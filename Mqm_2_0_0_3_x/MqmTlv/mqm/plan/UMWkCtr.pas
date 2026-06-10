unit UMWkCtr;

interface

uses
  classes,
//  UMPlan,
  UMCompat,
  UMCompatSrv,
  UMActArea,
//  UMSchedList,
  UMSchedContFunc,
  UMCompatRules,
  UMPlanObj;

type
  CEntityType    = (ety_category, ety_property);
  CUseMachineParts = (Mp_Non, Mp_All, Mp_RearPart, Mp_FrontPart);
  CWarpLevl = (Wc_No, Wc_BaseLvl, Wc_BaseAndSecondLvl);

  CPriorRelation = (pre_No,          // No priorities
                    pre_PrevDspPri,  // Wait until previous dispos priority steps will be scheduled
                    pre_PrevDspStp,  // Wait until previous dispos (All) steps to be scheduled
                    pre_NextDspPri,  // Wait until next dispos priority steps will be scheduled
                    pre_NextDspStp); // Wait until next dispos (All) steps to be scheduled

  CDependRelation = (dre_No,          // No dependencies
                    dre_PrevStep,     // Previous step
                    dre_PrevConnReq,  // revious connected request
                    dre_NextStep,     // Next step
                    dre_NextConnReq); // Next connected request

  CSetupHandleTyp = (sht_No,
                    sht_Yes,
                    sht_Cat,  // Category
                    sht_Res); // Resource

  TWkcProcList = class;

  TMqmWrkCtr = class(TMqmPlanObj)
    constructor CreateWrkCtr(Code: string);
    destructor  Destroy; override;
  private
    m_ReadOnly: boolean;
    m_Visible : boolean;
    m_resList: TList;
    m_ProdLineList: TList;
   // m_WkcDailyCapacityList : TList;
    m_WkcByEntityDailyCapacityList : TList;
    m_code: string;
    m_McmSeq : Integer;
    m_PlantCode : string;
    m_WcMain : string;
    m_WcGrp  : string;
    m_LDesc : string;
    m_SDesc : string;
    m_wkcProc: TWkcProcList;  // to handle process and alternatives
    m_alternativeWcList : TStringList;
    m_WcPlantsList      : TStringList;
    m_UseMachineParts : boolean;
    m_WarpLevl : CWarpLevl;
    m_Division : string;
    m_IgnoreProgress : boolean;
    function  ResCount: integer;
    function  GetRes(i: integer): TMqmPlanObj;
    function  ProdLinesCount: integer;
    function  GetProdLine(i: integer): TMqmPlanObj;
    function  GetProcess(i: integer): string;
    function  ProcessCount : Integer;
    function  GetWrctrLevelPropListCount : Integer;
    function  GetWkcProcList : TWkcProcList;

  public
    m_WkcDailyCapacityList : TList;
    function  GetDescr: string; override;
    procedure AddResource(res: TMqmPlanObj; Category : string; CategoryDesc : string);
    procedure AddAltWkcToList(altWkc: TMqmWrkCtr);
    procedure AddCodeToWkcCapacityEntity(Code : string; Desc, PropCode : string; EntityType : integer);
    function  CheckCodeInWkcCapacityEntity(Code : string) : boolean;
    procedure AddProdLine(ProdLine: TMqmPlanObj);
    procedure AddProcces(rec: Pointer);
    function  GetUseAllMachinePartsByProcess(proc: string) : CUseMachineParts;
    function  GetProcDesc(proc: string) : string;
    procedure AddAltWkc(proc: string; altWkc: TMqmWrkCtr; altProc: string);
    function  GetAltProcForAltWrkCtr(WrkCtrProc: string; AltWkcCode : string; var AltProc: string): boolean;
    function  GetAltWrkCtrForAltProc(WrkCtrProc: string; AltProc : string; var AltWrkCtr: TMqmWrkCtr): boolean;
    function  IsAlternative(AltWrkCtrCode, AltWrkCtrProc: string): boolean;
    function  FindRsrcByCode(resCode: string): TMqmPlanObj;
    function  GetGroupType(proc: string) : CGroupingType;
    function  GetResOccupationType(proc: string) : CSResOccupation;
    function  GetAltWcList : TStringList;
    function  GetPlantsList : TStringList;
    procedure CleanWkcEntityDailyCapacityList;
    procedure CleanWkcDailyCapacityList;
    function  GetPropValuesFromWkcDailyCapacityList(PropCode : string; ListVal : TStringList) : boolean;
    procedure AddIdToWkcDailyCapacityList(Id : TSchedId; ActArea : TMqmActArea; var MinStartDate : TDateTime; var MaxEndDate : TDateTime; errSet : SetOfErrors; PropMultiQty : Double);
    procedure AddIdToWkcDailyCapacityEntityList(Code : string; Id : TSchedId; ActArea : TMqmActArea; var MinStartDate : TDateTime; var MaxEndDate : TDateTime; errSet : SetOfErrors; PropMultiQty : Double);
    procedure AddHoursAvailableToWkcCapacity(ActArea : TMqmActArea; MinStartDate : TDate; MaxEndDate : TDate);
    procedure AddHoursAvailableToWkcEntityCapacity(Code : string; ActArea : TMqmActArea; MinStartDate : TDate; MaxEndDate : TDate);
    function  FindOrAddDateInDailyCapList(date : TdateTime) : Pointer;
    function  FindOrAddDateInDailyEntityCapList(Code : string; date : TdateTime) : Pointer;
    function  GetHintDataForPrdDailyCap(stDate, edDate: TDateTime; var qty : double; var NumJobsLate : integer; var MaxDaysInLate : integer; var NumJobsMaterialProblem : Integer; var NumJobsAddresProblem : integer; var RealPerc : Double) : boolean;
    function  GetDataForPrdDailyCap(stDate, edDate: TDateTime; var Hours_Available : double; var Hours_used : double; var errSet : SetOfErrors) : boolean;
    function  GetDataForPrdDailyCategoryCap(Code : string; stDate, edDate: TDateTime; var Hours_Available_slot : double; var Hours_used_slot : double; var errSet : SetOfErrors) : boolean;
    function  GetDataForPrdDailyPropertyCap(PropCode : string; stDate, edDate: TDateTime; var Hours_Available_slot : double; var Hours_used_slot : double; var errSet : SetOfErrors) : boolean;
    function  GetEntityDailyCapacityList(Code : string) : TList;
    function  GetHintDataForPrdDailyPropertyCap(PropCode : string; stDate, edDate: TDateTime; var qty : double; var NumJobsLate : integer; var MaxDaysInLate : integer; var NumJobsMaterialProblem : Integer; var NumJobsAddresProblem : integer; var RealPerc : Double) : boolean;
    function  GetHintDataForPrdDailyCategoryCap(Code : string; stDate, edDate: TDateTime; var qty : double; var NumJobsLate : integer; var MaxDaysInLate : integer; var NumJobsMaterialProblem : Integer; var NumJobsAddresProblem : integer; var RealPerc : Double) : boolean;
    function  GetNumSonsEntityDailyCapacityList : integer;
    function  HasEntityDailyCapacityData : boolean;
    function  GetEntityDailyCapacity(I : integer) : string;
    function  GetEntityDescDailyCapacity(I : integer) : string;
    function  GetEntityPropDailyCapacity(I : integer) : string;
    property p_ReadOnly:               boolean      read m_ReadOnly      write m_ReadOnly;
    property P_Visible:                boolean      read m_Visible       write m_Visible;
    property p_WrkCtrCode:             string       read m_code;
    property p_MCMSeq:                 Integer      read m_McmSeq       write m_McmSeq;
    property p_WrkCtrLDesc:            string       read m_LDesc         write m_LDesc;
    property p_WrkCtrSDesc:            string       read m_SDesc         write m_SDesc;
    property p_PlantCode:              string       read m_PlantCode     write m_PlantCode;
    property p_WcMain:                 string       read m_WcMain        write m_WcMain;
    property P_WcGrp:                  string       read m_WcGrp         write m_WcGrp;
    property p_ResCount:               integer      read ResCount;
    property p_Res[i: integer]:        TMqmPlanObj  read GetRes;
    property p_ProdLinesCount:         integer      read ProdLinesCount;
    property p_ProdLine[i: integer]:   TMqmPlanObj  read GetProdLine;
    property P_GetProccesCount:        integer      read ProcessCount;
    property P_GetProcess[i: integer]: string       read GetProcess;
    property P_WkcProcList:            TWkcProcList read GetWkcProcList;
    property P_WrctrLevelPropList_Count: Integer    read GetWrctrLevelPropListCount;
    property p_numSons_EntityDailyCapacityList : integer read GetNumSonsEntityDailyCapacityList;
    property p_Sons_EntityDailyCapacityList[pos:integer] : string read GetEntityDailyCapacity;
    property p_Sons_EntityDescDailyCapacityList[pos:integer] : string read GetEntityDescDailyCapacity;
    property p_Sons_EntityPropDailyCapacityList[pos:integer] : string read GetEntityPropDailyCapacity;
    property P_UseMachineParts: boolean          read m_UseMachineParts write m_UseMachineParts;
    property P_alternativeWcList : TStringList read m_alternativeWcList;
    property P_WarpLevl : CWarpLevl            read m_WarpLevl write m_WarpLevl;
    property P_IgnoreProgress : boolean        read m_IgnoreProgress write m_IgnoreProgress;	
    property p_Division:              string       read m_Division     write m_Division;
  // compatibility handling section

  private

    m_propMtx:      array[1..3] of TOrigMatrix;
    m_rulesRtoOMtx: array[1..6] of TOrigMatrix;
    m_rulesOtoOMtx: array[1..6] of TOrigMatrix;
    m_WrctrLevelPropList : TList;

  public

    function AddWrctrLevelPropToList(pID: TPropID) : boolean;
    function GetPropIdInWrctrLevelList(pID: TPropID) : boolean;
    function GetValueForProperty(pID: TPropID; mtx: TCompatMatrix;
                                 proc, cat: string): TPropRes;
    function GetRuleRtoOfForProperty(pID: TPropID; mtx: TCompatMatrix;
                                     proc, prod, cat: string): TCompRules;
    function GetRuleOtoOfForProperty(pID: TPropID; mtx: TCompatMatrix;
                                     proc, prod, cat: string): TCompRules;

    function GetSetupParms(scObj, scObjPrec: TSchedID; var supRec: TSetupRec;
                           var compatVal: TCompatVal; var SameGroup : boolean): boolean;

    function AddProperty(code: string; var val: TPropResRec; ErrList: TStringList): boolean;
    function AddRtoOrule(code: string; var val: TRuleResRec; ErrList: TStringList): boolean;
    function AddOtoOrule(code: string; var val: TRuleResRec; ErrList: TStringList): boolean;

    procedure GetPropMtxs(lst: TList; upChain: boolean);
    function  GetRulesRtoOMtxs: TList;
    function  GetRulesOtoOMtxs: TList;

  end;

  TAltProcList = class
    constructor Create;
    destructor  Destroy; override;
  private
    m_list: TList;
    function  GetAltCount : integer;
    function  GetAltWc(I : integer) : TMqmWrkCtr;
    function  GetAltWcSDesc(I : integer) : string;
    function  GetAltProccess(I : integer) : string;
  public
    procedure AddItem(wc: TMqmWrkCtr; proc: string);
    function  GetProcForWrkCtr(WkcCode: string; var Proc: string): boolean;
    function  GetWrkCtrForProc(Proc: string; var WrkCtr: TMqmWrkCtr) : boolean;
    function  GetAltProcDesc(Proc: string) : string;

    property  p_GetAltCount: Integer                  read GetAltCount;
    property  p_GetAltWc[I: Integer]: TMqmWrkCtr      read GetAltWc;
    property  p_GetAltWcSDesc[I: Integer]: string     read GetAltWcSDesc;
    property  p_GetAltProccess[I: Integer]: string    read GetAltProccess;
  end;

  TWorkCnterProcessAllowed = record
    wc:   string;
    proc: string;
  end;
  PTWorkCnterProcessAllowed = ^TWorkCnterProcessAllowed;

  TAltProcRec = record
    wc:   TMqmWrkCtr;
    proc: string;
    ProcDesc: string;
  end;
  PTAltProcRec = ^TAltProcRec;

  TWkcDailyCapacityByEntity = record
    m_EntityType : CEntityType;
    m_Code : string;
    m_Desc : string;
    m_PropCode : string;
    m_WkcDailyCapacityList : TList;
  end;
  PTWkcDailyCapacityByEntity = ^TWkcDailyCapacityByEntity;

  TWkcPriority = record
    PriorInDispo:    boolean;         //Schedule priorities within a dispo
    PrioritySeq:     string;          //Sequence
    RelationType:    CPriorRelation;  //Schedule priorities relation with intermediate allocated dispos
    SetupHandleType: CSetupHandleTyp; //Setup code handled for work center process
  end;
  PTWkcPriority = ^TWkcPriority;

  TWkcDependency = record
    DependOn:         CDependRelation;
    NotAlwdWC:        string; //Not allowed to schedule on workcenter
    NotAlwdResCat:    string; //Not allowed to schedule on resource category
    NotAlwdRes:       string; //Not allowed to schedule on resource
    DepSchedOnWC:     string; //When dependent is scheduled on workcenter
    DepSchedOnResCat: string; //When dependent is scheduled on resource category
    DepSchedOnRes:    string; //When dependent is scheduled on resource
  end;
  PTWkcDependency = ^TWkcDependency;

  TWkcDepList = class
    constructor Create;
    destructor  Destroy; override;
  private
    m_list: TList;
  public
    procedure AddDep(DepRec: PTWkcDependency);
    function GetCount: integer;
    function GetDepRec(RecIndex: integer): PTWkcDependency;
  end;

  TWkcProcRec = record
    proc:    string;
    ProcDesc: string;
    GroupingType: CGroupingType;
    RecPriority: PTWkcPriority;
    AltProcList: TAltProcList;
    DependencyList: TWkcDepList;
    ResOccupation : CSResOccupation;
    UseAllMachineParts : CUseMachineParts;
  end;
  PTWkcProcRec = ^TWkcProcRec;

  TWkcProcList = class
    constructor Create;
    destructor  Destroy; override;
  private
    m_list: TList;
    function  GetAltProcListCount(proc: string) : Integer;
    function  GetProcCount: Integer;
    function  GetProcByName(Proc: string): PTWkcProcRec;
    function  GetProc(i: integer): PTWkcProcRec;
  public
    procedure AddProc(rec: PTWkcProcRec);
    function  GetProcDesc(proc: string) : string;
    function  GetAltProcList(proc: string; toAdd: boolean): TAltProcList;
    function  GetUseAllMachinePartsProcess(proc: string) : CUseMachineParts;
    function  IsIn(proc: string): boolean;
    function  GetGroupType(proc: string) : CGroupingType;
    function  GetResOccupationType(proc: string) : CSResOccupation;
    property p_ProcCount: Integer                           read GetProcCount;
    property p_Proc[i: integer]: PTWkcProcRec               read GetProc;
    property p_ProcByName[Proc: string]: PTWkcProcRec       read GetProcByName;
    property p_GetAltProcListCount[proc : string]: Integer  read GetAltProcListCount;
  end;

  // for changing manual w.centers
  AltWkcRec = record
    WorkCenter :    string;
    Process :       string;
    AltWorkCenter : string;
    AltWorkCenterDesc : string;
    AltProcess :    string;
    AltProcessDesc : string;
    WStation   :    string;
    ExistAltWcInWStation :  boolean;
  end;
  PAltWkcRec = ^AltWkcRec;

  WkcDailyCapacity = record
   errSet : SetOfErrors;
   DateStr : string;
   Date : Tdate;
   Hours_Available : double;
   Hours_Used      : double;
   Total_Hours_in_Used  : double;
   ListIds         : TList;
  end;
  PWkcDailyCapacity = ^WkcDailyCapacity;

  JobCapacity = record
   id : TschedId;
   JobHours : double;
   errSet : SetOfErrors;
   qty    : double;
   PropMultiQty : Double;
   UM : String;
   NeededComponents : double; // use for log info
   HoursUsedJobWithoutComponents : double;
  end;
  PJobCapacity = ^JobCapacity;

implementation

uses
  Dialogs,
  gnugettext,
  UMSchedCont,
  UMGlobal,
  Variants,
  UMObjCont,
  SysUtils,
  FMbin,
  Forms,
  UMPlan,
  UGbaseCal,
  UMRes;

const

  PropMtxMap: array[TCompatMatrix] of integer = (
        1,  // simple code
        2,  // code and process
       -1,  // code and product type
        3,  // code and resource category
       -1,  // code, product type and resource category
       -1   // code, product type and process
      );

  RulesRtoOMtxMap: array[TCompatMatrix] of integer = (
        1,  // simple code
        2,  // code and process
        3,  // code and product type
        4,  // code and resource category
        5,  // code, product type and resource category
        6   // code, product type and process
      );

  RulesOtoOMtxMap: array[TCompatMatrix] of integer = (
        1,  // simple code
        2,  // code and process
        3,  // code and product type
        4,  // code and resource category
        5,  // code, product type and resource category
        6   // code, product type and process
      );

//----------------------------------------------------------------------------//

constructor TMqmWrkCtr.CreateWrkCtr(Code: string);
var
  cmpM: TCompatMatrix;
begin
  inherited Create;
  m_code := code;
  m_wkcProc := TWkcProcList.Create;
  m_WrctrLevelPropList := TList.Create;
  m_WkcDailyCapacityList   := Tlist.Create;
  m_WkcByEntityDailyCapacityList := Tlist.Create;
//  m_resList := TList.Create;
//  m_ProdLineList := TList.Create

  // initialize compatibility matrixes

  for cmpM := Low(TCompatMatrix) to High(TCompatMatrix) do
  begin
    // for the resource properties
    if PropMtxMap[cmpM] <> -1 then m_propMtx[PropMtxMap[cmpM]] := nil;

    // for the R to O compatibility rules
    if RulesRtoOMtxMap[cmpM] <> -1 then m_rulesRtoOMtx[RulesRtoOMtxMap[cmpM]] := nil;

    // for the O to O compatibility rules
    if RulesOtoOMtxMap[cmpM] <> -1 then m_rulesOtoOMtx[RulesOtoOMtxMap[cmpM]] := nil
  end
end;

//----------------------------------------------------------------------------//

destructor TMqmWrkCtr.Destroy;
begin
  inherited Destroy;
  m_resList.Free;
  m_wkcProc.Free;
  m_WrctrLevelPropList.Free;
  m_ProdLineList.Free;
  CleanWkcDailyCapacityList;
  m_WkcDailyCapacityList.Free;
  CleanWkcEntityDailyCapacityList;
  m_WkcByEntityDailyCapacityList.Free;
  if Assigned(m_alternativeWcList) then
    m_alternativeWcList.Free;
  if Assigned(m_WcPlantsList) then
    m_WcPlantsList.Free;
  if assigned(m_propMtx[1]) then
    TOrigMatrix(m_propMtx[1]).free;
  m_propMtx[1] := nil;

  if assigned(m_propMtx[2]) then
    TOrigMatrix(m_propMtx[2]).free;
  m_propMtx[2] := nil;

  if assigned(m_propMtx[3]) then
    TOrigMatrix(m_propMtx[3]).free;
  m_propMtx[3] := nil;

  if assigned(m_rulesRtoOMtx[1]) then
    TOrigMatrix(m_rulesRtoOMtx[1]).free;
  m_rulesRtoOMtx[1] := nil;

  if assigned(m_rulesRtoOMtx[2]) then
    TOrigMatrix(m_rulesRtoOMtx[2]).free;
  m_rulesRtoOMtx[2] := nil;

  if assigned(m_rulesRtoOMtx[3]) then
    TOrigMatrix(m_rulesRtoOMtx[3]).free;
  m_rulesRtoOMtx[3] := nil;

  if assigned(m_rulesRtoOMtx[4]) then
    TOrigMatrix(m_rulesRtoOMtx[4]).free;
  m_rulesRtoOMtx[4] := nil;

  if assigned(m_rulesRtoOMtx[5]) then
    TOrigMatrix(m_rulesRtoOMtx[5]).free;
  m_rulesRtoOMtx[5] := nil;

  if assigned(m_rulesRtoOMtx[6]) then
    TOrigMatrix(m_rulesRtoOMtx[6]).free;
  m_rulesRtoOMtx[6] := nil;

  if assigned(m_rulesOtoOMtx[1]) then
    TOrigMatrix(m_rulesOtoOMtx[1]).free;
  m_rulesOtoOMtx[1] := nil;

  if assigned(m_rulesOtoOMtx[2]) then
    TOrigMatrix(m_rulesOtoOMtx[2]).free;
  m_rulesOtoOMtx[2] := nil;

  if assigned(m_rulesOtoOMtx[3]) then
    TOrigMatrix(m_rulesOtoOMtx[3]).free;
  m_rulesOtoOMtx[3] := nil;

  if assigned(m_rulesOtoOMtx[4]) then
    TOrigMatrix(m_rulesOtoOMtx[4]).free;
  m_rulesOtoOMtx[4] := nil;

  if assigned(m_rulesOtoOMtx[5]) then
    TOrigMatrix(m_rulesOtoOMtx[5]).free;
  m_rulesOtoOMtx[5] := nil;

  if assigned(m_rulesOtoOMtx[6]) then
    TOrigMatrix(m_rulesOtoOMtx[6]).free;
  m_rulesOtoOMtx[6] := nil;

end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.GetDescr: string;
begin
  Result := _('Workcenter') + ' ' + p_WrkCtrCode;
end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.ResCount: integer;
begin
  if Assigned(m_resList) then
    Result := m_resList.Count
  else
    Result := 0
end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.GetRes(i: integer): TMqmPlanObj;
begin
  Result := nil;
  if not assigned(m_resList) then exit;

  Assert((i >= 0) and (i < m_resList.Count));
  Result := TMqmPlanObj(m_resList[i])
end;

//----------------------------------------------------------------------------//
function SortByResCode(Item1, Item2: Pointer): integer;
var
  Res1 : TMqmPlanObj;
  Res2 : TMqmPlanObj;
begin
  Res1 := TMqmPlanObj(Item1);
  Res2 := TMqmPlanObj(Item2);
  if TMqmRes(Res1).p_ResCode < TMqmRes(Res2).p_ResCode then
    Result := -1
  else if (TMqmRes(Res1).p_ResCode = TMqmRes(Res2).p_ResCode) then
    Result := 0
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

procedure TMqmWrkCtr.AddResource(res: TMqmPlanObj; Category : string; CategoryDesc : string);
begin
  if not Assigned(m_resList) then
    m_resList := TList.Create;

  m_resList.Add(res);
//  AddCodeToWkcCapacityEntity(Category, CategoryDesc); // avi
  Res.p_Father := self;
  Res.m_plan := m_plan;
  m_resList.Sort(SortByResCode);
end;

//----------------------------------------------------------------------------//

procedure TMqmWrkCtr.AddAltWkcToList(altWkc: TMqmWrkCtr);
begin
  if not Assigned(m_alternativeWcList) then
  begin
    m_alternativeWcList := TStringList.Create;
    m_alternativeWcList.Add(m_code)
  end;

  if (m_alternativeWcList.IndexOf(altWkc.m_code) = -1) and (m_code <> altWkc.m_code) then
     m_alternativeWcList.Add(altWkc.m_code);
end;

//----------------------------------------------------------------------------//

procedure TMqmWrkCtr.AddCodeToWkcCapacityEntity(Code : string; Desc, PropCode : string; EntityType : integer);
var
  I : integer;
  PDailyCapacityByEntity : PTWkcDailyCapacityByEntity;
begin
  for I := 0 to m_WkcByEntityDailyCapacityList.Count - 1 do
  begin
    if (PTWkcDailyCapacityByEntity(m_WkcByEntityDailyCapacityList[I]).m_Code = Code) then
      exit;
  end;

  new(PDailyCapacityByEntity);
  case EntityType of
    1 : PDailyCapacityByEntity.m_EntityType := ety_category;
    2 : PDailyCapacityByEntity.m_EntityType := ety_property;
  end;
  PDailyCapacityByEntity.m_Code := Code;
  PDailyCapacityByEntity.m_Desc := Desc;
  PDailyCapacityByEntity.m_PropCode := PropCode;
  PDailyCapacityByEntity.m_WkcDailyCapacityList := nil;
  m_WkcByEntityDailyCapacityList.Add(PDailyCapacityByEntity);
end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.CheckCodeInWkcCapacityEntity(Code : string) : boolean;
var
  I : Integer;
begin
  Result := false;
  for I := 0 to m_WkcByEntityDailyCapacityList.Count - 1 do
  begin
    if (PTWkcDailyCapacityByEntity(m_WkcByEntityDailyCapacityList[I]).m_Code = Code) then
    begin
      Result := true;
      exit;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TMqmWrkCtr.AddProcces(rec: Pointer);
begin
  m_wkcProc.AddProc(rec);
end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.GetUseAllMachinePartsByProcess(proc: string) : CUseMachineParts;
begin
  result := m_wkcProc.GetUseAllMachinePartsProcess(proc);
end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.GetProcDesc(proc: string) : string;
begin
  Result := m_wkcProc.GetProcDesc(proc);
end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.ProdLinesCount: integer;
begin
  if Assigned(m_ProdLineList) then
    Result := m_ProdLineList.Count
  else
    Result := 0
end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.GetProdLine(i: integer): TMqmPlanObj;
begin
  Assert((i >= 0) and (i < m_ProdLineList.Count));
  Result := TMqmPlanObj(m_ProdLineList[i])
end;

//----------------------------------------------------------------------------//

procedure TMqmWrkCtr.AddProdLine(ProdLine: TMqmPlanObj);
begin
  if not Assigned(m_ProdLineList) then
    m_ProdLineList := TList.Create;

  m_ProdLineList.Add(ProdLine);
  ProdLine.p_Father := self;
  ProdLine.m_plan := m_plan
end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.FindRsrcByCode(resCode: string): TMqmPlanObj;
var
  i: integer;
  Multiplier, NumberOfEntries : integer;
begin
  Result := nil;
  if not Assigned(m_resList) then exit;
{  for i := 0 to m_resList.Count-1 do
    if TMqmRes(m_resList[i]).p_ResCode = resCode then
      Result := TMqmPlanObj(m_resList[i]) }


  NumberOfEntries := m_resList.Count;
  if NumberOfEntries = 0 then exit;

  if NumberOfEntries > 32 then
     Multiplier := 64
  else
    Multiplier := 1;
  while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
  i := Multiplier - 1;

  while (Multiplier > 0) do
  begin

    if  (i < NumberOfEntries) and (TMqmRes(m_resList[i]).p_ResCode = resCode) then
    begin
      Result := TMqmPlanObj(m_resList[i]);
      break;
    end;

    Multiplier := trunc(Multiplier / 2);

    if  (i < NumberOfEntries) and (TMqmRes(m_resList[i]).p_ResCode < resCode) then
      i := i + Multiplier
    else
      i := i - Multiplier;
  end;

end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.GetGroupType(proc: string) : CGroupingType;
begin
  Result := m_wkcProc.GetGroupType(proc);
end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.GetResOccupationType(proc: string) : CSResOccupation;
begin
  Result := m_wkcProc.GetResOccupationType(proc);
end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.GetAltWcList : TStringList;
begin
  if not Assigned(m_alternativeWcList) then
  begin
    m_alternativeWcList := TStringList.Create;
    m_alternativeWcList.Add(m_code);
  end;
  Result := m_alternativeWcList;
end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.GetPlantsList : TStringList;
var
  I, J : Integer;
  TempWc : TMqmWrkCtr;
  Res : TMqmRes;
  PlantCode : string;
begin
  if Assigned(m_WcPlantsList) then
     Result := m_WcPlantsList
  else
  begin
    m_WcPlantsList := TStringList.Create;
    for I := 0 to m_alternativeWcList.Count - 1 do
    begin
      TempWc := p_pl.FindWrkCtrByCode(m_alternativeWcList.Strings[I]);
      if TempWc = nil then continue;
      if TempWc.p_PlantCode = '' then continue;
      if TempWc.m_resList = nil then continue;

      for J := 0 to TempWc.m_resList.Count - 1 do
      begin
        Res := TMqmRes(TempWc.m_resList[J]);
        if Res = nil then continue;
        PlantCode := TempWc.p_PlantCode + Res.P_LineWithinPlant;
        if m_WcPlantsList.IndexOf(PlantCode) <> -1 then continue;
        m_WcPlantsList.Add(PlantCode);
      end;
    end;
    result := m_WcPlantsList;
  end;
end;

//----------------------------------------------------------------------------//

procedure TMqmWrkCtr.CleanWkcEntityDailyCapacityList;
var
  I, J, K : integer;
  PWkcDailyCapacityByEntity : PTWkcDailyCapacityByEntity;
  WkcDailyCapacity : PWkcDailyCapacity;
begin
  for I := m_WkcByEntityDailyCapacityList.Count - 1 downto 0 do
  begin
    Application.ProcessMessages;
    PWkcDailyCapacityByEntity := PTWkcDailyCapacityByEntity(m_WkcByEntityDailyCapacityList[I]);
    if assigned(PWkcDailyCapacityByEntity.m_WkcDailyCapacityList) then
    begin
      for J := PWkcDailyCapacityByEntity.m_WkcDailyCapacityList.Count - 1 downto 0 do
      begin
        WkcDailyCapacity := PWkcDailyCapacity(PWkcDailyCapacityByEntity.m_WkcDailyCapacityList[J]);
        if (WkcDailyCapacity.Hours_Used > 0) then
        begin
          begin
            if Assigned(WkcDailyCapacity.ListIds) then
            begin
              for K := WkcDailyCapacity.ListIds.Count - 1 downto 0 do
              begin
                if Assigned(PJobCapacity(WkcDailyCapacity.ListIds[k])) then
                  dispose(PJobCapacity(WkcDailyCapacity.ListIds[k]));
              end;
              WkcDailyCapacity.ListIds.Free;
            end;
          end;
        end;
        dispose(WkcDailyCapacity)
      end;
      PWkcDailyCapacityByEntity.m_WkcDailyCapacityList.clear;
      PWkcDailyCapacityByEntity.m_WkcDailyCapacityList.free;
    end;
    dispose(PWkcDailyCapacityByEntity);
  end;
  m_WkcByEntityDailyCapacityList.Clear;
end;

//----------------------------------------------------------------------------//

procedure TMqmWrkCtr.CleanWkcDailyCapacityList;
var
  I, J : Integer;
  WkcDailyCapacity : PWkcDailyCapacity;
begin
  for I := m_WkcDailyCapacityList.Count - 1 downto 0 do
  begin
    WkcDailyCapacity := PWkcDailyCapacity(m_WkcDailyCapacityList[I]);
    if (WkcDailyCapacity.Hours_Used > 0) then
    begin
      begin
        if Assigned(WkcDailyCapacity.ListIds) then
        begin
          for J := WkcDailyCapacity.ListIds.Count - 1 downto 0 do
            dispose(PJobCapacity(WkcDailyCapacity.ListIds[J]));
          WkcDailyCapacity.ListIds.Free;
        end;
      end;
    end;
    //dispose(WkcDailyCapacity);

    try
      WkcDailyCapacity.DateStr := 'xx';
    finally
    if Assigned(WkcDailyCapacity) then
    begin
      Dispose(WkcDailyCapacity);   // Deallocation
      WkcDailyCapacity := nil;     // Prevent double-dispose
    end;
    end;

  //  Application.ProcessMessages;
  end;
  m_WkcDailyCapacityList.clear;
end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.GetPropValuesFromWkcDailyCapacityList(PropCode : string; ListVal : TStringList) : boolean;
var
  I, J : Integer;
  WkcDailyCapacity : PWkcDailyCapacity;
  JobCapacity   : PJobCapacity;
  Properties : TProperties;
  JobVal : variant;
begin
  for I := m_WkcDailyCapacityList.Count - 1 downto 0 do
  begin
    Application.ProcessMessages;
    WkcDailyCapacity := PWkcDailyCapacity(m_WkcDailyCapacityList[I]);
    if WkcDailyCapacity.ListIds = nil then continue;
    for J := WkcDailyCapacity.ListIds.Count - 1 downto 0 do
    begin
      JobCapacity := PJobCapacity(WkcDailyCapacity.ListIds[J]);
      Properties := p_sc.GetProperties(JobCapacity.Id,nil);
      Properties.GetValforCode(PropCode, '', -1, JobVal);
      if VarIsStr(JobVal) then
      begin
        if JobVal = '' then continue;
      end
      else
      begin
        if JobVal = 0 then continue;
        JobVal := IntToStr(JobVal);
      end;

      if ListVal.IndexOf(JobVal) <> -1 then continue;
      ListVal.add(JobVal);

    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TMqmWrkCtr.AddIdToWkcDailyCapacityList(Id : TSchedId; ActArea : TMqmActArea; var MinStartDate : TDateTime; var MaxEndDate : TDateTime;  errSet : SetOfErrors; PropMultiQty : Double);
var
  DatesInfo : TSQStartEndInfo;
  CurrentDate , DateSchedEnd : TDateTime;
  DailyCapacity, DailyCategoryCapacity : PWkcDailyCapacity;
  JobCapacity   : PJobCapacity;
  Cal: TPGCALObj;
  HoursUsed, SetupUsed, TotalHoursOfId : double;
  value, ExeTime: variant;
  dataType: CBinColValType;
  UM : String;
  TempInt, NeededComponents : integer;
  moveChgInfo: TSQmoveChgInfo;
  StartExecusionDateTime : TDateTime;
  HypoteticalExe, HoursUsedJobWithoutComponents : double;
  // --- one-batch-machine ("double resource") percent fix ---
  OBMRes, OBMPartner : TMqmRes;
  PartnerActArea : TMqmActArea;
  PartnerCal : TPGCALObj;
  BlockedHours : double;
  procVal : variant;
  OccupiesWholeGroup : boolean;
  PartnerBlockedForJob : double;   // partner hours to attribute to THIS job's SlotInfo row
begin
  StartExecusionDateTime := 0;
  Cal := ActArea.GetCalendar;

  p_sc.GetMoveChgInfo(Id, moveChgInfo);

  if moveChgInfo.supMinReal > 0 then
    cal.OfsByWH(moveChgInfo.supMinReal/60, true, moveChgInfo.startDate, StartExecusionDateTime, ActArea.m_CrossDownTmList);

  p_sc.GetStartEndInfo(Id, DatesInfo);
  CurrentDate := DatesInfo.startDate;
  DateSchedEnd := DatesInfo.endDate;

  if MinStartDate = 0 then
     MinStartDate := trunc(DatesInfo.startDate)
  else
    if DatesInfo.startDate < MinStartDate then
      MinStartDate := trunc(DatesInfo.startDate);

  if MaxEndDate = 0 then
     MaxEndDate := trunc(DatesInfo.endDate)
  else
    if DatesInfo.endDate > MaxEndDate then
      MaxEndDate := trunc(DatesInfo.endDate);

  TotalHoursOfId := Cal.DiffWHNotRounded(DatesInfo.startDate, DatesInfo.endDate, ActArea.m_CrossDownTmList);

  while True do
  begin
    Application.ProcessMessages;
    if DateSchedEnd < CurrentDate then exit;

    if (moveChgInfo.supMinReal = 0) or (trunc(StartExecusionDateTime) < Trunc(CurrentDate)) then
      SetupUsed := 0
    else
    begin
      if (trunc(DatesInfo.startDate) = Trunc(CurrentDate)) then
      begin
        if (trunc(StartExecusionDateTime) = Trunc(CurrentDate)) then
          SetupUsed := moveChgInfo.supMinReal/60
        else
         SetupUsed := Cal.DiffWHNotRounded(DatesInfo.startDate, trunc(CurrentDate + 1), ActArea.m_CrossDownTmList);
      end
      else
      begin
        if (trunc(StartExecusionDateTime) = Trunc(CurrentDate)) then
          SetupUsed := Cal.DiffWHNotRounded(CurrentDate, StartExecusionDateTime, ActArea.m_CrossDownTmList)
        else
          SetupUsed := Cal.DiffWHNotRounded(CurrentDate, trunc(CurrentDate + 1), ActArea.m_CrossDownTmList);
      end;
    end;

    if (trunc(DateSchedEnd) = Trunc(CurrentDate)) then
       HoursUsed := Cal.DiffWHNotRounded(CurrentDate, DatesInfo.endDate, ActArea.m_CrossDownTmList)
    else
      HoursUsed := Cal.DiffWHNotRounded(CurrentDate, trunc(CurrentDate + 1), ActArea.m_CrossDownTmList);

    HoursUsedJobWithoutComponents := HoursUsed;
    NeededComponents := 0;
    PartnerBlockedForJob := 0;
    if HoursUsed > 0 then
    begin
      if TMQMRes(ActArea.p_Res).p_isMultiRes then
      begin
        //if p_sc.GetRscComponentFromStep(Id) > 0 then
        NeededComponents := p_sc.GetRscComponentFromJobOrStep(id);
       // else
       //   NeededComponents := p_sc.GetJobComponents(Id, true);
        HoursUsed := HoursUsed * NeededComponents;
      end;

      DailyCapacity := FindOrAddDateInDailyCapList(Trunc(CurrentDate));
      if DailyCapacity.Hours_Used = 0 then
        DailyCapacity.ListIds := Tlist.Create;
      DailyCapacity.Hours_Used := DailyCapacity.Hours_Used + HoursUsed;

      // --- One-batch-machine group ("double resource") percent fix ---------------
      // Two resources A and B in this WC are linked as a one-batch-machine group
      // (P_rscOfBatchMachinSameGrpCode). Scheduling a job on A blocks the parallel
      // resource B for the same period (enforced by CheckDatesOnOneBatchMachineByGroupCode).
      // The WC available capacity counts BOTH A and B, but the job only consumed A, so
      // the slot showed 50%. Add the blocked partner's working hours for the same window
      // so the slot reflects the real occupancy (100%).
      //   Qty_typ     : every job occupies the whole group.
      //   process_typ : only an Mp_All job occupies the whole group; Mp_RearPart /
      //                 Mp_FrontPart jobs leave the complementary part free (genuine
      //                 parallel) and stay per-part -> unchanged.
      // Guard (OBMPartner.p_father = Self) ensures the partner shares THIS WC's capacity;
      // if it sits in another WC, that WC's available does not include B, so the slot is
      // already correct and we must not over-count.
      OBMRes := TMQMRes(ActArea.p_Res);
      OBMPartner := OBMRes.P_rscOfBatchMachinSameGrpCode;
      if Assigned(OBMPartner)
         and (TMqmWrkCtr(OBMPartner.p_father) = Self)
         and (OBMPartner.p_PlanType = RPT_Real)   // partner's capacity is in the WC available sum
         and (OBMPartner.p_VisResCount > 0) then
      begin
        OccupiesWholeGroup := false;
        case OBMRes.p_GROUP_TYPE_FOR_ONE_BATCH_MACHINE of
          Qty_typ:
            // Only double when the job's quantity actually needs both sides
            // (qty > single-machine max batch). A small job that fits one side
            // stays on one side and must not be doubled.
            OccupiesWholeGroup := OBMRes.CheckMaxQtyOnBatchMachinSameGrpCode(Id);
          process_typ:
            begin
              p_sc.GetFldValue(Id, CSC_WkctProc, procVal, dataType);
              OccupiesWholeGroup := (GetUseAllMachinePartsByProcess(procVal) = Mp_All);
            end;
        end;

        if OccupiesWholeGroup then
        begin
          PartnerActArea := TMqmActArea(OBMPartner.p_VisRes[0].p_ActArea[0]);
          PartnerCal := PartnerActArea.GetCalendar;
          if (trunc(DateSchedEnd) = Trunc(CurrentDate)) then
            BlockedHours := PartnerCal.DiffWHNotRounded(CurrentDate, DatesInfo.endDate, PartnerActArea.m_CrossDownTmList)
          else
            BlockedHours := PartnerCal.DiffWHNotRounded(CurrentDate, trunc(CurrentDate + 1), PartnerActArea.m_CrossDownTmList);
          if BlockedHours > 0 then
          begin
            DailyCapacity.Hours_Used := DailyCapacity.Hours_Used + BlockedHours;
            // Attribute the blocked partner hours to THIS job's SlotInfo row too, so the
            // per-job grid rows sum to the day total (slot percent is unchanged - it reads
            // DailyCapacity.Hours_Used, which already included BlockedHours before this).
            PartnerBlockedForJob := BlockedHours;
          end;
        end;
      end;
      // --- end one-batch-machine fix ---------------------------------------------

      new(JobCapacity);
      JobCapacity.JobHours := HoursUsed + PartnerBlockedForJob;
      JobCapacity.NeededComponents := NeededComponents;
      JobCapacity.HoursUsedJobWithoutComponents := HoursUsedJobWithoutComponents + PartnerBlockedForJob;

      JobCapacity.id := id;

//      p_sc.GetFldValue(id, CSC_ExeTimeSched, ExeTime, dataType); // Replaced by TotalHoursOfId - SetupUsed

      p_sc.GetFldValue(Id, CSC_QtyToSched, value, dataType);

      ExeTime := (TotalHoursOfId - SetupUsed)/60;
      HypoteticalExe := HoursUsed - SetupUsed;
      if HypoteticalExe > ExeTime then
         HypoteticalExe := ExeTime;

      TempInt := Trunc(100*HypoteticalExe/ExeTime*value);
      value := TempInt/100;

      JobCapacity.qty := value;

      JobCapacity.PropMultiQty := value * PropMultiQty;

      p_sc.GetFldValue(Id, CSC_ProdUM, value, dataType);
      JobCapacity.UM := value;
      ///

      JobCapacity.errSet := errSet;
      DailyCapacity.ListIds.Add(JobCapacity);
    end;

    CurrentDate := trunc(CurrentDate + 1);
  end;

end;
//----------------------------------------------------------------------------//

procedure TMqmWrkCtr.AddIdToWkcDailyCapacityEntityList(Code : string; Id : TSchedId; ActArea : TMqmActArea
; var MinStartDate : TDateTime; var MaxEndDate : TDateTime; errSet : SetOfErrors; PropMultiQty : Double);
var
  DatesInfo : TSQStartEndInfo;
  CurrentDate , DateSchedEnd : TDateTime;
  DailyCapacity : PWkcDailyCapacity;
  JobCapacity   : PJobCapacity;
  Cal: TPGCALObj;
  HoursUsed, NeededComponents : double;
  value : Variant;
  dataType: CBinColValType;
begin
  Cal := ActArea.GetCalendar;
  p_sc.GetStartEndInfo(Id, DatesInfo);
  CurrentDate := DatesInfo.startDate;
  DateSchedEnd := DatesInfo.endDate;

  if MinStartDate = 0 then
     MinStartDate := trunc(DatesInfo.startDate)
  else
    if DatesInfo.startDate < MinStartDate then
      MinStartDate := trunc(DatesInfo.startDate);

  if MaxEndDate = 0 then
     MaxEndDate := trunc(DatesInfo.endDate)
  else
    if DatesInfo.endDate > MaxEndDate then
      MaxEndDate := trunc(DatesInfo.endDate);

  while True do
  begin
    Application.ProcessMessages;
    if DateSchedEnd < CurrentDate then exit;

    if (trunc(DateSchedEnd) = Trunc(CurrentDate)) then
       HoursUsed := Cal.DiffWH(CurrentDate, DatesInfo.endDate, ActArea.m_CrossDownTmList)
    else
      HoursUsed := Cal.DiffWH(CurrentDate, trunc(CurrentDate + 1), ActArea.m_CrossDownTmList);

    if HoursUsed > 0 then
    begin

      if TMQMRes(ActArea.p_Res).p_isMultiRes then
      begin
        //if p_sc.GetRscComponentFromStep(Id) > 0 then
        NeededComponents := p_sc.GetRscComponentFromJobOrStep(id);
       // else
       //   NeededComponents := p_sc.GetJobComponents(Id, true);
        HoursUsed := HoursUsed * NeededComponents;
      end;

      DailyCapacity := FindOrAddDateInDailyEntityCapList(Code, Trunc(CurrentDate));
      if DailyCapacity.Hours_Used = 0 then
        DailyCapacity.ListIds := Tlist.Create;
      DailyCapacity.Hours_Used := DailyCapacity.Hours_Used + HoursUsed;
      new(JobCapacity);
      JobCapacity.JobHours := HoursUsed;
      JobCapacity.id := id;
      JobCapacity.PropMultiQty := PropMultiQty;

      p_sc.GetFldValue(Id, CSC_QtyToSched, value, dataType);
      JobCapacity.qty := value;

      JobCapacity.errSet := errSet;
      DailyCapacity.ListIds.Add(JobCapacity);
    end;

    CurrentDate := trunc(CurrentDate + 1);
  end;
end;

//----------------------------------------------------------------------------//

procedure TMqmWrkCtr.AddHoursAvailableToWkcCapacity(ActArea : TMqmActArea; MinStartDate : TDate; MaxEndDate : TDate);
var
  I : Integer;
  CurrentDate : TDate;
  DailyCapacity : PWkcDailyCapacity;
  Cal: TPGCALObj;
  Hours_Available : double;
begin
  CurrentDate := MinStartDate;
  Cal := ActArea.GetCalendar;
  while true do
  begin
    Application.ProcessMessages;
    DailyCapacity := FindOrAddDateInDailyCapList(CurrentDate);
    Hours_Available := Cal.DiffWH(CurrentDate, (CurrentDate + 1), ActArea.m_CrossDownTmList);
    if TMQMRes(ActArea.p_Res).p_isMultiRes then
       Hours_Available := Hours_Available * TMQMRes(ActArea.p_Res).p_ResComp;
    DailyCapacity.Hours_Available := DailyCapacity.Hours_Available + Hours_Available;
    CurrentDate := CurrentDate + 1;
    if CurrentDate = MaxEndDate then break
  end;
end;

//----------------------------------------------------------------------------//

procedure TMqmWrkCtr.AddHoursAvailableToWkcEntityCapacity(Code : string; ActArea : TMqmActArea; MinStartDate : TDate; MaxEndDate : TDate);
var
  I : Integer;
  CurrentDate : TDate;
  DailyCapacity : PWkcDailyCapacity;
  Cal: TPGCALObj;
  Hours_Available : double;
begin
  CurrentDate := MinStartDate;
  Cal := ActArea.GetCalendar;
  while true do
  begin
    Application.ProcessMessages;
    DailyCapacity := FindOrAddDateInDailyEntityCapList(Code, Trunc(CurrentDate));
    Hours_Available := Cal.DiffWH(CurrentDate, (CurrentDate + 1), ActArea.m_CrossDownTmList);
    DailyCapacity.Hours_Available := DailyCapacity.Hours_Available + Hours_Available;
    CurrentDate := CurrentDate + 1;
    if CurrentDate = MaxEndDate then break
  end;
end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.FindOrAddDateInDailyCapList(date : TdateTime) : Pointer;
var
  DailyCapacity : PWkcDailyCapacity;
  I: integer;
  Multiplier, NumberOfEntries, LowestHighestValue : integer;
begin

  NumberOfEntries := m_WkcDailyCapacityList.Count;
  LowestHighestValue := NumberOfEntries;

  if NumberOfEntries > 0 then
  begin

    Multiplier := 1;
    while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    I := Multiplier - 1;

    while (Multiplier > 0) do
    begin
      Multiplier := trunc(Multiplier / 2);

      if (i >= NumberOfEntries) then
      begin
        i := i - Multiplier;
        Continue;
      end;

      if (PWkcDailyCapacity(m_WkcDailyCapacityList[I]).Date < date) then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PWkcDailyCapacity(m_WkcDailyCapacityList[I]).Date > date) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      Result := PWkcDailyCapacity(m_WkcDailyCapacityList[I]);
      Exit;

    end;
  end;

  new(DailyCapacity);
  DailyCapacity.Date := date;
  DailyCapacity.Hours_Available := 0;
  DailyCapacity.Hours_Used := 0;
  DailyCapacity.ListIds := nil;
  m_WkcDailyCapacityList.insert(LowestHighestValue, DailyCapacity);
  Result := DailyCapacity;

end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.FindOrAddDateInDailyEntityCapList(Code : string; date : TdateTime) : Pointer;
var
  DailyCapacity : PWkcDailyCapacity;
  I: integer;
  Multiplier, NumberOfEntries, LowestHighestValue : integer;
  PWkcDailyCapacityByEntity : PTWkcDailyCapacityByEntity;
begin

  for I := 0 to m_WkcByEntityDailyCapacityList.Count - 1 do
  begin
    PWkcDailyCapacityByEntity := PTWkcDailyCapacityByEntity(m_WkcByEntityDailyCapacityList[I]);
    if PWkcDailyCapacityByEntity.m_Code = Code then break;
  end;

  if not assigned(PWkcDailyCapacityByEntity.m_WkcDailyCapacityList) then
     PWkcDailyCapacityByEntity.m_WkcDailyCapacityList := TList.create;

  NumberOfEntries := PWkcDailyCapacityByEntity.m_WkcDailyCapacityList.Count;
  LowestHighestValue := NumberOfEntries;

  if NumberOfEntries > 0 then
  begin

    Multiplier := 1;
    while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    I := Multiplier - 1;

    while (Multiplier > 0) do
    begin
      Multiplier := trunc(Multiplier / 2);

      if (i >= NumberOfEntries) then
      begin
        i := i - Multiplier;
        Continue;
      end;

      if (PWkcDailyCapacity(PWkcDailyCapacityByEntity.m_WkcDailyCapacityList[I]).Date < date) then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PWkcDailyCapacity(PWkcDailyCapacityByEntity.m_WkcDailyCapacityList[I]).Date > date) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      Result := PWkcDailyCapacity(PWkcDailyCapacityByEntity.m_WkcDailyCapacityList[I]);
      Exit;

    end;
  end;

  new(DailyCapacity);
  DailyCapacity.Date := date;
  DailyCapacity.Hours_Available := 0;
  DailyCapacity.Hours_Used := 0;
  DailyCapacity.ListIds := nil;
  if PWkcDailyCapacityByEntity.m_WkcDailyCapacityList = nil then
     result := nil;
    PWkcDailyCapacityByEntity.m_WkcDailyCapacityList.insert(LowestHighestValue, DailyCapacity);
  Result := DailyCapacity;
end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.GetHintDataForPrdDailyCap(stDate, edDate: TDateTime; var qty : double; var NumJobsLate : integer; var MaxDaysInLate : integer; var NumJobsMaterialProblem : Integer; var NumJobsAddresProblem : integer;var RealPerc : Double) : boolean;
var
  I, J, S : Integer;
  DailyCapacity : PWkcDailyCapacity;
  JobCapacity : PJobCapacity;
  Hours_used : double;
  ListId : TStringList;
begin
  qty := 0;
  RealPerc := 0;
  NumJobsLate := 0;
  MaxDaysInLate := 0;
  NumJobsMaterialProblem := 0;
  NumJobsAddresProblem := 0;


  ListId := TStringList.Create;
  for I := 0 to m_WkcDailyCapacityList.count - 1 do
  begin

    if (PWkcDailyCapacity(m_WkcDailyCapacityList[I]).Date < stDate) then continue;
    if (PWkcDailyCapacity(m_WkcDailyCapacityList[I]).Date > edDate) then exit;
    DailyCapacity := PWkcDailyCapacity(m_WkcDailyCapacityList[I]);
    Hours_used      := Hours_used + DailyCapacity.Hours_used;

    if DailyCapacity.Hours_Available > 0 then
      RealPerc := (DailyCapacity.Hours_used / DailyCapacity.Hours_Available)*100;

    if (Hours_used > 0) and assigned(PWkcDailyCapacity(m_WkcDailyCapacityList[I]).ListIds) then
    begin
      for J := 0 to PWkcDailyCapacity(m_WkcDailyCapacityList[I]).ListIds.Count - 1 do
      begin
        JobCapacity := PJobCapacity(PWkcDailyCapacity(m_WkcDailyCapacityList[I]).ListIds[J]);
        if ListId.IndexOf(IntToStr(PJobCapacity(JobCapacity).id)) <> - 1 then continue;
        ListId.Add(IntToStr(JobCapacity.id));
        qty := qty + JobCapacity.qty;
        if CSE_HighEndDate in JobCapacity.errSet then
          Inc(NumJobsLate);
        if CSE_Materials in JobCapacity.errSet then
          Inc(NumJobsMaterialProblem);
        if CSE_AddRes in JobCapacity.errSet then
          Inc(NumJobsAddresProblem);
      end;
    end;
  end;

  ListId.Free;
end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.GetDataForPrdDailyCap(stDate, edDate: TDateTime; var Hours_Available : double; var Hours_used : double; var errSet : SetOfErrors) : boolean;
var
  I, J, S : Integer;
  DailyCapacity : PWkcDailyCapacity;
  JobCapacity : PJobCapacity;
begin
  Hours_Available := 0;
  Hours_used := 0;
  errSet := [];
  for I := 0 to m_WkcDailyCapacityList.count - 1 do
  begin
    if (PWkcDailyCapacity(m_WkcDailyCapacityList[I]).Date < stDate) then continue;
    if (PWkcDailyCapacity(m_WkcDailyCapacityList[I]).Date > edDate) then exit;
    DailyCapacity := PWkcDailyCapacity(m_WkcDailyCapacityList[I]);
    Hours_Available := Hours_Available + DailyCapacity.Hours_Available;
    Hours_used      := Hours_used + DailyCapacity.Hours_used;
    if (Hours_used > 0) and assigned(PWkcDailyCapacity(m_WkcDailyCapacityList[I]).ListIds) then
    begin
      for J := 0 to PWkcDailyCapacity(m_WkcDailyCapacityList[I]).ListIds.Count - 1 do
      begin
        JobCapacity := PJobCapacity(PWkcDailyCapacity(m_WkcDailyCapacityList[I]).ListIds[J]);
        if CSE_Materials in JobCapacity.errSet then
           Include(errSet, CSE_Materials);
        if CSE_AddRes in JobCapacity.errSet then
           Include(errSet, CSE_AddRes);
        if CSE_HighEndDate in JobCapacity.errSet then
           Include(errSet, CSE_HighEndDate);
        if CSE_LowStrDate in JobCapacity.errSet then
           Include(errSet, CSE_LowStrDate);
        if CSE_LeftOvlp in JobCapacity.errSet then
           Include(errSet, CSE_LeftOvlp);
        if CSE_RightOvlp in JobCapacity.errSet then
           Include(errSet, CSE_RightOvlp);
        if CSE_BothOvlp in JobCapacity.errSet then
           Include(errSet, CSE_BothOvlp);
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.GetDataForPrdDailyCategoryCap(Code : string; stDate, edDate: TDateTime; var Hours_Available_slot : double; var Hours_used_slot : double; var errSet : SetOfErrors) : boolean;
var
  I, J, S : Integer;
  DailyCapacity : PWkcDailyCapacity;
  PWkcDailyCapacityByEntity : PTWkcDailyCapacityByEntity;
  JobCapacity : PJobCapacity;
begin
  Hours_Available_slot := 0;
  Hours_used_slot := 0;
  errSet := [];

  for I := 0 to m_WkcByEntityDailyCapacityList.Count - 1 do
  begin
    PWkcDailyCapacityByEntity := PTWkcDailyCapacityByEntity(m_WkcByEntityDailyCapacityList[I]);
    if PWkcDailyCapacityByEntity.m_Code = Code then break;
  end;

  try
    if PWkcDailyCapacityByEntity = nil then exit;
    if PWkcDailyCapacityByEntity.m_Code <> Code then exit;  // not found — return 0
    if not assigned(PWkcDailyCapacityByEntity.m_WkcDailyCapacityList) then exit;
  except
    Exit;
  end;

  for I := 0 to PWkcDailyCapacityByEntity.m_WkcDailyCapacityList.count - 1 do
  begin
    if (PWkcDailyCapacity(PWkcDailyCapacityByEntity.m_WkcDailyCapacityList[I]).Date < stDate) then continue;
    if (PWkcDailyCapacity(PWkcDailyCapacityByEntity.m_WkcDailyCapacityList[I]).Date > edDate) then exit;
    DailyCapacity := PWkcDailyCapacity(PWkcDailyCapacityByEntity.m_WkcDailyCapacityList[I]);
    Hours_Available_slot := Hours_Available_slot + DailyCapacity.Hours_Available;
    Hours_used_slot      := Hours_used_slot + DailyCapacity.Hours_used;
    if (Hours_used_slot > 0) and assigned(PWkcDailyCapacity(PWkcDailyCapacityByEntity.m_WkcDailyCapacityList[I]).ListIds) then
    begin
      for J := 0 to PWkcDailyCapacity(PWkcDailyCapacityByEntity.m_WkcDailyCapacityList[I]).ListIds.Count - 1 do
      begin
        JobCapacity := PJobCapacity(PWkcDailyCapacity(PWkcDailyCapacityByEntity.m_WkcDailyCapacityList[I]).ListIds[J]);
        if CSE_Materials in JobCapacity.errSet then
           Include(errSet, CSE_Materials);
        if CSE_AddRes in JobCapacity.errSet then
           Include(errSet, CSE_AddRes);
        if CSE_HighEndDate in JobCapacity.errSet then
           Include(errSet, CSE_HighEndDate);
        if CSE_LowStrDate in JobCapacity.errSet then
           Include(errSet, CSE_LowStrDate);
        if CSE_LeftOvlp in JobCapacity.errSet then
           Include(errSet, CSE_LeftOvlp);
        if CSE_RightOvlp in JobCapacity.errSet then
           Include(errSet, CSE_RightOvlp);
        if CSE_BothOvlp in JobCapacity.errSet then
           Include(errSet, CSE_BothOvlp);
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.GetDataForPrdDailyPropertyCap(PropCode : string; stDate, edDate: TDateTime; var Hours_Available_slot : double; var Hours_used_slot : double; var errSet : SetOfErrors) : boolean;
var
  I, J, S : Integer;
  DailyCapacity : PWkcDailyCapacity;
  JobCapacity : PJobCapacity;
  Properties : TProperties;
  JobVal : variant;
  PWkcDailyCapacityByEntity : PTWkcDailyCapacityByEntity;
begin
  PWkcDailyCapacityByEntity := nil;
  Hours_Available_slot := 0;
  Hours_used_slot := 0;
  errSet := [];

  for I := 0 to m_WkcByEntityDailyCapacityList.Count - 1 do
  begin
    PWkcDailyCapacityByEntity := PTWkcDailyCapacityByEntity(m_WkcByEntityDailyCapacityList[I]);
    if PWkcDailyCapacityByEntity.m_Code = PropCode then break;
  end;

  try
    if PWkcDailyCapacityByEntity = nil then exit;
    if PWkcDailyCapacityByEntity.m_Code <> PropCode then exit;  // not found — return 0
    if not assigned(PWkcDailyCapacityByEntity.m_WkcDailyCapacityList) then exit;
  except
    Exit;
  end;

  for I := 0 to PWkcDailyCapacityByEntity.m_WkcDailyCapacityList.count - 1 do
  begin
    if (trunc(PWkcDailyCapacity(PWkcDailyCapacityByEntity.m_WkcDailyCapacityList[I]).Date) < stDate) then continue;
    if (trunc(PWkcDailyCapacity(PWkcDailyCapacityByEntity.m_WkcDailyCapacityList[I]).Date) > edDate) then exit;

    DailyCapacity := PWkcDailyCapacity(PWkcDailyCapacityByEntity.m_WkcDailyCapacityList[I]);
    Hours_Available_slot := Hours_Available_slot + DailyCapacity.Hours_Available;
    Hours_used_slot      := Hours_used_slot + DailyCapacity.Hours_used;
    if (Hours_used_slot > 0) and assigned(PWkcDailyCapacity(PWkcDailyCapacityByEntity.m_WkcDailyCapacityList[I]).ListIds) then
    begin
      for J := 0 to PWkcDailyCapacity(PWkcDailyCapacityByEntity.m_WkcDailyCapacityList[I]).ListIds.Count - 1 do
      begin
        JobCapacity := PJobCapacity(PWkcDailyCapacity(PWkcDailyCapacityByEntity.m_WkcDailyCapacityList[I]).ListIds[J]);

        if CSE_Materials in JobCapacity.errSet then
           Include(errSet, CSE_Materials);
        if CSE_AddRes in JobCapacity.errSet then
           Include(errSet, CSE_AddRes);
        if CSE_HighEndDate in JobCapacity.errSet then
           Include(errSet, CSE_HighEndDate);
        if CSE_LowStrDate in JobCapacity.errSet then
           Include(errSet, CSE_LowStrDate);
        if CSE_LeftOvlp in JobCapacity.errSet then
           Include(errSet, CSE_LeftOvlp);
        if CSE_RightOvlp in JobCapacity.errSet then
           Include(errSet, CSE_RightOvlp);
        if CSE_BothOvlp in JobCapacity.errSet then
           Include(errSet, CSE_BothOvlp);
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

// Returns the daily-capacity list of a property/category entity (by its code/value),
// or nil if this work center has no data for that entity. Used by Slot Info to list
// the jobs that build a property/category slot. Does NOT own the returned list.
function TMqmWrkCtr.GetEntityDailyCapacityList(Code : string) : TList;
var
  I : Integer;
  Ent : PTWkcDailyCapacityByEntity;
begin
  Result := nil;
  if not assigned(m_WkcByEntityDailyCapacityList) then exit;
  for I := 0 to m_WkcByEntityDailyCapacityList.Count - 1 do
  begin
    Ent := PTWkcDailyCapacityByEntity(m_WkcByEntityDailyCapacityList[I]);
    if Ent.m_Code = Code then
    begin
      Result := Ent.m_WkcDailyCapacityList;
      exit;
    end;
  end;
end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.GetHintDataForPrdDailyPropertyCap(PropCode : string; stDate, edDate: TDateTime; var qty : double; var NumJobsLate : integer; var MaxDaysInLate : integer; var NumJobsMaterialProblem : Integer; var NumJobsAddresProblem : integer; var RealPerc : Double) : boolean;
var
  I, J : Integer;
  DailyCapacity : PWkcDailyCapacity;
  PWkcDailyCapacityByEntity : PTWkcDailyCapacityByEntity;
  JobCapacity : PJobCapacity;
  Hours_used : double;
  ListId : TStringList;
begin
  Result := True;
  qty := 0; RealPerc := 0; NumJobsLate := 0; MaxDaysInLate := 0;
  NumJobsMaterialProblem := 0; NumJobsAddresProblem := 0; Hours_used := 0;

  PWkcDailyCapacityByEntity := nil;
  for I := 0 to m_WkcByEntityDailyCapacityList.Count - 1 do
  begin
    PWkcDailyCapacityByEntity := PTWkcDailyCapacityByEntity(m_WkcByEntityDailyCapacityList[I]);
    if PWkcDailyCapacityByEntity.m_Code = PropCode then break;
  end;
  try
    if PWkcDailyCapacityByEntity = nil then exit;
    if PWkcDailyCapacityByEntity.m_Code <> PropCode then exit;
    if not assigned(PWkcDailyCapacityByEntity.m_WkcDailyCapacityList) then exit;
  except Exit; end;

  ListId := TStringList.Create;
  try
    for I := 0 to PWkcDailyCapacityByEntity.m_WkcDailyCapacityList.count - 1 do
    begin
      if (trunc(PWkcDailyCapacity(PWkcDailyCapacityByEntity.m_WkcDailyCapacityList[I]).Date) < stDate) then continue;
      if (trunc(PWkcDailyCapacity(PWkcDailyCapacityByEntity.m_WkcDailyCapacityList[I]).Date) > edDate) then break;
      DailyCapacity := PWkcDailyCapacity(PWkcDailyCapacityByEntity.m_WkcDailyCapacityList[I]);
      Hours_used := Hours_used + DailyCapacity.Hours_used;
      if DailyCapacity.Hours_Available > 0 then
        RealPerc := (DailyCapacity.Hours_used / DailyCapacity.Hours_Available) * 100;
      if (Hours_used > 0) and assigned(DailyCapacity.ListIds) then
        for J := 0 to DailyCapacity.ListIds.Count - 1 do
        begin
          JobCapacity := PJobCapacity(DailyCapacity.ListIds[J]);
          if ListId.IndexOf(IntToStr(JobCapacity.id)) <> -1 then continue;
          ListId.Add(IntToStr(JobCapacity.id));
          qty := qty + JobCapacity.qty;
          if CSE_HighEndDate in JobCapacity.errSet then Inc(NumJobsLate);
          if CSE_Materials in JobCapacity.errSet then Inc(NumJobsMaterialProblem);
          if CSE_AddRes in JobCapacity.errSet then Inc(NumJobsAddresProblem);
        end;
    end;
  finally
    ListId.Free;
  end;
end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.GetHintDataForPrdDailyCategoryCap(Code : string; stDate, edDate: TDateTime; var qty : double; var NumJobsLate : integer; var MaxDaysInLate : integer; var NumJobsMaterialProblem : Integer; var NumJobsAddresProblem : integer; var RealPerc : Double) : boolean;
var
  I, J : Integer;
  DailyCapacity : PWkcDailyCapacity;
  PWkcDailyCapacityByEntity : PTWkcDailyCapacityByEntity;
  JobCapacity : PJobCapacity;
  Hours_used : double;
  ListId : TStringList;
begin
  Result := True;
  qty := 0; RealPerc := 0; NumJobsLate := 0; MaxDaysInLate := 0;
  NumJobsMaterialProblem := 0; NumJobsAddresProblem := 0; Hours_used := 0;

  PWkcDailyCapacityByEntity := nil;
  for I := 0 to m_WkcByEntityDailyCapacityList.Count - 1 do
  begin
    PWkcDailyCapacityByEntity := PTWkcDailyCapacityByEntity(m_WkcByEntityDailyCapacityList[I]);
    if PWkcDailyCapacityByEntity.m_Code = Code then break;
  end;
  try
    if PWkcDailyCapacityByEntity = nil then exit;
    if PWkcDailyCapacityByEntity.m_Code <> Code then exit;
    if not assigned(PWkcDailyCapacityByEntity.m_WkcDailyCapacityList) then exit;
  except Exit; end;

  ListId := TStringList.Create;
  try
    for I := 0 to PWkcDailyCapacityByEntity.m_WkcDailyCapacityList.count - 1 do
    begin
      if (PWkcDailyCapacity(PWkcDailyCapacityByEntity.m_WkcDailyCapacityList[I]).Date < stDate) then continue;
      if (PWkcDailyCapacity(PWkcDailyCapacityByEntity.m_WkcDailyCapacityList[I]).Date > edDate) then break;
      DailyCapacity := PWkcDailyCapacity(PWkcDailyCapacityByEntity.m_WkcDailyCapacityList[I]);
      Hours_used := Hours_used + DailyCapacity.Hours_used;
      if DailyCapacity.Hours_Available > 0 then
        RealPerc := (DailyCapacity.Hours_used / DailyCapacity.Hours_Available) * 100;
      if (Hours_used > 0) and assigned(DailyCapacity.ListIds) then
        for J := 0 to DailyCapacity.ListIds.Count - 1 do
        begin
          JobCapacity := PJobCapacity(DailyCapacity.ListIds[J]);
          if ListId.IndexOf(IntToStr(JobCapacity.id)) <> -1 then continue;
          ListId.Add(IntToStr(JobCapacity.id));
          qty := qty + JobCapacity.qty;
          if CSE_HighEndDate in JobCapacity.errSet then Inc(NumJobsLate);
          if CSE_Materials in JobCapacity.errSet then Inc(NumJobsMaterialProblem);
          if CSE_AddRes in JobCapacity.errSet then Inc(NumJobsAddresProblem);
        end;
    end;
  finally
    ListId.Free;
  end;
end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.GetNumSonsEntityDailyCapacityList : integer;
begin
  result := m_WkcByEntityDailyCapacityList.Count
end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.HasEntityDailyCapacityData : boolean;
var I, J : Integer;
    EntityList : TList;
begin
  Result := False;
  for I := 0 to m_WkcByEntityDailyCapacityList.Count - 1 do
  begin
    EntityList := PTWkcDailyCapacityByEntity(m_WkcByEntityDailyCapacityList[I]).m_WkcDailyCapacityList;
    if not Assigned(EntityList) then continue;
    for J := 0 to EntityList.Count - 1 do
      if PWkcDailyCapacity(EntityList[J]).Hours_Used > 0 then
      begin
        Result := True;
        exit;
      end;
  end;
end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.GetEntityDailyCapacity(I : integer) : string;
begin
  Result := PTWkcDailyCapacityByEntity(m_WkcByEntityDailyCapacityList[I]).m_code
end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.GetEntityDescDailyCapacity(I : integer) : string;
begin
  Result := PTWkcDailyCapacityByEntity(m_WkcByEntityDailyCapacityList[I]).m_Desc
end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.GetEntityPropDailyCapacity(I : integer) : string;
begin
  Result := PTWkcDailyCapacityByEntity(m_WkcByEntityDailyCapacityList[I]).m_Propcode
end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.GetWkcProcList : TWkcProcList;
begin
  Result := m_wkcProc;
end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.GetProcess(i: integer): string;
begin
  Assert(i < m_wkcProc.m_list.Count);
  Result := PTWkcProcRec(m_wkcProc.m_list[i]).proc;
end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.ProcessCount : Integer;
begin
  Result := m_wkcProc.m_list.Count;
end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.GetWrctrLevelPropListCount : Integer;
begin
  Result := m_WrctrLevelPropList.Count;
end;

//----------------------------------------------------------------------------//

procedure TMqmWrkCtr.AddAltWkc(proc: string; altWkc: TMqmWrkCtr; altProc: string);
var
  AltProcList: TAltProcList;
begin
  AltProcList := m_wkcProc.GetAltProcList(proc, true);
  if Assigned(AltProcList) then
    AltProcList.AddItem(altWkc, altProc)
end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.GetAltProcForAltWrkCtr(WrkCtrProc: string; AltWkcCode: string; var AltProc: string): boolean;
var
  AltProcList: TAltProcList;
begin
  Result := false;
  if not Assigned(m_wkcProc) then exit;
  if m_wkcProc = nil then exit;
  if not Assigned(m_wkcProc.m_list) then exit;
  if m_wkcProc.m_list = nil then exit;
  AltProcList := m_wkcProc.GetAltProcList(WrkCtrProc, false);
  if Assigned(AltProcList) and Assigned(AltProcList.m_list) then
    Result := AltProcList.GetProcForWrkCtr(AltWkcCode, AltProc)
end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.GetAltWrkCtrForAltProc(WrkCtrProc: string; AltProc: string; var AltWrkCtr: TMqmWrkCtr): boolean;
var
  AltProcList: TAltProcList;
begin
  Result := false;
  AltProcList := m_wkcProc.GetAltProcList(WrkCtrProc, false);
  if Assigned(AltProcList) then
    Result := AltProcList.GetWrkCtrForProc(AltProc, AltWrkCtr);
end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.IsAlternative(AltWrkCtrCode, AltWrkCtrProc: string): boolean;
begin
  result := true;
end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.GetValueForProperty(pID: TPropID; mtx: TCompatMatrix;
                                        proc, cat: string): TPropRes;
var
  mtxVal: TOrigMatrix;
begin
  Result := nil;
  mtxVal := m_propMtx[PropMtxMap[mtx]];
  if not Assigned(mtxVal) then exit;

  case mtx of
  CMX_code:      Result := TPropRes(TOneDmatrix(mtxVal).GetObject(pID));
  CMX_code_proc: Result := TPropRes(TTwoDmatrix(mtxVal).GetObject(pID,proc));
  CMX_code_cat:  Result := TPropRes(TTwoDmatrix(mtxVal).GetObject(pID,cat));
  else
    Assert(false)
  end
end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.AddWrctrLevelPropToList(pID: TPropID) : boolean;
begin
  Result := true;
  if not assigned(m_WrctrLevelPropList) then
    m_WrctrLevelPropList := TList.Create;
  m_WrctrLevelPropList.Add(Pid);
end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.GetPropIdInWrctrLevelList(pID: TPropID) : boolean;
var
  I : Integer;
begin
  Result := false;
  if not assigned(m_WrctrLevelPropList) then exit;
  for I := 0 to m_WrctrLevelPropList.Count - 1 do
    if m_WrctrLevelPropList[I] = pID then
    begin
      Result := true;
      Exit;
    end;
end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.GetRuleRtoOfForProperty(pID: TPropID; mtx: TCompatMatrix;
                                             proc, prod, cat: string): TCompRules;
var
  mtxVal: TOrigMatrix;
begin
  Result := nil;
  if RulesRtoOMtxMap[mtx] = -1 then exit;
  mtxVal := m_rulesRtoOMtx[RulesRtoOMtxMap[mtx]];
  if not Assigned(mtxVal) then exit;

  case mtx of
  CMX_code:           Result := TCompRules(TOneDmatrix(mtxVal).GetObject(pID));
  CMX_code_proc:      Result := TCompRules(TTwoDmatrix(mtxVal).GetObject(pID,proc));
  CMX_code_prod:      Result := TCompRules(TTwoDmatrix(mtxVal).GetObject(pID,prod));
  CMX_code_cat:       Result := TCompRules(TTwoDmatrix(mtxVal).GetObject(pID,cat));
  CMX_code_prod_cat:  Result := TCompRules(TThreeDmatrix(mtxVal).GetObject(pID,prod,cat));
  CMX_code_prod_proc: Result := TCompRules(TThreeDmatrix(mtxVal).GetObject(pID,prod,proc));
  end
end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.GetRuleOtoOfForProperty(pID: TPropID; mtx: TCompatMatrix;
                                             proc, prod, cat: string): TCompRules;
var
  mtxVal: TOrigMatrix;
begin
  Result := nil;
  if RulesOtoOMtxMap[mtx] = -1 then exit;
  mtxVal := m_rulesOtoOMtx[RulesOtoOMtxMap[mtx]];
  if not Assigned(mtxVal) then exit;

  case mtx of
  CMX_code:           Result := TCompRules(TOneDmatrix(mtxVal).GetObject(pID));
  CMX_code_proc:      Result := TCompRules(TTwoDmatrix(mtxVal).GetObject(pID,proc));
  CMX_code_prod:      Result := TCompRules(TTwoDmatrix(mtxVal).GetObject(pID,prod));
  CMX_code_cat:       Result := TCompRules(TTwoDmatrix(mtxVal).GetObject(pID,cat));
  CMX_code_prod_cat:  Result := TCompRules(TThreeDmatrix(mtxVal).GetObject(pID,prod,cat));
  CMX_code_prod_proc: Result := TCompRules(TThreeDmatrix(mtxVal).GetObject(pID,prod,proc));
  end
end;

//----------------------------------------------------------------------------//

procedure TMqmWrkCtr.GetPropMtxs(lst: TList; upChain: boolean);
var
  cmpM: TCompatMatrix;
begin
  for cmpM := Low(TCompatMatrix) to High(TCompatMatrix) do
  begin
    if (PropMtxMap[cmpM] = -1) or
       (not Assigned(m_propMtx[PropMtxMap[cmpM]])) then continue;
    lst.Add(m_propMtx[PropMtxMap[cmpM]])
  end;

  if upChain then
    GlobGetPropMtxs(lst)
end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.GetRulesRtoOMtxs: TList;
var
  cmpM: TCompatMatrix;
begin
  Result := TList.Create;

  for cmpM := Low(TCompatMatrix) to High(TCompatMatrix) do
  begin
    if (RulesRtoOMtxMap[cmpM] = -1) or
       (not Assigned(m_rulesRtoOMtx[RulesRtoOMtxMap[cmpM]])) then continue;
    Result.Add(m_rulesRtoOMtx[RulesRtoOMtxMap[cmpM]])
  end
end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.GetRulesOtoOMtxs: TList;
var
  cmpM: TCompatMatrix;
begin
  Result := TList.Create;

  for cmpM := Low(TCompatMatrix) to High(TCompatMatrix) do
  begin
    if (RulesOtoOMtxMap[cmpM] = -1) or
       (not Assigned(m_rulesOtoOMtx[RulesOtoOMtxMap[cmpM]])) then continue;
    Result.Add(m_rulesOtoOMtx[RulesOtoOMtxMap[cmpM]])
  end
end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.GetSetupParms(scObj, scObjPrec: TSchedID; var supRec: TSetupRec;
                                  var compatVal: TCompatVal ; var SameGroup : boolean): boolean;
var
  i:                 integer;
  rule:              TCompRules;
  tmpComp, DefVal:   TCompatVal;
  pId:               TPropID;
  propScObj,
  propScObjPrec:     TProperties;
  procScObjInfo,
  procScObjPrecInfo: TSQprocInfo;
  scObjPropVal,
  scObjPrecPropVal:  variant;
  tmpSupRec:         TSetupRec;
  tpLink:            TCompatTopoLink;
  mtx:               TCompatMatrix;
  pos, SameGroupInt:               integer;
  PropRscCode, CurveCode:       string;
  IsSameGroup:       boolean;
begin
  DefVal  := CompValNotDef;
  tmpComp := CompValNotDef;
  propScObj := p_sc.GetProperties(scObj, self);
  p_sc.GetProcInfo(scObj, procScObjInfo);

  propScObjPrec := p_sc.GetProperties(scObjPrec, self);
  p_sc.GetProcInfo(scObjPrec, procScObjPrecInfo);

  // if no rule is found are used these default values
  Result                := false;
  compatVal             := CompValBest -1;
  supRec.supAdjType     := CSA_copy;
  supRec.supTime        := 0;
  supRec.supOverlap     := 0;
  supRec.supMult        := 1;
  supRec.supMultOverlap := 1;

  for i := 0 to propScObj.p_PropCount - 1 do
  begin
    scObjPropVal := propScObj.GetProperty(i, pId, PropRscCode);

    if IsPropDynamic(pId) then
    begin
      scObjPropVal := p_sc.GetPropDinamicVal(scObj,scObjPropVal);
      scObjPropVal := round(scObjPropVal);
    end;

    if PropRscCode <> '' then continue;

    // Find the level of occupation to occupation rules for the property and
    // discard properties that need reference to resources or resource categories
    GetPropCoordForOtoOcomp(pID, tpLink, mtx);
    if tpLink in [CTL_none,CTL_cat,CTL_res]       then continue;
    if mtx    in [CMX_code_cat,CMX_code_prod_cat] then continue;

    // The property is not found for the job in the job property list //
    if not propScObjPrec.GetValforProp(pId, scObjPrecPropVal) then continue;

    if IsPropDynamic(pId) then
    begin
      scObjPrecPropVal := p_sc.GetPropDinamicVal(scObjPrec,scObjPrecPropVal);
      scObjPrecPropVal := round(scObjPrecPropVal);
    end;

    if tpLink = CTL_global then
      rule := GetGlobRuleOtoOfForProperty(pID, procScObjInfo.prodType, mtx)
    else
      rule := GetRuleOtoOfForProperty(pId, mtx, procScObjInfo.process, procScObjInfo.prodType, '');

    if Assigned(rule) then
       tmpComp := rule.EvaluateSetupParms(scObjPropVal, scObjPrecPropVal, DefVal, propScObj, propScObjPrec, pID, tmpSupRec, pos, IsSameGroup, SameGroupInt, CurveCode);

    if Assigned(rule) and tmpSupRec.RuleFound then
    begin
      if tmpSupRec.supTime > supRec.supTime then
         supRec := tmpSupRec;

      if (not IsSameGroup) then
          SameGroup := false;

      if Assigned(FBin) and (FBin.GetGroupTypeCreate = CSM_Automatic) and (SameGroupInt = 2) then
          SameGroup := false;

      CurveCode := supRec.CurveCode;

      if tmpComp > compatVal then
      begin
         compatVal := tmpComp;
         Result    := true
      end

    end

    else

    begin
      // Find the level of resource property connection and
      // discard properties that need reference to resources or resource categories
      GetPropCoordForValue(pID, tpLink, mtx);
      if tpLink in [CTL_none,CTL_cat,CTL_res]       then continue;
      if mtx    in [CMX_code_cat,CMX_code_prod_cat] then continue;

      if tpLink = CTL_global then
      begin
        if not assigned(GetGlobValueForProperty(pID, mtx)) then
        begin
          //  SameGroup := false  - avi 16/10/2008
        end
        else
        begin
          DefVal := GetGlobValueForProperty(pID, mtx).m_dfltOccOcc;
          if (GetGlobValueForProperty(pID, mtx).m_dfltSameGrp = 0) then
             SameGroup := false
          else
            if Assigned(FBin) and (FBin.GetGroupTypeCreate = CSM_Automatic) and
              (GetGlobValueForProperty(pID, mtx).m_dfltSameGrp = 2) then
               SameGroup := false;
        end;
      end
      else
      begin
        if (GetValueForProperty(pId, mtx, procScObjInfo.process, '') = nil) then continue;
        DefVal := GetValueForProperty(pId, mtx, procScObjInfo.process, '').m_dfltOccOcc;
        if (GetValueForProperty(pId, mtx, procScObjInfo.process, '').m_dfltSameGrp = 0) then
           SameGroup := false
        else
          if Assigned(FBin) and (FBin.GetGroupTypeCreate = CSM_Automatic) and
          (GetValueForProperty(pId, mtx, procScObjInfo.process, '').m_dfltSameGrp = 2) then
             SameGroup := false;
      end;

      if DefVal > compatVal then compatVal := DefVal;
         Result    := true;

    end;
  end;

  if compatVal < CompValBest then
    compatVal := CompValBest;
end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.AddProperty(code: string; var val: TPropResRec; ErrList: TStringList): boolean;
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
  //Assert(tpLink = CTL_wkc);

  Assert(PropMtxMap[mtx] <> -1);
  if not Assigned(m_propMtx[PropMtxMap[mtx]]) then
    CreateMatrix(m_propMtx[PropMtxMap[mtx]], mtx);

  mtxVal := m_propMtx[PropMtxMap[mtx]];

  case mtx of
  CMX_code:      TOneDmatrix(mtxVal).AddObject(pId, propRes);
  CMX_code_proc: TTwoDmatrix(mtxVal).AddObject(pId, val.proc, propRes);
  CMX_code_cat:  TTwoDmatrix(mtxVal).AddObject(pId, val.resCat, propRes)
  end;

  Result := true
end;

//----------------------------------------------------------------------------//

procedure AssignRuleToMat(pId: TPropID; mtx: TCompatMatrix; mtxVal: TOrigMatrix;
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
                      end;

  CMX_code_cat: begin //  code and resource category
                  twoDmtx := TTwoDmatrix(mtxVal);
                  rule := TCompRules(twoDmtx.GetObject(pId, val.resCat));
                  if not Assigned(rule) then
                  begin
                    rule := TCompRules.Create;
                    twoDmtx.AddObject(pId, val.resCat, rule)
                  end
                end;

  CMX_code_prod_cat: begin // code, product type and resource category
                       threeDmtx := TThreeDmatrix(mtxVal);
                       rule := TCompRules(threeDmtx.GetObject(pId, val.prodType, val.resCat));
                       if not Assigned(rule) then
                       begin
                         rule := TCompRules.Create;
                         threeDmtx.AddObject(pId, val.prodType, val.resCat, rule)
                       end
                     end
  end;

  Assert(Assigned(rule));

  if not isOtoO then
    rule.AddItem(val.checkSeq, val.toBase, vrnt, val.op, val.comp, nil)
  else
  begin
    sup.Value       := ConvPropValue(pId, val.constStr);
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

    sup.Teoreticl_wc := val.Teoreticl_wc;
    sup.duration := val.duration;
    sup.LeadTime := val.LeadTime;
    sup.FromPos          := val.FromPos;
    sup.Length           :=  val.Length;
    sup.RuleForPartialPropVal := val.RuleForPartialPropVal;
    sup.WhenOkNextSeq    := val.WhenOkNextSeq;
    sup.NumOfdec         := val.NumOfdec;
    sup.Sequence         := val.Sequence;
    sup.CurveCode        := val.CurveCode;

    rule.AddItem(val.checkSeq, val.toBase, vrnt, val.op, val.comp, @sup)
  end
end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.AddRtoOrule(code: string; var val: TRuleResRec; ErrList: TStringList): boolean;
var
  pId:       TPropID;
  tpLink:    TCompatTopoLink;
  mtx:       TCompatMatrix;
  vrnt:      variant;
begin
  pId := DecodePropRule(code, val.valStr, vrnt);
  if not Assigned(pId) then
  begin
    ErrList.Add(_('Error loading property') + ' ' + code);
    Result := false;
    exit
  end;

  GetPropCoordForRtoOcomp(pId, tpLink, mtx);
  if tpLink <> CTL_wkc then
  begin
    ErrList.Add(_('mismatch between property definition of occupation to resource level and the actual rules data for property : ') + ' ' + code);
    Result := false;
    exit
  end;

  Assert(RulesRtoOMtxMap[mtx] <> -1);
  if not Assigned(m_rulesRtoOMtx[RulesRtoOMtxMap[mtx]]) then
    CreateMatrix(m_rulesRtoOMtx[RulesRtoOMtxMap[mtx]], mtx);

  AssignRuleToMat(pId, mtx, m_rulesRtoOMtx[RulesRtoOMtxMap[mtx]], false, vrnt, val);
  Result := true
end;

//----------------------------------------------------------------------------//

function TMqmWrkCtr.AddOtoOrule(code: string; var val: TRuleResRec; ErrList: TStringList): boolean;
var
  pId:    TPropID;
  tpLink: TCompatTopoLink;
  mtx:    TCompatMatrix;
  vrnt:   variant;
begin
  pId := DecodeProp(code, val.valStr, vrnt);
  if not Assigned(pId) then
  begin
    ErrList.Add(GetDescr + ': ' + _('Error loading property') + ' ' + code);
    Result := false;
    exit
  end;

  GetPropCoordForOtoOcomp(pId, tpLink, mtx);
  //Assert(tpLink = CTL_wkc);
  if (tpLink <> CTL_wkc) then
  begin
    ErrList.Add(GetDescr + ': ' + _('Error loading property') + ' ' + code +
            _(' connection level should be defined as Work center level ') +
       #13#10 + _('Program Will Be Terminated'));
    Result := false;
    exit
  end;

  Assert(RulesOtoOMtxMap[mtx] <> -1);
  if not Assigned(m_rulesOtoOMtx[RulesOtoOMtxMap[mtx]]) then
    CreateMatrix(m_rulesOtoOMtx[RulesOtoOMtxMap[mtx]], mtx);

  AssignRuleToMat(pId, mtx, m_rulesOtoOMtx[RulesOtoOMtxMap[mtx]], true, vrnt, val);
  Result := true
end;

//----------------------------------------------------------------------------//
// TWkcDepList
//----------------------------------------------------------------------------//

constructor TWkcDepList.Create;
begin
  m_list := TList.Create;
end;

//----------------------------------------------------------------------------//

destructor TWkcDepList.Destroy;
var
  i:    integer;
  prec: PTWkcDependency;
begin
  for i := 0 to m_list.Count-1 do
  begin
    prec := PTWkcDependency(m_list[i]);
    Dispose(prec)
  end;
  m_list.Free
end;

//----------------------------------------------------------------------------//

procedure TWkcDepList.AddDep(DepRec: PTWkcDependency);
begin
  m_list.Add(DepRec)
end;

//----------------------------------------------------------------------------//

function TWkcDepList.GetCount: integer;
begin
  Result := m_list.Count
end;

//----------------------------------------------------------------------------//

function TWkcDepList.GetDepRec(RecIndex: integer): PTWkcDependency;
begin
  Result := PTWkcDependency(m_list[RecIndex])
end;

//----------------------------------------------------------------------------//
{ TAltLav }
//----------------------------------------------------------------------------//

function TAltProcList.GetAltCount : integer;
begin
  if not Assigned(m_list) then
    Result := 0
  else
    Result := m_list.Count
end;

//----------------------------------------------------------------------------//

function TAltProcList.GetAltWc(I : integer) : TMqmWrkCtr;
var
  prec: PTAltProcRec;
begin
  prec := PTAltProcRec(m_list[I]);
  Result := prec.Wc
end;

//----------------------------------------------------------------------------//

function TAltProcList.GetAltWcSDesc(I : integer) : string;
var
  prec: PTAltProcRec;
begin
  prec := PTAltProcRec(m_list[I]);
  Result := prec.Wc.p_WrkCtrSDesc;
end;

//----------------------------------------------------------------------------//

function TAltProcList.GetAltProccess(I : integer) : string;
var
  prec: PTAltProcRec;
begin
  prec := PTAltProcRec(m_list[I]);
  Result := prec.proc;
end;

//----------------------------------------------------------------------------//

function TAltProcList.GetAltProcDesc(Proc: string) : string;
var
  prec: PTAltProcRec;
  i: integer;
begin
  for i := 0 to m_list.Count-1 do
  begin
    prec := PTAltProcRec(m_list[I]);
    if prec.proc = Proc then
      Result := prec.ProcDesc;
    break
  end
end;

//----------------------------------------------------------------------------//

procedure TAltProcList.AddItem(wc: TMqmWrkCtr; proc: string);
var
  prec: PTAltProcRec;
begin
  New(prec);
  prec.wc   := wc;
  prec.proc := proc;
  prec.ProcDesc := wc.GetProcDesc(proc);
  m_list.Add(prec)
end;

//----------------------------------------------------------------------------//

constructor TAltProcList.Create;
begin
  m_list := TList.Create;
end;

//----------------------------------------------------------------------------//

destructor TAltProcList.Destroy;
var
  i:    integer;
  prec: PTAltProcRec;
begin
  for i := 0 to m_list.Count-1 do
  begin
    prec := PTAltProcRec(m_list[i]);
    Dispose(prec)
  end;
  m_list.Free
end;

//----------------------------------------------------------------------------//

function TAltProcList.GetProcForWrkCtr(WkcCode: string; var Proc: string): boolean;
var
  i:    integer;
  prec: PTAltProcRec;
begin
  for i := 0 to m_list.Count-1 do
  begin
    prec := PTAltProcRec(m_list[I]);
    if (prec.Wc.p_WrkCtrCode = WkcCode) then
    begin
      Proc := prec.proc;
      Result := true;
      exit
    end
  end;
  Result := false
end;

//----------------------------------------------------------------------------//

function TAltProcList.GetWrkCtrForProc(Proc: string; var WrkCtr: TMqmWrkCtr) : boolean;
var
  i:    integer;
  prec: PTAltProcRec;
begin
  for i := 0 to m_list.Count-1 do
  begin
    prec := PTAltProcRec(m_list[I]);
    if (prec.proc = Proc) then
    begin
      WrkCtr := prec.wc;
      Result := true;
      exit
    end
  end;
  Result := false
end;

//----------------------------------------------------------------------------//
{ TWkcProc }
//----------------------------------------------------------------------------//

function TWkcProcList.GetAltProcListCount(proc: string) : Integer;
var
  alt: TAltProcList;
begin
  alt := GetAltProcList(proc, false);
  if Assigned(alt) then
    Result := alt.m_list.count
  else
    Result := 0
end;

//----------------------------------------------------------------------------//

constructor TWkcProcList.Create;
begin
  m_list := TList.Create;
end;

//----------------------------------------------------------------------------//

destructor TWkcProcList.Destroy;
var
  i:   integer;
  rec: PTWkcProcRec;
begin
  for i := 0 to m_list.Count-1 do
  begin
    rec := PTWkcProcRec(m_list[i]);
    if Assigned(rec.RecPriority) then
      Dispose(rec.RecPriority);
    if Assigned(rec.AltProcList) then
      rec.AltProcList.Free;
    if Assigned(rec.DependencyList) then
      rec.DependencyList.Free;
    Dispose(rec);
  end;
  m_list.Free
end;

//----------------------------------------------------------------------------//

function TWkcProcList.IsIn(proc: string): boolean;
var
  i:   integer;
  rec: PTWkcProcRec;
begin
  Result := true;

  for i := 0 to m_list.Count-1 do
  begin
    rec := PTWkcProcRec(m_list[i]);
    if (rec.proc = proc) then
      exit;
  end;

  Result := false;
end;

//----------------------------------------------------------------------------//

function TWkcProcList.GetGroupType(proc: string) : CGroupingType;
var
  rec: PTWkcProcRec;
  i:   integer;
begin
  Result := Single_grp;
  for i := 0 to m_list.Count-1 do
  begin
    rec := PTWkcProcRec(m_list[i]);
    if rec.proc = proc then
    begin
      Result := rec.GroupingType;
      exit
    end
  end;
end;

//----------------------------------------------------------------------------//

function TWkcProcList.GetResOccupationType(proc: string) : CSResOccupation;
var
  rec: PTWkcProcRec;
  i:   integer;
begin
  Result := CSResOcc_No;
  for i := 0 to m_list.Count-1 do
  begin
    rec := PTWkcProcRec(m_list[i]);
    if rec.proc = proc then
    begin
      Result := rec.ResOccupation;
      exit
    end
  end;
end;

//----------------------------------------------------------------------------//

function TWkcProcList.GetProcCount: Integer;
begin
  Result := m_list.Count
end;

//----------------------------------------------------------------------------//

function TWkcProcList.GetProc(i: integer): PTWkcProcRec;
begin
  Result := PTWkcProcRec(m_List[i])
end;

//----------------------------------------------------------------------------//

function TWkcProcList.GetProcByName(Proc: string): PTWkcProcRec;
var
  i: integer;
  ProcRec: PTWkcProcRec;
begin
  Result := nil;
  for i := 0 to m_list.Count -1 do
  begin
    ProcRec := PTWkcProcRec(m_list[i]);
    if ProcRec.proc = Proc then
    begin
      Result := ProcRec;
      break
    end
  end;
end;

//----------------------------------------------------------------------------//

procedure TWkcProcList.AddProc(rec: PTWkcProcRec);
begin
  m_list.Add(rec)
end;

//----------------------------------------------------------------------------//

function TWkcProcList.GetProcDesc(proc: string) : string;
var
  rec: PTWkcProcRec;
  i:   integer;
begin
  for i := 0 to m_list.Count-1 do
  begin
    rec := PTWkcProcRec(m_list[i]);
    if rec.proc = proc then
    begin
      Result := rec.ProcDesc;
      exit
    end
  end;
  Result := '';
end;

//----------------------------------------------------------------------------//

function TWkcProcList.GetAltProcList(proc: string; toAdd: boolean): TAltProcList;
var
  rec: PTWkcProcRec;
  i:   integer;
begin
  for i := 0 to m_list.Count-1 do
  begin
    rec := PTWkcProcRec(m_list[i]);
    if rec.proc = proc then
    begin
      if toAdd and (not Assigned(rec.AltProcList)) then
        rec.AltProcList := TAltProcList.Create;
      Result := rec.AltProcList;
      exit
    end
  end;
  Result := nil
end;

//----------------------------------------------------------------------------//

function TWkcProcList.GetUseAllMachinePartsProcess(proc: string) : CUseMachineParts;
var
  rec: PTWkcProcRec;
  i:   integer;
begin
  result := Mp_Non;
  for i := 0 to m_list.Count-1 do
  begin
    rec := PTWkcProcRec(m_list[i]);
    if rec.proc = proc then
    begin
      Result := rec.UseAllMachineParts;
      exit
    end
  end;
end;

//----------------------------------------------------------------------------//

end.

