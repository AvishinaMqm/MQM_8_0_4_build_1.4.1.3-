unit UMBinPanel;

interface

uses
  extctrls,
  controls,
  Windows,
  Classes,
  Sysutils,
  Grids,
  UMBinFunc,
  UGObjListSrv,
  UMSchedContFunc,
  menus,
  UMSchedList,
  UMSchedCont,
  UMbinGridMaterial,
  UMbinGrid;

type

  TBinPanel = class(TPanel)
    constructor CreateBinPnl(AOwner: TWinControl; sc: TMSchedCont; BinCfg: TBinConfig;
                             BinType: TBinType; filt: TFncFilter; Parmflt : TBinFilterParms ;IsNewTab : boolean ; DftCnfic : boolean);
    constructor CreateMaterialPnl(AOwner: TWinControl; sc: TMSchedCont; BinCfg: TBinConfig;
                             BinType: TBinType; filt: TFncFilter; Parmflt : TBinFilterParms ;IsNewTab : boolean ; DftCnfic : boolean);

    destructor Destroy ; override;

  private
    m_Grid:     TBinDrawGrid;
    m_GridMat : TBinDrawGridMat;
    m_fltParms: TBinFilterParms;
    m_ListWCPlan : TList;
    m_ListSelectedIds : TMSchedList;
  private
    function GetListWCPlan : TList;
    function  IsDynamicForPlan : boolean;
    function  GetNumberOfColumsSorted : integer;
    procedure CopySelectedIdsToListAndClearSelectedList;
    procedure UpdateSelectedIdsFromList;
  public
    m_BinType: TBinType;
    m_BinCfg : TBinConfig;
    m_objList: TMSchedList;
    m_ConfRec: TConfRec;
    procedure AssignFilter(fnc: TBinFilterJob; parms: TBinFilterParms);
    procedure UpdateRowList;
//    procedure DestroyJobsCheckBoxs;
    function  GetFiltParms: TBinFilterParms;
    procedure SetParamFilter(FilterParms : TBinFilterParms);
    procedure UpdateListWcPlanForFiltr;
    function  IsResVisible(Res: pointer): boolean;
    procedure UpdateForChangeFilter;
    procedure MainUpdateFilterAndSortTab;
    function  IsProdReqOnFilter : boolean;
    procedure RefreshGrid;
    property  p_Grid: TBinDrawGrid read m_Grid;
    property  p_GridMat : TBinDrawGridMat read m_GridMat;
    property  p_GetListWCPlan : TList read GetListWCPlan;
    property  P_BinDynamicPlan : boolean  read IsDynamicForPlan;
    property  p_GetNumberOfColumsSorted : Integer read GetNumberOfColumsSorted;

  end;

implementation

uses
  UMRes,
  FMAutoSched,
  UMPlan,
  UMObjCont,
  FMMainPlan,
  FMcfgBin,
  UMglobal,
  FmAutoRunSet,
  FMBin;

//----------------------------------------------------------------------------//
//  TBinPanel                                                                 //
//----------------------------------------------------------------------------//

procedure NotyChg(obj: TObject; chg: TObjLstChg);
begin
  if chg = TOL_Refresh then
  begin
    if not TBinPanel(obj).m_fltParms.P_MaterialSchedFilter then
      TBinPanel(obj).m_Grid.refresh
    else if TBinPanel(obj).m_fltParms.P_MaterialSchedFilter then
      TBinPanel(obj).m_GridMat.refresh;
    exit;
  end;

  if not TBinPanel(obj).m_fltParms.P_MaterialSchedFilter then
  begin

    if chg = TOL_UpdateWcPlan then
    begin
      if DBAppGlobals.MCM_App then
      begin
        //if (not TBinPanel(obj).P_BinDynamicPlan) then
         TBinPanel(obj).UpdateListWcPlanForFiltr;
      end
      else
      begin
       // if (not TBinPanel(obj).P_BinDynamicPlan) and (not IsDynamicPlanActiv) then
          TBinPanel(obj).UpdateListWcPlanForFiltr;
      end;
    end;

  end;

  if (chg = TOL_chgFiltr) or (chg = TOL_chg) then
    TBinPanel(obj).UpdateRowList;

  if TBinPanel(obj).m_fltParms.P_MaterialSchedFilter then exit;

  if (chg = TOL_SortListGroupedByFieldId) then
  begin
    if (TBinPanel(obj).m_fltParms.P_GroupedByCode <> '') then
       SortListGroupedByFieldId;
  end;

  if (chg = TOL_ClearGroupedByFieldList) then
     ClearGroupedByFieldList;

  if (chg = TOL_SavedShowGroupLinesInBin) then
  begin
    if (TBinPanel(obj).m_fltParms.P_GroupedByCode <> '') then
    begin
      TBinPanel(obj).m_fltParms.p_SavedShowContinueGroupLinesInBin  := TBinPanel(obj).m_fltParms.RecFilt.ShowContinueGroupLinesInBin;
      TBinPanel(obj).m_fltParms.p_savedShowBatchGroupLinesInBin     := TBinPanel(obj).m_fltParms.RecFilt.ShowBatchGroupLinesInBin;
      TBinPanel(obj).m_fltParms.RecFilt.ShowContinueGroupLinesInBin := CsSCG_Yes;
      TBinPanel(obj).m_fltParms.RecFilt.ShowBatchGroupLinesInBin    := true;
    end;
  end;

  if (chg = TOL_UpdatedSavedShowGroupLinesInBin) then
  begin
    if (TBinPanel(obj).m_fltParms.P_GroupedByCode <> '') then
    begin
      TBinPanel(obj).m_fltParms.RecFilt.ShowContinueGroupLinesInBin := TBinPanel(obj).m_fltParms.p_SavedShowContinueGroupLinesInBin;
      TBinPanel(obj).m_fltParms.RecFilt.ShowBatchGroupLinesInBin := TBinPanel(obj).m_fltParms.p_savedShowBatchGroupLinesInBin;
    end;
  end;

  if (chg = TOL_SavedSelectedIdsInListAndClearSelected) then
    TBinPanel(obj).CopySelectedIdsToListAndClearSelectedList;

  if (chg = TOL_UpdateSelectedIdsFromList) then
    TBinPanel(obj).UpdateSelectedIdsFromList;

end;

//----------------------------------------------------------------------------//

constructor TBinPanel.CreateBinPnl(AOwner: TWinControl; sc: TMSchedCont; BinCfg: TBinConfig;
                                   BinType: TBinType; filt: TFncFilter; Parmflt : TBinFilterParms ; IsNewTab : boolean ; DftCnfic : boolean);
begin
  inherited Create(AOwner);
  m_Grid     := nil;
  m_BinType  := BinType;
  m_BinCfg   := BinCfg;
  Parent     := AOwner;
  Align      := alClient;
  BevelInner := bvNone;
  BevelOuter := bvLowered;
  BevelWidth := 1;

  m_fltParms := Parmflt;
  m_ListWCPlan := TList.Create;
  m_ListSelectedIds := TMSchedList.Create(self);

  m_objList := p_pl.BinClientRegister(self, NotyChg, filt);

  m_Grid    := TBinDrawGrid.CreateBinGrid(self, sc, IsNewTab, DftCnfic);

  p_pl.BinAddSortFnc(self, 0, CompColValue, @m_ConfRec);

  if IsNewTab or DBAppSettings.RefreshBinByButton then
    p_pl.BinClientUpdateAll(self, true)

end;

//----------------------------------------------------------------------------//

constructor TBinPanel.CreateMaterialPnl(AOwner: TWinControl; sc: TMSchedCont; BinCfg: TBinConfig;
             BinType: TBinType; filt: TFncFilter; Parmflt: TBinFilterParms; IsNewTab, DftCnfic: boolean);
begin
  inherited Create(AOwner);
  m_Grid     := nil;
  m_BinType  := BinType;
  m_BinCfg   := BinCfg;
  Parent     := AOwner;
  Align      := alClient;
  BevelInner := bvNone;
  BevelOuter := bvLowered;
  BevelWidth := 1;
  DoubleBuffered := True;

  m_fltParms := Parmflt;
  m_ListWCPlan := TList.Create;
  m_ListSelectedIds := TMSchedList.Create(self);

  m_objList := p_pl.BinClientRegister(self, NotyChg, filt);

  m_GridMat    := TBinDrawGridMat.CreateBinGridMat(self, sc, IsNewTab, DftCnfic);

  p_pl.BinAddSortFnc(self, 0, UMbinGridMaterial.CompColValue, @m_ConfRec);

  if IsNewTab or DBAppSettings.RefreshBinByButton then
    p_pl.BinClientUpdateAll(self, true)

end;

//----------------------------------------------------------------------------//

destructor TBinPanel.Destroy;
begin
  m_objList.Free;
  if not m_fltParms.P_MaterialSchedFilter then
    m_Grid.Free
  else if m_fltParms.P_MaterialSchedFilter then
    m_GridMat.Free;
  p_pl.BinClientUnRegister(self);
  m_ListWCPlan.free;
  m_ListSelectedIds.Free;
  try
    inherited Destroy;
  except
  end;
end;

//----------------------------------------------------------------------------//

function TBinPanel.GetListWCPlan : TList;
begin
  Result := m_ListWCPlan;
end;

//----------------------------------------------------------------------------//

procedure TBinPanel.AssignFilter(fnc: TBinFilterJob; parms: TBinFilterParms);
begin
  if Assigned(m_fltParms) then m_fltParms.Free;
  m_fltParms := parms;
end;

//----------------------------------------------------------------------------//

procedure TBinPanel.UpdateListWcPlanForFiltr;
begin
  m_ListWcPlan.Clear;
  FMQMPlan.GetListForActPlanTab(m_ListWCPlan);
end;

//----------------------------------------------------------------------------//

function TBinPanel.IsResVisible(Res: pointer): boolean;
begin
  Result := false;
  if Assigned(FMQMPlan) then
    if FMQMPlan.GetActiveTab <> nil then
      if Assigned(FMQMPlan.GetActiveTab.p_ganttPanel) then
        if Assigned(FMQMPlan.GetActiveTab.p_ganttPanel.p_VisResList) then
          if (res <> nil) then
            if (FMQMPlan.GetActiveTab.p_ganttPanel.p_VisResList.IndexOf(res) >= 0) then
              Result := true;
end;

//----------------------------------------------------------------------------//

procedure TBinPanel.UpdateForChangeFilter;
begin
  p_pl.BinClientUpdateAllChange(self);
end;

//----------------------------------------------------------------------------//

procedure TBinPanel.MainUpdateFilterAndSortTab;
begin
  p_pl.MainUpdateFilterAndSort(self);
end;

//----------------------------------------------------------------------------//

function TBinPanel.IsProdReqOnFilter : boolean;
begin
  Result := false;
  if m_fltParms.RecFilt.ProdReq <> '' then
    Result := true;
end;

//----------------------------------------------------------------------------//

function TBinPanel.GetFiltParms: TBinFilterParms;
begin
  Result := m_fltParms
end;

//----------------------------------------------------------------------------//

procedure TBinPanel.SetParamFilter(FilterParms : TBinFilterParms);
begin
  m_fltParms := FilterParms
end;

//----------------------------------------------------------------------------//

procedure TBinPanel.UpdateRowList;
begin
  if m_fltParms.P_MaterialSchedFilter then
  begin
    if not assigned(m_GridMat) then
       exit;
    m_GridMat.SortRowBin;
    if m_objList.GetLinkCount = 0 then
      m_GridMat.RowCount := 2
    else
      m_GridMat.RowCount := m_objList.GetLinkCount + 1;

    if Assigned(FAutoSched) or IsAutoRunMode then
      m_GridMat.ResSetSelectedLenght
    else
      m_GridMat.SetSelectedLenght
  end
  else
  begin
    if not assigned(m_Grid) then
       exit;
    m_Grid.SortRowBin;
    if m_objList.GetLinkCount = 0 then
      m_Grid.RowCount := 2
    else
      m_Grid.RowCount := m_objList.GetLinkCount + 1;

    if Assigned(FAutoSched) or IsAutoRunMode then
      m_Grid.ResSetSelectedLenght
    else
      m_Grid.SetSelectedLenght
  end;
end;

//----------------------------------------------------------------------------//

{procedure TBinPanel.DestroyJobsCheckBoxs;
var
  I : Integer;
begin
  for I := 0 to m_objList.GetLinkCount - 1 do
  begin
    p_sc.CBoxSelDestroy(m_objList.GetLink(I));
  end;
end;  }

//----------------------------------------------------------------------------//

procedure TBinPanel.RefreshGrid;
begin
  if not m_fltParms.P_MaterialSchedFilter then
    m_Grid.Invalidate
  else //if m_fltParms.P_MaterialSchedFilter then
    m_GridMat.Invalidate
end;

//----------------------------------------------------------------------------//

function TBinPanel.IsDynamicForPlan : boolean;
begin
  if not (FiltWkcr_Active in m_fltParms.RecFilt.Options) then
    Result := true
  else
    Result := false;
end;

//----------------------------------------------------------------------------//

function TBinPanel.GetNumberOfColumsSorted : integer;
begin
  if not m_fltParms.P_MaterialSchedFilter then
  begin
    if (p_Grid.BinColumnSet[0].NumColSorted <= 0) or (p_Grid.BinColumnSet[0].NumColSorted > 12) then
      Result := 3
    else Result := p_Grid.BinColumnSet[0].NumColSorted
  end
  else
  begin
    result := 3;
    {if (p_GridMat.BinMatColumnSet[0].NumColSorted <= 0) or (p_GridMat.BinMatColumnSet[0].NumColSorted > 12) then
      Result := 3
    else Result := p_GridMat.BinMatColumnSet[0].NumColSorted}
  end;
end;

//----------------------------------------------------------------------------//

procedure TBinPanel.CopySelectedIdsToListAndClearSelectedList;
var
  I : Integer;
begin
  if not m_fltParms.P_MaterialSchedFilter then
  begin
    m_ListSelectedIds.ClearList;
    m_ListSelectedIds := m_Grid.GetSelectedList;
    if m_ListSelectedIds.GetLinkCount > 0 then
    begin
      for I := 0 to m_Grid.RowCount - 1 do
         m_Grid.ForceUnselected(I);
    end;
  end
  else if m_fltParms.P_MaterialSchedFilter then
  begin
    m_ListSelectedIds.ClearList;
    m_ListSelectedIds := m_Grid.GetSelectedList;
    if m_ListSelectedIds.GetLinkCount > 0 then
    begin
      for I := 0 to m_GridMat.RowCount - 1 do
         m_GridMat.ForceUnselected(I);
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TBinPanel.UpdateSelectedIdsFromList;
var
  I, Index : Integer;
begin
  if not m_fltParms.P_MaterialSchedFilter then
  begin
    for I := 0 to m_ListSelectedIds.GetLinkCount - 1 do
    begin
      Index := m_objList.IndexOf(m_ListSelectedIds.GetLink(I));
      if Index > -1 then
        p_Grid.ForceSelected(Index)
    end;
  end
  else
  begin
    for I := 0 to m_ListSelectedIds.GetLinkCount - 1 do
    begin
      Index := m_objList.IndexOf(m_ListSelectedIds.GetLink(I));
      if Index > -1 then
        p_GridMat.ForceSelected(Index)
    end;
  end;
end;

end.
