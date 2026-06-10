unit UMBinTbs;

interface

uses
  comctrls,
  classes,
  Graphics,
  menus,
  UMBinFunc,
  UMbinGrid,
  UGObjListSrv,
  UMSchedCont,
  UMViewTbs,
  UMTabCfg,
  UMbinGridMaterial,
  UMBinPanel;

type

  TBinTabSheet = class(TMViewTabSheet)
    m_BinPanel: TBinPanel;
    function   GetBinGrid: TBinDrawGrid;
    function   GetMatGrid: TBinDrawGridMat;
    procedure  OpenTbs;
    procedure  AssignFilter(fnc: TBinFilterJob; parms: TBinFilterParms);
    procedure  UpdateList;

  private
//    m_tbCfg:   TBinTabsCfg;
    m_IsDeleted : boolean;
    m_tabCode : integer;
    m_SearchTab : boolean;
    m_SlotFilterByDatesTab : boolean;
    m_AutoSequenceResultsTab : boolean;
    m_WarpCampatible : boolean;
    m_JobWarpCampatible : boolean;
    m_JobScheduleBySequenceTab : Boolean;
  public
    constructor CreateBinTbs(AOwner: TPageControl; PopUp: TPopUpMenu;
                             sc: TMSchedCont;
                             BinType: TBinType; filt: TFncFilter;
                             Parmflt: TBinFilterParms; IsNewTab: boolean;
                             tabCode: integer ; DftCnfic : boolean);
    constructor CreateMaterialTbs(AOwner: TPageControl; PopUp: TPopUpMenu;
                             sc: TMSchedCont;
                             BinType: TBinType; filt: TFncFilter;
                             Parmflt: TBinFilterParms; IsNewTab: boolean;
                             tabCode: integer ; DftCnfic : boolean);

    procedure  SetSearchIconForTab;
    procedure  SetSlotFilterByDatesIconForTab;
    procedure  SetAutoSequenceResultsIconForTab;
    destructor Destroy; override;

    function   GetCode: integer; override;
    procedure  SetCode(Code : Integer); override;
    property   p_SearchTab: boolean read m_SearchTab write m_SearchTab;
    property   p_SlotFilterByDatesTab : boolean read m_SlotFilterByDatesTab write m_SlotFilterByDatesTab;
    property   p_AutoSequenceResultsTab : boolean read m_AutoSequenceResultsTab write m_AutoSequenceResultsTab;
    property   P_WarpCampatible : boolean read m_WarpCampatible write m_WarpCampatible;
    property   P_JobWarpCampatible : boolean read m_JobWarpCampatible write m_JobWarpCampatible;
    property   P_JobScheduleBySequenceTab : boolean read m_JobScheduleBySequenceTab write m_JobScheduleBySequenceTab;

    property   p_IsDeleted: boolean read m_IsDeleted write m_IsDeleted;
  end;

implementation

//----------------------------------------------------------------------------//

constructor TBinTabSheet.CreateBinTbs(AOwner: TPageControl; PopUp: TPopUpMenu;
                                      sc: TMSchedCont;
                                      BinType: TBinType; filt: TFncFilter;
                                      Parmflt: TBinFilterParms;
                                      IsNewTab: boolean; tabCode: integer ; DftCnfic : boolean);
var
  BinCfg: TBinConfig;
begin
  inherited CreateViewTab(AOwner);
  m_BinPanel   := nil;
  PageControl  := AOwner;

  m_tabCode := tabCode;
  Parmflt.P_MaterialSchedFilter := false;
  BinCfg  := TBinConfig.Create;
  with BinCfg do
  begin
    m_OnDrawCell    := BinDrawCell;
    m_OnDblClick    := BinDblClick;
    m_OnSelectCell  := BinSelectCell;
    m_OnMouseDown   := BinMseDown;
    m_PopUp         := PopUp
  end;

  m_BinPanel := TBinPanel.CreateBinPnl(self, sc, BinCfg, BinType, filt, Parmflt, IsNewTab, DftCnfic);

  if m_BinPanel.P_BinDynamicPlan then
    ImageIndex := -1
  else
    ImageIndex := 12;
end;

//----------------------------------------------------------------------------//

constructor TBinTabSheet.CreateMaterialTbs(AOwner: TPageControl;
  PopUp: TPopUpMenu; sc: TMSchedCont; BinType: TBinType; filt: TFncFilter;
  Parmflt: TBinFilterParms; IsNewTab: boolean; tabCode: integer;
  DftCnfic: boolean);
var
  BinCfg: TBinConfig;
begin
  inherited CreateViewTab(AOwner);
  m_BinPanel   := nil;
  PageControl  := AOwner;
  DoubleBuffered := True;

  m_tabCode := tabCode;
  Parmflt.P_MaterialSchedFilter := true;
  BinCfg  := TBinConfig.Create;
  with BinCfg do
  begin
    m_OnDrawCell    := DrawMatCell;
    m_OnDblClick    := MatDblClick;
    m_OnSelectCell  := MatSelectCell;
    m_OnMouseDown   := MatMseDown;
    m_PopUp         := PopUp
  end;

  m_BinPanel := TBinPanel.CreateMaterialPnl(self, sc, BinCfg, BinType, filt, Parmflt, IsNewTab, DftCnfic);

 // if m_BinPanel.P_BinDynamicPlan then
 //   ImageIndex := -1
 // else
 //   ImageIndex := 12;
end;

//----------------------------------------------------------------------------//

procedure TBinTabSheet.SetSearchIconForTab;
begin
  if m_SearchTab then
    ImageIndex := 57
end;

//----------------------------------------------------------------------------//

procedure TBinTabSheet.SetSlotFilterByDatesIconForTab;
begin
  if m_SlotFilterByDatesTab then
    ImageIndex := 56
end;

//----------------------------------------------------------------------------//

procedure TBinTabSheet.SetAutoSequenceResultsIconForTab;
begin
  if m_AutoSequenceResultsTab then
    ImageIndex := 59
end;

//----------------------------------------------------------------------------//

procedure TBinTabSheet.OpenTbs;
begin
  TabVisible := true;
end;

//----------------------------------------------------------------------------//

destructor TBinTabSheet.Destroy;
begin
  m_BinPanel.Free;
  inherited destroy
end;

//----------------------------------------------------------------------------//

function TBinTabSheet.GetCode: integer;
begin
  Result := m_tabCode
end;

//----------------------------------------------------------------------------//

procedure TBinTabSheet.SetCode(Code : Integer);
begin
  m_tabCode := Code;
end;

//----------------------------------------------------------------------------//

procedure TBinTabSheet.AssignFilter(fnc: TBinFilterJob; parms: TBinFilterParms);
begin
  Assert(Assigned(m_BinPanel));
  m_BinPanel.AssignFilter(fnc, parms)
end;

//----------------------------------------------------------------------------//

procedure TBinTabSheet.UpdateList;
begin
  m_BinPanel.UpdateRowList
end;

//----------------------------------------------------------------------------//

function TBinTabSheet.GetBinGrid: TBinDrawGrid;
begin
  if Assigned(m_BinPanel) then
    Result := m_BinPanel.p_Grid
  else
    Result := nil;
end;

//----------------------------------------------------------------------------//

function TBinTabSheet.GetMatGrid: TBinDrawGridMat;
begin
  if Assigned(m_BinPanel) then
    Result := m_BinPanel.p_GridMat
  else
    Result := nil;
end;

end.
