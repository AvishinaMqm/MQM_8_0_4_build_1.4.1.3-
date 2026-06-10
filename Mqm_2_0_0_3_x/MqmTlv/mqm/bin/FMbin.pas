unit FMbin;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus, UMbinGrid, UMbinGridMaterial, extctrls, Grids, ComCtrls, UMBinTbs , UMTabCfg,
  UMSchedContFunc, UMSchedList, DMsrvPc, UMCompat, ClipBrd,
  UMViewPage, gnugettext, UGPropComp, ToolWin, ImgList, System.ImageList,
  dxScreenTip, cxClasses, dxCustomHint, cxHint;

type

  TFBin = class(TForm)
    PopUpBin: TPopupMenu;
    MIMoveOnPlan: TMenuItem;
    MIClose: TMenuItem;
    MINewGroup: TMenuItem;
    MIAddToGroup: TMenuItem;
    MIModiGrp: TMenuItem;
    EditTab: TMenuItem;
    MiJobDetails: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    MIJobHandling: TMenuItem;
    MIShowOnPlan: TMenuItem;
    MIStartAutoSchedCurrentCfg: TMenuItem;
    N4: TMenuItem;
    MIDftValProdReq: TMenuItem;
    MIBinTab: TMenuItem;
    MIChangeWC: TMenuItem;
    MIWCenterHandle: TMenuItem;
    MIReturnWCOriginal: TMenuItem;
    MICopyCnfg: TMenuItem;
    MiBinCong: TMenuItem;
    MIShowtabtotals: TMenuItem;
    MINewTab: TMenuItem;
    ImageListBin: TImageList;
    MISetFin: TMenuItem;
    MIClearAllMsgHost: TMenuItem;
    MIClearJobHostMsg: TMenuItem;
    MINextLevel: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    CoolBar1: TCoolBar;
    CoolBar2: TCoolBar;
    CoolBar3: TCoolBar;
    CoolBar4: TCoolBar;
    ToolBarBin: TToolBar;
    TBTmpFin: TToolButton;
    TBMoveToBin: TToolButton;
    TBMoveAllJobstobin: TToolButton;
    ToolButton1: TToolButton;
    TBJobMsg: TToolButton;
//    SPSelection: TToolButton;
    TBShowOnPlan: TToolButton;
    TBJobHandling: TToolButton;
    TBShowMaterials: TToolButton;
    ToolButton2: TToolButton;
    TBStartAutoSched: TToolButton;
    ToolButton3: TToolButton;
    TBJobDetails: TToolButton;
    ToolButton4: TToolButton;
    TBAutoGrouping: TToolButton;
    TBAddToGroup: TToolButton;
    TBModiGrp: TToolButton;
    ToolButton5: TToolButton;
    TBBinTab: TToolButton;
    TBShowtabtotals: TToolButton;
    MIJoinAll: TMenuItem;
    MIShowrequirements: TMenuItem;
    MiBalanceStep: TMenuItem;
    MiBalanceImbalanceInBin: TMenuItem;
    MiLearningCurveChange: TMenuItem;
    MiChangingCurveCode: TMenuItem;
    MiRemoveCurveCode: TMenuItem;
    TBRefresh: TToolButton;
    RefreshBin: TTimer;
    TBPosReqOnBin: TToolButton;
    MiSearchAndCreateNewTab: TMenuItem;
    MISearchCrtProdReq: TMenuItem;
    MiProductiondeliverydate: TMenuItem;
    MiPlanStart: TMenuItem;
    MiScheduledstartdate: TMenuItem;
    MiLatestendingdate: TMenuItem;
    MiLowStartTimeLimit: TMenuItem;
    MiProductionearliestdate: TMenuItem;
    MiSearchStep: TMenuItem;
    MiSearchGroupNumber: TMenuItem;
    MiSearchResource: TMenuItem;
    MiSearchQty: TMenuItem;
    MiSearchProductionFamily: TMenuItem;
    MiSearchMaterialFamily: TMenuItem;
    MiSearchProperty: TMenuItem;
    MiSearchSubStep: TMenuItem;
    MIMsgJobHandle: TMenuItem;
    TimerJobMsg: TTimer;
    MIPropPlannerdef: TMenuItem;
    MIStockDetails: TMenuItem;
    MICreateBinUsingCurentCell: TMenuItem;
    TBPosColumnOnBin: TToolButton;
    MICopy: TMenuItem;
    MISplitOnHost: TMenuItem;
    TBUpOrder: TToolButton;
    TBDownOrder: TToolButton;
    MiSelectedJobOverridingParams: TMenuItem;
    MiAssignedBooleanProp1: TMenuItem;
    MiSettAllJobsAssgnedJobTrue: TMenuItem;
    MiSettAllJobsAssgnedJobFalse: TMenuItem;
    MiSetWcPlant: TMenuItem;
    MiReturnOriginalPlantWc: TMenuItem;
    MiChangeWcToAlljobsListedInCurrentBin: TMenuItem;
    MiChangeWcOnlySelectedJob: TMenuItem;
    MiRemoveJobsCalculatedLimitDates: TMenuItem;
    MiSettAllJobsAssgnedJobFalseAndServingCode: TMenuItem;
    MiSettAllJobsAssgnedJobTrueAndServingCode: TMenuItem;
    MINewTabMain: TMenuItem;
    MiCreateTabForGroupByDetailsKeepFilter: TMenuItem;
    MiSearchBySelectedCell: TMenuItem;
    MiSearchBySelectedCellInGroupedBy: TMenuItem;
    MIUnschedule: TMenuItem;
    N5: TMenuItem;
    MiLastOnGantt: TMenuItem;
    MIAutoSchedPlusGeneric: TMenuItem;
    MiDrillDown: TMenuItem;
    MIStartAutoSchedWcCfg: TMenuItem;
    MiRepositionJobsToRealMachines: TMenuItem;
    MISetConfirmLevelTo: TMenuItem;
    MiConfInitial: TMenuItem;
    MiConfLevel1: TMenuItem;
    MiConfLevel2: TMenuItem;
    MiConfLevel3: TMenuItem;
    MiConfLevel4: TMenuItem;
    MiConfLevel5: TMenuItem;
    MiConfFinal: TMenuItem;
    N6: TMenuItem;
    MIAutoSched: TMenuItem;
    MIAutoGroupingSelection: TMenuItem;
    MIAutoUnGroupingSelection: TMenuItem;
    MiSettAllCopyValueFromNextLinkedReq: TMenuItem;
    MiSetlinkedStepsPropertyValueFromJobSelection: TMenuItem;
    MISplitJobsByStepNumberOfMachines: TMenuItem;
    Copyselectionpropertyfromcurrentsteptoprevsteps: TMenuItem;
    Copyselectionpropertyfromcurrentsteptonextsteps: TMenuItem;
    Copyselectionpropertyfromcurrentsteptoprevstep: TMenuItem;
    Copyselectionpropertyfromcurrentsteptonextstep: TMenuItem;
    BinIcons: TImageList;
    MiSeedChange: TMenuItem;
    MiJoinAndSplitAccordingNextStep: TMenuItem;
    MiAutoSeqBySelectedCfg: TMenuItem;
    MIWarpTab: TMenuItem;
    MatPopUp: TPopupMenu;
    CreateNewtab1: TMenuItem;
    CreateNewtab2: TMenuItem;
    Warp1: TMenuItem;
    New1: TMenuItem;
    Edit1: TMenuItem;
    Delete1: TMenuItem;
    MiMatCopy: TMenuItem;
    Configuration1: TMenuItem;
    MiMatUnschedule: TMenuItem;
    MiModifySpeedSetupWarp: TMenuItem;
    MiShowOnPlanMat: TMenuItem;
    MIAlterWorkCenterAndSplitAccordingToMcm: TMenuItem;
    MIUnscheduleSelectedAndForwardLinkedJobs: TMenuItem;
	  MIClearJobWarpHostMsg: TMenuItem;
    MiCreateVersioning: TMenuItem;
    MiFormularesult: TMenuItem;
    Create1: TMenuItem;
    Returntosavedversion1: TMenuItem;
    CleanVersion: TMenuItem;
    cxHintStyleController1: TcxHintStyleController;
    TBReport: TToolButton;
    MiReApplyIgnoreProgress: TMenuItem;
//    MiAutoSeqCompressMcm: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure MIMoveOnPlanClick(Sender: TObject);
//    function  SetPopUpGroupedByMenueItems : boolean;
    procedure SetMcmMqmMenueItems;
    procedure SetGroupedByPopup;
    procedure PopUpBinPopup(Sender: TObject);
    procedure PopUpMatPopup(Sender: TObject);
    procedure SetBinMenuItems(job: TSchedId);
    function  FillSelectedAutoSeqListCfg : TStringlist;
    procedure pgcMainChange(Sender: TObject);
    procedure MICloseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MiBinCongClick(Sender: TObject);
    procedure EditTabClick(Sender: TObject);
    procedure MINewGroupClick(Sender: TObject);
    procedure MIAddToGroupClick(Sender: TObject);
    procedure MIModiGrpClick(Sender: TObject);
    procedure MiJobDetailsClick(Sender: TObject);
    procedure MIJobHandlingClick(Sender: TObject);
    procedure MIShowOnPlanClick(Sender: TObject);
//    procedure MIAutoSchedAllClick(Sender: TObject);
//    procedure MIAutoSchedSelectedClick(Sender: TObject);
    procedure MIDftValProdReqClick(Sender: TObject);
{    procedure MIProdReqClick(Sender: TObject);
    procedure MIProdTypeClick(Sender: TObject);
    procedure MIStepTypeClick(Sender: TObject);
    procedure MIWorkCenterClick(Sender: TObject);
    procedure MIProcessClick(Sender: TObject);
    procedure MIProdFamilyClick(Sender: TObject);
    procedure MIMatFamilyClick(Sender: TObject);  }
    procedure MISearchResultClick(Sender: TObject);
    procedure MIChangeWCClick(Sender: TObject);
    procedure MICopyCnfgClick(Sender: TObject);
    procedure MIReturnWCOriginalClick(Sender: TObject);
    procedure MIShowTabTotalsClick(Sender: TObject);
    function  FocusBinOnJobID(objId : TSchedId; bViewMess: boolean) : boolean;
    procedure MINewTabClick(Sender: TObject);
    procedure MIMoveToBinClick(Sender: TObject);
    procedure MIMoveAllJobstobinClick(Sender: TObject);
    procedure MISetFinClick(Sender: TObject);
    procedure MIShowMaterialsClick(Sender: TObject);
//    procedure MIDeselectAllClick(Sender: TObject);
//    procedure MIInvertselectionClick(Sender: TObject);
//    procedure MISelectAllClick(Sender: TObject);
    procedure MIClearAllMsgHostClick(Sender: TObject);
    procedure MIClearJobHostMsgClick(Sender: TObject);
    procedure MINextLevelClick(Sender: TObject);
    procedure MISetConfLevelToClick(Sender: TObject);
    procedure MIJoinAllClick(Sender: TObject);
    procedure MIShowrequiermentsClick(Sender: TObject);
    procedure MiBalanceStepClick(Sender: TObject);
    procedure MiBalanceImbalanceInBinClick(Sender: TObject);

//    procedure MIAutoSchedAllStartingSelectedJobClick(Sender: TObject);
    procedure MiChangingCurveCodeClick(Sender: TObject);
    procedure MiRemoveCurveCodeClick(Sender: TObject);
    procedure RefreshBinTimer(Sender: TObject);
    procedure TBRefreshClick(Sender: TObject);
    procedure SearchndFocuseClick(Sender: TObject);
    procedure TBPosReqOnBinClick(Sender: TObject);
    procedure MISearchCrtTabClick(Sender: TObject);
    procedure MiAutoSeqBySelectedCfgName(Sender: TObject);
    procedure MiLatestendingdateClick(Sender: TObject);
//    procedure MIAutoSchedAllEndingSelectedJobIncludeClick(Sender: TObject);
    procedure MIMsgJobHandleClick(Sender: TObject);
    procedure TimerJobMsgTimer(Sender: TObject);
    procedure MIPropPlannerdefClick(Sender: TObject);
    procedure MIStockDetailsClick(Sender: TObject);
    procedure MICreateBinUsingCurentCellClick(Sender: TObject);
    procedure TBPosColumnOnBinClick(Sender: TObject);
    procedure MICopyClick(Sender: TObject);
    procedure MISplitOnHostClick(Sender: TObject);
    procedure TBUpDownOrderClick(Sender: TObject);
    procedure MiSelectedJobOverridingParamsClick(Sender: TObject);
    procedure MiSettAllJobsAssgnedJobFalseClick(Sender: TObject);
    procedure MiSettAllJobsAssgnedJobTrueClick(Sender: TObject);
//    procedure MIAutoSchedAllPlusGenericClick(Sender: TObject);
//    procedure MIAutoSchedAllEndingSelectedJobIncludRebuildGenericPlanClick(
//      Sender: TObject);
//    procedure MIAutoSchedAllEndingSelectedJobExcludeClick(Sender: TObject);
//    procedure MIAutoSchedAllEndingSelectedJobExcludRebuildGenericPlanClick(
//      Sender: TObject);
    procedure MiSetWcPlantClick(Sender: TObject);
    procedure MiReturnOriginalPlantWcClick(Sender: TObject);
    procedure MiRemoveJobsCalculatedLimitDatesClick(Sender: TObject);
    procedure MiSettAllJobsAssgnedJobFalseAndServingCodeClick(Sender: TObject);
    procedure MiSettAllJobsAssgnedJobTrueAndServingCodeClick(Sender: TObject);
    procedure MIMoveAllInBinLastOnGanttClick(Sender: TObject);
    procedure ClickGroupedByCode(Sender: TObject);
    procedure UpdateFilterForOverridenTab(Sender: TObject);

//    procedure DrawNenuItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
    procedure MiCreateTabForGroupByDetailsClick(Sender: TObject);
    procedure MiCreateTabForGroupByDetailsKeepFilterClick(Sender: TObject);
    procedure MiSearchBySelectedCellClick(Sender: TObject);
    procedure Showcompatibleforwarp(ProdTypeBaseLvl,ProductBaseLvl,ProdTypeSecondLvl,ProductSecondLvl : String);
    procedure ShowCompatibleWarpForJob(ProdTypeBaseLvl,ProductBaseLvl,ProdTypeSecondLvl,ProductSecondLvl : String);

    procedure MiSearchBySelectedCellInGroupedByClick(Sender: TObject);
    procedure MiSearchPropertyClick(Sender: TObject);
    procedure MIUnscheduleClick(Sender: TObject);
    procedure MiLastOnGanttClick(Sender: TObject);
    procedure MIAutoSchedPlusGenericClick(Sender: TObject);
    procedure MIStartAutoSchedCurrentCfgClick(Sender: TObject);
    procedure MIStartAutoSchedWcCfgClick(Sender: TObject);
    procedure MiRepositionJobsToRealMachinesClick(Sender: TObject);
    procedure MIAutoGroupingSelectionClick(Sender: TObject);
    procedure MIAutoUnGroupingSelectionClick(Sender: TObject);
    procedure MiCngPlanedWorkCenterClick(Sender: TObject);
    procedure MiSetWorkCenterPlantClick(Sender: TObject);
    procedure MiReturnOriginalPlantWorkCenterClick(Sender: TObject);
    procedure MIAutoSchedClick(Sender: TObject);
    procedure CoolBar1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure TBStartAutoSchedMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MiSettAllCopyValueFromNextLinkedReqClick(Sender: TObject);
    procedure MiSetlinkedStepsPropertyValueFromJobSelectionClick(
      Sender: TObject);
    procedure MISplitJobsByStepNumberOfMachinesClick(Sender: TObject);
//    procedure MIGroupedByClick(Sender: TObject);
//    procedure MiAssignedBooleanProp1Click(Sender: TObject);
    procedure CopySelectionPropertyFromCurrentStepToPrevStepsClick(
      Sender: TObject);
    procedure CopySelectionPropertyFromCurrentStepToNextStepsClick(
      Sender: TObject);
    procedure CopySelectionPropertyFromCurrentStepToPrevStepClick(
      Sender: TObject);
    procedure CopySelectionPropertyFromCurrentStepToNextStepClick(
      Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure DrawItemPopUp(Sender: TObject; ACanvas: TCanvas;ARect: TRect; Selected: Boolean);
    procedure MiSeedChangeClick(Sender: TObject);
    procedure MiAssignedBooleanProp1Click(Sender: TObject);
    procedure MiJoinAndSplitAccordingNextStepClick(Sender: TObject);
    procedure MiAutoSeqBySelectedCfgClick(Sender: TObject);
    procedure MIWarpTabClick(Sender: TObject);
    procedure MINewTabMainClick(Sender: TObject);
    procedure testClick(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure MiMatCopyClick(Sender: TObject);
    procedure MiMatUnscheduleClick(Sender: TObject);
	procedure MIUnscheduleSelectedAndForwardLinkedJobsClick(Sender: TObject);
    procedure MiModifySpeedSetupWarpClick(Sender: TObject);
    procedure MiShowOnPlanMatClick(Sender: TObject);
    procedure MIAlterWorkCenterAndSplitAccordingToMcmClick(Sender: TObject);
    procedure MIClearJobWarpHostMsgClick(Sender: TObject);
    procedure MiCreateVersioningClick(Sender: TObject);
    Procedure SetFormulaResultitems(ObjList : TMSchedList);
    Procedure FormulaResultClick(Sender : TObject);
    procedure Returntosavedversion1Click(Sender: TObject);
    procedure CleanVersionClick(Sender: TObject);
    procedure TBReportClick(Sender: TObject);
    procedure MiReApplyIgnoreProgressClick(Sender: TObject);
  public
    procedure SET_Conf_Lvl_AutoRun(Lvl : string);
    procedure FilterJobsWcByDate(Wcntr : pointer; lngDscDayWeekMonth : string; SchedStart : TDateTime; SchedEnd : TDateTime);
    procedure FilterJobsWcPropertyByDate(Wcntr : pointer; lngDscDayWeekMonth : string; Propcode : string; PropValue : string; SchedStart : TDateTime; SchedEnd : TDateTime);
    procedure FilterJobsWcGroupByDate(Wcntr : pointer; lngDscDayWeekMonth : string; SchedStart : TDateTime; SchedEnd : TDateTime);
    procedure FilterJobsWcGroupPropertyByDate(Wcntr : pointer; lngDscDayWeekMonth : string; Propcode : string; PropValue : string; SchedStart : TDateTime; SchedEnd : TDateTime);
    procedure FilterJobsWcGroupCategoryByDate(Wcntr : pointer; lngDscDayWeekMonth : string; ResCatCode : string; SchedStart : TDateTime; SchedEnd : TDateTime);
    procedure FilterJobsWcCategoryByDate(Wcntr : pointer; lngDscDayWeekMonth : string; ResCatCode : string; SchedStart : TDateTime; SchedEnd : TDateTime);

    //    procedure MIAutoSchedNewClick(Sender: TObject);
//    procedure ToolButton8Click(Sender: TObject);
    Procedure CreateTempSeqTab(resCode : string);
  private
    m_TbCfg:   TBinTabsCfg;
    m_pgcBin: TMViewPage;
    m_GroupTypeCreate : CScGroupTypeCreate;
    m_qryTabInsertFilter : TMqmQuery;
    m_qryTabInsertFilterMaterial : TMqmQuery;  // new filter insert
    m_qryTabInsertColumnsCfg : TMqmQuery;
    m_qryTabDelete : TMqmQuery;
    m_TransTabInsert : TMqmTransaction;
    m_toolBarpopUp : boolean;
    m_BinPopupList : TStringList;
    procedure  LoadStatus;

    procedure SetGroupedByFieldMenu;
    procedure SetOverrideExistingTabForDrillDown;
    procedure CopySelectionPropertyFromNextLinkedStep;
    procedure CopySelectionPropertyFromCurrentStepToPrevAndNextStep;
    procedure SetAllJobsAssgnedProp1(Flag : boolean; IncludeSameServingCode : boolean);
    procedure BuildQryForInsertTab;
    function  SearchTabOpened : TBinTabSheet;
    function  SlotFilterByDatesTabOpened : TBinTabSheet;
    function  AutoSequenceResultsTabOpend : TBinTabSheet;
    function  SequenceTabOpened : TBinTabSheet;
    function  WarpCompatibleTabIsOpend : TBinTabSheet;
    function  WarpCompatibleTabForJobIsOpend : TBinTabSheet;
    procedure ResetTabs(tbCfg: TBinTabsCfg);
    function  GetCountSearch : integer;
    function  GetTabByCode(TabCode : Integer) : TTabSheet;
    procedure AutoScheduleMain(ObjList: TMSchedList);
    procedure AutoSchedule(ObjList: TMSchedList);
    function  AutoCreateGroup(job: TSchedId): integer;
    procedure SetDynamicSubMenuForSearchProperty;
    procedure SetDynamicSubMenuForAutoSeqCfgList(ListCfg : TStringList);
    function  CheckExistPropPlannerForID(Id : TSchedId) : boolean;
    function  CheckGroupedByCodeFiledsForSearch(BinColId : CBinColId) : boolean;
    function  CheckActiveAlterWorkCenterAndSplitAccordingToMcm(SchedList : TMSchedList) : boolean;
  public
    function  GetBinPopupList : TStringList;
    function  GetGroupTypeCreate : CScGroupTypeCreate;
    function  GetMouseSchedObj(IDAsIs : boolean) : TSchedId;
    function  GetSchedObjByRow(Row: integer): TSchedId;
    function  GetActiveView: TBinTabSheet;
    function  IsDynamicBinActive : boolean;
    procedure ChangeTabBinforChangeTabPlan;
    function  GetPageCount : Integer;
    procedure OrganizeDefaultTabForNewPropSet;
    procedure UpdateDbForNewPropSetDefaultTab;
    procedure OrganizeTabsForNewPropSet;
    procedure UpdateDbForNewPropSet;
    procedure OrganizePosOerForTabs(var tbs : TBinTabSheet);
    procedure OrganizePosOerForTabsMat(var tbs : TBinTabSheet);

    procedure AddPropCodeForPropColumTabs;
    procedure AddPropCodeForPropColumTab(var tbs : TBinTabSheet);
    procedure UdateTabsProp;
    procedure SetSortIndex(obj : TObject ; NewIndex : Integer);
    procedure SaveStatus;
    procedure RefreshGrid;
    procedure UpdateForChangeFilter;
    procedure GetUpdatedList(ObjList: TMSchedList);
    procedure GetSingleUpdatedList(ObjList: TMSchedList; SchedId : TSchedId);
    function  CreateBinFilterCurrentValues(SchedId : TSchedId; PropType : TPropGridType ; SRChType : CSearchTabs) : boolean;
    procedure CreateTabFromJobID(SchedId : TSchedId; SRChType : CSearchTabs; GroupedByCode : string);
    procedure CreateTabBySearchValues(TabName : string; ValFrom : variant; ValTo : variant; BinColId : CBinColId; IsProp : boolean; PropId : TPropID);
    procedure ResetBinState;
    procedure ChangeBinOptions(FullRowSelect: boolean);
    procedure ShowRequiermants(Id : TSchedId);
    function  CheckSchedSumQtyToAll : boolean;
    function  CanUnGroup(Id : TSchedId) : boolean;
    procedure RemoveAutomaticllyJobsFromGroup(GroupId : TSchedId);
    function  CanUnGroupGroups : boolean;
    procedure ActivateRefreshButton;
    procedure DeActivateRefreshButton;
    procedure ActivateJobMsgButton;
    procedure DeActivateJobMsgButton;
    function  PrepareAutoSeqList(MainIdList : TMSchedList) : boolean;
    function  GetResListForActiveTab(CheckExist : boolean; var ResListObj : TList; var TabName : string) : boolean;
    function  CheckSplitBeforeSchedule(ObjList: TMSchedList; ForceSplit : boolean; NewIdsList : TMSchedList; checkOnly : boolean) : boolean;
    procedure SetActiveTab(TabName : string);
    procedure GetBinTabsNameList(ListStrBinTabsName : TStringList);
    procedure ShowGroupLinesInBin(var ShowBatchLines : boolean; var ShowContinuesLines : CScShowContinueGroupLinesInBin);
    function  ShowFirstGrplineInBin : boolean;
    procedure SetMultilineTabs(Multiline : boolean);
    function  SetDefaultTabName : string;
    procedure CreateSearchTabFromGantt(Id : TSchedId; BinColId : CBinColId);
    procedure AutoSequencingReScheduleMcmJobs(OnStart : boolean);

  end;

var
  FBin: TFBin;
  FToolBar: TToolBar;

implementation

{$R *.DFM}

uses
  UMSchedCont,
  FMCfgBin,
  UMSchedOnPlan,
  FMGroupDetail,
  FMJobHandle,
  UMGlobal,
  UMBinDefault,
  UMBinMatDefault,
  FMMainPlan,
  UMTblDesc,
  FMSearchAndCreateTab,
  UMBinPanel,
  UMObjCont,
  FMBinFiltTabs,
  FMBinFiltTabsMaterial,
//  FMEditTabsBin,
  UMPlanObj,
  UMwkCtr,
  UMPlanFunc,
  UMIssuedArt,
  UMRes,
  UMActArea,
  FMShowMaterials,
  FMStepDetails,
  FMAutoSched,
  FMAutoSchedReport,
  UMRank,
  UMOpStack,
  FMChangeWC,
  UMAutoSchedCfg,
 // FMRankReport,
  UMBinFunc,
  FMCreateCapRes,
  FMCrtDownTime,
  FMOccMov,
  FmBinTotals,
  UMCompatSrv,
  UMAutoSched,
  UMStoredProc,
  UMPlanTbs,
  FMPlannerPropDefine,
  FMRequirements,
  FMGroupAll,
  FMlearningCurve,
  UGbaseCal,
  FMWorkCenterCategoryCapacity,
  FMMsgJobHandler,
  FMAutoSchedOverridingParams,
  FMSearchAndFocuse,
  FmAutoRunSet,
  UMGenericSchedulePrevStep,
  UMAutoSchedSimulation,
  FMAutoSchedReportSimulation,
  FMGroupedByFieldsConfig,
  FMAutoSchedWorkCenterCfg,
  FMSpeedMachine,
  UGglobal, FMStockDetails, UMWarp, UMDurObj,
  FMGrpSplit,
  FMVersioning,
  FMAutoRunDefinition,
  FMTotalViews,
  FMBinReport;

type

  TBinParms = class(TBinFilterParms)
  end;

  TSeqInfo = record
    Request  : string;
    Step     : integer;
    ToHandle : boolean;
  end;
  PTSeqInfo  = ^TSeqInfo;

// -------------------------------------------------------------------------- //

function TFBin.GetBinPopupList: TStringList;
begin
  Result := m_BinPopupList
end;

// -------------------------------------------------------------------------- //

function RemoveAmpersand(ACaption : string) : string;
begin
  Result := ACaption;
  while Pos('&',Result) > 0 do
  System.Delete(Result,Pos('&',Result),1);
end;

// -------------------------------------------------------------------------- //

procedure TFBin.DrawItemPopUp(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; Selected: Boolean);
var
  tmpImage: TBitmap;
  tp, lf : Integer;
begin
  if selected then
    ACanvas.Brush.Color := Cl_STNDRD_LIGHT_BLUE   //Highlighted menutitem color
  else
  begin
    if not TMenuItem(sender).Enabled then
    begin
      ACanvas.Brush.Color := $00F0F0F0;
      ACanvas.Font.Color := clgray
    end
    else
    begin
      ACanvas.Brush.Color := ClWhite;    //default menuitem color
      ACanvas.Font.Color := $00412D23;
    end;
  end;
  ACanvas.FillRect(ARect);

      //TExt color
  ACanvas.TextOut(ARect.Left + 22 ,ARect.Top +2,RemoveAmpersand(TMenuItem(sender).Caption));

  if TMenuItem(sender).Checked = True then
      BinIcons.Draw(ACanvas, ARect.Left, ARect.Top + 2, 32);

  if TMenuItem(sender).ImageIndex > -1 then
  begin  //if image has been assigned
    tmpImage := TBitmap.Create;
    try
      tmpImage.TransparentMode:= tmFixed;
      tmpImage.Transparent := True;
      tmpImage.TransparentColor:= clWhite;
      TMenuItem(sender).GetParentMenu.Images.GetBitmap((TMenuItem(sender).ImageIndex), tmpImage);
      ACanvas.draw(ARect.Left + 2,ARect.Top +2, tmpImage);
    except
    end;
    tmpImage.Free;
  end;

end;

// -------------------------------------------------------------------------- //

procedure TFBin.SaveStatus;
var
  Pl : TWindowPlacement;  // used for API call
  R: TRect;
begin

  // save current window size and position
  with DBAppGlobals do
    if WdwBinDock = 0 then
      if Self.WindowState = wsMaximized then
        WdwBinState := true
      else
      begin
        WdwBinState  := false;
        WdwBinLeft   := Left;
        WdwBinTop    := Top;
        WdwBinWidth  := Width;
        WdwBinHeight := Height
      end
    else
      begin
        WdwBinLeft   := Left;
        WdwBinTop    := Top;
        WdwBinWidth  := Width;
        WdwBinHeight := Height;
        if WdwBinDock = 1 then
          WdwBinSplitterH := GetPlanView.PanRgDock.Width
        else
          WdwBinSplitterH := GetPlanView.PanBotDock.Height;

      //Save Bin Toolbar
       if DBAppSettings.ShowBinToolBar = false then exit;
         if FToolBar.Floating then  ToolBarDock := -1
         else
         begin
           if CoolBar1.Bands.Count > 0 then
             ToolBarDock   := 1;
           if CoolBar2.Bands.Count > 0 then
             ToolBarDock   := 2;
           if CoolBar3.Bands.Count > 0 then
             ToolBarDock   := 3;
           if CoolBar4.Bands.Count > 0 then
             ToolBarDock   := 4;
          end;//else
         if ToolBarDock   = -1 then
         begin
           if ToolBarBin.Parent <> nil then
           begin
             Pl.Length := SizeOf(TWindowPlacement);
             GetWindowPlacement( ToolBarBin.parent.Handle, @Pl);
             R := Pl.rcNormalPosition;
             ToolBarState  := ToolBarBin.Visible;
             ToolBarLeft   := R.Left;
             ToolBarTop    := R.Top;
             ToolBarWidth  := ToolBarBin.Width;
             ToolBarHeight := ToolBarBin.Height;
           end;

         end;
      end
end;

// -------------------------------------------------------------------------- //

procedure TFBin.ResetBinState;
begin
  ManualDock(GetPlanView.PanBotDock, nil, alClient);
  with DBAppGlobals do
  begin
    WdwBinDock := -1; // 0=Undocked  1=Right Dock    -1=Bottom Dock
    WdwBinLeft := 0;
    WdwBinTop := 0;
    WdwBinWidth := 500;
    WdwBinHeight := 70;
    WdwBinState := false;
    WdwBinSplitterH := 150;
  end;
end;

// -------------------------------------------------------------------------- //

procedure TFBin.LoadStatus;
var
  ScreenPos: TRect;
begin
  // restore previous window size and position
  with DBAppGlobals do
  begin

    if WdwBinDock = 0 then
      if WdwBinState then
        Self.WindowState := wsMaximized
      else
      begin
        left   := WdwBinLeft;
        top    := WdwBinTop;
        width  := WdwBinWidth;
        height := WdwBinHeight
      end
    else if WdwBinDock = 1 then
      ManualDock(GetPlanView.PanRgDock, nil, alClient)   // docked right
    else
      ManualDock(GetPlanView.PanBotDock, nil, alClient); // docked bottom

    // test position and size value
    if (top >= 0) and (left >= 0) and (width >= 0) and (height >= 0)  and
       (top <= Screen.DesktopWidth) and (left <= Screen.DesktopWidth) and
       (width <= Screen.DesktopWidth) and (height <= Screen.DesktopHeight) then
      SetBounds(left, top, width, height);

// Load Bin ToolBar
   case ToolBarDock of
         1: ToolBarBin.ManualDock(CoolBar1,nil,alClient);
         2: ToolBarBin.ManualDock(CoolBar2,nil,alClient);
         3: ToolBarBin.ManualDock(CoolBar3,nil,alClient);
         4: ToolBarBin.ManualDock(CoolBar4,nil,alClient);
        else
          ToolBarBin.ManualDock(CoolBar1,nil,alClient);
       end;

       if ToolBarDock  = -1 then
       begin
         ToolBarBin.Visible := ToolBarState;
         screenPos.Left := ToolBarLeft;
         ScreenPos.Top  :=  ToolBarTop;
         ToolBarBin.ManualFloat(screenPos);
         ToolBarBin.Width   := ToolBarWidth;
         ToolBarBin.Height  := ToolBarHeight;
       end; //if

    end;
 // end
end;

// -------------------------------------------------------------------------- //

procedure TFBin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  savestatus;
  if HostDockSite is TPanel then
    GetPlanView.ShowDockPanel(HostDockSite as TPanel, False, nil);
  Action := caFree;
  FBin := nil
end;

// -------------------------------------------------------------------------- //

function TFBin.GetActiveView: TBinTabSheet;
begin
  Result := TBinTabSheet(m_pgcBin.GetActiveView);
end;

// -------------------------------------------------------------------------- //

procedure TFBin.SetActiveTab(TabName : string);
var
  CodeTab : integer;
begin
  CodeTab := m_TbCfg.FinfTabByName(TabName);
  m_pgcBin.SetActiveViewBin(CodeTab);
end;

// -------------------------------------------------------------------------- //

procedure TFBin.GetBinTabsNameList(ListStrBinTabsName: TStringList);
var
  I : Integer;
  TabCfg : TBinTabCfg;
  tbs : TBinTabSheet;
begin
{  for I := 0 to m_TbCfg.p_GetTabsCount - 1 do
  begin
    TabCfg := TBinTabCfg(m_tbCfg.FindTab(m_TbCfg.GetTab(i).code));
    if TabCfg.ParmFilt.P_GroupedByCode <> '' then continue;
    ListStrBinTabsName.Add(TabCfg.name);
  end; }

  for I := 0 to m_TbCfg.p_GetTabsCount - 1 do
  begin
    tbs := TBinTabSheet(GetTabByCode(m_TbCfg.GetTab(i).code));
    if not assigned(tbs) then continue;
    if tbs.P_WarpCampatible or tbs.p_SearchTab or tbs.p_SlotFilterByDatesTab or tbs.p_AutoSequenceResultsTab
      or tbs.P_JobScheduleBySequenceTab then continue;
    TabCfg := TBinTabCfg(m_tbCfg.FindTab(m_TbCfg.GetTab(i).code));
    if tbs.m_BinPanel.GetFiltParms.P_GroupedByCode = '' then
       ListStrBinTabsName.Add(TabCfg.name);
  end;

end;

// -------------------------------------------------------------------------- //

procedure TFBin.ShowGroupLinesInBin(var ShowBatchLines : boolean; var ShowContinuesLines : CScShowContinueGroupLinesInBin);
var
  tab : TBinTabSheet;
begin
  tab := GetActiveView;
  ShowBatchLines := false;
  ShowContinuesLines := CsSCG_No;
  if Assigned(tab.m_BinPanel) and (tab.m_BinPanel.GetFiltParms <> nil) then//and
   // (tab.m_BinPanel.GetFiltParms.P_GroupedByCode = '') then
  begin
    ShowBatchLines := tab.m_BinPanel.GetFiltParms.RecFilt.ShowBatchGroupLinesInBin;
    ShowContinuesLines := tab.m_BinPanel.GetFiltParms.RecFilt.ShowContinueGroupLinesInBin;
  end;
end;

// -------------------------------------------------------------------------- //

function TFBin.ShowFirstGrplineInBin : boolean;
var
  tab : TBinTabSheet;
begin
  Result := false;
  tab := GetActiveView;
  if Assigned(tab) and assigned(tab.m_BinPanel) then
    Result := tab.m_BinPanel.GetFiltParms.RecFilt.ShowFirstGrplineInBin;
end;

// -------------------------------------------------------------------------- //

procedure TFBin.SetMultilineTabs(Multiline : boolean);
begin
  m_pgcBin.MultiLine := Multiline;
end;

// -------------------------------------------------------------------------- //

function TFBin.SetDefaultTabName : string;
var
  I, J : Integer;
  TabCfg : TBinTabCfg;
  FoundName : boolean;
  TmpName : string;
begin
  J := 0;
  Result := _('View');
  TmpName := _('View');
  while true do
  begin
    FoundName := false;
    for I := 0 to m_TbCfg.p_GetTabsCount - 1 do
    begin
      TabCfg := TBinTabCfg(m_tbCfg.FindTab(m_TbCfg.GetTab(i).code));
      if TabCfg.name =  ('   ' + Result +  '   ') then
      begin
        FoundName := true;
        inc(J);
        Result := TmpName + ' ' + IntToStr(J);
      end;
    end;
    if not FoundName then
      break;
  end;
end;

// -------------------------------------------------------------------------- //

function TFBin.IsDynamicBinActive : boolean;
var
  tab : TBinTabSheet;
begin
  Result := false;
  tab := GetActiveView;
  if Assigned(tab) then
    Result := tab.m_BinPanel.P_BinDynamicPlan
end;

procedure TFBin.MiJoinAndSplitAccordingNextStepClick(Sender: TObject);
var
  tbs : TBinTabSheet;
  ObjList : TMSchedList;
  ProdNo : string;
  Step, J, I : integer;
  StepInfo: TSQStepInfo;
  job, ID, NewId, NextjobId : TSchedId;
  SchedIdsList : TMSchedList;
  PlanInfo, PlanInfoMain  :TSQplanInfo;
  SplitInfo: TSQSplitInfo;
  SubStep : Integer;
  QtyPercent, TempQty, RemainQty : double;
  SubStepVal, IntQtyCurrStep , IniQtyNextStep : variant;
  dataType: CBinColValType;
  List : TList;
  MarkStack: TStackMark;
  NumOfSplit : integer;
  FirstSubStep : boolean;
begin
  MIJoinAllClick(self);

  tbs := TBinTabSheet(m_pgcBin.GetActiveView);
  ObjList := TMSchedList.Create(self);
  SchedIdsList := TMSchedList.Create(self);

  for I := 0 to tbs.m_BinPanel.m_objList.GetLinkCount - 1 do
  begin
    p_sc.GetPlanInfo(tbs.m_BinPanel.m_objList.GetLink(I), PlanInfo);
    if PlanInfo.isOnPlan then continue;
    if PlanInfo.isGroup then continue;

    SchedIdsList.ClearList;

    ProdNo := p_sc.GetFldDescr(tbs.m_BinPanel.m_objList.GetLink(I), CSC_ProdReq, false);
    Step := StrToInt(p_sc.GetFldDescr(tbs.m_BinPanel.m_objList.GetLink(I), CSC_ProdStep, false));

    p_sc.GetStepJobs(ProdNo, Step, SchedIdsList);

    NumOfSplit := 0;
    for J := 0 to SchedIdsList.GetLinkCount - 1 do
    begin
      job := SchedIdsList.GetLink(J);
      p_sc.GetPlanInfo(Job, PlanInfo);
      if PlanInfo.isDeleted then continue;
      inc(NumOfSplit);
    end;
    if NumOfSplit > 1 then continue;
    job := tbs.m_BinPanel.m_objList.GetLink(I);
    ProdNo := p_sc.GetFldDescr(job, CSC_ProdReq, false);
    Step := StrToInt(p_sc.GetFldDescr(job, CSC_ProdStep, false));

    if not p_sc.GetNextStepToSched(ProdNo ,Step, StepInfo) then continue;
    if not Assigned(StepInfo.ReqDet) then continue;

    SchedIdsList.ClearList;
    p_sc.GetStepJobs(ProdNo, StepInfo.StepNo , SchedIdsList);

    NumOfSplit := 0;
    for J := 0 to SchedIdsList.GetLinkCount - 1 do
    begin
      job := SchedIdsList.GetLink(J);
      p_sc.GetPlanInfo(Job, PlanInfo);
      if PlanInfo.isDeleted then continue;
      inc(NumOfSplit);
    end;
    if NumOfSplit < 2 then continue;
    ObjList.AddLink(tbs.m_BinPanel.m_objList.GetLink(I));
  end;

  for I := 0 to ObjList.GetLinkCount - 1 do
  begin
    job := ObjList.GetLink(I);

    p_sc.GetPlanInfo(Job, PlanInfoMain);

    RemainQty := PlanInfoMain.quant;
    P_sc.GetFldValue(Job, CSC_IniQty, IntQtyCurrStep, dataType);

    ProdNo := p_sc.GetFldDescr(job, CSC_ProdReq, false);
    Step := StrToInt(p_sc.GetFldDescr(job, CSC_ProdStep, false));
    p_sc.GetNextStepToSched(ProdNo ,Step, StepInfo);

    SchedIdsList.ClearList;
    p_sc.GetStepJobs(ProdNo, StepInfo.StepNo, SchedIdsList);
    FirstSubStep := true;

    for J := 0 to SchedIdsList.GetLinkCount - 1 do
    begin
      Id := SchedIdsList.GetLink(J);
      p_sc.GetPlanInfo(Id, PlanInfo);
      if PlanInfo.isDeleted then continue;
      if FirstSubStep then
      begin
        FirstSubStep := false;
        p_sc.SetJobSubStep(Job, 0, true, false);
        p_sc.SetJobSubStep(Id, 0, false, true);
        continue
      end;

      P_sc.GetFldValue(id, CSC_IniQty, IniQtyNextStep, dataType);
      p_sc.GetFldValue(Id, CSC_ProdSubStep, SubStepVal, dataType);
      SubStep := SubStepVal;
      QtyPercent := PlanInfo.quant/IniQtyNextStep;
      TempQty := IntQtyCurrStep * QtyPercent;
      TempQty := trunc(TempQty * 100);
      TempQty := TempQty / 100;
      RemainQty := RemainQty - TempQty;
      p_sc.SplitJob(job, RemainQty, TempQty, 1, NewId);
      p_sc.SetJobSubStep(NewId, SubStep, true, false);
      p_sc.GetFldValue(NewId, CSC_ProdSubStep, SubStepVal, dataType);
      SubStep := SubStepVal;
      p_sc.SetJobSubStep(Id, SubStep, false, true);
    end;

  end;

  if Assigned(tbs) then
    tbs.m_BinPanel.UpdateForChangeFilter;  // Refresh Bin

  if Assigned(SchedIdsList) then
  begin
    SchedIdsList.ClearList;
    SchedIdsList.Free;
  end;

end;

// -------------------------------------------------------------------------- //

procedure TFBin.MiLastOnGanttClick(Sender: TObject);
begin
  MIMoveAllInBinLastOnGanttClick(self)
end;

// -------------------------------------------------------------------------- //

procedure TFBin.ChangeTabBinforChangeTabPlan;
var
  tab : TBinTabSheet;
begin
  tab := GetActiveView;
  if Assigned(tab) then
  begin
//    p_sc.DisableAllBinCheckBox(false);
    tab.m_BinPanel.UpdateForChangeFilter;
  end;
end;

// -------------------------------------------------------------------------- //

function TFBin.GetPageCount : Integer;
begin
  Result := m_pgcBin.PageCount
end;

// -------------------------------------------------------------------------- //

Procedure BuildAllowedWCProcessList(GanttWCList : Tlist; var WcProcAllowedList : TList; FromWCCode, ToWCCode : String; Alternatives : boolean);
var
  WrkCtr, WrkCtrAlt : TMqmWrkCtr;
  AltProc : String;
  Index, Index2, Index3, processCount, IndexAlt : integer;
  EntryFound : boolean;
  ListAlt : Tlist;
  AltRec : PAltWkcRec;

  // -------------------------------------------------------------------------- //
  function SearchAndAddAllowedWCProcess(OnlySearch : boolean; WCCodeToSearch, ProcessCodeToSearch : String): boolean;
  var
    PWorkCnterProcessAllowed : PTWorkCnterProcessAllowed;
    I: integer;
    Multiplier, NumberOfEntries, LowestHighestValue : integer;
  begin
    Result := false;
    NumberOfEntries := WcProcAllowedList.Count;
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
        if (PTWorkCnterProcessAllowed(WcProcAllowedList[I]).wc < WCCodeToSearch) then
        begin
          i := i + Multiplier;
          Continue;
        end;
        if (PTWorkCnterProcessAllowed(WcProcAllowedList[I]).wc > WCCodeToSearch) then
        begin
          if I < LowestHighestValue then LowestHighestValue := I;
          i := i - Multiplier;
          Continue;
        end;
        if (PTWorkCnterProcessAllowed(WcProcAllowedList[I]).proc < ProcessCodeToSearch) then
        begin
          i := i + Multiplier;
          Continue;
        end;
        if (PTWorkCnterProcessAllowed(WcProcAllowedList[I]).proc > ProcessCodeToSearch) then
        begin
          if I < LowestHighestValue then LowestHighestValue := I;
          i := i - Multiplier;
          Continue;
        end;
        Result := true;
        Exit;
      end;
    end;
    if OnlySearch then exit;
    New(PWorkCnterProcessAllowed);
    PWorkCnterProcessAllowed.wc := WCCodeToSearch;
    PWorkCnterProcessAllowed.proc := ProcessCodeToSearch;
    WcProcAllowedList.insert(LowestHighestValue, PWorkCnterProcessAllowed);
  end;
  // -------------------------------------------------------------------------- //

begin
  for Index := 0 to GanttWCList.count - 1 do
  begin
    WrkCtr := TMqmWrkCtr(GanttWCList[Index]);
    if not assigned(WrkCtr) then continue;
    if (FromWCCode <> '') and (ToWCCode = '') and (WrkCtr.p_WrkCtrCode <> FromWCCode) then continue;
    if  (ToWCCode <> '') then
    begin
      if (WrkCtr.p_WrkCtrCode < FromWCCode) then continue;
      if (WrkCtr.p_WrkCtrCode > ToWCCode) then continue;
    end;

    SearchAndAddAllowedWCProcess(false, WrkCtr.p_WrkCtrCode, '');
  end;

  if not Alternatives then exit;

  for Index := 0 to GanttWCList.count - 1 do
  begin
    WrkCtr := TMqmWrkCtr(GanttWCList[Index]);
    if not assigned(WrkCtr) then continue;
    if (FromWCCode <> '') and (ToWCCode = '') and (WrkCtr.p_WrkCtrCode <> FromWCCode) then continue;
    if (ToWCCode <> '') then
    begin
      if (WrkCtr.p_WrkCtrCode < FromWCCode) then continue;
      if (WrkCtr.p_WrkCtrCode > ToWCCode) then continue;
    end;

    ListAlt := Tlist.Create;
    if p_pl.FindAltListWc(WrkCtr.p_WrkCtrCode , ListAlt) then
    for IndexAlt := 0 to ListAlt.Count -1 do
    begin
      WrkCtrAlt := nil;
      AltRec := PAltWkcRec(ListAlt[IndexAlt]);
      WrkCtrAlt := TMqmWrkCtr(p_pl.FindWrkCtrByCode(AltRec.WorkCenter));
      if WrkCtrAlt = nil then continue;
      if SearchAndAddAllowedWCProcess(true, WrkCtrAlt.p_WrkCtrCode, '') then continue;
      SearchAndAddAllowedWCProcess(false, WrkCtrAlt.p_WrkCtrCode, AltRec.Process);
    end;
    for IndexAlt := 0 to ListAlt.count-1 do
    begin
      AltRec := PAltWkcRec(ListAlt[IndexAlt]);
      Dispose(AltRec)
    end;
    ListAlt.Free;

  end;

end;

// -------------------------------------------------------------------------- //

function FncFilterStep(id: TSchedID; Panel: TObject; WcProcAllowedList : TList): boolean;
var
  binPan: TBinPanel;
  qtp: TBinParms;
  PlanInfo :TSQplanInfo;
  ActArea : TMqmPlanObj;
  FieldVal : variant;
  dataType: CBinColValType;
  FromWCCode, ToWCCode : String;
  Alternatives : boolean;
  visRes:   TMqmVisibleRes;
  CompVal:  TCompatVal;
  Dependency : boolean;
  errlist : TStringList;
  IdBelongToGroup : boolean;
  ShowBatchGroupLinesInBin : boolean;
  ShowContinueGroupLinesInBin : CScShowContinueGroupLinesInBin;
begin
  Result := false;
  binPan := TBinPanel(Panel);
  qtp := TBinParms(binPan.GetFiltParms);

  Assert(Assigned(qtp));

  if qtp.P_MaterialSchedFilter then
  begin
    p_sc.GetPlanInfo(id, PlanInfo);
    if not PlanInfo.is_MaterialSched then exit;
    Result := qtp.TestMatFilterOpts(id);
    exit;
  end;

  p_sc.GetPlanInfo(id, PlanInfo);

  if PlanInfo.isDeleted then
    exit; // tJob.m_isDeleted

  if PlanInfo.VisibleInBin = CSB_NotVisible then Exit;

  if PlanInfo.isDeleted then exit;

  if DBAppGlobals.MCM_App then
  begin

  end
  else
  begin
   // if (not binPan.P_BinDynamicPlan) and IsDynamicPlanActiv then
   // begin
   //   exit;
   // end;
  end;

  visRes := TMqmVisibleRes(p_pl.GetCompatModeInBinVisRes);

  if qtp.P_SeqFilter then
  begin
    if p_sc.IsProdSchedMaterial(Id) then exit;
    errlist := TStringList.Create;
    if visRes <> nil then
    begin
      if not visRes.CheckCompatWithOcc([cho_compVal, cho_wkc, cho_readOnly, cho_qty, cho_Depend],
                                   id, Now, errlist, compVal, Dependency) then
      begin
        if (DBAppSettings.CreateNewBinTabForCompatibles = NewB_Yes_OnlyCompatibleAndToSchedJobs) or
          (DBAppSettings.CreateNewBinTabForCompatibles = NewB_Yes_MarkCompatibleAndToSchedJobs) then
        begin
          errlist.Free;
          Exit;
        end;
      end;
      errlist.Free;
    end;
  end
  else if not qtp.P_MaterialSchedFilter then
  begin
    if p_sc.IsProdSchedMaterial(Id) then exit;
    if (DBAppSettings.ShowCompatibleInExistingBINS = ShowC_Yes_ShowOnlyCompatibles) then
    begin
      if visRes <> nil then
      begin
        p_sc.GetFldValue(id, CSC_Closed, FieldVal, dataType);
        if FieldVal then exit;
        if (p_sc.IsProgressed(id) <> prg_none) then exit;
        if p_sc.GetExtLinkPtr(id) <> nil then exit;
        if not visRes.CheckCompatWithOcc([cho_compVal, cho_wkc, cho_readOnly, cho_qty, cho_Depend],
                                     id, Now, nil, compVal, Dependency) then
           Exit
      end;
    end;
  end;

  p_sc.LinesBelongToGroup(id, IdBelongToGroup);

  ShowBatchGroupLinesInBin := qtp.RecFilt.ShowBatchGroupLinesInBin;
  ShowContinueGroupLinesInBin := qtp.RecFilt.ShowContinueGroupLinesInBin;

  ActArea := p_sc.GetExtLinkPtr(id);
  if Assigned(ActArea) //and //not IdBelongToGroup
  and not (FiltFltJobsOnGantt in qtp.RecFilt.Options) then
  begin
    if not binPan.IsResVisible(ActArea.p_Father) then
      Result := false
    else
    begin
      Result := true;
      if not ShowBatchGroupLinesInBin and (ShowContinueGroupLinesInBin = CsSCG_No) then
      begin
        if IdBelongToGroup then result := false;
      end
      else if ShowBatchGroupLinesInBin or (ShowContinueGroupLinesInBin <> CsSCG_No) then
      begin
        if p_sc.IsGroup(id) then
          Result := false
      end;
      if (FiltOnlyClosedJobs in qtp.RecFilt.Options) then
      begin
        if p_sc.GetFldValue(id, CSC_Closed, FieldVal, dataType) then
          if not FieldVal then
             Result := false;
      end
      else
      begin
        if not (FiltClosedJobs in qtp.RecFilt.Options) then
          if p_sc.GetFldValue(id, CSC_Closed, FieldVal, dataType) then
          begin
            if FieldVal then
              Result := false;
          end;
      end;
    end
  end
  else
  begin
    if (p_pl.p_AllWrkCtr = nil) then exit;
    if WcProcAllowedList.Count = 0 then
    begin
      FromWCCode := '';
      ToWCCode := '';
      if (FiltWkcr in qtp.RecFilt.Options) then FromWCCode := qtp.RecFilt.wkCtrCode;
      if (FiltWkcrTo in qtp.RecFilt.Options) then ToWCCode := qtp.RecFilt.wkCtrCodeTo;
      if (FiltWkcr_Active in qtp.RecFilt.Options) or (FromWCCode <> '') or (ToWCCode <> '') then
      begin
        Alternatives := false;
        if (FiltWkcrAlterntiv in qtp.RecFilt.Options) then Alternatives := true;
        if (FiltWkcr_Active in qtp.RecFilt.Options) then
          BuildAllowedWCProcessList(binPan.p_GetListWCPlan, WcProcAllowedList, FromWCCode, ToWCCode, Alternatives)
        else
          BuildAllowedWCProcessList(p_pl.p_AllWrkCtr, WcProcAllowedList, FromWCCode, ToWCCode, Alternatives);
        if WcProcAllowedList.Count = 0 then exit;
      end;
    end;
    Result := qtp.TestFilterOpts(id, WcProcAllowedList);
  end;
end;

// -------------------------------------------------------------------------- //

procedure TFBin.CreateSearchTabFromGantt(Id : TSchedId; BinColId : CBinColId);
var
  tab, TabActive : TBinTabSheet;
  BinGrid : TBinDrawGrid;
  I : Integer;
  ParmsFilt : TBinParms;
  Value: Variant;
  dataType: CBinColValType;
  Cfg : TBinTabCfg;
  Title : string;
begin
  tab := TBinTabSheet(m_pgcBin.ActivePage);
  TabActive := TBinTabSheet(m_pgcBin.ActivePage);
  BinGrid := tab.GetBinGrid;
  if Assigned(tab) then
  begin
    ParmsFilt := TBinParms.Create;
    p_sc.GetFldValue(Id, BinColId, Value, dataType);
    Title := '';
    ParmsFilt.RecFilt.Options := [];
    ClearFilterParams(ParmsFilt.RecFilt.Options , ParmsFilt, Tb_Search);
    Include(ParmsFilt.RecFilt.Options, FiltWkcrAlterntiv);
    Include(ParmsFilt.RecFilt.Options, FiltOnlySchedJobs);

    if SetFilterParams(BinColId, Value, dataType, false, 0,ParmsFilt, Title, binGrid) then
    begin
      if (dataType = CBT_string) then
         Title := value
      else if (dataType = CBT_integer) then
         Title := IntToStr(value)
      else if (dataType = CBT_float) then
         Title := FloatToStr(value)
      else if (dataType = CBT_date) then
         Title := DateToStr(value);

      tab := SearchTabOpened;
      if tab = nil then
      begin
        Cfg := m_TbCfg.AddNewTab(Title, m_TbCfg.FindNewCode, false, false);
        tab := TBinTabSheet.CreateBinTbs(m_pgcBin, PopUpBin, p_sc,
                           BT_Main, FncFilterStep, ParmsFilt, true, Cfg.code, true);
        CopyBinDefaultTabSearch(tab.m_BinPanel.p_Grid.BinColumnSet);
        tab.p_SearchTab := true;
        tab.SetSearchIconForTab;
        tab.SetCode(Cfg.code);
        tab.m_BinPanel.GetFiltParms.P_OverriddenTab := false;
        tab.TabVisible := true;
        tab.Caption    := Title
      end
      else
      begin
        Cfg := TBinTabCfg(m_TbCfg.FindTab(tab.GetCode));
        Cfg.ParmFilt.ClearPropRecFields;
        tab.m_BinPanel.GetFiltParms.ClearFiltPropList;
        tab.m_BinPanel.SetParamFilter(ParmsFilt);
        p_pl.BinClientUpdateAll(tab.m_BinPanel, true)
      end;
      tab.Caption    := Title;
      SetSortIndex(tab.m_BinPanel, 0);
      m_pgcBin.ActivePage := tab;

      Cfg.ParmFilt := ParmsFilt;
      Cfg.SaveArrayBinCol(Tab.GetBinGrid.BinColumnSet);
      if Assigned(FMQMPlan) then
        OpenMqmDynamicPlanforSearch(value);
    end;
  end;
end;

// -------------------------------------------------------------------------- //

procedure TFBin.AutoSequencingReScheduleMcmJobs(OnStart : boolean);
var
  ObjList : TMSchedList;
  I : Integer;
  MCMlinkInfo : PTSQMCMlinkInfo;
begin
  if not assigned(AutoSchedCfg.m_McmListOfRescheduledId) then exit;
  if not AutoSchedCfg.m_McmRescheduledJobs then exit;
  if m_pgcBin.PageCount < 1 then Exit;

  AutoSchedCfg.m_OverridingParams_Activated := false;
  if OnStart then
     AutoSchedCfg.m_McmRescheduledJobsAutoOnStart := true;

  ObjList := TMSchedList.Create(self);
  AutoSchedCfg.m_McmListOfRescheduledId.Sort(SortMcmReschededIds);
  for I := 0 to AutoSchedCfg.m_McmListOfRescheduledId.Count - 1 do
    ObjList.AddLink(PTSQMCMlinkInfo(AutoSchedCfg.m_McmListOfRescheduledId[I]).id);
  PrepareAutoSeqList(ObjList);

  for I := AutoSchedCfg.m_McmListOfRescheduledId.Count - 1 downto 0 do
    Dispose(PTSQMCMlinkInfo(AutoSchedCfg.m_McmListOfRescheduledId[I]));

  AutoSchedCfg.m_McmListOfRescheduledId.Free;
  AutoSchedCfg.m_McmListOfRescheduledId := nil;
  AutoSchedCfg.m_McmRescheduledJobs := false;
  AutoSchedCfg.m_McmRescheduledJobsAutoOnStart := false;
end;

// -------------------------------------------------------------------------- //

procedure TFBin.FormCreate(Sender: TObject);
var
  img: TImage;
  SavedRefreshBinByButton : boolean;
begin
  ScaleFormSize(Self, Screen.PixelsPerInch);
  TranslateComponent (self);
  LoadStatus;
  //font.Size := 8;
  TBTmpFin.Visible := false;
  TBModiGrp.Visible := false;
  TBAddToGroup.Visible := false;
  TBAutoGrouping.Visible := false;

  FBin := self;
  FToolBar := ToolBarBin;
  m_toolBarpopUp := false;
  PopUpBin.OwnerDraw := true;
  MatPopUp.OwnerDraw := true;
  m_GroupTypeCreate := CSM_Automatic;

  // create the bin page control
  m_pgcBin := TMViewPage.Create(self, Vt_bin);
  m_pgcBin.Align := alClient;

  img := TImage.Create(m_pgcBin);
  img.Picture := TPicture.Create;
  img.PopupMenu := PopUpBin;
  img.Parent := m_pgcBin;
  img.Align := alClient;

  img.Picture.LoadFromFile(LocAppGlobals.AppDir + LocAppGlobals.ImgDir + '\PageEmpty.jpg');
  img.Stretch := true;
  img.Visible := true;

  m_pgcBin.Images := GetPlanView.ImageList1;

  m_TbCfg := TBinTabsCfg.Create;

  SavedRefreshBinByButton := DBAppSettings.RefreshBinByButton;
  DBAppSettings.RefreshBinByButton := false;

  if m_TbCfg.LoadFromDatabase then
    ResetTabs(m_TbCfg);

  DBAppSettings.RefreshBinByButton := SavedRefreshBinByButton;
  m_pgcBin.OnChange := pgcMainChange;

  m_pgcBin.MultiLine := DBAppSettings.BinMultiLineTab;
  MIChangeWC.Visible := true;
  MIReturnWCOriginal.Visible := true;
  MiChangeWcOnlySelectedJob.Visible := true;

  SetBinMenuItems(GetMouseSchedObj(false));

  if DBAppSettings.ShowBinToolBar then
    ToolBarBin.Visible := true
   else
     ToolBarBin.Visible := false;

  m_TransTabInsert      := CreateTransaction(Cfg_DB);

  m_qryTabInsertFilter     := CreateQuery(Cfg_DB);
  m_qryTabInsertFilter.Transaction := m_TransTabInsert;

  m_qryTabInsertColumnsCfg := CreateQuery(Cfg_DB);
  m_qryTabInsertColumnsCfg.Transaction := m_TransTabInsert;

  m_qryTabInsertFilterMaterial := CreateQuery(Cfg_DB);
  m_qryTabInsertFilterMaterial.Transaction := m_TransTabInsert;

  m_qryTabDelete        := CreateQuery(Cfg_DB);
  m_qryTabDelete.Transaction := m_TransTabInsert;

  SetDynamicSubMenuForSearchProperty;
  BuildQryForInsertTab;
{$ifdef ARO}
  MIDftValProdReq.Visible := false;
{$endif}

  MiAssignedBooleanProp1.Visible := false;

  if DBAppSettings.GenericPlanExist then
    MIAutoSchedPlusGeneric.Visible := true
  else
    MIAutoSchedPlusGeneric.Visible := false;
  m_BinPopupList := TStringList.Create;
end;

// -------------------------------------------------------------------------- //

procedure TFBin.SearchndFocuseClick(Sender: TObject);
var
  SearchFocuseForm : TSearchAndFocuse;
  StrSearch : string;
  tbs : TBinTabSheet;
  I : Integer;
  Id : TschedId;
  FieldVal : variant;
  dataType: CBinColValType;
  found : boolean;
begin
  found := false;
  SearchFocuseForm := TSearchAndFocuse.CreateSearchFocuse(self);
  if SearchFocuseForm.ShowModal = mrOk then
  begin
    StrSearch := SearchFocuseForm.GetStringForSearch;
    tbs := TBinTabSheet(m_pgcBin.ActivePage);
    if Assigned(tbs) then
    begin
      for i := 0 to tbs.m_BinPanel.m_objList.GetLinkCount-1 do
      begin
        Id := tbs.m_BinPanel.m_objList.GetLink(i);
        p_sc.GetFldValue(Id, CSC_ProdReq, FieldVal, dataType);
        if (StrSearch = FieldVal) then
        begin
          found := true;
          Fbin.FocusBinOnJobID(id, False);
          break;
        end;
      end;
      if not found then
        showmessage(_('Production request can not be found'));
    end;
  end;
end;

// -------------------------------------------------------------------------- //

function TFBin.SearchTabOpened : TBinTabSheet;
var
  I : Integer;
  tbs : TBinTabSheet;
begin
  Result := nil;
  if m_TbCfg.p_GetTabsCount = 0 then
    exit;
  for I := (m_TbCfg.p_GetTabsCount - 1) downto 0 do
  begin
    tbs := TBinTabSheet(GetTabByCode(m_TbCfg.GetTab(i).code));
    if Assigned(tbs) and tbs.p_SearchTab then
    begin
      Result := tbs;
      Exit
    end;
  end;
end;

// -------------------------------------------------------------------------- //

function TFBin.SlotFilterByDatesTabOpened : TBinTabSheet;
var
  I : Integer;
  tbs : TBinTabSheet;
begin
  Result := nil;
  if m_TbCfg.p_GetTabsCount = 0 then
    exit;
  for I := (m_TbCfg.p_GetTabsCount - 1) downto 0 do
  begin
    tbs := TBinTabSheet(GetTabByCode(m_TbCfg.GetTab(i).code));
    if Assigned(tbs) and tbs.p_SlotFilterByDatesTab then
    begin
      Result := tbs;
      Exit
    end;
  end;
end;

// -------------------------------------------------------------------------- //

function TFBin.SequenceTabOpened : TBinTabSheet;
var
  I : Integer;
  tbs : TBinTabSheet;
begin
  Result := nil;
  if m_TbCfg.p_GetTabsCount = 0 then
    exit;
  for I := (m_TbCfg.p_GetTabsCount - 1) downto 0 do
  begin
    tbs := TBinTabSheet(GetTabByCode(m_TbCfg.GetTab(i).code));
    if Assigned(tbs) and tbs.P_JobScheduleBySequenceTab then
    begin
      Result := tbs;
      Exit
    end;
  end;
end;

// -------------------------------------------------------------------------- //

function TFBin.AutoSequenceResultsTabOpend : TBinTabSheet;
var
  I : Integer;
  tbs : TBinTabSheet;
begin
  Result := nil;
  if m_TbCfg.p_GetTabsCount = 0 then
    exit;
  for I := (m_TbCfg.p_GetTabsCount - 1) downto 0 do
  begin
    tbs := TBinTabSheet(GetTabByCode(m_TbCfg.GetTab(i).code));
    if Assigned(tbs) and tbs.p_AutoSequenceResultsTab then
    begin
      Result := tbs;
      Exit
    end;
  end;
end;

// -------------------------------------------------------------------------- //

function TFBin.WarpCompatibleTabForJobIsOpend : TBinTabSheet;
var
  I : Integer;
  tbs : TBinTabSheet;
begin
  Result := nil;
  if m_TbCfg.p_GetTabsCount = 0 then
    exit;
  for I := (m_TbCfg.p_GetTabsCount - 1) downto 0 do
  begin
    tbs := TBinTabSheet(GetTabByCode(m_TbCfg.GetTab(i).code));
    if Assigned(tbs) and tbs.P_JobWarpCampatible then
    begin
      Result := tbs;
      Exit
    end;
  end;
end;

//-------------------------------------------------------------------------- //

function TFBin.WarpCompatibleTabIsOpend : TBinTabSheet;
var
  I : Integer;
  tbs : TBinTabSheet;
begin
  Result := nil;
  if m_TbCfg.p_GetTabsCount = 0 then
    exit;
  for I := (m_TbCfg.p_GetTabsCount - 1) downto 0 do
  begin
    tbs := TBinTabSheet(GetTabByCode(m_TbCfg.GetTab(i).code));
    if Assigned(tbs) and tbs.P_WarpCampatible then
    begin
      Result := tbs;
      Exit
    end;
  end;
end;

// -------------------------------------------------------------------------- //

procedure TFBin.MIMoveOnPlanClick(Sender: TObject);
begin
  BinDblClick(Sender);
end;

// -------------------------------------------------------------------------- //

{function TFBin.SetPopUpGroupedByMenueItems : boolean;
var
  I, J, K : Integer;
  MenuItem : TMenuItem;
begin
  MiCreateTabForGroupByDetails.visible := true;
  MiCreateTabForGroupByDetailsKeepFilter.Visible := true;
//  MiSearchBySelectedCellInGroupedBy.Visible := true;

//  MISearchBy.Visible := false;

  MIDftValProdReq.Visible := false;
  MICopyCnfg.Visible := false;
  MICreateBinUsingCurentCell.Visible := false;
  MiSearchBySelectedCell.Visible := false;
  MIGroupedBy.Visible := false;
  MiOverrideExistingTab.Visible := false;

{

  for I := 0 to POpUpBin.Items.Count - 1 do
  begin
    if (POpUpBin.Items[I].Name = 'MIBinTab') then
    begin
      MenuItem := POpUpBin.Items[I];
      for J := 0 to MenuItem.Count - 1 do
      begin
        if (MenuItem.Items[J].Name <> 'MINewTab') and
           (MenuItem.Items[J].Name <> 'EditTab') and
           (MenuItem.Items[J].Name <> 'MiBinCong') and
           (MenuItem.Items[J].Name <> 'MIClose') and
           (MenuItem.Items[J].Name <> 'MIGroupedBy') then
          MenuItem.Items[J].Enabled := false
        else
          MenuItem.Items[J].Enabled := true;
      end;
    end
    else
    begin
      if (POpUpBin.Items[I].Name = 'MINewTabMain') then
      begin
        MenuItem := POpUpBin.Items[I];
        for K := 0 to MenuItem.Count - 1 do
        begin
          if (MenuItem.Items[k].Name <> 'MINewTab') and
             (MenuItem.Items[k].Name <> 'MICopyCnfg') and
             (MenuItem.Items[k].Name <> 'MiCreateTabForGroupByDetails') and
             (MenuItem.Items[k].Name <> 'MiCreateTabForGroupByDetailsKeepFilter') then
            MenuItem.Items[k].Enabled := false
          else
            MenuItem.Items[k].Enabled := true;
        end;
      end
      else
        POpUpBin.Items[I].Enabled := false;
    end;
  end;
end;      }

// -------------------------------------------------------------------------- //

procedure TFBin.SetMcmMqmMenueItems;
begin

end;

// -------------------------------------------------------------------------- //

procedure TFBin.SetGroupedByPopup;
var
  tab : TBinTabSheet;
  I : integer;
begin
  tab := GetActiveView;
  if assigned(tab) then
  begin
    if tab.m_BinPanel.GetFiltParms.P_GroupedByCode <> '' then
    begin
      for I := 0 to PopUpBin.Items.Count - 1 do
         PopUpBin.Items[I].Visible := false;
      MICopy.Visible := true;
      MIBinTab.Visible := true;
      EditTab.Visible := true;
      MiBinCong.Visible := true;
      MIClose.Visible := true;
      MiDrillDown.Visible := true;



    {  MiRepositionJobsToRealMachines.Visible := false;
      MiSelectedJobOverridingParams.Visible := false;
      MIAutoSchedPlusGeneric.Visible := false;
      MIStartAutoSchedWcCfg.Visible := false;
      MIStartAutoSchedCurrentCfg.Visible := false;
      MIAutoSched.Visible := false;
      MIMoveOnPlan.Visible := false;
      MIShowOnPlan.Visible := false;
      MIJobHandling.Visible := false;
      MIUnschedule.Visible := false;
      MISetConfirmLevelTo.Visible := false;
      MIAutoGroupingSelection.Visible := false;
      MIWCenterHandle.Visible := false;
      MIJoinAll.Visible := false;
      MIShowtabtotals.Visible := false;
      MINewGroup.Visible := false;  }
    end;
  end;
end;

// -------------------------------------------------------------------------- //

procedure TFBin.PopUpMatPopup(Sender: TObject);
var
  tab : TBinTabSheet;
  I, Index : integer;
  job : TSchedId;
  PlanInfo :TSQplanInfo;
  ObjList : TMSchedList;
  SchedList : TMSchedList;
  Id : TSchedId;
  BinGrid : TBinDrawGridMat;
  act : TMqmActArea;
begin
  DMib.m_MainDB.Ping;
  tab := GetActiveView;
  if not Assigned(tab) then
    exit;
  BinGrid := tab.GetMatGrid;
  if not assigned(BinGrid) then exit;
  ID := TSchedID(TBinPanel(binGrid.Parent).m_ObjList.GetLink(binGrid.p_GetRow - 1));
  if ID = CSchedIDnull then exit;
  act := TMqmActArea(p_sc.GetExtLinkPtr_Material(ID));
  SchedList := BinGrid.GetSelectedList;
  // no need to be handled /// avi
  if SchedList.GetLinkCount = 0 then
  begin
    if not assigned(act) then
    begin
     // MiShowOnPlanMat.Visible := false;
     // MiMatUnschedule.Visible := false
    end
    else
    begin
     // MiShowOnPlanMat.Visible := true;
     // MiMatUnschedule.Visible := true;
    end;
  end;
end;

// -------------------------------------------------------------------------- //

Procedure TFBin.FormulaResultClick(Sender : TObject);
var NewItem : TMenuItem;
  FTotalViews : TFTotalViews;
  JobsInBinCount, g, i : Integer;
  tab : TBinTabSheet;
  ChildId, id : TSchedID;
  ObjList, RealList : TMSchedList;
  BinGrid : TBinDrawGrid;
  planInfo: TSQplanInfo;
  WC  : TMqmWrkCtr;
begin
  NewItem := TMenuItem(Sender);

  if PTTotalsView(NewItem.VCLComObject).Wkc_list.Count = 0 then
  begin
    MessageDlg('Select workcenter for this set!', mtError, [mbOk], 0);
    exit;
  end;

  if PTTotalsView(NewItem.VCLComObject).Group_list.Count = 0 then
  begin
    MessageDlg('Select group by for this set!', mtError, [mbOk], 0);
    exit;
  end;

  if PTTotalsView(NewItem.VCLComObject).Formula_list.Count = 0 then
  begin
    MessageDlg('Select formula for this set!', mtError, [mbOk], 0);
    exit;
  end;

  tab := GetActiveView;
  binGrid := tab.GetBinGrid;
  ObjList := TMSchedList.Create(self);

  if BinGrid.pSelectedMarked Or IsAutoRunMode then
    ObjList := BinGrid.GetSelectedList
  else
    ObjList.AddLink(GetMouseSchedObj(false));

  RealList := TMSchedList.Create(self);

  for i := 0 to ObjList.GetLinkCount - 1  do
  begin

    id := ObjList.GetLink(i);

    if id = CSchedIdNull then
      continue;

    p_sc.GetPlanInfo(id, planInfo);

    if planInfo.isGroup then
    begin
      for G := 0 to p_sc.GetGrpNumSons(Id) - 1 do
      begin
        ChildId := p_sc.GetGrpSon(Id, G);
        RealList.AddLink(ChildId)
      end;

    end else
    begin
      RealList.AddLink(id)
    end;

  end;

  id := tab.m_BinPanel.m_objList.GetLink(binGrid.row-1);

  if Assigned(NewItem) then
  begin
    try
      FTotalViews := TFTotalViews.CreateTotalView_Final(Self, RealList, PTTotalsView(NewItem.VCLComObject) ,'view', p_sc.GetFldDescr(Id, CSC_GroupNo, false));

      if FTotalViews.GetError <> '' then
      begin
        MessageDlg(FTotalViews.GetError, mtWarning, [mbok], 0);
      end else
      begin
        FTotalViews.Show;
        FTotalViews.formStyle := fsStayOnTop;
      end;

    finally
      //FTotalViews.free;
    end;
  end;

  RealList.Free;
end;

Procedure TFBin.SetFormulaResultitems(ObjList : TMSchedList);
var
  I, J, K, P, q , w : Integer;
  MenuItemI : TMenuItem;
  NewItem : TMenuItem;
  Found : boolean;
  FTotalViews : TFTotalViews;
  JobsInBinCount, g : Integer;
  tab : TBinTabSheet;
  ChildId, id : TSchedID;
//  ObjList : TMSchedList;
  BinGrid : TBinDrawGrid;
  planInfo: TSQplanInfo;
  WC  : TMqmWrkCtr;
begin

 { tab := GetActiveView;
  binGrid := tab.GetBinGrid;
  ObjList := BinGrid.GetSelectedList; }

  for I := 0 to PopUpBin.Items.Count - 1 do
  begin
    if (PopUpBin.Items[I].Name = 'MiFormularesult') then
    begin
      MenuItemI := PopUpBin.Items[I];

      if MenuItemI.Count > 0 then
        for p := MenuItemI.Count - 1 downto 0 do
          MenuItemI.Delete(p);

      MenuItemI.Visible := True;

      if GetTotalViews_List.Count = 0 then
      begin
        MenuItemI.Visible := False;
        exit;
      end;

      WC := nil;

      for P := 0 to GetTotalViews_List.Count - 1 do
      begin

        NewItem := TMenuItem.Create(Self);
        NewItem.VCLComObject := PTTotalsView(GetTotalViews_List[p]);
        NewItem.Caption := PTTotalsView(GetTotalViews_List[p]).set_name;
        NewItem.OnClick := FormulaResultClick;
        MenuItemI.add(NewItem);

        for k := 0 to ObjList.GetLinkCount - 1 do
        begin

          id := ObjList.GetLink(k);

          if id = CSchedIdNull then
            continue;

          p_sc.GetPlanInfo(id, planInfo);

          if planInfo.isGroup then
          begin

            for G := 0 to p_sc.GetGrpNumSons(Id) - 1 do
            begin
              ChildId := p_sc.GetGrpSon(Id, G);
              WC := TMqmWrkCtr(p_sc.GetWrkCtrPtr(ChildId));

              if Assigned(WC) then
                if PTTotalsView(GetTotalViews_List[p]).Wkc_list.IndexOf(WC) = -1 then
                begin
                  NewItem.Visible := False;
                  break;
                end;

            end;
          end else
          begin

             WC := TMqmWrkCtr(p_sc.GetWrkCtrPtr(Id));

            if Assigned(WC) then
              if PTTotalsView(GetTotalViews_List[p]).Wkc_list.IndexOf(WC) = -1 then
              begin
                NewItem.Visible := False;
                break;
              end;

          end;
        end;
      end;

      w := 0;

      for q := 0 to MenuItemI.Count - 1 do
      begin
        if MenuItemI.Items[q].Visible = false then
          inc(w);
      end;

      if w = MenuItemI.Count then
      begin
        MenuItemI.Visible := False;
        exit;
      end;

      if MenuItemI.Count = 0 then
      begin
        MenuItemI.Visible := False;
        exit;
      end;
    end;
  end;
end;


procedure TFBin.PopUpBinPopup(Sender: TObject);
var
  tab : TBinTabSheet;
  I, y, Index : integer;
  job : TSchedId;
  PlanInfo :TSQplanInfo;
  ObjList : TMSchedList;
  BinGrid : TBinDrawGrid;
begin
  DMib.m_MainDB.Ping;
  tab := GetActiveView;

  if not Assigned(tab) then
  begin
    SetBinMenuItems(GetMouseSchedObj(false));
    if not DBAppGlobals.IsWarpHandled then
      MIWarpTab.Visible := false;
    exit;
  end;

  if tab.m_BinPanel.GetFiltParms.P_MaterialSchedFilter then
  begin
   tab.GetMatGrid.PopupMenu := MatPopUp;
  { binGrid.MouseToCell(Mouse.CursorPos.X, Mouse.CursorPos.Y, GCol, GRow);
   if GCol > 8 then binGrid.Col := GCol;
    if GRow > 0 then binGrid.Row := GRow; }
   MatPopUp.Popup(Mouse.CursorPos.x, Mouse.CursorPos.y) ;
   exit;
  end else
  begin

    BinGrid := tab.GetBinGrid;
    if not Assigned(BinGrid) then exit;

    for I := 0 to PopUpBin.Items.Count - 1 do
    begin
      PopUpBin.Items[I].Visible := true;
      PopUpBin.Items[I].Enabled := true;
     // PopUpBin.Items[I].OnDrawItem := GetPlanView.DrawItemPopUp;
    end;

    if ((DBAppGlobals.MCM_App and not CheckIfActiveGanttTabIsMcm) or
       (not DBAppGlobals.MCM_App and CheckIfActiveGanttTabIsMcm)) and (IniAppGlobals.MCMasMQM = 0) then
    begin
      for I := 0 to PopUpBin.Items.Count - 1 do
        PopUpBin.Items[I].Visible := false;

      for I := 0 to PopUpBin.Items.Count - 1 do
        PopUpBin.Items[I].Enabled := false;

      job := GetMouseSchedObj(false);
      if (job <> CSchedIDnull) then
      begin
        p_sc.GetPlanInfo(Job, PlanInfo);
        if PlanInfo.isGroup then
        begin
          MIModiGrp.Visible := true;
          MIModiGrp.Enabled := true;
        end
        else
        begin
          MiJobDetails.Visible := true;
          MiJobDetails.Enabled := true;
        end;
      end;
      exit;
    end;


    MiDrillDown.Visible := false;

    job := GetMouseSchedObj(false);
    if (job <> CSchedIDnull) then
    begin
      p_sc.GetPlanInfo(Job, PlanInfo);
      if planInfo.VisibleInBin = CSB_ReadOnly then
      begin
        MiBalanceStep.Visible := false;
        MiBalanceStep.Enabled := false;
        MiBalanceImbalanceInBin.Visible := false;
        MiBalanceImbalanceInBin.Enabled := false;
        MIJoinAll.Visible := false;
        MIJoinAll.Enabled := false;
        MIUnschedule.Visible := false;
        MIUnschedule.Enabled := false;
        MIUnscheduleSelectedAndForwardLinkedJobs.Visible := false;
        MIUnscheduleSelectedAndForwardLinkedJobs.Enabled := false;
        MIAutoSched.Visible := false;
        MIAutoSched.Enabled := false;
        MiLastOnGantt.Visible := false;
        MiLastOnGantt.Enabled := false;
        MIAutoGroupingSelection.Visible := false;
        MIAutoGroupingSelection.Enabled := false;
        MIWCenterHandle.Visible := false;
        MIWCenterHandle.Enabled := false;
      end
      else
      begin
        MIAlterWorkCenterAndSplitAccordingToMcm.Visible := false;
        MiBalanceStep.Visible := true;
        MiBalanceStep.Enabled := true;
        MiBalanceImbalanceInBin.Visible := true;
        MiBalanceImbalanceInBin.Enabled := true;
        MINextLevel.Visible := true;
        MINextLevel.Enabled := true;
        MIUnschedule.Visible := true;
        MIUnschedule.Enabled := true;
        MIUnscheduleSelectedAndForwardLinkedJobs.Visible := true;
        MIUnscheduleSelectedAndForwardLinkedJobs.Enabled := true;

        MIAutoSched.Visible := true;
        MIAutoSched.Enabled := true;
        MiLastOnGantt.Visible := true;
        MiLastOnGantt.Enabled := true;
        MIAutoGroupingSelection.Visible := true;
        MIAutoGroupingSelection.Enabled := true;
        MIWCenterHandle.Visible := true;
        MIWCenterHandle.Enabled := true;

      end;
    end;

    if assigned(tab) then
    begin
      if tab.m_BinPanel.GetFiltParms.P_GroupedByCode <> '' then
      begin
        SetOverrideExistingTabForDrillDown;
        MiDrillDown.Visible := true;
      end;
    end;

    ObjList := TMSchedList.Create(self);
    if BinGrid.pSelectedMarked Or IsAutoRunMode then
    begin
      if IsAutoRunMode then
        ObjList := BinGrid.GetAllAsSelectedForAutoRun
      else
        ObjList := BinGrid.GetSelectedList
    end
    else
    begin
      ObjList.AddLink(GetMouseSchedObj(false));
      Index := tab.m_BinPanel.m_objList.IndexOf(GetMouseSchedObj(false));
      tab.m_BinPanel.p_Grid.ForceSelected(Index);
    end;

    MISplitJobsByStepNumberOfMachines.Visible := false;
    if CheckSplitBeforeSchedule(ObjList, true, nil, true) then
      MISplitJobsByStepNumberOfMachines.Visible := true;

    SetBinMenuItems(GetMouseSchedObj(false));

    if not DBAppGlobals.IsWarpHandled then
      MIWarpTab.Visible := false;

  end;

  if not DBAppGlobals.MCM_App then
  begin
    if GetBinPopupList.IndexOf('MiFormularesult') > -1 then
      SetFormulaResultitems(ObjList);

    for y := 0 to PopUpBin.Items.Count - 1 do
    begin
      if m_BinPopupList.IndexOf(TMenuItem(PopUpBin.Items[y]).Name) = -1  then
        PopUpBin.Items[y].Visible := false;
    end;

    if not PlanInfo.isGroup then
      MiFormularesult.Visible := False;
  end
  else
  begin
    MiCreateVersioning.Visible := False;
    MiFormularesult.Visible := False;
  end;

end;

// -------------------------------------------------------------------------- //

procedure TFBin.SetBinMenuItems(job: TSchedId);
var
  planInfo: TSQplanInfo;
//  SplitInfo: TSQSplitInfo;
  i, z:    integer;
  formOut: boolean;
  GroupingType : CGroupingType;
  FieldVal : variant;
  dataType: CBinColValType;
  CanGrouped : string;
  tab : TBinTabSheet;
  BinGrid : TBinDrawGrid;
  Desc : string;
  RealCfgCol : integer;
  UserReqSplitOnHost, MsgSplit : boolean;
  ShowBatchGroupLinesInBin : boolean;
  ObjList: TMSchedList;
  ShowContinueGroupLinesInBin : CScShowContinueGroupLinesInBin;
  AllAutoSchedCfgList : TStringList;
begin

 // PopUpBin.


//  MISearchBy.Visible    := true;
  MINextLevel.Visible   := true;
  MISetFin.Visible      := true;
  MISetConfirmLevelTo.Visible := true;
  MIJobHandling.Visible := true;
  MIShowrequirements.Visible := true;
  MIShowtabtotals.Visible := true;
  MIStartAutoSchedCurrentCfg.Visible := true;
  MiRepositionJobsToRealMachines.Visible := true;
  MiSelectedJobOverridingParams.Visible := true;
  MIStartAutoSchedWcCfg.Visible := true;


  MiJobDetails.Visible := true;
  MICopy.Visible := true;
  MiChangeWcOnlySelectedJob.Visible := true;
  MIAddToGroup.Visible := true;
  MIMsgJobHandle.Visible := true;
  MIPropPlannerdef.Visible := true;
  MiAssignedBooleanProp1.Visible := true;
  MINewGroup.Visible := true;
  MiCreateTabForGroupByDetailsKeepFilter.Visible := false;
  MiSearchBySelectedCellInGroupedBy.Visible := false;
  TBShowOnPlan.Enabled := true;

  if (job = CSchedIDnull) then
  begin
    TBShowOnPlan.Enabled := false;
    MiCreateVersioning.Visible  := false;
//    MIWCenterCngHandle.Visible := false;
    MICreateBinUsingCurentCell.Visible := false;
    MiSearchBySelectedCell.Visible := false;
    MINextLevel.Visible   := false;
    MISetFin.Visible      := false;
    MISetConfirmLevelTo.Visible := false;
    MIJobHandling.Visible := false;
    MIShowrequirements.Visible := false;
    MIShowtabtotals.Visible := false;
    MIStartAutoSchedCurrentCfg.Visible := false;
//    MiRepositionJobsToRealMachines.Visible := false;
    MiJobDetails.Visible := false;
    MICopy.Visible := false;
    MiChangeWcOnlySelectedJob.Visible := false;
    MIAddToGroup.Visible := false;
    MIMsgJobHandle.Visible := false;
    MIPropPlannerdef.Visible := false;
    MiAssignedBooleanProp1.Visible := false;
    MINewGroup.Visible := false;
    exit;
  end;

  GroupingType := p_sc.GetStepGroupType(job);

  p_sc.GetFldValue(job, CSC_StepGroupType, FieldVal, dataType);
  CanGrouped := FieldVal;

  MISplitOnHost.Visible := false;
  if p_sc.CanSplitOnHost(job, UserReqSplitOnHost, MsgSplit) then
  begin
    MISplitOnHost.Visible := true;
    if UserReqSplitOnHost then
      MISplitOnHost.Caption := _('Delete split on host')
    else
      MISplitOnHost.Caption :=  _('Split also on host');
  end;

  tab := TBinTabSheet(m_pgcBin.ActivePage);
  MICreateBinUsingCurentCell.Visible := true;
  MiSearchBySelectedCell.Visible := true;
  MiSearchBySelectedCellInGroupedBy.Visible := true;
  MICopy.Visible := true;
  BinGrid := tab.GetBinGrid;
 // if (BinGrid.GetButtonMouse(RealCfgCol) <> mbRight) and not m_toolBarpopUp then exit;
  BinGrid.SetRealCfgCol(RealCfgCol);
  if m_toolBarpopUp then Exit;

  BinGrid.ResetCfgCol;

  if Assigned(tab) and (goRowSelect in (BinGrid).Options) then
  begin
    MICreateBinUsingCurentCell.Visible := false;
    MiSearchBySelectedCell.Visible := false;
    MiSearchBySelectedCellInGroupedBy.Visible := false;
    MICopy.Visible := false
  end
  else
  begin

    if (RealCfgCol <> -1) and (RealCfgCol >= Low(binGrid.BinColumnSet)) and (RealCfgCol <= High(binGrid.BinColumnSet)) then
    if (Job <> CSchedIDnull) and (TBinPanel(binGrid.Parent).m_ObjList.GetLinkCount > 0) and SetFilterParams(binGrid.BinColumnSet[RealCfgCol].Field, '', dataType, true, RealCfgCol ,nil, Desc, binGrid) then
    begin
      Desc := p_sc.GetFldDescr(TSchedID(TBinPanel(binGrid.Parent).m_ObjList.GetLink(binGrid.p_GetRow - 1)), binGrid.BinColumnSet[RealCfgCol].Field, false);
      MICreateBinUsingCurentCell.Caption := _('Create bin for') + ' : ' + Desc;
    end
    else
      MICreateBinUsingCurentCell.Visible := false;


    MiSearchBySelectedCellInGroupedBy.Visible := false;
    MiSearchBySelectedCell.Visible := false;
    if RealCfgCol <> -1 then
    begin

      if (RealCfgCol >= Low(binGrid.BinColumnSet)) and (RealCfgCol <= High(binGrid.BinColumnSet)) then
      if (Job <> CSchedIDnull) and (p_sc.GetExtLinkPtr(Job) <> nil) and (TBinPanel(binGrid.Parent).m_ObjList.GetLinkCount > 0) and SetFilterParams(binGrid.BinColumnSet[RealCfgCol].Field, '', dataType, true, RealCfgCol ,nil, Desc, binGrid) then
      begin

        if DBAppGlobals.MCM_App then
        begin
          if not CheckIfBinColIdIsProp(binGrid.BinColumnSet[RealCfgCol].Field) then
             MiSearchBySelectedCell.Visible := false
          else
             MiSearchBySelectedCell.Visible := true;
        end
        else
          MiSearchBySelectedCell.Visible := true;
     //   Desc := p_sc.GetFldDescr(TSchedID(TBinPanel(binGrid.Parent).m_ObjList.GetLink(binGrid.p_GetRow - 1)), binGrid.BinColumnSet[RealCfgCol].Field, false);
     //   MICreateBinUsingCurentCell.Caption := _('Create bin for') + ' : ' + Desc;
        MiSearchBySelectedCellInGroupedBy.Visible := CheckGroupedByCodeFiledsForSearch(binGrid.BinColumnSet[RealCfgCol].Field);

      end
      else
      begin
      //  MICreateBinUsingCurentCell.Visible := false;
        MiSearchBySelectedCellInGroupedBy.Visible := false;
        MiSearchBySelectedCell.Visible := false
      end;
    end;
  end;

//  job := GetMouseSchedObj;
  if (job <> CSchedIdNull) and (p_sc.GetSchedObjStatus(job) = CSS_Del) then
  begin
    for I := 0 to PopUpBin.Items.Count -1 do
      PopUpBin.Items.Items[I].Enabled := false;
    MiJobDetails.Enabled := true;
 //   MISearchBy.Enabled := true;
    MIBinTab.Enabled := true;
    MiBinCong.Enabled := true;
    Exit;
  end;

// fp - ARO-ITM-10 - OLD
//  for I := 0 to PopUpBin.Items.Count -1 do
//    PopUpBin.Items.Items[I].Enabled := true;

  // fp - ARO-ITM-10 - NEW
  for I := 0 to PopUpBin.Items.Count -1 do
  begin
    PopUpBin.Items.Items[I].Enabled := true;
    for z := 0 to PopUpBin.Items.Items[I].Count -1 do
      PopUpBin.Items.Items[I].Items[z].Enabled := true;
  end;

//{$ifdef Customer}
//  MITest.Visible := false;
//{$endif}

  MIDftValProdReq.Enabled  := true;
  MICopyCnfg.Enabled  := true;
//  MIAutoSchedSelected.Enabled  := true; avi to check
  EditTab.Enabled  := true;
  MIClose.Enabled  := true;
  MIChangeWC.Enabled  := true;
  MIPropPlannerdef.Visible := IsAtLeastOnePropPlannerDefExists and CheckExistPropPlannerForID(Job);
  MiAssignedBooleanProp1.Visible := ExistAssignedBooleanProp1;
  MIReturnWCOriginal.Enabled  := true;
  MIShowTabTotals.Enabled := true;
  if (job <> CSchedIdNull) then
  begin
    MIClearAllMsgHost.Visible := false;
    if p_sc.IsMsgFromHostArrived(true,job) then
      MIClearAllMsgHost.Visible := true;
    MIClearJobHostMsg.Visible := false;
    if p_sc.IsMsgFromHostArrived(false,job) then
      MIClearJobHostMsg.Visible := true;
  end;

  if m_pgcBin.PageCount < 1 then
  begin
    for I := 0 to PopUpBin.Items.Count -1 do
      PopUpBin.Items.Items[I].Enabled := false;
    MIBinTab.Enabled := true;
    MIDftValProdReq.Enabled := false;
    MICopyCnfg.Enabled := false;
    EditTab.Enabled := false;
    MIClose.Enabled := false;
    MiBinCong.Enabled := false;
    MIShowTabTotals.Enabled := false;
    Exit
  end;

  // configure the popup according to
  // the current schedule obj selected

  formOut := IsGroupFormOut;

  if (job <> CSchedIdNull) then
  begin
    MISetConfirmLevelTo.Visible := false;

    MiConfInitial.Visible := false;
    MiConfFinal.Visible := false;
    MiConfLevel1.Visible := false;
    MiConfLevel2.Visible := false;
    MiConfLevel3.Visible := false;
    MiConfLevel4.Visible := false;
    MiConfLevel5.Visible := false;

    MIStockDetails.Visible   := false;

    MISetFin.Visible := false;
    MINextLevel.Visible := false;

    if (p_sc.GetSchedType(job) <> '2') then
    begin
      MISetFin.Caption := _('Set to final');
      MISetFin.ImageIndex := 15;
      TBTmpFin.ImageIndex := 15;
    end else
    begin
      MISetFin.Caption := _('Set to initial');
      MISetFin.ImageIndex := 23; //Missing
      TBTmpFin.ImageIndex := 23;
    end;

    if DBAppGlobals.ConfLevels > 0 then
    begin
      MISetConfirmLevelTo.Visible := true;
      if (p_sc.GetSchedType(job) <> '2') then
      begin
        MISetFin.Visible := true;
        MINextLevel.Visible  := true
      end
    end;

    if not BinGrid.pSelectedMarked then
    begin
      MiChangeWcOnlySelectedJob.Visible := false;
      MiChangeWcToAlljobsListedInCurrentBin.Visible := false;
     // MiCngPlanedWorkCenter.Visible := false;
     // MiReturnOriginalPlantWorkCenter.Visible := false
    end
    else
    begin
      ObjList := BinGrid.GetSelectedList;
      if ObjList.GetLinkCount = 1 then
      begin
        MiChangeWcToAlljobsListedInCurrentBin.Visible := false;
        MiChangeWcOnlySelectedJob.Visible := true;
      end
      else
      begin
        MiChangeWcToAlljobsListedInCurrentBin.Visible := true;
        MiChangeWcOnlySelectedJob.Visible := false;
      end;
  //    MiChangeWcOnlySelectedJob.Visible := false;
     // MiCngPlanedWorkCenter.Visible := false;
     // MiReturnOriginalPlantWorkCenter.Visible := false;
    end;

    if (DBAppGlobals.ConfLevels > 0) and ((p_sc.GetSchedType(job) <> '1') or BinGrid.pSelectedMarked) then
    begin
      MiConfInitial.Visible := true;
    end;

    if (DBAppGlobals.ConfLevels > 0) and ((p_sc.GetSchedType(job) <> '2') or BinGrid.pSelectedMarked) then
    begin
      MiConfFinal.Visible := true;
    end;

    if (DBAppGlobals.ConfLevels > 1) and ((p_sc.GetSchedType(job) <> '3') or BinGrid.pSelectedMarked) then
    begin
      MiConfLevel1.Visible := true;
    end;

    if (DBAppGlobals.ConfLevels > 2) and ((p_sc.GetSchedType(job) <> '4') or BinGrid.pSelectedMarked) then
    begin
      MiConfLevel2.Visible := true;
    end;

    if (DBAppGlobals.ConfLevels > 3) and ((p_sc.GetSchedType(job) <> '5') or BinGrid.pSelectedMarked) then
    begin
      MiConfLevel3.Visible := true;
    end;

    if (DBAppGlobals.ConfLevels > 4) and ((p_sc.GetSchedType(job) <> '6') or BinGrid.pSelectedMarked) then
    begin
      MiConfLevel4.Visible := true;
    end;

    if (DBAppGlobals.ConfLevels > 5) and ((p_sc.GetSchedType(job) <> '7') or BinGrid.pSelectedMarked) then
    begin
      MiConfLevel5.Visible := true;
    end;

    if (p_sc.GetSchedType(job) = '1') and (DBAppGlobals.ConfLevels > 1) then
      MINextLevel.Caption := _('Set to confirmation level 1')
    else if (p_sc.GetSchedType(job) = '3') and (DBAppGlobals.ConfLevels > 2) then
      MINextLevel.Caption := _('Set to confirmation level 2')
    else if (p_sc.GetSchedType(job) = '4') and (DBAppGlobals.ConfLevels > 3) then
      MINextLevel.Caption := _('Set to confirmation level 3')
    else if (p_sc.GetSchedType(job) = '5') and (DBAppGlobals.ConfLevels > 4) then
      MINextLevel.Caption := _('Set to confirmation level 4')
    else if (p_sc.GetSchedType(job) = '6') and (DBAppGlobals.ConfLevels > 5) then
      MINextLevel.Caption := _('Set to confirmation level 5')
    else
    begin
      MINextLevel.Caption := _('Set to final');
      MINextLevel.Visible := false
    end
  end;

  if (job <> CSchedIdNull)
  and (GetOccMoveForm = nil)
  and (GetCrtCapResForm = nil)
  and (GetDownTimeForm = nil) then
  begin

    MIMsgJobHandle.Visible := DBAppSettings.FixColJobMsgVis;
    p_sc.GetPlanInfo(job, planInfo);

    if (GetCalculatedHighDateProp <> nil) then
      MiRemoveJobsCalculatedLimitDates.Visible := true
    else
      MiRemoveJobsCalculatedLimitDates.Visible := false;

    if (CanUnGroupGroups and (planInfo.VisibleInBin = CSB_Normal)) then
    begin
      MINewGroup.Visible := true;
      MIAutoUnGroupingSelection.Visible := true
    end
    else
    begin
      MINewGroup.Visible := false;
      MIAutoUnGroupingSelection.Visible := false;
    end;

    if (planInfo.VisibleInBin <> CSB_Normal) then
    begin
      MISetFin.Visible := false;
      MINextLevel.Visible  := false
    end;


    if (CanGrouped <> '1') and (CanGrouped <> '3') then
    begin
      MIAutoGroupingSelection.Visible := false;
      MINewGroup.Visible := false
    end
    else
    begin
      if planInfo.VisibleInBin <> CSB_ReadOnly then
      begin
        MINewGroup.Visible := true;
        MIAutoGroupingSelection.Visible := true
      end;
    end;

    if planInfo.isOnPlan then
    begin
      MIShowOnPlan.Enabled := true;
      MiCreateVersioning.Visible := true;
      MISetFin.Enabled := true;
    end else
    begin
      MIShowOnPlan.Enabled := false;
      MiCreateVersioning.Visible := false;
      MISetFin.Enabled := false;
    end;

    if (p_sc.GetLearningCurveType(Job) <> CSC_Managed) then
      MiLearningCurveChange.Visible := false
    else
      MiLearningCurveChange.Visible := true;

    if MiLearningCurveChange.Visible then
    begin
      if p_sc.GetLearningCurveCode(Job) <> '' then
      begin
        MiRemoveCurveCode.Visible := true;
        MiChangingCurveCode.Caption := _('Change');
        MiChangingCurveCode.Visible := true;
      end
      else
      begin
        MiChangingCurveCode.Visible := true;
        MiChangingCurveCode.Caption := _('Link');
        MiRemoveCurveCode.Visible := false
      end;
    end;

    if planInfo.isGroup then
    begin
    //  MISearchBy.Enabled := false;
      MIDftValProdReq.Enabled := false;
     // MIChangeWC.Enabled := false;
      ShowGroupLinesInBin(ShowBatchGroupLinesInBin, ShowContinueGroupLinesInBin);
      if (ShowContinueGroupLinesInBin <> CsSCG_No) or ShowBatchGroupLinesInBin then
        MIPropPlannerdef.Visible := IsAtLeastOnePropPlannerDefExists and CheckExistPropPlannerForID(Job)
      else
        MIPropPlannerdef.Visible := false;
      MiAssignedBooleanProp1.Visible := ExistAssignedBooleanProp1;
    //  MiChangeWcOnlySelectedJob.Visible := false;
      if planInfo.ChangedWC then
      begin
        MIReturnWCOriginal.Enabled := true;
        MIChangeWC.Enabled := false
      end
      else
      begin
        MIReturnWCOriginal.Enabled := false;
        MIChangeWC.Enabled := true
      end;

    //  MIReturnWCOriginal.Enabled := false;

      if not planInfo.SplitAllow then
      begin
        MIJobHandling.Visible := false;
        TBJobHandling.enabled := false
      end;

     // MIAutoGroupingSelection.Enabled := false;

      if (planInfo.VisibleInBin = CSB_Normal) then
      begin
        MIMoveOnPlan.Enabled  := true;
        MIClose.Enabled       := true;
        MIJobHandling.Enabled := false;
        TBJobHandling.enabled := false;
        MiJobDetails.Enabled  := false;
        MINewGroup.Enabled    := false;
        MIShowrequirements.Enabled  := false;
        MIAddToGroup.Enabled  := false;
        MIModiGrp.Enabled     := true;
      //  if CanUnGroup(Job) then
      //    MIAutoUnGroupSelected.Enabled := true
      //  else
      //    MIAutoUnGroupSelected.Enabled := false;
        MIShowTabTotals.Enabled := true;
      end
      else if (planInfo.VisibleInBin = CSB_ReadOnly) then
      begin
        MIMoveOnPlan.Enabled  := false;
        MIClose.Enabled       := true;
        MIJobHandling.Enabled := false;
        TBJobHandling.Enabled := false;
        MiJobDetails.Enabled  := false;
        MINewGroup.Enabled    := false;
        MIShowrequirements.Enabled  := false;
        MIAddToGroup.Enabled  := false;
        MIModiGrp.Enabled     := true;
      //  if CanUnGroup(Job) then
      //    MIAutoUnGroupSelected.Enabled := true
      //  else
      //    MIAutoUnGroupSelected.Enabled := false;
        MIShowTabTotals.Enabled := false;
      end;

    end
    else if p_sc.GetGroup(job) <> CSchedIdNull then
    begin
      MIAutoGroupingSelection.Enabled := false;
      MIMoveOnPlan.Enabled  := true;
      MIClose.Enabled       := true;
      MiJobDetails.Enabled  := true;
      MINewGroup.Enabled    := false;
      MIAddToGroup.Enabled  := false;
      MIModiGrp.Enabled     := true;
    //  if CanUnGroup(Job) then
    //    MIAutoUnGroupSelected.Enabled := true
    //  else
    //    MIAutoUnGroupSelected.Enabled := false;
    end
    else
    begin
      if (planInfo.VisibleInBin = CSB_Normal) then
      begin

        if formOut then
        begin
          MIMoveOnPlan.Enabled  := false;
          MIClose.Enabled       := false;
          MIAddToGroup.Enabled  := true;
          MINewGroup.Enabled    := false;
          MIModiGrp.Enabled     := false;
       //   MIAutoUnGroupSelected.Enabled := false;
          EditTab.Enabled       := false;
          MIJobHandling.Enabled := false;
          TBJobHandling.Enabled := false;
          MiBinCong.Enabled := false
        end
        else
        begin
          MIMoveOnPlan.Enabled  := true;
          MIClose.Enabled       := true;
          MiBinCong.Enabled     := true;

          if planInfo.isOnPlan then
            MIWCenterHandle.Visible := false
          else
            MIWCenterHandle.Visible := true;

          if not planInfo.SplitAllow then
          begin
            MIJobHandling.Visible := false;
            TBJobHandling.Enabled := false
          end;

          if planInfo.ChangedWC then
          begin
            MIReturnWCOriginal.Enabled := true;
            MIChangeWC.Enabled := false
          end
          else
          begin
            MIReturnWCOriginal.Enabled := false;
            MIChangeWC.Enabled := true
          end;

          MiBalanceStep.Visible := false;

          if ((p_sc.GetSchedObjStatus(Job) = CSS_From_PG) or (p_sc.CheckSchedSumQty(Job))) then
             MiBalanceStep.Visible := true;

          if not MiBalanceStep.Visible and (Job <> CSchedIdNull) and (p_sc.GetJobNumBrothers(Job) > 1) then
             MiBalanceStep.Visible := true;

          MiBalanceImbalanceInBin.Visible := false;

          if CheckSchedSumQtyToAll then
             MiBalanceImbalanceInBin.Visible := true;

          // fp - ARO-ITM-10
         // if planInfo.isOnPlan then
         //   MIAutoGroupSelected.Enabled := false;

          if planInfo.isOnPlan then
            MINewGroup.Enabled := false
          else
            MINewGroup.Enabled    := not formOut;
          MIAddToGroup.Enabled  := formOut;
          MIModiGrp.Enabled     := false;

          if ((GroupingType = No_grp) or (GroupingType = FromOtherStep_grp)) then
            MINewGroup.Enabled     := false;

         { if (GroupingType <> Single_grp) then
            MIAutoGroupSelected.Enabled     := false
          else
            MIAutoGroupSelected.Enabled     := true;  }

        //  MIAutoUnGroupSelected.Enabled := false
        end
      end
      else if (planInfo.VisibleInBin = CSB_ReadOnly) then
      begin
        MISetConfirmLevelTo.Enabled := false;
        MIMoveOnPlan.Enabled  := false;
        MIJobHandling.Enabled := false;
        TBJobHandling.Enabled := false;
       // MIMoveToBin.Enabled   := false;
        MiJobDetails.Enabled  := true;
        MIModiGrp.Enabled     := false;
     //   MIAutoUnGroupSelected.Enabled := false;
        MINewGroup.Enabled    := false;
        MIAddToGroup.Enabled  := false;
      //  MIAutoSchedSelected.Enabled  := false;  avi to check
        MiChangeWcOnlySelectedJob.Visible := false;
        MIReturnWCOriginal.Enabled := false;
        MIChangeWC.Enabled := false;
        MIPropPlannerdef.Visible := false;
        MiAssignedBooleanProp1.Visible := false;
        MIClose.Enabled       := true;
        MIShowTabTotals.Enabled := true;
      end;
    end

  end else
  begin
    for I := 0 to PopUpBin.Items.Count -1 do
      PopUpBin.Items.Items[I].Enabled := false;
    MIClose.Enabled       := true;
    MIBinTab.Enabled      := true;
    MIDftValProdReq.Enabled  := false;
    MIShowTabTotals.Enabled  := false;
    MICopyCnfg.Enabled    := true;
    MiBinCong.Enabled     := true;
    EditTab.Enabled       := true;
  end;

{  if not SearchTabOpened then
    MISearchResult.Enabled := false
  else
    MISearchResult.Enabled := true;  }

  if not planInfo.isGroup and DBAppGlobals.StockDetailsHandled then
     MIStockDetails.Visible   := true;

//  MIAutoSchedSelected.Enabled := true; avi to check
  p_sc.GetFldValue(Job, CSC_Closed, FieldVal, dataType);
  if FieldVal then
 //   MIAutoSchedSelected.Enabled := false;

  if (CProgress(p_sc.IsProgressed(Job)) <> prg_none) then // avi to check
 //   MIAutoSchedSelected.Enabled := false;

  //MIStartAutoSchedCurrentCfg.Enabled := true;

  if GetPlanView.IsDynamicPlanActiv or DBAppGlobals.MAINPLAN_Ignore_Save_Event then
  begin
    MIStartAutoSchedCurrentCfg.Enabled := false;
    MiRepositionJobsToRealMachines.Visible := false;
    MIStartAutoSchedWcCfg.Enabled := false;
    MIAutoSchedPlusGeneric.Enabled := false;
    MiSelectedJobOverridingParams.Enabled := false
  end;

  for i := 0 to ToolBarBin.ButtonCount-1 do
  begin
    if Assigned(ToolBarBin.Buttons[I].MenuItem) then
      ToolBarBin.Buttons[I].Enabled := ToolBarBin.Buttons[I].MenuItem.Enabled;
  end;

  MiAutoSeqBySelectedCfg.Visible := true;
  AllAutoSchedCfgList := GetAllAutoSchedCfgList;
  if AllAutoSchedCfgList.count > 1 then
    SetDynamicSubMenuForAutoSeqCfgList(AllAutoSchedCfgList)
  else
    MiAutoSeqBySelectedCfg.Visible := false;

  AllAutoSchedCfgList.free;

  if DBAppGlobals.MCM_App then
  begin
    MiLastOnGantt.Visible := false;
    MiSeedChange.Visible := false;
 //   MiLearningCurveChange.Visible := false;
    MIMoveOnPlan.Visible := false;
    MIShowOnPlan.Visible := false;

    MIUnschedule.Visible := true;
    MIUnscheduleSelectedAndForwardLinkedJobs.Visible := true;
    MIJobHandling.Visible := true;

    MISetConfirmLevelTo.Visible := true;
    MIAutoGroupingSelection.Visible := true;
 //   MIWCenterHandle.Visible := true;
    MIJoinAll.Visible := true;
    MIShowtabtotals.Visible := true;
    MIJoinAll.Visible := true;

//    MIWCenterCngHandle.Visible := FALSE;

    MINewGroup.Visible := true;
//    MiChangeWcOnlySelectedJob.Visible := true;

    if (not CheckIfActiveGanttTabIsMcm) and (IniAppGlobals.MCMasMQM = 0) then
    begin

      MIMoveOnPlan.Visible := true;
      MIShowOnPlan.Visible := true;

      MIJobHandling.Visible := false;
      TBJobHandling.Enabled := false;
      MIUnschedule.Visible := false;
      MIUnscheduleSelectedAndForwardLinkedJobs.Visible := false;
      MINewGroup.Visible := false;
      MIJoinAll.Visible := false;
      MiSelectedJobOverridingParams.Visible := false;
      MIAutoSchedPlusGeneric.Visible := false;
      MIStartAutoSchedWcCfg.Visible := false;
      MIStartAutoSchedCurrentCfg.Visible := false;
      MiRepositionJobsToRealMachines.Visible := false;
    end;

    if DBAppGlobals.MCM_App and not CheckIfActiveGanttTabIsMcm and (IniAppGlobals.MCMasMQM = 1) then
    begin
      MiAutoSeqBySelectedCfg.Visible := false;
      MIStartAutoSchedWcCfg.Visible := false;
      MiSelectedJobOverridingParams.Visible := false;
      MiAutoSeqBySelectedCfg.Visible := true;
      MIMoveOnPlan.Visible := true;
      MIShowOnPlan.Visible := true;
      MIAutoSched.Visible := false;
      MiRepositionJobsToRealMachines.Visible := false
    end;

    SetGroupedByPopup;

    MiSearchBySelectedCellInGroupedBy.Visible := false;
    MiCreateTabForGroupByDetailsKeepFilter.Visible := false
  end
  else
  begin
    ObjList := BinGrid.GetSelectedList;
    MIAlterWorkCenterAndSplitAccordingToMcm.Visible := CheckActiveAlterWorkCenterAndSplitAccordingToMcm(ObjList);

    if planInfo.VisibleInBin = CSB_Normal then
      MiLastOnGantt.Visible := true;

    if p_sc.IsGroup(job)then
    begin
      if (not p_sc.CheckIfGroupChilderenContainSubSteps(job)) and (p_sc.GetJobType(job) = CST_Continuous) and (CProgress(p_sc.IsProgressed(job)) = prg_none) then
        MiSeedChange.Visible := true
      else
        MiSeedChange.Visible := false;
    end
    else
    begin
      if (p_sc.GetJobNumBrothers(job) = 1) and (p_sc.GetJobType(job) = CST_Continuous) and (CProgress(p_sc.IsProgressed(job)) = prg_none) then
        MiSeedChange.Visible := true
      else
        MiSeedChange.Visible := false;
    end;

    MiRepositionJobsToRealMachines.Visible := false;
    MiSelectedJobOverridingParams.Visible := false;
   // MIAutoSchedPlusGeneric.Visible := false;
    MIStartAutoSchedWcCfg.Visible := false;
    SetGroupedByPopup
  end;

  if MIStartAutoSchedCurrentCfg.Visible then
    MIStartAutoSchedCurrentCfg.Caption := AutoSchedCfg.m_CfgName

end;

//----------------------------------------------------------------------------//

function TFBin.FillSelectedAutoSeqListCfg : TStringlist;
begin
  Result := TStringlist.Create;
end;

//----------------------------------------------------------------------------//

procedure TFBin.pgcMainChange(Sender: TObject);
var
  tab : TBinTabSheet;
begin
  tab := TBinTabSheet(m_pgcBin.ActivePage);
  if Assigned(tab) then
  begin
    DeActivateRefreshButton;
    tab.m_BinPanel.UpdateForChangeFilter;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFBin.MICloseClick(Sender: TObject);
var
  tab : TBinTabSheet;
  Cfg : TBinTabCfg;
  i : Integer;
begin
  tab := TBinTabSheet(m_pgcBin.ActivePage);

  if FMQMPlan.m_ListAutoRunSetInfo.Count > 0 then
  begin
    for i := 0 to FMQMPlan.m_ListAutoRunSetInfo.Count - 1 do
    begin
      if tab.Caption = PTUserDefRecord(FMQMPlan.m_ListAutoRunSetInfo[I]).ActiveBinTab then
      begin
        MessageDlg(_('You cannot delete tab, cause there is Auto Run definition set for it!'), mtError, [mbOk], 0);
        exit;
      end;
    end;
  end;

  if MessageDlg(_('Delete bin tab "' + Trim(tab.Caption) + '" ?'), mtWarning, [mbYes,mbNo], 0) in [mrYes] then
  begin
    if Assigned(tab) then tab.p_IsDeleted := true;
    Cfg := TBinTabCfg(m_tbCfg.FindTab(TBinTabSheet(GetActiveView).GetCode));

    if DBAppGlobals.m_ClientConnectionCriticalRepaired then
    begin
      m_TransTabInsert      := CreateTransaction(Cfg_DB);

      m_qryTabInsertFilter     := CreateQuery(Cfg_DB);
      m_qryTabInsertFilter.Transaction := m_TransTabInsert;

      m_qryTabInsertColumnsCfg := CreateQuery(Cfg_DB);
      m_qryTabInsertColumnsCfg.Transaction := m_TransTabInsert;

      m_qryTabInsertFilterMaterial := CreateQuery(Cfg_DB);
      m_qryTabInsertFilterMaterial.Transaction := m_TransTabInsert;

      m_qryTabDelete        := CreateQuery(Cfg_DB);
      m_qryTabDelete.Transaction := m_TransTabInsert;

      BuildQryForInsertTab;
    end;

    m_TransTabInsert.StartTransaction;

    if Assigned(Cfg.ParmFilt) and Cfg.ParmFilt.P_MaterialSchedFilter then
       Cfg.DeleteTab(m_qryTabDelete, Tb_MaterialSched)
    else
      Cfg.DeleteTab(m_qryTabDelete, Tb_Normal);

    m_TransTabInsert.Commit;
    Application.ProcessMessages;
    m_TbCfg.DeleteTab(TBinTabSheet(m_pgcBin.GetActiveView).GetCode);
    m_pgcBin.CloseActive;
   // m_pgcBin.ActivePageIndex := m_pgcBin.PageCount - 1;
    pgcMainChange(self);
    Application.ProcessMessages;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFBin.MiCngPlanedWorkCenterClick(Sender: TObject);
var
  Id : TSchedID;
  ChangeWc : TChangeWc;
begin
  Id := GetMouseSchedObj(false);
  ChangeWc := TChangeWc.CreateChangeWcForm(self,Id);
  if ChangeWc.ShowModal = mrOk then
    ChangeTabBinforChangeTabPlan;
  ChangeWc.free;
end;

//----------------------------------------------------------------------------//

procedure TFBin.ResetTabs(tbCfg: TBinTabsCfg);
var
  tbsNew: TBinTabSheet;
  I : Integer;
  ParmsFilt : TBinFilterParms;
  Cfg : TBinTabCfg;
begin

  for I := 0 to tbCfg.p_GetTabsCount - 1 do
  begin
    ParmsFilt := tbCfg.GetBinFilter(tbCfg.GetTab(i).code);

    if ParmsFilt.P_MaterialSchedFilter then
    begin
      tbsNew := TBinTabSheet.CreateMaterialTbs(m_pgcBin, MatPopUp, p_sc, BT_Main, FncFilterStep , ParmsFilt, false, 10, true);
      Cfg := TBinTabCfg(m_tbCfg.FindTab(tbCfg.GetTab(i).code));
      tbsNew.Caption := Cfg.name;
      tbsNew.SetCode(Cfg.code);
    //  tbCfg.SaveArrayBinCol(Cfg.code , tbsNew.GetMatGrid.BinMatColumnSet);
      tbCfg.FillArrayBinColByCod(Cfg.code , tbsNew.GetMatGrid.BinMatColumnSet);
      tbsNew.UpdateList;
    end
    else
    begin
      tbsNew := TBinTabSheet.CreateBinTbs(m_pgcBin, PopUpBin, p_sc, BT_Main, FncFilterStep , ParmsFilt, false, 10, false);
      Cfg := TBinTabCfg(m_tbCfg.FindTab(tbCfg.GetTab(i).code));
      tbsNew.Caption := Cfg.name;
      tbsNew.SetCode(Cfg.code);
    //  tbCfg.SaveArrayBinCol(Cfg.code , tbsNew.GetBinGrid.BinColumnSet);
      tbCfg.FillArrayBinColByCod(Cfg.code , tbsNew.GetBinGrid.BinColumnSet);
      tbsNew.UpdateList;
    end;

  end;

end;

procedure TFBin.Returntosavedversion1Click(Sender: TObject);
var tab : TBinTabSheet;
  ChildId, id : TSchedID;
  ObjList : TMSchedList;
  BinGrid : TBinDrawGrid;
begin

  if MessageDlg('Do you want to return back saved version?', MtConfirmation, [mbYes, mbNo],0 ) = mrYes then
  begin
    tab := GetActiveView;
    binGrid := tab.GetBinGrid;
    ObjList := BinGrid.GetSelectedList;

    p_sc.SetOrigVersioningback(ObjList);
    tab.m_BinPanel.p_Grid.Refresh;
    if Assigned(ObjList) then
      ObjList.Free;
  end;
end;

//----------------------------------------------------------------------------//

function TFBin.GetCountSearch : integer;
var
  I : Integer;
  tbs : TBinTabSheet;
begin
  Result := 0;
  for I := (m_TbCfg.p_GetTabsCount - 1) downto 0 do
  begin
    tbs := TBinTabSheet(GetTabByCode(m_TbCfg.GetTab(i).code));
    if Assigned(tbs) and tbs.p_SearchTab then
    begin
      Result := Result + 1;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFBin.FormDestroy(Sender: TObject);
begin
  m_BinPopupList.Free;
  m_qryTabInsertFilter.Free;
  m_qryTabInsertColumnsCfg.Free;
  m_qryTabDelete.Free;
  m_TransTabInsert.Free;
//  m_TbCfg.Free;   // avi 10.09.2024 interloop invlid pointer when closing program
  m_qryTabInsertFilterMaterial.Free;
  FBin := nil;
end;

//----------------------------------------------------------------------------//

procedure TFBin.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  GetPlanView.CleanSBar;
end;

//----------------------------------------------------------------------------//

procedure TFBin.OrganizeDefaultTabForNewPropSet;
begin
  OrganizeDefaultTabs;
  OrganizeBinMatDefaultTabs;
end;

//----------------------------------------------------------------------------//

procedure TFBin.UpdateDbForNewPropSetDefaultTab;
begin
  SaveDefaultTabBinSet;
  SaveDefaultTabSlotFilter;
  SaveDefaultTabSearch;
  SaveDefaultTabAutoSeqResults;
  SaveDefaultTabJobSchedSequence;
end;

//----------------------------------------------------------------------------//

procedure TFBin.OrganizeTabsForNewPropSet;
var
  II : Integer;
  tbs : TBinTabSheet;
begin

  if m_TbCfg.p_GetTabsCount = 0 then
    exit;

  for II := (m_tbCfg.p_GetTabsCount - 1) downto 0 do
  begin
    tbs := TBinTabSheet(GetTabByCode(m_tbCfg.GetTab(II).code));
    if Assigned(tbs) then
    begin
      if tbs.m_BinPanel.GetFiltParms.P_MaterialSchedFilter then
        OrganizePosOerForTabsMat(tbs)
      else
        OrganizePosOerForTabs(tbs);
    end;
  end;

end;

//----------------------------------------------------------------------------//

procedure TFBin.UpdateDbForNewPropSet;
var
  II : Integer;
  tbs : TBinTabSheet;
  Cfg : TBinTabCfg;
begin
  if m_TbCfg.p_GetTabsCount = 0 then
    exit;
  for II := (m_tbCfg.p_GetTabsCount - 1) downto 0 do
  begin
    tbs := TBinTabSheet(GetTabByCode(m_tbCfg.GetTab(II).code));
    if Assigned(tbs) then
    begin
      Cfg := TBinTabCfg(m_TbCfg.FindTab(tbs.GetCode));
      if Cfg = nil then continue;

   //   Cfg.SaveArrayBinCol(TBinTabSheet(GetActiveView).GetBinGrid.BinColumnSet);
      if Cfg.ParmFilt.P_MaterialSchedFilter then
      begin
        Cfg.SaveArrayBinCol(tbs.GetMatGrid.BinMatColumnSet);
        m_TransTabInsert.StartTransaction;
        Cfg.SaveColumnsCfgTab(m_qryTabInsertColumnsCfg,m_qryTabDelete,Tb_MaterialSched);
      end
      else
      begin
        Cfg.SaveArrayBinCol(tbs.GetBinGrid.BinColumnSet);
        m_TransTabInsert.StartTransaction;
        Cfg.SaveColumnsCfgTab(m_qryTabInsertColumnsCfg,m_qryTabDelete,Tb_Normal);
      end;
      m_TransTabInsert.Commit;
    end;
  end;

end;

//----------------------------------------------------------------------------//

procedure TFBin.OrganizePosOerForTabs(var tbs : TBinTabSheet);
var
  I,J,K,PropPosition, Index : Integer;
  Low, Last, current, HighBinProp : Integer;
  Found : boolean;
  Temparray: array [0..high(DBAppGlobals.ShowBinPropArry)] of TBinColCurrent;
  PropListString : TStringList;
begin
  PropListString := TStringList.Create;
  Current := 0;
  Index := 0;
  PropPosition := GetNumberFields;
  Last := -1;

  // Find how many propertyes defined for the planner and keep each defined property in temporary //
  //**********************************************************************************************//
  K := 0;
  for I := 0 to high(DBAppGlobals.ShowBinPropArry) do
  begin
    //if (DBAppGlobals.ShowBinPropArry[I] = nil) then break;

    if I = 0 then
    begin
      if (DBAppGlobals.ShowBinPropArry[I] = nil) then
      begin
        for J := PropPosition to High(tbs.GetBinGrid.BinColumnSet) do
        begin
          tbs.GetBinGrid.BinColumnSet[J].PropCode := '';
        end;
        break;
      end
      else
        PropListString.Add(GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]));
    end
    else if (DBAppGlobals.ShowBinPropArry[I] = nil) then
    begin

      for J := PropPosition to High(tbs.GetBinGrid.BinColumnSet) do
      begin
        if PropListString.IndexOf(tbs.GetBinGrid.BinColumnSet[J].PropCode) = -1 then
           tbs.GetBinGrid.BinColumnSet[J].PropCode := '';
      end;
      break;

    end;
    ///////////////////////////

    Index := Index + 1;
    for J := PropPosition to High(tbs.GetBinGrid.BinColumnSet) do
    begin
      if tbs.GetBinGrid.BinColumnSet[J].PropCode <>
          GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]) then continue;
      Temparray[K].Title    := tbs.GetBinGrid.BinColumnSet[J].Title;
      Temparray[K].Pos      := tbs.GetBinGrid.BinColumnSet[J].Pos;
      Temparray[K].Width    := tbs.GetBinGrid.BinColumnSet[J].Width;
      Temparray[K].Visible  := tbs.GetBinGrid.BinColumnSet[J].Visible;
      Temparray[K].Order    := tbs.GetBinGrid.BinColumnSet[J].Order;
      Temparray[K].PropCode := tbs.GetBinGrid.BinColumnSet[J].PropCode;
      K := K + 1;
      break;
    end;
  end;

  // Loop on all defined properties, and, enter them to bin. If defined before, restore values //
  //*******************************************************************************************//
  PropPosition := GetNumberFields;
  for I := 0 to high(DBAppGlobals.ShowBinPropArry) do
  begin
    if (DBAppGlobals.ShowBinPropArry[I] = nil) then break;

    K := I + PropPosition;
    Found := False;

    // Search if the property was kept before //
    for J := 0 to high(DBAppGlobals.ShowBinPropArry) do
    begin
      if Temparray[J].PropCode <> GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]) then continue;
      Found := True;
      break;
    end;

    tbs.GetBinGrid.BinColumnSet[K].PropCode := GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]);

    if found then
    begin
      tbs.GetBinGrid.BinColumnSet[K].Title    := Temparray[J].Title;
      tbs.GetBinGrid.BinColumnSet[K].Pos      := Temparray[J].Pos;
      tbs.GetBinGrid.BinColumnSet[K].Width    := Temparray[J].Width;
      tbs.GetBinGrid.BinColumnSet[K].Visible  := Temparray[J].Visible;
      tbs.GetBinGrid.BinColumnSet[K].Order    := Temparray[J].Order;
    end
    else
    begin
      tbs.GetBinGrid.BinColumnSet[K].Title    := '';
      tbs.GetBinGrid.BinColumnSet[K].Pos      := 998;
      tbs.GetBinGrid.BinColumnSet[K].Width    := 80;
      tbs.GetBinGrid.BinColumnSet[K].Visible  := true;
      tbs.GetBinGrid.BinColumnSet[K].Order    := 998;
    end;
  end;

  HighBinProp := Index;
  PropPosition := PropPosition + HighBinProp;


  // Compress the order values from 0 to ...///
  for I := 0 to PropPosition - 1 do
  begin
    Low := 999;
    for J := 0 to PropPosition - 1 do
    begin
      if (tbs.GetBinGrid.BinColumnSet[J].order > last) and (tbs.GetBinGrid.BinColumnSet[J].order < Low) then
      begin
        Current := J;
        Low := tbs.GetBinGrid.BinColumnSet[J].order;
       end;
    end;
    Last := tbs.GetBinGrid.BinColumnSet[Current].order;
    if last = 998 then last := 997;
    tbs.GetBinGrid.BinColumnSet[Current].order := I;
  end;

  // Complete the order for the remaining no-handled properties //
  for I := PropPosition to High(tbs.GetBinGrid.BinColumnSet) do
  begin
    tbs.GetBinGrid.BinColumnSet[I].order := I;
  end;

  Last := -1;
  Current := 0;

 // Compress the position values from 0 to ...///
  for I := 0 to PropPosition - 1 do
  begin
    Low := 999;
    for J := 0 to PropPosition - 1 do
    begin
      if (tbs.GetBinGrid.BinColumnSet[J].Pos > last) and (tbs.GetBinGrid.BinColumnSet[J].Pos < Low) then
      begin
        Current := J;
        Low := tbs.GetBinGrid.BinColumnSet[J].Pos;
      end;
    end;
    Last := tbs.GetBinGrid.BinColumnSet[Current].Pos;
    if last = 998 then last := 997;
    tbs.GetBinGrid.BinColumnSet[Current].Pos := I;
  end;

 // Complete the position for the remaining no-handled properties //
  for I := PropPosition to High(tbs.GetBinGrid.BinColumnSet) do
  begin
    tbs.GetBinGrid.BinColumnSet[I].Pos := I;
  end;

  PropPosition := GetNumberFields;
  // just be sure that all rest of properties are signed as false
  for I := PropPosition to high(tbs.GetBinGrid.BinColumnSet) do
  begin
    if not Assigned(DBAppGlobals.ShowBinPropArry[I-PropPosition]) then
    begin
      tbs.GetBinGrid.BinColumnSet[I].Visible := false;
      tbs.GetBinGrid.BinColumnSet[I].Title := Titletemp[I];
    end;
  end;

  tbs.GetBinGrid.SortRowBin;
  FBin.SetSortIndex(tbs.m_BinPanel, 0);
  PropListString.Free;
end;

//----------------------------------------------------------------------------//

procedure TFBin.OrganizePosOerForTabsMat(var tbs : TBinTabSheet);
var
  I,J,K,PropPosition, Index : Integer;
  Low, Last, current, HighBinProp : Integer;
  Found : boolean;
  Temparray: array [0..high(DBAppGlobals.ShowBinPropArry)] of TBinColCurrent;
  PropListString : TStringList;
begin
  PropListString := TStringList.Create;
  Current := 0;
  Index := 0;
  PropPosition := UMBinMatDefault.GetNumberFieldsMat;
  Last := -1;

  // Find how many propertyes defined for the planner and keep each defined property in temporary //
  //**********************************************************************************************//
  K := 0;
  for I := 0 to high(DBAppGlobals.ShowBinPropArry) do
  begin

    if I = 0 then
    begin
      if (DBAppGlobals.ShowBinPropArry[I] = nil) then
      begin
        for J := PropPosition to High(tbs.GetMatGrid.BinMatColumnSet) do
        begin
          tbs.GetMatGrid.BinMatColumnSet[J].PropCode := '';
        end;
        break;
      end
      else
        PropListString.Add(GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]));
    end
    else if (DBAppGlobals.ShowBinPropArry[I] = nil) then
    begin

      for J := PropPosition to High(tbs.GetMatGrid.BinMatColumnSet) do
      begin
        if PropListString.IndexOf(tbs.GetMatGrid.BinMatColumnSet[J].PropCode) = -1 then
           tbs.GetMatGrid.BinMatColumnSet[J].PropCode := '';
      end;
      break;

    end;
    ///////////////////////////

    Index := Index + 1;
    for J := PropPosition to High(tbs.GetMatGrid.BinMatColumnSet) do
    begin
      if tbs.GetMatGrid.BinMatColumnSet[J].PropCode <>
          GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]) then continue;
      Temparray[K].Title    := tbs.GetMatGrid.BinMatColumnSet[J].Title;
      Temparray[K].Pos      := tbs.GetMatGrid.BinMatColumnSet[J].Pos;
      Temparray[K].Width    := tbs.GetMatGrid.BinMatColumnSet[J].Width;
      Temparray[K].Visible  := tbs.GetMatGrid.BinMatColumnSet[J].Visible;
      Temparray[K].Order    := tbs.GetMatGrid.BinMatColumnSet[J].Order;
      Temparray[K].PropCode := tbs.GetMatGrid.BinMatColumnSet[J].PropCode;
      K := K + 1;
      break;
    end;
  end;

  // Loop on all defined properties, and, enter them to bin. If defined before, restore values //
  //*******************************************************************************************//
  PropPosition := UMBinMatDefault.GetNumberFieldsMat;
  for I := 0 to high(DBAppGlobals.ShowBinPropArry) do
  begin
    if (DBAppGlobals.ShowBinPropArry[I] = nil) then break;

    K := I + PropPosition;
    Found := False;

    // Search if the property was kept before //
    for J := 0 to high(DBAppGlobals.ShowBinPropArry) do
    begin
      if Temparray[J].PropCode <> GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]) then continue;
      Found := True;
      break;
    end;

    tbs.GetMatGrid.BinMatColumnSet[K].PropCode := GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]);

    if found then
    begin
      tbs.GetMatGrid.BinMatColumnSet[K].Title    := Temparray[J].Title;
      tbs.GetMatGrid.BinMatColumnSet[K].Pos      := Temparray[J].Pos;
      tbs.GetMatGrid.BinMatColumnSet[K].Width    := Temparray[J].Width;
      tbs.GetMatGrid.BinMatColumnSet[K].Visible  := Temparray[J].Visible;
      tbs.GetMatGrid.BinMatColumnSet[K].Order    := Temparray[J].Order;
    end
    else
    begin
      tbs.GetMatGrid.BinMatColumnSet[K].Title    := '';
      tbs.GetMatGrid.BinMatColumnSet[K].Pos      := 998;
      tbs.GetMatGrid.BinMatColumnSet[K].Width    := 80;
      tbs.GetMatGrid.BinMatColumnSet[K].Visible  := false;//true;
      tbs.GetMatGrid.BinMatColumnSet[K].Order    := 998;
    end;
  end;

  HighBinProp := Index;
  PropPosition := PropPosition + HighBinProp;


  // Compress the order values from 0 to ...///
  for I := 0 to PropPosition - 1 do
  begin
    Low := 999;
    for J := 0 to PropPosition - 1 do
    begin
      if (tbs.GetMatGrid.BinMatColumnSet[J].order > last) and (tbs.GetMatGrid.BinMatColumnSet[J].order < Low) then
      begin
        Current := J;
        Low := tbs.GetMatGrid.BinMatColumnSet[J].order;
       end;
    end;
    Last := tbs.GetMatGrid.BinMatColumnSet[Current].order;
    if last = 998 then last := 997;
    tbs.GetMatGrid.BinMatColumnSet[Current].order := I;
  end;

  // Complete the order for the remaining no-handled properties //
  for I := PropPosition to High(tbs.GetMatGrid.BinMatColumnSet) do
  begin
    tbs.GetMatGrid.BinMatColumnSet[I].order := I;
  end;

  Last := -1;
  Current := 0;

 // Compress the position values from 0 to ...///
  for I := 0 to PropPosition - 1 do
  begin
    Low := 999;
    for J := 0 to PropPosition - 1 do
    begin
      if (tbs.GetMatGrid.BinMatColumnSet[J].Pos > last) and (tbs.GetMatGrid.BinMatColumnSet[J].Pos < Low) then
      begin
        Current := J;
        Low := tbs.GetMatGrid.BinMatColumnSet[J].Pos;
      end;
    end;
    Last := tbs.GetMatGrid.BinMatColumnSet[Current].Pos;
    if last = 998 then last := 997;
    tbs.GetMatGrid.BinMatColumnSet[Current].Pos := I;
  end;

 // Complete the position for the remaining no-handled properties //
  for I := PropPosition to High(tbs.GetMatGrid.BinMatColumnSet) do
  begin
    tbs.GetMatGrid.BinMatColumnSet[I].Pos := I;
  end;

  PropPosition := UMBinMatDefault.GetNumberFieldsMat;
  // just be sure that all rest of properties are signed as false
  for I := PropPosition to high(tbs.GetMatGrid.BinMatColumnSet) do
  begin
    if not Assigned(DBAppGlobals.ShowBinPropArry[I-PropPosition]) then
    begin
      tbs.GetMatGrid.BinMatColumnSet[I].Visible := false;
      tbs.GetMatGrid.BinMatColumnSet[I].Title := TitleMatTemp[I];
    end;
  end;

  tbs.GetMatGrid.SortRowBin;
//  FBin.SetSortIndex(tbs.m_BinPanel, 0);
  PropListString.Free;
end;

//----------------------------------------------------------------------------//

procedure TFBin.AddPropCodeForPropColumTabs;
var
  II : Integer;
  tbs : TBinTabSheet;
  PropPosition, I , J: Integer;
begin
  // Work on Default tab
  if DBAppGlobals.ShowBinPropArry[0] = nil then exit;
  PropPosition := GetNumberFields;
  if (BinDefaultTabColumnSet[PropPosition].PropCode) <> '' then exit;

  J := 0;
  for I := PropPosition to High(BinDefaultTabColumnSet) do
  begin
    if DBAppGlobals.ShowBinPropArry[J] = nil then break;
    BinDefaultTabColumnSet[I].PropCode := GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[J]);
    BinDefaultTabColumnSet[I].Title    := '';
    J := J+ 1;
  end;

  if m_TbCfg.p_GetTabsCount = 0 then exit;

  for II := (m_tbCfg.p_GetTabsCount - 1) downto 0 do
  begin
    tbs := TBinTabSheet(GetTabByCode(m_tbCfg.GetTab(II).code));
    if Assigned(tbs) then AddPropCodeForPropColumTab(tbs);
  end;
end;

//----------------------------------------------------------------------------//

procedure TFBin.AddPropCodeForPropColumTab(var tbs : TBinTabSheet);
var
  PropPosition, I , J: Integer;
begin
  PropPosition := GetNumberFields;
  J := 0;
  for I := PropPosition to High(tbs.GetBinGrid.BinColumnSet) do
  begin
    if DBAppGlobals.ShowBinPropArry[J] = nil then break;
    tbs.GetBinGrid.BinColumnSet[I].PropCode := GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[J]);
    tbs.GetBinGrid.BinColumnSet[I].Title := '';
    J := J+ 1;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFBin.UdateTabsProp;
var
  I,J : Integer;
  tbs : TBinTabSheet;
  PropPosition : Integer;
begin
  PropPosition := GetNumberFields;

  for I := PropPosition to high(BinDefaultTabColumnSet) do
  begin
    if not Assigned(DBAppGlobals.ShowBinPropArry[I-PropPosition]) then
    begin
      BinDefaultTabColumnSet[I].Visible := false;
      BinDefaultTabColumnSet[I].Title := Titletemp[I];
    end
    else
    begin
      BinDefaultTabColumnSet[I].Visible := true;
    end;
  end;

  if m_TbCfg.p_GetTabsCount = 0 then
    exit;
  for I := (m_tbCfg.p_GetTabsCount - 1) downto 0 do
  begin
    tbs := TBinTabSheet(GetTabByCode(m_tbCfg.GetTab(i).code));
    for J := PropPosition to High(tbs.GetBinGrid.BinColumnSet) do
    begin
      if not Assigned(DBAppGlobals.ShowBinPropArry[J-PropPosition]) then
      begin
        tbs.GetBinGrid.BinColumnSet[J].Visible := false;
        tbs.GetBinGrid.BinColumnSet[J].Title := Titletemp[J];
      end
      else
      begin
        tbs.GetBinGrid.BinColumnSet[J].Visible := true;
      end;
    end;
    tbs.GetBinGrid.SortRowBin;
  end;

end;

//----------------------------------------------------------------------------//

function TFBin.GetTabByCode(TabCode : Integer) : TTabSheet;
var
  i:   integer;
  tbs: TBinTabSheet;
begin
  Result := nil;
  for i := (m_pgcBin.PageCount - 1) downto 0 do
  begin
    tbs := TBinTabSheet(m_pgcBin.Pages[i]);
    if tbs.GetCode = TabCode then
    begin
      Result := tbs;
      exit
    end
  end
end;

//----------------------------------------------------------------------------//

procedure TFBin.SetSortIndex(obj: TObject; NewIndex: Integer);
begin
  p_pl.BinSetSortIndex(obj, NewIndex)
end;

//----------------------------------------------------------------------------//

procedure TFBin.MiBinCongClick(Sender: TObject);
var
  Cfg : TBinTabCfg;
begin
  TFConfigBin.CreateCfgBin(Self, Tb_BinTab).ShowModal;
  Cfg := TBinTabCfg(m_TbCfg.FindTab(TBinTabSheet(GetActiveView).GetCode));

  if TBinTabSheet(GetActiveView).m_BinPanel.GetFiltParms.P_MaterialSchedFilter then
    Cfg.SaveArrayBinCol(TBinTabSheet(GetActiveView).GetMatGrid.BinMatColumnSet)
  else
    Cfg.SaveArrayBinCol(TBinTabSheet(GetActiveView).GetBinGrid.BinColumnSet);

  if DBAppGlobals.m_ClientConnectionCriticalRepaired then
  begin
    m_TransTabInsert      := CreateTransaction(Cfg_DB);

    m_qryTabInsertFilter     := CreateQuery(Cfg_DB);
    m_qryTabInsertFilter.Transaction := m_TransTabInsert;

    m_qryTabInsertColumnsCfg := CreateQuery(Cfg_DB);
    m_qryTabInsertColumnsCfg.Transaction := m_TransTabInsert;

    m_qryTabInsertFilterMaterial := CreateQuery(Cfg_DB);
    m_qryTabInsertFilterMaterial.Transaction := m_TransTabInsert;

    m_qryTabDelete        := CreateQuery(Cfg_DB);
    m_qryTabDelete.Transaction := m_TransTabInsert;

    BuildQryForInsertTab;
  end;

  m_TransTabInsert.StartTransaction;
  if TBinTabSheet(GetActiveView).m_BinPanel.GetFiltParms.P_MaterialSchedFilter then
  begin
    TBinTabSheet(GetActiveView).m_BinPanel.UpdateForChangeFilter;
    Cfg.SaveColumnsCfgTab(m_qryTabInsertColumnsCfg,m_qryTabDelete, Tb_MaterialSched)
  end
  else
    Cfg.SaveColumnsCfgTab(m_qryTabInsertColumnsCfg,m_qryTabDelete, Tb_Normal);

  m_TransTabInsert.Commit;
end;

//----------------------------------------------------------------------------//

procedure TFBin.EditTabClick(Sender: TObject);
var
  tbs : TBinTabSheet;
  BinFilter : TTBinFilter;
  BinFilterMaterial :TTBinFilterMaterial;
  Cfg : TBinTabCfg;
  SavedRefreshBinByButton : boolean;
begin
  tbs := TBinTabSheet(m_pgcBin.GetActiveView);
  if not assigned(tbs) then exit;

  if DBAppGlobals.m_ClientConnectionCriticalRepaired then
  begin
    m_TransTabInsert      := CreateTransaction(Cfg_DB);

    m_qryTabInsertFilter     := CreateQuery(Cfg_DB);
    m_qryTabInsertFilter.Transaction := m_TransTabInsert;

    m_qryTabInsertColumnsCfg := CreateQuery(Cfg_DB);
    m_qryTabInsertColumnsCfg.Transaction := m_TransTabInsert;

    m_qryTabInsertFilterMaterial := CreateQuery(Cfg_DB);
    m_qryTabInsertFilterMaterial.Transaction := m_TransTabInsert;

    m_qryTabDelete        := CreateQuery(Cfg_DB);
    m_qryTabDelete.Transaction := m_TransTabInsert;

    BuildQryForInsertTab;
  end;

  if tbs.m_BinPanel.GetFiltParms.P_MaterialSchedFilter then
  begin
    BinFilterMaterial := TTBinFilterMaterial.CreateMaterialBinFilter(Self, tbs.m_BinPanel.GetFiltParms,tbs.Caption, TabProp, CSchedIDnull, CSR_New);
    BinFilterMaterial.InitFilter;
    if BinFilterMaterial.ShowModal = mrOk then
    begin
      tbs.Caption := BinFilterMaterial.GetTabName;
      Cfg := TBinTabCfg(m_TbCfg.FindTab(tbs.GetCode));
      Cfg.name := tbs.Caption;

      tbs.m_BinPanel.UpdateForChangeFilter;

      Cfg.ParmFilt := tbs.m_BinPanel.GetFiltParms;
      m_TransTabInsert.StartTransaction;
      Cfg.SaveFiltersTab(m_qryTabInsertFilterMaterial, m_qryTabDelete);
      m_TransTabInsert.Commit;
    end;
  end
  else
  begin
    BinFilter := TTBinFilter.CreateBinFilter(Self, tbs.m_BinPanel.GetFiltParms, tbs.Caption, TabProp, CSchedIDnull, CSR_New);
    BinFilter.InitFilter;
    if BinFilter.ShowModal = mrOk then
    begin
      tbs.Caption := BinFilter.GetTabName;
      Cfg := TBinTabCfg(m_TbCfg.FindTab(tbs.GetCode));
      Cfg.name := tbs.Caption;

      SavedRefreshBinByButton := DBAppSettings.RefreshBinByButton;
      DBAppSettings.RefreshBinByButton := false;

      tbs.m_BinPanel.UpdateForChangeFilter;
      DBAppSettings.RefreshBinByButton := SavedRefreshBinByButton;

  {    if tbs.m_BinPanel.P_BinDynamicPlan then
        tbs.ImageIndex := -1
      else
        tbs.ImageIndex := 12; }

      Cfg.ParmFilt := tbs.m_BinPanel.GetFiltParms;

      if not tbs.P_WarpCampatible and not tbs.p_AutoSequenceResultsTab and
         not tbs.p_SlotFilterByDatesTab and not tbs.p_SearchTab and not tbs.P_JobScheduleBySequenceTab then
      begin
        m_TransTabInsert.StartTransaction;
        Cfg.SaveFiltersTab(m_qryTabInsertFilter, m_qryTabDelete);
        m_TransTabInsert.Commit;
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

function TFBin.GetGroupTypeCreate : CScGroupTypeCreate;
begin
  Result := m_GroupTypeCreate
end;

//----------------------------------------------------------------------------//

function TFBin.GetMouseSchedObj(IDAsIs : boolean) : TSchedId;
var
  tbs:  TBinTabSheet;
  grid: TBinDrawGrid;
  isGroup : boolean;
  IdGroup : TSchedId;
  ShowBatchGroupLinesInBin : boolean;
  ShowContinueGroupLinesInBin : CScShowContinueGroupLinesInBin;
begin
  Result := CSchedIdNull;
  if not assigned(m_pgcBin) then Exit;
  tbs := TBinTabSheet(m_pgcBin.GetActiveView);
  if not Assigned(tbs) then exit;
  grid := tbs.GetBinGrid;
  if not Assigned(grid) or (grid.p_GetRow < 1) then exit;
  Result := tbs.m_BinPanel.m_objList.GetLink(grid.p_GetRow-1);

  if Result = CSchedIdNull then exit; // fp
  if IDAsIs then exit;

  ShowGroupLinesInBin(ShowBatchGroupLinesInBin, ShowContinueGroupLinesInBin);
  if (ShowContinueGroupLinesInBin <> CsSCG_No) or ShowBatchGroupLinesInBin then
  begin
    IdGroup := p_sc.LinesBelongToGroup(Result, isGroup);
    if isGroup then
      Result := IdGroup;
  end;
end;

//----------------------------------------------------------------------------//

function TFBin.GetSchedObjByRow(Row: integer): TSchedId;
var
  tbs:  TBinTabSheet;
  grid: TBinDrawGrid;
begin
  Result := CSchedIdNull;

  tbs := TBinTabSheet(m_pgcBin.GetActiveView);
  if not Assigned(tbs) then exit;
  grid := tbs.GetBinGrid;
  if not Assigned(grid) or (Row < 1) then exit;
  Result := tbs.m_BinPanel.m_objList.GetLink(Row-1);
end;

//----------------------------------------------------------------------------//

function CheckGroupLimit(Id : TSchedID; var GroupLimit : integer; LimitGrpCounter : integer) : boolean;
var
  LimitGrpCountPropId : TPropID;
  LimitGrpCompValPropId : TPropID;
  Properties : TProperties;
  FoundLimitGrpCountProp, FoundLimitGrpCompValProp : boolean;
  ValueLimitGrpCountProp, ValueLimitGrpCompValProp : Variant;
begin
  result := true;
  LimitGrpCountPropId := nil;
  LimitGrpCompValPropId := nil;
  if LimitGrpCounter = 1 then
  begin
    LimitGrpCountPropId := GetAssignedLimitGrpCountProp1;
    LimitGrpCompValPropId := GetAssignedPropValueCompareLimitGroup1
  end
  else if LimitGrpCounter = 2 then
  begin
    LimitGrpCountPropId := GetAssignedLimitGrpCountProp2;
    LimitGrpCompValPropId := GetAssignedPropValueCompareLimitGroup2
  end;
  if (LimitGrpCountPropId <> nil) and (LimitGrpCompValPropId <> nil) then
  begin
    Properties := p_sc.GetProperties(Id,nil);
    if Assigned(Properties) then
    begin
      FoundLimitGrpCountProp := Properties.GetValforProp(LimitGrpCountPropId,ValueLimitGrpCountProp);
      FoundLimitGrpCompValProp := Properties.GetValforProp(LimitGrpCompValPropId,ValueLimitGrpCompValProp);
      if FoundLimitGrpCountProp and FoundLimitGrpCompValProp then
      begin
        if p_sc.LimitGroupByCount(LimitGrpCountPropId, LimitGrpCompValPropId, ValueLimitGrpCountProp, ValueLimitGrpCompValProp) then
        begin
          GroupLimit := ValueLimitGrpCountProp;
          result := false;
        end;
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFBin.MINewGroupClick(Sender: TObject);
var
  job:   TSchedId;
  isGrp: boolean;
  str:   string;
  GroupLimit : Integer;
  LimitGrpCompValPropId : TPropID;
begin
  m_GroupTypeCreate := CSM_Manual;
  if not IsGroupFormOut then
  begin
    job := GetMouseSchedObj(false);
    if job = -1 then exit;
    str := p_sc.GetObjInfo(job, isGrp);
    if isGrp then
      ShowMessage(_('You cannot add a group to a group'))
    else if p_sc.GetGroup(job) <> CSchedIdNull then
      ShowMessage(_('Already belonging to a group'))
    else
    begin
      if not CheckGroupLimit(job, GroupLimit, 1) then
      begin
        LimitGrpCompValPropId := GetAssignedPropValueCompareLimitGroup1;
        ShowMessage(_('Sorry, but group limit of ') + IntToStr(GroupLimit) + _(' for ') + GetPropDescr(LimitGrpCompValPropId) + '  ' + _('has been reached'));
      end
      else if not CheckGroupLimit(job, GroupLimit, 2) then
      begin
        LimitGrpCompValPropId := GetAssignedPropValueCompareLimitGroup2;
        ShowMessage(_('Sorry, but group limit of ') + IntToStr(GroupLimit) + _(' for ') + GetPropDescr(LimitGrpCompValPropId) + '  ' + _('has been reached'));
      end
      else
        HandleGroup(self, job, false, -1, true)
    end;

  end
end;

//----------------------------------------------------------------------------//

procedure TFBin.MIAddToGroupClick(Sender: TObject);
var
  job, grp:     TSchedId;
  isGrp:   boolean;
  res:     boolean;
  str:     string;
  ErrDesc: string;
begin
  m_GroupTypeCreate := CSM_Manual;
  if IsGroupFormOut then
  begin

    grp := GetGrpFromGrpForm;
    if (grp < 0) or (grp >= p_sc.GetSchedObjNum) then
      Exit;

    if p_sc.GetGrpNumSons(grp) > 200 then
    begin
      ShowMessage(_('Group Exceeded the limit of 200 jobs'));
      Exit;
    end;

    job := GetMouseSchedObj(false);
    if job = CSchedIdNull then Exit;

    str := p_sc.GetObjInfo(job, isGrp);
    if isGrp then
      ShowMessage(_('You cannot add a group to a group'))
    else if p_sc.GetGroup(job) <> CSchedIdNull then
      ShowMessage(_('Already belonging to a group'))
    else if p_sc.IsAForcedGroup(GetGrpFromGrpForm, true) then
      MessageDlg('Unable to add to a forced group', mtWarning, [mbOK], 0)
    else
    begin
      if p_sc.GetExtLinkPtr(GetGrpFromGrpForm) = nil then
        res := p_sc.CanAddJobToGroup(job, GetGrpFromGrpForm, CanAddJobToGroupOnBin, CanAddJobToGroupSameType, ErrDesc)
      else
        res := p_sc.CanAddJobToGroup(job, GetGrpFromGrpForm, CanAddJobToGroupOnPlan, nil, ErrDesc);

      if res then
        AddToGroup(job)
      else
        ShowMessage(ErrDesc)
    end
  end
end;

procedure TFBin.MiAssignedBooleanProp1Click(Sender: TObject);
begin

end;

//----------------------------------------------------------------------------//

procedure TFBin.MIModiGrpClick(Sender: TObject);
var
  job:   TSchedId;
  isGrp: boolean;
  str:   string;
begin
  if not IsGroupFormOut then
  begin
    job := GetMouseSchedObj(false);
    if job = CSchedIDnull then exit;
    str := p_sc.GetObjInfo(job, isGrp);
    if isGrp or (p_sc.GetGroup(job) <> CSchedIdNull) then
      HandleGroup(self, job, false, -1, false)
  end
end;

//----------------------------------------------------------------------------//

procedure TFBin.MiJobDetailsClick(Sender: TObject);
var
  StepDetails : TFStepDetails;
  id:       TSchedID;
begin
  DMib.m_MainDB.Ping;  // will be catched by CommunicationException in case ping failed
  id := GetMouseSchedObj(false);
  if id = -1 then exit;
  StepDetails := TFStepDetails.CreateStepDetails(Self, id);
  StepDetails.ShowModal;
  StepDetails.Free
end;

//----------------------------------------------------------------------------//

procedure TFBin.RefreshBinTimer(Sender: TObject);
begin
  RefreshBin.Interval := 600;
  if (TBRefresh.ImageIndex = -1) then
    TBRefresh.ImageIndex := 28
  else
    TBRefresh.ImageIndex := -1
end;

//----------------------------------------------------------------------------//

procedure TFBin.RefreshGrid;
var
  tab: TBinTabSheet;
begin
  SetBinMenuItems(GetMouseSchedObj(false));

  tab := TBinTabSheet(m_pgcBin.ActivePage);
  if Assigned(tab) then
    tab.m_BinPanel.RefreshGrid
end;

//----------------------------------------------------------------------------//

procedure TFBin.UpdateForChangeFilter;
var
//  i:   integer;
  tab: TBinTabSheet;
begin
//  for i := 0 to m_pgcBin.PageCount - 1 do
//  begin
//    tab := TBinTabSheet(m_pgcBin.Pages[i]);
//    tab.m_BinPanel.UpdateForChangeFilter
//  end

  tab := GetActiveView;
  if Assigned(tab) then
    tab.m_BinPanel.UpdateForChangeFilter
end;

//----------------------------------------------------------------------------//

procedure TFBin.GetUpdatedList(ObjList: TMSchedList);
var
  tbs : TBinTabSheet;
  i: integer;
begin
  tbs := TBinTabSheet(m_pgcBin.GetActiveView);

  if not Assigned(tbs) then exit;
  ObjList.ClearList;

  for i := 0 to tbs.m_BinPanel.m_objList.GetLinkCount-1 do
    ObjList.AddLink(tbs.m_BinPanel.m_objList.GetLink(i));
end;

//----------------------------------------------------------------------------//

procedure TFBin.GetSingleUpdatedList(ObjList: TMSchedList; SchedId : TSchedId);
var
  tbs : TBinTabSheet;
  i: integer;
  ReqVal, StepVal, FieldValStep, FieldValReq : variant;
  dataType: CBinColValType;
  Id : TSchedId;
begin
  tbs := TBinTabSheet(m_pgcBin.GetActiveView);

  if not Assigned(tbs) then exit;
  ObjList.ClearList;

  p_sc.GetFldValue(SchedId, CSC_ProdReq, FieldValReq, dataType);
  p_sc.GetFldValue(SchedId, CSC_ProdStep, FieldValStep, dataType);

  for i := 0 to tbs.m_BinPanel.m_objList.GetLinkCount-1 do
  begin
    Id := tbs.m_BinPanel.m_objList.GetLink(i);

    p_sc.GetFldValue(Id, CSC_ProdReq, ReqVal, dataType);
    p_sc.GetFldValue(Id, CSC_ProdStep, StepVal, dataType);

    if (ReqVal = FieldValReq) and (StepVal = FieldValStep) then
      ObjList.AddLink(tbs.m_BinPanel.m_objList.GetLink(i));
  end;
end;

//----------------------------------------------------------------------------//

procedure TFBin.MIJobHandlingClick(Sender: TObject);
var
  JobHandle : TFJobHandle;
  id:       TSchedID;
  SplitInfo : TSQSplitInfo;
  PlanInfo :TSQplanInfo;
begin
  id := GetMouseSchedObj(false);
  if id = -1 then exit;
  p_sc.GetPlanInfo(Id, PlanInfo);
  if PlanInfo.isGroup then Exit;
  p_sc.GetSplitInfo(Id, SplitInfo);
  if SplitInfo.SplitAllow = CSB_No then
  begin
    showmessage(_('Split is not allowed !'));
    exit
  end;
  JobHandle := TFJobHandle.CreateJobHandle(Self, Id);
  JobHandle.ShowModal;
  JobHandle.Free
end;

//----------------------------------------------------------------------------//

procedure TFBin.MIShowOnPlanClick(Sender: TObject);
var
  id : TSchedID;
begin
  id := GetMouseSchedObj(false);
  if Assigned(p_sc.GetExtLinkPtr(id)) then
    if Assigned(FMQMPlan) then
      FMQMPlan.FocusOnPlan(id);
end;

//----------------------------------------------------------------------------//

procedure TFBin.MiShowOnPlanMatClick(Sender: TObject);
var
  id : TSchedID;
  tab : TBinTabSheet;
  I, Index : integer;
  job : TSchedId;
  PlanInfo :TSQplanInfo;
  ObjList : TMSchedList;
  BinGrid : TBinDrawGridMat;
  act : TMqmActArea;
begin
  tab := GetActiveView;
  if not Assigned(tab) then exit;
  BinGrid := tab.GetMatGrid;
  if not assigned(BinGrid) then exit;
  ID := TSchedID(TBinPanel(binGrid.Parent).m_ObjList.GetLink(binGrid.p_GetRow - 1));
  if ID = CSchedIDnull then exit;
  if Assigned(TMqmActArea(p_sc.GetExtLinkPtr_Material(ID))) and Assigned(FMQMPlan) then
    FMQMPlan.FocusMatOnPlan(id);
end;

//----------------------------------------------------------------------------//

function TFBin.CreateBinFilterCurrentValues(SchedId: TSchedId ; PropType : TPropGridType ; SRChType : CSearchTabs) : boolean;
var
  BinFilter : TTBinFilter;
  tbs,ActTab : TBinTabSheet;
  ParmsFilt : TBinParms;
  TabTitle : string;
  Cfg : TBinTabCfg;
  binGrid, ActBinGrid  : TBinDrawGrid;
  SavedRefreshBinByButton : boolean;
begin

  Result := true;
  ActTab := GetActiveView;
  if not Assigned(ActTab) then
    Exit;
  ActBinGrid := ActTab.GetBinGrid;

  ParmsFilt := TBinParms.Create;
  BinFilter := TTBinFilter.CreateBinFilter(Self, ParmsFilt,'',PropType, SchedId, SRChType);
  if BinFilter.ShowModal = mrOk then
  begin
    Cfg := m_TbCfg.AddNewTab(BinFilter.GetTabName, m_TbCfg.FindNewCode, false, false);
    SavedRefreshBinByButton := DBAppSettings.RefreshBinByButton;
    DBAppSettings.RefreshBinByButton := false;
    tbs := TBinTabSheet.CreateBinTbs(m_pgcBin, PopUpBin, p_sc,
                             BT_Main, FncFilterStep, ParmsFilt, true, Cfg.code, false);
    DBAppSettings.RefreshBinByButton := SavedRefreshBinByButton;

    if SRChType <> CSR_New then
    begin
     // tbs.p_SearchTab := true;
   //   tbs.Highlighted := true;
    end;
    binGrid := tbs.GetBinGrid;
    binGrid.BinColumnSet := ActBinGrid.BinColumnSet;

{    for J := PropPosition to High(binGrid.BinColumnSet) do
    begin
      if not Assigned(DBAppGlobals.ShowBinPropArry[J-PropPosition]) then
      begin
        binGrid.BinColumnSet[J].Visible := false;
      end
      else
      begin
        binGrid.BinColumnSet[J].Visible := true;
      end;
    end;  }
    //binGrid.SortRowBin;

    TabTitle := BinFilter.GetTabName;
    tbs.TabVisible := true;
    tbs.Caption := TabTitle;
    tbs.SetCode(Cfg.code);
    SetSortIndex(tbs.m_BinPanel, 0);
    m_pgcBin.ActivePage := tbs;

    Cfg.ParmFilt := ParmsFilt;
    Cfg.SaveArrayBinCol(Tbs.GetBinGrid.BinColumnSet);
    Cfg.SaveFiltersTab(m_qryTabInsertFilter, m_qryTabDelete);
    m_TransTabInsert.StartTransaction;
    Cfg.SaveColumnsCfgTab(m_qryTabInsertColumnsCfg, m_qryTabDelete, Tb_Normal);
    m_TransTabInsert.Commit;

  end
  else
    Result := false;

  BinFilter.free;
end;

//----------------------------------------------------------------------------//

procedure TFBin.CreateTabFromJobID(SchedId : TSchedId; SRChType : CSearchTabs; GroupedByCode : string);
var
  BinFilter : TTBinFilter;
  tbs, ActTab : TBinTabSheet;
  ParmsFilt : TBinParms;
  TabTitle : string;
  Cfg : TBinTabCfg;
  binGrid, ActBinGrid : TBinDrawGrid;
begin
  ActTab := GetActiveView;
  ActBinGrid := ActTab.GetBinGrid;
  ParmsFilt := TBinParms.Create;
  BinFilter := TTBinFilter.CreateBinFilter(Self, ParmsFilt,'',TabProp, SchedId, SRChType);

  if (SRChType <> CSR_GroupedBy) and (SRChType <> CSR_GroupedByKeepFilter) then
    BinFilter.SetFilter('')
  else if (SRChType = CSR_GroupedBy) then
  begin
    if GroupedByCode = '' then
      BinFilter.SetFilter(ActTab.m_BinPanel.GetFiltParms.P_GroupedByCode)
    else
    begin
      BinFilter.SetFilter(GroupedByCode);
      ParmsFilt.SignGroupedByCode(GroupedByCode);
    end;

    BinFilter.SetDefaultBinFilter
  end
  else if (SRChType = CSR_GroupedByKeepFilter) then
  begin
    BinFilter.SetFilter(ActTab.m_BinPanel.GetFiltParms.P_GroupedByCode);
    ParmsFilt.RecFilt := ActTab.m_BinPanel.GetFiltParms.RecFilt;
  end;

  Cfg := m_TbCfg.AddNewTab(BinFilter.GetTabName, m_TbCfg.FindNewCode, false, false);

  tbs := TBinTabSheet.CreateBinTbs(m_pgcBin, PopUpBin, p_sc,
                           BT_Main, FncFilterStep, ParmsFilt, true, Cfg.code, false);
//  tbs.p_SearchTab := true;
//  tbs.Highlighted := true;
//  binGrid := tbs.GetBinGrid;


  TabTitle := BinFilter.GetTabName;
  if TabTitle = '' then
    TabTitle := _('TabBin');
  tbs.TabVisible := true;
  tbs.Caption := TabTitle;
  tbs.SetCode(Cfg.code);

  binGrid := tbs.GetBinGrid;
  binGrid.BinColumnSet := ActBinGrid.BinColumnSet;
  SetSortIndex(tbs.m_BinPanel, 0);
  m_pgcBin.ActivePage := tbs;

  Cfg.ParmFilt := ParmsFilt;
  Cfg.SaveArrayBinCol(Tbs.GetBinGrid.BinColumnSet);
  m_TransTabInsert.StartTransaction;
  Cfg.SaveFiltersTab(m_qryTabInsertFilter, m_qryTabDelete);
  m_TransTabInsert.Commit;
  m_TransTabInsert.StartTransaction;
  Cfg.SaveColumnsCfgTab(m_qryTabInsertColumnsCfg, m_qryTabDelete, Tb_Normal);
  m_TransTabInsert.Commit;

  BinFilter.free;
end;

//----------------------------------------------------------------------------//

procedure TFBin.CreateTabBySearchValues(TabName : string; ValFrom : variant; ValTo : variant; BinColId : CBinColId; IsProp : boolean; PropId : TPropID);
var
  BinFilter : TTBinFilter;
  tbs, ActTab : TBinTabSheet;
  ParmsFilt : TBinParms;
  TabTitle : string;
  Cfg : TBinTabCfg;
  binGrid, ActBinGrid: TBinDrawGrid;
//  J, PropPosition : Integer;
  StpType : CScSchedType;
begin
//  PropPosition := GetNumberFields;

  ActTab := GetActiveView;
  ActBinGrid := ActTab.GetBinGrid;

  ParmsFilt := TBinParms.Create;
  BinFilter := TTBinFilter.CreateBinFilter(Self, ParmsFilt,TabName,TabProp, -1, CSR_New);

  if not IsProp then
  begin
    case BinColId of
      CSC_ProdReq : begin
                      BinFilter.EditProdReqFrom.Text := ValFrom;
                      BinFilter.EditProdReqTo.Text := ValTo;
                    end;
      CSC_ProdDlvDate : begin
                          BinFilter.CheckDelivDate_From.Checked := true;
                          BinFilter.DatePickDelivDate_From.Date := ValFrom;
                          BinFilter.CheckDelivDate_To.Checked := true;
                          BinFilter.DatePickDelivDate_to.Date := ValTo;
                        end;
      CSC_PlanStartDate : begin
                            BinFilter.CheckStartDate_From.Checked := true;
                            BinFilter.DatePickStartDate_From.Date := ValFrom;
                            BinFilter.CheckStartDate_To.Checked := true;
                            BinFilter.DatePickStartDate_To.Date := ValTo;
                          end;
      CSC_SchedStart    : begin
                            BinFilter.CheckSchedStartDate_From.Checked := true;
                            BinFilter.DatePickSchedStartDate_From.Date := ValFrom;
                            BinFilter.CheckSchedStartDate_To.Checked := true;
                            BinFilter.DatePickSchedStartDate_To.Date := ValTo;
                          end;
      CSC_HighEndLimit  : begin
                            BinFilter.CheckLatestEndingDate_From.Checked := true;
                            BinFilter.DatePickerLatestEndingDate_From.Date := ValFrom;
                            BinFilter.CheckLatestEndingDate_To.Checked := true;
                            BinFilter.DatePickerLatestEndingDate_To.Date := ValTo;
                          end;

      CSC_LowStartTimeLimit : begin
                            BinFilter.CheckLowStartDate_From.Checked := true;
                            BinFilter.DatePickLowStartDate_From.Date := ValFrom;
                            BinFilter.CheckLowStartDate_To.Checked := true;
                            BinFilter.DatePickLowStartDate_To.Date := ValTo;
                          end;
      CSC_LowStartDate   : begin
                            BinFilter.CheckLowDate_From.Checked := true;
                            BinFilter.DatePickLowDate_From.Date := ValFrom;
                            BinFilter.CheckLowDate_To.Checked := true;
                            BinFilter.DatePickLowDate_To.Date := ValTo;
                          end;
      CSC_WkctCode       :  begin
                              BinFilter.ComboBoxWC.ItemIndex := BinFilter.SearchForWc(ValFrom);
                              BinFilter.ComboBoxWCTO.ItemIndex := BinFilter.SearchForWc(ValTo);
                            end;

      CSC_WkctProc       :  begin
                              BinFilter.ComboBoxWC.ItemIndex := BinFilter.searchForProces(ValFrom);
                              BinFilter.ComboBoxWCTO.ItemIndex := BinFilter.searchForProces(ValTo);
                            end;

      CSC_StepType       :   begin
                               if ValFrom =  'Continuous' then
                                  StpType := CST_Continuous
                               else if ValFrom =  'Batches' then
                                  StpType := CST_batch
                               else
                                  StpType := CST_Continuous;
                               BinFilter.CBStepType.ItemIndex := BinFilter.SearchForStpType(StpType);
                               end;
      CSC_ProdType        : BinFilter.ComboBoxProdType.ItemIndex := BinFilter.SearchForProdTyp(ValFrom);


      CSC_ProdStep        : begin
                              BinFilter.EdtStep.Text := ValFrom;
                              BinFilter.EdtStepTo.Text := ValTo;
                            end;

      CSC_ProdSubStep        : begin
                              BinFilter.EdtSubStep.Text := ValFrom;
                              BinFilter.EdtSubStepTo.Text := ValTo;
                            end;

      CSC_GroupNo         : begin
                              BinFilter.EdtGrpNumber.Text := ValFrom;
                              BinFilter.EdtGrpNumberto.Text := ValTo;
                            end;

      CSC_Rsc             : begin
                              BinFilter.EdtResource.Text  := ValFrom;
                              BinFilter.EdtResourceTo.Text  := ValFrom;
                            end;

      CSC_QtyToSched      : begin
                              BinFilter.EditMinStep.Text  := ValFrom;
                              BinFilter.EditMaxStep.Text  := ValTo;
                            end;

      CSC_ProdFamily      : BinFilter.EditProdFamily.Text  := ValFrom;

      CSC_ProdMatFamily   : BinFilter.EditMaterialFamily.Text  := ValFrom;

    end;

  end
  else
  begin
    BinFilter.m_PropComp.SetPropVal(GetPropCodeFromID(PropId),1,true);
    BinFilter.m_PropComp.SetValFrom(ValFrom,1);
    BinFilter.m_PropComp.SetValTo(ValTo,1);
  end;

  BinFilter.SetFilter('');
  Cfg := m_TbCfg.AddNewTab(BinFilter.GetTabName, m_TbCfg.FindNewCode, false, false);
  tbs := TBinTabSheet.CreateBinTbs(m_pgcBin, PopUpBin, p_sc,
                           BT_Main, FncFilterStep, ParmsFilt, true, Cfg.code, false);

//  binGrid := tbs.GetBinGrid;

{  for J := PropPosition to High(binGrid.BinColumnSet) do
  begin
    if not Assigned(DBAppGlobals.ShowBinPropArry[J-PropPosition]) then
    begin
      binGrid.BinColumnSet[J].Visible := false;
    end
    else
    begin
      binGrid.BinColumnSet[J].Visible := true;
    end;
  end;
  binGrid.SortRowBin;   }


  TabTitle := BinFilter.GetTabName;
  if TabTitle = '' then
    //TabTitle := _('TabBin');
    TabTitle := SetDefaultTabName;
  tbs.TabVisible := true;
  tbs.Caption := TabTitle;
  tbs.SetCode(Cfg.code);
//  m_pgcBin.ActivePage := tbs;

  binGrid := tbs.GetBinGrid;
  binGrid.BinColumnSet := ActBinGrid.BinColumnSet;
  SetSortIndex(tbs.m_BinPanel, 0);
  m_pgcBin.ActivePage := tbs;

  Cfg.ParmFilt := ParmsFilt;
  Cfg.SaveArrayBinCol(binGrid.BinColumnSet);
  m_TransTabInsert.StartTransaction;
  Cfg.SaveFiltersTab(m_qryTabInsertFilter, m_qryTabDelete);
  m_TransTabInsert.Commit;
  m_TransTabInsert.StartTransaction;
  Cfg.SaveColumnsCfgTab(m_qryTabInsertColumnsCfg, m_qryTabDelete, Tb_Normal);
  m_TransTabInsert.Commit;


  BinFilter.free;
end;

//----------------------------------------------------------------------------//

{procedure TFBin.MIAutoSchedAllClick(Sender: TObject);
var
  ObjList: TMSchedList;
  I : Integer;
  tbs : TBinTabSheet;
  BinGrid : TBinDrawGrid;
  Id : TSchedId;
  SchedList : TMSchedList;
begin
  AutoSchedCfg.m_SchedAllEndingSelectedJob := CSchedIDnull;
  AutoSchedCfg.m_OnlySelectedJobAuto := false;
  tbs := TBinTabSheet(m_pgcBin.GetActiveView);
  ObjList := TMSchedList.Create(self);
  SchedList := TMSchedList.Create(self);

  BinGrid := tbs.GetBinGrid;
  SchedList := BinGrid.GetSelectedList;
  if BinGrid.pSelectedMarked then
  begin



  end
  else
  begin


  end;


  for I := 0 to tbs.m_BinPanel.m_objList.GetLinkCount - 1 do
  begin
    Id := tbs.m_BinPanel.m_objList.GetLink(i);
    ObjList.AddLink(Id);
  end;

  if IsSplitRunMode then
  begin
    if CheckSplitBeforeSchedule(ObjList) then
       tbs.m_BinPanel.UpdateForChangeFilter;
  end
  else if IsAutoRunMode then
  begin
    PrepareAutoSeqList(false);
  end
  else
  begin
    if CheckSplitBeforeSchedule(ObjList)  then
        tbs.m_BinPanel.UpdateForChangeFilter
    else
      PrepareAutoSeqList(false);
  end;

end; }

//----------------------------------------------------------------------------//

{procedure TFBin.MIAutoSchedAllEndingSelectedJobExcludeClick(Sender: TObject);
begin
  AutoSchedCfg.m_SchedAllEndingSelectedJob_EXCLUDE := true;
  MIAutoSchedAllEndingSelectedJobIncludeClick(self);
  AutoSchedCfg.m_SchedAllEndingSelectedJob_EXCLUDE := false;
end; }

//----------------------------------------------------------------------------//

{procedure TFBin.MIAutoSchedAllEndingSelectedJobExcludRebuildGenericPlanClick(
  Sender: TObject);
begin
  AutoSchedCfg.m_SchedAllEndingSelectedJob_EXCLUDE := true;
  MIAutoSchedAllEndingSelectedJobIncludRebuildGenericPlanClick(self);
  AutoSchedCfg.m_SchedAllEndingSelectedJob_EXCLUDE := false;
end; }

//----------------------------------------------------------------------------//

{procedure TFBin.MIAutoSchedAllEndingSelectedJobIncludeClick(Sender: TObject);
var
  IDSelected : TSchedId;
  ObjList: TMSchedList;
  I : Integer;
  tbs : TBinTabSheet;
  Id : TSchedId;
begin
  IDSelected := GetMouseSchedObj(true);
  AutoSchedCfg.m_SchedAllEndingSelectedJob := IDSelected;
  AutoSchedCfg.m_OnlySelectedJobAuto := false;

  tbs := TBinTabSheet(m_pgcBin.GetActiveView);
  ObjList := TMSchedList.Create(self);
  for I := 0 to tbs.m_BinPanel.m_objList.GetLinkCount - 1 do
  begin
    Id := tbs.m_BinPanel.m_objList.GetLink(i);
    ObjList.AddLink(Id);
  end;

  if CheckSplitBeforeSchedule(ObjList) then
    tbs.m_BinPanel.UpdateForChangeFilter
  else
    PrepareAutoSeqList(false);
  AutoSchedCfg.m_SchedAllEndingSelectedJob := CSchedIDnull
end;  }

//----------------------------------------------------------------------------//

{procedure TFBin.MIAutoSchedAllEndingSelectedJobIncludRebuildGenericPlanClick(
  Sender: TObject);
begin
  AutoSchedCfg.m_runOrganizeGenericPlanFirst := true;
  MIAutoSchedAllEndingSelectedJobIncludeClick(self);
  AutoSchedCfg.m_runOrganizeGenericPlanFirst := false;
end; }

//----------------------------------------------------------------------------//

{procedure TFBin.MIAutoSchedAllStartingSelectedJobClick(Sender: TObject);
var
  skip : boolean;
  IDSelected : TSchedId;
  ObjList: TMSchedList;
  I : Integer;
  tbs : TBinTabSheet;
  Id : TSchedId;
begin
  Skip := true;
//  AutoSchedCfg.m_SchedAllEndingSelectedJob := CSchedIDnull;
  AutoSchedCfg.m_OnlySelectedJobAuto := false;
  IDSelected := GetMouseSchedObj(true);
  tbs := TBinTabSheet(m_pgcBin.GetActiveView);
  ObjList := TMSchedList.Create(self);
  for I := 0 to tbs.m_BinPanel.m_objList.GetLinkCount - 1 do
  begin
    Id := tbs.m_BinPanel.m_objList.GetLink(i);
    if Skip and (Id <> IDSelected) then continue;
      Skip := false;
    ObjList.AddLink(Id);
  end;

  if CheckSplitBeforeSchedule(ObjList) then
    tbs.m_BinPanel.UpdateForChangeFilter
  else
    PrepareAutoSeqList(true);
end;  }

//----------------------------------------------------------------------------//

procedure TFBin.MIAutoSchedClick(Sender: TObject);
begin
//  if Sender is TToolButton then
//    if TToolButton(Sender).name = 'TBStartAutoSched' then

 // MIAutoSched
end;

procedure TFBin.MIAutoSchedPlusGenericClick(Sender: TObject);
begin
  AutoSchedCfg.m_runOrganizeGenericPlanFirst := true;
  MIStartAutoSchedCurrentCfgClick(self);
  AutoSchedCfg.m_runOrganizeGenericPlanFirst := false;
end;

//----------------------------------------------------------------------------//

procedure TFBin.MiAutoSeqBySelectedCfgClick(Sender: TObject);
begin
  //GetAllAutoSchedCfgList
end;

//----------------------------------------------------------------------------//

procedure TFBin.MiRepositionJobsToRealMachinesClick(Sender: TObject);
var
  iRes, iVisRes, iApa, I, Y : integer;
  res:     TMqmRes;
  VisRes:  TMqmVisibleRes;
  ActArea: TMqmActArea;
  IdObj, id : TSchedID;
  linkInfo : TSQMCMlinkInfo;
  McmlinkInfo : PTSQMCMlinkInfo;
begin
 // Exit;
  for iRes := 0 to p_pl.p_ResCount -1 do
  begin

    res := TMqmRes(p_pl.p_ResList[iRes]);
    if res.p_PlanType = RPT_Real then continue;
    for iVisRes := 0 to res.p_VisResCount -1 do
    begin
      VisRes := TMqmVisibleRes(res.p_VisRes[iVisRes]);
      Application.ProcessMessages;

      for y := 0 to VisRes.p_ActAreasCount -1 do
      begin
        ActArea := TMqmActArea(VisRes.p_ActArea[y]);
        IdObj := ActArea.GetSchedObj(0);
        if IdObj <> CSchedIDnull then
        begin
          for I := ActArea.p_ObjCount - 1 downto 0 do
          begin
            id := ActArea.GetSchedObj(I);
            p_sc.GetMcmLinkInfo(id, linkInfo, false);

          if linkInfo.ProgType <> '' then continue;
          if AutoSchedCfg.m_McmListOfRescheduledId = nil then
            AutoSchedCfg.m_McmListOfRescheduledId := TList.Create;
          if AutoSchedCfg.m_WithoutStack then // When without stack this is called from override parameters, so , we need
            MoveToBin(Id, false)              // to unschedule with stack.
          else
            ActArea.RemoveSchedObj(id);
          new(McmlinkInfo);
          McmlinkInfo.id := Id;
          McmlinkInfo.SchedStart := linkInfo.SchedStart;
          McmlinkInfo.SchedEnd   := linkInfo.SchedEnd;
          McmlinkInfo.WorkCenter := linkInfo.WorkCenter;
          AutoSchedCfg.m_McmListOfRescheduledId.Add(McmlinkInfo)
          end;
        end;
      end;

      Application.ProcessMessages;

    end;

  end;

  AutoSchedCfg.m_McmRescheduledJobs := true;
  AutoSequencingReScheduleMcmJobs(false);
end;

//----------------------------------------------------------------------------//

procedure TFBin.AutoScheduleMain(ObjList: TMSchedList);
var
  tbs:      TBinTabSheet;
  BinGrid : TBinDrawGrid;
  MarkStack: TStackMark;
  I : Integer;
  Id : TschedId;
  SavedAutoSchedCfg : TAutoSchedCfg;
begin
  tbs  := FBin.GetActiveView;
  BinGrid := tbs.GetBinGrid;
  BinGrid.UpdateOrderColumns;

  if not AutoSchedCfg.m_McmRescheduledJobs or not AutoSchedCfg.m_McmRescheduledJobsAutoOnStart then
  begin
    MarkStack := p_opStack.MarkStack;
    p_opStack.MarkStackForButtonUndo(_('Automatic sequencing')); //aviadd
  end;

  if AutoSchedCfg.m_OverridingParams_Activated and AutoSchedCfg.m_OverridingParams_UnscheduleBefore then
  begin
    for I := 0 to ObjList.GetLinkCount - 1 do
    begin
      Id := ObjList.GetLink(I);
      if Assigned(p_sc.GetExtLinkPtr(Id)) then
      begin
        MoveToBin(Id, false)
      end;
    end;
  end;

//  if AutoSchedCfg.m_OverridingParams_Activated then
//  begin
//    SavedAutoSchedCfg := AutoSchedCfg^;
//    AutoSchedCfg.m_WithoutStack := true;
//    FBin.MiRepositionJobsToRealMachinesClick(Application);
//    AutoSchedCfg^ := SavedAutoSchedCfg;
//  end;

  AutoSchedule(ObjList);

end;

//----------------------------------------------------------------------------//

procedure TFBin.AutoSchedule(ObjList: TMSchedList);
var
  tbs:      TBinTabSheet;
  FrmAutoSchedRpt: TFAutoSchedRpt;
  ResultsOnPlan: TList;
  ResultsInBin: TList;
//  MarkStack: TStackMark;
  FrmAutoSched: TFAutoSched;
  I : Integer;
  ManagerResList : TList;
  AutoSchedRptSimulation : TFAutoSchedRptSimulation;
//  BinGrid : TBinDrawGrid;
begin
//  tbs  := FBin.GetActiveView;
//  BinGrid := tbs.GetBinGrid;
//  BinGrid.UpdateOrderColumns;

//  if not AutoSchedCfg.m_McmRescheduledJobs or not AutoSchedCfg.m_McmRescheduledJobsAutoOnStart then
//  begin
//    MarkStack := p_opStack.MarkStack;
//    p_opStack.MarkStackForButtonUndo(_('Automatic sequencing')); //aviadd
//  end;

  ResultsOnPlan := TList.Create;
  ResultsInBin := TList.Create;
  ManagerResList := TList.Create;

{  if AutoSchedCfg.m_OverridingParams_Activated and AutoSchedCfg.m_OverridingParams_UnscheduleBefore then
  begin
    for I := 0 to ObjList.GetLinkCount - 1 do
    begin
      Id := ObjList.GetLink(I);
        if Assigned(p_sc.GetExtLinkPtr(Id)) then
           MoveToBin(Id, false)
    end;
  end; }

  FrmAutoSched := TFAutoSched.CreateAutoSched(FMQMPlan, ObjList, ResultsOnPlan, ResultsInBin, ManagerResList);
  try
    FrmAutoSched.ShowModal;
  except
    raise;
  end;
  FMQMPlan.RefreshActiveTab;
  if Assigned(FBin) and (FBin.GetActiveView <> nil) then
    FBin.GetActiveView.m_BinPanel.UpdateForChangeFilter;

  if IsAutoRunMode or CheckIfActiveGanttTabIsMcm then
  begin
    CleanAllInformationList(false);
    for I := ManagerResList.Count - 1 downto 0 do
      TResourcesManager(ManagerResList[I]).CleanAllMemory;

    for I := ResultsOnPlan.Count - 1 downto 0 do
      Dispose(PTAutoSchedResult(ResultsOnPlan[I]));

    for I := ResultsInBin.Count - 1 downto 0 do
      Dispose(PTAutoSchedResult(ResultsInBin[I]));

    ManagerResList.Free;
    ResultsOnPlan.Free;
    ResultsInBin.Free;

    if DBAppGlobals.MCM_App then
      RefreshMcmActiveGanttTab;

    Application.ProcessMessages;

    FrmAutoSched.Free;

    exit;
  end;

  if FrmAutoSched.m_OperatedAbort then
  begin
    AutoSchedRptSimulation := TFAutoSchedRptSimulation.CreateAutoSchedRptSim(FMQMPlan, ObjList, ManagerResList, true);
    if AutoSchedRptSimulation.ShowModal <> mrOK then
    begin

    end;
  end
  else
  begin
    AutoSchedRptSimulation := TFAutoSchedRptSimulation.CreateAutoSchedRptSim(FMQMPlan, ObjList, ManagerResList, false);
    if AutoSchedRptSimulation.ShowModal <> mrOK then
    begin
      //p_opStack.UndoTo(MarkStack);
      p_opStack.UndoByButton;
      tbs  := FBin.GetActiveView;
      if Assigned(tbs) then
        tbs.m_BinPanel.UpdateForChangeFilter;  // Refresh Bin

    end
    else
    begin

    end;
  end;

  AutoSchedRptSimulation.Free;
  for I := ManagerResList.Count - 1 downto 0 do
    TResourcesManager(ManagerResList[I]).CleanAllMemory;
  ManagerResList.Clear;
 // end
  {else
  begin

    FrmAutoSchedRpt := TFAutoSchedRpt.CreateAutoSchedRpt(FMQMPlan, ObjList, ResultsOnPlan, ResultsInBin);
    if FrmAutoSchedRpt.ShowModal <> mrOK then
    begin
      p_opStack.UndoTo(MarkStack);
      tbs  := FBin.GetActiveView;
      if Assigned(tbs) then
        tbs.m_BinPanel.UpdateForChangeFilter;  // Refresh Bin
    end else
    begin
      if AutoSchedCfg.m_RankRep and Assigned(FrmAutoSched.m_LastObjRank) then
        if FrmAutoSched.m_LastObjRank.p_Rank.Count = 0 then
        begin
          MessageDlg(_('Is not possible to show the Rank Report because the last object is not been scheduled'), mtWarning, [mbOk], 0);
        end else
        begin
          try
            TFRankReport.CreateRankReport(FMQMPlan, FrmAutoSched.m_LastObjRank).Show;
          except
          end;
        end;
    end;

  end; }

  FrmAutoSched.Free;

  for I := ResultsOnPlan.Count - 1 downto 0 do
    Dispose(PTAutoSchedResult(ResultsOnPlan[I]));

  for I := ResultsInBin.Count - 1 downto 0 do
    Dispose(PTAutoSchedResult(ResultsInBin[I]));

  ManagerResList.Free;
  ResultsOnPlan.Free;
  ResultsInBin.Free;
end;

//----------------------------------------------------------------------------//

procedure TFBin.BuildQryForInsertTab;
var
  tbInfoFiltr, tbInfoColumn : ^TTblInfo;
  SQLStrings : string;
  I : Integer;
  IAsStr : string;
begin
  SQLStrings := '';

  tbInfoFiltr := @tblInfo[tbl_cfg_binFilter];
  tbInfoColumn := @tblInfo[tbl_cfg_binTab_col];


  SQLStrings := 'insert into ' + tbInfoFiltr.GetTableName + '(';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_Identifier) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_wkstCode) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_TabsCode) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_TabsDesc) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_TabVis) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_MinQty) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_MaxQty) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_rsc)     + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_rsc_To)   + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltResCatCode) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_ProdType) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_ProdLowDate_From) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_ProdLowDate_To) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_DelivDate_From) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_DelivDate_To) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_PlanStartDate_From) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_PlanStartDate_To) + ',';

  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_PlanStartDateToday_From) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_PlanStartDateToday_To) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_PlanEndDate_From) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_PlanEndDate_To) + ',';

  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_PlanEndDateToday_From) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_PlanEndDateToday_To) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_NextStartDate_From) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_NextStartDate_to) + ',';

  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_NextStartDateToday_From) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_NextStartDateToday_To) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_PrevEndDate_From) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_PrevEndDate_to) + ',';

  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_PrevEndDateToday_From) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_PrevEndDateToday_To) + ',';

  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_LowStartDate_From) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_LowStartDate_To) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_preqNo) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_preqNo_to) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_pstepId) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_pstepId_To) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_psubstId) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_psubstId_To) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_stGroupFrom) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_stGroupTo) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_Bin_ReadOnly) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_wkCtrCode) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_wkcProc) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_wkCtrCode_To) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_wkcProc_To) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_ShowAlternative) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_Wkcr_FromPlan) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_StepType) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_ProdFamily) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_MaterialFamily) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltSchedJobs) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltFltJobsOnGantt) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltClosedJobs) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_Bin_OnlyReadOnly) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltOnlySchedJobs) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltOnlyClosedJobs) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltGroups) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltOnlyGroups) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltPriority) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_SchedStartDate_From) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_SchedStartDate_To) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_DaysFromToday_From) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_DaysFromToday_To) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_DaysFromToday_ToTime) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_ScheduledJobsCrossesDateTime_From) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_ScheduledJobsCrossesDateTime_To) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_LatestEndingDate_From) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_LatestEndingDate_To) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltTemporary) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltProgress) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltOnlyProgress) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltAfterDeliveryDay) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltAfterDeliveryInDays) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltBeforeEarliestStart) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltBeforeEarliestStartInDays) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltAfterLatestEnd) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltAfterLatestEndInDays) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltShouldBeScheduled) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltShouldBeScheduledIndays) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltMissingmaterials) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltMissingAddRes) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltOveridePrevious) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltOverideNext) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltCompWithPrevJob) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltCompWithPrevJobInCase) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltCompWithRes) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltJobMsg) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltImbalancedSteps) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltCompWithResInCase) + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevNewLog) + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevels_final) + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevels_Ini) + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevel1) + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevel2) + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevel3) + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevel4) + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevel5) + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltCustomerDateConfirmed)    + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltCustomerDateCalculated)   + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltCustomerDateRequested)    + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltShowFirstGrplineInBin)    + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltAutoGroupSingleJob)       + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltShowBatchGroupLinesInBin) + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltShowContinueGroupLinesInBin) + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_GroupedByCode) + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_OverriddenTab) + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltDependingOnNextHandledStep) + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltDependingOnPrevHandledStep) + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_filtDependingOnNextHandledLinkedRequest) + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_filtDependingOnPrevHandledLinkedRequest) + ',' ;

  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_filtFixedEarlistDateFrom) + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_filtFixedEarlistDateTo) + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_filtFixedEarlistDateInDaysFrom) + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_filtFixedEarlistDateInDaysTo) + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_filtIgnoredProgress) + ',' ;

  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_wkCtrGroup) + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_PlantCode) + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_Division) + ',' ;

  for i := 1 to 60 do
  begin
    IAsStr := IntToStr(i);
    SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltPropCode) + IAsStr + ',';
    SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltPropRes) + IAsStr + ',';
    SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_filtPropValueFrom) + IAsStr + ',';
    if i < 60 then
      SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_filtPropValueTo) + IAsStr + ','
    else
      SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_filtPropValueTo) + IAsStr;
  end;

  SQLStrings := SQLStrings + ') values (';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_Identifier) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_wkstCode) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_TabsCode) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_TabsDesc) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_TabVis) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_MinQty) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_MaxQty) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_rsc) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_rsc_To) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltResCatCode) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_ProdType) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_ProdLowDate_From) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_ProdLowDate_To) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_DelivDate_From) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_DelivDate_To) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_PlanStartDate_From) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_PlanStartDate_To) + ',';

  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_PlanStartDateToday_From) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_PlanStartDateToday_To) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_PlanEndDate_From) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_PlanEndDate_To) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_PlanEndDateToday_From) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_PlanEndDateToday_To) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_NextStartDate_From) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_NextStartDate_to) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_NextStartDateToday_From) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_NextStartDateToday_To) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_PrevEndDate_From) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_PrevEndDate_to) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_PrevEndDateToday_From) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_PrevEndDateToday_To) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_LowStartDate_From) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_LowStartDate_To) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_preqNo) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_preqNo_To) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_pstepId) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_pstepId_To) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_psubstId) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_psubstId_To) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_stGroupFrom) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_stGroupTo) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_Bin_ReadOnly) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_wkCtrCode) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_wkcProc) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_wkCtrCode_To) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_wkcProc_To) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_ShowAlternative) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_Wkcr_FromPlan) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_StepType) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_ProdFamily) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_MaterialFamily) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltSchedJobs) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltFltJobsOnGantt) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltClosedJobs) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_Bin_OnlyReadOnly) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltOnlySchedJobs) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltOnlyClosedJobs) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltGroups) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltOnlyGroups) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltPriority) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_SchedStartDate_From) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_SchedStartDate_To) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_DaysFromToday_From) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_DaysFromToday_To) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_DaysFromToday_ToTime) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_ScheduledJobsCrossesDateTime_From) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_ScheduledJobsCrossesDateTime_To) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_LatestEndingDate_From) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_LatestEndingDate_To) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltTemporary) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltProgress) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltOnlyProgress) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltAfterDeliveryDay) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltAfterDeliveryInDays) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltBeforeEarliestStart) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltBeforeEarliestStartInDays) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltAfterLatestEnd) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltAfterLatestEndInDays) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltShouldBeScheduled) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltShouldBeScheduledIndays) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltMissingmaterials) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltMissingAddRes) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltOveridePrevious) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltOverideNext) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltCompWithPrevJob) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltCompWithPrevJobInCase) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltCompWithRes) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltJobMsg) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltImbalancedSteps) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltCompWithResInCase) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevNewLog) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevels_final) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevels_Ini) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevel1) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevel2) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevel3) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevel4) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevel5) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltCustomerDateConfirmed)    + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltCustomerDateCalculated)   + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltCustomerDateRequested)    + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltShowFirstGrplineInBin)    + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltAutoGroupSingleJob)       + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltShowBatchGroupLinesInBin) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltShowContinueGroupLinesInBin) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_GroupedByCode) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_OverriddenTab) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltDependingOnNextHandledStep) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltDependingOnPrevHandledStep) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_filtDependingOnNextHandledLinkedRequest) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_filtDependingOnPrevHandledLinkedRequest) + ',';

  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_filtFixedEarlistDateFrom) +',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_filtFixedEarlistDateTo) +',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_filtFixedEarlistDateInDaysFrom) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_filtFixedEarlistDateInDaysTo) + ',';

  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_filtIgnoredProgress) + ',';

  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_wkCtrGroup) +',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_PlantCode) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_Division) + ',';

  for i := 1 to 60 do
  begin
    IAsStr := IntToStr(i);

    SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltPropCode) + IAsStr + ',';
    SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltPropRes) + IAsStr + ',';
    SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_filtPropValueFrom) + IAsStr + ',';
    if i < 60 then
      SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_filtPropValueTo) + IAsStr + ','
    else
      SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_filtPropValueTo) + IAsStr;
  end;
  SQLStrings := SQLStrings + ')';

  m_qryTabInsertFilter.SQL.Clear;
  m_qryTabInsertFilter.SQL.add(SQLStrings);


  ///////////////////////MAT FILTER
  ///
  ///

  tbInfoFiltr := @tblInfo[tbl_cfg_binMaterialFilter];

  SQLStrings := '';
  SQLStrings := 'insert into ' + tbInfoFiltr.GetTableName + '(';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_Identifier) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_wkstCode) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_TabsCode) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_TabsDesc) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_ItemType) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_ProdCode) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_netGroupCode) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_Detail_Code) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_Sub_Detail) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltSchedJobs) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltWarpLvl) + ',';

  //2nd level
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_ItemType2) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_ProdCode2) + ',';
 { SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_TabVis) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_MinQty) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_MaxQty) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_rsc)     + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_rsc_To)   + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_ProdType) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_ProdLowDate_From) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_ProdLowDate_To) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_DelivDate_From) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_DelivDate_To) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_PlanStartDate_From) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_PlanStartDate_To) + ',';

  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_PlanStartDateToday_From) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_PlanStartDateToday_To) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_PlanEndDate_From) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_PlanEndDate_To) + ',';

  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_PlanEndDateToday_From) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_PlanEndDateToday_To) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_NextStartDate_From) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_NextStartDate_to) + ',';

  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_NextStartDateToday_From) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_NextStartDateToday_To) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_PrevEndDate_From) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_PrevEndDate_to) + ',';

  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_PrevEndDateToday_From) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_PrevEndDateToday_To) + ',';

  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_LowStartDate_From) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_LowStartDate_To) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_preqNo) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_preqNo_to) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_pstepId) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_pstepId_To) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_psubstId) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_psubstId_To) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_stGroupFrom) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_stGroupTo) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_Bin_ReadOnly) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_wkCtrCode) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_wkcProc) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_wkCtrCode_To) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_wkcProc_To) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_ShowAlternative) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_Wkcr_FromPlan) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_StepType) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_ProdFamily) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_MaterialFamily) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltSchedJobs) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltFltJobsOnGantt) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltClosedJobs) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_Bin_OnlyReadOnly) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltOnlySchedJobs) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltOnlyClosedJobs) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltGroups) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltOnlyGroups) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltPriority) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_SchedStartDate_From) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_SchedStartDate_To) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_DaysFromToday_From) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_DaysFromToday_To) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_DaysFromToday_ToTime) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_ScheduledJobsCrossesDateTime_From) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_ScheduledJobsCrossesDateTime_To) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_LatestEndingDate_From) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_LatestEndingDate_To) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltTemporary) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltProgress) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltOnlyProgress) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltAfterDeliveryDay) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltAfterDeliveryInDays) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltBeforeEarliestStart) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltBeforeEarliestStartInDays) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltAfterLatestEnd) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltAfterLatestEndInDays) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltShouldBeScheduled) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltShouldBeScheduledIndays) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltMissingmaterials) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltMissingAddRes) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltOveridePrevious) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltOverideNext) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltCompWithPrevJob) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltCompWithPrevJobInCase) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltCompWithRes) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltJobMsg) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltImbalancedSteps) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltCompWithResInCase) + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevNewLog) + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevels_final) + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevels_Ini) + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevel1) + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevel2) + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevel3) + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevel4) + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevel5) + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltCustomerDateConfirmed)    + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltCustomerDateCalculated)   + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltCustomerDateRequested)    + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltShowFirstGrplineInBin)    + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltAutoGroupSingleJob)       + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltShowBatchGroupLinesInBin) + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltShowContinueGroupLinesInBin) + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_GroupedByCode) + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_OverriddenTab) + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltDependingOnNextHandledStep) + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltDependingOnPrevHandledStep) + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_filtDependingOnNextHandledLinkedRequest) + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_filtDependingOnPrevHandledLinkedRequest) + ',' ;

  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_filtFixedEarlistDateFrom) + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_filtFixedEarlistDateTo) + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_filtFixedEarlistDateInDaysFrom) + ',' ;
  SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_filtFixedEarlistDateInDaysTo) + ',' ;   }
  for i := 1 to 60 do
  begin
    IAsStr := IntToStr(i);
    SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltPropCode) + IAsStr + ',';
   // SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_FiltPropRes) + IAsStr + ',';
    SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_filtPropValueFrom) + IAsStr + ',';
    if i < 60 then
      SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_filtPropValueTo) + IAsStr + ','
    else
      SQLStrings := SQLStrings + CreateFld(tbInfoFiltr.pfx, fli_filtPropValueTo) + IAsStr;
  end;

  SQLStrings := SQLStrings + ') values (';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_Identifier) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_wkstCode) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_TabsCode) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_TabsDesc) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_ItemType) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_ProdCode) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_netGroupCode) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_Detail_Code) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_Sub_Detail) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltSchedJobs)+ ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltWarplvl)+ ',';

  //2nd level
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_ItemType2) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_ProdCode2) + ',';
 { //SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_TabVis) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_MinQty) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_MaxQty) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_rsc) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_rsc_To) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_ProdType) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_ProdLowDate_From) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_ProdLowDate_To) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_DelivDate_From) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_DelivDate_To) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_PlanStartDate_From) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_PlanStartDate_To) + ',';

  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_PlanStartDateToday_From) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_PlanStartDateToday_To) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_PlanEndDate_From) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_PlanEndDate_To) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_PlanEndDateToday_From) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_PlanEndDateToday_To) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_NextStartDate_From) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_NextStartDate_to) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_NextStartDateToday_From) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_NextStartDateToday_To) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_PrevEndDate_From) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_PrevEndDate_to) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_PrevEndDateToday_From) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_PrevEndDateToday_To) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_LowStartDate_From) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_LowStartDate_To) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_preqNo) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_preqNo_To) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_pstepId) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_pstepId_To) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_psubstId) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_psubstId_To) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_stGroupFrom) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_stGroupTo) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_Bin_ReadOnly) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_wkCtrCode) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_wkcProc) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_wkCtrCode_To) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_wkcProc_To) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_ShowAlternative) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_Wkcr_FromPlan) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_StepType) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_ProdFamily) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_MaterialFamily) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltSchedJobs) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltFltJobsOnGantt) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltClosedJobs) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_Bin_OnlyReadOnly) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltOnlySchedJobs) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltOnlyClosedJobs) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltGroups) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltOnlyGroups) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltPriority) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_SchedStartDate_From) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_SchedStartDate_To) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_DaysFromToday_From) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_DaysFromToday_To) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_DaysFromToday_ToTime) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_ScheduledJobsCrossesDateTime_From) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_ScheduledJobsCrossesDateTime_To) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_LatestEndingDate_From) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_LatestEndingDate_To) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltTemporary) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltProgress) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltOnlyProgress) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltAfterDeliveryDay) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltAfterDeliveryInDays) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltBeforeEarliestStart) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltBeforeEarliestStartInDays) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltAfterLatestEnd) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltAfterLatestEndInDays) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltShouldBeScheduled) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltShouldBeScheduledIndays) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltMissingmaterials) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltMissingAddRes) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltOveridePrevious) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltOverideNext) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltCompWithPrevJob) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltCompWithPrevJobInCase) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltCompWithRes) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltJobMsg) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltImbalancedSteps) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltCompWithResInCase) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevNewLog) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevels_final) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevels_Ini) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevel1) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevel2) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevel3) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevel4) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltConfLevel5) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltCustomerDateConfirmed)    + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltCustomerDateCalculated)   + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltCustomerDateRequested)    + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltShowFirstGrplineInBin)    + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltAutoGroupSingleJob)       + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltShowBatchGroupLinesInBin) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltShowContinueGroupLinesInBin) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_GroupedByCode) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_OverriddenTab) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltDependingOnNextHandledStep) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltDependingOnPrevHandledStep) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_filtDependingOnNextHandledLinkedRequest) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_filtDependingOnPrevHandledLinkedRequest) + ',';

  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_filtFixedEarlistDateFrom) +',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_filtFixedEarlistDateTo) +',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_filtFixedEarlistDateInDaysFrom) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_filtFixedEarlistDateInDaysTo) + ','; }
  for i := 1 to 60 do
  begin
    IAsStr := IntToStr(i);

    SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltPropCode) + IAsStr + ',';
   // SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_FiltPropRes) + IAsStr + ',';
    SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_filtPropValueFrom) + IAsStr + ',';
    if i < 60 then
      SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_filtPropValueTo) + IAsStr + ','
    else
      SQLStrings := SQLStrings + ':' + CreateFld(tbInfoFiltr.pfx, fli_filtPropValueTo) + IAsStr;
  end;
  SQLStrings := SQLStrings + ')';

  m_qryTabInsertFilterMaterial.SQL.Clear;
  m_qryTabInsertFilterMaterial.SQL.Add(SQLStrings);


  SQLStrings := '';
  SQLStrings := 'insert into ' + tbInfoColumn.GetTableName + '(';
  SQLStrings := SQLStrings + CreateFld(tbInfoColumn.pfx, fli_Identifier) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoColumn.pfx, fli_wkstCode) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoColumn.pfx, fli_TabsCode) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoColumn.pfx, fli_BinColField) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoColumn.pfx, fli_BinColTitle) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoColumn.pfx, fli_BinColPos) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoColumn.pfx, fli_BinColWidth) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoColumn.pfx, fli_BinColVisibl) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoColumn.pfx, fli_FiltPropCode) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoColumn.pfx, fli_BinColOrder) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoColumn.pfx, fli_BinColDescending) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoColumn.pfx, fli_BinColNumColSorted) + ',';
  SQLStrings := SQLStrings + CreateFld(tbInfoColumn.pfx, fli_TypeOfUse) + ')';

  SQLStrings := SQLStrings + ' values (';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoColumn.pfx, fli_Identifier) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoColumn.pfx, fli_wkstCode) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoColumn.pfx, fli_TabsCode) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoColumn.pfx, fli_BinColField) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoColumn.pfx, fli_BinColTitle) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoColumn.pfx, fli_BinColPos) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoColumn.pfx, fli_BinColWidth) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoColumn.pfx, fli_BinColVisibl) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoColumn.pfx, fli_FiltPropCode) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoColumn.pfx, fli_BinColOrder) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoColumn.pfx, fli_BinColDescending) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoColumn.pfx, fli_BinColNumColSorted) + ',';
  SQLStrings := SQLStrings + ':' + CreateFld(tbInfoColumn.pfx, fli_TypeOfUse);
  SQLStrings := SQLStrings + ')';

  m_qryTabInsertColumnsCfg.SQL.Clear;
  m_qryTabInsertColumnsCfg.SQL.add(SQLStrings);
//  m_qryTabInsertColumnsCfg.Prepare;

end;

//----------------------------------------------------------------------------//

procedure TFBin.MIDftValProdReqClick(Sender: TObject);
var
  Id : TSchedID;
begin
  Id := GetMouseSchedObj(false);
  if not CreateBinFilterCurrentValues(Id, TabReqProp, CSR_FullProdReq) then
    Exit;
end;

//----------------------------------------------------------------------------//

procedure TFBin.MIPropPlannerdefClick(Sender: TObject);
var
  PlannerPropDefine: TPlannerPropDefine;
  Id : TSchedID;
  tbs : TBinTabSheet;
  grid : TBinDrawGrid;
begin
  Id := GetMouseSchedObj(false);
  if id = CSchedIDnull then exit;

  tbs := TBinTabSheet(m_pgcBin.GetActiveView);
  if not Assigned(tbs) then exit;
  grid := tbs.GetBinGrid;
  if not Assigned(grid) or (grid.row < 1) then exit;
  if (p_sc.GetGroup(id) = CSchedIDnull) then
    id := tbs.m_BinPanel.m_objList.GetLink(grid.row-1);

  PlannerPropDefine := TPlannerPropDefine.CreatePlannerPropDefine(self, p_sc.GetProperties(ID,nil), ID);
  PlannerPropDefine.ShowModal;
  PlannerPropDefine.free;
end;

//----------------------------------------------------------------------------//

procedure TFBin.MiRemoveCurveCodeClick(Sender: TObject);
var
  Id            : TSchedId;
  CurveCode     : string;
  MqmActArea    : TMqmActArea;
  SchedList     : TMSchedList;
  BinGrid       : TBinDrawGrid;
  I : Integer;
  tab : TBinTabSheet;
  RefreshIsNeeded : boolean;
begin
  Id := GetMouseSchedObj(false);
  if Id = CSchedIDnull then
     Exit;

  tab := TBinTabSheet(m_pgcBin.ActivePage);
  BinGrid := tab.GetBinGrid;
  SchedList := BinGrid.GetSelectedList;

  RefreshIsNeeded := false;
  for i := 0 to SchedList.GetLinkCount - 1 do
  begin
    id := SchedList.GetLink(I);
    CurveCode := p_sc.GetLearningCurveCode(Id);
    if (CurveCode <> '') then
      p_sc.SetLearningCurveCode(Id,'');
    if Assigned(p_sc.GetExtLinkPtr(id)) then
        RefreshIsNeeded := true;
  end;

  if RefreshIsNeeded then//Assigned(p_sc.GetExtLinkPtr(id)) then
  begin
    for i := 0 to SchedList.GetLinkCount - 1 do
    begin
      id := SchedList.GetLink(I);
      MqmActArea := TMqmActArea(p_sc.GetExtLinkPtr(Id));
      if assigned(MqmActArea) then
        MqmActArea.ReorganizeAllOcc(true);
    end;
  end;

  if RefreshIsNeeded then
  begin
    FMQMPlan.RefreshActiveTab;
    ChangeTabBinforChangeTabPlan;
  end;

  RefreshGrid;
end;

//----------------------------------------------------------------------------//

procedure TFBin.MiRemoveJobsCalculatedLimitDatesClick(Sender: TObject);
var
  tbs       : TBinTabSheet;
  I, G      : Integer;
  Id, ChildId : TSchedId;
  Proprty   : TProperties;
  jobPropVal : variant;
  PropId    : TPropId;
  PropCode : string;
  DatesInfo: TSQDatesInfo;
  PlanInfo : TSQplanInfo;
  ForcesInfo: TSQForcesInfo;
  Save_Cursor : TCursor;
begin
  PropId := GetCalculatedHighDateProp;
  if PropId = nil then exit;
  PropCode := GetPropCodeFromID(PropId);
  tbs := TBinTabSheet(m_pgcBin.GetActiveView);
  if not Assigned(tbs) then exit;
  Save_Cursor   := Screen.Cursor;
  Screen.Cursor  := crAppStart; //SQLWait;
  for i := 0 to tbs.m_BinPanel.m_objList.GetLinkCount - 1 do
  begin
    id := tbs.m_BinPanel.m_objList.GetLink(i);
    if id = CSchedIdNull then break;
    p_sc.GetPlanInfo(id, PlanInfo);
    if (planInfo.VisibleInBin = CSB_ReadOnly) then continue;
    p_sc.GetForcesInfo(id, ForcesInfo);
 //   if (ForcesInfo.FrcHighestDate <> CSF_RequestedHighesEndDate) then continue;
    p_sc.GetDatesInfo(id, DatesInfo);
    p_sc.SetEarliestLatestDate(Id, 0, DatesInfo.HighEndDateTemp, true, true, false, CSF_RequestedHighesEndDate);
    p_sc.SetHighEndTimeLimitOverriden(Id, false);
    if DatesInfo.HighEndDateTemp > 0 then
       p_sc.SetHighEndTimeLimitCustomer(Id, CSD_Requested);
    if planInfo.isGroup then
    begin
      for G := 0 to p_sc.GetGrpNumSons(Id) - 1 do
      begin
        ChildId := p_sc.GetGrpSon(Id, G);
        Proprty := p_sc.GetProperties(ChildId,nil);
        Proprty.DeletFromList(PropCode);
        UpdateMainListPropChange(ChildId, PropCode, jobPropVal, true)
      end;
    end
    else
    begin
      Proprty := p_sc.GetProperties(ID,nil);
      Proprty.DeletFromList(PropCode);
      UpdateMainListPropChange(Id, PropCode, jobPropVal, true)
    end;
  end;
  FMQMPlan.RefreshActiveTab;
  Fbin.RefreshGrid;
  Screen.Cursor := Save_Cursor;
end;

//----------------------------------------------------------------------------//

procedure TFBin.MiReturnOriginalPlantWcClick(Sender: TObject);
var
  i, G   : integer;
  tbs : TBinTabSheet;
  id, ChildId  : TSchedId;
  WC  : TMqmWrkCtr;
  planInfo: TSQplanInfo;
begin
  tbs := TBinTabSheet(m_pgcBin.GetActiveView);
  if not Assigned(tbs) then exit;
  for i := 0 to tbs.m_BinPanel.m_objList.GetLinkCount - 1 do
  begin
    id := tbs.m_BinPanel.m_objList.GetLink(i);
    if id = CSchedIdNull then break;
    WC := TMqmWrkCtr(p_sc.GetWrkCtrPtr(Id));
    if Assigned(WC) then
    begin
      p_sc.GetPlanInfo(id, planInfo);
      if planInfo.isGroup then
      begin
        for G := 0 to p_sc.GetGrpNumSons(Id) - 1 do
        begin
          ChildId := p_sc.GetGrpSon(Id, G);
          p_sc.SetWcenterToOriginal(ChildId)
        end;
      end
      else
        p_sc.SetWcenterToOriginal(Id);
    end
  end;
  ChangeTabBinforChangeTabPlan;
end;

//----------------------------------------------------------------------------//

procedure TFBin.MiReturnOriginalPlantWorkCenterClick(Sender: TObject);
var
  i, G, JobsInBinCount   : integer;
  tbs : TBinTabSheet;
  id, ChildId  : TSchedId;
  WC  : TMqmWrkCtr;
  planInfo: TSQplanInfo;
  BinGrid : TBinDrawGrid;
  SchedList: TMSchedList;
begin
  tbs := TBinTabSheet(m_pgcBin.GetActiveView);
  if not Assigned(tbs) then exit;
  BinGrid := tbs.GetBinGrid;
  SchedList := TMSchedList.Create(self);
  if BinGrid.pSelectedMarked then
    SchedList := BinGrid.GetSelectedList
  else
    SchedList.AddLink(GetMouseSchedObj(false));
  JobsInBinCount := SchedList.GetLinkCount;
  for i := (JobsInBinCount - 1) downto 0 do
  begin
    id := SchedList.GetLink(I);
    if id = CSchedIdNull then break;
    WC := TMqmWrkCtr(p_sc.GetWrkCtrPtr(Id));
    if Assigned(WC) then
    begin
      p_sc.GetPlanInfo(id, planInfo);
      if planInfo.isGroup then
      begin
        for G := 0 to p_sc.GetGrpNumSons(Id) - 1 do
        begin
          ChildId := p_sc.GetGrpSon(Id, G);
          p_sc.SetWcenterToOriginal(ChildId)
        end;
      end;
    end
    else
      p_sc.SetWcenterToOriginal(Id);
  end;
  ChangeTabBinforChangeTabPlan;
end;

//----------------------------------------------------------------------------//

procedure TFBin.MIAlterWorkCenterAndSplitAccordingToMcmClick(Sender: TObject);
var
  Id      : TSchedId;
  BinGrid : TBinDrawGrid;
  tab     : TBinTabSheet;
  SchedList : TMSchedList;
  PlanInfo : TSQplanInfo;
  JobsInBinCount, I : Integer;
begin
  tab := TBinTabSheet(m_pgcBin.ActivePage);
  BinGrid := tab.GetBinGrid;
  SchedList := BinGrid.GetSelectedList;
  JobsInBinCount := SchedList.GetLinkCount;
  for i := (JobsInBinCount - 1) downto 0 do
  begin
    id := SchedList.GetLink(I);
    if id = CSchedIdNull then continue;
    p_sc.GetPlanInfo(id, planInfo);
    if planInfo.SplitFromMcmToMqmAndAlterWorkCenter then
    begin
      if (p_sc.GetJobNumBrothers(Id) = 1) and (CProgress(p_sc.IsProgressed(Id)) = prg_none) and
          (not Assigned(p_sc.GetExtLinkPtr(id))) then
      begin
        SplitMqmAccordingToMcm(id, p_sc.GetMcmSplitListToSplitMqm(id));
      end;
    end;
  end;

  if SchedList.GetLinkCount > 0 then
  begin
    for I := 0 to BinGrid.RowCount - 1 do
       BinGrid.ForceUnselected(I);
  end;

  FMQMPlan.RefreshActiveTab;
  ChangeTabBinforChangeTabPlan;
end;

//----------------------------------------------------------------------------//

procedure TFBin.MISplitJobsByStepNumberOfMachinesClick(Sender: TObject);
var
  tab : TBinTabSheet;
  Index : integer;
  ObjList, NewIdsList : TMSchedList;
  tbs : TBinTabSheet;
  BinGrid : TBinDrawGrid;
begin
  p_opStack.MarkStackForButtonUndo(_('split before proceeding'));
  tbs := TBinTabSheet(m_pgcBin.GetActiveView);
  BinGrid := tbs.GetBinGrid;

  ObjList := TMSchedList.Create(self);
  if BinGrid.pSelectedMarked Or IsAutoRunMode then
  begin
    if IsAutoRunMode then
      ObjList := BinGrid.GetAllAsSelectedForAutoRun
    else
      ObjList := BinGrid.GetSelectedList
  end
  else
  begin
    ObjList.AddLink(GetMouseSchedObj(false));
    Index := tbs.m_BinPanel.m_objList.IndexOf(GetMouseSchedObj(false));
    tbs.m_BinPanel.p_Grid.ForceSelected(Index);
  end;

  NewIdsList := TMSchedList.Create(self);
  CheckSplitBeforeSchedule(ObjList, true, NewIdsList, false);
  tbs.m_BinPanel.UpdateForChangeFilter;
  NewIdsList.Free;
  FMQMPlan.ActiveUndo;
end;

//----------------------------------------------------------------------------//

Procedure TFbin.CreateTempSeqTab(resCode : string);
var
  ObjList: TMSchedList;
  I, Index : Integer;
  BinGrid : TBinDrawGrid;
  Id : TSchedId;
  NewIdsList : TMSchedList;
  tab : TBinTabSheet;
  Cfg : TBinTabCfg;
  Title : string;
  ParmsFilt : TBinParms;
  dataType : CBinColValType;
begin
  tab := SequenceTabOpened;
  Title := DBAppSettings.SuggestedTextTabJobSequence;
  if Title = '' then
     Title := _('Schedule Sequence');
  Title := '   ' + Title + '   ';
  if tab = nil then
  begin
    Cfg := m_TbCfg.AddNewTab(Title, m_TbCfg.FindNewCode, false, false);
    ParmsFilt := TBinParms.Create;
    ParmsFilt.P_GroupedByCode := '';

    if DBAppSettings.ShowScheduledJobsOfSelectedResource = ShowS_No then
    begin
      Exclude(ParmsFilt.RecFilt.Options, FiltSchedJobs);
      Exclude(ParmsFilt.RecFilt.Options, FiltOnlySchedJobs)
    end
    else
    begin
      Exclude(ParmsFilt.RecFilt.Options, FiltSchedJobs);
      Include(ParmsFilt.RecFilt.Options, FiltOnlySchedJobs);
    end;

    Exclude(ParmsFilt.RecFilt.Options, FiltProgress);
    Exclude(ParmsFilt.RecFilt.Options, FiltOnlyProgress);
    Include(ParmsFilt.RecFilt.Options, FiltFltJobsOnGantt);
    tab := TBinTabSheet.CreateBinTbs(m_pgcBin, PopUpBin, p_sc,
                         BT_Main, FncFilterStep, ParmsFilt, true, Cfg.code, true);
    Cfg.ParmFilt := ParmsFilt;
    CopyBinDefaultSequence(tab.m_BinPanel.p_Grid.BinColumnSet);
    tab.P_JobScheduleBySequenceTab := true;
    tab.SetCode(Cfg.code);
    tab.m_BinPanel.GetFiltParms.P_OverriddenTab := false;
    tab.TabVisible := true;
    tab.Caption    := Title;
    BinGrid := tab.GetBinGrid;
  end
  else
  begin
    Cfg := TBinTabCfg(m_TbCfg.FindTab(tab.GetCode));
    m_pgcBin.SetActiveViewBin(tab.GetCode);
    tab := GetActiveView;
    BinGrid := tab.GetBinGrid;
    BinGrid.Clear_Job_Sequence_List;
  end;

  tab.Caption    := Title;
  tab.m_BinPanel.GetFiltParms.P_SeqFilter := true;

  if DBAppSettings.ShowScheduledJobsOfSelectedResource = ShowS_Yes then
  begin
    Include(tab.m_BinPanel.GetFiltParms.RecFilt.Options, FiltResource);
    tab.m_BinPanel.GetFiltParms.RecFilt.Resource := resCode;
    Include(tab.m_BinPanel.GetFiltParms.RecFilt.Options, FiltResourceTo);
    tab.m_BinPanel.GetFiltParms.RecFilt.ResourceTo := resCode
  end;

  tab.m_BinPanel.UpdateForChangeFilter;
  Cfg.SaveArrayBinCol(Tab.GetBinGrid.BinColumnSet);

  BinGrid.Refresh;
  m_pgcBin.ActivePage := tab;
end;

//----------------------------------------------------------------------------//

procedure TFBin.MIStartAutoSchedCurrentCfgClick(Sender: TObject);
var
  ObjList: TMSchedList;
  I, Index : Integer;
  tbs : TBinTabSheet;
  BinGrid : TBinDrawGrid;
  Id : TSchedId;
  NewIdsList : TMSchedList;

  tab : TBinTabSheet;
  Cfg : TBinTabCfg;
  Title : string;
  ParmsFilt : TBinParms;
begin
  AutoSchedCfg.m_WithoutStack := false;
  if not DBAppGlobals.MCM_App then
  begin
    AutoSchedCfg.m_OverridingParams_Activated := false;
  end
  else
  begin
    if TMenuItem(Sender).name <> 'MiSelectedJobOverridingParams' then
       AutoSchedCfg.m_OverridingParams_Activated := false;
  end;

  AutoSchedCfg.m_ScheduleByWorkCenterCfg := false;
  AutoSchedCfg.m_AllowedMoveLinkedReq    := false;
  p_sc.CleanAllAutoSeqTakePart;

  if TMenuItem(Sender).name = 'MIStartAutoSchedWcCfg' then
  begin
    if not CheckCfgDefinitionForAllWorkCenters then
    begin
      ShowMessage(_('Please define first all work centers in Automatic sequencing configuration'));
      exit
    end;
    AutoSchedCfg.m_ScheduleByWorkCenterCfg := true;
  end;

  if AutoSchedCfg.m_OverridingParams_Activated then
  begin
    if AutoSchedCfg.m_OverridingParams_ScheduleByWorkCenterCfg then
      AutoSchedCfg.m_ScheduleByWorkCenterCfg := true;
    if AutoSchedCfg.m_OverridingParams_AllowedMoveLinkedReq then
      AutoSchedCfg.m_AllowedMoveLinkedReq := true;
  end;

  tbs := TBinTabSheet(m_pgcBin.GetActiveView);
  BinGrid := tbs.GetBinGrid;

  ObjList := TMSchedList.Create(self);
  if BinGrid.pSelectedMarked Or IsAutoRunMode then
  begin
    if IsAutoRunMode then
      ObjList := BinGrid.GetAllAsSelectedForAutoRun
    else
      ObjList := BinGrid.GetSelectedList
  end
  else
  begin
    ObjList.AddLink(GetMouseSchedObj(false));
    Index := tbs.m_BinPanel.m_objList.IndexOf(GetMouseSchedObj(false));
    tbs.m_BinPanel.p_Grid.ForceSelected(Index);
  end;

  if IsSplitRunMode then
  begin
    NewIdsList := TMSchedList.Create(self);
    if CheckSplitBeforeSchedule(ObjList, true, NewIdsList, false) then
       tbs.m_BinPanel.UpdateForChangeFilter;
    NewIdsList.Free;
  end
  else if IsAutoRunMode then
  begin
    PrepareAutoSeqList(ObjList);
  end
  else
  begin
    {NewIdsList := TMSchedList.Create(self);
    if CheckSplitBeforeSchedule(ObjList, true, NewIdsList) then
    begin
      tbs.m_BinPanel.UpdateForChangeFilter;

      if NewIdsList.GetLinkCount > 0 then
      for I := 0 to NewIdsList.GetLinkCount - 1 do
      begin
        Index := tbs.m_BinPanel.m_objList.IndexOf(NewIdsList.GetLink(I));
        if Index > -1 then
          tbs.m_BinPanel.p_Grid.ForceSelected(Index);
      end;

      for I := 0 to ObjList.GetLinkCount - 1 do
      begin
        Index := tbs.m_BinPanel.m_objList.IndexOf(ObjList.GetLink(I));
        tbs.m_BinPanel.p_Grid.ForceSelected(Index);
      end;
      tbs.m_BinPanel.p_Grid.Refresh;

      NewIdsList.Free;
    end;  }

    ObjList.ClearList;
    ObjList := BinGrid.GetSelectedList;

    for I := 0 to ObjList.GetLinkCount - 1 do
      p_sc.SetAutoSeqTakePart(ObjList.GetLink(I), true);

    tbs.m_BinPanel.p_Grid.SetButtonMouse(mbLeft);
    PrepareAutoSeqList(ObjList);
  end;

  ///////////////////////////

  Title := _('   Auto sequence final    ');
  tab := AutoSequenceResultsTabOpend;
  if tab = nil then
  begin
    Cfg := m_TbCfg.AddNewTab(Title, m_TbCfg.FindNewCode, false, false);
    ParmsFilt := TBinParms.Create;
    ParmsFilt.P_GroupedByCode := '';
    tab := TBinTabSheet.CreateBinTbs(m_pgcBin, PopUpBin, p_sc,
                         BT_Main, FncFilterStep, ParmsFilt, true, Cfg.code, true);
    CopyBinDefaultTabAutoSeqResults(tab.m_BinPanel.p_Grid.BinColumnSet);
    tab.p_AutoSequenceResultsTab := true;
    tab.SetAutoSequenceResultsIconForTab;
    tab.SetCode(Cfg.code);
    tab.m_BinPanel.GetFiltParms.P_OverriddenTab := false;
    tab.TabVisible := true;
    tab.Caption    := Title
  end
  else
  begin
    Cfg := TBinTabCfg(m_TbCfg.FindTab(tab.GetCode));
  end;

  tab.Caption    := Title;
  tab.m_BinPanel.GetFiltParms.RecFilt.Options := [];
  tab.m_BinPanel.GetFiltParms.P_AutoSeqResultFilter := true;
  ClearFilterParams(tab.m_BinPanel.GetFiltParms.RecFilt.Options , tab.m_BinPanel.GetFiltParms, Tb_AutoSeqResults);
  tab.m_BinPanel.UpdateForChangeFilter;
  Cfg.SaveArrayBinCol(Tab.GetBinGrid.BinColumnSet);
  m_pgcBin.ActivePage := tbs;

  //////////////////////////
end;

procedure TFBin.MIStartAutoSchedWcCfgClick(Sender: TObject);
begin
  MIStartAutoSchedCurrentCfgClick(MIStartAutoSchedWcCfg)
end;

//----------------------------------------------------------------------------//

procedure TFBin.SET_Conf_Lvl_AutoRun(Lvl : string);
var
  i   : integer;
  tbs : TBinTabSheet;
  id  : TSchedId;
  planInfo: TSQplanInfo;
  BinGrid : TBinDrawGrid;
begin
  tbs := TBinTabSheet(m_pgcBin.GetActiveView);
  if not Assigned(tbs) then exit;
  BinGrid := tbs.GetBinGrid;
//  if IsAutoRunMode then
//    BinGrid.SetAllSelected;

  for i := 0 to tbs.m_BinPanel.m_objList.GetLinkCount -1 do
  begin
    id := tbs.m_BinPanel.m_objList.GetLink(i);
    if id = CSchedIdNull then break;
    p_sc.GetPlanInfo(Id, planInfo);
    if (planInfo.VisibleInBin = CSB_ReadOnly) then continue;

    if Lvl = '5' then
      p_opStack.SetSchedType(id, '7')
    else if Lvl = '4' then
      p_opStack.SetSchedType(id, '6')
    else if Lvl = '3' then
      p_opStack.SetSchedType(id, '5')
    else if Lvl = '2' then
      p_opStack.SetSchedType(id, '4')
    else if Lvl = '1' then
      p_opStack.SetSchedType(id, '3')
    else if Lvl = 'Final' then
      p_opStack.SetSchedType(id, '2')
    else if Lvl = 'Initial' then
      p_opStack.SetSchedType(id, '1')

  end;

  FMQMPlan.RefreshActiveTab;
  ChangeTabBinforChangeTabPlan;
end;

//----------------------------------------------------------------------------//

procedure TFBin.FilterJobsWcGroupByDate(Wcntr : pointer; lngDscDayWeekMonth : string; SchedStart : TDateTime; SchedEnd : TDateTime);
var
  tab  : TBinTabSheet;
  CurrentTb : TMqmPlanTabSheet;
  Cfg : TBinTabCfg;
  CurrentCFg : TPlanTabCfg;
  Title, GrpName : string;
  ParmsFilt : TBinParms;
begin

  CurrentTb := GetPlanView.GetActiveTab;
  CurrentCFg := TPlanTabCfg(GetPlanView.m_planTbCfg.FindTab(CurrentTb.GetCode));

  if CurrentCFg.m_SlotGroup = 0 then
    exit
  else if CurrentCFg.m_SlotGroup = 1 then
    GrpName := TMqmWrkCtr(Wcntr).P_WcGrp
  else if CurrentCFg.m_SlotGroup = 2 then
    GrpName := TMqmWrkCtr(Wcntr).p_PlantCode
   else if CurrentCFg.m_SlotGroup = 3 then
    GrpName := TMqmWrkCtr(Wcntr).p_Division;

  Title := 'Group : '+GrpName + ' - ' + lngDscDayWeekMonth;
  tab := SlotFilterByDatesTabOpened;
  if tab = nil then
  begin
    Cfg := m_TbCfg.AddNewTab(Title, m_TbCfg.FindNewCode, false, false);
    ParmsFilt := TBinParms.Create;
    ParmsFilt.P_GroupedByCode := '';
    tab := TBinTabSheet.CreateBinTbs(m_pgcBin, PopUpBin, p_sc,
                         BT_Main, FncFilterStep, ParmsFilt, true, Cfg.code, true);
    CopyBinDefaultTabSlotFilter(tab.m_BinPanel.p_Grid.BinColumnSet);
    tab.p_SlotFilterByDatesTab := true;
    tab.SetSlotFilterByDatesIconForTab;
    tab.SetCode(Cfg.code);
    tab.m_BinPanel.GetFiltParms.P_OverriddenTab := false;
    tab.TabVisible := true;
    tab.Caption    := Title
  end
  else
  begin
    Cfg := TBinTabCfg(m_TbCfg.FindTab(tab.GetCode));
  end;

  tab.Caption    := '   ' + Title + '   ';//Title;
  tab.m_BinPanel.GetFiltParms.RecFilt.Options := [];
  ClearFilterParams(tab.m_BinPanel.GetFiltParms.RecFilt.Options , tab.m_BinPanel.GetFiltParms, Tb_FilterSloteBydate);

  if CurrentCFg.m_SlotGroup = 1 then
  begin
    tab.m_BinPanel.GetFiltParms.RecFilt.wkCtrGroup := GrpName;
    Include(tab.m_BinPanel.GetFiltParms.RecFilt.Options, FiltWkcrGrp);
  end else
  if CurrentCFg.m_SlotGroup = 2 then
  begin
    tab.m_BinPanel.GetFiltParms.RecFilt.wkCtrPlant := GrpName;
    Include(tab.m_BinPanel.GetFiltParms.RecFilt.Options, FiltWkcrPlant);
  end else
  if CurrentCFg.m_SlotGroup = 3 then
  begin
    tab.m_BinPanel.GetFiltParms.RecFilt.wkCtrDivision := GrpName;
    Include(tab.m_BinPanel.GetFiltParms.RecFilt.Options, FiltWkcrDivision);
  end;
 //Include(tab.m_BinPanel.GetFiltParms.RecFilt.Options, FiltWkcr);
  tab.m_BinPanel.GetFiltParms.RecFilt.ScheduleJobsCrosses_From := SchedStart;
  tab.m_BinPanel.GetFiltParms.RecFilt.ScheduleJobsCrosses_To := SchedEnd;
  include(tab.m_BinPanel.GetFiltParms.RecFilt.Options, FiltScheduledJobsCrossesDateTime);
  tab.m_BinPanel.UpdateForChangeFilter;
  Cfg.SaveArrayBinCol(Tab.GetBinGrid.BinColumnSet);
  m_pgcBin.ActivePage := tab;
end;

// -------------------------------------------------------------------------- //

procedure TFBin.FilterJobsWcGroupPropertyByDate(Wcntr : pointer; lngDscDayWeekMonth : string; Propcode : string; PropValue : string; SchedStart : TDateTime; SchedEnd : TDateTime);
var
  tab  : TBinTabSheet;
  CurrentTb : TMqmPlanTabSheet;
  Cfg : TBinTabCfg;
  CurrentCFg : TPlanTabCfg;
  Title, GrpName : string;
  ParmsFilt : TBinParms;
begin
  CurrentTb := GetPlanView.GetActiveTab;
  CurrentCFg := TPlanTabCfg(GetPlanView.m_planTbCfg.FindTab(CurrentTb.GetCode));

  if CurrentCFg.m_SlotGroup = 0 then
    exit
  else if CurrentCFg.m_SlotGroup = 1 then
    GrpName := TMqmWrkCtr(Wcntr).P_WcGrp
  else if CurrentCFg.m_SlotGroup = 2 then
    GrpName := TMqmWrkCtr(Wcntr).p_PlantCode
  else if CurrentCFg.m_SlotGroup = 3 then
    GrpName := TMqmWrkCtr(Wcntr).p_Division;

  Title := 'Group : ' + GrpName + ' ' + PropValue + ' - ' + lngDscDayWeekMonth;
  tab := SlotFilterByDatesTabOpened;
  if tab = nil then
  begin
    Cfg := m_TbCfg.AddNewTab(Title, m_TbCfg.FindNewCode, false, false);
    ParmsFilt := TBinParms.Create;
    ParmsFilt.P_GroupedByCode := '';
    tab := TBinTabSheet.CreateBinTbs(m_pgcBin, PopUpBin, p_sc,
                         BT_Main, FncFilterStep, ParmsFilt, true, Cfg.code, true);
    CopyBinDefaultTabSlotFilter(tab.m_BinPanel.p_Grid.BinColumnSet);
    tab.p_SlotFilterByDatesTab := true;
    tab.SetSlotFilterByDatesIconForTab;
    tab.SetCode(Cfg.code);
    tab.m_BinPanel.GetFiltParms.P_OverriddenTab := false;
    tab.TabVisible := true;
    tab.Caption    := Title
  end
  else
  begin
    Cfg := TBinTabCfg(m_TbCfg.FindTab(tab.GetCode));
  end;

  tab.Caption    := '   ' + Title + '   ';
  tab.m_BinPanel.GetFiltParms.RecFilt.Options := [];
  ClearFilterParams(tab.m_BinPanel.GetFiltParms.RecFilt.Options, tab.m_BinPanel.GetFiltParms, Tb_FilterSloteBydate);

  // set group filter (division/plant/WCGroup)
  if CurrentCFg.m_SlotGroup = 1 then
  begin
    tab.m_BinPanel.GetFiltParms.RecFilt.wkCtrGroup := GrpName;
    Include(tab.m_BinPanel.GetFiltParms.RecFilt.Options, FiltWkcrGrp);
  end else
  if CurrentCFg.m_SlotGroup = 2 then
  begin
    tab.m_BinPanel.GetFiltParms.RecFilt.wkCtrPlant := GrpName;
    Include(tab.m_BinPanel.GetFiltParms.RecFilt.Options, FiltWkcrPlant);
  end else
  if CurrentCFg.m_SlotGroup = 3 then
  begin
    tab.m_BinPanel.GetFiltParms.RecFilt.wkCtrDivision := GrpName;
    Include(tab.m_BinPanel.GetFiltParms.RecFilt.Options, FiltWkcrDivision);
  end;

  // set date filter
  tab.m_BinPanel.GetFiltParms.RecFilt.ScheduleJobsCrosses_From := SchedStart;
  tab.m_BinPanel.GetFiltParms.RecFilt.ScheduleJobsCrosses_To := SchedEnd;
  include(tab.m_BinPanel.GetFiltParms.RecFilt.Options, FiltScheduledJobsCrossesDateTime);

  // set property filter
  tab.m_BinPanel.GetFiltParms.ClearFiltPropList;
  tab.m_BinPanel.GetFiltParms.ClearPropRecFields;
  tab.m_BinPanel.GetFiltParms.RecFilt.PropCod[1] := Propcode;
  tab.m_BinPanel.GetFiltParms.RecFilt.PropValfrom[1] := PropValue;
  tab.m_BinPanel.GetFiltParms.RecFilt.PropValTo[1] := PropValue;
  Include(tab.m_BinPanel.GetFiltParms.RecFilt.Options, FiltProp);
  tab.m_BinPanel.GetFiltParms.SetPropValue(Propcode, '', PropValue, PropValue);
  tab.m_BinPanel.GetFiltParms.RecFilt.IsPropEnter := true;
  include(tab.m_BinPanel.GetFiltParms.RecFilt.Options, FiltProp);
  tab.m_BinPanel.GetFiltParms.P_SetListOnProp := false;

  tab.m_BinPanel.UpdateForChangeFilter;
  Cfg.SaveArrayBinCol(Tab.GetBinGrid.BinColumnSet);
  m_pgcBin.ActivePage := tab;
end;

//----------------------------------------------------------------------------//

procedure TFBin.FilterJobsWcGroupCategoryByDate(Wcntr : pointer; lngDscDayWeekMonth : string; ResCatCode : string; SchedStart : TDateTime; SchedEnd : TDateTime);
var
  tab  : TBinTabSheet;
  CurrentTb : TMqmPlanTabSheet;
  Cfg : TBinTabCfg;
  CurrentCFg : TPlanTabCfg;
  Title, GrpName : string;
  ParmsFilt : TBinParms;
begin
  CurrentTb := GetPlanView.GetActiveTab;
  CurrentCFg := TPlanTabCfg(GetPlanView.m_planTbCfg.FindTab(CurrentTb.GetCode));

  if CurrentCFg.m_SlotGroup = 0 then
    exit
  else if CurrentCFg.m_SlotGroup = 1 then
    GrpName := TMqmWrkCtr(Wcntr).P_WcGrp
  else if CurrentCFg.m_SlotGroup = 2 then
    GrpName := TMqmWrkCtr(Wcntr).p_PlantCode
  else if CurrentCFg.m_SlotGroup = 3 then
    GrpName := TMqmWrkCtr(Wcntr).p_Division;

  Title := 'Group : ' + GrpName + ' ' + ResCatCode + ' - ' + lngDscDayWeekMonth;
  tab := SlotFilterByDatesTabOpened;
  if tab = nil then
  begin
    Cfg := m_TbCfg.AddNewTab(Title, m_TbCfg.FindNewCode, false, false);
    ParmsFilt := TBinParms.Create;
    ParmsFilt.P_GroupedByCode := '';
    tab := TBinTabSheet.CreateBinTbs(m_pgcBin, PopUpBin, p_sc,
                         BT_Main, FncFilterStep, ParmsFilt, true, Cfg.code, true);
    CopyBinDefaultTabSlotFilter(tab.m_BinPanel.p_Grid.BinColumnSet);
    tab.p_SlotFilterByDatesTab := true;
    tab.SetSlotFilterByDatesIconForTab;
    tab.SetCode(Cfg.code);
    tab.m_BinPanel.GetFiltParms.P_OverriddenTab := false;
    tab.TabVisible := true;
    tab.Caption    := Title
  end
  else
  begin
    Cfg := TBinTabCfg(m_TbCfg.FindTab(tab.GetCode));
  end;

  tab.Caption    := '   ' + Title + '   ';
  tab.m_BinPanel.GetFiltParms.RecFilt.Options := [];
  ClearFilterParams(tab.m_BinPanel.GetFiltParms.RecFilt.Options, tab.m_BinPanel.GetFiltParms, Tb_FilterSloteBydate);

  // set group filter (division/plant/WCGroup)
  if CurrentCFg.m_SlotGroup = 1 then
  begin
    tab.m_BinPanel.GetFiltParms.RecFilt.wkCtrGroup := GrpName;
    Include(tab.m_BinPanel.GetFiltParms.RecFilt.Options, FiltWkcrGrp);
  end else
  if CurrentCFg.m_SlotGroup = 2 then
  begin
    tab.m_BinPanel.GetFiltParms.RecFilt.wkCtrPlant := GrpName;
    Include(tab.m_BinPanel.GetFiltParms.RecFilt.Options, FiltWkcrPlant);
  end else
  if CurrentCFg.m_SlotGroup = 3 then
  begin
    tab.m_BinPanel.GetFiltParms.RecFilt.wkCtrDivision := GrpName;
    Include(tab.m_BinPanel.GetFiltParms.RecFilt.Options, FiltWkcrDivision);
  end;

  // set date filter
  tab.m_BinPanel.GetFiltParms.RecFilt.ScheduleJobsCrosses_From := SchedStart;
  tab.m_BinPanel.GetFiltParms.RecFilt.ScheduleJobsCrosses_To := SchedEnd;
  include(tab.m_BinPanel.GetFiltParms.RecFilt.Options, FiltScheduledJobsCrossesDateTime);

  // set resource category filter
  tab.m_BinPanel.GetFiltParms.RecFilt.ResCatCode := ResCatCode;
  Include(tab.m_BinPanel.GetFiltParms.RecFilt.Options, FiltResCat);

  tab.m_BinPanel.UpdateForChangeFilter;
  Cfg.SaveArrayBinCol(Tab.GetBinGrid.BinColumnSet);
  m_pgcBin.ActivePage := tab;
end;

//----------------------------------------------------------------------------//

procedure TFBin.FilterJobsWcByDate(Wcntr : pointer; lngDscDayWeekMonth : string; SchedStart : TDateTime; SchedEnd : TDateTime);
var
  tab : TBinTabSheet;
  Cfg : TBinTabCfg;
  Title : string;
  ParmsFilt : TBinParms;
begin
  Title := TMqmWrkCtr(Wcntr).p_WrkCtrCode + ' ' + lngDscDayWeekMonth;
  tab := SlotFilterByDatesTabOpened;
  if tab = nil then
  begin
    Cfg := m_TbCfg.AddNewTab(Title, m_TbCfg.FindNewCode, false, false);
    ParmsFilt := TBinParms.Create;
    ParmsFilt.P_GroupedByCode := '';
    tab := TBinTabSheet.CreateBinTbs(m_pgcBin, PopUpBin, p_sc,
                         BT_Main, FncFilterStep, ParmsFilt, true, Cfg.code, true);
    CopyBinDefaultTabSlotFilter(tab.m_BinPanel.p_Grid.BinColumnSet);
    tab.p_SlotFilterByDatesTab := true;
    tab.SetSlotFilterByDatesIconForTab;
    tab.SetCode(Cfg.code);
    tab.m_BinPanel.GetFiltParms.P_OverriddenTab := false;
    tab.TabVisible := true;
    tab.Caption    := Title
  end
  else
  begin
    Cfg := TBinTabCfg(m_TbCfg.FindTab(tab.GetCode));
  end;

  tab.Caption    := '   ' + Title + '   ';//Title;
  tab.m_BinPanel.GetFiltParms.RecFilt.Options := [];
  ClearFilterParams(tab.m_BinPanel.GetFiltParms.RecFilt.Options , tab.m_BinPanel.GetFiltParms, Tb_FilterSloteBydate);
  tab.m_BinPanel.GetFiltParms.RecFilt.wkCtrCode := TMqmWrkCtr(Wcntr).p_WrkCtrCode;
  Include(tab.m_BinPanel.GetFiltParms.RecFilt.Options, FiltWkcr);
  tab.m_BinPanel.GetFiltParms.RecFilt.ScheduleJobsCrosses_From := SchedStart;
  tab.m_BinPanel.GetFiltParms.RecFilt.ScheduleJobsCrosses_To := SchedEnd;
  include(tab.m_BinPanel.GetFiltParms.RecFilt.Options, FiltScheduledJobsCrossesDateTime);
  tab.m_BinPanel.UpdateForChangeFilter;
  Cfg.SaveArrayBinCol(Tab.GetBinGrid.BinColumnSet);
  m_pgcBin.ActivePage := tab;
end;

// -------------------------------------------------------------------------- //

procedure TFBin.FilterJobsWcPropertyByDate(Wcntr : pointer; lngDscDayWeekMonth : string; Propcode : string; PropValue : string; SchedStart : TDateTime; SchedEnd : TDateTime);
var
  tab : TBinTabSheet;
  Cfg : TBinTabCfg;
  Title : string;
  ParmsFilt : TBinParms;
begin
  Title := TMqmWrkCtr(Wcntr).p_WrkCtrCode + ' ' + lngDscDayWeekMonth;
  tab := SlotFilterByDatesTabOpened;
  if tab = nil then
  begin
    Cfg := m_TbCfg.AddNewTab(Title, m_TbCfg.FindNewCode, false, false);
    ParmsFilt := TBinParms.Create;
    ParmsFilt.P_GroupedByCode := '';
    tab := TBinTabSheet.CreateBinTbs(m_pgcBin, PopUpBin, p_sc,
                         BT_Main, FncFilterStep, ParmsFilt, true, Cfg.code, true);
    tab.p_SlotFilterByDatesTab := true;
    tab.SetSlotFilterByDatesIconForTab;
    tab.SetCode(Cfg.code);
    tab.m_BinPanel.GetFiltParms.P_OverriddenTab := false;
    tab.TabVisible := true;
    tab.Caption    := Title
  end
  else
  begin
    Cfg := TBinTabCfg(m_TbCfg.FindTab(tab.GetCode));
  end;

  tab.Caption    := '   ' + Title + '   ';//Title;
  m_pgcBin.ActivePage := tab;
  tab.m_BinPanel.GetFiltParms.RecFilt.Options := [];
  ClearFilterParams(tab.m_BinPanel.GetFiltParms.RecFilt.Options , tab.m_BinPanel.GetFiltParms, Tb_FilterSloteBydate);
  tab.m_BinPanel.GetFiltParms.RecFilt.wkCtrCode := TMqmWrkCtr(Wcntr).p_WrkCtrCode;
  Include(tab.m_BinPanel.GetFiltParms.RecFilt.Options, FiltWkcr);
  tab.m_BinPanel.GetFiltParms.RecFilt.ScheduleJobsCrosses_From := SchedStart;
  tab.m_BinPanel.GetFiltParms.RecFilt.ScheduleJobsCrosses_To := SchedEnd;
  include(tab.m_BinPanel.GetFiltParms.RecFilt.Options, FiltScheduledJobsCrossesDateTime);
  tab.m_BinPanel.GetFiltParms.ClearFiltPropList;
  tab.m_BinPanel.GetFiltParms.ClearPropRecFields;
  tab.m_BinPanel.GetFiltParms.RecFilt.PropCod[1] := Propcode;
  tab.m_BinPanel.GetFiltParms.RecFilt.PropValfrom[1] := PropValue;
  tab.m_BinPanel.GetFiltParms.RecFilt.PropValTo[1] := PropValue;
  Include(tab.m_BinPanel.GetFiltParms.RecFilt.Options, FiltProp);
  tab.m_BinPanel.GetFiltParms.SetPropValue(Propcode, '', PropValue, PropValue);
  tab.m_BinPanel.GetFiltParms.RecFilt.IsPropEnter := true;
  include(tab.m_BinPanel.GetFiltParms.RecFilt.Options, FiltProp);
  tab.m_BinPanel.GetFiltParms.P_SetListOnProp := false;
  tab.m_BinPanel.UpdateForChangeFilter;
  Cfg.SaveArrayBinCol(Tab.GetBinGrid.BinColumnSet);

end;

// -------------------------------------------------------------------------- //

procedure TFBin.FilterJobsWcCategoryByDate(Wcntr : pointer; lngDscDayWeekMonth : string; ResCatCode : string; SchedStart : TDateTime; SchedEnd : TDateTime);
var
  tab : TBinTabSheet;
  Cfg : TBinTabCfg;
  Title : string;
  ParmsFilt : TBinParms;
begin
  Title := TMqmWrkCtr(Wcntr).p_WrkCtrCode + ' ' + ResCatCode + ' - ' + lngDscDayWeekMonth;
  tab := SlotFilterByDatesTabOpened;
  if tab = nil then
  begin
    Cfg := m_TbCfg.AddNewTab(Title, m_TbCfg.FindNewCode, false, false);
    ParmsFilt := TBinParms.Create;
    ParmsFilt.P_GroupedByCode := '';
    tab := TBinTabSheet.CreateBinTbs(m_pgcBin, PopUpBin, p_sc,
                         BT_Main, FncFilterStep, ParmsFilt, true, Cfg.code, true);
    CopyBinDefaultTabSlotFilter(tab.m_BinPanel.p_Grid.BinColumnSet);
    tab.p_SlotFilterByDatesTab := true;
    tab.SetSlotFilterByDatesIconForTab;
    tab.SetCode(Cfg.code);
    tab.m_BinPanel.GetFiltParms.P_OverriddenTab := false;
    tab.TabVisible := true;
    tab.Caption    := Title
  end
  else
  begin
    Cfg := TBinTabCfg(m_TbCfg.FindTab(tab.GetCode));
  end;

  tab.Caption    := '   ' + Title + '   ';
  tab.m_BinPanel.GetFiltParms.RecFilt.Options := [];
  ClearFilterParams(tab.m_BinPanel.GetFiltParms.RecFilt.Options, tab.m_BinPanel.GetFiltParms, Tb_FilterSloteBydate);

  // set WC filter
  tab.m_BinPanel.GetFiltParms.RecFilt.wkCtrCode := TMqmWrkCtr(Wcntr).p_WrkCtrCode;
  Include(tab.m_BinPanel.GetFiltParms.RecFilt.Options, FiltWkcr);

  // set date filter
  tab.m_BinPanel.GetFiltParms.RecFilt.ScheduleJobsCrosses_From := SchedStart;
  tab.m_BinPanel.GetFiltParms.RecFilt.ScheduleJobsCrosses_To := SchedEnd;
  include(tab.m_BinPanel.GetFiltParms.RecFilt.Options, FiltScheduledJobsCrossesDateTime);

  // set resource category filter
  tab.m_BinPanel.GetFiltParms.RecFilt.ResCatCode := ResCatCode;
  Include(tab.m_BinPanel.GetFiltParms.RecFilt.Options, FiltResCat);

  tab.m_BinPanel.UpdateForChangeFilter;
  Cfg.SaveArrayBinCol(Tab.GetBinGrid.BinColumnSet);
  m_pgcBin.ActivePage := tab;
end;

// -------------------------------------------------------------------------- //

procedure TFBin.MIStockDetailsClick(Sender: TObject);
var
  id: TSchedId;
begin
  Id := GetMouseSchedObj(false);
  HandleStockDetails(self,Id);
end;

// -------------------------------------------------------------------------- //

procedure TFBin.MiReApplyIgnoreProgressClick(Sender: TObject);
var
  tbs : TBinTabSheet;
  BinGrid : TBinDrawGrid;
  ObjList : TMSchedList;
  ProgressStatus : CProgressIgnor;
  ProgressIgnoredType : CProgressTypeIgnored;
  ReApply : boolean;
begin
  tbs := TBinTabSheet(m_pgcBin.GetActiveView);
  if tbs.m_BinPanel.GetFiltParms.P_GroupedByCode <> '' then Exit;

  BinGrid := tbs.GetBinGrid;

  ObjList := TMSchedList.create(self);
  if BinGrid.pSelectedMarked then
    ObjList := BinGrid.GetSelectedList
  else
    ObjList.AddLink(GetMouseSchedObj(false));

  if ObjList.GetLinkCount <= 0 then begin ObjList.Free; Exit; end;

  // Decide ignore vs re-apply from the (first) job's current status and confirm, mirroring
  // the main-plan handler (TFMQMPlan.MIIgnoreprogressClick). Previously this always called
  // OrganizeIgnoredProgressOperation(..., true) with no confirmation, so it showed no message
  // and did nothing when the job was not already ignored.
  ProgressStatus := p_sc.GetProgressOverrideStatus(ObjList.GetLink(0), ProgressIgnoredType);
  if (ProgressStatus = Prg_Ignored) or (ProgressStatus = Prg_IgnoredAndSave) then
  begin
    if MessageDlg(_('Confirm re-apply ?'), mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
      begin ObjList.Free; Exit; end;
    ReApply := true;
  end
  else
  begin
    if MessageDlg(_('Confirm Ignore ?'), mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
      begin ObjList.Free; Exit; end;
    ReApply := false;
  end;

  p_sc.OrganizeIgnoredProgressOperation(ObjList , ReApply);

  FMQMPlan.RefreshActiveTab;
  if assigned(FBin) then
    FBin.ChangeTabBinforChangeTabPlan;

  ObjList.Free
end;

//----------------------------------------------------------------------------//

procedure TFBin.MIUnscheduleClick(Sender: TObject);
var
  BinGrid : TBinDrawGrid;
  tab : TBinTabSheet;
  Id  : TSchedId;
  Save_Cursor : TCursor;
begin
  tab := TBinTabSheet(m_pgcBin.ActivePage);
  BinGrid := tab.GetBinGrid;

  if BinGrid.pSelectedMarked or IsAutoRunMode then
  begin
    Save_Cursor := Screen.Cursor;
    Screen.Cursor  := crAppStart;
    if TMenuItem(Sender).name = 'MiSelectedJobOverridingParams' then
      MoveAllJobsToBin(false, false, false)
    else
      MoveAllJobsToBin(false, true, false);
    Screen.Cursor := Save_Cursor;
  end
  else
  begin
    id := GetMouseSchedObj(false);
    if (id <> CSchedIdNull) and Assigned(p_sc.GetExtLinkPtr(id)) and (p_sc.GetVisbleInBin(id) = CSB_Normal) then
    begin
      p_opStack.MarkStackForButtonUndo(_('Unschedule'));
      MoveToBin(id, true);
      FMQMPlan.ActiveUndo;
    end
  end;
  if DBAppGlobals.MCM_App then
    RefreshMcmActiveGanttTab;
end;

//----------------------------------------------------------------------------//

procedure TFBin.MIUnscheduleSelectedAndForwardLinkedJobsClick(Sender: TObject);
var
  BinGrid : TBinDrawGrid;
  tab : TBinTabSheet;
  Id  : TSchedId;
  SchedList : TMSchedList;
  I : Integer;
  Save_Cursor : TCursor;
begin
  tab := TBinTabSheet(m_pgcBin.ActivePage);
  BinGrid := tab.GetBinGrid;

  if BinGrid.pSelectedMarked or IsAutoRunMode then
  begin
    Save_Cursor := Screen.Cursor;
    Screen.Cursor  := crAppStart;
    MoveAllJobsToBin(false, true, true);
    Screen.Cursor := Save_Cursor;
  end;

  if DBAppGlobals.MCM_App then
    RefreshMcmActiveGanttTab;
end;

//----------------------------------------------------------------------------//

procedure TFBin.MIWarpTabClick(Sender: TObject);
var
  BinFilter : TTBinFilter;
  BinFilterMaterial : TTBinFilterMaterial;
  NewTab : TBinTabSheet;
  ParmsFilt : TBinParms;
  TabTitle : string;
  Cfg : TBinTabCfg;
  SavedRefreshBinByButton : boolean;
begin
  ParmsFilt := TBinParms.Create;

  BinFilterMaterial := TTBinFilterMaterial.CreateMaterialBinFilter(Self, ParmsFilt,'',TabProp, CSchedIDnull, CSR_New);
  //BinFilter := TTBinFilter.CreateBinFilter(Self, ParmsFilt,'',TabProp, CSchedIDnull, CSR_NewWarp);
  if BinFilterMaterial.ShowModal = mrOk then
  begin
    Cfg := m_TbCfg.AddNewTab(BinFilterMaterial.GetTabName, m_TbCfg.FindNewCode, false, true);

    //SavedRefreshBinByButton := DBAppSettings.RefreshBinByButton;

   // ParmsFilt.P_MaterialSchedFilter := true;
    NewTab := TBinTabSheet.CreateMaterialTbs(m_pgcBin, MatPopUp, p_sc,
                             BT_Main, FncFilterStep, ParmsFilt, true, Cfg.code, True);


   // DBAppSettings.RefreshBinByButton := SavedRefreshBinByButton;
    NewTab.GetMatGrid.SortRowBin;
    TabTitle := BinFilterMaterial.GetTabName;
    NewTab.TabVisible := true;
    NewTab.Caption := TabTitle;
    NewTab.SetCode(Cfg.code);
    m_pgcBin.ActivePage := NewTab;

    Cfg.ParmFilt := ParmsFilt;
    Cfg.SaveArrayBinCol(NewTab.GetMatGrid.BinMatColumnSet);

    if DBAppGlobals.m_ClientConnectionCriticalRepaired then
    begin
      m_TransTabInsert      := CreateTransaction(Cfg_DB);

      m_qryTabInsertFilter     := CreateQuery(Cfg_DB);
      m_qryTabInsertFilter.Transaction := m_TransTabInsert;

      m_qryTabInsertColumnsCfg := CreateQuery(Cfg_DB);
      m_qryTabInsertColumnsCfg.Transaction := m_TransTabInsert;

      m_qryTabInsertFilterMaterial := CreateQuery(Cfg_DB);
      m_qryTabInsertFilterMaterial.Transaction := m_TransTabInsert;

      m_qryTabDelete        := CreateQuery(Cfg_DB);
      m_qryTabDelete.Transaction := m_TransTabInsert;

      BuildQryForInsertTab;
    end;

    m_TransTabInsert.StartTransaction;
    Cfg.SaveFiltersTab(m_qryTabInsertFilterMaterial, m_qryTabDelete);
    Cfg.SaveColumnsCfgTab(m_qryTabInsertColumnsCfg, m_qryTabDelete, Tb_MaterialSched);
    m_TransTabInsert.Commit;

  end;

  BinFilterMaterial.free;
end;

//----------------------------------------------------------------------------//

procedure TFBin.ShowCompatibleWarpForJob(ProdTypeBaseLvl,ProductBaseLvl,ProdTypeSecondLvl,ProductSecondLvl : String);
var
  tab, TabActive : TBinTabSheet;
  BinGrid : TBinDrawGridMat;
  BinColId : CBinColId;
  ParmsFilt : TBinFilterParms;
  Value: Variant;
  dataType: CBinColValType;
  I : Integer;
  Id : TSchedId ;
  Cfg : TBinTabCfg;
  Title : string;
  Save_Cursor : TCursor;
begin
  Save_Cursor   := Screen.Cursor;
  Screen.Cursor  := crSQLWait;
  ParmsFilt := TBinParms.Create;
  ParmsFilt.RecFilt.Options := [];
  tab := WarpCompatibleTabForJobIsOpend;

  Title := _('Compatible warp');
  Value := Title;

  if tab = nil then
  begin
    Cfg := m_TbCfg.AddNewTab(Title, m_TbCfg.FindNewCode, false, false);
    tab := TBinTabSheet.CreateMaterialTbs(m_pgcBin, MatPopUp, p_sc,
                       BT_Main, FncFilterStep, ParmsFilt, true, Cfg.code, true);
    ConfBinLoadDefaultValues(tab.m_BinPanel.p_GridMat.BinMatColumnSet);
    tab.P_JobWarpCampatible := true;
    tab.SetCode(Cfg.code);
    tab.m_BinPanel.GetFiltParms.P_OverriddenTab := false;
    tab.TabVisible := true;
    tab.Caption    := Title
  end
  else
  begin
    Cfg := TBinTabCfg(m_TbCfg.FindTab(tab.GetCode));
    Cfg.ParmFilt.ClearPropRecFields;
    tab.m_BinPanel.GetFiltParms.ClearFiltPropList;
    ParmsFilt := tab.m_BinPanel.GetFiltParms;
  end;

  Exclude(ParmsFilt.RecFilt.Options, FiltItemTypeBaseWarp);
  Exclude(ParmsFilt.RecFilt.Options, FiltProdCodeBaseWarp);
  Exclude(ParmsFilt.RecFilt.Options, FiltItemTypeSecondWarp);
  Exclude(ParmsFilt.RecFilt.Options, FiltProdCodeSecondWarp);
  ParmsFilt.RecFilt.ItemTypeCodeBaseWarp := '';
  ParmsFilt.RecFilt.ProdCodeBaseWarp := '';
  ParmsFilt.RecFilt.ItemTypeCodeSecondWarp := '';
  ParmsFilt.RecFilt.ProdCodeSecondWarp := '';

  ParmsFilt.RecFilt.Item_Type2 := '';
  ParmsFilt.RecFilt.Product_code2 := '';

  if ProdTypeBaseLvl <> '' then
  begin
    ParmsFilt.RecFilt.Item_Type := ProdTypeBaseLvl;
    Include(ParmsFilt.RecFilt.Options, Filt_Item_Type);
  end;

  if ProductBaseLvl <> '' then
  begin
    ParmsFilt.RecFilt.Product_code := ProductBaseLvl;
    Include(ParmsFilt.RecFilt.Options, Filt_Product_code);
  end;

  if ProdTypeSecondLvl <> '' then
  begin
    ParmsFilt.RecFilt.Item_Type2 := ProdTypeSecondLvl;
    Include(ParmsFilt.RecFilt.Options, Filt_Item_Type2);
  end;

  if ProductSecondLvl <> '' then
  begin
    ParmsFilt.RecFilt.Product_code2 := ProductSecondLvl;
    Include(ParmsFilt.RecFilt.Options, Filt_Product_code2);
  end;

  tab.m_BinPanel.SetParamFilter(ParmsFilt);
  p_pl.BinClientUpdateAll(tab.m_BinPanel, true);

  tab.Caption    := '   ' + Title + '   ';
  SetSortIndex(tab.m_BinPanel, 0);
  m_pgcBin.ActivePage := tab;

  Cfg.ParmFilt := ParmsFilt;
  Cfg.SaveArrayBinCol(Tab.GetMatGrid.BinMatColumnSet);
  Screen.Cursor := Save_Cursor;
end;

//----------------------------------------------------------------------------//

procedure TFBin.ShowCompatibleforwarp(ProdTypeBaseLvl,ProductBaseLvl,ProdTypeSecondLvl,ProductSecondLvl : String);
var
  tab, TabActive : TBinTabSheet;
  BinGrid : TBinDrawGridMat;

  BinColId : CBinColId;
  ParmsFilt : TBinFilterParms;
  Value: Variant;
  dataType: CBinColValType;
  I : Integer;
  Id : TSchedId ;
  Cfg : TBinTabCfg;
  Title : string;
  Save_Cursor : TCursor;
begin
  Save_Cursor   := Screen.Cursor;
  Screen.Cursor  := crSQLWait;
  ParmsFilt := TBinParms.Create;
  ParmsFilt.RecFilt.Options := [];
  tab := WarpCompatibleTabIsOpend;
  if tab = nil then
    ClearFilterParams(ParmsFilt.RecFilt.Options , ParmsFilt, Tb_WeavJobsForWarp);

  if ProdTypeBaseLvl <> '' then
  begin
    ParmsFilt.RecFilt.ItemTypeCodeBaseWarp := ProdTypeBaseLvl;
    Include(ParmsFilt.RecFilt.Options, FiltItemTypeBaseWarp);
  end;

  if ProductBaseLvl <> '' then
  begin
    ParmsFilt.RecFilt.ProdCodeBaseWarp := ProductBaseLvl;
    Include(ParmsFilt.RecFilt.Options, FiltProdCodeBaseWarp);
  end;

  if ProdTypeSecondLvl <> '' then
  begin
    ParmsFilt.RecFilt.ItemTypeCodeSecondWarp := ProdTypeSecondLvl;
    Include(ParmsFilt.RecFilt.Options, FiltItemTypeSecondWarp);
  end;

  if ProductSecondLvl <> '' then
  begin
    ParmsFilt.RecFilt.ProdCodeSecondWarp := ProductSecondLvl;
    Include(ParmsFilt.RecFilt.Options, FiltProdCodeSecondWarp);
  end;

  Title := _('Compatible to warp');
  Value := Title;

  if tab = nil then
  begin
    Cfg := m_TbCfg.AddNewTab(Title, m_TbCfg.FindNewCode, false, false);
    tab := TBinTabSheet.CreateBinTbs(m_pgcBin, PopUpBin, p_sc,
                       BT_Main, FncFilterStep, ParmsFilt, true, Cfg.code, true);
    CopyBinDefaultTabCompatibleWarp(tab.m_BinPanel.p_Grid.BinColumnSet);
    tab.P_WarpCampatible := true;
    tab.SetCode(Cfg.code);
    tab.m_BinPanel.GetFiltParms.P_OverriddenTab := false;
    tab.TabVisible := true;
    tab.Caption    := Title
  end
  else
  begin
    Cfg := TBinTabCfg(m_TbCfg.FindTab(tab.GetCode));
    Cfg.ParmFilt.ClearPropRecFields;
    tab.m_BinPanel.GetFiltParms.ClearFiltPropList;
    ParmsFilt := tab.m_BinPanel.GetFiltParms;

    Exclude(ParmsFilt.RecFilt.Options, FiltItemTypeBaseWarp);
    Exclude(ParmsFilt.RecFilt.Options, FiltProdCodeBaseWarp);
    Exclude(ParmsFilt.RecFilt.Options, FiltItemTypeSecondWarp);
    Exclude(ParmsFilt.RecFilt.Options, FiltProdCodeSecondWarp);
    ParmsFilt.RecFilt.ItemTypeCodeBaseWarp := '';
    ParmsFilt.RecFilt.ProdCodeBaseWarp := '';
    ParmsFilt.RecFilt.ItemTypeCodeSecondWarp := '';
    ParmsFilt.RecFilt.ProdCodeSecondWarp := '';

    if ProdTypeBaseLvl <> '' then
    begin
      ParmsFilt.RecFilt.ItemTypeCodeBaseWarp := ProdTypeBaseLvl;
      Include(ParmsFilt.RecFilt.Options, FiltItemTypeBaseWarp);
    end;

    if ProductBaseLvl <> '' then
    begin
      ParmsFilt.RecFilt.ProdCodeBaseWarp := ProductBaseLvl;
      Include(ParmsFilt.RecFilt.Options, FiltProdCodeBaseWarp);
    end;

    if ProdTypeSecondLvl <> '' then
    begin
      ParmsFilt.RecFilt.ItemTypeCodeSecondWarp := ProdTypeSecondLvl;
      Include(ParmsFilt.RecFilt.Options, FiltItemTypeSecondWarp);
    end;

    if ProductSecondLvl <> '' then
    begin
      ParmsFilt.RecFilt.ProdCodeSecondWarp := ProductSecondLvl;
      Include(ParmsFilt.RecFilt.Options, FiltProdCodeSecondWarp);
    end;

    tab.m_BinPanel.SetParamFilter(ParmsFilt);
    p_pl.BinClientUpdateAll(tab.m_BinPanel, true)
  end;
  tab.Caption    := '   ' + Title + '   ';
  SetSortIndex(tab.m_BinPanel, 0);
  m_pgcBin.ActivePage := tab;

  Cfg.ParmFilt := ParmsFilt;
  Cfg.SaveArrayBinCol(Tab.GetBinGrid.BinColumnSet);
  Screen.Cursor := Save_Cursor;

end;

//----------------------------------------------------------------------------//

procedure TFBin.MiSearchBySelectedCellClick(Sender: TObject);
var
  tab, TabActive : TBinTabSheet;
  BinGrid : TBinDrawGrid;
  I : Integer;
  BinColId : CBinColId;
  ParmsFilt : TBinParms;
  Value: Variant;
  dataType: CBinColValType;
  Id : TSchedId;
  Cfg : TBinTabCfg;
  Title : string;
  Save_Cursor : TCursor;
begin
  tab := TBinTabSheet(m_pgcBin.ActivePage);
  TabActive := TBinTabSheet(m_pgcBin.ActivePage);
  BinGrid := tab.GetBinGrid;

  Save_Cursor   := Screen.Cursor;
  Screen.Cursor  := crSQLWait;

  if Assigned(tab) then
  begin
    I := binGrid.BinColumnSet[binGrid.p_GetCol - binGrid.FixedCols - binGrid.p_GetFixedColumns].RealPos;
    Id := TSchedID(TBinPanel(binGrid.Parent).m_ObjList.GetLink(binGrid.p_GetRow - 1));
    BinColId := binGrid.BinColumnSet[I].Field;
    ParmsFilt := TBinParms.Create;
    p_sc.GetFldValue(Id, BinColId, Value, dataType);
    Title := '';
    ParmsFilt.RecFilt.Options := [];
    ClearFilterParams(ParmsFilt.RecFilt.Options , ParmsFilt, Tb_Search);
    Include(ParmsFilt.RecFilt.Options, FiltWkcrAlterntiv);
    Include(ParmsFilt.RecFilt.Options, FiltOnlySchedJobs);

    if SetFilterParams(BinColId, Value, dataType, false, I ,ParmsFilt, Title, binGrid) then
    begin
      if (dataType = CBT_string) then
         Title := value
      else if (dataType = CBT_integer) then
         Title := IntToStr(value)
      else if (dataType = CBT_float) then
         Title := FloatToStr(value)
      else if (dataType = CBT_date) then
         Title := DateToStr(value);

      tab := SearchTabOpened;
      if tab = nil then
      begin
        Cfg := m_TbCfg.AddNewTab(Title, m_TbCfg.FindNewCode, false, false);
        tab := TBinTabSheet.CreateBinTbs(m_pgcBin, PopUpBin, p_sc,
                           BT_Main, FncFilterStep, ParmsFilt, true, Cfg.code, true);
        CopyBinDefaultTabSearch(tab.m_BinPanel.p_Grid.BinColumnSet);
        tab.p_SearchTab := true;
        tab.SetSearchIconForTab;
        tab.SetCode(Cfg.code);
        tab.m_BinPanel.GetFiltParms.P_OverriddenTab := false;
        tab.TabVisible := true;
        tab.Caption    := Title
      end
      else
      begin
        Cfg := TBinTabCfg(m_TbCfg.FindTab(tab.GetCode));
        Cfg.ParmFilt.ClearPropRecFields;
        tab.m_BinPanel.GetFiltParms.ClearFiltPropList; //:= TBinFilterParms(ParmsFilt);
        tab.m_BinPanel.SetParamFilter(ParmsFilt);
        p_pl.BinClientUpdateAll(tab.m_BinPanel, true)
      end;
      tab.Caption    := '   ' + Title + '   ';
      SetSortIndex(tab.m_BinPanel, 0);
      m_pgcBin.ActivePage := tab;

      Cfg.ParmFilt := ParmsFilt;
      Cfg.SaveArrayBinCol(Tab.GetBinGrid.BinColumnSet);
      if Assigned(FMQMPlan) then
      begin
        if DBAppGlobals.MCM_App then
          OpenMcmDynamicPlanforSearch(ParmsFilt.RecFilt.PropCod[1] , value)
        else
          OpenMqmDynamicPlanforSearch(value);
      end;
    end;
  end;
  Screen.Cursor := Save_Cursor;

end;

//----------------------------------------------------------------------------//

procedure TFBin.MiSearchBySelectedCellInGroupedByClick(Sender: TObject);
begin
  MiSearchBySelectedCellClick(sender)
end;

//----------------------------------------------------------------------------//

procedure TFBin.MISearchCrtTabClick(Sender: TObject);
var
  SearchAndCreateTab : TSearchAndCreateTab;
  NewItem : TMenuItem;
begin
  if TMenuItem(Sender).name = 'MISearchCrtProdReq' then
  begin
    SearchAndCreateTab := TSearchAndCreateTab.SearchAndCreateTab(self, CSC_ProdReq);
    if SearchAndCreateTab.ShowModal = mrOk then
  end

  {else if TMenuItem(Sender).name = 'MISearchWorkCnter' then
  begin
    SearchAndCreateTab := TSearchAndCreateTab.SearchAndCreateTab(self, CSC_WkctCode);
    if SearchAndCreateTab.ShowModal = mrOk then
  end

  else if TMenuItem(Sender).name = 'MISearchWorkCnterProcess' then
  begin
    SearchAndCreateTab := TSearchAndCreateTab.SearchAndCreateTab(self, CSC_WkctProc);
    if SearchAndCreateTab.ShowModal = mrOk then
  end }

  else if TMenuItem(Sender).name = 'MiProductiondeliverydate' then
  begin
    SearchAndCreateTab := TSearchAndCreateTab.SearchAndCreateTab(self, CSC_ProdDlvDate);
    if SearchAndCreateTab.ShowModal = mrOk then
  end
  else if TMenuItem(Sender).name = 'MiPlanStart' then
  begin
    SearchAndCreateTab := TSearchAndCreateTab.SearchAndCreateTab(self, CSC_PlanStartDate);
    if SearchAndCreateTab.ShowModal = mrOk then
  end

  else if TMenuItem(Sender).name = 'MiScheduledstartdate' then
  begin
    SearchAndCreateTab := TSearchAndCreateTab.SearchAndCreateTab(self, CSC_SchedStart);
    if SearchAndCreateTab.ShowModal = mrOk then
  end

  else if TMenuItem(Sender).name = 'MiLatestendingdate' then
  begin
    SearchAndCreateTab := TSearchAndCreateTab.SearchAndCreateTab(self, CSC_HighEndLimit);
    if SearchAndCreateTab.ShowModal = mrOk then
  end

  else if TMenuItem(Sender).name = 'MiLowStartTimeLimit' then
  begin
    SearchAndCreateTab := TSearchAndCreateTab.SearchAndCreateTab(self, CSC_LowStartTimeLimit);
    if SearchAndCreateTab.ShowModal = mrOk then
  end
  else if TMenuItem(Sender).name = 'MiProductionearliestdate' then
  begin
    SearchAndCreateTab := TSearchAndCreateTab.SearchAndCreateTab(self, CSC_LowStartDate);
    if SearchAndCreateTab.ShowModal = mrOk then
  end

{  else if TMenuItem(Sender).name = 'MISearchStepType' then
  begin
    SearchAndCreateTab := TSearchAndCreateTab.SearchAndCreateTab(self, CSC_StepType);
    if SearchAndCreateTab.ShowModal = mrOk then
  end

  else if TMenuItem(Sender).name = 'MiSearchProdType' then
  begin
    SearchAndCreateTab := TSearchAndCreateTab.SearchAndCreateTab(self, CSC_ProdType);
    if SearchAndCreateTab.ShowModal = mrOk then
  end   }

  else if TMenuItem(Sender).name = 'MiSearchStep' then
  begin
    SearchAndCreateTab := TSearchAndCreateTab.SearchAndCreateTab(self, CSC_ProdStep);
    if SearchAndCreateTab.ShowModal = mrOk then
  end

  else if TMenuItem(Sender).name = 'MiSearchSubStep' then
  begin
    SearchAndCreateTab := TSearchAndCreateTab.SearchAndCreateTab(self, CSC_ProdSubStep);
    if SearchAndCreateTab.ShowModal = mrOk then
  end

  else if TMenuItem(Sender).name = 'MiSearchGroupNumber' then
  begin
    SearchAndCreateTab := TSearchAndCreateTab.SearchAndCreateTab(self, CSC_GroupNo);
    if SearchAndCreateTab.ShowModal = mrOk then
  end

  else if TMenuItem(Sender).name = 'MiSearchResource' then
  begin
    SearchAndCreateTab := TSearchAndCreateTab.SearchAndCreateTab(self, CSC_Rsc);
    if SearchAndCreateTab.ShowModal = mrOk then
  end

  else if TMenuItem(Sender).name = 'MiSearchQty' then
  begin
    SearchAndCreateTab := TSearchAndCreateTab.SearchAndCreateTab(self, CSC_QtyToSched);
    if SearchAndCreateTab.ShowModal = mrOk then
  end

  else if TMenuItem(Sender).name = 'MiSearchProductionFamily' then
  begin
    SearchAndCreateTab := TSearchAndCreateTab.SearchAndCreateTab(self, CSC_ProdFamily);
    if SearchAndCreateTab.ShowModal = mrOk then
  end

  else if TMenuItem(Sender).name = 'MiSearchMaterialFamily' then
  begin
    SearchAndCreateTab := TSearchAndCreateTab.SearchAndCreateTab(self, CSC_ProdMatFamily);
    if SearchAndCreateTab.ShowModal = mrOk then
  end;

  if sender is TMenuItem then
  begin
    NewItem := TMenuItem(Sender);
    if NewItem.Tag <> 1 then exit;
    SearchAndCreateTab := TSearchAndCreateTab.SearchAndCreateTabByProp(self, NewItem.VCLComObject);
    if SearchAndCreateTab.ShowModal = mrOk then
  end;

end;

//----------------------------------------------------------------------------//

procedure TFBin.MiAutoSeqBySelectedCfgName(Sender: TObject);
var
  SavedAutoSchedCfg, selectedCfgName : PTAutoSchedCfg;
begin
  SavedAutoSchedCfg := AutoSchedCfg;
  SelectedCfgName  := GetAutoSchedCfg(TMenuItem(Sender).Caption);
  SetAsActiveCfg(SelectedCfgName);
  MIStartAutoSchedCurrentCfgClick(self);
  SetAsActiveCfg(SavedAutoSchedCfg);
end;

//----------------------------------------------------------------------------//

procedure TFBin.MiSearchPropertyClick(Sender: TObject);
begin

end;

//----------------------------------------------------------------------------//

procedure TFBin.MISearchResultClick(Sender: TObject);
begin

end;

//----------------------------------------------------------------------------//

procedure TFBin.MiSeedChangeClick(Sender: TObject);
var
  SpeedMachine : TSpeedMachine;
  MqmActArea : TMqmActArea;
  id : TSchedID;
  ProdNo : string;
  Step, J : integer;
  SchedIdsList : TMSchedList;
begin
 // p_opStack.MarkStackForButtonUndo(_('Speed change'));
  id := GetMouseSchedObj(false);
  SpeedMachine := TSpeedMachine.CreateSpeedMachine(self , Id);
  if SpeedMachine.ShowModal = mrok then
  begin
    {MqmActArea := TMqmActArea(p_sc.GetExtLinkPtr(Id));
    if Assigned(MqmActArea) then
    begin
      MqmActArea.ReorganizeAllOcc;
      FMQMPlan.RefreshActiveTab;
      FBin.ChangeTabBinforChangeTabPlan;
    end;  }
    SchedIdsList := TMSchedList.Create(self);
    ProdNo := p_sc.GetFldDescr(Id, CSC_ProdReq, false);
    Step := StrToInt(p_sc.GetFldDescr(Id, CSC_ProdStep, false));
    p_sc.GetStepJobs(ProdNo, Step, SchedIdsList);
    for J := 0 to SchedIdsList.GetLinkCount - 1 do
    begin
      if p_sc.GetExtLinkPtr(SchedIdsList.GetLink(J)) <> nil then
      begin
        MqmActArea := TMqmActArea(p_sc.GetExtLinkPtr(SchedIdsList.GetLink(J)));
        if assigned(MqmActArea) then
          MqmActArea.ReorganizeAllOcc(true);
      end;
    end;
    FMQMPlan.RefreshActiveTab;
    if assigned(FBin) then
      FBin.ChangeTabBinforChangeTabPlan;
    SchedIdsList.Free;
  end;
  SpeedMachine.free
end;

//----------------------------------------------------------------------------//

procedure TFBin.MiSelectedJobOverridingParamsClick(Sender: TObject);
var
  AutoSeqOverridingParams: TAutoSeqOverridingParams;
  Id, NewId, PreviD : TSchedID;
  SavedEarliestStartDate, SavedLatestEndDate : TDateTime;
  EarliestStartDate, LatestEndDate : TDateTime;
  DatesInfo : TSQDatesInfo;
  ObjList   : TMSchedList;
  IniVal, FinVal: variant;
  SavedCurrAutoSchedCfg, CurrAutoSchedCfg : PTAutoSchedCfg;
  Err : string;
  dataType: CBinColValType;
  SplitQty, QtyPerJob,
  OrigJobQty, EachJobQty: currency;
  I, SplitNo, NewJobNr: integer;
  SplitInfo: TSQSplitInfo;
  List : TList;
  MoveLinkedRequest : boolean;
  tbs : TBinTabSheet;
  BinGrid : TBinDrawGrid;
begin
  AutoSchedCfg.m_WithoutStack := false;

  tbs := TBinTabSheet(m_pgcBin.GetActiveView);
  if tbs.m_BinPanel.GetFiltParms.P_GroupedByCode <> '' then Exit;

  BinGrid := tbs.GetBinGrid;

  ObjList := TMSchedList.create(self);
  MoveLinkedRequest := true;
  if BinGrid.pSelectedMarked then
    ObjList := BinGrid.GetSelectedList
  else
    ObjList.AddLink(GetMouseSchedObj(false));

  for I := 0 to ObjList.GetLinkCount - 1 do
  begin
    if ObjList.GetLink(I) = CSchedIDnull then exit;
    if p_sc.GetExtLinkPtr(ObjList.GetLink(I)) = nil then
    begin
      MoveLinkedRequest := false;
      break
    end;
  end;

  if not CheckCfgDefinitionForAllWorkCenters then
  begin
    ShowMessage(_('Please define first all work centers configuration in Automatic sequencing configuration. '  +
                     #13#10 + ' (' + 'Settings/Automatic sequencing configuration/work centers configuration') + ')');
    exit;
  end;

  AutoSeqOverridingParams := TAutoSeqOverridingParams.CreateAutoSeqOverridingParams(self, MoveLinkedRequest);
  if AutoSeqOverridingParams.ShowModal = mrOk then
  begin
    //SavedCurrAutoSchedCfg := AutoSchedCfg;
    CurrAutoSchedCfg := GetAutoSchedCfg(AutoSeqOverridingParams.GetParamsAutoCfg);
    SetAsActiveCfg(CurrAutoSchedCfg);
    AutoSeqOverridingParams.OverridingCurrParameters(CurrAutoSchedCfg);
    try

      MIStartAutoSchedCurrentCfgClick(MiSelectedJobOverridingParams);
      //if DBAppGlobals.MCM_App then


    Except
      DeleteDummyDownTimeForCapacity(FMQMPlan.GetActiveTab.p_ganttPanel.p_VisResList, false);
      //SetAsActiveCfg(SavedCurrAutoSchedCfg);
    end;

  //  SetAsActiveCfg(SavedCurrAutoSchedCfg);

  end;
  AutoSeqOverridingParams.Free;
  AutoSchedCfg.m_OverridingParams_InfiniteCapacityAllowed := false;
end;

//----------------------------------------------------------------------------//

procedure TFBin.MIChangeWCClick(Sender: TObject);
var
  Id : TSchedID;
  ChangeWc : TChangeWc;
begin
  Id := GetMouseSchedObj(false);
  ChangeWc := TChangeWc.CreateChangeWcForm(self,Id);
  if ChangeWc.ShowModal = mrOk then
    ChangeTabBinforChangeTabPlan;
  ChangeWc.free;
end;

//----------------------------------------------------------------------------//

procedure TFBin.MiChangingCurveCodeClick(Sender: TObject);
var
  learningCurve : TlearningCurve;
  Id            : TSchedId;
  CurveCode     : string;
  MqmActArea    : TMqmActArea;
  SchedList     : TMSchedList;
  BinGrid       : TBinDrawGrid;
  I : Integer;
  tab : TBinTabSheet;
  RefreshIsNeeded : boolean;
begin
  Id := GetMouseSchedObj(false);
  if Id = CSchedIDnull then
     Exit;
  CurveCode := p_sc.GetLearningCurveCode(Id);
  tab := TBinTabSheet(m_pgcBin.ActivePage);
  BinGrid := tab.GetBinGrid;
  SchedList := BinGrid.GetSelectedList;

  learningCurve := TlearningCurve.CreateLearnCurveCng(self, CurveCode);
  if learningCurve.ShowModal = mrOk then
   // p_sc.SetLearningCurveCode(Id,learningCurve.GetNewCurveCode);
  begin
    RefreshIsNeeded := false;
    for i := 0 to SchedList.GetLinkCount - 1 do
    begin
      id := SchedList.GetLink(I);
      p_sc.SetLearningCurveCode(Id,learningCurve.GetNewCurveCode);
      if Assigned(p_sc.GetExtLinkPtr(id)) then
          RefreshIsNeeded := true;
    end;

    if RefreshIsNeeded then//Assigned(p_sc.GetExtLinkPtr(id)) then
    begin
      for i := 0 to SchedList.GetLinkCount - 1 do
      begin
        id := SchedList.GetLink(I);
        MqmActArea := TMqmActArea(p_sc.GetExtLinkPtr(Id));
        if assigned(MqmActArea) then
          MqmActArea.ReorganizeAllOcc(true);
      end;
    end;
  end;

  if RefreshIsNeeded then
  begin
    FMQMPlan.RefreshActiveTab;
    ChangeTabBinforChangeTabPlan;
  end;

  learningCurve.Free;
  RefreshGrid;

end;

//----------------------------------------------------------------------------//

procedure TFBin.MICopyClick(Sender: TObject);
var
  I : Integer;
  BinGrid : TBinDrawGrid;
  Str : string;
  tab : TBinTabSheet;
begin
  tab := TBinTabSheet(m_pgcBin.ActivePage);
  BinGrid := tab.GetBinGrid;
  if assigned(BinGrid) then
  begin
    I := binGrid.BinColumnSet[binGrid.p_GetCol - binGrid.FixedCols - binGrid.p_GetFixedColumns].RealPos;
    if I >= 0 then
    begin
      Str := p_sc.GetFldDescr(TSchedID(TBinPanel(binGrid.Parent).m_ObjList.GetLink(binGrid.p_GetRow - 1)), binGrid.BinColumnSet[I].Field, false);
      Clipboard.AsText := Str;
    end
  end;
end;

//----------------------------------------------------------------------------//

procedure TFBin.MICopyCnfgClick(Sender: TObject);
var
  BinFilter : TTBinFilter;
  ActTab, NewTab : TBinTabSheet;
  ParmsFilt : TBinParms;
  TabTitle : string;
  Cfg : TBinTabCfg;
  ActBinGrid, NewBinGrid : TBinDrawGrid;
  SavedRefreshBinByButton : boolean;
begin
  ParmsFilt := TBinParms.Create;
  ActTab := GetActiveView;
  if not Assigned(ActTab) then
    Exit;
  ActbinGrid := ActTab.GetBinGrid;
  ParmsFilt.CopyFilterSetting(ActTab.m_BinPanel.GetFiltParms);

  BinFilter := TTBinFilter.CreateBinFilter(Self, ParmsFilt,'',TabProp, CSchedIDnull, CSR_New);
  BinFilter.InitFilter;
  if BinFilter.ShowModal = mrOk then
  begin
    Cfg := m_TbCfg.AddNewTab(BinFilter.GetTabName, m_TbCfg.FindNewCode, false, false);
    SavedRefreshBinByButton := DBAppSettings.RefreshBinByButton;
    DBAppSettings.RefreshBinByButton := false;
    NewTab := TBinTabSheet.CreateBinTbs(m_pgcBin, PopUpBin, p_sc,
                             BT_Main, FncFilterStep, ParmsFilt, true, Cfg.code, false);
    DBAppSettings.RefreshBinByButton := SavedRefreshBinByButton;
    NewBinGrid := NewTab.GetBinGrid;
    NewBinGrid.BinColumnSet := ActbinGrid.BinColumnSet;

    SetSortIndex(NewTab.m_BinPanel, 0);
    TabTitle := BinFilter.GetTabName;
    NewTab.TabVisible := true;
    NewTab.Caption := TabTitle;
    NewTab.SetCode(Cfg.code);
    m_pgcBin.ActivePage := NewTab;

    Cfg.ParmFilt := ParmsFilt;

    Cfg.SaveArrayBinCol(NewTab.GetBinGrid.BinColumnSet);
    m_TransTabInsert.StartTransaction;
    Cfg.SaveFiltersTab(m_qryTabInsertFilter, m_qryTabDelete);
    m_TransTabInsert.Commit;
    m_TransTabInsert.StartTransaction;
    Cfg.SaveColumnsCfgTab(m_qryTabInsertColumnsCfg, m_qryTabDelete, Tb_Normal);
    m_TransTabInsert.Commit;

  end;

  BinFilter.free;

 end;

//----------------------------------------------------------------------------//

procedure TFBin.MICreateBinUsingCurentCellClick(Sender: TObject);
var
  tab, TabActive : TBinTabSheet;
  BinGrid : TBinDrawGrid;
  I : Integer;
  BinColId : CBinColId;
  ParmsFilt : TBinParms;
  Value: Variant;
  dataType: CBinColValType;
  Id : TSchedId;
  Cfg : TBinTabCfg;
  Title : string;
  BinFilter : TTBinFilter;
  SavedRefreshBinByButton : boolean;
begin
  tab := TBinTabSheet(m_pgcBin.ActivePage);
  TabActive := TBinTabSheet(m_pgcBin.ActivePage);
  BinGrid := tab.GetBinGrid;
  if Assigned(tab) then
  begin
    I := binGrid.BinColumnSet[binGrid.p_GetCol - binGrid.FixedCols - binGrid.p_GetFixedColumns].RealPos;
    Id := TSchedID(TBinPanel(binGrid.Parent).m_ObjList.GetLink(binGrid.p_GetRow - 1));
    BinColId := binGrid.BinColumnSet[I].Field;
    ParmsFilt := TBinParms.Create;
    p_sc.GetFldValue(Id, BinColId, Value, dataType);
    Title := '';

    BinFilter := TTBinFilter.CreateBinFilter(Self, ParmsFilt,'',TabProp, CSchedIDnull, CSR_New);
    BinFilter.SetFilter('');
    BinFilter.free;

    if SetFilterParams(BinColId, Value, dataType, false, I ,ParmsFilt, Title, binGrid) then
    begin
      {if (dataType = CBT_string) then
         Title := Title + ':' + value
      else if (dataType = CBT_integer) then
         Title := Title + ':' + IntToStr(value)
      else if (dataType = CBT_float) then
         Title := Title + ':' + FloatToStr(value)
      else if (dataType = CBT_date) then
         Title := Title + ':' + DateToStr(value);}

      if (dataType = CBT_string) then
         Title := value
      else if (dataType = CBT_integer) then
         Title := IntToStr(value)
      else if (dataType = CBT_float) then
         Title := FloatToStr(value)
      else if (dataType = CBT_date) then
         Title := DateToStr(value);

      Cfg := m_TbCfg.AddNewTab(Title, m_TbCfg.FindNewCode, false, false);
      SavedRefreshBinByButton := DBAppSettings.RefreshBinByButton;
      DBAppSettings.RefreshBinByButton := false;
      tab := TBinTabSheet.CreateBinTbs(m_pgcBin, PopUpBin, p_sc,
                           BT_Main, FncFilterStep, ParmsFilt, true, Cfg.code, true);
      DBAppSettings.RefreshBinByButton := SavedRefreshBinByButton;
      tab.TabVisible := true;
      tab.Caption    := Title;
      tab.SetCode(Cfg.code);
      tab.GetBinGrid.BinColumnSet := TabActive.GetBinGrid.BinColumnSet;
      SetSortIndex(tab.m_BinPanel, 0);
      m_pgcBin.ActivePage := tab;
      Cfg.ParmFilt := ParmsFilt;
      Cfg.SaveArrayBinCol(Tab.GetBinGrid.BinColumnSet);
      m_TransTabInsert.StartTransaction;
      Cfg.SaveFiltersTab(m_qryTabInsertFilter, m_qryTabDelete);
      m_TransTabInsert.Commit;
      m_TransTabInsert.StartTransaction;
      Cfg.SaveColumnsCfgTab(m_qryTabInsertColumnsCfg, m_qryTabDelete, Tb_Normal);
      m_TransTabInsert.Commit;
    end;
  end;

end;

//----------------------------------------------------------------------------//

procedure TFBin.MiCreateTabForGroupByDetailsClick(Sender: TObject);
//var
//  Id : TSchedID;
begin
{  Id := GetMouseSchedObj(false);
  CreateTabFromJobID(Id , CSR_GroupedBy, '');
  if Assigned(FMQMPlan) then
    OpenMqmDynamicPlanforSearch; }
end;

//----------------------------------------------------------------------------//

procedure TFBin.MiCreateTabForGroupByDetailsKeepFilterClick(Sender: TObject);
//var
//  Id : TSchedID;
begin
{  Id := GetMouseSchedObj(false);
  CreateTabFromJobID(Id , CSR_GroupedByKeepFilter, '');
  if Assigned(FMQMPlan) then
    OpenMqmDynamicPlanforSearch; }
end;

//----------------------------------------------------------------------------//

procedure TFBin.MiCreateVersioningClick(Sender: TObject);
var tab : TBinTabSheet;
  ChildId, id : TSchedID;
  ObjList : TMSchedList;
  BinGrid : TBinDrawGrid;
  Versioning : TFVersioning;
begin
  tab := GetActiveView;
  BinGrid := tab.GetBinGrid;
  ObjList := TMSchedList.Create(self);
  if BinGrid.pSelectedMarked then
    ObjList := BinGrid.GetSelectedList
  else
    ObjList.AddLink(GetMouseSchedObj(false));

  Versioning := TFVersioning.CreateVersioning(self, ObjList);
  Versioning.ShowModal;
  Versioning.Free;

  tab.m_BinPanel.p_Grid.Refresh;
  if Assigned(ObjList) then
    ObjList.Free;
end;

//----------------------------------------------------------------------------//

procedure TFBin.MIReturnWCOriginalClick(Sender: TObject);
var
  Id : TSchedID;
  WC : TMqmWrkCtr;
begin
  Id := GetMouseSchedObj(false);
  WC := TMqmWrkCtr(p_sc.GetWrkCtrPtr(Id));
  if Assigned(WC) then
  begin
    if WC.p_ReadOnly then
    begin
      if MessageDlg(_('This job will belong to another work station, are you sure ?' ), mtConfirmation, [mbYes, mbNo], 0) = idYes then
      begin
        p_sc.SetWcenterToOriginal(Id);
        ChangeTabBinforChangeTabPlan;
      end
    end else
    begin
      p_sc.SetWcenterToOriginal(Id);
      ChangeTabBinforChangeTabPlan;
    end
  end;

{
  if MessageDlg(_('This job will belong to another work station, are you sure ?' ), mtConfirmation, [mbYes, mbNo], 0) = idYes then
  begin
    p_sc.SetWcenterToOriginal(Id);
    ChangeTabBinforChangeTabPlan;
  end
    }
end;

//----------------------------------------------------------------------------//

procedure TFBin.MIShowTabTotalsClick(Sender: TObject);
begin
  if m_pgcBin.PageCount < 1 then Exit;
  TFrmBintotals.create(self).ShowModal;
end;

//----------------------------------------------------------------------------//

procedure TFBin.MISplitOnHostClick(Sender: TObject);
var
  Id            : TSchedId;
  tab           : TBinTabSheet;
begin
  Id := GetMouseSchedObj(false);
  if Id = CSchedIDnull then
     Exit;
  p_sc.SetUserReqSplitOnHost(id);
  tab := TBinTabSheet(m_pgcBin.ActivePage);
  if Assigned(tab) then
    tab.m_BinPanel.RefreshGrid
end;

//----------------------------------------------------------------------------//

function TFBin.FocusBinOnJobID(ObjId: TSchedId; bViewMess: boolean) : boolean;
var
  ActTab: TBinTabSheet;
  ActBinGrid : TBinDrawGrid;
  ActBinGridMat : TBinDrawGridMat;
  i,NumberOfRowsInBin: Integer;
begin
  Result := false;
  ActTab := FBin.GetActiveView;

  if not Assigned(ActTab) then exit;

  if ActTab.m_BinPanel.GetFiltParms.P_MaterialSchedFilter then
  begin
    ActBinGridMat := ActTab.GetMatGrid;
    NumberOfRowsInBin := TBinPanel(ActBinGridMat.Parent).m_ObjList.GetLinkCount;
    for i:= 0 to NumberOfRowsInBin   do
      begin
        if ObjId = TSchedId(TBinPanel(ActBinGridMat.Parent).m_ObjList.GetLink(i)) then
          begin
            ActBinGridMat.toprow := i + 1  ;
            ActBinGridMat.Row := ActBinGridMat.toprow;
            Result := true;
            exit;
          end;//if
        end;//for
     if bViewMess then
       MessageDlg(_('The job was not found in bin !'), mtInformation, [mbOK], 0);
     Exit;
  end
  else
    ActbinGrid := ActTab.GetBinGrid;

  NumberOfRowsInBin := TBinPanel(ActbinGrid.Parent).m_ObjList.GetLinkCount;
  for i:= 0 to NumberOfRowsInBin   do
    begin
      if ObjId = TSchedId(TBinPanel(ActbinGrid.Parent).m_ObjList.GetLink(i)) then
        begin
          ActbinGrid.toprow := i + 1  ;
          ActbinGrid.Row := ActbinGrid.toprow;
          Result := true;
          exit;
        end;//if
      end;//for
   if bViewMess then
     MessageDlg(_('The job was not found in bin !'), mtInformation, [mbOK], 0);
end;

//----------------------------------------------------------------------------//

procedure TFBin.MINewTabClick(Sender: TObject);
var
  BinFilter : TTBinFilter;
  NewTab : TBinTabSheet;
  ParmsFilt : TBinParms;
  TabTitle : string;
  Cfg : TBinTabCfg;
  SavedRefreshBinByButton : boolean;
begin
  ParmsFilt := TBinParms.Create;

  BinFilter := TTBinFilter.CreateBinFilter(Self, ParmsFilt,'',TabProp, CSchedIDnull, CSR_New);
  if BinFilter.ShowModal = mrOk then
  begin
    Cfg := m_TbCfg.AddNewTab(BinFilter.GetTabName, m_TbCfg.FindNewCode, false, false);

    SavedRefreshBinByButton := DBAppSettings.RefreshBinByButton;
    DBAppSettings.RefreshBinByButton := false;

    NewTab := TBinTabSheet.CreateBinTbs(m_pgcBin, PopUpBin, p_sc,
                             BT_Main, FncFilterStep, ParmsFilt, true, Cfg.code, True);

    DBAppSettings.RefreshBinByButton := SavedRefreshBinByButton;
    NewTab.GetBinGrid.SortRowBin;
    TabTitle := BinFilter.GetTabName;
    NewTab.TabVisible := true;
    NewTab.Caption := TabTitle;
    NewTab.SetCode(Cfg.code);
    m_pgcBin.ActivePage := NewTab;

  //  ChangeForBinType;
    Cfg.ParmFilt := ParmsFilt;
    Cfg.SaveArrayBinCol(NewTab.GetBinGrid.BinColumnSet);

    if DBAppGlobals.m_ClientConnectionCriticalRepaired then
    begin
      m_TransTabInsert      := CreateTransaction(Cfg_DB);

      m_qryTabInsertFilter     := CreateQuery(Cfg_DB);
      m_qryTabInsertFilter.Transaction := m_TransTabInsert;

      m_qryTabInsertColumnsCfg := CreateQuery(Cfg_DB);
      m_qryTabInsertColumnsCfg.Transaction := m_TransTabInsert;

      m_qryTabInsertFilterMaterial := CreateQuery(Cfg_DB);
      m_qryTabInsertFilterMaterial.Transaction := m_TransTabInsert;

      m_qryTabDelete        := CreateQuery(Cfg_DB);
      m_qryTabDelete.Transaction := m_TransTabInsert;

      BuildQryForInsertTab;
    end;

    m_TransTabInsert.StartTransaction;
    Cfg.SaveFiltersTab(m_qryTabInsertFilter, m_qryTabDelete);
    Cfg.SaveColumnsCfgTab(m_qryTabInsertColumnsCfg, m_qryTabDelete, Tb_Normal);
    m_TransTabInsert.Commit;

  end;

  BinFilter.free;

end;

procedure TFBin.MINewTabMainClick(Sender: TObject);
begin

end;

//----------------------------------------------------------------------------//

procedure TFBin.MIMoveToBinClick(Sender: TObject);
//var
//  id:      TSchedId;
begin
//  id := GetMouseSchedObj(false);
//  if Assigned(p_sc.GetExtLinkPtr(id)) and (p_sc.GetVisbleInBin(id) = CSB_Normal) then
//  begin
//    p_opStack.MarkStackForButtonUndo(_('Unschedule'));
//    MoveToBin(id, true);
//    FMQMPlan.ActiveUndo;
//  end
end;

//----------------------------------------------------------------------------//

procedure TFBin.MIMsgJobHandleClick(Sender: TObject);
var
  id       : TSchedID;
begin
  id := GetMouseSchedObj(false);
  if id = CSchedIDnull then exit;
  CreateMsgJobForm(Id);
end;

//----------------------------------------------------------------------------//

procedure TFBin.MIMoveAllInBinLastOnGanttClick(Sender: TObject);
var
  Save_Cursor : TCursor;
begin
  Save_Cursor := Screen.Cursor;
  Screen.Cursor  := crAppStart;
  MoveAllJobsToBin(true, true, false);
  Screen.Cursor := Save_Cursor;
end;

//----------------------------------------------------------------------------//

procedure TFBin.CleanVersionClick(Sender: TObject);
var tab : TBinTabSheet;
  ChildId, id : TSchedID;
  ObjList : TMSchedList;
  BinGrid : TBinDrawGrid;
  Versioning : TFVersioning;
begin
  tab := GetActiveView;
  BinGrid := tab.GetBinGrid;
  ObjList := TMSchedList.Create(self);
  if BinGrid.pSelectedMarked then
    ObjList := BinGrid.GetSelectedList
  else
    ObjList.AddLink(GetMouseSchedObj(false));

  Versioning := TFVersioning.CreateVersioning(self, ObjList);
  Versioning.AssignedVersionValues(true);
//  Versioning.ShowModal;
  Versioning.Free;

  tab.m_BinPanel.p_Grid.Refresh;
  if Assigned(ObjList) then
    ObjList.Free;
end;

//----------------------------------------------------------------------------//

procedure TFBin.ClickGroupedByCode(Sender: TObject);
var
  NewItem : TMenuItem;
  GroupCode : string;
  Id : TSchedId;
begin
  NewItem := TMenuItem(Sender);
  Id := GetMouseSchedObj(false);
  CreateTabFromJobID(-1 , CSR_GroupedBy, NewItem.Name);
//  if Assigned(FMQMPlan) then
//    OpenMqmDynamicPlanforSearch;
end;

//----------------------------------------------------------------------------//

procedure TFBin.CoolBar1ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

//----------------------------------------------------------------------------//

procedure TFBin.UpdateFilterForOverridenTab(Sender: TObject);
var
  CurrentTab, tab, TabActive : TBinTabSheet;
  BinGrid : TBinDrawGrid;
  I, J, G : Integer;
  BinColId : CBinColId;
  ParmsFilt : TBinFilterParms;
  value: Variant;
  dataType: CBinColValType;
  Cfg : TBinTabCfg;
  GroupedByFieldList : TStringList;
  GroupedByFieldSet : PTGroupedByFieldSet;
  Properties : TProperties;
  Id : TSchedID;
  JobVal: variant;
begin
  TabActive := TBinTabSheet(m_pgcBin.ActivePage);
  CurrentTab := TMenuItem(Sender).VCLComObject;

  if not assigned(CurrentTab) then exit;

  for G := (m_TbCfg.p_GetTabsCount - 1) downto 0 do
  begin
    tab := TBinTabSheet(GetTabByCode(m_TbCfg.GetTab(G).code));
    if tab = CurrentTab then continue;

    if tab.m_BinPanel.GetFiltParms.P_GroupedByCode <> '' then
    begin
      GroupedByFieldSet := GetGroupBySetByCode(tab.m_BinPanel.GetFiltParms.P_GroupedByCode);

      if GroupedByFieldSet = nil then continue;

      if FiltProdReq in GroupedByFieldSet.GroupedByOption then
      begin
        Exclude(CurrentTab.m_BinPanel.GetFiltParms.RecFilt.Options, FiltProdReq);
        CurrentTab.m_BinPanel.GetFiltParms.RecFilt.ProdReq := '';
      end;

      if FiltProdFamily in GroupedByFieldSet.GroupedByOption then
      begin
        Exclude(CurrentTab.m_BinPanel.GetFiltParms.RecFilt.Options, FiltProdFamily);
        CurrentTab.m_BinPanel.GetFiltParms.RecFilt.ProductFamily := '';
      end;

      for I := Low(GroupedByFieldSet.PropCode) to High(GroupedByFieldSet.PropCode) do
      begin
        for J := Low(CurrentTab.m_BinPanel.GetFiltParms.RecFilt.PropCod) to High(CurrentTab.m_BinPanel.GetFiltParms.RecFilt.PropCod) do
        begin
          if (GroupedByFieldSet.PropCode[I] <> '') and ((GroupedByFieldSet.PropCode[I] = CurrentTab.m_BinPanel.GetFiltParms.RecFilt.PropCod[J])) then
          begin
            CurrentTab.m_BinPanel.GetFiltParms.RecFilt.PropCod[J] := '';
            CurrentTab.m_BinPanel.GetFiltParms.RecFilt.PropValfrom[J] := '';
            CurrentTab.m_BinPanel.GetFiltParms.RecFilt.PropValTo[J] := '';
            CurrentTab.m_BinPanel.GetFiltParms.DeletePropFromList(GroupedByFieldSet.PropCode[I]);
          end;
        end;
      end;

    end;
  end;

  BinGrid := TabActive.GetBinGrid;
  Id := TSchedID(TBinPanel(binGrid.Parent).m_ObjList.GetLink(binGrid.p_GetRow - 1));

  if TabActive.m_BinPanel.GetFiltParms.P_GroupedByCode <> '' then
  begin
    GroupedByFieldSet := GetGroupBySetByCode(TabActive.m_BinPanel.GetFiltParms.P_GroupedByCode);

    if FiltProdReq in GroupedByFieldSet.GroupedByOption then
    begin
      include(CurrentTab.m_BinPanel.GetFiltParms.RecFilt.Options, FiltProdReq);
      p_sc.GetFldValue(id, CSC_ProdReq, value, dataType);
      CurrentTab.m_BinPanel.GetFiltParms.RecFilt.ProdReq := value;
    end;

    if FiltProdFamily in GroupedByFieldSet.GroupedByOption then
    begin
      Exclude(CurrentTab.m_BinPanel.GetFiltParms.RecFilt.Options, FiltProdFamily);
      p_sc.GetFldValue(id, CSC_ProdFamily, value, dataType);
      CurrentTab.m_BinPanel.GetFiltParms.RecFilt.ProductFamily := value;
    end;

    Properties := p_sc.GetProperties(Id,nil);

    J := 1;
    while CurrentTab.m_BinPanel.GetFiltParms.RecFilt.PropCod[J] <> '' do
      inc(J);

    for I := Low(GroupedByFieldSet.PropCode) to High(GroupedByFieldSet.PropCode) do
    begin
      if not Assigned(Properties) then break;
      if GroupedByFieldSet.PropCode[I] = '' then break;

      if not Properties.GetValforCode(GroupedByFieldSet.PropCode[I], '', -1, JobVal) then
      begin
        continue;
      end;

      CurrentTab.m_BinPanel.GetFiltParms.RecFilt.PropCod[J] := GroupedByFieldSet.PropCode[I];
      CurrentTab.m_BinPanel.GetFiltParms.RecFilt.PropValfrom[J] := JobVal;
      CurrentTab.m_BinPanel.GetFiltParms.RecFilt.PropValTo[J] := JobVal;
      Include(CurrentTab.m_BinPanel.GetFiltParms.RecFilt.Options, FiltProp);
      CurrentTab.m_BinPanel.GetFiltParms.RecFilt.IsPropEnter := true;
      CurrentTab.m_BinPanel.GetFiltParms.SetPropValue(GroupedByFieldSet.PropCode[I],'', CurrentTab.m_BinPanel.GetFiltParms.RecFilt.PropValfrom[J],
      CurrentTab.m_BinPanel.GetFiltParms.RecFilt.PropValTo[J]);
      Inc(J)
    end;
 end;

  CurrentTab.m_BinPanel.UpdateForChangeFilter;
  m_pgcBin.SetActiveViewBin(CurrentTab.GetCode);
  Cfg := TBinTabCfg(m_TbCfg.FindTab(CurrentTab.GetCode));

  Cfg.ParmFilt := CurrentTab.m_BinPanel.GetFiltParms;
  m_TransTabInsert.StartTransaction;
  Cfg.SaveFiltersTab(m_qryTabInsertFilter, m_qryTabDelete);
  m_TransTabInsert.Commit;

end;

//----------------------------------------------------------------------------//

{procedure TFBin.DrawNenuItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
var
  TextS: String;
  ItemMenu : TMenuItem;
begin
  if TMenuItem(Sender).Name = 'CLEAR' then
    ACanvas.Font.Color := Clred;
  ACanvas.FillRect(ARect);
  ARect.Left := ACanvas.TextWidth(' ');
  Dec(ARect.Right, 1);
  TextS :=  ShortCutToText(TMenuItem(Sender).ShortCut);
  DrawText(ACanvas.Handle, PChar(TMenuItem(Sender).Caption), -1, ARect, DT_VCENTER or DT_SINGLELINE or DT_EXPANDTABS);
end; }
//----------------------------------------------------------------------------//

procedure TFBin.MIMoveAllJobstobinClick(Sender: TObject);
//var
//  Save_Cursor : TCursor;
begin
//  Save_Cursor := Screen.Cursor;
//  Screen.Cursor  := crAppStart;
//  MoveAllJobsToBin(false);
//  Screen.Cursor := Save_Cursor;
end;

//----------------------------------------------------------------------------//

function TFBin.AutoCreateGroup(job: TSchedId): integer;
var
  addFnc, canAddSameGrpFnc:   TGrpAddFunc;
  id, TempID:  TSchedId;
  linkInfo: TSQlinkInfo;
  errDesc:  string;
  i,M : integer;
  tbs : TBinTabSheet;
  Qty, TotalQty     : currency;
  MultQty, QtyConvert : double;
  dataType: CBinColValType;
  FieldVal : variant;
  MatFamilyList : TStringList;
begin
  Assert(job <> CSchedIdNull);
  MatFamilyList := TStringList.Create;

  if DBAppGlobals.ConvertToRscUomInGroup and not p_sc.QtyInUM(job ,DBAppGlobals.ResUmInGroup, QtyConvert, MultQty) then
    Exit;

  if DBAppGlobals.ConvertToRscUomInGroup then
    Qty := QtyConvert
  else
  begin
    p_sc.GetFldValue(job, CSC_QtyToSched, FieldVal, dataType);
    Qty := FieldVal
  end;

  if qty > DBAppGlobals.MaxQtyInGFroup then
     exit;

  p_opStack.CreateGroup(job, Result);
  addFnc := CanAddJobToGroupOnBin;
  canAddSameGrpFnc := CanAddJobToGroupSameType;
  tbs := TBinTabSheet(m_pgcBin.GetActiveView);
  if not Assigned(tbs) then exit;
  for i := 0 to tbs.m_BinPanel.m_objList.GetLinkCount -1 do
  begin
    id := tbs.m_BinPanel.m_objList.GetLink(i);
    if id = CSchedIdNull then break;

    if (DBAppGlobals.MaxNumJobsInGroup > 0) and (p_sc.GetGrpNumSons(Result) = DBAppGlobals.MaxNumJobsInGroup) then
        break;

    if (DBAppGlobals.NumOfMatFamiliyInGroup > 0) then
    begin
        MatFamilyList.Clear;
        for M := 0 to p_sc.GetGrpNumSons(Result) - 1 do
        begin
          TempID := p_sc.GetGrpSon(Result, M);
          if MatFamilyList.IndexOf(p_sc.GetFldDescr(TempID, CSC_ProdMatFamily, false)) = -1 then
             MatFamilyList.Add(p_sc.GetFldDescr(TempID, CSC_ProdMatFamily, false));
        end;
        if (MatFamilyList.IndexOf(p_sc.GetFldDescr(ID, CSC_ProdMatFamily, false)) = -1) and
            (DBAppGlobals.NumOfMatFamiliyInGroup = MatFamilyList.Count) then
               Continue;
    end;

    if DBAppGlobals.ConvertToRscUomInGroup and not p_sc.QtyInUM(id ,DBAppGlobals.ResUmInGroup, QtyConvert, MultQty) then
       continue;

    if DBAppGlobals.ConvertToRscUomInGroup then
    begin
      Qty := QtyConvert;
    end
    else
    begin
      p_sc.GetFldValue(id, CSC_QtyToSched, FieldVal, dataType);
      Qty := FieldVal
    end;

    if DBAppGlobals.ConvertToRscUomInGroup and not p_sc.QtyInUM(Result ,DBAppGlobals.ResUmInGroup, QtyConvert, MultQty) then
       continue;

    if DBAppGlobals.ConvertToRscUomInGroup then
    begin
      TotalQty := QtyConvert;
    end
    else
    begin
      p_sc.GetFldValue(Result, CSC_QtyToSched, FieldVal, dataType);
      TotalQty := FieldVal
    end;

    if TotalQty + qty > DBAppGlobals.MaxQtyInGFroup then
       continue;

    if p_sc.GetLinkInfo(id, linkInfo) and (not linkInfo.isOnPlan) and
            (not linkInfo.isGroup) and (linkInfo.grpId = CSchedIdNull) and
            p_sc.CanAddJobToGroup(id, Result, addFnc, canAddSameGrpFnc, errDesc) then
      p_opStack.AddJobToGroup(id, Result);
  end;

  if (p_sc.GetGrpNumSons(Result) < DBAppGlobals.MinNumJobsInGroup) then
  begin
    RemoveAutomaticllyJobsFromGroup(result);
    result := -1
  end;

  if (DBAppGlobals.MinQtyInGroup > 0) then
  begin
    if DBAppGlobals.ConvertToRscUomInGroup then
    begin
      p_sc.QtyInUM(result ,DBAppGlobals.ResUmInGroup, QtyConvert, MultQty);
      TotalQty := QtyConvert;
    end
    else
    begin
      p_sc.GetFldValue(result, CSC_QtyToSched, FieldVal, dataType);
      TotalQty := FieldVal
    end;

    if TotalQty < DBAppGlobals.MinQtyInGroup then
      RemoveAutomaticllyJobsFromGroup(result)
  end;

  MatFamilyList.Free;
  FBin.ChangeTabBinforChangeTabPlan;
end;

//----------------------------------------------------------------------------//

procedure TFBin.SetDynamicSubMenuForSearchProperty;
var
  P : Integer;
  NewItem : TMenuItem;
begin
  for P := 0 to GetPropertyCount - 1 do
  begin
    NewItem := TMenuItem.Create(Self);
    NewItem.VCLComObject := GetPropFromPos(P);
    NewItem.Caption := GetPropDescr(GetPropFromPos(P));
    NewItem.Name    := 'MiSet' + IntToStr(P);
    NewItem.OnClick := MISearchCrtTabClick;
    NewItem.Tag     := 1;
  //  NewItem.OnDrawItem := DrawItemPopUp;
    MiSearchProperty.add(NewItem);
  end;
end;

//----------------------------------------------------------------------------//

procedure TFBin.SetDynamicSubMenuForAutoSeqCfgList(ListCfg : TStringList);
var
  P : Integer;
  NewItem : TMenuItem;
begin
  MiAutoSeqBySelectedCfg.clear;
  for P := 0 to ListCfg.Count - 1 do
  begin
    NewItem := TMenuItem.Create(Self);
    NewItem.VCLComObject := Pointer(P);
    NewItem.Caption := ListCfg.Strings[P];
    NewItem.Name    := 'MiAutoSeqBySelectedCfg' + IntToStr(P);
    NewItem.OnClick := MiAutoSeqBySelectedCfgName;
    NewItem.Tag     := 1;
  //  NewItem.OnDrawItem := DrawItemPopUp;
    MiAutoSeqBySelectedCfg.add(NewItem);
  end;
end;

//----------------------------------------------------------------------------//

function TFBin.CheckExistPropPlannerForID(Id : TSchedId) : boolean;
var
  wkc : TMqmWrkCtr;
  I : Integer;
  PropId : TPropId;
  tpLink: TCompatTopoLink;
  mtx:    TCompatMatrix;
begin
  Result := false;

  for I := 0 to GetPropertyCount - 1 do
  begin
    PropId := GetPropFromPos(I);
    if not IsPropPlanner(PropId) then continue;
    GetPropCoordForValue(PropId, tpLink, mtx);
    if (tpLink = CTL_global) then
    begin
      Result := true;
      Exit;
    end;
  end;

  wkc := p_sc.GetWrkCtrPtr(id);
  if not assigned(wkc) then exit;
  if wkc.P_WrctrLevelPropList_Count = 0 then exit;
  for I := 0 to GetPropertyCount - 1 do
  begin
    PropId := GetPropFromPos(I);
    if not wkc.GetPropIdInWrctrLevelList(PropId) then continue;
    Result := true;
    exit;
  end;

end;

//----------------------------------------------------------------------------//

function TFBin.CheckGroupedByCodeFiledsForSearch(BinColId : CBinColId) : boolean;
var
  tab : TBinTabSheet;
begin
  tab := GetActiveView;
  Result := false;
  if assigned(tab) and (tab.m_BinPanel.GetFiltParms.P_GroupedByCode = '') then exit;
  result := FMGroupedByFieldsConfig.CheckGroupedByCodeFiledsForSearch(tab.m_BinPanel.GetFiltParms.P_GroupedByCode, BinColId)
end;

//----------------------------------------------------------------------------//

function TFBin.CheckActiveAlterWorkCenterAndSplitAccordingToMcm(SchedList : TMSchedList) : boolean;
var
  Id : TSchedId;
  PlanInfo : TSQplanInfo;
  JobsInBinCount, I : Integer;
begin
  Result := false;
  JobsInBinCount := SchedList.GetLinkCount;
  for i := (JobsInBinCount - 1) downto 0 do
  begin
    id := SchedList.GetLink(I);
    if id = CSchedIdNull then continue;
    p_sc.GetPlanInfo(id, planInfo);
    if planInfo.isGroup then continue;
    if planInfo.SplitFromMcmToMqmAndAlterWorkCenter then
    begin
      if (p_sc.GetJobNumBrothers(Id) = 1) and (CProgress(p_sc.IsProgressed(Id)) = prg_none) and
          (not Assigned(p_sc.GetExtLinkPtr(id))) then
      begin
        Result := true;
        break;
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFBin.MIAutoGroupingSelectionClick(Sender: TObject);
  function CanCreateGrpWithOneJob(GrpToCheck: TSchedId; SchedList : TMSchedList) : boolean;
  var
    id, SonId:       TSchedId;
    linkInfo: TSQlinkInfo;
    addFnc, canAddSameGrpFnc:   TGrpAddFunc;
    errDesc : string;
    i, J : integer;
    tbs : TBinTabSheet;
    dataType: CBinColValType;
    ValGrp, ValJob : variant;
    FoundSameValues : boolean;
    LowestDate, HigestDate, HigestDateSon : double;
  begin
    Result := true;
    addFnc := CanAddJobToGroupOnBin;
    canAddSameGrpFnc := CanAddJobToGroupSameType;
    tbs := TBinTabSheet(m_pgcBin.GetActiveView);
    if not Assigned(tbs) then exit;
    for i := 0 to SchedList.GetLinkCount -1 do
    begin
      id := SchedList.GetLink(i);
      if id = CSchedIdNull then break;

      if DBAppGlobals.GapInDaysForLatestEndGroup > 0 then
      begin
        p_sc.GetFldValue(id, CSC_HighEndLimit , ValJob, dataType);
        LowestDate := ValJob;
        HigestDate := ValJob;

        for J := 0 to p_sc.GetGrpNumSons(GrpToCheck) - 1 do
        begin
          SonId := p_sc.GetGrpSon(GrpToCheck, J);
          p_sc.GetFldValue(SonId, CSC_HighEndLimit , ValJob, dataType);
          HigestDateSon := ValJob;
          if HigestDateSon < LowestDate then LowestDate := HigestDateSon;
          if HigestDateSon > HigestDate then HigestDate := HigestDateSon;
        end;
        if (HigestDate - LowestDate) >= DBAppGlobals.GapInDaysForLatestEndGroup then continue;
      end;

      if p_sc.GetLinkInfo(id, linkInfo) and (not linkInfo.isOnPlan) and
              (not linkInfo.isGroup) and // (linkInfo.grpId = CSchedIdNull) and
              p_sc.CanAddJobToGroup(id, GrpToCheck, addFnc, canAddSameGrpFnc, errDesc) then
        exit;
    end;
    Result := tbs.m_BinPanel.GetFiltParms.RecFilt.AutoGroupSingleJob;
  end;

var
  GrpId, TempID: TSchedId;
  i, z, M, J : integer;
  addFnc, canAddSameGrpFnc:   TGrpAddFunc;
  id:       TSchedId;
  linkInfo: TSQlinkInfo;
  errDesc:  string;
  str: string;
  isGrp, AddedToGrp : boolean;
  LstGrpId: TStringList;
  planInfo: TSQplanInfo;
  extPtr: pointer;
  NumOfGroup : Integer;
  tbs : TBinTabSheet;
  GroupAll : TTGroupAllLines;
  IsBelong : boolean;
  GroupingTypeJob : CGroupingType;
  dataType: CBinColValType;
  FieldVal : variant;
  CanGrouped : string;
  Qty, TotalQty     : currency;
  MultQty, QtyConvert, HigestDate, HigestDateSon : double;
  MatFamilyList : TStringList;
  BinGrid : TBinDrawGrid;
  markStack : TStackMark;
  SchedList : TMSchedList;
  JobsInBinCount, JobsInGroup : integer;
  ValGrp, ValJob : variant;
begin
  m_GroupTypeCreate := CSM_Automatic;
  NumOfGroup := 0;
  Id := GetMouseSchedObj(false);
  if (id = CSchedIdNull) then exit;
  GroupAll := TTGroupAllLines.CreateForm(self, Id);
  if GroupAll.ShowModal <> mrOk then
  begin
    GroupAll.Free;
    Exit;
  end;

  GroupAll.Free;

  tbs := TBinTabSheet(m_pgcBin.GetActiveView);
  BinGrid := tbs.GetBinGrid;

//  p_opStack.MarkStackForButtonUndo('Create automatic group');

  if not BinGrid.pSelectedMarked then
  begin

    markStack := p_opStack.MarkStack;
    id := GetMouseSchedObj(false);
    str := p_sc.GetObjInfo(id, isGrp);

    if isGrp then
      ShowMessage(_('You cannot add a group to a group'))
    else if p_sc.GetGroup(id) <> CSchedIdNull then
      ShowMessage(_('Already belonging to a group'))
    else
    begin
      GrpId := AutoCreateGroup(id);
      if (GrpId <> -1) and (not IsGroupFormOut) then
      begin
        FocusBinOnJobID(GrpId , False);
        HandleGroup(self, GrpId, false, markStack, false);
      end;
    end;
    exit;
  end;

  LstGrpId := TStringList.Create;
  MatFamilyList := TStringList.Create;
  addFnc := CanAddJobToGroupOnBin;
  canAddSameGrpFnc := CanAddJobToGroupSameType;

  Assert(Assigned(FMQMPlan));

  Screen.Cursor := crSQLWait;
  try

  SchedList := BinGrid.GetSelectedList;
  JobsInBinCount := SchedList.GetLinkCount;

  for i := (JobsInBinCount - 1) downto 0 do
    FMQMPlan.MainProgBar.SetMax(JobsInBinCount);

  for i := 0 to SchedList.GetLinkCount - 1 do
  begin
    id := SchedList.GetLink(I);
    if p_sc.IsGroup(Id) then
    begin
      p_sc.GetLinkInfo(Id, linkInfo);
      if linkInfo.isOnPlan then continue;
      LstGrpId.Add(IntToStr(Id))
    end;
  end;
  for i := 0 to SchedList.GetLinkCount - 1 do
  begin
    id := SchedList.GetLink(I);
    if id = CSchedIdNull then break;

    FMQMPlan.MainProgBar.SetPosition(i);
    if (i mod 20) = 0 then
      Application.ProcessMessages;

    if DBAppGlobals.ConvertToRscUomInGroup and not p_sc.QtyInUM(id ,DBAppGlobals.ResUmInGroup, QtyConvert, MultQty) then
      continue;

    if DBAppGlobals.ConvertToRscUomInGroup then
    begin
      Qty := QtyConvert;
    end
    else
    begin
      p_sc.GetFldValue(id, CSC_QtyToSched, FieldVal, dataType);
      Qty := FieldVal
    end;

    if qty > DBAppGlobals.MaxQtyInGFroup then
      continue;

    str := p_sc.GetObjInfo(id, isGrp);
    if isGrp then
    begin
      p_sc.GetLinkInfo(Id, linkInfo);
      if linkInfo.isOnPlan then continue;
      LstGrpId.Add(IntToStr(Id));
      continue;
    end;

    GroupingTypeJob := p_sc.GetStepGroupType(id);
    if GroupingTypeJob <> Single_grp then
      continue;
    p_sc.GetFldValue(Id, CSC_StepGroupType, FieldVal, dataType);
    CanGrouped := FieldVal;
    if (CanGrouped <> '1') and (CanGrouped <> '3') then
      continue;

    p_sc.GetPlanInfo(id, planInfo);

    AddedToGrp := false;
    for z := 0 to LstGrpId.Count -1 do
    begin
      GrpId := StrToInt(LstGrpId[z]);
      //if ListGrpHandled.IndexOf(pointer(GrpId)) = -1 then continue;

      if (DBAppGlobals.MaxNumJobsInGroup > 0) and (p_sc.GetGrpNumSons(GrpId) = DBAppGlobals.MaxNumJobsInGroup) then
           continue;

      if (DBAppGlobals.NumOfMatFamiliyInGroup > 0) then
      begin
        MatFamilyList.Clear;
        for M := 0 to p_sc.GetGrpNumSons(GrpId) - 1 do
        begin
          TempID := p_sc.GetGrpSon(GrpId, M);
          if MatFamilyList.IndexOf(p_sc.GetFldDescr(TempID, CSC_ProdMatFamily, false)) = -1 then
             MatFamilyList.Add(p_sc.GetFldDescr(TempID, CSC_ProdMatFamily, false));
        end;
        if (MatFamilyList.IndexOf(p_sc.GetFldDescr(ID, CSC_ProdMatFamily, false)) = -1) and
            (DBAppGlobals.NumOfMatFamiliyInGroup = MatFamilyList.Count) then
               Continue;
      end;

      if DBAppGlobals.ConvertToRscUomInGroup then
      begin
        p_sc.QtyInUM(GrpId ,DBAppGlobals.ResUmInGroup, QtyConvert, MultQty);
        TotalQty := QtyConvert;
      end
      else
      begin
        p_sc.GetFldValue(GrpId, CSC_QtyToSched, FieldVal, dataType);
        TotalQty := FieldVal
      end;

      if DBAppGlobals.GapInDaysForLatestEndGroup > 0 then
      begin
        p_sc.GetFldValue(id, CSC_HighEndLimit , ValJob, dataType);

        HigestDate := ValJob;

        p_sc.GetFldValue(GrpId, CSC_HighEndLimit , ValGrp, dataType);
        HigestDateSon := ValGrp;

        if ABS(HigestDate - HigestDateSon) >= DBAppGlobals.GapInDaysForLatestEndGroup then continue;
      end;

      if TotalQty + qty > DBAppGlobals.MaxQtyInGFroup then
         continue;

//      if (p_sc.GetGrpNumSons(GrpId) = DBAppGlobals.MinNumJobsInGroup) then
//         continue;

      if p_sc.GetLinkInfo(id, linkInfo) and (not linkInfo.isOnPlan) and
              (not linkInfo.isGroup) and // (linkInfo.grpId = CSchedIdNull) and
              p_sc.CanAddJobToGroup(id, GrpId, addFnc, canAddSameGrpFnc, errDesc) then
      begin
        p_opStack.AddJobToGroup(id, GrpId);
        AddedToGrp := true;
        break;
      end;
    end;

    if (not AddedToGrp) and (not planInfo.isOnPlan) and (not planInfo.isGroup) and
       (p_sc.GetGroup(id) = CSchedIdNull) and (planInfo.VisibleInBin = CSB_Normal) then
    begin
      p_opStack.CreateGroup(id, GrpId);
      Inc(NumOfGroup);
      if CanCreateGrpWithOneJob(GrpId, SchedList) then
        LstGrpId.Add(IntToStr(GrpId))
      else
      begin
          //if (MinNumJobs > 0) then
          //begin
            extPtr := p_sc.GetExtLinkPtr(GrpId);
            if Assigned(extPtr) then
              p_opStack.DetachOccFromApa(GrpId, extPtr);
              p_opStack.RemoveJobFromGroup(id, 'Auto-grouping cancelled');
            p_sc.DeleteGroup(GrpId);
          //end
      end;
    end;

  end;

 // NumOfGroup := LstGrpId.Count;
  {if (DBAppGlobals.MinNumJobsInGroup > 0) then
  begin
    for i := 0 to LstGrpId.Count -1 do
    begin
      Id := StrToInt(LstGrpId[i]);

      if id = CSchedIdNull then break;

      p_sc.GetPlanInfo(id, planInfo);

      if planInfo.isGroup then
      begin
        if (DBAppGlobals.MinNumJobsInGroup <> 0) and (not planInfo.isOnPlan) and
            (planInfo.VisibleInBin = CSB_Normal) then
        begin

          if (p_sc.GetGrpNumSons(Id) < DBAppGlobals.MinNumJobsInGroup) then
          begin
            dec(NumOfGroup);
            RemoveAutomaticllyJobsFromGroup(Id)
          end;
        end;
      end
      else
      begin
        if (DBAppGlobals.MinNumJobsInGroup <> 0) and (not planInfo.isOnPlan) and
            (planInfo.VisibleInBin = CSB_Normal) then
        begin
          IsBelong := false;
          GrpId := p_sc.LinesBelongToGroup(id, IsBelong);
          if IsBelong and (p_sc.GetGrpNumSons(GrpId) < DBAppGlobals.MinNumJobsInGroup) then
          begin
            dec(NumOfGroup);
            RemoveAutomaticllyJobsFromGroup(GrpId)
          end;
        end;
      end;
    end;
  end; }


  if (DBAppGlobals.MinQtyInGroup > 0) or (DBAppGlobals.MinNumJobsInGroup > 0) then
  begin
    for i := 0 to LstGrpId.Count -1 do
    begin
      Id := StrToInt(LstGrpId[i]);

      if id = CSchedIdNull then break;

      p_sc.GetPlanInfo(id, planInfo);

      if DBAppGlobals.ConvertToRscUomInGroup then
      begin
        p_sc.QtyInUM(Id ,DBAppGlobals.ResUmInGroup, QtyConvert, MultQty);
        TotalQty := QtyConvert;
      end
      else
      begin
        p_sc.GetFldValue(Id, CSC_QtyToSched, FieldVal, dataType);
        TotalQty := FieldVal
      end;

      if planInfo.isGroup then
      begin
        if (not planInfo.isOnPlan) and
            (planInfo.VisibleInBin = CSB_Normal) then
        begin
          if ((DBAppGlobals.MinQtyInGroup > 0) and (TotalQty < DBAppGlobals.MinQtyInGroup))
          or ((DBAppGlobals.MinNumJobsInGroup > 0) and (p_sc.GetGrpNumSons(Id) < DBAppGlobals.MinNumJobsInGroup)) then
          begin
            dec(NumOfGroup);
            RemoveAutomaticllyJobsFromGroup(Id)
          end;
        end;
      end
      else
      begin
        if (not planInfo.isOnPlan) and
            (planInfo.VisibleInBin = CSB_Normal) then
        begin
          IsBelong := false;
          GrpId := p_sc.LinesBelongToGroup(id, IsBelong);
          if (IsBelong and (DBAppGlobals.MinQtyInGroup > 0) and (TotalQty < DBAppGlobals.MinQtyInGroup))
          or (IsBelong and (DBAppGlobals.MinNumJobsInGroup > 0) and (p_sc.GetGrpNumSons(GrpId) < DBAppGlobals.MinNumJobsInGroup)) then
          begin
            dec(NumOfGroup);
            RemoveAutomaticllyJobsFromGroup(GrpId)
          end;
        end;
      end;
    end;
  end;

  finally
    Screen.Cursor := crDefault;
  end;

  FMQMPlan.MainProgBar.SetPosition(FMQMPlan.MainProgBar.Max);

  if SchedList.GetLinkCount > 0 then
  begin
    for I := 0 to BinGrid.RowCount - 1 do
       BinGrid.ForceUnselected(I);
  end;

  FBin.ChangeTabBinforChangeTabPlan;
  if (NumOfGroup > 0) and (LstGrpId.Count > 0) then
    MessageDlg(IntToStr(NumOfGroup) + ' ' + _('Groups created'), mtInformation, [mbOK], 0)
  else
    MessageDlg(IntToStr(0) + ' ' + _('Groups created'), mtInformation, [mbOK], 0);
//  else
//    MessageDlg(IntToStr(LstGrpId.Count) + ' ' + _('Groups created'), mtInformation, [mbOK], 0);
  LstGrpId.Free;
  MatFamilyList.Free;

  FMQMPlan.MainProgBar.SetPosition(0);
  m_GroupTypeCreate := CSM_Manual;
//  FMQMPlan.ActiveUndo;
end;
//----------------------------------------------------------------------------//

procedure TFBin.MISetFinClick(Sender: TObject);
var
  id: TSchedId;
begin
  Id := GetMouseSchedObj(false);
  if id = -1 then exit;

  if (p_sc.GetSchedType(id) = '2') then
    p_opStack.SetSchedType(id, '1')
  else
    p_opStack.SetSchedType(id, '2');

  FMQMPlan.RefreshActiveTab;
  ChangeTabBinforChangeTabPlan;

  SetBinMenuItems(id);
end;

//----------------------------------------------------------------------------//

procedure TFBin.MIShowMaterialsClick(Sender: TObject);
var
  planInfo: TSQplanInfo;
  TimingInfo: TSQtimingInfo;
  MachSetupCodeList :TMQMMacSetupList;
  MacSetupRec: TMacSetup;
  ProdStep, WkcProc: String;
  TmpMacSetup: TMQMMachineSetup;
  Res: TmqmRes;
  IssArtList: TMQMIssuedArtList;
  FrmMat: TFShowMaterials;
  id: TSchedId;
begin
  Id := GetMouseSchedObj(false);

  p_sc.GetPlanInfo(id, planInfo);
  p_sc.GetTimingInfo(id, TimingInfo);

  MacSetupRec.WrkCtrCode := TimingInfo.wkctCode;
  MacSetupRec.MachineSetupCode := TimingInfo.MachSetupCode;

  ProdStep := p_sc.GetFldDescr(id, CSC_ProdStep, false);
  WkcProc :=  p_sc.GetFldDescr(id, CSC_WkctProc, false);

  MachSetupCodeList := p_sc.GetStepIssMaterials(id);

  if planInfo.isOnPlan then
  begin
    Res := TMqmRes(TMqmActArea(p_sc.getExtLinkPtr(id)).p_res);
    if Assigned(Res) then
    begin
      MacSetupRec.ResCat := Res.p_ResCat.p_ResCatCode;
      MacSetupRec.ResCode := Res.p_ResCode;
      MacSetupRec.WrkCtrCode := TMqmWrkCtr(Res.p_WrkCtr).p_WrkCtrCode;

      IssArtList := TMQMIssuedArtList.Create(true);
      MachSetupCodeList.GetIssuedArtList(MacSetupRec, IssArtList);

      FrmMat := TFShowMaterials.CreateFrmShowMat(self, id, nil, nil, nil, IssArtList, p_sc.GetReqBalList(Id));
      FrmMat.ShowModal;
      FrmMat.Free;

      IssArtList.Free;
    end;
  end else
  begin
    if MachSetupCodeList.p_count > 0 then
    begin
      TmpMacSetup := MachSetupCodeList.p_Item[0];

      MacSetupRec.ResCat := TmpMacSetup.p_ResCatCode;
      MacSetupRec.ResCode := TmpMacSetup.p_ResCode;
      MacSetupRec.WrkCtrCode := TmpMacSetup.p_WrkCtrCode;

      FrmMat := TFShowMaterials.CreateFrmShowMat(self, id, nil, nil, nil,
                                         TmpMacSetup.m_IssuedArtList, p_sc.GetReqBalList(Id));
      FrmMat.ShowModal;
      FrmMat.Free;
    end else
    begin
      FrmMat := TFShowMaterials.CreateFrmShowMat(self, id, nil, nil, nil,
                                         nil, p_sc.GetReqBalList(Id));
      FrmMat.ShowModal;
      FrmMat.Free;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFBin.MIClearAllMsgHostClick(Sender: TObject);
var
  tbs : TBinTabSheet;
begin
  p_sc.ClearMsgFromHost(true,-1);
  tbs  := FBin.GetActiveView;
  if Assigned(tbs) then
    tbs.m_BinPanel.UpdateForChangeFilter;  // Refresh Bin
end;

//----------------------------------------------------------------------------//

procedure TFBin.MIClearJobHostMsgClick(Sender: TObject);
var
  tbs : TBinTabSheet;
begin
  p_sc.ClearMsgFromHost(false,GetMouseSchedObj(false));
  tbs  := FBin.GetActiveView;
  if Assigned(tbs) then
    tbs.m_BinPanel.UpdateForChangeFilter;  // Refresh Bin
end;

//----------------------------------------------------------------------------//

procedure TFBin.MIClearJobWarpHostMsgClick(Sender: TObject);
var
  BinGrid : TBinDrawGridMat;
  tab     : TBinTabSheet;
  id      : TSchedID;
begin
  tab := TBinTabSheet(m_pgcBin.ActivePage);
  BinGrid := tab.GetMatGrid;
  if not assigned(BinGrid) then exit;
  ID := TSchedID(TBinPanel(binGrid.Parent).m_ObjList.GetLink(binGrid.p_GetRow - 1));
  if ID = CSchedIDnull then exit;
  p_sc.ClearMsgFromHost(false,Id);
  if Assigned(tab) then
    tab.m_BinPanel.UpdateForChangeFilter;  // Refresh Bin
end;

//----------------------------------------------------------------------------//

procedure TFBin.MINextLevelClick(Sender: TObject);
var
  id: TSchedId;
begin
  Id := GetMouseSchedObj(false);

  if (p_sc.GetSchedType(id) = '1') and (DBAppGlobals.ConfLevels >= 2) then
    p_opStack.SetSchedType(id, '3')

  else if (p_sc.GetSchedType(id) = '3') and (DBAppGlobals.ConfLevels >= 3) then
    p_opStack.SetSchedType(id, '4')

  else if (p_sc.GetSchedType(id) = '4') and (DBAppGlobals.ConfLevels >= 3) then
    p_opStack.SetSchedType(id, '5')
  else if (p_sc.GetSchedType(id) = '5') and (DBAppGlobals.ConfLevels >= 4) then
    p_opStack.SetSchedType(id, '6')
  else if (p_sc.GetSchedType(id) = '6') and (DBAppGlobals.ConfLevels >= 5) then
    p_opStack.SetSchedType(id, '7')
//  else if (p_sc.GetSchedType(id) = '7') and (DBAppGlobals.ConfLevels >= 6) then
//    p_opStack.SetSchedType(id, '8')
  else
    p_opStack.SetSchedType(id, '2');

  FMQMPlan.RefreshActiveTab;
  ChangeTabBinforChangeTabPlan;

  SetBinMenuItems(id);
end;

//----------------------------------------------------------------------------//

function GetValueForAssignedPropFromNextStepOrReqToSched(Id : TSchedId; PropId : TPropId; var value : string) : boolean;
var
  ProdNo : string;
  Step, J : integer;
  StepInfo: TSQStepInfo;
  SchedIdsList : TMSchedList;
  Prop : TProperties;
begin
  result := false;
  SchedIdsList := TMSchedList.Create(Application);
  ProdNo := p_sc.GetFldDescr(id, CSC_ProdReq, false);
  Step := StrToInt(p_sc.GetFldDescr(id, CSC_ProdStep, false));
  if p_sc.GetNextStepToSched(ProdNo ,Step, StepInfo) then
  begin
    if Assigned(StepInfo.ReqDet) then
      SchedIdsList.AddLink(StepInfo.FirstId);
  end
  else
    p_sc.GetNextConnReqFirstStepJobs(Id, SchedIdsList);

  for J := 0 to SchedIdsList.GetLinkCount - 1 do
  begin
    Id := SchedIdsList.GetLink(J);
    Prop := p_sc.GetProperties(Id,nil);
    if not FMPlannerPropDefine.CheckPropValueInJobList(Prop, PropId, value) then continue;
    result := true;
    break
  end;

end;

//----------------------------------------------------------------------------//

function SetAssignedPropertyValueForLinkedStepsForward(recursive : boolean; Id : TSchedId; PropId : TPropId; PropCode : string; value : string) : boolean;
var
  ProdNo : string;
  Step, J : integer;
  StepInfo, StepInfoPrev : TSQStepInfo;
  SchedIdsList : TMSchedList;
  Prop : TProperties;
  DummyValue : String;
begin
  result := false;
  SchedIdsList := TMSchedList.Create(Application);
  ProdNo := p_sc.GetFldDescr(id, CSC_ProdReq, false);
  Step := StrToInt(p_sc.GetFldDescr(id, CSC_ProdStep, false));
  if p_sc.GetNextStepToSched(ProdNo ,Step, StepInfo) then
  begin
    if Assigned(StepInfo.ReqDet) then
      SchedIdsList.AddLink(StepInfo.FirstId);
  end
  else
    p_sc.GetNextConnReqFirstStepJobs(Id, SchedIdsList);

  for J := 0 to SchedIdsList.GetLinkCount - 1 do
  begin
    Id := SchedIdsList.GetLink(J);
    Prop := p_sc.GetProperties(Id,nil);
    if not FMPlannerPropDefine.CheckPropValueInJobList(Prop, PropId, DummyValue) then continue;
    FMPlannerPropDefine.UpdatePropInJobList(Prop, PropId, value);
    UpdateMainListPropChange(Id, PropCode, value, false);
    result := true;
    if recursive then
      SetAssignedPropertyValueForLinkedStepsForward(true, Id, PropId, PropCode, value);
    break;
  end;

end;

//----------------------------------------------------------------------------//

function SetAssignedPropertyValueForLinkedStepsBackward(recursive : boolean; Id : TSchedId; PropId : TPropId; PropCode : string; var value : string) : boolean;
var
  ProdNo : string;
  Step, J : integer;
  StepInfoPrev : TSQStepInfo;
  SchedIdsList : TMSchedList;
  Prop : TProperties;
  DummyValue : String;
begin
  result := false;
  SchedIdsList := TMSchedList.Create(Application);
  ProdNo := p_sc.GetFldDescr(id, CSC_ProdReq, false);
  Step := StrToInt(p_sc.GetFldDescr(id, CSC_ProdStep, false));

  if p_sc.GetPrecStepToSched(ProdNo, Step, StepInfoPrev) then
  begin
    if Assigned(StepInfoPrev.ReqDet) then
      SchedIdsList.AddLink(StepInfoPrev.FirstId);
  end
  else
    p_sc.GetPrevConnReqLastStepJobs(Id, SchedIdsList);

  for J := 0 to SchedIdsList.GetLinkCount - 1 do
  begin
    Id := SchedIdsList.GetLink(J);
    Prop := p_sc.GetProperties(Id,nil);
    if not FMPlannerPropDefine.CheckPropValueInJobList(Prop, PropId, DummyValue) then continue;
    FMPlannerPropDefine.UpdatePropInJobList(Prop, PropId, value);
    UpdateMainListPropChange(Id, PropCode, value, false);
    result := true;
    if recursive then
      SetAssignedPropertyValueForLinkedStepsBackward(true, Id, PropId, PropCode, value);
    break;
  end;

end;

//----------------------------------------------------------------------------//

function SetAssignedPropertyValueForLinkedSteps(Id : TSchedId; PropId : TPropId; PropCode : string; var value : string) : boolean;
var
  ProdNo : string;
  Step, J : integer;
  StepInfo, StepInfoPrev : TSQStepInfo;
  SchedIdsList : TMSchedList;
  Prop : TProperties;
  DummyValue : String;
begin
  result := false;
  SchedIdsList := TMSchedList.Create(Application);
  ProdNo := p_sc.GetFldDescr(id, CSC_ProdReq, false);
  Step := StrToInt(p_sc.GetFldDescr(id, CSC_ProdStep, false));
  if p_sc.GetNextStepToSched(ProdNo ,Step, StepInfo) then
  begin
    if Assigned(StepInfo.ReqDet) then
      SchedIdsList.AddLink(StepInfo.FirstId);
  end
  else
    p_sc.GetNextConnReqFirstStepJobs(Id, SchedIdsList);

  for J := 0 to SchedIdsList.GetLinkCount - 1 do
  begin
    Id := SchedIdsList.GetLink(J);
    Prop := p_sc.GetProperties(Id,nil);
    if not FMPlannerPropDefine.CheckPropValueInJobList(Prop, PropId, DummyValue) then continue;
    FMPlannerPropDefine.UpdatePropInJobList(Prop, PropId, value);
    UpdateMainListPropChange(Id, PropCode, value, false);
    result := true;
    break
  end;

  SchedIdsList.ClearList;
  if p_sc.GetPrecStepToSched(ProdNo, Step, StepInfoPrev) then
  begin
    if Assigned(StepInfoPrev.ReqDet) then
      SchedIdsList.AddLink(StepInfoPrev.FirstId);
  end
  else
    p_sc.GetPrevConnReqLastStepJobs(Id, SchedIdsList);

  for J := 0 to SchedIdsList.GetLinkCount - 1 do
  begin
    Id := SchedIdsList.GetLink(J);
    Prop := p_sc.GetProperties(Id,nil);
    if not FMPlannerPropDefine.CheckPropValueInJobList(Prop, PropId, DummyValue) then continue;
    FMPlannerPropDefine.UpdatePropInJobList(Prop, PropId, value);
    UpdateMainListPropChange(Id, PropCode, value, false);
    result := true;
    break
  end;

end;

//----------------------------------------------------------------------------//

procedure TFBin.CopySelectionPropertyFromNextLinkedStep;
var
  tbs : TBinTabSheet;
  I, G, S : Integer;
  PropId : TPropId;
  Id, ChildId, NextSchedId : TSchedId;
  Prop : TProperties;
  Value, PropCode : string;
  PlanInfo, PlanInfoTemp : TSQplanInfo;
begin

  tbs := TBinTabSheet(m_pgcBin.ActivePage);

  if Assigned(tbs) then
  begin
    PropId := GetAssignedBooleanProp1;
    if PropId = nil then exit;

    PropCode := GetPropCodeFromID(PropId);
    for i := 0 to tbs.m_BinPanel.m_objList.GetLinkCount-1 do
    begin
      Id := tbs.m_BinPanel.m_objList.GetLink(i);
      p_sc.GetPlanInfo(id, PlanInfo);
      if (planInfo.VisibleInBin = CSB_ReadOnly) then continue;

      G := 0;
      ChildId := CSchedIDnull;
      while True do
      begin
        if (planInfo.isGroup) then
        begin
          if G = p_sc.GetGrpNumSons(Id) then break;
          ChildId := p_sc.GetGrpSon(Id, G);
          G := G + 1;
        end
        else
        begin
          if ChildId <> CSchedIDnull then break;
          ChildId := Id;
        end;

        if not GetValueForAssignedPropFromNextStepOrReqToSched(ChildId, PropId, value) then continue;

        Prop := p_sc.GetProperties(ChildId,nil);
        FMPlannerPropDefine.UpdatePropInJobList(Prop, PropId, value);
        UpdateMainListPropChange(ChildId, PropCode, value, false);

      end;
    end;

    if assigned(FBin) then FBin.RefreshGrid;

  end;
end;

//----------------------------------------------------------------------------//

procedure TFBin.Copy1Click(Sender: TObject);
var
  I : Integer;
  BinGrid : TBinDrawGridMat;
  Str : string;
  tab : TBinTabSheet;
begin
  tab := TBinTabSheet(m_pgcBin.ActivePage);
  BinGrid := tab.GetMatGrid;
  if assigned(BinGrid) then
  begin
    I := binGrid.BinMatColumnSet[binGrid.p_GetCol - binGrid.FixedCols - binGrid.p_GetFixedColumns].RealPos;
    if I >= 0 then
    begin
      Str := p_sc.GetFldDescr(TSchedID(TBinPanel(binGrid.Parent).m_ObjList.GetLink(binGrid.p_GetRow - 1)), binGrid.BinMatColumnSet[I].Field, false);
      Clipboard.AsText := Str;
    end
  end;

end;

procedure TFBin.CopySelectionPropertyFromCurrentStepToNextStepClick(
  Sender: TObject);
var
  tbs : TBinTabSheet;
  I, G, S : Integer;
  PropId : TPropId;
  Id, ChildId, NextSchedId : TSchedId;
  Prop : TProperties;
  Value, PropCode : string;
  PlanInfo, PlanInfoTemp : TSQplanInfo;
begin

  tbs := TBinTabSheet(m_pgcBin.ActivePage);

  if Assigned(tbs) then
  begin
    PropId := GetAssignedBooleanProp1;
    if PropId = nil then exit;

    PropCode := GetPropCodeFromID(PropId);
    for i := 0 to tbs.m_BinPanel.m_objList.GetLinkCount-1 do
    begin
      Id := tbs.m_BinPanel.m_objList.GetLink(i);
      p_sc.GetPlanInfo(id, PlanInfo);
      if (planInfo.VisibleInBin = CSB_ReadOnly) then continue;

      G := 0;
      ChildId := CSchedIDnull;
      while True do
      begin
        if (planInfo.isGroup) then
        begin
          if G = p_sc.GetGrpNumSons(Id) then break;
          ChildId := p_sc.GetGrpSon(Id, G);
          G := G + 1;
        end
        else
        begin
          if ChildId <> CSchedIDnull then break;
          ChildId := Id;
        end;

        Prop := p_sc.GetProperties(ChildId,nil);
        if not FMPlannerPropDefine.CheckPropValueInJobList(Prop, PropId, value) then continue;
        SetAssignedPropertyValueForLinkedStepsForward(false, ChildId, PropId, PropCode, value);

      end;
    end;

    if Assigned(FBin) then FBin.RefreshGrid;

  end;
end;

//----------------------------------------------------------------------------//

procedure TFBin.CopySelectionPropertyFromCurrentStepToNextStepsClick(
  Sender: TObject);
var
  tbs : TBinTabSheet;
  I, G, S : Integer;
  PropId : TPropId;
  Id, ChildId, NextSchedId : TSchedId;
  Prop : TProperties;
  Value, PropCode : string;
  PlanInfo, PlanInfoTemp : TSQplanInfo;
begin

  tbs := TBinTabSheet(m_pgcBin.ActivePage);

  if Assigned(tbs) then
  begin
    PropId := GetAssignedBooleanProp1;
    if PropId = nil then exit;

    PropCode := GetPropCodeFromID(PropId);
    for i := 0 to tbs.m_BinPanel.m_objList.GetLinkCount-1 do
    begin
      Id := tbs.m_BinPanel.m_objList.GetLink(i);
      p_sc.GetPlanInfo(id, PlanInfo);
      if (planInfo.VisibleInBin = CSB_ReadOnly) then continue;

      G := 0;
      ChildId := CSchedIDnull;
      while True do
      begin
        if (planInfo.isGroup) then
        begin
          if G = p_sc.GetGrpNumSons(Id) then break;
          ChildId := p_sc.GetGrpSon(Id, G);
          G := G + 1;
        end
        else
        begin
          if ChildId <> CSchedIDnull then break;
          ChildId := Id;
        end;

        Prop := p_sc.GetProperties(ChildId,nil);
        if not FMPlannerPropDefine.CheckPropValueInJobList(Prop, PropId, value) then continue;
        SetAssignedPropertyValueForLinkedStepsForward(true, ChildId, PropId, PropCode, value);

      end;
    end;

    if assigned(FBin) then FBin.RefreshGrid;

  end;
end;

procedure TFBin.CopySelectionPropertyFromCurrentStepToPrevAndNextStep;
var
  tbs : TBinTabSheet;
  I, G, S : Integer;
  PropId : TPropId;
  Id, ChildId, NextSchedId : TSchedId;
  Prop : TProperties;
  Value, PropCode : string;
  PlanInfo, PlanInfoTemp : TSQplanInfo;
begin

  tbs := TBinTabSheet(m_pgcBin.ActivePage);

  if Assigned(tbs) then
  begin
    PropId := GetAssignedBooleanProp1;
    if PropId = nil then exit;

    PropCode := GetPropCodeFromID(PropId);
    for i := 0 to tbs.m_BinPanel.m_objList.GetLinkCount-1 do
    begin
      Id := tbs.m_BinPanel.m_objList.GetLink(i);
      p_sc.GetPlanInfo(id, PlanInfo);
      if (planInfo.VisibleInBin = CSB_ReadOnly) then continue;

      G := 0;
      ChildId := CSchedIDnull;
      while True do
      begin
        if (planInfo.isGroup) then
        begin
          if G = p_sc.GetGrpNumSons(Id) then break;
          ChildId := p_sc.GetGrpSon(Id, G);
          G := G + 1;
        end
        else
        begin
          if ChildId <> CSchedIDnull then break;
          ChildId := Id;
        end;

        Prop := p_sc.GetProperties(ChildId,nil);
        if not FMPlannerPropDefine.CheckPropValueInJobList(Prop, PropId, value) then continue;
//        SetAssignedPropertyValueForLinkedSteps(ChildId, PropId, PropCode, value)
        SetAssignedPropertyValueForLinkedStepsForward(false, ChildId, PropId, PropCode, value);
        SetAssignedPropertyValueForLinkedStepsBackward(false, ChildId, PropId, PropCode, value);


      end;
    end;

    if assigned(FBin) then FBin.RefreshGrid;

  end;
end;

procedure TFBin.CopySelectionPropertyFromCurrentStepToPrevStepClick(
  Sender: TObject);
var
  tbs : TBinTabSheet;
  I, G, S : Integer;
  PropId : TPropId;
  Id, ChildId, NextSchedId : TSchedId;
  Prop : TProperties;
  Value, PropCode : string;
  PlanInfo, PlanInfoTemp : TSQplanInfo;
begin

  tbs := TBinTabSheet(m_pgcBin.ActivePage);

  if Assigned(tbs) then
  begin
    PropId := GetAssignedBooleanProp1;
    if PropId = nil then exit;

    PropCode := GetPropCodeFromID(PropId);
    for i := 0 to tbs.m_BinPanel.m_objList.GetLinkCount-1 do
    begin
      Id := tbs.m_BinPanel.m_objList.GetLink(i);
      p_sc.GetPlanInfo(id, PlanInfo);
      if (planInfo.VisibleInBin = CSB_ReadOnly) then continue;

      G := 0;
      ChildId := CSchedIDnull;
      while True do
      begin
        if (planInfo.isGroup) then
        begin
          if G = p_sc.GetGrpNumSons(Id) then break;
          ChildId := p_sc.GetGrpSon(Id, G);
          G := G + 1;
        end
        else
        begin
          if ChildId <> CSchedIDnull then break;
          ChildId := Id;
        end;

        Prop := p_sc.GetProperties(ChildId,nil);
        if not FMPlannerPropDefine.CheckPropValueInJobList(Prop, PropId, value) then continue;
        SetAssignedPropertyValueForLinkedStepsBackward(false, ChildId, PropId, PropCode, value);

      end;
    end;

    if assigned(FBin) then FBin.RefreshGrid;

  end;
end;

//----------------------------------------------------------------------------//

procedure TFBin.CopySelectionPropertyFromCurrentStepToPrevStepsClick(
  Sender: TObject);
var
  tbs : TBinTabSheet;
  I, G, S : Integer;
  PropId : TPropId;
  Id, ChildId, NextSchedId : TSchedId;
  Prop : TProperties;
  Value, PropCode : string;
  PlanInfo, PlanInfoTemp : TSQplanInfo;
begin

  tbs := TBinTabSheet(m_pgcBin.ActivePage);

  if Assigned(tbs) then
  begin
    PropId := GetAssignedBooleanProp1;
    if PropId = nil then exit;

    PropCode := GetPropCodeFromID(PropId);
    for i := 0 to tbs.m_BinPanel.m_objList.GetLinkCount-1 do
    begin
      Id := tbs.m_BinPanel.m_objList.GetLink(i);
      p_sc.GetPlanInfo(id, PlanInfo);
      if (planInfo.VisibleInBin = CSB_ReadOnly) then continue;

      G := 0;
      ChildId := CSchedIDnull;
      while True do
      begin
        if (planInfo.isGroup) then
        begin
          if G = p_sc.GetGrpNumSons(Id) then break;
          ChildId := p_sc.GetGrpSon(Id, G);
          G := G + 1;
        end
        else
        begin
          if ChildId <> CSchedIDnull then break;
          ChildId := Id;
        end;

        Prop := p_sc.GetProperties(ChildId,nil);
        if not FMPlannerPropDefine.CheckPropValueInJobList(Prop, PropId, value) then continue;
        SetAssignedPropertyValueForLinkedStepsBackward(true, ChildId, PropId, PropCode, value);

      end;
    end;

    if assigned(FBin) then FBin.RefreshGrid;

  end;
end;

//----------------------------------------------------------------------------//

procedure TFBin.SetAllJobsAssgnedProp1(Flag : boolean; IncludeSameServingCode : boolean);
var
  tbs : TBinTabSheet;
  I, G, S : Integer;
  PropId : TPropId;
  Id, ChildId, TempId : TSchedId;
  Prop : TProperties;
  Value, PropCode : string;
  PlanInfo, PlanInfoTemp : TSQplanInfo;
  ServingCodeIdList : TMSchedList;
//  isGroup : boolean;
begin

  if Flag then
    Value := _('1')
  else
    Value := _('0');
  tbs := TBinTabSheet(m_pgcBin.ActivePage);

  if Assigned(tbs) then
  begin
    PropId := GetAssignedBooleanProp1;
    if PropId = nil then exit;

    ServingCodeIdList := TMSchedList.Create(self);
    PropCode := GetPropCodeFromID(PropId);
    for i := 0 to tbs.m_BinPanel.m_objList.GetLinkCount-1 do
    begin
      Id := tbs.m_BinPanel.m_objList.GetLink(i);
      p_sc.GetPlanInfo(id, PlanInfo);
      if (planInfo.VisibleInBin = CSB_ReadOnly) then continue;

      G := 0;
      ChildId := CSchedIDnull;
      while True do
      begin
        if (planInfo.isGroup) then
        begin
          if G = p_sc.GetGrpNumSons(Id) then break;
          ChildId := p_sc.GetGrpSon(Id, G);
          G := G + 1;
        end
        else
        begin
          if ChildId <> CSchedIDnull then break;
          ChildId := Id;
        end;

        Prop := p_sc.GetProperties(ChildId,nil);
        FMPlannerPropDefine.UpdatePropInJobList(Prop, PropId, value);
        UpdateMainListPropChange(ChildId, PropCode, value, false);

        if IncludeSameServingCode then
        begin
          p_sc.GetServingGroupCode(ChildId, true, ServingCodeIdList);
          for S := 0 to ServingCodeIdList.GetLinkCount - 1 do
          begin
            TempId := ServingCodeIdList.GetLink(S);
            p_sc.GetPlanInfo(TempId, PlanInfoTemp);
            if (planInfoTemp.VisibleInBin = CSB_ReadOnly) then continue;
            Prop := p_sc.GetProperties(TempId,nil);
            FMPlannerPropDefine.UpdatePropInJobList(Prop, PropId, value);
            UpdateMainListPropChange(TempId, PropCode, value, false)
          end;
          ServingCodeIdList.ClearList;
        end;

      end;
    end;

    if Assigned(ServingCodeIdList) then ServingCodeIdList.Free;
    if assigned(FBin) then FBin.RefreshGrid;

  end;

end;

//----------------------------------------------------------------------------//

procedure TFBin.SetGroupedByFieldMenu;
var
  I, J, G : Integer;
  MenuItemI, NewItem : TMenuItem;
  GroupedByFieldList : TStringList;
begin
  GroupedByFieldList := GetAllGroupedByFieldList;
  if Assigned(GroupedByFieldList) then
  begin
    for I := 0 to PopUpBin.Items.Count - 1 do
    begin
      if (PopUpBin.Items[I].Name = 'MINewTabMain') then
      begin
        MenuItemI := PopUpBin.Items[I];
        for J := 0 to MenuItemI.Count - 1 do
        begin
          if (MenuItemI[J].Name = 'MIGroupedBy') then
          begin
            MenuItemI := MenuItemI[J];
            MenuItemI.Visible := true;
            for G := MenuItemI.Count - 1 downto 0 do
              MenuItemI.Items[G].free;

            for G := 0 to GroupedByFieldList.Count - 1 do
            begin
              NewItem := TMenuItem.Create(Self);
              NewItem.Caption := GroupedByFieldList.Strings[G];
              NewItem.Name    := GroupedByFieldList.Strings[G];
              NewItem.OnClick := ClickGroupedByCode;
              NewItem.Visible := true;
              //NewItem.OnDrawItem := DrawItemPopUp;
              MenuItemI.add(NewItem);
            end;
            break;
          end;
        end;
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

function CheckDrillDown(ActiveTab, tab : TBinTabSheet) : boolean;
var
  I, J : Integer;
  Found : boolean;
  GroupedByFieldSetActive, GroupedByFieldSetTab : PTGroupedByFieldSet;
  PropCodeList : TStringList;
begin
  result := false;
  if (tab.m_BinPanel.GetFiltParms.P_GroupedByCode = '') then
  begin
    result := true;
    exit
  end;
  if (ActiveTab.m_BinPanel.GetFiltParms.P_GroupedByCode = tab.m_BinPanel.GetFiltParms.P_GroupedByCode) then
  begin
    result := true;
    exit
  end
  else
  begin
    GroupedByFieldSetActive := GetGroupBySetByCode(ActiveTab.m_BinPanel.GetFiltParms.P_GroupedByCode);
    GroupedByFieldSetTab     := GetGroupBySetByCode(Tab.m_BinPanel.GetFiltParms.P_GroupedByCode);

    if (GroupedByFieldSetActive = nil) or (GroupedByFieldSetTab = nil) then
       exit;

    if (FiltProdReq in GroupedByFieldSetActive.GroupedByOption) and
       not (FiltProdReq in GroupedByFieldSetTab.GroupedByOption) then
    begin
      exit
    end;

    if (FiltProdFamily in GroupedByFieldSetActive.GroupedByOption) and
       not (FiltProdFamily in GroupedByFieldSetTab.GroupedByOption) then
    begin
      exit
    end;

    PropCodeList := TStringList.create;
    for I := Low(GroupedByFieldSetActive.PropCode) to High(GroupedByFieldSetActive.PropCode) do
      if GroupedByFieldSetActive.PropCode[I] <> '' then
        PropCodeList.Add(GroupedByFieldSetActive.PropCode[I]);

    for J := 0 to PropCodeList.Count - 1 do
    begin
      Found := false;
      for I := Low(GroupedByFieldSetTab.PropCode) to High(GroupedByFieldSetTab.PropCode) do
      begin
        if PropCodeList.Strings[J] = GroupedByFieldSetTab.PropCode[I] then
        begin
          Found := true;
          continue
        end;
      end;
    end;

    if found = true then
       result := true;

    PropCodeList.Free;
  end;

end;

//----------------------------------------------------------------------------//

procedure TFBin.SetOverrideExistingTabForDrillDown;
var
  I, G, C : Integer;
  MenuItemI, NewItem  : TMenuItem;
  tbs, ActiveTab : TBinTabSheet;
  dataType : CBinColValType;
  Desc : string;
begin
  Desc := '';
  ActiveTab := GetActiveView;
  if not assigned(ActiveTab) then exit;

  for I := 0 to PopUpBin.Items.Count - 1 do
  begin
    if (PopUpBin.Items[I].Name = 'MiDrillDown') then
    begin
      PopUpBin.Items[I].Visible := true;
      MenuItemI := PopUpBin.Items[I];
      for G := MenuItemI.Count - 1 downto 0 do
        MenuItemI.Items[G].free;

      if not Assigned(ActiveTab) then exit;

      for G := (m_TbCfg.p_GetTabsCount - 1) downto 0 do
      begin
        tbs := TBinTabSheet(GetTabByCode(m_TbCfg.GetTab(G).code));
        if tbs = ActiveTab then continue;

        if tbs.m_BinPanel.GetFiltParms.P_OverriddenTab then
        begin
          if CheckDrillDown(ActiveTab, tbs) then
          begin
            NewItem := TMenuItem.Create(Self);
            NewItem.Caption := m_TbCfg.GetTab(G).name;
            NewItem.Name    := 'MiOverridForDrill' + IntToStr(m_TbCfg.GetTab(G).code);
            NewItem.VCLComObject := tbs;
            NewItem.OnClick := UpdateFilterForOverridenTab;
          //  NewItem.OnDrawItem := DrawItemPopUp;
            MenuItemI.add(NewItem);
          end;
        end;
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFBin.MiSetlinkedStepsPropertyValueFromJobSelectionClick(
  Sender: TObject);
begin
  CopySelectionPropertyFromCurrentStepToPrevAndNextStep;
end;

//----------------------------------------------------------------------------//

procedure TFBin.MiSettAllCopyValueFromNextLinkedReqClick(Sender: TObject);
begin
  CopySelectionPropertyFromNextLinkedStep;
end;

//----------------------------------------------------------------------------//

procedure TFBin.MiSettAllJobsAssgnedJobFalseAndServingCodeClick(Sender: TObject);
begin
  SetAllJobsAssgnedProp1(false, true);
end;

//----------------------------------------------------------------------------//

procedure TFBin.MiSettAllJobsAssgnedJobFalseClick(Sender: TObject);
begin
  SetAllJobsAssgnedProp1(false, false);
end;

//----------------------------------------------------------------------------//

procedure TFBin.MiSettAllJobsAssgnedJobTrueAndServingCodeClick(Sender: TObject);
begin
  SetAllJobsAssgnedProp1(true, true);
end;

procedure TFBin.MiSettAllJobsAssgnedJobTrueClick(Sender: TObject);
begin
  SetAllJobsAssgnedProp1(true, false);
end;

//----------------------------------------------------------------------------//

procedure TFBin.MiSetWcPlantClick(Sender: TObject);
var
  i   : integer;
  tbs : TBinTabSheet;
  id  : TSchedId;
  Save_Cursor : TCursor;
begin
  Save_Cursor   := Screen.Cursor;
  Screen.Cursor  := crAppStart;
  tbs := TBinTabSheet(m_pgcBin.GetActiveView);
  if not Assigned(tbs) then exit;
  for i := 0 to tbs.m_BinPanel.m_objList.GetLinkCount - 1 do
  begin
    id := tbs.m_BinPanel.m_objList.GetLink(i);
    if id = CSchedIdNull then break;
    p_sc.ChangeWcPlanedToWcMain(id);
  end;
  ChangeTabBinforChangeTabPlan;
  Screen.Cursor := Save_Cursor;
end;

//----------------------------------------------------------------------------//

procedure TFBin.MiSetWorkCenterPlantClick(Sender: TObject);
var
  i,JobsInBinCount  : integer;
  tbs : TBinTabSheet;
  BinGrid : TBinDrawGrid;
  id  : TSchedId;
  Save_Cursor : TCursor;
  SchedList: TMSchedList;
begin
  Save_Cursor   := Screen.Cursor;
  Screen.Cursor  := crAppStart;
  tbs := TBinTabSheet(m_pgcBin.GetActiveView);
  if not Assigned(tbs) then exit;
  BinGrid := tbs.GetBinGrid;
  if BinGrid.pSelectedMarked then
  begin
    SchedList := BinGrid.GetSelectedList;
    JobsInBinCount := SchedList.GetLinkCount;
    for i := (JobsInBinCount - 1) downto 0 do
    begin
      id := SchedList.GetLink(I);
      if id = CSchedIdNull then break;
      p_sc.ChangeWcPlanedToWcMain(id);
    end;
  end;
  ChangeTabBinforChangeTabPlan;
  Screen.Cursor := Save_Cursor;
end;

//----------------------------------------------------------------------------//

procedure TFBin.MISetConfLevelToClick(Sender: TObject);
var
  BinGrid : TBinDrawGrid;
  tab : TBinTabSheet;
  Id  : TSchedId;
  SchedList : TMSchedList;
  I, JobsInBinCount : integer;
  planInfo: TSQplanInfo;
begin
  tab := TBinTabSheet(m_pgcBin.ActivePage);
  BinGrid := tab.GetBinGrid;

//  if IsAutoRunMode then
//    BinGrid.SetAllSelected;

  if BinGrid.pSelectedMarked or IsAutoRunMode then
  begin
    if IsAutoRunMode then
      SchedList := BinGrid.GetAllAsSelectedForAutoRun
    else
      SchedList := BinGrid.GetSelectedList;
    JobsInBinCount := SchedList.GetLinkCount;
    for i := (JobsInBinCount - 1) downto 0 do
    begin
      id := SchedList.GetLink(I);
      if id = CSchedIdNull then break;
      p_sc.GetPlanInfo(Id, planInfo);
      if (planInfo.VisibleInBin = CSB_ReadOnly) then continue;
      if TMenuItem(Sender).name = 'MiConfInitial' then
         p_opStack.SetSchedType(id, '1')
      else if TMenuItem(Sender).name = 'MiConfFinal' then
         p_opStack.SetSchedType(id, '2')
      else if TMenuItem(Sender).name = 'MiConfLevel1' then
         p_opStack.SetSchedType(id, '3')
      else if TMenuItem(Sender).name = 'MiConfLevel2' then
         p_opStack.SetSchedType(id, '4')
      else if TMenuItem(Sender).name = 'MiConfLevel3' then
         p_opStack.SetSchedType(id, '5')
      else if TMenuItem(Sender).name = 'MiConfLevel4' then
         p_opStack.SetSchedType(id, '6')
      else if TMenuItem(Sender).name = 'MiConfLevel5' then
         p_opStack.SetSchedType(id, '7');
    end;
  end
  else
  begin
    id := GetMouseSchedObj(false);
    if (id <> CSchedIdNull) then
    begin
      if TMenuItem(Sender).name = 'MiConfInitial' then
         p_opStack.SetSchedType(id, '1')
      else if TMenuItem(Sender).name = 'MiConfFinal' then
         p_opStack.SetSchedType(id, '2')
      else if TMenuItem(Sender).name = 'MiConfLevel1' then
         p_opStack.SetSchedType(id, '3')
      else if TMenuItem(Sender).name = 'MiConfLevel2' then
         p_opStack.SetSchedType(id, '4')
      else if TMenuItem(Sender).name = 'MiConfLevel3' then
         p_opStack.SetSchedType(id, '5')
      else if TMenuItem(Sender).name = 'MiConfLevel4' then
         p_opStack.SetSchedType(id, '6')
      else if TMenuItem(Sender).name = 'MiConfLevel5' then
         p_opStack.SetSchedType(id, '7');

    //  SetBinMenuItems(id);
    end;
  end;

  FMQMPlan.RefreshActiveTab;
  ChangeTabBinforChangeTabPlan;

end;

//----------------------------------------------------------------------------//

procedure TFBin.MIShowrequiermentsClick(Sender: TObject);
var
  Id : TSchedId;
begin
  Id := GetMouseSchedObj(false);
  if id = -1 then exit;
  if p_sc.IsGroup(Id) then exit;
  ShowRequiermants(Id);
end;

//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
{
  Changes the way the rows are selected in the bin. Row vs cell.

  @param FullRowSelect  If true then select full row otherwise select cell

  }
//----------------------------------------------------------------------------//

procedure TFBin.ChangeBinOptions(FullRowSelect: boolean);
var
  i: Integer;
  tbs:  TBinTabSheet;
  grid: TBinDrawGrid;
  grid2: TDrawGrid;
  gridmat: TBinDrawGridMat;
begin
  try

    for i:= 0 to m_pgcBin.PageCount-1 do
    begin
      tbs := TBinTabSheet(m_pgcBin.Pages[i]);
      if not Assigned(tbs) then continue;
      grid := tbs.GetBinGrid;
      grid2 := TdrawGrid(grid);
      if not Assigned(grid) then continue;
      if FullRowSelect then
        grid2.Options := [goColSizing, goFixedVertLine, goFixedHorzLine, goVertLine,
                         goHorzLine, goThumbTracking,  goRowSelect,  goDrawFocusSelected]
      else
        grid2.Options := [goColSizing, goFixedVertLine, goFixedHorzLine, goVertLine,
                         goHorzLine, goThumbTracking,  goDrawFocusSelected];
    end;

    for i:= 0 to m_pgcBin.PageCount-1 do
    begin
      tbs := TBinTabSheet(m_pgcBin.Pages[i]);
      if not Assigned(tbs) then continue;
      gridmat := tbs.GetMatGrid;
      grid2 := TdrawGrid(gridmat);
      if not Assigned(gridmat) then continue;
      if FullRowSelect then
        grid2.Options := [goColSizing, goFixedVertLine, goFixedHorzLine, goVertLine,
                         goHorzLine, goThumbTracking,  goRowSelect,  goDrawFocusSelected]
      else
        grid2.Options := [goColSizing, goFixedVertLine, goFixedHorzLine, goVertLine,
                         goHorzLine, goThumbTracking,  goDrawFocusSelected];
    end;
  except
    on e:Exception do MessageDlg('FMbin - ChangeBinOptions'+#13'Message: '+e.Message,mtError, [mbOK],0);
  end;

end;

//----------------------------------------------------------------------------//

procedure TFBin.ShowRequiermants(Id : TSchedId);
var
  planInfo: TSQplanInfo;
  TimingInfo: TSQtimingInfo;
  MachSetupCodeList :TMQMMacSetupList;
  MacSetupRec: TMacSetup;
  TmpMacSetup: TMQMMachineSetup;
  ProdStep, WkcProc: String;
  Res: TmqmRes;
  IssArtList: TMQMIssuedArtList;
  FrmMat: TFMaterialReq;//TForm2;//TFShowMaterials;
begin
  p_sc.GetPlanInfo(id, planInfo);
  p_sc.GetTimingInfo(id, TimingInfo);

  MacSetupRec.WrkCtrCode := TimingInfo.wkctCode;
  MacSetupRec.MachineSetupCode := TimingInfo.MachSetupCode;

  ProdStep := p_sc.GetFldDescr(id, CSC_ProdStep, false);
  WkcProc :=  p_sc.GetFldDescr(id, CSC_WkctProc, false);

  MachSetupCodeList := p_sc.GetStepIssMaterials(id);

  if planInfo.isOnPlan then
  begin
    Res := TMqmRes(TMqmActArea(p_sc.getExtLinkPtr(id)).p_res);
    if Assigned(Res) then
    begin
      MacSetupRec.ResCat := Res.p_ResCat.p_ResCatCode;
      MacSetupRec.ResCode := Res.p_ResCode;
      MacSetupRec.WrkCtrCode := TMqmWrkCtr(Res.p_WrkCtr).p_WrkCtrCode;

      IssArtList := TMQMIssuedArtList.Create(true);
      MachSetupCodeList.GetIssuedArtList(MacSetupRec, IssArtList);

      FrmMat := TFMaterialReq.CreateReqForm(self,id,IssArtList); //TFShowMaterials.CreateFrmShowMat(self, id, nil, nil, nil, IssArtList, p_sc.GetReqBalList(Id));
      FrmMat.ShowModal;
      FrmMat.Free;

      IssArtList.Free;
    end;
  end else
  begin
    if MachSetupCodeList.p_count > 0 then
    begin
      TmpMacSetup := MachSetupCodeList.p_Item[0];

      MacSetupRec.ResCat := TmpMacSetup.p_ResCatCode;
      MacSetupRec.ResCode := TmpMacSetup.p_ResCode;
      MacSetupRec.WrkCtrCode := TmpMacSetup.p_WrkCtrCode;

      //FrmMat := TFShowMaterials.CreateFrmShowMat(self, id, nil, nil, nil,
      //                                   TmpMacSetup.m_IssuedArtList, p_sc.GetReqBalList(Id));
      FrmMat := TFMaterialReq.CreateReqForm(self,id,TmpMacSetup.m_IssuedArtList);
      FrmMat.ShowModal;
      FrmMat.Free;
    end else
    begin
     // FrmMat := TFShowMaterials.CreateFrmShowMat(self, id, nil, nil, nil,
     //                                    nil, p_sc.GetReqBalList(Id));
      FrmMat := TFMaterialReq.CreateReqForm(self,id,nil);
      FrmMat.ShowModal;
      FrmMat.Free;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFBin.TBRefreshClick(Sender: TObject);
var
  tbs : TBinTabSheet;
  Save_Cursor : TCursor;
begin
  if (TBRefresh.Tag = 0) then
     Exit;

  Save_Cursor   := Screen.Cursor;
  Screen.Cursor  := crAppStart; //SQLWait;

  tbs  := FBin.GetActiveView;
  if Assigned(tbs) then
  begin
   // tbs.m_BinPanel.UpdateForChangeFilter;
    tbs.m_BinPanel.MainUpdateFilterAndSortTab;
    DeActivateRefreshButton
  end;
  Screen.Cursor := Save_Cursor;

end;

procedure TFBin.TBReportClick(Sender: TObject);
var Cfg : TBinTabCfg;
  tbsNew : TBinTabSheet;
begin

  tbsNew := GetActiveView;
  cfg := TBinTabCfg(m_tbCfg.FindTab(tbsNew.GetCode));

  FBinRep := TFBinRep.CreateBinReport(Self, cfg);
  FBinRep.formStyle := fsStayOnTop;
  FBinRep.Show

end;

//----------------------------------------------------------------------------//

procedure TFBin.TBStartAutoSchedMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  id: TSchedId;
begin
  m_toolBarpopUp := true;
  Id := GetMouseSchedObj(false);
  SetGroupedByPopup;
  SetBinMenuItems(Id);
  m_toolBarpopUp := false;
end;

//----------------------------------------------------------------------------//

procedure TFBin.TBUpDownOrderClick(Sender: TObject);
var
  tab : TBinTabSheet;
  I, J : Integer;
  BinGrid : TBinDrawGrid;
  BinGridMat : TBinDrawGridMat;
  ItmToMod, FromIndex, ToIndex : Integer;
begin
  ItmToMod := -1;
  ToIndex := 0;
  tab := TBinTabSheet(m_pgcBin.ActivePage);

  if not Assigned(tab) then exit;

  if tab.m_BinPanel.GetFiltParms.P_MaterialSchedFilter then
  begin
    BinGridMat := tab.GetMatGrid;

    if Assigned(tab) and (goRowSelect in (BinGridMat).Options) then
      exit;

    if TBinPanel(BinGridMat.Parent).m_ObjList.GetLinkCount <= 0 then exit;
    I := BinGridMat.BinMatColumnSet[BinGridMat.p_GetCol - BinGridMat.FixedCols - BinGridMat.p_GetFixedColumns].RealPos;
    if I >= 0 then
    begin

      for J := low(BinGridMat.BinMatColumnSet) to high(BinGridMat.BinMatColumnSet) do
        BinGridMat.BinMatColumnSet[J].DescendingSort := false;

      FromIndex := BinGridMat.BinMatColumnSet[I].Order;
      for i := low(BinGridMat.BinMatColumnSet) to high(BinGridMat.BinMatColumnSet) do
        if BinGridMat.BinMatColumnSet[i].Order = FromIndex then
        begin
          ItmToMod := i;
          break;
        end;

      for i := low(BinGridMat.BinMatColumnSet) to high(BinGridMat.BinMatColumnSet) do
        if (BinGridMat.BinMatColumnSet[i].Order < FromIndex) and (BinGridMat.BinMatColumnSet[i].Order >= ToIndex) and
           (ItmToMod <> i) then
          BinGridMat.BinMatColumnSet[i].Order := BinGridMat.BinMatColumnSet[i].Order + 1;

      BinGridMat.BinMatColumnSet[ItmToMod].Order := ToIndex;

      if (TToolButton(Sender).Name = 'TBDownOrder') then
        BinGridMat.BinMatColumnSet[ItmToMod].DescendingSort := true;

      if Assigned(tab) then
        tab.m_BinPanel.UpdateForChangeFilter;  // Refresh Bin

    end;

  end
  else
  begin
    MICreateBinUsingCurentCell.Visible := true;
    if m_pgcBin.PageCount < 1 then Exit;
    BinGrid := tab.GetBinGrid;
    if Assigned(tab) and (goRowSelect in (BinGrid).Options) then
      exit;

    if not binGrid.Focused then exit;

    if TBinPanel(binGrid.Parent).m_ObjList.GetLinkCount <= 0 then exit;
    I := binGrid.BinColumnSet[binGrid.p_GetCol - binGrid.FixedCols - binGrid.p_GetFixedColumns].RealPos;
    if I >= 0 then
    begin

      for J := low(binGrid.BinColumnSet) to high(binGrid.BinColumnSet) do
        binGrid.BinColumnSet[J].DescendingSort := false;

      FromIndex := binGrid.BinColumnSet[I].Order;
      for i := low(binGrid.BinColumnSet) to high(binGrid.BinColumnSet) do
        if binGrid.BinColumnSet[i].Order = FromIndex then
        begin
          ItmToMod := i;
          break;
        end;

      for i := low(binGrid.BinColumnSet) to high(binGrid.BinColumnSet) do
        if (binGrid.BinColumnSet[i].Order < FromIndex) and (binGrid.BinColumnSet[i].Order >= ToIndex) and
           (ItmToMod <> i) then
          binGrid.BinColumnSet[i].Order := binGrid.BinColumnSet[i].Order + 1;

      binGrid.BinColumnSet[ItmToMod].Order := ToIndex;

      if (TToolButton(Sender).Name = 'TBDownOrder') then
        binGrid.BinColumnSet[ItmToMod].DescendingSort := true;

      if Assigned(tab) then
        tab.m_BinPanel.UpdateForChangeFilter;  // Refresh Bin

    end;

  end;

end;

procedure TFBin.testClick(Sender: TObject);
begin
   //
end;

//----------------------------------------------------------------------------//

procedure TFBin.TimerJobMsgTimer(Sender: TObject);
begin
  TimerJobMsg.Interval := 600;
  if (TBJobMsg.ImageIndex = -1) then
    TBJobMsg.ImageIndex := 47
  else
    TBJobMsg.ImageIndex := -1
end;

//----------------------------------------------------------------------------//

procedure TFBin.TBPosColumnOnBinClick(Sender: TObject);
var
  tab : TBinTabSheet;
  I : Integer;
  BinGrid : TBinDrawGrid;
  BinMatGrid : TBinDrawGridMat;
  Desc, Title : string;
  dataType: CBinColValType;
begin
  tab := TBinTabSheet(m_pgcBin.ActivePage);
  if m_pgcBin.PageCount < 1 then Exit;
  if tab.m_BinPanel.GetFiltParms.P_MaterialSchedFilter then
  begin
    BinMatGrid := tab.GetMatGrid;
    if Assigned(tab) and (goRowSelect in (BinMatGrid).Options) then
      exit;

    if TBinPanel(BinMatGrid.Parent).m_ObjList.GetLinkCount <= 0 then exit;
    I := BinMatGrid.BinMatColumnSet[BinMatGrid.p_GetCol - BinMatGrid.FixedCols - BinMatGrid.p_GetFixedColumns].RealPos;
    if I >= 0 then
    begin
      Title := TBinDrawGridMat(BinMatGrid).BinMatColumnSet[I].Title;
      Desc := p_sc.GetFldDescr(TSchedID(TBinPanel(BinMatGrid.Parent).m_ObjList.GetLink(BinMatGrid.p_GetRow - 1)), BinMatGrid.BinMatColumnSet[I].Field, false);
      CreateSearchColumnFocuse(Self, Desc, Title,BinMatGrid.BinMatColumnSet[I].Field);
    end;

  end

  else
  begin
    MICreateBinUsingCurentCell.Visible := true;
    BinGrid := tab.GetBinGrid;
    if Assigned(tab) and (goRowSelect in (BinGrid).Options) then
      exit;

    if TBinPanel(binGrid.Parent).m_ObjList.GetLinkCount <= 0 then exit;
    I := binGrid.BinColumnSet[binGrid.p_GetCol - binGrid.FixedCols - binGrid.p_GetFixedColumns].RealPos;
    if (I >= 0) and (I <= 1000) then
    begin
      SetFilterParams(binGrid.BinColumnSet[I].Field, '', dataType, true, I ,nil, Title, binGrid);
      Desc := p_sc.GetFldDescr(TSchedID(TBinPanel(binGrid.Parent).m_ObjList.GetLink(binGrid.p_GetRow - 1)), binGrid.BinColumnSet[I].Field, false);
      CreateSearchColumnFocuse(Self, Desc, Title,binGrid.BinColumnSet[I].Field);
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFBin.TBPosReqOnBinClick(Sender: TObject);
begin
  CreateSearchAndFocus(self);
end;

//----------------------------------------------------------------------------//

function TFBin.CheckSchedSumQtyToAll : boolean;
var
  tbs : TBinTabSheet;
  I : Integer;
  id : TSchedId;
begin
  Result := false;
  tbs := TBinTabSheet(m_pgcBin.GetActiveView);
  if not Assigned(tbs) then exit;

  for i := 0 to tbs.m_BinPanel.m_objList.GetLinkCount -1 do
  begin
    id := tbs.m_BinPanel.m_objList.GetLink(i);
    if id = CSchedIdNull then break;
    if ((p_sc.GetSchedObjStatus(id) = CSS_From_PG) or (p_sc.CheckSchedSumQty(id))) then
    begin
      result := true;
      exit
    end;
  end;
end;

//----------------------------------------------------------------------------//

function TFBin.CanUnGroup(Id : TSchedId) : boolean;
var
  extPtr: pointer;
  FieldVal : variant;
  dataType: CBinColValType;
begin
  Result := false;
  extPtr := p_sc.GetExtLinkPtr(Id);
  p_sc.GetFldValue(Id, CSC_Closed, FieldVal, dataType);
  if not Assigned(extPtr) and not FieldVal then
    Result := true
end;

//----------------------------------------------------------------------------//

function TFBin.CanUnGroupGroups : boolean;
var
  tab : TBinTabSheet;
  I : Integer;
  isGrp : boolean;
  extPtr: pointer;
  FieldVal : variant;
  id,GrpId : TSchedId;
  IsBelong : boolean;
  dataType: CBinColValType;
begin
  Result := false;
  tab := GetActiveView;
  if Assigned(tab) and Assigned(tab.m_BinPanel) then
  begin
    for I := 0 to tab.m_BinPanel.m_objList.GetLinkCount-1 do
    begin
      p_sc.GetObjInfo(tab.m_BinPanel.m_objList.GetLink(i), isGrp);
      if isGrp then
      begin
        p_sc.GetFldValue(tab.m_BinPanel.m_objList.GetLink(i), CSC_Closed, FieldVal, dataType);
        extPtr := p_sc.GetExtLinkPtr(tab.m_BinPanel.m_objList.GetLink(i));
        if not Assigned(extPtr) and not FieldVal then
        begin
          Result := true;
          Exit
        end;
      end
      else
      begin
        id := tab.m_BinPanel.m_objList.GetLink(i);
        IsBelong := false;
        GrpId := p_sc.LinesBelongToGroup(id, IsBelong);
        if IsBelong then
        begin
          p_sc.GetFldValue(GrpId, CSC_Closed, FieldVal, dataType);
          extPtr := p_sc.GetExtLinkPtr(GrpId);
          if not Assigned(extPtr) and not FieldVal then
          begin
            Result := true;
            Exit
          end;
        end

      end;

    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFBin.ActivateRefreshButton;
begin
  TBRefresh.Tag        := 1;
  TBRefresh.Enabled := true;
  RefreshBin.Enabled := true;
  TBRefresh.ShowHint   := true;
end;

//----------------------------------------------------------------------------//

procedure TFBin.DeActivateRefreshButton;
begin
  TBRefresh.ImageIndex := 28;
  TBRefresh.Tag        := 0;
//  TBRefresh.Enabled := false;
  RefreshBin.Enabled := false;
end;

//----------------------------------------------------------------------------//

procedure TFBin.ActivateJobMsgButton;
begin
  TBJobMsg.Tag        := 1;
  TBJobMsg.Enabled := true;
  TimerJobMsg.Enabled := true;
  TBJobMsg.ShowHint   := true;
end;

//----------------------------------------------------------------------------//

procedure TFBin.DeActivateJobMsgButton;
begin
  TBJobMsg.ImageIndex := 47;
  TBJobMsg.Tag        := 0;
  TimerJobMsg.Enabled := false;
//  TBJobMsg.Enabled := false;
end;

//----------------------------------------------------------------------------//

procedure MarkReqAsHandled(List : TList);
var
  I : Integer;
begin
  for I := 0 to List.Count - 1 do
    PTSeqInfo(list[I]).ToHandle := false;
end;

//----------------------------------------------------------------------------//

{function SearchReqStep(Req : string ;Step : Integer; List : TList) : boolean;
var
  I : Integer;
  SeqInfo : PTSeqInfo;
begin
  Result := true;
  for I := 0 to List.Count - 1 do
  begin

    if (PTSeqInfo(List[I]).Request = Req) and (PTSeqInfo(List[I]).Step = Step) then
    begin
      if not PTSeqInfo(List[I]).ToHandle then
        Result := false;
      Exit;
    end;

    if (PTSeqInfo(List[I]).Request = Req) and PTSeqInfo(List[I]).ToHandle then
    begin
      if PTSeqInfo(List[I]).Step <> Step then
        Result := false;
      Exit;
    end;

  end;

  new(SeqInfo);
  SeqInfo.Request := Req;
  SeqInfo.Step    := Step;
  SeqInfo.ToHandle := true;
  List.add(SeqInfo);
end; }

//----------------------------------------------------------------------------//

function TFBin.PrepareAutoSeqList(MainIdList: TMSchedList) : boolean;
var
  ObjList : TMSchedList;
//  tbs : TBinTabSheet;
  i: integer;
  ID,IdGrp,IDSelected,PrevId : TSchedId;
  linkInfo: TSQlinkInfo;
  Isbelong : boolean;
  planInfo : TSQplanInfo;
  TmpListString : TStringList;
  TempCfg : PTAutoSchedCfg;
  FieldVal : variant;
  dataType: CBinColValType;
  BinGrid : TBinDrawGrid;
begin
  Result := true;
  PrevId := CSchedIDnull;
  IDSelected := CSchedIDnull;

  AutoSchedCfg.m_IdForStopOnFirstNotSchedJob := CSchedIDnull;

//  tbs := TBinTabSheet(m_pgcBin.GetActiveView);

//  if not Assigned(tbs) then exit;

  DBAppGlobals.MAINPLAN_Ignore_Save_Event := true;
  ObjList := TMSchedList.Create(self);

  for i := 0 to MainIdList.GetLinkCount - 1 do
  begin
    Id := MainIdList.GetLink(i);

    p_sc.GetPlanInfo(Id, PlanInfo);

    if not DBAppGlobals.Mcm_App_Resched_From_Mqm then
      if (PlanInfo.VisibleInBin = CSB_ReadOnly) then continue;

    if not (AutoSchedCfg.m_OverridingParams_Activated and AutoSchedCfg.m_OverridingParams_UnscheduleBefore) then
      if Assigned(p_sc.GetExtLinkPtr(Id)) then continue;

    p_sc.GetFldValue(id, CSC_Closed, FieldVal, dataType);
    if FieldVal then continue;

    if p_sc.GetLinkInfo(id, linkInfo) = false then continue;

    if not linkInfo.isGroup then
    begin
      IdGrp := p_sc.LinesBelongToGroup(id, Isbelong);
      if IsBelong then
      begin
        Id := IdGrp;
        if ObjList.IsIn(Id) then continue;
      end;
    end;
    ObjList.AddLink(Id);

    if (PreviD <> CSchedIDnull) then
    begin
      p_sc.SetAutoSeqPrevNextIds(Id, PrevId, true);
      p_sc.SetAutoSeqPrevNextIds(PrevId, Id, false);
    end
    else
      p_sc.SetAutoSeqPrevNextIds(Id, CSchedIDnull, true);

    PrevId := Id;
    p_sc.SetAutoSeqHandled(Id, true);
  end;

  if (PreviD <> CSchedIDnull) then
    p_sc.SetAutoSeqPrevNextIds(PrevId, CSchedIDnull, false);

  p_sc.ResetAutoSeqMaxBefore;
  AutoSchedCfg.m_LastCheckedRequest := '';
  AutoSchedCfg.m_LastCheckedStep    := -1;
  AutoSchedCfg.m_LastCheckedQty     := 0;
  AutoSchedCfg.m_LastCheckedID      := CSchedIDnull;
  AutoSchedCfg.m_LastSchedID        := CSchedIDnull;
  AutoSchedCfg.m_LastSchedRes       := nil;

  if AutoSchedCfg.m_WithoutStack then
    AutoSchedule(ObjList)
  else
    AutoScheduleMain(ObjList);

  Application.ProcessMessages;
  if AutoSchedCfg.m_StopOnFirstNotSchedJob and (AutoSchedCfg.m_IdForStopOnFirstNotSchedJob <> CSchedIDnull) then
     FocusBinOnJobID(AutoSchedCfg.m_IdForStopOnFirstNotSchedJob, false);
  Application.ProcessMessages;
  ObjList.Free;
  MainIdList.free;
  DBAppGlobals.MAINPLAN_Ignore_Save_Event := false;
end;

//----------------------------------------------------------------------------//

function TFBin.CheckSplitBeforeSchedule(ObjList: TMSchedList; ForceSplit : boolean; NewIdsList : TMSchedList; checkOnly : boolean) : boolean;
var
  SplitInfo: TSQSplitInfo;
  FieldVal, value : variant;
  dataType: CBinColValType;
  SplitQty, QtyPerJob,
  OrigJobQty, EachJobQty, GroupQty: currency;
  SplitNo, NewJobNr: integer;
  Err: string;
  UserWantToSplit: boolean;
  i,j,D, G: integer;
  id, ChildId : TSchedId;
  ValId : variant;
  ProdReq : string;
  ProdStep : Integer;
  NewId,SonId : TSchedID;
  FoundSonId  : boolean;
  List, ListFamily : TList;
  SplitFamilyCode : Integer;
  IniVal, FinVal: variant;
  planInfo : TSQplanInfo;
  ActiveUndo, ChecksplitGroup : boolean;
  NumOfres, DecMult : Integer;
begin
  ActiveUndo := false;
  Result := false;
  UserWantToSplit := false;

  if IsAutoRunMode or ForceSplit then
     UserWantToSplit := true;

  for i := 0 to ObjList.GetLinkCount - 1 do    //look for jobs to split
  begin
    id := TSchedID(ObjList.GetLink(i));
    if id = CSchedIDnull then continue;

    p_sc.GetPlanInfo(Id, PlanInfo);
    if (p_sc.IsProgressed(id) <> prg_none) then continue;
    if (PlanInfo.VisibleInBin = CSB_ReadOnly) then continue;

    if PlanInfo.isGroup then
    begin
      ChecksplitGroup := true;
      if checkOnly then
      begin
        for G := 0 to p_sc.GetGrpNumSons(Id) - 1 do
        begin
          ChildId := p_sc.GetGrpSon(Id, G);
          if not (p_sc.GetFldValue(ChildId, CSC_NumOfRscPlan, FieldVal, dataType)
          and (p_sc.IsProgressed(ChildId) = prg_none)
          and (FieldVal >= 2)
          and (p_sc.GetJobNumBrothers(ChildId) = 1)
          and not Assigned(p_sc.GetExtLinkPtr(ChildId))) then
          begin
            ChecksplitGroup := false;
            break
          end;
        end
      end;

      if checkOnly and ChecksplitGroup then
      begin
        Result := true;
        Exit;
      end;

      for G := 0 to p_sc.GetGrpNumSons(Id) - 1 do
      begin
        ChildId := p_sc.GetGrpSon(Id, G);
        if not (p_sc.GetFldValue(ChildId, CSC_NumOfRscPlan, FieldVal, dataType)
        and (p_sc.IsProgressed(ChildId) = prg_none)
        and (FieldVal >= 2)
        and (p_sc.GetJobNumBrothers(ChildId) = 1)
        and not Assigned(p_sc.GetExtLinkPtr(ChildId))) then
        begin
          ChecksplitGroup := false;
          break
        end;
      end;
      if not ChecksplitGroup then continue;

      NumOfres := FieldVal;
      p_sc.GetFldValue(Id, CSC_QtyToSched, value, dataType);
      GroupQty := value;
      // per-resource portion, floored to the job's own decimal precision (was hardcoded to 2
      // decimals). The remainder stays on the last (original) group; SplitGroup now carves each
      // peeled group exactly to this quantity.
      DecMult := 1;
      for D := 1 to p_sc.GetJobNumOfDecimals(Id) do DecMult := DecMult * 10;
      groupQty := trunc(groupQty / NumOfres * DecMult) / DecMult;
      for G := 0 to NumOfres - 2 do
        SplitGroup(id, groupQty, true);

    end
    else
    begin

      if p_sc.GetFldValue(id, CSC_NumOfRscPlan, FieldVal, dataType)
      and (FieldVal >= 2)
      and (p_sc.GetJobNumBrothers(id) = 1)
      and not Assigned(p_sc.GetExtLinkPtr(id)) then
      begin
        if not UserWantToSplit then
          if MessageDlg(_('There are steps in the bin that are planned to be produced on more then one resource,') + #13#10 +
                        _('do you want to split these steps before proceeding?'), mtConfirmation, [mbYes, mbNo], 0) = idYes then
          begin
            ActiveUndo := true;
            UserWantToSplit := true
          end
          else
            break;

        p_sc.GetFldValue(id, CSC_IniQty, IniVal, dataType);
        p_sc.GetFldValue(id, CSC_FinQty, FinVal, dataType);
        if (IniVal = 0) or (FinVal = 0) then
           continue;

        p_sc.GetSplitInfo(id, SplitInfo);
        SplitQty := SplitInfo.quant;
        SplitNo  := FieldVal;
        if SplitNo = 1 then continue;
        QtyPerJob := 0;

        if checkOnly then
        begin
          Result := true;
          Exit;
        end;

       // p_opStack.MarkStackForButtonUndo(_('split before proceeding'));
        if ActiveUndo then
        begin
          p_opStack.MarkStackForButtonUndo(_('split before proceeding'));
          FMQMPlan.ActiveUndo;
          ActiveUndo := false
        end;

        if not CalcSplitQty(id, 0, 0, SplitQty, SplitNo, QtyPerJob, OrigJobQty, EachJobQty, NewJobNr, Err) then
        begin
          if IsAutoRunMode then continue;
          p_sc.GetFldValue(id, CSC_ProdReq, ValId, dataType);
          ProdReq := ValId;
          p_sc.GetFldValue(id, CSC_ProdStep, ValId, dataType);
          ProdStep := ValId;
          showmessage(_('Errors splitting the job') + ' : ' + _('Request : ') + ProdReq + ', ' + _('Step') + ' : ' + IntTostr(ProdStep));
          exit;
        end;
        p_opStack.SplitJob(Id, OrigJobQty, EachJobQty, NewJobNr, NewId, List);

        for D := 0 to List.Count - 1 do
          NewIdsList.AddLink(TSchedId(List[D]));

        if SplitInfo.SplitAllow = CSB_father then
        begin
          SearchFamilyRelative(Id, FoundSonId, SonId);
          if FoundSonId then
          begin
            p_sc.GetSplitInfo(SonId, SplitInfo);
            SplitQty := SplitInfo.quant;
            SplitNo  := FieldVal;
            QtyPerJob := 0;
            if not CalcSplitQty(SonId, 0, 0, SplitQty, SplitNo, QtyPerJob, OrigJobQty, EachJobQty, NewJobNr, Err) then
            begin
              p_sc.GetFldValue(SonId, CSC_ProdReq, ValId, dataType);
              ProdReq := ValId;
              p_sc.GetFldValue(SonId, CSC_ProdStep, ValId, dataType);
              ProdStep := ValId;
              showmessage(_('Errors splitting the job') + ' : ' + _('Request : ') + ProdReq + ', ' + _('Step') + ' : ' + IntTostr(ProdStep));
              exit;
            end;
            ListFamily := p_sc.SplitJob(SonId, OrigJobQty, EachJobQty, NewJobNr, NewId);

            if (List.Count > 0) and (List.Count = ListFamily.Count) then
            begin
              for J := 0 to ListFamily.Count - 1 do
              begin
                SP_GET_SPLIT_FAMILY_CODE(SplitFamilyCode, 'SPLITFAMILY');
                if (SplitFamilyCode = 999999999) then
                   SP_Reset_SPLIT_FAMILY_CODE_Generator;
                p_sc.SetSplitFamilyCode(TSchedId(ListFamily[J]), '1' + FloatToStr(SplitFamilyCode));
                p_sc.SetSplitFamilyCode(TSchedId(List[J]), '1' + FloatToStr(SplitFamilyCode));
              end;
            end;

          end;

        end;

        Result := true;

      end;

    end;

  end;

//  Result := UserWantToSplit;

end;

//----------------------------------------------------------------------------//

function TFBin.GetResListForActiveTab(CheckExist : boolean; var ResListObj : TList; var TabName : string) : boolean;
var
  tbs : TBinTabSheet;
  I, J : Integer;
  id : TSchedId;
  PlanInfo : TSQplanInfo;
  FieldVal : variant;
  dataType: CBinColValType;
  ResList : TStringList;
  Cfg     : TBinTabCfg;
begin
  Result := false;
  ResList := nil;
  ResListObj := nil;
  tbs := TBinTabSheet(m_pgcBin.GetActiveView);
  if not Assigned(tbs) then exit;
  for i := 0 to tbs.m_BinPanel.m_objList.GetLinkCount -1 do
  begin
    id := tbs.m_BinPanel.m_objList.GetLink(i);
    if id = CSchedIdNull then break;
    p_sc.GetPlanInfo(id, planInfo);
    if planInfo.isOnPlan then
    begin
      Result := true;
      if CheckExist then
        Exit;
      p_sc.GetFldValue(Id, CSC_Rsc, FieldVal, dataType);
      if not assigned(ResList) then
      begin
        ResList := TStringList.Create;
        ResListObj := TList.Create;
      end;
      if ResList.IndexOf(FieldVal) = -1 then
        ResList.Add(FieldVal);
    end;
  end;

  if result then
  begin
    for J := 0 to ResList.Count - 1 do
      ResListObj.Add(TMqmRes(p_pl.FindResByCode(ResList.Strings[J])));
    Cfg := TBinTabCfg(m_tbCfg.FindTab(tbs.GetCode));
    TabName := Cfg.name;
  end;

end;

//----------------------------------------------------------------------------//

procedure TFBin.MIJoinAllClick(Sender: TObject);
var
  tbs : TBinTabSheet;
  I, J, S   : Integer;
  ObjList : TMSchedList;
  Request, OldRequest : string;
  Step, OldStep : Integer;
  PlanInfo : TSQplanInfo;
  List     : TList;
  First, FirstGrp, m_grpId, m_grpOld , m_grpTmp, SonId, SonId1, SonId2 : TSchedId;
  SplitInfo: TSQSplitInfo;
  FoundNewReqUniqId : boolean;
begin
  List := nil;
  First := CSchedIdNull;
  if not IsAutoRunMode then
  begin
    if MessageDlg(_('All jobs in BIN will be joined !!! are you sure ?' ), mtConfirmation, [mbYes, mbNo], 0) = idNo then
    begin
      Exit;
    end;
  end;
  p_opStack.MarkStackForButtonUndo(_('Join Jobs'));
  tbs := TBinTabSheet(m_pgcBin.GetActiveView);
  ObjList := TMSchedList.Create(self);
  for I := 0 to tbs.m_BinPanel.m_objList.GetLinkCount - 1 do
  begin
    p_sc.GetPlanInfo(tbs.m_BinPanel.m_objList.GetLink(I), PlanInfo);
    if PlanInfo.isOnPlan then continue;
    if PlanInfo.isGroup then continue;
    p_sc.GetSplitInfo(tbs.m_BinPanel.m_objList.GetLink(I), SplitInfo);
    if SplitInfo.NewReqUniqId <> '' then continue;
    ObjList.AddLink(tbs.m_BinPanel.m_objList.GetLink(I));
  end;
  ObjList.SortList(SortByReqStepSubStep);

  if ObjList.GetLinkCount > 0 then
     List := TList.Create;

  OldRequest := '';
  OldStep    := -1;
  for I := 0 to ObjList.GetLinkCount - 1 do
  begin
    Request := p_sc.GetFldDescr(ObjList.GetLink(I), CSC_ProdReq, false);
    Step    := StrToInt(p_sc.GetFldDescr(ObjList.GetLink(I), CSC_ProdStep, false));
    if (Request <> OldRequest) or (Step <> OldStep) then
    begin
      OldRequest := Request;
      OldStep    := Step;
      First := ObjList.GetLink(I);
    end
    else
    begin
      List.Add(Pointer(ObjList.GetLink(I)));
      if ((I + 1) <= (ObjList.GetLinkCount - 1)) then
      begin
        if (p_sc.GetFldDescr(ObjList.GetLink(I + 1), CSC_ProdReq, false) <> OldRequest) or
             (StrToInt(p_sc.GetFldDescr(ObjList.GetLink(I + 1), CSC_ProdStep, false)) <> OldStep) then
        begin
          if (Request = OldRequest) and (Step = OldStep) then
          begin
            //p_sc.JoinJobs(First, List);
            p_opStack.JoinJobs(First, List);
            List.clear;
          end
          else if (List.Count = 1) then
             List.clear;
        end;
      end
      else if (I = (ObjList.GetLinkCount - 1)) then
      begin
          if (OldRequest = Request) and (Step = OldStep) then
          begin
            //p_sc.JoinJobs(First, List);
            p_opStack.JoinJobs(First, List);
            List.clear;
          end
          else if (List.Count = 1) then
             List.clear;
      end

    end;

  end;

  if Assigned(tbs) then
    tbs.m_BinPanel.UpdateForChangeFilter;  // Refresh Bin

  if Assigned(List) then
  begin
    List.clear;
    List.free;
  end;
  if Assigned(ObjList) then
  begin
    ObjList.ClearList;
    ObjList.Free;
  end;

  // group handling

  List := nil;
  First := CSchedIdNull;
 // p_opStack.MarkStackForButtonUndo(_('Join Jobs'));
  tbs := TBinTabSheet(m_pgcBin.GetActiveView);
  ObjList := TMSchedList.Create(self);
  for I := 0 to tbs.m_BinPanel.m_objList.GetLinkCount - 1 do
  begin
    p_sc.GetPlanInfo(tbs.m_BinPanel.m_objList.GetLink(I), PlanInfo);
    if PlanInfo.isOnPlan then continue;
    if not PlanInfo.isGroup then continue;
    FoundNewReqUniqId := false;
    m_grpId := tbs.m_BinPanel.m_objList.GetLink(I);
    for J := 0 to p_sc.GetGrpNumSons(m_grpId) - 1 do
    begin
      SonId := p_sc.GetGrpSon(m_grpId, J);
      p_sc.GetSplitInfo(SonId, SplitInfo);
      if SplitInfo.NewReqUniqId <> '' then
      begin
        FoundNewReqUniqId := true;
        break
      end;
    end;
    if FoundNewReqUniqId then continue;
    ObjList.AddLink(m_grpId);
  end;

  if ObjList.GetLinkCount > 0 then
     List := TList.Create;

  OldRequest := '';
  OldStep    := -1;
  m_grpOld   := CSchedIdNull;
  for I := 0 to ObjList.GetLinkCount - 1 do
  begin
    m_grpId := ObjList.GetLink(I);
    if not p_sc.CompaireGroupsRequestStep(m_grpId, m_grpOld) then
    begin
      m_grpOld := m_grpId;
      FirstGrp := ObjList.GetLink(I);
    end
    else
    begin
      m_grpTmp := ObjList.GetLink(I);
      if ((I + 1) <= (ObjList.GetLinkCount - 1)) then
      begin
        if p_sc.CompaireGroupsRequestStep(m_grpTmp , m_grpOld) then
        begin
          for S := 0 to p_sc.GetGrpNumSons(FirstGrp) - 1 do
          begin
            SonId1 := p_sc.GetGrpSon(FirstGrp ,s);
            SonId2 := p_sc.GetGrpSon(m_grpTmp ,s);
            List.clear;
            List.Add(Pointer(SonId2));
            p_opStack.JoinJobs(SonId1, List);
          end;
          p_sc.DeleteGroup(m_grpTmp);
        end
        else if (List.Count = 1) then
           List.clear;

      end else if (I = (ObjList.GetLinkCount - 1)) then
      begin
        m_grpTmp := ObjList.GetLink(I);
        if p_sc.CompaireGroupsRequestStep(FirstGrp, m_grpTmp) then
        begin
          for S := 0 to p_sc.GetGrpNumSons(FirstGrp) - 1 do
          begin
            SonId1 := p_sc.GetGrpSon(FirstGrp ,s);
            SonId2 := p_sc.GetGrpSon(m_grpTmp ,s);
            List.clear;
            List.Add(Pointer(SonId2));
            p_opStack.JoinJobs(SonId1, List);
          end;
          p_sc.DeleteGroup(m_grpTmp);
        end
        else if (List.Count = 1) then
             List.clear;
      end;

    end;

  end;

  if Assigned(tbs) then
    tbs.m_BinPanel.UpdateForChangeFilter;  // Refresh Bin

  if Assigned(List) then
  begin
    List.clear;
    List.free;
  end;
  if Assigned(ObjList) then
  begin
    ObjList.ClearList;
    ObjList.Free;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFBin.MiLatestendingdateClick(Sender: TObject);
begin

end;

//----------------------------------------------------------------------------//

procedure TFBin.MiMatCopyClick(Sender: TObject);
var
  I : Integer;
  BinGrid : TBinDrawGridMat;
  Str : string;
  tab : TBinTabSheet;
begin
  tab := TBinTabSheet(m_pgcBin.ActivePage);
  BinGrid := tab.GetMatGrid;
  if assigned(BinGrid) then
  begin
    I := binGrid.BinMatColumnSet[binGrid.p_GetCol - binGrid.FixedCols - binGrid.p_GetFixedColumns].RealPos;
    if I >= 0 then
    begin
      Str := p_sc.GetFldDescr(TSchedID(TBinPanel(binGrid.Parent).m_ObjList.GetLink(binGrid.p_GetRow - 1)), binGrid.BinMatColumnSet[I].Field, false);
      Clipboard.AsText := Str;
    end
  end;
end;

//----------------------------------------------------------------------------//

procedure TFBin.MiMatUnscheduleClick(Sender: TObject);
var
  actArea : TMqmActArea;
  opStack : TOpStack;
  BinGrid : TBinDrawGridMat;
  tab     : TBinTabSheet;
  id      : TSchedID;
  MqmWarpObj : TMqmWarp;
  SchedList  : TMSchedList;
  WarpsCount, I : Integer;
  W : Word;
  TmpLstActArea : TList;
begin
  tab := TBinTabSheet(m_pgcBin.ActivePage);
  BinGrid := tab.GetMatGrid;
  if not assigned(BinGrid) then exit;
  SchedList := BinGrid.GetSelectedList;
  if SchedList.GetLinkCount = 0 then
  begin
    ID := TSchedID(TBinPanel(binGrid.Parent).m_ObjList.GetLink(binGrid.p_GetRow - 1));
    if ID = CSchedIDnull then exit;
    SchedList.AddLink(ID)
  end;

//  if SchedList.GetLinkCount = 0 then
//  begin
//    MessageDlg(_('There is no scheduled warp!'), mtInformation, [mbYes], 0);
//    exit;
//  end;

  if SchedList.GetLinkCount > 1 then
    w := MessageDlg(_('Unschedule all warps in current bin ?'), mtConfirmation, [mbYes, mbNo, mbCancel], 0)
  else
    w := MessageDlg(_('Unschedule current warp in the bin ?'), mtConfirmation, [mbYes, mbNo, mbCancel], 0);

  if w = mrYes then
  begin
    opStack := TOpStack.CreateStack;
    p_opStack.MarkStackForButtonUndo(_('Unschedule all warp in current bin'));
    TmpLstActArea := TList.Create;
    WarpsCount := SchedList.GetLinkCount;

    for i := (WarpsCount - 1) downto 0 do
    begin
      actArea := nil;
      id := SchedList.GetLink(I);
      if id = CSchedIdNull then break;
      if Assigned(p_sc.GetExtLinkPtr_Material(id)) then
      begin
        actArea := TMqmActArea(p_sc.GetExtLinkPtr_Material(id));
        if actArea = nil then Continue;
        if TMqmWrkCtr((actArea).p_WrkCtr).p_ReadOnly then continue;
        MqmWarpObj := TMqmWarp(ActArea.GetWarpFromId(id));
        if not assigned(MqmWarpObj) then
            Continue;
      end;
      if actArea = nil then Continue;
      p_opStack.DetachPlanObjFromApa(TMqmWarp(MqmWarpObj));
      TMqmWarp(MqmWarpObj).m_status := CDUR_del;
      p_pl.AddObjToDele(TMqmWarp(MqmWarpObj));
      if TmpLstActArea.IndexOf(actArea) = -1 then
        TmpLstActArea.Add(actArea);
    end;

    for i := 0 to TmpLstActArea.Count -1 do
    begin
      ActArea := TMqmActArea(TmpLstActArea[i]);
      actArea.ReorganizeAllOcc(true);
    end;
    FMQMPlan.RefreshActiveTab;
    FBin.ChangeTabBinforChangeTabPlan;
    FMQMPlan.ActiveUndo;
    opStack.Free;
    TmpLstActArea.Free
  end;

end;

//----------------------------------------------------------------------------//

procedure TFBin.MiModifySpeedSetupWarpClick(Sender: TObject);
var
  SpeedMachine : TSpeedMachine;
  MqmActArea : TMqmActArea;
  BinGrid : TBinDrawGridMat;
  Warp : TMqmWarp;
  tab     : TBinTabSheet;
  id      : TSchedID;
begin
  tab := TBinTabSheet(m_pgcBin.ActivePage);
  BinGrid := tab.GetMatGrid;
  if not assigned(BinGrid) then exit;
  ID := TSchedID(TBinPanel(binGrid.Parent).m_ObjList.GetLink(binGrid.p_GetRow - 1));
  if ID = CSchedIDnull then exit;
  MqmActArea := p_sc.GetExtLinkPtr_Material(ID);
  if not assigned(MqmActArea) then
    Warp := nil
  else
    Warp := TMqmWarp(MqmActArea.GetWarpFromId(id));
  SpeedMachine := TSpeedMachine.CreateSpeedWarpMachine(self , Warp, ID);
  if SpeedMachine.ShowModal = mrok then
  begin
    if assigned(MqmActArea) then
    begin
      MqmActArea.ReorganizeAllOcc(true);
      FMQMPlan.RefreshActiveTab;
      if assigned(FBin) then
        FBin.ChangeTabBinforChangeTabPlan
    end;
  end;
  SpeedMachine.free
end;

//----------------------------------------------------------------------------//

procedure TFBin.MiBalanceStepClick(Sender: TObject);
var
  id: TSchedId;
  tbs : TBinTabSheet;
  ListID : TMSchedList;
begin
  ListID := TMSchedList.Create(self);
  Id := GetMouseSchedObj(false);
  p_sc.BalanceQuantity(Id, false);
  if Assigned(p_sc.GetExtLinkPtr(id)) then p_pl.RecalcTimings(id);
  ListId.AddLink(Id);
  p_sc.UpdateBalancedQtyOnPlan(ListId);
  FMQMPlan.RefreshActiveTab;

  tbs  := FBin.GetActiveView;
  if Assigned(tbs) then
    tbs.m_BinPanel.UpdateForChangeFilter;  // Refresh Bin
  RefreshGrid;
  ListID.free
end;

//----------------------------------------------------------------------------//

procedure TFBin.MiBalanceImbalanceInBinClick(Sender: TObject);
var
  tbs : TBinTabSheet;
  I : integer;
  Save_Cursor : TCursor;
begin
  tbs := TBinTabSheet(m_pgcBin.GetActiveView);
  if not Assigned(tbs) then exit;
  Save_Cursor := Screen.Cursor;
  Screen.Cursor  := crAppStart;
  p_sc.UpdateBalanceQuantity(false, tbs.m_BinPanel.m_objList);
//  RefreshGrid;
  FMQMPlan.RefreshActiveTab;
  tbs  := FBin.GetActiveView;
  if Assigned(tbs) then
    tbs.m_BinPanel.UpdateForChangeFilter;  // Refresh Bin
  RefreshGrid;
  Screen.Cursor := Save_Cursor;
end;

//----------------------------------------------------------------------------//

procedure TFBin.RemoveAutomaticllyJobsFromGroup(GroupId : TSchedId);
var
  JobId :   TSchedId;
  I : Integer;
begin
  for I := p_sc.GetGrpNumSons(GroupId) - 1 downto 0 do
  begin
    JobId := p_sc.GetGrpSon(GroupId, I);
    if p_sc.GetGrpNumSons(GroupId) = 1 then
    begin
      if p_sc.GetSchedObjStatus(JobId) <> CSS_New then
         p_sc.SetSchedObjStatus(JobId, CSS_modi);
      p_sc.RemoveJobFromGroup(JobId, 'Removed automatically from group');
      p_sc.DeleteGroup(GroupId);
     // FBin.ChangeTabBinforChangeTabPlan;
    end
    else
    begin
      if p_sc.GetSchedObjStatus(JobId) <> CSS_New then
         p_sc.SetSchedObjStatus(JobId, CSS_modi);
       p_sc.RemoveJobFromGroup(JobId, 'Removed automatically from group');
    end
  end;

end;

//----------------------------------------------------------------------------//

procedure TFBin.MIAutoUnGroupingSelectionClick(Sender: TObject);
var
  tab : TBinTabSheet;
  BinGrid : TBinDrawGrid;
  I : Integer;
  isGrp : boolean;
  extPtr : pointer;
  FieldVal : variant;
  dataType: CBinColValType;
  IsBelong : boolean;
  Id,GrpId    : TSchedId;
  SchedList : TMSchedList;
  JobsInBinCount : integer;
begin
  Id := GetMouseSchedObj(false);
  if (id = CSchedIdNull) then exit;

  tab := TBinTabSheet(m_pgcBin.GetActiveView);
  BinGrid := tab.GetBinGrid;

  if not BinGrid.pSelectedMarked then
  begin
    if not IsGroupFormOut then
    begin
      GrpId := GetMouseSchedObj(false);
      p_sc.GetObjInfo(GrpId, isGrp);
      if isGrp then
      begin
        RemoveAutomaticllyJobsFromGroup(GrpId);
        FBin.ChangeTabBinforChangeTabPlan;
      end;
    end;
    exit;
  end;

  SchedList := BinGrid.GetSelectedList;
  JobsInBinCount := SchedList.GetLinkCount;

  if Assigned(tab) then
  begin

    for I := 0 to JobsInBinCount - 1 do
    begin
      id := SchedList.GetLink(I);
      if id = CSchedIdNull then break;

      p_sc.GetObjInfo(id, isGrp);
      if isGrp then
      begin
        p_sc.GetFldValue(id, CSC_Closed, FieldVal, dataType);
        extPtr := p_sc.GetExtLinkPtr(id);
        if not Assigned(extPtr) and not FieldVal then
          RemoveAutomaticllyJobsFromGroup(id);
      end
      else
      begin
        IsBelong := false;
        GrpId := p_sc.LinesBelongToGroup(id, IsBelong);
        if IsBelong then
        begin
          p_sc.GetFldValue(GrpId, CSC_Closed, FieldVal, dataType);
          extPtr := p_sc.GetExtLinkPtr(GrpId);
          if not Assigned(extPtr) and not FieldVal then
          begin
            RemoveAutomaticllyJobsFromGroup(GrpId)
          end;
        end;
      end
    end;

    if SchedList.GetLinkCount > 0 then
    begin
      for I := 0 to BinGrid.RowCount - 1 do
         BinGrid.ForceUnselected(I);
    end;
    FBin.ChangeTabBinforChangeTabPlan;

  end;
end;

//----------------------------------------------------------------------------//

{procedure TFBin.SetOverlappForJobList(ObjList: TMSchedList; Wait : TForm);
var
  I, J : integer;
  ActiveTbs : TMqmPlanTabSheet;
  VisRes    : TMqmVisibleRes;
  CompVal   : TCompatVal;
  Save_Cursor : TCursor;
  WaitTime : TFWait;
begin
  WaitTime := TFWait(Wait);
  Save_Cursor   := Screen.Cursor;
  Screen.Cursor  := crAppStart; //SQLWait;
  ActiveTbs := FMQMPlan.GetActiveTab;

  if Assigned(WaitTime.m_ProgBar) then
    WaitTime.m_ProgBar.SetMax(ObjList.GetLinkCount);

  for J := 0 to ObjList.GetLinkCount - 1 do
  begin
    Application.ProcessMessages;

    if Assigned(WaitTime.m_ProgBar) then
      WaitTime.m_ProgBar.SelEnd := J;

    for i := 0 to ActiveTbs.p_ganttPanel.p_VisResList.Count-1 do
    begin
      Application.ProcessMessages;
      p_pl.EnterCompatModeInPlan(ObjList.GetLink(J));
      VisRes := TMqmVisibleRes(ActiveTbs.p_ganttPanel.p_VisResList[i]);
      if VisRes.CheckCompatWithOcc([cho_compVal, cho_timing, cho_wkc, cho_readOnly, cho_qty, cho_Depend],
                                      ObjList.GetLink(J) , 0, nil, CompVal)
      and (CompVal <= AutoSchedCfg.m_MinJobResComp) then
      begin
        p_pl.SetOvplTargetRes(VisRes, OvlpChk_OptimumLimits, -1);
        break;
      end;
    end;
  end;

  if Assigned(WaitTime.m_ProgBar) then
    WaitTime.m_ProgBar.SelEnd := 0;

  p_pl.ExitCompatModeInPlan;
  Screen.Cursor := Save_Cursor;
end;                             }

//----------------------------------------------------------------------------//

end.






