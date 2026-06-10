unit FMCreateWarp;

interface

uses
  cxButtons, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, UMSchedList, UMArticles,
  Vcl.ExtCtrls, ExSpinEdit, UGPropComp, UMActArea,UMCompatSrv, UMWarp, UMSchedContFunc, UMWarpMover, UMUsrPropComp;

type

  TWarpMoveSrvFunc = procedure (ptr: pointer);
  TOccMoveEnterFunc = procedure (ptr1, ptr2: pointer);
  TOccMoveExitFunc  = procedure (ptr: pointer; BtnOk : boolean);

  TFCreateWarp = class(TForm)
    PageControlWarp: TPageControl;
    tbsParams: TTabSheet;
    GBLinkedRequest: TGroupBox;
    GroupBox1: TGroupBox;
    LblResource: TLabel;
    LblUpToCase: TLabel;
    SpEdtUpToCase: TExSpinEdit;
    Panel2: TPanel;
    GBDuration: TGroupBox;
    GBEndDate: TGroupBox;
    GBStDate: TGroupBox;
    TabProp: TTabSheet;
    Panel1: TPanel;
    BtnOk: TcxButton;
    BtnAbort: TcxButton;
    TbsErrors: TTabSheet;
    Panel3: TPanel;
    StWarpProduct: TStaticText;
    MemErrors: TMemo;
    lblID: TLabel;
    STSchedStart: TStaticText;
    STSchedEnd: TStaticText;
    STExecTime: TStaticText;
    StaticResCode: TStaticText;
    LblIDWarp: TLabel;
    LBQty: TLabel;
    STqty: TStaticText;
    GroupBox2: TGroupBox;
    EdtComment: TEdit;
    CBLinkRequest: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure BtnAbortClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOkClick(Sender: TObject);
    procedure Panel3Click(Sender: TObject);
  private
    m_Id : TSchedId;
    m_PropComp : TMShowPropList;
    m_New: boolean;
    m_Apa: TMqmActArea;
    m_Warp : TMqmWarp;
    m_WarpMover: TMqmWarpMover;
    m_fromGantt: boolean;
    m_LockChanges: boolean;
  //  m_duration : integer;

    m_suppFnc:  TWarpMoveSrvFunc;
    m_suppObj:  TObject;
    m_exitFnc:  TOccMoveExitFunc;

    procedure InitCaptions;
    function  CheckWarpSpeed : boolean;

  public
    constructor CreateWarpForm(AOwner: TComponent; Warp : TMqmWarp);
    destructor Destroy; override;

  //  function  CalculateWarpDurationBackword(var Date : TDateTime; var duration : double; var RemainQty : double) : boolean;
 //   function  CalculateWarpDurationForeward(var Date : TDateTime; var duration : double; var RemainQty : double; StopOnNotcompatibleId : boolean) : boolean;
    function  FindGoodWeavDateForSpot(Date : TDateTime; isEnd : boolean; var Duration : double) : boolean;
    function  CheckData(Apa: TMqmActArea) : boolean;
    function  CheckProductsUnderWarp : boolean;
    function  GetEndDate(ActArea : TMqmActArea; StartDate : TDateTime) : TDateTime;

//    function  setDataFromPlan(Apa: TMqmActArea; ToDate: TDateTime) : boolean;
    function  MoveTo(Date: TDateTime; isEnd: boolean; Duration : double) : boolean;
    function  MoveToNewPosition(Apa: TMqmActArea; ToDate: TDateTime; isEnd: boolean) : boolean;
    procedure SetActiveErrorTab(ErrorMsg : string);
    function  GetWarpId : TSchedId;
    function  GetWarpLvl : ArMaterialScheduleLvl;
    { Public declarations }
  end;

  function  GetCrtWarpForm: TFCreateWarp;
  procedure OpenWarpForm(AOwner: TWinControl; Warp : TMqmWarp; Id : TSchedId;
                          fnc: TWarpMoveSrvFunc; obj: TObject;
                          fncEnter: TOccMoveEnterFunc; fncExit: TOccMoveExitFunc;
                          apa: TMqmActArea);
  function CalculateWarpDurationBackword(Warp_id : TSchedId; Apa: TMqmActArea; var Date : TDateTime; var duration : double; var Setup : double; var RemainQty : double) : boolean;
  function CalculateWarpDurationForeward(Warp_id : TSchedId; Apa: TMqmActArea; var Date : TDateTime; var duration : double; var Setup : double; var RemainQty : double; StopOnNotcompatibleId : boolean) : boolean;


implementation

{$R *.dfm}

uses
  gnugettext,
  UGbaseCal,
  UMRes,
  UGglobal,
  UReShape,
  UMPlanObj,
  UMCompat,
  UMObjCont,
  UMSchedCont,
  UMDurObj,
  UMCommon, UMSchedOnPlan,
  UMWkCtr, FMMainPlan, FMbin;

var
  FCreateWarp: TFCreateWarp;

//----------------------------------------------------------------------------//

function CalculateWarpDurationForeward(Warp_id : TSchedId; Apa: TMqmActArea; var Date : TDateTime; var duration : double; var Setup : double; var RemainQty : double; StopOnNotcompatibleId : boolean) : boolean;
var
  Id, DummyId : Tschedid;
  StartIdDate, StartExecIdDate , EndIdDate ,WarpEndDate, DateToFindTheNextId : TDateTime;
  SpeedMinPerUM, MatQtyRequired, qty, MinutesUntilStart, MinutesUntilEnd, TotalMinutes, ConsumedQty, QtyDummy : double;
  StandardSpeed, OverridSpeed : variant;
  dataType: CBinColValType;
  cal : TPGCALObj;
begin
  Result := false;
  if not Assigned(Apa) then exit;
  cal := Apa.GetCalendar;
  if not Assigned(Cal) then exit;
  p_sc.GetFldValue(Warp_id, CSC_Mat_SpeedInminutePerUoM, StandardSpeed, dataType);
  p_sc.GetFldValue(Warp_id, CSC_Mat_Overriden_Speed, OverridSpeed, dataType);
  // take the setup as well
  if OverridSpeed > 0 then
    SpeedMinPerUM := OverridSpeed
  else
    SpeedMinPerUM := StandardSpeed;

  if SpeedMinPerUM <= 0 then exit;
  if RemainQty = 0 then exit;

  Cal.OfsByWH((Setup + SpeedMinPerUM * RemainQty)/60, true, Date, WarpEndDate, Apa.m_CrossDownTmList);
  DateToFindTheNextId := Date;

  while True do
  begin
    Id := Apa.FindSchedBeforeOrAfterDate(false, DateToFindTheNextId);
    if Id = CSchedIDnull then break;
    StartIdDate := p_sc.GetSchedStart(Id);
    StartExecIdDate := p_sc.GetSchedStart(Id); // we need the exec start
    cal := Apa.GetCalendar;
    if Assigned(Cal) then
      Cal.OfsByWH((Setup)/60, true, StartIdDate, StartExecIdDate, Apa.m_CrossDownTmList);

    EndIdDate   := p_sc.GetSchedEnd(ID);
    if (StartIdDate >= WarpEndDate) then break;
    if p_sc.CheckItemAndProductForWarp(Warp_id, Id, false, DummyId, MatQtyRequired) then break;
    if StopOnNotcompatibleId then exit;
    DateToFindTheNextId := EndIdDate;
  end;

  if (id = CSchedIDnull) or (StartExecIdDate >= WarpEndDate) then
  begin
    duration := Setup + duration + (SpeedMinPerUM * RemainQty);
    RemainQty := 0;
    Result := true;
    exit;
  end;

  if (StartExecIdDate > Date) then
  begin
    MinutesUntilStart := cal.DiffWH(Date, StartExecIdDate, Apa.m_CrossDownTmList)*60;
    qty := MinutesUntilStart/SpeedMinPerUM;
    if qty > RemainQty then // for rounding issues
      qty := RemainQty;
    duration := Setup + duration + MinutesUntilStart;
    RemainQty := RemainQty - qty;
    date := StartExecIdDate;
    Setup := 0;
    if CalculateWarpDurationForeward(Warp_id, Apa, date, duration, Setup, RemainQty, true) then
       result := true;
    exit;
  end;

  // we are above the job
  MinutesUntilEnd := cal.DiffWH(Date, EndIdDate , Apa.m_CrossDownTmList)*60;
  TotalMinutes    := cal.DiffWH(StartExecIdDate, EndIdDate , Apa.m_CrossDownTmList)*60;
  ConsumedQty := MinutesUntilEnd/TotalMinutes*MatQtyRequired;

  if ConsumedQty >= RemainQty then
  begin
    duration := Setup + duration + (RemainQty/MatQtyRequired*TotalMinutes);
    RemainQty := 0;
    Result := true;
    exit;
  end;

  RemainQty := RemainQty - ConsumedQty;
  duration  := Setup + duration + MinutesUntilEnd;
  date      := EndIdDate;
  Setup := 0;
  if CalculateWarpDurationForeward(Warp_id, Apa, date, duration, Setup, RemainQty, StopOnNotcompatibleID) then
       result := true;
end;

//----------------------------------------------------------------------------//

function CalculateWarpDurationBackword(Warp_id : TSchedId; Apa: TMqmActArea; var Date : TDateTime; var duration : double; var Setup : double; var RemainQty : double) : boolean;
var
  Id, DammyId : Tschedid;
  StartIdDate, StartExecIdDate , EndIdDate ,WarpStartDate : TDateTime;
  SpeedMinPerUM, MatQtyRequired, qty, MinutesUntilStart, MinutesUntilEnd, TotalMinutes, ConsumedQty, QtyDummy : double;
  cal : TPGCALObj;
  StandardSpeed, OverridSpeed : variant;
  dataType: CBinColValType;
begin
  Result := false;
  if not Assigned(Apa) then exit;
  cal := Apa.GetCalendar;
  if not Assigned(Cal) then exit;
  p_sc.GetFldValue(Warp_id, CSC_Mat_SpeedInminutePerUoM, StandardSpeed, dataType);
  p_sc.GetFldValue(Warp_id, CSC_Mat_Overriden_Speed, OverridSpeed, dataType);
  if OverridSpeed > 0 then
    SpeedMinPerUM := OverridSpeed
  else
    SpeedMinPerUM := StandardSpeed;

  if SpeedMinPerUM <= 0 then exit;

  if RemainQty = 0 then exit;
  Id := Apa.FindSchedBeforeOrAfterDate(true, Date);
  Cal.OfsByWH(-(Setup + SpeedMinPerUM * RemainQty)/60, false, Date, WarpStartDate, Apa.m_CrossDownTmList);

  if id <> CSchedIDnull then
  begin
    StartIdDate := p_sc.GetSchedStart(ID);
    StartExecIdDate := p_sc.GetSchedStart(ID); // we need the exec start
    EndIdDate   := p_sc.GetSchedEnd(ID);
  end;

  if (id = CSchedIDnull) or (EndIdDate <= WarpStartDate) then
  begin
    duration := Setup + duration + (SpeedMinPerUM * RemainQty);
    RemainQty := 0;
    Result := true;
    exit;
  end;

  if not p_sc.CheckItemAndProductForWarp(Warp_id, ID, false, DammyId, MatQtyRequired) then
    exit;

  if (EndIdDate < Date) then
  begin
    MinutesUntilEnd := cal.DiffWH(EndIdDate, Date , Apa.m_CrossDownTmList)*60;
    qty := MinutesUntilEnd/SpeedMinPerUM;
    if qty > RemainQty then // for rounding issues
      qty := RemainQty;
    duration := Setup + duration + MinutesUntilEnd;
    RemainQty := RemainQty - qty;
    date := EndIdDate;
    Setup := 0;
    if CalculateWarpDurationBackword(Warp_id, Apa, date, duration, Setup, RemainQty) then
       result := true;
    exit;
  end;

  // we are above the job
  MinutesUntilStart := cal.DiffWH(StartExecIdDate, Date , Apa.m_CrossDownTmList)*60;
  TotalMinutes    := cal.DiffWH(StartExecIdDate, EndIdDate , Apa.m_CrossDownTmList)*60;
  ConsumedQty := MinutesUntilStart/TotalMinutes*MatQtyRequired;

  if ConsumedQty >= RemainQty then
  begin
    duration := Setup + duration + (RemainQty/MatQtyRequired*TotalMinutes);
    RemainQty := 0;
    Result := true;
    exit;
  end;

  RemainQty := RemainQty - ConsumedQty;
  duration  := Setup + duration + MinutesUntilStart;
  date      := StartExecIdDate;

  if (StartIdDate > Date) then
  begin
    MinutesUntilStart := cal.DiffWH(StartIdDate, Date , Apa.m_CrossDownTmList)*60;
    qty := MinutesUntilStart/SpeedMinPerUM;
    if qty > RemainQty then // for rounding issues
      qty := RemainQty;
    duration := duration + MinutesUntilStart;
    RemainQty := RemainQty - qty;
    date := StartIdDate;
  end;
  Setup := 0;
  if CalculateWarpDurationBackword(Warp_id, Apa, date, duration, Setup, RemainQty) then
     result := true;
end;

//----------------------------------------------------------------------------//

function GetCrtWarpForm: TFCreateWarp;
begin
   Result := FCreateWarp
end;

//----------------------------------------------------------------------------//

procedure OpenWarpForm(AOwner: TWinControl; Warp: TMqmWarp; Id : TSchedId;
                          fnc: TWarpMoveSrvFunc; obj: TObject;
                          fncEnter: TOccMoveEnterFunc; fncExit: TOccMoveExitFunc;
                          apa: TMqmActArea);

var
  prop: TProperties;
begin
  if Assigned(Apa) then
    Warp := TMqmWarp(Apa.GetWarpFromId(id));

  p_opStack.MarkStackForButtonUndo(_('Move warp'));
  if not Assigned(FCreateWarp) then
  begin
    FCreateWarp := TFCreateWarp.CreateWarpForm(AOwner, Warp);
    FCreateWarp.formStyle := fsStayOnTop;
    FCreateWarp.m_Id := id;
    ReShape(FCreateWarp);
    FCreateWarp.InitCaptions;
    FCreateWarp.Show;
    FCreateWarp.SetFocus
  end;

  if Assigned(fncEnter) then fncEnter(obj, pointer(id));

  with FCreateWarp do
  begin
    m_fromGantt := false;
    LblIDWarp.Caption := IntToStr(id);
    m_WarpMover := TMqmWarpMover.Create;
    m_WarpMover.SetWarpToMove(Warp, Id);
    m_Warp := Warp;
    if assigned (apa) then
    begin
      m_Apa := apa;
      m_new := false;
      m_fromGantt := true;
    end;
    m_suppFnc :=  fnc;
    m_suppObj :=  obj;
    m_exitFnc := fncExit;

    FMQMPlan.RefreshActiveTab;

    if Assigned(FBin) then
      FBin.RefreshGrid;

    m_Id := Id;
    prop := p_sc.GetProperties(m_Id, nil);

    m_propComp := TMShowPropList.CreateShowPropList(TabProp, prop, m_Id, false);


    Show
  end

end;

//----------------------------------------------------------------------------//

procedure TFCreateWarp.BtnAbortClick(Sender: TObject);
begin
  ModalResult := mrAbort;
 // p_pl.ExitCompatModeInPlanCapRes;
  m_WarpMover.Abort;
  if Assigned(m_suppFnc) then m_suppFnc(m_suppObj);
  Close;
end;

//----------------------------------------------------------------------------//

procedure TFCreateWarp.BtnOkClick(Sender: TObject);
begin
  ModalResult := mrOk;
  Close
end;

//----------------------------------------------------------------------------//

{function TFCreateWarp.CalculateWarpDurationBackword(var Date : TDateTime; var duration : double; var RemainQty : double) : boolean;
var
  Id, DammyId : Tschedid;
  StartIdDate, StartExecIdDate , EndIdDate ,WarpStartDate : TDateTime;
  SpeedMinPerUM, MatQtyRequired, qty, MinutesUntilStart, MinutesUntilEnd, TotalMinutes, ConsumedQty, QtyDummy : double;
  cal : TPGCALObj;
  StandardSpeed, OverridSpeed : variant;
  dataType: CBinColValType;
begin
  Result := false;
  if not Assigned(m_Apa) then exit;
  cal := m_Apa.GetCalendar;
  if not Assigned(Cal) then exit;
  //SpeedMinPerUM := m_Warp.GetSpeedMinPerUm;
                                        //  CSC_Mat_SpeedInminutePerUoM
  p_sc.GetFldValue(m_id, CSC_Mat_SpeedInminutePerUoM, StandardSpeed, dataType);
  p_sc.GetFldValue(m_id, CSC_Mat_Overriden_Speed, OverridSpeed, dataType);
  if OverridSpeed > 0 then
    SpeedMinPerUM := OverridSpeed
  else
    SpeedMinPerUM := StandardSpeed;

  if SpeedMinPerUM <= 0 then exit;

  if RemainQty = 0 then exit;
  Id := m_Apa.FindSchedBeforeOrAfterDate(true, Date);
  Cal.OfsByWH(-(SpeedMinPerUM * RemainQty)/60, false, Date, WarpStartDate, m_Apa.m_CrossDownTmList);

  if id <> CSchedIDnull then
  begin
    StartIdDate := p_sc.GetSchedStart(ID);
    StartExecIdDate := p_sc.GetSchedStart(ID); // we need the exec start
    EndIdDate   := p_sc.GetSchedEnd(ID);
  end;

  if (id = CSchedIDnull) or (EndIdDate <= WarpStartDate) then
  begin
    duration := duration + (SpeedMinPerUM * RemainQty);
    RemainQty := 0;
    Result := true;
    exit;
  end;

  if not p_sc.CheckItemAndProductForWarp(m_id, ID, false, DammyId, MatQtyRequired) then
    exit;

  if (EndIdDate < Date) then
  begin
    MinutesUntilEnd := cal.DiffWH(EndIdDate, Date , m_Apa.m_CrossDownTmList)*60;
    qty := MinutesUntilEnd/SpeedMinPerUM;
    if qty > RemainQty then // for rounding issues
      qty := RemainQty;
    duration := duration + MinutesUntilEnd;
    RemainQty := RemainQty - qty;
    date := EndIdDate;
    if CalculateWarpDurationBackword(date, duration, RemainQty) then
       result := true;
    exit;
  end;

  // we are above the job
  MinutesUntilStart := cal.DiffWH(StartExecIdDate, Date , m_Apa.m_CrossDownTmList)*60;
  TotalMinutes    := cal.DiffWH(StartExecIdDate, EndIdDate , m_Apa.m_CrossDownTmList)*60;
  ConsumedQty := MinutesUntilStart/TotalMinutes*MatQtyRequired;

  if ConsumedQty >= RemainQty then
  begin
    duration := duration + (RemainQty/MatQtyRequired*TotalMinutes);
    RemainQty := 0;
    Result := true;
    exit;
  end;

  RemainQty := RemainQty - ConsumedQty;
  duration  := duration + MinutesUntilStart;
  date      := StartExecIdDate;

  if (StartIdDate > Date) then
  begin
    MinutesUntilStart := cal.DiffWH(StartIdDate, Date , m_Apa.m_CrossDownTmList)*60;
    qty := MinutesUntilStart/SpeedMinPerUM;
    if qty > RemainQty then // for rounding issues
      qty := RemainQty;
    duration := duration + MinutesUntilStart;
    RemainQty := RemainQty - qty;
    date := StartIdDate;
  end;

  if CalculateWarpDurationBackword(date, duration, RemainQty) then
     result := true;
end;   }

//----------------------------------------------------------------------------//

{function TFCreateWarp.CalculateWarpDurationForeward(var Date : TDateTime; var duration : double; var RemainQty : double; StopOnNotcompatibleId : boolean) : boolean;
var
  Id, DummyId : Tschedid;
  StartIdDate, StartExecIdDate , EndIdDate ,WarpEndDate, DateToFindTheNextId : TDateTime;
  SpeedMinPerUM, MatQtyRequired, qty, MinutesUntilStart, MinutesUntilEnd, TotalMinutes, ConsumedQty, QtyDummy : double;
  StandardSpeed, OverridSpeed : variant;
  dataType: CBinColValType;
  cal : TPGCALObj;
begin
  Result := false;
  if not Assigned(m_Apa) then exit;
  cal := m_Apa.GetCalendar;
  if not Assigned(Cal) then exit;
  p_sc.GetFldValue(m_id, CSC_Mat_SpeedInminutePerUoM, StandardSpeed, dataType);
  p_sc.GetFldValue(m_id, CSC_Mat_Overriden_Speed, OverridSpeed, dataType);
  if OverridSpeed > 0 then
    SpeedMinPerUM := OverridSpeed
  else
    SpeedMinPerUM := StandardSpeed;

  if SpeedMinPerUM <= 0 then exit;
  if RemainQty = 0 then exit;

  Cal.OfsByWH((SpeedMinPerUM * RemainQty)/60, true, Date, WarpEndDate, m_Apa.m_CrossDownTmList);
  DateToFindTheNextId := Date;

  while True do
  begin
    Id := m_Apa.FindSchedBeforeOrAfterDate(false, DateToFindTheNextId);
    if Id = CSchedIDnull then break;
    StartIdDate := p_sc.GetSchedStart(Id);
    StartExecIdDate := p_sc.GetSchedStart(Id); // we need the exec start
    EndIdDate   := p_sc.GetSchedEnd(ID);
    if (StartIdDate >= WarpEndDate) then break;
    if p_sc.CheckItemAndProductForWarp(m_id, Id, false, DummyId, MatQtyRequired) then break;
    if StopOnNotcompatibleId then exit;
    DateToFindTheNextId := EndIdDate;
  end;

  if (id = CSchedIDnull) or (StartExecIdDate >= WarpEndDate) then
  begin
    duration := duration + (SpeedMinPerUM * RemainQty);
    RemainQty := 0;
    Result := true;
    exit;
  end;

  if (StartExecIdDate > Date) then
  begin
    MinutesUntilStart := cal.DiffWH(Date, StartExecIdDate , m_Apa.m_CrossDownTmList)*60;
    qty := MinutesUntilStart/SpeedMinPerUM;
    if qty > RemainQty then // for rounding issues
      qty := RemainQty;
    duration := duration + MinutesUntilStart;
    RemainQty := RemainQty - qty;
    date := StartExecIdDate;
    if CalculateWarpDurationForeward(date, duration, RemainQty, true) then
       result := true;
    exit;
  end;

  // we are above the job
  MinutesUntilEnd := cal.DiffWH(Date, EndIdDate , m_Apa.m_CrossDownTmList)*60;
  TotalMinutes    := cal.DiffWH(StartExecIdDate, EndIdDate , m_Apa.m_CrossDownTmList)*60;
  ConsumedQty := MinutesUntilEnd/TotalMinutes*MatQtyRequired;

  if ConsumedQty >= RemainQty then
  begin
    duration := duration + (RemainQty/MatQtyRequired*TotalMinutes);
    RemainQty := 0;
    Result := true;
    exit;
  end;

  RemainQty := RemainQty - ConsumedQty;
  duration  := duration + MinutesUntilEnd;
  date      := EndIdDate;
  if CalculateWarpDurationForeward(date, duration, RemainQty, StopOnNotcompatibleID) then
       result := true;
end;      }

//----------------------------------------------------------------------------//

function TFCreateWarp.FindGoodWeavDateForSpot(Date : TDateTime; isEnd : boolean; var Duration : double) : boolean;
var
  Id, DammyId : TSchedId;
  DatesInfo : TSQStartEndInfo;
  I : integer;
  RemainQty, QtyDummy : double;
  DurationChanged : boolean;
  SetUp: variant;
  SetUpDouble : double;
  dataType: CBinColValType;
begin
  Id := CSchedIDnull;
  DurationChanged := false;
  Result := true;
  RemainQty := m_Warp.GetQuantity;

  p_sc.GetFldValue(m_Id, CSC_Mat_Overriden_Setup_Time, SetUp, dataType);
  SetUpDouble := SetUp;

  duration := 0;
  if not isEnd then
    result := CalculateWarpDurationForeward(m_Id, m_Apa, date,duration,SetUpDouble,RemainQty, true)
  else
    result := CalculateWarpDurationBackword(m_Id, m_Apa, date,duration, SetUpDouble,RemainQty);
end;

//-------------------------ses---------------------------------------------------//

function TFCreateWarp.CheckData(Apa: TMqmActArea) : boolean;
var
  errlist:  TStringList;
  CompVal:  TCompatVal;
  Dependency : boolean;
  SchedId, DammyId : TSchedId;
  ErrorMsg : string;
begin
  m_Apa := Apa;
  Result := true;
  if TMqmWrkCtr(Apa.p_WrkCtr).p_ReadOnly then
  begin
    ErrorMsg := _('Not allowed to move objects on read only resources.');
    MemErrors.Lines.Clear;
    result := false;
    MemErrors.Lines.Add(ErrorMsg);
    PageControlWarp.ActivePage := TbsErrors;
    BtnOk.Enabled      := false;
    exit
  end;

  PageControlWarp.ActivePage := tbsParams;
  MemErrors.Lines.Clear;

  errlist := TStringList.Create;
  if not Apa.CheckCompatWithOcc([cho_compVal, cho_wkc, cho_readOnly],
                                     m_Id, Date, errlist, CompVal, Dependency) then
  begin
    Result := false;
    MemErrors.Lines    := errlist;
    PageControlWarp.ActivePage := TbsErrors;
    BtnOk.Enabled      := false;
    exit
  end;
  errlist.Free;
end;

//----------------------------------------------------------------------------//

function TFCreateWarp.CheckProductsUnderWarp : boolean;
var
  ObjToCheck : TMSchedList;
  I : Integer;
  DammyQty : double;
  ID, DammyId : TSchedId;
begin
  Result := true;
  ObjToCheck := TMSchedList.Create(self);
  m_Apa.FindSchedInSpots(m_Warp.p_start, m_Warp.p_end, ObjToCheck);
  for I := ObjToCheck.GetLinkCount -1 downto 0 do
  begin
    ID := ObjToCheck.GetLink(i);
    if not p_sc.CheckItemAndProductForWarp(m_id, ID, false, DammyId, DammyQty) then
    begin
      Result := false;
      exit;
    end;

  end;
end;

//----------------------------------------------------------------------------//

function TFCreateWarp.GetEndDate(ActArea : TMqmActArea; StartDate : TDateTime) : TDateTime;
var
  cal:      TPGCALObj;
begin
  if Assigned(ActArea) then
  begin
    cal := actArea.GetCalendar;
    if Assigned(Cal) then
      Cal.OfsByWH((m_Warp.p_durDouble/60), true, StartDate, Result, ActArea.m_CrossDownTmList);
     // Cal.OfsByWHDwTime((m_Warp.p_durDouble/60), true, StartDate, Result);
  end;
end;

//----------------------------------------------------------------------------//

constructor TFCreateWarp.CreateWarpForm(AOwner: TComponent; Warp : TMqmWarp);
var
  WarpInfo: TPWarpInfo;
  MaterialSched : TSCMaterialSched;
begin
  inherited Create(AOwner);
//  m_ControlDaysChange := true;
//  m_ControlHoursChange := true;
//  m_ControlMinutesChange := true;

  if assigned(Warp) then
  begin
    m_Warp := Warp;
    m_Apa := TMqmActArea(Warp.p_father);
    SetComponent(STSchedStart, comp_Descr, false);
    SetComponent(STSchedEnd, comp_Descr, false);
    SetComponent(STExecTime, comp_Descr, false);
    SetComponent(StaticResCode, comp_Descr, false);

    STSchedStart.Caption :=  DateTimeToStr(m_Warp.p_start);
    STSchedEnd.Caption :=  DateTimeToStr(m_Warp.p_End);
    STExecTime.Caption := FormatDuration(m_Warp.p_durDouble, true);
    StaticResCode.Caption := TMqmRes(m_Warp.p_Res).p_ResCode;

    p_sc.GetWarpInfo(m_Warp.Get_M_id,  WarpInfo);

    if WarpInfo.IsWarpLinkedToRequest then
    begin
      MaterialSched := TSCMaterialSched(WarpInfo.MaterialSched);
      MaterialSched.FillLinkRequestStep(CBLinkRequest.Items);
      if CBLinkRequest.Items.count > 0 then
        CBLinkRequest.ItemIndex := 0
    end;

    m_New := false
  end else
  begin
    m_New := true;
    m_Warp := nil;
  end;

end;

//----------------------------------------------------------------------------//

destructor TFCreateWarp.Destroy;
begin
  inherited destroy;
  FCreateWarp := nil;
end;

//----------------------------------------------------------------------------//

procedure TFCreateWarp.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (ModalResult <> mrAbort) and (ModalResult <> mrOk) then
  begin
   // p_pl.ExitCompatModeInPlanCapRes;
   // m_CapResMover.Abort;
   // if Assigned(m_suppFnc) then m_suppFnc(m_suppObj);

   // if Assigned(m_CapRes) then
   //   Exclude(m_capRes.m_ObjProp, objPr_MoveSel);
  end;

  if Assigned(m_exitFnc) then
    m_exitFnc(m_suppObj, false);

  FMQMPlan.RefreshActiveTab;   // Refresh Plan
  Action    := caFree;
  FCreateWarp := nil
end;

//----------------------------------------------------------------------------//

procedure TFCreateWarp.InitCaptions;
var
  ActualDateTime: TDateTime;
  ResourceCode : string;
  FieldVal: variant;
  dataType: CBinColValType;
begin
  p_sc.GetFldValue(m_Id, CSC_Mat_PRODUCT_CODE, FieldVal, dataType);
  StWarpProduct.Caption := FieldVal;

  p_sc.GetFldValue(m_Id, CSC_Mat_Quantity, FieldVal, dataType);
  STqty.Caption := FieldVal;

  m_LockChanges := true;

  Caption := _('Warp');

  SetComponent(EdtComment, comp_Edit,  true);
 // SetComponent(StaticResCode, comp_Edit, false);

  if m_New then
  begin
    ActualDateTime := now;
    BtnOk.Enabled       := false;
    STSchedStart.Caption := '';
    STSchedEnd.Caption   := '';
    STExecTime.Caption   := '';
    StaticResCode.Caption := '';
   // LblResource.Caption := '';

    if Assigned(m_Warp) then
    begin
     // WorkCenterCode := TMqmWrkCtr(TMqmRes(m_Warp.p_Res).p_WrkCtr).p_WrkCtrCode;
    //  StaticResCode.Caption := TMqmRes(m_Warp.p_Res).p_ResCode;
     // CBResource.ItemIndex := CBResource.Items.IndexOf(ResourceCode);
    end;
  end else
  begin

  end;

  m_LockChanges := false;

end;

//----------------------------------------------------------------------------//

function TFCreateWarp.CheckWarpSpeed : boolean;
var
  StandardSpeed, OverridSpeed : variant;
  dataType: CBinColValType;
  SpeedMinPerUM : double;
begin
  Result := true;
  p_sc.GetFldValue(m_id, CSC_Mat_SpeedInminutePerUoM, StandardSpeed, dataType);
  p_sc.GetFldValue(m_id, CSC_Mat_Overriden_Speed, OverridSpeed, dataType);
  if OverridSpeed > 0 then
    SpeedMinPerUM := OverridSpeed
  else
    SpeedMinPerUM := StandardSpeed;
  if SpeedMinPerUM <= 0 then result := false;
end;

//----------------------------------------------------------------------------//

function TFCreateWarp.MoveTo(Date: TDateTime; isEnd: boolean; Duration : double): boolean;
var
  NewDate : TDateTime;
begin
  Result := true;
  BtnOk.Enabled := true;

  if not m_WarpMover.ChangeTo(m_Apa, Date, Duration, isEnd) then
  begin
    result := false;
    if Assigned(m_suppFnc) then
      m_suppFnc(m_suppObj);
    exit;
  end;
{  if not CheckProductsUnderWarp then
  begin
    Result := false;
    m_WarpMover.UndoTo;
    BtnOk.Enabled := false;
  end;  }

  if Assigned(m_suppFnc) then
    m_suppFnc(m_suppObj);

end;

//----------------------------------------------------------------------------//

function TFCreateWarp.MoveToNewPosition(Apa: TMqmActArea; ToDate: TDateTime; isEnd: boolean) : boolean;
var
  FoundPosition : boolean;
  Dur : double;
begin
  Result := false;

  if not CheckData(Apa) then exit;
  FoundPosition := false;

  if not CheckWarpSpeed then
  begin
    SetActiveErrorTab(_('Speed is not definied for the Warp'));
    if Assigned(FBin) then
      FBin.RefreshGrid;
    Exit;
  end;

  if FindGoodWeavDateForSpot(ToDate, isEnd, Dur) then
     FoundPosition := MoveTo(ToDate, isEnd, Dur);
  if not FoundPosition then
    SetActiveErrorTab(_('Not compatible position'))
  else
  begin
    STSchedStart.Caption :=  DateTimeToStr(m_Warp.p_start);
    STSchedEnd.Caption :=  DateTimeToStr(m_Warp.p_End);
    STExecTime.Caption := FormatDuration(m_Warp.p_durDouble  , true);
    StaticResCode.Caption := TMqmRes(m_Warp.p_Res).p_ResCode;
    p_sc.SetWarpSchedData(m_Id, m_Warp.p_start, m_Warp.p_End, TMqmRes(m_Warp.p_Res).p_ResCode);
  end;
  if Assigned(FBin) then
    FBin.RefreshGrid;
end;

//----------------------------------------------------------------------------//

procedure TFCreateWarp.SetActiveErrorTab(ErrorMsg : string);
var
  errlist : TStringList;
begin
  errlist := TStringList.Create;
  errlist.Add(ErrorMsg);
  MemErrors.Lines    := errlist;
  PageControlWarp.ActivePage := TbsErrors;
  BtnOk.Enabled      := false;
  errlist.Free;
end;

//----------------------------------------------------------------------------//

function TFCreateWarp.GetWarpId : TSchedId;
begin
  Result := m_Id
end;

//----------------------------------------------------------------------------//

function TFCreateWarp.GetWarpLvl : ArMaterialScheduleLvl;
begin
  result := m_Warp.m_WarpLvl
end;

//----------------------------------------------------------------------------//

procedure TFCreateWarp.Panel3Click(Sender: TObject);
begin
  LblIDWarp.Visible := true;
end;

//----------------------------------------------------------------------------//

procedure TFCreateWarp.FormCreate(Sender: TObject);
begin
  ReShape(Self);
end;

end.
