unit FMAutoSchedCfg;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, Buttons, CheckLst, Spin, UMAutoSchedCfg,
  Mask, DBCtrls, DB, Grids, DBGrids, IBX.IBDatabase, IBX.IBCustomDataSet,
  IBX.IBTable, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.IB, FireDAC.Phys.IBDef,
  FireDAC.VCLUI.Wait, FireDAC.Comp.Client, FireDAC.Comp.DataSet, UReShape, ExSpinEdit;

type
  TFAutoSchedCfg = class(TForm)
    PageControl1: TPageControl;
    TbsCompLimits: TTabSheet;
    TbsWeights: TTabSheet;
    TbsAlgorithm: TTabSheet;
    TbsOthers: TTabSheet;
    TBarDate: TTrackBar;
    LblDate: TLabel;
    Bevel5: TBevel;
    TrackBar1: TTrackBar;
    LblDelDate: TLabel;
    LblEffic: TLabel;
    Bevel4: TBevel;
    TBarToResComp: TTrackBar;
    LblToResComp: TLabel;
    LblToJobComp: TLabel;
    TBarToJobComp: TTrackBar;
    LblToCapResComp: TLabel;
    TBarToCapResComp: TTrackBar;
    LblSleep: TLabel;
    SEdtSleep: TexSpinEdit;
    CBoxRankReport: TCheckBox;
    GBGradients: TGroupBox;
    TbsDateDef: TTabSheet;
    GBDateLimits: TGroupBox;
    LblTollAfterDelDate: TLabel;
    LblTollAfterHighEnd: TLabel;
    LblTollBeforeLowStart: TLabel;
    SEdtTollAfterDelDate: TexSpinEdit;
    SEdtTollAfterHighEnd: TexSpinEdit;
    SEdtTollBeforeLowStart: TexSpinEdit;
    RGPrefTgtDate: TRadioGroup;
    LblGradBfrTollLSD: TLabel;
    SEdtGradBfrTollLSD: TexSpinEdit;
    LblGradBtwToll_LSD: TLabel;
    SEdtGradBtwToll_LSD: TexSpinEdit;
    LblGradBtwLSD_TGTD: TLabel;
    SEdtGradBtwLSD_TGTD: TexSpinEdit;
    LblGradBtwTGTD_HED: TLabel;
    SEdtGradBtwTGTD_HED: TexSpinEdit;
    LblGradBtwHED_Toll: TLabel;
    SEdtGradBtwHED_Toll: TexSpinEdit;
    LblGradBtwTollHED_Del: TLabel;
    SEdtGradBtwTollHED_Del: TexSpinEdit;
    LblGradBtwDel_Toll: TLabel;
    SEdtGradBtwDel_Toll: TexSpinEdit;
    LblGradAftTollDel: TLabel;
    SEdtGradAftTollDel: TexSpinEdit;
    CBoxLoopErrors: TCheckBox;
    GBMinComp: TGroupBox;
    LblMinToResComp: TLabel;
    SEdtMinToResComp: TexSpinEdit;
    LblMinToJobComp: TLabel;
    SEdtMinToJobComp: TexSpinEdit;
    LblMinToCapResComp: TLabel;
    SEdtMinToCapResComp: TexSpinEdit;
    BtnRstWeights: TBitBtn;
    BtnRstCompLimits: TBitBtn;
    BtnRstDateDef: TBitBtn;
    BtnRstGradients: TBitBtn;
    RGBeforeLowStart: TRadioGroup;
    RGAfterHighEnd: TRadioGroup;
    RGAfterDelDate: TRadioGroup;
    TbsGroupingSetup: TTabSheet;
    CBoxBAllowGroupsOneJob: TCheckBox;
    tbsMaterials: TTabSheet;
    BtnRstMaterials: TBitBtn;
    BtnRstGroupSetup: TBitBtn;
    BtnRstOther: TBitBtn;
    RGTempFinal: TRadioGroup;
    DTPStDate: TDateTimePicker;
    LblStDate: TLabel;
    CboxGraph: TCheckBox;
    Label1: TLabel;
    TBarSetup: TTrackBar;
    TabSheet1: TTabSheet;
    RGMoveObjs: TRadioGroup;
    BtnRstEntitiesDef: TBitBtn;
    RGSchedWOMat: TRadioGroup;
    RGSchedWOAddRes: TRadioGroup;
    CLBAllowToMove: TCheckListBox;
    Label2: TLabel;
    LblDays: TLabel;
    tbsPreferences: TTabSheet;
    tbsRequirements: TTabSheet;
    tbsSchedLimits1: TTabSheet;
    tbsSchedScore: TTabSheet;
    tbsOther: TTabSheet;
    RGJobSchedDate: TRadioGroup;
    RGAlreadySchedEnt: TRadioGroup;
    GBAllowEntConfLevel: TGroupBox;
    CLBConLevelsToMove: TCheckListBox;
    RGResSchedType: TRadioGroup;
    CBoxShowRankReport: TCheckBox;
    RGSchedWOMaterials: TRadioGroup;
    RGLinkedRequests: TRadioGroup;
    RGSchedWOAddResources: TRadioGroup;
    GBMinimComp: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    LblJobToCap: TLabel;
    SEdtMinCompJobToRes: TexSpinEdit;
    SEdtMaxCompJobToJob: TexSpinEdit;
    SEdtMinCompJobToResComp: TexSpinEdit;
    GBSchedRange: TGroupBox;
    Label9: TLabel;
    LBlBeforeErliestDayTolerance: TLabel;
    SEdtAfterLatDays: TexSpinEdit;
    SEdtBefEarlDays: TexSpinEdit;
    RGBeforeEarlDate: TRadioGroup;
    RGAfterLatDate: TRadioGroup;
    SEdtSleepTime: TexSpinEdit;
    Label23: TLabel;
    cboxShowGraph: TCheckBox;
    btnRstOthers: TBitBtn;
    SEdtBefEarlHours: TexSpinEdit;
    SEdtBefEarlMinutes: TexSpinEdit;
    SEdtAfterLatHours: TexSpinEdit;
    SEdtAfterLatMinutes: TexSpinEdit;
    TSSplitJobs: TTabSheet;
    RGLastSpitCanGoMinMachin: TRadioGroup;
    RGAutoSplitByBtach: TRadioGroup;
    RGCreteriaOfRes: TRadioGroup;
    RadGrpResLoaded: TRadioGroup;
    TbSSortbin: TTabSheet;
    CBField1: TComboBox;
    CBField2: TComboBox;
    CBField3: TComboBox;
    CBField4: TComboBox;
    CBField5: TComboBox;
    RGroupSortbeforeschedule: TRadioGroup;
    CBStopOnFirstNotSchedJob: TCheckBox;
    SEdtLimitDaysGapBtwnSubSteps: TexSpinEdit;
    SEdtLimitHoursGapBtwnSubSteps: TexSpinEdit;
    SEdtLimitMinGapBtwnSubSteps: TexSpinEdit;
    TabSheet2: TTabSheet;
    GBPenaltyCompat: TGroupBox;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    EdtJobToRes: TEdit;
    EdtJobToCapRes: TEdit;
    EdtJobNotCapRes: TEdit;
    GroupBox1: TGroupBox;
    Label14: TLabel;
    Label15: TLabel;
    rgJobOrSetup: TRadioGroup;
    EdtJobToJob: TEdit;
    EdtSetupPen: TEdit;
    GBPenaltyDays: TGroupBox;
    Label8: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    LblPenaltyNew1: TLabel;
    LblPenaltyNew2: TLabel;
    LblPenaltyNew3: TLabel;
    EdtEarlBefore: TEdit;
    EdtEarlWith: TEdit;
    EdtAfterLatest: TEdit;
    EdtAfterWith: TEdit;
    EditScheduleToPossibleStartPenalty: TEdit;
    GBWeight: TGroupBox;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    SEdtDateScore: TexSpinEdit;
    SEdtCompScore: TexSpinEdit;
    DataSource2: TDataSource;
    DBNavigator2: TDBNavigator;
    RGLog: TRadioGroup;
    EditLogLocation: TEdit;
    TbsServingGroup: TTabSheet;
    SpinEdtHoursToleranceOfGapBetweenJobs: TexSpinEdit;
    LblHoursToleranceOfGapBetweenJobs: TLabel;
    EdtPenaltyScoreWithinTol: TEdit;
    LblPenaltyScoreWithinTol: TLabel;
    LblPenaltyScoreAfterTol: TLabel;
    EdtPenaltyScoreAfterTol: TEdit;
    RGIgnoreRightOverlapping: TRadioGroup;
    RGIgnoreLeftOverlapping: TRadioGroup;
    CBunscheduleEarliesJobWhenAboveTolerance: TCheckBox;
    CBForceSameWcPlantToServingGroup: TCheckBox;
    SEdtMinCompJobToJob: TexSpinEdit;
    Label3: TLabel;
    CBAllowSchedBeforeNoneMovedConfLevl: TCheckBox;
    EditCalendarForDatesPenalty: TEdit;
    LblCalendarForDatesPenalty: TLabel;
    LblCalBalnk: TLabel;
    CBTextLog: TCheckBox;
    CBPrevOrNextLinkedJobIsTheTgtDateWhenScheduled: TCheckBox;
    FDTable2: TFDTable;
    FDTransaction1: TFDTransaction;
    DBGrid2: TDBGrid;
    Panel1: TPanel;
    LBConfigs: TListBox;
    EdtCfgName: TEdit;
    EdtCfgDesc: TEdit;
    EdtCfgGroup: TEdit;
    CBNextConfig: TComboBox;
    Label4: TLabel;
    lbEdtCfgName: TLabel;
    LblNextConfig: TLabel;
    lbEdtCfgDesc: TLabel;
    lbEdtCfgGroup: TLabel;
    btnDelete: TcxButton;
    Panel2: TPanel;
    BtnRstAll: TcxButton;
    BtnOk: TcxButton;
    btnAbo: TcxButton;
    Panel3: TPanel;
    btnRestSchedScore: TcxButton;
    btnRstPreferences: TcxButton;
    BTnClear1: TcxButton;
    BTnClear2: TcxButton;
    Panel5: TcxButton;
    BTnClear3: TcxButton;
    BTnClear4: TcxButton;
    BTnClear5: TcxButton;
    btnOk1: TBitBtn;
    btnRstRequirements: TcxButton;
    ScheduleLimits2: TTabSheet;
    GroupBoxLatestDateOfScheduleAllowed: TGroupBox;
    RadioGroupLatestDateLimit: TRadioGroup;
    ExSpinEditLatestDateOfScheduleNbrOfDays: TExSpinEdit;
    Label7: TLabel;
    RadioGroupDateLimitType: TRadioGroup;
    GBStartScheduleFrom: TGroupBox;
    LblDateTime: TLabel;
    LblNumDaysFromCurrDate: TLabel;
    RGStartScheduleFrom: TRadioGroup;
    DatePicker: TDateTimePicker;
    TimePicker: TDateTimePicker;
    SpinEdtNumDays: TExSpinEdit;
    Label10: TLabel;
    DateTimePickerLatestDateOfSchedule: TDateTimePicker;
    lblTime: TLabel;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LBConfigsClick(Sender: TObject);
    procedure EdtCfgNameChange(Sender: TObject);
    procedure TBarChange(Sender: TObject);
    procedure BtnDeleteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SEdtCompScoreChange(Sender: TObject);
    procedure SEdtDateScoreChange(Sender: TObject);
    procedure EdtEarlBeforeKeyPress(Sender: TObject; var Key: Char);
    procedure CheckKeyPress(Sender: TObject; var Key: Char);
    procedure EdtEarlBeforeExit(Sender: TObject);
    procedure btnRstPreferencesClick(Sender: TObject);
    procedure btnRstRequirementsClick(Sender: TObject);
    procedure btnRstSchedLimitsClick(Sender: TObject);
    procedure btnRestSchedScoreClick(Sender: TObject);
    procedure btnRstOthersClick(Sender: TObject);
    procedure BtnRstAllClick(Sender: TObject);
    procedure RGCompactEntClick(Sender: TObject);
    procedure RGBeforeEarlDateClick(Sender: TObject);
    procedure RGAfterLatDateClick(Sender: TObject);
    procedure rgJobOrSetupClick(Sender: TObject);
    procedure BitBtnClearClick(Sender: TObject);
    procedure RGRunningModeClick(Sender: TObject);
    procedure RGJobSchedDateClick(Sender: TObject);
    procedure RGAlreadySchedEntClick(Sender: TObject);
    procedure CBTextLogClick(Sender: TObject);
    procedure BtnOk1Click(Sender: TObject);
    procedure CBunscheduleEarliesJobWhenAboveToleranceClick(Sender: TObject);
    procedure RGStartScheduleFromClick(Sender: TObject);
    procedure FDTable2AfterInsert(DataSet: TDataSet);
    procedure FDTable2AfterPost(DataSet: TDataSet);
    procedure btnAboClick(Sender: TObject);
    procedure PageControl1DrawTab(Control: TCustomTabControl; TabIndex: Integer;
      const Rect: TRect; Active: Boolean);
    procedure BtnOkClick(Sender: TObject);

// --- OLD procedure

//    procedure TrackBar1Change(Sender: TObject);
//    procedure BtnRstWeightsClick(Sender: TObject);
//    procedure BtnRstCompLimitsClick(Sender: TObject);
//    procedure BtnRstGradientsClick(Sender: TObject);
//    procedure BtnRstDateDefClick(Sender: TObject);
//    procedure BtnRstAllClick(Sender: TObject);
//    procedure RGAfterHighEndClick(Sender: TObject);
//    procedure BtnRstMaterialsClick(Sender: TObject);
//    procedure BtnRstGroupSetupClick(Sender: TObject);
//    procedure BtnRstOtherClick(Sender: TObject);
//    procedure BtnRstEntitiesDefClick(Sender: TObject);
//    procedure RGCompactEntitiesClick(Sender: TObject);
  private
    m_CurrAutoSchedCfg : PTAutoSchedCfg;
    m_FormShow : boolean;
    procedure LoadVersions;
    procedure ShowCurrConf;
    procedure SaveConf;
    procedure SetSortFileds;
    procedure CheckData;
    procedure IniConnectionAutoSeqTable_JOBTOJOBDEFINITIONS;
  public
    constructor CreateAutoSchedCfg(AOwner: Tcomponent);
    destructor Destroy ; override;
  end;

var
  FAutoSchedCfg: TFAutoSchedCfg;

implementation

uses
  inifiles,
  gnugettext,
  DMSrvPC,
  UMTblDesc,
  UMSchedContFunc,
  UMbinGrid,
  UMBinDefault,
  UMCompat,
  UMGlobal, StrUtils, FMbin;//, UGDpiChange;

{$R *.DFM}

//----------------------------------------------------------------------------//

procedure TBar_ShowSelection(Obj: TTrackBar);
begin
  with Obj do
  begin
    if Position > 0 then
    begin
      SelStart := 0;
      Selend := Position;
    end else
    begin
      if Position < 0 then
      begin
        SelStart := Position;
        Selend := 0;
      end else
      begin
        SelStart := 0;
        Selend := 0;
      end;
    end;
    Hint := IntToStr(Position)
  end;
end;

//----------------------------------------------------------------------------//
//   TFAutoSched                                                              //
//----------------------------------------------------------------------------//

procedure TFAutoSchedCfg.CBunscheduleEarliesJobWhenAboveToleranceClick(
  Sender: TObject);
begin
  if (RGJobSchedDate.ItemIndex <> 2) and CBunscheduleEarliesJobWhenAboveTolerance.Checked then
  begin

    CBunscheduleEarliesJobWhenAboveTolerance.Checked := false;
    Showmessage(_('When target date is not "Today" the "unschedule earlies job when above tolerance " flag must not be checked ') );
  end;
end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedCfg.CBTextLogClick(Sender: TObject);
begin

end;

//----------------------------------------------------------------------------//

constructor TFAutoSchedCfg.CreateAutoSchedCfg(AOwner: Tcomponent);
var
  i : integer;
begin
  inherited create(AOwner);
  LoadVersions;
//  Height := 640;
//  Width := 900;

// Do not show OLD TabSheet
  TbSSortbin.TabVisible := false;
  TbsCompLimits.TabVisible := false;
  TbsWeights.TabVisible := false;
  TbsDateDef.TabVisible := false;
  TabSheet1.TabVisible := false;
  tbsMaterials.TabVisible := false;
  TbsAlgorithm.TabVisible := false;
  TbsGroupingSetup.TabVisible := false;
  TbsOthers.TabVisible := false;
  TSSplitJobs.TabVisible := true;

{$ifndef develop}
  tbsOther.TabVisible := false;
//  CBoxShowRankReport.Visible := false;
  Label18.Visible := false;
  EdtJobNotCapRes.Visible := false;
{$else}
  tbsOther.TabVisible := true;
//  CBoxShowRankReport.Visible := true;
  Label18.Visible := true;
  EdtJobNotCapRes.Visible := true;
{$endif}

  PageControl1.ActivePage := tbsPreferences;

  CLBConLevelsToMove.Clear;
  RGResSchedType.Items.Clear;
  CLBConLevelsToMove.Items.Add('Final');
  RGResSchedType.Items.Add(_('Final schedule'));
  for i := 1 to DBAppGlobals.ConfLevels do
    if i = 1 then
    begin
      CLBConLevelsToMove.Items.Add('Initial');
      RGResSchedType.Items.Add(_('Initial schedule'));
    end else
    begin
      CLBConLevelsToMove.Items.Add('Level' + ' ' + IntToStr(i - 1));
      RGResSchedType.Items.Add(_('Confirmation level') + ' ' + IntToStr(i - 1));
    end;

  m_CurrAutoSchedCfg := AutoSchedCfg;
  if LBConfigs.Items.IndexOf(m_CurrAutoSchedCfg.m_CfgName) = -1 then
    LBConfigs.Items.Add(m_CurrAutoSchedCfg.m_CfgName);
  LBConfigs.ItemIndex := LBConfigs.Items.IndexOf(m_CurrAutoSchedCfg.m_CfgName);

  Application.HintHidePause := 10000;

 { RGRunningMode.Hint := _(' Running mode decides on the way automatic sequence will run. ' + #13#10  +

                        ' Standard : ' + #13#10 +
                        ' Standard is the "Orthodox" way to find the best spot. ' + #13#10 +
                        ' Automatic sequence, for each job : ' + #13#10 +
                        ' 1. Makes a split by batch size if requested. ' + #13#10 +
                        ' 2. Go over all resources. ' + #13#10 +
                        ' 3. For each resource it prepares a list of positions to check. ' + #13#10 +
                        ' 3A. After each job ends. ' + #13#10 +
                        ' 3B. Each "beginning" place that additional resources are available (If required). ' + #13#10 +
                        ' 3C. Each "beginning" place materials are available (If required). ' + #13#10 +
                        ' 3D. On earliest spot the job can start respecting the prior step or prior requests. ' + #13#10 +
                        ' 3E. Current date time of running. ' + #13#10 +
                        ' 4. Each position is checked if relevant (Depending if there is enough room and if not, if the next jobs can be moved). ' + #13#10 +
                        ' 5. Each position that is relevant gets a score. ' + #13#10 +
                        ' 6. Out of all positions a position is selected according to : ' + #13#10 +
                        ' 6A. Its score. ' + #13#10 +
                        ' 6B. Its date. ' + #13#10 +
                        ' 6C. Its resource status. ' + #13#10 +

                        ' Forward : ' + #13#10 +
                        ' The main assumption in this way of running is that the BIN is sorted by importance of the request. ' + #13#10 +
                        ' The importance can be set by previous step dates, priority of any kind or any other rule. ' + #13#10 +
                        ' The important this is that the higher located jobs in the bin are prioretized over the next jobs. ' + #13#10 +
                        ' The forward method allows also to run several runs and let auto sequence select the best of them. ' + #13#10 +
                        ' Automatic sequence, for each job : ' + #13#10 +
                        ' 1. Go over all resources and for each checks the closest starting date after the last job on the resource ' + #13#10 +
                        '    (Or current date if no job is there) and calculates the score. ' + #13#10 +
                        ' 2. In addition to the traditional punishments, the score takes into account the penaly of where the job ' + #13#10 +
                             ' could end at the minimum versus its real end in this position. ' + #13#10 +
                        ' 3. Out of all scores, the position selected is according to : ' + #13#10 +
                        ' 3A. its score. ' + #13#10 +
                        ' 3B. Its date. ' + #13#10 +
                        ' 3C. Its gap to the ending job. ' + #13#10 +
                        ' 4. After a spot is selected, the score is re-calculated taking only the traditional punishments. ' + #13#10 +
                        ' 5. If the job is late above the tolerance, then its position is set otherwise - continue to check. ' + #13#10 +
                        ' 5. Read again all resources and go backward on each of the resources. ' + #13#10 +
                        ' 6. In each resource go backward on the jobs till running into a job that we can not move or because its ' + #13#10 +
                            'later already or because of the rules. ' + #13#10 +
                        ' 7. If a job can move , the position before it is checked : ' + #13#10 +
                        ' 7A. Calculate the score of the job we check. ' + #13#10 +
                        ' 7B. Re-schedule all the job from that position on one after the other after the last jobs. ' + #13#10 +
                        ' 8. If a better score found by re-scheduling other jobs, this position is taken , otherwise, the position found on "4". ');

                     }

end;

//----------------------------------------------------------------------------//

destructor TFAutoSchedCfg.Destroy;
begin
  FAutoSchedCfg := nil;
  inherited Destroy;
end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedCfg.FormCreate(Sender: TObject);
begin
  TranslateComponent (self);
  SetSortFileds;
  IniConnectionAutoSeqTable_JOBTOJOBDEFINITIONS;
  EditLogLocation.Text := AutoSchedCfg.m_LogLocation;
  ReShape(Self);
end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedCfg.CheckData;
begin
  ModalResult := mrOk;
  if (RadioGroupLatestDateLimit.ItemIndex <> 0) then
  begin
    if (RadioGroupDateLimitType.ItemIndex = 0) then
    begin
      if (RGStartScheduleFrom.ItemIndex <> 1) then
      begin
        showmessage('When selecting "Date Limit Type" as a Specific date, "Start schedule from" must be also selected as a specific date time');
        ModalResult := mrNone;
        PageControl1.activepage := ScheduleLimits2;
        exit;
      end;
    end;

    if (RadioGroupDateLimitType.ItemIndex = 0) then
    begin
      if (RGStartScheduleFrom.ItemIndex = 1) then
      begin
        if DatePicker.Date >= DateTimePickerLatestDateOfSchedule.Date then
        begin
          showmessage('When selecting "Date Limit Type" as specific date, the date must be bigger than "Start schedule from" / specific date');
          ModalResult := mrNone;
          PageControl1.activepage := ScheduleLimits2;
          exit;
        end;
      end;
    end;

    if (RadioGroupDateLimitType.ItemIndex = 1) then
    begin
      if (RGStartScheduleFrom.ItemIndex <> 2) then
      begin
        showmessage('When selecting "Date Limit Type" as a "Number of days from current date", "Start schedule from" must be also selected as "Number of days from current date"');
        ModalResult := mrNone;
        PageControl1.activepage := ScheduleLimits2;
        exit;
      end
      else
      begin
        if ExSpinEditLatestDateOfScheduleNbrOfDays.value <= SpinEdtNumDays.Value then
        begin
          showmessage('When selecting "Date Limit Type" as a "Number of days from current date", it must be bigger than "Start schedule from" / "Number of days from current date"');
          ModalResult := mrNone;
          PageControl1.activepage := ScheduleLimits2;
          exit;
        end;
      end;
    end

  end;

end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedCfg.FDTable2AfterInsert(DataSet: TDataSet);
begin
  FDTable2 ['AJ_WKST_CODE'] := IniAppGlobals.WkstCode;
  FDTable2['AJ_CFGNAME']   := m_CurrAutoSchedCfg.m_CfgName;
  FDTable2['AJ_IDENTIFIER']   := StrToInt(IniAppGlobals.Identifier);
end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedCfg.FDTable2AfterPost(DataSet: TDataSet);
begin
  IniConnectionAutoSeqTable_JOBTOJOBDEFINITIONS
end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedCfg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = mrOk then
    SaveConf;
  Action := caFree;
end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedCfg.FormShow(Sender: TObject);
 var Rgn: HRgn;
begin
  ShowCurrConf;
  CBNextConfig.ItemIndex := CBNextConfig.Items.IndexOf(m_CurrAutoSchedCfg.m_CfgNameNext);
  RGRunningModeClick(self);
  m_FormShow := true;

//  ReShape(Self);
{  ReShape(btnDelete);   //
  ReShape(BtnRstAll);
  ReShape(BtnOk);
  ReShape(BtnAbo);
  ReShape(btnRestSchedScore);
  ReShape(btnRstPreferences);

  ReShape(BTnClear1);
  ReShape(BTnClear2);
  ReShape(BTnClear3);
  ReShape(BTnClear4);
  ReShape(BTnClear5); }
end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedCfg.LoadVersions;
var
  i: integer;
  Cfg: PTAutoSchedCfg;
begin
  LBConfigs.Clear;
  for i := 0 to AutoSchedCfgList.Count-1 do
  begin
    Cfg := AutoSchedCfgList[i];
    LBConfigs.Items.Add(Cfg.m_CfgName);
  end;
end;

procedure TFAutoSchedCfg.PageControl1DrawTab(Control: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
begin
   //Mihailo 5.8.2019.

   //Rect.Width := Length((Control as TPageControl).Pages[TabIndex].Caption)* 15 div 10;

    {with Control.Canvas do begin
      Brush.Color := clWhite;
      FillRect(Rect);
      TextOut(Rect.Left + 5, Rect.Top + 4, (Control as TPageControl).Pages[TabIndex].Caption) ;
    end;  }


  {  pagecontrol1.canvas.Font.color:=clblack;

    pagecontrol1.canvas.brush.color:=clWhite;

    pagecontrol1.canvas.TextRect(Rect, Rect.Left+4, Rect.Top+4,PageControl1.Pages[TabIndex].Caption);
   // pagecontrol1.Canvas.DrawFocusRect(Rect);}

end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedCfg.SaveConf;
var
  TempCfg: PTAutoSchedCfg;
  i : integer;
  Year, Month, Day: Word;
  Hour, Min, Sec, MSec: Word;
  T : TTime;
  D : TDate;
begin
  BtnOk.SetFocus; // Only for invoke OnExit Event
  TempCfg := GetAutoSchedCfg(Trim(EdtCfgName.Text));
  if Assigned(TempCfg) then
    m_CurrAutoSchedCfg := TempCfg
  else
  begin
    new(m_CurrAutoSchedCfg);
    AddNewCfg(m_CurrAutoSchedCfg);
  end;

  m_CurrAutoSchedCfg.m_CfgName     := Trim(EdtCfgName.Text);
  m_CurrAutoSchedCfg.m_CfgDesc     := Trim(EdtCfgDesc.Text);
  m_CurrAutoSchedCfg.m_CfgGroup    := Trim(EdtCfgGroup.Text);
//  m_CurrAutoSchedCfg.m_RunningMode := RGRunningMode.ItemIndex;
//  RGRunningMode.ItemIndex := 1;
  m_CurrAutoSchedCfg.m_StartSchedFrom := RGStartScheduleFrom.ItemIndex;

  DecodeDate(DatePicker.Date, Year, Month, Day);
  D := EncodeDate(Year, Month, Day);
  DecodeTime(TimePicker.Time, Hour, Min, Sec, MSec);
  T := EncodeTime(Hour, Min, Sec, MSec);
  m_CurrAutoSchedCfg.m_SpecificDateTime := D + T;

  m_CurrAutoSchedCfg.m_NumberOfDaysFromCurrentDate := SpinEdtNumDays.Value;


  m_CurrAutoSchedCfg.m_CfgNameNext := CBNextConfig.Items[CBNextConfig.ItemIndex];

  // TabSheet Preferences
  m_CurrAutoSchedCfg.m_PrefTgtDate := RGJobSchedDate.ItemIndex;
  m_CurrAutoSchedCfg.m_PrevOrNextLinkedJobIsTheTgtDateWhenScheduled := CBPrevOrNextLinkedJobIsTheTgtDateWhenScheduled.Checked;
  m_CurrAutoSchedCfg.m_MoveObjsAllowed := RGAlreadySchedEnt.ItemIndex;
  m_CurrAutoSchedCfg.m_CreateLog := CBTextLog.Checked;


  m_CurrAutoSchedCfg.m_MoveFinalObjsAlwd := 0;
  m_CurrAutoSchedCfg.m_MoveInitialObjsAlwd := 0;
  m_CurrAutoSchedCfg.m_MoveLevel1ObjsAlwd := 0;
  m_CurrAutoSchedCfg.m_MoveLevel2ObjsAlwd := 0;
  m_CurrAutoSchedCfg.m_MoveLevel3ObjsAlwd := 0;
  m_CurrAutoSchedCfg.m_MoveLevel4ObjsAlwd  := 0;
  m_CurrAutoSchedCfg.m_MoveLevel5ObjsAlwd  := 0;

  for i := 0 to CLBConLevelsToMove.Items.Count -1 do
    if CLBConLevelsToMove.Checked[i] then
      case i of
        0: m_CurrAutoSchedCfg.m_MoveFinalObjsAlwd := 1;
        1: m_CurrAutoSchedCfg.m_MoveInitialObjsAlwd := 1;
        2: m_CurrAutoSchedCfg.m_MoveLevel1ObjsAlwd  := 1;
        3: m_CurrAutoSchedCfg.m_MoveLevel2ObjsAlwd  := 1;
        4: m_CurrAutoSchedCfg.m_MoveLevel3ObjsAlwd  := 1;
        5: m_CurrAutoSchedCfg.m_MoveLevel4ObjsAlwd  := 1;
        6: m_CurrAutoSchedCfg.m_MoveLevel5ObjsAlwd  := 1;
      end
    else
      case i of
        0: m_CurrAutoSchedCfg.m_MoveFinalObjsAlwd := 0;
        1: m_CurrAutoSchedCfg.m_MoveInitialObjsAlwd := 0;
        2: m_CurrAutoSchedCfg.m_MoveLevel1ObjsAlwd  := 0;
        3: m_CurrAutoSchedCfg.m_MoveLevel2ObjsAlwd  := 0;
        4: m_CurrAutoSchedCfg.m_MoveLevel3ObjsAlwd  := 0;
        5: m_CurrAutoSchedCfg.m_MoveLevel4ObjsAlwd  := 0;
        6: m_CurrAutoSchedCfg.m_MoveLevel5ObjsAlwd  := 0;
      end;

//  m_CurrAutoSchedCfg.m_MinStartDateOffset := Trunc(DTPScheduleStartDate.Date) - Trunc(Date);
  m_CurrAutoSchedCfg.m_TempFinal := RGResSchedType.ItemIndex;
  m_CurrAutoSchedCfg.m_RankRep := CBoxShowRankReport.Checked;
  m_CurrAutoSchedCfg.m_StopOnFirstNotSchedJob := CBStopOnFirstNotSchedJob.checked;

  m_CurrAutoSchedCfg.m_PriorErrLoop := true; // Always yes

  // TabSheet Requirements
  m_CurrAutoSchedCfg.m_MatWOMaterials := RGSchedWOMaterials.ItemIndex;
  m_CurrAutoSchedCfg.m_MatWOAddRes := RGSchedWOAddResources.ItemIndex;
  m_CurrAutoSchedCfg.m_IgnoreRightOverlapping := RGIgnoreRightOverlapping.ItemIndex;
  m_CurrAutoSchedCfg.m_IgnoreLeftOverlapping  := RGIgnoreLeftOverlapping.ItemIndex;
  m_CurrAutoSchedCfg.m_HoursToleranceOfGapBetweenJobs := SpinEdtHoursToleranceOfGapBetweenJobs.Value;
  m_CurrAutoSchedCfg.m_RescheduleErlierJobsWhenTolerance := CBunscheduleEarliesJobWhenAboveTolerance.Checked;
  m_CurrAutoSchedCfg.m_AllServingGroupJobsSamePlant    := CBForceSameWcPlantToServingGroup.Checked;
  m_CurrAutoSchedCfg.m_CalendarForDatesPenalty         := EditCalendarForDatesPenalty.Text;

//  if RGOneReqAtTime.ItemIndex = 0 then

  if RGAutoSplitByBtach.ItemIndex = 0 then
    m_CurrAutoSchedCfg.m_SplitSchedByBatchSize := ByMachinesOptimum
  else if RGAutoSplitByBtach.ItemIndex = 1 then
    m_CurrAutoSchedCfg.m_SplitSchedByBatchSize := ByEqualQuantity
  else if RGAutoSplitByBtach.ItemIndex = 2 then
    m_CurrAutoSchedCfg.m_SplitSchedByBatchSize := BalancingAll
  else if RGAutoSplitByBtach.ItemIndex = 3 then
    m_CurrAutoSchedCfg.m_SplitSchedByBatchSize := DailyProductionAndJoin
  else if RGAutoSplitByBtach.ItemIndex = 4 then
    m_CurrAutoSchedCfg.m_SplitSchedByBatchSize := ByMachinesOptimumForceSplit
  else if RGAutoSplitByBtach.ItemIndex = 5 then
    m_CurrAutoSchedCfg.m_SplitSchedByBatchSize := LongestDurationPossible;

  if RGCreteriaOfRes.ItemIndex = 0 then
    m_CurrAutoSchedCfg.m_CreteriaOfResForBachZise := AnyResource;
  if RGCreteriaOfRes.ItemIndex = 1 then
    m_CurrAutoSchedCfg.m_CreteriaOfResForBachZise := OnlySameSize;
  if RGCreteriaOfRes.ItemIndex = 2 then
    m_CurrAutoSchedCfg.m_CreteriaOfResForBachZise := SameSizeExcpetSmallesBatch;

  if RGLastSpitCanGoMinMachin.ItemIndex = 0 then
    m_CurrAutoSchedCfg.m_LastSplitCanGoUnderMin := true
  else
    m_CurrAutoSchedCfg.m_LastSplitCanGoUnderMin := false;

  // TabSheet Schedule limits
  m_CurrAutoSchedCfg.m_MinJobResComp :=  SEdtMinCompJobToRes.Value;
  m_CurrAutoSchedCfg.m_MinJobJobComp :=  SEdtMinCompJobToJob.Value;
  m_CurrAutoSchedCfg.m_MaxJobJobComp :=  SEdtMaxCompJobToJob.Value;
  m_CurrAutoSchedCfg.m_MinJobCapResComp := SEdtMinCompJobToResComp.Value;

  if CBAllowSchedBeforeNoneMovedConfLevl.Checked then
    m_CurrAutoSchedCfg.m_AllowSchedBeforeNoneConfLevl := true
  else
    m_CurrAutoSchedCfg.m_AllowSchedBeforeNoneConfLevl := false;
  m_CurrAutoSchedCfg.m_BeforeLowLimit := RGBeforeEarlDate.ItemIndex;
  m_CurrAutoSchedCfg.m_TollBeforeLowLimit := SEdtBefEarlDays.Value;
  m_CurrAutoSchedCfg.m_TollBeforeLowLimitHours := SEdtBefEarlHours.Value;
  m_CurrAutoSchedCfg.m_TollBeforeLowLimitMinutes := SEdtBefEarlMinutes.Value;
  m_CurrAutoSchedCfg.m_AfterHighLimit := RGAfterLatDate.ItemIndex;
  m_CurrAutoSchedCfg.m_TollAfterHighLimit :=  SEdtAfterLatDays.Value;
  m_CurrAutoSchedCfg.m_TollAfterHighLimitHours := SEdtAfterLatHours.Value;
  m_CurrAutoSchedCfg.m_TollAfterHighLimitMinutes := SEdtAfterLatMinutes.Value;

  // TabSheet Schedule Score
  m_CurrAutoSchedCfg.m_BeforeEarlDateTol := StrToFloat(EdtEarlBefore.Text);
  m_CurrAutoSchedCfg.m_WithinEarlDateTol := StrToFloat(EdtEarlWith.Text);
  m_CurrAutoSchedCfg.m_AfterLatestDateTol := StrToFloat(EdtAfterLatest.Text);
  m_CurrAutoSchedCfg.m_WithinLatestDateTol := StrToFloat(EdtAfterWith.Text);
  m_CurrAutoSchedCfg.m_ScheduleToPossibleStartPenalty := StrToFloat(EditScheduleToPossibleStartPenalty.Text);

  if rgJobOrSetup.ItemIndex = 0 then
  begin
    m_CurrAutoSchedCfg.m_PenCompJobToJob := StrToFloat(EdtJobToJob.Text);
    m_CurrAutoSchedCfg.m_PenCompSetupMinutes := 0.0;
  end else
  begin
    m_CurrAutoSchedCfg.m_PenCompJobToJob := 0.0;
    m_CurrAutoSchedCfg.m_PenCompSetupMinutes := StrToFloat(EdtSetupPen.Text);
  end;

  m_CurrAutoSchedCfg.m_PenaltyScoreWithinTolerance := StrToFloat(EdtPenaltyScoreWithinTol.Text);
  m_CurrAutoSchedCfg.m_PenaltyScoreAfterTolerance := StrToFloat(EdtPenaltyScoreAfterTol.Text);

  m_CurrAutoSchedCfg.m_PenCompJobToRes := StrToFloat(EdtJobToRes.Text);
  m_CurrAutoSchedCfg.m_PenCompJobToCapRes := StrToFloat(EdtJobToCapRes.Text);
  m_CurrAutoSchedCfg.m_PenCompJobNotCapRes := StrToFloat(EdtJobNotCapRes.Text);
  m_CurrAutoSchedCfg.m_DateScoreWeight := SEdtDateScore.Value;
  m_CurrAutoSchedCfg.m_CompScoreWeight := SEdtCompScore.Value;

  // Others
  m_CurrAutoSchedCfg.m_Sleep := SEdtSleepTime.Value * 100;
  m_CurrAutoSchedCfg.m_GraphOnMove := cboxShowGraph.Checked;

  SetAsActiveCfg(m_CurrAutoSchedCfg);
  DBAppGlobals.ActAutoSched := m_CurrAutoSchedCfg.m_CfgName;

  if RadGrpResLoaded.ItemIndex = 0 then
     m_CurrAutoSchedCfg.m_LoadedResource := false
  else
     m_CurrAutoSchedCfg.m_LoadedResource := true;

{  if RadGrpmLoadedOnSameResCat.ItemIndex = 0 then
     m_CurrAutoSchedCfg.m_LoadedOnSameResCat := false
  else
     m_CurrAutoSchedCfg.m_LoadedOnSameResCat := true; }

{  if RadioGrpLimitGapBtwnSubSteps.ItemIndex = 0 then
     m_CurrAutoSchedCfg.m_LimitGapBtwnSubSteps := '0'
  else
     m_CurrAutoSchedCfg.m_LimitGapBtwnSubSteps := '1'; }

  m_CurrAutoSchedCfg.m_ToleranceDaysGapBtwnSubSteps := SEdtLimitDaysGapBtwnSubSteps.Value;
  m_CurrAutoSchedCfg.m_ToleranceHoursGapBtwnSubSteps := SEdtLimitHoursGapBtwnSubSteps.Value;
  m_CurrAutoSchedCfg.m_ToleranceMinGapBtwnSubSteps := SEdtLimitMinGapBtwnSubSteps.Value;

  if RGroupSortbeforeschedule.ItemIndex = 0 then
    m_CurrAutoSchedCfg.m_SortBeforeSchedule := false
  else
    m_CurrAutoSchedCfg.m_SortBeforeSchedule := true;

  if CBField1.ItemIndex = -1 then
    m_CurrAutoSchedCfg.m_FieldArrayForSort[1].Field := CSC_NotSorted
  else if CBField1.ItemIndex = 0 then
  begin
    m_CurrAutoSchedCfg.m_FieldArrayForSort[1].Field := CSC_Overlapping;
    m_CurrAutoSchedCfg.m_FieldArrayForSort[1].Pos := 0;
  end
  else
  begin
    m_CurrAutoSchedCfg.m_FieldArrayForSort[1].Field := BinColDefault[CBField1.ItemIndex -1].Field;
    m_CurrAutoSchedCfg.m_FieldArrayForSort[1].Pos := BinColDefault[CBField1.ItemIndex -1].Pos + 1;
  end;

  if CBField2.ItemIndex = -1 then
    m_CurrAutoSchedCfg.m_FieldArrayForSort[2].Field := CSC_NotSorted
  else if CBField2.ItemIndex = 0 then
  begin
    m_CurrAutoSchedCfg.m_FieldArrayForSort[2].Field := CSC_Overlapping;
    m_CurrAutoSchedCfg.m_FieldArrayForSort[2].Pos := 0;
  end
  else
  begin
    m_CurrAutoSchedCfg.m_FieldArrayForSort[2].Field := BinColDefault[CBField2.ItemIndex -1].Field;
    m_CurrAutoSchedCfg.m_FieldArrayForSort[2].Pos := BinColDefault[CBField2.ItemIndex -1].Pos + 1;
  end;

  if CBField3.ItemIndex = -1 then
    m_CurrAutoSchedCfg.m_FieldArrayForSort[3].Field := CSC_NotSorted
  else if CBField3.ItemIndex = 0 then
  begin
    m_CurrAutoSchedCfg.m_FieldArrayForSort[3].Field := CSC_Overlapping;
    m_CurrAutoSchedCfg.m_FieldArrayForSort[3].Pos := 0;
  end
  else
  begin
    m_CurrAutoSchedCfg.m_FieldArrayForSort[3].Field := BinColDefault[CBField3.ItemIndex -1].Field;
    m_CurrAutoSchedCfg.m_FieldArrayForSort[3].Pos := BinColDefault[CBField3.ItemIndex -1].Pos + 1;
  end;

  if CBField4.ItemIndex = -1 then
    m_CurrAutoSchedCfg.m_FieldArrayForSort[4].Field := CSC_NotSorted
  else if CBField4.ItemIndex = 0 then
  begin
    m_CurrAutoSchedCfg.m_FieldArrayForSort[4].Field := CSC_Overlapping;
    m_CurrAutoSchedCfg.m_FieldArrayForSort[4].Pos := 0;
  end
  else
  begin
    m_CurrAutoSchedCfg.m_FieldArrayForSort[4].Field := BinColDefault[CBField4.ItemIndex -1].Field;
    m_CurrAutoSchedCfg.m_FieldArrayForSort[4].Pos := BinColDefault[CBField4.ItemIndex -1].Pos + 1;
  end;

  if CBField5.ItemIndex = -1 then
    m_CurrAutoSchedCfg.m_FieldArrayForSort[5].Field := CSC_NotSorted
  else if CBField5.ItemIndex = 0 then
  begin
    m_CurrAutoSchedCfg.m_FieldArrayForSort[5].Field := CSC_Overlapping;
    m_CurrAutoSchedCfg.m_FieldArrayForSort[5].Pos := 0;
  end
  else
  begin
    m_CurrAutoSchedCfg.m_FieldArrayForSort[5].Field := BinColDefault[CBField5.ItemIndex -1].Field;
    m_CurrAutoSchedCfg.m_FieldArrayForSort[5].Pos := BinColDefault[CBField5.ItemIndex -1].Pos + 1;
  end;

  m_CurrAutoSchedCfg.m_McmRescheduledJobs := false;

  m_CurrAutoSchedCfg.m_AllowedLatestDateLimit := RadioGroupLatestDateLimit.ItemIndex;
  m_CurrAutoSchedCfg.m_AllowedDatelimitType := RadioGroupDateLimitType.ItemIndex;
  m_CurrAutoSchedCfg.m_LatestDateScheduleNbrOfDays := ExSpinEditLatestDateOfScheduleNbrOfDays.Value;

  DecodeDate(DateTimePickerLatestDateOfSchedule.Date, Year, Month, Day);
  D := EncodeDate(Year, Month, Day);
  m_CurrAutoSchedCfg.m_LatestDateSchedule := D;

end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedCfg.SetSortFileds;
var
  i, Index, PropPosition, Num    : integer;
  binGrid     : TBinDrawGrid;
  FieldsCount : integer;
  PId : TPropID;
begin
  if m_CurrAutoSchedCfg.m_SortBeforeSchedule then
     RGroupSortbeforeschedule.ItemIndex := 1;

  binGrid := FBin.GetActiveView.GetBinGrid;
  for i := low(binGrid.BinColumnSet) to high(binGrid.BinColumnSet) do
    with m_CurrAutoSchedCfg.m_FieldsArray[i] do
    begin
      Field   := binGrid.BinColumnSet[i].Field;
      Title   := binGrid.BinColumnSet[i].Title;
      Pos     := binGrid.BinColumnSet[i].Pos;
      Width   := binGrid.BinColumnSet[i].Width;
      Visible := binGrid.BinColumnSet[i].Visible;
      Order   := binGrid.BinColumnSet[i].Order;
    end;

  FieldsCount := GetNumberFields;

  CBField1.Items.Add(_('Overlapping date/time'));
  CBField2.Items.Add(_('Overlapping date/time'));
  CBField3.Items.Add(_('Overlapping date/time'));
  CBField4.Items.Add(_('Overlapping date/time'));
  CBField5.Items.Add(_('Overlapping date/time'));

  for I := low(m_CurrAutoSchedCfg.m_FieldsArray) to FieldsCount - 1 do
  begin
    CBField1.Items.Add(m_CurrAutoSchedCfg.m_FieldsArray[i].Title);
    CBField2.Items.Add(m_CurrAutoSchedCfg.m_FieldsArray[i].Title);
    CBField3.Items.Add(m_CurrAutoSchedCfg.m_FieldsArray[i].Title);
    CBField4.Items.Add(m_CurrAutoSchedCfg.m_FieldsArray[i].Title);
    CBField5.Items.Add(m_CurrAutoSchedCfg.m_FieldsArray[i].Title);
  end;

  Index := 0;
  for I := 0 to high(DBAppGlobals.ShowBinPropArry) do
  begin
    if not (DBAppGlobals.ShowBinPropArry[I] = nil) then
      Index := Index + 1
    else
      break;
  end;

  PropPosition := FieldsCount + Index;
  num := -1;

  for I := FieldsCount to (PropPosition - 1) do
  begin

    case (m_CurrAutoSchedCfg.m_FieldsArray[I].Field) of
      CSC_property1:   num := 0;
      CSC_property2:   num := 1;
      CSC_property3:   num := 2;
      CSC_property4:   num := 3;
      CSC_property5:   num := 4;
      CSC_property6:   num := 5;
      CSC_property7:   num := 6;
      CSC_property8:   num := 7;
      CSC_property9:   num := 8;
      CSC_property10:  num := 9;
      CSC_property11:  num := 10;
      CSC_property12:  num := 11;
      CSC_property13:  num := 12;
      CSC_property14:  num := 13;
      CSC_property15:  num := 14;
      CSC_property16:  num := 15;
      CSC_property17:  num := 16;
      CSC_property18:  num := 17;
      CSC_property19:  num := 18;
      CSC_property20:  num := 19;
      CSC_property21:  num := 20;
      CSC_property22:  num := 21;
      CSC_property23:  num := 22;
      CSC_property24:  num := 23;
      CSC_property25:  num := 24;
      CSC_property26:  num := 25;
      CSC_property27:  num := 26;
      CSC_property28:  num := 27;
      CSC_property29:  num := 28;
      CSC_property30:  num := 29;
      CSC_property31:  num := 30;
      CSC_property32:  num := 31;
      CSC_property33:  num := 32;
      CSC_property34:  num := 33;
      CSC_property35:  num := 34;
      CSC_property36:  num := 35;
      CSC_property37:  num := 36;
      CSC_property38:  num := 37;
      CSC_property39:  num := 38;
      CSC_property40:  num := 39;
      CSC_property41:  num := 40;
      CSC_property42:  num := 41;
      CSC_property43:  num := 42;
      CSC_property44:  num := 43;
      CSC_property45:  num := 44;
      CSC_property46:  num := 45;
      CSC_property47:  num := 46;
      CSC_property48:  num := 47;
      CSC_property49:  num := 48;
      CSC_property50:  num := 49;
      CSC_property51:  num := 50;
      CSC_property52:  num := 51;
      CSC_property53:  num := 52;
      CSC_property54:  num := 53;
      CSC_property55:  num := 54;
      CSC_property56:  num := 55;
      CSC_property57:  num := 56;
      CSC_property58:  num := 57;
      CSC_property59:  num := 58;
      CSC_property60:  num := 59

    end;

    if (num <> -1) then
    begin
      pId := DBAppGlobals.ShowBinPropArry[num];
      if pId <> nil then
      begin
        CBField1.Items.Add(GetPropDescr(pId));
        CBField2.Items.Add(GetPropDescr(pId));
        CBField3.Items.Add(GetPropDescr(pId));
        CBField4.Items.Add(GetPropDescr(pId));
        CBField5.Items.Add(GetPropDescr(pId));
      end;
    end;
  end;

  if (m_CurrAutoSchedCfg.m_FieldArrayForSort[1].Field <> CSC_NotSorted) then
  begin
    if m_CurrAutoSchedCfg.m_FieldArrayForSort[1].Field = CSC_Overlapping then
       CBField1.ItemIndex := 0
    else
      CBField1.ItemIndex := m_CurrAutoSchedCfg.m_FieldArrayForSort[1].Pos + 1;
  end;

  if (m_CurrAutoSchedCfg.m_FieldArrayForSort[2].Field <> CSC_NotSorted) then
  begin
    if m_CurrAutoSchedCfg.m_FieldArrayForSort[2].Field = CSC_Overlapping then
       CBField2.ItemIndex := 0
    else
      CBField2.ItemIndex := m_CurrAutoSchedCfg.m_FieldArrayForSort[2].Pos + 1;
  end;

  if (m_CurrAutoSchedCfg.m_FieldArrayForSort[3].Field <> CSC_NotSorted) then
  begin
    if m_CurrAutoSchedCfg.m_FieldArrayForSort[3].Field = CSC_Overlapping then
       CBField3.ItemIndex := 0
    else
      CBField3.ItemIndex := m_CurrAutoSchedCfg.m_FieldArrayForSort[3].Pos + 1;
  end;

  if (m_CurrAutoSchedCfg.m_FieldArrayForSort[4].Field <> CSC_NotSorted) then
  begin
    if m_CurrAutoSchedCfg.m_FieldArrayForSort[4].Field = CSC_Overlapping then
       CBField4.ItemIndex := 0
    else
      CBField4.ItemIndex := m_CurrAutoSchedCfg.m_FieldArrayForSort[4].Pos + 1;
  end;

  if (m_CurrAutoSchedCfg.m_FieldArrayForSort[5].Field <> CSC_NotSorted) then
  begin
    if m_CurrAutoSchedCfg.m_FieldArrayForSort[5].Field = CSC_Overlapping then
       CBField5.ItemIndex := 0
    else
      CBField5.ItemIndex := m_CurrAutoSchedCfg.m_FieldArrayForSort[5].Pos + 1;
  end;

end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedCfg.IniConnectionAutoSeqTable_JOBTOJOBDEFINITIONS;
var
  StrFilter : string;
  LocalTableName : string;
begin
  FDTable2.close;
  FDTable2.Connection := GetCfgConnection;
  LocalTableName := 'AUTO_SEQ_JOBTOJOB_DEFINE';

  if IniAppGlobals.DownloadTo <> '2' then
    LocalTableName  := 'SCDC_' + 'AUTO_SEQ_JOBTOJOB_DEFINE';

  FDTable2.TableName := LocalTableName;

  FDTable2.Transaction := CreateTransaction(Cfg_DB);

  FDTable2.Open;
  StrFilter := 'AJ_WKST_CODE = ' + QuotedStr(IniAppGlobals.WkstCode);

  StrFilter :=  StrFilter + ' and AJ_IDENTIFIER = ' + QuotedStr(IniAppGlobals.Identifier);
  StrFilter :=  StrFilter + ' and AJ_CFGNAME = ' + QuotedStr(m_CurrAutoSchedCfg.m_CfgName);
  StrFilter :=  StrFilter + ' Order by AJ_FROM_CASE';

  FDTable2.Filter :=  StrFilter;

  DBGrid2.Columns[0].Title.Caption  := _('From case');    //
  DBGrid2.Columns[0].Title.Font.Name := 'Montserrat';
  DBGrid2.Columns[1].Title.Caption  := _('To case');
  DBGrid2.Columns[1].Title.Font.Name := 'Montserrat';
  DBGrid2.Columns[2].Title.Caption  := _('Score addition');
  DBGrid2.Columns[2].Title.Font.Name := 'Montserrat';

  DBGrid2.Columns[0].Width := 100;
  DBGrid2.Columns[1].Width := 100;
  DBGrid2.Columns[2].Width := 120;

end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedCfg.ShowCurrConf;
var
  i : integer;
  Year, Month, Day: Word;
  Hour, Min, Sec, MSec: Word;
begin

  EdtCfgName.Text               := m_CurrAutoSchedCfg.m_CfgName;
  EdtCfgDesc.Text               := m_CurrAutoSchedCfg.m_CfgDesc;

  EdtCfgGroup.Text              := m_CurrAutoSchedCfg.m_CfgGroup;
//  RGRunningMode.ItemIndex       := m_CurrAutoSchedCfg.m_RunningMode;
//  RGRunningMode.ItemIndex := 1;
 // CBNextConfig.ItemIndex := m_CurrAutoSchedCfg.m_CfgNameNext;
// --- NEW - START

  // TabSheet Preferences
  RGJobSchedDate.ItemIndex := m_CurrAutoSchedCfg.m_PrefTgtDate;
  CBPrevOrNextLinkedJobIsTheTgtDateWhenScheduled.Checked := m_CurrAutoSchedCfg.m_PrevOrNextLinkedJobIsTheTgtDateWhenScheduled;
  RGAlreadySchedEnt.ItemIndex := m_CurrAutoSchedCfg.m_MoveObjsAllowed;

  CBTextLog.Checked := m_CurrAutoSchedCfg.m_CreateLog;

  for i := 0 to CLBConLevelsToMove.Items.Count -1 do
    CLBConLevelsToMove.Checked[i] := false;

  for i := 0 to DBAppGlobals.ConfLevels do
    case i of
      0: if m_CurrAutoSchedCfg.m_MoveFinalObjsAlwd = 1 then CLBConLevelsToMove.Checked[i] := true;
      1: if m_CurrAutoSchedCfg.m_MoveInitialObjsAlwd = 1 then CLBConLevelsToMove.Checked[i] := true;
      2: if m_CurrAutoSchedCfg.m_MoveLevel1ObjsAlwd  = 1 then CLBConLevelsToMove.Checked[i] := true;
      3: if m_CurrAutoSchedCfg.m_MoveLevel2ObjsAlwd  = 1 then CLBConLevelsToMove.Checked[i] := true;
      4: if m_CurrAutoSchedCfg.m_MoveLevel3ObjsAlwd  = 1 then CLBConLevelsToMove.Checked[i] := true;
      5: if m_CurrAutoSchedCfg.m_MoveLevel4ObjsAlwd  = 1 then CLBConLevelsToMove.Checked[i] := true;
      6: if m_CurrAutoSchedCfg.m_MoveLevel5ObjsAlwd  = 1 then CLBConLevelsToMove.Checked[i] := true;
    end;

 // DTPScheduleStartDate.Date := Date + m_CurrAutoSchedCfg.m_MinStartDateOffset;
  RGResSchedType.ItemIndex := m_CurrAutoSchedCfg.m_TempFinal;
  CBoxShowRankReport.Checked := m_CurrAutoSchedCfg.m_RankRep;
  CBStopOnFirstNotSchedJob.checked := m_CurrAutoSchedCfg.m_StopOnFirstNotSchedJob;

  if m_CurrAutoSchedCfg.m_SplitSchedByBatchSize = ByMachinesOptimum then
    RGAutoSplitByBtach.ItemIndex := 0
  else if m_CurrAutoSchedCfg.m_SplitSchedByBatchSize = ByEqualQuantity then
    RGAutoSplitByBtach.ItemIndex := 1
  else if m_CurrAutoSchedCfg.m_SplitSchedByBatchSize = BalancingAll then
    RGAutoSplitByBtach.ItemIndex := 2
  else if m_CurrAutoSchedCfg.m_SplitSchedByBatchSize = DailyProductionAndJoin then
    RGAutoSplitByBtach.ItemIndex := 3
  else if m_CurrAutoSchedCfg.m_SplitSchedByBatchSize = ByMachinesOptimumForceSplit then
    RGAutoSplitByBtach.ItemIndex := 4
  else if m_CurrAutoSchedCfg.m_SplitSchedByBatchSize = LongestDurationPossible then
    RGAutoSplitByBtach.ItemIndex := 5;

  if m_CurrAutoSchedCfg.m_CreteriaOfResForBachZise = AnyResource then
    RGCreteriaOfRes.ItemIndex := 0;
  if m_CurrAutoSchedCfg.m_CreteriaOfResForBachZise = OnlySameSize then
    RGCreteriaOfRes.ItemIndex := 1;
  if m_CurrAutoSchedCfg.m_CreteriaOfResForBachZise = SameSizeExcpetSmallesBatch then
    RGCreteriaOfRes.ItemIndex := 2;

  if m_CurrAutoSchedCfg.m_LastSplitCanGoUnderMin then
    RGLastSpitCanGoMinMachin.ItemIndex := 0
  else
    RGLastSpitCanGoMinMachin.ItemIndex := 1;

  // TabSheet Requirements
  RGSchedWOMaterials.ItemIndex := m_CurrAutoSchedCfg.m_MatWOMaterials;
  RGSchedWOAddResources.ItemIndex := m_CurrAutoSchedCfg.m_MatWOAddRes;
  RGIgnoreRightOverlapping.ItemIndex := m_CurrAutoSchedCfg.m_IgnoreRightOverlapping;
  RGIgnoreLeftOverlapping.ItemIndex  := m_CurrAutoSchedCfg.m_IgnoreLeftOverlapping;

  // TabSheet Schedule limits
  SEdtMinCompJobToRes.Value := m_CurrAutoSchedCfg.m_MinJobResComp;
  SEdtMinCompJobToJob.Value := m_CurrAutoSchedCfg.m_MinJobJobComp;
  SEdtMaxCompJobToJob.Value := m_CurrAutoSchedCfg.m_MaxJobJobComp;
  SEdtMinCompJobToResComp.Value := m_CurrAutoSchedCfg.m_MinJobCapResComp;

  CBAllowSchedBeforeNoneMovedConfLevl.Checked := m_CurrAutoSchedCfg.m_AllowSchedBeforeNoneConfLevl;

  RGBeforeEarlDate.ItemIndex := m_CurrAutoSchedCfg.m_BeforeLowLimit;
  SEdtBefEarlDays.Value := m_CurrAutoSchedCfg.m_TollBeforeLowLimit;
  SEdtBefEarlHours.Value := m_CurrAutoSchedCfg.m_TollBeforeLowLimitHours;
  SEdtBefEarlMinutes.Value := m_CurrAutoSchedCfg.m_TollBeforeLowLimitMinutes;
  RGAfterLatDate.ItemIndex := m_CurrAutoSchedCfg.m_AfterHighLimit;
  SEdtAfterLatDays.Value := m_CurrAutoSchedCfg.m_TollAfterHighLimit;
  SEdtAfterLatHours.Value := m_CurrAutoSchedCfg.m_TollAfterHighLimitHours;
  SEdtAfterLatMinutes.Value := m_CurrAutoSchedCfg.m_TollAfterHighLimitMinutes;
  SpinEdtHoursToleranceOfGapBetweenJobs.Value := m_CurrAutoSchedCfg.m_HoursToleranceOfGapBetweenJobs;
  CBunscheduleEarliesJobWhenAboveTolerance.Checked := m_CurrAutoSchedCfg.m_RescheduleErlierJobsWhenTolerance;
  CBForceSameWcPlantToServingGroup.Checked := m_CurrAutoSchedCfg.m_AllServingGroupJobsSamePlant;
  EditCalendarForDatesPenalty.Text := m_CurrAutoSchedCfg.m_CalendarForDatesPenalty;

  // TabSheet Schedule Score
  if m_CurrAutoSchedCfg.m_PenCompSetupMinutes > 0 then
    rgJobOrSetup.ItemIndex := 1
  else
    rgJobOrSetup.ItemIndex := 0;

  EdtEarlBefore.Text := Format('%3.2f', [m_CurrAutoSchedCfg.m_BeforeEarlDateTol]);
  EdtEarlWith.Text := Format('%3.2f', [m_CurrAutoSchedCfg.m_WithinEarlDateTol]);
  EdtPenaltyScoreWithinTol.Text := Format('%3.2f', [m_CurrAutoSchedCfg.m_PenaltyScoreWithinTolerance]);
  EdtPenaltyScoreAfterTol.Text := Format('%3.2f', [m_CurrAutoSchedCfg.m_PenaltyScoreAfterTolerance]);
  EdtAfterLatest.Text := Format('%3.2f', [m_CurrAutoSchedCfg.m_AfterLatestDateTol]);
  EdtAfterWith.Text := Format('%3.2f', [m_CurrAutoSchedCfg.m_WithinLatestDateTol]);
  EditScheduleToPossibleStartPenalty.Text := Format('%3.2f', [m_CurrAutoSchedCfg.m_ScheduleToPossibleStartPenalty]);
  EdtJobToJob.Text := Format('%3.2f', [m_CurrAutoSchedCfg.m_PenCompJobToJob]);
  EdtSetupPen.Text := Format('%3.2f', [m_CurrAutoSchedCfg.m_PenCompSetupMinutes]);
  EdtJobToRes.Text := Format('%3.2f', [m_CurrAutoSchedCfg.m_PenCompJobToRes]);
  EdtJobToCapRes.Text := Format('%3.2f', [m_CurrAutoSchedCfg.m_PenCompJobToCapRes]);
  EdtJobNotCapRes.Text := Format('%3.2f', [m_CurrAutoSchedCfg.m_PenCompJobNotCapRes]);
  SEdtDateScore.Value := Trunc(m_CurrAutoSchedCfg.m_DateScoreWeight);
  SEdtCompScore.Value := Trunc(m_CurrAutoSchedCfg.m_CompScoreWeight);

  // Others
  SEdtSleepTime.Value := Round(m_CurrAutoSchedCfg.m_Sleep / 100);
  cboxShowGraph.Checked := m_CurrAutoSchedCfg.m_GraphOnMove;

  if not m_CurrAutoSchedCfg.m_LoadedResource then
    RadGrpResLoaded.ItemIndex := 0
  else
    RadGrpResLoaded.ItemIndex := 1;

{  if not m_CurrAutoSchedCfg.m_LoadedOnSameResCat then
    RadGrpmLoadedOnSameResCat.ItemIndex := 0
  else
    RadGrpmLoadedOnSameResCat.ItemIndex := 1;  }

 { if m_CurrAutoSchedCfg.m_LimitGapBtwnSubSteps = '0' then
     RadioGrpLimitGapBtwnSubSteps.ItemIndex := 0
  else if m_CurrAutoSchedCfg.m_LimitGapBtwnSubSteps = '1' then
    RadioGrpLimitGapBtwnSubSteps.ItemIndex := 1;  }

  SEdtLimitDaysGapBtwnSubSteps.Value := m_CurrAutoSchedCfg.m_ToleranceDaysGapBtwnSubSteps;
  SEdtLimitHoursGapBtwnSubSteps.Value := m_CurrAutoSchedCfg.m_ToleranceHoursGapBtwnSubSteps;
  SEdtLimitMinGapBtwnSubSteps.Value := m_CurrAutoSchedCfg.m_ToleranceMinGapBtwnSubSteps;

  if m_CurrAutoSchedCfg.m_SortBeforeSchedule then
    RGroupSortbeforeschedule.ItemIndex := 1
  else
    RGroupSortbeforeschedule.ItemIndex := 0;

  if m_CurrAutoSchedCfg.m_FieldArrayForSort[1].Field = CSC_NotSorted then
    CBField1.ItemIndex := -1
  else if m_CurrAutoSchedCfg.m_FieldArrayForSort[1].Field = CSC_Overlapping then
    CBField1.ItemIndex := 0
  else
    CBField1.ItemIndex := m_CurrAutoSchedCfg.m_FieldArrayForSort[1].pos;

  if m_CurrAutoSchedCfg.m_FieldArrayForSort[2].Field = CSC_NotSorted then
    CBField2.ItemIndex := -1
  else if m_CurrAutoSchedCfg.m_FieldArrayForSort[2].Field = CSC_Overlapping then
    CBField2.ItemIndex := 0
  else
    CBField2.ItemIndex := m_CurrAutoSchedCfg.m_FieldArrayForSort[2].pos;

  if m_CurrAutoSchedCfg.m_FieldArrayForSort[3].Field = CSC_NotSorted then
    CBField3.ItemIndex := -1
  else if m_CurrAutoSchedCfg.m_FieldArrayForSort[3].Field = CSC_Overlapping then
    CBField3.ItemIndex := 0
  else
    CBField3.ItemIndex := m_CurrAutoSchedCfg.m_FieldArrayForSort[3].pos;

  if m_CurrAutoSchedCfg.m_FieldArrayForSort[4].Field = CSC_NotSorted then
    CBField4.ItemIndex := -1
  else if m_CurrAutoSchedCfg.m_FieldArrayForSort[4].Field = CSC_Overlapping then
    CBField4.ItemIndex := 0
  else
    CBField4.ItemIndex := m_CurrAutoSchedCfg.m_FieldArrayForSort[4].pos;

  if m_CurrAutoSchedCfg.m_FieldArrayForSort[5].Field = CSC_NotSorted then
    CBField5.ItemIndex := -1
  else if m_CurrAutoSchedCfg.m_FieldArrayForSort[5].Field = CSC_Overlapping then
    CBField5.ItemIndex := 0
  else
    CBField5.ItemIndex := m_CurrAutoSchedCfg.m_FieldArrayForSort[5].pos;

  CBNextConfig.Items.Clear;
  CBNextConfig.Items.add('');
  for I := 0 to LBConfigs.Items.Count - 1 do
  begin
    if (LBConfigs.Items[I] <> m_CurrAutoSchedCfg.m_CfgName) then
        CBNextConfig.Items.Add(LBConfigs.Items[I]);
  end;
  CBNextConfig.ItemIndex := CBNextConfig.Items.IndexOf(m_CurrAutoSchedCfg.m_CfgNameNext);

  RGStartScheduleFrom.ItemIndex := m_CurrAutoSchedCfg.m_StartSchedFrom;

  DecodeDate(now, Year, Month, Day);
  DatePicker.Date := EncodeDate(Year, Month, Day);
  DecodeTime(time, Hour, Min, Sec, MSec);
  TimePicker.time := EncodeTime(Hour, Min, Sec, MSec);

  if m_CurrAutoSchedCfg.m_StartSchedFrom = 1 then
  begin
    DecodeDate(m_CurrAutoSchedCfg.m_SpecificDateTime, Year, Month, Day);
    DatePicker.Date := EncodeDate(Year, Month, Day);
    DecodeTime(m_CurrAutoSchedCfg.m_SpecificDateTime, Hour, Min, Sec, MSec);
    TimePicker.time := EncodeTime(Hour, Min, Sec, MSec);
  end

  else if m_CurrAutoSchedCfg.m_StartSchedFrom = 2 then
  begin
    SpinEdtNumDays.Value := m_CurrAutoSchedCfg.m_NumberOfDaysFromCurrentDate;
  end;

  RadioGroupLatestDateLimit.ItemIndex := m_CurrAutoSchedCfg.m_AllowedLatestDateLimit;
  RadioGroupDateLimitType.ItemIndex := m_CurrAutoSchedCfg.m_AllowedDatelimitType;
  ExSpinEditLatestDateOfScheduleNbrOfDays.Value := m_CurrAutoSchedCfg.m_LatestDateScheduleNbrOfDays;

  DecodeDate(now, Year, Month, Day);
  DateTimePickerLatestDateOfSchedule.Date := EncodeDate(Year, Month, Day);

  if (m_CurrAutoSchedCfg.m_AllowedDatelimitType = 0) and (m_CurrAutoSchedCfg.m_LatestDateSchedule > 0) then
  begin
    DecodeDate(m_CurrAutoSchedCfg.m_LatestDateSchedule, Year, Month, Day);
    DateTimePickerLatestDateOfSchedule.Date := EncodeDate(Year, Month, Day);
  end

end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedCfg.LBConfigsClick(Sender: TObject);
begin
  SaveConf;
  m_CurrAutoSchedCfg := GetAutoSchedCfg(LBConfigs.Items[LBConfigs.ItemIndex]);
  if not Assigned(m_CurrAutoSchedCfg) then
    m_CurrAutoSchedCfg := GetAutoSchedCfg('DEFAULT');

  ShowCurrConf;
//  IniConnectionAutoSeqTable_SCORE_ADDITION;
  IniConnectionAutoSeqTable_JOBTOJOBDEFINITIONS;
end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedCfg.EdtCfgNameChange(Sender: TObject);
begin
  if Trim(EdtCfgName.Text) <> '' then
  begin
    BtnOk.Enabled := true;

    BtnDelete.Enabled := true;

  end else
  begin
    BtnOk.Enabled := false;

    BtnDelete.Enabled := false;

  end
end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedCfg.BitBtnClearClick(Sender: TObject);
begin
  if (TcxButton(sender).Name = BTnClear1.Name) then
     CBField1.ItemIndex := -1
  else if (TcxButton(sender).Name = BTnClear2.Name) then
     CBField2.ItemIndex := -1
  else if (TcxButton(sender).Name = BTnClear3.Name) then
     CBField3.ItemIndex := -1
  else if (TcxButton(sender).Name = BTnClear4.Name) then
     CBField4.ItemIndex := -1
  else if (TcxButton(sender).Name = BTnClear5.Name) then
     CBField5.ItemIndex := -1
end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedCfg.btnAboClick(Sender: TObject);
begin
  Close;
end;

procedure TFAutoSchedCfg.BtnDeleteClick(Sender: TObject);
begin
  if m_CurrAutoSchedCfg.m_CfgName = 'DEFAULT' then
  begin
    MessageDlg(_('Is not possible to delete the default configuration'), mtWarning, [mbOk], 0);
    exit
  end;

  if AutoSchedCfgList.Count = 1 then
  begin
    MessageDlg(_('Is not possible to delete last configuration'), mtWarning, [mbOk], 0);
    exit
  end;

  if MessageDlg(_('Do you want to delete the configuration selected?'), mtConfirmation, [mbYes, mbNo], 0) = idYes then
  begin
    EreaseCfg(m_CurrAutoSchedCfg);

    LoadVersions;
    if LBConfigs.Items.Count > 0 then
    begin
      LBConfigs.ItemIndex := 0;
      EdtCfgName.Text :=  LBConfigs.Items[LBConfigs.ItemIndex];
      LBConfigsClick(nil)
    end;

    SetAsActiveCfg(m_CurrAutoSchedCfg);
    DBAppGlobals.ActAutoSched := m_CurrAutoSchedCfg.m_CfgName;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedCfg.BtnOk1Click(Sender: TObject);
begin
  DBAppGlobals.Change_AutoRunDefinition := true;
  AutoSchedCfg.m_LogLocation := trim(EditLogLocation.Text);
end;

procedure TFAutoSchedCfg.BtnOkClick(Sender: TObject);
begin
  CheckData;
  if ModalResult = mrOk then
    BtnOk1.Click;
end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedCfg.TBarChange(Sender: TObject);
begin
  TBar_ShowSelection(Sender as TTrackBar)
end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedCfg.SEdtCompScoreChange(Sender: TObject);
begin
//  SEdtDateScore.Text := IntToStr(100 - StrToInt(SEdtCompScore.Text));
end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedCfg.SEdtDateScoreChange(Sender: TObject);
begin
//  SEdtCompScore.Text := IntToStr(100 - StrToInt(SEdtDateScore.Text));
end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedCfg.EdtEarlBeforeKeyPress(Sender: TObject; var Key: Char);

  function WrongValue: boolean;
  var
    i : integer;
    Edt: TEdit;
    PosDecSep, CountDec, CountInt: integer;
  begin
    Result := false;
    CountInt := 0;
    CountDec := 0;
    Edt := TEdit(Sender);
    PosDecSep := Pos(FormatSettings.DecimalSeparator, Edt.Text);
    for i := 1 to Length(Edt.Text) do
    begin
      if (PosDecSep = 0) or
         ((PosDecSep > 0) and (i < PosDecSep)) then  Inc(CountInt);
      if (PosDecSep > 0) and (i > PosDecSep) then Inc(CountDec);
    end;

    if (Key = FormatSettings.DecimalSeparator) and (PosDecSep > 0) then Result := true;
    if (CharInSet(Key, ['0'..'9'])) and (Edt.SelLength = 0) then
    begin
      if (CountInt >= 3) and (PosDecSep = 0) then Result := true;
      if (CountInt >= 3) and (PosDecSep > 0) and (Edt.SelStart < PosDecSep) then Result := true;
      if (CountDec >= 2) and (Edt.SelStart > PosDecSep) then Result := true;
    end;
  end;

begin
  if (TEdit(Sender).SelLength = 0) or (TEdit(Sender).SelText = FormatSettings.DecimalSeparator) then
  begin
    if not ((CharInSet(Key, ['0'..'9'])) or (key = chr(vk_Back)) or (key = FormatSettings.DecimalSeparator)) then abort;
    if (key = chr(46)) and (key <> FormatSettings.DecimalSeparator) then Abort;
    if WrongValue then Abort;
  end;

end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedCfg.CheckKeyPress(Sender: TObject; var Key: Char);
var
  Edt: TEdit;
begin
  if (TEdit(Sender).SelLength = 0) or (TEdit(Sender).SelText = FormatSettings.DecimalSeparator) then
  begin
    if not ((CharInSet(Key, ['0'..'9'])) or (key = chr(vk_Back)) or (key = FormatSettings.DecimalSeparator)) then abort;
  end;
end;


procedure TFAutoSchedCfg.EdtEarlBeforeExit(Sender: TObject);
var
  Edt : TEdit;
begin
  Edt := TEdit(Sender);
  if Trim(Edt.Text) = '' then Edt.Text := '0';
  if StrToFloat(Edt.Text) > 9999999.99 then
  begin
    MessageDlg(_('The value is not valid (max is 999.99)'), mtWarning, [mbOk], 0);
    Edt.SetFocus;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedCfg.btnRstPreferencesClick(Sender: TObject);
var
  i : integer;
begin
  RGJobSchedDate.ItemIndex := DFT_PrefTgtDate;
  CBPrevOrNextLinkedJobIsTheTgtDateWhenScheduled.Checked := false;
  RGAlreadySchedEnt.ItemIndex := DFT_MoveObjsAllowed;

  for i := 0 to CLBConLevelsToMove.Items.Count -1 do
    CLBConLevelsToMove.Checked[i] := false;

//  DTPScheduleStartDate.Date := Date;
  RGResSchedType.ItemIndex := DFT_TempFinal;
  CBoxShowRankReport.Checked := DFT_RankRep;
  CBStopOnFirstNotSchedJob.Checked := DFT_StopOnFirstNotSchedJob;

  m_CurrAutoSchedCfg.m_PriorErrLoop :=   DFT_PriorErrLoop; // Always true
end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedCfg.btnRstRequirementsClick(Sender: TObject);
begin
  RGSchedWOMaterials.ItemIndex    := DFT_MatWOMaterials;
  RGSchedWOAddResources.ItemIndex := DFT_MatWOAddRes;
end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedCfg.btnRstSchedLimitsClick(Sender: TObject);
begin
  SEdtMinCompJobToRes.Value      := DFT_MinJobResComp;
  SEdtMinCompJobToJob.Value      := DFT_MinJobJobComp;
  SEdtMaxCompJobToJob.Value      := DFT_MaxJobJobComp;
  SEdtMinCompJobToResComp.Value   := DFT_MinJobCapResComp;
  RGBeforeEarlDate.ItemIndex := DFT_BeforeLowLimit;
  SEdtBefEarlDays.Value := DFT_TollBeforeLowLimit;
  SEdtBefEarlHours.Value := DFT_TollBeforeLowLimitHours;
  SEdtBefEarlMinutes.Value := DFT_TollBeforeLowLimitMinutes;
  RGAfterLatDate.ItemIndex := DFT_AfterHighLimit;
  SEdtAfterLatDays.Value := DFT_TollAfterHighLimit;
  SEdtAfterLatHours.Value := DFT_TollAfterHighLimitHours;
  SEdtAfterLatMinutes.Value := DFT_TollAfterHighLimitMinutes;
end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedCfg.btnRestSchedScoreClick(Sender: TObject);
begin
  EdtEarlBefore.Text := Format('%3.2f', [DFT_BeforeEarlDateTol]);
  EdtEarlWith.Text := Format('%3.2f', [DFT_WithinEarlDateTol]);
  EdtPenaltyScoreWithinTol.Text := Format('%3.2f', [DFT_PenaltyScorewithinTolerance]);
  EdtPenaltyScoreAfterTol.Text := Format('%3.2f', [DFT_PenaltyScoreAfterTolerance]);
  EdtAfterLatest.Text := Format('%3.2f', [DFT_AfterLatestDateTol]);
  EdtAfterWith.Text := Format('%3.2f', [DFT_WithinLatestDateTol]);
  EdtJobToJob.Text := Format('%3.2f', [DFT_PenCompJobToJob]);
  EdtSetupPen.Text := Format('%3.2f', [DFT_PenCompSetupMinutes]);
  EdtJobToRes.Text := Format('%3.2f', [DFT_PenCompJobToRes]);
  EdtJobToCapRes.Text := Format('%3.2f', [DFT_PenCompJobToCapRes]);
  EdtJobNotCapRes.Text := Format('%3.2f', [DFT_PenCompJobNotCapRes]);
  SEdtDateScore.Value := DFT_DateScoreWeight;
  SEdtCompScore.Value := DFT_CompScoreWeight;

  rgJobOrSetup.ItemIndex := 0;
end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedCfg.btnRstOthersClick(Sender: TObject);
begin
  SEdtSleepTime.Value := DFT_Sleep;
  cboxShowGraph.Checked := DFT_GraphOnMove;
end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedCfg.BtnRstAllClick(Sender: TObject);
var
  OldCfgName, OldCfgDesc: string;
begin
  OldCfgName := m_CurrAutoSchedCfg.m_CfgName;
  OldCfgDesc := m_CurrAutoSchedCfg.m_CfgDesc;

  SetDefaultAutoSchedCfg(m_CurrAutoSchedCfg);

  m_CurrAutoSchedCfg.m_CfgName := OldCfgName;
  m_CurrAutoSchedCfg.m_CfgDesc := OldCfgDesc;

  ShowCurrConf;

  rgJobOrSetup.ItemIndex := 0;
end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedCfg.RGCompactEntClick(Sender: TObject);
begin
end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedCfg.RGBeforeEarlDateClick(Sender: TObject);
begin
  if not m_FormShow then exit;

  SEdtBefEarlDays.Enabled := (RGBeforeEarlDate.ItemIndex <> 2);
  if not SEdtBefEarlDays.Enabled then
    SEdtBefEarlDays.Value := 0;
  SEdtBefEarlHours.Enabled := (RGBeforeEarlDate.ItemIndex <> 2);
  if not SEdtBefEarlHours.Enabled then
    SEdtBefEarlHours.Value := 0;
  SEdtBefEarlMinutes.Enabled := (RGBeforeEarlDate.ItemIndex <> 2);
  if not SEdtBefEarlMinutes.Enabled then
    SEdtBefEarlMinutes.Value := 0;

  if (RGJobSchedDate.ItemIndex = 2) and (RGBeforeEarlDate.ItemIndex > 0) then
  begin
    Showmessage(_('When target date is "Today" there can not be a limit for "Before date"'));
    RGBeforeEarlDate.ItemIndex := 0;
    exit
  end;

end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedCfg.RGAfterLatDateClick(Sender: TObject);
begin
  SEdtAfterLatDays.Enabled := (RGAfterLatDate.ItemIndex <> 2);
  if not SEdtAfterLatDays.Enabled then
    SEdtAfterLatDays.Value := 0;
  SEdtAfterLatHours.Enabled := (RGAfterLatDate.ItemIndex <> 2);
  if not SEdtAfterLatHours.Enabled then
    SEdtAfterLatHours.Value := 0;
  SEdtAfterLatMinutes.Enabled := (RGAfterLatDate.ItemIndex <> 2);
  if not SEdtAfterLatMinutes.Enabled then
    SEdtAfterLatMinutes.Value := 0;
end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedCfg.rgJobOrSetupClick(Sender: TObject);
begin
  if rgJobOrSetup.ItemIndex = 0 then
  begin
    Label14.Visible := true;
    EdtJobToJob.Visible := true;
    Label15.Visible := False;
    EdtSetupPen.Visible := False;
    EdtJobToJob.Text := Format('%3.2f', [m_CurrAutoSchedCfg.m_PenCompJobToJob]);
    EdtSetupPen.Text := '0';
  end else
  begin
    Label15.Visible := true;
    EdtSetupPen.Visible := true;
    Label14.Visible := false;
    EdtJobToJob.Visible := false;
    EdtJobToJob.Text := '0';
    EdtSetupPen.Text := Format('%3.2f', [m_CurrAutoSchedCfg.m_PenCompSetupMinutes]);
  end;
end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedCfg.RGJobSchedDateClick(Sender: TObject);
begin
  if (RGJobSchedDate.ItemIndex = 2) then
  begin
  //  Showmessage('Running mode error : "Step job schedule date" must be set to Earliest = Today');
    RGBeforeEarlDate.ItemIndex := 0;
  end
  else
    EditScheduleToPossibleStartPenalty.Text := '0';

  if (RGJobSchedDate.ItemIndex <> 2) then
  begin
    if CBunscheduleEarliesJobWhenAboveTolerance.checked then
    begin
      showmessage(_('When target date is not "Today" the "unschedule earlies job when above tolerance " flag must not be checked '));
      CBunscheduleEarliesJobWhenAboveTolerance.Checked := false;
    end;
  end;

end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedCfg.RGAlreadySchedEntClick(Sender: TObject);
begin
  if (RGAlreadySchedEnt.ItemIndex = 0) then
  begin
    Showmessage('Running mode error : "Allow moving entities with the following confirmation levels" Can not set to "Allow"');
     RGAlreadySchedEnt.ItemIndex := 1
  end;
end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedCfg.RGRunningModeClick(Sender: TObject);
begin
//  if RGRunningMode.ItemIndex = 1 then
//  begin
 {   if (RGJobSchedDate.ItemIndex <> -1) and (RGJobSchedDate.ItemIndex <> 2) then
    begin
      Showmessage(' "Step job schedule date" must be set to Earliest = Today');
      RGJobSchedDate.ItemIndex := 2
    end;

    if (RGAlreadySchedEnt.ItemIndex = 0) then
    begin
      Showmessage(' "Allow moving entities with the following confirmation levels" can not be set to "ALLOW"');
      RGAlreadySchedEnt.ItemIndex := 1
    end;  }


    RadGrpResLoaded.Visible := false;
    LblNextConfig.Visible   := false;
    CBNextConfig.Visible    := false;
    lblNextConfig.Visible    := false;// Mihailo
    CBStopOnFirstNotSchedJob.Visible      := false;
    CBoxShowRankReport.Visible            := false;
  //  RadioGrpLimitGapBtwnSubSteps.Visible  := false;
   // RadGrpmLoadedOnSameResCat.Visible     := false;
 //   LblJobToCap.Visible                   := false;
 //   SEdtMinCompJobToResComp.Visible       := false;
//    LblAllowGapDHM.Visible                := false;
    SEdtLimitDaysGapBtwnSubSteps.Visible  := false;
    SEdtLimitHoursGapBtwnSubSteps.Visible := false;
    SEdtLimitMinGapBtwnSubSteps.Visible   := false;
//    LBlBeforeErliestDayTolerance.Visible  := false;
//    SEdtBefEarlDays.Visible               := false;
//    SEdtBefEarlHours.Visible              := false;
//    SEdtBefEarlMinutes.Visible            := false;
//    LblStar1.Visible                      := false;
//    LblStar2.Visible                      := false;
//    LblStar3.Visible                      := false;

//    RGBeforeEarlDate.Visible              := false;

    LblPenaltyNew1.Visible                := true;
    LblPenaltyNew2.Visible                := true;
    LblPenaltyNew3.Visible                := true;
    EditScheduleToPossibleStartPenalty.Visible := true;

    RGAutoSplitByBtach.Visible            := true;
    RGCreteriaOfRes.Visible               := false;
    RGLastSpitCanGoMinMachin.Visible      := false;

 //   LblCfgGroupCode.Visible               := true;
 //   EdtCfgGroup.Visible                   := true;
 //   LBlDoNotSchedBefore.Visible           := false;
  //  DTPScheduleStartDate.Visible          := false;
    RGStartScheduleFrom.Visible           := true;

    LblDateTime.Visible                   := true;
    lblTime.Visible                       := true;
    DatePicker.Visible                    := true;
    TimePicker.Visible                    := true;
    GBStartScheduleFrom.Visible           := true;

    LblNumDaysFromCurrDate.Visible        := true;
    SpinEdtNumDays.Visible                := true;

    DBNavigator2.Visible                  := true;
    DBNavigator2.Left                     := 26;
    DBGrid2.Visible                       := true;
    DBGrid2.top                           := 74;
    GBWeight.Visible                      := false;
    CBTextLog.Visible                     := true;
    EditLogLocation.Visible               := true;
    RGLog.Visible                         := true;
    TbsServingGroup.Visible               := true;
    LblHoursToleranceOfGapBetweenJobs.Visible     := true;
    SpinEdtHoursToleranceOfGapBetweenJobs.Visible := true;
    LblPenaltyScoreWithinTol.Visible              := true;
    EdtPenaltyScoreWithinTol.Visible               := true;
    LblPenaltyScoreAfterTol.Visible               := true;
    EdtPenaltyScoreAfterTol.Visible               := true;
    RGIgnoreRightOverlapping.Visible              := true;
    RGIgnoreLeftOverlapping.Visible               := true;
    CBunscheduleEarliesJobWhenAboveTolerance.Visible   := true;
    CBAllowSchedBeforeNoneMovedConfLevl.Visible        := true;
    LblCalBalnk.Visible := true;
    EditCalendarForDatesPenalty.Visible := true;
    LblCalendarForDatesPenalty.Visible := true
//  end
{  else
  begin
    RadGrpResLoaded.Visible := true;
    LblNextConfig.Visible   := true;
    CBNextConfig.Visible    := true;
    CBStopOnFirstNotSchedJob.Visible     := true;
    CBoxShowRankReport.Visible           := true;
    RadioGrpLimitGapBtwnSubSteps.Visible := true;
    RadGrpmLoadedOnSameResCat.Visible    := true;
    LblJobToCap.Visible                  := true;
    SEdtMinCompJobToResComp.Visible      := true;
    LblAllowGapDHM.Visible               := true;
    SEdtLimitDaysGapBtwnSubSteps.Visible := true;
    SEdtLimitHoursGapBtwnSubSteps.Visible := true;
    SEdtLimitMinGapBtwnSubSteps.Visible   := true;
    LBlBeforeErliestDayTolerance.Visible  := true;
    SEdtBefEarlDays.Visible               := true;
    SEdtBefEarlHours.Visible              := true;
    SEdtBefEarlMinutes.Visible            := true;
    LblStar1.Visible                      := true;
    LblStar2.Visible                      := true;
    LblStar3.Visible                      := true;

    RGBeforeEarlDate.Visible              := true;
    LblPenaltyNew1.Visible                := false;
    LblPenaltyNew2.Visible                := false;
    LblPenaltyNew3.Visible                := false;
    EditScheduleToPossibleStartPenalty.Visible := false;
    RGAutoSplitByBtach.Visible            := true;
    RGCreteriaOfRes.Visible               := true;
    RGLastSpitCanGoMinMachin.Visible      := true;

    LblCfgGroupCode.Visible               := false;
    EdtCfgGroup.Visible                   := false;
    LBlDoNotSchedBefore.Visible           := true;
    DTPScheduleStartDate.Visible          := true;
    RGStartScheduleFrom.Visible           := false;
    LblDateTime.Visible                   := false;
    DatePicker.Visible                    := false;
    TimePicker.Visible                    := false;
    GBStartScheduleFrom.Visible           := false;
    LblNumDaysFromCurrDate.Visible        := false;
    SpinEdtNumDays.Visible                := false;
    DBNavigator1.Visible                  := true;
    DBGrid1.Visible                       := true;
    DBNavigator2.Visible                  := false;
    DBGrid2.Visible                       := false;
    GBWeight.Visible                      := true;
    CBTextLog.Visible                     := false;
    EditLogLocation.Visible               := false;
    RGLog.Visible                         := false;

    TbsServingGroup.Visible               := false;
    LblHoursToleranceOfGapBetweenJobs.Visible := false;
    SpinEdtHoursToleranceOfGapBetweenJobs.Visible := false;
    LblPenaltyScoreWithinTol.Visible               := false;
    EdtPenaltyScoreWithinTol.Visible              := false;
    LblPenaltyScoreAfterTol.Visible               := false;
    EdtPenaltyScoreAfterTol.Visible               := false;
    RGIgnoreRightOverlapping.Visible              := false;
    RGIgnoreLeftOverlapping.Visible               := false;
    CBunscheduleEarliesJobWhenAboveTolerance.Visible   := false;
    CBAllowSchedBeforeNoneMovedConfLevl.Visible             := false;

    LblCalBalnk.Visible := false;
    EditCalendarForDatesPenalty.Visible := false;
    LblCalendarForDatesPenalty.Visible := false

  end;   }

end;

procedure TFAutoSchedCfg.RGStartScheduleFromClick(Sender: TObject);
var
  Year, Month, Day: Word;
  Hour, Min, Sec, MSec: Word;
begin
  case RGStartScheduleFrom.ItemIndex of
    0 : begin
          DecodeDate(now, Year, Month, Day);
          DatePicker.Date := EncodeDate(Year, Month, Day);
          DecodeTime(time, Hour, Min, Sec, MSec);
          TimePicker.time := EncodeTime(Hour, Min, Sec, MSec);
        end;
    1 : begin
          DecodeDate(m_CurrAutoSchedCfg.m_SpecificDateTime, Year, Month, Day);
          DatePicker.Date := EncodeDate(Year, Month, Day);
          DecodeTime(m_CurrAutoSchedCfg.m_SpecificDateTime, Hour, Min, Sec, MSec);
          TimePicker.time := EncodeTime(Hour, Min, Sec, MSec);
        end;
    2 : begin
          DecodeDate(now, Year, Month, Day);
          DatePicker.Date := EncodeDate(Year, Month, Day);
          DecodeTime(time, Hour, Min, Sec, MSec);
          TimePicker.time := EncodeTime(Hour, Min, Sec, MSec);
          SpinEdtNumDays.Value := m_CurrAutoSchedCfg.m_NumberOfDaysFromCurrentDate;
        end;
  end;

end;

//----------------------------------------------------------------------------//

end.

