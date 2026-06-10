unit FMCreateCapRes;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Buttons, DateUtils,
  Grids, Menus,
  UGPropComp,
  UMCapRes,
  UmActArea,
  UMCapResMover,
  Spin,
  UMRes,
  UMCompat,
  UMSchedContFunc,
  UMschedCont,
  UMCompatSrv,
  gnugettext,
  UReShape, ExSpinEdit;

type
  TCapResMoveSrvFunc = procedure (ptr: pointer);

  TFCreateCapRes = class(TForm)
    PageControl1: TPageControl;
    tbsParams: TTabSheet;
    TabProp: TTabSheet;
    Panel1: TPanel;
    GBStDate: TGroupBox;
    LblStDate: TLabel;
    LblStTime: TLabel;
    DTPStDate: TDateTimePicker;
    DTPStTime: TDateTimePicker;
    GBDuration: TGroupBox;
    LblDays: TLabel;
    LblHours: TLabel;
    LblMinutes: TLabel;
    SEDays: TExSpinEdit;
    SEHours: TExSpinEdit;
    SEMinutes: TExSpinEdit;
    GBEndDate: TGroupBox;
    LblEndDate: TLabel;
    LblEndTime: TLabel;
    DTPEndDate: TDateTimePicker;
    DTPEndTime: TDateTimePicker;
    GroupBox5: TGroupBox;
    EdtComment: TEdit;
    GroupBox1: TGroupBox;
    CBProcess: TComboBox;
    CBResource: TComboBox;
    LblResource: TLabel;
    CBClrDesc: TComboBox;
    CBWrkCtr: TComboBox;
    LblWrkCtr: TLabel;
    LblClrDesc: TLabel;
    SpEdtUpToCase: TExSpinEdit;
    LblUpToCase: TLabel;
    LblProcess: TLabel;
    BtnOk: TcxButton;
    BtnAbort: TcxButton;
    BtnDetach: TcxButton;
    Panel2: TPanel;
    procedure CBoxDataFromResMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CBWrkCtrChange(Sender: TObject);
    procedure CBClrDescChange(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure BtnAbortClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CBClrDescDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure DTPStDateChange(Sender: TObject);
    procedure DTPStTimeChange(Sender: TObject);
    procedure DTPEndDateChange(Sender: TObject);
    procedure DTPEndTimeChange(Sender: TObject);
    procedure SEDaysChange(Sender: TObject);
    procedure SEHoursChange(Sender: TObject);
    procedure SEMinutesChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnDetachClick(Sender: TObject);
    procedure PageControl1DrawTab(Control: TCustomTabControl; TabIndex: Integer;
      const Rect: TRect; Active: Boolean);
  private
    m_ControlDaysChange, m_ControlHoursChange, m_ControlMinutesChange : boolean;
    m_PropComp : TPropComponent;
    m_New: boolean;
    m_Apa: TMqmActArea;
    m_CapRes: TMqmCapRes;
    m_CapResMover: TMqmCapResMover;
    m_fromGantt: boolean;
    m_LockChanges: boolean;

    m_suppFnc:  TCapResMoveSrvFunc;
    m_suppObj:  TObject;
    m_ErrorInProperties: boolean;
    procedure LoadCaptions;
    procedure InitCaptions;
    function  MoveTo(Apa: TMqmActArea; Date: TDateTime; Duration: integer; isEnd: boolean): boolean;
    function  CheckData: boolean;
    procedure StartDateChanged;
    procedure EndDateChanged;
    procedure DurationChanged;
    procedure UpdateObjData;
    procedure CheckProperties;
    procedure EnableDisablField(control : boolean);
    function getDur(StDate, EndDate : TDateTime): Integer;
    { Private declarations }
  public
    { Public declarations }
    m_MouseDate : TDateTime;

    constructor CreateFMCrtCapRes(AOwner: TComponent; CapRes: TMqmCapRes; StDate : TDateTime);//; apa: TMqmActArea);
    destructor Destroy; override;
    procedure setDataFromPlan(Apa: TMqmActArea; ToDate: TDateTime);
    procedure GetResourceProperties(Res: TMqmRes; ResProperties: TStrings);


  end;

  function BtnAddPropCheck(PropCode: string): boolean;
  function  GetCrtCapResForm: TFCreateCapRes;
  procedure OpenCapResForm(AOwner: TWinControl; CapRes: TMqmCapRes;
                          fnc: TCapResMoveSrvFunc; obj: TObject;
                          apa: TMqmActArea;
                          StDate : TDateTime);

var
  FMCrtCapRes: TFCreateCapRes;
  CapResDesc: array [0..99] of Integer;
  CapResSelectedDate: TDateTime;

implementation

{$R *.DFM}

uses
  UGglobal,
  UMglobal,
  UMObjCont,
  UMPlanObj,
  UMDurObj,
  UMWkCtr,
  UGbaseCal,
  FMMainPlan;

//----------------------------------------------------------------------------//

procedure OpenCapResForm(AOwner: TWinControl; CapRes: TMqmCapRes;
                          fnc: TCapResMoveSrvFunc; obj: TObject;
                          apa: TMqmActArea;
                          StDate : TDateTime);
begin
  if not Assigned(FMCrtCapRes) then
  begin
    FMCrtCapRes := TFCreateCapRes.CreateFMCrtCapRes(AOwner, CapRes, StDate);
    FMCrtCapRes.formStyle := fsStayOnTop;
    FMCrtCapRes.InitCaptions;
  end;

  with FMCrtCapRes do
  begin
    m_fromGantt := false;
    m_CapResMover := TMqmCapResMover.Create;
    m_CapResMover.SetCapResToMove(m_CapRes);
    if assigned (apa) then
      begin
        m_Apa := apa;
        m_new := false;
        m_fromGantt := true;

        CBWrkCtr.Text := TMqmWrkCtr(Apa.p_WrkCtr).p_WrkCtrCode;
        CBWrkCtrChange(FMCrtCapRes);
//        StStartDate.Caption := DateTimeTostr(CapResSelectedDate);
      end;
    Include(m_capRes.m_ObjProp, objPr_MoveSel);
    m_suppFnc :=  fnc;
    m_suppObj :=  obj;

    if (m_CapRes <> nil) then
      p_pl.EnterCompatModeInPlanCapRes(m_CapRes);
    FMQMPlan.RefreshActiveTab;   // Refresh Plan
    Show
  end
end;

//----------------------------------------------------------------------------//

function GetCrtCapResForm: TFCreateCapRes;
begin
  Result := FMCrtCapRes
end;

//----------------------------------------------------------------------------//

function BtnAddPropCheck(PropCode: string): boolean;
var
  ResProperties: TStringList;
  Res: TMqmRes;
begin
  Result := true;

  ResProperties := TStringList.Create;
  Res := TMqmRes(FMCrtCapRes.m_CapRes.p_Res);
  if not assigned(Res) then
    exit;

  FMCrtCapRes.GetResourceProperties(Res, ResProperties);
  if ResProperties.IndexOf(PropCode) < 0 then
  begin
    Result := false;
    MessageDlg(_('The property is irrelevant for that resource.'), mtWarning, [mbOK], 0);
  end;

  ResProperties.Free;
end;

//----------------------------------------------------------------------------//

procedure PropChanged;
begin
  FMCrtCapRes.UpdateObjData;
  p_pl.UpdateCompatModeInPlanCapRes;
  FMQMPlan.RefreshActiveTab;   // Refresh Plan
end;

//----------------------------------------------------------------------------//

constructor TFCreateCapRes.CreateFMCrtCapRes(AOwner: TComponent; CapRes: TMqmCapRes; StDate : TDateTime);//; apa: TMqmActArea);
begin
  inherited Create(AOwner);
  m_ControlDaysChange := true;
  m_ControlHoursChange := true;
  m_ControlMinutesChange := true;

  m_MouseDate := StDate;

//  Height := 368;
//  Width := 555;

  if assigned(CapRes) then
  begin
    m_CapRes := CapRes;
    m_Apa := TMqmActArea(CapRes.p_father);
    m_New := false
  end else
  begin
    m_New := true;
    m_CapRes := nil;
  end;

  if (DBAppSettings.CapResStartEnd) and (m_New) then
  begin
     DTPEndDate.Enabled := True;
     DTPStDate.Enabled := True;
     GBDuration.Enabled := False;
  end else
  begin
    DTPEndDate.Enabled := False;
    DTPStDate.Enabled := False;
    GBDuration.Enabled := True;
  end;

  m_PropComp := TPropComponent.CreatePropComp(TabProp,CapResProp,nil,-1, BtnAddPropCheck, PropChanged);
  LoadCaptions;
end;

//----------------------------------------------------------------------------//

destructor TFCreateCapRes.Destroy;
begin
  inherited destroy;
  FMCrtCapRes := nil;
end;

//----------------------------------------------------------------------------//

procedure TFCreateCapRes.LoadCaptions;
var
  i: integer;
begin
  //CBoxDataFromRes.Checked := m_New;

  CBWrkCtr.Items.Clear;
  for i := 0 to p_pl.p_WrkCtrsCount-1 do
    CBWrkCtr.Items.Add(TMqmWrkCtr(p_pl.p_WrkCtr[i]).p_WrkCtrCode);

  CBClrDesc.Items.Clear;
  for i := 0 to high(DBAppGlobals.CapResColors) do
    CBClrDesc.Items.Add( DBAppGlobals.CapResColors[i].Dsc );

end;

//----------------------------------------------------------------------------//

procedure TFCreateCapRes.InitCaptions;
var
  i,P: integer;
  propId : TPropID;
  PropCode,desc, WorkCenterCode, ResourceCode : string;
  PropVal  : variant;
  PropRscCode : string;
  ActualDateTime: TDateTime;
begin
  m_LockChanges := true;

  Caption := _('Capacity reservation');

  SetComponent(EdtComment, comp_Edit,  true);
  SetComponent(LblDays,    comp_Label, false);
  SetComponent(LblHours,   comp_Label, false);
  SetComponent(LblMinutes, comp_Label, false);
  SetComponent(LblStDate,  comp_Label, false);
  SetComponent(LblStTime,  comp_Label, false);
  SetComponent(LblEndDate, comp_Label, false);
  SetComponent(LblEndTime, comp_Label, false);
  SetComponent(LblProcess, comp_Label, false);
  SetComponent(LblWrkCtr,  comp_Label, false);
  SetComponent(CBProcess,  comp_Edit,  false);
  SetComponent(CBWrkCtr,   comp_Edit, false);
  SetComponent(LblClrDesc, comp_Label, false);
  SetComponent(CBClrDesc,  comp_Edit, true);
  SetComponent(CBResource, comp_Edit, false);



  if m_New then
  begin
    ActualDateTime := m_MouseDate;//now;
    DTPStDate.DateTime  := ActualDateTime;
    DTPStTime.DateTime  := ActualDateTime;
    DTPEndDate.DateTime := ActualDateTime;
    DTPEndTime.DateTime := ActualDateTime;
    SEHours.Value       := 1;
    CBClrDesc.ItemIndex := 0;
    CBClrDescChange(self);

    BtnOk.Enabled       := false;
  //  BtnOk.Color         := clGradientActiveCaption;

    BtnDetach.Enabled   := false;
  //  BtnDetach.Color     := clGradientActiveCaption;

    if Assigned(m_CapRes) then
    begin
      WorkCenterCode := TMqmWrkCtr(TMqmRes(m_CapRes.p_Res).p_WrkCtr).p_WrkCtrCode;
      ResourceCode := TMqmRes(m_CapRes.p_Res).p_ResCode;
      CBWrkCtr.ItemIndex := CBWrkCtr.Items.IndexOf( WorkCenterCode );
      CBWrkCtrChange(self);
      CBResource.ItemIndex := CBResource.Items.IndexOf(ResourceCode);
    end;
  end else
  begin
    DTPStDate.DateTime  := m_CapRes.p_start;
    DTPStTime.DateTime  := m_CapRes.p_start;

    DTPEndDate.DateTime := m_CapRes.p_End;
    DTPEndTime.DateTime := m_CapRes.p_End;

    SEDays.Value    := Trunc(m_CapRes.p_dur / 24 / 60);
    SEHours.Value   := Trunc((m_CapRes.p_dur - SEDays.Value*24*60) / 60);
    SEMinutes.Value := Trunc(m_CapRes.p_dur - SEDays.Value*24*60 - SEHours.Value * 60);


    if Assigned(m_CapRes.p_WrkCtr)
    and (CBWrkCtr.ItemIndex <> CBWrkCtr.Items.IndexOf(TMqmWrkCtr(m_CapRes.p_WrkCtr).p_WrkCtrCode)) then
    begin
      CBWrkCtr.ItemIndex := CBWrkCtr.Items.IndexOf(TMqmWrkCtr(m_CapRes.p_WrkCtr).p_WrkCtrCode);
      CBWrkCtrChange(self);

      CBClrDesc.ItemIndex := m_CapRes.m_ColorIndex;
      CBClrDescChange(self);

      if CBProcess.ItemIndex <> CBProcess.Items.IndexOf(m_CapRes.m_WCProc) then
        CBProcess.ItemIndex := CBProcess.Items.IndexOf(m_CapRes.m_WCProc);

      if CBResource.ItemIndex <> CBResource.Items.IndexOf(TMqmRes(m_CapRes.p_Res).p_ResCode) then
        CBResource.ItemIndex := CBResource.Items.IndexOf(TMqmRes(m_CapRes.p_Res).p_ResCode);

      SpEdtUpToCase.Value := m_CapRes.m_UpMostCase;
      EdtComment.Text := m_CapRes.m_Comment;
      BtnOk.Enabled   := true;
    //  BtnOk.Color         := $00F3B758;
      BtnDetach.Enabled := true;
    //  BtnDetach.Color  := $00F3B758;

    end;

    P := 1;
    for i := 0 to m_CapRes.m_propList.p_PropCount - 1 do
    begin
      PropVal := m_CapRes.m_propList.GetProperty(i, propId, PropRscCode); //-prop
      PropCode := GetPropCodeFromID(propId);
      desc := GetPropDescr(propId);
      if p = 1 then
        m_PropComp.SetPropDescVal(PropCode, desc, p, true, PropVal)
      else
        m_PropComp.SetPropDescVal(PropCode, desc, p, false, PropVal);
      Inc(p);
    end;
  end;

  SEDays.MinValue    := 0;
  SEHours.MinValue   := 0;
  SEMinutes.MinValue := 0;

  SEDays.MaxValue    := 9999;
  SEHours.MaxValue   := 99;
  SEMinutes.MaxValue := 59;

  DTPStDate.OnChange  := DTPStDateChange;
  DTPStTime.OnChange  := DTPStTimeChange;
  DTPEndDate.OnChange := DTPEndDateChange;
  DTPEndTime.OnChange := DTPEndTimeChange;
  SEDays.OnChange     := SEDaysChange;
  SEHours.OnChange    := SEHoursChange;
  SEMinutes.OnChange  := SEMinutesChange;

  m_LockChanges := false;
end;

//----------------------------------------------------------------------------//

procedure TFCreateCapRes.CBoxDataFromResMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  InitCaptions;
end;

//----------------------------------------------------------------------------//

procedure TFCreateCapRes.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if (ModalResult <> mrAbort) and (ModalResult <> mrOk) then
  begin
    p_pl.ExitCompatModeInPlanCapRes;
    m_CapResMover.Abort;
    if Assigned(m_suppFnc) then m_suppFnc(m_suppObj);

    if Assigned(m_CapRes) then
      Exclude(m_capRes.m_ObjProp, objPr_MoveSel);
  end;

  if Assigned(m_Apa) then
    m_Apa.ClearMoveBackup;
  p_sc.ClearMoveOp;

  FMQMPlan.RefreshActiveTab;   // Refresh Plan
  Action    := caFree;
  FMCrtCapRes := nil
end;

//----------------------------------------------------------------------------//

procedure TFCreateCapRes.SetDataFromPlan(Apa: TMqmActArea; ToDate: TDateTime);
var
  Duration: integer;
begin
  if TMqmWrkCtr(Apa.p_WrkCtr).p_ReadOnly then
  begin
    MessageDlg(_('Not allowed to move objects on read only resources.'), mtWarning, [mbOK], 0);
    exit
  end;

  if CBWrkCtr.ItemIndex <> CBWrkCtr.Items.IndexOf(TMqmWrkCtr(Apa.p_WrkCtr).p_WrkCtrCode) then
  begin
    CBWrkCtr.ItemIndex := CBWrkCtr.Items.IndexOf(TMqmWrkCtr(Apa.p_WrkCtr).p_WrkCtrCode);
    CBWrkCtrChange(self)
  end;
  if CBResource.ItemIndex <> CBResource.Items.IndexOf(TMqmRes(Apa.p_Res).p_ResCode) then
  begin
    CBResource.ItemIndex := CBResource.Items.IndexOf(TMqmRes(Apa.p_Res).p_ResCode);
    //CBWrkCtrChange(self)
  end;
  {
  if CBProcess.ItemIndex <> CBProcess.Items.IndexOf(TMqmWrkCtr(Apa.p_WrkCtr).) then
  begin
    CBProcess.ItemIndex := CBProcess.Items.IndexOf(TMqmRes(Apa.p_Res).p_ResCode);
    //CBWrkCtrChange(self)
  end;
  }
  Duration := (SEDays.Value*24*60) + (SEHours.Value*60) + SEMinutes.Value;
  MoveTo(Apa, ToDate, Duration, false)
end;

//----------------------------------------------------------------------------//
{ saves the color chosen by the user for the Capacity reservation }
procedure TFCreateCapRes.CBClrDescChange(Sender: TObject);
begin
  if Assigned(m_CapRes) then
    m_CapRes.m_ColorIndex := CBClrDesc.ItemIndex;
end;
//----------------------------------------------------------------------------//

procedure TFCreateCapRes.CBWrkCtrChange(Sender: TObject);
var
  WrkCtr: TMqmWrkCtr;
  res : TMqmRes;
  i : integer;
begin
  CBProcess.Items.Clear;
  CBProcess.ItemIndex := -1;
  CBProcess.Text := '';
  CBResource.Items.Clear;
  CBResource.ItemIndex := -1;
  CBResource.Text := '';

  WrkCtr := TMqmWrkCtr(p_pl.FindWrkCtrByCode(CBWrkCtr.Text));

  if Assigned(WrkCtr)
  and (WrkCtr.P_GetProccesCount > 0) then
  begin
    for i := 0 to WrkCtr.P_GetProccesCount-1 do
      CBProcess.Items.Add(WrkCtr.P_GetProcess[i]);
    CBProcess.ItemIndex := 0;
  end;

  if Assigned(WrkCtr)
  and (WrkCtr.p_ResCount > 0) then
  begin
    for i := 0 to WrkCtr.p_ResCount-1 do
    begin
      res := TMqmRes(WrkCtr.p_Res[i]);
      CBResource.Items.Add(res.p_ResCode);
    end;
    CBresource.ItemIndex := 0;
  end ;

  if CBResource.ItemIndex <> CBResource.Items.IndexOf(TMqmRes(m_Apa.p_Res).p_ResCode) then
    CBResource.ItemIndex := CBResource.Items.IndexOf(TMqmRes(m_Apa.p_Res).p_ResCode);
end;

//----------------------------------------------------------------------------//

function TFCreateCapRes.MoveTo(Apa: TMqmActArea; Date: TDateTime; Duration: integer; isEnd: boolean): boolean;
begin
  Result := false;
  BtnOk.Enabled := true;
 // BtnOk.Color := $00F3B758;
  m_Apa := Apa;

  if not CheckData then
    exit;

  CheckProperties;
  UpdateObjData;
//  if not CheckUpMostCase then exit;
  if m_ErrorInProperties then
  begin
    MessageDlg(_('Property code errors, unable to create capacity reservation.'), mtWarning, [mbOK], 0);
    FMCrtCapRes.PageControl1.ActivePage := TabProp;
    exit;
  end;

  if Duration = -1 then
    Duration := (SEDays.Value*24*60) + (SEHours.Value*60) + SEMinutes.Value;

  EnableDisablField(false);

  if DTPStTime.Enabled = true then
  begin
    EnableDisablField(true);
    Exit
  end;

  if not m_CapResMover.ChangeTo(m_Apa, Date, Duration, isEnd) then
  begin
    if Assigned(m_suppFnc) then
      m_suppFnc(m_suppObj);
    BtnOk.Enabled := false;
   // BtnOk.Color := clGradientActiveCaption;
    EnableDisablField(true);
    exit;
  end;

  if Assigned(m_suppFnc) then
    m_suppFnc(m_suppObj);

  DTPStDate.DateTime  := m_CapRes.p_Start;
  DTPStTime.DateTime  := m_CapRes.p_Start;
  DTPEndDate.DateTime := m_CapRes.p_End;
  DTPEndTime.DateTime := m_CapRes.p_End;

  if SEDays.Value <> Trunc(m_CapRes.p_dur / 24 / 60) then
  begin
    m_ControlDaysChange := false;
    SEDays.Value    := Trunc(m_CapRes.p_dur / 24 / 60);
    m_ControlDaysChange := true;
  end;

  if SEHours.Value <> Trunc((m_CapRes.p_dur - SEDays.Value*24*60) / 60) then
  begin
     m_ControlHoursChange := false;
    SEHours.Value    := Trunc((m_CapRes.p_dur - SEDays.Value*24*60) / 60);
    m_ControlHoursChange := true;
  end;

  if SEMinutes.Value <> Trunc(m_CapRes.p_dur - SEDays.Value*24*60 - SEHours.Value * 60) then
  begin
     m_ControlMinutesChange := false;
    SEMinutes.Value    := Trunc(m_CapRes.p_dur - SEDays.Value*24*60 - SEHours.Value * 60);
    m_ControlMinutesChange := true;
  end;

 // SEDays.Value    := Trunc(m_CapRes.p_dur / 24 / 60);
 // SEHours.Value   := Trunc((m_CapRes.p_dur - SEDays.Value*24*60) / 60);
//  SEMinutes.Value := Trunc(m_CapRes.p_dur - SEDays.Value*24*60 - SEHours.Value * 60);


  EnableDisablField(true);
  BtnDetach.Enabled := true;
//  BtnDetach.Color := $00E1E1E1;
  Result := true;
end;

procedure TFCreateCapRes.PageControl1DrawTab(Control: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
begin
  with Control.Canvas do begin
   Font.Name := 'Montserrat';
    Brush.Color := clWhite;
    FillRect(Rect);
    TextOut(Rect.Left + Font.Size -5, Rect.Top + 2, (Control as TPageControl).Pages[TabIndex].Caption) ;
  end;
end;

//----------------------------------------------------------------------------//

function TFCreateCapRes.CheckData: boolean;
var
  Duration: integer;
begin
  Result := false;
  BtnOk.Enabled := Result;
//  BtnOk.Color := clGradientActiveCaption;
  Duration := (SEDays.Value*24*60) + (SEHours.Value*60) + SEMinutes.Value;

  if not Assigned(m_Apa)
  or (CBWrkCtr.Text = '')
  or (CBProcess.Text = '')
 then
  begin
    MessageDlg(_('No workcenter or process specified. Please select first.'), mtWarning, [mbOK], 0);
    exit;
  end;

  if (Duration <= 0) then
  begin
    MessageDlg(_('No duration specified for capacirty reservation.'), mtWarning, [mbOK], 0);
    exit;
  end;

  if (CBClrDesc.ItemIndex < 0)  then
  begin
    MessageDlg(_('No color description selected for capacity reservation.'), mtWarning, [mbOK], 0);
    exit;
  end;

  if TMqmRes(m_Apa.p_Res).CheckCompCapRes(m_CapRes) = CompValNotComp then
  begin
    MessageDlg(_('Resource not compatible.'), mtWarning, [mbOK], 0);
    exit;
  end;

  Result := true;
  BtnOk.Enabled := Result;
 // BtnOk.Color := $00F3B758;
end;

//----------------------------------------------------------------------------//

procedure TFCreateCapRes.UpdateObjData;
var
  i: integer;
begin
  with m_CapRes do
  begin
    m_type := cr_Normal;
    m_Comment := EdtComment.Text;
    m_UpMostCase := SpEdtUpToCase.Value;
    m_WCProc := CBProcess.Text;

    m_CapRes.m_ColorIndex := CBClrDesc.ItemIndex;
    m_CapRes.m_BrushColor := DBAppGlobals.CapResColors[m_CapRes.m_ColorIndex].int;
    m_CapRes.m_brdColor := DBAppGlobals.CapResColors[m_CapRes.m_ColorIndex].brd;
    m_CapRes.m_Dsc := DBAppGlobals.CapResColors[m_CapRes.m_ColorIndex].Dsc;

    m_propList.Clear;
    for i := 1 to m_PropComp.p_RowCount - 1 do
      if m_PropComp.p_GetPropVal[I] <> '' then
        m_propList.AddProperty(m_PropComp.P_GetPropVal[I], '', m_PropComp.GetPropDescVal(I));
  end;
end;

//----------------------------------------------------------------------------//

procedure TFCreateCapRes.BtnOkClick(Sender: TObject);
begin
  if not CheckData then
    exit;
  ModalResult := mrOk;
  UpdateObjData;
  if Assigned(m_CapRes) then
    Exclude(m_capRes.m_ObjProp, objPr_MoveSel);
//  if Assigned(m_exitFnc) then m_exitFnc(m_suppObj);
//  if ( m_fromGantt ) then  //if opened form from Gantt and not menu button
//    SetDataFromPlan(m_Apa,CapResSelectedDate);
  p_pl.ExitCompatModeInPlanCapRes;
  Close
end;

//----------------------------------------------------------------------------//

procedure TFCreateCapRes.BtnAbortClick(Sender: TObject);
begin
  ModalResult := mrAbort;
  p_pl.ExitCompatModeInPlanCapRes;
  m_CapResMover.Abort;
  if Assigned(m_suppFnc) then m_suppFnc(m_suppObj);

  if Assigned(m_CapRes) then
    Exclude(m_capRes.m_ObjProp, objPr_MoveSel);

//  if Assigned(m_exitFnc) then m_exitFnc(m_suppObj)
  Close;
end;

//----------------------------------------------------------------------------//

procedure TFCreateCapRes.FormCreate(Sender: TObject);
begin
  ScaleFormSize(Self, Screen.PixelsPerInch);
  TranslateComponent (self);

  ReShape(Self);
end;

//----------------------------------------------------------------------------//

procedure TFCreateCapRes.GetResourceProperties(Res: TMqmRes; ResProperties: TStrings );
var
  i:     integer;
  pId:      TPropId;
  mat1:     TOneDmatrix;
  mat2:     TTwoDmatrix;
  mtx:      TOrigMatrix;
  iProp:    integer;
  iProc:    integer;
  iCat:     integer;
  m_mtxList: TList;
  m_filterCat: String;

begin
  ResProperties.Clear;
  m_mtxList := TList.Create;
  Res.GetPropMtxs(m_mtxList, true);
  Res.m_resCat.GetPropMtxs(m_mtxList);
  m_filterCat := Res.m_ResCat.p_ResCatCode;

  for i := 0 to m_mtxList.Count-1 do
  begin
    mtx := TOrigMatrix(m_mtxList[i]);
    Assert((mtx.m_mtx <> CMX_code_prod)      and
           (mtx.m_mtx <> CMX_code_prod_proc) and
           (mtx.m_mtx <> CMX_code_prod_cat));

    case mtx.m_mtx of

    CMX_code:
      begin
        mat1 := TOneDmatrix(mtx);
        Assert(Assigned(mat1));

        for iProp := 0 to mat1.GetLev1Count - 1 do
        begin
          mat1.GetLev1Obj(iProp, pId);
          ResProperties.Add(GetPropCodeFromID(pId));//GetPropDescr(pId));
        end
      end;

    CMX_code_proc:
      begin
        mat2 := TTwoDmatrix(mtx);
        Assert(Assigned(mat2));

        for iProc := 0 to mat2.GetLev1Count - 1 do
          for iProp := 0 to mat2.GetLev2Count(iProc)-1 do
          begin
            mat2.GetLev2Obj(iProc, iProp, pId);
            ResProperties.Add(GetPropCodeFromID(pId));//GetPropDescr(pId));
          end
      end;

    CMX_code_cat:
      begin
        mat2 := TTwoDmatrix(mtx);
        Assert(Assigned(mat2));

        for iCat := 0 to mat2.GetLev1Count - 1 do
          for iProp := 0 to mat2.GetLev2Count(iCat)-1 do
          begin
            if mat2.GetLev1Key(iCat) <> m_filterCat then continue;
            mat2.GetLev2Obj(iCat, iProp, pId);
            ResProperties.Add(GetPropCodeFromID(pId));//GetPropDescr(pId));
           end
      end
    end
  end;

end;

//----------------------------------------------------------------------------//

procedure TFCreateCapRes.CheckProperties;
var
  i,j: integer;
  Res: TMqmRes;
  ResProperties: TStrings;
  Property_exists: boolean;
begin
  ResProperties := TStringList.Create;
  try
    res := TMqmRes(p_pl.FindResByCode(CBResource.Text));
    m_ErrorInProperties := false;

    GetResourceProperties(res,ResProperties);
    // loop over all our chosen properties
    for i := 1 to m_PropComp.p_RowCount - 1 do
    begin
      Property_exists := false;
      if m_PropComp.p_GetPropVal[i] <> '' then
      begin
      //loop over all resource properties
        for j := 0 to ResProperties.Count-1 do
        begin
          if m_PropComp.p_GetPropVal[i] = ResProperties.Strings[j] then
            Property_exists := true;
        end; //j
        if  not Property_exists then
        begin
          m_PropComp.setError(i);
          m_ErrorInProperties := true;
        end;
      end; //i
    end;//try

  finally
    ResProperties.Free;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFCreateCapRes.CBClrDescDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  str: string;
begin
  str := _(DBAppGlobals.CapResColors[Index].Dsc);

  CBClrDesc.Canvas.Font.Color := DBAppGlobals.CapResColors[Index].txt;
  CBClrDesc.Canvas.Brush.Color := DBAppGlobals.CapResColors[Index].int;
  CBClrDesc.Canvas.Pen.Color := DBAppGlobals.CapResColors[Index].brd;
  CBClrDesc.Canvas.TextRect(rect, rect.left, rect.top, str);
end;

//----------------------------------------------------------------------------//

procedure TFCreateCapRes.StartDateChanged;
var
  Duration: integer;
begin
  if m_LockChanges then exit;

  DTPStTime.Date := DTPStDate.Date;
  if Assigned(m_apa) then
  begin
     if not GBDuration.Enabled then
      Duration := getDur( DTPStTime.DateTime,DTPEndTime.DateTime)
    else
       Duration := (SEDays.Value*24*60) + (SEHours.Value*60) + SEMinutes.Value;
    MoveTo(m_Apa, DTPStTime.DateTime, Duration, false);
  end;
end;

//----------------------------------------------------------------------------//

procedure TFCreateCapRes.EnableDisablField(control: boolean);
begin
//  DTPStDate.Enabled := control;
  DTPStTime.Enabled := control;
  SEDays.Enabled := control;
  SEHours.Enabled := control;
  SEMinutes.Enabled := control;
//  DTPEndDate.Enabled := control;
  DTPEndTime.Enabled := control;
end;

//----------------------------------------------------------------------------//

function TFCreateCapRes.getDur(StDate, EndDate : TDateTime): Integer;
var  cal : TPGCALObj;
begin
   cal := m_Apa.GetCalendar;
   Result := trunc(cal.DiffWH(DTPStDate.DateTime, DTPEndTime.DateTime , m_Apa.m_CrossDownTmList)*60);
end;

procedure TFCreateCapRes.EndDateChanged;
var
  Duration: integer;
begin
  if m_LockChanges then exit;

  DTPEndTime.Date := DTPEndDate.Date;

  if not GBDuration.Enabled then
    Duration := getDur( DTPStTime.DateTime,DTPEndTime.DateTime)
  else
     Duration := (SEDays.Value*24*60) + (SEHours.Value*60) + SEMinutes.Value;

  if Assigned(m_apa) then
    MoveTo(m_Apa, DTPStTime.DateTime, Duration, false);

end;

//----------------------------------------------------------------------------//

procedure TFCreateCapRes.DurationChanged;
var
  Duration: integer;
begin
  if m_LockChanges then exit;

  Duration := (SEDays.Value*24*60) + (SEHours.Value*60) + SEMinutes.Value;

 if Duration = 0 then
 begin
   SEHours.Value := 1;
   Duration := 60;
 end;

  if Assigned(m_apa)
  and (Duration > 0) then
    MoveTo(m_Apa, DTPStTime.DateTime, Duration, false);
end;

//----------------------------------------------------------------------------//

procedure TFCreateCapRes.DTPStDateChange(Sender: TObject);
begin
  StartDateChanged;
end;

//----------------------------------------------------------------------------//

procedure TFCreateCapRes.DTPStTimeChange(Sender: TObject);
begin
  StartDateChanged;
end;

//----------------------------------------------------------------------------//

procedure TFCreateCapRes.DTPEndDateChange(Sender: TObject);
begin
  EndDateChanged;
end;

//----------------------------------------------------------------------------//

procedure TFCreateCapRes.DTPEndTimeChange(Sender: TObject);
begin
  EndDateChanged;
end;

//----------------------------------------------------------------------------//

procedure TFCreateCapRes.SEDaysChange(Sender: TObject);
begin
  if m_ControlDaysChange then
  begin
    m_ControlDaysChange := false;

    if SEDays.Value >= 0 then
      DurationChanged;

    m_ControlDaysChange := True;
  end
end;

//----------------------------------------------------------------------------//

procedure TFCreateCapRes.SEHoursChange(Sender: TObject);
begin
  if m_ControlHoursChange then
  begin
    m_ControlHoursChange := false;
   // if SEHours.Value > 23 then
   //   SEHours.Value := 23;

    if SEHours.Value >= 0 then
      DurationChanged;
    m_ControlHoursChange := true;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFCreateCapRes.SEMinutesChange(Sender: TObject);
begin
  if m_ControlMinutesChange then
  begin
    m_ControlMinutesChange := false;
    if SEMinutes.Value > 59 then
      SEMinutes.Value := 59;

    if SEMinutes.Value >= 0 then
      DurationChanged;
    m_ControlMinutesChange := true;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFCreateCapRes.FormShow(Sender: TObject);
begin
end;

//----------------------------------------------------------------------------//

procedure TFCreateCapRes.BtnDetachClick(Sender: TObject);
begin
  m_CapResMover.DetachFromApa;
  FMQMPlan.RefreshActiveTab;

  BtnOk.Enabled := false;
 // BtnOk.Color := clGradientActiveCaption;

  BtnDetach.Enabled := false;
 // BtnDetach.Color := clGradientActiveCaption;
end;

//----------------------------------------------------------------------------//

initialization

  FMCrtCapRes := nil;


//----------------------------------------------------------------------------//

end.


