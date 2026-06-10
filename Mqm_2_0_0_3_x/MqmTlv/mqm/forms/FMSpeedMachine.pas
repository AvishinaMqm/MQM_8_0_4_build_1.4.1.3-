unit FMSpeedMachine;

interface

uses
  UReShape, cxButtons, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UMSchedContFunc, Vcl.StdCtrls, UMWarp,
  Vcl.ComCtrls, cxGraphics, dxUIAClasses, cxLookAndFeels, cxLookAndFeelPainters,
  Vcl.Menus;

type
  TSpeedMachine = class(TForm)
    PageControlSpeedChange: TPageControl;
    TabSheetJobSpeed: TTabSheet;
    BtnAbort: TcxButton;
    BtnOk: TcxButton;
    BtnRmvOveridn: TcxButton;
    TabSheetWarpSpeed: TTabSheet;
    Label1: TLabel;
    LabelWarpSpeed: TLabel;
    EditNewSpeedWarp: TEdit;
    EditStandardSpeedWarp: TEdit;
    LabelWarpStandardSpeed: TLabel;
    LblChangedSpeadWarp: TLabel;
    EditChangedSpeedWarp: TEdit;
    ButtonWarpOk: TcxButton;
    ButtonWarpAbort: TcxButton;
    BtnRmvOveridnSpeedWarp: TcxButton;
    LblWarpUm: TLabel;
    LabelWarpStandardSetup: TLabel;
    EditStandardSetUpWarp: TEdit;
    LblChangedSetUpWarp: TLabel;
    EditChangedSetUpWarp: TEdit;
    LblNewSetupWarp: TLabel;
    EditNewSetupWarp: TEdit;
    BtnRmvOveridnSetupWarp: TcxButton;
    LblCurrentSetup: TLabel;
    EdtCurrentSetup: TEdit;
    LblChangedSetup: TLabel;
    EdtChangedSetup: TEdit;
    LblSetUp: TLabel;
    EditNewSetup: TEdit;
    GroupBoxSetUpStep: TGroupBox;
    GroupBoxSetUpJob: TGroupBox;
    Label2: TLabel;
    eJobNewSetup: TEdit;
    Label3: TLabel;
    eJobSetupChanged: TEdit;
    GroupBoxSpeedStep: TGroupBox;
    LblUN: TLabel;
    LblUM: TLabel;
    LblChangedSpead: TLabel;
    LblCurrentSpead: TLabel;
    EditNewSpeed: TEdit;
    EdtCurrentSpeed: TEdit;
    EdtChangedSpeed: TEdit;
    procedure BtnOkClick(Sender: TObject);
    procedure BtnWarpOkClick(Sender: TObject);
    procedure BtnAbortClick(Sender: TObject);
    procedure EditNewSpeedKeyPress(Sender: TObject; var Key: Char);
    function  CheckData : boolean;
    function  CheckWarpData : boolean;
    procedure btnSetupOkClick(Sender: TObject);
    function CheckDataJob: boolean;
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    m_id, m_IdSon : TSchedId;
    m_Warp : TMqmWarp;
    m_QtyStep, m_QtyWarp : double;
    m_StandardSpeed : double;
    m_StandardSetup : double;
    m_OverridenSpeed : double;
    m_OverridenSetup : double;
    m_DurationOrig, m_SetupOrig, m_NewSetupJob : double;
    procedure CalcStandardSpeed;
    procedure CalcStandardSpeedNonScheduledJob;
    procedure CalcStandardSpeedAndSetupWarp;

    { Private declarations }
  public
    constructor CreateSpeedMachine(AOwner: TComponent; Id : TSchedId);
    constructor CreateSpeedWarpMachine(AOwner: TComponent; Warp: TMqmWarp; Id : TSchedId);
  end;

implementation

{$R *.dfm}

{ TSpeedMachine }

uses UMObjCont, UMRes, UMDurObj, UMActArea, gnugettext, UMDescUm, UMSchedCont, UMSchedOnPlan;

//----------------------------------------------------------------------------//

procedure TSpeedMachine.BtnAbortClick(Sender: TObject);
begin
  ModalResult := mrAbort;
end;

//----------------------------------------------------------------------------//

procedure TSpeedMachine.BtnOkClick(Sender: TObject);
var
  IniQty : variant;
  dataType : CBinColValType;
  NewSpeed, NewTime, NewSetup, NewSetupJob : currency;
  List : TList;
  I : Integer;
begin
  if (Tbutton(Sender).Name = 'BtnOk') and not checkdata and not checkdataJob then
  begin
    ModalResult := mrNone;
    Showmessage(_('Please insert a new valid speed/setup !'));
    exit;
  end;

//  p_sc.GetFldValue(m_Id, CSC_ProdReq, Request, dataType);
//  p_sc.GetFldValue(m_Id, CSC_ProdStep, step, dataType);

  if TEdit(Sender).name = 'BtnRmvOveridn' then
    p_sc.UpdateMachineSpeedAndSetup(m_id, 0, m_DurationOrig, m_SetupOrig, m_NewSetupJob, true)
  else
  begin
    if (EditNewSpeed.Text <> '') or ((EditNewSetup.Text <> '') or (eJobNewSetup.Text <> '')) then
    begin
      NewTime  := -1;
      NewSpeed := -1;
      NewSetup := -1;
      NewSetupJob := -1;
      if (EditNewSpeed.Text <> '') then
      begin
        NewSpeed := StrToFloat(EditNewSpeed.Text);
        NewSpeed := trunc(NewSpeed*10000)/10000;
        NewTime := m_QtyStep*NewSpeed;
        NewTime := trunc(NewTime*10000)/10000;
      end;
      if EditNewSetup.Text <> '' then
         NewSetup := StrToFloat(EditNewSetup.Text);

      if eJobNewSetup.Text <> '' then
         NewSetupJob := StrToFloat(eJobNewSetup.Text);

      p_sc.UpdateMachineSpeedAndSetup(m_id, NewSpeed, NewTime, NewSetup, NewSetupJob, false)
    end;

    p_pl.EnterCompatModeInPlan(m_id);
    p_pl.ExitCompatModeInPlan;
  end;

  ModalResult := mrOk;
end;

procedure TSpeedMachine.btnSetupOkClick(Sender: TObject);
begin
  
end;

//----------------------------------------------------------------------------//

procedure TSpeedMachine.CalcStandardSpeed;
var
  Res : TMqmRes;
  supMinBase, supMinBaseOrig:   double;
  TmgDescr: string;
  TmgMSC: string;
  Qty, duration, durationOrig : double;
  StandardSpeed, ChangedSpeed, StandardSetup, ChangedSetup, StandardJobSetup : currency;
begin

  if m_IdSon <> CSchedIDnull then
  begin
    Res := TMqmRes(TMqmActArea(p_sc.getExtLinkPtr(m_IdSon)).p_res);
    p_pl.EnterCompatModeInPlan(m_IdSon)
  end
  else
  begin
    Res := TMqmRes(TMqmActArea(p_sc.getExtLinkPtr(m_id)).p_res);
    p_pl.EnterCompatModeInPlan(m_id)
  end;

  p_pl.SetTmgTargetRes(TMqmRes(Res));
  p_pl.GetMainTimings(supMinBase, duration, TmgDescr, TmgMSC);
  p_pl.GetMainTimingsOrig(supMinBaseOrig, durationOrig, TmgDescr, TmgMSC);

  m_DurationOrig := durationOrig;
  m_SetupOrig := supMinBaseOrig;
  m_NewSetupJob := p_sc.GetStandardSetup(m_id);

  p_pl.ExitCompatModeInPlan;

  ChangedSpeed := duration/m_QtyStep;
  ChangedSpeed := trunc(ChangedSpeed*10000)/10000;
  EdtChangedSpeed.Text := FloatToStr(ChangedSpeed);

  StandardSpeed := durationOrig/m_QtyStep;
  StandardSpeed := trunc(StandardSpeed*10000)/10000;
  EdtCurrentSpeed.Text := FloatToStr(StandardSpeed);

  EdtChangedSetup.Text := FloatToStr(supMinBase);
  EdtCurrentSetup.Text := FloatToStr(supMinBaseOrig);

  eJobSetupChanged.Text := FloatToStr(supMinBase);

  if m_NewSetupJob = -1 then
    eJobSetupChanged.Text := ''
  else
    eJobSetupChanged.Text := FloatToStr(m_NewSetupJob);

  if (EdtChangedSpeed.Text = EdtCurrentSpeed.Text) and (EdtChangedSetup.Text = EdtCurrentSetup.Text)
    and (eJobNewSetup.Text = eJobSetupChanged.Text) then
    BtnRmvOveridn.Enabled := false
  else
    BtnRmvOveridn.Enabled := true;

  if EdtChangedSpeed.Text = EdtCurrentSpeed.Text then
  begin
    EdtChangedSpeed.Visible := false;
    LblChangedSpead.Visible  := false
  end;

  if (EdtChangedSetup.Text = EdtCurrentSetup.Text) or (m_NewSetupJob > -1) then
  begin
    EdtChangedSetup.Visible := false;
    LblChangedsetup.Visible  := false
  end;

  if p_sc.IsGroup(M_id) then
  begin
    if p_sc.CheckIfGroupChilderenContainSubSteps(M_id) then
    begin
      GroupBoxSpeedStep.Visible := false;
      GroupBoxSetUpStep.Visible := false;
      GroupBoxSetUpJob.Left := GroupBoxSpeedStep.Left;
      GroupBoxSetUpJob.Top := GroupBoxSpeedStep.Top
    end;
  end
  else
  if (p_sc.GetJobNumBrothers(m_Id) > 1) then
  begin
    GroupBoxSpeedStep.Visible := false;
    GroupBoxSetUpStep.Visible := false;
    GroupBoxSetUpJob.Left := GroupBoxSpeedStep.Left;
    GroupBoxSetUpJob.Top := GroupBoxSpeedStep.Top;
  end;
end;

//----------------------------------------------------------------------------//

procedure TSpeedMachine.CalcStandardSpeedNonScheduledJob;
var
  List : TList;
  PRecTiming : PTRecTiming;
  Qty, duration, setup, jobSetup, durationOrig, NewTime, SetUpOrig : double;
  StandardSpeed, ChangedSpeed : currency;
  I : Integer;
  DisplayStanDardTime, DisplayStanDardSetup : boolean;
  IsSpeedChanged, IsSetUpChanged, IsJobSetUpChanged : boolean;
begin
  DisplayStanDardTime := true;
  DisplayStanDardSetup := true;
  List := p_sc.GetProdReqDetTimeList(m_id);

  if List.Count > 1 then
  begin
    for I := 1 to List.Count - 1 do
    begin
      if PTRecTiming(List[0]).exeTime <> PTRecTiming(List[I]).exeTime then
      begin
        DisplayStanDardTime := false;
        break
      end;
    end;
  end;

  if List.Count > 1 then
  begin
    for I := 1 to List.Count - 1 do
    begin
      if PTRecTiming(List[0]).supTime <> PTRecTiming(List[I]).supTime then
      begin
        DisplayStanDardSetup := false;
        break
      end;
    end;
  end;

  if List.Count = 0 then
  begin
    DisplayStanDardTime := false;
    DisplayStanDardSetup := false
  end;

  if DisplayStanDardTime then
    durationOrig := PTRecTiming(List[0]).exeTime;

  if DisplayStanDardSetup then
    SetUpOrig := PTRecTiming(List[0]).supTime;

  if m_IdSon <> CSchedIDnull then
    p_sc.GetNewTimeIfSpeedChanged(m_IdSon, duration, setup, jobsetup, IsSpeedChanged, IsSetUpChanged, IsJobSetUpChanged)
  else
    p_sc.GetNewTimeIfSpeedChanged(M_id, duration, setup, jobsetup, IsSpeedChanged, IsSetUpChanged, IsJobSetUpChanged);

  if duration = 0 then
  begin
//    BtnRmvOveridn.Enabled := false;
    EdtChangedSpeed.Visible := false;
    LblChangedSpead.Visible  := false
  end;

  ChangedSpeed := duration/m_QtyStep;
  ChangedSpeed := trunc(ChangedSpeed*10000)/10000;
  EdtChangedSpeed.Text := FloatToStr(ChangedSpeed);

  if DisplayStanDardTime then
  begin
    StandardSpeed := durationOrig/m_QtyStep;
    StandardSpeed := trunc(StandardSpeed*10000)/10000;
    EdtCurrentSpeed.Text := FloatToStr(StandardSpeed);
  end
  else
    EdtCurrentSpeed.Text := _('Depending on schedule');

  EdtChangedSetup.Text := FloatToStr(setup);

  if Setup = 0 then
  begin
    EdtChangedSetup.Visible := false;
    LblChangedsetup.Visible  := false
  end;

  if (duration = 0) and (Setup = 0) then
     BtnRmvOveridn.Enabled := false;

  if DisplayStanDardSetup then
    EdtCurrentSetup.Text := FloatToStr(SetUpOrig);

  if JobSetup = 0 then
  begin
    eJobSetupChanged.Visible := false;
    label3.Visible  := false
  end;

  m_NewSetupJob := p_sc.GetStandardSetup(m_id);

  if m_NewSetupJob = -1 then
    eJobSetupChanged.Text := ''
  else
  begin
    eJobSetupChanged.Visible := true;
    eJobSetupChanged.Text := FloatToStr(m_NewSetupJob);
  end;

  if (EdtChangedSpeed.Text = EdtCurrentSpeed.Text) and (EdtChangedSetup.Text = EdtCurrentSetup.Text)
    and (eJobNewSetup.Text = eJobSetupChanged.Text) then
    BtnRmvOveridn.Enabled := false
  else
    BtnRmvOveridn.Enabled := true;

  if EdtChangedSpeed.Text = EdtCurrentSpeed.Text then
  begin
    EdtChangedSpeed.Visible := false;
    LblChangedSpead.Visible  := false
  end;

  if (EdtChangedSetup.Text = EdtCurrentSetup.Text) or (m_NewSetupJob > -1) then
  begin
    EdtChangedSetup.Visible := false;
    LblChangedsetup.Visible  := false
  end;

  if p_sc.IsGroup(M_id) then
  begin
    if p_sc.CheckIfGroupChilderenContainSubSteps(M_id) then
    begin
      GroupBoxSpeedStep.Visible := false;
      GroupBoxSetUpStep.Visible := false;
      GroupBoxSetUpJob.Left := GroupBoxSpeedStep.Left;
      GroupBoxSetUpJob.Top := GroupBoxSpeedStep.Top
    end;
  end
  else
  if (p_sc.GetJobNumBrothers(m_Id) > 1) then
  begin
    GroupBoxSpeedStep.Visible := false;
    GroupBoxSetUpStep.Visible := false;
    GroupBoxSetUpJob.Left := GroupBoxSpeedStep.Left;
    GroupBoxSetUpJob.Top := GroupBoxSpeedStep.Top;
  end;

end;

//----------------------------------------------------------------------------//

function TSpeedMachine.CheckDataJob: boolean;
begin
  Result := true;
  if Trim(eJobNewSetup.Text) = '' then
    Result := false;
end;

//----------------------------------------------------------------------------//

function TSpeedMachine.CheckData: boolean;
begin
  Result := true;
  if (Trim(EditNewSpeed.Text) = '') and (Trim(EditNewSetup.Text) = '') then
    Result := false;
  if (EditNewSpeed.Text = '0') then//(EditNewSetup.Text = '0') then
    Result := false;
end;

//----------------------------------------------------------------------------//

function TSpeedMachine.CheckWarpData: boolean;
begin
  Result := true;
  if ((Trim(EditNewSpeedWarp.Text) = '') or (EditNewSpeedWarp.Text = '0')) and
     ((Trim(EditNewSetupWarp.Text) = '') or (EditNewSetupWarp.Text = '0')) then
    Result := false;
end;

//----------------------------------------------------------------------------//

constructor TSpeedMachine.CreateSpeedMachine(AOwner: TComponent; Id: TSchedId);
var
  List : TList;
  NotScheduleWithOneTimeRecord : boolean;
  value: variant;
  dataType: CBinColValType;
  IdSon : TSchedId;
begin
  inherited Create(AOwner);
  PageControlSpeedChange.Pages[1].TabVisible := false;
  m_id := id;
  m_IdSon := CSchedIDnull;
  m_DurationOrig := 0;
  m_SetupOrig := 0;

  if p_sc.IsGroup(M_id) then
  begin
    IdSon := p_sc.GetGrpSon(m_id, 0);
    p_sc.GetFldValue(IdSon, CSC_Continues_parallel, value, dataType);
    if not value then
    begin
      p_sc.GetFldValue(IdSon, CSC_IniQty, value, dataType);
      m_QtyStep := value;
      m_IdSon := IdSon;
    end;
  end
  else
  begin
    p_sc.GetFldValue(m_Id, CSC_IniQty, value, dataType);
    m_QtyStep := value;
  end;

  LblUM.Caption :=  '/' + GetSUmDesc(p_sc.GetFldDescr(m_id, CSC_ProdUM, false));
  if p_sc.GetExtLinkPtr(id) = nil then
    CalcStandardSpeedNonScheduledJob
  else
    CalcStandardSpeed;
  ReShape(self);
end;

//----------------------------------------------------------------------------//
       // Warp handling
//----------------------------------------------------------------------------//

procedure TSpeedMachine.EditNewSpeedKeyPress(Sender: TObject; var Key: Char);
begin

     if TEdit(Sender).Name = 'EditNewSetup' then
    begin
      if eJobNewSetup.Text <> '' then
      begin
        MessageDlg(_('You cannot change because Job Setup exists'), mtError, [mbOk], 0);
        abort;
      end;

      if (Key = chr(44)) or (Key = chr(46)) then abort;
    end;

    if TEdit(Sender).Name = 'eJobNewSetup' then
    begin
      if EditNewSetup.Text <> '' then
      begin
        MessageDlg(_('You cannot change because Step Setup exists'), mtError, [mbOk], 0);
        abort;
      end;

      if (Key = chr(44)) or (Key = chr(46)) then abort;
    end;

  if FormatSettings.DecimalSeparator = ',' then
  begin
    if Key = chr(46) then // '.'
       Key := chr(44);

    if not ((CharInSet(Key, ['0'..'9'])) or (key = chr(vk_Back)) or (Key = chr(24)) or (Key = chr(44))) then
      abort;
  end
  else
  begin

    if Key = chr(44) then // ','
       Key := chr(46);

    if not ((CharInSet(Key, ['0'..'9'])) or (key = chr(vk_Back)) or (Key = chr(24)) or (Key = chr(46))) then
      abort;
  end;
end;

//----------------------------------------------------------------------------//

constructor TSpeedMachine.CreateSpeedWarpMachine(AOwner: TComponent; Warp: TMqmWarp; Id : TSchedId);
var
  List : TList;
  NotScheduleWithOneTimeRecord : boolean;
  valueItemType, valueProduct : variant;
  dataType: CBinColValType;
  WarpInfo: TPWarpInfo;
begin
  inherited Create(AOwner);
  PageControlSpeedChange.Pages[0].TabVisible := false;
  m_id := id;
  m_DurationOrig := 0;
  m_SetupOrig := 0;
  m_Warp := Warp;
  p_sc.GetFldValue(m_id, CSC_Mat_Item_Type, valueItemType, dataType);
  p_sc.GetFldValue(m_id, CSC_Mat_PRODUCT_CODE, valueProduct, dataType);
  TabSheetWarpSpeed.Caption := valueItemType + '   ' + valueProduct;

  p_sc.GetWarpInfo(m_id, WarpInfo);

  LblWarpUm.Caption := ' / ' + WarpInfo.UM; //' / ' + GetSUmDesc(p_sc.GetFldDescr(m_id, CSC_ProdUM, false));
  m_QtyWarp       := WarpInfo.quant;
  m_StandardSpeed := WarpInfo.StandardSpeedInminutePerUoM;
  m_StandardSetup := WarpInfo.Standard_Setup;
  m_OverridenSpeed := WarpInfo.MATERIAL_Overriden_Speed;
  m_OverridenSetup := WarpInfo.MATERIAL_Overriden_Setup_Time;

  CalcStandardSpeedAndSetupWarp;
  ReShape(self);
end;

//----------------------------------------------------------------------------//

procedure TSpeedMachine.CalcStandardSpeedAndSetupWarp;
var
  SpeedMinPerUM, qty, duration : double;
  TempExt : Extended;
  valueStandard : variant;
  dataType: CBinColValType;
begin
  EditStandardSpeedWarp.text := FloatToStr(m_StandardSpeed);
  EditStandardSetUpWarp.text := Floattostr(m_StandardSetup);
  EditChangedSpeedWarp.Text := Floattostr(m_OverridenSpeed);
  EditChangedSetUpWarp.Text := Floattostr(m_OverridenSetup);

  if (EditChangedSpeedWarp.Text <> '') and (EditChangedSpeedWarp.Text = '0') then
  begin
    BtnRmvOveridnSpeedWarp.Enabled := false;
    EditChangedSpeedWarp.Visible := false;
    LblChangedSpeadWarp.Visible  := false
  end
  else
  begin
    BtnRmvOveridnSpeedWarp.Enabled := true;
    EditChangedSpeedWarp.Visible := true;
    LblChangedSpeadWarp.Visible  := true
  end;

  if (EditChangedSetUpWarp.Text <> '') and (EditChangedSetUpWarp.Text = '0') then
  begin
    BtnRmvOveridnSetUpWarp.Enabled := false;
    EditChangedSetUpWarp.Visible := false;
    LblChangedSetUpWarp.Visible  := false
  end
  else
  begin
    BtnRmvOveridnSetUpWarp.Enabled := true;
    EditChangedSetUpWarp.Visible := true;
    LblChangedSetUpWarp.Visible  := true
  end;
end;

//----------------------------------------------------------------------------//

procedure TSpeedMachine.BtnWarpOkClick;
var
  NewSpeed, NewSetup, NewTime : double;
  TempExt : Extended;
  S, TempStrSpeed, TempStrNewTime, TempStrSetup : string;
begin
  NewSpeed := 0;
  NewSetup := 0;
  NewTime  := 0;
  if (Tbutton(Sender).Name = 'ButtonWarpOk') and not CheckWarpData then
  begin
    ModalResult := mrNone;
    Showmessage(_('Please insert a new valid speed/setup !'));
    exit;
  end;

  if TEdit(Sender).name = 'BtnRmvOveridnSpeedWarp' then
  begin
//    m_Warp.p_durDouble := m_Qty * m_StandardSpeed;
    p_sc.UpdateUpdateMachineSpeedAndSetUpWarp(m_id, true, 0, 0);
  end
  else
  begin
    if EditNewSpeedWarp.Text <> '' then
    begin
      NewSpeed := StrToFloat(EditNewSpeedWarp.Text);
      TempExt := Frac(NewSpeed);
      S := FloatToStr(TempExt);
      if Length(S) > 5 then
      begin
        S := Copy(s, 2, 5);
        TempStrSpeed := FloatToStr(trunc(NewSpeed));
        TempStrSpeed := TempStrSpeed + S;
        NewSpeed := StrToFloat(TempStrSpeed);
      end;

      NewTime := m_QtyWarp*NewSpeed;
      TempExt := Frac(NewTime);
      S := FloatToStr(TempExt);
      if Length(S) > 5 then
      begin
        S := Copy(s, 2, 5);
        TempStrNewTime := FloatToStr(trunc(NewTime));
        TempStrNewTime := TempStrNewTime + S;
        NewTime := StrToFloat(TempStrNewTime);
      end;

      //m_Warp.p_durDouble := NewTime;
      p_sc.UpdateUpdateMachineSpeedAndSetUpWarp(m_id, true, NewSpeed, 0);
    end;
  end;

  if TEdit(Sender).name = 'BtnRmvOveridnSetupWarp' then
  begin
    //m_Warp.p_durDouble := m_Qty * m_StandardSetup;
    p_sc.UpdateUpdateMachineSpeedAndSetUpWarp(m_id, false, 0, 0);
  end
  else
  begin
    if EditNewSetupWarp.Text <> '' then
    begin
      NewSetup := StrToFloat(EditNewSetupWarp.Text);
      TempExt := Frac(NewSetup);
      S := FloatToStr(TempExt);
      if Length(S) > 5 then
      begin
        S := Copy(s, 2, 5);
        TempStrSetup := FloatToStr(trunc(NewSpeed));
        TempStrSetup := TempStrSetup + S;
        NewSetup := StrToFloat(TempStrSetup);
      end;

      NewTime := m_QtyWarp*NewSetup;
      TempExt := Frac(NewTime);
      S := FloatToStr(TempExt);
      if Length(S) > 5 then
      begin
        S := Copy(s, 2, 5);
        TempStrNewTime := FloatToStr(trunc(NewTime));
        TempStrNewTime := TempStrNewTime + S;
        NewTime := StrToFloat(TempStrNewTime);
      end;

     // m_Warp.p_durDouble := NewTime;
      p_sc.UpdateUpdateMachineSpeedAndSetUpWarp(m_id, false, 0, NewSetup);
    end;
  end;

  if Assigned(m_Warp) then
    m_Warp.m_status := CDUR_modi
  else
  begin
    p_pl.UpdateNonScheduleObjWarp(m_id)
  end;

  ModalResult := mrOk;
end;

procedure TSpeedMachine.Button3Click(Sender: TObject);
begin
  ModalResult := mrAbort;
end;

//----------------------------------------------------------------------------//

procedure TSpeedMachine.FormCreate(Sender: TObject);
begin
  ReShape(Self);
end;

//----------------------------------------------------------------------------//

end.
