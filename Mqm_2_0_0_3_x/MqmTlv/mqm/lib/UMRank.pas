unit UMRank;

interface

uses
  Classes,
  UMDurObj,
  UMSchedContFunc,
  UMCompat,
  UMSchedOnPlan;

type
  TAutoSchedResult = record
    m_ObjID           : TSchedID;
    m_ObjFather       : TMqmDurObj;
    m_ToResCompVal    : TCompatVal;
 //   m_ToJobCompVal    : TCompatVal;
    m_ToJobCompVal    : Integer;
    m_ToCapResCompVal : TCompatVal;
    m_ErrCode         : integer;
    m_ErrDesc         : string;
  end;
  PTAutoSchedResult = ^TAutoSchedResult;

  TPlanPos = record
    m_ObjFather  : TMqmDurObj;
    m_PrevID     : TSchedID;
    m_PrevPrevID : TSchedID;
    m_NextID     : TSchedID;
    m_StartDate  : TDateTime;
    m_EndDate    : TDateTime;
    m_Setup      : double;
    m_DeltaSetup : double;
    m_ResIndex   : integer;
    m_AddRes     : boolean;
  end;
  PTPlanPos = ^TPlanPos;

  TRanking = record
    m_Pos                      : TPlanPos;
    m_DateScore                : double;
    m_PenaltyDateScore         : double;
    m_DiscrepDateScore         : double;
    m_ToResCompScore           : double;
    m_PenaltyToResCompScore    : double;
    m_DiscrepToResCompScore    : double;
    m_ToJobCompScore           : double;
    m_PenaltyToJobCompScore    : double;
    m_DiscrepToJobCompScore    : double;
    m_ToCapResCompScore        : double;
    m_PenaltyToCapResCompScore : double;
    m_DiscrepToCapResCompScore : double;
    m_PenaltyDeltaSetupNextObj : double;
    m_DiscrepDeltaSetupNextObj : double;
    m_DeltaSetupNextObj        : double;
    m_Score                    : double;
    m_TgtGap                   : double;
    m_ToResCompVal             : TCompatVal;
    m_ToJobCompVal             : Integer;//TCompatVal;
    m_ToCapResCompVal          : TCompatVal;
    m_RemoveFromGroup          : boolean;
    m_ReduceGroupCounter       : boolean;
  end;
  PTRanking = ^TRanking;

  TRank = class
    constructor Create(id: TSchedID);
    destructor  Destroy; override;
  private
    m_Rank: TList;
    m_ObjToSched: TSchedID;
    m_ResIndex : Integer;
    procedure CalcScore(Pos: TPlanPos; Ranking: PTRanking); virtual; abstract;
    function GetBestPos: TPlanPos;
    function GetBestRankig: PTRanking;
    function GetWortsScore: double;
    function RemoveResFromGroup : boolean;
    function ReduceGroupCounter : boolean;
  public
  //--Properties declarations--
    procedure SubmitPosition(Pos: TPlanPos); virtual; abstract;
    property p_BestPos: TPlanPos  read GetBestPos;
    property p_BestRanking: PTRanking  read GetBestRankig;
    property p_WorstScore: double read GetWortsScore;
    property p_RemoveResFromGroup : boolean read RemoveResFromGroup;
    property p_ReduceGroupCounter : boolean read ReduceGroupCounter;
    property p_Rank: TList read m_Rank;
    property p_ObjToSched: TSchedID read m_ObjToSched;
    property p_ResIndex : Integer Read m_ResIndex write m_ResIndex;
  end;

  TCustomRank = class(TRank)
  public
    destructor Destroy; override;
  private
    procedure CalcScore(Pos: TPlanPos; Ranking: PTRanking); override;
//    function CalcDeltaSetupScore(Pos: TPlanPos): double;
//    function CalcDateScore(Pos: TPlanPos; out TgtGap: double): double;
//    function CalcToResCompScore(Pos: TPlanPos; out CompatVal: TCompatVal): double;
//    function CalcToJobCompScore(Pos: TPlanPos; out CompatVal: TCompatVal): double;
//    function CalcToJobCompScore(Pos: TPlanPos; out CompatValue: Integer): double;
//    function CalcToCapResCompScore(Pos: TPlanPos; out CompatVal: TCompatVal): double;
  public
    procedure SubmitPosition(Pos: TPlanPos); override;
    procedure FillReportRec(Ranking: PTRanking; Rec: PTAutoSchedResult);
  end;

function CalcDateScore_old(Id : TSchedId; StartDate : TDateTime; EndDate : TDateTime; out DaysDiscrep: double): double;
function CalcDateScore(Id : TSchedId; StartDate : TDateTime; EndDate : TDateTime): double;
function CheckIfLinkedJobIsScheduled(Id : TSchedId; IsBackword : boolean) : boolean;
function CalcToResCompScore(ResPtr : Pointer ; out CompatVal: TCompatVal): double;
function CalcToJobCompScore(FromRank : boolean; ResPtr : pointer; PrevID : TSchedId; NextID : TSchedID; out CompatValue: Integer): double;
function CalcToCapResCompScore(ActArea : Pointer; StartDate : TDateTime; EndDate : TDateTime; out CompatVal: TCompatVal): double;

implementation

uses
  Sysutils,
  UMAutoSchedCfg,
  UMSchedCont,
  UMSchedList,
  UMObjCont,
  UMRes,
  UGshiftCal,
  UMpgCal,
  UGbaseCal,
  Vcl.Forms,
  UMActArea,
  UMCapRes;

//const
//  DATE_DIVIDER = 1;
//  COMPAT_DIVIDER = 5;
//  SETUP_DIVIDER = 10;
//  ABSOLUTE_DATE_DIVIDER = 2;

//----------------------------------------------------------------------------//

function CheckIfLinkedJobIsScheduled(Id : TSchedId; IsBackword : boolean) : boolean;
var
  I : Integer;
  ProdNo : string;
  value: variant;
  dataType: CBinColValType;
  StepInfo: TSQStepInfo;
  SchedIdsList : TMSchedList;
begin
  Result := false;
  SchedIdsList := TMSchedList.Create(application);
  ProdNo := p_sc.GetFldDescr(id, CSC_ProdReq, false);
  p_sc.GetFldValue(id, CSC_ProdStep, value, dataType);
  if IsBackword then
  begin
    if p_sc.GetPrecStepToSched(ProdNo, value, StepInfo) then
    begin
      if Assigned(StepInfo.ReqDet) then
        p_sc.GetStepJobs(ProdNo, value, SchedIdsList);
    end
    else
      p_sc.GetPrevConnReqLastStepJobs(id, SchedIdsList);
  end
  else
  begin
    if p_sc.GetNextStepToSched(ProdNo, value, StepInfo) then
    begin
      if Assigned(StepInfo.ReqDet) then
        p_sc.GetStepJobs(ProdNo, value, SchedIdsList);
    end
    else
      p_sc.GetNextConnReqFirstStepJobs(id, SchedIdsList);
  end;

  I := 0;
  while (not result) and (I < SchedIdsList.GetLinkCount) do
  begin
    if Assigned(p_sc.GetExtLinkPtr(SchedIdsList.GetLink(I))) then result := true;
    I := I + 1;
  end;

  SchedIdsList.Free;
end;

//----------------------------------------------------------------------------//

function AscendingByScore(Item1, Item2: Pointer): Integer;
begin
  if PTRanking(Item1).m_Score > PTRanking(Item2).m_Score then
    Result := -1
  else
    if PTRanking(Item1).m_Score < PTRanking(Item2).m_Score then
      Result := 1
    else
//      Result := 0;
      if Abs(PTRanking(Item1).m_TgtGap) < Abs(PTRanking(Item2).m_TgtGap) then
        Result := -1
      else
        if Abs(PTRanking(Item1).m_TgtGap) > Abs(PTRanking(Item2).m_TgtGap) then
          Result := 1
        else
          Result := 0;
end;

//----------------------------------------------------------------------------//

function DescendingByScore(Item1, Item2: Pointer): Integer;
begin
  if PTRanking(Item1).m_Score < PTRanking(Item2).m_Score then
    Result := -1
  else
    if PTRanking(Item1).m_Score > PTRanking(Item2).m_Score then
      Result := 1
    else
//      Result := 0;
      if Abs(PTRanking(Item1).m_TgtGap) < Abs(PTRanking(Item2).m_TgtGap) then
        Result := -1
      else
        if Abs(PTRanking(Item1).m_TgtGap) > Abs(PTRanking(Item2).m_TgtGap) then
          Result := 1
        else
        begin
          if PTRanking(Item1).m_Pos.m_ResIndex < PTRanking(Item2).m_Pos.m_ResIndex then
            result := -1
          else if PTRanking(Item1).m_Pos.m_ResIndex > PTRanking(Item2).m_Pos.m_ResIndex then
             Result := 1
          else
            Result := 0;
        end
end;

//----------------------------------------------------------------------------//
// TRank                                                                      //
//----------------------------------------------------------------------------//

constructor TRank.Create(id: TSchedID);
begin
  inherited Create;

  m_Rank := TList.Create;
  m_ObjToSched := id;
end;

//----------------------------------------------------------------------------//

destructor TRank.Destroy;
var
  I : Integer;
begin
  for i := m_Rank.Count - 1 downto 0 do
    dispose(PTRanking(m_Rank[i]));
  m_Rank.Free;
  m_Rank := nil;
  inherited Destroy
end;

//----------------------------------------------------------------------------//

function TRank.GetBestPos: TPlanPos;
begin
  Result.m_ObjFather := nil;
  Result.m_StartDate := 0;

  if m_Rank.Count > 0 then
  begin
    Result.m_ObjFather  := PTRanking(m_Rank.Items[0]).m_Pos.m_ObjFather;
    Result.m_StartDate  := PTRanking(m_Rank.Items[0]).m_Pos.m_StartDate;
    Result.m_EndDate    := PTRanking(m_Rank.Items[0]).m_Pos.m_EndDate;
  end;
end;

//----------------------------------------------------------------------------//

function TRank.GetBestRankig: PTRanking;
begin
  Result := nil;
  if m_Rank.Count > 0 then
  begin
    Result := PTRanking(m_Rank.Items[0])
  end;
end;

//----------------------------------------------------------------------------//

function TRank.GetWortsScore: double;
begin
  Result := 0.0;

  if m_Rank.Count > 0 then
  begin
    Result := PTRanking(m_Rank.Items[m_Rank.Count-1]).m_Score;
  end;
end;

//----------------------------------------------------------------------------//

function TRank.RemoveResFromGroup : boolean;
begin
  Result := false;
  if m_Rank.Count > 0 then
    Result := PTRanking(m_Rank.Items[0]).m_RemoveFromGroup
end;

//----------------------------------------------------------------------------//

function TRank.ReduceGroupCounter : boolean;
begin
  Result := false;
  if m_Rank.Count > 0 then
    Result := PTRanking(m_Rank.Items[0]).m_ReduceGroupCounter
end;

//----------------------------------------------------------------------------//
// TCustomRank
//----------------------------------------------------------------------------//

procedure TCustomRank.SubmitPosition(Pos: TPlanPos);
var
  Ranking: PTRanking;
begin
  New(Ranking);
  CalcScore(Pos, Ranking);
  m_Rank.Add(Ranking);
//  m_Rank.Sort(AscendingByScore)
  m_Rank.Sort(DescendingByScore)
end;

//----------------------------------------------------------------------------//

procedure TCustomRank.FillReportRec(Ranking: PTRanking; Rec: PTAutoSchedResult);
begin
  Rec.m_ObjID           := m_ObjToSched;
  Rec.m_ObjFather       := Ranking.m_Pos.m_ObjFather;
  Rec.m_ToResCompVal    := Ranking.m_ToResCompVal;
  Rec.m_ToJobCompVal    := Ranking.m_ToJobCompVal;
  Rec.m_ToCapResCompVal := Ranking.m_ToCapResCompVal;
  Rec.m_ErrDesc         := '';
  Rec.m_ErrCode         := 0
end;

//----------------------------------------------------------------------------//

procedure TCustomRank.CalcScore(Pos: TPlanPos; Ranking: PTRanking);
var
  PercDateScoreWeight, PercCompScoreWeight: double;
  I : Integer;
  ScoreAddition : PTScoreAddition;
//  TempToJobCompVal : Integer;
  TempcompBackVal, TempcompForeVal, TempJobToResCompVal : TCompatVal;
  DatesInfo: TSQDatesInfo;
  TempHighestDate, TempSchedEndDate, DaysDelay : TDate;
begin
  PercDateScoreWeight := AutoSchedCfg.m_DateScoreWeight / 100;
  PercCompScoreWeight := AutoSchedCfg.m_CompScoreWeight / 100;

  Ranking.m_Pos := Pos;

  if AutoSchedCfg.m_PenCompSetupMinutes > 0 then
  begin
//    Ranking.m_AbsDeltaSetupNextObj := CalcDeltaSetupScore(Pos);
    Ranking.m_DiscrepDeltaSetupNextObj := Pos.m_DeltaSetup/60;
    Ranking.m_PenaltyDeltaSetupNextObj := Ranking.m_DiscrepDeltaSetupNextObj * AutoSchedCfg.m_PenCompSetupMinutes;
    Ranking.m_DeltaSetupNextObj        := Ranking.m_PenaltyDeltaSetupNextObj * PercCompScoreWeight;
    Ranking.m_DiscrepToJobCompScore    := 0;
    Ranking.m_PenaltyToJobCompScore    := 0;
    Ranking.m_ToJobCompScore           := 0;
  end else
  begin
    Ranking.m_DiscrepToJobCompScore    := UMRank.CalcToJobCompScore(true,nil,Pos.m_PrevID, Pos.m_NextID, Ranking.m_ToJobCompVal);
    Ranking.m_PenaltyToJobCompScore    := Ranking.m_DiscrepToJobCompScore * AutoSchedCfg.m_PenCompJobToJob;
    Ranking.m_ToJobCompScore           := Ranking.m_PenaltyToJobCompScore * PercCompScoreWeight;
    Ranking.m_DiscrepDeltaSetupNextObj := 0;
    Ranking.m_PenaltyDeltaSetupNextObj := 0;
    Ranking.m_DeltaSetupNextObj        := 0;
  end;

  Ranking.m_PenaltyDateScore := UMRank.CalcDateScore_old(m_ObjToSched,pos.m_StartDate,pos.m_EndDate,Ranking.m_DiscrepDateScore);
//  Ranking.m_DiscrepDateScore := Abs(Ranking.m_TgtGap);
  Ranking.m_DateScore        := Ranking.m_PenaltyDateScore * PercDateScoreWeight;

  Ranking.m_DiscrepToResCompScore := UMRank.CalcToResCompScore(Pointer(TMqmRes(TMqmActArea(Pos.m_ObjFather).p_Res)), Ranking.m_ToResCompVal);
  Ranking.m_PenaltyToResCompScore := Ranking.m_DiscrepToResCompScore * AutoSchedCfg.m_PenCompJobToRes;
  Ranking.m_ToResCompScore        := Ranking.m_PenaltyToResCompScore * PercCompScoreWeight;

  Ranking.m_DiscrepToCapResCompScore := UMRank.CalcToCapResCompScore(pointer(TMqmActArea(Pos.m_ObjFather)), pos.m_StartDate,pos.m_EndDate, Ranking.m_ToCapResCompVal);
  Ranking.m_PenaltyToCapResCompScore := Ranking.m_DiscrepToCapResCompScore * AutoSchedCfg.m_PenCompJobToCapRes;
  Ranking.m_ToCapResCompScore        := Ranking.m_PenaltyToCapResCompScore * PercCompScoreWeight;

  Ranking.m_Score := Ranking.m_ToResCompScore + Ranking.m_ToJobCompScore +
                  Ranking.m_ToCapResCompScore + Ranking.m_DeltaSetupNextObj + Ranking.m_DateScore;

//  AutoSchedCfg.m_AutoSeq_LowestScore := Ranking.m_Score;
  AutoSchedCfg.m_AutoSeq_LowestScoreDate := Pos.m_StartDate;
  AutoSchedCfg.m_AutoSeq_LowestScoreRes := TMqmRes(TMqmActArea(Pos.m_ObjFather).p_Res).p_ResCode;

  //////////////////////////////////////////////////////////////////////

  if AutoSchedCfg.m_ListOfScoreAdditional.Count > 0 then
  begin
    for I := 0 to AutoSchedCfg.m_ListOfScoreAdditional.Count - 1 do
    begin
      ScoreAddition := PTScoreAddition(AutoSchedCfg.m_ListOfScoreAdditional[I]);

    //  if (ScoreAddition.Resource_is_in_Group = '1') and (TMqmRes(TMqmActArea(Pos.m_ObjFather).p_Res).m_GroupCode = '') then
    //     continue;

    //  if (ScoreAddition.Resource_is_in_Group = '0') and (TMqmRes(TMqmActArea(Pos.m_ObjFather).p_Res).m_GroupCode <> '') then
    //     continue;

      if Pos.m_PrevID <> CSchedIDnull then
      begin
        p_sc.GetCompatWithOcc(Pos.m_PrevID, TempcompForeVal, TempcompBackVal);
        if ScoreAddition.From_Job_to_Prior_Job_case > TempcompForeVal then
          continue;
        if (ScoreAddition.To_Job_to_Prior_Job_case >= 0) and
          (ScoreAddition.To_Job_to_Prior_Job_case < TempcompForeVal) then
          continue;

        // new part
        if ScoreAddition.Double_Direction then
        begin
          if ScoreAddition.From_Job_to_Follow_Job_case > TempcompForeVal then
            continue;
          if (ScoreAddition.To_Job_to_Follow_Job_case >= 0) and
            (ScoreAddition.To_Job_to_Follow_Job_case < TempcompForeVal) then
            continue;
        end;

      end;

      if (pos.m_NextID <> CSchedIDnull) then
      begin
        p_sc.GetCompatWithOcc(pos.m_NextID, TempcompForeVal, TempcompBackVal);

        if ScoreAddition.From_Job_to_Follow_Job_case > TempcompBackVal then
           continue;
        if (ScoreAddition.To_Job_to_Follow_Job_case >= 0) and
          (ScoreAddition.To_Job_to_Follow_Job_case < TempcompBackVal) then
           continue;

        // new part

        if ScoreAddition.Double_Direction then
        begin
          if ScoreAddition.From_Job_to_Prior_Job_case > TempcompBackVal then
             continue;
          if (ScoreAddition.To_Job_to_Prior_Job_case >= 0) and
            (ScoreAddition.To_Job_to_Prior_Job_case < TempcompBackVal) then
             continue;
        end;

      end;

      UMRank.CalcToResCompScore(Pointer(TMqmRes(TMqmActArea(Pos.m_ObjFather).p_Res)), TempJobToResCompVal);
      if ScoreAddition.From_Job_to_resource_case > TempJobToResCompVal then
         continue;

      if (ScoreAddition.To_Job_to_resource_case >= 0) and
         (ScoreAddition.To_Job_to_resource_case < TempJobToResCompVal) then
         continue;

      if (ScoreAddition.From_number_of_days_delay >= 0) or (ScoreAddition.To_number_of_days_delay >= 0) then
      begin
        p_sc.GetDatesInfo(m_ObjToSched, DatesInfo);
        TempHighestDate := trunc(DatesInfo.HighEndDate);
        TempSchedEndDate := trunc(pos.m_EndDate);
        if (TempSchedEndDate >= TempHighestDate) then
        begin
          DaysDelay := TempSchedEndDate - TempHighestDate;
          if DaysDelay < ScoreAddition.From_number_of_days_delay then
             continue;
          if (ScoreAddition.To_number_of_days_delay >= 0) and
             (ScoreAddition.To_number_of_days_delay < DaysDelay) then
            continue;
        end;
      end;

      if ScoreAddition.From_number_minutes_setup_add > Pos.m_DeltaSetup then
           continue;
      if (ScoreAddition.To_number_minutes_setup_add >= 0) and
         (ScoreAddition.To_number_minutes_setup_add < Pos.m_DeltaSetup) then
           continue;

      if ScoreAddition.Add_to_score > 0 then
        Ranking.m_Score := Ranking.m_Score + ScoreAddition.Add_to_score;

      break;

    end;

  end;

  AutoSchedCfg.m_AutoSeq_LowestScore := Ranking.m_Score;

end;

//----------------------------------------------------------------------------//
{
function TCustomRank.CalcDeltaSetupScore(Pos: TPlanPos): double;
var
  planInfo : TSQplanInfo;
begin
  p_sc.GetPlanInfo(m_ObjToSched, planInfo);
  Result := (Pos.m_Setup - planInfo.supMinBase) + Pos.m_DeltaSetup;

//  if Pos.m_DeltaSetup <= 0 then
//    Result := 0
//  else

// fp - OLD AUTOSCHED CONFIGURATION
//    Result := Pos.m_DeltaSetup/SETUP_DIVIDER;
//    Result := Pos.m_DeltaSetup;
end;
}
//----------------------------------------------------------------------------//

{function TCustomRank.CalcDateScore(Pos: TPlanPos; out TgtGap: double): double;
var
  DatesInfo: TSQDatesInfo;
  TollBfrLowDt,
  TollAftHighDt : TDateTime;
begin
  p_sc.GetDatesInfo(m_ObjToSched, DatesInfo);

  Result := 0.0;
  TgtGap := 0;

  case AutoSchedCfg.m_PrefTgtDate of
    0: begin
         if (Pos.m_StartDate < DatesInfo.LowStrDate) then
           TgtGap := Pos.m_StartDate - DatesInfo.LowStrDate
 // Eran 17.10.06 start
         else
           if (Pos.m_EndDate > DatesInfo.HighEndDate) then
             TgtGap := DatesInfo.HighEndDate - Pos.m_EndDate
// Eran 17.10.06  end
       end;
    1: begin
         if (Pos.m_EndDate > DatesInfo.HighEndDate) then
           TgtGap := DatesInfo.HighEndDate - Pos.m_EndDate
// Eran 17.10.06 start
         else
           if (Pos.m_StartDate < DatesInfo.LowStrDate) then
             TgtGap := Pos.m_StartDate - DatesInfo.LowStrDate
// Eran 17.10.06 end
       end;
    2: begin
         if (Pos.m_StartDate < AutoSchedCfg.m_NowDateTime) then
           TgtGap := Pos.m_StartDate - AutoSchedCfg.m_NowDateTime
         else
           if (Pos.m_EndDate > DatesInfo.HighEndDate) then
             TgtGap := DatesInfo.HighEndDate - Pos.m_EndDate
       end;
  end;

//  if TgtGap = 0 then exit;

//  if TgtGap = 0 then exit;   Eran 19.10.06

// Eran 19.10.06 start
  if TgtGap = 0 then
  begin
    case AutoSchedCfg.m_PrefTgtDate of
      0: TgtGap := Pos.m_StartDate - DatesInfo.LowStrDate;
      1: TgtGap := DatesInfo.HighEndDate - Pos.m_EndDate;
      2: TgtGap := Pos.m_StartDate - AutoSchedCfg.m_NowDateTime;
    end;
    exit;
  end;
// Eran 19.10.06 end

  TollBfrLowDt  := DatesInfo.LowStrDate - BeforeLowTolerance(AutoSchedCfg);
  TollAftHighDt := DatesInfo.HighEndDate + AfterHighTolerance(AutoSchedCfg);

  // Test Start Date
  if (Pos.m_StartDate < TollBfrLowDt) and (AutoSchedCfg.m_PrefTgtDate <> 2) then
    Result := Result + ((TollBfrLowDt - Pos.m_StartDate)* AutoSchedCfg.m_BeforeEarlDateTol);

  if (Pos.m_StartDate < DatesInfo.LowStrDate) and (AutoSchedCfg.m_PrefTgtDate <> 2) then
    if (Pos.m_StartDate < TollBfrLowDt) then
      Result := Result + ((DatesInfo.LowStrDate - TollBfrLowDt)* AutoSchedCfg.m_WithinEarlDateTol)
    else
      Result := Result + ((DatesInfo.LowStrDate - Pos.m_StartDate)* AutoSchedCfg.m_WithinEarlDateTol);

  // Test End Date
  if (Pos.m_EndDate > DatesInfo.HighEndDate) then
    if (Pos.m_EndDate > TollAftHighDt) then
      Result := Result + ((TollAftHighDt - DatesInfo.HighEndDate)* AutoSchedCfg.m_WithinLatestDateTol)
    else
      Result := Result + ((Pos.m_EndDate - DatesInfo.HighEndDate)* AutoSchedCfg.m_WithinLatestDateTol);

  if (Pos.m_EndDate > TollAftHighDt) then
    Result := Result + ((Pos.m_EndDate - TollAftHighDt)* (AutoSchedCfg.m_AfterLatestDateTol));

//  Result := Trunc(Result * 24 * 60);
end;
}
//----------------------------------------------------------------------------//
{
function TCustomRank.CalcToResCompScore(Pos: TPlanPos; out CompatVal: TCompatVal): double;
var
  Res: TMqmRes;
begin
  Res := TMqmRes(TMqmActArea(Pos.m_ObjFather).p_Res);
  CompatVal := Res.p_occCompatVal-1;

// OLD AUTOSCHED CONFIGURATION
//  Result := CompatVal/COMPAT_DIVIDER
  if CompatVal > 0 then
    Result := CompatVal
  else
    Result := 0
end;

//----------------------------------------------------------------------------//

//function TCustomRank.CalcToJobCompScore(Pos: TPlanPos; out CompatVal: TCompatVal): double;
// since the result of compat Val can be more than 100 this had a bug and so changed to this :
function TCustomRank.CalcToJobCompScore(Pos: TPlanPos; out CompatValue: Integer): double;
var
  compBack, TmpCompatVal: TCompatVal;
 // CompatValue: Integer;
  CompatVal: TCompatVal;
begin
  compBack := CompValNotValid;
  TmpCompatVal := CompValNotValid;
  CompatVal := 0;
  CompatValue := 0;

  if Pos.m_PrevID <> CSchedIDnull then
  begin
    p_sc.GetCompatWithOcc(Pos.m_PrevID, CompatVal, compBack);
    if CompatVal > 0 then
      //CompatVal := CompatVal - 1;
      CompatValue := CompatVal - 1;
  end;

  if Pos.m_NextID <> CSchedIDnull then
  begin
    p_sc.GetCompatWithOcc(Pos.m_NextID, TmpCompatVal, compBack);
    if compBack <> CompValNotValid then
    begin
      if compBack > 0 then
        compBack := compBack - 1;
  //   CompatVal := CompatVal + compBack;  // can be more than 100 so we have here a bug.
      CompatValue := CompatValue + compBack;
     end
  end;

  if (Pos.m_NextID <> CSchedIDnull) and (Pos.m_PrevID <> CSchedIDnull) then
  begin
    p_sc.GetCompatWithOccTwoIds(pos.m_PrevID, pos.m_NextID, CompatVal, compBack);
    compBack := compBack - 1;
    CompatValue := CompatValue - compBack;
  end;

{
  if Pos.m_PrevID = CSchedIDnull then
    CompatVal := 1
  else
    p_sc.GetCompatWithOcc(Pos.m_PrevID, CompatVal, compBack);
}
// OLD AUTOSCHED CONFIGURATION
//  Result := CompatVal/COMPAT_DIVIDER

//  if CompatVal > 0 then
//    Result := CompatVal
//   if CompatValue > 0 then
//    Result := CompatValue
//  else
//    Result := 0
//end;  }

//----------------------------------------------------------------------------//

{function TCustomRank.CalcToCapResCompScore(Pos: TPlanPos; out CompatVal: TCompatVal): double;
var
  CapResList: TDurList;
  i: integer;
  CapRes: TMqmCapRes;
begin
  CapResList := TDurList.Create(self);
  TMqmActArea(Pos.m_ObjFather).GetCapResInSpot(Pos.m_StartDate, Pos.m_EndDate, CapResList);

  CompatVal := 0;

  for i := 0 to CapResList.Count -1 do
  begin
    CapRes := TMqmCapRes(CapResList[i]);
    if CompatVal < CapRes.m_compatVal then
      CompatVal := CapRes.m_compatVal
  end;

  CapResList.Free;

// OLD AUTOSCHED CONFIGURATION
//  Result := CompatVal/COMPAT_DIVIDER;
  if CompatVal > 0 then
    Result := CompatVal -1
  else
    Result := 0
end; }

//----------------------------------------------------------------------------//

function CalcDateScore_old(Id : TSchedId; StartDate : TDateTime; EndDate : TDateTime; out DaysDiscrep: double): double;
var
  LowTolleranceDate, HighTolleranceDate, HighEndDate, LowStartDate : TDateTime;
  LowDaysInsideToll, LowDaysOutsideToll, HighDaysInsideToll, HighDaysOutsideToll : double;
  CalendarUse : boolean;
  Cal : TPGCALshift;
begin
  CalendarUse := false;
  cal := nil;

  HighEndDate := p_sc.GetHighEnd(id);
  if (AutoSchedCfg.m_PrefTgtDate <> 2) then LowStartDate := p_sc.GetLowStart(id);

  if AutoSchedCfg.m_CalendarForDatesPenalty <> '' then
  begin
    Cal := TPGCALshift(ObjPGCAL_ByKey(AutoSchedCfg.m_CalendarForDatesPenalty, TPGCALObjMqm));
    if Assigned(cal) then CalendarUse := true;
  end;

  LowDaysInsideToll := 0;
  LowDaysOutsideToll := 0;
  if (AutoSchedCfg.m_PrefTgtDate <> 2) and (StartDate < LowStartDate)
  and ((AutoSchedCfg.m_WithinEarlDateTol > 0) or (AutoSchedCfg.m_BeforeEarlDateTol > 0)) then
  begin
    LowTolleranceDate := LowStartDate;
    if (BeforeLowTolerance(AutoSchedCfg) > 0) then
    begin
      if CalendarUse then
        cal.OfsByWH(-(BeforeLowTolerance(AutoSchedCfg))*24, false, LowStartDate, LowTolleranceDate, nil)
      else
        LowTolleranceDate  := LowStartDate - BeforeLowTolerance(AutoSchedCfg);
    end;

    if (StartDate < LowTolleranceDate) then
    begin
      LowDaysInsideToll := BeforeLowTolerance(AutoSchedCfg);
      if CalendarUse then
        LowDaysOutsideToll := cal.DiffWH(LowTolleranceDate , StartDate , nil) / 24
      else
        LowDaysOutsideToll:= LowTolleranceDate - StartDate;
    end
    else
    begin
      if CalendarUse then
        LowDaysInsideToll := cal.DiffWH(LowStartDate , StartDate , nil) / 24
      else
        LowDaysInsideToll:= LowStartDate - StartDate;
    end;
  end;

  HighDaysInsideToll := 0;
  HighDaysOutsideToll := 0;
  if (EndDate > HighEndDate)
  and ((AutoSchedCfg.m_WithinLatestDateTol > 0) or (AutoSchedCfg.m_AfterLatestDateTol > 0)) then
  begin
    HighTolleranceDate := HighEndDate;
    if (AfterHighTolerance(AutoSchedCfg) > 0) then
    begin
      if CalendarUse then
        cal.OfsByWH((AfterHighTolerance(AutoSchedCfg))*24, true, HighEndDate, HighTolleranceDate, nil)
      else
        HighTolleranceDate  := HighEndDate + AfterHighTolerance(AutoSchedCfg);
    end;

    if (EndDate > HighTolleranceDate) then
    begin
      HighDaysInsideToll := AfterHighTolerance(AutoSchedCfg);
      if CalendarUse then
        HighDaysOutsideToll := cal.DiffWH(EndDate, HighTolleranceDate , nil) / 24
      else
        HighDaysOutsideToll:= EndDate - HighTolleranceDate;
    end
    else
    begin
      if CalendarUse then
        HighDaysInsideToll := cal.DiffWH(EndDate, HighEndDate , nil) / 24
      else
        HighDaysInsideToll:= EndDate - HighEndDate;
    end;
  end;

  DaysDiscrep := LowDaysInsideToll + LowDaysOutsideToll + HighDaysInsideToll + HighDaysOutSideToll;
  Result := (LowDaysInsideToll * AutoSchedCfg.m_WithinEarlDateTol) +
            (LowDaysOutsideToll * AutoSchedCfg.m_BeforeEarlDateTol) +
            (HighDaysInsideToll * AutoSchedCfg.m_WithinLatestDateTol) +
            (HighDaysOutSideToll * AutoSchedCfg.m_AfterLatestDateTol);
end;

//----------------------------------------------------------------------------//

function CalcDateScore(Id : TSchedId; StartDate : TDateTime; EndDate : TDateTime): double;
var
  ReferenceDate, ReferenceDateWithTollerance, DaysInsideToll, DaysOutsideToll : TDateTime;
  DateTmp : variant;
  CalendarUse : boolean;
  Cal : TPGCALshift;
//  IsBackwords : boolean;
  dataType: CBinColValType;
begin
  CalendarUse := false;
  cal := nil;
  if AutoSchedCfg.m_CalendarForDatesPenalty <> '' then
  begin
    Cal := TPGCALshift(ObjPGCAL_ByKey(AutoSchedCfg.m_CalendarForDatesPenalty, TPGCALObjMqm));
    if Assigned(cal) then CalendarUse := true;
  end;

  //*************************************
  // Calculate before target date days
  //*************************************

  DaysInsideToll := 0;
  DaysOutsideToll := 0;
  ReferenceDate := 0;

  if  (AutoSchedCfg.m_PrefTgtDate <> 2) // not today
  and ((AutoSchedCfg.m_WithinEarlDateTol > 0) or (AutoSchedCfg.m_BeforeEarlDateTol > 0)) then
  begin
    if AutoSchedCfg.m_PrevOrNextLinkedJobIsTheTgtDateWhenScheduled then
    begin
      if p_sc.GetFldValue(Id, CSC_PrvHighestDate, DateTmp, dataType) then
        ReferenceDate := DateTmp;
    end;
    case AutoSchedCfg.m_PrefTgtDate of
      0: begin
           if ReferenceDate = 0 then
              ReferenceDate := p_sc.GetLowStart(id);
         end;
      1: begin
           if ReferenceDate = 0 then
              ReferenceDate := p_sc.GetApprovalDate(id);
           if ReferenceDate = 0 then
              ReferenceDate := p_sc.GetLowStart(id);
         end;
      3: begin
           if ReferenceDate = 0 then
              ReferenceDate := p_sc.GetApprovalDate(id);
         end;
    end;
  end;

//  if (ReferenceDate > 0) and IsBackwords and AutoSchedCfg.m_PrevOrNextLinkedJobIsTheTgtDateWhenScheduled
//  and CheckIfLinkedJobIsScheduled(Id, IsBackwords) then
//    ReferenceDate := 0;

  if (ReferenceDate > 0) and (StartDate < ReferenceDate) then
  begin
    ReferenceDateWithTollerance := ReferenceDate;
    if (BeforeLowTolerance(AutoSchedCfg) > 0) then
    begin
      if CalendarUse then
        cal.OfsByWH(-(BeforeLowTolerance(AutoSchedCfg))*24, false, ReferenceDate, ReferenceDateWithTollerance, nil)
      else
        ReferenceDateWithTollerance  := ReferenceDate - BeforeLowTolerance(AutoSchedCfg);
    end;
    if (StartDate < ReferenceDateWithTollerance) then
    begin
      DaysInsideToll := BeforeLowTolerance(AutoSchedCfg);
      if CalendarUse then
        DaysOutsideToll := cal.DiffWH(ReferenceDateWithTollerance , StartDate , nil) / 24
      else
        DaysOutsideToll:= ReferenceDateWithTollerance - StartDate;
    end
    else
    begin
      if CalendarUse then
        DaysInsideToll := cal.DiffWH(ReferenceDate , StartDate , nil) / 24
      else
        DaysInsideToll:= ReferenceDate - StartDate;
    end;
  end;

  Result := (DaysInsideToll * AutoSchedCfg.m_WithinEarlDateTol) +
            (DaysOutsideToll * AutoSchedCfg.m_BeforeEarlDateTol);

  //*************************************
  // Calculate after highest end days
  //*************************************
  DaysInsideToll := 0;
  DaysOutsideToll := 0;

  ReferenceDate := 0;
  if (AutoSchedCfg.m_WithinLatestDateTol > 0) or (AutoSchedCfg.m_AfterLatestDateTol > 0) then
  begin
    if AutoSchedCfg.m_PrevOrNextLinkedJobIsTheTgtDateWhenScheduled then
    begin
      if p_sc.GetFldValue(Id, CSC_NxtLowestDate, DateTmp, dataType) then
        ReferenceDate := DateTmp;
    end;
    if ReferenceDate = 0 then
      ReferenceDate := p_sc.GetHighEnd(id);
  end;

//  if (ReferenceDate > 0) and not IsBackwords and AutoSchedCfg.m_PrevOrNextLinkedJobIsTheTgtDateWhenScheduled
//  and CheckIfLinkedJobIsScheduled(Id, IsBackwords) then
//    ReferenceDate := 0;

  if (ReferenceDate > 0) and (EndDate > ReferenceDate) then
  begin
    ReferenceDateWithTollerance := ReferenceDate;
    if (AfterHighTolerance(AutoSchedCfg) > 0) then
    begin
      if CalendarUse then
        cal.OfsByWH((AfterHighTolerance(AutoSchedCfg))*24, true, ReferenceDate, ReferenceDateWithTollerance, nil)
      else
        ReferenceDateWithTollerance  := ReferenceDate + AfterHighTolerance(AutoSchedCfg);
    end;

    if (EndDate > ReferenceDateWithTollerance) then
    begin
      DaysInsideToll := AfterHighTolerance(AutoSchedCfg);
      if CalendarUse then
        DaysOutsideToll := cal.DiffWH(EndDate, ReferenceDateWithTollerance , nil) / 24
      else
        DaysOutsideToll:= EndDate - ReferenceDateWithTollerance;
    end
    else
    begin
      if CalendarUse then
        DaysInsideToll := cal.DiffWH(EndDate, ReferenceDate , nil) / 24
      else
        DaysInsideToll:= EndDate - ReferenceDate;
    end;
  end;

  Result := Result +
            (DaysInsideToll * AutoSchedCfg.m_WithinLatestDateTol) +
            (DaysOutSideToll * AutoSchedCfg.m_AfterLatestDateTol);
end;

//----------------------------------------------------------------------------//

function CalcToResCompScore(ResPtr : Pointer ; out CompatVal: TCompatVal): double;
var
  Res: TMqmRes;
begin
  Res := TMqmRes(ResPtr);
  CompatVal := Res.p_occCompatVal-1;
  if CompatVal > 0 then
    Result := CompatVal
  else
    Result := 0
end;

//----------------------------------------------------------------------------//

function CalcToJobCompScore(FromRank : boolean; ResPtr : pointer; PrevID : TSchedId; NextID : TSchedID; out CompatValue: Integer): double;
var
  compBack, TmpCompatVal: TCompatVal;
  CompatVal: TCompatVal;
begin
  compBack := CompValNotValid;
  TmpCompatVal := CompValNotValid;
  CompatVal := 0;
  CompatValue := 0;

  if PrevID <> CSchedIDnull then
  begin
    p_sc.GetCompatWithOcc(PrevID, CompatVal, compBack);
    if CompatVal > 0 then
      CompatValue := CompatVal - 1;
  end;

  if NextID <> CSchedIDnull then
  begin
    p_sc.GetCompatWithOcc(NextID, TmpCompatVal, compBack);
    if compBack <> CompValNotValid then
    begin
      if compBack > 0 then
        compBack := compBack - 1;
      CompatValue := CompatValue + compBack;
     end
  end;

  if (NextID <> CSchedIDnull) and (PrevID <> CSchedIDnull) then
  begin
    p_sc.GetCompatWithOccTwoIds(FromRank, ResPtr, PrevID, NextID, CompatVal, compBack);
    compBack := compBack - 1;
    CompatValue := CompatValue - compBack;
  end;

   if CompatValue > 0 then
    Result := CompatValue
  else
    Result := 0
end;

//---------------------------------------------------------------------------//

function CalcToCapResCompScore(ActArea : Pointer; StartDate : TDateTime; EndDate : TDateTime; out CompatVal: TCompatVal): double;
var
  CapResList: TDurList;
  i: integer;
  CapRes: TMqmCapRes;
begin
  CapResList := TDurList.Create(TObject(ActArea));

  TMqmActArea(ActArea).GetCapResInSpot(StartDate, EndDate, CapResList);

  CompatVal := 0;

  for i := 0 to CapResList.Count -1 do
  begin
    CapRes := TMqmCapRes(CapResList[i]);
    if CompatVal < CapRes.m_compatVal then
      CompatVal := CapRes.m_compatVal
  end;

  CapResList.Free;

  if CompatVal > 0 then
    Result := CompatVal -1
  else
    Result := 0
end;

//----------------------------------------------------------------------------//

destructor TCustomRank.Destroy;
begin
  inherited destroy;
end;

end.
