unit FmAutoRunSet;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, Grids, StdCtrls, Buttons, ExtCtrls, UReShape;

type

  TFRowDetailsSet = class(TForm)
    SGRowDetailsSet: TStringGrid;
    PopupMenu1: TPopupMenu;
    MiUpdate: TMenuItem;
    MiInsert: TMenuItem;
    MIDelete: TMenuItem;
    PanBtn: TPanel;
    btnOK: TcxButton;
    procedure MiInsertClick(Sender: TObject);
    procedure MIDeleteClick(Sender: TObject);
    function GetLastSequence : Integer;
    procedure SGRowDetailsSetSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure MiUpdateClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    m_RowSelected : integer;
    m_SetCode : string;
    m_ListAutoRunCurrentSet : TList;
    m_mailGroupList : TStringList;
    procedure RefreshDataGrid;
    function CheckMailGroupCode(MailGroupCode : string) : boolean;
    { Private declarations }
  public

    constructor CreateRowDetailAutoRunSet(NewSetName : string; mailGroupList : TStringList; AOwner: TComponent);
    { Public declarations }
  end;

  procedure DeleteAutoRunCodeFromList(Code : string);
  procedure LoadAutoRunSetFromDB;
  procedure RunAutomaticByCode(Code : string);
  procedure GetAutoRunCodeList(Lst : TStrings);
  function  IsAutoRunMode : boolean;
  function  IsSplitRunMode : boolean;
  function  GetListCountForAutoRunSet : Integer;
  procedure SetInallWorkStationsCurrentDateTime;
  procedure SendReportByMail(MailGroupCode : string);

implementation

{$R *.dfm}

uses FmAutoRunDefinition, gnugettext, UMTblDesc, DMsrvPc, UMglobal, FMMainPlan,
     UMAutoSchedCfg, FMBIN, FMAutoSchedCfg, UMReports, umcommon, Data.DB;

var
  m_ListAutoRunSet : TList;
  m_AutomaticRunMode : boolean;
  m_SplitRunMode : boolean;
  RD : TFRowDetailsSet;
{ TFRowDetailsSet }

// -------------------------------------------------------------------------- //

procedure GetAutoRunCodeList(Lst : TStrings);
var
  I : Integer;
begin
  Lst.Clear;
  for I := 0 to m_ListAutoRunSet.Count - 1 do
  begin
    if Lst.IndexOf(PTUserDefRecord(m_ListAutoRunSet[I]).SetCode) = -1 then
       Lst.Add(PTUserDefRecord(m_ListAutoRunSet[I]).SetCode)
  end;
end;

// -------------------------------------------------------------------------- //

function IsAutoRunMode : boolean;
begin
  Result := m_AutomaticRunMode
end;

// -------------------------------------------------------------------------- //

function IsSplitRunMode : boolean;
begin
  Result := m_SplitRunMode;
end;

// -------------------------------------------------------------------------- //

function GetListCountForAutoRunSet : Integer;
begin
  Result := m_ListAutoRunSet.Count
end;

// -------------------------------------------------------------------------- //

procedure SetInallWorkStationsCurrentDateTime;
var
  NowTemp : TDateTime;
  TmpCfg: PTAutoSchedCfg;
  I : Integer;
begin
  NowTemp := now;
  for i := 0 to AutoSchedCfgList.Count - 1 do
  begin
    TmpCfg := AutoSchedCfgList[i];
    TmpCfg.m_SpecificDateTime := NowTemp;
  end;
  DBAppGlobals.Change_AutoRunDefinition := true;
end;

// -------------------------------------------------------------------------- //

procedure LoadAutoRunSetFromDB;
var
  tbInfo: ^TTblInfo;
  qry:    TMqmQuery;
  SqlSelect : string;
  UserDefRecord : PTUserDefRecord;
begin
  tbInfo := @tblInfo[tbl_cfg_AutoRunDefinition];
  qry := CreateQuery(Cfg_DB);
  SqlSelect := ' select * from ' + tbInfo.GetTableName;
  SqlSelect := SqlSelect + ' where ';
  SqlSelect := SqlSelect + CreateFld(tbInfo.pfx, fli_wkstCode) + '=' + QuotedStr(IniAppGlobals.WkstCode);
  SqlSelect := SqlSelect + AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier));
  SqlSelect := SqlSelect + ' order by ' + CreateFld(tbInfo.pfx, fli_AutomaticRunCode) + ',' +
               CreateFld(tbInfo.pfx, fli_LineNumber);
  qry.SQL.Text := SqlSelect;
  qry.open;
  while not Qry.Eof do
  begin
    new(UserDefRecord);
    UserDefRecord.SetCode := qry.FieldByName(CreateFld(tbInfo.pfx, fli_AutomaticRunCode)).AsString;
    UserDefRecord.SequenceInDB := qry.FieldByName(CreateFld(tbInfo.pfx, fli_LineNumber)).AsInteger;
    UserDefRecord.Sequence := qry.FieldByName(CreateFld(tbInfo.pfx, fli_Sequence)).AsInteger;
    if qry.FieldByName(CreateFld(tbInfo.pfx, fli_OperationCode)).AsString = 'A' then
      UserDefRecord.Operation := UD_Automatic_Sequencing
    else if qry.FieldByName(CreateFld(tbInfo.pfx, fli_OperationCode)).AsString = 'P' then
      UserDefRecord.Operation := UD_split
    else if qry.FieldByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString = 'U' then
      UserDefRecord.Operation := UD_Unschedule_All
    else if qry.FieldByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString = 'M' then
      UserDefRecord.Operation := UD_Unschedule_All_LAST_OnGantt
    else if qry.FieldByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString = 'C' then
      UserDefRecord.Operation := UD_Close
    else if qry.FieldByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString = 'S' then
      UserDefRecord.Operation := UD_Save
    else if qry.FieldByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString = 'B' then
      UserDefRecord.Operation := UD_AutoSchedAllReBuildGenericPlan
    else if qry.FieldByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString = 'F' then
      UserDefRecord.Operation := UD_SET_To_FINAL
    else if qry.FieldByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString = 'I' then
      UserDefRecord.Operation := UD_SET_To_Initial
    else if qry.FieldByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString = '1' then
      UserDefRecord.Operation := UD_SET_Conf_Lvl_1
    else if qry.FieldByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString = '2' then
      UserDefRecord.Operation := UD_SET_Conf_Lvl_2
    else if qry.FieldByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString = '3' then
      UserDefRecord.Operation := UD_SET_Conf_Lvl_3
    else if qry.FieldByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString = '4' then
      UserDefRecord.Operation := UD_SET_Conf_Lvl_4
    else if qry.FieldByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString = '5' then
      UserDefRecord.Operation := UD_SET_Conf_Lvl_5
    else if qry.FieldByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString = 'N' then
      UserDefRecord.Operation := UD_Set_bin_jobs_selection_property_False
    else if qry.FieldByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString = 'Y' then
      UserDefRecord.Operation := UD_Set_bin_jobs_selection_property_true
    else if qry.FieldByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString = 'G' then
      UserDefRecord.Operation := UD_Set_bin_jobs_selection_property_False_AndServingCode
    else if qry.FieldByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString = 'H' then
      UserDefRecord.Operation := UD_Set_bin_jobs_selection_property_true_AndServingCode
    else if qry.FieldByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString = 'K' then
      UserDefRecord.Operation := UD_Set_bin_jobs_selection_Copy_Value_From_Next_LinkedStep
    else if qry.FieldByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString = 'Q' then
      UserDefRecord.Operation := UD_CopySelectionPropertyFromCurrentStepToPrevAndNextStep

    else if qry.FieldByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString = 'Q1' then
      UserDefRecord.Operation := UD_CopySelectionPropertyFromCurrentStepToPrevStep
    else if qry.FieldByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString = 'Q2' then
      UserDefRecord.Operation := UD_CopySelectionPropertyFromCurrentStepToNextStep
    else if qry.FieldByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString = 'Q3' then
      UserDefRecord.Operation := UD_CopySelectionPropertyFromCurrentStepToPrevSteps
    else if qry.FieldByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString = 'Q4' then
      UserDefRecord.Operation := UD_CopySelectionpropertyFromCurrentStepToNextSteps
    else if qry.FieldByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString = 'W' then
      UserDefRecord.Operation := UD_SETAlterPlanedWcByPlant
    else if qry.FieldByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString = 'R' then
      UserDefRecord.Operation := UD_ReturnToOriginalWorkCerter
    else if qry.FieldByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString = 'D' then
      UserDefRecord.Operation := UD_SetjobslimitDates
    else if qry.FieldByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString = 'L' then
      UserDefRecord.Operation := UD_RemoveJobsCalculatedLimitDates
    else if qry.FieldByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString = 'E' then
      UserDefRecord.Operation := UD_BalanceImbalancedSteps
    else if qry.FieldByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString = 'J' then
      UserDefRecord.Operation := UD_JoinAllNotScheduledSubSteps
    else if qry.FieldByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString = 'O' then
      UserDefRecord.Operation := UD_putInAllAutoSeqCfgTheCurrDateTime
    else if qry.FieldByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString = 'T' then
      UserDefRecord.Operation := UD_SetSavedScheduleDate
    else if qry.FieldByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString = '7' then
      UserDefRecord.Operation := UD_CreatePeriodResourceAndSendMail
    else if qry.FieldByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString = 'X' then
      UserDefRecord.Operation := UD_MCM_OverrParams_InfiniteCapacityAllowed
    else if qry.FieldByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString = 'Z' then
      UserDefRecord.Operation := UD_MCM_RepositionJobsToRealMachines
    else if qry.FieldByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString = 'PN' then
      UserDefRecord.Operation := UD_PushAllJobsToNow
    else if qry.FieldByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString = 'SL' then
      UserDefRecord.Operation := UD_Start_Loop
    else if qry.FieldByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString = 'GL' then
      UserDefRecord.Operation := UD_Go_To_Loop_Start_When_Bin_Has_jobs;


    UserDefRecord.ActiveBinTab := qry.FieldByName(CreateFld(tbInfo.pfx, fli_Bin)).AsString;
    UserDefRecord.ActiveGanttTab := qry.FieldByName(CreateFld(tbInfo.pfx, fli_Gantt)).AsString;
    UserDefRecord.AutoSeqCfgName := qry.FieldByName(CreateFld(tbInfo.pfx, fli_OperationDetail)).AsString;
    UserDefRecord.MailGroupCode  := qry.FieldByName(CreateFld(tbInfo.pfx, fli_MailGroupName)).AsString;
    m_ListAutoRunSet.Add(UserDefRecord);
    FMQMPlan.m_ListAutoRunSetInfo.Add(UserDefRecord);
    Qry.Next;
    Application.ProcessMessages;
  end;

  qry.free;
end;

// -------------------------------------------------------------------------- //

function SortBySequence(Item1, Item2: Pointer) : integer;
var
  UserDefRecord1 : PTUserDefRecord;
  UserDefRecord2 : PTUserDefRecord;
begin
  UserDefRecord1 := PTUserDefRecord(Item1);
  UserDefRecord2 := PTUserDefRecord(Item2);
  if UserDefRecord1.Sequence < UserDefRecord2.Sequence then
    Result := -1
  else if (UserDefRecord1.Sequence = UserDefRecord2.Sequence) then
    Result := 0
  else
    Result := 1;
end;

// -------------------------------------------------------------------------- //

procedure RunAutomaticByCode(Code : string);
var
  AutoRunCurrentSetList : TList;
  I, NbrOfTry, Sequence : Integer;
  MQMPlan : TFMQMPlan;
  PAutoSchedCfg : PTAutoSchedCfg;
  AutoRunFixedDateTime : TDateTime;
begin
  AutoRunCurrentSetList := TList.Create;
  AutoRunFixedDateTime := now;
  for I := 0 to m_ListAutoRunSet.Count - 1 do
  begin
    if PTUserDefRecord(m_ListAutoRunSet[I]).SetCode = Code then
       AutoRunCurrentSetList.Add(m_ListAutoRunSet[I]);
  end;
  AutoRunCurrentSetList.Sort(SortBySequence);

  if AutoRunCurrentSetList.Count > 0 then
    m_AutomaticRunMode := true;

//  WriteLogLineToDB('P', 'AutoRun/'+Code , 0, 0, 0,'STR', '' ,'', 0, 0, 0, '', '');
//  for I := 0 to AutoRunCurrentSetList.Count - 1 do
  I := -1;
  while True do
  begin
    I := I + 1;
    if I > (AutoRunCurrentSetList.Count - 1) then break;
    case PTUserDefRecord(AutoRunCurrentSetList[I]).Operation of

      UD_Start_Loop                               : begin
                                                      NbrOfTry := 0;
                                                      Sequence := I;
                                                    end;

      UD_Go_To_Loop_Start_When_Bin_Has_jobs       : begin
                                                      Application.ProcessMessages;
                                                    //  WriteLogLineToDB('P', 'JoinAllNotScheduledSubSteps' , 0, 0, 0,'JNS', '' ,'', 0, 0, 0, '', '');
                                                      MQMPlan := GetPlanView;
                                                      MQMPlan.SetActiveTabByName(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveGanttTab);
                                                      if Assigned(FBin) then
                                                        FBin.SetActiveTab(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveBinTab);
                                                      if Assigned(FBin) then
                                                        FBin.ChangeTabBinforChangeTabPlan;
                                                      Application.ProcessMessages;
                                                      if Assigned(FBin) and (FBin.GetActiveView.m_BinPanel.m_objList.GetLinkCount > 0) then
                                                      begin
                                                        if (NbrOfTry <= 30) then
                                                          I := Sequence;
                                                      end;
                                                      Application.ProcessMessages;

                                                    end;


      UD_Automatic_Sequencing : begin
                                  Application.ProcessMessages;
                                //  WriteLogLineToDB('P', 'Automatic Sequencing' , 0, 0, 0,'AUS', '' ,'', 0, 0, 0, '', '');
                                  MQMPlan := GetPlanView;
                                  MQMPlan.SetActiveTabByName(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveGanttTab);
                                  if Assigned(FBin) then
                                    FBin.SetActiveTab(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveBinTab);
                                  if Assigned(FBin) then
                                    FBin.ChangeTabBinforChangeTabPlan;
                                  Application.ProcessMessages;
                               //   AutoSchedCfg.m_CfgName := PTUserDefRecord(AutoRunCurrentSetList[I]).AutoSeqCfgName;
                                  PAutoSchedCfg := GetAutoSchedCfg(PTUserDefRecord(AutoRunCurrentSetList[I]).AutoSeqCfgName);
                                  PAutoSchedCfg.m_AutoRunFixedDateTime := AutoRunFixedDateTime;
                                  SetAsActiveCfg(PAutoSchedCfg);
                                  FBin.MIStartAutoSchedCurrentCfgClick(Application);
                                  Application.ProcessMessages;
                                  if not CheckIfActiveGanttTabIsMcm then
                                  begin
                                    if FMQMPlan.GetActiveTab.p_shapeMan.m_scroll.Visible then
                                      FMQMPlan.GetActiveTab.p_shapeMan.m_scroll.SetFocus;
                                  end;
                                  Application.ProcessMessages;
                                end;
      UD_split : begin
                   Application.ProcessMessages;
               //    WriteLogLineToDB('P', 'Split' , 0, 0, 0,'SLT', '' ,'', 0, 0, 0, '', '');
                   MQMPlan := GetPlanView;
                   MQMPlan.SetActiveTabByName(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveGanttTab);
                   if Assigned(FBin) then
                      FBin.SetActiveTab(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveBinTab);
                   m_SplitRunMode := true;
                   if Assigned(FBin) then
                     FBin.ChangeTabBinforChangeTabPlan;
                   Application.ProcessMessages;
                   FBin.MIStartAutoSchedCurrentCfgClick(Application);
                   m_SplitRunMode := false;
                   Application.ProcessMessages;
                 end;

      UD_Unschedule_All : begin
                            Application.ProcessMessages;
                         //   WriteLogLineToDB('P', 'Unschedule_All' , 0, 0, 0,'USD', '' ,'', 0, 0, 0, '', '');
                            MQMPlan := GetPlanView;
                            MQMPlan.SetActiveTabByName(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveGanttTab);
                            if Assigned(FBin) then
                              FBin.SetActiveTab(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveBinTab);
                            if Assigned(FBin) then
                              FBin.ChangeTabBinforChangeTabPlan;
                            Application.ProcessMessages;
                            FBin.MIUnscheduleClick(Application);
                            Application.ProcessMessages;
                          end;

      UD_Unschedule_All_LAST_OnGantt : begin
                            Application.ProcessMessages;
                         //   WriteLogLineToDB('P', 'Unschedule_All_LAST_ON_GANT' , 0, 0, 0,'USL', '' ,'', 0, 0, 0, '', '');
                            MQMPlan := GetPlanView;
                            MQMPlan.SetActiveTabByName(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveGanttTab);
                            if Assigned(FBin) then
                              FBin.SetActiveTab(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveBinTab);
                            if Assigned(FBin) then
                              FBin.ChangeTabBinforChangeTabPlan;
                            Application.ProcessMessages;
                            FBin.MIMoveAllInBinLastOnGanttClick(Application);
                            Application.ProcessMessages;
                          end;

      UD_Close          : begin
                            Application.ProcessMessages;
                      //      WriteLogLineToDB('P', 'Close' , 0, 0, 0,'CLS', '' ,'', 0, 0, 0, '', '');
                            MQMPlan := GetPlanView;
                            if assigned(MQMPlan) then
                              MQMPlan.Close;
                          end;

      UD_Save           : begin
                            Application.ProcessMessages;
                       //     WriteLogLineToDB('P', 'SAVE' , 0, 0, 0,'SVE', '' ,'', 0, 0, 0, '', '');
                            MQMPlan := GetPlanView;
                            if assigned(MQMPlan) then
                               MQMPlan.MISaveClick(Application);
                            Application.ProcessMessages;
                          end;

      UD_AutoSchedAllReBuildGenericPlan : begin
                                            Application.ProcessMessages;
                                       //     WriteLogLineToDB('P', 'AutoSchedAllReBuildGenPlan' , 0, 0, 0,'ARG', '' ,'', 0, 0, 0, '', '');
                                            MQMPlan := GetPlanView;
                                            MQMPlan.SetActiveTabByName(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveGanttTab);
                                            if Assigned(FBin) then
                                              FBin.SetActiveTab(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveBinTab);
                                            if Assigned(FBin) then
                                              FBin.ChangeTabBinforChangeTabPlan;
                                            Application.ProcessMessages;
                                            PAutoSchedCfg := GetAutoSchedCfg(PTUserDefRecord(AutoRunCurrentSetList[I]).AutoSeqCfgName);
                                            SetAsActiveCfg(PAutoSchedCfg);
                                            Application.ProcessMessages;
                                            FBin.MIAutoSchedPlusGenericClick(Application);
                                            Application.ProcessMessages;
                                          end;

      UD_Set_bin_jobs_selection_property_False : begin
                                                   Application.ProcessMessages;
                                        //           WriteLogLineToDB('P', 'SetBinJobsSeltedProp_Fls' , 0, 0, 0,'SBF', '' ,'', 0, 0, 0, '', '');
                                                   MQMPlan := GetPlanView;
                                                   MQMPlan.SetActiveTabByName(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveGanttTab);
                                                   if Assigned(FBin) then
                                                      FBin.SetActiveTab(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveBinTab);
                                                   if Assigned(FBin) then
                                                      FBin.ChangeTabBinforChangeTabPlan;
                                                   Application.ProcessMessages;
                                                   if Assigned(FBin) then
                                                      FBin.MiSettAllJobsAssgnedJobFalseClick(Application);
                                                   Application.ProcessMessages;
                                                 end;

      UD_Set_bin_jobs_selection_property_true :  begin
                                                   Application.ProcessMessages;
                                             //      WriteLogLineToDB('P', 'SetBinJobsSeltedProp_Tru' , 0, 0, 0,'SBT', '' ,'', 0, 0, 0, '', '');
                                                   MQMPlan := GetPlanView;
                                                   MQMPlan.SetActiveTabByName(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveGanttTab);
                                                   if Assigned(FBin) then
                                                      FBin.SetActiveTab(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveBinTab);
                                                   if Assigned(FBin) then
                                                      FBin.ChangeTabBinforChangeTabPlan;
                                                   Application.ProcessMessages;
                                                   if Assigned(FBin) then
                                                      FBin.MiSettAllJobsAssgnedJobTrueClick(Application);
                                                   Application.ProcessMessages;
                                                 end;

      UD_Set_bin_jobs_selection_property_False_AndServingCode : begin
                                                   Application.ProcessMessages;
                                             //      WriteLogLineToDB('P', 'SetBinJobsSeltedPropFlsSrvCod' , 0, 0, 0,'SBS', '' ,'', 0, 0, 0, '', '');
                                                   MQMPlan := GetPlanView;
                                                   MQMPlan.SetActiveTabByName(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveGanttTab);
                                                   if Assigned(FBin) then
                                                      FBin.SetActiveTab(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveBinTab);
                                                   if Assigned(FBin) then
                                                      FBin.ChangeTabBinforChangeTabPlan;
                                                   Application.ProcessMessages;
                                                   if Assigned(FBin) then
                                                      FBin.MiSettAllJobsAssgnedJobFalseAndServingCodeClick(Application);
                                                   Application.ProcessMessages;
                                                 end;

      UD_Set_bin_jobs_selection_property_true_AndServingCode :  begin
                                                   Application.ProcessMessages;
                                               //    WriteLogLineToDB('P', 'SetBinJobsSeltedPropTruSrvCod' , 0, 0, 0,'SBT', '' ,'', 0, 0, 0, '', '');
                                                   MQMPlan := GetPlanView;
                                                   MQMPlan.SetActiveTabByName(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveGanttTab);
                                                   if Assigned(FBin) then
                                                      FBin.SetActiveTab(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveBinTab);
                                                   if Assigned(FBin) then
                                                      FBin.ChangeTabBinforChangeTabPlan;
                                                   Application.ProcessMessages;
                                                   if Assigned(FBin) then
                                                      FBin.MiSettAllJobsAssgnedJobTrueAndServingCodeClick(Application);
                                                   Application.ProcessMessages;
                                                 end;

      UD_Set_bin_jobs_selection_Copy_Value_From_Next_LinkedStep :  begin
                                                   Application.ProcessMessages;
                                            //       WriteLogLineToDB('P', 'SetBinJobsCopyNextLinkedStep' , 0, 0, 0,'SBC', '' ,'', 0, 0, 0, '', '');
                                                   MQMPlan := GetPlanView;
                                                   MQMPlan.SetActiveTabByName(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveGanttTab);
                                                   if Assigned(FBin) then
                                                      FBin.SetActiveTab(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveBinTab);
                                                   if Assigned(FBin) then
                                                      FBin.ChangeTabBinforChangeTabPlan;
                                                   Application.ProcessMessages;
                                                   if Assigned(FBin) then
                                                      FBin.MiSettAllCopyValueFromNextLinkedReqClick(Application);
                                                   Application.ProcessMessages;
                                                 end;

      UD_CopySelectionPropertyFromCurrentStepToPrevAndNextStep :  begin
                                                   Application.ProcessMessages;
                                               //    WriteLogLineToDB('P', 'CopyFromCurrStpToPrvAndNxtStp' , 0, 0, 0,'SBC', '' ,'', 0, 0, 0, '', '');
                                                   MQMPlan := GetPlanView;
                                                   MQMPlan.SetActiveTabByName(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveGanttTab);
                                                   if Assigned(FBin) then
                                                      FBin.SetActiveTab(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveBinTab);
                                                   if Assigned(FBin) then
                                                      FBin.ChangeTabBinforChangeTabPlan;
                                                   Application.ProcessMessages;
                                                   if Assigned(FBin) then
                                                      FBin.MiSettAllCopyValueFromNextLinkedReqClick(Application);
                                                   Application.ProcessMessages;
                                                 end;

      UD_CopySelectionPropertyFromCurrentStepToPrevStep :  begin
                                                   Application.ProcessMessages;
                                                  // WriteLogLineToDB('P', 'CopyFromFromCurrtStpToPrvStp' , 0, 0, 0,'SBC', '' ,'', 0, 0, 0, '', '');
                                                   MQMPlan := GetPlanView;
                                                   MQMPlan.SetActiveTabByName(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveGanttTab);
                                                   if Assigned(FBin) then
                                                      FBin.SetActiveTab(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveBinTab);
                                                   if Assigned(FBin) then
                                                      FBin.ChangeTabBinforChangeTabPlan;
                                                   Application.ProcessMessages;
                                                   if Assigned(FBin) then
                                                      FBin.CopySelectionPropertyFromCurrentStepToPrevStepClick(Application);
                                                   Application.ProcessMessages;
                                                 end;

      UD_CopySelectionPropertyFromCurrentStepToNextStep :  begin
                                                   Application.ProcessMessages;
                                                 //  WriteLogLineToDB('P', 'CopyFromCurrStpToPrvAndNxtStp' , 0, 0, 0,'SBC', '' ,'', 0, 0, 0, '', '');
                                                   MQMPlan := GetPlanView;
                                                   MQMPlan.SetActiveTabByName(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveGanttTab);
                                                   if Assigned(FBin) then
                                                      FBin.SetActiveTab(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveBinTab);
                                                   if Assigned(FBin) then
                                                      FBin.ChangeTabBinforChangeTabPlan;
                                                   Application.ProcessMessages;
                                                   if Assigned(FBin) then
                                                      FBin.CopySelectionPropertyFromCurrentStepToNextStepClick(Application);
                                                   Application.ProcessMessages;
                                                 end;
      UD_CopySelectionPropertyFromCurrentStepToPrevSteps :  begin
                                                   Application.ProcessMessages;
                                                 //  WriteLogLineToDB('P', 'CopyFromCurrStpToPrvAndNxtStp' , 0, 0, 0,'SBC', '' ,'', 0, 0, 0, '', '');
                                                   MQMPlan := GetPlanView;
                                                   MQMPlan.SetActiveTabByName(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveGanttTab);
                                                   if Assigned(FBin) then
                                                      FBin.SetActiveTab(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveBinTab);
                                                   if Assigned(FBin) then
                                                      FBin.ChangeTabBinforChangeTabPlan;
                                                   Application.ProcessMessages;
                                                   if Assigned(FBin) then
                                                      FBin.CopySelectionPropertyFromCurrentStepToPrevStepsClick(Application);
                                                   Application.ProcessMessages;
                                                 end;

      UD_CopySelectionpropertyFromCurrentStepToNextSteps :  begin
                                                   Application.ProcessMessages;
                                                //   WriteLogLineToDB('P', 'CopyFromCurrStpToPrvAndNxtStp' , 0, 0, 0,'SBC', '' ,'', 0, 0, 0, '', '');
                                                   MQMPlan := GetPlanView;
                                                   MQMPlan.SetActiveTabByName(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveGanttTab);
                                                   if Assigned(FBin) then
                                                      FBin.SetActiveTab(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveBinTab);
                                                   if Assigned(FBin) then
                                                      FBin.ChangeTabBinforChangeTabPlan;
                                                   Application.ProcessMessages;
                                                   if Assigned(FBin) then
                                                      FBin.CopySelectionPropertyFromCurrentStepToNextStepsClick(Application);
                                                   Application.ProcessMessages;
                                                 end;

      UD_SETAlterPlanedWcByPlant :               begin
                                                   Application.ProcessMessages;
                                              //     WriteLogLineToDB('P', 'SETAlterPlanedWcByPlant' , 0, 0, 0,'SAW', '' ,'', 0, 0, 0, '', '');
                                                   MQMPlan := GetPlanView;
                                                   MQMPlan.SetActiveTabByName(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveGanttTab);
                                                   if Assigned(FBin) then
                                                      FBin.SetActiveTab(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveBinTab);
                                                   if Assigned(FBin) then
                                                      FBin.ChangeTabBinforChangeTabPlan;
                                                   Application.ProcessMessages;
                                                   if Assigned(FBin) then
                                                      FBin.MiSetWcPlantClick(Application);
                                                   Application.ProcessMessages;
                                                 end;

      UD_ReturnToOriginalWorkCerter :            begin
                                                   Application.ProcessMessages;
                                              //     WriteLogLineToDB('P', 'ReturnToOriginalWorkCerter' , 0, 0, 0,'ROW', '' ,'', 0, 0, 0, '', '');
                                                   MQMPlan := GetPlanView;
                                                   MQMPlan.SetActiveTabByName(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveGanttTab);
                                                   if Assigned(FBin) then
                                                      FBin.SetActiveTab(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveBinTab);
                                                   if Assigned(FBin) then
                                                      FBin.ChangeTabBinforChangeTabPlan;
                                                   Application.ProcessMessages;
                                                   if Assigned(FBin) then
                                                      FBin.MiReturnOriginalPlantWcClick(Application);
                                                   Application.ProcessMessages;
                                                 end;

      UD_SetjobslimitDates :                     begin
                                                   Application.ProcessMessages;
                                              //     WriteLogLineToDB('P', 'SetjobslimitDates' , 0, 0, 0,'SJD', '' ,'', 0, 0, 0, '', '');
                                                   MQMPlan := GetPlanView;
                                                   MQMPlan.SetActiveTabByName(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveGanttTab);
                                             //      if Assigned(FBin) then
                                             //         FBin.SetActiveTab(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveBinTab);
                                             //      if Assigned(FBin) then
                                             //         FBin.ChangeTabBinforChangeTabPlan;
                                                   if Assigned(MQMPlan) then
                                                      MQMPlan.MiSetjobslimitdatesClick(Application);
                                                   Application.ProcessMessages;
                                                 end;

      UD_RemoveJobsCalculatedLimitDates :        begin
                                                   Application.ProcessMessages;
                                            //       WriteLogLineToDB('P', 'RmveJobsCalculatedLimitDates' , 0, 0, 0,'RLD', '' ,'', 0, 0, 0, '', '');
                                                   MQMPlan := GetPlanView;
                                                   MQMPlan.SetActiveTabByName(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveGanttTab);
                                                   if Assigned(FBin) then
                                                      FBin.SetActiveTab(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveBinTab);
                                                   if Assigned(FBin) then
                                                      FBin.ChangeTabBinforChangeTabPlan;
                                                   Application.ProcessMessages;
                                                   if Assigned(FBin) then
                                                      FBin.MiRemoveJobsCalculatedLimitDatesClick(Application);
                                                   Application.ProcessMessages;
                                                 end;

      UD_BalanceImbalancedSteps :                begin
                                                   Application.ProcessMessages;
                                              //     WriteLogLineToDB('P', 'BalanceImbalancedSteps' , 0, 0, 0,'BIS', '' ,'', 0, 0, 0, '', '');
                                                   MQMPlan := GetPlanView;
                                                   MQMPlan.SetActiveTabByName(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveGanttTab);
                                                   if Assigned(FBin) then
                                                      FBin.SetActiveTab(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveBinTab);
                                                   if Assigned(FBin) then
                                                      FBin.ChangeTabBinforChangeTabPlan;
                                                   Application.ProcessMessages;
                                                   if Assigned(FBin) then
                                                      FBin.MiBalanceImbalanceInBinClick(Application);
                                                   Application.ProcessMessages;
                                                 end;

      UD_JoinAllNotScheduledSubSteps :           begin
                                                   Application.ProcessMessages;
                                            //       WriteLogLineToDB('P', 'JoinAllNotScheduledSubSteps' , 0, 0, 0,'JNS', '' ,'', 0, 0, 0, '', '');
                                                   MQMPlan := GetPlanView;
                                                   MQMPlan.SetActiveTabByName(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveGanttTab);
                                                   if Assigned(FBin) then
                                                      FBin.SetActiveTab(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveBinTab);
                                                   if Assigned(FBin) then
                                                      FBin.ChangeTabBinforChangeTabPlan;
                                                   Application.ProcessMessages;
                                                   if Assigned(FBin) then
                                                      FBin.MIJoinAllClick(Application);
                                                   Application.ProcessMessages;
                                                 end;

      UD_putInAllAutoSeqCfgTheCurrDateTime :   begin
                                                   Application.ProcessMessages;
                                          //         WriteLogLineToDB('P', 'putInAllWsASCfgTheCurrDateTime' , 0, 0, 0,'PCD', '' ,'', 0, 0, 0, '', '');
                                                   MQMPlan := GetPlanView;
                                                   SetInallWorkStationsCurrentDateTime;
                                                   Application.ProcessMessages;
                                                 end;

      UD_SetSavedScheduleDate :                begin
                                                   Application.ProcessMessages;
                                           //        WriteLogLineToDB('P', 'SetSavedScheduleDate' , 0, 0, 0,'SCD', '' ,'', 0, 0, 0, '', '');
                                                   MQMPlan := GetPlanView;
                                                   MQMPlan.SetActiveTabByName(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveGanttTab);
                                                   MQMPlan.MiSetSavedScheduleDateClick(Application);
                                                   Application.ProcessMessages;
                                                end;


      UD_CreatePeriodResourceAndSendMail :      begin
                                                  Application.ProcessMessages;
                                          //        WriteLogLineToDB('P', 'CreatePeriodResourceAndSendMail' , 0, 0, 0,'SCD', '' ,'', 0, 0, 0, '', '');
                                                  MQMPlan := GetPlanView;
                                                  MQMPlan.SetActiveTabByName(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveGanttTab);
                                                  if Assigned(FBin) then
                                                     FBin.SetActiveTab(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveBinTab);
                                                  if Assigned(FBin) then
                                                     FBin.ChangeTabBinforChangeTabPlan;
                                                  Application.ProcessMessages;
                                                  MQMPlan.MIDailyMachineReportClick(Application);
                                                  Application.ProcessMessages;
                                                  if UMReports.ReportCreated then
                                                    SendReportByMail(PTUserDefRecord(AutoRunCurrentSetList[I]).MailGroupCode);
                                                  Application.ProcessMessages;
                                                end;

      UD_SET_To_Initial   : begin
                            Application.ProcessMessages;
                       //     WriteLogLineToDB('P', 'SET_To_Initial' , 0, 0, 0,'CFI', '' ,'', 0, 0, 0, '', '');
                            MQMPlan := GetPlanView;
                            MQMPlan.SetActiveTabByName(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveGanttTab);
                            if Assigned(FBin) then
                              FBin.SetActiveTab(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveBinTab);
                            if Assigned(FBin) then
                              FBin.ChangeTabBinforChangeTabPlan;
                            Application.ProcessMessages;
                            FBin.SET_Conf_Lvl_AutoRun('Initial');
                            Application.ProcessMessages;
                            //FBin.MISetLevelToInitialAllClick(Application);
                          end;

      UD_SET_To_FINAL   : begin
                            Application.ProcessMessages;
                       //     WriteLogLineToDB('P', 'SET_To_FINAL' , 0, 0, 0,'CFI', '' ,'', 0, 0, 0, '', '');
                            MQMPlan := GetPlanView;
                            MQMPlan.SetActiveTabByName(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveGanttTab);
                            if Assigned(FBin) then
                              FBin.SetActiveTab(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveBinTab);
                            if Assigned(FBin) then
                              FBin.ChangeTabBinforChangeTabPlan;
                            Application.ProcessMessages;
                            FBin.SET_Conf_Lvl_AutoRun('Final');
                            Application.ProcessMessages;
                          //  FBin.MISetLevelToFinalAllClick(Application);
                          end;

      UD_SET_Conf_Lvl_1   : begin
                            Application.ProcessMessages;
                     //       WriteLogLineToDB('P', 'SET_Conf_Lvl_1' , 0, 0, 0,'CF1', '' ,'', 0, 0, 0, '', '');
                            MQMPlan := GetPlanView;
                            MQMPlan.SetActiveTabByName(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveGanttTab);
                            if Assigned(FBin) then
                              FBin.SetActiveTab(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveBinTab);
                            if Assigned(FBin) then
                              FBin.ChangeTabBinforChangeTabPlan;
                            Application.ProcessMessages;
                            FBin.SET_Conf_Lvl_AutoRun('1');
                            Application.ProcessMessages;
                           // FBin.MISetLevelTo1AllClick(Application);
                          end;

      UD_SET_Conf_Lvl_2   : begin
                            Application.ProcessMessages;
                       //     WriteLogLineToDB('P', 'SET_Conf_Lvl_2' , 0, 0, 0,'CF2', '' ,'', 0, 0, 0, '', '');
                            MQMPlan := GetPlanView;
                            MQMPlan.SetActiveTabByName(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveGanttTab);
                            if Assigned(FBin) then
                              FBin.SetActiveTab(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveBinTab);
                            if Assigned(FBin) then
                              FBin.ChangeTabBinforChangeTabPlan;
                            Application.ProcessMessages;
                            FBin.SET_Conf_Lvl_AutoRun('2');
                            Application.ProcessMessages;
                          //  FBin.MISetLevelTo2AllClick(Application);
                          end;

      UD_SET_Conf_Lvl_3   : begin
                            Application.ProcessMessages;
                      //      WriteLogLineToDB('P', 'SET_Conf_Lvl_3' , 0, 0, 0,'CF3', '' ,'', 0, 0, 0, '', '');
                            MQMPlan := GetPlanView;
                            MQMPlan.SetActiveTabByName(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveGanttTab);
                            if Assigned(FBin) then
                              FBin.SetActiveTab(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveBinTab);
                            if Assigned(FBin) then
                              FBin.ChangeTabBinforChangeTabPlan;
                            Application.ProcessMessages;
                            FBin.SET_Conf_Lvl_AutoRun('3');
                            Application.ProcessMessages;
                           // FBin.MISetLevelTo3AllClick(Application);
                          end;

      UD_SET_Conf_Lvl_4   : begin
                            Application.ProcessMessages;
                       //     WriteLogLineToDB('P', 'SET_Conf_Lvl_4' , 0, 0, 0,'CF4', '' ,'', 0, 0, 0, '', '');
                            MQMPlan := GetPlanView;
                            MQMPlan.SetActiveTabByName(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveGanttTab);
                            if Assigned(FBin) then
                              FBin.SetActiveTab(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveBinTab);
                            if Assigned(FBin) then
                              FBin.ChangeTabBinforChangeTabPlan;
                            Application.ProcessMessages;
                            FBin.SET_Conf_Lvl_AutoRun('4');
                            Application.ProcessMessages;
                            //FBin.MISetLevelTo4AllClick(Application);
                          end;

      UD_SET_Conf_Lvl_5   : begin
                            Application.ProcessMessages;
                     //       WriteLogLineToDB('P', 'SET_Conf_Lvl_5' , 0, 0, 0,'CF5', '' ,'', 0, 0, 0, '', '');
                            MQMPlan := GetPlanView;
                            MQMPlan.SetActiveTabByName(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveGanttTab);
                            if Assigned(FBin) then
                              FBin.SetActiveTab(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveBinTab);
                            if Assigned(FBin) then
                              FBin.ChangeTabBinforChangeTabPlan;
                            Application.ProcessMessages;
                            FBin.SET_Conf_Lvl_AutoRun('5');
                            Application.ProcessMessages;
                            //FBin.MISetLevelTo5AllClick(Application);
                          end;


      UD_MCM_OverrParams_InfiniteCapacityAllowed : begin

                                                      Application.ProcessMessages;
                                               //       WriteLogLineToDB('P', 'Automatic Sequencing' , 0, 0, 0,'AUS', '' ,'', 0, 0, 0, '', '');
                                                      MQMPlan := GetPlanView;
                                                      MQMPlan.SetActiveTabByName(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveGanttTab);
                                                      if Assigned(FBin) then
                                                        FBin.SetActiveTab(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveBinTab);
                                                      if Assigned(FBin) then
                                                        FBin.ChangeTabBinforChangeTabPlan;
                                                      Application.ProcessMessages;
                                                   //   AutoSchedCfg.m_CfgName := PTUserDefRecord(AutoRunCurrentSetList[I]).AutoSeqCfgName;
                                                      PAutoSchedCfg := GetAutoSchedCfg(PTUserDefRecord(AutoRunCurrentSetList[I]).AutoSeqCfgName);
                                                      PAutoSchedCfg.m_AutoRunFixedDateTime := AutoRunFixedDateTime;
                                                      SetAsActiveCfg(PAutoSchedCfg);

                                                      PAutoSchedCfg.m_OverridingParams_InfiniteCapacityAllowed := true;

                                                      FBin.MIStartAutoSchedCurrentCfgClick(Application);
                                                      Application.ProcessMessages;
                                                      if not CheckIfActiveGanttTabIsMcm then
                                                      begin
                                                        if FMQMPlan.GetActiveTab.p_shapeMan.m_scroll.Visible then
                                                          FMQMPlan.GetActiveTab.p_shapeMan.m_scroll.SetFocus;
                                                      end;
                                                      AutoSchedCfg.m_OverridingParams_InfiniteCapacityAllowed := false;
                                                      Application.ProcessMessages;


                                                   end;

      UD_MCM_RepositionJobsToRealMachines        : begin
                                                      Application.ProcessMessages;
                                                //      WriteLogLineToDB('P', 'Automatic Sequencing' , 0, 0, 0,'AUS', '' ,'', 0, 0, 0, '', '');
                                                      MQMPlan := GetPlanView;
                                                      MQMPlan.SetActiveTabByName(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveGanttTab);
                                                      if Assigned(FBin) then
                                                        FBin.SetActiveTab(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveBinTab);
                                                      if Assigned(FBin) then
                                                        FBin.ChangeTabBinforChangeTabPlan;
                                                      Application.ProcessMessages;
                                                   //   AutoSchedCfg.m_CfgName := PTUserDefRecord(AutoRunCurrentSetList[I]).AutoSeqCfgName;
                                                      PAutoSchedCfg := GetAutoSchedCfg(PTUserDefRecord(AutoRunCurrentSetList[I]).AutoSeqCfgName);
                                                      PAutoSchedCfg.m_AutoRunFixedDateTime := AutoRunFixedDateTime;
                                                      SetAsActiveCfg(PAutoSchedCfg);
                                                      FBin.MiRepositionJobsToRealMachinesClick(Application);
                                                      Application.ProcessMessages;
                                                      if not CheckIfActiveGanttTabIsMcm then
                                                      begin
                                                        if FMQMPlan.GetActiveTab.p_shapeMan.m_scroll.Visible then
                                                          FMQMPlan.GetActiveTab.p_shapeMan.m_scroll.SetFocus;
                                                      end;
                                                      Application.ProcessMessages;

                                                   end;

      UD_PushAllJobsToNow                         : begin
                                                      Application.ProcessMessages;
                                               //       WriteLogLineToDB('N', 'PuShJobToNow' , 0, 0, 0,'Psh', '' ,'', 0, 0, 0, '', '');
                                                      MQMPlan := GetPlanView;
                                                      //MQMPlan.SetActiveTabByName(PTUserDefRecord(AutoRunCurrentSetList[I]).ActiveGanttTab);
                                                      MQMPlan.MiPushAllJobsClick(Application);
                                                      Application.ProcessMessages;
                                                    end;

    end;

  end;
//  WriteLogLineToDB('P', 'AutoRun/'+Code , 0, 0, 0,'END', '' ,'', 0, 0, 0, '', '');

  m_AutomaticRunMode := false;
  AutoRunCurrentSetList.Free;

end;

// -------------------------------------------------------------------------- //

procedure DeleteAutoRunCodeFromList(Code : string);
var
  I : Integer;
begin
  for I := m_ListAutoRunSet.Count - 1 downto 0 do
  begin
    if PTUserDefRecord(m_ListAutoRunSet[I]).SetCode = Code then
    begin
       m_ListAutoRunSet.Delete(I);
       FMQMPlan.m_ListAutoRunSetInfo.Delete(i);
    end;
  end;
end;

// -------------------------------------------------------------------------- //

constructor TFRowDetailsSet.CreateRowDetailAutoRunSet(NewSetName : string; mailGroupList : TStringList; AOwner: TComponent);
var
  I : Integer;
begin
  inherited Create(AOwner);
  m_SetCode := NewSetName;
  Caption := Caption + ' ' + m_SetCode;
  m_ListAutoRunCurrentSet := TList.Create;
  m_mailGroupList := mailGroupList;


  for I := 0 to m_ListAutoRunSet.Count - 1 do
  begin
    if PTUserDefRecord(m_ListAutoRunSet[I]).SetCode = NewSetName then
    begin
      m_ListAutoRunCurrentSet.Add(m_ListAutoRunSet[I]);

    end;
  end;
  if m_ListAutoRunCurrentSet.Count > 0 then
    m_RowSelected := 1;

  // read from database all records that exist and fill the current list;
  m_ListAutoRunCurrentSet.sort(SortBySequence);
  RefreshDataGrid;
  ReShape(Self);
end;


// -------------------------------------------------------------------------- //

function TFRowDetailsSet.GetLastSequence: Integer;
begin
  if m_ListAutoRunCurrentSet.Count = 0 then
    Result := 0
  else
    Result := PTUserDefRecord(m_ListAutoRunCurrentSet[m_ListAutoRunCurrentSet.Count - 1]).Sequence
end;

// -------------------------------------------------------------------------- //

procedure TFRowDetailsSet.MIDeleteClick(Sender: TObject);
var
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
  SqlDelete : string;
  I : Integer;
begin
  if ((m_RowSelected - 1) >= 0) and (m_ListAutoRunCurrentSet.Count > 0) then
  begin
    tbInfo := @tblInfo[tbl_cfg_AutoRunDefinition];
    qry := CreateQuery(Cfg_DB);
    Qry.Transaction := CreateTransaction(Cfg_DB);
    Qry.Transaction.StartTransaction;
    qry.SQL.Clear;

    SqlDelete := 'delete from ' + tbInfo.GetTableName;
    SqlDelete := SqlDelete + ' Where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + '=' + QuotedStr(IniAppGlobals.WkstCode);
    SqlDelete := SqlDelete + ' And ' + CreateFld(tbInfo.pfx, fli_AutomaticRunCode) + '=' + QuotedStr(m_SetCode);
    SqlDelete := SqlDelete + ' And ' + CreateFld(tbInfo.pfx, fli_LineNumber) + '=' + IntToStr(PTUserDefRecord(m_ListAutoRunCurrentSet[m_RowSelected -1]).SequenceInDB);
    SqlDelete := SqlDelete + AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier));

    for I := m_ListAutoRunSet.Count - 1 downto 0 do
    begin
      if (PTUserDefRecord(m_ListAutoRunSet[I]).SetCode = m_SetCode) and
         (PTUserDefRecord(m_ListAutoRunSet[I]).SequenceInDB = PTUserDefRecord(m_ListAutoRunCurrentSet[m_RowSelected - 1]).SequenceInDB) then
      begin
        m_ListAutoRunSet.Delete(I);
        break
      end;
    end;
    m_ListAutoRunCurrentSet.Delete(m_RowSelected - 1);

    qry.sql.Text := SqlDelete;
    Qry.ExecSQL;
    Qry.Transaction.Commit;
//    m_CalShiftList.Sort(SortByStartDate);
    m_ListAutoRunCurrentSet.sort(SortBySequence);
    RefreshDataGrid;
    qry.Free;
  end;
end;

// -------------------------------------------------------------------------- //

procedure TFRowDetailsSet.MiInsertClick(Sender: TObject);
var
  AutoRunDefine : TAutoRunDefinition;
  UserDefRecord : PTUserDefRecord;
  SqlSelect, SqlInsert : string;
  tbInfo: ^TTblInfo;
  qry:    TMqmQuery;
  LastLineNumber : integer;
begin
  m_ListAutoRunCurrentSet.sort(SortBySequence);
  AutoRunDefine := TAutoRunDefinition.CreateNewSet(self, m_SetCode, GetLastSequence, m_mailGroupList);
  AutoRunDefine.ShowModal;
  if AutoRunDefine.ModalResult = mrOK then
  begin
    New(UserDefRecord);
    UserDefRecord.Sequence := AutoRunDefine.SEdtSequence.Value;
  //  UserDefRecord.SequenceInDB := AutoRunDefine.SEdtSequence.Value;
    UserDefRecord.SetCode   := m_SetCode;

    if DBAppGlobals.MCM_App then
    begin

      case AutoRunDefine.CBOperation.ItemIndex of
       0 : UserDefRecord.Operation := UD_Automatic_Sequencing;
       1 : UserDefRecord.Operation := UD_split;
       2 : UserDefRecord.Operation := UD_Unschedule_All;
       3 : UserDefRecord.Operation := UD_Unschedule_All_LAST_OnGantt;
       4 : UserDefRecord.Operation := UD_Close;
       5 : UserDefRecord.Operation := UD_Save;
       6 : UserDefRecord.Operation := UD_AutoSchedAllReBuildGenericPlan;
       7 : UserDefRecord.Operation := UD_Set_bin_jobs_selection_property_False;
       8 : UserDefRecord.Operation := UD_Set_bin_jobs_selection_property_true;
       9 : UserDefRecord.Operation := UD_Set_bin_jobs_selection_property_False_AndServingCode;
       10 : UserDefRecord.Operation := UD_Set_bin_jobs_selection_property_true_AndServingCode;
       11 : UserDefRecord.Operation := UD_Set_bin_jobs_selection_Copy_Value_From_Next_LinkedStep;
       12 : UserDefRecord.Operation := UD_CopySelectionPropertyFromCurrentStepToPrevAndNextStep;

       13 : UserDefRecord.Operation := UD_CopySelectionPropertyFromCurrentStepToPrevStep;
       14 : UserDefRecord.Operation := UD_CopySelectionPropertyFromCurrentStepToNextStep;
       15 : UserDefRecord.Operation := UD_CopySelectionPropertyFromCurrentStepToPrevSteps;
       16 : UserDefRecord.Operation := UD_CopySelectionpropertyFromCurrentStepToNextSteps;
       17 : UserDefRecord.Operation := UD_SETAlterPlanedWcByPlant;
       18 : UserDefRecord.Operation := UD_ReturnToOriginalWorkCerter;
       19 : UserDefRecord.Operation := UD_SetjobslimitDates;
       20 : UserDefRecord.Operation := UD_RemoveJobsCalculatedLimitDates;
       21 : UserDefRecord.Operation := UD_BalanceImbalancedSteps;
       22 : UserDefRecord.Operation := UD_JoinAllNotScheduledSubSteps;
       23 : UserDefRecord.Operation := UD_putInAllAutoSeqCfgTheCurrDateTime;
       24 : UserDefRecord.Operation := UD_SetSavedScheduleDate;
       25 : UserDefRecord.Operation := UD_CreatePeriodResourceAndSendMail;
       26 : UserDefRecord.Operation := UD_MCM_OverrParams_InfiniteCapacityAllowed;
       27 : UserDefRecord.Operation := UD_MCM_RepositionJobsToRealMachines;
       28 : UserDefRecord.Operation := UD_PushAllJobsToNow;
       29 : UserDefRecord.Operation := UD_SET_To_Initial;
       30 : UserDefRecord.Operation := UD_SET_To_FINAL;
     //  31 : UserDefRecord.Operation := UD_SET_Conf_Lvl_1;
     //  32 : UserDefRecord.Operation := UD_SET_Conf_Lvl_2;
    //   33 : UserDefRecord.Operation := UD_SET_Conf_Lvl_3;
    //   34 : UserDefRecord.Operation := UD_SET_Conf_Lvl_4;
    //   35 : UserDefRecord.Operation := UD_SET_Conf_Lvl_5;
       31 : UserDefRecord.Operation := UD_Start_Loop;
       32 : UserDefRecord.Operation := UD_Go_To_Loop_Start_When_Bin_Has_jobs;

      end;
    end
    else
    begin

      case AutoRunDefine.CBOperation.ItemIndex of
       0 : UserDefRecord.Operation := UD_Automatic_Sequencing;
       1 : UserDefRecord.Operation := UD_split;
       2 : UserDefRecord.Operation := UD_Unschedule_All;
       3 : UserDefRecord.Operation := UD_Unschedule_All_LAST_OnGantt;
       4 : UserDefRecord.Operation := UD_Close;
       5 : UserDefRecord.Operation := UD_Save;
       6 : UserDefRecord.Operation := UD_AutoSchedAllReBuildGenericPlan;
       7 : UserDefRecord.Operation := UD_Set_bin_jobs_selection_property_False;
       8 : UserDefRecord.Operation := UD_Set_bin_jobs_selection_property_true;
       9 : UserDefRecord.Operation := UD_Set_bin_jobs_selection_property_False_AndServingCode;
       10 : UserDefRecord.Operation := UD_Set_bin_jobs_selection_property_true_AndServingCode;
       11 : UserDefRecord.Operation := UD_Set_bin_jobs_selection_Copy_Value_From_Next_LinkedStep;
       12 : UserDefRecord.Operation := UD_CopySelectionPropertyFromCurrentStepToPrevAndNextStep;

       13 : UserDefRecord.Operation := UD_CopySelectionPropertyFromCurrentStepToPrevStep;
       14 : UserDefRecord.Operation := UD_CopySelectionPropertyFromCurrentStepToNextStep;
       15 : UserDefRecord.Operation := UD_CopySelectionPropertyFromCurrentStepToPrevSteps;
       16 : UserDefRecord.Operation := UD_CopySelectionpropertyFromCurrentStepToNextSteps;

       17 : UserDefRecord.Operation := UD_SETAlterPlanedWcByPlant;
       18 : UserDefRecord.Operation := UD_ReturnToOriginalWorkCerter;
       19 : UserDefRecord.Operation := UD_SetjobslimitDates;
       20 : UserDefRecord.Operation := UD_RemoveJobsCalculatedLimitDates;
       21 : UserDefRecord.Operation := UD_BalanceImbalancedSteps;
       22 : UserDefRecord.Operation := UD_JoinAllNotScheduledSubSteps;
       23 : UserDefRecord.Operation := UD_putInAllAutoSeqCfgTheCurrDateTime;
       24 : UserDefRecord.Operation := UD_SetSavedScheduleDate;
       25 : UserDefRecord.Operation := UD_CreatePeriodResourceAndSendMail;
     //  22 : UserDefRecord.Operation := UD_MCM_OverrParams_InfiniteCapacityAllowed;
     //  23 : UserDefRecord.Operation := UD_MCM_RepositionJobsToRealMachines;
       26 : UserDefRecord.Operation := UD_PushAllJobsToNow;
       27 : UserDefRecord.Operation := UD_SET_To_Initial;
       28 : UserDefRecord.Operation := UD_SET_To_FINAL;
     //  29 : UserDefRecord.Operation := UD_SET_Conf_Lvl_1;
     //  30 : UserDefRecord.Operation := UD_SET_Conf_Lvl_2;
     //  31 : UserDefRecord.Operation := UD_SET_Conf_Lvl_3;
     //  32 : UserDefRecord.Operation := UD_SET_Conf_Lvl_4;
     //  33 : UserDefRecord.Operation := UD_SET_Conf_Lvl_5;
       29 : UserDefRecord.Operation := UD_Start_Loop;
       30 : UserDefRecord.Operation := UD_Go_To_Loop_Start_When_Bin_Has_jobs;

      end;

    end;

    UserDefRecord.ActiveGanttTab := AutoRunDefine.CBActiveGantt.Items[AutoRunDefine.CBActiveGantt.ItemIndex];
    UserDefRecord.ActiveBinTab   := AutoRunDefine.CBActiveBin.Items[AutoRunDefine.CBActiveBin.ItemIndex];
    UserDefRecord.AutoSeqCfgName := AutoRunDefine.CBAutoSeqCfgName.Items[AutoRunDefine.CBAutoSeqCfgName.ItemIndex];
    UserDefRecord.MailGroupCode  := AutoRunDefine.CBMailCodeList.Items[AutoRunDefine.CBMailCodeList.ItemIndex];
    m_ListAutoRunSet.add(UserDefRecord);
    m_ListAutoRunCurrentSet.Add(UserDefRecord);
    FMQMPlan.m_ListAutoRunSetInfo.Add(UserDefRecord);
    m_ListAutoRunCurrentSet.sort(SortBySequence);
    RefreshDataGrid;

    tbInfo := @tblInfo[tbl_cfg_AutoRunDefinition];
    qry := CreateQuery(Cfg_DB);
    Qry.Transaction := CreateTransaction(Cfg_DB);
    Qry.Transaction.StartTransaction;

    SqlSelect := ' select max ( '+ CreateFld(tbInfo.pfx, fli_LineNumber) + ')' + ' as LineNumber ' + ' from ' + tbInfo.GetTableName;
    SqlSelect := SqlSelect + ' where ';
    SqlSelect := SqlSelect + CreateFld(tbInfo.pfx, fli_wkstCode) + '=' + QuotedStr(IniAppGlobals.WkstCode);
    SqlSelect := SqlSelect + ' and ' + CreateFld(tbInfo.pfx, fli_AutomaticRunCode) + '=' + QuotedStr(m_SetCode);
    SqlSelect := SqlSelect + AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier));
    qry.SQL.Text := SqlSelect;
    qry.open;
    if Qry.Eof then
      LastLineNumber := 0
    else
    begin
      LastLineNumber := qry.FieldByName('LineNumber').AsInteger;
    end;

    SqlInsert := '';
    SqlInsert := 'insert into ' + tbInfo.GetTableName + '(';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_identifier) + ',';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_wkstCode) + ',';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_AutomaticRunCode) + ',';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_LineNumber) + ',';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_Sequence) + ',';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_OperationCode) + ',';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_Bin) + ',';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_Gantt) + ',';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_OperationDetail) + ',';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_MailGroupName);
    SqlInsert := SqlInsert + ') values (';
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_identifier) + ',' ;
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_wkstCode) + ',' ;
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_AutomaticRunCode) + ',';
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_LineNumber) + ',';
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_Sequence) + ',';
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_OperationCode) + ',' ;
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_Bin) + ',';
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_Gantt) + ',';
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_OperationDetail) + ',';
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_MailGroupName);
    SqlInsert := SqlInsert + ')';
    qry.SQL.Clear;
    qry.SQL.Text := SqlInsert;

    qry.ParamByName(CreateFld(tbInfo.pfx,fli_identifier)).AsString := IniAppGlobals.Identifier;
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_wkstCode)).AsString := IniAppGlobals.WkstCode;
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_AutomaticRunCode)).AsString := m_SetCode;
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_LineNumber)).AsInteger := LastLineNumber + 1;
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_Sequence)).AsInteger := UserDefRecord.Sequence;
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).DataType := ftString;
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).size := 2;

    if DBAppGlobals.MCM_App then
    begin

      case AutoRunDefine.CBOperation.ItemIndex of
       0 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'A';
       1 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'P';
       2 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'U';
       3 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'M';
       4 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'C';
       5 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'S';
       6 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'B';
       7 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'N';
       8 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'Y';
       9 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'G';
       10 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'H';
       11 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'K';
       12 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'Q';
       13 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'Q1';
       14 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'Q2';
       15 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'Q3';
       16 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'Q4';
       17 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'W';
       18 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'R';
       19 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'D';
       20 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'L';
       21 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'E';
       22 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'J';
       23 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'O';
       24 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'T';
       25 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := '7';
       26 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'X';
       27 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'Z';
       28 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'PN';
       29 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'I';
       30 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'F';
   //    31 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := '1';
   //    32 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := '2';
   //    33 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := '3';
   //    34 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := '4';
   //    35 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := '5';
       31 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'SL';
       32 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'GL';

      end

    end
    else
    begin

      case AutoRunDefine.CBOperation.ItemIndex of
       0 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'A';
       1 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'P';
       2 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'U';
       3 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'M';
       4 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'C';
       5 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'S';
       6 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'B';
       7 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'N';
       8 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'Y';
       9 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'G';
       10 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'H';
       11 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'K';
       12 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'Q';
       13 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'Q1';
       14 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'Q2';
       15 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'Q3';
       16 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'Q4';

       17 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'W';
       18 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'R';
       19 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'D';
       20 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'L';
       21 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'E';
       22 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'J';
       23 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'O';
       24 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'T';
       25 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := '7';
     //  22 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'X';
     //  23 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'Z';
       26 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'PN';
       27 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'I';
       28 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'F';
   //    29 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := '1';
   //    30 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := '2';
  //     31 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := '3';
  //     32 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := '4';
  //     33 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := '5';
       29 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'SL';
       30 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'GL';

      end

    end;


    qry.ParamByName(CreateFld(tbInfo.pfx,fli_Bin)).AsString := UserDefRecord.ActiveBinTab;
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_Gantt)).AsString := UserDefRecord.ActiveGanttTab;
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationDetail)).AsString := UserDefRecord.AutoSeqCfgName;
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_MailGroupName)).AsString := UserDefRecord.MailGroupCode;

    qry.ExecSQL;
    qry.Transaction.Commit;
    qry.free;
    UserDefRecord.SequenceInDB := LastLineNumber + 1;
  end;

end;

//-------------------------------------------------------------------------- //

procedure TFRowDetailsSet.MiUpdateClick(Sender: TObject);
var
  tbInfo: ^TTblInfo;
  qry:    TMqmQuery;
  UserDefRecord : PTUserDefRecord;
  AutoRunDefine : TAutoRunDefinition;
  I : Integer;
  SqlUpdate : string;
begin
  if not (((m_RowSelected - 1) >= 0) and (m_ListAutoRunCurrentSet.Count > 0)) then exit;

  if m_ListAutoRunCurrentSet.Count = 1 then
    m_RowSelected := 1;
  tbInfo := @tblInfo[tbl_cfg_AutoRunDefinition];
  qry := CreateQuery(Cfg_DB);
  Qry.Transaction := CreateTransaction(Cfg_DB);
  Qry.Transaction.StartTransaction;

  AutoRunDefine := TAutoRunDefinition.UpdateSet(self, m_SetCode, m_ListAutoRunCurrentSet[m_RowSelected -1], m_mailGroupList);
  AutoRunDefine.ShowModal;
  if AutoRunDefine.ModalResult = mrOK then
  begin
    UserDefRecord := m_ListAutoRunCurrentSet[m_RowSelected -1];

    if DBAppGlobals.MCM_App then
    begin

      case AutoRunDefine.CBOperation.ItemIndex of
       0 : UserDefRecord.Operation := UD_Automatic_Sequencing;
       1 : UserDefRecord.Operation := UD_split;
       2 : UserDefRecord.Operation := UD_Unschedule_All;
       3 : UserDefRecord.Operation := UD_Unschedule_All_LAST_OnGantt;
       4 : UserDefRecord.Operation := UD_Close;
       5 : UserDefRecord.Operation := UD_Save;
       6 : UserDefRecord.Operation := UD_AutoSchedAllReBuildGenericPlan;
       7 : UserDefRecord.Operation := UD_Set_bin_jobs_selection_property_False;
       8 : UserDefRecord.Operation := UD_Set_bin_jobs_selection_property_true;
       9 : UserDefRecord.Operation := UD_Set_bin_jobs_selection_property_False_AndServingCode;
       10 : UserDefRecord.Operation := UD_Set_bin_jobs_selection_property_true_AndServingCode;
       11 : UserDefRecord.Operation := UD_Set_bin_jobs_selection_Copy_Value_From_Next_LinkedStep;
       12 : UserDefRecord.Operation := UD_CopySelectionPropertyFromCurrentStepToPrevAndNextStep;

       13 : UserDefRecord.Operation := UD_CopySelectionPropertyFromCurrentStepToPrevStep;
       14 : UserDefRecord.Operation := UD_CopySelectionPropertyFromCurrentStepToNextStep;
       15 : UserDefRecord.Operation := UD_CopySelectionPropertyFromCurrentStepToPrevSteps;
       16 : UserDefRecord.Operation := UD_CopySelectionpropertyFromCurrentStepToNextSteps;


       17 : UserDefRecord.Operation := UD_SETAlterPlanedWcByPlant;
       18 : UserDefRecord.Operation := UD_ReturnToOriginalWorkCerter;
       19 : UserDefRecord.Operation := UD_SetjobslimitDates;
       20 : UserDefRecord.Operation := UD_RemoveJobsCalculatedLimitDates;
       21 : UserDefRecord.Operation := UD_BalanceImbalancedSteps;
       22 : UserDefRecord.Operation := UD_JoinAllNotScheduledSubSteps;
       23 : UserDefRecord.Operation := UD_putInAllAutoSeqCfgTheCurrDateTime;
       24 : UserDefRecord.Operation := UD_SetSavedScheduleDate;
       25 : UserDefRecord.Operation := UD_CreatePeriodResourceAndSendMail;
       26 : UserDefRecord.Operation := UD_MCM_OverrParams_InfiniteCapacityAllowed;
       27 : UserDefRecord.Operation := UD_MCM_RepositionJobsToRealMachines;
       28 : UserDefRecord.Operation := UD_PushAllJobsToNow;
       29 : UserDefRecord.Operation := UD_SET_To_Initial;
       30 : UserDefRecord.Operation := UD_SET_To_FINAL;
      { 31 : UserDefRecord.Operation := UD_SET_Conf_Lvl_1;
       32 : UserDefRecord.Operation := UD_SET_Conf_Lvl_2;
       33 : UserDefRecord.Operation := UD_SET_Conf_Lvl_3;
       34 : UserDefRecord.Operation := UD_SET_Conf_Lvl_4;
       35 : UserDefRecord.Operation := UD_SET_Conf_Lvl_5;   }
       31 : UserDefRecord.Operation := UD_Start_Loop;
       32 : UserDefRecord.Operation := UD_Go_To_Loop_Start_When_Bin_Has_jobs;

      end
    end
    else
    begin
      case AutoRunDefine.CBOperation.ItemIndex of
       0 : UserDefRecord.Operation := UD_Automatic_Sequencing;
       1 : UserDefRecord.Operation := UD_split;
       2 : UserDefRecord.Operation := UD_Unschedule_All;
       3 : UserDefRecord.Operation := UD_Unschedule_All_LAST_OnGantt;
       4 : UserDefRecord.Operation := UD_Close;
       5 : UserDefRecord.Operation := UD_Save;
       6 : UserDefRecord.Operation := UD_AutoSchedAllReBuildGenericPlan;
       7 : UserDefRecord.Operation := UD_Set_bin_jobs_selection_property_False;
       8 : UserDefRecord.Operation := UD_Set_bin_jobs_selection_property_true;
       9 : UserDefRecord.Operation := UD_Set_bin_jobs_selection_property_False_AndServingCode;
       10 : UserDefRecord.Operation := UD_Set_bin_jobs_selection_property_true_AndServingCode;
       11 : UserDefRecord.Operation := UD_Set_bin_jobs_selection_Copy_Value_From_Next_LinkedStep;
       12 : UserDefRecord.Operation := UD_CopySelectionPropertyFromCurrentStepToPrevAndNextStep;
       13 : UserDefRecord.Operation := UD_CopySelectionPropertyFromCurrentStepToPrevStep;
       14 : UserDefRecord.Operation := UD_CopySelectionPropertyFromCurrentStepToNextStep;
       15 : UserDefRecord.Operation := UD_CopySelectionPropertyFromCurrentStepToPrevSteps;
       16 : UserDefRecord.Operation := UD_CopySelectionpropertyFromCurrentStepToNextSteps;

       17 : UserDefRecord.Operation := UD_SETAlterPlanedWcByPlant;
       18 : UserDefRecord.Operation := UD_ReturnToOriginalWorkCerter;
       19 : UserDefRecord.Operation := UD_SetjobslimitDates;
       20 : UserDefRecord.Operation := UD_RemoveJobsCalculatedLimitDates;
       21 : UserDefRecord.Operation := UD_BalanceImbalancedSteps;
       22 : UserDefRecord.Operation := UD_JoinAllNotScheduledSubSteps;
       23 : UserDefRecord.Operation := UD_putInAllAutoSeqCfgTheCurrDateTime;
       24 : UserDefRecord.Operation := UD_SetSavedScheduleDate;
       25 : UserDefRecord.Operation := UD_CreatePeriodResourceAndSendMail;
    //   22 : UserDefRecord.Operation := UD_MCM_OverrParams_InfiniteCapacityAllowed;
    //   23 : UserDefRecord.Operation := UD_MCM_RepositionJobsToRealMachines;
       26 : UserDefRecord.Operation := UD_PushAllJobsToNow;
       27 : UserDefRecord.Operation := UD_SET_To_Initial;
       28 : UserDefRecord.Operation := UD_SET_To_FINAL;
    {   29 : UserDefRecord.Operation := UD_SET_Conf_Lvl_1;
       30 : UserDefRecord.Operation := UD_SET_Conf_Lvl_2;
       31 : UserDefRecord.Operation := UD_SET_Conf_Lvl_3;
       32 : UserDefRecord.Operation := UD_SET_Conf_Lvl_4;
       33 : UserDefRecord.Operation := UD_SET_Conf_Lvl_5;   }
       29 : UserDefRecord.Operation := UD_Start_Loop;
       30 : UserDefRecord.Operation := UD_Go_To_Loop_Start_When_Bin_Has_jobs;

      end

    end;

    UserDefRecord.ActiveGanttTab := AutoRunDefine.CBActiveGantt.Items[AutoRunDefine.CBActiveGantt.ItemIndex];
    UserDefRecord.ActiveBinTab   := AutoRunDefine.CBActiveBin.Items[AutoRunDefine.CBActiveBin.ItemIndex];
    UserDefRecord.AutoSeqCfgName := AutoRunDefine.CBAutoSeqCfgName.Items[AutoRunDefine.CBAutoSeqCfgName.ItemIndex];
    UserDefRecord.MailGroupCode  := AutoRunDefine.CBMailCodeList.Items[AutoRunDefine.CBMailCodeList.ItemIndex];
    UserDefRecord.Sequence := AutoRunDefine.SEdtSequence.Value;

    for I := m_ListAutoRunSet.Count - 1 downto 0 do
    begin
      if (PTUserDefRecord(m_ListAutoRunSet[I]).SetCode = m_SetCode) and
         (PTUserDefRecord(m_ListAutoRunSet[I]).SequenceInDB = PTUserDefRecord(m_ListAutoRunCurrentSet[m_RowSelected - 1]).SequenceInDB) then
      begin
        PTUserDefRecord(m_ListAutoRunSet[I]).Sequence := UserDefRecord.Sequence;
        PTUserDefRecord(m_ListAutoRunSet[I]).Operation := UserDefRecord.Operation;
        PTUserDefRecord(m_ListAutoRunSet[I]).ActiveGanttTab := UserDefRecord.ActiveGanttTab;
        PTUserDefRecord(m_ListAutoRunSet[I]).ActiveBinTab := UserDefRecord.ActiveBinTab;
        PTUserDefRecord(m_ListAutoRunSet[I]).AutoSeqCfgName := UserDefRecord.AutoSeqCfgName;
        PTUserDefRecord(m_ListAutoRunSet[I]).MailGroupCode  := UserDefRecord.MailGroupCode;
        break
      end;
    end;
    m_ListAutoRunCurrentSet.sort(SortBySequence);
    RefreshDataGrid;

    SqlUpdate := 'update ' + tbInfo.GetTableName + ' set ';
    SqlUpdate := SqlUpdate + CreateFld(tbInfo.pfx, fli_identifier) + ' = ';
    SqlUpdate := SqlUpdate + ':' + CreateFld(tbInfo.pfx, fli_identifier) + ',';
    SqlUpdate := SqlUpdate + CreateFld(tbInfo.pfx, fli_Sequence) + ' = ';
    SqlUpdate := SqlUpdate + ':' + CreateFld(tbInfo.pfx, fli_Sequence) + ',';
    SqlUpdate := SqlUpdate + CreateFld(tbInfo.pfx, fli_OperationCode) + ' = ';
    SqlUpdate := SqlUpdate + ':' + CreateFld(tbInfo.pfx, fli_OperationCode) + ',';
    SqlUpdate := SqlUpdate + CreateFld(tbInfo.pfx, fli_Bin) + ' = ';
    SqlUpdate := SqlUpdate + ':' + CreateFld(tbInfo.pfx, fli_Bin)  + ',';
    SqlUpdate := SqlUpdate + CreateFld(tbInfo.pfx, fli_Gantt) + ' = ';
    SqlUpdate := SqlUpdate + ':' + CreateFld(tbInfo.pfx, fli_Gantt)  + ',';
    SqlUpdate := SqlUpdate + CreateFld(tbInfo.pfx, fli_OperationDetail) + ' = ';
    SqlUpdate := SqlUpdate + ':' + CreateFld(tbInfo.pfx, fli_OperationDetail) + ',';
    SqlUpdate := SqlUpdate + CreateFld(tbInfo.pfx, fli_MailGroupName) + ' = ';
    SqlUpdate := SqlUpdate + ':' + CreateFld(tbInfo.pfx, fli_MailGroupName);
    SqlUpdate := SqlUpdate + ' where ';
    SqlUpdate := SqlUpdate + CreateFld(tbInfo.pfx, fli_identifier)   + ' = ';
    SqlUpdate := SqlUpdate + ':' + CreateFld(tbInfo.pfx, fli_identifier) + ' and ';
    SqlUpdate := SqlUpdate + CreateFld(tbInfo.pfx, fli_wkstCode)   + ' = ';
    SqlUpdate := SqlUpdate + ':' + CreateFld(tbInfo.pfx, fli_wkstCode) + ' and ';
    SqlUpdate := SqlUpdate + CreateFld(tbInfo.pfx, fli_AutomaticRunCode)   + ' = ';
    SqlUpdate := SqlUpdate + ':' + CreateFld(tbInfo.pfx, fli_AutomaticRunCode) + ' and ';
    SqlUpdate := SqlUpdate + CreateFld(tbInfo.pfx, fli_LineNumber)   + ' = ';
    SqlUpdate := SqlUpdate + ':' + CreateFld(tbInfo.pfx, fli_LineNumber);
    qry.SQL.Text := SqlUpdate;

    qry.ParamByName(CreateFld(tbInfo.pfx, fli_identifier)).AsString := IniAppGlobals.Identifier;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_wkstCode)).AsString := IniAppGlobals.WkstCode;//QuotedStr(IniAppGlobals.WkstCode);
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_AutomaticRunCode)).AsString := m_SetCode;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_LineNumber)).AsInteger      := UserDefRecord.SequenceInDB;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_Sequence)).AsInteger := AutoRunDefine.SEdtSequence.Value;

    if DBAppGlobals.MCM_App then
    begin

      case AutoRunDefine.CBOperation.ItemIndex of
       0 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'A';
       1 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'P';
       2 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'U';
       3 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'M';
       4 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'C';
       5 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'S';
       6 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'B';
       7 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'N';
       8 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'Y';
       9 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'G';
       10 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'H';
       11 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'K';
       12 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'Q';
       13 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'Q1';
       14 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'Q2';
       15 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'Q3';
       16 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'Q4';


       17 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'W';
       18 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'R';
       19 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'D';
       20 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'L';
       21 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'E';
       22 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'J';
       23 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'O';
       24 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'T';
       25 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := '7';
       26 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'X';
       27 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'Z';
       28 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'PN';
       29 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'I';
       30 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'F';
      { 31 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := '1';
       32 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := '2';
       33 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := '3';
       34 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := '4';
       35 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := '5'; }
       31 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'SL';
       32 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'GL';

      end
    end
    else
    begin
      case AutoRunDefine.CBOperation.ItemIndex of
       0 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'A';
       1 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'P';
       2 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'U';
       3 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'M';
       4 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'C';
       5 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'S';
       6 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'B';
       7 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'N';
       8 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'Y';
       9 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'G';
       10 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'H';
       11 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'K';
       12 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'Q';

       13 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'Q1';
       14 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'Q2';
       15 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'Q3';
       16 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'Q4';

       17 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'W';
       18 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'R';
       19 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'D';
       20 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'L';
       21 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'E';
       22 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'J';
       23 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'O';
       24 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'T';
       25 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := '7';
    //   22 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'X';
    //   23 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'Z';
       26 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'PN';
       27 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'I';
       28 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'F';
    {   29 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := '1';
       30 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := '2';
       31 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := '3';
       32 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := '4';
       33 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := '5';  }
       29 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'SL';
       30 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_OperationCode)).AsString := 'GL';
      end
    end;

    //    qry.ParamByName(CreateFld(tbInfo.pfx, fli_Sequence)).AsInteger        := UserDefRecord.Sequence;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_Bin)).AsString := AutoRunDefine.CBActiveBin.Items[AutoRunDefine.CBActiveBin.ItemIndex];
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_Gantt)).AsString  := AutoRunDefine.CBActiveGantt.Items[AutoRunDefine.CBActiveGantt.ItemIndex];
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_OperationDetail)).AsString := AutoRunDefine.CBAutoSeqCfgName.Items[AutoRunDefine.CBAutoSeqCfgName.ItemIndex];
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_MailGroupName)).AsString := AutoRunDefine.CBMailCodeList.Items[AutoRunDefine.CBMailCodeList.ItemIndex];

    Qry.ExecSQL;
    Qry.Transaction.Commit;
    qry.Free;

  end;
end;

procedure TFRowDetailsSet.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

//-------------------------------------------------------------------------- //

procedure TFRowDetailsSet.RefreshDataGrid;
var
  I : integer;
  RowData : PTUserDefRecord;
begin
  with SGRowDetailsSet do
  begin
    RowCount := m_ListAutoRunCurrentSet.Count + 1;
    if RowCount > 1 then FixedRows := 1;

    Cells[0, 0] := _('Sequence');
    Cells[1, 0] := _('Operation');
    Cells[2, 0] := _('Active Gantt Tab');
    Cells[3, 0] := _('Active Bin Tab ');
    Cells[4, 0] := _('Operation details');
    Cells[5, 0] := _('Mail group Code');

    for i:= 0 to m_ListAutoRunCurrentSet.Count - 1 do
    begin
      RowData := m_ListAutoRunCurrentSet.Items[i];
      Cells[0, i+1] := IntToStr(RowData.Sequence);
      if RowData.Operation = UD_Automatic_Sequencing then
         Cells[1, i+1] := (_('Automatic Sequencing'))
      else if RowData.Operation = UD_split then
         Cells[1, i+1] := (_('Split'))
      else if RowData.Operation = UD_Unschedule_All then
         Cells[1, i+1] := (_('Unschedule all'))
      else if RowData.Operation = UD_Unschedule_All_LAST_OnGantt then
         Cells[1, i+1] := (_('Unschedule all last on gantt'))
      else if RowData.Operation = UD_Close then
         Cells[1, i+1] := (_('Close program'))
      else if RowData.Operation = UD_Save then
         Cells[1, i+1] := (_('Save'))
      else if RowData.Operation = UD_AutoSchedAllReBuildGenericPlan then
         Cells[1, i+1] := (_('Automatic Sequencing Rebuild Generic Plan'))
      else if RowData.Operation = UD_Set_bin_jobs_selection_property_False then
         Cells[1, i+1] := (_('Set jobs selection property/false'))
      else if RowData.Operation = UD_Set_bin_jobs_selection_property_true then
         Cells[1, i+1] := (_('Set jobs selection property/true'))
      else if RowData.Operation = UD_Set_bin_jobs_selection_property_False_AndServingCode then
         Cells[1, i+1] := (_('Set jobs selection property/false (also to related serving code jobs)'))
      else if RowData.Operation = UD_Set_bin_jobs_selection_property_true_AndServingCode then
         Cells[1, i+1] := (_('Set jobs selection property/true (also to related serving code jobs)'))
      else if RowData.Operation = UD_Set_bin_jobs_selection_Copy_Value_From_Next_LinkedStep then
         Cells[1, i+1] := (_('Copy selection property value from next linked step'))
      else if RowData.Operation = UD_CopySelectionPropertyFromCurrentStepToPrevAndNextStep then
         Cells[1, i+1] := (_('Copy selection property from current step to prev and next step'))

      else if RowData.Operation = UD_CopySelectionPropertyFromCurrentStepToPrevStep then
         Cells[1, i+1] := (_('Copy selection property from current step to prev step'))
      else if RowData.Operation = UD_CopySelectionPropertyFromCurrentStepToNextStep then
         Cells[1, i+1] := (_('Copy selection property from current step to next step'))
      else if RowData.Operation = UD_CopySelectionPropertyFromCurrentStepToPrevSteps then
         Cells[1, i+1] := (_('Copy selection property from current step to prev steps'))
      else if RowData.Operation = UD_CopySelectionpropertyFromCurrentStepToNextSteps then
         Cells[1, i+1] := (_('Copy selection property from current step to next steps'))

      else if RowData.Operation = UD_SETAlterPlanedWcByPlant then
         Cells[1, i+1] := (_('Alter planned work center by plant'))
      else if RowData.Operation = UD_ReturnToOriginalWorkCerter then
         Cells[1, i+1] := (_('Return to original work center'))
      else if RowData.Operation = UD_SetjobslimitDates then
         Cells[1, i+1] := (_('Set jobs limit dates'))
      else if RowData.Operation = UD_RemoveJobsCalculatedLimitDates then
         Cells[1, i+1] := (_('Remove Jobs Calculated Limit Dates'))
      else if RowData.Operation = UD_BalanceImbalancedSteps then
         Cells[1, i+1] := (_('Balance Imbalanced steps in bin'))
      else if RowData.Operation = UD_JoinAllNotScheduledSubSteps then
         Cells[1, i+1] := (_('Join all not scheduled sub steps in bin'))
      else if RowData.Operation = UD_putInAllAutoSeqCfgTheCurrDateTime then
         Cells[1, i+1] := (_('Put the current date time in all Auto.Seq.Cfgs. for this stations'))
      else if RowData.Operation = UD_SetSavedScheduleDate then
         Cells[1, i+1] := (_('Update saved date with scheduled or overlap date'))
      else if RowData.Operation = UD_CreatePeriodResourceAndSendMail then
         Cells[1, i+1] := (_('Create Period dynamic schedule report and send mail'))
      else if RowData.Operation = UD_MCM_OverrParams_InfiniteCapacityAllowed then
         Cells[1, i+1] := (_('Automatic Sequencing - Infinite Capacity Allowed'))
      else if RowData.Operation = UD_MCM_RepositionJobsToRealMachines then
         Cells[1, i+1] := (_('Re-position jobs to a real machines'))
      else if RowData.Operation = UD_PushAllJobsToNow then
         Cells[1, i+1] := (_('Push all jobs to current date and time'))
      else if RowData.Operation = UD_SET_To_FINAL then
         Cells[1, i+1] := (_('Set to final'))
      else if RowData.Operation = UD_SET_To_Initial then
         Cells[1, i+1] := (_('Set to initial'))
   {   else if RowData.Operation = UD_SET_Conf_Lvl_1 then
         Cells[1, i+1] := (_('Set to Conf.level 1'))
      else if RowData.Operation = UD_SET_Conf_Lvl_2 then
         Cells[1, i+1] := (_('Set to Conf.level 2'))
      else if RowData.Operation = UD_SET_Conf_Lvl_3 then
         Cells[1, i+1] := (_('Set to Conf.level 3'))
      else if RowData.Operation = UD_SET_Conf_Lvl_4 then
         Cells[1, i+1] := (_('Set to Conf.level 4'))
      else if RowData.Operation = UD_SET_Conf_Lvl_5 then
         Cells[1, i+1] := (_('Set to Conf.level 5'))    }
      else if RowData.Operation = UD_Start_Loop then
         Cells[1, i+1] := (_('Start loop'))
      else if RowData.Operation = UD_Go_To_Loop_Start_When_Bin_Has_jobs then
         Cells[1, i+1] := (_('Go to loop start when bin has jobs'));


      if (RowData.Operation = UD_Close) or (RowData.Operation = UD_Save) or
             (RowData.Operation = UD_PushAllJobsToNow) or (RowData.Operation = UD_Start_Loop) then
        Cells[2, i+1] := ''
      else
        Cells[2, i+1] := RowData.ActiveGanttTab;

      if (RowData.Operation = UD_Close) or (RowData.Operation = UD_Save) or
         (RowData.Operation = UD_PushAllJobsToNow) or (RowData.Operation = UD_Start_Loop) then
        Cells[3, i+1] := ''
      else
        Cells[3, i+1] := RowData.ActiveBinTab;

      Cells[4, i+1] := RowData.AutoSeqCfgName;

      if CheckMailGroupCode(RowData.MailGroupCode) then
        Cells[5, i+1] := RowData.MailGroupCode
      else
        RowData.MailGroupCode := '';
    end;
  end;

end;

//-------------------------------------------------------------------------- //

function TFRowDetailsSet.CheckMailGroupCode(MailGroupCode : string) : boolean;
var
  I : Integer;
begin
  Result := false;
  if m_mailGroupList = nil then exit;
  for I := 0 to m_mailGroupList.Count - 1 do
  begin
    if MailGroupCode = m_mailGroupList.Strings[I] then
    begin
      Result := true;
      Break
    end;
  end;
end;

//-------------------------------------------------------------------------- //

procedure SendReportByMail(MailGroupCode : string);
var
  tbInfo: ^TTblInfo;
  qry:    TMqmQuery;
  trs:    TMqmTransaction;
  SqlSelect : string;
  SendMailParam : TSendMailParm;
  FileName : string;
begin
  tbInfo := @tblInfo[tbl_cfg_Mail_set_List];
  qry := CreateQuery(Cfg_DB);

  SqlSelect := ' select * from ' + tbInfo.GetTableName;
  SqlSelect := SqlSelect + ' where ';
  SqlSelect := SqlSelect + CreateFld(tbInfo.pfx, fli_workstation) + '=' + QuotedStr(IniAppGlobals.WkstCode);
  SqlSelect := SqlSelect + ' and ' + CreateFld(tbInfo.pfx, fli_MailGroupName) + '=' + QuotedStr(MailGroupCode);
  SqlSelect := SqlSelect + AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier));
  qry.SQL.Text := SqlSelect;
  qry.open;
  if not Qry.Eof then
  begin
    if iniAppGlobals.MachineReportFileNameAutoOperation = '' then
       iniAppGlobals.MachineReportFileNameAutoOperation := 'ResourcePeriod';
    FileName := iniAppGlobals.MachineReportFileNameAutoOperation;
    SendMailParam.UserId := qry.FieldByName(CreateFld(tbInfo.pfx, fli_User_Id)).AsString;
    SendMailParam.Password := qry.FieldByName(CreateFld(tbInfo.pfx, fli_Password)).AsString;
    SendMailParam.Recipient := qry.FieldByName(CreateFld(tbInfo.pfx, fli_Recipient)).AsString;
    SendMailParam.AttachmentFilePath := LocAppGlobals.AppDir + 'Reports\' + FileName + '.Xls';
    SendMailParam.Subject := 'Mqm Report';
    SendMailParam.BodyText := '';
    SendMailParam.SmtpServer := IniAppGlobals.SMTP_server;
    SendMailParam.port := IniAppGlobals.PORT;
    if IniAppGlobals.TLS_SSL = '1' then
      SendMailParam.TLS_SSL := true
    else
      SendMailParam.TLS_SSL := false;
    SendEmail(SendMailParam)
  end;
  qry.Free
end;

//-------------------------------------------------------------------------- //

procedure TFRowDetailsSet.SGRowDetailsSetSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  m_RowSelected := Arow;
end;

//-------------------------------------------------------------------------- //

procedure DestroyList;
var
  I : Integer;
begin
  for I := m_ListAutoRunSet.Count - 1 downto 0 do
  begin
    Dispose(PTUserDefRecord(m_ListAutoRunSet[I]));
  end;
  m_ListAutoRunSet.Free;
end;

//-------------------------------------------------------------------------- //

initialization

 m_ListAutoRunSet := TList.Create;

finalization

 DestroyList;

end.
