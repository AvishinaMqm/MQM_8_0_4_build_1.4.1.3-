unit UMOpStack;

interface

uses
  classes,
  SysUtils,
  UMSchedCont,
  UMSchedContFunc,
  UMCapRes,
  UMPlanObj,
  UMDurObj,
  UMRes,
  UMActArea;

type

  TStackMark = integer;

  TOpStack = class
    constructor CreateStack;
    destructor  Destroy; override;

    // settings for the stack
    function  MarkStack: TStackMark;
    procedure MarkStackForButtonUndo(Desc: string);
    procedure Undo;
    procedure UndoAll;
    procedure UndoTo(Mark: TStackMark);
    procedure UndoByMark(ToMark: TStackMark);

    procedure UndoByMarkTest(ToMark: TStackMark);


    procedure UndoByButtonForStatistic(UndoLoop : integer);
    procedure UndoByButton;// (StackMark: TStackMark);
    function  GetCount(out sHint: string): integer;
    function  GetUndoListCount : integer;
    procedure Clear;

    // available operations
    function CreatePlanObj(const pObj: TMqmDurObj): boolean;
    function DeleSchedObj(const id: TSchedID): boolean;
    function AddJobToGroup(const job, grp: TSchedID): boolean;
    function RemoveJobFromGroup(const id: TSchedID; Reason: string = ''): boolean;
    function CreateGroup(const job: TSchedID; var grp: TSchedID): boolean;
    function SplitJob(const job: TSchedID; OrigJobQty, EachJobQty: currency; NewJobNr: integer; var NewId : TSchedID; var List : TList): boolean;
    function JoinJobs(const job: TSchedID; JobsList: TList): boolean;
    function ReprocJob(const job: TSchedID; ReprocQty: currency): boolean;
    function SetForwardConn(const job: TSchedID; jobToConn: TSchedID): boolean;
    function SetBackwardConn(const job: TSchedID; jobToConn: TSchedID): boolean;
    function ResetForwardConn(const job: TSchedID; jobToConn: TSchedID): boolean;
    function ResetBackwardConn(const job: TSchedID; jobToConn: TSchedID): boolean;

    function ChgOccDurData(const id: TSchedID; var planInfo: TSQplanInfo): boolean;
    function ChgOccDurGenericPlan(const id: TSchedID; var planInfo: TSQplanInfo): boolean;
    function ChgOccMoveData(const id: TSchedID; var moveChg: TSQmoveChgInfo): boolean;
    function ChgProgressStatus(const id: TSchedID): boolean;
    function SetSchedType(const id: TSchedID; sSchedType: string): boolean;
    function LinkOccToApa(const id: TSchedID; apa: TMqmActArea): boolean;
    function DetachOccFromApa(const id: TSchedID; apa: TMqmActArea): boolean;
    function DetachOccFromApaInSameActArea(const id: TSchedID; apa: TMqmActArea): boolean;
    function DetachGenInfoFromApa(const id: TSchedID; var planInfo: TSQplanInfo): boolean;
    function UpdateOvlpLimits(const id: TSchedID; Res: TMqmRes): boolean;
    function UpdateBalance(const id: TSchedID): boolean;
    Procedure ClearBalance(const id: TSchedID);

    function ChgPlanObjDurData(const pObj: TMqmDurObj): boolean;
    function LinkPlanObjToApa(const pObj: TMqmDurObj; apa: TMqmActArea): boolean;
    function DetachPlanObjFromApa(const pObj: TMqmDurObj): boolean;
    function DelePlanObjFromApa(const pObj: TMqmDurObj; apa: TMqmActArea): boolean;

    function ChangeQuantity(const job: TschedID; modifiedQty: double; getChgQtyVal: boolean; chgstepQty: boolean): String;
    function UpdateSchedQuantity(const job: TSchedID; oldQty: double; newQty: double): String;

    function GetBkInfo(Op: Pointer): pointer;
    function GetUndoLoopForStatistic : Integer;
    procedure ResetUndoLoopForStatistic;
  private
    m_UndoLoopForStatistic : Integer;
    m_pointGen: TStackMark;
    m_list:     TList;
    m_UndoList: TList;
  end;

implementation

uses
  UMObjCont,
  UMSchedList,
  UMGlobal,
  UMPlanFunc,
  UMGenericSchedulePrevStep,
  UMSchedObjMover,
  UMWarp,
  FMMainPlan;

type

  TOperation = class
    constructor CreateOp;
    procedure Undo; virtual; abstract;
  private
    m_pointGen: TStackMark
  end;

  TOperationSched = class(TOperation)
    constructor CreateOpSched(id: TSchedID);
    destructor  Destroy; override;

    procedure Undo; override;
    function GetBkInfo: pointer; virtual;
  private
    m_idStatus: CScStatus;
    m_idRef:    TSchedId;
  end;

  TOperationPlan = class(TOperation)
    constructor CreateOpPlan(pObj: TMqmDurObj);
    destructor  Destroy; override;

    procedure Undo; override;
  private
    m_ObjStatus: CDurStatus;
    m_pObj: TMqmDurObj
  end;

  TOpChgOccDur = class(TOperationSched)
    constructor CreateChgOccDur(const id: TSchedID; var planInfo: TSQplanInfo);
    procedure Undo; override;
    function GetBkInfo: pointer; override;
  private
    m_planInfo: TSQplanInfo;
  end;

  TOpChgGenericPlanDur = class(TOperationSched)
    constructor CreateChgGenericPlanDur(const id: TSchedID; var planInfo: TSQplanInfo);
    procedure Undo; override;
  private
    m_planInfo: TSQplanInfo;
  end;

  TOpDetachGenInfoApa = class(TOperationSched)
    constructor CreateDetachGenInfoApa(const id: TSchedID; var planInfo: TSQplanInfo);
    procedure Undo; override;
  private
    m_planInfo: TSQplanInfo;
  end;

  TOpChgMoveDt = class(TOperationSched)
    constructor CreateChgMoveDt(const id: TSchedID; var moveChg: TSQmoveChgInfo);
    procedure Undo; override;
  private
    m_moveChg: TSQmoveChgInfo;
  end;

  TOpChgProgressStatus = class(TOperationSched)
    constructor CreateChgProgressStatus(const id: TSchedID;
      var snap: TSQProgressSnapshot; var planInfo: TSQplanInfo; var moveChg: TSQmoveChgInfo);
    procedure Undo; override;
  private
    m_progSnap : TSQProgressSnapshot;
    m_planInfo : TSQplanInfo;
    m_moveChg  : TSQmoveChgInfo;
  end;

  TOpSetSchedType = class(TOperationSched)
    constructor CreateSetSchedType(const id: TSchedID);
    procedure Undo; override;
  private
    m_SchedType: string;
    m_JobComponents : integer
  end;

  TOpChgPlanObjDur = class(TOperationPlan)
    constructor CreateChgPlanObjDur(const pObj: TMqmDurObj);
    procedure Undo; override;
  private
    m_startDate: TDateTime;
    m_EndDate: TDateTime;

    m_DurDouble : double;
    m_Dur: integer;
  end;

  TOpCreatePlanObj = class(TOperationPlan)
    constructor CreatePlanObj(const pObj: TMqmDurObj);
    procedure Undo; override;
  end;

  TOpDelSched = class(TOperationSched)
    constructor CreateDelSched(const id: TSchedID);
    procedure Undo; override;
  end;

  TOpAddToGrp = class(TOperationSched)
    constructor CreateAddToGrp(const id: TSchedID);
    procedure Undo; override;
  end;

  TOpRemoveFromGrp = class(TOperationSched)
    constructor CreateRemoveFromGrp(const grp, job: TSchedID);
    procedure Undo; override;
  private
    m_grp: TSchedID;
  end;

  TOpCreateGrp = class(TOperationSched)
    constructor CreateCreateGrp(const id: TSchedID);
    procedure Undo; override;
  private
    m_grp: TSchedID;
  end;

  TOpSplitJob = class(TOperationSched)
    constructor CreateSplitJob(const id: TSchedID);
    procedure Undo; override;
  private
    m_SplitInfo: TSQSplitInfo;
    m_JobList: TList;
  end;

  TOpJoinJobs = class(TOperationSched)
    constructor CreateJoinJobs(const id: TSchedID);
    procedure Undo; override;
  private
    m_planInfo: TSQplanInfo;
    m_JobList: TList;
    m_MaualChange : double;
  end;

  TOpReprocJob = class(TOperationSched)
    constructor CreateReprocJob(const id: TSchedID);
    procedure Undo; override;
  private
    m_NewJob: TSchedID;
  end;

  TOpSetForwardConn = class(TOperationSched)
    constructor CreateSetForwardConn(const id: TSchedID);
    procedure Undo; override;
  private
    m_ConnJob: TSchedID;
    m_ConnSubStep: integer;
    m_ConnReprocNo: integer;
    m_OrigSubStep: integer;
    m_OrigReprocNo: integer;
  end;

  TOpSetBackwardConn = class(TOperationSched)
    constructor CreateSetBackwardConn(const id: TSchedID);
    procedure Undo; override;
  private
    m_ConnJob: TSchedID;
    m_ConnSubStep: integer;
    m_ConnReprocNo: integer;
    m_OrigSubStep: integer;
    m_OrigReprocNo: integer;
  end;

  TOpLinkOccApa = class(TOperationSched)
    constructor CreateLinkOccApa(const id: TSchedID; apa: TMqmActArea);
    procedure Undo; override;
  private
    m_apa: TMqmActArea;
  end;

  TOpDetachOccApa = class(TOperationSched)
    constructor CreateDetachOccApa(const id: TSchedID; apa: TMqmActArea);
    procedure Undo; override;
  private
    m_apa: TMqmActArea;
  end;

  TOpUpdOvlpLimits = class(TOperationSched)
    constructor CreateUpdOvlpLimits(const id: TSchedID);
    procedure Undo; override;
  private
    m_LowLimitDate:   TDateTime;
    m_HighLimitDate:  TDateTime;
  end;

  TOpUpdBalance = class(TOperationSched)
    constructor CreateUpdBalance(const id: TSchedID);
    procedure Undo; override;
  private
    m_idRef:    TSchedId;
  end;

  TOpClrBalance = class(TOperationSched)
    constructor CreateClrBalance(const id: TSchedID);
    procedure Undo; override;
  private
    m_idRef:    TSchedId;
  end;

  TOpLinkPlanObjApa = class(TOperationPlan)
    constructor CreateLinkPlanObjApa(pObj: TMqmDurObj; apa: TMqmActArea);
    procedure Undo; override;
  private
    m_OldApa,
    m_apa: TMqmActArea;
    m_WarpInfo: TPWarpInfo;
  end;

  TOpDelePlanObjApa = class(TOperationPlan)
    constructor CreateDelePlanObjApa(pObj: TMqmDurObj; apa: TMqmActArea);
    procedure Undo; override;
  private
    m_apa: TMqmActArea;
  end;

  TOpDetachPlanObjApa = class(TOperationPlan)
    constructor CreateDetachPlanObjApa(pObj: TMqmDurObj);
    procedure Undo; override;
  private
    m_apa, m_Oldapa: TMqmActArea;
    m_WarpInfo: TPWarpInfo;
  end;

  TOpChangeQuantity = class(TOperationSched)
    constructor CreateQuantityChange(const id: TSchedID; modifiedQty: double; changeStepQty: boolean);
    procedure Undo; override;
  private
    m_ModifiedQty   : double;
    m_ChangeStepQty : boolean;
    m_id            : TSchedID
  end;

  TOpUpdateSchedQuantity = class(TOperationSched)
    constructor CreateUpdateSchedQuantity(const id: TSchedID; oldQty: double);
    procedure Undo; override;
  private
    m_Id     : TSchedID;
    m_OldQty : double;
  end;

  TUndoList = record
    m_StackMark: TStackMark;
    m_sDesc:     string;
  end;

  PTUndoList = ^ TUndoList;

const
  COPemptyStackMark = -1;
  COPnoStackMark    = -2;

//----------------------------------------------------------------------------//

constructor TOpStack.CreateStack;
begin
  inherited Create;
  m_pointGen := 0;
  m_UndoLoopForStatistic := 0;
  m_list     := TList.Create;
  m_UndoList := TList.Create;
end;

//----------------------------------------------------------------------------//

destructor TOpStack.Destroy;
var
  i: integer;
begin
  Clear;

  for i := 0 to m_UndoList.Count-1 do
    Dispose(m_UndoList[i]);

  m_list.Free;
  m_UndoList.Free;

  inherited Destroy
end;

//----------------------------------------------------------------------------//

function TOpStack.MarkStack: TStackMark;
begin
  if m_list.Count = 0 then
    Result := COPemptyStackMark
  else if TOperation(m_list[m_list.Count-1]).m_pointGen <> COPnoStackMark then
    Result := TOperation(m_list[m_list.Count-1]).m_pointGen
  else
  begin
    Result := m_pointGen;
    Inc(m_pointGen);
    TOperation(m_list[m_list.Count-1]).m_pointGen := Result
  end
end;

//----------------------------------------------------------------------------//

procedure TOpStack.MarkStackForButtonUndo(Desc: string);
var
  RecUndoList: PTUndoList;
begin
  New(RecUndoList);

  RecUndoList.m_StackMark := MarkStack;
  RecUndoList.m_sDesc     := Desc;

  m_UndoList.Add(RecUndoList);

{  if m_UndoList.Count > 0 then
  begin
    FMQMPlan.TBUndo.Enabled := True;
    FMQMPlan.MIUndo.Enabled := FMQMPlan.TBUndo.Enabled;
  end}
  Inc(m_UndoLoopForStatistic);
end;

//----------------------------------------------------------------------------//

procedure TOpStack.Undo;
var
  op: TOperation;
begin
  if m_list.Count > 0 then
  begin
    op := TOperation(m_list[m_list.Count-1]);
    op.Undo;
    op.Free;
    m_list.Delete(m_list.Count-1)
  end
end;

//----------------------------------------------------------------------------//

procedure TOpStack.UndoTo(mark: TStackMark);
var
  i:  integer;
  op: TOperation;
begin
  for i := m_list.Count-1 downto 0 do
  begin
    op := TOperation(m_list[i]);
    if op.m_pointGen = mark then exit;
    Undo
  end
end;

//----------------------------------------------------------------------------//

procedure TOpStack.UndoByMark(ToMark: TStackMark);
var
  i:  integer;
  op: TOperation;
begin
  for i := m_list.Count-1 downto 0 do
  begin
    op := TOperation(m_list[i]);
    if op.m_pointGen = ToMark then exit;
    if op.m_pointGen <> COPnoStackMark then
    begin
      op.m_pointGen := COPnoStackMark;
      exit
    end;
    Undo
  end
end;

//----------------------------------------------------------------------------//

procedure TOpStack.UndoByMarkTest(ToMark: TStackMark);
var
  i:  integer;
  op: TOperation;
begin
  for i := m_list.Count-1 downto 0 do
  begin
    op := TOperation(m_list[i]);
    if op.m_pointGen = ToMark then exit;
    if op.m_pointGen <> COPnoStackMark then
    begin
      op.m_pointGen := COPnoStackMark;
      exit
    end;
    Undo
  end
end;


procedure TOpStack.UndoByButtonForStatistic(UndoLoop : integer);
var
  i, J :  integer;
  RecUndo: PTUndoList;
begin

//  for J := 0 to UndoLoop do
//  begin
  for i := m_UndoList.Count-1 downto UndoLoop do
  begin
    RecUndo := m_UndoList[i];

    UndoTo(RecUndo.m_StackMark);
    Dispose(RecUndo);
    m_UndoList.Delete(i);
  //  Break;
  end;
//  end;
end;

//----------------------------------------------------------------------------//

procedure TOpStack.UndoByButton;//(StackMark: TStackMark);
var
  i:  integer;
  RecUndo: PTUndoList;
begin
  Dec(m_UndoLoopForStatistic);
  for i := m_UndoList.Count-1 downto 0 do
  begin
    RecUndo := m_UndoList[i];

    UndoTo(RecUndo.m_StackMark);
    Dispose(RecUndo);
    m_UndoList.Delete(i);

    Break;
  end;
end;

//----------------------------------------------------------------------------//

function TOpStack.GetCount(out sHint: string): integer;
var
  RecUndo: PTUndoList;
begin
  if m_UndoList.Count > 0 then
  begin
    RecUndo := m_UndoList[m_UndoList.Count - 1];
    sHint := RecUndo.m_sDesc;
  end;

  result := m_UndoList.Count;
end;

//----------------------------------------------------------------------------//

function TOpStack.GetUndoListCount : integer;
begin
  Result := m_UndoList.Count
end;

//----------------------------------------------------------------------------//

function TOpStack.GetUndoLoopForStatistic : Integer;
begin
  if m_UndoLoopForStatistic = 0 then
    MarkStackForButtonUndo('Undo For Statistic');
  Result := m_UndoLoopForStatistic
end;

//----------------------------------------------------------------------------//

procedure TOpStack.ResetUndoLoopForStatistic;
var
  I : Integer;
  RecUndo: PTUndoList;
begin
  m_UndoLoopForStatistic := 0;

  for i := m_UndoList.Count-1 downto 0 do
  begin
    RecUndo := m_UndoList[i];
    Dispose(RecUndo);
    m_UndoList.Delete(i);
  end;
  m_UndoList.clear;

end;

//----------------------------------------------------------------------------//

procedure TOpStack.UndoAll;
var
  i:  integer;
begin
  for i := m_list.Count-1 downto 0 do Undo
end;

//----------------------------------------------------------------------------//

procedure TOpStack.Clear;
var
  i: integer;
begin
  for i := m_list.Count-1 downto 0 do
  begin
    TOperation(m_list[i]).Free;
    m_list.Delete(i)
  end;

  for i := m_UndoList.Count-1 downto 0 do
    m_UndoList.Delete(i)
end;

//----------------------------------------------------------------------------//

function TOpStack.GetBkInfo(Op: Pointer): pointer;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to m_list.Count-1 do
    if m_list[i] = op then
      Result := TOperationSched(m_list[i]).GetBkInfo;
end;

//----------------------------------------------------------------------------//

function TOpStack.CreatePlanObj(const pObj: TMqmDurObj): boolean;
var
  crtObj:  TOpCreatePlanObj;
begin
  crtObj := TOpCreatePlanObj.CreatePlanObj(pObj);
  m_list.Add(crtObj);
  Result := true
end;

//----------------------------------------------------------------------------//

function TOpStack.ChgOccDurData(const id: TSchedID; var planInfo: TSQplanInfo): boolean;
var
  oldPlanInfo: TSQplanInfo;
  chgDur:      TOpChgOccDur;
  I : Integer;
  SonId : TSchedID;
begin
  if planInfo.isGroup then
  begin
    for i := 0 to p_sc.GetGrpNumSons(id)-1 do
    begin
      SonId := p_sc.GetGrpSon(id, i);
      p_sc.GetPlanInfo(SonId, oldPlanInfo);
      chgDur := TOpChgOccDur.CreateChgOccDur(SonId, oldPlanInfo);
      m_list.Add(chgDur);
    end;
  end;

  p_sc.GetPlanInfo(id, oldPlanInfo);
  chgDur := TOpChgOccDur.CreateChgOccDur(id, oldPlanInfo);
  if (p_sc.GetSchedObjStatus(id) <> CSS_New)
  and ( (oldPlanInfo.startDate <> planInfo.startDate) or (oldPlanInfo.endDate <> planInfo.endDate) ) then
    p_sc.SetSchedObjStatus(id, CSS_modi);
  m_list.Add(chgDur);
  if not Assigned(p_sc.GetMoveOp(id)) then
    p_sc.SetMoveOp(id, chgDur);

  p_sc.SetPlanInfo(id, planInfo);


  p_sc.UpdateBalance(id);  // fp

  Result := true
end;

//----------------------------------------------------------------------------//

function TOpStack.ChgOccDurGenericPlan(const id: TSchedID; var planInfo: TSQplanInfo): boolean;
var
  oldPlanInfo: TSQplanInfo;
  chgDur:      TOpChgGenericPlanDur;
  I : Integer;
  SonId : TSchedID;
begin
  if planInfo.isGroup then
  begin
    for i := 0 to p_sc.GetGrpNumSons(id)-1 do
    begin
      SonId := p_sc.GetGrpSon(id, i);
      p_sc.GetPlanInfo(SonId, oldPlanInfo);
      chgDur := TOpChgGenericPlanDur.CreateChgGenericPlanDur(SonId, oldPlanInfo);
      m_list.Add(chgDur);
    end;
  end;

  p_sc.GetPlanInfo(id, oldPlanInfo);
  chgDur := TOpChgGenericPlanDur.CreateChgGenericPlanDur(id, oldPlanInfo);
  m_list.Add(chgDur);
  p_sc.SetGenericInfo(id, planInfo);
  Result := true
end;

//----------------------------------------------------------------------------//

function TOpStack.ChgOccMoveData(const id: TSchedID; var moveChg: TSQmoveChgInfo): boolean;
var
  oldMoveChg: TSQmoveChgInfo;
  chgMoveDt:  TOpChgMoveDt;
begin
  p_sc.GetMoveChgInfo(id, oldMoveChg);
  chgMoveDt := TOpChgMoveDt.CreateChgMoveDt(id, oldMoveChg);
  if p_sc.GetSchedObjStatus(id) <> CSS_New then
      p_sc.SetSchedObjStatus(id, CSS_modi);
  m_list.Add(chgMoveDt);
  p_sc.SetMoveChgInfo(id, moveChg);
  Result := true
end;

//----------------------------------------------------------------------------//

function TOpStack.ChgProgressStatus(const id: TSchedID): boolean;
var
  planInfo: TSQplanInfo;
  i:        integer;
  sonId:    TSchedID;

  procedure PushOne(const aId: TSchedID);
  var
    snap:    TSQProgressSnapshot;
    pInfo:   TSQplanInfo;
    mChg:    TSQmoveChgInfo;
    chgProg: TOpChgProgressStatus;
  begin
    p_sc.GetProgressSnapshot(aId, snap);
    p_sc.GetPlanInfo(aId, pInfo);
    p_sc.GetMoveChgInfo(aId, mChg);
    chgProg := TOpChgProgressStatus.CreateChgProgressStatus(aId, snap, pInfo, mChg);
    if p_sc.GetSchedObjStatus(aId) <> CSS_New then
      p_sc.SetSchedObjStatus(aId, CSS_modi);
    m_list.Add(chgProg);
  end;

begin
  p_sc.GetPlanInfo(id, planInfo);
  if planInfo.isGroup then
  begin
    for i := 0 to p_sc.GetGrpNumSons(id)-1 do
    begin
      sonId := p_sc.GetGrpSon(id, i);
      PushOne(sonId);
    end;
  end
  else
    PushOne(id);
  Result := true
end;

//----------------------------------------------------------------------------//

function TOpStack.SetSchedType(const id: TSchedID; sSchedType: string): boolean;
var
  SetSchedType:  TOpSetSchedType;
  planInfo: TSQplanInfo;
  CurrentSchedType : string;
  Request, Step, SubStep, qty : variant;
  dataType: CBinColValType;
begin
  SetSchedType := TOpSetSchedType.CreateSetSchedType(id);
  p_sc.GetPlanInfo(id,planInfo);

  if (p_sc.GetSchedObjStatus(id) <> CSS_New) and (planInfo.VisibleInBin <> CSB_ReadOnly) then
    p_sc.SetSchedObjStatus(id, CSS_modi);

  CurrentSchedType := p_sc.GetSchedType(id);
  if (CurrentSchedType = '2') and (sSchedType <> '2') then
  begin
    p_sc.GetFldValue(Id, CSC_ProdReq, Request, dataType);
    p_sc.GetFldValue(Id, CSC_ProdStep, Step, dataType);
    p_sc.GetFldValue(Id, CSC_ProdSubStep, SubStep, dataType);
    p_sc.GetFldValue(Id, CSC_QtyToSched, qty, dataType);
  end;

  p_sc.SetSchedType(id, sSchedType);
  if sSchedType = '0' then
     p_sc.SetJobComponentsFromStack(id, 0);

  m_list.Add(SetSchedType);
  Result := true
end;

//----------------------------------------------------------------------------//

function TOpStack.ChgPlanObjDurData(const pObj: TMqmDurObj): boolean;
var
  chgDur: TOpChgPlanObjDur;
begin
  chgDur := TOpChgPlanObjDur.CreateChgPlanObjDur(pObj);
  if (pObj.m_status <> CDUR_New) then
    pObj.m_status := CDUR_modi;

  pObj.m_bkStart := pObj.p_start;
  if pObj is TMqmWarp then
    pObj.m_bkDurDouble := pObj.p_durDouble
  else
    pObj.m_bkDur   := pObj.p_dur;

  m_list.Add(chgDur);
  Result := true
end;

//----------------------------------------------------------------------------//

function TOpStack.DeleSchedObj(const id: TSchedID): boolean;
var
  scObj: TOpDelSched;
begin
  scObj := TOpDelSched.CreateDelSched(id);
  m_list.Add(scObj);

  p_sc.ClearSchedObj(id, 'DeleSchedObj - user deleted');
  Result := true
end;

//----------------------------------------------------------------------------//

function TOpStack.AddJobToGroup(const job, grp: TSchedID): boolean;
var
  opAdd:     TOpAddToGrp;
  fGrp:      TSchedId;
  planInfo,
  fPlanInfo: TSQplanInfo;
  moveChgInfo, fmoveChgInfo: TSQmoveChgInfo;
begin
  opAdd := TOpAddToGrp.CreateAddToGrp(job);
  if p_sc.GetSchedObjStatus(job) <> CSS_New then
      p_sc.SetSchedObjStatus(job, CSS_modi);
  m_list.Add(opAdd);

  if (p_sc.GetExtLinkPtr(grp) <> nil) and (p_sc.GetGrpNumSons(grp) > 0) then
  begin
    fGrp := p_sc.GetGrpSon(grp, 0);
    p_sc.GetPlanInfo(job, planInfo);
    p_sc.GetMoveChgInfo(Job, moveChgInfo);
    if p_sc.GetJobType(fGrp) = CST_batch then
    begin
      p_sc.GetPlanInfo(fGrp, fPlanInfo);
      planInfo.startDate := fPlanInfo.startDate;
      planInfo.endDate   := fPlanInfo.endDate;
      planInfo.exeMin    := fPlanInfo.exeMin;
      p_opStack.ChgOccDurData(job, planInfo);
//    p_sc.SetPlanInfo(job, planInfo);
      p_sc.AddJobToGroup(job, grp);
    end
    else
    begin
      p_sc.GetMoveChgInfo(fGrp, fmoveChgInfo);
      moveChgInfo.numOfRscComp := fmoveChgInfo.numOfRscComp;
      moveChgInfo.subLinRscId  := fmoveChgInfo.subLinRscId;
      moveChgInfo.SchedType    := fmoveChgInfo.SchedType;
      p_opStack.ChgOccMoveData(Job, moveChgInfo);
      p_sc.AddJobToGroup(job, grp);
      p_pl.EnterCompatModeInPlan(grp);
      UpdContGrpTimings(grp, grp);
    end;
  end else
    p_sc.AddJobToGroup(job, grp);


  Result := true
end;

//----------------------------------------------------------------------------//

function TOpStack.RemoveJobFromGroup(const id: TSchedID; Reason: string = ''): boolean;
var
  opRmv: TOpRemoveFromGrp;
  grp:   TSchedID;
  planInfo : TSQplanInfo;
begin
  grp := p_sc.GetGroup(id);
  p_sc.GetPlanInfo(id, planInfo);
  opRmv := TOpRemoveFromGrp.CreateRemoveFromGrp(grp, id);
  if p_sc.GetSchedObjStatus(id) <> CSS_New then
      p_sc.SetSchedObjStatus(id, CSS_modi);
  m_list.Add(opRmv);
  p_sc.RemoveJobFromGroup(id, Reason);

  if (p_sc.GetGrpNumSons(grp) > 0) and ((p_sc.GetJobType(grp) <> CST_batch)) then
    UpdContGrpTimings(grp,grp);
  Result := true
end;

//----------------------------------------------------------------------------//

function TOpStack.CreateGroup(const job: TSchedID; var grp: TSchedID): boolean;
var
  opCrt: TOpCreateGrp;
begin
  opCrt := TOpCreateGrp.CreateCreateGrp(job);
  if p_sc.GetSchedObjStatus(job) <> CSS_New then
      p_sc.SetSchedObjStatus(job, CSS_modi);
  m_list.Add(opCrt);
  grp := p_sc.CreateGroup(job);
  opCrt.m_grp := grp;
  Result := true
end;

//----------------------------------------------------------------------------//

function TOpStack.SplitJob(const job: TSchedID; OrigJobQty, EachJobQty: currency; NewJobNr: integer; var NewId : TSchedID; var List : TList): boolean;
var
  opSplit: TOpSplitJob;
//  ConnSchedList: TMSchedList;
//  i: integer;
begin
  opSplit := TOpSplitJob.CreateSplitJob(job);
  if p_sc.GetSchedObjStatus(job) <> CSS_New then
      p_sc.SetSchedObjStatus(job, CSS_modi);
  m_list.Add(opSplit);
  opSplit.m_JobList := p_sc.SplitJob(job,  OrigJobQty, EachJobQty, NewJobNr, NewId);
  List := opSplit.m_JobList;
{  ConnSchedList := TMSchedList.Create(self);
  //remove forward connections
  p_sc.GetFwLinkedJobs(job, ConnSchedList);
  for i := 0 to ConnSchedList.GetLinkCount-1 do
    ResetForwardConn(job, ConnSchedList.GetLink(i));
  //remove backward connections
  p_sc.GetBwLinkedJobs(job, ConnSchedList);
  for i := 0 to ConnSchedList.GetLinkCount-1 do
    ResetBackwardConn(job, ConnSchedList.GetLink(i));
  ConnSchedList.Free;   }

  Result := true
end;

//----------------------------------------------------------------------------//

function TOpStack.JoinJobs(const job: TSchedID; jobsList: TList): boolean;
var
  opJoin: TOpJoinJobs;
  i: integer;
begin
  opJoin := TOpJoinJobs.CreateJoinJobs(job);
  if p_sc.GetSchedObjStatus(job) <> CSS_New then
      p_sc.SetSchedObjStatus(job, CSS_modi);
  m_list.Add(opJoin);

  opJoin.m_JobList.Clear;
  for i := 0 to jobsList.Count -1 do
    opJoin.m_JobList.Add(jobsList[i]);

  p_sc.JoinJobs(job, jobsList);

  Result := true
end;

//----------------------------------------------------------------------------//

function TOpStack.ReprocJob(const job: TSchedID; ReprocQty: currency): boolean;
var
  opReproc: TOpReprocJob;
begin
  opReproc := TOpReprocJob.CreateReprocJob(job);
//  p_sc.SetSchedObjStatus(job, CSS_modi);
  m_list.Add(opReproc);
  opReproc.m_NewJob := p_sc.ReprocJob(job, ReprocQty);

  Result := true
end;

//----------------------------------------------------------------------------//

function TOpStack.SetForwardConn(const job: TSchedID; jobToConn: TSchedID): boolean;
//var
//  opSetForwardConn: TOpSetForwardConn;
//  OrigSplitInfo, ConnSplitInfo: TSQSplitInfo;
begin
  Result := true;

{  opSetForwardConn := TOpSetForwardConn.CreateSetForwardConn(job);
  m_list.Add(opSetForwardConn);
  p_sc.GetSplitInfo(job, OrigSplitInfo);
  opSetForwardConn.m_OrigSubStep  := OrigSplitInfo.fwdConnSubStp;
  opSetForwardConn.m_OrigReprocNo := OrigSplitInfo.fwdConnReProcs;

  if jobToConn = CSchedIDnull then exit;

  opSetForwardConn.m_ConnJob := jobToConn;
  p_sc.GetSplitInfo(jobToConn, ConnSplitInfo);
  opSetForwardConn.m_ConnSubStep  := ConnSplitInfo.bkwConnSubStp;
  opSetForwardConn.m_ConnReprocNo := ConnSplitInfo.bkwConnReProcs;

  //0=no 1=many 2=one 3=one to one
  case ConnSplitInfo.connTypeToPrevious of
    0:  Result:= false;
    1:  begin
          OrigSplitInfo.fwdConnSubStp  := ConnSplitInfo.SubStepNo;
          OrigSplitInfo.fwdConnReProcs := ConnSplitInfo.ReProcNo;
          ConnSplitInfo.bkwConnSubStp  := -1;
          ConnSplitInfo.bkwConnReProcs := -1;
        end;
    2:  begin
          OrigSplitInfo.fwdConnSubStp  := -1;
          OrigSplitInfo.fwdConnReProcs := -1;
          ConnSplitInfo.bkwConnSubStp  := OrigSplitInfo.SubStepNo;
          ConnSplitInfo.bkwConnReProcs := OrigSplitInfo.ReProcNo;
        end;
    3:  begin
          OrigSplitInfo.fwdConnSubStp  := ConnSplitInfo.SubStepNo;
          OrigSplitInfo.fwdConnReProcs := ConnSplitInfo.ReProcNo;
          ConnSplitInfo.bkwConnSubStp  := OrigSplitInfo.SubStepNo;
          ConnSplitInfo.bkwConnReProcs := OrigSplitInfo.ReProcNo;
        end;
  end;

  if Result then
  begin  }
//    p_sc.SetSplitInfo(job, OrigSplitInfo);
//    p_sc.SetSplitInfo(jobToConn, ConnSplitInfo);
    if p_sc.GetSchedObjStatus(job) <> CSS_New then
      p_sc.SetSchedObjStatus(job, CSS_modi);
    if p_sc.GetSchedObjStatus(jobToConn) <> CSS_New then
      p_sc.SetSchedObjStatus(jobToConn, CSS_modi);
//  end;
end;

//----------------------------------------------------------------------------//

function TOpStack.ResetForwardConn(const job: TSchedID; jobToConn: TSchedID): boolean;
//var
//  opSetForwardConn: TOpSetForwardConn;
//  OrigSplitInfo, ConnSplitInfo: TSQSplitInfo;
begin
  Result := true;

{  opSetForwardConn := TOpSetForwardConn.CreateSetForwardConn(job);
  m_list.Add(opSetForwardConn);
  p_sc.GetSplitInfo(job, OrigSplitInfo);
  opSetForwardConn.m_OrigSubStep  := OrigSplitInfo.fwdConnSubStp;
  opSetForwardConn.m_OrigReprocNo := OrigSplitInfo.fwdConnReProcs;

  if jobToConn = CSchedIDnull then exit;

  opSetForwardConn.m_ConnJob := jobToConn;
  p_sc.GetSplitInfo(jobToConn, ConnSplitInfo);
  opSetForwardConn.m_ConnSubStep  := ConnSplitInfo.bkwConnSubStp;
  opSetForwardConn.m_ConnReprocNo := ConnSplitInfo.bkwConnReProcs;

  OrigSplitInfo.fwdConnSubStp  := -2;
  OrigSplitInfo.fwdConnReProcs := -2;
  ConnSplitInfo.bkwConnSubStp  := -2;
  ConnSplitInfo.bkwConnReProcs := -2;

  p_sc.SetSplitInfo(job, OrigSplitInfo);
  p_sc.SetSplitInfo(jobToConn, ConnSplitInfo); }
  if p_sc.GetSchedObjStatus(job) <> CSS_New then
    p_sc.SetSchedObjStatus(job, CSS_modi);
  if p_sc.GetSchedObjStatus(jobToConn) <> CSS_New then
    p_sc.SetSchedObjStatus(jobToConn, CSS_modi);
end;

//----------------------------------------------------------------------------//

function TOpStack.SetBackwardConn(const job: TSchedID; jobToConn: TSchedID): boolean;
//var
//  opSetBackwardConn: TOpSetBackwardConn;
//  OrigSplitInfo, ConnSplitInfo: TSQSplitInfo;
begin
  Result := true;

{  opSetBackwardConn := TOpSetBackwardConn.CreateSetBackwardConn(job);
  m_list.Add(opSetBackwardConn);
  p_sc.GetSplitInfo(job, OrigSplitInfo);
  opSetBackwardConn.m_OrigSubStep  := OrigSplitInfo.bkwConnSubStp;
  opSetBackwardConn.m_OrigReprocNo := OrigSplitInfo.bkwConnReProcs;

  if jobToConn = CSchedIDnull then exit;

  opSetBackwardConn.m_ConnJob := jobToConn;
  p_sc.GetSplitInfo(jobToConn, ConnSplitInfo);
  opSetBackwardConn.m_ConnSubStep  := ConnSplitInfo.fwdConnSubStp;
  opSetBackwardConn.m_ConnReprocNo := ConnSplitInfo.fwdConnReProcs;

  //0=no 1=many 2=one 3=one to one
  case ConnSplitInfo.connTypeToPrevious of
    0:  Result:= false;
    1:  begin
          OrigSplitInfo.bkwConnSubStp  := -1;
          OrigSplitInfo.bkwConnReProcs := -1;
          ConnSplitInfo.fwdConnSubStp  := OrigSplitInfo.SubStepNo;
          ConnSplitInfo.fwdConnReProcs := OrigSplitInfo.ReProcNo;
        end;
    2:  begin
          OrigSplitInfo.bkwConnSubStp  := ConnSplitInfo.SubStepNo;
          OrigSplitInfo.bkwConnReProcs := ConnSplitInfo.ReProcNo;
          ConnSplitInfo.fwdConnSubStp  := -1;
          ConnSplitInfo.fwdConnReProcs := -1;
        end;
    3:  begin
          OrigSplitInfo.bkwConnSubStp  := ConnSplitInfo.SubStepNo;
          OrigSplitInfo.bkwConnReProcs := ConnSplitInfo.ReProcNo;
          ConnSplitInfo.fwdConnSubStp  := OrigSplitInfo.SubStepNo;
          ConnSplitInfo.fwdConnReProcs := OrigSplitInfo.ReProcNo;
        end;
  end; }

//  if Result then
//  begin
//    p_sc.SetSplitInfo(job, OrigSplitInfo);
//    p_sc.SetSplitInfo(jobToConn, ConnSplitInfo);
    if p_sc.GetSchedObjStatus(job) <> CSS_New then
      p_sc.SetSchedObjStatus(job, CSS_modi);
    if p_sc.GetSchedObjStatus(jobToConn) <> CSS_New then
      p_sc.SetSchedObjStatus(jobToConn, CSS_modi);
//  end;
end;

//----------------------------------------------------------------------------//

function TOpStack.ResetBackwardConn(const job: TSchedID; jobToConn: TSchedID): boolean;
//var
//  opSetBackwardConn: TOpSetBackwardConn;
//  OrigSplitInfo, ConnSplitInfo: TSQSplitInfo;
begin
  Result := true;

{  opSetBackwardConn := TOpSetBackwardConn.CreateSetBackwardConn(job);
  m_list.Add(opSetBackwardConn);
  p_sc.GetSplitInfo(job, OrigSplitInfo);
  opSetBackwardConn.m_OrigSubStep  := OrigSplitInfo.bkwConnSubStp;
  opSetBackwardConn.m_OrigReprocNo := OrigSplitInfo.bkwConnReProcs;

  if jobToConn = CSchedIDnull then exit;

  opSetBackwardConn.m_ConnJob := jobToConn;
  p_sc.GetSplitInfo(jobToConn, ConnSplitInfo);
  opSetBackwardConn.m_ConnSubStep  := ConnSplitInfo.fwdConnSubStp;
  opSetBackwardConn.m_ConnReprocNo := ConnSplitInfo.fwdConnReProcs;

  OrigSplitInfo.bkwConnSubStp  := -2;
  OrigSplitInfo.bkwConnReProcs := -2;
  ConnSplitInfo.fwdConnSubStp  := -2;
  ConnSplitInfo.fwdConnReProcs := -2;

  p_sc.SetSplitInfo(job, OrigSplitInfo);
  p_sc.SetSplitInfo(jobToConn, ConnSplitInfo);    }
  if p_sc.GetSchedObjStatus(job) <> CSS_New then
    p_sc.SetSchedObjStatus(job, CSS_modi);
  if p_sc.GetSchedObjStatus(jobToConn) <> CSS_New then
    p_sc.SetSchedObjStatus(jobToConn, CSS_modi);
end;

//----------------------------------------------------------------------------//

function TOpStack.LinkOccToApa(const id: TSchedID; apa: TMqmActArea): boolean;
var
  opLink: TOpLinkOccApa;
//  DatesInfo: TSQDatesInfo;
//  NextObjId: TSchedID;
begin
  opLink := TOpLinkOccApa.CreateLinkOccApa(id, apa);
  if p_sc.GetSchedObjStatus(id) <> CSS_New then
    p_sc.SetSchedObjStatus(id, CSS_modi);
  m_list.Add(opLink);

  apa.AddSchedObj(id);
  p_sc.InvalidateToBeSched(id);
//SavAvi  p_sc.SetWCProcessInfo(id);
{
  p_sc.GetDatesInfo(id, DatesInfo);
//  NextObjId := apa.GetNextObj(DatesInfo.endDate, id);
  NextObjId := apa.GetNextObj(DatesInfo.startDate, id);

  if NextObjId <> CSchedIDnull then
    p_sc.UpdateSetup(NextObjId);
}
  Result := true
end;

//----------------------------------------------------------------------------//

function TOpStack.LinkPlanObjToApa(const pObj: TMqmDurObj; apa: TMqmActArea): boolean;
var
  opLink: TOpLinkPlanObjApa;
begin
  opLink := TOpLinkPlanObjApa.CreateLinkPlanObjApa(pObj, apa);

  if Assigned(pObj.p_Father) then
  begin
    if pObj is TMqmCapRes then
      TMqmActArea(pObj.p_Father).RemoveCapRes(pObj)
    else if pObj is TMqmWarp then
      TMqmActArea(pObj.p_Father).RemoveWarp(pObj)
    else
      Assert(false);
  end;

  if (pObj.m_status <> CDUR_New) then
    pObj.m_status := CDUR_modi;
  m_list.Add(opLink);

  if pObj is TMqmCapRes then
    apa.AddCapRes(pObj)
  else if pObj is TMqmWarp then
  begin
    apa.AddWarp(pObj);
    p_sc.SetExtLinkPtr_Material(TMqmWarp(pObj).Get_M_id, apa);
  end;

  Result := true;
end;

//----------------------------------------------------------------------------//

function TOpStack.DetachOccFromApa(const id: TSchedID; apa: TMqmActArea): boolean;
var
  opLink: TOpDetachOccApa;
//  DatesInfo: TSQDatesInfo;
  NextObjId, PrevId: TSchedID;
  Delta: double;
  planInfo: TSQplanInfo;
  linkInfo: TSQlinkInfo;
  DummysupMinBase, Dummysetup, Dummyoverlap, Teoreticl_Dur, Teoreticl_LeadTime : double;
  Teoreticl_wc, LearningCurveCode : string;
begin
  NextObjId := CSchedIDnull;
  opLink := TOpDetachOccApa.CreateDetachOccApa(id, apa);
  if p_sc.GetSchedObjStatus(id) <> CSS_New then
    p_sc.SetSchedObjStatus(id, CSS_modi);
  m_list.Add(opLink);

//  p_sc.GetDatesInfo(id, DatesInfo);

  if p_sc.P_ReorganizeAllEnd then
  begin
    if not p_sc.P_DoNotSortScheduled then apa.SortSchedObjs;
    NextObjId := apa.GetNextObj(p_sc.GetSchedEnd(id){DatesInfo.endDate}, id);
  end;

  apa.RemoveSchedObj(id);
  p_sc.CleanInstanceCounterProperty(id);
  p_sc.InvalidateToBeSched(id);

  if p_sc.P_ReorganizeAllEnd and (NextObjId <> CSchedIDnull) and p_sc.CanDetach(NextObjId,nil,false) then
  begin
    p_sc.UpdateSetup(NextObjId, Delta, true);

    // Handling Generic Plan Info
    p_sc.GetLinkInfo(NextObjId, linkInfo);
    if linkInfo.IsGenericPlan then
    begin
      DummysupMinBase := 0;
      PrevId := apa.GetPrecObjByIndex(NextObjId);
      CalcSetup(NextObjId, PrevId, apa, DummysupMinBase, Dummysetup, Dummyoverlap, Teoreticl_wc, Teoreticl_Dur, Teoreticl_LeadTime, LearningCurveCode);
      p_sc.GetPlanInfo(NextObjId, planInfo);
      if planInfo.GenericPlan and (planInfo.GenericPlanWC = '') and (Trim(Teoreticl_wc) <> '')  then
      begin
        if ScheduleOnBestPosition(NextObjId, planInfo, planInfo.startDate, trim(Teoreticl_wc), Teoreticl_Dur, Teoreticl_LeadTime, true) then
          p_opStack.ChgOccDurGenericPlan(NextObjId, planInfo);
      end
      else if planInfo.GenericPlan and (Trim(Teoreticl_wc) = '') and (planInfo.GenericPlanWC <> '') then
      begin
        UnScheduleGenericPlan(NextObjId);
        planInfo.GenericPlanWC := '';
        p_opStack.ChgOccDurGenericPlan(NextObjId, planInfo);
      end;

    end;
  end;

  Result := true
end;

//----------------------------------------------------------------------------//

function TOpStack.DetachOccFromApaInSameActArea(const id: TSchedID; apa: TMqmActArea): boolean;
var
  opLink: TOpDetachOccApa;
//  DatesInfo: TSQDatesInfo;
  NextObjId: TSchedID;
  Delta: double;
begin
  opLink := TOpDetachOccApa.CreateDetachOccApa(id, apa);
  if p_sc.GetSchedObjStatus(id) <> CSS_New then
    p_sc.SetSchedObjStatus(id, CSS_modi);
  m_list.Add(opLink);

//  p_sc.GetDatesInfo(id, DatesInfo);
  NextObjId := apa.GetNextObj(p_sc.GetSchedEnd(id){DatesInfo.endDate}, id);

  p_sc.InvalidateToBeSched(id);

  if NextObjId <> CSchedIDnull then
    p_sc.UpdateSetup(NextObjId, Delta, true);

  apa.RemoveSchedObj(id);
  p_sc.CleanInstanceCounterProperty(id);
  Result := true
end;

//----------------------------------------------------------------------------//

function TOpStack.DetachGenInfoFromApa(const id: TSchedID; var planInfo: TSQplanInfo): boolean;
var
  oldPlanInfo: TSQplanInfo;
  DetachGenInfoApa:      TOpDetachGenInfoApa;
  I : Integer;
  SonId : TSchedID;
begin
  if planInfo.isGroup then
  begin
    for i := 0 to p_sc.GetGrpNumSons(id)-1 do
    begin
      SonId := p_sc.GetGrpSon(id, i);
      p_sc.GetJobInfo(SonId, oldPlanInfo);
      DetachGenInfoApa := TOpDetachGenInfoApa.CreateDetachGenInfoApa(SonId, oldPlanInfo);
      m_list.Add(DetachGenInfoApa);
    end;
  end;

  p_sc.GetPlanInfo(id, oldPlanInfo);
  DetachGenInfoApa := TOpDetachGenInfoApa.CreateDetachGenInfoApa(id, oldPlanInfo);
  m_list.Add(DetachGenInfoApa);
  p_sc.SetGenericInfo(id, planInfo);
  Result := true
end;

//----------------------------------------------------------------------------//

function TOpStack.UpdateOvlpLimits(const id: TSchedID; Res: TMqmRes): boolean;
var
  opLink: TOpUpdOvlpLimits;
begin
  opLink := TOpUpdOvlpLimits.CreateUpdOvlpLimits(id);
  m_list.Add(opLink);

  p_sc.SetOvlpUpdate(id, true);

  Result := true
end;

//----------------------------------------------------------------------------//

function TOpStack.UpdateBalance(const id: TSchedID): boolean;
var
  opLink: TOpUpdBalance;
begin
  opLink := TOpUpdBalance.CreateUpdBalance(id);
  m_list.Add(opLink);

  p_sc.UpdateBalance(Id);

  Result := true
end;

//----------------------------------------------------------------------------//

Procedure TOpStack.ClearBalance(const id: TSchedID);
var
  opLink: TOpClrBalance;
begin
  opLink := TOpClrBalance.CreateClrBalance(id);
  m_list.Add(opLink);

  p_sc.ClearBalance(Id);

end;


//----------------------------------------------------------------------------//

function TOpStack.DetachPlanObjFromApa(const pObj: TMqmDurObj): boolean;
var
  opLink: TOpDetachPlanObjApa;
  WarpInfo: TPWarpInfo;
begin
  opLink := TOpDetachPlanObjApa.CreateDetachPlanObjApa(pObj);
  pObj.m_status := CDUR_Modi;
  m_list.Add(opLink);
  if pObj is TMqmCapRes then
    TMqmActArea(pObj.p_Father).RemoveCapRes(pObj)
  else if pObj is TMqmWarp then
  begin
    p_sc.GetWarpInfo(TMqmWarp(pObj).Get_M_id, WarpInfo);
    opLink.m_WarpInfo := WarpInfo;
    p_sc.SetExtLinkPtr_Material(TMqmWarp(pObj).Get_M_id, nil);
    TMqmActArea(pObj.p_Father).RemoveWarp(pObj)
  end
  else
    Assert(false);

  Result := true
end;

//----------------------------------------------------------------------------//

function TOpStack.DelePlanObjFromApa(const pObj: TMqmDurObj; apa: TMqmActArea): boolean;
var
  opLink: TOpDelePlanObjApa;
begin
  opLink := TOpDelePlanObjApa.CreateDelePlanObjApa(pObj, apa);
  pObj.m_status := CDUR_del;
  m_list.Add(opLink);
  if pObj is TMqmCapRes then
    apa.RemoveCapRes(pObj)
  else if pObj is TMqmWarp then
  begin
    p_sc.SetExtLinkPtr_Material(TMqmWarp(pObj).Get_M_id, nil);
    apa.RemoveWarp(pObj)
  end
  else
    Assert(false);

  p_pl.AddObjToDele(pObj);
  Result := true
end;

//----------------------------------------------------------------------------//

constructor TOperation.CreateOp;
begin
  inherited Create;
  m_pointGen := COPnoStackMark
end;

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

constructor TOperationSched.CreateOpSched(id: TSchedId);
begin
  inherited CreateOp;
  m_idStatus := p_sc.GetSchedObjStatus(id);
  m_idRef    := id;
end;

//----------------------------------------------------------------------------//

procedure TOperationSched.Undo;
begin
  p_sc.SetSchedObjStatus(m_idRef, m_idStatus);
end;

//----------------------------------------------------------------------------//

destructor TOperationSched.Destroy;
begin
  inherited Destroy;
end;

//----------------------------------------------------------------------------//

function TOperationSched.GetBkInfo: pointer;
begin
  Result := nil;
end;

//----------------------------------------------------------------------------//

constructor TOperationPlan.CreateOpPlan(pObj: TMqmDurObj);
begin
  inherited CreateOp;
  m_ObjStatus := pObj.m_status;
  if pObj is TMqmWarp then
  begin
   // m_OldApa := TMqmActArea(pObj.p_Father);
   // p_sc.SetExtLinkPtr_Material(TMqmWarp(pObj).Get_M_id, apa);
  end;

  m_pObj := pObj
end;

//----------------------------------------------------------------------------//

procedure TOperationPlan.Undo;
begin
  m_pObj.m_status := m_ObjStatus;
  if m_pObj is TMqmWarp then
  begin
    if (m_ObjStatus = CDUR_modi) or (m_ObjStatus = CDUR_none) or (m_ObjStatus = CDUR_new) then
    begin
      p_sc.SetExtLinkPtr_Material(TMqmWarp(m_pObj).Get_M_id, TMqmActArea(m_pObj.p_Father));
    end;
  end;
end;

//----------------------------------------------------------------------------//

destructor TOperationPlan.Destroy;
begin
  inherited Destroy;
end;

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

constructor TOpChgOccDur.CreateChgOccDur(const id: TSchedID; var planInfo: TSQplanInfo);
begin
  inherited CreateOpSched(id);
  m_planInfo := planInfo;
end;

//----------------------------------------------------------------------------//

procedure TOpChgOccDur.Undo;
begin
  p_sc.SetPlanInfo(m_idRef, m_planInfo);

  if p_sc.GetMoveOp(m_idRef) = self then
    p_sc.SetMoveOp(m_idRef, nil);

  p_sc.UpdateBalance(m_idRef);  // fp

  inherited Undo
end;

//----------------------------------------------------------------------------//

function TOpChgOccDur.GetBkInfo: pointer;
begin
  Result := @m_planInfo;
end;

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

constructor TOpChgMoveDt.CreateChgMoveDt(const id: TSchedID; var moveChg: TSQmoveChgInfo);
begin
  inherited CreateOpSched(id);
  m_moveChg := moveChg;
end;

//----------------------------------------------------------------------------//

procedure TOpChgMoveDt.Undo;
begin
  p_sc.SetMoveChgInfo(m_idRef, m_moveChg);
  inherited Undo
end;

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

constructor TOpChgProgressStatus.CreateChgProgressStatus(const id: TSchedID;
  var snap: TSQProgressSnapshot; var planInfo: TSQplanInfo; var moveChg: TSQmoveChgInfo);
begin
  inherited CreateOpSched(id);
  m_progSnap := snap;
  m_planInfo := planInfo;
  m_moveChg  := moveChg;
end;

//----------------------------------------------------------------------------//

procedure TOpChgProgressStatus.Undo;
begin
  // restore progress / ignore-progress fields, then the saved position
  p_sc.SetProgressSnapshot(m_idRef, m_progSnap);
  p_sc.SetPlanInfo(m_idRef, m_planInfo);
  p_sc.SetMoveChgInfo(m_idRef, m_moveChg);
  p_sc.UpdateBalance(m_idRef);
  inherited Undo
end;

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

constructor TOpSetSchedType.CreateSetSchedType(const id: TSchedID);
var
  oldMoveChg: TSQmoveChgInfo;
begin
  inherited CreateOpSched(id);
  p_sc.GetMoveChgInfo(id, oldMoveChg);
  m_SchedType := oldMoveChg.SchedType;
  m_JobComponents := oldMoveChg.numOfRscComp;
end;

//----------------------------------------------------------------------------//

procedure TOpSetSchedType.Undo;
begin
  p_sc.SetSchedType(m_idRef, m_SchedType);
  p_sc.SetJobComponentsFromStack(m_idRef, m_JobComponents);
  inherited Undo
end;

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

constructor TOpChgPlanObjDur.CreateChgPlanObjDur(const pObj: TMqmDurObj);
begin
  inherited CreateOpPlan(pObj);
  m_pObj := pObj;
  m_startDate := pObj.p_Start;
  m_EndDate   := pObj.p_End;
  if pObj is TMqmWarp then
    m_DurDouble := pObj.p_DurDouble
  else
    m_Dur := pObj.p_Dur;
end;

//----------------------------------------------------------------------------//

procedure TOpChgPlanObjDur.Undo;
begin
  m_pObj.p_start := m_startDate;
  m_pObj.p_end := m_EndDate;

  if m_pObj is TMqmWarp then
    m_pObj.p_DurDouble := m_DurDouble
  else
    m_pObj.p_dur   := m_Dur;
  m_pObj.m_bkStart := 0;
  m_pObj.m_bkDur   := 0;
  inherited Undo
end;

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

constructor TOpCreatePlanObj.CreatePlanObj(const pObj: TMqmDurObj);
begin
  inherited CreateOpPlan(pObj);
  pObj.m_status := CDUR_New;
  m_pObj := pObj;
end;

//----------------------------------------------------------------------------//

procedure TOpCreatePlanObj.Undo;
begin
  m_pObj.Free;
  inherited Undo
end;

//----------------------------------------------------------------------------//

constructor TOpDelSched.CreateDelSched(const id: TSchedID);
begin
  inherited CreateOpSched(id)
end;

//----------------------------------------------------------------------------//

procedure TOpDelSched.Undo;
begin
  p_sc.ResumeDelSchedObj(m_idRef);
  inherited Undo
end;

//----------------------------------------------------------------------------//

constructor TOpAddToGrp.CreateAddToGrp(const id: TSchedID);
begin
  inherited CreateOpSched(id)
end;

//----------------------------------------------------------------------------//

procedure TOpAddToGrp.Undo;
begin
  p_sc.RemoveJobFromGroup(m_idRef, 'Undo - added to group');
  inherited Undo;
end;

//----------------------------------------------------------------------------//

constructor TOpRemoveFromGrp.CreateRemoveFromGrp(const grp, job: TSchedID);
begin
  inherited CreateOpSched(job);
  m_grp := grp
end;

//----------------------------------------------------------------------------//

procedure TOpRemoveFromGrp.Undo;
begin
  p_sc.AddJobToGroup(m_idRef, m_grp);
  inherited Undo
end;

//----------------------------------------------------------------------------//

constructor TOpCreateGrp.CreateCreateGrp(const id: TSchedID);
begin
  inherited CreateOpSched(id);
  m_grp := CSchedIDnull
end;

//----------------------------------------------------------------------------//

procedure TOpCreateGrp.Undo;
begin
  p_sc.RemoveJobFromGroup(m_idRef, 'Undo - create group');
  p_sc.DeleteGroup(m_grp);
  inherited Undo
end;

//----------------------------------------------------------------------------//

constructor TOpSplitJob.CreateSplitJob(const id: TSchedID);
begin
  inherited CreateOpSched(id);
  p_sc.GetSplitInfo(id, m_SplitInfo);
end;

//----------------------------------------------------------------------------//

procedure TOpSplitJob.Undo;
var
  i: integer;
begin
  p_sc.SetSplitInfo(m_idRef, m_SplitInfo);
  if assigned(m_JobList) then
  begin
    for i := m_JobList.Count-1 downto 0 do
    begin
      p_sc.ClearBalance(TSchedID(m_JobList[i]));
      p_sc.ClearSchedObj(TSchedID(m_JobList[i]), 'SplitJob.Undo - undo split');
    end;
    m_JobList.Free;
  end;

  inherited Undo
end;

//----------------------------------------------------------------------------//

constructor TOpJoinJobs.CreateJoinJobs(const id: TSchedID);
begin
  inherited CreateOpSched(id);
  m_JobList := TList.Create;
  p_sc.GetPlanInfo(id, m_planInfo);
  p_sc.GetManualChange(id , m_MaualChange);
end;

//----------------------------------------------------------------------------//

procedure TOpJoinJobs.Undo;
var
  i: integer;
  SavemanualJobsListChange:  double;
  PlanListJobs : TSQplanInfo;
begin

//  p_sc.GetManualChange(m_idRef,SavemanualJobChange);
  p_sc.SetManualChange(m_idRef,0);

  m_planInfo.quant := m_planInfo.quant - m_MaualChange;
  p_sc.SetPlanInfo(m_idRef, m_planInfo);
  p_sc.SetManualChange(m_idRef,m_MaualChange);

  for i := m_JobList.Count-1 downto 0 do
  begin
    p_sc.GetPlanInfo(TSchedID(m_JobList[i]),PlanListJobs);
    SavemanualJobsListChange := 0;
    p_sc.GetManualChange(TSchedID(m_JobList[i]),SavemanualJobsListChange);
    p_sc.SetManualChange(TSchedID(m_JobList[i]),0);
    PlanListJobs.quant := PlanListJobs.quant - SavemanualJobsListChange;
    p_sc.SetPlanInfo(TSchedID(m_JobList[i]),PlanListJobs);
    p_sc.ResumeDelSchedObj(TSchedID(m_JobList[i]));

    p_sc.SetManualChange(TSchedID(m_JobList[i]),SavemanualJobsListChange);

  end;

  m_JobList.Free;
  inherited Undo;

end;

//----------------------------------------------------------------------------//

constructor TOpReprocJob.CreateReprocJob(const id: TSchedID);
begin
  inherited CreateOpSched(id);
end;

//----------------------------------------------------------------------------//

procedure TOpReprocJob.Undo;
begin
  p_sc.ClearSchedObj(m_NewJob, 'ReprocJob.Undo - undo reprocess');

  inherited Undo
end;

//----------------------------------------------------------------------------//

constructor TOpSetForwardConn.CreateSetForwardConn(const id: TSchedID);
begin
  inherited CreateOpSched(id);
end;

//----------------------------------------------------------------------------//

procedure TOpSetForwardConn.Undo;
var
  SplitInfo: TSQSplitInfo;
begin
  p_sc.GetSplitInfo(m_idRef, SplitInfo);
  SplitInfo.fwdConnSubStp := m_OrigSubStep;
  SplitInfo.fwdConnReProcs := m_OrigReprocNo;
  p_sc.SetSplitInfo(m_idRef, SplitInfo);

  p_sc.GetSplitInfo(m_ConnJob, SplitInfo);
  SplitInfo.bkwConnSubStp := m_ConnSubStep;
  SplitInfo.bkwConnReProcs := m_ConnReprocNo;
  p_sc.SetSplitInfo(m_ConnJob, SplitInfo);

  inherited Undo
end;

//----------------------------------------------------------------------------//

constructor TOpSetBackwardConn.CreateSetBackwardConn(const id: TSchedID);
begin
  inherited CreateOpSched(id);
end;

//----------------------------------------------------------------------------//

procedure TOpSetBackwardConn.Undo;
var
  SplitInfo: TSQSplitInfo;
begin
  p_sc.GetSplitInfo(m_idRef, SplitInfo);
  SplitInfo.bkwConnSubStp := m_OrigSubStep;
  SplitInfo.bkwConnReProcs := m_OrigReprocNo;
  p_sc.SetSplitInfo(m_idRef, SplitInfo);

  p_sc.GetSplitInfo(m_ConnJob, SplitInfo);
  SplitInfo.fwdConnSubStp := m_ConnSubStep;
  SplitInfo.fwdConnReProcs := m_ConnReprocNo;
  p_sc.SetSplitInfo(m_ConnJob, SplitInfo);

  inherited Undo
end;

//----------------------------------------------------------------------------//

constructor TOpLinkOccApa.CreateLinkOccApa(const id: TSchedID; apa: TMqmActArea);
begin
  inherited CreateOpSched(id);
  m_apa := apa;
end;

//----------------------------------------------------------------------------//

procedure TOpLinkOccApa.Undo;
begin
  m_apa.RemoveSchedObj(m_idRef);
  p_sc.InvalidateToBeSched(m_idRef);
  p_sc.CleanInstanceCounterProperty(m_idRef);
  inherited Undo
end;

//----------------------------------------------------------------------------//

constructor TOpDetachOccApa.CreateDetachOccApa(const id: TSchedID; apa: TMqmActArea);
begin
  inherited CreateOpSched(id);
  m_apa := apa;
end;

//----------------------------------------------------------------------------//

procedure TOpDetachOccApa.Undo;
var
  planInfo : TSQplanInfo;
begin
  m_apa.AddSchedObj(m_idRef);

  p_sc.GetPlanInfo(m_idRef, planInfo);
  if planInfo.GenericPlan then
    ScheduleOnBestPosition(m_idRef, planInfo , planInfo.startDate,  planInfo.GenericPlanWC, planInfo.GenericPlanDur  , planInfo.GenericPlanLeadTime, false);

  p_sc.InvalidateToBeSched(m_idRef);

  inherited Undo
end;

//----------------------------------------------------------------------------//

constructor TOpUpdOvlpLimits.CreateUpdOvlpLimits(const id: TSchedID);
begin
  inherited CreateOpSched(id);
  p_sc.GetOvlpLimits(id, m_LowLimitDate, m_HighLimitDate);
end;

//----------------------------------------------------------------------------//

procedure TOpUpdOvlpLimits.Undo;
begin
  p_sc.SetOvlpLimits(m_idRef, m_LowLimitDate, m_HighLimitDate);
  p_sc.SetOvlpUpdate(m_idRef, true);
  inherited Undo
end;

//----------------------------------------------------------------------------//

constructor TOpUpdBalance.CreateUpdBalance(const id: TSchedID);
begin
  inherited CreateOpSched(id);
  m_IdRef := id;
end;

//----------------------------------------------------------------------------//

constructor TOpClrBalance.CreateClrBalance(const id: TSchedID);
begin
  inherited CreateOpSched(id);
  m_IdRef := id;
end;

//----------------------------------------------------------------------------//

procedure TOpUpdBalance.Undo;
begin
  p_sc.UpdateBalance(m_idRef);
//  p_sc.ClearBalance(m_idRef);
  inherited Undo
end;

//----------------------------------------------------------------------------//

procedure TOpClrBalance.Undo;
begin
  p_sc.ClearBalance(m_idRef);
  inherited Undo
end;

//----------------------------------------------------------------------------//

constructor TOpLinkPlanObjApa.CreateLinkPlanObjApa(pObj: TMqmDurObj; apa: TMqmActArea);
var
  WarpInfo: TPWarpInfo;
begin
  inherited CreateOpPlan(pObj);
  if Assigned(pObj.p_Father) then
  begin
    m_OldApa := TMqmActArea(pObj.p_Father);

    if m_pObj is TMqmWarp then
    begin    //SetWarpSchedData
     // m_OldApa.AddWarp(m_pObj);
      p_sc.GetWarpInfo(TMqmWarp(pObj).Get_M_id, WarpInfo);
      m_WarpInfo := WarpInfo;
      p_sc.SetWarpSchedData(TMqmWarp(pObj).Get_M_id, WarpInfo.startDate, WarpInfo.endDate, WarpInfo.resource);
    end;

  end;


  m_apa := apa
end;

//----------------------------------------------------------------------------//

procedure TOpLinkPlanObjApa.Undo;
begin
  if m_pObj is TMqmCapRes then
    m_apa.RemoveCapRes(TMqmCapRes(m_pObj))
  else if m_pObj is TMqmWarp then
    m_apa.RemoveWarp(TMqmWarp(m_pObj))
  else
    Assert(false);

  if Assigned(m_OldApa) then
  begin
    if m_pObj is TMqmCapRes then
      m_OldApa.AddCapRes(m_pObj)
    else if m_pObj is TMqmWarp then
    begin
      m_OldApa.AddWarp(m_pObj);
      p_sc.SetExtLinkPtr_Material(TMqmWarp(m_pObj).Get_M_id, m_OldApa);
      p_sc.SetWarpSchedData(TMqmWarp(m_pObj).Get_M_id, m_WarpInfo.startDate, m_WarpInfo.endDate, m_WarpInfo.resource);
    end;
  end;

//  if not (m_pObj is TMqmWarp) then    // avi 17.08.22
    inherited Undo
end;

//----------------------------------------------------------------------------//

constructor TOpDetachPlanObjApa.CreateDetachPlanObjApa(pObj: TMqmDurObj);
begin
  inherited CreateOpPlan(pObj);
  m_Oldapa := TMqmActArea(pObj.p_father);
  m_apa := TMqmActArea(pObj.p_father)
end;

//----------------------------------------------------------------------------//

procedure TOpDetachPlanObjApa.Undo;
var
  apa: TMqmActArea;
begin
  if m_pObj is TMqmCapRes then
  begin
    apa := TMqmActArea(TMqmCapRes(m_pObj).p_father);
    if assigned(apa) then
      apa.RemoveCapRes(TMqmCapRes(m_pObj));
    m_apa.AddCapRes(TMqmCapRes(m_pObj));
  end
  else if m_pObj is TMqmWarp then
  begin
    apa := TMqmActArea(TMqmWarp(m_pObj).p_father);
    if assigned(apa) then
      apa.RemoveWarp(TMqmWarp(m_pObj));
    m_apa.AddWarp(TMqmWarp(m_pObj));
    p_sc.SetWarpSchedData(TMqmWarp(m_pObj).Get_M_id, m_WarpInfo.startDate, m_WarpInfo.endDate, m_WarpInfo.resource);
    TMqmWarp(m_pObj).m_status := CDUR_modi
  end
  else
    Assert(false);

  inherited Undo;
end;

//----------------------------------------------------------------------------//

constructor TOpDelePlanObjApa.CreateDelePlanObjApa(pObj: TMqmDurObj; apa: TMqmActArea);
begin
  inherited CreateOpPlan(pObj);
  m_apa := apa
end;

//----------------------------------------------------------------------------//

procedure TOpDelePlanObjApa.Undo;
var
  apa: TMqmActArea;
begin
  if m_pObj is TMqmCapRes then
  begin
    apa := TMqmActArea(TMqmCapRes(m_pObj).p_father);
    if assigned(apa) then
      apa.RemoveCapRes(TMqmCapRes(m_pObj));
    m_apa.AddCapRes(TMqmCapRes(m_pObj));
  end
  else if m_pObj is TMqmWarp then
  begin
    apa := TMqmActArea(TMqmWarp(m_pObj).p_father);
    if assigned(apa) then
      apa.RemoveWarp(TMqmWarp(m_pObj));
    m_apa.AddWarp(TMqmWarp(m_pObj));
  end
  else
    Assert(false);

  inherited Undo
end;

//----------------------------------------------------------------------------//

function TOpStack.ChangeQuantity(const job: TschedID; modifiedQty: double; getChgQtyVal: boolean; chgstepQty: boolean): String;
var
  opChangeQTY: TOpChangeQuantity;
begin
  result := p_sc.ManualChangeQty(job, modifiedQty , getChgQtyVal, chgStepQty);
  if result = '' then
  begin
    opChangeQTY := TOpChangeQuantity.CreateQuantityChange(job, modifiedQty, chgStepQty);
    m_list.Add(opChangeQTY);
  end;
end;

//----------------------------------------------------------------------------//

constructor TOpChangeQuantity.CreateQuantityChange(const id: TSchedID; modifiedQty: double; changeStepQty: boolean);
begin
  inherited CreateOpSched(id);
  m_ModifiedQty   := modifiedQty;
  m_ChangeStepQty := changeStepQty;
  m_id            := id;
end;

//----------------------------------------------------------------------------//

procedure TOpChangeQuantity.Undo;
var
  deltaQty: double;
begin
  deltaQty := (-1) * m_ModifiedQty;
  p_sc.ManualChangeQty(m_id, deltaQty , false, m_ChangeStepQty);

  if Assigned(p_sc.GetExtLinkPtr(m_id)) then
    p_pl.RecalcTimings(m_id);

  inherited Undo
end;

//----------------------------------------------------------------------------//

function TOpStack.UpdateSchedQuantity(const job: TSchedID; oldQty: double; newQty: double): String;
var
  opUpdQty: TOpUpdateSchedQuantity;
begin
  Result := p_sc.ChangeSchedQty(job, newQty, false);
  if Result = '' then
  begin
    opUpdQty := TOpUpdateSchedQuantity.CreateUpdateSchedQuantity(job, oldQty);
    m_list.Add(opUpdQty);
  end;
end;

//----------------------------------------------------------------------------//

constructor TOpUpdateSchedQuantity.CreateUpdateSchedQuantity(const id: TSchedID; oldQty: double);
begin
  inherited CreateOpSched(id);
  m_Id := id;
  m_OldQty := oldQty;
end;

//----------------------------------------------------------------------------//

procedure TOpUpdateSchedQuantity.Undo;
begin
  p_sc.ChangeSchedQty(m_Id, m_OldQty, false);
  if Assigned(p_sc.GetExtLinkPtr(m_Id)) then p_pl.RecalcTimings(m_Id);
  inherited Undo
end;

//----------------------------------------------------------------------------//

{ TOpChgGenericPlanDur }

constructor TOpChgGenericPlanDur.CreateChgGenericPlanDur(const id: TSchedID; var planInfo: TSQplanInfo);
begin
  inherited CreateOpSched(id);
  m_planInfo := planInfo;
end;

//----------------------------------------------------------------------------//

procedure TOpChgGenericPlanDur.Undo;
begin
  ScheduleOnBestPosition(m_idRef, m_planInfo, m_planInfo.startDate , m_planInfo.GenericPlanWC, m_planInfo.GenericPlanDur  , m_planInfo.GenericPlanLeadTime, true);
  p_sc.SetGenericInfo(m_idRef, m_planInfo);
  inherited Undo
end;

//----------------------------------------------------------------------------//

{ TOpDetachGenInfoApa }

constructor TOpDetachGenInfoApa.CreateDetachGenInfoApa(const id: TSchedID;
  var planInfo: TSQplanInfo);
begin
  inherited CreateOpSched(id);
  m_planInfo := planInfo;
end;

//----------------------------------------------------------------------------//

procedure TOpDetachGenInfoApa.Undo;
begin
  p_sc.SetGenericInfo(m_idRef, m_planInfo);
  inherited Undo
end;

end.

