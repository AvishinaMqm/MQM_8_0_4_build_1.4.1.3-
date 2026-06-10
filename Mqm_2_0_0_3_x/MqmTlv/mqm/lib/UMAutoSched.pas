unit UMAutoSched;

interface

uses
  Classes,
  windows,
  UMSchedContFunc,
  UMSchedList,
  Forms,
  UMAutoSchedCfg,
  FmAutoRunSet,
  DateUtils,
  UMRank;//  UVdurObjects;

type

  TSchedOnRes = (Sc_All, Sc_With_Grp, Sc_without_grp);

  TAutoSchedThread = class(TThread)
  private
    m_ObjList : TMSchedList;
    m_ObjListInfo : TList;
    m_ManagerResList : TList;
    m_Active: Boolean;
    m_ResIndexSorted : boolean;
    m_ShcheduledJobs : boolean;
    m_IsPrevHighDateVisible : boolean;
    m_IsNextLowDateVisible  : boolean;

    procedure AddConnectedReqToList;
    procedure StartAutomaticSequencingRunningForWard;
    procedure CleanAllAutoSeqHandled;
    procedure SetAllAutoSeqHandled;
  protected
    procedure Execute; override;
  public
    constructor CreateAutoSchedTread(AOwner: Tcomponent; ObjList: TMSchedList; IsPrevHighDateVisible : boolean; IsNextLowDateVisible : boolean; ManagerResList : TList);
    destructor  Destroy ; override;
  end;

  function  SortMcmReschededIds(Item1, Item2: Pointer): integer;
  procedure SearchFamilyRelative(Id : TSchedId; var FoundSonId : boolean; var SonId : TSchedId);
  function  GetAutoSeqLogInfoList : TStringList;

var
//  AutoSchedCfg: TAutoSchedCfg;
  AutoSchedTread: TAutoSchedThread;

implementation

uses
  Sysutils,
  Math,
  Dialogs,
  gnugettext,
  FMAutoSched,
  FMAutoSchedCfg,
  umgLOBAL,
  UMObjCont,
  UMGenericSchedulePrevStep,
  FMWorkCenterCategoryCapacity,
  FMMainPlan,
  UMPlanTbs,
  UMRes,
  UMTabCfg,
  UMCompat,
  UMSchedCont,
  UMPlanObj,
  UMActArea,
  UMStatus,
  UMBinFunc,
  UMPlanFunc,
  UMOpStack,
  UMSchedObjMover,
  UMStoredProc,
  UGganttPanel,
  UMCommon,
  FMGrpSplit,
  FMAutoSchedWorkCenterCfg,
  UMAutoSchedSimulation,
  UMBinGrid;

type

  TSplitResByBatch = record
    Qty : currency;
    BatchSize : boolean;
  end;
  PTSplitResByBatch = ^TSplitResByBatch;

var
  m_LogInfoList : TStringList;

//----------------------------------------------------------------------------//
// Public functions
//----------------------------------------------------------------------------//

function SortMcmReschededIds(Item1, Item2: Pointer): integer;
var
  MCMlinkInfo1 : PTSQMCMlinkInfo;
  MCMlinkInfo2 : PTSQMCMlinkInfo;
begin
  MCMlinkInfo1 := PTSQMCMlinkInfo(Item1);
  MCMlinkInfo2 := PTSQMCMlinkInfo(Item2);
  if (MCMlinkInfo1.SchedStart < MCMlinkInfo2.SchedStart) then
    Result := -1
  else if (MCMlinkInfo1.SchedStart = MCMlinkInfo2.SchedStart) then
  begin
    if (MCMlinkInfo1.SchedEnd < MCMlinkInfo2.SchedEnd) then
      Result := -1
    else if (MCMlinkInfo1.SchedEnd = MCMlinkInfo2.SchedEnd) then
      Result := 0
    else
      Result := 1;
  end
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

constructor TAutoSchedThread.CreateAutoSchedTread(AOwner: Tcomponent; ObjList: TMSchedList; IsPrevHighDateVisible : boolean; IsNextLowDateVisible : boolean; ManagerResList : TList);
var
  I : Integer;
  Id : TSchedId;
begin
  inherited Create(False);
  m_ObjListInfo := TList.Create;
  FreeOnTerminate := True;
  m_ResIndexSorted := false;
  OnTerminate := FAutoSched.ThreadDone;
  m_ObjList  := ObjList;

  if AutoSchedCfg.m_OverridingParams_Activated and
         AutoSchedCfg.m_OverridingParams_AllowedMoveLinkedReq and
         AutoSchedCfg.m_OverridingParams_Wc_Selected then
     AddConnectedReqToList;

  m_ManagerResList := ManagerResList;
  m_Active := true;
  m_IsPrevHighDateVisible := IsPrevHighDateVisible;
  m_IsNextLowDateVisible  := IsNextLowDateVisible;
  m_ShcheduledJobs := false;
  AutoSchedCfg.m_TempMatListStart    := TList.Create;
  AutoSchedCfg.m_TempMatListEnd      := TList.Create;
  AutoSchedCfg.m_TempAddResListStart := TList.Create;
  AutoSchedCfg.m_TempAddResListEnd   := TList.Create;
  AutoSchedCfg.m_TempAddResNeededTillEndExec := TList.Create;
  AutoSchedCfg.m_ListOfScoreAdditional := TList.Create;
  AutoSchedCfg.m_ListOfJobToJobDefinitions := TList.Create;

  m_LogInfoList.Clear;
  LoadScoreAdditionalFromDB(AutoSchedCfg.m_ListOfScoreAdditional, AutoSchedCfg.m_CfgName);
//  LoadSpecificDateTimeFromDB(AutoSchedCfg.m_CfgName);
  LoadJobToJobDefinitionsFromDB(AutoSchedCfg.m_ListOfJobToJobDefinitions, AutoSchedCfg.m_CfgName);

  if AutoSchedCfg.m_LoadedOnSameResCat then
    AutoSchedCfg.m_CatResList := TStringList.Create;

  if AutoSchedCfg.m_MaxJobJobComp < AutoSchedCfg.m_MinJobJobComp then
  begin
    AutoSchedCfg.m_MinJobJobComp := 0;
    AutoSchedCfg.m_MaxJobJobComp := 98;
  end;

  AutoSchedTread := self;
end;

//----------------------------------------------------------------------------//

destructor TAutoSchedThread.Destroy;
var
  I : Integer;
begin
  AutoSchedCfg.m_TempMatListStart.free;
  AutoSchedCfg.m_TempMatListEnd.free;
  AutoSchedCfg.m_TempAddResListStart.free;
  AutoSchedCfg.m_TempAddResListEnd.free;
  AutoSchedCfg.m_TempAddResNeededTillEndExec.free;

  for I := AutoSchedCfg.m_ListOfScoreAdditional.Count - 1 downto 0 do
    dispose(PTScoreAddition(AutoSchedCfg.m_ListOfScoreAdditional[I]));
  AutoSchedCfg.m_ListOfScoreAdditional.free;

  for I := AutoSchedCfg.m_ListOfJobToJobDefinitions.Count - 1 downto 0 do
    dispose(PTJobToJobDefinitions(AutoSchedCfg.m_ListOfJobToJobDefinitions[I]));
  AutoSchedCfg.m_ListOfJobToJobDefinitions.free;

  if AutoSchedCfg.m_LoadedOnSameResCat then
    AutoSchedCfg.m_CatResList.free;

  if not m_ShcheduledJobs then
    if p_pl.GetCompatModeInPlanId <> CSchedIdNull then
       p_pl.ExitCompatModeInPlanForAutoSeq; // OccMoveExit(FMQMPlan, true);
  for I := m_ObjListInfo.Count - 1 downto 0 do
    Dispose(PTIdDetails(m_ObjListInfo[I]));
  m_ObjListInfo.Free;

  AutoSchedTread := nil;
  inherited Destroy;
end;

//----------------------------------------------------------------------------//

procedure TAutoSchedThread.Execute;
begin
  while true do
  begin
    StartAutomaticSequencingRunningForWard;
    break;
  end;
end;

//----------------------------------------------------------------------------//

function SortInfoList(Item1, Item2: Pointer): Integer;
var
  IdDetail1, IdDetail2 : PTIdDetails;
begin
  IdDetail1 := PTIdDetails(Item1);
  IdDetail2 := PTIdDetails(Item2);

  if IdDetail1.level > IdDetail2.level then
    Result := 1
  else if IdDetail1.level < IdDetail2.level then
    Result := -1
  else
  begin
    if IdDetail1.ServeGroupCode > IdDetail2.ServeGroupCode then
      Result := 1
    else if IdDetail1.ServeGroupCode < IdDetail2.ServeGroupCode then
      Result := -1
    else
      Result := 0;
  end
end;

//----------------------------------------------------------------------------//

procedure TAutoSchedThread.AddConnectedReqToList;
var
  I, J, IdxLevelBefore : Integer;
  IdDetail : PTIdDetails;
  ProdNo : string;
  value: variant;
  dataType: CBinColValType;
  StepInfo: TSQStepInfo;
  SchedIdsList : TMSchedList;
  ID : TSchedId;
begin
  SchedIdsList := TMSchedList.Create(self);

  for I := 0 to m_ObjList.GetLinkCount - 1 do
  begin
    new(IdDetail);
    IdDetail.level := 0;
    IdDetail.Id := m_ObjList.GetLink(I);
    IdDetail.ServeGroupCode := p_sc.GetServingGroupCode(IdDetail.Id, false, nil);
    m_ObjListInfo.Add(IdDetail);
  end;

  I := -1;
  while True do
  begin
    I := I + 1;
    if I > m_ObjList.GetLinkCount - 1 then break;
    SchedIdsList.ClearList;
    ProdNo := p_sc.GetFldDescr(m_ObjList.GetLink(I), CSC_ProdReq, false);
    p_sc.GetFldValue(m_ObjList.GetLink(I), CSC_ProdStep, value, dataType);

    if (PTIdDetails(m_ObjListInfo[I]).level < 1) then
    begin
      if p_sc.GetPrecStepToSched(ProdNo, value, StepInfo) then
      begin
        if Assigned(StepInfo.ReqDet) then
          p_sc.GetStepJobs(ProdNo, StepInfo.StepNo, SchedIdsList);
      end
      else
        p_sc.GetPrevConnReqLastStepJobs(m_ObjList.GetLink(I), SchedIdsList);
    end;

    IdxLevelBefore := SchedIdsList.GetLinkCount;

    if (PTIdDetails(m_ObjListInfo[I]).level > -1) then
    begin
      if p_sc.GetNextStepToSched(ProdNo, value, StepInfo) then
      begin
        if Assigned(StepInfo.ReqDet) then
          p_sc.GetStepJobs(ProdNo, StepInfo.StepNo, SchedIdsList);
      end
      else
        p_sc.GetNextConnReqFirstStepJobs(m_ObjList.GetLink(I), SchedIdsList);
    end;

    for J := 0 to SchedIdsList.GetLinkCount - 1 do
    begin
      if p_sc.GetExtLinkPtr(SchedIdsList.GetLink(J)) = nil then continue;
      // if belongs to group to add
      // avi
      if m_ObjList.IndexOf(SchedIdsList.GetLink(J)) > -1 then continue;
      m_ObjList.AddLink(SchedIdsList.GetLink(J));
      new(IdDetail);
      if (J + 1) > IdxLevelBefore then
        IdDetail.level := PTIdDetails(m_ObjListInfo[I]).level + 1
      else
        IdDetail.level := PTIdDetails(m_ObjListInfo[I]).level - 1;
      IdDetail.Id := SchedIdsList.GetLink(J);
      IdDetail.ServeGroupCode := p_sc.GetServingGroupCode(IdDetail.Id, false, nil);
      m_ObjListInfo.Add(IdDetail);
    end;
  end;

  m_ObjListInfo.sort(SortInfoList);

  if AutoSchedCfg.m_OverridingParams_Activated and AutoSchedCfg.m_OverridingParams_UnscheduleBefore then
  begin
    for I := 0 to m_ObjListInfo.Count - 1 do
    begin
      Id := PTIdDetails(m_ObjListInfo[I]).Id;
      if Assigned(p_sc.GetExtLinkPtr(Id)) then
      begin
        MoveToBin(Id, false)
      end;
    end;
  end;

  m_ObjList.ClearList;
  for I := 0 to m_ObjListInfo.Count - 1 do
    m_ObjList.AddLink(PTIdDetails(m_ObjListInfo[I]).Id);

end;

//----------------------------------------------------------------------------//

procedure SearchFamilyRelative(Id : TSchedId; var FoundSonId : boolean; var SonId : TSchedId);
var
  SplitInfo: TSQSplitInfo;
begin
  p_sc.GetSplitInfo(Id, SplitInfo);
  if SplitInfo.SplitAllow = CSB_father then
  //  FoundSonId := p_sc.SearchFatherOrSonForSplitFamily(SplitInfo.SplitFamilyCode, CSB_Son, SonId);
  if FoundSonId then
  begin
    if Assigned(p_sc.GetExtLinkPtr(SonId)) then
    begin
      FoundSonId := false;
      SonId := CSchedIDnull;
    end;
  end;

end;

//----------------------------------------------------------------------------//

function GetAutoSeqLogInfoList : TStringList;
begin
  Result := m_LogInfoList;
end;

//----------------------------------------------------------------------------//

procedure TAutoSchedThread.CleanAllAutoSeqHandled;
var
  I : Integer;
begin
  for I := 0 to m_ObjList.GetLinkCount - 1 do
    p_sc.SetAutoSeqHandled(m_ObjList.GetLink(I), false);
end;

//----------------------------------------------------------------------------//

procedure TAutoSchedThread.SetAllAutoSeqHandled;
var
  I : Integer;
  Id, PrevId : TSchedId;
begin
  PreviD := CSchedIDnull;
  for I := 0 to m_ObjList.GetLinkCount - 1 do
  begin
    Id := m_objList.GetLink(i);
    if (PreviD <> CSchedIDnull) then
    begin
      p_sc.SetAutoSeqPrevNextIds(Id, PrevId,true);
      p_sc.SetAutoSeqPrevNextIds(PrevId, Id, false);
    end
    else
      p_sc.SetAutoSeqPrevNextIds(Id, CSchedIDnull, true);

    PrevId := Id;
    p_sc.SetAutoSeqHandled(Id, true);
  end;
end;

//----------------------------------------------------------------------------//

procedure TAutoSchedThread.StartAutomaticSequencingRunningForWard;
var
  PlanInfo : TSQplanInfo;
  Id, NextId, ChildId : TSchedID;
  Year, Month, Day, Hour, Minute, Second, milisecond : Word;
  StartTime: double;
  FirstId, EndLoop, FirstCycle, IdReached, HandlePlants, LoopOnPlants, AllScheduled : boolean;
  ResManager : TResourcesManager;
  GroupCfg, PrevPlannedWorkCenter, WorkCenter : string;
  ListAutomaticSeqName : TStringList;
  CurrentSchedCfg : PTAutoSchedCfg;
  SaveCurrCfg, SavedSameWcCfg : TAutoSchedCfg;
  NumOfSchedJobs, NumOfNonSchedJobs, NumberOfTry, IdxToSched : integer;
  TotalScore, ScoreChange, NewScoreLocal : double;
  ScoreRecord, ReturnScoreRecordIdToPrevId : TScoreRecord;
  GenericPlanDates : Tlist;
  TolleranceHoursComparison : double;
  S, I, LogNumber : Integer;
  LogName, LogTime : string;
  PrevServeCode, ServeCode, NextServeCode : String;
  ServeCodeLimitStart, HighestPrevEndFoundLocal, SlotStart, SlotEnd : TDateTime;
  ServeCodeIdsList, TestedServingCodeIdsList, IdsToLoopOn : TMSchedList;
  ServeCodeCanMove, CheckSplitJob, IsNewId, CanBeNewId : Boolean;

  UnscheduleAlreadyInGanttIndex : Integer;
  AtLeastOneScheduled, OtherIdsAreInTheFamily : boolean;
  TempScore : Double;
  TempNumOfSchedJobs : Integer;

  PlantCode, BestPlantCode : string;
  PlantsToCheckList : TStringList;
  IndexPlants : Integer;
  BestPlantScore : Double;
  BestPlantJobSched : Integer;
  ScoreAfterLastFound, ScoreBeforeLastJobFound : boolean;
  PlanedWorkCenter, Req : variant;
  dataType: CBinColValType;
  SplitInfo: TSQSplitInfo;
  IdDetails : PTIdDetails;

  //*---------------------------
  Procedure getNextIdToSchedule;
  //*---------------------------
  var
    srvLoadOn, canRead, canWrite, isUpdating: boolean;
    Val : variant;
    dataType: CBinColValType;
    SubProg, PrevSubProg  : Integer;
    CurrentTime, TmpSeconds : double;
    ElapsedHH,ElapsedMM,ElapsedSS : integer;
    FirstIdFound, LastFoundId, NextIdToBeUsed : TSchedId;
    RequestStepsToReLoadResources : PTRequestStepsToReLoadResources;
    FoundIndex : integer;
    SkipToTheNextId : boolean;
  begin
    repeat    //Check if the server is updating
      GetStatus(srvLoadOn, canRead, canWrite, isUpdating);
      if isUpdating then sleep(500);
    until not isUpdating;

    while True do
    begin
      EndLoop := true;

      if FirstId then
      begin
        NumOfNonSchedJobs := 0;
        id := TSchedID(m_ObjList.GetLink(0));
        DecodeTime(now, hour, minute, second, milisecond);
        StartTime := (hour * 3600) + (minute * 60) + second;
        FAutoSched.SetStartTime(StartTime);
        FirstId := false;
      end
      else
      begin
        Id := p_sc.GetAutoSeqNextIdToSched(id);
      end;

      FirstIdFound := Id;
      LastFoundId := Id;
      while True do
      begin
        Application.ProcessMessages;
        if Terminated then Exit;
        if Id = CSchedIDnull then Exit;
        SkipToTheNextId := false;
        RequestStepsToReLoadResources := nil;
        if not p_sc.CheckPriorityTosched(Id, nil) then SkipToTheNextId := true;
        if not SkipToTheNextId then
        begin
          RequestStepsToReLoadResources := FindRequestStepToReLoadResourcesInList(Id, ResManager.m_ListOfRequestStepsToReLoadResources, FoundIndex);
          if  (RequestStepsToReLoadResources <> nil)
          and RequestStepsToReLoadResources.ReCheckResources
          and not RequestStepsToReLoadResources.ReLoadResources then
            SkipToTheNextId := true
          else
          begin
            if ResManager.NoneCompetibleSomeBecauseOfDependency(Id, '', '') then
            begin
              SkipToTheNextId := true;
              if RequestStepsToReLoadResources = nil then
                ResManager.AddRequestStepToReLoadResourcesList(Id, true, false, FoundIndex)
              else
              begin
                RequestStepsToReLoadResources.ReCheckResources := true;
                RequestStepsToReLoadResources.ReLoadResources := false;
              end;
            end;
          end;
        end;
        if not SkipToTheNextId then
        begin
          if RequestStepsToReLoadResources <> nil then
            ResManager.RemoveRequestStepToReLoadResourcesList(FoundIndex);
          break;
        end;
        LastFoundId := Id;
        Id := p_sc.GetAutoSeqNextIdToSched(id);
      end;

      if Id <> FirstIdFound then
      begin
        NextIdToBeUsed := p_sc.GetAutoSeqNextIdToSched(id);
        p_sc.SetAutoSeqPrevNextIds(Id, FirstIdFound, false);
        p_sc.SetAutoSeqPrevNextIds(FirstIdFound, Id, true);
        p_sc.SetAutoSeqPrevNextIds(LastFoundId, NextIdToBeUsed, false);
        if NextIdToBeUsed <> CSchedIDnull then
          p_sc.SetAutoSeqPrevNextIds(NextIdToBeUsed, LastFoundId, true);
      end;

      EndLoop := false;

      PrevSubProg := Trunc((NumOfNonSchedJobs-1)/m_ObjList.GetLinkCount*100);
      SubProg := Trunc(NumOfNonSchedJobs/m_ObjList.GetLinkCount*100);
      if (SubProg > 0) and (PrevSubProg <> SubProg) then
      begin
        DecodeTime(now, hour, minute, second, milisecond);
        CurrentTime := (hour * 3600) + (minute * 60) + second;
        TmpSeconds := CurrentTime - StartTime;
        ElapsedHH := trunc(TmpSeconds / 3600);
        TmpSeconds := TmpSeconds - (ElapsedHH * 3600);
        ElapsedMM := trunc(TmpSeconds / 60);
        TmpSeconds := TmpSeconds - (ElapsedMM * 60);
        ElapsedSS := trunc(TmpSeconds);
        if Assigned(FAutoSched) then
           FAutoSched.SetObj(SubProg,ElapsedHH,ElapsedMM,ElapsedSS, ListAutomaticSeqName.Strings[ ListAutomaticSeqName.Count -1]);
      end;

      inc(NumOfNonSchedJobs);

      p_sc.SetAutoSeqHandled(Id, false);
      if (p_sc.IsProgressed(id) <> prg_none) then continue;
      P_sc.GetFldValue(id, CSC_IniQty, Val, dataType);
      if val = 0 then continue;
      p_sc.GetFldValue(id, CSC_FinQty, Val, dataType);
      if val = 0 then continue;

      ResManager.AddIdToBackupList(id, '', nil);
      break;

    end;
  end;

  //*--------------------------------
  Procedure ScheduleIdOrServingGroup;
  //*--------------------------------
  var
    ReSchedServeCode, FirstIdHighestSchedPossible, FindFirstPossiblePlace : Boolean;
    SaveIdIntern, MainIdHandled, IdToRemove : TSchedID;
    DummyServeCode : String;
    NewScore : double;
    LowestServeCodeStart, HighestServeCodeStart, HighestPrevEndFound, DummyDate : TDateTime;
    IndexRemove, ServeCodeIdsIndex, PosToAdd : Integer;
//    LowestMinQty, HighestMaxQty : Double;
    OrigJobQty: variant;
    dataType: CBinColValType;
    NewId, NewGrpId : TSchedId;
    I : integer;
    List    : TList;
    RollBackInfo : PTJobToSched;
    TempQty, PercentQty : double;
    LowestMinimumQuantity, LowestOptimumQuantity : currency;
    JobQty : Currency;
    SplitPossible, KeepTheSplit : Boolean;
    MinMaxOptQtyList : Tlist;
    IndexMinMaxOpt, Index, RollBackCount : Integer;
    ListOfSplits : TStringList;
    UnschedWithError : boolean;
    SaveTimeOfNow : TDateTime;
    DecMult : integer;
    //*--------------------------------
    Procedure AddSplitToRolbackList(SchedType : TSchedType);
    //*--------------------------------
    begin
      new(RollBackInfo);
      RollBackInfo.SchedType := SchedType;
      RollBackInfo.Id := id;
      RollBackInfo.NewId := NewId;
      RollBackInfo.ResourceManagerPtr := ResManager;
      GetRollBackList.add(RollBackInfo);
    end;

    //*---------------------------------------------------------
    function SplitAndBalancingAllCalc(ListQtyOptions : Tlist; NbrOfOptMinMax : integer) : boolean;
    //*----------------------------------------------------------
    var
      Percent, PercentDifference, BestPercent, BestDiff, Diff, TotalMin : double;
      QuantityLeft, JobQuantity, TotalQuantity, TotalQuantityForBestPercent, Quantity, ReduceFromQtyLeft : Currency;
      IInt, NumberOfBatches, QtyInt, I, TotalNbrOfBatches : integer;
      POptionToSplit : PTOptionToSplit;
    begin
      Result := false;
      QtyInt := trunc(JobQty * DecMult);
      JobQuantity := QtyInt / DecMult;

      TotalMin := 0;
      TotalQuantity := 0;
      Percent := 1/1000;  // Upto accuracy of 0.001%
      TotalNbrOfBatches := 0;
      for IInt := 0 to NbrOfOptMinMax do
      begin
        NumberOfBatches := PTMinMaxOptQty(MinMaxOptQtyList[IInt]).NbrOfBacthes;
        TotalNbrOfBatches := TotalNbrOfBatches + NumberOfBatches;
        QtyInt := trunc(PTMinMaxOptQty(MinMaxOptQtyList[IInt]).OptQty * Percent);
        Quantity := QtyInt / 100;
        TotalMin := TotalMin + (Quantity * NumberOfBatches);
        TotalQuantity := TotalQuantity + (PTMinMaxOptQty(MinMaxOptQtyList[IInt]).OptQty * NumberOfBatches);
      end;
      if (TotalQuantity < JobQuantity) then exit;
      if (TotalMin > JobQuantity) then exit;

      Percent := 100;
      PercentDifference := 50;
      BestDiff := 99999999999;
      BestPercent := Percent;
      TotalQuantityForBestPercent := 0;
      while True do
      begin
        TotalQuantity := 0;
        for IInt := 0 to NbrOfOptMinMax do
        begin
          NumberOfBatches := PTMinMaxOptQty(MinMaxOptQtyList[IInt]).NbrOfBacthes;
          QtyInt := trunc(PTMinMaxOptQty(MinMaxOptQtyList[IInt]).OptQty * Percent);
          Quantity := QtyInt / 100;
          TotalQuantity := TotalQuantity + (Quantity * NumberOfBatches);
        end;
        Diff := abs(TotalQuantity - JobQuantity);
        if BestDiff > Diff then
        begin
          BestDiff := Diff;
          BestPercent := Percent;
          TotalQuantityForBestPercent := TotalQuantity;
        end;
        if Diff < 0.01 then break;
        if PercentDifference < 0.001 then break;
        if (TotalQuantity > JobQuantity) then
          Percent := Percent - PercentDifference
        else
          Percent := Percent + PercentDifference;
        PercentDifference := PercentDifference / 2;
      end;

      QuantityLeft := JobQuantity - TotalQuantityForBestPercent;
      QtyInt := trunc(QuantityLeft / TotalNbrOfBatches);
      if QuantityLeft > 0 then
        ReduceFromQtyLeft := QtyInt + 0.01
      else
        ReduceFromQtyLeft := QtyInt - 0.01;
      new(POptionToSplit);
      POptionToSplit.SplitsList := TStringList.Create;
      for IInt := 0 to NbrOfOptMinMax do
      begin
        NumberOfBatches := PTMinMaxOptQty(MinMaxOptQtyList[IInt]).NbrOfBacthes;
        QtyInt := trunc(PTMinMaxOptQty(MinMaxOptQtyList[IInt]).OptQty * BestPercent);
        Quantity := QtyInt / 100;
        for I := 1 to NumberOfBatches do
        begin
          if abs(ReduceFromQtyLeft) > abs(QuantityLeft) then
            ReduceFromQtyLeft := QuantityLeft;
          POptionToSplit.SplitsList.Add(FloatToStr(Quantity+ReduceFromQtyLeft));
          QuantityLeft := QuantityLeft - ReduceFromQtyLeft;
        end;
      end;
      ListQtyOptions.Add(POptionToSplit);
      Result := true;

    end;
    //*---------------------------------------------------------
    Procedure SplitAndBalancingAllRecursive(ListQtyOptions : Tlist; NbrOfOptMinMax, Index : integer);
    //*----------------------------------------------------------
    var
      MinimumNumberOfBatches, MaximumNumberOfBatches, IInt, NumberOfBatches, QtyInt : integer;
      TotalMin, TotalOpt, JobQuantity : double;

    begin

      if ((Now - SaveTimeOfNow) > (1 / 24 / 60 * 1)) then
        exit;

      QtyInt := trunc(JobQty * DecMult);
      JobQuantity := QtyInt / DecMult;

      TotalMin := 0;
      TotalOpt := 0;
      for IInt := 0 to Index - 1 do
      begin
        NumberOfBatches := PTMinMaxOptQty(MinMaxOptQtyList[IInt]).NbrOfBacthes;
        TotalMin := TotalMin + (PTMinMaxOptQty(MinMaxOptQtyList[IInt]).MinQty * NumberOfBatches);
        TotalOpt := TotalOpt + (PTMinMaxOptQty(MinMaxOptQtyList[IInt]).OptQty * NumberOfBatches);
      end;
      if (JobQuantity > TotalOpt) and (Index = NbrOfOptMinMax) then
        MinimumNumberOfBatches :=  trunc((JobQty-TotalOpt) / PTMinMaxOptQty(MinMaxOptQtyList[Index]).OptQty)
      else
        MinimumNumberOfBatches := 0;

      if JobQuantity > TotalMin then
        MaximumNumberOfBatches :=  trunc((JobQty-TotalMin) / PTMinMaxOptQty(MinMaxOptQtyList[Index]).MinQty)
      else
        MaximumNumberOfBatches := 0;

      while True do
      begin
        PTMinMaxOptQty(MinMaxOptQtyList[Index]).NbrOfBacthes := MinimumNumberOfBatches;
        if Index = NbrOfOptMinMax then
        begin
          if SplitAndBalancingAllCalc(ListQtyOptions, NbrOfOptMinMax) then
            exit;
        end
        else
          SplitAndBalancingAllRecursive(ListQtyOptions, NbrOfOptMinMax, Index + 1);
        MinimumNumberOfBatches := MinimumNumberOfBatches + 1;
        if MinimumNumberOfBatches > MaximumNumberOfBatches then break;
      end;
    end;

    //*---------------------------------------------------------
    Procedure SplitNewJobsByOptimums(ListQtyOptions : Tlist);
    //*----------------------------------------------------------
    var
      ExtraQty, LastExtraDifference, TotalQty, RemainQty, ExtraQtyDivider : double;
      MakeSenseNbrOfBatches, PrevNbrOfBatches, NbrOfBatches : integer;
      NbrOfOptMinMax, CurrentIndex, IInt, IInt1, NbrOfExtraBatches : integer;
      QtyFound, First : boolean;
      POptionToSplit : PTOptionToSplit;
    begin
      ExtraQty := 0;
      LastExtraDifference := 0;
      NbrOfOptMinMax := MinMaxOptQtyList.Count - 1;
      CurrentIndex := 0;

     { for IInt := 0 to NbrOfOptMinMax do
      begin
        if JobQty > PTMinMaxOptQty(MinMaxOptQtyList[IInt]).OptQty then break;
      end;
      if (IInt = 0) and (NbrOfOptMinMax > 0) then
      begin
        if JobQty > (PTMinMaxOptQty(MinMaxOptQtyList[IInt]).OptQty * 20) then
          IInt := IInt + 1
        else
          IInt := IInt + 2;
      end
      else
      begin
        IInt := IInt + 4;
      end;
      if IInt < NbrOfOptMinMax then
        NbrOfOptMinMax := IInt;  }

      for IInt := 0 to NbrOfOptMinMax do
      begin
        if JobQty >= PTMinMaxOptQty(MinMaxOptQtyList[IInt]).OptQty then break;
      end;
      MakeSenseNbrOfBatches := trunc(JobQty / PTMinMaxOptQty(MinMaxOptQtyList[IInt]).OptQty) * 20;
        
      // The logic uses the assumption that the lowest optimum size has also the lowest minimum quantity

      if (NbrOfOptMinMax > 0) then // There is more then one optimum
      begin
        CurrentIndex :=  NbrOfOptMinMax-1;
        PTMinMaxOptQty(MinMaxOptQtyList[CurrentIndex]).NbrOfBacthes := -1;
      end;

      while True do
      begin
        if CurrentIndex < 0 then break;
        if (NbrOfOptMinMax > 0) then
        begin
          TotalQty := 0;
          for IInt := 0 to NbrOfOptMinMax - 1 do
          begin
            if PTMinMaxOptQty(MinMaxOptQtyList[IInt]).NbrOfBacthes > 0 then
              TotalQty := TotalQty +
                (PTMinMaxOptQty(MinMaxOptQtyList[IInt]).NbrOfBacthes *
                   PTMinMaxOptQty(MinMaxOptQtyList[IInt]).OptQty);
          end;
          RemainQty := JobQty - TotalQty;

          if PTMinMaxOptQty(MinMaxOptQtyList[CurrentIndex]).NbrOfBacthes > 0 then
            NbrOfBatches := PTMinMaxOptQty(MinMaxOptQtyList[CurrentIndex]).NbrOfBacthes + 1
          else
          begin
            NbrOfBatches := trunc(RemainQty / PTMinMaxOptQty(MinMaxOptQtyList[CurrentIndex]).OptQty) - 2; // 2 is just a number to leave more options for the remaining
            if NbrOfBatches <= 0 then
              NbrOfBatches := 1;
          end;
          PrevNbrOfBatches := PTMinMaxOptQty(MinMaxOptQtyList[CurrentIndex]).NbrOfBacthes;
          if PrevNbrOfBatches < 0 then
            PrevNbrOfBatches := 0;
          PTMinMaxOptQty(MinMaxOptQtyList[CurrentIndex]).NbrOfBacthes := NbrOfBatches;
          
          RemainQty := RemainQty - (NbrOfBatches - PrevNbrOfBatches) * PTMinMaxOptQty(MinMaxOptQtyList[CurrentIndex]).OptQty;
          if (RemainQty <> 0) and (RemainQty < PTMinMaxOptQty(MinMaxOptQtyList[NbrOfOptMinMax]).MinQty) then
          begin
            PTMinMaxOptQty(MinMaxOptQtyList[CurrentIndex]).NbrOfBacthes := 0;
            CurrentIndex := CurrentIndex - 1;
            if CurrentIndex < 0 then break;
            Continue;
          end;
          CurrentIndex :=  NbrOfOptMinMax-1;
        end
        else
        begin
          RemainQty := JobQty;
          CurrentIndex := -1;
        end;

        PTMinMaxOptQty(MinMaxOptQtyList[NbrOfOptMinMax]).NbrOfBacthes := 0;
        ExtraQtyDivider := 0;
        QtyFound := true;

        if RemainQty > 0 then
        begin
          for IInt := 0 to NbrOfOptMinMax do
          begin
            if  (RemainQty < PTMinMaxOptQty(MinMaxOptQtyList[IInt]).MinQty) then continue;
            if  (PTMinMaxOptQty(MinMaxOptQtyList[IInt]).MaxQty > 0)
            and (RemainQty > PTMinMaxOptQty(MinMaxOptQtyList[IInt]).MaxQty) then continue;
            ExtraQtyDivider := 1;
            ExtraQty := RemainQty;
            RemainQty := 0;
            break;
          end;
        end;

        NbrOfBatches := 0;
        for IInt := 0 to NbrOfOptMinMax - 1 do
        begin
          if PTMinMaxOptQty(MinMaxOptQtyList[IInt]).NbrOfBacthes > 0 then
            NbrOfBatches := NbrOfBatches + PTMinMaxOptQty(MinMaxOptQtyList[IInt]).NbrOfBacthes; 
        end;
        if NbrOfBatches > MakeSenseNbrOfBatches then
          QtyFound := false;
          
        if QtyFound and (RemainQty > 0) then
        begin
          QtyFound := false;
          NbrOfExtraBatches :=  trunc(RemainQty / PTMinMaxOptQty(MinMaxOptQtyList[NbrOfOptMinMax]).OptQty) + 1;
          while True do
          begin
            ExtraQty := 0;
            ExtraQtyDivider := 0;
            NbrOfExtraBatches := NbrOfExtraBatches - 1;
            if NbrOfExtraBatches < 0 then break;
            TempQty := NbrOfExtraBatches *  PTMinMaxOptQty(MinMaxOptQtyList[NbrOfOptMinMax]).OptQty;
            if (RemainQty - TempQty) <  PTMinMaxOptQty(MinMaxOptQtyList[NbrOfOptMinMax]).MinQty then continue;
            if (RemainQty - TempQty) <= PTMinMaxOptQty(MinMaxOptQtyList[NbrOfOptMinMax]).MaxQty then
            begin
              PTMinMaxOptQty(MinMaxOptQtyList[NbrOfOptMinMax]).NbrOfBacthes := NbrOfExtraBatches;
              if (RemainQty - TempQty) > 0 then
              begin
                ExtraQty := (RemainQty - TempQty);
                ExtraQtyDivider := 1;
                LastExtraDifference := 0;
              end;
              QtyFound := true;
              break;
            end;

            ExtraQty := RemainQty - TempQty;
            ExtraQtyDivider := 1;

            for IInt := 0 to NbrOfOptMinMax do
            begin
              if  (ExtraQty >= PTMinMaxOptQty(MinMaxOptQtyList[IInt]).MinQty)
              and ((PTMinMaxOptQty(MinMaxOptQtyList[IInt]).MaxQty = 0)
                 or (ExtraQty <= PTMinMaxOptQty(MinMaxOptQtyList[IInt]).MaxQty)) then
              begin
                PTMinMaxOptQty(MinMaxOptQtyList[NbrOfOptMinMax]).NbrOfBacthes := NbrOfExtraBatches;
                QtyFound := true;
                LastExtraDifference := 0;
                break;
              end;
            end;
            if QtyFound then break;

            while True do
            begin
              ExtraQtyDivider := ExtraQtyDivider + 1;
              TempQty := trunc(ExtraQty / ExtraQtyDivider * DecMult);
              TempQty := TempQty / DecMult;
              if TempQty < PTMinMaxOptQty(MinMaxOptQtyList[NbrOfOptMinMax]).MinQty then break;
              if TempQty > PTMinMaxOptQty(MinMaxOptQtyList[NbrOfOptMinMax]).MaxQty then continue;
              LastExtraDifference := ExtraQty - (TempQty * ExtraQtyDivider);
              TempQty := TempQty + LastExtraDifference;
              if TempQty > PTMinMaxOptQty(MinMaxOptQtyList[NbrOfOptMinMax]).MaxQty then continue;
              PTMinMaxOptQty(MinMaxOptQtyList[NbrOfOptMinMax]).NbrOfBacthes := NbrOfExtraBatches;
              QtyFound := true;
              break;
            end;
            if QtyFound then break;
          end;
        end;
       
        if QtyFound then
        begin
          new(POptionToSplit);
          POptionToSplit.SplitsList := TStringList.Create;
          for IInt := 0 to NbrOfOptMinMax do
          begin
            IInt1 := PTMinMaxOptQty(MinMaxOptQtyList[IInt]).NbrOfBacthes;
            TempQty := PTMinMaxOptQty(MinMaxOptQtyList[IInt]).OptQty;
            while IInt1 > 0 do
            begin
              POptionToSplit.SplitsList.Add(FloatToStr(TempQty));
              IInt1 := IInt1 - 1;
            end;
          end;

          if ExtraQtyDivider > 0 then
          begin
            TempQty := trunc(ExtraQty / ExtraQtyDivider * DecMult);
            TempQty := TempQty / DecMult;
          end;

          while ExtraQtyDivider > 0 do
          begin
            POptionToSplit.SplitsList.Add(FloatToStr(TempQty + LastExtraDifference));
            LastExtraDifference := 0;
            ExtraQtyDivider := ExtraQtyDivider - 1;
          end;

           ListQtyOptions.Add(POptionToSplit);
           if (NbrOfOptMinMax = 0) then break;
        end;
      end;

    end;

     //*-------------------------------------------------------------
    Procedure SplitNewJobsByEqualQuantities(ListQtyOptions : Tlist);
    //*--------------------------------------------------------------
    var
      NbrOfOptMinMax, Divider, IInt : integer;
      AtLEastOneQtyAboveTheMinimum, QuantityMatchesAtLeastOneMachine : boolean;
      POptionToSplit : PTOptionToSplit;
      RemainQty : double;
    begin
      NbrOfOptMinMax := MinMaxOptQtyList.Count - 1;
      Divider := 1;
      while true do
      begin
        AtLEastOneQtyAboveTheMinimum := false;
        QuantityMatchesAtLeastOneMachine := false;
        inc(Divider);
        TempQty := trunc(JobQty / Divider * DecMult);
        TempQty := TempQty / DecMult;
        if TempQty < 1 then break;
        for IInt := 0 to NbrOfOptMinMax do
        begin
          if (PTMinMaxOptQty(MinMaxOptQtyList[IInt]).MinQty <=0 ) then continue; // If minimum is not limited - there can be many splits.
          if PTMinMaxOptQty(MinMaxOptQtyList[IInt]).MachineSizeUsed then continue; // use once each machine size
          if (JobQty > PTMinMaxOptQty(MinMaxOptQtyList[IInt]).MinQty) then
            AtLEastOneQtyAboveTheMinimum := true;
          if  (TempQty >= PTMinMaxOptQty(MinMaxOptQtyList[IInt]).MinQty)
          and ((PTMinMaxOptQty(MinMaxOptQtyList[IInt]).MaxQty = 0)
                or (TempQty <= PTMinMaxOptQty(MinMaxOptQtyList[IInt]).MaxQty)) then
          begin
            QuantityMatchesAtLeastOneMachine := true;
            PTMinMaxOptQty(MinMaxOptQtyList[IInt]).MachineSizeUsed := true;
          end;
        end;
        if not AtLEastOneQtyAboveTheMinimum then break;
        if not QuantityMatchesAtLeastOneMachine then continue;
        RemainQty :=  JobQty;
        new(POptionToSplit);
        POptionToSplit.SplitsList := TStringList.Create;
        for IInt := 1 to Divider - 1 do
        begin
          POptionToSplit.SplitsList.Add(FloatToStr(TempQty));
          RemainQty := RemainQty - TempQty;
        end;
        POptionToSplit.SplitsList.Add(FloatToStr(RemainQty));
        ListQtyOptions.Add(POptionToSplit);
      end;
    end;

    //*--------------------------------
    Procedure SplitToNewJobs;
    //*--------------------------------
    var
      RemainQty : double;
      IInt, IInt1, NbrOfOptMinMax, CurrentIndex, RollBackCountIntern, BestScoreIndex, LowestNumberOfJobs : integer;
      QtyFound, PlaceFound, AtLeastOneQtyAboveTheMinimum, BetterPlace : boolean;
      ListQtyOptions : Tlist;
      J : Integer;
      BestScore, TotalSplitScore, PenaltyDateScore : double;
    begin
      if FAutoSched.m_OperatedAbort then
        exit;
      if (AutoSchedCfg.m_SplitSchedByBatchSize = LongestDurationPossible) then exit;
      if AutoSchedCfg.m_OverridingParams_Activated and AutoSchedCfg.m_OverridingParams_UnscheduleBefore then exit;
      DecMult := Round(IntPower(10, p_sc.GetJobNumOfDecimals(Id)));
      p_sc.GetFldValue(Id, CSC_QtyToSched, OrigJobQty, dataType);
      JobQty := OrigJobQty;
      SplitPossible := false;
      CurrentIndex := 0;

      if MinMaxOptQtyList.Count = 0 then exit;
      p_sc.GetPlanInfo(Id, PlanInfo);
      if PlanInfo.isGroup then
      begin
        for J := 0 to p_sc.GetGrpNumSons(Id) - 1 do
        begin
          ChildId := p_sc.GetGrpSon(Id, J);
          p_sc.GetSplitInfo(ChildId, SplitInfo);
          if SplitInfo.SplitAllow <> CSB_Yes then exit;
        end;
      end
      else
        p_sc.GetSplitInfo(id, SplitInfo);
      if SplitInfo.SplitAllow <> CSB_Yes then exit;

      NbrOfOptMinMax := MinMaxOptQtyList.Count - 1;
      AtLeastOneQtyAboveTheMinimum := false;
      for IInt := 0 to NbrOfOptMinMax do
      begin
        if (JobQty > PTMinMaxOptQty(MinMaxOptQtyList[IInt]).MinQty) then AtLEastOneQtyAboveTheMinimum := true;
        if AutoSchedCfg.m_SplitSchedByBatchSize <> ByMachinesOptimumForceSplit then
        begin
          if  (JobQty >= PTMinMaxOptQty(MinMaxOptQtyList[IInt]).MinQty)
          and ((PTMinMaxOptQty(MinMaxOptQtyList[IInt]).MaxQty = 0)
               or (JobQty <= PTMinMaxOptQty(MinMaxOptQtyList[IInt]).MaxQty)) then exit;
        end;
        if (PTMinMaxOptQty(MinMaxOptQtyList[IInt]).OptQty <= 0) then exit;  // All must have optimum defined
        PTMinMaxOptQty(MinMaxOptQtyList[IInt]).NbrOfBacthes := 0;
        PTMinMaxOptQty(MinMaxOptQtyList[IInt]).MachineSizeUsed := false;
      end;
      if not AtLeastOneQtyAboveTheMinimum then Exit;

      ListQtyOptions := TList.create;
      if (AutoSchedCfg.m_SplitSchedByBatchSize = ByMachinesOptimum) or (AutoSchedCfg.m_SplitSchedByBatchSize = DailyProductionAndJoin) then
        SplitNewJobsByOptimums(ListQtyOptions);
      if AutoSchedCfg.m_SplitSchedByBatchSize = ByEqualQuantity then
        SplitNewJobsByEqualQuantities(ListQtyOptions);
      if AutoSchedCfg.m_SplitSchedByBatchSize = BalancingAll then
      begin
        SaveTimeOfNow := now;
        SplitAndBalancingAllRecursive(ListQtyOptions, NbrOfOptMinMax, 0);
      end;

      if (ListQtyOptions.Count = 0) then
      begin
        ListQtyOptions.Free;
        Exit;
      end;

      ListQtyOptions.sort(SortOptionToSplit);
      BestScore := 999999999;
      BestScoreIndex := -1;
      LowestNumberOfJobs := 999999999;
      SaveTimeOfNow := now;
      for IInt := 0 to ListQtyOptions.Count - 1 do
      begin
        PenaltyDateScore := 0;
        if FAutoSched.m_OperatedAbort then
          break;
        if BestScore = 0 then
          break;
        if ((Now - SaveTimeOfNow) > (1 / 24 / 60 * 1)) then
          break;
        RemainQty := JobQty;
        TotalSplitScore := 0;
        PlaceFound := true;
        RollBackCountIntern := GetRollBackList.Count;
        for IInt1 := 0 to PTOptionToSplit(ListQtyOptions[IInt]).SplitsList.Count - 1 do // last entry is the remaining
        begin
          if IInt1 < (PTOptionToSplit(ListQtyOptions[IInt]).SplitsList.Count - 1) then
          begin
            TempQty := StrToFloat(PTOptionToSplit(ListQtyOptions[IInt]).SplitsList[IInt1]);
            if not PlanInfo.isGroup then
            begin
              RemainQty := RemainQty - TempQty;
              p_sc.SplitJob(Id, RemainQty, TempQty, 1, NewId);
              ResManager.AddIdToBackupList(NewId, '', nil);
              AddSplitToRolbackList(New_Id)
            end
            else
            begin
              NewgrpId := SplitGroup(id, TempQty, false);
              if NewgrpId = CSchedIDnull then exit;

              NewId := NewgrpId;
              ResManager.AddIdToBackupList(NewgrpId, '', nil);
              AddSplitToRolbackList(New_Id_Group);
            end;
          end
          else
            NewId := Id;
          PlaceFound := ResManager.FindBestScoreAfterLastJob(NewId, false, ScoreRecord, ServeCodeLimitStart, 0,
                       GenericPlanDates, FindFirstPossiblePlace,
             HighestPrevEndFound, PlantCode);
          if PlaceFound then
          begin
            TotalSplitScore := TotalSplitScore + ScoreRecord.Score;
            if ScoreRecord.PenaltyDateScore <= PenaltyDateScore then
              TotalSplitScore := TotalSplitScore - ScoreRecord.PenaltyDateScore
            else
            begin
              TotalSplitScore := TotalSplitScore - PenaltyDateScore;
              PenaltyDateScore := ScoreRecord.PenaltyDateScore;
            end;
          end;
          ResManager.CleanGenericPlanDates(GenericPlanDates);
          if not PlaceFound then break;
          ScoreRecord.Resource.AddIdToList(NewId , ScoreRecord, -1, true, false);
        end;
        BetterPlace := false;
        if PlaceFound then
        begin
          if (TotalSplitScore < BestScore) then
            BetterPlace := true;
 //         if (TotalSplitScore = BestScore) and (PTOptionToSplit(ListQtyOptions[IInt]).SplitsList.Count < LowestNumberOfJobs) then
 //           BetterPlace := true;
        end;
        if BetterPlace then
        begin
          BestScore := TotalSplitScore;
          BestScoreIndex := IInt;
          LowestNumberOfJobs := PTOptionToSplit(ListQtyOptions[IInt]).SplitsList.Count;
        end;
        RollBackFromList(RollBackCountIntern);
      end;

      if BestScoreIndex > -1 then
      begin
        SplitPossible := true;
        ListOfSplits := TStringList.Create;
        for IInt := 0 to PTOptionToSplit(ListQtyOptions[BestScoreIndex]).SplitsList.Count - 2 do
          ListOfSplits.Add(PTOptionToSplit(ListQtyOptions[BestScoreIndex]).SplitsList[IInt]);
      end;

      for IInt := ListQtyOptions.Count - 1 downto 0 do
      begin
         PTOptionToSplit(ListQtyOptions[IInt]).SplitsList.Free;
         Dispose(PTOptionToSplit(ListQtyOptions[IInt]));
      end;

    end;

  //-----------------------------------------------------------------------------------------------

  begin

    if FAutoSched.m_OperatedAbort then
       exit;

    if (HandlePlants and (PlantCode = '')) // Just for BIN sort
    or (HandlePlants and (PlantCode <> '') and (IndexPlants < (PlantsToCheckList.Count))) then  // Decide on plant
    begin
      FindFirstPossiblePlace := false;
      if (PlantCode = '') then FindFirstPossiblePlace := true;
      MinMaxOptQtyList := TList.Create;

      if ResManager.SetCompatibleRes(Id, '', '', nil) then
      begin
        if FindFirstPossiblePlace then
        begin
          SplitPossible := false
        end
        else
        begin
          ResManager.SetCompatibleRes(Id, '', PlantCode, MinMaxOptQtyList);
          p_sc.SetPhisicallyDeleteLimitIndex;
          SplitToNewJobs;
          p_sc.ResetPhisicallyDeleteLimitIndex;
        end;
        if SplitPossible then
        begin
          for Index := 0 to ListOfSplits.Count - 1 do
          begin
            TempQty := StrToFloat(ListOfSplits[Index]);

            if not PlanInfo.isGroup then
            begin
              JobQty := JobQty - TempQty;
              p_sc.SplitJob(id, JobQty, TempQty, 1, NewId);
              ResManager.AddIdToBackupList(NewId, '', nil);
              AddSplitToRolbackList(New_Id);
              ResManager.FindBestScoreAfterLastJob(NewId, false, ScoreRecord, ServeCodeLimitStart, 0,
                GenericPlanDates, FindFirstPossiblePlace,
                 HighestPrevEndFound, PlantCode);
              TempScore := TempScore + ScoreRecord.Score;
              ResManager.CleanGenericPlanDates(GenericPlanDates);
              ScoreRecord.Resource.AddIdToList(NewId , ScoreRecord, -1, true, false);
            end
            else
            begin

              NewgrpId := SplitGroup(id, TempQty, false);
              NewId := NewgrpId;
              ResManager.AddIdToBackupList(NewgrpId, '', nil);
              AddSplitToRolbackList(New_Id_Group);

              ResManager.FindBestScoreAfterLastJob(NewgrpId, false, ScoreRecord, ServeCodeLimitStart, 0,
                GenericPlanDates, FindFirstPossiblePlace,
                 HighestPrevEndFound, PlantCode);
              TempScore := TempScore + ScoreRecord.Score;
              ResManager.CleanGenericPlanDates(GenericPlanDates);
              ScoreRecord.Resource.AddIdToList(NewgrpId , ScoreRecord, -1, true, false);

            end;

          end;
          ListOfSplits.Free;
        end;

        if ResManager.FindBestScoreAfterLastJob(Id, false, ScoreRecord, ServeCodeLimitStart, 0,
             GenericPlanDates, FindFirstPossiblePlace,
             HighestPrevEndFound, PlantCode) then
        begin
          ScoreRecord.Resource.AddIdToList(Id , ScoreRecord, -1, true, false);
          TempScore := TempScore + ScoreRecord.Score;
          inc(TempNumOfSchedJobs);
        end;
        ResManager.CleanGenericPlanDates(GenericPlanDates);
      end;

      for IndexMinMaxOpt := 0 to MinMaxOptQtyList.Count - 1 do
        Dispose(PTMinMaxOptQty(MinMaxOptQtyList[IndexMinMaxOpt]));
      MinMaxOptQtyList.Free;
      Exit;
    end;

    ReSchedServeCode := false;
    FirstIdHighestSchedPossible := false;
    SaveIdIntern := Id;
    ServeCodeIdsIndex := 0;
    MinMaxOptQtyList := Tlist.Create;
    if not ResManager.SetCompatibleRes(Id, '', PlantCode, MinMaxOptQtyList) then Exit;
{    if not (AutoSchedCfg.m_OverridingParams_Activated and AutoSchedCfg.m_OverridingParams_UnscheduleBefore) then
    begin
      if not ResManager.FindBestScoreAfterLastJob(Id, false, ScoreRecord, 0, 0,
                  GenericPlanDates, true, DummyDate, PlantCode) then
      begin
        if AutoSchedCfg.m_AfterHighLimit = 0 then exit;
        if not ResManager.FindBestScoreBeforeLastJob(Id, ScoreRecord, 0,
               GenericPlanDates, TempScore, PlantCode, false, true) then
           exit;
      end;
    end; } // ERAN 28/05 because of ORTA-63 - job that must move other jobs, otherwise, its overlapping.

    IdsToLoopOn := TMSchedList.Create(self);
    p_sc.SetPhisicallyDeleteLimitIndex;
    SplitToNewJobs;
    p_sc.ResetPhisicallyDeleteLimitIndex;
    PosToAdd := 0;
    if SplitPossible then
    begin
      if (ServeCode <> '') then
        PosToAdd := ServeCodeIdsList.IndexOf(Id);
      for Index := 0 to ListOfSplits.Count - 1 do
      begin
        TempQty := StrToFloat(ListOfSplits[Index]);
        if not PlanInfo.isGroup then
        begin
          JobQty := JobQty - TempQty;
          p_opStack.SplitJob(Id, JobQty, TempQty, 1, NewId, List);
          ResManager.AddIdToBackupList(NewId, '', nil);
          IdsToLoopOn.AddLink(NewId);
          if (ServeCode <> '') then
          begin
            ServeCodeIdsList.AddLinkAtPosition(PosToAdd, NewId);
            PosToAdd := PosToAdd + 1;
          end;
        end
        else
        begin
          NewgrpId := SplitGroup(id, TempQty, true);
          NewId := NewgrpId;
          ResManager.AddIdToBackupList(NewgrpId, '', nil);

          IdsToLoopOn.AddLink(NewgrpId);
          if (ServeCode <> '') then
          begin
            ServeCodeIdsList.AddLinkAtPosition(PosToAdd, NewgrpId);
            PosToAdd := PosToAdd + 1;
          end;
        end;
      end;
      ListOfSplits.Free;
    end;
    IdsToLoopOn.AddLink(Id);
    LowestMinimumQuantity := 999999999;
    LowestOptimumQuantity := 999999999;
    for IndexMinMaxOpt := 0 to MinMaxOptQtyList.Count - 1 do
    begin
      if LowestMinimumQuantity > PTMinMaxOptQty(MinMaxOptQtyList[IndexMinMaxOpt]).MinQty then
        LowestMinimumQuantity := PTMinMaxOptQty(MinMaxOptQtyList[IndexMinMaxOpt]).MinQty;
      if LowestOptimumQuantity > PTMinMaxOptQty(MinMaxOptQtyList[IndexMinMaxOpt]).OptQty then
        LowestOptimumQuantity := PTMinMaxOptQty(MinMaxOptQtyList[IndexMinMaxOpt]).OptQty;
      Dispose(PTMinMaxOptQty(MinMaxOptQtyList[IndexMinMaxOpt]));
    end;
    if LowestMinimumQuantity = 999999999 then
      LowestMinimumQuantity := 0;
    if LowestOptimumQuantity = 999999999 then
      LowestOptimumQuantity := 0;
    if LowestOptimumQuantity < LowestMinimumQuantity then
       LowestOptimumQuantity := LowestMinimumQuantity;
    MinMaxOptQtyList.Free;

    for Index  := 0 to IdsToLoopOn.GetLinkCount - 1 do
    begin
      id := IdsToLoopOn.GetLink(Index);
      MainIdHandled := id;

      while True do
      begin

        if ReSchedServeCode then
        begin
//          if (ServeCodeIdsIndex > (ServeCodeIdsList.GetLinkCount - 1)) then break;
          if ServeCodeIdsIndex > ServeCodeIdsList.IndexOf(MainIdHandled) then break; //We always need to ask index off as MainIdHandled might shift
          Id := ServeCodeIdsList.GetLink(ServeCodeIdsIndex);
          ServeCodeIdsIndex := ServeCodeIdsIndex + 1;
        end;

        if RtvLogSize > 300000 then
        begin
          Inc(LogNumber);
          LogName := ListAutomaticSeqName.strings[ListAutomaticSeqName.Count -1];
          LogName := LogName + '_'{ + LogTime + '_'} + inttostr(LogNumber);
          PrintLog(LogName);
          CleanLogList;
        end;
        FillLogListLine('Start',Id, false, nil, -1, -1, 0);

        CheckSplitJob := false;
        IsNewId := false;
        CanBeNewId := false;
        if (AutoSchedCfg.m_SplitSchedByBatchSize = LongestDurationPossible)
        and not p_sc.IsGroup(id)
        and (not ReSchedServeCode)
        and (LowestOptimumQuantity > 0)
        and (p_sc.GetJobType(id) = CST_Continuous) then
        begin
          p_sc.GetSplitInfo(Id, SplitInfo);
          JobQty := SplitInfo.quant;
          if (SplitInfo.SplitAllow = CSB_Yes) and (JobQty > (LowestOptimumQuantity*2)) then
          begin
            CheckSplitJob := true;
            RollBackCount := GetRollBackList.Count;
            p_sc.SplitJob(id, (JobQty - LowestOptimumQuantity), LowestOptimumQuantity, 1, NeWId);
            ResManager.AddIdToBackupList(NeWId, '', nil);
            AddSplitToRolbackList(New_Id);
            id := NeWId;
            CanBeNewId := true;
          end;
        end;

        ScoreAfterLastFound := false;
        ScoreBeforeLastJobFound := false;
        if ResManager.SetCompatibleRes(Id, '', PlantCode, nil) then
        begin
          ScoreAfterLastFound := ResManager.FindBestScoreAfterLastJob(Id, false, ScoreRecord,
                                 ServeCodeLimitStart, 0, GenericPlanDates, false,
                                 HighestPrevEndFound, PlantCode);
          NewScore := 0;
          ScoreBeforeLastJobFound := ResManager.FindBestScoreBeforeLastJob(Id, ScoreRecord, ServeCodeLimitStart,
                                     GenericPlanDates, NewScore, PlantCode, ScoreAfterLastFound, false,
                                     CheckSplitJob, IdxToSched, ReturnScoreRecordIdToPrevId, CanBeNewId);
          if CheckSplitJob then
          begin
            if not ScoreAfterLastFound and not ScoreBeforeLastJobFound then
              RollBackFromList(RollBackCount)
            else
            begin
              if ScoreBeforeLastJobFound then
                  KeepTheSplit := ReturnScoreRecordIdToPrevId.Resource.KeepTheSplitChgQtyIfNot(MainIdHandled, id, JobQty, LowestOptimumQuantity, ReturnScoreRecordIdToPrevId)
              else
                KeepTheSplit := ScoreRecord.Resource.KeepTheSplitChgQtyIfNot(MainIdHandled, id, JobQty, LowestOptimumQuantity, ScoreRecord);
              if KeepTheSplit then
                IsNewId := true
              else
              begin
                RollBackFromList(RollBackCount);
                id := MainIdHandled;
                ResManager.SetCompatibleRes(Id, '', PlantCode, nil);
                ScoreAfterLastFound := ResManager.FindBestScoreAfterLastJob(Id, false, ScoreRecord,
                                       ServeCodeLimitStart, 0, GenericPlanDates, false,
                                       HighestPrevEndFound, PlantCode);
                NewScore := 0;
                ScoreBeforeLastJobFound := ResManager.FindBestScoreBeforeLastJob(Id, ScoreRecord, ServeCodeLimitStart,
                                       GenericPlanDates, NewScore, PlantCode, ScoreAfterLastFound, false,
                                       true, IdxToSched, ReturnScoreRecordIdToPrevId, false);
              end;
            end;
          end;

          if ScoreBeforeLastJobFound then
          begin
            if CheckSplitJob then
              ReturnScoreRecordIdToPrevId.Resource.AddIdToList(Id , ReturnScoreRecordIdToPrevId, IdxToSched, true, IsNewId);
            TempScore := TempScore + NewScore
          end
          else
          begin
            if ScoreAfterLastFound  then
            begin
              ScoreRecord.Resource.AddIdToList(Id , ScoreRecord, -1, true, IsNewId);
              TempScore := TempScore + ScoreRecord.Score;
            end;
          end;
        end;

        if ScoreAfterLastFound or ScoreBeforeLastJobFound then
        begin
          if (IdsToLoopOn.IndexOf(Id) = 0) then
            inc(TempNumOfSchedJobs);

          if (AutoSchedCfg.m_AllServingGroupJobsSamePlant)
          and (ServeCode <> '') and (PlantCode = '') then
          begin
            PlantCode := ScoreRecord.Resource.GetResourcePlantCode;
          end;

          ResManager.CleanGenericPlanDates(GenericPlanDates);

          if (ServeCode <> '') and (Id = ServeCodeIdsList.GetLink(0)) then
          begin
            FirstIdHighestSchedPossible := false;
            p_sc.GetPlanInfo(Id, PlanInfo);
            if PlanInfo.startDate >= HighestPrevEndFound then FirstIdHighestSchedPossible := true;
          end;

          if (ServeCode <> '') and (ServeCodeCanMove) and (AutoSchedCfg.m_RescheduleErlierJobsWhenTolerance) then
          begin
            p_sc.GetServingGroupLowestHighiestDates(Id, DummyServeCode, LowestServeCodeStart, HighestServeCodeStart);
            if (HighestServeCodeStart - LowestServeCodeStart) > (AutoSchedCfg.m_HoursToleranceOfGapBetweenJobs + (4/3600) / 24) then // Take 4 seconds more for inaccuracy
            begin
              if FirstIdHighestSchedPossible then
              begin
                ServeCodeCanMove := false;
                ServeCodeLimitStart := 0;
              end
              else
              begin
                ServeCodeLimitStart := HighestServeCodeStart -  (AutoSchedCfg.m_HoursToleranceOfGapBetweenJobs / 24);
                RoundDateTime(ServeCodeLimitStart);
              end;
              ScoreRecord.ServingGroup := DummyServeCode;
              ScoreRecord.ServinglowestDate := LowestServeCodeStart;
              ScoreRecord.ServingHighestDate := HighestServeCodeStart;
              FillLogListLine('RestartServeGroup',Id, false, @ScoreRecord, ScoreRecord.CompValJobToRes , ScoreRecord.Score, 0);
              ServeCodeIdsIndex := 0;
              RollBackFromList(0);
              ReSchedServeCode := true;
              TempScore := 0;
              TempNumOfSchedJobs := 0;
              for IndexRemove := 0 to UnscheduleAlreadyInGanttIndex - 1 do
              begin
                TempNumOfSchedJobs := TempNumOfSchedJobs - 1;
                IdToRemove := TestedServingCodeIdsList.GetLink(IndexRemove);
                if ResManager.RemoveIdFromList(IdToRemove, -1, false, UnschedWithError) then
                begin
                  if ServeCodeIdsList.IndexOf(IdToRemove) = -1 then
                  begin
                    ServeCodeIdsList.AddLinkAtPosition(0, IdToRemove);
                  end;
                end;
              end;
              UnscheduleAlreadyInGanttIndex := 0;
            end;
          end;

        end;

        if CheckSplitJob then
          id := MainIdHandled;
        if not ReSchedServeCode and not IsNewId then break;

      end;

    end;
    IdsToLoopOn.ClearList;
    IdsToLoopOn.Free;
    Id := SaveIdIntern;

  end;

begin
  TolleranceHoursComparison := 0;
  SaveCurrCfg := AutoSchedCfg^;
  ListAutomaticSeqName := TStringList.Create;
  TestedServingCodeIdsList := TMSchedList.Create(self);
  FirstCycle := true;
  ServeCodeIdsList := TMSchedList.Create(self);
  GenericPlanDates := TList.Create;
  PlantsToCheckList := nil;
  CleanAllInformationList(false);

  if DBAppGlobals.MCM_App then
  begin
    DeleteDummyDownTimeForCapacity(FMQMPlan.GetActiveTab.p_ganttPanel.p_VisResList, true);
    BuildDummyDownTimeForCapacity;
  end;

  while True do
  begin

    Application.ProcessMessages;
    if Terminated then break;

    if FirstCycle then
    begin
      FirstCycle := false;
      ListAutomaticSeqName.add(AutoSchedCfg.m_CfgName);
      GroupCfg := AutoSchedCfg.m_CfgGroup;
      if AutoSchedCfg.m_StartSchedFrom = 0 then
      begin
        if IsAutoRunMode then
          AutoSchedCfg.m_NowDateTime := AutoSchedCfg.m_AutoRunFixedDateTime
        else
          AutoSchedCfg.m_NowDateTime := now;
      end;
      if AutoSchedCfg.m_StartSchedFrom = 1 then
        AutoSchedCfg.m_NowDateTime := AutoSchedCfg.m_SpecificDateTime;
      if AutoSchedCfg.m_StartSchedFrom = 2 then
        AutoSchedCfg.m_NowDateTime := Date + AutoSchedCfg.m_NumberOfDaysFromCurrentDate;

      if AutoSchedCfg.m_AllowedLatestDateLimit > 0 then
      begin
        if AutoSchedCfg.m_AllowedDatelimitType = 0 then
           AutoSchedCfg.m_ScheduleDateLimitDate := AutoSchedCfg.m_LatestDateSchedule;
        if AutoSchedCfg.m_AllowedDatelimitType = 1 then
        begin
          if IsAutoRunMode then
            AutoSchedCfg.m_ScheduleDateLimitDate := trunc(AutoSchedCfg.m_AutoRunFixedDateTime) + AutoSchedCfg.m_LatestDateScheduleNbrOfDays
          else
            AutoSchedCfg.m_ScheduleDateLimitDate := Date + AutoSchedCfg.m_LatestDateScheduleNbrOfDays;
        end;
        if AutoSchedCfg.m_AllowedDatelimitType = 2 then
          AutoSchedCfg.m_ScheduleDateLimitDate := trunc(AutoSchedCfg.m_NowDateTime) + AutoSchedCfg.m_LatestDateScheduleNbrOfDays;
        AutoSchedCfg.m_ScheduleDateLimitDate := AutoSchedCfg.m_ScheduleDateLimitDate + 1;
      end;

      TolleranceHoursComparison := AfterHighTolerance(AutoSchedCfg) * 24
    end
    else
    begin
      if GroupCfg = '' then break;
      CurrentSchedCfg := GetGetNextAutoSchedCfgByGroup(ListAutomaticSeqName, GroupCfg);
      if CurrentSchedCfg = nil then break;
      ListAutomaticSeqName.add(CurrentSchedCfg.m_CfgName);
      SetAutoSchedParams(CurrentSchedCfg, false);
    end;

    if not AutoSchedCfg.m_ScheduleByWorkCenterCfg then
      SetOverrideParams;  // AVI do it only when not RunByWorkCenterCfg

    DecodeDate(now, Year, Month, Day);
    DecodeTime(now, hour, minute, second, milisecond);
    LogTime :=  inttostr(integer(Year))+inttostr(integer(Month))+inttostr(integer(Day))+inttostr(integer(Hour))+inttostr(integer(Minute))+inttostr(integer(Second));

    if ListAutomaticSeqName.Count > 1 then
    begin
      CleanAllAutoSeqHandled;
      SetAllAutoSeqHandled
    end;

    CleanAllInformationList(true);
    ResManager := TResourcesManager.Create(FMQMPlan.GetActiveTab.p_ganttPanel.p_VisResList, ListAutomaticSeqName.Strings[ListAutomaticSeqName.Count - 1], m_ObjListInfo);
    LogNumber := 0;
    if AutoSchedCfg.m_runOrganizeGenericPlanFirst then ReBuildGenericPlanScheduled;
    LogName := ListAutomaticSeqName.strings[ListAutomaticSeqName.Count -1];
    LogName := LogName + 'GenericPlan';
    if AutoSchedCfg.m_CreateLog then PrintGenericPlanScheduled(LogName);

    PrevServeCode := '';
    EndLoop := false;
    TempScore          := 0;
    TempNumOfSchedJobs := 0;
    NumOfSchedJobs     := 0;
    TotalScore         := 0;
    FirstId := true;
    PrevPlannedWorkCenter := '';
    AutoSchedCfg.m_PushToThePreferedDateMode := false;
    AutoSchedCfg.m_FindFirstFreeInifiniteCapacityResource := false;

    if (AutoSchedCfg.m_OverridingParams_Activated and AutoSchedCfg.m_OverridingParams_AllowedMoveLinkedReq) then
    begin

      for S := 0 to TSchedID(m_ObjList.GetLinkCount) - 1 do
      begin
        id := TSchedID(m_ObjList.GetLink(S));
        ResManager.AddIdToBackupList(id, '', nil);
      end;

      PlantCode := '';
      NumberOfTry := 1;
      while true do
      begin
        AllScheduled := true;
        ResManager.CleanRequestIdList;
        CleanAllInformationList(true);
        for S := 0 to TSchedID(m_ObjList.GetLinkCount) - 1 do
        begin
          id := TSchedID(m_ObjList.GetLink(S));

          RestoreAutoSeqParms(@SaveCurrCfg);
          if AutoSchedCfg.m_ScheduleByWorkCenterCfg then
          begin
            p_sc.GetFldValue(id, CSC_PlanWkctCode, PlanedWorkCenter, dataType);
            if PlanedWorkCenter = PrevPlannedWorkCenter then
              SetAutoSchedParams(@SavedSameWcCfg, true)
            else
            begin
              SavedSameWcCfg := ChangeAutoSeqConfigurationByWorkCenter(Id, 0, SlotStart, SlotEnd)^;
              PrevPlannedWorkCenter := PlanedWorkCenter;
            end;
          end;
          AutoSchedCfg.m_PrefTgtDate := 2;  // Earliest = today
          AutoSchedCfg.m_PrevOrNextLinkedJobIsTheTgtDateWhenScheduled := false;
          AutoSchedCfg.m_RescheduleErlierJobsWhenTolerance := false;
          if (PTIdDetails(m_ObjListInfo[S]).level <> 0) then
          begin
            AutoSchedCfg.m_OverridingParams_Wc_Selected := false;
            AutoSchedCfg.m_OverridingParams_ScheduleJobsWithinTheFram := false;
          end;

          if (NumberOfTry > 1) and (PTIdDetails(m_ObjListInfo[S]).level < 0) then
          begin
            AutoSchedCfg.m_PenCompJobToJob := 0;
            AutoSchedCfg.m_PenCompSetupMinutes := 0;
            AutoSchedCfg.m_PenCompJobToRes := 0;
            AutoSchedCfg.m_PenCompJobToCapRes := 0;
            AutoSchedCfg.m_PenCompJobNotCapRes := 0;
          end;
          AutoSchedCfg.m_FindFirstFreeInifiniteCapacityResource := false;
          if (NumberOfTry = 3) and (PTIdDetails(m_ObjListInfo[S]).level < 0) then
            AutoSchedCfg.m_FindFirstFreeInifiniteCapacityResource := true;
          WorkCenter := '';
          if (PTIdDetails(m_ObjListInfo[S]).level = 0) and AutoSchedCfg.m_OverridingParams_Wc_Selected then
             WorkCenter := AutoSchedCfg.m_OverridingParams_Wc_Code_Selected;
          if ResManager.SetCompatibleRes(Id, WorkCenter , PlantCode, nil) then
          begin
            ScoreAfterLastFound := ResManager.FindBestScoreAfterLastJob(Id, false, ScoreRecord,
                                   ServeCodeLimitStart, 0, GenericPlanDates, false,
                                   HighestPrevEndFoundLocal, PlantCode);
            ScoreBeforeLastJobFound := false;
            if (NumberOfTry < 3) or (PTIdDetails(m_ObjListInfo[S]).level >= 0) then
              ScoreBeforeLastJobFound := ResManager.FindBestScoreBeforeLastJob(Id, ScoreRecord, ServeCodeLimitStart,
                                         GenericPlanDates, NewScoreLocal, PlantCode, ScoreAfterLastFound, false,
                                         false, IdxToSched, ReturnScoreRecordIdToPrevId, false);
            if not ScoreBeforeLastJobFound and ScoreAfterLastFound then
              ScoreRecord.Resource.AddIdToList(Id , ScoreRecord, -1, true, false);
            if not ScoreAfterLastFound and not ScoreBeforeLastJobFound { and level before link } then
            begin
              AllScheduled := false;
              break;
            end;
          end;
        end;
        if AllScheduled then break;
        if (NumberOfTry = 3) then break;
        if (NumberOfTry = 2) and not AutoSchedCfg.m_OverridingParams_InfiniteCapacityAllowed then break;
        RollBackFromList(0);
        NumberOfTry := NumberOfTry + 1;
      end;
      RestoreAutoSeqParms(@SaveCurrCfg);
    end;

    if AutoSchedCfg.m_McmRescheduledJobs then
    begin

      for S := 0 to TSchedID(m_ObjList.GetLinkCount) - 1 do
      begin
        id := TSchedID(m_ObjList.GetLink(S));
        ResManager.AddIdToBackupList(id, '', nil);
      end;

      PlantCode := '';
      for S := 0 to TSchedID(m_ObjList.GetLinkCount) - 1 do
      begin
        id := TSchedID(m_ObjList.GetLink(S));
        ///
        p_sc.GetFldValue(id, CSC_ProdReq, req, dataType);
        ///
        RestoreAutoSeqParms(@SaveCurrCfg);
        PlanedWorkCenter := PTSQMCMlinkInfo(AutoSchedCfg.m_McmListOfRescheduledId[s]).WorkCenter;
        if PlanedWorkCenter = PrevPlannedWorkCenter then
           SetAutoSchedParams(@SavedSameWcCfg, true)
        else if PrevPlannedWorkCenter <> '' then
        begin
          SavedSameWcCfg := ChangeAutoSeqConfigurationByWorkCenter(Id, PTSQMCMlinkInfo(AutoSchedCfg.m_McmListOfRescheduledId[s]).SchedStart, SlotStart, SlotEnd)^;
          PrevPlannedWorkCenter := PlanedWorkCenter;
        end;

        AutoSchedCfg.m_StartSchedFrom := 1;
        AutoSchedCfg.m_SpecificDateTime := 0; 
        AutoSchedCfg.m_NowDateTime := 0; 

        AutoSchedCfg.m_OverridingParams_Activated := true;
        AutoSchedCfg.m_OverridingParams_InfiniteCapacityAllowed := true;
        AutoSchedCfg.m_OverridingParams_Wc_Selected := true;
        AutoSchedCfg.m_OverridingParams_Wc_Code_Selected := PTSQMCMlinkInfo(AutoSchedCfg.m_McmListOfRescheduledId[s]).WorkCenter;
        AutoSchedCfg.m_OverridingParams_WcDateTimeFrom := PTSQMCMlinkInfo(AutoSchedCfg.m_McmListOfRescheduledId[s]).SchedStart;
        AutoSchedCfg.m_OverridingParams_WcDateTimeTo := PTSQMCMlinkInfo(AutoSchedCfg.m_McmListOfRescheduledId[s]).SchedEnd;
        AutoSchedCfg.m_OverridingParams_ScheduleJobsWithinTheFram := true;
        AutoSchedCfg.m_OverridingParams_ShorterJobsCanEndAfterFramEnd := false;
        AutoSchedCfg.m_OverridingParams_LargerJobsCanStartAfterTheFrameBegins := false;
        AutoSchedCfg.m_BeforeLowLimit := 0;
        AutoSchedCfg.m_AfterHighLimit := 0;
        AutoSchedCfg.m_ScheduleByWorkCenterCfg := true;
        AutoSchedCfg.m_StartSchedFrom := 0;
        AutoSchedCfg.m_PrefTgtDate := 2;
        AutoSchedCfg.m_PrevOrNextLinkedJobIsTheTgtDateWhenScheduled := false;
        AutoSchedCfg.m_MoveObjsAllowed := 3;
        AutoSchedCfg.m_AllowSchedBeforeNoneConfLevl := true;
        AutoSchedCfg.m_RescheduleErlierJobsWhenTolerance := false;
        AutoSchedCfg.m_PushToThePreferedDateMode := false;
        AutoSchedCfg.m_FindFirstFreeInifiniteCapacityResource := false;
        WorkCenter := PTSQMCMlinkInfo(AutoSchedCfg.m_McmListOfRescheduledId[s]).WorkCenter;

        if ResManager.SetCompatibleRes(Id, WorkCenter , PlantCode, nil) then
        begin
          ScoreAfterLastFound := ResManager.FindBestScoreAfterLastJob(Id, false, ScoreRecord,
                                 ServeCodeLimitStart, 0, GenericPlanDates, false,
                                 HighestPrevEndFoundLocal, PlantCode);
          ScoreBeforeLastJobFound := ResManager.FindBestScoreBeforeLastJob(Id, ScoreRecord, ServeCodeLimitStart,
                                       GenericPlanDates, NewScoreLocal, PlantCode, ScoreAfterLastFound, false,
                                       false, IdxToSched, ReturnScoreRecordIdToPrevId, false);
          if not ScoreBeforeLastJobFound and ScoreAfterLastFound then
            ScoreRecord.Resource.AddIdToList(Id , ScoreRecord, -1, true, false);
          if not ScoreAfterLastFound and not ScoreBeforeLastJobFound and (AutoSchedCfg.m_MatWOMaterials = 1) then
          begin
            AutoSchedCfg.m_MatWOMaterials := 0;
            ScoreAfterLastFound := ResManager.FindBestScoreAfterLastJob(Id, false, ScoreRecord,
                                   ServeCodeLimitStart, 0, GenericPlanDates, false,
                                   HighestPrevEndFoundLocal, PlantCode);
            ScoreBeforeLastJobFound := ResManager.FindBestScoreBeforeLastJob(Id, ScoreRecord, ServeCodeLimitStart,
                                         GenericPlanDates, NewScoreLocal, PlantCode, ScoreAfterLastFound, false,
                                         false, IdxToSched, ReturnScoreRecordIdToPrevId, false);
          end;
          if not ScoreAfterLastFound and not ScoreBeforeLastJobFound and (AutoSchedCfg.m_MatWOAddRes = 1) then
          begin
            AutoSchedCfg.m_MatWOAddRes := 0;
            ScoreAfterLastFound := ResManager.FindBestScoreAfterLastJob(Id, false, ScoreRecord,
                                   ServeCodeLimitStart, 0, GenericPlanDates, false,
                                   HighestPrevEndFoundLocal, PlantCode);
            ScoreBeforeLastJobFound := ResManager.FindBestScoreBeforeLastJob(Id, ScoreRecord, ServeCodeLimitStart,
                                       GenericPlanDates, NewScoreLocal, PlantCode, ScoreAfterLastFound, false,
                                       false, IdxToSched, ReturnScoreRecordIdToPrevId, false);
          end;
          if not ScoreAfterLastFound and not ScoreBeforeLastJobFound and (AutoSchedCfg.m_IgnoreRightOverlapping = 1) then
          begin
            AutoSchedCfg.m_IgnoreRightOverlapping := 0;
            ScoreAfterLastFound := ResManager.FindBestScoreAfterLastJob(Id, false, ScoreRecord,
                                   ServeCodeLimitStart, 0, GenericPlanDates, false,
                                   HighestPrevEndFoundLocal, PlantCode);
            ScoreBeforeLastJobFound := ResManager.FindBestScoreBeforeLastJob(Id, ScoreRecord, ServeCodeLimitStart,
                                         GenericPlanDates, NewScoreLocal, PlantCode, ScoreAfterLastFound, false,
                                         false, IdxToSched, ReturnScoreRecordIdToPrevId, false);
          end;
          if not ScoreAfterLastFound and not ScoreBeforeLastJobFound and (AutoSchedCfg.m_IgnoreLeftOverlapping = 1) then
          begin
            AutoSchedCfg.m_IgnoreLeftOverlapping := 0;
            ScoreAfterLastFound := ResManager.FindBestScoreAfterLastJob(Id, false, ScoreRecord,
                                   ServeCodeLimitStart, 0, GenericPlanDates, false,
                                   HighestPrevEndFoundLocal, PlantCode);
            ScoreBeforeLastJobFound := ResManager.FindBestScoreBeforeLastJob(Id, ScoreRecord, ServeCodeLimitStart,
                                       GenericPlanDates, NewScoreLocal, PlantCode, ScoreAfterLastFound, false,
                                       false, IdxToSched, ReturnScoreRecordIdToPrevId, false);
         end;
        end;

      end;
      RestoreAutoSeqParms(@SaveCurrCfg);
    end;

    if (not AutoSchedCfg.m_McmRescheduledJobs) and not (AutoSchedCfg.m_OverridingParams_Activated and AutoSchedCfg.m_OverridingParams_AllowedMoveLinkedReq) then
      getNextIdToSchedule;

    while true do
    begin
      if AutoSchedCfg.m_OverridingParams_Activated and AutoSchedCfg.m_OverridingParams_AllowedMoveLinkedReq then
        break;
      if AutoSchedCfg.m_McmRescheduledJobs then break;

      if not EndLoop and AutoSchedCfg.m_ScheduleByWorkCenterCfg then
      begin
        p_sc.GetFldValue(id, CSC_PlanWkctCode, PlanedWorkCenter, dataType);
        if PlanedWorkCenter = PrevPlannedWorkCenter then
          SetAutoSchedParams(@SavedSameWcCfg, true)
        else
        begin
          SavedSameWcCfg := ChangeAutoSeqConfigurationByWorkCenter(Id, 0, SlotStart, SlotEnd)^;
          PrevPlannedWorkCenter := PlanedWorkCenter;
        end;
      end;

      if not EndLoop then
        ServeCode := p_sc.GetServingGroupCode(Id, false, nil);


      if EndLoop or (ServeCode = '') or (ServeCode <> PrevServeCode) then
      begin
        TotalScore := TotalScore + TempScore;
        NumOfSchedJobs := NumOfSchedJobs + TempNumOfSchedJobs;
        if EndLoop then Break;

        TempScore := 0;
        TempNumOfSchedJobs := 0;
        ServeCodeLimitStart := 0;
        ServeCodeIdsList.ClearList;
        CleanRollbackInfoList(0);
        HandlePlants := false;
        PlantCode := '';
        if (ServeCode <> '') then
        begin
          TestedServingCodeIdsList.ClearList;
          ServeCodeCanMove := p_sc.CheckAllowMovingJobsInServingGroup(id, TestedServingCodeIdsList,
                                   AutoSchedCfg.m_MoveInitialObjsAlwd, AutoSchedCfg.m_MoveFinalObjsAlwd,
                                   AutoSchedCfg.m_MoveLevel1ObjsAlwd, AutoSchedCfg.m_MoveLevel2ObjsAlwd,
                                   AutoSchedCfg.m_MoveLevel3ObjsAlwd, AutoSchedCfg.m_MoveLevel4ObjsAlwd,
                                   AutoSchedCfg.m_MoveLevel5ObjsAlwd, AtLeastOneScheduled, PlantCode, OtherIdsAreInTheFamily);
          UnscheduleAlreadyInGanttIndex := 0;
          if Assigned(TestedServingCodeIdsList) then
          begin
            for S := 0 to TestedServingCodeIdsList.GetLinkCount - 1 do
            begin
              if FindIdInBackUpList(TestedServingCodeIdsList.GetLink(S),
                    ResManager.m_ListBackupIdInfo) = nil then // Id scheduled not on our Gantt
              begin
                ServeCodeCanMove := false;
                Break;
              end;
            end;
            UnscheduleAlreadyInGanttIndex := TestedServingCodeIdsList.GetLinkCount;
          end;
          if AutoSchedCfg.m_AllServingGroupJobsSamePlant then
          begin
            if not OtherIdsAreInTheFamily then
            begin
              p_sc.GetPlanInfo(Id, PlanInfo);
              if PlanInfo.isGroup then
              begin
                OtherIdsAreInTheFamily := true;
                for I := 0 to p_sc.GetGrpNumSons(Id) - 1 do
                begin
                  ChildId := p_sc.GetGrpSon(Id, I);
                  p_sc.GetSplitInfo(ChildId, SplitInfo);
                  if SplitInfo.SplitAllow <> CSB_Yes then
                  begin
                    OtherIdsAreInTheFamily := false;
                    break
                  end;
                end;
              end
              else
              begin
                p_sc.GetSplitInfo(id, SplitInfo);
                if SplitInfo.SplitAllow = CSB_Yes then
                  OtherIdsAreInTheFamily := true;
              end;
            end;

            if not AtLeastOneScheduled and OtherIdsAreInTheFamily then
            begin
              PlantsToCheckList := p_sc.GetWcPlantList(id);
              if PlantsToCheckList.Count > 0 then HandlePlants := true;
            end;
          end
          else
            PlantCode := '';
        end;
      end;


      if ServeCode <> '' then ServeCodeIdsList.AddLink(Id);
      PrevServeCode := ServeCode;
      scheduleIdOrServingGroup;
      getNextIdToSchedule;
      NextId := Id;

      LoopOnPlants := false;
      if HandlePlants then
      begin
        LoopOnPlants := true;
        if not EndLoop then
        begin
          NextServeCode := p_sc.GetServingGroupCode(Id, false, nil);
          if (ServeCode = NextServeCode) then LoopOnPlants := false;
        end;
      end;

      BestPlantJobSched := 0;
      BestPlantScore := 0;
      if LoopOnPlants then
      begin
        IndexPlants := -1;
        while True do
        begin

          IndexPlants := IndexPlants + 1;
          if IndexPlants > (PlantsToCheckList.Count - 1) then
            PlantCode := BestPlantCode
          else
            PlantCode := PlantsToCheckList[IndexPlants];

          RollBackFromList(0);
          TempScore := 0;
          TempNumOfSchedJobs := 0;
          ServeCodeLimitStart := 0;
          S := 0;
          while true do
          begin
            if S = ServeCodeIdsList.GetLinkCount then break;
            Id := ServeCodeIdsList.GetLink(S);
            scheduleIdOrServingGroup;
            while ServeCodeIdsList.GetLink(S) <> Id do Inc(S);
            Inc(S);
          end;
          if (IndexPlants = 0) or (TempNumOfSchedJobs > BestPlantJobSched)
          or ((TempNumOfSchedJobs = BestPlantJobSched) and (TempScore < BestPlantScore))
          or ((TempNumOfSchedJobs = BestPlantJobSched) and (TempScore = BestPlantScore)) then
          begin
            BestPlantCode := PlantCode;
            BestPlantScore := TempScore;
            BestPlantJobSched := TempNumOfSchedJobs;
          end;
          if IndexPlants > (PlantsToCheckList.Count - 1) then break;
        end;
      end;

      Id := NextId;
    end;

    CleanRollbackInfoList(0);
    ResManager.JoinAllSubStep;
    ScoreChange := ResManager.TryToPushJobsToTheirTargetDate;
    RestoreAutoSeqParms(@SaveCurrCfg);
    AutoSchedCfg.m_PushToThePreferedDateMode := false;
    TotalScore:= TotalScore + ScoreChange;
    NumOfNonSchedJobs := NumOfNonSchedJobs - NumOfSchedJobs;
    ResManager.p_NumOfScheduleJobs    := NumOfSchedJobs;
    ResManager.p_NumOfNotScheduleJobs := NumOfNonSchedJobs;
    ResManager.p_TotalScore           := TotalScore;
    ResManager.p_ElapsedTime          := FAutoSched.LblElapsedT.Caption;
    ResManager.p_TolleranceHoursComparison := TolleranceHoursComparison;
    ResManager.CleanAndUnScheduleBeforeScheduleOnPlan;
    ResManager.CleanBacupListId;
    ResManager.CleanRequestIdList;
    ResManager.StatisticCalculation;
    m_ManagerResList.Add(ResManager);

    Inc(LogNumber);
    LogName := ListAutomaticSeqName.strings[ListAutomaticSeqName.Count -1];
    LogName := LogName + '_' {+ LogTime + '_'} + inttostr(LogNumber);
    if AutoSchedCfg.m_CreateLog then
      PrintLog(LogName);
    CleanLogList;

    if (AutoSchedCfg.m_OverridingParams_Activated and AutoSchedCfg.m_OverridingParams_AllowedMoveLinkedReq) then break;
    if (AutoSchedCfg.m_McmRescheduledJobs) then break;
  end;

  m_ManagerResList.Sort(SortByLowScore);
  if not Terminated then
  TResourcesManager(m_ManagerResList[0]).ScheduledObjOnGantt;

  LogName := ListAutomaticSeqName.strings[ListAutomaticSeqName.Count -1];
  LogName := LogName + 'GenericPlanAfterSchedule';
  if AutoSchedCfg.m_CreateLog then PrintGenericPlanScheduled(LogName);

  SetAutoSchedParams(@SaveCurrCfg, true);

  if DBAppGlobals.MCM_App then
    DeleteDummyDownTimeForCapacity(FMQMPlan.GetActiveTab.p_ganttPanel.p_VisResList, false);

  SetParamsFromOverride(SaveCurrCfg);

  CleanAllInformationList(false);
  CleanAllAutoSeqHandled;
  CleanPropList;
  GenericPlanDates.Free;
  AutoSchedCfg.m_runOrganizeGenericPlanFirst := false;
  ServeCodeIdsList.Free;
  TestedServingCodeIdsList.Free;

end;


//----------------------------------------------------------------------------//

initialization

  m_LogInfoList := TStringList.Create;

//----------------------------------------------------------------------------//

finalization

  m_LogInfoList.Free;

end.












