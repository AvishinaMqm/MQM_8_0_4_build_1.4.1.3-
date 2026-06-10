unit UGganttPanel;

interface

uses
  extctrls,
  controls,
  classes,
  SysUtils,
  Graphics,
  UMSchedContFunc,
  UMRes,
  UGshapeMan;

type

  TSortType = (SRT_RscCode, SRT_RscCatCode, SRT_WCRscCode, SRT_WCCatRscCode, SRT_Customized, SRT_Sequence, SRT_SequenceDesc);

  TGanttConst = class
    bkColor: TColor;
    RH, RW:  integer;
  end;

  TGanttPanel = class(TPanel)
    constructor CreateGanttPnl(AOwner: TWinControl; var gc: TGanttConst; shCfg: TShConfig);
    destructor  Destroy; override;
    procedure   UpdateList(lst: TList);
    procedure   EnterCompatMode(id: TSchedId);
    procedure   ExitCompatMode;
  private
    m_shapeMan:     TShapeManager;
    m_rowList:      TList;
    m_origRowList:  TList;
    m_gc:           TGanttConst;
    m_id:           TSchedId;
    m_inCompatMode: boolean;
    m_LastSort   :  TSortType;
  public
    procedure SortOnDunamic;
    procedure SetGanttConst(gc: TGanttConst);
    function  GetGanttConst: TGanttConst;
    function  GetListWcForFilter(ListWcFltr : TList) : boolean;
    function  GetRowIndex( VisRes : TMqmVisibleRes ) : Integer;
    procedure SetRowHeight(RowHeight: integer);
    procedure SetFirstJobOnDynamic;
    procedure ClearObjList;
    procedure SortByResourceCode;
    procedure SortByIndex;
    procedure SortByCategoryAndResCode;
    procedure SortByWCAndRes;
    procedure SortByWcAndCatAndRes;
    procedure SortBySequence;
    procedure SortBySequenceDesc;
    procedure UpdateListWithOldSort(lst: TList);
    procedure CollapseSubRes(Res: TMqmRes);
    procedure ExpandSubRes(Res: TMqmRes);
    function  SerchPosInOrigRowList(CodeRes : string) : Integer;

    property  p_shapeMan: TShapeManager read m_shapeMan;
    property  p_VisResList: TList read m_origRowList;
    property  p_SortType : TSortType read m_LastSort write m_LastSort;

  end;

procedure CheckCompat(parms: PTRowParms; ptr: pointer);
function SortResByIndex(Item1, Item2: Pointer) : integer;
function SortResByMachineType(Item1, Item2: Pointer) : integer;

implementation

uses
  FMMainPlan,
  UMGlobal,
  UMCompat,
  UMObjCont,
  FMShowMaterials,
  FMCreateWarp,
  UMActArea,
  UMCompatRules,
  UMSchedCont,
  UMCapRes,
  UMResCat,
  UMBalance,
  UMArticles,
  UMwkCtr;

//----------------------------------------------------------------------------//

constructor TGanttPanel.CreateGanttPnl(AOwner: TWinControl; var gc: TGanttConst;
                                       shCfg: TShConfig);
begin
  inherited Create(AOwner);

  m_origRowList  := TList.Create;
  m_rowList      := m_origRowList;
  m_inCompatMode := false;

  Parent        := AOwner;
  Align         := alClient;
  BevelInner    := bvNone;
  BevelOuter    := bvLowered;
  BevelWidth    := 2;
  DoubleBuffered := True;
  Assert(Assigned(gc));
  m_id := CSchedIDnull;
  m_gc := nil;
  SetGanttConst(gc);

  shCfg.m_assObj := self;
  m_shapeMan := TShapeManager.CreateShapeMan(self, m_gc.RH,
                                             m_gc.RW, m_rowList,
                                             shCfg, true);
  m_gc.bkColor := clWhite;
  m_shapeMan.SetBkgndColor(m_gc.bkColor);
  m_shapeMan.m_FreezeShapes := false
end;

//----------------------------------------------------------------------------//

destructor TGanttPanel.Destroy;
begin
  m_shapeMan.Free;
  if Assigned(m_gc) then m_gc.Free;
  inherited destroy
end;

//----------------------------------------------------------------------------//

procedure TGanttPanel.UpdateList(lst: TList);
var
  i,k:    integer;
  VisRes: TList;
begin
  if not assigned(lst) then exit;
 // Assert(Assigned(lst));
  m_origRowList.Clear;
  for i := 0 to lst.Count-1 do
  begin
    Assert(Assigned(lst));
    VisRes := TMqmRes(lst[i]).GetVisResList;
    TMqmRes(lst[i]).m_index := i;
    for k := 0 to VisRes.Count-1 do
      m_origRowList.Add(VisRes[k])
  end;
  SortByIndex;
  p_SortType := SRT_Customized;
//  SortByResourceCode; // fp - Keep attenction to remove this line because
                      //      can cause problem with position of subresources
end;

//----------------------------------------------------------------------------//

function  TGanttPanel.GetRowIndex( VisRes : TMqmVisibleRes ) : Integer;
begin
  if Assigned(m_rowList) then
    Result := m_rowList.IndexOf(VisRes)
  else
    Result := m_origRowList.IndexOf(VisRes )
end;

//----------------------------------------------------------------------------//

procedure CheckCompat(parms: PTRowParms; ptr: pointer);
var
  id, idPrec: TSchedId;
  res:        TMqmRes;
  supRec:     TSetupRec;
  compVal:    TCompatVal;
//  FrmMat: TFShowMaterials;
  IsSameGroup : boolean;
  LearningCurveCode : string;
begin
  id := TSchedId(ptr);
  if parms.isContObj then
  begin
    if not p_sc.TestPlanInfo(TSchedId(parms.objPtr)) then
    begin
      exit;
    end;
    // occupation to occupation compatibility check
    if id <> TSchedId(parms.objPtr) then
    begin
      idPrec := TSchedId(parms.objPtr);
      if not Assigned(TMqmActArea(p_sc.GetExtLinkPtr(idPrec))) then exit;
      res := TMqmRes(TMqmActArea(p_sc.GetExtLinkPtr(idPrec)).p_res);

      if res.GetSetupParms(id, idPrec, supRec, compVal, IsSameGroup, LearningCurveCode) then
        parms.suppVal1 := compVal
      else
        parms.suppVal1 := -1;

      if res.GetSetupParms(idPrec, id, supRec, compVal, IsSameGroup, LearningCurveCode) then
        parms.suppVal2 := compVal
      else
        parms.suppVal2 := -1
    end else
    begin
      parms.suppVal1 := -1;
      parms.suppVal2 := -1
    end;
  end else
  begin
    if TObject(parms.objPtr) is TMqmCapRes then
    begin
      if (TMqmCapRes(parms.objPtr).m_Type = cr_Normal) then
      begin
        res := TMqmRes(TMqmCapRes(parms.objPtr).p_Res);
        parms.suppVal1 := res.CheckCompIDCapRes(id, parms.objPtr)
      end else
        parms.suppVal1 := -1;
    end;

    if (GetCrtWarpForm <> nil) then exit;

    if TObject(parms.objPtr) is TMqmVisibleRes then
    begin
      res := TMqmRes(TMqmVisibleRes(parms.objPtr).p_Father);
      if Res.p_occCanAttach then
      begin

        p_pl.SetOvplTargetRes(TMqmVisibleRes(parms.objPtr),OvlpChk_OptimumLimits, -1);
        p_pl.GetOverlaps(parms.OvlpLmtL, parms.OvlpLmtR);

        parms.NoMaterialList := TList.Create;
        parms.NoAddResList   := TList.Create;
        parms.NoPrevStepList := TList.Create;
        p_sc.GetMinMaterialsArrivalDate(id, Res, [Ar_MatWithDet, Ar_Material], parms.NoMaterialList, -1, -1, -1, false);   // fp - tmp0408

        p_sc.GetMinMaterialsArrivalDate(id, Res, [Ar_AddRes, Ar_AddRes_ManPower, Ar_AddRes_Capacity], parms.NoAddResList, -1, -1, -1, false);     // fp - tmp0408

      end;

    end;
  end;
end;

//----------------------------------------------------------------------------//

function SortDynamicOnEqual(Item1, Item2: Pointer) : integer;
var
  res1, res2: TMqmRes;
begin
//  Result := 0;
  res1 := TMqmRes(TMqmVisibleRes(Item1).p_father);
  res2 := TMqmRes(TMqmVisibleRes(Item2).p_father);

  if res1.p_ResCode < res2.p_ResCode then
    Result := -1
  else if res1.p_ResCode > res2.p_ResCode then
    Result := 1
  else
    Result := 0;

end;

//----------------------------------------------------------------------------//

{function sortOnDynamic(Item1, Item2: Pointer): Integer;
var
  res1, res2: TMqmRes;
  VisRes1, VisRes2 : TMqmVisibleRes;
  Start1, Start2 : TDateTime;
begin
//  Result := 0;

  if item1 = item2 then
  begin
    Result := 0;
    Exit
  end;

  res1 := TMqmRes(TMqmVisibleRes(Item1).p_father);
  res2 := TMqmRes(TMqmVisibleRes(Item2).p_father);

  VisRes1 := TMqmVisibleRes(Item1);
  VisRes2 := TMqmVisibleRes(Item2);

  // ---- put readonly at the end --------------------------------------------

  if TMqmWrkCtr(res1.p_father).p_ReadOnly and (not VisRes1.JobsScheduled) then
  begin
    if TMqmWrkCtr(res2.p_father).p_ReadOnly and (not VisRes2.JobsScheduled) then
      Result := 0
    else
      Result := 1;
    exit
  end;

  if TMqmWrkCtr(res2.p_father).p_ReadOnly and (not VisRes2.JobsScheduled) then
  begin
    Result := -1;
    exit
  end;

  // ---- put no timings at the end ------------------------------------------

{  if not res1.p_occHasTimings then
  begin
    if not res2.p_occHasTimings then
      Result := 0
    else
      Result := 1;
    exit
  end;

  if not res2.p_occHasTimings then
  begin
    Result := -1;
    exit
  end;   }


{  if not VisRes1.JobsScheduled then
  begin
    if not VisRes2.JobsScheduled then
      Result := SortDynamicOnEqual(Item1,Item2)                  //Result := 0   // avi 25/08
    else
      Result := 1;
    Exit;
  end;

  if not VisRes2.JobsScheduled then
  begin
    Result := -1;
    Exit;
  end;

  // ---- put  xxx   xxx   xxx   ------------------------------------------

  if not VisRes1.GetFirstDateInDynamicPlan(Start1) then
  begin
    if not VisRes2.GetFirstDateInDynamicPlan(Start2) then
      Result := SortDynamicOnEqual(Item1,Item2)                                  //Result := 0
    else
      Result := 1;
    exit;
  end;

  if not VisRes2.GetFirstDateInDynamicPlan(Start2) then
  begin
    Result := -1;
    exit;
  end;

  if Start1 < Start2 then
    Result := -1
  else if Start1 > Start2 then
    Result := 1
  else
    Result := 0;

end;    }

//----------------------------------------------------------------------------//

function SortBySubResource(Res1, Res2: TMQMRes; Item1, Item2: pointer): integer;
var
  VisRes1, VisRes2: TMqmVisibleRes;
begin
  Result := 0;
  if res1.p_ResCode <> res2.p_ResCode then exit;
  VisRes1 := TMqmVisibleRes(Item1);
  VisRes2 := TMqmVisibleRes(Item2);

  if VisRes1.p_SubCode > VisRes2.p_SubCode then
    Result := 1
  else if VisRes1.p_SubCode < VisRes2.p_SubCode then
         Result := -1;
end;

//----------------------------------------------------------------------------//

function SortOnEqualCompat(Item1, Item2: Pointer) : integer;
var
  res1, res2: TMqmRes;
  Id : TSchedID;
begin
//  Result := 0;
  res1 := TMqmRes(TMqmVisibleRes(Item1).p_father);
  res2 := TMqmRes(TMqmVisibleRes(Item2).p_father);
  Id := p_pl.GetCompatModeInPlanId;
  if (res1.p_occGoodMaxQty[id]) and (res2.p_occGoodMaxQty[id]) then
  begin
    if res1.p_ResCode < res2.p_ResCode then
      Result := -1
    else if res1.p_ResCode > res2.p_ResCode then
      Result := 1
    else
//      Result := 0
      Result := SortBySubResource(Res1, Res2, Item1, Item2);
  end
  else if not (res1.p_occGoodMaxQty[id]) and not (res2.p_occGoodMaxQty[id]) then
  begin
    if res1.p_ResCode < res2.p_ResCode then
      Result := -1
    else if res1.p_ResCode > res2.p_ResCode then
      Result := 1
    else
//      Result := 0
      Result := SortBySubResource(Res1, Res2, Item1, ITem2);
  end
  else if (res1.p_occGoodMaxQty[id]) and not (res2.p_occGoodMaxQty[id]) then
    Result := -1
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function sortOnComp(Item1, Item2: Pointer): Integer;
var
  res1, res2: TMqmRes;
begin
  res1 := TMqmRes(TMqmVisibleRes(Item1).p_father);
  res2 := TMqmRes(TMqmVisibleRes(Item2).p_father);

  // ---- put readonly at the end --------------------------------------------

  if TMqmWrkCtr(res1.p_father).p_ReadOnly then
  begin
    if TMqmWrkCtr(res2.p_father).p_ReadOnly then
      Result := 0
    else
      Result := 1;
    exit
  end;

  if TMqmWrkCtr(res2.p_father).p_ReadOnly then
  begin
    Result := -1;
    exit
  end;

  // ---- put workcenter no good at the end ----------------------------------

  if item1 = item2 then                          // avi
  begin
    Result := 0;
    Exit
  end;

  if not res1.p_occGoodWkc[p_pl.GetCompatModeInPlanId] then
  begin
    if not res2.p_occGoodWkc[p_pl.GetCompatModeInPlanId] then
    begin
      if res1.p_ResCode < res2.p_ResCode then
        Result := -1
      else if res1.p_ResCode > res2.p_ResCode then
        Result := 1
      else
        Result := 0;                            // old only result := 0;
    end
    else
      Result := 1;
    exit
  end;

  if not res2.p_occGoodWkc[p_pl.GetCompatModeInPlanId] then
  begin
    Result := -1;
    exit
  end;

  // ---- put no timings at the end ------------------------------------------

  if not res1.p_occHasTimings then
  begin
    if not res2.p_occHasTimings then
      Result := 0
    else
      Result := 1;
    exit
  end;

  if not res2.p_occHasTimings then
  begin
    Result := -1;
    exit
  end;


  // ---- put case 99  ------------------------------------------

  if res1.p_occCompatVal = 99 then
  begin
    if res2.p_occCompatVal = 99 then
      Result := 0
    else
      Result := 1;
    exit
  end;

  if res2.p_occCompatVal = 99 then
  begin
    Result := -1;
    exit
  end;

  // ---- case min qty ------------------------------------------

  if not res1.p_occGoodMinQty[p_pl.GetCompatModeInPlanId] then
  begin
    if not res2.p_occGoodMinQty[p_pl.GetCompatModeInPlanId] then
      Result := 0
    else
      Result := 1;
    exit
  end;

  if not res2.p_occGoodMinQty[p_pl.GetCompatModeInPlanId] then
  begin
    Result := -1;
    exit
  end;

  // ---- case max qty ------------------------------------------

  if not res1.p_occGoodMaxQty[p_pl.GetCompatModeInPlanId] then
  begin
    if not res2.p_occGoodMaxQty[p_pl.GetCompatModeInPlanId] then
      Result := 0
    else
      Result := 1;
    exit
  end;

  if not res2.p_occGoodMaxQty[p_pl.GetCompatModeInPlanId] then
  begin
    Result := -1;
    exit
  end;

//-------------------------------------------------------------------------

  // ---- now check the real compatibility mode ------------------------------

  if res1.p_occCompatVal < res2.p_occCompatVal then
    Result := -1
  else if res1.p_occCompatVal = res2.p_occCompatVal then
    Result := SortOnEqualCompat(Item1, Item2)
  else
    Result := 1;

end;

//----------------------------------------------------------------------------//

procedure TGanttPanel.EnterCompatMode(id: TSchedId);
var
  i:   integer;
  res: TMqmRes;
  DatesInfo: TSQDatesInfo;
begin
  Assert(p_pl.GetCompatModeInPlanId <> CSchedIdNull);

  if p_sc.GetDatesInfo(id, DatesInfo) then
  begin
    m_shapeMan.m_LeftLimit := DatesInfo.LowStrDate;
    m_shapeMan.m_RightLimit := DatesInfo.HighEndDate;
    m_shapeMan.m_ApprovalDate := DatesInfo.ApprovalDate;
  end;

  res := TMqmRes(p_pl.GetCompatModeInBinVisRes);

  if DBAppSettings.TabResSort
  and (not m_inCompatMode)
  and (not Assigned(res)) then
//  and not Assigned(p_sc.GetExtLinkPtr(id)) then
  begin
    m_inCompatMode := true;
    m_rowList := TList.Create;
    for i := 0 to m_origRowList.Count-1 do
    begin
      res := TMqmRes(TMqmVisibleRes(m_origRowList[i]).p_father);

      with DBAppSettings do
        if ((not TabFilterRead) or (not TMqmWrkCtr(res.p_WrkCtr).p_ReadOnly)) and
           ((not TabWorkcenter) or res.p_occGoodWkc[p_pl.GetCompatModeInPlanId]) and
           ((not TabNoTimings)  or res.p_occHasTimings)                       and
           ((not TabNoCompat)   or (res.p_occCompatVal <> CompValNotComp)) then
          m_rowList.Add(m_origRowList[i]);
    end;

    m_rowList.Sort(sortOnComp);
    m_shapeMan.NewRowsAdded(true);
  end;
  m_shapeMan.SetApplyFunc(CheckCompat, pointer(id));
end;

//----------------------------------------------------------------------------//

procedure TGanttPanel.ExitCompatMode;
begin
  m_shapeMan.m_LeftLimit := 0;
  m_shapeMan.m_RightLimit := 0;
  m_shapeMan.m_ApprovalDate := 0;

  if m_inCompatMode then
  begin
    m_inCompatMode := false;
    m_rowList.Free;
    m_rowList := m_origRowList;

    if DBAppSettings.TabKeepSort then
    begin
      Assert(p_pl.GetCompatModeInPlanId <> CSchedIdNull);
      m_rowList.Sort(sortOnComp);
      m_shapeMan.NewRowsAdded(false)
    end else
      m_shapeMan.NewRowsAdded(true)
  end;
  m_shapeMan.SetApplyFunc(nil, nil)
end;

//----------------------------------------------------------------------------//

procedure TGanttPanel.SortOnDunamic;
begin
//  m_origRowList.Sort(sortOnDynamic);
  SetFirstJobOnDynamic;
  m_shapeMan.NewRowsAdded(true)
end;

//----------------------------------------------------------------------------//

procedure TGanttPanel.SetGanttConst(gc: TGanttConst);
begin
  if Assigned(m_gc) then m_gc.Free;
  m_gc := gc
end;

//----------------------------------------------------------------------------//

procedure TGanttPanel.SetRowHeight(RowHeight: integer);
begin
  m_gc.RH := RowHeight;
  m_shapeMan.m_rh := RowHeight;
  m_shapeMan.NewRowsAdded(false)
end;

//----------------------------------------------------------------------------//

procedure TGanttPanel.ClearObjList;
begin
  m_origRowList.Clear;
  m_shapeMan.NewRowsAdded(true);
end;

//----------------------------------------------------------------------------//

function TGanttPanel.GetListWcForFilter(ListWcFltr : TList) : boolean;
var
  I : Integer;
  Res : TMqmVisibleRes;
  WC : TMqmWrkCtr;

  function CheckWcInList(NewWc : String ; WcList : TList) : boolean;
  var
    J: Integer;
  begin
    Result := true;
    for J := 0 to WcList.Count - 1 do
      if NewWc = TMqmWrkCtr(WcList[J]).p_WrkCtrCode then
      begin
        Result := false;
        Exit
      end
  end;

begin
  Result := false;
  for I := 0 to m_origRowList.Count - 1 do
  begin
    Result := true;
    Res := TMqmVisibleRes(m_origRowList[I]);
    WC := TMqmWrkCtr(res.p_Father.p_Father);
    if CheckWcInList(WC.p_WrkCtrCode, ListWcFltr) then
      ListWcFltr.Add(WC);
  end;
end;

//----------------------------------------------------------------------------//

function TGanttPanel.GetGanttConst: TGanttConst;
begin
  Result := m_gc
end;

//----------------------------------------------------------------------------//

procedure TGanttPanel.SetFirstJobOnDynamic;
var
  VisRes : TMqmVisibleRes;
//  DateTime : TDateTime;
  JobId : TSchedId;
begin
  JobId := -1;
  if (m_origRowList.count = 0) then
    Exit;
  VisRes := TMqmVisibleRes(m_origRowList[0]);
  if Assigned(VisRes) then
  begin
    if VisRes.GetFirstJobIdInDynamicPlan(JobId) then
      GetPlanView.FocusOnDate(VisRes , JobId);
  end
end;

//----------------------------------------------------------------------------//

function SortResByIndex(Item1, Item2: Pointer) : integer;
var
  res1, res2: TMqmRes;
begin
//  Result := 0;
  res1 := TMqmRes(TMqmVisibleRes(Item1).p_father);
  res2 := TMqmRes(TMqmVisibleRes(Item2).p_father);

  if res1.m_Index < res2.m_Index then
    Result := -1  // res1 < res 2
  else if res1.m_Index > res2.m_Index then
    Result := 1   // res1 > res 2
  else
//    Result := 0;  fp - If equal sort by sub resource
    Result := SortBySubResource(res1, res2, Item1, Item2);

end;

//----------------------------------------------------------------------------//

function SortResByMachineType(Item1, Item2: Pointer) : integer;
var
  res1, res2: TMqmRes;
begin
//  Result := 0;
  res1 := TMqmRes(TMqmVisibleRes(Item1).p_father);
  res2 := TMqmRes(TMqmVisibleRes(Item2).p_father);

  if res1.m_Index < res2.m_Index then
  begin
    if res1.p_PlanType < res2.p_PlanType then
      Result := -1
    else if res1.p_PlanType > res2.p_PlanType then
       Result := 1
    else
    begin
      if TMqmWrkCtr(res1.p_WrkCtr).p_WrkCtrCode < TMqmWrkCtr(res2.p_WrkCtr).p_WrkCtrCode then
        Result := -1
      else if TMqmWrkCtr(res1.p_WrkCtr).p_WrkCtrCode > TMqmWrkCtr(res2.p_WrkCtr).p_WrkCtrCode then
        Result := 1
      else
      begin
        if res1.p_ResCode < res2.p_ResCode then
           Result := -1  // res1 < res 2
        else if res1.p_ResCode > res2.p_ResCode then
           Result := 1   // res1 > res 2
      end;
    end;
  end
  else if res1.m_Index > res2.m_Index then
  begin
    if res1.p_PlanType < res2.p_PlanType then
      Result := -1
    else if res1.p_PlanType > res2.p_PlanType then
       Result := 1
    else
    begin
      if TMqmWrkCtr(res1.p_WrkCtr).p_WrkCtrCode < TMqmWrkCtr(res2.p_WrkCtr).p_WrkCtrCode then
        Result := -1
      else if TMqmWrkCtr(res1.p_WrkCtr).p_WrkCtrCode > TMqmWrkCtr(res2.p_WrkCtr).p_WrkCtrCode then
        Result := 1

      else
      begin
        if res1.p_ResCode < res2.p_ResCode then
           Result := -1  // res1 < res 2
        else if res1.p_ResCode > res2.p_ResCode then
           Result := 1   // res1 > res 2
      end;

    end;
  end
  else
//    Result := 0;  fp - If equal sort by sub resource
    Result := SortBySubResource(res1, res2, Item1, Item2);
end;

function SortBySeq(Item1, Item2: Pointer) : integer;
var
  res1, res2: TMqmRes;
  VisRes1, VisRes2: TMqmVisibleRes;
begin
  res1 := TMqmRes(TMqmVisibleRes(Item1).p_father);
  res2 := TMqmRes(TMqmVisibleRes(Item2).p_father);

  if (TMqmWrkCtr(res1.p_WrkCtr).p_McmSeq = 0) and (TMqmWrkCtr(res2.p_WrkCtr).p_McmSeq > 0) then
    Result := 1
  else if (TMqmWrkCtr(res1.p_WrkCtr).p_McmSeq > 0) and (TMqmWrkCtr(res2.p_WrkCtr).p_McmSeq = 0) then
    Result := -1
  else
  begin

    if TMqmWrkCtr(res1.p_WrkCtr).p_McmSeq < TMqmWrkCtr(res2.p_WrkCtr).p_McmSeq then
      Result := -1
    else if TMqmWrkCtr(res1.p_WrkCtr).p_McmSeq > TMqmWrkCtr(res2.p_WrkCtr).p_McmSeq then
      Result := 1
    else //if both have the same McmSeq sort by Resource code
    begin
      if TMqmWrkCtr(res1.p_WrkCtr).p_WrkCtrCode < TMqmWrkCtr(res2.p_WrkCtr).p_WrkCtrCode then
        Result := -1
      else if TMqmWrkCtr(res1.p_WrkCtr).p_WrkCtrCode > TMqmWrkCtr(res2.p_WrkCtr).p_WrkCtrCode then
        Result := 1
      else //if both have the same WC sort by Resource code
      begin
        if res1.p_ResCode < res2.p_ResCode then
          Result := -1
        else if res1.p_ResCode > res2.p_ResCode then
          Result := 1
        else  //Same RES, check for SubRes
        begin
          VisRes1 := TMqmVisibleRes(Item1);
          VisRes2 := TMqmVisibleRes(Item2);

          if VisRes1.p_SubCode > VisRes2.p_SubCode then
            Result := 1
          else if VisRes1.p_SubCode < VisRes2.p_SubCode then
            Result := -1
          else
            Result := 0;
        end;
      end;
    end;
  end;

  //  Result := SortByWC(Item1, Item2); //Result := 0;  // res 1 = res 2
end;

function SortBySeqDesc(Item1, Item2: Pointer) : integer;
var
  res1, res2: TMqmRes;
begin
  res1 := TMqmRes(TMqmVisibleRes(Item1).p_father);
  res2 := TMqmRes(TMqmVisibleRes(Item2).p_father);

  if (TMqmWrkCtr(res1.p_WrkCtr).p_McmSeq = 0) and (TMqmWrkCtr(res2.p_WrkCtr).p_McmSeq > 0) then
    Result := 1
  else if (TMqmWrkCtr(res1.p_WrkCtr).p_McmSeq > 0) and (TMqmWrkCtr(res2.p_WrkCtr).p_McmSeq = 0) then
    Result := -1
  else
  begin

    if TMqmWrkCtr(res1.p_WrkCtr).p_McmSeq < TMqmWrkCtr(res2.p_WrkCtr).p_McmSeq then
      Result := 1  // res1 < res 2
    else if TMqmWrkCtr(res1.p_WrkCtr).p_McmSeq > TMqmWrkCtr(res2.p_WrkCtr).p_McmSeq then
      Result := -1   // res1 > res 2
    else //if both have the same WC sort by Resource code
    begin
      if TMqmWrkCtr(res1.p_WrkCtr).p_WrkCtrCode < TMqmWrkCtr(res2.p_WrkCtr).p_WrkCtrCode then
        Result := 1  // res1 < res 2
      else if TMqmWrkCtr(res1.p_WrkCtr).p_WrkCtrCode > TMqmWrkCtr(res2.p_WrkCtr).p_WrkCtrCode then
        Result := -1   // res1 > res 2
      else //if both have the same WC sort by Resource code
      begin
        if res1.p_ResCode < res2.p_ResCode then
          Result := 1  // res1 < res 2
        else if res1.p_ResCode > res2.p_ResCode then
          Result := -1   // res1 > res 2
        else
          Result := 0;
      end;
    end;
  end;

  //  Result := SortByWC(Item1, Item2); //Result := 0;  // res 1 = res 2
end;

function SortByResCode(Item1, Item2: Pointer) : integer;
var
  res1, res2: TMqmRes;
begin
//  Result := 0;
  res1 := TMqmRes(TMqmVisibleRes(Item1).p_father);
  res2 := TMqmRes(TMqmVisibleRes(Item2).p_father);

  if res1.p_ResCode < res2.p_ResCode then
    Result := -1  // res1 < res 2
  else if res1.p_ResCode > res2.p_ResCode then
    Result := 1   // res1 > res 2
  else
    Result := SortBySubResource(res1, res2, Item1, Item2);
end;

//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//

function SortByCategory(Item1, Item2: Pointer) : integer;
var
  res1, res2: TMqmRes;
begin
//  Result := 0;
  res1 := TMqmRes(TMqmVisibleRes(Item1).p_father);
  res2 := TMqmRes(TMqmVisibleRes(Item2).p_father);

  if TMqmResCat(res1.p_ResCat).p_ResCatCode < TMqmResCat(res2.p_ResCat).p_ResCatCode then
    Result := -1  // res1 < res 2
  else if TMqmResCat(res1.p_ResCat).p_ResCatCode > TMqmResCat(res2.p_ResCat).p_ResCatCode then
    Result := 1   // res1 > res 2
  else //if both have the same category sort by Resource code
    Result := SortByResCode(Item1, Item2); //Result := 0;  // res 1 = res 2

end;

//----------------------------------------------------------------------------//

function SortByWC(Item1, Item2: Pointer) : integer;
var
  res1, res2: TMqmRes;
begin
//  Result := 0;
  res1 := TMqmRes(TMqmVisibleRes(Item1).p_father);
  res2 := TMqmRes(TMqmVisibleRes(Item2).p_father);

  if TMqmWrkCtr(res1.p_WrkCtr).p_WrkCtrCode < TMqmWrkCtr(res2.p_WrkCtr).p_WrkCtrCode then
    Result := -1  // res1 < res 2
  else if TMqmWrkCtr(res1.p_WrkCtr).p_WrkCtrCode > TMqmWrkCtr(res2.p_WrkCtr).p_WrkCtrCode then
    Result := 1   // res1 > res 2
  else //if both have the same WC sort by Resource code
    Result := SortByResCode(Item1, Item2); //Result := 0;  // res 1 = res 2

end;

//----------------------------------------------------------------------------//

function SortByWCAndCategory(Item1, Item2: Pointer) : integer;
var
  res1, res2: TMqmRes;
begin
//  Result := 0;
  res1 := TMqmRes(TMqmVisibleRes(Item1).p_father);
  res2 := TMqmRes(TMqmVisibleRes(Item2).p_father);

  if TMqmWrkCtr(res1.p_WrkCtr).p_WrkCtrCode < TMqmWrkCtr(res2.p_WrkCtr).p_WrkCtrCode then
    Result := -1  // res1 < res 2
  else if TMqmWrkCtr(res1.p_WrkCtr).p_WrkCtrCode > TMqmWrkCtr(res2.p_WrkCtr).p_WrkCtrCode then
    Result := 1   // res1 > res 2
  else //if both have the same WC sort by Category code and also Res code
    Result := SortByCategory(Item1, Item2); //Result := 0;  // res 1 = res 2

end;

//----------------------------------------------------------------------------//
//sorts the resources on gantt by Resource
procedure TGanttPanel.SortByResourceCode;
begin
  m_origRowList.Sort(sortByResCode);
  m_shapeMan.NewRowsAdded(true);//refresh the Gantt
end;

//----------------------------------------------------------------------------//

procedure TGanttPanel.SortByIndex;
begin
  if DBAppGlobals.MCM_App then
     m_origRowList.Sort(SortBySeq)
  else
    m_origRowList.Sort(SortResByIndex);
  m_shapeMan.NewRowsAdded(true);//refresh the Gantt
end;

//----------------------------------------------------------------------------//
//sorts the resources on gantt by Category and Resource
procedure TGanttPanel.SortByCategoryAndResCode;
begin
  m_origRowList.Sort(sortByResCode);
  m_origRowList.Sort(sortByCategory);
  m_shapeMan.NewRowsAdded(true);//refresh the Gantt
end;

//----------------------------------------------------------------------------//
//sorts the resources on gantt by WC and Resource
procedure TGanttPanel.SortByWCAndRes;
begin
  m_origRowList.Sort(sortByResCode);
  m_origRowList.Sort(sortByWC);
  m_shapeMan.NewRowsAdded(true);//refresh the Gantt
end;

//----------------------------------------------------------------------------//
//sorts the resources on gantt by Sequence,WC and Resource
procedure TGanttPanel.SortBySequence;
begin
  m_origRowList.Sort(sortBySeq);
  m_shapeMan.NewRowsAdded(true);//refresh the Gantt
//  m_origRowList.Sort(sortBySeq);
end;

procedure TGanttPanel.SortBySequenceDesc;
begin
  m_origRowList.Sort(sortBySeqDesc);
  m_shapeMan.NewRowsAdded(true);//refresh the Gantt
end;

//sorts the resources on gantt by WC,Category and Resource
procedure TGanttPanel.SortByWCAndCatAndRes;
begin
  m_origRowList.Sort(sortByWCAndCategory);
  m_shapeMan.NewRowsAdded(true);//refresh the Gantt
end;

//----------------------------------------------------------------------------//

procedure TGanttPanel.UpdateListWithOldSort(lst: TList);
var
  i,k:    integer;
  VisRes: TList;
begin
  Assert(Assigned(lst));
  m_origRowList.Clear;
  for i := 0 to lst.Count-1 do
  begin
    Assert(Assigned(lst));
    VisRes := TMqmRes(lst[i]).GetVisResList;
    for k := 0 to VisRes.Count-1 do
      m_origRowList.Add(VisRes[k])
  end;

  p_SortType := SRT_Sequence;

  case p_SortType of
    SRT_RscCode : SortByResourceCode;
    SRT_RscCatCode : SortByCategoryAndResCode;
    SRT_WCRscCode  : SortByWCAndRes;
    SRT_WCCatRscCode : SortByWCAndCatAndRes;
    SRT_Customized : SortByIndex;
    SRT_Sequence : SortbySequence;
    SRT_SequenceDesc : SortbySequenceDesc;
  end;

end;

//----------------------------------------------------------------------------//

procedure TGanttPanel.CollapseSubRes(Res: TMqmRes);
var
  i:    integer;
  VisResLst : TList;
  VisRes : TMQMVisibleRes;
begin
  // Remove all visible res of resource except first one
  // This simulate collapse operation
  VisResLst := Res.GetVisResList;
  for i := VisResLst.Count -1 downto 1 do // Don't remove first visible res
  begin
    VisRes := TMQMVisibleRes(VisResLst.Items[i]);
    m_origRowList.Remove(VisRes);
  end;
end;

//----------------------------------------------------------------------------//

procedure TGanttPanel.ExpandSubRes(Res: TMqmRes);
var
  i,Pos:    integer;
  VisResLst : TList;
  VisRes : TMQMVisibleRes;
begin
  // add all visible res of resource except first one
  // This simulate expand operation
  VisResLst := Res.GetVisResList;
  Pos := SerchPosInOrigRowList(Res.p_ResCode);
  for i := VisResLst.Count -1 downto 1 do // Don't remove first visible res
  begin
    Pos := pos + 1;
    VisRes := TMQMVisibleRes(VisResLst.Items[i]);
    if m_origRowList.IndexOf(VisRes) = -1 then
      m_origRowList.Insert(Pos,VisRes);
  end;
end;

//----------------------------------------------------------------------------//

function TGanttPanel.SerchPosInOrigRowList(CodeRes : string) : Integer;
var
  I : integer;
begin
  Result := 0;
  for I := 0 to m_origRowList.Count - 1 do
  begin
    if CodeRes = TMqmRes(TMqmVisibleRes(m_origRowList[I]).p_father).p_ResCode then
    begin
      Result := I;
      exit;
    end;
  end;
end;

end.
