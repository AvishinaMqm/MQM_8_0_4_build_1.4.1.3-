unit UMCompatSrv;

interface

uses
  classes, UMCompat;

type
  TMtxPrtDataProc = procedure (sl: TStringList; str, cls: string; empty: integer; pId: TPropID; obj: TObject);

  TPropVal = class(TObject)
    m_val: variant;
  end;

  TProperties = class
  private
    m_list: TList;
    m_ListInstanceCounter : TList;
    function GetNumProp: integer;
    function GetNumPropInstanceCounter: integer;
  public
    constructor Create;
    destructor  Destroy; override;

    procedure OrganizeProperties;
    function AddProperty(code, RscCode, val: string): boolean;
    function AddPropertyOnly(code, RscCode, val: string): boolean;
    function GetProperty(ndx: integer; var prop: TPropID; var RscCode: string): variant;
    function GetNextROProp(ndx: integer): Integer;
    function GetNextOOProp(ndx: integer): Integer;
    function GetNextAffectSameGroupProp(ndx: integer): Integer;
    function GetPropertyInstanceCounterVal(ndx: integer) : Integer;
    procedure GetPropertyInstanceCounter(ndx: integer; var InstanceCounterProp : string; var PlaceInMainList : integer);
    procedure CleanPropertyInstanceCounter(ndx: integer);
    function SearchForPropertyInstanceCounterVal(InstanceCounterProp : string) : Integer;
    procedure SetPropertyInstanceCounterVal(ndx: integer; value : Integer);
    function AddPropertyToGroup(code, RscCode, val: string): boolean;
    function GetPureValProp(ndx: integer; var prop: TPropID; var RscCode: string): string; // avi
    function GetValforCode(code, RscCode: string; IndexToTry : Integer; var val: variant): boolean;
    function GetValforProp(prop: TPropID; var val: variant): boolean;
    function SetValforProp(prop: TPropID; val: variant): boolean;
    function SetValforCode(propCode: string; val: variant): boolean;
    function SetValforCodeByIndex(val: variant; Index : integer): boolean;
    function GetValforCodeByIndex(var val: string; Index : integer): boolean;
    function DeletFromList(propCode: string) : boolean;
    procedure DeletAllNonPlannerProperties(BuildPropertyPointrs : boolean);
    function HasProperty(prop: TPropID): boolean;
    function AddPlannerProperty(code : string; val: string): boolean;
    Procedure BuildPropertyPointers;
    procedure Clear;
    property p_PropCount: integer read GetNumProp;
    property P_PropCountInstanceCounter : integer read GetNumPropInstanceCounter;

  end;

  TPropRes = class
  public
    destructor  Destroy; override;
  public
    m_val:         variant;
    m_addResToOcc: string;
    m_dfltResOcc:  integer;
    m_dfltOccOcc:  integer;
    m_dfltSameGrp: integer;
    m_ValForGrp:   integer;
  end;

  TOrigMatrix = class
  private
    m_list: TList;
  public
    m_mtx:  TCompatMatrix;

    constructor Create;
    destructor  Destroy; override;

    procedure PrintHdrAsHtml(sl: TStringList; const colHdrs: array of const);
    procedure PrintDataAsHtml(sl: TStringList; clsEven, clsOdd: string; dataProc: TMtxPrtDataProc); virtual; abstract;
  end;

  TOneDmatrix = class(TOrigMatrix)
    destructor  Destroy; override;
    function    GetObject(prop: TPropID): TObject;
    procedure   AddObject(prop: TPropID; obj: TObject);
    function    GetLev1Count: integer;
    function    GetLev1Obj(i1: integer; var pId: TPropID): TObject;

    procedure PrintDataAsHtml(sl: TStringList; clsEven, clsOdd: string; dataProc: TMtxPrtDataProc); override;
  end;

  TTwoDmatrix = class(TOrigMatrix)
    destructor  Destroy; override;
    function    GetObject(prop: TPropID; key1: string): TObject;
    procedure   AddObject(prop: TPropID; key1: string; obj: TObject);
    function    GetLev1Count: integer;
    function    GetLev1Key(i1: integer): string;
    function    GetLev2Count(i1: integer): integer;
    function    GetLev2Obj(i1, i2: integer; var pId: TPropID): TObject;

    procedure PrintDataAsHtml(sl: TStringList; clsEven, clsOdd: string; dataProc: TMtxPrtDataProc); override;
  end;

  TThreeDmatrix = class(TOrigMatrix)
    destructor  Destroy; override;
    function    GetObject(prop: TPropID; key1, key2: string): TObject;
    procedure   AddObject(prop: TPropID; key1, key2: string; obj: TObject);
    function    GetLev1Count: integer;
    function    GetLev1Key(i1: integer): string;
    function    GetLev2Count(i1: integer): integer;
    function    GetLev2Key(i1, i2: integer): string;
    function    GetLev3Count(i1, i2: integer): integer;
    function    GetLev3Obj(i1, i2, i3: integer; var pId: TPropID): TObject;

    procedure PrintDataAsHtml(sl: TStringList; clsEven, clsOdd: string; dataProc: TMtxPrtDataProc); override;
  end;
{
  TFourDmatrix = class(TOrigMatrix)
    function    GetObject(prop: TPropID; key1, key2, key3: string): TObject;
    procedure   AddObject(prop: TPropID; key1, key2, key3: string; obj: TObject);
    function    GetLev1Count: integer;
    function    GetLev1Key(i1: integer): string;
    function    GetLev2Count(i1: integer): integer;
    function    GetLev2Key(i1, i2: integer): string;
    function    GetLev3Count(i1, i2: integer): integer;
    function    GetLev3Key(i1, i2, i3: integer): string;
    function    GetLev4Count(i1, i2, i3: integer): integer;
    function    GetLev4Obj(i1, i2, i3, i4: integer; var pId: TPropID): TObject;

    procedure PrintDataAsHtml(sl: TStringList; clsEven, clsOdd: string; dataProc: TMtxPrtDataProc); override;
  end;
}
  procedure CreateMatrix(var origMtx: TOrigMatrix; mtx: TCompatMatrix);

implementation

uses
  SysUtils,
  Vcl.Forms,
  Dialogs;

type

  TPropRec = record
    prop: TPropID;
    RscCode: string;
    val:  variant;
    PureVal : string;
    NextOOProp : Integer;
    NextROProp : Integer;
    NextAffectSameGroup : Integer;
  end;
  PTPropRec = ^TPropRec;

  TPropInstanceCounterRec = record
    InstanceCounterPropId : TPropID;
    InstanceCounterPropCode : string;
    PlaceInMainList : integer;
  end;
  PTPropInstanceCounterRec = ^TPropInstanceCounterRec;

  TPropMtxObj = class
    m_prop: TPropID;
    m_obj:  TObject;

    constructor Create;
    destructor Destroy; override;
  end;

  TCodedListObj = class
    destructor  Destroy; override;
  public
    m_code: string;
    m_obj:  TObject;
  end;

  TCodedList = class
    constructor Create;
    destructor  Destroy; override;
    function    GetObject(code: string): TObject;
    procedure   AddObject(code: string; obj: TObject);
  private
    m_list:     TList;
  end;

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

function SortByPropCode(Item1, Item2: Pointer): integer;
var
  propRec1, propRec2 : PTPropRec;
  PropCode1, PropCode2 : string;
begin
  propRec1 := PTPropRec(Item1);
  propRec2 := PTPropRec(Item2);

  PropCode1 := GetPropCodeFromID(propRec1.prop);
  PropCode2 := GetPropCodeFromID(propRec2.prop);

  if PropCode1 < PropCode2 then
    Result := -1
  else if PropCode1 = PropCode2 then
  begin
    if propRec1.RscCode < propRec2.RscCode then
      Result := -1
    else if propRec1.RscCode = propRec2.RscCode then
      Result := 0
    else
      Result := 1
  end
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

constructor TPropMtxObj.Create;
begin
  m_obj := nil;
end;

//----------------------------------------------------------------------------//

destructor TPropMtxObj.Destroy;
begin
  m_obj.Free;
  m_obj := nil;

  inherited Destroy
end;

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

constructor TCodedList.Create;
begin
  m_list := TList.Create;
end;

//----------------------------------------------------------------------------//

destructor TCodedList.Destroy;
var
  i: integer;
begin
  for i := 0 to m_list.Count-1 do
    TCodedListObj(m_list[i]).Free;
  m_list.Free;
  m_list := nil;

  inherited Destroy
end;

//----------------------------------------------------------------------------//

function TCodedList.GetObject(code: string): TObject;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to m_list.Count-1 do
    if TCodedListObj(m_list[i]).m_code = code then
    begin
      Result := TCodedListObj(m_list[i]).m_obj;
      exit
    end
end;

//----------------------------------------------------------------------------//

procedure TCodedList.AddObject(code: string; obj: TObject);
var
  tcObj: TCodedListObj;
begin
  tcObj := TCodedListObj.Create;
  tcObj.m_code := code;
  tcObj.m_obj := obj;

  m_list.Add(tcObj)
end;

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

constructor TProperties.Create;
begin
  inherited Create;
  m_list := TList.Create;
  m_ListInstanceCounter := TList.Create
end;

//----------------------------------------------------------------------------//

destructor TProperties.Destroy;
var
  i: integer;
begin
  for i := 0 to m_list.Count-1 do
    Dispose(PTPropRec(m_list[i]));

  for i := 0 to m_ListInstanceCounter.Count-1 do
    Dispose(PTPropInstanceCounterRec(m_ListInstanceCounter[i]));

  m_list.Free;
  m_ListInstanceCounter.Free;
  inherited Destroy
end;

//----------------------------------------------------------------------------//

procedure TProperties.Clear;
begin
  m_list.Clear
end;

//----------------------------------------------------------------------------//

procedure TProperties.OrganizeProperties;
begin
  m_list.Sort(SortByPropCode);
  BuildPropertyPointers;
end;

//----------------------------------------------------------------------------//

function TProperties.AddProperty(code, RscCode, val: string): boolean;
var
  prop: TPropID;
  tmpVal:  variant;
  propRec: ^TPropRec;
  i : integer;
begin

  prop := DecodeProp(code, val, tmpVal);

  if not Assigned(prop) then
    Result := false
  else
  begin
    New(propRec);
    propRec.prop := prop;
    propRec.RscCode := RscCode;
    propRec.val := tmpVal;
    propRec.PureVal := Trim(val);    // avi
    i := m_list.count;
    try
      m_list.Add(propRec);
    except
      showmessage(inttostr(i));
      showmessage(inttostr(m_list.count));
    end;
    Result := true
  end;

  OrganizeProperties;

{  prop := DecodeProp(code, val, tmpVal);

  if not Assigned(prop) then
  begin
    Result := false;
    exit;
  end;

  Index := 0;
  while True do
  begin
    if m_list.count = Index then break;
    PropCode := GetPropCodeFromID(PTPropRec(m_list[Index]).prop);
    if PropCode > Code then break;
    if (PropCode = Code) and (PTPropRec(m_list[Index]).RscCode > RscCode) then break;
    Index := Index + 1;
  end;

  begin
    New(propRec);
    propRec.prop := prop;
    propRec.RscCode := RscCode;
    propRec.val := tmpVal;
    propRec.PureVal := Trim(val);    // avi
    i := m_list.count;
    try
      m_list.Insert(Index, propRec);
    except
      showmessage(inttostr(i));
      showmessage(inttostr(m_list.count));
    end;
    Result := true
  end   }
end;

//----------------------------------------------------------------------------//

function TProperties.AddPropertyOnly(code, RscCode, val: string): boolean;
var
  prop: TPropID;
  tmpVal : variant;
  propRec: ^TPropRec;
  i : integer;
begin

  prop := DecodeProp(code, val, tmpVal);

  if not Assigned(prop) then
    Result := false
  else
  begin
    New(propRec);
    propRec.prop := prop;
    propRec.RscCode := RscCode;
    propRec.val := tmpVal;
    propRec.PureVal := Trim(val);    // avi
    i := m_list.count;
    try
      m_list.Add(propRec);
    except
      showmessage(inttostr(i));
      showmessage(inttostr(m_list.count));
    end;
    Result := true
  end;
end;

//----------------------------------------------------------------------------//

function TProperties.GetNumProp: integer;
begin
  Result := m_list.Count
end;

//----------------------------------------------------------------------------//
function TProperties.GetNumPropInstanceCounter : integer;
begin
  Result := m_ListInstanceCounter.Count
end;

//----------------------------------------------------------------------------//

function TProperties.GetProperty(ndx: integer; var prop: TPropID; var RscCode: string): variant;
var
  propRec: ^TPropRec;
begin
  Assert(ndx < m_list.Count);
  propRec := m_list[ndx];
  prop    := propRec.prop;
  RscCode := propRec.RscCode;
  Result  := propRec.val
end;

//----------------------------------------------------------------------------//

function TProperties.GetNextROProp(ndx: integer): Integer;
var
  propRec: ^TPropRec;
begin
  Assert(ndx < m_list.Count);
  propRec := m_list[ndx];
  Result  := propRec.NextROProp;
end;

//----------------------------------------------------------------------------//

function TProperties.GetNextOOProp(ndx: integer): Integer;
var
  propRec: ^TPropRec;
begin
  Assert(ndx < m_list.Count);
  propRec := m_list[ndx];
  Result  := propRec.NextOOProp;
end;

//----------------------------------------------------------------------------//

function TProperties.GetNextAffectSameGroupProp(ndx: integer): Integer;
var
  propRec: ^TPropRec;
begin
  Assert(ndx < m_list.Count);
  propRec := m_list[ndx];
  Result  := propRec.NextAffectSameGroup;
end;

//----------------------------------------------------------------------------//

function TProperties.GetPropertyInstanceCounterVal(ndx: integer) : Integer;
var
  PropInstanceCounterRec : PTPropInstanceCounterRec;
  propRec: PTPropRec;
begin
  Assert(ndx < m_ListInstanceCounter.Count);
  PropInstanceCounterRec := m_ListInstanceCounter[ndx];
  propRec := PTPropRec(m_list[PropInstanceCounterRec.PlaceInMainList]);
  Result := propRec.val
end;

//----------------------------------------------------------------------------//

procedure TProperties.GetPropertyInstanceCounter(ndx: integer; var InstanceCounterProp : string; var PlaceInMainList : integer);
var
  PropInstanceCounterRec : PTPropInstanceCounterRec;
//  propRec: PTPropRec;
begin
  Assert(ndx < m_ListInstanceCounter.Count);
  PropInstanceCounterRec := m_ListInstanceCounter[ndx];
  InstanceCounterProp := PropInstanceCounterRec.InstanceCounterPropCode;
//  propRec := PTPropRec(m_list[PropInstanceCounterRec.PlaceInMainList]);
  PlaceInMainList := PropInstanceCounterRec.PlaceInMainList;
end;

//----------------------------------------------------------------------------//

procedure TProperties.CleanPropertyInstanceCounter(ndx: integer);
var
  PropInstanceCounterRec : PTPropInstanceCounterRec;
  propRec: PTPropRec;
begin
  Assert(ndx < m_ListInstanceCounter.Count);
  PropInstanceCounterRec := m_ListInstanceCounter[ndx];
  propRec := PTPropRec(m_list[PropInstanceCounterRec.PlaceInMainList]);
  propRec.val := 0;
end;

//----------------------------------------------------------------------------//

function TProperties.SearchForPropertyInstanceCounterVal(InstanceCounterProp : string) : Integer;
var
  I : Integer;
  PropInstanceCounterRec : PTPropInstanceCounterRec;
begin
  Result := -1;
  for I := 0 to m_ListInstanceCounter.Count - 1 do
  begin
    PropInstanceCounterRec := m_ListInstanceCounter[I];
    if PropInstanceCounterRec.InstanceCounterPropCode <> InstanceCounterProp then continue;
    result := PropInstanceCounterRec.PlaceInMainList;
    break
  end;
end;

//----------------------------------------------------------------------------//

procedure TProperties.SetPropertyInstanceCounterVal(ndx: integer; value : Integer);
var
  propRec: PTPropRec;
begin
  if ndx >= m_list.Count then exit;
  if ndx < 0 then exit;
  propRec := PTPropRec(m_list[ndx]);
  propRec.val := value
end;

//----------------------------------------------------------------------------//

function TProperties.AddPropertyToGroup(code, RscCode, val: string): boolean;
var
  prop:    TPropID;
  propRec: ^TPropRec;
  i: integer;
  Passval : variant;
//  Index : Integer;
//  PropCode : String;
begin

  prop := DecodeProp(code, '', Passval);

  if not Assigned(prop) then
    Result := false
  else
  begin
    New(propRec);
    propRec.prop := prop;
    propRec.RscCode := RscCode;
    propRec.val := Val;
    i := m_list.count;
    try
      m_list.Add(propRec);
    except
      showmessage(inttostr(i));
      showmessage(inttostr(m_list.count));
    end;
    Result := true
  end;

  m_list.Sort(SortByPropCode);
  BuildPropertyPointers;

  {prop := DecodeProp(code, '', Passval);

  if not Assigned(prop) then
  begin
    Result := false;
    exit;
  end;

  Index := 0;
  while True do
  begin
    if m_list.count = Index then break;
    PropCode := GetPropCodeFromID(PTPropRec(m_list[Index]).prop);
    if PropCode > Code then break;
    if (PropCode = Code) and (PTPropRec(m_list[Index]).RscCode > RscCode) then break;
    Index := Index + 1;
  end;

  begin
    New(propRec);
    propRec.prop := prop;
    propRec.RscCode := RscCode;
    propRec.val := Val;
    i := m_list.count;
    try
//      m_list.Add(propRec);
      m_list.Insert(Index, propRec);
    except
      showmessage(inttostr(i));
      showmessage(inttostr(m_list.count));
    end;
    Result := true
  end  }

end;

//----------------------------------------------------------------------------//
procedure TProperties.BuildPropertyPointers;
var
  i, J : integer;
  mtx:    TCompatMatrix;
  tpLink: TCompatTopoLink;
  IndexOOToUpdate, IndexROToUpdate, IndexSameGroupToUpdate : Integer;
  PropInstanceCounterRec : PTPropInstanceCounterRec;
  InstanceCounterPropCode, PointToPropCode, PointToPropValue : string;
  InstanceCounterPropId : TPropId;
  PlaceInMainList : Integer;
  PropAffectsSameGroup : boolean;
begin

  IndexROToUpdate := 0;
  IndexOOToUpdate := 0;
  IndexSameGroupToUpdate := 0;

  for i := 0 to m_List.Count - 1 do
  begin
    if IsInstanceCounter(PTPropRec(m_list[i]).prop) then
    begin
      InstanceCounterPropId := PTPropRec(m_list[i]).prop;
      InstanceCounterPropCode := GetPropCodeFromID(PTPropRec(m_list[i]).prop);
      PlaceInMainList := I;
      PointToPropCode := GetPropInstanceCounterCode(InstanceCounterPropId);
      PointToPropValue := GetPropInstanceCounterValue(InstanceCounterPropId);
      for J := 0 to m_List.Count - 1 do
      begin
      //  Application.ProcessMessages;
        if (GetPropCodeFromID(PTPropRec(m_list[j]).prop) <> PointToPropCode) then continue;
        if (PTPropRec(m_list[j]).val <> PointToPropValue) then continue;
        New(PropInstanceCounterRec);
        PropInstanceCounterRec.InstanceCounterPropId   := InstanceCounterPropId;
        PropInstanceCounterRec.InstanceCounterPropCode := InstanceCounterPropCode;
        PropInstanceCounterRec.PlaceInMainList := PlaceInMainList;
        m_ListInstanceCounter.Add(PropInstanceCounterRec);
        break
      end;
    end;

    PTPropRec(m_list[i]).NextROProp := -1;
    GetPropCoordForRtoOcomp(PTPropRec(m_list[i]).prop, tpLink, mtx);
    if (tpLink <> CTL_none) and (i > 0) then
    begin
      PTPropRec(m_list[IndexROToUpdate]).NextROProp := i;
      IndexROToUpdate := i;
    end;

    GetPropCoordForOtoOcomp(PTPropRec(m_list[i]).prop, tpLink, mtx);
    PTPropRec(m_list[i]).NextOOProp := -1;
    if (tpLink <> CTL_none) and (i > 0) then
    begin
      PTPropRec(m_list[IndexOOToUpdate]).NextOOProp := i;
      IndexOOToUpdate := i;
    end;

    PropAffectsSameGroup := IsPropAffectSameGroupFlag(PTPropRec(m_list[i]).prop);
    PTPropRec(m_list[i]).NextAffectSameGroup := -1;
    if PropAffectsSameGroup and (i > 0) then
    begin
      PTPropRec(m_list[IndexSameGroupToUpdate]).NextAffectSameGroup := i;
      IndexSameGroupToUpdate := i;
    end;

  end;

end;

//----------------------------------------------------------------------------//

function TProperties.GetPureValProp(ndx: integer; var prop: TPropID; var RscCode: string): string; // avi
var
  propRec: ^TPropRec;
begin
  Assert(ndx < m_list.Count);
  propRec := m_list[ndx];
  prop    := propRec.prop;
  RscCode := propRec.RscCode;
  Result :=  propRec.PureVal;
end;

//----------------------------------------------------------------------------//

function TProperties.GetValforCode(code, RscCode: string; IndexToTry : Integer; var val: variant): boolean;
var
  i: integer;
  Multiplier, SaveMultiplier, NumberOfEntries : integer;
  PropertyWithAnyResFound : boolean;
  RscCodeTmp : String;
begin
  Result := false;

  NumberOfEntries := m_list.Count;
  if NumberOfEntries = 0 then exit;

  while true do
  begin
    if (IndexToTry < 0) then break;
    if (IndexToTry > (NumberOfEntries - 1)) then break;
    if (GetPropCodeFromID(PTPropRec(m_list[IndexToTry]).prop) <> code) then break;

    RscCodeTmp := PTPropRec(m_list[IndexToTry]).RscCode;
    if (RscCodeTmp <> '') and (RscCode <> RscCodeTmp) then break;

    if (RscCodeTmp = '')
    and ((IndexToTry + 1) < NumberOfEntries)
    and (GetPropCodeFromID(PTPropRec(m_list[IndexToTry + 1]).prop) = code) then break;

    val := PTPropRec(m_list[IndexToTry]).val;
    Result := true;
    Exit;
  end;

  if NumberOfEntries > 16 then // Save some performance not always to sdtart from 1
    Multiplier := 32
  else
    Multiplier := 1;

  while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
  SaveMultiplier := Multiplier;
  i := Multiplier - 1;
  PropertyWithAnyResFound := false;

  while (Multiplier > 0) do
  begin

    if  (i < NumberOfEntries) and (GetPropCodeFromID(PTPropRec(m_list[i]).prop) = code) then
    begin
       if  (PTPropRec(m_list[i]).RscCode = '') then
       begin
          val := PTPropRec(m_list[i]).val;
          Result := true;
          if ((i + 1) < NumberOfEntries) and
             (GetPropCodeFromID(PTPropRec(m_list[i+1]).prop) = code) then
               PropertyWithAnyResFound := true;
          break
       end
       else
       begin
         PropertyWithAnyResFound := true;
       end;
    end;

    Multiplier := trunc(Multiplier / 2);

    if (i < NumberOfEntries) and (GetPropCodeFromID(PTPropRec(m_list[i]).prop) < code) then
       i := i + Multiplier
    else
      i := i - Multiplier;

  end;

  if (RscCode = '') or (not PropertyWithAnyResFound) then exit;

  Multiplier := SaveMultiplier;
  i := Multiplier - 1;

  while (Multiplier > 0) do
  begin

    if  (i < NumberOfEntries) and (GetPropCodeFromID(PTPropRec(m_list[i]).prop) = code) then
    begin
       if  (PTPropRec(m_list[i]).RscCode = RscCode) then
       begin
          val := PTPropRec(m_list[i]).val;
          Result := true;
          break;
       end;
    end;

    Multiplier := trunc(Multiplier / 2);

    if ((i < NumberOfEntries) and (GetPropCodeFromID(PTPropRec(m_list[i]).prop) < code)) or
       ((i < NumberOfEntries) and (GetPropCodeFromID(PTPropRec(m_list[i]).prop) = code) and
        (PTPropRec(m_list[i]).RscCode < RscCode)) then
       i := i + Multiplier
    else
      i := i - Multiplier;

  end;

end;

//----------------------------------------------------------------------------//

function TProperties.GetValforProp(prop: TPropID; var val: variant): boolean;
var
  i: integer;
begin
  Result := false;
  for i := 0 to m_list.Count-1 do
    if PTPropRec(m_list[i]).prop = prop then
    begin
      val := PTPropRec(m_list[i]).val;
      Result := true;
      exit
    end
end;

//----------------------------------------------------------------------------//

function TProperties.SetValforProp(prop: TPropID; val: variant): boolean;
var
  i: integer;
begin
  Result := false;
  for i := 0 to m_list.Count-1 do
    if PTPropRec(m_list[i]).prop = prop then
    begin
      PTPropRec(m_list[i]).val := val;
      Result := true;
      exit
    end
end;

//----------------------------------------------------------------------------//

function TProperties.SetValforCode(propCode: string; val: variant): boolean;
var
  i: integer;
begin
  Result := false;
  for i := 0 to m_list.Count-1 do
    if (GetPropCodeFromID(PTPropRec(m_list[i]).prop) = propCode) then
    begin
      PTPropRec(m_list[i]).val := val;
      Result := true;
      exit
    end
end;

//----------------------------------------------------------------------------//

function TProperties.SetValforCodeByIndex(val: variant; Index : integer): boolean;
begin
  PTPropRec(m_list[Index]).val := val;
  Result := true;
end;

//----------------------------------------------------------------------------//

function TProperties.GetValforCodeByIndex(var val: string; Index : integer): boolean;
begin
  val := PTPropRec(m_list[Index]).val;
  Result := true;
end;

//----------------------------------------------------------------------------//

procedure TProperties.DeletAllNonPlannerProperties(BuildPropertyPointrs : boolean);
var
  i: integer;
begin
  for i := m_list.Count-1 downto 0 do
  begin
    if not IsPropPlanner(PTPropRec(m_list[i]).prop) then
    begin
      dispose(PTPropRec(m_list[i]));
      m_list.Delete(I);
    end;
  end;
  if BuildPropertyPointrs then
    BuildPropertyPointers;
end;

//----------------------------------------------------------------------------//

function TProperties.DeletFromList(propCode: string) : boolean;
var
  i: integer;
begin
  Result := false;
  for i := 0 to m_list.Count-1 do
  begin
    if (GetPropCodeFromID(PTPropRec(m_list[i]).prop) = propCode) then
    begin
      dispose(PTPropRec(m_list[i]));
      m_list.Delete(I);
      Result := true;
      BuildPropertyPointers;
      exit;
    end;
  end;
end;

//----------------------------------------------------------------------------//

function TProperties.HasProperty(prop: TPropID): boolean;
var
  i: integer;
begin
  Result := false;
  for i := 0 to m_list.Count-1 do
    if PTPropRec(m_list[i]).prop = prop then
    begin
      Result := true;
      exit
    end
end;

//----------------------------------------------------------------------------//

function TProperties.AddPlannerProperty(code : string; val: string): boolean;
var
  prop: TPropID;
  propRec: ^TPropRec;
  i: integer;
begin
  prop := GetIdFromCode(code);

  if not Assigned(prop) then
    Result := false
  else
  begin
    New(propRec);
    propRec.prop := prop;
    propRec.val := Val;
    propRec.PureVal := Trim(val);
    i := m_list.count;
    try
      m_list.Add(propRec);
    except
      showmessage(inttostr(i));
      showmessage(inttostr(m_list.count));
    end;
    Result := true
  end;
  m_list.Sort(SortByPropCode);
  BuildPropertyPointers;
end;

//----------------------------------------------------------------------------//

constructor TOrigMatrix.Create;
begin
  m_mtx  := CMX_CODE;
  m_list := TList.Create
end;

//----------------------------------------------------------------------------//

destructor TOrigMatrix.Destroy;
var
  i: integer;
begin
  for i := 0 to m_list.Count-1 do
    TCodedListObj(m_list[i]).Free;
  m_list.Free;
  m_list := nil;
  inherited Destroy
end;

//----------------------------------------------------------------------------//

procedure TOrigMatrix.PrintHdrAsHtml(sl: TStringList; const colHdrs: array of const);
const
  fmt = '<TR><TH>Code</TH><TH>Description</TH>';
var
  str: string;
  i:   integer;
begin
  str := fmt;
  for i := Low(colHdrs) to High(colHdrs) do
    str := str + '<TH>' + string(colHdrs[i].VPChar) + '</TH>';
  str := str + '</TR>';
  sl.Add(str)
end;

//----------------------------------------------------------------------------//

destructor TOneDmatrix.Destroy;
begin
  Inherited destroy;
end;

//----------------------------------------------------------------------------//

function TOneDmatrix.GetObject(prop: TPropID): TObject;
var
  i, Multiplier, NumberOfEntries : integer;
  PropCode, PropCodeInTable : String;
begin
  Result := nil;

  NumberOfEntries := m_list.Count;
  if NumberOfEntries = 0 then exit;

  Multiplier := 1;
  while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    i := Multiplier - 1;

  PropCode := GetPropCodeFromID(prop);
  while (Multiplier > 0) do
  begin

    if  (i < NumberOfEntries) then
    begin
      PropCodeInTable := GetPropCodeFromID(TPropMtxObj(m_list[i]).m_prop);
      if (PropCodeInTable = PropCode) then
      begin
        Result := TPropMtxObj(m_list[i]).m_obj;
        break;
      end;
    end;

    Multiplier := trunc(Multiplier / 2);

    if  (i < NumberOfEntries) and (PropCodeInTable < PropCode) then
      i := i + Multiplier
    else
      i := i - Multiplier;
  end;

end;

//----------------------------------------------------------------------------//

procedure TOneDmatrix.AddObject(prop: TPropID; obj: TObject);
var
  mtxObj: TPropMtxObj;
  i: integer;
  PropCode : String;
begin
  mtxObj := TPropMtxObj.Create;
  mtxObj.m_prop := prop;
  mtxObj.m_obj  := obj;

  PropCode := GetPropCodeFromID(prop);
  for i := 0 to m_list.Count-1 do
  begin
    if GetPropCodeFromID(TPropMtxObj(m_list[i]).m_prop) > PropCode then
      break;
  end;

  m_list.insert(i, mtxObj);
end;

//----------------------------------------------------------------------------//

function TOneDmatrix.GetLev1Count: integer;
begin
  Result := m_list.Count
end;

//----------------------------------------------------------------------------//

function TOneDmatrix.GetLev1Obj(i1: integer; var pId: TPropID): TObject;
var
  mtxObj: TPropMtxObj;
begin
  mtxObj := TPropMtxObj(m_list[i1]);
  pId := mtxObj.m_prop;
  Result := mtxObj.m_obj
end;

//----------------------------------------------------------------------------//

procedure TOneDmatrix.PrintDataAsHtml(sl: TStringList; clsEven, clsOdd: string; dataProc: TMtxPrtDataProc);
const
  fmt = '<TR class="%s"><TD>%s</TD><TD>%s</TD>';
var
  i1:     integer;
  mtxObj: TPropMtxObj;
  str:    string;
  pId:    TPropId;
  cls:    string;
begin
  Assert(Assigned(dataProc));
  for i1 := 0 to m_list.Count-1 do
  begin
    mtxObj := TPropMtxObj(m_list[i1]);
    pId := mtxObj.m_prop;
    if (i1 mod 2) = 0 then
      cls := clsEven
    else
      cls := clsOdd;

    FmtStr(str, fmt, [cls, GetPropCodeFromID(pId), GetPropDescr(pId)]);
    dataProc(sl, str, cls, 2, pId, mtxObj.m_Obj);
  end
end;

//----------------------------------------------------------------------------//

function TTwoDmatrix.GetObject(prop: TPropID; key1: string): TObject;
var
  i:     integer;
  cdObj: TCodedListObj;
begin
  Result := nil;
  for i := 0 to m_list.Count-1 do
  begin
    cdObj := TCodedListObj(m_list[i]);
    if cdObj.m_code = key1 then
    begin
      Result := TOneDmatrix(cdObj.m_obj).GetObject(prop);
      exit
    end
  end
end;

//----------------------------------------------------------------------------//

procedure TTwoDmatrix.AddObject(prop: TPropID; key1: string; obj: TObject);
var
  i:     integer;
  cdObj: TCodedListObj;
begin
  cdObj := nil;
  for i := 0 to m_list.Count-1 do
    if TCodedListObj(m_list[i]).m_code = key1 then
    begin
      cdObj := TCodedListObj(m_list[i]);
      break
    end;

  if not Assigned(cdObj) then
  begin
    cdObj := TCodedListObj.Create;
    cdObj.m_code := key1;
    cdObj.m_obj  := TOneDmatrix.Create;
    m_list.Add(cdObj);
  end;

  TOneDmatrix(cdObj.m_obj).AddObject(prop, obj)
end;

//----------------------------------------------------------------------------//

destructor TTwoDmatrix.Destroy;
begin
  inherited destroy
end;

//----------------------------------------------------------------------------//

function TTwoDmatrix.GetLev1Count: integer;
begin
  Result := m_list.Count
end;

//----------------------------------------------------------------------------//

function TTwoDmatrix.GetLev1Key(i1: integer): string;
var
  cdObj: TCodedListObj;
begin
  cdObj := TCodedListObj(m_list[i1]);
  Result := cdObj.m_code
end;

//----------------------------------------------------------------------------//

function TTwoDmatrix.GetLev2Count(i1: integer): integer;
var
  cdObj: TCodedListObj;
begin
  cdObj := TCodedListObj(m_list[i1]);
  Result := TOneDmatrix(cdObj.m_obj).GetLev1Count
end;

//----------------------------------------------------------------------------//

function TTwoDmatrix.GetLev2Obj(i1, i2: integer; var pId: TPropID): TObject;
var
  cdObj: TCodedListObj;
begin
  cdObj := TCodedListObj(m_list[i1]);
  Result := TOneDmatrix(cdObj.m_obj).GetLev1Obj(i2, pId)
end;

//----------------------------------------------------------------------------//

procedure TTwoDmatrix.PrintDataAsHtml(sl: TStringList; clsEven, clsOdd: string; dataProc: TMtxPrtDataProc);
const
  fmt = '<TR class="%s"><TD>%s</TD><TD>%s</TD><TD>%s</TD>';
var
  i1, i2: integer;
  obj:    TObject;
  str:    string;
  pId:    TPropId;
  cls:    string;
begin
  Assert(Assigned(dataProc));
  cls := clsEven;
  for i1 := 0 to GetLev1Count-1 do
    for i2 := 0 to GetLev2Count(i1)-1 do
    begin
      obj := GetLev2Obj(i1, i2, pId);
      if cls = clsEven then
        cls := clsOdd
      else
        cls := clsEven;

      FmtStr(str, fmt, [cls, GetPropCodeFromID(pId), GetPropDescr(pId), GetLev1Key(i1)]);
      dataProc(sl, str, cls, 3, pId, obj);
    end
end;

//----------------------------------------------------------------------------//

function TThreeDmatrix.GetObject(prop: TPropID; key1, key2: string): TObject;
var
  i:     integer;
  cdObj: TCodedListObj;
begin
  Result := nil;
  for i := 0 to m_list.Count-1 do
  begin
    cdObj := TCodedListObj(m_list[i]);
    if cdObj.m_code = key1 then
    begin
      Result := TTwoDmatrix(cdObj.m_obj).GetObject(prop, key2);
      exit
    end
  end
end;

//----------------------------------------------------------------------------//

procedure TThreeDmatrix.AddObject(prop: TPropID; key1, key2: string; obj: TObject);
var
  i:     integer;
  cdObj: TCodedListObj;
begin
  cdObj := nil;
  for i := 0 to m_list.Count-1 do
    if TCodedListObj(m_list[i]).m_code = key1 then
    begin
      cdObj := TCodedListObj(m_list[i]);
      break
    end;

  if not Assigned(cdObj) then
  begin
    cdObj := TCodedListObj.Create;
    cdObj.m_code := key1;
    cdObj.m_obj  := TTwoDmatrix.Create;
    m_list.Add(cdObj);
  end;

  TTwoDmatrix(cdObj.m_obj).AddObject(prop, key2, obj)
end;

//----------------------------------------------------------------------------//

function TThreeDmatrix.GetLev1Count: integer;
begin
  Result := m_list.Count
end;

//----------------------------------------------------------------------------//

function TThreeDmatrix.GetLev1Key(i1: integer): string;
var
  cdObj: TCodedListObj;
begin
  cdObj := TCodedListObj(m_list[i1]);
  Result := cdObj.m_code
end;

//----------------------------------------------------------------------------//

function TThreeDmatrix.GetLev2Count(i1: integer): integer;
var
  cdObj: TCodedListObj;
begin
  cdObj := TCodedListObj(m_list[i1]);
  Result := TTwoDmatrix(cdObj.m_obj).GetLev1Count
end;

//----------------------------------------------------------------------------//

function TThreeDmatrix.GetLev2Key(i1, i2: integer): string;
var
  cdObj: TCodedListObj;
begin
  cdObj := TCodedListObj(m_list[i1]);
  Result := TTwoDmatrix(cdObj.m_obj).GetLev1Key(i2)
end;

//----------------------------------------------------------------------------//

function TThreeDmatrix.GetLev3Count(i1, i2: integer): integer;
var
  cdObj: TCodedListObj;
begin
  cdObj := TCodedListObj(m_list[i1]);
  Result := TTwoDmatrix(cdObj.m_obj).GetLev2Count(i2)
end;

//----------------------------------------------------------------------------//

function TThreeDmatrix.GetLev3Obj(i1, i2, i3: integer; var pId: TPropID): TObject;
var
  cdObj: TCodedListObj;
begin
  cdObj := TCodedListObj(m_list[i1]);
  Result := TTwoDmatrix(cdObj.m_obj).GetLev2Obj(i2, i3, pId)
end;

//----------------------------------------------------------------------------//

procedure TThreeDmatrix.PrintDataAsHtml(sl: TStringList; clsEven, clsOdd: string; dataProc: TMtxPrtDataProc);
const
  fmt = '<TR class="%s"><TD>%s</TD><TD>%s</TD><TD>%s</TD><TD>%s</TD>';
var
  i1, i2, i3: integer;
  obj:        TObject;
  str:        string;
  pId:        TPropId;
  cls:        string;
begin
  Assert(Assigned(dataProc));
  cls := clsEven;
  for i1 := 0 to GetLev1Count-1 do
    for i2 := 0 to GetLev2Count(i1)-1 do
      for i3 := 0 to GetLev3Count(i1, i2)-1 do
      begin
        obj := GetLev3Obj(i1, i2, i3, pId);
        if cls = clsEven then
          cls := clsOdd
        else
          cls := clsEven;

        FmtStr(str, fmt, [cls, GetPropCodeFromID(pId), GetPropDescr(pId), GetLev1Key(i1), GetLev2Key(i1, i2)]);
        dataProc(sl, str, cls, 4, pId, obj);
      end
end;

//----------------------------------------------------------------------------//
{
function TFourDmatrix.GetObject(prop: TPropID; key1, key2, key3: string): TObject;
var
  i:     integer;
  cdObj: TCodedListObj;
begin
  Result := nil;
  for i := 0 to m_list.Count-1 do
  begin
    cdObj := TCodedListObj(m_list[i]);
    if cdObj.m_code = key1 then
    begin
      Result := TThreeDmatrix(cdObj.m_obj).GetObject(prop, key2, key3);
      exit
    end
  end
end;

//----------------------------------------------------------------------------//

procedure TFourDmatrix.AddObject(prop: TPropID; key1, key2, key3: string; obj: TObject);
var
  cdObj: TCodedListObj;
begin
  cdObj := TCodedListObj.Create;
  cdObj.m_code := key1;
  cdObj.m_obj  := TOneDmatrix.Create;
  TThreeDmatrix(cdObj.m_obj).AddObject(prop, key2, key3, obj);

  m_list.Add(cdObj)
end;

//----------------------------------------------------------------------------//

function TFourDmatrix.GetLev1Count: integer;
begin
  Result := m_list.Count
end;

//----------------------------------------------------------------------------//

function TFourDmatrix.GetLev1Key(i1: integer): string;
var
  cdObj: TCodedListObj;
begin
  cdObj := TCodedListObj(m_list[i1]);
  Result := cdObj.m_code
end;

//----------------------------------------------------------------------------//

function TFourDmatrix.GetLev2Count(i1: integer): integer;
var
  cdObj: TCodedListObj;
begin
  cdObj := TCodedListObj(m_list[i1]);
  Result := TThreeDmatrix(cdObj.m_obj).GetLev1Count
end;

//----------------------------------------------------------------------------//

function TFourDmatrix.GetLev2Key(i1, i2: integer): string;
var
  cdObj: TCodedListObj;
begin
  cdObj := TCodedListObj(m_list[i1]);
  Result := TThreeDmatrix(cdObj.m_obj).GetLev1Key(i2)
end;

//----------------------------------------------------------------------------//

function TFourDmatrix.GetLev3Count(i1, i2: integer): integer;
var
  cdObj: TCodedListObj;
begin
  cdObj := TCodedListObj(m_list[i1]);
  Result := TThreeDmatrix(cdObj.m_obj).GetLev2Count(i2)
end;

//----------------------------------------------------------------------------//

function TFourDmatrix.GetLev3Key(i1, i2, i3: integer): string;
var
  cdObj: TCodedListObj;
begin
  cdObj := TCodedListObj(m_list[i1]);
  Result := TThreeDmatrix(cdObj.m_obj).GetLev2Key(i2, i3)
end;

//----------------------------------------------------------------------------//

function TFourDmatrix.GetLev4Count(i1, i2, i3: integer): integer;
var
  cdObj: TCodedListObj;
begin
  cdObj := TCodedListObj(m_list[i1]);
  Result := TThreeDmatrix(cdObj.m_obj).GetLev3Count(i2, i3)
end;

//----------------------------------------------------------------------------//

function TFourDmatrix.GetLev4Obj(i1, i2, i3, i4: integer; var pId: TPropID): TObject;
var
  cdObj: TCodedListObj;
begin
  cdObj := TCodedListObj(m_list[i1]);
  Result := TThreeDmatrix(cdObj.m_obj).GetLev3Obj(i2, i3, i4, pId)
end;

//----------------------------------------------------------------------------//

procedure TFourDmatrix.PrintDataAsHtml(sl: TStringList; clsEven, clsOdd: string; dataProc: TMtxPrtDataProc);
begin
  Assert(false);
end;
}
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

procedure CreateMatrix(var origMtx: TOrigMatrix; mtx: TCompatMatrix);
begin
  case mtx of
  CMX_code:            origMtx := TOneDmatrix.Create;


  CMX_code_proc,
  CMX_code_prod,
  CMX_code_cat:        origMtx := TTwoDmatrix.Create;

  CMX_code_prod_cat,
  CMX_code_prod_proc:  origMtx := TThreeDmatrix.Create
  end;

  origMtx.m_mtx := mtx
end;

//----------------------------------------------------------------------------//
{ TPropRes }

destructor TPropRes.Destroy;
begin
  inherited destroy;
end;

{ TCodedListObj }

//----------------------------------------------------------------------------//

destructor TCodedListObj.Destroy;
begin
  inherited destroy;
end;

//----------------------------------------------------------------------------//

destructor TThreeDmatrix.Destroy;
begin
  inherited destroy;
end;

end.


