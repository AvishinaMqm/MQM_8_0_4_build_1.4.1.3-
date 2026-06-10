unit UMPlanFunc;

interface

uses
  UMSchedContFunc, gnugettext;

  function CanAddJobToGroupOnPlan(job, grp: TSchedID; out ErrDesc: string): boolean;
  function CanAddJobToGroupOnBin(job, grp: TSchedID; out ErrDesc: string): boolean;
  function CanAddJobToGroupSameType(job, Jobgrp: TSchedID; out ErrDesc: string): boolean;
  function CutTimetoSecond(Minutes : double) : double;
  procedure UpdContGrpTimings(grp: TSchedID; LastId : TSchedID);
  procedure UpdContGrpTimingsForBatchContTime(grp: TSchedID; LastId : TSchedID; JobComponent: integer; GrpStartDate : TDateTime);
  function UpdContGrpTimingsForSingleJob(grp: TSchedID; ChildId : TSchedID; ResObj : Tobject; VisResPtr : pointer; var SetUp : double) : double;
  function UpdContGrpTimingsForSingleJobBatchContTime(grp: TSchedID; ChildId : TSchedID; ResObj : Tobject; var SetUp : double; JobComponent: integer) : double;

//  procedure UpdBatchInsideContGrpTimings(grp: TSchedID; var duration : double);
  function CalcSplitQty(id: TSchedID; SplitType: integer; QtyType: integer;
                        SplitQty: currency;
                        SplitNo: integer; QtyPerJob: currency;
                        out OrigJobQty: currency; out EachJobQty: currency;
                        out NewJobNr: integer;
                        out Err: string): boolean;

  function CalcSplitQtyGrp(id: TSchedID; SplitType: integer;
                        SplitQty: currency; SplitNo: integer; QtyPerJob: currency;
                        out OrigJobQty: currency; out EachJobQty: currency;
                        out NewJobNr: integer; out Err: string): boolean;

  function CalcSplitQtyAlternative(id: TSchedID; SplitType: integer; QtyType: integer;
                        SplitQty: currency;
                        SplitNo: integer; QtyPerJob: currency;
                        out OrigJobQty: currency; out EachJobQty: currency;
                        out NewJobNr: integer;
                        out Err: string; out OrigJobQtyAlt : currency; out EachJobQtyAlt: currency): boolean;

  function CalcSplitQtyGrpAlternative(id: TSchedID; SplitType: integer;
                        SplitQty: currency; SplitNo: integer; QtyPerJob: currency;
                        out OrigJobQty: currency; out EachJobQty: currency;
                        out NewJobNr: integer; out Err: string): boolean;
  function GetEnableGroupAutomaticInternalSortingSequence : boolean;

implementation

uses
  UMRes,
  UMWkCtr,
  UMSchedCont,
  UMCompatRules,
  UMCompat,
  UMObjCont,
  UMActArea,
  UMglobal,
  FMOccMov,
  UMSchedObjMover,
  SysUtils,
  UGBaseCal;

var
  m_EnableGroupAutomaticInternalSortingSequence : boolean;

//----------------------------------------------------------------------------//

function GetEnableGroupAutomaticInternalSortingSequence : boolean;
begin
  Result := m_EnableGroupAutomaticInternalSortingSequence
end;

//----------------------------------------------------------------------------//

function CanAddJobToGroupOnPlan(job, grp: TSchedID; out ErrDesc: string): boolean;
var
  apa:       TMqmActArea;
  res:       TMqmRes;
  Value:     variant;
  dataType:  CBinColValType;
  grpQty:    double;
  jobQty:    double;
  ResMaxQty, ResMinQty : double;
  GrpJobId:  TSchedID;
  supRec:    TSetupRec;
  compatVal: TCompatVal;
  i:         integer;
  SameGroup: boolean;
  MultQty  : double;
  JobInfo, GroupInfo : TSQplanInfo;
  LearningCurveCode : string;
  AdditionalMultiplierProp : double;
begin
  ErrDesc := _('Undefined error');
  Result := false;
  SameGroup := true;
  if (not p_sc.GetFldValue(grp, CSC_StepType, Value, dataType)) then exit;

  apa := TMqmActArea(p_sc.GetExtLinkPtr(grp));
  Assert(Assigned(apa));

  res := TMqmRes(apa.p_Res);

  for i := 0 to p_sc.GetGrpNumSons(grp)-1 do
  begin
    GrpJobId := p_sc.GetGrpSon(grp, i);
    Res.GetSetupParms(job, GrpJobId, supRec, compatVal, SameGroup, LearningCurveCode);
    if not SameGroup then
    begin
      ErrDesc := _('Not compatible');
      exit
    end;
    Res.GetSetupParms(GrpJobId, job, supRec, compatVal, SameGroup, LearningCurveCode);
    if not SameGroup then
    begin
      ErrDesc := _('Not compatible');
      exit
    end
  end;

  if value = CST_batch then
  begin
    p_sc.GetJobInfo(Job, JobInfo);
    p_sc.GetJobInfo(Grp, GroupInfo);
    if JobInfo.BatchSizePerStep or (JobInfo.MaxBatchSize = -1) then
    begin
      jobQty := JobInfo.quant;
      grpQty := GroupInfo.quant;
    end
    else
    begin
      if (not p_sc.QtyInUM(grp, res.p_BchUM, grpQty, MultQty)) or
         (not p_sc.QtyInUM(job, res.p_BchUM, jobQty, MultQty)) then exit;
    end;

    AdditionalMultiplierProp := res.P_GetAdditionalOptimumMaxMultiplierProp[job];
    if JobInfo.BatchSizePerStep then
      ResMaxQty := JobInfo.MaxBatchSize
    else
      ResMaxQty := res.p_Max_bch_size*AdditionalMultiplierProp;
    if (grpQty+jobQty) > ResMaxQty then
    begin
      ErrDesc := _('The group quantity is too high');
      exit
    end;

  end;

  Result := true
end;

//----------------------------------------------------------------------------//

function CanAddJobToGroupOnBin(job, grp: TSchedID; out ErrDesc: string): boolean;
var
  wkc:       TMqmWrkCtr;
  Value:     variant;
  dataType:  CBinColValType;
  GrpJobId:  TSchedID;
  supRec:    TSetupRec;
  compatVal: TCompatVal;
  i:         integer;
  SameGroup: boolean;
begin
  ErrDesc := _('Undefined error');
  Result  := false;
  SameGroup := true;

  Assert(not Assigned(p_sc.GetExtLinkPtr(grp)));

  if (not p_sc.GetFldValue(grp, CSC_WkctCode, Value, dataType)) then exit;
  wkc := TMqmWrkCtr(p_sc.GetWrkCtrPtr(grp));

  if not Assigned(wkc) then exit;

  for i := 0 to p_sc.GetGrpNumSons(grp)-1 do
  begin
    GrpJobId := p_sc.GetGrpSon(grp, i);
    wkc.GetSetupParms(job, GrpJobId, supRec, compatVal, SameGroup);
    if not SameGroup then
    begin
      ErrDesc := _('Not compatible');
      exit
    end;
    wkc.GetSetupParms(GrpJobId, job, supRec, compatVal, SameGroup);
    if not SameGroup then
    begin
      ErrDesc := _('Not compatible');
      exit
    end
  end;

  Result := true
end;

//----------------------------------------------------------------------------//

function CanAddJobToGroupSameType(job, Jobgrp: TSchedID; out ErrDesc: string): boolean;
var
  wkc:       TMqmWrkCtr;
  Value:     variant;
  dataType:  CBinColValType;
  supRec:    TSetupRec;
  compatVal: TCompatVal;
  SameGroup: boolean;
begin
  ErrDesc := _('Undefined error');
  Result  := false;
  SameGroup := true;

  Assert(not Assigned(p_sc.GetExtLinkPtr(Jobgrp)));

  if (not p_sc.GetFldValue(Jobgrp, CSC_WkctCode, Value, dataType)) then exit;
  wkc := TMqmWrkCtr(p_sc.GetWrkCtrPtr(Jobgrp));

  if not Assigned(wkc) then exit;

  wkc.GetSetupParms(job, Jobgrp, supRec, compatVal, SameGroup);
  if not SameGroup then
  begin
    ErrDesc := _('Not compatible');
    exit
  end;
  wkc.GetSetupParms(Jobgrp, job, supRec, compatVal, SameGroup);
  if not SameGroup then
  begin
    ErrDesc := _('Not compatible');
    exit
  end;

  Result := true
end;

//----------------------------------------------------------------------------//

procedure UpdContGrpTimingsForBatchContTime(grp: TSchedID; LastId : TSchedID; JobComponent: integer; GrpStartDate : TDateTime);
var
  cal:          TPGCALObj;
  act:          TMqmActArea;
  i : integer;
  idCurr, prevID : TSchedId;
  planInfoCurr, FirstIdplanInfo: TSQplanInfo;
  StartDate, EndDate, ForcedEndDate, DummyDate, CurrentDate :  TDateTime;
  origSetup, setup, overlap, DurationOfAllbefore : double;
  DummyStr, LearningCurveCode, TmgDescr, TmgMSC : string;
  DummyDbl1 , DummyDbl2 : double;
  Res: TMQMRes;
  moveChgInfo : TSQmoveChgInfo;
  VisRes : TMqmVisibleRes;
  duration, RemainCurve, RemainExecusion, TotalExe, TotalExeWithCurve, TotalQty, TotalProgressed : double;
  HandleLearningCurve, AllJobsFinal : boolean;
  ProgressLevel : CProgress;
  FoundOneProgress : boolean;
  ProgressMinutes : double;
begin
  FoundOneProgress := false;
  act := p_sc.GetExtLinkPtr(grp);
  if not assigned(act) then exit;
  cal := act.GetCalendar;
  Assert(Assigned(cal));

  idCurr := p_sc.GetGrpSon(grp, 0);
  p_sc.GetPlanInfo(idCurr, FirstIdplanInfo);
  // Need to start from the lowest date of the group - It was changed because of split of group and replace requests
  // StartDate := FirstIdplanInfo.startDate;   // The start date is already affected from the first progress
  StartDate := GrpStartDate;
  CurrentDate := StartDate;

  p_pl.GetSubTimings(0, idCurr, FirstIdplanInfo.supMinReal, FirstIdplanInfo.exeMin, FirstIdplanInfo.TmgDescr, FirstIdplanInfo.MSC);

  prevID := act.GetPrecObj(StartDate, idCurr);
  if (prevID <> CSchedIdNull) then
  begin
    CalcSetup(idCurr, prevID, act , FirstIdplanInfo.supMinBase, setup, overlap, DummyStr, DummyDbl1, DummyDbl2, LearningCurveCode);
    origSetup := setup;
  end
  else
    origSetup := FirstIdplanInfo.supMinReal;

  if (p_sc.GetLearningCurveCode(grp) <> '') then
  begin
    HandleLearningCurve := true;
    DurationOfAllbefore := act.GetDurationOfAllJobsBeforeThisSpot(StartDate, grp);
  end
  else
    HandleLearningCurve := false;

  TotalExe := 0;
  AllJobsFinal := true;
  ForcedEndDate := 0;
  TotalQty := 0;
  TotalProgressed := 0;
  for i := 0 to p_sc.GetGrpNumSons(Grp)-1 do
  begin
    idCurr := p_sc.GetGrpSon(grp, i);
    p_sc.GetPlanInfo(idCurr, planInfoCurr);
    p_pl.GetSubTimings(i, idCurr, planInfoCurr.supMinReal, planInfoCurr.exeMin, planInfoCurr.TmgDescr, planInfoCurr.MSC);
    ProgressLevel := CProgress(p_sc.IsProgressed(idCurr));
    if ProgressLevel <> prg_none then
    begin
       FoundOneProgress := true;
       origSetup := 0;
    end;
    CalcDurBeforeCurve(idCurr, planInfoCurr.exeMin, JobComponent);
    TotalExe := TotalExe + planInfoCurr.exeMin;
    TotalQty := TotalQty + planInfoCurr.quant;
    if (ProgressLevel = prg_Final) or (ProgressLevel = prg_FinalSplit) or (ProgressLevel = prg_General) then
    begin
      if ProgressLevel = prg_General then
      begin
        TotalProgressed := TotalProgressed + p_sc.GetProgressedQuantity(idCurr);
        AllJobsFinal := false;
        if CurrentDate < planInfoCurr.CurrentProgressDate then
          CurrentDate := planInfoCurr.CurrentProgressDate;
      end
      else
      begin
        if planInfoCurr.EndProgressDate > ForcedEndDate then
          ForcedEndDate := planInfoCurr.EndProgressDate;
        TotalProgressed := TotalProgressed + planInfoCurr.quant;
      end;
    end
    else
      AllJobsFinal := false;
  end;

  if CurrentDate < ForcedEndDate then
     CurrentDate := ForcedEndDate;

  if (not AllJobsFinal) and (TotalQty <= TotalProgressed) then
  begin
    AllJobsFinal := true;
    ForcedEndDate := CurrentDate;
  end;

  idCurr := p_sc.GetGrpSon(grp, 0);

  ProgressMinutes := 0;
  RemainExecusion := 0;
  if AllJobsFinal then
  begin
    EndDate := ForcedEndDate;
    ProgressMinutes := cal.DiffWH(StartDate, EndDate , act.m_CrossDownTmList)*60;
  end
  else
  begin
    RemainExecusion := (TotalQty - TotalProgressed)/TotalQty*TotalExe;
    if HandleLearningCurve then
    begin
      ProgressMinutes := 0;
      if CurrentDate > StartDate  then
      begin
        ProgressMinutes := cal.DiffWH(StartDate, CurrentDate , act.m_CrossDownTmList)*60;
      end;
      RemainCurve := GetCurveTime(nil, 0 ,idCurr, RemainExecusion, false, (DurationOfAllbefore+ProgressMinutes));
    end
    else
      RemainCurve := 0;
    DummyDate := CurrentDate;
    cal.OfsByWH((origSetup+RemainCurve+RemainExecusion) / 60, true, DummyDate, EndDate, act.m_CrossDownTmList);
  end;

  TotalExeWithCurve := TotalExe;
  if HandleLearningCurve then
    TotalExeWithCurve := TotalExe + GetCurveTime(act, StartDate, idCurr, ProgressMinutes+RemainExecusion, false, DurationOfAllbefore);

  for i := 0 to p_sc.GetGrpNumSons(Grp)-1 do
  begin
    idCurr := p_sc.GetGrpSon(grp, i);
    p_sc.GetPlanInfo(idCurr, planInfoCurr);
{    if i = 0 then
      planInfoCurr.supMinReal := origSetup
    else
      planInfoCurr.supMinReal := 0;  }
    planInfoCurr.supMinReal := origSetup;
    planInfoCurr.exeMin := TotalExeWithCurve;
    planInfoCurr.startDate := StartDate;
    planInfoCurr.endDate :=  EndDate;

    if not FoundOneProgress then
    begin
      planInfoCurr.SchedStarttOfJobInContGroup := StartDate;
      planInfoCurr.SchedEndtOfJobInContGroup := EndDate;
      //p_sc.setSchedStartOfJobInContGroup(idCurr, StartDate);    // avi 16/12/2025
      //p_sc.setSchedEndOfJobInContGroup(idCurr, EndDate);        // Solving Undo issue
    end;

    p_opStack.ChgOccDurData(idCurr, planInfoCurr);
  end;

  if grp <> LastId then
    p_pl.SetTmgMainID(LastId);

  p_sc.SetOvlpLimitsFlag(grp, false);
end;

//----------------------------------------------------------------------------//

function CutTimetoSecond(Minutes : double) : double;
var
  SecondsInteger, MinutesInteger  : integer;
begin
  SecondsInteger := trunc(Minutes * 60);
  MinutesInteger := trunc(SecondsInteger / 60 * 100);
  Result := MinutesInteger / 100;
  if (Minutes > 0) and (Result = 0) then
    Result := Minutes;
end;

//----------------------------------------------------------------------------//

procedure UpdContGrpTimings(grp: TSchedID; LastId : TSchedID);
var
  cal:          TPGCALObj;
  act:          TMqmActArea;
  i,j, StartSeq: integer;
  idCurr, SonId:       TSchedId;
  planInfoCurr : TSQplanInfo;
  prevID:        TSchedId;
  StartDate, EndDate, GrpStartDate, GrpEndDate, TempEndDate, FirstJobStartDate :  TDateTime;
  origSetup:    double;
  OldGrpSeq, NewGrpSeq:    string;
  setup, overlap, DurationOfAllbefore : double;
  DummyStr, LearningCurveCode : string;
  DummyDbl1 , DummyDbl2 : double;
  Res: TMQMRes;
  JobComponent, ResComp, NumOfRscComp : Integer;
  VisRes : TMqmVisibleRes;
  TmgDescr: string;
  TmgMSC: string;
  duration, RemainCurve, RemainExecusion, ExeBeforeCurve, TotalExe, ProgressMinutes : double;
  HandleLearningCurve, Is_batch_ContinuesTime : boolean;
  ProgressLevel : CProgress;
  FoundOneProgress : boolean;
begin
  act := p_sc.GetExtLinkPtr(grp);
  if not assigned(act) then exit;
  FoundOneProgress := false;
  cal := act.GetCalendar;
  Assert(Assigned(cal));
  p_sc.GetPlanInfo(grp, planInfoCurr);
  GrpStartDate := planInfoCurr.startDate;
  GrpEndDate := planInfoCurr.endDate;

  Assert(planInfoCurr.isGroup);
//  GroupEndDate := planInfoCurr.endDate;
  Is_batch_ContinuesTime := planInfoCurr.Is_batch_ContinuesTime;

  for i := 0 to p_sc.GetGrpNumSons(Grp)-1 do
  begin
    idCurr := p_sc.GetGrpSon(Grp, i);
    p_sc.GetPlanInfo(idCurr, planInfoCurr);
    if (CProgress(p_sc.IsProgressed(idCurr)) <> prg_none) then
    begin
      FoundOneProgress := true;
      continue;
    end;
    if planInfoCurr.exeMin = 0 then
    begin
      p_pl.SetTmgMainID(idCurr);
      p_pl.SetTmgTargetResForGroup(TMqmRes(act.p_res));
      p_pl.GetMainTimings(planInfoCurr.supMinBase, duration, TmgDescr, TmgMSC);
      planInfoCurr.exeMin := duration;
      p_sc.SetPlanInfo(idCurr, planInfoCurr);
    end;
  end;

  m_EnableGroupAutomaticInternalSortingSequence := true;
  p_sc.SortGroup(Grp);
  m_EnableGroupAutomaticInternalSortingSequence := false;
  p_pl.SetTmgMainID(grp);
  p_pl.UpdateGrpTmg;
  p_pl.SetTmgTargetResForGroup(TMqmRes(act.p_res));

  JobComponent := 1;
  Res := TMQMRes(act.p_Res);
  if Assigned(Res) and Res.p_isMultiRes then
  begin
    begin
      numOfRscComp := p_sc.GetJobComponents(idCurr, false);
      VisRes := TMqmVisibleRes(act.p_Father);
      if p_sc.GetRscComponentFromJobOrStep(idCurr) > 0 then
        ResComp := p_sc.GetRscComponentFromJobOrStep(idCurr)
      else
        ResComp := Res.p_ResComp;
      JobComponent := ResComp;
      if (GetOccMoveForm <> nil) and (p_pl.GetCompatModeInPlanId = Grp) then
      begin
        if (GetOccMoveForm.LbEInputUser.Text <> '') and (StrToInt(GetOccMoveForm.LbEInputUser.Text) <> JobComponent) then
           JobComponent := StrToInt(GetOccMoveForm.LbEInputUser.Text);
      end
      else
        JobComponent := numOfRscComp;
    end;
  end;

  if Is_batch_ContinuesTime then
  begin
    UpdContGrpTimingsForBatchContTime(grp,LastId,JobComponent,GrpStartDate);
    exit;
  end;

  idCurr := p_sc.GetGrpSon(grp, 0);
  p_sc.GetPlanInfo(idCurr, planInfoCurr);
  // Need to start from the lowest date of the group - It was changed because of split of group and replace requests
  // StartDate := planInfoCurr.startDate;   // The start date is already affected from the first progress
  StartDate := GrpStartDate;
  FirstJobStartDate := StartDate;

  p_pl.GetSubTimings(0, idCurr, planInfoCurr.supMinReal, planInfoCurr.exeMin, planInfoCurr.TmgDescr, planInfoCurr.MSC);

  Assert((p_sc.GetJobType(idCurr) <> CST_batch));

  prevID := act.GetPrecObj(StartDate, grp);
  if (prevID <> CSchedIdNull) then
  begin
    CalcSetup(grp, prevID, act , planInfoCurr.supMinBase, setup, overlap, DummyStr, DummyDbl1, DummyDbl2, LearningCurveCode);
    origSetup := setup;//planInfoCurr.supMinReal;
  end
  else
    origSetup := planInfoCurr.supMinReal;

  if (p_sc.GetLearningCurveCode(grp) <> '') then
  begin
    HandleLearningCurve := true;
    DurationOfAllbefore := act.GetDurationOfAllJobsBeforeThisSpot(StartDate, grp);
  end
  else
    HandleLearningCurve := false;

  //-------------------------------------------------------------------------------
  // Continues groups with sequences inside does not support learning curve  !!!
  //-------------------------------------------------------------------------------

  CalcDurBeforeCurve(idCurr, planInfoCurr.exeMin, JobComponent);
  TotalExe := planInfoCurr.exeMin;
  if HandleLearningCurve then
    planInfoCurr.exeMin := planInfoCurr.exeMin + GetCurveTime(act, StartDate, idCurr, TotalExe, false, DurationOfAllbefore);

  ProgressLevel := CProgress(p_sc.IsProgressed(idCurr));

  if (ProgressLevel = prg_Final) or (ProgressLevel = prg_FinalSplit) or (ProgressLevel = prg_General) then
  begin
    if ProgressLevel = prg_General then
    begin
      if planInfoCurr.quant > p_sc.GetProgressedQuantity(idCurr) then
        RemainExecusion := (planInfoCurr.quant - p_sc.GetProgressedQuantity(idCurr))/planInfoCurr.quant*TotalExe
      else
        RemainExecusion := 0;
      RemainCurve := 0;
      if HandleLearningCurve then
      begin
        ProgressMinutes := 0;
        if planInfoCurr.CurrentProgressDate > StartDate  then
        begin
          ProgressMinutes := cal.DiffWH(StartDate, planInfoCurr.CurrentProgressDate , act.m_CrossDownTmList)*60;
        end;
        RemainCurve := GetCurveTime(nil, 0 ,idCurr, RemainExecusion, false, (DurationOfAllbefore+ProgressMinutes));
      end;
      cal.OfsByWH((CutTimetoSecond(RemainCurve+RemainExecusion) / 60), true, planInfoCurr.CurrentProgressDate, TempEndDate, act.m_CrossDownTmList);
    end
    else
      TempEndDate := planInfoCurr.endDate;
  end
  else
    cal.OfsByWH((origSetup+CutTimetoSecond(planInfoCurr.exeMin)) / 60, true, StartDate, TempEndDate, act.m_CrossDownTmList);

  p_opStack.ChgOccDurData(idCurr, planInfoCurr);

  EndDate := TempEndDate;
  OldGrpSeq := planInfoCurr.GrpSequence;
  i := 0;
  StartSeq := 0;
  while True do
  begin
    i := i + 1;
    if i < p_sc.GetGrpNumSons(grp) then
    begin
      idCurr := p_sc.GetGrpSon(grp, i);
      p_sc.GetPlanInfo(idCurr, planInfoCurr);
      p_pl.GetSubTimings(i, idCurr, planInfoCurr.supMinReal, planInfoCurr.exeMin, planInfoCurr.TmgDescr, planInfoCurr.MSC);
      NewGrpSeq := planInfoCurr.GrpSequence;
    end;
    if (i = p_sc.GetGrpNumSons(grp)) or (OldGrpSeq = '') or (NewGrpSeq = '') or (OldGrpSeq <> NewGrpSeq) then
    begin

      for j := StartSeq to i - 1 do
      begin
        idCurr := p_sc.GetGrpSon(grp, j);
        p_sc.GetPlanInfo(idCurr, planInfoCurr);
        planInfoCurr.supMinReal := origSetup;
        planInfoCurr.startDate := StartDate;
        planInfoCurr.endDate :=  EndDate;
        if not FoundOneProgress then
        begin
          planInfoCurr.SchedStarttOfJobInContGroup := StartDate;
          planInfoCurr.SchedEndtOfJobInContGroup := EndDate;
//        p_sc.setSchedStartOfJobInContGroup(idCurr, StartDate);  // avi 16/12/2025
//        p_sc.setSchedEndOfJobInContGroup(idCurr, EndDate);      // solving Undo issue
        end;
        p_opStack.ChgOccDurData(idCurr, planInfoCurr);
      end;
      if i = p_sc.GetGrpNumSons(grp) then break;
      origSetup := 0;
      OldGrpSeq := NewGrpSeq;
      StartDate := EndDate;
      EndDate := 0;
      startseq := i;
    end;

    idCurr := p_sc.GetGrpSon(grp, i);
    p_sc.GetPlanInfo(idCurr, planInfoCurr);
    p_pl.GetSubTimings(i, idCurr, planInfoCurr.supMinReal, planInfoCurr.exeMin, planInfoCurr.TmgDescr, planInfoCurr.MSC);
    CalcDurBeforeCurve(idCurr, planInfoCurr.exeMin, JobComponent);
    ExeBeforeCurve := planInfoCurr.exeMin;
    TotalExe := TotalExe + planInfoCurr.exeMin;
    if HandleLearningCurve then
    begin
      ProgressMinutes := 0;
      if StartDate > FirstJobStartDate  then
      begin
        ProgressMinutes := cal.DiffWH(FirstJobStartDate, StartDate , act.m_CrossDownTmList)*60;
      end;
      planInfoCurr.exeMin := planInfoCurr.exeMin + GetCurveTime(act, StartDate, idCurr, ExeBeforeCurve, false, ProgressMinutes+DurationOfAllbefore);
    end;

    ProgressLevel := CProgress(p_sc.IsProgressed(idCurr));
    if (ProgressLevel = prg_Final) or (ProgressLevel = prg_FinalSplit) or (ProgressLevel = prg_General) then
    begin
      if ProgressLevel = prg_General then
      begin
        if planInfoCurr.quant > p_sc.GetProgressedQuantity(idCurr) then
          RemainExecusion := (planInfoCurr.quant - p_sc.GetProgressedQuantity(idCurr))/planInfoCurr.quant*ExeBeforeCurve
        else
          RemainExecusion := 0;
        RemainCurve := 0;
        if HandleLearningCurve then
        begin
          ProgressMinutes := 0;
          if planInfoCurr.CurrentProgressDate > FirstJobStartDate  then
          begin
            ProgressMinutes := cal.DiffWH(FirstJobStartDate, planInfoCurr.CurrentProgressDate , act.m_CrossDownTmList)*60;
          end;
          RemainCurve := GetCurveTime(nil, 0 ,idCurr, RemainExecusion, false, (DurationOfAllbefore+ProgressMinutes));
        end;

        cal.OfsByWH((CutTimetoSecond(RemainCurve+RemainExecusion) / 60), true, planInfoCurr.CurrentProgressDate, TempEndDate, act.m_CrossDownTmList);
      end
      else
        TempEndDate := planInfoCurr.endDate;
    end
    else
      cal.OfsByWH((origSetup+CutTimetoSecond(planInfoCurr.exeMin)) / 60, true, StartDate, TempEndDate, act.m_CrossDownTmList);

    if (i = (p_sc.GetGrpNumSons(grp) - 1)) and (not FoundOneProgress) then
    begin
      TempEndDate := GrpEndDate;
    end;

    p_opStack.ChgOccDurData(idCurr, planInfoCurr);

    if TempEndDate > EndDate then
      EndDate := TempEndDate;

  end;

  if grp <> LastId then
    p_pl.SetTmgMainID(LastId);

  p_sc.SetOvlpLimitsFlag(grp, false);
end;

//----------------------------------------------------------------------------//

function UpdContGrpTimingsForSingleJobBatchContTime(grp: TSchedID; ChildId : TSchedID; ResObj : Tobject; var SetUp : double; JobComponent: integer) : double;
var
  i : integer;
  idCurr :       TSchedId;
  planInfoCurr : TSQplanInfo;
  TotalExe, ExeBeforeCurve, TotalQty, DurationOfAllbefore:  double;
  TmgDescr: string;
  TmgMSC: string;
  HandleLearningCurve : boolean;
  apa : TMqmActArea;
begin
  Result := 0;
  setup := 0;
  JobComponent := 1;
  apa := TMqmActArea(p_sc.GetExtLinkPtr(grp));
  if not (Assigned(apa)) then exit;
  idCurr := p_sc.GetGrpSon(grp, 0);
  p_sc.GetPlanInfo(idCurr, planInfoCurr);
  p_pl.GetSubTimings(0, idCurr, planInfoCurr.supMinReal, planInfoCurr.exeMin, planInfoCurr.TmgDescr, planInfoCurr.MSC);
  if (p_sc.GetLearningCurveCode(grp) <> '') then
  begin
    HandleLearningCurve := true;
    DurationOfAllbefore := apa.GetDurationOfAllJobsBeforeThisSpot(planInfoCurr.StartDate, idCurr);
  end
  else
    HandleLearningCurve := false;

  TotalExe := 0;
  TotalQty := 0;
  for i := 0 to p_sc.GetGrpNumSons(Grp)-1 do
  begin
    idCurr := p_sc.GetGrpSon(grp, i);
    p_sc.GetPlanInfo(idCurr, planInfoCurr);
    p_pl.GetSubTimings(i, idCurr, planInfoCurr.supMinReal, planInfoCurr.exeMin, planInfoCurr.TmgDescr, planInfoCurr.MSC);
    CalcDurBeforeCurve(idCurr, planInfoCurr.exeMin, JobComponent);
    TotalExe := TotalExe + planInfoCurr.exeMin;
    TotalQty := TotalQty + planInfoCurr.quant;
  end;

  idCurr := p_sc.GetGrpSon(grp, 0);
  Result := TotalExe;
  if HandleLearningCurve then
    Result := TotalExe + GetCurveTime(apa, planInfoCurr.startDate, idCurr, TotalExe, false, DurationOfAllbefore);

  setup := 0;
  if ChildId = idCurr then
    setup  := planInfoCurr.supMinReal;

  p_sc.SetOvlpLimitsFlag(grp, false);
end;

//----------------------------------------------------------------------------//

function UpdContGrpTimingsForSingleJob(grp: TSchedID; ChildId : TSchedID; ResObj : Tobject; VisResPtr : pointer; var SetUp : double) : double;
var
  i : integer;
  idCurr :       TSchedId;
  planInfo:     TSQplanInfo;
  planInfoCurr : TSQplanInfo;
  TotalExe, ExeBeforeCurve, DurationOfAllbefore:  double;
  DummyStr, LearningCurveCode : string;
  DummyDbl1 , DummyDbl2 : double;
  JobComponent, ResComp, numOfRscComp : Integer;
  VisRes : TMqmVisibleRes;
  TmgDescr: string;
  TmgMSC: string;
  duration : double;
  HandleLearningCurve : boolean;
  Res : TMQMRes;
  apa : TMqmActArea;
begin
  Result := 0;
  setup := 0;
  JobComponent := 1;

  apa := TMqmActArea(p_sc.GetExtLinkPtr(grp));
  if not (Assigned(apa)) then exit;

  p_sc.SortGroup(Grp);

  p_sc.GetPlanInfo(grp, planInfo);
  Assert(planInfo.isGroup);

  p_pl.SetTmgMainID(grp);
  p_pl.UpdateGrpTmg;
  p_pl.SetTmgTargetResForGroup(ResObj);

  Res := TMQMRes(ResObj);
  if Assigned(Res) and Res.p_isMultiRes then
  begin
    begin
      numOfRscComp := p_sc.GetJobComponents(idCurr, false);
      VisRes := TMqmVisibleRes(VisResPtr);
      if p_sc.GetRscComponentFromJobOrStep(idCurr) > 0 then
        ResComp := p_sc.GetRscComponentFromJobOrStep(idCurr)
      else
        ResComp := Res.p_ResComp;
      JobComponent := ResComp;
      if (GetOccMoveForm <> nil) and (p_pl.GetCompatModeInPlanId = Grp) then
      begin
        if (GetOccMoveForm.LbEInputUser.Text <> '') and (StrToInt(GetOccMoveForm.LbEInputUser.Text) <> JobComponent) then
           JobComponent := StrToInt(GetOccMoveForm.LbEInputUser.Text);
      end
      else
        JobComponent := numOfRscComp;
    end;
  end;

  if planInfoCurr.Is_batch_ContinuesTime then
  begin
    Result := UpdContGrpTimingsForSingleJobBatchContTime(grp,ChildId,ResObj,SetUp,JobComponent);
    exit;
  end;

  idCurr := p_sc.GetGrpSon(grp, 0);
  p_sc.GetPlanInfo(idCurr, planInfoCurr);

  p_pl.GetSubTimings(0, idCurr, planInfoCurr.supMinReal, planInfoCurr.exeMin, planInfoCurr.TmgDescr, planInfoCurr.MSC);

  Assert((p_sc.GetJobType(idCurr) <> CST_batch) or planInfo.Is_batch_ContinuesTime);

  if (p_sc.GetLearningCurveCode(grp) <> '') then
  begin
    HandleLearningCurve := true;
    DurationOfAllbefore := apa.GetDurationOfAllJobsBeforeThisSpot(planInfoCurr.StartDate, idCurr);
  end
  else
    HandleLearningCurve := false;

  //-------------------------------------------------------------------------------
  // Continues groups with sequences inside does not support learning curve  !!!
  //-------------------------------------------------------------------------------

  TotalExe := planInfoCurr.exeMin;
  CalcDurBeforeCurve(idCurr, planInfoCurr.exeMin, JobComponent);
  if HandleLearningCurve then
    planInfoCurr.exeMin := planInfoCurr.exeMin + GetCurveTime(apa, planInfoCurr.startDate, idCurr, TotalExe, false, DurationOfAllbefore);

  Result := planInfoCurr.exeMin;

  if ChildId = idCurr then
  begin
    setup  := planInfoCurr.supMinReal;
    Result := planInfoCurr.exeMin;
    exit;
  end;
  setup := 0;

  for I := 1 to p_sc.GetGrpNumSons(grp) - 1 do
  begin
    idCurr := p_sc.GetGrpSon(grp, i);
    p_pl.GetSubTimings(i, idCurr, planInfoCurr.supMinReal, planInfoCurr.exeMin, planInfoCurr.TmgDescr, planInfoCurr.MSC);
    CalcDurBeforeCurve(idCurr, planInfoCurr.exeMin, JobComponent);
    ExeBeforeCurve := planInfoCurr.exeMin;
    TotalExe := TotalExe + planInfoCurr.exeMin;
    if HandleLearningCurve then
      planInfoCurr.exeMin := planInfoCurr.exeMin + GetCurveTime(apa, planInfoCurr.startDate, idCurr, TotalExe, false, DurationOfAllbefore);
    if ChildId = idCurr then
    begin
      Result := planInfoCurr.exeMin;
      setup := 0;
      p_sc.SetOvlpLimitsFlag(grp, false);
      exit;
    end;
  end;
  p_sc.SetOvlpLimitsFlag(grp, false);
end;

//----------------------------------------------------------------------------//

function CalcSplitQty(id: TSchedID; SplitType: integer;
                      QtyType: integer;
                      SplitQty: currency;
                      SplitNo: integer; QtyPerJob: currency;
                      out OrigJobQty: currency; out EachJobQty: currency;
                      out NewJobNr: integer;
                      out Err: string): boolean;
var
  JobQty, ProgQty, KeepQty: currency;
  SplitTot: currency;
  value: variant;
  dataType: CBinColValType;
  AvailQty: currency;
  Apa : TMqmActArea;
  Mult : integer;
begin
  p_sc.GetFldValue(Id, CSC_ProgQty, value, dataType);
  ProgQty := value;
  p_sc.GetFldValue(Id, CSC_QtyToSched, value, dataType);
  JobQty := value;

  KeepQty := SplitQty;
  AvailQty := (JobQty - ProgQty);

  case QtyType of
    0: ;//split - do nothing
    1: SplitQty := AvailQty - KeepQty; //keep aside the quantity
  end;//case

  case SplitType of
    0:  begin
          if SplitNo <= 0 then
          begin
            Err := _('Please input a number of jobs');
            Result := false;
            exit
          end
        end;
    1:  begin
          if QtyPerJob <= 0 then
          begin
            Err := _('Please input a quantity per job');
            Result := false;
            exit
          end
        end;
    2:  begin
          if SplitNo <= 0 then
          begin
            Err := _('Please input a number of jobs');
            Result := false;
            exit
          end;

          if QtyPerJob <= 0 then
          begin
            Err := _('Please input a quantity per job');
            Result := false;
            exit
          end
        end;
  end;
{
  if SplitQty >= QtyNotToSplit then
  begin
    SplitQty := SplitQty - QtyNotToSplit;
    Result := true
  end
  else
  begin
    Err := _('No quantity left for the split');
    Result := false;
    exit
  end;
 }

  if SplitQty <= AvailQty then
    Result := true
  else
  begin
    Err := _('The split quantity is greater than the remaining quantity');
    Result := false;
    exit
  end;

  OrigJobQty := JobQty - SplitQty;
  NewJobNr := SplitNo;
  EachJobQty := QtyPerJob;

  if (QtyPerJob > 0) and (SplitNo <= 0) then
    NewJobNr := trunc(SplitQty/QtyPerJob)
  else
    if (SplitQty > 0)
    and (SplitNo > 0) and (QtyPerJob <= 0) then
    begin
      EachJobQty := SplitQty/SplitNo;

      if (iniAppGlobals.SplitFromPointNumOfDec = '0') then
        Mult := 1
      else if (iniAppGlobals.SplitFromPointNumOfDec = '1') then
        Mult := 10
      else
        Mult := 100;

      EachJobQty := trunc(EachJobQty*Mult)/Mult;
     // EachJobQty := trunc(EachJobQty*100)/100;
    end;

 // if CalcWithNoDecimals then
 //   EachJobQty := trunc(EachJobQty);

  SplitTot  := EachJobQty * NewJobNr;
//  OrigJobQty := JobQty - SplitTot;

// if OrigJobQty <> JobQty then
//    OrigJobQty := OrigJobQty - SplitTot             //JobQty - SplitTot;
//  else
    OrigJobQty := JobQty - SplitTot;
  OrigJobQty := trunc(OrigJobQty*100)/100;

  if SplitType = 0 then
  begin
    if ((SplitQty < JobQty) and (OrigJobQty <= 0))
    or ((OrigJobQty < EachJobQty) and (SplitQty = JobQty))  then
//    if OrigJobQty <= 0 then bug when splitting a job into 3 parts
    begin
      OrigJobQty := EachJobQty + OrigJobQty;
      dec(NewJobNr)
    end
  end else
  begin
    if OrigJobQty = 0 then
    begin
      OrigJobQty := EachJobQty;
      dec(NewJobNr)
    end
  end;

  Apa := p_sc.GetExtLinkPtr(id);
  if Assigned(Apa) then
  begin
    if OrigJobQty < TMqmRes(Apa.p_Res).p_Min_bch_size then
    begin
      Err := _('The current job quantity must be greater than the resource minium batch size');
      Result := false;
      exit;
    end;
  end;

  if JobQty < SplitTot then
  begin
    Err := _('The split quantity is greater than the remaining quantity');
    Result := false;
    exit;
  end;

  if SplitTot <= 0 then
  begin
    Err := _('The split quantity must be greater than zero');
    Result := false;
    exit;
  end;

end;

//----------------------------------------------------------------------------//

function CalcSplitQtyGrp(id: TSchedID; SplitType: integer;
                      SplitQty: currency; SplitNo: integer; QtyPerJob: currency;
                      out OrigJobQty: currency; out EachJobQty: currency;
                      out NewJobNr: integer; out Err: string): boolean;
var
  JobQty, ProgQty, KeepQty: currency;
  SplitTot: currency;
  value: variant;
  dataType: CBinColValType;
  AvailQty: currency;
  Apa : TMqmActArea;
  Mult : integer;
begin
  Result := false;
  Err := '';

  p_sc.GetFldValue(Id, CSC_ProgQty, value, dataType);
  ProgQty := value;
  p_sc.GetFldValue(Id, CSC_QtyToSched, value, dataType);
  JobQty := value;

  AvailQty := (JobQty - ProgQty);

  case SplitType of
  0:begin
      if SplitQty <= 0 then
      begin
        Err := _('Please input a quantity to split');
        exit;
      end;
      if SplitNo <= 0 then
      begin
        Err := _('Please input a number of jobs');
        exit;
      end;
      Mult := 100;
      if (iniAppGlobals.SplitFromPointNumOfDec = '0') then Mult := 1;
      if (iniAppGlobals.SplitFromPointNumOfDec = '1') then Mult := 10;
      if SplitQty = JobQty then
        EachJobQty := trunc(SplitQty/(SplitNo+1)*Mult)/Mult
      else
        EachJobQty := trunc(SplitQty/SplitNo*Mult)/Mult;
      NewJobNr := SplitNo;
    end;

  1:begin
      if SplitQty <= 0 then
      begin
        Err := _('Please input a quantity to split');
        exit;
      end;
      if QtyPerJob <= 0 then
      begin
        Err := _('Please input a quantity per job');
        exit;
      end;
      EachJobQty := QtyPerJob;
      NewJobNr := trunc(SplitQty/QtyPerJob);
    end;

  2:begin
      if SplitNo <= 0 then
      begin
        Err := _('Please input a number of jobs');
        exit;
      end;
      if QtyPerJob <= 0 then
      begin
        Err := _('Please input a quantity per job');
        exit;
      end;
      EachJobQty := QtyPerJob;
      if JobQty = (EachJobQty * NewJobNr) then
        NewJobNr := SplitNo - 1
      else
        NewJobNr := SplitNo;
    end;
  end;

  OrigJobQty := JobQty - (EachJobQty * NewJobNr);
  if (EachJobQty * SplitNo) <= AvailQty then
    Result := true
  else
    Err := _('The split quantity is greater than the remaining quantity');

end;


//----------------------------------------------------------------------------//

function CalcSplitQtyAlternative(id: TSchedID; SplitType: integer;
                      QtyType: integer;
                      SplitQty: currency;
                      SplitNo: integer; QtyPerJob: currency;
                      out OrigJobQty: currency; out EachJobQty: currency;
                      out NewJobNr: integer;
                      out Err: string; out OrigJobQtyAlt : currency; out EachJobQtyAlt: currency): boolean;
var
  JobQty, ProgQty, KeepQty, stepqty: currency;
  SplitTot, X: currency;
  value: variant;
  dataType: CBinColValType;
  AvailQty: currency;
  Apa : TMqmActArea;
  Mult : integer;
  SplitInfo : TSQSplitInfo;
  S, TempStrQty : string;
  TempExt : Extended;
  QtyInt : Integer;
begin
  ProgQty := 0;
  JobQty  := 0;
  p_sc.GetSplitInfo(Id, SplitInfo);

  p_sc.GetFldValue(Id, CSC_ProgQty, value, dataType);
  ProgQty := value;

  p_sc.GetFldValue(Id, CSC_IniQty , value, dataType);    //Step qty
  stepqty := value;

  if stepqty = 0 then
    ProgQty := 0
  else
    ProgQty := ProgQty * SplitInfo.AlternativeQty / stepqty;

  p_sc.GetFldValue(Id, CSC_QtyToSched, value, dataType);
  JobQty := value;

  if stepqty = 0 then
    JobQty := 0
  else
    JobQty := JobQty * SplitInfo.AlternativeQty / stepqty;

  QtyInt := trunc(JobQty * 100);
  JobQty := QtyInt/100;

  KeepQty := SplitQty;
  AvailQty := (JobQty - ProgQty);

  case QtyType of
    0: ;//split - do nothing
    1: SplitQty := AvailQty - KeepQty; //keep aside the quantity
  end;//case

  case SplitType of
    0:  begin
          if SplitNo <= 0 then
          begin
            Err := _('Please input a number of jobs');
            Result := false;
            exit
          end
        end;
    1:  begin
          if QtyPerJob <= 0 then
          begin
            Err := _('Please input a quantity per job');
            Result := false;
            exit
          end
        end;
    2:  begin
          if SplitNo <= 0 then
          begin
            Err := _('Please input a number of jobs');
            Result := false;
            exit
          end;

          if QtyPerJob <= 0 then
          begin
            Err := _('Please input a quantity per job');
            Result := false;
            exit
          end
        end;
  end;
{
  if SplitQty >= QtyNotToSplit then
  begin
    SplitQty := SplitQty - QtyNotToSplit;
    Result := true
  end
  else
  begin
    Err := _('No quantity left for the split');
    Result := false;
    exit
  end;
 }

  if SplitQty <= AvailQty then
    Result := true
  else
  begin
    Err := _('The split quantity is greater than the remaining quantity');
    Result := false;
    exit
  end;

  OrigJobQty := JobQty - SplitQty;
  NewJobNr := SplitNo;
  EachJobQty := QtyPerJob;
  Mult := 100;

  if (QtyPerJob > 0) and (SplitNo <= 0) then
    NewJobNr := trunc(SplitQty/QtyPerJob)
  else
    if (SplitQty > 0)
    and (SplitNo > 0) and (QtyPerJob <= 0) then
    begin
      EachJobQty := SplitQty/SplitNo;

      if (iniAppGlobals.SplitFromPointNumOfDec = '0') then
        Mult := 1
      else if (iniAppGlobals.SplitFromPointNumOfDec = '1') then
        Mult := 10
      else
        Mult := 100;

      EachJobQty := trunc(EachJobQty*Mult)/Mult;
     // EachJobQty := trunc(EachJobQty*100)/100;
    end;

 // if CalcWithNoDecimals then
 //   EachJobQty := trunc(EachJobQty);

  SplitTot  := EachJobQty * NewJobNr;
//  OrigJobQty := JobQty - SplitTot;

// if OrigJobQty <> JobQty then
//    OrigJobQty := OrigJobQty - SplitTot             //JobQty - SplitTot;
//  else
    OrigJobQty := JobQty - SplitTot;
  OrigJobQty := trunc(OrigJobQty*100)/100;

  if SplitType = 0 then
  begin
    if ((SplitQty < JobQty) and (OrigJobQty <= 0))
    or ((OrigJobQty < EachJobQty) and (SplitQty = JobQty))  then
//    if OrigJobQty <= 0 then bug when splitting a job into 3 parts
    begin
      OrigJobQty := EachJobQty + OrigJobQty;
      dec(NewJobNr)
    end
  end else
  begin
    if OrigJobQty = 0 then
    begin
      OrigJobQty := EachJobQty;
      dec(NewJobNr)
    end
  end;

  OrigJobQtyAlt := OrigJobQty;
  EachJobQtyAlt := EachJobQty;

  if SplitInfo.AlternativeQty = 0 then
    EachJobQty := 0
  else
    EachJobQty := EachJobQty * stepqty / SplitInfo.AlternativeQty;

  EachJobQty := trunc(EachJobQty*Mult)/Mult;

  if (EachJobQty * SplitInfo.AlternativeQty / stepqty) < EachJobQtyAlt then
  begin
    EachJobQty := EachJobQtyAlt * stepqty / SplitInfo.AlternativeQty;
    EachJobQty := trunc(EachJobQty*Mult + 1)/Mult;
  end;

  p_sc.GetFldValue(Id, CSC_QtyToSched, value, dataType);
  JobQty := value;

  OrigJobQty := JobQty - (EachJobQty * NewJobNr);

  if (OrigJobQty = 0) or (EachJobQty = 0) then
  begin
    Err := _('Original job quantity and each job qty must be greater than 0');
    Result := false;
    exit
  end;

  Apa := p_sc.GetExtLinkPtr(id);
  if Assigned(Apa) then
  begin
    if OrigJobQty < TMqmRes(Apa.p_Res).p_Min_bch_size then
    begin
      Err := _('The current job quantity must be greater than the resource minium batch size');
      Result := false;
      exit;
    end;
  end;

  if SplitQty < SplitTot then
  begin
    Err := _('The split quantity is greater than the remaining quantity');
    Result := false;
    exit;
  end;

  if SplitTot <= 0 then
  begin
    Err := _('The split quantity must be greater than zero');
    Result := false;
    exit;
  end;

end;

//----------------------------------------------------------------------------//

function CalcSplitQtyGrpAlternative(id: TSchedID; SplitType: integer;
                      SplitQty: currency; SplitNo: integer; QtyPerJob: currency;
                      out OrigJobQty: currency; out EachJobQty: currency;
                      out NewJobNr: integer; out Err: string): boolean;
var
  JobQty, ProgQty, KeepQty, TotalAltQty, TotalAltProg, jobqtyVal, stepqty : currency;
  SplitTot: currency;
  value  : variant;
  dataType: CBinColValType;
  AvailQty: currency;
  Apa : TMqmActArea;
  Mult : integer;
  SplitInfo : TSQSplitInfo;
  I, QtyInt : Integer;
  SonId : TSchedId;
begin
  Result := false;
  Err := '';
  TotalAltQty := 0;
  TotalAltProg := 0;
  for i := 0 to p_sc.GetGrpNumSons(Id)-1 do
  begin
    SonId := p_sc.GetGrpSon(Id, i);
    p_sc.GetSplitInfo(SonId, SplitInfo);
    p_sc.GetFldValue(SonId, CSC_QtyToSched, value, dataType);
    jobqtyVal := value;
    p_sc.GetFldValue(SonId, CSC_IniQty , value, dataType);
    stepqty := value;
    TotalAltQty := TotalAltQty + jobqtyVal / StepQty * SplitInfo.AlternativeQty;
    p_sc.GetFldValue(Id, CSC_ProgQty, value, dataType);
    ProgQty := value;
    TotalAltProg := TotalAltProg + ProgQty / StepQty * SplitInfo.AlternativeQty;
  end;

  QtyInt := trunc(TotalAltQty * 100);
  TotalAltQty := QtyInt/100;

  JobQty := TotalAltQty;
  ProgQty := TotalAltProg;

  AvailQty := (JobQty - ProgQty);

  if AvailQty <= 0 then
  begin
    Err := _('Available quantity cannot be equal/less than 0');
    exit;
  end;


  case SplitType of
  0:begin
      if SplitQty <= 0 then
      begin
        Err := _('Please input a quantity to split');
        exit;
      end;
      if SplitNo <= 0 then
      begin
        Err := _('Please input a number of jobs');
        exit;
      end;
      Mult := 100;
      if (iniAppGlobals.SplitFromPointNumOfDec = '0') then Mult := 1;
      if (iniAppGlobals.SplitFromPointNumOfDec = '1') then Mult := 10;
      if SplitQty = JobQty then
        EachJobQty := trunc(SplitQty/(SplitNo+1)*Mult)/Mult
      else
        EachJobQty := trunc(SplitQty/SplitNo*Mult)/Mult;
      NewJobNr := SplitNo;
    end;

  1:begin
      if SplitQty <= 0 then
      begin
        Err := _('Please input a quantity to split');
        exit;
      end;
      if QtyPerJob <= 0 then
      begin
        Err := _('Please input a quantity per job');
        exit;
      end;
      EachJobQty := QtyPerJob;
      NewJobNr := trunc(SplitQty/QtyPerJob);
    end;

  2:begin
      if SplitNo <= 0 then
      begin
        Err := _('Please input a number of jobs');
        exit;
      end;
      if QtyPerJob <= 0 then
      begin
        Err := _('Please input a quantity per job');
        exit;
      end;
      EachJobQty := QtyPerJob;
      if JobQty = (EachJobQty * NewJobNr) then
        NewJobNr := SplitNo - 1
      else
        NewJobNr := SplitNo;
    end;
  end;


 { OrigJobQtyAlt := OrigJobQty;
  EachJobQtyAlt := EachJobQty;

  if SplitInfo.AlternativeQty = 0 then
    EachJobQty := 0
  else
    EachJobQty := EachJobQty * stepqty / TotalAltQty;

  EachJobQty := trunc(EachJobQty*Mult)/Mult;

  if (EachJobQty * SplitInfo.AlternativeQty / stepqty) < EachJobQtyAlt then
  begin
    EachJobQty := EachJobQtyAlt * stepqty / SplitInfo.AlternativeQty;
    EachJobQty := trunc(EachJobQty*Mult + 1)/Mult;
  end;  }



  OrigJobQty := JobQty - (EachJobQty * NewJobNr);
  if (EachJobQty * SplitNo) <= AvailQty then
    Result := true
  else
    Err := _('The split quantity is greater than the remaining quantity');

end;

initialization

 m_EnableGroupAutomaticInternalSortingSequence := false;

end.

