unit UMPlanTbs;

interface

uses
  comctrls,
  classes,
  Graphics,
  UGganttPanel,
  UMSchedContFunc,
  UGShapeMan,
  UMViewTbs,
  UMTabCfg,
  ExtCtrls,
  UMStatisticCalculation,
  UGWorkCentersPlanControl,
  UMHdrMan,
  UGWorkCentersPlanShot;

type

  TMqmPlanTabSheet = class(TMViewTabSheet)
    destructor  Destroy; override;
    constructor CreatePlanTbs(AOwner: TPageControl;
                              hdrCfg: TMqmHdrCfg; gc: TGanttConst;
                              shCfg: TShConfig; tbCfg: TPlanTabsCfg;
                              tabCode: integer);

    procedure   CreateWorkCentersPlanTbs(AOwner: TPageControl;
                              hdrCfg: TMqmHdrCfgWc; gc: TGanttConst;
                              shCfg: TShConfig; tbCfg: TPlanTabsCfg;
                              tabCode: integer);

    procedure   SetMcmWorkCenterCategory(allwc : boolean; WcCode : string);
    procedure   SetMcmPropertySelection(allwc : boolean; WcCode : string; PropCode : string; PropDesc : string; SearchedPropValue : string);
    procedure   SetMcmPropertySelectionOnStart(PlanLineGroup : TPlanLineGroup);
    procedure   SetMcmWorkCenterCategoryOnStart(PlanLineGroup : TPlanLineGroup);
    procedure   ClearMcmSecondLvl(allwc : boolean; WcCode : string);
    procedure   ClearMcmSecondLvlGroup(allwcgrp : boolean; PlanLine : TPlanLineWCGroup);
    procedure   UpdatePlanTbs(AOwner: TPageControl; TbCfg: TPlanTabsCfg; TabCode: integer);
    procedure   UpdateList;
    procedure   EnterCompatMode(id: TSchedId);
    procedure   FocusOnDate(date: TDateTime);
    procedure   FocusOnLine(Line: integer);
    procedure   FocusOnJob(startDate,endDate: TDateTime);
    procedure   ExitCompatMode;
    procedure   UpdateCaptions;
    procedure   SetDynamicMcmTabData(WcList : TList);
    procedure   RefreshMcmMcmSecondLvl;
//    procedure   RefreshPlanWc;

  private
    m_PlanType :  TPlanType;
    m_tbCfg:      TPlanTabsCfg;
    m_tabCode:    integer;
    m_ganttPanel: TGanttPanel;
    m_PlanWcControl : TPlanWcControl;
    m_hdrManRes :     TMqmHdrManResources;
    m_BasePanelResources : TPanel;
    m_BasePanelWorkCenters : TPanel;
    m_ActiveTabForStatistics : boolean;

    function GetShapeMan:   TShapeManager;
    function GetGanttPanel: TGanttPanel;
    procedure SetZoom(NewVal: integer);
    function GetZoom: integer;

    procedure SetHZoom(NewVal: integer);
    function GetHZoom: integer;

    procedure SetSZoom(NewVal: integer);
    function GetSZoom: integer;

  public
    property  p_GetPlanType : TPlanType read m_PlanType;
    property  p_shapeMan: TShapeManager read GetShapeMan;
    property  p_HeaderMan: TMqmHdrManResources read m_hdrManRes;
    property  p_ganttPanel : TGanttPanel read GetGanttPanel;
    property  p_zoom :integer read GetZoom write SetZoom;
    property  p_Hzoom :integer read GetHZoom write SetHZoom;
    property  p_Szoom :integer read GetSZoom write SetSZoom;
    property  p_BasePanelResources : TPanel read m_BasePanelResources;
    property  p_BasePanelWorkCenters : TPanel read m_BasePanelWorkCenters;
    property  p_PlanWcControl : TPlanWcControl read m_PlanWcControl;
    property  p_ActiveTabForStatistics : boolean read m_ActiveTabForStatistics write m_ActiveTabForStatistics;

    function GetCode: integer; override;
    procedure SetCode(Code : Integer); override;
    procedure CreateWkcGroups(WCList : TList);
  end;

const

  HEADPANEL_HEIGHT = 95;
  ROW_HEIGHT_NORM  = 50;
  ROW_HEIGHT_DIS_CAPRES = 30;

implementation

uses
  UMSchedCont,
  UMObjCont,
  UMGlobal,
  UGCal,
  UMWkCtr,
  Dialogs,
  Controls,
  SysUtils, // should be remove , not in used
  UGWorkCentersPlanDraw,
  UMres,
  UMPlanGraph,
  FMMainPlan,
  UMCommon;

//----------------------------------------------------------------------------//

destructor TMqmPlanTabSheet.Destroy;
begin
  m_ganttPanel.Free;
  m_PlanWcControl.Free;
//  if assigned(m_StatisticsArray[0]) then
//    m_StatisticsArray[0].free;
//  if assigned(m_StatisticsArray[1]) then
//    m_StatisticsArray[1].free;
  inherited destroy;
end;

//----------------------------------------------------------------------------//

constructor TMqmPlanTabSheet.CreatePlanTbs(AOwner: TPageControl;
                                           hdrCfg: TMqmHdrCfg; gc: TGanttConst;
                                           shCfg: TShConfig; tbCfg: TPlanTabsCfg;
                                           tabCode: integer);
var
  tc: TPlanTabCfg;
  IsDynamic : boolean;
begin
  inherited CreateViewTab(AOwner);
  IsDynamic := false;
  m_BasePanelResources := TPanel.Create(self);
  m_BasePanelResources.parent := self;
  m_BasePanelResources.align := alClient;

  m_BasePanelWorkCenters := TPanel.Create(self);
  m_BasePanelWorkCenters.parent := self;
  m_BasePanelWorkCenters.align := alClient;
  m_BasePanelWorkCenters.Visible := false;

  m_tbCfg   := tbCfg;
  tc := TPlanTabCfg(m_tbCfg.FindTab(tabCode));
  Assert(Assigned(tc));
  m_tabCode := tabCode;
  Caption   := tc.name;

  m_PlanType := tc.m_PlanType;

  if m_PlanType = PDynamic then
    IsDynamic := true;

  gc.RH := Trunc(gc.RH * tc.m_Zoom/ZOOM_CONST);



  m_ganttPanel    := nil;
  m_hdrManRes        := TMqmHdrManResources.CreateHdrMan(m_BasePanelResources, hdrCfg, IsDynamic);
  shCfg.m_calcObj := m_hdrManRes.m_CalPanel;
  m_ganttPanel    := TGanttPanel.CreateGanttPnl(m_BasePanelResources, gc, shCfg);

  m_hdrManRes.m_CalPanel.TimeSCale := TTimeScale(tc.m_CurrTScale);
  m_hdrManRes.m_CalPanel.GoToTime(tc.m_CurrDtTime);

  m_hdrManRes.m_CalPanel.ChangeLeftDate(m_hdrManRes.m_CalPanel.getFTImageToday);

//  if tc.m_PlanType = PNormal then
  m_ganttPanel.UpdateList(tc.res);

  if tc.m_PlanType = PDynamic then
    ImageIndex := 57 //12
  else
    ImageIndex := -1;

  TabVisible := true;
  p_shapeMan.NewRowsAdded(true)

end;

//----------------------------------------------------------------------------//    .

procedure TMqmPlanTabSheet.CreateWkcGroups(WCList : TList);
var  I, Date : Integer;
  WC : TMqmWrkCtr;
  SlotGrpWC, SUM_SlotGrpWC: TTSlotGrp_WKC;
  Hours_Available, Hours_Used : Double;
  S_Hours_Available, S_Hours_Used, SUM_Hours_Available, SUM_Hours_Used : Single;
  errSet : SetOfErrors;
begin

  if not DBAppGlobals.MCM_App then exit;
  if m_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup = 0 then exit;
  SlotGrpWC := nil;

  for Date := Trunc(m_PlanWcControl.P_planWcView.p_cal.GetStartDay) to Trunc(m_PlanWcControl.P_planWcView.p_cal.GetEndDay) do
  begin

    Hours_Available := 0;
    Hours_used := 0;
    SUM_Hours_Available := 0;
    SUM_Hours_used := 0;

    for i := 0 to WCList.Count - 1 do
    begin
      WC := TMqmWrkCtr(WCList[i]);
      if (WC.p_ReadOnly) and (not WC.p_Visible) then
        Continue;

      if m_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup_Lists.Count = 0 then
      begin
        new(SlotGrpWC);
        if m_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup = 1 then
          SlotGrpWC.m_Group :=  WC.P_WcGrp
        else if m_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup = 2 then
          SlotGrpWC.m_Group :=  WC.p_PlantCode
        else if m_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup = 3 then
          SlotGrpWC.m_Group :=  WC.p_Division;
        SlotGrpWC.m_Date := Date;
        SlotGrpWC.m_IsExpanded := True;
        SlotGrpWC.m_errSet := [];
        m_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup_Lists.Add(SlotGrpWC);
      end;

      if m_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup = 1 then //WC Group
      begin
        if (SlotGrpWC.m_Group <> WC.P_WcGrp) or (SlotGrpWC.m_Date <> Date) then
        begin
          new(SlotGrpWC);
          SlotGrpWC.m_Group :=  WC.P_WcGrp;
          SlotGrpWC.m_Date := Date;
          SlotGrpWC.m_IsExpanded := True;
          SlotGrpWC.m_errSet := [];
          m_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup_Lists.Add(SlotGrpWC);
        end;
      end else
      if m_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup = 2 then //plant Group
      begin
        if (SlotGrpWC.m_Group <> WC.p_PlantCode) or (SlotGrpWC.m_Date <> Date) then
        begin
          new(SlotGrpWC);
          SlotGrpWC.m_Group :=  WC.P_PlantCode;
          SlotGrpWC.m_Date := Date;
          SlotGrpWC.m_IsExpanded := True;
          SlotGrpWC.m_errSet := [];
          m_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup_Lists.Add(SlotGrpWC);
        end;
      end else
      if m_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup = 3 then //Division Group
      begin
        if (SlotGrpWC.m_Group <> WC.p_Division) or (SlotGrpWC.m_Date <> Date) then
        begin
          new(SlotGrpWC);
          SlotGrpWC.m_Group :=  WC.p_Division;
          SlotGrpWC.m_Date := Date;
          SlotGrpWC.m_IsExpanded := True;
          SlotGrpWC.m_errSet := [];
          m_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup_Lists.Add(SlotGrpWC);
        end;
      end;

      WC.GetDataForPrdDailyCap(Date, Date, Hours_Available, Hours_used, errSet);

      Hours_Available := SafeFloat(Hours_Available);
      Hours_used := SafeFloat(Hours_used);

      if (Hours_Available < 0.001) and (Hours_Available > 0) then
         Hours_Available := 0;

      if (Hours_used < 0.001) and (Hours_used > 0) then
         Hours_used := 0;

      if Hours_Available > 999999 then
         Hours_Available := 999999;

      if Hours_used > 999999 then
         Hours_used := 999999;

      if Hours_Available < 0 then
         Hours_Available := 0;

      if Hours_used < 0 then
         Hours_used := 0;

      SlotGrpWC.sum_Hours_Available := SafeFloat(SlotGrpWC.sum_Hours_Available);
      SlotGrpWC.sum_Hours_Used := SafeFloat(SlotGrpWC.sum_Hours_Used);

      SlotGrpWC.sum_Hours_Available := SlotGrpWC.sum_Hours_Available + Hours_Available;
      SlotGrpWC.sum_Hours_Used := SlotGrpWC.sum_Hours_Used + Hours_used;
      SlotGrpWC.m_errSet := SlotGrpWC.m_errSet + errSet;

      SUM_Hours_Available := SUM_Hours_Available + Hours_Available;
      SUM_Hours_Used := SUM_Hours_Used + Hours_used;
    end;

    //add summary for each day
    if m_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup > 0 then
    begin
      new(SUM_SlotGrpWC);
      SUM_SlotGrpWC.m_Group := 'Summary';
      SUM_SlotGrpWC.m_Date := Date;
      SUM_SlotGrpWC.m_IsExpanded := True;
      SUM_SlotGrpWC.sum_Hours_Available := SUM_Hours_Available;
      SUM_SlotGrpWC.sum_Hours_Used := SUM_Hours_Used;
      SUM_SlotGrpWC.m_errSet := [];
      m_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup_Lists.Add(SUM_SlotGrpWC);
    end;
  end;
end;

function SortOnWcGrp(Item1, Item2: Pointer): Integer;
var
  Wc1 , Wc2 : TMqmWrkCtr;
begin
  Wc1 := TMqmWrkCtr(Item1);
  Wc2 := TMqmWrkCtr(Item2);

  result := 0;
  if Wc1.p_ReadOnly then
  begin
    if Wc2.p_ReadOnly then
      Result := 0
    else
      Result := 1;
    exit
  end;

  if Wc2.p_ReadOnly then
  begin
    Result := -1;
    exit
  end;

  if Wc1.P_WcGrp < Wc2.P_WcGrp then
    Result := 1  // WC1 < WC2
  else if Wc1.P_WcGrp > Wc2.P_WcGrp then
    Result := -1   // WC1 > WC2
  else
    Result := 0;
end;

function SortOnWcPlant(Item1, Item2: Pointer): Integer;
var
  Wc1 , Wc2 : TMqmWrkCtr;
begin
  Wc1 := TMqmWrkCtr(Item1);
  Wc2 := TMqmWrkCtr(Item2);

  result := 0;
  if Wc1.p_ReadOnly then
  begin
    if Wc2.p_ReadOnly then
      Result := 0
    else
      Result := 1;
    exit
  end;

  if Wc2.p_ReadOnly then
  begin
    Result := -1;
    exit
  end;

  if Wc1.p_PlantCode < Wc2.p_PlantCode then
    Result := 1  // WC1 < WC2
  else if Wc1.p_PlantCode > Wc2.p_PlantCode then
    Result := -1   // WC1 > WC2
  else
    Result := 0;
end;

function SortOnWcDivision(Item1, Item2: Pointer): Integer;
var
  Wc1 , Wc2 : TMqmWrkCtr;
begin
  Wc1 := TMqmWrkCtr(Item1);
  Wc2 := TMqmWrkCtr(Item2);

  result := 0;
  if Wc1.p_ReadOnly then
  begin
    if Wc2.p_ReadOnly then
      Result := 0
    else
      Result := 1;
    exit
  end;

  if Wc2.p_ReadOnly then
  begin
    Result := -1;
    exit
  end;

  if Wc1.p_Division < Wc2.p_Division then
    Result := 1  // WC1 < WC2
  else if Wc1.p_Division > Wc2.p_Division then
    Result := -1   // WC1 > WC2
  else
    Result := 0;
end;

procedure TMqmPlanTabSheet.CreateWorkCentersPlanTbs(AOwner: TPageControl;
                              hdrCfg: TMqmHdrCfgWc; gc: TGanttConst;
                              shCfg: TShConfig; tbCfg: TPlanTabsCfg;
                              tabCode: integer);
var
  tc: TPlanTabCfg;
  I,y : Integer;
  WC : TMqmWrkCtr;
  WCList : TList;
  PlanLineGroup : TPlanLineGroup;
  PlanLineWc : TPlanLineWc;
  IsDynamic : boolean;
  sl : TStringlist;
  PlanLineWCGroup : TPlanLineWCGroup;
begin
  IsDynamic := false;
  m_tbCfg   := tbCfg;
  tc := TPlanTabCfg(m_tbCfg.FindTab(tabCode));
  Assert(Assigned(tc));
  m_tabCode := tabCode;
  Caption   := tc.name;

  m_PlanType := tc.m_PlanType;

  gc.RH := Trunc(gc.RH * tc.m_Zoom/ZOOM_CONST);

  m_BasePanelWorkCenters.Visible := false;

  if m_PlanType = PDynamic then
    IsDynamic := true;

  if not DBAppGlobals.MCM_App then
  begin
    tc.MCMcNumMaxPrd := -1;//3;
    tc.MCMcMaxPrd1 := -1;
    tc.MCMcMaxPrd2 := -1;
    tc.MCMCatViewWcHoursPerc := -1;
    tc.MCMPropertyViewWcHoursPerc := -1;
  end;

  m_PlanWcControl := TPlanWcControl.CreateWcPlanComp(m_BasePanelWorkCenters, hdrCfg, IsDynamic, tc.MCMcNumMaxPrd, tc.MCMcMaxPrd1 , tc.MCMcMaxPrd2, tc.MCMCatViewWcHoursPerc, tc.MCMPropertyViewWcHoursPerc, tc.m_SlotGroup);

  WCList := tc.GetWorkCenterList;

  sl := TStringList.Create;
  PlanLineWc := nil;

  if m_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup = 1 then
    WCList.Sort(SortOnWcGrp)
  else if m_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup = 2 then
    WCList.Sort(SortOnWcPlant)
  else if m_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup = 3 then
    WCList.Sort(SortOnWcDivision);

  for i := 0 to WCList.Count - 1 do
  begin
    WC := TMqmWrkCtr(WCList[i]);
    if (WC.p_ReadOnly) and (not WC.p_Visible) then
      Continue;

    if DBAppGlobals.MCM_App  then
    begin

      if m_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup = 1 then //WC Group
      begin
        if sl.IndexOf(WC.P_WcGrp) = -1 then
        begin
          PlanLineGroup := m_PlanWcControl.P_planWcView.p_pShot.AddGroupLine(WC);
          PlanLineGroup.AddWcGroupLine(PlanLineWc);
          sl.Add(WC.P_WcGrp);
        end;
      end else
      if m_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup = 2 then //Plant
      begin
        if sl.IndexOf(WC.p_PlantCode) = -1 then
        begin
          PlanLineGroup := m_PlanWcControl.P_planWcView.p_pShot.AddGroupLine(WC);
          PlanLineGroup.AddWcGroupLine(PlanLineWc);
          sl.Add(WC.p_PlantCode);
        end;
      end else
      if m_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup = 3 then //Division
      begin
        if sl.IndexOf(WC.p_Division) = -1 then
        begin
          PlanLineGroup := m_PlanWcControl.P_planWcView.p_pShot.AddGroupLine(WC);
          PlanLineGroup.AddWcGroupLine(PlanLineWc);
          sl.Add(WC.p_Division);
        end;
      end;

    end;

    PlanLineGroup := m_PlanWcControl.P_planWcView.p_pShot.AddGroupLine(WC);
    PlanLineGroup.AddWcLine(PlanLineWc); // PlanLineWc not in use to be remove avi

  end;


  if DBAppGlobals.MCM_App  then
  begin
    for y := 0 to m_PlanWcControl.P_planWcView.p_pShot.GetNumLines - 1 do  //number of rows
    begin

      if TPlanLineShow(TPlanLineGroup(m_PlanWcControl.P_planWcView.p_pShot.GetPlanLine(y)).p_son[0]).ClassName = 'TPlanLineWCGroup' then
      begin
        PlanLineWCGroup := TPlanLineWCGroup(TPlanLineGroup(m_PlanWcControl.P_planWcView.p_pShot.GetPlanLine(y)).p_son[0]);

        for i := 0 to WCList.Count - 1 do
        begin
          WC := TMqmWrkCtr(WCList[i]);
          if (WC.p_ReadOnly) and (not WC.p_Visible) then
            Continue;

          if m_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup = 1 then
           if (PlanLineWCGroup.p_Group_name = wc.P_WcGrp) and (PlanLineWCGroup.p_WC_List.IndexOf(WC) = -1) then
              PlanLineWCGroup.p_WC_List.Add(WC);

          if m_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup = 2 then
            if (PlanLineWCGroup.p_Group_name = wc.p_PlantCode) and (PlanLineWCGroup.p_WC_List.IndexOf(WC) = -1) then
              PlanLineWCGroup.p_WC_List.Add(WC);

          if m_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup = 3 then
            if (PlanLineWCGroup.p_Group_name = wc.p_Division) and (PlanLineWCGroup.p_WC_List.IndexOf(WC) = -1) then
              PlanLineWCGroup.p_WC_List.Add(WC);

        end;
      end;
    end;
  end;

  //add summary line
  if m_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup > 0 then
  begin
    PlanLineGroup := m_PlanWcControl.P_planWcView.p_pShot.AddGroupLine(nil);
    PlanLineGroup.AddWcGroupLine(PlanLineWc);
  end;

  sl.Free;

//  m_PlanWcControl.P_planWcView.p_pShot.SortByWC;
  m_PlanWcControl.SetScrolZise;

  WCList.Free;

end;

//----------------------------------------------------------------------------//

procedure TMqmPlanTabSheet.SetMcmWorkCenterCategory(allwc : boolean; WcCode : string);


  function DoesWCCatGroupExist(PlanLineGroup : TPlanLineGroup; Cat_code : String) : Boolean;
   var i : Integer;
  begin
    result := False;

    for I := 0 to PlanLineGroup.p_lineList.Count -1 do
    begin
      if TPlanLineSecondLevel(PlanLineGroup.p_lineList[i]).m_lineHd = Cat_code then
      begin
        result := True;
        break;
      end;
    end;
  end;
var
  I, J, w, x : Integer;
  PlanLineGroup : TPlanLineGroup;
  Grouplevel  :Boolean;
  WC : TMqmWrkCtr;
begin

  Grouplevel := FMQMPlan.IViewAllWcSecondLvla.Caption <> 'All Work center';

  for I := 0 to m_PlanWcControl.P_planWcView.p_pShot.p_numSons - 1 do   //number of rows
  begin
    if (TPlanLineShow(TPlanLineGroup(m_PlanWcControl.P_planWcView.p_pShot.GetPlanLine(i)).p_son[0]).ClassName = 'TPlanLineWCGroup') then
    begin

      if not Grouplevel then continue;

      PlanLineGroup := TPlanLineGroup(m_PlanWcControl.P_planWcView.p_pShot.p_son[I]);
      PlanLineGroup.CleanGroupLines(false);
      PlanLineGroup.p_SecondLevelType := Lvl_Wc_category;
      for w := 0 to TPlanLineWCGroup(TPlanLineGroup(m_PlanWcControl.P_planWcView.p_pShot.GetPlanLine(i)).p_son[0]).p_WC_List.Count -1 do
      begin
         wc := TMqmWrkCtr(TPlanLineWCGroup(TPlanLineGroup(m_PlanWcControl.P_planWcView.p_pShot.GetPlanLine(i)).p_son[0]).p_WC_List[w]);

        for J := 0 to wc.p_numSons_EntityDailyCapacityList - 1 do
        begin

           if not DoesWCCatGroupExist(PlanLineGroup,wc.p_Sons_EntityDailyCapacityList[J])   then
            PlanLineGroup.AddSecondLineLvl(Lvl_Wc_category, '', wc.p_Sons_EntityDailyCapacityList[J],
                          wc.p_Sons_EntityDescDailyCapacityList[J]);

        end;
      end;
      if not allwc then break
    end else
    begin

      if Grouplevel then Continue;

      if not allwc and (WcCode <> TPlanLineGroup(m_PlanWcControl.P_planWcView.p_pShot.p_son[I]).P_WrkCtr.p_WrkCtrCode) then continue;
      PlanLineGroup := TPlanLineGroup(m_PlanWcControl.P_planWcView.p_pShot.p_son[I]);
      PlanLineGroup.CleanGroupLines(false);
      PlanLineGroup.p_SecondLevelType := Lvl_Wc_category;
      for J := 0 to PlanLineGroup.P_WrkCtr.p_numSons_EntityDailyCapacityList - 1 do
      begin
        PlanLineGroup.AddSecondLineLvl(Lvl_Wc_category, '', PlanLineGroup.P_WrkCtr.p_Sons_EntityDailyCapacityList[J],
                      PlanLineGroup.P_WrkCtr.p_Sons_EntityDescDailyCapacityList[J]);
      end;

      if not allwc then break
    end;
  end;
//  m_PlanWcControl.SetScrolZise(DT_OnlyWc);
//  m_PlanWcControl.P_planWcView.RefreshPlan(true)
end;

//----------------------------------------------------------------------------//

procedure TMqmPlanTabSheet.SetMcmPropertySelection(allwc : boolean; WcCode : string; PropCode : string; PropDesc : string; SearchedPropValue : string);

  function DoesWCCatGroupExist(PlanLineGroup : TPlanLineGroup; Cat_code : String) : Boolean;
   var i : Integer;
  begin
    result := False;

    for I := 0 to PlanLineGroup.p_lineList.Count -1 do
    begin
      if TPlanLineSecondLevel(PlanLineGroup.p_lineList[i]).m_lineHd = Cat_code then
      begin
        result := True;
        break;
      end;
    end;
  end;
var
  I, J,w,x : Integer;
  PlanLineGroup : TPlanLineGroup;
  Grouplevel : Boolean;
  WC : TMqmWrkCtr;
begin
  Grouplevel := FMQMPlan.IViewAllWcSecondLvla.Caption <> 'All Work center';

  for I := 0 to m_PlanWcControl.P_planWcView.p_pShot.p_numSons - 1 do
  begin
    if (TPlanLineShow(TPlanLineGroup(m_PlanWcControl.P_planWcView.p_pShot.GetPlanLine(i)).p_son[0]).ClassName = 'TPlanLineWCGroup') then
    begin

      if not Grouplevel then continue;

      if (assigned(TPlanLineWCGroup(FMQMPlan.m_PlanLine))) and not allwc then
      begin

        if TPlanLineShow(TPlanLineGroup(m_PlanWcControl.P_planWcView.p_pShot.GetPlanLine(i)).p_son[0])
          <> TPlanLineWCGroup(FMQMPlan.m_PlanLine)  then
        continue;


      end;

      PlanLineGroup := TPlanLineGroup(m_PlanWcControl.P_planWcView.p_pShot.p_son[I]);
      PlanLineGroup.CleanGroupLines(false);
      PlanLineGroup.p_PropCode := PropCode;
      PlanLineGroup.p_PropDesc := PropDesc;
      PlanLineGroup.p_SearChedValue := SearchedPropValue;
      PlanLineGroup.p_SecondLevelType := lvl_property;
      for w := 0 to TPlanLineWCGroup(TPlanLineGroup(m_PlanWcControl.P_planWcView.p_pShot.GetPlanLine(i)).p_son[0]).p_WC_List.Count -1 do
      begin
         wc := TMqmWrkCtr(TPlanLineWCGroup(TPlanLineGroup(m_PlanWcControl.P_planWcView.p_pShot.GetPlanLine(i)).p_son[0]).p_WC_List[w]);

        for J := 0 to wc.p_numSons_EntityDailyCapacityList - 1 do
        begin

           if not DoesWCCatGroupExist(PlanLineGroup,wc.p_Sons_EntityDailyCapacityList[J])   then
           begin
            if (SearchedPropValue <> '') and (SearchedPropValue <> PlanLineGroup.P_WrkCtr.p_Sons_EntityDailyCapacityList[J]) then
              continue;

            PlanLineGroup.AddSecondLineLvl(lvl_property, PropCode, wc.p_Sons_EntityDailyCapacityList[J],
                          wc.p_Sons_EntityDescDailyCapacityList[J]);
           end;

        end;
      end;
      //if not allwc then break
    end else
    begin
      //if TPlanLineShow(TPlanLineGroup(m_PlanWcControl.P_planWcView.p_pShot.GetPlanLine(i)).p_son[0]).ClassName = 'TPlanLineWCGroup' then continue;
      if Grouplevel then Continue;

      if not allwc and (WcCode <> TPlanLineGroup(m_PlanWcControl.P_planWcView.p_pShot.p_son[I]).P_WrkCtr.p_WrkCtrCode) then continue;

      PlanLineGroup := TPlanLineGroup(m_PlanWcControl.P_planWcView.p_pShot.p_son[I]);

      PlanLineGroup.CleanGroupLines(false);
      PlanLineGroup.p_PropCode := PropCode;
      PlanLineGroup.p_PropDesc := PropDesc;
      PlanLineGroup.p_SearChedValue := SearchedPropValue;
      PlanLineGroup.p_SecondLevelType := lvl_property;
      for J := 0 to PlanLineGroup.P_WrkCtr.p_numSons_EntityDailyCapacityList - 1 do
      begin
        if (SearchedPropValue <> '') and (SearchedPropValue <> PlanLineGroup.P_WrkCtr.p_Sons_EntityDailyCapacityList[J]) then
           continue;
        PlanLineGroup.AddSecondLineLvl(lvl_property, PropCode, PlanLineGroup.P_WrkCtr.p_Sons_EntityDailyCapacityList[J],
                      PlanLineGroup.P_WrkCtr.p_Sons_EntityDescDailyCapacityList[J]);
      end;
      if not allwc then break
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TMqmPlanTabSheet.SetMcmPropertySelectionOnStart(PlanLineGroup : TPlanLineGroup);

  function DoesWCCatGroupExist(PlanLineGroup : TPlanLineGroup; Cat_code : String) : Boolean;
   var i : Integer;
  begin
    result := False;

    for I := 0 to PlanLineGroup.p_lineList.Count -1 do
    begin
      if TPlanLineSecondLevel(PlanLineGroup.p_lineList[i]).m_lineHd = Cat_code then
      begin
        result := True;
        break;
      end;
    end;
  end;


var
  I, J,w,x : Integer;
  WC : TMqmWrkCtr;
begin
  if PlanLineGroup = nil then exit;

  if TPlanLineShow(PlanLineGroup.p_son[0]).ClassName = 'TPlanLineWCGroup' then
  begin

    if assigned(TPlanLineWCGroup(FMQMPlan.m_PlanLine)) then
    begin
        if TPlanLineShow(PlanLineGroup) <> TPlanLineWCGroup(FMQMPlan.m_PlanLine)  then
          exit;
    end;

      for w := 0 to TPlanLineWCGroup(TPlanLineGroup(PlanLineGroup).p_son[0]).p_WC_List.Count -1 do
      begin
         wc := TMqmWrkCtr(TPlanLineWCGroup(TPlanLineGroup(PlanLineGroup).p_son[0]).p_WC_List[w]);

        for J := 0 to wc.p_numSons_EntityDailyCapacityList - 1 do
        begin
           if not DoesWCCatGroupExist(PlanLineGroup,wc.p_Sons_EntityDailyCapacityList[J])   then
           begin
            if wc.p_Sons_EntityDailyCapacityList[J] = '' then
              continue;

            PlanLineGroup.AddSecondLineLvl(lvl_property, PlanLineGroup.p_PropCode, wc.p_Sons_EntityDailyCapacityList[J], wc.p_Sons_EntityDescDailyCapacityList[J]);
           end;

        end;
      end;
  end else
  begin
    PlanLineGroup.CleanGroupLines(false);

      for J := 0 to PlanLineGroup.P_WrkCtr.p_numSons_EntityDailyCapacityList - 1 do
      begin
        if PlanLineGroup.P_WrkCtr.p_Sons_EntityDailyCapacityList[J] = '' then
           continue;

        PlanLineGroup.AddSecondLineLvl(lvl_property, PlanLineGroup.p_PropCode, PlanLineGroup.P_WrkCtr.p_Sons_EntityDailyCapacityList[J],
                      PlanLineGroup.P_WrkCtr.p_Sons_EntityDescDailyCapacityList[J]);
      end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TMqmPlanTabSheet.SetMcmWorkCenterCategoryOnStart(PlanLineGroup : TPlanLineGroup);

  function DoesWCCatGroupExist(PlanLineGroup : TPlanLineGroup; Cat_code : String) : Boolean;
   var i : Integer;
  begin
    result := False;
    for I := 0 to PlanLineGroup.p_lineList.Count -1 do
    begin
      if TPlanLineSecondLevel(PlanLineGroup.p_lineList[i]).m_lineHd = Cat_code then
      begin
        result := True;
        break;
      end;
    end;
  end;

var
  J, w : Integer;
  WC : TMqmWrkCtr;
begin
  if PlanLineGroup = nil then exit;

  if TPlanLineShow(PlanLineGroup.p_son[0]).ClassName = 'TPlanLineWCGroup' then
  begin
    for w := 0 to TPlanLineWCGroup(TPlanLineGroup(PlanLineGroup).p_son[0]).p_WC_List.Count -1 do
    begin
      wc := TMqmWrkCtr(TPlanLineWCGroup(TPlanLineGroup(PlanLineGroup).p_son[0]).p_WC_List[w]);
      for J := 0 to wc.p_numSons_EntityDailyCapacityList - 1 do
      begin
        if not DoesWCCatGroupExist(PlanLineGroup, wc.p_Sons_EntityDailyCapacityList[J]) then
        begin
          if wc.p_Sons_EntityDailyCapacityList[J] = '' then
            continue;
          PlanLineGroup.AddSecondLineLvl(Lvl_Wc_category, '', wc.p_Sons_EntityDailyCapacityList[J],
                        wc.p_Sons_EntityDescDailyCapacityList[J]);
        end;
      end;
    end;
  end
  else
  begin
    PlanLineGroup.CleanGroupLines(false);
    for J := 0 to PlanLineGroup.P_WrkCtr.p_numSons_EntityDailyCapacityList - 1 do
    begin
      if PlanLineGroup.P_WrkCtr.p_Sons_EntityDailyCapacityList[J] = '' then
        continue;
      PlanLineGroup.AddSecondLineLvl(Lvl_Wc_category, '', PlanLineGroup.P_WrkCtr.p_Sons_EntityDailyCapacityList[J],
                    PlanLineGroup.P_WrkCtr.p_Sons_EntityDescDailyCapacityList[J]);
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TMqmPlanTabSheet.ClearMcmSecondLvlGroup(allwcgrp : boolean; PlanLine : TPlanLineWCGroup);
var
  I : Integer;
  PlanLineGroup : TPlanLineGroup;
begin
  for I := 0 to m_PlanWcControl.P_planWcView.p_pShot.p_numSons - 1 do
  begin
    if not allwcgrp and (TPlanLineShow(TPlanLineGroup(m_PlanWcControl.P_planWcView.p_pShot.GetPlanLine(i)).p_son[0]) <> PlanLine) then continue;

    //if TPlanLineShow(TPlanLineGroup(m_PlanWcControl.P_planWcView.p_pShot.GetPlanLine(i)).p_son[0]).ClassName = 'TPlanLineWCGroup' then continue;

    PlanLineGroup := TPlanLineGroup(m_PlanWcControl.P_planWcView.p_pShot.p_son[I]);
    PlanLineGroup.CleanGroupLines(true);
    if not allwcgrp then break
  end;
//  m_PlanWcControl.SetScrolZise(DT_OnlyWc);
  m_PlanWcControl.P_planWcView.RefreshPlan(true)
end;

procedure TMqmPlanTabSheet.ClearMcmSecondLvl(allwc : boolean; WcCode : string);
var
  I, J : Integer;
  PlanLineGroup : TPlanLineGroup;
  ListPropVal   : TStringList;
begin
  ListPropVal   := TStringList.Create;
  for I := 0 to m_PlanWcControl.P_planWcView.p_pShot.p_numSons - 1 do
  begin
    if not allwc and (WcCode <> TPlanLineGroup(m_PlanWcControl.P_planWcView.p_pShot.p_son[I]).P_WrkCtr.p_WrkCtrCode) then continue;

    if TPlanLineShow(TPlanLineGroup(m_PlanWcControl.P_planWcView.p_pShot.GetPlanLine(i)).p_son[0]).ClassName = 'TPlanLineWCGroup' then continue;

    PlanLineGroup := TPlanLineGroup(m_PlanWcControl.P_planWcView.p_pShot.p_son[I]);
    PlanLineGroup.CleanGroupLines(true);
    if not allwc then break
  end;
//  m_PlanWcControl.SetScrolZise(DT_OnlyWc);
  m_PlanWcControl.P_planWcView.RefreshPlan(true)
end;

//----------------------------------------------------------------------------//

procedure TMqmPlanTabSheet.UpdatePlanTbs(AOwner: TPageControl; TbCfg: TPlanTabsCfg; TabCode: integer);
begin
  m_tbCfg := TbCfg;
  if TPlanTabCfg(m_tbCfg.FindTab(TabCode)).m_PlanType = PNormal then
  begin
    Caption := m_tbCfg.FindTab(TabCode).name;
    if Assigned(m_ganttPanel) then
      m_ganttPanel.UpdateListWithOldSort(TPlanTabCfg(m_tbCfg.FindTab(TabCode)).res);
  end;
end;

//----------------------------------------------------------------------------//

procedure TMqmPlanTabSheet.UpdateList;
//var
//  tc: TPlanTabCfg;
begin

{  if Assigned(m_ganttPanel) then
  begin
    tc := TPlanTabCfg(m_tbCfg.FindTab(m_tabCode));
    if not tc.m_isDynamic then
    if Assigned(tc) then
      m_ganttPanel.UpdateList(tc.res)
  end   }
end;

//----------------------------------------------------------------------------//

function TMqmPlanTabSheet.GetShapeMan: TShapeManager;
begin
  Result := nil;
  if m_ganttPanel = nil then exit;

  if Assigned(m_ganttPanel) then
    Result := m_ganttPanel.p_shapeMan
end;

//----------------------------------------------------------------------------//

function TMqmPlanTabSheet.GetGanttPanel : TGanttPanel;
begin
  Result := nil;
  if Assigned(m_ganttPanel) then
    Result := m_ganttPanel
end;

//----------------------------------------------------------------------------//

function TMqmPlanTabSheet.GetCode: integer;
begin
  Result := m_tabCode
end;

//----------------------------------------------------------------------------//

procedure TMqmPlanTabSheet.SetCode(Code : Integer);
begin
  m_tabCode := Code;
end;

//----------------------------------------------------------------------------//

procedure TMqmPlanTabSheet.EnterCompatMode(id: TSchedId);
begin
  if Assigned(m_ganttPanel) then
    m_ganttPanel.EnterCompatMode(id);
end;

//----------------------------------------------------------------------------//

procedure TMqmPlanTabSheet.FocusOnDate(date: TDateTime);
begin
  m_hdrManRes.m_CalPanel.GoToTime(date);
end;

//----------------------------------------------------------------------------//

procedure TMqmPlanTabSheet.FocusOnJob(startdate , enddate: TDateTime );
begin
  if ( m_hdrManRes.m_CalPanel.LeftTime  > enddate) or
     ( m_hdrManRes.m_CalPanel.RightTime < startdate ) then
      m_hdrManRes.m_CalPanel.GoToTime(startdate);
end;

//----------------------------------------------------------------------------//

procedure TMqmPlanTabSheet.FocusOnLine(Line: integer);
begin
  m_ganttPanel.p_shapeMan.TopRowChanged(Line)
end;

//----------------------------------------------------------------------------//

procedure TMqmPlanTabSheet.ExitCompatMode;
begin
  if Assigned(m_ganttPanel) then
    m_ganttPanel.ExitCompatMode
end;

//----------------------------------------------------------------------------//

procedure TMqmPlanTabSheet.UpdateCaptions;
begin
  m_hdrManRes.m_CalPanel.UpdateCaptions
end;

//----------------------------------------------------------------------------//

procedure TMqmPlanTabSheet.SetDynamicMcmTabData(WcList : TList);
var
  I, J : Integer;
  WC : TMqmWrkCtr;
  PlanLineGroup : TPlanLineGroup;
  PlanLineWc : TPlanLineWc;
  sl : TStringList;
begin
  m_PlanWcControl.P_planWcView.p_pShot.Reset;

  sl := TStringList.Create;

  PlanLineWc := nil;

  if m_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup = 1 then
    WCList.Sort(SortOnWcGrp)
  else  if m_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup = 2 then
    WCList.Sort(SortOnWcPlant)
  else if m_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup = 3 then
    WCList.Sort(SortOnWcDivision);

  for I := 0 to WCList.Count - 1 do
  begin
    WC := TMqmWrkCtr(WCList[i]);
    if (WC.p_ReadOnly) and (not WC.p_Visible) then
      Continue;

    if DBAppGlobals.MCM_App then //add group line
    begin
      if m_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup = 1 then //WC Group
      begin
        if sl.IndexOf(WC.P_WcGrp) = -1 then
        begin
          PlanLineGroup := m_PlanWcControl.P_planWcView.p_pShot.AddGroupLine(WC);
          PlanLineGroup.AddWcGroupLine(PlanLineWc);
          sl.Add(WC.P_WcGrp);
        end;

      end else
      if m_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup = 2 then //Plant
      begin
        if sl.IndexOf(WC.p_PlantCode) = -1 then
        begin
          PlanLineGroup := m_PlanWcControl.P_planWcView.p_pShot.AddGroupLine(WC);
          PlanLineGroup.AddWcGroupLine(PlanLineWc);
          sl.Add(WC.p_PlantCode);
        end;

      end else
      if m_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup = 3 then //Division
      begin
        if sl.IndexOf(WC.p_Division) = -1 then
        begin
          PlanLineGroup := m_PlanWcControl.P_planWcView.p_pShot.AddGroupLine(WC);
          PlanLineGroup.AddWcGroupLine(PlanLineWc);
          sl.Add(WC.p_Division);
        end;

      end;
    end;

    PlanLineGroup := m_PlanWcControl.P_planWcView.p_pShot.AddGroupLine(WC);
    PlanLineGroup.AddWcLine(PlanLineWc);
  end;

  //add summary line
  if m_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup > 0 then
  begin
    PlanLineGroup := m_PlanWcControl.P_planWcView.p_pShot.AddGroupLine(nil);
    PlanLineGroup.AddWcGroupLine(PlanLineWc);
  end;

  sl.Free;
//  m_PlanWcControl.P_planWcView.p_pShot.SortByWC;
  m_PlanWcControl.SetScrolZise;
end;

//----------------------------------------------------------------------------//

procedure TMqmPlanTabSheet.RefreshMcmMcmSecondLvl;
var
  I, J, x : Integer;
  PlanLineGroup : TPlanLineGroup;
  LineShow: TPlanLineShow;
  VisRes : TMqmVisibleRes;
  Res    : TMqmRes;
  WrkCtr : TMqmWrkCtr;
  ResList : TList;
begin
  if not Assigned(p_ganttPanel) then exit;
  if not Assigned(p_ganttPanel.p_VisResList) then exit;

  ResList := TList.Create;
  for I := 0 to m_PlanWcControl.P_planWcView.p_pShot.p_numSons - 1 do
  begin
    PlanLineGroup := TPlanLineGroup(m_PlanWcControl.P_planWcView.p_pShot.p_son[I]);
 //   PlanLineGroup.CleanGroupLines(false);

    if PlanLineGroup.p_SecondLevelType = Lvl_non then continue;

    ResList.Clear;
    for J := 0 to p_ganttPanel.p_VisResList.Count - 1 do
    begin
      VisRes := TMqmVisibleRes(p_ganttPanel.p_VisResList[J]);
      Res := TMqmRes(TMqmVisibleRes(VisRes).p_father);
      WrkCtr := TMqmWrkCtr(res.p_father);

      if PlanLineGroup.p_son[0].classname = 'TPlanLineWCGroup' then
      begin
        for x := 0 to TPlanLineWCGroup(PlanLineGroup.p_son[0]).m_WC_List.Count - 1 do
          if TMqmWrkCtr(TPlanLineWCGroup(PlanLineGroup.p_son[0]).m_WC_List[x]) = WrkCtr  then
          begin
           ResList.Add(VisRes);
           break;
          end;
      end else
      begin
        if TMqmWrkCtr(PlanLineGroup.P_WrkCtr) = WrkCtr then
        begin
         ResList.Add(VisRes);
         break;
        end;
      end;
    end;

    if PlanLineGroup.p_SecondLevelType = lvl_property then
    begin
      // Use full VisResList (like runtime) — filtered ResList may miss resources
      p_pl.BuildWkcDailyEntityCapacity(p_ganttPanel.p_VisResList, 2, PlanLineGroup.p_PropCode);

      if PlanLineGroup.P_WrkCtr = nil  then
        SetMcmPropertySelectionOnStart(nil)
      else
        SetMcmPropertySelectionOnStart(PlanLineGroup);
    end
    else if PlanLineGroup.p_SecondLevelType = Lvl_Wc_category then
    begin
      // Use full VisResList (like runtime) — filtered ResList may miss resources
      p_pl.BuildWkcDailyEntityCapacity(p_ganttPanel.p_VisResList, 1, '');
      SetMcmWorkCenterCategoryOnStart(PlanLineGroup);
    end;
  end;
  ResList.Free;
end;

//----------------------------------------------------------------------------//

{procedure TMqmPlanTabSheet.RefreshPlanWc;
begin
  m_PlanWcControl.P_planWcView.RefreshPlan(true);
end;  }

//----------------------------------------------------------------------------//

procedure TMqmPlanTabSheet.SetZoom(NewVal: integer);
var
  tc: TPlanTabCfg;
begin
  if not assigned(self) then exit;
  if Assigned(m_ganttPanel) then
  begin
    tc := TPlanTabCfg(m_tbCfg.FindTab(m_tabCode));
    if Assigned(tc) then
      tc.m_Zoom := NewVal;
    if DBAppSettings.DisableCapRes then
      m_ganttPanel.SetRowHeight(Trunc(ROW_HEIGHT_DIS_CAPRES * tc.m_Zoom/ZOOM_CONST))
    else
      m_ganttPanel.SetRowHeight(Trunc(ROW_HEIGHT_NORM * tc.m_Zoom/ZOOM_CONST));
  end
end;

procedure TMqmPlanTabSheet.SetHZoom(NewVal: integer);
var
  tc: TPlanTabCfg;
begin
  if not assigned(self) then exit;
  if Assigned(m_ganttPanel) then
  begin
    tc := TPlanTabCfg(m_tbCfg.FindTab(m_tabCode));
    if Assigned(tc) then
      tc.m_HZoom := NewVal;
    if DBAppSettings.DisableCapRes then
      m_ganttPanel.SetRowHeight(Trunc(ROW_HEIGHT_DIS_CAPRES * tc.m_HZoom/ZOOM_CONST))
    else
      m_ganttPanel.SetRowHeight(Trunc(ROW_HEIGHT_NORM * tc.m_HZoom/ZOOM_CONST));
  end
end;

procedure TMqmPlanTabSheet.SetSZoom(NewVal: integer);
var
  tc: TPlanTabCfg;
begin
  if not assigned(self) then exit;
  if Assigned(m_ganttPanel) then
  begin
    tc := TPlanTabCfg(m_tbCfg.FindTab(m_tabCode));
    if Assigned(tc) then
      tc.m_SZoom := NewVal;
  end
end;
//----------------------------------------------------------------------------//

function TMqmPlanTabSheet.GetZoom: integer;
var
  tc: TPlanTabCfg;
begin
  Result := ZOOM_CONST;
  if not assigned(self) then exit;
  if Assigned(m_ganttPanel) then
  begin
    tc := TPlanTabCfg(m_tbCfg.FindTab(m_tabCode));
    if Assigned(tc) then
      Result := tc.m_Zoom
  end
end;

function TMqmPlanTabSheet.GetHZoom: integer;
var
  tc: TPlanTabCfg;
begin
  Result := ZOOM_CONST;
  if not assigned(self) then exit;
  if Assigned(m_ganttPanel) then
  begin
    tc := TPlanTabCfg(m_tbCfg.FindTab(m_tabCode));
    if Assigned(tc) then
      Result := tc.m_HZoom
  end
end;

function TMqmPlanTabSheet.GetSZoom: integer;
var
  tc: TPlanTabCfg;
begin
  Result := 20;
  if not assigned(self) then exit;
  if Assigned(m_ganttPanel) then
  begin
    tc := TPlanTabCfg(m_tbCfg.FindTab(m_tabCode));
    if Assigned(tc) then
      Result := tc.m_SZoom
  end
end;

end.
