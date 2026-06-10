unit UMBobbins;

interface

uses Classes, UMSchedContFunc, UGCustomList, SysUtils;

type
  TRecItmBobbin = record
    Job: TSchedID;
    QtyUsed: double;
    DtStart: TDateTime;
    DtEnd: TDateTime;
  end;
  PTRecItmBobbin = ^TRecItmBobbin;

  TBobbinObj = class(TObject)
    constructor CreateBobbin(DueDate: TDateTime; Qty: double);
    destructor Destroy; override;
  private
    m_StartQty: double;
    m_ActualQty: double;
    m_DueDate: TDateTime;
    m_LastAvailDate: TDateTime;
    m_LstItem: TMQMCustomList;  // List of PTRecItmBobbin (Info of job using bobbin)
    procedure RecalcData;
    function AddBalRecord(ID: TSchedId; Qty: double; dtStart, dtEnd: TDateTime): double;
  public
    procedure ClearBalanceForJob(ID: TSchedId);
    function IsBobbinUsed: boolean;
    function CheckJob(JobID: TSchedId): boolean;
    procedure AddBalIfBobbinIsAvail(OnlyCheck: boolean; JobID: TSchedId;
                         dtStartBal, dtEndBal: double; var QtySched: double;
                         var QtyBobbinRest: double; var LstOfJob: TStringList);
    property p_StartQty: double       read m_StartQty;
    property p_ActualQty: double      read m_ActualQty;
    property p_DueDate: TDateTime     read m_DueDate;
  end;

implementation

uses UMObjCont;

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//                       TBobbin
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

constructor TBobbinObj.CreateBobbin(DueDate: TDateTime; Qty: double);
begin
  inherited Create;
  m_DueDate := DueDate;
  m_LastAvailDate := DueDate;
  m_StartQty := Qty;
  m_ActualQty := Qty;
  m_LstItem := TMQMCustomList.Create;
end;

//----------------------------------------------------------------------------//

destructor TBobbinObj.Destroy;
var
  i : integer;
  Rec: PTRecItmBobbin;
begin
  for i := m_LstItem.p_count -1 downto 0 do
  begin
    Rec := m_LstItem.p_Item[i];
    m_LstItem.RemoveItem(Rec);
  end;

  m_LstItem.Free;
  inherited Destroy;
end;

//----------------------------------------------------------------------------//

procedure TBobbinObj.ClearBalanceForJob(ID: TSchedId);
var
  i : integer;
  RecBobbin : PTRecItmBobbin;
begin
  for i := m_LstItem.p_count-1 downto 0 do
  begin
    RecBobbin := (m_LstItem.p_Item[i]);
    if RecBobbin.Job = ID then
    begin
      m_LstItem.RemoveItem(RecBobbin);

      try
        RecBobbin.QtyUsed := 0;
      finally
      if Assigned(RecBobbin) then
      begin
        Dispose(RecBobbin);   // Deallocation
        RecBobbin := nil;     // Prevent double-dispose
      end;
      end;


      //Dispose(RecBobbin)
    end;
  end;

  RecalcData
end;

//----------------------------------------------------------------------------//

function TBobbinObj.CheckJob(JobID: TSchedId): boolean;
var
  i : integer;
  Rec: PTRecItmBobbin;
begin
  Result := false;
  for i := 0 to m_LstItem.p_count-1 do
  begin
    Rec := m_LstItem.p_Item[i];
    if Rec.Job = JobId then
    begin
      Result := true;
      exit;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TBobbinObj.AddBalIfBobbinIsAvail(OnlyCheck: boolean; JobID: TSchedId;
                         dtStartBal, dtEndBal: double; var QtySched: double;
                         var QtyBobbinRest: double; var LstOfJob: TStringList);
var
  i, z : integer;
  Rec: PTRecItmBobbin;
  QtyUsed, QtyReallySched: double;
  LastLstIdx : integer;
begin

  if dtStartBal < m_DueDate then exit;

  QtyUsed := 0;
  QtyReallySched := 0;
  QtyBobbinRest := m_ActualQty;
  if LstOfJob.Count > 0 then
    LastLstIdx := LstOfJob.Count
  else
    LastLstIdx := 0;

  for i := 0 to m_LstItem.p_count-1 do
  begin
    Rec := m_LstItem.p_Item[i];
    if dtStartBal < Rec.DtStart then
    begin
      if not OnlyCheck then
        LstOfJob.Add(IntToStr(Rec.Job))
    end else
      QtyUsed := QtyUsed + Rec.QtyUsed;
  end;

  if QtyUsed < m_StartQty then
  begin
    if (m_StartQty - QtyUsed - QtySched) < 0 then
    begin
      QtyBobbinRest := 0;
      QtyReallySched := m_StartQty - QtyUsed;
      QtySched := QtySched - QtyReallySched;
    end else
    begin
      QtyReallySched := QtySched;
      QtySched := 0;
    end;
  end;

  if (not OnlyCheck) and (QtyReallySched > 0) then
  begin
    for i := LastLstIdx to LstOfJob.Count -1 do
      for z := m_LstItem.p_count -1 downto 0 do
      begin
        Rec := m_LstItem.p_Item[z];
        if (Rec.Job = StrToInt(LstOfJob.Strings[i])) and
           (Rec.Job <> JobID) then
          m_LstItem.RemoveItem(Rec)
      end;
    AddBalRecord(JobID, QtyReallySched, dtStartBal, dtEndBal);
    QtyBobbinRest := m_ActualQty;
  end;

end;

//----------------------------------------------------------------------------//

function TBobbinObj.AddBalRecord(ID: TSchedId; Qty: double; dtStart, dtEnd: TDateTime): double;
var
  RecBobbin : PTRecItmBobbin;
begin
  New(RecBobbin);

  m_LstItem.AddItem(RecBobbin);
  RecBobbin.Job     := ID;
  RecBobbin.DtStart := dtStart;
  RecBobbin.DtEnd   := dtEnd;
  RecBobbin.QtyUsed := Qty;

  Result := 0;  // not used at the moment - fp

  RecalcData
end;

//----------------------------------------------------------------------------//

procedure TBobbinObj.RecalcData;
var
  i : integer;
  RecBobbin : PTRecItmBobbin;
begin
  m_LastAvailDate := m_DueDate;
  m_ActualQty := m_StartQty;
  for i := 0 to m_LstItem.p_count-1 do
  begin
    RecBobbin := m_LstItem.p_Item[i];
    m_ActualQty := m_ActualQty - RecBobbin.QtyUsed;
    if RecBobbin.DtEnd > m_LastAvailDate then
      m_LastAvailDate := RecBobbin.DtEnd;
  end;
end;

//----------------------------------------------------------------------------//

function TBobbinObj.IsBobbinUsed: boolean;
begin
  if m_LstItem.p_count > 0 then
    Result := true
  else
    Result := false
end;

//----------------------------------------------------------------------------//

end.
