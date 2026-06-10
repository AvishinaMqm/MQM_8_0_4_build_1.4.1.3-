unit UMWarpMover;

interface

uses
  UMSchedCont, UMActArea, UMRes, UMWkCtr, System.Classes,
  UMOpStack, UMWarp, gnugettext, UMSchedContFunc;

type

  TMqmWarpMover = class
    constructor Create;
    destructor  Destroy; override;
  private
    m_Warp:      TMqmWarp;
    m_SavedLastStart : TDateTime;
    m_SavedLastDur : integer;
    m_actArea: TMqmActArea;
    m_markStackIni: TStackMark;
    m_markStackCrt: TStackMark;

    function  CalcBaseTimes(var BaseSetup, BaseDur: double): boolean;
    function  CalcDur(var Duration: double): boolean;
    function  CalcSetup(ToDate: TDateTime; var Setup: double): boolean;
    function  CanAttach(ToActArea: TMqmActArea): boolean;
  public
    procedure UndoTo;
    procedure UndoToByMark;
    function  RecalcWarpDur : boolean;
    function  CalcTimes(ActArea: TMqmActArea; ToDate: TDateTime; var SetupTime, DurTime: double): boolean;
    procedure SetWarpToMove(var Warp: TMqmWarp; Id : TSchedId);
    function  ChangeTo(actArea: TMqmActArea; date: TDateTime;
                       duration: double; isEnd: boolean): boolean;

    procedure ChangeObjDur;
    function  DetachFromApa: boolean;
    procedure Abort;
    property p_WarpToMove: TMqmWarp       read m_Warp;

  end;

implementation

uses
  UMDurObj,
  UGbaseCal,
  UMArticles,
  UMObjCont;

{ TMqmWarpMover }

//----------------------------------------------------------------------------//

procedure TMqmWarpMover.Abort;
begin
   p_opStack.UndoTo(m_markStackIni);
end;

//----------------------------------------------------------------------------//

function TMqmWarpMover.CalcBaseTimes(var BaseSetup, BaseDur: double): boolean;
begin
  //
end;

//----------------------------------------------------------------------------//

function TMqmWarpMover.CalcDur(var Duration: double): boolean;
begin
  //
end;

//----------------------------------------------------------------------------//

function TMqmWarpMover.CalcSetup(ToDate: TDateTime; var Setup: double): boolean;
begin
  //
end;

//----------------------------------------------------------------------------//

function TMqmWarpMover.CalcTimes(ActArea: TMqmActArea; ToDate: TDateTime;
  var SetupTime, DurTime: double): boolean;
begin
  //
end;

//----------------------------------------------------------------------------//

function TMqmWarpMover.CanAttach(ToActArea: TMqmActArea): boolean;
begin
  //
end;

//----------------------------------------------------------------------------//

procedure TMqmWarpMover.UndoToByMark;
begin
  p_opStack.UndoByMark(m_markStackCrt);
end;

//----------------------------------------------------------------------------//

function TMqmWarpMover.RecalcWarpDur : boolean;
begin
//  Result := true;
//  m_Warp.p_dur := 4444;
//  p_opStack.ChgPlanObjDurData(m_Warp);
end;

//----------------------------------------------------------------------------//

procedure TMqmWarpMover.UndoTo;
begin
  p_opStack.UndoTo(m_markStackCrt);
end;

//----------------------------------------------------------------------------//

function TMqmWarpMover.ChangeTo(actArea: TMqmActArea; date: TDateTime;
  duration: double; isEnd: boolean): boolean;
var
  cal:      TPGCALObj;
  TmpDate1, TmpDate2 : TDateTime;
  StartDate , EndDate : TDateTime;
  Warp : TMqmDurObj;
begin
  Result := false;

  cal := actArea.GetCalendar;
  if not assigned(cal) then exit;

  if not isEnd then
  begin
    cal.NormalizeDate(date, ntNormalizeForward);
    startDate := date;
    Cal.OfsByWHDwTime((duration)/60, true, startDate, EndDate);
  end
  else
  begin
    cal.NormalizeDate(date, ntNormalizeBackward);
    TmpDate1 := -1;
    TmpDate2 := -1;
    cal.OfsByWHDwTime((-duration)/60, false, date, date);

    if (TmpDate1 > date) then
      date := TmpDate1;
    if (TmpDate2 > date) then
      date := TmpDate2;
    startDate := date;
    Cal.OfsByWHDwTime((duration)/60, true, startDate, EndDate);
  end;

  Result := true;

  if actArea.FindWarpPlace(m_Warp, isend, startdate, EndDate) then
  begin
    Result := false;
    Exit;
  end
  else
  begin
    UndoTo;
    p_opStack.LinkPlanObjToApa(m_Warp, actArea);
    p_opStack.ChgPlanObjDurData(m_Warp);
    m_Warp.p_start := startDate;
    m_Warp.p_end   := EndDate;
    m_Warp.p_durDouble   := duration;
  end;


end;

//----------------------------------------------------------------------------//

procedure TMqmWarpMover.ChangeObjDur;
begin
  p_opStack.ChgPlanObjDurData(m_Warp);
end;

//----------------------------------------------------------------------------//

constructor TMqmWarpMover.Create;
begin
  inherited Create;
  m_markStackIni := p_opStack.MarkStack;
  m_markStackCrt := m_markStackIni
end;

//----------------------------------------------------------------------------//

destructor TMqmWarpMover.Destroy;
begin
  inherited Destroy
end;

//----------------------------------------------------------------------------//

function TMqmWarpMover.DetachFromApa: boolean;
begin
  Result := p_opStack.DetachPlanObjFromApa(m_Warp)
end;

//----------------------------------------------------------------------------//

procedure TMqmWarpMover.SetWarpToMove(var Warp: TMqmWarp; Id : TSchedId);
var
  Qty : double;
  IsWarpLInkedToRequest : boolean;
begin
  if not Assigned(Warp) then
  begin
    Qty := p_sc.GetWarpQty(id);
    IsWarpLInkedToRequest := p_sc.IsWarpLinkedToRequest(id);

   // SpeedMinPerUm := p_sc.GetWarpSpeedInminutePerUoM(id);;
    if p_sc.GetWarp_Levl_Material(id) = MT_SecondLvl then
      Warp := TMqmWarp.CreateWarp(Id, Qty, MT_SecondLvl, IsWarpLInkedToRequest)
    else
      Warp := TMqmWarp.CreateWarp(Id, Qty, MT_BaseLvl, IsWarpLInkedToRequest);
   // Warp.p_NewInMemorty := true;
    p_opStack.CreatePlanObj(Warp);
    m_markStackCrt := p_opStack.MarkStack
  end
  else
  begin
    if Warp.m_status <> CDUR_new then
      Warp.m_status := CDUR_modi;
  end;
  m_Warp := Warp;
end;

end.
