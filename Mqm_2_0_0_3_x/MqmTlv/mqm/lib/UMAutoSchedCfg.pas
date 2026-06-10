unit UMAutoSchedCfg;

interface

uses
  classes,UMSchedContFunc,UMBinDefault, StdCtrls, UMCommon, Forms;

type

  TSplitAutoJobs = (ByMachinesOptimum, ByEqualQuantity, BalancingAll, DailyProductionAndJoin, ByMachinesOptimumForceSplit, LongestDurationPossible);
  TCreteriaOfResBachSize = (AnyResource, OnlySameSize, SameSizeExcpetSmallesBatch);

  TScoreAddition = record
    From_Job_to_Prior_Job_case  : Integer;
    To_Job_to_Prior_Job_case    : Integer;
    From_Job_to_Follow_Job_case : Integer;
    To_Job_to_Follow_Job_case   : Integer;
    From_Job_to_resource_case   : Integer;
    To_Job_to_resource_case     : Integer;
    From_number_of_days_delay   : Integer;
    To_number_of_days_delay     : Integer;
    From_number_of_days_early   : Integer;
    To_number_of_days_early       : Integer;
    From_number_minutes_setup_add : Integer;
    To_number_minutes_setup_add   : Integer;
    Add_to_score                  : Integer;
    Double_Direction              : boolean;
  end;
  PTScoreAddition = ^TScoreAddition;

  TIdDetails = record
    level          : integer;
    Id             : TschedId;
    ServeGroupCode : String;
  end;
  PTIdDetails = ^TIdDetails;

  TJobToJobDefinitions = record
    FromCase : integer;
    ToCase   : integer;
    AddToScore : integer;
  end;
  PTJobToJobDefinitions = ^TJobToJobDefinitions;

  TAutoSchedCfg = record
    m_CfgName       : string;
    m_CfgDesc       : string;
    m_CfgNameNext   : string;
    m_CfgGroup      : string;
    m_RunningMode   : integer;

    m_StartSchedFrom : integer;
    m_SpecificDateTime : TDateTime;
    m_NumberOfDaysFromCurrentDate : integer;
    m_McmListOfRescheduledId : TList;
    m_McmRescheduledJobs     : boolean;
    m_McmRescheduledJobsAutoOnStart : boolean;
    m_WithoutStack : boolean;

// --- NEW - START   - Near new name there is old one

    // TabSheet Preferences
    m_PrefTgtDate         : integer;    //  m_PrefTgtDate
    m_PrevOrNextLinkedJobIsTheTgtDateWhenScheduled : boolean;
    m_MoveObjsAllowed     : integer;  // m_MoveObjsAllowed
    m_MoveFinalObjsAlwd   : integer; // m_MoveFinalObjsAlwd
    m_MoveInitialObjsAlwd : integer; // m_MoveInitialObjsAlwd
    m_MoveLevel1ObjsAlwd  : integer; // m_MoveLevel1ObjsAlwd
    m_MoveLevel2ObjsAlwd  : integer; // m_MoveLevel2ObjsAlwd
    m_MoveLevel3ObjsAlwd  : integer; // m_MoveLevel3ObjsAlwd
    m_MoveLevel4ObjsAlwd  : integer; // m_MoveLevel4ObjsAlwd
    m_MoveLevel5ObjsAlwd  : integer; // m_MoveLevel5ObjsAlwd
//    m_CompactEntities     : integer; // m_CompactEntities
//    m_NextDays            : integer; // m_NextDays
    m_MinStartDateOffset  : Integer; // m_MinStartDateOffset
    m_TempFinal           : integer; // m_TempFinal
    m_RankRep             : boolean; // m_RankRep
    m_PriorErrLoop        : boolean; // m_PriorErrLoop
//    m_OneRequestAtTime    : boolean; // fli_OneRequestAtTime
    m_SplitSchedByBatchSize : TSplitAutoJobs;
    m_CreteriaOfResForBachZise : TCreteriaOfResBachSize;
    m_LastSplitCanGoUnderMin  : boolean;
    m_StopOnFirstNotSchedJob  : boolean;
    m_IdForStopOnFirstNotSchedJob  : TSchedID;

    // TabSheet Requirements
    m_MatWOMaterials      : integer; //  m_MatWOMaterials
    m_MatWOAddRes         : integer; //   m_MatWOAddRes


    // TabSheet Schedule limits
    m_MinJobResComp       : integer; // m_MinJobResComp
    m_MinJobJobComp       : integer; // m_MinJobJobComp
    m_MaxJobJobComp       : integer; // m_MaxJobJobComp
    m_MinJobCapResComp    : integer; // m_MinJobCapResComp
    m_BeforeLowLimit      : integer; // m_BeforeLowLimit
    m_TollBeforeLowLimit        : integer;
    m_TollBeforeLowLimitHours   : integer;
    m_TollBeforeLowLimitMinutes : integer;
    m_AfterHighLimit      : integer; // m_AfterHighLimit
    m_TollAfterHighLimit        : integer;
    m_TollAfterHighLimitHours   : integer;
    m_TollAfterHighLimitMinutes : integer;
    m_AllowSchedBeforeNoneConfLevl : boolean;

   //-------------------------------------------------------------------

    // TabSheet Schedule Score
    m_BeforeEarlDateTol   : double; // new item
    m_WithinEarlDateTol   : double; // new item
    m_AfterLatestDateTol  : double; // new item
    m_WithinLatestDateTol : double; // new item
    m_ScheduleToPossibleStartPenalty : double; // new item
    m_PenCompJobToJob     : double; // new item
    m_PenCompSetupMinutes : double; // new item
    m_PenCompJobToRes     : double; // new item
    m_PenCompJobToCapRes  : double; // new item
    m_PenCompJobNotCapRes : double; // new item
    m_DateScoreWeight     : integer; // new item
    m_CompScoreWeight     : integer; // new item

   //-------------------------------------------------------------------
   // latest date of schedule allowed

    m_AllowedLatestDateLimit : integer; // 0 = n/A , 1= start, 2 = end
    m_AllowedDatelimitType : integer;   // 0 = specific date, 1 = number of days from current date, 2 = number of days from "start schedule from"
    m_LatestDateScheduleNbrOfDays : integer;
    m_LatestDateSchedule : TDate;

    // Others
    m_Sleep               : integer; // m_Sleep
    m_GraphOnMove         : boolean; // m_GraphOnMove
    m_NowDateTime         : TDateTime;
    m_ScheduleDateLimitDate : TDate;
    m_NowDate             : TDateTime;
    m_AutoSeq_LowestScore : double;
    m_AutoSeq_LowestScoreDate : TDateTime;
    m_AutoSeq_LowestScoreRes  : string;
    m_AutoSeq_SingleJob   : boolean;
    m_LoadedResource      : boolean;
    m_LoadedOnSameResCat  : boolean;
    m_LimitGapBtwnSubSteps : string;
    m_ToleranceDaysGapBtwnSubSteps : integer;
    m_ToleranceHoursGapBtwnSubSteps : integer;
    m_ToleranceMinGapBtwnSubSteps : integer;
    m_TestPosAfterLastBrother : boolean;
    m_LastCheckedRequest    : string;
    m_LastCheckedStep       : integer;
    m_LastCheckedQty        : double;
    m_LastCheckedID         : TSchedId;
    m_LastSchedID           : TSchedId;
    m_LastSchedRes          : pointer;
    m_FoundPosNextLastSched : boolean;
    m_SortBeforeSchedule    : boolean;
    m_MatListBuilt          : boolean;
    m_TempMatListStart      : TList;
    m_TempMatListEnd        : TList;
    m_TempAddResListStart   : TList;
    m_TempAddResListEnd     : TList;
    m_TempAddResNeededTillEndExec : TList;
    m_CatResList            : TStringList;
    m_ListOfScoreAdditional : TList;
    m_ListOfJobToJobDefinitions : TList;
    m_CreateLog           : boolean;
    m_LogLocation         : string;
    m_runOrganizeGenericPlanFirst : boolean;

    m_HoursToleranceOfGapBetweenJobs : Integer;
    m_PenaltyScoreWithinTolerance : double;
    m_PenaltyScoreAfterTolerance : double;
    m_IgnoreRightOverlapping : Integer;
    m_IgnoreLeftOverlapping  : Integer;
    m_RescheduleErlierJobsWhenTolerance : boolean;
    m_AllServingGroupJobsSamePlant : boolean;
    m_CalendarForDatesPenalty      : string;

    m_FieldsArray : array [0..High(BinColDefault)] of TBinColCurrent;
    m_FieldArrayForSort : array [1..5] of TBinColCurrent;


    // Overriding Params
    m_ScheduleByWorkCenterCfg : boolean;
    m_AllowedMoveLinkedReq    : boolean;

    m_OverridingParams_Activated : boolean;
    m_OverridingParams_InfiniteCapacityAllowed : boolean;
    m_OverridingParams_UnscheduleBefore : boolean;

    m_OverridingParams_Wc_Selected : boolean;
    m_OverridingParams_Wc_Code_Selected : string;

    m_OverridingParams_WcDateTimeFrom        : TDateTime;
    m_OverridingParams_WcDateTimeTo          : TDateTime;

    m_OverridingParams_ScheduleJobsWithinTheFram : boolean;
    m_OverridingParams_ShorterJobsCanEndAfterFramEnd  : boolean;
    m_OverridingParams_LargerJobsCanStartAfterTheFrameBegins : boolean;

    m_OverridingParams_BeforeLowLimit        : Integer;
    m_OverridingParams_TollBeforeLowLimit    : Integer;
    m_OverridingParams_TollBeforeLowLimitHours  : Integer;
    m_OverridingParams_TollBeforeLowLimitMinutes : Integer;

    m_OverridingParams_AfterHighLimit        : Integer;
    m_OverridingParams_TollAfterHighLimit    : Integer;
    m_OverridingParams_TollAfterHighLimitHours  : Integer;
    m_OverridingParams_TollAfterHighLimitMinutes : Integer;

    m_OverridingParams_MatWOMaterials            : integer;
    m_OverridingParams_MatWOAddRes               : integer;

    m_OverridingParams_IgnoreRightOverlapping    : integer;
    m_OverridingParams_IgnoreLeftOverlapping     : integer;

    m_OverridingParams_MatWOMaterials_Family     : integer;
    m_OverridingParams_MatWOAddRes_Family        : integer;
    m_OverridingParams_ScheduleByWorkCenterCfg   : boolean;
    m_OverridingParams_AllowedMoveLinkedReq      : boolean;

    m_PushToThePreferedDateMode                  : boolean;
    m_FindFirstFreeInifiniteCapacityResource     : boolean;
    m_AutoRunFixedDateTime : TDateTime;

    m_SlotGroup : Integer;
    m_GroupName : String;

  end;
  PTAutoSchedCfg = ^TAutoSchedCfg;

  procedure SaveAutoSchedCfgToDB;
  procedure LoadAutoSchedCfgFromDB(ProgBar: TMqmProgBar; Status: TStaticText);
  procedure SetAsActiveCfg(Cfg: PTAutoSchedCfg);
  function  GetAutoSchedCfg(CfgName: string): PTAutoSchedCfg;
  function  GetAllAutoSchedCfgList: TStringList;
  procedure AddNewCfg(Cfg: PTAutoSchedCfg);
  procedure EreaseCfg(Cfg: PTAutoSchedCfg);
  procedure SetDefaultAutoSchedCfg(Cfg: PTAutoSchedCfg);
  function BeforeLowTolerance(Cfg: PTAutoSchedCfg): double;
  function AfterHighTolerance(Cfg: PTAutoSchedCfg): double;
  procedure LoadScoreAdditionalFromDB(List : TList; AutoCfgName : string);
  procedure LoadSpecificDateTimeFromDB(AutoCfgName : string);
  procedure LoadJobToJobDefinitionsFromDB(List : TList; AutoCfgName : string);
  function GetStrReqForJobId(Id : TSchedId) : string;
  procedure SetAutoSchedParams(CurrentAutoSchedCfg : PTAutoSchedCfg; OverrideAll : boolean);
  procedure RestoreAutoSeqParms(SavedAutoSchedCfg : PTAutoSchedCfg);
  function GetGetNextAutoSchedCfgByGroup(CfgNameList : TStringList; CfgGroup : string): PTAutoSchedCfg;
  procedure SetOverrideParams;
  procedure SetParamsFromOverride(SaveCurrCfg : TAutoSchedCfg);

var
  AutoSchedCfg: PTAutoSchedCfg;
  AutoSchedCfgList: Tlist;

const

// --- NEW - START

  // TabSheet Preferences
  DFT_PrefTgtDate         = 2;    //  m_PrefTgtDate
  DFT_MoveObjsAllowed     = 3;  // m_MoveObjsAllowed
  DFT_MoveFinalObjsAlwd   = 0; // m_MoveFinalObjsAlwd
  DFT_MoveInitialObjsAlwd = 0; // m_MoveInitialObjsAlwd
  DFT_MoveLevel1Alwd      = 0; // m_MoveLevel1ObjsAlwd
  DFT_MoveLevel2Alwd      = 0; // m_MoveLevel2ObjsAlwd
  DFT_MoveLevel3Alwd      = 0; // m_MoveLevel3ObjsAlwd
  DFT_MoveLevel4Alwd      = 0; // m_MoveLevel4ObjsAlwd
  DFT_MoveLevel5Alwd      = 0; // m_MoveLevel5ObjsAlwd
  DFT_MinDateOffset       = 0; // m_MinStartDateOffset
  DFT_TempFinal           = 0; // m_TempFinal
  DFT_RankRep             = false; // m_RankRep
  DFT_StopOnFirstNotSchedJob = false;
  DFT_PriorErrLoop        = true; // m_PriorErrLoop
//  DFT_OneRequestAtTime    = false; //  m_OneRequestAtTime
  DFT_SplitSchedByBatchSize = ByMachinesOptimum;
  DFT_CreteriaOfResBachSize = AnyResource;
  DFT_LastSplitCanGoUnderMin = false;
  DFT_LimitGapBtwnSubSteps   = '0';

  // TabSheet Requirements
  DFT_MatWOMaterials      = 0; //  m_MatWOMaterials
  DFT_MatWOAddRes         = 0; //  m_MatWOAddRes

  // TabSheet Schedule limits
  DFT_MinJobResComp       = 98; // m_MinJobResComp
  DFT_MinJobJobComp       = 0; // m_MinJobJobComp
  DFT_MaxJobJobComp       = 98; // m_MinJobJobComp
  DFT_MinJobCapResComp    = 98; // m_MinJobCapResComp
  DFT_BeforeLowLimit      = 0; // m_BeforeLowLimit
  DFT_TollBeforeLowLimit        = 0;
  DFT_TollBeforeLowLimitHours   = 0;
  DFT_TollBeforeLowLimitMinutes = 0;
  DFT_AfterHighLimit      = 0; // m_AfterHighLimit
  DFT_TollAfterHighLimit        = 0;
  DFT_TollAfterHighLimitHours   = 0;
  DFT_TollAfterHighLimitMinutes = 0;
  DFT_ToleranceDaysGapBtwnSubSteps  = 0;
  DFT_ToleranceHoursGapBtwnSubSteps = 0;
  DFT_ToleranceMinGapBtwnSubSteps   = 0;

  // TabSheet Schedule Score
  DFT_BeforeEarlDateTol   = 20.0; //  m_BeforeEarlDateTol
  DFT_WithinEarlDateTol   = 0.0; //   m_WithinEarlDateTol
  DFT_PenaltyScoreWithinTolerance   = 0.0;
  DFT_PenaltyScoreAfterTolerance    = 0.0;

  DFT_HoursToleranceOfGapBetweenJobs = 0;
  DFT_IgnoreRightOverlapping = 1;
  DFT_IgnoreLeftOverlapping  = 1;
  DFT_RescheduleErlierJobsWhenTolerance = false;
  DFT_AllServingGroupJobsSamePlant = false;

  DFT_AfterLatestDateTol  = 30.0; //  m_AfterLatestDateTol
  DFT_WithinLatestDateTol = 0.0; //  m_WithinLatestDateTol
  DFT_ScheduleToPossibleStartPenalty = 0.0; //  m_ScheduleToPossibleStartPenalty
  DFT_PenCompJobToJob     = 0.0; //      m_PenCompJobToJob
  DFT_PenCompSetupMinutes = 0.0; //  m_PenCompSetupMinutes
  DFT_PenCompJobToRes     = 0.0; //      m_PenCompJobToRes
  DFT_PenCompJobToCapRes  = 0.0; //   m_PenCompJobToCapRes
  DFT_PenCompJobNotCapRes = 0.0; // m_PenCompJobNotCapRes
  DFT_DateScoreWeight     = 80; //   m_DateScoreWeight
  DFT_CompScoreWeight     = 20; //   m_CompScoreWeight

  // TabSheet Others
  DFT_Sleep               = 0; // m_Sleep
  DFT_GraphOnMove         = false; // m_GraphOnMove

implementation

uses
  gnugettext,
  DMSrvPC,
  UMTblDesc, UMRes, UMObjCont, SysUtils,
  UMGlobal, DB;

//----------------------------------------------------------------------------//

procedure SetDefaultAutoSchedCfg(Cfg: PTAutoSchedCfg);
begin
  cfg.m_CfgName       := 'DEFAULT';
  cfg.m_CfgDesc       := _('Default configuration');

// --- NEW - START

  // TabSheet Preferences
  cfg.m_PrefTgtDate         := DFT_PrefTgtDate;
  cfg.m_MoveObjsAllowed     := DFT_MoveObjsAllowed;
  cfg.m_MoveFinalObjsAlwd   := DFT_MoveFinalObjsAlwd;
  cfg.m_MoveInitialObjsAlwd := DFT_MoveInitialObjsAlwd;
  cfg.m_MoveLevel1ObjsAlwd  := DFT_MoveLevel1Alwd;
  cfg.m_MoveLevel2ObjsAlwd  := DFT_MoveLevel2Alwd;
  cfg.m_MoveLevel3ObjsAlwd  := DFT_MoveLevel3Alwd;
  cfg.m_MoveLevel4ObjsAlwd  := DFT_MoveLevel4Alwd;
  cfg.m_MoveLevel5ObjsAlwd  := DFT_MoveLevel5Alwd;
  cfg.m_MinStartDateOffset  := DFT_MinDateOffset;
  cfg.m_TempFinal           := DFT_TempFinal;
  cfg.m_RankRep             := DFT_RankRep;
  cfg.m_PriorErrLoop        := DFT_PriorErrLoop;
//  cfg.m_OneRequestAtTime    := DFT_OneRequestAtTime;
  cfg.m_SplitSchedByBatchSize := DFT_SplitSchedByBatchSize;
  cfg.m_CreteriaOfResForBachZise := DFT_CreteriaOfResBachSize;
  cfg.m_LastSplitCanGoUnderMin := DFT_LastSplitCanGoUnderMin;
  cfg.m_LimitGapBtwnSubSteps   := DFT_LimitGapBtwnSubSteps;

  // TabSheet Requirements
  cfg.m_MatWOMaterials      := DFT_MatWOMaterials;
  cfg.m_MatWOAddRes         := DFT_MatWOAddRes;

  // TabSheet Schedule limits
  cfg.m_MinJobResComp       := DFT_MinJobResComp;
  cfg.m_MinJobJobComp       := DFT_MinJobJobComp;
  cfg.m_MaxJobJobComp       := DFT_MaxJobJobComp;
  cfg.m_MinJobCapResComp    := DFT_MinJobCapResComp;
  cfg.m_BeforeLowLimit      := DFT_BeforeLowLimit;
  cfg.m_TollBeforeLowLimit        := DFT_TollBeforeLowLimit;
  cfg.m_TollBeforeLowLimitHours   := DFT_TollBeforeLowLimitHours;
  cfg.m_TollBeforeLowLimitMinutes := DFT_TollBeforeLowLimitMinutes;
  cfg.m_AfterHighLimit      := DFT_AfterHighLimit;
  cfg.m_TollAfterHighLimit        := DFT_TollAfterHighLimit;
  cfg.m_TollAfterHighLimitHours   := DFT_TollAfterHighLimitHours;
  cfg.m_TollAfterHighLimitMinutes := DFT_TollAfterHighLimitMinutes;

  // TabSheet Schedule Score
  cfg.m_BeforeEarlDateTol   := DFT_BeforeEarlDateTol;
  cfg.m_WithinEarlDateTol   := DFT_WithinEarlDateTol;
  cfg.m_AfterLatestDateTol  := DFT_AfterLatestDateTol;
  cfg.m_WithinLatestDateTol := DFT_WithinLatestDateTol;
  cfg.m_ScheduleToPossibleStartPenalty := DFT_ScheduleToPossibleStartPenalty;
  cfg.m_PenCompJobToJob     := DFT_PenCompJobToJob;
  cfg.m_PenCompSetupMinutes := DFT_PenCompSetupMinutes;
  cfg.m_PenCompJobToRes     := DFT_PenCompJobToRes;
  cfg.m_PenCompJobToCapRes  := DFT_PenCompJobToCapRes;
  cfg.m_PenCompJobNotCapRes := DFT_PenCompJobNotCapRes;
  cfg.m_DateScoreWeight     := DFT_DateScoreWeight;
  cfg.m_CompScoreWeight     := DFT_CompScoreWeight;
  cfg.m_PenaltyScoreAfterTolerance := DFT_PenaltyScoreAfterTolerance;

  // Others
  cfg.m_Sleep               := DFT_Sleep;
  cfg.m_GraphOnMove         := DFT_GraphOnMove;
  cfg.m_FieldArrayForSort[1].Field := CSC_NotSorted;
  cfg.m_FieldArrayForSort[2].Field := CSC_NotSorted;
  cfg.m_FieldArrayForSort[3].Field := CSC_NotSorted;
  cfg.m_FieldArrayForSort[4].Field := CSC_NotSorted;
  cfg.m_FieldArrayForSort[5].Field := CSC_NotSorted;

  cfg.m_ToleranceDaysGapBtwnSubSteps  := DFT_ToleranceDaysGapBtwnSubSteps;
  cfg.m_ToleranceHoursGapBtwnSubSteps := DFT_ToleranceHoursGapBtwnSubSteps;
  cfg.m_ToleranceMinGapBtwnSubSteps   := DFT_ToleranceMinGapBtwnSubSteps;

//  cfg.m_OnlySelectedJobAuto := false;
  cfg.m_runOrganizeGenericPlanFirst := false;
  cfg.m_HoursToleranceOfGapBetweenJobs := DFT_HoursToleranceOfGapBetweenJobs;

  cfg.m_IgnoreRightOverlapping := DFT_IgnoreRightOverlapping;
  cfg.m_IgnoreLeftOverlapping  := DFT_IgnoreLeftOverlapping;
  cfg.m_RescheduleErlierJobsWhenTolerance := DFT_RescheduleErlierJobsWhenTolerance;
  cfg.m_AllServingGroupJobsSamePlant := DFT_AllServingGroupJobsSamePlant;

  cfg.m_RunningMode := 1;
  cfg.m_StartSchedFrom := 0;
  cfg.m_SpecificDateTime := now;
  cfg.m_NumberOfDaysFromCurrentDate := 0;

  cfg.m_AllowedLatestDateLimit := 0;
  cfg.m_AllowedDatelimitType := 1;
  cfg.m_LatestDateScheduleNbrOfDays := 0;
  cfg.m_LatestDateSchedule := date;

  cfg.m_McmRescheduledJobs := false;
  cfg.m_McmRescheduledJobsAutoOnStart := false;
  cfg.m_WithoutStack                  := false;
  cfg.m_PrevOrNextLinkedJobIsTheTgtDateWhenScheduled := false;
  cfg.m_RankRep                       := false;
  cfg.m_PriorErrLoop                  := false;
  cfg.m_LastSplitCanGoUnderMin        := false;
  cfg.m_StopOnFirstNotSchedJob        := false;

  cfg.m_AllowSchedBeforeNoneConfLevl  := false;
  cfg.m_GraphOnMove                   := false;
  cfg.m_AutoSeq_SingleJob             := false;
  cfg.m_LoadedResource                := false;
  cfg.m_LoadedOnSameResCat            := false;
  cfg.m_TestPosAfterLastBrother       := false;
  cfg.m_FoundPosNextLastSched         := false;
  cfg.m_SortBeforeSchedule            := false;
  cfg.m_MatListBuilt                  := false;
  cfg.m_CreateLog                     := false;
  cfg.m_runOrganizeGenericPlanFirst   := false;
  cfg.m_RescheduleErlierJobsWhenTolerance := false;
  cfg.m_AllServingGroupJobsSamePlant  := false;
  cfg.m_ScheduleByWorkCenterCfg       := false;
  cfg.m_AllowedMoveLinkedReq          := false;

  cfg.m_OverridingParams_Activated    := false;
  cfg.m_OverridingParams_InfiniteCapacityAllowed := false;
  cfg.m_OverridingParams_UnscheduleBefore := false;
  cfg.m_OverridingParams_Wc_Selected  := false;
  cfg.m_OverridingParams_ScheduleJobsWithinTheFram := false;
  cfg.m_OverridingParams_ShorterJobsCanEndAfterFramEnd := false;
  cfg.m_OverridingParams_LargerJobsCanStartAfterTheFrameBegins := false;
  cfg.m_OverridingParams_ScheduleByWorkCenterCfg   := false;
  cfg.m_OverridingParams_AllowedMoveLinkedReq      := false;
  cfg.m_PushToThePreferedDateMode                  := false;
  cfg.m_FindFirstFreeInifiniteCapacityResource     := false;

end;

//----------------------------------------------------------------------------//

procedure LoadAutoSchedCfgFromDB(ProgBar: TMqmProgBar; Status: TStaticText);
var
  tbInfo: ^TTblInfo;
  qry :  TMqmQuery;
  TempCfg: PTAutoSchedCfg;
begin
  qry := CreateQuery(Cfg_DB);
  tbInfo := @tblInfo[tbl_cfg_AutoSched];

  if Assigned(Status) then
    Status.Caption := _('Loading Auto scheduling configuration...');
  Application.ProcessMessages;

  with qry do
  begin
    SQL.Clear;
    SQL.Add('Select * from ' + tbInfo.GetTableName + ' Where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + ' = ''' +  IniAppGlobals.WkstCode + '''');
    SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
    Open;

    if EOF then
    begin
      new(TempCfg);
      SetDefaultAutoSchedCfg(TempCfg);
      AutoSchedCfgList.Add(TempCfg);
      SetAsActiveCfg(TempCfg)
    end;

    while not EOF do
    begin
      new(TempCfg);
      SetDefaultAutoSchedCfg(TempCfg);
      TempCfg.m_CfgName       := FieldByName(CreateFld(tbInfo.pfx, fli_CfgName)).AsString;
      TempCfg.m_CfgNameNext   := FieldByName(CreateFld(tbInfo.pfx, fli_CfgNextName)).AsString;
      TempCfg.m_CfgDesc       := FieldByName(CreateFld(tbInfo.pfx, fli_CfgDesc)).AsString;
      TempCfg.m_CfgGroup      := FieldByName(CreateFld(tbInfo.pfx, fli_CfgGroup)).AsString;
      if FieldByName(CreateFld(tbInfo.pfx, fli_AutoSeq_RunningMode)).AsString = '1' then
        TempCfg.m_RunningMode := 1
      else
        TempCfg.m_RunningMode := 0;

      if FieldByName(CreateFld(tbInfo.pfx, fli_StartSchedFrom)).AsString = '0' then
        TempCfg.m_StartSchedFrom := 0
      else if FieldByName(CreateFld(tbInfo.pfx, fli_StartSchedFrom)).AsString = '1' then
        TempCfg.m_StartSchedFrom := 1
      else if FieldByName(CreateFld(tbInfo.pfx, fli_StartSchedFrom)).AsString = '2' then
        TempCfg.m_StartSchedFrom := 2
      else
        TempCfg.m_StartSchedFrom := 0;

      TempCfg.m_SpecificDateTime := FieldByName(CreateFld(tbInfo.pfx, fli_StartSched_SpecificDateTime)).AsDateTime;
      if TempCfg.m_SpecificDateTime = 0 then
         TempCfg.m_SpecificDateTime := now;

      TempCfg.m_NumberOfDaysFromCurrentDate := FieldByName(CreateFld(tbInfo.pfx, fli_StartSched_NumberOfDaysFromCurrentDate)).AsInteger;

      TempCfg.m_MinJobResComp := FieldByName(CreateFld(tbInfo.pfx, fli_MinJobResComp)).AsInteger;
      TempCfg.m_MinJobJobComp := FieldByName(CreateFld(tbInfo.pfx, fli_MinJobJobComp)).AsInteger;
      TempCfg.m_MaxJobJobComp := FieldByName(CreateFld(tbInfo.pfx, fli_MaxJobJobComp)).AsInteger;
      TempCfg.m_MinJobCapResComp := FieldByName(CreateFld(tbInfo.pfx, fli_MinJobCapResComp)).AsInteger;
      if FieldByName(CreateFld(tbInfo.pfx, fli_AllowSchedBeforeNoneConfLevl)).AsString = '1' then
        TempCfg.m_AllowSchedBeforeNoneConfLevl := true
      else
        TempCfg.m_AllowSchedBeforeNoneConfLevl := false;

      TempCfg.m_AfterHighLimit := FieldByName(CreateFld(tbInfo.pfx, fli_AfterHighLimit)).AsInteger;
      TempCfg.m_TollAfterHighLimit := FieldByName(CreateFld(tbInfo.pfx, fli_TollAfterHighLimit)).AsInteger;
      TempCfg.m_TollAfterHighLimitHours := FieldByName(CreateFld(tbInfo.pfx, fli_TollAfterHighLimitHours)).AsInteger;
      TempCfg.m_TollAfterHighLimitMinutes := FieldByName(CreateFld(tbInfo.pfx, fli_TollAfterHighLimitMinutes)).AsInteger;
      TempCfg.m_BeforeLowLimit := FieldByName(CreateFld(tbInfo.pfx, fli_BeforeLowLimit)).AsInteger;
      TempCfg.m_TollBeforeLowLimit := FieldByName(CreateFld(tbInfo.pfx, fli_TollBeforeLowLimit)).AsInteger;
      TempCfg.m_TollBeforeLowLimitHours := FieldByName(CreateFld(tbInfo.pfx, fli_TollBeforeLowLimitHours)).AsInteger;
      TempCfg.m_TollBeforeLowLimitMinutes := FieldByName(CreateFld(tbInfo.pfx, fli_TollBeforeLowLimitMinutes)).AsInteger;
      TempCfg.m_PrefTgtDate := FieldByName(CreateFld(tbInfo.pfx, fli_PrefTgtDate)).AsInteger;
      TempCfg.m_PrevOrNextLinkedJobIsTheTgtDateWhenScheduled := false;
      if FieldByName(CreateFld(tbInfo.pfx, fli_PrevOrNextLinkedJobIsTheTgtDateWhenScheduled)).AsString = '1' then
        TempCfg.m_PrevOrNextLinkedJobIsTheTgtDateWhenScheduled := true;
      TempCfg.m_MoveObjsAllowed := FieldByName(CreateFld(tbInfo.pfx, fli_MoveObjsAllowed)).AsInteger;
      TempCfg.m_MoveFinalObjsAlwd := FieldByName(CreateFld(tbInfo.pfx, fli_MoveFinalObjsAlwd)).AsInteger;
      TempCfg.m_MoveInitialObjsAlwd := FieldByName(CreateFld(tbInfo.pfx, fli_MoveInitialObjsAlwd)).AsInteger;
      TempCfg.m_MoveLevel1ObjsAlwd := FieldByName(CreateFld(tbInfo.pfx, fli_MoveLevel1ObjsAlwd)).AsInteger;
      TempCfg.m_MoveLevel2ObjsAlwd := FieldByName(CreateFld(tbInfo.pfx, fli_MoveLevel2ObjsAlwd)).AsInteger;
      TempCfg.m_MoveLevel3ObjsAlwd := FieldByName(CreateFld(tbInfo.pfx, fli_MoveLevel3ObjsAlwd)).AsInteger;
      TempCfg.m_MoveLevel4ObjsAlwd := FieldByName(CreateFld(tbInfo.pfx, fli_MoveLevel4ObjsAlwd)).AsInteger;
      TempCfg.m_MoveLevel5ObjsAlwd := FieldByName(CreateFld(tbInfo.pfx, fli_MoveLevel5ObjsAlwd)).AsInteger;
      TempCfg.m_MinStartDateOffset := FieldByName(CreateFld(tbInfo.pfx, fli_MinStartDateOffset)).AsInteger;
      if FieldByName(CreateFld(tbInfo.pfx, fli_PriorErrLoop)).AsString = '1'  then
        TempCfg.m_PriorErrLoop := true
      else
        TempCfg.m_PriorErrLoop := false;
      TempCfg.m_TempFinal := FieldByName(CreateFld(tbInfo.pfx, fli_TempFinal)).AsInteger;
      TempCfg.m_Sleep := FieldByName(CreateFld(tbInfo.pfx, fli_Sleep)).AsInteger;
      if FieldByName(CreateFld(tbInfo.pfx, fli_RankRep)).AsString = '1'  then
        TempCfg.m_RankRep := true
      else
        TempCfg.m_RankRep := false;

      TempCfg.m_MatWOMaterials := FieldByName(CreateFld(tbInfo.pfx, fli_MatWOMaterials)).AsInteger;
                               ;
      TempCfg.m_SplitSchedByBatchSize := ByMachinesOptimum;
      if (FieldByName(CreateFld(tbInfo.pfx, fli_AutoSplitByStdBtchSize)).AsInteger = 0) then
        TempCfg.m_SplitSchedByBatchSize := ByMachinesOptimum
      else if (FieldByName(CreateFld(tbInfo.pfx, fli_AutoSplitByStdBtchSize)).AsInteger = 1) then
        TempCfg.m_SplitSchedByBatchSize := ByEqualQuantity
      else if (FieldByName(CreateFld(tbInfo.pfx, fli_AutoSplitByStdBtchSize)).AsInteger = 2) then
        TempCfg.m_SplitSchedByBatchSize := BalancingAll
      else if (FieldByName(CreateFld(tbInfo.pfx, fli_AutoSplitByStdBtchSize)).AsInteger = 3) then
        TempCfg.m_SplitSchedByBatchSize := DailyProductionAndJoin
      else if (FieldByName(CreateFld(tbInfo.pfx, fli_AutoSplitByStdBtchSize)).AsInteger = 4) then
        TempCfg.m_SplitSchedByBatchSize := ByMachinesOptimumForceSplit
      else if (FieldByName(CreateFld(tbInfo.pfx, fli_AutoSplitByStdBtchSize)).AsInteger = 5) then
        TempCfg.m_SplitSchedByBatchSize := LongestDurationPossible;

      if (FieldByName(CreateFld(tbInfo.pfx, fli_CreteriaOfResForBachZise)).AsInteger = 1) then
        TempCfg.m_CreteriaOfResForBachZise := OnlySameSize
      else if (FieldByName(CreateFld(tbInfo.pfx, fli_CreteriaOfResForBachZise)).AsInteger = 2) then
        TempCfg.m_CreteriaOfResForBachZise := SameSizeExcpetSmallesBatch
      else TempCfg.m_CreteriaOfResForBachZise := AnyResource;

      if (FieldByName(CreateFld(tbInfo.pfx, fli_LastSplitCanGoUnderMinMac)).AsInteger = 1) then
        TempCfg.m_LastSplitCanGoUnderMin := true
      else
        TempCfg.m_LastSplitCanGoUnderMin := false;

      TempCfg.m_MatWOAddRes := FieldByName(CreateFld(tbInfo.pfx, fli_MatWOAddRes)).AsInteger;
      if FieldByName(CreateFld(tbInfo.pfx, fli_GraphOnMove)).AsString = '1'  then
        TempCfg.m_GraphOnMove := true
      else
        TempCfg.m_GraphOnMove := false;

      if FieldByName(CreateFld(tbInfo.pfx, fli_LatestDateLimit)).AsString = '0' then
        TempCfg.m_AllowedLatestDateLimit := 0
      else if FieldByName(CreateFld(tbInfo.pfx, fli_LatestDateLimit)).AsString = '1' then
        TempCfg.m_AllowedLatestDateLimit := 1
      else if FieldByName(CreateFld(tbInfo.pfx, fli_LatestDateLimit)).AsString = '2' then
        TempCfg.m_AllowedLatestDateLimit := 2
      else
        TempCfg.m_AllowedLatestDateLimit := 0;

      if FieldByName(CreateFld(tbInfo.pfx, fli_DateLimitType)).AsString = '0' then
        TempCfg.m_AllowedDatelimittype := 0
      else if FieldByName(CreateFld(tbInfo.pfx, fli_DateLimitType)).AsString = '1' then
        TempCfg.m_AllowedDatelimittype := 1
      else if FieldByName(CreateFld(tbInfo.pfx, fli_DateLimitType)).AsString = '2' then
        TempCfg.m_AllowedDatelimittype := 2
      else
        TempCfg.m_AllowedDatelimittype := 1;

      TempCfg.m_LatestDateScheduleNbrOfDays := FieldByName(CreateFld(tbInfo.pfx, fli_NumberOfdaysFromStartingPoint)).AsInteger;
      TempCfg.m_LatestDateSchedule := FieldByName(CreateFld(tbInfo.pfx, fli_DateFromStartPointAllowed)).AsDateTime;

      // NewFields
      TempCfg.m_BeforeEarlDateTol := FieldByName(CreateFld(tbInfo.pfx, fli_BefEarlDateTol)).AsFloat;
      TempCfg.m_WithinEarlDateTol := FieldByName(CreateFld(tbInfo.pfx, fli_WithEarlDateTol)).AsFloat;
      TempCfg.m_AfterLatestDateTol := FieldByName(CreateFld(tbInfo.pfx, fli_AfterLatDateTol)).AsFloat;
      TempCfg.m_WithinLatestDateTol := FieldByName(CreateFld(tbInfo.pfx, fli_WithLatDateTol)).AsFloat;
      TempCfg.m_ScheduleToPossibleStartPenalty := FieldByName(CreateFld(tbInfo.pfx, fli_ScheduleToPossibleStartPenalty)).AsFloat;
      TempCfg.m_PenCompJobToJob := FieldByName(CreateFld(tbInfo.pfx, fli_PenJobToJob)).AsFloat;
      TempCfg.m_PenCompSetupMinutes := FieldByName(CreateFld(tbInfo.pfx, fli_PenSetupMin)).AsFloat;
      TempCfg.m_PenCompJobToRes := FieldByName(CreateFld(tbInfo.pfx, fli_PenJobToRes)).AsFloat;
      TempCfg.m_PenCompJobToCapRes := FieldByName(CreateFld(tbInfo.pfx, fli_PenJobToCapRes)).AsFloat;
      TempCfg.m_PenCompJobNotCapRes := FieldByName(CreateFld(tbInfo.pfx, fli_PenJobNotCapRes)).AsFloat;
      TempCfg.m_DateScoreWeight := FieldByName(CreateFld(tbInfo.pfx, fli_DateScoreWeight)).AsInteger;
      TempCfg.m_CompScoreWeight := FieldByName(CreateFld(tbInfo.pfx, fli_CompScoreWeight)).AsInteger;

      if FieldByName(CreateFld(tbInfo.pfx, fli_LoadedResource)).AsString = '1' then
        TempCfg.m_LoadedResource := true
      else
        TempCfg.m_LoadedResource := false;

      if FieldByName(CreateFld(tbInfo.pfx, fli_LoadedOnSameResCat)).AsString = '1' then
        TempCfg.m_LoadedOnSameResCat := true
      else
        TempCfg.m_LoadedOnSameResCat := false;

      if FieldByName(CreateFld(tbInfo.pfx, fli_StopOnFirstNotSchedJob)).AsString = '1' then
        TempCfg.m_StopOnFirstNotSchedJob := true
      else
        TempCfg.m_StopOnFirstNotSchedJob := false;

      if FieldByName(CreateFld(tbInfo.pfx, fli_SortBeforeSchedule)).AsString = '1' then
        TempCfg.m_SortBeforeSchedule := true
      else
        TempCfg.m_SortBeforeSchedule := false;

      if FieldByName(CreateFld(tbInfo.pfx, fli_LimitGapBtwnSubSteps)).AsString = '1' then
        TempCfg.m_LimitGapBtwnSubSteps := '1'
      else
        TempCfg.m_LimitGapBtwnSubSteps := '0';

      TempCfg.m_ToleranceDaysGapBtwnSubSteps  := FieldByName(CreateFld(tbInfo.pfx, fli_ToleranceDaysGapBtwnSubSteps)).AsInteger;
      TempCfg.m_ToleranceHoursGapBtwnSubSteps := FieldByName(CreateFld(tbInfo.pfx, fli_ToleranceHoursGapBtwnSubSteps)).AsInteger;
      TempCfg.m_ToleranceMinGapBtwnSubSteps   := FieldByName(CreateFld(tbInfo.pfx, fli_ToleranceMinGapBtwnSubSteps)).AsInteger;

      TempCfg.m_HoursToleranceOfGapBetweenJobs := FieldByName(CreateFld(tbInfo.pfx, fli_HoursToleranceOfGapBetweenJobs)).AsInteger;
      TempCfg.m_RescheduleErlierJobsWhenTolerance := false;
      if FieldByName(CreateFld(tbInfo.pfx, fli_RescheduleErlierJobsWhenTolerance)).AsString = '1' then
        TempCfg.m_RescheduleErlierJobsWhenTolerance := true;

      TempCfg.m_AllServingGroupJobsSamePlant := false;
      if FieldByName(CreateFld(tbInfo.pfx, fli_ForceSameWcPlantToServingGroup)).AsString = '1' then
        TempCfg.m_AllServingGroupJobsSamePlant := true;

      TempCfg.m_CalendarForDatesPenalty := trim(FieldByName(CreateFld(tbInfo.pfx, fli_CalendarForDatesPenalty)).AsString);

      TempCfg.m_PenaltyScoreWithinTolerance := FieldByName(CreateFld(tbInfo.pfx, fli_PenaltyScoreWithinTolerance)).AsFloat;
      TempCfg.m_PenaltyScoreAfterTolerance := FieldByName(CreateFld(tbInfo.pfx, fli_PenaltyScoreAfterTolerance)).AsFloat;
      TempCfg.m_IgnoreRightOverlapping := FieldByName(CreateFld(tbInfo.pfx, fli_IgnoreRightOverlapping)).AsInteger;
      TempCfg.m_IgnoreLeftOverlapping := FieldByName(CreateFld(tbInfo.pfx, fli_IgnoreLeftOverlapping)).AsInteger;

      if FieldByName(CreateFld(tbInfo.pfx, fli_BinColField1)).IsNull or (FieldByName(CreateFld(tbInfo.pfx, fli_BinColField1)).AsInteger = -1) then
        TempCfg.m_FieldArrayForSort[1].Field := CSC_NotSorted
      else if FieldByName(CreateFld(tbInfo.pfx, fli_BinColField1)).AsInteger = 1000 then
        TempCfg.m_FieldArrayForSort[1].Field := CSC_Overlapping
      else
      begin
        TempCfg.m_FieldArrayForSort[1].Field := BinColDefault[FieldByName(CreateFld(tbInfo.pfx, fli_BinColField1)).AsInteger].Field;
        TempCfg.m_FieldArrayForSort[1].Pos := BinColDefault[FieldByName(CreateFld(tbInfo.pfx, fli_BinColField1)).AsInteger].pos;
      end;

      if FieldByName(CreateFld(tbInfo.pfx, fli_BinColField2)).IsNull or (FieldByName(CreateFld(tbInfo.pfx, fli_BinColField2)).AsInteger = -1) then
        TempCfg.m_FieldArrayForSort[2].Field := CSC_NotSorted
      else if FieldByName(CreateFld(tbInfo.pfx, fli_BinColField2)).AsInteger = 1000 then
        TempCfg.m_FieldArrayForSort[2].Field := CSC_Overlapping
      else
      begin
        TempCfg.m_FieldArrayForSort[2].Field := BinColDefault[FieldByName(CreateFld(tbInfo.pfx, fli_BinColField2)).AsInteger].Field;
        TempCfg.m_FieldArrayForSort[2].Pos := BinColDefault[FieldByName(CreateFld(tbInfo.pfx, fli_BinColField2)).AsInteger].Pos ;
      end;

      if FieldByName(CreateFld(tbInfo.pfx, fli_BinColField3)).IsNull or(FieldByName(CreateFld(tbInfo.pfx, fli_BinColField3)).AsInteger = -1) then
        TempCfg.m_FieldArrayForSort[3].Field := CSC_NotSorted
      else if FieldByName(CreateFld(tbInfo.pfx, fli_BinColField3)).AsInteger = 1000 then
        TempCfg.m_FieldArrayForSort[3].Field := CSC_Overlapping
      else
      begin
        TempCfg.m_FieldArrayForSort[3].Field := BinColDefault[FieldByName(CreateFld(tbInfo.pfx, fli_BinColField3)).AsInteger].Field;
        TempCfg.m_FieldArrayForSort[3].Pos := BinColDefault[FieldByName(CreateFld(tbInfo.pfx, fli_BinColField3)).AsInteger].Pos;
      end;

      if FieldByName(CreateFld(tbInfo.pfx, fli_BinColField4)).IsNull or (FieldByName(CreateFld(tbInfo.pfx, fli_BinColField4)).AsInteger = -1) then
        TempCfg.m_FieldArrayForSort[4].Field := CSC_NotSorted
      else if FieldByName(CreateFld(tbInfo.pfx, fli_BinColField4)).AsInteger = 1000 then
        TempCfg.m_FieldArrayForSort[4].Field := CSC_Overlapping
      else
      begin
        TempCfg.m_FieldArrayForSort[4].Field := BinColDefault[FieldByName(CreateFld(tbInfo.pfx, fli_BinColField4)).AsInteger].Field;
        TempCfg.m_FieldArrayForSort[4].Pos := BinColDefault[FieldByName(CreateFld(tbInfo.pfx, fli_BinColField4)).AsInteger].Pos;
      end;

      if FieldByName(CreateFld(tbInfo.pfx, fli_BinColField5)).IsNull or (FieldByName(CreateFld(tbInfo.pfx, fli_BinColField5)).AsInteger = -1) then
        TempCfg.m_FieldArrayForSort[5].Field := CSC_NotSorted
      else if FieldByName(CreateFld(tbInfo.pfx, fli_BinColField5)).AsInteger = 1000 then
        TempCfg.m_FieldArrayForSort[5].Field := CSC_Overlapping
      else
      begin
        TempCfg.m_FieldArrayForSort[5].Field := BinColDefault[FieldByName(CreateFld(tbInfo.pfx, fli_BinColField5)).AsInteger].Field;
        TempCfg.m_FieldArrayForSort[5].Pos := BinColDefault[FieldByName(CreateFld(tbInfo.pfx, fli_BinColField5)).AsInteger].Pos;
      end;
      TempCfg.m_OverridingParams_InfiniteCapacityAllowed := false;

      AutoSchedCfgList.Add(TempCfg);
      next
    end;

    Close;

  end;

  TempCfg := GetAutoSchedCfg(DBAppGlobals.ActAutoSched);
  if Assigned(TempCfg) then
    SetAsActiveCfg(TempCfg)
  else
  begin
    TempCfg := GetAutoSchedCfg('DEFAULT');
    SetAsActiveCfg(TempCfg);
  end;

  AutoSchedCfg.m_McmListOfRescheduledId := nil;
  AutoSchedCfg.m_McmRescheduledJobs     := false;
  AutoSchedCfg.m_McmRescheduledJobsAutoOnStart := false;

  qry.Free;
end;

//----------------------------------------------------------------------------//

procedure SaveAutoSchedCfgToDB;
var
  tbInfo: ^TTblInfo;
  qry :  TMqmQuery;
  SQLStrings: TStringList;
  TmpCfg: PTAutoSchedCfg;
  i, arraysize : integer;
begin
  if not DBAppGlobals.Change_AutoRunDefinition then exit;
  SQLStrings := TStringList.Create;
  qry := CreateQuery(Cfg_DB);
  Qry.Transaction := CreateTransaction(Cfg_DB);
  Qry.Transaction.StartTransaction;

  tbInfo := @tblInfo[tbl_cfg_AutoSched];

  with qry do
  begin
    SQL.Clear;
    SQL.Add('delete from ' + tbInfo.GetTableName + ' Where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + ' = ''' +  IniAppGlobals.WkstCode + '''');
    SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
    ExecSQL;
    Close;
  end;

  arraysize := -1;
  SQLStrings.Clear;

  SQLStrings.Add('insert into ' + tbInfo.GetTableName + '(');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_IDENTIFIER) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_wkstCode) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_CfgName) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_CfgNextName) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_CfgDesc) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_CfgGroup) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_AutoSeq_RunningMode) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_StartSchedFrom) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_StartSched_SpecificDateTime) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_StartSched_NumberOfDaysFromCurrentDate) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_MinJobResComp) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_MinJobJobComp) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_MaxJobJobComp) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_MinJobCapResComp) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_AllowSchedBeforeNoneConfLevl) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_AfterHighLimit) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_TollAfterHighLimit) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_TollAfterHighLimitHours) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_TollAfterHighLimitMinutes) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_BeforeLowLimit) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_TollBeforeLowLimit) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_TollBeforeLowLimitHours) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_TollBeforeLowLimitMinutes) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_PrefTgtDate) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_PrevOrNextLinkedJobIsTheTgtDateWhenScheduled) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_MoveObjsAllowed) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_MoveFinalObjsAlwd) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_MoveInitialObjsAlwd) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_MoveLevel1ObjsAlwd) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_MoveLevel2ObjsAlwd) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_MoveLevel3ObjsAlwd) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_MoveLevel4ObjsAlwd) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_MoveLevel5ObjsAlwd) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_MinStartDateOffset) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_PriorErrLoop) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_TempFinal) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_Sleep) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_RankRep) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_MatWOMaterials) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_AutoSplitByStdBtchSize) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_CreteriaOfResForBachZise) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_LastSplitCanGoUnderMinMac) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_MatWOAddRes) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_GraphOnMove) + ',');

  // New fields
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_BefEarlDateTol) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_WithEarlDateTol) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_AfterLatDateTol) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_WithLatDateTol) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_ScheduleToPossibleStartPenalty) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_PenJobToJob) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_PenSetupMin) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_PenJobToRes) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_PenJobToCapRes) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_PenJobNotCapRes) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_LoadedResource)  + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_LoadedOnSameResCat)  + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_StopOnFirstNotSchedJob)  + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_SortBeforeSchedule)  + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_LimitGapBtwnSubSteps) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_ToleranceDaysGapBtwnSubSteps)   + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_ToleranceHoursGapBtwnSubSteps)  + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_ToleranceMinGapBtwnSubSteps)    + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_HoursToleranceOfGapBetweenJobs)  + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_RescheduleErlierJobsWhenTolerance)  + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_forceSameWcPlantToServingGroup)  + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_CalendarForDatesPenalty)  + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_PenaltyScoreWithinTolerance) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_PenaltyScoreAfterTolerance)   + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_IgnoreRightOverlapping)  + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_IgnoreLeftOverlapping)    + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_BinColField1)  + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_BinColField2)  + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_BinColField3)  + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_BinColField4)  + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_BinColField5)  + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_DateScoreWeight) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_CompScoreWeight) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_LatestDateLimit)  + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_DateLimitType) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_NumberOfdaysFromStartingPoint) + ',');
  SQLStrings.Add(CreateFld(tbInfo.pfx, fli_DateFromStartPointAllowed));
  SQLStrings.Add(') values (');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_IDENTIFIER) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_wkstCode) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_CfgName) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_CfgNextName) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_CfgDesc) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_CfgGroup) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_AutoSeq_RunningMode) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_StartSchedFrom) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_StartSched_SpecificDateTime) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_StartSched_NumberOfDaysFromCurrentDate) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_MinJobResComp) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_MinJobJobComp) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_MaxJobJobComp) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_MinJobCapResComp) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_AllowSchedBeforeNoneConfLevl) + ',');

  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_AfterHighLimit) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_TollAfterHighLimit) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_TollAfterHighLimitHours) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_TollAfterHighLimitMinutes) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_BeforeLowLimit) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_TollBeforeLowLimit) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_TollBeforeLowLimitHours) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_TollBeforeLowLimitMinutes) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_PrefTgtDate) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_PrevOrNextLinkedJobIsTheTgtDateWhenScheduled) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_MoveObjsAllowed) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_MoveFinalObjsAlwd) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_MoveInitialObjsAlwd) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_MoveLevel1ObjsAlwd) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_MoveLevel2ObjsAlwd) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_MoveLevel3ObjsAlwd) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_MoveLevel4ObjsAlwd) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_MoveLevel5ObjsAlwd) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_MinStartDateOffset) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_PriorErrLoop) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_TempFinal) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_Sleep) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_RankRep) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_MatWOMaterials) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_AutoSplitByStdBtchSize) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_CreteriaOfResForBachZise) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_LastSplitCanGoUnderMinMac) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_MatWOAddRes) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_GraphOnMove) + ',');

  // New fields

  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_BefEarlDateTol) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_WithEarlDateTol) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_AfterLatDateTol) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_WithLatDateTol) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_ScheduleToPossibleStartPenalty) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_PenJobToJob) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_PenSetupMin) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_PenJobToRes) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_PenJobToCapRes)  + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_PenJobNotCapRes) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_LoadedResource)  + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_LoadedOnSameResCat)  + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_StopOnFirstNotSchedJob) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_SortBeforeSchedule)  + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_LimitGapBtwnSubSteps) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_ToleranceDaysGapBtwnSubSteps)   + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_ToleranceHoursGapBtwnSubSteps)  + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_ToleranceMinGapBtwnSubSteps)    + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_HoursToleranceOfGapBetweenJobs)  + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_RescheduleErlierJobsWhenTolerance)  + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_forceSameWcPlantToServingGroup)     + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_CalendarForDatesPenalty)            + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_PenaltyScoreWithinTolerance)  + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_PenaltyScoreAfterTolerance)  + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_IgnoreRightOverlapping)  + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_IgnoreLeftOverlapping)  + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_BinColField1)  + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_BinColField2)  + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_BinColField3)  + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_BinColField4)  + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_BinColField5)  + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_DateScoreWeight) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_CompScoreWeight) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_LatestDateLimit)  + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_DateLimitType) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_NumberOfdaysFromStartingPoint) + ',');
  SQLStrings.Add(':' + CreateFld(tbInfo.pfx, fli_DateFromStartPointAllowed));
  SQLStrings.Add(')');

  with qry do
  begin

    SQL.Clear;
    SQL.AddStrings(SQLStrings);

    //start loop
    for i := 0 to AutoSchedCfgList.Count - 1 do
    begin
      TmpCfg := AutoSchedCfgList[i];
      Inc(arraysize);
      qry.params.arraysize := arraysize + 1;
      qry.params[0].AsIntegers[arraysize] := StrToInt(IniAppGlobals.Identifier);
      qry.params[1].AsStrings[arraysize] := IniAppGlobals.WkstCode;
      qry.params[2].AsStrings[arraysize] := TmpCfg.m_CfgName;
      qry.params[3].AsStrings[arraysize] := TmpCfg.m_CfgNameNext;
      qry.params[4].AsStrings[arraysize] := TmpCfg.m_CfgDesc;
      qry.params[5].AsStrings[arraysize] := TmpCfg.m_CfgGroup;
      if TmpCfg.m_RunningMode = 1 then
        qry.params[6].AsStrings[arraysize] := '1'
      else
        qry.params[6].AsStrings[arraysize] := '0';

      if TmpCfg.m_StartSchedFrom = 0 then
        qry.params[7].AsStrings[arraysize] := '0'
      else if TmpCfg.m_StartSchedFrom = 1 then
        qry.params[7].AsStrings[arraysize] := '1'
      else if TmpCfg.m_StartSchedFrom = 2 then
        qry.params[7].AsStrings[arraysize] := '2'
      else
        qry.params[7].AsStrings[arraysize] := '0';

      qry.params[8].AsDateTimes[arraysize]  := TmpCfg.m_SpecificDateTime;
      qry.params[9].AsIntegers[arraysize]   := TmpCfg.m_NumberOfDaysFromCurrentDate;

      qry.params[10].AsIntegers[arraysize] := TmpCfg.m_MinJobResComp;
      qry.params[11].AsIntegers[arraysize] := TmpCfg.m_MinJobJobComp;
      qry.params[12].AsIntegers[arraysize] := TmpCfg.m_MaxJobJobComp;
      qry.params[13].AsIntegers[arraysize] := TmpCfg.m_MinJobCapResComp;

      if TmpCfg.m_AllowSchedBeforeNoneConfLevl then
        qry.params[14].AsStrings[arraysize] := '1'
      else
        qry.params[14].AsStrings[arraysize] := '0';
      qry.params[15].AsIntegers[arraysize] := TmpCfg.m_AfterHighLimit;
      qry.params[16].AsIntegers[arraysize] := TmpCfg.m_TollAfterHighLimit;
      qry.params[17].AsIntegers[arraysize] := TmpCfg.m_TollAfterHighLimitHours;
      qry.params[18].AsIntegers[arraysize] := TmpCfg.m_TollAfterHighLimitMinutes;
      qry.params[19].AsIntegers[arraysize] := TmpCfg.m_BeforeLowLimit;
      qry.params[20].AsIntegers[arraysize] := TmpCfg.m_TollBeforeLowLimit;
      qry.params[21].AsIntegers[arraysize] := TmpCfg.m_TollBeforeLowLimitHours;
      qry.params[22].AsIntegers[arraysize] := TmpCfg.m_TollBeforeLowLimitMinutes;
      qry.params[23].AsIntegers[arraysize] := TmpCfg.m_PrefTgtDate;
      if TmpCfg.m_PrevOrNextLinkedJobIsTheTgtDateWhenScheduled then
        qry.params[24].AsStrings[arraysize] := '1'
      else
        qry.params[24].AsStrings[arraysize] := '0';
      qry.params[25].AsIntegers[arraysize] := TmpCfg.m_MoveObjsAllowed;
      qry.params[26].AsIntegers[arraysize] := TmpCfg.m_MoveFinalObjsAlwd;
      qry.params[27].AsIntegers[arraysize] := TmpCfg.m_MoveInitialObjsAlwd;
      qry.params[28].AsIntegers[arraysize] := TmpCfg.m_MoveLevel1ObjsAlwd;
      qry.params[29].AsIntegers[arraysize] := TmpCfg.m_MoveLevel2ObjsAlwd;
      qry.params[30].AsIntegers[arraysize] := TmpCfg.m_MoveLevel3ObjsAlwd;
      qry.params[31].AsIntegers[arraysize] := TmpCfg.m_MoveLevel4ObjsAlwd;
      qry.params[32].AsIntegers[arraysize] := TmpCfg.m_MoveLevel5ObjsAlwd;
      qry.params[33].AsIntegers[arraysize] := TmpCfg.m_MinStartDateOffset;
      if TmpCfg.m_PriorErrLoop then
        qry.params[34].AsStrings[arraysize] := '1'
      else
        qry.params[34].AsStrings[arraysize] := '0';
      qry.params[35].AsIntegers[arraysize] := TmpCfg.m_TempFinal;
      qry.params[36].AsIntegers[arraysize] := TmpCfg.m_Sleep;
      if TmpCfg.m_RankRep then
        qry.params[37].AsStrings[arraysize] := '1'
      else
        qry.params[37].AsStrings[arraysize] := '0';
      qry.params[38].AsIntegers[arraysize] := TmpCfg.m_MatWOMaterials;

      case TmpCfg.m_SplitSchedByBatchSize of
        ByEqualQuantity : qry.params[39].AsIntegers[arraysize] := 1;
        BalancingAll    : qry.params[39].AsIntegers[arraysize] := 2;
        DailyProductionAndJoin : qry.params[39].AsIntegers[arraysize] := 3;
        ByMachinesOptimumForceSplit : qry.params[39].AsIntegers[arraysize] := 4;
        LongestDurationPossible : qry.params[39].AsIntegers[arraysize] := 5;
      else
        qry.params[39].AsIntegers[arraysize] := 0;
      end;

      case TmpCfg.m_CreteriaOfResForBachZise of
        OnlySameSize : qry.params[40].AsIntegers[arraysize] := 1;
        SameSizeExcpetSmallesBatch : qry.params[40].AsIntegers[arraysize] := 2;
        else
          qry.params[40].AsIntegers[arraysize] := 0;
      end;

      if TmpCfg.m_LastSplitCanGoUnderMin then
        qry.params[41].AsIntegers[arraysize] := 1
      else
        qry.params[41].AsIntegers[arraysize] := 0;

      qry.params[42].AsIntegers[arraysize] := TmpCfg.m_MatWOAddRes;
      if TmpCfg.m_GraphOnMove then
        qry.params[43].AsStrings[arraysize] := '1'
      else
        qry.params[43].AsStrings[arraysize] := '0';

      // New fields

      qry.params[44].AsFloats[arraysize] := TmpCfg.m_BeforeEarlDateTol;
      qry.params[45].AsFloats[arraysize] := TmpCfg.m_WithinEarlDateTol;
      qry.params[46].AsFloats[arraysize] := TmpCfg.m_AfterLatestDateTol;
      qry.params[47].AsFloats[arraysize] := TmpCfg.m_WithinLatestDateTol;
      qry.params[48].AsFloats[arraysize] := TmpCfg.m_ScheduleToPossibleStartPenalty;
      qry.params[49].AsFloats[arraysize] := TmpCfg.m_PenCompJobToJob;
      qry.params[50].AsFloats[arraysize] := TmpCfg.m_PenCompSetupMinutes;
      qry.params[51].AsFloats[arraysize] := TmpCfg.m_PenCompJobToRes;
      qry.params[52].AsFloats[arraysize] := TmpCfg.m_PenCompJobToCapRes;
      qry.params[53].AsFloats[arraysize] := TmpCfg.m_PenCompJobNotCapRes;

      if TmpCfg.m_LoadedResource then
         qry.params[54].AsStrings[arraysize] := '1'
      else
         qry.params[54].AsStrings[arraysize] := '2';

      if TmpCfg.m_LoadedOnSameResCat then
         qry.params[55].AsStrings[arraysize] := '1'
      else
         qry.params[55].AsStrings[arraysize] := '2';

      if TmpCfg.m_StopOnFirstNotSchedJob then
         qry.params[56].AsStrings[arraysize] := '1'
      else
         qry.params[56].AsStrings[arraysize] := '2';

      if TmpCfg.m_SortBeforeSchedule then
         qry.params[57].AsStrings[arraysize] := '1'
      else
         qry.params[57].AsStrings[arraysize] := '2';

      if TmpCfg.m_LimitGapBtwnSubSteps = '0' then
         qry.params[58].AsStrings[arraysize] := '0'
      else if TmpCfg.m_LimitGapBtwnSubSteps = '1' then
         qry.params[58].AsStrings[arraysize] := '1';

      qry.params[59].AsIntegers[arraysize] := TmpCfg.m_ToleranceDaysGapBtwnSubSteps;
      qry.params[60].AsIntegers[arraysize] := TmpCfg.m_ToleranceHoursGapBtwnSubSteps;
      qry.params[61].AsIntegers[arraysize] := TmpCfg.m_ToleranceMinGapBtwnSubSteps;
      qry.params[62].AsIntegers[arraysize] := TmpCfg.m_HoursToleranceOfGapBetweenJobs;
      if TmpCfg.m_RescheduleErlierJobsWhenTolerance then
        qry.params[63].AsStrings[arraysize] := '1'
      else
        qry.params[63].AsStrings[arraysize] := '0';

      if TmpCfg.m_AllServingGroupJobsSamePlant then
        qry.params[64].AsStrings[arraysize] := '1'
      else
        qry.params[64].AsStrings[arraysize] := '0';
      qry.params[65].AsStrings[arraysize] := TmpCfg.m_CalendarForDatesPenalty;
      qry.params[66].AsFloats[arraysize] := TmpCfg.m_PenaltyScoreWithinTolerance;
      qry.params[67].AsFloats[arraysize] := TmpCfg.m_PenaltyScoreAfterTolerance;

      qry.params[68].AsIntegers[arraysize] := TmpCfg.m_IgnoreRightOverlapping;
      qry.params[69].AsIntegers[arraysize] := TmpCfg.m_IgnoreLeftOverlapping;

      if (TmpCfg.m_FieldArrayForSort[1].Field = CSC_NotSorted) then
         qry.params[70].AsIntegers[arraysize] := -1
      else if (TmpCfg.m_FieldArrayForSort[1].Field = CSC_Overlapping) then
         qry.params[70].AsIntegers[arraysize] := 1000
      else
        qry.params[70].AsIntegers[arraysize] := TmpCfg.m_FieldArrayForSort[1].Pos;

      if (TmpCfg.m_FieldArrayForSort[2].Field = CSC_NotSorted) then
         qry.params[71].AsIntegers[arraysize] := -1
      else if (TmpCfg.m_FieldArrayForSort[2].Field = CSC_Overlapping) then
         qry.params[71].AsIntegers[arraysize] := 1000
      else
        qry.params[71].AsIntegers[arraysize] := TmpCfg.m_FieldArrayForSort[2].Pos;

      if (TmpCfg.m_FieldArrayForSort[3].Field = CSC_NotSorted) then
         qry.params[72].AsIntegers[arraysize] := -1
      else if (TmpCfg.m_FieldArrayForSort[3].Field = CSC_Overlapping) then
         qry.params[72].AsIntegers[arraysize] := 1000
      else
        qry.params[72].AsIntegers[arraysize] := TmpCfg.m_FieldArrayForSort[3].Pos;

      if (TmpCfg.m_FieldArrayForSort[4].Field = CSC_NotSorted) then
         qry.params[73].AsIntegers[arraysize] := -1
      else if (TmpCfg.m_FieldArrayForSort[4].Field = CSC_Overlapping) then
         qry.params[73].AsIntegers[arraysize] := 1000
      else
        qry.params[73].AsIntegers[arraysize] := TmpCfg.m_FieldArrayForSort[4].Pos;

      if (TmpCfg.m_FieldArrayForSort[5].Field = CSC_NotSorted) then
         qry.params[74].AsIntegers[arraysize] := -1
      else if (TmpCfg.m_FieldArrayForSort[5].Field = CSC_Overlapping) then
         qry.params[74].AsIntegers[arraysize] := 1000
      else
        qry.params[74].AsIntegers[arraysize] := TmpCfg.m_FieldArrayForSort[5].Pos;

      qry.params[75].AsIntegers[arraysize] := TmpCfg.m_DateScoreWeight;
      qry.params[76].AsIntegers[arraysize] := TmpCfg.m_CompScoreWeight;

      if TmpCfg.m_AllowedLatestDateLimit = 0 then
        qry.params[77].AsStrings[arraysize] := '0'
      else if TmpCfg.m_AllowedLatestDateLimit = 1 then
        qry.params[77].AsStrings[arraysize] := '1'
      else if TmpCfg.m_AllowedLatestDateLimit = 2 then
        qry.params[77].AsStrings[arraysize] := '2'
      else
        qry.params[77].AsStrings[arraysize] := '0';

      if TmpCfg.m_AllowedDatelimitType = 0 then
        qry.params[78].AsStrings[arraysize] := '0'
      else if TmpCfg.m_AllowedDatelimitType = 1 then
        qry.params[78].AsStrings[arraysize] := '1'
      else if TmpCfg.m_AllowedDatelimitType = 2 then
        qry.params[78].AsStrings[arraysize] := '2'
      else
        qry.params[78].AsStrings[arraysize] := '1';

      qry.params[79].AsIntegers[arraysize]   := TmpCfg.m_LatestDateScheduleNbrOfDays;
      qry.params[80].AsDateTimes[arraysize]  := TmpCfg.m_LatestDateSchedule;

    //  ExecSQL;
    end; //end Loop

    if arraysize >= 0 then
      qry.execute(arraysize + 1);

    Transaction.Commit;
    close;

  end;

  qry.Free;
  SQLStrings.Free
end;

//----------------------------------------------------------------------------//

function GetAutoSchedCfg(CfgName: string): PTAutoSchedCfg;
var
  i: integer;
  TmpCfg: PTAutoSchedCfg;
begin
  Result := nil;

  for i := 0 to AutoSchedCfgList.Count -1 do
  begin
    TmpCfg := AutoSchedCfgList.Items[i];
    if TmpCfg.m_CfgName = CfgName then
    begin
      Result := TmpCfg;
      Break
    end;
  end;
end;

//----------------------------------------------------------------------------//

function GetAllAutoSchedCfgList: TStringList;
var
  i: integer;
  TmpCfg: PTAutoSchedCfg;
begin
  Result := TStringList.Create;

  for i := 0 to AutoSchedCfgList.Count -1 do
  begin
    TmpCfg := AutoSchedCfgList.Items[i];
    Result.Add(TmpCfg.m_CfgName)
  end;
end;

//----------------------------------------------------------------------------//

procedure SetAsActiveCfg(Cfg: PTAutoSchedCfg);
begin
  AutoSchedCfg := Cfg;
end;

//----------------------------------------------------------------------------//

procedure AddNewCfg(Cfg: PTAutoSchedCfg);
begin
  AutoSchedCfgList.Add(Cfg);
end;

//----------------------------------------------------------------------------//

procedure EreaseCfg(Cfg: PTAutoSchedCfg);
begin
  AutoSchedCfgList.Remove(Cfg);
  Dispose(Cfg)
end;

//----------------------------------------------------------------------------//

procedure ClearAllCfg;
var
  i: integer;
  Cfg: PTAutoSchedCfg;
begin
  for i := AutoSchedCfgList.Count-1 downto 0 do
  begin
    Cfg := AutoSchedCfgList[i];
    AutoSchedCfgList.Remove(Cfg);
    Dispose(Cfg)
  end;
end;

//----------------------------------------------------------------------------//

function BeforeLowTolerance(Cfg: PTAutoSchedCfg): double;
begin
  Result := Cfg.m_TollBeforeLowLimit + Cfg.m_TollBeforeLowLimitHours / 24 +
    Cfg.m_TollBeforeLowLimitMinutes / 24 / 60;
end;

//----------------------------------------------------------------------------//

function AfterHighTolerance(Cfg: PTAutoSchedCfg): double;
begin
  Result := Cfg.m_TollAfterHighLimit + Cfg.m_TollAfterHighLimitHours / 24 +
    Cfg.m_TollAfterHighLimitMinutes / 24 / 60;
end;

//----------------------------------------------------------------------------//

procedure LoadScoreAdditionalFromDB(List : TList; AutoCfgName : string);
var
  qry: TMqmQuery;
  tbInfo : ^TTblInfo;
  ScoreAddition : PTScoreAddition;
begin
  qry := CreateQuery(Cfg_DB);
  tbInfo := @tblInfo[tbl_AutoSeq_ScoreAddition];
  with qry do
  begin
    SQL.Add('select * from ' + tbInfo.GetTableName);
    SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + '= ''' + IniAppGlobals.WkstCode + '''');
    SQL.Add(' And ' + CreateFld(tbInfo.pfx, fli_CfgName) + '= ''' + AutoCfgName + '''');
    SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
    SQL.Add(' order by ' + CreateFld(tbInfo.pfx, fli_Sequence));
    qry.open;
    while not EOF do
    begin
      new(ScoreAddition);
      if FieldByName(CreateFld(tbInfo.pfx, fli_From_Job_to_Prior_Job_case)).IsNull then
        ScoreAddition.From_Job_to_Prior_Job_case := -1
      else
        ScoreAddition.From_Job_to_Prior_Job_case := FieldByName(CreateFld(tbInfo.pfx, fli_From_Job_to_Prior_Job_case)).AsInteger;
      if FieldByName(CreateFld(tbInfo.pfx, fli_To_Job_to_Prior_Job_case)).IsNull then
        ScoreAddition.To_Job_to_Prior_Job_case := -1
      else
        ScoreAddition.To_Job_to_Prior_Job_case := FieldByName(CreateFld(tbInfo.pfx, fli_To_Job_to_Prior_Job_case)).AsInteger;
      if FieldByName(CreateFld(tbInfo.pfx, fli_From_Job_to_Follow_Job_case)).IsNull then
        ScoreAddition.From_Job_to_Follow_Job_case := -1
      else
        ScoreAddition.From_Job_to_Follow_Job_case := FieldByName(CreateFld(tbInfo.pfx, fli_From_Job_to_Follow_Job_case)).AsInteger;

      if FieldByName(CreateFld(tbInfo.pfx, fli_To_Job_to_Follow_Job_case)).IsNull then
        ScoreAddition.To_Job_to_Follow_Job_case := -1
      else
        ScoreAddition.To_Job_to_Follow_Job_case := FieldByName(CreateFld(tbInfo.pfx, fli_To_Job_to_Follow_Job_case)).AsInteger;

      if FieldByName(CreateFld(tbInfo.pfx, fli_From_Job_to_resource_case)).IsNull then
        ScoreAddition.From_Job_to_resource_case := -1
      else
        ScoreAddition.From_Job_to_resource_case := FieldByName(CreateFld(tbInfo.pfx, fli_From_Job_to_resource_case)).AsInteger;

      if FieldByName(CreateFld(tbInfo.pfx, fli_To_Job_to_resource_case)).IsNull then
        ScoreAddition.To_Job_to_resource_case := -1
      else
        ScoreAddition.To_Job_to_resource_case := FieldByName(CreateFld(tbInfo.pfx, fli_To_Job_to_resource_case)).AsInteger;

      if FieldByName(CreateFld(tbInfo.pfx, fli_From_number_of_days_delay)).IsNull then
        ScoreAddition.From_number_of_days_delay := -1
      else
        ScoreAddition.From_number_of_days_delay := FieldByName(CreateFld(tbInfo.pfx, fli_From_number_of_days_delay)).AsInteger;
      if FieldByName(CreateFld(tbInfo.pfx, fli_To_number_of_days_delay)).IsNull then
        ScoreAddition.To_number_of_days_delay := -1
      else
        ScoreAddition.To_number_of_days_delay := FieldByName(CreateFld(tbInfo.pfx, fli_To_number_of_days_delay)).AsInteger;

      if FieldByName(CreateFld(tbInfo.pfx, fli_From_number_of_days_early)).IsNull then
        ScoreAddition.From_number_of_days_early := -1
      else
        ScoreAddition.From_number_of_days_early := FieldByName(CreateFld(tbInfo.pfx, fli_From_number_of_days_early)).AsInteger;

      if FieldByName(CreateFld(tbInfo.pfx, fli_To_number_of_days_early)).IsNull then
        ScoreAddition.To_number_of_days_early := -1
      else
        ScoreAddition.To_number_of_days_early := FieldByName(CreateFld(tbInfo.pfx, fli_To_number_of_days_early)).AsInteger;

      if FieldByName(CreateFld(tbInfo.pfx, fli_From_number_minutes_setup_add)).IsNull then
        ScoreAddition.From_number_minutes_setup_add := -1
      else
        ScoreAddition.From_number_minutes_setup_add := FieldByName(CreateFld(tbInfo.pfx, fli_From_number_minutes_setup_add)).AsInteger;
      if FieldByName(CreateFld(tbInfo.pfx, fli_To_number_minutes_setup_add)).IsNull then
        ScoreAddition.To_number_minutes_setup_add := -1
      else
        ScoreAddition.To_number_minutes_setup_add := FieldByName(CreateFld(tbInfo.pfx, fli_To_number_minutes_setup_add)).AsInteger;

      if FieldByName(CreateFld(tbInfo.pfx, fli_Add_to_score)).Isnull then
        ScoreAddition.Add_to_score := 0
      else
        ScoreAddition.Add_to_score := FieldByName(CreateFld(tbInfo.pfx, fli_Add_to_score)).AsInteger;

      if not FieldByName(CreateFld(tbInfo.pfx, fli_Double_Direction)).IsNull and (FieldByName(CreateFld(tbInfo.pfx, fli_Double_Direction)).AsInteger = 1) then
        ScoreAddition.Double_Direction := true
      else
        ScoreAddition.Double_Direction := false;

      List.Add(ScoreAddition);
      Next;
    end;
    qry.Free;
  end;
end;

//----------------------------------------------------------------------------//

procedure LoadSpecificDateTimeFromDB(AutoCfgName : string);
var
  qry: TMqmQuery;
  tbInfo : ^TTblInfo;
begin
  qry := CreateQuery(Cfg_DB);
  tbInfo := @tblInfo[tbl_cfg_AutoSched];
  with qry do
  begin
    SQL.Add('select * from ' + tbInfo.GetTableName);
    SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + '= ''' + IniAppGlobals.WkstCode + '''');
    SQL.Add(' And ' + CreateFld(tbInfo.pfx, fli_CfgName) + '= ''' + AutoCfgName + '''');
    SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
    qry.open;
    if not EOF then
      AutoSchedCfg.m_SpecificDateTime := FieldByName(CreateFld(tbInfo.pfx, fli_StartSched_SpecificDateTime)).AsdateTime;
  end;
  qry.Free;
end;

//----------------------------------------------------------------------------//

procedure LoadJobToJobDefinitionsFromDB(List : TList; AutoCfgName : string);
var
  qry: TMqmQuery;
  tbInfo : ^TTblInfo;
  PJobToJobDefinitions : PTJobToJobDefinitions;
begin
  qry := CreateQuery(Cfg_DB);
  tbInfo := @tblInfo[tbl_AutoSeqJobToJobDefinitions];
  with qry do
  begin
    SQL.Add('select * from ' + tbInfo.GetTableName);
    SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + '= ''' + IniAppGlobals.WkstCode + '''');
    SQL.Add(' And ' + CreateFld(tbInfo.pfx, fli_CfgName) + '= ''' + AutoCfgName + '''');
    SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
    SQL.Add(' order by ' + CreateFld(tbInfo.pfx, fli_From_Case));
    qry.open;
    while not EOF do
    begin
      new(PJobToJobDefinitions);
      PJobToJobDefinitions.FromCase := FieldByName(CreateFld(tbInfo.pfx, fli_From_Case)).AsInteger;
      PJobToJobDefinitions.ToCase := FieldByName(CreateFld(tbInfo.pfx, fli_ToCase)).AsInteger;
      PJobToJobDefinitions.AddToScore := FieldByName(CreateFld(tbInfo.pfx, fli_Add_to_score)).AsInteger;
      List.Add(PJobToJobDefinitions);
      Next;
    end;
    qry.Free;
  end;
end;

//----------------------------------------------------------------------------//

function GetStrReqForJobId(Id : TSchedId) : string;
var
  ProdReq, ProdStep, ProdSubStep, reProcess  : variant;
  dataType: CBinColValType;
begin
  p_sc.GetFldValue(Id, CSC_ProdReq,    ProdReq,  dataType);
  p_sc.GetFldValue(Id, CSC_ProdStep,   ProdStep, dataType);
  p_sc.GetFldValue(Id, CSC_ProdSubStep,ProdSubStep, dataType);
  p_sc.GetFldValue(Id, CSC_ReprocNo,  reProcess, dataType);
  Result := _('Job') + ' ' + ProdReq + '/' + IntToStr(ProdStep) + '/' + IntToStr(ProdSubStep) + '/' + IntToStr(reProcess);
end;

//----------------------------------------------------------------------------//

procedure SetAutoSchedParams(CurrentAutoSchedCfg : PTAutoSchedCfg; OverrideAll : boolean);
begin
  AutoSchedCfg.m_MinJobResComp :=  CurrentAutoSchedCfg.m_MinJobResComp;
  AutoSchedCfg.m_MinJobJobComp :=  CurrentAutoSchedCfg.m_MinJobJobComp;
  AutoSchedCfg.m_MinJobCapResComp := CurrentAutoSchedCfg.m_MinJobCapResComp;
  AutoSchedCfg.m_BeforeLowLimit := CurrentAutoSchedCfg.m_BeforeLowLimit;
  AutoSchedCfg.m_TollBeforeLowLimit := CurrentAutoSchedCfg.m_TollBeforeLowLimit;
  AutoSchedCfg.m_TollBeforeLowLimitHours := CurrentAutoSchedCfg.m_TollBeforeLowLimitHours;
  AutoSchedCfg.m_TollBeforeLowLimitMinutes := CurrentAutoSchedCfg.m_TollBeforeLowLimitMinutes;
  AutoSchedCfg.m_AfterHighLimit := CurrentAutoSchedCfg.m_AfterHighLimit;
  AutoSchedCfg.m_TollAfterHighLimit :=  CurrentAutoSchedCfg.m_TollAfterHighLimit;
  AutoSchedCfg.m_TollAfterHighLimitHours := CurrentAutoSchedCfg.m_TollAfterHighLimitHours;
  AutoSchedCfg.m_TollAfterHighLimitMinutes := CurrentAutoSchedCfg.m_TollAfterHighLimitMinutes;
  AutoSchedCfg.m_CfgName := CurrentAutoSchedCfg.m_CfgName;
//  AutoSchedCfg.m_CfgNameNext := CurrentAutoSchedCfg.m_CfgNameNext;

  AutoSchedCfg.m_PrefTgtDate := CurrentAutoSchedCfg.m_PrefTgtDate;
  AutoSchedCfg.m_PrevOrNextLinkedJobIsTheTgtDateWhenScheduled := CurrentAutoSchedCfg.m_PrevOrNextLinkedJobIsTheTgtDateWhenScheduled;
  AutoSchedCfg.m_MoveObjsAllowed := CurrentAutoSchedCfg.m_MoveObjsAllowed;
  AutoSchedCfg.m_MoveFinalObjsAlwd := CurrentAutoSchedCfg.m_MoveFinalObjsAlwd;
  AutoSchedCfg.m_MoveInitialObjsAlwd := CurrentAutoSchedCfg.m_MoveInitialObjsAlwd;
  AutoSchedCfg.m_MoveLevel1ObjsAlwd := CurrentAutoSchedCfg.m_MoveLevel1ObjsAlwd;
  AutoSchedCfg.m_MoveLevel2ObjsAlwd := CurrentAutoSchedCfg.m_MoveLevel2ObjsAlwd;
  AutoSchedCfg.m_MoveLevel3ObjsAlwd := CurrentAutoSchedCfg.m_MoveLevel3ObjsAlwd;
  AutoSchedCfg.m_MoveLevel4ObjsAlwd := CurrentAutoSchedCfg.m_MoveLevel4ObjsAlwd;
  AutoSchedCfg.m_MoveLevel5ObjsAlwd := CurrentAutoSchedCfg.m_MoveLevel5ObjsAlwd;

  AutoSchedCfg.m_StartSchedFrom := CurrentAutoSchedCfg.m_StartSchedFrom;
  AutoSchedCfg.m_SpecificDateTime := CurrentAutoSchedCfg.m_SpecificDateTime;
  AutoSchedCfg.m_NumberOfDaysFromCurrentDate := CurrentAutoSchedCfg.m_NumberOfDaysFromCurrentDate;

  AutoSchedCfg.m_MatWOMaterials := CurrentAutoSchedCfg.m_MatWOMaterials;
  AutoSchedCfg.m_MatWOAddRes := CurrentAutoSchedCfg.m_MatWOAddRes;

  AutoSchedCfg.m_BeforeEarlDateTol := CurrentAutoSchedCfg.m_BeforeEarlDateTol;
  AutoSchedCfg.m_WithinEarlDateTol := CurrentAutoSchedCfg.m_WithinEarlDateTol;
  AutoSchedCfg.m_AfterLatestDateTol := CurrentAutoSchedCfg.m_AfterLatestDateTol;

  AutoSchedCfg.m_WithinLatestDateTol := CurrentAutoSchedCfg.m_WithinLatestDateTol;
  AutoSchedCfg.m_ScheduleToPossibleStartPenalty := CurrentAutoSchedCfg.m_ScheduleToPossibleStartPenalty;

  AutoSchedCfg.m_PenCompJobToRes := CurrentAutoSchedCfg.m_PenCompJobToRes;
  AutoSchedCfg.m_PenCompJobToCapRes := CurrentAutoSchedCfg.m_PenCompJobToCapRes;
  AutoSchedCfg.m_PenCompSetupMinutes := CurrentAutoSchedCfg.m_PenCompSetupMinutes;
  AutoSchedCfg.m_PenCompJobToJob := CurrentAutoSchedCfg.m_PenCompJobToJob;

//  AutoSchedCfg.m_ListOfScoreAdditional := TList.Create;
//  LoadScoreAdditionalFromDB(AutoSchedCfg.m_ListOfScoreAdditional, AutoSchedCfg.m_CfgName);
  AutoSchedCfg.m_ListOfJobToJobDefinitions := TList.Create;
  LoadJobToJobDefinitionsFromDB(AutoSchedCfg.m_ListOfJobToJobDefinitions, AutoSchedCfg.m_CfgName);

  if OverrideAll then
  begin
    AutoSchedCfg.m_PrefTgtDate := CurrentAutoSchedCfg.m_PrefTgtDate;
    AutoSchedCfg.m_MoveObjsAllowed := CurrentAutoSchedCfg.m_MoveObjsAllowed;

    AutoSchedCfg.m_MoveFinalObjsAlwd   := CurrentAutoSchedCfg.m_MoveFinalObjsAlwd;
    AutoSchedCfg.m_MoveInitialObjsAlwd := CurrentAutoSchedCfg.m_MoveInitialObjsAlwd;
    AutoSchedCfg.m_MoveLevel1ObjsAlwd  := CurrentAutoSchedCfg.m_MoveLevel1ObjsAlwd;
    AutoSchedCfg.m_MoveLevel2ObjsAlwd  := CurrentAutoSchedCfg.m_MoveLevel2ObjsAlwd;
    AutoSchedCfg.m_MoveLevel3ObjsAlwd  := CurrentAutoSchedCfg.m_MoveLevel3ObjsAlwd;
    AutoSchedCfg.m_MoveLevel4ObjsAlwd  := CurrentAutoSchedCfg.m_MoveLevel4ObjsAlwd;
    AutoSchedCfg.m_MoveLevel5ObjsAlwd  := CurrentAutoSchedCfg.m_MoveLevel5ObjsAlwd;
    AutoSchedCfg.m_TempFinal  := CurrentAutoSchedCfg.m_TempFinal;
    AutoSchedCfg.m_AllowSchedBeforeNoneConfLevl := CurrentAutoSchedCfg.m_AllowSchedBeforeNoneConfLevl;
  end;

end;

//----------------------------------------------------------------------------//

procedure RestoreAutoSeqParms(SavedAutoSchedCfg : PTAutoSchedCfg);
begin
  AutoSchedCfg.m_StartSchedFrom  		    																:= SavedAutoSchedCfg.m_StartSchedFrom;
  AutoSchedCfg.m_SpecificDateTime 		    															:= SavedAutoSchedCfg.m_SpecificDateTime;
  AutoSchedCfg.m_NumberOfDaysFromCurrentDate 		    										:= SavedAutoSchedCfg.m_NumberOfDaysFromCurrentDate;
  AutoSchedCfg.m_PrefTgtDate         		    														:= SavedAutoSchedCfg.m_PrefTgtDate;
  AutoSchedCfg.m_PrevOrNextLinkedJobIsTheTgtDateWhenScheduled						:= SavedAutoSchedCfg.m_PrevOrNextLinkedJobIsTheTgtDateWhenScheduled;
  AutoSchedCfg.m_MoveObjsAllowed    		    														:= SavedAutoSchedCfg.m_MoveObjsAllowed;
  AutoSchedCfg.m_MoveFinalObjsAlwd   		    														:= SavedAutoSchedCfg.m_MoveFinalObjsAlwd;
  AutoSchedCfg.m_MoveInitialObjsAlwd 		    														:= SavedAutoSchedCfg.m_MoveInitialObjsAlwd;
  AutoSchedCfg.m_MoveLevel1ObjsAlwd  		    														:= SavedAutoSchedCfg.m_MoveLevel1ObjsAlwd;
  AutoSchedCfg.m_MoveLevel2ObjsAlwd  		    														:= SavedAutoSchedCfg.m_MoveLevel2ObjsAlwd;
  AutoSchedCfg.m_MoveLevel3ObjsAlwd  		    														:= SavedAutoSchedCfg.m_MoveLevel3ObjsAlwd;
  AutoSchedCfg.m_MoveLevel4ObjsAlwd  		    														:= SavedAutoSchedCfg.m_MoveLevel4ObjsAlwd;
  AutoSchedCfg.m_MoveLevel5ObjsAlwd  		    														:= SavedAutoSchedCfg.m_MoveLevel5ObjsAlwd;
  AutoSchedCfg.m_MatWOMaterials      		  														  := SavedAutoSchedCfg.m_MatWOMaterials;
  AutoSchedCfg.m_MatWOAddRes         		  														  := SavedAutoSchedCfg.m_MatWOAddRes;
  AutoSchedCfg.m_MinJobResComp       		  														  := SavedAutoSchedCfg.m_MinJobResComp;
  AutoSchedCfg.m_MinJobJobComp																					:= SavedAutoSchedCfg.m_MinJobJobComp;
  AutoSchedCfg.m_MaxJobJobComp       		   			 												:= SavedAutoSchedCfg.m_MaxJobJobComp;
  AutoSchedCfg.m_MinJobCapResComp    		    														:= SavedAutoSchedCfg.m_MinJobCapResComp;
  AutoSchedCfg.m_BeforeLowLimit      		   															:= SavedAutoSchedCfg.m_BeforeLowLimit;
  AutoSchedCfg.m_TollBeforeLowLimit        		    											:= SavedAutoSchedCfg.m_TollBeforeLowLimit;
  AutoSchedCfg.m_TollBeforeLowLimitHours   		    											:= SavedAutoSchedCfg.m_TollBeforeLowLimitHours;
  AutoSchedCfg.m_TollBeforeLowLimitMinutes 		    											:= SavedAutoSchedCfg.m_TollBeforeLowLimitMinutes;
  AutoSchedCfg.m_AfterHighLimit      		    														:= SavedAutoSchedCfg.m_AfterHighLimit;
  AutoSchedCfg.m_TollAfterHighLimit        		    											:= SavedAutoSchedCfg.m_TollAfterHighLimit;
  AutoSchedCfg.m_TollAfterHighLimitHours   		    											:= SavedAutoSchedCfg.m_TollAfterHighLimitHours;
  AutoSchedCfg.m_TollAfterHighLimitMinutes 		    											:= SavedAutoSchedCfg.m_TollAfterHighLimitMinutes;
  AutoSchedCfg.m_AllowSchedBeforeNoneConfLevl 		 					  					:= SavedAutoSchedCfg.m_AllowSchedBeforeNoneConfLevl;
  AutoSchedCfg.m_BeforeEarlDateTol   		    														:= SavedAutoSchedCfg.m_BeforeEarlDateTol;
  AutoSchedCfg.m_WithinEarlDateTol   		    														:= SavedAutoSchedCfg.m_WithinEarlDateTol;
  AutoSchedCfg.m_AfterLatestDateTol  		    														:= SavedAutoSchedCfg.m_AfterLatestDateTol;
  AutoSchedCfg.m_WithinLatestDateTol 		    														:= SavedAutoSchedCfg.m_WithinLatestDateTol;
  AutoSchedCfg.m_ScheduleToPossibleStartPenalty 		    								:= SavedAutoSchedCfg.m_ScheduleToPossibleStartPenalty;
  AutoSchedCfg.m_PenCompJobToJob     		    														:= SavedAutoSchedCfg.m_PenCompJobToJob;
  AutoSchedCfg.m_PenCompSetupMinutes 		    														:= SavedAutoSchedCfg.m_PenCompSetupMinutes;
  AutoSchedCfg.m_PenCompJobToRes     		    														:= SavedAutoSchedCfg.m_PenCompJobToRes;
  AutoSchedCfg.m_PenCompJobToCapRes  		    														:= SavedAutoSchedCfg.m_PenCompJobToCapRes;
  AutoSchedCfg.m_PenCompJobNotCapRes 		    														:= SavedAutoSchedCfg.m_PenCompJobNotCapRes;
  AutoSchedCfg.m_LoadedResource      		    														:= SavedAutoSchedCfg.m_LoadedResource;
  AutoSchedCfg.m_LoadedOnSameResCat  		    														:= SavedAutoSchedCfg.m_LoadedOnSameResCat;
  AutoSchedCfg.m_LimitGapBtwnSubSteps 		  														:= SavedAutoSchedCfg.m_LimitGapBtwnSubSteps;
  AutoSchedCfg.m_ToleranceDaysGapBtwnSubSteps    		    								:= SavedAutoSchedCfg.m_ToleranceDaysGapBtwnSubSteps;
  AutoSchedCfg.m_ToleranceHoursGapBtwnSubSteps 		    									:= SavedAutoSchedCfg.m_ToleranceHoursGapBtwnSubSteps;
  AutoSchedCfg.m_ToleranceMinGapBtwnSubSteps 		    										:= SavedAutoSchedCfg.m_ToleranceMinGapBtwnSubSteps;
  AutoSchedCfg.m_HoursToleranceOfGapBetweenJobs 		    								:= SavedAutoSchedCfg.m_HoursToleranceOfGapBetweenJobs;
  AutoSchedCfg.m_PenaltyScoreWithinTolerance 		    										:= SavedAutoSchedCfg.m_PenaltyScoreWithinTolerance;
  AutoSchedCfg.m_PenaltyScoreAfterTolerance 		    										:= SavedAutoSchedCfg.m_PenaltyScoreAfterTolerance;
  AutoSchedCfg.m_IgnoreRightOverlapping 		    												:= SavedAutoSchedCfg.m_IgnoreRightOverlapping;
  AutoSchedCfg.m_IgnoreLeftOverlapping 		    													:= SavedAutoSchedCfg.m_IgnoreLeftOverlapping;
  AutoSchedCfg.m_RescheduleErlierJobsWhenTolerance 		    							:= SavedAutoSchedCfg.m_RescheduleErlierJobsWhenTolerance;
  AutoSchedCfg.m_AllServingGroupJobsSamePlant 		    									:= SavedAutoSchedCfg.m_AllServingGroupJobsSamePlant;
  AutoSchedCfg.m_CalendarForDatesPenalty      		    									:= SavedAutoSchedCfg.m_CalendarForDatesPenalty;
  AutoSchedCfg.m_ScheduleByWorkCenterCfg 		    												:= SavedAutoSchedCfg.m_ScheduleByWorkCenterCfg;
  AutoSchedCfg.m_OverridingParams_Activated 		    										:= SavedAutoSchedCfg.m_OverridingParams_Activated;
  AutoSchedCfg.m_OverridingParams_InfiniteCapacityAllowed 							:= SavedAutoSchedCfg.m_OverridingParams_InfiniteCapacityAllowed;
  AutoSchedCfg.m_OverridingParams_UnscheduleBefore 		    							:= SavedAutoSchedCfg.m_OverridingParams_UnscheduleBefore;
  AutoSchedCfg.m_OverridingParams_Wc_Selected 		    									:= SavedAutoSchedCfg.m_OverridingParams_Wc_Selected;
  AutoSchedCfg.m_OverridingParams_Wc_Code_Selected 		    							:= SavedAutoSchedCfg.m_OverridingParams_Wc_Code_Selected;
  AutoSchedCfg.m_OverridingParams_WcDateTimeFrom        		  					:= SavedAutoSchedCfg.m_OverridingParams_WcDateTimeFrom;
  AutoSchedCfg.m_OverridingParams_WcDateTimeTo         		    					:= SavedAutoSchedCfg.m_OverridingParams_WcDateTimeTo;
  AutoSchedCfg.m_OverridingParams_ScheduleJobsWithinTheFram 						:= SavedAutoSchedCfg.m_OverridingParams_ScheduleJobsWithinTheFram;
  AutoSchedCfg.m_OverridingParams_ShorterJobsCanEndAfterFramEnd 				:= SavedAutoSchedCfg.m_OverridingParams_ShorterJobsCanEndAfterFramEnd;
  AutoSchedCfg.m_OverridingParams_LargerJobsCanStartAfterTheFrameBegins := SavedAutoSchedCfg.m_OverridingParams_LargerJobsCanStartAfterTheFrameBegins;
  AutoSchedCfg.m_OverridingParams_BeforeLowLimit        		    				:= SavedAutoSchedCfg.m_OverridingParams_BeforeLowLimit;
  AutoSchedCfg.m_OverridingParams_TollBeforeLowLimit    		    				:= SavedAutoSchedCfg.m_OverridingParams_TollBeforeLowLimit;
  AutoSchedCfg.m_OverridingParams_TollBeforeLowLimitHours  		    			:= SavedAutoSchedCfg.m_OverridingParams_TollBeforeLowLimitHours;
  AutoSchedCfg.m_OverridingParams_TollBeforeLowLimitMinutes 		    		:= SavedAutoSchedCfg.m_OverridingParams_TollBeforeLowLimitMinutes;
  AutoSchedCfg.m_OverridingParams_AfterHighLimit        		    				:= SavedAutoSchedCfg.m_OverridingParams_AfterHighLimit;
  AutoSchedCfg.m_OverridingParams_TollAfterHighLimit    		    				:= SavedAutoSchedCfg.m_OverridingParams_TollAfterHighLimit;
  AutoSchedCfg.m_OverridingParams_TollAfterHighLimitHours  		    			:= SavedAutoSchedCfg.m_OverridingParams_TollAfterHighLimitHours;
  AutoSchedCfg.m_OverridingParams_TollAfterHighLimitMinutes 		    		:= SavedAutoSchedCfg.m_OverridingParams_TollAfterHighLimitMinutes;
  AutoSchedCfg.m_OverridingParams_MatWOMaterials            		    		:= SavedAutoSchedCfg.m_OverridingParams_MatWOMaterials;
  AutoSchedCfg.m_OverridingParams_MatWOAddRes               		    		:= SavedAutoSchedCfg.m_OverridingParams_MatWOAddRes;
  AutoSchedCfg.m_OverridingParams_IgnoreRightOverlapping    		    		:= SavedAutoSchedCfg.m_OverridingParams_IgnoreRightOverlapping;
  AutoSchedCfg.m_OverridingParams_IgnoreLeftOverlapping     		    		:= SavedAutoSchedCfg.m_OverridingParams_IgnoreLeftOverlapping;
  AutoSchedCfg.m_OverridingParams_MatWOMaterials_Family     		    		:= SavedAutoSchedCfg.m_OverridingParams_MatWOMaterials_Family;
  AutoSchedCfg.m_OverridingParams_MatWOAddRes_Family        		    		:= SavedAutoSchedCfg.m_OverridingParams_MatWOAddRes_Family;
  AutoSchedCfg.m_OverridingParams_ScheduleByWorkCenterCfg   		    		:= SavedAutoSchedCfg.m_OverridingParams_ScheduleByWorkCenterCfg;
  AutoSchedCfg.m_OverridingParams_AllowedMoveLinkedReq      		    		:= SavedAutoSchedCfg.m_OverridingParams_AllowedMoveLinkedReq;
end;
//----------------------------------------------------------------------------//

function GetGetNextAutoSchedCfgByGroup(CfgNameList : TStringList; CfgGroup : string): PTAutoSchedCfg;
var
  i: integer;
  TmpCfg: PTAutoSchedCfg;
begin
  Result := nil;

  for i := 0 to AutoSchedCfgList.Count -1 do
  begin
    TmpCfg := AutoSchedCfgList.Items[i];
    if (CfgNameList.IndexOf(TmpCfg.m_CfgName) = - 1) and (TmpCfg.m_CfgGroup = CfgGroup) then
    begin
      Result := TmpCfg;
      Break
    end;
  end;
end;

//----------------------------------------------------------------------------//
procedure SetOverrideParams;
begin
  if AutoSchedCfg.m_OverridingParams_Activated then
  begin
    if AutoSchedCfg.m_OverridingParams_BeforeLowLimit > 0 then
    begin
      AutoSchedCfg.m_BeforeLowLimit := AutoSchedCfg.m_OverridingParams_BeforeLowLimit - 1;
      AutoSchedCfg.m_TollBeforeLowLimit := AutoSchedCfg.m_OverridingParams_TollBeforeLowLimit;
      AutoSchedCfg.m_TollBeforeLowLimitHours := AutoSchedCfg.m_OverridingParams_TollBeforeLowLimitHours;
      AutoSchedCfg.m_TollBeforeLowLimitMinutes := AutoSchedCfg.m_OverridingParams_TollBeforeLowLimitMinutes;
    end;

    if AutoSchedCfg.m_OverridingParams_AfterHighLimit > 0 then
    begin
      AutoSchedCfg.m_AfterHighLimit := AutoSchedCfg.m_OverridingParams_AfterHighLimit - 1;
      AutoSchedCfg.m_TollAfterHighLimit :=  AutoSchedCfg.m_OverridingParams_TollAfterHighLimit;
      AutoSchedCfg.m_TollAfterHighLimitHours := AutoSchedCfg.m_OverridingParams_TollAfterHighLimitHours;
      AutoSchedCfg.m_TollAfterHighLimitMinutes := AutoSchedCfg.m_OverridingParams_TollAfterHighLimitMinutes;
    end;

    if AutoSchedCfg.m_OverridingParams_MatWOMaterials > 0 then
      AutoSchedCfg.m_MatWOMaterials := AutoSchedCfg.m_OverridingParams_MatWOMaterials - 1;
    if AutoSchedCfg.m_OverridingParams_MatWOAddRes > 0 then
      AutoSchedCfg.m_MatWOAddRes    := AutoSchedCfg.m_OverridingParams_MatWOAddRes - 1;

    if AutoSchedCfg.m_OverridingParams_IgnoreRightOverlapping > 0 then
      AutoSchedCfg.m_IgnoreRightOverlapping := AutoSchedCfg.m_OverridingParams_IgnoreRightOverlapping - 1;
    if AutoSchedCfg.m_OverridingParams_IgnoreLeftOverlapping > 0 then
      AutoSchedCfg.m_IgnoreLeftOverlapping  := AutoSchedCfg.m_OverridingParams_IgnoreLeftOverlapping  - 1;

    if AutoSchedCfg.m_OverridingParams_Wc_Selected then
    begin
      AutoSchedCfg.m_AllowSchedBeforeNoneConfLevl := true;
      AutoSchedCfg.m_MoveObjsAllowed := 3;
    end;

  end;
end;

//----------------------------------------------------------------------------//

procedure SetParamsFromOverride(SaveCurrCfg : TAutoSchedCfg);
begin
  if AutoSchedCfg.m_OverridingParams_Activated then
  begin
    AutoSchedCfg.m_BeforeLowLimit := SaveCurrCfg.m_BeforeLowLimit;
    AutoSchedCfg.m_TollBeforeLowLimit := SaveCurrCfg.m_TollBeforeLowLimit;
    AutoSchedCfg.m_TollBeforeLowLimitHours := SaveCurrCfg.m_TollBeforeLowLimitHours;
    AutoSchedCfg.m_TollBeforeLowLimitMinutes := SaveCurrCfg.m_TollBeforeLowLimitMinutes;
    AutoSchedCfg.m_AfterHighLimit := SaveCurrCfg.m_AfterHighLimit;
    AutoSchedCfg.m_TollAfterHighLimit := SaveCurrCfg.m_TollAfterHighLimit;
    AutoSchedCfg.m_TollAfterHighLimitHours := SaveCurrCfg.m_TollAfterHighLimitHours;
    AutoSchedCfg.m_TollAfterHighLimitMinutes := SaveCurrCfg.m_TollAfterHighLimitMinutes;
    AutoSchedCfg.m_MoveObjsAllowed := SaveCurrCfg.m_MoveObjsAllowed;
//    AutoSchedCfg.m_MatWOMaterials := SaveCurrCfg.m_MatWOMaterials;
//    AutoSchedCfg.m_MatWOAddRes    := SaveCurrCfg.m_MatWOAddRes;
    AutoSchedCfg.m_OverridingParams_Activated := false;
    AutoSchedCfg.m_OverridingParams_UnscheduleBefore := false;

    // add new field for the m_MatWOMaterialsFamily
//    AutoSchedCfg.m_MatWOMaterials := AutoSchedCfg.m_OverridingParams_MatWOMaterials_Family;
//    AutoSchedCfg.m_MatWOAddRes    := AutoSchedCfg.m_OverridingParams_MatWOAddRes_Family;
  end;
//  AutoSchedCfg.m_OverridingParams_Activated := false;
end;

//----------------------------------------------------------------------------//

initialization
  AutoSchedCfgList := TList.Create;

//----------------------------------------------------------------------------//

finalization

  ClearAllCfg;
  AutoSchedCfgList.Free;

end.
