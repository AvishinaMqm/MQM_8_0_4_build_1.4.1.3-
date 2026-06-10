unit UMAutoSchedSimulation;

interface

uses Classes, UMSchedContFunc, UGbaseCal, UMActArea, UMRes, UMCompat, Forms, UMSchedCont, UMArticles, Vcl.Dialogs;

type

 TSchedType = (unschedule, schedule, RemoveGenericPlan, update, New_Id, New_Id_Group, MinorUpdate);

 TResourcesManager = class;
 TResourcesStruct  = class;
 TArrayCompatabilityCase = array[0..99] of integer;
 TArrayDaysOfLatedJobs = array[1..61] of integer;

 TMinMaxOptQty = record
   PlantCode    : String;
   MinQty       : currency;
   MaxQty       : currency;
   OptQty       : currency;
   NbrOfBacthes : integer;
   MachineSizeUsed : boolean;
 end;
 PTMinMaxOptQty = ^TMinMaxOptQty;

 TOptionToSplit = record
   SplitsList : TStringList;
 end;
 PTOptionToSplit = ^TOptionToSplit;

 TScoreRecord = record
   Id              : TSchedId;
   prevId          : TSchedId;
   Score           : double;
   ScoreJobToJob   : double;
   ScoreJobToRes   : double;
   StartDateTime   : TDateTime;
   Gap             : double;
   Resource        : TResourcesStruct;
   EndDateTime     : TDateTime;
   supMinBase      : double;
   Setup           : double;
   SetupNoMaterial : double;
   Duration        : double;
   DurationOrg     : double;
   GenericPlanWc   : string;
   GenericPlanleadTime : double;
   GenericPlanDuration : double;
   CompValJobToJob : TCompatVal;
   CompValJobToRes : TCompatVal;
   ServingGroup           : string;
   ServinglowestDate      : TDateTime;
   ServingHighestDate     : TDateTime;
   LowOverlap : TDateTime;
   HighOverlap : TDateTime;
   PenaltyDateScore : double;
   MainIdQuantity : double;
   MainIdDuration : double;
   NextNotPossibleDate : TDateTime;
 end;
 PTScoreRecord     = ^TScoreRecord;

 TSetupCompactInfo = record
   Id : TSchedId;
   ResCode : string;
   CompValJobToJob : TCompatVal;
   supMinBase : double;
   setup : double;
   SetupNoMaterial : double;
   GenericPlanWc : string;
   GenericPlanDuration : double;
   GenericPlanleadTime : double;
 end;
 PTSetupCompactInfo = ^TSetupCompactInfo;

 TJobToSched = record
   Id                     : TSchedId;
   NewId                  : TSchedId;
   ResCode                : string;
   FromGantt              : boolean;
   PossibleMoveJob        : boolean;
   PossibleSchedBefore    : boolean;
   JobIsLate              : boolean;
   score                  : double;
   ScoreJobToJob          : double;
   ScoreJobToRes          : double;
   StartSched             : TDateTime;
   EndSched               : TDateTime;
//   StartWithoutMat        : TDateTime;
   OldPlanInfo            : TSQplanInfo;
//   GenericPlanInfo        : TSQplanInfo;
   ResourcesStruct        : Pointer;
   UnscheduledFromActArea : boolean;
   Setup                  : double;
   SetUpNoMaterial        : double;
   supMinBase             : double;
   Duration               : double;
   DurationOrg            : double;
   CompValJobToJob        : TCompatVal;
   CompValJobToRes        : TCompatVal;
 //  CompValResToJob : TCompatVal;

//   List_SetupCompactParams : TList;
   GenericPlanWC          : string;
   GenericPlanDur         : double;
   GenericPlanLeadTime    : double;
   GenericPlanMachineNum  : integer;
   GenericPlanStartDate   : TdateTime;
   GenericPlanEndDate     : TdateTime;
   SchedType              : TSchedType;
   PosInList              : Integer;
   ResourceManagerPtr     : Pointer;
   ServingGroup           : string;
   ServinglowestDate      : TDateTime;
   ServingHighestDate     : TDateTime;
   PropStrQty             : double;
   PropListId             : integer;
   PropListLevel          : Integer;
   HasPropInstanceCountWithRule : boolean;
   ReScheduleAtSpecificPlace : boolean;
   ReSchedulePlace : integer;
   LowOverlap             : TDateTime;
   HighOverlap            : TDateTime;
   DurationBeforeCurve    : double;
 end;
 PTJobToSched = ^TJobToSched;

  TJobInfo = record
   Valid                  : Boolean;
   ResCode                : string;
   ResourcesStruct        : Pointer;
   UnscheduledFromActArea : boolean;
   PropStrQty             : double;
   PropListId             : integer;
   PropListLevel          : Integer;
   HasPropInstanceCountWithRule : boolean;
   List_SetupCompactParams : TList;
   OldPlanInfo            : TSQplanInfo;
   RequestNumber          : String;
   ServingGroupCode       : String;
 end;
 PTJobInfo = ^TJobInfo;

 TRequestStepsToReLoadResources = record
   Request    : string;
   step       : integer;
   ReCheckResources : boolean;
   ReLoadResources : boolean;
 end;
 PTRequestStepsToReLoadResources = ^TRequestStepsToReLoadResources;

 TCurveByFamilyInfo = record
   CurveCode       : string;
   FamilyIdCode    : string;
   OldIdsTimeBeforeCurve : double;
   IdsList : TStringList;
   IdsStartDate : TStringList;
   IdDurationOrg : TStringList;
 end;
 PTCurveByFamilyInfo = ^TCurveByFamilyInfo;

 TLogInfo = record
   Action          : String;
   Id              : TSchedId;
   PrevId          : TSchedId;
   rescode         : string;
   StartDate       : TDateTime;
   EndDate         : TDateTime;
//   CompValResToJob : integer;
//   PrevEndDate     : TDatetime;
   setup           : double;
   Overlap         : double;
   Duration        : double;
   Gap             : double;
//   compFore        : Integer;
   LowestEndDateTime : TDateTime;
   GenericPlan       : boolean;
   GenericPlanWc     : string;
   GenericPlanDuration : double;
   GenericPlanleadTime : double;
   GenericPlanStartDate : TDateTime;
   GenericPlanEndDate : TDateTime;
   GenericPlanMachine : Integer;
   Score               : double;
   ScoreJobToJob   : double;
   ScoreJobToRes   : double;
   CompValJobToJob        : TCompatVal;
   CompValJobToRes        : TCompatVal;
   ReqStepSubStep_ID      : string;
   Prev_ReqStepSubStep_ID : string;
   ServingGroup           : string;
   ServinglowestDate      : TDateTime;
   ServingHighestDate     : TDateTime;

//   ScoreResult         : double;
 end;
 PTLogInfo = ^TLogInfo;

 TResourcesStruct = class
 private
   m_ResourcesManager : TResourcesManager;
   m_Cal        : TPGCALObj;
   m_ActArea    : TMqmActArea;
   m_ResPtr     : TMQMVisibleRes;
   m_ResCode    : string;
   m_PlanType   : CScResPlanType;
   m_PlantCode  : string;
   m_SchedList  : TList;
   m_IdDeletedList : TStringList;
   m_CurveByFamilyInfo : TList;
//   m_CompValResToJob_Main : TCompatVal;
//   m_CompValResToJob_NotMain : TCompatVal;
//   m_SupMinBase_Main, m_Duration_Main, m_SupMinBase_NotMain, m_Duration_NotMain : Double;
//   m_Sndt_bch_Size_Main ,m_Min_bch_size_Main ,m_Max_bch_size_Main, m_Sndt_bch_Size_NotMain ,m_Min_bch_size_NotMain ,m_Max_bch_size_NotMain : double;
   function  CalcScore(ResPtr : pointer; id, previd : TSchedId; ScoreRecord : PTScoreRecord; LowestEndDateTime : TDateTime;
                       CompValResToJob : TCompatVal; ServingGroupCode : String; LowestServingCodeDateTime, HighestServingCodeDateTime : TDateTime) : double;
   procedure ClearResList;
   procedure LoadIdFromActiveArea;
   function  PushjobAfterDownTime(setup, dur : double; StartDateTime : TDateTime; Id : TSchedId; out NextNotPossibleDate : TDateTime) : TDateTime;
   function  PushjobAfterWarpInCaseNotCompatible(setup, dur : double; StartDateTime : TDateTime; Id : TSchedId; out NextNotPossibleDate : TDateTime) : TDateTime;
   function  TempScoreAndScheduleAndPushAllJobsFromPosition(Id : TSchedId; var ScoreList : TList;
               Index : Integer; BetterScoreFound : boolean; var NewScore : double;
               ScoreAfterLastJob : TScoreRecord; ScoreAfterLastFound : boolean; LimitStartDate, ValPrev, ValNext : TDateTime;
               ResourceIndex : integer; FinalSchdule : boolean; ServingGroupCode : String;
               ServingCodeLowestDateTime, ServingCodeHighestDateTime,
               ServingCodeLowestPlusTollerance : TDateTime; PlantCode : String;
               SupMinBaseMain, DurationMain, DurationOrgMain, DurationQuantityBaseMain : Double;
               CompJobToResMain : TCompatVal) : boolean;
   function  CheckAndScorePositionWithoutMove(Id, PrevId, ToMoveId : TSchedId; ApprovalDate,
               LeftGreenLine, RightGreenLine, PrevIdEndDateTime, ToMoveIdStartDateTime, ValPrev, ValNext : TDateTime;
               ScoreAfterLastJob : TScoreRecord; ScoreAfterLastFound : boolean;
               MatAddResList, GenericPlanDates : Tlist;
               ToMoveIdIndex, ResourceIndex : Integer; MainIdServingGroupCode : String;
               MainIdServingCodeLowestDateTime, MainIdServingCodeHighestDateTime,
               LimitStartDate, MainIdServingCodeLowestPlusTollerance : TDateTime;
               SupMinBaseMain, DurationMain, DurationOrgMain, DurationQuantityBaseMain : Double; CompJobToResMain : TCompatVal;
               var SchedBetweenJobsScoreFound : Boolean; var SchedBetweenJobsScore : double;
               var SchedBetweenJobsIdIndex, SchedBetweenJobsResourceIndex : Integer;
               var ReturnScoreRecordIdToPrevId, ReturnScoreRecordToMoveIdToId : TScoreRecord; CanBeNewId : boolean) : boolean;
   function  CalcScoreToAnAlreadySchedJob(ToMoveIdIndex : integer; ServingGroupCode : String) : boolean;
   function  CheckScoreAfterJob(PrevId, Id : TSchedId; CheckMovedJob : boolean; LimitStartDate, MaxStartDate,
                LimitEndDate, MovedJobStartDate, PrevEndDate : TDateTime; var ScoreRecord : TScoreRecord;
                GenericPlanDates : TList; PrvHighestDate, NxtLowestDate : TDateTime;
                var MatAddResList : TList;
                IgnoreGenericPlan : boolean; IgnoreAddRessMat : boolean;
                SupMinBase, Duration, DurationOrg, DurationQuantityBase : double) : boolean;
   function  CheckDateOnOneBatchMachineByGroupCode(ScoreRecord : TScoreRecord; out NextNotPossibleDate : TDateTime) : TDateTime;
   function  CheckDateOnSubResources(ScoreRecord : TScoreRecord; out NextNotPossibleDate : TDateTime) : TDateTime;
   function  GetIdResTiming(Id : TSchedId; var SupMinBase, Duration, DurationOrg : double) : boolean;
   function  FindClosestDateForSingleConsType(Id : TSchedId; setup, overlap, Dur : double; StartDateTime : TDateTime; var Index : Integer ; FromPos, NumberOfEntries : Integer; ConsList : Tlist; AddResStart, AddResEnd : ArResTime; HoursToKeepAddRes : integer; var NextNotPossibleDate : TDateTime) : TDateTime;
   function  FindClosestDateForConsumptions(Id : TSchedId; SupMinBase, setup, overlap, Dur : double; StartDateTime : TDateTime; var MatAddResList : Tlist; var NextNotPossibleDatePrm : TDateTime) : TDateTime;
   procedure SetPlanInfo(id: TSchedID; var planInfo: TSQplanInfo);
   function  GetHigherDailyProduction : integer;
//   procedure CleanIdOverlapListForSameRequest(id : TSchedId);
 public
   function  GetResourcePlantCode() : String;
   function  AddIdToList(Id : TSchedId; var ScoreRecord : TScoreRecord; AtPosition : integer; FinalSched : boolean; NewId : boolean) : integer;
   function  GetMqmActArea : TMqmActArea;
   procedure JoinAllSubStep;
   function KeepTheSplitChgQtyIfNot(OrigId, NewId : TSchedId; OrigQty, NewIdQty : double; var ScoreRecord : TScoreRecord) : boolean;
   constructor Create(ResPtr : pointer; father : TResourcesManager);
   destructor  Destroy; override;
 end;

 TResourcesManager = class
   public
     m_ListBackupIdInfo : TList;
     m_ListOfRequestStepsToReLoadResources : TList;
   private
   m_CfgName  : string;
   m_TotalScore : double;
   m_ElapsedTime : string;
   m_NumOfScheduleJobs : integer;
   m_NumOfNotScheduleJobss : integer;
   m_TolleranceHoursComparison : double;
   m_TotalLateHoursAboveTollenrance : double;
   m_TotalLateJobsAboveTollenrance : Integer;
   m_TotalHoursForLatestJobAboveTollenrance : double;
   m_TotalLateHoursUpToTollenrance : double;
   m_TotalLateJobsUpToTollenrance : Integer;

   m_TotalSetupHoursStandard : double;
   m_TotalSetupHoursBeforeMaterials : double;
   m_TotalSetupHoursAfterMaterials : double;
   m_TotalHoursAboveStandard : double;
   m_NumberOfJobsWithSetupNoMaterials : integer;
   m_NumberOfJobsWithSetupAboveStandard : integer;
   m_TotalCaseOfJobToResource : double;
   m_arrayJobToJobCase : TArrayCompatabilityCase;
   m_arrayJobToResCase : TArrayCompatabilityCase;
   m_ArrayDaysOfLatedJobs : TArrayDaysOfLatedJobs;
//   m_DurationQuantityBase_Main : double;
//   m_DurationQuantityBase_NotMain : double;

   m_AllResList : TList;
   m_AllResListByTyp : TList;
   m_MainListIDInfo : TList;
//   m_MainIdResList : TList;
//   m_TempIdResList : TList;
 //  m_ListBackupIdInfo : TList;
   m_ListOfRequestAndId : TList;
   procedure SetTotalScore(TotalScore : double);
   function  GetTotalScore : double;
   procedure SetNumOfScheduleJobs(Number : integer);
   procedure SetNumOfNotScheduleJobs(Number : integer);
   function  GetNumOfScheduleJobs : integer;
   function  GetNumOfNotScheduleJobs : integer;
   function  GetElapsedTime : string;
   procedure SetElapsedTime(ElapsedTime : string);
   function  GetTolleranceHoursComparison : double;
   procedure SetTolleranceHoursComparison(TolleranceHours : double);
   public
   constructor Create(ResList : TList; CfgName : string; MainListIDInfo : TList);
   destructor  Destroy; override;
   function  RemoveIdFromList(Id : TSchedID; ResourceIndex : integer;
               WriteToRollBack : boolean; var UnschedWithError : boolean) : boolean;
   function  TryToPushJobsToTheirTargetDate() : double;
   procedure  JoinAllSubStep;
   procedure CleanAndUnScheduleBeforeScheduleOnPlan;
   procedure AddIdToBackupList(Id : TSchedId; ResCode : string; ResourcesStruct : TResourcesStruct);
   procedure MarkIdAsNotValidInBackupList(Id : TSchedId);
   procedure AddRequestStepToReLoadResourcesList(Id : TSchedId; ReCheckResources, ReLoadResources : boolean; Index : integer);
   procedure CheckSetupCompactParam(Id : TSchedId; PrevId : TSchedId; ResCode : string; ActArea : TMqmActArea; var CompValJobToJob : TCompatVal; supMinBase : double;
                                    var setup : double; var SetupNoMaterial : double; var GenericPlanWc : string;
                                    var GenericPlanDuration : double; var GenericPlanleadTime : double; var RecalcDur : boolean);
   procedure ScheduledObjOnGantt;
   procedure AddResource(ResPtr : Pointer);
   procedure IniResStruct(ResList : TList);
   function  NoneCompetibleSomeBecauseOfDependency(Id : TSchedId; WorkCnterCode : string; PlantCode : String) : boolean;
   function  SetCompatibleRes(Id : TSchedId; WorkCnterCode : string; PlantCode : String; MinMaxOptQtyList : Tlist) : boolean;
   function  FindBestScoreAfterLastJob(Id : TSchedId; CheckMovedJob : boolean;
                 var ScoreRecord : TScoreRecord; LimitStartDate, MovedJobStartDate : TDateTime;
                 var GenericPlanDates : Tlist; FindFirstPossiblePlace : Boolean;
                 var HighestPrevEndFound : TDateTime; PlantCode : String) : boolean;
   function  FindBestScoreBeforeLastJob(Id : TSchedId; ScoreAfterLastJob : TScoreRecord; LimitStartDate : TDateTime;
                                  GenericPlanDates : TList;
                                  var NewScore : double; PlantCode : String; ScoreAfterLastFound : boolean;
                                  FindFirstPossiblePlace : Boolean;
                                  BetweenSchedDoneAfter : boolean; var IdxToSched : integer; out ReturnScoreRecordIdToPrevId : TScoreRecord;
                                  CanBeNewId : boolean) : boolean;
   procedure CleanMaterialAddRessList(var MatAddResList : Tlist);
   procedure CleanGenericPlanDates(var GenericPlanDates : Tlist);
   procedure GetMaterialAddRessList(Id : TSchedId; ResourcesStruct : TResourcesStruct;
             var MatList, AddResList, AddResPointerList, ManPowerList, ManPowerPointerList : TList;
             SupMinBase, Dur, SetupNeedMat : double);
   procedure CleanBacupListId;
   procedure CleanRequestIdList;
   procedure CleanRequestStepsToReLoadResourcesList;
   procedure CleanAllMemory;
   procedure RemoveRequestStepToReLoadResourcesList(Index : Integer);
   function  GetCfgName : string;
   procedure StatisticCalculation;
   function  GetDaysOfLatedJobsCumulativeTillSpecificDay(Day : integer) : integer;
   property p_TotalScore                             : double    read GetTotalScore write SetTotalScore;
   property p_NumOfScheduleJobs                      : Integer   read GetNumOfScheduleJobs write SetNumOfScheduleJobs;
   property p_NumOfNotScheduleJobs                   : Integer   read GetNumOfNotScheduleJobs write SetNumOfNotScheduleJobs;
   property p_ElapsedTime                            : string    read GetElapsedTime write SetElapsedTime;
   property p_TolleranceHoursComparison              : double    read GetTolleranceHoursComparison write SetTolleranceHoursComparison;
   property P_TotalLateHoursAboveTollenrance         : double    read m_TotalLateHoursAboveTollenrance;
   property P_TotalLateJobsAboveTollenrance          : integer   read m_TotalLateJobsAboveTollenrance;
   property P_TotalHoursForLatestJobAboveTollenrance : double    read m_TotalHoursForLatestJobAboveTollenrance;
   property P_TotalLateHoursUpToTollenrance          : double    read m_TotalLateHoursUpToTollenrance;
   property P_TotalLateJobsUpToTollenrance           : integer   read m_TotalLateJobsUpToTollenrance;
   property P_TotalSetupHoursStandard                : double    read m_TotalSetupHoursStandard;
   property P_TotalSetupHoursBeforeMaterials         : double    read m_TotalSetupHoursBeforeMaterials;
   property P_TotalSetupHoursAfterMaterials          : double    read m_TotalSetupHoursAfterMaterials;
   property P_TotalHoursAboveStandard                : double    read m_TotalHoursAboveStandard;
   property P_NumberOfJobsWithSetupNoMaterials       : integer   read m_NumberOfJobsWithSetupNoMaterials;
   property P_NumberOfJobsWithSetupAboveStandard     : integer   read m_NumberOfJobsWithSetupAboveStandard;
   property P_TotalCaseOfJobToResource               : double    read m_TotalCaseOfJobToResource;
   property p_arrayJobToJobCase                      : TArrayCompatabilityCase  read m_arrayJobToJobCase;
   property p_arrayJobToResCase                      : TArrayCompatabilityCase  read m_arrayJobToResCase;
   property p_ArrayDaysOfLatedJobs                   : TArrayDaysOfLatedJobs    read m_ArrayDaysOfLatedJobs;

 end;

// procedure CleanInformationListById(Id : TSchedId; ResCode : string);
 procedure CleanAllInformationList(OnlyOvrlapList : boolean);
 function  SortByLowScore(Item1, Item2: Pointer): integer;
 procedure CleanLogList;
 procedure PrintLog(Name : string);
 procedure FillLogListLine(Action : string; Id : TSchedId; GenericPlan : boolean; InfoScoreRecord : PTScoreRecord; CompJobToRes : TCompatVal; score : double; LowestEndDateTime : TDateTime);
 function  RtvLogSize() : Integer;
 procedure RollBackFromList(RollDowntoIndex : integer);
 procedure CleanRollbackInfoList(RollDowntoIndex : Integer);
 procedure CleanPropList;
 function  FindIdInBackUpList(id : TschedId; ListBackup : TList) : PTJobInfo;
 function  FindRequestStepToReLoadResourcesInList(Id : TSchedId; List : TList; var Index : integer) : PTRequestStepsToReLoadResources;
 function  GetRollBackList : TList;
 function  GetPosInList(List : TList; id : TschedId) : Integer;
 function  SortOptionToSplit(Item1, Item2: Pointer): integer;
 function  AreIdsIdentical(Firstid, SecondId : TschedId; var LowestSubStepId : TschedId): boolean;
 procedure AddOrSubtructIdsQuantity(IdToChange, IdToLoad : TschedId; Add : boolean);
 procedure JoinTwoIds(IdToLeave, IdToRemove : TschedId);

//----------------------------------------------------------------------------//


implementation

uses UMObjCont, UMPlanObj, UMBinFunc, UMRank, UMCalcOverlaps, UMDurObj, UMPlan, UMBalance, UMPlanFunc, UMStoredProc,
     UMWkCtr, UMAutoSchedCfg, UMSchedObjMover, SysUtils, UMSchedList, FMMainPlan, UMglobal, UMCompatRules, UMWarp,
     UMCommon, UMResCat, Math, FMAutoSchedWorkCenterCfg, FMAutoSched, FmAutoRunSet, UMGenericSchedulePrevStep;

type

  TGenericPlan = record
    WorkCenterCode  : String;
    MinimumStartDateTime : TDateTime;
    PositionFound : boolean;
  end;
  PTGenericPlan = ^TGenericPlan;

  TOvlopLimit = record
    LowOvlopLimit : TDateTime;
    HighOvlpLimit : TDateTime;
    SetUp         : double;
  end;
  PTOvlopLimit = ^TOvlopLimit;

  TResOvlop = record
    m_ResCode    : string;
    m_OvlopLimit : TList;
  end;
  PTResOvlop = ^TResOvlop;

  TInformationBox = record
    m_ListStrRes      : TStringList;
    m_ListStrCmpToRes : TStringList;
    m_SupMinBaseList  : TStringList;
    m_DurationList    : TStringList;
    m_DurationListOrg : TStringList;
    m_Sndt_bch_Size   : TStringList;
    m_Min_bch_Size    : TStringList;
    m_Max_bch_Size    : TStringList;
    m_MinMaxOptQtyList  : TList;
//    m_ResListOvlop    : TList;
    m_DurationQuantityBase : Double;
    m_id   : TSchedId;
  end;
  PInformationBox = ^TInformationBox;

  TOverlapBox = record
    m_id              : TSchedId;
    m_ResListOvlop    : TList;
  end;
  PTOverlapBox = ^TOverlapBox;

{  TGenericPlanSchedInfo = record
    Id                  : TSchedId;
    Start               : TDateTime;
    GenericPlanWc       : string;
    GenericPlanDur      : double;
    GenericPlanleadTime : double;
    GenericPlanMachineNum : integer;
  end;
  PTGenericPlanSchedInfo = ^TGenericPlanSchedInfo;  }

  TRequestId = record
    Request    : string;
    Id         : TSchedId;
  end;
  PTRequestId = ^TRequestId;

  TPropListId = record
    PropList     : String;
    UniqueId     : integer;
  end;
  PTPropListId = ^TPropListId;

  TPropListSetup = record
    WorkCenterCode : String;
    CategoryCode : String;
    ResCode : String;
    IdUniqueId : Integer;
    PrevIdUniqueId : Integer;
    CompValJobToJob : TCompatVal;
    supRec : TSetupRec;
  end;
  PTPropListSetup = ^TPropListSetup;

var
  m_InformationBoxList : TList;
  m_LastId             : TSchedId;
  m_LastIdPos          : integer;
  m_ListLogId          : TList;
  m_rollbackInfoList   : TList;
  m_OverlapBoxList     : TList;
  m_LastOvrlapId       : TSchedId;
  m_LastOverlapIdPos   : Integer;
  m_PropListId : Tlist;
  m_PropListSetup : Tlist;

//----------------------------------------------------------------------------//

function SortOptionToSplit(Item1, Item2: Pointer): integer;
var
  OptionToSplit1 : PTOptionToSplit;
  OptionToSplit2 : PTOptionToSplit;
begin
  OptionToSplit1 := PTOptionToSplit(Item1);
  OptionToSplit2 := PTOptionToSplit(Item2);
  if OptionToSplit1.SplitsList.Count < OptionToSplit2.SplitsList.Count then
    Result := -1
  else if (OptionToSplit1.SplitsList.Count > OptionToSplit2.SplitsList.Count) then
    Result := 1
  else
    Result := 0;
end;

//----------------------------------------------------------------------------//

function SortByRequest(Item1, Item2: Pointer): integer;
var
  MQMPR1 : PTRequestId;
  MQMPR2 : PTRequestId;
begin
  MQMPR1 := PTRequestId(Item1);
  MQMPR2 := PTRequestId(Item2);
  if MQMPR1.Request < MQMPR2.Request then
    Result := -1
  else if (MQMPR1.Request > MQMPR2.Request) then
    Result := 1
  else
    Result := 0;
end;

//----------------------------------------------------------------------------//

function SortByIdAndRes(Item1, Item2: Pointer): integer;
var
  MQMPR1 : PTSetupCompactInfo;
  MQMPR2 : PTSetupCompactInfo;
begin
  MQMPR1 := PTSetupCompactInfo(Item1);
  MQMPR2 := PTSetupCompactInfo(Item2);
  if MQMPR1.Id < MQMPR2.Id then
    Result := -1
  else if (MQMPR1.Id > MQMPR2.Id) then
    Result := 1
  else
  begin
    if MQMPR1.ResCode < MQMPR2.ResCode then
      Result := -1
    else if (MQMPR1.ResCode > MQMPR2.ResCode) then
      Result := 1
    else
      Result := 0;
  end;
end;

//----------------------------------------------------------------------------//

function FindResourceByCode(ResCode : string; AllResList : TList) : TResourcesStruct;
var
  i: integer;
  Multiplier, NumberOfEntries : integer;
begin
  Result := nil;

  NumberOfEntries := AllResList.Count;
  if NumberOfEntries = 0 then
  begin
    Exit;
  end;

  Multiplier := 1;
  while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    i := Multiplier - 1;

  while (Multiplier > 0) do
  begin

    if  (i < NumberOfEntries)
      and (TResourcesStruct(AllResList[i]).m_ResCode = ResCode) then break;

    Multiplier := trunc(Multiplier / 2);

    if  (i < NumberOfEntries) and (TResourcesStruct(AllResList[i]).m_ResCode < ResCode) then
      i := i + Multiplier
    else
      i := i - Multiplier;
  end;

  if Multiplier > 0 then
    Result := TResourcesStruct(AllResList[i]);

end;

//----------------------------------------------------------------------------//

function FindIdInBackUpList(id : TschedId; ListBackup : TList) : PTJobInfo;
var
  i: integer;
  Multiplier, NumberOfEntries : integer;
begin
  Result := nil;
  if id < ListBackup.Count then
  begin
    Result := PTJobInfo(ListBackup[Id]);
    if not Result.Valid then
      Result := nil;
  end;
end;

//----------------------------------------------------------------------------//

function FindInfoIdInMainList(Id : TschedId; MainListIDInfo : TList) : PTIdDetails;
var
  I: integer;
begin
  Result := nil;

  for I := 0 to MainListIDInfo.Count - 1 do
  begin
    if (PTIdDetails(MainListIDInfo[i]).Id <> Id) then continue;
    Result := PTIdDetails(MainListIDInfo[I]);
    break;
  end;

end;

//----------------------------------------------------------------------------//

function GetRollBackList : TList;
begin
  Result := m_rollbackInfoList
end;

//----------------------------------------------------------------------------//

function GetPosInList(List : TList; id : TschedId) : Integer;
var
  I : Integer;
begin
  Result := -1;
  for I := 0 to List.count - 1 do
  begin
    if PTJobToSched(List[I]).Id = id then
    begin
      Result := I;
      Exit
    end;
  end;
end;

//----------------------------------------------------------------------------//

function FindSetupCompactParamsInList(id : TschedId; ResCode : string; List_SetupCompactInfo : TList) : PTSetupCompactInfo;
var
  i: integer;
  Multiplier, NumberOfEntries, NumberOfEntriesMinusOne : integer;
begin
  Result := nil;

  NumberOfEntries := List_SetupCompactInfo.Count;
  if NumberOfEntries = 0 then exit;
  NumberOfEntriesMinusOne := NumberOfEntries - 1;

  Multiplier := 1;
  while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    i := Multiplier - 1;

  while (Multiplier > 0) do
  begin
    Multiplier := trunc(Multiplier / 2);

    if (i > NumberOfEntriesMinusOne)
    or ((PTSetupCompactInfo(List_SetupCompactInfo[i]).Id > id)) then
    begin
      i := i - Multiplier;
      Continue;
    end;

    if  (PTSetupCompactInfo(List_SetupCompactInfo[i]).Id < id) then
    begin
      i := i + Multiplier;
      Continue;
    end;

    if  (PTSetupCompactInfo(List_SetupCompactInfo[i]).ResCode < ResCode) then
    begin
      i := i + Multiplier;
      Continue;
    end;

    if  (PTSetupCompactInfo(List_SetupCompactInfo[i]).ResCode > ResCode) then
    begin
      i := i - Multiplier;
      Continue;
  end;

    Result := PTSetupCompactInfo(List_SetupCompactInfo[i]);
    Break;

  end;

end;

//----------------------------------------------------------------------------//

function FindRequestStepToReLoadResourcesInList(Id : TSchedId; List : TList; var Index : integer) : PTRequestStepsToReLoadResources;
var
  i: integer;
  Multiplier, NumberOfEntries, NumberOfEntriesMinusOne : integer;
  step : variant;
  Request : string;
  dataType: CBinColValType;
 // RequestStepsToReLoadResources : PTRequestStepsToReLoadResources;
begin
  NumberOfEntries := List.Count;
  Result := nil;
  Index := NumberOfEntries;

  if NumberOfEntries = 0 then exit;

 // p_sc.GetFldValue(Id , CSC_ProdReq, Request, dataType);
  Request := p_sc.GetRequestNumber(Id);
  p_sc.GetFldValue(Id , CSC_ProdStep, step, dataType);

  NumberOfEntriesMinusOne := NumberOfEntries - 1;
  Multiplier := 1;
  while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
  i := Multiplier - 1;

  while (Multiplier > 0) do
  begin
    Multiplier := trunc(Multiplier / 2);

    if (i > NumberOfEntriesMinusOne) then
    begin
      i := i - Multiplier;
      Continue;
    end;

    if (PTRequestStepsToReLoadResources(List[i]).Request > Request) then
    begin
      if I < Index then Index := I;
      i := i - Multiplier;
      Continue;
    end;

    if  (PTRequestStepsToReLoadResources(List[i]).Request < Request) then
    begin
      i := i + Multiplier;
      Continue;
    end;

    if  (PTRequestStepsToReLoadResources(List[i]).Step > Step) then
    begin
      if I < Index then Index := I;
      i := i - Multiplier;
      Continue;
    end;

    if  (PTRequestStepsToReLoadResources(List[i]).Step < Step) then
    begin
      i := i + Multiplier;
      Continue;
    end;

    Result := PTRequestStepsToReLoadResources(List[i]);
    Index := i;
    Break;

  end;

end;

//----------------------------------------------------------------------------//

function FindCurveByFamilyInfo(var List : TList; CurveCode : string; FamilyIdCode : string; CreateWhenNotExist : boolean) : PTCurveByFamilyInfo;
var
  i, Index : integer;
  Multiplier, NumberOfEntries, NumberOfEntriesMinusOne : integer;
  RequestStepsToReLoadResources : PTRequestStepsToReLoadResources;
  CurveByFamilyInfo : PTCurveByFamilyInfo;
begin
  NumberOfEntries := List.Count;
  Result := nil;
  Index := NumberOfEntries;

  if NumberOfEntries > 0 then
  begin
    NumberOfEntriesMinusOne := NumberOfEntries - 1;
    Multiplier := 1;
    while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    i := Multiplier - 1;

    while (Multiplier > 0) do
    begin
      Multiplier := trunc(Multiplier / 2);

      if (i > NumberOfEntriesMinusOne) then
      begin
        i := i - Multiplier;
        Continue;
      end;

      if  (PTCurveByFamilyInfo(List[i]).CurveCode > CurveCode) then
      begin
        if I < Index then Index := I;
        i := i - Multiplier;
        Continue;
      end;

      if  (PTCurveByFamilyInfo(List[i]).CurveCode < CurveCode) then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if  (PTCurveByFamilyInfo(List[i]).FamilyIdCode > FamilyIdCode) then
      begin
        if I < Index then Index := I;
        i := i - Multiplier;
        Continue;
      end;

      if  (PTCurveByFamilyInfo(List[i]).FamilyIdCode < FamilyIdCode) then
      begin
        i := i + Multiplier;
        Continue;
      end;

      Result := PTCurveByFamilyInfo(List[i]);
      Index := i;
      Break;

    end;

  end;

  if (Result = nil) and CreateWhenNotExist then
  begin
    new(CurveByFamilyInfo);
    CurveByFamilyInfo.CurveCode := CurveCode;
    CurveByFamilyInfo.FamilyIdCode := FamilyIdCode;
    CurveByFamilyInfo.OldIdsTimeBeforeCurve := 0;
    CurveByFamilyInfo.IdsList := TStringList.Create;
    CurveByFamilyInfo.IdsStartDate := TStringList.Create;
    CurveByFamilyInfo.IdDurationOrg := TStringList.Create;
    List.insert(Index, CurveByFamilyInfo);
    Result := CurveByFamilyInfo;
  end;

end;

//----------------------------------------------------------------------------//

procedure AfterInsertToSched(var List : TList; IdToSched : PTJobToSched);
var
  Id : TSchedId;
  CurveByFamilyInfo : PTCurveByFamilyInfo;
  I : Integer;
begin
  Id := IdToSched.Id;
  if (p_sc.GetLearningCurveType(Id) <> CSC_No) and (p_sc.GetCurveFamilyIdCode(Id) <> '') then
  begin
    CurveByFamilyInfo := FindCurveByFamilyInfo(List, p_sc.GetLearningCurveCode(Id), p_sc.GetCurveFamilyIdCode(Id), true);
    CurveByFamilyInfo.IdsList.Add(IntToStr(Id));
    CurveByFamilyInfo.IdsStartDate.Add(DateTimeToStr(IdToSched.StartSched));
    CurveByFamilyInfo.IdDurationOrg.Add(FloatToStr(IdToSched.durationOrg));
  end;

end;

//----------------------------------------------------------------------------//

procedure AfterSchedUpdated(List : TList; IdToSched : PTJobToSched);
var
  Id : TSchedId;
  I : integer;
  CurveByFamilyInfo : PTCurveByFamilyInfo;
begin
  Id := IdToSched.Id;
  if (p_sc.GetLearningCurveType(Id) <> CSC_No) and (p_sc.GetCurveFamilyIdCode(Id) <> '') then
  begin
    CurveByFamilyInfo := FindCurveByFamilyInfo(List, p_sc.GetLearningCurveCode(Id), p_sc.GetCurveFamilyIdCode(Id), false);
    for I := 0 to CurveByFamilyInfo.IdsList.Count - 1 do
    begin
      if Id = StrToInt(CurveByFamilyInfo.IdsList.Strings[I]) then
      begin
        CurveByFamilyInfo.IdsStartDate.Strings[I] := DateTimeToStr(IdToSched.StartSched);
        CurveByFamilyInfo.IdDurationOrg.Strings[I] := FloatToStr(IdToSched.durationOrg);
        break;
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure BeforeDeletedFromSched(List : TList; Id : TSchedId);
var
  CurveByFamilyInfo : PTCurveByFamilyInfo;
  I : Integer;
begin
  if (p_sc.GetLearningCurveType(Id) <> CSC_No) and (p_sc.GetCurveFamilyIdCode(Id) <> '') then
  begin
    CurveByFamilyInfo := FindCurveByFamilyInfo(List, p_sc.GetLearningCurveCode(Id), p_sc.GetCurveFamilyIdCode(Id), false);
    for I := 0 to CurveByFamilyInfo.IdsList.Count - 1 do
    begin
      if Id = StrToInt(CurveByFamilyInfo.IdsList.Strings[I]) then
      begin
        CurveByFamilyInfo.IdsList.delete(I);
        CurveByFamilyInfo.IdsStartDate.delete(I);
        CurveByFamilyInfo.IdDurationOrg.delete(I);
        break;
      end;
    end;

  end;

end;

//----------------------------------------------------------------------------//

function getCurveTotalsBeforeDate(Id : TSchedId; List : TList; Date : TDateTime) : Double;
var
  I : integer;
  CurveByFamilyInfo : PTCurveByFamilyInfo;
begin
  Result := 0;
  if (p_sc.GetLearningCurveType(Id) <> CSC_No) and (p_sc.GetCurveFamilyIdCode(Id) <> '') then
  begin
    CurveByFamilyInfo := FindCurveByFamilyInfo(List, p_sc.GetLearningCurveCode(Id), p_sc.GetCurveFamilyIdCode(Id), false);
    if CurveByFamilyInfo <> nil then
    begin
      Result := CurveByFamilyInfo.OldIdsTimeBeforeCurve;
      for I := 0 to CurveByFamilyInfo.IdsList.Count - 1 do
      begin
        if Date > StrToDateTime(CurveByFamilyInfo.IdsStartDate.Strings[I]) then
          Result := Result + StrToFloat(CurveByFamilyInfo.IdDurationOrg.Strings[I]);
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

function DoesCurveExistAfterDate(Id : TSchedId; List : TList; Date : TDateTime) : boolean;
var
  I : integer;
  CurveByFamilyInfo : PTCurveByFamilyInfo;
begin
  Result := false;
  if (p_sc.GetLearningCurveType(Id) <> CSC_No) and (p_sc.GetCurveFamilyIdCode(Id) <> '') then
  begin
    CurveByFamilyInfo := FindCurveByFamilyInfo(List, p_sc.GetLearningCurveCode(Id), p_sc.GetCurveFamilyIdCode(Id), false);
    if CurveByFamilyInfo <> nil then
    begin
      Result := false;
      for I := 0 to CurveByFamilyInfo.IdsList.Count - 1 do
      begin
        if Date <= StrToDateTime(CurveByFamilyInfo.IdsStartDate.Strings[I]) then
        begin
          Result := true;
          break;
        end;
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

function FindRequestInOverlapList(Request : string; List : TList) : PTRequestId;
var
  i: integer;
  Multiplier, NumberOfEntries : integer;
begin
  Result := nil;

  NumberOfEntries := List.Count;
  if NumberOfEntries = 0 then Exit;

  Multiplier := 1;
  while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
  i := Multiplier - 1;

  while (Multiplier > 0) do
  begin

    if  (i < NumberOfEntries) and (PTRequestId(List[i]).Request = Request) then
    begin
      Result := PTRequestId(List[i]);
      break;
    end;

    Multiplier := trunc(Multiplier / 2);

    if  (i < NumberOfEntries) and (PTRequestId(List[i]).Request < Request) then
      i := i + Multiplier
    else
      i := i - Multiplier;
  end;

end;

//----------------------------------------------------------------------------//

function SortInformationBoxById(Item1, Item2: Pointer): integer;
var
  MQMPR1 : PInformationBox;
  MQMPR2 : PInformationBox;
begin
  MQMPR1 := PInformationBox(Item1);
  MQMPR2 := PInformationBox(Item2);
  if MQMPR1.m_id < MQMPR2.m_id then
    Result := -1
  else if (MQMPR1.m_id = MQMPR2.m_id) then
    Result := 0
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function SortOverlapBoxById(Item1, Item2: Pointer): integer;
var
  MQMPR1 : PTOverlapBox;
  MQMPR2 : PTOverlapBox;
begin
  MQMPR1 := PTOverlapBox(Item1);
  MQMPR2 := PTOverlapBox(Item2);
  if MQMPR1.m_id < MQMPR2.m_id then
    Result := -1
  else if (MQMPR1.m_id = MQMPR2.m_id) then
    Result := 0
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function GetInformationById(IdToCheck : TSchedId; var ListStrCmpToRes, ListStrSupMinBase, ListStrDuration, ListStrDurationOrg, ListStrStandBchSize, ListStrMinBchSize, ListStrMaxBchSize : TStringList; var Pos : integer; var DurationQuantityBase : double) : TStringList;
var
  i: integer;
  Multiplier, NumberOfEntries : integer;
  Id, ChildId, GrpId  : TSchedId;
begin
  Result := nil;
  ListStrCmpToRes := nil;
  Pos := -1;

  Id := IdToCheck;
  {if p_sc.IsGroup(id) then
  begin
    ChildId := p_sc.GetGrpSon(Id, 0);
    if p_sc.GetJobNumBrothers(ChildId) > 1 then
    begin
      ChildId := p_sc.GetJobLowestBrother(ChildId);
      GrpId := p_sc.GetGroup(ChildId);
      if GrpId <> -1 then
         Id := GrpId;
    end;
  end
  else
  begin
    if p_sc.GetJobNumBrothers(id) > 1 then
    begin
      id := p_sc.GetJobLowestBrother(id);
    end;
  end; }

  if m_LastId = Id then
  begin
    if (m_LastIdPos >= 0) and (m_LastIdPos < m_InformationBoxList.Count) then
    begin
      if (PInformationBox(m_InformationBoxList[m_LastIdPos]).m_id = m_LastId) then
      begin
        Result := PInformationBox(m_InformationBoxList[m_LastIdPos]).m_ListStrRes;
        ListStrCmpToRes := PInformationBox(m_InformationBoxList[m_LastIdPos]).m_ListStrCmpToRes;
        ListStrSupMinBase := PInformationBox(m_InformationBoxList[m_LastIdPos]).m_SupMinBaseList;
        ListStrDuration := PInformationBox(m_InformationBoxList[m_LastIdPos]).m_DurationList;
        ListStrDurationOrg := PInformationBox(m_InformationBoxList[m_LastIdPos]).m_DurationListOrg;
        ListStrStandBchSize := PInformationBox(m_InformationBoxList[m_LastIdPos]).m_Sndt_bch_Size;
        ListStrMinBchSize   := PInformationBox(m_InformationBoxList[m_LastIdPos]).m_Min_bch_Size;
        ListStrMaxBchSize   := PInformationBox(m_InformationBoxList[m_LastIdPos]).m_Max_bch_Size;
        DurationQuantityBase := PInformationBox(m_InformationBoxList[m_LastIdPos]).m_DurationQuantityBase;
        Pos := m_LastIdPos;
        exit;
      end;
    end;
  end;

  NumberOfEntries := m_InformationBoxList.Count;
  if NumberOfEntries = 0 then Exit;

  if NumberOfEntries > 64 then
    Multiplier := 128
  else
    Multiplier := 1;
  while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    i := Multiplier - 1;

  while (Multiplier > 0) do
  begin

    if  (i < NumberOfEntries)
      and (PInformationBox(m_InformationBoxList[i]).m_id = Id) then break;

    Multiplier := trunc(Multiplier / 2);

    if  (i < NumberOfEntries) and (PInformationBox(m_InformationBoxList[i]).m_id < Id) then
      i := i + Multiplier
    else
      i := i - Multiplier;
  end;

  if Multiplier > 0 then
  begin
    Result := PInformationBox(m_InformationBoxList[i]).m_ListStrRes;
    ListStrCmpToRes := PInformationBox(m_InformationBoxList[i]).m_ListStrCmpToRes;
    ListStrSupMinBase := PInformationBox(m_InformationBoxList[i]).m_SupMinBaseList;
    ListStrDuration := PInformationBox(m_InformationBoxList[i]).m_DurationList;
    ListStrDurationOrg := PInformationBox(m_InformationBoxList[i]).m_DurationListOrg;
    ListStrStandBchSize := PInformationBox(m_InformationBoxList[i]).m_Sndt_bch_Size;
    ListStrMinBchSize   := PInformationBox(m_InformationBoxList[i]).m_Min_bch_Size;
    ListStrMaxBchSize   := PInformationBox(m_InformationBoxList[i]).m_Max_bch_Size;
    DurationQuantityBase := PInformationBox(m_InformationBoxList[i]).m_DurationQuantityBase;
    Pos := i;
    m_LastId := Id;
    m_LastIdPos := i;
  end;

end;

//----------------------------------------------------------------------------//

function GetOverlapById(Id : TSchedId) : Integer;
var
  i: integer;
  Multiplier, NumberOfEntries : integer;
begin
  Result := -1;

  if m_LastOvrlapId = Id then
  begin
    if (m_LastOverlapIdPos >= 0) and (m_LastOverlapIdPos < m_OverlapBoxList.Count) then
    begin
      if (PTOverlapBox(m_OverlapBoxList[m_LastOverlapIdPos]).m_id = m_LastOvrlapId) then
      begin
        Result := m_LastOverlapIdPos;
        exit;
      end;
    end;
  end;

   NumberOfEntries := m_OverlapBoxList.Count;
  if NumberOfEntries = 0 then Exit;

  if NumberOfEntries > 64 then
    Multiplier := 128
  else
    Multiplier := 1;
  while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    i := Multiplier - 1;

  while (Multiplier > 0) do
  begin

    if  (i < NumberOfEntries)
      and (PTOverlapBox(m_OverlapBoxList[i]).m_id = Id) then break;

    Multiplier := trunc(Multiplier / 2);

    if  (i < NumberOfEntries) and (PTOverlapBox(m_OverlapBoxList[i]).m_id < Id) then
      i := i + Multiplier
    else
      i := i - Multiplier;
  end;

  if Multiplier > 0 then
  begin
    Result := i;
    m_LastOvrlapId := Id;
    m_LastOverlapIdPos := i;
  end;

end;

//----------------------------------------------------------------------------//

function sortmResOvlopList(Item1, Item2: Pointer): integer;
var
  MQMPR1 : PTResOvlop;
  MQMPR2 : PTResOvlop;
begin
  MQMPR1 := PTResOvlop(Item1);
  MQMPR2 := PTResOvlop(Item2);
  if MQMPR1.m_ResCode < MQMPR2.m_ResCode then
    Result := -1
  else if (MQMPR1.m_ResCode = MQMPR2.m_ResCode) then
    Result := 0
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function SortByResCode(Item1, Item2: Pointer): integer;
var
  MQMPR1 : TResourcesStruct;
  MQMPR2 : TResourcesStruct;
begin
  MQMPR1 := TResourcesStruct(Item1);
  MQMPR2 := TResourcesStruct(Item2);
  if MQMPR1.m_ResCode < MQMPR2.m_ResCode then
    Result := -1
  else if (MQMPR1.m_ResCode = MQMPR2.m_ResCode) then
    Result := 0
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function SortByPlanTypeAndCode(Item1, Item2: Pointer): integer;
var
  MQMPR1 : TResourcesStruct;
  MQMPR2 : TResourcesStruct;
begin
  MQMPR1 := TResourcesStruct(Item1);
  MQMPR2 := TResourcesStruct(Item2);
  if MQMPR1.m_PlanType < MQMPR2.m_PlanType then
    Result := -1
  else if (MQMPR1.m_PlanType = MQMPR2.m_PlanType) then
  begin
    if MQMPR1.m_ResCode < MQMPR2.m_ResCode then
      Result := -1
    else if (MQMPR1.m_ResCode = MQMPR2.m_ResCode) then
      Result := 0
    else
      Result := 1;
  end
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function SortByWcCatResCode(Item1, Item2: Pointer): integer;
var
  MQMPR1 : TResourcesStruct;
  MQMPR2 : TResourcesStruct;
  Wc1, Wc2, Cat1 , Cat2 : string;
begin
  MQMPR1 := TResourcesStruct(Item1);
  MQMPR2 := TResourcesStruct(Item2);

  Wc1 := TMqmWrkCtr(TMqmRes(TMQMVisibleRes(MQMPR1.m_ResPtr).p_Father).p_Father).p_WrkCtrCode;
  Wc2 := TMqmWrkCtr(TMqmRes(TMQMVisibleRes(MQMPR2.m_ResPtr).p_Father).p_Father).p_WrkCtrCode;
  Cat1 := TMqmResCat(TMqmRes(TMQMVisibleRes(MQMPR1.m_ResPtr).p_Father).m_ResCat).p_ResCatCode;
  Cat2 := TMqmResCat(TMqmRes(TMQMVisibleRes(MQMPR2.m_ResPtr).p_Father).m_ResCat).p_ResCatCode;

  if Wc1 < Wc2 then
  begin
    Result := -1;
    Exit;
  end;

  if Wc1 > Wc2 then
  begin
    Result := 1;
    Exit;
  end;

  if Cat1 < Cat2 then
  begin
    Result := -1;
    Exit;
  end;

  if Cat1 > Cat2 then
  begin
    Result := 1;
    Exit;
  end;

  if MQMPR1.m_ResCode < MQMPR2.m_ResCode then
  begin
    Result := -1;
    Exit;
  end;

  if MQMPR1.m_ResCode > MQMPR2.m_ResCode then
  begin
    Result := 1;
    Exit;
  end;

  Result := 0;

end;

//----------------------------------------------------------------------------//


function GetOvrlpResForId(ResCode : string; List : TList) : TList;
var
  i: integer;
  Multiplier, NumberOfEntries : integer;
  PResOvlop : PTResOvlop;
begin
//  Result := nil;
  I := -1;
  NumberOfEntries := List.Count;
  if NumberOfEntries = 0 then
     Multiplier := 0
  else
  begin
    Multiplier := 1;
    while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
      i := Multiplier - 1;
    while (Multiplier > 0) do
    begin
      if  (i < NumberOfEntries)
        and (PTResOvlop(List[i]).m_ResCode = ResCode) then break;
      Multiplier := trunc(Multiplier / 2);
      if  (i < NumberOfEntries) and (PTResOvlop(List[i]).m_ResCode < ResCode) then
        i := i + Multiplier
      else
        i := i - Multiplier;
    end;
  end;

  if Multiplier > 0 then
  begin
    Result := PTResOvlop(List[i]).m_OvlopLimit;
  end
  else
  begin
    new(PResOvlop);
    PResOvlop.m_ResCode := ResCode;
    PResOvlop.m_OvlopLimit := TList.Create;
    List.Add(PResOvlop);
    List.sort(sortmResOvlopList);
    Result := PResOvlop.m_OvlopLimit
  end;

end;

//----------------------------------------------------------------------------//

function FindOverlapsForSetUp(Id : TSchedId; var PosInList : Integer; ResCode : string; Setup : double; var LowOvlopLimit : TDateTime; var HighOvlpLimit : TDateTime): boolean;
var
  Pos, I : integer;
  OverlapBox : PTOverlapBox;
  OvlopList      : TList;
begin
  result := false;
  Pos := GetOverlapById(Id);
  PosInList := Pos;
  if Pos > -1 then
  begin
    OverlapBox := PTOverlapBox(m_OverlapBoxList[Pos]);
    OvlopList := GetOvrlpResForId(ResCode, OverlapBox.m_ResListOvlop);

    for I := 0 to OvlopList.Count - 1 do
    begin
      if PTOvlopLimit(OvlopList[I]).SetUp = SetUp then
      begin
        Result := true;
        LowOvlopLimit := PTOvlopLimit(OvlopList[I]).LowOvlopLimit;
        HighOvlpLimit := PTOvlopLimit(OvlopList[I]).HighOvlpLimit;
        Exit
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure AddOverlapsForSetUp(Id : TSchedId ;Pos : Integer; ResCode : string; SetUp : double; LowOvlopLimit : TDateTime; HighOvlpLimit : TDateTime);
var
  OvlopLimit : PTOvlopLimit;
  POverlapBox : PTOverlapBox;
  OvlopList : TList;
begin
  if (Pos < 0) or (Pos > m_OverlapBoxList.Count - 1) then
  begin
    new(POverlapBox);
    POverlapBox.m_id := Id;
    POverlapBox.m_ResListOvlop := TList.Create;
    m_OverlapBoxList.add(POverlapBox);
    m_OverlapBoxList.sort(SortOverlapBoxById)
  end
  else
    POverlapBox := PTOverlapBox(m_OverlapBoxList[Pos]);
  OvlopList := GetOvrlpResForId(ResCode, POverlapBox.m_ResListOvlop);
  new(OvlopLimit);
  OvlopLimit.LowOvlopLimit := LowOvlopLimit;
  OvlopLimit.HighOvlpLimit := HighOvlpLimit;
  OvlopLimit.SetUp         := SetUp;
  OvlopList.Add(OvlopLimit);
end;

//----------------------------------------------------------------------------//

procedure CleanLogList;
var
  I : integer;
begin
  for I := m_ListLogId.Count - 1 downto 0 do
     dispose(PTlogInfo(m_ListLogId[I]));
  m_ListLogId.Clear
end;

//----------------------------------------------------------------------------//

function AdjustStringMaxLength(CurrentLength : Integer; StringContent : string) : integer;
var
  StringLength : Integer;
begin
  Result := CurrentLength;
  try
    StringLength := Length(StringContent);
  Except
    StringLength := 0;
  end;
  StringLength := StringLength + 1;
  if CurrentLength < StringLength then
    Result := StringLength
end;


//----------------------------------------------------------------------------//

function AdjustStringToItsMaxLength(MaxLength : Integer; StringContent : string) : String;
var
  StringLength : Integer;
  Gap : Integer;
begin
  Result := StringContent;
  try
    StringLength := Length(StringContent);
  Except
    StringLength := 0;
  end;
  if MaxLength > StringLength then
  begin
    Gap := MaxLength - StringLength;
    while Gap > 0 do
    begin
      Gap := Gap - 1;
      Result := Result + ' ';
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure PrintLog(Name : string);
var
  PLogInfo : PTLogInfo;
  LogStringList : TStringList;
  I : Integer;
  Infoline, InfolineHeadr  : string;
  ActionHeading : string;
  RequestIdHeading : string;
  ResCodeHeading      : string;
  JobToResCaseHeading : string;
  RequestPrevIdHeading : string;
  JobToJobCaseHeading  : string;
  SCheduledDatesHeading : string;
  setUpHeading          : string;
  ScoreHeading : String;
  GapHeading : String;
  DurHeading : String;
  LowestDateTimeHeading      : string;
  GenericPlanStartHeading    : string;
  GenericPlanEndHeading      : string;
  GenericPlanWCHeading       : string;
  GenericPlanDurationHeading : string;
  GenericPlanLeadTimeHeading : string;
  GenericPlanMachineHeading  : string;
  ServingGroupHeading : string;
  ServinglowestDateHeading : string;
  ServingHighestDateHeading : string;
  PrintALine : String;

  ActionLength         : Integer;
  RequestIdLength      : Integer;
  ResCodeLength        : Integer;
  JobToResCaseLength   : Integer;
  RequestPrevIdLength  : Integer;
  JobToJobCaseLength   : Integer;
  SCheduledDatesLength  : Integer;
  setUpLength          : Integer;
  ScoreLength          : Integer;
  GapLength            : Integer;
  DurLength            : Integer;
  LowestDateTimeLength   : Integer;
  GenericPlanStartLength : Integer;
  GenericPlanEndLength   : Integer;
  GenericPlanWCLength    : Integer;
  GenericPlanDurationLength : Integer;
  GenericPlanLeadTimeLength : Integer;
  GenericPlanMachineLength : Integer;
  ServingGroupLength       : Integer;
  ServinglowestDateLength  : Integer;
  ServingHighestDateLength : Integer;
//  planInfo: TSQplanInfo;
begin
  PrintALine := '';
  for I := 1 to 294 do
  begin
    PrintALine := PrintALine + '-';
  end;

  LogStringList := TStringList.Create;
  LogStringList.Add('Log action key : ');

  LogStringList.Add('Start - Start analyzing a job to schedule');

  LogStringList.Add('ENDAfterLastTest - checking last position.');
  LogStringList.Add('ENDAfterLastOk   - the position choosen out of all last position.');

  LogStringList.Add('StartMove - Start analyzing between and with moving for the job.');

  LogStringList.Add('BTWTestOk - possible position between two jobs.');

  LogStringList.Add('MOVMainTest - "check" position for the main job before moving the next jobs');
  LogStringList.Add('MOVMainTestOk - the "checked" position was ok for main job');

  LogStringList.Add('There will be now for pushed jobs many : ENDAfterLastTest  + ENDAfterLastOk');
  LogStringList.Add('MoveOtherTestOk - the position chosen out of all last position for the moved (Pushed) job.');

  LogStringList.Add('ENDSelected - Out of last position and between and move - the best was the check after the last positions and that was selected.');
  LogStringList.Add('BTWSelected -  Out of last position and between and move - the best was the between.');
  LogStringList.Add('MOVMainSelected - Out of last position and between and move - the best was the move - and this is the main job schedule.');
  LogStringList.Add('MOVOtherSelected - same as MOVMainSelected  - for the pushed jobs.');

  ActionLength         := 0;
  RequestIdLength      := 0;
  ResCodeLength        := 0;
  JobToResCaseLength   := 0;
  RequestPrevIdLength  := 0;
  JobToJobCaseLength   := 0;
  SCheduledDatesLength   := 0;
  setUpLength          := 0;
  ScoreLength          := 0;
  GapLength            := 0;
  DurLength            := 0;
  LowestDateTimeLength := 0;
  GenericPlanStartLength := 0;
  GenericPlanEndLength   := 0;
  GenericPlanWCLength    := 0;
  GenericPlanDurationLength := 0;
  GenericPlanLeadTimeLength := 0;
  GenericPlanMachineLength := 0;
  ServingGroupLength       := 0;
  ServinglowestDateLength  := 0;
  ServingHighestDateLength := 0;

  ActionHeading          := 'Action';
  RequestIdHeading       := 'Request';
  ResCodeHeading         := 'Res';
  JobToResCaseHeading    := 'Case';
  RequestPrevIdHeading   := 'Prev.Request';
  JobToJobCaseHeading    := 'Case';
  SCheduledDatesHeading  := 'SCheduled Dates';
  setUpHeading           := 'Setup';
  ScoreHeading           := 'Score';
  GapHeading             := 'Gap';
  DurHeading             := 'Dur';
  LowestDateTimeHeading  := 'Lowest date';
  GenericPlanStartHeading    := 'GPStart';
  GenericPlanEndHeading      := 'GPEnd';
  GenericPlanWCHeading       := 'GPWC';
  GenericPlanDurationHeading := 'GPDuration';
  GenericPlanLeadTimeHeading := 'GPTime';
  GenericPlanMachineHeading  := 'GPMachine';
  ServingGroupHeading := 'ServingGroup';
  ServinglowestDateHeading := 'ServinglowestDate';
  ServingHighestDateHeading := 'ServingHighestDate';

  ActionLength         := AdjustStringMaxLength(ActionLength, ActionHeading);
  RequestIdLength      := AdjustStringMaxLength(RequestIdLength, RequestIdHeading);
  ResCodeLength        := AdjustStringMaxLength(ResCodeLength, ResCodeHeading);
  JobToResCaseLength   := AdjustStringMaxLength(JobToResCaseLength, JobToResCaseHeading);
  RequestPrevIdLength  := AdjustStringMaxLength(RequestPrevIdLength, RequestPrevIdHeading);
  JobToJobCaseLength   := AdjustStringMaxLength(JobToJobCaseLength, JobToJobCaseHeading);
  SCheduledDatesLength := AdjustStringMaxLength(SCheduledDatesLength, SCheduledDatesHeading);
  setUpLength          := AdjustStringMaxLength(setUpLength, setUpHeading);
  ScoreLength          := AdjustStringMaxLength(ScoreLength, ScoreHeading);
  GapLength            := AdjustStringMaxLength(GapLength, GapHeading);
  DurLength            := AdjustStringMaxLength(DurLength, DurHeading);
  LowestDateTimeLength := AdjustStringMaxLength(LowestDateTimeLength, LowestDateTimeHeading);
  GenericPlanStartLength    := AdjustStringMaxLength(GenericPlanStartLength, GenericPlanStartHeading);
  GenericPlanEndLength      := AdjustStringMaxLength(GenericPlanEndLength, GenericPlanEndHeading);
  GenericPlanWCLength       := AdjustStringMaxLength(GenericPlanWCLength, GenericPlanWCHeading);
  GenericPlanDurationLength := AdjustStringMaxLength(GenericPlanDurationLength, GenericPlanDurationHeading);
  GenericPlanLeadTimeLength := AdjustStringMaxLength(GenericPlanLeadTimeLength, GenericPlanLeadTimeHeading);
  GenericPlanMachineLength := AdjustStringMaxLength(GenericPlanMachineLength, GenericPlanMachineHeading);
  ServingGroupLength       := AdjustStringMaxLength(ServingGroupLength, ServingGroupHeading);
  ServinglowestDateLength  := AdjustStringMaxLength(ServinglowestDateLength, ServinglowestDateHeading);
  ServingHighestDateLength := AdjustStringMaxLength(ServingHighestDateLength, ServingHighestDateHeading);

  for I := 0 to m_ListLogId.Count - 1 do
  begin
    PLogInfo := PTLogInfo(m_ListLogId[I]);
    if PLogInfo.Action = 'RollBack' then continue;
    ActionLength         := AdjustStringMaxLength(ActionLength,  PLogInfo.Action);
    RequestIdLength      := AdjustStringMaxLength(RequestIdLength, PLogInfo.ReqStepSubStep_ID);
    if (PLogInfo.Action = 'Start') or (PLogInfo.Action = 'StartMove') then continue;
    ResCodeLength        := AdjustStringMaxLength(ResCodeLength, PLogInfo.rescode);
    JobToResCaseLength   := AdjustStringMaxLength(JobToResCaseLength, FloatToStr(PLogInfo.CompValJobToRes));
    RequestPrevIdLength  := AdjustStringMaxLength(RequestPrevIdLength, PLogInfo.Prev_ReqStepSubStep_ID);
    JobToJobCaseLength   := AdjustStringMaxLength(JobToJobCaseLength, FloatToStr(PLogInfo.CompValJobToJob));
    SCheduledDatesLength := AdjustStringMaxLength(SCheduledDatesLength, DateTimeToStr(PLogInfo.StartDate) + ' ' +  DateTimeToStr(PLogInfo.EndDate));
    if PLogInfo.setup < 1 then
       PLogInfo.setup := 0;
    setUpLength          := AdjustStringMaxLength(setUpLength, FloatToStr(PLogInfo.setup));
    ScoreLength          := AdjustStringMaxLength(ScoreLength, FloatToStr(PLogInfo.Score));
    GapLength            := AdjustStringMaxLength(GapLength,   FloatToStr(PLogInfo.Gap) +  ' m');
    DurLength            := AdjustStringMaxLength(DurLength,   FloatToStr(PLogInfo.Duration));
    LowestDateTimeLength := AdjustStringMaxLength(LowestDateTimeLength, DateTimeToStr(PLogInfo.LowestEndDateTime));

    if PLogInfo.GenericPlanWc <> '' then
    begin
      GenericPlanStartLength    := AdjustStringMaxLength(GenericPlanStartLength, DateTimeToStr(PLogInfo.GenericPlanStartDate));
      GenericPlanEndLength      := AdjustStringMaxLength(GenericPlanEndLength, DateTimeToStr(PLogInfo.GenericPlanEndDate));
      GenericPlanWCLength       := AdjustStringMaxLength(GenericPlanWCLength, PLogInfo.GenericPlanWC);
      GenericPlanDurationLength := AdjustStringMaxLength(GenericPlanDurationLength, FloatToStr(PLogInfo.GenericPlanDuration));
      GenericPlanLeadTimeLength := AdjustStringMaxLength(GenericPlanLeadTimeLength, FloatToStr(PLogInfo.GenericPlanLeadTime));
      GenericPlanMachineLength := AdjustStringMaxLength(GenericPlanMachineLength, IntToStr(PLogInfo.GenericPlanMachine));
    end;
    if PLogInfo.ServingGroup <> '' then
    begin
      ServingGroupLength           := AdjustStringMaxLength(ServingGroupLength, PLogInfo.ServingGroup);
      ServinglowestDateLength      := AdjustStringMaxLength(ServinglowestDateLength, DateTimeToStr(PLogInfo.ServinglowestDate));
      ServingHighestDateLength      := AdjustStringMaxLength(ServingHighestDateLength, DateTimeToStr(PLogInfo.ServingHighestDate));
    end;
  end;

  for I := 0 to m_ListLogId.Count - 1 do
  begin
    PLogInfo := PTLogInfo(m_ListLogId[I]);

    if PLogInfo.Action = 'RollBack' then
    begin
      LogStringList.Add('RollBack');
      continue;
    end;

    Infoline := '';
    Infoline := Infoline + AdjustStringToItsMaxLength(ActionLength, PLogInfo.Action);
    Infoline := Infoline + AdjustStringToItsMaxLength(RequestIdLength, PLogInfo.ReqStepSubStep_ID);

    if (PLogInfo.Action = 'Start') then
    begin
       LogStringList.Add('');
       InfolineHeadr := '';
       InfolineHeadr := InfolineHeadr + AdjustStringToItsMaxLength(ActionLength,    ActionHeading);
       InfolineHeadr := InfolineHeadr + AdjustStringToItsMaxLength(RequestIdLength, RequestIdHeading);
       InfolineHeadr := InfolineHeadr + AdjustStringToItsMaxLength(ResCodeLength, ResCodeHeading);
       InfolineHeadr := InfolineHeadr + AdjustStringToItsMaxLength(JobToResCaseLength, JobToResCaseHeading);
       InfolineHeadr := InfolineHeadr + AdjustStringToItsMaxLength(RequestPrevIdLength, RequestPrevIdHeading);
       InfolineHeadr := InfolineHeadr + AdjustStringToItsMaxLength(JobToJobCaseLength, JobToJobCaseHeading);
       InfolineHeadr := InfolineHeadr + AdjustStringToItsMaxLength(SCheduledDatesLength, SCheduledDatesHeading);
       InfolineHeadr := InfolineHeadr + AdjustStringToItsMaxLength(setUpLength, setUpHeading);
       InfolineHeadr := InfolineHeadr + AdjustStringToItsMaxLength(ScoreLength, ScoreHeading);
       InfolineHeadr := InfolineHeadr + AdjustStringToItsMaxLength(GapLength, GapHeading);
       InfolineHeadr := InfolineHeadr + AdjustStringToItsMaxLength(DurLength, DurHeading);
       InfolineHeadr := InfolineHeadr + AdjustStringToItsMaxLength(LowestDateTimeLength, LowestDateTimeHeading);
       InfolineHeadr := InfolineHeadr + AdjustStringToItsMaxLength(GenericPlanStartLength, GenericPlanStartHeading);
       InfolineHeadr := InfolineHeadr + AdjustStringToItsMaxLength(GenericPlanEndLength, GenericPlanEndHeading);
       InfolineHeadr := InfolineHeadr + AdjustStringToItsMaxLength(GenericPlanWCLength, GenericPlanWCHeading);
       InfolineHeadr := InfolineHeadr + AdjustStringToItsMaxLength(GenericPlanDurationLength, GenericPlanDurationHeading);
       InfolineHeadr := InfolineHeadr + AdjustStringToItsMaxLength(GenericPlanLeadTimeLength, GenericPlanLeadTimeHeading);
       InfolineHeadr := InfolineHeadr + AdjustStringToItsMaxLength(GenericPlanMachineLength, GenericPlanMachineHeading);
       InfolineHeadr := InfolineHeadr + AdjustStringToItsMaxLength(ServingGroupLength, ServingGroupHeading);
       InfolineHeadr := InfolineHeadr + AdjustStringToItsMaxLength(ServinglowestDateLength, ServinglowestDateHeading);
       InfolineHeadr := InfolineHeadr + AdjustStringToItsMaxLength(ServingHighestDateLength, ServingHighestDateHeading);

       LogStringList.Add(InfolineHeadr);
       LogStringList.Add(PrintALine);
    end;

    if (PLogInfo.Action <> 'Start') and (PLogInfo.Action <> 'StartMove') then
    begin
      Infoline := Infoline + AdjustStringToItsMaxLength(ResCodeLength, PLogInfo.rescode);
      Infoline := Infoline + AdjustStringToItsMaxLength(JobToResCaseLength, FloatToStr(PLogInfo.CompValJobToRes));
      Infoline := Infoline + AdjustStringToItsMaxLength(RequestPrevIdLength, PLogInfo.Prev_ReqStepSubStep_ID);
      Infoline := Infoline + AdjustStringToItsMaxLength(JobToJobCaseLength, FloatToStr(PLogInfo.CompValJobToJob));
      Infoline := Infoline + AdjustStringToItsMaxLength(SCheduledDatesLength, DateTimeToStr(PLogInfo.StartDate) + ' ' +  DateTimeToStr(PLogInfo.EndDate));
      Infoline := Infoline + AdjustStringToItsMaxLength(setUpLength, FloatToStr(PLogInfo.setup));
      Infoline := Infoline + AdjustStringToItsMaxLength(ScoreLength, FloatToStr(PLogInfo.Score));
      Infoline := Infoline + AdjustStringToItsMaxLength(GapLength,   FloatToStr(PLogInfo.Gap) + ' m');
      Infoline := Infoline + AdjustStringToItsMaxLength(DurLength,   FloatToStr(PLogInfo.Duration));
      Infoline := InfoLine + AdjustStringToItsMaxLength(LowestDateTimeLength, DateTimeToStr(PLogInfo.LowestEndDateTime));

      if PLogInfo.GenericPlanWc <> '' then
      begin
        Infoline := Infoline + AdjustStringToItsMaxLength(GenericPlanStartLength, DateTimeToStr(PLogInfo.GenericPlanStartDate));
        Infoline := Infoline + AdjustStringToItsMaxLength(GenericPlanEndLength, DateTimeToStr(PLogInfo.GenericPlanEndDate));
        Infoline := Infoline + AdjustStringToItsMaxLength(GenericPlanWCLength, PLogInfo.GenericPlanWC);
        Infoline := Infoline + AdjustStringToItsMaxLength(GenericPlanDurationLength, FloatToStr(PLogInfo.GenericPlanDuration));
        Infoline := Infoline + AdjustStringToItsMaxLength(GenericPlanLeadTimeLength, FloatToStr(PLogInfo.GenericPlanLeadTime));
        Infoline := Infoline + AdjustStringToItsMaxLength(GenericPlanMachineLength, IntToStr(PLogInfo.GenericPlanMachine));
      end
      else
      begin
        Infoline := Infoline + AdjustStringToItsMaxLength(GenericPlanStartLength, ' ');
        Infoline := Infoline + AdjustStringToItsMaxLength(GenericPlanEndLength, ' ');
        Infoline := Infoline + AdjustStringToItsMaxLength(GenericPlanWCLength, ' ');
        Infoline := Infoline + AdjustStringToItsMaxLength(GenericPlanDurationLength, ' ');
        Infoline := Infoline + AdjustStringToItsMaxLength(GenericPlanLeadTimeLength, ' ');
        Infoline := Infoline + AdjustStringToItsMaxLength(GenericPlanMachineLength, ' ');
      end;

      if (trim(PLogInfo.ServingGroup) <> '') then
      begin
        Infoline := Infoline + AdjustStringToItsMaxLength(ServingGroupLength, PLogInfo.ServingGroup);
        Infoline := Infoline + AdjustStringToItsMaxLength(ServinglowestDateLength, DateTimeToStr(PLogInfo.ServinglowestDate));
        Infoline := Infoline + AdjustStringToItsMaxLength(ServingHighestDateLength, DateTimeToStr(PLogInfo.ServingHighestDate));
      end;

    end;
    LogStringList.Add(Infoline);
  end;

  if trim(AutoSchedCfg.m_LogLocation) <> '' then
     LogStringList.SaveToFile(AutoSchedCfg.m_LogLocation + '\' + Name + '.txt')
  else
  begin
    CreateDir(LocAppGlobals.AppDir + '\' + 'AutoSeqLog');
    LogStringList.SaveToFile(LocAppGlobals.AppDir + '\AutoSeqLog\' + Name + '.txt' );
  end;
  LogStringList.Clear;
  LogStringList.Free;
end;

//----------------------------------------------------------------------------//

procedure FillLogListLine(Action : string; Id : TSchedId; GenericPlan : boolean; InfoScoreRecord : PTScoreRecord; CompJobToRes : TCompatVal; score : double; LowestEndDateTime : TDateTime);
var
  PLogInfo : PTLogInfo;
  FieldReq, FieldStep, FieldSubStep : variant;
  dataType : CBinColValType;
  Request, Step, SubStep : string;
  planInfo: TSQplanInfo;
begin
  if not AutoSchedCfg.m_CreateLog then exit;
  new(PLogInfo);
  PLogInfo.Id := id;
  PLogInfo.Action := Action;

//  p_sc.GetFldValue(PLogInfo.Id , CSC_ProdReq, FieldReq, dataType);
//  Request := FieldReq;
  Request := p_sc.GetRequestNumber(PLogInfo.Id);
  p_sc.GetFldValue(PLogInfo.Id , CSC_ProdStep, FieldStep, dataType);
  step := IntToStr(FieldStep);
  p_sc.GetFldValue(PLogInfo.Id , CSC_ProdSubStep, FieldSubStep, dataType);
  SubStep := IntToStr(FieldSubStep);
  PLogInfo.ReqStepSubStep_ID := Request + ' ' + step + ' ' + SubStep + '(' + IntToStr(PLogInfo.Id) + ')';
  m_ListLogId.Add(PLogInfo);

  if (Action = 'Start') or (Action = 'StartMove') or  (Action = 'RollBack') then
    exit;

//  try
  if not assigned(InfoScoreRecord.Resource) then exit;

  PLogInfo.rescode := TResourcesStruct(InfoScoreRecord.Resource).m_ResCode;

//  except
//    PLogInfo.rescode := '';
//  end;
  PLogInfo.CompValJobToRes := CompJobToRes;
  PLogInfo.PrevId  := InfoScoreRecord.prevId;
  try
    if PLogInfo.PrevId > -1 then
    begin
      //p_sc.GetFldValue(PLogInfo.PrevId , CSC_ProdReq, FieldReq, dataType);
      //Request := FieldReq;
      Request := p_sc.GetRequestNumber(PLogInfo.PrevId);
      p_sc.GetFldValue(PLogInfo.PrevId , CSC_ProdStep, FieldStep, dataType);
      step := IntToStr(FieldStep);
      p_sc.GetFldValue(PLogInfo.PrevId , CSC_ProdSubStep, FieldSubStep, dataType);
      SubStep := IntToStr(FieldSubStep);
      PLogInfo.Prev_ReqStepSubStep_ID := Request + ' ' + step + ' ' + SubStep + '(' + IntToStr(PLogInfo.PrevId) + ')';
    end
      else PLogInfo.Prev_ReqStepSubStep_ID := '';
  except
    PLogInfo.Prev_ReqStepSubStep_ID := '';
  end;
  PLogInfo.CompValJobToJob := InfoScoreRecord.CompValJobToJob;
  PLogInfo.StartDate       := InfoScoreRecord.StartDateTime;
  PLogInfo.EndDate         := InfoScoreRecord.EndDateTime;
  PLogInfo.Score           := score;
  PLogInfo.Score           := RoundDblToDbl(PLogInfo.Score, 4);
  PLogInfo.setup           := InfoScoreRecord.Setup;
  PLogInfo.Gap             := InfoScoreRecord.Gap;
  PLogInfo.Duration        := InfoScoreRecord.Duration;
  PLogInfo.LowestEndDateTime := LowestEndDateTime;

  if GenericPlan then
  begin
    p_sc.GetJobInfo(PLogInfo.Id, planInfo);
    PLogInfo.GenericPlanStartDate    := planInfo.GenericPlanStartDate;
    PLogInfo.GenericPlanEndDate      := planInfo.GenericPlanEndDate;
    PLogInfo.GenericPlanWc       := planInfo.GenericPlanWC;
    PLogInfo.GenericPlanDuration := planInfo.GenericPlanDur;
    PLogInfo.GenericPlanleadTime := planInfo.GenericPlanLeadTime;
    PLogInfo.GenericPlanMachine  := planInfo.GenericPlanMachineNum;
  end;

  PLogInfo.Score           := RoundDblToDbl(PLogInfo.Score, 4);
  PLogInfo.setup           := InfoScoreRecord.Setup;
  PLogInfo.Gap             := InfoScoreRecord.Gap;

  PLogInfo.ServingGroup           := InfoScoreRecord.ServingGroup;
  PLogInfo.ServinglowestDate      := InfoScoreRecord.ServinglowestDate;
  PLogInfo.ServingHighestDate     := InfoScoreRecord.ServingHighestDate

end;

//----------------------------------------------------------------------------//

function RtvLogSize() : Integer;
begin
  Result := m_ListLogId.Count;
end;

//----------------------------------------------------------------------------//

function SortByLowScore(Item1, Item2: Pointer): integer;
var
  MQMPR1 : TResourcesManager;
  MQMPR2 : TResourcesManager;
begin
  MQMPR1 := TResourcesManager(Item1);
  MQMPR2 := TResourcesManager(Item2);

  if MQMPR1.m_NumOfScheduleJobs > MQMPR2.m_NumOfScheduleJobs then
    Result := -1
  else if (MQMPR1.m_NumOfScheduleJobs = MQMPR2.m_NumOfScheduleJobs) then
  begin
    if (MQMPR1.m_TotalLateHoursUpToTollenrance > MQMPR2.m_TotalLateHoursUpToTollenrance) then
      Result := -1
    else if (MQMPR1.m_TotalLateHoursUpToTollenrance = MQMPR2.m_TotalLateHoursUpToTollenrance) then
    begin
      if MQMPR1.m_TotalSetupHoursStandard < MQMPR2.m_TotalSetupHoursStandard then
        Result := -1
      else if MQMPR1.m_TotalSetupHoursStandard > MQMPR2.m_TotalSetupHoursStandard then
        result := 1
      else
        result := 0
    end
    else
      Result := 1;
  end
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

procedure CleanOverlapListById(Id : TSchedId);
var
  POverlapBox : PTOverlapBox;
  I, Pos, J : Integer;
  PResOvlop : PTResOvlop;
begin
  pos := GetOverlapById(Id);
  if Pos = -1 then Exit;

  POverlapBox := PTOverlapBox(m_OverlapBoxList[Pos]);
  for I := 0 to POverlapBox.m_ResListOvlop.Count - 1 do
  begin
    PResOvlop := PTResOvlop(POverlapBox.m_ResListOvlop[I]);
    for J := PResOvlop.m_OvlopLimit.Count - 1 downto 0 do
      dispose(PTOvlopLimit(PResOvlop.m_OvlopLimit[J]));
    PResOvlop.m_OvlopLimit.Clear;
  end;
  POverlapBox.m_ResListOvlop.Clear;
end;

//----------------------------------------------------------------------------//

function IsPossitionBetter(PrevPosResType, ResType : CScResPlanType;
         PrevPosStartDateTime, StartDateTime, PrevPosEndDateTime, EndDateTime,
         LeftGreenLine, RightGreenLine, ApprovalDate,
         PrevPosLowOverlap, LowOverlap, PrevPosHighOverlap, HigOverlap : TDateTime;
         PrevScore, Score : double;
         AsSoonAsPossible : boolean; IgnoreSmallTimeDifference : boolean) : integer;
var
  Gap1, Gap2, PrevLeftGreenLine, PrevRightGreenLine, PrevApprovalDate, CurrLeftGreenLine, CurrRightGreenLine, CurrApprovalDate : TDateTime;
begin
  Result := 0;

  PrevLeftGreenLine := LeftGreenLine;
  PrevApprovalDate := ApprovalDate;
  PrevRightGreenLine := RightGreenLine;
  CurrLeftGreenLine := LeftGreenLine;
  CurrApprovalDate := ApprovalDate;
  CurrRightGreenLine := RightGreenLine;
  if AutoSchedCfg.m_PrevOrNextLinkedJobIsTheTgtDateWhenScheduled then
  begin
    // As a concept, always when prev overlap > 0 , also the current will be > 0 , but the condition is separated just in case...
    if (PrevPosLowOverlap > 0) then
    begin
      PrevLeftGreenLine := PrevPosLowOverlap;
      PrevApprovalDate := PrevPosLowOverlap;
    end;
    if (LowOverlap > 0) then
    begin
      CurrLeftGreenLine := LowOverlap;
      CurrApprovalDate := LowOverlap;
    end;
    if (PrevPosHighOverlap > 0) then
      PrevRightGreenLine := PrevPosHighOverlap;
    if (HigOverlap > 0) then
      CurrRightGreenLine := HigOverlap;
  end;

  if (PrevPosResType = RPT_Real) and (ResType = RPT_InfiniteCapacity) then
  begin
    Result := -1;
    exit;
  end;

  if (ResType = RPT_Real) and (PrevPosResType = RPT_InfiniteCapacity) then
  begin
    Result := 1;
    exit;
  end;

  if (PrevScore < Score) then
  begin
    Result := -1;
    exit;
  end;

  if (Score < PrevScore) then
  begin
    Result := 1;
    exit;
  end;

  if (AutoSchedCfg.m_PrefTgtDate = 2) or AsSoonAsPossible then
  begin
    if (PrevPosEndDateTime < EndDateTime) then
    begin
      result := -1;
      Exit;
    end;
    if (PrevPosEndDateTime > EndDateTime) then
    begin
      result := 1;
      Exit;
    end;
    if (PrevPosStartDateTime < StartDateTime) then
    begin
      result := -1;
      Exit;
    end;
    if (PrevPosStartDateTime > StartDateTime) then
    begin
      result := 1;
      Exit;
    end;
    if (PrevPosResType = RPT_Real) and (ResType = RPT_OverCapacity) then
    begin
      Result := -1;
      exit;
    end;
    if (ResType = RPT_Real) and (PrevPosResType = RPT_OverCapacity) then
    begin
      Result := 1;
      exit;
    end;
    exit;
  end;

  if (AutoSchedCfg.m_PrefTgtDate = 0) or (AutoSchedCfg.m_PrefTgtDate = 1) then
  begin
    if (StartDateTime >= CurrLeftGreenLine)
    and (EndDateTime <= CurrRightGreenLine)
    and ((PrevPosStartDateTime < PrevLeftGreenLine)
    or (PrevPosEndDateTime > PrevRightGreenLine)) then
    begin
      result := 1;
      exit;
    end;
    if ((StartDateTime < CurrLeftGreenLine)
    or (EndDateTime > CurrRightGreenLine))
    and (PrevPosStartDateTime >= PrevLeftGreenLine)
    and (PrevPosEndDateTime <= PrevRightGreenLine) then
    begin
      result := -1;
      exit;
    end;
  end;

  Gap1 := 0;
  Gap2 := 0;
  if  (AutoSchedCfg.m_PrefTgtDate = 1) then
  begin
    Gap1 := ABS(CurrRightGreenLine - EndDateTime);
    Gap2 := ABS(PrevRightGreenLine - PrevPosEndDateTime);
  end;
  if  (AutoSchedCfg.m_PrefTgtDate = 0) then
  begin
    Gap1 := ABS(CurrLeftGreenLine - StartDateTime);
    Gap2 := ABS(PrevLeftGreenLine - PrevPosStartDateTime);
  end;
  if  (AutoSchedCfg.m_PrefTgtDate = 3) then
  begin
    Gap1 := ABS(CurrApprovalDate - StartDateTime);
    Gap2 := ABS(PrevApprovalDate - PrevPosStartDateTime);
  end;

  if (Gap1 > Gap2) then
  begin
    if not IgnoreSmallTimeDifference
    or (IgnoreSmallTimeDifference and ((Gap1 - Gap2) > 1/24/60*5)) then
    begin
      result := -1;
      exit;
    end;
  end;

  if (Gap1 < Gap2) then
  begin
    if not IgnoreSmallTimeDifference
    or (IgnoreSmallTimeDifference and ((Gap2 - Gap1) > 1/24/60*5)) then
    begin
      result := 1;
      exit;
    end;
  end;

  if (PrevPosResType = RPT_Real) and (ResType = RPT_OverCapacity) then
  begin
    Result := -1;
    exit;
  end;

  if (ResType = RPT_Real) and (PrevPosResType = RPT_OverCapacity) then
  begin
    Result := 1;
    exit;
  end;

end;


//----------------------------------------------------------------------------//

{ ResourcesStruct }

//----------------------------------------------------------------------------//

procedure TResourcesStruct.SetPlanInfo(id: TSchedID; var planInfo: TSQplanInfo);
var
  J, K : Integer;
  idSon : TSchedId;
  planInfoSon : TSQplanInfo;
  Res : TMqmRes;
  components, ResComp : integer;
  supMinRealDummy, exeMinDummy, SequenceexeMin : double;
  ListSequence : TStringList;
  StartDate, EndDate, DummyDateTime : TDateTime;
begin
  if planInfo.isGroup and (planInfo.stepType <> CST_batch) and
    not planInfo.Is_batch_ContinuesTime and not planInfo.Is_Continues_Parallel then
  begin
    p_pl.SetTmgMainID(id);
    p_pl.UpdateGrpTmg;
    Res := TMqmRes(TMqmVisibleRes(m_ResPtr.p_Father));
    p_pl.SetTmgTargetResForGroup(Res);
    EndDate := 0;

    ListSequence := TStringList.Create;
    ListSequence.Sorted := true;
    for J := 0 to p_sc.GetGrpNumSons(id)-1 do
    begin
      idSon := p_sc.GetGrpSon(id, J);
      p_sc.GetPlanInfo(idSon, planInfoSon);
      if ListSequence.IndexOf(trim(planInfoSon.GrpSequence)) = -1 then
        ListSequence.add(trim(planInfoSon.GrpSequence));
    end;

    for K := 0 to ListSequence.Count - 1 do
    begin
      StartDate := EndDate;
      if ListSequence.Strings[K] <> '' then
      begin
        SequenceexeMin := 0;
        for J := 0 to p_sc.GetGrpNumSons(id)-1 do
        begin
          idSon := p_sc.GetGrpSon(id, J);
          p_sc.GetPlanInfo(idSon, planInfoSon);
          if trim(planInfoSon.GrpSequence) <> ListSequence.Strings[K] then  continue;
          p_pl.GetSubTimings(J, IdSon, supMinRealDummy, exeMinDummy, planInfoSon.TmgDescr, planInfoSon.MSC);
          SequenceexeMin := SequenceexeMin + exeMinDummy;
       end;
      end;

      for J := 0 to p_sc.GetGrpNumSons(id)-1 do
      begin
        idSon := p_sc.GetGrpSon(id, J);
        p_sc.GetPlanInfo(idSon, planInfoSon);
        if trim(planInfoSon.GrpSequence) <> ListSequence.Strings[K] then continue;

        p_pl.GetSubTimings(J, IdSon, supMinRealDummy, exeMinDummy, planInfoSon.TmgDescr, planInfoSon.MSC);
        if k = 0 then
        begin
          planInfoSon.supMinReal :=  planInfo.supMinReal;
          StartDate := planInfo.startDate;
        end
        else
          planInfoSon.supMinReal :=  0;
        if ListSequence.Strings[K] <> '' then
          planInfoSon.exeMin := SequenceexeMin
        else
          planInfoSon.exeMin := exeMinDummy;
        components := 1;

        if TMqmRes(m_actArea.p_res).p_isMultiRes then
        begin
          if p_sc.GetRscComponentFromJobOrStep(idSon) > 0 then
            ResComp := p_sc.GetRscComponentFromJobOrStep(idSon)
          else
            ResComp := Res.p_ResComp;
          components := ResComp;
        end;

        CalcDur(m_ActArea, DummyDateTime, id, planInfoSon.exeMin, components, false);
        m_cal.OfsByWH((planInfoSon.supMinReal + CutTimetoSecond(planInfoSon.exeMin))/60, true, StartDate, EndDate, m_actArea.m_CrossDownTmList);
        planInfoSon.startDate := startDate;
        planInfoSon.endDate := endDate;
        p_sc.SetPlanInfo(IDSon, planInfoSon);
        p_sc.SetGenericInfo(IDSon, planInfo)
      end;
    end;
    ListSequence.Free;
  end
  else
    p_sc.SetPlanInfo(Id, planInfo);
end;

//----------------------------------------------------------------------------//
function TResourcesStruct.GetResourcePlantCode() : String;
begin
  result := self.m_PlantCode;
end;

//----------------------------------------------------------------------------//

procedure AddLinkedReqForDependency(Id : TSchedId; ResManager : TResourcesManager);
type
 TLinkedSteps = record
   Request : String;
   step : integer;
   Id : TSchedId;
   Level : Integer;
 end;
 PTLinkedSteps = ^TLinkedSteps;
 var
   PLinkedSteps : PTLinkedSteps;
   LinkedSteps : Tlist;
   FoundIndex, I, J, IdxLevelBefore : Integer;
   StepInfo: TSQStepInfo;
   step : variant;
   Request : string;
   PrevRequest : String;
   PrevStep : integer;
   dataType: CBinColValType;
   SchedIdsList : TMSchedList;
   RequestStepsToReLoadResources : PTRequestStepsToReLoadResources;
begin
  LinkedSteps := TList.Create;
  SchedIdsList := TMSchedList.Create(Application);

  //p_sc.GetFldValue(Id , CSC_ProdReq, Request, dataType);
  Request := p_sc.GetRequestNumber(Id);
  p_sc.GetFldValue(Id , CSC_ProdStep, step, dataType);
  new(PLinkedSteps);
  PLinkedSteps.Id := Id;
  PLinkedSteps.Request := Request;
  PLinkedSteps.Step := step;
  PLinkedSteps.Level := 0;
  LinkedSteps.add(PLinkedSteps);

  I := -1;
  while True do
  begin
    I := I + 1;
    if I > LinkedSteps.Count - 1 then break;

    SchedIdsList.ClearList;

    if (PTLinkedSteps(LinkedSteps[I]).level < 1) then
    begin
      if p_sc.GetPrecStepToSched(PTLinkedSteps(LinkedSteps[I]).Request , PTLinkedSteps(LinkedSteps[I]).step, StepInfo) then
      begin
        if Assigned(StepInfo.ReqDet) then
          SchedIdsList.AddLink(StepInfo.FirstId);
      end
      else
        p_sc.GetPrevConnReqLastStepJobs(PTLinkedSteps(LinkedSteps[I]).Id, SchedIdsList);
    end;

    IdxLevelBefore := SchedIdsList.GetLinkCount;

    if (PTLinkedSteps(LinkedSteps[I]).level > -1) then
    begin
      if p_sc.GetNextStepToSched(PTLinkedSteps(LinkedSteps[I]).Request , PTLinkedSteps(LinkedSteps[I]).step, StepInfo) then
      begin
        if Assigned(StepInfo.ReqDet) then
          SchedIdsList.AddLink(StepInfo.FirstId);
      end
      else
        p_sc.GetNextConnReqFirstStepJobs(PTLinkedSteps(LinkedSteps[I]).Id, SchedIdsList);
    end;

    PrevRequest := '';
    PrevStep := 0;
    for J := 0 to SchedIdsList.GetLinkCount - 1 do
    begin
      //p_sc.GetFldValue(SchedIdsList.GetLink(J) , CSC_ProdReq, Request, dataType);
      Request := p_sc.GetRequestNumber(SchedIdsList.GetLink(J));
      p_sc.GetFldValue(SchedIdsList.GetLink(J) , CSC_ProdStep, step, dataType);
      if (PrevRequest = Request) and (PrevStep = step) then continue;
      PrevRequest := Request;
      PrevStep := step;
      new(PLinkedSteps);
      PLinkedSteps.Id := SchedIdsList.GetLink(J);
      PLinkedSteps.Request := PrevRequest;
      PLinkedSteps.Step := PrevStep;
      if (J + 1) > IdxLevelBefore then
        PLinkedSteps.Level := 1
      else
        PLinkedSteps.Level := -1;
      LinkedSteps.add(PLinkedSteps);
      RequestStepsToReLoadResources := FindRequestStepToReLoadResourcesInList(SchedIdsList.GetLink(J), ResManager.m_ListOfRequestStepsToReLoadResources, FoundIndex);
      if RequestStepsToReLoadResources = nil then
         ResManager.AddRequestStepToReLoadResourcesList(SchedIdsList.GetLink(J), false, true, FoundIndex)
      else
      begin
         RequestStepsToReLoadResources.ReLoadResources := true;
      end;
    end;
  end;

  for I := 0 to LinkedSteps.Count - 1 do
    dispose(PTLinkedSteps(LinkedSteps[I]));
  LinkedSteps.Free;

end;

//----------------------------------------------------------------------------//

function TResourcesStruct.AddIdToList(Id : TSchedId; var ScoreRecord : TScoreRecord; AtPosition : integer; FinalSched : boolean; NewId : boolean) : integer;
var
  planInfo  : TSQplanInfo;
  IdToSched : PTJobToSched;
  JobIdFromList : PTJobInfo;
  DatesInfo: TSQDatesInfo;
  RollBackInfo : PTJobToSched;
  DateTmp : TDateTime;
begin
  p_sc.GetPlanInfo(Id, PlanInfo);

  new(IdToSched);

  IdToSched.Id         := Id;
  IdToSched.FromGantt  := false;
  IdToSched.UnscheduledFromActArea := false;
  IdToSched.PossibleMoveJob := true;
  IdToSched.PossibleSchedBefore := true;
  IdToSched.JobIsLate := false;

  p_sc.GetDatesInfo(Id, DatesInfo);

  if (AutoSchedCfg.m_MoveObjsAllowed = 1) or (AutoSchedCfg.m_MoveObjsAllowed = 2) then
  begin
    DateTmp := 0;
    if AutoSchedCfg.m_PrevOrNextLinkedJobIsTheTgtDateWhenScheduled then
    begin
//      if p_sc.GetFldValue(Id, CSC_NxtLowestDate, DateTmp, dataType) then
      if ScoreRecord.HighOverlap > 0 then
      begin
        DateTmp := ScoreRecord.HighOverlap;
        if (DateTmp <= ScoreRecord.EndDateTime) then
          IdToSched.JobIsLate := true;
      end;
    end;
    if DateTmp = 0 then
    begin
      case AutoSchedCfg.m_MoveObjsAllowed of
      1: if (DatesInfo.HighEndDate <= ScoreRecord.EndDateTime) then
         IdToSched.JobIsLate := true;
      2: if ((DatesInfo.HighEndDate + AfterHighTolerance(AutoSchedCfg)) <= ScoreRecord.EndDateTime) then
         IdToSched.JobIsLate := true;
      end;
    end;
  end;

  IdToSched.StartSched := ScoreRecord.StartDateTime;
  IdToSched.EndSched   := ScoreRecord.EndDateTime;
  IdToSched.LowOverlap := ScoreRecord.LowOverlap;
  IdToSched.HighOverlap := ScoreRecord.HighOverlap;
  IdToSched.score      := ScoreRecord.Score;
  IdToSched.ScoreJobToJob  := ScoreRecord.ScoreJobToJob;
  IdToSched.ScoreJobToRes  := ScoreRecord.ScoreJobToRes;
  IdToSched.Setup      := ScoreRecord.Setup;
  IdToSched.SetUpNoMaterial  := ScoreRecord.SetUpNoMaterial;
  IdToSched.supMinBase := ScoreRecord.supMinBase;
  IdToSched.CompValJobToJob  := ScoreRecord.CompValJobToJob;
  IdToSched.CompValJobToRes  := ScoreRecord.CompValJobToRes;
  IdToSched.duration         := ScoreRecord.Duration;
  IdToSched.durationOrg      := ScoreRecord.DurationOrg;

 // IdToSched.CompValResToJob := m_CompValResToJob;
  if AtPosition = -1 then
    Result := m_SchedList.Add(IdToSched)
  else
  begin
    Result := AtPosition;
    m_SchedList.insert(AtPosition, IdToSched);
  end;

  AfterInsertToSched(m_CurveByFamilyInfo, IdToSched);

  p_sc.GetPlanInfo(IdToSched.Id, planInfo);
  planInfo.startDate := IdToSched.StartSched;
  planInfo.endDate   := IdToSched.EndSched;
  planInfo.supMinReal := ScoreRecord.Setup;
  planInfo.supMinOvlp := ScoreRecord.SetUpNoMaterial;
  planInfo.exeMin     := ScoreRecord.Duration;
  planInfo.supMinBase := ScoreRecord.supMinBase;
  PlanInfo.GenericPlanWC := '';
  PlanInfo.GenericPlanDur := 0;
  PlanInfo.GenericPlanLeadTime := 0;
  PlanInfo.GenericPlanMachineNum := 0;
  PlanInfo.GenericPlanStartDate  := 0;
  PlanInfo.GenericPlanEndDate    := 0;
  if PlanInfo.GenericPlan and (trim(ScoreRecord.GenericPlanWc) <> '') then
  begin
    if ScheduleOnBestPosition(Id, PlanInfo , ScoreRecord.StartDateTime, trim(ScoreRecord.GenericPlanWc),
               ScoreRecord.GenericPlanDuration , ScoreRecord.GenericPlanleadTime, false) then
    IdToSched.GenericPlanWC  := PlanInfo.GenericPlanWC;
    IdToSched.GenericPlanDur := PlanInfo.GenericPlanDur;
    IdToSched.GenericPlanLeadTime := PlanInfo.GenericPlanLeadTime;
    IdToSched.GenericPlanMachineNum := PlanInfo.GenericPlanMachineNum;
    IdToSched.GenericPlanStartDate  := PlanInfo.GenericPlanStartDate;
    IdToSched.GenericPlanEndDate    := PlanInfo.GenericPlanEndDate
  end
  else
    IdToSched.GenericPlanWC  := '';

 // p_sc.SetPlanInfo(IdToSched.Id, planInfo);
  SetPlanInfo(IdToSched.Id, planInfo);
//  p_pl.UpdatePlanLinkJob(m_ResCode,Id, nil);
  p_pl.UpdatePlanLinkJobAutoSeq(m_ResPtr,Id, nil);
  p_sc.UpdateBalance(id);

  JobIdFromList := FindIdInBackUpList(IdToSched.Id, m_ResourcesManager.m_ListBackupIdInfo);
  if JobIdFromList <> nil then
  begin
    JobIdFromList.ResourcesStruct := self;
    IdToSched.OldPlanInfo := JobIdFromList.OldPlanInfo;
  end;

  if FinalSched and (not NewId) then
  begin
    p_sc.AutoSeqCheckMoveJobsToCorrectPlace(Id, true);
    p_sc.AutoSeqCheckMoveJobsToCorrectPlace(Id, false);
    p_sc.AutoSeqCheckMoveServingGroupJobsToCorrectPlace(Id);
  end;

  // RollBackInfo
  new(RollBackInfo);
  RollBackInfo.SchedType := schedule;
  RollBackInfo.ResourcesStruct := self;
  RollBackInfo.PosInList       := result;
  RollBackInfo.Id              := id;
  RollBackInfo.ResourceManagerPtr := m_ResourcesManager;
  RollBackInfo.ReScheduleAtSpecificPlace := false;
  m_rollbackInfoList.add(RollBackInfo);

  if FinalSched then
    AddLinkedReqForDependency(Id, m_ResourcesManager);
end;

//----------------------------------------------------------------------------//

function TResourcesStruct.GetMqmActArea : TMqmActArea;
begin
  Result := m_ActArea
end;

//----------------------------------------------------------------------------//

procedure TResourcesStruct.JoinAllSubStep;
var
  PrevId, LowestSubStepId : TSchedId;
  I, J, IndexToRemove, IndexToLeave, Position  : integer;
  IdToSchedCurr, IdToSchedNext, IdToRemove, IdToLeave : PTJobToSched;
  ToRemoveJobIdFromBackup, ToLeaveJobIdFromBackup : PTJobInfo;
  ValPrev, ValNext : variant;
  dataType: CBinColValType;
  ListStrRes, ListStrCmpToRes, ListStrSupMinBase, ListStrDuration, ListStrDurationOrg,
  ListStrStandBatchSize , ListStrMinBatchSize, ListStrMaxBatchSize : TStringList;
  DurationQuantityBase : double;
  ResourcesStruct : TResourcesStruct;
  GenericPlanInfo : TSQplanInfo;
  MatAddResList, GenericPlanDates : Tlist;
  PrevEndDate : TDateTime;
  ScoreRecord : TScoreRecord;
  ServingGroupCode : String;
  ServingCodeLowestDateTime, ServingCodeHighestDateTime, ServingCodeHighestMinusTollerance : TDateTime;
  Score : Double;
  planInfo : TSQplanInfo;
begin
  if m_SchedList.Count < 2 then exit;

  MatAddResList := TList.Create;
  GenericPlanDates := TList.Create;

  I := -1;
  while true do
  begin

    Inc(I);
    if I = (m_SchedList.Count - 1) then
      break;

    IdToSchedCurr := PTJobToSched(m_SchedList[I]);
    IdToSchedNext := PTJobToSched(m_SchedList[I + 1]);

    if not AreIdsIdentical(IdToSchedCurr.Id, IdToSchedNext.Id, LowestSubStepId) then
      continue;

    if LowestSubStepId = IdToSchedCurr.Id then
    begin
      IndexToRemove := I + 1;
      IndexToLeave := I;
    end
    else
    begin
      IndexToRemove := I;
      IndexToLeave := I + 1;
    end;

    IdToRemove := PTJobToSched(m_SchedList[IndexToRemove]);
    IdToLeave := PTJobToSched(m_SchedList[IndexToLeave]);

    ToRemoveJobIdFromBackup := FindIdInBackUpList(IdToRemove.id, m_ResourcesManager.m_ListBackupIdInfo);
    ToLeaveJobIdFromBackup := FindIdInBackUpList(IdToLeave.id, m_ResourcesManager.m_ListBackupIdInfo);
    if (ToRemoveJobIdFromBackup = nil)
    or (ToLeaveJobIdFromBackup = nil)
    or (ToRemoveJobIdFromBackup.ResCode <> '')
    or (ToLeaveJobIdFromBackup.ResCode <> '') then continue;

    ListStrRes := GetInformationById(IdToLeave.Id, ListStrCmpToRes, ListStrSupMinBase, ListStrDuration, ListStrDurationOrg,
                  ListStrStandBatchSize , ListStrMinBatchSize, ListStrMaxBatchSize, Position, DurationQuantityBase);
    if ListStrRes = nil then continue;
    for J := 0 to ListStrRes.Count - 1 do   // Find the batch size of the specific resource
    begin
      ResourcesStruct := FindResourceByCode(ListStrRes.Strings[J],  m_ResourcesManager.m_AllResList);
      if ResourcesStruct = nil then Continue;
      if ResourcesStruct.m_ResCode = self.m_ResCode then break;
    end;
    if J >= ListStrRes.Count then continue;
    if StrToFloat(ListStrMinBatchSize.Strings[J]) <> - 1 then continue; // -1 is when split by daily production

    p_pl.UpdatePlanLinkJob('', IdToRemove.Id, nil);
    p_pl.UpdatePlanLinkJob('', IdToLeave.Id, nil);
    AddOrSubtructIdsQuantity(IdToLeave.Id, IdToRemove.Id, true);
    m_ResourcesManager.CleanMaterialAddRessList(MatAddResList);
    m_ResourcesManager.CleanGenericPlanDates(GenericPlanDates);
    ValPrev := p_sc.GetPrvHighestDate(IdToLeave.Id);
    ValNext := p_sc.GetNextHighiestEndDate(IdToLeave.Id);

    if I = 0 then
    begin
      PrevId := CSchedIDnull;
      PrevEndDate := AutoSchedCfg.m_NowDateTime;
    end
    else
    begin
      PrevId := PTJobToSched(m_SchedList[I - 1]).id;
      PrevEndDate := PTJobToSched(m_SchedList[I - 1]).EndSched;
    end;

    // We allow to find the earliest date possible ignoring when the job started originally
    CleanOverlapListById(IdToLeave.Id);
    if not ResourcesStruct.CheckScoreAfterJob(PrevId, IdToLeave.Id , false, 0, 0,
       IdToSchedNext.EndSched, 0, PrevEndDate, ScoreRecord, GenericPlanDates, ValPrev, ValNext,
       MatAddResList, false, false, StrToFloat(ListStrSupMinBase.Strings[J]),
       StrToFloat(ListStrDuration.Strings[J]), StrToFloat(ListStrDurationOrg.Strings[J]), DurationQuantityBase) then
    begin
      AddOrSubtructIdsQuantity(IdToLeave.Id, IdToRemove.Id, false);
      p_pl.UpdatePlanLinkJobAutoSeq(m_ResPtr,IdToRemove.Id, nil);
      p_sc.UpdateBalance(IdToRemove.id);
      p_pl.UpdatePlanLinkJobAutoSeq(m_ResPtr,IdToLeave.Id, nil);
      p_sc.UpdateBalance(IdToLeave.id);
      Continue;
    end;

    AddOrSubtructIdsQuantity(IdToLeave.Id, IdToRemove.Id, false);
    BeforeDeletedFromSched(m_CurveByFamilyInfo, IdToRemove.Id);
    dispose(PTJobToSched(ResourcesStruct.m_SchedList[IndexToRemove]));
    ResourcesStruct.m_SchedList.Delete(IndexToRemove);
    p_sc.GetJobInfo(IdToRemove.id,GenericplanInfo);
    if GenericPlanInfo.GenericPlanWC <> '' then
    begin
       UMGenericSchedulePrevStep.UnScheduleGenericPlan(IdToRemove.Id);
       GenericPlanInfo.GenericPlanWC := '';
       p_sc.SetGenericInfo(IdToRemove.Id, GenericPlanInfo);
    end;
    ToRemoveJobIdFromBackup.ResourcesStruct := nil;
    m_ResourcesManager.MarkIdAsNotValidInBackupList(IdToRemove.Id);

    JoinTwoIds(IdToLeave.Id, IdToRemove.Id);

    ServingCodeHighestMinusTollerance := 0;
    if p_sc.GetServingGroupLowestHighiestDates(IdToLeave.Id,ServingGroupCode,ServingCodeLowestDateTime,ServingCodeHighestDateTime) then
    begin
      if AutoSchedCfg.m_RescheduleErlierJobsWhenTolerance then
         ServingCodeHighestMinusTollerance := ServingCodeHighestDateTime - (AutoSchedCfg.m_HoursToleranceOfGapBetweenJobs / 24);
    end;

    Score := CalcScore(TMqmRes(TMQMVisibleRes(m_ResPtr).p_Father), IdToLeave.Id, PrevId,
                                 @ScoreRecord , 999999, StrToInt(ListStrCmpToRes.Strings[J]),
                                 ServingGroupCode, ServingCodeLowestDateTime,
                                 ServingCodeHighestDateTime);

    p_sc.GetPlanInfo(IdToLeave.Id, PlanInfo);
    PlanInfo.startDate := ScoreRecord.StartDateTime;
    PlanInfo.EndDate := ScoreRecord.EndDateTime;
    PlanInfo.supMinReal := ScoreRecord.Setup;
    PlanInfo.supMinOvlp := ScoreRecord.SetupNoMaterial;
    planInfo.exeMin     := ScoreRecord.Duration;
    ResourcesStruct.SetPlanInfo(IdToLeave.Id, PlanInfo);
    p_pl.UpdatePlanLinkJobAutoSeq(m_ResPtr,IdToLeave.Id, nil);
    p_sc.UpdateBalance(IdToLeave.Id);
    IdToLeave.StartSched := ScoreRecord.StartDateTime;
    IdToLeave.EndSched := ScoreRecord.EndDateTime;
    IdToLeave.LowOverlap := ScoreRecord.LowOverlap;
    IdToLeave.HighOverlap := ScoreRecord.HighOverlap;
    IdToLeave.score := Score;
    IdToLeave.ScoreJobToJob := ScoreRecord.ScoreJobToJob;
    IdToLeave.ScoreJobToRes := ScoreRecord.ScoreJobToRes;
    IdToLeave.CompValJobToJob := ScoreRecord.CompValJobToJob;
    IdToLeave.Setup := ScoreRecord.Setup;
    IdToLeave.SetUpNoMaterial := ScoreRecord.SetupNoMaterial;
    IdToLeave.Duration := ScoreRecord.Duration;
    IdToLeave.DurationOrg := ScoreRecord.DurationOrg;
    AfterSchedUpdated(m_CurveByFamilyInfo, IdToLeave);

    I := I - 1;

  end;

  m_ResourcesManager.CleanMaterialAddRessList(MatAddResList);
  MatAddResList.Free;
  m_ResourcesManager.CleanGenericPlanDates(GenericPlanDates);
  GenericPlanDates.Free;

end;

//----------------------------------------------------------------------------//
function  AreIdsIdentical(Firstid, SecondId : TschedId; var LowestSubStepId : TschedId): boolean;
var
  dataType: CBinColValType;
  FirstidRequest, SecondIdRequest : string;
  FirstidStep, SecondIdStep, FirstidSubStep, SecondIdSubStep : variant;
  NumberOfGroupSons, I  : integer;
  FirstIdGroupSon, SecondIdGroupSon, LowestSubStepIdInAGroup, LowestGroupId : TSchedId;
begin
   Result := false;

   if p_sc.IsGroup(Firstid) or p_sc.IsGroup(SecondId) then
   begin
     if p_sc.IsGroup(Firstid) and not p_sc.IsGroup(SecondId) then exit;
     if not p_sc.IsGroup(Firstid) and p_sc.IsGroup(SecondId) then exit;
     if p_sc.GetGrpNumSons(Firstid) <> p_sc.GetGrpNumSons(SecondId) then exit;
     NumberOfGroupSons := p_sc.GetGrpNumSons(Firstid);
     LowestSubStepId := CSchedIDnull;
     for I := 0 to NumberOfGroupSons - 1 do
     begin
       FirstIdGroupSon := p_sc.GetGrpSon(Firstid, I);
       SecondIdGroupSon := p_sc.GetGrpSon(SecondId, I);
       if not AreIdsIdentical(FirstIdGroupSon, SecondIdGroupSon, LowestSubStepIdInAGroup) then exit;
       if LowestSubStepIdInAGroup = FirstIdGroupSon then
         LowestGroupId := Firstid
       else
         LowestGroupId := SecondId;
       if (LowestSubStepId <> CSchedIDnull) and (LowestSubStepId <> LowestGroupId) then exit;
       LowestSubStepId := LowestGroupId;
     end;
     Result := true;
     Exit;
   end;

   FirstidRequest := p_sc.GetRequestNumber(Firstid);
   SecondIdRequest := p_sc.GetRequestNumber(SecondId);
   if FirstidRequest <> SecondIdRequest then
     Exit;

   p_sc.GetFldValue(Firstid, CSC_ProdStep, FirstidStep, dataType);
   p_sc.GetFldValue(SecondId, CSC_ProdStep, SecondIdStep, dataType);
   if FirstidStep <> SecondIdStep then
     Exit;

   Result := true;
   p_sc.GetFldValue(Firstid, CSC_ProdSubStep, FirstidSubStep, dataType);
   p_sc.GetFldValue(SecondId, CSC_ProdSubStep, SecondIdSubStep, dataType);
   if FirstidSubStep < SecondIdSubStep then
     LowestSubStepId := Firstid
   else
     LowestSubStepId := SecondId;

end;

//----------------------------------------------------------------------------//
procedure AddOrSubtructIdsQuantity(IdToChange, IdToLoad : TschedId; Add : boolean);
var
  NumberOfGroupSons, I  : integer;
  IdToChangeGroupSon, IdToLoadGroupSon : TSchedId;
  Quantity : double;
begin
   if p_sc.IsGroup(IdToChange) then // If the first one if grouped, second group is identical
   begin
     NumberOfGroupSons := p_sc.GetGrpNumSons(IdToChange);
     for I := 0 to NumberOfGroupSons - 1 do
     begin
       IdToChangeGroupSon := p_sc.GetGrpSon(IdToChange, I);
       IdToLoadGroupSon := p_sc.GetGrpSon(IdToLoad, I);
       AddOrSubtructIdsQuantity(IdToChangeGroupSon, IdToLoadGroupSon, Add);
     end;
     Exit;
   end;

   Quantity := p_sc.GetJobQty(IdToLoad);
   if not Add then
     Quantity := Quantity * (-1);
   p_sc.AddQtyToJob(IdToChange, Quantity);

end;

//----------------------------------------------------------------------------//
procedure JoinTwoIds(IdToLeave, IdToRemove : TschedId);
var
  NumberOfGroupSons, I  : integer;
  IdToLeaveGroupSon, IdToRemoveGroupSon : TSchedId;
  jobsListToJoin : TList;
begin
   if p_sc.IsGroup(IdToRemove) then // If the first one if grouped, second group is identical
   begin
     NumberOfGroupSons := p_sc.GetGrpNumSons(IdToLeave);
     for I := (NumberOfGroupSons - 1) downto 0 do
     begin
       IdToLeaveGroupSon := p_sc.GetGrpSon(IdToLeave, I);
       IdToRemoveGroupSon := p_sc.GetGrpSon(IdToRemove, I);
       p_opStack.RemoveJobFromGroup(IdToRemoveGroupSon, 'Auto-scheduling - groups merged');
       JoinTwoIds(IdToLeaveGroupSon, IdToRemoveGroupSon);
     end;
     p_sc.DeleteGroup(IdToRemove);
     Exit;
   end;

   jobsListToJoin := TList.Create;
   jobsListToJoin.Add(pointer(IdToRemove));
  // p_sc.JoinJobs(IdToLeave, jobsListToJoin);
   p_opStack.JoinJobs(IdToLeave, jobsListToJoin);

   jobsListToJoin.clear;
   jobsListToJoin.free;

end;

//----------------------------------------------------------------------------//

procedure TResourcesStruct.LoadIdFromActiveArea;
var
  SchedId : TSchedId;
  planInfo, PlanInfoOld : TSQplanInfo;
  JobToSched : PTJobToSched;
  I : Integer;
//  VisRes : TMqmVisibleRes;
//  CompVal : TCompatVal;
  DatesInfo: TSQDatesInfo;
  TempList : TList;
  TypeSched : string;
//  DateTmp : variant;
//  dataType: CBinColValType;
  DurationOrg,Setup : double;
  DateTmp, LowOvlopLimitTmp, HighOvlpLimitTmp : TDateTime;
  CurveByFamilyInfo : PTCurveByFamilyInfo;
  Index : integer;
  NoMovedJobsZone : boolean;
begin
  TempList := TList.Create;
  m_ActArea := TMqmActArea(m_ResPtr.p_ActArea[0]);
  m_Cal := m_ActArea.GetCalendar;
  if not m_ActArea.p_CheckIfSchedObjsIsAssigned then exit;
  m_ActArea.SortSchedObjsByEnd;
  NoMovedJobsZone := false;

  for I := m_ActArea.p_ObjCount - 1 downto 0 do
  begin
    SchedId := m_ActArea.GetSchedObj(I);

    if (p_sc.GetLearningCurveType(SchedId) <> CSC_No) and (p_sc.GetCurveFamilyIdCode(SchedId) <> '') then
    begin
      p_sc.GetIdTimes(SchedId,'','','',false,DurationOrg,Setup,true);
      if DurationOrg > 0 then
      begin
        CurveByFamilyInfo := FindCurveByFamilyInfo(m_CurveByFamilyInfo,
          p_sc.GetLearningCurveCode(SchedId), p_sc.GetCurveFamilyIdCode(SchedId), true);
        if NoMovedJobsZone then
          CurveByFamilyInfo.OldIdsTimeBeforeCurve := CurveByFamilyInfo.OldIdsTimeBeforeCurve + DurationOrg;
      end;
    end;

    if NoMovedJobsZone and (not TMqmRes(m_actArea.p_res).p_isMultiRes) then
      continue;

    p_sc.GetPlanInfo(SchedId, PlanInfo);
   // PlanInfoOld := PlanInfo;
    p_sc.GetPlanInfo(SchedId, PlanInfoOld);
    new(JobToSched);
    JobToSched.Id := SchedId;
    JobToSched.FromGantt := true;
    JobToSched.PossibleMoveJob := true;
    JobToSched.PossibleSchedBefore := true;
    JobToSched.JobIsLate := false;
    JobToSched.score := -999;
    JobToSched.StartSched := PlanInfo.startDate;
    JobToSched.EndSched := PlanInfo.endDate;
    JobToSched.Setup := PlanInfo.supMinReal;
    JobToSched.SetUpNoMaterial  := PlanInfo.supMinOvlp;
    JobToSched.supMinBase := PlanInfo.supMinBase;
    JobToSched.duration := PlanInfo.exeMin;
    JobToSched.durationOrg := DurationOrg;
    JobToSched.OldPlanInfo := PlanInfoOld;
    JobToSched.ResourcesStruct := Pointer(self);
    JobToSched.UnscheduledFromActArea := false;

    if (CProgress(p_sc.IsProgressed(SchedId)) = prg_none) then
    begin
      p_sc.CalcOvlpLimits(SchedId, m_ResPtr, LowOvlopLimitTmp, HighOvlpLimitTmp, OvlpChk_OptimumLimits, PlanInfo.supMinReal - PlanInfo.supMinOvlp, PlanInfo.exeMin);
      if (LowOvlopLimitTmp > 0) and (LowOvlopLimitTmp < 999999) then // add 4 seconds to the low limit
        m_Cal.OfsByWH(4/3600, true, LowOvlopLimitTmp, LowOvlopLimitTmp , m_ActArea.m_CrossDownTmList);
      if (HighOvlpLimitTmp > 0) and (HighOvlpLimitTmp < 999999) then // reduce 4 seconds from the high limit
        m_Cal.OfsByWH(-4/3600, false, HighOvlpLimitTmp, HighOvlpLimitTmp , m_ActArea.m_CrossDownTmList);
      JobToSched.LowOverlap := LowOvlopLimitTmp;
      JobToSched.HighOverlap := HighOvlpLimitTmp;
    end;

    TempList.Add(JobToSched);
    AfterInsertToSched(m_CurveByFamilyInfo, JobToSched);
    m_ResourcesManager.AddIdToBackupList(SchedId, m_ResCode, self);

    if (PlanInfo.endDate < AutoSchedCfg.m_NowDateTime) then
    begin
      JobToSched.PossibleSchedBefore := false;
      JobToSched.PossibleMoveJob := false;
      NoMovedJobsZone := true;
      continue;
    end;

//    if (not PlanInfo.isGroup) and not p_sc.CanDetach(SchedId, nil, false) or
//       (PlanInfo.isGroup and not p_sc.CanDetachGroup(SchedId)) then

    if not p_sc.CanDetachJobOrGroup(SchedId) then
    begin
      JobToSched.PossibleSchedBefore := false;
      JobToSched.PossibleMoveJob := false;
      NoMovedJobsZone := true;
      continue;
    end;

    TypeSched := p_sc.GetSchedType(SchedId);
    if (AutoSchedCfg.m_MoveObjsAllowed = 3)
    or ((TypeSched = '1') and (AutoSchedCfg.m_MoveInitialObjsAlwd = 0))
    or ((TypeSched = '2') and (AutoSchedCfg.m_MoveFinalObjsAlwd = 0))
    or ((TypeSched = '4') and (AutoSchedCfg.m_MoveLevel1ObjsAlwd = 0))
    or ((TypeSched = '5') and (AutoSchedCfg.m_MoveLevel2ObjsAlwd = 0))
    or ((TypeSched = '6') and (AutoSchedCfg.m_MoveLevel3ObjsAlwd = 0))
    or ((TypeSched = '7') and (AutoSchedCfg.m_MoveLevel4ObjsAlwd = 0))
    or ((TypeSched = '8') and (AutoSchedCfg.m_MoveLevel5ObjsAlwd = 0)) then
    begin
      JobToSched.PossibleMoveJob := false;
      if not AutoSchedCfg.m_AllowSchedBeforeNoneConfLevl then
      begin
        JobToSched.PossibleSchedBefore := false;
        NoMovedJobsZone := true;
        continue;
      end;
      continue;
    end;

    p_sc.GetDatesInfo(SchedId, DatesInfo);

    if (AutoSchedCfg.m_MoveObjsAllowed = 1) or (AutoSchedCfg.m_MoveObjsAllowed = 2) then
    begin
      DateTmp := 0;
//      if AutoSchedCfg.m_PrevOrNextLinkedJobIsTheTgtDateWhenScheduled and p_sc.GetFldValue(SchedId, CSC_NxtLowestDate, DateTmp, dataType) then
      if AutoSchedCfg.m_PrevOrNextLinkedJobIsTheTgtDateWhenScheduled and (HighOvlpLimitTmp > 0) then
      begin
        DateTmp := HighOvlpLimitTmp;
        if (DateTmp <= PlanInfo.endDate) then
          JobToSched.JobIsLate := true;
      end;
      if DateTmp = 0 then
      begin
        case AutoSchedCfg.m_MoveObjsAllowed of
        1: if (DatesInfo.HighEndDate <= PlanInfo.endDate) then
             JobToSched.JobIsLate := true;
        2: if ((DatesInfo.HighEndDate + AfterHighTolerance(AutoSchedCfg)) <= PlanInfo.endDate) then
             JobToSched.JobIsLate := true;
        end;
      end;
    end;

  end;

  m_ActArea.SortSchedObjs;

  for I := TempList.Count - 1 downto 0 do
    m_SchedList.Add(TempList[I]);

  TempList.Free;

end;

//----------------------------------------------------------------------------//

function TResourcesStruct.PushjobAfterDownTime(setup, dur: double; StartDateTime: TDateTime; Id : TSchedId; out NextNotPossibleDate : TDateTime): TDateTime;
var
  DwTime : TMqmDurObj;
  EndDateTime, FarFutureTime : TDateTime;
  LastIndexChecked, SavedLastIndexChecked : integer;
begin
  Result := StartDateTime;
  NextNotPossibleDate := 999999;
  if m_actArea.p_CapResCount = 0 then exit;

  LastIndexChecked := -1;
  FarFutureTime := EncodeDate(2100, 01, 01);
  DwTime := m_actArea.FindNonCrossingDwTime(Result, FarFutureTime, LastIndexChecked, Id, AutoSchedCfg.m_MinJobCapResComp);
  if not assigned(DwTime) then exit;

  m_cal.OfsByWH((setup + dur)/60, true, Result, EndDateTime, m_actArea.m_CrossDownTmList);
  if DwTime.p_end >= EndDateTime then
    DwTime := nil;

  while DwTime <> nil do
  begin
    Result := DwTime.p_end;
    m_cal.OfsByWH((setup + dur)/60, true, Result, EndDateTime, m_actArea.m_CrossDownTmList);
    SavedLastIndexChecked := LastIndexChecked;
    DwTime := m_actArea.FindNonCrossingDwTime(Result, EndDateTime, LastIndexChecked, Id, AutoSchedCfg.m_MinJobCapResComp);
  end;

  if (AutoSchedCfg.m_SplitSchedByBatchSize <> LongestDurationPossible) then exit;

  LastIndexChecked := SavedLastIndexChecked;
  DwTime := m_actArea.FindNonCrossingDwTime(EndDateTime, FarFutureTime, LastIndexChecked, Id, AutoSchedCfg.m_MinJobCapResComp);
  if assigned(DwTime) then
    NextNotPossibleDate := DwTime.p_start;

end;

//----------------------------------------------------------------------------//

function TResourcesStruct.PushjobAfterWarpInCaseNotCompatible(setup, dur : double; StartDateTime : TDateTime; Id : TSchedId; out NextNotPossibleDate : TDateTime) : TDateTime;
var
  EndDateTime, FarFutureTime : TDateTime;
  LastIndexChecked, SavedLastIndexChecked : integer;
  Warp : TMqmDurObj;
  DummyId : TSchedId;
  MatQtyRequired : double;
begin
  Result := StartDateTime;
  NextNotPossibleDate := 999999;

  LastIndexChecked := -1;
  FarFutureTime := EncodeDate(2100, 01, 01);
  Warp := m_actArea.FindWarpCoveringByIndex(Result, FarFutureTime, LastIndexChecked);
  if not assigned(Warp) then exit;

  m_cal.OfsByWH((setup + dur)/60, true, Result, EndDateTime, m_actArea.m_CrossDownTmList);
  if Warp.p_end >= EndDateTime then
    Warp := nil;

  while Warp <> nil do
  begin
    if not p_sc.CheckItemAndProductForWarp(TMqmWarp(Warp).Get_M_id, Id, false, DummyId, MatQtyRequired) then
    begin
      Result := Warp.p_end;
      m_cal.OfsByWH((setup + dur)/60, true, Result, EndDateTime, m_actArea.m_CrossDownTmList);
    end;
    SavedLastIndexChecked := LastIndexChecked;
    Warp := m_actArea.FindWarpCoveringByIndex(Result, EndDateTime, LastIndexChecked);
  end;

  if (AutoSchedCfg.m_SplitSchedByBatchSize <> LongestDurationPossible) then exit;

  LastIndexChecked := SavedLastIndexChecked;
  Warp := m_actArea.FindWarpCoveringByIndex(EndDateTime, FarFutureTime, LastIndexChecked);
  while Warp <> nil do
  begin
    if not p_sc.CheckItemAndProductForWarp(TMqmWarp(Warp).Get_M_id, Id, false, DummyId, MatQtyRequired) then
    begin
      NextNotPossibleDate := Warp.p_start;
      break;
    end;
    Warp := m_actArea.FindWarpCoveringByIndex(EndDateTime, FarFutureTime, LastIndexChecked);
  end;

end;

//----------------------------------------------------------------------------//

function TResourcesStruct.TempScoreAndScheduleAndPushAllJobsFromPosition(Id : TSchedId; var ScoreList : TList;
            Index : Integer; BetterScoreFound : boolean; var NewScore : double;
            ScoreAfterLastJob : TScoreRecord; ScoreAfterLastFound : boolean; LimitStartDate, ValPrev, ValNext : TDateTime;
            ResourceIndex : integer; FinalSchdule : boolean;
            ServingGroupCode : String; ServingCodeLowestDateTime, ServingCodeHighestDateTime,
            ServingCodeLowestPlusTollerance : TDateTime; PlantCode : String;
            SupMinBaseMain, DurationMain, DurationOrgMain, DurationQuantityBaseMain : Double; CompJobToResMain : TCompatVal) : boolean;
type
 TRemovedIds = record
   id    : TSchedId;
   Score : double;
   ToMoveStartDate, ToMoveEndDate : TDateTime;
 end;
 PTRemovedIds = ^TRemovedIds;

var
  I : Integer;
  LoopStopped : boolean;
  PossitionScore : double;
  TempList : TList;
  MatAddResList, GenericPlanDates : TList;
  DatesInfo: TSQDatesInfo;
  PrevId : TSchedId;
  ScoreRecord : TScoreRecord;
  PScoreRecord : PTScoreRecord;
  PrevEndDate, ToMoveIdEndDate : TDateTime;
  IgnoreGenericPlan, IgnoreAddRessMat : boolean;
  PJobToSched, PJobToSchedTemp : PTJobToSched;
//  PlanInfo : TSQplanInfo;
  ContinueCheck : boolean;
  CurrentId : TSchedId;
  checkMovedJob : boolean;
  TempScoreList : TList;
  MainIdPosition : integer;
  SchedAfterMainId : boolean;
  RollBackInfo : PTJobToSched;
  rollbackIndex      : Integer;
  PRemovedIds : PTRemovedIds;
  HighestPrevEndFound, DummyDatTime : TDateTime;
  RecalcDur, UnschedWithError : boolean;
//  SetupChange : Double;
//  LowestMinQty, HighestMaxQty : Double;
//  FirstResource : TResourcesStruct;
begin
  result := false;
  PossitionScore := 0;
  TempList := TList.Create;
  TempScoreList := TList.Create;
  MatAddResList := TList.Create;
  GenericPlanDates := Tlist.Create;
  ContinueCheck := true;

  rollbackIndex := m_rollbackInfoList.Count;

  ToMoveIdEndDate := PTJobToSched(m_SchedList[Index]).EndSched;
//  SetupChange := 0;
  for I := m_SchedList.Count - 1 downto index do
  begin
    PJobToSched := PTJobToSched(m_SchedList[I]);
//    p_sc.GetPlanInfo(PJobToSched.Id, PlanInfo);
    p_sc.GetPlanInfo(PJobToSched.Id, PJobToSched.OldPlanInfo);

    if I = index then
    begin
      Self.m_ResourcesManager.CheckSetupCompactParam(PJobToSched.Id, Id,
      Self.m_ResCode,m_ActArea, ScoreRecord.CompValJobToJob,
      PJobToSched.OldPlanInfo.supMinBase, ScoreRecord.setup, ScoreRecord.SetupNoMaterial,
      ScoreRecord.GenericPlanWc, ScoreRecord.GenericPlanDuration, ScoreRecord.GenericPlanleadTime, RecalcDur);

//      if RecalcDur then
//         ScoreRecord.Duration := ScoreRecord.DurationOrg + GetCurveTime(m_ActArea, DummyDatTime, PJobToSched.Id, ScoreRecord.DurationOrg, false, 0);
    end;

    new(RollBackInfo);
    RollBackInfo^ := PJobToSched^;
    RollBackInfo.SchedType := unschedule;
    RollBackInfo.ResourcesStruct := self;
    RollBackInfo.ResourceManagerPtr := m_ResourcesManager;
    RollBackInfo.ReScheduleAtSpecificPlace := false;
    m_rollbackInfoList.Add(RollBackInfo);

    new(PRemovedIds);
    PRemovedIds.id := PJobToSched.Id;
    PRemovedIds.Score := PJobToSched.Score;
    PRemovedIds.ToMoveStartDate := PJobToSched.OldPlanInfo.startDate;
    PRemovedIds.ToMoveEndDate := PJobToSched.OldPlanInfo.endDate;
    TempList.add(PRemovedIds);

    m_ResourcesManager.RemoveIdFromList(PJobToSched.Id, I, true, UnschedWithError);

  end;

  SchedAfterMainId := false;
  if FinalSchdule then
  begin
    PScoreRecord := PTScoreRecord(ScoreList[0]);
    ScoreRecord  := PScoreRecord^;

    MainIdPosition := AddIdToList(Id , ScoreRecord, -1, FinalSchdule, false);
    PJobToSched := PTJobToSched(m_SchedList[MainIdPosition]);
    p_sc.GetPlanInfo(PJobToSched.Id, PJobToSched.OldPlanInfo);

    ScoreRecord.Gap := 0;
    FillLogListLine('MOVMainSelected',Id, true, @ScoreRecord, ScoreRecord.CompValJobToRes , ScoreRecord.Score, 0);
    for I := 1 to ScoreList.Count - 1 do
    begin
      PScoreRecord := PTScoreRecord(ScoreList[I]);
      ScoreRecord  := PScoreRecord^;
      ScoreRecord.Resource.AddIdToList(ScoreRecord.Id , ScoreRecord, -1, FinalSchdule, false);
      ScoreRecord.Gap := 0;
      if ScoreRecord.Resource.m_ResCode = self.m_ResCode then
        SchedAfterMainId := true;
      FillLogListLine('MOVOtherSelected',ScoreRecord.Id, true, @ScoreRecord, ScoreRecord.CompValJobToRes , ScoreRecord.Score, 0);
    end;
    if not SchedAfterMainId then
    begin
//      p_sc.GetPlanInfo(Id, PlanInfo);

      new(RollBackInfo);
      RollBackInfo^ := PJobToSched^;
      RollBackInfo.SchedType := unschedule;
      RollBackInfo.ResourcesStruct := self;
      RollBackInfo.ResourceManagerPtr := m_ResourcesManager;
      RollBackInfo.ReScheduleAtSpecificPlace := false;
      m_rollbackInfoList.Add(RollBackInfo);

      m_ResourcesManager.RemoveIdFromList(Id, MainIdPosition, true, UnschedWithError);

      if m_ResourcesManager.FindBestScoreAfterLastJob(id, false, ScoreRecord,LimitStartDate, 0 ,
            GenericPlanDates, false, HighestPrevEndFound, PlantCode) then
      begin
        m_ResourcesManager.CleanGenericPlanDates(GenericPlanDates);
        ScoreRecord.Resource.AddIdToList(Id , ScoreRecord, -1, FinalSchdule, false);
        FillLogListLine('REMOVMainSelected',Id, true, @ScoreRecord, ScoreRecord.CompValJobToRes , ScoreRecord.Score, 0);
      end;
    end;
    for I := TempList.Count - 1 downto 0 do
      Dispose(PTRemovedIds(TempList[I]));
    TempList.Clear;
    TempList.free;
    MatAddResList.Free;
    TempScoreList.Free;
    GenericPlanDates.Free;
    exit;
  end;

  if Index = 0 then
  begin
    PrevId := CSchedIDnull;
    PrevEndDate := AutoSchedCfg.m_NowDateTime;
  end
  else
  begin
    PrevId := PTJobToSched(m_SchedList[Index -1]).Id;
    PrevEndDate := PTJobToSched(m_SchedList[Index -1]).EndSched;
  end;

  ScoreRecord.prevId := PrevId;

  IgnoreGenericPlan := false;
  IgnoreAddRessMat  := false;
  p_sc.GetDatesInfo(id, DatesInfo);

  if ContinueCheck then
  begin
//    m_ResourcesManager.GetMaterialAddRessList(id, self, MatList, AddRes1, AddRes2, AddRes3, AddRes4, AddRes5, AddRes6, ManPower1, ManPower2, ManPower3, ManPower4, ManPower5, ManPower6);
    checkMovedJob := false;
    if not CheckScoreAfterJob(PrevId, Id , CheckMovedJob,
             LimitStartDate, 0, 0, 0, PrevEndDate ,ScoreRecord ,nil, ValPrev, ValNext,
             MatAddResList, IgnoreGenericPlan, IgnoreAddRessMat,
             SupMinBaseMain, DurationMain, DurationOrgMain,DurationQuantityBaseMain) then ContinueCheck := false;
    m_ResourcesManager.CleanMaterialAddRessList(MatAddResList);
  end;

  if ContinueCheck then
  begin
    if  (ScoreRecord.EndDateTime > ServingCodeLowestPlusTollerance)
    and ScoreAfterLastFound
    and (ScoreRecord.EndDateTime > ScoreAfterLastJob.EndDateTime) then
      ContinueCheck := false;
  end;

  if ContinueCheck then
  begin
     PossitionScore := CalcScore(TMqmRes(TMQMVisibleRes(m_ResPtr).p_Father), id, previd,
                         @ScoreRecord , 999999, CompJobToResMain,
                         ServingGroupCode, ServingCodeLowestDateTime, ServingCodeHighestDateTime);
     ScoreRecord.Score := PossitionScore;
  end;
  if ContinueCheck and (ScoreRecord.StartDateTime >= ToMoveIdEndDate) then ContinueCheck := false;
  ScoreRecord.Gap := 0;

//  FillLogListLine('MOVMainTest',Id, false, @ScoreRecord, m_CompValResToJob_Main, ScoreRecord.Score, 0);

 // if ContinueCheck and ScoreAfterLastFound and (PossitionScore >= ScoreAfterLastJob.Score) then ContinueCheck := false;  // TMG 17/07/2017

  if ContinueCheck then
  begin
    ScoreRecord.prevId := -1;
    if (Index > 0) then
    begin
      PJobToSchedTemp := PTJobToSched(m_SchedList[Index - 1]);
      ScoreRecord.prevId := PJobToSchedTemp.Id;
    end;
    AddIdToList(Id, ScoreRecord, -1, FinalSchdule, false);
    ScoreRecord.Gap := 0;
//    FillLogListLine('MOVMainTestOk',Id, true, @ScoreRecord, m_CompValResToJob_Main, ScoreRecord.Score, 0);
    new(PScoreRecord);
    PScoreRecord^ := ScoreRecord;
    PScoreRecord.Id := id;
    TempScoreList.add(PScoreRecord);
  end;

  LoopStopped := false;
  if ContinueCheck then
  begin
    for I := TempList.Count - 1 downto 0 do
    begin
      CurrentId := PTRemovedIds(TempList[I]).id;
      if not m_ResourcesManager.SetCompatibleRes(CurrentId, '', Self.m_PlantCode, nil) then
      begin
        LoopStopped := true;
        break;
      end;

      if not m_ResourcesManager.FindBestScoreAfterLastJob(CurrentId, true,
               ScoreRecord, 0, PTRemovedIds(TempList[I]).ToMoveStartDate,
               GenericPlanDates, false, HighestPrevEndFound, Self.m_PlantCode) then LoopStopped := true;
      m_ResourcesManager.CleanGenericPlanDates(GenericPlanDates);

      if LoopStopped then break;

  //    p_sc.GetDatesInfo(CurrentId, DatesInfo);
  //    if ((DatesInfo.HighEndDate + AfterHighTolerance(AutoSchedCfg)) < ScoreRecord.EndDateTime) then
  //    begin
  //      LoopStopped := true;
  //      break;
  //    end;

      PossitionScore := PossitionScore - PTRemovedIds(TempList[I]).score + ScoreRecord.Score;

      if ScoreAfterLastFound and (PossitionScore >= ScoreAfterLastJob.Score) then // or (BetterScoreFound and (PossitionScore > NewScore)) then
      begin
        LoopStopped := true;
        break;
      end;

      ScoreRecord.Resource.AddIdToList(CurrentId, ScoreRecord, -1, FinalSchdule, false);
      ScoreRecord.Gap := 0;
//      FillLogListLine('MoveOtherTestOk',CurrentId, true, @ScoreRecord, ScoreRecord.CompValJobToRes, ScoreRecord.Score, 0);
      new(PScoreRecord);
      PScoreRecord^ := ScoreRecord;
      PScoreRecord.Id := CurrentId;
      TempScoreList.add(PScoreRecord);
    end;
  end;

  if not FinalSchdule then
  begin
    RollBackFromList(rollbackIndex);
  end;

  if ContinueCheck and not LoopStopped and (not BetterScoreFound or (PossitionScore < NewScore)) then
  begin
    NewScore := PossitionScore;
    result := true;
    for I := 0 to ScoreList.Count - 1 do
      dispose(PTScoreRecord(ScoreList[I]));
    ScoreList.Clear;
    for I := 0 to TempScoreList.Count - 1 do
      ScoreList.Add(TempScoreList[I])
  end
  else
  begin
    for I := 0 to TempScoreList.Count - 1 do
      dispose(PTScoreRecord(TempScoreList[I]));
  end;

  for I := TempList.Count - 1 downto 0 do
     Dispose(PTRemovedIds(TempList[I]));
  TempList.Clear;
  TempList.free;
  MatAddResList.Free;
  TempScoreList.Free;
  GenericPlanDates.Free;

end;

//----------------------------------------------------------------------------//

function TResourcesStruct.CheckAndScorePositionWithoutMove(Id, PrevId, ToMoveId : TSchedId; ApprovalDate,
          LeftGreenLine, RightGreenLine, PrevIdEndDateTime, ToMoveIdStartDateTime, ValPrev, ValNext : TDateTime;
          ScoreAfterLastJob : TScoreRecord; ScoreAfterLastFound : boolean;
          MatAddResList, GenericPlanDates : Tlist;
          ToMoveIdIndex, ResourceIndex : Integer; MainIdServingGroupCode : String;
          MainIdServingCodeLowestDateTime, MainIdServingCodeHighestDateTime,
          LimitStartDate, MainIdServingCodeLowestPlusTollerance : TDateTime;
          SupMinBaseMain, DurationMain, DurationOrgMain, DurationQuantityBaseMain : Double; CompJobToResMain : TCompatVal;
          var SchedBetweenJobsScoreFound : Boolean; var SchedBetweenJobsScore : double;
          var SchedBetweenJobsIdIndex, SchedBetweenJobsResourceIndex : Integer;
          var ReturnScoreRecordIdToPrevId, ReturnScoreRecordToMoveIdToId : TScoreRecord; CanBeNewId : boolean) : boolean;

var
  IgnoreGenericPlan, IgnoreAddRessMat, ShouldExit, checkMovedJob : Boolean;
  ScoreRecord, ScoreRecordIdToPrevId : TScoreRecord;
  supMinBase, Setup, Overlap, GenericPlanDur, GenericPlanleadTime, PositionScore, ScoreIdToPrevId, ScoreToMoveIdToId : Double;
  CompValJobToJob : TCompatVal;
  GenericPlanWc, CurrenctGenericPlanWc : string;
  ToMoveIdNewStartDateTime, ToMoveIdNewEndDateTime : TDateTime;
  MatAddResListT : Tlist;
  ValPrevTemp, ValNextTemp : variant;
  dataType: CBinColValType;
  DatesInfo: TSQDatesInfo;
//  MainIdUsedAsTrueEvenIfFalse : boolean;
  ServingGroupCode : String;
  ServingCodeLowestDateTime, ServingCodeHighestDateTime, DummyDateTime : TDateTime;
  ServingCodeHighestMinusTollerance, NewDate, LimitEndDateTime : TDateTime;
  Gap1, Gap2 : TDateTime;
  ListStrRes, ListStrCmpToRes, ListStrSupMinBase, ListStrDuration, ListStrDurationOrg,
  ListStrStandBatchSize , ListStrMinBatchSize, ListStrMaxBatchSize : TStringList;
  DurationQuantityBase : double;
  I, Multiplier, NumberOfEntries, Position : Integer;
  ResourcesStruct : TResourcesStruct;
  RecalcDur : boolean;
  exeMin, exeMinOrg, supMinReal, supMinOvlp, JobQty, DurationOrgMainForJob, LowOverLap, HighOverLap : double;
  StartDate, EndDate : TDateTime;
  JobIdFromBackup : PTJobInfo;
  RequestToMoveId : String;
  SecondsForcedGap : integer;
  TotalCurveBeforePos : double;
  ExistIdsAfterPos, TempBoolean : boolean;
  StepType : CScSchedType;
  MainIdQuantity, MainIdDuration : double;
  ComparePossition : integer;
begin
  result := false;

  if ValPrev >= ToMoveIdStartDateTime then exit;

  supMinBase := PTJobToSched(m_SchedList[ToMoveIdIndex]).supMinBase;
  exeMin := PTJobToSched(m_SchedList[ToMoveIdIndex]).Duration;
  exeMinOrg := PTJobToSched(m_SchedList[ToMoveIdIndex]).DurationOrg;
  CurrenctGenericPlanWc := PTJobToSched(m_SchedList[ToMoveIdIndex]).GenericPlanWC;
  StartDate := PTJobToSched(m_SchedList[ToMoveIdIndex]).StartSched;
  EndDate := PTJobToSched(m_SchedList[ToMoveIdIndex]).EndSched;
  supMinReal := PTJobToSched(m_SchedList[ToMoveIdIndex]).Setup;
  supMinOvlp := PTJobToSched(m_SchedList[ToMoveIdIndex]).SetUpNoMaterial;
  LowOverLap := PTJobToSched(m_SchedList[ToMoveIdIndex]).LowOverLap;
  HighOverLap := PTJobToSched(m_SchedList[ToMoveIdIndex]).HighOverLap;
//  if not CalcSetupAndCompatability(ToMoveId, Id , m_ActArea, CompValJobToJob, supMinBase,
//      Setup, Overlap, GenericPlanWc, GenericPlanDur, GenericPlanleadTime) then Exit;
  JobQty := p_sc.GetJobQty(id);
  StepType := p_sc.GetJobType(id);
  if (StepType = CST_Continuous) and (JobQty <> DurationQuantityBaseMain) then
    DurationOrgMainForJob := DurationOrgMain * JobQty / DurationQuantityBaseMain
  else
    DurationOrgMainForJob := DurationOrgMain;

  m_cal.OfsByWH(-(exeMinOrg+DurationOrgMainForJob)/60, false, endDate, NewDate, m_ActArea.m_CrossDownTmList);
  if NewDate < PrevIdEndDateTime then
    exit;

 { m_cal.OfsByWH(DurationMain/60, true, PrevIdEndDateTime, NewDateTmp1, m_ActArea.m_CrossDownTmList);
  if NewDateTmp1 > StartDate then
  begin
    m_cal.OfsByWH(-(exeMin)/60, false, endDate, NewDateTmp2, m_ActArea.m_CrossDownTmList);
    if NewDateTmp1 > NewDateTmp2 then
      exit;
  end;      }

  if DoesCurveExistAfterDate(Id, m_CurveByFamilyInfo, StartDate) then
    exit;   // We do not support schedule before same family as then we need to calculate all future id's.

  Self.m_ResourcesManager.CheckSetupCompactParam(ToMoveId,Id,Self.m_ResCode,m_ActArea, CompValJobToJob,
      supMinBase, Setup, Overlap, GenericPlanWc, GenericPlanDur, GenericPlanleadTime, RecalcDur);

  if RecalcDur then // No need to add total from same family before as we will exit if this id has the same family as ToMoveId
     exeMin := exeMinOrg + GetCurveTime(m_ActArea, DummyDateTime, ToMoveId, exeMinOrg, false, 0);

   if exeMin > exeMinOrg then
   begin
     m_cal.OfsByWH(-(exeMin+DurationOrgMainForJob)/60, false, endDate, NewDate, m_ActArea.m_CrossDownTmList);
     if NewDate < PrevIdEndDateTime then
       exit;
   end;

//  if setup > PlanInfo.supMinReal then exit;
  if (GenericPlanWc <> '') and (CurrenctGenericPlanWc = '') then exit;

  ToMoveIdNewStartDateTime := StartDate;
  ToMoveIdNewEndDateTime := endDate;
  if setup < supMinReal then
    m_cal.OfsByWH(-(setup + exeMin)/60, false, endDate, ToMoveIdNewStartDateTime, m_ActArea.m_CrossDownTmList);
  if setup > supMinReal then
 //   m_cal.OfsByWH((setup + PlanInfo.exeMin)/60, true, planInfo.startDate, ToMoveIdNewEndDateTime, m_ActArea.m_CrossDownTmList);
  begin
    m_cal.OfsByWH(-(setup + exeMin)/60, false, endDate, NewDate, m_ActArea.m_CrossDownTmList);
    if CheckScoreAfterJob(PrevId, Id , false, LimitStartDate, 0, NewDate, 0,
            PrevIdEndDateTime ,ScoreRecordIdToPrevId ,GenericPlanDates, ValPrev, ValNext,
            MatAddResList, false, false, SupMinBaseMain, DurationMain, DurationOrgMain, DurationQuantityBaseMain) then
      ToMoveIdNewStartDateTime := NewDate
    else
      m_cal.OfsByWH((setup + exeMin)/60, true, startDate, ToMoveIdNewEndDateTime, m_ActArea.m_CrossDownTmList);
  end;

  if  ((ToMoveIdIndex+1) < m_SchedList.Count)
  and (ToMoveIdNewEndDateTime > PTJobToSched(m_SchedList[ToMoveIdIndex+1]).StartSched) then exit;

//  if ToMoveIdNewStartDateTime < PlanInfo.startDate then exit;

  if not CheckScoreAfterJob(PrevId, Id , false, LimitStartDate, 0, ToMoveIdNewStartDateTime, 0,
              PrevIdEndDateTime ,ScoreRecordIdToPrevId ,GenericPlanDates, ValPrev, ValNext,
              MatAddResList, false, false, SupMinBaseMain, DurationMain, DurationOrgMain, DurationQuantityBaseMain) then exit;

  if  (ScoreRecordIdToPrevId.EndDateTime > MainIdServingCodeLowestPlusTollerance)
  and ScoreAfterLastFound
  and (ScoreRecordIdToPrevId.EndDateTime > ScoreAfterLastJob.EndDateTime) then exit;

  if not m_ResourcesManager.SetCompatibleRes(ToMoveId, '', self.m_PlantCode, nil) then exit;
  ListStrRes := GetInformationById(ToMoveId, ListStrCmpToRes, ListStrSupMinBase, ListStrDuration, ListStrDurationOrg,
                ListStrStandBatchSize , ListStrMinBatchSize, ListStrMaxBatchSize, Position, DurationQuantityBase);
  if ListStrRes = nil then exit;
  ShouldExit := true;
  NumberOfEntries := ListStrRes.Count;
  I := 0;
  if NumberOfEntries > 0 then
  begin
    Multiplier := 1;
    while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    i := Multiplier - 1;
    while (Multiplier > 0) do
    begin
      Multiplier := trunc(Multiplier / 2);
      if  (i >= NumberOfEntries) then
      begin
        i := i - Multiplier;
        Continue;
      end;
      ResourcesStruct := FindResourceByCode(ListStrRes.Strings[I], m_ResourcesManager.m_AllResList);
      if (ResourcesStruct.m_PlanType = m_PlanType) and (ResourcesStruct.m_ResCode = m_ResCode) then
      begin
        ShouldExit := false;
        break;
      end;
      if ResourcesStruct.m_PlanType < m_PlanType then
      begin
        i := i + Multiplier;
        continue;
      end;
      if ResourcesStruct.m_PlanType > m_PlanType then
      begin
        i := i - Multiplier;
        continue;
      end;
      if ResourcesStruct.m_ResCode < m_ResCode then
        i := i + Multiplier
      else
        i := i - Multiplier;
    end;
  end;

{  for I := 0 to ListStrRes.Count - 1 do
  begin
    ResourcesStruct := FindResourceByCode(ListStrRes.Strings[I], m_ResourcesManager.m_AllResList);
    if ResourcesStruct = nil then Continue;
//    assert(assigned(ResourcesStruct.m_Cal));
    if ResourcesStruct.m_ResCode <> m_ResCode then Continue;
    ShouldExit := false;
    break;
  end;  }

  if ShouldExit then exit;

  ServingCodeHighestMinusTollerance := 0;
  if p_sc.GetServingGroupLowestHighiestDates(ToMoveId,ServingGroupCode,ServingCodeLowestDateTime,ServingCodeHighestDateTime) then
  begin
    if AutoSchedCfg.m_RescheduleErlierJobsWhenTolerance then
       ServingCodeHighestMinusTollerance := ServingCodeHighestDateTime - (AutoSchedCfg.m_HoursToleranceOfGapBetweenJobs / 24);
  end;

//   if (setup < PlanInfo.supMinReal) and (ScoreRecordIdToPrevId.EndDateTime <= ToMoveIdStartDateTime) then
  if (setup <> supMinReal) or (Overlap <> supMinOvlp) then
  begin

    p_sc.GetDatesInfo(id, DatesInfo);
   // if not p_sc.GetFldValue(ToMoveId, CSC_PrvHighestDate, ValPrevTemp, dataType) then ValPrevTemp := 0;
   // if not p_sc.GetFldValue(ToMoveId, CSC_NxtLowestDate, ValNextTemp, dataType) then ValNextTemp := 0;
    ValPrevTemp := p_sc.GetPrvHighestDate(ToMoveId);
    ValNextTemp := p_sc.GetNextHighiestEndDate(ToMoveId);

    checkMovedJob := true;
    IgnoreGenericPlan := true;
    IgnoreAddRessMat  := false;

    MatAddResListT := TList.Create;
    ShouldExit := false;
//    MainIdUsedAsTrueEvenIfFalse := true; // DO NOT CHANGE

    SecondsForcedGap := 0;
    if ((ToMoveIdIndex+1) < m_SchedList.Count)
    and (AutoSchedCfg.m_SplitSchedByBatchSize = DailyProductionAndJoin)
    and (not AutoSchedCfg.m_PushToThePreferedDateMode)
    and (StrToFloat(ListStrMinBatchSize.Strings[I]) = - 1) then
    begin
      JobIdFromBackup := FindIdInBackUpList(ToMoveId, m_ResourcesManager.m_ListBackupIdInfo);
      if JobIdFromBackup <> nil then
      begin
        RequestToMoveId := JobIdFromBackup.RequestNumber;
        JobIdFromBackup := FindIdInBackUpList(PTJobToSched(m_SchedList[ToMoveIdIndex+1]).Id, m_ResourcesManager.m_ListBackupIdInfo);
        if (JobIdFromBackup <> nil) and (RequestToMoveId = JobIdFromBackup.RequestNumber) then
          SecondsForcedGap := 4;
      end;
    end;

    if (ToMoveIdIndex+1) < m_SchedList.Count then
      LimitEndDateTime := PTJobToSched(m_SchedList[ToMoveIdIndex+1]).StartSched - (1 / 24 / 60 / 60 * SecondsForcedGap)
    else
      LimitEndDateTime := 0;

 //   m_ResourcesManager.GetMaterialAddRessList(ToMoveId, self, MatListT, AddRes1T, AddRes2T, AddRes3T, AddRes4T, AddRes5T, AddRes6T, ManPower1T, ManPower2T, ManPower3T, ManPower4T, ManPower5T, ManPower6T);
       // LimitEndDateTime was added by Eran 26/10/2017 because when try to push = yes,  CheckScoreAfterJob returns a prefered date but it must be limited not to go over the next job
    MainIdQuantity := DurationQuantityBase;
    MainIdDuration := StrToFloat(ListStrDurationOrg.Strings[I]);
    if not CheckScoreAfterJob(Id, ToMoveId, checkMovedJob, ServingCodeHighestMinusTollerance, 0, LimitEndDateTime, 0,
       // ToMoveIdStartDateTime replaced by  ToMoveIdNewStartDateTime by Eran 29/05
       // Eran 27/01/2019 ToMoveIdNewStartDateTime replaced AGAIN,
       //  this time by ScoreRecordIdToPrevId.EndDateTime as this is actually the id end date.
       //  The problem is that if the prev and is the tomoveid start, if we do not allow to push
       //  jobs and the tomoveid is late, this place will be ignored.
             ScoreRecordIdToPrevId.EndDateTime ,ScoreRecord ,nil, ValPrevTemp, ValNextTemp,
             MatAddResListT, IgnoreGenericPlan, IgnoreAddRessMat,
             StrToFloat(ListStrSupMinBase.Strings[I]), StrToFloat(ListStrDuration.Strings[I]),
             StrToFloat(ListStrDurationOrg.Strings[I]),
             DurationQuantityBase) then ShouldExit := true;
    LowOverLap := ScoreRecord.LowOverLap;
    HighOverLap := ScoreRecord.HighOverLap;

    m_ResourcesManager.CleanMaterialAddRessList(MatAddResListT);
    MatAddResListT.Free;

    if ShouldExit then exit;

//    if ScoreRecord.EndDateTime > PlanInfo.endDate then exit;
    // Altthough LimitEndDateTime was added by Eran 26/10/2017 - see above, I decided to leave this check for security
    if  ((ToMoveIdIndex+1) < m_SchedList.Count)
    and (ScoreRecord.EndDateTime > PTJobToSched(m_SchedList[ToMoveIdIndex+1]).StartSched) then exit;

    ToMoveIdNewStartDateTime := ScoreRecord.StartDateTime;
    ToMoveIdNewEndDateTime := ScoreRecord.EndDateTime;

  end;

  result := true;

  ScoreIdToPrevId := CalcScore(TMqmRes(TMQMVisibleRes(m_ResPtr).p_Father), id, previd,
                               @ScoreRecordIdToPrevId , 999999, CompJobToResMain,
                               MainIdServingGroupCode, MainIdServingCodeLowestDateTime,
                               MainIdServingCodeHighestDateTime);
  PositionScore := ScoreIdToPrevId;

  PositionScore := PositionScore - PTJobToSched(m_SchedList[ToMoveIdIndex]).score;

  ScoreRecord.prevId := Id;
  ScoreRecord.Score := 0;
  ScoreRecord.StartDateTime := ToMoveIdNewStartDateTime;
  ScoreRecord.Resource := self;
  ScoreRecord.EndDateTime := ToMoveIdNewEndDateTime;
  ScoreRecord.supMinBase := SupMinBase;
  ScoreRecord.Setup := setup;
  ScoreRecord.SetupNoMaterial := Overlap;
  ScoreRecord.Duration := exeMin;
  ScoreRecord.DurationOrg := exeMinOrg;
  ScoreRecord.GenericPlanWc := GenericPlanWc;
  ScoreRecord.GenericPlanleadTime := GenericPlanleadTime;
  ScoreRecord.GenericPlanDuration := GenericPlanDur;
  ScoreRecord.CompValJobToJob:= CompValJobToJob;

  ScoreToMoveIdToId := CalcScore(TMqmRes(TMQMVisibleRes(m_ResPtr).p_Father), ToMoveId, id,
                                 @ScoreRecord , 999999, StrToInt(ListStrCmpToRes.Strings[I]),
                                 ServingGroupCode, ServingCodeLowestDateTime,
                                 ServingCodeHighestDateTime);
  PositionScore := PositionScore + ScoreToMoveIdToId;
  ScoreRecord.Gap := 0;
//  FillLogListLine('BTWTestOk',Id, false, @ScoreRecord, m_CompValResToJob_Main, PositionScore, 0);
  if AutoSchedCfg.m_PushToThePreferedDateMode then
    TempBoolean := false
  else
    TempBoolean := true;

  if not SchedBetweenJobsScoreFound then
  begin
    if ScoreAfterLastFound then
    begin
      ComparePossition := IsPossitionBetter(ScoreAfterLastJob.Resource.m_PlanType, ScoreRecordIdToPrevId.Resource.m_PlanType,
                           ScoreAfterLastJob.StartDateTime, ScoreRecordIdToPrevId.StartDateTime,
                           ScoreAfterLastJob.EndDateTime, ScoreRecordIdToPrevId.EndDateTime,
                           LeftGreenLine, RightGreenLine, ApprovalDate,
                           ScoreAfterLastJob.LowOverlap, ScoreRecordIdToPrevId.LowOverlap,
                           ScoreAfterLastJob.HighOverlap, ScoreRecordIdToPrevId.HighOverlap,
                           ScoreAfterLastJob.Score, PositionScore,
                           TempBoolean, false);
      if ComparePossition < 0 then
        exit;
      if (ComparePossition = 0) and CanBeNewId and (ScoreAfterLastJob.NextNotPossibleDate > ScoreRecordIdToPrevId.NextNotPossibleDate) then
        exit;
    end;
  end
  else
  begin
    ComparePossition := IsPossitionBetter(ReturnScoreRecordIdToPrevId.Resource.m_PlanType, ScoreRecordIdToPrevId.Resource.m_PlanType,
                         ReturnScoreRecordIdToPrevId.StartDateTime, ScoreRecordIdToPrevId.StartDateTime,
                         ReturnScoreRecordIdToPrevId.EndDateTime, ScoreRecordIdToPrevId.EndDateTime,
                         LeftGreenLine, RightGreenLine, ApprovalDate,
                         ReturnScoreRecordIdToPrevId.LowOverlap, ScoreRecordIdToPrevId.LowOverlap,
                         ReturnScoreRecordIdToPrevId.HighOverlap, ScoreRecordIdToPrevId.HighOverlap,
                         SchedBetweenJobsScore, PositionScore,
                         TempBoolean, false);
    if ComparePossition < 0 then
      exit;
    if (ComparePossition = 0) then
    begin
      if not CanBeNewId then
        exit;
      if (ReturnScoreRecordIdToPrevId.NextNotPossibleDate > ScoreRecordIdToPrevId.NextNotPossibleDate) then
        exit;
    end;
  end;

  SchedBetweenJobsScoreFound := true;
  SchedBetweenJobsScore := PositionScore;
  SchedBetweenJobsIdIndex := ToMoveIdIndex;
  SchedBetweenJobsResourceIndex := ResourceIndex;

  ReturnScoreRecordIdToPrevId.prevId := PrevId;
  ReturnScoreRecordIdToPrevId.Score := ScoreIdToPrevId;
  ReturnScoreRecordIdToPrevId.ScoreJobToJob := ScoreRecordIdToPrevId.ScoreJobToJob;
  ReturnScoreRecordIdToPrevId.ScoreJobToRes := ScoreRecordIdToPrevId.ScoreJobToRes;
  ReturnScoreRecordIdToPrevId.StartDateTime := ScoreRecordIdToPrevId.StartDateTime;
  ReturnScoreRecordIdToPrevId.Resource := self;
  ReturnScoreRecordIdToPrevId.EndDateTime := ScoreRecordIdToPrevId.EndDateTime;
  ReturnScoreRecordIdToPrevId.supMinBase := ScoreRecordIdToPrevId.supMinBase;
  ReturnScoreRecordIdToPrevId.Setup := ScoreRecordIdToPrevId.Setup;
  ReturnScoreRecordIdToPrevId.SetupNoMaterial := ScoreRecordIdToPrevId.SetupNoMaterial;
  ReturnScoreRecordIdToPrevId.Duration := ScoreRecordIdToPrevId.Duration;
  ReturnScoreRecordIdToPrevId.DurationOrg := ScoreRecordIdToPrevId.DurationOrg;
  ReturnScoreRecordIdToPrevId.GenericPlanWc := ScoreRecordIdToPrevId.GenericPlanWc;
  ReturnScoreRecordIdToPrevId.GenericPlanleadTime := ScoreRecordIdToPrevId.GenericPlanleadTime;
  ReturnScoreRecordIdToPrevId.GenericPlanDuration := ScoreRecordIdToPrevId.GenericPlanDuration;
  ReturnScoreRecordIdToPrevId.CompValJobToJob:= ScoreRecordIdToPrevId.CompValJobToJob;
  ReturnScoreRecordIdToPrevId.CompValJobToRes := CompJobToResMain;
  ReturnScoreRecordIdToPrevId.LowOverlap := ScoreRecordIdToPrevId.LowOverlap;
  ReturnScoreRecordIdToPrevId.HighOverlap := ScoreRecordIdToPrevId.HighOverlap;
  ReturnScoreRecordIdToPrevId.MainIdQuantity := DurationQuantityBaseMain;
  ReturnScoreRecordIdToPrevId.MainIdDuration := DurationOrgMain;
  ReturnScoreRecordIdToPrevId.NextNotPossibleDate := ScoreRecordIdToPrevId.NextNotPossibleDate;

  ReturnScoreRecordToMoveIdToId.prevId := Id;
  ReturnScoreRecordToMoveIdToId.Score := ScoreToMoveIdToId;
  ReturnScoreRecordToMoveIdToId.ScoreJobToJob := ScoreRecord.ScoreJobToJob;
  ReturnScoreRecordToMoveIdToId.ScoreJobToRes := ScoreRecord.ScoreJobToRes;
  ReturnScoreRecordToMoveIdToId.StartDateTime := ToMoveIdNewStartDateTime;
  ReturnScoreRecordToMoveIdToId.Resource := self;
  ReturnScoreRecordToMoveIdToId.EndDateTime := ToMoveIdNewEndDateTime;
  ReturnScoreRecordToMoveIdToId.supMinBase := supMinBase;
  ReturnScoreRecordToMoveIdToId.Setup := Setup;
  ReturnScoreRecordToMoveIdToId.SetupNoMaterial := Overlap;
  ReturnScoreRecordToMoveIdToId.Duration := exeMin;
  ReturnScoreRecordToMoveIdToId.DurationOrg := exeMinOrg;
  ReturnScoreRecordToMoveIdToId.GenericPlanWc := GenericPlanWc;
  ReturnScoreRecordToMoveIdToId.GenericPlanleadTime := GenericPlanleadTime;
  ReturnScoreRecordToMoveIdToId.GenericPlanDuration := GenericPlanDur;
  ReturnScoreRecordToMoveIdToId.CompValJobToJob:= CompValJobToJob;
  ReturnScoreRecordToMoveIdToId.CompValJobToRes := StrToInt(ListStrCmpToRes.Strings[I]);
  ReturnScoreRecordToMoveIdToId.LowOverlap := LowOverlap;
  ReturnScoreRecordToMoveIdToId.HighOverlap := HighOverlap;
  ReturnScoreRecordToMoveIdToId.MainIdQuantity := MainIdQuantity;
  ReturnScoreRecordToMoveIdToId.MainIdDuration := MainIdDuration;
  ReturnScoreRecordToMoveIdToId.NextNotPossibleDate := ScoreRecord.NextNotPossibleDate;

end;

//----------------------------------------------------------------------------//

function  TResourcesStruct.CalcScoreToAnAlreadySchedJob(ToMoveIdIndex : integer; ServingGroupCode : String) : boolean;
var
  PJobToSched : PTJobToSched;
  ScoreRecord : TScoreRecord;
  PlanInfo : TSQplanInfo;
  PrevId, CurrentId : TSchedId;
  CompValJobToRes, CompValJobToJob : TCompatVal;
  IsSameGroup, ShouldExit : Boolean;
  supRec: TSetupRec;
  Score : Double;
  VisRes : TMQMVisibleRes;
  LearningCurveCode : string;
  ServingCodeExist : Boolean;
  DummyString : String;
  ServingCodeLowestDateTime, ServingCodeHighestDateTime : TDateTime;
  Dependency : boolean;
  begin
  result := false;

  PJobToSched := PTJobToSched(m_SchedList[ToMoveIdIndex]);
  CurrentId := PJobToSched.Id;

  ServingCodeExist := false;

  if (ServingGroupCode <> '')
  and ((AutoSchedCfg.m_PenaltyScoreWithinTolerance > 0) or (AutoSchedCfg.m_PenaltyScoreAfterTolerance > 0)) then
  begin
    ServingCodeExist := true;
    p_sc.GetServingGroupLowestHighiestDates(CurrentId,DummyString,ServingCodeLowestDateTime,ServingCodeHighestDateTime);
  end;

  if (PJobToSched.score <> -999) and (not ServingCodeExist) then
  begin
    result := true;
    exit;
  end;

  if ToMoveIdIndex = 0 then
     PrevId := CSchedIDnull
  else
     PrevId := PTJobToSched(m_SchedList[ToMoveIdIndex-1]).Id;

  p_sc.GetPlanInfo(CurrentId, PlanInfo);

  if (PJobToSched.score = -999) then
  begin
    VisRes := TMQMVisibleRes(m_ResPtr);
    ShouldExit := false;
    p_pl.EnterCompatModeInPlanForAutoSeq(CurrentId, Pointer(TMqmRes(VisRes).p_Father));
    if not VisRes.CheckCompatWithOcc([cho_compVal, cho_timing, cho_wkc,
       cho_readOnly, cho_qty, cho_Depend], CurrentId, 0, nil, CompValJobToRes, Dependency) then ShouldExit := true;
    p_pl.ExitCompatModeInPlanForAutoSeq;
    if ShouldExit then exit;

    if PrevId = CSchedIDnull then
      CompValJobToJob := 1
    else
      if not TMqmRes(TMQMVisibleRes(m_ResPtr).p_Father).GetSetupParms(CurrentId, PrevId, supRec,
       CompValJobToJob, IsSameGroup, LearningCurveCode) then exit;
  end
  else
  begin
    CompValJobToRes := PJobToSched.CompValJobToRes;
    CompValJobToJob := PJobToSched.CompValJobToJob;
  end;

  ScoreRecord.prevId := PrevId;
  ScoreRecord.Score := 0;
  ScoreRecord.StartDateTime := PlanInfo.startDate;
  ScoreRecord.Gap := 0;
  ScoreRecord.Resource := self;
  ScoreRecord.EndDateTime := PlanInfo.endDate;
  ScoreRecord.supMinBase := PlanInfo.supMinBase;
  ScoreRecord.Setup := PlanInfo.supMinReal;
  ScoreRecord.SetupNoMaterial := PlanInfo.supMinOvlp;
  ScoreRecord.Duration := PlanInfo.exeMin;
  ScoreRecord.GenericPlanWc := PlanInfo.GenericPlanWC;
  ScoreRecord.GenericPlanleadTime := PlanInfo.GenericPlanLeadTime;
  ScoreRecord.GenericPlanDuration := PlanInfo.GenericPlanDur;
  ScoreRecord.CompValJobToJob:= CompValJobToJob;

  Score := CalcScore(TMqmRes(TMQMVisibleRes(m_ResPtr).p_Father), CurrentId, PrevId,
                     @ScoreRecord , 999999, CompValJobToRes,
                     ServingGroupCode, ServingCodeLowestDateTime, ServingCodeHighestDateTime);
  PTJobToSched(m_SchedList[ToMoveIdIndex]).score := Score;
  PTJobToSched(m_SchedList[ToMoveIdIndex]).ServingGroup := ServingGroupCode;
  PTJobToSched(m_SchedList[ToMoveIdIndex]).ServinglowestDate := ServingCodeLowestDateTime;
  PTJobToSched(m_SchedList[ToMoveIdIndex]).ServingHighestDate := ServingCodeHighestDateTime;
  PTJobToSched(m_SchedList[ToMoveIdIndex]).CompValJobToJob := CompValJobToJob;
  PTJobToSched(m_SchedList[ToMoveIdIndex]).CompValJobToRes := CompValJobToRes;

  result := true;

end;

//----------------------------------------------------------------------------//

function TResourcesStruct.CalcScore(ResPtr : pointer; id, previd : TSchedId; ScoreRecord : PTScoreRecord; LowestEndDateTime : TDateTime;
                          CompValResToJob : TCompatVal; ServingGroupCode : String; LowestServingCodeDateTime, HighestServingCodeDateTime : TDateTime) : double;
var
  PenaltyDateScore, MaxCaseToCapResPenalty : Double;

  GapFromLowestEndInHours : double;
  A : Integer;
  PJobToJobDefinitions : PTJobToJobDefinitions;
  CompVal : TCompatVal;
  GapHours : double;
begin
  // need to handle also score to capacity reservation

  Result := 0;

  GapHours := 0;
  if LowestServingCodeDateTime > 0 then
  begin
    if ScoreRecord.StartDateTime < LowestServingCodeDateTime then
       GapHours := (LowestServingCodeDateTime - ScoreRecord.StartDateTime) * 24
    else
      GapHours := (ScoreRecord.StartDateTime - LowestServingCodeDateTime) * 24;
  end;

  if GapHours > 0 then
  begin
    if GapHours <= AutoSchedCfg.m_HoursToleranceOfGapBetweenJobs then
      Result := Result + (GapHours * AutoSchedCfg.m_PenaltyScoreWithinTolerance)
    else
    begin
      Result := Result + (AutoSchedCfg.m_HoursToleranceOfGapBetweenJobs * AutoSchedCfg.m_PenaltyScoreWithinTolerance);
      Result := Result + ((GapHours - AutoSchedCfg.m_HoursToleranceOfGapBetweenJobs) * AutoSchedCfg.m_PenaltyScoreAfterTolerance)
    end;
  end;

  ScoreRecord.ServingGroup := ServingGroupCode;
  ScoreRecord.ServinglowestDate := LowestServingCodeDateTime;
  ScoreRecord.ServingHighestDate := HighestServingCodeDateTime;

  ScoreRecord.ScoreJobToJob := 0;
  ScoreRecord.ScoreJobToRes := 0;
  ScoreRecord.CompValJobToRes := CompValResToJob;

  GapFromLowestEndInHours := 0;
  if (LowestEndDateTime > 0) and  (ScoreRecord.EndDateTime > LowestEndDateTime) then
     GapFromLowestEndInHours := (ScoreRecord.EndDateTime - LowestEndDateTime) * 24;

  CompVal := CompValResToJob;
  if CompVal < 2 then CompVal := 0;

  ScoreRecord.ScoreJobToRes := CompVal * AutoSchedCfg.m_PenCompJobToRes {* CompScoreWeight};
  Result := Result + ScoreRecord.ScoreJobToRes;

  CompVal := ScoreRecord.CompValJobToJob;
  if CompVal < 2 then CompVal := 0;

  if AutoSchedCfg.m_PenCompSetupMinutes > 0 then
    ScoreRecord.ScoreJobToJob := (ScoreRecord.setup-ScoreRecord.supMinBase)/60 * AutoSchedCfg.m_PenCompSetupMinutes {* CompScoreWeight}
  else
    ScoreRecord.ScoreJobToJob := CompVal * AutoSchedCfg.m_PenCompJobToJob {* CompScoreWeight};
  Result := Result + ScoreRecord.ScoreJobToJob;

  PenaltyDateScore := CalcDateScore(Id , ScoreRecord.StartDateTime , ScoreRecord.EndDateTime);
  PenaltyDateScore := PenaltyDateScore + (GapFromLowestEndInHours * AutoSchedCfg.m_ScheduleToPossibleStartPenalty);
  Result := Result + PenaltyDateScore;
  ScoreRecord.PenaltyDateScore := PenaltyDateScore;

  if AutoSchedCfg.m_ListOfJobToJobDefinitions.Count > 0 then
  begin
    for A := 0 to AutoSchedCfg.m_ListOfJobToJobDefinitions.Count - 1 do
    begin
      PJobToJobDefinitions := PTJobToJobDefinitions(AutoSchedCfg.m_ListOfJobToJobDefinitions[A]);
      if (ScoreRecord.CompValJobToJob >= PJobToJobDefinitions.FromCase) and
         (ScoreRecord.CompValJobToJob <= PJobToJobDefinitions.ToCase) then
      begin
        ScoreRecord.ScoreJobToJob := ScoreRecord.ScoreJobToJob + PJobToJobDefinitions.AddToScore;
        Result := Result + PJobToJobDefinitions.AddToScore
      end;
    end;
  end;

  CompVal := m_actArea.FindMaxCaseCapRes(ScoreRecord.StartDateTime, ScoreRecord.EndDateTime, Id);
  if CompVal < 2 then CompVal := 0;
  MaxCaseToCapResPenalty := CompVal * AutoSchedCfg.m_PenCompJobToCapRes;
  Result := Result + MaxCaseToCapResPenalty;

end;

//----------------------------------------------------------------------------//

function TResourcesStruct.CheckScoreAfterJob(PrevId, Id : TSchedId; CheckMovedJob : boolean;
            LimitStartDate, MaxStartDate, LimitEndDate, MovedJobStartDate, PrevEndDate : TDateTime;
            var ScoreRecord : TScoreRecord; GenericPlanDates : TList; PrvHighestDate, NxtLowestDate : TDateTime;
            var MatAddResList : TList;
            IgnoreGenericPlan : boolean; IgnoreAddRessMat : boolean;
            SupMinBase, Duration, DurationOrg, DurationQuantityBase : Double) : boolean;
var
  PreviousEndDateTime, HighEndDate, DateToCheck, ReferenceLowDateAllowed{, SavedStartingDate} : TDateTime;
//  DatesInfo: TSQDatesInfo;
  GenericPlanPlanInfo : TSQplanInfo;
  OutStartDate, OutEndDate, SaveDateTime, TempDateTime, PreferedStartDate, EndOfGantt, LowestHighDate : TDateTime;
  OutMachineNumber, TempIndex : Integer;
  LowOvlopLimit, HighOvlpLimit, MovedJobLimitDate, LowOvlopLimitTmp, HighOvlpLimitTmp, DummyDateTime : TDateTime;
  Pos, I : integer;
  PGenericPlan : PTGenericPlan;
  GenericPlanPositionFound, GenericPlanSavedAlready, First : Boolean;
  LimitToCheck : integer;
  DateTmp : variant;
  QtyVal : double;
  StepType : CScSchedType;
  dataType: CBinColValType;
  SecondsDifference : LongInt;
  RecalcDur : boolean;
  ForcesInfo: TSQForcesInfo;
  CurveTotalBefore : double;
  MaxStartingDateAutoSeq : TDateTime;
  NextNotPossibleDateTemp : TDateTime;
begin
  Result := false;

  if AutoSchedCfg.m_AllowedLatestDateLimit = 1 then
  begin
   if (AutoSchedCfg.m_ScheduleDateLimitDate < MaxStartDate) or (MaxStartDate = 0) then
     MaxStartDate := AutoSchedCfg.m_ScheduleDateLimitDate;
  end;

  MaxStartingDateAutoSeq := p_sc.GetMaxStartingDateAutoSeq(id);
  if MaxStartingDateAutoSeq > 0 then
  begin
    if (MaxStartingDateAutoSeq < MaxStartDate) or (MaxStartDate = 0) then
      MaxStartDate := MaxStartingDateAutoSeq;
  end;

  if AutoSchedCfg.m_AllowedLatestDateLimit = 2 then
  begin
   if (AutoSchedCfg.m_ScheduleDateLimitDate < LimitEndDate) or (LimitEndDate = 0) then
     LimitEndDate := AutoSchedCfg.m_ScheduleDateLimitDate;
  end;

  ScoreRecord.Id := Id;
  ScoreRecord.prevId := PrevId;
  ScoreRecord.Score := 0;
  ScoreRecord.ScoreJobToJob := 0;
  ScoreRecord.ScoreJobToRes := 0;
  ScoreRecord.StartDateTime := 0;
  ScoreRecord.Gap := 0;
  ScoreRecord.Resource := self;
  ScoreRecord.EndDateTime := 0;
  ScoreRecord.supMinBase := 0;
  ScoreRecord.Setup := 0;
  ScoreRecord.SetupNoMaterial := 0;
  ScoreRecord.Duration := 0;
  ScoreRecord.DurationOrg := 0;
  ScoreRecord.GenericPlanWc := '';
  ScoreRecord.GenericPlanleadTime := 0;
  ScoreRecord.GenericPlanDuration := 0;
  ScoreRecord.CompValJobToJob := 0;
  ScoreRecord.CompValJobToRes := 0;
  ScoreRecord.ServingGroup := '';
  ScoreRecord.ServinglowestDate := 0;
  ScoreRecord.ServingHighestDate := 0;
  ScoreRecord.LowOverlap := 0;
  ScoreRecord.HighOverlap := 0;
  ScoreRecord.NextNotPossibleDate := 999999;
  GenericPlanPositionFound := false;
  HighEndDate := p_sc.GetHighEnd(id);
  p_sc.GetForcesInfo(id, ForcesInfo);

  DateToCheck := 0;
  MovedJobLimitDate := 0;
  if CheckMovedJob then
  begin
    DateTmp := 0;
//      if AutoSchedCfg.m_PrevOrNextLinkedJobIsTheTgtDateWhenScheduled and p_sc.GetFldValue(Id, CSC_NxtLowestDate, DateTmp, dataType) then
      // We use CSC_NxtHighiestEndDate as a temporary limit till we know the real overlap date
    if (AutoSchedCfg.m_MoveObjsAllowed > 0) then
    begin
      if AutoSchedCfg.m_PrevOrNextLinkedJobIsTheTgtDateWhenScheduled and p_sc.GetFldValue(Id, CSC_NxtHighiestEndDate, DateTmp, dataType) then
        MovedJobLimitDate := DateTmp;
    end;
    if DateTmp = 0 then
    begin
      if AutoSchedCfg.m_MoveObjsAllowed = 2 then
        MovedJobLimitDate := AddDaysToDate(HighEndDate , AfterHighTolerance(AutoSchedCfg));
      if AutoSchedCfg.m_MoveObjsAllowed = 1 then
        MovedJobLimitDate := HighEndDate;
      if (AutoSchedCfg.m_MoveObjsAllowed = 0) or (AutoSchedCfg.m_MoveObjsAllowed = 3) then
      begin
        case AutoSchedCfg.m_AfterHighLimit of
          1: MovedJobLimitDate := AddDaysToDate(HighEndDate , AfterHighTolerance(AutoSchedCfg));
          2: MovedJobLimitDate := HighEndDate;
        end;
      end;
    end;
  end
  else
  begin
    if (AutoSchedCfg.m_AfterHighLimit = 1) or (AutoSchedCfg.m_AfterHighLimit = 2) then
    begin
      DateTmp := 0;
//      if AutoSchedCfg.m_PrevOrNextLinkedJobIsTheTgtDateWhenScheduled and p_sc.GetFldValue(Id, CSC_NxtLowestDate, DateTmp, dataType) then
      // We use CSC_NxtHighiestEndDate as a temporary limit till we know the real overlap date
      if AutoSchedCfg.m_PrevOrNextLinkedJobIsTheTgtDateWhenScheduled and p_sc.GetFldValue(Id, CSC_NxtHighiestEndDate, DateTmp, dataType) then
        DateToCheck := DateTmp;
      if DateTmp = 0 then
      begin
        case AutoSchedCfg.m_AfterHighLimit of
          1: DateToCheck := AddDaysToDate(HighEndDate , AfterHighTolerance(AutoSchedCfg));
          2: DateToCheck := HighEndDate;
        end;
      end;
    end;
  end;
  if (ForcesInfo.FrcHighestDate = CSF_Yes) and (p_sc.GetHighEnd(id) > DateToCheck) then
    DateToCheck := p_sc.GetHighEnd(id);

  LowestHighDate := DateToCheck;
  if (LowestHighDate = 0) or ((LimitEndDate > 0) and (LowestHighDate > LimitEndDate)) then LowestHighDate := LimitEndDate;

  TempDateTime := PrevEndDate;
  if LimitStartDate > TempDateTime then TempDateTime := LimitStartDate;

  // There can not be a limit on the allowed before when target date is right green line - so, it is not checked

  ReferenceLowDateAllowed := 0;
  if (AutoSchedCfg.m_PrefTgtDate <> 2) and (AutoSchedCfg.m_BeforeLowLimit <> 0) then  // not today and not allowed
  begin
    DateTmp := 0;

    if AutoSchedCfg.m_PrevOrNextLinkedJobIsTheTgtDateWhenScheduled and (p_sc.GetPrvHighestDate(Id) > 0) then
       ReferenceLowDateAllowed := DateTmp;
    if DateTmp = 0 then
    begin
{    Eran and Avi 28/09/2017 decided to change the meaning of allowed before target date
     From now when not allowed it means, it takes the approval date if exists and if not
     take the lowest date.
     We did it to allow to select not to be too early but to allow to prefer the right green line.
      if AutoSchedCfg.m_PrefTgtDate = 0 then
        ReferenceLowDateAllowed := p_sc.GetLowStart(id)
      else
        if AutoSchedCfg.m_PrefTgtDate = 3 then
          ReferenceLowDateAllowed := p_sc.GetApprovalDate(id)
        else
        begin
          ReferenceLowDateAllowed := p_sc.GetApprovalDate(id);
        if ReferenceLowDateAllowed = 0 then
           ReferenceLowDateAllowed := p_sc.GetLowStart(id);
        end;  }
      ReferenceLowDateAllowed := p_sc.GetApprovalDate(id);
      if (ReferenceLowDateAllowed = 0) then
        ReferenceLowDateAllowed := p_sc.GetLowStart(id);
      if AutoSchedCfg.m_BeforeLowLimit = 1 then
        ReferenceLowDateAllowed := AddDaysToDate(ReferenceLowDateAllowed, -BeforeLowTolerance(AutoSchedCfg));
    end;
  end;
  if (ForcesInfo.FrcLowestDate = CSF_Yes) and (p_sc.GetLowStart(id) > ReferenceLowDateAllowed) then
    ReferenceLowDateAllowed := p_sc.GetLowStart(id);


//  if (ReferenceLowDateAllowed > 0) and AutoSchedCfg.m_PrevOrNextLinkedJobIsTheTgtDateWhenScheduled
//  and CheckIfLinkedJobIsScheduled(Id, true) then  //true=Backword
//    ReferenceLowDateAllowed := 0;

{  SavedStartingDate := p_sc.GetSavedStartingDate_AUTOSEQ(Id);
  if (SavedStartingDate > 0) and (ReferenceLowDateAllowed < SavedStartingDate) then
    ReferenceLowDateAllowed := SavedStartingDate;      }

  if TempDateTime < ReferenceLowDateAllowed then TempDateTime := ReferenceLowDateAllowed;

  ScoreRecord.StartDateTime := AutoSchedCfg.m_NowDateTime;

  if (TempDateTime > ScoreRecord.StartDateTime) then ScoreRecord.StartDateTime := TempDateTime;
  if  AutoSchedCfg.m_OverridingParams_Activated
  and AutoSchedCfg.m_OverridingParams_ScheduleJobsWithinTheFram
  and (ScoreRecord.StartDateTime < AutoSchedCfg.m_OverridingParams_WcDateTimeFrom) then
    ScoreRecord.StartDateTime := AutoSchedCfg.m_OverridingParams_WcDateTimeFrom;

  if  AutoSchedCfg.m_OverridingParams_Activated
  and AutoSchedCfg.m_OverridingParams_ScheduleJobsWithinTheFram
  and (ScoreRecord.StartDateTime > AutoSchedCfg.m_OverridingParams_WcDateTimeTo) then
    exit;

  if (MaxStartDate > 0) and (ScoreRecord.StartDateTime > MaxStartDate) then exit;
  PreviousEndDateTime := ScoreRecord.StartDateTime;

//  p_sc.GetFldValue(id, CSC_QtyToSched, QtyVal, dataType);
//  p_sc.GetFldValue(id, CSC_StepType, StepType, dataType);
  QtyVal := p_sc.GetJobQty(id);
  StepType := p_sc.GetJobType(id);

  ScoreRecord.supMinBase := SupMinBase;
  if (StepType = CST_Continuous) and (QtyVal <> DurationQuantityBase) then
    ScoreRecord.DurationOrg := DurationOrg *  QtyVal / DurationQuantityBase
  else
    ScoreRecord.DurationOrg := DurationOrg;

  ScoreRecord.EndDateTime := m_Cal.AddDaysToDateNoCalendar(ScoreRecord.StartDateTime, (ScoreRecord.DurationOrg/60/24));
  if (LowestHighDate > 0) and (ScoreRecord.EndDateTime > LowestHighDate) then
    exit;
  if  (MovedJobLimitDate > 0) and (ScoreRecord.EndDateTime > MovedJobLimitDate)
  and (ScoreRecord.StartDateTime > MovedJobStartDate) then
    exit;

  Self.m_ResourcesManager.CheckSetupCompactParam(Id,PrevId,Self.m_ResCode,m_ActArea,ScoreRecord.CompValJobToJob, ScoreRecord.supMinBase,
                                   ScoreRecord.setup, ScoreRecord.SetupNoMaterial, ScoreRecord.GenericPlanWc,
                                  ScoreRecord.GenericPlanDuration, ScoreRecord.GenericPlanleadTime, RecalcDur);

  if ScoreRecord.CompValJobToJob > AutoSchedCfg.m_MaxJobJobComp then exit;
  if ScoreRecord.CompValJobToJob < AutoSchedCfg.m_MinJobJobComp then exit;

  if (StepType = CST_Continuous) and (QtyVal <> DurationQuantityBase) then
    RecalcDur := true;

  CurveTotalBefore := getCurveTotalsBeforeDate(Id, m_CurveByFamilyInfo, PrevEndDate);

  if RecalcDur or (CurveTotalBefore > 0) then
    ScoreRecord.Duration := ScoreRecord.DurationOrg + GetCurveTime(m_ActArea, DummyDateTime, Id, ScoreRecord.DurationOrg, false, CurveTotalBefore)
  else
    ScoreRecord.Duration := Duration;

  ScoreRecord.EndDateTime := m_Cal.AddDaysToDateNoCalendar(ScoreRecord.StartDateTime, ((ScoreRecord.setup+ScoreRecord.Duration)/60/24));
  if (LowestHighDate > 0) and (ScoreRecord.EndDateTime > LowestHighDate)
    then exit;
  if  (MovedJobLimitDate > 0) and (ScoreRecord.EndDateTime > MovedJobLimitDate)
  and (ScoreRecord.StartDateTime > MovedJobStartDate)
    then exit;

  if not IgnoreGenericPlan then
  begin
    // generic plan
    p_sc.GetJobInfo(id, GenericPlanplanInfo);
    if (prevId <> CSchedIdNull) and (GenericPlanplanInfo.GenericPlan) and (Trim(ScoreRecord.GenericPlanWc) <> '') then
    begin
      GenericPlanSavedAlready := false;
      if assigned(GenericPlanDates) then
      begin
        for I := 0 to GenericPlanDates.Count - 1 do
        begin
          if (PTGenericPlan(GenericPlanDates[I]).WorkCenterCode) = Trim(ScoreRecord.GenericPlanWc) then
          begin
            GenericPlanPositionFound := PTGenericPlan(GenericPlanDates[I]).PositionFound;
            OutEndDate := PTGenericPlan(GenericPlanDates[I]).MinimumStartDateTime;
            GenericPlanSavedAlready := true;
            break;
          end;
        end;
      end;

      if not GenericPlanSavedAlready then
      begin
        if FindBestPositionGenericPlan(id, 0, trim(ScoreRecord.GenericPlanWc), ScoreRecord.GenericPlanDuration, 0,
                                       OutStartDate, OutEndDate, OutMachineNumber, TempIndex) then
          GenericPlanPositionFound := true
        else
        begin
          GenericPlanPositionFound := false;
          OutEndDate := 0;
        end;
        if Assigned(GenericPlanDates) then
        begin
          new(PGenericPlan);
          PGenericPlan.WorkCenterCode := trim(ScoreRecord.GenericPlanWc);
          PGenericPlan.MinimumStartDateTime := OutEndDate;
          PGenericPlan.PositionFound := GenericPlanPositionFound;
          GenericPlanDates.Add(PGenericPlan);
        end;
      end;

      if not GenericPlanPositionFound then exit;

//      OutEndDate := AddDaysToDate(OutEndDate, (ScoreRecord.GenericPlanleadTime / 60 / 24));
      OutEndDate := m_Cal.AddDaysToDateNoCalendar(OutEndDate, (ScoreRecord.GenericPlanleadTime / 60 / 24));
      if OutEndDate > ScoreRecord.StartDateTime then
      begin
        TempDateTime := CalcNewDateForGenericStart(m_cal,m_actArea,OutEndDate,ScoreRecord.StartDateTime, Id);
        if TempDateTime > ScoreRecord.StartDateTime then
        begin
          ScoreRecord.StartDateTime := TempDateTime;
        end;
      end;
    end;

  end;

  // Overlap
  LowOvlopLimitTmp := 0;
  HighOvlpLimitTmp := 0;

  if (AutoSchedCfg.m_IgnoreRightOverlapping = 0)
  or (AutoSchedCfg.m_IgnoreLeftOverlapping = 0)
  or (AutoSchedCfg.m_PrevOrNextLinkedJobIsTheTgtDateWhenScheduled) then
  begin
    if not FindOverlapsForSetUp(Id, Pos, m_ResCode, ScoreRecord.Setup - ScoreRecord.SetupNoMaterial, LowOvlopLimitTmp, HighOvlpLimitTmp) then
    begin
      p_sc.CalcOvlpLimits(id, m_ResPtr, LowOvlopLimitTmp, HighOvlpLimitTmp, OvlpChk_OptimumLimits, ScoreRecord.Setup - ScoreRecord.SetupNoMaterial, ScoreRecord.Duration);
      if (LowOvlopLimitTmp > 0) and (LowOvlopLimitTmp < 999999) then // add 4 seconds to the low limit
        m_Cal.OfsByWH(4/3600, true, LowOvlopLimitTmp, LowOvlopLimitTmp , m_ActArea.m_CrossDownTmList);
      if (HighOvlpLimitTmp > 0) and (HighOvlpLimitTmp < 999999) then // reduce 4 seconds from the high limit
        m_Cal.OfsByWH(-4/3600, false, HighOvlpLimitTmp, HighOvlpLimitTmp , m_ActArea.m_CrossDownTmList);
      AddOverlapsForSetUp(id, pos, m_ResCode, ScoreRecord.Setup - ScoreRecord.SetupNoMaterial, LowOvlopLimitTmp, HighOvlpLimitTmp);
    end;
    ScoreRecord.LowOverlap := LowOvlopLimitTmp;
    ScoreRecord.HighOverlap := HighOvlpLimitTmp;
    if (HighOvlpLimitTmp > 0) and AutoSchedCfg.m_PrevOrNextLinkedJobIsTheTgtDateWhenScheduled then
    begin
      if CheckMovedJob and ((AutoSchedCfg.m_MoveObjsAllowed = 1) or (AutoSchedCfg.m_MoveObjsAllowed = 2)) then
         MovedJobLimitDate := HighOvlpLimitTmp;
      if  not CheckMovedJob
      and ((AutoSchedCfg.m_AfterHighLimit = 1) or (AutoSchedCfg.m_AfterHighLimit = 2))
      and (LowestHighDate > HighOvlpLimitTmp) then
        LowestHighDate := HighOvlpLimitTmp;
    end;
  end;

  if AutoSchedCfg.m_IgnoreLeftOverlapping = 1 then
     LowOvlopLimit := 0
  else
     LowOvlopLimit := LowOvlopLimitTmp;
  if AutoSchedCfg.m_IgnoreRightOverlapping = 1 then
     HighOvlpLimit := 0
  else
     HighOvlpLimit := HighOvlpLimitTmp;

  if LowOvlopLimit = 999999 then exit;
  if LowOvlopLimit > ScoreRecord.StartDateTime then ScoreRecord.StartDateTime := LowOvlopLimit;
  if (MaxStartDate > 0) and (ScoreRecord.StartDateTime > MaxStartDate) then exit;

//  ScoreRecord.StartDateTime := PushjobAfterDownTime(ScoreRecord.setup, ScoreRecord.duration, ScoreRecord.StartDateTime);
  if (LowestHighDate = 0) or ((HighOvlpLimit > 0) and (LowestHighDate > HighOvlpLimit)) then LowestHighDate := HighOvlpLimit;

//  ScoreRecord.EndDateTime := AddDaysToDate(ScoreRecord.StartDateTime , ((ScoreRecord.setup+ScoreRecord.Duration)/60/24));
  ScoreRecord.EndDateTime := m_Cal.AddDaysToDateNoCalendar(ScoreRecord.StartDateTime , ((ScoreRecord.setup+ScoreRecord.Duration)/60/24));
  if (LowestHighDate > 0) and (ScoreRecord.EndDateTime > LowestHighDate)
    then exit;
  if  (MovedJobLimitDate > 0) and (ScoreRecord.EndDateTime > MovedJobLimitDate)
  and (ScoreRecord.StartDateTime > MovedJobStartDate) then
    exit;

  PreferedStartDate := 0;
  if AutoSchedCfg.m_PushToThePreferedDateMode then
  begin
    if (AutoSchedCfg.m_PrefTgtDate = 0) then
    begin
      if AutoSchedCfg.m_PrevOrNextLinkedJobIsTheTgtDateWhenScheduled and (LowOvlopLimitTmp > 0) then
        PreferedStartDate := LowOvlopLimitTmp
      else
        PreferedStartDate := p_sc.GetLowStart(id);
      if (MaxStartDate > 0) and (PreferedStartDate > MaxStartDate) then PreferedStartDate := MaxStartDate;
      m_Cal.OfsByWH((ScoreRecord.setup + ScoreRecord.Duration)/60, true, PreferedStartDate, TempDateTime , m_ActArea.m_CrossDownTmList);
    end;
    if (AutoSchedCfg.m_PrefTgtDate = 1) then
    begin
      if AutoSchedCfg.m_PrevOrNextLinkedJobIsTheTgtDateWhenScheduled and (HighOvlpLimitTmp > 0) then
        TempDateTime := HighOvlpLimitTmp
      else
        TempDateTime := HighEndDate;
      m_Cal.OfsByWH(-(ScoreRecord.setup + ScoreRecord.Duration)/60, false, TempDateTime, PreferedStartDate , m_ActArea.m_CrossDownTmList);
      if (MaxStartDate > 0) and (PreferedStartDate > MaxStartDate) then
      begin
        PreferedStartDate := MaxStartDate;
        m_Cal.OfsByWH((ScoreRecord.setup + ScoreRecord.Duration)/60, true, PreferedStartDate, TempDateTime , m_ActArea.m_CrossDownTmList);
      end;
    end;
    if (AutoSchedCfg.m_PrefTgtDate = 3) then
    begin
      if AutoSchedCfg.m_PrevOrNextLinkedJobIsTheTgtDateWhenScheduled and (LowOvlopLimitTmp > 0) then
        PreferedStartDate := LowOvlopLimitTmp
      else
        PreferedStartDate := p_sc.GetApprovalDate(id);  // Approval date is when the customer approves the Garment , that is the start of production
      if (MaxStartDate > 0) and (PreferedStartDate > MaxStartDate) then PreferedStartDate := MaxStartDate;
      m_Cal.OfsByWH((ScoreRecord.setup + ScoreRecord.Duration)/60, true, PreferedStartDate, TempDateTime , m_ActArea.m_CrossDownTmList);
    end;
    if (PreferedStartDate > 0) and (LowestHighDate > 0) and (TempDateTime > LowestHighDate) then
      m_Cal.OfsByWH(-(ScoreRecord.setup + ScoreRecord.Duration)/60, false, LowestHighDate, PreferedStartDate , m_ActArea.m_CrossDownTmList);
  end;

  EndOfGantt := (now + 850);

  First := true;
  while true do
  begin
    while True do
    begin
      SaveDateTime := ScoreRecord.StartDateTime;
      ScoreRecord.NextNotPossibleDate := 999999;
      NextNotPossibleDateTemp := 999999;
      if not IgnoreAddRessMat then
      begin
        ScoreRecord.StartDateTime := FindClosestDateForConsumptions(Id, SupMinBase, ScoreRecord.setup, ScoreRecord.SetupNoMaterial, ScoreRecord.Duration, ScoreRecord.StartDateTime, MatAddResList, NextNotPossibleDateTemp);
        ScoreRecord.NextNotPossibleDate := NextNotPossibleDateTemp;
      end;
      if ScoreRecord.StartDateTime > EndOfGantt then break;
      ScoreRecord.StartDateTime := CheckDateOnOneBatchMachineByGroupCode(ScoreRecord, NextNotPossibleDateTemp); // gaetano - recheck the StartDateTime and sign new date.
      if NextNotPossibleDateTemp < ScoreRecord.NextNotPossibleDate then
        ScoreRecord.NextNotPossibleDate := NextNotPossibleDateTemp;
      if ScoreRecord.StartDateTime > EndOfGantt then break;
      ScoreRecord.StartDateTime := CheckDateOnSubResources(ScoreRecord, NextNotPossibleDateTemp);
      if NextNotPossibleDateTemp < ScoreRecord.NextNotPossibleDate then
        ScoreRecord.NextNotPossibleDate := NextNotPossibleDateTemp;
      if ScoreRecord.StartDateTime > EndOfGantt then break;
      ScoreRecord.StartDateTime := PushjobAfterDownTime(ScoreRecord.setup, ScoreRecord.duration, ScoreRecord.StartDateTime, Id, NextNotPossibleDateTemp);
      if NextNotPossibleDateTemp < ScoreRecord.NextNotPossibleDate then
        ScoreRecord.NextNotPossibleDate := NextNotPossibleDateTemp;
      if ScoreRecord.StartDateTime > EndOfGantt then break;
      ScoreRecord.StartDateTime := PushjobAfterWarpInCaseNotCompatible(ScoreRecord.setup, ScoreRecord.duration, ScoreRecord.StartDateTime, Id, NextNotPossibleDateTemp);
      if NextNotPossibleDateTemp < ScoreRecord.NextNotPossibleDate then
        ScoreRecord.NextNotPossibleDate := NextNotPossibleDateTemp;
      if ScoreRecord.StartDateTime > EndOfGantt then break;
      if SaveDateTime = ScoreRecord.StartDateTime then break;
    end;
    if PreferedStartDate = 0 then break;
    if ScoreRecord.StartDateTime = PreferedStartDate then break;
    if ScoreRecord.StartDateTime > PreferedStartDate then
    begin
      if First then break;
      ScoreRecord.StartDateTime := TempDateTime;
      PreferedStartDate := ScoreRecord.StartDateTime + ((SecondsDifference / 60 / 60 / 24));
    end;
    TempDateTime := ScoreRecord.StartDateTime;
    SecondsDifference := Trunc((PreferedStartDate - ScoreRecord.StartDateTime) * 24 * 60 * 60);
    if First then
      ScoreRecord.StartDateTime := PreferedStartDate
    else
    begin
      if SecondsDifference < 2 then break;
      SecondsDifference := Trunc(SecondsDifference / 2);
//      ScoreRecord.StartDateTime := AddDaysToDate(ScoreRecord.StartDateTime , ((SecondsDifference / 60 / 60 / 24)));
      ScoreRecord.StartDateTime := m_Cal.AddDaysToDateNoCalendar(ScoreRecord.StartDateTime , ((SecondsDifference / 60 / 60 / 24)));
    end;
    First := false;
  end;

  if (MaxStartDate > 0) and (ScoreRecord.StartDateTime > MaxStartDate) then exit;

  if ScoreRecord.StartDateTime > EndOfGantt then exit;
  m_Cal.OfsByWH((ScoreRecord.setup + ScoreRecord.Duration)/60, true, ScoreRecord.StartDateTime, ScoreRecord.EndDateTime , m_ActArea.m_CrossDownTmList);
  if (LowestHighDate > 0) and (ScoreRecord.EndDateTime > LowestHighDate)
    then exit;
  if (LowestHighDate > 0) and (ScoreRecord.NextNotPossibleDate > LowestHighDate) then
    ScoreRecord.NextNotPossibleDate := LowestHighDate;
  if  (MovedJobLimitDate > 0) and (ScoreRecord.EndDateTime > MovedJobLimitDate)
  and (ScoreRecord.StartDateTime > MovedJobStartDate)
    then exit;
  if ScoreRecord.EndDateTime > EndOfGantt then exit;

  if  AutoSchedCfg.m_OverridingParams_Activated
  and AutoSchedCfg.m_OverridingParams_ScheduleJobsWithinTheFram
  and (ScoreRecord.StartDateTime > AutoSchedCfg.m_OverridingParams_WcDateTimeTo) then
    exit;

  if  AutoSchedCfg.m_OverridingParams_Activated
  and AutoSchedCfg.m_OverridingParams_ScheduleJobsWithinTheFram
  and (ScoreRecord.EndDateTime > AutoSchedCfg.m_OverridingParams_WcDateTimeTo) then
  begin
    TempDateTime := AutoSchedCfg.m_OverridingParams_WcDateTimeFrom;
    m_Cal.OfsByWH((ScoreRecord.setup + ScoreRecord.Duration)/60, true, TempDateTime, TempDateTime , m_ActArea.m_CrossDownTmList);
    if (TempDateTime <= AutoSchedCfg.m_OverridingParams_WcDateTimeTo)
    and not AutoSchedCfg.m_OverridingParams_ShorterJobsCanEndAfterFramEnd then
      exit;
    if (TempDateTime > AutoSchedCfg.m_OverridingParams_WcDateTimeTo)
    and (ScoreRecord.StartDateTime > AutoSchedCfg.m_OverridingParams_WcDateTimeFrom)
    and not AutoSchedCfg.m_OverridingParams_LargerJobsCanStartAfterTheFrameBegins then
    begin
      TempDateTime := AutoSchedCfg.m_OverridingParams_WcDateTimeFrom;
      m_Cal.OfsByWH(1/24/60/60 , true, TempDateTime, TempDateTime , m_ActArea.m_CrossDownTmList);
      TempDateTime := PushjobAfterDownTime(ScoreRecord.setup, ScoreRecord.duration, TempDateTime, Id, NextNotPossibleDateTemp); // NextNotPossibleDateTemp does not have an influence
      if (ScoreRecord.StartDateTime > TempDateTime) then
        exit;
    end;
  end;

  ScoreRecord.Gap := trunc(m_Cal.DiffWH(PreviousEndDateTime, ScoreRecord.StartDateTime , m_ActArea.m_CrossDownTmList)*60);

  Result := true;
end;

//----------------------------------------------------------------------------//
function TResourcesStruct.KeepTheSplitChgQtyIfNot(OrigId, NewId : TSchedId; OrigQty, NewIdQty : double; var ScoreRecord : TScoreRecord) : boolean;
var
  SecondsNeeded, SecondsGap : integer;
  NewQuantity : currency;
  DecMult : integer;
begin
  DecMult := Round(IntPower(10, p_sc.GetJobNumOfDecimals(OrigId)));

  Result := false;

  // If the next not possible date is 999999, it means no limit, so, we do not need to split the job, we can schedeule its total quantity
  if (ScoreRecord.NextNotPossibleDate = 999999) then exit;

  // If the next not possible date is before the job ending date, there is a bug and in that case, we do not split
  if (ScoreRecord.NextNotPossibleDate < ScoreRecord.EndDateTime) then exit;

  // If the next not possible date equals the job ending date, it is a bug but we keep the origial split
  if (ScoreRecord.NextNotPossibleDate = ScoreRecord.EndDateTime) then
  begin
    Result := true;
    exit;
  end;

  SecondsNeeded := trunc((ScoreRecord.MainIdDuration*60) / ScoreRecord.MainIdQuantity * OrigQty);
  SecondsGap := trunc(m_Cal.DiffWH(ScoreRecord.StartDateTime, ScoreRecord.NextNotPossibleDate , m_ActArea.m_CrossDownTmList)*60*60);
  SecondsGap := trunc(SecondsGap - (ScoreRecord.Setup * 60));

  if SecondsGap >= SecondsNeeded then exit;

  Result := true;

  NewQuantity := trunc(ScoreRecord.MainIdQuantity / (ScoreRecord.MainIdDuration * 60) * SecondsGap * DecMult) / DecMult;
  if (OrigQty - NewQuantity) < NewIdQty then
    NewQuantity := OrigQty - NewIdQty;

  if NewQuantity <= NewIdQty then exit;

   p_sc.AddQtyToJob(OrigId, -(NewQuantity - NewIdQty));
   p_sc.AddQtyToJob(NewId, (NewQuantity - NewIdQty));

   ScoreRecord.Duration := ScoreRecord.MainIdDuration / ScoreRecord.MainIdQuantity *  NewQuantity;
   m_Cal.OfsByWH((ScoreRecord.setup + ScoreRecord.Duration)/60, true, ScoreRecord.StartDateTime, ScoreRecord.EndDateTime , m_ActArea.m_CrossDownTmList);

end;

//----------------------------------------------------------------------------//

function TResourcesStruct.CheckDateOnOneBatchMachineByGroupCode(ScoreRecord : TScoreRecord; out NextNotPossibleDate : TDateTime) : TDateTime;
var
  BatchMachineByGroupCode : TMqmRes;
  ResourcesStructBatchMachine : TResourcesStruct;
  IsQtyHigherOnSingleRes : boolean;
  I, StartIdx : Integer;
  PJobToSched : PTJobToSched;
  EndTm : TDateTime;
  Res : TMqmRes;
  QtyType : boolean;
begin
  Result := ScoreRecord.StartDateTime;
  NextNotPossibleDate := 999999;
  if not TMqmRes(TMQMVisibleRes(m_ResPtr).p_Father).p_ONE_BATCH_MACHINE_By_GROUP_CODE then exit;
  BatchMachineByGroupCode := TMqmRes(TMQMVisibleRes(m_ResPtr).p_Father).P_rscOfBatchMachinSameGrpCode;
  if not Assigned(BatchMachineByGroupCode) then exit;

  ResourcesStructBatchMachine := FindResourceByCode(BatchMachineByGroupCode.p_ResCode, m_ResourcesManager.m_AllResList);

  if ResourcesStructBatchMachine = nil then exit;
  if (ResourcesStructBatchMachine.m_SchedList.count = 0) then exit;

  if (Res.p_GROUP_TYPE_FOR_ONE_BATCH_MACHINE = Qty_typ) and (BatchMachineByGroupCode.p_GROUP_TYPE_FOR_ONE_BATCH_MACHINE = Qty_typ) then
    QtyType := true
  else
  begin
    QtyType := false;
    if (Res.p_GROUP_TYPE_FOR_ONE_BATCH_MACHINE <> process_typ) or (BatchMachineByGroupCode.p_GROUP_TYPE_FOR_ONE_BATCH_MACHINE <> process_typ) then
      exit;
  end;

  Res := TMqmRes(TMQMVisibleRes(m_ResPtr).p_Father);

  if QtyType then
  begin
    m_Cal.OfsByWH((ScoreRecord.setup + ScoreRecord.Duration)/60, true, Result, Endtm, m_ActArea.m_CrossDownTmList);
    IsQtyHigherOnSingleRes := Res.CheckMaxQtyOnBatchMachinSameGrpCode(ScoreRecord.Id);
    for i := 0 to ResourcesStructBatchMachine.m_SchedList.Count - 1 do
    begin
      PJobToSched := PTJobToSched(ResourcesStructBatchMachine.m_SchedList[I]);
      if PJobToSched.StartSched > Endtm then break;
      if (PJobToSched.EndSched > Result) and (PJobToSched.StartSched < EndTm) then
      begin
        if IsQtyHigherOnSingleRes then
        begin
          Result := PJobToSched.EndSched;
          m_Cal.OfsByWH((ScoreRecord.setup + ScoreRecord.Duration)/60, true, Result, Endtm, m_ActArea.m_CrossDownTmList);
        end
        else
        begin
          if BatchMachineByGroupCode.CheckMaxQtyOnBatchMachinSameGrpCode(PJobToSched.Id) then
          begin
            Result := PJobToSched.EndSched;
            m_Cal.OfsByWH((ScoreRecord.setup + ScoreRecord.Duration)/60, true, Result, Endtm, m_ActArea.m_CrossDownTmList);
          end;
        end;
      end;
    end
  end
  else
  begin
    m_ActArea := TMqmActArea(m_ResPtr.p_ActArea[0]);
    if not m_ActArea.p_CheckIfSchedObjsIsAssigned then exit;

    m_Cal.OfsByWH((ScoreRecord.setup + ScoreRecord.Duration)/60, true, Result, Endtm, m_ActArea.m_CrossDownTmList);
    for i := 0 to ResourcesStructBatchMachine.m_SchedList.Count - 1 do
    begin
      PJobToSched := PTJobToSched(ResourcesStructBatchMachine.m_SchedList[I]);
      if PJobToSched.StartSched > Endtm then break;
      if (PJobToSched.EndSched > Result) and (PJobToSched.StartSched < EndTm) then
      begin
        if not Res.CheckUsedAllMachinePartsProcessOnBatchMachinSameGrpCode(ScoreRecord.id , PTJobToSched(ResourcesStructBatchMachine.m_SchedList[I]).Id) then break;
        Result := PJobToSched.EndSched;
        m_Cal.OfsByWH((ScoreRecord.setup + ScoreRecord.Duration)/60, true, Result, Endtm, m_ActArea.m_CrossDownTmList);
      end;
    end;
  end;

  if (AutoSchedCfg.m_SplitSchedByBatchSize <> LongestDurationPossible) then exit;

  // No sense that machines with quantity limit (Batch machines) will need to split in this way
  if QtyType then exit;

  StartIdx := I + 1;
  for i := StartIdx to ResourcesStructBatchMachine.m_SchedList.Count - 1 do
  begin
    PJobToSched := PTJobToSched(ResourcesStructBatchMachine.m_SchedList[I]);
    if Res.CheckUsedAllMachinePartsProcessOnBatchMachinSameGrpCode(ScoreRecord.id , PTJobToSched(ResourcesStructBatchMachine.m_SchedList[I]).Id) then
    begin
      NextNotPossibleDate := PJobToSched.StartSched;
      break;
    end;
   end;

end;

//----------------------------------------------------------------------------//

function TResourcesStruct.CheckDateOnSubResources(ScoreRecord : TScoreRecord; out NextNotPossibleDate : TDateTime) : TDateTime;

type
TSubResources = record
   FromIndex  : integer;
   ResourcesStruct : TResourcesStruct;
end;
PTSubResources = ^TSubResources;

var
  ResCode : string;
  ResourcesStruct : TResourcesStruct;
  Visres : TMQMVisibleRes;
  I, J, DateToCheckIdx : Integer;
  PJobToSched : PTJobToSched;
  EndTm, DateToCheck, LowestDateFound : TDateTime;
  ComponentsAllowed, NeededComponents, TotalComponents, CurrentComponents, FromIndex : integer;
  SubResourcesList : TList;
  DatesToCheck : TStringList;
  PSubResources : PTSubResources;
  CheckLeftSide, CheckRightSide, AllPositionsAreOk, AllPositionsAreOkFound : boolean;

begin
  Result := ScoreRecord.StartDateTime;
  NextNotPossibleDate := 999999;

  if TMqmRes(m_actArea.p_res).p_isMultiRes then
  begin
    ResCode := TMqmRes(m_actArea.p_res).p_ResCode;
    ComponentsAllowed := TMqmRes(m_actArea.p_res).p_ResComp;
    if p_sc.GetRscComponentFromJobOrStep(ScoreRecord.Id) > 0 then
      NeededComponents := p_sc.GetRscComponentFromJobOrStep(ScoreRecord.id)
    else
      NeededComponents := TMQMVisibleRes(m_ResPtr).p_ResComp;

    if NeededComponents > ComponentsAllowed then
      exit;

    SubResourcesList := Tlist.Create;
    for I := 0 to TMqmRes(m_actArea.p_res).p_VisResCount - 1 do
    begin
      VisRes := TMqmRes(m_actArea.p_res).p_VisRes[I];
      new(PSubResources);
      ResourcesStruct := FindResourceByCode((ResCode  + IntToStr(TMQMVisibleRes(Visres).p_SubCode)) , m_ResourcesManager.m_AllResList);
      if ResourcesStruct = self then continue;
      PSubResources.FromIndex := 0;
      PSubResources.ResourcesStruct := ResourcesStruct;
      SubResourcesList.Add(PSubResources);
    end;

    DatesToCheck := TStringList.Create;

    while true do
    begin

      if AllPositionsAreOkFound then
        Endtm := EncodeDate(2100, 01, 01)  // Check if there is any position till the ends of time that is not possible
      else
        m_Cal.OfsByWH((ScoreRecord.setup + ScoreRecord.Duration)/60, true, Result, Endtm, m_ActArea.m_CrossDownTmList);

      DatesToCheck.Clear;
      DatesToCheck.Add(DateTimeToStr(Result));
      LowestDateFound := 999999;

      for I := 0 to SubResourcesList.Count - 1 do
      begin
        PSubResources := PTSubResources(SubResourcesList[I]);
        FromIndex := PSubResources.FromIndex;
        ResourcesStruct := PSubResources.ResourcesStruct;
        for J := FromIndex to ResourcesStruct.m_SchedList.Count - 1 do
        begin
          PJobToSched := PTJobToSched(ResourcesStruct.m_SchedList[J]);
          if PJobToSched.StartSched >= Endtm then break;
          if PJobToSched.EndSched <= Result then
          begin
            PSubResources.FromIndex := (J + 1);
            continue;
          end;
          if (PJobToSched.StartSched > Result) then
            DatesToCheck.Add(DateTimeToStr(PJobToSched.StartSched));
          if (PJobToSched.EndSched < Endtm) then
            DatesToCheck.Add(DateTimeToStr(PJobToSched.EndSched));
          if (PJobToSched.StartSched > Result) and (LowestDateFound > PJobToSched.StartSched) then
            LowestDateFound := PJobToSched.StartSched;
          if LowestDateFound > PJobToSched.EndSched then
            LowestDateFound := PJobToSched.EndSched;
        end;
      end;
      DatesToCheck.Add(DateTimeToStr(Endtm));

      DateToCheckIdx := 0;
      CheckLeftSide := false;
      CheckRightSide := true;
      AllPositionsAreOk := true;

      while True do
      begin

        DateToCheck := StrToDateTime(DatesToCheck.Strings[DateToCheckIdx]);
        TotalComponents := 0;

        for I := 0 to SubResourcesList.Count - 1 do
        begin
          PSubResources := PTSubResources(SubResourcesList[I]);
          FromIndex := PSubResources.FromIndex;
          ResourcesStruct := PSubResources.ResourcesStruct;
          for J := FromIndex to ResourcesStruct.m_SchedList.Count - 1 do
          begin
            PJobToSched := PTJobToSched(ResourcesStruct.m_SchedList[J]);
            if ((PJobToSched.StartSched < DateToCheck) and (PJobToSched.EndSched > DateToCheck))
            or (CheckLeftSide and (PJobToSched.EndSched = DateToCheck))
            or (not CheckLeftSide and CheckRightSide and (PJobToSched.StartSched = DateToCheck)) then
            begin
              if PJobToSched.FromGantt then
                CurrentComponents := p_sc.GetJobComponents(PJobToSched.Id, true)
              else
              begin
                if p_sc.GetRscComponentFromJobOrStep(PJobToSched.Id) > 0 then
                  CurrentComponents := p_sc.GetRscComponentFromJobOrStep(PJobToSched.id)
                else
                  CurrentComponents := TMQMVisibleRes(ResourcesStruct.m_ResPtr).p_ResComp;
              end;
              TotalComponents := TotalComponents + CurrentComponents;
              break;
            end;
            if PJobToSched.StartSched >= Endtm then
              break;
          end;
        end;

        if (TotalComponents + NeededComponents) > ComponentsAllowed then
        begin
          AllPositionsAreOk := false;
          break;
        end;

        if CheckLeftSide then
          CheckLeftSide := false
        else
          CheckRightSide := false;

        if not CheckLeftSide and not CheckRightSide then
        begin
          if DateToCheckIdx = (DatesToCheck.count - 1) then
           break;
          inc(DateToCheckIdx);
          CheckLeftSide := true;
          if DateToCheckIdx < (DatesToCheck.count - 1) then
            CheckRightSide := true;
        end;

      end;

      if AllPositionsAreOk then
      begin
        if (AutoSchedCfg.m_SplitSchedByBatchSize <> LongestDurationPossible) then break;
        if AllPositionsAreOkFound then break;   // If on the previoud cycle all was ok, and now, also till end of time all is ok, there is no bad position
        AllPositionsAreOkFound := true;
      end
      else
      begin
        if AllPositionsAreOkFound then // If on the previoud cycle all was ok and now not, we take the first bad position found
        begin
          NextNotPossibleDate := DateToCheck;
          break;
        end;
        Result := LowestDateFound;
      end;

    end;

    for I := 0 to SubResourcesList.Count - 1 do
      dispose(PTSubResources(SubResourcesList[I]));
    SubResourcesList.Free;
    DatesToCheck.Free;

  end;
end;

//----------------------------------------------------------------------------//

function TResourcesStruct.FindClosestDateForSingleConsType(Id : TSchedId; setup, overlap, Dur : double; StartDateTime : TDateTime; var Index : Integer ; FromPos, NumberOfEntries : Integer; ConsList : Tlist ; AddResStart, AddResEnd : ArResTime; HoursToKeepAddRes : integer; var NextNotPossibleDate : TDateTime) : TDateTime;
var
  NewStartSetupDateTime, NewStartExeDateTime, NewEndDate : TDateTime;
  StartDateToCheck, EndDateToCheck : TDateTime;
  TimeBackToStart : Double;
  Multiplier : integer;
  ConsType : String;
begin
  Result := StartDateTime;
  EndDateToCheck := 0;
  NextNotPossibleDate := 9999999;

  if AddResStart = Ar_NoMatSetup then
  begin
    case AddResEnd of
      Ar_NoMatSetup : ConsType := 'STR_TO_STARTSETUP';
      Ar_MatSetup   : ConsType := 'STR_TO_STARTEXE';
      Ar_Exec       : ConsType := 'STR_TO_END';
    end;
  end;
  if AddResStart = Ar_MatSetup then
  begin
    case AddResEnd of
      Ar_MatSetup   : ConsType := 'STARTSETUP_TO_STARTEXE';
      Ar_Exec       : ConsType := 'STARTSETUP_TO_END';
    end;
  end;
  if (AddResStart = Ar_Exec) or (AddResStart = Ar_Day) then
    ConsType := 'STARTEXE_TO_END';

  if (ConsType = 'STR_TO_STARTSETUP') and (Overlap <= 0) then exit;
  if (ConsType = 'STR_TO_STARTEXE') and (setup <= 0) then exit;
  if (ConsType = 'STARTSETUP_TO_STARTEXE') and ((setup - Overlap) <= 0) then exit;

  while True do
  begin
    if Index > NumberOfEntries - 1 then break;

    if PTRecNoMatDate(ConsList[Index + FromPos]).m_end > (now + (360 * 3)) then
    begin
      Result := 999999;
      break;
    end;

    NewStartSetupDateTime := Result;
    if Overlap > 0 then
      m_Cal.OfsByWH((Overlap)/60, true, Result, NewStartSetupDateTime , m_ActArea.m_CrossDownTmList);
    NewStartExeDateTime := NewStartSetupDateTime;
    if (setup - Overlap) > 0 then
      m_Cal.OfsByWH((setup - Overlap)/60, true, NewStartSetupDateTime, NewStartExeDateTime , m_ActArea.m_CrossDownTmList);
    NewEndDate := NewStartExeDateTime;
    if Dur > 0 then
      m_Cal.OfsByWH((dur)/60, true, NewStartExeDateTime, NewEndDate , m_ActArea.m_CrossDownTmList);

    StartDateToCheck := Result;
    TimeBackToStart := 0;
    if ConsType = 'STR_TO_STARTSETUP' then EndDateToCheck := NewStartSetupDateTime;
    if ConsType = 'STR_TO_STARTEXE' then  EndDateToCheck := NewStartExeDateTime;
    if ConsType = 'STR_TO_END' then EndDateToCheck := NewEndDate;
    if ConsType = 'STARTSETUP_TO_STARTEXE' then
    begin
      StartDateToCheck := NewStartSetupDateTime;
      EndDateToCheck := NewStartExeDateTime;
      TimeBackToStart := Overlap;
    end;
    if ConsType = 'STARTSETUP_TO_END' then
    begin
      StartDateToCheck := NewStartSetupDateTime;
      EndDateToCheck := NewEndDate;
      TimeBackToStart := Overlap;
    end;
    if ConsType = 'STARTEXE_TO_END' then
    begin
      StartDateToCheck := NewStartExeDateTime;
      EndDateToCheck := NewEndDate;
      TimeBackToStart := Setup;
    end;

    EndDateToCheck := EndDateToCheck + HoursToKeepAddRes / 24;

    if StartDateToCheck >= PTRecNoMatDate(ConsList[Index + FromPos]).m_end then
    // This can happen only the first cycle of the loop
    begin
      if StartDateToCheck >= PTRecNoMatDate(ConsList[NumberOfEntries - 1 + FromPos]).m_end then
      begin
        Index := NumberOfEntries;
        break;
      end;

      if NumberOfEntries > 32 then // Save some performance not always to start from 1
        Multiplier := 64
      else
        Multiplier := 1;

      while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
      Index := Multiplier - 1;
      while (Multiplier > 0) do
      begin
        if  (Index < NumberOfEntries)
        and (StartDateToCheck < PTRecNoMatDate(ConsList[Index + FromPos]).m_end)
        and (StartDateToCheck >= PTRecNoMatDate(ConsList[Index - 1 + FromPos]).m_end) then break;
        Multiplier := trunc(Multiplier / 2);
        if (Index < NumberOfEntries) and (StartDateToCheck >= PTRecNoMatDate(ConsList[Index + FromPos]).m_end) then
          Index := Index + Multiplier
        else
          Index := Index - Multiplier;
      end;

      if Multiplier = 0 then
      begin
        Index := NumberOfEntries;
        break;
      end;

    end;

    if (AddResStart = Ar_Day) then
    begin
      if StartDateToCheck <= PTRecNoMatDate(ConsList[Index + FromPos]).m_start then break;
    end
    else
    begin
      if EndDateToCheck <= PTRecNoMatDate(ConsList[Index + FromPos]).m_start then
      begin
       if (ConsType = 'STR_TO_END') or (ConsType = 'STARTSETUP_TO_END') or (ConsType = 'STARTEXE_TO_END') then
       begin
         if NextNotPossibleDate > PTRecNoMatDate(ConsList[Index]).m_start then
           NextNotPossibleDate := PTRecNoMatDate(ConsList[Index]).m_start;
       end;
        break;
      end;
    end;

    Result := PTRecNoMatDate(ConsList[Index + FromPos]).m_end;
    if TimeBackToStart > 0 then
      m_Cal.OfsByWH((-TimeBackToStart)/60, false, Result, Result , m_ActArea.m_CrossDownTmList);
    Index := Index + 1;

  end;
end;


//----------------------------------------------------------------------------//

function TResourcesStruct.FindClosestDateForConsumptions(Id : TSchedId; SupMinBase, setup, overlap, Dur : double; StartDateTime : TDateTime; var MatAddResList : Tlist; var NextNotPossibleDatePrm : TDateTime) : TDateTime;
type
  TConsumptions = record
     WorkCenter  : String;
     CalendarCode : String;
     ResCode : String;
     SupMinBase : double;
     SetupNeedMat : double;
     Duration : double;
     MatList : Tlist;
     AddResList, AddResPointerList : Tlist;
     ManPowerList, ManPowerPointerList : Tlist;
  end;
  PTConsumptions = ^TConsumptions;
type
  TNotAvailType = record
    ToPos : integer;
    Nature : ArProdNature;
    AddResStart : ArResTime;
    AddResEnd : ArResTime;
    HoursToDownFromMachine : integer;
    Index : integer;
  end;
  PTNotAvailType = ^TNotAvailType;
var
  I , J, FromPos, NumberOfEntries, ListSize : Integer;
  NewStartDateTime, SaveNewStartDateTime, TempStartDateTime : TDateTime;
  IdxCons : Integer;
  SetupNeedMat : double;
  WorkCenter, CalendarCode, ResCode : String;
  PConsumptions : PTConsumptions;
  PNotAvailType, PNotAvailTypeCopy : PTNotAvailType;
  Found : boolean;
  MatList : Tlist;
  AddResList, AddResPointerList : Tlist;
  ManPowerListOrg, ManPowerPointerListOrg, ManPowerList, ManPowerPointerList, TempList, TempListR : TList;
  NextNotPossibleDate  : TDateTime;

function OverrideManPowerListWithDownTime(ManPowerOrg : TList) : TList;
var
  StartCons, EndCons : TDateTime;
  IndexDownTime, IndexCons: integer;
  RecDownTime: PTRecCalDownTime;
  ConsIgnored : boolean;
  RecNoMatDate : PTRecNoMatDate;
begin
  Result := TList.Create;
  for IndexCons := 0 to ManPowerOrg.Count - 1 do
  begin
    StartCons := PTRecNoMatDate(ManPowerOrg[IndexCons]).m_start;
    EndCons := PTRecNoMatDate(ManPowerOrg[IndexCons]).m_end;
    ConsIgnored := false;
    for IndexDownTime := 0 to m_ActArea.m_CrossDownTmList.Count -1 do
    begin
      RecDownTime := m_ActArea.m_CrossDownTmList[IndexDownTime];
      if StartCons >= RecDownTime.DowntimeEnd then continue;
      if EndCons <= RecDownTime.DowntimeStart then break;
      if (StartCons < RecDownTime.DowntimeStart) and (EndCons > RecDownTime.DowntimeEnd) then
      begin
        new(RecNoMatDate);
        RecNoMatDate.m_start := StartCons;
        RecNoMatDate.m_end := RecDownTime.DowntimeStart;
        Result.Add(RecNoMatDate);
        StartCons := RecDownTime.DowntimeEnd;
        continue;
      end;
      if (StartCons >= RecDownTime.DowntimeStart) and (EndCons <= RecDownTime.DowntimeEnd) then
      begin
        ConsIgnored := true;
        break;
      end;
      if (StartCons < RecDownTime.DowntimeStart) and (EndCons <= RecDownTime.DowntimeEnd) then
      begin
        StartCons := RecDownTime.DowntimeStart;
        break;
      end;
      if (StartCons >= RecDownTime.DowntimeStart) and (EndCons > RecDownTime.DowntimeEnd) then
      begin
        StartCons := RecDownTime.DowntimeEnd;
        continue;
      end;
    end;
    if not ConsIgnored then
    begin
      new(RecNoMatDate);
      RecNoMatDate.m_start := StartCons;
      RecNoMatDate.m_end := EndCons;
      Result.Add(RecNoMatDate);
    end;
  end;

end;

begin
  Result := 999999;

  SetupNeedMat := setup - overlap;
  WorkCenter := TMqmWrkCtr(TMqmRes(TMQMVisibleRes(self.m_ResPtr).p_Father).p_WrkCtr).p_WrkCtrCode;
  CalendarCode := m_Cal.GetKey;
  if m_cal.IsResCal then
    ResCode := self.m_ResCode
  else
    ResCode := '';
  Found := false;
  for IdxCons := 0 to MatAddResList.Count - 1 do
  begin
    PConsumptions := PTConsumptions(MatAddResList[IdxCons]);
    if PConsumptions.WorkCenter <> WorkCenter then continue;
    if PConsumptions.CalendarCode <> CalendarCode then continue;
    if PConsumptions.ResCode <> ResCode then continue;
    if PConsumptions.SupMinBase <> SupMinBase then continue;
    if PConsumptions.SetupNeedMat <> SetupNeedMat then continue;
    if PConsumptions.Duration <> Dur then continue;
    Found := true;
    Break;
  end;
  if not Found then
  begin
    new(PConsumptions);
    PConsumptions.WorkCenter := WorkCenter;
    PConsumptions.SupMinBase := SupMinBase;
    PConsumptions.SetupNeedMat := SetupNeedMat;
    PConsumptions.Duration := Dur;
    PConsumptions.MatList := TList.Create;
    PConsumptions.AddResList := TList.Create;
    PConsumptions.AddResPointerList := TList.Create;
    PConsumptions.ManPowerList := TList.Create;
    PConsumptions.ManPowerPointerList := TList.Create;
    m_ResourcesManager.GetMaterialAddRessList(Id, self, PConsumptions.MatList, PConsumptions.AddResList,
        PConsumptions.AddResPointerList, PConsumptions.ManPowerList, PConsumptions.ManPowerPointerList,
        SupMinBase, Dur, SetupNeedMat);
    MatAddResList.add(PConsumptions);
  end;
  MatList := PConsumptions.MatList;
  AddResList := PConsumptions.AddResList;
  AddResPointerList := PConsumptions.AddResPointerList;
  ManPowerListOrg := PConsumptions.ManPowerList;
  ManPowerPointerListOrg := PConsumptions.ManPowerPointerList;

  if Assigned(m_ActArea.m_CrossDownTmList) and (m_ActArea.m_CrossDownTmList.Count > 0) then
  begin
    ManPowerList := Tlist.Create;
    ManPowerPointerList := Tlist.Create;
    TempList := Tlist.Create;
    FromPos := 0;
    for I := 0 to ManPowerPointerListOrg.Count - 1 do
    begin
      PNotAvailType := PTNotAvailType(ManPowerPointerListOrg[I]);
      for J := FromPos to PNotAvailType.ToPos - 1 do
        TempList.Add(ManPowerListOrg[J]);
      FromPos := PNotAvailType.ToPos;
      TempListR := OverrideManPowerListWithDownTime(TempList);
      for J := 0 to TempListR.Count - 1 do
        ManPowerList.Add(TempListR[J]);
      new(PNotAvailTypeCopy);
      PNotAvailTypeCopy.ToPos := ManPowerList.Count;
      PNotAvailTypeCopy.Nature := PNotAvailType.Nature;
      PNotAvailTypeCopy.AddResStart := PNotAvailType.AddResStart;
      PNotAvailTypeCopy.AddResEnd := PNotAvailType.AddResEnd;
      PNotAvailTypeCopy.HoursToDownFromMachine := PNotAvailType.HoursToDownFromMachine;
      ManPowerPointerList.Add(PNotAvailTypeCopy);
      TempList.Clear;
      TempListR.Free;
    end;
    TempList.Free;
  end
  else
  begin
    ManPowerList := ManPowerListOrg;
    ManPowerPointerList := ManPowerPointerListOrg;
  end;

  for I := 0 to AddResPointerList.Count - 1 do
  begin
    PNotAvailType := PTNotAvailType(AddResPointerList[I]);
    PNotAvailType.Index := 0;
  end;

  for I := 0 to ManPowerPointerList.Count - 1 do
  begin
    PNotAvailType := PTNotAvailType(ManPowerPointerList[I]);
    PNotAvailType.Index := 0;
  end;

  SaveNewStartDateTime := 0;
  NewStartDateTime := StartDateTime;
  TempStartDateTime := 0;
  while SaveNewStartDateTime <> NewStartDateTime do
  begin
    if TempStartDateTime = 999999 then break;

    SaveNewStartDateTime := NewStartDateTime;

    if MatList.Count > 0 then
    begin
      TempStartDateTime := PTRecNoMatDate(MatList[MatList.Count -1]).m_end;
      if TempStartDateTime = 999999 then break;
      if NewStartDateTime < TempStartDateTime then NewStartDateTime := TempStartDateTime;
    end;

    for J := 0 to 1 do
    begin
      if TempStartDateTime = 999999 then break;
      if J = 0 then
        ListSize := AddResPointerList.Count
      else
        ListSize := ManPowerPointerList.Count;

      FromPos := 0;
      for I := 0 to ListSize - 1 do
      begin
        if J = 0 then
          PNotAvailType := PTNotAvailType(AddResPointerList[I])
        else
          PNotAvailType := PTNotAvailType(ManPowerPointerList[I]);
        NumberOfEntries := PNotAvailType.ToPos - FromPos;
        if PNotAvailType.Index <= (NumberOfEntries - 1) then
        begin
          if J = 0 then
            TempStartDateTime := FindClosestDateForSingleConsType(Id,setup,overlap,Dur,NewStartDateTime,
                                                                  PNotAvailType.Index,
                                                                  FromPos,NumberOfEntries,AddResList,
                                                                  PNotAvailType.AddResStart, PNotAvailType.AddResEnd,
                                                                  PNotAvailType.HoursToDownFromMachine,
                                                                  NextNotPossibleDate)
          else
            TempStartDateTime := FindClosestDateForSingleConsType(Id,setup,overlap,Dur,NewStartDateTime,
                                                                  PNotAvailType.Index,
                                                                  FromPos,NumberOfEntries,ManPowerList,
                                                                  PNotAvailType.AddResStart, PNotAvailType.AddResEnd,
                                                                  PNotAvailType.HoursToDownFromMachine,
                                                                  NextNotPossibleDate);

          if TempStartDateTime = 999999 then break;
          if NewStartDateTime < TempStartDateTime then NewStartDateTime := TempStartDateTime;
          if NextNotPossibleDate < NextNotPossibleDatePrm then
            NextNotPossibleDatePrm := NextNotPossibleDate;
        end;
        FromPos := PNotAvailType.ToPos;
      end;

    end;

  end;

  if Assigned(m_ActArea.m_CrossDownTmList) and (m_ActArea.m_CrossDownTmList.Count > 0) then
  begin
    for I := 0 to ManPowerList.Count - 1 do
      dispose(PTRecNoMatDate(ManPowerList[I]));
    for I := 0 to ManPowerPointerList.Count - 1 do
      dispose(PTNotAvailType(ManPowerPointerList[I]));
    ManPowerList.Free;
    ManPowerPointerList.Free;
  end;

  if TempStartDateTime = 999999 then exit;

  Result := NewStartDateTime;

end;

//----------------------------------------------------------------------------//

procedure TResourcesStruct.ClearResList;
var
  I : Integer;
begin
  for I := m_SchedList.Count - 1 downto 0 do
    dispose(PTJobToSched(m_SchedList[I]));
end;

//----------------------------------------------------------------------------//

constructor TResourcesStruct.Create(ResPtr : pointer; father : TResourcesManager);
begin
  inherited Create;
  m_SchedList := TList.Create;
  m_IdDeletedList := TStringList.Create;
  m_CurveByFamilyInfo := TList.Create;
  m_ResPtr := TMQMVisibleRes(ResPtr);
  m_ResCode := TMqmRes(TMQMVisibleRes(m_ResPtr).p_Father).p_ResCode;
  if TMqmRes(TMQMVisibleRes(m_ResPtr).p_Father).p_isMultiRes then
    m_ResCode := m_ResCode + IntToStr(TMQMVisibleRes(m_ResPtr).p_SubCode);
  m_PlanType := TMqmRes(TMQMVisibleRes(m_ResPtr).p_Father).p_PlanType;
  m_PlantCode := TMqmWrkCtr(TMqmRes(TMQMVisibleRes(m_ResPtr).p_Father).p_Father).p_PlantCode;
  m_PlantCode := m_PlantCode + TMqmRes(TMQMVisibleRes(m_ResPtr).p_Father).P_LineWithinPlant;
  m_ResourcesManager := father;
  LoadIdFromActiveArea;
end;

//----------------------------------------------------------------------------//

destructor TResourcesStruct.Destroy;
var
  I : Integer;
begin
  ClearResList;
  for I := 0 to m_CurveByFamilyInfo.Count - 1 do
  begin
    PTCurveByFamilyInfo(m_CurveByFamilyInfo[I]).IdsList.Free;
    PTCurveByFamilyInfo(m_CurveByFamilyInfo[I]).IdsStartDate.Free;
    PTCurveByFamilyInfo(m_CurveByFamilyInfo[I]).IdDurationOrg.Free;
    dispose(PTCurveByFamilyInfo(m_CurveByFamilyInfo[I]));
  end;
  m_CurveByFamilyInfo.Free;
  m_SchedList.free;
  m_IdDeletedList.Free;
  inherited Destroy;
end;

{ TResourcesManager }

procedure TResourcesManager.AddResource(ResPtr : Pointer);
var
  ResourcesStruct : TResourcesStruct;
  MqmRes : TMqmRes;
  VisRes : TMQMVisibleRes;
  I : Integer;
begin
  MqmRes := TMqmRes(TMqmVisibleRes(ResPtr).p_father);
  if TMqmWrkCtr(MqmRes.p_father).p_ReadOnly then exit;
  ResourcesStruct := TResourcesStruct.Create(ResPtr, self);
  m_AllResList.Add(ResourcesStruct);
end;

//----------------------------------------------------------------------------//

function TResourcesManager.FindBestScoreAfterLastJob(Id : TSchedId; CheckMovedJob : boolean;
                           var ScoreRecord : TScoreRecord; LimitStartDate, MovedJobStartDate : TDateTime;
                           var GenericPlanDates : Tlist; FindFirstPossiblePlace : Boolean;
                           var HighestPrevEndFound : TDateTime; PlantCode : String) : boolean;
var
  I, IdxCons : Integer;
  PrevId, idSon :  TSchedId;
  ResourcesStruct : TResourcesStruct;
  setup, overlap, supMinBase, duration, durationOrg, score : double;
  StartDateTime, EndDateTime, LowOverlap, HighOverlap : TDateTime;
  Gap, JobQty, MinQtyBatchSize , MaxQtyBatchSize, StandardQtyBatchSize : currency;
  CompJobToJob, CompJobToRes : TCompatVal;
  JobInfo : TSQPlanInfo;
  PrvHighestDate, NxtLowestDate : variant;
  dataType: CBinColValType;
  Position : integer;
  GenericPlanWc, LogText : string;
  GenericPlanDuration, GenericPlanleadTime : double;
  PScoreRecord : PTScoreRecord;
  SchedInfoList : TList;
  ScoreRecordTemp : TScoreRecord;
  LowestEndDateTime, LowestStartDateTime, PrevEndDate : TDateTime;
  LeftGreenLine, RightGreenLine : variant;
  ApprovalDate : TDateTime;
  IgnoreGenericPlan ,IgnoreAddRessMat, Found, StopLoop : boolean;
  Request, RequestPrevId : string;
  PRequestId : PTRequestId;
  TempBoolean : boolean;
//  HoursGapServingGroup : double;

  ServingGroupCode : String;
  ServingCodeLowestDateTime, ServingCodeHighestDateTime : TDateTime;
  ServingCodeHighestMinusTollerance, ServingCodeLowestPlusTollerance, MaxStartDate : TDateTime;
  ServingCodeExist, ServeCodeUnscheEarliest : Boolean;
  LimitStartDateTmp, NextNotPossibleDateTemp : TDateTime;
  MainIdQuantity, MainIdDuration : double;

  ListStrRes, ListStrCmpToRes, ListStrSupMinBase, ListStrDuration, ListStrDurationOrg,
  ListStrStandBatchSize , ListStrMinBatchSize, ListStrMaxBatchSize : TStringList;
  DurationQuantityBase : double;
  MinMaxOptQtyList : Tlist;
  OnlyResourcesWithOptimum, NeedToClean : Boolean;
  ResourcesWithMaximumQty, GapMaximumToJobQuantity : double;

  MatAddResList : Tlist;
  IsBetter : integer;
//  SavedMachineCode : String;
begin
  Application.ProcessMessages;
  SchedInfoList := TList.Create;
  result     := false;
  LowestStartDateTime := 999999;
  LowestEndDateTime := 999999;
  HighestPrevEndFound := 999999;
  ServingCodeLowestPlusTollerance := 0;
  p_sc.GetJobInfo(id, JobInfo);

{  LeftGreenLine := 0;
  RightGreenLine := 0;
  ApprovalDate   := 0;
  if AutoSchedCfg.m_PrevOrNextLinkedJobIsTheTgtDateWhenScheduled then
  begin
    if not p_sc.GetFldValue(Id, CSC_PrvHighestDate, LeftGreenLine, dataType) then LeftGreenLine := 0;
    ApprovalDate := LeftGreenLine;
    if not p_sc.GetFldValue(Id, CSC_NxtLowestDate, RightGreenLine, dataType) then RightGreenLine := 0;
  end;
  if LeftGreenLine = 0 then LeftGreenLine := p_sc.GetLowStart(Id);
  if RightGreenLine = 0 then RightGreenLine := p_sc.GetHighEnd(id);
  if ApprovalDate = 0 then ApprovalDate := p_sc.GetApprovalDate(id);  }
  LeftGreenLine := p_sc.GetLowStart(Id);
  RightGreenLine := p_sc.GetHighEnd(id);
  ApprovalDate := p_sc.GetApprovalDate(id);

 // p_sc.GetFldValue(id, CSC_QtyToSched, QtyVal, dataType);
  JobQty := p_sc.GetJobQty(id);
  if (JobInfo.MinBatchSize > 0) and (JobQty < JobInfo.MinBatchSize) then Exit;

//  p_sc.GetFldValue(Id, CSC_ProdReq, ReqVal, dataType);
  Request := p_sc.GetRequestNumber(Id);
  PRequestId := FindRequestInOverlapList(Request, m_ListOfRequestAndId);

 if p_sc.IsGroup(id) then
  begin
    NeedToClean := false;
    for I := 0 to p_sc.GetGrpNumSons(id)-1 do
    begin
      idSon := p_sc.GetGrpSon(id, I);
      //p_sc.GetFldValue(idSon, CSC_ProdReq, ReqVal, dataType);
      Request := p_sc.GetRequestNumber(Id);
      PRequestId := FindRequestInOverlapList(Request, m_ListOfRequestAndId);
      if PRequestId = nil then
      begin
        new(PRequestId);
        PRequestId.Request := Request;
        PRequestId.Id      := id;
        m_ListOfRequestAndId.Add(PRequestId);
        m_ListOfRequestAndId.Sort(SortByRequest);
      end
      else
      begin
        if PRequestId.Id <> id then
        begin
          PRequestId.Id := id;
          NeedToClean := true;
        end;
      end;
    end;
    if NeedToClean then
      CleanOverlapListById(id);
  end
  else
  begin
    //p_sc.GetFldValue(Id, CSC_ProdReq, ReqVal, dataType);
    Request := p_sc.GetRequestNumber(Id);
    PRequestId := FindRequestInOverlapList(Request, m_ListOfRequestAndId);
    if PRequestId = nil then
    begin
      new(PRequestId);
      PRequestId.Request := Request;
      PRequestId.Id      := Id;
      m_ListOfRequestAndId.Add(PRequestId);
      m_ListOfRequestAndId.Sort(SortByRequest);
    end
    else
    begin
      if PRequestId.Id <> Id then
      begin
        PRequestId.Id := Id;
        CleanOverlapListById(id);
      end;
    end;
  end;

//  if not p_sc.GetFldValue(Id, CSC_PrvHighestDate, PrvHighestDate, dataType) then PrvHighestDate := 0;
//  if not p_sc.GetFldValue(Id, CSC_NxtLowestDate, NxtLowestDate, dataType) then NxtLowestDate := 0;
  PrvHighestDate := p_sc.GetPrvHighestDate(Id);
  NxtLowestDate := p_sc.GetNextHighiestEndDate(Id);

  ServeCodeUnscheEarliest := AutoSchedCfg.m_RescheduleErlierJobsWhenTolerance;
  ServingCodeHighestMinusTollerance := 0;
  ServingCodeExist := false;
  if p_sc.GetServingGroupLowestHighiestDates(id,ServingGroupCode,ServingCodeLowestDateTime,ServingCodeHighestDateTime) then
  begin
    ServingCodeExist := true;
    if ServeCodeUnscheEarliest then
    begin
       ServingCodeHighestMinusTollerance := ServingCodeHighestDateTime - (AutoSchedCfg.m_HoursToleranceOfGapBetweenJobs / 24);
       ServingCodeLowestPlusTollerance := ServingCodeLowestDateTime + (AutoSchedCfg.m_HoursToleranceOfGapBetweenJobs / 24);
    end;
  end;

  ListStrRes := GetInformationById(Id, ListStrCmpToRes, ListStrSupMinBase, ListStrDuration, ListStrDurationOrg,
                ListStrStandBatchSize , ListStrMinBatchSize, ListStrMaxBatchSize, Position, DurationQuantityBase);
  if ListStrRes = nil then exit;

  OnlyResourcesWithOptimum := false;
  ResourcesWithMaximumQty := 0;
  GapMaximumToJobQuantity := 9999999999;
  MinMaxOptQtyList := TList.Create;
  if not FindFirstPossiblePlace then
  begin
    SetCompatibleRes(Id, '', PlantCode, MinMaxOptQtyList);
    if AutoSchedCfg.m_SplitSchedByBatchSize = ByEqualQuantity then
    begin
      for I := 0 to MinMaxOptQtyList.Count - 1 do
      Begin
        if (PTMinMaxOptQty(MinMaxOptQtyList[I]).MaxQty > 0)
        and (JobQty <= (PTMinMaxOptQty(MinMaxOptQtyList[I]).MaxQty))
        and (((PTMinMaxOptQty(MinMaxOptQtyList[I]).MaxQty) - JobQty) < GapMaximumToJobQuantity) then
        begin
          ResourcesWithMaximumQty := PTMinMaxOptQty(MinMaxOptQtyList[I]).MaxQty;
          GapMaximumToJobQuantity := (PTMinMaxOptQty(MinMaxOptQtyList[I]).MaxQty) - JobQty;
        end;
      end;
    end
    else
    begin
      if (AutoSchedCfg.m_SplitSchedByBatchSize <> DailyProductionAndJoin) then
      begin
        for I := 0 to MinMaxOptQtyList.Count - 1 do
        Begin
          if (PTMinMaxOptQty(MinMaxOptQtyList[I]).OptQty > 0)
          and (PTMinMaxOptQty(MinMaxOptQtyList[I]).OptQty = JobQty) then
            OnlyResourcesWithOptimum := true;
        end;
      end;
    end;
  end;

  MatAddResList := TList.Create;
  StopLoop := false;
//  SavedMachineCode := p_sc.GetSavedMachineCode_AUTOSEQ(Id);
  for I := 0 to ListStrRes.Count - 1 do

  begin
    if StopLoop then break;
    ResourcesStruct := FindResourceByCode(ListStrRes.Strings[I], m_AllResList);
    if ResourcesStruct = nil then Continue;
//    if (SavedMachineCode <> '') and (SavedMachineCode <> ResourcesStruct.m_ResCode) then continue;

    if (ResourcesStruct.m_PlanType = RPT_InfiniteCapacity) and (SchedInfoList.Count > 0) then break;

    MinQtyBatchSize :=  StrToFloat(ListStrMinBatchSize.Strings[I]);
    MaxQtyBatchSize :=  StrToFloat(ListStrMaxBatchSize.Strings[I]);
    StandardQtyBatchSize  := StrToFloat(ListStrStandBatchSize.Strings[I]);

    if (PlantCode <> '') and (PlantCode <> ResourcesStruct.m_PlantCode) then Continue;
    if not FindFirstPossiblePlace then
    begin

//      if JobQty < StrToFloat(ListStrMinBatchSize.Strings[I]) then Continue;
//      if (StrToFloat(ListStrMaxBatchSize.Strings[I]) > 0) and (JobQty > StrToFloat(ListStrMaxBatchSize.Strings[I])) then Continue;
//      if JobQty < StrToFloat(ListStrMinBatchSize.Strings[I]) then Continue;
//      if (StrToFloat(ListStrMaxBatchSize.Strings[I]) > 0) and (JobQty > StrToFloat(ListStrMaxBatchSize.Strings[I])) then Continue;

      if JobQty < MinQtyBatchSize then Continue;
      if (MaxQtyBatchSize > 0) and (JobQty > MaxQtyBatchSize) then Continue;
      if JobQty < MinQtyBatchSize then Continue;
      if (MaxQtyBatchSize > 0) and (JobQty > MaxQtyBatchSize) then Continue;

    end;
//    if (ResourcesWithMaximumQty > 0) and (ResourcesWithMaximumQty <> StrToFloat(ListStrMaxBatchSize.Strings[I])) then continue;
//    if OnlyResourcesWithOptimum and (JobQty <> StrToFloat(ListStrStandBatchSize.Strings[I])) then continue;

    if (ResourcesWithMaximumQty > 0) and (ResourcesWithMaximumQty <> MaxQtyBatchSize) then continue;
    if OnlyResourcesWithOptimum and (JobQty <> StandardQtyBatchSize) then continue;

    if ResourcesStruct.m_SchedList.Count = 0 then
      PrevId := CSchedIDnull
    else
      PrevId := PTJobToSched(ResourcesStruct.m_SchedList[ResourcesStruct.m_SchedList.Count -1]).Id;

    if AutoSchedCfg.m_FindFirstFreeInifiniteCapacityResource then
    begin
      if PrevId = CSchedIDnull then
        StopLoop := true
      else
        continue;
    end;

    if (PrevId <> CSchedIDnull) then
      PrevEndDate := PTJobToSched(ResourcesStruct.m_SchedList[ResourcesStruct.m_SchedList.Count -1]).EndSched
    else
      PrevEndDate := AutoSchedCfg.m_NowDateTime;

    if HighestPrevEndFound = 999999 then
      HighestPrevEndFound := PrevEndDate;
    if HighestPrevEndFound < PrevEndDate then
       HighestPrevEndFound := PrevEndDate;

    IgnoreGenericPlan := false;
    IgnoreAddRessMat  := false;

    LimitStartDateTmp := LimitStartDate;
    if ServingCodeHighestMinusTollerance > LimitStartDateTmp then
       LimitStartDateTmp := ServingCodeHighestMinusTollerance;

    MaxStartDate := 0;
    if ServingCodeExist and ServeCodeUnscheEarliest then
    begin
      if CheckMovedJob or AutoSchedCfg.m_PushToThePreferedDateMode or AutoSchedCfg.m_McmRescheduledJobs
      or (AutoSchedCfg.m_OverridingParams_Activated and AutoSchedCfg.m_OverridingParams_AllowedMoveLinkedReq) then
        MaxStartDate := ServingCodeLowestPlusTollerance;
    end;

    if (PrevId <> CSchedIDnull)
    and (AutoSchedCfg.m_SplitSchedByBatchSize = DailyProductionAndJoin)
    and (not AutoSchedCfg.m_PushToThePreferedDateMode)
    and (MinQtyBatchSize = -1) then
    begin
      RequestPrevId := p_sc.GetRequestNumber(PrevId);
      if Request = RequestPrevId then
        PrevEndDate := PrevEndDate + (1 / 24 / 60 / 60 * 4);
    end;

    if ResourcesStruct.CheckScoreAfterJob(PrevId, Id , CheckMovedJob,
              LimitStartDateTmp, MaxStartDate, 0, MovedJobStartDate, PrevEndDate ,ScoreRecordTemp ,GenericPlanDates,
              PrvHighestDate, NxtLowestDate, MatAddResList, IgnoreGenericPlan, IgnoreAddRessMat,
              StrToFloat(ListStrSupMinBase.Strings[I]), StrToFloat(ListStrDuration.Strings[I]),
              StrToFloat(ListStrDurationOrg.Strings[I]),
              DurationQuantityBase) then
    begin
//      if  CheckMovedJob and ServingCodeExist and ServeCodeUnscheEarliest
//      and (ScoreRecordTemp.StartDateTime > ServingCodeLowestPlusTollerance) then Continue;
      new(PScoreRecord);
      PScoreRecord.StartDateTime := ScoreRecordTemp.StartDateTime;
      PScoreRecord.Gap           := ScoreRecordTemp.Gap;
      PScoreRecord.GenericPlanWc  := ScoreRecordTemp.GenericPlanWc;
      PScoreRecord.Duration      := ScoreRecordTemp.Duration;
      PScoreRecord.DurationOrg   := ScoreRecordTemp.DurationOrg;
      PScoreRecord.SetUp         := ScoreRecordTemp.setup;
      PScoreRecord.SetUpNoMaterial := ScoreRecordTemp.SetupNoMaterial;
      PScoreRecord.GenericPlanleadTime := ScoreRecordTemp.GenericPlanleadTime;
      PScoreRecord.GenericPlanDuration := ScoreRecordTemp.GenericPlanDuration;
      PScoreRecord.supMinBase     := ScoreRecordTemp.supMinBase;
      PScoreRecord.Resource      := ResourcesStruct;
      PScoreRecord.EndDateTime   := ScoreRecordTemp.EndDateTime;
      PScoreRecord.CompValJobToJob := ScoreRecordTemp.CompValJobToJob;
      PScoreRecord.PrevID          := prevId;
      PScoreRecord.CompValJobToRes  := StrToInt(ListStrCmpToRes.Strings[I]);
      PScoreRecord.LowOverlap := ScoreRecordTemp.LowOverlap;
      PScoreRecord.HighOverlap := ScoreRecordTemp.HighOverlap;
      PScoreRecord.MainIdQuantity := DurationQuantityBase;
      PScoreRecord.MainIdDuration := StrToFloat(ListStrDurationOrg.Strings[I]);
      PScoreRecord.NextNotPossibleDate := ScoreRecordTemp.NextNotPossibleDate;
      SchedInfoList.Add(PScoreRecord);

      if LowestStartDateTime > PScoreRecord.StartDateTime then
        LowestStartDateTime := PScoreRecord.StartDateTime;

      if LowestEndDateTime > PScoreRecord.EndDateTime then
        LowestEndDateTime := PScoreRecord.EndDateTime;

      if FindFirstPossiblePlace then break;

    end
    else
    begin
      if (PrevId = CSchedIDnull) and (ResourcesStruct.m_PlanType <> RPT_OverCapacity) then
        StopLoop := true; // If the resource is empty and not able to schedule, it will not schedule anywhere
    end;
  end;

  CleanMaterialAddRessList(MatAddResList);
  MatAddResList.Free;

  for I := 0 to MinMaxOptQtyList.Count - 1 do
      Dispose(PTMinMaxOptQty(MinMaxOptQtyList[I]));
  MinMaxOptQtyList.Free;

  for I := 0 to SchedInfoList.Count - 1 do
  begin
    StartDateTime := PTScoreRecord(SchedInfoList[I]).StartDateTime;
    Gap := PTScoreRecord(SchedInfoList[I]).Gap;
    GenericPlanWc := PTScoreRecord(SchedInfoList[I]).GenericPlanWc;
    GenericPlanleadTime := PTScoreRecord(SchedInfoList[I]).GenericPlanleadTime;
    GenericPlanDuration := PTScoreRecord(SchedInfoList[I]).GenericPlanDuration;
    Duration := PTScoreRecord(SchedInfoList[I]).Duration;
    DurationOrg := PTScoreRecord(SchedInfoList[I]).DurationOrg;
    ResourcesStruct := PTScoreRecord(SchedInfoList[I]).Resource;
    EndDateTime := PTScoreRecord(SchedInfoList[I]).EndDateTime;
    setup       := PTScoreRecord(SchedInfoList[I]).SetUp;
    overlap     := PTScoreRecord(SchedInfoList[I]).SetUpNoMaterial;
    CompJobToJob := PTScoreRecord(SchedInfoList[I]).CompValJobToJob;
    PrevID      := PTScoreRecord(SchedInfoList[I]).prevId;
    supMinBase  := PTScoreRecord(SchedInfoList[I]).supMinBase;
    CompJobToRes := PTScoreRecord(SchedInfoList[I]).CompValJobToRes;
    LowOverlap := PTScoreRecord(SchedInfoList[I]).LowOverlap;
    HighOverlap := PTScoreRecord(SchedInfoList[I]).HighOverlap;
    MainIdQuantity := PTScoreRecord(SchedInfoList[I]).MainIdQuantity;
    MainIdDuration := PTScoreRecord(SchedInfoList[I]).MainIdDuration;
    NextNotPossibleDateTemp := PTScoreRecord(SchedInfoList[I]).NextNotPossibleDate;

    score := ResourcesStruct.CalcScore(TMqmRes(TMQMVisibleRes(ResourcesStruct.m_ResPtr).p_Father),
              id, previd, PTScoreRecord(SchedInfoList[I]), LowestEndDateTime, CompJobToRes,
              ServingGroupCode, ServingCodeLowestDateTime, ServingCodeHighestDateTime);
    LogText := 'ENDAfterLastTest';
//    if not FindFirstPossiblePlace then
//      FillLogListLine(LogText, Id, false, PTScoreRecord(SchedInfoList[I]), CompJobToRes, score, LowestEndDateTime);
    dispose(PTScoreRecord(SchedInfoList[I]));

    if ServingCodeExist and ServeCodeUnscheEarliest then
    begin
      if  (LowestStartDateTime <= ServingCodeLowestPlusTollerance)
      and (StartDateTime > ServingCodeLowestPlusTollerance) then Continue;
      if  (LowestStartDateTime > ServingCodeLowestPlusTollerance)
      and (StartDateTime > LowestStartDateTime) then Continue;
    end;

    if Result then
    begin
      if AutoSchedCfg.m_PushToThePreferedDateMode then
        TempBoolean := false
      else
        TempBoolean := true;

      IsBetter := IsPossitionBetter(ScoreRecord.Resource.m_PlanType, ResourcesStruct.m_PlanType,
                                    ScoreRecord.StartDateTime, StartDateTime,
                                    ScoreRecord.EndDateTime, EndDateTime,
                                    LeftGreenLine, RightGreenLine, ApprovalDate,
                                    ScoreRecord.LowOverlap, LowOverlap,
                                    ScoreRecord.HighOverlap, HighOverlap,
                                    ScoreRecord.Score, Score,
                                    TempBoolean, false);
      if IsBetter < 0 then
        continue;
      if IsBetter = 0 then
      begin
        if Gap >= ScoreRecord.Gap then continue;
      end;
    end;

    ScoreRecord.Score         := Score;
    ScoreRecord.StartDateTime := StartDateTime;
    ScoreRecord.Gap           := Gap;
    ScoreRecord.GenericPlanWc  := GenericPlanWc;
    ScoreRecord.GenericPlanleadTime := GenericPlanleadTime;
    ScoreRecord.GenericPlanDuration := GenericPlanDuration;
    ScoreRecord.Duration      := Duration;
    ScoreRecord.DurationOrg   := DurationOrg;
    ScoreRecord.Resource      := ResourcesStruct;
    ScoreRecord.EndDateTime   := EndDateTime;
    ScoreRecord.Setup         := setup;
    ScoreRecord.SetupNoMaterial := overlap;
    ScoreRecord.PrevId          := PrevId;
    ScoreRecord.CompValJobToJob := CompJobToJob;
    ScoreRecord.supMinBase := supMinBase;
    ScoreRecord.CompValJobToRes := CompJobToRes;
    ScoreRecord.LowOverlap   := LowOverlap;
    ScoreRecord.HighOverlap  := HighOverlap;
    ScoreRecord.MainIdQuantity := MainIdQuantity;
    ScoreRecord.MainIdDuration := MainIdDuration;
    ScoreRecord.NextNotPossibleDate := NextNotPossibleDateTemp;

    Result := true;
  end;

  if result then
  begin
     ScoreRecord.Score := ScoreRecord.Resource.CalcScore(TMqmRes(TMQMVisibleRes(ScoreRecord.Resource.m_ResPtr).p_Father),
                          id, ScoreRecord.PrevId, @ScoreRecord, 999999, ScoreRecord.CompValJobToRes,
                          ServingGroupCode, ServingCodeLowestDateTime, ServingCodeHighestDateTime);
     LogText := 'ENDAfterLastOk';
     if FindFirstPossiblePlace then LogText := 'BinSortPlantTest';
//     FillLogListLine(LogText,Id, false, @ScoreRecord, CompJobToRes, ScoreRecord.Score, 0);
  end;

  SchedInfoList.Free;

end;

//----------------------------------------------------------------------------//

procedure TResourcesManager.CleanGenericPlanDates(var GenericPlanDates : Tlist);
var
  I : Integer;
begin
  for I := GenericPlanDates.Count - 1 downto 0 do
    dispose(PTGenericPlan(GenericPlanDates[I]));
  GenericPlanDates.clear;
end;

//----------------------------------------------------------------------------//

function TResourcesManager.FindBestScoreBeforeLastJob(Id : TSchedId; ScoreAfterLastJob : TScoreRecord; LimitStartDate : TDateTime;
                                  GenericPlanDates : TList;
                                  var NewScore : double; PlantCode : String; ScoreAfterLastFound : boolean;
                                  FindFirstPossiblePlace : Boolean;
                                  BetweenSchedDoneAfter : boolean; var IdxToSched : integer; out ReturnScoreRecordIdToPrevId : TScoreRecord;
                                  CanBeNewId : boolean) : boolean;
var
  I, Index, Position, IdxCons : Integer;
  ResourcesStruct, BestScoreResource : TResourcesStruct;
  PrevId, ToMoveId : TSchedId;
  LeftGreenLine, RightGreenLine : variant;
  PrevEndDate, ToMoveIdStartDate, ToMoveIdEndDate, ApprovalDate : TDateTime;
  CalculatedGap, SpaceAvailBeforeLateJob : double;
  JobInfo, PlanInfo : TSQplanInfo;
  score, SchedBetweenJobsScore : double;
  ValPrev, ValNext : variant;
  dataType: CBinColValType;
  ScoreRecord, ReturnScoreRecordToMoveIdToId : TScoreRecord;
  CameAcrossANonMovedJob, CanNotMoveBecauseOfConfirmLevel : boolean;
  BetterScoreFound, SchedBetweenJobsScoreFound : boolean;
  BestScoreIndex, BestScoreResourceIndex, SchedBetweenJobsIdIndex, SchedBetweenJobsResourceIndex : Integer;
  JobIdFromBackup : PTJobInfo;
  ReqValId, ReqValMoveId : string;
  TryToPush, Found, SameRequestFound : boolean;
  ScoreList : TList;

  ServingGroupCode : String;
  ServingCodeLowestDateTime, ServingCodeHighestDateTime : TDateTime;
  ServingCodeHighestMinusTollerance, ServingCodeLowestPlusTollerance : TDateTime;
  MainIdLimitStart : TDateTime;

  RollBackInfo : PTJobToSched;

  ListStrRes, ListStrCmpToRes, ListStrSupMinBase, ListStrDuration, ListStrDurationOrg,
  ListStrStandBatchSize , ListStrMinBatchSize, ListStrMaxBatchSize : TStringList;
  DurationQuantityBase, JobQty : double;

  MinMaxOptQtyList : Tlist;
  OnlyResourcesWithOptimum : Boolean;
  ResourcesWithMaximumQty, GapMaximumToJobQuantity : double;

  MatAddResList : Tlist;

  CompValJobToJob, CompValJobToJobDifference : TCompatVal;        // TMG 17/07/2017
  Setup, SetupNoMaterial, GenericPlanDuration, GenericPlanleadTime : double; // TMG 17/07/2017
  GenericPlanWc : String;  // TMG 17/07/2017
  RecalcDur : boolean;
begin
  Application.ProcessMessages;
  result := false;
  SchedBetweenJobsScoreFound := false;
  BestScoreResourceIndex := -1;
  BestScoreIndex := -1;
//  if m_MainIdResList.Count = 0 then exit;
  ScoreList := TList.Create;
  BestScoreResource := nil;
  IdxToSched := -1;

//  JobIdFromBackup := FindIdInBackUpList(Id, m_ListBackupIdInfo);
//  p_sc.GetDatesInfo(id, DatesInfo);
//  if not p_sc.GetFldValue(ID, CSC_PrvHighestDate, ValPrev, dataType) then ValPrev := 0;
//  if not p_sc.GetFldValue(ID, CSC_NxtLowestDate, ValNext, dataType) then ValNext := 0;
  ValPrev := p_sc.GetPrvHighestDate(Id);
  ValNext := p_sc.GetNextHighiestEndDate(Id);
//  ReqValId := p_sc.GetRequestNumber(Id);
  JobIdFromBackup := FindIdInBackUpList(Id, m_ListBackupIdInfo);
  ReqValId := JobIdFromBackup.RequestNumber;

//  FillLogListLine('StartMove',Id, false, nil, -1, -1, 0);

  ServingCodeHighestMinusTollerance := 0;
  ServingCodeLowestPlusTollerance := 999999;
  if p_sc.GetServingGroupLowestHighiestDates(id,ServingGroupCode,ServingCodeLowestDateTime,ServingCodeHighestDateTime) then
  begin
    if AutoSchedCfg.m_RescheduleErlierJobsWhenTolerance then
    begin
       ServingCodeHighestMinusTollerance := ServingCodeHighestDateTime - (AutoSchedCfg.m_HoursToleranceOfGapBetweenJobs / 24);
       ServingCodeLowestPlusTollerance := ServingCodeLowestDateTime + (AutoSchedCfg.m_HoursToleranceOfGapBetweenJobs / 24);
    end;
  end;

  MainIdLimitStart := LimitStartDate;
  if ServingCodeHighestMinusTollerance > MainIdLimitStart then
     MainIdLimitStart := ServingCodeHighestMinusTollerance;

  ListStrRes := GetInformationById(Id, ListStrCmpToRes, ListStrSupMinBase, ListStrDuration, ListStrDurationOrg,
                ListStrStandBatchSize , ListStrMinBatchSize, ListStrMaxBatchSize, Position, DurationQuantityBase);
  if ListStrRes = nil then exit;
  //p_sc.GetFldValue(id, CSC_QtyToSched, QtyVal, dataType);
  JobQty := p_sc.GetJobQty(id);
  p_sc.GetJobInfo(Id, JobInfo);
  if (JobInfo.MinBatchSize > 0) and (JobQty < JobInfo.MinBatchSize) then Exit;

  OnlyResourcesWithOptimum := false;
  ResourcesWithMaximumQty := 0;
  GapMaximumToJobQuantity := 9999999999;
  MinMaxOptQtyList := TList.Create;
  SetCompatibleRes(Id, '', PlantCode, MinMaxOptQtyList);
  if AutoSchedCfg.m_SplitSchedByBatchSize = ByEqualQuantity then
  begin
    for I := 0 to MinMaxOptQtyList.Count - 1 do
    Begin
      if (PTMinMaxOptQty(MinMaxOptQtyList[I]).MaxQty > 0)
      and (JobQty <= (PTMinMaxOptQty(MinMaxOptQtyList[I]).MaxQty))
      and (((PTMinMaxOptQty(MinMaxOptQtyList[I]).MaxQty) - JobQty) < GapMaximumToJobQuantity) then
      begin
        ResourcesWithMaximumQty := PTMinMaxOptQty(MinMaxOptQtyList[I]).MaxQty;
        GapMaximumToJobQuantity := (PTMinMaxOptQty(MinMaxOptQtyList[I]).MaxQty) - JobQty;
      end;
    end;
  end
  else
  begin
    for I := 0 to MinMaxOptQtyList.Count - 1 do
    Begin
      if (PTMinMaxOptQty(MinMaxOptQtyList[I]).OptQty > 0)
      and (PTMinMaxOptQty(MinMaxOptQtyList[I]).OptQty = JobQty) then
        OnlyResourcesWithOptimum := true;
    end;
  end;

  MatAddResList := TList.Create;
  LeftGreenLine := p_sc.GetLowStart(Id);
  RightGreenLine := p_sc.GetHighEnd(id);
  ApprovalDate := p_sc.GetApprovalDate(id);

  for I := 0 to ListStrRes.Count - 1 do
  begin
    ResourcesStruct := FindResourceByCode(ListStrRes.Strings[I], m_AllResList);
    if ResourcesStruct = nil then Continue;

    if (ResourcesStruct.m_PlanType = RPT_InfiniteCapacity) and ((result or SchedBetweenJobsScoreFound)) then
      break;

    if (PlantCode <> '') and (PlantCode <> ResourcesStruct.m_PlantCode) then Continue;
    if JobQty < StrToFloat(ListStrMinBatchSize.Strings[I]) then Continue;
    if (StrToFloat(ListStrMaxBatchSize.Strings[I]) > 0) and (JobQty > StrToFloat(ListStrMaxBatchSize.Strings[I])) then Continue;
    if (ResourcesWithMaximumQty > 0) and (ResourcesWithMaximumQty <> StrToFloat(ListStrMaxBatchSize.Strings[I])) then continue;
    if OnlyResourcesWithOptimum and (JobQty <> StrToFloat(ListStrStandBatchSize.Strings[I])) then continue;

    Index := ResourcesStruct.m_SchedList.Count;
    if Index = 0 then continue;
    CameAcrossANonMovedJob := false;
    SpaceAvailBeforeLateJob := -1;
    SameRequestFound := false;
    while true do
    begin
      if Index = 0 then break;
      Index := Index - 1;
      if not PTJobToSched(ResourcesStruct.m_SchedList[Index]).PossibleSchedBefore then break;

      ToMoveId := PTJobToSched(ResourcesStruct.m_SchedList[Index]).Id;
      ToMoveIdStartDate := PTJobToSched(ResourcesStruct.m_SchedList[Index]).StartSched;
      ToMoveIdEndDate := PTJobToSched(ResourcesStruct.m_SchedList[Index]).EndSched;

//      ReqValMoveId := p_sc.GetRequestNumber(ToMoveId);
      JobIdFromBackup := FindIdInBackUpList(ToMoveId, m_ListBackupIdInfo);
      ReqValMoveId := JobIdFromBackup.RequestNumber;
      if ReqValId = ReqValMoveId then {break} SameRequestFound := true;

      if Index = 0 then
      begin
        PrevId := CSchedIDnull;
        PrevEndDate := AutoSchedCfg.m_NowDateTime;
      end
      else
      begin
        PrevId := PTJobToSched(ResourcesStruct.m_SchedList[Index -1]).id;
        PrevEndDate := PTJobToSched(ResourcesStruct.m_SchedList[Index - 1]).EndSched;
        if  (SameRequestFound)
        and (AutoSchedCfg.m_SplitSchedByBatchSize = DailyProductionAndJoin)
        and (not AutoSchedCfg.m_PushToThePreferedDateMode)
        and (StrToFloat(ListStrMinBatchSize.Strings[I]) = - 1) then
          PrevEndDate := PrevEndDate + (1 / 24 / 60 / 60 * 4);
      end;

      CanNotMoveBecauseOfConfirmLevel := false;
      if (AutoSchedCfg.m_MoveObjsAllowed = 3) then CanNotMoveBecauseOfConfirmLevel := true;
      if ((AutoSchedCfg.m_TempFinal = 1) and (AutoSchedCfg.m_MoveInitialObjsAlwd = 0))
      or ((AutoSchedCfg.m_TempFinal = 0) and (AutoSchedCfg.m_MoveFinalObjsAlwd = 0))
      or ((AutoSchedCfg.m_TempFinal = 2) and (AutoSchedCfg.m_MoveLevel1ObjsAlwd = 0))
      or ((AutoSchedCfg.m_TempFinal = 3) and (AutoSchedCfg.m_MoveLevel2ObjsAlwd = 0))
      or ((AutoSchedCfg.m_TempFinal = 4) and (AutoSchedCfg.m_MoveLevel3ObjsAlwd = 0))
      or ((AutoSchedCfg.m_TempFinal = 5) and (AutoSchedCfg.m_MoveLevel4ObjsAlwd = 0))
      or ((AutoSchedCfg.m_TempFinal = 6) and (AutoSchedCfg.m_MoveLevel5ObjsAlwd = 0))then
        CanNotMoveBecauseOfConfirmLevel := true;

      if not PTJobToSched(ResourcesStruct.m_SchedList[Index]).PossibleMoveJob then
         CanNotMoveBecauseOfConfirmLevel := true;

      if CanNotMoveBecauseOfConfirmLevel and not AutoSchedCfg.m_AllowSchedBeforeNoneConfLevl then break;
      if SameRequestFound then CanNotMoveBecauseOfConfirmLevel := true;
      if AutoSchedCfg.m_PushToThePreferedDateMode then CanNotMoveBecauseOfConfirmLevel := true;

      if CanNotMoveBecauseOfConfirmLevel then CameAcrossANonMovedJob := true;

      if not ResourcesStruct.CalcScoreToAnAlreadySchedJob(Index, JobIdFromBackup.ServingGroupCode) then
      begin
        CameAcrossANonMovedJob := true;
        Continue;
      end;

      CalculatedGap := (ToMoveIdStartDate - PrevEndDate) * 24 * 60;
      if PTJobToSched(ResourcesStruct.m_SchedList[Index]).JobIsLate then
        SpaceAvailBeforeLateJob := CalculatedGap
      else
      begin
        if (SpaceAvailBeforeLateJob > -1) then
          SpaceAvailBeforeLateJob := SpaceAvailBeforeLateJob + CalculatedGap;
      end;

      if ResourcesStruct.CheckAndScorePositionWithoutMove(Id, PrevId, ToMoveId, ApprovalDate,
         LeftGreenLine, RightGreenLine,
         PrevEndDate, ToMoveIdStartDate, ValPrev, ValNext, ScoreAfterLastJob, ScoreAfterLastFound, MatAddResList,
         GenericPlanDates, Index, I, ServingGroupCode,
         ServingCodeLowestDateTime, ServingCodeHighestDateTime,
         MainIdLimitStart, ServingCodeLowestPlusTollerance,
         StrToFloat(ListStrSupMinBase.Strings[I]), StrToFloat(ListStrDuration.Strings[I]),
         StrToFloat(ListStrDurationOrg.Strings[I]),
         DurationQuantityBase, StrToInt(ListStrCmpToRes.Strings[I]),
         SchedBetweenJobsScoreFound, SchedBetweenJobsScore,
         SchedBetweenJobsIdIndex, SchedBetweenJobsResourceIndex, ReturnScoreRecordIdToPrevId,
         ReturnScoreRecordToMoveIdToId, CanBeNewId) then
      begin
        if not FindFirstPossiblePlace then continue;
        result := true;
        exit;
      end;

      if FindFirstPossiblePlace or CameAcrossANonMovedJob then continue;
      if  (SpaceAvailBeforeLateJob > -1) and (Index < ResourcesStruct.m_SchedList.Count - 1)
      and (StrToFloat(ListStrDuration.Strings[I]) > SpaceAvailBeforeLateJob) then
        Continue;

      if not ResourcesStruct.CheckScoreAfterJob(PrevId, Id , false, MainIdLimitStart, 0, 0, 0, PrevEndDate ,
              ScoreRecord ,nil, ValPrev, ValNext, MatAddResList,
              true, true, StrToFloat(ListStrSupMinBase.Strings[I]), StrToFloat(ListStrDuration.Strings[I]),
              StrToFloat(ListStrDurationOrg.Strings[I]),
              DurationQuantityBase) then continue;

      // Change done by Eran 21/01/2019 - Continue instead of break because if a job ends after the next job
      // It does not mean that it can not find a place before prior jobs - for example - it might
      // find place before because there are other capacity reservations
      // -------------------------------------------------------------------
      // if ScoreRecord.StartDateTime >= ToMoveIdEndDate then break;
      if ScoreRecord.StartDateTime >= ToMoveIdEndDate then continue;
      // End change Eran 21/01/2019

      if  (ScoreRecord.EndDateTime > ServingCodeLowestPlusTollerance)
      and (ScoreRecord.EndDateTime > ScoreAfterLastJob.EndDateTime) then continue;

//      if not TMqmRes(TMQMVisibleRes(ResourcesStruct.m_ResPtr).p_Father).GetSetupParms(PrevId, ToMoveId, supRec, compVal, IsSameGroup) then continue;
//      if ScoreRecord.CompValJobToJob >= compVal then continue;

      score := ResourcesStruct.CalcScore(TMqmRes(TMQMVisibleRes(ResourcesStruct.m_ResPtr).p_Father),
                               id, previd, @ScoreRecord , 999999,
                               StrToInt(ListStrCmpToRes.Strings[I]), ServingGroupCode,
                               ServingCodeLowestDateTime, ServingCodeHighestDateTime);

      TryToPush := false;
      if not ScoreAfterLastFound then TryToPush := true;
      if score < ScoreAfterLastJob.Score then TryToPush := true;
      if (score = ScoreAfterLastJob.Score) and (ScoreRecord.StartDateTime < ScoreAfterLastJob.StartDateTime) then TryToPush := true;
      if ScoreRecord.CompValJobToJob < PTJobToSched(ResourcesStruct.m_SchedList[Index]).CompValJobToJob then TryToPush := true;
      if not TryToPush then   // TMG 17/07/2017
      begin
        ResourcesStruct.m_ResourcesManager.CheckSetupCompactParam(ToMoveId, Id,
          ResourcesStruct.m_ResCode,ResourcesStruct.m_ActArea,CompValJobToJob,
          PTJobToSched(ResourcesStruct.m_SchedList[Index]).supMinBase,
          Setup, SetupNoMaterial, GenericPlanWc, GenericPlanDuration, GenericPlanleadTime, RecalcDur);
          CompValJobToJobDifference := CompValJobToJob - PTJobToSched(ResourcesStruct.m_SchedList[Index]).CompValJobToJob +
            ScoreRecord.CompValJobToJob - ScoreAfterLastJob.CompValJobToJob;
          if CompValJobToJobDifference < 0 then TryToPush := true;
      end;  // TMG 17/07/2017
      if not TryToPush then Continue;

      BetterScoreFound := ResourcesStruct.TempScoreAndScheduleAndPushAllJobsFromPosition(Id,
                               ScoreList, Index, Result, NewScore, ScoreAfterLastJob, ScoreAfterLastFound,
                               MainIdLimitStart, ValPrev, ValNext, I, false, ServingGroupCode,
                               ServingCodeLowestDateTime, ServingCodeHighestDateTime,
                               ServingCodeLowestPlusTollerance, PlantCode,
                               StrToFloat(ListStrSupMinBase.Strings[I]), StrToFloat(ListStrDuration.Strings[I]),
                               StrToFloat(ListStrDurationOrg.Strings[I]),
                               DurationQuantityBase, StrToInt(ListStrCmpToRes.Strings[I]));
      if BetterScoreFound then
      begin
        BestScoreIndex := index;
        BestScoreResource := ResourcesStruct;
        BestScoreResourceIndex := I;
        result := true;
      end;

    end;

  end;

  CleanMaterialAddRessList(MatAddResList);
  MatAddResList.Free;

  for I := 0 to MinMaxOptQtyList.Count - 1 do
      Dispose(PTMinMaxOptQty(MinMaxOptQtyList[I]));
  MinMaxOptQtyList.Free;

  if SchedBetweenJobsScoreFound and (not result)
  or (SchedBetweenJobsScoreFound and result and (SchedBetweenJobsScore <= NewScore)) then
  begin
    result := true;
    NewScore := SchedBetweenJobsScore;
//    ResourcesStruct := TResourcesStruct(m_MainIdResList[SchedBetweenJobsResourceIndex]);
    ResourcesStruct := FindResourceByCode(ListStrRes.Strings[SchedBetweenJobsResourceIndex], m_AllResList);
    ToMoveId := PTJobToSched(ResourcesStruct.m_SchedList[SchedBetweenJobsIdIndex]).Id;
    p_sc.GetPlanInfo(ToMoveId, PlanInfo);
    if (PlanInfo.GenericPlanWC <> '') and (ReturnScoreRecordToMoveIdToId.GenericPlanWc = '') then
    begin

      new(RollBackInfo);
      RollBackInfo^ := PTJobToSched(ResourcesStruct.m_SchedList[SchedBetweenJobsIdIndex])^;
      RollBackInfo.SchedType := RemoveGenericPlan;
      RollBackInfo.PosInList := SchedBetweenJobsIdIndex;
      RollBackInfo.ResourceManagerPtr := self;
      RollBackInfo.ResourcesStruct := ResourcesStruct;
      RollBackInfo.ReScheduleAtSpecificPlace := false;
      m_rollbackInfoList.Add(RollBackInfo);

      UMGenericSchedulePrevStep.UnScheduleGenericPlan(ToMoveId);
      PlanInfo.GenericPlanWC := '';
      p_sc.SetGenericInfo(ToMoveId, PlanInfo);
      PTJobToSched(ResourcesStruct.m_SchedList[SchedBetweenJobsIdIndex]).GenericPlanWC  := '';

    end;
    if (PlanInfo.startDate <> ReturnScoreRecordToMoveIdToId.StartDateTime)
    or (PlanInfo.endDate <> ReturnScoreRecordToMoveIdToId.EndDateTime)
    or (PlanInfo.supMinReal <> ReturnScoreRecordToMoveIdToId.setup)
    or (PlanInfo.supMinOvlp <> ReturnScoreRecordToMoveIdToId.SetupNoMaterial) then
    begin
      new(RollBackInfo);
      RollBackInfo^ := PTJobToSched(ResourcesStruct.m_SchedList[SchedBetweenJobsIdIndex])^;
      RollBackInfo.SchedType := update;
      RollBackInfo.PosInList   := SchedBetweenJobsIdIndex;
      RollBackInfo.ResourceManagerPtr := self;
      RollBackInfo.ResourcesStruct := ResourcesStruct;
      RollBackInfo.ReScheduleAtSpecificPlace := false;
      m_rollbackInfoList.Add(RollBackInfo);

//      JobIdFromBackup := FindIdInBackUpList(ToMoveId, m_ListBackupIdInfo);
      if (JobIdFromBackup.ResCode <> '') and not JobIdFromBackup.UnscheduledFromActArea then
         JobIdFromBackup.UnscheduledFromActArea := true;
      p_pl.UpdatePlanLinkJob('', ToMoveId, nil);
      PlanInfo.startDate := ReturnScoreRecordToMoveIdToId.StartDateTime;
      PlanInfo.EndDate := ReturnScoreRecordToMoveIdToId.EndDateTime;
      PlanInfo.supMinReal := ReturnScoreRecordToMoveIdToId.Setup;
      PlanInfo.supMinOvlp := ReturnScoreRecordToMoveIdToId.SetupNoMaterial;
     // p_sc.SetPlanInfo(ToMoveId, PlanInfo);
      ResourcesStruct.SetPlanInfo(ToMoveId, PlanInfo);
      //p_pl.UpdatePlanLinkJob(ResourcesStruct.m_ResCode, ToMoveId, nil);
      p_pl.UpdatePlanLinkJobAutoSeq(ResourcesStruct.m_ResPtr,ToMoveId, nil);
      p_sc.UpdateBalance(ToMoveId);
    end;
    PTJobToSched(ResourcesStruct.m_SchedList[SchedBetweenJobsIdIndex]).StartSched := ReturnScoreRecordToMoveIdToId.StartDateTime;
    PTJobToSched(ResourcesStruct.m_SchedList[SchedBetweenJobsIdIndex]).EndSched := ReturnScoreRecordToMoveIdToId.EndDateTime;
    PTJobToSched(ResourcesStruct.m_SchedList[SchedBetweenJobsIdIndex]).LowOverlap := ReturnScoreRecordToMoveIdToId.LowOverlap;
    PTJobToSched(ResourcesStruct.m_SchedList[SchedBetweenJobsIdIndex]).HighOverlap := ReturnScoreRecordToMoveIdToId.HighOverlap;
    PTJobToSched(ResourcesStruct.m_SchedList[SchedBetweenJobsIdIndex]).score := ReturnScoreRecordToMoveIdToId.Score;
    PTJobToSched(ResourcesStruct.m_SchedList[SchedBetweenJobsIdIndex]).ScoreJobToJob := ReturnScoreRecordToMoveIdToId.ScoreJobToJob;
    PTJobToSched(ResourcesStruct.m_SchedList[SchedBetweenJobsIdIndex]).ScoreJobToRes := ReturnScoreRecordToMoveIdToId.ScoreJobToRes;
    PTJobToSched(ResourcesStruct.m_SchedList[SchedBetweenJobsIdIndex]).CompValJobToJob := ReturnScoreRecordToMoveIdToId.CompValJobToJob;
    PTJobToSched(ResourcesStruct.m_SchedList[SchedBetweenJobsIdIndex]).Duration := ReturnScoreRecordToMoveIdToId.Duration;
    PTJobToSched(ResourcesStruct.m_SchedList[SchedBetweenJobsIdIndex]).DurationOrg := ReturnScoreRecordToMoveIdToId.DurationOrg;
    PTJobToSched(ResourcesStruct.m_SchedList[SchedBetweenJobsIdIndex]).Setup := ReturnScoreRecordToMoveIdToId.Setup;
    PTJobToSched(ResourcesStruct.m_SchedList[SchedBetweenJobsIdIndex]).SetUpNoMaterial := ReturnScoreRecordToMoveIdToId.SetupNoMaterial;
    AfterSchedUpdated(ResourcesStruct.m_CurveByFamilyInfo, PTJobToSched(ResourcesStruct.m_SchedList[SchedBetweenJobsIdIndex]));
    if not BetweenSchedDoneAfter then
      ResourcesStruct.AddIdToList(Id, ReturnScoreRecordIdToPrevId, SchedBetweenJobsIdIndex, true, false);
    IdxToSched := SchedBetweenJobsIdIndex;
    FillLogListLine('BTWSelected',Id, true, @ReturnScoreRecordIdToPrevId, ReturnScoreRecordIdToPrevId.CompValJobToRes , ReturnScoreRecordIdToPrevId.Score, 0);
    exit;
  end;

  if result then
  begin
    BestScoreResource.TempScoreAndScheduleAndPushAllJobsFromPosition(Id, ScoreList, BestScoreIndex,
      Result, NewScore, ScoreAfterLastJob, ScoreAfterLastFound, MainIdLimitStart, ValPrev, ValNext, BestScoreResourceIndex, true,
      ServingGroupCode, ServingCodeLowestDateTime, ServingCodeHighestDateTime,
      ServingCodeLowestPlusTollerance, PlantCode,
      StrToFloat(ListStrSupMinBase.Strings[BestScoreResourceIndex]),
      StrToFloat(ListStrDuration.Strings[BestScoreResourceIndex]),
      StrToFloat(ListStrDurationOrg.Strings[BestScoreResourceIndex]),
      DurationQuantityBase, StrToInt(ListStrCmpToRes.Strings[BestScoreResourceIndex]))
  end
  else
  begin
    if ScoreAfterLastFound then
      FillLogListLine('ENDSelected',Id, true, @ScoreAfterLastJob, ScoreAfterLastJob.CompValJobToRes , ScoreAfterLastJob.Score, 0);
  end;

  for I := 0 to ScoreList.Count - 1 do
    dispose(PTScoreRecord(ScoreList[I]));
  ScoreList.free;

end;

//----------------------------------------------------------------------------//

procedure TResourcesManager.CleanMaterialAddRessList(var MatAddResList : TList);
type
 TConsumptions = record
   WorkCenter  : String;
   CalendarCode : String;
   ResCode : String;
   SupMinBase : double;
   SetupNeedMat : double;
   Duration : double;
   MatList : Tlist;
   AddResList, AddResPointerList : Tlist;
   ManPowerList, ManPowerPointerList : Tlist;
 end;
 PTConsumptions = ^TConsumptions;
type
  TNotAvailType = record
    ToPos : integer;
    Nature : ArProdNature;
    AddResStart : ArResTime;
    AddResEnd : ArResTime;
    HoursToDownFromMachine : integer;
    Index : integer;
  end;
  PTNotAvailType = ^TNotAvailType;
var
  I, IdxCons : Integer;
  PConsumptions : PTConsumptions;
begin
  for IdxCons := 0 to MatAddResList.Count - 1 do
  begin
    PConsumptions := PTConsumptions(MatAddResList[IdxCons]);

    for I := PConsumptions.MatList.Count - 1 downto 0 do
      dispose(PTRecNoMatDate(PConsumptions.MatList[I]));
    PConsumptions.MatList.free;

    for I := PConsumptions.AddResList.Count - 1 downto 0 do
      dispose(PTRecNoMatDate(PConsumptions.AddResList[I]));
    PConsumptions.AddResList.free;

    for I := PConsumptions.AddResPointerList.Count - 1 downto 0 do
      dispose(PTNotAvailType(PConsumptions.AddResPointerList[I]));
    PConsumptions.AddResPointerList.free;

    for I := PConsumptions.ManPowerList.Count - 1 downto 0 do
      dispose(PTRecNoMatDate(PConsumptions.ManPowerList[I]));
    PConsumptions.ManPowerList.free;

    for I := PConsumptions.ManPowerPointerList.Count - 1 downto 0 do
      dispose(PTNotAvailType(PConsumptions.ManPowerPointerList[I]));
    PConsumptions.ManPowerPointerList.free;

    Dispose(PConsumptions);

  end;

  MatAddResList.Clear;

end;

//----------------------------------------------------------------------------//

procedure TResourcesManager.CleanBacupListId;
var
  I, J : Integer;
  JobToSched : PTJobInfo;
begin
  for I := m_ListBackupIdInfo.Count - 1 downto 0 do
  begin
    JobToSched := PTJobInfo(m_ListBackupIdInfo[I]);
    if JobToSched.Valid then
    begin
      for J := JobToSched.List_SetupCompactParams.Count - 1 downto 0 do
        dispose(PTSetupCompactInfo(JobToSched.List_SetupCompactParams[J]));
      JobToSched.List_SetupCompactParams.Free;
    end;
    dispose(JobToSched);
  end;
  m_ListBackupIdInfo.Clear;
end;

//----------------------------------------------------------------------------//

procedure TResourcesManager.CleanRequestIdList;
var
  I : Integer;
begin
  for I := m_ListOfRequestAndId.Count - 1 downto 0 do
    dispose(PTRequestId(m_ListOfRequestAndId[I]));
  m_ListOfRequestAndId.Clear;
end;

//----------------------------------------------------------------------------//

procedure TResourcesManager.CleanRequestStepsToReLoadResourcesList;
var
  I : Integer;
begin
  for I := m_ListOfRequestStepsToReLoadResources.Count - 1 downto 0 do
    dispose(PTRequestStepsToReLoadResources(m_ListOfRequestStepsToReLoadResources[I]));
  m_ListOfRequestStepsToReLoadResources.Clear;
end;

//----------------------------------------------------------------------------//

procedure TResourcesManager.CleanAllMemory;
var
  I : Integer;
begin
  for I := m_AllResList.Count - 1 downto 0 do
    TResourcesStruct(m_AllResList[I]).Free;
  m_ListBackupIdInfo.Free;
  CleanRequestStepsToReLoadResourcesList;
  m_ListOfRequestStepsToReLoadResources.free;
  m_ListOfRequestAndId.Free;
end;

//----------------------------------------------------------------------------//

procedure TResourcesManager.AddRequestStepToReLoadResourcesList(Id : TSchedId; ReCheckResources, ReLoadResources : boolean; Index : integer);
var
  step : variant;
  Request : string;
  dataType: CBinColValType;
  RequestStepsToReLoadResources : PTRequestStepsToReLoadResources;
begin
  //p_sc.GetFldValue(Id , CSC_ProdReq, Request, dataType);
  Request := p_sc.GetRequestNumber(Id);
  p_sc.GetFldValue(Id , CSC_ProdStep, step, dataType);
  new(RequestStepsToReLoadResources);
  RequestStepsToReLoadResources.Request := Request;
  RequestStepsToReLoadResources.Step := Step;
  RequestStepsToReLoadResources.ReCheckResources := ReCheckResources;
  RequestStepsToReLoadResources.ReLoadResources  := ReLoadResources;
  m_ListOfRequestStepsToReLoadResources.insert(Index, RequestStepsToReLoadResources);
end;

//----------------------------------------------------------------------------//

procedure TResourcesManager.RemoveRequestStepToReLoadResourcesList(Index : integer);
begin
  dispose(PTRequestStepsToReLoadResources(m_ListOfRequestStepsToReLoadResources[Index]));
  m_ListOfRequestStepsToReLoadResources.Delete(Index);
end;

//----------------------------------------------------------------------------//

constructor TResourcesManager.Create(ResList : TList; CfgName : string; MainListIDInfo : TList);
begin
  inherited create;
  m_AllResList       := TList.Create;
  m_AllResListByTyp  := TList.Create;
  m_MainListIDInfo   := MainListIDInfo;
//  m_MainIdResList    := TList.Create;
//  m_TempIdResList    := TList.Create;
  m_ListBackupIdInfo := TList.Create;
  m_ListOfRequestAndId := TList.Create;
  m_ListOfRequestStepsToReLoadResources := TList.Create;
  m_CfgName          := CfgName;
  IniResStruct(ResList);
end;

//----------------------------------------------------------------------------//

destructor TResourcesManager.Destroy;
var
  I : Integer;
begin
  for I := m_AllResList.Count - 1 downto 0 do
    TResourcesStruct(m_AllResList[I]).Free;
  m_AllResList.free;
  m_AllResListByTyp.Free;
  m_MainListIDInfo.Free;
  inherited destroy;
end;

//----------------------------------------------------------------------------//

procedure TResourcesManager.IniResStruct(ResList : TList);
var
  I, iVisRes : Integer;
  ResourcesStruct : TResourcesStruct;
  Res : TMqmRes;
  Vis_Res : TMqmVisibleRes;
  VisRes : TList;
begin
  if AutoSchedCfg.m_McmRescheduledJobs then
  begin
    VisRes := TList.Create;
    for I := 0 to p_pl.p_Rescount - 1 do
    begin
      Res := TMqmRes(p_pl.p_ResList[I]);
      for iVisRes := 0 to res.p_VisResCount -1 do
        VisRes.add(TMqmVisibleRes(res.p_VisRes[iVisRes]));
    end;
    for I := 0 to VisRes.Count - 1 do
      AddResource(VisRes[I]);
    VisRes.Free;
  end
  else
  begin
    VisRes := TList.Create;

    for I := 0 to ResList.Count - 1 do
    begin
      Vis_Res := TMqmVisibleRes(ResList[I]);
      res := TMqmRes(Vis_Res.p_Father);
      for iVisRes := 0 to Res.p_VisResCount -1 do
        VisRes.add(TMqmVisibleRes(res.p_VisRes[iVisRes]));
    end;

    for I := 0 to VisRes.Count - 1 do
      AddResource(VisRes[I]);

    VisRes.Free;
  end;

  m_AllResList.sort(SortByResCode);

  if DBAppGlobals.MCM_App then
  begin
    m_AllResListByTyp.Clear;
    for I := 0 to m_AllResList.Count - 1 do
    begin
      if (TResourcesStruct(m_AllResList[I]).m_PlanType = RPT_InfiniteCapacity) then
      begin
       // if (AutoSchedCfg.m_OverridingParams_Activated and AutoSchedCfg.m_OverridingParams_InfiniteCapacityAllowed)
        if AutoSchedCfg.m_OverridingParams_InfiniteCapacityAllowed
        or AutoSchedCfg.m_McmRescheduledJobs then
          m_AllResListByTyp.Add(m_AllResList[I]);
      end
      else
        m_AllResListByTyp.Add(m_AllResList[I]);
    end;
    m_AllResListByTyp.sort(SortByPlanTypeAndCode);
  end;
end;

//----------------------------------------------------------------------------//

procedure TResourcesManager.SetTotalScore(TotalScore : double);
begin
  m_TotalScore := TotalScore;
end;

//----------------------------------------------------------------------------//

function TResourcesManager.RemoveIdFromList(Id : TSchedID; ResourceIndex : integer;
            WriteToRollBack : boolean; var UnschedWithError : boolean) : boolean;
var
  I, J : Integer;
  JobIdFromBackup : PTJobInfo;
  ResourcesStruct, ResourcesStructTemp : TResourcesStruct;
  GenericPlanInfo : TSQplanInfo;
  PrevId, NextId, NextNextId : TSchedID;
  PlanInfo : TSQplanInfo;
  supMinBase, Setup, Overlap, exeMin, PrevScore, Score, DurationNextOrg : double;
  CompValJobToJob, PrevCompValJobToJob, PrevCompValJobToRes : TCompatVal;
  GenericPlanDur, GenericPlanleadTime : double;
  GenericPlanWc, ServingGroupCode : String;
  PrevIdEndDate, StartDate, Enddate, ServingCodeLowestDateTime, ServingCodeHighestDateTime, NextNextIdStartDate, NewStartDate : TDateTime;
  LimitStartDate, DummyDateTime : TDateTime;
  RecalcDur, RollBackWritten : boolean;
  ScoreRecord, ScoreRecordTemp : TScoreRecord;
  RollBackInfo : PTJobToSched;
  MatAddResList, GenericPlanDates : Tlist;
  ValPrev, ValNext : variant;
  ListStrRes, ListStrCmpToRes, ListStrSupMinBase, ListStrDuration, ListStrDurationOrg,
  ListStrStandBatchSize , ListStrMinBatchSize, ListStrMaxBatchSize : TStringList;
  DurationQuantityBase : double;
  Position : integer;

begin
  Result := false;
  UnschedWithError := false;
  PrevId := CSchedIDnull;
  NextID := CSchedIDnull;
  NextNextID := CSchedIDnull;

  JobIdFromBackup := FindIdInBackUpList(id, m_ListBackupIdInfo);
  if JobIdFromBackup <> nil then
  begin
    Result := true;

    ResourcesStruct := TResourcesStruct(JobIdFromBackup.ResourcesStruct);

    I := ResourceIndex;
    if (ResourceIndex < 0) then
    begin
      for I := 0 to ResourcesStruct.m_SchedList.Count - 1 do
        if (PTJobToSched(ResourcesStruct.m_SchedList[I]).Id = Id) then break;
    end;

    if (I >= 0) and (I < ResourcesStruct.m_SchedList.Count) then
    begin
      if (I > 0) then
      begin
        PrevId := PTJobToSched(ResourcesStruct.m_SchedList[I-1]).Id;
        PrevIdEndDate := PTJobToSched(ResourcesStruct.m_SchedList[I-1]).EndSched;
      end
      else
        PrevIdEndDate := 0;
      if ((I + 1) < ResourcesStruct.m_SchedList.Count) then
      begin
        NextId := PTJobToSched(ResourcesStruct.m_SchedList[I+1]).Id;
        DurationNextOrg := PTJobToSched(ResourcesStruct.m_SchedList[I+1]).DurationOrg;
        PrevCompValJobToJob := PTJobToSched(ResourcesStruct.m_SchedList[I+1]).CompValJobToJob;
        PrevCompValJobToRes := PTJobToSched(ResourcesStruct.m_SchedList[I+1]).CompValJobToRes;
        PrevScore := PTJobToSched(ResourcesStruct.m_SchedList[I+1]).score;
      end;
      if ((I + 2) < ResourcesStruct.m_SchedList.Count) then
      begin
        NextNextId := PTJobToSched(ResourcesStruct.m_SchedList[I+2]).Id;
        NextNextIdStartDate := PTJobToSched(ResourcesStruct.m_SchedList[I+2]).StartSched;
      end;
      BeforeDeletedFromSched(ResourcesStruct.m_CurveByFamilyInfo, PTJobToSched(ResourcesStruct.m_SchedList[I]).Id);
      dispose(PTJobToSched(ResourcesStruct.m_SchedList[I]));
      ResourcesStruct.m_SchedList.Delete(I);
    end;

    if (JobIdFromBackup.ResCode <> '') and not JobIdFromBackup.UnscheduledFromActArea then
      JobIdFromBackup.UnscheduledFromActArea := true;
    p_pl.UpdatePlanLinkJob('', Id, nil);

    p_sc.GetJobInfo(id,GenericplanInfo);

    if GenericPlanInfo.GenericPlanWC <> '' then
    begin
       UMGenericSchedulePrevStep.UnScheduleGenericPlan(Id);
       GenericPlanInfo.GenericPlanWC := '';
       p_sc.SetGenericInfo(Id, GenericPlanInfo);
    end;
    JobIdFromBackup.ResourcesStruct := nil;
  end;

  if NextId = CSchedIDnull then exit;

  p_sc.GetPlanInfo(NextId, PlanInfo);

  supMinBase := PlanInfo.supMinBase;
  CheckSetupCompactParam(NextId, PrevId, ResourcesStruct.m_ResCode, ResourcesStruct.m_ActArea, CompValJobToJob,
      supMinBase, Setup, Overlap, GenericPlanWc, GenericPlanDur, GenericPlanleadTime, RecalcDur);

  if (CompValJobToJob > AutoSchedCfg.m_MaxJobJobComp)
  or (CompValJobToJob < AutoSchedCfg.m_MinJobJobComp) then
    UnschedWithError := true;

  if RecalcDur then
     exeMin := DurationNextOrg + GetCurveTime(ResourcesStruct.m_ActArea, DummyDateTime, NextId, DurationNextOrg, false, 0)
     // There can not be setup curve and family handling on the same time - no need to take totals
  else
     exeMin := planInfo.exeMin;

  p_sc.GetServingGroupLowestHighiestDates(NextId, ServingGroupCode, ServingCodeLowestDateTime, ServingCodeHighestDateTime);

  if (Setup = PlanInfo.supMinReal) and (Overlap = PlanInfo.supMinOvlp) and (exeMin = planInfo.exeMin) and (CompValJobToJob = PrevCompValJobToJob) then
    exit;

  StartDate := PlanInfo.startDate;
  EndDate := PlanInfo.endDate;

  if (setup + exeMin) < (PlanInfo.supMinReal + PlanInfo.exeMin) then
    LimitStartDate := PlanInfo.startDate;
  if (setup + exeMin) > (PlanInfo.supMinReal + PlanInfo.exeMin) then
    ResourcesStruct.m_cal.OfsByWH(-(setup + exeMin)/60, false, EndDate, LimitStartDate, ResourcesStruct.m_ActArea.m_CrossDownTmList);
  MatAddResList := TList.Create;
  GenericPlanDates := TList.Create;
  ValPrev := p_sc.GetPrvHighestDate(NextId);
  ValNext := p_sc.GetNextHighiestEndDate(NextId);

  ResourcesStructTemp := nil;
  ListStrRes := GetInformationById(NextId, ListStrCmpToRes, ListStrSupMinBase, ListStrDuration, ListStrDurationOrg,
                  ListStrStandBatchSize , ListStrMinBatchSize, ListStrMaxBatchSize, Position, DurationQuantityBase);
  if ListStrRes <> nil then
  begin
    for J := 0 to ListStrRes.Count - 1 do   // Find the batch size of the specific resource
    begin
      ResourcesStructTemp := FindResourceByCode(ListStrRes.Strings[J], m_AllResList);
      if ResourcesStructTemp = nil then Continue;
      if ResourcesStructTemp.m_ResCode = ResourcesStruct.m_ResCode then break;
    end;
  end;

  if ResourcesStructTemp = nil then
    UnschedWithError := true;

  if not ResourcesStruct.CheckScoreAfterJob(PrevId, NextId , false, LimitStartDate, 0, EndDate, 0,
            PrevIdEndDate ,ScoreRecordTemp ,GenericPlanDates, ValPrev, ValNext,
            MatAddResList, false, false, StrToFloat(ListStrSupMinBase.Strings[J]),
            StrToFloat(ListStrDuration.Strings[J]), StrToFloat(ListStrDurationOrg.Strings[J]), DurationQuantityBase) then
    UnschedWithError := true;
  CleanMaterialAddRessList(MatAddResList);
  MatAddResList.Free;
  CleanGenericPlanDates(GenericPlanDates);
  GenericPlanDates.Free;
  if not UnschedWithError then
  begin
    StartDate := ScoreRecordTemp.StartDateTime;
    EndDate := ScoreRecordTemp.EndDateTime;
  end;

  if (PrevId <> CSchedIDnull) and (StartDate <  PrevIdEndDate) then
    UnschedWithError := true;
  if (PlanInfo.GenericPlanWC = '') and (GenericPlanWc <> '') then
    UnschedWithError := true;
  if (NextNextId <> CSchedIDnull) and (EndDate > NextNextIdStartDate) then
    UnschedWithError := true;

  ScoreRecord.prevId := PrevId;
  ScoreRecord.Score := 0;
  ScoreRecord.StartDateTime := startDate;
  ScoreRecord.Gap := 0;
  ScoreRecord.Resource := ResourcesStruct;
  ScoreRecord.EndDateTime := endDate;
  ScoreRecord.supMinBase := supMinBase;
  ScoreRecord.Setup := Setup;
  ScoreRecord.SetupNoMaterial := Overlap;
  ScoreRecord.Duration := exeMin;
  ScoreRecord.GenericPlanWc := GenericPlanWC;
  ScoreRecord.GenericPlanleadTime := GenericPlanLeadTime;
  ScoreRecord.GenericPlanDuration := GenericPlanDur;
  ScoreRecord.CompValJobToJob:= CompValJobToJob;

  Score := ResourcesStruct.CalcScore(TMqmRes(TMQMVisibleRes(ResourcesStruct.m_ResPtr).p_Father), NextId, PrevId,
                     @ScoreRecord , 999999, PrevCompValJobToRes,
                     ServingGroupCode, ServingCodeLowestDateTime, ServingCodeHighestDateTime);


  if (PlanInfo.GenericPlanWC <> '') and (GenericPlanWc = '') then
  begin

    if WriteToRollBack then
    begin
      new(RollBackInfo);
      RollBackInfo^ := PTJobToSched(ResourcesStruct.m_SchedList[I])^;
      RollBackInfo.SchedType := RemoveGenericPlan;
      RollBackInfo.PosInList := I;
      RollBackInfo.ResourceManagerPtr := self;
      RollBackInfo.ResourcesStruct := ResourcesStruct;
      RollBackInfo.ReScheduleAtSpecificPlace := false;
      m_rollbackInfoList.Add(RollBackInfo);
    end;

    UMGenericSchedulePrevStep.UnScheduleGenericPlan(NextId);
    PlanInfo.GenericPlanWC := '';
    p_sc.SetGenericInfo(NextId, PlanInfo);
    PTJobToSched(ResourcesStruct.m_SchedList[I]).GenericPlanWC  := '';
  end;

  RollBackWritten := false;
  if (PlanInfo.startDate <> StartDate)
  or (PlanInfo.endDate <> EndDate)
  or (PlanInfo.supMinReal <> Setup)
  or (PlanInfo.supMinOvlp <> Overlap)
  or (PlanInfo.exeMin <> exeMin) then
  begin
    if WriteToRollBack then
    begin
      RollBackWritten := true;
      new(RollBackInfo);
      RollBackInfo^ := PTJobToSched(ResourcesStruct.m_SchedList[I])^;
      RollBackInfo.SchedType := update;
      RollBackInfo.PosInList   := I;
      RollBackInfo.ResourceManagerPtr := self;
      RollBackInfo.ResourcesStruct := ResourcesStruct;
      RollBackInfo.ReScheduleAtSpecificPlace := false;
      m_rollbackInfoList.Add(RollBackInfo);
    end;

    JobIdFromBackup := FindIdInBackUpList(NextId, m_ListBackupIdInfo);
    if (JobIdFromBackup.ResCode <> '') and not JobIdFromBackup.UnscheduledFromActArea then
       JobIdFromBackup.UnscheduledFromActArea := true;
    p_pl.UpdatePlanLinkJob('', NextId, nil);
    PlanInfo.startDate := StartDate;
    PlanInfo.EndDate := EndDate;
    PlanInfo.supMinReal := Setup;
    PlanInfo.supMinOvlp := Overlap;
    PlanInfo.exeMin := exeMin;
    ResourcesStruct.SetPlanInfo(NextId, PlanInfo);
    p_pl.UpdatePlanLinkJob(ResourcesStruct.m_ResCode, NextId, nil);
    p_sc.UpdateBalance(NextId);
  end;

  if (PTJobToSched(ResourcesStruct.m_SchedList[I]).score <> Score)
  or (PTJobToSched(ResourcesStruct.m_SchedList[I]).ScoreJobToJob <> ScoreRecord.ScoreJobToJob)
  or (PTJobToSched(ResourcesStruct.m_SchedList[I]).ScoreJobToRes <> ScoreRecord.ScoreJobToRes)
  or (PTJobToSched(ResourcesStruct.m_SchedList[I]).CompValJobToJob <> ScoreRecord.CompValJobToJob)
  or (PTJobToSched(ResourcesStruct.m_SchedList[I]).DurationOrg <> DurationNextOrg) then
  begin
    if WriteToRollBack and not RollBackWritten then
    begin
      new(RollBackInfo);
      RollBackInfo^ := PTJobToSched(ResourcesStruct.m_SchedList[I])^;
      RollBackInfo.SchedType := MinorUpdate;
      RollBackInfo.PosInList   := I;
      RollBackInfo.ResourceManagerPtr := self;
      RollBackInfo.ResourcesStruct := ResourcesStruct;
      RollBackInfo.ReScheduleAtSpecificPlace := false;
      m_rollbackInfoList.Add(RollBackInfo);
    end;
  end;

  PTJobToSched(ResourcesStruct.m_SchedList[I]).StartSched := StartDate;
  PTJobToSched(ResourcesStruct.m_SchedList[I]).EndSched := EndDate;
  PTJobToSched(ResourcesStruct.m_SchedList[I]).score := Score;
  PTJobToSched(ResourcesStruct.m_SchedList[I]).ScoreJobToJob := ScoreRecord.ScoreJobToJob;
  PTJobToSched(ResourcesStruct.m_SchedList[I]).ScoreJobToRes := ScoreRecord.ScoreJobToRes;
  PTJobToSched(ResourcesStruct.m_SchedList[I]).CompValJobToJob := ScoreRecord.CompValJobToJob;
  PTJobToSched(ResourcesStruct.m_SchedList[I]).Setup := Setup;
  PTJobToSched(ResourcesStruct.m_SchedList[I]).SetUpNoMaterial := Overlap;
  PTJobToSched(ResourcesStruct.m_SchedList[I]).Duration := exeMin;
  PTJobToSched(ResourcesStruct.m_SchedList[I]).DurationOrg := DurationNextOrg;
  AfterSchedUpdated(ResourcesStruct.m_CurveByFamilyInfo, PTJobToSched(ResourcesStruct.m_SchedList[I]));

end;

//----------------------------------------------------------------------------//

function SortDescendingDate(Item1, Item2: Pointer): integer;
type
 TIds = record
   id         : TSchedId;
   StartSched : TDateTime;
   EndSched   : TDateTime;
   WorkCenter : String;
   Level : integer;
 end;
 PTIds = ^TIds;
var
  PIds1, PIds2 : PTIds;
begin
  PIds1 := PTIds(Item1);
  PIds2 := PTIds(Item2);
  Result := 0;

  if PIds1.EndSched < PIds2.EndSched then
  begin
    Result := 1;
    Exit;
  end;
  if PIds1.EndSched > PIds2.EndSched then
  begin
    Result := -1;
    Exit;
  end;

  if PIds1.StartSched < PIds2.StartSched then
  begin
    Result := 1;
    Exit;
  end;
  if PIds1.StartSched > PIds2.StartSched then
  begin
    Result := -1;
    Exit;
  end;

  if PIds1.id < PIds2.id then
  begin
    Result := 1;
    Exit;
  end;
  if PIds1.id > PIds2.id then
  begin
    Result := -1;
    Exit;
  end;

end;

//----------------------------------------------------------------------------//

function TResourcesManager.TryToPushJobsToTheirTargetDate() : double;
type
 TIds = record
   id         : TSchedId;
   StartSched : TDateTime;
   EndSched   : TDateTime;
   WorkCenter : String;
   Level : integer;
 //  Score      : double;  // ORTA-48   // Commented by Eran 19032019 - EP190319
 end;
 PTIds = ^TIds;
var
  ResourcesStruct, PrevResourcesStruct : TResourcesStruct;
  I, J : Integer;
  Id, PrevId, NextId : TSchedId;
  PJobToSched, RollBackInfo : PTJobToSched;
  PIds : PTIds;
  HighestPrevEndFound, OldStartDate, OldEndDate, SlotStart, SlotEnd, OldLowOverlap, OldHighOverlap : TDateTime;
  GenericPlanDates : Tlist;
  PlanInfo : TSQplanInfo;
  ScoreRecord, ReturnScoreRecordIdToPrevId : TScoreRecord;
  dataType: CBinColValType;
  ValPrev, ValNext, QtyVal : variant;
  OldScore, NewScore : double;
  MainList : TList;
  TempJobToSched : Tlist;
  ScoreAfterLastFound, ScoreBeforeLastFound, IdFound : boolean;
  JobsMoved {, FirstCycle }: boolean;
  IdDetails : PTIdDetails;
  PlanedWorkCenter, PrevPlannedWorkCenter : variant;
  JobIdFromList, JobNextIdFromList : PTJobInfo;
  LeftGreenLine, RightGreenLine : variant;
  ApprovalDate : TDateTime;
  StatusAfterJobRemovedOk : boolean;
  NextIdCompValJobToRes : TCompatVal;
  NextIdSetup, NextIdOverlap, NextIdScore, Setup, Overlap, Score : double;
  NextIdIndex : integer;
  DummyCompatVal : TCompatVal;
  NumberOfCycles : integer;
  UnschedWithError, PositionIsBetter : boolean;
  NumberOfMovedJobs : integer;
  PrevSubProg, SubProg, NumOfAllJobs, IdxToSched  : Integer;
begin
  Result := 0;
  PrevSubProg := 101;

  GenericPlanDates := Tlist.Create;
  TempJobToSched := TList.Create;
  CleanRollbackInfoList(0);

  if DBAppGlobals.MCM_App then
    MainList := m_AllResListByTyp
  else
    MainList := m_AllResList;

  for I := 0 to MainList.Count - 1 do
  begin
    ResourcesStruct := TResourcesStruct(MainList[i]);
    J := ResourcesStruct.m_SchedList.Count;
    while True do
    begin
      if J = 0 then break;
      J := J - 1;
      PJobToSched := PTJobToSched(ResourcesStruct.m_SchedList[J]);
      if PJobToSched.FromGantt then continue;
      if AutoSchedCfg.m_OverridingParams_Activated and AutoSchedCfg.m_OverridingParams_AllowedMoveLinkedReq then
      begin
        IdDetails := FindInfoIdInMainList(PJobToSched.Id, m_MainListIDInfo);
        if (IdDetails = nil) or (IdDetails.level = 0) then continue;
      end;
      new(PIds);
      PIds.id := PJobToSched.Id;
      PIds.StartSched := PJobToSched.StartSched;
      PIds.EndSched := PJobToSched.EndSched;
      PIds.WorkCenter := TMqmWrkCtr(TMqmRes(TMQMVisibleRes(ResourcesStruct.m_ResPtr).p_Father).p_WrkCtr).p_WrkCtrCode;
      if AutoSchedCfg.m_OverridingParams_Activated and AutoSchedCfg.m_OverridingParams_AllowedMoveLinkedReq then
        PIds.Level := IdDetails.level;
      TempJobToSched.add(PIds);
    end;
  end;
  TempJobToSched.Sort(SortDescendingDate);

//  FirstCycle := true;
  JobsMoved := true;
  NumberOfCycles := 0;
  while JobsMoved and (NumberOfCycles < 15) do
  begin
    if Assigned(FAutoSched) and FAutoSched.m_OperatedAbort then
      break;
    inc(NumberOfCycles);
    JobsMoved := false;
    CleanRequestIdList;
    CleanAllInformationList(true);
    NumberOfMovedJobs := 0;
    NumOfAllJobs := 0;

    for I := 0 to TempJobToSched.Count - 1 do
    begin
      Application.ProcessMessages;
      Inc(NumOfAllJobs);
      if Assigned(FAutoSched) then
      begin
        if FAutoSched.m_OperatedAbort then
           break;
        SubProg := Trunc(NumOfAllJobs/TempJobToSched.Count*100);
        if PrevSubProg <> SubProg then
        begin
          PrevSubProg := SubProg;
          if (trunc(SubProg/5)*5 = SubProg) then
          begin
            FAutoSched.SetTryToImproveJobsPossition(SubProg, NumberOfCycles);
            SetElapsedTime(FAutoSched.SetElapsedTime);
          end;
        end;
      end;

      PIds := PTIds(TempJobToSched[I]);
      JobIdFromList := FindIdInBackUpList(PIds.Id, m_ListBackupIdInfo);
      if JobIdFromList = nil then continue;
      ResourcesStruct := JobIdFromList.ResourcesStruct;
      IdFound := false;
      for J := 0 to ResourcesStruct.m_SchedList.Count - 1 do
      begin
        Application.ProcessMessages;
        PJobToSched := PTJobToSched(ResourcesStruct.m_SchedList[J]);
        if PJobToSched.Id <> PIds.Id then continue;
        ResourcesStruct.CalcScoreToAnAlreadySchedJob(J, JobIdFromList.ServingGroupCode);
        OldScore := PTJobToSched(ResourcesStruct.m_SchedList[J]).score; // EP190319
        PrevId := CSchedIDnull;
        NextId := CSchedIDnull;
        if (J > 0) then
          PrevId := PTJobToSched(ResourcesStruct.m_SchedList[J-1]).id;
        if (J < (ResourcesStruct.m_SchedList.Count - 1)) then
        begin
          NextIdIndex := J + 1;
          NextId := PTJobToSched(ResourcesStruct.m_SchedList[NextIdIndex]).id;
          JobNextIdFromList := FindIdInBackUpList(NextId, m_ListBackupIdInfo);
          ResourcesStruct.CalcScoreToAnAlreadySchedJob(NextIdIndex, JobNextIdFromList.ServingGroupCode);
          NextIdCompValJobToRes := PTJobToSched(ResourcesStruct.m_SchedList[NextIdIndex]).CompValJobToRes;
          NextIdSetup := PTJobToSched(ResourcesStruct.m_SchedList[NextIdIndex]).Setup;
          NextIdOverlap := PTJobToSched(ResourcesStruct.m_SchedList[NextIdIndex]).SetUpNoMaterial;
          NextIdScore := PTJobToSched(ResourcesStruct.m_SchedList[NextIdIndex]).score;
          OldScore := OldScore + NextIdScore;  // EP190319
        end;
        IdFound := true;
        break;
      end;
      if not IdFound then continue;
      Id := PIds.Id;

      p_sc.GetFldValue(id, CSC_PlanWkctCode, PlanedWorkCenter, dataType);
      if AutoSchedCfg.m_ScheduleByWorkCenterCfg then
      begin
        if PlanedWorkCenter <> PrevPlannedWorkCenter then
        begin
          ChangeAutoSeqConfigurationByWorkCenter(Id, PIds.StartSched, SlotStart, SlotEnd);
          PrevPlannedWorkCenter := PlanedWorkCenter;
        end;
      end;
      if (AutoSchedCfg.m_PrefTgtDate = 2) and (not AutoSchedCfg.m_OverridingParams_Activated
      or not AutoSchedCfg.m_OverridingParams_AllowedMoveLinkedReq) then continue;
      if  AutoSchedCfg.m_OverridingParams_Activated
      and AutoSchedCfg.m_OverridingParams_AllowedMoveLinkedReq then
      begin
        AutoSchedCfg.m_PrevOrNextLinkedJobIsTheTgtDateWhenScheduled := true;
        AutoSchedCfg.m_OverridingParams_Wc_Selected := false;
        AutoSchedCfg.m_OverridingParams_ScheduleJobsWithinTheFram := false;
        if PIds.Level < 0 then
          AutoSchedCfg.m_PrefTgtDate := 1
        else
          AutoSchedCfg.m_PrefTgtDate := 2;
      end;

      AutoSchedCfg.m_PushToThePreferedDateMode := true;

      if AutoSchedCfg.m_McmRescheduledJobs then
      begin
        AutoSchedCfg.m_OverridingParams_Activated := true;
        AutoSchedCfg.m_OverridingParams_InfiniteCapacityAllowed := true;
        AutoSchedCfg.m_OverridingParams_Wc_Selected := true;
        AutoSchedCfg.m_OverridingParams_ScheduleJobsWithinTheFram := true;
        AutoSchedCfg.m_ScheduleByWorkCenterCfg := true;
        AutoSchedCfg.m_PrevOrNextLinkedJobIsTheTgtDateWhenScheduled := false;
        AutoSchedCfg.m_FindFirstFreeInifiniteCapacityResource := false;
        AutoSchedCfg.m_OverridingParams_Wc_Code_Selected := PIds.WorkCenter;
        GetCfgByWorkCenter(PlanedWorkCenter, PIds.StartSched, SlotStart, SlotEnd);
        AutoSchedCfg.m_OverridingParams_WcDateTimeFrom := SlotStart;
        AutoSchedCfg.m_OverridingParams_WcDateTimeTo := SlotEnd;
        if PIds.EndSched > SlotEnd then
          AutoSchedCfg.m_OverridingParams_ShorterJobsCanEndAfterFramEnd := true
        else
          AutoSchedCfg.m_OverridingParams_ShorterJobsCanEndAfterFramEnd := false;
        if PIds.StartSched > SlotStart then
          AutoSchedCfg.m_OverridingParams_LargerJobsCanStartAfterTheFrameBegins := true
        else
          AutoSchedCfg.m_OverridingParams_LargerJobsCanStartAfterTheFrameBegins := false;
        AutoSchedCfg.m_OverridingParams_Wc_Code_Selected := PIds.WorkCenter;
      end;

      p_sc.GetPlanInfo(Id, PJobToSched.OldPlanInfo);
      if not SetCompatibleRes(Id, '', ResourcesStruct.m_PlantCode, nil) then continue;
      new(RollBackInfo);
      RollBackInfo^ := PJobToSched^;
      RollBackInfo.SchedType := unschedule;
      RollBackInfo.ResourcesStruct := ResourcesStruct;
      RollBackInfo.ResourceManagerPtr := self;
      RollBackInfo.ReSchedulePlace := J;
      RollBackInfo.ReScheduleAtSpecificPlace := true;
      m_rollbackInfoList.Add(RollBackInfo);
//    OldScore := PJobToSched.score; ORTA-48
//      OldScore := PIds.Score; // ORTA-48  // Commented by EP190319
      OldStartDate := PJobToSched.StartSched;
      OldEndDate := PJobToSched.EndSched;
      OldLowOverlap := PJobToSched.LowOverlap;
      OldHighOverlap := PJobToSched.HighOverlap;
      RemoveIdFromList(Id, J, true, UnschedWithError);
      if (NextId <> CSchedIDnull) then  // EP190319
        OldScore := OldScore - PTJobToSched(ResourcesStruct.m_SchedList[J]).score; // We keep the same J for next Id because the tlist got shranked // EP190319

      ScoreAfterLastFound := FindBestScoreAfterLastJob(Id, false, ScoreRecord,
                             0, 0, GenericPlanDates, false, HighestPrevEndFound,
                             ResourcesStruct.m_PlantCode);
      ScoreBeforeLastFound := FindBestScoreBeforeLastJob(Id, ScoreRecord, 0, GenericPlanDates, NewScore,
                              ResourcesStruct.m_PlantCode, ScoreAfterLastFound, false,
                              false, IdxToSched, ReturnScoreRecordIdToPrevId, false);

      CleanGenericPlanDates(GenericPlanDates);
      if not ScoreBeforeLastFound and ScoreAfterLastFound then
      begin
        ScoreRecord.Resource.AddIdToList(Id , ScoreRecord, -1, true, false);
        NewScore := ScoreRecord.Score;
      end;

      if ScoreAfterLastFound or ScoreBeforeLastFound then
      begin
        StatusAfterJobRemovedOk := true;
        if (NextId <> CSchedIDnull) then
        begin
          if (not ScoreBeforeLastFound)     // If not Schedule in the exact same place as before
          or (NextIdIndex >= (ResourcesStruct.m_SchedList.Count))
          or (PTJobToSched(ResourcesStruct.m_SchedList[NextIdIndex]).id <> NextId) then
          begin
            if UnschedWithError then
              StatusAfterJobRemovedOk := false
            else
              StatusAfterJobRemovedOk := true;
          end;
        end;

        PositionIsBetter := false;
        PrevResourcesStruct := ResourcesStruct;

        if StatusAfterJobRemovedOk then
        begin

//          if FirstCycle then
//            PositionIsBetter := true
//          else
          if ((NewScore < OldScore) and (PrevResourcesStruct.m_PlanType = RPT_InfiniteCapacity)) then
            PositionIsBetter := true;

          if PositionIsBetter then
          begin
            CleanRollbackInfoList(0);
            JobsMoved := true;
 //           PIds.Score := NewScore;  // ORTA-48  commented by // EP190319
            NumberOfMovedJobs := NumberOfMovedJobs + 1;
            Continue;
          end;

          IdFound := false;
          JobIdFromList := FindIdInBackUpList(Id, m_ListBackupIdInfo);
          if JobIdFromList <> nil then
          begin
            ResourcesStruct := JobIdFromList.ResourcesStruct;
            for J := 0 to ResourcesStruct.m_SchedList.Count - 1 do
            begin
               PJobToSched := PTJobToSched(ResourcesStruct.m_SchedList[J]);
               if PJobToSched.Id <> Id then continue;
               IdFound := true;
               break;
            end;
          end;
        end;

        if StatusAfterJobRemovedOk and IdFound then
        begin
          LeftGreenLine := p_sc.GetLowStart(Id);
          RightGreenLine := p_sc.GetHighEnd(id);
          ApprovalDate := p_sc.GetApprovalDate(id);
          if IsPossitionBetter(PrevResourcesStruct.m_PlanType, ResourcesStruct.m_PlanType,
                               OldStartDate, PJobToSched.StartSched,
                               OldEndDate, PJobToSched.EndSched,
                               LeftGreenLine, RightGreenLine, ApprovalDate,
                               OldLowOverlap, PJobToSched.LowOverlap,
                               OldHighOverlap, PJobToSched.HighOverlap,
                               OldScore, NewScore,
                               false, true) > 0 then
          begin
            CleanRollbackInfoList(0);
            JobsMoved := true;
            NumberOfMovedJobs := NumberOfMovedJobs + 1;
            Continue;
          end;
        end;
      end;
      RollBackFromList(0);
      if ScoreAfterLastFound or ScoreBeforeLastFound then
        FillLogListLine('RollBack',Id, false, nil, DummyCompatVal , 0, 0);
    end;
//    FirstCycle := false;
  end;

  CleanGenericPlanDates(GenericPlanDates);
  GenericPlanDates.Free;
  for I := 0 to TempJobToSched.Count - 1 do
    dispose(PTIds(TempJobToSched[I]));
  TempJobToSched.Free;

end;

//----------------------------------------------------------------------------//

procedure TResourcesManager.JoinAllSubStep;
var
  I, J : Integer;
  ResourcesStruct : TResourcesStruct;
  IdToSched : PTJobToSched;
  MainList : TList;
begin

  if DBAppGlobals.MCM_App then
    MainList := m_AllResListByTyp
  else
    MainList := m_AllResList;

  for I := 0 to MainList.Count - 1 do
  begin
    ResourcesStruct := TResourcesStruct(MainList[i]);
    ResourcesStruct.JoinAllSubStep
  end;
end;

//----------------------------------------------------------------------------//

procedure TResourcesManager.CleanAndUnScheduleBeforeScheduleOnPlan;
var
  I : Integer;
  IdToSched       : PTJobInfo;
  planInfo, TempPlanInfo : TSQplanInfo;
begin
  for I := 0 to m_ListBackupIdInfo.Count - 1 do
  begin
    IdToSched := PTJobInfo(m_ListBackupIdInfo[i]);
    if not IdToSched.Valid then continue;
    if (IdToSched.ResCode <> '') and (not IdToSched.UnscheduledFromActArea) then continue;
    if not assigned(IdToSched.ResourcesStruct) then
    begin
      p_sc.CleanInstanceCounterProperty(I);
      continue;
    end;
    p_pl.UpdatePlanLinkJob('', I, nil);
    p_sc.GetPlanInfo(i,planInfo);
    if planInfo.GenericPlanWC <> '' then
      UMGenericSchedulePrevStep.UnScheduleGenericPlan(I);
    //p_sc.SetPlanInfo(IdToSched.Id, IdToSched.OldPlanInfo);

    TempPlanInfo := IdToSched.OldPlanInfo;
    TempPlanInfo.quant := planInfo.quant;
    TempPlanInfo.FinQuant := planInfo.FinQuant;
    TResourcesStruct(IdToSched.ResourcesStruct).SetPlanInfo(I, TempPlanInfo);

    if (IdToSched.ResCode <> '') then
    begin
      if IdToSched.OldPlanInfo.GenericPlanWC <> '' then
      begin
        ScheduleOnSpecificPosition(I , IdToSched.OldPlanInfo);
      end;
      //p_pl.UpdatePlanLinkJob(IdToSched.ResCode, IdToSched.Id, nil);
      p_pl.UpdatePlanLinkJobAutoSeq(TResourcesStruct(IdToSched.ResourcesStruct).m_ResPtr, I, nil);
      p_sc.UpdateBalance(I);
    end;
  end;
end;

//----------------------------------------------------------------------------//

function SortBackupListById(Item1, Item2: Pointer): integer;
var
  IdToSched1 : PTJobToSched;
  IdToSched2 : PTJobToSched;
begin
  IdToSched1 := PTJobToSched(Item1);
  IdToSched2 := PTJobToSched(Item2);
  if IdToSched1.Id < IdToSched2.Id then
    Result := -1
  else if (IdToSched1.Id = IdToSched2.Id) then
    Result := 0
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

procedure TResourcesManager.AddIdToBackupList(Id : TSchedId; ResCode : string; ResourcesStruct : TResourcesStruct);
var
  IdToSched : PTJobInfo;
  InsertPlace : Integer;
begin

  while id >= (m_ListBackupIdInfo.Count) do
  begin
    new(IdToSched);
    IdToSched.Valid := false;
    m_ListBackupIdInfo.Add(IdToSched);
  end;

  IdToSched := PTJobInfo(m_ListBackupIdInfo[Id]);
  if IdToSched.Valid then
    Exit;

  IdToSched.Valid := True;
  IdToSched.ResCode := ResCode;
  IdToSched.ResourcesStruct := ResourcesStruct;
  IdToSched.UnscheduledFromActArea := false;
  IdToSched.PropStrQty := -1;
  IdToSched.PropListId := 0;
  IdToSched.PropListLevel := 0;
  IdToSched.HasPropInstanceCountWithRule := false;
  IdToSched.List_SetupCompactParams := TList.Create;
  p_sc.GetPlanInfo(Id, IdToSched.OldPlanInfo);
  IdToSched.RequestNumber := p_sc.GetRequestNumber(Id);
  IdToSched.ServingGroupCode := p_sc.GetServingGroupCode(Id, false, nil);

end;

//----------------------------------------------------------------------------//

procedure TResourcesManager.MarkIdAsNotValidInBackupList(Id : TSchedId);
var
  IdToSched : PTJobInfo;
  I : Integer;
begin

  if Id >= (m_ListBackupIdInfo.Count) then
    Exit;

  IdToSched := PTJobInfo(m_ListBackupIdInfo[Id]);
  if not IdToSched.Valid then
    Exit;

  IdToSched.Valid := false;
  for I := 0 to IdToSched.List_SetupCompactParams.Count - 1 do
    dispose(PTJobInfo(IdToSched.List_SetupCompactParams[I]));
  IdToSched.List_SetupCompactParams.Free;

end;

//-----------------------------------------------------------------------------------------

function FindOrAddPropListSetup(Action : String; PropListId, PropListPrevId : integer;
   WorkCenterCode, CategoryCode, ResCode : String;
   var CompValJobToJob : TCompatVal; var supRec : TSetupRec) : boolean;
var
  PropListSetup : PTPropListSetup;
  I: integer;
  Multiplier, NumberOfEntries, LowestHighestValue : integer;
begin
  Result := false;

  NumberOfEntries := m_PropListSetup.Count;
  LowestHighestValue := NumberOfEntries;

  if NumberOfEntries > 0 then
  begin

    Multiplier := 1;
    while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    I := Multiplier - 1;

    while (Multiplier > 0) do
    begin
      Multiplier := trunc(Multiplier / 2);

      if (i >= NumberOfEntries) then
      begin
        i := i - Multiplier;
        Continue;
      end;

      if (PTPropListSetup(m_PropListSetup[I]).WorkCenterCode < WorkCenterCode) then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTPropListSetup(m_PropListSetup[I]).WorkCenterCode > WorkCenterCode) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if (PTPropListSetup(m_PropListSetup[I]).CategoryCode < CategoryCode) then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTPropListSetup(m_PropListSetup[I]).CategoryCode > CategoryCode) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if (PTPropListSetup(m_PropListSetup[I]).ResCode < ResCode) then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTPropListSetup(m_PropListSetup[I]).ResCode > ResCode) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if (PTPropListSetup(m_PropListSetup[I]).IdUniqueId < PropListId) then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTPropListSetup(m_PropListSetup[I]).IdUniqueId > PropListId) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if (PTPropListSetup(m_PropListSetup[I]).PrevIdUniqueId < PropListPrevId) then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTPropListSetup(m_PropListSetup[I]).PrevIdUniqueId > PropListPrevId) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      CompValJobToJob := PTPropListSetup(m_PropListSetup[I]).CompValJobToJob;
      supRec := PTPropListSetup(m_PropListSetup[I]).supRec;
      Result := true;
      Exit;

    end;
  end;

  if Action = '0' then Exit;

  new(PropListSetup);
  PropListSetup.WorkCenterCode := WorkCenterCode;
  PropListSetup.CategoryCode := CategoryCode;
  PropListSetup.ResCode := ResCode;
  PropListSetup.IdUniqueId := PropListId;
  PropListSetup.PrevIdUniqueId := PropListPrevId;
  PropListSetup.CompValJobToJob := CompValJobToJob;
  PropListSetup.supRec := supRec;
  m_PropListSetup.insert(LowestHighestValue, PropListSetup);

end;
//-----------------------------------------------------------------------------------------

function ReturnPropListId(PropList : String) : integer;
var
  PropListId : PTPropListId;
  I: integer;
  Multiplier, NumberOfEntries, LowestHighestValue : integer;
begin
  NumberOfEntries := m_PropListId.Count;
  LowestHighestValue := NumberOfEntries;

  if NumberOfEntries > 0 then
  begin

    Multiplier := 1;
    while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    I := Multiplier - 1;

    while (Multiplier > 0) do
    begin
      Multiplier := trunc(Multiplier / 2);
      if (i >= NumberOfEntries) then
      begin
        i := i - Multiplier;
        Continue;
      end;

      if PTPropListId(m_PropListId[I]).PropList = PropList then
      begin
        Result := PTPropListId(m_PropListId[I]).UniqueId;
        Exit;
      end;

      if PTPropListId(m_PropListId[I]).PropList < PropList then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if I < LowestHighestValue then LowestHighestValue := I;
      i := i - Multiplier;
    end;
  end;

  new(PropListId);
  PropListId.PropList := PropList;
  PropListId.UniqueId := NumberOfEntries + 1;
  Result := NumberOfEntries + 1;
  m_PropListId.insert(LowestHighestValue, PropListId);

end;

//----------------------------------------------------------------------------//

procedure TResourcesManager.CheckSetupCompactParam(Id : TSchedId; PrevId : TSchedId;
            ResCode : string; ActArea : TMqmActArea;
            var CompValJobToJob : TCompatVal;
            supMinBase : double; var setup : double; var SetupNoMaterial : double;
            var GenericPlanWc : string; var GenericPlanDuration : double; var GenericPlanleadTime : double; var RecalcDur : boolean);
var
  TempIdJobIdInfo : PTJobToSched;
  IdJobIdInfo : PTJobInfo;
  QtyVal : double;
  dataType: CBinColValType;
  PropertyList : String;
  IdUniqueId, PrevIdUniqueId, LevelId, LevelPrevId, Level, LowestLevel, I : Integer;
  WorkCenter, Category, Resource : String;
  supRec : TSetupRec;
  HasPropInstanceCounterWithRule : boolean;
  IdHasPropInstanceCounterWithRule , PrevIdHasPropInstanceCounterWithRule : boolean;
  IdPosInList, PrevIdPosInList, PosInList : Integer;
  ResourcesStructId, ResourcesStructPrevId, ResourcesStruct : TResourcesStruct;
  TempId : TSchedId;
begin
  PrevIdUniqueId := 0;
  IdPosInList := 0;
  PrevIdPosInList := 0;
  PrevIdHasPropInstanceCounterWithRule := false;
  ResourcesStructPrevId := nil;
  RecalcDur := false;

  IdJobIdInfo := FindIdInBackUpList(Id, m_ListBackupIdInfo);

 // p_sc.GetFldValue(id, CSC_QtyToSched, QtyVal, dataType);
  QtyVal := p_sc.GetJobQty(id);
  if (IdJobIdInfo.PropStrQty <> QtyVal) or IdJobIdInfo.HasPropInstanceCountWithRule then
  begin
    IdJobIdInfo.PropStrQty := QtyVal;
    PropertyList := TMqmRes(actArea.p_res).GetObjPropValString(id, LevelId, HasPropInstanceCounterWithRule);
    IdJobIdInfo.HasPropInstanceCountWithRule := HasPropInstanceCounterWithRule;
    IdJobIdInfo.PropListId := ReturnPropListId(PropertyList);
    IdJobIdInfo.PropListLevel := LevelId;
  end;
  IdUniqueId := IdJobIdInfo.PropListId;
  LevelId := IdJobIdInfo.PropListLevel;
  IdHasPropInstanceCounterWithRule := IdJobIdInfo.HasPropInstanceCountWithRule;
  ResourcesStructId := TResourcesStruct(IdJobIdInfo.ResourcesStruct);

  if PrevId <> CSchedIdNull then
  begin
    IdJobIdInfo := FindIdInBackUpList(PrevId, m_ListBackupIdInfo);
    //p_sc.GetFldValue(PrevId, CSC_QtyToSched, QtyVal, dataType);
    QtyVal := p_sc.GetJobQty(PrevId);
    if (IdJobIdInfo.PropStrQty <> QtyVal) or IdJobIdInfo.HasPropInstanceCountWithRule then
    begin
      IdJobIdInfo.PropStrQty := QtyVal;
      PropertyList := TMqmRes(actArea.p_res).GetObjPropValString(PrevId, LevelPrevId, HasPropInstanceCounterWithRule);
      IdJobIdInfo.HasPropInstanceCountWithRule := HasPropInstanceCounterWithRule;
      IdJobIdInfo.PropListId := ReturnPropListId(PropertyList);
      IdJobIdInfo.PropListLevel := LevelPrevId;
    end;
    PrevIdUniqueId := IdJobIdInfo.PropListId;
    LevelPrevId := IdJobIdInfo.PropListLevel;
    PrevIdHasPropInstanceCounterWithRule := IdJobIdInfo.HasPropInstanceCountWithRule;
    ResourcesStructPrevId := TResourcesStruct(IdJobIdInfo.ResourcesStruct);
  end;

  if (IdHasPropInstanceCounterWithRule or PrevIdHasPropInstanceCounterWithRule) and
     ((ResourcesStructId <> nil) or (ResourcesStructPrevId <> nil)) then
  begin
    if Assigned(ResourcesStructId) then
      IdPosInList := GetPosInList(ResourcesStructId.m_SchedList, Id);
    if Assigned(ResourcesStructPrevId) then
      PrevIdPosInList := GetPosInList(ResourcesStructPrevId.m_SchedList, PrevId);

    CompValJobToJob := 99;
    if (ResourcesStructId <> nil)
      and IdHasPropInstanceCounterWithRule
      and ((ResourcesStructId.m_SchedList.Count - 1) > IdPosInList) then exit;
    if (ResourcesStructPrevId <> nil)
      and (ResourcesStructId = nil)
      and PrevIdHasPropInstanceCounterWithRule
      and ((ResourcesStructPrevId.m_SchedList.Count - 1) > PrevIdPosInList) then exit;
    CompValJobToJob := 0;
    ResourcesStruct := ResourcesStructId;
    if ResourcesStruct = nil then ResourcesStruct := ResourcesStructPrevId;
    PosInList := PrevIdPosInList;
    if ResourcesStructPrevId = nil then PosInList := IdPosInList;
    while PosInList > 0 do
    begin
      TempIdJobIdInfo := PTJobToSched(ResourcesStruct.m_SchedList[PosInList]);
      if (TempIdJobIdInfo.PropStrQty > 0) then
      begin
        TempIdJobIdInfo.PropStrQty := QtyVal;
        PropertyList := TMqmRes(actArea.p_res).GetObjPropValString(TempIdJobIdInfo.Id, Level, HasPropInstanceCounterWithRule);
        TempIdJobIdInfo.HasPropInstanceCountWithRule := HasPropInstanceCounterWithRule;
        TempIdJobIdInfo.PropListId := ReturnPropListId(PropertyList);
        TempIdJobIdInfo.PropListLevel := Level;
      end;
      if not TempIdJobIdInfo.HasPropInstanceCountWithRule then break;
      PosInList := PosInList - 1;
    end;
    while true do
    begin
      if PosInList > (ResourcesStruct.m_SchedList.Count - 1) then break;
      TempId := CSchedIdNull;
      if PosInList > 0 then
      begin
        TempIdJobIdInfo := PTJobToSched(ResourcesStruct.m_SchedList[PosInList - 1]);
        TempId := TempIdJobIdInfo.Id;
      end;
      TempIdJobIdInfo := PTJobToSched(ResourcesStruct.m_SchedList[PosInList]);
      TMqmRes(ResourcesStruct.m_actArea.p_res).UpdateInstanceCounterProperty(TempIdJobIdInfo.Id , TempId);
      PosInList := PosInList + 1;
    end;
    if (ResourcesStructId = nil) then
      TMqmRes(ResourcesStruct.m_actArea.p_res).UpdateInstanceCounterProperty(Id , PrevId);
    if (ResourcesStructPrevId = nil) then
    begin
      TempIdJobIdInfo := PTJobToSched(ResourcesStruct.m_SchedList[IdPosInList - 1]);
    //  TempId := TempIdJobIdInfo.Id;
      TMqmRes(ResourcesStruct.m_actArea.p_res).UpdateInstanceCounterProperty(PrevId , TempIdJobIdInfo.Id);
      TMqmRes(ResourcesStruct.m_actArea.p_res).UpdateInstanceCounterProperty(Id , PrevId);
    end;
  end;

  if PrevId <> CSchedIdNull then
  begin
    LowestLevel := LevelId;
    if LowestLevel > LevelPrevId then LowestLevel := LevelPrevId;
    WorkCenter := '';
    Category := '';
    Resource := '';
    if LowestLevel > 0 then
    begin
      WorkCenter := TMqmWrkCtr(TMqmRes(actArea.p_res).p_WrkCtr).p_WrkCtrCode;
      Category := TMqmResCat(TMqmRes(actArea.p_res).p_ResCat).p_ResCatCode;
    end;
    if LowestLevel = 2 then Resource := ResCode;

    if FindOrAddPropListSetup('0', IdUniqueId, PrevIdUniqueId, WorkCenter, Category, Resource,
         CompValJobToJob, supRec) then
    begin
      CalcSetupFromPreparedData(supRec, supMinBase, Setup, SetupNoMaterial);
      GenericPlanWc := supRec.teoreticl_wc;
      GenericPlanDuration := supRec.duration;
      GenericPlanleadTime := suprec.LeadTime;
      Exit;
    end;
  end;

  if not CalcCompatabilityAndPrepareSetup(id, PrevId, actArea, CompValJobToJob, supRec) then
  begin
    Setup := supMinBase;
    SetupNoMaterial := 0;
    GenericPlanWc := '';
    GenericPlanDuration := 0;
    GenericPlanleadTime := 0;
    Exit;
  end;
  if (supRec.CurveCode <> '') and (p_sc.GetLearningCurveCode(id) = '') then
     RecalcDur := true;

  CalcSetupFromPreparedData(supRec, supMinBase, Setup, SetupNoMaterial);
  GenericPlanWc := supRec.teoreticl_wc;
  GenericPlanDuration := supRec.duration;
  GenericPlanleadTime := suprec.LeadTime;

  if PrevId <> CSchedIdNull then
    FindOrAddPropListSetup('1', IdUniqueId, PrevIdUniqueId, WorkCenter, Category, Resource,
      CompValJobToJob, SupRec);

end;

//----------------------------------------------------------------------------//

function TResourcesManager.GetCfgName: string;
begin
  Result := m_CfgName
end;

//----------------------------------------------------------------------------//

procedure TResourcesManager.StatisticCalculation;
var
  I, J : integer;
  ResourcesStruct : TResourcesStruct;
  IdToSched       : PTJobToSched;
  DatesInfo       : TSQDatesInfo;
  GapEndDateToTolleranceInHours, GapEndDateToHighestEnd : double;
  SetUpNoMaterial, Setup, supMinBase : double;
  MainList : TList;
begin
  m_TotalLateJobsAboveTollenrance      := 0;
  m_TotalHoursForLatestJobAboveTollenrance := 0;
  m_TotalLateHoursUpToTollenrance      := 0;
  m_TotalLateJobsUpToTollenrance       := 0;
  m_TotalSetupHoursStandard            := 0;
  m_TotalSetupHoursBeforeMaterials     := 0;
  m_TotalSetupHoursAfterMaterials      := 0;
  m_TotalHoursAboveStandard            := 0;
  m_NumberOfJobsWithSetupNoMaterials   := 0;
  m_NumberOfJobsWithSetupAboveStandard := 0;

  for I := low(m_arrayJobToJobCase) to High(m_arrayJobToJobCase) do
  begin
    m_arrayJobToJobCase[I] := 0;
    m_arrayJobToResCase[I] := 0;
  end;

  for I := low(m_ArrayDaysOfLatedJobs) to High(m_ArrayDaysOfLatedJobs) do
    m_ArrayDaysOfLatedJobs[I] := 0;

  if DBAppGlobals.MCM_App then
    MainList := m_AllResListByTyp
  else
    MainList := m_AllResList;

  for I := 0 to MainList.Count - 1 do
  begin
    ResourcesStruct := TResourcesStruct(MainList[I]);
    for J := 0 to ResourcesStruct.m_SchedList.Count - 1 do
    begin
      IdToSched := PTJobToSched(ResourcesStruct.m_SchedList[J]);
      if IdToSched.FromGantt then continue;

      SetUpNoMaterial := 0;
      Setup           := 0;
      supMinBase      := 0;
      try
        if IdToSched.SetUpNoMaterial > 1 then
          SetUpNoMaterial := IdToSched.SetUpNoMaterial / 60;
      except
      end;

      try
        if IdToSched.Setup > 1 then
          Setup := IdToSched.Setup / 60;
      except
      end;

      try
        if IdToSched.supMinBase > 1 then
          supMinBase := IdToSched.supMinBase / 60;
      except
      end;

      p_sc.GetDatesInfo(IdToSched.Id, DatesInfo);

      if m_TolleranceHoursComparison > 0 then
      begin
        if IdToSched.EndSched > (DatesInfo.HighEndDate + m_TolleranceHoursComparison/24) then
        begin
          GapEndDateToTolleranceInHours := ((IdToSched.EndSched - (DatesInfo.HighEndDate + m_TolleranceHoursComparison / 24))) * 24;
          m_TotalLateHoursAboveTollenrance := m_TotalLateHoursAboveTollenrance + GapEndDateToTolleranceInHours;
          inc(m_TotalLateJobsAboveTollenrance);
          if GapEndDateToTolleranceInHours > m_TotalHoursForLatestJobAboveTollenrance then
             m_TotalHoursForLatestJobAboveTollenrance := GapEndDateToTolleranceInHours;
        end
        else if (IdToSched.EndSched > DatesInfo.HighEndDate) and ((IdToSched.EndSched <
            (DatesInfo.HighEndDate + m_TolleranceHoursComparison / 24))) then
        begin
          GapEndDateToHighestEnd := (IdToSched.EndSched - DatesInfo.HighEndDate) * 24;
          m_TotalLateHoursUpToTollenrance := m_TotalLateHoursUpToTollenrance + GapEndDateToHighestEnd;
          Inc(m_TotalLateJobsUpToTollenrance);
        end;
      end
      else
      begin
        if (IdToSched.EndSched > DatesInfo.HighEndDate) then
        begin
          GapEndDateToTolleranceInHours := (IdToSched.EndSched - DatesInfo.HighEndDate) * 24;
          m_TotalLateHoursAboveTollenrance := m_TotalLateHoursAboveTollenrance + GapEndDateToTolleranceInHours;
          if GapEndDateToTolleranceInHours > m_TotalHoursForLatestJobAboveTollenrance then
             m_TotalHoursForLatestJobAboveTollenrance := GapEndDateToTolleranceInHours;
          Inc(m_TotalLateJobsAboveTollenrance)
        end;
      end;

      m_TotalSetupHoursStandard        := m_TotalSetupHoursStandard + supMinBase;
      m_TotalSetupHoursBeforeMaterials := m_TotalSetupHoursBeforeMaterials + SetUpNoMaterial;
      m_TotalSetupHoursAfterMaterials  := m_TotalSetupHoursAfterMaterials + (Setup - SetUpNoMaterial);
      m_TotalHoursAboveStandard        := m_TotalHoursAboveStandard + (Setup - supMinBase);
      if SetUpNoMaterial > 1 then
        inc(m_NumberOfJobsWithSetupNoMaterials);
      if setup > supminbase then
        inc(m_NumberOfJobsWithSetupAboveStandard);

      if (IdToSched.CompValJobToJob > 0) and (IdToSched.CompValJobToJob < 100) then
         inc(m_arrayJobToJobCase[IdToSched.CompValJobToJob]);

      if (IdToSched.CompValJobToRes > 0) and (IdToSched.CompValJobToRes < 100) then
         inc(m_arrayJobToResCase[IdToSched.CompValJobToRes]);

      if (IdToSched.EndSched > DatesInfo.HighEndDate) then
      begin
        if (IdToSched.EndSched > DatesInfo.HighEndDate) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 1)) then inc(m_ArrayDaysOfLatedJobs[1])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 1)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 2)) then inc(m_ArrayDaysOfLatedJobs[2])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 2)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 3)) then inc(m_ArrayDaysOfLatedJobs[3])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 3)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 4)) then inc(m_ArrayDaysOfLatedJobs[4])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 4)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 5)) then inc(m_ArrayDaysOfLatedJobs[5])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 5)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 6)) then inc(m_ArrayDaysOfLatedJobs[6])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 6)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 7)) then inc(m_ArrayDaysOfLatedJobs[7])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 7)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 8)) then inc(m_ArrayDaysOfLatedJobs[8])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 8)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 9)) then inc(m_ArrayDaysOfLatedJobs[9])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 9)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 10)) then inc(m_ArrayDaysOfLatedJobs[10])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 10)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 11)) then inc(m_ArrayDaysOfLatedJobs[11])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 11)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 12)) then inc(m_ArrayDaysOfLatedJobs[12])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 12)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 13)) then inc(m_ArrayDaysOfLatedJobs[13])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 13)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 14)) then inc(m_ArrayDaysOfLatedJobs[14])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 14)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 15)) then inc(m_ArrayDaysOfLatedJobs[15])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 15)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 16)) then inc(m_ArrayDaysOfLatedJobs[16])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 16)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 17)) then inc(m_ArrayDaysOfLatedJobs[17])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 17)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 18)) then inc(m_ArrayDaysOfLatedJobs[18])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 18)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 19)) then inc(m_ArrayDaysOfLatedJobs[19])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 19)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 20)) then inc(m_ArrayDaysOfLatedJobs[20])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 20)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 21)) then inc(m_ArrayDaysOfLatedJobs[21])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 21)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 22)) then inc(m_ArrayDaysOfLatedJobs[22])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 22)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 23)) then inc(m_ArrayDaysOfLatedJobs[23])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 23)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 24)) then inc(m_ArrayDaysOfLatedJobs[24])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 24)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 25)) then inc(m_ArrayDaysOfLatedJobs[25])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 25)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 26)) then inc(m_ArrayDaysOfLatedJobs[26])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 26)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 27)) then inc(m_ArrayDaysOfLatedJobs[27])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 27)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 28)) then inc(m_ArrayDaysOfLatedJobs[28])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 28)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 29)) then inc(m_ArrayDaysOfLatedJobs[29])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 29)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 30)) then inc(m_ArrayDaysOfLatedJobs[30])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 30)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 31)) then inc(m_ArrayDaysOfLatedJobs[31])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 31)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 32)) then inc(m_ArrayDaysOfLatedJobs[32])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 32)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 33)) then inc(m_ArrayDaysOfLatedJobs[33])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 33)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 34)) then inc(m_ArrayDaysOfLatedJobs[34])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 34)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 35)) then inc(m_ArrayDaysOfLatedJobs[35])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 35)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 36)) then inc(m_ArrayDaysOfLatedJobs[36])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 36)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 37)) then inc(m_ArrayDaysOfLatedJobs[37])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 37)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 38)) then inc(m_ArrayDaysOfLatedJobs[38])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 38)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 39)) then inc(m_ArrayDaysOfLatedJobs[39])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 39)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 40)) then inc(m_ArrayDaysOfLatedJobs[40])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 40)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 41)) then inc(m_ArrayDaysOfLatedJobs[41])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 41)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 42)) then inc(m_ArrayDaysOfLatedJobs[42])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 42)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 43)) then inc(m_ArrayDaysOfLatedJobs[43])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 43)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 44)) then inc(m_ArrayDaysOfLatedJobs[44])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 44)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 45)) then inc(m_ArrayDaysOfLatedJobs[45])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 45)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 46)) then inc(m_ArrayDaysOfLatedJobs[46])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 46)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 47)) then inc(m_ArrayDaysOfLatedJobs[47])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 47)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 48)) then inc(m_ArrayDaysOfLatedJobs[48])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 48)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 49)) then inc(m_ArrayDaysOfLatedJobs[49])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 49)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 50)) then inc(m_ArrayDaysOfLatedJobs[50])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 50)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 51)) then inc(m_ArrayDaysOfLatedJobs[51])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 51)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 52)) then inc(m_ArrayDaysOfLatedJobs[52])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 52)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 53)) then inc(m_ArrayDaysOfLatedJobs[53])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 53)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 54)) then inc(m_ArrayDaysOfLatedJobs[54])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 54)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 55)) then inc(m_ArrayDaysOfLatedJobs[55])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 55)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 56)) then inc(m_ArrayDaysOfLatedJobs[56])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 56)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 57)) then inc(m_ArrayDaysOfLatedJobs[57])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 57)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 58)) then inc(m_ArrayDaysOfLatedJobs[58])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 58)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 59)) then inc(m_ArrayDaysOfLatedJobs[59])
        else if (IdToSched.EndSched > (DatesInfo.HighEndDate + 59)) and (IdToSched.EndSched <= (DatesInfo.HighEndDate + 60)) then inc(m_ArrayDaysOfLatedJobs[60])
        else inc(m_ArrayDaysOfLatedJobs[61])
      end;

    end;

  end;
end;

//----------------------------------------------------------------------------//

function TResourcesManager.GetDaysOfLatedJobsCumulativeTillSpecificDay(Day : integer) : integer;
var
  I : Integer;
begin
  Result := 0;
  for I := low(m_ArrayDaysOfLatedJobs) to Day do
    Result := Result + m_ArrayDaysOfLatedJobs[I];
//  m_ArrayDaysOfLatedJobsCumulative[Day] := m_ArrayDaysOfLatedJobsCumulative[Day] + result;
//  Result := m_ArrayDaysOfLatedJobsCumulative[Day];
end;

//----------------------------------------------------------------------------//

procedure TResourcesManager.GetMaterialAddRessList(Id : TSchedId; ResourcesStruct : TResourcesStruct;
          var MatList, AddResList, AddResPointerList, ManPowerList, ManPowerPointerList : TList;
          SupMinBase, Dur, SetupNeedMat : double);
var
  ProdNature : SetArProdNature;
//  FirstResource : TResourcesStruct;
begin
//  p_pl.EnterCompatModeInPlanForAutoSeq(id, Pointer(GetResourceObjFromList(IsMainId, 0)));
  p_pl.EnterCompatModeInPlanForAutoSeq(id, Pointer(TMqmRes(TMqmVisibleRes(ResourcesStruct.m_ResPtr.p_Father))));

//  if IsMainId then
//    FirstResource := m_MainIdResList[0]
//  else
//    FirstResource := m_TempIdResList[0];

  if AutoSchedCfg.m_MatWOMaterials = 1 then
  begin
    ProdNature := [Ar_Material, Ar_MatWithDet];
    p_sc.GetMinMaterialsArrivalDate(id, TMqmRes(TMqmActArea(ResourcesStruct.m_ActArea).p_Res), ProdNature, MatList, SupMinBase, Dur, SetupNeedMat, false);
  end;

  if AutoSchedCfg.m_MatWOAddRes = 1 then
  begin
    ProdNature := [Ar_AddRes, Ar_AddRes_Capacity];
    AddResPointerList := p_sc.GetMinMaterialsArrivalDate(id, TMqmRes(TMqmActArea(ResourcesStruct.m_ActArea).p_Res), ProdNature, AddResList, SupMinBase, Dur, SetupNeedMat, true);
    ProdNature := [Ar_AddRes_ManPower];
    ManPowerPointerList := p_sc.GetMinMaterialsArrivalDate(id, TMqmRes(TMqmActArea(ResourcesStruct.m_ActArea).p_Res), ProdNature, ManPowerList, SupMinBase, Dur, SetupNeedMat, true);
  end;

  p_pl.ExitCompatModeInPlanForAutoSeq;
end;

//----------------------------------------------------------------------------//

function TResourcesManager.GetElapsedTime : string;
begin
  Result := m_ElapsedTime
end;

//----------------------------------------------------------------------------//

procedure TResourcesManager.SetElapsedTime(ElapsedTime : string);
begin
  m_ElapsedTime := ElapsedTime
end;

//----------------------------------------------------------------------------//

function TResourcesManager.GetTolleranceHoursComparison : double;
begin
  Result := m_TolleranceHoursComparison
end;

//----------------------------------------------------------------------------//

procedure TResourcesManager.SetTolleranceHoursComparison(TolleranceHours : double);
begin
  m_TolleranceHoursComparison := TolleranceHours
end;

//----------------------------------------------------------------------------//

function TResourcesManager.GetNumOfNotScheduleJobs : Integer;
begin
  result := m_NumOfNotScheduleJobss;
end;

//----------------------------------------------------------------------------//

function TResourcesManager.GetNumOfScheduleJobs : integer;
begin
  result := m_NumOfScheduleJobs;
end;

//----------------------------------------------------------------------------//

function TResourcesManager.GetTotalScore : double;
begin
  Result := m_TotalScore
end;

//----------------------------------------------------------------------------//

procedure TResourcesManager.ScheduledObjOnGantt;
var
  I, J, ResComp, NumberOfGroups, StartingGroupNumber, GroupNumber : Integer;
  ResourcesStruct : TResourcesStruct;
  IdToSched : PTJobToSched;
  ObjMover  : TMqmSchedObjMover;
  Res : TMqmVisibleRes;
  TmpStartDate, TmpEndDate : TDateTime;
  setup, overlap, duration, DeltaSetupObjToMove : double;
  OptsMover : SetOptsMover;
  planInfo, planInfoTmp  : TSQplanInfo;
  ActArea  : TMqmActArea;
  ResCode : string;
  MainList : TList;
begin

  if DBAppGlobals.MCM_App then
    MainList := m_AllResListByTyp
  else
    MainList := m_AllResList;

  for I := 0 to MainList.Count - 1 do
  begin
    ResourcesStruct := TResourcesStruct(MainList[i]);
    ResourcesStruct.m_ActArea.SortSchedObjs;
    for J := 0 to ResourcesStruct.m_SchedList.Count - 1 do
    begin
       if Assigned(FAutoSched) and FAutoSched.m_OperatedAbort then
           break;
      IdToSched := PTJobToSched(ResourcesStruct.m_SchedList[J]);
      if not Assigned(p_sc.GetExtLinkPtr(IdToSched.Id)) then continue;
      ActArea := p_sc.GetExtLinkPtr(IdToSched.Id);
      ResCode := TMqmRes(TMqmActArea(ActArea).p_Res).p_ResCode;
      p_sc.GetPlanInfo(IdToSched.Id, PlanInfo);
      if (PlanInfo.startDate <> IdToSched.StartSched) Or (TMqmRes(TMQMVisibleRes(ResourcesStruct.m_ResPtr).p_Father).p_ResCode <> ResCode) then
          MoveToBin(IdToSched.Id, false);
    end;
  end;

  NumberOfGroups := 0;
  for I := 0 to MainList.Count - 1 do
  begin
    ResourcesStruct := TResourcesStruct(MainList[i]);
    for J := 0 to ResourcesStruct.m_SchedList.Count - 1 do
    begin
      if Assigned(FAutoSched) and FAutoSched.m_OperatedAbort then
         break;
      IdToSched := PTJobToSched(ResourcesStruct.m_SchedList[J]);
      if Assigned(p_sc.GetExtLinkPtr(IdToSched.Id)) then continue;
      if p_sc.IsGroup(IdToSched.Id) and (p_sc.GetGroupCode(IdToSched.Id) = 0) then
        inc(NumberOfGroups);
    end;
  end;

  if NumberOfGroups > 0 then
  begin
    if not DBAppGlobals.MCM_App then
      StartingGroupNumber := GET_GRP_STARTING_NUMBER(NumberOfGroups,'GROUPNUMBER')
    else
      StartingGroupNumber := GET_GRP_STARTING_NUMBER(NumberOfGroups,'GRPNUMBERMCM');
    GroupNumber := StartingGroupNumber - 1;
  end;

  for I := 0 to MainList.Count - 1 do
  begin
    ResourcesStruct := TResourcesStruct(MainList[i]);
    for J := 0 to ResourcesStruct.m_SchedList.Count - 1 do
    begin
      if Assigned(FAutoSched) and FAutoSched.m_OperatedAbort then
         break;

      IdToSched := PTJobToSched(ResourcesStruct.m_SchedList[J]);

      if Assigned(p_sc.GetExtLinkPtr(IdToSched.Id)) then continue;

      if p_sc.IsGroup(IdToSched.Id) and (p_sc.GetGroupCode(IdToSched.Id) = 0) then
      begin
        inc(GroupNumber);
        p_sc.SetGroupCode(IdToSched.Id, GroupNumber);
      end;

      OccMoveEnter(FMQMPlan, Pointer(IdToSched.id));
      ObjMover := TMqmSchedObjMover.Create;
      ObjMover.SetObjToMove(IdToSched.id);
      Res := TMqmVisibleRes(ResourcesStruct.m_ActArea.p_Father);
      TmpStartDate := IdToSched.StartSched;
      if p_sc.GetRscComponentFromJobOrStep(IdToSched.id) > 0 then
        ResComp := p_sc.GetRscComponentFromJobOrStep(IdToSched.id)
      else
        ResComp := Res.p_ResComp;
      if ObjMover.ChangeTo(ResourcesStruct.m_ActArea, TmpStartDate, false, CSchedIDnull, Al_toDate, setup, overlap,
                           duration, '', TmpEndDate, OptsMover, nil, False, DeltaSetupObjToMove,false, ResComp) = CSM_Yes then
      begin
      end
      else
        ObjMover.Abort;
      OccMoveExit(FMQMPlan, true);

      p_sc.GetPlanInfo(IdToSched.Id, planInfoTmp);
      if planInfoTmp.startDate <> IdToSched.StartSched then
      begin
        IdToSched.id := IdToSched.id;
      end;

      UMGenericSchedulePrevStep.UnScheduleGenericPlan(IdToSched.Id);
      if IdToSched.GenericPlanWC <> '' then
      begin
        PlanInfo.GenericPlanWC := IdToSched.GenericPlanWC;
        PlanInfo.GenericPlanDur  := IdToSched.GenericPlanDur;
        PlanInfo.GenericPlanLeadTime := IdToSched.GenericPlanLeadTime;
        PlanInfo.GenericPlanMachineNum := IdToSched.GenericPlanMachineNum;
        PlanInfo.GenericPlanStartDate := IdToSched.GenericPlanStartDate;
        PlanInfo.GenericPlanEndDate := IdToSched.GenericPlanEndDate;
        p_sc.SetGenericInfo(IdToSched.Id, PlanInfo);
        UMGenericSchedulePrevStep.ScheduleOnSpecificPosition(IdToSched.id , PlanInfo);
      end;
      p_sc.SetAutoSeqTakePart(IdToSched.Id, true);
    end;

  end;

//  if UpdateGroupCodeInDb then
//     SET_GRP_MAX_NUM(GroupCode ,  'GROUPNUMBER');

end;

//----------------------------------------------------------------------------//

function TResourcesStruct.GetHigherDailyProduction: integer;
var
  I : Integer;
  StartDate : TDate;
  DailyHours : integer;
begin
  StartDate := date;
  Result := 0;
  for I := 1 to 30 do
  begin
    DailyHours := ceil(m_cal.DiffWH(StartDate, StartDate + 1, m_ActArea.m_CrossDownTmList));
    if DailyHours > result then
       result := DailyHours;
    if result = 24 then break;
    StartDate := StartDate + 1;
  end;
end;

//----------------------------------------------------------------------------//

function TResourcesStruct.GetIdResTiming(Id : TSchedId; var SupMinBase, Duration, DurationOrg : double) : boolean;
var
  TmgDescr, TmgMSC : String;
  components, ResComp : integer;
  DummyDateTime : TDateTime;
begin
  Result := true;
  components := 1;
  p_pl.SetTmgTargetRes(TMqmRes(m_actArea.p_res));
  p_pl.GetMainTimings(supMinBase, DurationOrg, TmgDescr, TmgMSC);
  if TMqmRes(m_actArea.p_res).p_isMultiRes then
  begin
    if p_sc.GetRscComponentFromJobOrStep(id) > 0 then
      ResComp := p_sc.GetRscComponentFromJobOrStep(id)
    else
      ResComp := TMQMVisibleRes(m_ResPtr).p_ResComp;
    components := ResComp;
  end;
  if CalcDurBeforeCurve(id, DurationOrg, Components) then
    Duration := DurationOrg + GetCurveTime(m_ActArea, now, id, DurationOrg, false , 0)
  else
    Duration := DurationOrg;
  if DurationOrg <= 0 then Result := false;
end;

//----------------------------------------------------------------------------//
function TResourcesManager.NoneCompetibleSomeBecauseOfDependency(Id : TSchedId; WorkCnterCode : string; PlantCode : String) : boolean;
var
  I: Integer;
  VisRes : TMqmVisibleRes;
  CompVal : TCompatVal;
  ResourcesStruct : TResourcesStruct;
  SupMinBase, Duration, DurationOrg : Double;
  Res : TMqmRes;
  MainList : TList;
  ChildId, GrpId : TSchedId;
  Dependency : boolean;
begin
  Result := false;
  {if p_sc.IsGroup(id) then
  begin
    ChildId := p_sc.GetGrpSon(Id, 0);
    if p_sc.GetJobNumBrothers(ChildId) > 1 then
    begin
      ChildId := p_sc.GetJobLowestBrother(ChildId);
      GrpId := p_sc.GetGroup(ChildId);
      if GrpId <> -1 then
         Id := GrpId;
    end;
  end
  else
  begin
    if p_sc.GetJobNumBrothers(id) > 1 then
    begin
      id := p_sc.GetJobLowestBrother(id);
    end;
  end;  }

  if DBAppGlobals.MCM_App then
    MainList := m_AllResListByTyp
  else
    MainList := m_AllResList;

  for I := 0 to MainList.Count - 1 do
  begin
    ResourcesStruct := TResourcesStruct(MainList[i]);
    if (PlantCode <> '') and (PlantCode <> ResourcesStruct.m_PlantCode) then Continue;
    VisRes := TMqmVisibleRes(ResourcesStruct.m_ResPtr);
    Res := TMqmRes(TMqmVisibleRes(VisRes.p_Father));
    p_pl.EnterCompatModeInPlanForAutoSeq(id, Pointer(TMqmRes(VisRes.p_Father)));
    if VisRes.CheckCompatWithOcc([cho_compVal, cho_timing, cho_wkc, cho_readOnly, cho_Depend],id, 0, nil,
       CompVal, Dependency) then
    begin
      if (CompVal > AutoSchedCfg.m_MinJobResComp) then continue;
      if not ResourcesStruct.GetIdResTiming(Id, SupMinBase, Duration, DurationOrg) then continue;
      Result := false;
      exit;
    end;
    if Dependency then Result := true;
  end;

end;

//----------------------------------------------------------------------------//
function TResourcesManager.SetCompatibleRes(Id: TSchedId; WorkCnterCode : string; PlantCode : String; MinMaxOptQtyList : Tlist) : boolean;
var
  I,J,Pos : Integer;
  VisRes : TMqmVisibleRes;
  CompVal : TCompatVal;
  ResourcesStruct : TResourcesStruct;
  ListStrRes, ListStrCmpToRes, ListStrSupMinBase, ListStrDuration, ListStrDurationOrg,
  ListStrStandBatchSize , ListStrMinBatchSize, ListStrMaxBatchSize : TStringList;
  InformationBox : PInformationBox;
  SupMinBase, Duration, DurationOrg, QtyConvert, MultQty, MaxSingleQty : Double;
  MinQty, OptQty, MaxQty : currency;
  TempExt : Extended;
  L : string;
  Res : TMqmRes;
  ChildId, GrpId : TSchedId;
  QtyVal : double;
  dataType: CBinColValType;
  DurationQuantityBase : double;
  FoundSameQuantities, IdIsAlreadyStored, AllowSplit : boolean;
  PMinMaxOptQty : PTMinMaxOptQty;
  JobInfo : TSQplanInfo;
  MainList : TList;
  Dependency : boolean;
  RequestStepsToReLoadResources : PTRequestStepsToReLoadResources;
  FoundIndex, QtyInt : integer;
  AdditionalOptimumMaxMultiplierProp, AdditionalMinMultiplierProp : double;
  HoursDailyProduction : integer;
  JobQty : double;
  SplitInfo: TSQSplitInfo;
begin
  Result := false;

 { if p_sc.IsGroup(id) then
  begin
    ChildId := p_sc.GetGrpSon(Id, 0);
    if p_sc.GetJobNumBrothers(ChildId) > 1 then
    begin
      ChildId := p_sc.GetJobLowestBrother(ChildId);
      GrpId := p_sc.GetGroup(ChildId);
      if GrpId <> -1 then
         Id := GrpId;
    end;
  end
  else
  begin
    if p_sc.GetJobNumBrothers(id) > 1 then
    begin
      id := p_sc.GetJobLowestBrother(id);
    end;
  end;   }

  RequestStepsToReLoadResources := FindRequestStepToReLoadResourcesInList(Id, m_ListOfRequestStepsToReLoadResources, FoundIndex);
  ListStrRes := GetInformationById(Id, ListStrCmpToRes, ListStrSupMinBase, ListStrDuration, ListStrDurationOrg,
                ListStrStandBatchSize , ListStrMinBatchSize, ListStrMaxBatchSize, Pos, DurationQuantityBase);

  if (RequestStepsToReLoadResources <> nil) and RequestStepsToReLoadResources.ReLoadResources then
  begin
    if (ListStrRes <> nil) then
    begin
      InformationBox := PInformationBox(m_InformationBoxList[Pos]);
      InformationBox.m_ListStrRes.Free;
      InformationBox.m_ListStrCmpToRes.Free;
      InformationBox.m_SupMinBaseList.Free;
      InformationBox.m_DurationList.Free;
      InformationBox.m_DurationListOrg.Free;
//      InformationBox.m_Sndt_bch_Size.Free;
//      InformationBox.m_Min_bch_Size.Free;
//      InformationBox.m_Max_bch_Size.Free;
      for I := 0 to InformationBox.m_MinMaxOptQtyList.Count - 1 do
        dispose(PTMinMaxOptQty(InformationBox.m_MinMaxOptQtyList[I]));
      InformationBox.m_MinMaxOptQtyList.Free;
      Dispose(InformationBox);
      m_InformationBoxList.Delete(pos);
      m_LastId := -1;
      ListStrRes := nil;
    end;
    if not RequestStepsToReLoadResources.ReCheckResources then
      RemoveRequestStepToReLoadResourcesList(FoundIndex);
  end;

  IdIsAlreadyStored := true;
  if (ListStrRes = nil) then
  begin
    if DBAppGlobals.MCM_App then
      MainList := m_AllResListByTyp
    else
      MainList := m_AllResList;

    IdIsAlreadyStored := false;
    new(InformationBox);
    InformationBox.m_ListStrRes           := TStringList.Create;
    InformationBox.m_ListStrCmpToRes      := TStringList.Create;
    InformationBox.m_SupMinBaseList       := TStringList.Create;
    InformationBox.m_DurationList         := TStringList.Create;
    InformationBox.m_DurationListOrg      := TStringList.Create;
    InformationBox.m_Sndt_bch_Size        := TStringList.Create;
    InformationBox.m_Min_bch_Size         := TStringList.Create;
    InformationBox.m_Max_bch_Size         := TStringList.Create;

    InformationBox.m_MinMaxOptQtyList     := TList.Create;
    InformationBox.m_id := Id;
    //p_sc.GetFldValue(id, CSC_QtyToSched, QtyVal, dataType);
    QtyVal := p_sc.GetJobQty(id);
    InformationBox.m_DurationQuantityBase := QtyVal;
    pos := m_InformationBoxList.add(InformationBox);

    for I := 0 to MainList.Count - 1 do
    begin
      ResourcesStruct := TResourcesStruct(MainList[i]);
      if (PlantCode <> '') and (PlantCode <> ResourcesStruct.m_PlantCode) then Continue;
      if AutoSchedCfg.m_OverridingParams_Activated and AutoSchedCfg.m_OverridingParams_Wc_Selected then
      begin

        if (AutoSchedCfg.m_SlotGroup = 0) then // w.c normal selection
        begin
          if TMqmWrkCtr(TMqmRes(TMQMVisibleRes(ResourcesStruct.m_ResPtr).p_Father).p_WrkCtr).p_WrkCtrCode <>
             AutoSchedCfg.m_OverridingParams_Wc_Code_Selected then
           continue;
        end
        else if AutoSchedCfg.m_SlotGroup = 1 then  // P_WcGrp
        begin
          if AutoSchedCfg.m_GroupName <> TMqmWrkCtr(TMqmRes(TMQMVisibleRes(ResourcesStruct.m_ResPtr).p_Father).p_WrkCtr).P_WcGrp then
              continue;
        end
        else if AutoSchedCfg.m_SlotGroup = 2 then  // p_PlantCode
        begin
          if AutoSchedCfg.m_GroupName <> TMqmWrkCtr(TMqmRes(TMQMVisibleRes(ResourcesStruct.m_ResPtr).p_Father).p_WrkCtr).p_PlantCode then
              continue;
        end
        else if AutoSchedCfg.m_SlotGroup = 3 then  // p_Division
        begin
          if AutoSchedCfg.m_GroupName <> TMqmWrkCtr(TMqmRes(TMQMVisibleRes(ResourcesStruct.m_ResPtr).p_Father).p_WrkCtr).p_Division then
              continue;
        end

      end;

      VisRes := TMqmVisibleRes(ResourcesStruct.m_ResPtr);
      Res := TMqmRes(TMqmVisibleRes(VisRes.p_Father));
      p_pl.EnterCompatModeInPlanForAutoSeq(id, Pointer(TMqmRes(VisRes.p_Father)));
      if VisRes.CheckCompatWithOcc([cho_compVal, cho_timing, cho_wkc, cho_readOnly, {cho_qty,} cho_Depend],
                                     id, 0, nil, CompVal, Dependency)
      and (CompVal <= AutoSchedCfg.m_MinJobResComp) then
      begin
        if ResourcesStruct.GetIdResTiming(Id, SupMinBase, Duration, DurationOrg) then
        begin
          Result := True;
        //  FirstResource := ResourcesStruct;
          InformationBox.m_ListStrRes.Add(ResourcesStruct.m_ResCode);
          InformationBox.m_ListStrCmpToRes.Add(IntToStr(CompVal));
          InformationBox.m_SupMinBaseList.Add(FloatToStr(SupMinBase));
          InformationBox.m_DurationList.Add(FloatToStr(Duration));
          InformationBox.m_DurationListOrg.Add(FloatToStr(DurationOrg));

          MultQty := 1;

          p_sc.GetJobInfo(Id, JobInfo);

          if not JobInfo.BatchSizePerStep then
          begin
            AdditionalOptimumMaxMultiplierProp := res.P_GetAdditionalOptimumMaxMultiplierProp[Id];
            AdditionalMinMultiplierProp := res.P_GetAdditionalMinMultiplierProp[Id];
            p_sc.QtyInUM(id ,Res.p_BchUM , QtyConvert, MultQty);

            if JobInfo.OptimumBatchSize = -1 then
            begin
              QtyInt := trunc(Res.p_Sndt_bch_Size*AdditionalOptimumMaxMultiplierProp*100);
              OptQty := QtyInt/100;
            end
            else
            begin
              QtyInt := trunc(Res.p_Sndt_bch_Size*AdditionalOptimumMaxMultiplierProp/MultQty*100);
              OptQty := QtyInt/100;
            end;

            if JobInfo.MinBatchSize = -1 then
            begin
              QtyInt := trunc(Res.p_Min_bch_size*AdditionalMinMultiplierProp*100);
              MinQty := QtyInt/100;
            end
            else
            begin
              QtyInt := trunc(Res.p_Min_bch_size*AdditionalMinMultiplierProp/MultQty*100);
              MinQty := QtyInt/100;
            end;
            if (Res.p_Min_bch_size > 0) and (MinQty = 0) then
              MinQty := 999999999;

            if JobInfo.MaxBatchSize = -1 then
            begin
              QtyInt := trunc(Res.p_Max_bch_size*AdditionalOptimumMaxMultiplierProp*100);
              MaxQty := QtyInt/100;
            end
            else
            begin
              QtyInt := trunc(Res.p_Max_bch_size*AdditionalOptimumMaxMultiplierProp/MultQty*100);
              MaxQty := QtyInt/100;
            end;

            if JobInfo.MaxBatchSize = -1 then
            begin
              QtyInt := trunc(Res.p_Single_Max_bch_size/1*100);
              MaxSingleQty := QtyInt/100;
            end
            else
            begin
              QtyInt := trunc(Res.p_Single_Max_bch_size/MultQty*100);
              MaxSingleQty := QtyInt/100;
            end;

          end
          else
          begin
            QtyInt := trunc(JobInfo.OptimumBatchSize*100);
            OptQty := QtyInt/100;
            QtyInt := trunc(JobInfo.MinBatchSize);
            MinQty := QtyInt/100;
            QtyInt := trunc(JobInfo.MaxBatchSize);
            MaxQty := QtyInt/100;
            QtyInt := trunc(JobInfo.MaxBatchSize*100);
            MaxSingleQty := QtyInt/100;
          end;

         // MaxQty := 0;
         // MinQty := 0;
          if (MaxQty = 0) and (MinQty = 0) and (AutoSchedCfg.m_SplitSchedByBatchSize = DailyProductionAndJoin) then
          begin
            JobQty := p_sc.GetJobQty(id);
            AllowSplit := true;
            if p_sc.IsGroup(id) then
            begin
              for J := 0 to p_sc.GetGrpNumSons(Id) - 1 do
              begin
                ChildId := p_sc.GetGrpSon(Id, J);
                p_sc.GetSplitInfo(ChildId, SplitInfo);
                if SplitInfo.SplitAllow <> CSB_Yes then
                begin
                  AllowSplit := false;
                  break;
                end;
              end;
            end
            else
            begin
              p_sc.GetSplitInfo(Id, SplitInfo);
              if SplitInfo.SplitAllow <> CSB_Yes then
                AllowSplit := false;
            end;

            if AllowSplit then
            begin
              HoursDailyProduction := ResourcesStruct.GetHigherDailyProduction;
              QtyInt := trunc(100*JobQty/(Duration) * HoursDailyProduction * 60);
              MaxQty := QtyInt/100;
              OptQty := MaxQty;
              MinQty := -1
            end;
          end;

          if (MaxQty = 0) and (OptQty = 0) and (AutoSchedCfg.m_SplitSchedByBatchSize = LongestDurationPossible) then
          begin
            JobQty := p_sc.GetJobQty(id);
            QtyInt := trunc(100 * JobQty / Duration * 30); // Quantity in 30 minutes
            OptQty := QtyInt/100;
            if OptQty < MinQty then
              OptQty := MinQty;
          end;

          InformationBox.m_Sndt_bch_Size.Add(FloatToStr(OptQty));
          InformationBox.m_Min_bch_Size.Add(FloatToStr(MinQty));
          InformationBox.m_Max_bch_Size.Add(FloatToStr(MaxQty));

          FoundSameQuantities := false;
          for J := 0 to InformationBox.m_MinMaxOptQtyList.Count - 1 do
          begin
            if (PTMinMaxOptQty(InformationBox.m_MinMaxOptQtyList[J]).OptQty = OptQty)
            and (PTMinMaxOptQty(InformationBox.m_MinMaxOptQtyList[J]).MinQty = MinQty)
            and (PTMinMaxOptQty(InformationBox.m_MinMaxOptQtyList[J]).MaxQty = MaxQty)
            and (PTMinMaxOptQty(InformationBox.m_MinMaxOptQtyList[J]).PlantCode = ResourcesStruct.m_PlantCode) then
            begin
              FoundSameQuantities := true;
              break;
            end;
            if (PTMinMaxOptQty(InformationBox.m_MinMaxOptQtyList[J]).OptQty < OptQty) then break;
          end;
          if not FoundSameQuantities then
          begin
            if InformationBox.m_MinMaxOptQtyList.Count = 0 then J := 0;
            new(PMinMaxOptQty);
            PMinMaxOptQty.PlantCode := ResourcesStruct.m_PlantCode;
            PMinMaxOptQty.MinQty    := MinQty;
            PMinMaxOptQty.MaxQty    := MaxQty;
            PMinMaxOptQty.OptQty    := OptQty;
            InformationBox.m_MinMaxOptQtyList.Insert(j, PMinMaxOptQty);
          end;
        end;
      end;
      p_pl.ExitCompatModeInPlanForAutoSeq
    end;
  end
  else
  begin
    Result := True;
 {   for I := 0 to ListStrRes.Count - 1 do
    begin
      ResourcesStruct := FindResourceByCode(ListStrRes.Strings[I], m_AllResList);
      if ResourcesStruct <> nil then
      begin
        FirstResource := ResourcesStruct;
        Break;
      end;
    end;  }
  end;

  if assigned(MinMaxOptQtyList) then
  begin
    p_sc.GetJobInfo(Id, JobInfo);
    InformationBox := PInformationBox(m_InformationBoxList[Pos]);
    for J := 0 to InformationBox.m_MinMaxOptQtyList.Count - 1 do
    begin
      if (PlantCode <> '') and (PlantCode <> PTMinMaxOptQty(InformationBox.m_MinMaxOptQtyList[J]).PlantCode) then Continue;
      if (AutoSchedCfg.m_SplitSchedByBatchSize = DailyProductionAndJoin) and (MinMaxOptQtyList.Count = 1) then
        PMinMaxOptQty := PTMinMaxOptQty(MinMaxOptQtyList[0])
      else
        new(PMinMaxOptQty);
      PMinMaxOptQty.MinQty := PTMinMaxOptQty(InformationBox.m_MinMaxOptQtyList[J]).MinQty;
      PMinMaxOptQty.MaxQty := PTMinMaxOptQty(InformationBox.m_MinMaxOptQtyList[J]).MaxQty;
      PMinMaxOptQty.OptQty := PTMinMaxOptQty(InformationBox.m_MinMaxOptQtyList[J]).OptQty;
      if (JobInfo.MinBatchSize > 0) and (JobInfo.MinBatchSize > PMinMaxOptQty.MinQty) then
          PMinMaxOptQty.MinQty := JobInfo.MinBatchSize;
      if (AutoSchedCfg.m_SplitSchedByBatchSize <> DailyProductionAndJoin) or (MinMaxOptQtyList.Count = 0) then
      MinMaxOptQtyList.add(PMinMaxOptQty);
    end;
  end;

  if not IdIsAlreadyStored then
    m_InformationBoxList.Sort(SortInformationBoxById);

end;

//----------------------------------------------------------------------------//

procedure TResourcesManager.SetNumOfNotScheduleJobs(Number: integer);
begin
  m_NumOfNotScheduleJobss := Number
end;

//----------------------------------------------------------------------------//

procedure TResourcesManager.SetNumOfScheduleJobs(Number: integer);
begin
  m_NumOfScheduleJobs := Number
end;

//----------------------------------------------------------------------------//

procedure CleanAllInformationList(OnlyOvrlapList : boolean);
var
  I, J , L : Integer;
  InformationBox : PInformationBox;
  OverlapBox     : PTOverlapBox;
  PResOvlop      : PTResOvlop;
begin
  for I := m_OverlapBoxList.Count - 1 downto 0 do
  begin
    OverlapBox := PTOverlapBox(m_OverlapBoxList[I]);
    for J := OverlapBox.m_ResListOvlop.Count - 1 downto 0 do
    begin
      PResOvlop := PTResOvlop(OverlapBox.m_ResListOvlop[J]);
      for L := PResOvlop.m_OvlopLimit.Count - 1 downto 0 do
        dispose(PTOvlopLimit(PResOvlop.m_OvlopLimit[L]));
    //  PResOvlop.m_OvlopLimit.Clear;
      PResOvlop.m_OvlopLimit.Free;
      dispose(PResOvlop);
     // end;
    end;
    OverlapBox.m_ResListOvlop.Clear;
    OverlapBox.m_ResListOvlop.Free;
  end;
  m_OverlapBoxList.Clear;

  if OnlyOvrlapList then Exit;
  for I := m_InformationBoxList.Count - 1 downto 0 do
  begin
    InformationBox := PInformationBox(m_InformationBoxList[I]);
    begin
      for J := InformationBox.m_MinMaxOptQtyList.Count - 1 downto 0 do
        dispose(PTMinMaxOptQty(InformationBox.m_MinMaxOptQtyList[J]));
      InformationBox.m_ListStrRes.Free;
      InformationBox.m_ListStrCmpToRes.Free;
      InformationBox.m_SupMinBaseList.Free;
      InformationBox.m_DurationList.Free;
      InformationBox.m_DurationListOrg.Free;
      InformationBox.m_MinMaxOptQtyList.Free;
//      InformationBox.m_Sndt_bch_Size.Free;
//      InformationBox.m_Min_bch_Size.Free;
//      InformationBox.m_Max_bch_Size.Free;
      Dispose(InformationBox);
    end;
  end;
  m_InformationBoxList.clear;
end;

//----------------------------------------------------------------------------//

procedure CleanRollbackInfoList(RollDowntoIndex : Integer);
var
  I : Integer;
begin
  for I := m_rollbackInfoList.Count - 1 downto RollDowntoIndex do
  begin
    dispose(PTJobToSched(m_rollbackInfoList[I]));
    m_rollbackInfoList.Delete(I);
  end;
end;

//----------------------------------------------------------------------------//

procedure CleanPropList;
var
  I : Integer;
  PropListId : PTPropListId;
  PropListSetup : PTPropListSetup;
begin
  for I := m_PropListId.Count - 1 downto 0 do
  begin
    PropListId := PTPropListId(m_PropListId[I]);
    dispose(PropListId);
  end;
  m_PropListId.Clear;

  for I := m_PropListSetup.Count - 1 downto 0 do
  begin
    PropListSetup := PTPropListSetup(m_PropListSetup[I]);
    dispose(PropListSetup);
  end;
  m_PropListSetup.Clear;

end;

//----------------------------------------------------------------------------//

procedure RollBackFromList(RollDowntoIndex : integer);
var
  I, J : Integer;
  RollBackInfo,IdToSched : PTJobToSched;
  JobIdFromBackup : PTJobInfo;
  List : TList;
  Id, ChildId : TSchedId;
  TempPlanInfo, PlanInfo, JobInfo : TSQplanInfo;
  TempList, TempGrpList : TList;
  PTRResourceManagaer : pointer;
begin
  for I := m_rollbackInfoList.Count - 1 downto RollDowntoIndex do
  begin
    RollBackInfo := PTJobToSched(m_rollbackInfoList[i]);
    Id := RollBackInfo.Id;
    PTRResourceManagaer := RollBackInfo.ResourceManagerPtr;
    List := TResourcesManager(RollBackInfo.ResourceManagerPtr).m_ListBackupIdInfo;

    if RollBackInfo.SchedType = schedule then
    begin
      JobIdFromBackup := FindIdInBackUpList(RollBackInfo.Id, List);
      BeforeDeletedFromSched(TResourcesStruct(RollBackInfo.ResourcesStruct).m_CurveByFamilyInfo, RollBackInfo.Id);
      dispose(PTJobToSched(TResourcesStruct(RollBackInfo.ResourcesStruct).m_SchedList[RollBackInfo.PosInList]));
      TResourcesStruct(RollBackInfo.ResourcesStruct).m_SchedList.Delete(RollBackInfo.PosInList);
      if assigned(JobIdFromBackup) then
        JobIdFromBackup.ResourcesStruct := nil;
      p_pl.UpdatePlanLinkJob('', Id, nil);

      p_sc.GetplanInfo(Id, planInfo);
      if planInfo.GenericPlanWC <> '' then
      begin
         UMGenericSchedulePrevStep.UnScheduleGenericPlan(Id);
         planInfo.GenericPlanWC := '';
         p_sc.SetGenericInfo(Id, planInfo);
      end;
      if assigned(JobIdFromBackup) then
      begin
 //       p_sc.SetPlanInfo(Id, JobIdFromBackup.OldPlanInfo);
        TempPlanInfo := JobIdFromBackup.OldPlanInfo;
        TempPlanInfo.quant := planInfo.quant;
        TempPlanInfo.FinQuant := planInfo.FinQuant;
        p_sc.SetPlanInfo(Id, TempPlanInfo);
      end;
    end;

    if RollBackInfo.SchedType = unschedule then
    begin
      JobIdFromBackup := FindIdInBackUpList(RollBackInfo.Id, List);
      if RollBackInfo.OldPlanInfo.GenericPlanWC <> '' then
        ScheduleOnSpecificPosition(id , RollBackInfo.OldPlanInfo);
      TResourcesStruct(RollBackInfo.ResourcesStruct).SetPlanInfo(id, RollBackInfo.OldPlanInfo);
     // p_pl.UpdatePlanLinkJob(TResourcesStruct(RollBackInfo.ResourcesStruct).m_ResCode, Id, nil);
      p_pl.UpdatePlanLinkJobAutoSeq(TResourcesStruct(RollBackInfo.ResourcesStruct).m_ResPtr, Id, nil);
      p_sc.UpdateBalance(id);
      if JobIdFromBackup <> nil then
        JobIdFromBackup.ResourcesStruct := RollBackInfo.ResourcesStruct;
      new(IdToSched);
      IdToSched^ := RollBackInfo^;
      if RollBackInfo.ReScheduleAtSpecificPlace then
        TResourcesStruct(RollBackInfo.ResourcesStruct).m_SchedList.insert(RollBackInfo.ReSchedulePlace, IdToSched)
      else
        TResourcesStruct(RollBackInfo.ResourcesStruct).m_SchedList.Add(IdToSched);
      AfterInsertToSched(TResourcesStruct(RollBackInfo.ResourcesStruct).m_CurveByFamilyInfo, IdToSched);
    end;

    if RollBackInfo.SchedType = RemoveGenericPlan then
    begin
//      JobIdFromBackup := FindIdInBackUpList(RollBackInfo.Id, List);
      p_sc.GetJobInfo(Id, JobInfo);
      JobInfo.GenericPlanWC :=RollBackInfo.GenericPlanWC;
      JobInfo.GenericPlanDur:=RollBackInfo.GenericPlanDur;
      JobInfo.GenericPlanLeadTime :=RollBackInfo.GenericPlanLeadTime;
      JobInfo.GenericPlanMachineNum :=RollBackInfo.GenericPlanMachineNum;
      JobInfo.GenericPlanStartDate :=RollBackInfo.GenericPlanStartDate;
      JobInfo.GenericPlanEndDate :=RollBackInfo.GenericPlanEndDate;
      p_sc.SetGenericInfo(Id, JobInfo);
      ScheduleOnSpecificPosition(id , JobInfo);
    end;

    if RollBackInfo.SchedType = Update then
    begin
//      JobIdFromBackup := FindIdInBackUpList(RollBackInfo.Id, List);
      p_sc.GetPlanInfo(Id, PlanInfo);
      p_pl.UpdatePlanLinkJob('', Id, nil);
      PlanInfo.startDate := RollBackInfo.StartSched;
      PlanInfo.EndDate := RollBackInfo.EndSched;
      PlanInfo.supMinReal := RollBackInfo.Setup;
      PlanInfo.supMinOvlp := RollBackInfo.SetupNoMaterial;
      PlanInfo.exeMin := RollBackInfo.Duration;
      TResourcesStruct(RollBackInfo.ResourcesStruct).SetPlanInfo(Id, PlanInfo);
      p_pl.UpdatePlanLinkJobAutoSeq(TResourcesStruct(RollBackInfo.ResourcesStruct).m_ResPtr, Id, nil);
   //   p_pl.UpdatePlanLinkJob(TResourcesStruct(RollBackInfo.ResourcesStruct).m_ResCode, Id, nil);
      p_sc.UpdateBalance(Id);
//      PTJobToSched(TResourcesStruct(RollBackInfo.ResourcesStruct).m_SchedList[RollBackInfo.PosInList]).StartSched := RollBackInfo.StartSched;
//      PTJobToSched(TResourcesStruct(RollBackInfo.ResourcesStruct).m_SchedList[RollBackInfo.PosInList]).EndSched := RollBackInfo.EndSched;
//      PTJobToSched(TResourcesStruct(RollBackInfo.ResourcesStruct).m_SchedList[RollBackInfo.PosInList]).score := RollBackInfo.Score;
//      PTJobToSched(TResourcesStruct(RollBackInfo.ResourcesStruct).m_SchedList[RollBackInfo.PosInList]).ScoreJobToJob := RollBackInfo.ScoreJobToJob;
//      PTJobToSched(TResourcesStruct(RollBackInfo.ResourcesStruct).m_SchedList[RollBackInfo.PosInList]).ScoreJobToRes := RollBackInfo.ScoreJobToRes;
//      PTJobToSched(TResourcesStruct(RollBackInfo.ResourcesStruct).m_SchedList[RollBackInfo.PosInList]).CompValJobToJob := RollBackInfo.CompValJobToJob;
//      PTJobToSched(TResourcesStruct(RollBackInfo.ResourcesStruct).m_SchedList[RollBackInfo.PosInList]).Setup := RollBackInfo.Setup;
//      PTJobToSched(TResourcesStruct(RollBackInfo.ResourcesStruct).m_SchedList[RollBackInfo.PosInList]).SetUpNoMaterial := RollBackInfo.SetupNoMaterial;
      PTJobToSched(TResourcesStruct(RollBackInfo.ResourcesStruct).m_SchedList[RollBackInfo.PosInList])^ := RollBackInfo^;
      AfterSchedUpdated(TResourcesStruct(RollBackInfo.ResourcesStruct).m_CurveByFamilyInfo,
        PTJobToSched(TResourcesStruct(RollBackInfo.ResourcesStruct).m_SchedList[RollBackInfo.PosInList]));
    end;

    if RollBackInfo.SchedType = MinorUpdate then
    begin
      PTJobToSched(TResourcesStruct(RollBackInfo.ResourcesStruct).m_SchedList[RollBackInfo.PosInList])^ := RollBackInfo^;
    end;

    if RollBackInfo.SchedType = New_Id then
    begin
      JobIdFromBackup := FindIdInBackUpList(RollBackInfo.NewId, List);
      TempList := TList.Create;
      TempList.add(Pointer(RollBackInfo.NewId));
      p_sc.JoinJobs(RollBackInfo.Id, TempList);
      if assigned(JobIdFromBackup) then
    //  begin
    //    List.Remove(JobIdFromBackup);
    //    dispose(JobIdFromBackup)
    //  end;
      TResourcesManager(PTRResourceManagaer).MarkIdAsNotValidInBackupList(RollBackInfo.NewId);
      TempList.Free;
    end;

    if RollBackInfo.SchedType = New_Id_Group then
    begin
      JobIdFromBackup := FindIdInBackUpList(RollBackInfo.NewId, List);
      TempList := TList.Create;
      for J := 0 to p_sc.GetGrpNumSons(RollBackInfo.NewId) - 1 do
      begin
        ChildId := p_sc.GetGrpSon(RollBackInfo.NewId, J);
        TempList.add(Pointer(ChildId));
      end;

      p_sc.DeleteGroup(RollBackInfo.NewId);
      TempGrpList := TList.Create;
      for J := 0 to p_sc.GetGrpNumSons(RollBackInfo.Id) - 1 do
      begin
        TempGrpList.Clear;
        ChildId := p_sc.GetGrpSon(RollBackInfo.Id, J);
        TempGrpList.Add(TempList[J]);
        p_sc.JoinJobs(ChildId, TempGrpList);
      end;

    //  if assigned(JobIdFromBackup) then
    //  begin
    //    List.Remove(JobIdFromBackup);
    //    dispose(JobIdFromBackup)
    //  end;
      TResourcesManager(PTRResourceManagaer).MarkIdAsNotValidInBackupList(RollBackInfo.NewId);
      TempGrpList.Free;
      TempList.Free;
    end;

    dispose(PTJobToSched(RollBackInfo));
    m_rollbackInfoList.Delete(I);

  end;

end;

//----------------------------------------------------------------------------//

initialization

  m_InformationBoxList := TList.Create;
  m_rollbackInfoList   := TList.Create;
  m_LastId             := CSchedIDnull;
  m_LastIdPos          := -1;
  m_ListLogId          := TList.create;

  m_OverlapBoxList     := TList.Create;
  m_LastOvrlapId       := CSchedIDnull;
  m_LastOverlapIdPos   := -1;
  m_PropListId         := Tlist.Create;
  m_PropListSetup      := Tlist.Create;

finalization

//  CleanAllInformationList(false);
//  CleanRollbackInfoList(0);
//  CleanLogList;
  m_ListLogId.Free;
  m_InformationBoxList.Free;
  m_OverlapBoxList.Free;
  m_rollbackInfoList.Free;
  m_PropListId.Free;
  m_PropListSetup.Free;

end.
