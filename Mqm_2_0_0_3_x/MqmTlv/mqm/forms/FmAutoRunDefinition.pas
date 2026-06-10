unit FmAutoRunDefinition;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, Buttons, Vcl.ExtCtrls,UReShape, ExSpinEdit;

type

  TUserDefOperation = (UD_Automatic_Sequencing, UD_split, UD_Unschedule_All, UD_Unschedule_All_LAST_OnGantt, UD_Close,
  UD_SET_Conf_Lvl_1, UD_SET_Conf_Lvl_2, UD_SET_Conf_Lvl_3, UD_SET_Conf_Lvl_4,
  UD_SET_Conf_Lvl_5,UD_SET_To_Initial, UD_SET_To_FINAL, UD_Save, UD_AutoSchedAllReBuildGenericPlan,
  UD_Set_bin_jobs_selection_property_False, UD_Set_bin_jobs_selection_property_true,
  UD_Set_bin_jobs_selection_property_False_AndServingCode, UD_Set_bin_jobs_selection_property_true_AndServingCode,
  UD_Set_bin_jobs_selection_Copy_Value_From_Next_LinkedStep,
//  UD_Set_linked_Steps_PropertyV_alue_From_Job_Selection,
  UD_CopySelectionPropertyFromCurrentStepToPrevAndNextStep,
  UD_CopySelectionPropertyFromCurrentStepToPrevStep,
  UD_CopySelectionPropertyFromCurrentStepToNextStep,
  UD_CopySelectionPropertyFromCurrentStepToPrevSteps,
  UD_CopySelectionpropertyFromCurrentStepToNextSteps,
  UD_SETAlterPlanedWcByPlant, UD_ReturnToOriginalWorkCerter, UD_SetjobslimitDates,
  UD_RemoveJobsCalculatedLimitDates, UD_BalanceImbalancedSteps, UD_JoinAllNotScheduledSubSteps,
  UD_putInAllAutoSeqCfgTheCurrDateTime, UD_SetSavedScheduleDate, UD_CreatePeriodResourceAndSendMail,
  UD_MCM_OverrParams_InfiniteCapacityAllowed, UD_MCM_RepositionJobsToRealMachines, UD_PushAllJobsToNow,
  UD_Start_Loop,
  UD_Go_To_Loop_Start_When_Bin_Has_jobs);

  TUserDefRecord = record
    SetCode   : string;
    Sequence  : integer;
    SequenceInDB : integer;
    Operation : TUserDefOperation;
    ActiveGanttTab : string;
    ActiveBinTab   : string;
    AutoSeqCfgName : string;
    MailGroupCode  : string;
  end;
  PTUserDefRecord = ^TUserDefRecord;

  TAutoRunDefinition = class(TForm)
    CBOperation: TComboBox;
    CBActiveGantt: TComboBox;
    CBActiveBin: TComboBox;
    LBlOperation: TLabel;
    LblActiveGanttTab: TLabel;
    LblActiveBinTab: TLabel;
    LblSequence: TLabel;
    SEdtSequence: TexSpinEdit;
    LblCfg: TLabel;
    CBAutoSeqCfgName: TComboBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    CBMailCodeList: TComboBox;
    LblMailCodeList: TLabel;
    BtnOk: TcxButton;
    BtnAbo: TcxButton;
    procedure FormCreate(Sender: TObject);
    procedure IniData;
    procedure CBOperationChange(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnAbortClick(Sender: TObject);
    procedure BtnAboClick(Sender: TObject);
  private
    m_Update : boolean;
    m_Sequence : Integer;
    m_UserDefRecord : PTUserDefRecord;
    m_mailGroupList : TStringList;
    function CheckData : boolean;
    { Private declarations }
  public
    constructor CreateNewSet(AOwner: TComponent; Code : string; Sequence : Integer; mailGroupList : TStringList);
    constructor UpdateSet(AOwner: TComponent; Code : string; UserDefRecord : PTUserDefRecord; mailGroupList : TStringList);
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses gnugettext, FMMainPlan, FMbin, UMAutoSchedCfg, UMglobal;

{ TAutoRunDefinition }

// -------------------------------------------------------------------------- //

procedure TAutoRunDefinition.BitBtn2Click(Sender: TObject);
begin
  ModalResult := mrOk;
  if not CheckData then
    ModalResult := mrNone
end;

// -------------------------------------------------------------------------- //

procedure TAutoRunDefinition.btnAbortClick(Sender: TObject);
begin
  Bitbtn1.Click;
end;

procedure TAutoRunDefinition.btnOkClick(Sender: TObject);
begin
  Bitbtn2.Click;
end;

procedure TAutoRunDefinition.BtnAboClick(Sender: TObject);
begin
  Close;
end;

procedure TAutoRunDefinition.CBOperationChange(Sender: TObject);
begin
  CBAutoSeqCfgName.Visible := false;
  LblCfg.Visible := false;
  CBActiveGantt.Visible := true;;
  LblActiveGanttTab.Visible := true;
  CBActiveBin.Visible := true;
  LblActiveBinTab.Visible := true;
  CBMailCodeList.Visible := false;
  LblMailCodeList.Visible := false;

  if DBAppGlobals.MCM_App then
  begin
    if (CBOperation.ItemIndex = 0) or (CBOperation.ItemIndex = 6) or (CBOperation.ItemIndex = 26) then
    begin
      CBAutoSeqCfgName.Visible := true;
      LblCfg.Visible := true;
    end;
  end
  else
  begin
    if (CBOperation.ItemIndex = 0) or (CBOperation.ItemIndex = 6) then
    begin
      CBAutoSeqCfgName.Visible := true;
      LblCfg.Visible := true;
    end;
  end;

  if DBAppGlobals.MCM_App then
  begin
    if (CBOperation.ItemIndex = 4) or (CBOperation.ItemIndex = 5) or (CBOperation.ItemIndex = 23) or
       (CBOperation.ItemIndex = 31) or (CBOperation.ItemIndex = 36) then
    begin
      CBActiveGantt.Visible := false;;
      LblActiveGanttTab.Visible := false;
      CBActiveBin.Visible := false;
      LblActiveBinTab.Visible := false;
    end;
  end
  else
  begin
    if (CBOperation.ItemIndex = 4) or (CBOperation.ItemIndex = 5) or (CBOperation.ItemIndex = 23) or (CBOperation.ItemIndex = 29) or
       (CBOperation.ItemIndex = 26) or (CBOperation.ItemIndex = 34) then
    begin
      CBActiveGantt.Visible := false;;
      LblActiveGanttTab.Visible := false;
      CBActiveBin.Visible := false;
      LblActiveBinTab.Visible := false;
    end;
  end;

  if (CBOperation.ItemIndex = 24) then
  begin
    CBActiveBin.Visible := false;
    LblActiveBinTab.Visible := false;
  end;

  if (CBOperation.ItemIndex = 25) then
  begin
    CBMailCodeList.Visible := true;
    LblMailCodeList.Visible := true;
  end;

end;

// -------------------------------------------------------------------------- //

function TAutoRunDefinition.CheckData: boolean;
begin
  Result := true;

  if DBAppGlobals.MCM_App then
  begin
    if ((CBOperation.ItemIndex = 0) or (CBOperation.ItemIndex = 6) or
       (CBOperation.ItemIndex = 26) or (CBOperation.ItemIndex = 27)) and (CBAutoSeqCfgName.ItemIndex = -1) then
    begin
      Showmessage(_('Automatic sequencing configuration CODE must be selected'));
      Result := false;
      exit
    end;
  end
  else
  begin
    if ((CBOperation.ItemIndex = 0) or (CBOperation.ItemIndex = 6)) and (CBAutoSeqCfgName.ItemIndex = -1) then
    begin
      Showmessage(_('Automatic sequencing configuration CODE must be selected'));
      Result := false;
      exit
    end;
  end;

  if (CBOperation.ItemIndex = -1) then
  begin
    Showmessage(_('Operation CODE must be selected'));
    Result := false;
    exit
  end;

  if DBAppGlobals.MCM_App then
  begin
    if not ((CBOperation.ItemIndex = 4) or (CBOperation.ItemIndex = 5) or (CBOperation.ItemIndex = 31) or
       (CBOperation.ItemIndex = 23) or (CBOperation.ItemIndex = 28)) then
    begin
      if CBActiveGantt.ItemIndex = -1 then
      begin
        Showmessage(_('Active Gantt tab must be selected'));
        Result := false
      end
      else if (CBOperation.ItemIndex <> 17) and (CBOperation.ItemIndex <> 24) and (CBActiveBin.ItemIndex = -1) then
      begin
        Showmessage(_('Active Bin tab must be selected'));
        Result := false
      end
    end;
  end
  else
  begin

    if not ((CBOperation.ItemIndex = 4) or (CBOperation.ItemIndex = 5) or (CBOperation.ItemIndex = 23) or  (CBOperation.ItemIndex = 26)) then
    begin
      if CBActiveGantt.ItemIndex = -1 then
      begin
        Showmessage(_('Active Gantt tab must be selected'));
        Result := false
      end
      else if (CBOperation.ItemIndex <> 17) and (CBOperation.ItemIndex <> 24) and (CBActiveBin.ItemIndex = -1) then
      begin
        Showmessage(_('Active Bin tab must be selected'));
        Result := false
      end
    end;

  end;

  if (CBOperation.ItemIndex = 25) and (CBMailCodeList.ItemIndex = -1) then
  begin
    Showmessage(_('Group code for mail must be selected'));
    Result := false;
    exit
  end;

end;

// -------------------------------------------------------------------------- //

constructor TAutoRunDefinition.CreateNewSet(AOwner: TComponent; Code : string; Sequence : Integer; mailGroupList : TStringList);
begin
  inherited Create(AOwner);
  caption := 'Code : ' + Code;
  m_Update := false;
  m_Sequence := Sequence;
  m_mailGroupList := mailGroupList
end;

// -------------------------------------------------------------------------- //

constructor TAutoRunDefinition.UpdateSet(AOwner: TComponent; Code : string; UserDefRecord : PTUserDefRecord; mailGroupList : TStringList);
begin
  inherited Create(AOwner);
  caption := 'Code : ' + Code;
  m_UserDefRecord := UserDefRecord;
  m_Update := true;
  m_mailGroupList := mailGroupList
end;

// -------------------------------------------------------------------------- //

procedure TAutoRunDefinition.FormCreate(Sender: TObject);
var
  I : Integer;
   var Rgn: HRgn;
begin
  IniData;
  if m_Update then
  begin
    SEdtSequence.Value := m_UserDefRecord.Sequence;

    if DBAppGlobals.MCM_App then
    begin
      case m_UserDefRecord.Operation of
        UD_Automatic_Sequencing : CBOperation.ItemIndex := 0;
        UD_split : CBOperation.ItemIndex := 1;
        UD_Unschedule_All : CBOperation.ItemIndex := 2;
        UD_Unschedule_All_LAST_OnGantt : CBOperation.ItemIndex := 3;
        UD_Close : CBOperation.ItemIndex := 4;
        UD_Save : CBOperation.ItemIndex  := 5;
        UD_AutoSchedAllReBuildGenericPlan : CBOperation.ItemIndex  := 6;
        UD_Set_bin_jobs_selection_property_False : CBOperation.ItemIndex := 7;
        UD_Set_bin_jobs_selection_property_true  : CBOperation.ItemIndex := 8;
        UD_Set_bin_jobs_selection_property_False_AndServingCode : CBOperation.ItemIndex := 9;
        UD_Set_bin_jobs_selection_property_true_AndServingCode : CBOperation.ItemIndex := 10;
        UD_Set_bin_jobs_selection_Copy_Value_From_Next_LinkedStep : CBOperation.ItemIndex := 11;
        UD_CopySelectionPropertyFromCurrentStepToPrevAndNextStep : CBOperation.ItemIndex := 12;
        UD_CopySelectionPropertyFromCurrentStepToPrevStep : CBOperation.ItemIndex := 13;
        UD_CopySelectionPropertyFromCurrentStepToNextStep : CBOperation.ItemIndex := 14;
        UD_CopySelectionPropertyFromCurrentStepToPrevSteps : CBOperation.ItemIndex := 15;
        UD_CopySelectionpropertyFromCurrentStepToNextSteps : CBOperation.ItemIndex := 16;

        UD_SETAlterPlanedWcByPlant               : CBOperation.ItemIndex := 17;
        UD_ReturnToOriginalWorkCerter            : CBOperation.ItemIndex := 18;
        UD_SetjobslimitDates                     : CBOperation.ItemIndex := 19;
        UD_RemoveJobsCalculatedLimitDates        : CBOperation.ItemIndex := 20;
        UD_BalanceImbalancedSteps                : CBOperation.ItemIndex := 21;
        UD_JoinAllNotScheduledSubSteps           : CBOperation.ItemIndex := 22;
        UD_putInAllAutoSeqCfgTheCurrDateTime     : CBOperation.ItemIndex := 23;
        UD_SetSavedScheduleDate                  : CBOperation.ItemIndex := 24;
        UD_CreatePeriodResourceAndSendMail       : CBOperation.ItemIndex := 25;

        // only mcm
        UD_MCM_OverrParams_InfiniteCapacityAllowed : CBOperation.ItemIndex := 26;
        UD_MCM_RepositionJobsToRealMachines : CBOperation.ItemIndex := 27;
        UD_PushAllJobsToNow : CBOperation.ItemIndex := 28;

        UD_SET_To_Initial : CBOperation.ItemIndex := 29;
        UD_SET_To_FINAL   : CBOperation.ItemIndex := 30;
     //   UD_SET_Conf_Lvl_1 : CBOperation.ItemIndex := 31;
     //   UD_SET_Conf_Lvl_2 : CBOperation.ItemIndex := 32;
     //   UD_SET_Conf_Lvl_3 : CBOperation.ItemIndex := 33;
     //   UD_SET_Conf_Lvl_4 : CBOperation.ItemIndex := 34;
     //   UD_SET_Conf_Lvl_5 : CBOperation.ItemIndex := 35;
     //   UD_Start_Loop     : CBOperation.ItemIndex := 36;
     //   UD_Go_To_Loop_Start_When_Bin_Has_jobs : CBOperation.ItemIndex := 37;
        UD_Start_Loop     : CBOperation.ItemIndex := 31;
        UD_Go_To_Loop_Start_When_Bin_Has_jobs : CBOperation.ItemIndex := 32;


      end;

    end
    else
    begin

      case m_UserDefRecord.Operation of
        UD_Automatic_Sequencing : CBOperation.ItemIndex := 0;
        UD_split : CBOperation.ItemIndex := 1;
        UD_Unschedule_All : CBOperation.ItemIndex := 2;
        UD_Unschedule_All_LAST_OnGantt : CBOperation.ItemIndex := 3;
        UD_Close : CBOperation.ItemIndex := 4;
        UD_Save : CBOperation.ItemIndex  := 5;
        UD_AutoSchedAllReBuildGenericPlan : CBOperation.ItemIndex  := 6;
        UD_Set_bin_jobs_selection_property_False : CBOperation.ItemIndex := 7;
        UD_Set_bin_jobs_selection_property_true  : CBOperation.ItemIndex := 8;
        UD_Set_bin_jobs_selection_property_False_AndServingCode : CBOperation.ItemIndex := 9;
        UD_Set_bin_jobs_selection_property_true_AndServingCode : CBOperation.ItemIndex := 10;
        UD_Set_bin_jobs_selection_Copy_Value_From_Next_LinkedStep : CBOperation.ItemIndex := 11;
        UD_CopySelectionPropertyFromCurrentStepToPrevAndNextStep : CBOperation.ItemIndex := 12;

        UD_CopySelectionPropertyFromCurrentStepToPrevStep : CBOperation.ItemIndex := 13;
        UD_CopySelectionPropertyFromCurrentStepToNextStep : CBOperation.ItemIndex := 14;
        UD_CopySelectionPropertyFromCurrentStepToPrevSteps : CBOperation.ItemIndex := 15;
        UD_CopySelectionpropertyFromCurrentStepToNextSteps : CBOperation.ItemIndex := 16;

        UD_SETAlterPlanedWcByPlant               : CBOperation.ItemIndex := 17;
        UD_ReturnToOriginalWorkCerter            : CBOperation.ItemIndex := 18;
        UD_SetjobslimitDates                     : CBOperation.ItemIndex := 19;
        UD_RemoveJobsCalculatedLimitDates        : CBOperation.ItemIndex := 20;
        UD_BalanceImbalancedSteps                : CBOperation.ItemIndex := 21;
        UD_JoinAllNotScheduledSubSteps           : CBOperation.ItemIndex := 22;
        UD_putInAllAutoSeqCfgTheCurrDateTime     : CBOperation.ItemIndex := 23;
        UD_SetSavedScheduleDate                  : CBOperation.ItemIndex := 24;
        UD_CreatePeriodResourceAndSendMail       : CBOperation.ItemIndex := 25;

        UD_PushAllJobsToNow : CBOperation.ItemIndex := 26;

        UD_SET_To_Initial : CBOperation.ItemIndex := 27;
        UD_SET_To_FINAL   : CBOperation.ItemIndex := 28;
      //  UD_SET_Conf_Lvl_1 : CBOperation.ItemIndex := 29;
      //  UD_SET_Conf_Lvl_2 : CBOperation.ItemIndex := 30;
      //  UD_SET_Conf_Lvl_3 : CBOperation.ItemIndex := 31;
      //  UD_SET_Conf_Lvl_4 : CBOperation.ItemIndex := 32;
      //  UD_SET_Conf_Lvl_5 : CBOperation.ItemIndex := 33;
        UD_Start_Loop     : CBOperation.ItemIndex := 29;
        UD_Go_To_Loop_Start_When_Bin_Has_jobs : CBOperation.ItemIndex := 30;


      end;

    end;

    for I := 0 to CBActiveGantt.Items.Count - 1 do
    begin
      if CBActiveGantt.Items.Strings[I] = m_UserDefRecord.ActiveGanttTab then
      begin
        CBActiveGantt.ItemIndex := I;
        break
      end;
    end;

    for I := 0 to CBActiveBin.Items.Count - 1 do
    begin
      if CBActiveBin.Items.Strings[I] = m_UserDefRecord.ActiveBinTab then
      begin
        CBActiveBin.ItemIndex := I;
        break
      end;
    end;

    if (m_UserDefRecord.Operation = UD_Automatic_Sequencing) or (m_UserDefRecord.Operation = UD_AutoSchedAllReBuildGenericPlan)
       or (m_UserDefRecord.Operation = UD_MCM_OverrParams_InfiniteCapacityAllowed) then
      for I := 0 to CBAutoSeqCfgName.Items.Count - 1 do
      begin
        if CBAutoSeqCfgName.Items.Strings[I] = m_UserDefRecord.AutoSeqCfgName then
        begin
          CBAutoSeqCfgName.ItemIndex := I;
          break
        end;
      end;

    if (m_UserDefRecord.Operation = UD_CreatePeriodResourceAndSendMail) then // or to add new report
      for I := 0 to CBMailCodeList.Items.Count - 1 do
      begin
        if CBMailCodeList.Items.Strings[I] = m_UserDefRecord.MailGroupCode then
        begin
          CBMailCodeList.ItemIndex := I;
          break
        end;
      end;

     CBOperationChange(self);
  end
  else
    SEdtSequence.Value := m_Sequence + 1;

    //Mihailo 1.8.2019.
//    ReShape(btnOk);
//    ReShape(btnAbort);
    ReShape(Self);
end;

// -------------------------------------------------------------------------- //

procedure TAutoRunDefinition.IniData;
var
  ListTabsName : TStringList;
  I : Integer;
  AutoSchedCfg : PTAutoSchedCfg;
begin
  ListTabsName := TStringList.Create;
  CBOperation.Items.Add(_('Automatic Sequencing'));
  CBOperation.Items.Add(_('Split'));
  CBOperation.Items.Add(_('Unschedule all'));
  CBOperation.Items.Add(_('Unschedule all last on gantt'));
  CBOperation.Items.Add(_('Close program'));
  CBOperation.Items.Add(_('Save'));
  CBOperation.Items.Add(_('Automatic Sequencing Rebuild Generic Plan'));
  CBOperation.Items.Add(_('Set bin jobs to property/false'));
  CBOperation.Items.Add(_('Set bin jobs to property/true'));
  CBOperation.Items.Add(_('Set bin jobs to property/false (also to related serving code jobs)'));
  CBOperation.Items.Add(_('Set bin jobs to property/true (also to related serving code jobs)'));
  CBOperation.Items.Add(_('Set bin jobs to property value from next linked step'));
  CBOperation.Items.Add(_('Copy selection property from current step to prev and next step'));
  CBOperation.Items.Add(_('Copy selection property from current step to prev step'));
  CBOperation.Items.Add(_('Copy selection property from current step to next step'));
  CBOperation.Items.Add(_('Copy selection property from current step to prev steps'));
  CBOperation.Items.Add(_('Copy selection property from current step to next steps'));
  CBOperation.Items.Add(_('Alter planned work center by plant'));
  CBOperation.Items.Add(_('Return to original work center'));
  CBOperation.Items.Add(_('Set jobs limit dates'));
  CBOperation.Items.Add(_('Remove Jobs Calculated Limit Dates'));
  CBOperation.Items.Add(_('Balance Imbalanced steps in bin'));
  CBOperation.Items.Add(_('Join all not scheduled sub steps in bin'));
  CBOperation.Items.Add(_('Put the current date time in all Auto.Seq.Cfgs. for this stations'));
  CBOperation.Items.Add(_('Update saved date with scheduled or overlap date'));
  CBOperation.Items.Add(_('Create Period dynamic schedule report and send mail'));

  if DBAppGlobals.MCM_App then
  begin
    CBOperation.Items.Add(_('Automatic Sequencing - Infinite capacity allowed'));
    CBOperation.Items.Add(_('Re-position jobs to a real machines'));
  end;
  CBOperation.Items.Add(_('Push all jobs to current date and time'));

  for i := 1 to DBAppGlobals.ConfLevels do
    if i = 1 then
    begin
      CBOperation.Items.Add(_('set jobs to initial'));
      CBOperation.Items.Add(_('set jobs to final'));
    end else
    begin
      CBOperation.Items.Add(_('set confirmation level to ') + ' ' + IntToStr(i - 1));
    end;

  CBOperation.Items.Add(_('Start loop'));
  CBOperation.Items.Add(_('Go to loop start when bin has jobs'));

  if assigned(FMQMplan) then
     GetGanttTabsNameList(ListTabsName);
  for I := 0 to ListTabsName.Count - 1 do
    CBActiveGantt.Items.Add(ListTabsName.strings[I]);
  ListTabsName.Clear;
  if assigned(FBin) then
     FBin.GetBinTabsNameList(ListTabsName);
  for I := 0 to ListTabsName.Count - 1 do
    CBActiveBin.Items.Add(ListTabsName.strings[I]);

  for i := 0 to AutoSchedCfgList.Count-1 do
  begin
    AutoSchedCfg := AutoSchedCfgList[i];
    CBAutoSeqCfgName.Items.Add(AutoSchedCfg.m_CfgName);
  end;

  if Assigned(m_mailGroupList) then
    for i := 0 to m_mailGroupList.Count-1 do
      CBMailCodeList.Items.Add(m_mailGroupList.Strings[i]);

  ListTabsName.Free;
end;

// -------------------------------------------------------------------------- //

end.
