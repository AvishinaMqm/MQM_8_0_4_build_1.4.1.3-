unit UMCalcOverlaps;

interface

uses
  classes,
  UMSchedContFunc;

type

  TMCalcOverlaps = class
    constructor CreateOvlp;
    destructor  Destroy; override;

    procedure Clear;
    procedure SetMainId(id: TSchedId);

    procedure SetTargetRes(ResObj: TObject; OvlpChk : TypeOvlpChk; Setup : double);
    procedure GetMainOverlaps(var LowLimit, HighLimit: TDateTime);

  private
    m_tgtRes: TObject;
    m_id:     TSchedId;
    m_type:   CScSchedType;
    m_isGrp:  boolean;
    m_list:   TList;
    m_LowLimit: TDateTime;
    m_HighLimit: TDateTime;
  end;

  function  FindOverlapsForSetUp(SetUp : double; var LowOvlopLimit : TDateTime; var HighOvlpLimit : TDateTime): boolean;
  procedure AddOverlapsForSetUp(SetUp : double; LowOvlopLimit : TDateTime; HighOvlpLimit : TDateTime);
  procedure CleanOverlapsSetUpList;

implementation

uses
  SysUtils,
  UMRes,
  UMTblDesc,
  DMSrvPC,
  UMWkCtr,
  UMObjCont,
  UMSchedCont,
  UMSchedList,
  UGbaseCal;

type

  TRecOvpl = record
    wkcCode: string;
    wkcProc: string;
    resCat:  string;
    resCode: string;
    supTime: double;
    exeTime: double;
  end;
  PTRecOvpl = ^TRecOvpl;

  TMObjOverlaps = class
    constructor CreateObj(id: TSchedId);
    destructor  Destroy; override;

    procedure CalcLimits(resObj: TObject; OvlpChk : TypeOvlpChk; Setup : double);

  private
    m_id:         TSchedId;
    m_ObjLowLimit:  TDateTime;
    m_ObjHighLimit: TDateTime;
    m_timingInfo: TSQtimingInfo;
    m_wkc:        TMqmWrkCtr;

    m_recList:    TList;

  end;

  TOvlopLimit = record
    LowOvlopLimit : TDateTime;
    HighOvlpLimit : TDateTime;
    SetUp         : double;
  end;
  PTOvlopLimit = ^TOvlopLimit;

var
  m_OvlopLimitList : TList;

//----------------------------------------------------------------------------//

constructor TMCalcOverlaps.CreateOvlp;
begin
  inherited Create;
  m_tgtRes := nil;
  m_id     := CSchedIdNull;
  m_list   := TList.Create;
end;

//----------------------------------------------------------------------------//

destructor TMCalcOverlaps.Destroy;
begin
  Clear;
  m_list.Free;
  inherited Destroy
end;

//----------------------------------------------------------------------------//

procedure TMCalcOverlaps.Clear;
var
  i: integer;
begin
  m_tgtRes := nil;
  m_id     := CSchedIdNull;
  for i := 0 to m_list.Count-1 do
    TMObjOverlaps(m_list[i]).Free;
  m_list.Clear
end;

//----------------------------------------------------------------------------//

procedure TMCalcOverlaps.SetMainId(id: TSchedId);
var
  isGrp: boolean;
  i:     integer;
begin
//  if m_id = id then exit;
  p_sc.GetObjInfo(id, isGrp);
  if not isGrp and (m_id = id) then exit;

  Clear;
  m_id   := id;
  m_type := p_sc.GetJobType(id);
  m_isGrp := isGrp;

//  p_sc.GetObjInfo(id, isGrp);

  if not isGrp then
    m_list.Add(TMObjOverlaps.CreateObj(m_id))
  else
    for i := 0 to p_sc.GetGrpNumSons(m_id)-1 do
      m_list.Add(TMObjOverlaps.CreateObj(p_sc.GetGrpSon(m_id, i)))
end;

//----------------------------------------------------------------------------//

procedure TMCalcOverlaps.SetTargetRes(resObj: TObject; OvlpChk : TypeOvlpChk; Setup : double);
var
  i: integer;
  ObjLimitDate : TDateTime;
begin
  if not Assigned(resObj) then
  begin
    m_LowLimit := 0;
    m_HighLimit := 0;
    m_tgtRes := nil;
    exit
  end;

//  if m_tgtRes <> resObj then
//  begin
    m_LowLimit := 0;
    m_HighLimit := 0;

    for i := 0 to m_list.Count-1 do
    begin
      TMObjOverlaps(m_list[i]).CalcLimits(resObj, OvlpChk, Setup);
      ObjLimitDate := TMObjOverlaps(m_list[i]).m_ObjLowLimit;

      if (ObjLimitDate > 0) and (m_type = CST_Continuous) and m_isGrp then
      begin
        ObjLimitDate := p_sc.GetRealOverlapForGroup(resObj, false, ObjLimitDate, m_id, i);
      end;
      if (ObjLimitDate > m_LowLimit) and (ObjLimitDate > 0) then
        m_LowLimit := ObjLimitDate;


      ObjLimitDate := TMObjOverlaps(m_list[i]).m_ObjHighLimit;
      if (ObjLimitDate > 0) and (m_type = CST_Continuous) and m_isGrp then
      begin
        ObjLimitDate := p_sc.GetRealOverlapForGroup(resObj, true, ObjLimitDate, m_id, i);
      end;

      if ((ObjLimitDate < m_HighLimit) or (m_HighLimit = 0))
      and (ObjLimitDate > 0) then
        m_HighLimit := ObjLimitDate;
    end;

{
    if m_type = CST_batch then
    begin
      m_exeMin := TMObjOverlaps(m_list[0]).m_ObjExeMin;
      m_supMin := 0;

      //Take the worst setup time
      for i := 0 to m_list.Count-1 do
        if m_supMin < TMObjOverlaps(m_list[i]).m_ObjSupMin then
          m_supMin := TMObjOverlaps(m_list[i]).m_ObjSupMin;
    end else
    begin
      //Take the setup time of the first job
      m_supMin := TMObjOverlaps(m_list[0]).m_ObjSupMin;
      m_exeMin := 0;

      //Sum the jobs duration
      for i := 0 to m_list.Count-1 do
        m_exeMin := m_exeMin + TMObjOverlaps(m_list[i]).m_ObjExeMin
    end;
}
    m_tgtRes := resObj;
 // end

end;

//----------------------------------------------------------------------------//

procedure TMCalcOverlaps.GetMainOverlaps(var LowLimit, HighLimit: TDateTime);
begin
  Assert(Assigned(m_tgtRes));
  LowLimit := m_LowLimit;
  HighLimit := m_HighLimit
end;

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

constructor TMObjOverlaps.CreateObj(id: TSchedId);
begin
  inherited Create;
  m_recList := TList.Create;
  m_id      := id;

  p_sc.GetTimingInfo(m_id, m_timingInfo);
//  m_wkc := TMqmWrkCtr(p_pl.FindWrkCtrByCode(m_timingInfo.wkctCode));
  m_wkc := TMqmWrkCtr(p_sc.GetWrkCtrPtr(m_id));

end;

//----------------------------------------------------------------------------//

destructor TMObjOverlaps.Destroy;
var
  i:    integer;
  pTmg: PTRecOvpl;
begin
  for i := 0 to m_recList.Count-1 do
  begin
    pTmg := PTRecOvpl(m_recList[i]);
    Dispose(pTmg)
  end;
  m_recList.Free;
  inherited Destroy
end;

//----------------------------------------------------------------------------//

procedure TMObjOverlaps.CalcLimits(resObj: TObject; OvlpChk : TypeOvlpChk; Setup : double);
begin
  m_ObjHighLimit := 0;
  m_ObjLowLimit  := 0;

  p_sc.CalcOvlpLimits(m_id, resObj, m_ObjLowLimit, m_ObjHighLimit, OvlpChk, Setup, -1)
end;

//----------------------------------------------------------------------------//

procedure IniOvlopLimitList;
begin
  m_OvlopLimitList := TList.Create;
end;

//----------------------------------------------------------------------------//

procedure Destroy_OvlopLimitList(FreeList : boolean);
var
  I : Integer;
begin
  for i := m_OvlopLimitList.Count-1 downto 0 do
    Dispose(PTOvlopLimit(m_OvlopLimitList[i]));
  m_OvlopLimitList.Clear;
  if FreeList then
    m_OvlopLimitList.Free;
end;

//----------------------------------------------------------------------------//

function FindOverlapsForSetUp(SetUp : double; var LowOvlopLimit : TDateTime; var HighOvlpLimit : TDateTime): boolean;
var
  I : Integer;
begin
  Result := false;
  for I := 0 to m_OvlopLimitList.Count - 1 do
  begin
    if PTOvlopLimit(m_OvlopLimitList[I]).SetUp = SetUp then
    begin
      Result := true;
      LowOvlopLimit := PTOvlopLimit(m_OvlopLimitList[I]).LowOvlopLimit;
      HighOvlpLimit := PTOvlopLimit(m_OvlopLimitList[I]).HighOvlpLimit;
      Break
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure AddOverlapsForSetUp(SetUp : double; LowOvlopLimit : TDateTime; HighOvlpLimit : TDateTime);
var
  OvlopLimit : PTOvlopLimit;
begin
  new(OvlopLimit);
  OvlopLimit.LowOvlopLimit := LowOvlopLimit;
  OvlopLimit.HighOvlpLimit := HighOvlpLimit;
  OvlopLimit.SetUp         := SetUp;
  m_OvlopLimitList.Add(OvlopLimit);
end;

//----------------------------------------------------------------------------//

procedure CleanOverlapsSetUpList;
begin
  Destroy_OvlopLimitList(false);
end;

//----------------------------------------------------------------------------//

initialization

  IniOvlopLimitList;

// -------------------------------------------------------------------------- //

finalization

  Destroy_OvlopLimitList(true);

// -------------------------------------------------------------------------- //


end.

