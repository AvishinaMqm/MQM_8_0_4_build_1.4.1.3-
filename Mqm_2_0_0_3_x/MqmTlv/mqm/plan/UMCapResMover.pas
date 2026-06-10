unit UMCapResMover;

interface

uses
  UMSchedCont, UMActArea, UMRes, UMWkCtr, DateUtils,
  UMOpStack, UMCapRes, gnugettext;

type
  TMqmCapResMover = class
    constructor Create;
    destructor  Destroy; override;
  private
    m_CapRes:       TMqmCapRes;
    m_ActArea:      TMqmActArea;
    m_markStackIni: TStackMark;
    m_markStackCrt: TStackMark;

    function  CalcBaseTimes(var BaseSetup, BaseDur: double): boolean;
    function  CalcDur(var Duration: double): boolean;
    function  CalcSetup(ToDate: TDateTime; var Setup: double): boolean;
    function  CanAttach(ToActArea: TMqmActArea): boolean;
  public
    function  CalcTimes(ActArea: TMqmActArea; ToDate: TDateTime; var SetupTime, DurTime: double): boolean;
    procedure SetCapResToMove(var CapRes: TMqmCapRes);
    function  ChangeTo(actArea: TMqmActArea; date: TDateTime;
                       duration: integer; isEnd: boolean): boolean;
    function  DetachFromApa: boolean;
    procedure Abort;
    property p_CapResToMove: TMqmCapRes       read m_CapRes;

  end;

implementation

uses
  dialogs,
  UMStoredProc,
  UMSchedContFunc,
  UMObjCont,
  UGBaseCal,
  UMDurObj,
  UMCompatRules;

//----------------------------------------------------------------------------//

constructor TMqmCapResMover.Create;
begin
  inherited Create;
  m_markStackIni := p_opStack.MarkStack;
  m_markStackCrt := m_markStackIni
end;

//----------------------------------------------------------------------------//

destructor TMqmCapResMover.Destroy;
begin
  inherited Destroy
end;

//----------------------------------------------------------------------------//

procedure TMqmCapResMover.SetCapResToMove(var CapRes: TMqmCapRes);
begin
  if not Assigned(CapRes) then
  begin
    CapRes := TMqmCapRes.CreateCapRes(0);
    CapRes.p_NewInMemorty := true;
    p_opStack.CreatePlanObj(CapRes);
    m_markStackCrt := p_opStack.MarkStack
  end
  else
  begin
    if CapRes.m_status <> CDUR_new then
      CapRes.m_status := CDUR_modi;
  end;
  m_CapRes := CapRes;
end;

//----------------------------------------------------------------------------//

function TMqmCapResMover.CanAttach(ToActArea: TMqmActArea): boolean;
var
  OrigWrkCtr, ToWrkCtr: TMqmWrkCtr;
  OldactArea: TMqmActArea;
begin
  Result := false;

  ToWrkCtr := TMqmWrkCtr(ToActArea.p_WrkCtr);
  OrigWrkCtr := TMqmWrkCtr(m_CapRes.p_WrkCtr);

  if m_CapRes.m_Type = Cr_CrossingDtm then
  begin
    OldactArea := TMqmActArea(m_CapRes.p_Father);
    if (OldactArea <> nil) and (ToActArea <> OldactArea) then
      Exit
  end;

  if (m_CapRes.m_Type = cr_DownTime) or (m_CapRes.m_Type = Cr_CrossingDtm) then
  begin
    Result := true;
    exit
  end;

  if (
  not Assigned(OrigWrkCtr)
  or (ToWrkCtr.p_WrkCtrCode <> OrigWrkCtr.p_WrkCtrCode)
  )
  and not ToWrkCtr.P_WkcProcList.IsIn(m_CapRes.m_WCProc) then
  begin
    showmessage(_('Not compatible workcenter'));
    exit;
  end;

  Result := true;
end;

//----------------------------------------------------------------------------//

function TMqmCapResMover.ChangeTo(actArea: TMqmActArea; date: TDateTime;
                                  duration: integer; isEnd: boolean): boolean;
label
  fail;
var
  cal:      TPGCALObj;
  TmpDate1, TmpDate2 : TDateTime;
  StartDate , EndDate : TDateTime;
  DwTime : TMqmDurObj;

begin

  Result := CanAttach(actArea);
//  ObjId := -1;
//  DeltaSetupObjToMove := 0;

  if not result then exit;

//  ReduceCross := false;
  p_opStack.UndoTo(m_markStackCrt);

  p_opStack.LinkPlanObjToApa(m_CapRes, actArea);
  cal := actArea.GetCalendar;
  Assert(Assigned(cal));

{
  if m_CapRes.m_Type = Cr_CrossingDtm then
  begin

    //Check if this is the fisrt downtime
    if actArea.CheckCroseMoveOrdr(m_CapRes) then
      exit;
    //reset the duration of the jobs
    ObjId := actArea.BackUpDurCross(m_CapRes);

    p_opStack.ChgPlanObjDurData(m_CapRes);
    m_CapRes.p_start := date;
    m_CapRes.p_dur := duration;

    if actArea.ReduceObjCrossing(m_CapRes.p_start, NewStart, m_CapRes) then
    begin
      p_opStack.ChgPlanObjDurData(m_CapRes);
      m_CapRes.p_start := NewStart;
      m_CapRes.p_dur := duration;
      ReduceCross := true;
    end;
  end;
}



    {p_opStack.ChgPlanObjDurData(m_CapRes);
    m_CapRes.p_Start := date;
    cal.OfsByWHDwTime((duration)/60, false, date, date);

    m_CapRes.p_End := date;

   // Duration := round(MinuteSpan(m_CapRes.p_Start, m_CapRes.p_End));
    m_CapRes.p_dur := duration;  }


  if not isEnd then
  begin
    cal.NormalizeDate(date, ntNormalizeForward);
    p_opStack.ChgPlanObjDurData(m_CapRes);

    m_CapRes.p_start := date;

    startDate := m_CapRes.p_start;
    EndDate   := m_CapRes.p_end;

    repeat
      DwTime := actArea.FindDwTimeCovering(startDate, enddate, CSchedIDnull);
        if assigned(DwTime) then
        begin
          if DwTime <> m_CapRes then
          begin
          StartDate := DwTime.p_end;

          Cal.OfsByWHDwTime((duration/60), true, StartDate, EndDate);

          end
          else
            break;
        end;
      until DwTime = nil;

    startDate := m_CapRes.p_start;
    m_CapRes.p_dur := duration;
    Cal.OfsByWHDwTime((m_CapRes.p_dur/60), true, startDate, EndDate);
    m_CapRes.p_End := EndDate;
   // m_CapRes.p_dur := round(MinuteSpan(m_CapRes.p_start, m_CapRes.p_End));
  end
  else
  begin
    cal.NormalizeDate(date, ntNormalizeBackward);

    TmpDate1 := -1;
    TmpDate2 := -1;
    //actArea.FindStartCover(date, TmpDate1, false, m_CapRes);
    //actArea.FindStartCover(date, TmpDate2, true, m_CapRes);
    p_opStack.ChgPlanObjDurData(m_CapRes);
    m_CapRes.p_Start := date;
    cal.OfsByWHDwTime((duration)/60, false, date, date);

    if (TmpDate1 > date) then
      date := TmpDate1;
    if (TmpDate2 > date) then
      date := TmpDate2;


    m_CapRes.p_End := date;
    m_CapRes.p_dur := duration;


  end;

//  if not ReduceCross then
//  begin
 //   p_opStack.ChgPlanObjDurData(m_CapRes);
 //   m_CapRes.p_start := date;
 //   m_CapRes.p_dur := duration;




//  end;

  if not actArea.ReorganizeDur(m_CapRes) then goto fail;
  if actArea.ReorganizeAllOcc(true) = CSM_No then goto fail;

{
  if (m_CapRes.m_Type = Cr_CrossingDtm) and (ObjId <> -1) then
    p_sc.UpdateSetUpOccMove(ObjId,DeltaSetupObjToMove, true);
}
  exit;

  fail:
    p_opStack.UndoTo(m_markStackCrt);
    Result := false

end;

//----------------------------------------------------------------------------//

function TMqmCapResMover.DetachFromApa: boolean;
begin
  Result := p_opStack.DetachPlanObjFromApa(m_CapRes)
end;

//----------------------------------------------------------------------------//

procedure TMqmCapResMover.Abort;
begin
  p_opStack.UndoTo(m_markStackIni);
end;

//----------------------------------------------------------------------------//

function TMqmCapResMover.CalcTimes(ActArea: TMqmActArea; ToDate: TDateTime; var SetupTime, DurTime: double): boolean;
begin
  m_ActArea := ActArea;
  Result := CalcBaseTimes(SetupTime, DurTime);

  Result := (Result and CalcDur(DurTime) and CalcSetup(ToDate, SetupTime));
end;

//----------------------------------------------------------------------------//

function TMqmCapResMover.CalcBaseTimes(var BaseSetup, BaseDur: double): boolean;
//var
//  InParam: TMQMSTInParms;
//  OutParam: TMQMSTOutParms;
//  TmpValue: variant;
//  WrkCtr, OrigWrkCtr: TMqmWrkCtr;
begin
  Result := false;
{
  WrkCtr := TMqmWrkCtr(m_ActArea.p_Father.p_Father.p_Father);

  if p_sc.GetFldValue(m_id, CSC_ProdReq, TmpValue) then
    InParam.REQ_NO := TmpValue
  else
    exit;

  if p_sc.GetFldValue(m_id, CSC_ProdStep, TmpValue) then
    InParam.STEP_ID := TmpValue
  else
    exit;

  if p_sc.GetFldValue(m_id, CSC_WkctCode, TmpValue) then
    InParam.WRK_CTR := TmpValue
  else
    exit;

  if p_sc.GetFldValue(m_id, CSC_WkctProc, TmpValue) then
  begin
    InParam.WC_PROC := TmpValue;

  end else
    exit;

  if Assigned(m_ActArea.p_Father.p_Father) then
    InParam.RES_CAT := TMqmRes(m_ActArea.p_Father.p_Father).p_ResCat.p_ResCatCode
  else
    exit;

  InParam.RESOURCE := TMqmRes(m_ActArea.p_Father.p_Father).p_ResCode;

  OrigWrkCtr := TMqmWrkCtr(p_pl.FindWrkCtrByCode(InParam.WRK_CTR));

  if (OrigWrkCtr <> WrkCtr)
  and not OrigWrkCtr.GetAltProcForAltWrkCtr(InParam.WC_PROC, WrkCtr.p_WrkCtrCode, InParam.WC_PROC) then
    exit
  else
    InParam.WRK_CTR := WrkCtr.p_WrkCtrCode;

  if SP_MQMST(InParam, OutParam) then
  begin
    BaseSetup := OutParam.SETUP_TIME;
    BaseDur := OutParam.EXEC_TIME;
    Result := true
  end else
    exit;
}
end;

//----------------------------------------------------------------------------//

function TMqmCapResMover.CalcDur(var Duration: double): boolean;
// var
//  StepType: string;
//  TmpValue: variant;
//  IniQty, QtyToSched: double;
begin
  Result := true;
{
  if p_sc.GetFldValue(m_ID, CSC_StepType, TmpValue) then
    StepType := TmpValue
  else
  begin
    Result := false;
    exit
  end;

  if (StepType <> 'B') then
  begin
    if p_sc.GetFldValue(m_id, CSC_IniQty, TmpValue) then
      IniQty := TmpValue
    else
    begin
      Result := false;
      exit
    end;

    if p_sc.GetFldValue(m_id, CSC_QtyToSched, TmpValue) then
      QtyToSched := TmpValue
    else
    begin
      Result := false;
      exit
    end;

    Duration := Duration * QtyToSched / IniQty
  end
}
end;

//----------------------------------------------------------------------------//

function TMqmCapResMover.CalcSetup(ToDate: TDateTime; var Setup: double): boolean;
// var
//  id: TSchedID;
//  supRec: TSetupRec;
begin
  Result := true;
{
  id := m_ActArea.GetPrecObj(ToDate);

  if TMqmRes(m_ActArea.p_Father.p_Father).GetSetupParms(m_id, id, supRec) then
  begin
    if (supRec.supAdjType = 0) then
      Setup := Setup
    else
      if (supRec.supAdjType = 1) then
        Setup := Setup + supRec.supTime
      else
        if (supRec.supAdjType = 2) then
          Setup := supRec.supTime
        else
          if (supRec.supAdjType = 3) then
            Setup := Setup * supRec.supMult
          else
            Result := false
  end else
    Result := false;
}
end;

//----------------------------------------------------------------------------//
end.
