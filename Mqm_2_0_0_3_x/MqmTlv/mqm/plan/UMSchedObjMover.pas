unit UMSchedObjMover;

interface

uses
  UMSchedContFunc,
  UMActArea, UMRes, UMWkCtr, UGBaseCal,
  UMOpStack, UMCalcTimings, classes,
  UMCompat,
  UMBalance,
  {$ifdef Big}
  Forms,
  FGinfo,
  {$endif}
  UMCompatRules;

type

  CSetMatAlignOpt = set of ArProdNature;

  TMqmSchedObjMover = class
    constructor Create;
    destructor  Destroy; override;
  private
    m_id:        TSchedID;
    m_markStack: TStackMark;
  public
    function  CanMoveTo(ActArea: TMqmActArea; ToDate: TDateTime; ErrLst: TStrings): boolean;
    procedure SetObjToMove(id: TSchedID);
    function  ChangeTo(actArea: TMqmActArea; var date: TDateTime; isEnd: boolean; ToId: TSchedId; AlignOpt: CAlignOpt;
                       var setup, overlap, duration: double; TimeDescr: string; out EndDate: TDateTime;
                       out OptsMover: SetOptsMover; ErrList: TStringList;
                       CheckMat: boolean; out DeltaSetupObjToMove: double; PlanClicked : boolean;
                       components: integer): CScMovementResult;

    function  ChangeToWithoutOrganize(actArea: TMqmActArea; var date: TDateTime; isEnd: boolean; ToId: TSchedId; AlignOpt: CAlignOpt;
                       var setup, overlap, duration: double; TimeDescr: string; out EndDate: TDateTime;
                       out OptsMover: SetOptsMover; ErrList: TStringList;
                       CheckMat: boolean; out DeltaSetupObjToMove: double; PlanClicked : boolean;
                       components: integer): CScMovementResult;


    function  GetAlignedDate(actArea: TMqmActArea; AlignOpt: CAlignOpt;
                             MouseDate, LowDate, HighDate: TDateTime;
                             var isEnd: boolean; MatToCheck: CSetMatAlignOpt; Setup, Overlap : Double): TDateTime;

    function  GetAlignedDateAuto(actArea: TMqmActArea; AlignOpt: CAlignOpt;
                             MouseDate, LowDate, HighDate: TDateTime;
                             var isEnd: boolean; LimitStart : TdateTime ;LimitEnd : TdateTime; PrevId : TSchedId; NextId : TSchedId; Setup, Overlap : Double): TDateTime;

    procedure Abort;
    procedure CompactEntities(MatToCheck: CSetMatAlignOpt; Days: integer);
    procedure CompactEntitiesOnResByDate(ActAreaObj : Tobject; startDateTime : TdateTime; ptr : pointer);
    property p_ID: TSchedID       read m_id;
  end;

  function CalcDur(ActArea: TMqmActArea; ToDate: TDateTime; id: TSchedID; var Duration: double; components : integer; ConsiderPrevIds : boolean): boolean;
  function CalcDurBeforeCurve(id: TSchedID; var Duration: double; components : integer): boolean;
  function GetCurveTime(actArea : TMqmActArea; DateTime : TDateTime; id: TSchedID; Duration : double; ConsiderPrevIds : boolean; AlreadyProcessedTime : double): double;
  function CalcSetup(id, precId: TSchedId; actArea: TMqmActArea;
                     supMinBase: double; var Setup, Overlap : double;
                     var Teoreticl_wc : string; var Duration : Double; var LeadTime : double; var LearningCurveCode : string): boolean;
  function CalcSetupForReattach(id, precId: TSchedId; actArea: TMqmActArea; var compVal : TCompatVal;
                     supMinBase: double; var Setup, Overlap : double;
                     var Teoreticl_wc : string; var Duration : Double; var LeadTime : double): boolean;
  function CalcCompatabilityAndPrepareSetup(id, precId: TSchedId; actArea: TMqmActArea;
            var CompactVal : TCompatVal;  var supRec:  TSetupRec) : boolean;
  Procedure CalcSetupFromPreparedData(supRec : TSetupRec; supMinBase: double; var Setup, Overlap : double);
  procedure CheckNextIdGenericPlan(act: TMqmActArea; Id : TSchedID);
  function CalcNewDateForGenericStart(cal : TPGCALObj; actArea: TMqmActArea; MinDate : TDateTime; StartDate : TDateTime; Id : TSchedId) : TDateTime;

implementation

uses
  gnugettext,
  UMSchedCont,
  dialogs,
  UMPlanObj,
  UMStoredProc,
  UMObjCont,
  UMPlanFunc,
  UMSchedOnPlan,
  UMDurObj,
  UMCapRes,
  UMSchedList,
  sysutils,
  UMAutoSchedCfg,
  UMRank,
  UMglobal,
  FMAutoSched,
  UMCalcOverlaps,
  UMGenericSchedulePrevStep;

//----------------------------------------------------------------------------//

function CalcNewDateForGenericStart(cal : TPGCALObj; actArea: TMqmActArea; MinDate : TDateTime; StartDate : TDateTime; Id : TSchedId) : TDateTime;
var
  DwTime : TMqmDurObj;
  TempRecDownTime: PTRecCalDownTime;
  LastIndexChecked : integer;
begin
  Result := StartDate;
  if StartDate >=  MinDate then exit;
  Result := MinDate;
  cal.NormalizeDate(Result, ntNormalizeForward);
  TempRecDownTime := actArea.FindCrossingDwTime(Result, Result);
  if assigned(TempRecDownTime) then Result := TempRecDownTime.DowntimeEnd;
  LastIndexChecked := -1;
  DwTime := actArea.FindNonCrossingDwTime(Result, Result, LastIndexChecked, Id, 99);
  if assigned(DwTime) then Result := DwTime.p_end;
end;

//----------------------------------------------------------------------------//

procedure CheckNextIdGenericPlan(act: TMqmActArea; Id : TSchedID);
var
  NextObjId, PrevObjId : TSchedID;
  PlanInfo, PlanInfoNextId: TSQplanInfo;
  Teoreticl_Dur, Teoreticl_LeadTime : double;
  Teoreticl_wc_Nxt : string;
  DummysupMinBase, Dummysetup, Dummyoverlap : double;
  NextIdChange : boolean;
  LearningCurveCode : string;
begin
  DummysupMinBase := 0;
  Dummysetup := 0;
  Dummyoverlap := 0;
  NextIdChange := false;
  p_sc.GetPlanInfo(Id, PlanInfo);
  NextObjId := act.GetNextObj(PlanInfo.EndDate, Id);
  if NextObjId = CSchedIDnull then exit;
  p_sc.GetPlanInfo(NextObjId, PlanInfoNextId);
  if not PlanInfoNextId.GenericPlan then exit;

  PrevObjId := act.GetPrecObj(PlanInfo.endDate, Id);
  if PrevObjId = CSchedIDnull then Exit;
  Teoreticl_wc_Nxt := '';
  CalcSetup(NextObjId, PrevObjId, act ,DummysupMinBase, Dummysetup, Dummyoverlap, Teoreticl_wc_Nxt, Teoreticl_Dur, Teoreticl_LeadTime, LearningCurveCode);

  if (Teoreticl_wc_Nxt = '') then
  begin
    if (PlanInfoNextId.GenericPlanWC <> '') then
    begin
      UnScheduleGenericPlan(NextObjId);
      PlanInfoNextId.GenericPlanWC := '';
      NextIdChange := true
    end
  end
  else
  begin
    if (PlanInfoNextId.GenericPlanWC = '') then
    begin
      if ScheduleOnBestPosition(NextObjId, PlanInfoNextId, PlanInfoNextId.startDate, trim(Teoreticl_wc_Nxt), Teoreticl_Dur, Teoreticl_LeadTime, true) then
        NextIdChange := true
    end;
  end;

  if NextIdChange then
     p_opStack.ChgOccDurGenericPlan(NextObjId, PlanInfoNextId);
end;

//----------------------------------------------------------------------------//

function GetCurveTime(actArea : TMqmActArea; DateTime : TDateTime; id: TSchedID; Duration : double; ConsiderPrevIds : boolean; AlreadyProcessedTime : double): double;
var
  CurveTime, durationOfAllbefore : double;
begin
  Result := 0;
  durationOfAllbefore := 0;
  if (p_sc.GetLearningCurveType(id) <> CSC_No)
  and (p_sc.GetLearningCurveCode(id) <> '') and (Duration > 0) then
  begin
    if ConsiderPrevIds then
    begin
      if assigned(ActArea) and (ActArea.SchedObjsCount > 0) then
        durationOfAllbefore := ActArea.GetDurationOfAllJobsBeforeThisSpot(DateTime, Id);
    end;
    Result := GetAddtionalTimeExeForCurve(id, Duration, AlreadyProcessedTime + durationOfAllbefore);
  end;
end;

//----------------------------------------------------------------------------//

function CalcDurBeforeCurve(id: TSchedID; var Duration: double; components : integer): boolean;
var
  StepType:           CScSchedType;
  TmpValue :           variant;
  IniQty, QtyToSched: double;
  dataType:           CBinColValType;
begin
  Result := true;

  if p_sc.GetFldValue(id, CSC_StepType, TmpValue, dataType) then
    StepType := TmpValue
  else
  begin
    Result := false;
    exit
  end;

  if (StepType = CST_batch) then
  begin
   // Result := false;
    exit
  end;

  if p_sc.GetFldValue(id, CSC_IniQty, TmpValue, dataType) then
     IniQty := TmpValue
  else
  begin
    Result := false;
    exit
  end;

  if p_sc.GetFldValue(id, CSC_QtyToSched, TmpValue, dataType) then
    QtyToSched := TmpValue
  else
  begin
    Result := false;
    exit
  end;

  if components < 1 then components := 1;
  Duration := Duration * QtyToSched / IniQty / components;

end;

//----------------------------------------------------------------------------//

function CalcDur(ActArea: TMqmActArea; ToDate: TDateTime; id: TSchedID; var Duration: double; components : integer; ConsiderPrevIds : boolean): boolean;
begin
  Result := CalcDurBeforeCurve(id, Duration, Components);
  if result then
    Duration := Duration + GetCurveTime(ActArea, ToDate, id, Duration, ConsiderPrevIds, 0);
end;

//----------------------------------------------------------------------------//

function CalcSetup(id, precId: TSchedId; actArea: TMqmActArea;
                   supMinBase: double; var Setup, Overlap : double;
                   var Teoreticl_wc : string; var Duration : Double; var LeadTime : double; var LearningCurveCode : string): boolean;
var
  supRec:  TSetupRec;
  compVal: TCompatVal;
  supAdj: CScSupAdj;
  supConst,AddToSetup,AddToOverlap,
  supMult, supOvlpConst,
  supOvlpMult: double;
  IsSameGroup : boolean;
begin
  Assert((id <> CSchedIdNull) or (precId <> CSchedIdNull));

  Result := true;
  if (precId = CSchedIdNull) or (id = CSchedIdNull) then
  begin
    supAdj       := CSA_copy;
    supConst     := 0.0;
    supMult      := 1.0;
    supOvlpConst := 0.0;
    supOvlpMult  := 1.0;
    AddToSetup   := 0.0;
    AddToOverlap := 0.0;
    Teoreticl_wc := '';
    Duration     := 0;
    LeadTime     := 0;
  end else
    if not TMqmRes(actArea.p_res).GetSetupParms(id, precId, supRec, compVal, IsSameGroup, LearningCurveCode) then
    begin
      Result := false;
      exit
    end else
    begin
      supAdj       := supRec.supAdjType;
      supConst     := supRec.supTime;
      supMult      := supRec.supMult;
      supOvlpConst := supRec.supOverlap;
      supOvlpMult  := supRec.supMultOverlap;
      AddToSetup   := supRec.AddToSetup;
      AddToOverlap := supRec.AddToOverlap;
      Teoreticl_wc := supRec.Teoreticl_wc;
      if (supRec.CurveCode <> '') and (p_sc.GetLearningCurveType(id) = CSC_Managed) then
         p_sc.SetLearningCurveCodeOccToOcc(id, supRec.CurveCode);
    //  if LearningCurveCode <> '' then
      //   p_sc.SetLearningCurveCodeOccToOcc(id, LearningCurveCode);
      Duration     := supRec.Duration;
      LeadTime     := supRec.LeadTime
    end;

//  if (p_sc.isProgressed(id) = prg_Final)
//  or (p_sc.isProgressed(id) = prg_FinalSplit) then
//    setup := 0
//  else
    setup := CalcSetupFormula(supAdj, supMinBase, supConst, supMult, AddToSetup);

  if (p_sc.isProgressed(id) = prg_none) then
//    overlap := CalcSetupOvlpFormula(supAdj, supMinBase, supOvlpConst, supOvlpMult, AddToOverlap)
    overlap := CalcSetupOvlpFormula(supAdj, 0, supOvlpConst, supOvlpMult, AddToOverlap)
  else
    overlap := 0;

  setup := setup// + overlap
end;

//----------------------------------------------------------------------------//

function CalcSetupForReattach(id, precId: TSchedId; actArea: TMqmActArea; var compVal : TCompatVal;
                   supMinBase: double; var Setup, Overlap : double;
                   var Teoreticl_wc : string; var Duration : Double; var LeadTime : double): boolean;
var
  supRec:  TSetupRec;
//  compVal: TCompatVal;
  supAdj: CScSupAdj;
  supConst,AddToSetup,AddToOverlap,
  supMult, supOvlpConst,
  supOvlpMult: double;
  IsSameGroup : boolean;
  LearningCurveCode : string;
begin
  Assert((id <> CSchedIdNull) or (precId <> CSchedIdNull));

  Result := true;
  if (precId = CSchedIdNull) or (id = CSchedIdNull) then
  begin
    supAdj       := CSA_copy;
    supConst     := 0.0;
    supMult      := 1.0;
    supOvlpConst := 0.0;
    supOvlpMult  := 1.0;
    AddToSetup   := 0.0;
    AddToOverlap := 0.0;
    Teoreticl_wc := '';
    Duration     := 0;
    LeadTime     := 0;
  end else
    if not TMqmRes(actArea.p_res).GetSetupParms(id, precId, supRec, compVal, IsSameGroup, LearningCurveCode) then
    begin
      Result := false;
      exit
    end else
    begin
      supAdj       := supRec.supAdjType;
      supConst     := supRec.supTime;
      supMult      := supRec.supMult;
      supOvlpConst := supRec.supOverlap;
      supOvlpMult  := supRec.supMultOverlap;
      AddToSetup   := supRec.AddToSetup;
      AddToOverlap := supRec.AddToOverlap;
      Teoreticl_wc := supRec.Teoreticl_wc;
      Duration     := supRec.Duration;
      LeadTime     := supRec.LeadTime
    end;

//  if (p_sc.isProgressed(id) = prg_Final)
//  or (p_sc.isProgressed(id) = prg_FinalSplit) then
//    setup := 0
//  else
    setup := CalcSetupFormula(supAdj, supMinBase, supConst, supMult, AddToSetup);

  if (p_sc.isProgressed(id) = prg_none) then
//    overlap := CalcSetupOvlpFormula(supAdj, supMinBase, supOvlpConst, supOvlpMult, AddToOverlap)
    overlap := CalcSetupOvlpFormula(supAdj, 0, supOvlpConst, supOvlpMult, AddToOverlap)
  else
    overlap := 0;

  setup := setup// + overlap
end;

//----------------------------------------------------------------------------//

function CalcCompatabilityAndPrepareSetup(id, precId: TSchedId; actArea: TMqmActArea;
            var CompactVal : TCompatVal;  var supRec : TSetupRec) : boolean;
var
  IsSameGroup : boolean;
  LearningCurveCode : string;
begin
  Assert(id <> CSchedIdNull);

 if (precId = CSchedIdNull) or (id = CSchedIdNull) then
 begin
   supRec.supAdjType       := CSA_copy;
   supRec.supTime     := 0.0;
   supRec.supMult      := 1.0;
   supRec.supOverlap := 0.0;
   supRec.supMultOverlap  := 1.0;
   supRec.AddToSetup   := 0.0;
   supRec.AddToOverlap := 0.0;
   supRec.Teoreticl_wc := '';
   supRec.Duration     := 0;
   supRec.LeadTime     := 0;
   CompactVal   := 0;
   Result := true;
   Exit;
  end;

  Result := TMqmRes(actArea.p_res).GetSetupParms(id, precId, supRec, CompactVal, IsSameGroup, LearningCurveCode);
  if (supRec.CurveCode <> '') and (p_sc.GetLearningCurveType(id) = CSC_Managed) then
     p_sc.SetLearningCurveCodeOccToOcc(id, supRec.CurveCode);
end;

//----------------------------------------------------------------------------//

Procedure CalcSetupFromPreparedData(supRec : TSetupRec; supMinBase: double; var Setup, Overlap : double);
begin
  setup := CalcSetupFormula(supRec.supAdjType, supMinBase, supRec.supTime, supRec.supMult, supRec.AddToSetup);

//  if (p_sc.isProgressed(id) = prg_none) then
    overlap := CalcSetupOvlpFormula(supRec.supAdjType, 0, supRec.supOverlap,
                   supRec.supMultOverlap, supRec.AddToOverlap)
//  else
//    overlap := 0;
end;

//----------------------------------------------------------------------------//

constructor TMqmSchedObjMover.Create;
begin
  inherited Create;
  m_markStack := p_opStack.MarkStack;
end;

//----------------------------------------------------------------------------//

destructor TMqmSchedObjMover.Destroy;
begin
  inherited Destroy
end;

//----------------------------------------------------------------------------//

procedure TMqmSchedObjMover.SetObjToMove(id: TSchedID);
begin
  m_id := id;
//sav1  p_pl.p_prMan.SetMainId(m_Id);

  // the plan must already be in compat mode with this object
  Assert(p_pl.GetCompatModeInPlanId = id);
end;

//----------------------------------------------------------------------------//

function TMqmSchedObjMover.ChangeTo(actArea: TMqmActArea; var date: TDateTime;
                                    isEnd: boolean; ToId: TSchedId; AlignOpt: CAlignOpt;
                                    var setup, overlap, duration: double;
                                    TimeDescr: string; out EndDate: TDateTime;
                                    out OptsMover: SetOptsMover; ErrList: TStringList;
                                    CheckMat: boolean; out DeltaSetupObjToMove: double; PlanClicked : boolean;
                                    components: integer): CScMovementResult;
var
  planInfo,planInfoSon, PlanInfoNext: TSQplanInfo;
  planInfoCurr:   TSQplanInfo;
  planInfoPrevId, PlanInfoNextId: TSQplanInfo;
  cal:          TPGCALObj;
  act:          TMqmActArea;
  i, J:            integer;
  idCorr:       TSchedId;
  prevID, PrevPrevID , idSon:       TSchedId;
  supMinBase:   double;
  Teoreticl_wc : string;
  Teoreticl_Dur, Teoreticl_leadTime :double;
  TmgDescr: string;
  TmgMSC: string;
  TmpResult : CScMovementResult;
  ToIdDtInfo: TSQDatesInfo;
  DatesInfo:  TSQDatesInfo;
  NextObjId:  TSchedId;
  componentsTemp, ResComp : Integer;
  SchedType : string;
  NextIdPropInstanceCount : boolean;
  LearningCurveCode : string;
{$ifdef ARO}
  PrevReqJobs: TMSchedList;
{$endif}
  Res: TMQMRes;
//  ComponentsUsed : integer;
//  ComponentsUsed: integer;
  tmpStartDt, tmpEndDt, SavedOrigStartDate : TDateTime;
//  StartMaterial, StartExecution : TDateTime;

  procedure RecalcDates;
  var
    DummysupMinBase, Dummysetup, Dummyoverlap : double;
    Teoreticl_wc_Nxt : string;
    NextIdChange : boolean;
  begin
    DummysupMinBase := 0;
    Dummysetup := 0;
    Dummyoverlap := 0;
    if isEnd then
    begin
      planInfo.endDate := date;
      cal.OfsByWH(-(setup + duration)/60, false, planInfo.endDate, planInfo.startDate, actArea.m_CrossDownTmList);

      if prevId <> CSchedIdNull then
      begin
        p_sc.GetPlanInfo(prevID, planInfoPrevId);
        if planInfo.startDate < planInfoPrevId.endDate then
        begin
          planInfo.startDate := planInfoPrevId.endDate;
          cal.OfsByWH((setup + duration)/60, true, planInfo.startDate, planInfo.endDate, actArea.m_CrossDownTmList);
        end
      end;
    end else
    begin
      planInfo.startDate  := date;
      cal.OfsByWH((setup + duration)/60, true, planInfo.startDate, planInfo.endDate, actArea.m_CrossDownTmList);
    end;

    if planInfo.GenericPlan and (Trim(Teoreticl_wc) <> '') then
    begin
      if ScheduleOnBestPosition(m_id, planInfo, planInfo.startDate, trim(Teoreticl_wc), Teoreticl_Dur, Teoreticl_LeadTime, true) then
        p_opStack.ChgOccDurGenericPlan(m_id, planInfo);
    end
    else if planInfo.GenericPlan and (Trim(Teoreticl_wc) = '') and (planInfo.GenericPlanWC <> '') then
    begin
      UnScheduleGenericPlan(m_id);
      planInfo.GenericPlanWC := '';
      p_opStack.ChgOccDurGenericPlan(m_id, planInfo);
    end;

    NextIdChange := false;
    if (NextObjId <> CSchedIDnull) then
    begin
      p_sc.GetPlanInfo(NextObjId, PlanInfoNextId);
      if PlanInfoNextId.GenericPlan then
      begin
        Teoreticl_wc_Nxt := '';
        CalcSetup(NextObjId, m_id, actArea , DummysupMinBase, Dummysetup, Dummyoverlap, Teoreticl_wc_Nxt, Teoreticl_Dur, Teoreticl_LeadTime, LearningCurveCode);
        if (Teoreticl_wc_Nxt = '') then
        begin
          if (PlanInfoNextId.GenericPlanWC <> '') then
          begin
            UnScheduleGenericPlan(NextObjId);
            PlanInfoNextId.GenericPlanWC := '';
            NextIdChange := true
          end
        end
        else
        begin
          if (PlanInfoNextId.GenericPlanWC = '') then
          begin
            if ScheduleOnBestPosition(NextObjId, PlanInfoNextId, PlanInfoNextId.startDate, trim(Teoreticl_wc_Nxt), Teoreticl_Dur, Teoreticl_LeadTime, true) then
              NextIdChange := true
          end;
        end;
      end;
    end;

    if NextIdChange then
       p_opStack.ChgOccDurGenericPlan(NextObjId, PlanInfoNextId);


      {if prevId <> CSchedIdNull then // oldGap
      begin
        p_sc.GetPlanInfo(prevID, planInfoPrevId);

        cal.OfsByWH((AddGapMinToStart)/60, true, planInfoPrevId.endDate, planInfoPrevId.endDate, nil);

        if planInfo.startDate < planInfoPrevId.endDate then
        begin
          planInfo.startDate := planInfoPrevId.endDate;
          cal.OfsByWH((setup + duration)/60, true, planInfo.startDate, planInfo.endDate, nil);
        end
      end;}
    //end;

  end;

begin
  NextIdPropInstanceCount := false;
  p_opStack.UndoTo(m_markStack); //re

  if p_sc.GetLearningCurveType(m_id) = CSC_Managed then
    p_sc.SetLearningCurveCodeOccToOcc(m_id, '');
  p_sc.GetPlanInfo(m_id, planInfo);
  SavedOrigStartDate := planInfo.startDate;

  act := p_sc.GetExtLinkPtr(m_id);
  if (act = nil) then  p_opStack.ClearBalance(m_id);

  NextObjId := CSchedIDnull;
  if (act <> nil) then
  begin
    NextObjId := act.GetNextObj(planInfo.endDate, m_id);
    if (act = actArea) and (act.GetNextObj(planInfo.endDate, m_id) = actArea.GetNextObj(date, m_id)) then
    begin
      p_opStack.DetachOccFromApaInSameActArea(m_id, act);
    end
    else
      p_opStack.DetachOccFromApa(m_id, act);
    if NextObjId <> CSchedIDnull then
    begin
      p_sc.GetPlanInfo(NextObjId, planInfoNext);
      if (planInfoNext.isGroup) and ((planInfoNext.stepType <> CST_batch)) then
      begin
        UpdContGrpTimings(NextObjId, m_id);
//        p_pl.SetTmgMainID(m_Id);
      end;
    end;
  end;

  if ToId <> CSchedIDnull then
  begin
    p_sc.GetDatesInfo(ToId, ToIdDtInfo);
    if isEnd then
      date := ToIdDtInfo.startDate
    else
      date := ToIdDtInfo.endDate
  end;

  OptsMover := [];

  cal := actArea.GetCalendar;
  Assert(Assigned(cal));

  if Assigned(FAutoSched) and (AutoSchedCfg.m_MoveObjsAllowed = 0) then
    p_pl.SetTmgMainID(m_Id);

  p_pl.SetTmgTargetRes(TMqmRes(actArea.p_res));

  p_sc.GetPlanInfo(m_id, planInfo);
  if (TimeDescr <> '') then
{$ifndef ARO}
    p_pl.SetTmgByDescr(TimeDescr);
{$else}
    p_pl.SetTmgByDescr(TimeDescr)
  else
  begin
    PrevReqJobs := TMSchedList.Create(self);
    p_sc.GetPrevConnReqLastStepJobs(m_id, PrevReqJobs);
    for i := 0 to PrevReqJobs.GetLinkCount -1 do
    begin
      idCorr := PrevReqJobs.GetLink(i);
      if Assigned(p_sc.GetExtLinkPtr(idCorr)) then
      begin
        TimeDescr := p_sc.GetConnMachReqCode(m_id, idCorr);
        p_pl.SetTmgByDescr(TimeDescr);
        break
      end;
    end;
    PrevReqJobs.ClearList;
    PrevReqJobs.Free
  end;
{$endif}

  p_pl.GetMainTimings(supMinBase, duration, TmgDescr, TmgMSC);

  Res := TMQMRes(actArea.p_Res);
  if Assigned(Res) and Res.p_isMultiRes and (p_sc.GetJobType(m_id) = CST_Continuous)  then
    componentsTemp := components
  else
    componentsTemp := 1;

  // get the new setup of the object
  if PlanClicked then
  begin
    prevID := actArea.GetPrecObjFromPlanClicked(date, m_id);
    if (prevID = CSchedIDnull) then
       prevID := actArea.GetPrecObj(date, m_id);
  end
  else
    prevID := actArea.GetPrecObj(date, m_id);

  DeltaSetupObjToMove := 0;
  if (NextObjId <> CSchedIDnull) then
  begin
    CalcSetup(NextObjId, m_id, actArea , supMinBase, setup, overlap, Teoreticl_wc, Teoreticl_Dur, Teoreticl_LeadTime, LearningCurveCode);
    p_sc.GetPlanInfo(NextObjId, PlanInfoNextId);
    DeltaSetupObjToMove := setup - planInfoNextId.supMinReal;
  end;

  Teoreticl_wc := '';
  LearningCurveCode := '';
  if not CalcSetup(m_id, prevID, actArea, supMinBase, setup, overlap, Teoreticl_wc, Teoreticl_Dur, Teoreticl_LeadTime, LearningCurveCode) then
  begin
    if Assigned(ErrList) then
      ErrList.Add(_('Error during setup calculation.'));
    Result := CSM_No;
    exit
  end;

  if (not CalcDur(actArea, date, m_id, duration, componentsTemp, true)) or (duration = 0) then
  begin
    if Assigned(ErrList) then
      ErrList.Add(_('Error during duration calculation.'));
    Result := CSM_No;
    exit
  end;

  if (PrevID <> CSchedIDnull) then
    DeltaSetupObjToMove := DeltaSetupObjToMove + (setup - supMinBase);

  actArea.UpdateInstanceCounterProperty(m_id, prevID);
  if (NextObjId <> CSchedIDnull) then
  begin
    PrevPrevID := act.GetPrecObj(PlanInfoNextId.startDate, NextObjId);
    NextIdPropInstanceCount := act.UpdateInstanceCounterProperty(NextObjId, PrevPrevID);
  end;

  date := GetAlignedDate(actArea, AlignOpt, date, 0, 0, isEnd, [Ar_AddRes, Ar_AddRes_ManPower,Ar_AddRes_Capacity], setup, overlap);

  // change parameters of the current object
  planInfo.supMinBase := supMinBase;
  planInfo.supMinReal := setup;  // supMinBase + overlap
  planInfo.supMinOvlp := overlap;
  planInfo.exeMin     := duration;

  p_sc.SetResCatWrkCntrProcessTimings(m_id);

  RecalcDates;

  planInfo.TmgDescr   := TmgDescr;
  planInfo.MSC := TmgMSC;

  // update duration in case of subresource
  Res := TMQMRes(actArea.p_Res);
  if Assigned(Res) and Res.p_isMultiRes and (p_sc.GetJobType(m_id) = CST_Continuous)  then
  begin
    if components < 1 then
      components := 1;
    //duration := duration / components;

    tmpStartDt := planInfo.startDate;
    tmpEndDt := planInfo.endDate;

    if isEnd then
    begin
      cal.OfsByWH(-(setup + duration)/60, false, tmpEndDt, tmpStartDt, actArea.m_CrossDownTmList);
      if prevId <> CSchedIdNull then
      begin
        p_sc.GetPlanInfo(prevID, planInfoPrevId);
        if tmpStartDt < planInfoPrevId.endDate then
        begin
          tmpStartDt := planInfoPrevId.endDate;
          cal.OfsByWH((setup + duration)/60, true, tmpStartDt, tmpEndDt, actArea.m_CrossDownTmList);
        end
      end;
    end else
    begin
      cal.OfsByWH((setup + duration)/60, true, tmpStartDt, tmpEndDt, actArea.m_CrossDownTmList);
    end;

    //ComponentsUsed := Res.GetComponentsUsed(m_id, tmpStartDt, tmpEndDt);

    //if (ComponentsUsed + components) > Res.p_ResComp then

    //if p_sc.GetRscComponentFromJobOrStep(m_Id) > 0 then
    //  ResComp := p_sc.GetRscComponentFromJobOrStep(m_Id)
    //else
      ResComp := Res.p_ResComp;

    if components > ResComp then
    begin
      Result := NumComponentsExceeded;
     // if Assigned(ErrList) then
     //   ErrList.Add(_('Maximum numbers of Components exceeded'));
      Abort;
      exit;
    end;

//    planInfo.exeMin     := duration;
    RecalcDates;
  end;

  if Res.p_ONE_BATCH_MACHINE_By_GROUP_CODE then
  begin
    Result := CSM_No;
    if Assigned(ErrList) then
    begin
      if Res.CheckDatesOnOneBatchMachineByGroupCode(m_id, planInfo, tmpEndDt) then
      begin
        ErrList.Add(_('Machine is occupied on that time'));
        Abort;
        exit;
      end;
    end
    else
    begin
      while true do
      begin
        if Res.CheckDatesOnOneBatchMachineByGroupCode(m_id, planInfo, tmpEndDt) then
        begin
          Date := tmpEndDt;
          RecalcDates;
        end
        else
          break;
      end;
    end;
  end;

  p_opStack.LinkOccToApa(m_id, actArea);  //re
  p_opStack.ChgOccDurData(m_id, planInfo);

  if Assigned(FAutoSched) then
  begin
    case AutoSchedCfg.m_TempFinal of
      0 : SchedType := '2';
      1 : SchedType := '1';
      2 : SchedType := '3';
      3 : SchedType := '4';
      4 : SchedType := '5';
      5 : SchedType := '6';
      6 : SchedType := '7'
      else
        SchedType := '2';
    end;
    p_opStack.SetSchedType(m_id, SchedType);
  end;

  if planInfo.isGroup and ((planInfo.stepType <> CST_batch)) then
  begin
    UpdContGrpTimings(m_id, m_id);
   { p_pl.SetTmgMainID(m_id);
    p_pl.UpdateGrpTmg;
    p_pl.SetTmgTargetResForGroup(TMqmRes(actArea.p_res));
    for J := 0 to p_sc.GetGrpNumSons(m_id)-1 do
    begin
      idSon := p_sc.GetGrpSon(m_id, J);
      p_sc.GetPlanInfo(idSon, planInfoSon);
      p_pl.GetSubTimings(J, IdSon, planInfoSon.supMinReal, planInfoSon.exeMin, planInfoSon.TmgDescr, planInfoSon.MSC);
      CalcDur(m_id, planInfoSon.exeMin, componentsTemp);
      p_opStack.ChgOccDurData(IDSon, planInfoSon);
    end; }
  end;

  if ((act <> nil) and (act <> actArea) and (NextObjId <> CSchedIDnull))
  or ((NextObjId <> CSchedIDnull) and NextIdPropInstanceCount and (PlanInfoNextId.startDate < PlanInfo.startDate))
  or ((NextObjId <> CSchedIDnull) and (p_sc.GetLearningCurveType(m_id) <> CSC_No) and
      (p_sc.GetCurveFamilyIdCode(m_id) <> '') and (p_sc.GetLearningCurveCode(m_id) <> '') and (PlanInfoNextId.startDate < PlanInfo.startDate)) then
  begin
    Result := act.ReorganizeOcc(NextObjId, False, OptsMover, DeltaSetupObjToMove, ErrList, SavedOrigStartDate);
    case Result of
      CSM_Not_Compatible:
        begin
          if Assigned(ErrList) then
          begin
            ErrList.Clear;
            ErrList.Add(_('Not compatible with job on Gantt'));
          end;
          Abort;
          exit;
        end;
      CSM_Forced:
        begin
          if Assigned(ErrList) then
            ErrList.Add(_('There are objects that need to be forced'));
        end;
      CSM_No:
        begin
          if Assigned(ErrList) then
            ErrList.Add(_('There are objects that can not be moved'));
          Abort;
          exit;
        end;
    end;
  end
  else
    if ((act <> nil) and (act <> actArea) and (NextObjId = CSchedIDnull)) then
      act.ReorganizeWarpMain(SavedOrigStartDate, false);

  Result := actArea.ReorganizeOcc(m_id, False, OptsMover, DeltaSetupObjToMove, ErrList, SavedOrigStartDate);
  p_pl.SetTmgMainID(m_Id);
  p_pl.SetTmgTargetRes(TMqmRes(actArea.p_res));
  case Result of
    CSM_Not_Compatible:
      begin
        if Assigned(ErrList) then
        begin
          ErrList.Clear;
          ErrList.Add(_('Not compatible with job on Gantt'));
        end;
        Abort;
        exit;
      end;
    CSM_Forced:
      begin
        if Assigned(ErrList) then
          ErrList.Add(_('There are objects that need to be forced'));
      end;
    CSM_No:
      begin
        if Assigned(ErrList) then
          ErrList.Add(_('There are objects that can not be moved'));
        Abort;
        exit;
      end;
  end;

  p_sc.GetPlanInfo(m_id, planInfo);
//  DeltaSetupObjToMove := planInfo.supMinReal - planInfo.supMinBase + DeltaSetupObjToMove;

  p_opStack.UpdateOvlpLimits(m_id, TMqmRes(actArea.p_Res));
  p_opStack.UpdateBalance(m_id);

  //Checks if the new position is good
  TmpResult := actArea.CheckPosition(m_id, ErrList);
  if Result > TmpResult then
    Result := TmpResult;

  TmpResult := p_sc.CheckPosition(m_id, ErrList);
  if Result > TmpResult then
    Result := TmpResult;

  //check overlap
  p_sc.GetDatesInfo(m_id, DatesInfo);
  if ((DatesInfo.MinOvlpDate > 0) and (DatesInfo.startDate < DatesInfo.MinOvlpDate))
  or ((DatesInfo.MaxOvlpDate > 0) and (DatesInfo.endDate > DatesInfo.MaxOvlpDate)) then
    Include(OptsMover, OM_Overlap);

  //check material
{  if CheckMat then
  begin
    if not p_sc.CheckEnoughMaterial(m_id, [Ar_MatWithDet, Ar_Material], false) then
        Include(OptsMover, OM_Materials);// NoMaterials := True;

    if not p_sc.CheckEnoughMaterial(m_id, [Ar_AddRes, Ar_AddRes_ManPower,Ar_AddRes_Capacity], false)  then
        Include(OptsMover, OM_AddRes);//NoAddRes := True;
  end;}

  // handle the groups
  if planInfo.isGroup then
  begin
    if (planInfo.stepType <> CST_batch) then
    begin
      UpdContGrpTimings(m_id, m_id);
      if not assigned(FAutoSched) then
      begin
        p_sc.GetPlanInfo(m_id, planInfo);
        duration := planInfo.exeMin;
      end
    end
    else
      // handle batch jobs
      for i := 0 to p_sc.GetGrpNumSons(m_id)-1 do
      begin
        idCorr := p_sc.GetGrpSon(m_id, i);
        p_sc.GetPlanInfo(idCorr, planInfoCurr);
        planInfoCurr.supMinReal := planInfo.supMinReal;
        planInfoCurr.supMinOvlp := planInfo.supMinOvlp;
        planInfoCurr.exeMin     := planInfo.exeMin;
        planInfoCurr.startDate  := planInfo.startDate;
        planInfoCurr.endDate    := planInfo.endDate;
        planInfoCurr.TmgDescr   := TmgDescr;
        planInfoCurr.TmgDescr   := TmgMSC;
        p_opStack.ChgOccDurData(idCorr, planInfoCurr);
      end;
  end;

  if (Result = CSM_Forced) and not assigned(ErrList) then  // automatic seq
     Result := CSM_Yes;

  endDate := planinfo.endDate;
  Date := planinfo.startDate;
end;

//----------------------------------------------------------------------------//

function TMqmSchedObjMover.ChangeToWithoutOrganize(actArea: TMqmActArea; var date: TDateTime;
                                    isEnd: boolean; ToId: TSchedId; AlignOpt: CAlignOpt;
                                    var setup, overlap, duration: double;
                                    TimeDescr: string; out EndDate: TDateTime;
                                    out OptsMover: SetOptsMover; ErrList: TStringList;
                                    CheckMat: boolean; out DeltaSetupObjToMove: double; PlanClicked : boolean;
                                    components: integer): CScMovementResult;
var
  planInfo,planInfoSon, PlanInfoNext: TSQplanInfo;
  planInfoCurr:   TSQplanInfo;
  planInfoPrevId, PlanInfoNextId: TSQplanInfo;
  cal:          TPGCALObj;
  act:          TMqmActArea;
  i, J:            integer;
  idCorr:       TSchedId;
  prevID, PrevPrevID , idSon:       TSchedId;
  supMinBase:   double;
  Teoreticl_wc : string;
  Teoreticl_Dur, Teoreticl_leadTime :double;
  TmgDescr: string;
  TmgMSC: string;
  TmpResult : CScMovementResult;
  ToIdDtInfo: TSQDatesInfo;
  DatesInfo:  TSQDatesInfo;
  NextObjId:  TSchedId;
  componentsTemp, ResComp : Integer;
  SchedType : string;
  NextIdPropInstanceCount : boolean;
  LearningCurveCode : string;
{$ifdef ARO}
  PrevReqJobs: TMSchedList;
{$endif}
  Res: TMQMRes;
//  ComponentsUsed : integer;
//  ComponentsUsed: integer;
  tmpStartDt, tmpEndDt, SavedOrigStartDate : TDateTime;
//  StartMaterial, StartExecution : TDateTime;

  procedure RecalcDates;
  var
    DummysupMinBase, Dummysetup, Dummyoverlap : double;
    Teoreticl_wc_Nxt : string;
    NextIdChange : boolean;
  begin
    DummysupMinBase := 0;
    Dummysetup := 0;
    Dummyoverlap := 0;
    if isEnd then
    begin
      planInfo.endDate := date;
      cal.OfsByWH(-(setup + duration)/60, false, planInfo.endDate, planInfo.startDate, actArea.m_CrossDownTmList);

      if prevId <> CSchedIdNull then
      begin
        p_sc.GetPlanInfo(prevID, planInfoPrevId);
        if planInfo.startDate < planInfoPrevId.endDate then
        begin
          planInfo.startDate := planInfoPrevId.endDate;
          cal.OfsByWH((setup + duration)/60, true, planInfo.startDate, planInfo.endDate, actArea.m_CrossDownTmList);
        end
      end;
    end else
    begin
      planInfo.startDate  := date;
      cal.OfsByWH((setup + duration)/60, true, planInfo.startDate, planInfo.endDate, actArea.m_CrossDownTmList);
    end;

    if planInfo.GenericPlan and (Trim(Teoreticl_wc) <> '') then
    begin
      if ScheduleOnBestPosition(m_id, planInfo, planInfo.startDate, trim(Teoreticl_wc), Teoreticl_Dur, Teoreticl_LeadTime, true) then
        p_opStack.ChgOccDurGenericPlan(m_id, planInfo);
    end
    else if planInfo.GenericPlan and (Trim(Teoreticl_wc) = '') and (planInfo.GenericPlanWC <> '') then
    begin
      UnScheduleGenericPlan(m_id);
      planInfo.GenericPlanWC := '';
      p_opStack.ChgOccDurGenericPlan(m_id, planInfo);
    end;

    NextIdChange := false;
    if (NextObjId <> CSchedIDnull) then
    begin
      p_sc.GetPlanInfo(NextObjId, PlanInfoNextId);
      if PlanInfoNextId.GenericPlan then
      begin
        Teoreticl_wc_Nxt := '';
        CalcSetup(NextObjId, m_id, actArea , DummysupMinBase, Dummysetup, Dummyoverlap, Teoreticl_wc_Nxt, Teoreticl_Dur, Teoreticl_LeadTime, LearningCurveCode);
        if (Teoreticl_wc_Nxt = '') then
        begin
          if (PlanInfoNextId.GenericPlanWC <> '') then
          begin
            UnScheduleGenericPlan(NextObjId);
            PlanInfoNextId.GenericPlanWC := '';
            NextIdChange := true
          end
        end
        else
        begin
          if (PlanInfoNextId.GenericPlanWC = '') then
          begin
            if ScheduleOnBestPosition(NextObjId, PlanInfoNextId, PlanInfoNextId.startDate, trim(Teoreticl_wc_Nxt), Teoreticl_Dur, Teoreticl_LeadTime, true) then
              NextIdChange := true
          end;
        end;
      end;
    end;

    if NextIdChange then
       p_opStack.ChgOccDurGenericPlan(NextObjId, PlanInfoNextId);


      {if prevId <> CSchedIdNull then // oldGap
      begin
        p_sc.GetPlanInfo(prevID, planInfoPrevId);

        cal.OfsByWH((AddGapMinToStart)/60, true, planInfoPrevId.endDate, planInfoPrevId.endDate, nil);

        if planInfo.startDate < planInfoPrevId.endDate then
        begin
          planInfo.startDate := planInfoPrevId.endDate;
          cal.OfsByWH((setup + duration)/60, true, planInfo.startDate, planInfo.endDate, nil);
        end
      end;}
    //end;

  end;

begin
  NextIdPropInstanceCount := false;
  p_opStack.UndoTo(m_markStack); //re

  if p_sc.GetLearningCurveType(m_id) = CSC_Managed then
    p_sc.SetLearningCurveCodeOccToOcc(m_id, '');
  p_sc.GetPlanInfo(m_id, planInfo);
  SavedOrigStartDate := planInfo.startDate;

  act := p_sc.GetExtLinkPtr(m_id);
  if (act = nil) then  p_opStack.ClearBalance(m_id);

  NextObjId := CSchedIDnull;
  if (act <> nil) then
  begin
    NextObjId := act.GetNextObj(planInfo.endDate, m_id);
    if (act = actArea) and (act.GetNextObj(planInfo.endDate, m_id) = actArea.GetNextObj(date, m_id)) then
    begin
      p_opStack.DetachOccFromApaInSameActArea(m_id, act);
    end
    else
      p_opStack.DetachOccFromApa(m_id, act);
    if NextObjId <> CSchedIDnull then
    begin
      p_sc.GetPlanInfo(NextObjId, planInfoNext);
      if (planInfoNext.isGroup) and ((planInfoNext.stepType <> CST_batch)) then
      begin
        UpdContGrpTimings(NextObjId, m_id);
//        p_pl.SetTmgMainID(m_Id);
      end;
    end;
  end;

  if ToId <> CSchedIDnull then
  begin
    p_sc.GetDatesInfo(ToId, ToIdDtInfo);
    if isEnd then
      date := ToIdDtInfo.startDate
    else
      date := ToIdDtInfo.endDate
  end;

  OptsMover := [];

  cal := actArea.GetCalendar;
  Assert(Assigned(cal));

  if Assigned(FAutoSched) and (AutoSchedCfg.m_MoveObjsAllowed = 0) then
    p_pl.SetTmgMainID(m_Id);

  p_pl.SetTmgTargetRes(TMqmRes(actArea.p_res));

  p_sc.GetPlanInfo(m_id, planInfo);
  if (TimeDescr <> '') then
{$ifndef ARO}
    p_pl.SetTmgByDescr(TimeDescr);
{$else}
    p_pl.SetTmgByDescr(TimeDescr)
  else
  begin
    PrevReqJobs := TMSchedList.Create(self);
    p_sc.GetPrevConnReqLastStepJobs(m_id, PrevReqJobs);
    for i := 0 to PrevReqJobs.GetLinkCount -1 do
    begin
      idCorr := PrevReqJobs.GetLink(i);
      if Assigned(p_sc.GetExtLinkPtr(idCorr)) then
      begin
        TimeDescr := p_sc.GetConnMachReqCode(m_id, idCorr);
        p_pl.SetTmgByDescr(TimeDescr);
        break
      end;
    end;
    PrevReqJobs.ClearList;
    PrevReqJobs.Free
  end;
{$endif}

  p_pl.GetMainTimings(supMinBase, duration, TmgDescr, TmgMSC);

  Res := TMQMRes(actArea.p_Res);
  if Assigned(Res) and Res.p_isMultiRes and (p_sc.GetJobType(m_id) = CST_Continuous)  then
    componentsTemp := components
  else
    componentsTemp := 1;

  // get the new setup of the object
  if PlanClicked then
  begin
    prevID := actArea.GetPrecObjFromPlanClicked(date, m_id);
    if (prevID = CSchedIDnull) then
       prevID := actArea.GetPrecObj(date, m_id);
  end
  else
    prevID := actArea.GetPrecObj(date, m_id);

  DeltaSetupObjToMove := 0;
  if (NextObjId <> CSchedIDnull) then
  begin
    CalcSetup(NextObjId, m_id, actArea , supMinBase, setup, overlap, Teoreticl_wc, Teoreticl_Dur, Teoreticl_LeadTime, LearningCurveCode);
    p_sc.GetPlanInfo(NextObjId, PlanInfoNextId);
    DeltaSetupObjToMove := setup - planInfoNextId.supMinReal;
  end;

  Teoreticl_wc := '';
  LearningCurveCode := '';
  if not CalcSetup(m_id, prevID, actArea, supMinBase, setup, overlap, Teoreticl_wc, Teoreticl_Dur, Teoreticl_LeadTime, LearningCurveCode) then
  begin
    if Assigned(ErrList) then
      ErrList.Add(_('Error during setup calculation.'));
    Result := CSM_No;
    exit
  end;

  if (not CalcDur(actArea, date, m_id, duration, componentsTemp, true)) or (duration = 0) then
  begin
    if Assigned(ErrList) then
      ErrList.Add(_('Error during duration calculation.'));
    Result := CSM_No;
    exit
  end;

  if (PrevID <> CSchedIDnull) then
    DeltaSetupObjToMove := DeltaSetupObjToMove + (setup - supMinBase);

  actArea.UpdateInstanceCounterProperty(m_id, prevID);
  if (NextObjId <> CSchedIDnull) then
  begin
    PrevPrevID := act.GetPrecObj(PlanInfoNextId.startDate, NextObjId);
    NextIdPropInstanceCount := act.UpdateInstanceCounterProperty(NextObjId, PrevPrevID);
  end;

  date := GetAlignedDate(actArea, AlignOpt, date, 0, 0, isEnd, [Ar_AddRes, Ar_AddRes_ManPower,Ar_AddRes_Capacity], setup, overlap);

  // change parameters of the current object
  planInfo.supMinBase := supMinBase;
  planInfo.supMinReal := setup;  // supMinBase + overlap
  planInfo.supMinOvlp := overlap;
  planInfo.exeMin     := duration;

  p_sc.SetResCatWrkCntrProcessTimings(m_id);

  RecalcDates;

  planInfo.TmgDescr   := TmgDescr;
  planInfo.MSC := TmgMSC;

  // update duration in case of subresource
  Res := TMQMRes(actArea.p_Res);
  if Assigned(Res) and Res.p_isMultiRes and (p_sc.GetJobType(m_id) = CST_Continuous)  then
  begin
    if components < 1 then
      components := 1;
    //duration := duration / components;

    tmpStartDt := planInfo.startDate;
    tmpEndDt := planInfo.endDate;

    if isEnd then
    begin
      cal.OfsByWH(-(setup + duration)/60, false, tmpEndDt, tmpStartDt, actArea.m_CrossDownTmList);
      if prevId <> CSchedIdNull then
      begin
        p_sc.GetPlanInfo(prevID, planInfoPrevId);
        if tmpStartDt < planInfoPrevId.endDate then
        begin
          tmpStartDt := planInfoPrevId.endDate;
          cal.OfsByWH((setup + duration)/60, true, tmpStartDt, tmpEndDt, actArea.m_CrossDownTmList);
        end
      end;
    end else
    begin
      cal.OfsByWH((setup + duration)/60, true, tmpStartDt, tmpEndDt, actArea.m_CrossDownTmList);
    end;

    //ComponentsUsed := Res.GetComponentsUsed(m_id, tmpStartDt, tmpEndDt);

    //if (ComponentsUsed + components) > Res.p_ResComp then

    //if p_sc.GetRscComponentFromJobOrStep(m_Id) > 0 then
    //  ResComp := p_sc.GetRscComponentFromJobOrStep(m_Id)
    //else
      ResComp := Res.p_ResComp;

    if components > ResComp then
    begin
      Result := NumComponentsExceeded;
     // if Assigned(ErrList) then
     //   ErrList.Add(_('Maximum numbers of Components exceeded'));
      Abort;
      exit;
    end;

//    planInfo.exeMin     := duration;
    RecalcDates;
  end;

  if Res.p_ONE_BATCH_MACHINE_By_GROUP_CODE then
  begin
    Result := CSM_No;
    if Assigned(ErrList) then
    begin
      if Res.CheckDatesOnOneBatchMachineByGroupCode(m_id, planInfo, tmpEndDt) then
      begin
        ErrList.Add(_('Machine is occupied on that time'));
        Abort;
        exit;
      end;
    end
    else
    begin
      while true do
      begin
        if Res.CheckDatesOnOneBatchMachineByGroupCode(m_id, planInfo, tmpEndDt) then
        begin
          Date := tmpEndDt;
          RecalcDates;
        end
        else
          break;
      end;
    end;
  end;

  p_opStack.LinkOccToApa(m_id, actArea);  //re
  p_opStack.ChgOccDurData(m_id, planInfo);

end;

//----------------------------------------------------------------------------//

procedure TMqmSchedObjMover.Abort;
begin
  p_opStack.UndoTo(m_markStack);
end;

//----------------------------------------------------------------------------//

function TMqmSchedObjMover.CanMoveTo(ActArea: TMqmActArea; ToDate: TDateTime; ErrLst: TStrings): boolean;
var
  CompVal: TCompatVal;
  Dependency : boolean;
begin
  Result := ActArea.CheckCompatWithOcc([cho_compVal, cho_timing, cho_wkc, cho_readOnly, cho_useDate, cho_qty, cho_Depend],
                                       m_id, ToDate, ErrLst, CompVal, Dependency);
  Result := (Result and p_pl.HasTimingsOnRes(TMqmRes(ActArea.p_Res)))
end;

//----------------------------------------------------------------------------//

function CheckMat(id: TSchedId; Res: pointer; MatToCheck: CSetMatAlignOpt; DateToCheck: TDateTime): TDateTime;
var
  Lst: TList;
  RecNoMat: PTRecNoMatDate;
  i : integer;
begin
  Result := DateToCheck;
  Lst := TList.Create;
  p_sc.GetMinMaterialsArrivalDate(id, Res, MatToCheck, Lst, -1, -1, -1, false);
  Lst.Sort(SortAvailList);
  for i := 0 to Lst.Count -1 do
  begin
    RecNoMat := PTRecNoMatDate(Lst.Items[i]);
    if (RecNoMat.m_start < DateToCheck) and (RecNoMat.m_end <> 0) and
       (RecNoMat.m_end > DateToCheck) then
    begin
      Result := RecNoMat.m_end;
      exit;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TMqmSchedObjMover.CompactEntities(MatToCheck: CSetMatAlignOpt; Days: integer);
label
  ContinueLoop;
var
  nextId :  TSchedId;
  actArea: TMqmActArea;
{$ifdef ARO}
  TmpDate: TDateTime;
{$endif}
  EndDate,
  LimitDate: TDateTime;
  planInfo, planInfoTemp: TSQplanInfo;
  Cal: TPGCALObj;
  CapResList : TDurList;
  I : Integer;
  CapRes : TMqmCapRes;
  CompVal: TCompatVal;
begin
  Assert(m_id <> CSchedIdNull);
  actarea := TMqmActArea(p_sc.GetExtLinkPtr(m_id));
  Cal := actarea.GetCalendar;
  p_sc.GetPlanInfo(m_id, planInfo);
  nextId := actarea.GetNextObj(planInfo.EndDate, m_id);
  EndDate := planInfo.endDate;
  LimitDate := TruncToDayDate(EndDate) + Days;

  while  nextId <> CSchedIdNull do
  begin
    p_sc.GetPlanInfo(nextId, planInfo);
    if not p_sc.CanMoveTo(nextId, EndDate)
      or ((Days > 0) and (planInfo.startDate >= LimitDate)) then break;

    CapResList := TDurList.Create(self);

    planInfoTemp := planInfo;
    planInfoTemp.startDate := EndDate;
    cal.OfsByWH((planInfoTemp.supMinReal + planInfoTemp.exeMin)/60, true, planInfoTemp.startDate, planInfoTemp.endDate, actArea.m_CrossDownTmList);
    actArea.GetCapResInSpot(planInfoTemp.startDate, planInfoTemp.endDate, CapResList);
    for i := 0 to CapResList.Count -1 do
    begin
      CapRes := TMqmCapRes(CapResList.p_sons[i]);
      if CapRes.m_Type <> cr_Normal then
         Continue;
      CompVal := TMqmRes(CapRes.p_Res).CheckCompIDCapRes(nextId, capRes);
      if CompVal = CompValNotComp then
      begin
        CapResList.Free;
        nextId := actarea.GetNextObj(planInfo.EndDate, m_id);
        EndDate := planInfo.endDate;

        goto ContinueLoop;
      end;

      if not CapRes.CheckUpMostCase(CompVal) then
      begin
        CapResList.Free;
        nextId := actarea.GetNextObj(planInfo.EndDate, m_id);
        EndDate := planInfo.endDate;
        goto ContinueLoop;
      end;
    end;
    CapResList.Free;

{$ifdef ARO}
    TmpDate := CheckMat(nextId, actArea.p_Res, MatToCheck, EndDate);
    if TmpDate > planInfo.startDate then
      planInfo.startDate := EndDate
    else
      planInfo.startDate := TmpDate;
{$else}
    planInfo.startDate := EndDate;
{$endif}
    cal.OfsByWH((planInfo.supMinReal + planInfo.exeMin)/60, true, planInfo.startDate, planInfo.endDate, actArea.m_CrossDownTmList);
    p_opStack.ChgOccDurData(nextId, planInfo);
    p_opStack.UpdateOvlpLimits(nextId, nil);
    nextId := actarea.GetNextObj(planInfo.EndDate, m_id);
    EndDate := planInfo.endDate;

    ContinueLoop:
  end;

end;

//----------------------------------------------------------------------------//

procedure TMqmSchedObjMover.CompactEntitiesOnResByDate(ActAreaObj : Tobject; startDateTime : TdateTime; ptr : pointer);
label
  ContinueLoop;
var
  nextId, Id :  TSchedId;
  actArea: TMqmActArea;
{$ifdef ARO}
  TmpDate: TDateTime;
{$endif}
  EndDate,
  LimitDate: TDateTime;
  planInfo, planInfoTemp: TSQplanInfo;
  Cal: TPGCALObj;
  CapResList : TDurList;
  I : Integer;
  CapRes : TMqmCapRes;
  CompVal: TCompatVal;
begin
  ActArea := TMqmActArea(ActAreaObj);
  Cal := actarea.GetCalendar;
  cal.NormalizeDate(startDateTime, ntNormalizeForward);
  Id := ActArea.FindSchedInSpot(startDateTime);

  if Id <> CSchedIDnull then
  begin
    p_sc.GetPlanInfo(Id, planInfo);
    startDateTime := planInfo.endDate;
  end;

  nextId := ActArea.FindSchedBeforeOrAfterDate(false, startDateTime);

  if nextId = CSchedIDnull then exit;

  EndDate := startDateTime;
  LimitDate := TruncToDayDate(EndDate) + 360; // one year

  while nextId <> CSchedIdNull do
  begin
    p_sc.GetPlanInfo(nextId, planInfo);
    //if not p_sc.CanMoveTo(nextId, EndDate) then break;
    if not p_sc.CanDetach(nextId, nil, false) then break;
    if (planInfo.startDate >= LimitDate) then break;

    CapResList := TDurList.Create(self);

    planInfoTemp := planInfo;
    planInfoTemp.startDate := EndDate;
    cal.OfsByWH((planInfoTemp.supMinReal + planInfoTemp.exeMin)/60, true, planInfoTemp.startDate, planInfoTemp.endDate, actArea.m_CrossDownTmList);
    actArea.GetCapResInSpot(planInfoTemp.startDate, planInfoTemp.endDate, CapResList);
    for i := 0 to CapResList.Count -1 do
    begin

      CapRes := TMqmCapRes(CapResList.p_sons[i]);
      if CapRes.m_Type = cr_Normal then
      begin

        CompVal := TMqmRes(CapRes.p_Res).CheckCompIDCapRes(nextId, capRes);
        if CompVal = CompValNotComp then
        begin
          CapResList.Free;
          nextId := actarea.GetNextObj(planInfo.EndDate, m_id);
          EndDate := planInfo.endDate;
          goto ContinueLoop;
        end;

        if not CapRes.CheckUpMostCase(CompVal) then
        begin
          CapResList.Free;
          nextId := actarea.GetNextObj(planInfo.EndDate, m_id);
          EndDate := planInfo.endDate;
          goto ContinueLoop;
        end;
      end else if CapRes.m_Type = cr_DownTime then
      begin
        EndDate := CapRes.p_end;
        goto ContinueLoop;
      end;
    end;
    CapResList.Free;

    planInfo.startDate := EndDate;
    cal.OfsByWH((planInfo.supMinReal + planInfo.exeMin)/60, true, planInfo.startDate, planInfo.endDate, actArea.m_CrossDownTmList);
    p_opStack.ChgOccDurData(nextId, planInfo);
    p_opStack.UpdateOvlpLimits(nextId, nil);
    nextId := actarea.GetNextObj(planInfo.EndDate, nextId);
    EndDate := planInfo.endDate;

    ContinueLoop:
  end;
end;

//----------------------------------------------------------------------------//

function TMqmSchedObjMover.GetAlignedDate(actArea: TMqmActArea; AlignOpt: CAlignOpt;
                                          MouseDate, LowDate, HighDate: TDateTime;
                                          var isEnd: boolean; MatToCheck: CSetMatAlignOpt; Setup, Overlap : Double): TDateTime;
var
  nextId :  TSchedId;
  nextId_StartDate: TDateTime;
  prevId : TSchedId;
  prevId_EndDate: TDateTime;
  Cal_endDate: TDateTime;
  DatesInfo: TSQDatesInfo;
  CurrentDate: TDateTime;
  Cal: TPGCALObj;
  OvlpLowLimit, OvlpHighLimit: TDateTime;
begin
  Assert(m_id <> CSchedIdNull);
  Cal := actarea.GetCalendar;
  Cal_endDate := Cal.GetLastDate;

//  if AlignOpt = Al_Auto then
//    p_pl.SetOvplTargetRes(actArea.p_Father, OvlpChk_OptimumLimits, -1)
//  else
  p_pl.SetOvplTargetRes(actArea.p_Father, OvlpChk_OptimumLimits, Setup - Overlap);
  p_pl.GetOverlaps(OvlpLowLimit, OvlpHighLimit);

  if (overlap > 0) then
    Cal.OfsByWH(-overlap/60, false, OvlpLowLimit, OvlpLowLimit, actArea.m_CrossDownTmList);

//  p_sc.GetOvlpLimits(m_id, actArea.p_Father, OvlpLowLimit, OvlpHighLimit);

  nextId := actarea.GetNextObj(MouseDate, m_id);

  if nextId = CSchedIdNull then
    nextId_startDate := 0
  else
  begin
    p_sc.GetDatesInfo(nextId, DatesInfo);
    nextId_startDate := DatesInfo.startDate;
  end;

  prevId := m_id ;
  prevId := actarea.GetPrecObj(MouseDate, prevId);

  if prevId = CSchedIdNull then
    prevId_EndDate := 0
  else
  begin
    p_sc.GetDatesInfo(prevId, DatesInfo);
    prevId_EndDate := DatesInfo.endDate;
  end;

  if MouseDate < actarea.p_start then
    CurrentDate := actarea.p_start
  else
    CurrentDate := now;

  p_sc.GetDatesInfo(m_id, DatesInfo);

  Result := -1 ;
  case  AlignOpt  of
    Al_ToDate: Result := MouseDate;//selected date

    Al_Erliest: begin
                  if prevId = CSchedIdNull then   // no previous job
                    Result := CurrentDate
                  else
                    Result := PrevId_EndDate;

                  if (OvlpLowLimit > 0)
                  and (Result < OvlpLowLimit) then
                    Result := OvlpLowLimit;

                  isEnd := false;
                end;

    Al_Latest:  begin   //align to the most right
                  if nextId = CSchedIdNull then   // no next job
                  begin
                    if Cal_endDate < ActArea.p_end then
                      Result := Cal_endDate   //if the Calendar ends before the Active Area
                    else
                      Result := ActArea.p_end
                  end else    // we have a nexr job
                    Result := NextId_StartDate ;

                  if (OvlpHighLimit > 0)
                  and (Result > OvlpHighLimit) then
                    Result := OvlpHighLimit;

                  isEnd := true;
                end;

    Al_LowStart:begin
                  Result := MouseDate;
                  isEnd := false;

                  if (Result > DatesInfo.LowStrDate) then
                  begin
                    if (prevId = CSchedIdNull)    // no previous job
                    or (DatesInfo.LowStrDate > PrevId_EndDate) then
                      Result := DatesInfo.LowStrDate
                    else
                      Result := PrevId_EndDate;
                  end;

                  if (Result < DatesInfo.LowStrDate) then
                  begin
                    if (nextId = CSchedIdNull)    // no next job
                    or (DatesInfo.LowStrDate < NextId_StartDate) then
                      Result := DatesInfo.LowStrDate
                    else
                    begin
                      Result := NextId_StartDate;
                      isEnd := true
                    end;
                  end;

                  if Result < CurrentDate then
                    Result := CurrentDate;

                  if (OvlpLowLimit > 0)
                  and (Result < OvlpLowLimit) then
                    Result := OvlpLowLimit;

                end;

    Al_HighEnd: begin
                  Result := MouseDate;
                  isEnd := true;

                  if (Result > DatesInfo.HighEndDate) then
                  begin
                    if (prevId = CSchedIdNull)    // no previous job
                    or (DatesInfo.HighEndDate > PrevId_EndDate) then
                      Result := DatesInfo.HighEndDate
                    else
                    begin
                      Result := PrevId_EndDate;
                      isEnd := false
                    end
                  end;

                  if (Result < DatesInfo.HighEndDate) then
                  begin
                    if (nextId = CSchedIdNull)   // no next job
                    or (DatesInfo.HighEndDate < NextId_StartDate) then
                      Result := DatesInfo.HighEndDate
                    else
                      Result := NextId_StartDate;
                  end;

                  if (OvlpHighLimit > 0)
                  and (Result > OvlpHighLimit) then
                    Result := OvlpHighLimit;

                  if Result < CurrentDate then
                  begin
                    Result := CurrentDate;
                    isEnd := false
                  end;

                end;

    Al_PlanStart: begin
                    Result := MouseDate;
                    isEnd := false;

                    if (Result > DatesInfo.PlannedStrDate) then
                    begin
                      if (prevId = CSchedIdNull)    // no previous job
                      or (DatesInfo.PlannedStrDate > PrevId_EndDate) then
                        Result := DatesInfo.PlannedStrDate
                      else
                        Result := PrevId_EndDate;
                    end;

                    if (Result < DatesInfo.PlannedStrDate) then
                    begin
                      if (nextId = CSchedIdNull)    // no next job
                      or (DatesInfo.PlannedStrDate < NextId_StartDate) then
                        Result := DatesInfo.PlannedStrDate
                      else
                      begin
                        Result := NextId_StartDate;
                        isEnd := true
                      end;
                    end;

                    if Result < CurrentDate then
                      Result := CurrentDate;

                    if (OvlpLowLimit > 0)
                    and (Result < OvlpLowLimit) then
                      Result := OvlpLowLimit;

                  end;

    Al_PlanEnd: begin   //align to the most right
                  Result := MouseDate;
                  isEnd := true;

                  if (Result > DatesInfo.PlannedEndDate) then
                  begin
                    if (prevId = CSchedIdNull)    // no previous job
                    or (DatesInfo.PlannedEndDate > PrevId_EndDate) then
                      Result := DatesInfo.PlannedEndDate
                    else
                    begin
                      Result := PrevId_EndDate;
                      isEnd := false
                    end
                  end;

                  if (Result < DatesInfo.PlannedEndDate) then
                  begin
                    if (nextId = CSchedIdNull)   // no next job
                    or (DatesInfo.PlannedEndDate < NextId_StartDate) then
                      Result := DatesInfo.PlannedEndDate
                    else
                      Result := NextId_StartDate;
                  end;

                  if (OvlpHighLimit > 0)
                  and (Result > OvlpHighLimit) then
                    Result := OvlpHighLimit;

                  if Result < CurrentDate then
                  begin
                    Result := CurrentDate;
                    isEnd := false
                  end;

                end;

  end; //case

  if isEnd then
    cal.NormalizeDate(Result, ntNormalizeBackward)
  else
    cal.NormalizeDate(Result, ntNormalizeForward);
end;

//----------------------------------------------------------------------------//

function TMqmSchedObjMover.GetAlignedDateAuto(actArea: TMqmActArea; AlignOpt: CAlignOpt;
                                          MouseDate, LowDate, HighDate: TDateTime;
                                          var isEnd: boolean; LimitStart : TdateTime ;LimitEnd : TdateTime; PrevId : TSchedId; NextId : TSchedId; Setup, Overlap : Double): TDateTime;
var
//  nextId :  TSchedId;
  nextId_StartDate: TDateTime;
//  prevId : TSchedId;
  prevId_EndDate: TDateTime;
  DatesInfo: TSQDatesInfo;
//  CurrentDate: TDateTime;
  Cal: TPGCALObj;
//  OvlpLowLimit, OvlpHighLimit,
  RealLowestDate, RealHighestDate : TDateTime;
begin
  Assert(m_id <> CSchedIdNull);
  Cal := actarea.GetCalendar;

//  p_pl.SetOvplTargetRes(actArea.p_Father, OvlpChk_OptimumLimits, Setup - Overlap);
//  p_pl.GetOverlaps(OvlpLowLimit, OvlpHighLimit);
 // Cal.OfsByWH(-overlap/60, false, OvlpLowLimit, OvlpLowLimit, actArea.m_CrossDownTmList);
//  p_sc.GetOvlpLimits(m_id, actArea.p_Father, OvlpLowLimit, OvlpHighLimit);

  if nextId = CSchedIdNull then
    nextId_startDate := 0
  else
  begin
    p_sc.GetDatesInfo(nextId, DatesInfo);
    nextId_startDate := DatesInfo.startDate;
  end;

  if prevId = CSchedIdNull then
    prevId_EndDate := 0
  else
  begin
    p_sc.GetDatesInfo(prevId, DatesInfo);
    prevId_EndDate := DatesInfo.endDate;
  end;

//  if MouseDate < actarea.p_start then
//    CurrentDate := actarea.p_start
//  else
//    CurrentDate := now;

  RealLowestDate := LimitStart;
//  if (OvlpLowLimit > 0) and (RealLowestDate < OvlpLowLimit) then RealLowestDate := OvlpLowLimit;
  if (RealLowestDate > NextId_StartDate) and (NextId_StartDate > 0) then RealLowestDate := NextId_StartDate;

  RealHighestDate := LimitEnd;
//  if (OvlpHighLimit > 0) and (RealHighestDate > OvlpHighLimit) then RealHighestDate := OvlpHighLimit;
  if (RealHighestDate < PrevId_EndDate) and (PrevId_EndDate > 0) then RealHighestDate := PrevId_EndDate;

  p_sc.GetDatesInfo(m_id, DatesInfo);

  Result := -1 ;
  case  AlignOpt  of
    Al_ToDate: Result := MouseDate;//selected date

    Al_LowStart:begin
                  Result := MouseDate;
                  isEnd := false;

                  if (Result > DatesInfo.LowStrDate) then
                  begin
                    if (prevId = CSchedIdNull)    // no previous job
                    or ((prevId <> CSchedIdNull) and (DatesInfo.LowStrDate > PrevId_EndDate)) then
                      Result := DatesInfo.LowStrDate
                    else
                      Result := PrevId_EndDate;
                    if Result < RealLowestDate then Result := RealLowestDate;
                  end;

                  if (Result < DatesInfo.LowStrDate) then
                  begin
                    if (nextId = CSchedIdNull)    // no next job
                    or ((nextId <> CSchedIdNull) and (DatesInfo.LowStrDate < NextId_StartDate)) then
                      Result := DatesInfo.LowStrDate
                    else
                    begin
                      Result := NextId_StartDate;
                      isEnd := true
                    end;
                    if Result > RealHighestDate then Result := RealHighestDate;
                  end;
                end;

    Al_Erliest : begin
                  if prevId = CSchedIdNull then   // no previous job
                    Result := AutoSchedCfg.m_NowDateTime
                  else
                    Result := PrevId_EndDate;

                  if Result < RealLowestDate then Result := RealLowestDate;
                  isEnd := false;
                end;

    Al_HighEnd: begin
                  Result := MouseDate;
                  isEnd := true;

                  if (Result > DatesInfo.HighEndDate) then
                  begin
                    if (prevId = CSchedIdNull)    // no previous job
                    or ((prevId <> CSchedIdNull) and (DatesInfo.HighEndDate > PrevId_EndDate)) then
                      Result := DatesInfo.HighEndDate
                    else
                    begin
                      Result := PrevId_EndDate;
                      isEnd := false
                    end;
                    if Result < RealLowestDate then Result := RealLowestDate;
                  end;

                  if (Result < DatesInfo.HighEndDate) then
                  begin
                    if (nextId = CSchedIdNull)   // no next job
                    or ((nextId <> CSchedIdNull) and (DatesInfo.HighEndDate < NextId_StartDate)) then
                      Result := DatesInfo.HighEndDate
                    else
                      Result := NextId_StartDate;
                    if Result > RealHighestDate then Result := RealHighestDate;
                  end;
                end;

  end; //case

  if isEnd then
    cal.NormalizeDate(Result, ntNormalizeBackward)
  else
    cal.NormalizeDate(Result, ntNormalizeForward);
end;

end.

