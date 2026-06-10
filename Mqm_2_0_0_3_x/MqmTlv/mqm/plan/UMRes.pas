unit UMRes;

interface

uses
  Windows,
  classes,
  graphics,
  UGBaseCal,
  UMCompat,
  UMDurObj,
  UMResCat,
  UMPlanObj,
  UMCompatRules,
//Old overlap  UMOverlapRules,
  UMCompatSrv,
  UMSchedContFunc,
  UMRank,
  UMOverlap,
  UMSchedCont, gnugettext;

type

  COneBatchMachineGroupType = (Non_typ, Qty_typ, process_typ);

  TPropertyCodeVal = record
    PropCod_val        : string;
    PropCod_val_previd : string;
    suprecId          : TSetupRec;
    compatValId       : TCompatVal;
    SameGroupId       : boolean;
    OrigResultId      : boolean;
    suprecPrev          : TSetupRec;
    compatValPrev       : TCompatVal;
    SameGroupPrev       : boolean;
    OrigResultPrev      : boolean;
  end;
  TPPropertyCodeVal = ^TPropertyCodeVal;

  TDwTimeLinked = record
    LstDwTime: TList;
  end;
  PTDwTimeLinked = ^TDwTimeLinked;

  // fp - tmp0408
  TRecNoMatDate = record
    m_dueDate : TDateTime;
    m_start: TDateTime;
    m_end:   TDateTime;
    m_StdPurcOrProdTime : Integer;
    m_startStdPurcOrd: TDateTime;
    m_endStdPurcOrd:   TDateTime;
    m_isdStdPurcOrd: boolean;
  end;
  PTRecNoMatDate = ^TRecNoMatDate;

  TRowParms = record
    lev:        integer;     // level priority
    st:         TDateTime;   // start time of the object
    et:         TDateTime;   // end time of the object
    it:         TDateTime;   // setup end date
    mt:         TDateTime;   // setup without material start date
    OvlpLmtL:   TDateTime;   // Left overlap limit date
    OvlpLmtR:   TDateTime;   // Right overlap limit date
    top:        double;      // top of the shape in percentage
    hgt:        double;      // height of the shape in percentage
    suppVal1:   integer;
    suppVal2:   integer;
    errSet:     SetOfErrors;
    isTmp:      boolean;
    isReadOnly: boolean;
    compatVal:  TCompatVal;
    calendar:   TPGCalObj;   // calendar of the object
    isContObj:  boolean;
    objPtr:     pointer;     // reference object
    objActArea_Warp : pointer;
    Row:        integer;     // Row of visibleRes
    RH:         integer;     // Row Height

    NoMaterialList: TList;  // fp - tmp0408
    NoAddResList: TList;    // fp - tmp0408
    NoPrevStepList: TList;
  end;
  PTRowParms = ^TRowParms;

  TPropCompRepo = record
    pId:            TPropId;
    jobPropVal:     variant;
    propRes:        TPropRes;
    rule:           TCompRules;
    pos:            integer;
    inJob:          integer;   // only in evaluation of setup parms
    jobPrecPropVal: variant;
    WhenOkNextSeq : integer;
    jobPropValPartial : variant;
    jobPrecPropValPartial : variant;
    CurveCode : string;
  end;
  PTPropCompRepo = ^TPropCompRepo;

  TDurShDraw = procedure (Canvas: TCanvas; parms: PTRowParms; const rect: TRect; const IntPt, MatPt: integer);

  TMqmVisibleRes = class; //Just to compile

  TMqmRes = class(TMqmPlanObj)
    constructor CreateRes(Code: string);
    destructor  Destroy; override;

  private
    m_SDescr:        string;
    m_LDescr:        string;
    m_ProcessType:   CScSchedType;
    m_PlanType:      CScResPlanType;
    m_Sndt_bch_Size: double;
    m_Min_bch_size:  double;
    m_Max_bch_size:  double;
    m_Single_Max_bch_size:  double;
    m_PropCodeOptimumMaxMultiplier : string;
    m_PropCodeMinMultiplier : string;
    m_BchUM:         string;
    m_Text1:         string;
    m_Text2:         string;
    m_ForceOutsideLimitQty : boolean;
    m_ForceOccToResCase99  : boolean;

    m_VisRes:  TList;
    m_ResCode: string;
    m_OvlpRulesList: TMQMOvlpRulesList;
    m_DwTimeLinked: TList;
//    m_ListCompactPropCodeVal : TList;

    m_compatVal:  TCompatVal;
    m_hasTimings: integer;
    m_goodWkc:    integer;
    m_goodDep:    integer;
    m_rscComp: integer;
    m_GROUP_CODE_FOR_ONE_BATCH_MACHINE : string;
    m_GROUP_TYPE_FOR_ONE_BATCH_MACHINE : COneBatchMachineGroupType;
    m_ONE_BATCH_MACHINE_By_GROUP_CODE : boolean;
    m_rscOfBatchMachinSameGrpCode : TMqmRes;
    m_LineWithinPlant : string;

    m_propMtx:       array[1..2] of TOrigMatrix;
    m_CmpRlsRtoOMtx: array[1..4] of TOrigMatrix;
    m_CmpRlsOtoOMtx: array[1..4] of TOrigMatrix;

    function  VisResCount: integer;
    function  GetVisRes(i: integer): TMqmVisibleRes;

    function  IsMultiRes: boolean;
    function  GetWrkCtr: TMqmPlanObj;

    // property serving functions
    function PSoccCanAttach:  boolean;
    function PSoccCompatVal:  TCompatVal;
    function PSoccHasTimings: boolean;
    function PSoccGoodWkc(id: TSchedID): boolean;
    function PSoccGoodDepend(id: TSchedID): boolean;
    function PSoccGoodMinQty(id: TSchedID): boolean;
    function PSoccGoodMaxQty(id: TSchedID): boolean;
    function PGetSplitQtyByBatch(id: TSchedID; var Qty : currency; var MinQty : currency) : boolean;

    function GetValueForProperty(pID: TPropID; proc: string): TPropRes;
    function GetRuleRtoOfForProperty(pID: TPropID; proc, prod: string): TCompRules;
    function GetRuleOtoOfForProperty(pID: TPropID; proc, prod: string): TCompRules;

  public
  //  m_GrpCode: string;
    m_ResCat:  TMqmResCat;
    m_index :  Integer;
    function  GET_GROUP_CODE_FOR_ONE_BATCH_MACHINE : string;
    function  IS_ONE_BATCH_MACHINE_By_GROUP_CODE : boolean;
    function  CheckMaxQtyOnBatchMachinSameGrpCode(id: TSchedID): boolean;
    function  CheckUsedAllMachinePartsProcessOnBatchMachinSameGrpCode(id: TSchedID; CheckedId : TSchedID): boolean;
    function  GetDescr: string; override;
    procedure AddVisibleRes(VisRes: TMqmPlanObj);
    function  GetVisResList: TList;
    function  GetSubRes(subCode: integer): TMqmVisibleRes;
    function  CheckCompatWithOcc(opt: TSetChkCompOpt; id: integer; toDate: TDateTime; errLst: TStrings; var compVal: TCompatVal; var Dependency : boolean): boolean; override;
    function  GetComponentsUsed(RefObjID: TSchedID; StartDate, EndDate: TDateTime): integer;

    function  CheckDatesOnOneBatchMachineByGroupCode(Id : TSchedId; planInfo : TSQplanInfo; var AvailbleDateTime : TDateTime) : boolean;
    function  GetAdditionalOptimumMaxMultiplierProp(Id : TSchedId) : double;
    function  GetAdditionalMinMultiplierProp(Id : TSchedId) : double;

    property p_ResCode:       string         read m_ResCode;
    property p_ResSDesc:      string         read m_SDescr        write m_SDescr;
    property p_ResLDesc:      string         read m_LDescr        write m_LDescr;

    property p_ResComp:       integer        read m_rscComp       write m_rscComp;
    property p_ProcessType:   CScSchedType   read m_ProcessType   write m_ProcessType;
    property p_PlanType:      CScResPlanType read m_PlanType      write m_PlanType;
    property p_Sndt_bch_Size: double         read m_Sndt_bch_Size write m_Sndt_bch_Size;
    property p_Min_bch_size:  double         read m_Min_bch_size  write m_Min_bch_size;
    property p_Max_bch_size:  double         read m_Max_bch_size  write m_Max_bch_size;
    property p_Single_Max_bch_size:  double  read m_Single_Max_bch_size  write m_Single_Max_bch_size;
    property P_rscOfBatchMachinSameGrpCode:  TMqmRes  read m_rscOfBatchMachinSameGrpCode  write m_rscOfBatchMachinSameGrpCode;
    property P_LineWithinPlant:  string      read m_LineWithinPlant  write m_LineWithinPlant;
    property P_PropCodeOptimumMaxMultiplier : string read m_PropCodeOptimumMaxMultiplier  write m_PropCodeOptimumMaxMultiplier;
    property P_PropCodeMinMultiplier : string read m_PropCodeMinMultiplier  write m_PropCodeMinMultiplier;
    property P_GetAdditionalOptimumMaxMultiplierProp[Id : TSchedId] : double read GetAdditionalOptimumMaxMultiplierProp;
    property P_GetAdditionalMinMultiplierProp[Id : TSchedId] : double read GetAdditionalMinMultiplierProp;

    property p_ONE_BATCH_MACHINE_By_GROUP_CODE: boolean           read m_ONE_BATCH_MACHINE_By_GROUP_CODE  write m_ONE_BATCH_MACHINE_By_GROUP_CODE;
    property p_GROUP_CODE_FOR_ONE_BATCH_MACHINE : string          read m_GROUP_CODE_FOR_ONE_BATCH_MACHINE write m_GROUP_CODE_FOR_ONE_BATCH_MACHINE;
    property p_GROUP_TYPE_FOR_ONE_BATCH_MACHINE : COneBatchMachineGroupType read m_GROUP_TYPE_FOR_ONE_BATCH_MACHINE write m_GROUP_TYPE_FOR_ONE_BATCH_MACHINE;

    property p_BchUM:         string         read m_BchUM         write m_BchUM;
    property p_Text1:         string         read m_Text1         write m_Text1;
    property p_Text2:         string         read m_Text2         write m_Text2;

    property p_VisResCount: integer               read VisResCount;
    property p_VisRes[i: integer]: TMqmVisibleRes read GetVisRes;    default;
    property p_VisResList: TLIst                  read m_VisRes;

    property p_isMultiRes: boolean                read IsMultiRes;
    property p_ResCat: TMqmResCat                 read m_ResCat;
    property p_WrkCtr: TMqmPlanObj                read GetWrkCtr;

  // compatibility handling section

    procedure ClearCompatCaches;

    property p_ForceOutsideLimitQty:     boolean  read m_ForceOutsideLimitQty write m_ForceOutsideLimitQty;
    property p_ForceOccToResCase99:      boolean  read m_ForceOccToResCase99  write m_ForceOccToResCase99;
    property p_occCanAttach:  boolean    read PSoccCanAttach;
    property p_occCompatVal:  TCompatVal read PSoccCompatVal;
    property p_occHasTimings: boolean    read PSoccHasTimings;
    property p_occGoodWkc[id: TSchedID]   : boolean    read PSoccGoodWkc;
    property p_occGoodDepend[id: TSchedID]: boolean    read PSoccGoodDepend;
    property p_occGoodMinQty[id: TSchedID]: boolean    read PSoccGoodMinQty;
    property p_occGoodMaxQty[id: TSchedID]: boolean    read PSoccGoodMaxQty;
    property p_GetSplitQtyByBatch[id: TSchedID; var qty : currency; var MinQty : currency]: boolean read PGetSplitQtyByBatch;

    function  AddProperty(code: string; var val: TPropResRec; ErrList: TStringList): boolean;
    function  AddRtoOrule(code: string; var val: TRuleResRec; ErrList: TStringList): boolean;
    function  AddOtoOrule(code: string; var val: TRuleResRec; ErrList: TStringList): boolean;
    function  AddOvlpRule(ArtType, WrkCtrProc: string; RuleRec: TOvlpRule; DetailRec: TOvlpRuleDet): boolean;
    function  GetOvlpRule(ArtType, WrkCtrProc: string; out isDefault: boolean): TMQMOvlpRule;
    function  CheckCompat(id: TSchedID): TCompatVal;
    function  CheckCompIDCapRes(id: TSchedID; CapRes: TMqmPlanObj): TCompatVal;
    function  CheckCompCapRes(CapRes: TMqmPlanObj): TCompatVal;
    function  GetSetupParms(scObj, scObjPrec: TSchedID; var supRec: TSetupRec;
                            var compatVal: TCompatVal; var SameGroup:boolean; var LearningCurveCode : string): boolean;
    function  GetObjPropValString(scObj : TSchedID; var Level : Integer; var HasPropInstanceCounterWithRule : boolean) : string;
    function  GetPropValAffectSameGroupString(scObj : TSchedID) : string;
{    function  GetSetupParmsStr(scObj, scObjPrec: TSchedID; var supRec: TSetupRec;
                            var compatVal: TCompatVal; var SameGroup : boolean;
                            var scObjPropsStr, scObjPrecPropStr : String): boolean;   }
//    function  SearchObjPropValString(scObjStr, scObjPrecStr: string; var compatVal : TCompatVal; var SetupRec : TSetupRec; var SameGroup, OrigResult : boolean) : boolean;

    procedure GetPropMtxs(lst: TList; upChain: boolean);
    function  GetRulesRtoOMtxs: TList;
    function  GetRulesOtoOMtxs: TList;
    function  GetPropListForGroup(id: TSchedID): TProperties;

    procedure ReportCompatRO(id: TSchedID; list: TList);
    procedure ReportSetupParms(scObj, scObjPrec: TSchedID; list: TList; Before : boolean);

    procedure RefreshDwTimeLinked(CapResMaster: TMqmDurObj; isEnd, isNewDwTime: boolean);
    function  GetRecDwTmLinked(CapResMaster: TMqmDurObj): PTDwTimeLinked;
    procedure AddDwTimeLinked(CapResMaster: TMqmDurObj; isNewDwTime: boolean);
    procedure RemoveDwTimeLinked(CapResMaster: TMqmDurObj; OpStack: pointer);
    function  GetPropertyInstanceCounterValList(Id : TSchedId) : TStringList;
    procedure SetPropertyInstanceCounterValList(Id : TSchedId; list : TStringList);
    function  UpdateInstanceCounterProperty(Id, PrevId : TSchedId) : boolean;
    function  HasActiveInstanceCounterProperty(Id : TSchedId; PropCode : string) : boolean;
    Procedure FindComponentsOnTheNextSubRsc(res : TMqmRes;StartingDate, EndingDate : TDateTime; NumberOfPossibleSubRsc, SubRscCount,
               Components : Integer;var SubRscNumbersChecked : TStringList; var MaxUsedComponents : integer);
    Function  CheckNbrOfComponents(res : TMqmRes; VisRes : TMqmVisibleRes; Id : TSchedID; NbrOfComponents : Integer; StartingDate : TDateTime) : boolean;
  end;

  TMqmVisibleRes = class(TMqmPlanObj)
    constructor CreateVisRes(SubCode: integer);
    destructor  Destroy; override;
  private
    m_CalCode:    string;
    m_cal:        TPGCALObj;
    m_CalCodeReal: string;
    m_CalReal:    TPGCALObj;
    m_CalOnResLvl : TPGCALObj;
    m_EfficiencyOnLevel : CEfficiencyOnLevel;
    m_ActAreas:   TDurList;
    m_SubCode:    integer;
    m_rscComp: integer;
    m_lt, m_rt:   TDateTime;
    //m_SubResExpanded: boolean; // TRUE=sub resources are expanded FALSE=sub res collapsed

    // variable to handle the generator
    m_cnt:          integer;
    m_onActiveArea: boolean;

    procedure SortActAreas;
    function  ActAreasCount: integer;
    function  GetActArea(i: integer): TMqmPlanObj;
    function  GetIsSubRes: boolean;
    function  GetComponentsUsed(RefObjID: TSchedID; StartDate, EndDate: TDateTime): integer;

  public
    function  GetDescr: string; override;
    function  GetFirstDateInDynamicPlan(var DateTime : TDateTime) : boolean;
    function  GetFirstJobIdInDynamicPlan(var JobId : TSchedId) : boolean;
    function  GetCalendar: TPGCALObj;
    procedure StartGenerator(lt, rt: TDateTime);
    function  Next(parms: PTRowParms; var dwFnc: TDurShDraw; var Toadd : boolean): boolean;
    procedure GetColors(brush: TBrush; pen: TPen; font: TFont);
    procedure AddActArea(ActArea: TMqmDurObj);
    function  JobsScheduled : boolean;
    procedure RefreshDwTimeLinked(CapResMaster: TMQMDurObj; isEnd: boolean;
                            RecDwTmLinked: PTDwTimeLinked);

    function  FindActForDate(date: TDateTime): TMqmPlanObj;
    procedure FindActInSpot(startTm, endTm: TDateTime; ObjList: TList);

    procedure ClearCalendar;

    property p_isSubRes: boolean                  read GetIsSubRes;
    property p_SubCode: integer                   read m_SubCode;
    property p_Calendar: TPGCALObj                read GetCalendar;
    property p_CalendarReal: TPGCALObj            read m_CalReal;
    property p_CalCod : string                    read m_CalCode write m_CalCode;
    property p_CalCodReal : string                read m_CalCodeReal;
    property p_EfficiencyOnLevel : CEfficiencyOnLevel read m_EfficiencyOnLevel;
    property p_ActAreasCount: integer             read ActAreasCount;
    property p_ActArea[i: integer]: TMqmPlanObj   read GetActArea;    default;
    property p_ResComp:     integer               read m_rscComp      write m_rscComp;
    //property p_SubResExpanded: boolean            read m_SubResExpanded write m_SubResExpanded;
  end;

implementation

uses
  Variants,
  Sysutils,
  Dialogs,
  UMGlobal,
  UMCompatClr,
  UMPgCal,
  UMActArea,
  UMCapRes,
  UMWkCtr,
  UMPlanGraph,
  UMOpStack,
  UMObjCont,
  UMSchedList,
  FMAutoSched,
  UMArticles,
  UMStoredProc;

const

  PropMtxMap: array[TCompatMatrix] of integer = (
        1,  // simple code
        2,  // code and process
       -1,  // code and product type
       -1,  // code and resource category
       -1,  // code, product type and resource category
       -1   // code, product type and process
      );

  RulesRtoOMtxMap: array[TCompatMatrix] of integer = (
        1,  // simple code
        2,  // code and process
        3,  // code and product type
       -1,  // code and resource category
       -1,  // code, product type and resource category
        4   // code, product type and process
      );

  RulesOtoOMtxMap: array[TCompatMatrix] of integer = (
        1,  // simple code
        2,  // code and process
        3,  // code and product type
       -1,  // code and resource category
       -1,  // code, product type and resource category
        4   // code, product type and process
      );

  OvlpRulesMtxMap: array[TCompatMatrix] of integer = (
        1,  // simple code
        2,  // code and process
        3,  // code and product type
       -1,  // code and resource category
       -1,  // code, product type and resource category
        4   // code, product type and process
      );

//----------------------------------------------------------------------------//
//    TMqmRes    -------------------------------------------------------------//
//----------------------------------------------------------------------------//

type

  TGapDates = record
    UpToDate : TDateTime;
    Gap      : double;
  end;
  PTGapDates = ^TGapDates;

constructor TMqmRes.CreateRes(Code: string);
var
  cmpM: TCompatMatrix;
  OvlpRule: TOvlpRule;
  OvlpRuleDet: TOvlpRuleDet;
begin
  inherited Create;
  m_ResCode := Code;

  // initialize compatibility matrixes
  for cmpM := Low(TCompatMatrix) to High(TCompatMatrix) do
  begin
    // for the resource properties
    if PropMtxMap[cmpM] <> -1 then m_propMtx[PropMtxMap[cmpM]] := nil;

    // for the R to O compatibility rules
    if RulesRtoOMtxMap[cmpM] <> -1 then m_CmpRlsRtoOMtx[RulesRtoOMtxMap[cmpM]] := nil;

    // for the O to O compatibility rules
    if RulesOtoOMtxMap[cmpM] <> -1 then m_CmpRlsOtoOMtx[RulesOtoOMtxMap[cmpM]] := nil;
  end;

  // Put the Default Rules
  m_OvlpRulesList := TMQMOvlpRulesList.Create;

  with OvlpRule do
  begin
    CanDeliverPartial := False;
    MinQtyFromPrvStp := 0;
    MinQtyPassNxtStp := 0;
    UpdBalEveryHour := 0;
    UpdBalEveryQty := 0;
    WaitAtLeastMin := 0;
    WaitAtMostMin := 0;
    WaitEntirePrvQty := True;
    UpdIssFromPrvStpHour := 0;
  end;

  with OvlpRuleDet do
  begin
    MatArticleType := 'EMPTY';
    IssueTransType := 'EMPTY';
    MinMatQty := 0;
    WaitEntireMatQty := True;
    SearchBalance := True;
    UpdEveryHours := 0;
  end;
  AddOvlpRule('EMPTY', '', OvlpRule, OvlpRuleDet);

//  m_ListCompactPropCodeVal := TList.Create;
end;

//----------------------------------------------------------------------------//

destructor TMqmRes.Destroy;
var
  i : integer;
  Rec : PTDwTimeLinked;
begin
  m_OvlpRulesList.Free;

  for i := 0 to m_VisRes.Count-1 do
  begin
    TMqmVisibleRes(m_VisRes[i]).Destroy;
  end;

  m_VisRes.Free;

//  for I := m_ListCompactPropCodeVal.Count - 1 downto 0 do
//    dispose(TPPropertyCodeVal(m_ListCompactPropCodeVal[I]));
//  m_ListCompactPropCodeVal.Free;

  if assigned(m_propMtx[1]) then
    TOrigMatrix(m_propMtx[1]).free;
  m_propMtx[1] := nil;

  if assigned(m_propMtx[2]) then
    TOrigMatrix(m_propMtx[2]).free;
  m_propMtx[2] := nil;

  if assigned(m_CmpRlsRtoOMtx[1]) then
    TOrigMatrix(m_CmpRlsRtoOMtx[1]).free;
  m_CmpRlsRtoOMtx[1] := nil;

  if assigned(m_CmpRlsRtoOMtx[2]) then
    TOrigMatrix(m_CmpRlsRtoOMtx[2]).free;
  m_CmpRlsRtoOMtx[2] := nil;

  if assigned(m_CmpRlsRtoOMtx[3]) then
    TOrigMatrix(m_CmpRlsRtoOMtx[3]).free;
  m_CmpRlsRtoOMtx[3] := nil;

  if assigned(m_CmpRlsRtoOMtx[4]) then
    TOrigMatrix(m_CmpRlsRtoOMtx[4]).free;
  m_CmpRlsRtoOMtx[4] := nil;

  if assigned(m_CmpRlsOtoOMtx[1]) then
    TOrigMatrix(m_CmpRlsOtoOMtx[1]).free;
  m_CmpRlsOtoOMtx[1] := nil;

  if assigned(m_CmpRlsOtoOMtx[2]) then
    TOrigMatrix(m_CmpRlsOtoOMtx[2]).free;
  m_CmpRlsOtoOMtx[2] := nil;

  if assigned(m_CmpRlsOtoOMtx[3]) then
    TOrigMatrix(m_CmpRlsOtoOMtx[3]).free;
  m_CmpRlsOtoOMtx[3] := nil;

  if assigned(m_CmpRlsOtoOMtx[4]) then
    TOrigMatrix(m_CmpRlsOtoOMtx[4]).free;
  m_CmpRlsOtoOMtx[4] := nil;

  if Assigned(m_DwTimeLinked) then
    for i := m_DwTimeLinked.Count -1 downto 0 do
    begin
      Rec := m_DwTimeLinked.Items[i];
      Rec.LstDwTime.Free;
      Dispose(Rec);
    end;

  inherited Destroy;
end;

//----------------------------------------------------------------------------//

function TMqmRes.VisResCount: integer;
begin
  if Assigned(m_VisRes) then
    Result := m_VisRes.Count
  else
    Result := 0
end;

//----------------------------------------------------------------------------//

function TMqmRes.GetVisRes(i: integer): TMqmVisibleRes;
begin
  Assert(Assigned(m_VisRes));
  Result := m_VisRes[i]
end;

//----------------------------------------------------------------------------//

function TMqmRes.GetDescr: string;
begin
  Result := _('Resource') + ' ' + p_ResCode;
end;

//----------------------------------------------------------------------------//

function TMqmRes.GET_GROUP_CODE_FOR_ONE_BATCH_MACHINE : string;
begin
  result := p_GROUP_CODE_FOR_ONE_BATCH_MACHINE
end;

//----------------------------------------------------------------------------//

function TMqmRes.IS_ONE_BATCH_MACHINE_By_GROUP_CODE : boolean;
begin
  result := p_ONE_BATCH_MACHINE_By_GROUP_CODE
end;

//----------------------------------------------------------------------------//

function TMqmRes.IsMultiRes: boolean;

begin
  Result := false;
  if (not Assigned(m_VisRes)) or (m_VisRes.Count = 0) then exit;
  Result := not TMqmVisibleRes(m_VisRes[0]).p_isSubRes
end;

//----------------------------------------------------------------------------//

procedure TMqmRes.AddVisibleRes(VisRes: TMqmPlanObj);
begin
  if not Assigned(m_VisRes) then
    m_VisRes := TList.Create;

  m_VisRes.Add(VisRes);
  VisRes.p_Father := self;
  VisRes.m_plan := m_plan
end;

//----------------------------------------------------------------------------//

function TMqmRes.GetVisResList: TList;
begin
  Assert(Assigned(m_VisRes));
  Result := m_VisRes
end;

//----------------------------------------------------------------------------//

function TMqmRes.GetSubRes(subCode: integer): TMqmVisibleRes;
var
  i: integer;
begin
  Result := nil;
  if not Assigned(m_VisRes) then exit;

  for i := 0 to m_VisRes.Count-1 do
    if TMqmVisibleRes(m_VisRes[i]).m_SubCode = subCode then
    begin
      Result := TMqmVisibleRes(m_VisRes[i]);
      exit
    end
end;

//----------------------------------------------------------------------------//

function TMqmRes.GetValueForProperty(pID: TPropID; proc: string): TPropRes;
var
  mtx:    TCompatMatrix;
  mtxVal: TOrigMatrix;
  tpLink: TCompatTopoLink;
begin
  Assert(Assigned(p_father));
  GetPropCoordForValue(pID, tpLink, mtx);

  Result := nil;
  case tpLink of
  CTL_global:
    Result := GetGlobValueForProperty(pID, mtx);

  CTL_cat:
    Result := m_ResCat.GetValueForProperty(pID, mtx);

  CTL_wkc:
    Result := TMqmWrkCtr(p_father).GetValueForProperty(pID, mtx, proc, m_ResCat.p_ResCatCode);

  else
    // CTL_res
    if PropMtxMap[mtx] = -1 then exit;
    mtxVal := m_propMtx[PropMtxMap[mtx]];
    if not Assigned(mtxVal) then exit;

    case mtx of
    CMX_code:      Result := TPropRes(TOneDmatrix(mtxVal).GetObject(pID));
    CMX_code_proc: Result := TPropRes(TTwoDmatrix(mtxVal).GetObject(pID,proc));
    else
      Assert(false)
    end
  end
end;

//----------------------------------------------------------------------------//

function TMqmRes.GetRuleRtoOfForProperty(pID: TPropID; proc, prod: string): TCompRules;
var
  mtx:    TCompatMatrix;
  mtxVal: TOrigMatrix;
  tpLink: TCompatTopoLink;
begin
  Assert(Assigned(p_father));
  GetPropCoordForRtoOcomp(pID, tpLink, mtx);

  case tpLink of
  CTL_none: Result := nil;

  CTL_global:
    Result := GetGlobRuleRtoOfForProperty(pID, prod, mtx);

  CTL_cat:
    Result := m_ResCat.GetRuleRtoOfForProperty(pID, mtx, prod);

  CTL_wkc:
    Result := TMqmWrkCtr(p_father).GetRuleRtoOfForProperty(pID, mtx, proc, prod, m_ResCat.p_ResCatCode);

  else
    Assert(tpLink = CTL_res);
    Result := nil;
    if RulesRtoOMtxMap[mtx] = -1 then exit;
    mtxVal := m_CmpRlsRtoOMtx[RulesRtoOMtxMap[mtx]];
    if not Assigned(mtxVal) then exit;

    case mtx of
    CMX_code:           Result := TCompRules(TOneDmatrix(mtxVal).GetObject(pID));
    CMX_code_proc:      Result := TCompRules(TTwoDmatrix(mtxVal).GetObject(pID,proc));
    CMX_code_prod:      Result := TCompRules(TTwoDmatrix(mtxVal).GetObject(pID,prod));
    CMX_code_prod_proc: Result := TCompRules(TThreeDmatrix(mtxVal).GetObject(pID,prod,proc));
    else
      Assert(false)
    end
  end
end;

//----------------------------------------------------------------------------//

function TMqmRes.GetRuleOtoOfForProperty(pID: TPropID; proc, prod: string): TCompRules;
var
  mtx:    TCompatMatrix;
  mtxVal: TOrigMatrix;
  tpLink: TCompatTopoLink;
begin
  Assert(Assigned(p_father));
  GetPropCoordForOtoOcomp(pID, tpLink, mtx);

  case tpLink of
  CTL_none:  Result := nil;

  CTL_global:
    Result := GetGlobRuleOtoOfForProperty(pID, prod, mtx);

  CTL_cat:
    Result := m_ResCat.GetRuleOtoOfForProperty(pID, mtx, prod);


  CTL_wkc:
    Result := TMqmWrkCtr(p_father).GetRuleOtoOfForProperty(pID, mtx, proc, prod, m_ResCat.p_ResCatCode);

  else
    Assert(tpLink = CTL_res);
    Result := nil;
    if RulesOtoOMtxMap[mtx] = -1 then exit;
    mtxVal := m_CmpRlsOtoOMtx[RulesOtoOMtxMap[mtx]];
    if not Assigned(mtxVal) then exit;

    case mtx of
    CMX_code:           Result := TCompRules(TOneDmatrix(mtxVal).GetObject(pID));
    CMX_code_proc:      Result := TCompRules(TTwoDmatrix(mtxVal).GetObject(pID,proc));
    CMX_code_prod:      Result := TCompRules(TTwoDmatrix(mtxVal).GetObject(pID,prod));
    CMX_code_prod_proc: Result := TCompRules(TThreeDmatrix(mtxVal).GetObject(pID,prod,proc));
    else
      Assert(false)
    end
  end
end;

//----------------------------------------------------------------------------//

function TMqmRes.CheckCompat(id: TSchedID): TCompatVal;
var
  i:           integer;
  jobPropVal,TestedVal:  variant;
  propRes:     TPropRes;
  rule:        TCompRules;
  prop:        TProperties;
  pId:         TPropID;
  procInfo:    TSQprocInfo;
  tmpComp, DefVal: TCompatVal;
  pos:         integer;
  mtx:    TCompatMatrix;
  tpLink: TCompatTopoLink;
  PropRscCode: string;
  Info : TSQplanInfo;
  NextI : Integer;
begin
  prop := p_sc.GetProperties(id, self);
  p_sc.GetProcInfo(id, procInfo);

  Result := CompValNotDef;

  if prop.p_PropCount = 0 then
    NextI := -1
  else
    NextI := 0;

//  for i := 0 to prop.p_PropCount - 1 do
  while True do
  begin

    if NextI = -1 then break;
    i := NextI;
    NextI := prop.GetNextROProp(i);

    jobPropVal := prop.GetProperty(i, pId, PropRscCode);

    if IsPropDynamic(pId) then
    begin
      p_sc.GetPropVal(id,pId,TestedVal);
      if (TestedVal = jobPropVal) then
      begin
        jobPropVal := p_sc.GetPropDinamicVal(id,jobPropVal);
        jobPropVal := round(jobPropVal);
      end;
    end;

    if (PropRscCode <> '')
    and (PropRscCode <> m_ResCode) then
      continue;

    propRes := GetValueForProperty(pId, procInfo.process);

    GetPropCoordForRtoOcomp(pID, tpLink, mtx);
    if tpLink = CTL_none then continue;

    if Assigned(propRes) then
    begin
       rule := GetRuleRtoOfForProperty(pId, procInfo.process, procInfo.prodType);
       DefVal := propRes.m_dfltResOcc;
       if Assigned(rule) then
       begin
         tmpComp := rule.EvaluateCompat(jobPropVal, propRes.m_val, DefVal, pos);
         if tmpComp > Result then Result := tmpComp
       end else
         if DefVal > Result then Result := DefVal;
    end
  end;

//  p_sc.GetPlanInfo(id, Info);
//  if Info.isGroup then
//    prop.Free;
end;

//----------------------------------------------------------------------------//

procedure TMqmRes.ReportCompatRO(id: TSchedID; list: TList);
var
  i:           integer;
  prop:        TProperties;
  pId:         TPropID;
  procInfo:    TSQprocInfo;
  DefVal:      TCompatVal;
  compRepo:    PTPropCompRepo;
  mtx:    TCompatMatrix;
  tpLink: TCompatTopoLink;
  PropRscCode: string;
  jobPropVal,TestedVal: variant;
  PropRes : TPropRes;
begin
  prop := p_sc.GetProperties(id, self);
  p_sc.GetProcInfo(id, procInfo);

  Assert(Assigned(list));
  list.Clear;

  for i := 0 to prop.p_PropCount - 1 do
  begin
    jobPropVal := prop.GetProperty(i, pId, PropRscCode);

    if IsPropDynamic(pId) then
    begin
      p_sc.GetPropVal(id,pId,TestedVal);
      if (TestedVal = jobPropVal) then
      begin
        jobPropVal := p_sc.GetPropDinamicVal(id,jobPropVal);
        jobPropVal := round(jobPropVal);
      end;
    end;

    if (PropRscCode <> '')
    and (PropRscCode <> m_ResCode) then
      continue;

    GetPropCoordForRtoOcomp(pID, tpLink, mtx);
    if tpLink = CTL_none then continue;

    PropRes := GetValueForProperty(pId, procInfo.process);
    if PropRes = nil then continue;

    New(compRepo);
    list.Add(compRepo);
    compRepo.inJob      := 0; // not relevant in this case
    compRepo.jobPropVal := jobPropVal;
    compRepo.pId        := pId;
    compRepo.propRes    := PropRes;//GetValueForProperty(pId, procInfo.process);
    compRepo.pos        := -1;

    if Assigned(compRepo.propRes) then
    begin
      DefVal := compRepo.propRes.m_dfltResOcc;
      compRepo.rule := GetRuleRtoOfForProperty(pId, procInfo.process, procInfo.prodType);
      if Assigned(compRepo.rule) then
        compRepo.rule.EvaluateCompat(compRepo.jobPropVal, compRepo.propRes.m_val, DefVal, compRepo.pos);
    end
  end
end;

//----------------------------------------------------------------------------//

function TMqmRes.CheckCompIDCapRes(id: TSchedID; CapRes: TMqmPlanObj): TCompatVal;
var
  i:           integer;
  jobPropVal:  variant;
  CapPropVal:  variant;
  rule:        TCompRules;
  SchedProp:        TProperties;
  pId:         TPropID;
  procInfo:    TSQprocInfo;
  tmpComp, DefVal: TCompatVal;
  pos, SamegroupInt:         integer;
  PropRscCode: string;
  tmpSupRec:   TSetupRec;
  IsSameGroup : boolean;
  CurveCode : string;
begin
  SchedProp := p_sc.GetProperties(id, self);
  p_sc.GetProcInfo(id, procInfo);

  Result := CompValBest;

  for i := 0 to SchedProp.p_PropCount - 1 do
  begin
    jobPropVal := SchedProp.GetProperty(i, pId, PropRscCode);
    if (PropRscCode <> '')
    and (PropRscCode <> m_ResCode) then
      continue;

    if TMqmCapRes(CapRes).m_propList.GetValforProp(pId, CapPropVal) then
    begin
        rule := GetRuleOtoOfForProperty(pId, procInfo.process, procInfo.prodType);
        DefVal := GetValueForProperty(pId, procInfo.process).m_dfltOccOcc;
      if Assigned(rule) then
      begin
        tmpComp := rule.EvaluateSetupParms(jobPropVal, CapPropVal, DefVal,
                                            SchedProp, TMqmCapRes(CapRes).m_propList, pID, tmpSupRec, pos, IsSameGroup,SamegroupInt,CurveCode);

        if tmpComp > Result then Result := tmpComp
      end else
        if DefVal > Result then Result := DefVal;
    end
  end
end;

//----------------------------------------------------------------------------//

function TMqmRes.CheckCompCapRes(CapRes: TMqmPlanObj): TCompatVal;
var
  i:           integer;
  CapPropVal:  variant;
  propRes:     TPropRes;
  rule:        TCompRules;
  prop:        TProperties;
  pId:         TPropID;
//  procInfo:    TSQprocInfo;
  tmpComp, DefVal: TCompatVal;
  pos:         integer;
  mtx:    TCompatMatrix;
  tpLink: TCompatTopoLink;
  PropRscCode: string;
begin
  prop := TMqmCapRes(CapRes).m_propList;
//  p_sc.GetProcInfo(id, procInfo);

  Result := CompValNotDef;

  for i := 0 to prop.p_PropCount - 1 do
  begin
    CapPropVal := prop.GetProperty(i, pId, PropRscCode);
    if (PropRscCode <> '')
    and (PropRscCode <> m_ResCode) then
      continue;

    propRes := GetValueForProperty(pId, TMqmCapRes(CapRes).m_WCProc);

    GetPropCoordForRtoOcomp(pID, tpLink, mtx);
    if tpLink = CTL_none then continue;

    if Assigned(propRes) then
    begin
       rule := GetRuleRtoOfForProperty(pId, TMqmCapRes(CapRes).m_WCProc, '');
       DefVal := propRes.m_dfltResOcc;
       if Assigned(rule) then
       begin
         tmpComp := rule.EvaluateCompat(CapPropVal, propRes.m_val, DefVal, pos);
         if tmpComp > Result then Result := tmpComp
       end else
         if DefVal > Result then Result := DefVal;
    end else
    begin
      Result := CompValNotValid;
      break
    end
  end
end;

//----------------------------------------------------------------------------//

function TMqmRes.GetSetupParms(scObj, scObjPrec: TSchedID; var supRec: TSetupRec;
                               var compatVal: TCompatVal; var SameGroup : boolean; var LearningCurveCode : string): boolean;
var
  i:                 integer;
  rules:              TCompRules;
  tmpComp, DefVal:   TCompatVal;
  CompToAdd:         integer;
//  PropToAdd:         integer;
  pId:               TPropID;
  propScObj,
  propScObjPrec:     TProperties;
  procScObjInfo,
  procScObjPrecInfo: TSQprocInfo;
  scObjPropVal,
  scObjPrecPropVal,TestedVal:  variant;
  tmpSupRec:         TSetupRec;
  pos,SamegroupInt: integer;
  AddToSetup :       double; // avi
  AddToOverlap :     double; // avi
  mtx:    TCompatMatrix;
  tpLink: TCompatTopoLink;
  PropRscCode: string;
  IsSameGroup : boolean;
  Info1,Info2 : TSQplanInfo;
  Teoreticl_wc, CurveCode : string;
  Duration, leadTime :double;
  NextI : Integer;
begin
  tmpComp := CompValNotDef;
  AddToSetup := 0;
  AddToOverlap := 0;
  Teoreticl_wc := '';
  Duration := 0;
  LeadTime := 0;

  propScObj := p_sc.GetProperties(scObj, self);
  p_sc.GetProcInfo(scObj, procScObjInfo);

  propScObjPrec := p_sc.GetProperties(scObjPrec, self);
  p_sc.GetProcInfo(scObjPrec, procScObjPrecInfo);

  // if no rule is found are used these default values
  Result                := false;
//  PropToAdd             := 0;
  CompToAdd             := 0;
  compatVal             := CompValBest -1;
  supRec.supAdjType     := CSA_copy;
  supRec.supTime        := 0;
  supRec.supOverlap     := 0;
  supRec.supMult        := 1;
  supRec.supMultOverlap := 1;

//  for i := 0 to propScObj.p_PropCount - 1 do
  if propScObj.p_PropCount = 0 then
    NextI := -1
  else
    NextI := 0;

  while True do
  begin

    if NextI = -1 then break;
    i := NextI;
    NextI := propScObj.GetNextOOProp(i);

    scObjPropVal := propScObj.GetProperty(i, pId, PropRscCode);

    if IsPropDynamic(pId) then
    begin
      p_sc.GetPropVal(scObj,pId,TestedVal);
      if (TestedVal = scObjPropVal) then
      begin
        scObjPropVal := p_sc.GetPropDinamicVal(scObj,scObjPropVal);
        scObjPropVal := round(scObjPropVal);
      end;
    end;

    if (PropRscCode <> '')
    and (PropRscCode <> m_ResCode) then
      continue;

 //-prop    if not propScObjPrec.GetValforProp(pId, scObjPrecPropVal)
//    if not propScObjPrec.GetValforCode(GetPropCodeFromID(pId), m_ResCode, scObjPrecPropVal)
//    or not Assigned(GetValueForProperty(pId, procScObjInfo.process)) then continue;

    GetPropCoordForValue(pID, tpLink, mtx);

    GetPropCoordForOtoOcomp(pID, tpLink, mtx);
    if tpLink = CTL_none then continue;

    if not Assigned(GetValueForProperty(pId, procScObjInfo.process)) then continue;

    rules := GetRuleOtoOfForProperty(pId, procScObjInfo.process, procScObjInfo.prodType);
    DefVal := GetValueForProperty(pId, procScObjInfo.process).m_dfltOccOcc;

    if Assigned(rules) then
    begin
      if not propScObjPrec.GetValforCode(GetPropCodeFromID(pId), m_ResCode, i, scObjPrecPropVal) then continue;

      if IsPropDynamic(pId) then
      begin
        p_sc.GetPropVal(ScObjPrec,pId,TestedVal);
        if (TestedVal = scObjPrecPropVal) then
        begin
          scObjPrecPropVal := p_sc.GetPropDinamicVal(ScObjPrec,scObjPrecPropVal);
          scObjPrecPropVal := round(scObjPrecPropVal);
        end;
      end;

      tmpComp := rules.EvaluateSetupParms(scObjPropVal, scObjPrecPropVal, DefVal,
                                          propScObj, propScObjPrec, pID, tmpSupRec, pos, IsSameGroup, SamegroupInt, CurveCode);
    end;

    if Assigned(rules) and tmpSupRec.RuleFound then
    begin

      if tmpSupRec.supAdjType = CSA_AddTot then  //avi
      begin
        AddToSetup := AddToSetup + tmpSupRec.supTime;
        AddToOverlap := AddToOverlap + tmpSupRec.supOverlap;
      end else
      begin
        if tmpSupRec.supTime > supRec.supTime then
          supRec    := tmpSupRec;
      end;

      if (tmpSupRec.Teoreticl_wc <> Teoreticl_wc) and (Teoreticl_wc = '') then
         Teoreticl_wc := tmpSupRec.Teoreticl_wc;

      if (tmpSupRec.Duration > Duration) and (Duration = 0) then
         Duration := tmpSupRec.Duration;

      if (tmpSupRec.LeadTime > LeadTime) and (LeadTime = 0) then
         LeadTime := tmpSupRec.LeadTime;

      if tmpSupRec.toAdd then  //the property compat case is to be added
      begin
        CompToAdd := CompToAdd + tmpComp;
//        inc(PropToAdd);
        Result    := true
      end
      else
      begin
        if tmpComp > compatVal then
        begin
          compatVal := tmpComp;
          LearningCurveCode := CurveCode;
          Result    := true
        end
      end;

      if (not IsSameGroup) then
          SameGroup := false;

    end
    else
    begin
      if not Assigned(rules) then
      begin
        if DefVal > compatVal then compatVal := DefVal;
      end
      else if tmpComp > compatVal then compatVal := tmpComp;
      Result    := true;

      if (GetValueForProperty(pId, procScObjInfo.process).m_dfltSameGrp = 0) then
          SameGroup := false;

    end;
  end;

//  if (CompToAdd > 0) then
//    CompToAdd := Round(CompToAdd/2);
//    CompToAdd := Round(CompToAdd/PropToAdd);

  if (compatVal + CompToAdd) > CompValNotComp then
    compatVal := CompValNotComp
  else
    compatVal := compatVal + CompToAdd;

  if compatVal < CompValBest then
  begin
    compatVal := CompValBest;
    Result := true
  end;

  supRec.AddToSetup := AddToSetup;
  supRec.AddToOverlap := AddToOverlap;
  supRec.Teoreticl_wc := Teoreticl_wc;
  supRec.Duration     := Duration;
  supRec.LeadTime     := LeadTime;
  supRec.CurveCode    := LearningCurveCode;

//  p_sc.GetPlanInfo(scObj, Info1);
//  if Info1.isGroup then
//    propScObj.Free;

//  p_sc.GetPlanInfo(scObjPrec, Info2);
//  if Info2.isGroup then
//    propScObjPrec.Free;

end;

//----------------------------------------------------------------------------//

function TMqmRes.GetObjPropValString(scObj : TSchedID; var Level : Integer; var HasPropInstanceCounterWithRule : boolean) : string;
var
  i:                 integer;
  pId:               TPropID;
  propScObj:         TProperties;
  scObjPropVal ,  TestedVal:  variant;

  mtx:    TCompatMatrix;
  tpLink: TCompatTopoLink;
  PropRscCode: string;
  NextI : Integer;
  PropCode : string;

begin
  // Level 0=Global/1=Work Center category/2=Resource
  Level := 0;
  HasPropInstanceCounterWithRule := false;

  propScObj := p_sc.GetProperties(scObj, self);

  if propScObj.p_PropCount = 0 then
    NextI := -1
  else
    NextI := 0;

  result := '';
  while True do
  begin
    if NextI = -1 then break;
    i := NextI;
    NextI := propScObj.GetNextOOProp(i);
    scObjPropVal := propScObj.GetProperty(i, pId, PropRscCode);
    if IsPropDynamic(pId) then
    begin
      p_sc.GetPropVal(scObj,pId,TestedVal);
      if (TestedVal = scObjPropVal) then
      begin
        scObjPropVal := p_sc.GetPropDinamicVal(scObj,scObjPropVal);
        scObjPropVal := round(scObjPropVal);
      end;
    end;
    if (PropRscCode <> '')
    and (PropRscCode <> m_ResCode) then continue;
    GetPropCoordForOtoOcomp(pID, tpLink, mtx);
    if tpLink = CTL_none then continue;

    PropCode := GetPropCodeFromID(pId);
    if result <> '' then Result := Result + '_';
    result := Result + PropCode + '_' + vartostr(scObjPropVal);

    if PropRscCode <> '' then Level := 2;

    if tpLink = CTL_res then Level := 2;
    if (Level < 1) and (tpLink = CTL_cat) then Level := 1;
    if (Level < 1) and (tpLink = CTL_wkc) then Level := 1;

    GetPropCoordForValue(pID, tpLink, mtx);
    if tpLink = CTL_res then Level := 2;
    if (Level < 1) and (tpLink = CTL_cat) then Level := 1;
    if (Level < 1) and (tpLink = CTL_wkc) then Level := 1;

    if IsInstanceCounter(pId) then
    begin
      if HasActiveInstanceCounterProperty(scObj, PropCode) then
        HasPropInstanceCounterWithRule := true;
    end;

  end;

end;

//----------------------------------------------------------------------------//

function TMqmRes.GetPropValAffectSameGroupString(scObj : TSchedID) : string;
var
  i:                 integer;
  pId:               TPropID;
  propScObj:         TProperties;
  scObjPropVal ,  TestedVal:  variant;

  mtx:    TCompatMatrix;
  tpLink: TCompatTopoLink;
  PropRscCode: string;
  NextI : Integer;
  PropCode : string;

begin
  propScObj := p_sc.GetProperties(scObj, self);

  if propScObj.p_PropCount = 0 then
    NextI := -1
  else
    NextI := 0;

  result := '';
  while True do
  begin
    if NextI = -1 then break;
    i := NextI;
    NextI := propScObj.GetNextAffectSameGroupProp(i);
    scObjPropVal := propScObj.GetProperty(i, pId, PropRscCode);
    if IsPropDynamic(pId) then
    begin
      p_sc.GetPropVal(scObj,pId,TestedVal);
      if (TestedVal = scObjPropVal) then
      begin
        scObjPropVal := p_sc.GetPropDinamicVal(scObj,scObjPropVal);
        scObjPropVal := round(scObjPropVal);
      end;
    end;
    if (PropRscCode <> '')
    and (PropRscCode <> m_ResCode) then continue;

    if IsPropAffectSameGroupFlag(pID) then
    begin
      PropCode := GetPropCodeFromID(pId);
      if result <> '' then Result := Result + '_';
      result := Result + PropCode + '_' + vartostr(scObjPropVal);
    end;

  end;

end;

//----------------------------------------------------------------------------//

function SortCompactPropCodeVal(Item1, Item2: Pointer): integer;
var
  Rec1 , Rec2: TPPropertyCodeVal;
begin
  Rec1 := TPPropertyCodeVal(Item1);
  Rec2 := TPPropertyCodeVal(Item2);

  if Rec1.PropCod_val = Rec2.PropCod_val then
  begin
    if Rec1.PropCod_val_previd = Rec2.PropCod_val_previd then
      Result := 0
    else if Rec1.PropCod_val_previd > Rec2.PropCod_val_previd then
      Result := 1
    else
      Result := -1
  end
  else if Rec1.PropCod_val > Rec2.PropCod_val then
    Result := 1
  else
    Result := -1
end;

//----------------------------------------------------------------------------//

{function TMqmRes.GetSetupParmsStr(scObj, scObjPrec: TSchedID; var supRec: TSetupRec;
                               var compatVal: TCompatVal; var SameGroup : boolean;
                               var scObjPropsStr, scObjPrecPropStr : String): boolean;
var
  supRecRtrv : TSetupRec;
  PropertyCodeVal : TPPropertyCodeVal;
  OrigResult : boolean;
  LeftId, RightId : TSchedID;
begin
  Result := false;
  if (scObjPropsStr = '') then scObjPropsStr := GetObjPropValString(scObj);
  if (scObjPrecPropStr = '') then scObjPrecPropStr := GetObjPropValString(scObjPrec);
//  if SearchObjPropValString(scObjPropsStr, scObjPrecPropStr, compatVal, supRecRtrv, SameGroup, OrigResult) then
//  begin
//    Result := OrigResult;
//    exit;
//  end;

  new(PropertyCodeVal);

  if scObjPropsStr <= scObjPrecPropStr then
  begin
    PropertyCodeVal.PropCod_val := scObjPropsStr;
    PropertyCodeVal.PropCod_val_previd := scObjPrecPropStr;
    LeftId := scObj;
    RightId := scObjPrec;
  end
  else
  begin
    PropertyCodeVal.PropCod_val := scObjPrecPropStr;
    PropertyCodeVal.PropCod_val_previd := scObjPropsStr;
    LeftId := scObjPrec;
    RightId := scObj;
  end;

  Result := GetSetupParms(scObj, scObjPrec, supRecRtrv, compatVal, SameGroup);
  PropertyCodeVal.compatValId := compatVal;
  PropertyCodeVal.suprecId := supRecRtrv;
  PropertyCodeVal.SameGroupId := SameGroup;
  PropertyCodeVal.OrigResultId := Result;

  Result := GetSetupParms(scObjPrec, scObj, supRecRtrv, compatVal, SameGroup);
  PropertyCodeVal.compatValPrev := compatVal;
  PropertyCodeVal.suprecPrev := supRecRtrv;
  PropertyCodeVal.SameGroupPrev := SameGroup;
  PropertyCodeVal.OrigResultPrev := Result;

//  m_ListCompactPropCodeVal.Add(PropertyCodeVal);
//  m_ListCompactPropCodeVal.Sort(SortCompactPropCodeVal);

end;       }

//----------------------------------------------------------------------------//

{function TMqmRes.SearchObjPropValString(scObjStr, scObjPrecStr: string; var compatVal : TCompatVal; var SetupRec : TSetupRec; var SameGroup, OrigResult : boolean) : boolean;
var
  I : Integer;
  Multiplier, NumberOfEntries : integer;
  PrevToId : boolean;
  TempStr : String;
begin
  Result := false;
  PrevToId := false;
  if scObjStr > scObjPrecStr then
  begin
    PrevToId := true;
    TempStr :=  scObjStr;
    scObjStr :=  scObjPrecStr;
    scObjPrecStr := TempStr;
  end;

  NumberOfEntries := m_ListCompactPropCodeVal.Count;
  if NumberOfEntries = 0 then exit;

  Multiplier := 1;
  while Multiplier < NumberOfEntries do
    Multiplier := Multiplier * 2;
  i := Multiplier - 1;

  while (Multiplier > 0) do
  begin

    Multiplier := trunc(Multiplier/2);

    if (i >= NumberOfEntries) then
    begin
      i := i - Multiplier;
      continue;
    end;

    if (TPPropertyCodeVal(m_ListCompactPropCodeVal[i]).PropCod_val = scObjStr) and
        (TPPropertyCodeVal(m_ListCompactPropCodeVal[i]).PropCod_val_previd = scObjPrecStr) then
    begin
      Result := true;
      if PrevToId then
      begin
        compatVal := TPPropertyCodeVal(m_ListCompactPropCodeVal[i]).compatValPrev;
        SetupRec  := TPPropertyCodeVal(m_ListCompactPropCodeVal[i]).suprecPrev;
        SameGroup := TPPropertyCodeVal(m_ListCompactPropCodeVal[i]).SameGroupPrev;
        OrigResult := TPPropertyCodeVal(m_ListCompactPropCodeVal[i]).OrigResultPrev;
      end
      else
      begin
        compatVal := TPPropertyCodeVal(m_ListCompactPropCodeVal[i]).compatValId;
        SetupRec  := TPPropertyCodeVal(m_ListCompactPropCodeVal[i]).suprecId;
        SameGroup := TPPropertyCodeVal(m_ListCompactPropCodeVal[i]).SameGroupId;
        OrigResult := TPPropertyCodeVal(m_ListCompactPropCodeVal[i]).OrigResultId;
      end;
      break;
    end;

    if (TPPropertyCodeVal(m_ListCompactPropCodeVal[i]).PropCod_val < scObjStr)
    or ((TPPropertyCodeVal(m_ListCompactPropCodeVal[i]).PropCod_val = scObjStr) and
       (TPPropertyCodeVal(m_ListCompactPropCodeVal[i]).PropCod_val_previd < scObjPrecStr)) then
       i := i + Multiplier
    else
       i := i - Multiplier;
  end;

end;           }

//----------------------------------------------------------------------------//

procedure TMqmRes.ReportSetupParms(scObj, scObjPrec: TSchedID; list: TList; Before : boolean);
var
  i:                 integer;
  DefVal:            TCompatVal;
  pId:               TPropID;
  propScObj,
  propScObjPrec:     TProperties;
  procScObjInfo,
  procScObjPrecInfo: TSQprocInfo;
  tmpSupRec:         TSetupRec;
  compRepo:          PTPropCompRepo;
  mtx:    TCompatMatrix;
  tpLink: TCompatTopoLink;
  PropRscCode: string;
  PropVal,TestedVal: variant;
  IsSameGroup : boolean;
  SamegroupInt : Integer;
  ListPropertyInstanceValMain, ListPropertyInstanceValPrev : TStringList;
  IndexCompId, IndexId : integer;
  CompId, Id , PrevId, CurrentId, NextCurrentId, NextId : TSchedID;
  CurveCode : string;
begin
  propScObj := p_sc.GetProperties(scObj, self);
  p_sc.GetProcInfo(scObj, procScObjInfo);

  propScObjPrec := p_sc.GetProperties(scObjPrec, self);
  p_sc.GetProcInfo(scObjPrec, procScObjPrecInfo);

  if Before then
  begin
    CompId := scObjPrec;
    Id := scObj;
  end
  else
  begin
    CompId := scObj;
    Id := scObjPrec;
  end;

  ListPropertyInstanceValMain := GetPropertyInstanceCounterValList(compId);
  ListPropertyInstanceValPrev := GetPropertyInstanceCounterValList(Id);

  if assigned(p_sc.GetExtLinkPtr(compId)) and Assigned(ListPropertyInstanceValMain) then
  begin
    IndexCompId := TMqmActArea(p_sc.GetExtLinkPtr(id)).GetObjIndex(CompId);
    if IndexCompId > -1 then  // CompId is on the same active area as Id
    begin
      IndexId := TMqmActArea(p_sc.GetExtLinkPtr(id)).GetObjIndex(Id);
      if IndexId > IndexCompId then
      begin
        NextId := TMqmActArea(p_sc.GetExtLinkPtr(id)).GetSchedObj(IndexId + 1);
        CurrentId := TMqmActArea(p_sc.GetExtLinkPtr(id)).GetPrecObjByIndex(compId);
        while True do
        begin
          if CurrentId = CSchedIDnull then
            NextCurrentId := TMqmActArea(p_sc.GetExtLinkPtr(id)).GetNextObjByIndex(compId)
          else
            NextCurrentId := TMqmActArea(p_sc.GetExtLinkPtr(id)).GetNextObjByIndex(CurrentId);
          if (NextCurrentId = compId) then
            NextCurrentId := TMqmActArea(p_sc.GetExtLinkPtr(id)).GetNextObjByIndex(NextCurrentId);
          if (NextCurrentId = CSchedIDnull) or (NextCurrentId = NextId) then break;
          UpdateInstanceCounterProperty(NextCurrentId, CurrentId);
          CurrentId := NextCurrentId;
        end;
      end;
    end;
  end;

  UpdateInstanceCounterProperty(compId, Id);

  if Before then
  begin
    PrevId := TMqmActArea(p_sc.GetExtLinkPtr(id)).GetPrecObjByIndex(id);
    if PrevId = compId then
      PrevId := TMqmActArea(p_sc.GetExtLinkPtr(id)).GetPrecObjByIndex(PrevId);
    UpdateInstanceCounterProperty(compId, PrevId);
    UpdateInstanceCounterProperty(Id, compId);
  end;

  for i := 0 to propScObj.p_PropCount - 1 do
  begin
    PropVal := propScObj.GetProperty(i, pId, PropRscCode);
    if (PropRscCode <> '')
    and (PropRscCode <> m_ResCode) then
      continue;

    GetPropCoordForOtoOcomp(pID, tpLink, mtx);
    if (tpLink = CTL_none)
    or not Assigned(GetValueForProperty(pId, procScObjInfo.process)) then continue;

    New(compRepo);
    list.Add(compRepo);

    compRepo.jobPropVal := PropVal;
    compRepo.pId        := pId;
    compRepo.propRes    := GetValueForProperty(pId, procScObjInfo.process);

//-prop    if not propScObjPrec.GetValforProp(pId, compRepo.jobPrecPropVal) then
    if not propScObjPrec.GetValforCode(GetPropCodeFromID(pId), PropRscCode, i, compRepo.jobPrecPropVal) then
    begin
      compRepo.inJob := 2;
      continue
    end;

    compRepo.inJob := 0;

    compRepo.rule := GetRuleOtoOfForProperty(pId, procScObjInfo.process, procScObjInfo.prodType);
    if Assigned(compRepo.rule) then
    begin
      DefVal := GetValueForProperty(pId, procScObjInfo.process).m_dfltOccOcc;
      if IsPropDynamic(pId) then
      begin
        p_sc.GetPropVal(scObj,pId,TestedVal);
        if (TestedVal = compRepo.jobPropVal) then
        begin
          compRepo.jobPropVal := p_sc.GetPropDinamicVal(scObj,compRepo.jobPropVal);
          compRepo.jobPropVal := round(compRepo.jobPropVal);
        end;

        p_sc.GetPropVal(scObjPrec,pId,TestedVal);
        if (TestedVal = compRepo.jobPrecPropVal) then
        begin
          compRepo.jobPrecPropVal := p_sc.GetPropDinamicVal(scObjPrec,compRepo.jobPrecPropVal);
          compRepo.jobPrecPropVal := round(compRepo.jobPrecPropVal);
        end;
      end;
      compRepo.rule.EvaluateSetupParms(compRepo.jobPropVal, compRepo.jobPrecPropVal, DefVal, propScObj, propScObjPrec, pID, tmpSupRec, compRepo.pos, IsSameGroup,SamegroupInt,CurveCode);
      compRepo.WhenOkNextSeq := tmpSupRec.WhenOkNextSeq;
      compRepo.jobPropValPartial := tmpSupRec.Report_jobPropValPartial;
      compRepo.jobPrecPropValPartial := tmpSupRec.Report_jobPrecPropValPartial;
      compRepo.CurveCode := CurveCode
    end
    else
    begin
      if IsPropDynamic(pId) then
      begin
        p_sc.GetPropVal(scObj,pId,TestedVal);
        if (TestedVal = compRepo.jobPropVal) then
        begin
          compRepo.jobPropVal := p_sc.GetPropDinamicVal(scObj,compRepo.jobPropVal);
          compRepo.jobPropVal := round(compRepo.jobPropVal);
        end;

        p_sc.GetPropVal(scObjPrec,pId,TestedVal);
        if (TestedVal = compRepo.jobPrecPropVal) then
        begin
          compRepo.jobPrecPropVal := p_sc.GetPropDinamicVal(scObjPrec,compRepo.jobPrecPropVal);
          compRepo.jobPrecPropVal := round(compRepo.jobPrecPropVal);
        end;
      end;
    end;

  end;

  if Assigned(ListPropertyInstanceValMain) then
  begin
    SetPropertyInstanceCounterValList(compId, ListPropertyInstanceValMain);
    ListPropertyInstanceValMain.Free;
  end;
  if Assigned(ListPropertyInstanceValPrev) then
  begin
    SetPropertyInstanceCounterValList(Id, ListPropertyInstanceValPrev);
    ListPropertyInstanceValPrev.Free;
  end;

  if assigned(P_sc.GetExtLinkPtr(compId)) and Assigned(ListPropertyInstanceValMain)
  and (IndexId > IndexCompId) and (IndexCompId > -1) then
  begin
    UpdateInstanceCounterProperty(CompId, PrevId);
    UpdateInstanceCounterProperty(Id, CompId);
    CurrentId := Id;
    while True do
    begin
      NextCurrentId := TMqmActArea(P_sc.GetExtLinkPtr(id)).GetNextObjByIndex(CurrentId);
      if (NextCurrentId = CSchedIDnull) or (NextCurrentId = NextId) then break;
      UpdateInstanceCounterProperty(NextCurrentId, CurrentId);
      CurrentId := NextCurrentId;
    end;
  end;

end;

//----------------------------------------------------------------------------//

function TMqmRes.CheckCompatWithOcc(opt: TSetChkCompOpt; id: integer; toDate: TDateTime; errLst: TStrings; var compVal: TCompatVal; var Dependency : boolean): boolean;
var
  ObjTimingInfo:      TSQtimingInfo;
  ObjPlanInfo : TSQplanInfo;
//  WrkCtr, OrigWrkCtr: TMqmWrkCtr;
  i, j: integer;
  job1, job2: TSchedID;
  supRec: TSetupRec;
  compatVal: TCompatVal;
  IsSameGroup : boolean;
  FieldVal : variant;
  dataType: CBinColValType;
  StepGroupType : string;
  ProdReq, LearningCurveCode : string;
  ProdStep : integer;
  Unsechedule : boolean;
  DependencyDummy : boolean;
  PropList1, PropList2, PropListToPropList  : String;
  Level : Integer;
  HasPropInstanceCounterWithRule : boolean;
  PropListToPropListList, IdPropList : TStringList;
begin
  Result := false;
  IsSameGroup := true;
  Dependency := false;

  if (cho_readOnly in opt) and TMqmWrkCtr(p_WrkCtr).p_ReadOnly then
  begin
    if Assigned(ErrLst) then
      ErrLst.Add(_('Read only resource'));
    exit;
  end;

  p_sc.GetTimingInfo(id, ObjTimingInfo);

{  if m_ProcessType <> ObjTimingInfo.stepType then  // avi 08/07/07 - for isko remove resource checking
  begin
    if Assigned(ErrLst) then
      ErrLst.Add(_('Resource of different process'));
    exit;
  end;  }

//  WrkCtr := TMqmWrkCtr(p_WrkCtr);
//  OrigWrkCtr := TMqmWrkCtr(p_sc.GetWrkCtrPtr(id));
//  OrigWrkCtr := TMqmWrkCtr(p_pl.FindWrkCtrByCode(ObjTimingInfo.wkctCode));


  if (cho_wkc in opt) and (not p_occGoodWkc[id]) then
  begin
    if Assigned(ErrLst) then
        ErrLst.Add(_('Resource of different workcenter'));
    exit;
  end;
{
  if (cho_wkc in opt) and (OrigWrkCtr.p_WrkCtrCode <> WrkCtr.p_WrkCtrCode)
  and not OrigWrkCtr.GetAltProcForAltWrkCtr(ObjTimingInfo.wcProc, WrkCtr.p_WrkCtrCode, ObjTimingInfo.wcProc) then
  begin
    if Assigned(ErrLst) then
      ErrLst.Add(_('Resource of different workcenter'));
    exit;
  end;
}
  CompVal := CheckCompat(id);
  if (cho_compVal in opt) and (not (CompVal in [0..98])) then
  begin
    if not Assigned(FAutoSched) and (not m_ForceOccToResCase99) then
    begin
      if Assigned(ErrLst) then
        ErrLst.Add(_('Compatibility case not valid'));
      exit;
    end;
  end;

  if (cho_timing in opt) and (not p_occHasTimings) then
  begin
    if Assigned(ErrLst) then
    begin
      // check if not only St is missing (maybe the job was deleted from host
      p_sc.GetFldValue(id, CSC_ProdReq, FieldVal, dataType);
      ProdReq := FieldVal;
      p_sc.GetFldValue(id, CSC_ProdStep, FieldVal, dataType);
      ProdStep := FieldVal;
      if m_plan.HasJobWasDeletetedFromHost(ProdReq,ProdStep, Unsechedule) then
        ErrLst.Add(_('Request:') + ' ' + ProdReq + ' ' + _('does no longer exist. Refresh will remove it from Gantt.'))
      else
        ErrLst.Add(_('No Setup - Execution time defined for this resource'));
    end;
    exit;
  end;

  if (cho_Depend in opt) and (not p_occGoodDepend[id]) then
  begin
    if Assigned(ErrLst) then
        ErrLst.Add(_('Dependency rules not valid for this resource'));
    Dependency := true;
    exit;
  end;

  if (cho_Qty in opt) and (not p_occGoodMinQty[id]) then
  begin
    if not Assigned(FAutoSched) and not m_ForceOutsideLimitQty then
    begin
      if Assigned(ErrLst) then
        ErrLst.Add(_('The group quantity is lower than the resource minimum batch size'));
      exit;
    end;
  end;

  if (cho_Qty in opt) and (not p_occGoodMaxQty[id]) then
  begin
    if not Assigned(FAutoSched) and not m_ForceOutsideLimitQty then
    begin
      if Assigned(ErrLst) then
          ErrLst.Add(_('The group quantity is greater than the resource maximum batch size'));
      exit;
    end;
  end;

  p_sc.GetPlanInfo(id, ObjPlanInfo);
{
  if p_BchUM <> '' then
  begin
    BatchQty := ObjPlanInfo.quant;
    p_sc.QtyInUM(Id, p_BchUM, BatchQty);
    if (p_Min_bch_size > 0) and (BatchQty < p_Min_bch_size) then
    begin
      if Assigned(ErrLst) then
        ErrLst.Add('The group quantity is lower than the resource minium batch size');
      exit;
    end;

    if (p_Max_bch_size > 0) and (BatchQty > p_Max_bch_size) then
    begin
      if Assigned(ErrLst) then
        ErrLst.Add('The group quantity is greater than the resource maximum batch size');
      exit;
    end;
  end;
}
  if ObjPlanInfo.isGroup then
  begin
    IdPropList := TStringList.Create;
    PropListToPropListList := TStringList.Create;
    PropListToPropListList.Sorted := true;
    for i := 0 to p_sc.GetGrpNumSons(id)-1 do
    begin
      Job1 := p_sc.GetGrpSon(id, i);
      PropList1 := GetPropValAffectSameGroupString(Job1);
      IdPropList.add(PropList1);
    end;
    for i := 0 to p_sc.GetGrpNumSons(id)-1 do
    begin
      Job1 := p_sc.GetGrpSon(id, i);
      PropList1 := IdPropList[i];
      for j := (i + 1) to p_sc.GetGrpNumSons(id)-1 do
      begin
        Job2 := p_sc.GetGrpSon(id, j);
        PropList2 := IdPropList[j];
        PropListToPropList := PropList1 + '%%%%' + PropList2;
        if PropListToPropListList.IndexOf(PropListToPropList) <> -1 then continue;
        PropListToPropListList.Add(PropListToPropList);
        GetSetupParms(Job1, Job2, supRec, compatVal, IsSameGroup, LearningCurveCode);
        if not IsSameGroup then
        begin
          if Assigned(ErrLst) then
            ErrLst.Add(_('According to Occ to Occ Rules the group is not valid for this resource'));
          //  ErrLst.Add(_('The jobs in this group are not compatible for this resource'));
          exit;
        end;
      end;
    end;
    IdPropList.Free;
    PropListToPropListList.Free;
  end
  else
  begin
    if not ObjPlanInfo.is_MaterialSched then
    begin
      p_sc.GetFldValue(id, CSC_StepGroupType, FieldVal, dataType);
      StepGroupType := FieldVal;
      if StepGroupType = '3' then
      begin
        if Assigned(ErrLst) then
          ErrLst.Add(_('The job must be in a group.'));
        exit;
      end;
    end;
  end;

  if Assigned(p_Father) then
    Result := p_Father.CheckCompatWithOcc(opt, id, toDate, errLst, compVal, DependencyDummy)
  else
    Result := True;
end;

//----------------------------------------------------------------------------//

function TMqmRes.GetWrkCtr: TMqmPlanObj;
begin
  Result := nil;
  if Assigned(p_father) then
    Result := p_father
end;

//----------------------------------------------------------------------------//

procedure TMqmRes.ClearCompatCaches;
begin
  m_compatVal  := CompValNotDef;
  m_hasTimings := -1;
  m_goodWkc    := -1;
  m_goodDep    := -1
end;

//----------------------------------------------------------------------------//

function TMqmRes.PSoccCanAttach: boolean;
begin
  Result := false;
  if  p_occGoodWkc[p_pl.GetCompatModeInPlanId]
  and p_occHasTimings
  and (p_occCompatVal <> CompValNotComp)
  and p_occGoodDepend[p_pl.GetCompatModeInPlanId]  then
    Result := true
end;

//----------------------------------------------------------------------------//

function TMqmRes.PSoccCompatVal: TCompatVal;
begin
  if m_compatVal = CompValNotDef then
    if (p_pl.GetCompatModeInPlanCapRes <> nil) then
      m_compatVal := CheckCompCapRes(TMqmPlanObj(p_pl.GetCompatModeInPlanCapRes))
    else
      m_compatVal := CheckCompat(p_pl.GetCompatModeInPlanId);
  Result := m_compatVal
end;

//----------------------------------------------------------------------------//

function TMqmRes.PSoccHasTimings: boolean;
begin
  if (p_pl.GetCompatModeInPlanId <> CSchedIDnull) and p_sc.IsProdSchedMaterial(p_pl.GetCompatModeInPlanId) then
  begin
    result := true;
    Exit
  end;

  if m_hasTimings = -1 then
    if m_plan.HasTimingsOnRes(self) then
      m_hasTimings := 1
    else
      m_hasTimings := 0;

  if m_hasTimings = 1 then
    Result := true
  else
    Result := false
end;

//----------------------------------------------------------------------------//

function TMqmRes.PSoccGoodMinQty(id: TSchedID): boolean;
var
  ObjPlanInfo: TSQplanInfo;
  BatchQty: double;
  MultQty : double;
  AdditionalMultiplierProp : double;
begin
  p_sc.GetPlanInfo(id, ObjPlanInfo);
  Result := true;

  if not ObjPlanInfo.BatchSizePerStep then
  begin
    if p_BchUM <> '' then
    begin
      BatchQty := ObjPlanInfo.quant;
        if ObjPlanInfo.MinBatchSize <> -1 then
      p_sc.QtyInUM(Id, p_BchUM, BatchQty, MultQty);
      AdditionalMultiplierProp := P_GetAdditionalMinMultiplierProp[Id];
      if ((AdditionalMultiplierProp*p_Min_bch_size > 0) and (currency(BatchQty) < Currency(AdditionalMultiplierProp*p_Min_bch_size))) then
        Result := false;
    end;

  end
//  end
  else
  begin
    BatchQty := ObjPlanInfo.quant;
    if (ObjPlanInfo.MinBatchSize > 0) and (BatchQty < ObjPlanInfo.MinBatchSize) then
        Result := false;
  end;
end;

//----------------------------------------------------------------------------//

function TMqmRes.PSoccGoodMaxQty(id: TSchedID): boolean;
var
  ObjPlanInfo: TSQplanInfo;
  BatchQty: double;
  MultQty : double;
  AdditionalMultiplierProp : double;
begin
  p_sc.GetPlanInfo(id, ObjPlanInfo);
  Result := true;

  if not ObjPlanInfo.BatchSizePerStep then
  begin
  if p_BchUM <> '' then
    begin
      BatchQty := ObjPlanInfo.quant;
      if ObjPlanInfo.MaxBatchSize <> -1 then
        p_sc.QtyInUM(Id, p_BchUM, BatchQty, MultQty);
      AdditionalMultiplierProp := P_GetAdditionalOptimumMaxMultiplierProp[Id];
      if ((AdditionalMultiplierProp*p_Max_bch_size) > 0) and (BatchQty > (AdditionalMultiplierProp*p_Max_bch_size)) then
        Result := false;
    end;
  end
  else
  begin
    BatchQty := ObjPlanInfo.quant;
    if (ObjPlanInfo.MaxBatchSize > 0) and (BatchQty > ObjPlanInfo.MaxBatchSize) then
      Result := false;
  end;
end;

//----------------------------------------------------------------------------//

function TMqmRes.CheckMaxQtyOnBatchMachinSameGrpCode(id: TSchedID): boolean;
var
  ObjPlanInfo: TSQplanInfo;
  BatchQty: double;
  MultQty : double;
  AdditionalMultiplierProp : double;
begin
  p_sc.GetPlanInfo(id, ObjPlanInfo);
  Result := false;

  if p_BchUM <> '' then
  begin
    BatchQty := ObjPlanInfo.quant;
    p_sc.QtyInUM(Id, p_BchUM, BatchQty, MultQty);
    AdditionalMultiplierProp := P_GetAdditionalOptimumMaxMultiplierProp[Id];
    if ((AdditionalMultiplierProp*p_Max_bch_size) > 0) and (BatchQty > p_Single_Max_bch_size) then
      Result := true;
  end;
end;

//----------------------------------------------------------------------------//

function TMqmRes.CheckUsedAllMachinePartsProcessOnBatchMachinSameGrpCode(id: TSchedID; CheckedId : TSchedID): boolean;
var
  WcVal, WcValChecked, ProcessVal, ProcessValChecked : variant;
  dataType: CBinColValType;
  WrkCtr : TMqmWrkCtr;
  ProcessVal_UseAllMachineParts, ProcessValChecked_UseAllMachineParts : CUseMachineParts;
begin
  Result := false;
  p_sc.GetFldValue(id, CSC_WkctCode, WcVal, dataType);
  p_sc.GetFldValue(CheckedId, CSC_WkctCode, WcValChecked, dataType);
  if WcVal <> WcValChecked then exit;

  WrkCtr := TMqmWrkCtr(p_pl.FindWrkCtrByCode(WcVal));
  if not assigned(WrkCtr) then exit;

//  if not WrkCtr.P_UseMachineParts then exit;

  p_sc.GetFldValue(id, CSC_WkctProc, ProcessVal, dataType);
  ProcessVal_UseAllMachineParts := WrkCtr.GetUseAllMachinePartsByProcess(ProcessVal);
//  if ProcessVal_UseAllMachineParts = Mp_Non then exit;

  p_sc.GetFldValue(CheckedId, CSC_WkctProc, ProcessValChecked, dataType);
  ProcessValChecked_UseAllMachineParts := WrkCtr.GetUseAllMachinePartsByProcess(ProcessValChecked);
//  if ProcessValChecked_UseAllMachineParts = Mp_Non then exit;

  if ((ProcessVal_UseAllMachineParts = Mp_RearPart) and (ProcessValChecked_UseAllMachineParts = Mp_FrontPart)) or
     ((ProcessValChecked_UseAllMachineParts = Mp_RearPart) and (ProcessVal_UseAllMachineParts = Mp_FrontPart)) then
     exit;
  result := true;

end;

//----------------------------------------------------------------------------//

function TMqmRes.PGetSplitQtyByBatch(id: TSchedID; var Qty : currency; var MinQty : currency) : boolean;
var
  BatchQty : double;
  MultQty  : double;
//  ObjPlanInfo: TSQplanInfo;
begin
  Result := true;

{  p_sc.GetPlanInfo(id, ObjPlanInfo);

  if not ObjPlanInfo.BatchSizePerStep then
  begin
    if p_BchUM <> '' then
    begin
      if not p_sc.QtyInUM(Id, p_BchUM, BatchQty, MultQty) then
      begin
        Result := false;
        Exit;
      end;
      if MultQty = 0 then
      begin
        Result := false;
        exit
      end;
      Qty := p_Sndt_bch_Size/MultQty;
      Qty := trunc(Qty*100)/100;
      MinQty := p_Min_bch_size;
    end
    else
      Result := false;
  end
  else
  begin
    if ObjPlanInfo.OptimumBatchSize > 0 then
    begin
      Qty := ObjPlanInfo.OptimumBatchSize;
      MinQty := ObjPlanInfo.MinBatchSize;
    end
    else
      Result := false;
  end;

  }
end;

//----------------------------------------------------------------------------//

function TMqmRes.PSoccGoodWkc(id: TSchedID): boolean;
var
  tmgInfo: TSQtimingInfo;
  resWkc:  TMqmWrkCtr;
  objWkc:  TMqmWrkCtr;
  altProc: string;
  MaterialScheduleLvl : ArMaterialScheduleLvl;
begin
  //if (m_goodWkc = -1)
  //or (p_pl.GetCompatModeInPlanId <> id) then
  if true then

  begin
    m_goodWkc := -1;   // avi added


    p_sc.GetTimingInfo(id, tmgInfo);
   // if m_ProcessType <> tmgInfo.stepType then // avi 08/07/07 - for isko remove resource checking
   //   m_goodWkc := 1
   // else
   // begin
    resWkc := TMqmWrkCtr(p_WrkCtr);

  //  if (p_pl.GetCompatModeInBinVisRes <> nil) and //(p_pl.GetCompatModeInPlanId <> CSchedIDnull) and not p_sc.IsProdSchedMaterial(p_pl.GetCompatModeInPlanId)
    if not p_sc.IsProdSchedMaterial(id)then
   // if (p_pl.GetCompatModeInPlanId <> CSchedIDnull) and not p_sc.IsProdSchedMaterial(p_pl.GetCompatModeInPlanId)
    begin
      if resWkc.p_WrkCtrCode = tmgInfo.wkctCode then
          m_goodWkc := 1
      else
      begin
        objWkc := TMqmWrkCtr(p_sc.GetWrkCtrPtr(id));

        //check that the workcenter of the resource (resWkc) is an alternative
        //of the one of the job (objWkc)
        if Assigned(objWkc) then
        begin
          if not objWkc.GetAltProcForAltWrkCtr(tmgInfo.wcProc, resWkc.p_WrkCtrCode, altProc) then
            m_goodWkc := 0
          else
            m_goodWkc := 1
        end
        else
          m_goodWkc := 0
      end
    end
    else
    begin
      if (resWkc.P_WarpLevl = Wc_No) then
        m_goodWkc := -1
      else
      begin
        MaterialScheduleLvl := p_sc.GetWarp_Levl_Material(id);
        if (MaterialScheduleLvl = MT_BaseLvl) then
           m_goodWkc := 1
        else if resWkc.P_WarpLevl = Wc_BaseAndSecondLvl then
           m_goodWkc := 1
        else if (MaterialScheduleLvl = MT_SecondLvl) then
          m_goodWkc := -1
      end;

    end;
  end;

  if m_goodWkc = 1 then
    Result := true
  else
    Result := false
end;

//----------------------------------------------------------------------------//

function TMqmRes.PSoccGoodDepend(id: TSchedID): boolean;
begin

  if (m_goodDep = -1)
  or (p_pl.GetCompatModeInPlanId <> id) then
  begin
    if p_sc.CheckDependencyOnRes(id, self) then
      m_goodDep := 1
    else
      m_goodDep := 0;
  end;

  if m_goodDep = 1 then
    Result := true
  else
    Result := false
end;

//----------------------------------------------------------------------------//

procedure TMqmRes.GetPropMtxs(lst: TList; upChain: boolean);
var
  cmpM: TCompatMatrix;
  wkc:  TMqmWrkCtr;
begin
  for cmpM := Low(TCompatMatrix) to High(TCompatMatrix) do
  begin
    if (PropMtxMap[cmpM] = -1) or
       (not Assigned(m_propMtx[PropMtxMap[cmpM]])) then continue;
    lst.Add(m_propMtx[PropMtxMap[cmpM]]);
  end;

  if upChain then
  begin
    wkc := TMqmWrkCtr(p_WrkCtr);
    Assert(Assigned(wkc));
    wkc.GetPropMtxs(lst, true)
  end
end;

//----------------------------------------------------------------------------//

function TMqmRes.GetRulesRtoOMtxs: TList;
var
  cmpM: TCompatMatrix;
begin
  Result := TList.Create;

  for cmpM := Low(TCompatMatrix) to High(TCompatMatrix) do
  begin
    if (RulesRtoOMtxMap[cmpM] = -1) or
       (not Assigned(m_CmpRlsRtoOMtx[RulesRtoOMtxMap[cmpM]])) then continue;
    Result.Add(m_CmpRlsRtoOMtx[RulesRtoOMtxMap[cmpM]])
  end
end;

//----------------------------------------------------------------------------//

function TMqmRes.GetRulesOtoOMtxs: TList;
var
  cmpM: TCompatMatrix;
begin
  Result := TList.Create;

  for cmpM := Low(TCompatMatrix) to High(TCompatMatrix) do
  begin
    if (RulesOtoOMtxMap[cmpM] = -1) or
       (not Assigned(m_CmpRlsOtoOMtx[RulesOtoOMtxMap[cmpM]])) then continue;
    Result.Add(m_CmpRlsOtoOMtx[RulesOtoOMtxMap[cmpM]])
  end
end;

//----------------------------------------------------------------------------//

function TMqmRes.GetPropListForGroup(id: TSchedID): TProperties;
var
  i,j, num: integer;
  JobId: TSchedID;
  JobProp: TProperties;
  PropRes: TPropRes;
  pId:      TPropID;
  procInfo: TSQprocInfo;
  jobPropVal,
  GrpPropVal,TestedVal:  variant;
  Exist: boolean;
  PropRscCode: string;
  IsAlpha : boolean;
begin
  Result := p_sc.GetGroupPropList(id);
  if not p_sc.GetPropListFlag(Id) and (m_ResCode = p_sc.GetResourceForPropList(id)) then exit;
  p_sc.RemoveGroupPropList(id);

  Result := TProperties.Create;
  // Loop the sons of the group
  for i := 0 to p_sc.GetGrpNumSons(id)-1 do
  begin
    JobId   := p_sc.GetGrpSon(id, i);
    JobProp := p_sc.GetProperties(JobId, self);
    p_sc.GetProcInfo(JobId, procInfo);

    //Loop the properties of each son of the group
    for j := 0 to JobProp.p_PropCount-1 do
    begin
      jobPropVal := JobProp.GetProperty(j, pId, PropRscCode);

      if IsPropDynamic(pId) then
      begin
        p_sc.GetPropVal(JobId,pId,TestedVal);
        if (TestedVal = jobPropVal) then
        begin
          jobPropVal := p_sc.GetPropDinamicVal(JobId,jobPropVal);
          if IsPropDynamic(pId) then
          begin
            num := trunc(100*jobPropVal);
            jobPropVal := num/100;  // supporting 2 decimal
          end;
          //jobPropVal := round(jobPropVal);
        end;
      end;

      if (PropRscCode <> '')
      and (PropRscCode <> m_ResCode) then
        continue;

      PropRes := GetValueForProperty(pId, procInfo.process);
      if not Assigned(PropRes) then
        continue;

      if Result.GetValforProp(pId, GrpPropVal) then
        Exist := true
      else
        Exist := false;

 //     if PropRes.m_ValForGrp <> 1 then
 //       Assert(VarType(jobPropVal) <> varString);

      if IsPropAlpha(GetPropCodeFromID(pId)) then
        IsAlpha := true
      else
        IsAlpha := false;

      case PropRes.m_ValForGrp of
        1: if not Exist then
           begin
             if IsAlpha then
                Result.AddProperty(GetPropCodeFromID(pId), '', jobPropVal) //-prop
             else
                Result.AddPropertyToGroup(GetPropCodeFromID(pId), '', jobPropVal); //-prop
           end;

        2: if Exist then
             Result.SetValforProp(pId, GrpPropVal + jobPropVal)
           else
           begin
             if IsAlpha then
               Result.AddProperty(GetPropCodeFromID(pId), '', jobPropVal) //-prop
             else
               Result.AddPropertyToGroup(GetPropCodeFromID(pId), '', jobPropVal) //-prop
           end;
        3: if Exist then
           begin
             if jobPropVal < GrpPropVal then
             Result.SetValforProp(pId, jobPropVal)
           end else
           begin
             if IsAlpha then
               Result.AddProperty(GetPropCodeFromID(pId), '', jobPropVal) //-prop
             else
               Result.AddPropertyToGroup(GetPropCodeFromID(pId), '', jobPropVal) //-
           end;
        4: if Exist then
           begin
             if jobPropVal > GrpPropVal then
             Result.SetValforProp(pId, jobPropVal)
           end else
           begin
             if IsAlpha then
               Result.AddProperty(GetPropCodeFromID(pId), '', jobPropVal) //-prop
             else
               Result.AddPropertyToGroup(GetPropCodeFromID(pId), '', jobPropVal); //-prop
           end;
      end;
    end;
  end;

  p_sc.SetPropListFlag(id, false, false);
  p_sc.SetGroupPropList(id, result);
  p_sc.SetResourceForPropList(id, m_ResCode);

end;

//----------------------------------------------------------------------------//

function TMqmRes.AddProperty(code: string; var val: TPropResRec; ErrList: TStringList): boolean;
var
  propRes: TPropRes;
  pId:     TPropID;
  tpLink:  TCompatTopoLink;
  mtx:     TCompatMatrix;
  mtxVal:  TOrigMatrix;
begin
  propRes := TPropRes.Create;

  propRes.m_addResToOcc := val.addResToOcc;
  propRes.m_dfltResOcc  := val.dfltResOcc;
  propRes.m_dfltOccOcc  := val.dfltOccOcc;
  propRes.m_dfltSameGrp := val.dfltSameGrp;
  propRes.m_ValForGrp   := val.ValForGrp;

  pId := DecodeProp(code, val.valStr, propRes.m_val);
  if not Assigned(pId) then
  begin
    ErrList.Add(GetDescr + ': ' + _('Error loading property') + ' ' + code);
    Result := false;
    exit
  end;
{
  // mario to put on log
  if not Assigned(pId) then
  begin
    Result := false;
    exit
  end;
}
  GetPropCoordForValue(pID, tpLink, mtx);
  if tpLink <> CTL_res then
  begin
    ErrList.Add(GetDescr + ': ' + _('Error loading property') + ' ' + code + #13#10 + ' system expects the property will be defined in a resource level');
    Result := false;
    exit
  end;

 // Assert(tpLink = CTL_res);

  Assert(PropMtxMap[mtx] <> -1);
  if not Assigned(m_propMtx[PropMtxMap[mtx]]) then
    CreateMatrix(m_propMtx[PropMtxMap[mtx]], mtx);

  mtxVal := m_propMtx[PropMtxMap[mtx]];

  if mtx = CMX_code then
    TOneDmatrix(mtxVal).AddObject(pId, propRes)
  else
  begin
    Assert(mtx = CMX_code_proc);
    TTwoDmatrix(mtxVal).AddObject(pId, val.proc, propRes)
  end;

  Result := true
end;

//----------------------------------------------------------------------------//

procedure AssignCmpRuleToMat(pId: TPropID; mtx: TCompatMatrix; mtxVal: TOrigMatrix;
                              isOtoO: boolean; var vrnt: variant; var val: TRuleResRec);
var
  oneDmtx:   TOneDmatrix;
  twoDmtx:   TTwoDmatrix;
  threeDmtx: TThreeDmatrix;
  rule:      TCompRules;
  sup:       TSetupRec;
begin
  rule := nil;

  case mtx of
  CMX_code: begin
              oneDmtx := TOneDmatrix(mtxVal);
              rule := TCompRules(oneDmtx.GetObject(pId));
              if not Assigned(rule) then
              begin
                rule := TCompRules.Create;
                oneDmtx.AddObject(pId, rule)
              end
            end;

  CMX_code_proc: begin //  code and process
                   twoDmtx := TTwoDmatrix(mtxVal);
                   rule := TCompRules(twoDmtx.GetObject(pId, val.proc));
                   if not Assigned(rule) then
                   begin
                     rule := TCompRules.Create;
                     twoDmtx.AddObject(pId, val.proc, rule)
                   end
                 end;

  CMX_code_prod: begin // code and product type
                   twoDmtx := TTwoDmatrix(mtxVal);
                   rule := TCompRules(twoDmtx.GetObject(pId, val.prodType));
                   if not Assigned(rule) then
                   begin
                     rule := TCompRules.Create;
                     twoDmtx.AddObject(pId, val.prodType, rule)
                   end
                 end;

  CMX_code_prod_proc: begin // code, product type and process
                        threeDmtx := TThreeDmatrix(mtxVal);
                        rule := TCompRules(threeDmtx.GetObject(pId, val.prodType, val.proc));
                        if not Assigned(rule) then
                        begin
                          rule := TCompRules.Create;
                          threeDmtx.AddObject(pId, val.prodType, val.proc, rule)
                        end
                      end
  end;

  Assert(Assigned(rule));

  if not isOtoO then
    rule.AddItem(val.checkSeq, val.toBase, vrnt, val.op, val.comp, nil)
  else
  begin
    sup.Value          := ConvPropValue(pId, val.constStr);
    sup.supAdjType     := val.supAdjType;
    sup.supTime        := val.supTime;
    sup.supOverlap     := val.supOverlap;
    sup.supMult        := val.supMult;
    sup.supMultOverlap := val.supMultOverlap;
    if val.onSameGroup = '0' then
      sup.OnSameGroupInt := 0
    else if val.onSameGroup = '1' then
      sup.OnSameGroupInt := 1
    else if val.onSameGroup = '2' then
      sup.OnSameGroupInt := 2;

    if val.onSameGroup = '1' then
      sup.onSameGroup := true
    else
      sup.onSameGroup := false;

    rule.AddItem(val.checkSeq, val.toBase, vrnt, val.op, val.comp, @sup)
  end
end;

//----------------------------------------------------------------------------//

function TMqmRes.AddRtoOrule(code: string; var val: TRuleResRec; ErrList: TStringList): boolean;
var
  pId:       TPropID;
  tpLink:    TCompatTopoLink;
  mtx:       TCompatMatrix;
  vrnt:      variant;
begin
  pId := DecodeProp(code, val.valStr, vrnt);

  if not Assigned(pId) then
  begin
    ErrList.Add(GetDescr + ': ' + _('Error loading property') + ' ' + code);
    Result := false;
    exit
  end;

  GetPropCoordForRtoOcomp(pId, tpLink, mtx);
  if (tpLink = CTL_none) then
  begin
    ErrList.Add(GetDescr + ': ' + _('Property') + ' ' + code + ' ' + 'disabled for res. to occ. checks');
    Result := false;
    exit
  end;

  //Assert(tpLink = CTL_res);

  if tpLink <> CTL_res then
  begin
    ErrList.Add(GetDescr + ': ' + _('Error loading property') + ' ' + code + #13#10 + _('system expects the property rule will be defined as a resource level, according to property definition'));
    Result := false;
    exit
  end;

  Assert(RulesRtoOMtxMap[mtx] <> -1);
  if not Assigned(m_CmpRlsRtoOMtx[RulesRtoOMtxMap[mtx]]) then
    CreateMatrix(m_CmpRlsRtoOMtx[RulesRtoOMtxMap[mtx]], mtx);

  AssignCmpRuleToMat(pId, mtx, m_CmpRlsRtoOMtx[RulesRtoOMtxMap[mtx]], false, vrnt, val);
  Result := true
end;

//----------------------------------------------------------------------------//

function TMqmRes.AddOtoOrule(code: string; var val: TRuleResRec; ErrList: TStringList): boolean;
var
  pId:    TPropID;
  tpLink: TCompatTopoLink;
  mtx:    TCompatMatrix;
  vrnt:   variant;
  PropCode : string;
begin
  pId := DecodeProp(code, val.valStr, vrnt);

  if not Assigned(pId) then
  begin
    ErrList.Add(GetDescr + ': ' + _('Error loading property') + ' ' + code);
    Result := false;
    exit
  end;

  GetPropCoordForOtoOcomp(pId, tpLink, mtx);
  try
    Assert(tpLink = CTL_res);
  except
    PropCode := GetPropCodeFromID(pID);
    ErrList.Add(_('UMRes') + ': ' + _('Error loading rules Occ Occ for property') + ' ' + PropCode + ' '
     + '- ' +  _('Resource Level is expected for property definition.'));
    Result := false;
  end;

  Assert(RulesOtoOMtxMap[mtx] <> -1);
  if not Assigned(m_CmpRlsOtoOMtx[RulesOtoOMtxMap[mtx]]) then
    CreateMatrix(m_CmpRlsOtoOMtx[RulesOtoOMtxMap[mtx]], mtx);

  AssignCmpRuleToMat(pId, mtx, m_CmpRlsOtoOMtx[RulesOtoOMtxMap[mtx]], true, vrnt, val);
  Result := true
end;

//----------------------------------------------------------------------------//

function TMqmRes.AddOvlpRule(ArtType, WrkCtrProc: string; RuleRec: TOvlpRule; DetailRec: TOvlpRuleDet): boolean;
begin
  Assert(Assigned(m_OvlpRulesList));
  m_OvlpRulesList.AddOvplRule(ArtType, WrkCtrProc, RuleRec, DetailRec);
  Result := true
end;

//----------------------------------------------------------------------------//

function TMqmRes.GetOvlpRule(ArtType, WrkCtrProc: string; out isDefault: boolean): TMQMOvlpRule;
begin
  Assert(Assigned(m_OvlpRulesList));
  Result := m_OvlpRulesList.GetRule(ArtType, WrkCtrProc, isDefault)
end;

//----------------------------------------------------------------------------//

Function TMqmRes.CheckNbrOfComponents(res : TMqmRes; VisRes : TMqmVisibleRes; Id : TSchedID; NbrOfComponents : Integer; StartingDate : TDateTime) : boolean;
  var
   EndingDate : TDateTime;
  MaxUsedComponents, MaximumComponentsAllowed, NumberOfPossibleSubRsc,
   i : integer;
  moveChgInfo: TSQmoveChgInfo;
  SubRscNumbersChecked : TStringList;
//  res : TMqmRes;
//  VisRes : TMqmVisibleRes;
  CalNumber,IdDurationForOneComponent : DOuble;
  ActArea : TMqmActArea;
  Cal: TPGCALObj;
  EndDate : TDateTime;
  Setup : double;
begin
  p_sc.GetMoveChgInfo(id, moveChgInfo);

//  Res := TMQMRes(p_pl.FindResByCode(moveChgInfo.RscCode));
//  VisRes := TMqmVisibleRes(TMqmActArea(p_sc.GetExtLinkPtr(Id)).p_Father);

  NumberOfPossibleSubRsc := Res.VisResCount;

  MaximumComponentsAllowed := res.p_ResComp;

  if (NumberOfPossibleSubRsc = 1) then
  begin
    if NbrOfComponents > MaximumComponentsAllowed then
      Result := false
    else
      Result := true;
    Exit;
  end;
  p_sc.GetIdTimes(id, TMqmWrkCtr(res.p_WrkCtr).p_WrkCtrCode , res.p_ResCat.p_ResCatCode, res.p_ResCode, false, IdDurationForOneComponent, Setup, false);

  ActArea := TMqmActArea(VisRes.p_ActArea[0]);//TMqmActArea(p_sc.GetExtLinkPtr(Id));

  if not assigned(ActArea) then exit;
  Cal := ActArea.GetCalendar;
  if not assigned(cal) then exit;

  cal.OfsByWH((moveChgInfo.supMinReal + IdDurationForOneComponent / NbrOfComponents)/60, true, StartingDate, EndingDate, ActArea.m_CrossDownTmList);

  Result := false;

  SubRscNumbersChecked := TStringList.Create;
  SubRscNumbersChecked.Add(IntToStr(VisRes.p_SubCode));
  MaxUsedComponents := 0;
  FindComponentsOnTheNextSubRsc(res, StartingDate,EndingDate,NumberOfPossibleSubRsc,1,0,SubRscNumbersChecked,MaxUsedComponents);
  SubRscNumbersChecked.Free;

  if (NbrOfComponents + MaxUsedComponents) <= MaximumComponentsAllowed then
    Result := true;

end;

//----------------------------------------------------------------------------//

Procedure TMqmRes.FindComponentsOnTheNextSubRsc(res : TMqmRes;StartingDate, EndingDate : TDateTime; NumberOfPossibleSubRsc, SubRscCount,
 Components : Integer;var SubRscNumbersChecked : TStringList; var MaxUsedComponents : integer);

  type SubRes = record
     StartDate : TdateTime;
     EndDate : Tdatetime;
     NumberOfUsedComponents : Integer;
  end;
  TSubRes = ^SubRes;
var
 ComponentsTemp, q, w, i : integer;
 ListOfDatesToCheck  : TList;
 //CurrentStartDate : TDatetime;
 VisRes : TMqmVisibleRes;
 moveChgInfo: TSQmoveChgInfo;
 ActArea : TMqmActArea;
 id : TSChedId;
 DatesInfo: TSQDatesInfo;
 SubRs : TSubRes;
 IdFound : Boolean;
begin

  ListOfDatesToCheck := TList.Create;
  //CurrentStartDate := StartingDate;

  for i := 0 to res.p_VisResList.count - 1 do
  begin
    VisRes := TMqmVisibleRes(res.p_VisResList[i]);

    if VisRes.p_SubCode >= 1 then
    begin
      if SubRscNumbersChecked.IndexOf(IntToStr(VisRes.p_SubCode)) = -1 then
      begin
        SubRscNumbersChecked.Add(IntToStr(VisRes.p_SubCode));
        Inc(SubRscCount);
        break;
      end;
    end;
  end;

  ActArea := TMqmActArea(VisRes.p_ActArea[0]);
  IdFound := False;

  if ActArea.SchedObjsCount > 0 then
  begin
    for w := 0 to ActArea.p_ObjCount - 1 do
    begin
      id := ActArea.GetSchedObj(w);
      p_sc.GetDatesInfo(id, DatesInfo);

      if DatesInfo.endDate <= StartingDate then
        continue;

      if DatesInfo.StartDate >= EndingDate then
        break;

      IdFound := True;
      p_sc.GetMoveChgInfo(id, moveChgInfo);

      If StartingDate < DatesInfo.StartDate then
      begin
        New(SubRs);
        SubRs.StartDate := StartingDate;
        SubRs.EndDate := DatesInfo.StartDate;
        SubRs.NumberOfUsedComponents := 0;
        ListOfDatesToCheck.Add(SubRs);
      end;

      If DatesInfo.endDate > EndingDate then
      begin
        New(SubRs);
        SubRs.StartDate := DatesInfo.StartDate;
        SubRs.EndDate := EndingDate;
        SubRs.NumberOfUsedComponents := moveChgInfo.numOfRscComp;
        ListOfDatesToCheck.Add(SubRs);
      end else
      begin
        New(SubRs);
        SubRs.StartDate := DatesInfo.StartDate;
        SubRs.EndDate := DatesInfo.endDate;
        SubRs.NumberOfUsedComponents := moveChgInfo.numOfRscComp;
        ListOfDatesToCheck.Add(SubRs);
      end;
    end;
  end;

  if not IdFound then
  begin
    New(SubRs);
    SubRs.StartDate := StartingDate;
    SubRs.EndDate := EndingDate;
    SubRs.NumberOfUsedComponents := 0;
    ListOfDatesToCheck.Add(SubRs);
  end;

  for i := 0 to ListOfDatesToCheck.Count -1 do
  begin
    ComponentsTemp := Components + TSubRes(ListOfDatesToCheck[i]).NumberOfUsedComponents;
    if SubRscCount = NumberOfPossibleSubRsc then
    begin
      if ComponentsTemp > MaxUsedComponents then
        MaxUsedComponents := ComponentsTemp;
      continue;
    end;

    FindComponentsOnTheNextSubRsc(res, TSubRes(ListOfDatesToCheck[i]).StartDate, TSubRes(ListOfDatesToCheck[i]).EndDate
            ,NumberOfPossibleSubRsc, SubRscCount, ComponentsTemp, SubRscNumbersChecked, MaxUsedComponents);
  end;

  for I := 0 to ListOfDatesToCheck.Count - 1 do
    dispose(TSubRes(ListOfDatesToCheck[i]));

  ListOfDatesToCheck.free;
  SubRscNumbersChecked.Delete(SubRscNumbersChecked.Count-1);
end;

//----------------------------------------------------------------------------//

function TMqmRes.GetComponentsUsed(RefObjID: TSchedID; StartDate, EndDate: TDateTime): integer;
var
  i : integer;
  VisRes: TMqmVisibleRes;
begin
  // Retrieve total components used inside a choosen period
  Result := 0;
  for i := 0 to m_VisRes.Count -1 do
  begin
    VisRes := GetVisRes(i);
    Result := Result + VisRes.GetComponentsUsed(RefObjID, StartDate, EndDate);
  end;
end;

//----------------------------------------------------------------------------//

function TMqmRes.CheckDatesOnOneBatchMachineByGroupCode(Id : TSchedId; planInfo : TSQplanInfo; var AvailbleDateTime : TDateTime) : boolean;
var
  MqmVisibleRes : TMqmVisibleRes;
  ActArea       : TMqmActArea;
  SchedList     : TMSchedList;
  I             : integer;
  info          : TSQPlanInfo;
begin
  Result := false;
  if Assigned(P_rscOfBatchMachinSameGrpCode) then
  begin
    SchedList := TMSchedList.Create(self);
    MqmVisibleRes := TMqmRes(P_rscOfBatchMachinSameGrpCode).p_VisRes[0];
    actArea := TMqmActArea(MqmVisibleRes.p_ActArea[0]);
    actArea.FindSchedInSpots(planInfo.startDate, planInfo.endDate , SchedList);
    if SchedList.GetLinkCount > 0 then
    begin
      for I := 0 to SchedList.GetLinkCount - 1 do
      begin
        if (m_GROUP_TYPE_FOR_ONE_BATCH_MACHINE = process_typ) and (P_rscOfBatchMachinSameGrpCode.p_GROUP_TYPE_FOR_ONE_BATCH_MACHINE = process_typ) then
        begin
          if CheckUsedAllMachinePartsProcessOnBatchMachinSameGrpCode(Id, SchedList.GetLink(I)) then
            Result := true;
        end
        else if (m_GROUP_TYPE_FOR_ONE_BATCH_MACHINE = Qty_typ) and (P_rscOfBatchMachinSameGrpCode.p_GROUP_TYPE_FOR_ONE_BATCH_MACHINE = Qty_typ) then
        begin
          if (P_rscOfBatchMachinSameGrpCode.CheckMaxQtyOnBatchMachinSameGrpCode(SchedList.GetLink(I)) or
             CheckMaxQtyOnBatchMachinSameGrpCode(Id)) then
          begin
            Result := true;
          end;
        end;
        if Result then
        begin
          p_sc.GetPlanInfo(SchedList.GetLink(I), info);
          AvailbleDateTime := info.endDate;
          break
        end;
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

function TMqmRes.GetAdditionalOptimumMaxMultiplierProp(Id : TSchedId) : double;
var
  PropId : TPropId;
  multiplierProp : variant;
  NbrOfSons, I : integer;
  IdSon  : TSchedId;
  TotJobQty, TotalMultProp, QtyConvert, MultQty : double;
begin
  Result := 1;
  if m_PropCodeOptimumMaxMultiplier <> '' then
  begin
    PropId := GetIdFromCode(m_PropCodeOptimumMaxMultiplier);
    if p_sc.IsGroup(Id) then
    begin
      TotalMultProp := 0;
      TotJobQty := 0;
      NbrOfSons := p_sc.GetGrpNumSons(Id);
      for I := 0 to NbrOfSons - 1 do
      begin
        IdSon := p_sc.GetGrpSon(Id, I);
        p_sc.GetPropVal(IdSon,PropId,multiplierProp);
        p_sc.QtyInUM(IdSon ,p_BchUM , QtyConvert, MultQty);
        TotJobQty :=  TotJobQty + QtyConvert;
        TotalMultProp :=  TotalMultProp + (QtyConvert*multiplierProp);
      end;
      multiplierProp := TotalMultProp /  TotJobQty;
    end
    else
      p_sc.GetPropVal(Id,PropId,multiplierProp);
    Result := Double(multiplierProp);
    if Result = 0 then
       Result := 1;
  end;
end;

//----------------------------------------------------------------------------//

function TMqmRes.GetAdditionalMinMultiplierProp(Id : TSchedId) : double;
var
  PropId : TPropId;
  multiplierProp : variant;
  NbrOfSons, I : integer;
  IdSon  : TSchedId;
  TotJobQty, TotalMultProp, QtyConvert, MultQty : double;
begin
  Result := 1;
  if m_PropCodeMinMultiplier <> '' then
  begin
    PropId := GetIdFromCode(m_PropCodeMinMultiplier);
    if p_sc.IsGroup(Id) then
    begin
      TotalMultProp := 0;
      TotJobQty := 0;
      NbrOfSons := p_sc.GetGrpNumSons(Id);
      for I := 0 to NbrOfSons - 1 do
      begin
        IdSon := p_sc.GetGrpSon(Id, I);
        p_sc.GetPropVal(IdSon,PropId,multiplierProp);
        p_sc.QtyInUM(IdSon ,p_BchUM , QtyConvert, MultQty);
        TotJobQty :=  TotJobQty + QtyConvert;
        TotalMultProp :=  TotalMultProp + (QtyConvert*multiplierProp);
      end;
      multiplierProp := TotalMultProp /  TotJobQty;
    end
    else
      p_sc.GetPropVal(Id,PropId,multiplierProp);
    Result := Double(multiplierProp);
    if Result = 0 then
       Result := 1;
  end;
end;

//----------------------------------------------------------------------------//

procedure TMqmRes.RefreshDwTimeLinked(CapResMaster: TMQMDurObj; isEnd, isNewDwTime: boolean);
var
  i : integer;
  VisResTarget, VisResSource: TMqmVisibleRes;
  RecDwTimeLinked: PTDwTimeLinked;
begin
  Assert(Assigned(CapResMaster));

  if not Assigned(m_DwTimeLinked) then
    m_DwTimeLinked := TList.Create;

  RecDwTimeLinked := GetRecDwTmLinked(CapResMaster);
  if not Assigned(RecDwTimeLinked) then
  begin
    New(RecDwTimeLinked);
    RecDwTimeLinked.LstDwTime := TList.Create;
    RecDwTimeLinked.LstDwTime.Add(CapResMaster);
    m_DwTimeLinked.Add(RecDwTimeLinked);
  end;

  CapResMaster := TMQMCapRes(CapResMaster);
  for i := 0 to m_VisRes.Count -1 do
  begin
    VisResTarget := GetVisRes(i);
    VisResSource := TMQMVisibleRes(TMQMActArea(CapResMaster.p_Father).p_Father);
    if VisResTarget.p_SubCode = VisResSource.p_SubCode then continue;
    VisResTarget.RefreshDwTimeLinked(CapResMaster, isEnd, RecDwTimeLinked);
  end;
end;

//----------------------------------------------------------------------------//

function TMqmRes.GetRecDwTmLinked(CapResMaster: TMqmDurObj): PTDwTimeLinked;
var
  i, j : integer;
  CapRes: TMQMDurObj;
begin
  Result := nil;
  if not Assigned(m_DwTimeLinked) or (m_DwTimeLinked.Count = 0) then exit;

  for i := 0 to m_DwTimeLinked.Count -1 do
  begin
    Result := m_DwTimeLinked[i];
    for j := 0 to Result.LstDwTime.Count -1 do
    begin
      CapRes := TMQMDurObj(Result.LstDwTime.Items[j]);
      if Assigned(CapRes) then
      begin
        if CapResMaster = CapRes then exit;
        if (CapResMaster.p_start = CapRes.p_start) and
           (CapResMaster.p_end = CapRes.p_end) then exit;
      end;
    end;
  end;

  Result := nil;
end;

//----------------------------------------------------------------------------//

procedure TMqmRes.AddDwTimeLinked(CapResMaster: TMqmDurObj; isNewDwTime: boolean);
var
  RecDwTimeLinked: PTDwTimeLinked;
begin
  Assert(Assigned(CapResMaster));

  if not Assigned(m_DwTimeLinked) then
    m_DwTimeLinked := TList.Create;

  RecDwTimeLinked := GetRecDwTmLinked(CapResMaster);
  if not Assigned(RecDwTimeLinked) then
  begin
    New(RecDwTimeLinked);
    m_DwTimeLinked.Add(RecDwTimeLinked);
    RecDwTimeLinked.LstDwTime := TList.Create;
  end;

  if RecDwTimeLinked.LstDwTime.IndexOf(CapResMaster) = -1 then
    RecDwTimeLinked.LstDwTime.Add(CapResMaster);
end;

//----------------------------------------------------------------------------//

procedure TMqmRes.RemoveDwTimeLinked(CapResMaster: TMqmDurObj; OpStack: pointer);
var
  RecDwTimeLinked: PTDwTimeLinked;
  i : integer;
  CapRes : TMQMCapRes;
  act : TMQMActArea;
begin
  RecDwTimeLinked := GetRecDwTmLinked(CapResMaster);
  Assert(Assigned(RecDwTimeLinked));

  for i := RecDwTimeLinked.LstDwTime.Count -1 downto 0 do
  begin
    CapRes := TMQMCapRes(RecDwTimeLinked.LstDwTime.Items[i]);
    if CapRes <> CapResMaster then
    begin
      act := TMQMActArea(CapRes.p_Father);
      TOpStack(opStack).DelePlanObjFromApa(TMqmDurObj(CapRes), act);
      act.ReorganizeAllOcc(true);
      RecDwTimeLinked.LstDwTime.Delete(i);
    end;
  end;

  RecDwTimeLinked.LstDwTime.Free;
  m_DwTimeLinked.Remove(RecDwTimeLinked);
end;

//----------------------------------------------------------------------------//

function TMqmRes.GetPropertyInstanceCounterValList(Id : TSchedId) : TStringList;
var
  prop : TProperties;
  I : Integer;
  JobId : TSchedId;
begin
  Result := nil;
  if p_sc.IsGroup(Id) then
    JobId := p_sc.GetGrpSon(Id, 0)
  else
    JobId := Id;
  prop := p_sc.GetProperties(JobId,nil);
  if prop.P_PropCountInstanceCounter = 0 then exit;
  Result := TStringList.Create;
  for I := 0 to prop.P_PropCountInstanceCounter - 1 do
    result.Add(IntToStr(prop.GetPropertyInstanceCounterVal(I)));
end;

//----------------------------------------------------------------------------//

procedure TMqmRes.SetPropertyInstanceCounterValList(Id : TSchedId; list : TStringList);
var
  prop, PropInGrp : TProperties;
  I, J : Integer;
  JobId, IdInGrp : TSchedId;
  PlaceInMainList : Integer;
  InstanceCounterProp : string;
begin
  prop := p_sc.GetProperties(Id,nil);
  if prop.P_PropCountInstanceCounter = 0 then exit;
  if p_sc.IsGroup(Id) then
    JobId := p_sc.GetGrpSon(Id, 0)
  else
    JobId := Id;
  prop := p_sc.GetProperties(JobId,nil);
  for I := 0 to prop.P_PropCountInstanceCounter - 1 do
  begin
    prop.GetPropertyInstanceCounter(I , InstanceCounterProp, PlaceInMainList);
    prop.SetPropertyInstanceCounterVal(PlaceInMainList,StrToInt(list.Strings[I]));
    if p_sc.IsGroup(Id) then
    begin
      for J := 1 to p_sc.GetGrpNumSons(id) - 1 do
      begin
        IdInGrp := p_sc.GetGrpSon(id, J);
        PropInGrp := p_sc.GetProperties(IdInGrp,nil);
        PlaceInMainList := PropInGrp.SearchForPropertyInstanceCounterVal(InstanceCounterProp);
        if PlaceInMainList > -1 then
           PropInGrp.SetPropertyInstanceCounterVal(PlaceInMainList, StrToInt(list.Strings[I]));
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

function TMqmRes.UpdateInstanceCounterProperty(Id, PrevId : TSchedId) : boolean;
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
  if p_sc.IsGroup(Id) then
    JobId := p_sc.GetGrpSon(Id, 0)
  else
    JobId := Id;

  if PrevId <> CSchedIDnull then
  begin
    if p_sc.IsGroup(PrevId) then
      PrevJobId := p_sc.GetGrpSon(PrevId, 0)
    else
      PrevJobId := PrevId;
  end;

  prop := p_sc.GetProperties(JobId,nil);
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

function TMqmRes.HasActiveInstanceCounterProperty(Id : TSchedId; PropCode : string) : boolean;
var
  prop : TProperties;
  JobId : TSchedId;
begin
  Result := false;
  if p_sc.IsGroup(Id) then
    JobId := p_sc.GetGrpSon(Id, 0)
  else
    JobId := Id;
  prop := p_sc.GetProperties(JobId,nil);
  if prop.P_PropCountInstanceCounter = 0 then exit;

  if prop.SearchForPropertyInstanceCounterVal(PropCode) > -1 then
    Result := true;
end;

//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
//    TMqmVisibleRes  --------------------------------------------------------//
//----------------------------------------------------------------------------//

constructor TMqmVisibleRes.CreateVisRes(SubCode: integer);
var
  actArea: TMqmActArea;
begin
  inherited Create;
  m_SubCode    := SubCode;
  m_ActAreas   := TDurList.Create(self);
  //m_SubResExpanded := true;
  m_EfficiencyOnLevel := EffLvl_Non;

//  if SubCode = -1 then

  actArea := TMqmActArea.CreateActArea;
  actArea.p_start := DBAppGlobals.StDateForPlan;
  actArea.p_end   := DBAppGlobals.EndDateForPlan;
  AddActArea(ActArea)

end;

//----------------------------------------------------------------------------//

destructor TMqmVisibleRes.Destroy;
var
  i: integer;
begin
  for i := 0 to m_ActAreas.Count-1 do
    TMqmActArea(m_ActAreas[i]).Free;
  m_ActAreas.Free;
  inherited Destroy
end;

//----------------------------------------------------------------------------//

function TMqmVisibleRes.GetDescr: string;
var
  res: TMqmRes;
begin
  res := TMqmRes(p_Father);
  Result := {_('Resource') + ' ' + }res.p_ResCode;
  if m_SubCode <> -1 then
  Result := Result {+ _('SubResource')} + ' ' + IntToStr(m_SubCode);
end;

//----------------------------------------------------------------------------//

function TMqmVisibleRes.GetFirstDateInDynamicPlan(var DateTime : TDateTime) : boolean;
var
  I : Integer;
  ActArea : TMqmActArea;
  FirstSched : TDateTime;
begin
  DateTime := 0;
  FirstSched := 0;
  Result := false;
  for i := 0 to m_ActAreas.Count - 1 do
  begin
    ActArea := TMqmActArea(m_ActAreas[i]);
    if ActArea.GetFirstDateInDynamic(DateTime) then
      Result := true
    else
      Result := false;
    if (FirstSched = 0) then
      FirstSched := DateTime
    else if (DateTime < FirstSched) and (DateTime <> 0) then
      FirstSched := DateTime
  end;
end;

//----------------------------------------------------------------------------//

function TMqmVisibleRes.GetFirstJobIdInDynamicPlan(var JobId : TSchedId) : boolean;
var
  I : Integer;
  ActArea : TMqmActArea;
//  FirstSched : TDateTime;
begin
  Result := false;
  for i := 0 to m_ActAreas.Count - 1 do
  begin
    ActArea := TMqmActArea(m_ActAreas[i]);
    if ActArea.GetFirstJobIdInDynamic(JobId) then
      Result := true
  end;
end;

//----------------------------------------------------------------------------//

function TMqmVisibleRes.GetCalendar: TPGCALObj;
var
  ResDesc : string;
begin
  if not Assigned(m_cal) then
  begin

    if CheckCalenderAndEfficiencyOnResourceLevelBoth(m_CalCode) then
    begin
      m_EfficiencyOnLevel := Eff_And_Cal_Both_Lvl_Res;

      ResDesc := GetDescr;
     // if not p_isSubRes then  // should be the oposite;
     //   ResDesc := TMqmRes(Self.p_Father).p_ResSDesc;

      m_cal := ObjPGCAL_ByCalAndResKey(m_CalCode, ResDesc, TPGCALObjMqm);
      m_CalReal := m_cal;
      m_CalCodeReal := m_CalCode + GetDescr;
     // m_CalCode := m_CalCode;//GetDescr
    end
    else if CheckCalenderForEfficiencyOnWorkCenterLevel(m_CalCode) then
    begin
      m_EfficiencyOnLevel := EffLvl_Wc;
      m_cal := ObjPGCAL_ByResKey(m_CalCode, GetDescr, TPGCALObjMqm);
      m_CalReal := ObjPGCAL_ByKey(m_CalCode, TPGCALObjMqm);
      m_CalCodeReal := m_CalCode;
      m_CalCode := GetDescr
    end
    else if CheckCalenderForEfficiencyOnResourceLevel(m_CalCode) then
    begin
      m_EfficiencyOnLevel := EffLvl_Res;
      m_cal := ObjPGCAL_ByResKey(m_CalCode, GetDescr, TPGCALObjMqm);
      m_CalReal := ObjPGCAL_ByKey(m_CalCode, TPGCALObjMqm);
      m_CalCodeReal := m_CalCode;
      m_CalCode := GetDescr
    end
    else
      m_cal := ObjPGCAL_ByKey(m_CalCode, TPGCALObjMqm);
  end;
  Result := m_cal
end;

//----------------------------------------------------------------------------//

function TMqmVisibleRes.ActAreasCount: integer;
begin
  Assert(Assigned(m_ActAreas));
  Result := m_ActAreas.Count
end;

//----------------------------------------------------------------------------//

function TMqmVisibleRes.GetActArea(i: integer): TMqmPlanObj;
begin
  Assert(Assigned(m_ActAreas));
  Result := m_ActAreas[i]
end;

//----------------------------------------------------------------------------//

function  TMqmVisibleRes.GetIsSubRes: boolean;
begin
  Result := (m_SubCode = -1)
end;

//----------------------------------------------------------------------------//

procedure TMqmVisibleRes.StartGenerator(lt, rt: TDateTime);
begin
  m_lt := lt;
  m_rt := rt;
  SortActAreas;

  m_cnt := m_ActAreas.FindCovering(m_lt, m_rt, nil);
  if m_cnt <> -1 then m_onActiveArea := false
end;

//----------------------------------------------------------------------------//

function TMqmVisibleRes.Next(parms: PTRowParms; var dwFnc: TDurShDraw; var Toadd : boolean): boolean;
var
  ActArea: TMqmActArea;
begin
  Result := false;
  if m_cnt = -1 then exit;

  if not m_onActiveArea then
  begin

    // draw the active area
    ActArea := TMqmActArea(m_ActAreas[m_cnt]);
    if ActArea.p_start > m_rt then exit;

    Result := true;

    SetDrawPos(parms.top, parms.hgt, st_ActArea);
    dwFnc := @DrawActArea;     // draw function

    parms.lev       := 2;                // level priority
    parms.st        := ActArea.p_start;  // start time of the object
    parms.et        := ActArea.p_end;    // end time of the object
    parms.it        := 0;                // setup end time
    parms.mt        := 0;                // setup without material start time
    parms.compatVal := CompValNotDef;    // compatibility value
    parms.isTmp     := false;            // not a temporary object
    parms.suppVal1  := -1;
    parms.suppVal2  := -1;
//    parms.errVal    := CSE_NoError;
    parms.errSet    := [];
    parms.objPtr    := ActArea;          // reference object
    parms.isContObj := false;
    parms.NoMaterialList := nil;   // fp - tmp0408
    parms.NoAddResList   := nil;   // fp - tmp0408
    parms.NoPrevStepList := nil;
    Toadd := true;
    m_onActiveArea := true;
    ActArea.StartGenerator(ActArea.p_start, ActArea.p_end)
  end
  else
  begin
    ActArea := TMqmActArea(m_ActAreas[m_cnt]);

    if ActArea.Next(parms, dwFnc, ToAdd) then
      Result := true
    else
    begin
      m_onActiveArea := false;
      Inc(m_cnt);
      if m_cnt = p_ActAreasCount then m_cnt := -1
    end
  end
end;

//----------------------------------------------------------------------------//

procedure TMqmVisibleRes.AddActArea(ActArea: TMqmDurObj);
begin
  Assert(Assigned(m_ActAreas));

  m_ActAreas.AddTail(actArea);
  ActArea.p_Father := self;
  ActArea.m_plan := m_plan;
//  TMqmActArea(ActArea).GetCalendar
end;

//----------------------------------------------------------------------------//

function TMqmVisibleRes.JobsScheduled : boolean;
var
  I : Integer;
  ActArea : TMqmActArea;
begin
  Result := false;
  for I := 0 to m_ActAreas.count - 1 do
  begin
    ActArea := TMqmActArea(m_ActAreas[I]);
    if (ActArea.SchedObjsCount > 0) then
    begin
      Result := true;
      Exit
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TMqmVisibleRes.GetColors(brush: TBrush; pen: TPen; font: TFont);
var
  res: TMqmRes;
  compId : TSchedId;
begin
  res := TMqmRes(p_father);
  compId := p_pl.GetCompatModeInPlanId;
      if (compId <> CSchedIdNull) and p_sc.IsProdSchedMaterial(compId) then
         compId := CSchedIdNull;


  if (p_pl.GetCompatModeInPlanCapRes = nil) then
  begin
    if (res.m_plan.GetCompatModeInPlanId = CSchedIdNull)
    or (not Res.p_occGoodWkc[p_pl.GetCompatModeInPlanId]) or (not res.p_occHasTimings)  then
      GetResNormalColors(res.m_ProcessType, res.IsMultiRes,
                         TMqmWrkCtr(res.p_father).p_ReadOnly, brush, pen, font)
    else

      if (compId <> CSchedIdNull) and not p_sc.IsProdSchedMaterial(compId) then
      begin
        if (res.p_occGoodMinQty[p_pl.GetCompatModeInPlanId]
        and res.p_occGoodMaxQty[p_pl.GetCompatModeInPlanId])
        and res.p_occGoodDepend[p_pl.GetCompatModeInPlanId] then
          GetResCompatColor(res.p_occCompatVal, brush, pen, font)
        else
          GetResCompatColor(99, brush, pen, font);
      end
        else GetResCompatColor(res.p_occCompatVal, brush, pen, font);


  end else
  begin
    if TMqmWrkCtr(res.p_father).p_ReadOnly then
    begin
      GetResNormalColors(res.m_ProcessType, res.IsMultiRes,
                         TMqmWrkCtr(res.p_father).p_ReadOnly, brush, pen, font)
    end else
    begin
      if (res.p_occCompatVal >= 0) then
        GetResCompatColor(res.p_occCompatVal, brush, pen, font)
      else
        GetResCompatColor(99, brush, pen, font);
    end
  end;

  if p_pl.GetCompatModeInBinVisRes = self then
  begin
    pen.Width := 4;
    pen.Color := ClBlack;
  end
  else
    pen.Width := 1
end;

//----------------------------------------------------------------------------//

function TMqmVisibleRes.FindActForDate(date: TDateTime): TMqmPlanObj;
var
  i: integer;
  ActArea: TMqmActArea;
begin
  Result := nil;
  if not Assigned(m_ActAreas) then exit;
  m_ActAreas.SortList;
  for i := 0 to m_ActAreas.Count-1 do
  begin
    ActArea := TMqmActArea(m_ActAreas[i]);
    if (date >= ActArea.p_start)
    and (date <= ActArea.p_end) then
    begin
      Result := ActArea;
      break
    end
  end
end;

//----------------------------------------------------------------------------//

procedure TMqmVisibleRes.FindActInSpot(startTm, endTm: TDateTime; ObjList: TList);
var
  ActArea: TMqmActArea;
  i:  integer;
begin
  if not Assigned(m_ActAreas) then exit;
  m_ActAreas.SortList;

  for i := 0 to m_ActAreas.Count -1 do
  begin
    ActArea := TMqmActArea(m_ActAreas[i]);
    if (ActArea.p_end > startTm) and (ActArea.p_start < endTm) then
      ObjList.Add(ActArea);
  end
end;

//----------------------------------------------------------------------------//

procedure TMqmVisibleRes.SortActAreas;
begin
  if Assigned(m_ActAreas) then m_ActAreas.SortList
end;

//----------------------------------------------------------------------------//

procedure TMqmVisibleRes.ClearCalendar;
begin
  m_Cal := nil;
end;

//----------------------------------------------------------------------------//

function TMqmVisibleRes.GetComponentsUsed(RefObjID: TSchedID;
                                StartDate, EndDate: TDateTime): integer;
var
  i, j : integer;
  ValidActArea: TList;
  ObjToCheck: TMSChedList;
  ActArea: TMQMActArea;
  numOfRscComp : integer;
begin
  // Get max components number used in period choosed
  Result := 0;

  ValidActArea := TList.Create;
  ObjToCheck := TMSchedList.Create(self);
  FindActInSpot(StartDate, EndDate, ValidActArea);

  for i := 0 to ValidActArea.Count -1 do
  begin
    ActArea := TMQMActArea(ValidActArea[i]);
    ActArea.SortSchedObjs;
    ActArea.FindSchedInSpots(StartDate, EndDate, ObjToCheck);
    for j := 0 to ObjToCheck.GetLinkCount -1 do
    begin
      if RefObjID = ObjToCheck.GetLink(j) then continue;
      numOfRscComp := p_sc.GetJobComponents(ObjToCheck.GetLink(j), false);
      if numOfRscComp > Result then
        Result := numOfRscComp;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TMqmVisibleRes.RefreshDwTimeLinked(CapResMaster: TMQMDurObj; isEnd: boolean;
                                       RecDwTmLinked: PTDwTimeLinked);
var
  i : integer;
  ActArea: TMQMActArea;
begin
  Assert(Assigned(RecDwTmLinked));

  for i := 0 to m_ActAreas.Count -1 do
  begin
    ActArea := TMQMActArea(m_ActAreas[i]);
    ActArea.RefreshDwTime(CapResMaster, isEnd, RecDwTmLinked);
  end;
end;

//----------------------------------------------------------------------------//
end.


