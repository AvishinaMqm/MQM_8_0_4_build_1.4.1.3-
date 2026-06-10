unit UMActArea;

interface

uses
  classes,
  UMSchedList,
  UMSchedContFunc,
  UMSchedCont,
  UMDurObj,
  UMPlanObj,
  UGBaseCal,
  SysUtils,
  UMRank,
  UMBalance,
  UMArticles,
  UMRes;

type

  TMqmActArea = class(TMqmDurObj)
    constructor CreateActArea;
    destructor  Destroy; override;
  private
    m_ActArea_UserClick : boolean;
    m_WarpList:  TDurList;
    m_CapResList:  TDurList;
    m_SchedObjs: TMSchedList;
    m_Components: integer;

    // variable to handle the generator
    m_lt, m_rt: TDateTime;
    m_genObt:   integer;
    m_cnt:      integer;

    m_firstSched:  integer;
    m_firstCapRes: integer;
    m_firstWarp: integer;

    procedure SetComponents(Components: integer);
    function  CapResCount: integer;
    function  GetCapRes(i: integer): TMqmPlanObj;
    function  WarpCount: integer;
    function  GetWarp(i: integer): TMqmPlanObj;
    function  GetWrkCtr: TMqmPlanObj;
    function  GetRes: TMqmPlanObj;

   // function StartWarp: boolean;
    function StartCapRes: boolean;
    function StartWarp: boolean;
    function StartSchedObj: boolean;
    function StartCompat: boolean;
    function NextCapRes(parms: PTRowParms; var dwFnc: TDurShDraw): boolean;
    function NextWarp(parms: PTRowParms; var dwFnc: TDurShDraw): boolean;
    function NextSchedObj(parms: PTRowParms; var dwFnc: TDurShDraw ; var ToAdd : boolean): boolean;
    function NextCompat(parms: PTRowParms; var dwFnc: TDurShDraw): boolean;

    function GetObjCount: integer;
    function CheckIfSchedObjsIsAssigned : boolean;

  protected
    procedure SetStart(date: TDateTime); override;
    procedure SetEnd(date: TDateTime);   override;
    procedure SetDur(durMin: integer);   override;
//    procedure SetDurList(lst: TDurList); override;
    function  GetStart: TDateTime;       override;
    function  GetEnd: TDateTime;         override;
    function  GetDur: integer;           override;

  public
    m_CrossDownTmList: TList;

    function  GetDescr: string; override;
    function  GetCalendar: TPGCALObj;
    function  GetFirstDateInDynamic(var DateTime : TDateTime) : boolean;
    function  GetFirstJobIdInDynamic(var JobId : TSchedId) : boolean;
    function  UpdateInstanceCounterProperty(Id, PrevId : TSchedId) : boolean;
    procedure ReorganizeInstanceCounterProperty;

    procedure CleanWarpList;
    procedure AddWarp(Warp: TMqmDurObj);
    procedure RemoveWarp(Warp: TMqmDurObj);
    procedure AddCapRes(CapRes: TMqmDurObj);
    procedure AddSchedObj(id: TSchedID);
    procedure RemoveSchedObj(id: TSchedID);
    procedure RemoveCapRes(CapRes: TMqmDurObj);
    procedure RemoveAllCapResDummy;
    procedure RemoveAllCapResDynamic;
    procedure RemoveAllCapResDummyUpTime;
    procedure RemoveAllCapRes;

    property p_CapResCount: integer            read CapResCount;
    property p_CapRes[i: integer]: TMqmPlanObj read GetCapRes;
    property p_WarpCount: integer              read WarpCount;
    property p_Warp[i: integer]: TMqmPlanObj read GetWarp;

    property p_Components: integer             read m_Components write SetComponents;
    property p_WrkCtr: TMqmPlanObj             read GetWrkCtr;
    property p_Res: TMqmPlanObj                read GetRes;
    property p_ObjCount: integer               read GetObjCount;
    property p_CheckIfSchedObjsIsAssigned: boolean read CheckIfSchedObjsIsAssigned;
    property P_ActArea_UserClick : boolean     read m_ActArea_UserClick write m_ActArea_UserClick;

    procedure SortCapRes;
    procedure SortWarp;

    function  CheckDateOnSubResources(CurrentActArea : TMqmActArea; Id : TSchedId; StartDate : TdateTime; planInfo : TSQplanInfo) : TDateTime;
	function  FindAllObjCovering(DurList : TDurList; StDate, Endate : TDateTime; RefObj: TMqmDurObj; var LastIndexChecked : integer; IsWarpList : boolean) : boolean;
    function  FindDwTimeCovering(startTm, endTm: TDateTime; Id : TSchedId): TMqmDurObj;

    function  FindWarpCoveringByIndex(startTm, endTm: TDateTime; var LastIndexChecked : integer): TMqmDurObj;
    function  FindWarpCovering(Start : TDateTime ; skipObj: TMqmDurObj): TMqmDurObj;
    function  FindNonCrossingDwTime(startTm, endTm: TDateTime; var LastIndexChecked : integer; Id : TSchedId; MaxCaseAllowedCapRes : integer): TMqmDurObj;
    function  FindMaxCaseCapRes(startTm, endTm: TDateTime; Id : TSchedId) : integer;
    function  FindCrossingDwTime(startTm, endTm: TDateTime): PTRecCalDownTime;
//    function  IsCrosDwTimeCovering(startTm : TDateTime ; var NewStart : TDateTime) : boolean;

    function  FindObjCoverInSpot(date : TDateTime; Warp : TMqmDurObj) : TMqmDurObj;
    function  FindCapResCovering(startTm, endTm: TDateTime; skipObj: TMqmDurObj): integer;
    procedure GetCapResInSpot(startTm, endTm: TDateTime; var ObjList: TDurList);
    function  FindCapResInSpots(startTm : TDateTime; var StartTime : TDateTime; skipObj: TMqmDurObj; var OrigStart : TDateTime) : boolean;
    function  ReattachObjsForReorg(ObjToMove: TSchedID; LastEndDate: TDateTime;
                                   isLastObj:boolean;
                                   out DeltaSetupObjToMove: double;
                                   var OptsMover: SetOptsMover;
                                   CheckTotalComponents : boolean) : CScMovementResult;
    procedure ReorganizeWarpMain(ReorgFromDate : TDateTime; OnStart : boolean);
    function  ReorganizeWarp(ReorgFromDate : TDateTime; OnStart : boolean; warp_level : ArMaterialScheduleLvl) : boolean;
    function  ReorganizeOcc(RefObjID: TSchedID; CheckMaterial: boolean;
                            out OptsMover: SetOptsMover; out DeltaSetupObjToMove: double;
                            ErrList: TStringList; DateToOrganizeWarpFrom : TDateTime): CScMovementResult;

    function  ReorganizeOccForUnsched(RefObjID: TSchedID; CheckMaterial: boolean;
                            out OptsMover: SetOptsMover; out DeltaSetupObjToMove: double;
                            ErrList: TStringList): CScMovementResult;
    function  ReorganizeAllOcc(CheckTotalComponents : boolean) : CScMovementResult;
    function  ReorganizeAllOccForWarp(RefObjID: TSchedID; newStartDate : TdateTime) : CScMovementResult;
    procedure ReorganizeAllIgnoredProgress(OnStart : boolean);
    procedure ReorganizeAllProgress(OnStart : boolean);
    function  ChangeTo_IgnorProgress(Id: TSchedId; startTm : TDateTime) : boolean;
    procedure FillJobsIdBeforeDodayInList(List : Tlist);
    procedure RemovetoBinClosedSteps;
    function  ReorganizeDur(RefObj: TMqmDurObj): boolean;
    function  FindWarpPlace(RefObj: TMqmDurObj; IsEnd : boolean; StarDate, EndDate : TDateTime): boolean;
    function  SchedObjsCount: integer;
    function  GetSchedObj(i: integer): TSchedID;
    function  GetPrecObj(Date: TDateTime; avoid: TSchedID): TSchedID;
    function  GetPrecObjFromPlanClicked(Date: TDateTime; avoid: TSchedID): TSchedID;
    function  GetNextObj(Date: TDateTime; avoid: TSchedID): TSchedID;
    function  GetPrecObjByIndex(Obj: TSchedID): TSchedID;
    function  GetObjIndex(Obj: TSchedID): Integer;
    function  GetNextObjByIndex(Obj: TSchedID): TSchedID;
    function  FindSchedBeforeOrAfterDate(Before : boolean; Date : TDateTime) : TSchedId;
    function  FindSchedInSpot(date : TDateTime) : TSchedId;
    procedure FindSchedInSpots(startTm, endTm: TDateTime; ObjList: TMSchedList);
    function  FindCoverSchedInSpot(ActiveDate: TDateTime; var id: TSchedID): boolean;
    procedure SortSchedObjs;
    function  BuildInstPropAndCheckIfListIsSorted : boolean;
    procedure SortSchedObjsByEnd;
    procedure StartGenerator(lt, rt: TDateTime);
    function  Next(parms: PTRowParms; var dwFnc: TDurShDraw ; var ToAdd : boolean): boolean;
    procedure ClearMoveBackup;
    function  CheckPosition(RefId: TSchedID; ErrList: TStringList): CScMovementResult;
    function  CheckPositionAuto(RefId: TSchedID): CScMovementResult;
    procedure UpdateCrossDownTmList;
    procedure RefreshDwTime(CapResMaster: TMQMDurObj; isEnd: boolean;
                            RecDwTmLinked: PTDwTimeLinked);
    function GetDurationOfAllJobsBeforeThisSpot(IdStartDateTime : TDateTime; Id : TschedId) : double;
    function GetWarpFromId(Id : TSchedID) : TMqmPlanObj;
  end;

implementation

uses
  gnugettext,
  Math,
  Forms,
  Windows,
  UMOpStack,
  UMCmp,
  UMPlanGraph,
  UMCapRes,
  UMWarp,
  UMCompat,
  UMSchedObjMover,
  UMAutoschedCfg,
  FMAutoSched,
  UMPlanFunc,
  UGshapeMan,
  UMCapResMover,
  FMMainPlan,
  UMGlobal,
  FMOccMov,
  UMCompatSrv,
  UMCalcOverlaps,
  UMGenericSchedulePrevStep,
  UMWkCtr,
  FMCreateWarp,
  UMObjCont;

type

  TPos = record
    AlignOpt   : CAlignOpt;
    PlanPos    : PTPlanPos;
    BeforeObj  : boolean;
    DateBeforeChain : boolean;
    DateForSort : TDateTime;
  end;
  PTPos = ^TPos;

const

  GOBT_NONE     = 0;
  GOBT_CAPRES   = 1;
  GOBT_SCHEDOBJ = 2;
  GOBT_COMPAT   = 3;
  GOBT_WARP     = 4;


//----------------------------------------------------------------------------//
//   TMqmActArea      --------------------------------------------------------//
//----------------------------------------------------------------------------//

constructor TMqmActArea.CreateActArea;
begin
  inherited Create;
  m_SchedObjs := nil;
  m_WarpList  := nil;
  m_CapResList := nil;
end;

//----------------------------------------------------------------------------//

destructor TMqmActArea.Destroy;
var
  i: integer;
  TempRecDownTime: PTRecCalDownTime;
begin
  //m_SchedObjs.Free;
  if Assigned(m_CrossDownTmList) then
    for i := m_CrossDownTmList.Count -1 downto 0 do
    begin
      TempRecDownTime := m_CrossDownTmList[i];
      m_CrossDownTmList.Remove(TempRecDownTime);
      dispose(TempRecDownTime);
    end;
  m_CrossDownTmList.Free;

  if assigned(m_CapResList) then
  begin
    for i := m_CapResList.Count -1 downto 0 do
      TMqmDurObj(m_CapResList[I]).Free;
    m_CapResList.Free;
  end;

  if assigned(m_WarpList) then
  begin
    for i := m_WarpList.Count -1 downto 0 do
      TMqmDurObj(m_WarpList[I]).Free;
    m_WarpList.Free;
  end;

  inherited Destroy;
end;

//----------------------------------------------------------------------------//

function TMqmActArea.GetWrkCtr: TMqmPlanObj;
begin
  Result := nil;
  if Assigned(p_father)
  and Assigned(p_father.p_Father)
  and Assigned(p_father.p_Father.p_Father) then
    Result := p_father.p_Father.p_Father
end;

//----------------------------------------------------------------------------//

function TMqmActArea.GetRes: TMqmPlanObj;
begin
  Result := nil;
  if Assigned(p_father)
  and Assigned(p_father.p_Father) then
    Result := p_father.p_Father
end;

//----------------------------------------------------------------------------//

function TMqmActArea.GetDescr: string;
begin
  Result := '';
end;

//----------------------------------------------------------------------------//

function TMqmActArea.GetCalendar: TPGCALObj;
var
  visRes: TMqmVisibleRes;
begin
  visRes := TMqmVisibleRes(p_father);
  Assert(Assigned(visRes));
  Result := visRes.GetCalendar
end;

//----------------------------------------------------------------------------//

function TMqmActArea.GetFirstDateInDynamic(var DateTime : TDateTime) : boolean;
var
  I : Integer;
  ObjId: TSchedID;
  info:  TSQPlanInfo;
  FirstFound  : boolean;
begin
  Result := false;
  FirstFound := true;
  if Assigned(m_SchedObjs) then
  begin
    for i := m_SchedObjs.GetLinkCount - 1 downto 0 do
    begin
      ObjId := m_SchedObjs.GetLink(i);
      p_sc.GetPlanInfo(ObjId, info);
      if p_sc.HasFlags(ObjId, [CSF_FilterJobsInDynamicGantt]) then
      begin
        Result := true;
        if FirstFound then
        begin
          DateTime := info.startDate;
          FirstFound := false;
        end
        else
        begin
          if (info.startDate < DateTime) and (DateTime <> 0) then
             DateTime := info.startDate;
        end;
      end;
    end
  end;
end;

//----------------------------------------------------------------------------//

function TMqmActArea.GetFirstJobIdInDynamic(var JobId : TSchedId) : boolean;
var
  I : Integer;
  Id : TSchedId;
  info:  TSQPlanInfo;
begin
  Result := false;
  if Assigned(m_SchedObjs) then
  begin
    for i := m_SchedObjs.GetLinkCount - 1 downto 0 do
    begin
      Id := m_SchedObjs.GetLink(i);
      p_sc.GetPlanInfo(Id, info);
      if p_sc.HasFlags(Id, [CSF_FilterJobsInDynamicGantt]) then
      begin
        Result := true;
        JobId := Id;
      end;
    end
  end;
end;

//----------------------------------------------------------------------------//

function TMqmActArea.UpdateInstanceCounterProperty(Id, PrevId : TSchedId) : boolean;
var
  prop, PropPrev, PropInGrp : TProperties;
  JobId, PrevJobId, IdInGrp : TSchedId;
  I, J  : Integer;
  PropValue : Integer;
  PlaceInMainList, PlaceInMainListPrev : Integer;
  InstanceCounterProp, Res : string;
  propId: TPropID;
begin
  Result := false;
  propPrev := nil;
  PrevJobId := CSchedIDnull;

  if (id = CSchedIDnull) then exit;
  try
    if p_sc.IsGroup(Id) then
      JobId := p_sc.GetGrpSon(Id, 0)
    else
      JobId := Id;
  except
    Exit;
  end;

  if PrevId <> CSchedIDnull then
  begin
    try
      if p_sc.IsGroup(PrevId) then
        PrevJobId := p_sc.GetGrpSon(PrevId, 0)
      else
        PrevJobId := PrevId;
    except
      Exit;
    end;
  end;

  prop := p_sc.GetProperties(JobId,nil);
  if not assigned(prop) then exit;

  if prop.P_PropCountInstanceCounter = 0 then exit;
  Result := true;

  if PrevJobId <> CSchedIDnull then
    propPrev := p_sc.GetProperties(PrevJobId,nil);

  for I := 0 to prop.P_PropCountInstanceCounter - 1 do
  begin
    prop.GetPropertyInstanceCounter(I , InstanceCounterProp, PlaceInMainList);
    PropValue := 1;
    if (propPrev <> nil) then
    begin
      PlaceInMainListPrev := propPrev.SearchForPropertyInstanceCounterVal(InstanceCounterProp);
      if PlaceInMainListPrev > -1 then
      begin
        PropValue := propPrev.GetProperty(PlaceInMainListPrev, PropId, Res);
        PropValue := PropValue + 1;
      end;
    end;
    prop.SetPropertyInstanceCounterVal(PlaceInMainList, PropValue);
    if p_sc.IsGroup(Id) then
    begin
      for J := 1 to p_sc.GetGrpNumSons(id) - 1 do
      begin
        IdInGrp := p_sc.GetGrpSon(id, J);
        PropInGrp := p_sc.GetProperties(IdInGrp,nil);
        PlaceInMainListPrev := PropInGrp.SearchForPropertyInstanceCounterVal(InstanceCounterProp);
        if PlaceInMainListPrev > -1 then
           PropInGrp.SetPropertyInstanceCounterVal(PlaceInMainListPrev, PropValue);
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TMqmActArea.ReorganizeInstanceCounterProperty;
var
  I : Integer;
  ObjId1, ObjId2 : TSchedId;
begin
  if not assigned(m_SchedObjs) or (m_SchedObjs.GetLinkCount = 0) then
    Exit;

  ObjId1 := -1;
  for i := 0 to m_SchedObjs.GetLinkCount - 1 do
  begin
    ObjId2 := m_SchedObjs.GetLink(i);
    UpdateInstanceCounterProperty(ObjId2, ObjId1);
    ObjId1 := ObjId2;
   end;
end;

//----------------------------------------------------------------------------//

procedure TMqmActArea.CleanWarpList;
var
  I : Integer;
begin
  if assigned(m_WarpList) then
  begin
    for i := m_WarpList.Count -1 downto 0 do
      TMqmDurObj(m_WarpList[I]).Free;
    m_WarpList.ClearList
  end;
end;

//----------------------------------------------------------------------------//

procedure TMqmActArea.AddWarp(Warp: TMqmDurObj);
var
  StartTime, EndTime : TDateTime;
begin
  if not Assigned(m_WarpList) then
    m_WarpList := TDurList.Create(self);

  m_WarpList.AddTail(Warp);
  Warp.p_Father := self;
  Warp.m_plan := m_plan;

 { StartTime := Warp.p_start;
  GetCalendar.NormalizeDate(StartTime, ntNormalizeForward);
//  GetCalendar.OfsByWH(CapRes.p_dur/60 , true, StartTime, EndTime, m_CrossDownTmList);
  GetCalendar.OfsByWHDwTime(Warp.p_durDouble/60 , true, StartTime, EndTime);
  Warp.p_end := EndTime;  }

  // update real time warp
 // UpdateCrossDownTmList;

end;

//----------------------------------------------------------------------------//

procedure TMqmActArea.RemoveWarp(Warp: TMqmDurObj);
begin
  if Assigned(m_WarpList) then
  begin
    m_WarpList.DetachObject(Warp);
   // UpdateCrossDownTmList;
  end;
end;

//----------------------------------------------------------------------------//

procedure TMqmActArea.AddCapRes(CapRes: TMqmDurObj);
var
  StartTime, EndTime : TDateTime;
begin

  if not Assigned(m_CapResList) then
    m_CapResList := TDurList.Create(self);

  m_CapResList.AddTail(CapRes);
  CapRes.p_Father := self;
  CapRes.m_plan := m_plan;

  StartTime := CapRes.p_start;
  GetCalendar.NormalizeDate(StartTime, ntNormalizeForward);
//  GetCalendar.OfsByWH(CapRes.p_dur/60 , true, StartTime, EndTime, m_CrossDownTmList);
  GetCalendar.OfsByWHDwTime(CapRes.p_dur/60 , true, StartTime, EndTime);
  CapRes.p_end := EndTime;
  UpdateCrossDownTmList;

  // I think this check should be opposite - fp
  if (not TMQMVisibleRes(p_Father).p_isSubRes) and (TMQMRes(p_Res).p_VisResCount > 1) then
  begin
    if (TMQMCapRes(CapRes).m_Type = cr_DownTime) or (TMQMCapRes(CapRes).m_Type = Cr_CrossingDtm) then
      TMQMRes(p_Res).AddDwTimeLinked(CapRes, TMQMVisibleRes(p_Father).p_SubCode = 1);
  end;

end;

//----------------------------------------------------------------------------//

procedure TMqmActArea.RemoveCapRes(CapRes: TMqmDurObj);
begin
//  Assert(Assigned(m_CapResList));
  if Assigned(m_CapResList) then
  begin
    m_CapResList.DetachObject(CapRes);
    UpdateCrossDownTmList;
  end;
end;

//----------------------------------------------------------------------------//

procedure TMqmActArea.RemoveAllCapResDummy;
var
  i : integer;
  CapRes : TMqmDurObj;
begin
  if Assigned(m_CapResList) then
  for i := m_CapResList.Count -1 downto 0 do
  begin
    CapRes := TMqmDurObj(m_CapResList[i]);
    if (TMQMCapRes(CapRes).m_Type <> Cr_DummyDtm) and (TMQMCapRes(CapRes).m_Type <> Cr_DummyUpTime) then continue;
    RemoveCapRes(CapRes);
  end;
end;

//----------------------------------------------------------------------------//

procedure TMqmActArea.RemoveAllCapResDynamic;
var
  i : integer;
  CapRes : TMqmDurObj;
begin
  if Assigned(m_CapResList) then
  for i := m_CapResList.Count -1 downto 0 do
  begin
    CapRes := TMqmDurObj(m_CapResList[i]);
    if (TMQMCapRes(CapRes).m_Type = Cr_Dynamic) then
      RemoveCapRes(CapRes);
  end;
end;

//----------------------------------------------------------------------------//

procedure TMqmActArea.RemoveAllCapResDummyUpTime;
var
  i : integer;
  CapRes : TMqmDurObj;
begin
  if Assigned(m_CapResList) then
  for i := m_CapResList.Count -1 downto 0 do
  begin
    CapRes := TMqmDurObj(m_CapResList[i]);
    if TMQMCapRes(CapRes).m_Type <> Cr_DummyUpTime then continue;
    RemoveCapRes(CapRes);
  end;
end;

//----------------------------------------------------------------------------//

procedure TMqmActArea.AddSchedObj(id: TSchedID);
begin
  if not Assigned(m_SchedObjs) then
    m_SchedObjs := TMSchedList.Create(self);

  RemoveSchedObj(id);
  m_SchedObjs.AddLink(id);

  p_sc.SetExtLinkPtr(id, self)
end;

//----------------------------------------------------------------------------//

procedure TMqmActArea.RemoveSchedObj(id: TSchedID);
begin
  Assert(Assigned(m_SchedObjs));
  m_SchedObjs.Remove(id);
  p_sc.SetExtLinkPtr(id, nil);
  p_sc.SetLearningCurveCodeOccToOcc(id, '');
end;

//----------------------------------------------------------------------------//

procedure TMqmActArea.RemoveAllCapRes;
var
  i : integer;
  CapRes : TMqmDurObj;
begin
  if Assigned(m_CapResList) then
    for i := m_CapResList.Count -1 downto 0 do
    begin
      CapRes := TMqmDurObj(m_CapResList[i]);
      RemoveCapRes(CapRes);
    end;
end;

//----------------------------------------------------------------------------//

procedure TMqmActArea.SetComponents(Components: integer);
begin
  m_Components := Components;
end;

//----------------------------------------------------------------------------//

function TMqmActArea.CapResCount: integer;
begin
  if Assigned(m_CapResList) then
    Result := m_CapResList.Count
  else
    Result := 0
end;

//----------------------------------------------------------------------------//

function TMqmActArea.GetCapRes(i: integer): TMqmPlanObj;
begin
  Assert((i >= 0) and (i < m_CapResList.Count));
  Result := TMqmPlanObj(m_CapResList[i])
end;

//----------------------------------------------------------------------------//

function TMqmActArea.WarpCount: integer;
begin
  if Assigned(m_WarpList) then
    Result := m_WarpList.Count
  else
    Result := 0
end;

//----------------------------------------------------------------------------//

function TMqmActArea.GetWarp(i: integer): TMqmPlanObj;
begin
  Assert((i >= 0) and (i < m_WarpList.Count));
  Result := TMqmPlanObj(m_WarpList[i])
end;

//----------------------------------------------------------------------------//

procedure TMqmActArea.SortCapRes;
begin
  if Assigned(m_CapResList) then
    m_CapResList.SortList
end;

//----------------------------------------------------------------------------//

procedure TMqmActArea.SortWarp;
begin
  if Assigned(m_WarpList) then
    m_WarpList.SortList
end;

//----------------------------------------------------------------------------//

function TMqmActArea.SchedObjsCount: integer;
begin
  if Assigned(m_SchedObjs) then
    Result := m_SchedObjs.GetLinkCount
  else
    Result := 0
end;

//----------------------------------------------------------------------------//

function TMqmActArea.GetSchedObj(i: integer): TSchedID;
begin
//  Assert(Assigned(m_SchedObjs)); - fp
  if not Assigned(m_SchedObjs) then
    Result := CSchedIDnull
  else
    Result := m_SchedObjs.GetLink(i)
end;

//----------------------------------------------------------------------------//

function TMqmActArea.GetPrecObjByIndex(Obj: TSchedID): TSchedID;
var
  ObjIndex: integer;
begin
  Result := CSchedIDnull;
  if not Assigned(m_SchedObjs) then
    exit;

//  SortSchedObjs;

  ObjIndex := m_SchedObjs.IndexOf(Obj);

  if (ObjIndex < m_SchedObjs.GetLinkCount)
  and (ObjIndex > 0) then
    Result := m_SchedObjs.GetLink(ObjIndex-1);
end;

//----------------------------------------------------------------------------//

function TMqmActArea.GetObjIndex(Obj: TSchedID): Integer;
begin
  Result := -1;
  if not Assigned(m_SchedObjs) then
    exit;
  Result := m_SchedObjs.IndexOf(Obj);
end;

//----------------------------------------------------------------------------//

function TMqmActArea.GetNextObjByIndex(Obj: TSchedID): TSchedID;
var
  ObjIndex: integer;
begin
  Result := CSchedIDnull;
  if not Assigned(m_SchedObjs) then
    exit;

//  SortSchedObjs;

  ObjIndex := m_SchedObjs.IndexOf(Obj);

  if (ObjIndex < m_SchedObjs.GetLinkCount-1)
  and (ObjIndex >= 0) then
    Result := m_SchedObjs.GetLink(ObjIndex+1);
end;

//----------------------------------------------------------------------------//

function TMqmActArea.GetPrecObj(Date: TDateTime; avoid: TSchedID): TSchedID;
var
  i:     integer;
  info:  TSQStartEndInfo;
  ObjId: TSchedID;
begin
  Result := CSchedIDnull;
  if not Assigned(m_SchedObjs) then
    exit;

//  SortSchedObjs;

  for i := m_SchedObjs.GetLinkCount-1 downto 0 do
  begin
    ObjId := m_SchedObjs.GetLink(i);
    if ObjId = avoid then continue;
    p_sc.GetStartInfo(ObjId, info);
//    if (info.endDate <= date)
    if (info.startDate < date) then
    begin
      Result := ObjId;
      break
    end
  end
end;

//----------------------------------------------------------------------------//

function TMqmActArea.GetPrecObjFromPlanClicked(Date: TDateTime; avoid: TSchedID): TSchedID;
var
  ObjToCheck : TMSchedList;
//  ID : TSchedID;
//  planInfo: TSQplanInfo;
begin
  Result := CSchedIDnull;
  ObjToCheck := TMSchedList.Create(self);
  SortSchedObjs;
  FindSchedInSpots(date, date, ObjToCheck);
  if ObjToCheck.GetLinkCount > 0 then
  begin
    Result := TSchedID(ObjToCheck.GetLink(0));
    //ID := TSchedID(ObjToCheck.GetLink(0));
    //p_sc.GetPlanInfo(id, planInfo);
    //Result := GetPrecObj(planInfo.startDate, avoid);
  end;
  ObjToCheck.Free;
end;

//----------------------------------------------------------------------------//

function TMqmActArea.GetNextObj(Date: TDateTime; avoid: TSchedID): TSchedID;
var
  i:     integer;
  info:  TSQPlanInfo;
  ObjId: TSchedID;
begin
  Result := CSchedIDnull;
  if not Assigned(m_SchedObjs) then
    exit;

//  SortSchedObjs;

  for i := 0 to m_SchedObjs.GetLinkCount-1 do
  begin
    ObjId := m_SchedObjs.GetLink(i);
    if ObjId = avoid then continue;
    p_sc.GetPlanInfo(ObjId, info);
    if (info.startDate >= date) then
//    if (info.endDate >= date) then
    begin
      Result := ObjId;
      break
    end
  end
end;

//----------------------------------------------------------------------------//

function TMqmActArea.FindSchedBeforeOrAfterDate(Before : boolean; Date : TDateTime) : TSchedId;
begin
  result := CSchedIDnull;
  if Assigned(m_SchedObjs) then
  begin
    if Before then
      result := m_SchedObjs.FindSchedBeforeDate(date)
    else
      result := m_SchedObjs.FindSchedAfterDate(date);
  end;
end;

//----------------------------------------------------------------------------//

function TMqmActArea.FindSchedInSpot(date : TDateTime) : TSchedId;
begin
  result := CSchedIDnull;
  if Assigned(m_SchedObjs) then
    result := m_SchedObjs.FindSchedInSpot(date)
end;

//----------------------------------------------------------------------------//

procedure TMqmActArea.FindSchedInSpots(startTm, endTm: TDateTime; ObjList: TMSchedList);
begin
  if Assigned(m_SchedObjs) then
    m_SchedObjs.FindSchedInSpots(startTm, endTm, ObjList)
end;

//----------------------------------------------------------------------------//

function TMqmActArea.FindCoverSchedInSpot(ActiveDate: TDateTime; var id: TSchedID): boolean;
begin
  Id := CSchedIDnull;
  Result := false;
  if Assigned(m_SchedObjs) then
    result := m_SchedObjs.FindCoverSchedInSpot(ActiveDate, id)
end;

//----------------------------------------------------------------------------//

procedure TMqmActArea.SortSchedObjs;
var
  IsSorted : boolean;
begin
  if not Assigned(m_SchedObjs) then exit;
  try
    IsSorted := BuildInstPropAndCheckIfListIsSorted;
  if not IsSorted then m_SchedObjs.SortList(OrderGrowing);
  if (not IsSorted) or (m_SchedObjs.GetLinkCount = 1) then
    ReorganizeInstanceCounterProperty;
  except
  end;
end;

//----------------------------------------------------------------------------//

function TMqmActArea.BuildInstPropAndCheckIfListIsSorted : boolean;
var
  I : Integer;
  schedStart1 : TDateTime;
  schedStart2 : TDateTime;
  ObjId, ObjIdPrev : TSchedId;
  Req1, Req2, Step1, Step2, SubStep1, SubStep2 : variant;
  dataType: CBinColValType;
begin
  result := true;
  if not assigned(m_SchedObjs) then
  begin
    Result := false;
    Exit
  end;

  if m_SchedObjs.GetLinkCount = 0 then exit;
  ObjId := m_SchedObjs.GetLink(0);
  UpdateInstanceCounterProperty(ObjId, -1);

  schedStart1 := p_sc.GetSchedStart(ObjId);
  p_sc.GetFldValue(ObjId, CSC_ProdReq, Req1, dataType);
  p_sc.GetFldValue(ObjId, CSC_ProdStep, Step1, dataType);
  p_sc.GetFldValue(ObjId, CSC_ProdSubStep, SubStep1, dataType);

  for i := 1 to m_SchedObjs.GetLinkCount - 1 do
  begin
    ObjIdPrev := ObjId;
    ObjId := m_SchedObjs.GetLink(i);
    UpdateInstanceCounterProperty(ObjId, ObjIdPrev);

    schedStart2 := p_sc.GetSchedStart(ObjId);
    p_sc.GetFldValue(ObjId, CSC_ProdReq, Req2, dataType);
    p_sc.GetFldValue(ObjId, CSC_ProdStep, Step2, dataType);
    p_sc.GetFldValue(ObjId, CSC_ProdSubStep, SubStep2, dataType);

    if schedstart2 < schedStart1 then
    begin
      result := false;
      exit;
    end;
    if schedstart2 = schedStart1 then
    begin
      if Req2 < Req1 then
      begin
        result := false;
        exit;
      end;
      if Req2 = Req1 then
      begin
        if Step2 < Step1 then
        begin
          result := false;
          exit;
        end;
        if Step2 = Step1 then
        begin
          if SubStep2 < SubStep1 then
          begin
            result := false;
            exit;
          end;
        end;
      end;
    end;
    schedStart1 := schedstart2;
    Req1 := Req2;
    Step1 := Step2;
    SubStep1 := SubStep2;
   end;
end;

//----------------------------------------------------------------------------//

procedure TMqmActArea.SortSchedObjsByEnd;
begin
  if Assigned(m_SchedObjs) then
    m_SchedObjs.SortList(OrderGrowingByEnd);
end;

//----------------------------------------------------------------------------//

procedure TMqmActArea.SetStart(date: TDateTime);
begin
  m_Start := date;
end;

//----------------------------------------------------------------------------//

procedure TMqmActArea.SetEnd(date: TDateTime);
begin
  m_savedEnd := date;
end;

//----------------------------------------------------------------------------//

procedure TMqmActArea.SetDur(durMin: integer);
begin
//  HandleBackup;
//  m_dur := durMin;
//  m_savedEnd := 0
end;

//----------------------------------------------------------------------------//

function TMqmActArea.GetStart: TDateTime;
begin
  Result := m_Start
end;

//----------------------------------------------------------------------------//

function TMqmActArea.GetEnd: TDateTime;
begin
  Result := m_savedEnd
end;

//----------------------------------------------------------------------------//

function TMqmActArea.GetDur: integer;
begin
  Result := 0
end;

//----------------------------------------------------------------------------//

procedure TMqmActArea.StartGenerator(lt, rt: TDateTime);
begin
  m_lt := lt;
  m_rt := rt;

  SortWarp;
  SortCapRes;
  SortSchedObjs;

  // fix on the first object to show
  if (not StartCapRes) and (not StartWarp) and (not StartSchedObj) then m_genObt := GOBT_NONE
end;

//----------------------------------------------------------------------------//

function TMqmActArea.Next(parms: PTRowParms; var dwFnc: TDurShDraw ; var ToAdd : boolean): boolean;
begin
  if m_genObt <> GOBT_NONE then
  begin
    Result := true;
    if m_genObt = GOBT_CAPRES then
    begin
      if NextCapRes(parms, dwFnc) then exit;
      if not StartWarp then
        StartSchedObj;
    end;

    if m_genObt = GOBT_WARP then
    begin
      if NextWarp(parms, dwFnc) then exit;
      StartSchedObj
    end;

    if m_genObt = GOBT_SCHEDOBJ then
    begin
      if NextSchedObj(parms, dwFnc, ToAdd) then exit;
      StartCompat
    end;
    if (m_genObt = GOBT_COMPAT) and NextCompat(parms, dwFnc) then exit
  end;
  Result := false
end;

//----------------------------------------------------------------------------//

function TMqmActArea.StartCapRes: boolean;
begin
  Result := false;

  m_firstCapRes := -1;

  if Assigned(m_CapResList) then
  begin
    m_firstCapRes := m_CapResList.FindCovering(m_lt, m_rt, nil);
    m_cnt := m_firstCapRes;
    if m_cnt <> -1 then
    begin
      m_genObt := GOBT_CAPRES;
      Result := true
    end
  end

end;

//----------------------------------------------------------------------------//

function TMqmActArea.StartWarp: boolean;
begin
  Result := false;

  m_firstWarp := -1;

  if Assigned(m_WarpList) then
  begin
    m_firstWarp := m_WarpList.FindCovering(m_lt, m_rt, nil);
    m_cnt := m_firstWarp;
    if m_cnt <> -1 then
    begin
      m_genObt := GOBT_WARP;
      Result := true
    end
  end

end;

//----------------------------------------------------------------------------//

function TMqmActArea.StartSchedObj: boolean;
begin
  Result := false;

  m_firstSched := -1;

  if p_sc.P_ReorganizeAllEnd then
     SortSchedObjs;

  if Assigned(m_SchedObjs) then
  begin
    m_firstSched := p_sc.FindCovering(m_lt, m_rt, -1, m_SchedObjs, false);
    m_cnt := m_firstSched;
    if m_cnt <> -1 then
    begin
      m_genObt := GOBT_SCHEDOBJ;
      Result := true
    end
  end
end;

//----------------------------------------------------------------------------//

function TMqmActArea.StartCompat: boolean;
begin
  if (m_firstCapRes = -1) or (m_firstSched = -1) then
    m_genObt := GOBT_NONE
  else
    m_genObt := GOBT_COMPAT;

  m_cnt := m_firstSched;

  Result := true
end;

//----------------------------------------------------------------------------//

function TMqmActArea.NextCapRes(parms: PTRowParms; var dwFnc: TDurShDraw): boolean;
var
  CapRes: TMqmDurObj;
begin
  Result := false;

  if m_cnt = -1 then exit;

  CapRes := TMqmDurObj(m_CapResList[m_cnt]);
  if CapRes.p_start > m_rt then exit;

  // find the next occupation
  Inc(m_cnt);
  if m_cnt = p_CapResCount then m_cnt := -1;

  Result := true;

  if TMqmCapRes(CapRes).m_Type = cr_DownTime then
    SetDrawPos(parms.top, parms.hgt, st_DownTime)
  else if TMqmCapRes(CapRes).m_Type = Cr_CrossingDtm then
    SetDrawPos(parms.top, parms.hgt, st_CrossDownTime)
  else
    SetDrawPos(parms.top, parms.hgt, st_CapRes);

  dwFnc := @DrawCapRes;      // draw function
  parms.lev       := 1;               // level priority
  parms.st        := CapRes.p_start;  // start time of the object
  parms.et        := CapRes.p_end;    // end time of the object
  parms.it        := 0;                // setup end time
  parms.mt        := 0;                // setup without material start time
  parms.compatVal := CompValNotDef;    // compatibility value
  parms.isTmp     := false;
  parms.suppVal1  := -1;
  parms.suppVal2  := -1;
//  parms.errVal    := CSE_NoError;
  parms.errSet    := [];
  parms.isContObj := false;
  parms.objPtr    := CapRes;           // reference object

  parms.NoMaterialList := nil;   // fp - tmp0408
  parms.NoAddResList   := nil;     // fp - tmp0408
  parms.NoPrevStepList := nil;
end;

//----------------------------------------------------------------------------//

function TMqmActArea.NextWarp(parms: PTRowParms; var dwFnc: TDurShDraw): boolean;
var
  Warp: TMqmDurObj;
begin
  Result := false;

  if m_cnt = -1 then exit;

  Warp := TMqmDurObj(m_WarpList[m_cnt]);
  if Warp.p_start > m_rt then exit;

  // find the next occupation
  Inc(m_cnt);
  if m_cnt = p_warpCount then m_cnt := -1;

  Result := true;

  if TMqmWarp(Warp).m_WarpLvl = MT_BaseLvl then
    SetDrawPos(parms.top, parms.hgt, st_Warp_1lvl)
  else if TMqmWarp(Warp).m_WarpLvl = MT_SecondLvl then
    SetDrawPos(parms.top, parms.hgt, st_Warp_2lvl)
  else
    SetDrawPos(parms.top, parms.hgt, st_Warp_1lvl);

  dwFnc := @DrawWarp;      // draw function
  parms.lev       := 1;               // level priority
  parms.st        := Warp.p_start;  // start time of the object
  parms.et        := Warp.p_end;    // end time of the object
  parms.it        := 0;                // setup end time
  parms.mt        := 0;                // setup without material start time
  parms.compatVal := CompValNotDef;    // compatibility value
  parms.isTmp     := false;
  parms.suppVal1  := -1;
  parms.suppVal2  := -1;
//  parms.errVal    := CSE_NoError;
  parms.errSet    := [];
  parms.isContObj := false;
  parms.objPtr    := Warp;           // reference object
  parms.objActArea_Warp := self;

  parms.NoMaterialList := nil;   // fp - tmp0408
  parms.NoAddResList   := nil;     // fp - tmp0408
  parms.NoPrevStepList := nil;
end;

//----------------------------------------------------------------------------//

function TMqmActArea.NextSchedObj(parms: PTRowParms; var dwFnc: TDurShDraw; var ToAdd : boolean): boolean;
var
  id: TSchedID;
  planInfo: TSQplanInfo;
begin
  Result := false;
  ToAdd := true;
  if m_cnt = -1 then exit;

  id := m_SchedObjs.GetLink(m_cnt);
  p_sc.GetPlanInfo(id, planInfo);

  if (planInfo.startDate > m_rt) then exit;

  // find the next job
  Inc(m_cnt);
  if m_cnt = m_SchedObjs.GetLinkCount then m_cnt := -1;

  Result := true;

  if (planInfo.startDate > GetLimitRightDate) then
  begin
    ToAdd := false;
    exit;
  end;

  if planInfo.endDate < GetLimitLeftDate then
  begin
    ToAdd := false;
    exit;
  end;

  if planInfo.isGroup then
  begin
    SetDrawPos(parms.top, parms.hgt, st_Group);
    dwFnc := @DrawGroup        // draw function
  end else
  begin
    SetDrawPos(parms.top, parms.hgt, st_SchedObj);
    dwFnc := @DrawSchedObj     // draw function
  end;

  parms.lev       := 1;                  // level priority
  parms.st        := planInfo.startDate; // start time of the object
  parms.et        := planInfo.endDate;   // end time of the object
  if planInfo.supMinReal > 0 then
    GetCalendar.OfsByWH(planInfo.supMinReal/60, true, planInfo.startDate, parms.it, m_CrossDownTmList) // setup end time
  else
    parms.it := 0;
  if planInfo.supMinOvlp > 0 then
    GetCalendar.OfsByWH(planInfo.supMinOvlp/60, true, planInfo.startDate, parms.mt, m_CrossDownTmList) // setup without material start time
  else
    parms.mt := 0;
  parms.compatVal := CompValNotDef;      // compatibility value
  parms.isTmp     := false;              // not temporary object
  parms.suppVal1  := -1;
  parms.suppVal2  := -1;
//  parms.errVal    := CSE_NoError;
  parms.errSet    := [];
  parms.isContObj := true;
  parms.objPtr    := pointer(id);        // reference object

  parms.NoMaterialList := nil;   // fp - tmp0408
  parms.NoAddResList   := nil;     // fp - tmp0408
  parms.NoPrevStepList := nil;
end;

//----------------------------------------------------------------------------//

function TMqmActArea.NextCompat(parms: PTRowParms; var dwFnc: TDurShDraw): boolean;
var
  planInfo:    TSQplanInfo;
  capRes:      TMqmCapRes;
  id: TSchedID;
  maxStart,
  minEnd:   TDateTime;
begin
  Result := false;

  if m_firstSched = -1 then exit;

  id := m_SchedObjs.GetLink(m_firstSched);
  p_sc.GetPlanInfo(id, planInfo);
  if planInfo.startDate > m_rt then exit;

  if m_firstCapRes = -1 then exit;
  capRes := TMqmCapRes(m_CapResList[m_firstCapRes]);
  if capRes.p_start > m_rt then exit;

  // find the overlapping region between occupation and job
  while true do
  begin
    maxStart := Max(capRes.p_start, planInfo.startDate);
    minEnd   := Min(capRes.p_end,   planInfo.endDate);

    if maxStart < minEnd then
    begin

      // decide if increment occupations or jobs
      if capRes.p_end > planInfo.endDate then
      begin
        Inc(m_firstSched);
        if m_firstSched = m_SchedObjs.GetLinkCount then m_firstSched := -1
      end
      else if capRes.p_end < planInfo.endDate then
      begin
        Inc(m_firstCapRes);
        if m_firstCapRes = m_CapResList.Count then m_firstCapRes := -1
      end
      else
      begin
        Inc(m_firstSched);
        if m_firstSched = m_SchedObjs.GetLinkCount then m_firstSched := -1;
        Inc(m_firstCapRes);
        if m_firstCapRes = m_CapResList.Count then m_firstCapRes := -1
      end;
      break
    end;

    if capRes.p_end < planInfo.startDate then
    begin
      Inc(m_firstCapRes);
      if (m_firstCapRes = m_CapResList.Count) or
         (TMqmCapRes(m_CapResList[m_firstCapRes]).p_start > m_rt) then
        exit;
      capRes := TMqmCapRes(m_CapResList[m_firstCapRes])
    end
    else
    begin
      Inc(m_firstSched);
      if m_firstSched = m_SchedObjs.GetLinkCount then exit;
      id := m_SchedObjs.GetLink(m_firstSched);
      p_sc.GetPlanInfo(id, planInfo);
      if planInfo.startDate > m_rt then exit
    end
  end;

  Assert(id <> CSchedIDnull);
  Assert(Assigned(capRes));

  Result := true;

  SetDrawPos(parms.top, parms.hgt, st_Compat);
  dwFnc := @DrawCmp;         // draw function

  parms.lev       := 1;          // level priority
  parms.st        := maxStart;   // start time of the object
  parms.et        := minEnd;     // end time of the object
  parms.it        := 0;                // setup end time
  parms.mt        := 0;                // setup without material start time
  parms.compatVal := CompValNotDef;    // compatibility value
  parms.isTmp     := true;
  parms.suppVal1  := -1;
  parms.suppVal2  := -1;
//  parms.errVal    := CSE_NoError;
  parms.errSet    := [];
  parms.isContObj := false;
  parms.objPtr    := TMqmCmp.CreateMqmCmp;     // reference object
  TMqmCmp(parms.objPtr).m_diffVal := TMqmRes(CapRes.p_Res).CheckCompIDCapRes(id, capRes);
  //TMqmCmp(parms.objPtr).m_diffVal := TMqmRes(CapRes.p_Resource).CheckCompIDCapRes(id, capRes)

  if (capRes.m_Type = Cr_CrossingDtm) then   // avi
  begin
    parms.st := 0;
    parms.et := 0;
  end;

  parms.NoMaterialList := nil;   // fp - tmp0408
  parms.NoAddResList   := nil;     // fp - tmp0408
  parms.NoPrevStepList := nil;

end;

//----------------------------------------------------------------------------//

function TMqmActArea.FindObjCoverInSpot(date : TDateTime; Warp : TMqmDurObj) : TMqmDurObj;
var
  I : Integer;
  CoveredObj : TMqmDurObj;
begin
 { Result := nil;
  if Assigned(m_CapResList) then
  begin
    for i := 0 to m_CapResList.Count -1 do
    begin
      CoveredObj := TMqmDurObj(m_CapResList.p_sons[i]);
      if CoveredObj.p_end <= date then Continue;
      if CoveredObj.p_start >= date then break;
      result := CoveredObj;
      exit
    end;
  end;

  if Assigned(m_WarpList) then
  begin
    for i := 0 to m_WarpList.Count -1 do
    begin
      CoveredObj := TMqmDurObj(m_WarpList.p_sons[i]);
      if CoveredObj.p_start >= date then exit;
      if CoveredObj.p_end <= date then Continue;
      if CoveredObj = Warp then continue;
      if TMqmWarp(CoveredObj).m_WarpLvl <> TMqmWarp(Warp).m_WarpLvl then Continue;
      result := CoveredObj;
      exit
    end;
  end;  }
end;

//----------------------------------------------------------------------------//

function TMqmActArea.FindCapResCovering(startTm, endTm: TDateTime; skipObj: TMqmDurObj): integer;
begin
  if Assigned(m_CapResList) then
    Result := m_CapResList.FindCovering(startTm, endTm, skipObj)
  else
    Result := -1
end;

//----------------------------------------------------------------------------//

procedure TMqmActArea.GetCapResInSpot(startTm, endTm: TDateTime; var ObjList: TDurList);
begin
  if Assigned(m_CapResList) then
    m_CapResList.FindObjsInSpot(startTm, endTm, ObjList)
end;

//----------------------------------------------------------------------------//

function TMqmActArea.FindCapResInSpots(startTm : TDateTime; var StartTime : TDateTime; skipObj: TMqmDurObj; var OrigStart : TDateTime) : boolean;
begin
  Result := false;
  if Assigned(m_CapResList) then
    Result := m_CapResList.FindObjInSpots(startTm, StartTime, skipObj, OrigStart);
end;

//----------------------------------------------------------------------------//

function TMqmActArea.FindCrossingDwTime(startTm, endTm: TDateTime): PTRecCalDownTime;
var
  i: integer;
  TempRecDownTime: PTRecCalDownTime;
begin
  Result := nil;
  if Assigned(m_CrossDownTmList) then
  for i := 0 to m_CrossDownTmList.Count - 1 do
  begin
    TempRecDownTime := m_CrossDownTmList[i];
    if not ((TempRecDownTime.DowntimeEnd <= StartTm) or (TempRecDownTime.DowntimeStart >= endTm)) then
    begin
      Result := TempRecDownTime;
      exit
    end
  end;
end;

//----------------------------------------------------------------------------//

function TMqmActArea.CheckDateOnSubResources(CurrentActArea : TMqmActArea; Id : TSchedId; StartDate : TdateTime; planInfo : TSQplanInfo) : TDateTime;
type
 TSubResources = record
   FromIndex  : integer;
   VisRes     : TMQMVisibleRes;
 end;
 PTSubResources = ^TSubResources;
var
  ResCode : string;
  Cal     : TPGCALObj;
  ObjId   : TSchedId;
  DatesInfo : TSQStartEndInfo;
  Visres : TMQMVisibleRes;
  I, J, DateToCheckIdx : Integer;
  EndTm, DateToCheck, LowestDateFound : TDateTime;
  ComponentsAllowed, NeededComponents, TotalComponents, CurrentComponents, FromIndex : integer;
  SubResourcesList : TList;
  DatesToCheck : TStringList;
  PSubResources : PTSubResources;
  CheckLeftSide, CheckRightSide, AllPositionsAreOk : boolean;
  ActArea : TMqmActArea;
begin
  Result := StartDate;

  ResCode := TMqmRes(Self.p_res).p_ResCode;
  ComponentsAllowed := TMqmRes(Self.p_res).p_ResComp;
  NeededComponents := p_sc.GetJobComponents(Id, true);

  if NeededComponents > ComponentsAllowed then
    exit;

  Cal := GetCalendar;

  SubResourcesList := Tlist.Create;
  for I := 0 to TMqmRes(p_res).p_VisResCount - 1 do
  begin
    new(PSubResources);
    Visres := TMqmRes(p_res).p_VisRes[I];
    if TMqmActArea(VisRes.p_ActArea[0]) = CurrentActArea then continue;
    ActArea := TMqmActArea(Visres.p_ActArea[0]);
    PSubResources.FromIndex := 0;
    PSubResources.VisRes := Visres;
    SubResourcesList.Add(PSubResources);
  end;

  DatesToCheck := TStringList.Create;

  while true do
  begin

    Cal.OfsByWH((planInfo.supMinBase + planInfo.exeMin)/60, true, Result, Endtm, m_CrossDownTmList);

    DatesToCheck.Clear;
    DatesToCheck.Add(DateTimeToStr(Result));
    LowestDateFound := 999999;

    for I := 0 to SubResourcesList.Count - 1 do
    begin
      PSubResources := PTSubResources(SubResourcesList[I]);
      FromIndex := PSubResources.FromIndex;
      ActArea := TMqmActArea(PSubResources.Visres.p_ActArea[0]);
      ObjId := ActArea.GetSchedObj(0);
      if ObjId <> CSchedIDnull then
      begin
        for J := FromIndex to ActArea.p_ObjCount - 1 do
        begin
          ObjId := ActArea.GetSchedObj(j);
          p_sc.GetStartEndInfo(ObjId, DatesInfo);
          if DatesInfo.startDate >= Endtm then break;
          if DatesInfo.endDate <= Result then
          begin
            PSubResources.FromIndex := (J + 1);
            continue;
          end;
          if (DatesInfo.startDate > Result) then
            DatesToCheck.Add(DateTimeToStr(DatesInfo.startDate));
          if (DatesInfo.endDate < Endtm) then
            DatesToCheck.Add(DateTimeToStr(DatesInfo.endDate));
          if (DatesInfo.startDate > Result) and (LowestDateFound > DatesInfo.startDate) then
            LowestDateFound := DatesInfo.startDate;
          if LowestDateFound > DatesInfo.endDate then
            LowestDateFound := DatesInfo.endDate;
        end;
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
        ActArea := TMqmActArea(PSubResources.Visres.p_ActArea[0]);
        ObjId := ActArea.GetSchedObj(0);
        if ObjId <> CSchedIDnull then
        begin
          for J := FromIndex to ActArea.p_ObjCount - 1 do
          begin
            ObjId := ActArea.GetSchedObj(j);
            p_sc.GetStartEndInfo(ObjId, DatesInfo);
            if ((DatesInfo.startDate < DateToCheck) and (DatesInfo.endDate > DateToCheck))
            or (CheckLeftSide and (DatesInfo.endDate = DateToCheck))
            or (not CheckLeftSide and CheckRightSide and (DatesInfo.StartDate = DateToCheck)) then
            begin
              CurrentComponents := p_sc.GetJobComponents(ObjId, true);
              TotalComponents := TotalComponents + CurrentComponents;
              break;
            end;
            if DatesInfo.startDate >= Endtm then
              break;
          end;
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
      break;

    Result := LowestDateFound;

  end;

  for I := 0 to SubResourcesList.Count - 1 do
    dispose(PTSubResources(SubResourcesList[I]));
  SubResourcesList.Free;
  DatesToCheck.free;
end;

//----------------------------------------------------------------------------//

function TMqmActArea.FindAllObjCovering(DurList : TDurList; StDate, Endate : TDateTime; RefObj: TMqmDurObj; var LastIndexChecked : integer; IsWarpList : boolean) : boolean;
var
  StartIndex, i: integer;
  CapRes: TMqmCapRes;
  CompVal : TCompatVal;
  CoveredObj : TMqmDurObj;
  Starttm, Endtm : TDateTime;
begin
  Result := false;
  if not IsWarpList and not Assigned(m_CapResList) then
    exit
  else if IsWarpList and not Assigned(m_WarpList) then exit;

 { if LastIndexChecked < 0 then
  begin
    Starttm := RefObj.p_start;
    Endtm := RefObj.p_end;
    StartIndex := DurList.FindCovering(Starttm, Endtm, RefObj)
  end
  else
    StartIndex := LastIndexChecked + 1;  }

//  if StartIndex <> -1 then
//  begin
    for i := 0 to DurList.Count -1 do
    begin
      //LastIndexChecked := i;
      CoveredObj := TMqmDurObj(DurList.p_sons[i]);
      if CoveredObj = RefObj then continue;
      if CoveredObj.p_start >= Endate then exit;
      if CoveredObj.p_end <= StDate then Continue;
      if IsWarpList and (CoveredObj is TMqmWarp) and (RefObj is TMqmWarp) and
         (TMqmWarp(CoveredObj).m_WarpLvl <> TMqmWarp(RefObj).m_WarpLvl) then Continue;
      result := true;
      exit
    //  LastIndexChecked := i;
    end;
  //end;
end;

//----------------------------------------------------------------------------//

function TMqmActArea.FindDwTimeCovering(startTm, endTm: TDateTime; Id : TSchedId): TMqmDurObj;
var
  StartIndex, i: integer;
  CapRes: TMqmCapRes;
  CompVal : TCompatVal;
begin
  Result := nil;
  if not Assigned(m_CapResList) then exit;

  StartIndex := m_CapResList.FindCovering(startTm, endTm, nil);
  if StartIndex <> -1 then
  begin
    for i := StartIndex to m_CapResList.Count -1 do
    begin
      CapRes := TMqmCapRes(m_CapResList.p_sons[i]);
      if CapRes.p_start >= endTm then exit;
      if CapRes.p_end <= StartTm then Continue;
      if (CapRes.m_Type = cr_DownTime) or (CapRes.m_Type = Cr_CrossingDtm) then
      begin
        Result := CapRes;
        exit
      end;
      if (CapRes.m_Type = cr_Normal) and (Id <> CSchedIDnull) then
      begin
        CompVal := TMqmRes(CapRes.p_Res).CheckCompIDCapRes(Id, capRes);
        if (CompVal = CompValNotComp) or (not CapRes.CheckUpMostCase(CompVal)) then
        begin
          Result := CapRes;
          exit;
        end;
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

function TMqmActArea.FindWarpCoveringByIndex(startTm, endTm: TDateTime; var LastIndexChecked : integer): TMqmDurObj;
var
  StartIndex, i: integer;
  Warp: TMqmWarp;
  Item_Id : TSchedId;
begin
  Result := nil;
  if not Assigned(m_WarpList) then exit;

  if LastIndexChecked < 0 then
    StartIndex := m_WarpList.FindCovering(startTm, endTm, nil)
  else
    StartIndex := LastIndexChecked + 1;

  if StartIndex <> -1 then
  begin
    for i := StartIndex to m_WarpList.Count -1 do
    begin
      LastIndexChecked := i;
      Warp := TMqmWarp(m_WarpList.p_sons[i]);
      if Warp.p_start >= endTm then exit;
      if Warp.p_end <= StartTm then Continue;
      begin
        Result := Warp;
        break
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

function TMqmActArea.FindWarpCovering(Start : TDateTime ;skipObj: TMqmDurObj) : TMqmDurObj;
var
  Index : Integer;
  Warp  : TMqmWarp;
begin
  Result := nil;
  if Assigned(m_WarpList) then
  begin
    Index := m_WarpList.FindCoveringForSpot(Start, skipObj);
    if Index < 0 then exit;
    result := TMqmWarp(m_WarpList.p_sons[Index]);
  end;
end;

//----------------------------------------------------------------------------//

function TMqmActArea.FindNonCrossingDwTime(startTm, endTm: TDateTime; var LastIndexChecked : integer; Id : TSchedId; MaxCaseAllowedCapRes : integer): TMqmDurObj;
var
  StartIndex, i: integer;
  CapRes: TMqmCapRes;
  CompVal : TCompatVal;
begin
  Result := nil;
  if not Assigned(m_CapResList) then exit;

  if LastIndexChecked < 0 then
    StartIndex := m_CapResList.FindCovering(startTm, endTm, nil)
  else
    StartIndex := LastIndexChecked + 1;

  if StartIndex <> -1 then
  begin
    for i := StartIndex to m_CapResList.Count -1 do
    begin
      LastIndexChecked := i;
      CapRes := TMqmCapRes(m_CapResList.p_sons[i]);
      if CapRes.p_start >= endTm then exit;
      if CapRes.p_end <= StartTm then Continue;
      if (CapRes.m_Type = cr_Normal) or (CapRes.m_Type = Cr_Dynamic) then
      begin
        CompVal := TMqmRes(CapRes.p_Res).CheckCompIDCapRes(id, capRes);
        if (CompVal = CompValNotComp) or (CompVal > MaxCaseAllowedCapRes) or (not CapRes.CheckUpMostCase(CompVal)) then
        begin
          Result := CapRes;
          exit;
        end;
      end;
      if (CapRes.m_Type <> cr_DownTime) and (CapRes.m_Type <> Cr_DummyDtm) then continue;
      Result := CapRes;
      exit;
    end;
  end;
end;


//----------------------------------------------------------------------------//
function TMqmActArea.FindMaxCaseCapRes(startTm, endTm: TDateTime; Id : TSchedId) : integer;
//----------------------------------------------------------------------------//

var
  StartIndex, i: integer;
  CapRes: TMqmCapRes;
  CompVal : TCompatVal;
begin
  Result := 0;
  if not Assigned(m_CapResList) then exit;
  StartIndex := m_CapResList.FindCovering(startTm, endTm, nil);
  if (StartIndex = -1) then exit;

  for i := StartIndex to m_CapResList.Count -1 do
  begin
    CapRes := TMqmCapRes(m_CapResList.p_sons[i]);
    if CapRes.p_start >= endTm then exit;
    if CapRes.p_end <= StartTm then Continue;
    if (CapRes.m_Type <> cr_Normal) and (CapRes.m_Type <> Cr_Dynamic) then  continue;
    CompVal := TMqmRes(CapRes.p_Res).CheckCompIDCapRes(id, capRes);
    if (CompVal > Result) then
      result := CompVal;
  end;

end;


//----------------------------------------------------------------------------//
{
function TMqmActArea.IsCrosDwTimeCovering(startTm : TDateTime ; var NewStart : TDateTime) : boolean;
var
  StartIndex, i: integer;
  CapRes : TMqmCapRes;
begin
  Result := false;
  if not Assigned(m_CapResList) then exit;
  StartIndex := m_CapResList.FindCoveringForSpot(startTm, nil);

  if (StartIndex = -1) then
    Exit
  else
  begin
    for i := StartIndex to m_CapResList.Count -1 do
    begin
      CapRes := TMqmCapRes(m_CapResList.p_sons[i]);
      if (CapRes.m_Type = Cr_CrossingDtm) then
      begin
        if (startTm >= CapRes.p_start) and (startTm <= CapRes.p_End) then
        begin
          Result := true;
          NewStart := CapRes.p_End;
          Exit;
        end;
      end;
    end;
  end;
end;
}
//----------------------------------------------------------------------------//

procedure TMqmActArea.ClearMoveBackup;
var
  i: integer;
  CapRes: TMqmCapRes;
begin
  if not assigned(m_CapResList) then exit;

  for i := 0 to m_CapResList.Count -1 do
  begin
    CapRes := TMqmCapRes(m_CapResList.p_sons[i]);
    CapRes.m_bkStart := 0;
    CapRes.m_bkDur := 0;
  end;
end;


//----------------------------------------------------------------------------//

{procedure TMqmActArea.CleaningCrossFlag;
var
  I : Integer;
  CrossDwTime : TMqmDurObj;
begin
  if Assigned(m_CapResList) and (m_CapResList.Count > 0) then
    for I := 0 to m_CapResList.Count -1 do
    begin
      CrossDwTime := TMqmCapRes(m_CapResList.p_sons[i]);
      if (TMqmCapRes(CrossDwTime).m_Type = Cr_CrossingDtm) then
         TMqmCapRes(CrossDwTime).m_Cros := false;
    end;
end; }

//----------------------------------------------------------------------------//

function TMqmActArea.ReattachObjsForReorg(ObjToMove: TSchedID;
                                           LastEndDate: TDateTime;
                                           isLastObj : boolean;
                                           out DeltaSetupObjToMove: double;
                                           var OptsMover: SetOptsMover;
                                           CheckTotalComponents : boolean) : CScMovementResult;
var
//  OrigEnd,
  NewEndDate,
  MaxEndDate, NewStartDate:    TDateTime;
  planInfo, TmpPlanInfo:  TSQplanInfo;
  DatesInfo:     TSQDatesInfo;
  OldMarkStack:  TStackMark;
  TmpDeltaSetup: double;
  Cal:           TPGCALObj;
//  DummySetUp, DummyOverlap : double;
  Teoreticl_wc : string;
  Dur, leadTime :double;
  vsupMinReal, vsupMinOvlp : double;
  compatVal: TCompatVal;
  Res : TMqmRes;
  WCCode, ResCatCode, ResCode : string;
  Duration, Setup, CurveTime : double;
  PrevId, PrevIdTemp, NextId, DammyId : TSchedID;
  IdIndex : integer;
  DwTime, Warp : TMqmDurObj;
begin
  Result := CSM_Yes;
  Cal := GetCalendar;
  p_sc.GetPlanInfo(ObjToMove, planInfo);
  if p_sc.P_ReorganizeAllEnd then
    SortSchedObjs;

  Res := TMqmRes(self.p_res);
  ResCode := Res.p_ResCode;
  if Assigned(Res) then
  begin
    ResCatCode := Res.p_ResCat.p_ResCatCode;
    WCCode     := TMqmWrkCtr(Res.p_WrkCtr).p_WrkCtrCode;
  end;
  p_sc.GetIdTimes(ObjToMove, WCCode, ResCatCode, ResCode, false, Duration, Setup,true);

  //Duration := Duration / p_sc.GetJobComponents(ObjToMove, true); // avi 03/03/2026

  if LastEndDate > planInfo.StartDate then
  begin
    PlanInfo.StartDate := LastEndDate;
  end;

  repeat

    PrevId := GetPrecObj(planInfo.startDate, ObjToMove);

    while True do
    begin

      UpdateInstanceCounterProperty(ObjToMove, PrevId);

      planInfo.supMinBase := setup;

      CalcSetupForReattach(ObjToMove, PrevId, self, compatVal, PlanInfo.supMinBase, vsupMinReal, vsupMinOvlp,
              Teoreticl_wc, Dur, leadTime);
      if (GetOccMoveForm <> nil) and (compatVal = 99) then
      begin
        Result := CSM_Not_Compatible;
        Exit;
      end;

      CurveTime := GetCurveTime(self, planInfo.startDate, ObjToMove , duration, true, 0);

      PlanInfo.exeMin := Duration + CurveTime;

      cal.OfsByWH((vsupMinReal + Duration + CurveTime)/60, true, planInfo.startDate, planInfo.endDate, m_CrossDownTmList);

      NewStartDate := planInfo.startDate;
      if Res.p_ONE_BATCH_MACHINE_By_GROUP_CODE then
        Res.CheckDatesOnOneBatchMachineByGroupCode(ObjToMove, planInfo, NewStartDate);

      if NewStartDate <> planInfo.startDate then
      begin
        planInfo.startDate := NewStartDate;
        cal.OfsByWH((vsupMinReal + Duration + CurveTime)/60, true, planInfo.startDate, planInfo.endDate, m_CrossDownTmList);
        PrevIdTemp := GetPrecObj(planInfo.startDate, ObjToMove);
        if PrevIdTemp <> PrevId then
        begin
          PrevId := PrevIdTemp;
          Continue;
        end;
      end;

      NewStartDate := planInfo.startDate;
      DwTime := FindDwTimeCovering(planInfo.startDate, planInfo.endDate, ObjToMove);
      if assigned(DwTime) and not (TMqmCapRes(DwTime).m_Type = Cr_CrossingDtm) then
        NewStartDate := DwTime.p_end;

      if Assigned(p_Res) and TMqmRes(p_Res).p_isMultiRes and CheckTotalComponents then
        NewStartDate := CheckDateOnSubResources(self, ObjToMove, NewStartDate, planInfo);

      if NewStartDate <> planInfo.startDate then
      begin
        planInfo.startDate := NewStartDate;
        cal.OfsByWH((vsupMinReal + Duration + CurveTime)/60, true, planInfo.startDate, planInfo.endDate, m_CrossDownTmList);
        PrevIdTemp := GetPrecObj(planInfo.startDate, ObjToMove);
        if PrevIdTemp <> PrevId then
        begin
          PrevId := PrevIdTemp;
          Continue;
        end;
      end;

    {  Warp := FindWarpCovering(planInfo.startDate, planInfo.endDate, CSchedIDnull);
      if assigned(Warp) and not p_sc.CheckItemAndProductForWarp(TMqmWarp(Warp).Get_M_id, PrevId, false, DammyId) then
        NewStartDate := Warp.p_end;

      if NewStartDate <> planInfo.startDate then
      begin
        planInfo.startDate := NewStartDate;
        cal.OfsByWH((vsupMinReal + Duration + CurveTime)/60, true, planInfo.startDate, planInfo.endDate, m_CrossDownTmList);
        PrevIdTemp := GetPrecObj(planInfo.startDate, ObjToMove);
        if PrevIdTemp <> PrevId then
        begin
          PrevId := PrevIdTemp;
          Continue;
        end;
      end;   }

      IdIndex := p_sc.FindCovering(planInfo.startDate, planInfo.endDate, ObjToMove, m_SchedObjs, false);
      if IdIndex >= 0 then
      begin
        PrevId := GetSchedObj(IdIndex);
        p_sc.GetPlanInfo(PrevId, TmpPlanInfo);
        planInfo.startDate := TmpPlanInfo.endDate;
        continue;
      end;

      break;

    end;

    p_sc.P_DoNotCalcMatBalance := true;

    if not p_sc.P_ReorganizeAllEnd and planInfo.GenericPlan then
      ScheduleOnBestPosition(ObjToMove, planInfo, planInfo.startDate , Teoreticl_wc, Dur, leadTime, false);

    p_opStack.LinkOccToApa(ObjToMove, self);
    p_opStack.ChgOccDurData(ObjToMove, planInfo);
//      p_sc.UpdateSetup(ObjToMove, TmpDeltaSetup, true);

    p_sc.GetDatesInfo(ObjToMove, DatesInfo);

    MaxEndDate := DatesInfo.HighEndDate;
    if (DatesInfo.MaxOvlpDate > 0) and (DatesInfo.MaxOvlpDate < DatesInfo.HighEndDate) then
      MaxEndDate := DatesInfo.MaxOvlpDate;

    planInfo.supMinReal := vsupMinReal;
    planInfo.supMinOvlp := vsupMinOvlp;
    cal.OfsByWH((planInfo.supMinReal + planInfo.exeMin)/60, true, planInfo.startDate, planInfo.endDate, m_CrossDownTmList);
    NewEndDate := PlanInfo.endDate;
//    p_sc.CalcNewSetupData(ObjToMove, NewEndDate);

  {  if (NewEndDate > DatesInfo.endDate)
      and ((DatesInfo.endDate > MaxEndDate)
        or (NewEndDate > MaxEndDate)) then   }
    if (DatesInfo.endDate <= MaxEndDate) and (NewEndDate > MaxEndDate) then
    begin
      OldMarkStack := p_opStack.MarkStack;
      p_sc.UpdateSetup(ObjToMove, TmpDeltaSetup, false);
      p_sc.GetDatesInfo(ObjToMove, DatesInfo);

      if p_sc.P_ReorganizeAllEnd then
        SortSchedObjs;
      if (p_sc.FindCovering(DatesInfo.startDate, DatesInfo.endDate, ObjToMove, m_SchedObjs, false) >= 0) or
         (DatesInfo.startDate < DatesInfo.MinOvlpDate) then
      begin
        p_opStack.UndoTo(OldmarkStack);
        p_sc.UpdateSetup(ObjToMove, TmpDeltaSetup, true);
        p_sc.GetDatesInfo(ObjToMove, DatesInfo);
      end
    end else
      p_sc.UpdateSetup(ObjToMove, TmpDeltaSetup, true);

//    p_sc.UpdateBalance(ObjToMove);

    if TmpDeltaSetup <= 0 then   //  avi for isko 18/august 2011 (old TmpDeltaSetup = 0);
      Break
    else
    begin
      if isLastObj then
        DeltaSetupObjToMove := TmpDeltaSetup;

      p_sc.GetPlanInfo(ObjToMove, planInfo);
      p_opStack.DetachOccFromApa(ObjToMove, self);
      p_sc.GetPlanInfo(ObjToMove, planInfo);
    end;

  until false;

  if planInfo.isGroup and (planInfo.stepType = CST_Continuous) then
    UpdContGrpTimings(ObjToMove, ObjToMove);

  p_sc.P_DoNotCalcMatBalance := false;
  p_sc.UpdateBalance(ObjToMove);

  NextId := GetNextObj(planInfo.startDate, ObjToMove);
  if NextId <> CSchedIDnull then
  begin
    p_sc.GetPlanInfo(NextId, planInfo);
    if planInfo.isGroup and (planInfo.stepType = CST_Continuous) then
    begin
      if (CProgress(p_sc.IsProgressed(NextId)) = prg_Starting)
      or (CProgress(p_sc.IsProgressed(NextId)) = prg_General) then
        UpdContGrpTimings(NextId, NextId);
    end;
  end;

end;

//----------------------------------------------------------------------------//

procedure TMqmActArea.ReorganizeWarpMain(ReorgFromDate : TDateTime; OnStart : boolean);
var
  BaseReorgPushedJobs, SecondReorgPushedJobs : boolean;
begin
  if not DBAppGlobals.IsWarpHandled then exit;
  if p_warpCount = 0 then exit;
  if OnStart then SortWarp;

  while true do
  begin
    BaseReorgPushedJobs := ReorganizeWarp(ReorgFromDate, OnStart, MT_BaseLvl);
    SecondReorgPushedJobs := ReorganizeWarp(ReorgFromDate, OnStart, MT_SecondLvl);

    if (not BaseReorgPushedJobs) and (not SecondReorgPushedJobs) then
      break
  end;

end;

//----------------------------------------------------------------------------//

function TMqmActArea.ReorganizeWarp(ReorgFromDate : TDateTime; OnStart : boolean; warp_level : ArMaterialScheduleLvl) : boolean;
var
  I, J : integer;
  Warp : TMqmWarp;
  ObjToReorgList:     TList;
  IdToMove :  TSchedID;
  WarpInfoRec, WarpReSched : PWarpInfo;
  WarpInfo: TPWarpInfo;
  OrigStartDate, StartDate, WarpEndDate, DateToStartFrom, SchedStart : TDateTime;
  SetUpMins, DummyQty : double;
  Cal       : TPGCALObj;
  ObjToCheck : TMSchedList;
  ID, DummyId : TSchedId;
  duration, RemainQty, MatQtyRequired, SetUp : double;
  MovementResult : CScMovementResult;
begin
  Result := false;

  ObjToReorgList := TList.Create;

  for I := m_WarpList.Count - 1 downto 0 do
  begin
    Warp := TMqmWarp(GetWarp(I));
   // if Warp.p_end <= DBAppGlobals.StDateForPlan then break;
   // if not OnStart then

    if (not OnStart) and (Warp.p_end <= ReorgFromDate) then break;
    IdToMove := Warp.Get_M_id;
    p_sc.GetWarpInfo(IdToMove, WarpInfo);
    if WarpInfo.warp_levl <> warp_level then continue;
    new(WarpInfoRec);
    WarpInfoRec^ := WarpInfo;
    WarpInfoRec.Id := IdToMove;
    ObjToReorgList.Add(WarpInfoRec);
    DateToStartFrom := WarpInfoRec.startDate;
    p_opStack.DetachPlanObjFromApa(TMqmWarp(Warp));
  end;

  Cal := GetCalendar;

  ObjToCheck := TMSchedList.Create(self);

  for i := ObjToReorgList.Count - 1 downto 0 do
  begin
    WarpReSched := PWarpInfo(ObjToReorgList[I]);
    OrigStartDate := WarpReSched.startDate;
    if OrigStartDate < DateToStartFrom then
       OrigStartDate := DateToStartFrom;

    if WarpReSched.MATERIAL_Overriden_Setup_Time > 0 then
      SetUpMins := WarpReSched.MATERIAL_Overriden_Setup_Time
    else
      SetUpMins := WarpReSched.Standard_Setup;

    RemainQty := WarpReSched.quant;
    duration := 0;
    startDate := OrigStartDate;
    SetUp := SetUpMins;
    CalculateWarpDurationForeward(WarpReSched.Id, self, StartDate, duration, SetUp, RemainQty, false);

    Cal.OfsByWH((duration)/60, true, OrigStartDate, WarpEndDate, m_CrossDownTmList);

    ObjToCheck.ClearList;
    FindSchedInSpots(OrigStartDate, WarpEndDate, ObjToCheck);

    J := ObjToCheck.GetLinkCount;

    while j > 0 do
    begin
      dec(j);
      ID := ObjToCheck.GetLink(J);
      if not p_sc.CheckItemAndProductForWarp(WarpReSched.Id ,id, false, DummyId, MatQtyRequired) then
      begin
        if p_sc.CanDetach(id, nil, false) then
        begin
          MovementResult := ReorganizeAllOccForWarp(id, WarpEndDate);
          Result         := true;
        end
        else
          MovementResult := CSM_No;
        if MovementResult = CSM_yes then break;

        OrigStartDate := p_sc.GetSchedEnd(Id);
        RemainQty := WarpReSched.quant;
        duration  := 0;
        startDate := OrigStartDate;
        SetUp := SetUpMins;
        CalculateWarpDurationForeward(WarpReSched.Id, self, StartDate, duration, SetUp, RemainQty, false);
        Cal.OfsByWH((duration)/60, true, OrigStartDate, WarpEndDate, m_CrossDownTmList);
        ObjToCheck.ClearList;
        FindSchedInSpots(OrigStartDate, WarpEndDate, ObjToCheck);
        J := ObjToCheck.GetLinkCount;
      end;
    end;

    if WarpReSched.warp_levl = MT_BaseLvl then
      Warp := TMqmWarp.CreateWarp(WarpReSched.Id, WarpReSched.quant, MT_BaseLvl, WarpReSched.IsWarpLinkedToRequest)
    else if WarpReSched.warp_levl = MT_SecondLvl then
      Warp := TMqmWarp.CreateWarp(WarpReSched.Id, WarpReSched.quant, MT_SecondLvl, WarpReSched.IsWarpLinkedToRequest);

   // Warp.m_status := CDUR_none;

    Warp.p_durDouble := duration - SetUpMins;
    Warp.p_start := OrigStartDate;
    Warp.p_end   := WarpEndDate;


    p_opStack.LinkPlanObjToApa(Warp, self);
    p_opStack.ChgPlanObjDurData(Warp);
    p_sc.SetExtLinkPtr_Material(WarpReSched.Id, self);
    p_sc.SetWarpSchedData(WarpReSched.Id, Warp.p_start,  Warp.p_end, WarpReSched.Resource);

    DateToStartFrom := Warp.p_end;
    if OnStart then
      Warp.m_status := CDUR_none
    else
      Warp.m_status := CDUR_modi;
  end;

  for I := ObjToReorgList.Count -1 downto 0 do
     Dispose(PWarpInfo(ObjToReorgList[I]));
  ObjToReorgList.Clear;
  ObjToReorgList.free;

  ObjToCheck.Free;
end;

//----------------------------------------------------------------------------//

function TMqmActArea.ReorganizeOcc(RefObjID: TSchedID; CheckMaterial: boolean;
                                   out OptsMover: SetOptsMover;
                                   out DeltaSetupObjToMove: double; ErrList: TStringList; DateToOrganizeWarpFrom : TDateTime): CScMovementResult;
var
  planInfo,planInfoCurr : TSQplanInfo;
  DatesInfo:          TSQDatesInfo;
  StartIndex:         integer;
  ObjToMove, idCorr, DammyId:  TSchedID;
  LastEndDate,
  OrigStart,
  OrigEnd:            TDateTime;
  i:                  integer;
  Cal:                TPGCALObj;
  ObjToReorgList:     TList;
  TmpCheckPosResult, CheckPosResult :  CScMovementResult;
  bGrp:               boolean;
  sMsg:               string;
  DwTime, Warp:     TMqmDurObj;
  LastIndexChecked : integer;
  SavedOrigStartDate : TDateTime;
begin

  Result := CSM_Yes;
  DeltaSetupObjToMove := 0;

  if (not assigned(m_SchedObjs) or (m_SchedObjs.GetLinkCount <= 0)) and (p_warpCount = 0) then
    exit;

  Cal := GetCalendar;

  SortSchedObjs;  //m_SchedObjs.SortList(OrderGrowing);
  p_sc.GetPlanInfo(RefObjID, planInfo);
  SavedOrigStartDate := DateToOrganizeWarpFrom;
  if planInfo.startDate < DateToOrganizeWarpFrom then
     SavedOrigStartDate := planInfo.startDate;

//  OrigStart := planInfo.startDate;

  // check if the RefObjID is overlapping a downtime
  LastIndexChecked := -1;

  repeat
    DwTime := FindNonCrossingDwTime(planInfo.startDate, planInfo.endDate, LastIndexChecked, RefObjID, 99);
    if assigned(DwTime) then
    begin
      planInfo.startDate := DwTime.p_end;
      cal.OfsByWH((planInfo.supMinReal + planInfo.exeMin)/60, true, planInfo.startDate, planInfo.endDate, m_CrossDownTmList);
      p_opStack.ChgOccDurData(RefObjID, planInfo);
    end;

  until (DwTime = nil);

  if p_sc.P_ReorganizeAllEnd then
   SortSchedObjs;

  StartIndex := p_sc.FindCovering(planInfo.startDate, planInfo.endDate, RefObjID, m_SchedObjs, true);
  if StartIndex < 0 then
  begin
    ObjToMove := GetNextObj(planInfo.startDate, RefObjID);
    StartIndex := m_SchedObjs.IndexOf(ObjToMove)
  end;
  if StartIndex < 0 then
  begin
    ReorganizeWarpMain(SavedOrigStartDate, false);
    exit;
  end;

  //Create a list of objects to be reorganized
  ObjToReorgList := TList.Create;
  for i := m_SchedObjs.GetLinkCount-1 downto StartIndex do
  begin
    ObjToMove := m_SchedObjs.GetLink(i);
    if (ObjToMove <> RefObjID)
    and p_sc.CanDetach(ObjToMove, nil, false) then
    begin
      ObjToReorgList.Add(Pointer(ObjToMove));
      p_sc.P_DoNotSortScheduled := true;
      p_opStack.DetachOccFromApa(ObjToMove, self);
      p_sc.P_DoNotSortScheduled := false;
    end
  end;

  if p_sc.P_ReorganizeAllEnd then
     SortSchedObjs;

  if p_sc.FindCovering(planInfo.startDate, planInfo.endDate, RefObjID, m_SchedObjs, true) <> -1 then
  begin
    Result := CSM_No;
    exit;
  end;

  // handle the groups
  if planInfo.isGroup then
  begin
    if (planInfo.stepType <> CST_batch) then
      UpdContGrpTimings(RefObjID, RefObjID)
    else
      // handle batch jobs
      for i := 0 to p_sc.GetGrpNumSons(RefObjID)-1 do
      begin
        idCorr := p_sc.GetGrpSon(RefObjID, i);
        p_sc.GetPlanInfo(idCorr, planInfoCurr);
        planInfoCurr.supMinReal := planInfo.supMinReal;
        planInfoCurr.supMinOvlp := planInfo.supMinOvlp;
        planInfoCurr.exeMin     := planInfo.exeMin;
        planInfoCurr.startDate  := planInfo.startDate;
        planInfoCurr.endDate    := planInfo.endDate;
     //   planInfoCorr.TmgDescr   := TmgDescr;
     //   planInfoCorr.TmgDescr   := TmgMSC;
        p_opStack.ChgOccDurData(idCorr, planInfoCurr);
      end;
  end
  else
    p_opStack.ChgOccDurData(RefObjID, planInfo);

  p_sc.GetPlanInfo(RefObjID, planInfo);

  LastEndDate := planInfo.endDate;
  DeltaSetupObjToMove := 0;

  //Attach the object do be reorgamized
  for i := ObjToReorgList.Count-1 downto 0 do
  begin
    ObjToMove := TSchedId(ObjToReorgList.Items[i]);
    p_sc.GetPlanInfo(ObjToMove, planInfo);

    OrigStart := planInfo.startDate;
    OrigEnd := planInfo.EndDate;

    CheckPosResult := ReattachObjsForReorg(ObjToMove, LastEndDate, (i = ObjToReorgList.Count-1),
                         DeltaSetupObjToMove, OptsMover, true);
    if CheckPosResult = CSM_Not_Compatible then
    begin
      Result := CheckPosResult;
      exit;
    end;

    p_opStack.UpdateBalance(ObjToMove);
    p_sc.GetPlanInfo(ObjToMove, planInfo);
    p_opStack.UpdateOvlpLimits(ObjToMove, nil);
    p_sc.GetDatesInfo(ObjToMove, DatesInfo);

    if (planInfo.endDate > OrigEnd) then
    begin
      p_opStack.ChgOccDurData(ObjToMove, planInfo);
      if planInfo.isGroup then
      begin
      if (planInfo.stepType <> CST_batch) then
        UpdContGrpTimings(ObjToMove, RefObjID)
      end;
      Include(OptsMover, OM_ObjsMoved);

      if p_sc.GetSchedType(ObjToMove) = '1' then
        Include(OptsMover, OM_InitialObjsMoved);

      if p_sc.GetSchedType(ObjToMove) = '2' then
        Include(OptsMover, OM_FinalObjsMoved);

      if p_sc.GetSchedType(ObjToMove) = '4' then
        Include(OptsMover, OM_Level1ObjsMoved);

      if p_sc.GetSchedType(ObjToMove) = '5' then
        Include(OptsMover, OM_Level2ObjsMoved);

      if p_sc.GetSchedType(ObjToMove) = '6' then
        Include(OptsMover, OM_Level3ObjsMoved);

      if p_sc.GetSchedType(ObjToMove) = '7' then
        Include(OptsMover, OM_Level4ObjsMoved);

      if p_sc.GetSchedType(ObjToMove) = '8' then
        Include(OptsMover, OM_Level5ObjsMoved);

      if (DatesInfo.endDate > DatesInfo.HighEndDate) then
        Include(OptsMover, OM_ObjsMovedUpToLatest);

{$ifdef ARO}
      if (DatesInfo.endDate > DatesInfo.DeliveryDate)
      and (p_sc.GetSchedType(ObjToMove) <> '5') then
{$else}
      if (DatesInfo.endDate > DatesInfo.HighEndDate) then //DatesInfo.DeliveryDate) then
{$endif}
      begin
        Include(OptsMover, OM_ObjsDelayed);

        if Assigned(ErrList) then
        begin
          sMsg := _('is in delay');
          if planInfo.FrcDelDate > CSF_No then
            sMsg := sMsg + ' ' + _('and need to be forced');

          Errlist.Add(p_sc.GetObjBarText(ObjToMove, bGrp, True,0) + ' ' + sMsg );
        end;
      end;

      // Overlap
      if (DatesInfo.MaxOvlpDate > 0)
      and (DatesInfo.endDate > DatesInfo.MaxOvlpDate)then
      begin
        Include(OptsMover, OM_ObjsOverlapped);
        if Assigned(ErrList) then
        begin
          sMsg := _('overlaps next step');
          Errlist.Add(p_sc.GetObjBarText(ObjToMove, bGrp, True,0) + ' ' + sMsg );
        end;
      end;
    end;

    // Overlap
    if  (DatesInfo.startDate < OrigStart)
    and (DatesInfo.MinOvlpDate > 0)
    and (DatesInfo.startDate < DatesInfo.MinOvlpDate) then
    begin
      Include(OptsMover, OM_ObjsOverlapped);
      if Assigned(ErrList) then
      begin
        sMsg := _('overlaps previous step');
        Errlist.Add(p_sc.GetObjBarText(ObjToMove, bGrp, True,0) + ' ' + sMsg );
      end;
    end;

    if (DatesInfo.startDate <> OrigStart) or (planInfo.endDate <> OrigEnd) then
    begin
      p_sc.SetOvlpLimitsFlag(ObjToMove, false);
    end;

    // Materials
    if not p_sc.CheckEnoughMaterial(ObjToMove, [Ar_MatWithDet, Ar_Material]) then
    begin
      Include(OptsMover, OM_ObjsMaterials);//      NoMaterials := True;

      if Assigned(ErrList) then
        Errlist.Add(p_sc.GetObjBarText(ObjToMove, bGrp, True,0) + ' ' + _('does not have enough materials') );
    end;
    if not p_sc.CheckEnoughMaterial(ObjToMove, [Ar_AddRes, Ar_AddRes_ManPower,Ar_AddRes_Capacity])  then
    begin
      Include(OptsMover, OM_ObjsAddRes);  //      NoAddRes := True;

      if Assigned(ErrList) then
        Errlist.Add(p_sc.GetObjBarText(ObjToMove, bGrp, True,0) + ' ' + _('does not have enough additional resources') );
    end;

    LastEndDate := DatesInfo.endDate;

    if DatesInfo.endDate > OrigEnd then
    begin
      TmpCheckPosResult := p_sc.CheckPosition(ObjToMove, nil);
      if Result > TmpCheckPosResult then
        Result := TmpCheckPosResult;
    end;
  end;
 // p_pl.SetTmgMainID(RefObjID);

  ObjToReorgList.Clear;
  ObjToReorgList.Free;

  ReorganizeWarpMain(SavedOrigStartDate, false);
end;

//----------------------------------------------------------------------------//

function TMqmActArea.ReorganizeOccForUnsched(RefObjID: TSchedID; CheckMaterial: boolean;
                                   out OptsMover: SetOptsMover;
                                   out DeltaSetupObjToMove: double; ErrList: TStringList): CScMovementResult;
var
  planInfo,planInfoCurr : TSQplanInfo;
  DatesInfo:          TSQDatesInfo;
  StartIndex:         integer;
  ObjToMove, idCorr:  TSchedID;
  LastEndDate,
  OrigStart,
  OrigEnd:            TDateTime;
  i:                  integer;
  Cal:                TPGCALObj;
  ObjToReorgList:     TList;
  TmpCheckPosResult:  CScMovementResult;
  bGrp:               boolean;
  sMsg:               string;
  DwTime:     TMqmDurObj;
  LastIndexChecked : Integer;
  SavedOrigStartDate : TDateTime;
begin

  Result := CSM_Yes;
  DeltaSetupObjToMove := 0;

  if not assigned(m_SchedObjs) or (m_SchedObjs.GetLinkCount <= 0) then
    exit;

  Cal := GetCalendar;
  SortSchedObjs;  //m_SchedObjs.SortList(OrderGrowing);
  p_sc.GetPlanInfo(RefObjID, planInfo);

  SavedOrigStartDate := planInfo.startDate;

  // check if the RefObjID is overlapping a downtime
  LastIndexChecked := -1;
  repeat
    DwTime := FindNonCrossingDwTime(planInfo.startDate, planInfo.endDate, LastIndexChecked, RefObjID, 99);
    if assigned(DwTime) then
    begin
      planInfo.startDate := DwTime.p_end;
      cal.OfsByWH((planInfo.supMinReal + planInfo.exeMin)/60, true, planInfo.startDate, planInfo.endDate, m_CrossDownTmList);
      p_opStack.ChgOccDurData(RefObjID, planInfo);
    end;
  until DwTime = nil;

  if p_sc.P_ReorganizeAllEnd then
     SortSchedObjs;
  StartIndex := p_sc.FindCovering(planInfo.startDate, planInfo.endDate, RefObjID, m_SchedObjs, false);
  if StartIndex < 0 then
  begin
    ObjToMove := GetNextObj(planInfo.startDate, RefObjID);
    StartIndex := m_SchedObjs.IndexOf(ObjToMove)
  end;
  if StartIndex < 0 then
  begin
    ReorganizeWarpMain(SavedOrigStartDate, false);
    exit;
  end;

  //Create a list of objects to be reorganized
  ObjToReorgList := TList.Create;
  for i := m_SchedObjs.GetLinkCount-1 downto StartIndex do
  begin
    ObjToMove := m_SchedObjs.GetLink(i);
    if (ObjToMove <> RefObjID)
    and p_sc.CanDetach(ObjToMove, nil, false) then
    begin
      ObjToReorgList.Add(Pointer(ObjToMove));
      p_opStack.DetachOccFromApa(ObjToMove, self);
    end
  end;

  // handle the groups
  if planInfo.isGroup then
  begin
    if (planInfo.stepType <> CST_batch)  then
      UpdContGrpTimings(RefObjID, RefObjID)
    else
      // handle batch jobs
      for i := 0 to p_sc.GetGrpNumSons(RefObjID)-1 do
      begin
        idCorr := p_sc.GetGrpSon(RefObjID, i);
        p_sc.GetPlanInfo(idCorr, planInfoCurr);

        planInfoCurr.supMinReal := planInfo.supMinReal;
        planInfoCurr.supMinOvlp := planInfo.supMinOvlp;
        planInfoCurr.exeMin     := planInfo.exeMin;
        planInfoCurr.startDate  := planInfo.startDate;
        planInfoCurr.endDate    := planInfo.endDate;
     //   planInfoCorr.TmgDescr   := TmgDescr;
     //   planInfoCorr.TmgDescr   := TmgMSC;
        p_opStack.ChgOccDurData(idCorr, planInfoCurr);
      end;
  end
  else
    p_opStack.ChgOccDurData(RefObjID, planInfo);

  p_sc.GetPlanInfo(RefObjID, planInfo);

  LastEndDate := planInfo.endDate;
  DeltaSetupObjToMove := 0;

  //Attach the object do be reorgamized
  for i := ObjToReorgList.Count-1 downto 0 do
  begin
    ObjToMove := TSchedId(ObjToReorgList.Items[i]);
    p_sc.GetPlanInfo(ObjToMove, planInfo);

    OrigStart := planInfo.startDate;
    OrigEnd := planInfo.EndDate;

    ReattachObjsForReorg(ObjToMove, LastEndDate, (i = ObjToReorgList.Count-1),
                         DeltaSetupObjToMove, OptsMover, true);

    p_opStack.UpdateBalance(ObjToMove);
    p_sc.GetPlanInfo(ObjToMove, planInfo);
    p_opStack.UpdateOvlpLimits(ObjToMove, nil);
    p_sc.GetDatesInfo(ObjToMove, DatesInfo);

    if (planInfo.endDate > OrigEnd) then
    begin
      p_opStack.ChgOccDurData(ObjToMove, planInfo);
      Include(OptsMover, OM_ObjsMoved);

      if p_sc.GetSchedType(ObjToMove) = '1' then
        Include(OptsMover, OM_InitialObjsMoved);

      if p_sc.GetSchedType(ObjToMove) = '2' then
        Include(OptsMover, OM_FinalObjsMoved);

      if p_sc.GetSchedType(ObjToMove) = '4' then
        Include(OptsMover, OM_Level1ObjsMoved);

      if p_sc.GetSchedType(ObjToMove) = '5' then
        Include(OptsMover, OM_Level2ObjsMoved);

      if p_sc.GetSchedType(ObjToMove) = '6' then
        Include(OptsMover, OM_Level3ObjsMoved);

      if p_sc.GetSchedType(ObjToMove) = '7' then
        Include(OptsMover, OM_Level4ObjsMoved);

      if p_sc.GetSchedType(ObjToMove) = '8' then
        Include(OptsMover, OM_Level5ObjsMoved);

      if (DatesInfo.endDate > DatesInfo.HighEndDate) then
        Include(OptsMover, OM_ObjsMovedUpToLatest);

{$ifdef ARO}
      if (DatesInfo.endDate > DatesInfo.DeliveryDate)
      and (p_sc.GetSchedType(ObjToMove) <> '5') then
{$else}
      if (DatesInfo.endDate > DatesInfo.DeliveryDate) then
{$endif}
      begin
        Include(OptsMover, OM_ObjsDelayed);

        if Assigned(ErrList) then
        begin
          sMsg := _('is in delay');
          if planInfo.FrcDelDate > CSF_No then
            sMsg := sMsg + ' ' + _('and need to be forced');

          Errlist.Add(p_sc.GetObjBarText(ObjToMove, bGrp, True,0) + ' ' + sMsg );
        end;
      end;

      // Overlap
      if (DatesInfo.MaxOvlpDate > 0)
      and (DatesInfo.endDate > DatesInfo.MaxOvlpDate)then
      begin
        Include(OptsMover, OM_ObjsOverlapped);
        if Assigned(ErrList) then
        begin
          sMsg := _('overlaps next step');
          Errlist.Add(p_sc.GetObjBarText(ObjToMove, bGrp, True,0) + ' ' + sMsg );
        end;
      end;
    end;

    // Overlap
    if  (DatesInfo.startDate < OrigStart)
    and (DatesInfo.MinOvlpDate > 0)
    and (DatesInfo.startDate < DatesInfo.MinOvlpDate) then
    begin
      Include(OptsMover, OM_ObjsOverlapped);
      if Assigned(ErrList) then
      begin
        sMsg := _('overlaps previous step');
        Errlist.Add(p_sc.GetObjBarText(ObjToMove, bGrp, True,0) + ' ' + sMsg );
      end;
    end;

    if (DatesInfo.startDate <> OrigStart) or (planInfo.endDate <> OrigEnd) then
    begin
      p_sc.SetOvlpLimitsFlag(ObjToMove, false);
    end;

    // Materials
    if not p_sc.CheckEnoughMaterial(ObjToMove, [Ar_MatWithDet, Ar_Material]) then
    begin
      Include(OptsMover, OM_ObjsMaterials);//      NoMaterials := True;

      if Assigned(ErrList) then
        Errlist.Add(p_sc.GetObjBarText(ObjToMove, bGrp, True,0) + ' ' + _('does not have enough materials') );
    end;
    if not p_sc.CheckEnoughMaterial(ObjToMove, [Ar_AddRes, Ar_AddRes_ManPower,Ar_AddRes_Capacity])  then
    begin
      Include(OptsMover, OM_ObjsAddRes);  //      NoAddRes := True;

      if Assigned(ErrList) then
        Errlist.Add(p_sc.GetObjBarText(ObjToMove, bGrp, True,0) + ' ' + _('does not have enough additional resources') );
    end;

    LastEndDate := DatesInfo.endDate;

    if DatesInfo.endDate > OrigEnd then
    begin
      TmpCheckPosResult := p_sc.CheckPosition(ObjToMove, nil);
      if Result > TmpCheckPosResult then
        Result := TmpCheckPosResult;
    end;
  end;

  ObjToReorgList.Clear;
  ObjToReorgList.Free;

  ReorganizeWarpMain(SavedOrigStartDate, false)
end;

//----------------------------------------------------------------------------//

function TMqmActArea.ReorganizeAllOcc(CheckTotalComponents : boolean): CScMovementResult;
var
  planInfo :   TSQplanInfo;
  ObjToMove:  TSchedID;
  i: integer;
  ObjToReorgList: TList;
  DeltaSetupObjToMove : double;
  LastEndDate:   TDateTime;
  OptsMover: SetOptsMover;
begin

  Result := CSM_Yes;

  if not assigned(m_SchedObjs)
  or (m_SchedObjs.GetLinkCount <= 0) then
    exit;
  //Create a list of objects to be reorganized
  ObjToReorgList := TList.Create;
  SortSchedObjs;//m_SchedObjs.SortList(OrderGrowing);

  for i := m_SchedObjs.GetLinkCount-1 downto 0 do
  begin
    Application.ProcessMessages;
    ObjToMove := m_SchedObjs.GetLink(i);
    if p_sc.CanDetach(ObjToMove, nil, true) then
    begin
      ObjToReorgList.Add(Pointer(ObjToMove));
      p_opStack.DetachOccFromApa(ObjToMove, self);
    end else
      p_sc.UpdateBalance(ObjToMove);

  end;

  LastEndDate := 0;

  for i := ObjToReorgList.Count-1 downto 0 do
  begin
    Application.ProcessMessages;
    ObjToMove := TSchedId(ObjToReorgList.Items[i]);
    ReattachObjsForReorg(ObjToMove, LastEndDate, (i = ObjToReorgList.Count-1),
                         DeltaSetupObjToMove, OptsMover, CheckTotalComponents);
    p_sc.GetPlanInfo(ObjToMove, planInfo);
    LastEndDate := planInfo.endDate
  end;

  ObjToReorgList.Free;
end;

//----------------------------------------------------------------------------//

function TMqmActArea.ReorganizeAllOccForWarp(RefObjID: TSchedID; newStartDate : TdateTime) : CScMovementResult;
var
  planInfo :   TSQplanInfo;
  ObjToMove:  TSchedID;
  i: integer;
  ObjToReorgList: TList;
  DeltaSetupObjToMove : double;
  LastEndDate:   TDateTime;
  OptsMover: SetOptsMover;
begin
  Result := CSM_Yes;

  //Create a list of objects to be reorganized
  ObjToReorgList := TList.Create;

  for i := m_SchedObjs.GetLinkCount-1 downto 0 do
  begin
    Application.ProcessMessages;
    ObjToMove := m_SchedObjs.GetLink(i);
    if not p_sc.CanDetach(ObjToMove, nil, true) then
    begin
      Result := CSM_No;
      exit
    end;
    if ObjToMove = RefObjID then break;
  end;

  for i := m_SchedObjs.GetLinkCount-1 downto 0 do
  begin
    Application.ProcessMessages;
    ObjToMove := m_SchedObjs.GetLink(i);
    ObjToReorgList.Add(Pointer(ObjToMove));
    p_opStack.DetachOccFromApa(ObjToMove, self);
    if ObjToMove = RefObjID then break;
  end;

  LastEndDate := newStartDate;

  for i := ObjToReorgList.Count-1 downto 0 do
  begin
    Application.ProcessMessages;
    ObjToMove := TSchedId(ObjToReorgList.Items[i]);
    ReattachObjsForReorg(ObjToMove, LastEndDate, (i = ObjToReorgList.Count-1),
                         DeltaSetupObjToMove, OptsMover, true);
    p_sc.GetPlanInfo(ObjToMove, planInfo);
    LastEndDate := planInfo.endDate
  end;

  SortSchedObjs;
  ObjToReorgList.Free;

end;

//----------------------------------------------------------------------------//

procedure TMqmActArea.ReorganizeAllIgnoredProgress(OnStart : boolean);
var
  PrevId, Id, NextId, SonId, SonIdTemp : TSchedID;
  Index, GrpIndex, I : integer;
  PrevProgInfo, ProgInfo, NextProgInfo : TSQProgInfo;
  SavedStartDate, StartDate, EndDate, PrevProgressEnd, NextStart : TDateTime;
  TempDuration, Duration, Setup, CurveTime, QtyToSched : double;
  TimingInfo:   TSQtimingInfo;
  SchedObjs: TMSchedList;
  ActualEnd, StartSchedule, EndSchedule : variant;
  dataType: CBinColValType;
  Res : TMqmRes;
  OverrideStatus : CProgressIgnor;
  ProgressIgnoredType : CProgressTypeIgnored;
begin
  if not assigned(m_SchedObjs) or (m_SchedObjs.GetLinkCount <= 0) then
    exit;

  SchedObjs := TMSchedList.Create(self);

  Res := TMqmRes(self.p_res);
  if Assigned(Res) and assigned(TMqmWrkCtr(Res.p_WrkCtr)) then
     if not TMqmWrkCtr(Res.p_WrkCtr).P_IgnoreProgress then exit;

  for Index := 0 to m_SchedObjs.GetLinkCount - 1 do
  begin
    Id := m_SchedObjs.GetLink(Index);
    {if not OnStart then
    begin
      if p_sc.IsGroup(Id) then
      begin
        for i := 0 to p_sc.GetGrpNumSons(ID) - 1 do
        begin
          SonId := p_sc.GetGrpSon(ID, i);
          p_sc.GetProgInfo(SonId, ProgInfo);
          if ProgInfo.JobProgSaved then
            p_sc.SaveProgInfoStatus(SonId, true);
        end
      end
      else
      begin
        p_sc.GetProgInfo(Id, ProgInfo);
        if ProgInfo.JobProgSaved then
          p_sc.SaveProgInfoStatus(Id, true);
      end;
    end; }

    p_sc.GetProgInfo(Id, ProgInfo);

    if (ProgInfo.ProgType <> '') then
    begin
      OverrideStatus := p_sc.GetProgressOverrideStatus(id, ProgressIgnoredType);
      if OverrideStatus = Prg_NotIgnored then
      begin
        if p_sc.IsGroup(Id) then
        begin
          for i := 0 to p_sc.GetGrpNumSons(ID) - 1 do
          begin
            SonId := p_sc.GetGrpSon(ID, i);
            p_sc.GetProgInfo(SonId, ProgInfo);
            if (ProgInfo.ProgType <> '') then
              p_sc.SetProgressStatus(SonId, p_pl.PlanLinkJob, false);
          end
        end
        else
          p_sc.SetProgressStatus(Id, p_pl.PlanLinkJob, false);
      end;

    end;

  end;

end;

//----------------------------------------------------------------------------//

procedure TMqmActArea.ReorganizeAllProgress(OnStart : boolean);
var
  PrevId, Id, NextId, SonId, SonIdTemp : TSchedID;
  Index, GrpIndex, I : integer;
  PrevProgInfo, ProgInfo, NextProgInfo : TSQProgInfo;
  SavedStartDate, StartDate, EndDate, PrevProgressEnd : TDateTime;
  TempDuration, Duration, Setup, CurveTime, QtyToSched : double;
  TimingInfo:   TSQtimingInfo;
  SchedObjs, SchedContGroups : TMSchedList;

  //*-------------------------------------
  Procedure updateProgressDatesAndStatus;
  //*-------------------------------------
  begin
    SchedObjs.SortList(OrderGrowing);
    Index := -1;
    while true do
    begin
      Application.ProcessMessages;
      Index := Index + 1;
      if Index > (SchedObjs.GetLinkCount - 2) then
        break;
      Id := SchedObjs.GetLink(Index);
      NextId := SchedObjs.GetLink(Index+1);
      p_sc.GetProgInfo(Id, ProgInfo);
      p_sc.GetProgInfo(NextId, NextProgInfo);
      if (ProgInfo.ProgType = '2') then
      begin
        if ProgInfo.PrgCurDt > NextProgInfo.PrgSt then
          EndDate := NextProgInfo.PrgSt
        else
          EndDate := ProgInfo.PrgCurDt;
      end
      else if (ProgInfo.ProgType = '1') then
        EndDate := (ProgInfo.PrgSt + (1 / 24 / 60 / 60))
      else
      begin
        if ProgInfo.PrEd <= NextProgInfo.PrgSt then
          continue;
        EndDate := NextProgInfo.PrgSt;
      end;
      p_sc.CloseProgress(Id, EndDate);
      SavedStartDate := ProgInfo.PrgSt;
      p_sc.GetProgInfo(Id, ProgInfo);
      if ProgInfo.PrgSt < SavedStartDate then
      begin
        if Index = 0 then
          Index := -1
        else
          Index := Index - 2;
      end;
    end;
  end;

//*----------------------------------------------------------------------
begin
//*----------------------------------------------------------------------
  if not assigned(m_SchedObjs) or (m_SchedObjs.GetLinkCount <= 0) then
    exit;

  SchedObjs := TMSchedList.Create(self);
  SchedContGroups := TMSchedList.Create(self);

  for Index := 0 to m_SchedObjs.GetLinkCount - 1 do
  begin
    Id := m_SchedObjs.GetLink(Index);
    if not OnStart then
    begin
      if p_sc.IsGroup(Id) then
      begin
        for i := 0 to p_sc.GetGrpNumSons(ID) - 1 do
        begin
          SonId := p_sc.GetGrpSon(ID, i);
          p_sc.GetProgInfo(SonId, ProgInfo);
          if ProgInfo.JobProgSaved then
            p_sc.SaveProgInfoStatus(SonId, true);
        end
      end
      else
      begin
        p_sc.GetProgInfo(Id, ProgInfo);
        if ProgInfo.JobProgSaved then
          p_sc.SaveProgInfoStatus(Id, true);
      end;
    end;

    p_sc.GetProgInfo(Id, ProgInfo);
    if ProgInfo.ProgType <> '' then
    begin
      SchedObjs.AddLink(Id);
      if p_sc.IsGroup(Id) and (p_sc.GetGrpNumSons(id) > 1) then
      begin
        SonId := p_sc.GetGrpSon(id, 0);
        if p_sc.IsIdSimpleContinues(SonId) then
          SchedContGroups.AddLink(Id);
      end;
    end;

    if p_sc.IsGroup(Id) then
    begin
      for i := 0 to p_sc.GetGrpNumSons(ID) - 1 do
      begin
        SonId := p_sc.GetGrpSon(ID, i);
        p_sc.SaveProgInfoStatus(SonId, false);
      end
    end
    else
      p_sc.SaveProgInfoStatus(Id, false);

  end;

  updateProgressDatesAndStatus;

  for GrpIndex := 0 to SchedContGroups.GetLinkCount - 1 do
  begin
    SchedObjs.ClearList;
    Id := SchedContGroups.GetLink(GrpIndex);
    for i := 0 to p_sc.GetGrpNumSons(id) - 1 do
    begin
      SonId := p_sc.GetGrpSon(id, i);
      p_sc.GetProgInfo(SonId, ProgInfo);
      if ProgInfo.ProgType <> '' then
        SchedObjs.AddLink(SonId);
    end;
    if SchedObjs.GetLinkCount > 1 then
      updateProgressDatesAndStatus;
  end;
  SchedContGroups.Free;

  SchedObjs.ClearList;
  for Index := 0 to m_SchedObjs.GetLinkCount - 1 do
  begin
    Id := m_SchedObjs.GetLink(Index);
    SchedObjs.AddLink(Id);
  end;
  SchedObjs.SortList(OrderGrowing);

  for Index := 0 to SchedObjs.GetLinkCount - 1 do
  begin
    Application.ProcessMessages;
    Id := SchedObjs.GetLink(Index);
    p_sc.GetTimingInfo(id, TimingInfo);
    if TimingInfo.stepType = CST_batch then continue;

    if p_sc.IsGroup(Id) and TimingInfo.batch_ContinuesTime  then
    begin
      Duration := 0;
      StartDate := 999999;
      for GrpIndex := 0 to p_sc.GetGrpNumSons(Id) - 1 do
      begin
        SonId := p_sc.GetGrpSon(Id, GrpIndex);
        p_sc.GetProgInfo(SonId, ProgInfo);
        if (ProgInfo.ProgType = '') or (ProgInfo.ProgType = '1') or (ProgInfo.PrgStartingQtyOrig <= 0) then continue;
        p_sc.GetIdTimes(SonId,'','','',false,TempDuration,Setup,true);
        QtyToSched := p_sc.GetQtyToSched(SonId);
        TempDuration := TempDuration/QtyToSched*ProgInfo.PrgStartingQtyOrig;
        Duration := Duration + TempDuration;
        if StartDate > ProgInfo.PrgSt then
          StartDate := ProgInfo.PrgSt;
      end;
      if Duration = 0 then continue;
      SonId := p_sc.GetGrpSon(Id, 0);
      CurveTime := GetCurveTime(self, StartDate,SonId,duration,true,0);
      duration := duration + CurveTime;
    end
    else
    begin
      if p_sc.IsGroup(Id) then  // Continutes and not batch_ContinuesTime
      begin
        StartDate := 999999;
        for GrpIndex := 0 to p_sc.GetGrpNumSons(Id) - 1 do
        begin
          SonIdTemp := p_sc.GetGrpSon(Id, GrpIndex);
          p_sc.GetProgInfo(SonIdTemp, ProgInfo);
          if (ProgInfo.ProgType = '') or (ProgInfo.ProgType = '1') or (ProgInfo.PrgStartingQtyOrig <= 0) then continue;
          if StartDate > ProgInfo.PrgSt then
          begin
            SonId := SonIdTemp;
            StartDate := ProgInfo.PrgSt;
          end;
        end;
        if StartDate = 999999 then continue;
        p_sc.GetProgInfo(SonId, ProgInfo);
        p_sc.GetIdTimes(SonId,'','','',false,Duration,Setup,true);
        QtyToSched := p_sc.GetQtyToSched(SonId);
        duration := duration/QtyToSched*ProgInfo.PrgStartingQtyOrig;
        CurveTime := GetCurveTime(self, StartDate, SonId, duration,true,0);
        duration := duration + CurveTime;
      end
      else
      begin  // Not group
        p_sc.GetProgInfo(Id, ProgInfo);
        p_sc.GetIdTimes(Id,'','','',false,Duration,Setup,true);
        if (ProgInfo.ProgType = '') or (ProgInfo.ProgType = '1') or (ProgInfo.PrgStartingQtyOrig <= 0) then continue;
        p_sc.GetIdTimes(Id,'','','',false,Duration,Setup,true);
        QtyToSched := p_sc.GetQtyToSched(id);
        duration := duration/QtyToSched*ProgInfo.PrgStartingQtyOrig;
        StartDate := ProgInfo.PrgSt;
        CurveTime := GetCurveTime(self, StartDate, Id, duration, true, 0);
        duration := duration + CurveTime;
      end;
    end;

    GetCalendar.OfsByWH(-duration/60, false, StartDate, StartDate, m_CrossDownTmList);

    PrevProgressEnd := 0;
    for I := (Index - 1) downto 0 do
    begin
      PrevId := SchedObjs.GetLink(I);
      p_sc.GetProgInfo(PrevId, PrevProgInfo);
      if PrevProgInfo.ProgType = '' then continue;  // All progressed before are already closed
      PrevProgressEnd := PrevProgInfo.PrEd;
      break;
    end;

    if StartDate < PrevProgressEnd then
      p_sc.UpdateProgressStartTime(Id, PrevProgressEnd)
    else
      p_sc.UpdateProgressStartTime(Id, StartDate);

  end;
  SchedObjs.Free;
end;

//----------------------------------------------------------------------------//

function TMqmActArea.ChangeTo_IgnorProgress(Id: TSchedId; startTm : TDateTime) : boolean;
var
  ObjMover : TMqmSchedObjMover;
  duration, setup, overlap: double;
  TmpEndDate : TDatetime;
  OptsMover : SetOptsMover;
  DeltaSetupObjToMove : double;
  NextId : TSchedId;
  planInfo: TSQplanInfo;
  ObjToCheck: TMSChedList;
  JobComponentsUsed : integer;
begin
  Result := false;
  JobComponentsUsed := -1;
 { if ReApply then
  begin
    p_sc.GetPlanInfo(Id, planInfo);
    ObjToCheck := TMSchedList.Create(self);
    SortSchedObjs;
    FindSchedInSpots(planInfo.startDate, planInfo.endDate, ObjToCheck);
    if (ObjToCheck.GetLinkCount > 1) then
    begin
      ObjToCheck.free;
      exit
    end;
  end;  }

  ObjMover := TMqmSchedObjMover.Create;
  ObjMover.SetObjToMove(Id);

 // if Assigned(p_Res) and TMqmRes(p_Res).p_isMultiRes then
 //   JobComponentsUsed := p_sc.GetJobComponents(id, false);

//  while true do
//  begin
  if ObjMover.ChangeTo(self, startTm, false, CSchedIDnull, Al_toDate, setup, overlap,
                         duration, '', TmpEndDate, OptsMover, nil, False, DeltaSetupObjToMove,false, JobComponentsUsed) = CSM_Yes then
  begin
    Result := true;
   // break
  end
  else
  begin
   // NextId := GetNextObj(startTm,Id);
  //  p_sc.GetPlanInfo(NextId, planInfo);
  //  startTm := planInfo.endDate + 1/24/60/60;
  //  Id := NextId;
  end;
//  end;

  ObjMover.Destroy;
end;

//----------------------------------------------------------------------------//

procedure TMqmActArea.FillJobsIdBeforeDodayInList(List : Tlist);
var
  PrevId : TSchedId;
begin
  PrevId := GetPrecObj(now, -1);
  while true do
  begin
    if PrevId <> CSchedIDnull then
    begin
     // if p_sc.CanDetach(PrevId, nil, false) then
      if p_sc.CanMoveToBin(PrevId, nil, false) then
        List.Add(Pointer(PrevId));
      PrevId := GetPrecObjByIndex(PrevId);
    end
    else
      exit;
  end;
end;

//----------------------------------------------------------------------------//

procedure TMqmActArea.RemovetoBinClosedSteps;
var
  progInfo : TSQprogInfo;
  ObjToMove : TSchedId;
  I : integer;
begin
  for i := m_SchedObjs.GetLinkCount - 1 downto 0 do
  begin
    Application.ProcessMessages;
    ObjToMove := m_SchedObjs.GetLink(i);

    if Assigned(p_sc.GetExtLinkPtr(ObjToMove))
    and TMqmWrkCtr(TMqmActArea(p_sc.GetExtLinkPtr(ObjToMove)).p_WrkCtr).p_ReadOnly then
      continue;

    p_sc.GetProgInfo(ObjToMove, progInfo);
    if (progInfo.ProgType <> '') then
      continue;

    if p_sc.IsClosedForDetach(ObjToMove) then
      RemoveSchedObj(ObjToMove);
  end;
end;

//----------------------------------------------------------------------------//

function TMqmActArea.ReorganizeDur(RefObj: TMqmDurObj): boolean;
label
  fail;
var
  StartIndex,i: integer;
  LastDate:   TDateTime;
  CapToMove : TMqmCapRes;
  WarptoMove : TMqmWarp;
begin
  Result := true;
  if RefObj is TMqmCapRes then
  begin

    m_CapResList.SortList;

    StartIndex := m_CapResList.FindCovering(RefObj.p_start, RefObj.p_end, RefObj);
    if StartIndex < 0 then
    begin
      UpdateCrossDownTmList;
      exit;
    end;

    LastDate := RefObj.p_end;

    for i := StartIndex to m_CapResList.Count-1 do
    begin
      CapToMove := TMqmCapRes(m_CapResList.p_sons[i]);
      if (CapToMove <> RefObj) then
      begin
        if (CapToMove.p_start < LastDate) then
        begin
  //        if not CapToMove.CanMoveTo(ObjToMove, LastDate) then goto fail;
          p_opStack.ChgPlanObjDurData(CapToMove);
          CapToMove.p_start := LastDate;
          CapToMove.p_end;

          LastDate := CapToMove.p_end
        end else
          break;
      end;
    end;
    UpdateCrossDownTmList;
  end

  else if RefObj is TMqmWarp then
  begin
    m_WarpList.SortList;

    StartIndex := m_WarpList.FindCovering(RefObj.p_start, RefObj.p_end, RefObj);
    if StartIndex < 0 then
    begin
      exit;
    end;

    LastDate := RefObj.p_end;

    for i := StartIndex to m_WarpList.Count-1 do
    begin
      WarptoMove := TMqmWarp(m_WarpList.p_sons[i]);
      if (WarptoMove <> RefObj) and (TMqmWarp(WarptoMove).m_WarpLvl = TMqmWarp(RefObj).m_WarpLvl) then
      begin
        if (WarptoMove.p_start < LastDate) then
        begin
  //        if not CapToMove.CanMoveTo(ObjToMove, LastDate) then goto fail;
          p_opStack.ChgPlanObjDurData(WarptoMove);
          WarptoMove.p_start := LastDate;
          WarptoMove.p_end;

          LastDate := WarptoMove.p_end
        end else
          break;
      end;
    end;

  end;


  exit;

  fail:
    Result := False;
end;

//----------------------------------------------------------------------------//

function TMqmActArea.FindWarpPlace(RefObj: TMqmDurObj; IsEnd : boolean; StarDate, EndDate : TDateTime): boolean;
var
  StartIndex,i, CapRes_LastIndexChecked, Warp_LastIndexChecked : integer;
  startTime, EndTime:   TDateTime;
  ObjCoverd, ObjCoverdWarp : TMqmDurObj;
begin
  Result := FindAllObjCovering(m_CapResList, StarDate, EndDate, RefObj, CapRes_LastIndexChecked, false);
  if Result then exit;
  Result := FindAllObjCovering(m_WarpList, StarDate, EndDate, RefObj, Warp_LastIndexChecked, true);
end;

//----------------------------------------------------------------------------//

function SortPosListDescending(Item1, Item2: Pointer): Integer;
var
  PosTest1, PosTest2 : PTPos;
begin
  PosTest1 := PTPos(Item1);
  PosTest2 := PTPos(Item2);

  if PosTest2.PlanPos.m_StartDate > PosTest1.PlanPos.m_StartDate then
    Result := 1
  else if PosTest2.PlanPos.m_StartDate < PosTest1.PlanPos.m_StartDate then
    Result := -1
  else
    Result := 0;
end;

//----------------------------------------------------------------------------//

function SortPosListAscending(Item1, Item2: Pointer): Integer;
var
  PosTest1, PosTest2 : PTPos;
begin
  PosTest1 := PTPos(Item1);
  PosTest2 := PTPos(Item2);

  if PosTest1.DateBeforeChain and not PosTest2.DateBeforeChain then
    result := 1
  else if not PosTest1.DateBeforeChain and PosTest2.DateBeforeChain then
    Result := -1
  else
  begin
    if PosTest1.DateForSort > PosTest2.DateForSort then
      Result := 1
    else if PosTest1.DateForSort < PosTest2.DateForSort then
      Result := -1
    else
      Result := 0;
  end;
end;

//----------------------------------------------------------------------------//

function TMqmActArea.CheckPosition(RefId: TSchedID; ErrList: TStringList): CScMovementResult;
label
  fail;
var
  Id: TSchedID;
  actArea: TMQMActArea;
  CompFore, CompBack, CompVal: TCompatVal;
  CapResList: TDurList;
  planInfo:     TSQplanInfo;
  CapRes: TMqmCapRes;
  i: integer;
begin
  Result := CSM_No;
  actArea := p_sc.GetExtLinkPtr(RefId);

  Id := actArea.GetPrecObjByIndex(RefId);
  if Id <> CSchedIDnull then
  begin
    p_sc.GetCompatWithOcc(Id, CompFore, CompBack);
    if CompFore = CompValNotComp then
    begin
      if Assigned(ErrList) then
        ErrList.Add(_('Not compatible with previous job on Gantt'));
      exit;
    end
  end;

  Id := actArea.GetNextObjByIndex(RefId);
  if Id <> CSchedIDnull then
  begin
    p_sc.GetCompatWithOcc(Id, CompFore, CompBack);
    if CompBack = CompValNotComp then
    begin
      if Assigned(ErrList) then
        ErrList.Add(_('Not compatible with next job on Gantt'));
      exit;
    end
  end;

  CapResList := TDurList.Create(self);
  p_sc.GetPlanInfo(RefId, planInfo);
  actArea.GetCapResInSpot(planInfo.startDate, planInfo.endDate, CapResList);
  for i := 0 to CapResList.Count -1 do
  begin
    CapRes := TMqmCapRes(CapResList.p_sons[i]);
    if CapRes.m_Type <> cr_Normal then
       Continue;
    CompVal := TMqmRes(CapRes.p_Res).CheckCompIDCapRes(RefId, capRes);
    if CompVal = CompValNotComp then
    begin
      if Assigned(ErrList) then
        ErrList.Add(_('Job not compatible with the capacity reservation on this position'));
      goto fail;
    end;

    if not CapRes.CheckUpMostCase(CompVal) then
    begin
      if Assigned(ErrList) then
        ErrList.Add(_('Compatibility up most case with the capacity reservation exceeded'));
      goto fail;
    end;
  end;

  Result := CSM_Yes;

fail:
  CapResList.Free;
end;

//----------------------------------------------------------------------------//

function TMqmActArea.CheckPositionAuto(RefId: TSchedID): CScMovementResult;
label
  fail;
var
  Id: TSchedID;
  actArea: TMQMActArea;
  CompFore, CompBack, CompVal: TCompatVal;
  CapResList: TDurList;
  planInfo :     TSQplanInfo;
  CapRes: TMqmCapRes;
  i: integer;
//  DwTime: TMqmDurObj;
begin
  Result := CSM_No;
  actArea := p_sc.GetExtLinkPtr(RefId);
  p_sc.GetPlanInfo(RefId, planInfo);

  Id := actArea.GetPrecObjByIndex(RefId);

  if (ID <> CSchedIdNull) then
  begin
    p_sc.GetCompatWithOcc(Id, CompFore, CompBack);
    if CompFore = CompValNotComp then
    begin
      exit;
    end
  end;

  Id := actArea.GetNextObjByIndex(RefId);
  if Id <> CSchedIDnull then
  begin
    p_sc.GetCompatWithOcc(Id, CompFore, CompBack);
    if CompBack = CompValNotComp then
    begin
      exit;
    end
  end;

  CapResList := TDurList.Create(self);
//  p_sc.GetPlanInfo(RefId, planInfo);
  actArea.GetCapResInSpot(planInfo.startDate, planInfo.endDate, CapResList);
  for i := 0 to CapResList.Count -1 do
  begin
    CapRes := TMqmCapRes(CapResList.p_sons[i]);
    if CapRes.m_Type <> cr_Normal then
       Continue;
    CompVal := TMqmRes(CapRes.p_Res).CheckCompIDCapRes(RefId, capRes);
    if CompVal = CompValNotComp then
    begin
      goto fail;
    end;

    if not CapRes.CheckUpMostCase(CompVal) then
    begin
      goto fail;
    end;
  end;

  Result := CSM_Yes;

fail:
  CapResList.Free;
end;

//----------------------------------------------------------------------------//

function SortMatByStart(Item1, Item2: Pointer): integer;
var
  Rec1, Rec2 : PTRecNoMatDate;
begin
  Rec1 := PTRecNoMatDate(Item1);
  Rec2 := PTRecNoMatDate(Item2);
  if Rec1.m_start = Rec2.m_start then
    Result := 0
  else if Rec1.m_start > Rec2.m_start then
    Result := 1
  else
    Result := -1;
end;

//----------------------------------------------------------------------------//

function SortMatByEnd(Item1, Item2: Pointer): integer;
var
  Rec1, Rec2 : PTRecNoMatDate;
begin
  Rec1 := PTRecNoMatDate(Item1);
  Rec2 := PTRecNoMatDate(Item2);
  if Rec1.m_end = Rec2.m_end then
    Result := 0
  else if Rec1.m_end > Rec2.m_end then
    Result := 1
  else
    Result := -1;
end;

//----------------------------------------------------------------------------//

function TMqmActArea.GetObjCount: integer;
begin
  Result := m_SchedObjs.GetLinkCount;
end;

//----------------------------------------------------------------------------//

function TMqmActArea.CheckIfSchedObjsIsAssigned : boolean;
begin
  Result := true;
  if not assigned(m_SchedObjs) then
     Result := false;
end;

//----------------------------------------------------------------------------//

function DwTimeOrderGrowing(Item1, Item2: Pointer): integer;
var
  id1, id2: PTRecCalDownTime;
begin
  id1 := Item1;
  id2 := Item2;

  if      id1.DowntimeStart = id2.DowntimeStart then Result :=  0
  else if id1.DowntimeStart < id2.DowntimeStart then Result := -1
  else                                           Result :=  1
end;

//----------------------------------------------------------------------------//

procedure TMqmActArea.UpdateCrossDownTmList;
var
  i: integer;
  TempRecDownTime: PTRecCalDownTime;
  CrossDowntime: TMqmCapRes;
begin
  if Assigned(m_CrossDownTmList) then
    for i := m_CrossDownTmList.Count -1 downto 0 do
    begin
      TempRecDownTime := m_CrossDownTmList[i];
      m_CrossDownTmList.Remove(TempRecDownTime);
      dispose(TempRecDownTime);
    end;

  if Assigned(m_CapResList) then
    for i := 0 to m_CapResList.Count-1 do
    begin
      CrossDowntime := TMqmCapRes(m_CapResList.p_sons[i]);
      if CrossDowntime.m_Type = Cr_CrossingDtm then
      begin
        if not Assigned(m_CrossDownTmList) then
          m_CrossDownTmList := TList.Create;
        new(TempRecDownTime);
        TempRecDownTime.DowntimeStart := CrossDowntime.p_start;
        TempRecDownTime.DowntimeEnd := CrossDowntime.p_end;
        TempRecDownTime.DurationHours := CrossDowntime.p_dur/60;
        m_CrossDownTmList.Add(TempRecDownTime)
      end;
    end;

  if Assigned(m_CrossDownTmList) then
    m_CrossDownTmList.Sort(DwTimeOrderGrowing);
end;

//----------------------------------------------------------------------------//

procedure TMqmActArea.RefreshDwTime(CapResMaster: TMQMDurObj; isEnd: boolean;
                                    RecDwTmLinked: PTDwTimeLinked);
var
  CapResMover: TMqmCapResMover;
  CapRes : TMQMCapRes;
  i : integer;
  isNew : boolean;
begin

  CapRes := nil;
  for i := 0 to RecDwTmLinked.LstDwTime.Count -1 do
  begin
    CapRes := TMQMCapRes(RecDwTmLinked.LstDwTime.Items[i]);
    if CapRes.p_Father = self then break
    else CapRes := nil;
  end;

  isNew := CapRes = nil;

  if CapRes = CapResMaster then exit;
  CapResMover := TMqmCapResMover.Create;
  CapResMover.SetCapResToMove(CapRes);
  CapRes.m_type := TMQMCapRes(CapResMaster).m_Type;

  if isNew then
    RecDwTmLinked.LstDwTime.Add(CapRes);

  CapResMover.ChangeTo(self, CapResMaster.p_start, CapResMaster.p_dur, isEnd);
  ReorganizeAllOcc(true);
end;

//----------------------------------------------------------------------------//

function TMqmActArea.GetDurationOfAllJobsBeforeThisSpot(IdStartDateTime : TDateTime; Id : TschedId) : double;
var
  I, j : Integer;
  ObjId, IdSon : TSchedID;
  ReadEachChildInGroup : boolean;
  Duration,Setup : double;
  IdFamily, IdLearningCurveCode : String;
  Cal: TPGCALObj;
  CurveAlreadyUsedTime : double;
  StartDate, EndDate : TDateTime;
  progInfo: TSQProgInfo;

{  function GetIdDuration(IdToCalc : TschedId) : double;
  var
    progInfo: TSQProgInfo;
    JobInfo : TSQplanInfo;
    JobQty : double;
    TempTime, TmpRemTime : double;
  begin
    Result := 0;

    p_sc.GetprogInfo(IdToCalc, progInfo);

    if progInfo.ProgressStatus = prg_none then
    begin
      p_sc.GetIdTimes(IdToCalc,'','','',false,Result,Setup,true);
      Exit;
    end;

    if (progInfo.ProgressStatus = prg_Final) or (progInfo.ProgressStatus = prg_Final) then
    begin
      EndDate := p_sc.GetSchedEnd(IdToCalc);
      Result := cal.DiffWH(StartDate, enddate , m_CrossDownTmList)*60;
      Exit;
    end;

    p_sc.GetJobInfo(IdToCalc, JobInfo);

    if JobInfo.stepType <> CST_Continuous then // There is no sense that no continues will have partial progress
    begin
      p_sc.GetIdTimes(IdToCalc,'','','',false,Result,Setup,true);
      Exit;
    end;

    if p_sc.IsGroup(IdToCalc) or ReadEachChildInGroup then
    begin
      EndDate := p_sc.GetSchedEnd(IdToCalc);
      Result := cal.DiffWH(StartDate, enddate , m_CrossDownTmList)*60;
      Exit;
    end;

    if progInfo.PrgRemTime > 0 then
    begin
      Result := progInfo.PrgRemTime;
      Exit;
    end;

    if (progInfo.ProgressStatus = prg_Starting) then
    begin
      p_sc.GetIdTimes(IdToCalc,'','','',false,Result,Setup,true);
      Exit;
    end;

    // Must be a progress partial of continues job not in a group
    JobQty := p_sc.GetJobQty(IdToCalc);
    Result := cal.DiffWH(StartDate, progInfo.PrgCurDt , m_CrossDownTmList)*60;

    if progInfo.PrgQty < JobQty then
    begin
      p_sc.GetIdTimes(IdToCalc,'','','',false,TempTime,Setup,true);
      TmpRemTime := (JobQty - progInfo.PrgQty)*TempTime/JobQty;
      Result := Result + GetCurveTime(nil, 0, IdToCalc, TmpRemTime, false, (CurveAlreadyUsedTime + Result));
    end;

  end;   }

begin
  Result := 0;

  IdFamily := p_sc.GetCurveFamilyIdCode(id);
  if IdFamily = '' then
    Exit;
  IdLearningCurveCode := p_sc.GetLearningCurveCode(Id);

  CurveAlreadyUsedTime := 0;
  Cal := GetCalendar;

  for i := 0 to m_SchedObjs.GetLinkCount - 1 do
  begin
    ObjId := m_SchedObjs.GetLink(i);

    if (p_sc.GetLearningCurveType(ObjId) = CSC_No)
    or (p_sc.GetCurveFamilyIdCode(ObjId) <> IdFamily)
    or (p_sc.GetLearningCurveCode(ObjId) <> IdLearningCurveCode) then
      continue;

{    ReadEachChildInGroup := false;
    if p_sc.IsGroup(ObjId) then
    begin
      idSon := p_sc.GetGrpSon(ObjId, 0);
      if p_sc.IsIdSimpleContinues(idSon) then
        ReadEachChildInGroup := true;
    end;

    if ReadEachChildInGroup then
    begin
      for j := 0 to p_sc.GetGrpNumSons(ObjId)-1 do
      begin
        idSon := p_sc.GetGrpSon(ObjId, j);
        if idSon = Id then break;
        StartDate := p_sc.GetSchedStart(idSon);
        if StartDate >= IdStartDateTime then break;
        CurveAlreadyUsedTime := CurveAlreadyUsedTime + GetIdDuration(idSon);
      end;
      continue;
    end;       }  // Eran 13/12/2025 - We need always to take the whole group

    if ObjId = Id then break;
    StartDate := p_sc.GetSchedStart(ObjId);
    if StartDate >= IdStartDateTime then break;
//    CurveAlreadyUsedTime := CurveAlreadyUsedTime + GetIdDuration(ObjId);

    p_sc.GetprogInfo(ObjId, progInfo);

    if (progInfo.ProgressStatus = prg_none) or (progInfo.ProgressStatus = prg_Starting) then
      CurveAlreadyUsedTime := CurveAlreadyUsedTime + p_sc.GetExeMin(ObjId)
    else
    begin
      // It can be that there is a setup , but we do not know when its ending, so, we take the whole job
      EndDate := p_sc.GetSchedEnd(ObjId);
      CurveAlreadyUsedTime := CurveAlreadyUsedTime + cal.DiffWH(StartDate, enddate , m_CrossDownTmList)*60;
    end;

  end;

  Result := CurveAlreadyUsedTime;

end;

//----------------------------------------------------------------------------//

function TMqmActArea.GetWarpFromId(Id : TSchedID) : TMqmPlanObj;
var
  I : Integer;
begin
  Result := nil;
  if not Assigned(m_WarpList) then exit;
  for I := 0 to WarpCount - 1 do
  begin
    if TMqmWarp(p_Warp[I]).Get_M_id = id then
    begin
      Result := TMqmWarp(p_Warp[I]);
      break
    end;
  end;
end;

end.

