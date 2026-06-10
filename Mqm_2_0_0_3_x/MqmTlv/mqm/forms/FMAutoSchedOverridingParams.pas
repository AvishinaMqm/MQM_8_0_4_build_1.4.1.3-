unit FMAutoSchedOverridingParams;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, UMSchedContFunc, UMAutoSchedCfg, Buttons,
  ExtCtrls, Spin,UReShape, ExSpinedit, cxButtons, cxGraphics, dxUIAClasses, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit,
  cxMaskEdit, cxDropDownEdit, cxCustomListBox, cxListBox;

type
  TAutoSeqOverridingParams = class(TForm)
    PageControl1: TPageControl;
    TabSheetRules: TTabSheet;
    GBSchedRange: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    SEdtAfterLatDays: TexSpinEdit;
    SEdtBefEarlDays: TexSpinEdit;
    RGBeforeEarlDate: TRadioGroup;
    RGAfterLatDate: TRadioGroup;
    SEdtBefEarlHours: TexSpinEdit;
    SEdtBefEarlMinutes: TexSpinEdit;
    SEdtAfterLatHours: TexSpinEdit;
    SEdtAfterLatMinutes: TexSpinEdit;
    CBUnscheduleBefore: TCheckBox;
    CBInfiniteCapacity: TCheckBox;
    GroupBox1: TGroupBox;
    RGSchedWOMaterials: TRadioGroup;
    RGSchedWOAddResources: TRadioGroup;
    GBForcedDateSelection: TGroupBox;
    CBScheduleWithinTheFram: TCheckBox;
    DatePickerWcFrom: TDateTimePicker;
    CBShorterJobsEndAfterFramEnd: TCheckBox;
    DateWcPickerToDate: TDateTimePicker;
    TimeWcFromPicker: TDateTimePicker;
    TimePickerWcTo: TDateTimePicker;
    CBSelectedWc: TCheckBox;
    LblLimitToWorkCenter: TLabel;
    LblFrameBegin: TLabel;
    LblFrameEnd: TLabel;
    CBLargerJobsCanStartAfterFrameBegins: TCheckBox;
    RGIgnoreRightOverlapping: TRadioGroup;
    RGIgnoreLeftOverlapping: TRadioGroup;
    GBAutoSeqConfig: TGroupBox;
    CombBoxCfg: TComboBox;
    CBWorkCenterConfiguration: TCheckBox;
    CBLinkedReq: TCheckBox;
    Panel1: TPanel;
    BtnAbo: TBitBtn;
    BitBtn1: TBitBtn;
    BtnOk: TcxButton;
    btnAbort: TcxButton;
    cbWCList: TcxListBox;
    procedure FormCreate(Sender: TObject);
    procedure CombBoxCfgChange(Sender: TObject);
    procedure SetParamsToCurrentConfig;
    procedure RGBeforeEarlDateClick(Sender: TObject);
    procedure RGAfterLatDateClick(Sender: TObject);
    procedure CBWorkCenterConfigurationClick(Sender: TObject);
    procedure CBLinkedReqClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CBWorkCenterConfigurationMouseLeave(Sender: TObject);
    procedure CBSelectedWcClick(Sender: TObject);
    procedure CBScheduleWithinTheFramClick(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure btnAbortClick(Sender: TObject);

  private
    UnCheckWorkCenterConfiguration : boolean;
    m_formShow : boolean;
    m_MoveLinkedRequest : boolean;
    m_wcCode: string;
    m_SavedBeforeLowLimit, m_SavedTollBeforeLowLimit,
      m_SavedTollBeforeLowLimitHours, m_SavedTollBeforeLowLimitMinutes: Integer;
    m_SavedAfterHighLimit, m_SavedTollAfterHighLimit,
      m_SavedTollAfterHighLimitHours, m_SavedTollAfterHighLimitMinutes: Integer;
    m_SavedSplitSchedByBatchSize: TSplitAutoJobs;
    m_CurrAutoSchedCfg: PTAutoSchedCfg;

    m_SlotGroup : Integer;
    m_GroupName : String;
    { Private declarations }
  public
    constructor CreateAutoSeqOverridingParams(AOwner: Tcomponent; MoveLinkedRequest : boolean);
    procedure GetUpdatedWcEarliestLatestDates(var EarliestStart: TDateTime;
      var LatestEnd: TDateTime);
    function GetParamsAutoCfg: string;
    procedure OverridingCurrParameters(CurrAutoSchedCfg: PTAutoSchedCfg);
    procedure CleanOverridingCurrParameters(CurrAutoSchedCfg: PTAutoSchedCfg);

    { Public declarations }
  end;

implementation

{$R *.dfm}

uses

  UMSchedCont,
  FMMainPlan,
  gnugettext,
  FMAutoSchedWorkCenterCfg,
  UGWorkCentersDrawSlot,
  UMWkCtr,
  UMObjCont,
  UMPlanTbs;

{ TAutoSeqOverridingParams }

// ----------------------------------------------------------------------------------------------

procedure TAutoSeqOverridingParams.CombBoxCfgChange(Sender: TObject);
begin
  m_CurrAutoSchedCfg := GetAutoSchedCfg(CombBoxCfg.Items[CombBoxCfg.ItemIndex]);
  if not Assigned(m_CurrAutoSchedCfg) then
    m_CurrAutoSchedCfg := GetAutoSchedCfg('DEFAULT');
//  SetParamsToCurrentConfig;
end;

// ----------------------------------------------------------------------------------------------

procedure TAutoSeqOverridingParams.SetParamsToCurrentConfig;
begin
//  RGBeforeEarlDate.ItemIndex := m_CurrAutoSchedCfg.m_BeforeLowLimit;
//  SEdtBefEarlDays.Value := m_CurrAutoSchedCfg.m_TollBeforeLowLimit;
//  SEdtBefEarlHours.Value := m_CurrAutoSchedCfg.m_TollBeforeLowLimitHours;
//  SEdtBefEarlMinutes.Value := m_CurrAutoSchedCfg.m_TollBeforeLowLimitMinutes;

//  RGAfterLatDate.ItemIndex := m_CurrAutoSchedCfg.m_AfterHighLimit;
//  SEdtAfterLatDays.Value := m_CurrAutoSchedCfg.m_TollAfterHighLimit;
//  SEdtAfterLatHours.Value := m_CurrAutoSchedCfg.m_TollAfterHighLimitHours;
//  SEdtAfterLatMinutes.Value := m_CurrAutoSchedCfg.m_TollAfterHighLimitMinutes;
end;

// ----------------------------------------------------------------------------------------------

constructor TAutoSeqOverridingParams.CreateAutoSeqOverridingParams
  (AOwner: Tcomponent; MoveLinkedRequest : boolean);
begin
  inherited create(AOwner);
  m_MoveLinkedRequest := MoveLinkedRequest
end;

// ----------------------------------------------------------------------------------------------

procedure TAutoSeqOverridingParams.FormCreate(Sender: TObject);
var
  DatesInfo: TSQDatesInfo;
  i, Index: Integer;
  Cfg: PTAutoSchedCfg;
  MQMPlan: TFMQMPlan;
begin
  MQMPlan := GetPlanView;
  m_wcCode := '';
  m_SlotGroup := 0;
  MQMPlan.SetSelectionSlotOnActiveTab;
  CBSelectedWc.Enabled := true;
  DatePickerWcFrom.date := date;
  DateWcPickerToDate.date := date + 2 * 365;

  if Assigned(MQMPlan.m_SelectedListWrkCtrPopUp) and
    (MQMPlan.m_SelectedListWrkCtrPopUp.Count = 1) and
    (PTSelectedParam(MQMPlan.m_SelectedListWrkCtrPopUp[0]).S_WkCtr <> nil) then
  begin
    CBSelectedWc.Visible := True;
    cbWcList.Visible := False;
    CBSelectedWc.Brush.Color := ($00DDFFFD);
    CBSelectedWc.Font.Color := Clred;
    CBSelectedWc.Checked := true;
    CBSelectedWc.Caption :=
      TMqmWrkCtr(PTSelectedParam(MQMPlan.m_SelectedListWrkCtrPopUp[0]).S_WkCtr)
      .p_WrkCtrLDesc;
    m_wcCode := TMqmWrkCtr(PTSelectedParam(MQMPlan.m_SelectedListWrkCtrPopUp[0])
      .S_WkCtr).p_WrkCtrCode;
    DatePickerWcFrom.DateTime :=
      PTSelectedParam(MQMPlan.m_SelectedListWrkCtrPopUp[0]).S_startDt;
    DateWcPickerToDate.DateTime :=
      PTSelectedParam(MQMPlan.m_SelectedListWrkCtrPopUp[0]).S_endDt - 1;
    RGBeforeEarlDate.ItemIndex := 1;
    RGAfterLatDate.ItemIndex := 1;
    if m_MoveLinkedRequest then
    begin
      CBLinkedReq.Enabled := true;
      CBLinkedReq.Checked := true
    end
    else
    begin
      CBLinkedReq.Enabled := false;
      CBLinkedReq.Checked := false
    end;

    LblLimitToWorkCenter.Caption := 'Limit to work center   : ';
  end
  else if Assigned(MQMPlan.m_SelectedListWrkCtrPopUp) and
    (MQMPlan.m_SelectedListWrkCtrPopUp.Count > 0) and
    (PTSelectedParam(MQMPlan.m_SelectedListWrkCtrPopUp[0]).S_TypeSelected = Slt_WcGroup) then
  begin

    CBSelectedWc.Visible := false;
    cbWcList.Visible := True;
    cbWcList.Clear;
    for i := 0 to MQMPlan.m_SelectedListWrkCtrPopUp.Count -1 do
    begin
      cbWcList.Items.Add(TMqmWrkCtr(PTSelectedParam(MQMPlan.m_SelectedListWrkCtrPopUp[i]).S_WkCtr).p_WrkCtrLDesc);
      m_SlotGroup := TMqmPlanTabSheet(FMQMPlan.m_pgcPlan.GetActiveView).p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup;

      if m_SlotGroup = 1 then
        m_GroupName := TMqmWrkCtr(PTSelectedParam(MQMPlan.m_SelectedListWrkCtrPopUp[i]).S_WkCtr).P_WcGrp
      else if m_SlotGroup = 2 then
        m_GroupName := TMqmWrkCtr(PTSelectedParam(MQMPlan.m_SelectedListWrkCtrPopUp[i]).S_WkCtr).p_PlantCode
      else if m_SlotGroup = 3 then
        m_GroupName := TMqmWrkCtr(PTSelectedParam(MQMPlan.m_SelectedListWrkCtrPopUp[i]).S_WkCtr).p_Division;

      DatePickerWcFrom.DateTime :=
        PTSelectedParam(MQMPlan.m_SelectedListWrkCtrPopUp[0]).S_startDt;
      DateWcPickerToDate.DateTime :=
        PTSelectedParam(MQMPlan.m_SelectedListWrkCtrPopUp[0]).S_endDt - 1;

      LblLimitToWorkCenter.Caption := 'Limit to group       "' + m_GroupName+'"'
    end;

  end
  else
  begin
    LblLimitToWorkCenter.Visible := false;
    CBScheduleWithinTheFram.Checked := false;
    CBSelectedWc.Visible         := false;
    CBInfiniteCapacity.Checked := false;
    CBSelectedWc.Checked := false;
    CBSelectedWc.Enabled := false;
    CBSelectedWc.Checked := false;
    CBLinkedReq.Enabled  := false;
    CBLinkedReq.Checked  := false
  end;
  if not CBLinkedReq.Checked then CBLinkedReq.Enabled := false;

  CBWorkCenterConfiguration.checked := true;
  if CBWorkCenterConfiguration.checked then
  begin
   // CBWorkCenterConfiguration.Checked := true;
    CombBoxCfg.Enabled := false
  end
  else
  begin
   // CBWorkCenterConfiguration.Checked := false;
    CombBoxCfg.Enabled := true;
  end;

  CombBoxCfg.Clear;
  m_CurrAutoSchedCfg := AutoSchedCfg;
  for i := 0 to AutoSchedCfgList.Count - 1 do
  begin
    Cfg := AutoSchedCfgList[i];
    CombBoxCfg.Items.Add(Cfg.m_CfgName);
  end;

  Index := CombBoxCfg.Items.IndexOf(m_CurrAutoSchedCfg.m_CfgName);
  CombBoxCfg.ItemIndex := Index;
  // SetParamsToCurrentConfig;
//  ReShape(btnOk);
//  ReShape(btnAbort);
  ReShape(self);
end;

procedure TAutoSeqOverridingParams.FormShow(Sender: TObject);
begin
  m_formShow := true;
end;

// ----------------------------------------------------------------------------------------------

function TAutoSeqOverridingParams.GetParamsAutoCfg: string;
begin
  Result := m_CurrAutoSchedCfg.m_CfgName;
end;

// ----------------------------------------------------------------------------------------------

procedure TAutoSeqOverridingParams.btnAbortClick(Sender: TObject);
begin
  BtnAbo.click;
end;

procedure TAutoSeqOverridingParams.BtnOkClick(Sender: TObject);
begin
  BitBtn1.click;
end;

procedure TAutoSeqOverridingParams.CBLinkedReqClick(Sender: TObject);
begin
  if not m_formShow then exit;
  CombBoxCfg.Enabled := true;
  if CBLinkedReq.Checked then
  begin
    CombBoxCfg.Enabled   := false;
    CBWorkCenterConfiguration.Checked := true;
  end;

  if CBLinkedReq.Checked then
  begin
    if not CBSelectedWc.Checked or not CBScheduleWithinTheFram.Checked then
    begin
      ShowMessage(_('linked request can not be checked with current settings !'));
      CBLinkedReq.Checked := false
    end;
  end;

end;

// ----------------------------------------------------------------------------------------------

procedure TAutoSeqOverridingParams.CBScheduleWithinTheFramClick(Sender: TObject);
begin
  if not m_formShow then exit;
  if not CBScheduleWithinTheFram.Checked then
  begin
    if (CBSelectedWc.Checked) and (CBLinkedReq.Checked) then
    begin
      ShowMessage(_('linked request will be unchecked !'));
      CBLinkedReq.Checked := false;
    end;
  end;
end;

// ----------------------------------------------------------------------------------------------

procedure TAutoSeqOverridingParams.CBSelectedWcClick(Sender: TObject);
begin
  if not m_formShow then exit;
  if not CBSelectedWc.Checked then
  begin
    if CBLinkedReq.Checked then
    begin
      ShowMessage(_('linked request will be unchecked !'));
      CBLinkedReq.Checked := false;
    end;
  end;
end;

// ----------------------------------------------------------------------------------------------

procedure TAutoSeqOverridingParams.CBWorkCenterConfigurationClick(
  Sender: TObject);
begin
  if not m_formShow then exit;

  if UnCheckWorkCenterConfiguration then exit;

  if not CBWorkCenterConfiguration.Checked then
    CombBoxCfg.Enabled := true
  else
  begin
    CombBoxCfg.Enabled := false;
    CombBoxCfg.ItemIndex := 0;
  end;

end;

// ----------------------------------------------------------------------------------------------

procedure TAutoSeqOverridingParams.CBWorkCenterConfigurationMouseLeave(
  Sender: TObject);
begin
  UnCheckWorkCenterConfiguration := false;
  if CBLinkedReq.Checked and not CBWorkCenterConfiguration.Checked then
  begin
    ShowMessage(_('Allowed moved linked request is active - must use work center configuration !'));
    CBWorkCenterConfiguration.Checked := true;
    UnCheckWorkCenterConfiguration := true;
  end;
end;

// ----------------------------------------------------------------------------------------------

procedure TAutoSeqOverridingParams.CleanOverridingCurrParameters
  (CurrAutoSchedCfg: PTAutoSchedCfg);
begin
  CurrAutoSchedCfg.m_OverridingParams_Activated := false;

  { CurrAutoSchedCfg.m_BeforeLowLimit            := m_SavedBeforeLowLimit;
    CurrAutoSchedCfg.m_TollBeforeLowLimit        := m_SavedTollBeforeLowLimit;
    CurrAutoSchedCfg.m_TollBeforeLowLimitHours   := m_SavedTollBeforeLowLimitHours;
    CurrAutoSchedCfg.m_TollBeforeLowLimitMinutes := m_SavedTollBeforeLowLimitMinutes;
    CurrAutoSchedCfg.m_AfterHighLimit            := m_SavedAfterHighLimit;
    CurrAutoSchedCfg.m_TollAfterHighLimit        := m_SavedTollAfterHighLimit;
    CurrAutoSchedCfg.m_TollAfterHighLimitHours   := m_SavedTollAfterHighLimitHours;
    CurrAutoSchedCfg.m_TollAfterHighLimitMinutes := m_SavedTollAfterHighLimitMinutes;
    CurrAutoSchedCfg.m_SplitSchedByBatchSize     := m_SavedSplitSchedByBatchSize; }
end;

// ----------------------------------------------------------------------------------------------

procedure TAutoSeqOverridingParams.GetUpdatedWcEarliestLatestDates
  (var EarliestStart, LatestEnd: TDateTime);
begin
  EarliestStart := Trunc(DatePickerWcFrom.date) + frac(TimeWcFromPicker.Time);
  LatestEnd := Trunc(DateWcPickerToDate.date) + frac(TimePickerWcTo.Time);
end;

// ----------------------------------------------------------------------------------------------

procedure TAutoSeqOverridingParams.OverridingCurrParameters(CurrAutoSchedCfg
  : PTAutoSchedCfg);
begin
  CurrAutoSchedCfg.m_OverridingParams_Activated := true;
  CurrAutoSchedCfg.m_OverridingParams_InfiniteCapacityAllowed := CBInfiniteCapacity.Checked;
  CurrAutoSchedCfg.m_OverridingParams_UnscheduleBefore := CBUnscheduleBefore.Checked;

  CurrAutoSchedCfg.m_OverridingParams_Wc_Selected := CBSelectedWc.Checked;

  if cbWcList.Items.Count > 0 then
     CurrAutoSchedCfg.m_OverridingParams_Wc_Selected := true;

  CurrAutoSchedCfg.m_OverridingParams_Wc_Code_Selected := m_wcCode;

  CurrAutoSchedCfg.m_OverridingParams_WcDateTimeFrom := Trunc(DatePickerWcFrom.date) + frac(TimeWcFromPicker.Time);
  CurrAutoSchedCfg.m_OverridingParams_WcDateTimeTo := Trunc(DateWcPickerToDate.date) + frac(TimePickerWcTo.Time);

  CurrAutoSchedCfg.m_OverridingParams_ScheduleJobsWithinTheFram    := CBScheduleWithinTheFram.Checked;
  CurrAutoSchedCfg.m_OverridingParams_ShorterJobsCanEndAfterFramEnd := CBShorterJobsEndAfterFramEnd.Checked;
  CurrAutoSchedCfg.m_OverridingParams_LargerJobsCanStartAfterTheFrameBegins := CBLargerJobsCanStartAfterFrameBegins.Checked;

  CurrAutoSchedCfg.m_OverridingParams_BeforeLowLimit := RGBeforeEarlDate.ItemIndex;
  CurrAutoSchedCfg.m_OverridingParams_TollBeforeLowLimit := SEdtBefEarlDays.Value;
  CurrAutoSchedCfg.m_OverridingParams_TollBeforeLowLimitHours := SEdtBefEarlHours.Value;
  CurrAutoSchedCfg.m_OverridingParams_TollBeforeLowLimitMinutes := SEdtBefEarlMinutes.Value;

  CurrAutoSchedCfg.m_OverridingParams_AfterHighLimit := RGAfterLatDate.ItemIndex;
  CurrAutoSchedCfg.m_OverridingParams_TollAfterHighLimit := SEdtAfterLatDays.Value;
  CurrAutoSchedCfg.m_OverridingParams_TollAfterHighLimitHours := SEdtAfterLatHours.Value;
  CurrAutoSchedCfg.m_OverridingParams_TollAfterHighLimitMinutes := SEdtAfterLatMinutes.Value;

  CurrAutoSchedCfg.m_OverridingParams_MatWOMaterials := RGSchedWOMaterials.ItemIndex;

  CurrAutoSchedCfg.m_OverridingParams_MatWOAddRes := RGSchedWOAddResources.ItemIndex;

  CurrAutoSchedCfg.m_OverridingParams_IgnoreRightOverlapping := RGIgnoreRightOverlapping.ItemIndex;

  CurrAutoSchedCfg.m_OverridingParams_IgnoreLeftOverlapping := RGIgnoreLeftOverlapping.ItemIndex;

  if CBWorkCenterConfiguration.Checked then
    CurrAutoSchedCfg.m_OverridingParams_ScheduleByWorkCenterCfg := true
  else
    CurrAutoSchedCfg.m_OverridingParams_ScheduleByWorkCenterCfg := false;

  CurrAutoSchedCfg.m_OverridingParams_AllowedMoveLinkedReq := CBLinkedReq.Checked;

  CurrAutoSchedCfg.m_SlotGroup := m_SlotGroup;
  CurrAutoSchedCfg.m_GroupName := m_GroupName;

end;

// ----------------------------------------------------------------------------------------------

procedure TAutoSeqOverridingParams.RGAfterLatDateClick(Sender: TObject);
begin
  SEdtAfterLatDays.Enabled := (RGAfterLatDate.ItemIndex = 2);
  if not SEdtAfterLatDays.Enabled then
    SEdtAfterLatDays.Value := 0;
  SEdtAfterLatHours.Enabled := (RGAfterLatDate.ItemIndex = 2);
  if not SEdtAfterLatHours.Enabled then
    SEdtAfterLatHours.Value := 0;
  SEdtAfterLatMinutes.Enabled := (RGAfterLatDate.ItemIndex = 2);
  if not SEdtAfterLatMinutes.Enabled then
    SEdtAfterLatMinutes.Value := 0;
end;

// ----------------------------------------------------------------------------------------------

procedure TAutoSeqOverridingParams.RGBeforeEarlDateClick(Sender: TObject);
begin
  SEdtBefEarlDays.Enabled := (RGBeforeEarlDate.ItemIndex = 2);
  if not SEdtBefEarlDays.Enabled then
    SEdtBefEarlDays.Value := 0;
  SEdtBefEarlHours.Enabled := (RGBeforeEarlDate.ItemIndex = 2);
  if not SEdtBefEarlHours.Enabled then
    SEdtBefEarlHours.Value := 0;
  SEdtBefEarlMinutes.Enabled := (RGBeforeEarlDate.ItemIndex = 2);
  if not SEdtBefEarlMinutes.Enabled then
    SEdtBefEarlMinutes.Value := 0;
end;

// ----------------------------------------------------------------------------------------------

end.
