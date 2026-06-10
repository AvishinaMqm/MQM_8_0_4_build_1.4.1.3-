unit UMPlan;

interface

uses
  Classes,
  forms,
  UMSchedCont,
  UMSchedList,
  UMSchedContFunc,
  UMCalcTimings,
  UMCalcOverlaps,
  UMResCat,
//  UMRes,
  UGObjListSrv,
//  UMWkCtr,

//Old overlap  UMOverlapRules,
  UMCommon,
  stdctrls,
  DMsrvPc, gnugettext;

type

  TMqmPlan = class;

  TMqmObj = class
    m_plan: TMqmPlan
  end;

  TMqmPlan = class
    constructor CreatePlan(schedCont: TMSchedCont);
    destructor  Destroy; override;
  private
    m_corrUpd:      integer;
    m_corrUpdSharedDate : integer;
    m_compId:       TSchedId;
    m_CompCapRes:   TMqmObj;
    m_visRes:       TMqmObj;
    m_calcTmg:      TMCalcTimings;
    m_calcOvlp:     TMCalcOverlaps;
//Old overlap    m_OvplRules:    TMOvlpRules;
    m_WrkCtrs:      TList;
    m_AltWrkCtrs:   TList;
    m_AltWrkCtrsGen:   TList;
    m_schedCont:    TMSchedCont;
    m_ResList:      TList;
    m_ResCatList:   TList;
    m_ObjToDelList: TList;
    m_ObjWarpNonScheduledToUpdateList: TList;
    m_objListSrv:   TObjListSrv;
    m_SavedPlanCopy : TList;

    procedure LoadWorkcenters(qry: TMqmQuery; ProgBar: TMqmProgBar; Status: TStaticText; ErrList: TStringList);
    procedure LoadAltWorkcenters(qry: TMqmQuery; ProgBar: TMqmProgBar; Status: TStaticText; ErrList: TStringList);
    procedure LoadResources(qry: TMqmQuery; ProgBar: TMqmProgBar; Status: TStaticText; ErrList: TStringList);
    procedure LoadActPlanArea(qry: TMqmQuery; ProgBar: TMqmProgBar; Status: TStaticText; ErrList: TStringList);
//  procedure LoadCapRes(qry: TMqmQuery; ProgBar: TMqmProgBar; Status: TStaticText; ErrList: TStringList);
//    procedure LoadCapResProperties(qry: TMqmQuery; ProgBar: TMqmProgBar; Status: TStaticText; ErrList: TStringList);
    procedure LoadResProperties(qry: TMqmQuery; ProgBar: TMqmProgBar; Status: TStaticText; ErrList: TStringList);
    procedure LoadResRules(qry: TMqmQuery; ProgBar: TMqmProgBar; Status: TStaticText; ErrList: TStringList);
    procedure LoadOvlpRules(qry: TMqmQuery; ProgBar: TMqmProgBar; Status: TStaticText; ErrList: TStringList);

    procedure SaveWarp(DB: TMqmDBType; qry: TMqmQuery; SuffixTblName: string; updNum : integer);
    procedure SaveCapRes(DB: TMqmDBType; qry: TMqmQuery; SuffixTblName: string; updNum : integer);
    procedure SaveCapResProp(qry: TMqmQuery; SuffixTblName: string; ObjCapRes: TMqmObj);

    function  WrkCtrsCount : Integer;
    function  GetMqmWrkCtr(i: integer): TMqmObj;
    function  ResCatCount : Integer;
    function  GetMqmResCat(i: integer): TMqmObj;
    function  ObjToDelCount : Integer;
    function  GetObjToDel(i: integer): TMqmObj;
    function  GetAllMqmWrkCtr : TList;
    function  GetResCat(code, descr: string; Create: Boolean): TMqmResCat;
    function  GetRes(I : integer) : pointer;
    function  ResCount : integer;
    function  GetSavePLanCopyCount : integer;
  public
    m_today:     TDateTime;
    m_todayAlgn: TDateTime;

    procedure Clear;
    procedure SaveSharedComment(Id : TSchedId; Comment : string; updNum: integer);
    procedure Load(ProgBar: TMqmProgBar; Status: TStaticText; ErrList: TStringList; UpdNum : integer; UpdNumSharedData : integer);
    procedure Save(DB: TMqmDBType; SuffixTblName: string; updNum: integer);
    procedure UpdateStationCapRes(DB: TMqmDBType; updNum : integer);
    procedure UpdateCapResColorDesc;
    procedure UpdateSharedData(DB: TMqmDBType; updNum : integer);
    function  FindWrkCtrByCode(WkcCode: string): pointer;
    function  FindWrkCtrByGrpAndPlantCode(WkcGrp, WkcPlant : string): pointer;
    function  FindWrkCtrMainByWrkCtrAndPlantCode(WkcPlant, PlanedWc : string): pointer;
    function  FindAltWcByCode(WkcCode: string ; Process : string ;AltList : TList): boolean;
    function  FindAltListWc(WkcCode: string ; AltList : TList): boolean;
    function  FindResByCode(resCode: string): TMqmObj;
    function  FindCapResByCode(capResCode: integer; removeCapRes : boolean): TMqmObj;
    function  AddRow(pObj: pointer): integer;
    procedure AddWorkcenter(WrkCtr: TMqmObj);
    procedure UpdateNonScheduleObjWarp(Id : TSchedId);
    procedure AddObjWarpNonScheduleToUpdate(ObjToUpdate: TMqmObj);
    procedure AddObjToDele(ObjToDele: TMqmObj);
    procedure PlanLinkJob(link: string; id: TSchedID; ptr: pointer);
    procedure UpdatePlanLinkJob(link: string; id: TSchedID; ptr: pointer);
    procedure UpdatePlanLinkJobAutoSeq(resObj: TObject; id: TSchedID; ptr: pointer);
    function  GetVisResCode(ptr: pointer): string;
    function  ChangesMade: boolean;
    procedure SetTmgTargetResForGroup(resObj: TObject);
    function  BuildWkcDailyCapacity(VisResList: TList ;ProgBar: TMqmProgBar; Status: TStaticText) : boolean;
    procedure BuildWkcDailyEntityCapacity(VisResList: TList; EntityType : Integer; PropCode : string);

    procedure LoadWarp(ProgBar: TMqmProgBar; Status: TStaticText; ErrList: TStringList);
    procedure LoadCapRes(qry: TMqmQuery; SuffixTblName: string; ProgBar: TMqmProgBar;
                         Status: TStaticText; ErrList: TStringList);
    procedure LoadCapResDynamic(qry: TMqmQuery; ResourceCode : string; SuffixTblName: string; ProgBar: TMqmProgBar;
                         Status: TStaticText; ErrList: TStringList);
    procedure LoadCapResProperties(qry: TMqmQuery; SuffixTblName: string; ProgBar: TMqmProgBar;
                         Status: TStaticText; ErrList: TStringList);
    procedure LoadSavedPlanCopy;
    Function  GetListForSavedPlan(SET_NAME : String;StartDate, EndDate : TDateTime): TList;

    function  BinClientRegister(obj: TObject; fnc: TFncNotyChg; filt: TFncFilter): TMSchedList;
    procedure BinClientUpdateAll(obj: TObject ; ToSort : boolean);
    procedure BinClientUpdateAllChange(obj: TObject);
    procedure BinClientUnRegister(obj: TObject);
    procedure MainUpdateFilterAndSort(obj: TObject);
    procedure BinSetSortIndex(obj : TObject ; NewIndex : Integer);
    procedure BinSetAllSortIndex(NewIndex: integer);
    procedure BinAddSortFnc(obj: TObject; Index: integer;
                            fnc: TListSortCompare; Ptr: pointer);

    // operating modes
    function  GetCompatModeInPlanId: TSchedId;
    procedure EnterCompatModeInPlan(id: TSchedId);
    procedure ExitCompatModeInPlan;

    procedure EnterCompatModeInPlanForAutoSeq(id: TSchedId; Res : Pointer);
    procedure ExitCompatModeInPlanForAutoSeq;
    procedure EnterCompatModeInPlanForSplit(id: TSchedId);

    procedure EnterCompatModeInPlanCapRes(CapRes: TMqmObj);
    function  GetCompatModeInPlanCapRes: TMqmObj;
    procedure ExitCompatModeInPlanCapRes;
    procedure UpdateCompatModeInPlanCapRes;

    function  GetCompatModeInBinVisRes: TMqmObj;
    procedure EnterCompatModeInBin(visRes: TMqmObj);
    procedure ExitCompatModeInBin;
    function  GetWorkCenterProcessFromRes(ResCode : string ; Pd_Wc : string; Pd_Process : string; var wc : string; var process : string) : boolean;

    // caching various
    function  HasTimingsOnRes(resObj: TMqmObj): boolean;
    function  HasJobWasDeletetedFromHost(Request : string; ProdStep : Integer;  var UnSchedule : boolean) : boolean;
    procedure SetTmgTargetRes(resObj: TObject);
    procedure ReCreateCalcTmg;
    procedure SetTmgByDescr(Descr: string);
    procedure GetTmgDescList(DescList: TStringList);
    procedure SetTmgMainID(id: TSchedID);
    procedure GetMainTimings(var supMin, exeMin: double; var Descr: string; var MSC: string);
    procedure GetMainTimingsOrig(var supMin, exeMin: double; var Descr: string; var MSC: string);
    procedure GetSubTimings(pos: integer; var id: TSchedId; var supMin, exeMin: double; var Descr: string; var MSC: string);
    procedure GetResCatWrkCntrProcessCalcTiming(var WkCentr : string; var Process : string; var Res : string; var CatRes : string);
    procedure GetResCatWrkCntrProcessSubTimings(pos: integer; var id: TSchedId; var WkCentr : string; var Process : string; var Res : string; var CatRes : string);
    procedure UpdateGrpTmg;
    procedure RecalcTimings(id: TSchedId);
    procedure SetOvplTargetRes(ResObj: TObject; OvlpChk : TypeOvlpChk; Setup : double);
    procedure GetOverlaps(var LowLimit, HighLimit: TDateTime);
    function  GetAllCalendarsForEfficiencyOnWcOrResourceLevel(CalCode : string; EfficiencyOnLevel : CEfficiencyOnLevel; workCenter : Pointer) : TList;
//Old overlap    function  GetOverlapRule(wkcCode, wkcProc, resCode, resCat: string): PTMOvlpRuleRec;
//Old overlap    function  GetOverlapQty(wkcCode, wkcProc, resCode, resCat, um: string): PTMOvlpQtyRec;

    // reporting functions
    procedure PrintCompatReport(sl: TStringList);
    procedure PrintResourceReport(sl: TStringList);

    procedure RescheduledMcmListOfIds(ptr : pointer);
    function  PrepareMcmJobsInListForReSchedule(ProgBar: TMqmProgBar; Status: TStaticText) : boolean;
    function  ReorganizeAllIgnoredProgress(OnStart : boolean; ProgBar: TMqmProgBar; Status: TStaticText): boolean;
    function  ReorganizeAllProgress(OnStart : boolean; ProgBar: TMqmProgBar; Status: TStaticText): boolean;
    function  ReorganizeAll(ProgBar: TMqmProgBar; Status: TStaticText): boolean;
    function  SetSavedScheduleDate(List : TList) : boolean;
    function  RemoveAllCapRes(ProgBar: TMqmProgBar; Status: TStaticText): boolean;
    function  ReorganizeAllAfterOrBeforeToday(ProgBar: TMqmProgBar; ptr : pointer; BeforeNow : boolean) : boolean;
    function  ReorganizeAllAfterOrBeforeTodayByActTab(ProgBar: TMqmProgBar; ptr : pointer; List : TList; BeforeNow : boolean) : boolean;

    procedure ClearCalendar;
    procedure UpdateClientForCapResChanges(qry : TMqmQuery; DispoList : TStringList; ProgBar: TMqmProgBar);
    function CalcLowestScheduledDate(Id : TSchedId; MinJobResComp : integer; ResList : TList) : TDatetime;
    procedure SavedPlanCopy(SET_NAME, SET_DESC : string; StartDate, EndDate : TDateTime; ListSavedPlanCopy : TList);
    procedure ClearSavedPlanCopyList;

    property p_WrkCtrsCount: integer         read WrkCtrsCount;
    property p_WrkCtr[i: integer]: TMqmObj   read GetMqmWrkCtr;
    property p_ResCatCount: integer          read ResCatCount;
    property p_ResCat[i: integer]: TMqmObj   read GetMqmResCat;
    property p_ObjToDelCount: integer        read ObjToDelCount;
    property p_ObjToDel[i: integer]: TMqmObj read GetObjToDel;
    property p_AllWrkCtr: TList              read GetAllMqmWrkCtr;
    property p_ResList : TList               read m_ResList;
    property p_GetRes[I: Integer]: Pointer   read GetRes;
    property p_ResCount : integer            read ResCount;
    property p_SavedPlanCopyList : TList     read m_SavedPlanCopy;
    property p_GetSavedPlanCopyCount: integer   read GetSavePLanCopyCount;
  end;

implementation

uses
  SysUtils,
  Dialogs,
  Variants,
  FGInfo,
  UMCompatSrv,
  UMWkCtr,
  UMActArea,
  UMTblDesc,
  UMPlanObj,
  UMProdLine,
  UMGlobal,
  UMDurObj,
  UMCapRes,
  UMCompat,
  UMStoredProc,
  UMObjCont,
  UMCompatRules,
  UMProdLineActPer,
  UMSchedObjMover,
  UMBinFunc,
  UMOverlap,
  FMCapResDynamic,
  FMCapResDynamicDetails,
  Graphics,
  DateUtils,
  UMRes,
  UMWarp,
  UMArticles,
  UMAutoSchedCfg,
  UMSchedOnPlan,
  UMExternalDatabaseOperation,
  UGbaseCal, DB, UMReportExport, FMCompareSavedBuckets;

//----------------------------------------------------------------------------//

constructor TMqmPlan.CreatePlan(schedCont: TMSchedCont);
begin
  inherited Create;

  m_compId    := CSchedIdNull;
  m_visRes    := nil;
  m_calcTmg   := TMCalcTimings.CreateCalc;
//Old overlap  m_OvplRules := TMOvlpRules.Create;
  m_calcOvlp  := TMCalcOverlaps.CreateOvlp;
  m_schedCont := schedCont;
  m_WrkCtrs   := TList.Create;
  m_AltWrkCtrs := TList.Create;
  m_AltWrkCtrsGen := TList.Create;
  m_ResCatList:= TList.Create;
  m_ResList   := TList.Create;
  m_ObjToDelList := TList.Create;
  m_ObjWarpNonScheduledToUpdateList := TList.Create;
  m_objListSrv := TObjListSrv.Create;
  m_SavedPlanCopy   := TList.Create;

//  m_Today := Trunc(now);
{  m_Today := GetDateForPlanLine;
  m_todayAlgn := m_Today  }

  m_Today := now;
  m_todayAlgn := GetDateForPlanLine;


end;

//----------------------------------------------------------------------------//

destructor TMqmPlan.Destroy;
var
  i: integer;
  Rec : PAltWkcRec;
begin
  Clear;
  m_calcTmg.Free;
  m_calcOvlp.Free;

  for i := 0 to m_ResList.Count-1 do
    TMqmRes(m_ResList[i]).Destroy;
  m_ResList.Free;
  m_ResList := nil;

  for i := 0 to m_ResCatList.Count-1 do
    TMqmResCat(m_ResCatList[i]).Destroy;
  m_ResCatList.Free;
  m_ResCatList := nil;

  for i := 0 to m_WrkCtrs.Count-1 do
    TMqmWrkCtr(m_WrkCtrs[i]).Destroy;
  m_WrkCtrs.Free;
  m_WrkCtrs := nil;

  for i := 0 to m_AltWrkCtrs.count-1 do
  begin
    Rec := PAltWkcRec(m_AltWrkCtrs[i]);
    Dispose(Rec)
  end;
  m_AltWrkCtrs.Free;
  m_AltWrkCtrs := nil;

  for i := 0 to m_AltWrkCtrsGen.count-1 do
  begin
    Rec := PAltWkcRec(m_AltWrkCtrsGen[i]);
    Dispose(Rec)
  end;
  m_AltWrkCtrsGen.Free;
  m_AltWrkCtrsGen := nil;

  for i := 0 to m_ObjToDelList.Count-1 do
  begin
    if not(TMqmPlanObj(m_ObjToDelList[i]) is TMqmWarp) then
      TMqmPlanObj(m_ObjToDelList[i]).Destroy;
  end;

  m_ObjToDelList.clear;
  m_ObjToDelList.Free;
  m_ObjToDelList := nil;

  for i := m_ObjWarpNonScheduledToUpdateList.Count - 1 downto 0 do
    TMqmPlanObj(m_ObjWarpNonScheduledToUpdateList[i]).free;

  m_ObjWarpNonScheduledToUpdateList.Free;
  m_ObjWarpNonScheduledToUpdateList := nil;

  ClearSavedPlanCopyList;
  m_SavedPlanCopy.free;
  m_objListSrv.Free;
  m_objListSrv := nil;
  inherited Destroy
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.Clear;
var
  i: integer;
begin
  for i := 0 to m_WrkCtrs.Count-1 do
    TMqmWrkCtr(m_WrkCtrs[i]).Free;
  m_WrkCtrs.Clear;

  for i := 0 to m_ResList.Count-1 do
    TMqmRes(m_ResList[i]).free;
  m_ResList.clear;
end;

//----------------------------------------------------------------------------//

function TMqmPlan.WrkCtrsCount: integer;
begin
  if Assigned(m_WrkCtrs) then
    Result := m_WrkCtrs.Count
  else
    Result := 0
end;

//----------------------------------------------------------------------------//

function TMqmPlan.GetMqmWrkCtr(i: integer): TMqmObj;
begin
  Assert(Assigned(m_WrkCtrs));
  if i >= m_WrkCtrs.Count then
    Result := nil
  else
    Result := m_WrkCtrs[i]
end;

//----------------------------------------------------------------------------//

function TMqmPlan.ResCatCount: Integer;
begin
  if Assigned(m_ResCatList) then
    Result := m_ResCatList.Count
  else
    Result := 0
end;

//----------------------------------------------------------------------------//

function TMqmPlan.GetMqmResCat(i: integer): TMqmObj;
begin
  Assert(Assigned(m_ResCatList));
  if i >= m_ResCatList.Count then
    Result := nil
  else
    Result := m_ResCatList[i]
end;

//----------------------------------------------------------------------------//

function TMqmPlan.ObjToDelCount: integer;
begin
  if Assigned(m_ObjToDelList) then
    Result := m_ObjToDelList.Count
  else
    Result := 0
end;

//----------------------------------------------------------------------------//

function TMqmPlan.GetObjToDel(i: integer): TMqmObj;
begin
  Assert(Assigned(m_ObjToDelList));
  if i >= m_ObjToDelList.Count then
    Result := nil
  else
    Result := m_ObjToDelList[i]
end;

//----------------------------------------------------------------------------//

function TMqmPlan.GetAllMqmWrkCtr : TList;
begin
  if not Assigned(m_WrkCtrs) then
    Result := nil
  else
    Result := m_WrkCtrs;
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.AddWorkcenter(WrkCtr: TMqmObj);
begin
  if not Assigned(m_WrkCtrs) then
    m_WrkCtrs := TList.Create;

  m_WrkCtrs.Add(WrkCtr);
  TMqmPlanObj(WrkCtr).p_Father := nil;
  WrkCtr.m_Plan := self
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.UpdateNonScheduleObjWarp(Id : TSchedId);
var
  I : Integer;
  MqmWarp : TMqmWarp;
  foundObj : boolean;
begin
  foundObj := false;
  if not Assigned(m_ObjWarpNonScheduledToUpdateList) then
    m_ObjWarpNonScheduledToUpdateList := TList.Create;

  for I := 0 to m_ObjWarpNonScheduledToUpdateList.Count - 1 do
  begin
    MqmWarp := TMqmWarp(m_ObjWarpNonScheduledToUpdateList[i]);
    if Id = MqmWarp.Get_M_id then
    begin
      foundObj := true;
      break
    end;
  end;

  if not foundObj then
  begin
    MqmWarp := TMqmWarp.CreateWarpNonSchedule(Id);
    AddObjWarpNonScheduleToUpdate(MqmWarp)
  end;

end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.AddObjWarpNonScheduleToUpdate(ObjToUpdate: TMqmObj);
begin
  if not Assigned(m_ObjWarpNonScheduledToUpdateList) then
    m_ObjWarpNonScheduledToUpdateList := TList.Create;

  m_ObjWarpNonScheduledToUpdateList.Add(ObjToUpdate);
  TMqmPlanObj(ObjToUpdate).p_Father := nil;
  ObjToUpdate.m_Plan := self
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.AddObjToDele(ObjToDele: TMqmObj);
begin
  if not Assigned(m_ObjToDelList) then
    m_ObjToDelList := TList.Create;

  m_ObjToDelList.Add(ObjToDele);
  TMqmPlanObj(ObjToDele).p_Father := nil;
  ObjToDele.m_Plan := self
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.PlanLinkJob(link: string; id: TSchedID; ptr: pointer);
var
  res:      TMqmRes;
  visRes:   TMqmVisibleRes;
  linkInfo: TSQlinkInfo;
  actArea:  TMqmActArea;
  ProgInfo: TSQProgInfo;
//  deltaSetup: double;
begin
  res := TMqmRes(FindResByCode(link));
  if not Assigned(res) then exit;

  p_sc.GetLinkInfo(id, linkInfo);
  p_sc.GetProgInfo(id, ProgInfo);

  if not res.p_isMultiRes then
    visRes := res.p_VisRes[0]
  else
  begin
    visRes := res.GetSubRes(linkInfo.subLinRscId);
    if not Assigned(visRes) then exit;
  end;

  if (linkInfo.schedStart = 0) and (ProgInfo.ProgType <> '') then
    actArea := TMqmActArea(visRes.FindActForDate(ProgInfo.PrgSt))
  else
    actArea := TMqmActArea(visRes.FindActForDate(linkInfo.schedStart));
  if not Assigned(actArea) then
  begin
    p_sc.SetExtLinkPtr(id, nil);
    exit
  end
  else
    actArea.AddSchedObj(id);

  if (Trim(progInfo.ProgType) <> '') and (p_sc.GetSchedType(id) <> '2') then
    p_opStack.SetSchedType(id, '2');

end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.UpdatePlanLinkJob(link: string; id: TSchedID; ptr: pointer);
var
  res:      TMqmRes;
  visRes:   TMqmVisibleRes;
  linkInfo: TSQlinkInfo;
  actArea:  TMqmActArea;
begin
  actArea := TMqmActArea(p_sc.GetExtLinkPtr(id));
  if Assigned(actArea) then
  begin
    actArea.RemoveSchedObj(id);
    p_sc.UpdateBalance(id);
  end;

  if link <> CSnoResCode then
  begin
    res := TMqmRes(FindResByCode(link));
    if not Assigned(res) then exit;

    p_sc.GetLinkInfo(id, linkInfo);

    if not res.p_isMultiRes then
      visRes := res.p_VisRes[0]
    else
    begin
      visRes := res.GetSubRes(linkInfo.subLinRscId);
      if not Assigned(visRes) then exit;
    end;

    actArea := TMqmActArea(visRes.FindActForDate(linkInfo.schedStart));
    if Assigned(actArea) then
      actArea.AddSchedObj(id)
    else
      p_sc.SetExtLinkPtr(id, nil)
  end;
  p_sc.InvalidateToBeSched(id);
  p_sc.SetOvlpUpdate(id, true);
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.UpdatePlanLinkJobAutoSeq(resObj: TObject; id: TSchedID; ptr: pointer);
var
  visRes:   TMqmVisibleRes;
  linkInfo: TSQlinkInfo;
  actArea:  TMqmActArea;
begin
  visRes := TMqmVisibleRes(resObj);
  if not Assigned(visRes) then exit;

  p_sc.GetLinkInfo(id, linkInfo);

  actArea := TMqmActArea(TMqmVisibleRes(visRes).FindActForDate(linkInfo.schedStart));
  if Assigned(actArea) then
    actArea.AddSchedObj(id)
  else
    p_sc.SetExtLinkPtr(id, nil);

  p_sc.InvalidateToBeSched(id);
  p_sc.SetOvlpUpdate(id, true);
end;

//----------------------------------------------------------------------------//

function TMqmPlan.GetVisResCode(ptr: pointer): string;
var
  res: TMqmRes;
begin
  res := TMqmRes(TMqmActArea(ptr).p_father.p_father);
  Result := res.p_ResCode
end;

//----------------------------------------------------------------------------//

function TMqmPlan.ChangesMade: boolean;
var
  i,j,y,k: integer;
  res: TMqmRes;
  VisRes: TMqmVisibleRes;
  ActArea: TMqmActArea;
  CapRes: TMqmCapRes;
begin
  Result := false;

  if m_ObjToDelList.Count > 0 then
  begin
    Result := true;
    exit
  end;

  for i := 0 to m_ResList.Count-1 do
  begin
    res := m_ResList[i];
    for j := 0 to res.p_VisResCount -1 do
    begin
      VisRes := res.p_VisRes[j];
      for y := 0 to VisRes.p_ActAreasCount -1 do
      begin
        ActArea := TMqmActArea(VisRes.p_ActArea[y]);
        if (ActArea.m_status in [CDUR_new, CDUR_modi]) then
        begin
          Result := true;
          exit
        end else
        begin
          for k := 0 to ActArea.p_CapResCount -1 do
          begin
            CapRes := TMqmCapRes(ActArea.p_CapRes[k]);
            if (CapRes.m_status in [CDUR_new, CDUR_modi]) then
            begin
              Result := true;
              exit
            end
          end
        end;
      end;
    end;
  end;

  if m_schedCont.ChangesMade then
    Result := true;
end;

//----------------------------------------------------------------------------//

function TMqmPlan.BuildWkcDailyCapacity(VisResList : TList; ProgBar: TMqmProgBar; Status: TStaticText) : boolean;
var
  I, J : Integer;
  WcCodeList : TStringList;
  VisRes : TMqmVisibleRes;
  Res    : TMqmRes;
  WrkCtr : TMqmWrkCtr;
  ActArea : TMqmActArea;
  Id      : TschedId;
  MinStartDate, MaxEndDate : TDateTime;
  FirstDayStartMonth, LastDayEndMonth : TDate;
  errSet : SetOfErrors;
  DummyList : TList;
  value : Variant;
  datatype : CBinColValType;
  Properties : TProperties;
  MultiResList : TStringList;
 // st : TSlotDisplayCustomizeRec;

  function CheckCodeInList(WcCodeList : TStringList; WcCode : string) : boolean;
  begin
    result := true;
    if WcCodeList.IndexOf(WcCode) = -1 then
    begin
      result := false;
      WcCodeList.add(WcCode)
    end;
  end;

begin
  WcCodeList := TStringList.Create;
  MinStartDate := 0;
  MaxEndDate   := 0;
  DummyList := nil;

  Result := true;

  if Assigned(Status) then
    Status.Caption := _('Reorganization of the work centers ...');

  Application.ProcessMessages;

  if Assigned(ProgBar) then
  begin
    ProgBar.SetPosition(0);
    ProgBar.SetMax(VisResList.Count);
  end;

  for I := 0 to VisResList.Count - 1 do
  begin
    VisRes := TMqmVisibleRes(VisResList[i]);
    Res := TMqmRes(TMqmVisibleRes(VisRes).p_father);
    WrkCtr := TMqmWrkCtr(res.p_father);
    CheckCodeInList(WcCodeList , WrkCtr.p_WrkCtrCode);
  end;

  for I := 0 to WcCodeList.Count - 1 do
  begin
    WrkCtr := TMqmWrkCtr(FindWrkCtrByCode(WcCodeList[I]));
    WrkCtr.CleanWkcDailyCapacityList
  end;

  WcCodeList.Clear;

  for I := 0 to VisResList.Count - 1 do
  begin
    if Assigned(ProgBar) then
       ProgBar.SetPosition(I + 1);
      //ProgBar.SelEnd := I + 1;
    try
    Application.ProcessMessages;
    VisRes := TMqmVisibleRes(VisResList[i]);
    Res := TMqmRes(TMqmVisibleRes(VisRes).p_father);

    WrkCtr := TMqmWrkCtr(res.p_father);
    ActArea := TMqmActArea(VisRes.p_ActArea[0]);
    if ActArea.GetSchedObj(0) = CSchedIDnull then continue;

    if not CheckCodeInList(WcCodeList , WrkCtr.p_WrkCtrCode) then
    begin
      WrkCtr.CleanWkcDailyCapacityList;
    //  WrkCtr.CleanWkcCategoryDailyCapacityList(false);
    end;

    for J := 0 to ActArea.p_ObjCount - 1 do
    begin
      Application.ProcessMessages;
      id := ActArea.GetSchedObj(j);
      errSet := [];
      p_sc.GetFldValue(Id, CSC_QtyToSched, value, dataType);

      Properties := p_sc.GetProperties(Id,nil);
      if not Properties.GetValforCode(DBAppGlobals.MCMCustomProp, '', -1, Value) then
         Value := 0
      else
      begin
        {if not VarIsStr(Value) then
        begin
          Value := IntToStr(Value);
        end;  }
      end;

      p_sc.CheckErrors(id, CSEG_All, errSet, DummyList);
      WrkCtr.AddIdToWkcDailyCapacityList(Id, ActArea, MinStartDate, MaxEndDate, errSet, Value);
    end;
    except
      Result := false
    end

  end;

  if MaxEndDate = 999999 then
    MaxEndDate := MinStartDate + 1000;  //add 3 years from minimum

  FirstDayStartMonth := Trunc(FDOM(MinStartDate));
  LastDayEndMonth    := Trunc(LDOM(MaxEndDate + 7));

  MultiResList := TStringList.Create;

  if Assigned(Status) then
    Status.Caption := _('Add hours available to work center capacity ...');

  Application.ProcessMessages;

  if Assigned(ProgBar) then
  begin
    ProgBar.SetPosition(0);
    ProgBar.SetMax(VisResList.Count);
  end;

  for I := 0 to VisResList.Count - 1 do
  begin
    if Assigned(ProgBar) then
       ProgBar.SetPosition(I + 1);

    Application.ProcessMessages;
    VisRes := TMqmVisibleRes(VisResList[i]);
    Res := TMqmRes(TMqmVisibleRes(VisRes).p_father);
    if Res.p_PlanType <> RPT_Real then continue;
    WrkCtr := TMqmWrkCtr(res.p_father);
    ActArea := TMqmActArea(VisRes.p_ActArea[0]);
    if Res.p_isMultiRes then
    begin
      if MultiResList.IndexOf(Res.p_ResCode) = -1 then
      begin
        MultiResList.Add(Res.p_ResCode);
        WrkCtr.AddHoursAvailableToWkcCapacity(ActArea, FirstDayStartMonth, LastDayEndMonth);
      end;
    end
    else
      WrkCtr.AddHoursAvailableToWkcCapacity(ActArea, FirstDayStartMonth, LastDayEndMonth)
  end;
  WcCodeList.Free;
  MultiResList.Free;

  if Assigned(ProgBar) then
    ProgBar.SetPosition(0);
  if Assigned(Status) then
    Status.Caption := '';

end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.BuildWkcDailyEntityCapacity(VisResList: TList; EntityType : Integer; PropCode : string);
var
  I, J : Integer;
  WcCodeList : TStringList;
  Code : string;
  VisRes : TMqmVisibleRes;
  Res    : TMqmRes;
  WrkCtr : TMqmWrkCtr;
  ActArea : TMqmActArea;
  Id      : TschedId;
  MinStartDate, MaxEndDate : TDateTime;
  FirstDayStartMonth, LastDayEndMonth : TDate;
  errSet : SetOfErrors;
  Properties : TProperties;
  JobVal : variant;
  DummyList : TList;
  var PropMultiQty : Double;

  function CheckCodeInList(CodeList : TStringList; WcCode : string) : boolean;
  begin
    result := true;
    if CodeList.IndexOf(WcCode) = -1 then
    begin
      result := false;
      CodeList.add(WcCode)
    end;
  end;

begin
  WcCodeList := TStringList.Create;
  MinStartDate := 0;
  MaxEndDate   := 0;
  DummyList := nil;
  for I := 0 to VisResList.Count - 1 do
  begin
    Application.ProcessMessages;
    VisRes := TMqmVisibleRes(VisResList[i]);
    Res := TMqmRes(TMqmVisibleRes(VisRes).p_father);
    WrkCtr := TMqmWrkCtr(res.p_father);
    ActArea := TMqmActArea(VisRes.p_ActArea[0]);

    if not CheckCodeInList(WcCodeList , WrkCtr.p_WrkCtrCode) then
      WrkCtr.CleanWkcEntityDailyCapacityList;

//    if EntityType = 1 then // res Category
//      WrkCtr.AddCodeToWkcCapacityEntity(Res.m_ResCat.p_ResCatCode, Res.m_ResCat.p_ResCatDesc, 1);

    if ActArea.GetSchedObj(0) = CSchedIDnull then continue;

    for J := 0 to ActArea.p_ObjCount - 1 do
    begin
      Application.ProcessMessages;
      id := ActArea.GetSchedObj(j);
      if EntityType = 1 then // res Category
      begin
        WrkCtr.AddCodeToWkcCapacityEntity(Res.m_ResCat.p_ResCatCode, Res.m_ResCat.p_ResCatDesc,'', 1);
        Code := Res.m_ResCat.p_ResCatCode;
      end
      else if EntityType = 2 then // property
      begin
        Properties := p_sc.GetProperties(Id,nil);
        if not Properties.GetValforCode(PropCode, '', -1, JobVal) then
           code := ''
        else
        begin
          if VarIsStr(JobVal) then
            code := JobVal
          else
          begin
            PropMultiQty := JobVal;
            code := JobVal;
          end;
        end;
        WrkCtr.AddCodeToWkcCapacityEntity(code, '' , PropCode, 2);
      end;

      errSet := [];
      p_sc.CheckErrors(id, CSEG_All, errSet, DummyList);
      WrkCtr.AddIdToWkcDailyCapacityEntityList(Code, Id, ActArea, MinStartDate, MaxEndDate, errSet, PropMultiQty);
    end;
  end;

  FirstDayStartMonth := Trunc(FDOM(MinStartDate));
  LastDayEndMonth    := Trunc(LDOM(MaxEndDate + 7));

  for I := 0 to VisResList.Count - 1 do
  begin
    Application.ProcessMessages;
    VisRes := TMqmVisibleRes(VisResList[i]);
    Res := TMqmRes(TMqmVisibleRes(VisRes).p_father);
    code := res.p_ResCode;
    WrkCtr := TMqmWrkCtr(res.p_father);
    ActArea := TMqmActArea(VisRes.p_ActArea[0]);
    if ActArea.SchedObjsCount = 0 then continue;

    if EntityType = 1 then // res Category
      Code := Res.m_ResCat.p_ResCatCode
    else if EntityType = 2 then // property
    begin
      Properties := p_sc.GetProperties(Id,nil);
      if not Properties.GetValforCode(PropCode, '', -1, JobVal) then
         code := ''
      else
      begin
        if VarIsStr(JobVal) then
          code := JobVal
        else
        begin
          //code := IntToStr(JobVal);
          code := JobVal;
        end;
      end;
    end;

    if //(EntityType = 1) and
    WrkCtr.CheckCodeInWkcCapacityEntity(code) then
      WrkCtr.AddHoursAvailableToWkcEntityCapacity(Code, ActArea, FirstDayStartMonth, LastDayEndMonth);
  end;

  WcCodeList.Free;
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.SetTmgTargetResForGroup(resObj: TObject);
begin
  Assert(resObj is TMqmRes);
  m_calcTmg.SetTargetRes(resObj)
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.SaveSharedComment(Id : TSchedId; Comment : string; updNum : Integer);
var
  qry: TMqmQuery;
  tbInfo : ^TTblInfo;
  SqlStr : string;
  FieldVal : variant;
  dataType: CBinColValType;
  Request : string;
  step, SubStep, ReProcess : Integer;
begin
  qry := CreateQuery(Main_DB);
  Qry.Transaction := CreateTransaction(Main_DB);
  Qry.Transaction.StartTransaction;

  tbInfo := @tblInfo[tbl_prod_sched_shared_data];

  p_sc.GetFldValue(Id, CSC_ProdReq, FieldVal, dataType);
  Request := FieldVal;
  p_sc.GetFldValue(Id, CSC_ProdStep, FieldVal, dataType);
  step := FieldVal;
  p_sc.GetFldValue(Id, CSC_ProdSubStep, FieldVal, dataType);
  SubStep := FieldVal;
  p_sc.GetFldValue(Id, CSC_ReprocNo, FieldVal, dataType);
  ReProcess := FieldVal;

  with qry do
  begin

    SQL.Clear;
    SqlStr := 'select * ';
    SqlStr := SqlStr + ' from ' + tbInfo.GetTableName;
    SqlStr := SqlStr + WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier));
    SqlStr := SqlStr + ' AND ' + CreateFld(tbInfo.pfx, fli_preqNo)   + '=''' + Request + '''';
    SqlStr := SqlStr + ' and ' + CreateFld(tbInfo.pfx, fli_pstepId)  + '=''' + IntToStr(Step) + '''';
    SqlStr := SqlStr + ' and ' + CreateFld(tbInfo.pfx, fli_psubstId) + '=''' + IntToStr(SubStep) + '''';
    SqlStr := SqlStr + ' and ' + CreateFld(tbInfo.pfx, fli_reprocNo) + '=''' + IntToStr(ReProcess) + '''';
    sql.Text := SqlStr;
    Open;

    if EOF then
    begin
      Application.ProcessMessages;
      SQL.Clear;

      SqlStr := '';
      SqlStr := SqlStr + 'insert into ' + tbInfo.GetTableName     + '(';
      SqlStr := SqlStr + CreateFld(tbInfo.pfx,fli_Identifier) + ',';
      SqlStr := SqlStr + CreateFld(tbInfo.pfx,fli_preqNo)   + ',';
      SqlStr := SqlStr + CreateFld(tbInfo.pfx,fli_pstepId)  + ',';
      SqlStr := SqlStr + CreateFld(tbInfo.pfx,fli_psubstId) + ',';
      SqlStr := SqlStr + CreateFld(tbInfo.pfx,fli_reprocNo) + ',';
      SqlStr := SqlStr + CreateFld(tbInfo.pfx,fli_Comment)  + ',';
      SqlStr := SqlStr + CreateFld(tbInfo.pfx,fli_updCode)  + ',';
      SqlStr := SqlStr + CreateFld(tbInfo.pfx,fli_usrCr)    + ',';
      SqlStr := SqlStr + CreateFld(tbInfo.pfx,fli_usrTmCr);

      SqlStr := SqlStr + ') values (';
      SqlStr := SqlStr + ':' + CreateFld(tbInfo.pfx,fli_Identifier) + ',';
      SqlStr := SqlStr + ':' + CreateFld(tbInfo.pfx,fli_preqNo)   + ',';
      SqlStr := SqlStr + ':' + CreateFld(tbInfo.pfx,fli_pstepId)  + ',';
      SqlStr := SqlStr + ':' + CreateFld(tbInfo.pfx,fli_psubstId) + ',';
      SqlStr := SqlStr + ':' + CreateFld(tbInfo.pfx,fli_reprocNo) + ',';
      SqlStr := SqlStr + ':' + CreateFld(tbInfo.pfx,fli_Comment)  + ',';
      SqlStr := SqlStr + ':' + CreateFld(tbInfo.pfx,fli_updCode)  + ',';
      SqlStr := SqlStr + ':' + CreateFld(tbInfo.pfx,fli_usrCr)    + ',';
      SqlStr := SqlStr + ':' + CreateFld(tbInfo.pfx,fli_usrTmCr);
      SqlStr := SqlStr + ')';
      sql.Text  := SqlStr;
    //  Prepare;

      ParamByName(CreateFld(tbInfo.pfx,fli_Identifier)).AsString   := IniAppGlobals.Identifier;
      ParamByName(CreateFld(tbInfo.pfx,fli_preqNo)).AsString       := request;
      ParamByName(CreateFld(tbInfo.pfx,fli_pstepId)).AsInteger     := step;
      ParamByName(CreateFld(tbInfo.pfx,fli_psubstId)).AsInteger    := SubStep;
      ParamByName(CreateFld(tbInfo.pfx,fli_reprocNo)).AsInteger    := ReProcess;
      ParamByName(CreateFld(tbInfo.pfx,fli_Comment)).AsString      := Comment;
      ParamByName(CreateFld(tbInfo.pfx,fli_updCode)).AsInteger     := updNum + 1;
      ParamByName(CreateFld(tbInfo.pfx,fli_usrCr)).AsString        := IniAppGlobals.WkstCode;
      ParamByName(CreateFld(tbInfo.pfx,fli_usrTmCr)).AsDateTime    := now;
      ExecSQL;

    end
    else
    begin
      SqlStr := 'update ' + tbInfo.GetTableName + ' set ';
      SqlStr := SqlStr + CreateFld(tbInfo.pfx, fli_Comment) + ' = ';
      SqlStr := SqlStr + ':' + CreateFld(tbInfo.pfx, fli_Comment)  + ',';
      SqlStr := SqlStr + CreateFld(tbInfo.pfx, fli_updCode) + ' = ';
      SqlStr := SqlStr + ':' + CreateFld(tbInfo.pfx, fli_updCode)  + ',';
      SqlStr := SqlStr + CreateFld(tbInfo.pfx, fli_usrCg) + ' = ';
      SqlStr := SqlStr + ':' + CreateFld(tbInfo.pfx, fli_usrCg)  + ',';
      SqlStr := SqlStr + CreateFld(tbInfo.pfx, fli_usrTmCg) + ' = ';
      SqlStr := SqlStr + ':' + CreateFld(tbInfo.pfx, fli_usrTmCg);
      SqlStr := SqlStr + ' where ';
      SqlStr := SqlStr + CreateFld(tbInfo.pfx, fli_preqNo)   + ' = ';
      SqlStr := SqlStr + ':' + CreateFld(tbInfo.pfx, fli_preqNo) + ' and ';
      SqlStr := SqlStr + CreateFld(tbInfo.pfx, fli_pstepId)   + ' = ';
      SqlStr := SqlStr + ':' + CreateFld(tbInfo.pfx, fli_pstepId) + ' and ';
      SqlStr := SqlStr + CreateFld(tbInfo.pfx, fli_psubstId)   + ' = ';
      SqlStr := SqlStr + ':' + CreateFld(tbInfo.pfx, fli_psubstId) + ' and ';
      SqlStr := SqlStr + CreateFld(tbInfo.pfx, fli_reprocNo)   + ' = ';
      SqlStr := SqlStr + ':' + CreateFld(tbInfo.pfx, fli_reprocNo) + ' and ';
      SqlStr := SqlStr + CreateFld(tbInfo.pfx, fli_Identifier)   + ' = ';
      SqlStr := SqlStr + ':' + CreateFld(tbInfo.pfx, fli_Identifier);

      SQL.Text := SqlStr;
    //  Prepare;
      ParamByName(CreateFld(tbInfo.pfx, fli_Identifier)).AsString := IniAppGlobals.identifier;
      ParamByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString    := Request;
      ParamByName(CreateFld(tbInfo.pfx, fli_pstepId)).AsInteger  := Step;
      ParamByName(CreateFld(tbInfo.pfx, fli_psubstId)).AsInteger := SubStep;
      ParamByName(CreateFld(tbInfo.pfx, fli_reprocNo)).AsInteger := ReProcess;
      ParamByName(CreateFld(tbInfo.pfx, fli_Comment)).AsString   := Comment;
      ParamByName(CreateFld(tbInfo.pfx, fli_updCode)).AsInteger  := updNum + 1;
      ParamByName(CreateFld(tbInfo.pfx, fli_usrCg)).AsString     := IniAppGlobals.WkstCode;
      ParamByName(CreateFld(tbInfo.pfx, fli_usrTmCg)).AsDateTime := now;
      ExecSQL;
    end;
  end;

  Qry.Transaction.commit;
  qry.Free;

end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.Load(ProgBar: TMqmProgBar; Status: TStaticText; ErrList: TStringList; UpdNum : integer; UpdNumSharedData : integer);
var
  qry: TMqmQuery;
begin
  Clear;
  CleanLog;
  m_corrUpd := UpdNum;
  m_corrUpdSharedDate := UpdNumSharedData;
  qry := CreateQuery(Main_DB);

  LoadCalendarCodeForEfficiencyOnResourceLevel;
  LoadCalendarCodeForEfficiencyOnWorkCenterLevel;
  LoadCalendarCodeForEfficiencyBothOnResourceLevel;

  LoadWorkcenters(qry, ProgBar, Status, ErrList);
  LoadAltWorkcenters(qry, ProgBar, Status, ErrList);

  LoadResources(qry, ProgBar, Status, ErrList);
  if (ErrList.Count > 0) then exit;
  LoadActPlanArea(qry, ProgBar, Status, ErrList);
  LoadResProperties(qry, ProgBar, Status, ErrList);
  if (ErrList.Count > 0) then exit;
  LoadResRules(qry, ProgBar, Status, ErrList);
  LoadOvlpRules(qry, ProgBar, Status, ErrList);

  LoadCapRes(qry, '', ProgBar, Status, ErrList);
  LoadCapResDynamic(qry, '', '', ProgBar, Status, ErrList);
  LoadCapResProperties(qry, '', ProgBar, Status, ErrList);

  qry.Close;

  qry.Free;

end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.LoadWorkcenters(qry: TMqmQuery; ProgBar: TMqmProgBar; Status: TStaticText; ErrList: TStringList);
var
  wkc, AlterWcObj : TMqmWrkCtr;
  ProdLine: TMqmProdLine;
  ActPeriod: TMqmProdLnAtcPer;
  tbInfoWkcWks,
  tbInfoWkc,
  tbInfoProces,
//  tbInfoPriority,
  tbAlternativ,
  tbInfoPrior,
  tbDependency,
  tbwkc_group,
  tbProdLines : ^TTblInfo;
  AltWc , AltWcProces : string;
  oldWkcCode, wkcCode, proc, TypeUse, Visible: string;
  ProcRec: PTWkcProcRec;
  PriorRec: PTWkcPriority;
  I,MCMSeq : Integer;
  WarpHandled : string;
  IgnoreProgress : boolean;
  WkcDependency: PTWkcDependency;
begin
//-----------
//  load Workcenters and Process
//-----------
  if Assigned(ProgBar) then
    ProgBar.SetPosition(0);
  if Assigned(Status) then
    Status.Caption := _('Reading workcenters and process from database...');

  tbInfoProces := @tblInfo[tbl_wkc_proc];
  tbInfoWkcWks := @tblInfo[tbl_wkst_wkc];
  tbInfoWkc := @tblInfo[tbl_wkc];
//  SetFldPfx(tbInfoWkcWks.pfx);

{$ifdef LOAD_TMNGS}
  StartInterval;
{$endif}

  with qry do
  begin
    Application.ProcessMessages;
    SQL.Clear;
    SQL.Add('select');
    SQL.Add(CreateFld(tbInfoWkcWks.pfx, fli_wkstCode)    + ',');
    SQL.Add(CreateFld(tbInfoWkcWks.pfx, fli_wkCtrCode)   + ',');
    SQL.Add(CreateFld(tbInfoProces.pfx, fli_wkcProc)   + ',');
    SQL.Add(CreateFld(tbInfoProces.pfx, fli_SDescr)   + ',');
    SQL.Add(CreateFld(tbInfoProces.pfx, fli_GroupType)+ ',');
  	SQL.Add(CreateFld(tbInfoProces.pfx, fli_ResOccupation)+ ',');
    SQL.Add(CreateFld(tbInfoProces.pfx, fli_UseAllResourceParts)+ ',');
    SQL.Add(CreateFld(tbInfoWkc.pfx, fli_SDescr)   + ',');
    SQL.Add(CreateFld(tbInfoWkc.pfx, fli_LDescr)   + ',');
    SQL.Add(CreateFld(tbInfoWkc.pfx, fli_PlantCode)   + ',');
    SQL.Add(CreateFld(tbInfoWkc.pfx, fli_wkCtrGroup)  + ',');
    SQL.Add(CreateFld(tbInfoWkcWks.pfx, fli_Visible)  + ',');
    SQL.Add(CreateFld(tbInfoWkcWks.pfx, fli_TypeOfUse)+ ',');
    SQL.Add(CreateFld(tbInfoWkc.pfx, fli_WarpHandle) + ',');
	SQL.Add(CreateFld(tbInfoWkc.pfx, fli_Ignoreprogress) + ',');
    SQL.Add(CreateFld(tbInfoWkc.pfx, fli_MCMSequence)+ ',');
    SQL.Add(CreateFld(tbInfoWkc.pfx, fli_Division));

    SQL.Add(' from ' + tbInfoWkcWks.GetTableName);
    SQL.Add(' left join ' + tbInfoProces.GetTableName + ' on ');
    SQL.Add(CreateFld(tbInfoWkcWks.pfx, fli_wkCtrCode) + '=' + CreateFld(tbInfoProces.pfx, fli_wkCtrCode));
    SQL.Add(' AND ' + CreateFld(tbInfoWkcWks.pfx, fli_Identifier) + '=' + CreateFld(tbInfoProces.pfx, fli_Identifier));
    SQL.Add(' left join ' + tbInfoWkc.GetTableName + ' on ');
    SQL.Add(CreateFld(tbInfoWkcWks.pfx, fli_wkCtrCode) + '=' + CreateFld(tbInfoWkc.pfx, fli_wkCtrCode));
    SQL.Add(' AND ' + CreateFld(tbInfoWkcWks.pfx, fli_Identifier) + '=' + CreateFld(tbInfoWkc.pfx, fli_Identifier));
    SQL.Add(' where ' + CreateFld(tbInfoWkcWks.pfx, fli_wkstCode) + '=');
    SQL.Add('''' + IniAppGlobals.WkstCode + '''');
    SQL.Add(AND_IDF_Condition(CreateFld(tbInfoWkcWks.pfx, fli_Identifier)));
    SQL.Add(' order by ' + CreateFld(tbInfoWkcWks.pfx, fli_wkCtrCode) +  ', ');
    SQL.Add(CreateFld(tbInfoProces.pfx, fli_wkcProc));
    Open;

    Application.ProcessMessages;

    if Assigned(ProgBar) then
      ProgBar.SetMax(2000);
    if Assigned(Status) then
      Status.Caption := _('Loading workcenters and process in memory...');

    Application.ProcessMessages;

    wkc        := nil;
    oldWkcCode := '';

    while not EOF do
    begin

      Application.ProcessMessages;

      wkcCode := FieldByName(CreateFld(tbInfoWkcWks.pfx, fli_wkCtrCode)).AsString;

      if (oldWkcCode <> wkcCode) then
      begin
        oldWkcCode := wkcCode;
        TypeUse := FieldByName(CreateFld(tbInfoWkcWks.pfx, fli_TypeOfUse)).AsString;
        Visible := FieldByName(CreateFld(tbInfoWkcWks.pfx, fli_Visible)).AsString;
        MCMSeq  := FieldByName(CreateFld(tbInfoWkc.pfx, fli_MCMSequence)).asinteger;
        WarpHandled := FieldByName(CreateFld(tbInfoWkc.pfx, fli_WarpHandle)).AsString;
        IgnoreProgress := false;
        if FieldByName(CreateFld(tbInfoWkc.pfx, fli_Ignoreprogress)).AsString = '1' then
          IgnoreProgress := true;

        wkc := TMqmWrkCtr.CreateWrkCtr(wkcCode);

        if Visible = '1' then
          wkc.P_Visible := true
        else
          wkc.P_Visible := false;

        if TypeUse = '1' then
          wkc.p_ReadOnly := false
        else
          wkc.p_ReadOnly := true;
        wkc.p_MCMSeq := MCMSeq;

        if WarpHandled = '1' then
          wkc.P_WarpLevl := Wc_BaseLvl
        else if WarpHandled = '2' then
          wkc.P_WarpLevl := Wc_BaseAndSecondLvl
        else
          wkc.P_WarpLevl := Wc_no;

        if (wkc.P_WarpLevl = Wc_BaseLvl) or (wkc.P_WarpLevl = Wc_BaseAndSecondLvl) then
           DBAppGlobals.IsWarpHandled := true;

        wkc.P_IgnoreProgress := IgnoreProgress;

        Application.ProcessMessages;

        New(ProcRec);
        ProcRec.proc   := FieldByName(CreateFld(tbInfoProces.pfx, fli_wkcProc)).AsString;
        ProcRec.ProcDesc := FieldByName(CreateFld(tbInfoProces.pfx, fli_SDescr)).AsString;
        ProcRec.UseAllMachineParts := Mp_All;
        if FieldByName(CreateFld(tbInfoProces.pfx, fli_UseAllResourceParts)).AsString = '0' then
        begin
          ProcRec.UseAllMachineParts := Mp_All;
          wkc.P_UseMachineParts := true;
        end
        else if FieldByName(CreateFld(tbInfoProces.pfx, fli_UseAllResourceParts)).AsString = '1' then
        begin
          ProcRec.UseAllMachineParts := Mp_RearPart;
          wkc.P_UseMachineParts := true;
        end
        else if FieldByName(CreateFld(tbInfoProces.pfx, fli_UseAllResourceParts)).AsString = '2' then
        begin
          ProcRec.UseAllMachineParts := Mp_FrontPart;
          wkc.P_UseMachineParts := true;
        end;
        ProcRec.RecPriority    := nil;
        ProcRec.AltProcList    := nil;
        ProcRec.DependencyList := nil;
        wkc.AddProcces(ProcRec);

        wkc.p_WrkCtrLDesc := FieldByName(CreateFld(tbInfoWkc.pfx, fli_LDescr)).AsString;
        wkc.p_WrkCtrSDesc := FieldByName(CreateFld(tbInfoWkc.pfx, fli_SDescr)).AsString;
        wkc.p_PlantCode   := FieldByName(CreateFld(tbInfoWkc.pfx, fli_PlantCode)).AsString;
        wkc.P_WcGrp       := FieldByName(CreateFld(tbInfoWkc.pfx, fli_wkCtrGroup)).AsString;
        wkc.p_Division    := FieldByName(CreateFld(tbInfoWkc.pfx, fli_Division)).AsString;

        AddWorkcenter(wkc);
      end else
      begin
        Application.ProcessMessages;

        New(ProcRec);
        ProcRec.proc     := FieldByName(CreateFld(tbInfoProces.pfx, fli_wkcProc)).AsString;
        ProcRec.ProcDesc := FieldByName(CreateFld(tbInfoProces.pfx, fli_SDescr)).AsString;
        ProcRec.UseAllMachineParts :=  Mp_All;
        if FieldByName(CreateFld(tbInfoProces.pfx, fli_UseAllResourceParts)).AsString = '0' then
        begin
          ProcRec.UseAllMachineParts := Mp_All;
          wkc.P_UseMachineParts := true;
        end
        else if FieldByName(CreateFld(tbInfoProces.pfx, fli_UseAllResourceParts)).AsString = '1' then
        begin
          ProcRec.UseAllMachineParts := Mp_RearPart;
          wkc.P_UseMachineParts := true;
        end
        else if FieldByName(CreateFld(tbInfoProces.pfx, fli_UseAllResourceParts)).AsString = '2' then
        begin
          ProcRec.UseAllMachineParts := Mp_FrontPart;
          wkc.P_UseMachineParts := true;
        end;
        ProcRec.RecPriority    := nil;
        ProcRec.AltProcList    := nil;
        ProcRec.DependencyList := nil;
        wkc.AddProcces(ProcRec);
      end;

      ProcRec.ResOccupation := CSResOcc_No;
      if (FieldByName(CreateFld(tbInfoProces.pfx, fli_ResOccupation)).AsString = '1') then
         ProcRec.ResOccupation := CSResOcc_Border
      else if (FieldByName(CreateFld(tbInfoProces.pfx, fli_ResOccupation)).AsString = '2') then
         ProcRec.ResOccupation := CSResOcc_Occupy;

      ProcRec.GroupingType := Single_grp;
      if (FieldByName(CreateFld(tbInfoProces.pfx, fli_GroupType)).IsNull) then
        ProcRec.GroupingType := Single_grp
      else
      begin
        if (FieldByName(CreateFld(tbInfoProces.pfx, fli_GroupType)).AsString = '0') then
          ProcRec.GroupingType := No_grp
        else if (FieldByName(CreateFld(tbInfoProces.pfx, fli_GroupType)).AsString = '1') then
          ProcRec.GroupingType := FromOtherStep_grp
        else if (FieldByName(CreateFld(tbInfoProces.pfx, fli_GroupType)).AsString = '2') then
          ProcRec.GroupingType := Single_grp
        else if (FieldByName(CreateFld(tbInfoProces.pfx, fli_GroupType)).AsString = '3') then
          ProcRec.GroupingType := MultiStepForward_grp
        else if (FieldByName(CreateFld(tbInfoProces.pfx, fli_GroupType)).AsString = '4') then
          ProcRec.GroupingType := MultiStepBackward_grp
        else if (FieldByName(CreateFld(tbInfoProces.pfx, fli_GroupType)).AsString = '5') then
          ProcRec.GroupingType := MultiStepForwardBackward_grp
      end;

      Next;
      if Assigned(ProgBar) then
        ProgBar.SetPosition(RecNo);
      Application.ProcessMessages;
    end;
    Close;
  end;

//-----------
//  load workcenters priorities
//-----------

  if Assigned(ProgBar) then
    ProgBar.SetPosition(0);
  if Assigned(Status) then
    Status.Caption := _('Reading workcenters priority from database...');

  Application.ProcessMessages;

  tbInfoPrior := @tblInfo[tbl_wkc_priority];

  with qry do
  begin
    SQL.Clear;
    SQL.Add('select');
    SQL.Add(CreateFld(tbInfoWkcWks.pfx, fli_wkstCode)    + ',');
    SQL.Add(CreateFld(tbInfoWkcWks.pfx, fli_wkCtrCode)   + ',');
    SQL.Add(CreateFld(tbInfoPrior.pfx, fli_wkCtrCode)         + ',');
    SQL.Add(CreateFld(tbInfoPrior.pfx, fli_wkcProc)           + ',');
    SQL.Add(CreateFld(tbInfoPrior.pfx, fli_SequenceDepend)    + ',');
    SQL.Add(CreateFld(tbInfoPrior.pfx, fli_SeqAlpha)          + ',');
    SQL.Add(CreateFld(tbInfoPrior.pfx, fli_PriorityRelation)  + ',');
    SQL.Add(CreateFld(tbInfoPrior.pfx, fli_Mach_stp_code_lvl));
    SQL.Add(' from ' + tbInfoWkcWks.GetTableName);
    SQL.Add(' join ' + tbInfoPrior.GetTableName + ' on ');
    SQL.Add(CreateFld(tbInfoWkcWks.pfx, fli_wkCtrCode) + '=' + CreateFld(tbInfoPrior.pfx, fli_wkCtrCode));
    SQL.Add(' AND ' + CreateFld(tbInfoWkcWks.pfx, fli_Identifier) + '=' + CreateFld(tbInfoPrior.pfx, fli_Identifier));
    SQL.Add(' where ' + CreateFld(tbInfoWkcWks.pfx, fli_wkstCode) + '=');
    SQL.Add('''' + IniAppGlobals.WkstCode + '''');
    SQL.Add(AND_IDF_Condition(CreateFld(tbInfoWkcWks.pfx, fli_Identifier)));
    SQL.Add('order by ' + CreateFld(tbInfoPrior.pfx, fli_wkCtrCode) + ', ');
    SQL.Add(CreateFld(tbInfoPrior.pfx, fli_wkcProc));
    Open;

    Application.ProcessMessages;

    if Assigned(ProgBar) then
      ProgBar.SetMax(2000);
    if Assigned(Status) then
      Status.Caption := _('Loading workcenters priority in memory...');

    wkc        := nil;
    oldWkcCode := '';

    while not EOF do
    begin

      Application.ProcessMessages;
      wkcCode := FieldByName(CreateFld(tbInfoPrior.pfx, fli_wkCtrCode)).AsString;

      if (oldWkcCode <> wkcCode) then
      begin
        oldWkcCode := wkcCode;
        wkc := TMqmWrkCtr(FindWrkCtrByCode(wkcCode));
      end;

      if wkc <> nil then
      begin
        ProcRec := wkc.P_WkcProcList.p_ProcByName[FieldByName(CreateFld(tbInfoPrior.pfx, fli_wkcProc)).AsString];
        if Assigned(ProcRec) then
        begin
          New(PriorRec);
          if FieldByName(CreateFld(tbInfoPrior.pfx, fli_SequenceDepend)).AsString = '0' then
            PriorRec.PriorInDispo := false
          else
            PriorRec.PriorInDispo := true;
          PriorRec.PrioritySeq := FieldByName(CreateFld(tbInfoPrior.pfx, fli_SeqAlpha)).AsString;
          case StrToInt(FieldByName(CreateFld(tbInfoPrior.pfx, fli_PriorityRelation)).AsString) of
            0: PriorRec.RelationType := pre_No;
            1: PriorRec.RelationType := pre_PrevDspPri;
            2: PriorRec.RelationType := pre_PrevDspStp;
            3: PriorRec.RelationType := pre_NextDspPri;
            4: PriorRec.RelationType := pre_NextDspStp;
          end;

          if Trim(FieldByName(CreateFld(tbInfoPrior.pfx, fli_Mach_stp_code_lvl)).AsString) = ''  then
          begin
            PriorRec.SetupHandleType := sht_No;
          end
          else
          begin
            case StrToInt(FieldByName(CreateFld(tbInfoPrior.pfx, fli_Mach_stp_code_lvl)).AsString) of
              0: PriorRec.SetupHandleType := sht_No;
              1: PriorRec.SetupHandleType := sht_Yes;
              2: PriorRec.SetupHandleType := sht_Cat;
              3: PriorRec.SetupHandleType := sht_Res;
            end;
          end;

          ProcRec.RecPriority := PriorRec
        end;
      end;
      Next;
      if Assigned(ProgBar) then
        ProgBar.SetPosition(RecNo);
      Application.ProcessMessages;
    end;
    Close;
  end;

//-----------
//  load workcenters dependency
//-----------

  if Assigned(ProgBar) then
    ProgBar.SetPosition(0);
  if Assigned(Status) then
    Status.Caption := _('Reading workcenters dependency from database...');

  Application.ProcessMessages;

  tbDependency := @tblInfo[tbl_wkc_dependency];

  with qry do
  begin
    SQL.Clear;
    SQL.Add('select *');
    SQL.Add(' from ' + tbInfoWkcWks.GetTableName);
    SQL.Add(' join ' + tbDependency.GetTableName + ' on ');
    SQL.Add(CreateFld(tbInfoWkcWks.pfx, fli_wkCtrCode) + '=' + CreateFld(tbDependency.pfx, fli_SchedWkc));
    SQL.Add(' AND ' + CreateFld(tbInfoWkcWks.pfx, fli_Identifier) + '=' + CreateFld(tbDependency.pfx, fli_Identifier));
    SQL.Add(' where ' + CreateFld(tbInfoWkcWks.pfx, fli_wkstCode) + '=');
    SQL.Add('''' + IniAppGlobals.WkstCode + '''');
    SQL.Add(AND_IDF_Condition(CreateFld(tbInfoWkcWks.pfx, fli_Identifier)));
    SQL.Add('order by ' + CreateFld(tbDependency.pfx, fli_SchedWkc) + ', ');
    SQL.Add(CreateFld(tbDependency.pfx, fli_SchedWkCtrProc));
    Open;

    Application.ProcessMessages;

    if Assigned(ProgBar) then
      ProgBar.SetMax(2000);
    if Assigned(Status) then
      Status.Caption := _('Loading workcenters dependency in memory...');

    wkc        := nil;
    oldWkcCode := '';

    while not EOF do
    begin

      Application.ProcessMessages;
      wkcCode := FieldByName(CreateFld(tbDependency.pfx, fli_SchedWkc)).AsString;

      if (oldWkcCode <> wkcCode) then
      begin
        oldWkcCode := wkcCode;
        wkc := TMqmWrkCtr(FindWrkCtrByCode(wkcCode));
      end;

      if wkc <> nil then
      begin
        ProcRec := wkc.P_WkcProcList.p_ProcByName[FieldByName(CreateFld(tbDependency.pfx, fli_SchedWkCtrProc)).AsString];
        if Assigned(ProcRec) then
        begin
          if not Assigned(ProcRec.DependencyList) then
            ProcRec.DependencyList := TWkcDepList.Create;
          New(WkcDependency);

          case StrToInt(FieldByName(CreateFld(tbDependency.pfx, fli_DependOn)).AsString) of
            1: WkcDependency.DependOn := dre_PrevStep;
            2: WkcDependency.DependOn := dre_PrevConnReq;
            3: WkcDependency.DependOn := dre_NextStep;
            4: WkcDependency.DependOn := dre_NextConnReq;
          else
            WkcDependency.DependOn := dre_No;
          end;
          WkcDependency.NotAlwdWC       := Trim(FieldByName(CreateFld(tbDependency.pfx, fli_NoSchedWkc)).AsString);
          WkcDependency.NotAlwdResCat   := Trim(FieldByName(CreateFld(tbDependency.pfx, fli_NoSchedRscCat)).AsString);
          WkcDependency.NotAlwdRes      := Trim(FieldByName(CreateFld(tbDependency.pfx, fli_NoSchedRsc)).AsString);
          WkcDependency.DepSchedOnWC    := Trim(FieldByName(CreateFld(tbDependency.pfx, fli_DepIsSchedWkc)).AsString);
          WkcDependency.DepSchedOnResCat:= Trim(FieldByName(CreateFld(tbDependency.pfx, fli_DepIsSchedRscCat)).AsString);
          WkcDependency.DepSchedOnRes   := Trim(FieldByName(CreateFld(tbDependency.pfx, fli_DepIsSchedRsc)).AsString);

          ProcRec.DependencyList.AddDep(WkcDependency)
        end;

      end;
      Next;
      if Assigned(ProgBar) then
        ProgBar.SetPosition(RecNo);

      Application.ProcessMessages;
    end;
    Close;
  end;

//-----------
//  load Production lines
//-----------

  if Assigned(ProgBar) then
    ProgBar.SetPosition(0);
  if Assigned(Status) then
    Status.Caption := _('Reading production lines from database...');

  Application.ProcessMessages;

  tbProdLines := @tblInfo[tbl_wkc_prodLine];
//  SetFldPfx(tbInfoWkcWks.pfx);

  with qry do
  begin
    SQL.Clear;
    SQL.Add('select');
    SQL.Add(CreateFld(tbInfoWkcWks.pfx, fli_wkstCode)    + ', ');
    SQL.Add(CreateFld(tbInfoWkcWks.pfx, fli_wkCtrCode)   + ', ');
    SQL.Add(CreateFld(tbProdLines.pfx, fli_ProdLine)  + ', ');
    SQL.Add(CreateFld(tbProdLines.pfx, fli_DateBegin) + ', ');
    SQL.Add(CreateFld(tbProdLines.pfx, fli_DateEnd)   + ', ');
    SQL.Add(CreateFld(tbProdLines.pfx, fli_NumResPlan));
    SQL.Add(' from ' + tbInfoWkcWks.GetTableName);
    SQL.Add(' right join ' + tbProdLines.GetTableName + ' on ');
    SQL.Add(CreateFld(tbInfoWkcWks.pfx, fli_wkCtrCode) + '=' + CreateFld(tbProdLines.pfx, fli_wkCtrCode));
    SQL.Add(' AND ' + CreateFld(tbInfoWkcWks.pfx, fli_Identifier) + '=' + CreateFld(tbProdLines.pfx, fli_Identifier));
    SQL.Add(' where ' + CreateFld(tbInfoWkcWks.pfx, fli_wkstCode) + '=');
    SQL.Add('''' + IniAppGlobals.WkstCode + '''');
    SQL.Add(AND_IDF_Condition(CreateFld(tbInfoWkcWks.pfx, fli_Identifier)));
    Open;

    if Assigned(ProgBar) then
      ProgBar.SetMax(2000);
    if Assigned(Status) then
      Status.Caption := _('Loading production lines in memory...');
    Application.ProcessMessages;

    while not EOF do
    begin
      Application.ProcessMessages;

      wkcCode := FieldByName(CreateFld(tbInfoWkcWks.pfx, fli_wkCtrCode)).AsString;
      wkc := TMqmWrkCtr(FindWrkCtrByCode(wkcCode));
      if wkc <> nil then
      begin
        ProdLine := TMqmProdLine.CreateProdLine(FieldByName(CreateFld(tbProdLines.pfx, fli_ProdLine)).AsString);
        wkc.AddProdLine(ProdLine);
        //Load Periods
        while (wkc.p_WrkCtrCode = FieldByName(CreateFld(tbInfoWkcWks.pfx, fli_wkCtrCode)).AsString)
        and (ProdLine.p_ProdLineCode = FieldByName(CreateFld(tbProdLines.pfx, fli_ProdLine)).AsString)
        and not EOF do
        begin
          Application.ProcessMessages;

          ActPeriod := TMqmProdLnAtcPer.CreateDurObj(self);
          ActPeriod.p_start  := FieldByName(CreateFld(tbProdLines.pfx, fli_DateBegin)).AsFloat;
          ActPeriod.p_end    := FieldByName(CreateFld(tbProdLines.pfx, fli_DateEnd)).AsFloat;
          ActPeriod.m_RscNum := FieldByName(CreateFld(tbProdLines.pfx, fli_NumResPlan)).AsInteger;
          ProdLine.AddActPeriod(ActPeriod);
          Next;
          if Assigned(ProgBar) then
            ProgBar.SetPosition(RecNo);
        end;
        Continue
      end;
      Next;
      if Assigned(ProgBar) then
        ProgBar.SetPosition(RecNo);

      Application.ProcessMessages;
    end;

    close;

  end;


//-----------
//  update main wc
//-----------

  if Assigned(ProgBar) then
    ProgBar.SetPosition(0);
  if Assigned(Status) then
    Status.Caption := _('Updating main work center from database...');

  Application.ProcessMessages;

  tbwkc_group := @tblInfo[tbl_wkc_group];

  for I := 0 to p_WrkCtrsCount - 1 do
  begin
    with qry do
    begin
      SQL.Clear;
      SQL.Add('select');
      SQL.Add(CreateFld(tbwkc_group.pfx, fli_MainWC) + ' ');
      SQL.Add(' from ' + tbwkc_group.GetTableName);
      SQL.Add(' where ' + CreateFld(tbwkc_group.pfx, fli_wkCtrGroup) + '=');
      SQL.Add('''' + TMqmWrkCtr(p_WrkCtr[i]).P_WcGrp + '''');
      SQL.Add(' and ' + CreateFld(tbwkc_group.pfx, fli_PlantCode) + '=');
      SQL.Add('''' + TMqmWrkCtr(p_WrkCtr[i]).p_PlantCode + '''');
      SQL.Add(AND_IDF_Condition(CreateFld(tbwkc_group.pfx, fli_Identifier)));
      Open;
      Application.ProcessMessages;

      if not EOF then
      begin
        Application.ProcessMessages;
        TMqmWrkCtr(p_WrkCtr[i]).p_WcMain := FieldByName(CreateFld(tbwkc_group.pfx, fli_MainWC)).AsString;
      end;
      close;

    end;
  end;


{$ifdef LOAD_TMNGS}
  LogAndStopInterval('end loading workcenters');
{$endif}

//-----------
//  load the alternatives
//-----------

  if Assigned(ProgBar) then
    ProgBar.SetPosition(0);
  if Assigned(Status) then
    Status.Caption := _('Reading alternative workcenters from database...');
  Application.ProcessMessages;

  tbAlternativ := @tblInfo[tbl_wkc_alt];
//  SetFldPfx(tbAlternativ.pfx);

//  qry.Transaction.StartTransaction;

  oldWkcCode := '';

  with qry do
  begin

    Application.ProcessMessages;
    SQL.Clear;
    SQL.Add('select');
    SQL.Add(CreateFld(tbAlternativ.pfx, fli_wkCtrCode)  + ',');
    SQL.Add(CreateFld(tbAlternativ.pfx, fli_wkcProc)    + ',');
    SQL.Add(CreateFld(tbAlternativ.pfx, fli_AlterWC)    + ',');
    SQL.Add(CreateFld(tbAlternativ.pfx, fli_AlterWCProces));
    SQL.Add(' from ' + tbAlternativ.GetTableName);
    SQL.Add(WHERE_IDF_Condition(CreateFld(tbAlternativ.pfx, fli_Identifier)));
    Open;

    if Assigned(ProgBar) then
      ProgBar.SetMax(2000);
    if Assigned(Status) then
      Status.Caption := _('Loading alternative workcenters in memory...');

    while not EOF do
    begin
      Application.ProcessMessages;

      wkcCode := FieldByName(CreateFld(tbAlternativ.pfx, fli_wkCtrCode)).AsString;
      wkc := TMqmWrkCtr(FindWrkCtrByCode(wkcCode));
      if wkc <> nil then
      begin
        proc := FieldByName(CreateFld(tbAlternativ.pfx, fli_wkcProc)).AsString;
        AltWc := FieldByName(CreateFld(tbAlternativ.pfx, fli_AlterWC)).AsString;
        AltWcProces := FieldByName(CreateFld(tbAlternativ.pfx, fli_AlterWCProces)).AsString;
        AlterWcObj := TMqmWrkCtr(FindWrkCtrByCode(AltWc));  // find his alternative
        if Assigned(AlterWcObj) then
        begin
          wkc.AddAltWkc(proc, AlterWcObj, AltWcProces);
          wkc.AddAltWkcToList(AlterWcObj);
        end;
      end;
      Next;
      if Assigned(ProgBar) then
        ProgBar.SetPosition(RecNo);

      Application.ProcessMessages;
    end;

    close
  end;

  if Assigned(ProgBar) then
    ProgBar.SetPosition(0);
  if Assigned(Status) then
    Status.Caption := '';
  Application.ProcessMessages;
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.LoadAltWorkcenters(qry: TMqmQuery; ProgBar: TMqmProgBar; Status: TStaticText; ErrList: TStringList);
var
  wkc : TMqmWrkCtr;
  tbInfoWkcWks: ^TTblInfo;
  tbAlternativ: ^TTblInfo;
  tbWCenter : ^TTblInfo;
  tbInfoProces: ^TTblInfo;
  AltRec : PAltWkcRec;
  I : Integer;
begin

  tbAlternativ := @tblInfo[tbl_wkc_alt];
  tbInfoWkcWks := @tblInfo[tbl_wkst_wkc];
  tbWCenter :=    @tblInfo[tbl_wkc];
  tbInfoProces := @tblInfo[tbl_wkc_proc];

//  SetFldPfx(tbAlternativ.pfx);

//  qry.Transaction.Active := true;

  with qry do
  begin
    SQL.Clear;
    SQL.Add('select * from ' + tbAlternativ.GetTableName + ', ' + tbInfoWkcWks.GetTableName);
    SQL.Add(' where ');
    SQL.Add(CreateFld(tbAlternativ.pfx, fli_wkCtrCode)    + '=' + CreateFld(tbInfoWkcWks.pfx, fli_wkCtrCode));
    SQL.Add(' AND ' + CreateFld(tbAlternativ.pfx, fli_Identifier)    + '=' + CreateFld(tbInfoWkcWks.pfx, fli_Identifier));
    SQL.Add(' and ' + CreateFld(tbInfoWkcWks.pfx, fli_wkstCode) + '=');
    SQL.Add('''' + IniAppGlobals.WkstCode + '''');
//    SQL.Add(' and ' + CreateFld(tbInfoWkcWks.pfx, fli_TypeOfUse) + '=' + '1');
    SQL.Add(' and ' + CreateFld(tbInfoWkcWks.pfx, fli_TypeOfUse) + '=' + QuotedStr('1'));
    SQL.Add(AND_IDF_Condition(CreateFld(tbAlternativ.pfx, fli_Identifier)));
    open;

    while not EOF do
    begin
      New(AltRec);
      AltRec.WorkCenter := FieldByName(CreateFld(tbAlternativ.pfx, fli_wkCtrCode)).AsString;
      AltRec.Process    := FieldByName(CreateFld(tbAlternativ.pfx, fli_wkcProc)).AsString;
      AltRec.AltWorkCenter := FieldByName(CreateFld(tbAlternativ.pfx, fli_AlterWC)).AsString;
      AltRec.AltProcess := FieldByName(CreateFld(tbAlternativ.pfx, fli_AlterWCProces)).AsString;

      AltRec.ExistAltWcInWStation := false;

      wkc := TMqmWrkCtr(FindWrkCtrByCode(AltRec.AltWorkCenter));
//      if Assigned(wkc) then
      if Assigned(wkc) and not wkc.p_ReadOnly then
      begin
        AltRec.ExistAltWcInWStation := true;
        AltRec.AltWorkCenterDesc := wkc.p_WrkCtrSDesc;
        AltRec.AltProcessDesc := wkc.GetProcDesc(AltRec.AltProcess);
        AltRec.WStation := IniAppGlobals.WkstCode;
      end
      else
        AltRec.ExistAltWcInWStation := false;

      m_AltWrkCtrs.Add(AltRec);
      next;
    end;

    Close;

    for I := 0 to m_AltWrkCtrs.count - 1 do
    begin
    //  SetFldPfx(tbInfoWkcWks.pfx);
      AltRec := PAltWkcRec(m_AltWrkCtrs[i]);
      if not AltRec.ExistAltWcInWStation then
      begin
        with qry do
        begin

          SQL.Clear;
          SQL.Add('select ' + CreateFld(tbInfoWkcWks.pfx, fli_wkstCode));
          SQL.Add(' from ' + tbInfoWkcWks.GetTableName);
          SQL.Add(' where ' + CreateFld(tbInfoWkcWks.pfx, fli_wkCtrCode) + ' = ''' + AltRec.AltWorkCenter + '''');
          SQL.Add(' And ' + CreateFld(tbInfoWkcWks.pfx, fli_TypeOfUse) + '=' + QuotedStr('1'));
          SQL.Add(AND_IDF_Condition(CreateFld(tbInfoWkcWks.pfx, fli_Identifier)));
          open;
          if not Eof then
            AltRec.WStation := FieldByName(CreateFld(tbInfoWkcWks.pfx, fli_wkstCode)).AsString;
          close;

        //  SetFldPfx(tbWCenter.pfx);
          SQL.Clear;
          SQL.Add('select ' + CreateFld(tbWCenter.pfx, fli_SDescr));
          SQL.Add(' from ' + tbWCenter.GetTableName);
          SQL.Add(' where ''' + AltRec.AltWorkCenter + ''' = ' + CreateFld(tbWCenter.pfx, fli_wkCtrCode));
          SQL.Add(AND_IDF_Condition(CreateFld(tbWCenter.pfx, fli_Identifier)));
          open;
          if not Eof then
            AltRec.AltWorkCenterDesc := FieldByName(CreateFld(tbWCenter.pfx, fli_SDescr)).AsString;
          close;

          SQL.Clear;
        //  SetFldPfx(tbInfoProces.pfx);
          SQL.Add('select ' + CreateFld(tbInfoProces.pfx, fli_SDescr));
          SQL.Add(' from ' + tbInfoProces.GetTableName);
          SQL.Add(' where ' + CreateFld(tbInfoProces.pfx, fli_wkCtrCode) + '=' + '''' + AltRec.AltWorkCenter + '''');
          SQL.Add(' and ' + CreateFld(tbInfoProces.pfx, fli_wkcProc) + '=' + '''' + AltRec.AltProcess + '''');
          SQL.Add(AND_IDF_Condition(CreateFld(tbInfoProces.pfx, fli_Identifier)));
          open;
          if not Eof then
            AltRec.AltProcessDesc := FieldByName(CreateFld(tbInfoProces.pfx, fli_SDescr)).AsString;
        end;

      end
    end;

    with qry do
    begin
//      SetFldPfx(tbAlternativ.pfx);
      SQL.Clear;
      SQL.Add('select * from ' + tbAlternativ.GetTableName + ', ' + tbInfoWkcWks.GetTableName);
      SQL.Add(' where ');
      SQL.Add(CreateFld(tbAlternativ.pfx, fli_wkCtrCode)    + '=' + CreateFld(tbInfoWkcWks.pfx, fli_wkCtrCode));
      SQL.Add(' AND ' + CreateFld(tbAlternativ.pfx, fli_wkCtrCode)   + '=' + CreateFld(tbInfoWkcWks.pfx, fli_wkCtrCode));
      SQL.Add(AND_IDF_Condition(CreateFld(tbAlternativ.pfx, fli_Identifier)));
      SQL.Add(' ORDER by ' + CreateFld(tbAlternativ.pfx, fli_AlterWC));
      open;

      while not EOF do
      begin
        New(AltRec);
        AltRec.AltWorkCenter := FieldByName(CreateFld(tbAlternativ.pfx, fli_AlterWC)).AsString;
        AltRec.WorkCenter := FieldByName(CreateFld(tbAlternativ.pfx, fli_wkCtrCode)).AsString;
        AltRec.Process    := FieldByName(CreateFld(tbAlternativ.pfx, fli_wkcProc)).AsString;
        m_AltWrkCtrsGen.Add(AltRec);
        next;
      end;
    end;


    Close;
  end;

end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.LoadResources(qry: TMqmQuery; ProgBar: TMqmProgBar; Status: TStaticText; ErrList: TStringList);
var
  Res, TempRes:           TMqmRes;
  ResCat:        TMqmResCat;
  VisRes:        TMqmVisibleRes;
  Wkc :          TMqmWrkCtr;
  tbInfoRes:    ^TTblInfo;
  tbInfoSubRes: ^TTblInfo;
  tbInfoResCat: ^TTblInfo;
  tbInfoWrkst:  ^TTblInfo;
  tmpStr:        string;
  I : Integer;
begin
  if Assigned(ProgBar) then
    ProgBar.SetPosition(0);
  if Assigned(Status) then
    Status.Caption := _('Reading resources from database...');

  tbInfoWrkst  := @tblInfo[tbl_wkst_wkc];
  tbInfoRes    := @tblInfo[tbl_res];
  tbInfoSubRes := @tblInfo[tbl_res_sub];
  tbInfoResCat := @tblInfo[tbl_resCat];

//  qry.Transaction.Active := true;

{$ifdef LOAD_TMNGS}
  StartInterval;
{$endif}

  with qry do
  begin
    SQL.Clear;
    SQL.Add('select ');
    SQL.Add(CreateFld(tbInfoRes.pfx, fli_rsc)              + ', ');
    SQL.Add(CreateFld(tbInfoRes.pfx, fli_NumOfRsc)         + ', ');
    SQL.Add(CreateFld(tbInfoRes.pfx, fli_RscCat)           + ', ');
    SQL.Add(CreateFld(tbInfoRes.pfx, fli_SDescr)           + ', ');
    SQL.Add(CreateFld(tbInfoRes.pfx, fli_LDescr)           + ', ');
    SQL.Add(CreateFld(tbInfoRes.pfx, fli_ProcesType)       + ', ');
    SQL.Add(CreateFld(tbInfoRes.pfx, fli_Rsc_PLanType)     + ', ');
    SQL.Add(CreateFld(tbInfoRes.pfx, fli_Standrd_bch_Size) + ', ');
    SQL.Add(CreateFld(tbInfoRes.pfx, fli_BchUM)            + ', ');
    SQL.Add(CreateFld(tbInfoRes.pfx, fli_Min_bch_size)     + ', ');
    SQL.Add(CreateFld(tbInfoRes.pfx, fli_Max_bch_size)     + ', ');
    SQL.Add(CreateFld(tbInfoRes.pfx, fli_WorkAsOneBatchMachineGroupCode) + ', ');
    SQL.Add(CreateFld(tbInfoRes.pfx, fli_OneBatchMachineGrouptype) + ', ');
    SQL.Add(CreateFld(tbInfoRes.pfx, fli_LineWithinPlant)  + ', ');
    SQL.Add(CreateFld(tbInfoRes.pfx, fli_PropOptimumMaxMultiplier)  + ', ');
    SQL.Add(CreateFld(tbInfoRes.pfx, fli_PropMinMultiplier)  + ', ');
    SQL.Add(CreateFld(tbInfoRes.pfx, fli_ForceOutsideLimitQty) + ', ');
    SQL.Add(CreateFld(tbInfoRes.pfx, fli_ForceOccToResCase99)  + ', ');
    SQL.Add(CreateFld(tbInfoRes.pfx, fli_wkCtrCode)        + ', ');
    SQL.Add(CreateFld(tbInfoRes.pfx, fli_CalCod)           + ', ');
    SQL.Add(CreateFld(tbInfoRes.pfx, fli_DisplayText1)     + ', ');
    SQL.Add(CreateFld(tbInfoRes.pfx, fli_DisplayText2)     + ', ');
    SQL.Add(CreateFld(tbInfoResCat.pfx, fli_CategorySDesc) + ', ');
    SQL.Add(CreateFld(tbInfoSubRes.pfx, fli_SubRsc)        + ', ');
    SQL.Add(CreateFld(tbInfoSubRes.pfx, fli_CalCod)        + ', ');
    SQL.Add(CreateFld(tbInfoSubRes.pfx, fli_NumSubRscComponents));

    // old - cant run with interbase 2007.
{    SQL.Add('from ');
    SQL.Add(tbInfoWrkst.GetTableName  + ', ');
    SQL.Add(tbInfoResCat.GetTableName + ', ');
    SQL.Add(tbInfoRes.GetTableName);
    SQL.Add('left outer join ' + tbInfoSubRes.GetTableName + ' on ');
    SQL.Add(CreateFld(tbInfoRes.pfx, fli_rsc) + ' = ' + CreateFld(tbInfoSubRes.pfx, fli_rsc));
    SQL.Add(' where ');
    SQL.Add(CreateFld(tbInfoWrkst.pfx, fli_wkstCode) + ' = ');
    SQL.Add('''' + IniAppGlobals.WkstCode + ''' and ');
    SQL.Add(CreateFld(tbInfoRes.pfx, fli_wkCtrCode) + ' = ' + CreateFld(tbInfoWrkst.pfx, fli_wkCtrCode) + ' and');
    SQL.Add(CreateFld(tbInfoRes.pfx, fli_RscCat)    + ' = ' + CreateFld(tbInfoResCat.pfx, fli_RscCat));
    SQL.Add('order by ');
    SQL.Add(CreateFld(tbInfoRes.pfx, fli_rsc) + ', ' + CreateFld(tbInfoSubRes.pfx, fli_SubRsc)); }

    // will run also with interbase 2007

    SQL.Add('from ');
    SQL.Add(tbInfoWrkst.GetTableName  + ', ');
    SQL.Add(tbInfoRes.GetTableName);
    SQL.Add('left outer join ' + tbInfoResCat.GetTableName + ' on ');
    SQL.Add(CreateFld(tbInfoRes.pfx, fli_RscCat)    + ' = ' + CreateFld(tbInfoResCat.pfx, fli_RscCat));
    SQL.Add(' AND ' + CreateFld(tbInfoRes.pfx, fli_Identifier)    + ' = ' + CreateFld(tbInfoResCat.pfx, fli_Identifier));
    SQL.Add('left outer join ' + tbInfoSubRes.GetTableName + ' on ');
    SQL.Add(CreateFld(tbInfoRes.pfx, fli_rsc) + ' = ' + CreateFld(tbInfoSubRes.pfx, fli_rsc));
    SQL.Add(' AND ' + CreateFld(tbInfoRes.pfx, fli_Identifier) + ' = ' + CreateFld(tbInfoSubRes.pfx, fli_Identifier));
    SQL.Add(' where ');
    SQL.Add(CreateFld(tbInfoWrkst.pfx, fli_wkstCode) + ' = ');
    SQL.Add('''' + IniAppGlobals.WkstCode + ''' and ');
    SQL.Add(CreateFld(tbInfoRes.pfx, fli_wkCtrCode) + ' = ' + CreateFld(tbInfoWrkst.pfx, fli_wkCtrCode));
    SQL.Add(AND_IDF_Condition(CreateFld(tbInfoRes.pfx, fli_Identifier)));
    SQL.Add(AND_IDF_Condition(CreateFld(tbInfoWrkst.pfx, fli_Identifier)));
    SQL.Add(' order by ');
    SQL.Add(CreateFld(tbInfoRes.pfx, fli_rsc) + ', ' + CreateFld(tbInfoSubRes.pfx, fli_SubRsc) + ', ' + CreateFld(tbInfoRes.pfx, fli_Rsc_PLanType));
    Open;

    if Assigned(ProgBar) then
      ProgBar.SetMax(500);
    if Assigned(Status) then
      Status.Caption := _('Loading resources in memory...');

    while not EOF do
    begin

      if not DBAppGlobals.MCM_App then
      begin
        if (Trim(FieldByName(CreateFld(tbInfoRes.pfx, fli_Rsc_PLanType)).AsString) = '1') or
          (Trim(FieldByName(CreateFld(tbInfoRes.pfx, fli_Rsc_PLanType)).AsString) = '2') then
        begin
          Next;
          Continue
        end;
      end;

      res := TMqmRes.CreateRes(Trim(FieldByName(CreateFld(tbInfoRes.pfx, fli_rsc)).AsString));
      res.m_plan  := self;

      res.p_ResComp       := FieldByName(CreateFld(tbInfoRes.pfx, fli_NumOfRsc)).AsInteger;
      ResCat              := GetResCat(FieldByName(CreateFld(tbInfoRes.pfx, fli_RscCat)).AsString,
                                       FieldByName(CreateFld(tbInfoResCat.pfx, fli_CategorySDesc)).AsString,
                                       true);
      res.m_ResCat        := ResCat;
      res.p_ResSDesc      := FieldByName(CreateFld(tbInfoRes.pfx, fli_SDescr)).AsString;
      res.p_ResLDesc      := FieldByName(CreateFld(tbInfoRes.pfx, fli_LDescr)).AsString;

      tmpStr := FieldByName(CreateFld(tbInfoRes.pfx, fli_ProcesType)).AsString;
      if tmpStr = 'B' then
        res.p_ProcessType := CST_batch
      else if tmpStr = 'C' then
        res.p_ProcessType := CST_continuous
      else
      begin
        //res.p_ProcessType := CST_printing;
        ErrList.add(_('Process Type was not defined for Resource') + ' ' +
           Trim(FieldByName(CreateFld(tbInfoRes.pfx, fli_rsc)).AsString) + #13#10 + _('Program Will Be Terminated'));
        Exit
      end;

      if (FieldByName(CreateFld(tbInfoRes.pfx, fli_Rsc_PLanType)).AsString = '1') then
        res.p_PlanType := RPT_OverCapacity
      else if (FieldByName(CreateFld(tbInfoRes.pfx, fli_Rsc_PLanType)).AsString = '2') then
        res.p_PlanType := RPT_InfiniteCapacity
      else
        res.p_PlanType := RPT_Real;

      res.p_Sndt_bch_Size := FieldByName(CreateFld(tbInfoRes.pfx, fli_Standrd_bch_Size)).AsFloat;
      res.p_BchUM         := FieldByName(CreateFld(tbInfoRes.pfx, fli_BchUM)).AsString;
      res.p_Min_bch_size  := FieldByName(CreateFld(tbInfoRes.pfx, fli_Min_bch_size)).AsFloat;
      res.p_Max_bch_size  := FieldByName(CreateFld(tbInfoRes.pfx, fli_Max_bch_size)).AsFloat;

      if not FieldByName(CreateFld(tbInfoRes.pfx, fli_DisplayText1)).IsNull then
         res.p_Text1 := trim(FieldByName(CreateFld(tbInfoRes.pfx, fli_DisplayText1)).AsString);

      if not FieldByName(CreateFld(tbInfoRes.pfx, fli_DisplayText2)).IsNull then
         res.p_Text2 := trim(FieldByName(CreateFld(tbInfoRes.pfx, fli_DisplayText2)).AsString);

      if not FieldByName(CreateFld(tbInfoRes.pfx, fli_WorkAsOneBatchMachineGroupCode)).IsNull then
         res.p_GROUP_CODE_FOR_ONE_BATCH_MACHINE := Trim(FieldByName(CreateFld(tbInfoRes.pfx, fli_WorkAsOneBatchMachineGroupCode)).AsString);

      res.P_LineWithinPlant := '';
      if not FieldByName(CreateFld(tbInfoRes.pfx, fli_LineWithinPlant)).IsNull then
         res.P_LineWithinPlant := Trim(FieldByName(CreateFld(tbInfoRes.pfx, fli_LineWithinPlant)).AsString);

      res.P_PropCodeOptimumMaxMultiplier := '';
      if not FieldByName(CreateFld(tbInfoRes.pfx, fli_PropOptimumMaxMultiplier)).IsNull then
         res.P_PropCodeOptimumMaxMultiplier := Trim(FieldByName(CreateFld(tbInfoRes.pfx, fli_PropOptimumMaxMultiplier)).AsString);

      res.P_PropCodeMinMultiplier := '';
      if not FieldByName(CreateFld(tbInfoRes.pfx, fli_PropMinMultiplier)).IsNull then
         res.P_PropCodeMinMultiplier := Trim(FieldByName(CreateFld(tbInfoRes.pfx, fli_PropMinMultiplier)).AsString);

      res.p_ForceOutsideLimitQty := false;
      if (not FieldByName(CreateFld(tbInfoRes.pfx, fli_ForceOutsideLimitQty)).IsNull) and (FieldByName(CreateFld(tbInfoRes.pfx, fli_ForceOutsideLimitQty)).AsString = '1') then
        res.p_ForceOutsideLimitQty := true;

      res.p_ForceOccToResCase99 := false;
      if (not FieldByName(CreateFld(tbInfoRes.pfx, fli_ForceOccToResCase99)).IsNull) and (FieldByName(CreateFld(tbInfoRes.pfx, fli_ForceOccToResCase99)).AsString = '1') then
        res.p_ForceOccToResCase99 := true;

      res.p_GROUP_TYPE_FOR_ONE_BATCH_MACHINE := Non_typ;
      if not FieldByName(CreateFld(tbInfoRes.pfx, fli_OneBatchMachineGrouptype)).IsNull then
      begin
        if FieldByName(CreateFld(tbInfoRes.pfx, fli_OneBatchMachineGrouptype)).AsString = '1' then
          res.p_GROUP_TYPE_FOR_ONE_BATCH_MACHINE := Qty_typ
        else if FieldByName(CreateFld(tbInfoRes.pfx, fli_OneBatchMachineGrouptype)).AsString = '2' then
          res.p_GROUP_TYPE_FOR_ONE_BATCH_MACHINE := Process_typ;
      end;

      if (res.p_GROUP_CODE_FOR_ONE_BATCH_MACHINE <> '') and (res.p_GROUP_TYPE_FOR_ONE_BATCH_MACHINE = Non_typ) then
         res.p_GROUP_TYPE_FOR_ONE_BATCH_MACHINE := Qty_typ;

      // Link the resource to a workcenter
      Wkc := TMqmWrkCtr(FindWrkCtrByCode(FieldByName(CreateFld(tbInfoRes.pfx, fli_wkCtrCode)).AsString));
      if Assigned(Wkc) then
        Wkc.AddResource(TMqmPlanObj(res), res.m_ResCat.p_ResCatCode, res.m_ResCat.p_ResCatDesc);

      if not assigned(Wkc) then
      begin
        Next;
        Continue
      end;

      AddRow(res);

      if (FieldByName(CreateFld(tbInfoSubRes.pfx, fli_SubRsc)).IsNull) or (FieldByName(CreateFld(tbInfoSubRes.pfx, fli_NumSubRscComponents)).AsInteger = 0) then
           // Has No sub resources
      begin
        VisRes := TMqmVisibleRes.CreateVisRes(-1);
        VisRes.p_CalCod := FieldByName(CreateFld(tbInfoRes.pfx, fli_CalCod)).AsString;
        res.p_ResComp := 0;
        Res.AddVisibleRes(VisRes);
      end else
      begin
      //Load SubResources
      while (not EOF) do
        begin
          if Res.p_ResCode <> FieldByName(CreateFld(tbInfoRes.pfx, fli_rsc)).AsString then break;
          if (res.p_ResComp < FieldByName(CreateFld(tbInfoSubRes.pfx, fli_NumSubRscComponents)).AsInteger) then
          begin
            ErrList.add(_('Number of sub resource is higher than the resource definition for resource') + ' ' +
            Trim(FieldByName(CreateFld(tbInfoRes.pfx, fli_rsc)).AsString) + #13#10 + _('Program Will Be Terminated'));
            VisRes := TMqmVisibleRes.CreateVisRes(FieldByName(CreateFld(tbInfoSubRes.pfx, fli_SubRsc)).AsInteger);
            Res.AddVisibleRes(VisRes);
            Exit
          end;
          VisRes := TMqmVisibleRes.CreateVisRes(FieldByName(CreateFld(tbInfoSubRes.pfx, fli_SubRsc)).AsInteger);
          VisRes.p_CalCod := FieldByName(CreateFld(tbInfoSubRes.pfx, fli_CalCod)).AsString;
          VisRes.p_ResComp := FieldByName(CreateFld(tbInfoSubRes.pfx, fli_NumSubRscComponents)).AsInteger;
          // If p_ResComp is 0 mean 1
          if VisRes.p_ResComp = 0 then VisRes.p_ResComp := 1;

          Res.AddVisibleRes(VisRes);
          qry.Next;
          if Assigned(ProgBar) then
            ProgBar.SetPosition(RecNo);
        end;
        Continue
      end;

      Next;
      if Assigned(ProgBar) then
        ProgBar.SetPosition(RecNo);
    end;

    Close;

    for i := 0 to m_ResList.Count - 1 do
    begin
      if (TMqmRes(m_ResList[i]).p_GROUP_CODE_FOR_ONE_BATCH_MACHINE <> '') and (TMqmRes(m_ResList[i]).p_GROUP_CODE_FOR_ONE_BATCH_MACHINE <> '0') then
      begin
        Res := TMqmRes(m_ResList[i]);
        Res.p_Single_Max_bch_size := Res.p_Max_bch_size;
      end;
    end;

    for i := 0 to m_ResList.Count - 1 do
    begin
      if (TMqmRes(m_ResList[i]).p_GROUP_CODE_FOR_ONE_BATCH_MACHINE <> '') and (TMqmRes(m_ResList[i]).p_GROUP_CODE_FOR_ONE_BATCH_MACHINE <> '0') then
      begin
        Res := TMqmRes(m_ResList[i]);
        qry.SQL.Clear;
        tmpStr := 'select * from ' + tbInfoRes.GetTableName + ' where ' +
                   CreateFld(tbInfoRes.pfx, fli_rsc) + '<>''' + Res.p_ResCode + '''' + ' AND ' +
                   CreateFld(tbInfoRes.pfx, fli_WorkAsOneBatchMachineGroupCode) + '=''' + Res.p_GROUP_CODE_FOR_ONE_BATCH_MACHINE + '''' + //+ '(';
                   AND_IDF_Condition(CreateFld(tbInfoRes.pfx, fli_Identifier));
        qry.SQL.Text := tmpStr;
        qry.Open;
        if not qry.Eof then
        begin
          TempRes := TMqmRes(FindResByCode(Trim(FieldByName(CreateFld(tbInfoRes.pfx, fli_rsc)).AsString)));
          if Assigned(TempRes) then
          begin
            Res.P_rscOfBatchMachinSameGrpCode := TempRes;
//            Res.p_Single_Max_bch_size := Res.p_Max_bch_size;
//            Res.p_Max_bch_size := Res.p_Max_bch_size + TempRes.p_Max_bch_size;
            Res.p_Max_bch_size := Res.p_Max_bch_size + TempRes.p_Single_Max_bch_size;
            Res.p_ONE_BATCH_MACHINE_By_GROUP_CODE := true;
          end;
        end;
      end;
    end;

    Close;

{$ifdef LOAD_TMNGS}
  LogAndStopInterval('end loading resources')
{$endif}

  end;

  if Assigned(ProgBar) then
    ProgBar.SetPosition(0);
  if Assigned(Status) then
    Status.Caption := '';

end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.LoadActPlanArea(qry: TMqmQuery; ProgBar: TMqmProgBar; Status: TStaticText; ErrList: TStringList);
var
  i: integer;
  Res:      TMqmRes;
  VisRes:   TMqmVisibleRes;
  ActArea : TMqmActArea;
  tbRscDivision:  ^TTblInfo;
  tbRes:  ^TTblInfo;
  tbInfoWrkst:  ^TTblInfo;
begin
  if Assigned(ProgBar) then
    ProgBar.SetPosition(0);
  if Assigned(Status) then
    Status.Caption := _('Reading active planning areas from database...');

  tbInfoWrkst := @tblInfo[tbl_wkst_wkc];
//  SetFldPfx(tbInfoWrkst.pfx);

  tbRes := @tblInfo[tbl_res];
//  SetFldPfx(tbRes.pfx);

  tbRscDivision := @tblInfo[tbl_res_apa];
//  SetFldPfx(tbRscDivision.pfx);

//  qry.Transaction.Active := true;

{$ifdef LOAD_TMNGS}
  StartInterval;
{$endif}

  with qry do
  begin
    SQL.Clear;
    SQL.Add('select ');
    SQL.Add(CreateFld(tbRscDivision.pfx, fli_rsc)    + ', ');
    SQL.Add(CreateFld(tbRscDivision.pfx, fli_SubRsc) + ', ');
    SQL.Add(CreateFld(tbRscDivision.pfx, fli_DateBegin) + ', ');
    SQL.Add(CreateFld(tbRscDivision.pfx, fli_DateEnd) + ', ');
    SQL.Add(CreateFld(tbRscDivision.pfx, fli_NumOfRsc));
    SQL.Add('from ');
    SQL.Add(tbInfoWrkst.GetTableName + ', ');
    SQL.Add(tbRes.GetTableName);
    SQL.Add('right outer join ' + tbRscDivision.GetTableName + ' on ');
    SQL.Add(CreateFld(tbRes.pfx, fli_rsc) + ' = ' + CreateFld(tbRscDivision.pfx, fli_rsc));
    SQL.Add(' AND ' + CreateFld(tbRes.pfx, fli_IDENTIFIER) + ' = ' + CreateFld(tbRscDivision.pfx, fli_IDENTIFIER));
    SQL.Add(' where ');
    SQL.Add(CreateFld(tbInfoWrkst.pfx, fli_wkstCode) + ' = ');
    SQL.Add('''' + IniAppGlobals.WkstCode + ''' and ');
    SQL.Add(CreateFld(tbRes.pfx, fli_wkCtrCode) + ' = ' + CreateFld(tbInfoWrkst.pfx, fli_wkCtrCode));
    SQL.Add(AND_IDF_Condition(CreateFld(tbInfoWrkst.pfx, fli_Identifier)));
    SQL.Add('order by');
    SQL.Add(CreateFld(tbRscDivision.pfx, fli_rsc));

    Open;

    if Assigned(ProgBar) then
      ProgBar.SetMax(500);
    if Assigned(Status) then
      Status.Caption := _('Loading active planning areas in memory...');

    for i := 0 to m_ResList.Count-1 do
    begin
      Res := m_ResList[i];
      if not Res.p_isMultiRes then
        continue;

      first;
      while not EOF do
      begin
        if Res.p_ResCode = FieldByName(CreateFld(tbRscDivision.pfx, fli_rsc)).AsString then
        begin
          VisRes := Res.GetSubRes(FieldByName(CreateFld(tbRscDivision.pfx, fli_SubRsc)).AsInteger);
          ActArea := TMqmActArea.CreateActArea;
          ActArea.p_Components := FieldByName(CreateFld(tbRscDivision.pfx, fli_NumOfRsc)).AsInteger;
          ActArea.p_start := FieldByName(CreateFld(tbRscDivision.pfx, fli_DateBegin)).AsDateTime;
          ActArea.p_end := FieldByName(CreateFld(tbRscDivision.pfx, fli_DateEnd)).AsDateTime;
          VisRes.AddActArea(ActArea)
        end;
        Next;
        if Assigned(ProgBar) then
          ProgBar.SetPosition(RecNo);
      end;
    end;

    Close;

{$ifdef LOAD_TMNGS}
  LogAndStopInterval('end loading active planning areas')
{$endif}

  end;

  if Assigned(ProgBar) then
    ProgBar.SetPosition(0);
  if Assigned(Status) then
    Status.Caption := '';
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.LoadWarp(ProgBar: TMqmProgBar; Status: TStaticText; ErrList: TStringList);
var
  I : Integer;
  Warp :  TMqmWarp;
  PrevResCode : string;
  res   :  TMqmRes;
  VisRes:  TMqmVisibleRes;
  ActArea: TMqmActArea;
  MaterialSched : TSCMaterialSched;
begin
  if p_sc.p_MatTerialCount = 0 then exit;

  PrevResCode := '';

  for I := 0 to p_sc.p_MatTerialCount - 1 do
  begin
    MaterialSched := TSCMaterialSched(p_sc.p_Material[I]);
    if MaterialSched.m_ResCode = '' then continue;

    if MaterialSched.m_ResCode <> PrevResCode then
      res := TMqmRes(FindResByCode(MaterialSched.m_ResCode));
    if not Assigned(res) then continue;
    VisRes := res.p_VisRes[0];
    actArea := TMqmActArea(VisRes.p_ActArea[0]);
    actArea.CleanWarpList
  end;

  for I := 0 to p_sc.p_MatTerialCount - 1 do
  begin
    MaterialSched := TSCMaterialSched(p_sc.p_Material[I]);
    if MaterialSched.m_ResCode = '' then continue;

    if MaterialSched.m_ResCode <> PrevResCode then
      res := TMqmRes(FindResByCode(MaterialSched.m_ResCode));
    if not Assigned(res) then continue;
    VisRes := res.p_VisRes[0];
    actArea := TMqmActArea(VisRes.p_ActArea[0]);
    PrevResCode := MaterialSched.m_ResCode;

    if MaterialSched.m_warp_levl = MT_BaseLvl then
      Warp := TMqmWarp.CreateWarp(MaterialSched.m_Job.m_Id, MaterialSched.m_qty, MT_BaseLvl, MaterialSched.m_LinkedToRequest)
    else if MaterialSched.m_warp_levl = MT_SecondLvl then
      Warp := TMqmWarp.CreateWarp(MaterialSched.m_Job.m_Id, MaterialSched.m_qty, MT_SecondLvl, MaterialSched.m_LinkedToRequest)
    else continue;

    Warp.m_status := CDUR_none;
    Warp.m_plan := self;
    Warp.p_start := MaterialSched.m_start;
    Warp.p_end := MaterialSched.m_end;
    MaterialSched.m_WarpObj := Warp;
    MaterialSched.m_MqmActArea := actArea;


    //temp calculation
  {  if MaterialSched.m_MATERIAL_Overriden_Speed > 0 then
      Warp.p_durDouble := MaterialSched.m_MATERIAL_Overriden_Speed * MaterialSched.m_qty
    else
      Warp.p_durDouble := MaterialSched.m_SpeedInminutePerUoM * MaterialSched.m_qty; }
    //////////////

    if Assigned(ActArea) then
    begin
      ActArea.AddWarp(Warp);
      p_sc.SetExtLinkPtr_Material(MaterialSched.m_Job.m_Id, actArea);
    end;
    //  ActArea.ReorganizeWarp(0, true);
  end;

end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.LoadCapRes(qry: TMqmQuery; SuffixTblName: string; ProgBar: TMqmProgBar;
                              Status: TStaticText; ErrList: TStringList);
var
  CapResQry : TMqmQuery;
  qryCfg : TMqmQuery;
  tbInfoClrCapRes: ^TTblInfo;
  capRes:  TMqmCapRes;
  res   :  TMqmRes;
  VisRes:  TMqmVisibleRes;
  ActArea: TMqmActArea;
  resCode, PrevResCode : string;
  tbInfo, tbInfoRes, tbInfoWW, tbInfoWK:  ^TTblInfo;
  SchedEnd : TDateTime;
  cal     : TPGCALObj;
  CapNum  : Integer;
  PrevEnd, SchedStart : TDateTime;
  StartTime : string;
begin
  StartTime := ConvertDateFormatMQM(Now - 240);

  if Assigned(ProgBar) then
    ProgBar.SetPosition(0);
  if Assigned(Status) then
    Status.Caption := _('Reading capacity reservations from database...');

  PrevResCode := '';

  tbInfo := @tblInfo[tbl_capRes];
  tbInfoRes := @tblInfo[tbl_res];
  tbInfoWW := @tblInfo[tbl_wkst_wkc];
  tbInfoWK := @tblInfo[tbl_wkst];
//  SetFldPfx(tbInfo.pfx);

//  qry.Transaction.Active := true;

  CapResQry := CreateQuery(Main_DB);
  CapResQry.Transaction := CreateTransaction(Main_DB);

  qryCfg := CreateQuery(Cfg_DB);
  tbInfoClrCapRes := @tblInfo[tbl_cfg_clrCapRes];

{$ifdef LOAD_TMNGS}
  StartInterval;
{$endif}

  with qry do
  begin
    SQL.Clear;

    SQL.Add('select * ');
    SQL.Add(' from ' + tbInfo.GetTableName);
    SQL.Add(' join ' + tbInfoRes.GetTableName + ' on ');
    SQL.Add(CreateFld(tbInfoRes.pfx, fli_rsc) + '=' + CreateFld(tbInfo.pfx, fli_rsc));
    SQL.Add(' AND ' + CreateFld(tbInfoRes.pfx, fli_Identifier) + '=' + CreateFld(tbInfo.pfx, fli_Identifier));
    SQL.Add(' join ' + tbInfoWW.GetTableName + ' on ');
    SQL.Add(CreateFld(tbInfoWW.pfx, fli_wkCtrCode) + '=' + CreateFld(tbInfoRes.pfx, fli_wkCtrCode));
    SQL.Add(' AND ' + CreateFld(tbInfoWW.pfx, fli_Identifier) + '=' + CreateFld(tbInfoRes.pfx, fli_Identifier));
    SQL.Add(' And ' + CreateFld(tbInfoWW.pfx, fli_TypeOfUse) + '=' + QuotedStr('1'));
    SQL.Add(AND_IDF_Condition(CreateFld(tbInfoRes.pfx, fli_Identifier)));
    SQL.Add(' where exists (select 1 from ' + tbInfoWK.GetTableName + ' where ' + tbInfoWK.GetTableName + '.WK_WKST_CODE = ' + tbInfoWW.GetTableName + '.WW_WKST_CODE');
    SQL.Add(' AND ' + tbInfoWK.GetTableName + '.WK_IDENTIFIER = ' + tbInfoWW.GetTableName + '.WW_IDENTIFIER');
    if DBAppGlobals.MCM_App then
      SQL.Add('  and ' + tbInfoWK.GetTableName + '.WK_WORKSTATIONTYPE = ' + QuotedStr('1') + AND_IDF_Condition(CreateFld(tbInfoWK.pfx, fli_Identifier)) + ')')
    else
      SQL.Add('  and ' + tbInfoWK.GetTableName + '.WK_WORKSTATIONTYPE = ' + QuotedStr('0') + AND_IDF_Condition(CreateFld(tbInfoWK.pfx, fli_Identifier)) + ')');

    SQL.Add(' AND ' + '((' + CreateFld(tbInfo.pfx, fli_schedStart) + '>' + StartTime + ')');
   // SQL.Add(' AND ' + '((' + CreateFld(tbInfo.pfx, fli_CapacyResrvStatus) + '<>' + QuotedStr('2') + ')');
    SQL.Add(' or (' +  CreateFld(tbInfo.pfx, fli_CapacyResrvStatus) + ' is null ))');
    SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
    SQL.Add(' Order by ' + CreateFld(tbInfo.pfx, fli_rsc) + ' , ' + CreateFld(tbInfo.pfx, fli_schedStart));
    Open;

    if Assigned(ProgBar) then
      ProgBar.SetMax(1000);
    if Assigned(Status) then
      Status.Caption := _('Loading capacity reservations in memory...');

    while not EOF do
    begin

      resCode := FieldByName(CreateFld(tbInfo.pfx, fli_rsc)).AsString;
      res := TMqmRes(FindResByCode(resCode));

      if not Assigned(res) then
        //capRes.Free
      else
      begin
        if ((FieldByName(CreateFld(tbInfo.pfx, fli_CapacyResrv)).AsInteger > 0) and // normal cap res / downtime (deleted)
           (FieldByName(CreateFld(tbInfo.pfx, fli_CapacyResrvStatus)).AsString = '3')) OR
           ((FieldByName(CreateFld(tbInfo.pfx, fli_CapacyResrv)).AsInteger < 0) and
           (FieldByName(CreateFld(tbInfo.pfx, fli_CapacyResrvStatus)).AsString = '2')) then // down time from NOW (deleted)
        begin
          Next;
          continue;
        end;

        if ((qry.FieldByName(CreateFld(tbInfo.pfx, fli_schedEnd)).AsDateTime <= DBAppGlobals.StDateForPlan))
        Or ((PrevResCode = resCode) and (PrevEnd > (qry.FieldByName(CreateFld(tbInfo.pfx, fli_schedStart)).AsDateTime))) then
        begin
          CapNum := FieldByName(CreateFld(tbInfo.pfx, fli_CapacyResrv)).AsInteger;
          Qry.Next;
          try
          if Assigned(res.p_WrkCtr) and (not TMqmWrkCtr(res.p_WrkCtr).p_ReadOnly) then
          begin
            CapResQry.Transaction.StartTransaction;
            CapResQry.SQL.Clear;
            CapResQry.SQL.Add('delete from ' + tbInfo.GetTableName);
            CapResQry.SQL.Add(' where ');
            CapResQry.SQL.Add(CreateFld(tbInfo.pfx, fli_CapacyResrv) + '=' + '''' + IntToStr(CapNum) + '''');
            CapResQry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
            CapResQry.ExecSQL;
            CapResQry.Transaction.Commit;
          end;
          except
          end;
          continue;
        end;

        capRes := TMqmCapRes.CreateCapRes(FieldByName(CreateFld(tbInfo.pfx, fli_CapacyResrv)).AsInteger);
        capRes.m_plan := self;

        if res.p_isMultiRes then
        begin
          VisRes := res.GetSubRes(FieldByName(CreateFld(tbInfo.pfx, fli_subLinRscId)).AsInteger);
        end else
          VisRes := res.GetSubRes(-1);

        if not Assigned(VisRes) then
        begin
          Next;
          continue
        end;

        capRes.p_start  := FieldByName(CreateFld(tbInfo.pfx, fli_schedStart)).AsDateTime;
      //  capRes.p_dur    := FieldByName(CreateFld(tbInfo.pfx, fli_exeMin)).AsInteger;
        capRes.m_WCProc := FieldByName(CreateFld(tbInfo.pfx, fli_WCProcess)).AsString;
        capRes.m_Work_Station := FieldByName(CreateFld(tbInfoWW.pfx, fli_wkstCode)).AsString;

        if FieldByName(CreateFld(tbInfo.pfx, fli_CapacyResTyp)).AsString = '1' then
          capRes.m_Type := cr_Normal
        else if FieldByName(CreateFld(tbInfo.pfx, fli_CapacyResTyp)).AsString = '2' then
          capRes.m_Type := cr_DownTime
        else
          capRes.m_Type := Cr_CrossingDtm;

        capRes.m_Comment    := FieldByName(CreateFld(tbInfo.pfx, fli_Comment)).AsString;
        if (capRes.m_Type = cr_Normal) then
        begin
          capRes.m_UpMostCase := StrToInt(FieldByName(CreateFld(tbInfo.pfx, fli_Capacity_To_Job)).AsString);
          capRes.m_ColorIndex := FieldByName(CreateFld(tbInfo.pfx, fli_ColorIndex)).AsInteger;
          CapRes.m_BrushColor := DBAppGlobals.CapResColors[CapRes.m_ColorIndex].int;
          CapRes.m_brdColor := DBAppGlobals.CapResColors[CapRes.m_ColorIndex].brd;
          CapRes.m_Dsc := DBAppGlobals.CapResColors[CapRes.m_ColorIndex].Dsc;
        end;

        ActArea := TMqmActArea(VisRes.FindActForDate(capRes.p_start));
        if Assigned(ActArea) then
        begin
          cal := actArea.GetCalendar;
          if (capRes.p_dur = 0) then
          begin
//            cal := actArea.GetCalendar;
            SchedEnd := FieldByName(CreateFld(tbInfo.pfx, fli_schedEnd)).AsDateTime;
            capRes.p_dur := trunc(cal.DiffWH(capRes.p_start, SchedEnd , ActArea.m_CrossDownTmList)*60);
          end;
          if (FieldByName(CreateFld(tbInfo.pfx, fli_schedStart)).AsDateTime < DBAppGlobals.StDateForPlan) then
          begin
            CapRes.m_status := CDUR_Modi;
            capRes.p_start := DBAppGlobals.StDateForPlan;
 //           cal := actArea.GetCalendar;
            SchedEnd := FieldByName(CreateFld(tbInfo.pfx, fli_schedEnd)).AsDateTime;
            capRes.p_dur := trunc(cal.DiffWH(capRes.p_start, SchedEnd , ActArea.m_CrossDownTmList)*60);
          end;
          PrevResCode := ResCode;
          SchedStart :=  capRes.p_start;
          cal.OfsByWH(capRes.p_dur/60, true, SchedStart, PrevEnd, ActArea.m_CrossDownTmList);
          ActArea.AddCapRes(capRes);

          qryCfg.SQL.Clear;
          qryCfg.SQL.Add('select * from ' + tbInfoClrCapRes.GetTableName);
          qryCfg.SQL.Add(' where ');
          qryCfg.SQL.Add(CreateFld(tbInfoClrCapRes.pfx, fli_ValFrom) + '=' + IntToStr(capRes.m_ColorIndex));
          qryCfg.SQL.Add(' and ');
          qryCfg.SQL.Add(CreateFld(tbInfoClrCapRes.pfx, fli_wkstCode) + '=''' + capRes.m_Work_Station + '''');
          qryCfg.SQL.Add(AND_IDF_Condition(CreateFld(tbInfoClrCapRes.pfx, fli_Identifier)));

          qryCfg.Open;
          if not qryCfg.Eof then
          begin
            capRes.m_BrushColor := TColor(qryCfg.FieldByName(CreateFld(tbInfoClrCapRes.pfx, fli_intColor)).AsInteger);
            capRes.m_brdColor := TColor(qryCfg.FieldByName(CreateFld(tbInfoClrCapRes.pfx, fli_bdrColor)).AsInteger);
            capRes.m_Dsc := qryCfg.FieldByName(CreateFld(tbInfoClrCapRes.pfx, Fli_txtDescription)).AsString;
            qryCfg.close;
          end;

        end
      end;

      Next;
      if Assigned(ProgBar) then
        ProgBar.SetPosition(RecNo);
    end;

    Close;

{$ifdef LOAD_TMNGS}
  LogAndStopInterval('end loading capacity reservations')
{$endif}

  end;

  if Assigned(ProgBar) then
    ProgBar.SetPosition(0);
  if Assigned(Status) then
    Status.Caption := '';

  qryCfg.free;
  CapResQry.Free;
end;

//----------------------------------------------------------------------------//
//- service functions to load property values and rules                      -//
//----------------------------------------------------------------------------//

procedure TMqmPlan.LoadCapResDynamic(qry: TMqmQuery; ResourceCode : string; SuffixTblName: string; ProgBar: TMqmProgBar;
                         Status: TStaticText; ErrList: TStringList);
var
  QryProp : TMqmQuery;
  capRes:  TMqmCapRes;
  res   :  TMqmRes;
  VisRes:  TMqmVisibleRes;
  ActArea: TMqmActArea;
  resCode, PrevResCode : string;
  tbInfo, tbInfoDate, tbInfoProp:  ^TTblInfo;
  SchedEnd, EndDateForOCC : TDateTime;
  cal     : TPGCALObj;
  MainStartOcc : boolean;
  PrevEnd : TDateTime;
  Hour, Min, Sec, MSec: Word;
  I, J, P : Integer;
  DateBeginStr : string;
  CapResDynamicList : TList;
  RecCapResDynamic : PTRecCapResDynamic;
  RecCapResDetails : PTRecCapResDetails;
  CapResList : TDurList;
begin
  MainStartOcc := true;
  tbInfo := @tblInfo[tbl_capRes_DynamicPerRes];

  qry.SQL.Clear;
  qry.SQL.Add('select * from ' + tbInfo.getTableName);
  qry.SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  if ResourceCode <> '' then
    qry.SQL.Add(' AND ' + CreateFld(tbInfo.pfx, fli_rsc) + '=''' + ResourceCode + '''');
  qry.SQL.Add(' order by ' + CreateFld(tbInfo.pfx , fli_rsc) + ',' + CreateFld(tbInfo.pfx , fli_DateBegin) + ',' + CreateFld(tbInfo.pfx , fli_fromTime));
  qry.Open;

  if ResourceCode <> '' then
  begin
    res := TMqmRes(FindResByCode(ResourceCode));
    VisRes := res.p_VisRes[0];
    actArea := TMqmActArea(VisRes.p_ActArea[0]);
    ActArea.RemoveAllCapResDynamic;
  end;

  if qry.eof then
  begin
    qry.close;
    Exit
  end;

  if Assigned(ProgBar) then
    ProgBar.SetPosition(0);
  if Assigned(Status) then
    Status.Caption := _('Reading capacity reservations dynamic from database...');

  QryProp   := CreateQuery(Main_DB);
  CapResDynamicList := TList.Create;
  CapResList        := TDurList.Create(self);

  while not qry.Eof do
  begin
    new(RecCapResDynamic);
    RecCapResDynamic.ResCode         := qry.FieldByName(CreateFld(tbInfo.pfx, fli_rsc)).AsString;
    RecCapResDynamic.DateBegin       := qry.FieldByName(CreateFld(tbInfo.pfx, fli_DateBegin)).AsDateTime;
    RecCapResDynamic.ToDateTimelimit := qry.FieldByName(CreateFld(tbInfo.pfx, fli_ToDateLimit)).AsDateTime;
    RecCapResDynamic.FromTime        := qry.FieldByName(CreateFld(tbInfo.pfx, fli_fromTime)).AsInteger;
    RecCapResDynamic.ResDetailsList  := TList.Create;
    CapResDynamicList.Add(RecCapResDynamic);
    qry.Next;
  end;
  qry.close;

  tbInfoDate  := @tblInfo[tbl_capRes_DynamicPerDate];
  tbInfoProp  := @tblInfo[tbl_capRes_DynamicPerResDateProp];

  for I := 0 to CapResDynamicList.Count - 1 do
  begin
  //  DecodeDate(PTRecCapResDynamic(CapResDynamicList[I]).DateBegin, year, month, day);
  //  DateBeginStr := QuotedStr(IntToStr(month) + '/' + IntToStr(Day) + '/' + IntToStr(Year));

    DateBeginStr := ConvertDateFormatDb2Oracle(PTRecCapResDynamic(CapResDynamicList[I]).DateBegin, true, true);

    qry.SQL.Clear;
    qry.SQL.Add('select * from ' + tbInfoDate.getTableName);
    qry.SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfoDate.pfx, fli_Identifier)));
    qry.SQL.Add(' AND ' + CreateFld(tbInfoDate.pfx, fli_rsc) + '=''' + PTRecCapResDynamic(CapResDynamicList[I]).ResCode + '''');
    qry.SQL.Add(' AND ' + CreateFld(tbInfoDate.pfx, fli_DateBegin) + '=' + DateBeginStr);
    qry.SQL.Add(' AND ' + CreateFld(tbInfoDate.pfx, fli_fromTime) + '=' + IntToStr(PTRecCapResDynamic(CapResDynamicList[I]).FromTime));
    qry.SQL.Add(' order by ' + CreateFld(tbInfoDate.pfx , fli_DateBegin) + ',' + CreateFld(tbInfoDate.pfx , fli_fromTime) + ',' + CreateFld(tbInfoDate.pfx , fli_Sequence));
    qry.Open;

    while not qry.Eof do
    begin
      new(RecCapResDetails);
      RecCapResDetails.rescode         := qry.FieldByName(CreateFld(tbInfoDate.pfx, fli_rsc)).AsString;
      RecCapResDetails.DateBegin       := qry.FieldByName(CreateFld(tbInfoDate.pfx, fli_DateBegin)).AsDateTime;
      DecodeTime(qry.FieldByName(CreateFld(tbInfoDate.pfx, fli_fromTime)).AsInteger/24/60, Hour, Min, Sec, MSec);
      RecCapResDetails.FromTime := EncodeTime(Hour, Min, Sec, MSec);
      RecCapResDetails.Sequence        := qry.FieldByName(CreateFld(tbInfoDate.pfx, fli_Sequence)).AsInteger;
      RecCapResDetails.ColorDesc       := qry.FieldByName(CreateFld(tbInfoDate.pfx, fli_Color)).AsInteger;
      RecCapResDetails.NumberOfDays    := Trunc(qry.FieldByName(CreateFld(tbInfoDate.pfx, fli_NumberOfHours)).AsInteger / 24);
      RecCapResDetails.CompactCase     := qry.FieldByName(CreateFld(tbInfoDate.pfx, fli_CompCaseNum)).AsInteger;
      RecCapResDetails.Comment         := qry.FieldByName(CreateFld(tbInfoDate.pfx, fli_Comment)).AsString;
      RecCapResDetails.propertyCode    := TStringList.Create;
      RecCapResDetails.propertyValue   := TStringList.Create;


  //    DecodeDate(PTRecCapResDynamic(CapResDynamicList[I]).DateBegin, year, month, day);
  //    DateBeginStr := QuotedStr(IntToStr(month) + '/' + IntToStr(Day) + '/' + IntToStr(Year));

      QryProp.SQL.Clear;
      QryProp.SQL.Add('select * from ' + tbInfoProp.getTableName);
      QryProp.SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfoProp.pfx, fli_Identifier)));
      QryProp.SQL.Add(' AND ' + CreateFld(tbInfoProp.pfx, fli_rsc) + '=''' + RecCapResDetails.rescode + '''');
      QryProp.SQL.Add(' AND ' + CreateFld(tbInfoProp.pfx, fli_DateBegin) + '=' + DateBeginStr);
      QryProp.SQL.Add(' AND ' + CreateFld(tbInfoProp.pfx, fli_fromTime) + '=' + IntToStr(PTRecCapResDynamic(CapResDynamicList[I]).FromTime));
      QryProp.SQL.Add(' AND ' + CreateFld(tbInfoProp.pfx, fli_Sequence) + '=' + IntToStr(RecCapResDetails.Sequence));
      QryProp.SQL.Add(' order by ' + CreateFld(tbInfoProp.pfx , fli_DateBegin) + ',' + CreateFld(tbInfoProp.pfx , fli_fromTime) +
                      ',' + CreateFld(tbInfoProp.pfx , fli_Sequence) + ',' + CreateFld(tbInfoProp.pfx , fli_PropertyCode));

      QryProp.open;
      while not QryProp.Eof do
      begin
        RecCapResDetails.propertyCode.Add(QryProp.FieldByName(CreateFld(tbInfoProp.pfx, fli_PropertyCode)).AsString);
        RecCapResDetails.propertyValue.Add(QryProp.FieldByName(CreateFld(tbInfoProp.pfx, fli_PropValue)).AsString);
        QryProp.Next
      end;
      PTRecCapResDynamic(CapResDynamicList[I]).ResDetailsList.Add(RecCapResDetails);
      qry.next
    end;
  end;

  PrevResCode := '';

  for I := 0 to CapResDynamicList.Count - 1 do
  begin
    MainStartOcc := true;
    SchedEnd := now;

    resCode := PTRecCapResDynamic(CapResDynamicList[I]).ResCode;
    res := TMqmRes(FindResByCode(resCode));
    if not assigned(res) then
       continue;
   // VisRes := res.p_VisRes[0];
   // actArea := TMqmActArea(VisRes.p_ActArea[0]);
  //  ActArea.RemoveAllCapResDynamic;

    if not Assigned(res) then
      //capRes.Free
    else
    begin

      if (PTRecCapResDynamic(CapResDynamicList[I]).ResDetailsList.Count = 0) then continue;

      if PTRecCapResDynamic(CapResDynamicList[I]).ToDateTimelimit <= DBAppGlobals.EndDateForPlan then
        EndDateForOCC := PTRecCapResDynamic(CapResDynamicList[I]).ToDateTimelimit
      else
        EndDateForOCC := DBAppGlobals.EndDateForPlan;

      while (SchedEnd <= EndDateForOCC) do
      begin

        for J := 0 to PTRecCapResDynamic(CapResDynamicList[I]).ResDetailsList.Count - 1 do
        begin

          capRes := TMqmCapRes.CreateCapRes(I);
          capRes.m_plan := self;

       {   if res.p_isMultiRes then
          begin
            VisRes := res.GetSubRes(FieldByName(CreateFld(tbInfo.pfx, fli_subLinRscId)).AsInteger);
          end else
            VisRes := res.GetSubRes(-1);  }
          VisRes := res.GetSubRes(-1);

          if MainStartOcc then
          begin
            capRes.p_start  := PTRecCapResDynamic(CapResDynamicList[I]).DateBegin + PTRecCapResDetails(PTRecCapResDynamic(CapResDynamicList[I]).ResDetailsList[J]).FromTime;
            MainStartOcc := false;
          end
          else
            capRes.p_start := PrevEnd;

          capRes.p_dur    := 0;
          capRes.m_WCProc := '';
          capRes.m_Work_Station := '';

          capRes.m_Type := Cr_Dynamic;


          ActArea := TMqmActArea(VisRes.FindActForDate(capRes.p_start));
          if Assigned(ActArea) then
          begin
            cal := actArea.GetCalendar;
            if (capRes.p_dur = 0) then
            begin
              SchedEnd := capRes.p_start + PTRecCapResDetails(PTRecCapResDynamic(CapResDynamicList[I]).ResDetailsList[J]).NumberOfDays;
              if SchedEnd > EndDateForOCC then
                break;
              capRes.p_dur := trunc(cal.DiffWH(capRes.p_start, SchedEnd , ActArea.m_CrossDownTmList)*60);
            end;
            actArea.GetCapResInSpot(capRes.p_start, SchedEnd, CapResList);
            if CapResList.Count > 0 then
            begin
              capRes.free;
              CapResList.ClearList;
              PrevEnd := SchedEnd;
              continue;
            end;

            capRes.m_Comment := PTRecCapResDetails(PTRecCapResDynamic(CapResDynamicList[I]).ResDetailsList[J]).Comment;
            capRes.m_UpMostCase := PTRecCapResDetails(PTRecCapResDynamic(CapResDynamicList[I]).ResDetailsList[J]).CompactCase;

            ActArea.AddCapRes(capRes);

            capRes.m_BrushColor := DBAppGlobals.CapResColors[PTRecCapResDetails(PTRecCapResDynamic(CapResDynamicList[I]).ResDetailsList[J]).ColorDesc].int;
            capRes.m_brdColor := DBAppGlobals.CapResColors[PTRecCapResDetails(PTRecCapResDynamic(CapResDynamicList[I]).ResDetailsList[J]).ColorDesc].brd;
            capRes.m_ColorIndex := PTRecCapResDetails(PTRecCapResDynamic(CapResDynamicList[I]).ResDetailsList[J]).ColorDesc;

            for p := 0 to PTRecCapResDetails(PTRecCapResDynamic(CapResDynamicList[I]).ResDetailsList[J]).propertyCode.Count -1 do
              capRes.m_propList.AddProperty(PTRecCapResDetails(PTRecCapResDynamic(CapResDynamicList[I]).ResDetailsList[J]).propertyCode.Strings[p] , '',
                                PTRecCapResDetails(PTRecCapResDynamic(CapResDynamicList[I]).ResDetailsList[J]).propertyValue.Strings[p]);

            PrevEnd := SchedEnd;

          end
          else
            PrevEnd := capRes.p_start + PTRecCapResDetails(PTRecCapResDynamic(CapResDynamicList[I]).ResDetailsList[J]).NumberOfDays

        end;

      end;

    end;

    if Assigned(ProgBar) then
        ProgBar.SetPosition(I);
  end;

  qry.close;

  for I := 0 to CapResDynamicList.Count - 1 do
  begin
    RecCapResDynamic := PTRecCapResDynamic(CapResDynamicList[I]);
    for J := 0 to RecCapResDynamic.ResDetailsList.Count - 1 do
    begin
      RecCapResDetails := PTRecCapResDetails(RecCapResDynamic.ResDetailsList[J]);
      RecCapResDetails.propertyCode.Free;
      RecCapResDetails.propertyValue.Free;
      dispose(RecCapResDetails);
    end;
    RecCapResDynamic.ResDetailsList.Free;
    Dispose(RecCapResDynamic)
  end;
  CapResDynamicList.Free;

  if Assigned(ProgBar) then
    ProgBar.SetPosition(0);
  if Assigned(Status) then
    Status.Caption := '';

  QryProp.Free;
end;

//----------------------------------------------------------------------------//

procedure AddFilterGlobal(qrySQL: TStrings; tblName: string; TTbInfo : PTblInfo);
var
  tbiProp : ^TTblInfo;
begin
  tbiProp := @tblInfo[tbl_prop];
  with qrySQL do
  begin
    Add('from ' + tblName);
    Add('where ');
    Add(CreateFld(TTbInfo.pfx,fli_PropertyCode) + ' In (Select ' + CreateFld(tbiProp.pfx, fli_PropertyCode)
                     + ' from ' + tbiProp.GetTableName);
    Add(' where ');
    if DBAppGlobals.MCM_App then
       Add(CreateFld(tbiProp.pfx, fli_MCMRelevance) + '=' + QuotedStr('1') + AND_IDF_Condition(CreateFld(tbiProp.pfx, fli_Identifier)) + ')')
    else
      Add('(' + CreateFld(tbiProp.pfx, fli_MQMRelevance) + '<>' + QuotedStr('0') + ' or ' +  CreateFld(tbiProp.pfx, fli_MQMRelevance) + ' is null ) ' + AND_IDF_Condition(CreateFld(tbiProp.pfx, fli_Identifier)) + ' )');
    Add( ' and ');

    Add('(' + CreateFld(TTbInfo.pfx, fli_wkCtrCode) + '=''''' + ' OR ' + CreateFld(TTbInfo.pfx, fli_wkCtrCode) + '='' '' ) ' + ' and');
    Add('(' + CreateFld(TTbInfo.pfx, fli_Rsc) + '=''''' + ' OR ' + CreateFld(TTbInfo.pfx, fli_Rsc) + '='' '')');
//    Add(CreateFld(TTbInfo.pfx, fli_wkCtrCode) + '='''' and');
//    Add(CreateFld(TTbInfo.pfx, fli_Rsc)       + '=''''');
    Add(AND_IDF_Condition(CreateFld(TTbInfo.pfx, fli_Identifier)));
    Add('order by ' + CreateFld(TTbInfo.pfx, fli_RscCat))
  end
end;

//----------------------------------------------------------------------------//

procedure AddFilterWorkcenter(qrySQL: TStrings; tblName: string; isForRule: boolean; Rules : string);
var
  tbInfoWk, tbiProp, tbInfoPropRes, tbInfoPropResOrRules :  ^TTblInfo;
begin
  tbInfoWk  := @tblInfo[tbl_wkst_wkc];
  tbiProp := @tblInfo[tbl_prop];
  tbInfoPropRes := @tblInfo[tbl_prop_res];
//  tbInfoRules := @tblInfo[tbl_ruleResToOcc];

  if isForRule then
  begin
    if Rules = 'OCCTOOCC' then
      tbInfoPropResOrRules := @tblInfo[tbl_ruleOccToOcc]
    else if Rules = 'RESTOOCC' then
      tbInfoPropResOrRules := @tblInfo[tbl_ruleResToOcc]
  end
  else
    tbInfoPropResOrRules := tbInfoPropRes;

  with qrySQL do
  begin
    Add('from ' + tbInfoWk.GetTableName);
    Add('inner join ' + tblName + ' on');
    Add(CreateFld(tbInfoWk.pfx, fli_wkCtrCode) + '=' + CreateFld(tbInfoPropResOrRules.pfx, fli_wkCtrCode));
    Add(' AND ' + CreateFld(tbInfoWk.pfx, fli_Identifier) + '=' + CreateFld(tbInfoPropResOrRules.pfx, fli_Identifier));
    Add('where ');
    Add(CreateFld(tbInfoPropResOrRules.pfx, fli_PropertyCode) + ' In (Select ' + CreateFld(tbiProp.pfx, fli_PropertyCode)
                     + ' from ' + tbiProp.GetTableName);
    Add(' where ');
    if DBAppGlobals.MCM_App then
       Add(CreateFld(tbiProp.pfx, fli_MCMRelevance) + '=' + QuotedStr('1') + AND_IDF_Condition(CreateFld(tbiProp.pfx, fli_Identifier)) + ')')
    else
      Add('(' + CreateFld(tbiProp.pfx, fli_MQMRelevance) + '<>' + QuotedStr('0') + ' or ' +  CreateFld(tbiProp.pfx, fli_MQMRelevance) + ' is null ) ' + AND_IDF_Condition(CreateFld(tbiProp.pfx, fli_Identifier)) + ')');
    Add( ' and ');
    Add(CreateFld(tblInfo[tbl_wkst_wkc].pfx, fli_wkstCode) + '=''' + IniAppGlobals.WkstCode + '''');
    Add(AND_IDF_Condition(CreateFld(tbInfoWk.pfx, fli_Identifier)));
    Add('order by ' + CreateFld(tbInfoPropResOrRules.pfx, fli_wkCtrCode)    + ','
                    + CreateFld(tbInfoPropResOrRules.pfx, fli_RscCat)       + ','
                    + CreateFld(tbInfoPropResOrRules.pfx, fli_WCProcess)    + ',');
    if isForRule then
      Add(            CreateFld(tbInfoPropResOrRules.pfx, fli_ProdType)     + ',');
    Add(              CreateFld(tbInfoPropResOrRules.pfx, fli_PropertyCode) );
  end
end;

//----------------------------------------------------------------------------//

procedure AddFilterResources(qrySQL: TStrings; tblName: string; isForRule: boolean; Rules : string);
var
  tbInfoprop, tbInfoRules, tbInfoRes, tbInfoWk, tbInfoPropRes, tbInfoPropResOrRules: ^TTblInfo;
begin
  tbInfoRes := @tblInfo[tbl_res];
  tbInfoWk  := @tblInfo[tbl_wkst_wkc];
  tbInfoPropRes := @tblInfo[tbl_prop_res];
  tbInfoRules := @tblInfo[tbl_ruleResToOcc];
  tbInfoprop  := @tblInfo[tbl_prop];

  if isForRule then
  begin
    if Rules = 'OCCTOOCC' then
      tbInfoPropResOrRules := @tblInfo[tbl_ruleOccToOcc]
    else if Rules = 'RESTOOCC' then
      tbInfoPropResOrRules := @tblInfo[tbl_ruleResToOcc]
  end
  else
    tbInfoPropResOrRules := tbInfoPropRes;

  with qrySQL do
  begin
    Add('from ' + tbInfoRes.GetTableName + ' inner join ' + tblName + ' on');
    Add(CreateFld(tbInfoRes.pfx, fli_rsc) + '=' + CreateFld(tbInfoPropResOrRules.pfx, fli_rsc));
    Add(' AND ' + CreateFld(tbInfoRes.pfx, fli_Identifier) + '=' + CreateFld(tbInfoPropResOrRules.pfx, fli_Identifier));
    Add('where ' + CreateFld(tbInfoRes.pfx, fli_wkCtrCode) + ' in');
    Add('(select ' + CreateFld(tbInfoWk.pfx, fli_wkCtrCode) + ' from ' + tbInfoWk.GetTableName);
    Add('where ' + CreateFld(tbInfoWk.pfx, fli_wkstCode) + '=''' + IniAppGlobals.WkstCode + ''')');

    if DBAppGlobals.MCM_App then
      Add(' And ' + CreateFld(tbInfoPropResOrRules.pfx, fli_PropertyCode) + ' in (Select PY_PROPERTY from ' + tbInfoprop.GetTableName + ' where PY_MCMRELEVANCE = ' + QuotedStr('1') +
            AND_IDF_Condition(CreateFld(tbInfoprop.pfx, fli_Identifier)) + ')')
    else
    begin
      Add(' And (' + CreateFld(tbInfoPropResOrRules.pfx, fli_PropertyCode) + ' in (Select PY_PROPERTY from ' + tbInfoprop.GetTableName + ' where PY_MQMRELEVANCE = ' + QuotedStr('1') + AND_IDF_Condition(CreateFld(tbInfoprop.pfx, fli_Identifier)) + ')');
      Add(' OR ' + CreateFld(tbInfoPropResOrRules.pfx, fli_PropertyCode) + ' in (Select PY_PROPERTY from ' + tbInfoprop.GetTableName + ' where PY_MQMRELEVANCE = ' + QuotedStr('3') + AND_IDF_Condition(CreateFld(tbInfoprop.pfx, fli_Identifier)) + ')');
      Add(' OR ' + CreateFld(tbInfoPropResOrRules.pfx, fli_PropertyCode) + ' in (Select PY_PROPERTY from ' + tbInfoprop.GetTableName + ' where PY_MQMRELEVANCE = ' + QuotedStr('2') + AND_IDF_Condition(CreateFld(tbInfoprop.pfx, fli_Identifier)) + '))');
    end;
    Add(AND_IDF_Condition(CreateFld(tbInfoRes.pfx, fli_Identifier)));
    Add(' order by ' + CreateFld(tbInfoPropResOrRules.pfx, fli_Rsc)         + ','
                    + CreateFld(tbInfoPropResOrRules.pfx, fli_WCProcess)   + ',');
    if isForRule then
      Add(            CreateFld(tbInfoPropResOrRules.pfx, fli_ProdType)     + ',');
    Add(              CreateFld(tbInfoPropResOrRules.pfx, fli_PropertyCode) );
  end
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.LoadResProperties(qry: TMqmQuery; ProgBar: TMqmProgBar; Status: TStaticText; ErrList: TStringList);

  procedure FillDataQuery(qrySQL: TStrings);
  var
    tbInfoProp: ^TTblInfo;
  begin
    with qrySQL do
    begin
      tbInfoProp := @tblInfo[tbl_prop_res];
      Clear;
      Add('select');
      Add(CreateFld(tbInfoProp.pfx, fli_wkCtrCode)                       + ',');
      Add(CreateFld(tbInfoProp.pfx, fli_RscCat)                          + ',');
      Add(CreateFld(tbInfoProp.pfx, fli_WCProcess)                       + ',');
      Add(CreateFld(tbInfoProp.pfx, fli_Rsc)                             + ',');
      Add(CreateFld(tbInfoProp.pfx, fli_PropertyCode)                    + ',');
      Add(CreateFld(tbInfoProp.pfx, fli_PropBaseValue)                   + ',');
      Add(CreateFld(tbInfoProp.pfx, fli_PropAddRscOfOcc)                 + ',');
      Add(CreateFld(tbInfoProp.pfx, fli_PropAddValToAddiRsc)             + ',');
      Add(CreateFld(tbInfoProp.pfx, fli_PropValTakeForGroup)             + ',');
      Add(CreateFld(tbInfoProp.pfx, fli_PropDftCaseRsc_Occ_Ruls)         + ',');
      Add(CreateFld(tbInfoProp.pfx, fli_PropDftCaseOcc_Occ_Ruls)         + ',');
      Add(CreateFld(tbInfoProp.pfx, fli_PropDftSameGroupForOcc_Occ_Ruls));
    end
  end;

  procedure FillRecord(qry: TMqmQuery; var resRec: TPropResRec; var wkcCode, resCode: string);
  var
    tbInfoProp: ^TTblInfo;
  begin
    tbInfoProp := @tblInfo[tbl_prop_res];
    with qry do
    begin
      wkcCode            := Trim(FieldByName(CreateFld(tbInfoProp.pfx, fli_wkCtrCode)).AsString);
      resCode            := Trim(FieldByName(CreateFld(tbInfoProp.pfx, fli_Rsc)).AsString);
      resRec.proc        := Trim(FieldByName(CreateFld(tbInfoProp.pfx, fli_WCProcess)).AsString);
      resRec.resCat      := Trim(FieldByName(CreateFld(tbInfoProp.pfx, fli_RscCat)).AsString);
      resRec.valStr      := Trim(FieldByName(CreateFld(tbInfoProp.pfx, fli_PropBaseValue)).AsString);
      resRec.addResToOcc := Trim(FieldByName(CreateFld(tbInfoProp.pfx, fli_PropAddRscOfOcc)).AsString);
      try
        resRec.dfltResOcc := FieldByName(CreateFld(tbInfoProp.pfx, fli_PropDftCaseRsc_Occ_Ruls)).AsInteger;
      except
        ErrList.add('Missing field value for field : ' + CreateFld(tbInfoProp.pfx, fli_PropDftCaseRsc_Occ_Ruls) +
          ' in table PROP_RES for Property ' + '"' + FieldByName(CreateFld(tbInfoProp.pfx, fli_PropertyCode)).AsString + '"' + #13#10 +
            _('Program Will Be Terminated'));
        exit;
      end;

      try
        resRec.dfltOccOcc  := FieldByName(CreateFld(tbInfoProp.pfx, fli_PropDftCaseOcc_Occ_Ruls)).AsInteger;
      except
        ErrList.add('Missing field value for field : ' + CreateFld(tbInfoProp.pfx, fli_PropDftCaseOcc_Occ_Ruls) +
          ' in table PROP_RES for Property ' + '"' + FieldByName(CreateFld(tbInfoProp.pfx, fli_PropertyCode)).AsString + '"' + #13#10 +
            _('Program Will Be Terminated'));
        exit;
      end;

      try
        resRec.dfltSameGrp := FieldByName(CreateFld(tbInfoProp.pfx, fli_PropDftSameGroupForOcc_Occ_Ruls)).AsInteger;
      except
        ErrList.add('Missing field value for field : ' + CreateFld(tbInfoProp.pfx, fli_PropDftSameGroupForOcc_Occ_Ruls) +
          ' in table PROP_RES for Property ' + '"' + FieldByName(CreateFld(tbInfoProp.pfx, fli_PropertyCode)).AsString  + '"' + #13#10 +
            _('Program Will Be Terminated'));
        exit;
      end;

      try
        resRec.ValForGrp   := FieldByName(CreateFld(tbInfoProp.pfx, fli_PropValTakeForGroup)).AsInteger;
      except
        ErrList.add('Missing field value for field : ' + CreateFld(tbInfoProp.pfx, fli_PropValTakeForGroup) +
          ' in table PROP_RES for Property ' + '"' + FieldByName(CreateFld(tbInfoProp.pfx, fli_PropertyCode)).AsString  + '"' +  #13#10 +
            _('Program Will Be Terminated'));
        exit;
      end;

    end
  end;

var
  tbInfoProp:          ^TTblInfo;
  wkc:                 TMqmWrkCtr;
  wkcCode, oldWkcCode: string;
  res:                 TMqmRes;
  resCode, oldResCode: string;
  resRec:              TPropResRec;
  resCat:              TMqmResCat;
  oldResCatCode:       string;
  errStr:              string;
begin
  tbInfoProp := @tblInfo[tbl_prop_res];
//  SetFldPfx(tbInfoProp.pfx);

  with qry do
  begin
    // load the global and resource category properties
    if Assigned(ProgBar) then
      ProgBar.SetPosition(0);
    if Assigned(Status) then
      Status.Caption := _('Reading global and resource category properties from database...');

    FillDataQuery(qry.SQL);
    AddFilterGlobal(qry.SQL, tbInfoProp.GetTableName, Pointer(tbInfoProp));

    // SQL.SaveToFile('d:\resPropWk.txt'); // query check

    Open;

    if Assigned(ProgBar) then
      ProgBar.SetMax(2000);
    if Assigned(Status) then
      Status.Caption := _('Loading global and resource category properties in memory...');

    resCat        := nil;
    oldResCatCode := '';

    while not EOF do
    begin
      FillRecord(qry, resRec, wkcCode, resCode);
      if ErrList.Count > 0 then
         Exit;
      if (wkcCode <> CVoidCharStr) or (resCode <> CVoidCharStr) then
      begin
        errStr := _('Property ') + FieldByName(CreateFld(tbInfoProp.pfx, fli_PropertyCode)).AsString;
        if wkcCode <> CVoidCharStr then
          errStr := errStr + _(' assigned to workcenter ') + wkcCode
        else
          errStr := errStr + _(' assigned to resource ') + resCode;

        AddInfo(titDbErr, errStr);
      end
      else
      begin
        if (resRec.resCat = CVoidCharStr) then
          //Add property at global level
          GlobAddProperty(FieldByName(CreateFld(tbInfoProp.pfx, fli_PropertyCode)).AsString, resRec, ErrList)
        else
        begin
          //Add property at Resource category level
          if resRec.resCat <> oldResCatCode then
          begin
            resCat := GetResCat(resRec.resCat, '', false);
            if Assigned(resCat) then
              oldResCatCode := resRec.resCat
            else
              oldResCatCode := ''
          end;

          if Assigned(resCat) then
            resCat.AddProperty(FieldByName(CreateFld(tbInfoProp.pfx, fli_PropertyCode)).AsString, resRec, ErrList)
        end
      end;
      Next;
      if Assigned(ProgBar) then
        ProgBar.SetPosition(RecNo);
    end;

    Close;

    // load the properties of the workcenters
    if Assigned(ProgBar) then
      ProgBar.SetPosition(0);
    if Assigned(Status) then
      Status.Caption := _('Reading the properties of the workcenters from database...');

    FillDataQuery(qry.SQL);
    AddFilterWorkcenter(qry.SQL, tbInfoProp.GetTableName, false, '');

    // SQL.SaveToFile('d:\resPropWk.txt'); // query check

    Open;

    if Assigned(ProgBar) then
      ProgBar.SetMax(2000);
    if Assigned(Status) then
      Status.Caption := _('Loading the properties of the workcenters in memory...');

    wkc        := nil;
    oldWkcCode := '';

    while not EOF do
    begin
      FillRecord(qry, resRec, wkcCode, resCode);
      Assert(wkcCode <> CVoidCharStr);

      if wkcCode <> oldWkcCode then
      begin
        wkc := TMqmWrkCtr(FindWrkCtrByCode(wkcCode));
        if Assigned(wkc) then
          oldWkcCode := wkcCode
        else
          oldWkcCode := ''
      end;

      if Assigned(wkc) then
        wkc.AddProperty(FieldByName(CreateFld(tbInfoProp.pfx, fli_PropertyCode)).AsString, resRec, ErrList);

      if (resCode = '') and (resRec.proc = '') and (resRec.resCat = '') then
         wkc.AddWrctrLevelPropToList(GetIdFromCode(FieldByName(CreateFld(tbInfoProp.pfx, fli_PropertyCode)).AsString));

      Next;
      if Assigned(ProgBar) then
        ProgBar.SetPosition(RecNo);
    end;

    Close;

   // load the properties of the resources
    if Assigned(ProgBar) then
      ProgBar.SetPosition(0);
    if Assigned(Status) then
      Status.Caption := _('Reading properties of the resources from database...');

    FillDataQuery(qry.SQL);
    AddFilterResources(qry.SQL, tbInfoProp.GetTableName, false, '');
    Open;

    if Assigned(ProgBar) then
      ProgBar.SetMax(2000);
    if Assigned(Status) then
      Status.Caption := _('Loading properties of the resources in memory...');

    // SQL.SaveToFile('d:\resPropRes.txt'); // query check

    res        := nil;
    oldResCode := '';

    while not EOF do
    begin
      FillRecord(qry, resRec, wkcCode, resCode);
      Assert(resCode <> CVoidCharStr);

      if resCode <> oldResCode then
      begin
        res := TMqmRes(FindResByCode(resCode));
        if Assigned(res) then
          oldResCode := resCode
        else
          oldResCode := ''
      end;

      if Assigned(res) then
        res.AddProperty(FieldByName(CreateFld(tbInfoProp.pfx, fli_PropertyCode)).AsString,
                        resRec, ErrList);
      Next;
      if Assigned(ProgBar) then
        ProgBar.SetPosition(RecNo);
    end;

    Close;
  end;

  if Assigned(ProgBar) then
    ProgBar.SetPosition(0);
  if Assigned(Status) then
    Status.Caption := '';
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.LoadResRules(qry: TMqmQuery; ProgBar: TMqmProgBar; Status: TStaticText; ErrList: TStringList);

var
  wkc:                 TMqmWrkCtr;
  wkcCode, oldWkcCode: string;
  res:                 TMqmRes;
  resCode, oldResCode: string;
  resRec:              TRuleResRec;
  resCat:              TMqmResCat;
  oldResCatCode:       string;

  // -----------------------------------------------------------

  procedure LoadRules(forOtoO: boolean);

    procedure FillDataQuery(qrySQL: TStrings; forOtoO: boolean; tbInfoRules: PTblInfo);
    begin
      with qrySQL do
      begin
        Clear;
        Add('select');
        Add(CreateFld(tbInfoRules.pfx, fli_wkCtrCode)      + ',');
        Add(CreateFld(tbInfoRules.pfx, fli_RscCat)         + ',');
        Add(CreateFld(tbInfoRules.pfx, fli_WCProcess)      + ',');
        Add(CreateFld(tbInfoRules.pfx, fli_ProdType)       + ',');
        Add(CreateFld(tbInfoRules.pfx, fli_PropertyCode)   + ',');
        Add(CreateFld(tbInfoRules.pfx, fli_Rsc)            + ',');
        Add(CreateFld(tbInfoRules.pfx, fli_PropLineNum)    + ',');
        Add(CreateFld(tbInfoRules.pfx, fli_Sequence)       + ',');
        Add(CreateFld(tbInfoRules.pfx, fli_PropOperand)    + ',');
        Add(CreateFld(tbInfoRules.pfx, fli_DepOnCurr)      + ',');
        Add(CreateFld(tbInfoRules.pfx, fli_DepValue)       + ',');
        Add(CreateFld(tbInfoRules.pfx, fli_PropCase)      );

        if forOtoO then
        begin
          Add(',');
          Add(CreateFld(tbInfoRules.pfx, fli_RuleConst)                 + ',');
          Add(CreateFld(tbInfoRules.pfx, fli_PropSetupTyp)              + ',');
          Add(CreateFld(tbInfoRules.pfx, fli_PropSetUpTime)             + ',');
          Add(CreateFld(tbInfoRules.pfx, fli_PropSetUpOverlappTime)     + ',');
          Add(CreateFld(tbInfoRules.pfx, fli_PropSetUpTimeMult)         + ',');
          Add(CreateFld(tbInfoRules.pfx, fli_PropSetUpOverlappTimeMult) + ',');
          Add(CreateFld(tbInfoRules.pfx, fli_CanBeSameGroup)            + ',');
          Add(CreateFld(tbInfoRules.pfx, fli_teoreticl_wc)              + ',');
          Add(CreateFld(tbInfoRules.pfx, fli_duration)                  + ',');
          Add(CreateFld(tbInfoRules.pfx, fli_LeadTime)                  + ',');
          Add(CreateFld(tbInfoRules.pfx, fli_RuleOccFrom)               + ',');
          Add(CreateFld(tbInfoRules.pfx, fli_RuleOccLength)             + ',');
          Add(CreateFld(tbInfoRules.pfx, fli_RuleOccForPartialPropVal)  + ',');
          Add(CreateFld(tbInfoRules.pfx, fli_WhenOkNextSeq)             + ',');
          Add(CreateFld(tbInfoRules.pfx, fli_LearningCurveCode)         + ',');
          Add(CreateFld(tbInfoRules.pfx, fli_DecNum));
        end;
      end
    end;


    procedure FillRecord(qry: TMqmQuery; forOtoO: boolean; var resRec: TRuleResRec;
                         var wkcCode, resCode, propCode: string; tbInfoRules: PTblInfo);
    begin
      with qry do
      begin
        wkcCode         := Trim(FieldByName(CreateFld(tbInfoRules.pfx, fli_wkCtrCode)).AsString);
        resCode         := Trim(FieldByName(CreateFld(tbInfoRules.pfx, fli_Rsc)).AsString);
        propCode        := Trim(FieldByName(CreateFld(tbInfoRules.pfx, fli_PropertyCode)).AsString);
        resRec.proc     := Trim(FieldByName(CreateFld(tbInfoRules.pfx, fli_WCProcess)).AsString);
        resRec.resCat   := Trim(FieldByName(CreateFld(tbInfoRules.pfx, fli_RscCat)).AsString);
        resRec.prodType := Trim(FieldByName(CreateFld(tbInfoRules.pfx, fli_ProdType)).AsString);
        resRec.checkSeq := FieldByName(CreateFld(tbInfoRules.pfx, fli_Sequence)).AsInteger;
        resRec.valStr   := Trim(FieldByName(CreateFld(tbInfoRules.pfx, fli_DepValue)).AsString);
        resRec.op       := Trim(FieldByName(CreateFld(tbInfoRules.pfx, fli_PropOperand)).AsString);
        resRec.toBase   := Trim(FieldByName(CreateFld(tbInfoRules.pfx, fli_DepOnCurr)).AsString);
        resRec.comp     := FieldByName(CreateFld(tbInfoRules.pfx, fli_PropCase)).AsInteger;

        if forOtoO then
        begin
          resRec.constStr       := Trim(FieldByName(CreateFld(tbInfoRules.pfx, fli_RuleConst)).AsString);
          resRec.supAdjType     := FromCharToSadj(Trim(FieldByName(CreateFld(tbInfoRules.pfx, fli_PropSetupTyp)).AsString));
          resRec.supTime        := FieldByName(CreateFld(tbInfoRules.pfx, fli_PropSetUpTime)).AsFloat;
          resRec.supOverlap     := FieldByName(CreateFld(tbInfoRules.pfx, fli_PropSetUpOverlappTime)).AsFloat;
          resRec.supMult        := FieldByName(CreateFld(tbInfoRules.pfx, fli_PropSetUpTimeMult)).AsFloat;
          resRec.supMultOverlap := FieldByName(CreateFld(tbInfoRules.pfx, fli_PropSetUpOverlappTimeMult)).AsFloat;
          resRec.onSameGroup    := Trim(FieldByName(CreateFld(tbInfoRules.pfx, fli_CanBeSameGroup)).AsString);
          resRec.teoreticl_wc   := Trim(FieldByName(CreateFld(tbInfoRules.pfx, fli_teoreticl_wc)).AsString);
          resRec.duration       := FieldByName(CreateFld(tbInfoRules.pfx, fli_duration)).AsFloat;
          resRec.LeadTime       := FieldByName(CreateFld(tbInfoRules.pfx, fli_LeadTime)).AsFloat;
          resRec.FromPos        := FieldByName(CreateFld(tbInfoRules.pfx, fli_RuleOccFrom)).AsInteger;
          resRec.Length         := FieldByName(CreateFld(tbInfoRules.pfx, fli_RuleOccLength)).AsInteger;
          resRec.NumOfdec       := FieldByName(CreateFld(tbInfoRules.pfx, fli_DecNum)).AsInteger;
          if Trim(FieldByName(CreateFld(tbInfoRules.pfx, fli_RuleOccForPartialPropVal)).AsString) = '2' then
            resRec.RuleForPartialPropVal := CSA_Yes_String
          else if Trim(FieldByName(CreateFld(tbInfoRules.pfx, fli_RuleOccForPartialPropVal)).AsString) = '3' then
            resRec.RuleForPartialPropVal := CSA_Yes_Numeric
          else
            resRec.RuleForPartialPropVal := CSA_No;
          resRec.WhenOkNextSeq  := FieldByName(CreateFld(tbInfoRules.pfx, fli_WhenOkNextSeq)).AsInteger;
          resRec.Sequence  := FieldByName(CreateFld(tbInfoRules.pfx, fli_Sequence)).AsInteger;
          resRec.CurveCode := Trim(FieldByName(CreateFld(tbInfoRules.pfx, fli_LearningCurveCode)).AsString);
        end
      end
    end;

  var
    propCode:    string;
    tbInfoRules: ^TTblInfo;
  begin  // LoadRules

    if forOtoO then
      tbInfoRules := @tblInfo[tbl_ruleOccToOcc]
    else
      tbInfoRules := @tblInfo[tbl_ruleResToOcc];

//    SetFldPfx(tbInfoRules.pfx);

    with qry do
    begin

      // load the global and resource category rules
      if Assigned(ProgBar) then
        ProgBar.SetPosition(0);
      if Assigned(Status) then
        Status.Caption := _('Reading global and resource category rules from database...');

      FillDataQuery(qry.SQL, forOtoO, Pointer(tbInfoRules));
      AddFilterGlobal(qry.SQL, tbInfoRules.GetTableName, pointer(tbInfoRules));

      // SQL.SaveToFile('d:\resPropWk.txt'); // query check
      Open;

      if Assigned(ProgBar) then
        ProgBar.SetMax(2000);
      if Assigned(Status) then
        Status.Caption := _('Loading global and resource category rules in memory...');

      resCat        := nil;
      oldResCatCode := '';

      while not EOF do
      begin
        FillRecord(qry, forOtoO, resRec, wkcCode, resCode, propCode, Pointer(tbInfoRules));

        if resRec.resCat = CVoidCharStr then
        begin
          if forOtoO then
            GlobAddOtoOrule(propCode, resRec, ErrList)
          else
            GlobAddRtoOrule(propCode, resRec, ErrList)
        end
        else
        begin
          if resRec.resCat <> oldResCatCode then
          begin
            resCat := GetResCat(resRec.resCat, '', false);
            if Assigned(resCat) then
              oldResCatCode := resRec.resCat
            else
              oldResCatCode := ''
          end;

          if Assigned(resCat) then
            if forOtoO then
              resCat.AddOtoOrule(propCode, resRec, ErrList)
            else
              resCat.AddRtoOrule(propCode, resRec, ErrList)
        end;
        Next;
        if Assigned(ProgBar) then
          ProgBar.SetPosition(RecNo);
      end;

      Close;

      // load the rules of the workcenters
      if Assigned(ProgBar) then
        ProgBar.SetPosition(0);
      if Assigned(Status) then
        Status.Caption := _('Reading the rules of the workcenters from database...');

      FillDataQuery(qry.SQL, forOtoO, Pointer(tbInfoRules));
      if forOtoO then
        AddFilterWorkcenter(qry.SQL, tbInfoRules.GetTableName, true, 'OCCTOOCC')
      else
        AddFilterWorkcenter(qry.SQL, tbInfoRules.GetTableName, true, 'RESTOOCC');

      Open;

      if Assigned(ProgBar) then
        ProgBar.SetMax(2000);
      if Assigned(Status) then
        Status.Caption := _('Loading the rules of the workcenters in memory...');

      wkc        := nil;
      oldWkcCode := '';

      while not EOF do
      begin
        FillRecord(qry, forOtoO, resRec, wkcCode, resCode, propCode, Pointer(tbInfoRules));

        if wkcCode <> oldWkcCode then
        begin
          wkc := TMqmWrkCtr(FindWrkCtrByCode(wkcCode));
          if Assigned(wkc) then
            oldWkcCode := wkcCode
          else
            oldWkcCode := ''
        end;

        if Assigned(wkc) then
          if forOtoO then
            wkc.AddOtoOrule(propCode, resRec, ErrList)
          else
            wkc.AddRtoOrule(propCode, resRec, ErrList);

        Next;
        if Assigned(ProgBar) then
          ProgBar.SetPosition(RecNo);
      end;

      Close;

      // load the rules of the resources
      if Assigned(ProgBar) then
        ProgBar.SetPosition(0);
      if Assigned(Status) then
        Status.Caption := _('Reading the rules of the resources from database...');

      FillDataQuery(qry.SQL, forOtoO, Pointer(tbInfoRules));
      if forOtoO then
        AddFilterResources(qry.SQL, tbInfoRules.GetTableName, true, 'OCCTOOCC')
      else
        AddFilterResources(qry.SQL, tbInfoRules.GetTableName, true, 'RESTOOCC');

      // SQL.SaveToFile('d:\resRuleRO.txt'); // query check

      Open;

      if Assigned(ProgBar) then
        ProgBar.SetMax(2000);
      if Assigned(Status) then
        Status.Caption := _('Loading the rules of the resources in memory...');

      res        := nil;
      oldResCode := '';

      while not EOF do
      begin
        FillRecord(qry, forOtoO, resRec, wkcCode, resCode, propCode, Pointer(tbInfoRules));

        if resCode <> oldResCode then
        begin
          res := TMqmRes(FindResByCode(resCode));
          if Assigned(res) then
            oldResCode := resCode
          else
            oldResCode := ''
        end;

        if Assigned(res) then
          if forOtoO then
            res.AddOtoOrule(propCode, resRec, ErrList)
          else
            res.AddRtoOrule(propCode, resRec, ErrList);

        Next;
        if Assigned(ProgBar) then
          ProgBar.SetPosition(RecNo);
      end;

      Close;
    end;

    if Assigned(ProgBar) then
      ProgBar.SetPosition(0);
    if Assigned(Status) then
      Status.Caption := '';
  end;

begin
  // load the rules for resource to occupation check
  LoadRules(false);

  // load the rules for occupation to occupation check
  LoadRules(true);
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.LoadOvlpRules(qry: TMqmQuery; ProgBar: TMqmProgBar; Status: TStaticText; ErrList: TStringList);
var
  tbInfoOvlpH: ^TTblInfo;
  tbInfoOvlpD: ^TTblInfo;
  i: integer;
  Res: TMQMRes;
  RuleRec: TOvlpRule;
  DetailRec: TOvlpRuleDet;

begin

  tbInfoOvlpH := @tblInfo[tbl_material_sup_header];
  tbInfoOvlpD := @tblInfo[tbl_material_sup_detail];

  if Assigned(ProgBar) then
    ProgBar.SetMax(m_ResList.Count);
  if Assigned(Status) then
    Status.Caption := _('Loading the overlap rules of the resources in memory...');

  with qry do
  begin
    SQL.Clear;
    SQL.Add('Select * from ' + tbInfoOvlpH.GetTableName);
    SQL.Add(' left join ' + tbInfoOvlpD.GetTableName);
    SQL.Add(' on ' + CreateFld(tbInfoOvlpH.pfx, fli_wkCtrCode) + '=' + CreateFld(tbInfoOvlpD.pfx, fli_wkCtrCode));
    SQL.Add(' and ' + CreateFld(tbInfoOvlpH.pfx, fli_wkcProc) + '=' + CreateFld(tbInfoOvlpD.pfx, fli_wkcProc));
    SQL.Add(' and ' + CreateFld(tbInfoOvlpH.pfx, fli_ResCatcode) + '=' + CreateFld(tbInfoOvlpD.pfx, fli_ResCatcode));
    SQL.Add(' and ' + CreateFld(tbInfoOvlpH.pfx, fli_rsc) + '=' + CreateFld(tbInfoOvlpD.pfx, fli_rsc));
    SQL.Add(' and ' + CreateFld(tbInfoOvlpH.pfx, fli_prodtype) + '=' + CreateFld(tbInfoOvlpD.pfx, fli_prodtype));
    SQL.Add(' and ' + CreateFld(tbInfoOvlpH.pfx, fli_Identifier) + '=' + CreateFld(tbInfoOvlpD.pfx, fli_Identifier));
    SQL.Add(' and ' + '(' + CreateFld(tbInfoOvlpH.pfx, fli_ModuleRule) + '<> ' + QuotedStr('1'));
    SQL.Add(' or ' + CreateFld(tbInfoOvlpH.pfx,fli_ModuleRule) + ' is null )');
    SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfoOvlpH.pfx, fli_Identifier)));
    Open;

    while not EOF do
    begin
      for i:= 0 to m_ResList.Count -1 do
      begin
        if Assigned(ProgBar) then
          ProgBar.SetPosition(i);
        Res := TMQMRes(m_ResList[i]);

        if (trim(FieldByName(CreateFld(tbInfoOvlpH.pfx, fli_rsc)).AsString) <> '')
        and (trim(FieldByName(CreateFld(tbInfoOvlpH.pfx, fli_rsc)).AsString) <> trim(Res.p_ResCode)) then
          continue;

        if (trim(FieldByName(CreateFld(tbInfoOvlpH.pfx, fli_ResCatcode)).AsString) <> '')
        and (trim(FieldByName(CreateFld(tbInfoOvlpH.pfx, fli_ResCatcode)).AsString) <> trim(TMqmResCat(Res.p_ResCat).p_ResCatCode)) then
          continue;

        if (trim(FieldByName(CreateFld(tbInfoOvlpH.pfx, fli_wkCtrCode)).AsString) <> '')
        and (trim(FieldByName(CreateFld(tbInfoOvlpH.pfx, fli_wkCtrCode)).AsString) <> trim(TMqmWrkCtr(Res.p_WrkCtr).p_WrkCtrCode)) then
          continue;

        RuleRec.WaitAtLeastMin := FieldByName(CreateFld(tbInfoOvlpH.pfx, fli_MinDelWaitDays)).AsInteger * 24 * 60 +
        FieldByName(CreateFld(tbInfoOvlpH.pfx, fli_MinDelWaitHrs)).AsInteger * 60 +
        FieldByName(CreateFld(tbInfoOvlpH.pfx, fli_MinDelWaitMin)).AsInteger;
        RuleRec.WaitAtMostMin := FieldByName(CreateFld(tbInfoOvlpH.pfx, fli_MaxDelWaitDays)).AsInteger * 24 * 60 +
        FieldByName(CreateFld(tbInfoOvlpH.pfx, fli_MaxDelWaitHrs)).AsInteger * 60 +
        FieldByName(CreateFld(tbInfoOvlpH.pfx, fli_MaxDelWaitMin)).AsInteger;
        RuleRec.MinQtyFromPrvStp := FieldByName(CreateFld(tbInfoOvlpH.pfx, fli_MinQtyPrevStp)).AsFloat;
        RuleRec.MinQtyPassNxtStp := FieldByName(CreateFld(tbInfoOvlpH.pfx, fli_MinQtyPassNxt)).AsFloat;
        RuleRec.UpdBalEveryHour := FieldByName(CreateFld(tbInfoOvlpH.pfx, fli_UpdBalHrs)).AsInteger;
        RuleRec.UpdBalEveryQty := FieldByName(CreateFld(tbInfoOvlpH.pfx, fli_UpdBalQty)).AsFloat;
        RuleRec.UpdIssFromPrvStpHour := FieldByName(CreateFld(tbInfoOvlpH.pfx, fli_UpdReqPrevStpHrs)).AsInteger;

        if FieldByName(CreateFld(tbInfoOvlpH.pfx, fli_waitPrevQty)).AsString = '1' then
           RuleRec.WaitEntirePrvQty := true
        else
          RuleRec.WaitEntirePrvQty := false;

        if FieldByName(CreateFld(tbInfoOvlpH.pfx, fli_PartDel)).AsString = '1' then
          RuleRec.CanDeliverPartial := true
        else
          RuleRec.CanDeliverPartial := false;

        DetailRec.MatArticleType := FieldByName(CreateFld(tbInfoOvlpD.pfx, fli_MatProdType)).AsString;
        DetailRec.IssueTransType := FieldByName(CreateFld(tbInfoOvlpD.pfx, fli_issueTransType)).AsString;
        DetailRec.MinMatQty := FieldByName(CreateFld(tbInfoOvlpD.pfx, fli_minQty)).AsFloat;
        if FieldByName(CreateFld(tbInfoOvlpD.pfx, fli_waitEntireMat)).AsString = '1' then
          DetailRec.WaitEntireMatQty := true
        else
          DetailRec.WaitEntireMatQty := false;
        if FieldByName(CreateFld(tbInfoOvlpD.pfx, fli_searchBalance)).AsString = '1' then
          DetailRec.SearchBalance := true
        else
          DetailRec.SearchBalance := false;
        DetailRec.UpdEveryHours := FieldByName(CreateFld(tbInfoOvlpD.pfx, fli_updReqHrs)).AsInteger;

        Res.AddOvlpRule(FieldByName(CreateFld(tbInfoOvlpH.pfx, fli_prodtype)).AsString,
        FieldByName(CreateFld(tbInfoOvlpH.pfx, fli_wkcProc)).AsString,
        RuleRec, DetailRec);
      end;
      next;
    end;

  end;

  qry.close;

  if Assigned(ProgBar) then
    ProgBar.SetPosition(0);
  if Assigned(Status) then
    Status.Caption := '';

end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.LoadCapResProperties(qry: TMqmQuery; SuffixTblName: string;
                      ProgBar: TMqmProgBar; Status: TStaticText; ErrList: TStringList);
var
  tbInfoProp: ^TTblInfo;
  code, val:  string;
  oldCapResCode: integer;
  capResCode:    integer;
  oldCapRes:     TMqmCapRes;
begin
  if Assigned(ProgBar) then
    ProgBar.SetPosition(0);
  if Assigned(Status) then
    Status.Caption := _('Reading the capacity reservations priorities from database...');

  tbInfoProp := @tblInfo[tbl_prop_capRes];
//  SetFldPfx(tbInfoProp.pfx);

  with qry do
  begin
    SQL.Clear;
    SQL.Add('select');
    SQL.Add(CreateFld(tbInfoProp.pfx, fli_CapacyResrv)   + ',');
    SQL.Add(CreateFld(tbInfoProp.pfx, fli_PropertyCode)  + ',');
    SQL.Add(CreateFld(tbInfoProp.pfx, fli_PropValue));
    SQL.Add('from ' + tbInfoProp.GetTableName);
    SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfoProp.pfx, fli_Identifier)));
    Open;

    if Assigned(ProgBar) then
      ProgBar.SetMax(2000);
    if Assigned(Status) then
      Status.Caption := _('Loading the capacity reservations priorities in memory...');

    oldCapResCode := 0;
    oldCapRes     := nil;

    while not EOF do
    begin
      code := FieldByName(CreateFld(tbInfoProp.pfx, fli_PropertyCode)).AsString;
      val :=  FieldByName(CreateFld(tbInfoProp.pfx, fli_PropValue)).AsString;

      capResCode := FieldByName(CreateFld(tbInfoProp.pfx, fli_CapacyResrv)).AsInteger;
      if capResCode <> oldCapResCode then
        oldCapRes := TMqmCapRes(FindCapResByCode(capResCode, false));

      if Assigned(oldCapRes) then
      begin
        if not oldCapRes.m_propList.AddProperty(code, '', val) then //-prop
       //   ErrList.Add(oldCapRes.GetDescr + ': ' + ('Error loading property') + ' ' + code)
      end;
      Next;
      if Assigned(ProgBar) then
        ProgBar.SetPosition(RecNo);
    end;

    Close
  end;

  if Assigned(ProgBar) then
    ProgBar.SetPosition(0);
  if Assigned(Status) then
    Status.Caption := '';
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.LoadSavedPlanCopy;
var
  tbi, tbiH : ^TTblInfo;
  RecSavedPlan : PRecSavedPlanCopy;
  qry: TMqmQuery;
begin
  qry := CreateQuery(Main_DB);
  Qry.Transaction := CreateTransaction(Main_DB);
  tbi := @tblInfo[tbl_SavedPlanCopy];
  tbiH := @tblInfo[tbl_SavedPlanCopyHeader];

  with Qry.SQL do
  begin
    Clear;
    Add('select  CPH_START_DATE, CPH_END_DATE, CP_SET_NAME, CPH_SET_DESC,CP_PREQ_NO, CP_PSTEP_ID, CP_PSUBST_ID, CP_RSC_CODE, CP_BUCKET_TYPE, CP_BUCKET_QTY '
      + ', CP_SCH_START, CP_SCH_END, CP_EXE_MIN, CP_BUCKET_Date');
    Add(' from  ' + tbi.GetTableName);
    Add(' inner join '+tbiH.GetTableName+' h on cp_set_name = cph_set_Name and cp_identifier = cph_identifier');
    Add(' where CP_IDENTIFIER = ' + IniAppGlobals.Identifier + ' and CP_WKST_CODE = ' + QuotedStr(IniAppGlobals.WkstCode));
    Add('order by CP_SET_NAME,CP_PREQ_NO, CP_PSTEP_ID, CP_PSUBST_ID, CP_RSC_CODE, CP_SCH_START, CP_BUCKET_Date, CP_BUCKET_TYPE');
  end;

  qry.Open;

  while not qry.eof do
  begin
    new(RecSavedPlan);
    RecSavedPlan.IDENTIFIER   := IniAppGlobals.Identifier;
    RecSavedPlan.FROMDATE     := qry.FieldByName('CPH_START_DATE').AsDateTime;
    RecSavedPlan.TODATE       := qry.FieldByName('CPH_END_DATE').AsDateTime;
    RecSavedPlan.WKST_CODE    := IniAppGlobals.WkstCode;
    RecSavedPlan.SET_NAME     := qry.FieldByName('CP_SET_NAME').AsString;
    RecSavedPlan.SET_DESC     := qry.FieldByName('CPH_SET_DESC').AsString;
    RecSavedPlan.PREQ_NO      := qry.FieldByName('CP_PREQ_NO').AsString;
    RecSavedPlan.STEP_ID      := qry.FieldByName('CP_PSTEP_ID').asInteger;
    RecSavedPlan.SubStep      := qry.FieldByName('CP_PSUBST_ID').asInteger;
   // RecSavedPlan.REPROC_NO    := qry.FieldByName('CP_REPROC_NO').asInteger;
    RecSavedPlan.RSC          := qry.FieldByName('CP_RSC_CODE').AsString;
    RecSavedPlan.BucDate      := qry.FieldByName('CP_BUCKET_DATE').asDateTime;
    RecSavedPlan.BucType      := qry.FieldByName('CP_BUCKET_TYPE').asString;
    RecSavedPlan.BucQty       := qry.FieldByName('CP_BUCKET_QTY').asFloat;
    RecSavedPlan.SchedStart   := qry.FieldByName('CP_SCH_START').asDateTime;
    RecSavedPlan.SchedEnd     := qry.FieldByName('CP_SCH_END').asDateTime;
    RecSavedPlan.ExeMin       := qry.FieldByName('CP_EXE_MIN').asFloat;

    m_SavedPlanCopy.Add(RecSavedPlan);
    qry.Next;
  end;

  qry.Close;
  qry.free;

end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.Save(DB: TMqmDBType; SuffixTblName: string; updNum: integer);
var
  qry: TMqmQuery;
begin
  qry := CreateQuery(DB);
  Qry.Transaction := CreateTransaction(DB);
  SaveCapRes(DB, qry, SuffixTblName, updNum);
  SaveWarp(DB, qry, SuffixTblName, updNum);

  qry.Close;

  qry.Free;
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.UpdateStationCapRes(DB: TMqmDBType; updNum : integer);
var
  qry: TMqmQuery;
  qryCfg : TMqmQuery;
  tbInfoClrCapRes: ^TTblInfo;
  tbInfo, tbInfoRes, tbInfoWW : ^TTblInfo;
  resCode : string;
  OldRes , res : TMqmRes;
  capRes : TMqmCapRes;
  VisRes : TMqmVisibleRes;
  ActArea1,ActArea : TMqmActArea;
  NewCap : boolean;
  SqlStr : string;
begin
  qry := CreateQuery(DB);
  qryCfg := CreateQuery(Cfg_DB);
  tbInfoClrCapRes := @tblInfo[tbl_cfg_clrCapRes];
  tbInfo := @tblInfo[tbl_capRes];
  tbInfoRes := @tblInfo[tbl_res];
  tbInfoWW := @tblInfo[tbl_wkst_wkc];

  with qry do
  begin

    SQL.Clear;

    SqlStr := 'select ';

    SqlStr := SqlStr + CreateFld(tbInfo.pfx, fli_CapacyResrv) + ' , ';
    SqlStr := SqlStr + CreateFld(tbInfo.pfx, fli_rsc) + ' , ';
    SqlStr := SqlStr + CreateFld(tbInfo.pfx, fli_WCProcess) + ' , ';
    SqlStr := SqlStr + CreateFld(tbInfo.pfx, fli_CapacyResTyp) + ' , ';
    SqlStr := SqlStr + CreateFld(tbInfo.pfx, fli_subLinRscId) + ' , ';
    SqlStr := SqlStr + CreateFld(tbInfo.pfx, fli_Capacity_To_Job) + ' , ';
    SqlStr := SqlStr + CreateFld(tbInfo.pfx, fli_Comment) + ' , ';
    SqlStr := SqlStr + CreateFld(tbInfo.pfx, fli_schedStart) + ' , ';
    SqlStr := SqlStr + CreateFld(tbInfo.pfx, fli_schedEnd) + ' , ';
    SqlStr := SqlStr + CreateFld(tbInfo.pfx, fli_ColorIndex) + ' , ';
    SqlStr := SqlStr + CreateFld(tbInfo.pfx, fli_updCode) + ' , ';
    SqlStr := SqlStr + CreateFld(tbInfo.pfx, fli_exeMin) + ' , ';
    SqlStr := SqlStr + CreateFld(tbInfo.pfx, fli_CapacyResrvStatus) + ' , ';
    SqlStr := SqlStr + CreateFld(tbInfoRes.pfx, fli_rsc) + ' , ';
    SqlStr := SqlStr + CreateFld(tbInfoWW.pfx, fli_wkstCode);
    SqlStr := SqlStr + ' from ' + tbInfo.GetTableName;
    SqlStr := SqlStr + ' left join ' + tbInfoRes.GetTableName + ' on ';
    SqlStr := SqlStr + CreateFld(tbInfoRes.pfx, fli_rsc) + '=' + CreateFld(tbInfo.pfx, fli_rsc);
    SqlStr := SqlStr + ' And ' + CreateFld(tbInfoRes.pfx, fli_IDENTIFIER) + '=' + CreateFld(tbInfo.pfx, fli_IDENTIFIER);
    SqlStr := SqlStr + ' left join ' + tbInfoWW.GetTableName + ' on ';
    SqlStr := SqlStr + CreateFld(tbInfoWW.pfx, fli_wkCtrCode) + '=' + CreateFld(tbInfoRes.pfx, fli_wkCtrCode);
    SqlStr := SqlStr + ' And ' + CreateFld(tbInfoWW.pfx, fli_IDENTIFIER) + '=' + CreateFld(tbInfoRes.pfx, fli_IDENTIFIER);
    SqlStr := SqlStr + ' And ' + CreateFld(tbInfoWW.pfx, fli_TypeOfUse) + '=' + QuotedStr('1');
    SqlStr := SqlStr + ' Where ' + CreateFld(tbInfo.pfx, fli_CapacyResrv) + '>=''' + IntToStr(0) + '''';
    SqlStr := SqlStr + ' and ' + CreateFld(tbInfo.pfx, fli_updCode) + '>' + IntToStr(m_corrUpd) + ' and ';
    SqlStr := SqlStr + CreateFld(tbInfo.pfx, fli_updCode) + '<=' + IntToStr(updNum);
    SqlStr := SqlStr + AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier));

    sql.Text := SqlStr;
    Open;

    while not EOF do
    begin
      Application.ProcessMessages;
      NewCap  := false;
      resCode := FieldByName(CreateFld(tbInfo.pfx, fli_rsc)).AsString;
      res := TMqmRes(FindResByCode(resCode));

      if not assigned(res) then
      begin
        Next;
        continue;
      end;

      capRes := TMqmCapRes(FindCapResByCode(FieldByName(CreateFld(tbInfo.pfx, fli_CapacyResrv)).AsInteger, false));

      if Assigned(capRes) and (FieldByName(CreateFld(tbInfo.pfx, fli_CapacyResrvStatus)).AsString = '3') then
      begin
        try
          OldRes := TMqmRes(FindResByCode(TMqmRes(capRes.p_Res).p_ResCode));
          if Assigned(OldRes) then
          begin
            if OldRes.p_isMultiRes then
            begin
              VisRes := OldRes.GetSubRes(FieldByName(CreateFld(tbInfo.pfx, fli_subLinRscId)).AsInteger);
            end else
              VisRes := OldRes.GetSubRes(-1);

            if Assigned(VisRes) then
            begin
              ActArea1 := TMqmActArea(VisRes.FindActForDate(FieldByName(CreateFld(tbInfo.pfx, fli_schedStart)).AsDateTime));
              if assigned(ActArea1) then
               ActArea1.RemoveCapRes(capRes);
            end;
          end;
          Next;
          continue
        except
          Next;
          continue
        end;
      end;

      if not assigned(capRes) then
      begin
        capRes := TMqmCapRes.CreateCapRes(FieldByName(CreateFld(tbInfo.pfx, fli_CapacyResrv)).AsInteger);
        capRes.m_plan := self;
        NewCap := true;
      end
      else if (TMqmRes(capRes.p_Res).p_ResCode <> resCode) then
      begin
        OldRes := TMqmRes(FindResByCode(TMqmRes(capRes.p_Res).p_ResCode));
        if OldRes.p_isMultiRes then
        begin
          VisRes := OldRes.GetSubRes(FieldByName(CreateFld(tbInfo.pfx, fli_subLinRscId)).AsInteger);
        end else
          VisRes := OldRes.GetSubRes(-1);
        ActArea := TMqmActArea(VisRes.FindActForDate(capRes.p_start));
        if assigned(ActArea) then
          ActArea.RemoveCapRes(capRes);

        capRes := TMqmCapRes.CreateCapRes(FieldByName(CreateFld(tbInfo.pfx, fli_CapacyResrv)).AsInteger);
        capRes.m_plan := self;
        NewCap := true;
      end;

      if res.p_isMultiRes then
      begin
        VisRes := res.GetSubRes(FieldByName(CreateFld(tbInfo.pfx, fli_subLinRscId)).AsInteger);
      end else
        VisRes := res.GetSubRes(-1);

//        capRes.m_cond := plcd_gantt;
//        capRes.ForceDurData(FieldByName(CreatePfxFld(fli_schedStart)).AsDateTime,
//                            FieldByName(CreatePfxFld(fli_exeMin)).AsInteger);
//        capRes.m_typeVal   := FieldByName(CreatePfxFld(fli_myTypeVal)).AsInteger;
//        capRes.m_compatVal := FieldByName(CreatePfxFld(fli_myCompVal)).AsInteger;
//        capRes.m_ObjProp   := [objPr_InDb]

      capRes.p_start  := FieldByName(CreateFld(tbInfo.pfx, fli_schedStart)).AsDateTime;
      capRes.p_dur    := FieldByName(CreateFld(tbInfo.pfx, fli_exeMin)).AsInteger;
      capRes.m_WCProc := FieldByName(CreateFld(tbInfo.pfx, fli_WCProcess)).AsString;
      capRes.m_Work_Station := FieldByName(CreateFld(tbInfoWW.pfx, fli_wkstCode)).AsString;
      if FieldByName(CreateFld(tbInfo.pfx, fli_CapacyResTyp)).AsString = '1' then
        capRes.m_Type := cr_Normal
      else if FieldByName(CreateFld(tbInfo.pfx, fli_CapacyResTyp)).AsString = '2' then
        capRes.m_Type := cr_DownTime
      else
        capRes.m_Type := Cr_CrossingDtm;

      capRes.m_Comment    := FieldByName(CreateFld(tbInfo.pfx, fli_Comment)).AsString;
      if (capRes.m_Type = cr_Normal) then
      begin
        capRes.m_UpMostCase := StrToInt(FieldByName(CreateFld(tbInfo.pfx, fli_Capacity_To_Job)).AsString);
        capRes.m_ColorIndex := FieldByName(CreateFld(tbInfo.pfx, fli_ColorIndex)).AsInteger;
      end;

      if NewCap then
      begin
        ActArea := TMqmActArea(VisRes.FindActForDate(capRes.p_start));
        if Assigned(ActArea) then
          ActArea.AddCapRes(capRes);
      end;

      qryCfg.SQL.Clear;
      qryCfg.SQL.Add('select * from ' + tbInfoClrCapRes.GetTableName);
      qryCfg.SQL.add(WHERE_IDF_Condition(CreateFld(tbInfoClrCapRes.pfx, fli_Identifier)));
      qryCfg.SQL.Add(' AND ');
      qryCfg.SQL.Add(IntToStr(capRes.m_ColorIndex) + '=' + CreateFld(tbInfoClrCapRes.pfx, fli_ValFrom));
      qryCfg.SQL.Add(' and ');
      qryCfg.SQL.Add(CreateFld(tbInfoClrCapRes.pfx, fli_wkstCode) + '=''' + capRes.m_Work_Station + '''');
      qryCfg.Open;
      if not qryCfg.Eof then
      begin
        capRes.m_BrushColor := TColor(qryCfg.FieldByName(CreateFld(tbInfoClrCapRes.pfx, fli_intColor)).AsInteger);
        capRes.m_brdColor := TColor(qryCfg.FieldByName(CreateFld(tbInfoClrCapRes.pfx, fli_bdrColor)).AsInteger);
        capRes.m_Dsc := qryCfg.FieldByName(CreateFld(tbInfoClrCapRes.pfx, Fli_txtDescription)).AsString;
        qryCfg.close;
      end;

      Next;
    end;

    Close;

  end;

  m_corrUpd := updNum;

//  qry.Transaction.Commit;

  qry.Close;    //Vinc

  qry.Free;

  qryCfg.free;

end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.UpdateCapResColorDesc;
var
  i,j,y,k: integer;
  res: TMqmRes;
  VisRes: TMqmVisibleRes;
  ActArea: TMqmActArea;
  CapRes: TMqmCapRes;
begin
  for i := 0 to m_ResList.Count-1 do
  begin
    res := m_ResList[i];
    for j := 0 to res.p_VisResCount -1 do
    begin
      VisRes := res.p_VisRes[j];

      if TMqmWrkCtr(res.p_father).p_ReadOnly then
         Continue;

      for y := 0 to VisRes.p_ActAreasCount -1 do
      begin
        ActArea := TMqmActArea(VisRes.p_ActArea[y]);
        for k := 0 to ActArea.p_CapResCount -1 do
        begin
          CapRes := TMqmCapRes(ActArea.p_CapRes[k]);
          CapRes.m_BrushColor := DBAppGlobals.CapResColors[CapRes.m_ColorIndex].int;
          CapRes.m_brdColor := DBAppGlobals.CapResColors[CapRes.m_ColorIndex].brd;
          CapRes.m_Dsc := DBAppGlobals.CapResColors[CapRes.m_ColorIndex].Dsc;
        end
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.UpdateSharedData(DB: TMqmDBType; updNum : integer);
var
  qry: TMqmQuery;
  tbInfo : ^TTblInfo;
  SqlStr : string;
begin
  qry := CreateQuery(DB);
  tbInfo := @tblInfo[tbl_prod_sched_shared_data];

  with qry do
  begin

    SQL.Clear;
    SqlStr := 'select * ';
    SqlStr := SqlStr + ' from ' + tbInfo.GetTableName;
    SqlStr := SqlStr + WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier));
    SqlStr := SqlStr + ' AND ' + CreateFld(tbInfo.pfx, fli_updCode) + '>' + IntToStr(m_corrUpdSharedDate) + ' and ';
    SqlStr := SqlStr + CreateFld(tbInfo.pfx, fli_updCode) + '<=' + IntToStr(updNum);
    sql.Text := SqlStr;
    Prepare;
    Open;

    while not EOF do
    begin
      Application.ProcessMessages;
      p_sc.UpdateSharedData(FieldByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString,
                       fieldByName(CreateFld(tbInfo.pfx,fli_pstepId)).AsInteger,
                       fieldByName(CreateFld(tbInfo.pfx,fli_psubstId)).AsInteger,
                       fieldByName(CreateFld(tbInfo.pfx,fli_reprocNo)).AsInteger,
                       FieldByName(CreateFld(tbInfo.pfx, fli_Comment)).AsString);
      Next;
    end;
  end;
  m_corrUpdSharedDate := updNum;
  qry.Free;

end;

//----------------------------------------------------------------------------//

function CopyUnSavedValuesToFolder(IsInsert : boolean ; SavedClickTime : TDateTime; capResNum : integer; ResCode : string; SubCode : integer; capRes:  TMqmCapRes): boolean;
var
  qry: TMqmQuery;
  tbiCapRes: ^TTblInfo;
  StrLst : TStringList;
  ExistInDataBase : boolean;
begin
  ExistInDataBase := false;
  tbiCapRes := @tblInfo[tbl_capRes];
  qry := CreateQuery(Main_DB);
  with qry do
  begin
    SQL.Clear;
    SQL.Add('select * from ' + tbiCapRes.GetTableName);
    SQL.add(WHERE_IDF_Condition(CreateFld(tbiCapRes.pfx, fli_Identifier)));
    SQL.Add(' AND ');
    SQL.Add(CreateFld(tbiCapRes.pfx, fli_CapacyResrv) + '=''' + IntToStr(capResNum) + '''');
    Open;
    if not EOF then
      ExistInDataBase := true;
    Close;
    qry.Free;
  end;

  StrLst := TStringList.Create;
  try
     StrLst.LoadFromFile(LocAppGlobals.AppDir + '\MqmSaveCapLog.txt');
  except
  end;

  if (StrLst.Count > 500) then
     StrLst.clear;

  if IsInsert then
    StrLst.add('-------------------------- Insert Cap Res -----------------------------')
  else
    StrLst.add('-------------------------- Update Cap res -----------------------------');
  StrLst.add(DateTimeToStr(SavedClickTime));

  if ExistInDataBase then
    StrLst.add(' --------------------  Cap Res Is Exist In DataBase -------------------- ')
  else
    StrLst.add(' --------------------  Cap Res is not Exist In DataBase ----------------- ');
  StrLst.add('CapacyResrvNo : ' + IntToStr(CapResNum));
  StrLst.add('rsc : ' + ResCode);
  StrLst.add('subLinRscId : ' + IntToStr(SubCode));
  StrLst.add('WCProcess : ' + CapRes.m_WCProc);
  case capRes.m_Type of
    cr_Normal: StrLst.add('fli_CapacyResTyp : 1');
    cr_DownTime: StrLst.add('fli_CapacyResTyp : 2');
    Cr_CrossingDtm: StrLst.add('fli_CapacyResTyp : 3');
  end;

  StrLst.add('Capacity_To_Job : ' + IntToStr(CapRes.m_UpMostCase));
  StrLst.add('Comment : ' + CapRes.m_Comment);
  StrLst.add('schedStart : ' + DateTimeToStr(CapRes.p_start));
  StrLst.add('schedEnd : ' + DateTimeToStr(CapRes.p_end));
  StrLst.add('ColorIndex : ' + IntToStr(CapRes.m_ColorIndex));
  StrLst.add('exeMin : ' + FloatToStr(CapRes.p_dur));
  StrLst.SaveToFile(LocAppGlobals.AppDir + '\MqmSaveCapLog.txt');
  StrLst.Free;
  Result := ExistInDataBase;
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.SaveWarp(DB: TMqmDBType; qry: TMqmQuery; SuffixTblName: string; updNum : integer);
var
  Warp:  TMqmWarp;
  res:     TMqmRes;
  VisRes:  TMqmVisibleRes;
  ActArea: TMqmActArea;
  tbInfo:  ^TTblInfo;
  iRes, iVisRes, iApa, iWarp: integer;
  ObjToDel: TMqmObj;
  FieldVal: variant;
  dataType: CBinColValType;
begin
  if not DBAppGlobals.IsWarpHandled then exit;

  Application.ProcessMessages;
  Warp := nil;
  tbInfo := @tblInfo[tbl_MaterialDetailSchedule];
  Qry.Transaction.StartTransaction;

  // updating non scheduled warp with new spead/setup

  with qry do
  begin
    SQL.Clear;
    SQL.Add('update ' + TbInfo.GetTableName + ' set ');
    SQL.Add(CreateFld(tbInfo.pfx, fli_updCode)                + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_updCode)          + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_OverridenSpeed)         + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_OverridenSpeed)   + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_OverridenSetupTime)     + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_OverridenSetupTime));
    SQL.Add('where');
    SQL.Add(CreateFld(tbInfo.pfx, fli_IDENTIFIER)   + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_IDENTIFIER) + ' and ');
    SQL.Add(CreateFld(tbInfo.pfx, fli_prodtype)     + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_prodtype) + ' and ');
    SQL.Add(CreateFld(tbInfo.pfx, fli_ProdCode)     + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_ProdCode) + ' and ');
    SQL.Add(CreateFld(tbInfo.pfx, fli_Sub_Detail)   + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Sub_Detail) + ' and ');
    SQL.Add(CreateFld(tbInfo.pfx, fli_Detail_Code)  + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Detail_Code));

    for iWarp := 0 to m_ObjWarpNonScheduledToUpdateList.Count - 1 do
    begin
      Application.ProcessMessages;
      Warp := TMqmWarp(m_ObjWarpNonScheduledToUpdateList[iWarp]);
      ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsString   := IniAppGlobals.Identifier;
      p_sc.GetFldValue(Warp.Get_M_id, CSC_Mat_Item_Type, FieldVal, dataType);
      ParamByName(CreateFld(tbInfo.pfx, fli_prodtype)).AsString   := FieldVal;
      p_sc.GetFldValue(Warp.Get_M_id, CSC_Mat_PRODUCT_CODE, FieldVal, dataType);
      ParamByName(CreateFld(tbInfo.pfx, fli_ProdCode)).AsString   := FieldVal;
      p_sc.GetFldValue(Warp.Get_M_id, CSC_Mat_MATERIAL_CODE_SUB_DET, FieldVal, dataType);
      ParamByName(CreateFld(tbInfo.pfx, fli_Sub_Detail)).AsString   := FieldVal;
      p_sc.GetFldValue(Warp.Get_M_id, CSC_Mat_Detail_Code, FieldVal, dataType);
      ParamByName(CreateFld(tbInfo.pfx, fli_Detail_Code)).AsString   := FieldVal;
      ParamByName(CreateFld(tbInfo.pfx, fli_updCode)).AsInteger     := updNum + 1;

      p_sc.GetFldValue(Warp.Get_M_id, CSC_Mat_Overriden_Setup_Time, FieldVal, dataType);
      ParamByName(CreateFld(tbInfo.pfx, fli_OverridenSetupTime)).AsFloat := FieldVal;
      p_sc.GetFldValue(Warp.Get_M_id, CSC_Mat_Overriden_Speed, FieldVal, dataType);
      ParamByName(CreateFld(tbInfo.pfx, fli_OverridenSpeed)).AsFloat := FieldVal;

      ExecSQL;

    end;

    for iWarp := m_ObjWarpNonScheduledToUpdateList.Count - 1 downto 0 do
       TMqmPlanObj(m_ObjWarpNonScheduledToUpdateList[iWarp]).free;
    m_ObjWarpNonScheduledToUpdateList.Clear;

  end;

  with qry do
  begin
    SQL.Clear;
    SQL.Add('update ' + TbInfo.GetTableName + ' set ');
    SQL.Add(CreateFld(tbInfo.pfx, fli_rsc)                    + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_rsc)              + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_updCode)                + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_updCode)          + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_schedStart)             + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_schedStart)       + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_schedEnd)               + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_schedEnd)         + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_OverridenSpeed)             + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_OverridenSpeed)       + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_OverridenSetupTime)         + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_OverridenSetupTime)   + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_schedType)              + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_schedType));
    SQL.Add('where');
    SQL.Add(CreateFld(tbInfo.pfx, fli_IDENTIFIER)   + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_IDENTIFIER) + ' and ');
    SQL.Add(CreateFld(tbInfo.pfx, fli_prodtype)     + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_prodtype) + ' and ');
    SQL.Add(CreateFld(tbInfo.pfx, fli_ProdCode)     + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_ProdCode) + ' and ');
    SQL.Add(CreateFld(tbInfo.pfx, fli_Sub_Detail)   + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Sub_Detail) + ' and ');
    SQL.Add(CreateFld(tbInfo.pfx, fli_Detail_Code)  + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Detail_Code));

    for iRes := 0 to p_pl.m_ResList.Count -1 do
    begin
      Application.ProcessMessages;
      res := TMqmRes(p_pl.m_ResList[iRes]);
      for iVisRes := 0 to res.p_VisResCount -1 do
      begin
        Application.ProcessMessages;
        VisRes := TMqmVisibleRes(res.p_VisRes[iVisRes]);

        for iApa := 0 to VisRes.p_ActAreasCount -1 do
        begin
          Application.ProcessMessages;
          ActArea := TMqmActArea(VisRes.p_ActArea[iApa]);

          for iWarp := 0 to ActArea.p_WarpCount -1 do
          begin
            Warp := TMqmWarp(ActArea.p_Warp[iWarp]);
                                // was modi
            if Warp.m_status = CDUR_None then continue;
            ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsString   := IniAppGlobals.Identifier;
            p_sc.GetFldValue(Warp.Get_M_id, CSC_Mat_Item_Type, FieldVal, dataType);
            ParamByName(CreateFld(tbInfo.pfx, fli_prodtype)).AsString   := FieldVal;
            p_sc.GetFldValue(Warp.Get_M_id, CSC_Mat_PRODUCT_CODE, FieldVal, dataType);
            ParamByName(CreateFld(tbInfo.pfx, fli_ProdCode)).AsString   := FieldVal;
            p_sc.GetFldValue(Warp.Get_M_id, CSC_Mat_MATERIAL_CODE_SUB_DET, FieldVal, dataType);
            ParamByName(CreateFld(tbInfo.pfx, fli_Sub_Detail)).AsString   := FieldVal;
            p_sc.GetFldValue(Warp.Get_M_id, CSC_Mat_Detail_Code, FieldVal, dataType);
            ParamByName(CreateFld(tbInfo.pfx, fli_Detail_Code)).AsString   := FieldVal;
            ParamByName(CreateFld(tbInfo.pfx, fli_updCode)).AsInteger     := updNum + 1;

            // 0 - not schdule
            // 1 - schdule
            // 2 unschdule
            ParamByName(CreateFld(tbInfo.pfx, fli_schedType)).AsString    := '1';
            ParamByName(CreateFld(tbInfo.pfx, fli_rsc)).AsString          :=  Res.p_ResCode;
            ParamByName(CreateFld(tbInfo.pfx, fli_schedStart)).AsDateTime     := Warp.p_start;
            ParamByName(CreateFld(tbInfo.pfx, fli_schedEnd)).AsDateTime       := Warp.p_end;
            p_sc.GetFldValue(Warp.Get_M_id, CSC_Mat_Overriden_Setup_Time, FieldVal, dataType);
            ParamByName(CreateFld(tbInfo.pfx, fli_OverridenSetupTime)).AsFloat := FieldVal;
            p_sc.GetFldValue(Warp.Get_M_id, CSC_Mat_Overriden_Speed, FieldVal, dataType);
            ParamByName(CreateFld(tbInfo.pfx, fli_OverridenSpeed)).AsFloat := FieldVal;

            ExecSQL;
            Application.ProcessMessages;
            Warp.m_status := CDUR_None
          end;
        end;
      end;
    end;
  end;

  with qry do
  begin
    SQL.Clear;    // should add also the CSC_Mat_Overriden_Setup_Time, fli_OverridenSpeed
    SQL.Add('update ' + TbInfo.GetTableName + ' set ');
    SQL.Add(CreateFld(tbInfo.pfx, fli_rsc)                    + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_rsc)              + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_updCode)                + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_updCode)          + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_schedStart)             + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_schedStart)       + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_schedEnd)               + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_schedEnd)         + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_OverridenSpeed)         + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_OverridenSpeed)   + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_OverridenSetupTime)     + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_OverridenSetupTime) + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_schedType)               + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_schedType)              );
    SQL.Add('where');
    SQL.Add(CreateFld(tbInfo.pfx, fli_IDENTIFIER)   + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_IDENTIFIER) + ' and ');
    SQL.Add(CreateFld(tbInfo.pfx, fli_prodtype)   + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_prodtype) + ' and ');
    SQL.Add(CreateFld(tbInfo.pfx, fli_ProdCode)   + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_ProdCode) + ' and ');
    SQL.Add(CreateFld(tbInfo.pfx, fli_Sub_Detail)   + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Sub_Detail) + ' and ');
    SQL.Add(CreateFld(tbInfo.pfx, fli_Detail_Code)  + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Detail_Code));


    for iWarp := p_pl.p_ObjToDelCount - 1 downto 0 do
    begin
      ObjToDel := p_pl.p_ObjToDel[iWarp];
      if not (ObjToDel is TMqmWarp) then
        continue;
      Warp := TMqmWarp(ObjToDel);

      if Warp.m_status <> CDUR_del then continue;

      ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsString   := IniAppGlobals.Identifier;
      p_sc.GetFldValue(Warp.Get_M_id, CSC_Mat_Item_Type, FieldVal, dataType);
      ParamByName(CreateFld(tbInfo.pfx, fli_prodtype)).AsString   := FieldVal;
      p_sc.GetFldValue(Warp.Get_M_id, CSC_Mat_PRODUCT_CODE, FieldVal, dataType);
      ParamByName(CreateFld(tbInfo.pfx, fli_ProdCode)).AsString   := FieldVal;

      p_sc.GetFldValue(Warp.Get_M_id, CSC_Mat_MATERIAL_CODE_SUB_DET, FieldVal, dataType);
      ParamByName(CreateFld(tbInfo.pfx, fli_Sub_Detail)).AsString   := FieldVal;


      p_sc.GetFldValue(Warp.Get_M_id, CSC_Mat_Detail_Code, FieldVal, dataType);
      ParamByName(CreateFld(tbInfo.pfx, fli_Detail_Code)).AsString   := FieldVal;
      ParamByName(CreateFld(tbInfo.pfx, fli_updCode)).AsInteger     := updNum + 1;

      // 0 - not schdule
      // 1 - schdule
      // 2 unschduled
      ParamByName(CreateFld(tbInfo.pfx, fli_schedType)).AsString     := '2';
      ParamByName(CreateFld(tbInfo.pfx, fli_rsc)).AsString           := '';
      ParamByName(CreateFld(tbInfo.pfx, fli_schedStart)).AsDateTime  := 0;
      ParamByName(CreateFld(tbInfo.pfx, fli_schedEnd)).AsDateTime    := 0;
      ParamByName(CreateFld(tbInfo.pfx, fli_OverridenSetupTime)).AsFloat := 0;
      ParamByName(CreateFld(tbInfo.pfx, fli_OverridenSpeed)).AsFloat := 0;
      ExecSQL;
      Application.ProcessMessages;
      Warp.m_status := CDUR_None
    end;
   // m_ObjToDelList.clear;
    Close;
    Transaction.Commit;

  end;

end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.SaveCapRes(DB: TMqmDBType; qry: TMqmQuery;
                       SuffixTblName: string; updNum : integer);
var
  capRes:  TMqmCapRes;
  res:     TMqmRes;
  VisRes:  TMqmVisibleRes;
  ActArea: TMqmActArea;
  ObjToDel: TMqmObj;
  tbInfo:  ^TTblInfo;
  capResNum: integer;
  iRes, iVisRes, iApa, iCapRes: integer;
  CapResQry: TMqmQuery;
  QryPrepared: boolean;
  SevedClickTime    : TDateTime;
begin
  Application.ProcessMessages;
  SevedClickTime := now;
  CapRes := nil;
  CapResQry := CreateQuery(DB);
  CapResQry.Transaction := CreateTransaction(DB);

  tbInfo := @tblInfo[tbl_capRes];
//  SetFldPfx(tbInfo.pfx);

  Qry.Transaction.StartTransaction;
  QryPrepared := false;

  with qry do
  begin
    SQL.Clear;

    SQL.Add('insert into ' + SuffixTblName + tbInfo.GetTableName + '(');
    SQL.Add(CreateFld(tbInfo.pfx, fli_IDENTIFIER)       + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_CapacyResrv)      + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_rsc)              + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_updCode)          + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_subLinRscId)      + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_WCProcess)        + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_CapacyResTyp)     + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_Capacity_To_Job)  + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_Comment)          + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_schedStart)       + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_schedEnd)         + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_ColorIndex)       + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_exeMin));
    SQL.Add(') values (');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_IDENTIFIER)       + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_CapacyResrv)      + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_rsc)              + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_updCode)          + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_subLinRscId)      + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_WCProcess)        + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_CapacyResTyp)     + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Capacity_To_Job)  + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Comment)          + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_schedStart)       + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_schedEnd)         + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_ColorIndex)       + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_exeMin));
    SQL.Add(')');

    for iRes := 0 to p_pl.m_ResList.Count -1 do
    begin
      Application.ProcessMessages;
      res := TMqmRes(p_pl.m_ResList[iRes]);

      for iVisRes := 0 to res.p_VisResCount -1 do
      begin
        Application.ProcessMessages;
        VisRes := TMqmVisibleRes(res.p_VisRes[iVisRes]);

        for iApa := 0 to VisRes.p_ActAreasCount -1 do
        begin
          Application.ProcessMessages;
          ActArea := TMqmActArea(VisRes.p_ActArea[iApa]);
          if not QryPrepared
          and (ActArea.p_CapResCount > 0) then
          begin
//            Prepare;
            QryPrepared := true
          end;

          for iCapRes := 0 to ActArea.p_CapResCount -1 do
          begin
            try
            CapRes := TMqmCapRes(ActArea.p_CapRes[iCapRes]);

            if (CapRes.m_status <> CDUR_New) then continue;

            if not SP_GET_CAP_RES_NUM(capResNum, 'CAPRESNUMBER') then exit;

            ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsString   := IniAppGlobals.Identifier;
            ParamByName(CreateFld(tbInfo.pfx, fli_CapacyResrv)).AsInteger := capResNum;
            CapRes.p_CapResNum := capResNum;
            CapRes.p_NewInMemorty := false;
            ParamByName(CreateFld(tbInfo.pfx, fli_updCode)).AsInteger      := updNum + 1;
            ParamByName(CreateFld(tbInfo.pfx, fli_rsc)).AsString          := Res.p_ResCode;
            ParamByName(CreateFld(tbInfo.pfx, fli_subLinRscId)).AsInteger := VisRes.p_SubCode;
            ParamByName(CreateFld(tbInfo.pfx, fli_WCProcess)).AsString    := CapRes.m_WCProc;
            case capRes.m_Type of
                cr_Normal: ParamByName(CreateFld(tbInfo.pfx, fli_CapacyResTyp)).AsString := '1';
                cr_DownTime: ParamByName(CreateFld(tbInfo.pfx, fli_CapacyResTyp)).AsString := '2';
                Cr_CrossingDtm : ParamByName(CreateFld(tbInfo.pfx, fli_CapacyResTyp)).AsString := '3';
            end;
            ParamByName(CreateFld(tbInfo.pfx, fli_Capacity_To_Job)).AsString  := IntToStr(CapRes.m_UpMostCase);
            ParamByName(CreateFld(tbInfo.pfx, fli_Comment)).AsString          := CapRes.m_Comment;
            ParamByName(CreateFld(tbInfo.pfx, fli_schedStart)).AsDateTime     := CapRes.p_start;
            ParamByName(CreateFld(tbInfo.pfx, fli_schedEnd)).AsDateTime       := CapRes.p_end;
            ParamByName(CreateFld(tbInfo.pfx, fli_ColorIndex)).AsInteger      := CapRes.m_ColorIndex;
            ParamByName(CreateFld(tbInfo.pfx, fli_exeMin)).AsFloat            := CapRes.p_dur;
            Application.ProcessMessages;
            ExecSQL;

            except

             on E: Exception do
              begin
                showmessage(E.Message + '  ' + _('Saving of Capacity reservation was ignored'));

                showmessage(_('Saving of Capacity reservation was ignored'));
                //if Assigned(Res) and Assigned(VisRes) and assigned(CapRes) then
                  //CopyUnSavedValuesToFolder(true,SevedClickTime,capResNum,Res.p_ResCode,VisRes.p_SubCode,CapRes);
                continue
              end;
            end;

            SaveCapResProp(CapResQry, SuffixTblName, CapRes);
            CapRes.m_status := CDUR_None
          end;
        end;
      end;
    end;


    QryPrepared := false;
    SQL.Clear;
    SQL.Add('update ' + SuffixTblName + TbInfo.GetTableName + ' set ');
    SQL.Add(CreateFld(tbInfo.pfx, fli_rsc)                    + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_rsc)              + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_updCode)                + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_updCode)          + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_subLinRscId)            + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_subLinRscId)      + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_WCProcess)              + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_WCProcess)        + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_CapacyResTyp)           + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_CapacyResTyp)     + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_Capacity_To_Job)        + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Capacity_To_Job)  + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_Comment)                + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Comment)          + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_schedStart)             + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_schedStart)       + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_schedEnd)               + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_schedEnd)         + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_ColorIndex)             + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_ColorIndex)       + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_exeMin)                 + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_exeMin)                );
    SQL.Add('where');
    SQL.Add(CreateFld(tbInfo.pfx, fli_IDENTIFIER)   + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_IDENTIFIER) + ' and ');
    SQL.Add(CreateFld(tbInfo.pfx, fli_CapacyResrv)  + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_CapacyResrv));

    for iRes := 0 to p_pl.m_ResList.Count -1 do
    begin
      Application.ProcessMessages;
      res := TMqmRes(p_pl.m_ResList[iRes]);
      for iVisRes := 0 to res.p_VisResCount -1 do
      begin
        Application.ProcessMessages;
        VisRes := TMqmVisibleRes(res.p_VisRes[iVisRes]);

        for iApa := 0 to VisRes.p_ActAreasCount -1 do
        begin
          Application.ProcessMessages;
          ActArea := TMqmActArea(VisRes.p_ActArea[iApa]);

          if not QryPrepared
          and (ActArea.p_CapResCount > 0) then
          begin
    //        Prepare;
            QryPrepared := true
          end;

          for iCapRes := 0 to ActArea.p_CapResCount -1 do
          begin
            try
            CapRes := TMqmCapRes(ActArea.p_CapRes[iCapRes]);

            if CapRes.m_status <> CDUR_Modi then continue;
            CapRes.p_NewInMemorty := false;
            ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsString   := IniAppGlobals.Identifier;
            ParamByName(CreateFld(tbInfo.pfx, fli_CapacyResrv)).AsInteger := CapRes.p_CapResNum;
            ParamByName(CreateFld(tbInfo.pfx, fli_updCode)).AsInteger     := updNum + 1;
            ParamByName(CreateFld(tbInfo.pfx, fli_rsc)).AsString          := Res.p_ResCode;
            ParamByName(CreateFld(tbInfo.pfx, fli_subLinRscId)).AsInteger := VisRes.p_SubCode;
            ParamByName(CreateFld(tbInfo.pfx, fli_WCProcess)).AsString    := CapRes.m_WCProc;
            case capRes.m_Type of
                cr_Normal: ParamByName(CreateFld(tbInfo.pfx, fli_CapacyResTyp)).AsString := '1';
                cr_DownTime: ParamByName(CreateFld(tbInfo.pfx, fli_CapacyResTyp)).AsString := '2';
                Cr_CrossingDtm : ParamByName(CreateFld(tbInfo.pfx, fli_CapacyResTyp)).AsString := '3';
            end;
            ParamByName(CreateFld(tbInfo.pfx, fli_Capacity_To_Job)).AsString  := IntToStr(CapRes.m_UpMostCase);
            ParamByName(CreateFld(tbInfo.pfx, fli_Comment)).AsString          := CapRes.m_Comment;
            ParamByName(CreateFld(tbInfo.pfx, fli_schedStart)).AsDateTime     := CapRes.p_start;
            ParamByName(CreateFld(tbInfo.pfx, fli_schedEnd)).AsDateTime       := CapRes.p_end;
            ParamByName(CreateFld(tbInfo.pfx, fli_ColorIndex)).AsInteger      := CapRes.m_ColorIndex;
            ParamByName(CreateFld(tbInfo.pfx, fli_exeMin)).AsFloat            := CapRes.p_dur;

            ExecSQL;

            except
              showmessage(_('Updating of Capacity reservation was ignored'));
              if Assigned(Res) and Assigned(VisRes) and assigned(CapRes) then
                CopyUnSavedValuesToFolder(false,SevedClickTime,capResNum,Res.p_ResCode,VisRes.p_SubCode,CapRes);
              continue
            end;

            Application.ProcessMessages;
            SaveCapResProp(CapResQry, SuffixTblName, CapRes);
            CapRes.m_status := CDUR_None
          end;
        end;
      end;
    end;

    QryPrepared := false;
    SQL.Clear;
    //SQL.Add('delete from ' + SuffixTblName + tbInfo.GetTableName);
    SQL.Add('update ' + SuffixTblName + TbInfo.GetTableName + ' set ');
    SQL.Add(CreateFld(tbInfo.pfx, fli_updCode)                + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_updCode)          + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_CapacyResrvStatus)      + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_CapacyResrvStatus));
    SQL.Add(' where ');
    SQL.Add(CreateFld(tbInfo.pfx, fli_IDENTIFIER)   + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_IDENTIFIER) + ' and ');
    SQL.Add(CreateFld(tbInfo.pfx, fli_CapacyResrv) + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_CapacyResrv));

  {  if not QryPrepared
    and (p_pl.p_ObjToDelCount > 0) then
      Prepare;   }

    for iCapRes := 0 to p_pl.p_ObjToDelCount-1 do
    begin
      ObjToDel := p_pl.p_ObjToDel[iCapRes];
      if not (ObjToDel is TMqmCapRes) then
        continue;
      CapRes := TMqmCapRes(ObjToDel);

      if CapRes.m_status <> CDUR_del then continue;

      ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsString   := IniAppGlobals.Identifier;
      ParamByName(CreateFld(tbInfo.pfx, fli_CapacyResrv)).AsInteger := CapRes.p_CapResNum;
      ParamByName(CreateFld(tbInfo.pfx, fli_updCode)).AsInteger     := updNum + 1;
      ParamByName(CreateFld(tbInfo.pfx, fli_CapacyResrvStatus)).AsString := '3';
      ExecSQL;
      Application.ProcessMessages;
      SaveCapResProp(CapResQry, SuffixTblName, CapRes);
      CapRes.m_status := CDUR_None
    end;

    Close;
    Transaction.Commit;

  end;
  CapResQry.Close;
  CapResQry.Free;

end;

//----------------------------------------------------------------------------//

function CopyUnSavedPropValuesToFolder(SavedClickTime : TDateTime; capRes: TMqmCapRes; PropValue : string; propCode : string) : boolean;
var
  StrLst : TStringList;
begin
  Result := false;
  StrLst := TStringList.Create;
  try
     StrLst.LoadFromFile(LocAppGlobals.AppDir + '\MqmSaveCapPropertyLog.txt');
  except
  end;

  if (StrLst.Count > 500) then
     StrLst.clear;

  StrLst.add('-------------------- Insert Cap Property -------------------');
  if not assigned(CapRes) then
  begin
    StrLst.add('Cap res Not assigned');
  end
  else
  begin
    StrLst.add('CapResNum : ' + intTostr(CapRes.p_CapResNum));
    StrLst.add('PropValue : ' + PropValue);
    StrLst.add('PropCode : '  + PropCode);
    StrLst.add('usrCg : '  + IniAppGlobals.WkstCode);
  end;
  StrLst.SaveToFile(LocAppGlobals.AppDir + '\MqmSaveCapPropertyLog.txt');
  StrLst.Free;
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.SaveCapResProp(qry: TMqmQuery; SuffixTblName: string; ObjCapRes: TMqmObj);
var
  capRes:  TMqmCapRes;
  prop: TPropID;
  tbInfo:  ^TTblInfo;
  iProp: integer;
  RscCode: string;
  SavedClickTime : TDateTime;
begin
  SavedClickTime := now;
  capRes := TMqmCapRes(ObjCapRes);
  tbInfo := @tblInfo[tbl_prop_capRes];
//  SetFldPfx(tbInfo.pfx);

  Qry.Transaction.StartTransaction;

  with qry do
  begin
    Application.ProcessMessages;
    SQL.Clear;
    SQL.Add('delete from ' + tbInfo.GetTableName);
    SQL.Add('where');
    SQL.Add(CreateFld(tbInfo.pfx, fli_CapacyResrv)  + '= ');
    SQL.Add('''' + IntToStr(capRes.p_CapResNum) + '''');
    SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));

    ExecSQL;

    SQL.Clear;

    SQL.Add('insert into ' + SuffixTblName + tbInfo.GetTableName + '(');
    SQL.Add(CreateFld(tbInfo.pfx, fli_IDENTIFIER)  + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_CapacyResrv)  + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_PropertyCode) + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_PropValue)    + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_usrCg)        + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_usrTmCg));

    SQL.Add(') values (');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_IDENTIFIER)  + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_CapacyResrv)  + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_PropertyCode) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_PropValue)    + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_usrCg)        + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_usrTmCg));

    SQL.Add(')');
 //   Prepare;

    for iProp := 0 to CapRes.m_propList.p_PropCount -1 do
    begin
      try
      Application.ProcessMessages;
      ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsString   := IniAppGlobals.Identifier;
      ParamByName(CreateFld(tbInfo.pfx, fli_CapacyResrv)).AsInteger := CapRes.p_CapResNum;
      ParamByName(CreateFld(tbInfo.pfx, fli_PropValue)).AsString    := CapRes.m_propList.GetProperty(iProp,prop,RscCode); //--prop
      ParamByName(CreateFld(tbInfo.pfx, fli_PropertyCode)).AsString := GetPropCodeFromID(prop);
      ParamByName(CreateFld(tbInfo.pfx, fli_usrCg)).AsString := IniAppGlobals.WkstCode;
      ParamByName(CreateFld(tbInfo.pfx, fli_usrTmCg)).AsDateTime := now;
      ExecSQL;
      except
        showmessage(_('Saving of Capacity reservation Properties was ignored'));
        CopyUnSavedPropValuesToFolder(SavedClickTime, CapRes, CapRes.m_propList.GetProperty(iProp,prop,RscCode), GetPropCodeFromID(prop));
      end;
    end;

    Close;
    Transaction.Commit;

  end;

end;


//----------------------------------------------------------------------------//

function TMqmPlan.FindWrkCtrByCode(WkcCode: string): pointer;
var
  i: integer;
  L, H: integer;
  Found: boolean;
begin
  Result := nil;

//  Binary search we have to sort the list before using it

  L := 0;
  H := p_WrkCtrsCount-1;
  Found := false;

  while (L <= H) and not Found do
  begin

    i := (H-L) div 2;
    if i < L then i := L+i;
    if i > H then i := H-i;

    if (WkcCode < TMqmWrkCtr(p_WrkCtr[i]).p_WrkCtrCode) then
      H := i - 1
    else
      if (WkcCode > TMqmWrkCtr(p_WrkCtr[i]).p_WrkCtrCode) then
        L := i + 1
      else
      begin
        Result := TMqmObj(p_WrkCtr[i]);
        Found := true
      end;
  end;

end;

//----------------------------------------------------------------------------//

function TMqmPlan.FindWrkCtrByGrpAndPlantCode(WkcGrp, WkcPlant : string): pointer;
var
  i: integer;
//  Multiplier, NumberOfEntries, NumberOfEntriesMinusOne : integer;
begin
  Result := nil;
  for I := 0 to p_WrkCtrsCount - 1 do
  begin
    if ((TMqmWrkCtr(p_WrkCtr[i]).P_WcGrp = WkcGrp)) and ((TMqmWrkCtr(p_WrkCtr[i]).p_PlantCode = WkcPlant)) then
    begin
      result := TMqmWrkCtr(p_WrkCtr[i]);
      break
    end;
  end;

{  Result := nil;

  NumberOfEntries := p_WrkCtrsCount;
  if NumberOfEntries = 0 then exit;
  NumberOfEntriesMinusOne := NumberOfEntries - 1;

  Multiplier := 1;
  while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    i := Multiplier - 1;

  while (Multiplier > 0) do
  begin
    Multiplier := trunc(Multiplier / 2);

    if (i > NumberOfEntriesMinusOne)
    or ((TMqmWrkCtr(p_WrkCtr[i]).P_WcGrp > WkcGrp)) then
    begin
      i := i - Multiplier;
      Continue;
    end;

    if ((TMqmWrkCtr(p_WrkCtr[i]).P_WcGrp < WkcGrp)) then
    begin
      i := i + Multiplier;
      Continue;
    end;

    if ((TMqmWrkCtr(p_WrkCtr[i]).p_PlantCode < WkcPlant)) then
    begin
      i := i + Multiplier;
      Continue;
    end;

    if ((TMqmWrkCtr(p_WrkCtr[i]).p_PlantCode < WkcPlant)) then
    begin
      i := i - Multiplier;
      Continue;
    end;

    Result := TMqmWrkCtr(p_WrkCtr[i]);
    Break;

  end;  }

end;

//----------------------------------------------------------------------------//

function TMqmPlan.FindWrkCtrMainByWrkCtrAndPlantCode(WkcPlant, PlanedWc : string): pointer;
var
  i: integer;
begin
  Result := nil;
  for I := 0 to p_WrkCtrsCount - 1 do
  begin
    if ((TMqmWrkCtr(p_WrkCtr[i]).p_WrkCtrCode = PlanedWc)) and ((TMqmWrkCtr(p_WrkCtr[i]).p_PlantCode = WkcPlant)) then
    begin
      result := TMqmWrkCtr(p_WrkCtr[i]);
      break
    end;
  end;

end;

//----------------------------------------------------------------------------//

function TMqmPlan.FindAltWcByCode(WkcCode: string ; Process : string ;AltList : TList): boolean;
var
  I : Integer;
  AltRec : PAltWkcRec;
begin
  Result := false;
  for I := 0 to m_AltWrkCtrs.count -1 do
  begin
    if (PAltWkcRec(m_AltWrkCtrs[I]).WorkCenter = WkcCode) and (PAltWkcRec(m_AltWrkCtrs[I]).Process = Process) then
    begin
      New(AltRec);
      AltRec.WorkCenter := PAltWkcRec(m_AltWrkCtrs[I]).WorkCenter;
      AltRec.Process := PAltWkcRec(m_AltWrkCtrs[I]).Process;
      AltRec.AltWorkCenter := PAltWkcRec(m_AltWrkCtrs[I]).AltWorkCenter;
      AltRec.AltWorkCenterDesc := PAltWkcRec(m_AltWrkCtrs[I]).AltWorkCenterDesc;
      AltRec.AltProcess := PAltWkcRec(m_AltWrkCtrs[I]).AltProcess;
      AltRec.AltProcessDesc := PAltWkcRec(m_AltWrkCtrs[I]).AltProcessDesc;
      AltRec.WStation := PAltWkcRec(m_AltWrkCtrs[I]).WStation;
      Result := true;
      AltList.Add(AltRec);
    end
  end
end;

//----------------------------------------------------------------------------//

function TMqmPlan.FindAltListWc(WkcCode: string ; AltList : TList): boolean;
var
  I : Integer;
  AltRec : PAltWkcRec;
begin
  Result := false;
  for I := 0 to m_AltWrkCtrsGen.count -1 do
  begin
    if (PAltWkcRec(m_AltWrkCtrsGen[I]).AltWorkCenter = WkcCode) then
    begin
      New(AltRec);
      AltRec.WorkCenter := PAltWkcRec(m_AltWrkCtrsGen[I]).WorkCenter;
      AltRec.Process := PAltWkcRec(m_AltWrkCtrsGen[I]).Process;
      Result := true;
      AltList.Add(AltRec);
    end
  end
end;

//----------------------------------------------------------------------------//

function TMqmPlan.FindResByCode(resCode: string): TMqmObj;
var
  i: integer;
begin
  Result := nil;

  for i := 0 to p_WrkCtrsCount-1 do
  begin
    Result := TMqmWrkCtr(p_WrkCtr[i]).FindRsrcByCode(resCode);
    if Assigned(Result) then exit
  end
end;

//----------------------------------------------------------------------------//

function TMqmPlan.FindCapResByCode(capResCode: integer; removeCapRes : boolean): TMqmObj;
var
  iRes, iVisRes, iApa, iCapRes: integer;
  capRes:  TMqmCapRes;
  res:     TMqmRes;
  VisRes:  TMqmVisibleRes;
  ActArea: TMqmActArea;
begin
  Result := nil;
  if not Assigned(m_resList) then exit;

  for iRes := 0 to m_ResList.Count -1 do
  begin
    res := TMqmRes(m_ResList[iRes]);

    for iVisRes := 0 to res.p_VisResCount -1 do
    begin
      VisRes := TMqmVisibleRes(res.p_VisRes[iVisRes]);

      for iApa := 0 to VisRes.p_ActAreasCount -1 do
      begin
        ActArea := TMqmActArea(VisRes.p_ActArea[iApa]);

        for iCapRes := 0 to ActArea.p_CapResCount -1 do
        begin
          CapRes := TMqmCapRes(ActArea.p_CapRes[iCapRes]);

          if CapRes.p_CapResNum = CapResCode then
          begin
            Result := CapRes;
            if removeCapRes then
            begin
              ActArea.RemoveCapRes(capRes);
              result := nil;
            end;
            exit
          end;
        end;
      end;
    end;
  end;

end;

//----------------------------------------------------------------------------//

function TMqmPlan.AddRow(pObj: pointer): integer;
begin
  Result := m_ResList.Add(pObj)
end;

//----------------------------------------------------------------------------//

function TMqmPlan.GetResCat(Code, descr: string; Create: Boolean): TMqmResCat;
var
  i: integer;
begin
  Result := nil;

  for i := 0 to m_ResCatList.Count-1 do
    if TMqmResCat(m_ResCatList[i]).p_ResCatCode = Code then
    begin
      Result := TMqmResCat(m_ResCatList[i]);
      exit;
    end;

  if Create then
  begin
    Result := TMqmResCat.CreateResCat(Code, descr);
    m_ResCatList.Add(Result)
  end
end;

//----------------------------------------------------------------------------//

function TMqmPlan.GetRes(I : integer) : Pointer;
begin
  Result := TMqmRes(m_ResList[I]);
end;

//----------------------------------------------------------------------------//

function TMqmPlan.GetSavePLanCopyCount : integer;
begin
  Result := m_SavedplanCopy.count;
end;

//----------------------------------------------------------------------------//

function TMqmPlan.ResCount : integer;
begin
  Result := m_ResList.count
end;

//----------------------------------------------------------------------------//

procedure WritePropVal(sl: TStringList; str, cls: string; empty: integer; pId: TPropID; obj: TObject);
begin
  str := str + '<TD>' + FormatToShow(pId, TPropVal(obj).m_val) + '</TD></TD>';
  sl.Add(str)
end;

//----------------------------------------------------------------------------//

procedure WritePropList(title: string; sl: TStringList; lst: TList);
var
  i:       integer;
  origMtx: TOrigMatrix;
  titWrit: boolean;
begin
  titWrit := false;
  for i := 0 to lst.Count-1 do
  begin
    origMtx := TOrigMatrix(lst[i]);
    if not titWrit then
    begin
      titWrit := false;
      sl.Add('<H2 align=center>' + title + '</H2>');
      sl.Add('<H3 align=center>' + _('Property values') + '</H3>');
    end;
    sl.Add('<TABLE align=center cellpadding=3 cellspacing=2>');

    case origMtx.m_mtx of
    CMX_code:           origMtx.PrintHdrAsHtml(sl, [_('Value')]);
    CMX_code_proc:      origMtx.PrintHdrAsHtml(sl, [_('Process'), _('Value')]);
    CMX_code_prod:      origMtx.PrintHdrAsHtml(sl, [_('Product type'), _('Value')]);
    CMX_code_cat:       origMtx.PrintHdrAsHtml(sl, [_('Resource category'), _('Value')]);
    CMX_code_prod_cat:  origMtx.PrintHdrAsHtml(sl, [_('Product type'), _('Resource category'), _('Value')]);
    CMX_code_prod_proc: origMtx.PrintHdrAsHtml(sl, [_('Product type'), _('Process'), _('Value')]);
    end;

    origMtx.PrintDataAsHtml(sl, 'rowEven', 'rowOdd', WritePropVal);
    sl.Add('</TABLE>');
  end;
end;

//----------------------------------------------------------------------------//

procedure WriteRuleRtoO(sl: TStringList; str, cls: string; empty: integer; pId: TPropID; obj: TObject);
var
  i:        integer;
  rule:     TCompRules;
  checkSeq: integer;
  value:    variant;
  op:       TRuleOpType;
  toBase:   string;
  comp:     TCompatVal;
  emptyStr: string;
begin
  FmtStr(emptyStr, '<TR class="%s">', [cls]);
  for i := 1 to empty do
    emptyStr := emptyStr + '<TD></TD>';

  rule := TCompRules(obj);
  for i := 0 to rule.GetItemCount-1 do
  begin
    rule.GetItem(i, checkSeq, toBase, value, op, comp);
    str := str + '<TD>' + IntToStr(checkSeq) + '</TD><TD>' + toBase + '</TD><TD>' + FormatToShow(pId, value) + '</TD><TD>' + RTtypeToChar(op) + '</TD><TD>' + IntToStr(comp);
    sl.Add(str + '</TD></TR>');
    str := emptyStr
  end
end;

//----------------------------------------------------------------------------//

procedure WriteRtoOrulesList(title: string; sl: TStringList; lst: TList);
var
  i:       integer;
  origMtx: TOrigMatrix;
  titWrit: boolean;
begin
  titWrit := false;
  for i := 0 to lst.Count-1 do
  begin
    origMtx := TOrigMatrix(lst[i]);
    if not titWrit then
    begin
      titWrit := false;
      sl.Add('<H2 align=center>' + title + '</H2>');
      sl.Add('<H3 align=center>' + _('Resource to occupation compatibility rules') + '</H3>');
    end;
    sl.Add('<TABLE align=center cellpadding=3 cellspacing=2>');

    case origMtx.m_mtx of
    CMX_code:           origMtx.PrintHdrAsHtml(sl, [_('chk. seq.'), _('to base'), _('value'), _('op'), _('comp. value')]);
    CMX_code_proc:      origMtx.PrintHdrAsHtml(sl, [_('Process'), _('chk. seq.'), _('to base'), _('value'), _('op'), _('comp. value')]);
    CMX_code_prod:      origMtx.PrintHdrAsHtml(sl, [_('Product type'), _('chk. seq.'), _('to base'), _('value'), _('op'), _('comp. value')]);
    CMX_code_cat:       origMtx.PrintHdrAsHtml(sl, [_('Resource category'), _('chk. seq.'), _('to base'), _('value'), _('op'), _('comp. value')]);
    CMX_code_prod_cat:  origMtx.PrintHdrAsHtml(sl, [_('Product type'), _('Resource category'), _('chk. seq.'), _('to base'), _('value'), _('op'), _('comp. value')]);
    CMX_code_prod_proc: origMtx.PrintHdrAsHtml(sl, [_('Product type'), _('Process'), _('chk. seq.'), _('to base'), _('value'), _('op'), _('comp. value')]);
    end;

    origMtx.PrintDataAsHtml(sl, 'rowEven', 'rowOdd', WriteRuleRtoO);
    sl.Add('</TABLE>');
  end;
end;

//----------------------------------------------------------------------------//

procedure WriteRuleOtoO(sl: TStringList; str, cls: string; empty: integer; pId: TPropID; obj: TObject);
var
  i:        integer;
  rule:     TCompRules;
  checkSeq: integer;
  value:    variant;
  op:       TRuleOpType;
  toBase:   string;
  comp:     TCompatVal;
  emptyStr: string;
  supRec:   PTSetupRec;
begin
  FmtStr(emptyStr, '<TR class="%s">', [cls]);
  for i := 1 to empty do
    emptyStr := emptyStr + '<TD></TD>';

  rule := TCompRules(obj);
  for i := 0 to rule.GetItemCount-1 do
  begin
    supRec := rule.GetItem(i, checkSeq, toBase, value, op, comp);
    Assert(Assigned(supRec));
    str := str + '<TD>' + IntToStr(checkSeq) + '</TD><TD>' + toBase + '</TD><TD>' + FormatToShow(pId, value) + '</TD><TD>' + RTtypeToChar(op) + '</TD><TD>' + IntToStr(comp);
    str := str + '</TD><TD>' + FromSadjToChar(supRec.supAdjType) + '</TD><TD>' + FloatToStr(supRec.supTime) + '</TD><TD>' + FloatToStr(supRec.supOverlap);
    str := str + '</TD><TD>' + FloatToStr(supRec.supMult) + '</TD><TD>' + FloatToStr(supRec.supMultOverlap);
    if supRec.onSameGroup then
      str := str + '</TD><TD>' + _('yes')
    else
      str := str + '</TD><TD>' + _('no');

    sl.Add(str + '</TD></TR>');
    str := emptyStr
  end
end;

//----------------------------------------------------------------------------//

procedure WriteOtoOrulesList(title: string; sl: TStringList; lst: TList);
var
  i:       integer;
  origMtx: TOrigMatrix;
  titWrit: boolean;
begin
  titWrit := false;
  for i := 0 to lst.Count-1 do
  begin
    origMtx := TOrigMatrix(lst[i]);
    if not titWrit then
    begin
      titWrit := false;
      sl.Add('<H2 align=center>' + title + '</H2>');
      sl.Add('<H3 align=center>' + _('Occupation to occupation compatibility rules') + '</H3>');
    end;
    sl.Add('<TABLE align=center cellpadding=3 cellspacing=2>');

    case origMtx.m_mtx of
    CMX_code:           origMtx.PrintHdrAsHtml(sl, [_('chk. seq.'), _('to base'), _('value'), _('op'), _('comp. value'), _('sup.type'), _('sup.time'), _('sup.over'), _('sup.mult.'), _('sup.over.mult'), _('same grp.')]);
    CMX_code_proc:      origMtx.PrintHdrAsHtml(sl, [_('Process'), _('chk. seq.'), _('to base'), _('value'), _('op'), _('comp. value'), _('sup.type'), _('sup.time'), _('sup.over'), _('sup.mult.'), _('sup.over.mult'), _('same grp.')]);
    CMX_code_prod:      origMtx.PrintHdrAsHtml(sl, [_('Product type'), _('chk. seq.'), _('to base'), _('value'), _('op'), _('comp. value'), _('sup.type'), _('sup.time'), _('sup.over'), _('sup.mult.'), _('sup.over.mult'), _('same grp.')]);
    CMX_code_cat:       origMtx.PrintHdrAsHtml(sl, [_('Resource category'), _('chk. seq.'), _('to base'), _('value'), _('op'), _('comp. value'), _('sup.type'), _('sup.time'), _('sup.over'), _('sup.mult.'), _('sup.over.mult'), _('same grp.')]);
    CMX_code_prod_cat:  origMtx.PrintHdrAsHtml(sl, [_('Product type'), _('Resource category'), _('chk. seq.'), _('to base'), _('value'), _('op'), _('comp. value'), _('sup.type'), _('sup.time'), _('sup.over'), _('sup.mult.'), _('sup.over.mult'), _('same grp.')]);
    CMX_code_prod_proc: origMtx.PrintHdrAsHtml(sl, [_('Product type'), _('Process'), _('chk. seq.'), _('to base'), _('value'), _('op'), _('comp. value'), _('sup.type'), _('sup.time'), _('sup.over'), _('sup.mult.'), _('sup.over.mult'), _('same grp.')]);
    end;

    origMtx.PrintDataAsHtml(sl, 'rowEven', 'rowOdd', WriteRuleOtoO);
    sl.Add('</TABLE>');
  end
end;

//----------------------------------------------------------------------------//

function TMqmPlan.GetCompatModeInPlanId: TSchedId;
begin
  Result := m_compId
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.EnterCompatModeInPlan(id: TSchedId);
var
  i:   integer;
  res: TMqmRes;
begin
  m_compId := id;
  if not p_sc.IsProdSchedMaterial(Id) then
  begin
    m_calcTmg.SetMainId(id);
    m_calcOvlp.SetMainId(id);
  end;

  // clear all compatibility fields in plan
  for i := 0 to m_ResList.Count -1 do
  begin
    res := TMqmRes(m_ResList[i]);
    res.ClearCompatCaches
  end;

  // clear all compatibility fields in bin
  p_sc.EnterCompatModeInPlan(id)
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.EnterCompatModeInPlanForAutoSeq(id: TSchedId; Res : Pointer);
begin
  m_compId := id;
  m_calcTmg.SetMainId(id);
  m_calcOvlp.SetMainId(id);
  TMQMres(res).ClearCompatCaches;
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.ExitCompatModeInPlanForAutoSeq;
begin
  Assert(m_compId <> CSchedIdNull);
  m_compId := CSchedIdNull;
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.EnterCompatModeInPlanForSplit(id: TSchedId);
begin
  m_compId := id;
  m_calcTmg.SetMainId(id);
  m_calcOvlp.SetMainId(id);
end;

//----------------------------------------------------------------------------//

function TMqmPlan.GetCompatModeInPlanCapRes: TMqmObj;
begin
  Result := m_compCapRes
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.ExitCompatModeInPlan;
begin
//  Assert(m_compId <> CSchedIdNull);
  m_compId := CSchedIdNull;

  p_sc.ExitCompatModeInPlan
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.EnterCompatModeInPlanCapRes(CapRes: TMqmObj);
var
  i:   integer;
  res: TMqmRes;
begin
  m_CompCapRes := CapRes;

  // clear all compatibility fields in plan
  for i := 0 to m_ResList.Count -1 do
  begin
    res := TMqmRes(m_ResList[i]);
    res.ClearCompatCaches
  end;

  // clear all compatibility fields in bin
//  p_sc.EnterCompatModeInPlan(id)
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.ExitCompatModeInPlanCapRes;
begin
  Assert(Assigned(m_CompCapRes));
  m_CompCapRes := nil;

//  p_sc.ExitCompatModeInPlan
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.UpdateCompatModeInPlanCapRes;
var
  CapRes: TMqmObj;
begin
  CapRes := m_CompCapRes;
  ExitCompatModeInPlanCapRes;
  EnterCompatModeInPlanCapRes(CapRes)
end;

//----------------------------------------------------------------------------//

function TMqmPlan.GetCompatModeInBinVisRes: TMqmObj;
begin
  Result := m_visRes
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.EnterCompatModeInBin(visRes: TMqmObj);
var
  i: integer;
  res: TMqmRes;
begin
  m_visRes := visRes;

  // clear all compatibility fields in plan
  for i := 0 to m_ResList.Count -1 do
  begin
    res := TMqmRes(m_ResList[i]);
    res.ClearCompatCaches
  end;

end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.ExitCompatModeInBin;
begin
  m_visRes := nil
end;

//----------------------------------------------------------------------------//

function TMqmPlan.GetWorkCenterProcessFromRes(ResCode : string ; Pd_Wc : string; Pd_Process : string; var wc : string; var process : string) : boolean;
var
  WcResource : string;
  res :   TMqmRes;
begin
  result := true;
  wc := Pd_Wc;
  process := Pd_Process;

  res := TMqmRes(FindResByCode(ResCode));
  if Assigned(res) then
    WcResource := TMqmWrkCtr(res.p_WrkCtr).p_WrkCtrCode
  else
  begin
    Result := false;
    Exit;
  end;

  if (WcResource <> Pd_Wc) then
  begin
    // Get alternative process
    TMqmWrkCtr(res.p_WrkCtr).GetAltProcForAltWrkCtr(Pd_Process, TMqmWrkCtr(res.p_Father).p_WrkCtrCode, process);
    wc := WcResource;
  end;

end;

//----------------------------------------------------------------------------//

function TMqmPlan.HasTimingsOnRes(resObj: TMqmObj): boolean;
begin
  Assert(m_compId <> CSchedIdNull);
  Result := m_calcTmg.CanGoOnRes(resObj)
end;

//----------------------------------------------------------------------------//

function TMqmPlan.HasJobWasDeletetedFromHost(Request : string; ProdStep : Integer; var UnSchedule : boolean) : boolean;
var
  tbInfo: ^TTblInfo;
  qry:    TMqmQuery;
  LastUpdate : Integer;
begin
  Result := false;
  UnSchedule := false;

  if IniAppGlobals.External_Database_Update = '1' then
  begin
    if ExternalDB_CheckRequestStepInToNotSaveList(Request, IntToStr(ProdStep)) then
    begin
      Result := true;
      UnSchedule := true
    end;
    Exit;
  end;

  qry := CreateQuery(Main_DB);
  LastUpdate := DBAppGlobals.LastUpdatNr;
  tbInfo := @tblInfo[tbl_Req_Change];

  with qry do
  begin
    SQL.Clear;
    Sql.Add('select * from ' + tbInfo.GetTableName);
    sql.add(WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
    Sql.Add(' AND ');
    SQL.Add(CreateFld(tbInfo.pfx, fli_preqNo) + '=' + '''' + Request + '''');
    SQL.Add(' and ' + CreateFld(tbInfo.pfx, fli_updCode) + '>' + IntToStr(LastUpdate) + ' and((');
    SQL.Add(CreateFld(tbInfo.pfx, fli_pstepId) + '=''' + IntToStr(0) + '''');
    SQL.Add( ' and ');
    SQL.Add(CreateFld(tbInfo.pfx, fli_ChangeType) + ' in(' + '4,' + '5,' + '6' + '))');
    SQL.Add( ' or (');
    SQL.Add(CreateFld(tbInfo.pfx, fli_pstepId) + '=''' + IntTostr(ProdStep) + '''');
    SQL.Add( ' and ');
    SQL.Add(CreateFld(tbInfo.pfx, fli_ChangeType) + ' in(' + '3,' + '4,' + '5' + ')))');
    Open;
    if EOF then
       Result := false
    else
    begin
      while not EOF do
      begin
        if (FieldByName(CreateFld(tbInfo.pfx, fli_pstepId)).AsInteger = 0) then
        begin
          if (FieldByName(CreateFld(tbInfo.pfx, fli_ChangeType)).AsString = '4') or
             (FieldByName(CreateFld(tbInfo.pfx, fli_ChangeType)).AsString = '5') then
          begin
            Result := true;
            Break;
          end;
          UnSchedule := true;
          next;
        end
        else
        begin
          if (FieldByName(CreateFld(tbInfo.pfx, fli_ChangeType)).AsString = '3') or
             (FieldByName(CreateFld(tbInfo.pfx, fli_ChangeType)).AsString = '4') then
          begin
            Result := true;
            Break;
          end;
          UnSchedule := true;
          Next;
        end;
      end;
    end;

  end;

  qry.Close;
  qry.Free;

end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.GetTmgDescList(DescList: TStringList);
begin
  Assert(m_compId <> CSchedIdNull);
  m_calcTmg.GetDescList(DescList)
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.SetTmgMainID(id: TSchedID);
begin
  Assert(id <> CSchedIdNull);
  m_calcTmg.SetMainId(id);
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.SetTmgTargetRes(resObj: TObject);
begin
  Assert(m_compId <> CSchedIdNull);
  Assert(resObj is TMqmRes);
  m_calcTmg.SetTargetRes(resObj)
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.ReCreateCalcTmg;
begin
  if Assigned(m_calcTmg) then
    m_calcTmg.Free;
  m_calcTmg := TMCalcTimings.CreateCalc;
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.SetTmgByDescr(Descr: string);
begin
  Assert(m_compId <> CSchedIdNull);
  m_calcTmg.SetByDescr(Descr)
end;


//----------------------------------------------------------------------------//

procedure TMqmPlan.UpdateGrpTmg;
begin
  m_calcTmg.UpdateGrpTmg
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.SetOvplTargetRes(resObj: TObject; OvlpChk : TypeOvlpChk; Setup : double);
begin
  Assert(m_compId <> CSchedIdNull);
  if assigned(resObj) then
    Assert(resObj is TMqmVisibleRes);
  m_calcOvlp.SetTargetRes(resObj, OvlpChk, Setup)
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.GetMainTimingsOrig(var supMin, exeMin: double; var Descr: string; var MSC: string);
begin
  m_calcTmg.GetMainTimingsOrig(supMin, exeMin, descr, MSC)
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.GetMainTimings(var supMin, exeMin: double; var Descr: string; var MSC: string);
begin
  m_calcTmg.GetMainTimings(supMin, exeMin, descr, MSC)
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.GetOverlaps(var LowLimit, HighLimit: TDateTime);
begin
  m_calcOvlp.GetMainOverlaps(LowLimit, HighLimit)
end;

//----------------------------------------------------------------------------//

function TMqmPlan.GetAllCalendarsForEfficiencyOnWcOrResourceLevel(CalCode : string; EfficiencyOnLevel : CEfficiencyOnLevel; workCenter : Pointer) : TList;
var
  I,J : Integer;
  WC:     TMqmWrkCtr;
  Rsc:    TMqmRes;
  VisRes: TMqmVisibleRes;
begin
  Result := TList.Create;

  if EfficiencyOnLevel = Eff_And_Cal_Both_Lvl_Res then
  begin
    WC := TMqmWrkCtr(workCenter);
    for i := 0 to wc.p_ResCount - 1 do
    begin
      Rsc := TMqmRes(Wc.p_Res[I]);
      TMqmVisibleRes(Rsc.p_VisRes[0]).p_Calendar;
      if (TMqmVisibleRes(Rsc.p_VisRes[0]).p_EfficiencyOnLevel = Eff_And_Cal_Both_Lvl_Res) and (TMqmVisibleRes(Rsc.p_VisRes[0]).p_CalCodReal = calCode) then
      begin
        Result.add(TMqmVisibleRes(Rsc.p_VisRes[0]).GetCalendar);
        if TMqmVisibleRes(Rsc.p_VisRes[0]).p_isSubRes then // should be the oposite condition
           break
      end;
    end;
  end
  else if EfficiencyOnLevel = EffLvl_Wc then
  begin
    WC := TMqmWrkCtr(workCenter);
    for i := 0 to wc.p_ResCount - 1 do
    begin
      Rsc := TMqmRes(Wc.p_Res[I]);
      TMqmVisibleRes(Rsc.p_VisRes[0]).p_Calendar;
      if (TMqmVisibleRes(Rsc.p_VisRes[0]).p_EfficiencyOnLevel = EffLvl_Wc) and (TMqmVisibleRes(Rsc.p_VisRes[0]).p_CalCodReal = calCode) then
         Result.add(TMqmVisibleRes(Rsc.p_VisRes[0]).GetCalendar);
    end;
  end
  else if EfficiencyOnLevel = EffLvl_Res then
  begin
    for i := 0 to m_ResList.Count - 1 do
    begin
      Rsc := m_ResList[i];
      for j := 0 to Rsc.p_VisResCount -1 do
      begin
        VisRes := Rsc.p_VisRes[j];
        TMqmVisibleRes(Rsc.p_VisRes[0]).p_Calendar;
        if (VisRes.p_EfficiencyOnLevel = EfficiencyOnLevel) and (VisRes.p_CalCodReal = CalCode) then
           Result.add(VisRes.GetCalendar);
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//
{old overlap
function TMqmPlan.GetOverlapRule(wkcCode, wkcProc, resCode, resCat: string): PTMOvlpRuleRec;
begin
  Result := m_OvplRules.FindTheRule(wkcCode, wkcProc, resCode, resCat)
end;

//----------------------------------------------------------------------------//

function TMqmPlan.GetOverlapQty(wkcCode, wkcProc, resCode, resCat, um: string): PTMOvlpQtyRec;
begin
  Result := m_OvplRules.FindTheQty(wkcCode, wkcProc, resCode, resCat, um)
end;
}
//----------------------------------------------------------------------------//

procedure TMqmPlan.GetSubTimings(pos: integer; var id: TSchedId;
                                 var supMin, exeMin: double; var Descr: string; var MSC: string);
begin
  m_calcTmg.GetSubTimings(pos, id, supMin, exeMin, Descr, MSC)
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.GetResCatWrkCntrProcessCalcTiming(var WkCentr : string; var Process : string; var Res : string; var CatRes : string);
begin
  m_calcTmg.GetResCatWrkCntrProcessCalcTiming(WkCentr, Process, Res, CatRes)
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.GetResCatWrkCntrProcessSubTimings(pos: integer; var id: TSchedId; var WkCentr : string; var Process : string; var Res : string; var CatRes : string);
begin
  m_calcTmg.GetResCatWrkCntrProcessSubTimings(pos, id, WkCentr, Process, Res, CatRes)
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.RecalcTimings(id: TSchedId);
var
  actArea: TMqmActArea;
  supMinBase:   double;
  TmgDescr: string;
  TmgMSC: string;
  setup, overlap, duration: double;
  planInfo:     TSQplanInfo;
  cal:          TPGCALObj;
  FieldVal: variant;
  dataType: CBinColValType;
  Dummy1, LearningCurveCode : string;
  Dummy2, Dummy3 : double;
begin
  actArea := p_sc.GetExtLinkPtr(id);
  cal := actArea.GetCalendar;
  p_sc.GetPlanInfo(id, planInfo);
  EnterCompatModeInPlan(id);

  SetTmgTargetRes(TMqmRes(actArea.p_res));
  GetMainTimings(supMinBase, duration, TmgDescr, TmgMSC);
  p_sc.GetFldValue(Id, CSC_NoResComp, FieldVal, dataType);

//  if (not CalcDur(id, duration, FieldVal)) or (duration = 0) or
//     (not CalcSetup(id, actArea.GetPrecObj(planInfo.startDate, id), actArea, supMinBase, setup, overlap, Dummy1, Dummy2, Dummy3, LearningCurveCode)) then

  // get the new setup of the object
  if (not CalcSetup(id, actArea.GetPrecObj(planInfo.startDate, id), actArea, supMinBase, setup, overlap, Dummy1, Dummy2, Dummy3, LearningCurveCode)) or
     (not CalcDur(actArea, planInfo.startDate, id, duration, FieldVal, true)) or (duration = 0) then
  begin
    ExitCompatModeInPlan;
    exit;
  end;

//  setup := CalcSetupFormula(supAdj, supMinBase, supConst, supMult, AddToSetup);
//  overlap := CalcSetupOvlpFormula(supAdj, supMinBase, supOvlpConst, supOvlpMult, AddToOverlap);

  // change parameters of the current object
  planInfo.supMinBase := supMinBase;
  planInfo.supMinReal := setup;
  planInfo.supMinOvlp := overlap;
  planInfo.exeMin     := duration;
  planInfo.TmgDescr   := TmgDescr;
  planInfo.MSC        := TmgMSC;
  cal.OfsByWH((setup + duration)/60, true, planInfo.startDate, planInfo.endDate, actArea.m_CrossDownTmList);
  p_sc.SetPlanInfo(id, planInfo);

  ExitCompatModeInPlan
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.PrintCompatReport(sl: TStringList);
const
  fmtPropEvn = '<TR class="rowEven"><TD>%s</TD><TD>%s</TD><TD>%s</TD></TR>';
  fmtPropOdd = '<TR class="rowOdd"><TD>%s</TD><TD>%s</TD><TD>%s</TD></TR>';
var
  i:       integer;
  resCat:  TMqmResCat;
  lst:     TList;
  wkc:     TMqmWrkCtr;
  res:     TMqmRes;
begin
  sl.Add('<H1 align=center>' + _('Properties and rules defined at global level') + '</H1>');
  sl.Add('<BR>');

  lst := TList.Create;
  GlobGetPropMtxs(lst);
  WritePropList('Global', sl, lst);
  lst.Free;

  sl.Add('<BR>');

  lst := GlobGetRulesRtoOMtxs;
  WriteRtoOrulesList('Global', sl, lst);
  lst.Free;

  sl.Add('<BR>');

  lst := GlobGetRulesOtoOMtxs;
  WriteOtoOrulesList('Global', sl, lst);
  lst.Free;

  sl.Add('<BR>');
  sl.Add('<BR>');

  sl.Add('<H1 align=center>' + _('Properties and rules defined at resource category level') + '</H1>');
  sl.Add('<BR>');

  lst := TList.Create;
  for i := 0 to m_ResCatList.Count-1 do
  begin
    resCat := TMqmResCat(m_ResCatList[i]);

    resCat.GetPropMtxs(lst);
    WritePropList(resCat.p_ResCatCode, sl, lst);
    lst.Clear;
  end;
  lst.Free;
  sl.Add('<BR>');

  for i := 0 to m_ResCatList.Count-1 do
  begin
    resCat := TMqmResCat(m_ResCatList[i]);

    lst := resCat.GetRulesRtoOMtxs;
    WriteRtoOrulesList(resCat.p_ResCatCode, sl, lst);
    lst.Free
  end;

  sl.Add('<BR>');

  for i := 0 to m_ResCatList.Count-1 do
  begin
    resCat := TMqmResCat(m_ResCatList[i]);

    lst := resCat.GetRulesOtoOMtxs;
    WriteOtoOrulesList(resCat.p_ResCatCode, sl, lst);
    lst.Free
  end;

  sl.Add('<BR>');
  sl.Add('<BR>');
  sl.Add('<H1 align=center>' + _('Properties and rules defined at workcenter level') + '</H1>');
  sl.Add('<BR>');

  lst := TList.Create;
  for i := 0 to p_WrkCtrsCount-1 do
  begin
    wkc := TMqmWrkCtr(p_WrkCtr[i]);

    wkc.GetPropMtxs(lst, false);
    WritePropList(wkc.p_WrkCtrCode, sl, lst);
    lst.Clear
  end;
  lst.Free;

  sl.Add('<BR>');

  for i := 0 to p_WrkCtrsCount-1 do
  begin
    wkc := TMqmWrkCtr(p_WrkCtr[i]);

    lst := wkc.GetRulesRtoOMtxs;
    WriteRtoOrulesList(wkc.p_WrkCtrCode, sl, lst);
    lst.Free
  end;

  sl.Add('<BR>');

  for i := 0 to p_WrkCtrsCount-1 do
  begin
    wkc := TMqmWrkCtr(p_WrkCtr[i]);

    lst := wkc.GetRulesOtoOMtxs;
    WriteOtoOrulesList(wkc.p_WrkCtrCode, sl, lst);
    lst.Free
  end;

  sl.Add('<BR>');
  sl.Add('<BR>');
  sl.Add('<H1 align=center>' + _('Properties and rules defined at resource level') + '</H1>');
  sl.Add('<BR>');

  lst := TList.Create;
  for i := 0 to m_ResList.Count-1 do
  begin
    res := TMqmRes(m_ResList[i]);

    res.GetPropMtxs(lst, false);
    WritePropList(res.p_ResCode, sl, lst);
    lst.Clear
  end;
  lst.Free;

  sl.Add('<BR>');

  for i := 0 to m_ResList.Count-1 do
  begin
    res := TMqmRes(m_ResList[i]);

    lst := res.GetRulesRtoOMtxs;
    WriteRtoOrulesList(res.p_ResCode, sl, lst);
    lst.Free
  end;

  sl.Add('<BR>');

  for i := 0 to m_ResList.Count-1 do
  begin
    res := TMqmRes(m_ResList[i]);

    lst := res.GetRulesOtoOMtxs;
    WriteOtoOrulesList(res.p_ResCode, sl, lst);
    lst.Free
  end

end;

//----------------------------------------------------------------------------//

function TMqmPlan.BinClientRegister(obj: TObject; fnc: TFncNotyChg; filt: TFncFilter): TMSchedList;
begin
  Result := m_objListSrv.ClientRegister(obj, fnc, filt)
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.BinClientUpdateAll(obj: TObject ; ToSort : boolean);
begin
  //m_objListSrv.MainOneAddedAll(obj, m_schedCont, ToSort);
  m_objListSrv.MainOneAddedAllChangeTab(obj, m_schedCont);
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.BinClientUpdateAllChange(obj: TObject);
begin
  m_objListSrv.MainOneAddedAllChangeTab(obj, m_schedCont);
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.BinClientUnRegister(obj: TObject);
begin
  m_objListSrv.ClientUnRegister(obj)
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.MainUpdateFilterAndSort(obj: TObject);
begin
  m_objListSrv.MainUpdateFilterAndSortTab(obj, m_schedCont);
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.BinAddSortFnc(obj: TObject; Index: integer; fnc: TListSortCompare; Ptr: pointer);
begin
  m_objListSrv.AddSortFnc(obj, Index, fnc, Ptr);
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.BinSetAllSortIndex(NewIndex: integer);
begin
  m_objListSrv.SetAllSortIndex(NewIndex);
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.BinSetSortIndex(obj : TObject ; NewIndex : Integer);
begin
  m_objListSrv.SetSortIndex(Obj,NewIndex);
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.PrintResourceReport(sl: TStringList);
const
  fmtPropEvn = '<TR class="rowEven"><TD>%s</TD><TD>%s</TD><TD>%s</TD></TR>';
  fmtPropOdd = '<TR class="rowOdd"><TD>%s</TD><TD>%s</TD><TD>%s</TD></TR>';
var
//  i:       integer;
//  resCat:  TMqmResCat;
  lst:     TList;
//  wkc:     TMqmWrkCtr;
//  res:     TMqmRes;
begin
  sl.Add('<H1 align=center>' + _('Properties and rules defined at global level') + '</H1>');
  sl.Add('<BR>');

  lst := TList.Create;
  GlobGetPropMtxs(lst);
  WritePropList('Global', sl, lst);
  lst.Free;

  sl.Add('<BR>');

  lst := GlobGetRulesRtoOMtxs;
  WriteRtoOrulesList('Global', sl, lst);
  lst.Free;

  sl.Add('<BR>');

  lst := GlobGetRulesOtoOMtxs;
  WriteOtoOrulesList('Global', sl, lst);
  lst.Free;
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.RescheduledMcmListOfIds(ptr : pointer);
var
  MCMlinkInfo : PTSQMCMlinkInfo;
  TmpStartDate, TmpEndDate : TDateTime;
  ObjMover : TMqmSchedObjMover;
  Res : TMqmVisibleRes;
  ResComp : Integer;
  setup, overlap, duration, DeltaSetupObjToMove : double;
  OptsMover : SetOptsMover;
  I : Integer;
begin
  if assigned(AutoSchedCfg.m_McmListOfRescheduledId) then
  begin
    for I := 0 to AutoSchedCfg.m_McmListOfRescheduledId.Count - 1 do
    begin
      MCMlinkInfo := PTSQMCMlinkInfo(AutoSchedCfg.m_McmListOfRescheduledId[I]);

      OccMoveEnter(ptr, Pointer(MCMlinkInfo.id));
      ObjMover := TMqmSchedObjMover.Create;
      ObjMover.SetObjToMove(MCMlinkInfo.id);
      Res := TMqmVisibleRes(TMqmActArea(MCMlinkInfo.ActArea).p_Father);
      TmpStartDate := MCMlinkInfo.SchedStart;
      ResComp := MCMlinkInfo.NumRscComponent;
      if ObjMover.ChangeTo(TMqmActArea(MCMlinkInfo.ActArea), TmpStartDate, false, CSchedIDnull, Al_toDate, setup, overlap,
                         duration, '', TmpEndDate, OptsMover, nil, False, DeltaSetupObjToMove,false, ResComp) = CSM_Yes then
      begin
      end
      else
        ObjMover.Abort;
      OccMoveExit(ptr, true);
    end;
  end;
end;

//----------------------------------------------------------------------------//

function TMqmPlan.PrepareMcmJobsInListForReSchedule(ProgBar: TMqmProgBar; Status: TStaticText) : boolean;
var
  iRes, iVisRes, iApa, I : integer;
  res:     TMqmRes;
  VisRes:  TMqmVisibleRes;
  ActArea: TMqmActArea;
  IdObj, id : TSchedID;
  RescheduleJobs : boolean;
  linkInfo : TSQMCMlinkInfo;
  McmlinkInfo : PTSQMCMlinkInfo;
begin
  Result := false;
  if Assigned(ProgBar) then
  begin
    ProgBar.SetPosition(0);
    ProgBar.SetMax(p_pl.m_ResList.Count);
  end;

  if Assigned(Status) then
    Status.Caption := _('Prepare Mcm jobs for reschedule ...');

  for iRes := 0 to p_pl.m_ResList.Count -1 do
  begin
    if Assigned(ProgBar) then
      ProgBar.SetPosition(iRes+1);
   // try

    res := TMqmRes(p_pl.m_ResList[iRes]);

    if res.p_PlanType <> RPT_Real then continue;


    for iVisRes := 0 to res.p_VisResCount -1 do
    begin
      VisRes := TMqmVisibleRes(res.p_VisRes[iVisRes]);

      for iApa := 0 to VisRes.p_ActAreasCount -1 do
      begin
        RescheduleJobs := false;
        Application.ProcessMessages;
        ActArea := TMqmActArea(VisRes.p_ActArea[iApa]);

        IdObj := ActArea.GetSchedObj(0);
        if IdObj <> CSchedIDnull then
        begin
          for I := 0 to ActArea.p_ObjCount - 1 do
          begin
            id := ActArea.GetSchedObj(I);
            p_sc.GetMcmLinkInfo(id, linkInfo, true);
            if linkInfo.From_Mqm_Env then
            begin
              RescheduleJobs := true;
              break
            end;
          end;
        end;
      end;

      if RescheduleJobs then
      begin

        for I := ActArea.p_ObjCount - 1 downto 0 do
        begin
          id := ActArea.GetSchedObj(I);
          p_sc.GetMcmLinkInfo(id, linkInfo, false);
          if not linkInfo.From_Mqm_Env then continue;
          if linkInfo.ProgType <> '' then continue;
          Result := true;
          if AutoSchedCfg.m_McmListOfRescheduledId = nil then
            AutoSchedCfg.m_McmListOfRescheduledId := TList.Create;
         // AutoSchedCfg.m_McmRescheduledJobs := false;
         // if IniAppGlobals.CBForceMqmScheduleDetails = '1' then
          AutoSchedCfg.m_McmRescheduledJobs := true;
          ActArea.RemoveSchedObj(id);
          new(McmlinkInfo);
          McmlinkInfo.id := Id;
          McmlinkInfo.SchedStart := linkInfo.SchedStart;
          McmlinkInfo.SchedEnd   := linkInfo.SchedEnd;
          McmlinkInfo.WorkCenter := linkInfo.WorkCenter;
          McmlinkInfo.Resource := linkInfo.Resource;
          McmlinkInfo.ActArea   := linkInfo.ActArea;
          McmlinkInfo.NumRscComponent := linkInfo.NumRscComponent;
          AutoSchedCfg.m_McmListOfRescheduledId.Add(McmlinkInfo)
        end;

        Application.ProcessMessages;

      end;

    end;
  //  except

  //  end;

  end;

  if Assigned(ProgBar) then
    ProgBar.SetPosition(0);
  if Assigned(Status) then
    Status.Caption := '';
end;

//----------------------------------------------------------------------------//

function TMqmPlan.ReorganizeAllIgnoredProgress(OnStart : boolean; ProgBar: TMqmProgBar; Status: TStaticText): boolean;
var
  iRes, iVisRes, iApa : integer;
  res:     TMqmRes;
  VisRes:  TMqmVisibleRes;
  ActArea: TMqmActArea;
  IdObj : TSchedID;
begin
  if Assigned(ProgBar) then
  begin
    ProgBar.SetPosition(0);
    ProgBar.SetMax(p_pl.m_ResList.Count);
  end;

  if Assigned(Status) then
    Status.Caption := _('Reorganizing ignored progress on the Gantt...');

  for iRes := 0 to p_pl.m_ResList.Count -1 do
  begin
    if Assigned(ProgBar) then
      ProgBar.SetPosition(iRes+1);
    res := TMqmRes(p_pl.m_ResList[iRes]);

    for iVisRes := 0 to res.p_VisResCount -1 do
    begin
      VisRes := TMqmVisibleRes(res.p_VisRes[iVisRes]);
      for iApa := 0 to VisRes.p_ActAreasCount -1 do
      begin
        Application.ProcessMessages;
        ActArea := TMqmActArea(VisRes.p_ActArea[iApa]);
        IdObj := ActArea.GetSchedObj(0);
        if IdObj <> CSchedIDnull then
        begin
          ActArea.ReorganizeAllIgnoredProgress(OnStart);
        end;
      end;
    end;

  end;

  if Assigned(ProgBar) then
    ProgBar.SetPosition(0);
  if Assigned(Status) then
    Status.Caption := '';
end;

//----------------------------------------------------------------------------//

function TMqmPlan.ReorganizeAllProgress(OnStart : boolean; ProgBar: TMqmProgBar; Status: TStaticText): boolean;
var
  iRes, iVisRes, iApa : integer;
  res:     TMqmRes;
  VisRes:  TMqmVisibleRes;
  ActArea: TMqmActArea;
  IdObj : TSchedID;
begin
  if Assigned(ProgBar) then
  begin
    ProgBar.SetPosition(0);
    ProgBar.SetMax(p_pl.m_ResList.Count);
  end;

  if Assigned(Status) then
    Status.Caption := _('Reorganization of progresses on gantt...');

  for iRes := 0 to p_pl.m_ResList.Count -1 do
  begin
    if Assigned(ProgBar) then
      ProgBar.SetPosition(iRes+1);
    res := TMqmRes(p_pl.m_ResList[iRes]);

    for iVisRes := 0 to res.p_VisResCount -1 do
    begin
      VisRes := TMqmVisibleRes(res.p_VisRes[iVisRes]);
      for iApa := 0 to VisRes.p_ActAreasCount -1 do
      begin
        Application.ProcessMessages;
        ActArea := TMqmActArea(VisRes.p_ActArea[iApa]);
        IdObj := ActArea.GetSchedObj(0);
        if IdObj <> CSchedIDnull then
        begin
          ActArea.RemovetoBinClosedSteps;
          ActArea.ReorganizeAllProgress(OnStart);
        end;
      end;
    end;

  end;

  if Assigned(ProgBar) then
    ProgBar.SetPosition(0);
  if Assigned(Status) then
    Status.Caption := '';
end;

//----------------------------------------------------------------------------//

function TMqmPlan.ReorganizeAll(ProgBar: TMqmProgBar; Status: TStaticText): boolean;
var
  iRes, iVisRes, iApa : integer;
  res:     TMqmRes;
  VisRes:  TMqmVisibleRes;
  ActArea: TMqmActArea;
  IdObj : TSchedID;
  CycleNumber : integer;
begin
  Result := true;
  p_sc.P_ReorganizeAllEnd := false;

  if Assigned(ProgBar) then
  begin
    Application.ProcessMessages;
    ProgBar.SetPosition(0);
    ProgBar.SetMax(p_pl.m_ResList.Count);
  end;

  if Assigned(Status) then
    Status.Caption := _('Reorganization of the gantt...');

  for CycleNumber := 1 to 2 do // For sub resources - Check components only on second cycle
  begin
    for iRes := 0 to p_pl.m_ResList.Count -1 do
    begin
      Application.ProcessMessages;
      if Assigned(ProgBar) then
        ProgBar.SetPosition(iRes+1);
      try
        res := TMqmRes(p_pl.m_ResList[iRes]);
        if (CycleNumber = 2) and (not res.p_isMultiRes) then
          continue;
        for iVisRes := 0 to res.p_VisResCount -1 do
        begin
          VisRes := TMqmVisibleRes(res.p_VisRes[iVisRes]);
          for iApa := 0 to VisRes.p_ActAreasCount -1 do
          begin
            Application.ProcessMessages;
            ActArea := TMqmActArea(VisRes.p_ActArea[iApa]);
            if CycleNumber = 1 then
              ActArea.UpdateCrossDownTmList;
            IdObj := ActArea.GetSchedObj(0);
            if IdObj <> CSchedIDnull then
            begin
              if CycleNumber = 1 then
                ActArea.ReorganizeAllOcc(false)
              else
                ActArea.ReorganizeAllOcc(true);
              Application.ProcessMessages;
            end;
          end;
        end;
      except
        result := false;
      end;
    end;
  end;

  p_sc.P_ReorganizeAllEnd := true;
  Application.ProcessMessages;

  if Assigned(ProgBar) then
    ProgBar.SetPosition(0);
  if Assigned(Status) then
    Status.Caption := '';
end;

//----------------------------------------------------------------------------//

function TMqmPlan.SetSavedScheduleDate(List : TList) : boolean;
var
  iRes, I, J : Integer;
  VisRes : TMqmVisibleRes;
  ActArea : TMqmActArea;
  Id : TSchedId;
begin
  Result := true;
  for iRes := 0 to List.Count -1 do
  begin
    Application.ProcessMessages;
    VisRes := TMqmVisibleRes(List[iRes]);
    for I := 0 to VisRes.p_ActAreasCount -1 do
    begin
      Application.ProcessMessages;
      ActArea := TMqmActArea(VisRes.p_ActArea[I]);
      if not ActArea.p_CheckIfSchedObjsIsAssigned then continue;
      for J := ActArea.p_ObjCount - 1 downto 0 do
      begin
        id := ActArea.GetSchedObj(j);
        if p_sc.CanDetach(Id, nil, false) then
          p_sc.SetSavedScheudleDate(Id, false);
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

function TMqmPlan.RemoveAllCapRes(ProgBar: TMqmProgBar; Status: TStaticText): boolean;
var
  iRes, iVisRes, iApa : integer;
  res:     TMqmRes;
  VisRes:  TMqmVisibleRes;
  ActArea: TMqmActArea;
begin
  Result := true;

  if Assigned(ProgBar) then
  begin
    ProgBar.SetPosition(0);
    ProgBar.SetMax(p_pl.m_ResList.Count);
  end;

  if Assigned(Status) then
    Status.Caption := _('Remove all objects from plan...');

  for iRes := 0 to p_pl.m_ResList.Count -1 do
  begin
    if Assigned(ProgBar) then
      ProgBar.SetPosition(iRes+1);

    res := TMqmRes(p_pl.m_ResList[iRes]);

    for iVisRes := 0 to res.p_VisResCount -1 do
    begin
      VisRes := TMqmVisibleRes(res.p_VisRes[iVisRes]);

      for iApa := 0 to VisRes.p_ActAreasCount -1 do
      begin
        ActArea := TMqmActArea(VisRes.p_ActArea[iApa]);
        ActArea.RemoveAllCapRes;
      end;
    end;
  end;

  if Assigned(ProgBar) then
    ProgBar.SetPosition(0);
  if Assigned(Status) then
    Status.Caption := '';
end;

//----------------------------------------------------------------------------//

function ReorganizeJobsAfterToday(VisRes : TMqmVisibleRes; ptr : pointer; BeforeNow : boolean) : boolean;
var
  ActArea: TMqmActArea;
  ObjMover : TMqmSchedObjMover;
  iApa, I, Idx : integer;
  OptsMover : SetOptsMover;
  TodayDateTime,TmpEndDate : TDateTime;
  duration, setup, overlap: double;
  moveChgInfo: TSQmoveChgInfo;
  DeltaSetupObjToMove : double;
  List : TList;
  PrevId, PrevIdTemp : TSchedId;
  planInfo : TSQplanInfo;
begin
  result := true;
  List := TList.Create;
  for iApa := 0 to VisRes.p_ActAreasCount -1 do
  begin
    ActArea := TMqmActArea(VisRes.p_ActArea[iApa]);
    Idx := ActArea.p_ObjCount;
    PrevId := CSchedIDnull;
    while True do
    begin
      if Idx = 0 then break;
      Idx := Idx - 1;
      PrevIdTemp := ActArea.GetSchedObj(idx);
      if not p_sc.CanMoveToBin(PrevIdTemp, nil, false) then
      begin
        if PrevId = CSchedIDnull then
          PrevId := PrevIdTemp;
        continue;
      end;
      if BeforeNow then
      begin
        p_sc.GetPlanInfo(PrevIdTemp, planInfo);
        if planInfo.startDate < now then
          List.Add(Pointer(PrevIdTemp));
      end
      else
        List.Add(Pointer(PrevIdTemp));
    end;
    TodayDateTime := 0;
    if PrevId <> CSchedIDnull then
    begin
      p_sc.GetPlanInfo(PrevId, planInfo);
      TodayDateTime := planInfo.endDate;
    end;
    if TodayDateTime < now then
       TodayDateTime := now;
    for I := 0 to List.Count - 1 do
    begin
      ObjMover := TMqmSchedObjMover.Create;
      OccMoveEnter(ptr, Pointer(List[I]));
      ObjMover.SetObjToMove(TSchedId(List[I]));
      Application.ProcessMessages;
      if ObjMover.ChangeTo(ActArea, TodayDateTime, false, CSchedIDnull, Al_toDate, setup, overlap,
                             duration, '', TmpEndDate, OptsMover, nil, False, DeltaSetupObjToMove,false, p_sc.GetJobComponents(TSchedId(List[I]), true)) = CSM_Yes then
      begin
        p_sc.GetMoveChgInfo(TSchedId(List[I]), moveChgInfo);
        p_opStack.ChgOccMoveData(TSchedId(List[I]), moveChgInfo);
       // OccMoveExit(ptr, true);
      end;
      OccMoveExit(ptr, true);
    end;
  end;
  List.Free;
end;

//----------------------------------------------------------------------------//

function TMqmPlan.ReorganizeAllAfterOrBeforeToday(ProgBar: TMqmProgBar; ptr : pointer; BeforeNow : boolean) : boolean;
var
  iRes,iVisRes : integer;
  res    : TMqmRes;
  VisRes : TMqmVisibleRes;
begin
  Result := true;

  if Assigned(ProgBar) then
  begin
    ProgBar.SetPosition(0);
    ProgBar.SetMax(p_pl.m_ResList.Count);
  end;

  for iRes := 0 to p_pl.m_ResList.Count -1 do
  begin
    if Assigned(ProgBar) then
      ProgBar.SetPosition(iRes+1);
    try
      res := TMqmRes(p_pl.m_ResList[iRes]);
      for iVisRes := 0 to res.p_VisResCount -1 do
      begin
        Application.ProcessMessages;
        VisRes := TMqmVisibleRes(res.p_VisRes[iVisRes]);
        ReorganizeJobsAfterToday(VisRes, ptr, BeforeNow);
      end;
    except
      result := false;
      ProgBar.SetPosition(0);
    end;
  end;

  if Assigned(ProgBar) then
    ProgBar.SetPosition(0);

end;

//----------------------------------------------------------------------------//

function TMqmPlan.ReorganizeAllAfterOrBeforeTodayByActTab(ProgBar: TMqmProgBar; ptr : pointer; List : TList; BeforeNow : boolean) : boolean;
var
  iRes   : integer;
  VisRes : TMqmVisibleRes;
begin
  Result := true;

  if Assigned(ProgBar) then
  begin
    ProgBar.SetPosition(0);
    ProgBar.SetMax(p_pl.m_ResList.Count);
  end;

  for iRes := 0 to List.Count -1 do
  begin
    if Assigned(ProgBar) then
      ProgBar.SetPosition(iRes+1);
    try
      Application.ProcessMessages;
      VisRes := TMqmVisibleRes(List[iRes]);
      ReorganizeJobsAfterToday(VisRes, ptr, BeforeNow);
    except
      result := false;
      ProgBar.SetPosition(0);
    end;
  end;

  if Assigned(ProgBar) then
    ProgBar.SetPosition(0);
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.ClearCalendar;
var
  iRes, iVisRes : integer;
  res:     TMqmRes;
  VisRes:  TMqmVisibleRes;
begin
  for iRes := 0 to p_pl.m_ResList.Count -1 do
  begin
    res := TMqmRes(p_pl.m_ResList[iRes]);

    for iVisRes := 0 to res.p_VisResCount -1 do
    begin
      VisRes := TMqmVisibleRes(res.p_VisRes[iVisRes]);
      VisRes.ClearCalendar;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.UpdateClientForCapResChanges(qry : TMqmQuery ;DispoList : TStringList ;ProgBar : TMqmProgBar);
type
  RecCapResChanged = record
    CapResNo :  Integer;
    ChangeType : string;
  end;
  PRecChanged = ^RecCapResChanged;
var
  LastChange : Integer;
  Changed_CapRes_List : TList;
  tbiCapRscChanged : ^TTblInfo;
  tbiCapres        : ^TTblInfo;
  RecChanged : PRecChanged;
  I : Integer;
  capRes : TMqmCapRes;
  TypeChange : string;
  res, oldres : TMqmRes;
  visRes  : TMqmVisibleRes;
  ActArea : TMqmActArea;
  resCode : string;
  SchedEnd : TDateTime;
  cal     : TPGCALObj;

  function FindInList(Capres : Integer; var TypeChange : string) : boolean;
  var
    J : Integer;
  begin
    Result := false;
    for J := 0 to Changed_CapRes_List.Count - 1 do
    begin
      if (Capres = PRecChanged(Changed_CapRes_List[J]).CapResNo) then
      begin
        Result := true;
        TypeChange := PRecChanged(Changed_CapRes_List[J]).ChangeType;
        exit;
      end;
    end;

  end;
begin
  tbiCapRscChanged := @tblInfo[tbl_CapRsc_Change];
  LastChange := GetLastUpdatedCapResNumber;
  if LastChange = -1 then
    Exit;
  Changed_CapRes_List := TList.Create;

  with qry do
  begin
    Application.ProcessMessages;
    Sql.Clear;
    Sql.Add('select * from ' + tbiCapRscChanged.GetTableName);
    sql.add(WHERE_IDF_Condition(CreateFld(tbiCapRscChanged.pfx, fli_Identifier)));
    Sql.Add(' AND ' + CreateFld(tbiCapRscChanged.pfx, fli_updCode) + '>' + IntToStr(DBAppGlobals.LastUpdatCapResNr));
    Sql.Add(' Order by ' + CreateFld(tbiCapRscChanged.pfx, fli_updCode) + ',' +
                           CreateFld(tbiCapRscChanged.pfx, fli_ChangeType));
    Open;
    Application.ProcessMessages;
    while not EOF do
    begin
      New(RecChanged);
      RecChanged.CapResNo := FieldByName(CreateFld(tbiCapRscChanged.pfx, fli_CapacyResrv)).AsInteger;
      RecChanged.ChangeType := FieldByName(CreateFld(tbiCapRscChanged.pfx, fli_ChangeType)).AsString;
      Changed_CapRes_List.Add(RecChanged);
      Next;
      Application.ProcessMessages;
    end;
  end;
  qry.Close;

  if Changed_CapRes_List.count = 0 then
  begin
    Changed_CapRes_List.Free;
    exit
  end;

  tbiCapres := @tblInfo[tbl_capRes];

  with qry do
  begin
    SQL.Clear;
    SQL.Add('select * ');
    SQL.Add('from ' + tbiCapres.GetTableName);
    sql.add(WHERE_IDF_Condition(CreateFld(tbiCapres.pfx, fli_Identifier)));
    Sql.Add(' AND ' + CreateFld(tbiCapres.pfx, fli_CapacyResrv) + '<' + IntToStr(0));
    Open;

    if Assigned(ProgBar) then
      ProgBar.SetMax(1000);

    while not EOF do
    begin
      Application.ProcessMessages;
      if not FindInList(FieldByName(CreateFld(tbiCapres.pfx, fli_CapacyResrv)).AsInteger , TypeChange) then
      begin
        Next;
        continue;
      end;

      resCode := FieldByName(CreateFld(tbiCapres.pfx, fli_rsc)).AsString;
      res := TMqmRes(FindResByCode(resCode));

      if Assigned(res) then
      begin

        if TypeChange = '2' then   // delete
        begin
          capRes := TMqmCapRes(FindCapResByCode(FieldByName(CreateFld(tbiCapres.pfx, fli_CapacyResrv)).AsInteger, false));
          if Assigned(CapRes) then
          begin
            oldres := TMqmRes(CapRes.p_Res);
            FindCapResByCode(FieldByName(CreateFld(tbiCapres.pfx, fli_CapacyResrv)).AsInteger, true);
            if Assigned(oldres) then
              DispoList.add(_('Downtime removed:') + ' ' + _('resource:') + ' ' + oldres.p_ResSDesc + '  ' + _('Start:') + DateTimeTostr(capRes.p_start) + ' , ' + _('End:') + DateTimeTostr(SchedEnd));
          end

        end
        else if TypeChange = '3' then   // update
        begin
          capRes := TMqmCapRes(FindCapResByCode(FieldByName(CreateFld(tbiCapres.pfx, fli_CapacyResrv)).AsInteger, false));
          if Assigned(CapRes) then
          begin
            oldres := TMqmRes(CapRes.p_Res);
            FindCapResByCode(FieldByName(CreateFld(tbiCapres.pfx, fli_CapacyResrv)).AsInteger, true);

            capRes := TMqmCapRes.CreateCapRes(FieldByName(CreateFld(tbiCapres.pfx, fli_CapacyResrv)).AsInteger);
            capRes.m_plan := self;

            if res.p_isMultiRes then
              VisRes := res.GetSubRes(FieldByName(CreateFld(tbiCapres.pfx, fli_subLinRscId)).AsInteger)
            else
              VisRes := res.GetSubRes(-1);

            capRes.p_start  := FieldByName(CreateFld(tbiCapres.pfx, fli_schedStart)).AsDateTime;
            capRes.m_WCProc := FieldByName(CreateFld(tbiCapres.pfx, fli_WCProcess)).AsString;
            if FieldByName(CreateFld(tbiCapres.pfx, fli_CapacyResTyp)).AsString = '1' then
              capRes.m_Type := cr_Normal
            else if FieldByName(CreateFld(tbiCapres.pfx, fli_CapacyResTyp)).AsString = '2' then
              capRes.m_Type := cr_DownTime
            else
              capRes.m_Type := Cr_CrossingDtm;

            capRes.m_Comment    := FieldByName(CreateFld(tbiCapres.pfx, fli_Comment)).AsString;
            if (capRes.m_Type = cr_Normal) then
            begin
              capRes.m_UpMostCase := StrToInt(FieldByName(CreateFld(tbiCapres.pfx, fli_Capacity_To_Job)).AsString);
              capRes.m_ColorIndex := FieldByName(CreateFld(tbiCapres.pfx, fli_ColorIndex)).AsInteger;
            end;

            ActArea := TMqmActArea(VisRes.FindActForDate(capRes.p_start));
            if Assigned(ActArea) then
            begin
              cal := actArea.GetCalendar;
              SchedEnd := FieldByName(CreateFld(tbiCapres.pfx, fli_schedEnd)).AsDateTime;
              capRes.p_dur := trunc(cal.DiffWH(capRes.p_start, SchedEnd , ActArea.m_CrossDownTmList)*60);
              ActArea.AddCapRes(capRes);
              if Assigned(oldres) and (oldres <> res) then
              begin
                DispoList.add(_('Downtime removed:') + ' ' + _('resource:') + ' ' + oldres.p_ResSDesc + '  ' + _('Start:') + DateTimeTostr(capRes.p_start) + ' , ' + _('End:') + DateTimeTostr(SchedEnd));
                DispoList.add(_('Downtime added to:') + ' ' + _('resource:') + ' ' + res.p_ResSDesc + '  ' + _('Start:') + DateTimeTostr(capRes.p_start) + ' , ' + _('End:') + DateTimeTostr(SchedEnd));
              end
              else
                DispoList.add(_('Downtime changed to:') + ' ' + _('resource:') + ' ' + res.p_ResSDesc + '  ' + _('Start:') + DateTimeTostr(capRes.p_start) + ' , ' + _('End:') + DateTimeTostr(SchedEnd));
            end;
            if Assigned(ProgBar) then
            ProgBar.SetPosition(RecNo);
          end;

        end

        else if TypeChange = '1' then
        begin

          capRes := TMqmCapRes.CreateCapRes(FieldByName(CreateFld(tbiCapres.pfx, fli_CapacyResrv)).AsInteger);
          capRes.m_plan := self;

          if res.p_isMultiRes then
            VisRes := res.GetSubRes(FieldByName(CreateFld(tbiCapres.pfx, fli_subLinRscId)).AsInteger)
          else
            VisRes := res.GetSubRes(-1);

          capRes.p_start  := FieldByName(CreateFld(tbiCapres.pfx, fli_schedStart)).AsDateTime;
          capRes.m_WCProc := FieldByName(CreateFld(tbiCapres.pfx, fli_WCProcess)).AsString;
          if FieldByName(CreateFld(tbiCapres.pfx, fli_CapacyResTyp)).AsString = '1' then
            capRes.m_Type := cr_Normal
          else if FieldByName(CreateFld(tbiCapres.pfx, fli_CapacyResTyp)).AsString = '2' then
            capRes.m_Type := cr_DownTime
          else
            capRes.m_Type := Cr_CrossingDtm;

          capRes.m_Comment    := FieldByName(CreateFld(tbiCapres.pfx, fli_Comment)).AsString;
          if (capRes.m_Type = cr_Normal) then
          begin
            capRes.m_UpMostCase := StrToInt(FieldByName(CreateFld(tbiCapres.pfx, fli_Capacity_To_Job)).AsString);
            capRes.m_ColorIndex := FieldByName(CreateFld(tbiCapres.pfx, fli_ColorIndex)).AsInteger;
          end;

          ActArea := TMqmActArea(VisRes.FindActForDate(capRes.p_start));
          if Assigned(ActArea) then
          begin
            cal := actArea.GetCalendar;
            SchedEnd := FieldByName(CreateFld(tbiCapres.pfx, fli_schedEnd)).AsDateTime;
            capRes.p_dur := trunc(cal.DiffWH(capRes.p_start, SchedEnd , ActArea.m_CrossDownTmList)*60);
            ActArea.AddCapRes(capRes);
            DispoList.add(_('New Downtime:') + ' ' + _('resource:') + ' ' + res.p_ResSDesc + '  ' + _('Start:') + DateTimeTostr(capRes.p_start) + ' , ' + _('End:') + DateTimeTostr(SchedEnd));
          end
        end;
        if Assigned(ProgBar) then
          ProgBar.SetPosition(RecNo);
      end;
      Next;
    end;
  end;

  qry.close;

  if Assigned(ProgBar) then
    ProgBar.SetPosition(0);

  if (Changed_CapRes_List.Count > 0) then
  begin
    for I := Changed_CapRes_List.Count - 1 downto 0 do
      Dispose(PRecChanged(Changed_CapRes_List[I]));

    DBAppGlobals.LastUpdatCapResNr := LastChange
  end;

  Changed_CapRes_List.Free;

end;

//----------------------------------------------------------------------------//

function TMqmPlan.CalcLowestScheduledDate(Id : TSchedId; MinJobResComp : integer; ResList : TList) : TDatetime;
var
  I : Integer;
  VisRes : TMqmVisibleRes;
  CompVal: TCompatVal;
  ActArea : TMqmActArea;
  PlanInfo : TSQplanInfo;
  SchedId : TSchedId;
  TempDateTime : TDateTime;
  Dependency : boolean;
begin
  Result := 0;
  VisRes := nil;
  for I := 0 to ResList.Count - 1 do
  begin
    VisRes := TMqmVisibleRes(VisRes[i]);

    if VisRes.CheckCompatWithOcc([cho_compVal, cho_timing, cho_wkc, cho_readOnly, cho_qty, cho_Depend],
                                       id, 0, nil, CompVal, Dependency)
    and (CompVal <= MinJobResComp) then
    begin
      ActArea := TMqmActArea(TMqmVisibleRes(VisRes));
      if ActArea.p_ObjCount > 0 then
      begin
        SchedId := ActArea.GetSchedObj(ActArea.p_ObjCount -1);
        p_sc.GetPlanInfo(SchedId, PlanInfo);
        TempDateTime := PlanInfo.endDate;
        if (I = 0) then
           Result := TempDateTime
        else
        begin
          if TempDateTime < Result then
             Result := TempDateTime;
        end;
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

Function TMqmPlan.GetListForSavedPlan(SET_NAME : String; StartDate, EndDate : TDateTime): TList;
var
  iRes, iVisRes, iApa, I, J, CurrentLine : Integer;
  res  : TMqmRes;
  VisRes : TMqmVisibleRes;
  ActArea : TMqmActArea;
  Id : TSchedid;
  StartSched , EndSched, FromDateTime, ToDateTime : TDateTime;
  RecSavedPlan : PRecSavedPlanCopy;
  value : Variant;
  datatype : CBinColValType;
  TimeOfFamilyBeforeId,QuantityForJob, BeforeQty, AfterQty : Double;
  DatesInfo : TSQStartEndInfo;
  Cal      : TPGCALObj;
  BucDate : TDate;
begin
  Result := TList.Create;

  for iRes := 0 to p_pl.m_ResList.Count -1 do
  begin
    res := TMqmRes(p_pl.m_ResList[iRes]);
    if Assigned(res.p_WrkCtr) and (TMqmWrkCtr(res.p_WrkCtr).p_ReadOnly) then continue;
    for iVisRes := 0 to res.p_VisResCount -1 do
    begin

      VisRes := TMqmVisibleRes(res.p_VisRes[iVisRes]);

      for iApa := 0 to VisRes.p_ActAreasCount -1 do
      begin

        ActArea := TMqmActArea(VisRes.p_ActArea[iApa]);
        if ActArea.GetSchedObj(0) = CSchedIDnull then continue;

        for J := 0 to ActArea.p_ObjCount - 1 do
        begin
          id := ActArea.GetSchedObj(j);
          if Id = CSchedIDnull then continue;
          if p_sc.GetSchedEnd(id) <= StartDate then Continue;
          if p_sc.GetSchedStart(id) > EndOfTheDay(EndDate) then Continue;

          StartSched := p_sc.GetSchedStart(id);
          EndSched   := p_sc.GetSchedEnd(id);
          i := 0;
          BeforeQty := 0;
          AfterQty := 0;

          Cal := ActArea.GetCalendar;
          p_sc.GetStartInfo(id, DatesInfo);
          TimeOfFamilyBeforeId := ActArea.GetDurationOfAllJobsBeforeThisSpot(DatesInfo.StartDate, id);  //dont know if we need this

         { CurrentLine := 0;
          while StartSched.GetDate + CurrentLine < StartDate do   //GET SUM QTY BEFORE SET START
          begin
            if CurrentLine = 0 then
              FromDateTime := StartSched
            else
              FromDateTime := StrToDateTime(DateToStr(StartSched.GetDate + CurrentLine) + ' ' + '00:00:00');

            if ToDateTime.GetDate = EndSched.GetDate then
              ToDateTime := EndSched
            else
              ToDateTime :=  StrToDateTime(DateToStr(FromDateTime) + ' ' + '23:59:59');


            QuantityForJob := CalculateJobQuantityInBucket(id, FromDateTime, ToDateTime, 0, TimeOfFamilyBeforeId);
            BeforeQty := BeforeQty + QuantityForJob;
            Inc(CurrentLine);
          end;

          if BeforeQty > 0 then
          begin
            new(RecSavedPlan);
            RecSavedPlan.BucType := '1';
            RecSavedPlan.BucQty := BeforeQty;
            RecSavedPlan.BucDate := StartSched.GetDate;
            RecSavedPlan.IDENTIFIER := IniAppGlobals.Identifier;
            RecSavedPlan.FROMDATE :=  StartDate;
            RecSavedPlan.TODATE :=    EndDate;
            RecSavedPlan.WKST_CODE  := IniAppGlobals.WkstCode;
            RecSavedPlan.SET_NAME   := SET_NAME;
            p_sc.GetFldValue(id, CSC_ProdReq, value, dataType);
            RecSavedPlan.PREQ_NO    := value;
            p_sc.GetFldValue(id, CSC_ProdStep, value, dataType);
            RecSavedPlan.STEP_ID    := value;
            p_sc.GetFldValue(id, CSC_ProdSubStep, value, dataType);
            RecSavedPlan.SubStep    := value;
            p_sc.GetFldValue(id, CSC_ReprocNo, value, dataType);
            RecSavedPlan.REPROC_NO := value;
            p_sc.GetFldValue(id, CSC_Rsc, value, dataType);
            RecSavedPlan.RSC       := value;
            p_sc.GetFldValue(id, CSC_SchedStart, value, dataType);
            RecSavedPlan.SchedStart   := value;
            p_sc.GetFldValue(id, CSC_SchedEnd, value, dataType);
            RecSavedPlan.SchedEnd  := value;
            p_sc.GetFldValue(id, CSC_ExeTimeSched, value, dataType);
            RecSavedPlan.ExeMin    := value;

            Result.Add(RecSavedPlan);
          end;       }

          CurrentLine := 0;
          while StartSched.GetDate + CurrentLine <= EndSched.GetDate  do  //loop everyday in job
          begin

           { if StartSched + CurrentLine < StartDate then
            begin
              Inc(CurrentLine);
              Continue;
            end; }

            BucDate := StartSched.GetDate + CurrentLine;
            FromDateTime := StartSched + CurrentLine;

            new(RecSavedPlan);

            if CurrentLine = 0 then
              ToDateTime :=  StrToDateTime(DateToStr(FromDateTime) + ' ' + '23:59:59')
            else if StartSched.GetDate + CurrentLine < EndSched.GetDate  then
            begin
              FromDateTime := StrToDateTime(DateToStr(StartSched + CurrentLine) + ' ' + '00:00:00');
              ToDateTime :=  StrToDateTime(DateToStr(FromDateTime) + ' ' + '23:59:59')
            end else if StartSched.GetDate + CurrentLine = EndSched.GetDate  then
            begin
              FromDateTime := StrToDateTime(DateToStr(StartSched + CurrentLine) + ' ' + '00:00:00');
              ToDateTime :=  EndSched;
            end;

            QuantityForJob := CalculateJobQuantityInBucket(id, FromDateTime, ToDateTime, 0, TimeOfFamilyBeforeId);

            new(RecSavedPlan);
            RecSavedPlan.BucType := '2';
            RecSavedPlan.BucQty := QuantityForJob;
            RecSavedPlan.BucDate := BucDate;
            RecSavedPlan.IDENTIFIER := IniAppGlobals.Identifier;
            RecSavedPlan.FROMDATE :=  StartDate;
            RecSavedPlan.TODATE :=    EndDate;
            RecSavedPlan.WKST_CODE  := IniAppGlobals.WkstCode;
            RecSavedPlan.SET_NAME   := SET_NAME;
            p_sc.GetFldValue(id, CSC_ProdReq, value, dataType);
            RecSavedPlan.PREQ_NO    := value;
            p_sc.GetFldValue(id, CSC_ProdStep, value, dataType);
            RecSavedPlan.STEP_ID    := value;
            p_sc.GetFldValue(id, CSC_ProdSubStep, value, dataType);
            RecSavedPlan.SubStep    := value;
            p_sc.GetFldValue(id, CSC_ReprocNo, value, dataType);
            RecSavedPlan.REPROC_NO := value;
            p_sc.GetFldValue(id, CSC_Rsc, value, dataType);
            RecSavedPlan.RSC       := value;
            p_sc.GetFldValue(id, CSC_SchedStart, value, dataType);
            RecSavedPlan.SchedStart   := value;
            p_sc.GetFldValue(id, CSC_SchedEnd, value, dataType);
            RecSavedPlan.SchedEnd  := value;
            p_sc.GetFldValue(id, CSC_ExeTimeSched, value, dataType);
            RecSavedPlan.ExeMin    := value;

            Result.Add(RecSavedPlan);

            Inc(CurrentLine);

            if StartSched + CurrentLine > EndOfTheDay(EndDate) then break;
          end;

          {CurrentLine := 1;
          while EndDate + CurrentLine <= EndSched.GetDate do  //GET SUM QTY AFTER SET END
          begin
            FromDateTime := StrToDateTime(DateToStr(EndDate + CurrentLine) + ' ' + '00:00:00');

            if EndDate + CurrentLine = EndSched.GetDate then
               ToDateTime :=  EndSched
            else
              ToDateTime :=  StrToDateTime(DateToStr(FromDateTime) + ' ' + '23:59:59');

            QuantityForJob := CalculateJobQuantityInBucket(id, FromDateTime, ToDateTime, 0, TimeOfFamilyBeforeId);
            AfterQty := AfterQty + QuantityForJob;

            Inc(CurrentLine);
          end;

          if AfterQty > 0 then
          begin
            new(RecSavedPlan);
            RecSavedPlan.BucType := '3';
            RecSavedPlan.BucQty := AfterQty;
            RecSavedPlan.BucDate := EndSched.GetDate;
            RecSavedPlan.IDENTIFIER := IniAppGlobals.Identifier;
            RecSavedPlan.FROMDATE :=  StartDate;
            RecSavedPlan.TODATE :=    EndDate;
            RecSavedPlan.WKST_CODE  := IniAppGlobals.WkstCode;
            RecSavedPlan.SET_NAME   := SET_NAME;
            p_sc.GetFldValue(id, CSC_ProdReq, value, dataType);
            RecSavedPlan.PREQ_NO    := value;
            p_sc.GetFldValue(id, CSC_ProdStep, value, dataType);
            RecSavedPlan.STEP_ID    := value;
            p_sc.GetFldValue(id, CSC_ProdSubStep, value, dataType);
            RecSavedPlan.SubStep    := value;
            p_sc.GetFldValue(id, CSC_ReprocNo, value, dataType);
            RecSavedPlan.REPROC_NO := value;
            p_sc.GetFldValue(id, CSC_Rsc, value, dataType);
            RecSavedPlan.RSC       := value;
            p_sc.GetFldValue(id, CSC_SchedStart, value, dataType);
            RecSavedPlan.SchedStart   := value;
            p_sc.GetFldValue(id, CSC_SchedEnd, value, dataType);
            RecSavedPlan.SchedEnd  := value;
            p_sc.GetFldValue(id, CSC_ExeTimeSched, value, dataType);
            RecSavedPlan.ExeMin    := value;

            Result.Add(RecSavedPlan);
          end; }
        end;
      end;
    end;
  end;

end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.SavedPlanCopy(SET_NAME, SET_DESC : string; StartDate, EndDate : TDateTime; ListSavedPlanCopy : TList);
var
  I, arraysize : Integer;
  qry: TMqmQuery;
  tbInfo: ^TTblInfo;
  StrSrvSql : string;
  TimeCreation : TDateTime;
  RecSavedPlan : PRecSavedPlanCopy;
begin
  sleep(1000);
  TimeCreation := now;

  tbInfo := @tblInfo[tbl_SavedPlanCopyHeader];
  qry := CreateQuery(Main_DB);
  qry.Transaction := CreateTransaction(Main_DB);
  qry.Transaction.StartTransaction;

  StrSrvSql := 'insert into ' + tbInfo.GetTableName + '(';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_IDENTIFIER)              + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_wkstCode)                + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_SetName)                 + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_SetDesc)                 + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_CalStartDate)            + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_CalEndDate)              + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_usrTmCr);
  StrSrvSql := StrSrvSql + ') values (';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_IDENTIFIER)        + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_wkstCode)          + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_SetName)           + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_SetDesc)           + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_CalStartDate)      + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_CalEndDate)        + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_usrTmCr);
  StrSrvSql := StrSrvSql + ')';
  qry.sql.text := StrSrvSql;

  Application.ProcessMessages;

  qry.ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsString        := IniAppGlobals.Identifier;
  qry.ParamByName(CreateFld(tbInfo.pfx, fli_wkstCode)).AsString          := IniAppGlobals.WkstCode;
  qry.ParamByName(CreateFld(tbInfo.pfx, fli_SetName)).AsString           := SET_NAME;
  qry.ParamByName(CreateFld(tbInfo.pfx, fli_SetDesc)).AsString           := SET_DESC;
  qry.ParamByName(CreateFld(tbInfo.pfx, fli_CalStartDate)).AsDateTime    := StartDate;
  qry.ParamByName(CreateFld(tbInfo.pfx, fli_CalEndDate)).AsDateTime      := EndDate;
  qry.ParamByName(CreateFld(tbInfo.pfx, fli_usrTmCr)).AsDateTime         := TimeCreation;
  qry.ExecSQL;

  qry.Transaction.Commit;
  qry.Close;


  arraysize := -1;
  tbInfo := @tblInfo[tbl_SavedPlanCopy];
  qry.SQL.Clear;
  qry.SQL.Add('insert into ' + tbInfo.GetTableName + '(');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_identifier) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_wkstCode) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SetName) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_preqNo) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_pstepId) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_psubstId) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_reprocNo) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_rsc) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BucketType) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BucketDate) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BucketQty) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SchedStart) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SchedEnd) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_exeMin) + ')');

  qry.SQL.Add(' values (');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_identifier) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wkstCode) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_SetName) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_preqNo) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_pstepId) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_psubstId) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_reprocNo) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_rsc) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BucketType) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BucketDate) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BucketQty) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_SchedStart) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_SchedEnd) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_exeMin) + ')');


  for i := 0 to ListSavedPlanCopy.count - 1 do
  begin
    Inc(arraysize);
    qry.params.arraysize := arraysize + 1;
    qry.params[0].AsIntegers[arraysize] := StrToInt(IniAppGlobals.Identifier);
    qry.params[1].asStrings[arraysize] := PRecSavedPlanCopy(ListSavedPlanCopy[i]).WKST_CODE;
    qry.params[2].asStrings[arraysize] := PRecSavedPlanCopy(ListSavedPlanCopy[i]).SET_NAME;
    qry.params[3].asStrings[arraysize] := PRecSavedPlanCopy(ListSavedPlanCopy[i]).PREQ_NO;
    qry.params[4].AsIntegers[arraysize] := PRecSavedPlanCopy(ListSavedPlanCopy[i]).STEP_ID;
    qry.params[5].AsIntegers[arraysize] := PRecSavedPlanCopy(ListSavedPlanCopy[i]).SubStep;
    qry.params[6].AsIntegers[arraysize] := PRecSavedPlanCopy(ListSavedPlanCopy[i]).REPROC_NO;
    qry.params[7].asStrings[arraysize] := PRecSavedPlanCopy(ListSavedPlanCopy[i]).RSC;
    qry.params[8].asStrings[arraysize] := PRecSavedPlanCopy(ListSavedPlanCopy[i]).BucType;
    qry.params[9].asDatetimes[arraysize] := PRecSavedPlanCopy(ListSavedPlanCopy[i]).BucDate;

    if Abs(PRecSavedPlanCopy(ListSavedPlanCopy[i]).BucQty) > 9999999 then
        PRecSavedPlanCopy(ListSavedPlanCopy[i]).BucQty := 9999999;
    PRecSavedPlanCopy(ListSavedPlanCopy[i]).BucQty := SafeFloat(PRecSavedPlanCopy(ListSavedPlanCopy[i]).BucQty);

    qry.params[10].asFloats[arraysize] := PRecSavedPlanCopy(ListSavedPlanCopy[i]).BucQty;
    qry.params[11].asDatetimes[arraysize] := PRecSavedPlanCopy(ListSavedPlanCopy[i]).SchedStart;
    qry.params[12].asDatetimes[arraysize] := PRecSavedPlanCopy(ListSavedPlanCopy[i]).SchedEnd;

    if Abs(PRecSavedPlanCopy(ListSavedPlanCopy[i]).ExeMin) > 9999999 then
        PRecSavedPlanCopy(ListSavedPlanCopy[i]).ExeMin := 9999999;
    PRecSavedPlanCopy(ListSavedPlanCopy[i]).ExeMin := SafeFloat(PRecSavedPlanCopy(ListSavedPlanCopy[i]).ExeMin);

    qry.params[13].asFloats[arraysize] := PRecSavedPlanCopy(ListSavedPlanCopy[i]).ExeMin;

  end;

  qry.Transaction.StartTransaction;
  if arraysize >= 0 then
    qry.execute(arraysize + 1);

  qry.Transaction.Commit;
  qry.Close;
  qry.Free;


  for i := 0 to ListSavedPlanCopy.count - 1 do
  begin
    RecSavedPlan := PRecSavedPlanCopy(ListSavedPlanCopy[i]);
    Dispose(RecSavedPlan)
  end;

  ListSavedPlanCopy.Clear;
  ListSavedPlanCopy.free;

//  MessageDlg(_('Saved!'), mtInformation, [mbOk], 0);
end;

//----------------------------------------------------------------------------//

procedure TMqmPlan.ClearSavedPlanCopyList;
var I : Integer;
begin
  for i := 0 to m_SavedplanCopy.count - 1 do
    Dispose(PRecSavedPlanCopy(m_SavedplanCopy[i]));
  m_SavedplanCopy.Clear;
end;

//----------------------------------------------------------------------------//

end.
