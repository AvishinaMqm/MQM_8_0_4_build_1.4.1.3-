unit FMMainPlan;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ComCtrls, ToolWin, ImgList, Dateutils,
  UMhdrMan,
  DMSrvPC,
  UGshapeMan,
  UMPlanObj,
  UMPlanTbs,
  UMDurObj,
  UMTabCfg,
  UMRes,
  UMViewPage,
  UMSchedContFunc,
  ExtCtrls, StdCtrls,
  UMCommon, UReshape,
  UMDbFunc,
  UGWorkCentersPlanControl,
  gnugettext, FMExcelReport, FMCapResDynamic,
  UMOpStack, Buttons, System.ImageList, UGWorkCentersPlanShot, cxImageList, cxGraphics ;//, ExceptionLog;

const
  CcfgDbCode  = 1;
  CmainDbCode = 1;
  CprogRele   = '1.0.1';
  wm_Stylechange = wm_app + $1000;

type

  TShapeUpdate = class(ExtCtrls.TShape) //interposer class
  protected
     procedure Paint; override;
  end;

  TFMQMPlan = class(TForm)
    MainMenu: TMainMenu;
    MIFile: TMenuItem;
    MISave: TMenuItem;
    MIRefreshExternal: TMenuItem;
    MIExit: TMenuItem;
 //   MICreat: TMenuItem;
    MIShow: TMenuItem;
    MIShowCalShapes: TMenuItem;
    MISetting: TMenuItem;
    MIColorLegend: TMenuItem;
    MIVerify: TMenuItem;
    TBMain: TToolBar;
    TBSave: TToolButton;
    TBSpcCrtCap: TToolButton;
    VSplit: TSplitter;
    HSplit: TSplitter;
    PanRgDock: TPanel;
    PanBotDock: TPanel;
    PUpPlan: TPopupMenu;
    PupCapRes: TPopupMenu;
    PupJob: TPopupMenu;
    ICapResDetails: TMenuItem;
    ICloseTbs: TMenuItem;
    PopRes: TPopupMenu;
    MIResDetails: TMenuItem;
    ImageListBig: TImageList;
    TBResources: TToolButton;
    MIWkcDet: TMenuItem;
    MIPlanPropRepo: TMenuItem;
    ImageList1: TImageList;
    MIConfig: TMenuItem;
    MIStepDetails: TMenuItem;
    StBarInfo: TStatusBar;
    PupGroup: TPopupMenu;
    MIGrpDetails: TMenuItem;
    MIgrpToBin: TMenuItem;
    MICompatInBin: TMenuItem;
    MIClearCompInBin: TMenuItem;
    MIDelCapRes: TMenuItem;
    TBSpcLowWndw: TToolButton;
    MIJobHandle: TMenuItem;
    N1: TMenuItem;
    MIResourceReport: TMenuItem;
    MIAutoSchedSettings: TMenuItem;
    MILangauge: TMenuItem;
    MIEnglish: TMenuItem;
    MIItalian: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    MISearchProdReqby: TMenuItem;
    MIProductionReq: TMenuItem;
    MIProdType: TMenuItem;
    MIWorkCenter: TMenuItem;
    MIProccess: TMenuItem;
    MIProdFamiy: TMenuItem;
    MIMaterialFamily: TMenuItem;
    MIChinese: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    MIEditCal: TMenuItem;
    MIAutoSeqResult: TMenuItem;
    PupActArea: TPopupMenu;
    MIApaCrtCapRes: TMenuItem;
    MIApaCrtDownTime: TMenuItem;
    MIApaDelPlan: TMenuItem;
    MISortresourcesby: TMenuItem;
    MISortResourceCode: TMenuItem;
    Categoryresourcecode1: TMenuItem;
    WCresourcecode1: TMenuItem;
    Wccategoryresource1: TMenuItem;
    N6: TMenuItem;
    MIFindjobinbin: TMenuItem;
    MiTurkish: TMenuItem;
    MiSetBinConficuration: TMenuItem;
    StMouseDate: TStaticText;
    ToolButton6: TToolButton;
    MISpanish: TMenuItem;
    MIResourceReport1: TMenuItem;
    SaveDialog1: TSaveDialog;
    MISimplified: TMenuItem;
    MITraditional: TMenuItem;
    MIBinHtmlReport: TMenuItem;
    MIBinExcelReport: TMenuItem;
    ExcelFontBold: TLabel;
    MIBarconfig: TMenuItem;
    RefreshTimer: TTimer;
    N8: TMenuItem;
    PnlSimulation: TPanel;
    PanStatus: TPanel;
    ShServerLoad: TShape;
    MIJobBarConfig: TMenuItem;
    MIStatusbarConfig: TMenuItem;
    MIScheduleReport: TMenuItem;
    MISetFinal: TMenuItem;
    MISetToTemp: TMenuItem;
    MIPrint: TMenuItem;
    MILabel: TMenuItem;
    MIRoll: TMenuItem;
    TBUndo: TToolButton;
    MIEdit: TMenuItem;
    MIUndo: TMenuItem;
    N10: TMenuItem;
    MIProd: TMenuItem;
    TBAutoSchedCfg: TToolButton;
    ExcelFontHeader1: TLabel;
    ExcelFontHeader2: TLabel;
    MISetLevelTo: TMenuItem;
    MISetLevelTo1: TMenuItem;
    MISetLevelTo2: TMenuItem;
    MISetLevelTo3: TMenuItem;
    MISetLevelTo4: TMenuItem;
    MISetLevelTo5: TMenuItem;
    MISetNextLevel: TMenuItem;
    N11: TMenuItem;
    MISetIniFin: TMenuItem;
    MIUserDictionary: TMenuItem;
    MIShowbintoolbar: TMenuItem;
    MIDynamicSchedExcel: TMenuItem;
    MIDynamicSchedHtml: TMenuItem;
    PnlProgBar: TPanel;
    ToolButton2: TToolButton;
    MIAbout: TMenuItem;
    MIShowrequierments: TMenuItem;
    Bin1: TMenuItem;
    MIShowbin: TMenuItem;
    MIResetBin: TMenuItem;
    MIDownLoadFromHost: TMenuItem;
    MIDnLoadUploadReq: TMenuItem;
    MIDownloadProd: TMenuItem;
    MIOnlyUpload: TMenuItem;
    MiTools: TMenuItem;
    MiPushJobsAfterNOW: TMenuItem;
    MiPuchJobsByActiveTab: TMenuItem;
    MiPushAllJobs: TMenuItem;
    MIApaEditPlan: TMenuItem;
    MISubRes: TMenuItem;
    MISubResCollapse: TMenuItem;
    MISubResExpand: TMenuItem;
    MIServerStatus: TMenuItem;
    N12: TMenuItem;
    MIBucketReport: TMenuItem;
    MICngResSec: TMenuItem;
    MIIgnoreprogress: TMenuItem;
    MiSetBarColor: TMenuItem;
    MiSetPropColor: TMenuItem;
    MiBarColorCreteria: TMenuItem;
    MiSchedulestatus: TMenuItem;
    MiPropertyPreDefined: TMenuItem;
    MiPropertyDynamic: TMenuItem;
    MiSplitHere: TMenuItem;
    MIRestOnGantt: TMenuItem;
    MiUnscheduleRestToBin: TMenuItem;
    MIUnscheduleRestGroupToBin : TMenuItem;
    MiSplitGroupOnGantt : TMenuItem;
    MISetLevelToGrp: TMenuItem;
    MISetToTempGrp: TMenuItem;
    MISetLevelToGrp1: TMenuItem;
    MISetLevelToGrp2: TMenuItem;
    MISetLevelToGrp3: TMenuItem;
    MISetLevelToGrp4: TMenuItem;
    MISetLevelToGrp5: TMenuItem;
    MISetFinalGrp: TMenuItem;
    MISetIniFinGrp: TMenuItem;
    MISetNextLevelGrp: TMenuItem;
    MiChangeBalance: TMenuItem;
    MiShowScheduledJobs: TMenuItem;
    MiShowScheduledJobsFromPoint: TMenuItem;
    MiCustomizedFields: TMenuItem;
    MiDateCustomize: TMenuItem;
    MIAutoSchedCfg: TMenuItem;
    MiLastAutoSeqResult: TMenuItem;
    MIStockDetails: TMenuItem;
    MiShowBarColorCreteriaTab: TMenuItem;
    MiPropertyPreDefinedTab: TMenuItem;
    MiPropertyDynamicTab: TMenuItem;
    MiStandardSettings: TMenuItem;
    MiScheduleStatusTab: TMenuItem;
    MiExcelReport: TMenuItem;
    MIEditCapacity: TMenuItem;
    MIUPloadDownload: TMenuItem;
    MiSplitBySelectedDate: TMenuItem;
    MiSplitFromThisPointBehaviour: TMenuItem;
    MiSplitFromThisPointOnGantt: TMenuItem;
    MiSplitFromThisPointRestToBin: TMenuItem;
    MiCreateNewTabFromBinResources: TMenuItem;
    MiUpdateTabUsingBinResource: TMenuItem;
    MiReportfreeResource: TMenuItem;
    MiDateCustomizeGap1: TMenuItem;
    MiDateCustomizeGap3: TMenuItem;
    MiAutomaticOperation: TMenuItem;
    MiSetjobslimitdates: TMenuItem;
    MIUnschedule: TMenuItem;
    MIRussian: TMenuItem;
    PopupWcLevel: TPopupMenu;
    IwkcDetails: TMenuItem;
    PopupWcSlot: TPopupMenu;
    MiGroupedByFiled: TMenuItem;
    IFilterBinBySlot: TMenuItem;
    IwkcPropertySelectionAllWc: TMenuItem;
    IViewAllWcSecondLvla: TMenuItem;
    IViewAllAsWorkCnterCategory: TMenuItem;
    Iwkc: TMenuItem;
    MiTabHandle : TMenuItem;
    IwkcPropertySelectionWc: TMenuItem;
    IViewAsWorkCnterCategory: TMenuItem;
    PopupPropertySlot: TPopupMenu;
    IClearSecondLevl: TMenuItem;
    IClearSeconLvl: TMenuItem;
    WorkCenterCap: TMenuItem;
    IFilterBinBySlotProp: TMenuItem;
    MIAutoSchedWcCfg: TMenuItem;
    NiNewtabs: TMenuItem;
    MiSlotFilterTab: TMenuItem;
    MiSearch: TMenuItem;
    MiAutoSeqResults: TMenuItem;
    MiGerman: TMenuItem;
    MiStatistics: TMenuItem;
    MistatisticsCreateAndShow: TMenuItem;
    MiStatisticsShow: TMenuItem;
    MiStatisticsUndo: TMenuItem;
    MiShowStatisticsWeeks: TMenuItem;
    MiShowStatisticsMonths: TMenuItem;
    MiStatisticsClean: TMenuItem;
    MiDashboard: TMenuItem;
    MiSetSavedScheduleDate: TMenuItem;
    MIDailyMachineReport: TMenuItem;
    MICapResDynamic: TMenuItem;
    MiSetStyle: TMenuItem;
    MiSplitRemainGroup: TMenuItem;
  	MiSapphireKamri: TMenuItem;
    MiStyleWindows: TMenuItem;
    MiSplitRemainJob: TMenuItem;
  	MiStyleLuna: TMenuItem;
    MiStyleSky: TMenuItem;
    MIStyleIcebergClassico: TMenuItem;
    ToolButton1: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton14: TToolButton;
    MiBlanck: TMenuItem;
    MainMenuIcons: TImageList;
    JobsIcon: TImageList;
    ToolButton7: TToolButton;
    ImageList2: TImageList;
    Deletegantttab1: TMenuItem;
    Editgantttab1: TMenuItem;
    BalloonHint1: TBalloonHint;
    MiSpeedChange: TMenuItem;
    MiSeedGrpChange: TMenuItem;
    MiLearningCurveChange: TMenuItem;
    MiChangingCurveCode: TMenuItem;
    MiRemoveCurveCode: TMenuItem;
    PupWarp: TPopupMenu;
    MiDelwarp: TMenuItem;
    MiPushJobsAfterNOWAndclosefuturegaps: TMenuItem;
    MiPuchJobsAndCloseGapsByActiveTab: TMenuItem;
    MiPushAllJobsAndCloseGaps: TMenuItem;
	  stQtyComp: TStaticText;
    MiSpeedChangeWarp: TMenuItem;
    MiWarpShowCompatibleInBin: TMenuItem;
    NewTabsWarp1: TMenuItem;
    CompatibleinbinWarp1: TMenuItem;
    MiGroupBucket: TMenuItem;
    MiResourceSchedulesBysequence: TMenuItem;
    MiScheduleJobBySequence: TMenuItem;
    MICompacAllScheduledFromThisPointOnThisResource: TMenuItem;
    MICompacAllScheduledFromThisPointForAllResource: TMenuItem;
    TimerConnectionCheck: TTimer;
    Appendix1: TMenuItem;
    MISplitGroup: TMenuItem;
    ChangeStationpassword: TMenuItem;
    MiLearningCurveGrpChange: TMenuItem;
    MiRemoveCurveGrpCode: TMenuItem;
    MiChangingCurveGrpCode: TMenuItem;
    N9: TMenuItem;
    MiSavePlanCopy: TMenuItem;
    MiCollapseall: TMenuItem;
    MiExpandall: TMenuItem;
    MiComparesavedbuckets: TMenuItem;
    MiFrench: TMenuItem;
    MiSlotDetails: TMenuItem;
    MIShowwarpcompatible: TMenuItem;
    miAvailablityReport: TMenuItem;
    MiArabic: TMenuItem;
    MIIgnoreprogressGrp: TMenuItem;
    cxImageList1: TcxImageList;
    N13: TMenuItem;
    miExpandallGroup: TMenuItem;
    miCollapseallGroup: TMenuItem;
    PopupWcGrpSlot: TPopupMenu;
    Filtercurrentbinbyslot1: TMenuItem;
    MiSlotDetailsProp: TMenuItem;
    MiSlotDetailsGrp: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure PanDockDockDrop(Sender: TObject; Source: TDragDockObject;
      X, Y: Integer);
    procedure PanRgDockDockOver(Sender: TObject; Source: TDragDockObject;
      X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure PanDockGetSiteInfo(Sender: TObject; DockClient: TControl;
      var InfluenceRect: TRect; MousePos: TPoint; var CanDock: Boolean);
    procedure PanRgDockUnDock(Sender: TObject; Client: TControl;
      NewTarget: TWinControl; var Allow: Boolean);
    procedure PanBotDockDockOver(Sender: TObject; Source: TDragDockObject;
      X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure PanBotDockUnDock(Sender: TObject; Client: TControl;
      NewTarget: TWinControl; var Allow: Boolean);
    procedure ICapResDetailsClick(Sender: TObject);
    procedure ICloseTbsClick(Sender: TObject);
    procedure DeleteTab;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PgcMainChange(Sender: TObject);
    procedure PUpPlanPopup(Sender: TObject);
    procedure TBLogWindowClick(Sender: TObject);
    procedure MIResDetailsClick(Sender: TObject);
    procedure MIWkcDetClick(Sender: TObject);
    procedure MIPlanPropRepoClick(Sender: TObject);
    procedure IMoveToBinClick(Sender: TObject);
    procedure MISaveClick(Sender: TObject);
    procedure MIRefreshExternalClick(Sender: TObject);
    procedure MIStepDetailsClick(Sender: TObject);
    procedure MIExitClick(Sender: TObject);
    procedure TBResourcesClick(Sender: TObject);
    procedure MICrtCapResClick(Sender: TObject);
    procedure MIApaCrtCapResClick(Sender: TObject);
    procedure MIApaCrtDownTimeClick(Sender: TObject);
    procedure PupActAreaPopup(Sender: TObject);
    procedure MIShowCalShapesClick(Sender: TObject);
    procedure TrcBarZoomChange(Sender: TObject);
    procedure TrcBarStatusChange(Sender: TObject);
    procedure MIGrpDetailsClick(Sender: TObject);
    procedure MIConfigClick(Sender: TObject);
    procedure MICompatInBinClick(Sender: TObject);
    procedure MIClearCompInBinClick(Sender: TObject);
    procedure MIShowBinClick(Sender: TObject);
    procedure MIDelCapResClick(Sender: TObject);
    procedure MIJobHandleClick(Sender: TObject);
    procedure MIResSchedHtmlReportclick(Sender: TObject);
    procedure MIAutoSchedSettingsClick(Sender: TObject);
    procedure MIEnglishClick(Sender: TObject);
    procedure MIItalianClick(Sender: TObject);
    procedure MIColorLegendClick(Sender: TObject);
    procedure MIProductionReqClick(Sender: TObject);
    procedure MIProdTypeClick(Sender: TObject);
    procedure MIWorkCenterClick(Sender: TObject);
    procedure MIProccessClick(Sender: TObject);
    procedure MIProdFamiyClick(Sender: TObject);
    procedure MIMaterialFamilyClick(Sender: TObject);
    procedure MIChineseClick(Sender: TObject);
    procedure MIEditCalClick(Sender: TObject);
    procedure MISortResourceCodeClick(Sender: TObject);
    procedure Categoryresourcecode1Click(Sender: TObject);
    procedure WCresourcecode1Click(Sender: TObject);
    procedure Wccategoryresource1Click(Sender: TObject);
    procedure MIFindjobinbinClick(Sender: TObject);
    procedure MiTurkishClick(Sender: TObject);
    procedure MiSetBinConficurationClick(Sender: TObject);
    procedure IMoveAllJobsToBinClick(Sender: TObject);
    procedure PupJobPopup(Sender: TObject);
    procedure PupGroupPopup(Sender: TObject);
    procedure MISpanishClick(Sender: TObject);
    procedure MITraditionalClick(Sender: TObject);
    procedure MIBinHtmlReportClick(Sender: TObject);
    procedure MIBinExcelReportClick(Sender: TObject);
//    procedure MIBarconfigClick(Sender: TObject);
    procedure RefreshTimerTimer(Sender: TObject);
    procedure TbRefreshBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MIJobBarConfigClick(Sender: TObject);
    procedure MIStatusbarConfigClick(Sender: TObject);
    procedure MIScheduleReportClick(Sender: TObject);
    procedure MISetFinalClick(Sender: TObject);
    procedure MISetToTempClick(Sender: TObject);
    procedure MILabelClick(Sender: TObject);
//    procedure MIRollClick(Sender: TObject);
    procedure MIProdClick(Sender: TObject);
    procedure MIUndoClick(Sender: TObject);
    procedure TBUndoClick(Sender: TObject);
    procedure MIMaterialsClick(Sender: TObject);
    procedure MISetLevelTo1Click(Sender: TObject);
    procedure MISetLevelTo2Click(Sender: TObject);
    procedure MISetLevelTo3Click(Sender: TObject);
    procedure MISetLevelTo4Click(Sender: TObject);
    procedure MISetLevelTo5Click(Sender: TObject);
    procedure MISetIniFinClick(Sender: TObject);
    procedure MISetNextLevelClick(Sender: TObject);
    procedure MIUserDictionaryClick(Sender: TObject);
    procedure MIShowbintoolbarClick(Sender: TObject);
    procedure MIResSchedExcelReportclick(Sender: TObject);
    procedure MIAboutClick(Sender: TObject);
    procedure MIShowrequiermentsClick(Sender: TObject);
    procedure MIResetBinClick(Sender: TObject);
    procedure MIFileClick(Sender: TObject);
    procedure MIDnLoadUploadReqClick(Sender: TObject);
    procedure MIDownloadProdClick(Sender: TObject);
    procedure MIOnlyUploadClick(Sender: TObject);
    procedure MiPuchJobsByActiveTabClick(Sender: TObject);
    procedure MiPushAllJobsClick(Sender: TObject);
    procedure MIApaEditPlanClick(Sender: TObject);
    procedure CustomizedResourceList1Click(Sender: TObject);
    procedure MISubResCollapseClick(Sender: TObject);
    procedure MISubResExpandClick(Sender: TObject);
    procedure PopResPopup(Sender: TObject);
    procedure MIServerStatusClick(Sender: TObject);
    procedure MIBucketReportClick(Sender: TObject);
    procedure MICngResSecClick(Sender: TObject);
    procedure MIIgnoreprogressClick(Sender: TObject);
    procedure PupCapResPopup(Sender: TObject);
    procedure CheckConnectionClick(Sender: TObject);
    procedure MiSchedulestatusClick(Sender: TObject);
    procedure ClickShowBarColorDynamic(Sender: TObject);
    procedure ClickShowBarColorTabDynamic(Sender: TObject);
    procedure ClickShowBarColorfromPropList(Sender: TObject);
    procedure ClickShowBarColorTabfromPropList(Sender: TObject);
    procedure ClickAutoRunByCode(Sender: TObject);
    procedure MISetPropertyToAllWcClick(Sender: TObject);
    procedure MISetPropertyToWcClick(Sender: TObject);
    procedure MIRestOnGanttClick(Sender: TObject);
    procedure MiUnscheduleRestToBinClick(Sender: TObject);
    procedure MISetLevelToClick(Sender: TObject);
    procedure MISetNextLevelGrpClick(Sender: TObject);
    procedure MiChangeBalanceClick(Sender: TObject);
    procedure MiShowScheduledJobsClick(Sender: TObject);
    procedure MiShowScheduledJobsFromPointClick(Sender: TObject);
    procedure MiDateCustomizeClick(Sender: TObject);
    procedure MIAutoSchedCfgClick(Sender: TObject);
    procedure MiLastAutoSeqResultClick(Sender: TObject);
    procedure MIStockDetailsClick(Sender: TObject);
    procedure MiStandardSettingsClick(Sender: TObject);
    procedure MiScheduleStatusTabClick(Sender: TObject);
    procedure MiExcelReportClick(Sender: TObject);
    procedure MIEditCapacityClick(Sender: TObject);
    procedure MIUPloadDownloadClick(Sender: TObject);
    procedure MiSplitBySelectedDateClick(Sender: TObject);
    procedure MiSplitFromThisPointBehaviourClick(Sender: TObject);
    procedure MiSplitFromThisPointOnGanttClick(Sender: TObject);
    procedure MiSplitFromThisPointRestToBinClick(Sender: TObject);
    procedure MiCreateNewTabFromBinResourcesClick(Sender: TObject);
    procedure MiUpdateTabUsingBinResourceClick(Sender: TObject);
    procedure MiReportfreeResourceClick(Sender: TObject);
    procedure MiDateCustomizeGap1Click(Sender: TObject);
    procedure MiDateCustomizeGap3Click(Sender: TObject);
    procedure MiToolsClick(Sender: TObject);
    procedure MiAutomaticOperationClick(Sender: TObject);
    procedure MiSetjobslimitdatesClick(Sender: TObject);
    procedure IMoveAllInBinLastOnGanntClick(Sender: TObject);
    procedure MIRussianClick(Sender: TObject);
    procedure IwkcDetailsClick(Sender: TObject);
    procedure OnPopupWcSlot(Sender: TObject);
    procedure OnPopupPropertySlot(Sender: TObject);
    procedure MiGroupedByFiledClick(Sender: TObject);
    procedure IFilterBinBySlotClick(Sender: TObject);
    procedure IViewAllAsWorkCnterCategoryClick(Sender: TObject);
    procedure IViewAsWorkCnterCategoryClick(Sender: TObject);
    procedure IwkcPropertySelectionWcClick(Sender: TObject);
    procedure IClearSecondLevlClick(Sender: TObject);
    procedure IClearSeconLvlClick(Sender: TObject);
    procedure WorkCenterCapClick(Sender: TObject);
    procedure IWcDleteTabClick(Sender: TObject);
    procedure MIUnscheduleClick(Sender: TObject);
    procedure TBShowCalClick(Sender: TObject);
    procedure IFilterBinBySlotPropClick(Sender: TObject);
    procedure MIAutoSchedWcCfgClick(Sender: TObject);
    procedure NiNewtabsClick(Sender: TObject);
    procedure MiSlotFilterTabClick(Sender: TObject);
    procedure MiSearchClick(Sender: TObject);
    procedure MiAutoSeqResultsClick(Sender: TObject);
    procedure PopupWcLevelPopup(Sender: TObject);
    procedure MiGermanClick(Sender: TObject);
    procedure MistatisticsCreateAndShowClick(Sender: TObject);
    procedure MiStatisticsShowClick(Sender: TObject);
    procedure MiStatisticsUndoClick(Sender: TObject);
    procedure MIResourceReportClick(Sender: TObject);
    procedure MiStatisticsCleanClick(Sender: TObject);
    procedure MiDashboardClick(Sender: TObject);
    procedure MiSetSavedScheduleDateClick(Sender: TObject);
    procedure MIDailyMachineReportClick(Sender: TObject);
    procedure MICapResDynamicClick(Sender: TObject);
    procedure Dynamiccapacityreservation1Click(Sender: TObject);
    procedure MiSplitRemainGroupClick(Sender: TObject);
	  procedure MiSapphireKamriClick(Sender: TObject);
    procedure MiStyleWindowsClick(Sender: TObject);
    procedure MiSplitRemainJobClick(Sender: TObject);
	  procedure MiStyleLunaClick(Sender: TObject);
    procedure MiStyleSkyClick(Sender: TObject);
    procedure MIStyleIcebergClassicoClick(Sender: TObject);
    procedure OnClickRefreshDate(Sender: TObject);
  //  procedure DrawItemTitleMainMenu(Sender: TObject; ACanvas: TCanvas; ARect: TRect;
  //    Selected: Boolean);
    {procedure DrawItemPopUp(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; Selected: Boolean); }
	  procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure MiSpeedChangeClick(Sender: TObject);
  	procedure TimerConnectionCheckTimer(Sender: TObject);
    procedure MiSpeedChangeWarpClick(Sender: TObject);
    procedure MiSeedGrpChangeClick(Sender: TObject);
    procedure MiUnscheduleWarpClick(Sender: TObject);
    procedure PopupWarp(Sender: TObject);
    procedure MiWarpShowCompatibleInBinClick(Sender: TObject);
    procedure NewTabsWarp1Click(Sender: TObject);
    procedure CompatibleinbinWarp1Click(Sender: TObject);
    procedure MiGroupBucketClick(Sender: TObject);
    procedure MiResourceSchedulesBysequenceClick(Sender: TObject);
    procedure MiScheduleJobBySequenceClick(Sender: TObject);
    procedure MICompacAllScheduledFromThisPointOnThisResourceClick(
      Sender: TObject);
    procedure MICompacAllScheduledFromThisPointForAllResourceClick(
      Sender: TObject);
    procedure Appendix1Click(Sender: TObject);
    procedure SplitGroupClick(Sender: TObject);
    procedure Appendix1MeasureItem(Sender: TObject; ACanvas: TCanvas; var Width,
      Height: Integer);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
      Procedure ChangeStationpasswordClick(Sender: TObject);
    procedure MiChangingCurveCodeClick(Sender: TObject);
    procedure MiRemoveCurveCodeClick(Sender: TObject);
    procedure MiCollapseallClick(Sender: TObject);
    procedure MiExpandallClick(Sender: TObject);
    procedure MiSavePlanCopyClick(Sender: TObject);
    procedure MiComparesavedbucketsClick(Sender: TObject);
    procedure MiFrenchClick(Sender: TObject);
    procedure MiSlotDetailsClick(Sender: TObject);
    procedure MIShowwarpcompatibleClick(Sender: TObject);
    procedure miAvailablityReportClick(Sender: TObject);
    procedure MiArabicClick(Sender: TObject);
    procedure MiFiltercurrentbinbyGroupClick(Sender: TObject);
    procedure miExpandallGroupClick(Sender: TObject);
    procedure miCollapseallGroupClick(Sender: TObject);
  private
    m_ResPopupList : TStringlist;
    m_ActAreaPopupList : TStringlist;
    m_GroupPopupList : TStringlist;
    m_JobPopupList : TStringlist;
    m_HostDataWaiting : boolean;
    m_MyStationEvent : boolean;
    m_OtherStationDataWaiting : boolean;
    m_style : string;
    m_ShapeUpdateAvailable : TShapeUpdate;
    m_ShapeUpdateNow       : TShapeUpdate;
    m_RefreshDate          : boolean;
    m_ConnectionRepairedetails : TStringList;
    procedure GeneratePopupMenus;
    procedure CreateShapeForUpdate;
    procedure CreateNewPlan(tbCfg: TPlanTabsCfg; tabCode: integer);
    procedure ResetTabs(tbCfg: TPlanTabsCfg);
    procedure AddTabWithList(name: string; resList: TList; PlanTyp : TPlanType; SlotGroup : Integer);
    function  IsDynamicActiveted(var Code : integer) : boolean;
    procedure UpdateStatusPanel;
    procedure PgcBinChange;
    procedure UpdateCaptions;
    procedure OpenMqmDynamicPlanforSearch(value : Variant);
    procedure OpenMcmDynamicPlanforSearch(PropCode : string; Value : Variant);
    function  EventCameFromHost : boolean;
    procedure OperateRefreshButton;
    procedure SetPropertyListToPopUpwc;
    procedure SetDynamicSubMenuForShowColor;
    procedure ClickSetPropColorBar(Sender: TObject);
    procedure SetCheckedCurrentPropertyColoredPreDefined(CreanAllChecked : boolean);
    procedure SetCheckedCurrentPropertyColoredDynamic(CreanAllChecked : boolean);
    procedure SetCheckedCurrentPropertyColoredPreDefinedTab(CreanAllChecked : boolean;  pId : Pointer);
    procedure SetCheckedCurrentPropertyColoredDynamicTab(CreanAllChecked : boolean; pId : Pointer);
    procedure ShowScheduledJobsOnRes(date_from : TDateTime; date_to : TdateTime; MqmRes : TMqmRes);
    procedure SetDynamcMenuForAutoRunCodes;
    procedure SetVisibilityForPopup(Sender: TObject);

  protected
    procedure UpdateRequested(var msg: TMessage); message MSG_UPDATE;
    procedure PowerMessageReceived(var msg: TMessage); message WM_POWERBROADCAST;
    procedure WMStyleChange( var msg: TMessage ); message wm_Stylechange;

  public
///    m_shapeMan: TShapeManager;
    m_planTbCfg: TPlanTabsCfg;
    m_pgcPlan:   TMViewPage;
    m_popObj:    TMqmPlanObj;
    m_popDate:   TDateTime;
    m_MouseDate: TDateTime;
    m_MqmWrkCtrPopUp : Pointer;
    m_SelectedListWrkCtrPopUp : TList;
    //m_popWcMatProductCode : string;
    MainProgBar: TMqmProgBar;
    m_MainX : Integer;
    Changing : Boolean;
    m_ClientConnected : Boolean;
    m_ListAutoRunSetInfo : TList;
    m_PlanLine : TPlanLineWCGroup;
    m_MqmSlotInfoLine : TPlanLineShow;   // slot line last right-clicked (for Slot Info, any level)
    m_SlotInfoSlotStart : TDateTime;
    m_SlotInfoSlotEnd   : TDateTime;
    function GetResPopupList: TStringList;
    function GetActAreaPopupList: TStringList;
    function GetGroupPopupList: TStringList;
    function GetJobPopupList: TStringList;

    Procedure CompactallscheduledjobsfromthispointonwardonlyforselectedResource(AllRes : boolean);
    function  BuildStatisticAndShow(OnlyShow : boolean) : TList;
    function  CheckChangedDataForWc : boolean;
    function  CheckChangedDataForRes : boolean;
    function  MoveAllowed(Obj: TMqmDurObj): boolean;
    procedure RefreshActiveTab;
    procedure EnterCompatModeInPlan(id: TSchedId);
    procedure FocusAllTbsOnDate(date: TDateTime);
    procedure FocusAllTbsOnID(Id: TSchedId);
    procedure FocusOnPlan(Id: TSchedId);
    procedure FocusMatOnPlan(Id: TSchedId);
    procedure FocusOnDate(VisRes : TMqmVisibleRes ; JobId : TSchedId);
    procedure ExitCompatModeInPlan;
    procedure SBarSetSchedObj(Param: PTRowParms);
    procedure SBarSetPlanObj(obj: TMqmPlanObj);
    procedure SetMouseDateDesc(posXMou: integer);
    procedure SetMouseQtyComp(Qty: Double; IsSubRes : boolean);
    procedure CleanSBar;
    procedure SetDynamicMqmPlanActive(ResList : TList; Value : Variant);
    procedure SetDynamicMcmPlanActiv(VisResList : TList; WcList : TList; PropCode : string; Value : Variant);
    function  IsDynamicPlanActiv : boolean;
    function  IsDynamicPlanOpened : boolean;
    procedure ResetDynamicTab;
    function  GetListForActPlanTab(List : TList) : Boolean;
    procedure ShowDockPanel(APanel: TPanel; MakeVisible: Boolean; Client: TControl);
    function  GetPlanCfg: TPlanTabsCfg;
    function  GetActiveTab: TMqmPlanTabSheet;
    function  SaveToDB(ForSim: boolean ): boolean;
    function  OrganizePlanAfterOrBeforeToday(ByActiveTab : boolean; BeforeNow : boolean) : boolean;
    procedure MiniMizedMainForm;
    procedure MaxiMizedMainForm;
    procedure DisableMainMenu;
    procedure EnableMainMenu;
    Procedure UpdateMenuItems(Value: Boolean);
    procedure ActiveUndo;
    procedure SendJobMsg;
    procedure SendSharedData;
    function  CheckMultiResInActiveTab : boolean;
    procedure ExpOrCollSubRes(Expand: boolean);
    procedure ExpOrCollSubResForAllRes(Expand: boolean);
    procedure SetActiveTabByName(Name : string);
    function  ChangeTabFromResourcesToWorkCenters(FromResources : boolean) : boolean;
    function  CheckIfActiveGanttTabIsMcm : boolean;
    procedure SetSelectionSlotOnActiveTab;
    function RemoveAmpersand(ACaption : string) : string;
    procedure UpdateBalanceListFromDB;
    procedure ExpOrCollSubResForCfg(Expand: boolean; ConfTab: TPlanTabCfg);

  end;

  procedure OpenPlanView(AOwner: TComponent);
  function  GetPlanView: TFMQMPlan;
  function  LoadPlanFromDB(ProgBar: TMqmProgBar; Status: TStaticText): boolean;
  function  IsCompatibleWithDb(mainCode, cfgCode: integer; var errStr: string): boolean;
  function  IsDynamicPlanActiv : boolean;
  function  IsDynamicBinPlanActiv : boolean;
  procedure SetDynamicMqmPlanActive(ResList : TList; Value : Variant);
  procedure OpenMqmDynamicPlanforSearch(value : Variant);
  procedure OpenMcmDynamicPlanforSearch(PropCode : string; Value : Variant);
  procedure ResetDynamicTab;
  procedure MoveAllJobsToBin(LastOnGantt : boolean; MessagDlg : boolean; LinkedAndForewardJobs : boolean);
  function  GetLastProdSched : Integer;
  function  GetLastCapRes : Integer;
  function  GetLastSharedData : integer;
  function  RefreshData : boolean;
  procedure GetGanttTabsNameList(ListStrGanttTabsName : TStringList);
  function  CheckMultiResInActiveTab : boolean;
  procedure SetActiveTabByName(Name : string);
  function  ChangeTabFromResourcesToWorkCenters(FromResources : boolean) : boolean;
  procedure SetDynamicMcmPlanActiv(VisResList : TList; WcList : TList; PropCode : string; Value : Variant);
  function  RefreshMcmActiveGanttTab : boolean;
  function  CheckIfActiveGanttTabIsMcm : boolean;
  Procedure RefreshWkcGroup;

var
  FMQMPlan: TFMQMPlan;

implementation

{$R *.DFM}

uses
  FMWait,
  Variants,
  UMSchedCont,
  umgLOBAL,
  UMTblDesc,
  Math,
  UMSchedObjMover,
  UMplan,
  UGGlobal,
  UMStatus,
  UMCompat,
  Vcl.Themes,
  UMPlanGraph,
  UMwkCtr,
  UMCapRes,
  UMWarp,
  FMBin,
  UMObjCont,
  UMActArea,
  FMOccMov,
  UMCompatSrv,
  UMReports,
  FMColors,
  UMBinDefault,
  UMBinMatDefault,
  FMStepDetails,
  FMCreateCapRes,
  FMStockDetails,
  FMCrtDownTime,
  FMresFilter,
  FMGroupDetail,
  FMResDetails,
  FMEditCal,
  FMWkcDetails,
  FGInfo,
  UMAutoSched,
  UMBinFunc,
  UGGanttPanel,
  FMAutoSchedReport,
  FMOptions,
  UGcal,
  UMDescUm,
  FMAutoSchedCfg,
  FMJobHandle,
  UGLicensing,
  UGBaseCal,
  UMBinTbs,
  UGPropComp,
  FMcfgBin,
  UMCalDbInterface,
  UMStoredProc,
  FMAutoSched,
  UmCmp,
  UMBinGrid,
  UMBinPanel,
  FMMsgDlgSim,
  FmEditCapacity,
  UMArticles,
{$ifdef ARO}
  UMReport,
{$endif}
  FMBarConfig,
  FMBarConfigSets,
  UMIssuedArt,
  FMShowMaterials,
  UMAutoSchedCfg,
  FMAbout,
  FMcfgResList,
  FMServerStatus,
  FMShowColorsBar,
  FMlearningCurve,
  FMBalanceHeaders,
  CheckLst,
  FMViewHtml,
  UMReportExport,
  FMMsgJobHandler,
  FMCustomizeDates,
  FMCustomizeDatesGap,
  FMPlannerPropDefine,
  FMSplitBySelectedDateTime,
  FMSpeedMachine,
//  FMResourceGroupDefinition,
  FmAutoRunSet, UMGenericSchedulePrevStep,
  UMSchedList,
  FMGroupedByFieldsConfig,
  FMGroupedByFieldsSet,
  UGWorkCentersDrawSlot,
  FMAutoSchedWorkCenterCfg,
  FMWorkCenterCategoryCapacity,
  FMStatistics,
  UMStatisticCalculation,
  UMDashboardHtml,
  UGWorkCentersPlanDraw,
  FMRequirements,
  UMConnectionClientThread, FMsplash,
  UMExternalDatabaseOperation, FMChangeWkstPass, FMSavedPlanCopy,
  FmAutoRunDefinition, FMTotalViews, FMAppendix, FMGrpSplit, UMPlanFunc, FMSlotInfo,
  FMCompareSavedBuckets, FMAvailablityReport;

var
  s_FMQMPlan: TFMQMPlan;

//----------------------------------------------------------------------------//

Procedure TFMQMPlan.SetVisibilityForPopup(Sender: TObject);
var i, y : Integer;
begin
  if DBAppGlobals.MCM_App then Exit;
  if TPopupMenu(Sender).Name = 'PopRes' then
  begin
    for y := 0 to TPopupMenu(Sender).Items.Count -1 do
    begin
      if m_ResPopupList.IndexOf(TMenuItem(TPopupMenu(Sender).items[y]).Name) = -1  then
          TMenuItem(TPopupMenu(Sender).items[y]).Visible := False;
    end;
  end else if TPopupMenu(Sender).Name = 'PupActArea' then
  begin
    for y := 0 to TPopupMenu(Sender).Items.Count -1 do
    begin
       if m_ActAreaPopupList.IndexOf(TMenuItem(TPopupMenu(Sender).items[y]).Name) = -1  then
          TMenuItem(TPopupMenu(Sender).items[y]).Visible := False;
    end;
  end else if TPopupMenu(Sender).Name = 'PupGroup' then
  begin
    for y := 0 to TPopupMenu(Sender).Items.Count -1 do
    begin
      if TMenuItem(TPopupMenu(Sender).items[y]).Name = 'MISetNextLevelGrp' then
          if (TMenuItem(TPopupMenu(Sender).items[y]).Caption = _('Set to final')) and (TMenuItem(TPopupMenu(Sender).items[y]).Visible = false) then
              continue;

     if m_GroupPopupList.IndexOf(TMenuItem(TPopupMenu(Sender).items[y]).Name) = -1  then
     begin
       if TMenuItem(TPopupMenu(Sender).items[y]).Name <> 'MIIgnoreprogressGrp' then
         TMenuItem(TPopupMenu(Sender).items[y]).Visible := False;
     end;
    end;
  end else if TPopupMenu(Sender).Name = 'PupJob' then
  begin
    for y := 0 to TPopupMenu(Sender).Items.Count -1 do
    begin
      if m_JobPopupList.IndexOf(TMenuItem(TPopupMenu(Sender).items[y]).Name) = -1  then
         TMenuItem(TPopupMenu(Sender).items[y]).Visible := False;
    end;
  end;
end;

//----------------------------------------------------------------------------//

function IsCompatibleWithDb(mainCode, cfgCode: integer; var errStr: string): boolean;
begin
  Result := true;
  errStr := '';

  if mainCode <> CmainDbCode then
  begin
    errStr := _('main database version not supported');
    Result := false
  end;

  if (cfgCode <> CcfgDbCode) then
  begin
    if errStr <> '' then errStr := errStr + #10#13;
    errStr := errStr + _('configuration database version not supported');
    Result := false
  end
end;

//----------------------------------------------------------------------------//

function IsDynamicPlanActiv : boolean;
var
  MQMPlan : TFMQMPlan;
begin
  MQMPlan := GetPlanView;
  Result := MQMPlan.IsDynamicPlanActiv
end;

//----------------------------------------------------------------------------//

function IsDynamicBinPlanActiv : boolean;
var
  MQMPlan : TFMQMPlan;
begin
  MQMPlan := GetPlanView;
  Result := MQMPlan.IsDynamicPlanActiv;
  if Result and Assigned(Fbin) then
    Result := Fbin.IsDynamicBinActive;
end;

//----------------------------------------------------------------------------//

procedure SetDynamicMqmPlanActive(ResList : TList; Value : Variant);
var
  MQMPlan : TFMQMPlan;
begin
  MQMPlan := GetPlanView;
  MQMPlan.SetDynamicMqmPlanActive(ResList, Value);
end;

//----------------------------------------------------------------------------//

procedure OpenMqmDynamicPlanforSearch(value : Variant);
var
  MQMPlan : TFMQMPlan;
begin
  MQMPlan := GetPlanView;
  MQMPlan.OpenMqmDynamicPlanforSearch(value);
end;

//----------------------------------------------------------------------------//

procedure OpenMcmDynamicPlanforSearch(PropCode : string; Value : Variant);
var
  MQMPlan : TFMQMPlan;
begin
  MQMPlan := GetPlanView;
  MQMPlan.OpenMcmDynamicPlanforSearch(PropCode,Value);
end;

//----------------------------------------------------------------------------//

procedure ResetDynamicTab;
var
  MQMPlan : TFMQMPlan;
begin
  MQMPlan := GetPlanView;
  MQMPlan.ResetDynamicTab;
end;

//----------------------------------------------------------------------------//

procedure OpenPlanView(AOwner: TComponent);
begin
  if not Assigned(s_FMQMPlan) then TFMQMPlan.Create(AOwner);
  s_FMQMPlan.Show
end;

//----------------------------------------------------------------------------//

function GetPlanView: TFMQMPlan;
begin
  Result := s_FMQMPlan
end;

//----------------------------------------------------------------------------//

function LoadPlanFromDB(ProgBar: TMqmProgBar; Status: TStaticText): boolean;
const
  TRY_NUMBER = 14;
var
  qry:    TMqmQuery;
  updNum : integer;
  ErrList: TStringList;
  i : integer;
  WorkCentersHandledList, WorkCentersViewedList : string;
begin
  Result := false;
  DBAppGlobals.MAINPLAN_Ignore_Save_Event := true;
  IniAppGlobals.Curr_Date_Signed := now;
  IniAppGlobals.RefreshUTC := UTCNow;
  if Assigned(ProgBar) then
  begin
    ProgBar.SetMax(TRY_NUMBER);
    ProgBar.SetPosition(0);
  end;

  if Assigned(Status) then
    Status.Caption := _('Waiting to access the database...');
  Application.ProcessMessages;

  i := 0;

  while i <= TRY_NUMBER do
  begin

    if GET_ACCESS(IniAppGlobals.WkstCode, AT_Lock) then
    begin
      updNum := GetLastProdSched;
      UPDATE_ACCESS_OPERATION(IniAppGlobals.WkstCode, AT_Read, IniAppGlobals.Curr_Date_Signed);
      IniAppGlobals.WkstCodeSelected := true;
      qry := CreateQuery(Main_DB);
      ErrList := TStringList.Create;

      Application.ProcessMessages;

      WorkCentersHandledList := p_sc.GetWorkCentersList(qry, '1', Status);
      Application.ProcessMessages;
      WorkCentersViewedList := p_sc.GetWorkCentersList(qry, '2', Status);
      Application.ProcessMessages;

      if IniAppGlobals.External_Database_Update = '1' then
      begin
        ExternalDB_FillPropertiesUnscheduleList(qry, Status);
        Application.ProcessMessages;
        ExternalDB_DeleteProd_Sched(qry, ProgBar, Status, WorkCentersHandledList, WorkCentersViewedList);
      end;

      p_ArtType.LoadFromDb(qry, ProgBar, Status);
      if not p_ArtTypeList.LoadFromDb(qry,ProgBar,Status,WorkCentersHandledList,WorkCentersViewedList) then
      begin
        Exit;
      end;
      Application.ProcessMessages;
      p_pl.Load(ProgBar, Status, ErrList, GetLastCapRes, GetLastSharedData);
      if (ErrList.Count > 0) then
      begin
        showmessage(ErrList.Strings[0]);
        Exit
      end;
      Application.ProcessMessages;
      LoadCurveDataFromDB;
      p_sc.LoadFromDb(qry, updNum, GetLast_PROP_PROD_PLANNER, ProgBar, Status, ErrList, WorkCentersHandledList, WorkCentersViewedList);
      Application.ProcessMessages;

      if (IniAppGlobals.External_Database_Update = '1') and (IniAppGlobals.DownloadTo <> '2') then
      begin
        if DBAppGlobals.MCM_App then
          ExternalDB_ForceMqmScheduleDetailsToMCM(WorkCentersHandledList)
        else
          ExternalDB_UpdateMqmFromMcmEarliestLatestDates(qry, ProgBar, Status, WorkCentersHandledList, WorkCentersViewedList);
      end;
            //    p_Priorities.LoadFromDb(qry, ProgBar, Status);
      p_WrkctrDesc.LoadFromDb(qry, ProgBar, Status);
      Application.ProcessMessages;
//      p_ArtType.LoadFromDb(qry, ProgBar, Status);
      Application.ProcessMessages;
      LoadUMDesc;
      Application.ProcessMessages;
      BuildTotalViewStructure_FromDB;
      Application.ProcessMessages;

      qry.Close;

      //qry.Free;
      Application.ProcessMessages;

 {     smd := p_sc.GetSmallestDate;

      smd := Max(smd , Now - 210);

      if (smd = 0) or ((smd-7) > (Now - DBAppGlobals.MonthBefore * 30)) then
        smd := Now - DBAppGlobals.MonthBefore * 30
      else
        smd := smd - 7;

      Application.ProcessMessages;

      // align to the first day of week
      smd := Trunc(smd);
      while DayOfWeek(smd) <> 2 do
        smd := smd - 1.0;

      DBAppGlobals.StDateForPlan  := smd;
      DBAppGlobals.EndDateForPlan := Max(DBAppGlobals.StDateForPlan+500, Now+500);    }

 //     p_pl.Load(ProgBar, Status, ErrList);
      Application.ProcessMessages;
      p_sc.LinkRequests(ProgBar, Status);
      Application.ProcessMessages;

     // SP_END_ACCESS(IniAppGlobals.WkstCode,false);
      END_ACCESS(IniAppGlobals.WkstCode);

      p_sc.LinkJobs(p_pl.PlanLinkJob, nil, ProgBar, Status);
      Application.ProcessMessages;

      p_pl.ReorganizeAllIgnoredProgress(true, ProgBar, Status);
      p_pl.ReorganizeAllProgress(true, ProgBar, Status);
      p_sc.UpdateBalanceQuantity(true, nil);
      p_sc.UpdContGrpTimingsForAll(ProgBar, Status);

      if DBAppGlobals.MCM_App and DBAppGlobals.Mcm_App_Resched_From_Mqm then
      begin
        //if IniAppGlobals.CBForceMqmScheduleDetails = '1' then
          p_pl.PrepareMcmJobsInListForReSchedule(ProgBar, Status);
        Application.ProcessMessages
      end;

      p_sc.LinkWrkCtr(p_pl.FindWrkCtrByCode, ProgBar, Status);
      Application.ProcessMessages;
      p_sc.FindJobsToGroupByProcessPropertyRules(false, ProgBar, Status);
      Application.ProcessMessages;

      p_sc.UpdateBalanceForAllJobs(ProgBar,Status);

      if not p_pl.ReorganizeAll(ProgBar, Status) then
        ErrList.add(_('It is not possible to reorganize the plan'));

      ReBuildGenericPlanScheduled;
      Application.ProcessMessages;

      UpdateJobMsgFromDB(ProgBar, Status, true);
      Application.ProcessMessages;
      ProgBar.SetPosition(0);
      if DBAppGlobals.MCM_App then
      begin
        if IniAppGlobals.CBForceMqmScheduleDetails = '1' then
          Status.Caption := _('Rescheduling MCM jobs and Creating tabs...')
        else
          Status.Caption := _('Creating MCM tabs...')
      end
      else
        Status.Caption := _('Creating MQM tabs...');

      if ErrList.Count > 0 then
        ShowStringsInInfoForm(application, ErrList);

      ErrList.Free;
      Result := true;
      DBAppGlobals.MAINPLAN_Ignore_Save_Event := false;
      break
    end else
    begin
      inc(i);
      if (i > TRY_NUMBER) then
      begin
        if MessageDlg(_('Can not currently open the workstation as the host or a planner are writing to the database. Try again?'), mtConfirmation, [mbYes, mbNo], 0) = idYes then
          i :=0 ;
      end else
      begin
        if Assigned(ProgBar) then
          ProgBar.SetPosition(i);
        Application.ProcessMessages;
        REMOVE_UNACTIVATED_STATIONS;
        {if SP_ASK_POLL then
        begin
          Sleep(2500);
          inc(i);
          if Assigned(ProgBar) then
            ProgBar.SelEnd := i;
          Application.ProcessMessages;
          Sleep(2500);
          SP_CHECK_POLL;
        end else
          Sleep(2500);  }
      end
    end;
  end;

end;

//----------------------------------------------------------------------------//

function ChangeTabFromResourcesToWorkCenters(FromResources : boolean) : boolean;
begin
  FMQMPlan.ChangeTabFromResourcesToWorkCenters(FromResources);
end;

//----------------------------------------------------------------------------//

procedure SetDynamicMcmPlanActiv(VisResList : TList; WcList : TList; PropCode : string; Value : Variant);
var
  MQMPlan : TFMQMPlan;
begin
  MQMPlan := GetPlanView;
  MQMPlan.SetDynamicMcmPlanActiv(VisResList,WcList,PropCode,Value);
end;

//----------------------------------------------------------------------------//

Procedure RefreshWkcGroup;
var pt: TMqmPlanTabSheet;
  MQMPlan : TFMQMPlan;
  TabCfg : TPlanTabCfg;
  WC : TMqmWrkCtr;
  y,i : Integer;
  PlanLineGroup : TPlanLineGroup;
  PlanLineWc : TPlanLineWc;
  PlanLineWCGroup : TPlanLineWCGroup;
  WCList : TList;
begin
  MQMPlan := GetPlanView;
  pt := TMqmPlanTabSheet(MQMPlan.m_pgcPlan.GetActiveView);
  if Assigned(pt) then
  begin
    TabCfg := TPlanTabCfg(MQMPlan.m_planTbCfg.FindTab(pt.GetCode));
    pt.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup_Lists.Clear;

     WCList := TabCfg.GetWorkCenterList;

    for y := 0 to pt.p_PlanWcControl.P_planWcView.p_pShot.GetNumLines - 1 do  //number of rows
    begin

      if TPlanLineShow(TPlanLineGroup(pt.p_PlanWcControl.P_planWcView.p_pShot.GetPlanLine(y)).p_son[0]).ClassName = 'TPlanLineWCGroup' then
      begin
        PlanLineWCGroup := TPlanLineWCGroup(TPlanLineGroup(pt.p_PlanWcControl.P_planWcView.p_pShot.GetPlanLine(y)).p_son[0]);

        for i := 0 to WCList.Count - 1 do
        begin
          WC := TMqmWrkCtr(WCList[i]);
          if (WC.p_ReadOnly) and (not WC.p_Visible) then
            Continue;

          if pt.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup = 1 then
            if (PlanLineWCGroup.p_Group_name = wc.P_WcGrp) and (PlanLineWCGroup.p_WC_List.IndexOf(WC) = -1) then
              PlanLineWCGroup.p_WC_List.Add(WC);

          if pt.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup = 2 then
            if (PlanLineWCGroup.p_Group_name = wc.p_PlantCode) and (PlanLineWCGroup.p_WC_List.IndexOf(WC) = -1) then
              PlanLineWCGroup.p_WC_List.Add(WC);

          if pt.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup = 3 then
            if (PlanLineWCGroup.p_Group_name = wc.p_Division) and (PlanLineWCGroup.p_WC_List.IndexOf(WC) = -1) then
              PlanLineWCGroup.p_WC_List.Add(WC);

        end;
      end;
    end;

    if TabCfg.m_SlotGroup > 0 then
      pt.CreateWkcGroups(TabCfg.GetWorkCenterList);
  end;

end;

function RefreshMcmActiveGanttTab : boolean;
var
  pt: TMqmPlanTabSheet;
  MQMPlan : TFMQMPlan;
  TabCfg : TPlanTabCfg;
  CollapsedGroups : TStringList;
  k : Integer;
begin
  MQMPlan := GetPlanView;
  pt := TMqmPlanTabSheet(MQMPlan.m_pgcPlan.GetActiveView);
  if Assigned(pt) then
  begin
    if pt.p_BasePanelWorkCenters.Visible then
    begin
      p_pl.BuildWkcDailyCapacity(pt.p_ganttPanel.p_VisResList, nil, nil);

      TabCfg := TPlanTabCfg(MQMPlan.m_planTbCfg.FindTab(pt.GetCode));

      if TabCfg.m_SlotGroup > 0 then
      begin
        // save collapsed group names before clearing
        CollapsedGroups := TStringList.Create;
        try
          for k := 0 to pt.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup_Lists.Count - 1 do
            if not TTSlotGrp_WKC(pt.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup_Lists[k]).m_IsExpanded then
              if CollapsedGroups.IndexOf(TTSlotGrp_WKC(pt.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup_Lists[k]).m_Group) < 0 then
                CollapsedGroups.Add(TTSlotGrp_WKC(pt.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup_Lists[k]).m_Group);

          pt.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup_Lists.Clear;
          pt.CreateWkcGroups(TabCfg.GetWorkCenterList);

          // restore collapsed state
          for k := 0 to pt.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup_Lists.Count - 1 do
            if CollapsedGroups.IndexOf(TTSlotGrp_WKC(pt.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup_Lists[k]).m_Group) >= 0 then
              TTSlotGrp_WKC(pt.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup_Lists[k]).m_IsExpanded := False;
        finally
          CollapsedGroups.Free;
        end;
      end;

      pt.p_PlanWcControl.P_planWcView.RefreshPlan(true);
    end;
  end;
end;

//----------------------------------------------------------------------------//

function CheckIfActiveGanttTabIsMcm : boolean;
var
  pt: TMqmPlanTabSheet;
  MQMPlan : TFMQMPlan;
begin
  MQMPlan := GetPlanView;
  result := MQMPlan.CheckIfActiveGanttTabIsMcm
end;

//----------------------------------------------------------------------------//


function CalcPos(date: TDateTime; calcObj: TObject): integer;
begin
  Assert(Assigned(calcObj));
  Result := TCalPanel(calcObj).TimeToPixels(date);
end;

//----------------------------------------------------------------------------//

function CalcDate(pos: integer; calcObj: TObject): TDateTime;
begin
  Assert(Assigned(calcObj));
  Result := TCalPanel(calcObj).PixelsToTime(pos);
end;

//----------------------------------------------------------------------------//

function CalcCalZoom(calcObj: TObject): Integer;
begin
  Assert(Assigned(calcObj));
  Result := TCalPanel(calcObj).Lw;
end;

//----------------------------------------------------------------------------//

function CalcWdw(isLeft: boolean; calcObj: TObject): TDateTime;
begin
  if isLeft then
    Result := TCalPanel(calcObj).LeftTime
  else
    Result := TCalPanel(calcObj).RightTime
end;

//----------------------------------------------------------------------------//

procedure CalendarOnScroll(Sender: TObject);
var
  sh: TShapeManager;
begin
  sh := TMqmPlanTabSheet(Sender).p_shapeMan;
  Assert(Assigned(sh));
  sh.ShapesUpdate
end;

//----------------------------------------------------------------------------//

procedure LogoImage(AOwner: TWinControl);
var
  image: TImage;
  tmpBmp: TBitmap;
begin
  // put an image in the logo panel
  Image := TImage.Create(AOwner);
  Image.Parent := AOwner;
  Image.Align := alClient;
  Image.Center := true;
  Image.Left := 3;
  Image.Top := 2;
  Image.Width := 100;
  Image.Height := 90;
  Image.Transparent := false;
  image.Stretch := true;
  try
    // Draw via ImageList.Draw into a pf32bit bitmap to avoid upside-down DIB issue
    tmpBmp := TBitmap.Create;
    try
      tmpBmp.PixelFormat := pf32bit;
      tmpBmp.Width  := s_FMQMPlan.ImageListBig.Width;
      tmpBmp.Height := s_FMQMPlan.ImageListBig.Height;
      s_FMQMPlan.ImageListBig.Draw(tmpBmp.Canvas, 0, 0, 13);
      Image.Picture.Bitmap.Assign(tmpBmp);
    finally
      tmpBmp.Free;
    end;
  except
  end;
end;

//----------------------------------------------------------------------------//

procedure LogoImageWc(AOwner: TWinControl);
var
  image: TImage;
  tmpBmp: TBitmap;
begin
  Image := TImage.Create(AOwner);
  Image.Parent := AOwner;
  Image.Align := alClient;
  Image.Center := true;
  Image.Left := 3;
  Image.Top := 2;
  Image.Width := 100;
  Image.Height := 90;
  Image.Transparent := false;
  image.Stretch := true;
  try
    // Draw via ImageList.Draw into a pf32bit bitmap to avoid upside-down DIB issue
    tmpBmp := TBitmap.Create;
    try
      tmpBmp.PixelFormat := pf32bit;
      tmpBmp.Width  := s_FMQMPlan.ImageListBig.Width;
      tmpBmp.Height := s_FMQMPlan.ImageListBig.Height;
      s_FMQMPlan.ImageListBig.Draw(tmpBmp.Canvas, 0, 0, 13);
      Image.Picture.Bitmap.Assign(tmpBmp);
    finally
      tmpBmp.Free;
    end;
  except
  end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.CreateNewPlan(tbCfg: TPlanTabsCfg; tabCode: integer);
var
  shCfg:  TShConfig;
  hdrCfg: TMqmHdrCfg;
  hdrCfgWc : TMqmHdrCfgWc;
  gc:     TMqmGanttConst;
  PlanTabSheet : TMqmPlanTabSheet;
begin

  // used and then released
  hdrCfg := TMqmHdrCfg.Create;
  hdrCfg.m_class     := TMqmHdrManResources;
  hdrCfg.m_rh        := HEADPANEL_HEIGHT;
  hdrCfg.m_rw        := 97;
  hdrCfg.m_LogoImage := LogoImage;
//  hdrCfg.m_LogoImageWc := LogoImageWc;
  hdrCfg.m_CalScroll := CalendarOnScroll;

  // used and then released
  shCfg := TShConfig.Create;
  shCfg.m_calcPos    := CalcPos;
  shCfg.m_calcDate   := CalcDate;
  shCfg.m_CalcCalZoom := CalcCalZoom;
  shCfg.m_calcWdw    := CalcWdw;
//shCfg.m_assProp    := GenAssProp;
  shCfg.m_mouUp      := MsUp;
  shCfg.m_mouMove    := MsMove;
  shCfg.m_mouObj     := self;
  shCfg.m_DrawHeader := DrawRes;
  shCfg.m_LeftLimit  := 0;
  shCfg.m_RightLimit := 0;
  shCfg.m_today      := @(p_pl.m_today);
  shCfg.m_todayAlgn  := @(p_pl.m_todayAlgn);
  shCfg.m_DrawLink   := LinkAssPropAndDraw;
  shCfg.m_ApprovalDate := 0;

  // acquired by the user
  gc := TMqmGanttConst.Create;
  gc.bkColor    := RGB(150,150,150);
  if DBAppSettings.DisableCapRes then
    gc.RH := ROW_HEIGHT_DIS_CAPRES
  else
    gc.RH := ROW_HEIGHT_NORM;
  gc.RW         := 97;
  gc.VO_RS      := 2;//Trunc(gc.RH*0.04*2);
  gc.OO_RS      := Trunc(gc.RH*0.04*2);

  PlanTabSheet := TMqmPlanTabSheet.CreatePlanTbs(m_pgcPlan, hdrCfg, gc,
                                 shCfg, tbCfg, tabCode);

  hdrCfgWc := TMqmHdrCfgWc.create;
  hdrCfgWc.m_LogoImage := LogoImageWc;
  hdrCfgWc.m_rw := 100;
  hdrCfgWc.m_rh := 100;

  PlanTabSheet.CreateWorkCentersPlanTbs(m_pgcPlan, hdrCfgWc, gc,
                                 shCfg, tbCfg, tabCode);
  if DBAppGlobals.MCM_App then
  begin
    StMouseDate.Visible := false;
    PlanTabSheet.p_BasePanelResources.Visible := false;
    PlanTabSheet.p_BasePanelWorkCenters.Visible := true;
  end;
//  {$ifdef MCM}
//    PlanTabSheet.p_BasePanelResources.Visible := false
// {$endif};

  shCfg.Free;
  hdrCfg.Free;
  hdrCfgWc.Free;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.CreateShapeForUpdate;
begin
  if Screen.Width < 1500 then
  begin
    toolButton1.Width := 200;

  end
  else
    toolButton1.Width := 350;

  m_ShapeUpdateAvailable := TShapeUpdate.Create(Self);
  with m_ShapeUpdateAvailable do
  begin
    Parent := TBmain;
    name := 'ShapeUpdateAvailable';
    Top := 5;
    Left := toolButton1.left + toolButton1.Width + 1;
    Width := 190;
  //  Height := 18;
  //  TabStop := False;
    shape  := stRoundRect;
    pen.color := CLwhite;
    canvas.Font.name := 'Montserrat'
  end;

  m_ShapeUpdateNow := TShapeUpdate.Create(Self);
  with m_ShapeUpdateNow do
  begin
    Parent := TBmain;
    name := 'ShapeUpdateNow';
    Top := 5;
    Left := m_ShapeUpdateAvailable.Left + m_ShapeUpdateAvailable.width + 1;
    Width := 140;
    shape  := stRoundRect;
    pen.color := Cl_STNDRD_LIGHT_BLUE;
  //  pen.Width := 2;
    Brush.color := Cl_STNDRD_LIGHT_BLUE;
    OnClick := OnClickRefreshDate;
    canvas.Font.name := 'Montserrat'
  end;

end;

//----------------------------------------------------------------------------//

function EventFromHost : boolean;
begin
  result := GetPlanView.EventCameFromHost;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.UpdateRequested(var msg: TMessage);
const
  TRY_NUMBER = 14;
var
  qry, qry2 :    TMqmQuery;
  updNum, updPropNum : integer;
  tbInfo: ^TTblInfo;
  CheckChangedForWc, CheckChangedForRes : boolean;
  hdrCode : string;
  detCode : integer;
  jobCode : integer;
  ReprocNo: integer;
  Counter : integer;
  id:      TSchedID;
  IsHeaderDetFound : boolean;
  FoundMsg, MarkMsg, WSFound : boolean;
begin
  FoundMsg := false;
  MarkMsg  := false;
  if msg.LParam <> StrToInt(IniAppGlobals.Identifier) then exit;

  if (msg.WParam = 8) and DBAppGlobals.IsWarpHandled then
  begin
    DBAppGlobals.WarpOnlyCngClientUpdate := true;
    OperateRefreshButton;
  end;

  if (msg.WParam = 3) or (msg.WParam = 4) then
  begin
    DBAppGlobals.WarpOnlyCngClientUpdate := false;
    DBAppGlobals.BalanceOnlyClientUpdate    := false;
    if (msg.WParam = 4) and DBAppGlobals.IsWarpHandled then
         DBAppGlobals.WarpCngClientUpdate := true;

    CheckChangedForWc := CheckChangedDataForWc;
    CheckChangedForRes := CheckChangedDataForRes;
    if CheckChangedForWc then
      m_HostDataWaiting := true;
    if (CheckChangedForWc or CheckChangedForRes) then
      OperateRefreshButton
    else
    begin
      if not Assigned(FAutoSched) then
        TFWait.CreateWaitForm(self, w_BalanceUpdate, nil).ShowModal
      else
      begin
        DBAppGlobals.BalanceOnlyClientUpdate := true;
        OperateRefreshButton;
      end;
    end;
  end;

  //To avoid deadlock if two istances of the same workstations are opened together
//  sleep(RandomRange(1,700));

  if (msg.WParam = 6) and not m_MyStationEvent then
  begin
    qry := CreateQuery(Main_DB);
    Qry.Transaction := CreateTransaction(Main_DB);
//    Qry.Transaction.StartTransaction;

    qry2 := CreateQuery(Main_DB);
    Qry2.Transaction := CreateTransaction(Main_DB);
 //   Qry2.Transaction.StartTransaction;

    tbInfo := @tblInfo[tbl_Job_Massages];
    with qry do
    begin
      qry.SQL.Clear;
      qry.SQL.add( 'select * from ' + tbInfo.GetTableName);
      qry.SQL.add( ' where ');
      qry.SQL.add(CreateFld(tbInfo.pfx, fli_To_WorkStation) + ' = ' + QuotedStr(IniAppGlobals.WkstCode) + ' AND ');
      qry.SQL.add(CreateFld(tbInfo.pfx, fli_JobMsgEvent) + ' = ' + QuotedStr('1'));
      qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
      qry.open;
      while not qry.EOF do
      begin
        hdrCode := qry.FieldByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString;
        detCode := qry.FieldByName(CreateFld(tbInfo.pfx, fli_pstepId)).AsInteger;
        jobCode := qry.FieldByName(CreateFld(tbInfo.pfx, fli_psubstId)).AsInteger;
        ReprocNo := qry.FieldByName(CreateFld(tbInfo.pfx, fli_reprocNo)).AsInteger;
        id := p_sc.FindProdSched(hdrCode, detCode, jobCode, ReprocNo, IsHeaderDetFound);
        if (id <> CSchedIDnull) and IsHeaderDetFound then
        begin
          qry2.SQL.Clear;
          qry2.SQL.add( 'select * from ' + tbInfo.GetTableName);
          qry2.SQL.Add(where_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)) + ' AND ');
          qry2.SQL.add(CreateFld(tbInfo.pfx, fli_Status) + ' = ' + QuotedStr('1') + ' AND ');
          qry2.SQL.add(CreateFld(tbInfo.pfx, fli_preqNo) + ' = ' + QuotedStr(hdrCode) + ' AND ');
          qry2.SQL.add(CreateFld(tbInfo.pfx, fli_pstepId) + ' = ' + IntToStr(detCode) + ' AND ');
          qry2.SQL.add(CreateFld(tbInfo.pfx, fli_psubstId) + ' = ' + IntToStr(jobCode) + ' AND ');
          qry2.SQL.add(CreateFld(tbInfo.pfx, fli_reprocNo) + ' = ' + IntToStr(ReprocNo));
          qry2.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
          qry2.open;
          if qry2.eof then
            p_sc.MarkMsgForJobGet(id, false)
          else
            p_sc.MarkMsgForJobGet(id, true);

          qry2.SQL.Clear;
          Qry2.Transaction.StartTransaction;
          qry2.SQL.Add('update ' + tbInfo.GetTableName + ' set ');
          qry2.SQL.Add(CreateFld(tbInfo.pfx, fli_JobMsgEvent)                   + '=');
          qry2.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_JobMsgEvent)             + ' ');
          qry2.SQL.Add(where_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)) + ' AND ');
          qry2.SQL.add(CreateFld(tbInfo.pfx, fli_Identifier) + ' = ' + IniAppGlobals.Identifier + ' AND ');
          qry2.SQL.add(CreateFld(tbInfo.pfx, fli_preqNo) + ' = ' + QuotedStr(hdrCode) + ' AND ');
          qry2.SQL.add(CreateFld(tbInfo.pfx, fli_pstepId) + ' = ' + IntToStr(detCode) + ' AND ');
          qry2.SQL.add(CreateFld(tbInfo.pfx, fli_psubstId) + ' = ' + IntTostr(jobCode) + ' AND ');
          qry2.SQL.add(CreateFld(tbInfo.pfx, fli_reprocNo) + ' = ' + IntTostr(ReprocNo) + ' AND ');
          qry2.SQL.add(CreateFld(tbInfo.pfx, fli_To_WorkStation) + ' = ' + QuotedStr(IniAppGlobals.WkstCode));
          qry2.ParamByName(CreateFld(tbInfo.pfx, fli_JobMsgEvent)).AsString := '0';
          qry2.ExecSQL;
          qry2.Transaction.Commit;
          FoundMsg := true;
        end;
        qry.Next;
      end;

      qry.SQL.Clear;
      qry.SQL.add( 'select * from ' + tbInfo.GetTableName);
      qry.SQL.Add(where_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)) + ' AND ');
      qry.SQL.add(CreateFld(tbInfo.pfx, fli_From_WorkStation) + ' = ' + QuotedStr(IniAppGlobals.WkstCode) + ' AND ');
      qry.SQL.add(CreateFld(tbInfo.pfx, fli_JobMsgEvent) + ' = ' + QuotedStr('1'));
      qry.open;
      while not qry.EOF do
      begin
        hdrCode := qry.FieldByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString;
        detCode := qry.FieldByName(CreateFld(tbInfo.pfx, fli_pstepId)).AsInteger;
        jobCode := qry.FieldByName(CreateFld(tbInfo.pfx, fli_psubstId)).AsInteger;
        ReprocNo := qry.FieldByName(CreateFld(tbInfo.pfx, fli_reprocNo)).AsInteger;
        id := p_sc.FindProdSched(hdrCode, detCode, jobCode, ReprocNo, IsHeaderDetFound);
        if (id <> CSchedIDnull) and IsHeaderDetFound then
        begin
          qry2.SQL.Clear;
          qry2.SQL.add( 'select * from ' + tbInfo.GetTableName);
          qry2.SQL.Add(where_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)) + ' AND ');
          qry2.SQL.add(CreateFld(tbInfo.pfx, fli_From_WorkStation) + ' = ' + QuotedStr(IniAppGlobals.WkstCode) + ' AND ');
          qry2.SQL.add(CreateFld(tbInfo.pfx, fli_Status) + ' = ' + QuotedStr('1') + ' AND ');
          qry2.SQL.add(CreateFld(tbInfo.pfx, fli_preqNo) + ' = ' + QuotedStr(hdrCode) + ' AND ');
          qry2.SQL.add(CreateFld(tbInfo.pfx, fli_pstepId) + ' = ' + IntToStr(detCode) + ' AND ');
          qry2.SQL.add(CreateFld(tbInfo.pfx, fli_psubstId) + ' = ' + IntToStr(jobCode) + ' AND ');
          qry2.SQL.add(CreateFld(tbInfo.pfx, fli_reprocNo) + ' = ' + IntToStr(ReprocNo));
          qry2.open;
          if qry2.eof then
            p_sc.MarkMsgForJobSent(id, false)
          else
            p_sc.MarkMsgForJobSent(id, true);

          qry2.SQL.Clear;
          Qry2.Transaction.StartTransaction;
          qry2.SQL.Add('update ' + tbInfo.GetTableName + ' set ');
          qry2.SQL.Add(CreateFld(tbInfo.pfx, fli_JobMsgEvent)                   + '=');
          qry2.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_JobMsgEvent)             + ' ');
          qry2.SQL.Add(where_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)) + ' AND ' );
          qry2.SQL.add(CreateFld(tbInfo.pfx, fli_preqNo) + ' = ' + QuotedStr(hdrCode) + ' AND ');
          qry2.SQL.add(CreateFld(tbInfo.pfx, fli_pstepId) + ' = ' + IntToStr(detCode) + ' AND ');
          qry2.SQL.add(CreateFld(tbInfo.pfx, fli_psubstId) + ' = ' + IntTostr(jobCode) + ' AND ');
          qry2.SQL.add(CreateFld(tbInfo.pfx, fli_reprocNo) + ' = ' + IntTostr(ReprocNo) + ' AND ');
          qry2.SQL.add(CreateFld(tbInfo.pfx, fli_To_WorkStation) + ' = ' + QuotedStr(IniAppGlobals.WkstCode));
          qry2.ParamByName(CreateFld(tbInfo.pfx, fli_JobMsgEvent)).AsString := '0';
          qry2.ExecSQL;
          qry2.Transaction.Commit;
          FoundMsg := true;
        end;
        qry.Next;
      end;

      qry.SQL.Clear;
      qry.SQL.add( 'select * from ' + tbInfo.GetTableName);
      qry.SQL.add( ' where ');
      qry.SQL.add(CreateFld(tbInfo.pfx, fli_To_WorkStation) + ' = ' + QuotedStr(IniAppGlobals.WkstCode) + ' And ');
      qry.SQL.add(CreateFld(tbInfo.pfx, fli_Status) + ' = ' + QuotedStr('1'));
      qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
      qry.open;
      while not qry.EOF do
      begin
        hdrCode := Trim(qry.FieldByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString);
        detCode := qry.FieldByName(CreateFld(tbInfo.pfx, fli_pstepId)).AsInteger;
        jobCode := qry.FieldByName(CreateFld(tbInfo.pfx, fli_psubstId)).AsInteger;
        ReprocNo := qry.FieldByName(CreateFld(tbInfo.pfx, fli_reprocNo)).AsInteger;
        id := p_sc.FindProdSched(hdrCode, detCode, jobCode, ReprocNo, IsHeaderDetFound);
        if (id <> CSchedIDnull) and IsHeaderDetFound then
        begin
          MarkMsg := true;
          break;
        end;
        qry.Next;
      end;

      if Assigned(FBin) then
      begin
        if MarkMsg then
          FBin.ActivateJobMsgButton
        else
          FBin.DeActivateRefreshButton;
        if FoundMsg then
          FBin.UpdateForChangeFilter;
      end;
    end;
    qry.Close;
    qry2.close;
    qry.Free;
    qry2.free;
  end
  else if (msg.WParam = 6) and m_MyStationEvent then
    m_MyStationEvent := false;

  if msg.WParam = 2 then
  begin
      // polling
    qry := CreateQuery(Cfg_DB);
    Qry.Transaction := CreateTransaction(Cfg_DB);
    Qry.Transaction.StartTransaction;
    tbInfo := @tblInfo[tbl_cfg_exchg_wkst];

    qry.SQL.Add('select * from ' + tbInfo.GetTableName);
    qry.SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + ' = ''' + IniAppGlobals.WkstCode + '''');
    qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
    if IniAppGlobals.DownloadTo = '0' then
      qry.SQL.Add('with rs use and keep update locks')    // <--- only db2
    else if IniAppGlobals.DownloadTo = '1' then
      qry.SQL.Add('for update');                          // lock one record - oracle

    qry.open;

    WSFound := false;
    if qry.RecordCount > 0 then
    begin
      WSFound := true;

      // Check for remote reset station signal (CEW_COUNTER = 99)
      if (not qry.FieldByName(CreateFld(tbInfo.pfx, fli_COUNTER)).IsNull) and
         (qry.FieldByName(CreateFld(tbInfo.pfx, fli_COUNTER)).AsInteger = 99) then
      begin
        qry.Close;
        Qry.Transaction.commit;
        qry.Free;
        Application.Terminate;
        exit;
      end;

      if qry.FieldByName(CreateFld(tbInfo.pfx, fli_COUNTER)).IsNull then
        Counter := 0
      else
      begin
        if qry.FieldByName(CreateFld(tbInfo.pfx, fli_COUNTER)).AsInteger = 0 then
          Counter := 1
        else
          Counter := 0;
      end;
      qry.Close;
      qry.SQL.Clear;
      qry.SQL.Add('update ' + tbInfo.GetTableName);
      qry.SQL.Add('set '    + CreateFld(tbInfo.pfx, fli_COUNTER)     + ' = ' + QuotedStr(IntToStr(Counter)));
      qry.SQL.Add('where '  + CreateFld(tbInfo.pfx, fli_wkstCode) + ' = ''' + IniAppGlobals.WkstCode + '''');
      qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
      qry.ExecSQL;
    end;
    qry.Close;
    Qry.Transaction.commit;
    qry.Free;

    if not WSFound then
      CHECK_STATION_EXIST_AND_INSERT(IniAppGlobals.WkstCode);
  end;

  if msg.WParam = 0 then
  begin
    if DBAppGlobals.MAINPLAN_Ignore_Save_Event then
    begin
      m_OtherStationDataWaiting := true;
      OperateRefreshButton;
      Exit;
    end;

    // update
    if GetPlanView <> nil then
    begin
    //  try
     // if SP_GET_ACCESS(IniAppGlobals.WkstCode, AT_Lock) then
      if GET_ACCESS(IniAppGlobals.WkstCode, AT_Lock) then
      begin
        DBAppGlobals.MAINPLAN_Ignore_Save_Event := true;
        StartUpdating;
        UpdateStatusPanel;

        qry := CreateQuery(Main_DB);
        updNum := GetLastProdSched;
        p_sc.UpdateFromDB(qry, updNum, p_pl.UpdatePlanLinkJob, nil, FMQMPlan.MainProgBar, EventFromHost);
        if not m_MyStationEvent then
        begin
          if DBAppGlobals.MCM_App then
             RefreshMcmActiveGanttTab;
          updPropNum := GetLast_PROP_PROD_PLANNER;
          if updPropNum > -1 then
             p_sc.UpdatePropFromDB(qry, updPropNum, FMQMPlan.MainProgBar, EventFromHost);
        end;

        qry.Close;
        qry.Free;
        if not m_MyStationEvent then
        begin
          updNum := GetLastCapRes;
          p_pl.UpdateStationCapRes(Main_DB, updNum);
        end;

//        RefreshCalFromDb(FMQMPlan.MainProgBar); //Refresh of the calendars
        RefreshActiveTab;

        if Assigned(FBin) and not m_MyStationEvent then
          FBin.UpdateForChangeFilter;
        UpdateStatusPanel;
        EndUpdating;
        m_MyStationEvent := false;
       // SP_END_ACCESS(IniAppGlobals.WkstCode, false);
        END_ACCESS(IniAppGlobals.WkstCode);
        DBAppGlobals.MAINPLAN_Ignore_Save_Event := false;
      end;
    //  except
    //    END_ACCESS(IniAppGlobals.WkstCode, IniAppGlobals.Curr_Date_Signed);
    //  end;
    end;
  end;

  if (msg.WParam = 7) and not m_MyStationEvent then
  begin
    updNum := GetLastSharedData;
    p_pl.UpdateSharedData(Main_DB, updNum);

    //RefreshActiveTab;
    if Assigned(FBin) then
    begin
      FBin.GetActiveView.m_BinPanel.p_Grid.p_commentText := 'Mqm_Ini';

      Fbin.RefreshGrid;
    end;

  end
  else if (msg.WParam = 7) and m_MyStationEvent then
    m_MyStationEvent := false;

  // good also for new status
  UpdateStatus;
  UpdateStatusPanel
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.PowerMessageReceived(var msg: TMessage);
begin
{
  if msg.LParam <> StrToInt(IniAppGlobals.Identifier) then exit;

  if msg.WParam in [4,5,8] then    // enter to stand by / or close
  begin
    if Assigned(Dmib.m_MainDB) then
      Dmib.m_MainDB.Connected := false;
    if Assigned(Dmib.m_CfgDB) then
      Dmib.m_CfgDB.Connected := false;
    if Assigned(Dmib.m_TempDB) then
      Dmib.m_TempDB.Connected := false;
  end;

  if msg.WParam in [6,7] then    // go out from stand by / or close
  begin
    Dmib.ConnectMainDB;
    Dmib.ConnectCFGDB;

    while not CheckServerConnection do
    begin
      sleep(1000);
      Dmib.ConnectMainDB;
      Dmib.ConnectCFGDB;
    end;

    SP_CONNECT(IniAppGlobals.WkstCode)
  end;
}
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.WMStyleChange( var msg: TMessage);
begin
  if msg.LParam <> StrToInt(IniAppGlobals.Identifier) then exit;
  if Assigned(TStyleManager.ActiveStyle) then
    TStyleManager.TrySetStyle(m_Style);
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.UpdateStatusPanel;
var
  srvLoadOn,
  canRead,
  canWrite,
  isUpdating: boolean;
begin
  GetStatus(srvLoadOn, canRead, canWrite, isUpdating);
  if srvLoadOn then
  begin
   // SrvStatus.ImageIndex := 8;
    ShServerLoad.Brush.Color := clLime
  end
  else
  begin
  //  SrvStatus.ImageIndex := 9;
    ShServerLoad.Brush.Color := clBtnFace;//clActiveBorder;
  end;

  if srvLoadOn then
    MIDownLoadFromHost.Enabled := false
  else
    MIDownLoadFromHost.Enabled := true;

{  if canRead then
    ShCanRead.Brush.Color := clLime
  else
    ShCanRead.Brush.Color := clRed;

  if canWrite then
    ShCanWrite.Brush.Color := clLime
  else
    ShCanWrite.Brush.Color := clRed;

  if isUpdating then
    ShAutoUpdate.Brush.Color := clRed
  else
    ShAutoUpdate.Brush.Color := clLime    }
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.PgcBinChange;
var
  Bintab : TBinTabSheet;
  ResList : TList;
begin
  if Assigned(fbin) then
  begin
    fbin.ChangeTabBinforChangeTabPlan;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.OpenMqmDynamicPlanforSearch(value : Variant);
var
  Bintab : TBinTabSheet;
  ResList : TList;
  Code : Integer;
begin
  if Assigned(Fbin) then
  begin
    if Fbin.GetPageCount > 0 then
    begin
      Bintab := TBinTabSheet(Fbin.GetActiveView);
      if Assigned(BinTab) and Bintab.m_BinPanel.P_BinDynamicPlan then
      begin
        ResList := TList.Create;
        Bintab.m_BinPanel.m_objList.BuildResList(ResList);
        if IsDynamicPlanOpened then
           SetDynamicMqmPlanActive(ResList, Value)
        else
        begin
          AddTabWithList(value, ResList, PDynamic,0);
          SetDynamicMqmPlanActive(ResList, Value);
        end;
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.OpenMcmDynamicPlanforSearch(PropCode : string; Value : Variant);
var
  Bintab : TBinTabSheet;
  ResList, VisResList : TList;
  Code : Integer;
  WcList : TList;
  I, iVisRes : integer;
  Res : TMqmRes;
begin
  if Assigned(Fbin) then
  begin
    if Fbin.GetPageCount > 0 then
    begin
      Bintab := TBinTabSheet(Fbin.GetActiveView);
      if Assigned(BinTab) and Bintab.m_BinPanel.P_BinDynamicPlan then
      begin
        ResList := TList.Create;
        Bintab.m_BinPanel.m_objList.BuildResList(ResList);
        if ResList.Count = 0 then exit;

        WcList := Bintab.m_BinPanel.m_objList.BuildWcList(ResList);

        VisResList := TList.Create;

        for I := 0 to ResList.Count - 1 do
        begin
          Res := TMqmRes(ResList[I]);
          for iVisRes := 0 to res.p_VisResCount -1 do
              VisResList.add(TMqmVisibleRes(res.p_VisRes[iVisRes]))
        end;

        if IsDynamicPlanOpened then
           SetDynamicMcmPlanActiv(VisResList, WcList, Propcode, value)
        else
        begin
          AddTabWithList(Value, ResList, PDynamic,0);
          SetDynamicMcmPlanActiv(VisResList, WcList, Propcode, value);
        end;
        WcList.free;
        ResList.Free;
        VisResList.Free;
        PgcMainChange(self);
      end;
    end;
  end;

end;

//----------------------------------------------------------------------------//

function GetLastProdSched : Integer;
var
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
begin
  qry := CreateQuery(Main_DB);
  tbInfo := @tblInfo[tbl_Prod_sched];

  qry.SQL.Clear;
  qry.SQL.Add('select MAX(' + CreateFld(tbInfo.pfx, fli_updCode) + ') UPD_CODE from ' + tbInfo.GetTableName);
  qry.SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.Open;

  if not qry.EOF then
    Result := qry.FieldByName('UPD_CODE').AsInteger
  else
    Result := -1;

  qry.Close;
  qry.Free;
end;

//----------------------------------------------------------------------------//

function GetLastCapRes : Integer;
var
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
begin
  qry := CreateQuery(Main_DB);
  tbInfo := @tblInfo[tbl_capRes];

  qry.SQL.Clear;
  qry.SQL.Add('select * from ' + tbInfo.GetTableName );
  qry.SQL.Add(' Where ' + CreateFld(tbInfo.pfx, fli_CapacyResrv) + '>=''' + IntToStr(0) + '''');
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  if IniAppGlobals.DownloadTo = '2' then
    qry.SQL.Add(' order by ' + CreateFld(tbInfo.pfx, fli_updCode) + ' descending')
  else
    qry.SQL.Add(' order by ' + CreateFld(tbInfo.pfx, fli_updCode) + ' DESC');
  qry.Open;

  if not qry.EOF then
    Result := qry.FieldByName(CreateFld(tbInfo.pfx, fli_updCode)).AsInteger
  else
    Result := -1;

  qry.Close;
  qry.Free;
end;

//----------------------------------------------------------------------------//

function GetLastSharedData : Integer;
var
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
begin
  qry := CreateQuery(Main_DB);
  tbInfo := @tblInfo[tbl_prod_sched_shared_data];

  qry.SQL.Clear;
  qry.SQL.Add('select * from ' + tbInfo.GetTableName );
  qry.SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  if IniAppGlobals.DownloadTo = '2' then
    qry.SQL.Add(' order by ' + CreateFld(tbInfo.pfx, fli_updCode) + ' descending')
  else
    qry.SQL.Add(' order by ' + CreateFld(tbInfo.pfx, fli_updCode) + ' DESC');
  qry.Open;

  if not qry.EOF then
    Result := qry.FieldByName(CreateFld(tbInfo.pfx, fli_updCode)).AsInteger
  else
    Result := -1;

  qry.Close;
  qry.Free;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.UpdateCaptions;
var
  i: integer;
  ts: TMqmPlanTabSheet;
  lic: TRecLicVers1;
  strErr:     string;
  licBytes : TLicMemory;
begin

  if DBAppGlobals.MCM_App then
  begin
    Caption := 'Capacity planner  -  ' + IniAppGlobals.WkstDesc;
    licBytes := s_licBytesMcm
  end
  else
  begin
    Caption := 'Scheduling  -  ' + IniAppGlobals.WkstDesc;
    licBytes := s_licBytes
  end;

  if not DecodeLicVers1(lic, licBytes, strErr) then exit;
  case lic.instType of
    INST_CUST_DEMO: Caption := Caption + _(' ** DEMO VERSION, NOT ALLOWED TO SAVE JOBS **');
         INST_DEMO: Caption := Caption + _(' ** DEMO VERSION, ALLOWED TO SAVE JUST ALREADY SCHEDULED JOBS **');
  end;

  if Assigned(FBin) then
  begin
    ReTranslateComponent(FBin);
    Fbin.RefreshGrid;
  end;

  for i := 1 to m_pgcPlan.PageCount -1 do
  begin
    ts := TMqmPlanTabSheet(m_pgcPlan.Pages[i]);
    ts.UpdateCaptions ;
  end;


end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.ResetTabs(tbCfg: TPlanTabsCfg);
var
  i: integer;
begin
  for i := 0 to tbCfg.p_GetTabsCount - 1 do
  begin
    Application.ProcessMessages;
    CreateNewPlan(tbCfg, tbCfg.GetTab(i).code);
  end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.FormCreate(Sender: TObject);
var
  Save_Cursor : TCursor;
  tbs:   TTabSheet;
  img:   TImage;
  lic:        TRecLicVers1;
  strErr:     string;
  NewItem : TMenuItem;
  I, iVisRes, x, m, y : Integer;
  pt : TMqmPlanTabSheet;
  SavedRefreshBinByButton : boolean;
  licBytes : TLicMemory;
  Res : TMqmRes;
  VisRes : TList;
  TabCfg : TPlanTabCfg;
  PlanLineGroup : TPlanLineGroup;
  PropId : TPropID;
  PropDesc : string;
begin
  TP_IgnoreClassProperty(TToolButton, 'Caption'); // prevent toolbar button reorder on language change
  TranslateComponent (self);
  //Application.HintColor := clblack;
 // Screen.HintFont.Color := clwhite;
  Screen.MenuFont.Name := 'Montserrat';

  if Screen.PixelsPerInch = 144 then
    Screen.MenuFont.size := font.Size + 2
  else
    Screen.MenuFont.size := font.Size + 1;

  Screen.MessageFont.Size := 9;
  StBarInfo.Visible := false;

  if DBAppGlobals.IsWarpHandled then
  begin
    MIShowwarpcompatible.Visible := true;
    NewTabsWarp1.Visible := true;
    CompatibleinbinWarp1.Visible := true
  end
  else
  begin
    MIShowwarpcompatible.Visible := false;
    NewTabsWarp1.Visible := false;
    CompatibleinbinWarp1.Visible := false
  end;

  if Iniappglobals.Upload_Download_disable = '2' then
  begin
    MIUPloadDownload.Visible := False;
    MIDnLoadUploadReq.Visible := False;
    MIDownloadProd.Visible := False;
  end;

  CreateShapeForUpdate;
  if IniAppGlobals.External_Database_Update = '1' then
  begin  // case of external refresh
    MIDownLoadFromHost.Visible := false;
    MIRefreshExternal.Visible := true;
    PanStatus.Visible := false;
    ShServerLoad.Visible := false;
    m_ShapeUpdateAvailable.Visible := false;
    m_ShapeUpdateNow.Visible := false
  end;

  ChangeStationpassword.Visible := false;
  if IniAppGlobals.ChangePassStation = '1' then
     ChangeStationpassword.Visible := true;

  if ParamCount > 0 then // Orta
    MiniMizedMainForm;

  s_FMQMPlan := self;

  if s_suicide then
  begin
    Close;
    exit
  end;

//  Caption := IniAppGlobals.WkstCode;
  if DBAppGlobals.MCM_App then
  begin
    licBytes := s_licBytesMcm;
    Caption := 'NOW capacity planner  -  ' + IniAppGlobals.WkstDesc
  end
  else
  begin
    licBytes := s_licBytes;
    Caption := 'NOW Scheduling  -  ' + IniAppGlobals.WkstDesc;
  end;

  MISetting.Caption := _('Settings');

  if not DecodeLicVers1(lic, licBytes, strErr) then exit;
  case lic.instType of
    INST_CUST_DEMO: Caption := Caption + _(' ** DEMO VERSION, NOT ALLOWED TO SAVE JOBS **');
         INST_DEMO: Caption := Caption + _(' ** DEMO VERSION, ALLOWED TO SAVE JUST ALREADY SCHEDULED JOBS **');
  end;

  MIResourceReport1.Visible := true;
//  TbRefreshBtn.Visible   := true;
//  MICreat.Visible        := true;
  MIShow.Visible         := true;
  MISetting.Visible      := true;
  MIVerify.Visible       := false;
//  TBLogWindow.Visible    := true;
  TBSpcLowWndw.Visible   := true;
//  TBCrtCap.Enabled       := not DBAppSettings.DisableCapRes;
  TBSpcCrtCap.Visible    := true;
//  MICrtCapRes.Enabled    := not DBAppSettings.DisableCapRes;
  MIApaCrtCapRes.Enabled := not DBAppSettings.DisableCapRes;

  MIPrint.Visible := False;
  MILabel.Visible := False;
  MIRoll.Visible  := False;
  MIProd.Visible  := False;

  MiDashboard.Visible := false;

{$ifdef DEMO}
  MiDashboard.Visible := true;
{$endif}


//  TbRefreshBtn.Enabled := false;
  m_RefreshDate := false;
  m_ListAutoRunSetInfo := TList.Create;

  MainProgBar := TMqmProgBar.Create(self);
  with MainProgBar do
  begin
    Parent := PnlProgBar;
    Align  := AlClient;
    Enabled := false;
//    Top := -2;
//    Left := ToolButton5.Left + ToolButton5.Width;
//    Width := 140;
//    Height := 26;
    TickStyle := tsNone;
   // SliderVisible := false;
  end;
  Application.ProcessMessages;

 // SetComponent(StMouseDate, comp_Descr, false);
  Save_Cursor   := Screen.Cursor;
  Screen.Cursor  := crAppStart; //SQLWait;

  Assert(p_pl <> nil);

//  s_MsgHandle := Handle;
  s_MsgHandle := AllocateHWnd(WndProc);

  // create the plan page control
  m_pgcPlan := TMViewPage.Create(self, Vt_Gantt);
  m_pgcPlan.Images := ImageList1;

  m_pgcPlan.Align := alClient;

  // create the main tab
  tbs := TTabSheet.Create(m_pgcPlan);
  tbs.PageControl := m_pgcPlan;
  tbs.TabVisible := false;

  img := TImage.Create(m_pgcPlan);
  img.Picture := TPicture.Create;
  img.Parent := m_pgcPlan;
  img.Align := alClient;

  img.Picture.LoadFromFile(LocAppGlobals.AppDir + LocAppGlobals.ImgDir + '\PageEmpty.jpg');
  img.Stretch := true;
  img.Visible := true;
  LoadAutoRunSetFromDB;
  LoadDefaultBinTabsSet;
  LoadDefaultMatBinTabsSet;

  LoadBarDataFromDB();
  LoadWkcSetsFromDB();
  LoadGroupByFieldFromDB;
  LoadPropShowColorData;
  LoadCustomDateColumnInfo;
  LoadCustomDateGapColumnInfo;
  SetDynamicSubMenuForShowColor;
  // Builds the default resources list
  m_planTbCfg := TPlanTabsCfg.CreatePlanTbs(p_pl);
  if m_planTbCfg.LoadFromDatabase then ResetTabs(m_planTbCfg);
  m_pgcPlan.OnChange := pgcMainChange;

  m_pgcPlan.MultiLine := DBAppSettings.GanttMultiLineTab;

  if DBAppGlobals.MCM_App then
    SetPropertyListToPopUpwc
  else
  begin
    WorkCenterCap.Visible := false;
    MiSlotFilterTab.Visible := false;
    SetPropertyListToPopUpwc
  end;

  if not Assigned(FBin) then
  begin
    FBin := TFBin.Create(self);
    FBin.AddPropCodeForPropColumTabs;
    CheckChangedProperties;
    Fbin.OrganizeDefaultTabForNewPropSet;
    Fbin.OrganizeTabsForNewPropSet;
    FBin.Show
  end;

  // use values from AppG lobals to determine form position and size
  // These lines must be in the end of the function

  if ((DBAppGlobals.WdwPlanLeft + DBAppGlobals.WdwPlanwidth) > screen.DesktopWidth)
   or ((DBAppGlobals.WdwPlantop + DBAppGlobals.WdwPlanheight) > screen.DesktopHeight) then
  begin
    DBAppGlobals.WdwPlanLeft := 0;
    DBAppGlobals.WdwPlanTop := 0;
    DBAppGlobals.WdwPlanWidth := screen.Width - 200;
    DBAppGlobals.WdwPlanHeight := screen.Height - 100;
  end;

  self.Left   := DBAppGlobals.WdwPlanLeft;
  self.top    := DBAppGlobals.WdwPlantop;
  self.width  := DBAppGlobals.WdwPlanwidth;
  self.height := DBAppGlobals.WdwPlanheight;

  if DBAppglobals.WdwPlanState then WindowState := wsmaximized;

  UpdateStatus;
  UpdateStatusPanel;

  if GetListCountForAutoRunSet = 0 then
    MiAutomaticOperation.Visible := false
  else
    SetDynamcMenuForAutoRunCodes;

  if UpdateJobMsgFromDB(nil,nil,false) and Assigned(FBin) then
     FBin.ActivateJobMsgButton;

  Screen.Cursor := Save_Cursor;

  if DBAppGlobals.ShowColorJobMode = PreDefinedPropList then
  begin
    if (GetIdFromCode(DBAppGlobals.LastPropColorInUseJobMode) <> nil) then
    begin
      NewItem := TMenuItem.Create(Self);
      NewItem.VCLComObject := GetIdFromCode(DBAppGlobals.LastPropColorInUseJobMode);
      ClickShowBarColorfromPropList(NewItem);
    end
    else
    begin
      DBAppGlobals.ShowColorJobMode := Standard;
      MiSchedulestatus.Checked := true;
    end;
  end
  else if DBAppGlobals.ShowColorJobMode = DinamicPropList then
  begin
    if (GetIdFromCode(DBAppGlobals.LastPropColorInUseJobMode) <> nil) then
    begin
      NewItem := TMenuItem.Create(Self);
      NewItem.VCLComObject := GetIdFromCode(DBAppGlobals.LastPropColorInUseJobMode);
      ClickShowBarColorDynamic(NewItem);
    end
    else
    begin
      DBAppGlobals.ShowColorJobMode := Standard;
      MiSchedulestatus.Checked := true;
    end;
  end
  else
  begin
    MiSchedulestatus.Checked := true;
  end;

  SavedRefreshBinByButton := DBAppSettings.RefreshBinByButton;
  DBAppSettings.RefreshBinByButton := false;

   PgcMainChange(self);

  DBAppSettings.RefreshBinByButton := SavedRefreshBinByButton;

  if DBAppGlobals.MCM_App then
  begin

    if (m_pgcPlan.PageCount > 1) then
    begin
      if IniAppGlobals.CBForceMqmScheduleDetails = '1' then
        p_pl.RescheduledMcmListOfIds(GetPlanView)
      else
        Fbin.AutoSequencingReScheduleMcmJobs(true);
    end;

    VisRes := TList.Create;
    for I := 0 to p_pl.p_Rescount - 1 do
    begin
      Res := TMqmRes(p_pl.p_ResList[I]);
      for iVisRes := 0 to res.p_VisResCount -1 do
        VisRes.add(TMqmVisibleRes(res.p_VisRes[iVisRes]))
    end;

    p_pl.BuildWkcDailyCapacity(VisRes, SplashForm.ProgBar, TStaticText(SplashForm.StStatus));

    for i := m_pgcPlan.PageCount -1 downto 1 do
    begin
      pt := TMqmPlanTabSheet(m_pgcPlan.Pages[i]);
      TabCfg := TPlanTabCfg(m_planTbCfg.FindTab(pt.GetCode));
      pt.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup_Lists.Clear;
      if TabCfg.m_SlotGroup > 0 then
        pt.CreateWkcGroups(TabCfg.GetWorkCenterList);

      // restore saved MCM per-WC slot/wkc second-level settings and expand state
      if not Assigned(TabCfg.McmTabConfig) then continue;
      if TabCfg.McmTabConfig.Count = 0 then continue;

      // PASS 1: restore property codes, second-level types, and group expand states
      for x := 0 to pt.p_PlanWcControl.P_planWcView.p_pShot.p_numSons - 1 do
      begin
        PlanLineGroup := TPlanLineGroup(pt.p_PlanWcControl.P_planWcView.p_pShot.p_son[x]);
        if PlanLineGroup.P_WrkCtr = nil then break;

        for m := 0 to TabCfg.McmTabConfig.Count - 1 do
        begin
          if TTMcmTabConfig(TabCfg.McmTabConfig[m]).Wkc <> PlanLineGroup.P_WrkCtr then continue;

          if PlanLineGroup.p_son[0] is TPlanLineWCGroup then
          begin
            // slot-level grouping: restore property code and expanded flag
            if TTMcmTabConfig(TabCfg.McmTabConfig[m]).SlotSndLvl <> '' then
            begin
              PropId := GetIdFromCode(TTMcmTabConfig(TabCfg.McmTabConfig[m]).SlotSndLvl);
              if Assigned(PropId) then
                PropDesc := GetPropDescr(PropId)
              else
                PropDesc := '';
              PlanLineGroup.p_PropCode       := TTMcmTabConfig(TabCfg.McmTabConfig[m]).SlotSndLvl;
              PlanLineGroup.p_PropDesc       := PropDesc;
              PlanLineGroup.p_SecondLevelType := lvl_property;
            end;

            // apply expand state to ALL p_SlotGroup_Lists entries for this group
            if TTMcmTabConfig(TabCfg.McmTabConfig[m]).IsSlotExpanded = 0 then
              for y := 0 to pt.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup_Lists.Count - 1 do
                if TTSlotGrp_WKC(pt.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup_Lists[y]).m_Group
                   = TPlanLineWCGroup(PlanLineGroup.p_son[0]).m_Group_name then
                  TTSlotGrp_WKC(pt.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup_Lists[y]).m_IsExpanded := False;
          end
          else
          begin
            // WC-level second-row: restore category/property type (expand applied in pass 2)
            if TTMcmTabConfig(TabCfg.McmTabConfig[m]).WkcSndLvl <> '' then
            begin
              if TTMcmTabConfig(TabCfg.McmTabConfig[m]).WkcSndLvl = 'wkcat' then
                PlanLineGroup.p_SecondLevelType := Lvl_Wc_category
              else
              begin
                PropId := GetIdFromCode(TTMcmTabConfig(TabCfg.McmTabConfig[m]).WkcSndLvl);
                if Assigned(PropId) then
                  PropDesc := GetPropDescr(PropId)
                else
                  PropDesc := '';
                PlanLineGroup.p_PropCode        := TTMcmTabConfig(TabCfg.McmTabConfig[m]).WkcSndLvl;
                PlanLineGroup.p_PropDesc        := PropDesc;
                PlanLineGroup.p_SecondLevelType := lvl_property;
              end;
            end;
          end;

          break; // found and applied — move to next pShot line
        end;
      end;

      // rebuild second-level rows (property/category sub-breakdown) from restored settings
      pt.RefreshMcmMcmSecondLvl;

      // PASS 2: restore expand state for sub-rows (now exist after RefreshMcmMcmSecondLvl)
      for x := 0 to pt.p_PlanWcControl.P_planWcView.p_pShot.p_numSons - 1 do
      begin
        PlanLineGroup := TPlanLineGroup(pt.p_PlanWcControl.P_planWcView.p_pShot.p_son[x]);
        if PlanLineGroup.P_WrkCtr = nil then break;

        if PlanLineGroup.p_son[0] is TPlanLineWCGroup then
        begin
          // group-level: restore property sub-row visibility from IsSlotExpanded
          if (PlanLineGroup.p_SecondLevelType <> Lvl_non) and
             (PlanLineGroup.p_numSons > 1) and
             (PlanLineGroup.p_son[1] is TPlanLineSecondLevel) then
          begin
            for m := 0 to TabCfg.McmTabConfig.Count - 1 do
            begin
              if TTMcmTabConfig(TabCfg.McmTabConfig[m]).Wkc <> PlanLineGroup.P_WrkCtr then continue;
              for y := 1 to PlanLineGroup.p_numSons - 1 do
                TPlanLineSecondLevel(PlanLineGroup.p_son[y]).p_shownAsSubLevel :=
                  TTMcmTabConfig(TabCfg.McmTabConfig[m]).IsSlotExpanded = 1;
              break;
            end;
          end;
          continue;
        end;

        // WC-level: restore p_shownAsSubLevel from IsWkcExpanded
        for m := 0 to TabCfg.McmTabConfig.Count - 1 do
        begin
          if TTMcmTabConfig(TabCfg.McmTabConfig[m]).Wkc <> PlanLineGroup.P_WrkCtr then continue;

          if (PlanLineGroup.p_numSons > 1)
             and (PlanLineGroup.p_son[1] is TPlanLineSecondLevel) then
            TPlanLineSecondLevel(PlanLineGroup.p_son[1]).p_shownAsSubLevel :=
              TTMcmTabConfig(TabCfg.McmTabConfig[m]).IsWkcExpanded = 1;

          break;
        end;
      end;
    end;

  end;

  TBSave.enabled := true;

  m_ClientConnected := true;

  TimerConnectionCheck.Enabled := false;
  m_ConnectionRepairedetails := TStringlist.Create;
{  if IniAppGlobals.ClientConnectionCheck = '1' then  // Avi 20.05.2025 - thread connection will not be in used anymore
  begin                                               // Network exception will be catch in CommunicationException below
    TimerConnectionCheck.Interval := 6000;//6 second
    TimerConnectionCheck.Enabled := true;
  end; }

  m_ResPopupList := TStringlist.Create;
  m_ActAreaPopupList := TStringlist.Create;
  m_GroupPopupList := TStringlist.Create;
  m_JobPopupList := TStringlist.Create;

  if not DBAppGlobals.MCM_App then
    GeneratePopupMenus;
  IniAppGlobals.MainFormCreated := true;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var a  : TPlanWcView;
var pt : TMqmPlanTabSheet;
begin

  if m_MainX = 1 then //Can move select
  begin
    if DBAppGlobals.MCM_App then
    begin
      SetSelectionSlotOnActiveTab;
      if Assigned(m_SelectedListWrkCtrPopUp) and (m_SelectedListWrkCtrPopUp.Count = 1) then
      begin
        pt := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
        if Assigned(pt) then
        begin
          a := pt.p_PlanWcControl.P_planWcView ;
          a.SelectNew(Key);
        end;
      end;
    end;
  end;
end;

procedure TFMQMPlan.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin

end;

//----------------------------------------------------------------------------//

function TFMQMPlan.CheckChangedDataForWc : boolean;
var
  qry:    TMqmQuery;
  tbWcChange : ^TTblInfo;
  NewLastUpdatNr : Integer;
begin
  Result := false;
  NewLastUpdatNr := -1;
  tbWcChange := @tblInfo[tbl_wkc_Change];
  qry := CreateQuery(Main_DB);
  sleep(1000);
  // load the Last updated number for the request changed table

  with qry do
  begin
    SQL.Clear;
    SQL.Add('select ' + CreateFld(tbWcChange.pfx, fli_wkCtrCode) + ',' + CreateFld(tbWcChange.pfx,fli_updCode));
    SQL.Add(' from ' + tbWcChange.GetTableName);
    Sql.Add(' where ' + CreateFld(tbWcChange.pfx, fli_wkCtrCode) + '=' + QuotedStr('_ _'));
    SQL.Add(AND_IDF_Condition(CreateFld(tbWcChange.pfx, fli_Identifier)));
    Sql.Add(' Order by');
    Sql.Add(' ' + CreateFld(tbWcChange.pfx, fli_updCode));
    if (IniAppGlobals.downloadTo = '0') or (IniAppGlobals.DownloadTo = '1') then
      Sql.Add(' desc')
    else
      Sql.Add(' descending');
    Open;
    Application.ProcessMessages;
    while not EOF do
    begin
      NewLastUpdatNr := FieldByName(CreateFld(tbWcChange.pfx, fli_updCode)).AsInteger;
      break;
      Application.ProcessMessages;
    end;
    qry.close;

    SQL.Clear;
    Sql.Add('select * from ' + tbWcChange.GetTableName);
    Sql.Add(' where ' + CreateFld(tbWcChange.pfx, fli_updCode) + '>' + IntToStr(DBAppGlobals.LastUpdatNr));
    Sql.Add(' and   ' + CreateFld(tbWcChange.pfx, fli_updCode) + '<=' + IntToStr(NewLastUpdatNr));
    Sql.Add(' and   ' + CreateFld(tbWcChange.pfx, fli_wkCtrCode)  + '<>' + QuotedStr('_ _'));
    SQL.Add(AND_IDF_Condition(CreateFld(tbWcChange.pfx, fli_Identifier)));
    SQL.Add(' order by ' + CreateFld(tbWcChange.pfx, fli_updCode));
    Open;
    Application.ProcessMessages;
    while not qry.Eof do
    begin
      if (p_pl.FindWrkCtrByCode(FieldByName(CreateFld(tbWcChange.pfx, fli_wkCtrCode)).AsString) = nil) then
        Next
      else
      begin
      //  DBAppGlobals.LastUpdatNr :=  must be updated with the number , avi
        qry.Close;
        qry.Free;

        Result := true;
        Exit;
      end;
    end;
  end;
  qry.Close;
  qry.Free;
end;

//----------------------------------------------------------------------------//

function TFMQMPlan.CheckChangedDataForRes : boolean;
var
  qry:    TMqmQuery;
  tbRscChange : ^TTblInfo;
begin
  Result := false;
  tbRscChange := @tblInfo[tbl_Rsc_Change];
  qry := CreateQuery(Main_DB);

  // load the Last updated number for the request changed table

  with qry do
  begin
    SQL.Clear;
    SQL.Add('select ' + CreateFld(tbRscChange.pfx,fli_rsc) + ',' + CreateFld(tbRscChange.pfx,fli_updCode));
    SQL.Add(' from ' + tbRscChange.GetTableName);
    SQL.Add(' where ' + CreateFld(tbRscChange.pfx,fli_updCode) + '>' + IntToStr(DBAppGlobals.LastUpdatCapResNr));
    SQL.Add(AND_IDF_Condition(CreateFld(tbRscChange.pfx, fli_Identifier)));
    SQL.Add(' order by ' + CreateFld(tbRscChange.pfx,fli_updCode));
    Open;

    while not Eof do
    begin
      if (p_pl.FindResByCode(FieldByName(CreateFld(tbRscChange.pfx, fli_rsc)).AsString) = nil) then
        Next
      else
      begin
        qry.Close;
        qry.Free;

        Result := true;
        Exit;
      end;
    end;
  end;
  qry.Close;
  qry.Free
end;

//----------------------------------------------------------------------------//

function TFMQMPlan.MoveAllowed(Obj: TMqmDurObj): boolean;
begin
  Result := true
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.NewTabsWarp1Click(Sender: TObject);
begin
  TFConfigBin.CreateCfgBin(Self, Tb_defaultWarp).ShowModal;
  SaveDefaultTabBinMatSet;
end;

procedure TFMQMPlan.NiNewtabsClick(Sender: TObject);
begin
  TFConfigBin.CreateCfgBin(Self, Tb_default).ShowModal;
  SaveDefaultTabBinSet;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.RefreshActiveTab;
var
  sh: TShapeManager;
  pt: TMqmPlanTabSheet;

  ActTab : TBinTabSheet;
  ActBinGrid: TBinDrawGrid;
begin
  Assert(Assigned(m_pgcPlan));
  pt := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
  if not Assigned(pt) then exit;

  if Assigned(FBin) then
  begin
    ActTab := FBin.GetActiveView;
    if not Assigned(ActTab) then
      Exit;

    if DBAppSettings.RefreshBinByButton then
       ActTab.m_BinPanel.RefreshGrid;

    ActbinGrid := ActTab.GetBinGrid;
    ActbinGrid.GrdTopLeftChanged(self);
  end;

  sh := pt.p_shapeMan;
  if Assigned(sh) then sh.Update;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.EnterCompatModeInPlan(id: TSchedId);
var
  i:  integer;
  ts: TMqmPlanTabSheet;
begin
  p_pl.EnterCompatModeInPlan(id);

  if DBAppGlobals.OrganizeJobsAfterDoday then exit;

  if AutoSchedCfg.m_GraphOnMove or not Assigned(FAutoSched) then
    for i := 1 to m_pgcPlan.PageCount -1 do
    begin
      ts := TMqmPlanTabSheet(m_pgcPlan.Pages[i]);
      ts.EnterCompatMode(id)
    end
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.FocusAllTbsOnDate(date: TDateTime);
var
  i:  integer;
  ts: TMqmPlanTabSheet;
begin
  for i := 1 to m_pgcPlan.PageCount -1 do
  begin
    ts := TMqmPlanTabSheet(m_pgcPlan.Pages[i]);
    ts.FocusOnDate(date)
  end
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.FocusAllTbsOnID(Id: TSchedId);
var
  i:  integer;
  ts: TMqmPlanTabSheet;
  VisRes: TMqmVisibleRes;
  Line: integer;
  DatesInfo: TSQDatesInfo;
//  sh: TShapeManager; // avi
begin
  VisRes := TMqmVisibleRes(TMqmActArea(p_sc.GetExtLinkPtr(id)).p_Father);
  for i := 1 to m_pgcPlan.PageCount -1 do
  begin
    ts := TMqmPlanTabSheet(m_pgcPlan.Pages[i]);
    Line := ts.p_ganttPanel.GetRowIndex(VisRes);
    if (Line = -1) then
      continue;
    if Line > 0 then
      ts.FocusOnLine(Line);
    p_sc.GetDatesInfo(id, DatesInfo);
    ts.FocusOnDate(DatesInfo.startDate);
// avi
//    sh := TShapeManager(ts.p_shapeMan);
//    sh.SetScrolbar(Line);
  end
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.FocusMatOnPlan(Id: TSchedId);
var
  ts: TMqmPlanTabSheet;
  VisRes: TMqmVisibleRes;
  Line: integer;
  DatesInfo: TSQDatesInfo;
  Warp : TMqmWarp;
  MqmActArea : TMqmActArea;
begin
  Assert(Assigned(m_pgcPlan));

  ts := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
  if not Assigned(ts) then exit;

  MqmActArea := p_sc.GetExtLinkPtr_Material(ID);
  Warp := TMqmWarp(MqmActArea.GetWarpFromId(id));
  if not assigned(Warp) then exit;

  VisRes := TMqmVisibleRes(MqmActArea.p_Father);
  Line := ts.p_ganttPanel.GetRowIndex(VisRes);

  if (Line = -1) then
    showmessage(_('Warp is not on active Gantt'))
  else
  begin
    if Line > -1 then
      ts.FocusOnLine(Line);
    ts.FocusOnDate(TMqmDurObj(Warp).p_start);
  end
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.FocusOnPlan(Id: TSchedId);
var
  ts: TMqmPlanTabSheet;
  VisRes: TMqmVisibleRes;
  Line: integer;
  DatesInfo: TSQDatesInfo;
begin
  Assert(Assigned(m_pgcPlan));
  VisRes := TMqmVisibleRes(TMqmActArea(p_sc.GetExtLinkPtr(id)).p_Father);
  ts := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
  if not Assigned(ts) then exit;
  Line := ts.p_ganttPanel.GetRowIndex(VisRes);
  if (Line = -1) then
    showmessage(_('Job not on active Gantt'))
  else
  begin
    if Line > -1 then
      ts.FocusOnLine(Line);
    p_sc.GetDatesInfo(id, DatesInfo);
    ts.FocusOnDate(DatesInfo.startDate);
//    sh := TShapeManager(ts.p_shapeMan);
//    sh.SetScrolbar(Line)
  end
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.FocusOnDate(VisRes : TMqmVisibleRes ; JobId : TSchedId);
var
  ts : TMqmPlanTabSheet;
  DatesInfo: TSQDatesInfo;
begin
  ts := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
  p_sc.GetDatesInfo(JobId, DatesInfo);
  if Assigned(ts) then
    ts.FocusOnDate(DatesInfo.startDate);
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.ExitCompatModeInPlan;
var
  i:  integer;
  ts: TMqmPlanTabSheet;
begin
  if not DBAppGlobals.OrganizeJobsAfterDoday then
  if AutoSchedCfg.m_GraphOnMove or not Assigned(FAutoSched) then
    for i := 1 to m_pgcPlan.PageCount -1 do
    begin
      ts := TMqmPlanTabSheet(m_pgcPlan.Pages[i]);
      ts.ExitCompatMode
    end;

  p_pl.ExitCompatModeInPlan
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.SBarSetSchedObj(Param: PTRowParms);
var
  planInfo: TSQplanInfo;
  isGroup: boolean;
  ErrSet: SetOfErrors;
  DummyList : TList;
  pId: TSchedID;
  VisRes : TMqmVisibleRes;
  QtyAtDate : currency;
  UM : string;
  Mult : integer;
  pt : TMqmPlanTabSheet;
  StBarInfo : TStatusBar;
  ActArea  : TMqmActArea;
  TimeOfFamilyBeforeId : double;
begin
  pId := TSchedID(Param.objPtr);
  p_sc.GetPlanInfo(pId, planInfo);
  if not planInfo.isOnPlan then exit;
//  if GetOccMoveForm <> nil then exit;
  DummyList := nil;

//  if ((p_sc.IsProgressed(pId) <> prg_none) and (p_sc.IsProgressed(pId) <> prg_General)) then
//      Exit;
  pt := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
  StBarInfo := pt.p_HeaderMan.m_StBarInfo;

  StBarInfo.Panels.Items[0].Text := p_sc.GetObjBarText(pId, isGroup, false,0);
  Screen.Cursor := crHandPoint;
 // if Screen.Width > 1500 then

 // DevSB.panels.items[0].Width := 220;
  //DevSB.panels.items[0].text := mouObj.ClassName + ' | ' + mouObj.ClassParent.ClassName;


  VisRes := TMqmVisibleRes(TMqmActArea(p_sc.GetExtLinkPtr(pId)).p_Father);
  if (p_sc.GetLearningCurveCode(pId) <> '') then
  begin
    ActArea := p_sc.GetExtLinkPtr(pId);
    TimeOfFamilyBeforeId := ActArea.GetDurationOfAllJobsBeforeThisSpot(planInfo.startDate, pId);
    QtyAtDate := CalculateJobQuantityInBucket(pId, planInfo.startDate, m_MouseDate, 0, TimeOfFamilyBeforeId)
  end
  else
    QtyAtDate := p_sc.GetJobQtyAtDate(PId, VisRes, m_MouseDate);
  if QtyAtDate > 0 then
  begin
    Um := planInfo.prodUMCode;  //p_sc.GetFldDescr(pid, CSC_WeightUM);
    //StBarInfo.Panels.Items[1].Text := _('Quantity') + ' : ' + floattostr(QtyAtDate);

    if (iniAppGlobals.NumOfDecJobQtyOnStatusBar = '0') then
      Mult := 1
    else if (iniAppGlobals.NumOfDecJobQtyOnStatusBar = '1') then
      Mult := 10
    else
      Mult := 100;

    QtyAtDate := trunc(QtyAtDate*Mult)/Mult;
    StBarInfo.Panels.Items[2].Text := FloatToStr(QtyAtDate) + '' + um + '    ';
  end;
  StBarInfo.Panels.Items[4].Text := DateTimeToStr(planInfo.startDate);
  StBarInfo.Panels.Items[5].Text := DateTimeToStr(planInfo.endDate);

  errSet := [];
  p_sc.CheckErrors(pId, CSEG_All, errSet, DummyList);
//  StBarInfo.Panels.Items[2].Text := GetErrorDesc(errVal);

  StBarInfo.Panels.Items[6].Text := GetErrorDesc(GetWorstError(errSet));

  if StBarInfo.Panels.Items[6].Text = '0' then
    StBarInfo.Panels.Items[6].Text := '';

  if param.suppVal1 <> -1 then
  begin
    StBarInfo.Panels.Items[3].Text := _('Case before:') + ' ' + IntToStr(param.suppVal2);
    StBarInfo.Panels.Items[4].Text := _('Case after:') + ' ' + IntToStr(param.suppVal1);
  end;

  var Koef :=  StBarInfo.Font.size;
  var gape := Trunc(Koef * 2.7);

  if Koef > 10 then
    Gape := 100
  else
    Gape := 30;

  if Length(Trim(StBarInfo.Panels.Items[0].Text)) * Koef < 750 then
    StBarInfo.Panels.Items[0].Width := 770
  else
    StBarInfo.Panels.Items[0].Width := Length(Trim(StBarInfo.Panels.Items[0].Text)) * Koef - gape - 20; //+ 20;

  if Length(Trim(StBarInfo.Panels.Items[1].Text)) = 0 then
    StBarInfo.Panels.Items[1].Width := 4
  else
    StBarInfo.Panels.Items[1].Width := Length(Trim(StBarInfo.Panels.Items[1].Text)) * Koef;

  StBarInfo.Panels.Items[2].Width := Length(Trim(StBarInfo.Panels.Items[2].Text)) * Koef + 17;//270;

  if Length(Trim(StBarInfo.Panels.Items[3].Text)) = 0 then
    StBarInfo.Panels.Items[3].Width := 4
  else
    StBarInfo.Panels.Items[3].Width := Length(Trim(StBarInfo.Panels.Items[3].Text)) * Koef;

  StBarInfo.Panels.Items[4].Width := Length(Trim(StBarInfo.Panels.Items[4].Text)) * Koef +17;//270;
  StBarInfo.Panels.Items[5].Width := Length(StBarInfo.Panels.Items[5].Text) * Koef + 10;
  StBarInfo.Panels.Items[6].Width := Length(Trim(StBarInfo.Panels.Items[6].Text)) * Koef + 5;

//  StBarInfo.Panels.Items[2].Text := 'Dur: ' + FloatToStr(planInfo.exeMin);
//  StBarInfo.Panels.Items[3].Text := 'End: ' + DateTimeToStr(planInfo.endDate);
//  StBarInfo.Panels.Items[4].Text := 'Qty: ' + FloatToStr(planInfo.quant);

  // Show as transparent hint if user enabled the option
  if IniAppGlobals.ShowStatusBarAsHint then
  begin
    var HintText: string := StBarInfo.Panels.Items[0].Text;
    if Trim(StBarInfo.Panels.Items[2].Text) <> '' then
      HintText := HintText + #13#10 + _('Qty') + ': ' + Trim(StBarInfo.Panels.Items[2].Text);
    HintText := HintText + #13#10 + _('Start') + ': ' + StBarInfo.Panels.Items[4].Text;
    HintText := HintText + #13#10 + _('End') + ': ' + StBarInfo.Panels.Items[5].Text;
    if Trim(StBarInfo.Panels.Items[6].Text) <> '' then
      HintText := HintText + #13#10 + _('Warning') + ': ' + StBarInfo.Panels.Items[6].Text;

    Application.HintColor := RGB(60, 120, 200);  // Nice blue
    Screen.HintFont.Color := clWhite;
    Screen.HintFont.Name := 'Segoe UI';
    Screen.HintFont.Size := 9;
    pt.Hint := HintText;
    pt.ShowHint := True;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.SBarSetPlanObj(obj: TMqmPlanObj);
var
  pt : TMqmPlanTabSheet;
  StBarInfo : TStatusBar;
  R: TRect;
  P: TPoint;
  FieldVal : Variant;
  dataType: CBinColValType;
begin
  pt := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
  StBarInfo := pt.p_HeaderMan.m_StBarInfo;
  StBarInfo.Font.Name := 'Montserrat';

  pt.ShowHint := False;
  Screen.Cursor := crDefault;

  if obj is TMqmVisibleRes then
  begin
    StBarInfo.Panels.Items[0].Text := _('Resource:') + ' ' + TMqmRes(obj.p_father).p_ResCode;

    if TMqmVisibleRes(obj).p_SubCode <> -1 then
    begin
      if TMqmVisibleRes(obj).p_SubCode = 1 then
        Screen.Cursor := crHandPoint
      else
        Screen.Cursor := crDefault;

      StBarInfo.Panels.Items[1].Text := _('Sub res.:') + ' ' + IntToStr(TMqmVisibleRes(obj).p_SubCode);
    end else
    begin
//      StBarInfo.Panels.Items[0].Text := 'Resource'
    end;
  end
  else
  begin

    if obj is TMqmActArea then
    begin
      // useless information currently is commented
     //tBarInfo.Panels.Items[0].Text := _('Active planning area');
     //tBarInfo.Panels.Items[2].Text := ' ' +  DateTimeToStr(TMqmActArea(obj).p_Start);
     //tBarInfo.Panels.Items[4].Text := ' ' +  DateTimeToStr(TMqmActArea(obj).p_End);
    end
    else
    begin
      if (obj is TMqmCapRes) then
      begin
        Screen.Cursor := crHandPoint;
        StBarInfo.Panels.Items[2].Text :=  DateTimeToStr(TMqmCapRes(obj).p_Start);
        StBarInfo.Panels.Items[4].Text :=  DateTimeToStr(TMqmCapRes(obj).p_End);
        StBarInfo.Panels.Items[5].Text := _('Dur:') + ' ' + FloatToStr(TMqmCapRes(obj).p_dur);

        if (TMqmCapRes(obj).m_Type = cr_Normal) or (TMqmCapRes(obj).m_Type = Cr_Dynamic) then
        begin
          //StBarInfo.Panels.Items[0].Text := _('Capacity reservation:') + ' ' + DBAppGlobals.CapResColors[TMqmCapRes(obj).m_ColorIndex].Dsc;
          StBarInfo.Panels.Items[0].Text := _('Capacity reservation ') + ' ' + TMqmCapRes(obj).m_Dsc;
        end
        else
        begin
          if (TMqmCapRes(obj).m_Type = cr_DownTime) or (TMqmCapRes(obj).m_Type = Cr_CrossingDtm) then
          begin
            //StBarInfo.Panels.Items[0].Text := _('Downtime: ') + IntToStr(TMqmCapRes(obj).p_CapResNum);
            StBarInfo.Panels.Items[0].Text := TMqmCapRes(obj).m_Comment;
          end
        end;//Capres
      end
      else
      begin
        if (obj is TMqmCmp ) then
        begin
          Screen.Cursor := crHandPoint;
          StBarInfo.Panels.Items[0].Text := _('Capacity reservation to occupation case:')+ ' ' + inttostr(TMqmCmp(obj).m_diffVal);
        end; //Cmp

        ShowHint := False;
        if (obj is TMqmWarp) then
        begin
          Screen.Cursor := crHandPoint;
          pt.ShowHint :=  True;
          var H := '';

          p_sc.GetFldValue(TMqmWarp(obj).Get_M_id, CSC_Mat_PRODUCT_CODE, FieldVal, dataType);
          H := 'Product code: ' + FieldVal;

          p_sc.GetFldValue(TMqmWarp(obj).Get_M_id, CSC_Mat_Item_Type, FieldVal, dataType);
          H := H + char(13) +  'Item type: ' + FieldVal;

          p_sc.GetFldValue(TMqmWarp(obj).Get_M_id, CSC_Mat_Detail_Code, FieldVal, dataType);
          H := H + char(13) +  'Material Code: ' + FieldVal;

          p_sc.GetFldValue(TMqmWarp(obj).Get_M_id, CSC_Mat_MATERIAL_CODE_SUB_DET, FieldVal, dataType);
          H := H + char(13) + 'Material sub code: ' + FieldVal;


          pt.Hint := H;

        end;
      end;
    end;


    if StBarInfo.Panels.Items[6].Text = '0' then
      StBarInfo.Panels.Items[6].Text := '';

    var Koef := StBarInfo.font.size;
    var gape := Trunc(Koef * 2.7);

    if Koef > 10 then
      Gape := 100
    else
      Gape := 30;


    if Length(Trim(StBarInfo.Panels.Items[0].Text)) * Koef < 750 then
      StBarInfo.Panels.Items[0].Width := 750
    else
      StBarInfo.Panels.Items[0].Width := Length(Trim(StBarInfo.Panels.Items[0].Text)) * Koef- gape;

    if Length(Trim(StBarInfo.Panels.Items[1].Text)) = 0 then
      StBarInfo.Panels.Items[1].Width := 4
    else
      StBarInfo.Panels.Items[1].Width := Length(Trim(StBarInfo.Panels.Items[1].Text)) * Koef;

    StBarInfo.Panels.Items[2].Width := Length(Trim(StBarInfo.Panels.Items[2].Text)) * Koef + 17;//270;

    if Length(Trim(StBarInfo.Panels.Items[3].Text)) = 0 then
      StBarInfo.Panels.Items[3].Width := 4
    else
      StBarInfo.Panels.Items[3].Width := Length(Trim(StBarInfo.Panels.Items[3].Text)) * Koef;

    StBarInfo.Panels.Items[4].Width := Length(Trim(StBarInfo.Panels.Items[4].Text)) * Koef + 17;
    StBarInfo.Panels.Items[5].Width := Length(Trim(StBarInfo.Panels.Items[5].Text)) * Koef;
    StBarInfo.Panels.Items[6].Width := Length(Trim(StBarInfo.Panels.Items[6].Text)) * Koef+5;

  end;

end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.SetMouseDateDesc(posXMou: integer);
var
  dtMouPos: TDateTime;
  ActTab: TMqmPlanTabSheet;
begin
  ActTab := GetActiveTab;
  if Assigned(ActTab) then
  begin
    dtMouPos := ActTab.p_HeaderMan.m_CalPanel.PixelsToTime(posXMou);
    StMouseDate.Caption := DateTimeToStr(dtMouPos);
    m_MouseDate := dtMouPos;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.SetMouseQtyComp(Qty: Double; IsSubRes : boolean);
var
  dtMouPos: TDateTime;
  ActTab: TMqmPlanTabSheet;
begin
  ActTab := GetActiveTab;
  if Assigned(ActTab) then
  begin
    if IsSubRes then
    begin
      if Qty < 0 then
         Qty := 0;
      StQtyComp.Caption := _('free comp.') + ' ' + FloatTOStr(Qty);
    end
    else
      StQtyComp.Caption := '';
  end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.CleanSBar;
var
  i, J : integer;
var
  pt : TMqmPlanTabSheet;
  StBarInfo : TStatusBar;
begin
{  pt := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
  StBarInfo := pt.p_HeaderMan.m_StBarInfo;
  for i := 0 to StBarInfo.Panels.Count -1 do
    StBarInfo.Panels.Items[i].Text := '';
  StBarInfo.Panels.Items[1].Width := 0;
  StBarInfo.Panels.Items[3].Width := 0;
  StBarInfo.Panels.Items[2].Width := 0;
  StBarInfo.Panels.Items[4].Width := 0;
  StBarInfo.Panels.Items[5].Width := 0;
  StBarInfo.Panels.Items[6].Width := 0;  }

  for i := 0 to m_pgcPlan.PageCount-1 do
  begin
    pt := TMqmPlanTabSheet(m_pgcPlan.Pages[i]);
    if not Assigned(pt)
    or not (m_pgcPlan.Pages[i] is TMqmPlanTabSheet)then continue;
    StBarInfo := pt.p_HeaderMan.m_StBarInfo;
    for J := 0 to StBarInfo.Panels.Count -1 do
      StBarInfo.Panels.Items[J].Text := '';
    StBarInfo.Panels.Items[1].Width := 0;
    StBarInfo.Panels.Items[3].Width := 0;
    StBarInfo.Panels.Items[2].Width := 0;
    StBarInfo.Panels.Items[4].Width := 0;
    StBarInfo.Panels.Items[5].Width := 0;
    StBarInfo.Panels.Items[6].Width := 0;
  end;

end;

//----------------------------------------------------------------------------//

function TFMQMPlan.GetJobPopupList: TStringList;
begin
  Result := m_JobPopupList
end;

//----------------------------------------------------------------------------//

function TFMQMPlan.GetGroupPopupList: TStringList;
begin
  Result := m_GroupPopupList
end;

//----------------------------------------------------------------------------//

function TFMQMPlan.GetActAreaPopupList: TStringList;
begin
  Result := m_ActAreaPopupList
end;

//----------------------------------------------------------------------------//

function TFMQMPlan.GetResPopupList: TStringList;
begin
  Result := m_ResPopupList
end;

//----------------------------------------------------------------------------//

function TFMQMPlan.GetPlanCfg: TPlanTabsCfg;
begin
  Result := m_planTbCfg
end;

//----------------------------------------------------------------------------//
//-                               Handle docking                             -//
//----------------------------------------------------------------------------//

procedure TFMQMPlan.ShowDockPanel(APanel: TPanel; MakeVisible: boolean; Client: TControl);
begin
  // Client - the docked client to show if we are re-showing the panel.
  // Client is ignored if hiding the panel.

  // Since docking to a non-visible docksite isn't allowed, instead of setting
  // Visible for the panels we set the width to zero. The default InfluenceRect
  // for a control extends a few pixels beyond it's boundaries, so it is possible
  // to dock to zero width controls.

  // Don't try to hide a panel which has visible dock clients.
  if not MakeVisible and (APanel.VisibleDockClientCount > 1) then exit;

  if APanel = PanRgDock then
  begin

    VSplit.Visible := MakeVisible;

    if not MakeVisible then
      APanel.Width := 0
    else
    begin
      APanel.Width := dbappglobals.WdwBinSplitterH;
      VSplit.Left := APanel.Width + VSplit.Width;
    end

  end
  else
  begin

    HSplit.Visible := MakeVisible;

    if not MakeVisible then
      APanel.Height := 0
    else
    begin
      APanel.Height := DBappglobals.WdwBinSplitterH;
      HSplit.Top := ClientHeight - APanel.Height - HSplit.Width;
    end
  end;

  if MakeVisible and (Client <> nil) then Client.Show
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.PanDockDockDrop(Sender: TObject;
  Source: TDragDockObject; X, Y: Integer);
var
  pan: TPanel;
begin
  // OnDockDrop gets called AFTER the client has actually docked,
  // so we check for DockClientCount = 1 before making the dock panel visible.
  pan := TPanel(Sender);
  if pan.DockClientCount = 1 then ShowDockPanel(pan, True, nil);
  pan.DockManager.ResetBounds(true);

  // make DockManager repaints it's clients.
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.PanRgDockDockOver(Sender: TObject;
  Source: TDragDockObject; X, Y: Integer; State: TDragState;
  var Accept: Boolean);
var
  Temp : TRect;
begin
  Accept := Source.Control is TFBin;
  Temp := Source.DockRect;

  if Accept then
    with Temp do
    begin
      //Modify the DockRect to preview dock area.
      TopLeft     := PanRgDock.ClientToScreen(Point(-ClientWidth div 3, 0));
      BottomRight := PanRgDock.ClientToScreen(Point(0, PanRgDock.Height));
      Source.DockRect := Temp;
      DBAppGlobals.WdwBinDock:=1;
    end
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.PanDockGetSiteInfo(Sender: TObject;
  DockClient: TControl; var InfluenceRect: TRect; MousePos: TPoint;
  var CanDock: Boolean);
begin
  // if CanDock is true, the panel will not automatically draw the preview rect.
  CanDock := DockClient is TFBin
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.PanRgDockUnDock(Sender: TObject; Client: TControl;
  NewTarget: TWinControl; var Allow: Boolean);
var
  pan: TPanel;
begin
  pan := TPanel(Sender);
  if pan.DockClientCount = 1 then
    ShowDockPanel(pan, False, nil);
  DBAppGlobals.WdwBinDock := 0;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.PanBotDockDockOver(Sender: TObject;
              Source: TDragDockObject; X, Y: Integer; State: TDragState;
              var Accept: Boolean);
var
  pan: TPanel;
  Temp : TRect;
begin
  Accept := Source.Control is TFBin;
  Temp := Source.DockRect;
  if Accept then
  begin
    pan := TPanel(Sender);
    with Temp do
    begin
      //Modify the DockRect to preview dock area.
      TopLeft     := pan.ClientToScreen(Point(0, -Self.ClientHeight div 3));
      BottomRight := pan.ClientToScreen(Point(pan.Width, pan.Height)) ;
      Source.DockRect := Temp;
      DBAppGlobals.WdwBinDock := -1;
    end
  end
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.PanBotDockUnDock(Sender: TObject; Client: TControl;
  NewTarget: TWinControl; var Allow: Boolean);
var
  pan: TPanel;
begin
  pan := TPanel(Sender);
  if pan.DockClientCount = 1 then
    ShowDockPanel(pan, False, nil);
  DBAppGlobals.WdwBinDock := 0;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.ICapResDetailsClick(Sender: TObject);
begin
  case TMqmCapRes(m_popObj).m_Type of
      cr_Normal: OpenCapResForm(FMQMPlan, TMqmCapRes(m_popObj), RefreshAfterMove, FMQMPlan, nil,m_popDate );
      cr_DownTime, Cr_CrossingDtm: OpenDownTimeForm(FMQMPlan, TMqmCapRes(m_popObj), RefreshAfterMove, FMQMPlan, TMqmActArea(TMqmCapRes(m_popObj).p_father), m_popDate);
  end;
  RefreshActiveTab;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.ICloseTbsClick(Sender: TObject);
var i : Integer;
begin
  if m_ListAutoRunSetInfo.Count > 0 then
  begin
    for i := 0 to m_ListAutoRunSetInfo.Count - 1 do
    begin
      if TMqmPlanTabSheet(m_pgcPlan.GetActiveView).Caption = PTUserDefRecord(m_ListAutoRunSetInfo[I]).ActiveGanttTab then
      begin
        MessageDlg(_('You cannot delete tab, cause there is Auto Run definition set for it !'), mtError, [mbOk], 0);
        exit;
      end;
    end;
  end;

  if MessageDlg(_('Delete gantt tab?'), mtWarning, [mbYes,mbNo], 0) in [mrYes] then
    DeleteTab;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.DeleteTab;
begin
  m_planTbCfg.DeleteTab(TMqmPlanTabSheet(m_pgcPlan.GetActiveView).GetCode);
  m_pgcPlan.CloseActive;
  PgcMainChange(self);
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.FormClose(Sender: TObject; var Action: TCloseAction);
var
  W : Word;
  ts: TMqmPlanTabSheet;
  i: integer;
  TabCfg: TPlanTabCfg;
  EnvOK: boolean;
  DBconnection: boolean;
begin
  Application.ProcessMessages;
  DBconnection := true;

  if p_pl.ChangesMade and DMib.m_MainDB.Connected then
  begin
    if IsAutoRunMode then
    begin
      Application.ProcessMessages;
      exit//w := mrYes
    end
    else
      w := (MessageDlg(_('Do you want to save the changes?'), mtConfirmation, [mbYes, mbNo, mbCancel], 0));
    case w of
      mrCancel: begin
                  Action := caNone;
                  exit
                end;
      mrYes: begin
               MISaveClick(self)
             end;
//               p_Sim.SaveSim(p_Sim.p_CurrSimCode, p_Sim.p_CurrSimDesc, GenProgressBar, EnvOK);

    end;

    if w = mrCancel then
    begin
      Exit
    end
    else if w = mrYes then
    begin
    end;
  end
  else
  begin
     // this is to avoid error while program is closed // avi 17.10.2019
     TFWait.CreateWaitForm(self, w_close, nil).ShowModal;
  end;

  // prepare values for saving
{  if (windowstate = wsmaximized) or (windowstate = wsminimized) then
    DBappglobals.wdwplanstate := true
  else
  begin
    DBappglobals.WdwPlanLeft   := Left;
    DBappglobals.WdwPlanTop    := top;
    DBappglobals.WdwPlanWidth  := width;
    DBappglobals.Wdwplanheight := height;
    DBappglobals.wdwplanstate  := false
  end; }

  {for i := 0 to m_pgcPlan.PageCount-1 do
  begin
    ts := TMqmPlanTabSheet(m_pgcPlan.Pages[i]);
    if not Assigned(ts)
    or not (m_pgcPlan.Pages[i] is TMqmPlanTabSheet)then continue;

    TabCfg := TPlanTabCfg(m_planTbCfg.FindTab(ts.GetCode));
    if not Assigned(TabCfg) then continue;

    case ts.p_HeaderMan.m_CalPanel.TimeSCale of
      csOneHour  : TabCfg.m_CurrTScale := 0;
      csFourHours: TabCfg.m_CurrTScale := 1;
      csOneDay   : TabCfg.m_CurrTScale := 2;
      csOneWeek  : TabCfg.m_CurrTScale := 3;
    end;


    TabCfg.m_CurrDtTime := ts.p_HeaderMan.m_CalPanel.LeftTime;

    if DBAppGlobals.MCM_App then
    begin
      TabCfg.MCMcNumMaxPrd := ts.p_PlanWcControl.GetScaleComboBoxs(0);
      TabCfg.MCMcMaxPrd1 := ts.p_PlanWcControl.GetScaleComboBoxs(1);
      TabCfg.MCMcMaxPrd2 := ts.p_PlanWcControl.GetScaleComboBoxs(2);
      TabCfg.MCMCatViewWcHoursPerc := ts.p_PlanWcControl.GetScaleComboBoxs(3);
      TabCfg.MCMPropertyViewWcHoursPerc := ts.p_PlanWcControl.GetScaleComboBoxs(4);
    end;

  end; }

//  if fbin <> nil then FBin.SaveStatus;
//  if  DBconnection then  // do we have a connection to DB
//  m_planTbCfg.StoreToDatabase;

  //if IniAppGlobals.DownloadTo = '2' then
 // begin
 // m_planTbCfg.StoreToDatabase;
 // SaveAutoSchedCfgToDB;

  //GlobSaveValues;


  //  GlobSaveIniValues;
//  if fbin <> nil then FBin.SaveStatus;
 // end;}

  m_planTbCfg.Free;
  m_ListAutoRunSetInfo.Free;
  m_ConnectionRepairedetails.Free;

  m_ResPopupList.Free;
  m_ActAreaPopupList.free;
  m_GroupPopupList.free;
  m_JobPopupList.free;

  if Assigned(FAutoSched) then
    FAutoSched.Free
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.PgcMainChange(Sender: TObject);
var
  TabCfg : TPlanTabCfg;
  NewItem : TMenuItem;
  pt : TMqmPlanTabSheet;
  Save_Cursor : TCursor;
  SavedColorJobMode : TDisplayBarColor;
  ts: TMqmPlanTabSheet;
  i : Integer;
  CollapsedGroups : TStringList;
begin
  if m_planTbCfg.p_GetTabsCount = 0 then
  begin
   // PnlZoom.Visible := false;
  end
  else
  begin
   // PnlZoom.Visible := true;
  //  TrcBarZoom.Position := TMqmPlanTabSheet(m_pgcPlan.GetActiveView).p_zoom;
    if m_pgcPlan.GetActiveView <> nil then
    begin
      pt := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
      pt.p_HeaderMan.m_CalPanel.FResourceTrcBarZoom.Position := TMqmPlanTabSheet(m_pgcPlan.GetActiveView).p_zoom;
      pt.p_HeaderMan.m_CalPanel.FHorizontalTrcBarZoom.Position := TMqmPlanTabSheet(m_pgcPlan.GetActiveView).p_Hzoom;
      pt.p_HeaderMan.m_CalPanel.FStatusZoom.Position := TMqmPlanTabSheet(m_pgcPlan.GetActiveView).p_Szoom;
    end;
    TrcBarZoomChange(self);
  end;

  if m_pgcPlan.GetActiveView <> nil then
  begin
    TabCfg := TPlanTabCfg(m_planTbCfg.FindTab(m_pgcPlan.GetActiveView.GetCode));
    FMQMPlan.ExpOrCollSubResForCfg(False, TabCfg);
    SavedColorJobMode := TabCfg.m_ShowColorJobMode;
    if (TabCfg.m_ShowColorJobMode = Standard)// and (DBAppGlobals.ShowColorJobMode = Standard)
    then
    begin
      //DBAppGlobals.ShowColorJobMode := Standard;
      DBAppGlobals.ShowColorJobModeActivTab := Standard;
    {  if (GetIdFromCode(DBAppGlobals.LastPropColorInUseJobMode) <> nil) then
      begin
        NewItem := TMenuItem.Create(Self);
        NewItem.VCLComObject := GetIdFromCode(DBAppGlobals.LastPropColorInUseJobMode);
        ClickShowBarColorfromPropList(NewItem);
        DBAppGlobals.ShowColorJobModeActivTab := Standard;
      end
      else }
      //if (GetIdFromCode(DBAppGlobals.LastPropColorInUseJobMode) <> nil) then
      //  DBAppGlobals.LastPropColorInUseJobMode := '';

      ts := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
      if TabCfg.m_SlotGroup > 0 then
      begin
        // save collapsed group names before clearing
        CollapsedGroups := TStringList.Create;
        try
          for i := 0 to ts.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup_Lists.Count - 1 do
            if not TTSlotGrp_WKC(ts.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup_Lists[i]).m_IsExpanded then
              if CollapsedGroups.IndexOf(TTSlotGrp_WKC(ts.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup_Lists[i]).m_Group) < 0 then
                CollapsedGroups.Add(TTSlotGrp_WKC(ts.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup_Lists[i]).m_Group);

          ts.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup_Lists.Clear;
          ts.CreateWkcGroups(TabCfg.GetWorkCenterList);

          // restore collapsed state
          for i := 0 to ts.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup_Lists.Count - 1 do
            if CollapsedGroups.IndexOf(TTSlotGrp_WKC(ts.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup_Lists[i]).m_Group) >= 0 then
              TTSlotGrp_WKC(ts.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup_Lists[i]).m_IsExpanded := False;
        finally
          CollapsedGroups.Free;
        end;
      end;
      ts.p_shapeMan.ShapesUpdate;
     // MiSchedulestatusClick(self);
    end

    else if TabCfg.m_ShowColorJobMode = PreDefinedPropList then
    begin
      NewItem := TMenuItem.Create(Self);
      NewItem.VCLComObject := GetIdFromCode(TabCfg.m_PropertyCode);
      DBAppGlobals.ShowColorJobModeActivTab := PreDefinedPropList;
      ClickShowBarColorTabfromPropList(NewItem);
    end
    else if TabCfg.m_ShowColorJobMode = DinamicPropList then
    begin
      NewItem := TMenuItem.Create(Self);
      NewItem.VCLComObject := GetIdFromCode(TabCfg.m_PropertyCode);
      DBAppGlobals.ShowColorJobModeActivTab := DinamicPropList;
      ClickShowBarColorTabDynamic(NewItem);
    end
    else if TabCfg.m_ShowColorJobMode = ScheduleStatus then
    begin
      DBAppGlobals.ShowColorJobModeActivTab := ScheduleStatus;
      MiScheduleStatusTabClick(self);
    end else
    if (DBAppGlobals.ShowColorJobMode = PreDefinedPropList) and (TabCfg.m_ShowColorJobMode = Standard) then
    begin
      if (GetIdFromCode(DBAppGlobals.LastPropColorInUseJobMode) <> nil) then
      begin
        DBAppGlobals.ShowColorJobModeActivTab := PreDefinedPropList;
        NewItem := TMenuItem.Create(Self);
        NewItem.VCLComObject := GetIdFromCode(DBAppGlobals.LastPropColorInUseJobMode);
        ClickShowBarColorfromPropList(NewItem);
       { if (SavedColorJobMode = Standard) then
        begin
          TabCfg.m_ShowColorJobMode := Standard;
          MiStandardSettings.Checked := true;
          MiPropertyDynamicTab.Checked := false
        end;   }

      end;
    end
    else if (DBAppGlobals.ShowColorJobMode = DinamicPropList) and (TabCfg.m_ShowColorJobMode = Standard) then
    begin
      if (GetIdFromCode(DBAppGlobals.LastPropColorInUseJobMode) <> nil) then
      begin
        DBAppGlobals.ShowColorJobModeActivTab := DinamicPropList;
        NewItem := TMenuItem.Create(Self);
        NewItem.VCLComObject := GetIdFromCode(DBAppGlobals.LastPropColorInUseJobMode);
       // ClickShowBarColorDynamic(NewItem);
        ClickShowBarColorTabDynamic(NewItem);
        if (SavedColorJobMode = Standard) then
        begin
          TabCfg.m_ShowColorJobMode := Standard;
          MiStandardSettings.Checked := true;
          MiPropertyDynamicTab.Checked := false
        end;
      end
    end;
  end;

  pt := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
  if Assigned(pt) then
  begin
    if DBAppGlobals.MCM_App then
    begin
      Save_Cursor   := Screen.Cursor;
      Screen.Cursor  := crSQLWait;
      pt.RefreshMcmMcmSecondLvl;
      pt.p_PlanWcControl.P_planWcView.RefreshPlan(true);
      RefreshActiveTab;
      Screen.Cursor := Save_Cursor;
    end;

    {if pt.p_BasePanelResources.Visible then
      ChangeTabFromResourcesToWorkCenters(false)
    else
      ChangeTabFromResourcesToWorkCenters(true); }
  end;
  Application.ProcessMessages;
  CleanSBar;
  PgcBinChange;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.SetDynamicMqmPlanActive(ResList : TList; Value : Variant);
var
  Plantab : TMqmPlanTabSheet;
  I : Integer;
begin
  for i := 1 to m_pgcPlan.PageCount -1 do
  begin
    Plantab := TMqmPlanTabSheet(m_pgcPlan.Pages[i]);
    if (Plantab.p_GetPlanType = PDynamic) then
    begin
      Plantab.Caption := Value;
      Plantab.p_ganttPanel.UpdateList(ResList);
      Plantab.p_ganttPanel.SortOnDunamic;
      m_pgcPlan.SetActiveViewPlan(Plantab.GetCode);
      break;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.SetDynamicMcmPlanActiv(VisResList : TList; WcList : TList; PropCode : string; Value : Variant);
var
  Plantab : TMqmPlanTabSheet;
  I : Integer;
  WC : TMqmWrkCtr;
  PropId : TPropID;
  Propdesc : string;
begin
  for i := 1 to m_pgcPlan.PageCount -1 do
  begin
    Plantab := TMqmPlanTabSheet(m_pgcPlan.Pages[i]);
    if (Plantab.p_GetPlanType = PDynamic) then
    begin
      //SetActiveTabByName('Dynamic');
      Plantab.Caption := Value;
      m_pgcPlan.SetActiveViewPlan(Plantab.GetCode);
      p_pl.BuildWkcDailyEntityCapacity(VisResList, 2, PropCode);
      PropId := GetIdFromCode(PropCode);
      if assigned(PropId) then
         Propdesc := GetPropDescr(PropId);

      Plantab.SetDynamicMcmTabData(WcList);
      Plantab.SetMcmPropertySelection(true, '', PropCode, PropDesc, Value);
      break;
    end;
  end;
end;

//----------------------------------------------------------------------------//

function TFMQMPlan.IsDynamicPlanActiv : boolean;
var
  ts : TMqmPlanTabSheet;
begin
  Result := false;
  if (m_pgcPlan.PageCount > 1) then
  begin
    ts := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
    if (ts.p_GetPlanType = PDynamic) then
      Result := true
    else
      Result := false;
  end;
end;

function TFMQMPlan.IsDynamicPlanOpened : boolean;
var
  i:  integer;
  ts: TMqmPlanTabSheet;
begin
  Result := false;
  for i := 1 to m_pgcPlan.PageCount -1 do
  begin
    ts := TMqmPlanTabSheet(m_pgcPlan.Pages[i]);
    if (ts.p_GetPlanType = PDynamic) then
    begin
      Result := true;
      break;
    end;
  end
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.ResetDynamicTab;
var
  ts : TMqmPlanTabSheet;
begin
  ts := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
  assert(ts.p_GetPlanType = PDynamic);
  ts.p_ganttPanel.ClearObjList;
end;

//----------------------------------------------------------------------------//

function TFMQMPlan.GetListForActPlanTab(List: TList) : Boolean;
var
  ActTab : TMqmPlanTabSheet;
begin
  Result := false;
  with m_pgcPlan do
  begin
    if PageCount > 1 then
    begin
      ActTab := TMqmPlanTabSheet(ActivePage);

      if ActTab = nil then
      begin
        m_pgcPlan.ActivePageIndex := m_pgcPlan.PageCount -1 ;
        ActTab := TMqmPlanTabSheet(ActivePage);
      end;

      if ActTab.p_ganttPanel.GetListWcForFilter(List) then
        Result := true
    end
  end
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.AddTabWithList(name: string; resList: TList; PlanTyp : TPlanType; SlotGroup : Integer);
var
  tc: TPlanTabCfg;
begin
  tc := m_planTbCfg.AddNewTab(name, resList, m_planTbCfg.FindNewCode, PlanTyp, SlotGroup);
  CreateNewPlan(m_planTbCfg, tc.code);
  m_pgcPlan.ActivePageIndex := m_pgcPlan.PageCount-1
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.Appendix1Click(Sender: TObject);
var
  FAppendix: TFAppendix;
begin
  DMib.m_MainDB.Ping;  // will be catched by CommunicationException in case ping failed
  FAppendix := TFAppendix.Create(Self);
  FAppendix.ShowModal;
  FAppendix.free;
end;

procedure TFMQMPlan.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  var i : integer;
  var
  sh: TShapeManager;
  pt: TMqmPlanTabSheet;
  ActTab : TBinTabSheet;
  ActBinGrid: TBinDrawGrid;
  tb : TTabSheet;
begin
  exit;
  if ssCtrl in Shift  then
  begin
      Handled := True;
      if ((WheelDelta div 10) < 0) and (Handled) then
        Dec(ZoomRate)
      else
        Inc(zoomRate);

     FontResize2(Screen.MenuFont,0);
     m_pgcPlan.ActivePage.Repaint;
     //FontResize2(FBin.GetActiveView.GetBinGrid.Font);

    { //tb := m_pgcPlan.ActivePage;
      for i := 0 to m_pgcPlan.PageCount -1 do
      begin
       //m_pgcPlan.ActivePageIndex := i;
      end;
      //m_pgcPlan.ActivePage := tb;  }
      ActiveZoom :=  ZoomRate;
  end else
    Handled := false;

end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.Appendix1MeasureItem(Sender: TObject; ACanvas: TCanvas;
  var Width, Height: Integer);
begin
  if Assigned(FBin) then
    Appendix1.Visible := FBin.GetBinPopupList.IndexOf('MiFormularesult') > -1;
end;

//----------------------------------------------------------------------------//

function TFMQMPlan.IsDynamicActiveted(var Code : integer) : boolean;
var
  i:  integer;
  ts: TMqmPlanTabSheet;
begin
  Result := false;
  for i := 1 to m_pgcPlan.PageCount -1 do
  begin
    ts := TMqmPlanTabSheet(m_pgcPlan.Pages[i]);
    if (ts.p_GetPlanType = PDynamic) then
    begin
      Code := ts.GetCode;
      Result := true;
      break;
    end;
  end
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.PUpPlanPopup(Sender: TObject);
var
  I: integer;
begin
  for I := 0 to PupPlan.Items.Count - 1 do
    PupPlan.Items[I].Enabled := true;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.TBLogWindowClick(Sender: TObject);
begin
  ShowInfoForm(false)
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIResDetailsClick(Sender: TObject);
var
  FResDetails: TFResDetails;
begin
  FResDetails := TFResDetails.CreateResDet(self, TMqmVisibleRes(m_popObj));
  FResDetails.ShowModal;
  PgcMainChange(self);
  FResDetails.Free
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIWkcDetClick(Sender: TObject);
var
  FWkcDetails: TFWkcDetails;
begin
  FWkcDetails := TFWkcDetails.CreateWkcDetByResource(self, TMqmRes(TMqmVisibleRes(m_popObj).p_father));
  FWkcDetails.ShowModal;
  FWkcDetails.Free
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.IwkcPropertySelectionWcClick(Sender: TObject);
//var
//  ts : TMqmPlanTabSheet;
begin
//  ts := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
//  ts.SetMcmPropertySelection(false, TMqmWrkCtr(m_MqmWrkCtrPopUp).p_WrkCtrCode, '');
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIPlanPropRepoClick(Sender: TObject);
var
  sl: TStringList;
begin
  sl := TStringList.Create;

  sl.Add('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">');
  sl.Add('<HTML>');
  sl.Add('<HEAD>');
  sl.Add('<TITLE>MQM plan properties and rules overview</TITLE>');
  sl.Add('<STYLE type="text/css">');
  sl.Add('BODY {background: #5555cc; color: white}');
  sl.Add('TH { background: #000000; color: #ffffff }');
  sl.Add('TR.rowEven { background: #cccccc; color: #000000 }');
  sl.Add('TR.rowOdd { background: #ffffff; color: #000000 }');
  sl.Add('TD.hrsNum { align=right }');
  sl.Add('</STYLE>');
  sl.Add('</HEAD>');
  sl.Add('<BODY>');

  p_pl.PrintCompatReport(sl);

  sl.Add('</BODY>');
  sl.Add('</HTML>');

  sl.SaveToFile(IniAppGlobals.FilePlanPropRepo);
  sl.Free
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.IMoveToBinClick(Sender: TObject);
var
  id:  TSchedId;
begin
  if MessageDlg(_('Do you confirm to unschedule the current job?'), mtWarning, [mbYes,mbNo], 0) in [mrYes] then
  begin
    id := TSchedId(m_popObj);
    if p_sc.IsJobSavedInDB(id) then
    begin
      MessageDlg(_('Cannot unschedule: job already has a unique ID saved in the database.'), mtWarning, [mbOK], 0);
      exit;
    end;
    p_opStack.MarkStackForButtonUndo(_('Unschedule'));
    MoveToBin(id, true);
    ActiveUndo;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIUnscheduleClick(Sender: TObject);
var
  id : TSchedId;
  MqmActArea : TMqmActArea;
  OptsMover: SetOptsMover;
  DeltaSetupObjToMove: double;
begin
  if MessageDlg(_('Do you confirm to unschedule the current job?'), mtWarning, [mbYes,mbNo], 0) in [mrYes] then
  begin
    id := TSchedId(m_popObj);
    if p_sc.IsJobSavedInDB(id) then
    begin
      MessageDlg(_('Cannot unschedule: job already has a unique ID saved in the database.'), mtWarning, [mbOK], 0);
      exit;
    end;
    p_opStack.MarkStackForButtonUndo(_('Unschedule'));
    MqmActArea := TMqmActArea(p_sc.GetExtLinkPtr(Id));
    MoveToBin(id, true);
    ActiveUndo;
    if Assigned(MqmActArea) then
    begin
      MqmActArea.ReorganizeOcc(id, False, OptsMover, DeltaSetupObjToMove, nil, NOW);
      RefreshActiveTab
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MISaveClick(Sender: TObject);
begin

  if ((GetOccMoveForm <> nil) or (GetDownTimeForm <> nil)) then exit;

  if IniAppGlobals.External_Database_Update = '1' then
     ExternalDB_AddRequestStepToStepsToNotSaveList;

  p_sc.CleanAllBackup_Saved_flag_for_network_repairing;

  if (windowstate = wsmaximized) or (windowstate = wsminimized) then
    DBappglobals.wdwplanstate := true
  else
  begin
    DBappglobals.WdwPlanLeft   := Left;
    DBappglobals.WdwPlanTop    := top;
    DBappglobals.WdwPlanWidth  := width;
    DBappglobals.Wdwplanheight := height;
    DBappglobals.wdwplanstate  := false
  end;

  TFWait.CreateWaitForm(self, w_Save, nil).ShowModal;

  if Assigned(FBin) then
    FBin.RefreshGrid;

  p_opStack.Clear;
  ActiveUndo;
  DBAppGlobals.m_Network_Stoped_Dur_Save := false; // Clean anyway communication error in TDMib.CommunicationException
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiScheduleJobBySequenceClick(Sender: TObject);
var
  Bintab : TBinTabSheet;
  BinGrid : TBinDrawGrid;
  SchedList : TMSchedList;
  I, ResComp : Integer;
  VisRes : TMqmVisibleRes;
  StartDatePoint : TDateTime;
  Id : TSchedId;
  ObjMover : TMqmSchedObjMover;
  MqmActArea : TMqmActArea;
  setup, overlap, duration, DeltaSetupObjToMove : double;
  OptsMover : SetOptsMover;
  errlist : TStringList;
  CompVal : TCompatVal;
  Dependency : boolean;
  Cal: TPGCALObj;
  planInfo: TSQplanInfo;
  moveChgInfo: TSQmoveChgInfo;
begin
  if Assigned(FBin) then
  begin
    errlist := TStringList.Create;
    Bintab := TBinTabSheet(Fbin.GetActiveView);
    MqmActArea := TMqmActArea(m_popObj);
    VisRes := TMqmVisibleRes(MqmActArea.p_Father);
    StartDatePoint := m_popDate;

    if Assigned(VisRes) then
    begin
      BinGrid := Bintab.GetBinGrid;
      if BinGrid.HaveSameSequence then
      begin
        ShowMessage(_('Some jobs are having same sequence - please correct selection'));
        exit
      end;
      SchedList := BinGrid.Fill_Job_Sequence_List;
      p_opStack.MarkStackForButtonUndo(_('Move'));

      for I := SchedList.GetLinkCount - 1 downto 0 do
      begin
        Id := SchedList.GetLink(I);
        OccMoveEnter(FMQMPlan, Pointer(id));
        if (p_sc.ToBeSched(id, errlist) <> CSX_Yes)
        or not p_sc.CanDetach(id, ErrList, false)
        or not Assigned(MqmActArea)
        or not VisRes.CheckCompatWithOcc([cho_compVal, cho_timing, cho_wkc, cho_readOnly, cho_useDate, cho_qty, cho_Depend],
                                     id, Date, errlist, CompVal, Dependency) then
        begin
          OccMoveExit(FMQMPlan, true);
          ShowMessage(_('At least one of the jobs is not compatible'));
          exit;
        end;

        OccMoveExit(FMQMPlan, true);
      end;

      Cal := MqmActArea.GetCalendar;
      cal.NormalizeDate(StartDatePoint, ntNormalizeForward);

      while true do
      begin
        Id := MqmActArea.FindSchedInSpot(StartDatePoint);
        if Id = CSchedIDnull then break;
        if (p_sc.IsProgressed(Id) = prg_none) then
          break ;
        if Id <> CSchedIDnull then
        begin
          p_sc.GetPlanInfo(Id, planInfo);
          StartDatePoint := planInfo.endDate;
        end;
      end;

      for I := SchedList.GetLinkCount - 1 downto 0 do
      begin
        Id := SchedList.GetLink(I);
        OccMoveEnter(FMQMPlan, Pointer(id));
        if (p_sc.ToBeSched(id, errlist) <> CSX_Yes)
        or not p_sc.CanDetach(id, ErrList, false)
        or not Assigned(MqmActArea)
        or not VisRes.CheckCompatWithOcc([cho_compVal, cho_timing, cho_wkc, cho_readOnly, cho_useDate, cho_qty, cho_Depend],
                                     id, Date, errlist, CompVal, Dependency) then
        begin
          OccMoveExit(FMQMPlan, true);
          continue;
        end;

        ObjMover := TMqmSchedObjMover.Create;
        ObjMover.SetObjToMove(id);
        if p_sc.GetRscComponentFromJobOrStep(id) > 0 then
          ResComp := p_sc.GetRscComponentFromJobOrStep(id)
        else
          ResComp := VisRes.p_ResComp;

        p_sc.GetMoveChgInfo(id, moveChgInfo);

        case DBAppGlobals.ConfLevels of
          0 : moveChgInfo.SchedType := '2';
          1 : moveChgInfo.SchedType := '1';
          2 : moveChgInfo.SchedType := '3';
          3 : moveChgInfo.SchedType := '4';
          4 : moveChgInfo.SchedType := '5';
          5 : moveChgInfo.SchedType := '6';
          6 : moveChgInfo.SchedType := '7'
        end;

        if ObjMover.ChangeTo(MqmActArea, StartDatePoint, false, CSchedIDnull, Al_toDate, setup, overlap,
                           duration, '', StartDatePoint, OptsMover, nil, False, DeltaSetupObjToMove,false, ResComp) = CSM_Yes then
        begin
          p_opStack.ChgOccMoveData(id, moveChgInfo);
        end
        else
        begin
          ObjMover.Abort;
          OccMoveExit(FMQMPlan, true);
          FMQMPlan.TBUndoClick(Application);
          exit;
        end;
        OccMoveExit(FMQMPlan, true);
      end;
      BinGrid.Clear_Job_Sequence_List;
      if Assigned(FBin) then
      begin
        FBin.RefreshGrid;
        FBin.UpdateForChangeFilter;
      end;
    end;
  end;
  errlist.Free;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIUndoClick(Sender: TObject);
begin
  p_opStack.UndoByButton;

  RefreshActiveTab;
  if Assigned(FBin) then
    FBin.ChangeTabBinforChangeTabPlan;

  ActiveUndo;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiStatisticsUndoClick(Sender: TObject);
var
  NewItem : TMenuItem;
  StackMark : Integer;
begin
  NewItem := TMenuItem(Sender);
  if (NewItem.Name = 'MiStatisticsUndo') then exit;

  StackMark := GetStatisticStackMarkByIndex(Integer(NewItem.VCLComObject));
  p_opStack.UndoByButtonForStatistic(StackMark);
  p_opStack.ResetUndoLoopForStatistic;
  FreeScheduleStatistics;
  ActiveUndo;
  RefreshActiveTab;
  if Assigned(FBin) then
    FBin.ChangeTabBinforChangeTabPlan;

end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiUnscheduleRestToBinClick(Sender: TObject);
var
  NewCreatedId : TSchedId;
  RoundType : RoundToType;
  NumOfDec : Integer;
begin
  RoundType := NON;
  NumOfDec := 0;
  TMenuItem(Sender).Tag := -1;
  if (iniAppGlobals.SplitFromPointRoundCrit = '') or (iniAppGlobals.SplitFromPointRoundCrit = '0') then
    RoundType := Up
  else if (iniAppGlobals.SplitFromPointRoundCrit = '1') then
    RoundType := Down;
  if iniAppGlobals.SplitFromPointNumOfDec = '1' then
    NumOfDec := 1
  else if iniAppGlobals.SplitFromPointNumOfDec = '2' then
    NumOfDec := 2;
  SplitFromDatePoint(TSchedId(m_popObj), m_popDate, true, false, NewCreatedId, RoundType, NumOfDec);
  TMenuItem(Sender).Tag := 0;
  RefreshAfterMove(self)
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiUpdateTabUsingBinResourceClick(Sender: TObject);
var
  TabName : string;
  ResListObj : TList;
  Plantab : TMqmPlanTabSheet;
begin
  Plantab := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
  if assigned(Fbin) then
  begin
    if Fbin.GetResListForActiveTab(false, ResListObj, TabName) then
    begin
      Plantab.p_ganttPanel.UpdateList(ResListObj);
      m_planTbCfg.UpdateTab(Plantab.GetCode , TabName, ResListObj,-1);
    end;
  end;
end;

//----------------------------------------------------------------------------//
// this button not have a menuitem set by proprieties because when the function
// disable a button that to be left down

procedure TFMQMPlan.TBUndoClick(Sender: TObject);
begin
  if ((GetOccMoveForm <> nil) or (GetDownTimeForm <> nil)) then exit;
  p_opStack.UndoByButton;

  RefreshActiveTab;
  if Assigned(FBin) then
    FBin.ChangeTabBinforChangeTabPlan;

  ActiveUndo;

  if DBAppGlobals.MCM_App then
    RefreshMcmActiveGanttTab;
end;

//----------------------------------------------------------------------------//

// Not in used anymor since CommunicationException is handling in DMsrvPc
procedure TFMQMPlan.TimerConnectionCheckTimer(Sender: TObject);
var
  ThCheck : TClientConnectionThread;
  TimeTry : TDateTime;
begin

 { if (Iniappglobals.StartCheck = '') or (Iniappglobals.EndCheck = '') then
  begin
    Iniappglobals.StartCheck := '7';
    Iniappglobals.EndCheck := '19';
  end;

  if ((Time > (1 / 24 / 60) * 60 * StrToInt(Iniappglobals.StartCheck))
  and (Time < (1 / 24 / 60) * 60 * StrToInt(Iniappglobals.EndCheck))) then//or m_OperationStarted then
  begin

    if not m_ClientConnected then
    begin
      TimerConnectionCheck.Enabled := False;
      TimeTry := now;

      while True  do
      begin
        if ((Now - TimeTry) > (1 / 24 / 60 * 0.5)) then  //check every minute/2 for connection
        begin
          if DMib.m_MainDB.Ping then break;
          TimeTry := Now;
        end;
        Application.ProcessMessages;
        sleep(500);
      end;

      if DMib.m_MainDB.Connected then  //reset EXE if connection is back
      begin
        WriteLogConnectionRepair(m_ConnectionRepairedetails, true, '0');
        try
          DMib.ConnectDB_Cfg(true);
          RegisterEvent(true);
          DMib.ConnectDB_main;
          DMib.ConnectDB_Arc;
          DMib.ConnectDB_Host;

        except

        end;
      end;
    end;

    ThCheck := TClientConnectionThread.CreateChecking;
    ThCheck.Start;

  end;     }

end;

//----------------------------------------------------------------------------//

function TFMQMPlan.SaveToDB(ForSim: boolean): boolean;
const
  TRY_NUMBER = 14;
var
  I  :    Integer;
  qry :  TMqmQuery;
  updNum, updNumProp, NumberOfUniqueIds, StartingUniqueId  : integer;
  Save_Cursor : TCursor;
  j: integer;
  w : word;
begin
  Result := false;
  qry := nil;
  I := 0;
  try
    Result := false;
    if Assigned(FMQMPlan.MainProgBar) then
    begin
      FMQMPlan.MainProgBar.SetMax(TRY_NUMBER);
      FMQMPlan.MainProgBar.SetPosition(0);
    end;
  except
  end;

  while (I <= TRY_NUMBER) do
  begin
   // try

      j := 0;

      while j <= TRY_NUMBER do
      begin
        //if SP_GET_ACCESS(IniAppGlobals.WkstCode, AT_save) then
        if GET_ACCESS(IniAppGlobals.WkstCode, AT_save) then
        begin
          DBAppGlobals.MAINPLAN_Ignore_Save_Event := true;
          Save_Cursor := Screen.Cursor;
          Screen.Cursor  := crAppStart;
          StartingUniqueId := 0;
          NumberOfUniqueIds := p_sc.GetNbrOfUniqueIds;
          if NumberOfUniqueIds > 0 then
            StartingUniqueId  := GET_NEW_REQ_STARTING_NUMBER(NumberOfUniqueIds);

          qry := CreateQuery(Main_DB);
          Qry.Transaction := CreateTransaction(Main_DB);
          Qry.Transaction.StartTransaction;

          updNum := GetLastProdSched;
          updNumProp := GetLast_PROP_PROD_PLANNER;
          SaveStockDetails(qry);
          p_sc.SaveJobs(qry,'', ForSim, p_pl.GetVisResCode, updNum, p_pl.HasJobWasDeletetedFromHost , MainProgBar, StartingUniqueId);
          savePropUserDefine(qry,updNumProp);
          Qry.Transaction.Commit;
          qry.Close;

          qry.Free;
          updNum := GetLastCapRes;
          p_pl.Save(Main_DB, '', updNum);

      //    UpdateCalDb(GenProgressBar);
          UpdateCalDb(MainProgBar);

        //  SP_END_ACCESS(IniAppGlobals.WkstCode, true);
          END_ACCESS(IniAppGlobals.WkstCode);
          DBAppGlobals.MAINPLAN_Ignore_Save_Event := false;
          SP_SEND_UPDATE_CLIENT;
          m_MyStationEvent := true;
          Sleep(500);
          p_sc.ClearMoveOp;
          Screen.Cursor := Save_Cursor;
          Result := true;
          MainProgBar.SetPosition(0);
          exit;

        end else
        begin
          inc(j);
          if (j > TRY_NUMBER) then
          begin
            w := MessageDlg(_('Can not currently perform a save as the host or a planner are writing to the database. Try again?'), mtConfirmation, [mbYes, mbNo], 0);// = idYes then
            if (w = mrYes) then
              j := 0
            else
            begin
              MainProgBar.SetPosition(0);
              exit;
            end;
            ModalResult := mrNone;
          end else
          begin
            if Assigned(FMQMPlan.MainProgBar) then
              FMQMPlan.MainProgBar.SetPosition(j);
            REMOVE_UNACTIVATED_STATIONS;
            Application.ProcessMessages;
            {if SP_ASK_POLL then
            begin
              Sleep(2500);
              inc(j);
              if Assigned(FMQMPlan.MainProgBar) then
                FMQMPlan.MainProgBar.SelEnd := j;
              Application.ProcessMessages;
              Sleep(2500);
              SP_CHECK_POLL;
            end else
              Sleep(2500);  }
          end
        end;
      end;

   { except

      on E: Exception do
        begin
          FMQMPlan.MainProgBar.SelEnd := 0;
          END_ACCESS(IniAppGlobals.WkstCode, IniAppGlobals.Curr_Date_Signed);
          if assigned(qry) then
            qry.Free;
        //  inc(I);
          sleep(10);
          raise;
          break;
        end;
      end;  }

  end;


//  GenProgressBar.Position := 0;
//  MainProgBar.SetPosition(0);

end;

//----------------------------------------------------------------------------//

function TFMQMPlan.OrganizePlanAfterOrBeforeToday(ByActiveTab : boolean; BeforeNow : boolean) : boolean;
var
  ActTab : TMqmPlanTabSheet;
begin
  Result := true;
  if ByActiveTab then
  begin
    ActTab := GetActiveTab;
    if assigned(ActTab) then
    begin
      p_pl.ReorganizeAllAfterOrBeforeTodayByActTab(FMQMPlan.MainProgBar, GetPlanView, ActTab.p_ganttPanel.p_VisResList, BeforeNow)
    end;
  end
  else
    p_pl.ReorganizeAllAfterOrBeforeToday(FMQMPlan.MainProgBar, GetPlanView, BeforeNow);
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiniMizedMainForm;
begin
  self.WindowState := wsMinimized;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MaxiMizedMainForm;
begin
//  if not (ParamCount > 0) then // orta
    self.WindowState := wsMaximized;
end;

procedure TFMQMPlan.UpdateMenuItems(Value: Boolean);
var i : integer;
begin
  // Defer updates
//  SendMessage(Handle, WM_SETREDRAW, WPARAM(False), 0);
  try
    for i:= 0 to MainMenu.Items.count-1 do
      MainMenu.Items[i].Enabled:= Value
  except
    // Make sure updates are re-enabled
   // SendMessage(Handle, WM_SETREDRAW, WPARAM(True), 0);
    //  Invalidate;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.DisableMainMenu;
begin
     UpdateMenuItems(False);
end;

procedure TFMQMPlan.Dynamiccapacityreservation1Click(Sender: TObject);
begin

end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.EnableMainMenu;
begin
  UpdateMenuItems(True);
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.ActiveUndo;
var
  sHint: string;
begin
  if p_opStack.GetCount(sHint) > 0 then
  begin
    MIUndo.Enabled := True;
    TBUndo.Hint    := _('Undo') + ' ' + sHint;
    tbUndo.CustomHint := BalloonHint1;
  end
  else
  begin
    MIUndo.Enabled := False;
    TBUndo.Hint    := _('Undo');
    tbUndo.CustomHint := BalloonHint1;
  end;

 // TBUndo.Enabled := MIUndo.Enabled;  this line makes double button ... need to be recheck avi 13022020
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.SendJobMsg;
begin
  m_MyStationEvent := true;
  SP_SEND_JOB_MSG;
//  m_MyStationEvent := false;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.SendSharedData;
begin
  m_MyStationEvent := true;
  SP_SEND_SHARED_DATA;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiResourceSchedulesBysequenceClick(Sender: TObject);
begin
  TFConfigBin.CreateCfgBin(Self, Tb_SchedJobSequence).ShowModal;
  SaveDefaultTabJobSchedSequence;
end;

//----------------------------------------------------------------------------//
procedure TFMQMPlan.ExpOrCollSubResForCfg(Expand: boolean; ConfTab: TPlanTabCfg);
var
  J : integer;
  tempres: TMQMRes;
  VisRes : TMQMVisibleRes;
  ActTab: TMqmPlanTabSheet;
  RowPos, i : integer;
  Res : TMqmRes;
begin
  ActTab := GetActiveTab;
  RowPos := ActTab.p_ganttPanel.p_shapeMan.p_TopRowIdx;

  for i := 0 to ConfTab.IsResExpanded.Count-1 do
  begin

    Res := TMQMRES(TTResExpanded(ConfTab.IsResExpanded[i]).obj);
    if TTResExpanded(ConfTab.IsResExpanded[i]).Is_Res_Expanded = 1 then
      ActTab.p_ganttPanel.ExpandSubRes(Res)
    else
      ActTab.p_ganttPanel.CollapseSubRes(Res);

  end;

  for J := 0 to ActTab.p_ganttPanel.p_VisResList.Count - 1 do
  begin
    tempres := TMqmRes(TMqmVisibleRes(ActTab.p_ganttPanel.p_VisResList[j]).p_father);
    tempres.m_index := j;
  end;
  ActTab.p_ganttPanel.SortByIndex;
  ActTab.p_ganttPanel.p_shapeMan.TopRowChanged(RowPos);

  FMQMPlan.RefreshActiveTab;
  FMQMPlan.UpdateStatusPanel;

  if Assigned(FBin) then
  begin
    FBin.RefreshGrid;
    // FBin.UpdateForChangeFilter removed: PgcBinChange (called right after) handles this once
  end;
end;

procedure TFMQMPlan.ExpOrCollSubResForAllRes(Expand: boolean);
var
  J, i : integer;
  tempres: TMQMRes;
  VisRes : TMQMVisibleRes;
  ActTab: TMqmPlanTabSheet;
  RowPos : integer;
  Bintab : TBinTabSheet;
  res : TMqmRes;
  WC:     TMqmWrkCtr;
  ConfTab: TPlanTabCfg;
begin
  if Assigned(Fbin) then
  begin
    if Fbin.GetPageCount > 0 then
    begin
      Bintab := TBinTabSheet(Fbin.GetActiveView);
      ActTab := GetActiveTab;
      RowPos := ActTab.p_ganttPanel.p_shapeMan.p_TopRowIdx;

      if Assigned(BinTab) then
      begin
        ConfTab := TPlanTabCfg(m_planTbCfg.FindTab(m_pgcPlan.GetActiveView.GetCode));

        for i := 0 to ConfTab.res.Count-1 do
        begin
          Res := TMqmRes(ConfTab.res[i]);
          //VisRes := Res.p_VisRes[0];
          //VisRes.p_SubResExpanded := Expand;

          if Expand then
          begin
            ActTab.p_ganttPanel.ExpandSubRes(Res);
            TTResExpanded(ConfTab.IsResExpanded[i]).Is_Res_Expanded := 1;
          end else
          begin
            ActTab.p_ganttPanel.CollapseSubRes(Res);
            TTResExpanded(ConfTab.IsResExpanded[i]).Is_Res_Expanded := 0;
          end;
        end;

        for J := 0 to ActTab.p_ganttPanel.p_VisResList.Count - 1 do
        begin
          tempres := TMqmRes(TMqmVisibleRes(ActTab.p_ganttPanel.p_VisResList[j]).p_father);
          tempres.m_index := j;
        end;
      end;
    end;

    ActTab.p_ganttPanel.SortByIndex;
    ActTab.p_ganttPanel.p_shapeMan.TopRowChanged(RowPos);

    FMQMPlan.RefreshActiveTab;
    FMQMPlan.UpdateStatusPanel;

    if Assigned(FBin) then
    begin
      FBin.RefreshGrid;
      FBin.UpdateForChangeFilter;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.ExpOrCollSubRes(Expand: boolean);
var
  J, i : integer;
  Res,tempres: TMQMRes;
  VisRes : TMQMVisibleRes;
  ActTab: TMqmPlanTabSheet;
  RowPos : integer;
  ConfTab: TPlanTabCfg;
begin
  Res := TMQMRes(TMqmVisibleRes(m_popObj).p_Father);
  //VisRes := Res.p_VisRes[0];
  //VisRes.p_SubResExpanded := Expand;
  ActTab := GetActiveTab;
  RowPos := ActTab.p_ganttPanel.p_shapeMan.p_TopRowIdx;

  {if Expand then
    ActTab.p_ganttPanel.ExpandSubRes(Res)
  else
    ActTab.p_ganttPanel.CollapseSubRes(Res); }

  ConfTab := TPlanTabCfg(m_planTbCfg.FindTab(m_pgcPlan.GetActiveView.GetCode));

  for i := 0 to ConfTab.IsResExpanded.Count-1 do
  begin

    if Res = TMQMRES(TTResExpanded(ConfTab.IsResExpanded[i]).obj) then
    begin
      if Expand then
      begin
        ActTab.p_ganttPanel.ExpandSubRes(Res);
        TTResExpanded(ConfTab.IsResExpanded[i]).Is_Res_Expanded := 1;
      end else
      begin
        ActTab.p_ganttPanel.CollapseSubRes(Res);
        TTResExpanded(ConfTab.IsResExpanded[i]).Is_Res_Expanded := 0;
      end;

      break;
    end;
  end;

  for J := 0 to ActTab.p_ganttPanel.p_VisResList.Count - 1 do
  begin
    tempres := TMqmRes(TMqmVisibleRes(ActTab.p_ganttPanel.p_VisResList[j]).p_father);
    tempres.m_index := j;
  end;
  ActTab.p_ganttPanel.SortByIndex;
  ActTab.p_ganttPanel.p_shapeMan.TopRowChanged(RowPos);

  FMQMPlan.RefreshActiveTab;
  FMQMPlan.UpdateStatusPanel;

  if Assigned(FBin) then
  begin
    FBin.RefreshGrid;
    FBin.UpdateForChangeFilter;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.SetActiveTabByName(Name : string);
var
  CodeTab, I : integer;
  ts : TMqmPlanTabSheet;
begin
  CodeTab := m_planTbCfg.FinfTabByName(Name);
  for I := 0 to m_pgcPlan.PageCount - 1 do
  begin
    ts := TMqmPlanTabSheet(m_pgcPlan.Pages[I]);
    if not (m_pgcPlan.Pages[i] is TMqmPlanTabSheet)then continue;
    if TMqmPlanTabSheet(ts).GetCode = CodeTab then
    begin
      m_pgcPlan.SetActiveViewPlan(CodeTab);
      break;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.ChangeStationpasswordClick(Sender: TObject);
var FChgWkstPass: TFChgWkstPass;
begin
     FChgWkstPass := TFChgWkstPass.Create(self);
     FChgWkstPass.ShowModal;
     FChgWkstPass.Free;
end;

function TFMQMPlan.ChangeTabFromResourcesToWorkCenters(Fromresources : boolean) : boolean;
var
  pt: TMqmPlanTabSheet;
  Code : integer;
  I : Integer;
  shCfg:  TShConfig;
  hdrCfg: TMqmHdrCfg;
  gc:     TMqmGanttConst;
  StBarInfo : TStatusBar;
  TabCfg : TPlanTabCfg;
begin
  Assert(Assigned(m_pgcPlan));
  pt := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
  if Assigned(pt) then
  begin
    StBarInfo := pt.p_HeaderMan.m_StBarInfo;
    if Fromresources then
    begin
      StMouseDate.Caption := '';
      stQtyComp.Caption := '';
      StBarInfo.Visible   := false;
      StBarInfo.Panels.Items[0].Text := '';
      StBarInfo.Panels.Items[1].Text := '';
      StBarInfo.Panels.Items[2].Text := '';
      StBarInfo.Panels.Items[3].Text := '';
      StBarInfo.Panels.Items[4].Text := '';
      p_pl.BuildWkcDailyCapacity(pt.p_ganttPanel.p_VisResList, nil, nil);

      TabCfg := TPlanTabCfg(m_planTbCfg.FindTab(pt.GetCode));
      pt.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup_Lists.Clear;

      if TabCfg.m_SlotGroup > 0 then
        pt.CreateWkcGroups(TabCfg.GetWorkCenterList);

      pt.p_BasePanelResources.Visible := false;
      pt.p_BasePanelWorkCenters.Visible := true
    end
    else
    begin
      StBarInfo.Visible := true;
      StMouseDate.Visible := true;
      pt.p_BasePanelResources.Visible := true;
      pt.p_BasePanelWorkCenters.Visible := false;
    end;
  end;
  m_pgcPlan.OnChangeControl(self);
end;

//----------------------------------------------------------------------------//

function TFMQMPlan.CheckIfActiveGanttTabIsMcm : boolean;
var
  pt : TMqmPlanTabSheet;
begin
  Result := true;
  pt := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
  if Assigned(pt) then
  begin
    if pt.p_BasePanelResources.Visible then
       Result := false;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.SetSelectionSlotOnActiveTab;
var
  pt : TMqmPlanTabSheet;
begin
  pt := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
  if Assigned(pt) then
  begin
    m_SelectedListWrkCtrPopUp := pt.p_PlanWcControl.P_planWcView.p_selectSlot.p_SelectedList;
  end;
end;

//----------------------------------------------------------------------------//

function TFMQMPlan.EventCameFromHost : boolean;
begin
  Result := m_HostDataWaiting;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.OperateRefreshButton;
begin
 // TbRefreshBtn.Enabled := true;
  RefreshTimer.Enabled := true;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.SetPropertyListToPopUpwc;
var
  P : Integer;
  NewItem : TMenuItem;
begin
  for P := 0 to GetPropertyCount - 1 do
  begin
    NewItem := TMenuItem.Create(Self);
    NewItem.VCLComObject := GetPropFromPos(P);
    NewItem.Caption := GetPropDescr(GetPropFromPos(P));
    NewItem.Name    := 'MiAllWcViewProp' + IntToStr(P);
    NewItem.OnClick := MISetPropertyToAllWcClick;     // IwkcPropertySelectionWc
    if p = 25 then
      NewItem.Break := mbBarBreak;
    if p = 50 then
      NewItem.Break := mbBarBreak;
    NewItem.Tag     := 1;
   // NewItem.OnDrawItem := DrawItemPopUp;
    IwkcPropertySelectionAllWc.add(NewItem);

    NewItem := TMenuItem.Create(Self);
    NewItem.VCLComObject := GetPropFromPos(P);
    NewItem.Caption := GetPropDescr(GetPropFromPos(P));
    NewItem.Name    := 'MiWcViewProp' + IntToStr(P);
    NewItem.OnClick := MISetPropertyToWcClick;
    if p = 25 then
      NewItem.Break := mbBarBreak;
    if p = 50 then
      NewItem.Break := mbBarBreak;
    NewItem.Tag     := 1;
  //  NewItem.OnDrawItem := DrawItemPopUp;
    IwkcPropertySelectionWc.Add(NewItem);
  end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.SetDynamicSubMenuForShowColor;
var
  I, J, K, P : Integer;
  MenuItemI : TMenuItem;
  NewItem : TMenuItem;
  Found : boolean;
begin
  try

  Found := false;

  for I := 0 to MainMenu.Items.Count - 1 do
  begin
    if (MainMenu.Items[I].Name = 'MIShow') then
    begin
      MenuItemI := MainMenu.Items[I];
      for J := 0 to MenuItemI.Count - 1 do
      begin
        if MenuItemI[J].Name = 'MiBarColorCreteria' then
        begin
          MenuItemI := MenuItemI[J];
          for K := 0 to MenuItemI.Count - 1 do
          begin
            if MenuItemI[K].Name = 'MiPropertyPreDefined' then
            begin
              MenuItemI := MenuItemI[K];
              for P := 0 to GetPropertyCount - 1 do
              begin
                NewItem := TMenuItem.Create(Self);
                NewItem.VCLComObject := GetPropFromPos(P);
                NewItem.Caption := GetPropDescr(GetPropFromPos(P));
                NewItem.Name    := 'MiPropertyPreDefined' + IntToStr(P);
                NewItem.OnClick := ClickShowBarColorfromPropList;
               // NewItem.OnDrawItem := DrawItemPopUp; //Mihailo
                if p = 25 then
                  NewItem.Break := mbBarBreak;
                if p = 50 then
                  NewItem.Break := mbBarBreak;
                MenuItemI.add(NewItem);
              end;
              Found := true;
              break
            end
          end;
          if Found then break;
        end;
        if Found then break;
      end;
    end;
  end;

  Found := false;

  for I := 0 to MainMenu.Items.Count - 1 do
  begin
    if (MainMenu.Items[I].Name = 'MIShow') then
    begin
      MenuItemI := MainMenu.Items[I];
      for J := 0 to MenuItemI.Count - 1 do
      begin
        if MenuItemI[J].Name = 'MiBarColorCreteria' then
        begin
          MenuItemI := MenuItemI[J];
          for K := 0 to MenuItemI.Count - 1 do
          begin
            if MenuItemI[K].Name = 'MiPropertyDynamic' then
            begin
              MenuItemI := MenuItemI[K];
              for P := 0 to GetPropertyCount - 1 do
              begin
                NewItem := TMenuItem.Create(Self);
                NewItem.VCLComObject := GetPropFromPos(P);
                NewItem.Caption := GetPropDescr(GetPropFromPos(P));
                NewItem.Name    := 'MiPropertyDynamic' + IntToStr(P);
                NewItem.OnClick := ClickShowBarColorDynamic;
              //  NewItem.OnDrawItem := DrawItemPopUp; //Mihailo
                if p = 25 then
                  NewItem.Break := mbBarBreak;
                if p = 50 then
                  NewItem.Break := mbBarBreak;
                MenuItemI.add(NewItem);
              end;
              Found := true;
              break;
            end
          end;
          if Found then break;
        end;
      end;
      if Found then break;
    end;
  end;

  Found := false;

  for I := 0 to MainMenu.Items.Count - 1 do
  begin
    if (MainMenu.Items[I].Name = 'MISetting') then
    begin
      MenuItemI := MainMenu.Items[I];
      for J := 0 to MenuItemI.Count - 1 do
      begin
        if Assigned(MenuItemI[J]) and (MenuItemI[J].Name = 'MiSetBarColor') then
        begin
          MenuItemI := MenuItemI[J];
          for K := 0 to MenuItemI.Count - 1 do
          begin
            if MenuItemI[K].Name = 'MiSetPropColor' then
            begin
              MenuItemI := MenuItemI[K];
              for P := 0 to GetPropertyCount - 1 do
              begin
                NewItem := TMenuItem.Create(Self);
                NewItem.VCLComObject := GetPropFromPos(P);
                NewItem.Caption := GetPropDescr(GetPropFromPos(P));
                NewItem.Name    := 'MiSet' + IntToStr(P);
                NewItem.OnClick := ClickSetPropColorBar;
                if p = 25 then
                  NewItem.Break := mbBarBreak;
                if p = 50 then
                  NewItem.Break := mbBarBreak;
                MenuItemI.add(NewItem);
              end;
              Found := true;
              break;
            end
          end;
          if Found then break;
        end;
      end;
      if Found then break;
    end;
  end;

  Found := false;

  for I := 0 to PupActArea.Items.Count -1 do
  begin
    if (PupActArea.Items[I].Name = 'MiShowBarColorCreteriaTab') then
    begin
      MenuItemI := PupActArea.Items[I];
      for J := 0 to MenuItemI.Count - 1 do
      begin
        if MenuItemI[J].Name = 'MiPropertyPreDefinedTab' then
        begin
          MenuItemI := MenuItemI[J];
          for k := 0 to GetPropertyCount - 1 do
          begin
            NewItem := TMenuItem.Create(Self);
            NewItem.VCLComObject := GetPropFromPos(k);
            NewItem.Caption := GetPropDescr(GetPropFromPos(k));
            NewItem.Name    := 'MiPropertyPreDefinedTab' + IntToStr(k);
            NewItem.OnClick := ClickShowBarColorTabfromPropList;
          //  NewItem.OnDrawItem := DrawItemPopUp; //Mihailo
            if k = 25 then
              NewItem.Break := mbBarBreak;
            if k = 50 then
              NewItem.Break := mbBarBreak;
            MenuItemI.add(NewItem);
          end;
          Found := true;
          break;
        end;
      end;
      if Found then break;
    end;
  end;

  Found := false;

  for I := 0 to PupActArea.Items.Count -1 do
  begin
    if (PupActArea.Items[I].Name = 'MiShowBarColorCreteriaTab') then
    begin
      MenuItemI := PupActArea.Items[I];
      for J := 0 to MenuItemI.Count - 1 do
      begin
        if MenuItemI[J].Name = 'MiPropertyDynamicTab' then
        begin
          MenuItemI := MenuItemI[J];
          for k := 0 to GetPropertyCount - 1 do
          begin
            NewItem := TMenuItem.Create(Self);
            NewItem.VCLComObject := GetPropFromPos(k);
            NewItem.Caption := GetPropDescr(GetPropFromPos(k));
            NewItem.Name    := 'MiPropertyDynamicTab' + IntToStr(k);
            NewItem.OnClick := ClickShowBarColorTabDynamic;
          //  NewItem.OnDrawItem := DrawItemPopUp; //Mihailo
            if k = 25 then
              NewItem.Break := mbBarBreak;
            if k = 50 then
              NewItem.Break := mbBarBreak;
            MenuItemI.add(NewItem);
          end;
          Found := true;
          break;
        end;
      end;
      if Found then break;
    end;
  end;

  except

  end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.ClickShowBarColorTabfromPropList(Sender: TObject);
var
  NewItem : TMenuItem;
  ts: TMqmPlanTabSheet;
  TabCfg : TPlanTabCfg;
begin
  NewItem := TMenuItem(Sender);
  MiStandardSettings.Checked := false;
  MiPropertyPreDefinedTab.Checked := true;
  MiPropertyDynamicTab.Checked := false;

  DBAppGlobals.ShowColorJobModeActivTab := PreDefinedPropList;
  TabCfg := TPlanTabCfg(m_planTbCfg.FindTab(m_pgcPlan.GetActiveView.GetCode));
  TabCfg.m_ShowColorJobMode := PreDefinedPropList;
  TabCfg.m_PropertyCode := GetPropCodeFromID(NewItem.VCLComObject);
  SetCheckedCurrentPropertyColoredPreDefinedTab(false, NewItem.VCLComObject);
  SetCheckedCurrentPropertyColoredDynamicTab(true, NewItem.VCLComObject);
  FillColorPropDisplayListActivTab(NewItem.VCLComObject);
  ts := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
  ts.p_shapeMan.ShapesUpdate;
  if assigned(FBin) then
    FBin.RefreshGrid;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.ClickAutoRunByCode(Sender: TObject);
var
  NewItem : TMenuItem;
  Str : string;
begin
  NewItem := TMenuItem(Sender);
  Str := copy(NewItem.Name, 1 , length(NewItem.Name) - 1);
  Str := copy(Str, 14 , length(str));
  RunAutomaticByCode(Str);
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.ClickShowBarColorTabDynamic(Sender: TObject);
var
  NewItem : TMenuItem;
  ts: TMqmPlanTabSheet;
  TabCfg : TPlanTabCfg;
  id: TSchedID;
  Iter: TMSchedContIterator;
  PropID, pId : TPropID;
  prop : TProperties;
  I : Integer;
  jobPropVal,TestedVal : variant;
  PropValList : TStringList;
  PropRscCode: string;
  function CheckValExist(val : string) : boolean;
  var
    J : Integer;
  begin
    Result := false;
    for J := 0 to PropValList.Count - 1 do
    begin
      if (val = PropValList.Strings[J]) then
      begin
        Result := true;
        break;
      end;
    end;
  end;

begin
  NewItem := TMenuItem(Sender);
  PropID := NewItem.VCLComObject;
  PropValList := TStringList.Create;
  Iter := TMSchedContIterator.CreateScIter(p_sc);
  Iter.Start;
  id := Iter.GetNext;

  while (id <> CSchedIDnull) do
  begin
    if (p_sc.GetExtLinkPtr(id) <> nil) then
    begin
      prop := p_sc.GetProperties(id, nil);
      for I  := 0 to prop.p_PropCount - 1 do
      begin
        jobPropVal := prop.GetProperty(i, pId, PropRscCode);

        if IsPropDynamic(pId) then
        begin
          p_sc.GetPropVal(Id,pId,TestedVal);
          if (TestedVal = jobPropVal) then
          begin
            jobPropVal := p_sc.GetPropDinamicVal(Id,jobPropVal);
            jobPropVal := round(jobPropVal);
          end;
        end;

        if pId <> PropID then continue;
        begin
          if not CheckValExist(jobPropVal) then
            PropValList.add(jobPropVal);
        end;
      end;
    end;
    id := Iter.GetNext
  end;

  PropValList.Sort;

  FillColorDinamicPropDisplayList(NewItem.VCLComObject, PropValList);

  MiStandardSettings.Checked := false;
  MiPropertyPreDefinedTab.Checked := false;
  MiPropertyDynamicTab.Checked := true;

//  DBAppGlobals.ShowColorJobMode := DinamicPropList;
//  DBAppGlobals.LastPropColorInUseJobMode := GetPropCodeFromID(NewItem.VCLComObject);
  DBAppGlobals.ShowColorJobModeActivTab := DinamicPropList;
  PropValList.Free;

  TabCfg := TPlanTabCfg(m_planTbCfg.FindTab(m_pgcPlan.GetActiveView.GetCode));
  TabCfg.m_ShowColorJobMode := DinamicPropList;
  if NewItem.VCLComObject <> nil then
  begin
    TabCfg.m_PropertyCode := GetPropCodeFromID(NewItem.VCLComObject);
    SetCheckedCurrentPropertyColoredDynamicTab(false, NewItem.VCLComObject);
    SetCheckedCurrentPropertyColoredPreDefinedTab(true, NewItem.VCLComObject);
  end;
  ts := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
  ts.p_shapeMan.ShapesUpdate;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.ClickShowBarColorfromPropList(Sender: TObject);
var
  NewItem : TMenuItem;
  ts: TMqmPlanTabSheet;
begin
  NewItem := TMenuItem(Sender);
  MiSchedulestatus.Checked := false;
  MiPropertyPreDefined.Checked := true;
  MiPropertyDynamic.Checked := false;
  DBAppGlobals.ShowColorJobMode := PreDefinedPropList;
  DBAppGlobals.LastPropColorInUseJobMode := GetPropCodeFromID(NewItem.VCLComObject);
  //FillColorPropDisplayList(NewItem.VCLComObject);
  FillColorPropDisplayListActivTab(NewItem.VCLComObject);
  ts := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
  ts.p_shapeMan.ShapesUpdate;
  SetCheckedCurrentPropertyColoredPreDefined(false);
  SetCheckedCurrentPropertyColoredDynamic(true);
  if assigned(FBin) then
    FBin.RefreshGrid;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.ClickShowBarColorDynamic(Sender: TObject);
var
  NewItem : TMenuItem;
  ts: TMqmPlanTabSheet;
  id: TSchedID;
  Iter: TMSchedContIterator;
  PropID, pId : TPropID;
  prop : TProperties;
  I : Integer;
  jobPropVal,TestedVal : variant;
  PropValList : TStringList;
  PropRscCode: string;
  function CheckValExist(val : string) : boolean;
  var
    J : Integer;
  begin
    Result := false;
    for J := 0 to PropValList.Count - 1 do
    begin
      if (val = PropValList.Strings[J]) then
      begin
        Result := true;
        break;
      end;
    end;
  end;

begin
  NewItem := TMenuItem(Sender);
  PropID := NewItem.VCLComObject;
  PropValList := TStringList.Create;
  Iter := TMSchedContIterator.CreateScIter(p_sc);
  Iter.Start;
  id := Iter.GetNext;

  while (id <> CSchedIDnull) do
  begin
    if (p_sc.GetExtLinkPtr(id) <> nil) then
    begin
      prop := p_sc.GetProperties(id, nil);
      for I  := 0 to prop.p_PropCount - 1 do
      begin
        jobPropVal := prop.GetProperty(i, pId, PropRscCode);

        if IsPropDynamic(pId) then
        begin
          p_sc.GetPropVal(Id,pId,TestedVal);
          if (TestedVal = jobPropVal) then
          begin
            jobPropVal := p_sc.GetPropDinamicVal(Id,jobPropVal);
            jobPropVal := round(jobPropVal);
          end;
        end;

        if pId <> PropID then continue;
        begin
          if not CheckValExist(jobPropVal) then
            PropValList.add(jobPropVal);
        end;
      end;
    end;
    id := Iter.GetNext
  end;

  PropValList.Sort;

  FillColorDinamicPropDisplayList(NewItem.VCLComObject, PropValList);

  MiSchedulestatus.Checked := false;
  MiPropertyPreDefined.Checked := false;
  MiPropertyDynamic.Checked := true;

  DBAppGlobals.ShowColorJobMode := DinamicPropList;
  DBAppGlobals.LastPropColorInUseJobMode := GetPropCodeFromID(NewItem.VCLComObject);
  PropValList.Free;
  ts := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
  ts.p_shapeMan.ShapesUpdate;
  SetCheckedCurrentPropertyColoredPreDefined(true);
  SetCheckedCurrentPropertyColoredDynamic(false);
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.ClickSetPropColorBar(Sender: TObject);
var
  NewItem : TMenuItem;
  ShowColor: TShowColor;
  PropId   : TPropId;
begin
  NewItem := TMenuItem(Sender);
  PropId := NewItem.VCLComObject;
  ShowColor := TShowColor.CreateSetColorForm(self, PropId);
  if ShowColor.ShowModal = mrOk then
  begin
    ShowColor.Free;
    FillColorPropDisplayListActivTab(PropId);
    PgcMainChange(self);
  end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.SetCheckedCurrentPropertyColoredPreDefined(CreanAllChecked : boolean);
var
  I, J, K, P : Integer;
  MenuItemI: TMenuItem;
begin
  try

  for I := 0 to MainMenu.Items.Count - 1 do
  begin
    if (MainMenu.Items[I].Name = 'MIShow') then
    begin
      MenuItemI := MainMenu.Items[I];
      for J := 0 to MenuItemI.Count - 1 do
      begin
        if MenuItemI[J].Name = 'MiBarColorCreteria' then
        begin
          MenuItemI := MenuItemI[J];
          for K := 0 to MenuItemI.Count - 1 do
          begin
            if MenuItemI[K].Name = 'MiPropertyPreDefined' then
            begin
              MenuItemI := MenuItemI[K];
              for P := 0 to MenuItemI.Count - 1 do
              begin
                MenuItemI.Items[P].Checked := false;
                if not CreanAllChecked then
                begin
                  if MenuItemI.Items[P].VCLComObject = GetIdFromCode(DBAppGlobals.LastPropColorInUseJobMode) then
                     MenuItemI.Items[P].Checked := true
                end;
              end;
              break;
            end
          end;
        end;
      end;
    end;
  end;

  except

  end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.SetCheckedCurrentPropertyColoredDynamic(CreanAllChecked : boolean);
var
  I, J, K, P : Integer;
  MenuItemI: TMenuItem;
begin
  try

  for I := 0 to MainMenu.Items.Count - 1 do
  begin
    if (MainMenu.Items[I].Name = 'MIShow') then
    begin
      MenuItemI := MainMenu.Items[I];
      for J := 0 to MenuItemI.Count - 1 do
      begin
        if MenuItemI[J].Name = 'MiBarColorCreteria' then
        begin
          MenuItemI := MenuItemI[J];
          for K := 0 to MenuItemI.Count - 1 do
          begin
            if MenuItemI[K].Name = 'MiPropertyDynamic' then
            begin
              MenuItemI := MenuItemI[K];
              for P := 0 to MenuItemI.Count - 1 do
              begin
                MenuItemI.Items[P].Checked := false;
                if not CreanAllChecked then
                begin
                  if MenuItemI.Items[P].VCLComObject = GetIdFromCode(DBAppGlobals.LastPropColorInUseJobMode) then
                     MenuItemI.Items[P].Checked := true
                end;
              end;
              break
            end
          end;
        end;
      end;
    end;
  end;

  except

  end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.SetCheckedCurrentPropertyColoredPreDefinedTab(CreanAllChecked : boolean; pId : Pointer);
var
  I, J, K : Integer;
  MenuItemI : TMenuItem;
begin
  for I := 0 to PupActArea.Items.Count -1 do
  begin
    if (PupActArea.Items[I].Name = 'MiShowBarColorCreteriaTab') then
    begin
      MenuItemI := PupActArea.Items[I];
      for J := 0 to MenuItemI.Count - 1 do
      begin
        if MenuItemI[J].Name = 'MiPropertyPreDefinedTab' then
        begin
          MenuItemI := MenuItemI[J];
          for k := 0 to MenuItemI.Count - 1 do
          begin
            MenuItemI.Items[K].Checked := false;
            if not CreanAllChecked and assigned(pId) then
            begin
              if MenuItemI.Items[K].VCLComObject = TPropId(Pid) then
                MenuItemI.Items[K].Checked := true
            end;
          end;
          exit;
        end;
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.SetCheckedCurrentPropertyColoredDynamicTab(CreanAllChecked : boolean; pId : Pointer);
var
  I, J, K : Integer;
  MenuItemI : TMenuItem;
begin
  for I := 0 to PupActArea.Items.Count -1 do
  begin
    if (PupActArea.Items[I].Name = 'MiShowBarColorCreteriaTab') then
    begin
      MenuItemI := PupActArea.Items[I];
      for J := 0 to MenuItemI.Count - 1 do
      begin
        if MenuItemI[J].Name = 'MiPropertyDynamicTab' then
        begin
          MenuItemI := MenuItemI[J];
          for k := 0 to MenuItemI.Count - 1 do
          begin
            MenuItemI.Items[K].Checked := false;
            if not CreanAllChecked and assigned(pId) then
            begin
              if MenuItemI.Items[K].VCLComObject = TPropId(Pid) then
                 MenuItemI.Items[K].Checked := true
            end;
          end;
          exit;
        end;
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.ShowScheduledJobsOnRes(date_from : TDateTime; date_to : TdateTime; MqmRes : TMqmRes);
var
  ReportSettings : TSettings;
  ChkLstBoxRsc: TCheckListBox;
  ReportForm: TFViewHtml;
  Save_Cursor : TCursor;
begin
  Save_Cursor   := Screen.Cursor;
  Screen.Cursor  := crAppStart;
  ChkLstBoxRsc := TCheckListBox.Create(self);
  ChkLstBoxRsc.Parent := self;
  ChkLstBoxRsc.Items.Add(MqmRes.p_ResCode);
  ChkLstBoxRsc.Visible := false;
  ChkLstBoxRsc.Checked[0] := true;
  ReportSettings.NativeExcel      := nil;
  ReportSettings.DateFrom         := date_from;
  ReportSettings.DateTo           := date_to;
  ReportSettings.SaveFileLocation := GetCurrentDir + SetBackslash + HTML_REPORT_FULL;
  ReportSettings.ChkLstBoxRsc     := ChkLstBoxRsc;
  ReportSettings.ReportType       := 'Html';
  ReportSettings.IsBinReport      := false;
  try
    ReportSettings.MaxRows        := StrToInt(iniAppGlobals.HtmlRowNum);
  except ReportSettings.MaxRows   := -1;
  end;
  if ReportSettings.MaxRows < 1 then ReportSettings.MaxRows := -1;
  ReportSettings.MaxCols          := -1;
  if ReportSettings.IsBinReport then
    ReportSettings.ShowBinCaptionBinReport   := iniAppGlobals.ShowBinCaptionBinReport = '1'
  else
    ReportSettings.ShowBinCaption   := iniAppGlobals.ShowBinCaption = '1';
  ReportSettings.ShowCriteria     := iniAppGlobals.ShowCriteria = '1';
  ReportSettings.ShowResources    := iniAppGlobals.ShowResources = '1';
  ReportSettings.NewPagePerRes    := iniAppGlobals.PagePerResource = '1';
  ReportSettings.IncDowntime      := iniAppGlobals.IncDowntime = '1';
  ReportSettings.ShowUnschedJobs  := false;
  ReportSettings.Comment          := iniAppGlobals.ReportComment1;
  ReportSettings.IsExportReport   := false;
  ReportSettings.GroupingFields   := -1;
  ReportSettings.JumpingFields    := -1;
  ReportSettings.ShowGroups       := false;
  SetReportFonts(ReportSettings);
  // Create temporary HTML file(s) for FMViewHtml
  if DynamicScheduleExport(ReportSettings,false) then //ViewReport(date_from, date_to);
  begin
    ReportForm := TFViewHtml.CreateHtmlViewer(self, ChkLstBoxRsc, date_from, date_to, false, MqmRes.p_ResCode
                  + ' ' + MqmRes.p_ResLDesc);
    ReportForm.ShowModal;
    ReportForm.Free;
  end;
  ChkLstBoxRsc.free;
  Screen.Cursor := Save_Cursor;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.SplitGroupClick(Sender: TObject);
var
  SplitQty, QtyPerJob, OrigJobQty, EachJobQty: currency;
  NewJobNr: integer;
  id, NewId, ChildId, m_Newgrp : TSchedID;
  Err, m_msgError: string;
  List : TList;
  I,J : Integer;
  value: variant;
  dataType: CBinColValType;
  JobQty : double;
  TabSheet : TTabSheet;
  m_GrpSchedList : TMSchedList;
  ArraySchedList : array of TMSchedList;
  m_SplitGroupData : TSplitGroupData;
   QtyPerGrp,
  OrigGrpQty, EachGrpQty : currency;
  SplitNo, NewGrpNr: integer;
  JobQtyValue, stepqtyValue: variant;
  QtyAtDate : currency;
  VisRes    : TMqmVisibleRes;
  ProgQty, Temp: double;
  NewIdStartDate : TDateTime;
  planInfo       : TSQplanInfo;
  Ptr            : Pointer;
  OptsMover: SetOptsMover;
  DeltaSetupObjToMove: double;
  MarkStack: TStackMark;
  ResComp : Integer;
  S : string;
  TempExt : Extended;
  ObjMover  : TMqmSchedObjMover;
  Res : TMqmVisibleRes;
  ResMain : TMqmRes;
  setup, overlap, duration : double;
  TmpEndDate : TDateTime;
  MacSetupRec: TMacSetup;
  TimingInfo: TSQtimingInfo;
  ProdStep, WkcProc: String;
  MachSetupCodeList :TMQMMacSetupList;
  IssArtList: TMQMIssuedArtList;
  FrmMat: TFMaterialReq;
  info:  TSQStartEndInfo;
  ActArea  : TMqmActArea;
  TimeOfFamilyBeforeId : double;
  SavedOrigStart : TdateTime;
begin
  List := nil;
  m_GrpSchedList := TMSchedList.Create(self);
  id := TSchedId(m_popObj);

  p_sc.GetStartEndInfo(id, info);
  SavedOrigStart := info.startDate;

  p_sc.GetFldValue(id, CSC_QtyToSched, JobQtyValue, dataType);
  JobQty := JobQtyValue;

  SplitQty := JobQty;
  Ptr := p_sc.GetExtLinkPtr(Id);
  Res := TMqmVisibleRes(TMqmActArea(ptr).p_Father);

  p_sc.GetPlanInfo(id, planInfo);
  if (p_sc.GetLearningCurveCode(Id) <> '') then
  begin
    ActArea := p_sc.GetExtLinkPtr(Id);
    TimeOfFamilyBeforeId := ActArea.GetDurationOfAllJobsBeforeThisSpot(planInfo.startDate, Id);
    QtyAtDate := CalculateJobQuantityInBucket(Id, planInfo.startDate, m_popDate, 0, TimeOfFamilyBeforeId);
  end
  else
    QtyAtDate := p_sc.GetJobQtyAtDate(Id, Res, m_popDate);

  if QtyAtDate > JobQty then exit;

  SplitNo   := 1;
  QtyPerGrp := 0;

  MarkStack := -1;
  MarkStack := p_opStack.MarkStack;
  p_opStack.MarkStackForButtonUndo(_('Split scheduled Group On Gantt'));

  if TMenuItem(Sender).Name = 'MIUnscheduleRestGroupToBin' then
     TMenuItem(Sender).Tag := -1;

  CalcSplitQtyGrp(id, 0, SplitQty, SplitNo, QtyPerGrp, OrigGrpQty, EachGrpQty, NewGrpNr, Err);

  m_SplitGroupData.Id_Grp := id;
  m_SplitGroupData.SplitPercent := 1 - (QtyAtDate / JobQty);
  m_SplitGroupData.NewGrpNr := NewGrpNr;

  for I := 0 to p_sc.GetGrpNumSons(m_SplitGroupData.Id_Grp) - 1 do
  begin
    ChildId := p_sc.GetGrpSon(m_SplitGroupData.Id_Grp, I);
    p_sc.GetFldValue(ChildId, CSC_QtyToSched, value, dataType);
    JobQty := value;
    SplitQty := JobQty*m_SplitGroupData.SplitPercent;
    m_msgError := '';
    if not CalcSplitQtyGrp(ChildId,0,SplitQty, m_SplitGroupData.NewGrpNr, QtyPerJob, OrigJobQty, EachJobQty, NewJobNr, Err) then
    begin
      m_msgError := Err;
      break;
    end;

    p_opStack.SplitJob(ChildId, OrigJobQty, EachJobQty, NewJobNr, NewId, List);
    if I = 0 then
    begin
      for J := 0 to List.Count - 1 do
      begin
        p_opStack.CreateGroup(TSchedId(List[J]), m_Newgrp);
        m_GrpSchedList.AddLink(TschedId(m_Newgrp));
      end
    end
    else
    begin
      for J := 0 to List.count - 1 do
        p_opStack.AddJobToGroup(TSchedId(List[J]), TSchedId(m_GrpSchedList.GetLink(J)));
    end;
  end;

  if TMenuItem(Sender).Name = 'MiSplitGroupOnGantt' then
  begin
    p_pl.EnterCompatModeInPlanForSplit(Id);
    ObjMover := TMqmSchedObjMover.Create;
    ObjMover.SetObjToMove(id);

    if p_sc.GetRscComponentFromJobOrStep(id) > 0 then
      ResComp := p_sc.GetRscComponentFromJobOrStep(id)
    else
      ResComp := Res.p_ResComp;

    NewIdStartDate := info.startDate;
    ObjMover.ChangeToWithoutOrganize(TMqmActArea(ptr), NewIdStartDate, false, CSchedIDnull, Al_toDate, setup, overlap,
                         duration, '', TmpEndDate, OptsMover, nil, False, DeltaSetupObjToMove,false, ResComp);// = CSM_Yes then
    begin
    end;

    p_pl.ExitCompatModeInPlanForAutoSeq;

    p_sc.GetStartEndInfo(id, info);
    NewIdStartDate := info.endDate;

    p_pl.EnterCompatModeInPlanForSplit(m_Newgrp);
    ObjMover := TMqmSchedObjMover.Create;
    ObjMover.SetObjToMove(m_Newgrp);

    if p_sc.GetRscComponentFromJobOrStep(m_Newgrp) > 0 then
      ResComp := p_sc.GetRscComponentFromJobOrStep(m_Newgrp)
    else
      ResComp := Res.p_ResComp;

    ObjMover.ChangeToWithoutOrganize(TMqmActArea(ptr), NewIdStartDate, false, CSchedIDnull, Al_toDate, setup, overlap,
                         duration, '', TmpEndDate, OptsMover, nil, False, DeltaSetupObjToMove,false, ResComp);
    begin
    end;

    p_pl.ExitCompatModeInPlanForAutoSeq;
    if TMqmActArea(ptr).ReorganizeOcc(id, False, OptsMover, DeltaSetupObjToMove, nil, SavedOrigStart) <> CSM_Yes then
    begin
      p_opStack.UndoTo(MarkStack);
    end;

  end
  else
  begin
    if TMenuItem(Sender).Name = 'MIUnscheduleRestGroupToBin' then
       TMenuItem(Sender).Tag := 0;

    p_pl.EnterCompatModeInPlanForSplit(Id);
    ObjMover := TMqmSchedObjMover.Create;
    ObjMover.SetObjToMove(id);

    if p_sc.GetRscComponentFromJobOrStep(id) > 0 then
      ResComp := p_sc.GetRscComponentFromJobOrStep(id)
    else
      ResComp := Res.p_ResComp;

    NewIdStartDate := info.startDate;
    if ObjMover.ChangeTo(TMqmActArea(ptr), NewIdStartDate, false, CSchedIDnull, Al_toDate, setup, overlap,
                         duration, '', TmpEndDate, OptsMover, nil, False, DeltaSetupObjToMove,false, ResComp) = CSM_Yes then
    begin
    end
    else
      ObjMover.Abort;

    p_pl.ExitCompatModeInPlanForAutoSeq;

  end;

  Fbin.UpdateForChangeFilter;
  FBin.GetActiveView.Refresh;
  FBin.ChangeTabBinforChangeTabPlan;
  GetPlanView.RefreshActiveTab;
  FMQMPlan.ActiveUndo;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.SetDynamcMenuForAutoRunCodes;
var
  NewItem, MenuItemI : TMenuItem;
  I, J, K : Integer;
  CodesList : TStringList;
//  MyComp: TComponent;
begin
  try
  CodesList := TStringList.Create;
  GetAutoRunCodeList(CodesList);
  for I := 0 to MainMenu.Items.Count - 1 do     //   MiAutomaticOperation
  begin
    if (MainMenu.Items[I].Name = 'MiTools') then
    begin
      MenuItemI := MainMenu.Items[I];
      for J := 0 to MenuItemI.Count - 1 do
      begin
        if MenuItemI[J].Name = 'MiAutomaticOperation' then
        begin
          MenuItemI := MenuItemI[J];
          for K := MenuItemI.Count - 1 downto 0 do
            MenuItemI[K].free;
          for K := 0 to CodesList.Count - 1 do
          begin
            NewItem := TMenuItem.Create(Self);
            NewItem.Caption := CodesList[K];
          //  MyComp := FindComponent('MiAutomaticOperation' + IntToStr(K));
          //  if Assigned(MyComp) then
          //    MyComp.Free();
            NewItem.Name    := 'AutoOperation' + CodesList[K] + IntToStr(K);
            NewItem.OnClick := ClickAutoRunByCode;
            MenuItemI.add(NewItem);
          end;
          break
        end;
      end;
    end;
  end;
  CodesList.Free;

  except

  end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIRefreshExternalClick(Sender: TObject);
var
  NewItem : TMenuItem;
begin
  if IniAppGlobals.External_Database_Update = '1' then
  begin
    DMib.m_MainDB.Ping;  // will be catched by CommunicationException in case ping failed
    ExternalDB_DeleteAll_Req_change_OnMystation;
    ExternalDB_LoadAllStepsAndRequestsOnMyStation;
    if ExternalDB_LoopAllRequestHeaderFromPlan then
    begin
      //OperateRefreshButton;
      DBAppGlobals.MAINPLAN_Ignore_Save_Event := true;
      DBAppGlobals.MAINPLAN_Ignore_Pain_When_refresh := true;
      TFWait.CreateWaitForm(self, w_Refresh, nil).ShowModal;
      DBAppGlobals.MAINPLAN_Ignore_Pain_When_refresh := false;

      if DBAppGlobals.ShowColorJobMode = DinamicPropList then
      begin
        if (GetIdFromCode(DBAppGlobals.LastPropColorInUseJobMode) <> nil) then
        begin
          NewItem := TMenuItem.Create(Self);
          NewItem.VCLComObject := GetIdFromCode(DBAppGlobals.LastPropColorInUseJobMode);
          ClickShowBarColorDynamic(NewItem);
        end
      end;
    end;

  end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiReportfreeResourceClick(Sender: TObject);
var
  activeTab: integer;
  ConfTab: TPlanTabCfg;
begin
  activeTab := m_pgcPlan.GetActiveView.GetCode;
  ConfTab := TPlanTabCfg(m_planTbCfg.FindTab(activeTab));
  ExcelDynamicScheduleFreeResource(self, ConfTab.res);
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.IFilterBinBySlotClick(Sender: TObject);
begin
  if m_SelectedListWrkCtrPopUp.Count < 1 then exit;
  if PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_WkCtr = nil then exit;
//  Fbin.FilterJobsWcByDate(PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_WkCtr ,PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_lngDscSlot,  PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_startDt, PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_endDt - 1);
  if Assigned(Fbin) then
    Fbin.FilterJobsWcByDate(PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_WkCtr ,PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_lngDscSlot,  PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_startDt, PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_endDt - 1/24/3600);
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.IFilterBinBySlotPropClick(Sender: TObject);
var
  ts : TMqmPlanTabSheet;
  SlotGroup : Integer;
begin
  if m_SelectedListWrkCtrPopUp = nil then exit;
  if m_SelectedListWrkCtrPopUp.Count < 1 then exit;
  if PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_WkCtr = nil then exit;
  if not Assigned(Fbin) then exit;

  ts := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
  SlotGroup := ts.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup;

  // WC category slot — filter by resource category
  if PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_TypeSelected = slt_Wc_category then
  begin
    if SlotGroup > 0 then
      Fbin.FilterJobsWcGroupCategoryByDate(
        PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_WkCtr,
        PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_lngDscSlot,
        PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).s_PropertyValue,
        PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_startDt,
        PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_endDt - 1/24/3600)
    else
      Fbin.FilterJobsWcCategoryByDate(
        PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_WkCtr,
        PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_lngDscSlot,
        PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).s_PropertyValue,
        PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_startDt,
        PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_endDt - 1/24/3600);
    exit;
  end;

  if SlotGroup > 0 then
    // group mode (division/plant/WCGroup) — filter by group + property
    Fbin.FilterJobsWcGroupPropertyByDate(
      PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_WkCtr,
      PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_lngDscSlot,
      PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).s_PropertyCode,
      PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).s_PropertyValue,
      PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_startDt,
      PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_endDt - 1/24/3600)
  else
    // no grouping — filter by single WC + property
    Fbin.FilterJobsWcPropertyByDate(
      PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_WkCtr,
      PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_lngDscSlot,
      PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).s_PropertyCode,
      PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).s_PropertyValue,
      PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_startDt,
      PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_endDt - 1/24/3600);
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIStepDetailsClick(Sender: TObject);
var
  StepDetails : TFStepDetails;
begin
  StepDetails := TFStepDetails.CreateStepDetails(Self, TSchedId(m_popObj));
  StepDetails.ShowModal;
  StepDetails.Free
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.IViewAllAsWorkCnterCategoryClick(Sender: TObject);
var
  ts : TMqmPlanTabSheet;
  Save_Cursor : TCursor;
begin
  Save_Cursor   := Screen.Cursor;
  Screen.Cursor  := crAppStart; //SQLWait;
  ts := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
  p_pl.BuildWkcDailyEntityCapacity(ts.p_ganttPanel.p_VisResList, 1, '');
  ts.SetMcmWorkCenterCategory(true, '');
  ts.p_PlanWcControl.P_planWcView.RefreshPlan(true);
  Screen.Cursor := Save_Cursor;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.IViewAsWorkCnterCategoryClick(Sender: TObject);
var
  ts : TMqmPlanTabSheet;
  I,y : Integer;
  Wc, WrkCtr : TMqmWrkCtr;
  ResList : TList;
  Res : TMqmRes;
  VisRes : TMqmVisibleRes;
  TabCfg : TPlanTabCfg;
begin
  ts := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
  if assigned(TMqmWrkCtr(m_MqmWrkCtrPopUp)) then
  begin
    ResList := TList.Create;
    Wc := TMqmWrkCtr(m_MqmWrkCtrPopUp);
    for I := 0 to ts.p_ganttPanel.p_VisResList.Count - 1 do
    begin
      VisRes := TMqmVisibleRes(ts.p_ganttPanel.p_VisResList[i]);
      Res := TMqmRes(TMqmVisibleRes(VisRes).p_father);
      WrkCtr := TMqmWrkCtr(res.p_father);
      if TMqmWrkCtr(m_MqmWrkCtrPopUp) = WrkCtr then
         ResList.Add(VisRes);
    end;
    p_pl.BuildWkcDailyEntityCapacity(ResList  , 1, '');
    ts.SetMcmWorkCenterCategory(false, TMqmWrkCtr(m_MqmWrkCtrPopUp).p_WrkCtrCode);
    ts.p_PlanWcControl.P_planWcView.RefreshPlan(true);
    ResList.Free;
  end else
  if assigned(TPlanLineWCGroup(m_PlanLine)) then
  begin

    ResList := TList.Create;
    TabCfg := TPlanTabCfg(m_planTbCfg.FindTab(ts.GetCode));

    for I := 0 to TabCfg.GetWorkCenterList.Count -1  do
    begin
      Wc := TMqmWrkCtr(TabCfg.GetWorkCenterList[i]);

      if ts.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup = 1 then
      begin
        if WC.P_WcGrp <> TPlanLineWCGroup(m_PlanLine).p_Group_name then
          continue
      end else if ts.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup = 2 then
      begin
        if WC.p_PlantCode <> TPlanLineWCGroup(m_PlanLine).p_Group_name then
          continue
      end else if ts.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup = 3 then
      begin
        if WC.p_Division <> TPlanLineWCGroup(m_PlanLine).p_Group_name then
          continue;
      end;

      for y := 0 to ts.p_ganttPanel.p_VisResList.Count - 1 do
      begin
        VisRes := TMqmVisibleRes(ts.p_ganttPanel.p_VisResList[y]);
        Res := TMqmRes(TMqmVisibleRes(VisRes).p_father);
        WrkCtr := TMqmWrkCtr(res.p_father);
        if WC = WrkCtr then
          ResList.Add(VisRes);
      end;
    end;
    p_pl.BuildWkcDailyEntityCapacity(ResList  , 1, '');

    for I := 0 to TabCfg.GetWorkCenterList.Count -1  do
    begin
      Wc := TMqmWrkCtr(TabCfg.GetWorkCenterList[i]);

      if ts.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup = 1 then
      begin
        if WC.P_WcGrp <> TPlanLineWCGroup(m_PlanLine).p_Group_name then
          continue
      end else if ts.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup = 2 then
      begin
        if WC.p_PlantCode <> TPlanLineWCGroup(m_PlanLine).p_Group_name then
          continue
      end else if ts.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup = 3 then
      begin
        if WC.p_Division <> TPlanLineWCGroup(m_PlanLine).p_Group_name then
          continue;
      end;

      ts.SetMcmWorkCenterCategory(false, Wc.p_WrkCtrCode);
    end;


    ts.p_PlanWcControl.P_planWcView.RefreshPlan(true);
    ResList.Free;

  end;
end;

procedure TFMQMPlan.IWcDleteTabClick(Sender: TObject);
begin
  ICloseTbsClick(self);
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.IwkcDetailsClick(Sender: TObject);
var
  FWkcDetails: TFWkcDetails;
begin
  if assigned(m_MqmWrkCtrPopUp) then
  begin
    FWkcDetails := TFWkcDetails.CreateWkcDet(self, TMqmWrkCtr(m_MqmWrkCtrPopUp));
    FWkcDetails.ShowModal;
    FWkcDetails.Free
  end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIExitClick(Sender: TObject);
begin
  close;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.TBResourcesClick(Sender: TObject);
var
  ResFilter: TFResFilter;
  Mcm, FoundName : boolean;
  J, I : Integer;
  TmpName , TabName, Value : string;
  TabCfg : TPlanTabCfg;
  ts : TMqmPlanTabSheet;
begin
  if ((GetOccMoveForm <> nil) or (GetDownTimeForm <> nil)) then exit;
  Mcm := false;
  if DBAppGlobals.MCM_App then
    Mcm := true;

  J := 0;
  TabName := _('Plan view');
  TmpName := _('Plan view');
  FoundName := false;

  for i := m_pgcPlan.PageCount -1 downto 1 do
  begin
    ts := TMqmPlanTabSheet(FMQMPlan.m_pgcPlan.Pages[i]);
    TabCfg := TPlanTabCfg(FMQMPlan.m_planTbCfg.FindTab(ts.GetCode));
    if TabName = Copy(trim(TabCfg.name),0,9) then
    begin
      FoundName := true;
      Value := Copy(Trim(TabCfg.name), 11,1);
      if Trim(Value) <> '' then
      begin
        J := StrToIntDef(Value, 0);
        if J > 0 then
          J := StrToInt(Value);
      end;
      inc(J);
      TabName := TmpName + ' ' + IntToStr(J);
    //  break;
    end;
  end;

  if not FoundName then
    TabName := _('Plan view');

  ResFilter := TFResFilter.CreateFrmResFilter(self, Mcm, TabName);
  if ResFilter.ShowModal = mrOk then
  begin
    AddTabWithList(ResFilter.P_GetTabName, ResFilter.GetReslist, PNormal, ResFilter.P_SlotGoup);
    RefreshWkcGroup;
  end;

  {  var
  TabName : string;
  ResListObj : TList;
begin
  if assigned(Fbin) then
  begin
    if Fbin.GetResListForActiveTab(false, ResListObj, TabName) then
      AddTabWithList(TabName, ResListObj, PNormal);
  end;
end;}
  PgcMainChange(self);
//  ResFilter.Free
end;

procedure TFMQMPlan.TBShowCalClick(Sender: TObject);
begin

end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MICrtCapResClick(Sender: TObject);
begin
  OpenCapResForm(self, nil, RefreshAfterMove, FMQMPlan, nil, m_popDate);
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIDailyMachineReportClick(Sender: TObject);
begin
  UMReports.PeriodMachineReport(self);
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiDateCustomizeClick(Sender: TObject);
var
  DatesCustomize: TDatesCustomize;
begin
  DatesCustomize := TDatesCustomize.CreateCustomizeDate(self);
  DatesCustomize.ShowModal;
  DatesCustomize.free;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiDateCustomizeGap1Click(Sender: TObject);
var
  DatesCustomize: TDatesCustomizeGap;
begin
  DatesCustomize := TDatesCustomizeGap.CreateCustomizeDateGap(self, 2);
  DatesCustomize.ShowModal;
  DatesCustomize.free;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiDateCustomizeGap3Click(Sender: TObject);
var
  DatesCustomize: TDatesCustomizeGap;
begin
  DatesCustomize := TDatesCustomizeGap.CreateCustomizeDateGap(self, 3);
  DatesCustomize.ShowModal;
  DatesCustomize.free;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIApaCrtCapResClick(Sender: TObject);
var
  ActivePlanningArea: TMqmActArea;
begin
  ActivePlanningArea := TMqmActArea(m_popObj);
  OpenCapResForm(self, nil, RefreshAfterMove, FMQMPlan, ActivePlanningArea, m_popDate);
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIApaCrtDownTimeClick(Sender: TObject);
begin
  OpenDownTimeForm(self, nil, RefreshAfterMove, FMQMPlan, TMqmActArea(m_popObj), m_popDate)
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.PupActAreaPopup(Sender: TObject);
var
  I: integer;
  TabCfg : TPlanTabCfg;
  TabName : string;
  ResListObj : TList;
  ActTab : TBinTabSheet;
begin
  for I := 0 to PupActArea.Items.Count - 1 do
  begin
    PupActArea.Items[I].Enabled := true;
    PupActArea.Items[I].Visible := true;
  end;

  MIApaEditPlan.Enabled := TPlanTabCfg(m_planTbCfg.FindTab(m_pgcPlan.GetActiveView.GetCode)).m_PlanType = PNormal;
  MISortresourcesby.Enabled := TPlanTabCfg(m_planTbCfg.FindTab(m_pgcPlan.GetActiveView.GetCode)).m_PlanType = PNormal;
  if DBAppSettings.DisableCapRes then
    MIApaCrtCapRes.Visible := false;

  MiStandardSettings.Checked := false;
  MiPropertyPreDefinedTab.Checked := false;
  MiPropertyDynamicTab.Checked := false;
  MiScheduleStatusTab.Checked := false;
  TabCfg := TPlanTabCfg(m_planTbCfg.FindTab(m_pgcPlan.GetActiveView.GetCode));
  if (TabCfg.m_ShowColorJobMode = PreDefinedPropList) then
  begin
    MiPropertyPreDefinedTab.Checked := true;
    SetCheckedCurrentPropertyColoredDynamicTab(true, nil);
    SetCheckedCurrentPropertyColoredPreDefinedTab(false, GetIdFromCode(TabCfg.m_PropertyCode));
  end
  else if (TabCfg.m_ShowColorJobMode = DinamicPropList) then
  begin
    MiPropertyDynamicTab.Checked := true;
    SetCheckedCurrentPropertyColoredDynamicTab(false, GetIdFromCode(TabCfg.m_PropertyCode));
    SetCheckedCurrentPropertyColoredPreDefinedTab(true, nil);
  end
  else if (TabCfg.m_ShowColorJobMode = ScheduleStatus) then
  begin
    MiScheduleStatusTab.Checked := true;
    SetCheckedCurrentPropertyColoredDynamicTab(true, nil);
    SetCheckedCurrentPropertyColoredPreDefinedTab(true , nil);
  end else

  begin
    SetCheckedCurrentPropertyColoredDynamicTab(true, nil);
    SetCheckedCurrentPropertyColoredPreDefinedTab(true , nil);
    MiStandardSettings.Checked := true;
  end;

  MiCreateNewTabFromBinResources.Visible := true;
  MiUpdateTabUsingBinResource.Visible := true;
  if assigned(Fbin) and not Fbin.GetResListForActiveTab(true, ResListObj, TabName) then
  begin
    MiCreateNewTabFromBinResources.Visible := false;
    MiUpdateTabUsingBinResource.Visible := false;
  end;

  if (GetCalculatedHighDateProp <> nil) then
    MiSetjobslimitdates.Visible := true
  else
    MiSetjobslimitdates.Visible := false;

  if DBAppGlobals.MCM_App and (IniAppGlobals.MCMasMQM = 0) then
  begin
    for I := 0 to PupActArea.Items.Count - 1 do
      PupActArea.Items[I].Visible := false;
    MISortresourcesby.Visible := true
  end
  else
  begin
    if Assigned(FBin) then
    begin
      MiScheduleJobBySequence.Visible := false;
      ActTab := FBin.GetActiveView;
      if Assigned(ActTab) and not (ActTab.m_BinPanel.GetFiltParms.P_MaterialSchedFilter) and (ActTab.m_BinPanel.p_Grid.Get_Job_Sequence_List_Count > 0) then
        MiScheduleJobBySequence.Visible := true;
    end;
  end;

  SetVisibilityForPopup(Sender);

end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIShowCalShapesClick(Sender: TObject);
var
  sh: TShapeManager;
begin
  sh := TMqmPlanTabSheet(m_pgcPlan.GetActiveView).p_shapeMan;
  if Assigned(sh) then
  begin
    if sh.m_CalHigh then
      sh.SetCalLow
    else
      sh.SetCalHigh;
    sh.Update
  end
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiWarpShowCompatibleInBinClick(Sender: TObject);
var
  MqmActArea : TMqmActArea;
  IdWarp : TschedId;
  ProdTypeBaseLvl : string;
  ProdTypeSecondLvl : string;
  ProductBaseLvl : string;
  ProductSecondLvl : string;
  WarpLvl : ArMaterialScheduleLvl;
  WarpObj, WarpObjB  : TMqmWarp;
begin
  MqmActArea := TMqmActArea(TMqmWarp(m_popObj).p_father);
  if assigned(MqmActArea) then
  begin
    WarpObj := TMqmWarp(MqmActArea.FindWarpCovering(m_popDate, nil));
    if WarpObj <> nil then
    begin
      IdWarp := WarpObj.Get_M_id;
      WarpLvl := p_sc.GetWarp_Levl_Material(IdWarp);
      if WarpLvl = MT_BaseLvl then
        p_sc.GetWarp_ProdType_Product_Levl_Belong(IdWarp,ProdTypeBaseLvl,ProductBaseLvl)
      else if WarpLvl = MT_SecondLvl then
        p_sc.GetWarp_ProdType_Product_Levl_Belong(IdWarp,ProdTypeSecondLvl,ProductSecondLvl);
    end;

    WarpObjB := TMqmWarp(MqmActArea.FindWarpCovering(m_popDate, WarpObj));
    if (WarpObjB <> nil) and (WarpObj <> WarpObjB) then
    begin
      IdWarp := WarpObjB.Get_M_id;
      WarpLvl := p_sc.GetWarp_Levl_Material(IdWarp);
      if WarpLvl = MT_BaseLvl then
        p_sc.GetWarp_ProdType_Product_Levl_Belong(IdWarp,ProdTypeBaseLvl,ProductBaseLvl)
      else if WarpLvl = MT_SecondLvl then
        p_sc.GetWarp_ProdType_Product_Levl_Belong(IdWarp,ProdTypeSecondLvl,ProductSecondLvl);
    end;

    FBin.Showcompatibleforwarp(ProdTypeBaseLvl,ProductBaseLvl,ProdTypeSecondLvl,ProductSecondLvl);

  end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.TrcBarStatusChange(Sender: TObject);
var
  Position : real;
  FontSize : Integer;
begin

  if (m_planTbCfg.p_GetTabsCount > 0) then
  begin
    Position := TMqmPlanTabSheet(m_pgcPlan.GetActiveView).p_HeaderMan.m_CalPanel.FStatusZoom.Position;
    FontSize := Trunc(Position / 3);

    if FontSize < 9  then
      FontSize := 9;

    TPlanTabCfg(m_planTbCfg.FindTab(m_pgcPlan.GetActiveView.GetCode)).m_SZoom := TMqmPlanTabSheet(m_pgcPlan.GetActiveView).p_HeaderMan.m_CalPanel.FStatusZoom.Position;
    TMqmPlanTabSheet(m_pgcPlan.GetActiveView).p_HeaderMan.m_StatusPanel.Height := TMqmPlanTabSheet(m_pgcPlan.GetActiveView).p_HeaderMan.m_CalPanel.FStatusZoom.Position;
    TMqmPlanTabSheet(m_pgcPlan.GetActiveView).p_HeaderMan.m_StBarInfo.Font.size :=  FontSize;  //FONT SIZE
  end;

end;

procedure TFMQMPlan.TrcBarZoomChange(Sender: TObject);
var
  Position : integer;
begin
  if not assigned(m_pgcPlan) then exit;
  if TMqmPlanTabSheet(m_pgcPlan.GetActiveView) = nil then exit;

  if Sender is TTrackBar then
  begin
  //  TrcBarZoom.Position := TTrackBar(Sender).Position;
  end;

  if (m_planTbCfg.p_GetTabsCount > 0) then
  begin
    TMqmPlanTabSheet(m_pgcPlan.GetActiveView).p_zoom := TMqmPlanTabSheet(m_pgcPlan.GetActiveView).p_HeaderMan.m_CalPanel.FResourceTrcBarZoom.Position;
  //  StSizePercent.Caption := IntToStr((TMqmPlanTabSheet(m_pgcPlan.GetActiveView).p_zoom) * 5) + '%';

    TMqmPlanTabSheet(m_pgcPlan.GetActiveView).p_HeaderMan.m_CalPanel.FResourceBarZoomShape.m_ResourceZoom_Val :=
      (TMqmPlanTabSheet(m_pgcPlan.GetActiveView).p_zoom) * 5;

    TMqmPlanTabSheet(m_pgcPlan.GetActiveView).p_HeaderMan.m_CalPanel.FResourceBarZoomShape.repaint
  end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIGrpDetailsClick(Sender: TObject);
begin
  HandleGroup(self, TSchedId(m_popObj), false, -1, false)
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIConfigClick(Sender: TObject);
var
  fOptions: TFOptions;
begin
  fOptions := TFOptions.Create(Self);
  if fOptions.ShowModal = mrOk then
  begin
    if fOptions.IsCustomPropChanged and CheckIfActiveGanttTabIsMcm then
      RefreshMcmActiveGanttTab;
    m_pgcPlan.MultiLine := DBAppSettings.GanttMultiLineTab;
    if Assigned(FBin) then
       FBin.SetMultilineTabs(DBAppSettings.BinMultiLineTab);
  end;

  fOptions.free;
  RefreshActiveTab;
  RefreshMcmActiveGanttTab;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiCreateNewTabFromBinResourcesClick(Sender: TObject);
var
  TabName : string;
  ResListObj : TList;
begin
  if assigned(Fbin) then
  begin
    if Fbin.GetResListForActiveTab(false, ResListObj, TabName) then
      AddTabWithList(TabName, ResListObj, PNormal,0);
  end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MICompatInBinClick(Sender: TObject);
var
  res:      TMqmRes;
  iter:     TMSchedContIterator;
  id:       TSchedId;
  linkInfo: TSQlinkInfo;
  CompVal:  TCompatVal;
  visRes:   TMqmVisibleRes;
  Dependency : boolean;
begin
  p_pl.ExitCompatModeInBin;
  p_sc.SetAllFlags([CSF_compInBin], []);
  visRes := TMqmVisibleRes(m_popObj);
  p_pl.EnterCompatModeInBin(visRes);
  res := TMqmRes(visRes.p_father);

  if DBAppSettings.CreateNewBinTabForCompatibles <> NewB_No then
     FBin.CreateTempSeqTab(res.p_ResCode);

  iter := TMSchedContIterator.CreateScIter(p_sc);
  while true do
  begin
    id := iter.GetNext;
    if id = CSchedIdNull then break;
    if (not p_sc.GetLinkInfo(id, linkInfo)) or
       linkInfo.isOnPlan                    or
      // linkInfo.isGroup                     or
      // (linkInfo.grpId <> CSchedIdNull)     or
       (not res.CheckCompatWithOcc([cho_compVal, cho_wkc, cho_readOnly, cho_qty, cho_Depend],
                                   id, Now, nil, compVal, Dependency)) then
      p_sc.SetFlags(id, [CSF_compInBin], [])
    else
    begin
      p_sc.SetFlags(id, [], [CSF_compInBin]);
      p_sc.SetCompatWithRes(id, compVal)
    end
  end;

  RefreshActiveTab;
  FBin.RefreshGrid
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIClearCompInBinClick(Sender: TObject);
begin
  p_pl.ExitCompatModeInBin;
  p_sc.SetAllFlags([CSF_compInBin], []);

  RefreshActiveTab;
  FBin.RefreshGrid
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.IClearSecondLevlClick(Sender: TObject);
var
  ts : TMqmPlanTabSheet;
begin
  ts := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
  if assigned(TPlanLineWCGroup(m_PlanLine)) then
    ts.ClearMcmSecondLvlGroup(True, TPlanLineWCGroup(m_PlanLine))
  else
    ts.ClearMcmSecondLvl(true, '');

end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.IClearSeconLvlClick(Sender: TObject);
var ts : TMqmPlanTabSheet;
    TabCfg : TPlanTabCfg;
    i : Integer;
    WC : TMqmWrkCtr;
begin
  ts := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
  if assigned(TMqmWrkCtr(m_MqmWrkCtrPopUp)) then
    ts.ClearMcmSecondLvl(false, TMqmWrkCtr(m_MqmWrkCtrPopUp).p_WrkCtrCode)
  else if assigned(TPlanLineWCGroup(m_PlanLine)) then
    ts.ClearMcmSecondLvlGroup(false, TPlanLineWCGroup(m_PlanLine));

end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIShowBinClick(Sender: TObject);
begin
  if not assigned(FBin) then
  begin
    FBin := TFBin.Create(self);
    if not DBAppGlobals.MCM_App then
       GeneratePopupMenus;
    FBin.Show;
    fbin.ChangeTabBinforChangeTabPlan;
  end else
    BringWindowToTop(Fbin.Handle);
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIDelCapResClick(Sender: TObject);
var
  act:     TMqmActArea;
  opStack: TOpStack;
begin
  act := TMqmActArea(TMqmCapRes(m_popObj).p_father);
  Assert(Assigned(act));
  opStack := TOpStack.CreateStack;
  opStack.DelePlanObjFromApa(TMqmDurObj(m_popObj), act);
  opStack.Free;
  act.ReorganizeAllOcc(true);
  RefreshActiveTab;
  FBin.ChangeTabBinforChangeTabPlan;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiUnscheduleWarpClick(Sender: TObject);
var
  act:     TMqmActArea;
  opStack: TOpStack;
begin
  act := TMqmActArea(TMqmWarp(m_popObj).p_father);
  Assert(Assigned(act));
  opStack := TOpStack.CreateStack;
  p_opStack.MarkStackForButtonUndo(_('Unschedule'));
  p_opStack.DetachPlanObjFromApa(TMqmWarp(m_popObj));
  TMqmWarp(m_popObj).m_status := CDUR_del;
  p_pl.AddObjToDele(TMqmWarp(m_popObj));
  opStack.Free;
  act.ReorganizeAllOcc(true);
  RefreshActiveTab;
  FBin.ChangeTabBinforChangeTabPlan;
  FMQMPlan.ActiveUndo;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIJobHandleClick(Sender: TObject);
var
  JobHandle : TFJobHandle;
  ProdNo : string;
  Step, ResComp : integer;
  SchedIdsList : TMSchedList;
  J : Integer;
  ObjMover : TMqmSchedObjMover;
  Res : TMqmVisibleRes;
  DatesInfo: TSQDatesInfo;
  setup, overlap, duration, DeltaSetupObjToMove : double;
  TmpEndDate : TDateTime;
  OptsMover : SetOptsMover;
  moveChgInfo: TSQmoveChgInfo;
begin
  JobHandle := TFJobHandle.CreateJobHandle(Self, TSchedId(m_popObj));
  if JobHandle.ShowModal = mrOk then
  begin
    SchedIdsList := TMSchedList.Create(self);
    ProdNo := p_sc.GetFldDescr(TSchedId(m_popObj), CSC_ProdReq, false);
    Step := StrToInt(p_sc.GetFldDescr(TSchedId(m_popObj), CSC_ProdStep, false));
    p_sc.GetStepJobs(ProdNo, Step, SchedIdsList);
    for J := 0 to SchedIdsList.GetLinkCount - 1 do
    begin
      if p_sc.GetExtLinkPtr(SchedIdsList.GetLink(J)) <> nil then
      begin
      OccMoveEnter(FMQMPlan, Pointer(SchedIdsList.GetLink(J)));
      ObjMover := TMqmSchedObjMover.Create;
      ObjMover.SetObjToMove(SchedIdsList.GetLink(J));
      Res := TMqmVisibleRes(TMqmActArea(p_sc.GetExtLinkPtr(SchedIdsList.GetLink(J))).p_Father);
      p_sc.GetDatesInfo(SchedIdsList.GetLink(J), DatesInfo);
      p_sc.GetMoveChgInfo(SchedIdsList.GetLink(J), moveChgInfo);
      if p_sc.GetRscComponentFromJobOrStep(SchedIdsList.GetLink(J)) > 0 then
        ResComp := p_sc.GetRscComponentFromJobOrStep(SchedIdsList.GetLink(J))
      else
        ResComp := moveChgInfo.numOfRscComp; //ResComp := Res.p_ResComp;
      if ObjMover.ChangeTo(TMqmActArea(p_sc.GetExtLinkPtr(SchedIdsList.GetLink(J))), DatesInfo.startDate , false, CSchedIDnull, Al_toDate, setup, overlap,
                           duration, '', TmpEndDate, OptsMover, nil, False, DeltaSetupObjToMove,false, ResComp) = CSM_Yes then
      begin
      end
      else
        ObjMover.Abort;
      OccMoveExit(FMQMPlan, true);
      end;
    end
  end;
  JobHandle.Free
end;

//----------------------------------------------------------------------------//


function TFMQMPlan.GetActiveTab:TMqmPlanTabSheet;
begin
  Assert(Assigned(m_pgcPlan));
  Result := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIResSchedExcelReportclick(Sender: TObject);
var
  ActWcList : TList;
begin
  ActWcList := TList.Create;
  GetListForActPlanTab(ActWcList);
  ExcelDynamicScheduleReport(self, ActWcList);
  ActWcList.Free;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIResSchedHtmlReportclick(Sender: TObject);
var
  ActWcList : TList;
begin
  ActWcList := TList.Create;
  GetListForActPlanTab(ActWcList);
  HtmlDynamicScheduleReport(self, ActWcList);
  ActWcList.Free;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MISetPropertyToAllWcClick(Sender: TObject);
var
  PropCode, PropDesc : string;
  NewItem  : TMenuItem;
  ts : TMqmPlanTabSheet;
  Save_Cursor : TCursor;
begin
  Save_Cursor   := Screen.Cursor;
  Screen.Cursor  := crSQLWait;
  NewItem := TMenuItem(Sender);
  PropCode := GetPropCodeFromID(NewItem.VCLComObject);
  PropDesc := GetPropDescr(NewItem.VCLComObject);
  ts := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
  p_pl.BuildWkcDailyEntityCapacity(ts.p_ganttPanel.p_VisResList, 2, PropCode);
  ts.SetMcmPropertySelection(true, '', PropCode, PropDesc, '');
  ts.p_PlanWcControl.P_planWcView.RefreshPlan(true);
  Screen.Cursor := Save_Cursor;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MISetPropertyToWcClick(Sender: TObject);
var
  PropCode, PropDesc : string;
  NewItem  : TMenuItem;
  ts : TMqmPlanTabSheet;
  Wc, WrkCtr : TMqmWrkCtr;
  I, y : Integer;
  ResList : TList;
  Res : TMqmRes;
  VisRes : TMqmVisibleRes;
  TabCfg : TPlanTabCfg;
begin
  NewItem := TMenuItem(Sender);
  PropCode := GetPropCodeFromID(NewItem.VCLComObject);
  PropDesc := GetPropDescr(NewItem.VCLComObject);
  ts := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
  if assigned(TMqmWrkCtr(m_MqmWrkCtrPopUp)) then
  begin
    ResList := TList.Create;
    Wc := TMqmWrkCtr(m_MqmWrkCtrPopUp);
    for I := 0 to ts.p_ganttPanel.p_VisResList.Count - 1 do
    begin
      VisRes := TMqmVisibleRes(ts.p_ganttPanel.p_VisResList[i]);
      Res := TMqmRes(TMqmVisibleRes(VisRes).p_father);
      WrkCtr := TMqmWrkCtr(res.p_father);
      if TMqmWrkCtr(m_MqmWrkCtrPopUp) = WrkCtr then
         ResList.Add(VisRes);
    end;
    p_pl.BuildWkcDailyEntityCapacity(ResList, 2, PropCode);
    ts.SetMcmPropertySelection(false, TMqmWrkCtr(m_MqmWrkCtrPopUp).p_WrkCtrCode, PropCode, PropDesc, '');
    ts.p_PlanWcControl.P_planWcView.RefreshPlan(true);
    ResList.Free;
  end else
  if assigned(TPlanLineWCGroup(m_PlanLine)) then
  begin

    ResList := TList.Create;
    TabCfg := TPlanTabCfg(m_planTbCfg.FindTab(ts.GetCode));

    for I := 0 to TabCfg.GetWorkCenterList.Count -1  do
    begin
      Wc := TMqmWrkCtr(TabCfg.GetWorkCenterList[i]);

      if ts.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup = 1 then
      begin
        if WC.P_WcGrp <> TPlanLineWCGroup(m_PlanLine).p_Group_name then
          continue
      end else if ts.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup = 2 then
      begin
        if WC.p_PlantCode <> TPlanLineWCGroup(m_PlanLine).p_Group_name then
          continue
      end else if ts.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup = 3 then
      begin
        if WC.p_Division <> TPlanLineWCGroup(m_PlanLine).p_Group_name then
          continue;
      end;

      for y := 0 to ts.p_ganttPanel.p_VisResList.Count - 1 do
      begin
        VisRes := TMqmVisibleRes(ts.p_ganttPanel.p_VisResList[y]);
        Res := TMqmRes(TMqmVisibleRes(VisRes).p_father);
        WrkCtr := TMqmWrkCtr(res.p_father);
        if WC = WrkCtr then
          ResList.Add(VisRes);
      end;
    end;
    p_pl.BuildWkcDailyEntityCapacity(ResList  , 2, PropCode);

    for I := 0 to TabCfg.GetWorkCenterList.Count -1  do
    begin
      Wc := TMqmWrkCtr(TabCfg.GetWorkCenterList[i]);

      if ts.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup = 1 then
      begin
        if WC.P_WcGrp <> TPlanLineWCGroup(m_PlanLine).p_Group_name then
          continue
      end else if ts.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup = 2 then
      begin
        if WC.p_PlantCode <> TPlanLineWCGroup(m_PlanLine).p_Group_name then
          continue
      end else if ts.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup = 3 then
      begin
        if WC.p_Division <> TPlanLineWCGroup(m_PlanLine).p_Group_name then
          continue;
      end;
      ts.SetMcmPropertySelection(false, WC.p_WrkCtrCode, PropCode, PropDesc, '');
    end;

    ts.p_PlanWcControl.P_planWcView.RefreshPlan(true);
    ResList.Free;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiSetSavedScheduleDateClick(Sender: TObject);
var
  ActTab : TMqmPlanTabSheet;
begin
  ActTab := GetActiveTab;
  if assigned(ActTab) then
  begin
    p_pl.SetSavedScheduleDate(ActTab.p_ganttPanel.p_VisResList);
    if (TMenuItem(Sender).name = 'MiSetSavedScheduleDate') and Assigned(FBin) then
       FBin.ChangeTabBinforChangeTabPlan;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIRestOnGanttClick(Sender: TObject);
var
  NewCreatedId : TSchedId;
  RoundType : RoundToType;
  NumOfDec : Integer;
begin
  RoundType := NON;
  NumOfDec := 0;
  if (iniAppGlobals.SplitFromPointRoundCrit = '') or (iniAppGlobals.SplitFromPointRoundCrit = '0') then
    RoundType := Up
  else if (iniAppGlobals.SplitFromPointRoundCrit = '1') then
    RoundType := Down;
  if iniAppGlobals.SplitFromPointNumOfDec = '1' then
    NumOfDec := 1
  else if iniAppGlobals.SplitFromPointNumOfDec = '2' then
    NumOfDec := 2;
  SplitFromDatePoint(TSchedId(m_popObj), m_popDate, false, false, NewCreatedId, RoundType, NumOfDec);
  RefreshAfterMove(self)
end;

procedure TFMQMPlan.MIAutoSchedCfgClick(Sender: TObject);
var
  AutoSchedCfg : TFAutoSchedCfg;
begin
  AutoSchedCfg := TFAutoSchedCfg.CreateAutoSchedCfg(self);
  if AutoSchedCfg.ShowModal = mrok then
    AutoSchedCfg.Free;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIAutoSchedSettingsClick(Sender: TObject);
//var
//  AutoSchedCfg : TFAutoSchedCfg;
begin
//  AutoSchedCfg := TFAutoSchedCfg.CreateAutoSchedCfg(self);
//  AutoSchedCfg.ShowModal;
//  AutoSchedCfg.Free;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIAutoSchedWcCfgClick(Sender: TObject);
var
  AutoSchedWcCfg: TFAutoSchedWcCfg;
begin
  AutoSchedWcCfg := TFAutoSchedWcCfg.CreateAutoSchedWcCfg(self);
  AutoSchedWcCfg.ShowModal;
  AutoSchedWcCfg.free
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIEnglishClick(Sender: TObject);
begin
  UseLanguage ('en');
  ReTranslateComponent (self);
  UpdateCaptions;
  DBAppGlobals.Language := 'en';
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiExcelReportClick(Sender: TObject);
var
  ReportForm: TFExcelReport;
begin
  ReportForm := TFExcelReport.CreateExcelSettings(self);
  ReportForm.ShowModal;
  ReportForm.Free;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIRussianClick(Sender: TObject);
begin
  UseLanguage ('ru');
  ReTranslateComponent (self);
  UpdateCaptions;
  DBAppGlobals.Language := 'ru';
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIItalianClick(Sender: TObject);
begin
  UseLanguage ('it');
  ReTranslateComponent (self);
  UpdateCaptions;
  DBAppGlobals.Language := 'it';
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIChineseClick(Sender: TObject);
begin
  UseLanguage ('zh');
  ReTranslateComponent (self);
  UpdateCaptions;
  DBAppGlobals.Language := 'zh';
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MITurkishClick(Sender: TObject);
begin
  UseLanguage ('tr');
  ReTranslateComponent (self);
  UpdateCaptions;
  DBAppGlobals.Language := 'tr';
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MISpanishClick(Sender: TObject);
begin
  UseLanguage ('es');
  ReTranslateComponent (self);
  UpdateCaptions;
  DBAppGlobals.Language := 'es';
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiGermanClick(Sender: TObject);
begin
  UseLanguage ('de');
  ReTranslateComponent (self);
  UpdateCaptions;
  DBAppGlobals.Language := 'de';
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiSpeedChangeClick(Sender: TObject);
var
  SpeedMachine : TSpeedMachine;
  MqmActArea : TMqmActArea;
  ProdNo : string;
  Step, J : integer;
  SchedIdsList : TMSchedList;
  OrganizeDone : boolean;
begin
  OrganizeDone := false;
  SpeedMachine := TSpeedMachine.CreateSpeedMachine(self , TSchedId(m_popObj));

  if SpeedMachine.ShowModal = mrok then
  begin
    SchedIdsList := TMSchedList.Create(self);
    ProdNo := p_sc.GetFldDescr(TSchedId(m_popObj), CSC_ProdReq, false);
    Step := StrToInt(p_sc.GetFldDescr(TSchedId(m_popObj), CSC_ProdStep, false));
    p_sc.GetStepJobs(ProdNo, Step, SchedIdsList);
    for J := 0 to SchedIdsList.GetLinkCount - 1 do
    begin
      if p_sc.GetExtLinkPtr(SchedIdsList.GetLink(J)) <> nil then
      begin
        MqmActArea := TMqmActArea(p_sc.GetExtLinkPtr(SchedIdsList.GetLink(J)));
        if assigned(MqmActArea) then
        begin
          OrganizeDone := true;
          MqmActArea.ReorganizeAllOcc(true);
        end;
      end;
    end;
    if OrganizeDone then
    begin
      RefreshActiveTab;
      if assigned(FBin) then
        FBin.ChangeTabBinforChangeTabPlan
    end;
    SchedIdsList.Free;
  end;
  SpeedMachine.free;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiChangingCurveCodeClick(Sender: TObject);
var
  learningCurve : TlearningCurve;
  Id            : TSchedId;
  CurveCode     : string;
  MqmActArea    : TMqmActArea;
begin
  Id := TSchedId(m_popObj);
  CurveCode := p_sc.GetLearningCurveCode(Id);
  learningCurve := TlearningCurve.CreateLearnCurveCng(self, CurveCode);
  if learningCurve.ShowModal = mrOk then
    p_sc.SetLearningCurveCode(Id,learningCurve.GetNewCurveCode);

  MqmActArea := TMqmActArea(p_sc.GetExtLinkPtr(Id));
  if assigned(MqmActArea) then
    MqmActArea.ReorganizeAllOcc(true);
  RefreshActiveTab;
  FBin.ChangeTabBinforChangeTabPlan;
  learningCurve.Free;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiRemoveCurveCodeClick(Sender: TObject);
var
  Id            : TSchedId;
  CurveCode     : string;
  MqmActArea    : TMqmActArea;
begin
  Id := TSchedId(m_popObj);
  CurveCode := p_sc.GetLearningCurveCode(Id);
  if (CurveCode <> '') then
    p_sc.SetLearningCurveCode(Id,'');
  MqmActArea := TMqmActArea(p_sc.GetExtLinkPtr(Id));
  if assigned(MqmActArea) then
    MqmActArea.ReorganizeAllOcc(true);
  RefreshActiveTab;
  FBin.ChangeTabBinforChangeTabPlan;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiSpeedChangeWarpClick(Sender: TObject);
var
  SpeedMachine : TSpeedMachine;
  MqmActArea : TMqmActArea;
begin
  SpeedMachine := TSpeedMachine.CreateSpeedWarpMachine(self , TMqmWarp(m_popObj), TMqmWarp(m_popObj).Get_M_id);
  if SpeedMachine.ShowModal = mrok then
  begin
    MqmActArea := TMqmActArea(TMqmWarp(m_popObj).p_father);
    if assigned(MqmActArea) then
    begin
      MqmActArea.ReorganizeWarpMain(TMqmWarp(m_popObj).p_start, false);
      RefreshActiveTab;
      if assigned(FBin) then
        FBin.ChangeTabBinforChangeTabPlan
    end;
  end;
  SpeedMachine.free
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiSplitBySelectedDateClick(Sender: TObject);
var
  SplitBySelectedDateTime : TSplitBySelectedDateTime;
begin
  SplitBySelectedDateTime := TSplitBySelectedDateTime.CreateSplitBySelectedDateTime(self, m_popDate);
  SplitBySelectedDateTime.ShowModal;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiSplitFromThisPointBehaviourClick(Sender: TObject);
begin
  //
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiSplitFromThisPointOnGanttClick(Sender: TObject);
var
  NewCreatedId : TSchedId;
  RoundType : RoundToType;
  NumOfDec : Integer;
begin
  RoundType := NON;
  NumOfDec := 0;
  if (iniAppGlobals.SplitFromPointRoundCrit = '') or (iniAppGlobals.SplitFromPointRoundCrit = '0') then
    RoundType := Up
  else if (iniAppGlobals.SplitFromPointRoundCrit = '1') then
    RoundType := Down;
  if iniAppGlobals.SplitFromPointNumOfDec = '1' then
    NumOfDec := 1
  else if iniAppGlobals.SplitFromPointNumOfDec = '2' then
    NumOfDec := 2;

  SplitFromDatePoint(TSchedId(m_popObj), Trunc(m_popDate) + StrToFloat(iniAppGlobals.SplitFromPointPreDefTime), false, false, NewCreatedId, RoundType, NumOfDec);
  RefreshAfterMove(self)
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiSplitFromThisPointRestToBinClick(Sender: TObject);
var
  NewCreatedId : TSchedId;
  RoundType : RoundToType;
  NumOfDec : Integer;
begin
  RoundType := NON;
  NumOfDec := 0;
  if (iniAppGlobals.SplitFromPointRoundCrit = '') or (iniAppGlobals.SplitFromPointRoundCrit = '0') then
    RoundType := Up
  else if (iniAppGlobals.SplitFromPointRoundCrit = '1') then
    RoundType := Down;
  if iniAppGlobals.SplitFromPointNumOfDec = '1' then
    NumOfDec := 1
  else if iniAppGlobals.SplitFromPointNumOfDec = '2' then
    NumOfDec := 2;

  SplitFromDatePoint(TSchedId(m_popObj), Trunc(m_popDate) + StrToFloat(iniAppGlobals.SplitFromPointPreDefTime), true, false, NewCreatedId, RoundType, NumOfDec);
  RefreshAfterMove(self)
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiSplitRemainGroupClick(Sender: TObject);
begin
  SplitRestOfGroup(TSchedId(m_popObj));
  FMQMPlan.RefreshActiveTab;
  FBin.UpdateForChangeFilter
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiSplitRemainJobClick(Sender: TObject);
begin
  SplitRestOfJob(TSchedId(m_popObj));
  FMQMPlan.RefreshActiveTab;
  FBin.UpdateForChangeFilter
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiStandardSettingsClick(Sender: TObject);
var
  NewItem : TMenuItem;
  TabCfg  : TPlanTabCfg;
  ts: TMqmPlanTabSheet;
begin
  DBAppGlobals.ShowColorJobModeActivTab := Standard;
  MiPropertyPreDefinedTab.Checked := false;
  MiPropertyDynamicTab.Checked := false;
  SetCheckedCurrentPropertyColoredPreDefinedTab(true, nil);
  SetCheckedCurrentPropertyColoredDynamicTab(true, nil);
  MiStandardSettings.Checked := True;
  TabCfg := TPlanTabCfg(m_planTbCfg.FindTab(m_pgcPlan.GetActiveView.GetCode));
  TabCfg.m_ShowColorJobMode := Standard;

  if DBAppGlobals.ShowColorJobMode = PreDefinedPropList then
  begin
    if (GetIdFromCode(DBAppGlobals.LastPropColorInUseJobMode) <> nil) then
    begin
      NewItem := TMenuItem.Create(Self);
      NewItem.VCLComObject := GetIdFromCode(DBAppGlobals.LastPropColorInUseJobMode);
      ClickShowBarColorfromPropList(NewItem);
    end;
  end
  else if DBAppGlobals.ShowColorJobMode = DinamicPropList then
  begin
    if (GetIdFromCode(DBAppGlobals.LastPropColorInUseJobMode) <> nil) then
    begin
      NewItem := TMenuItem.Create(Self);
      NewItem.VCLComObject := GetIdFromCode(DBAppGlobals.LastPropColorInUseJobMode);
      ClickShowBarColorDynamic(NewItem);
    end
  end;
  //else
  //begin
    ts := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
    if assigned(ts) then
    begin
      ts.p_shapeMan.ShapesUpdate;
      ts.Refresh;
    end;
 // end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiStatisticsShowClick(Sender: TObject);
var
  Statistics : TFStatistics;
  ShowWeeks : boolean;
  NewItem : TMenuItem;
  ListStatisticOfGantTab : Tlist;
  Wait : TFWait;
begin
  ShowWeeks := false;
  NewItem := TMenuItem(Sender);
  if (NewItem.Name = 'MiShowStatisticsWeeks') then
     ShowWeeks := true;

  Wait := TFWait.CreateWaitForm(self, w_Statistic_Show, nil);
  Wait.m_Weeks := ShowWeeks;

  Wait.ShowModal;

  Statistics := wait.GetStatisticObj;

  if Assigned(Statistics) then
     Statistics.ShowModal;

  Statistics.Free;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiStatisticsCleanClick(Sender: TObject);
begin
  FreeScheduleStatistics;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiDashboardClick(Sender: TObject);
begin
  GenerateAndOpenDashboard;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiCollapseallClick(Sender: TObject);
begin
  ExpOrCollSubResForAllRes(false)
end;

procedure TFMQMPlan.miCollapseallGroupClick(Sender: TObject);
var i : Integer;
 ts : TMqmPlanTabSheet;
begin
    ts := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
        for i := 0 to ts.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup_Lists.Count -1 do
            TTSlotGrp_WKC(ts.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup_Lists[i]).m_IsExpanded := False;

    ts.p_PlanWcControl.P_planWcView.RefreshPlan(false);

end;

procedure TFMQMPlan.MiExpandallClick(Sender: TObject);
begin
  ExpOrCollSubResForAllRes(True)
end;

procedure TFMQMPlan.miExpandallGroupClick(Sender: TObject);
var i : Integer;
 ts : TMqmPlanTabSheet;
begin
    ts := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
        for i := 0 to ts.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup_Lists.Count -1 do
            TTSlotGrp_WKC(ts.p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup_Lists[i]).m_IsExpanded := True;

    ts.p_PlanWcControl.P_planWcView.RefreshPlan(false);
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiSavePlanCopyClick(Sender: TObject);
var
  SavedPlanCopy : TSavedPlanCopy;
begin
  DMib.m_MainDB.Ping;  // will be catched by CommunicationException in case ping failed

  if ((GetOccMoveForm <> nil) or (GetDownTimeForm <> nil)) then exit;
  SavedPlanCopy := TSavedPlanCopy.CreateSavedPlanCopy(self);
  SavedPlanCopy.ShowModal;
  SavedPlanCopy.Free;
end;

//----------------------------------------------------------------------------//

Procedure TFMQMPlan.CompactallscheduledjobsfromthispointonwardonlyforselectedResource(AllRes : boolean);
var
  ActArea: TMqmActArea;
  VisRes: TMqmVisibleRes;
  Res: TMQMRes;
  ObjMover: TMqmSchedObjMover;
  ActTab : TMqmPlanTabSheet;
  iRes : integer;
  opStack: TOpStack;
begin
  DBAppGlobals.MAINPLAN_Ignore_Save_Event := true;
  MiniMizedMainForm;
  ObjMover := TMqmSchedObjMover.Create;
  p_opStack.MarkStackForButtonUndo(_('Compact jobs'));

  if not AllRes then
  begin
    ActArea := TMqmActArea(m_popObj);
    ObjMover.CompactEntitiesOnResByDate(ActArea, m_popDate, GetPlanView);
  end
  else
  begin
    ActTab := GetActiveTab;
    if assigned(ActTab) then
    begin
      for iRes := 0 to ActTab.p_ganttPanel.p_VisResList.Count -1 do
      begin
        VisRes := TMqmVisibleRes(ActTab.p_ganttPanel.p_VisResList[iRes]);
        ActArea := TMqmActArea(VisRes.p_ActArea[0]);
        ObjMover.CompactEntitiesOnResByDate(ActArea, m_popDate, GetPlanView);
      end;
    end;
  end;

  MaxiMizedMainForm;
  DBAppGlobals.MAINPLAN_Ignore_Save_Event := false;
  FMQMPlan.ActiveUndo;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiComparesavedbucketsClick(Sender: TObject);
var
  FCompareSaved: TFCompareSaved;
begin
  FCompareSaved := TFCompareSaved.Create(Self);
  FCompareSaved.ShowModal;
  FCompareSaved.Free;
end;

//----------------------------------------------------------------------------//

function TFMQMPlan.BuildStatisticAndShow(OnlyShow : boolean) :  TList;
var
  I : Integer;
  Statistics : TFStatistics;
  ListGanttTabs : TList;
  tab, ActiveTab : TMqmPlanTabSheet;
  ScheduleStatistics : TScheduleStatistics;
  ListStatisticOfGantTab : Tlist;
begin

  ListGanttTabs := TList.Create;
  ActiveTab := GetActiveTab;

  for i := 1 to m_pgcPlan.PageCount -1 do
  begin
    tab := TMqmPlanTabSheet(m_pgcPlan.Pages[i]);
    tab.p_ActiveTabForStatistics := false;
    if ActiveTab = Tab then
      tab.p_ActiveTabForStatistics := true;

    ListGanttTabs.Add(tab);
  end;

  if ListGanttTabs.Count = 0 then exit;

  if OnlyShow then
     Result := ShowStatisticForGanttTabs(ListGanttTabs)
  else
  begin
    ScheduleStatistics := TScheduleStatistics.CreateScheduleStatistics(ListGanttTabs, true, p_opStack.GetUndoLoopForStatistic);
    Result := ScheduleStatistics.GetListStatisticOfGantTab;
  end;

  ListGanttTabs.Free;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MistatisticsCreateAndShowClick(Sender: TObject);
var
  Statistics : TFStatistics;
  ListStatisticOfGantTab : Tlist;
  Wait : TFWait;
begin
  Wait := TFWait.CreateWaitForm(self, w_Statistic_Create, nil);
  Wait.ShowModal;

  Statistics := wait.GetStatisticObj;

  if Assigned(Statistics) then
     Statistics.ShowModal;

  Statistics.Free;
 // Wait.free;

end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MITraditionalClick(Sender: TObject);
begin
  UseLanguage ('zh_TW');
  ReTranslateComponent (self);
  UpdateCaptions;
  DBAppGlobals.Language := 'zh_TW';
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIUPloadDownloadClick(Sender: TObject);
begin
  if SP_SRVLOAD_GET_STATUS_OPENED_OR_CLOSED then
    OPERATE_DOWNLOAD_REQUEST(IniAppGlobals.WkstCode, 'UPLDNL')
  else
    ShowMessage('Server is closed - Please contact the operator');
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIUserDictionaryClick(Sender: TObject);
begin
  UseLanguage ('ud');
  ReTranslateComponent (self);
  UpdateCaptions;
  DBAppGlobals.Language := 'ud';
end;
//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIColorLegendClick(Sender: TObject);
var
  ts : TMqmPlanTabSheet;
  FColors: TFColors;
  I : Integer;
begin
  FColors := TFColors.CreateColorsForm(self);
  if FColors.ShowModal = mrok then
  begin
    for i := 1 to m_pgcPlan.PageCount -1 do
    begin
      ts := TMqmPlanTabSheet(m_pgcPlan.Pages[i]);
      ts.p_shapeMan.Update;
    end
  end;
  FColors.Free
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIProductionReqClick(Sender: TObject);
begin
  if Assigned(Fbin) then
    Fbin.CreateSearchTabFromGantt(TSchedId(m_popObj) , CSC_ProdReq);
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIProdTypeClick(Sender: TObject);
begin
  if Assigned(Fbin) then
     Fbin.CreateSearchTabFromGantt(TSchedId(m_popObj) , CSC_ProdType);
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIWorkCenterClick(Sender: TObject);
begin
  if Assigned(Fbin) then
    Fbin.CreateSearchTabFromGantt(TSchedId(m_popObj) , CSC_WkctCode);
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIProccessClick(Sender: TObject);
begin
  if Assigned(Fbin) then
    Fbin.CreateSearchTabFromGantt(TSchedId(m_popObj) , CSC_WkctProc);
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIProdFamiyClick(Sender: TObject);
begin
  if Assigned(Fbin) then
    Fbin.CreateSearchTabFromGantt(TSchedId(m_popObj) , CSC_ProdFamily);
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIMaterialFamilyClick(Sender: TObject);
begin
  if Assigned(Fbin) then
    Fbin.CreateSearchTabFromGantt(TSchedId(m_popObj) , CSC_ProdMatFamily);
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIStockDetailsClick(Sender: TObject);
var
  id: TSchedId;
begin
  id := TSchedId(m_popObj);
  HandleStockDetails(self,Id);
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiSapphireKamriClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to MainMenu.Items.Count -1  do
    MainMenu.Items[i].OnDrawItem := nil;

  m_Style := 'Sapphire Kamri';
  PostMessage( Handle, wm_Stylechange, 0, StrToInt(IniAppGlobals.Identifier));
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIStyleIcebergClassicoClick(Sender: TObject);
var  I: Integer;
begin
  for I := 0 to MainMenu.Items.Count -1  do
    MainMenu.Items[i].OnDrawItem := nil;

  m_style := 'Iceberg Classico';
  PostMessage( Handle, wm_Stylechange, 0, StrToInt(IniAppGlobals.Identifier));
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiStyleLunaClick(Sender: TObject);
var  I: Integer;
begin
  for I := 0 to MainMenu.Items.Count -1  do
    MainMenu.Items[i].OnDrawItem := nil;
  MISEtting.OnDrawItem := nil;
  m_Style := 'Luna';
  PostMessage( Handle, wm_Stylechange, 0, StrToInt(IniAppGlobals.Identifier));
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiStyleSkyClick(Sender: TObject);
var  I: Integer;
begin
  for I := 0 to MainMenu.Items.Count -1  do
    MainMenu.Items[i].OnDrawItem := nil;

  m_Style := 'Sky';
  PostMessage( Handle, wm_Stylechange, 0, StrToInt(IniAppGlobals.Identifier));
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiStyleWindowsClick(Sender: TObject);
var  I: Integer;
begin
 // for I := 0 to MainMenu.Items.Count -1  do
 //   MainMenu.Items[i].OnDrawItem := DrawItemTitleMainMenu;

  m_Style := 'Windows';
  PostMessage( Handle, wm_Stylechange, 0, StrToInt(IniAppGlobals.Identifier));
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIEditCalClick(Sender: TObject);
var
  pt: TMqmPlanTabSheet;
  Cal : TPGCALObj;
  Res : TMqmRes;
  MqmWrkCtr : TMqmWrkCtr;
  CalListToUpdate : TList;
begin
  CalListToUpdate := nil;
  Res := TMqmRes(TMqmVisibleRes(m_popObj).p_father);
  if TMqmWrkCtr(res.p_father).p_ReadOnly then
  begin
    MessageDlg(_('Is not possible modify the calendar for resource read-only'),
            mtInformation, [mbOk], 0);
    exit;
  end;


  if TMqmVisibleRes(m_popObj).p_EfficiencyOnLevel = Eff_And_Cal_Both_Lvl_Res then
  begin
    Cal := TMqmVisibleRes(m_popObj).p_CalendarReal;
    CalListToUpdate := p_pl.GetAllCalendarsForEfficiencyOnWcOrResourceLevel(TMqmVisibleRes(m_popObj).p_CalCodReal , Eff_And_Cal_Both_Lvl_Res,  TMqmRes(TMqmVisibleRes(m_popObj).p_Father).p_Father);
  end
  else if TMqmVisibleRes(m_popObj).p_EfficiencyOnLevel = EffLvl_Wc then
  begin
    Cal := TMqmVisibleRes(m_popObj).p_CalendarReal;
    CalListToUpdate := p_pl.GetAllCalendarsForEfficiencyOnWcOrResourceLevel(TMqmVisibleRes(m_popObj).p_CalCodReal , EffLvl_Wc,  TMqmRes(TMqmVisibleRes(m_popObj).p_Father).p_Father);
  end
  else if TMqmVisibleRes(m_popObj).p_EfficiencyOnLevel = EffLvl_Res then
  begin
    Cal := TMqmVisibleRes(m_popObj).p_CalendarReal;
    CalListToUpdate := p_pl.GetAllCalendarsForEfficiencyOnWcOrResourceLevel(TMqmVisibleRes(m_popObj).p_CalCodReal, EffLvl_Res, TMqmRes(TMqmVisibleRes(m_popObj).p_Father).p_Father);
  end
  else
    Cal := TMqmVisibleRes(m_popObj).GetCalendar;

  if Cal.GetKey <> 'VOID' then
  begin
    MEditCal := TMEditCal.CreateEditCalFrm(self, Cal, CalListToUpdate, Res );
    MEditCal.ShowModal;
    pt := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
    if Assigned(pt) then
      pt.p_shapeMan.ShapesUpdate;
    if Assigned(CalListToUpdate) then
      CalListToUpdate.Free;
    MEditCal.Free
  end;

end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIEditCapacityClick(Sender: TObject);
var
  EditCapacity: TEditCapacity;
  Res : TMqmRes;
begin

  Res := TMqmRes(TMqmVisibleRes(m_popObj).p_father);
  if TMqmWrkCtr(res.p_father).p_ReadOnly then
  begin
    MessageDlg(_('Is not possible modify the calendar efficiency for resource read-only'),
            mtInformation, [mbOk], 0);
    exit;
  end;

  EditCapacity := TEditCapacity.CreateEditCapacity(self, TMqmVisibleRes(m_popObj));
  EditCapacity.ShowModal;
  PgcMainChange(self);
  EditCapacity.Free
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiAutoSeqResultsClick(Sender: TObject);
begin
  TFConfigBin.CreateCfgBin(Self, Tb_AutoSeqResults).ShowModal;
  SaveDefaultTabAutoSeqResults;
end;

procedure TFMQMPlan.miAvailablityReportClick(Sender: TObject);
var   FAvailablityReport: TFAvailablityReport;
begin
  FAvailablityReport := TFAvailablityReport.Create(Self);
  FAvailablityReport.ShowModal;
  FAvailablityReport.Free
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MISortResourceCodeClick(Sender: TObject);
var
  Plantab : TMqmPlanTabSheet;
begin
  Plantab := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
  Plantab.p_ganttPanel.SortByResourceCode;
  Plantab.p_ganttPanel.p_SortType := SRT_RscCode;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.Categoryresourcecode1Click(Sender: TObject);
var
  Plantab : TMqmPlanTabSheet;
begin
  Plantab := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
  Plantab.p_ganttPanel.SortByCategoryAndResCode;
  Plantab.p_ganttPanel.p_SortType := SRT_RscCatCode;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.WCresourcecode1Click(Sender: TObject);
var
  Plantab : TMqmPlanTabSheet;
begin
  Plantab := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
  Plantab.p_ganttPanel.SortByWcAndRes;
  Plantab.p_ganttPanel.p_SortType := SRT_WCRscCode;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.WorkCenterCapClick(Sender: TObject);
var
  WorkCenterCategoryCapacity : TWorkCenterCategoryCapacity;
begin
  WorkCenterCategoryCapacity := TWorkCenterCategoryCapacity.CreateWcCategoryCapacity(self);
  WorkCenterCategoryCapacity.ShowModal;
  WorkCenterCategoryCapacity.Free
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.Wccategoryresource1Click(Sender: TObject);
var
  Plantab : TMqmPlanTabSheet;
begin
  Plantab := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
  Plantab.p_ganttPanel.SortByWcAndCatAndRes;
  Plantab.p_ganttPanel.p_SortType := SRT_WCCatRscCode;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIFindjobinbinClick(Sender: TObject);
begin
  if Assigned(Fbin) then
    Fbin.FocusBinOnJobID(TSchedId(m_popObj), True);
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiSetBinConficurationClick(Sender: TObject);
begin

end;

//----------------------------------------------------------------------------//
{
 Deletes all the Jobs/steps from the Gannt and moves them back to the bin
 it checks for the following :
 1. the job isn't a progressed job
 2. the job isn't closed
 3. there are no dependant jobs upon this job

 }

procedure TFMQMPlan.IMoveAllInBinLastOnGanntClick(Sender: TObject);
var
  Save_Cursor : TCursor;
begin
  Save_Cursor := Screen.Cursor;
  Screen.Cursor  := crAppStart;
  MoveAllJobsToBin(true, true, false);
  Screen.Cursor := Save_Cursor;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.IMoveAllJobsToBinClick(Sender: TObject);
var
  Save_Cursor : TCursor;
begin
  Save_Cursor := Screen.Cursor;
  Screen.Cursor  := crAppStart;
//  MoveAllJobsToBin(false);
  Screen.Cursor := Save_Cursor;
end;

//----------------------------------------------------------------------------//

function SortActArea(Item1, Item2: Pointer): Integer;
var
  actArea1, actArea2: TMqmActArea;
begin
  actArea1 := TMqmActArea(Item1);
  actArea2 := TMqmActArea(Item2);

  if actArea1.GetSchedObj(0) > actArea2.GetSchedObj(0) then
    Result := -1
  else
    if actArea1.GetSchedObj(0) < actArea2.GetSchedObj(0) then
      Result := 1
    else
      Result := 0;
end;

//----------------------------------------------------------------------------//

procedure MoveAllJobsToBin(LastOnGantt : boolean; MessagDlg : boolean; LinkedAndForewardJobs : boolean);
var
  id, id_Linked, IdGrp, ChildId :      TSchedId;
  i, j, G, JobsInBinCount : integer;
  linkInfo: TSQlinkInfo;
  ActTab : TBinTabSheet;
  ActBinGrid: TBinDrawGrid;
  JobStillOnPlan, IsBelong, AtLeastOneUnschedule: boolean;
  actArea, OldActArea: TMqmActArea;
  TmpLstActArea: TList;
  OptsMover: SetOptsMover;
  DeltaSetupObjToMove: double;
  MarkStack: TStackMark;
  W : Word;
  SchedList, LinkedJobList : TMSchedList;
  ShowBatchGroupLinesInBin, Found_From_Mqm_Env : boolean;
  ShowContinueGroupLinesInBin : CScShowContinueGroupLinesInBin;
  linkInfoMcm : TSQMCMlinkInfo;
begin
  // Refactorized by fp - October 20th 2005
  // Refactorized by fp - November 10th 2005
  DBAppGlobals.MAINPLAN_Ignore_Save_Event := true;
  MarkStack := p_OpStack.MarkStack;

  JobStillOnPlan := false;
  TmpLstActArea := nil;

  ActTab := FBin.GetActiveView;

  if not Assigned(ActTab) then
  begin
    MessageDlg(_('No bin available'), mtError, [mbOK], 0);
    exit;
  end;
  ActbinGrid := ActTab.GetBinGrid;

  if IsAutoRunMode then
    SchedList := ActbinGrid.GetAllAsSelectedForAutoRun
  else
    SchedList := ActbinGrid.GetSelectedList;

  if IsAutoRunMode then
  begin
//    ActbinGrid := ActTab.GetBinGrid;
//    ActbinGrid.SetAllSelected;
    w := mrYes
  end
  else
  begin
    if MessagDlg then
    begin
      if SchedList.GetLinkCount > 1 then
        w := MessageDlg(_('Unschedule all jobs in current bin ?'), mtConfirmation, [mbYes, mbNo, mbCancel], 0)
      else
        w := MessageDlg(_('Unschedule current job in the bin ?'), mtConfirmation, [mbYes, mbNo, mbCancel], 0)
    end
    else
      w := mrYes;
  end;

  if w = mrYes then
  begin

    if LinkedAndForewardJobs then
      p_opStack.MarkStackForButtonUndo(_('Unschedule selected and forward linked jobs'))
    else
      p_opStack.MarkStackForButtonUndo(_('Unschedule all jobs in current bin'));

    TmpLstActArea := TList.Create;


    JobsInBinCount := SchedList.GetLinkCount;


    if LinkedAndForewardJobs then
    begin

      LinkedJobList := TMSchedList.Create(Application);
      for i := 0 to (JobsInBinCount - 1) do
      begin
        id := SchedList.GetLink(I);
        if p_sc.GetLinkInfo(id, linkInfo) = false then continue;
        if linkInfo.isGroup then
        begin
          for G := 0 to p_sc.GetGrpNumSons(id) - 1 do
          begin
            ChildId := p_sc.GetGrpSon(id, G);
            LinkedJobList.AddLink(ChildId);
          end;
        end
        else
          LinkedJobList.AddLink(Id)
      end;

      for i := 0 to (LinkedJobList.GetLinkCount - 1) do
      begin
        id := LinkedJobList.GetLink(I);
        p_sc.FillLinkedListIdsForeward(Id, LinkedJobList);
      end;

      AtLeastOneUnschedule := true;
      while AtLeastOneUnschedule do
      Begin
        AtLeastOneUnschedule := false;
        for i := 0 to (LinkedJobList.GetLinkCount - 1) do
        begin
          id := LinkedJobList.GetLink(I);
          if p_sc.GetLinkInfo(id, linkInfo) = false then continue;

          if not linkInfo.isOnPlan then continue;

          if p_sc.IsJobSavedInDB(id) then continue;

          if linkInfo.grpId <> CSchedIdNull then
             id := linkInfo.grpId;

          if Assigned(p_sc.GetExtLinkPtr(id)) then
          begin
            actArea := TMqmActArea(p_sc.GetExtLinkPtr(id));
            if DBAppGlobals.MCM_App then
            begin
              Found_From_Mqm_Env := false;
              if linkInfo.grpId <> CSchedIdNull then
              begin
                for G := 0 to p_sc.GetGrpNumSons(id) - 1 do
                begin
                  ChildId := p_sc.GetGrpSon(id, G);
                  p_sc.GetMcmLinkInfo(ChildId, linkInfoMcm, true);
                  if linkInfoMcm.From_Mqm_Env then
                  begin
                    Found_From_Mqm_Env := true;
                    break
                  end;
                end;
                if Found_From_Mqm_Env then continue;
              end
              else
              begin
                p_sc.GetMcmLinkInfo(id, linkInfoMcm, true);
                if linkInfoMcm.From_Mqm_Env then continue;
              end;
            end;
          end;

          if MoveToBin(id, false) then
          begin
            AtLeastOneUnschedule := true;
            TmpLstActArea.Add(actArea);
          end;
        end;
      end;
    end

    else
    begin

    //we must loop from end to start because each time we delete a job
    //the JobsInBinCount is reduced by one and so GetLink(i) must be
    //GetLink(0) to get the first object, but then we can't continue to loop
    //in case that the first id can't be deleted if it has some dependant ids
      if not LastOnGantt then
      begin
        for i := (JobsInBinCount - 1) downto 0 do
        begin
          actArea := nil;
          id := SchedList.GetLink(I);

          if id = CSchedIdNull then break;
          if p_sc.GetLinkInfo(id, linkInfo) = false then continue;
          if linkInfo.isOnPlan = false then continue;
          if p_sc.IsJobSavedInDB(id) then continue;

          if (ActTab.m_BinPanel.GetFiltParms.RecFilt.ShowContinueGroupLinesInBin <> CsSCG_No) or
            (ActTab.m_BinPanel.GetFiltParms.RecFilt.ShowBatchGroupLinesInBin) then
          begin
            if not linkInfo.isGroup then
            begin
              IdGrp := p_sc.LinesBelongToGroup(id, Isbelong);
              if IsBelong then
                Id := IdGrp;
            end;
          end;

          if Assigned(p_sc.GetExtLinkPtr(id)) then
          begin
            actArea := TMqmActArea(p_sc.GetExtLinkPtr(id));
            if TMqmWrkCtr((actArea).p_WrkCtr).p_ReadOnly then continue;
            if DBAppGlobals.MCM_App then
            begin
              Found_From_Mqm_Env := false;
              if linkInfo.isGroup then
              begin
                for G := 0 to p_sc.GetGrpNumSons(Id) - 1 do
                begin
                  ChildId := p_sc.GetGrpSon(Id, G);
                  p_sc.GetMcmLinkInfo(ChildId, linkInfoMcm, true);
                  if linkInfoMcm.From_Mqm_Env then
                  begin
                    Found_From_Mqm_Env := true;
                    break
                  end;
                end;
                if Found_From_Mqm_Env then continue;
              end
              else
              begin
                p_sc.GetMcmLinkInfo(Id, linkInfoMcm, true);
                if linkInfoMcm.From_Mqm_Env then continue;
              end;
            end;
            if LastOnGantt and ((TMqmActArea(actArea).GetNextObj(linkInfo.schedStart,id)) <> CSchedIDnull) then continue;
          end;

          if not MoveToBin(id, false) then
          begin
            JobStillOnPlan := true;
            continue;
          end;

          TmpLstActArea.Add(actArea);

        end;
      end

      else
      begin

        for i := 0 to SchedList.GetLinkCount - 1 do
        begin
          actArea := nil;
          id := SchedList.GetLink(I);

          if id = CSchedIdNull then break;
          if p_sc.GetLinkInfo(id, linkInfo) = false then continue;
          if linkInfo.isOnPlan = false then continue;
          if p_sc.IsJobSavedInDB(id) then continue;

          if (ActTab.m_BinPanel.GetFiltParms.RecFilt.ShowContinueGroupLinesInBin <> CsSCG_No) or
            (ActTab.m_BinPanel.GetFiltParms.RecFilt.ShowBatchGroupLinesInBin) then
          begin
            if not linkInfo.isGroup then
            begin
              IdGrp := p_sc.LinesBelongToGroup(id, Isbelong);
              if IsBelong then
                Id := IdGrp;
            end;
          end;

          if Assigned(p_sc.GetExtLinkPtr(id)) then
          begin
            actArea := TMqmActArea(p_sc.GetExtLinkPtr(id));
            if TMqmWrkCtr((actArea).p_WrkCtr).p_ReadOnly then continue;
            if DBAppGlobals.MCM_App then
            begin
              Found_From_Mqm_Env := false;
              if linkInfo.isGroup then
              begin
                for G := 0 to p_sc.GetGrpNumSons(Id) - 1 do
                begin
                  ChildId := p_sc.GetGrpSon(Id, G);
                  p_sc.GetMcmLinkInfo(ChildId, linkInfoMcm, true);
                  if linkInfoMcm.From_Mqm_Env then
                  begin
                    Found_From_Mqm_Env := true;
                    break
                  end;
                end;
                if Found_From_Mqm_Env then continue;
              end
              else
              begin
                p_sc.GetMcmLinkInfo(Id, linkInfoMcm, true);
                if linkInfoMcm.From_Mqm_Env then continue;
              end;
            end;
            if LastOnGantt and ((TMqmActArea(actArea).GetNextObj(linkInfo.schedStart,id)) <> CSchedIDnull) then continue;
          end;

          if not MoveToBin(id, false) then
          begin
            JobStillOnPlan := true;
            continue;
          end;

          TmpLstActArea.Add(actArea);

        end;
      end;

    end;

  end;

  if Assigned(TmpLstActArea) then
  begin
    TmpLstActArea.Sort(SortActArea);

    OldActArea := nil;
    for i := 0 to TmpLstActArea.Count -1 do
    begin
      ActArea := TMqmActArea(TmpLstActArea[i]);
      if ActArea <> OldActArea then
      begin
        OldActArea := ActArea;

        id := CSchedIDnull;
        for j := 0 to ActArea.p_ObjCount -1 do
        begin
          id := ActArea.GetSchedObj(j);
          if p_sc.CanDetach(id, nil, false) = true then
            break
          else
            id := CSchedIDnull;
        end;

        if id <> CSchedIDnull then
          if ActArea.ReorganizeOccForUnsched(id, false, OptsMover, DeltaSetupObjToMove, nil) = CSM_No then
          begin
            p_OpStack.UndoTo(MarkStack);
            MessageDlg(_('Is not possible to perform the operation because the reorganization is failed'), mtWarning, [mbOK], 0);
            break;
          end;
      end;
    end;

    TmpLstActArea.Free;
  end;

  FMQMPlan.RefreshActiveTab;

  if DBAppSettings.RefreshBinByButton then
  begin
    if Assigned(FBin) then
      FBin.ActivateRefreshButton
  end
  else
  begin
    if not AutoSchedCfg.m_OverridingParams_Activated then
      FBin.ChangeTabBinforChangeTabPlan;
  end;

  if JobStillOnPlan and not IsAutoRunMode then
    MessageDlg(_('Not all jobs were unscheduled'), mtWarning, [mbOK], 0);

  FMQMPlan.ActiveUndo;
  DBAppGlobals.MAINPLAN_Ignore_Save_Event := false;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.PupJobPopup(Sender: TObject);
var
  id : TSchedId;
  I  : Integer;
  ProgressStatus : CProgressIgnor;
  ProgressIgnoredType : CProgressTypeIgnored;
  Cal : TPGCALObj;
  Res : TMqmRes;
  DatesInfo: TSQDatesInfo;
  NewCreatedId : TschedId;
  SplitInfo: TSQSplitInfo;
begin
  for I := 0 to PupJob.Items.Count -1 do
  begin
    PupJob.Items.Items[I].Enabled := true;
    PupJob.Items.Items[I].Visible := true;
  end;

  if DBAppGlobals.MCM_App and (IniAppGlobals.MCMasMQM = 0) then
  begin
    for I := 0 to PupJob.Items.Count -1 do
      PupJob.Items.Items[I].Visible := false;
    MIStepDetails.Visible := true;
    MIShowrequierments.Visible := true;
    MIFindjobinbin.Visible := true;
  end;

  for I := 0 to MISetLevelTo.Count -1 do
    MISetLevelTo.Items[I].Visible := true;

  id := TSchedId(m_popObj);

  p_sc.GetSplitInfo(id, SplitInfo);
  if (p_sc.GetJobType(id) = CST_Continuous) and (CProgress(p_sc.IsProgressed(id)) = prg_none) then
//  if (p_sc.GetJobNumBrothers(Id) = 1) and (p_sc.GetJobType(id) = CST_Continuous) and (CProgress(p_sc.IsProgressed(id)) = prg_none) then
    MiSpeedChange.Visible := true
  else
    MiSpeedChange.Visible := false;

  if (p_sc.GetLearningCurveType(Id) <> CSC_Managed) then
    MiLearningCurveChange.Visible    := false
  else
    MiLearningCurveChange.Visible    := true;

  if MiLearningCurveChange.Visible then
  begin
    if p_sc.GetLearningCurveCode(Id) <> '' then
    begin
      MiRemoveCurveCode.Visible := true;
      MiChangingCurveCode.Caption := _('Change');
      MiChangingCurveCode.Visible := true;
    end
    else
    begin
      MiChangingCurveCode.Visible := true;
      MiChangingCurveCode.Caption := _('Link');
      MiRemoveCurveCode.Visible := false;
    end;
  end;

  if (DBAppGlobals.ConfLevels = 0) then
    MISetLevelTo.Visible := false;
  if (DBAppGlobals.ConfLevels = 0) or (p_sc.GetSchedType(id) = '1') then
    MISetToTemp.Visible := false;
  if (DBAppGlobals.ConfLevels = 0) or (p_sc.GetSchedType(id) = '2') then
    MISetFinal.Visible := false;
  if (DBAppGlobals.ConfLevels <= 1) or (p_sc.GetSchedType(id) = '3') then
    MISetLevelTo1.Visible := false;
  if (DBAppGlobals.ConfLevels <= 2) or (p_sc.GetSchedType(id) = '4') then
    MISetLevelTo2.Visible := false;
  if (DBAppGlobals.ConfLevels <= 3) or (p_sc.GetSchedType(id) = '5') then
    MISetLevelTo3.Visible := false;
  if (DBAppGlobals.ConfLevels <= 4) or (p_sc.GetSchedType(id) = '6') then
    MISetLevelTo4.Visible := false;
  if (DBAppGlobals.ConfLevels <= 5) or (p_sc.GetSchedType(id) = '7') then
    MISetLevelTo5.Visible := false;

  if (DBAppGlobals.ConfLevels = 0) or (p_sc.GetSchedType(id) = '2') then
    MISetNextLevel.Visible := false
  else
  begin
    if (p_sc.GetSchedType(id) = '1') and (DBAppGlobals.ConfLevels > 1) then
      MISetNextLevel.Caption := _('Set to confirmation level 1')
    else if (p_sc.GetSchedType(id) = '3') and (DBAppGlobals.ConfLevels > 2) then
      MISetNextLevel.Caption := _('Set to confirmation level 2')
    else if (p_sc.GetSchedType(id) = '4') and (DBAppGlobals.ConfLevels > 3) then
      MISetNextLevel.Caption := _('Set to confirmation level 3')
    else if (p_sc.GetSchedType(id) = '5') and (DBAppGlobals.ConfLevels > 4) then
      MISetNextLevel.Caption := _('Set to confirmation level 4')
    else if (p_sc.GetSchedType(id) = '6') and (DBAppGlobals.ConfLevels > 5) then
      MISetNextLevel.Caption := _('Set to confirmation level 5')
    else
    begin
      MISetNextLevel.Caption := _('Set to final');
      MISetNextLevel.Visible := false
    end
  end;

  if (DBAppGlobals.ConfLevels = 0) or (p_sc.GetSchedType(id) = '2') then
    MISetIniFin.Visible := false
  else
  begin
    if (p_sc.GetSchedType(id) <> '2') then
    begin
      MISetIniFin.Caption := _('Set to final');
      MISetIniFin.ImageIndex := 5;
    end else
    begin
      MISetIniFin.Caption := _('Set to initial');
      MISetIniFin.ImageIndex := 3;
    end
  end;

  if Assigned(p_sc.GetExtLinkPtr(id)) and not (p_sc.GetVisbleInBin(id) = CSB_Normal) then
  begin
   // IMoveToBin.Enabled := false;
    MIIgnoreprogress.Enabled := false;
    MIIgnoreprogress.Visible := false;
  end;

  ProgressStatus := p_sc.GetProgressOverrideStatus(id, ProgressIgnoredType);

  if ((ProgressStatus = Prg_NotIgnored) or (ProgressStatus = Prg_ReApplied) or (ProgressStatus = Prg_ReAppliedAndSave)) and (p_sc.IsProgressed(id) <> prg_none) then
    MIIgnoreprogress.Caption := _('Ignore last progress statues')
  else if ((ProgressStatus = Prg_Ignored) or (ProgressStatus = Prg_IgnoredAndSave)) and (p_sc.IsProgressed(id) = prg_none) then
     MIIgnoreprogress.Caption := _('Re-apply progress status')
  else
  begin
    MIIgnoreprogress.Enabled := false;
    MIIgnoreprogress.Visible := false;
  end;

  Res := TMqmRes(TMqmActArea(p_sc.getExtLinkPtr(TSchedId(m_popObj))).p_res);

  if (Assigned(Res) and TMqmWrkCtr(res.p_father).p_ReadOnly) or
  ((p_sc.IsProgressed(Id) <> prg_none) and (p_sc.IsProgressed(Id) <> prg_General)) then
  begin
    MiSplitHere.Visible := false;
    MiSplitFromThisPointBehaviour.Visible := false;
    MIJobHandle.Visible := false;
    MISetLevelTo.Visible := false;
    MISetIniFin.Visible := false;
    MISetNextLevel.Visible := false;
   // IMoveAllJobsToBin2.Visible := false;
  end;

  if MiSplitHere.Visible then
  begin
    if iniAppGlobals.SplitFromPointOnPreDefTime = '1' then
         MiSplitHere.Visible := false
    else
    begin
      Cal := TMqmActArea(p_sc.getExtLinkPtr(TSchedId(m_popObj))).GetCalendar;
      if Assigned(Cal) then
      begin
        Cal.NormalizeDate(m_popDate, ntNormalizeForward);
        if not SplitFromDatePoint(TSchedId(m_popObj), m_popDate, false, true, NewCreatedId, Non, -1) then
           MiSplitHere.Visible := false
        else
        begin
          p_sc.GetDatesInfo(id, DatesInfo);
          if DatesInfo.endDate = m_popDate then
             MiSplitHere.Visible := false;
        end;

      end;
    end;
  end;

  //MiSplitFromThisPointBehaviour.Visible := true;
  if (iniAppGlobals.SplitFromPointOnPreDefTime = '') or (iniAppGlobals.SplitFromPointOnPreDefTime = '0') then
     MiSplitFromThisPointBehaviour.Visible := false
  else if (iniAppGlobals.SplitFromPointOnPreDefTime = '1') or (iniAppGlobals.SplitFromPointOnPreDefTime = '2') then
  begin

    Cal := TMqmActArea(p_sc.getExtLinkPtr(TSchedId(m_popObj))).GetCalendar;
    if Assigned(Cal) then
    begin
      Cal.NormalizeDate(m_popDate, ntNormalizeForward);
      p_sc.GetDatesInfo(id, DatesInfo);
      if DatesInfo.endDate <= Trunc(m_popDate) + StrToFloat(iniAppGlobals.SplitFromPointPreDefTime) then
         MiSplitFromThisPointBehaviour.Visible := false
      else if DatesInfo.startDate >= Trunc(m_popDate) + StrToFloat(iniAppGlobals.SplitFromPointPreDefTime) then
         MiSplitFromThisPointBehaviour.Visible := false
      else if not SplitFromDatePoint(TSchedId(m_popObj), Trunc(m_popDate) + StrToFloat(iniAppGlobals.SplitFromPointPreDefTime) , false, true, NewCreatedId, Non, -1) then
         MiSplitFromThisPointBehaviour.Visible := false
    end;
  end;

  if not DBAppGlobals.StockDetailsHandled then
    MIStockDetails.Visible := false
  else
    MIStockDetails.Visible := true;

  if SplitInfo.SplitAllow = CSB_No then
  begin
    MiSplitFromThisPointBehaviour.visible := false;
    MiSplitHere.Visible := false;
    MIJobHandle.Visible := false
  end;

  if not CheckIfSplitIsPossible(Id) then
    MiSplitRemainJob.Visible := false
  else
    MiSplitRemainJob.Visible := true;

  SetVisibilityForPopup(Sender);

end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.PupGroupPopup(Sender: TObject);
var
  id : TSchedId;
  I : Integer;
  planInfo: TSQplanInfo;
  ProgressStatus : CProgressIgnor;
  ProgressIgnoredType : CProgressTypeIgnored;
begin
  for I := 0 to PupGroup.Items.Count -1 do
  begin
    PupGroup.Items.Items[I].Enabled := true;
    PupGroup.Items.Items[I].Visible := true;
  end;

  id := TSchedId(m_popObj);
  if (p_sc.GetVisbleInBin(id) = CSB_ReadOnly) then
    MIgrpToBin.Enabled := false;

  for I := 0 to MISetLevelToGrp.Count -1 do
    MISetLevelToGrp.Items[I].Visible := true;

  if (p_sc.GetJobType(id) <> CST_Continuous) then
    MISplitGroup.Visible := false;

//  if (not p_sc.CheckIfGroupChilderenContainSubSteps(id)) and (p_sc.GetJobType(id) = CST_Continuous) and (CProgress(p_sc.IsProgressed(id)) = prg_none) then
  if (p_sc.GetJobType(id) = CST_Continuous) and (CProgress(p_sc.IsProgressed(id)) = prg_none) then
    MiSeedGrpChange.Visible := true
  else
    MiSeedGrpChange.Visible := false;

  if (p_sc.GetLearningCurveType(Id) <> CSC_Managed) then
    MiLearningCurveGrpChange.Visible := false
  else
    MiLearningCurveGrpChange.Visible := true;

  if MiLearningCurveGrpChange.Visible then
  begin
    if p_sc.GetLearningCurveCode(Id) <> '' then
    begin
      MiRemoveCurveGrpCode.Visible := true;
      MiChangingCurveGrpCode.Caption := _('Change');
      MiChangingCurveGrpCode.Visible := true;
    end
    else
    begin
      MiChangingCurveGrpCode.Visible := true;
      MiChangingCurveGrpCode.Caption := _('Link');
      MiRemoveCurveGrpCode.Visible := false
    end;
  end;

  MISetNextLevelGrp.Visible := true;
  MISetIniFinGrp.Visible := true;

  if (DBAppGlobals.ConfLevels = 0) then
    MISetLevelToGrp.Visible := false;
  if (DBAppGlobals.ConfLevels = 0) or (p_sc.GetSchedType(id) = '1') then
    MISetToTempGrp.Visible := false;
  if (DBAppGlobals.ConfLevels = 0) or (p_sc.GetSchedType(id) = '2') then
    MISetFinalGrp.Visible := false;
  if (DBAppGlobals.ConfLevels <= 1) or (p_sc.GetSchedType(id) = '3') then
    MISetLevelToGrp1.Visible := false;
  if (DBAppGlobals.ConfLevels <= 2) or (p_sc.GetSchedType(id) = '4') then
    MISetLevelToGrp2.Visible := false;
  if (DBAppGlobals.ConfLevels <= 3) or (p_sc.GetSchedType(id) = '5') then
    MISetLevelToGrp3.Visible := false;
  if (DBAppGlobals.ConfLevels <= 4) or (p_sc.GetSchedType(id) = '6') then
    MISetLevelToGrp4.Visible := false;
  if (DBAppGlobals.ConfLevels <= 5) or (p_sc.GetSchedType(id) = '7') then
    MISetLevelToGrp5.Visible := false;

  if (DBAppGlobals.ConfLevels = 0) or (p_sc.GetSchedType(id) = '2') then
    MISetNextLevelGrp.Visible := false
  else
  begin
    if (p_sc.GetSchedType(id) = '1') and (DBAppGlobals.ConfLevels > 1) then
      MISetNextLevelGrp.Caption := _('Set to confirmation level 1')
    else if (p_sc.GetSchedType(id) = '3') and (DBAppGlobals.ConfLevels > 2) then
      MISetNextLevelGrp.Caption := _('Set to confirmation level 2')
    else if (p_sc.GetSchedType(id) = '4') and (DBAppGlobals.ConfLevels > 3) then
      MISetNextLevelGrp.Caption := _('Set to confirmation level 3')
    else if (p_sc.GetSchedType(id) = '5') and (DBAppGlobals.ConfLevels > 4) then
      MISetNextLevelGrp.Caption := _('Set to confirmation level 4')
    else if (p_sc.GetSchedType(id) = '6') and (DBAppGlobals.ConfLevels > 5) then
      MISetNextLevelGrp.Caption := _('Set to confirmation level 5')
    else
    begin
      MISetNextLevelGrp.Caption := _('Set to final');
      MISetNextLevelGrp.Visible := false
    end
  end;

  if (DBAppGlobals.ConfLevels = 0) or (p_sc.GetSchedType(id) = '2') then
    MISetIniFinGrp.Visible := false
  else
  begin
    if (p_sc.GetSchedType(id) <> '2') then
    begin
      MISetIniFinGrp.Caption := _('Set to final');
      MISetIniFinGrp.ImageIndex := 36;
    end else
    begin
      MISetIniFinGrp.Caption := _('Set to initial');
      MISetIniFinGrp.ImageIndex := 37;
    end
  end;
  if Assigned(p_sc.GetExtLinkPtr(id)) and not (p_sc.GetVisbleInBin(id) = CSB_Normal) then
  begin
    MIIgnoreprogress.Enabled := false;
    MIIgnoreprogress.Visible := false;
  end;

  ProgressStatus := p_sc.GetProgressOverrideStatus(id, ProgressIgnoredType);
  if (ProgressStatus <> Prg_NotIgnored) or (p_sc.IsProgressed(id) <> prg_none) then
  begin
    if (ProgressStatus = Prg_Ignored) then
       MIIgnoreprogressGrp.Caption := _('Re-apply progress status')
    else if (ProgressStatus = Prg_NotIgnored) or (p_sc.IsProgressed(id) <> prg_none) then
       MIIgnoreprogressGrp.Caption := _('Ignore last progress statues')
    else
    begin
      MIIgnoreprogressGrp.Enabled := false;
      MIIgnoreprogressGrp.Visible := false;
    end;
  end
  else
  begin
    MIIgnoreprogressGrp.Enabled := false;
    MIIgnoreprogressGrp.Visible := false;
  end;


  if not CheckIfSplitIsPossible(Id) then
    MiSplitRemainGroup.Visible := false
  else
    MiSplitRemainGroup.Visible := true;

  p_sc.GetPlanInfo(Id, planInfo);

  if not planInfo.SplitAllow then
    MISplitGroup.Visible := false
  else
    MISplitGroup.Visible := true;

  MIIgnoreprogressGrp.Visible := MIIgnoreprogress.Visible;

  SetVisibilityForPopup(Sender);
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIBinHtmlReportClick(Sender: TObject);
begin
  HtmlBinExtraction(self, true, 0,0,-1);
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIBinExcelReportClick(Sender: TObject);
begin
  ExcelBinExtraction(self);
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.RefreshTimerTimer(Sender: TObject);
begin
  RefreshTimer.Interval := 1000;

  if m_RefreshDate then
    m_RefreshDate := false
  else m_RefreshDate := true;

  m_ShapeUpdateNow.Refresh;
  m_ShapeUpdateAvailable.Refresh;

{  if (m_HostDataWaiting and m_OtherStationDataWaiting) or m_HostDataWaiting then
  begin
    if (TbRefreshBtn.ImageIndex = -1) then
      TbRefreshBtn.ImageIndex := 45
    else
      TbRefreshBtn.ImageIndex := -1
  end
  else if m_OtherStationDataWaiting then
  begin
    if (TbRefreshBtn.ImageIndex = -1) then
      TbRefreshBtn.ImageIndex := 53
    else
      TbRefreshBtn.ImageIndex := -1
  end
  else
  begin
    // only downtime
    if (TbRefreshBtn.ImageIndex = -1) then
      TbRefreshBtn.ImageIndex := 45
    else
      TbRefreshBtn.ImageIndex := -1
  end;         }
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.TbRefreshBtnClick(Sender: TObject);
var
  NewItem : TMenuItem;
begin
  if (GetOccMoveForm <> nil) then
    Exit;
  DBAppGlobals.MAINPLAN_Ignore_Save_Event := true;
  DBAppGlobals.MAINPLAN_Ignore_Pain_When_refresh := true;
  TFWait.CreateWaitForm(self, w_Refresh, nil).ShowModal;
  DBAppGlobals.MAINPLAN_Ignore_Pain_When_refresh := false;

  if DBAppGlobals.ShowColorJobMode = DinamicPropList then
  begin
    if (GetIdFromCode(DBAppGlobals.LastPropColorInUseJobMode) <> nil) then
    begin
      NewItem := TMenuItem.Create(Self);
      NewItem.VCLComObject := GetIdFromCode(DBAppGlobals.LastPropColorInUseJobMode);
      ClickShowBarColorDynamic(NewItem);
    end
  end;

end;

//----------------------------------------------------------------------------//

function RefreshData : boolean;
const
  TRY_NUMBER = 14;
var
  qry:    TMqmQuery;
  DispoList : TStringList;
  j, I: integer;
begin
  p_sc.loopAllJobsSchedType(true);
  Result := false;
  qry := nil;

  if Assigned(FMQMPlan.MainProgBar) then
  begin
    FMQMPlan.MainProgBar.SetMax(TRY_NUMBER);
    FMQMPlan.MainProgBar.SetPosition(0);
  end;

  I := 0;

  while (I <= TRY_NUMBER) do
  begin

  //  try

      j := 0;

      while j <= TRY_NUMBER do
      begin
       // if GET_ACCESS(IniAppGlobals.WkstCode, AT_Lock) then
        if GET_ACCESS(IniAppGlobals.WkstCode, AT_Read) then
        begin
          Screen.Cursor := crHourGlass;
          qry := CreateQuery(Main_DB);
          Qry.Transaction := CreateTransaction(Main_DB);
          Qry.Transaction.StartTransaction;
          DispoList := TStringList.Create;
       //   try
          p_sc.UpdateClientForChanges(qry, p_pl.FindWrkCtrByCode, p_pl.PlanLinkJob, DispoList, FMQMPlan.MainProgBar);
       //   except
       //     ShowMessage(_('A minor problem occured during refresh. Please continue your work. Make sure to inform your system adminstrator about this message.'));
       //   end;

         if (IniAppGlobals.External_Database_Update = '1') and not DBAppGlobals.MCM_App then
            ExternalDB_UpdateMqmFromMcmEarliestLatestDates(qry, nil, nil, p_sc.p_WorkCentersHandledList, p_sc.p_WorkCentersViewedList);

          DBAppGlobals.MAINPLAN_Ignore_Save_Event := false;
          FMQMPlan.m_OtherStationDataWaiting := false;
          FMQMPlan.m_HostDataWaiting := false;
          p_pl.UpdateClientForCapResChanges(qry,DispoList,FMQMPlan.MainProgBar);
          FMQMPlan.m_MyStationEvent := true;
          DBUpdated;
          p_pl.m_today := GetDateForPlanLine;
          p_pl.m_todayAlgn := p_pl.m_Today;
          p_pl.ReorganizeAllIgnoredProgress(false, nil, nil);
          p_pl.ReorganizeAllProgress(false, nil, nil);
          p_sc.UpdateBalanceQuantity(true, nil);
          p_pl.ReorganizeAll(nil, nil);
          p_sc.loopAllJobsSchedType(false);
          Qry.Transaction.Commit;
          qry.Free;

        //  SP_END_ACCESS(IniAppGlobals.WkstCode,false);
          DBAppGlobals.MAINPLAN_Ignore_Pain_When_refresh := false;
          END_ACCESS(IniAppGlobals.WkstCode);
          FMQMPlan.ActiveUndo;
          FMQMPlan.RefreshActiveTab;
          FBin.UpdateForChangeFilter;

          if DBAppGlobals.MCM_App then
            RefreshMcmActiveGanttTab;

          FMQMPlan.RefreshTimer.Enabled := false;
          FMQMPlan.m_RefreshDate := false;
          FMQMPlan.m_ShapeUpdateAvailable.Paint;
          FMQMPlan.m_ShapeUpdateNow.Paint;

        //  FMQMPlan.TbRefreshBtn.ImageIndex := 45;
        //  FMQMPlan.TbRefreshBtn.Enabled := false;
          if DispoList.Count > 0 then
            ShowStringsInInfoForm(application, DispoList);
          FMQMPlan.MISave.Enabled := true;
          Screen.Cursor := crDefault;
          Result := true;
          Exit;
        end else
        begin
          inc(j);
          if (j > TRY_NUMBER) then
          begin
            if MessageDlg(_('Can not currently perform a resfresh as the host or a planner are writing to the database. Try again?'), mtConfirmation, [mbYes, mbNo], 0) = idYes then
              j := 0;
          end else
          begin
            if Assigned(FMQMPlan.MainProgBar) then
              FMQMPlan.MainProgBar.SetPosition(j);
            REMOVE_UNACTIVATED_STATIONS;
            Application.ProcessMessages;
            {if SP_ASK_POLL then
            begin
              Sleep(2500);
              inc(j);
              if Assigned(FMQMPlan.MainProgBar) then
                FMQMPlan.MainProgBar.SelEnd := j;
              Application.ProcessMessages;
              Sleep(2500);
              SP_CHECK_POLL;
            end else
              Sleep(2500); }
          end
        end;
      end;

   { except
      if assigned(qry) then
          qry.Free;
      inc(I);
      sleep(10);
    end; }
  end;

end;

//----------------------------------------------------------------------------//

procedure GetGanttTabsNameList(ListStrGanttTabsName : TStringList);
var
  i: integer;
  ts : TMqmPlanTabSheet;
  TabCfg : TPlanTabCfg;
begin
  if Assigned(FMQMPlan) then
  begin
    for i := 1 to FMQMPlan.m_pgcPlan.PageCount -1 do
    begin
      ts := TMqmPlanTabSheet(FMQMPlan.m_pgcPlan.Pages[i]);
      TabCfg := TPlanTabCfg(FMQMPlan.m_planTbCfg.FindTab(ts.GetCode));
      ListStrGanttTabsName.Add(TabCfg.name);
    end;
  end;
end;

//----------------------------------------------------------------------------//

function CheckMultiResInActiveTab : boolean;
var
  MQMPlan : TFMQMPlan;
begin
  MQMPlan := GetPlanView;
  Result := MQMPlan.CheckMultiResInActiveTab
end;

//----------------------------------------------------------------------------//

procedure SetActiveTabByName(Name : string);
var
  MQMPlan : TFMQMPlan;
begin
  MQMPlan := GetPlanView;
  MQMPlan.SetActiveTabByName(Name);
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.FormShow(Sender: TObject);
begin
  if not assigned(m_pgcPlan) then exit;
  if not Assigned(m_planTbCfg) then exit;
  if TMqmPlanTabSheet(m_pgcPlan.GetActiveView) = nil then exit;

  if (m_planTbCfg.p_GetTabsCount > 0) then
  begin
    //TrcBarZoom.SetFocus;
   // TrcBarZoom.Position := TMqmPlanTabSheet(m_pgcPlan.GetActiveView).p_zoom;
    TMqmPlanTabSheet(m_pgcPlan.GetActiveView).p_HeaderMan.m_CalPanel.FResourceTrcBarZoom.Position := TMqmPlanTabSheet(m_pgcPlan.GetActiveView).p_zoom;
    TMqmPlanTabSheet(m_pgcPlan.GetActiveView).p_HeaderMan.m_CalPanel.FHorizontalTrcBarZoom.Position := TMqmPlanTabSheet(m_pgcPlan.GetActiveView).p_Hzoom;

    if TMqmPlanTabSheet(m_pgcPlan.GetActiveView).p_Szoom >= 20 then
      TMqmPlanTabSheet(m_pgcPlan.GetActiveView).p_HeaderMan.m_CalPanel.FStatusZoom.Position := TMqmPlanTabSheet(m_pgcPlan.GetActiveView).p_Szoom
    else
      TMqmPlanTabSheet(m_pgcPlan.GetActiveView).p_HeaderMan.m_CalPanel.FStatusZoom.Position := 20;

    TrcBarStatusChange(self);
    TrcBarZoomChange(self);
  end;
  if ParamCount > 0 then
    RunAutomaticByCode(ParamStr(3));

  if Screen.Width < 1500 then
  begin
    toolButton1.Width := 200;
    toolbutton1.Left := 400;
  end
  else
    toolButton1.Width := 350;

end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiFrenchClick(Sender: TObject);
begin
  UseLanguage('fr');
  ReTranslateComponent (self);
  UpdateCaptions;
  DBAppGlobals.Language := 'fr';
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiArabicClick(Sender: TObject);
begin
  UseLanguage ('ar');
  ReTranslateComponent (self);
  UpdateCaptions;
  DBAppGlobals.Language := 'ar';
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIJobBarConfigClick(Sender: TObject);
var
  FBarConfigSets: TFBarConfigSets;
begin
  DMib.m_MainDB.Ping;  // will be catched by CommunicationException in case ping failed

  FBarConfigSets := TFBarConfigSets.Create(Self,'Job_bar');
  FBarConfigSets.ShowModal;
 {
  if FBarConfigSets.ModalResult = mrOK then
  begin
    FBarConfigSets.free;
    fBarConfig := TFBarConfig.Create(Self,'Job_bar');
    fBarConfig.ShowModal;
    fBarConfig.free;
    FBarConfigSets.ShowModal;
  end
  else
    FBarConfigSets.free;
    }
  FBarConfigSets.free;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIStatusbarConfigClick(Sender: TObject);
var
  FBarConfigSets: TFBarConfigSets;
begin
  DMib.m_MainDB.Ping;  // will be catched by CommunicationException in case ping failed
  FBarConfigSets := TFBarConfigSets.Create(Self,'Status_bar');
  FBarConfigSets.ShowModal;
  {
  if FBarConfigSets.ModalResult = mrOK then
  begin
    FBarConfigSets.free;
    fBarConfig := TFBarConfig.Create(Self,'Status_bar');
    fBarConfig.ShowModal;
    fBarConfig.free;
    FBarConfigSets.ShowModal;
  end
  else
    FBarConfigSets.free;
    }
  FBarConfigSets.free;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIScheduleReportClick(Sender: TObject);
var
  ActWcList : TList;
begin
  ActWcList := TList.Create;
  GetListForActPlanTab(ActWcList);
  FixedScheduleReport(self, ActWcList);
  ActWcList.Free;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MISetFinalClick(Sender: TObject);
var
  id : TSchedId;
begin
  id := TSchedId(m_popObj);
  p_opStack.SetSchedType(id, '2');

  RefreshActiveTab;

  if Assigned(FBin) then
    FBin.ChangeTabBinforChangeTabPlan
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MISetToTempClick(Sender: TObject);
var
  id : TSchedId;
begin
  id := TSchedId(m_popObj);
  p_opStack.SetSchedType(id, '1');

  RefreshActiveTab;
  if Assigned(FBin) then
    FBin.ChangeTabBinforChangeTabPlan
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MILabelClick(Sender: TObject);
begin
{$ifdef ARO}
  if SaveCurrBin then
  begin
    if not Assigned(FQReportLab) then
      FQReportLab := TFQReportLab.Create(Self);

    if FQReportLab.Showing then
      FQReportLab.SetFocus
    else
    begin
      with FQReportLab do
      begin
        QuickRep1.Prepare;
        iTot := QuickRep1.QRPrinter.PageCount;
        QuickRep1.QRPrinter.Free;
        QuickRep1.QRPrinter := nil;
        QuickRep1.Preview;
      end;
    end;
  end;
{$endif}
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiLastAutoSeqResultClick(Sender: TObject);
begin
//  if assigned(AutoSchedCfg) and assigned(GetAutoSeqLogInfoList) then
    ShowStringsInInfoForm(application, GetAutoSeqLogInfoList);
end;

//----------------------------------------------------------------------------//

//procedure TFMQMPlan.MIRollClick(Sender: TObject);
//begin
//{$ifdef ARO}
//  if SaveCurrBin then
//  begin
//    if not Assigned(FQReportRoll) then
//      FQReportRoll := TFQReportRoll.Create(Self);

//    if FQReportRoll.Showing then
//      FQReportRoll.SetFocus
//    else
//    begin
//      with FQReportRoll do
//      begin
//        QuickRep1.Prepare;
//        iTot := QuickRep1.QRPrinter.PageCount;
//        QuickRep1.QRPrinter.Free;
//        QuickRep1.QRPrinter := nil;
//        QuickRep1.Preview;
//      end;
//    end;
//  end;
//{$endif}
//end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIProdClick(Sender: TObject);
begin
{$ifdef ARO}
  if SaveCurrBin then
  begin
    if not Assigned(FQReportProd) then
      FQReportProd := TFQReportProd.Create(Self);

    if FQReportProd.Showing then
      FQReportProd.SetFocus
    else
    begin
      with FQReportProd do
      begin
        QuickRep1.Prepare;
        iTot := QuickRep1.QRPrinter.PageCount;
        QuickRep1.QRPrinter.Free;
        QuickRep1.QRPrinter := nil;
        QuickRep1.Preview;
      end;
    end;
  end;
{$endif}
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIMaterialsClick(Sender: TObject);
var
  planInfo: TSQplanInfo;
  TimingInfo: TSQtimingInfo;
  MachSetupCodeList :TMQMMacSetupList;
  MacSetupRec: TMacSetup;
  ProdStep, WkcProc: String;
  Res: TmqmRes;
  IssArtList: TMQMIssuedArtList;
  FrmMat: TFShowMaterials;
  id: TSchedId;
begin
  id := TSchedId(m_popObj);

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
  end
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MISetLevelTo1Click(Sender: TObject);
var
  id : TSchedId;
begin
  id := TSchedId(m_popObj);
  p_opStack.SetSchedType(id, '3');

  RefreshActiveTab;

  if Assigned(FBin) then
    FBin.ChangeTabBinforChangeTabPlan
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MISetLevelTo2Click(Sender: TObject);
var
  id : TSchedId;
begin
  id := TSchedId(m_popObj);
  p_opStack.SetSchedType(id, '4');

  RefreshActiveTab;

  if Assigned(FBin) then
    FBin.ChangeTabBinforChangeTabPlan
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MISetLevelTo3Click(Sender: TObject);
var
  id : TSchedId;
begin
  id := TSchedId(m_popObj);
  p_opStack.SetSchedType(id, '5');

  RefreshActiveTab;

  if Assigned(FBin) then
    FBin.ChangeTabBinforChangeTabPlan
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MISetLevelTo4Click(Sender: TObject);
var
  id : TSchedId;
begin
  id := TSchedId(m_popObj);
  p_opStack.SetSchedType(id, '6');

  RefreshActiveTab;

  if Assigned(FBin) then
    FBin.ChangeTabBinforChangeTabPlan
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MISetLevelTo5Click(Sender: TObject);
var
  id : TSchedId;
begin
  id := TSchedId(m_popObj);
  p_opStack.SetSchedType(id, '7');

  RefreshActiveTab;

  if Assigned(FBin) then
    FBin.ChangeTabBinforChangeTabPlan
end;

procedure TFMQMPlan.MISetLevelToClick(Sender: TObject);
begin

end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MISetIniFinClick(Sender: TObject);
var
  id : TSchedId;
begin
  id := TSchedId(m_popObj);
  if (p_sc.GetSchedType(id) = '2') then
    p_opStack.SetSchedType(id, '1')
  else
    p_opStack.SetSchedType(id, '2');

  RefreshActiveTab;

  if Assigned(FBin) then
    FBin.ChangeTabBinforChangeTabPlan
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiSetjobslimitdatesClick(Sender: TObject);
var
  ActiveTbs : TMqmPlanTabSheet;
  VisRes    : TMqmVisibleRes;
  Res       : TMqmRes;
  I, J, G {, P}  : Integer;
  Id , ChildId{, TempId}: TSchedId;
  ActArea   : TMQMActArea;
  Proprty   : TProperties;
  PropId : TPropId;
  PropCode  : string;
  ForcesInfo: TSQForcesInfo;
  PlanInfo : TSQplanInfo;
  DatesInfo{, DatesInfoTemp} : TSQDatesInfo;
  cal      : TPGCALObj;
  Capacity, SecureNumDays : integer;
  AddedCapacity : double;
  jobPropVal, jobPropVal1, TempEndDateTime : TDateTime;
  Save_Cursor : TCursor;
//  StepInfo: TSQStepInfo;
//  TimingInfo: TSQtimingInfo;
//  StepList  : TList;
//  PrevReqJobs : TMSchedList;
begin
  SecureNumDays := 0;
  Capacity := 0;
  if IniAppGlobals.SetLimiDateUsingCapacity <> '' then
  begin
    try
      Capacity := StrToInt(IniAppGlobals.SetLimiDateUsingCapacity);
    except
      ShowMessage('Please define a capacity first');
      Exit;
    end
  end;

  if IniAppGlobals.SetLimiDateUsingSecureNumDays <> '' then
  begin
    try
      SecureNumDays := StrToInt(IniAppGlobals.SetLimiDateUsingSecureNumDays);
    except
      ShowMessage('Please define number of days secure first');
      Exit;
    end
  end;

  PropId := GetCalculatedHighDateProp;
  if PropId = nil then exit;
  Save_Cursor   := Screen.Cursor;
  Screen.Cursor  := crAppStart; //SQLWait;

  PropCode := GetPropCodeFromID(PropId);
  ActiveTbs := FMQMPlan.GetActiveTab;

  for i := 0 to ActiveTbs.p_ganttPanel.p_VisResList.Count-1 do
  begin
    Application.ProcessMessages;
    VisRes := TMqmVisibleRes(ActiveTbs.p_ganttPanel.p_VisResList[i]);
    Res := TMqmRes(TMqmVisibleRes(VisRes).p_father);
    if TMqmWrkCtr(res.p_father).p_ReadOnly then continue;
    ActArea := TMqmActArea(VisRes.p_ActArea[0]);
    if ActArea.SchedObjsCount = 0 then continue;
    for J := 0 to ActArea.p_ObjCount - 1 do
    begin
      id := ActArea.GetSchedObj(j);
      p_sc.GetForcesInfo(id, ForcesInfo);
      if p_sc.GetHighEndTimeLimitOverriden(id) then continue;
      if (ForcesInfo.FrcHighestDate = CSF_RequestedHighesEndDate) then
      begin
        if (CProgress(p_sc.IsProgressed(id)) <> prg_none) then continue;
        p_sc.SetEarliestLatestDate(Id, 0, 0, true, true, false, CSF_NO);
      end
    end;
  end;

  for i := 0 to ActiveTbs.p_ganttPanel.p_VisResList.Count-1 do
  begin
    Application.ProcessMessages;
    VisRes := TMqmVisibleRes(ActiveTbs.p_ganttPanel.p_VisResList[i]);
    Res := TMqmRes(TMqmVisibleRes(VisRes).p_father);
    if TMqmWrkCtr(res.p_father).p_ReadOnly then continue;
    ActArea := TMqmActArea(VisRes.p_ActArea[0]);
    if ActArea.SchedObjsCount = 0 then continue;
    jobPropVal := 0;
    for J := 0 to ActArea.p_ObjCount - 1 do
    begin
      id := ActArea.GetSchedObj(j);
      p_sc.GetForcesInfo(id, ForcesInfo);
      if (ForcesInfo.FrcHighestDate = CSF_RequestedHighesEndDate) then
      begin
        if (CProgress(p_sc.IsProgressed(id)) <> prg_none) then continue;
        if p_sc.GetHighEndTimeLimitOverriden(id) then continue;

        p_sc.GetPlanInfo(id, PlanInfo);
        p_sc.GetDatesInfo(id, DatesInfo);

        if (jobPropVal <> 0) and (PlanInfo.startDate < jobPropVal) then
           PlanInfo.startDate := jobPropVal;

//        G := 0;
//        ChildId := CSchedIDnull;
//        while True do
//        begin
//          if (planInfo.isGroup) then
//          begin
//            if G = p_sc.GetGrpNumSons(Id) then break;
//            ChildId := p_sc.GetGrpSon(Id, G);
//            G := G + 1;
//          end
//          else
//          begin
//            if ChildId <> CSchedIDnull then break;
//            ChildId := Id;
//          end;
//          p_sc.GetTimingInfo(ChildId, TimingInfo);
//          if p_sc.GetPrecStepToSched(TimingInfo.prodReq, TimingInfo.step, StepInfo) then
//          begin
//            if StepInfo.HighEnd > PlanInfo.startDate then
//              PlanInfo.startDate := StepInfo.HighEnd;
//            Continue;
//          end;
        {  PrevReqJobs := TMSchedList.Create(self);
          p_sc.GetPrevConnReqLastStepJobs(ChildId, PrevReqJobs);
          for P := 0 to PrevReqJobs.GetLinkCount -1 do
          begin
            TempId := PrevReqJobs.GetLink(p);
            if Assigned(p_sc.GetExtLinkPtr(TempId)) then
            begin
              p_sc.GetDatesInfo(TempId, DatesInfoTemp);
              if DatesInfoTemp.HighEndDate > PlanInfo.startDate then
                PlanInfo.startDate := DatesInfoTemp.HighEndDate;
            end;
          end;
          PrevReqJobs.ClearList;
          PrevReqJobs.Free;  }
//        end;

        AddedCapacity := Capacity/100 * PlanInfo.exeMin;
        cal := ActArea.GetCalendar;
        cal.OfsByWH((PlanInfo.supMinReal + PlanInfo.exeMin + AddedCapacity)/60, true, PlanInfo.startDate , TempEndDateTime, ActArea.m_CrossDownTmList);
        if (TempEndDateTime < (DatesInfo.HighEndDateTemp - SecureNumDays)) then
          jobPropVal1 := DatesInfo.HighEndDateTemp - SecureNumDays
        else
          jobPropVal1 := TempEndDateTime;
        jobPropVal := TempEndDateTime;

        if jobPropVal1 > DatesInfo.HighEndDate then
          p_sc.SetEarliestLatestDate(Id, 0, jobPropVal1, true, true, false, CSF_NO)
        else
          continue;
        if planInfo.isGroup then
        begin
          for G := 0 to p_sc.GetGrpNumSons(Id) - 1 do
          begin
            ChildId := p_sc.GetGrpSon(Id, G);
            Proprty := p_sc.GetProperties(ChildId,nil);
            FMPlannerPropDefine.UpdatePropInJobList(Proprty, PropId, DateTimeToStr(jobPropVal1));
            UpdateMainListPropChange(ChildId, PropCode, DateTimeToStr(jobPropVal1), false);
          end;
        end
        else
        begin
          Proprty := p_sc.GetProperties(ID,nil);
          FMPlannerPropDefine.UpdatePropInJobList(Proprty, PropId, DateTimeToStr(jobPropVal1));
          UpdateMainListPropChange(Id, PropCode, DateTimeToStr(jobPropVal1), false);
        end;
      end;
    end;
  end;

  for i := 0 to ActiveTbs.p_ganttPanel.p_VisResList.Count-1 do
  begin
    Application.ProcessMessages;
    VisRes := TMqmVisibleRes(ActiveTbs.p_ganttPanel.p_VisResList[i]);
    Res := TMqmRes(TMqmVisibleRes(VisRes).p_father);
    if TMqmWrkCtr(res.p_father).p_ReadOnly then continue;
    ActArea := TMqmActArea(VisRes.p_ActArea[0]);
    if ActArea.SchedObjsCount = 0 then continue;
    for J := 0 to ActArea.p_ObjCount - 1 do
    begin
      id := ActArea.GetSchedObj(j);
      p_sc.GetForcesInfo(id, ForcesInfo);
      if (ForcesInfo.FrcHighestDate <> CSF_RequestedHighesEndDate) then continue;
      if (CProgress(p_sc.IsProgressed(id)) <> prg_none) then continue;
      if p_sc.GetHighEndTimeLimitOverriden(id) then continue;
      p_sc.GetDatesInfo(id, DatesInfo);
      if DatesInfo.HighEndDate = 0 then
      begin
        p_sc.SetEarliestLatestDate(Id, 0, DatesInfo.HighEndDateTemp , true, true, false, CSF_NO);
        Continue;
      end;
      p_sc.SetHighEndTimeLimitOverriden(Id, true);
      p_sc.SetHighEndTimeLimitCustomer(Id, CSD_Calculated);
    end;
  end;
  p_sc.OrganizeHighLimitToAllRequest;

  RefreshActiveTab;
  if Assigned(FBin) then
    Fbin.RefreshGrid;
  Screen.Cursor := Save_Cursor;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MISetNextLevelClick(Sender: TObject);
var
  id : TSchedId;
begin
  id := TSchedId(m_popObj);

  if (p_sc.GetSchedType(id) = '1') and (DBAppGlobals.ConfLevels >= 2) then
    p_opStack.SetSchedType(id, '3')
  else if (p_sc.GetSchedType(id) = '4') and (DBAppGlobals.ConfLevels >= 3) then
    p_opStack.SetSchedType(id, '5')
  else if (p_sc.GetSchedType(id) = '5') and (DBAppGlobals.ConfLevels >= 4) then
    p_opStack.SetSchedType(id, '6')
  else if (p_sc.GetSchedType(id) = '6') and (DBAppGlobals.ConfLevels >= 5) then
    p_opStack.SetSchedType(id, '7')
  else if (p_sc.GetSchedType(id) = '7') and (DBAppGlobals.ConfLevels >= 6) then
    p_opStack.SetSchedType(id, '8')
  else
    p_opStack.SetSchedType(id, '2');

  RefreshActiveTab;

  if Assigned(FBin) then
    FBin.ChangeTabBinforChangeTabPlan
end;

procedure TFMQMPlan.MISetNextLevelGrpClick(Sender: TObject);
begin

end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIShowbintoolbarClick(Sender: TObject);
begin
  if not assigned(FBin) then exit;
  if not assigned(FToolBar) then exit;
  if DBAppSettings.ShowBinToolBar then
    FToolBar.Show
  else
    MessageDlg(_('First enable this option on the configuration'), mtInformation, [mbOK], 0);

end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIAboutClick(Sender: TObject);
begin
  if FAbout = nil then
    TFAbout.Create(Self);
 // FAbout.ShowModal;
  ///FAbout.Free;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIShowrequiermentsClick(Sender: TObject);
var
  planInfo: TSQplanInfo;
  TimingInfo: TSQtimingInfo;
  MachSetupCodeList :TMQMMacSetupList;
  MacSetupRec: TMacSetup;
  ProdStep, WkcProc: String;
  Res: TmqmRes;
  IssArtList: TMQMIssuedArtList;
  FrmMat: TFMaterialReq;//TForm2;//TFShowMaterials;
  id: TSchedId;
begin
  id := TSchedId(m_popObj);

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
  end
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiShowScheduledJobsClick(Sender: TObject);
begin
  ShowScheduledJobsOnRes(now - (DaysInYear(YearOf(Now)) * 2), now + (DaysInYear(YearOf(Now)) * 2), TMqmRes(TMqmVisibleRes(m_popObj).p_father));
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiShowScheduledJobsFromPointClick(Sender: TObject);
var
  MqmRes : TMqmRes;
begin
  MqmRes := TMqmRes(TMqmVisibleRes(TMqmActArea(m_popObj).p_father).p_father);
  ShowScheduledJobsOnRes(m_popDate, now + (DaysInYear(YearOf(Now)) * 2), MqmRes);
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIShowWarpCompatibleClick(Sender: TObject);
var
  i,m_id : Integer;
  IssuedAL: PTIssuedArt;
  ListMatNotAvail : TList;
  IssArtList: TMQMIssuedArtList;
  MacSetupRec: TMacSetup;
  planInfo: TSQplanInfo;
  TimingInfo: TSQtimingInfo;
  MachSetupCodeList :TMQMMacSetupList;
  TmpMacSetup: TMQMMachineSetup;
  Res: TmqmRes;
  MqmActArea : TMqmActArea;
  IdWarp : TschedId;
  ProdTypeBaseLvl : string;
  ProdTypeSecondLvl : string;
  ProductBaseLvl : string;
  ProductSecondLvl : string;
  WarpLvl : ArMaterialScheduleLvl;
  WarpObj, WarpObjB  : TMqmWarp;
  FoundWarp : boolean;
begin
  FoundWarp := false;
  m_id := TSchedId(m_popObj);
  p_sc.GetPlanInfo(m_id, planInfo);
  p_sc.GetTimingInfo(m_id, TimingInfo);
  MacSetupRec.WrkCtrCode := TimingInfo.wkctCode;
  MacSetupRec.MachineSetupCode := TimingInfo.MachSetupCode;
  MachSetupCodeList := p_sc.GetStepIssMaterials(m_id);
  ListMatNotAvail := nil;

  ListMatNotAvail := TList.Create;
  IssArtList := TMQMIssuedArtList.Create(true);
  MachSetupCodeList.GetIssuedArtList(MacSetupRec, IssArtList);
  MachSetupCodeList := p_sc.GetStepIssMaterials(m_id);
  p_sc.GetListMatNotAvail(m_id, IssArtList, ListMatNotAvail);

  for i:= 0 to IssArtList.p_count-1 do
  begin
    IssuedAL := IssArtList.p_Item[i];
    if IssuedAL.Article.p_MaterialSchedule = MT_BaseLvl then
    begin
      FoundWarp := true;
      ProdTypeBaseLvl := IssuedAL.Article.p_ArtType.p_ArtTypeCode;
      ProductBaseLvl  := IssuedAL.Article.p_ArtCode;
    end else if IssuedAL.Article.p_MaterialSchedule = MT_SecondLvl then
    begin
      FoundWarp := true;
      ProdTypeSecondLvl := IssuedAL.Article.p_ArtType.p_ArtTypeCode;
      ProductSecondLvl  := IssuedAL.Article.p_ArtCode;
    end;
  end;

  if not FoundWarp then
  begin
    showmessage(_('There isnt any warp available for this job'));
    ListMatNotAvail.Free;
    IssArtList.Free;
    Exit;
  end;

  MqmActArea := TMqmActArea(p_sc.GetExtLinkPtr(m_id));
  if assigned(MqmActArea) then
    FBin.ShowCompatibleWarpForJob(ProdTypeBaseLvl,ProductBaseLvl,ProdTypeSecondLvl,ProductSecondLvl);
  ListMatNotAvail.Free;
  IssArtList.Free;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiSlotDetailsClick(Sender: TObject);
var
  PlanWcView : TPlanWcView;
  pt : TMqmPlanTabSheet;
  WcList, AllWc : TList;
  EntityCode : string;
  SlotGroup : Integer;
  grp : TPlanLineGroup;
  WC : TMqmWrkCtr;
  TabCfg : TPlanTabCfg;

  // collect every work center belonging to a group/plant/division by its code,
  // independent of the (sometimes empty) cached WC list on the group line
  procedure GatherByCode(Code : string);
  var k : Integer; w2 : TMqmWrkCtr;
  begin
    if not assigned(AllWc) then exit;
    for k := 0 to AllWc.Count - 1 do
    begin
      w2 := TMqmWrkCtr(AllWc[k]);
      // skip read-only + invisible WCs, same as the slot-sum build (UMPlanTbs)
      if (w2.p_ReadOnly) and (not w2.p_Visible) then continue;
      if (SlotGroup = 1) and (w2.P_WcGrp = Code) then WcList.Add(w2)
      else if (SlotGroup = 2) and (w2.p_PlantCode = Code) then WcList.Add(w2)
      else if (SlotGroup = 3) and (w2.p_Division = Code) then WcList.Add(w2);
    end;
  end;

begin
  pt := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
  if not Assigned(pt) then exit;
  PlanWcView := pt.p_PlanWcControl.P_planWcView;

  // Preferred path: any slot level (WC / WC-Group / Plant / Division / Property /
  // Category) via the right-clicked plan line captured at popup time.
  if Assigned(m_MqmSlotInfoLine) then
  begin
    WcList := TList.Create;
    AllWc  := nil;
    EntityCode := '';
    SlotGroup := PlanWcView.p_pShot.p_SlotGroup;
    TabCfg := TPlanTabCfg(m_planTbCfg.FindTab(pt.GetCode));
    if Assigned(TabCfg) then AllWc := TabCfg.GetWorkCenterList;

    if m_MqmSlotInfoLine is TPlanLineWc then
    begin
      WC := TPlanLineShow(m_MqmSlotInfoLine).P_WcGroup.P_WrkCtr;
      if assigned(WC) then WcList.Add(WC);
    end
    else if m_MqmSlotInfoLine is TPlanLineWCGroup then
      GatherByCode(TPlanLineWCGroup(m_MqmSlotInfoLine).p_Group_name)
    else if m_MqmSlotInfoLine is TPlanLineSecondLevel then
    begin
      EntityCode := TPlanLineShow(m_MqmSlotInfoLine).m_lineHd;
      grp := TPlanLineShow(m_MqmSlotInfoLine).P_WcGroup;
      if (grp.p_numSons > 0) and (grp.p_son[0].ClassName = 'TPlanLineWCGroup') then
        GatherByCode(TPlanLineWCGroup(grp.p_son[0]).p_Group_name)
      else
      begin
        WC := grp.P_WrkCtr;
        if assigned(WC) then WcList.Add(WC);
      end;
    end;

    TSlotInfo.CreateSlotInfoForWcList(self, PlanWcView, WcList, EntityCode,
      m_SlotInfoSlotStart, m_SlotInfoSlotEnd - 1/24/3600).ShowModal;

    WcList.Free;
    if assigned(AllWc) then AllWc.Free;
    exit;
  end;

  // Fallback: original work-center-only path (e.g. keyboard selection)
  if m_SelectedListWrkCtrPopUp = nil then exit;
  if m_SelectedListWrkCtrPopUp.Count < 1 then exit;
  if PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_WkCtr = nil then exit;

  TSlotInfo.CreateSlotInfo(self, PlanWcView, PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_WkCtr, PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_startDt, PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_endDt - 1/24/3600).ShowModal;

//  if Assigned(Fbin) then
//    Fbin.FilterJobsWcByDate(PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_WkCtr ,PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_lngDscSlot,  PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_startDt, PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_endDt - 1/24/3600);
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiSlotFilterTabClick(Sender: TObject);
begin
  TFConfigBin.CreateCfgBin(Self, Tb_FilterSlot).ShowModal;
  SaveDefaultTabSlotFilter;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIResetBinClick(Sender: TObject);
begin
  if not assigned(FBin) then
  begin
    FBin := TFBin.Create(self);
    if not DBAppGlobals.MCM_App then
       GeneratePopupMenus;
    FBin.Show;
    fbin.ChangeTabBinforChangeTabPlan;
  end else
   FBin.ResetBinState;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIResourceReportClick(Sender: TObject);
var
  I, J, K : Integer;
  NewItem : TMenuItem;
begin
  MiStatisticsUndo.Visible := false;
  MiStatisticsShow.Visible := false;
  MiStatisticsClean.Visible := false;

  for K := MiStatisticsUndo.Count - 1 downto 0 do
      MiStatisticsUndo[K].free;

  if GetScheduleStatisticArraySize > 0 then
  begin
    MiStatisticsShow.Visible := true;
    MiStatisticsClean.Visible := true;
  end;

  for J := 0 to GetScheduleStatisticArrayCount do
  begin
    if GetStatisticStackMarkByIndex(J) > (p_opStack.GetUndoListCount) then
       continue; // maybe we need also to delete this place from the array ? boooo

    NewItem := TMenuItem.Create(Self);
    NewItem.Caption := GetSetScheduleStatisticName(J);//GetScheduleStatisticTimeCreate(J);
    NewItem.Name    := 'Undostatistic' + IntToStr(J);
    NewItem.OnClick := MiStatisticsUndoClick;
    NewItem.VCLComObject := Pointer(J);
    MiStatisticsUndo.add(NewItem);
    MiStatisticsUndo.Visible := true;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIFileClick(Sender: TObject);
begin
  DMib.m_MainDB.Ping;  // will be catched by CommunicationException in case ping failed
  Application.ProcessMessages;
  if not SP_SRVLOAD_GET_STATUS_OPENED_OR_CLOSED then
    MIDownLoadFromHost.Enabled := false;
end;

procedure TFMQMPlan.MiFiltercurrentbinbyGroupClick(Sender: TObject);
begin
  if m_SelectedListWrkCtrPopUp.Count < 1 then exit;
  if PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_WkCtr = nil then exit;
//  Fbin.FilterJobsWcByDate(PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_WkCtr ,PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_lngDscSlot,  PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_startDt, PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_endDt - 1);
  if Assigned(Fbin) then
    Fbin.FilterJobsWcGroupByDate(PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_WkCtr ,PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_lngDscSlot,  PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_startDt, PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_endDt - 1/24/3600);

end;

//----------------------------------------------------------------------------//

function TFMQMPlan.RemoveAmpersand(ACaption : string) : string;
begin
  Result := ACaption;
  while Pos('&',Result) > 0 do
  System.Delete(Result,Pos('&',Result),1);
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.UpdateBalanceListFromDB;
var
  qry : TMqmQuery;
begin
  qry := CreateQuery(Main_DB);
  Qry.Transaction := CreateTransaction(Main_DB);
  try
    p_ArtTypeList.ClearBalanceLists;
    p_ArtTypeList.LoadFromDb(qry, nil, nil, p_sc.p_WorkCentersHandledList, p_sc.p_WorkCentersViewedList);
  except
  end;
  qry.Close;
  qry.Free;
end;

//----------------------------------------------------------------------------//

{procedure TFMQMPlan.DrawItemTitleMainMenu(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; Selected: Boolean);
var
  s: string;
begin
   if TStyleManager.ActiveStyle.Name = 'Windows' then
  begin
  ACanvas.Font.Size := 10;
  ACanvas.Font.Color := ClWhite;
  ACanvas.Brush.Color := $00412D23;
  ACanvas.FillRect(Arect);
  s:= RemoveAmpersand(TMenuItem(Sender).Caption);



    if TMenuItem(Sender).name = 'MiBlanck' then
    begin
      ACanvas.Font.Size := 13;
      ACanvas.TextOut(ARect.Left, ARect.Top, '              ' +
                               '                                         ' +
                               '                                         ' +
                               '                                         ' +
                               '                                         ' +
                               '                                         ' +
                               '                                         ' +
                               '                                         ' +
                               '                                         ' +
                               '                                         ' +
                               '                                         ');
    end
    else
      ACanvas.TextOut(ARect.Left + 2, ARect.Top +2, s);
  end;
end; }

//----------------------------------------------------------------------------//

{procedure TFMQMPlan.DrawItemPopUp(Sender: TObject; ACanvas: TCanvas;
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
  ACanvas.TextOut(ARect.Left + 25,ARect.Top +2,RemoveAmpersand(TMenuItem(sender).Caption));
  if TMenuItem(sender).Checked = True then
      MainMenuIcons.Draw(ACanvas, ARect.Left, ARect.Top + 2, 8);

  if TMenuItem(sender).ImageIndex > -1 then
  begin  //if image has been assigned
    tmpImage := TBitmap.Create;
    try
      tmpImage.TransparentMode:= tmFixed;
      tmpImage.Transparent := True;
      tmpImage.TransparentColor:= clWhite;
      TMenuItem(sender).GetParentMenu.Images.GetBitmap((TMenuItem(sender).ImageIndex), tmpImage);
      ACanvas.draw(ARect.Left ,ARect.Top +2, tmpImage);
    except
    end;
    tmpImage.Free;
  end;
end;}

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiGroupedByFiledClick(Sender: TObject);
var
  GroupedByFieldsSet : TFGroupedByFieldsSet;
begin
  GroupedByFieldsSet := TFGroupedByFieldsSet.CreateGroupedByFieldsSet(Self);
  if GroupedByFieldsSet.ShowModal = mrOk then
    GroupedByFieldsSet.free;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIDnLoadUploadReqClick(Sender: TObject);
begin
  if SP_SRVLOAD_GET_STATUS_OPENED_OR_CLOSED then
    OPERATE_DOWNLOAD_REQUEST(IniAppGlobals.WkstCode, 'DNLUPL')
  else
    ShowMessage('Server is closed - Please contact the operator');
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIDownloadProdClick(Sender: TObject);
begin
  if SP_SRVLOAD_GET_STATUS_OPENED_OR_CLOSED then
    OPERATE_DOWNLOAD_REQUEST(IniAppGlobals.WkstCode, 'DOWNLD')
  else
    ShowMessage('Server Load is down');
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIOnlyUploadClick(Sender: TObject);
begin
  if SP_SRVLOAD_GET_STATUS_OPENED_OR_CLOSED then
    OPERATE_DOWNLOAD_REQUEST(IniAppGlobals.WkstCode, 'UPLOAD')
  else
    ShowMessage('Server Load is down');
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiPuchJobsByActiveTabClick(Sender: TObject);
begin
  DBAppGlobals.OrganizeJobsAfterDoday := true;
  DBAppGlobals.MAINPLAN_Ignore_Save_Event := true;
  MiniMizedMainForm;
  if TMenuItem(Sender).name = 'MiPuchJobsByActiveTab' then
    TFWait.CreateWaitForm(self, w_MoveByActTabAfterToday, nil).ShowModal
  else if TMenuItem(Sender).name = 'MiPuchJobsAndCloseGapsByActiveTab' then
    TFWait.CreateWaitForm(self, w_MoveByActTabAfterTodayAndCloseGaps, nil).ShowModal;
  MaxiMizedMainForm;
  DBAppGlobals.OrganizeJobsAfterDoday := false;
  DBAppGlobals.MAINPLAN_Ignore_Save_Event := false;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiPushAllJobsClick(Sender: TObject);
begin
  DBAppGlobals.OrganizeJobsAfterDoday := true;
  DBAppGlobals.MAINPLAN_Ignore_Save_Event := true;
  MiniMizedMainForm;
  if TMenuItem(Sender).name = 'MiPushAllJobs' then
    TFWait.CreateWaitForm(self, w_MoveAllAfterToday, nil).ShowModal
  else if  TMenuItem(Sender).name = 'MiPushAllJobsAndCloseGaps' then
    TFWait.CreateWaitForm(self, w_MoveAllAfterTodayAndCloseGaps, nil).ShowModal;
  MaxiMizedMainForm;
  DBAppGlobals.OrganizeJobsAfterDoday := false;
  DBAppGlobals.MAINPLAN_Ignore_Save_Event := false;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIApaEditPlanClick(Sender: TObject);
var
  ResFilter: TFResFilter;
  activeTab: integer;
  ConfTab: TPlanTabCfg;
  isMcm, ShowModalResult : Boolean;
begin
  activeTab := m_pgcPlan.GetActiveView.GetCode;
  ConfTab := TPlanTabCfg(m_planTbCfg.FindTab(activeTab));
  ShowModalResult := false;
  if DBAppGlobals.MCM_App then
    isMcm := true;

  ResFilter := TFResFilter.EditFrmResFilter(self, ConfTab.name, ConfTab.GetWorkCenterList, ConfTab.res, isMCm);
  if ResFilter.ShowModal = mrOk then
  begin
    ShowModalResult := true;
    m_planTbCfg.UpdateTab(activeTab, ResFilter.P_GetTabName, ResFilter.GetResList, ResFilter.P_SlotGoup);
    TMqmPlanTabSheet(m_pgcPlan.GetActiveView).UpdatePlanTbs(m_pgcPlan, m_planTbCfg, ConfTab.code);
    TMqmPlanTabSheet(m_pgcPlan.GetActiveView).p_PlanWcControl.P_planWcView.p_pShot.p_SlotGroup := ResFilter.P_SlotGoup;
    ConfTab.m_SlotGroup := ResFilter.P_SlotGoup;
    TMqmPlanTabSheet(m_pgcPlan.GetActiveView).SetDynamicMcmTabData(ConfTab.GetWorkCenterList);
    if isMcm then
      RefreshWkcGroup;
    TMqmPlanTabSheet(m_pgcPlan.GetActiveView).p_HeaderMan.m_CalPanel.FResourceTrcBarZoom.Position := TMqmPlanTabSheet(m_pgcPlan.GetActiveView).p_zoom;
    TMqmPlanTabSheet(m_pgcPlan.GetActiveView).p_HeaderMan.m_CalPanel.FHorizontalTrcBarZoom.Position := TMqmPlanTabSheet(m_pgcPlan.GetActiveView).p_Hzoom;
    TrcBarZoomChange(self);
  end;

  ResFilter.Free;
  if ShowModalResult then
  begin
    PgcMainChange(self);
    PgcBinChange
  end;
end;

procedure TFMQMPlan.MiAutomaticOperationClick(Sender: TObject);
begin

end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.CustomizedResourceList1Click(Sender: TObject);
var
  CustResList: TFConfigResList;
  ActiveTab: integer;
  ConfTab: TPlanTabCfg;
  Tab : TMqmPlanTabSheet;
begin
  Tab := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
  if not Assigned(Tab) then exit;
  Tab.p_ganttPanel.p_SortType := SRT_Customized;
  ActiveTab := m_pgcPlan.GetActiveView.GetCode;
  ConfTab := TPlanTabCfg(m_planTbCfg.FindTab(ActiveTab));
  CustResList := TFConfigResList.CreateCfgResList(self, ConfTab.res);
  if CustResList.ShowModal = mrOk then
  begin
    m_planTbCfg.UpdateTabNewSort(activeTab, ConfTab.name, CustResList.GetResList);
    Tab.p_ganttPanel.UpdateList(CustResList.GetResList);
    //PnlZoom.Visible := true;
    TMqmPlanTabSheet(m_pgcPlan.GetActiveView).p_HeaderMan.m_CalPanel.FResourceTrcBarZoom.Position := TMqmPlanTabSheet(m_pgcPlan.GetActiveView).p_zoom;
    TMqmPlanTabSheet(m_pgcPlan.GetActiveView).p_HeaderMan.m_CalPanel.FHorizontalTrcBarZoom.Position := TMqmPlanTabSheet(m_pgcPlan.GetActiveView).p_Hzoom;
    TrcBarZoomChange(self);
    PgcBinChange;
  end;
  CustResList.Free
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MISubResCollapseClick(Sender: TObject);
begin
  ExpOrCollSubRes(false);
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MISubResExpandClick(Sender: TObject);
begin
  ExpOrCollSubRes(true);
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiToolsClick(Sender: TObject);
begin
  //CheckConnectionClick(self);
  if GetListCountForAutoRunSet = 0 then
    MiAutomaticOperation.Visible := false
  else //if not MiAutomaticOperation.Visible then
  begin
    SetDynamcMenuForAutoRunCodes;
    MiAutomaticOperation.Visible := true;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.PopResPopup(Sender: TObject);
var
  I: integer;
  VisRes : TMQMVisibleRes;
begin
  for I := 0 to PopRes.Items.Count - 1 do
  begin
    PopRes.Items[I].Enabled := true;
    PopRes.Items[I].Visible := true;
  end;

  VisRes := TMqmVisibleRes(m_popObj);
  if VisRes.p_isSubRes then // This check should be working opposite
  begin
    N12.Enabled := false;
    MISubRes.Enabled := false;
  end;

  if (DBAppSettings.CreateNewBinTabForCompatibles = NewB_No) and (DBAppSettings.ShowCompatibleInExistingBINS = ShowC_No) then
  begin
    MICompatInBin.Visible    := false;
    MIClearCompInBin.Visible := false;
  end;

  SetVisibilityForPopup(Sender);

  if DBAppGlobals.MCM_App then
     MIResDetails.Visible := true;

end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.PopupWarp(Sender: TObject);
begin
  //
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.PopupWcLevelPopup(Sender: TObject);
begin
  if not DBAppGlobals.MCM_App then
  begin
    MiTabHandle.Visible := False;
   // Editgantttab1.Visible := False
  end;

  if assigned(TMqmWrkCtr(m_MqmWrkCtrPopUp)) then
    Iwkc.Caption := TMqmWrkCtr(m_MqmWrkCtrPopUp).p_WrkCtrCode
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.OnPopupWcSlot(Sender: TObject);
begin
  if Assigned(m_SelectedListWrkCtrPopUp) and (m_SelectedListWrkCtrPopUp.Count = 1) then
    IFilterBinBySlot.Visible := true
  else
    IFilterBinBySlot.Visible := false;

  //MiFiltercurrentbinbyGroup.Visible := TPlanTabCfg(m_planTbCfg.GetTab(GetActiveTab.GetCode)).m_SlotGroup > 0;

//  if assigned(TMqmWrkCtr(m_MqmWrkCtrPopUp)) then
//    Iwkc.Caption := TMqmWrkCtr(m_MqmWrkCtrPopUp).p_WrkCtrCode
end;

//----------------------------------------------------------------------------//


procedure TFMQMPlan.OnClickRefreshDate(Sender: TObject);
var
  NewItem : TMenuItem;
begin
  if not RefreshTimer.Enabled then exit;

  if (GetOccMoveForm <> nil) then
    Exit;

  DBAppGlobals.MAINPLAN_Ignore_Save_Event := true;
  DBAppGlobals.MAINPLAN_Ignore_Pain_When_refresh := true;
  TFWait.CreateWaitForm(self, w_Refresh, nil).ShowModal;
  DBAppGlobals.MAINPLAN_Ignore_Pain_When_refresh := false;

  if DBAppGlobals.ShowColorJobMode = DinamicPropList then
  begin
    if (GetIdFromCode(DBAppGlobals.LastPropColorInUseJobMode) <> nil) then
    begin
      NewItem := TMenuItem.Create(Self);
      NewItem.VCLComObject := GetIdFromCode(DBAppGlobals.LastPropColorInUseJobMode);
      ClickShowBarColorDynamic(NewItem);
    end
  end;
  m_ShapeUpdateNow.refresh;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.OnPopupPropertySlot(Sender: TObject);
begin
  if Assigned(m_SelectedListWrkCtrPopUp) and (m_SelectedListWrkCtrPopUp.Count = 1) then
  begin
    IFilterBinBySlotProp.Visible := true;
    if PTSelectedParam(m_SelectedListWrkCtrPopUp[0]).S_TypeSelected = slt_Wc_category then
      IFilterBinBySlotProp.Caption := _('Filter bin by work center category slot')
    else
      IFilterBinBySlotProp.Caption := _('Filter bin by property slot');
  end
  else
    IFilterBinBySlotProp.Visible := false;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIServerStatusClick(Sender: TObject);
var
  logForm: TFServerStatus;
begin
  logForm := TFServerStatus.CreateForm(self);
  logForm.ShowModal;
  logForm.Free;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIBucketReportClick(Sender: TObject);
begin
  ExcelBucketReport(self);
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MICapResDynamicClick(Sender: TObject);
var
  CapResDynamic : TCapResDynamic;
  qry:    TMqmQuery;
  pt :    TMqmPlanTabSheet;
begin
  CapResDynamic := TCapResDynamic.CreateCapResDynamic(self, TMqmRes(TMqmVisibleRes(m_popObj).p_father).p_ResCode);
  if CapResDynamic.ShowModal = mrOk then
  begin
    qry := CreateQuery(Main_DB);
    p_pl.LoadCapResDynamic(qry, TMqmRes(TMqmVisibleRes(m_popObj).p_father).p_ResCode, '', nil, nil, nil);
    pt := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
    if Assigned(pt) then
      pt.p_shapeMan.ShapesUpdate;
    qry.free
  end;
  CapResDynamic.Free;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiChangeBalanceClick(Sender: TObject);
var
  BalanceList : TList;
  BalanceHeadersForm : TMBalanceHeadersForm;
begin
  BalanceList := TList.Create;
  p_sc.GetAllBalanceList(BalanceList);
  BalanceHeadersForm := TMBalanceHeadersForm.CreateBalanceHeadersForm(self,BalanceList);
  BalanceHeadersForm.ShowModal;
  BalanceHeadersForm.free;
  BalanceList.Free;
  RefreshActiveTab;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MICngResSecClick(Sender: TObject);
var
  CustResList: TFConfigResList;
  ActiveTab: integer;
  ConfTab: TPlanTabCfg;
  Tab : TMqmPlanTabSheet;
begin
  Tab := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
  if not Assigned(Tab) then exit;
  Tab.p_ganttPanel.p_SortType := SRT_Customized;
  ActiveTab := m_pgcPlan.GetActiveView.GetCode;
  ConfTab := TPlanTabCfg(m_planTbCfg.FindTab(ActiveTab));
  CustResList := TFConfigResList.CreateCfgResList(self, ConfTab.res);
  if CustResList.ShowModal = mrOk then
  begin
    m_planTbCfg.UpdateTabNewSort(activeTab, ConfTab.name, CustResList.GetResList);
    Tab.p_ganttPanel.UpdateList(CustResList.GetResList);
    //PnlZoom.Visible := true;
    TMqmPlanTabSheet(m_pgcPlan.GetActiveView).p_HeaderMan.m_CalPanel.FResourceTrcBarZoom.Position := TMqmPlanTabSheet(m_pgcPlan.GetActiveView).p_zoom;
    TMqmPlanTabSheet(m_pgcPlan.GetActiveView).p_HeaderMan.m_CalPanel.FHorizontalTrcBarZoom.Position := TMqmPlanTabSheet(m_pgcPlan.GetActiveView).p_Hzoom;
    TrcBarZoomChange(self);
    PgcBinChange;
  end;
  CustResList.Free
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MICompacAllScheduledFromThisPointForAllResourceClick(Sender: TObject);
begin
  TFWait.CreateWaitForm(self, w_CompactJobsFromThisPointAllRes, nil).ShowModal;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MICompacAllScheduledFromThisPointOnThisResourceClick(Sender: TObject);
begin
  TFWait.CreateWaitForm(self, w_CompactJobsFromThisPoint, nil).ShowModal;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.CompatibleinbinWarp1Click(Sender: TObject);
begin
  TFConfigBin.CreateCfgBin(Self, Tb_WarpCompatible).ShowModal;
  SaveDefaultTabBinMatCompatibleSet;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIIgnoreprogressClick(Sender: TObject);
var
  pt: TMqmPlanTabSheet;
  Save_Cursor : TCursor;
  ProgressStatus : CProgressIgnor;
  ProgressIgnoredType : CProgressTypeIgnored;
  SchedList : TMSchedList;
begin
  ProgressStatus := p_sc.GetProgressOverrideStatus(TSchedId(m_popObj), ProgressIgnoredType);
  SchedList := TMSchedList.Create(self);
  SchedList.AddLink(TSchedId(m_popObj));
  if (ProgressStatus = Prg_Ignored) or (ProgressStatus = Prg_IgnoredAndSave) then
  begin
    if MessageDlg(_('Confirm re-apply ?'),
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      p_sc.OrganizeIgnoredProgressOperation(SchedList , true);
    end
    else
      exit
  end
  else if (ProgressStatus = Prg_NotIgnored) or (ProgressStatus = Prg_ReApplied) or (ProgressStatus = Prg_ReAppliedAndSave) then
  begin
    if MessageDlg(_('Confirm Ignore ?'),
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
       p_sc.OrganizeIgnoredProgressOperation(SchedList , false);
    end
    else
      Exit;
  end;

  Save_Cursor   := Screen.Cursor;
  Screen.Cursor  := crAppStart; //SQLWait;

  if not Assigned(m_pgcPlan) then exit;
  pt := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
  if not Assigned(pt) then exit;
  pt.p_shapeMan.Update;

  if Assigned(FBin) then
    FBin.ChangeTabBinforChangeTabPlan;
  Screen.Cursor := Save_Cursor;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.PupCapResPopup(Sender: TObject);
var
  I: integer;
  act : TMqmActArea;
begin
  for I := 0 to PupCapRes.Items.Count - 1 do
    PopRes.Items[I].Enabled := true;
  act := TMqmActArea(TMqmCapRes(m_popObj).p_father);
  if assigned(act) then
  begin
    MIDelCapRes.Enabled := true;
    if (TMqmWrkCtr((act).p_WrkCtr).p_ReadOnly) or (TMqmCapRes(m_popObj).p_CapResNum < 0) then
       MIDelCapRes.Enabled := false;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.CheckConnectionClick(Sender: TObject);
begin
  //if not reCheckServerConnection then
  //  if not ReconnectMsg then Exit;
end;

//----------------------------------------------------------------------------//

function TFMQMPlan.CheckMultiResInActiveTab: boolean;
var
  TempRes : TMqmRes;
  I       : Integer;
  ActTab: TMqmPlanTabSheet;
begin
  Result := false;
  ActTab := GetActiveTab;
  if not Assigned(ActTab) then exit;
  for I := 0 to ActTab.p_ganttPanel.p_VisResList.Count - 1 do
  begin
    TempRes := TMqmRes(TMqmVisibleRes(ActTab.p_ganttPanel.p_VisResList[I]).p_father);
    if Assigned(TempRes) and TempRes.p_isMultiRes then
    begin
      Result := true;
      Break
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiSchedulestatusClick(Sender: TObject);
var
  ts: TMqmPlanTabSheet;
begin
  DBAppGlobals.ShowColorJobMode := Standard;
  MiSchedulestatus.Checked := true;
  MiPropertyPreDefined.Checked := false;
  MiPropertyDynamic.Checked := false;
  ts := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
  if assigned(ts) then
  begin
    ts.p_shapeMan.ShapesUpdate;
    SetCheckedCurrentPropertyColoredPreDefined(true);
    SetCheckedCurrentPropertyColoredDynamic(true);
    ts.Refresh;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiScheduleStatusTabClick(Sender: TObject);
var
  NewItem : TMenuItem;
  TabCfg  : TPlanTabCfg;
  ts: TMqmPlanTabSheet;
begin
  DBAppGlobals.ShowColorJobModeActivTab := ScheduleStatus;
 { MiPropertyPreDefinedTab.Checked := false;
  MiPropertyDynamicTab.Checked := false;
  MiStandardSettings.Checked := false;  }

  SetCheckedCurrentPropertyColoredPreDefinedTab(true, nil);
  SetCheckedCurrentPropertyColoredDynamicTab(true, nil);
  TabCfg := TPlanTabCfg(m_planTbCfg.FindTab(m_pgcPlan.GetActiveView.GetCode));
  TabCfg.m_ShowColorJobMode := ScheduleStatus;
   ts := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
  if assigned(ts) then
  begin
    ts.p_shapeMan.ShapesUpdate;
    ts.Refresh;
  end;

  {if DBAppGlobals.ShowColorJobMode = PreDefinedPropList then
  begin
    if (GetIdFromCode(DBAppGlobals.LastPropColorInUseJobMode) <> nil) then
    begin
      NewItem := TMenuItem.Create(Self);
      NewItem.VCLComObject := GetIdFromCode(DBAppGlobals.LastPropColorInUseJobMode);
      ClickShowBarColorfromPropList(NewItem);
    end;
  end
  else if DBAppGlobals.ShowColorJobMode = DinamicPropList then
  begin
    if (GetIdFromCode(DBAppGlobals.LastPropColorInUseJobMode) <> nil) then
    begin
      NewItem := TMenuItem.Create(Self);
      NewItem.VCLComObject := GetIdFromCode(DBAppGlobals.LastPropColorInUseJobMode);
      ClickShowBarColorDynamic(NewItem);
    end
  end
 // else if True then

  else
  begin
    MiSchedulestatusClick(self);
  end;   }
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiSearchClick(Sender: TObject);
begin
  TFConfigBin.CreateCfgBin(Self, Tb_Search).ShowModal;
  SaveDefaultTabSearch;
end;

procedure TFMQMPlan.MiSeedGrpChangeClick(Sender: TObject);
begin

end;

//----------------------------------------------------------------------------//

{ TShapeBase }

procedure TShapeUpdate.Paint;
begin
  if not Visible then exit;
  inherited;
  FontResize2(Canvas.Font,0);
  if name = 'ShapeUpdateAvailable' then
  begin
    Canvas.Font.Name :='Montserrat';
    //Canvas.Font.Size  :=9;
    Canvas.Font.Color:= clblack;
    if s_FMQMPlan.RefreshTimer.Enabled then
      Canvas.TextOut(10,2,_('Update is available'))
    else
      Canvas.TextOut(50,2,_('Data update'))
  end;

  if name = 'ShapeUpdateNow' then
  begin
    Canvas.Font.Name :='Montserrat';
    //Canvas.Font.Size  :=9;
    Canvas.Font.Color:= CLWhite;
    Canvas.Brush.Color := Cl_STNDRD_LIGHT_BLUE;
    if s_FMQMPlan.m_RefreshDate then
      Canvas.TextOut(10,2,_('Update now !'))
    else
    begin
      Canvas.Font.Color := Cl_STNDRD_LIGHT_BLUE; // like the background clor , so the msg is not seen
      Canvas.TextOut(10,2,_('Update now !'))
    end;

    if s_FMQMPlan.m_OtherStationDataWaiting and not s_FMQMPlan.m_HostDataWaiting then
    begin
      Canvas.Brush.Color := 12550399;
      Canvas.Font.Color:= CLWhite;
      if s_FMQMPlan.m_RefreshDate then
        Canvas.TextOut(10,2,_('Update now !'))
      else
      begin
        Canvas.Font.Color := 12550399; // like the background clor , so the msg is not seen
        Canvas.TextOut(10,2,_('Update now !'))
      end;

    end;

  end;

end;

// -------------------------------------------------------------------------- //

procedure TFMQMPlan.MiGroupBucketClick(Sender: TObject);
begin
  GroupBucketReport(self);
end;

// -------------------------------------------------------------------------- //

procedure TFMQMPlan.GeneratePopupMenus;
var
  qry : TmqmQuery;
  tbInfo:       PTblInfo;
  mi : TMenuItem;
  i : integer;
begin
  GetResPopupList;
  GetActAreaPopupList;
  GetGroupPopupList;
  GetJobPopupList;
  if Assigned(Fbin) then
    Fbin.GetBinPopupList;

  Qry := CreateQuery(Cfg_DB);
  tbInfo := @tblInfo[tbl_CustomMenu];

  qry.SQL.Text := 'Select * from ' + tbInfo.GetTableName + ' where CM_IDENTIFIER = ' + IniAppGlobals.Identifier
    + ' and CM_WKST_CODE = ' + QuotedStr(IniAppGlobals.WkstCode)
    + ' order by CM_IDENTIFIER, CM_WKST_CODE';
  qry.Open;

  if qry.RecordCount = 0 then
    DefaultValuesForMenu;

  qry.close;
  qry.Open;

  while not qry.eof do
  begin

    if qry.FieldByName('CM_MenuCode').asString <> 'Bin' then
      mi := FindComponent(qry.FieldByName('CM_MenuCaption').asString) as TMenuItem
    else
      mi := FBin.FindComponent(qry.FieldByName('CM_MenuCaption').asString) as TMenuItem;

    if not Assigned(mi) then
    begin
      qry.Next;
      continue
    end;

    if qry.FieldByName('CM_Visible').asInteger = 0 then
      mi.Visible := False
    else
      mi.Visible := True;

    //resource
    if qry.FieldByName('CM_MenuCode').asString = 'Resource' then
      m_ResPopupList.AddObject(mi.Name, mi)
    else //act area
    if qry.FieldByName('CM_MenuCode').asString = 'ActArea' then
      m_ActAreaPopupList.AddObject(mi.Name, mi)
    else //group
    if qry.FieldByName('CM_MenuCode').asString = 'Group' then
      m_GroupPopupList.AddObject(mi.Name, mi)
    else  //job
    if qry.FieldByName('CM_MenuCode').asString = 'Job' then
      m_JobPopupList.AddObject(mi.Name, mi)
    else  //bin
      if Assigned(Fbin) and (qry.FieldByName('CM_MenuCode').asString = 'Bin') then
        FBin.GetBinPopupList.AddObject(mi.Name, mi);

    qry.Next;
  end;

  qry.close;

  ///Check if there is new item
  for i := 0 to PopRes.items.count-1 do
  begin
    mi := PopRes.items[i];
    if TMenuitem(mi).caption = '-' then continue;

    if m_ResPopupList.IndexOfObject(mi) = -1 then
    begin
      m_ResPopupList.AddObject(mi.Name, mi);
      qry.ExecSQL('Insert into ' + tbInfo.GetTableName + ' (CM_IDENTIFIER, CM_WKST_CODE, CM_MENUCODE, CM_MENUCAPTION,CM_VISIBLE)'
        + ' Values(' + IniAppGlobals.Identifier + ', ' + QuotedStr(IniAppGlobals.WkstCode) + ', ' +QuotedStr('Resource') + ', '+ QuotedStr(Mi.Name)+ ', '+ QuotedStr('0') +')');
    end;

    if mi.Visible = false then
      m_ResPopupList.Delete(m_ResPopupList.IndexOfObject(mi));
  end;

  for i := 0 to PupActArea.items.count-1 do
  begin
    mi := PupActArea.items[i];
    if TMenuitem(mi).caption = '-' then continue;

    if m_ActAreaPopupList.IndexOfObject(mi) = -1 then
    begin
      m_ActAreaPopupList.AddObject(mi.Name, mi);
      qry.ExecSQL('Insert into ' + tbInfo.GetTableName + ' (CM_IDENTIFIER, CM_WKST_CODE, CM_MENUCODE, CM_MENUCAPTION,CM_VISIBLE)'
        + ' Values(' + IniAppGlobals.Identifier + ', ' + QuotedStr(IniAppGlobals.WkstCode) + ', ' +QuotedStr('ActArea') + ', '+ QuotedStr(Mi.Name)+ ', '+ QuotedStr('0') +')');
    end;

    if mi.Visible = false then
      m_ActAreaPopupList.Delete(m_ActAreaPopupList.IndexOfObject(mi));
  end;

  for i := 0 to PupGroup.items.count-1 do
  begin
    mi := PupGroup.items[i];
    if TMenuitem(mi).caption = '-' then continue;

    if m_GroupPopupList.IndexOfObject(mi) = -1 then
    begin
      m_GroupPopupList.AddObject(mi.Name, mi);
      qry.ExecSQL('Insert into ' + tbInfo.GetTableName + ' (CM_IDENTIFIER, CM_WKST_CODE, CM_MENUCODE, CM_MENUCAPTION,CM_VISIBLE)'
        + ' Values(' + IniAppGlobals.Identifier + ', ' + QuotedStr(IniAppGlobals.WkstCode) + ', ' +QuotedStr('Group') + ', '+ QuotedStr(Mi.Name)+ ', '+ QuotedStr('0') +')');
    end;

    if mi.Visible = false then
      m_GroupPopupList.Delete(m_GroupPopupList.IndexOfObject(mi));
  end;

  for i := 0 to PupJob.items.count-1 do
  begin
    mi := PupJob.items[i];
    if TMenuitem(mi).caption = '-' then continue;

    if m_JobPopupList.IndexOfObject(mi) = -1 then
    begin
      m_JobPopupList.AddObject(mi.Name, mi);
      qry.ExecSQL('Insert into ' + tbInfo.GetTableName + ' (CM_IDENTIFIER, CM_WKST_CODE, CM_MENUCODE, CM_MENUCAPTION,CM_VISIBLE)'
        + ' Values(' + IniAppGlobals.Identifier + ', ' + QuotedStr(IniAppGlobals.WkstCode) + ', ' +QuotedStr('Job') + ', '+ QuotedStr(Mi.Name)+ ', '+ QuotedStr('0') +')');
    end;

    if mi.Visible = false then
      m_JobPopupList.Delete(m_JobPopupList.IndexOfObject(mi));
  end;

  if Assigned(Fbin) then
    for i := 0 to FBin.PopUpBin.items.count-1 do
    begin
      mi := FBin.PopUpBin.items[i];
      if TMenuitem(mi).caption = '-' then continue;

      if FBin.GetBinPopupList.IndexOfObject(mi) = -1 then
      begin
        FBin.GetBinPopupList.AddObject(mi.Name, mi);
        qry.ExecSQL('Insert into ' + tbInfo.GetTableName + ' (CM_IDENTIFIER, CM_WKST_CODE, CM_MENUCODE, CM_MENUCAPTION,CM_VISIBLE)'
          + ' Values(' + IniAppGlobals.Identifier + ', ' + QuotedStr(IniAppGlobals.WkstCode) + ', ' +QuotedStr('Bin') + ', '+ QuotedStr(Mi.Name)+ ', '+ QuotedStr('0') +')');
      end;

      if mi.Visible = false then
        FBin.GetBinPopupList.Delete(FBin.GetBinPopupList.IndexOfObject(mi));
    end;

  qry.Close;
  qry.Free;

end;

initialization

  s_FMQMPlan := nil;

//----------------------------------------------------------------------------//

end.



