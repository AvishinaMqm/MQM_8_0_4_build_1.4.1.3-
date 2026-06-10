unit UMTabCfg;
interface

uses
  classes,
  UMBinFunc, UMGlobal, UMBinDefault, DMsrvPc, UMBinMatDefault,
  UMSchedContFunc,
  UMPlan,StrUtils;

type

  TTabCfg = class
    name:   string;
    code:   integer;
  end;

  TTabsCfg = class
    constructor Create;
    destructor  Destroy; override;

    procedure DeleteTab(cod: integer);
    procedure AddNewTab(tbCfg: TTabCfg);
    procedure UpdateTab(cod: integer; name: string; resList: TList; SlotGroup : Integer);
    procedure UpdateTabNewSort(cod: integer; name: string; resList: TList);


    function  FindTab(tabCode: integer): TTabCfg;
    function  FinfTabByName(TabName : string) : Integer;
    function  GetTab(tbNum: integer): TTabCfg;
    function  FindNewCode: integer;

    function  LoadFromDatabase: boolean; virtual; abstract;
    procedure StoreToDatabase; virtual; abstract;

  private
    m_tabList: TList;

    procedure Clear;
    function  GetCodePosition(cod: integer): integer;
    function  GetTabsCount: integer;

  public
    property  p_GetTabsCount : Integer read GetTabsCount;
  end;

  TResExpanded = Record
    obj : TmqmObj;
    Is_Res_Expanded : Integer;  //0 collapsed,1 expanded
  end;
  TTResExpanded = ^TResExpanded;

  TMcmTabConfig = Record
    Wkc        : TMqmObj;
    SlotGroup  : Integer;
    SlotSndLvl : String;
    WkcSndLvl  : String;
    IsSlotExpanded : Integer;
    IsWkcExpanded  : Integer;
  end;
  TTMcmTabConfig = ^TMcmTabConfig;

  TPlanTabCfg = class(TTabCfg)
    m_PlanType : TPlanType;
    m_Zoom: integer;
    m_HZoom: integer;
    m_SZoom: integer;
    m_SlotGroup: integer;
    m_CurrTScale: integer;
    m_CurrDtTime: TDateTime;

    //mcm
    MCMcNumMaxPrd : integer;
    MCMcMaxPrd1   : integer;
    MCMcMaxPrd2   : integer;
    MCMCatViewWcHoursPerc : integer;
    MCMPropertyViewWcHoursPerc : integer;

    m_ShowColorJobMode : TDisplayBarColor;
    m_PropertyCode : string;
    res:    TList;
    IsResExpanded : TList;
    sl_SlotGroup : TList;
    McmTabConfig : TList;
    destructor Destroy; override;
    function GetResIndex(ResCode : string) : integer;
    function GetWorkCenterList : TList;
  end;

  TPlanTabsCfg = class(TTabsCfg)
    constructor CreatePlanTbs(plan: TMqmPlan);

    procedure AddNewResourcesToExistedTabs;
    function  AddNewTab(tabName: string; resList: TList;  code: integer;
                        TypPlan : TPlanType; SlotGroup : Integer): TPlanTabCfg;
    function  LoadFromDatabase: boolean; override;
    procedure StoreToDatabase; override;

  private
    m_plan: TMqmPlan;
    procedure LoadMcmTabSettings;
  end;

  TBinTabCfg = class(TTabCfg)
    isView: boolean;
    //m_isMat : boolean;
   // BinArray : array[0..High(BinColDefault)] of TBinColCurrent;
    BinArray : array of TBinColCurrent;
    ParmFilt : TBinFilterParms;
    constructor CreatBinTab(IsMat : boolean);
    destructor  Destroy; override;
    procedure   DeleteTab(qryDelete : TMqmQuery; TabType : TTabObj);
    procedure   SaveArrayBinCol(BinColArray : array of TBinColCurrent);
    procedure   SaveColumnsCfgTab(qryColumns : TMqmQuery; qryDelete : TMqmQuery; TabType : TTabObj);
    procedure   SaveFiltersTab(qryFiltr : TMqmQuery; qryDelete : TMqmQuery);
  end;

  TBinTabsCfg = class(TTabsCfg)
    constructor CreateBinTbs;

    function  AddNewTab(TabName : string ; code : Integer; IsTabView : boolean; IsMat : boolean): TBinTabCfg;
    procedure FillArrayBinColByCod(tbCode : integer ; var BinColArray : array of TBinColCurrent);
    procedure SaveArrayBinCol(tbCod: integer ; BinColArray : array of TBinColCurrent);
    procedure SaveFilterBinTab(tbCod: integer ; filt : TBinFilterParms);
    function  GetBinFilter(tbCod: integer) : TBinFilterParms;
    function  LoadFromDatabase: boolean; override;
    procedure StoreToDatabase; override;
  end;

implementation

uses
  gnugettext,
  SysUtils,
  Forms,
  UMWkCtr,
  UMCommon,
  UMTblDesc,
  UMPlanGraph,
 // UMBinMatDefault,
  UMRes,
  UMPlanTbs,
  FMMainPlan,
  UGWorkCentersPlanShot;

//----------------------------------------------------------------------------//

constructor TTabsCfg.Create;
begin
  inherited Create;
  m_tabList := TList.Create
end;

//----------------------------------------------------------------------------//

procedure TTabsCfg.DeleteTab(cod: integer);
var
  pos: integer;
  cfg: TTabCfg;
begin
  pos := GetCodePosition(cod);
  if pos < 0 then exit; //tab already deleted
  cfg := TTabCfg(m_tabList[pos]);
  cfg.Free;
  m_tabList.Delete(pos)
end;

//----------------------------------------------------------------------------//

function TTabsCfg.GetCodePosition(cod: integer): integer;
var
  i:   integer;
  cfg: TTabCfg;
begin
  Result := -1;
  for i := 0 to m_tabList.Count - 1 do
  begin
    cfg := TTabCfg(m_tabList[i]);
    if cfg.code = cod then
    begin
      Result := i;
      break
    end
  end
end;

//----------------------------------------------------------------------------//

function TTabsCfg.FindTab(tabCode: integer): TTabCfg;
var
  i: integer;
begin
  for i := 0 to GetTabsCount - 1 do
  begin
    Result := TTabCfg(m_tabList[i]);
    if Result.code = tabCode then exit
  end;

  Result := nil
end;

//----------------------------------------------------------------------------//

function TTabsCfg.FinfTabByName(TabName : string) : Integer;
var
  I : Integer;
begin
  Result := 0;
  for i := 0 to GetTabsCount - 1 do
  begin
    if TTabCfg(m_tabList[i]).name = TabName then
    begin
      Result := TTabCfg(m_tabList[i]).code;
      Break
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TTabsCfg.AddNewTab(tbCfg: TTabCfg);
begin
  m_tabList.add(tbCfg)
end;

//----------------------------------------------------------------------------//

procedure TTabsCfg.UpdateTab(cod: integer; name: string; resList: TList; SlotGroup : Integer);
var
  cfg: TPlanTabCfg;
  i: integer;
  TempList, NewList : TList;
  RS : TTResExpanded;
  function FindInOldResList(Res : string): boolean;
  var
    J : Integer;
  begin
    Result := false;
    for J := 0 to resList.Count - 1 do
    begin
      if (res = TMqmRes(resList[J]).p_ResCode) then
      begin
        Result := true;
        exit
      end;
    end;
  end;

  function SearchForNewAdded(Res : string): boolean;
  var
    J : Integer;
  begin
    Result := false;
    for J := 0 to NewList.Count - 1 do
    begin
      if (res = TMqmRes(NewList[J]).p_ResCode) then
      begin
        Result := true;
        exit
      end;

    end;

  end;


begin
  if TPlanTabCfg(FindTab(cod)).m_PlanType = PDynamic then exit;
  cfg := TPlanTabCfg(FindTab(cod));
  cfg.name := name;
  if SlotGroup > -1 then
    cfg.m_SlotGroup := SlotGroup;
  TempList := TList.Create;
  NewList  := TList.Create;

  {for I := 0 to cfg.res.Count - 1 do
  begin
    if FindInOldResList(TMqmRes(cfg.res[I]).p_ResCode) then
      NewList.Add(cfg.res.Items[I])
  end;  }

  for I := 0 to resList.Count - 1 do
  begin
    if not SearchForNewAdded(TMqmRes(resList[I]).p_ResCode) then
      NewList.Add(resList.Items[I])
  end;

  cfg.res.Clear;
  cfg.IsResExpanded.Clear;
  cfg.sl_SlotGroup.Clear;

  for i := 0 to NewList.count - 1 do
  begin
      cfg.res.add(NewList.Items[i]);

      NEW(RS);
      RS.obj := resList.Items[i];
      RS.Is_Res_Expanded := 1;
      cfg.IsResExpanded.add(RS);


      if cfg.sl_SlotGroup.IndexOf(TmqmRes(resList.Items[i]).p_WrkCtr) = -1 then
          cfg.sl_SlotGroup.add(TmqmRes(resList.Items[i]).p_WrkCtr)
  end;

  NewList.free;
  TempList.Free;

end;

//----------------------------------------------------------------------------//

procedure TTabsCfg.UpdateTabNewSort(cod: integer; name: string; resList: TList);
var
  cfg: TPlanTabCfg;
  i: integer;
  RS : TTResExpanded;
begin
 // if TPlanTabCfg(FindTab(cod)).m_PlanType = PDynamic then
 //   exit;
  cfg := TPlanTabCfg(FindTab(cod));
  cfg.name := name;
  cfg.res.Clear;
  cfg.IsResExpanded.Clear;
  cfg.sl_SlotGroup.clear;
  for i := 0 to resList.count - 1 do
  begin
      cfg.res.add(resList.Items[i]);

      NEW(RS);
      RS.obj := resList.Items[i];
      RS.Is_Res_Expanded := 1;
      cfg.IsResExpanded.add(RS);

      if cfg.sl_SlotGroup.IndexOf(TmqmRes(resList.Items[i]).p_WrkCtr) = -1 then
          cfg.sl_SlotGroup.add(TmqmRes(resList.Items[i]).p_WrkCtr)
  end;
end;

//----------------------------------------------------------------------------//

destructor TTabsCfg.Destroy;
begin
  Clear;
  m_tabList.Free;
  inherited Destroy
end;

//----------------------------------------------------------------------------//

function SortOnCode(Item1, Item2: Pointer): integer;
var
  cfg1, cfg2: TTabCfg;
begin
  cfg1 := TTabCfg(Item1);
  cfg2 := TTabCfg(Item2);

  if cfg1.code < cfg2.code then
    Result := -1
  else if cfg1.code > cfg2.code then
    Result := 1
  else
    Result := 0
end;

//----------------------------------------------------------------------------//

function TTabsCfg.FindNewCode: integer;
//var
//  cfg: TTabCfg;
begin
  m_tabList.Sort(SortOnCode);

{  for Result := 0 to GetTabsCount - 1 do
  begin
    cfg := TTabCfg(m_tabList[Result]);
    if cfg.code <> Result then exit
  end;

  Result := GetTabsCount }

  if GetTabsCount = 0 then
     Result := 0
  else
  begin
    Result := TTabCfg(m_tabList[GetTabsCount - 1]).code + 1;
  end;

end;

//----------------------------------------------------------------------------//

procedure TTabsCfg.Clear;
var
  i:   integer;
  cfg: TTabCfg;
begin
  for i := 0 to m_tabList.Count-1 do
  begin
    cfg := TTabCfg(m_tabList[i]);
    cfg.Free
  end;
  m_tabList.Clear
end;

//----------------------------------------------------------------------------//

function TTabsCfg.GetTabsCount: integer;
begin
  Result := m_tabList.Count
end;

//----------------------------------------------------------------------------//

function TTabsCfg.GetTab(tbNum: integer): TTabCfg;
begin
  Assert(tbNum < m_tabList.Count);
  Result := TTabCfg(m_tabList[tbNum])
end;

//----------------------------------------------------------------------------//

constructor TPlanTabsCfg.CreatePlanTbs(plan: TMqmPlan);
begin
  inherited Create;
  m_plan    := plan
end;

//----------------------------------------------------------------------------//

function TPlanTabsCfg.AddNewTab(tabName: string; resList: TList; code: integer;
                                TypPlan : TPlanType; SlotGroup : Integer): TPlanTabCfg;
var
  i:   integer;
  cfg: TPlanTabCfg;
  RS : TTResExpanded;
begin
  cfg := TPlanTabCfg.Create;

  cfg.m_PlanType := TypPlan;
  cfg.code   := code;
  cfg.m_Zoom := ZOOM_CONST;
  cfg.m_HZoom := ZOOM_CONST;
  cfg.m_SZoom := 20; 
  cfg.m_CurrTScale := 3;
  cfg.m_CurrDtTime := now;

  cfg.MCMcNumMaxPrd := -1;//3;
  cfg.MCMcMaxPrd1 := -1;
  cfg.MCMcMaxPrd2 := -1;
  cfg.MCMCatViewWcHoursPerc := -1;
  cfg.MCMPropertyViewWcHoursPerc := -1;
  cfg.m_SlotGroup := SlotGroup;

  if (cfg.m_PlanType = PDynamic) then
    cfg.name := _('Dynamic');

  cfg.name := tabName;
  cfg.res    := TList.Create;
  cfg.IsResExpanded    := TList.Create;
  cfg.sl_SlotGroup := TList.Create;

  if Assigned(resList) then
  begin
    for i := 0 to resList.count - 1 do
    begin
      cfg.res.add(resList.Items[i]);

      NEW(RS);
      RS.obj := resList.Items[i];
      RS.Is_Res_Expanded := 1;
      cfg.IsResExpanded.add(RS);

      if cfg.sl_SlotGroup.IndexOf(TmqmRes(resList.Items[i]).p_WrkCtr) = -1 then
          cfg.sl_SlotGroup.add(TmqmRes(resList.Items[i]).p_WrkCtr)
    end;
  end;


  inherited AddNewTab(cfg);
  Result := cfg
end;

//----------------------------------------------------------------------------//

procedure TPlanTabsCfg.AddNewResourcesToExistedTabs;
var
  I, J, W : Integer;
  TabCfg : TPlanTabCfg;
  TempWcMcmList : TList;
  McmRes : TMqmRes;
  McmWrkCtr : TMqmWrkCtr;
  function FindWcInList(WcCode : string) : boolean;
  var
    W : integer;
  begin
    Result := false;
    for W := 0 to TempWcMcmList.Count - 1 do
    begin
      if (TMqmWrkCtr(TempWcMcmList[W]).p_WrkCtrCode = WcCode) then
      begin
        Result := true;
        break
      end;
    end;
  end;

begin
  TempWcMcmList := TList.Create;
  for i := 0 to GetTabsCount - 1 do
  begin
    TabCfg := TPlanTabCfg(m_tabList[i]);
    TempWcMcmList.clear;
    for J := 0 to TabCfg.res.Count - 1 do
    begin
      McmRes := TMqmRes(TabCfg.res[J]);
      McmWrkCtr := TMqmWrkCtr(McmRes.p_WrkCtr);
      if not FindWcInList(McmWrkCtr.p_WrkCtrCode) then
         TempWcMcmList.Add(McmWrkCtr)
    end;
    if TabCfg.res.Count > 0 then
       TabCfg.res.Clear;
    for W := 0 to TempWcMcmList.Count - 1 do
    begin
      McmWrkCtr := TMqmWrkCtr(TempWcMcmList[W]);
      for J := 0 to McmWrkCtr.p_ResCount - 1 do
        TabCfg.res.Add(McmWrkCtr.p_Res[J]);
    end;
  end;

end;

//----------------------------------------------------------------------------//

function TPlanTabsCfg.LoadFromDatabase : boolean;
var
  cfg:       TPlanTabCfg;
  qry:       TMqmQuery;
  mqmObj:    TMqmObj;
  tbMaster,
  tbDetail:  ^TTblInfo;
  tabName:   string;
  tabCode:   integer;
  RS : TTResExpanded;
begin
  Result := false;
  Clear;
  TabName := '';

  tbMaster := @tblInfo[tbl_cfg_planTab_master];
//  SetFldPfx(tbMaster.pfx);
  qry := CreateQuery(Cfg_DB);
  // load the header informations

  with qry do
  begin
    SQL.Add('select *');
    SQL.Add(' from ' + tbMaster.GetTableName);
    SQL.Add(' where ' + CreateFld(tbMaster.pfx, fli_wkstCode) + '=');
    SQL.Add('''' + IniAppGlobals.WkstCode + '''');
    SQL.Add(AND_IDF_Condition(CreateFld(tbMaster.pfx, fli_Identifier)));
    SQL.Add('order by ' + CreateFld(tbMaster.pfx, fli_TabsCode));
    Open;
    First;

    while not EOF do
    begin
   //   Result := true;
      Application.ProcessMessages;
      TabCode := FieldByName(CreateFld(tbMaster.pfx, fli_TabsCode)).AsInteger;
      TabName := FieldByName(CreateFld(tbMaster.pfx, fli_TabsDesc)).AsString;

      cfg := TPlanTabCfg.Create;

      cfg.name := TabName;
      cfg.code := TabCode;

      cfg.m_Zoom := FieldByName(CreateFld(tbMaster.pfx, fli_Zoom)).AsInteger;
      cfg.m_HZoom := FieldByName(CreateFld(tbMaster.pfx, fli_HZoom)).AsInteger;
      cfg.m_SZoom := FieldByName(CreateFld(tbMaster.pfx, fli_SZoom)).AsInteger;
      cfg.m_CurrTScale := FieldByName(CreateFld(tbMaster.pfx, fli_CurrTScale)).AsInteger;
      cfg.m_CurrDtTime := FieldByName(CreateFld(tbMaster.pfx, fli_CurrDtTime)).AsDateTime;

      cfg.m_SlotGroup := FieldByName(CreateFld(tbMaster.pfx, fli_SlotGroup)).AsInteger;

      cfg.MCMcNumMaxPrd := FieldByName(CreateFld(tbMaster.pfx, fli_MCMcNumMaxPrd)).AsInteger;
      cfg.MCMcMaxPrd1   := FieldByName(CreateFld(tbMaster.pfx, fli_MCMcMaxPrd1)).AsInteger;
      cfg.MCMcMaxPrd2   := FieldByName(CreateFld(tbMaster.pfx, fli_MCMcMaxPrd2)).AsInteger;
      cfg.MCMCatViewWcHoursPerc := FieldByName(CreateFld(tbMaster.pfx, fli_MCMCatViewWcHoursPerc)).AsInteger;
      cfg.MCMPropertyViewWcHoursPerc := FieldByName(CreateFld(tbMaster.pfx, fli_MCMPropertyViewWcHoursPerc)).AsInteger;

      if (qry.FieldByName(CreateFld(tbMaster.pfx, fli_ShowColorJobMode)).AsString = '1') then
        cfg.m_ShowColorJobMode := PreDefinedPropList
      else if (qry.FieldByName(CreateFld(tbMaster.pfx, fli_ShowColorJobMode)).AsString = '2') then
        cfg.m_ShowColorJobMode := DinamicPropList
      else if (qry.FieldByName(CreateFld(tbMaster.pfx, fli_ShowColorJobMode)).AsString = '3') then
        cfg.m_ShowColorJobMode := ScheduleStatus
      else
        cfg.m_ShowColorJobMode := Standard;

      cfg.m_PropertyCode := '';
      if not qry.FieldByName(CreateFld(tbMaster.pfx, fli_PropertyCode)).isnull then
        cfg.m_PropertyCode := qry.FieldByName(CreateFld(tbMaster.pfx, fli_PropertyCode)).AsString;

      case StrToInt(FieldByName(CreateFld(tbMaster.pfx, fli_TypeOfUse)).AsString) of
        0 : begin
              cfg.m_PlanType := PNormal;
              cfg.res  := TList.Create;
              cfg.IsResExpanded := TList.Create;
              cfg.sl_SlotGroup := TList.Create;
            end;

        1 : cfg.m_PlanType := PDynamic;
         else
           cfg.m_PlanType := PNormal;
      end;

      inherited AddNewTab(cfg);

      Next
    end;
    Close;

  end;

  // Load the detail informations
  tbDetail := @tblInfo[tbl_cfg_planTab_det];
//  SetFldPfx(tbDetail.pfx);

  qry.SQL.Clear;

  with qry do
  begin
    SQL.Add('select');
    SQL.Add(CreateFld(tbDetail.pfx, fli_wkstCode)    + ',');
    SQL.Add(CreateFld(tbDetail.pfx, fli_TabsCode)    + ',');
    SQL.Add(CreateFld(tbDetail.pfx, fli_toPos)       + ',');
    SQL.Add(CreateFld(tbDetail.pfx, fli_rsc)         + ',');
    SQL.Add(CreateFld(tbDetail.pfx, fli_IsResExpanded));
    SQL.Add(' from ' + tbDetail.GetTableName);
    SQL.Add(' where ' + CreateFld(tbDetail.pfx, fli_wkstCode) + '=');
    SQL.Add('''' + IniAppGlobals.WkstCode + '''');
    SQL.Add(AND_IDF_Condition(CreateFld(tbDetail.pfx, fli_Identifier)));
    SQL.Add('order by ' + CreateFld(tbDetail.pfx, fli_TabsCode) + ',' + CreateFld(tbDetail.pfx, fli_toPos));
    Open;
    First;

    cfg := nil;

    while not EOF do
    begin
      Application.ProcessMessages;
      tabCode := FieldByName(CreateFld(tbDetail.pfx, fli_TabsCode)).AsInteger;
      if (cfg = nil) or (cfg.code <> tabCode) then
        cfg := TPlanTabCfg(FindTab(tabCode));
      //Assert(Assigned(cfg));
      if not assigned(cfg) then
      begin
        qry.Next;
        continue;
      end;

      if (cfg.m_PlanType = PDynamic) then
      begin
        qry.Next;
        continue;
      end;
      mqmObj := m_plan.FindResByCode(FieldByName(CreateFld(tbDetail.pfx, fli_rsc)).AsString);
      if Assigned(mqmObj) then
      begin
        cfg.res.Add(mqmObj);

        New(RS);
        RS.obj := mqmObj;
        RS.Is_Res_Expanded := FieldByName(CreateFld(tbDetail.pfx, fli_IsResExpanded)).AsInteger;
        cfg.IsResExpanded.Add(RS);

        result := true;


        if cfg.sl_SlotGroup.IndexOf(TmqmRes(mqmObj).p_WrkCtr) = -1 then
          cfg.sl_SlotGroup.add(TmqmRes(mqmObj).p_WrkCtr)
      end;
      //if no resource found for tab - delete tab // avi 14/7/2010
     // if ((result = false) and Assigned(cfg)) then
     // begin
     //   inherited DeleteTab(tabCode);
     // end;
      qry.Next
    end;

    Close
  end;

  qry.free;

  if DBAppGlobals.MCM_App then
  begin
    AddNewResourcesToExistedTabs;
    LoadMcmTabSettings;
  end;
end;

//----------------------------------------------------------------------------//

procedure TPlanTabsCfg.LoadMcmTabSettings;
var
  qry      : TMqmQuery;
  tbinfo   : ^TTblInfo;
  i        : Integer;
  cfg      : TPlanTabCfg;
  McmTabConfig : TTMcmTabConfig;
begin
  tbinfo := @tblInfo[tbl_cfg_McmTabConfig];

  qry := CreateQuery(Cfg_DB);
  qry.SQL.Clear;
  with qry do
  begin
    SQL.Add('select ');
    SQL.Add(CreateFld(tbinfo.pfx, fli_TabsCode) + ',');
    SQL.Add(CreateFld(tbinfo.pfx, fli_wkCtrCode) + ',');
    SQL.Add(CreateFld(tbinfo.pfx, fli_SlotGroup) + ',');
    SQL.Add(CreateFld(tbinfo.pfx, fli_SlotScnLevel) + ',');
    SQL.Add(CreateFld(tbinfo.pfx, fli_WkcScnLevel) + ',');
    SQL.Add(CreateFld(tbinfo.pfx, fli_isSlotExpanded) + ',');
    SQL.Add(CreateFld(tbinfo.pfx, fli_isWkcExpanded));
    SQL.Add(' from ' + tbinfo.GetTableName);
    SQL.Add(' where ' + CreateFld(tbinfo.pfx, fli_wkstCode) + '=');
    SQL.Add('''' + IniAppGlobals.WkstCode + '''');
    SQL.Add(AND_IDF_Condition(CreateFld(tbinfo.pfx, fli_Identifier)));
    Open;
  end;

  while not qry.eof do
  begin
    cfg := TPlanTabCfg(FindTab(qry.FieldByName(CreateFld(tbinfo.pfx, fli_TabsCode)).AsInteger));

    if cfg = nil then
    begin
      qry.Next;
      continue;
    end;

    if cfg.m_PlanType = PDynamic then
    begin
      qry.Next;
      continue;
    end;

    if cfg.McmTabConfig = nil then
      cfg.McmTabConfig := TList.Create;

    New(McmTabConfig);

    // find the WC object matching the stored code
    McmTabConfig.Wkc := nil;
    for i := 0 to cfg.GetWorkCenterList.Count - 1 do
      if TMqmWrkCtr(cfg.GetWorkCenterList[i]).p_WrkCtrCode =
         qry.FieldByName(CreateFld(tbinfo.pfx, fli_wkCtrCode)).AsString then
      begin
        McmTabConfig.Wkc := TMqmWrkCtr(cfg.GetWorkCenterList[i]);
        break;
      end;

    McmTabConfig.SlotGroup  := qry.FieldByName(CreateFld(tbinfo.pfx, fli_SlotGroup)).AsInteger;
    McmTabConfig.SlotSndLvl := qry.FieldByName(CreateFld(tbinfo.pfx, fli_SlotScnLevel)).AsString;
    McmTabConfig.WkcSndLvl  := qry.FieldByName(CreateFld(tbinfo.pfx, fli_WkcScnLevel)).AsString;

    if qry.FieldByName(CreateFld(tbinfo.pfx, fli_isSlotExpanded)).IsNull then
      McmTabConfig.IsSlotExpanded := 0
    else
      McmTabConfig.IsSlotExpanded := qry.FieldByName(CreateFld(tbinfo.pfx, fli_isSlotExpanded)).AsInteger;

    if qry.FieldByName(CreateFld(tbinfo.pfx, fli_isWkcExpanded)).IsNull then
      McmTabConfig.IsWkcExpanded := 0
    else
      McmTabConfig.IsWkcExpanded := qry.FieldByName(CreateFld(tbinfo.pfx, fli_isWkcExpanded)).AsInteger;

    cfg.McmTabConfig.Add(McmTabConfig);

    qry.Next;
  end;

  qry.Close;
  qry.Free;
end;

//----------------------------------------------------------------------------//

procedure TPlanTabsCfg.StoreToDatabase;
var
  i, j, x, y, mcmI, arraysize : integer;
  grpExpanded : Boolean;
  cfg       : TPlanTabCfg;
  qry       : TMqmQuery;
  tbInfo    : ^TTblInfo;
  tbInfoMcm : ^TTblInfo;
  pt        : TMqmPlanTabSheet;
  PlanLineGroup : TPlanLineGroup;
begin
  if GetTabsCount = 0 then
     Exit;

  arraysize := -1;
  qry := CreateQuery(Cfg_DB);
  Qry.Transaction := CreateTransaction(Cfg_DB);
  Qry.Transaction.StartTransaction;

  // handle the heading informations

  tbInfo := @tblInfo[tbl_cfg_planTab_master];
  qry.SQL.Clear;
  qry.SQL.Add('delete from ' + tbInfo.GetTableName + ' where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + ' = ''' +  IniAppGlobals.WkstCode + '''');
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.ExecSQL;
  qry.Close;

  qry.SQL.Clear;
  qry.SQL.Add('insert into ' + tbInfo.GetTableName + '(');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_Identifier) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_wkstCode)   + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_TabsCode)   + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_TypeOfUse)  + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_TabsDesc)   + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_Zoom)       + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_CurrTScale) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_CurrDtTime) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_ShowColorJobMode) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_PropertyCode)     + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_MCMcNumMaxPrd) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_MCMcMaxPrd1) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_MCMcMaxPrd2) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_MCMCatViewWcHoursPerc) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_MCMPropertyViewWcHoursPerc)  + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_HZoom)+ ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SZoom) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SlotGroup));
  qry.SQL.Add(') values (');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Identifier) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wkstCode) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_TabsCode) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_TypeOfUse)+ ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_TabsDesc) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Zoom) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_CurrTScale) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_CurrDtTime) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_ShowColorJobMode)+ ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_PropertyCode) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_MCMcNumMaxPrd) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_MCMcMaxPrd1) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_MCMcMaxPrd2) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_MCMCatViewWcHoursPerc) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_MCMPropertyViewWcHoursPerc) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_HZoom)+ ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_SZoom)+ ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_SlotGroup));
  qry.SQL.Add(')');

  for i := 0 to GetTabsCount - 1 do
  begin
    cfg := TPlanTabCfg(GetTab(i));

    if (cfg.m_PlanType = PDynamic) then
       continue;

    Inc(arraysize);
    qry.params.arraysize := arraysize + 1;

    qry.params[0].AsIntegers[arraysize]  := StrToInt(IniAppGlobals.Identifier);
    qry.params[1].AsStrings[arraysize]  := IniAppGlobals.WkstCode;
    qry.params[2].AsIntegers[arraysize] := cfg.code;

    case cfg.m_PlanType of
      PNormal : qry.params[3].AsStrings[arraysize] := '0'; // Normal
      PDynamic : qry.params[3].AsStrings[arraysize] := '1'; // Dynamic
    else
      qry.params[3].AsStrings[arraysize] := '0';
    end;
    if Length(cfg.name) > 40 then
      cfg.name := AnsiLeftStr(cfg.name,37) + '...';

    qry.params[4].AsStrings[arraysize] := cfg.name;
    qry.params[5].AsIntegers[arraysize] := cfg.m_Zoom;
    qry.params[6].AsIntegers[arraysize] := cfg.m_CurrTScale;
    qry.params[7].AsDateTimes[arraysize] := cfg.m_CurrDtTime;

    if cfg.m_ShowColorJobMode = Standard then
    begin
      qry.params[8].AsStrings[arraysize] := '0';
      qry.params[9].AsStrings[arraysize] := '';
    end
    else if cfg.m_ShowColorJobMode = PreDefinedPropList then
      qry.params[8].AsStrings[arraysize] := '1'
    else if cfg.m_ShowColorJobMode = DinamicPropList then
      qry.params[8].AsStrings[arraysize] := '2'
    else if cfg.m_ShowColorJobMode = ScheduleStatus then
      qry.params[8].AsStrings[arraysize] := '3';

    qry.params[9].AsStrings[arraysize]   := cfg.m_PropertyCode;
    qry.params[10].AsIntegers[arraysize] := cfg.MCMcNumMaxPrd;
    qry.params[11].AsIntegers[arraysize] := cfg.MCMcMaxPrd1;
    qry.params[12].AsIntegers[arraysize] := cfg.MCMcMaxPrd2;
    qry.params[13].AsIntegers[arraysize] := cfg.MCMCatViewWcHoursPerc;
    qry.params[14].AsIntegers[arraysize] := cfg.MCMPropertyViewWcHoursPerc;
    qry.params[15].AsIntegers[arraysize] := cfg.m_HZoom;
    qry.params[16].AsIntegers[arraysize] := cfg.m_SZoom;
    qry.params[17].AsIntegers[arraysize] := cfg.m_SlotGroup;
  end;

  if arraysize >= 0 then
    qry.execute(arraysize + 1);

  qry.Close;
  // handle the detail informations
  tbInfo := @tblInfo[tbl_cfg_planTab_det];

  qry.SQL.Clear;
  qry.SQL.Add('delete from ' + tbInfo.GetTableName + ' where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + ' = ''' +  IniAppGlobals.WkstCode + '''');
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.ExecSQL;
  qry.Close;

  qry.SQL.Clear;
  qry.SQL.Add('insert into ' + tbInfo.GetTableName  + '(');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_Identifier) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_wkstCode) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_TabsCode) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_toPos) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_rsc)+ ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_IsResExpanded));
  qry.SQL.Add(') values (');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Identifier) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wkstCode) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_TabsCode) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_toPos) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_rsc) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_IsResExpanded));
  qry.SQL.Add(')');

 // qry.Params[0].AsInteger := StrToInt(IniAppGlobals.Identifier);
 // qry.Params[1].AsString := IniAppGlobals.WkstCode;

  arraysize := -1;
  for i := 0 to GetTabsCount - 1 do
  begin
    if arraysize = 1000 then
    begin
      qry.execute(arraysize + 1);
      arraysize := -1;
    end;

    cfg := TPlanTabCfg(GetTab(i));
    if (cfg.m_PlanType = PDynamic) then
       continue;
    if cfg.res.Count > 0 then
    begin
      for j := 0 to cfg.res.Count - 1 do
      begin
        Inc(arraysize);
        qry.params.arraysize := arraysize + 1;

        qry.Params[0].AsIntegers[arraysize] := StrToInt(IniAppGlobals.Identifier);
        qry.Params[1].AsStrings[arraysize]  := IniAppGlobals.WkstCode;
        qry.Params[2].AsIntegers[arraysize] := cfg.code;
        qry.Params[3].AsIntegers[arraysize] := J;
        qry.Params[4].AsStrings[arraysize]  := TMqmRes(cfg.res[j]).p_ResCode;

        if j > cfg.IsResExpanded.count-1 then
          qry.Params[5].AsIntegers[arraysize] := 1
        else
          qry.Params[5].AsIntegers[arraysize] := TTResExpanded(cfg.IsResExpanded[j]).Is_Res_Expanded;
      end;
    end;
  end;
  if arraysize >= 0 then
    qry.execute(arraysize + 1);
{
  qry.SQL.Clear;
  qry.SQL.Add('insert into ' + tbInfo.GetTableName  + '(');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_Identifier) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_wkstCode) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_TabsCode) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_toPos) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_rsc));
  qry.SQL.Add(') values (');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Identifier) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wkstCode) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_TabsCode) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_toPos) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_rsc));
  qry.SQL.Add(')');

 // qry.params.Clear;

  for i := 0 to GetTabsCount - 1 do
  begin
    cfg := TPlanTabCfg(GetTab(i));
    if (cfg.m_PlanType = PDynamic) then
       continue;

    if cfg.res.Count > 0 then
      for j := 0 to cfg.res.Count - 1 do
      begin
        Inc(arraysize);
        qry.params.arraysize := arraysize + 1;

        qry.params[0].AsStrings[arraysize] := IniAppGlobals.Identifier;
        qry.params[1].AsStrings[arraysize] := IniAppGlobals.WkstCode;

        qry.params[2].AsIntegers[arraysize] := cfg.code;
        qry.params[3].AsIntegers[arraysize] := J;
        qry.params[4].AsStrings[arraysize] := TMqmRes(cfg.res[j]).p_ResCode;
      end
  end;

  if arraysize >= 0 then
    qry.execute(arraysize + 1);  }

  // MCM tab config: save per-WC slot/wkc second-level and expand state
  if DBAppGlobals.MCM_App then
  begin
    qry.Close;
    tbInfoMcm := @tblInfo[tbl_cfg_McmTabConfig];

    // delete all existing rows for this workstation+identifier
    qry.SQL.Text := 'Delete from ' + tbInfoMcm.GetTableName
      + ' where ' + CreateFld(tbInfoMcm.pfx, fli_Identifier) + ' = ' + IniAppGlobals.Identifier
      + ' and '   + CreateFld(tbInfoMcm.pfx, fli_wkstCode)   + ' = ' + QuotedStr(IniAppGlobals.WkstCode);
    qry.ExecSQL;

    qry.SQL.Clear;
    qry.SQL.Add('insert into ' + tbInfoMcm.GetTableName + '(');
    qry.SQL.Add(CreateFld(tbInfoMcm.pfx, fli_Identifier)    + ',');
    qry.SQL.Add(CreateFld(tbInfoMcm.pfx, fli_wkstCode)      + ',');
    qry.SQL.Add(CreateFld(tbInfoMcm.pfx, fli_TabsCode)      + ',');
    qry.SQL.Add(CreateFld(tbInfoMcm.pfx, fli_wkCtrCode)     + ',');
    qry.SQL.Add(CreateFld(tbInfoMcm.pfx, fli_SlotGroup)     + ',');
    qry.SQL.Add(CreateFld(tbInfoMcm.pfx, fli_SlotScnLevel)  + ',');
    qry.SQL.Add(CreateFld(tbInfoMcm.pfx, fli_WkcScnLevel)   + ',');
    qry.SQL.Add(CreateFld(tbInfoMcm.pfx, fli_isSlotExpanded)+ ',');
    qry.SQL.Add(CreateFld(tbInfoMcm.pfx, fli_isWkcExpanded) );
    qry.SQL.Add(') values (');
    qry.SQL.Add(':' + CreateFld(tbInfoMcm.pfx, fli_Identifier)    + ',');  // 0
    qry.SQL.Add(':' + CreateFld(tbInfoMcm.pfx, fli_wkstCode)      + ',');  // 1
    qry.SQL.Add(':' + CreateFld(tbInfoMcm.pfx, fli_TabsCode)      + ',');  // 2
    qry.SQL.Add(':' + CreateFld(tbInfoMcm.pfx, fli_wkCtrCode)     + ',');  // 3
    qry.SQL.Add(':' + CreateFld(tbInfoMcm.pfx, fli_SlotGroup)     + ',');  // 4
    qry.SQL.Add(':' + CreateFld(tbInfoMcm.pfx, fli_SlotScnLevel)  + ',');  // 5
    qry.SQL.Add(':' + CreateFld(tbInfoMcm.pfx, fli_WkcScnLevel)   + ',');  // 6
    qry.SQL.Add(':' + CreateFld(tbInfoMcm.pfx, fli_isSlotExpanded)+ ',');  // 7
    qry.SQL.Add(':' + CreateFld(tbInfoMcm.pfx, fli_isWkcExpanded) );       // 8
    qry.SQL.Add(')');

    arraysize := -1;

    for mcmI := GetPlanView.m_pgcPlan.PageCount - 1 downto 1 do
    begin
      pt  := TMqmPlanTabSheet(GetPlanView.m_pgcPlan.Pages[mcmI]);
      cfg := TPlanTabCfg(GetPlanView.m_planTbCfg.FindTab(pt.GetCode));

      if cfg.m_PlanType = PDynamic then continue;
      if cfg.GetWorkCenterList.Count = 0 then continue;

      for j := 0 to cfg.GetWorkCenterList.Count - 1 do
      begin
        if TMqmWrkCtr(cfg.GetWorkCenterList[j]).p_ReadOnly
           and (not TMqmWrkCtr(cfg.GetWorkCenterList[j]).p_Visible) then
          continue;

        Inc(arraysize);
        qry.Params.ArraySize := arraysize + 1;

        qry.Params[0].AsIntegers[arraysize] := StrToInt(IniAppGlobals.Identifier);
        qry.Params[1].AsStrings[arraysize]  := IniAppGlobals.WkstCode;
        qry.Params[2].AsIntegers[arraysize] := cfg.code;
        qry.Params[3].AsStrings[arraysize]  := TMqmWrkCtr(cfg.GetWorkCenterList[j]).p_WrkCtrCode;
        qry.Params[4].AsIntegers[arraysize] := cfg.m_SlotGroup;
        // default empty values (overwritten below if WC found in pShot)
        qry.Params[5].AsStrings[arraysize]  := '';
        qry.Params[6].AsStrings[arraysize]  := '';
        qry.Params[7].AsIntegers[arraysize] := 0;
        qry.Params[8].AsIntegers[arraysize] := 0;

        for x := 0 to pt.p_PlanWcControl.P_planWcView.p_pShot.p_numSons - 1 do
        begin
          PlanLineGroup := TPlanLineGroup(pt.p_PlanWcControl.P_planWcView.p_pShot.GetPlanLine(x));

          if PlanLineGroup.P_WrkCtr = nil then break;
          if PlanLineGroup.P_WrkCtr.p_WrkCtrCode <> TMqmWrkCtr(cfg.GetWorkCenterList[j]).p_WrkCtrCode then continue;

          // first son: WCGroup header (div/plant/wkcgrp grouping row) or plain WC row
          if PlanLineGroup.p_son[0] is TPlanLineWCGroup then
          begin
            // slot-level grouping row
            if PlanLineGroup.p_SecondLevelType = lvl_property then
              qry.Params[5].AsStrings[arraysize] := PlanLineGroup.p_PropCode
            else
              qry.Params[5].AsStrings[arraysize] := '';

            // save property sub-row visibility or group expand state
            if (PlanLineGroup.p_SecondLevelType <> Lvl_non) and
               (PlanLineGroup.p_numSons > 1) and
               (PlanLineGroup.p_son[1] is TPlanLineSecondLevel) then
            begin
              // group has property/category sub-rows — save sub-row visibility
              if TPlanLineSecondLevel(PlanLineGroup.p_son[1]).p_shownAsSubLevel then
                qry.Params[7].AsIntegers[arraysize] := 1
              else
                qry.Params[7].AsIntegers[arraysize] := 0;
            end
            else
            begin
              // no property sub-rows — save group expand state from p_SlotGroup_Lists
              grpExpanded := True;
              for y := 0 to pt.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup_Lists.Count - 1 do
                if TTSlotGrp_WKC(pt.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup_Lists[y]).m_Group
                   = TPlanLineWCGroup(PlanLineGroup.p_son[0]).m_Group_name then
                begin
                  grpExpanded := TTSlotGrp_WKC(pt.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup_Lists[y]).m_IsExpanded;
                  break;
                end;
              if grpExpanded then
                qry.Params[7].AsIntegers[arraysize] := 1
              else
                qry.Params[7].AsIntegers[arraysize] := 0;
            end;
          end
          else
          begin
            // WC-level second row (category or property sub-breakdown)
            if PlanLineGroup.p_SecondLevelType = lvl_property then
              qry.Params[6].AsStrings[arraysize] := PlanLineGroup.p_PropCode
            else if PlanLineGroup.p_SecondLevelType = Lvl_Wc_category then
              qry.Params[6].AsStrings[arraysize] := 'wkcat'
            else
              qry.Params[6].AsStrings[arraysize] := '';

            if (PlanLineGroup.p_numSons > 1)
               and (PlanLineGroup.p_son[1] is TPlanLineSecondLevel)
               and TPlanLineSecondLevel(PlanLineGroup.p_son[1]).p_shownAsSubLevel then
              qry.Params[8].AsIntegers[arraysize] := 1
            else
              qry.Params[8].AsIntegers[arraysize] := 0;
          end;

          break; // found the matching pShot line — done for this WC
        end;
      end;
    end;

    if arraysize >= 0 then
      qry.Execute(arraysize + 1);
  end;

  Qry.Transaction.Commit;
  qry.Close;
  qry.free;
end;

//----------------------------------------------------------------------------//

constructor TBinTabsCfg.CreateBinTbs;
begin
  inherited Create
end;

//----------------------------------------------------------------------------//

procedure TBinTabsCfg.FillArrayBinColByCod(tbCode : integer ; var BinColArray : array of TBinColCurrent);
var
  cfg : TBinTabCfg;
  I, K, TabCode : Integer;

  function FindPos(s : CBinColId): integer;
  var
    J: Integer;
  begin
    Result := 0;
    for J := Low(BinColArray) to High(BinColArray) do
      if s = BinColArray[J].Field then
      begin
        Result := J;
        Exit
      end
  end;

begin
  TabCode := GetCodePosition(tbCode);
  cfg := TBinTabCfg(m_tabList[TabCode]);
  for I := Low(BinColArray) to High(BinColArray) do
  begin
    K := FindPos(cfg.BinArray[I].Field);
    BinColArray[K].Field := cfg.BinArray[I].Field;
    BinColArray[K].Title := cfg.BinArray[I].Title;
    BinColArray[K].Pos := cfg.BinArray[I].Pos;
    BinColArray[K].Width := cfg.BinArray[I].Width;
    BinColArray[K].Visible := cfg.BinArray[I].Visible;
    BinColArray[K].Order := cfg.BinArray[I].Order;
    BinColArray[K].PropCode := cfg.BinArray[I].PropCode;
    BinColArray[K].DescendingSort := cfg.BinArray[I].DescendingSort;
    BinColArray[K].NumColSorted := cfg.BinArray[I].NumColSorted;
  end;
end;

//----------------------------------------------------------------------------//

procedure TBinTabsCfg.SaveArrayBinCol(tbCod: integer ; BinColArray : array of TBinColCurrent);
var
  cfg: TBinTabCfg;
  I, TabCode : Integer;
begin
  TabCode := GetCodePosition(tbCod);
  cfg := TBinTabCfg(m_tabList[TabCode]);
  for I := Low(BinColArray) to High(BinColArray) do
  begin
    cfg.BinArray[I].Field := BinColArray[I].Field;
    cfg.BinArray[I].Title := BinColArray[I].Title;
    cfg.BinArray[I].Pos := BinColArray[I].Pos;
    cfg.BinArray[I].Width := BinColArray[I].Width;
    cfg.BinArray[I].Visible := BinColArray[I].Visible;
    cfg.BinArray[I].PropCode := BinColArray[I].PropCode;
    cfg.BinArray[I].Order := BinColArray[I].Order;
    cfg.BinArray[I].DescendingSort := BinColArray[I].DescendingSort;
    cfg.BinArray[I].NumColSorted := BinColArray[I].NumColSorted;
  end;
end;

//----------------------------------------------------------------------------//

procedure TBinTabsCfg.SaveFilterBinTab(tbCod: integer ; filt : TBinFilterParms);
var
  cfg:     TBinTabCfg;
  TabCode: integer;
begin
  TabCode := GetCodePosition(tbCod);
  cfg := TBinTabCfg(m_tabList[TabCode]);
  cfg.ParmFilt := filt;
end;

//----------------------------------------------------------------------------//

function TBinTabsCfg.GetBinFilter(tbCod: integer) : TBinFilterParms;
var
  cfg:     TBinTabCfg;
  TabCode: integer;
begin
  TabCode := GetCodePosition(tbCod);
  cfg := TBinTabCfg(m_tabList[TabCode]);
  Result := cfg.ParmFilt;
end;

//----------------------------------------------------------------------------//

function TBinTabsCfg.AddNewTab(TabName : String ; code : Integer; IsTabView : boolean; IsMat : boolean): TBinTabCfg;
var
  cfg: TBinTabCfg;
begin
  cfg := TBinTabCfg.CreatBinTab(IsMat);

  cfg.isView := isTabView;
  cfg.name   := TabName;
  cfg.code   := code;

  inherited AddNewTab(cfg);
  Result := cfg;
end;

//----------------------------------------------------------------------------//

function TBinTabsCfg.LoadFromDatabase : boolean;
var
  I:         integer;
  cfg:       TBinTabCfg;
  qryColum : TMqmQuery;
  QryFiltr : TMqmQuery;
  tbInfo, tbInfoCol:   ^TTblInfo;
  TabName :  string;
  TabCode :  integer;
  str:       string;
  FoundColumsInDb : boolean;
begin

  // First part will take the normal tabs (without material tabs)
  Clear;
  TabName := '';

  tbInfo := @tblInfo[tbl_cfg_binFilter];

  qryFiltr := CreateQuery(Cfg_DB);

  qryFiltr.SQL.Clear;
  qryFiltr.SQL.Add('Select * from ' + tbInfo.GetTableName + ' Where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + ' = ''' +  IniAppGlobals.WkstCode + '''');
  qryFiltr.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qryFiltr.SQL.Add(' order by ' + CreateFld(tbInfo.pfx, fli_TabsCode));
  qryFiltr.Open;
  qryFiltr.First;

  tbInfo := @tblInfo[tbl_cfg_binTab_col];
//  SetFldPfx(tbInfo.pfx);

  qryColum := CreateQuery(Cfg_DB);

  qryColum.SQL.Clear;
  qryColum.SQL.Add('Select * from ' + tbInfo.GetTableName + ' Where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + ' = ''' +  IniAppGlobals.WkstCode + '''');
  qryColum.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qryColum.SQL.Add(' And ' + CreateFld(tbInfo.pfx, fli_TabsCode) + ' <> ''' + '-1''');
  qryColum.SQL.Add(' And ' + CreateFld(tbInfo.pfx, fli_TabsCode) + ' <> ''' + '-2''');
  qryColum.SQL.Add(' And ' + CreateFld(tbInfo.pfx, fli_TabsCode) + ' <> ''' + '-3''');
  qryColum.SQL.Add(' And ' + CreateFld(tbInfo.pfx, fli_TabsCode) + ' <> ''' + '-4''');
  qryColum.SQL.Add(' And ' + CreateFld(tbInfo.pfx, fli_TabsCode) + ' <> ''' + '-5''');
  qryColum.SQL.Add(' And ' + CreateFld(tbInfo.pfx, fli_TabsCode) + ' <> ''' + '-6''');
  qryColum.SQL.Add(' And ' + CreateFld(tbInfo.pfx, fli_TabsCode) + ' <> ''' + '-7''');
  qryColum.SQL.Add(' And ' + CreateFld(tbInfo.pfx, fli_TypeOfUse) + ' = ' + QuotedStr('0'));
  //qryColum.SQL.Add(' And ((' + CreateFld(tbInfo.pfx, fli_TypeOfUse) + ' <> ' + QuotedStr('1') + ')');
  //qryColum.SQL.Add(' OR (' + CreateFld(tbInfo.pfx, fli_TypeOfUse) + ' is null ))');
  qryColum.SQL.Add(' order by ' + CreateFld(tbInfo.pfx, fli_TabsCode));
  qryColum.SQL.Add(' , ' + CreateFld(tbInfo.pfx, fli_BinColField));
  qryColum.Open;
  qryColum.First;

  with qryFiltr do
    while not EOF do
    begin
//      Result := true;
      FoundColumsInDb := false;
      tbInfo := @tblInfo[tbl_cfg_binFilter];
    //  SetFldPfx(tbInfo.pfx);

      TabCode := FieldByName(CreateFld(tbInfo.pfx, fli_TabsCode)).AsInteger;
      TabName := FieldByName(CreateFld(tbInfo.pfx, fli_TabsDesc)).AsString;
      cfg := TBinTabCfg.CreatBinTab(false);

      cfg.name := TabName;
      cfg.code := TabCode;

      if FieldByName(CreateFld(tbInfo.pfx, fli_TabVis)).AsInteger = 1 then
        cfg.isView := true
      else
        cfg.isView := false;

      cfg.ParmFilt := TBinFilterParms.Create;

      cfg.ParmFilt.RecFilt.MinQty := FieldByName(CreateFld(tbInfo.pfx, fli_MinQty)).AsFloat;
      if (cfg.ParmFilt.RecFilt.MinQty <> -1) then
        Include(cfg.ParmFilt.RecFilt.Options, FiltQty);

      cfg.ParmFilt.RecFilt.MaxQty := FieldByName(CreateFld(tbInfo.pfx, fli_MaxQty)).AsInteger;

      cfg.ParmFilt.RecFilt.Resource := Trim(FieldByName(CreateFld(tbInfo.pfx, fli_rsc)).AsString);
      if (cfg.ParmFilt.RecFilt.Resource <> '') then
        Include(cfg.ParmFilt.RecFilt.Options, FiltResource);

      cfg.ParmFilt.RecFilt.ResourceTo := Trim(FieldByName(CreateFld(tbInfo.pfx, fli_rsc_To)).AsString);
      if (cfg.ParmFilt.RecFilt.ResourceTo <> '') then
        Include(cfg.ParmFilt.RecFilt.Options, FiltResourceTo);

      if FindField(CreateFld(tbInfo.pfx, fli_FiltResCatCode)) <> nil then
      begin
        cfg.ParmFilt.RecFilt.ResCatCode := Trim(FieldByName(CreateFld(tbInfo.pfx, fli_FiltResCatCode)).AsString);
        if (cfg.ParmFilt.RecFilt.ResCatCode <> '') then
          Include(cfg.ParmFilt.RecFilt.Options, FiltResCat);
      end;

      cfg.ParmFilt.RecFilt.ProdType := Trim(FieldByName(CreateFld(tbInfo.pfx, fli_ProdType)).AsString);
      if (cfg.ParmFilt.RecFilt.ProdType <> '') then
        Include(cfg.ParmFilt.RecFilt.Options, FiltProdType);

      cfg.ParmFilt.RecFilt.ProdLowDate_From  := FieldByName(CreateFld(tbInfo.pfx, fli_ProdLowDate_From)).AsDateTime;
      if cfg.ParmFilt.RecFilt.ProdLowDate_From <> 0 then
        Include(cfg.ParmFilt.RecFilt.Options, FiltLowDate);

      cfg.ParmFilt.RecFilt.ProdLowDate_To  := FieldByName(CreateFld(tbInfo.pfx, fli_ProdLowDate_To)).AsDateTime;
      if cfg.ParmFilt.RecFilt.ProdLowDate_To <> 0 then
        Include(cfg.ParmFilt.RecFilt.Options, FiltLowDate);

      cfg.ParmFilt.RecFilt.ProdDelivDate_From := FieldByName(CreateFld(tbInfo.pfx, fli_DelivDate_From)).AsDateTime;
      if cfg.ParmFilt.RecFilt.ProdDelivDate_From <> 0 then
        Include(cfg.ParmFilt.RecFilt.Options, FiltDeliveryDate);

      cfg.ParmFilt.RecFilt.ProdDelivDate_To := FieldByName(CreateFld(tbInfo.pfx, fli_DelivDate_To)).AsDateTime;
      if cfg.ParmFilt.RecFilt.ProdDelivDate_To <> 0 then
        Include(cfg.ParmFilt.RecFilt.Options, FiltDeliveryDate);

      cfg.ParmFilt.RecFilt.PlanStartDate_From := FieldByName(CreateFld(tbInfo.pfx, fli_PlanStartDate_From)).AsDateTime;
      if (cfg.ParmFilt.RecFilt.PlanStartDate_From <> 0) then
        Include(cfg.ParmFilt.RecFilt.Options, FiltPlanStartDate);

      cfg.ParmFilt.RecFilt.PlanStartDate_To := FieldByName(CreateFld(tbInfo.pfx, fli_PlanStartDate_To)).AsDateTime;
      if (cfg.ParmFilt.RecFilt.PlanStartDate_To <> 0) then
        Include(cfg.ParmFilt.RecFilt.Options, FiltPlanStartDate);

      cfg.ParmFilt.RecFilt.PlanStartDate_DaysFromToday := FieldByName(CreateFld(tbInfo.pfx, fli_PlanStartDateToday_From)).AsInteger;
      if cfg.ParmFilt.RecFilt.PlanStartDate_DaysFromToday <> 0 then
        Include(cfg.ParmFilt.RecFilt.Options, FiltPlanStartDate_DaysFromToday);

      cfg.ParmFilt.RecFilt.PlanStartDate_DaysTillToday := FieldByName(CreateFld(tbInfo.pfx, fli_PlanStartDateToday_To)).AsInteger;
      if cfg.ParmFilt.RecFilt.PlanStartDate_DaysTillToday <> 0 then
        Include(cfg.ParmFilt.RecFilt.Options, FiltPlanStartDate_DaysFromToday);
                                      ////
      cfg.ParmFilt.RecFilt.PlanEndDate_From := FieldByName(CreateFld(tbInfo.pfx, fli_PlanEndDate_From)).AsDateTime;
      if (cfg.ParmFilt.RecFilt.PlanEndDate_From <> 0) then
        Include(cfg.ParmFilt.RecFilt.Options, FiltPlanEndDate);

      cfg.ParmFilt.RecFilt.PlanEndDate_To := FieldByName(CreateFld(tbInfo.pfx, fli_PlanEndDate_To)).AsDateTime;
      if (cfg.ParmFilt.RecFilt.PlanEndDate_To <> 0) then
        Include(cfg.ParmFilt.RecFilt.Options, FiltPlanEndDate);

      cfg.ParmFilt.RecFilt.PlanEndDate_DaysFromToday := FieldByName(CreateFld(tbInfo.pfx, fli_PlanEndDateToday_From)).AsInteger;
      if cfg.ParmFilt.RecFilt.PlanEndDate_DaysFromToday <> 0 then
        Include(cfg.ParmFilt.RecFilt.Options, FiltPlanEndDate_DaysFromToday);

      cfg.ParmFilt.RecFilt.PlanEndDate_DaysTillToday := FieldByName(CreateFld(tbInfo.pfx, fli_PlanEndDateToday_To)).AsInteger;
      if cfg.ParmFilt.RecFilt.PlanEndDate_DaysTillToday <> 0 then
        Include(cfg.ParmFilt.RecFilt.Options, FiltPlanEndDate_DaysFromToday);

      cfg.ParmFilt.RecFilt.NextStartDate_From := FieldByName(CreateFld(tbInfo.pfx, fli_NextStartDate_From)).AsDateTime;
      if (cfg.ParmFilt.RecFilt.NextStartDate_From <> 0) then
        Include(cfg.ParmFilt.RecFilt.Options, FiltNextStartDate);

      cfg.ParmFilt.RecFilt.NextStartDate_To := FieldByName(CreateFld(tbInfo.pfx, fli_NextStartDate_To)).AsDateTime;
      if (cfg.ParmFilt.RecFilt.NextStartDate_To <> 0) then
        Include(cfg.ParmFilt.RecFilt.Options, FiltNextStartDate);

      cfg.ParmFilt.RecFilt.NextStartDate_DaysFromToday := FieldByName(CreateFld(tbInfo.pfx, fli_NextStartDateToday_From)).AsInteger;
      if cfg.ParmFilt.RecFilt.NextStartDate_DaysFromToday <> 0 then
        Include(cfg.ParmFilt.RecFilt.Options, FiltNextStartDate_DaysFromToday);

      cfg.ParmFilt.RecFilt.NextStartDate_DaysTillToday := FieldByName(CreateFld(tbInfo.pfx, fli_NextStartDateToday_To)).AsInteger;
      if cfg.ParmFilt.RecFilt.NextStartDate_DaysTillToday <> 0 then
        Include(cfg.ParmFilt.RecFilt.Options, FiltNextStartDate_DaysFromToday);

      cfg.ParmFilt.RecFilt.PrevEndDate_From := FieldByName(CreateFld(tbInfo.pfx, fli_PrevEndDate_From)).AsDateTime;
      if (cfg.ParmFilt.RecFilt.PrevEndDate_From <> 0) then
        Include(cfg.ParmFilt.RecFilt.Options, FiltPrevEndDate);

      cfg.ParmFilt.RecFilt.PrevEndDate_to := FieldByName(CreateFld(tbInfo.pfx, fli_PrevEndDate_to)).AsDateTime;
      if (cfg.ParmFilt.RecFilt.PrevEndDate_to <> 0) then
        Include(cfg.ParmFilt.RecFilt.Options, FiltPrevEndDate);

      cfg.ParmFilt.RecFilt.PrevEndDate_DaysFromToday := FieldByName(CreateFld(tbInfo.pfx, fli_PrevEndDateToday_From)).AsInteger;
      if cfg.ParmFilt.RecFilt.PrevEndDate_DaysFromToday <> 0 then
        Include(cfg.ParmFilt.RecFilt.Options, FiltPrevEndDate_DaysFromToday);

      cfg.ParmFilt.RecFilt.PrevEndDate_DaysTillToday := FieldByName(CreateFld(tbInfo.pfx, fli_PrevEndDateToday_To)).AsInteger;
      if cfg.ParmFilt.RecFilt.PrevEndDate_DaysTillToday <> 0 then
        Include(cfg.ParmFilt.RecFilt.Options, FiltPrevEndDate_DaysFromToday);

      cfg.ParmFilt.RecFilt.LowStartDate_From := FieldByName(CreateFld(tbInfo.pfx, fli_LowStartDate_From)).AsDateTime;
      if cfg.ParmFilt.RecFilt.LowStartDate_From <> 0 then
        Include(cfg.ParmFilt.RecFilt.Options, FiltLowStartDate);

      cfg.ParmFilt.RecFilt.LowStartDate_To := FieldByName(CreateFld(tbInfo.pfx, fli_LowStartDate_To)).AsDateTime;
      if cfg.ParmFilt.RecFilt.LowStartDate_To <> 0 then
        Include(cfg.ParmFilt.RecFilt.Options, FiltLowStartDate);

//// Sched start date
      cfg.ParmFilt.RecFilt.SchedStartDate_From := FieldByName(CreateFld(tbInfo.pfx, fli_SchedStartDate_From)).AsDateTime;
      if cfg.ParmFilt.RecFilt.SchedStartDate_From <> 0 then
        Include(cfg.ParmFilt.RecFilt.Options, FiltSchedStartDate);
      cfg.ParmFilt.RecFilt.SchedStartDate_To := FieldByName(CreateFld(tbInfo.pfx, fli_SchedStartDate_To)).AsDateTime;
      if cfg.ParmFilt.RecFilt.SchedStartDate_To <> 0 then
        Include(cfg.ParmFilt.RecFilt.Options, FiltSchedStartDate);

      cfg.ParmFilt.RecFilt.SchedStartDate_DaysFromToday := FieldByName(CreateFld(tbInfo.pfx, fli_DaysFromToday_From)).AsInteger;
      if cfg.ParmFilt.RecFilt.SchedStartDate_DaysFromToday <> 0 then
        Include(cfg.ParmFilt.RecFilt.Options, FiltSchedStartDate_Days);

      cfg.ParmFilt.RecFilt.SchedStartDate_DaysTillToday := FieldByName(CreateFld(tbInfo.pfx, fli_DaysFromToday_To)).AsInteger;
      if cfg.ParmFilt.RecFilt.SchedStartDate_DaysTillToday <> 0 then
        Include(cfg.ParmFilt.RecFilt.Options, FiltSchedStartDate_Days);

      cfg.ParmFilt.RecFilt.SchedStartDate_DaysTillToday_time := FieldByName(CreateFld(tbInfo.pfx, fli_DaysFromToday_ToTime)).AsInteger;

      if cfg.ParmFilt.RecFilt.SchedStartDate_DaysTillToday <> 0 then
      begin
        Include(cfg.ParmFilt.RecFilt.Options, FiltSchedStartDate_Days);
        if FieldByName(CreateFld(tbInfo.pfx, fli_DaysFromToday_ToTime)).IsNull then
          cfg.ParmFilt.RecFilt.SchedStartDate_DaysTillToday_time := 1439;
      end;

//// Sched start date

      cfg.ParmFilt.RecFilt.ScheduleJobsCrosses_From := FieldByName(CreateFld(tbInfo.pfx, fli_ScheduledJobsCrossesDateTime_From)).AsDateTime;
      if cfg.ParmFilt.RecFilt.ScheduleJobsCrosses_From <> 0 then
        Include(cfg.ParmFilt.RecFilt.Options, FiltScheduledJobsCrossesDateTime);

      cfg.ParmFilt.RecFilt.ScheduleJobsCrosses_To := FieldByName(CreateFld(tbInfo.pfx, fli_ScheduledJobsCrossesDateTime_To)).AsDateTime;
      if cfg.ParmFilt.RecFilt.ScheduleJobsCrosses_To <> 0 then
        Include(cfg.ParmFilt.RecFilt.Options, FiltScheduledJobsCrossesDateTime);

      cfg.ParmFilt.RecFilt.LatestEndingDate_From := FieldByName(CreateFld(tbInfo.pfx, fli_LatestEndingDate_From)).AsDateTime;
      if cfg.ParmFilt.RecFilt.LatestEndingDate_From <> 0 then
        Include(cfg.ParmFilt.RecFilt.Options, FiltLatestEndingDate);

      cfg.ParmFilt.RecFilt.LatestEndingDate_To := FieldByName(CreateFld(tbInfo.pfx, fli_LatestEndingDate_To)).AsDateTime;
      if cfg.ParmFilt.RecFilt.LatestEndingDate_To <> 0 then
        Include(cfg.ParmFilt.RecFilt.Options, FiltLatestEndingDate);

      cfg.ParmFilt.RecFilt.ProdReq := Trim(FieldByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString);
      if (cfg.ParmFilt.RecFilt.ProdReq <> '') then
        Include(cfg.ParmFilt.RecFilt.Options, FiltProdReq);

      cfg.ParmFilt.RecFilt.ProdReqTo := Trim(FieldByName(CreateFld(tbInfo.pfx, fli_preqNo_To)).AsString);
      if (cfg.ParmFilt.RecFilt.ProdReqTo <> '') then
        Include(cfg.ParmFilt.RecFilt.Options, FiltProdReqTo);

      case FieldByName(CreateFld(tbInfo.pfx, fli_Bin_ReadOnly)).AsInteger of
       0 : cfg.ParmFilt.RecFilt.ReadOnly := CSB_Normal;
       1 : cfg.ParmFilt.RecFilt.ReadOnly := CSB_ReadOnly;
       2 : cfg.ParmFilt.RecFilt.ReadOnly := CSB_NotVisible;
      end;

      if (cfg.ParmFilt.RecFilt.ReadOnly = CSB_ReadOnly) then
        Include(cfg.ParmFilt.RecFilt.Options, Filt_ReadOnly);

      cfg.ParmFilt.RecFilt.wkCtrCode := Trim(FieldByName(CreateFld(tbInfo.pfx, fli_wkCtrCode)).AsString);
      if (cfg.ParmFilt.RecFilt.wkCtrCode <> '') then
        Include(cfg.ParmFilt.RecFilt.Options, FiltWkcr);

      cfg.ParmFilt.RecFilt.wkcProc := Trim(FieldByName(CreateFld(tbInfo.pfx, fli_wkcProc)).AsString);
      if (cfg.ParmFilt.RecFilt.wkcProc <> '') then
        Include(cfg.ParmFilt.RecFilt.Options, FlitProcces);

      cfg.ParmFilt.RecFilt.wkCtrCodeTo := Trim(FieldByName(CreateFld(tbInfo.pfx, fli_wkCtrCode_To)).AsString);
      if (cfg.ParmFilt.RecFilt.wkCtrCodeTo <> '') then
        Include(cfg.ParmFilt.RecFilt.Options, FiltWkcrTo);

      cfg.ParmFilt.RecFilt.wkcProcTo := Trim(FieldByName(CreateFld(tbInfo.pfx, fli_wkcProc_To)).AsString);
      if (cfg.ParmFilt.RecFilt.wkcProcTo <> '') then
        Include(cfg.ParmFilt.RecFilt.Options, FlitProccesTo);

      cfg.ParmFilt.RecFilt.StepId := -1;
      if not FieldByName(CreateFld(tbInfo.pfx, fli_pstepId)).IsNull and (FieldByName(CreateFld(tbInfo.pfx, fli_pstepId)).AsInteger <> -1) then
      begin
        cfg.ParmFilt.RecFilt.StepId := FieldByName(CreateFld(tbInfo.pfx, fli_pstepId)).AsInteger;
        Include(cfg.ParmFilt.RecFilt.Options, FiltStepId);
      end;

      cfg.ParmFilt.RecFilt.StepIdTo := -1;
      if not FieldByName(CreateFld(tbInfo.pfx, fli_pstepId_To)).IsNull and (FieldByName(CreateFld(tbInfo.pfx, fli_pstepId_To)).AsInteger <> -1) then
      begin
        cfg.ParmFilt.RecFilt.StepIdTo := FieldByName(CreateFld(tbInfo.pfx, fli_pstepId_To)).AsInteger;
        Include(cfg.ParmFilt.RecFilt.Options, FiltStepIdTo);
      end;

      cfg.ParmFilt.RecFilt.SubStepId := -1;
      if not FieldByName(CreateFld(tbInfo.pfx, fli_psubstId)).IsNull and (FieldByName(CreateFld(tbInfo.pfx, fli_psubstId)).AsInteger <> -1) then
      begin
        cfg.ParmFilt.RecFilt.SubStepId := FieldByName(CreateFld(tbInfo.pfx, fli_psubstId)).AsInteger;
        Include(cfg.ParmFilt.RecFilt.Options, FiltSubStepId);
      end;

      cfg.ParmFilt.RecFilt.SubStepIdTo := -1;
      if not FieldByName(CreateFld(tbInfo.pfx, fli_psubstId_To)).IsNull and (FieldByName(CreateFld(tbInfo.pfx, fli_psubstId_To)).AsInteger <> -1) then
      begin
        cfg.ParmFilt.RecFilt.SubStepIdTo := FieldByName(CreateFld(tbInfo.pfx, fli_psubstId_To)).AsInteger;
        Include(cfg.ParmFilt.RecFilt.Options, FiltSubStepIdTo);
      end;

      cfg.ParmFilt.RecFilt.GroupNum := 1234;
      if not FieldByName(CreateFld(tbInfo.pfx, fli_stGroupFrom)).IsNull and (FieldByName(CreateFld(tbInfo.pfx, fli_stGroupFrom)).AsInteger <> 1234) then
      begin
        cfg.ParmFilt.RecFilt.GroupNum := FieldByName(CreateFld(tbInfo.pfx, fli_stGroupFrom)).AsInteger;
        Include(cfg.ParmFilt.RecFilt.Options, FiltGroupNum);
      end;

      cfg.ParmFilt.RecFilt.GroupNumTo := 1234;
      if not FieldByName(CreateFld(tbInfo.pfx, fli_stGroupTo)).IsNull and (FieldByName(CreateFld(tbInfo.pfx, fli_stGroupTo)).AsInteger <> 1234) then
      begin
        cfg.ParmFilt.RecFilt.GroupNumTo := FieldByName(CreateFld(tbInfo.pfx, fli_stGroupTo)).AsInteger;
        Include(cfg.ParmFilt.RecFilt.Options, FiltGroupNumTo);
      end;

      if (FieldByName(CreateFld(tbInfo.pfx, fli_ShowAlternative)).AsInteger = 1) then
        Include(cfg.ParmFilt.RecFilt.Options, FiltWkcrAlterntiv)
      else
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltWkcrAlterntiv);

      if (FieldByName(CreateFld(tbInfo.pfx, fli_Wkcr_FromPlan)).AsInteger = 1) then
        Include(cfg.ParmFilt.RecFilt.Options, FiltWkcr_Active)
      else
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltWkcr_Active);

      str := Trim(FieldByName(CreateFld(tbInfo.pfx, fli_StepType)).AsString);

      if      str = 'B' then
        cfg.ParmFilt.RecFilt.StepType := CST_batch
      else if str = 'C' then
        cfg.ParmFilt.RecFilt.StepType := CST_Continuous
      else if str = 'P' then
        cfg.ParmFilt.RecFilt.StepType := CST_printing
      else
        cfg.ParmFilt.RecFilt.StepType := CST_undef;

      if cfg.ParmFilt.RecFilt.StepType <> CST_undef then
        Include(cfg.ParmFilt.RecFilt.Options, FiltStepType);

      cfg.ParmFilt.RecFilt.ProductFamily := FieldByName(CreateFld(tbInfo.pfx, fli_ProdFamily)).Asstring;
      if (cfg.ParmFilt.RecFilt.ProductFamily <> '') then
        Include(cfg.ParmFilt.RecFilt.Options, FiltProdFamily);

      cfg.ParmFilt.RecFilt.MaterialFamily := FieldByName(CreateFld(tbInfo.pfx, fli_MaterialFamily)).Asstring;
      if (cfg.ParmFilt.RecFilt.MaterialFamily <> '') then
        Include(cfg.ParmFilt.RecFilt.Options, FiltMaterialFamily);

      if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltSchedJobs)).AsInteger = 1) then
        Include(cfg.ParmFilt.RecFilt.Options, FiltSchedJobs)
      else
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltSchedJobs);

      if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltFltJobsOnGantt)).AsInteger = 1) then
        Include(cfg.ParmFilt.RecFilt.Options, FiltFltJobsOnGantt)
      else
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltFltJobsOnGantt);

      if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltClosedJobs)).AsInteger = 1) then
        Include(cfg.ParmFilt.RecFilt.Options, FiltClosedJobs)
      else
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltClosedJobs);

      if (FieldByName(CreateFld(tbInfo.pfx, fli_Bin_OnlyReadOnly)).AsInteger = 1) then
        Include(cfg.ParmFilt.RecFilt.Options, FiltOnlyReadOnly)
      else
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltOnlyReadOnly);

      if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltOnlySchedJobs)).AsInteger = 1) then
        Include(cfg.ParmFilt.RecFilt.Options, FiltOnlySchedJobs)
      else
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltOnlySchedJobs);

      if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltOnlyClosedJobs)).AsInteger = 1) then
        Include(cfg.ParmFilt.RecFilt.Options, FiltOnlyClosedJobs)
      else
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltOnlyClosedJobs);

      if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltGroups)).AsInteger = 1) then
        Include(cfg.ParmFilt.RecFilt.Options, FiltGroups)
      else
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltGroups);

      if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltOnlyGroups)).AsInteger = 1) then
        Include(cfg.ParmFilt.RecFilt.Options, FiltOnlyGroups)
      else
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltOnlyGroups);

      Exclude(cfg.ParmFilt.RecFilt.Options, FiltTemporary);
      Exclude(cfg.ParmFilt.RecFilt.Options, FiltFix);
        case FieldByName(CreateFld(tbInfo.pfx, fli_FiltTemporary)).AsInteger of
          0 : Include(cfg.ParmFilt.RecFilt.Options, FiltTemporary);
          1 : Include(cfg.ParmFilt.RecFilt.Options, FiltFix)
        end;

      if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltPriority)).AsInteger = 1) then
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltJobPriority)
      else
        Include(cfg.ParmFilt.RecFilt.Options, FiltJobPriority);

      if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltProgress)).AsInteger = 1) or (FieldByName(CreateFld(tbInfo.pfx, fli_FiltProgress)).IsNull) then
        Include(cfg.ParmFilt.RecFilt.Options, FiltProgress)
      else
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltProgress);

      if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltOnlyProgress)).AsInteger = 1) then
        Include(cfg.ParmFilt.RecFilt.Options, FiltOnlyProgress)
      else
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltOnlyProgress);

      if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltAfterDeliveryDay)).AsInteger = 1) then
        Include(cfg.ParmFilt.RecFilt.Options, FiltAfterDeliveryDay)
      else
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltAfterDeliveryDay);

      if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltAfterDeliveryInDays)).AsInteger <> 0) then
      begin
        Include(cfg.ParmFilt.RecFilt.Options, FiltAfterDeliveryInDays);
        cfg.ParmFilt.RecFilt.AfterDeliveryInDays := FieldByName(CreateFld(tbInfo.pfx, fli_FiltAfterDeliveryInDays)).AsInteger;
      end
      else
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltAfterDeliveryInDays);

      if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltBeforeEarliestStart)).AsInteger <> 0) then
        Include(cfg.ParmFilt.RecFilt.Options, FiltBeforeEarliestStart)
      else
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltBeforeEarliestStart);

      if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltBeforeEarliestStartInDays)).AsInteger <> 0) then
      begin
        Include(cfg.ParmFilt.RecFilt.Options, FiltBeforeEarliestStartInDays);
        cfg.ParmFilt.RecFilt.BeforeEarliestStartInDays := FieldByName(CreateFld(tbInfo.pfx, fli_FiltBeforeEarliestStartInDays)).AsInteger;
      end
      else
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltBeforeEarliestStartInDays);

      if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltAfterLatestEnd)).AsInteger = 1) then
        Include(cfg.ParmFilt.RecFilt.Options, FiltAfterLatestEnd)
      else
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltAfterLatestEnd);

      if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltAfterLatestEndInDays)).AsInteger <> 0) then
      begin
        Include(cfg.ParmFilt.RecFilt.Options, FiltAfterLatestEndInDays);
        cfg.ParmFilt.RecFilt.AfterLatestEndInDays := FieldByName(CreateFld(tbInfo.pfx, fli_FiltAfterLatestEndInDays)).AsInteger;
      end
      else
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltBeforeEarliestStartInDays);

      if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltShouldBeScheduled)).AsInteger = 1) then
        Include(cfg.ParmFilt.RecFilt.Options, FiltShouldBeScheduled)
      else
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltShouldBeScheduled);

      if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltShouldBeScheduledIndays)).AsInteger <> 0) then
      begin
        Include(cfg.ParmFilt.RecFilt.Options, FiltShouldBeScheduledIndays);
        cfg.ParmFilt.RecFilt.ShouldBeScheduledIndays := FieldByName(CreateFld(tbInfo.pfx, fli_FiltShouldBeScheduledIndays)).AsInteger;
      end
      else
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltShouldBeScheduledIndays);

      if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltMissingmaterials)).AsInteger = 1) then
        Include(cfg.ParmFilt.RecFilt.Options, FiltMissingmaterials)
      else
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltMissingmaterials);

      if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltMissingAddRes)).AsInteger = 1) then
        Include(cfg.ParmFilt.RecFilt.Options, FiltMissingAddRes)
      else
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltMissingAddRes);

      if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltOveridePrevious)).AsInteger = 1) then
        Include(cfg.ParmFilt.RecFilt.Options, FiltOveridePrevious)
      else
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltOveridePrevious);

      if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltOverideNext)).AsInteger = 1) then
        Include(cfg.ParmFilt.RecFilt.Options, FiltOverideNext)
      else
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltOverideNext);

      if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltCompWithPrevJob)).AsInteger = 1) then
        Include(cfg.ParmFilt.RecFilt.Options, FiltCompWithPrevJob)
      else
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltCompWithPrevJob);

      if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltCompWithPrevJobInCase)).AsInteger <> 0) then
      begin
        Include(cfg.ParmFilt.RecFilt.Options, FiltCompWithPrevJobInCase);
        cfg.ParmFilt.RecFilt.CompWithPrevJobInCase := FieldByName(CreateFld(tbInfo.pfx, fli_FiltCompWithPrevJobInCase)).AsInteger;
      end
      else
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltCompWithPrevJobInCase);

      if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltCompWithRes)).AsInteger = 1) then
        Include(cfg.ParmFilt.RecFilt.Options, FiltCompWithRes)
      else
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltCompWithRes);

      if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltJobMsg)).AsString = '1') then
        Include(cfg.ParmFilt.RecFilt.Options, FiltJobMsg)
      else
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltJobMsg);

      if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltImbalancedSteps)).AsString = '1') then
        Include(cfg.ParmFilt.RecFilt.Options, FiltImbalancedSteps)
      else
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltImbalancedSteps);

      if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltConfLevNewLog)).AsString = '1') then
        Include(cfg.ParmFilt.RecFilt.Options, FiltConfLevNewLog)
      else
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltConfLevNewLog);

      if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltConfLevels_final)).AsString = '1') then
        Include(cfg.ParmFilt.RecFilt.Options, FiltConfLevelsfinal)
      else
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltConfLevelsfinal);
      if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltConfLevels_Ini)).AsString = '1') then
        Include(cfg.ParmFilt.RecFilt.Options, FiltConfLevelsIni)
      else
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltConfLevelsIni);
      if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltConfLevel1)).AsString = '1') then
        Include(cfg.ParmFilt.RecFilt.Options, FiltConfLevels1)
      else
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltConfLevels1);
      if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltConfLevel2)).AsString = '1') then
        Include(cfg.ParmFilt.RecFilt.Options, FiltConfLevels2)
      else
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltConfLevels2);
      if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltConfLevel3)).AsString = '1') then
        Include(cfg.ParmFilt.RecFilt.Options, FiltConfLevels3)
      else
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltConfLevels3);
      if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltConfLevel4)).AsString = '1') then
        Include(cfg.ParmFilt.RecFilt.Options, FiltConfLevels4)
      else
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltConfLevels4);
      if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltConfLevel5)).AsString = '1') then
        Include(cfg.ParmFilt.RecFilt.Options, FiltConfLevels5)
      else
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltConfLevels5);

      if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltCustomerDateConfirmed)).AsString <> '1') and
         (FieldByName(CreateFld(tbInfo.pfx, fli_FiltCustomerDateCalculated)).AsString <> '1') and
         (FieldByName(CreateFld(tbInfo.pfx, fli_FiltCustomerDateRequested)).AsString <> '1') then
      begin
        Include(cfg.ParmFilt.RecFilt.Options, FiltCustomerDateConfirmed);
        Include(cfg.ParmFilt.RecFilt.Options, FiltCustomerDateCulculated);
        Include(cfg.ParmFilt.RecFilt.Options, FiltCustomerDateRequested)
      end
      else
      begin
        if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltCustomerDateConfirmed)).AsString = '1') then
          Include(cfg.ParmFilt.RecFilt.Options, FiltCustomerDateConfirmed)
        else
          Exclude(cfg.ParmFilt.RecFilt.Options, FiltCustomerDateConfirmed);

        if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltCustomerDateCalculated)).AsString = '1') then
          Include(cfg.ParmFilt.RecFilt.Options, FiltCustomerDateCulculated)
        else
          Exclude(cfg.ParmFilt.RecFilt.Options, FiltCustomerDateCulculated);

        if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltCustomerDateRequested)).AsString = '1') then
          Include(cfg.ParmFilt.RecFilt.Options, FiltCustomerDateRequested)
        else
          Exclude(cfg.ParmFilt.RecFilt.Options, FiltCustomerDateRequested);
      end;

      if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltCompWithResInCase)).AsInteger <> 0) then
      begin
        Include(cfg.ParmFilt.RecFilt.Options, FiltCompWithResInCase);
        cfg.ParmFilt.RecFilt.CompWithResInCase := FieldByName(CreateFld(tbInfo.pfx, fli_FiltCompWithResInCase)).AsInteger;
      end
      else
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltCompWithResInCase);

      cfg.ParmFilt.P_GroupedByCode := Trim(FieldByName(CreateFld(tbInfo.pfx, fli_GroupedByCode)).AsString);
      cfg.ParmFilt.P_OverriddenTab := false;
      if Trim(FieldByName(CreateFld(tbInfo.pfx, fli_OverriddenTab)).AsString) = '1' then
         cfg.ParmFilt.P_OverriddenTab := true;

      cfg.ParmFilt.RecFilt.ShowDependingOnNextHandledStep := CsAlways;
      if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltDependingOnNextHandledStep)).AsInteger = 1) then
        cfg.ParmFilt.RecFilt.ShowDependingOnNextHandledStep := CsWhenNotScheduled
      else if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltDependingOnNextHandledStep)).AsInteger = 2) then
        cfg.ParmFilt.RecFilt.ShowDependingOnNextHandledStep := CsWhenScheduled;

      cfg.ParmFilt.RecFilt.ShowDependingOnPrevHandledStep := CsAlways;
      if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltDependingOnPrevHandledStep)).AsInteger = 1) then
        cfg.ParmFilt.RecFilt.ShowDependingOnPrevHandledStep := CsWhenNotScheduled
      else if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltDependingOnPrevHandledStep)).AsInteger = 2) then
        cfg.ParmFilt.RecFilt.ShowDependingOnPrevHandledStep := CsWhenScheduled;

      cfg.ParmFilt.RecFilt.ShowDependingOnNextHandledLinkedRequest := CsAlways;
      if (FieldByName(CreateFld(tbInfo.pfx, fli_filtDependingOnNextHandledLinkedRequest)).AsInteger = 1) then
        cfg.ParmFilt.RecFilt.ShowDependingOnNextHandledLinkedRequest := CsWhenNotScheduled
      else if (FieldByName(CreateFld(tbInfo.pfx, fli_filtDependingOnNextHandledLinkedRequest)).AsInteger = 2) then
        cfg.ParmFilt.RecFilt.ShowDependingOnNextHandledLinkedRequest := CsWhenScheduled;

      cfg.ParmFilt.RecFilt.ShowDependingOnPrevHandledLinkedRequest := CsAlways;
      if (FieldByName(CreateFld(tbInfo.pfx, fli_filtDependingOnPrevHandledLinkedRequest)).AsInteger = 1) then
        cfg.ParmFilt.RecFilt.ShowDependingOnPrevHandledLinkedRequest := CsWhenNotScheduled
      else if (FieldByName(CreateFld(tbInfo.pfx, fli_filtDependingOnPrevHandledLinkedRequest)).AsInteger = 2) then
        cfg.ParmFilt.RecFilt.ShowDependingOnPrevHandledLinkedRequest := CsWhenScheduled;

      cfg.ParmFilt.RecFilt.ShowFirstGrplineInBin := false;
      if Trim(FieldByName(CreateFld(tbInfo.pfx, fli_FiltShowFirstGrplineInBin)).AsString) = '1' then
        cfg.ParmFilt.RecFilt.ShowFirstGrplineInBin := true;

      cfg.ParmFilt.RecFilt.AutoGroupSingleJob := false;
      if Trim(FieldByName(CreateFld(tbInfo.pfx, fli_FiltAutoGroupSingleJob)).AsString) = '1' then
        cfg.ParmFilt.RecFilt.AutoGroupSingleJob := true;

      cfg.ParmFilt.RecFilt.ShowBatchGroupLinesInBin := false;
      if Trim(FieldByName(CreateFld(tbInfo.pfx, fli_FiltShowBatchGroupLinesInBin)).AsString) = '1' then
        cfg.ParmFilt.RecFilt.ShowBatchGroupLinesInBin := true;

      cfg.ParmFilt.RecFilt.ShowContinueGroupLinesInBin := CsSCG_No;
      if Trim(FieldByName(CreateFld(tbInfo.pfx, fli_FiltShowContinueGroupLinesInBin)).AsString) = '1' then
        cfg.ParmFilt.RecFilt.ShowContinueGroupLinesInBin := CsSCG_Yes
      else if Trim(FieldByName(CreateFld(tbInfo.pfx, fli_FiltShowContinueGroupLinesInBin)).AsString) = '2' then
        cfg.ParmFilt.RecFilt.ShowContinueGroupLinesInBin := CsSCG_YesSameSequence;

      for i := Low(cfg.ParmFilt.RecFilt.PropCod) to High(cfg.ParmFilt.RecFilt.PropCod) do
      begin
        cfg.ParmFilt.RecFilt.PropCod[i] := Trim(FieldByName(CreateFld(tbInfo.pfx, fli_FiltPropCode)+ IntToStr(i)).AsString);
        cfg.ParmFilt.RecFilt.PropRes[i] := Trim(FieldByName(CreateFld(tbInfo.pfx, fli_FiltPropRes)+ IntToStr(i)).AsString);
        cfg.ParmFilt.RecFilt.PropValfrom[i] := Trim(FieldByName(CreateFld(tbInfo.pfx, fli_filtPropValueFrom)+ IntToStr(i)).AsString);
        cfg.ParmFilt.RecFilt.PropValTo[i] := Trim(FieldByName(CreateFld(tbInfo.pfx, fli_filtPropValueTo)+ IntToStr(i)).AsString);
        if (cfg.ParmFilt.RecFilt.PropCod[i] <> '') then
        begin
          cfg.ParmFilt.RecFilt.IsPropEnter := true;
          Include(cfg.ParmFilt.RecFilt.Options, FiltProp);
          cfg.ParmFilt.SetPropValue(cfg.ParmFilt.RecFilt.PropCod[i],
                                    cfg.ParmFilt.RecFilt.PropRes[i],
                                    cfg.ParmFilt.RecFilt.PropValfrom[i],
                                    cfg.ParmFilt.RecFilt.PropValTo[i]);
        end;
      end;

      //Earliest fixed date
      cfg.ParmFilt.RecFilt.FixedEarliestDate_To := 0;
      cfg.ParmFilt.RecFilt.FixedEarliestDate_From := FieldByName(CreateFld(tbInfo.pfx, fli_filtFixedEarlistDateFrom)).AsDateTime;
      if cfg.ParmFilt.RecFilt.FixedEarliestDate_From <> 0 then
        Include(cfg.ParmFilt.RecFilt.Options, FiltBeforeEarliestStartFixed);
      cfg.ParmFilt.RecFilt.FixedEarliestDate_To := FieldByName(CreateFld(tbInfo.pfx, fli_filtFixedEarlistDateTo)).AsDateTime;

      cfg.ParmFilt.RecFilt.EarliestDays_To := 0;
      if (FieldByName(CreateFld(tbInfo.pfx, fli_filtFixedEarlistDateInDaysFrom)).AsInteger <> 0) then
      begin
        Include(cfg.ParmFilt.RecFilt.Options, FiltBeforeEarliestStartInDaysFixed);
        cfg.ParmFilt.RecFilt.EarliestDays_From := FieldByName(CreateFld(tbInfo.pfx, fli_filtFixedEarlistDateInDaysFrom)).AsInteger;
      end
      else
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltBeforeEarliestStartInDaysFixed);
      cfg.ParmFilt.RecFilt.EarliestDays_To := fieldByName(CreateFld(tbInfo.pfx, fli_filtFixedEarlistDateInDaysTo)).AsInteger;

      if FieldByName(CreateFld(tbInfo.pfx, fli_filtIgnoredProgress)).asInteger = 1 then
      begin
        cfg.ParmFilt.RecFilt.IgnoredProg := True;
        Include(cfg.ParmFilt.RecFilt.Options, FiltIgnoredProg);
      end;

      //Grouping
      if FieldByName(CreateFld(tbInfo.pfx, fli_wkCtrGroup)).asString <> '' then
      begin
        cfg.ParmFilt.RecFilt.wkCtrGroup := fieldByName(CreateFld(tbInfo.pfx, fli_wkCtrGroup)).asString;
        Include(cfg.ParmFilt.RecFilt.Options, FiltWkcrGrp);
      end else
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltWkcrGrp);

      if FieldByName(CreateFld(tbInfo.pfx, fli_PlantCode)).asString <> '' then
      begin
        cfg.ParmFilt.RecFilt.wkCtrPlant := fieldByName(CreateFld(tbInfo.pfx, fli_PlantCode)).asString;
        Include(cfg.ParmFilt.RecFilt.Options, FiltWkcrPlant);
      end else
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltWkcrPlant);

      if FieldByName(CreateFld(tbInfo.pfx, fli_Division)).asString <> '' then
      begin
        cfg.ParmFilt.RecFilt.wkCtrDivision := fieldByName(CreateFld(tbInfo.pfx, fli_Division)).asString;
        Include(cfg.ParmFilt.RecFilt.Options, FiltWkcrDivision);
      end else
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltWkcrDivision);

      tbInfo := @tblInfo[tbl_cfg_binTab_col];
     // SetFldPfx(tbInfo.pfx); //

      I := 0;
      while (TabCode = qryColum.FieldByName(CreateFld(tbInfo.pfx, fli_TabsCode)).AsInteger) and (not qryColum.EOF) do
      begin
      //  setLength(cfg.BinArray, Length(BinColDefault));

        FoundColumsInDb := true;
        cfg.BinArray[I].Field := BinColDefault[qryColum.FieldByName(CreateFld(tbInfo.pfx, fli_BinColField)).AsInteger].Field;
        cfg.BinArray[I].Title   := qryColum.FieldByName(CreateFld(tbInfo.pfx, fli_BinColTitle)).AsString;
        cfg.BinArray[I].Pos     := qryColum.FieldByName(CreateFld(tbInfo.pfx, fli_BinColPos)).AsInteger;
        cfg.BinArray[I].Width   := qryColum.FieldByName(CreateFld(tbInfo.pfx, fli_BinColWidth)).AsInteger;
        if qryColum.FieldByName(CreateFld(tbInfo.pfx, fli_BinColVisibl)).AsInteger = 1 then
          cfg.BinArray[I].Visible := true
        else
          cfg.BinArray[I].Visible := false;
        cfg.BinArray[I].Order   := qryColum.FieldByName(CreateFld(tbInfo.pfx, fli_BinColOrder)).AsInteger;

        if qryColum.FieldByName(CreateFld(tbInfo.pfx, fli_BinColDescending)).AsString = '1' then
          cfg.BinArray[I].DescendingSort := true
        else
          cfg.BinArray[I].DescendingSort := false;

        cfg.BinArray[I].PropCode := qryColum.FieldByName(CreateFld(tbInfo.pfx, fli_FiltPropCode)).AsString;

        cfg.BinArray[I].NumColSorted   := qryColum.FieldByName(CreateFld(tbInfo.pfx, fli_BinColNumColSorted)).AsInteger;
        Inc(I);
        qryColum.Next;
      end;

      if FoundColumsInDb then
      begin
        FixOldArrayBinCol(cfg.BinArray, I);
        inherited AddNewTab(cfg);
        m_tabList.Sort(SortOnCode);
      end;
      Application.ProcessMessages;
      Next
    end;

  qryColum.sql.clear;
  qryFiltr.sql.clear;

  qryColum.Close;
  qryFiltr.Close;

  //qryFiltr.Free;

                 // Result := true;
                 // exit;
  // Second part will take the material tabs :


  tbInfo := @tblInfo[tbl_cfg_binMaterialFilter];
//  qryFiltr := CreateQuery(Cfg_DB);

  qryFiltr.SQL.Clear;
  qryFiltr.SQL.Add('Select * from ' + tbInfo.GetTableName + ' Where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + ' = ''' +  IniAppGlobals.WkstCode + '''');
  qryFiltr.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qryFiltr.SQL.Add(' order by ' + CreateFld(tbInfo.pfx, fli_TabsCode));
  qryFiltr.Open;
  qryFiltr.First;

  tbInfo := @tblInfo[tbl_cfg_binTab_col];
 // qryColum := CreateQuery(Cfg_DB);

  qryColum.SQL.Clear;
  qryColum.SQL.Add('Select * from ' + tbInfo.GetTableName + ' Where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + ' = ''' +  IniAppGlobals.WkstCode + '''');
  qryColum.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qryColum.SQL.Add(' And ' + CreateFld(tbInfo.pfx, fli_TabsCode) + ' <> ''' + '-1''');
  qryColum.SQL.Add(' And ' + CreateFld(tbInfo.pfx, fli_TabsCode) + ' <> ''' + '-2''');
  qryColum.SQL.Add(' And ' + CreateFld(tbInfo.pfx, fli_TabsCode) + ' <> ''' + '-3''');
  qryColum.SQL.Add(' And ' + CreateFld(tbInfo.pfx, fli_TabsCode) + ' <> ''' + '-4''');
  qryColum.SQL.Add(' And ' + CreateFld(tbInfo.pfx, fli_TabsCode) + ' <> ''' + '-5''');
  qryColum.SQL.Add(' And ' + CreateFld(tbInfo.pfx, fli_TabsCode) + ' <> ''' + '-6''');
  qryColum.SQL.Add(' And ' + CreateFld(tbInfo.pfx, fli_TabsCode) + ' <> ''' + '-7''');
  qryColum.SQL.Add(' And ' + CreateFld(tbInfo.pfx, fli_TypeOfUse) + ' = ' + QuotedStr('1'));
  qryColum.SQL.Add(' order by ' + CreateFld(tbInfo.pfx, fli_TabsCode));
  qryColum.SQL.Add(' , ' + CreateFld(tbInfo.pfx, fli_BinColField));
  qryColum.Open;
  qryColum.First;

  with qryFiltr do
    while not EOF do
   begin

      FoundColumsInDb := false;
      tbInfo := @tblInfo[tbl_cfg_binMaterialFilter];

      TabCode := FieldByName(CreateFld(tbInfo.pfx, fli_TabsCode)).AsInteger;
      TabName := FieldByName(CreateFld(tbInfo.pfx, fli_TabsDesc)).AsString;
      cfg := TBinTabCfg.CreatBinTab(True);

      cfg.name := TabName;
      cfg.code := TabCode;

     { if FieldByName(CreateFld(tbInfo.pfx, fli_TabVis)).AsInteger = 1 then
        cfg.isView := true
      else
        cfg.isView := false;   }

      cfg.isView := true;
      cfg.ParmFilt := TBinFilterParms.Create;
      cfg.ParmFilt.P_MaterialSchedFilter := true;

      cfg.ParmFilt.RecFilt.Item_Type := Trim(FieldByName(CreateFld(tbInfo.pfx, fli_ItemType)).AsString);
      if (cfg.ParmFilt.RecFilt.Item_Type <> '') then
        Include(cfg.ParmFilt.RecFilt.Options, Filt_Item_Type);

      cfg.ParmFilt.RecFilt.Product_code := Trim(FieldByName(CreateFld(tbInfo.pfx, fli_ProdCode)).AsString);
      if (cfg.ParmFilt.RecFilt.Product_code <> '') then
        Include(cfg.ParmFilt.RecFilt.Options, Filt_Product_code);

      cfg.ParmFilt.RecFilt.NetGroup_Code := Trim(FieldByName(CreateFld(tbInfo.pfx, fli_netGroupCode)).AsString);
      if (cfg.ParmFilt.RecFilt.NetGroup_Code <> '') then
        Include(cfg.ParmFilt.RecFilt.Options, Filt_NetGroup_Code);

      cfg.ParmFilt.RecFilt.MaterialDetailCode := Trim(FieldByName(CreateFld(tbInfo.pfx, fli_Detail_Code)).AsString);
      if (cfg.ParmFilt.RecFilt.MaterialDetailCode <> '') then
        Include(cfg.ParmFilt.RecFilt.Options, Filt_MaterialDetailCode);

      cfg.ParmFilt.RecFilt.MaterialCodeSubDetail := Trim(FieldByName(CreateFld(tbInfo.pfx, fli_Sub_Detail)).AsString);
      if (cfg.ParmFilt.RecFilt.MaterialCodeSubDetail <> '') then
        Include(cfg.ParmFilt.RecFilt.Options, Filt_MaterialCode_SUB_DETAILS);

      //2nd level
      cfg.ParmFilt.RecFilt.Item_Type2 := Trim(FieldByName(CreateFld(tbInfo.pfx, fli_ItemType2)).AsString);
      if (cfg.ParmFilt.RecFilt.Item_Type2 <> '') then
        Include(cfg.ParmFilt.RecFilt.Options, Filt_Item_Type2);

      cfg.ParmFilt.RecFilt.Product_code2 := Trim(FieldByName(CreateFld(tbInfo.pfx, fli_ProdCode2)).AsString);
      if (cfg.ParmFilt.RecFilt.Product_code2 <> '') then
        Include(cfg.ParmFilt.RecFilt.Options, Filt_Product_code2);

      if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltSchedJobs)).AsInteger = 0) then
      begin
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltSchedJobs);
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltOnlySchedJobs);
      end else if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltSchedJobs)).AsInteger = 1) then
      begin
        Include(cfg.ParmFilt.RecFilt.Options, FiltSchedJobs);
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltOnlySchedJobs);
      end else if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltSchedJobs)).AsInteger = 2) then
      begin
        Exclude(cfg.ParmFilt.RecFilt.Options, FiltSchedJobs);
        Include(cfg.ParmFilt.RecFilt.Options, FiltOnlySchedJobs);
      end;


      //WARP LEVEL
      cfg.ParmFilt.RecFilt.WarpLevel := FieldByName(CreateFld(tbInfo.pfx, fli_FiltWarplvl)).AsInteger;
      if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltWarplvl)).AsInteger = 0) then
      begin
        Include(cfg.ParmFilt.RecFilt.Options, Filt_WarpBasicLvl);
        Exclude(cfg.ParmFilt.RecFilt.Options, Filt_WarpSecondLvl);
      end else if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltWarplvl)).AsInteger = 1) then
      begin
        Exclude(cfg.ParmFilt.RecFilt.Options, Filt_WarpBasicLvl);
        Include(cfg.ParmFilt.RecFilt.Options, Filt_WarpSecondLvl);
      end else if (FieldByName(CreateFld(tbInfo.pfx, fli_FiltWarplvl)).AsInteger = 2) then
      begin
        Include(cfg.ParmFilt.RecFilt.Options, Filt_WarpBasicLvl);
        Include(cfg.ParmFilt.RecFilt.Options, Filt_WarpSecondLvl);
      end;


      for i := Low(cfg.ParmFilt.RecFilt.PropCod) to High(cfg.ParmFilt.RecFilt.PropCod) do
      begin
        cfg.ParmFilt.RecFilt.PropCod[i] := Trim(FieldByName(CreateFld(tbInfo.pfx, fli_FiltPropCode)+ IntToStr(i)).AsString);
      //  cfg.ParmFilt.RecFilt.PropRes[i] := Trim(FieldByName(CreateFld(tbInfo.pfx, fli_FiltPropRes)+ IntToStr(i)).AsString);
        cfg.ParmFilt.RecFilt.PropValfrom[i] := Trim(FieldByName(CreateFld(tbInfo.pfx, fli_filtPropValueFrom)+ IntToStr(i)).AsString);
        cfg.ParmFilt.RecFilt.PropValTo[i] := Trim(FieldByName(CreateFld(tbInfo.pfx, fli_filtPropValueTo)+ IntToStr(i)).AsString);
        if (cfg.ParmFilt.RecFilt.PropCod[i] <> '') then
        begin
          cfg.ParmFilt.RecFilt.IsPropEnter := true;
          Include(cfg.ParmFilt.RecFilt.Options, FiltProp);
          cfg.ParmFilt.SetPropValue(cfg.ParmFilt.RecFilt.PropCod[i],
                                   '',// cfg.ParmFilt.RecFilt.PropRes[i],
                                    cfg.ParmFilt.RecFilt.PropValfrom[i],
                                    cfg.ParmFilt.RecFilt.PropValTo[i]);
        end;
      end;



      tbInfo := @tblInfo[tbl_cfg_binTab_col];
      I := 0;
      while (TabCode = qryColum.FieldByName(CreateFld(tbInfo.pfx, fli_TabsCode)).AsInteger) and (not qryColum.EOF) do
      begin
        //setLength(cfg.BinArray, Length(BinMatColDefault));

        FoundColumsInDb := true;
        cfg.BinArray[I].Field := BinMatColDefault[qryColum.FieldByName(CreateFld(tbInfo.pfx, fli_BinColField)).AsInteger].Field;
        cfg.BinArray[I].Title   := qryColum.FieldByName(CreateFld(tbInfo.pfx, fli_BinColTitle)).AsString;
        cfg.BinArray[I].Pos     := qryColum.FieldByName(CreateFld(tbInfo.pfx, fli_BinColPos)).AsInteger;
        cfg.BinArray[I].Width   := qryColum.FieldByName(CreateFld(tbInfo.pfx, fli_BinColWidth)).AsInteger;
        if qryColum.FieldByName(CreateFld(tbInfo.pfx, fli_BinColVisibl)).AsInteger = 1 then
          cfg.BinArray[I].Visible := true
        else
          cfg.BinArray[I].Visible := false;
        cfg.BinArray[I].Order   := qryColum.FieldByName(CreateFld(tbInfo.pfx, fli_BinColOrder)).AsInteger;

        if qryColum.FieldByName(CreateFld(tbInfo.pfx, fli_BinColDescending)).AsString = '1' then
          cfg.BinArray[I].DescendingSort := true
        else
          cfg.BinArray[I].DescendingSort := false;

        cfg.BinArray[I].PropCode := qryColum.FieldByName(CreateFld(tbInfo.pfx, fli_FiltPropCode)).AsString;

        cfg.BinArray[I].NumColSorted   := qryColum.FieldByName(CreateFld(tbInfo.pfx, fli_BinColNumColSorted)).AsInteger;
        Inc(I);
        qryColum.Next;
      end;

      if FoundColumsInDb then
      begin
        FixOldArrayBinColMat(cfg.BinArray, I);
        inherited AddNewTab(cfg);
        m_tabList.Sort(SortOnCode);
      end;

      next;
     //end;
   end;

  qryColum.Close;
  qryFiltr.Close;

  qryColum.free;
  qryFiltr.free;

  Result := true
end;

//----------------------------------------------------------------------------//

procedure TBinTabsCfg.StoreToDatabase;

//var
//  I, J : Integer;
//  cfg: TBinTabCfg;
//  qryColumns : TMqmQuery;
//  trsColumns : TMqmTransaction;
//  qryFiltr : TMqmQuery;
//  trsFiltr : TMqmTransaction;
//  tbInfo:  ^TTblInfo;
//  SQLStrings: TStringList;
//  IAsStr: string;
begin
{  exit;
  SQLStrings := TStringList.Create;

  tbInfo := @tblInfo[tbl_cfg_binFilter];
  SetFldPfx(tbInfo.pfx);

  trsFiltr := CreateTransaction(Cfg_DB, false);
  qryFiltr := CreateQuery(trsFiltr, Cfg_DB);
  trsColumns := CreateTransaction(Cfg_DB, false);
  qryColumns := CreateQuery(trsColumns, Cfg_DB);

  try

    trsFiltr.Active := true;

    qryFiltr.SQL.Clear;
    qryFiltr.SQL.Add('delete from ' + tbInfo.GetTableName + ' Where ' + CreatePfxFld(fli_wkstCode) + ' = ''' +  IniAppGlobals.WkstCode + '''');
    qryFiltr.ExecSQL;
  //  TrsFiltr.Commit;
    qryFiltr.Close;

    trsFiltr.Active := true;
    SQLStrings.Clear;

    SQLStrings.Add('insert into ' + tbInfo.GetTableName + '(');
    SQLStrings.Add(CreatePfxFld(fli_wkstCode) + ',');
    SQLStrings.Add(CreatePfxFld(fli_TabsCode) + ',');
    SQLStrings.Add(CreatePfxFld(fli_TabsDesc) + ',');
    SQLStrings.Add(CreatePfxFld(fli_TabVis) + ',');
    SQLStrings.Add(CreatePfxFld(fli_MinQty) + ',');
    SQLStrings.Add(CreatePfxFld(fli_MaxQty) + ',');
    SQLStrings.Add(CreatePfxFld(fli_ProdLine) + ',');
    SQLStrings.Add(CreatePfxFld(fli_ProdType) + ',');
    SQLStrings.Add(CreatePfxFld(fli_ProdLowDate_From) + ',');
    SQLStrings.Add(CreatePfxFld(fli_ProdLowDate_To) + ',');
    SQLStrings.Add(CreatePfxFld(fli_DelivDate_From) + ',');
    SQLStrings.Add(CreatePfxFld(fli_DelivDate_To) + ',');
    SQLStrings.Add(CreatePfxFld(fli_PlanStartDate_From) + ',');
    SQLStrings.Add(CreatePfxFld(fli_PlanStartDate_To) + ',');
    SQLStrings.Add(CreatePfxFld(fli_LowStartDate_From) + ',');
    SQLStrings.Add(CreatePfxFld(fli_LowStartDate_To) + ',');
    SQLStrings.Add(CreatePfxFld(fli_preqNo) + ',');
    SQLStrings.Add(CreatePfxFld(fli_Bin_ReadOnly) + ',');
    SQLStrings.Add(CreatePfxFld(fli_wkCtrCode) + ',');
    SQLStrings.Add(CreatePfxFld(fli_wkcProc) + ',');
    SQLStrings.Add(CreatePfxFld(fli_ShowAlternative) + ',');
    SQLStrings.Add(CreatePfxFld(fli_Wkcr_FromPlan) + ',');
    SQLStrings.Add(CreatePfxFld(fli_StepType) + ',');
    SQLStrings.Add(CreatePfxFld(fli_stGroup) + ',');
    SQLStrings.Add(CreatePfxFld(fli_reprocNo) + ',');
    SQLStrings.Add(CreatePfxFld(fli_ProdFamily) + ',');
    SQLStrings.Add(CreatePfxFld(fli_MaterialFamily) + ',');
    SQLStrings.Add(CreatePfxFld(fli_FiltSchedJobs) + ',');
    SQLStrings.Add(CreatePfxFld(fli_FiltFltJobsOnGantt) + ',');
    SQLStrings.Add(CreatePfxFld(fli_FiltClosedJobs) + ',');
    SQLStrings.Add(CreatePfxFld(fli_Bin_OnlyReadOnly) + ',');
    SQLStrings.Add(CreatePfxFld(fli_FiltOnlySchedJobs) + ',');
    SQLStrings.Add(CreatePfxFld(fli_FiltOnlyClosedJobs) + ',');
    SQLStrings.Add(CreatePfxFld(fli_FiltGroups) + ',');
    SQLStrings.Add(CreatePfxFld(fli_FiltOnlyGroups) + ',');
    SQLStrings.Add(CreatePfxFld(fli_FiltPriority) + ',');
    SQLStrings.Add(CreatePfxFld(fli_SchedStartDate_From) + ',');
    SQLStrings.Add(CreatePfxFld(fli_SchedStartDate_To) + ',');
    SQLStrings.Add(CreatePfxFld(fli_LatestEndingDate_From) + ',');
    SQLStrings.Add(CreatePfxFld(fli_LatestEndingDate_To) + ',');
    SQLStrings.Add(CreatePfxFld(fli_FiltTemporary) + ',');
    SQLStrings.Add(CreatePfxFld(fli_FiltProgress) + ',');
    SQLStrings.Add(CreatePfxFld(fli_FiltOnlyProgress) + ',');
    SQLStrings.Add(CreatePfxFld(fli_FiltAfterDeliveryDay) + ',');
    SQLStrings.Add(CreatePfxFld(fli_FiltAfterDeliveryInDays) + ',');
    SQLStrings.Add(CreatePfxFld(fli_FiltBeforeEarliestStart) + ',');
    SQLStrings.Add(CreatePfxFld(fli_FiltBeforeEarliestStartInDays) + ',');
    SQLStrings.Add(CreatePfxFld(fli_FiltAfterLatestEnd) + ',');
    SQLStrings.Add(CreatePfxFld(fli_FiltAfterLatestEndInDays) + ',');
    SQLStrings.Add(CreatePfxFld(fli_FiltShouldBeScheduled) + ',');
    SQLStrings.Add(CreatePfxFld(fli_FiltShouldBeScheduledIndays) + ',');
    SQLStrings.Add(CreatePfxFld(fli_FiltMissingmaterials) + ',');
    SQLStrings.Add(CreatePfxFld(fli_FiltMissingAddRes) + ',');
    SQLStrings.Add(CreatePfxFld(fli_FiltOveridePrevious) + ',');
    SQLStrings.Add(CreatePfxFld(fli_FiltOverideNext) + ',');
    SQLStrings.Add(CreatePfxFld(fli_FiltCompWithPrevJob) + ',');
    SQLStrings.Add(CreatePfxFld(fli_FiltCompWithPrevJobInCase) + ',');
    SQLStrings.Add(CreatePfxFld(fli_FiltCompWithRes) + ',');
    SQLStrings.Add(CreatePfxFld(fli_FiltCompWithResInCase) + ',');
    SQLStrings.Add(CreatePfxFld(fli_FiltResCatCode) + ',');

    for i := 1 to 30 do
    begin
      IAsStr := IntToStr(i);
      SQLStrings.Add(CreatePfxFld(fli_FiltPropCode) + IAsStr + ',');
      SQLStrings.Add(CreatePfxFld(fli_FiltPropRes) + IAsStr + ',');
      SQLStrings.Add(CreatePfxFld(fli_filtPropValueFrom) + IAsStr + ',');
      if i < 30 then
        SQLStrings.Add(CreatePfxFld(fli_filtPropValueTo) + IAsStr + ',')
      else
        SQLStrings.Add(CreatePfxFld(fli_filtPropValueTo) + IAsStr);
    end;

    SQLStrings.Add(') values (');

    SQLStrings.Add(':' + CreatePfxFld(fli_wkstCode) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_TabsCode) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_TabsDesc) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_TabVis) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_MinQty) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_MaxQty) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_ProdLine) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_ProdType) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_ProdLowDate_From) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_ProdLowDate_To) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_DelivDate_From) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_DelivDate_To) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_PlanStartDate_From) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_PlanStartDate_To) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_LowStartDate_From) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_LowStartDate_To) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_preqNo) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_Bin_ReadOnly) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_wkCtrCode) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_wkcProc) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_ShowAlternative) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_Wkcr_FromPlan) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_StepType) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_stGroup) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_reprocNo) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_ProdFamily) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_MaterialFamily) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_FiltSchedJobs) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_FiltFltJobsOnGantt) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_FiltClosedJobs) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_Bin_OnlyReadOnly) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_FiltOnlySchedJobs) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_FiltOnlyClosedJobs) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_FiltGroups) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_FiltOnlyGroups) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_FiltPriority) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_SchedStartDate_From) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_SchedStartDate_To) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_LatestEndingDate_From) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_LatestEndingDate_To) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_FiltTemporary) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_FiltProgress) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_FiltOnlyProgress) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_FiltAfterDeliveryDay) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_FiltAfterDeliveryInDays) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_FiltBeforeEarliestStart) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_FiltBeforeEarliestStartInDays) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_FiltAfterLatestEnd) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_FiltAfterLatestEndInDays) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_FiltShouldBeScheduled) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_FiltShouldBeScheduledIndays) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_FiltMissingmaterials) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_FiltMissingAddRes) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_FiltOveridePrevious) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_FiltOverideNext) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_FiltCompWithPrevJob) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_FiltCompWithPrevJobInCase) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_FiltCompWithRes) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_FiltCompWithResInCase) + ',');
    SQLStrings.Add(':' + CreatePfxFld(fli_FiltResCatCode) + ',');

    for i := 1 to 30 do
    begin
      IAsStr := IntToStr(i);

      SQLStrings.Add(':' + CreatePfxFld(fli_FiltPropCode) + IAsStr + ',');
      SQLStrings.Add(':' + CreatePfxFld(fli_FiltPropRes) + IAsStr + ',');
      SQLStrings.Add(':' + CreatePfxFld(fli_filtPropValueFrom) + IAsStr + ',');
      if i < 30 then
        SQLStrings.Add(':' + CreatePfxFld(fli_filtPropValueTo) + IAsStr + ',')
      else
        SQLStrings.Add(':' + CreatePfxFld(fli_filtPropValueTo) + IAsStr);
    end;
    SQLStrings.Add(')');

    qryFiltr.SQL.Clear;
    qryFiltr.SQL.AddStrings(SQLStrings);
    qryFiltr.Prepare;

    tbInfo := @tblInfo[tbl_cfg_binTab_col];
    SetFldPfx(tbInfo.pfx);

    trsColumns.Active := true;

    qryColumns.SQL.Clear;
    qryColumns.SQL.Add('delete from ' + tbInfo.GetTableName + ' Where ' + CreatePfxFld(fli_wkstCode) + ' = ''' +  IniAppGlobals.WkstCode + '''');
    qryColumns.SQL.Add(' And ' + CreateFld(tbInfo.pfx, fli_TabsCode) + ' <> ''' + '-1''');

    qryColumns.ExecSQL;
  //  TrsColumns.Commit;
    qryColumns.Close;

    trsColumns.Active := true;
    qryColumns.SQL.Clear;
    qryColumns.SQL.Add('insert into ' + tbInfo.GetTableName + '(');
    qryColumns.SQL.Add(CreatePfxFld(fli_wkstCode) + ',');
    qryColumns.SQL.Add(CreatePfxFld(fli_TabsCode) + ',');
    qryColumns.SQL.Add(CreatePfxFld(fli_BinColField) + ',');
    qryColumns.SQL.Add(CreatePfxFld(fli_BinColTitle) + ',');
    qryColumns.SQL.Add(CreatePfxFld(fli_BinColPos) + ',');
    qryColumns.SQL.Add(CreatePfxFld(fli_BinColWidth) + ',');
    qryColumns.SQL.Add(CreatePfxFld(fli_BinColVisibl) + ',');
    qryColumns.SQL.Add(CreatePfxFld(fli_FiltPropCode) + ',');
    qryColumns.SQL.Add(CreatePfxFld(fli_BinColOrder) + ')');

    qryColumns.SQL.Add(' values (');
    qryColumns.SQL.Add(':' + CreatePfxFld(fli_wkstCode) + ',');
    qryColumns.SQL.Add(':' + CreatePfxFld(fli_TabsCode) + ',');
    qryColumns.SQL.Add(':' + CreatePfxFld(fli_BinColField) + ',');
    qryColumns.SQL.Add(':' + CreatePfxFld(fli_BinColTitle) + ',');
    qryColumns.SQL.Add(':' + CreatePfxFld(fli_BinColPos) + ',');
    qryColumns.SQL.Add(':' + CreatePfxFld(fli_BinColWidth) + ',');
    qryColumns.SQL.Add(':' + CreatePfxFld(fli_BinColVisibl) + ',');
    qryColumns.SQL.Add(':' + CreatePfxFld(fli_FiltPropCode) + ',');
    qryColumns.SQL.Add(':' + CreatePfxFld(fli_BinColOrder));
    qryColumns.SQL.Add(')');
    qryColumns.Prepare;

    for i := 0 to GetTabsCount - 1 do
    begin
      cfg := TBinTabCfg(m_tabList[I]);

      tbInfo := @tblInfo[tbl_cfg_binFilter];
      SetFldPfx(tbInfo.pfx);

      qryFiltr.ParamByName(CreatePfxFld(fli_wkstCode)).AsString  := IniAppGlobals.WkstCode; // fli_wkstCode
      qryFiltr.ParamByName(CreatePfxFld(fli_TabsCode)).AsInteger := I;  // fli_TabsCode
      qryFiltr.ParamByName(CreatePfxFld(fli_TabsDesc)).AsString  := cfg.name;  // fli_TabsDesc
      if cfg.isView then
        qryFiltr.ParamByName(CreatePfxFld(fli_TabVis)).AsInteger := 1    // fli_TabVis
      else
        qryFiltr.ParamByName(CreatePfxFld(fli_TabVis)).AsInteger := 0;   // fli_TabVis

      // saveing filter params
      qryFiltr.ParamByName(CreatePfxFld(fli_MinQty)).AsFloat := cfg.ParmFilt.RecFilt.MinQty; // fli_MinQty
      qryFiltr.ParamByName(CreatePfxFld(fli_MaxQty)).AsFloat := cfg.ParmFilt.RecFilt.MaxQty; // fli_MaxQty
      qryFiltr.ParamByName(CreatePfxFld(fli_ProdLine)).AsString  := Trim(cfg.ParmFilt.RecFilt.ProdLine); // fli_ProdLine
      qryFiltr.ParamByName(CreatePfxFld(fli_ProdType)).AsString  := cfg.ParmFilt.RecFilt.ProdType;       // fli_ProdType
      qryFiltr.ParamByName(CreatePfxFld(fli_ProdLowDate_From)).AsDateTime := cfg.ParmFilt.RecFilt.ProdLowDate_From; // fli_ProdLowDate_From
      qryFiltr.ParamByName(CreatePfxFld(fli_ProdLowDate_To)).AsDateTime := cfg.ParmFilt.RecFilt.ProdLowDate_To;   // fli_ProdLowDate_To
      qryFiltr.ParamByName(CreatePfxFld(fli_DelivDate_From)).AsDateTime := cfg.ParmFilt.RecFilt.ProdDelivDate_From;  // fli_DelivDate_From
      qryFiltr.ParamByName(CreatePfxFld(fli_DelivDate_To)).AsDateTime := cfg.ParmFilt.RecFilt.ProdDelivDate_To;    // fli_DelivDate_To
      qryFiltr.ParamByName(CreatePfxFld(fli_PlanStartDate_From)).AsDateTime := cfg.ParmFilt.RecFilt.PlanStartDate_From;  // fli_PlanStartDate_From
      qryFiltr.ParamByName(CreatePfxFld(fli_PlanStartDate_To)).AsDateTime := cfg.ParmFilt.RecFilt.PlanStartDate_To;  // fli_PlanStartDate_To
      qryFiltr.ParamByName(CreatePfxFld(fli_LowStartDate_From)).AsDateTime := cfg.ParmFilt.RecFilt.LowStartDate_From;  // fli_LowStartDate_From
      qryFiltr.ParamByName(CreatePfxFld(fli_LowStartDate_To)).AsDateTime := cfg.ParmFilt.RecFilt.LowStartDate_To;  // fli_LowStartDate_To
      qryFiltr.ParamByName(CreatePfxFld(fli_preqNo)).AsString := cfg.ParmFilt.RecFilt.ProdReq;  // fli_ProdReq
      qryFiltr.ParamByName(CreatePfxFld(fli_Bin_ReadOnly)).AsInteger := ord(cfg.ParmFilt.RecFilt.ReadOnly);  // fli_Bin_ReadOnly
      qryFiltr.ParamByName(CreatePfxFld(fli_wkCtrCode)).AsString := cfg.ParmFilt.RecFilt.wkCtrCode;  // fli_wkCtrCode
      qryFiltr.ParamByName(CreatePfxFld(fli_wkcProc)).AsString := cfg.ParmFilt.RecFilt.wkcProc;    // fli_wkcProc
      qryFiltr.ParamByName(CreatePfxFld(fli_SchedStartDate_From)).AsDateTime := cfg.ParmFilt.RecFilt.SchedStartDate_From;
      qryFiltr.ParamByName(CreatePfxFld(fli_SchedStartDate_To)).AsDateTime := cfg.ParmFilt.RecFilt.SchedStartDate_To;
      qryFiltr.ParamByName(CreatePfxFld(fli_LatestEndingDate_From)).AsDateTime := cfg.ParmFilt.RecFilt.LatestEndingDate_From;
      qryFiltr.ParamByName(CreatePfxFld(fli_LatestEndingDate_To)).AsDateTime := cfg.ParmFilt.RecFilt.LatestEndingDate_To;

      if FiltWkcrAlterntiv in cfg.ParmFilt.RecFilt.Options then
        qryFiltr.ParamByName(CreatePfxFld(fli_ShowAlternative)).AsInteger := 1     // fli_ShowAlternative
      else
        qryFiltr.ParamByName(CreatePfxFld(fli_ShowAlternative)).AsInteger := 0;    // fli_ShowAlternative

      if FiltWkcr_Active in cfg.ParmFilt.RecFilt.Options then
        qryFiltr.ParamByName(CreatePfxFld(fli_Wkcr_FromPlan)).AsInteger := 1     // fli_Wkcr_FromPlan
      else
        qryFiltr.ParamByName(CreatePfxFld(fli_Wkcr_FromPlan)).AsInteger := 0;    // fli_Wkcr_FromPlan

      case cfg.ParmFilt.RecFilt.StepType of
      CST_batch:      qryFiltr.ParamByName(CreatePfxFld(fli_StepType)).AsString := 'B';
      CST_Continuous: qryFiltr.ParamByName(CreatePfxFld(fli_StepType)).AsString := 'C';
      CST_printing:   qryFiltr.ParamByName(CreatePfxFld(fli_StepType)).AsString := 'P'
      else
        // CST_undef
        qryFiltr.ParamByName(CreatePfxFld(fli_StepType)).AsString := ' '
      end;

      qryFiltr.ParamByName(CreatePfxFld(fli_stGroup)).AsInteger := cfg.ParmFilt.RecFilt.GroupNo; // fli_stGroup
      if FiltReProcces in cfg.ParmFilt.RecFilt.Options then
        qryFiltr.ParamByName(CreatePfxFld(fli_reprocNo)).AsInteger := 1
      else
        qryFiltr.ParamByName(CreatePfxFld(fli_reprocNo)).AsInteger := 0;

      qryFiltr.ParamByName(CreatePfxFld(fli_ProdFamily)).AsString := cfg.ParmFilt.RecFilt.ProductFamily;
      qryFiltr.ParamByName(CreatePfxFld(fli_MaterialFamily)).AsString := cfg.ParmFilt.RecFilt.MaterialFamily;

      if FiltSchedJobs in cfg.ParmFilt.RecFilt.Options then
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltSchedJobs)).AsInteger := 1     // fli_FiltSchedJobs
      else
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltSchedJobs)).AsInteger := 0;    // fli_FiltSchedJobs

      if FiltFltJobsOnGantt in cfg.ParmFilt.RecFilt.Options then
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltFltJobsOnGantt)).AsInteger := 1     // fli_FiltFltJobsOnGantt
      else
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltFltJobsOnGantt)).AsInteger := 0;    // fli_FiltFltJobsOnGantt

      if FiltClosedJobs in cfg.ParmFilt.RecFilt.Options then
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltClosedJobs)).AsInteger := 1     // fli_FiltClosedJobs
      else
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltClosedJobs)).AsInteger := 0;    // fli_FiltClosedJobs

      if FiltOnlyReadOnly in cfg.ParmFilt.RecFilt.Options then
        qryFiltr.ParamByName(CreatePfxFld(fli_Bin_OnlyReadOnly)).AsInteger := 1     // fli_Bin_OnlyReadOnly
      else
        qryFiltr.ParamByName(CreatePfxFld(fli_Bin_OnlyReadOnly)).AsInteger := 0;    // fli_Bin_OnlyReadOnly

      if FiltOnlySchedJobs in cfg.ParmFilt.RecFilt.Options then
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltOnlySchedJobs)).AsInteger := 1     // fli_FiltOnlySchedJobs
      else
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltOnlySchedJobs)).AsInteger := 0;    // fli_FiltOnlySchedJobs

      if FiltOnlyClosedJobs in cfg.ParmFilt.RecFilt.Options then
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltOnlyClosedJobs)).AsInteger := 1     // fli_FiltOnlySchedJobs
      else
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltOnlyClosedJobs)).AsInteger := 0;    // fli_FiltOnlySchedJobs

      if FiltGroups in cfg.ParmFilt.RecFilt.Options then
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltGroups)).AsInteger := 1             // fli_FiltGroups
      else
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltGroups)).AsInteger := 0;            // fli_FiltGroups

      if FiltOnlyGroups in cfg.ParmFilt.RecFilt.Options then
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltOnlyGroups)).AsInteger := 1         // fli_FiltOnlyGroups
      else
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltOnlyGroups)).AsInteger := 0;        // fli_FiltOnlyGroups

      if FiltJobPriority in cfg.ParmFilt.RecFilt.Options then
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltPriority)).AsInteger := 0         // fli_FiltShowPriority
      else
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltPriority)).AsInteger := 1;        // fli_FiltShowPriority

      if FiltTemporary in cfg.ParmFilt.RecFilt.Options then
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltTemporary)).AsInteger := 0
      else if FiltFix in cfg.ParmFilt.RecFilt.Options then
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltTemporary)).AsInteger := 1
      else
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltTemporary)).AsInteger := 2;

      if FiltProgress in cfg.ParmFilt.RecFilt.Options then
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltProgress)).AsInteger := 1
      else
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltProgress)).AsInteger := 0;

      if FiltOnlyProgress in cfg.ParmFilt.RecFilt.Options then
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltOnlyProgress)).AsInteger := 1
      else
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltOnlyProgress)).AsInteger := 0;

      if FiltAfterDeliveryDay in cfg.ParmFilt.RecFilt.Options then
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltAfterDeliveryDay)).AsInteger := 1
      else
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltAfterDeliveryDay)).AsInteger := 0;

      if FiltAfterDeliveryInDays in cfg.ParmFilt.RecFilt.Options then
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltAfterDeliveryInDays)).AsInteger := cfg.ParmFilt.RecFilt.AfterDeliveryInDays
      else
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltAfterDeliveryInDays)).AsInteger := 0;

      if FiltBeforeEarliestStart in cfg.ParmFilt.RecFilt.Options then
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltBeforeEarliestStart)).AsInteger := 1
      else
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltBeforeEarliestStart)).AsInteger := 0;

      if FiltBeforeEarliestStartInDays in cfg.ParmFilt.RecFilt.Options then
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltBeforeEarliestStartInDays)).AsInteger := cfg.ParmFilt.RecFilt.BeforeEarliestStartInDays
      else
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltBeforeEarliestStartInDays)).AsInteger := 0;

      if FiltAfterLatestEnd in cfg.ParmFilt.RecFilt.Options then
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltAfterLatestEnd)).AsInteger := 1
      else
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltAfterLatestEnd)).AsInteger := 0;

      if FiltAfterLatestEndInDays in cfg.ParmFilt.RecFilt.Options then
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltAfterLatestEndInDays)).AsInteger := cfg.ParmFilt.RecFilt.AfterLatestEndInDays
      else
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltAfterLatestEndInDays)).AsInteger := 0;

      if FiltShouldBeScheduled in cfg.ParmFilt.RecFilt.Options then
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltShouldBeScheduled)).AsInteger := 1
      else
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltShouldBeScheduled)).AsInteger := 0;

      if FiltShouldBeScheduledIndays in cfg.ParmFilt.RecFilt.Options then
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltShouldBeScheduledIndays)).AsInteger := cfg.ParmFilt.RecFilt.ShouldBeScheduledIndays
      else
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltShouldBeScheduledIndays)).AsInteger := 0;

      if FiltMissingmaterials in cfg.ParmFilt.RecFilt.Options then
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltMissingmaterials)).AsInteger := 1
      else
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltMissingmaterials)).AsInteger := 0;

      if FiltMissingAddRes in cfg.ParmFilt.RecFilt.Options then
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltMissingAddRes)).AsInteger := 1
      else
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltMissingAddRes)).AsInteger := 0;

      if FiltOveridePrevious in cfg.ParmFilt.RecFilt.Options then
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltOveridePrevious)).AsInteger := 1
      else
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltOveridePrevious)).AsInteger := 0;

      if FiltOverideNext in cfg.ParmFilt.RecFilt.Options then
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltOverideNext)).AsInteger := 1
      else
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltOverideNext)).AsInteger := 0;

      if FiltCompWithPrevJob in cfg.ParmFilt.RecFilt.Options then
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltCompWithPrevJob)).AsInteger := 1
      else
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltCompWithPrevJob)).AsInteger := 0;

      if FiltCompWithPrevJobInCase in cfg.ParmFilt.RecFilt.Options then
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltCompWithPrevJobInCase)).AsInteger := cfg.ParmFilt.RecFilt.CompWithPrevJobInCase
      else
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltCompWithPrevJobInCase)).AsInteger := 0;

      if FiltCompWithRes in cfg.ParmFilt.RecFilt.Options then
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltCompWithRes)).AsInteger := 1
      else
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltCompWithRes)).AsInteger := 0;

      if FiltCompWithResInCase in cfg.ParmFilt.RecFilt.Options then
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltCompWithResInCase)).AsInteger := cfg.ParmFilt.RecFilt.CompWithResInCase
      else
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltCompWithResInCase)).AsInteger := 0;

      qryFiltr.ParamByName(CreatePfxFld(fli_FiltResCatCode)).AsString := Trim(cfg.ParmFilt.RecFilt.ResCatCode);

      for j := 1 to 30 do
      begin
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltPropCode) + IntToStr(j)).AsString := cfg.ParmFilt.RecFilt.PropCod[j];
        qryFiltr.ParamByName(CreatePfxFld(fli_FiltPropRes) + IntToStr(j)).AsString := cfg.ParmFilt.RecFilt.PropRes[j];
        qryFiltr.ParamByName(CreatePfxFld(fli_filtPropValueFrom) + IntToStr(j)).AsString := cfg.ParmFilt.RecFilt.PropValfrom[j];
        qryFiltr.ParamByName(CreatePfxFld(fli_filtPropValueTo) + IntToStr(j)).AsString := cfg.ParmFilt.RecFilt.PropValTo[j];
      end;

      trsFiltr.Active := true;
      qryFiltr.ExecSQL;

      tbInfo := @tblInfo[tbl_cfg_binTab_col];
      SetFldPfx(tbInfo.pfx);

      // This is only to check that the array have not been changed unexpected
      for J := Low(cfg.BinArray) to High(cfg.BinArray) do
      begin
        if (cfg.BinArray[J].Width = 0) then
          Exit;
      end;

      for J := Low(cfg.BinArray) to High(cfg.BinArray) do
      begin
        qryColumns.ParamByName(CreatePfxFld(fli_wkstCode)).AsString      := IniAppGlobals.WkstCode;
        qryColumns.ParamByName(CreatePfxFld(fli_TabsCode)).AsInteger     := I;
        qryColumns.ParamByName(CreatePfxFld(fli_BinColField)).AsInteger  := J;

        qryColumns.ParamByName(CreatePfxFld(fli_BinColTitle)).AsString   := cfg.BinArray[J].Title;
        qryColumns.ParamByName(CreatePfxFld(fli_BinColPos)).AsInteger    := cfg.BinArray[J].Pos;
        qryColumns.ParamByName(CreatePfxFld(fli_BinColWidth)).AsInteger  := cfg.BinArray[J].Width;
        if cfg.BinArray[J].Visible  then
          qryColumns.ParamByName(CreatePfxFld(fli_BinColVisibl)).AsInteger := 1
        else
          qryColumns.ParamByName(CreatePfxFld(fli_BinColVisibl)).AsInteger := 0;

        qryColumns.ParamByName(CreatePfxFld(fli_FiltPropCode)).AsString  := cfg.BinArray[J].PropCode;
        qryColumns.ParamByName(CreatePfxFld(fli_BinColOrder)).AsInteger  := cfg.BinArray[J].Order;

        trsColumns.Active := true;
        qryColumns.ExecSQL;
      end;

    end;

  except
    qryColumns.Close;
    trsColumns.Active := false;
    qryColumns.free;
    trsColumns.free;
    qryFiltr.Close;
    trsFiltr.Active := false;
    qryFiltr.free;
    trsFiltr.free;
    SQLStrings.Free;
    Exit;
  end;

  trsColumns.Commit;
  qryColumns.Close;
  trsColumns.Active := false;
  qryColumns.free;
  trsColumns.free;

  trsFiltr.Commit;
  qryFiltr.Close;
  trsFiltr.Active := false;
  qryFiltr.free;
  trsFiltr.free;
  SQLStrings.Free  }
end;

//----------------------------------------------------------------------------//

destructor TBinTabCfg.Destroy;
begin
  if Assigned(ParmFilt) then
    ParmFilt.free;
  inherited Destroy;
end;

//----------------------------------------------------------------------------//

procedure TBinTabCfg.SaveColumnsCfgTab(qryColumns : TMqmQuery; qryDelete : TMqmQuery; TabType : TTabObj);
var
  tbInfoColumns:  ^TTblInfo;
  J, arraysize : Integer;
begin
  tbInfoColumns := @tblInfo[tbl_cfg_binTab_col];
  qryDelete.SQL.Clear;
  qryDelete.SQL.Add('delete from ' + tbInfoColumns.GetTableName + ' Where ' + CreateFld(tbInfoColumns.pfx, fli_wkstCode) + ' = ''' +  IniAppGlobals.WkstCode + '''');
  qryDelete.SQL.Add(AND_IDF_Condition(CreateFld(tbInfoColumns.pfx, fli_Identifier)));
  qryDelete.SQL.Add(' And ' + CreateFld(tbInfoColumns.pfx, fli_TabsCode) + ' = ''' + IntToStr(Code) + '''');

  if TabType = Tb_Normal then
  begin

  end;

  qryDelete.ExecSQL;

  arraysize := -1;
  for J := Low(BinArray) to High(BinArray) do
  begin
    Application.ProcessMessages;
    Inc(arraysize);
    qryColumns.params.arraysize := arraysize + 1;

    qryColumns.params[0].AsIntegers[arraysize]  := StrToInt(IniAppGlobals.Identifier);
    qryColumns.params[1].AsStrings[arraysize]  := IniAppGlobals.WkstCode;
    qryColumns.params[2].AsIntegers[arraysize]  := Code;
    qryColumns.params[3].AsIntegers[arraysize]  := J;

    qryColumns.params[4].AsStrings[arraysize]  := BinArray[J].Title;
    qryColumns.params[5].AsIntegers[arraysize]  := BinArray[J].Pos;
    qryColumns.params[6].AsIntegers[arraysize]  := BinArray[J].Width;

    if BinArray[J].Visible  then
      qryColumns.params[7].AsIntegers[arraysize] := 1
    else
      qryColumns.params[7].AsIntegers[arraysize] := 0;

    qryColumns.params[8].asStrings[arraysize]  := BinArray[J].PropCode;
    qryColumns.params[9].AsIntegers[arraysize]  := BinArray[J].Order;

    if BinArray[J].DescendingSort then
      qryColumns.params[10].asStrings[arraysize] := '1'
    else
      qryColumns.params[10].asStrings[arraysize] := '0';

    qryColumns.params[11].AsIntegers[arraysize]  := BinArray[J].NumColSorted;
     // qryColumns.ParamByName(CreateFld(tbInfoColumns.pfx, fli_BinColDescending)).AsString := '0';
   // qryColumns.ParamByName(CreateFld(tbInfoColumns.pfx, fli_BinColNumColSorted)).AsInteger  := BinArray[J].NumColSorted;

    if TabType = Tb_Normal then
      qryColumns.params[12].AsStrings[arraysize] := '0'

    else if TabType = Tb_MaterialSched then
      qryColumns.params[12].AsStrings[arraysize] := '1';

//    qryColumns.ExecSQL;
  end;

  if arraysize >= 0 then
    qryColumns.execute(arraysize + 1);

  qryColumns.Close;
end;

//----------------------------------------------------------------------------//

procedure TBinTabCfg.SaveFiltersTab(qryFiltr : TMqmQuery; qryDelete : TMqmQuery);
var
  tbInfoFiltr:  ^TTblInfo;
  J : Integer;
begin

  if ParmFilt.P_MaterialSchedFilter then
     tbInfoFiltr := @tblInfo[tbl_cfg_binMaterialFilter]
  else
    tbInfoFiltr := @tblInfo[tbl_cfg_binFilter];


  qryDelete.SQL.Clear;
  qryDelete.SQL.Add('delete from ' + tbInfoFiltr.GetTableName + ' Where ' + CreateFld(tbInfoFiltr.pfx, fli_wkstCode) + ' = ''' +  IniAppGlobals.WkstCode + '''');
  qryDelete.SQL.Add(AND_IDF_Condition(CreateFld(tbInfoFiltr.pfx, fli_Identifier)));
  qryDelete.SQL.Add(' And ' + CreateFld(tbInfoFiltr.pfx, fli_TabsCode) + ' = ''' + IntToStr(Code) + '''');
  qryDelete.ExecSQL;

//  qryFiltr.Prepare;
  qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_Identifier)).AsString := IniAppGlobals.Identifier; // fli_wkstCode
  qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_wkstCode)).AsString  := IniAppGlobals.WkstCode; // fli_wkstCode
  qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_TabsCode)).AsInteger := code;//I;  // fli_TabsCode

  if Length(name) > 40 then
    name := AnsiLeftStr(name,37) + '...';

  qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_TabsDesc)).AsString  := name;  // fli_TabsDesc

  if not ParmFilt.P_MaterialSchedFilter then
  begin
    if isView then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_TabVis)).AsInteger := 1    // fli_TabVis
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_TabVis)).AsInteger := 0;   // fli_TabVis

    // saveing filter params
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_MinQty)).AsFloat := ParmFilt.RecFilt.MinQty; // fli_MinQty
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_MaxQty)).AsFloat := ParmFilt.RecFilt.MaxQty; // fli_MaxQty
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_rsc)).AsString  := Trim(ParmFilt.RecFilt.Resource); // fli_Rsc
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_rsc_to)).AsString  := Trim(ParmFilt.RecFilt.ResourceTo); // fli_ProdLine
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltResCatCode)).AsString := Trim(ParmFilt.RecFilt.ResCatCode);
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_ProdType)).AsString  := ParmFilt.RecFilt.ProdType;       // fli_ProdType
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_ProdLowDate_From)).AsDateTime := ParmFilt.RecFilt.ProdLowDate_From; // fli_ProdLowDate_From
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_ProdLowDate_To)).AsDateTime := ParmFilt.RecFilt.ProdLowDate_To;   // fli_ProdLowDate_To
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_DelivDate_From)).AsDateTime := ParmFilt.RecFilt.ProdDelivDate_From;  // fli_DelivDate_From
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_DelivDate_To)).AsDateTime := ParmFilt.RecFilt.ProdDelivDate_To;    // fli_DelivDate_To
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_PlanStartDate_From)).AsDateTime := ParmFilt.RecFilt.PlanStartDate_From;  // fli_PlanStartDate_From
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_PlanStartDate_To)).AsDateTime := ParmFilt.RecFilt.PlanStartDate_To;  // fli_PlanStartDate_To
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_PlanStartDateToday_From)).AsInteger := ParmFilt.RecFilt.PlanStartDate_DaysFromToday;  // fli_PlanStartDate_From
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_PlanStartDateToday_To)).AsInteger := ParmFilt.RecFilt.PlanStartDate_DaysTillToday;  // fli_PlanStartDate_To
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_PlanEndDate_From)).AsDateTime := ParmFilt.RecFilt.PlanEndDate_From;  // fli_PlanStartDate_From
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_PlanEndDate_To)).AsDateTime := ParmFilt.RecFilt.PlanEndDate_To;  // fli_PlanStartDate_To
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_PlanEndDateToday_From)).AsInteger := ParmFilt.RecFilt.PlanEndDate_DaysFromToday;  // fli_PlanStartDate_From
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_PlanEndDateToday_To)).AsInteger := ParmFilt.RecFilt.PlanEndDate_DaysTillToday;  // fli_PlanStartDate_To
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_NextStartDate_From)).AsDateTime := ParmFilt.RecFilt.NextStartDate_From;  // fli_PlanStartDate_From
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_NextStartDate_to)).AsDateTime := ParmFilt.RecFilt.NextStartDate_to;  // fli_PlanStartDate_To
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_NextStartDateToday_From)).AsInteger := ParmFilt.RecFilt.NextStartDate_DaysFromToday;  // fli_PlanStartDate_From
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_NextStartDateToday_To)).AsInteger := ParmFilt.RecFilt.NextStartDate_DaysTillToday;  // fli_PlanStartDate_To
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_PrevEndDate_From)).AsDateTime := ParmFilt.RecFilt.PrevEndDate_From;  // fli_PlanStartDate_From
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_PrevEndDate_to)).AsDateTime := ParmFilt.RecFilt.PrevEndDate_to;  // fli_PlanStartDate_To
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_PrevEndDateToday_From)).AsInteger := ParmFilt.RecFilt.PrevEndDate_DaysFromToday;  // fli_PlanStartDate_From
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_PrevEndDateToday_To)).AsInteger := ParmFilt.RecFilt.PrevEndDate_DaysTillToday;  // fli_PlanStartDate_To
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_LowStartDate_From)).AsDateTime := ParmFilt.RecFilt.LowStartDate_From;  // fli_LowStartDate_From
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_LowStartDate_To)).AsDateTime := ParmFilt.RecFilt.LowStartDate_To;  // fli_LowStartDate_To
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_preqNo)).AsString := ParmFilt.RecFilt.ProdReq;  // fli_ProdReq
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_preqNo_To)).AsString := ParmFilt.RecFilt.ProdReqTo;  // fli_ProdReq
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_pstepId)).AsInteger := ParmFilt.RecFilt.StepId;
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_pstepId_To)).AsInteger := ParmFilt.RecFilt.StepIdTo;
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_psubstId)).AsInteger := ParmFilt.RecFilt.SubStepId;
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_psubstId_To)).AsInteger := ParmFilt.RecFilt.SubStepIdTo;
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_stGroupFrom)).AsInteger := ParmFilt.RecFilt.GroupNum;
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_stGroupTo)).AsInteger := ParmFilt.RecFilt.GroupNumTo;
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_Bin_ReadOnly)).AsInteger := ord(ParmFilt.RecFilt.ReadOnly);  // fli_Bin_ReadOnly
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_wkCtrCode)).AsString := ParmFilt.RecFilt.wkCtrCode;  // fli_wkCtrCode
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_wkcProc)).AsString := ParmFilt.RecFilt.wkcProc;    // fli_wkcProc
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_wkCtrCode_To)).AsString := ParmFilt.RecFilt.wkCtrCodeTo;  // fli_wkCtrCode
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_wkcProc_To)).AsString := ParmFilt.RecFilt.wkcProcTo;    // fli_wkcProc
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_SchedStartDate_From)).AsDateTime := ParmFilt.RecFilt.SchedStartDate_From;
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_SchedStartDate_To)).AsDateTime := ParmFilt.RecFilt.SchedStartDate_To;
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_DaysFromToday_From)).AsInteger := ParmFilt.RecFilt.SchedStartDate_DaysFromToday;
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_DaysFromToday_To)).AsInteger := ParmFilt.RecFilt.SchedStartDate_DaysTillToday;
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_DaysFromToday_ToTime)).AsInteger := Trunc(ParmFilt.RecFilt.SchedStartDate_DaysTillToday_time);
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_ScheduledJobsCrossesDateTime_From)).AsDateTime := ParmFilt.RecFilt.ScheduleJobsCrosses_From;
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_ScheduledJobsCrossesDateTime_To)).AsDateTime := ParmFilt.RecFilt.ScheduleJobsCrosses_To;
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_LatestEndingDate_From)).AsDateTime := ParmFilt.RecFilt.LatestEndingDate_From;
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_LatestEndingDate_To)).AsDateTime := ParmFilt.RecFilt.LatestEndingDate_To;

    if FiltWkcrAlterntiv in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_ShowAlternative)).AsInteger := 1     // fli_ShowAlternative
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_ShowAlternative)).AsInteger := 0;    // fli_ShowAlternative

    if FiltWkcr_Active in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_Wkcr_FromPlan)).AsInteger := 1     // fli_Wkcr_FromPlan
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_Wkcr_FromPlan)).AsInteger := 0;    // fli_Wkcr_FromPlan

    case ParmFilt.RecFilt.StepType of
    CST_batch:      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_StepType)).AsString := 'B';
    CST_Continuous: qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_StepType)).AsString := 'C';
    CST_printing:   qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_StepType)).AsString := 'P'
    else
      // CST_undef
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_StepType)).AsString := ' '
    end;

  //  qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_stGroup)).AsInteger := ParmFilt.RecFilt.GroupNo; // fli_stGroup
  //  if FiltReProcces in ParmFilt.RecFilt.Options then
  //    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_reprocNo)).AsInteger := 1
  //  else
  //    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_reprocNo)).AsInteger := 0;

    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_ProdFamily)).AsString := ParmFilt.RecFilt.ProductFamily;
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_MaterialFamily)).AsString := ParmFilt.RecFilt.MaterialFamily;

    if FiltSchedJobs in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltSchedJobs)).AsInteger := 1     // fli_FiltSchedJobs
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltSchedJobs)).AsInteger := 0;    // fli_FiltSchedJobs

    if FiltFltJobsOnGantt in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltFltJobsOnGantt)).AsInteger := 1     // fli_FiltFltJobsOnGantt
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltFltJobsOnGantt)).AsInteger := 0;    // fli_FiltFltJobsOnGantt

    if FiltClosedJobs in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltClosedJobs)).AsInteger := 1     // fli_FiltClosedJobs
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltClosedJobs)).AsInteger := 0;    // fli_FiltClosedJobs

    if FiltOnlyReadOnly in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_Bin_OnlyReadOnly)).AsInteger := 1     // fli_Bin_OnlyReadOnly
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_Bin_OnlyReadOnly)).AsInteger := 0;    // fli_Bin_OnlyReadOnly

    if FiltOnlySchedJobs in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltOnlySchedJobs)).AsInteger := 1     // fli_FiltOnlySchedJobs
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltOnlySchedJobs)).AsInteger := 0;    // fli_FiltOnlySchedJobs

    if FiltOnlyClosedJobs in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltOnlyClosedJobs)).AsInteger := 1     // fli_FiltOnlySchedJobs
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltOnlyClosedJobs)).AsInteger := 0;    // fli_FiltOnlySchedJobs

    if FiltGroups in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltGroups)).AsInteger := 1             // fli_FiltGroups
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltGroups)).AsInteger := 0;            // fli_FiltGroups

    if FiltOnlyGroups in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltOnlyGroups)).AsInteger := 1         // fli_FiltOnlyGroups
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltOnlyGroups)).AsInteger := 0;        // fli_FiltOnlyGroups

    if FiltJobPriority in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltPriority)).AsInteger := 0         // fli_FiltShowPriority
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltPriority)).AsInteger := 1;        // fli_FiltShowPriority

    if FiltTemporary in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltTemporary)).AsInteger := 0
    else if FiltFix in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltTemporary)).AsInteger := 1
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltTemporary)).AsInteger := 2;

    if FiltProgress in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltProgress)).AsInteger := 1
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltProgress)).AsInteger := 0;

    if FiltOnlyProgress in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltOnlyProgress)).AsInteger := 1
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltOnlyProgress)).AsInteger := 0;

    if FiltAfterDeliveryDay in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltAfterDeliveryDay)).AsInteger := 1
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltAfterDeliveryDay)).AsInteger := 0;

    if FiltAfterDeliveryInDays in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltAfterDeliveryInDays)).AsInteger := ParmFilt.RecFilt.AfterDeliveryInDays
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltAfterDeliveryInDays)).AsInteger := 0;

    if FiltBeforeEarliestStart in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltBeforeEarliestStart)).AsInteger := 1
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltBeforeEarliestStart)).AsInteger := 0;

    if FiltBeforeEarliestStartInDays in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltBeforeEarliestStartInDays)).AsInteger := ParmFilt.RecFilt.BeforeEarliestStartInDays
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltBeforeEarliestStartInDays)).AsInteger := 0;

    if FiltAfterLatestEnd in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltAfterLatestEnd)).AsInteger := 1
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltAfterLatestEnd)).AsInteger := 0;

    if FiltAfterLatestEndInDays in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltAfterLatestEndInDays)).AsInteger := ParmFilt.RecFilt.AfterLatestEndInDays
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltAfterLatestEndInDays)).AsInteger := 0;

    if FiltShouldBeScheduled in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltShouldBeScheduled)).AsInteger := 1
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltShouldBeScheduled)).AsInteger := 0;

    if FiltShouldBeScheduledIndays in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltShouldBeScheduledIndays)).AsInteger := ParmFilt.RecFilt.ShouldBeScheduledIndays
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltShouldBeScheduledIndays)).AsInteger := 0;

    if FiltMissingmaterials in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltMissingmaterials)).AsInteger := 1
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltMissingmaterials)).AsInteger := 0;

    if FiltMissingAddRes in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltMissingAddRes)).AsInteger := 1
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltMissingAddRes)).AsInteger := 0;

    if FiltOveridePrevious in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltOveridePrevious)).AsInteger := 1
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltOveridePrevious)).AsInteger := 0;

    if FiltOverideNext in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltOverideNext)).AsInteger := 1
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltOverideNext)).AsInteger := 0;

    if FiltCompWithPrevJob in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltCompWithPrevJob)).AsInteger := 1
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltCompWithPrevJob)).AsInteger := 0;

    if FiltCompWithPrevJobInCase in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltCompWithPrevJobInCase)).AsInteger := ParmFilt.RecFilt.CompWithPrevJobInCase
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltCompWithPrevJobInCase)).AsInteger := 0;

    if FiltCompWithRes in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltCompWithRes)).AsInteger := 1
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltCompWithRes)).AsInteger := 0;

    if FiltJobMsg in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltJobMsg)).AsString := '1'
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltJobMsg)).AsString := '0';

    if FiltImbalancedSteps in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltImbalancedSteps)).AsString := '1'
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltImbalancedSteps)).AsString := '0';

    if FiltCompWithResInCase in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltCompWithResInCase)).AsInteger := ParmFilt.RecFilt.CompWithResInCase
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltCompWithResInCase)).AsInteger := 0;

    if FiltConfLevNewLog in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevNewLog)).AsString := '1'
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevNewLog)).AsString := '0';

    if FiltConfLevelsfinal in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevels_final)).AsString := '1'
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevels_final)).AsString := '0';
    if FiltConfLevelsIni in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevels_Ini)).AsString := '1'
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevels_Ini)).AsString := '0';
    if FiltConfLevels1 in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevel1)).AsString := '1'
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevel1)).AsString := '0';
    if FiltConfLevels2 in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevel2)).AsString := '1'
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevel2)).AsString := '0';
    if FiltConfLevels3 in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevel3)).AsString := '1'
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevel3)).AsString := '0';
    if FiltConfLevels4 in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevel4)).AsString := '1'
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevel4)).AsString := '0';
    if FiltConfLevels5 in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevel5)).AsString := '1'
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevel5)).AsString := '0';
    if FiltCustomerDateConfirmed in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltCustomerDateConfirmed)).AsString := '1'
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltCustomerDateConfirmed)).AsString := '0';
    if FiltCustomerDateCulculated in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltCustomerDateCalculated)).AsString := '1'
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltCustomerDateCalculated)).AsString := '0';
    if FiltCustomerDateRequested in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltCustomerDateRequested)).AsString := '1'
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltCustomerDateRequested)).AsString := '0';

    if ParmFilt.RecFilt.ShowFirstGrplineInBin then
       qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltShowFirstGrplineInBin)).AsString := '1'
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltShowFirstGrplineInBin)).AsString := '0';

    if ParmFilt.RecFilt.AutoGroupSingleJob then
       qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltAutoGroupSingleJob)).AsString := '1'
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltAutoGroupSingleJob)).AsString := '0';

    if ParmFilt.RecFilt.ShowBatchGroupLinesInBin then
       qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltShowBatchGroupLinesInBin)).AsString := '1'
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltShowBatchGroupLinesInBin)).AsString := '0';

    case ParmFilt.RecFilt.ShowContinueGroupLinesInBin of
      CsSCG_No:      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltShowContinueGroupLinesInBin)).AsString := '0';
      CsSCG_Yes:     qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltShowContinueGroupLinesInBin)).AsString := '1';
      CsSCG_YesSameSequence:   qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltShowContinueGroupLinesInBin)).AsString := '2'
      else
        qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltShowContinueGroupLinesInBin)).AsString := '0';
    end;

    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_GroupedByCode)).AsString := ParmFilt.P_GroupedByCode;
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_OverriddenTab)).AsString := '0';
    if ParmFilt.P_OverriddenTab then
       qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_OverriddenTab)).AsString := '1';

    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltDependingOnNextHandledStep)).AsInteger := 0;
    if ParmFilt.RecFilt.ShowDependingOnNextHandledStep = CsWhenNotScheduled then
       qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltDependingOnNextHandledStep)).AsInteger := 1
    else if ParmFilt.RecFilt.ShowDependingOnNextHandledStep = CsWhenScheduled then
       qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltDependingOnNextHandledStep)).AsInteger := 2;

    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltDependingOnPrevHandledStep)).AsInteger := 0;
    if ParmFilt.RecFilt.ShowDependingOnPrevHandledStep = CsWhenNotScheduled then
       qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltDependingOnPrevHandledStep)).AsInteger := 1
    else if ParmFilt.RecFilt.ShowDependingOnPrevHandledStep = CsWhenScheduled then
       qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltDependingOnPrevHandledStep)).AsInteger := 2;

    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_filtDependingOnNextHandledLinkedRequest)).AsInteger := 0;
    if ParmFilt.RecFilt.ShowDependingOnNextHandledLinkedRequest = CsWhenNotScheduled then
       qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_filtDependingOnNextHandledLinkedRequest)).AsInteger := 1
    else if ParmFilt.RecFilt.ShowDependingOnNextHandledLinkedRequest = CsWhenScheduled then
       qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_filtDependingOnNextHandledLinkedRequest)).AsInteger := 2;

    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_filtDependingOnPrevHandledLinkedRequest)).AsInteger := 0;
    if ParmFilt.RecFilt.ShowDependingOnPrevHandledLinkedRequest = CsWhenNotScheduled then
       qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_filtDependingOnPrevHandledLinkedRequest)).AsInteger := 1
    else if ParmFilt.RecFilt.ShowDependingOnPrevHandledLinkedRequest = CsWhenScheduled then
       qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_filtDependingOnPrevHandledLinkedRequest)).AsInteger := 2;

    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_wkCtrGroup)).asString := ParmFilt.RecFilt.wkCtrGroup;
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_PlantCode)).asString := ParmFilt.RecFilt.wkCtrPlant;
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_Division)).asString := ParmFilt.RecFilt.wkCtrDivision;


    for j := 1 to 60 do
    begin
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltPropCode) + IntToStr(j)).AsString := ParmFilt.RecFilt.PropCod[j];
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltPropRes) + IntToStr(j)).AsString := ParmFilt.RecFilt.PropRes[j];
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_filtPropValueFrom) + IntToStr(j)).AsString := ParmFilt.RecFilt.PropValfrom[j];
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_filtPropValueTo) + IntToStr(j)).AsString := ParmFilt.RecFilt.PropValTo[j];
    end;


    if FiltBeforeEarliestStartFixed in ParmFilt.RecFilt.Options then
    begin
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_filtFixedEarlistDateFrom)).AsDateTime := ParmFilt.RecFilt.FixedEarliestDate_From;
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_filtFixedEarlistDateTo)).AsDateTime := ParmFilt.RecFilt.FixedEarliestDate_To;
    end else
    begin
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_filtFixedEarlistDateFrom)).AsDateTime := 0;
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_filtFixedEarlistDateTo)).AsDateTime := 0;
    end;

    if FiltBeforeEarliestStartInDaysFixed in ParmFilt.RecFilt.Options then
    begin
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_filtFixedEarlistDateInDaysFrom)).asInteger := ParmFilt.RecFilt.EarliestDays_From;
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_filtFixedEarlistDateInDaysTo)).asInteger := ParmFilt.RecFilt.EarliestDays_To;
    end else
    begin
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_filtFixedEarlistDateInDaysFrom)).asInteger := 0;
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_filtFixedEarlistDateInDaysTo)).asInteger := 0;
    end;

    if FiltIgnoredProg in ParmFilt.RecFilt.Options then
       qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_filtIgnoredProgress)).asInteger := 1
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_filtIgnoredProgress)).asInteger := 0;

   { if FiltItemTypeAndProdCodeBaseWarp in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_filtitemTypeAndProdCodebaseWarp)).asString := ParmFilt.RecFilt.ItemTypeAndProdCodebaseWarp
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_filtitemTypeAndProdCodebaseWarp)).asString := '';

    if FiltItemTypeAndProdCodeSecondWarp in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_filtitemTypeAndProdCodeSecondWarp)).asString := ParmFilt.RecFilt.ItemTypeAndProdCodeSecondWarp
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_filtitemTypeAndProdCodeSecondWarp)).asString := '';  }

  end else
  begin
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_ItemType)).asString := ParmFilt.RecFilt.Item_Type;
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_ProdCode)).asString := ParmFilt.RecFilt.Product_code;
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_netGroupCode)).asString := ParmFilt.RecFilt.NetGroup_Code;
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_Detail_Code)).asString := ParmFilt.RecFilt.MaterialDetailCode;
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_Sub_Detail)).asString := ParmFilt.RecFilt.MaterialCodeSubDetail;
    //2nd level
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_ItemType2)).asString := ParmFilt.RecFilt.Item_Type2;
    qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_ProdCode2)).asString := ParmFilt.RecFilt.Product_code2;

    //sched jobs
    if FiltSchedJobs in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltSchedJobs)).AsInteger := 1     // fli_FiltSchedJobs
    else if FiltOnlySchedJobs in ParmFilt.RecFilt.Options then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltSchedJobs)).AsInteger := 2
    else
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltSchedJobs)).AsInteger := 0;

      //warp level
    if (Filt_WarpBasicLvl in ParmFilt.RecFilt.Options) and not (Filt_WarpSecondLvl in ParmFilt.RecFilt.Options) then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltWarplvl)).AsInteger := 0
    else if not (Filt_WarpBasicLvl in ParmFilt.RecFilt.Options) and (Filt_WarpSecondLvl in ParmFilt.RecFilt.Options) then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltWarplvl)).AsInteger := 1
    else if (Filt_WarpBasicLvl in ParmFilt.RecFilt.Options) and (Filt_WarpSecondLvl in ParmFilt.RecFilt.Options) then
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltWarplvl)).AsInteger := 2;

    for j := 1 to 60 do
    begin
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltPropCode) + IntToStr(j)).AsString := ParmFilt.RecFilt.PropCod[j];
     // qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_FiltPropRes) + IntToStr(j)).AsString := ParmFilt.RecFilt.PropRes[j];
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_filtPropValueFrom) + IntToStr(j)).AsString := ParmFilt.RecFilt.PropValfrom[j];
      qryFiltr.ParamByName(CreateFld(tbInfoFiltr.pfx, fli_filtPropValueTo) + IntToStr(j)).AsString := ParmFilt.RecFilt.PropValTo[j];
    end;

  end;

  qryFiltr.ExecSQL;

end;

//----------------------------------------------------------------------------//

procedure TBinTabCfg.SaveArrayBinCol(BinColArray : array of TBinColCurrent);
var
  I : Integer;
begin
  for I := Low(BinColArray) to High(BinColArray) do
  begin
    BinArray[I].Field := BinColArray[I].Field;
    BinArray[I].Title := BinColArray[I].Title;
    BinArray[I].Pos := BinColArray[I].Pos;
    BinArray[I].Width := BinColArray[I].Width;
    BinArray[I].Visible := BinColArray[I].Visible;
    BinArray[I].PropCode := BinColArray[I].PropCode;
    BinArray[I].Order := BinColArray[I].Order;
    BinArray[I].DescendingSort := BinColArray[I].DescendingSort;
    BinArray[I].NumColSorted := BinColArray[I].NumColSorted;
  end;
end;

//----------------------------------------------------------------------------//

constructor TBinTabCfg.CreatBinTab(IsMat: boolean);
begin
  if isMat then
    SetLength(BinArray, Length(BinMatColDefault))
  else
    SetLength(BinArray, Length(BinColDefault));
  inherited create;
end;

//----------------------------------------------------------------------------//

procedure TBinTabCfg.DeleteTab(qryDelete : TMqmQuery; TabType : TTabObj);
var
  tbInfoFiltr,tbInfoColumns : ^TTblInfo;
begin

  if TabType = Tb_Normal then
  begin
    tbInfoFiltr := @tblInfo[tbl_cfg_binFilter];
    qryDelete.SQL.Clear;
    qryDelete.SQL.Add('delete from ' + tbInfoFiltr.GetTableName + ' Where ' + CreateFld(tbInfoFiltr.pfx, fli_wkstCode) + ' = ''' +  IniAppGlobals.WkstCode + '''');
    qryDelete.SQL.Add(AND_IDF_Condition(CreateFld(tbInfoFiltr.pfx, fli_Identifier)));
    qryDelete.SQL.Add(' And ' + CreateFld(tbInfoFiltr.pfx, fli_TabsCode) + ' = ''' + IntToStr(Code) + '''');
    qryDelete.ExecSQL;

    tbInfoColumns := @tblInfo[tbl_cfg_binTab_col];
    qryDelete.SQL.Clear;
    qryDelete.SQL.Add('delete from ' + tbInfoColumns.GetTableName + ' Where ' + CreateFld(tbInfoColumns.pfx, fli_wkstCode) + ' = ''' +  IniAppGlobals.WkstCode + '''');
    qryDelete.SQL.Add(AND_IDF_Condition(CreateFld(tbInfoColumns.pfx, fli_Identifier)));
    qryDelete.SQL.Add(' And ' + CreateFld(tbInfoColumns.pfx, fli_TabsCode) + ' = ''' + IntToStr(Code) + '''');
    qryDelete.SQL.Add(' And ' + CreateFld(tbInfoColumns.pfx, fli_TypeOfUse) + ' <> ''' + IntToStr(1) + '''');
  end
  else if TabType = Tb_MaterialSched then
  begin
   // should be new table here
    tbInfoFiltr := @tblInfo[tbl_cfg_binMaterialFilter];
    qryDelete.SQL.Clear;
    qryDelete.SQL.Add('delete from ' + tbInfoFiltr.GetTableName + ' Where ' + CreateFld(tbInfoFiltr.pfx, fli_wkstCode) + ' = ''' +  IniAppGlobals.WkstCode + '''');
    qryDelete.SQL.Add(AND_IDF_Condition(CreateFld(tbInfoFiltr.pfx, fli_Identifier)));
    qryDelete.SQL.Add(' And ' + CreateFld(tbInfoFiltr.pfx, fli_TabsCode) + ' = ''' + IntToStr(Code) + '''');
    qryDelete.ExecSQL;

    tbInfoColumns := @tblInfo[tbl_cfg_binTab_col];
    qryDelete.SQL.Clear;
    qryDelete.SQL.Add('delete from ' + tbInfoColumns.GetTableName + ' Where ' + CreateFld(tbInfoColumns.pfx, fli_wkstCode) + ' = ''' +  IniAppGlobals.WkstCode + '''');
    qryDelete.SQL.Add(AND_IDF_Condition(CreateFld(tbInfoColumns.pfx, fli_Identifier)));
    qryDelete.SQL.Add(' And ' + CreateFld(tbInfoColumns.pfx, fli_TabsCode) + ' = ''' + IntToStr(Code) + '''');
    qryDelete.SQL.Add(' And ' + CreateFld(tbInfoColumns.pfx, fli_TypeOfUse) + ' = ''' + IntToStr(1) + '''');
  end;

  qryDelete.ExecSQL;
  Application.ProcessMessages;
end;

//----------------------------------------------------------------------------//

{ TPlanTabCfg }

destructor TPlanTabCfg.Destroy;
var i : Integer;
begin
  if Assigned(res) then
    res.free;

  for I := IsResExpanded.Count -1 downto 0 do
    Dispose(TTResExpanded(IsResExpanded[i]));

  if Assigned(IsResExpanded) then
    IsResExpanded.Free;

  if Assigned(sl_SlotGroup) then
    sl_SlotGroup.Free;

  if Assigned(McmTabConfig) then
  begin
    for i := McmTabConfig.Count - 1 downto 0 do
      Dispose(TTMcmTabConfig(McmTabConfig[i]));
    McmTabConfig.Free;
  end;

  inherited Destroy;
end;

//----------------------------------------------------------------------------//

function TPlanTabCfg.GetResIndex(ResCode : string) : Integer;
var
  I : Integer;
begin
  Result := 0;
  for I := 0 to res.Count - 1 do
  begin
    if (TMqmRes(res[I]).p_ResCode = ResCode) then
    begin
      Result := I;
      Exit
    end;
  end;

end;

//----------------------------------------------------------------------------//

function TPlanTabCfg.GetWorkCenterList : TList;
var
  I : Integer;
  ListWcStr : TStringList;
begin
  Result := TList.Create;
  ListWcStr := TStringList.Create;
  if not assigned(res) then exit;

  for I := 0 to res.Count - 1 do
  begin
    if ListWcStr.IndexOf(TMqmWrkCtr((TMqmRes(res[I])).p_WrkCtr).p_WrkCtrCode) = -1 then
    begin
      ListWcStr.add(TMqmWrkCtr((TMqmRes(res[I])).p_WrkCtr).p_WrkCtrCode);
      Result.add(TMqmRes(res[I]).p_WrkCtr)
    end;
  end;
  ListWcStr.Free;
end;

end.
