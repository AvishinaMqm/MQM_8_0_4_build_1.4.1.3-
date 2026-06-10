unit UMDurObj;

interface

uses
  classes,
  UMPlanObj,
  UMPlan,
  UGBaseCal;

type
  CDurStatus = (CDUR_none, CDUR_new, CDUR_modi, CDUR_del);

  TMqmDurObj = class(TMqmPlanObj)
    constructor CreateDurObj(plan: TMqmPlan); virtual;
    destructor  Destroy; override;
  private
    m_offset: TDateTime;

  protected
    m_Start: TDateTime;
    m_dur  : Integer;
    m_durDouble  : double;
    m_SavedEnd: TDateTime;

    procedure SetStart(date: TDateTime); virtual; abstract;
    procedure SetEnd(date: TDateTime);   virtual; abstract;
    procedure SetDur(durMin: integer);   virtual; abstract;
    procedure SetDurDouble(durMin: double); virtual; abstract;
    function  GetStart: TDateTime;       virtual; abstract;
    function  GetEnd: TDateTime;         virtual; abstract;
    function  GetDur: integer;           virtual; abstract;
    function  GetDurDouble : double;    virtual; abstract;

  public
    m_status: CDurStatus;
    m_bkStart: TDateTime;
    m_bkDur  : Integer;
    m_bkDurDouble  : double;
//    procedure UpdateDurData; virtual; abstract;

    property p_start:            TDateTime  read GetStart      write SetStart;
    property p_dur:              integer    read GetDur        write SetDur;
    property p_durDouble:        double     read GetDurDouble  write SetDurDouble;
    property p_end:              TDateTime  read GetEnd        write SetEnd;

  end;

  TDurList = class
  private
    m_owner:  TObject;
    m_lst:    TList;
    m_sorted: boolean;

    function  GetSon(i: integer): TMqmDurObj;

  public

    property p_sons[i: integer]: TMqmDurObj  read GetSon; default;

    constructor Create(owner: TObject);
    destructor  Destroy; override;

    procedure DeSort;
    procedure SortList;
    procedure ClearList;

    function  Count: integer;
    function  Add(dObj: TMqmDurObj): integer;
    function  AddTail(dObj: TMqmDurObj): integer;
    function  DetachObject(dObj: TMqmDurObj): boolean;
    function  DetachPos(pos: integer): TMqmDurObj;
    function  FindCovering(startTm, endTm: TDateTime; skipObj: TMqmDurObj): integer;
    function  FindCoveringForSpot(Start : TDateTime ; skipObj: TMqmDurObj): integer;
    procedure FindObjsInSpot(startTm, endTm: TDateTime; var ObjList: TDurList);
    function  FindObjInSpots(startTm : TDateTime ; var StartTime : TDateTime; skipObj: TMqmDurObj; var OrigStart : TDateTime) : boolean;
    procedure FindFreeSpot(date: TDateTime; var startSlot, endSlot: TDateTime;
                           obj: TMqmDurObj);
    function  GetOwner: TObject;
    function  FindStartCover(ActiveDate: TDateTime; var StDate: TDateTime; RefObj: TMqmDurObj): boolean;
  end;

implementation


//----------------------------------------------------------------------------//
//  TDurList  ----------------------------------------------------------------//
//----------------------------------------------------------------------------//

constructor TDurList.Create(owner: TObject);
begin
  inherited Create;
  m_owner := owner;
  m_lst   := TList.Create
end;

//----------------------------------------------------------------------------//

destructor TDurList.Destroy;
begin
  m_lst.Free;
  inherited Destroy
end;

//----------------------------------------------------------------------------//

function TDurList.GetSon(i: integer): TMqmDurObj;
begin
  Assert((i >= 0) and (i < m_lst.Count));
  Result := TMqmDurObj(m_lst[i])
end;

//----------------------------------------------------------------------------//

function OrderGrowing(Item1, Item2: Pointer): integer;
var
  pd1, pd2: TMqmDurObj;
begin
  pd1 := TMqmDurObj(Item1);
  pd2 := TMqmDurObj(Item2);

  if      pd1.p_start = pd2.p_start then Result :=  0
  else if pd1.p_start < pd2.p_start then Result := -1
  else                                   Result :=  1
end;

//----------------------------------------------------------------------------//

procedure TDurList.ClearList;
begin
  m_lst.clear;
end;

//----------------------------------------------------------------------------//

function TDurList.Count: integer;
begin
  Result := m_lst.Count
end;

//----------------------------------------------------------------------------//

procedure TDurList.DeSort;
begin
  m_sorted := false
end;

//----------------------------------------------------------------------------//

procedure TDurList.SortList;
begin
  if not m_sorted then
  begin
    m_lst.Sort(OrderGrowing);
    m_sorted := true
  end
end;

//----------------------------------------------------------------------------//

function TDurList.Add(dObj: TMqmDurObj): integer;
var
  i: integer;
begin
  if not m_sorted then
    Result := AddTail(dObj)
  else
  begin
    i := 0;
    while (i < m_lst.Count) and (TMqmDurObj(m_lst[i]).p_start <= dObj.p_start) do
      inc(i);
    m_lst.Insert(i, dObj);
    Result := i
  end
end;

//----------------------------------------------------------------------------//

function TDurList.AddTail(dObj: TMqmDurObj): integer;
begin
  Result := m_lst.Add(dObj);
  m_sorted := false
end;

//----------------------------------------------------------------------------//

function TDurList.DetachObject(dObj: TMqmDurObj): boolean;
// returns false if the object to remove is not present in the list
// clears the father pointer of the detached object
var
  pos: integer;
begin
  Result := true;
  pos := m_lst.Remove(dObj);
  if pos = -1 then
    Result := false
  else
    dObj.p_Father := nil
end;

//----------------------------------------------------------------------------//

function TDurList.DetachPos(pos: integer): TMqmDurObj;
// returns the pointer of the object detached
// clears the father pointer of the detached object
begin
  Assert(Assigned(m_lst));
  Assert((pos >= 0) and (pos < m_lst.Count));
  Result := m_lst[pos];
  Assert(Assigned(result));
  m_lst.Delete(pos);
end;

//----------------------------------------------------------------------------//

function TDurList.FindCovering(startTm, endTm: TDateTime; skipObj: TMqmDurObj): integer;
var
  i:  integer;
  pd: TMqmDurObj;
begin
  Result := -1;
  Assert(Assigned(m_lst));

  SortList;

  for i := 0 to m_lst.Count-1 do
  begin
    pd := TMqmDurObj(m_lst[i]);
    if (pd <> skipObj) and
       (not ((pd.p_start >= endTm) or
             (pd.p_end   <= startTm))) then
    begin
      Result := i;
      exit
    end
  end
end;

//----------------------------------------------------------------------------//

function TDurList.FindCoveringForSpot(Start : TDateTime ; skipObj: TMqmDurObj): integer;
var
  i:  integer;
  pd: TMqmDurObj;
begin
  Result := -1;
  Assert(Assigned(m_lst));

  SortList;

  for i := 0 to m_lst.Count-1 do
  begin
    pd := TMqmDurObj(m_lst[i]);
    if (pd <> skipObj) and
       ((pd.p_start <= Start) and
             (pd.p_end >= Start)) then
    begin
      Result := i;
      exit
    end
  end
end;

//----------------------------------------------------------------------------//

procedure TDurList.FindObjsInSpot(startTm, endTm: TDateTime; var ObjList: TDurList);
var
  i:  integer;
  pd: TMqmDurObj;
begin
  Assert(Assigned(m_lst));
  SortList;

  for i := 0 to m_lst.Count-1 do
  begin
    pd := TMqmDurObj(m_lst[i]);
    if endTm <= pd.p_start then continue;
    if startTm >= pd.p_end then continue;    
//    if ((pd.p_start >= startTm) and (pd.p_start <= endTm))
//    or ((pd.p_end >= startTm) and (pd.p_end <= endTm))
//    or ((pd.p_start < startTm) and (pd.p_end > endTm)) then
      ObjList.Add(pd);
  end
end;

//----------------------------------------------------------------------------//

function TDurList.FindObjInSpots(startTm : TDateTime ; var StartTime : TDateTime ; skipObj: TMqmDurObj; var OrigStart : TDateTime) : boolean;
var
  i:  integer;
  pd: TMqmDurObj;
begin
  Result := false;
  Assert(Assigned(m_lst));
  SortList;

  for i := 0 to m_lst.Count-1 do  //for OrganizedallOcc avo to continue
  begin
    pd := TMqmDurObj(m_lst[i]);

    if  (pd <> skipObj) and((startTm > pd.p_start) and (startTm <= pd.p_End)) then
    begin
      Result := true;
      StartTime := pd.p_End;
      OrigStart := pd.p_start;
      break
    end;

  end


{  for i := 0 to m_lst.Count-1 do  for OrganizedallOcc
  begin
    pd := TMqmDurObj(m_lst[i]);
    if ((pd.p_end >= startTm) and (pd.p_end <= endTm))
    or ((pd.p_end >= endTm) and (pd.p_start <= startTm)) then
//    or ((pd.p_start < startTm) and (pd.p_end > endTm)) then
      ObjList.Add(pd);
  end }
end;

//----------------------------------------------------------------------------//

procedure TDurList.FindFreeSpot(date: TDateTime; var startSlot, endSlot: TDateTime;
                                obj: TMqmDurObj);
var
  pd: TMqmDurObj;
  i:  integer;
begin
  Assert(Assigned(m_lst));
  SortList;
  for i := 0 to m_lst.Count -1 do
  begin
    pd := TMqmDurObj(m_lst[i]);
    if pd <> obj then
    begin
      if (pd.p_end > 0) and (pd.p_end <= date) then
      begin
        if pd.p_end > startSlot then
          startSlot := pd.p_end;
      end;
      if pd.p_start > date then
      begin
        endSlot := pd.p_start;
        exit
      end
    end
  end
end;

//----------------------------------------------------------------------------//

function TDurList.GetOwner: TObject;
begin
  Result := m_owner
end;

//----------------------------------------------------------------------------//

function TDurList.FindStartCover(ActiveDate: TDateTime; var StDate: TDateTime; RefObj: TMqmDurObj): boolean;
var
  pd: TMqmDurObj;
  i:  integer;
begin
  Result := false;
  Assert(Assigned(m_lst));
  SortList;

  for i := m_lst.Count -1 downto 0 do
  begin
    pd := TMqmDurObj(m_lst[i]);
    if pd = RefObj then continue;

    if (pd.p_end <= ActiveDate) then
    begin
      Result := true;
      StDate := pd.p_end;
      exit;
    end
  end;
end;

//----------------------------------------------------------------------------//
//   TMqmDurObj  -------------------------------------------------------------//
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//

destructor TMqmDurObj.Destroy;
begin
  inherited destroy;
end;

//----------------------------------------------------------------------------//

constructor TMqmDurObj.CreateDurObj(plan: TMqmPlan);
begin
  inherited Create;
  m_status    := CDUR_none;
  m_plan      := plan;
  m_offset    := 0;
  m_ObjProp   := []
end;

//----------------------------------------------------------------------------//
end.
