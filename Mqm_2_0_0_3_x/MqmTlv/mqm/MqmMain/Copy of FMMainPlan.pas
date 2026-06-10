unit FMMainPlan;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ComCtrls, ToolWin, ImgList,
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
  ExtCtrls, StdCtrls, IBEvents,
  UMCommon,
  UMDbFunc,
  UMBinReport,
  gnugettext,
  mxNativeExcel,
  UMOpStack, Buttons;//, ExceptionLog;

const
  CcfgDbCode  = 1;
  CmainDbCode = 1;
  CprogRele   = '1.0.1';

type

  TFMQMPlan = class(TForm)
    MainMenu: TMainMenu;
    MIFile: TMenuItem;
    MISave: TMenuItem;
    MIReload: TMenuItem;
    MIExit: TMenuItem;
    MICreat: TMenuItem;
    MIShow: TMenuItem;
    MIShowCalShapes: TMenuItem;
    MISetting: TMenuItem;
    MIColorLegend: TMenuItem;
    MIVerify: TMenuItem;
    TBMain: TToolBar;
    TBSave: TToolButton;
    ToolButton4: TToolButton;
    TBLogWindow: TToolButton;
    TBSpcCrtCap: TToolButton;
    TBCrtCap: TToolButton;
    ToolButton11: TToolButton;
    VSplit: TSplitter;
    HSplit: TSplitter;
    PanRgDock: TPanel;
    PanBotDock: TPanel;
    PUpPlan: TPopupMenu;
    PupCapRes: TPopupMenu;
    PupJob: TPopupMenu;
    IDispoDetails: TMenuItem;
    ICapResDetails: TMenuItem;
    ICloseTbs: TMenuItem;
    PopRes: TPopupMenu;
    MIResDetails: TMenuItem;
    ImageListBig: TImageList;
    TBResources: TToolButton;
    IWkcDet: TMenuItem;
    MIPlanPropRepo: TMenuItem;
    ImageList1: TImageList;
    MIConfig: TMenuItem;
    IMoveToBin: TMenuItem;
    IStepDetails: TMenuItem;
    StBarInfo: TStatusBar;
    MICrtCapRes: TMenuItem;
    PupGroup: TPopupMenu;
    MIGrpDetails: TMenuItem;
    MIgrpToBin: TMenuItem;
    ICompatInBin: TMenuItem;
    IClearCompInBin: TMenuItem;
    MIDelCapRes: TMenuItem;
    TBSpcLowWndw: TToolButton;
    MIJobHandle: TMenuItem;
    N1: TMenuItem;
    TBtnDynamic: TToolButton;
    ToolButton3: TToolButton;
    MIResourceReport: TMenuItem;
    MIAutoSchedCfg: TMenuItem;
    MILangauge: TMenuItem;
    MIEnglish: TMenuItem;
    MIItalian: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    IMSearchProdReqby: TMenuItem;
    MIProductionReq: TMenuItem;
    MIProdType: TMenuItem;
    MIDltProdReqVal: TMenuItem;
    MIStepType: TMenuItem;
    MIWorkCenter: TMenuItem;
    MIProccess: TMenuItem;
    MIProdFamiy: TMenuItem;
    MIMaterialFamily: TMenuItem;
    MIProdLine: TMenuItem;
    MIChinese: TMenuItem;
    TBShoBin: TToolButton;
    TBShowCal: TToolButton;
    TBSetColors: TToolButton;
    ToolButton1: TToolButton;
    TBConfig: TToolButton;
    N4: TMenuItem;
    N5: TMenuItem;
    MIEditCal: TMenuItem;
    MIAutoSeqResult: TMenuItem;
    PupActArea: TPopupMenu;
    MIApaCrtCapRes: TMenuItem;
    MIApaCrtDownTime: TMenuItem;
    MIApaDelPlan: TMenuItem;
    Sortresourcesby1: TMenuItem;
    MISortResourceCode: TMenuItem;
    Categoryresourcecode1: TMenuItem;
    WCresourcecode1: TMenuItem;
    Wccategoryresource1: TMenuItem;
    N6: TMenuItem;
    Findjobinbin1: TMenuItem;
    MiTurkish: TMenuItem;
    MiSetBinConficuration: TMenuItem;
    StMouseDate: TStaticText;
    PnlZoom: TPanel;
    StSizePercent: TStaticText;
    TrcBarZoom: TTrackBar;
    ToolButton6: TToolButton;
    ToolButton10: TToolButton;
    IMoveAllJobsToBin2: TMenuItem;
    Unschedulejobsincurrentbin1: TMenuItem;
    MISpanish: TMenuItem;
    MIResourceReport1: TMenuItem;
    MIBinReport2: TMenuItem;
    SaveDialog1: TSaveDialog;
    MISimplified: TMenuItem;
    MITraditional: TMenuItem;
    MIBinHtmlReport: TMenuItem;
    MIBinExcelReport: TMenuItem;
    ExcelFontBold: TLabel;
    ToolButton5: TToolButton;
    MIBarconfig: TMenuItem;
    RefreshTimer: TTimer;
    N8: TMenuItem;
    MISaveAsSim: TMenuItem;
    N9: TMenuItem;
    MISaveAsMPlan: TMenuItem;
    MIOpenPlan: TMenuItem;
    MIOpenMainPlan: TMenuItem;
    MIOpenOldSim: TMenuItem;
    MIDeleteSim: TMenuItem;
    MIDelCurrSim: TMenuItem;
    MIDelSimSel: TMenuItem;
    MIDelAllSim: TMenuItem;
    PnlSimulation: TPanel;
    TbRefreshBtn: TToolButton;
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
    ToolButton7: TToolButton;
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
    MISaveAs: TMenuItem;
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
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    BitBtn1: TBitBtn;

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
    procedure IDispoDetailsClick(Sender: TObject);
    procedure ICapResDetailsClick(Sender: TObject);
    procedure ICloseTbsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PgcMainChange(Sender: TObject);
    procedure PUpPlanPopup(Sender: TObject);
    procedure TBLogWindowClick(Sender: TObject);
    procedure MIResDetailsClick(Sender: TObject);
    procedure IWkcDetClick(Sender: TObject);
    procedure MIPlanPropRepoClick(Sender: TObject);
    procedure IMoveToBinClick(Sender: TObject);
    procedure MISaveClick(Sender: TObject);
    procedure MIReloadClick(Sender: TObject);
    procedure IStepDetailsClick(Sender: TObject);
    procedure MIExitClick(Sender: TObject);
    procedure TBResourcesClick(Sender: TObject);
    procedure MICrtCapResClick(Sender: TObject);
    procedure MIApaCrtCapResClick(Sender: TObject);
    procedure MIApaCrtDownTimeClick(Sender: TObject);
    procedure PupActAreaPopup(Sender: TObject);
    procedure MIShowCalShapesClick(Sender: TObject);
    procedure TrcBarZoomChange(Sender: TObject);
    procedure MIGrpDetailsClick(Sender: TObject);
    procedure MIConfigClick(Sender: TObject);
    procedure ICompatInBinClick(Sender: TObject);
    procedure IClearCompInBinClick(Sender: TObject);
    procedure MIShowBinClick(Sender: TObject);
    procedure MIDelCapResClick(Sender: TObject);
    procedure MIJobHandleClick(Sender: TObject);
    procedure TBtnDynamicClick(Sender: TObject);
    procedure MIResSchedHtmlReportclick(Sender: TObject);
    procedure MIAutoSchedCfgClick(Sender: TObject);
    procedure MIBinPrqFilterClick(Sender: TObject);
    procedure MIEnglishClick(Sender: TObject);
    procedure MIItalianClick(Sender: TObject);
    procedure MIColorLegendClick(Sender: TObject);
    procedure MIProductionReqClick(Sender: TObject);
    procedure MIProdTypeClick(Sender: TObject);
    procedure MIDltProdReqValClick(Sender: TObject);
    procedure MIStepTypeClick(Sender: TObject);
    procedure MIWorkCenterClick(Sender: TObject);
    procedure MIProccessClick(Sender: TObject);
    procedure MIProdFamiyClick(Sender: TObject);
    procedure MIMaterialFamilyClick(Sender: TObject);
    procedure MIProdLineClick(Sender: TObject);
    procedure MIChineseClick(Sender: TObject);
    procedure MIEditCalClick(Sender: TObject);
    procedure MIAutoSeqResultClick(Sender: TObject);
    procedure MISortResourceCodeClick(Sender: TObject);
    procedure Categoryresourcecode1Click(Sender: TObject);
    procedure WCresourcecode1Click(Sender: TObject);
    procedure Wccategoryresource1Click(Sender: TObject);
    procedure Findjobinbin1Click(Sender: TObject);
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
    procedure MISaveAsSimClick(Sender: TObject);
    procedure MISaveAsMPlanClick(Sender: TObject);
    procedure TbRefreshBtnClick(Sender: TObject);
    procedure MIOpenMainPlanClick(Sender: TObject);
    procedure MIOpenOldSimClick(Sender: TObject);
    procedure MIOpenNewSimClick(Sender: TObject);
    procedure MIDelCurrSimClick(Sender: TObject);
    procedure MIDelSimSelClick(Sender: TObject);
    procedure MIDelAllSimClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MIJobBarConfigClick(Sender: TObject);
    procedure MIStatusbarConfigClick(Sender: TObject);
    procedure MIScheduleReportClick(Sender: TObject);
    procedure MISetFinalClick(Sender: TObject);
    procedure MISetToTempClick(Sender: TObject);
    procedure MILabelClick(Sender: TObject);
    procedure MIRollClick(Sender: TObject);
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
    procedure ToolButton10Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);

  private
    m_planTbCfg: TPlanTabsCfg;
    m_pgcPlan:   TMViewPage;

    procedure CreateNewPlan(tbCfg: TPlanTabsCfg; tabCode: integer);
    procedure ResetTabs(tbCfg: TPlanTabsCfg);
    procedure AddTabWithList(name: string; resList: TList; PlanTyp : TPlanType);
    function  IsDynamicActiveted(var Code : integer) : boolean;
    procedure UpdateStatusPanel;
    procedure PgcBinChange;
    procedure UpdateCaptions;
    procedure OpenDynamicPlanforSearch;

  protected
    procedure UpdateRequested(var msg: TMessage); message MSG_UPDATE;
    procedure PowerMessageReceived(var msg: TMessage); message WM_POWERBROADCAST;

  public
///    m_shapeMan: TShapeManager;
    m_popObj:   TMqmPlanObj;
    m_popDate:  TDateTime;
    MainProgBar: TMqmProgBar;

    function  CheckChangedDataForWc : boolean;
    function  MoveAllowed(Obj: TMqmDurObj): boolean;
    procedure RefreshActiveTab;
    procedure EnterCompatModeInPlan(id: TSchedId);
    procedure FocusAllTbsOnDate(date: TDateTime);
    procedure FocusAllTbsOnID(Id: TSchedId);
    procedure FocusOnPlan(Id: TSchedId);
    procedure FocusOnDate(VisRes : TMqmVisibleRes ; JobId : TSchedId);
    procedure ExitCompatModeInPlan;
    procedure SBarSetSchedObj(Param: PTRowParms);
    procedure SBarSetPlanObj(obj: TMqmPlanObj);
    procedure SetMouseDateDesc(posXMou: integer);
    procedure CleanSBar;
    procedure SetDynamicPlanActiv(ResList : TList);
    function  IsDynamicPlanActiv : boolean;
    function  IsDynamicPlanOpened : boolean;
    procedure ResetDynamicTab;
    function  GetListForActPlanTab(List : TList) : Boolean;
    function  TbsByName(TbsName : string) : TTabSheet;
    procedure ShowDockPanel(APanel: TPanel; MakeVisible: Boolean; Client: TControl);
    function  GetPlanCfg: TPlanTabsCfg;
    function  GetActiveTab: TMqmPlanTabSheet;
    function SaveToDB(ForSim: boolean ): boolean;
    procedure MiniMizedMainForm;
    procedure MaxiMizedMainForm;
    procedure ActiveUndo;

  end;

  procedure OpenPlanView(AOwner: TComponent);
  function  GetPlanView: TFMQMPlan;
  function LoadPlanFromDB(ProgBar: TMqmProgBar; Status: TStaticText): boolean;
  function  IsCompatibleWithDb(mainCode, cfgCode: integer; var errStr: string): boolean;
  function  IsDynamicPlanActiv : boolean;
  function  IsDynamicBinPlanActiv : boolean;
  procedure SetDynamicPlanActiv(ResList : TList);
  procedure OpenDynamicPlanforSearch;
  procedure ResetDynamicTab;
  procedure MoveAllJobsToBin;
  function  GetLastProdSched : Integer;
  function  RefreshData : boolean;

  function ReloadPlanFromDB(DB: TMqmDBType; SuffixTblName: string): boolean;

var
  FMQMPlan: TFMQMPlan;

implementation

{$R *.DFM}

uses
  FMWait,
//  FGInfo,
  UMSchedCont,
  umgLOBAL,
  UMTblDesc,
  Math,
  UMplan,
  UGGlobal,
  UMStatus,
  UMCompat,
  UMPlanGraph,
  UMwkCtr,
  UMCapRes,
  FMBin,
  UMObjCont,
  UMActArea,
//  UMOpStack,
  FMColors,
  UMBinDefault,
  FMDispoDet,
  FMStepDetails,
  FMCreateCapRes,
  FMCrtDownTime,
  FMresFilter,
  FMGroupDetail,
  FMResDetails,
  FMEditCal,
  FMWkcDetails,
  FGInfo,
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
  FMResourceReport,
  UGPropComp,
  FMcfgBin,
  UMCalDbInterface,
  UMStoredProc,
  FMAutoSched,
  UmCmp,
  UMBinGrid,
  UMBinPanel,
  UMBinToExcel,
  FMSimulations,
  UMSimulations,
  FMMsgDlgSim,
  UMArticles,
{$ifdef ARO}
  UMReport,
  FMQReportLab,
  FMQReportRoll,
  FMQReportProd,
{$endif}
  FMBarConfig,
  FMBarConfigSets,
  UMIssuedArt,
  FMShowMaterials,
  UMAutoSchedCfg,
  FMAbout,
  FMRequirements;

var
  s_FMQMPlan: TFMQMPlan;

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

procedure SetDynamicPlanActiv(ResList : TList);
var
  MQMPlan : TFMQMPlan;
begin
  MQMPlan := GetPlanView;
  MQMPlan.SetDynamicPlanActiv(ResList);
end;

//----------------------------------------------------------------------------//

procedure OpenDynamicPlanforSearch;
var
  MQMPlan : TFMQMPlan;
begin
  MQMPlan := GetPlanView;
  MQMPlan.OpenDynamicPlanforSearch;
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
  trs:    TMqmTransaction;
  smd:    TDateTime;
  updNum: integer;
  ErrList: TStringList;
  i: integer;
begin
  Result := false;
  DBAppGlobals.MAINPLAN_Ignore_Save_Event := true;
  if Assigned(ProgBar) then
  begin
    ProgBar.SetMax(TRY_NUMBER);
    ProgBar.SetPosition(0);
  end;

  if Assigned(Status) then
    Status.Caption := _('Waiting to access the database...');
  i := 0;

  while i <= TRY_NUMBER do
  begin
   // if SP_GET_ACCESS(IniAppGlobals.WkstCode, AT_Lock) then
    if GET_ACCESS(IniAppGlobals.WkstCode, AT_Lock) then
    begin
      updNum := GetLastProdSched;
    //  SP_CHANGE_ACCESS(IniAppGlobals.WkstCode);
      CHANGE_ACCESS(IniAppGlobals.WkstCode);
      trs := CreateTransaction(Main_DB, true);
      qry := CreateQuery(trs, Main_DB);
      ErrList := TStringList.Create;

      Application.ProcessMessages;

      p_ArtTypeList.LoadFromDb(qry, ProgBar, Status);
      Application.ProcessMessages;
      p_sc.LoadFromDb(qry, updNum, ProgBar, Status, ErrList);
      Application.ProcessMessages;
            //    p_Priorities.LoadFromDb(qry, ProgBar, Status);
      p_WrkctrDesc.LoadFromDb(qry, ProgBar, Status);
      Application.ProcessMessages;
      p_ArtType.LoadFromDb(qry, ProgBar, Status);
      Application.ProcessMessages;
      LoadUMDesc;
      Application.ProcessMessages;

      qry.Close;       //Vinc
      trs.Commit;      //Vinc

      qry.Free;
      trs.Free;

      smd := p_sc.GetSmallestDate;
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
      DBAppGlobals.EndDateForPlan := Max(DBAppGlobals.StDateForPlan+500, Now+500);

      p_pl.Load(ProgBar, Status, ErrList);
      Application.ProcessMessages;
      p_sc.LinkRequests(ProgBar, Status);
      Application.ProcessMessages;

     // SP_END_ACCESS(IniAppGlobals.WkstCode,false);
      END_ACCESS(IniAppGlobals.WkstCode);

      p_sc.LinkJobs(p_pl.PlanLinkJob, nil, ProgBar, Status);
      Application.ProcessMessages;
      p_sc.LinkWrkCtr(p_pl.FindWrkCtrByCode, ProgBar, Status);
      Application.ProcessMessages;

      p_sc.UpdateBalanceForAllJobs(ProgBar,nil);
      p_sc.P_ReorganizeAllEnd := false;
      if not p_pl.ReorganizeAll(ProgBar, Status) then
        ErrList.add(_('It is not possible to reorganize the plan'));
      p_sc.P_ReorganizeAllEnd := true;
      Application.ProcessMessages;

  //    p_sc.UpdateBalanceForAllJobs(ProgBar, Status);
  //    Application.ProcessMessages;

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
          ProgBar.SelEnd := i;
        Application.ProcessMessages;
        if SP_ASK_POLL then
        begin
          Sleep(2500);
          inc(i);
          if Assigned(ProgBar) then
            ProgBar.SelEnd := i;
          Application.ProcessMessages;
          Sleep(2500);
          SP_CHECK_POLL;
        end else
          Sleep(2500);
      end
    end;
  end;

end;

//----------------------------------------------------------------------------//

function ReloadPlanFromDB(DB: TMqmDBType; SuffixTblName: string): boolean;
const
  TRY_NUMBER = 14;
var
  qry:    TMqmQuery;
  trs:    TMqmTransaction;
  updNum : integer;
  tbiPS:   ^TTblInfo;
  i, j : integer;
  ts: TMqmPlanTabSheet;
  sh: TShapeManager;
begin
  Result := false;

  if Assigned(FMQMPlan.MainProgBar) then
  begin
    FMQMPlan.MainProgBar.SetMax(TRY_NUMBER);
    FMQMPlan.MainProgBar.SetPosition(0);
  end;

  j := 0;

  while j <= TRY_NUMBER do
  begin
    if SP_GET_ACCESS(IniAppGlobals.WkstCode, AT_read) then
    begin
      p_opStack.Clear;
      FMQMPlan.ActiveUndo;

      ClearPGCALPool(false);
      p_pl.ClearCalendar;

      p_sc.RemoveAllObjsFromPlan;
      p_pl.RemoveAllCapRes(FMQMPlan.MainProgBar, nil);

      for i := 1 to FMQMPlan.m_pgcPlan.PageCount -1 do
      begin
        ts := TMqmPlanTabSheet(FMQMPlan.m_pgcPlan.Pages[i]);
        sh := ts.p_shapeMan;
        sh.ClearCaches;
      end;

      updNum := -1;
      trs := CreateTransaction(DB, true);
      qry := CreateQuery(trs, DB);

      case DB of
        Main_DB: p_sc.UpdateFromDB(qry, updNum, p_pl.UpdatePlanLinkJob, nil, FMQMPlan.MainProgBar);
        Temp_DB:
          begin
            tbiPS := @tblInfo[tbl_prod_sched];
            qry.SQL.Add(' SELECT * FROM ' + SuffixTblName + tbiPS.PCname);
            p_sc.ProcessQryForUpdate(qry, p_pl.UpdatePlanLinkJob, nil, FMQMPlan.MainProgBar);
          end;
      end;

      p_pl.LoadCapRes(qry, SuffixTblName, FMQMPlan.MainProgBar, nil, nil);
      p_pl.LoadCapResProperties(qry, SuffixTblName, FMQMPlan.MainProgBar, nil, nil);

      qry.Close;   //Vinc

      if trs.Active then trs.Commit;

      trs.Free;
      qry.Free;

      SP_END_ACCESS(IniAppGlobals.WkstCode,false);

      for i := 1 to FMQMPlan.m_pgcPlan.PageCount -1 do
      begin
        ts := TMqmPlanTabSheet(FMQMPlan.m_pgcPlan.Pages[i]);
        sh := ts.p_shapeMan;
        sh.NewRowsAdded(true)
      end;
      p_sc.P_ReorganizeAllEnd := false;
      p_pl.ReorganizeAll(FMQMPlan.MainProgBar, nil);
      p_sc.P_ReorganizeAllEnd := true;
      FMQMPlan.RefreshActiveTab;
      FMQMPlan.UpdateStatusPanel;

      if Assigned(FBin) then
      begin
        FBin.RefreshGrid;
        FBin.UpdateForChangeFilter;
      end;

      Result := true;
      break
    end else
    begin
      inc(j);
      if (j > TRY_NUMBER) then
      begin
        if MessageDlg(_('Can not currently reload. The host or a planner are writing to the database. Try again?'), mtConfirmation, [mbYes, mbNo], 0) = idYes then
          j := 0;
      end else
      begin
        if Assigned(FMQMPlan.MainProgBar) then
          FMQMPlan.MainProgBar.SelEnd := j;
        Application.ProcessMessages;
        if SP_ASK_POLL then
        begin
          Sleep(2500);
          inc(j);
          if Assigned(FMQMPlan.MainProgBar) then
            FMQMPlan.MainProgBar.SelEnd := j;
          Application.ProcessMessages;
          Sleep(2500);
          SP_CHECK_POLL;
        end else
          Sleep(2500);
      end
    end;
  end;
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
  s_FMQMPlan.ImageListBig.GetBitmap(0, Image.Picture.Bitmap)
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.CreateNewPlan(tbCfg: TPlanTabsCfg; tabCode: integer);
var
  shCfg:  TShConfig;
  hdrCfg: TMqmHdrCfg;
  gc:     TMqmGanttConst;
begin

  // used and then released
  hdrCfg := TMqmHdrCfg.Create;
  hdrCfg.m_class     := TMqmHdrMan;
  hdrCfg.m_rh        := HEADPANEL_HEIGHT;
  hdrCfg.m_rw        := 97;
  hdrCfg.m_LogoImage := LogoImage;
  hdrCfg.m_CalScroll := CalendarOnScroll;

  // used and then released
  shCfg := TShConfig.Create;
  shCfg.m_calcPos    := CalcPos;
  shCfg.m_calcDate   := CalcDate;
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

  // acquired by the user
  gc := TMqmGanttConst.Create;
  gc.bkColor    := RGB(150,150,150);
  if DBAppSettings.DisableCapRes then
    gc.RH := ROW_HEIGHT_DIS_CAPRES
  else
    gc.RH := ROW_HEIGHT_NORM;
  gc.RW         := 97;
  gc.VO_RS      := Trunc(gc.RH*0.04*2);
  gc.OO_RS      := Trunc(gc.RH*0.04*2);

  TMqmPlanTabSheet.CreatePlanTbs(m_pgcPlan, hdrCfg, gc,
                                 shCfg, tbCfg, tabCode);

  shCfg.Free;
  hdrCfg.Free;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.UpdateRequested(var msg: TMessage);
const
  TRY_NUMBER = 14;
var
//  I:      Integer;
  qry:    TMqmQuery;
  trs:    TMqmTransaction;
  updNum : integer;
  tbInfo: ^TTblInfo;
begin
  if msg.WParam = 3 then
    if CheckChangedDataForWc then
    begin
      TbRefreshBtn.Enabled := true;
      RefreshTimer.Enabled := true; // Handle changes in Database for the Clients
   //   MISave.Enabled := false;
    end;

  //To avoid deadlock if two istances of the same workstations are opened together
//  sleep(RandomRange(1,700));

  if msg.WParam = 2 then
  begin
  //  I := 0;

  //  while (I <= TRY_NUMBER) do
  //  begin
    try
      // polling
      trs := CreateTransaction(Cfg_DB, false);
      qry := CreateQuery(trs, Cfg_DB);
      tbInfo := @tblInfo[tbl_cfg_exchg_wkst];
     // SetFldPfx(tbInfo.pfx);

      qry.SQL.Add('select * from ' + tbInfo.PCname);
      qry.SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + ' = ''' + IniAppGlobals.WkstCode + '''');
      qry.open;

      if qry.RecordCount > 0 then
      begin
        qry.Close;
        qry.SQL.Clear;

        qry.SQL.Add('update ' + tbInfo.PCname);
        qry.SQL.Add('set '    + CreateFld(tbInfo.pfx, fli_POLL)     + ' = ''1''');
        qry.SQL.Add('where '  + CreateFld(tbInfo.pfx, fli_wkstCode) + ' = ''' + IniAppGlobals.WkstCode + '''');
        qry.SQL.Add(' and '  +  CreateFld(tbInfo.pfx, fli_POLL)     + ' = ''0''');
        qry.ExecSQL;

      end else
      begin
        qry.Close;
        qry.SQL.Clear;
        qry.SQL.Add('insert into ' + tbInfo.PCname + ' (');
        qry.SQL.Add(CreateFld(tbInfo.pfx, fli_wkstCode) + ', ');
        qry.SQL.Add(CreateFld(tbInfo.pfx, fli_CONNECT) + ', ');
        qry.SQL.Add(CreateFld(tbInfo.pfx, fli_LAST_UPD) + ', ');
        qry.SQL.Add(CreateFld(tbInfo.pfx, fli_OP) + ', ');
        qry.SQL.Add(CreateFld(tbInfo.pfx, fli_POLL));
        qry.SQL.Add(') values (');
        qry.SQL.Add('''' + IniAppGlobals.WkstCode + ''', ');
        qry.SQL.Add('CURRENT_TIMESTAMP, ');
        qry.SQL.Add('0, ');
        qry.SQL.Add(''' '', ');
        qry.SQL.Add('''1''');
        qry.SQL.Add(')');
        qry.ExecSQL;
      end;

      qry.Close;       //Vinc

      trs.Commit;
      trs.Free;
      qry.Free;

    except
      {  if assigned(trs) then
        begin
          trs.Rollback;
          trs.Free;
        end;
        if assigned(qry) then
          qry.Free;
        inc(I);
        sleep(10); }
     // end;

    end;
  end;

  if msg.WParam = 0 then
  begin
    if DBAppGlobals.MAINPLAN_Ignore_Save_Event then exit;
    // update
    if GetPlanView <> nil then
    begin
      try
     // if SP_GET_ACCESS(IniAppGlobals.WkstCode, AT_Lock) then
      if GET_ACCESS(IniAppGlobals.WkstCode, AT_Lock) then
      begin
        DBAppGlobals.MAINPLAN_Ignore_Save_Event := true;
        StartUpdating;
        UpdateStatusPanel;

      {    // read the current update level     // old logic
          trs := CreateTransaction(Cfg_DB, true);
          qry := CreateQuery(trs, Cfg_DB);
          qry.SQL.Add('select CEG_LAST_UPD from ' + tblInfo[tbl_cfg_exchg_glob].PCname);
          qry.Open;
          updNum := qry.FieldByName('CEG_LAST_UPD').AsInteger;
          qry.Close;  //Vinc
          trs.Commit;
          trs.Free;
          qry.Free;   }

        trs := CreateTransaction(Main_DB, true);
        qry := CreateQuery(trs, Main_DB);

        updNum := GetLastProdSched;
       // SP_CHANGE_ACCESS(IniAppGlobals.WkstCode);
      //  CHANGE_ACCESS(IniAppGlobals.WkstCode);   avieran/march 21 2007

        p_sc.UpdateFromDB(qry, updNum, p_pl.UpdatePlanLinkJob, nil, FMQMPlan.MainProgBar);
        qry.Close;   //Vinc
        trs.Commit;
        trs.Free;
        qry.Free;

        RefreshCalFromDb(FMQMPlan.MainProgBar); //Refresh of the calendars
        RefreshActiveTab;

        if Assigned(FBin) then
          FBin.UpdateForChangeFilter;
        UpdateStatusPanel;
        EndUpdating;
       // SP_END_ACCESS(IniAppGlobals.WkstCode, false);
        END_ACCESS(IniAppGlobals.WkstCode);
        DBAppGlobals.MAINPLAN_Ignore_Save_Event := false;
      end;
      except
      end;
    end;
  end;

  // good also for new status
  UpdateStatus;
  UpdateStatusPanel
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.PowerMessageReceived(var msg: TMessage);
begin
{
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

procedure TFMQMPlan.UpdateStatusPanel;
var
  srvLoadOn,
  canRead,
  canWrite,
  isUpdating: boolean;
begin
  GetStatus(srvLoadOn, canRead, canWrite, isUpdating);
  if srvLoadOn then
    ShServerLoad.Brush.Color := clLime
  else
    ShServerLoad.Brush.Color := clActiveBorder;

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
    if (m_pgcPlan.PageCount > 1) then
    begin
      if IsDynamicPlanActiv and (fbin.GetPageCount > 0) then
      begin
        Bintab := TBinTabSheet(Fbin.GetActiveView);
        if Bintab.m_BinPanel.P_BinDynamicPlan then
        begin
          ResList := TList.Create;
          Bintab.m_BinPanel.m_objList.BuildResList(ResList);
          SetDynamicPlanActiv(ResList);
          ResList.free;
        end
        else
        begin
          ResetDynamicTab;
        end;
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.OpenDynamicPlanforSearch;
var
  Bintab : TBinTabSheet;
  ResList : TList;
  Code : Integer;
begin
  if not IsDynamicPlanOpened then
    AddTabWithList('Dynamic', nil, PDynamic);
  if IsDynamicActiveted(Code) and (m_pgcPlan.PageCount > 1) then
    m_pgcPlan.SetActiveView(Code)
  else exit;

  if Assigned(Fbin) then
  begin
    if Fbin.GetPageCount > 0 then
    begin
      Bintab := TBinTabSheet(Fbin.GetActiveView);
      if Assigned(BinTab) and Bintab.m_BinPanel.P_BinDynamicPlan then
      begin
        ResList := TList.Create;
        Bintab.m_BinPanel.m_objList.BuildResList(ResList);
        if IsDynamicPlanActiv then
          SetDynamicPlanActiv(ResList);
      end;
    end;
  end;

end;

//----------------------------------------------------------------------------//

function GetLastProdSched : Integer;
var
  qry:    TMqmQuery;
  trs:    TMqmTransaction;
  tbInfo: ^TTblInfo;
begin
//  Result := -1;
  trs := CreateTransaction(Main_DB, false);
  qry := CreateQuery(trs, Main_DB);
  tbInfo := @tblInfo[tbl_Prod_sched];
  SetFldPfx(tbInfo.pfx);

  trs.StartTransaction;
  qry.SQL.Clear;
  qry.SQL.Add('select * from ' + tbInfo.PCname );
  qry.SQL.Add(' order by ' + CreatePfxFld(fli_updCode) + ' descending');
  qry.Open;

  if not qry.EOF then
    Result := qry.FieldByName(CreatePfxFld(fli_updCode)).AsInteger
  else
    Result := -1;

  qry.Close;
  trs.free;
  qry.Free;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.UpdateCaptions;
var
  i: integer;
  ts: TMqmPlanTabSheet;
  lic: TRecLicVers1;
  strErr:     string;
begin

//  Caption := Caption + ' - ' + IniAppGlobals.WkstCode;
  Caption := 'MQM  -  ' + IniAppGlobals.WkstDesc;

  if not DecodeLicVers1(lic, s_licBytes, strErr) then exit;
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
    CreateNewPlan(tbCfg, tbCfg.GetTab(i).code);
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.FormCreate(Sender: TObject);
var
  Save_Cursor : TCursor;
  tbs:   TTabSheet;
  img:   TImage;
  lic:        TRecLicVers1;
  strErr:     string;
begin
  TranslateComponent (self);
  //DefaultInstance.DebugLogToFile('c:\translation-debug.txt',false);

  s_FMQMPlan := self;

  if s_suicide then
  begin
    Close;
    exit
  end;

//  Caption := IniAppGlobals.WkstCode;
  Caption := 'MQM  -  ' + IniAppGlobals.WkstDesc;

  if not DecodeLicVers1(lic, s_licBytes, strErr) then exit;
  case lic.instType of
    INST_CUST_DEMO: Caption := Caption + _(' ** DEMO VERSION, NOT ALLOWED TO SAVE JOBS **');
         INST_DEMO: Caption := Caption + _(' ** DEMO VERSION, ALLOWED TO SAVE JUST ALREADY SCHEDULED JOBS **');
  end;

{$ifdef Customer}
  MICreat.Visible      := false;
  MIVerify.Visible     := false;
  TBLogWindow.Visible  := false;
  TBSpcLowWndw.Visible := false;
  MICrtCapRes.Enabled  := false;
  TBCrtCap.Visible     := false;
  TBSpcCrtCap.Visible  := false;
  MIReload.Visible     := false;
  MISaveAs.Visible     := false;
  MISaveAsSim.Visible   := false;
  MISaveAsMPlan.Visible := false;
  MIDeleteSim.Visible   := false;
  MIOpenPlan.Visible   := false;
//  MIShowbintoolbar.Visible := false;
{$else}
  MIResourceReport1.Visible := true;
  TbRefreshBtn.Visible   := true;
  MICreat.Visible        := true;
  MIShow.Visible         := true;
  MISetting.Visible      := true;
  MIVerify.Visible       := true;
  TBLogWindow.Visible    := true;
  TBSpcLowWndw.Visible   := true;
  TBCrtCap.Enabled       := not DBAppSettings.DisableCapRes;
  TBSpcCrtCap.Visible    := true;
  MICrtCapRes.Enabled    := not DBAppSettings.DisableCapRes;
  MIApaCrtCapRes.Enabled := not DBAppSettings.DisableCapRes;
  MISaveAs.Visible      := true;
  MISaveAsSim.Visible   := true;
  MISaveAsMPlan.Visible := true;
  MIDeleteSim.Visible   := true;
  MIOpenPlan.Visible    := true;
//  MIShowbintoolbar.Visible := true;
{$endif}

  MIPrint.Visible := False;
  MILabel.Visible := False;
  MIRoll.Visible  := False;
  MIProd.Visible  := False;

{$ifdef ARO}
  MIPrint.Visible := True;
  MILabel.Visible := True;
  MIRoll.Visible  := True;
  MIProd.Visible  := True;

  MISaveAs.Visible      := true;
  MISaveAsSim.Visible   := true;
  MISaveAsMPlan.Visible := true;
  MIDeleteSim.Visible   := true;
  MIOpenPlan.Visible    := true;
{$endif}

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
    SliderVisible := false;
  end;


  SetComponent(StMouseDate, comp_Descr, false);
  SetComponent(StSizePercent, comp_Descr, false);
  Save_Cursor   := Screen.Cursor;
  Screen.Cursor  := crAppStart; //SQLWait;

  Assert(p_pl <> nil);

  s_MsgHandle := Handle;
  // create the plan page control
  m_pgcPlan := TMViewPage.Create(self);
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
  LoadDefaultTabBinSet;

  LoadBarDataFromDB();
  LoadWkcSetsFromDB();

  // Builds the default resources list
  m_planTbCfg := TPlanTabsCfg.CreatePlanTbs(p_pl);
  if m_planTbCfg.LoadFromDatabase then ResetTabs(m_planTbCfg);

  m_pgcPlan.OnChange := pgcMainChange;

  if (m_planTbCfg.p_GetTabsCount > 0) then
  begin
//    TrcBarZoom.Visible := true;
    PnlZoom.Visible := true;

    StSizePercent.Visible := true;
//    TrcBarZoomChange(self);
  end else
    PnlZoom.Visible := false;
//    TrcBarZoom.Visible := false;

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
  self.Left   := DBAppGlobals.WdwPlanLeft;
  self.top    := DBAppGlobals.WdwPlantop;
  self.width  := DBAppGlobals.WdwPlanwidth;
  self.height := DBAppGlobals.WdwPlanheight;
  if DBAppglobals.WdwPlanState then WindowState := wsmaximized;

  UpdateStatus;
  UpdateStatusPanel;

  MISaveAsMPlan.Enabled := false;
  MIOpenMainPlan.Enabled := false;
  MIDelCurrSim.Enabled := false;

//  m_SimEnabled := SetFlagSimEnabled;
//  if not m_SimEnabled then
//  begin
  MISaveAs.Enabled := false;
  MISaveAsSim.Enabled := false;
  MIDeleteSim.Enabled   := false;
  MIOpenPlan.Enabled    := false;
//  end;

  Screen.Cursor := Save_Cursor;
//  DMib.RegisterEvents(false);
end;

//----------------------------------------------------------------------------//

function TFMQMPlan.CheckChangedDataForWc : boolean;
var
  qry:    TMqmQuery;
  trs:    TMqmTransaction;
  tbWcChange : ^TTblInfo;
begin
  Result := false;
  tbWcChange := @tblInfo[tbl_wkc_Change];
  SetFldPfx(tbWcChange.pfx);

  trs := CreateTransaction(Main_DB, true);
  qry := CreateQuery(trs, Main_DB);

  trs.Active := true;

  // load the Last updated number for the request changed table

  with qry do
  begin
    SQL.Clear;
    SQL.Add('select ' + CreatePfxFld(fli_wkCtrCode) + ',' + CreatePfxFld(fli_updCode));
    SQL.Add(' from ' + tbWcChange.PCname);
    SQL.Add(' order by ' + CreatePfxFld(fli_updCode));
    Open;

    while not Eof and (FieldByName(CreatePfxFld(fli_updCode)).AsInteger <= DBAppGlobals.LastUpdatNr) do
      Next;

    while not Eof do
    begin
      if (p_pl.FindWrkCtrByCode(FieldByName(CreatePfxFld(fli_wkCtrCode)).AsString) = nil) then
        Next
      else
      begin
      //  DBAppGlobals.LastUpdatNr :=  must be updated with the number , avi
        qry.Close;    //Vinc
        trs.Commit;   //Vinc
        qry.Free;     //Vinc
        trs.Free;     //Vinc

        Result := true;
        Exit;
      end;
    end;
  end;
  qry.Close;    //Vinc
  trs.Commit;   //Vinc
  qry.Free;     //Vinc
  trs.Free;     //Vinc
end;

//----------------------------------------------------------------------------//

function TFMQMPlan.MoveAllowed(Obj: TMqmDurObj): boolean;
begin
  Result := true
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
    ActbinGrid := ActTab.GetBinGrid;
    ActbinGrid.GrdTopLeftChanged(self);
  end;

  sh := pt.p_shapeMan;
  if Assigned(sh) then sh.Update
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.EnterCompatModeInPlan(id: TSchedId);
var
  i:  integer;
  ts: TMqmPlanTabSheet;
begin
  p_pl.EnterCompatModeInPlan(id);

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
    showmessage(_('Not exist on active plan'))
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
//  ErrVal: CScErrors;
  ErrSet: SetOfErrors;
  pId: TSchedID;
begin
  pId := TSchedID(Param.objPtr);
  p_sc.GetPlanInfo(pId, planInfo);
  StBarInfo.Panels.Items[0].Text := p_sc.GetObjBarText(pId, isGroup, false);

  StBarInfo.Panels.Items[1].Text := _('Start:') + ' ' + DateTimeToStr(planInfo.startDate);
  errSet := [];
  p_sc.CheckErrors(pId, CSEG_All, errSet);
//  StBarInfo.Panels.Items[2].Text := GetErrorDesc(errVal);

  StBarInfo.Panels.Items[2].Text := GetErrorDesc(GetWorstError(errSet));

  if param.suppVal1 <> -1 then
  begin
    StBarInfo.Panels.Items[2].Text := _('Case before:') + ' ' + IntToStr(param.suppVal2);
    StBarInfo.Panels.Items[3].Text := _('Case after:') + ' ' + IntToStr(param.suppVal1);
  end;

//  StBarInfo.Panels.Items[2].Text := 'Dur: ' + FloatToStr(planInfo.exeMin);
//  StBarInfo.Panels.Items[3].Text := 'End: ' + DateTimeToStr(planInfo.endDate);
//  StBarInfo.Panels.Items[4].Text := 'Qty: ' + FloatToStr(planInfo.quant);
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.SBarSetPlanObj(obj: TMqmPlanObj);
begin
  if obj is TMqmVisibleRes then
  begin
    StBarInfo.Panels.Items[0].Text := _('Resource:') + ' ' + TMqmRes(obj.p_father).p_ResCode;
    if TMqmVisibleRes(obj).p_SubCode <> -1 then
    begin
      StBarInfo.Panels.Items[1].Text := _('Sub res.:') + ' ' + IntToStr(TMqmVisibleRes(obj).p_SubCode);
    end else
    begin
//      StBarInfo.Panels.Items[0].Text := 'Resource'
    end;
  end else
  begin
    if obj is TMqmActArea then
    begin
      StBarInfo.Panels.Items[0].Text := _('Active planning area');
      StBarInfo.Panels.Items[1].Text := _('Start:') + ' ' + DateTimeToStr(TMqmActArea(obj).p_Start);
      StBarInfo.Panels.Items[2].Text := _('End:') + ' ' + DateTimeToStr(TMqmActArea(obj).p_End);
{$ifndef Customer}
      StBarInfo.Panels.Items[3].Text := _('Components:') + ' ' + IntToStr(TMqmActArea(obj).p_Components);
{$endif}
    end else
    begin
      if (obj is TMqmCapRes) then
      begin
        StBarInfo.Panels.Items[1].Text := _('Start:') + ' ' + DateTimeToStr(TMqmCapRes(obj).p_Start);
{$ifndef Customer}
        StBarInfo.Panels.Items[2].Text := _('Dur:') + ' ' + FloatToStr(TMqmCapRes(obj).p_dur);
        StBarInfo.Panels.Items[3].Text := _('End:') + ' ' + DateTimeToStr(TMqmCapRes(obj).p_End);
{$endif}
        if (TMqmCapRes(obj).m_Type = cr_Normal) then
        begin
          StBarInfo.Panels.Items[0].Text := _('Capacity reservation:') + ' ' + DBAppGlobals.CapResColors[TMqmCapRes(obj).m_ColorIndex].Dsc;
        end else
        begin
          if (TMqmCapRes(obj).m_Type = cr_DownTime) or (TMqmCapRes(obj).m_Type = Cr_CrossingDtm) then
          begin
            //StBarInfo.Panels.Items[0].Text := _('Downtime: ') + IntToStr(TMqmCapRes(obj).p_CapResNum);
             StBarInfo.Panels.Items[0].Text := TMqmCapRes(obj).m_Comment;
          end
        end;//Capres
      end else
      begin
        if (obj is  TMqmCmp ) then
        begin
          StBarInfo.Panels.Items[0].Text := _('Capacity reservation to occupation case:')+ ' ' + inttostr(TMqmCmp(obj).m_diffVal);
        end; //Cmp

      end;
    end;
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
    StMouseDate.Caption := DateTimeToStr(dtMouPos)
  end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.CleanSBar;
var
  i: integer;
begin
  for i := 0 to StBarInfo.Panels.Count -1 do
    StBarInfo.Panels.Items[i].Text := ''
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
begin
  Accept := Source.Control is TFBin;

  if Accept then
    with Source.DockRect do
    begin
      //Modify the DockRect to preview dock area.
      TopLeft     := PanRgDock.ClientToScreen(Point(-ClientWidth div 3, 0));
      BottomRight := PanRgDock.ClientToScreen(Point(0, PanRgDock.Height));
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
begin
  Accept := Source.Control is TFBin;
  if Accept then
  begin
    pan := TPanel(Sender);
    with Source.DockRect do
    begin
      //Modify the DockRect to preview dock area.
      TopLeft     := pan.ClientToScreen(Point(0, -Self.ClientHeight div 3));
      BottomRight := pan.ClientToScreen(Point(pan.Width, pan.Height)) ;
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

procedure TFMQMPlan.IDispoDetailsClick(Sender: TObject);
var
  DispoDet : TDispoDet;
begin
  DispoDet := TDispoDet.CreateDispoDet(self, TSchedId(m_popObj));
  DispoDet.ShowModal;
  DispoDet.Free
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.ICapResDetailsClick(Sender: TObject);
begin
  case TMqmCapRes(m_popObj).m_Type of
      cr_Normal: OpenCapResForm(FMQMPlan, TMqmCapRes(m_popObj), RefreshAfterMove, FMQMPlan, nil);
      cr_DownTime, Cr_CrossingDtm: OpenDownTimeForm(FMQMPlan, TMqmCapRes(m_popObj), RefreshAfterMove, FMQMPlan, TMqmActArea(TMqmCapRes(m_popObj).p_father), m_popDate);
  end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.ICloseTbsClick(Sender: TObject);
begin
  if MessageDlg(_('Delete gantt tab?'), mtWarning, [mbYes,mbNo], 0) in [mrYes] then
  begin
    m_planTbCfg.DeleteTab(TMqmPlanTabSheet(m_pgcPlan.GetActiveView).GetCode);
    m_pgcPlan.CloseActive;
    PgcMainChange(self);
  end;  
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
  DBconnection := true;
  if p_pl.ChangesMade then
  begin
    w := (MessageDlg(_('Do you want to save the changes?'), mtConfirmation, [mbYes, mbNo, mbCancel], 0));
    case w of
      mrCancel: begin
                  Action := caNone;
                  exit
                end;
      mrYes: if not p_Sim.p_SimModeActive then
               MISaveClick(self)
             else
               p_Sim.SaveSim(p_Sim.p_CurrSimCode, p_Sim.p_CurrSimDesc, MainProgBar, EnvOK);
//               p_Sim.SaveSim(p_Sim.p_CurrSimCode, p_Sim.p_CurrSimDesc, GenProgressBar, EnvOK);

    end;

    if w = mrCancel then
    begin
      Exit
    end
    else if w = mrYes then
    begin
    end;
  end;


  try
    SaveDefaultTabBinSet
  except
    on e:Exception do begin
 //   ShowMessage(_('Lost connection to database , save is aborted'));
      DBconnection := false;
    end;
  end;
  if IsDynamicPlanActiv then
     TBtnDynamicClick(self);

  // prepare values for saving
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

  for i := 0 to m_pgcPlan.PageCount-1 do
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

    TabCfg.m_CurrDtTime := ts.p_HeaderMan.m_CalPanel.LeftTime
  end;

  if fbin <> nil then FBin.SaveStatus;
  if  DBconnection then  // do we have a connection to DB
    m_planTbCfg.StoreToDatabase;
  m_planTbCfg.Free;

  if Assigned(FAutoSched) then
    FAutoSched.Free
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.PgcMainChange(Sender: TObject);
begin
  if m_planTbCfg.p_GetTabsCount = 0 then
  begin
    PnlZoom.Visible := false;
//    TrcBarZoom.Visible := false;
//    StSizePercent.Visible := false
  end
  else
  begin
    PnlZoom.Visible := true;
//    TrcBarZoom.Visible  := true;
//    StSizePercent.Visible := true;
    TrcBarZoom.Position := TMqmPlanTabSheet(m_pgcPlan.GetActiveView).p_zoom;
    TrcBarZoomChange(self);
  end;

  PgcBinChange;

end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.SetDynamicPlanActiv(ResList : TList);
var
  Plantab : TMqmPlanTabSheet;
begin
  Plantab := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
  if (Plantab.p_GetPlanType = PDynamic) then
  begin
    Plantab.p_ganttPanel.UpdateList(ResList);
    Plantab.p_ganttPanel.SortOnDunamic;
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
      if ActTab.p_ganttPanel.GetListWcForFilter(List) then
        Result := true
    end
  end
end;

//----------------------------------------------------------------------------//

function TFMQMPlan.TbsByName(TbsName : string) : TTabSheet;
var
  i: integer;
begin
  Result := nil;
  with m_pgcPlan do
  begin
    for i := 0 to PageCount -1 do
      if (TbsName = Pages[i].Name) then
        Result := Pages[i];
  end
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.AddTabWithList(name: string; resList: TList; PlanTyp : TPlanType);
var
  tc: TPlanTabCfg;
begin
  tc := m_planTbCfg.AddNewTab(name, resList, m_planTbCfg.FindNewCode, PlanTyp);
  CreateNewPlan(m_planTbCfg, tc.code);
  m_pgcPlan.ActivePageIndex := m_pgcPlan.PageCount-1
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
  FResDetails.Free
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.IWkcDetClick(Sender: TObject);
var
  FWkcDetails: TFWkcDetails;
begin
  FWkcDetails := TFWkcDetails.CreateWkcDet(self, TMqmRes(TMqmVisibleRes(m_popObj).p_father));
  FWkcDetails.ShowModal;
  FWkcDetails.Free
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
    p_opStack.MarkStackForButtonUndo(_('Unschedule'));
    id := TSchedId(m_popObj);
    MoveToBin(id, true);
    ActiveUndo;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MISaveClick(Sender: TObject);
//var
//  EnvOK: boolean;
begin
//  if TbRefreshBtn.Enabled then
//  begin
//    MessageDlg(_('Please click first on refresh data button...'), mtWarning, [mbOk], 0);
//    Exit
//  end;

  if not p_Sim.p_SimModeActive then
//    SaveToDB(false,false)
    TFWait.CreateWaitForm(self, w_Save).ShowModal
  else
//    p_Sim.SaveSim(p_Sim.p_CurrSimCode, p_Sim.p_CurrSimDesc, MainProgBar, EnvOK);
    TFWait.CreateWaitForm(self, w_SaveSim).ShowModal
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
// this button not have a menuitem set by proprieties because when the function
// disable a button that to be left down

procedure TFMQMPlan.TBUndoClick(Sender: TObject);
begin
  p_opStack.UndoByButton;

  RefreshActiveTab;
  if Assigned(FBin) then
    FBin.ChangeTabBinforChangeTabPlan;

  ActiveUndo;
end;

//----------------------------------------------------------------------------//

function TFMQMPlan.SaveToDB(ForSim: boolean): boolean;
const
  TRY_NUMBER = 14;
var
  I  :    Integer;
  qry:    TMqmQuery;
  trs:    TMqmTransaction;
  updNum: integer;
  Save_Cursor : TCursor;
  j: integer;
  w : word;
begin
  Result := false;
  qry := nil;
  trs := nil;

  if Assigned(FMQMPlan.MainProgBar) then
  begin
    FMQMPlan.MainProgBar.SetMax(TRY_NUMBER);
    FMQMPlan.MainProgBar.SetPosition(0);
  end;

  I := 0;
  while (I <= TRY_NUMBER) do
  begin
    try

      j := 0;

      while j <= TRY_NUMBER do
      begin
        //if SP_GET_ACCESS(IniAppGlobals.WkstCode, AT_save) then
        if GET_ACCESS(IniAppGlobals.WkstCode, AT_save) then
        begin
          DBAppGlobals.MAINPLAN_Ignore_Save_Event := true;
          Save_Cursor := Screen.Cursor;
          Screen.Cursor  := crAppStart;

          trs := CreateTransaction(Main_DB, false);
          qry := CreateQuery(trs, Main_DB);
          updNum := GetLastProdSched;
          p_sc.SaveJobs(qry, '', ForSim, p_pl.GetVisResCode, updNum, p_pl.HasJobWasDeletetedFromHost , MainProgBar);

          qry.Close;
          trs.Commit;

          qry.Free;
          trs.Free;

          p_pl.Save(Main_DB, '', ForSim);

      //    UpdateCalDb(GenProgressBar);
          UpdateCalDb(MainProgBar);

        //  SP_END_ACCESS(IniAppGlobals.WkstCode, true);
          END_ACCESS(IniAppGlobals.WkstCode);
          DBAppGlobals.MAINPLAN_Ignore_Save_Event := false;
          SP_SEND_UPDATE_CLIENT;

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
              FMQMPlan.MainProgBar.SelEnd := j;
            Application.ProcessMessages;
            if SP_ASK_POLL then
            begin
              Sleep(2500);
              inc(j);
              if Assigned(FMQMPlan.MainProgBar) then
                FMQMPlan.MainProgBar.SelEnd := j;
              Application.ProcessMessages;
              Sleep(2500);
              SP_CHECK_POLL;
            end else
              Sleep(2500);
          end
        end;
      end;

    except
      if assigned(trs) then
      begin
        trs.Rollback;
        trs.Free;
      end;
      if assigned(qry) then
          qry.Free;
      inc(I);
      sleep(10);
    end;

  end;


//  GenProgressBar.Position := 0;
//  MainProgBar.SetPosition(0);

end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiniMizedMainForm;
begin
  self.WindowState := wsMinimized;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MaxiMizedMainForm;
begin
  self.WindowState := wsMaximized;
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
  end
  else
  begin
    MIUndo.Enabled := False;
    TBUndo.Hint    := _('Undo');
  end;

  TBUndo.Enabled := MIUndo.Enabled;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIReloadClick(Sender: TObject);
begin
  ReloadPlanFromDB(Main_DB, '');
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.IStepDetailsClick(Sender: TObject);
var
  StepDetails : TFStepDetails;
begin
  StepDetails := TFStepDetails.CreateStepDetails(Self, TSchedId(m_popObj));
  StepDetails.ShowModal;
  StepDetails.Free
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
begin
  ResFilter := TFResFilter.CreateFrmResFilter(self);
  if ResFilter.ShowModal = mrOk then
    AddTabWithList(ResFilter.P_GetTabName, ResFilter.GetReslist, PNormal);
  PgcMainChange(self);
  ResFilter.Free
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MICrtCapResClick(Sender: TObject);
begin

  OpenCapResForm(self, nil, RefreshAfterMove, FMQMPlan, nil);

end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIApaCrtCapResClick(Sender: TObject);
var
  ActivePlanningArea: TMqmActArea;
begin
  ActivePlanningArea := TMqmActArea(m_popObj);
  OpenCapResForm(self, nil, RefreshAfterMove, FMQMPlan, ActivePlanningArea);

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
begin
  for I := 0 to PupPlan.Items.Count - 1 do
    PupPlan.Items[I].Enabled := true;

  if DBAppSettings.DisableCapRes then
    MIApaCrtCapRes.Visible := false;
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

procedure TFMQMPlan.TrcBarZoomChange(Sender: TObject);
begin
  if (m_planTbCfg.p_GetTabsCount > 0) then
  begin
    TMqmPlanTabSheet(m_pgcPlan.GetActiveView).p_zoom := TrcBarZoom.Position;
    StSizePercent.Caption := IntToStr((TMqmPlanTabSheet(m_pgcPlan.GetActiveView).p_zoom) * 5) + '%';
  end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIGrpDetailsClick(Sender: TObject);
begin
  HandleGroup(self, TSchedId(m_popObj), false)
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIConfigClick(Sender: TObject);
var
  fOptions: TFOptions;
begin
  fOptions := TFOptions.Create(Self);
  fOptions.ShowModal;
  fOptions.free;
  RefreshActiveTab;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.ICompatInBinClick(Sender: TObject);
var
  res:      TMqmRes;
  iter:     TMSchedContIterator;
  id:       TSchedId;
  linkInfo: TSQlinkInfo;
  CompVal:  TCompatVal;
  visRes:   TMqmVisibleRes;
begin
  visRes := TMqmVisibleRes(m_popObj);
  p_pl.EnterCompatModeInBin(visRes);
  res := TMqmRes(visRes.p_father);

  iter := TMSchedContIterator.CreateScIter(p_sc);
  while true do
  begin
    id := iter.GetNext;
    if id = CSchedIdNull then break;
    if (not p_sc.GetLinkInfo(id, linkInfo)) or
       linkInfo.isOnPlan                    or
       linkInfo.isGroup                     or
       (linkInfo.grpId <> CSchedIdNull)     or
       (not res.CheckCompatWithOcc([cho_compVal, cho_wkc, cho_readOnly, cho_qty, cho_Depend],
                                   id, Now, nil, compVal)) then
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

procedure TFMQMPlan.IClearCompInBinClick(Sender: TObject);
begin
  p_pl.ExitCompatModeInBin;
  p_sc.SetAllFlags([CSF_compInBin], []);

  RefreshActiveTab;
  FBin.RefreshGrid
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIShowBinClick(Sender: TObject);
begin
  if not assigned(FBin) then
  begin
    FBin := TFBin.Create(self);
    FBin.Show;
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
  act.ReorganizeAllOcc;
  RefreshActiveTab;
  FBin.ChangeTabBinforChangeTabPlan;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIJobHandleClick(Sender: TObject);
var
  JobHandle : TFJobHandle;
begin
  JobHandle := TFJobHandle.CreateJobHandle(Self, TSchedId(m_popObj));
  JobHandle.ShowModal;
  JobHandle.Free
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.TBtnDynamicClick(Sender: TObject);
var
  Code : Integer;
  Bintab : TBinTabSheet;
  ResList : TList;
begin
  if not IsDynamicActiveted(Code) then
  begin
    AddTabWithList('Dynamic', nil, PDynamic);
    if Assigned(Fbin) then
    begin
      if Fbin.GetPageCount > 0 then
      begin
        Fbin.ChangeTabBinforChangeTabPlan;
        Bintab := TBinTabSheet(Fbin.GetActiveView);
        if Assigned(BinTab) and Bintab.m_BinPanel.P_BinDynamicPlan then
        begin
          ResList := TList.Create;
          Bintab.m_BinPanel.m_objList.BuildResList(ResList);
          // avi to be continue ...
         { if Bintab.m_BinPanel.IsProdReqOnFilter then
          begin
            LinksList := TList.Create;
            p_sc.SetSearchLinks(Bintab.m_BinPanel.m_objList , LinksList);
            sh := TMqmPlanTabSheet(m_pgcPlan.GetActiveView).p_shapeMan;
            sh.AddLinkList(LinksList);
            LinksList.Free;
          end; }

          if IsDynamicPlanActiv then
            SetDynamicPlanActiv(ResList);
        end;
      end;
    end;
  end
  else  // delete dynamic tab up
  begin
    m_planTbCfg.DeleteTab(Code);
    m_pgcPlan.SetActiveView(Code);
    m_pgcPlan.CloseActive;
    PgcMainChange(self);
  end;
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
  ResourceReport : TFResourceReport;
begin
  ResourceReport := TFResourceReport.CreateResReport(self,'excel_sched');
  ResourceReport.ShowModal;
  ResourceReport.Free;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIResSchedHtmlReportclick(Sender: TObject);
var
  ResourceReport : TFResourceReport;
begin
  ResourceReport := TFResourceReport.CreateResReport(self,'html_sched');
  ResourceReport.ShowModal;
  ResourceReport.Free;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIAutoSchedCfgClick(Sender: TObject);
var
  AutoSchedCfg : TFAutoSchedCfg;
begin
  AutoSchedCfg := TFAutoSchedCfg.CreateAutoSchedCfg(self);
  AutoSchedCfg.ShowModal;
  AutoSchedCfg.Free;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIBinPrqFilterClick(Sender: TObject);
begin

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

procedure TFMQMPlan.MITraditionalClick(Sender: TObject);
begin
  UseLanguage ('zh_TW');
  ReTranslateComponent (self);
  UpdateCaptions;
  DBAppGlobals.Language := 'zh_TW';
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

procedure TFMQMPlan.MIDltProdReqValClick(Sender: TObject);
begin
  if Assigned(Fbin) then
    Fbin.CreateBinFilter(TSchedId(m_popObj) , TabReqProp, CSR_FullProdReq);
  OpenDynamicPlanforSearch;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIProductionReqClick(Sender: TObject);
begin
  if Assigned(Fbin) then
    Fbin.CreateTabFromJobID(TSchedId(m_popObj) , CSR_Prod_Req);
  OpenDynamicPlanforSearch;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIProdTypeClick(Sender: TObject);
begin
  if Assigned(Fbin) then
    Fbin.CreateTabFromJobID(TSchedId(m_popObj) , CSR_Prod_Type);
  OpenDynamicPlanforSearch;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIStepTypeClick(Sender: TObject);
begin
  if Assigned(Fbin) then
    Fbin.CreateTabFromJobID(TSchedId(m_popObj) , CSR_Step_Type);
  OpenDynamicPlanforSearch;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIWorkCenterClick(Sender: TObject);
begin
  if Assigned(Fbin) then
    Fbin.CreateTabFromJobID(TSchedId(m_popObj) , CSR_WorkCntr);
  OpenDynamicPlanforSearch;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIProccessClick(Sender: TObject);
begin
  if Assigned(Fbin) then
    Fbin.CreateTabFromJobID(TSchedId(m_popObj) , CSR_Process);
  OpenDynamicPlanforSearch;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIProdFamiyClick(Sender: TObject);
begin
  if Assigned(Fbin) then
    Fbin.CreateTabFromJobID(TSchedId(m_popObj) , CSR_Prod_Family);
  OpenDynamicPlanforSearch;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIMaterialFamilyClick(Sender: TObject);
begin
  if Assigned(Fbin) then
    Fbin.CreateTabFromJobID(TSchedId(m_popObj) , CSR_Mat_Family);
  OpenDynamicPlanforSearch;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIProdLineClick(Sender: TObject);
begin
  if Assigned(Fbin) then
    Fbin.CreateTabFromJobID(TSchedId(m_popObj) , CSR_Prod_Line);
  OpenDynamicPlanforSearch;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIEditCalClick(Sender: TObject);
var
  pt: TMqmPlanTabSheet;
  Cal : TPGCALObj;
  Res : TMqmRes;
begin

  Res := TMqmRes(TMqmVisibleRes(m_popObj).p_father);
  if TMqmWrkCtr(res.p_father).p_ReadOnly then
  begin
    MessageDlg(_('Is not possible modify the calendar for resource read-only'),
            mtInformation, [mbOk], 0);
    exit;
  end;

  Cal := TMqmVisibleRes(m_popObj).GetCalendar;

  if Cal.GetKey <> 'VOID' then
  begin
    MEditCal := TMEditCal.CreateEditCalFrm(self, Cal);
    MEditCal.ShowModal;
    pt := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
    if Assigned(pt) then
      pt.p_shapeMan.ShapesUpdate;
    MEditCal.Free
  end;

end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIAutoSeqResultClick(Sender: TObject);
begin
{
  if Assigned(FAutoSchedRpt) then
    FAutoSchedRpt.Show
  else
  begin
    if Assigned(FAutoSched) then
    begin
      TFAutoSchedRpt.CreateAutoSchedRpt(FMQMPlan, FAutoSched.m_ResultsOnPlan, FAutoSched.m_ResultsInBin);
      FAutoSchedRpt.Show
    end;
  end
}
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MISortResourceCodeClick(Sender: TObject);
var
  Plantab : TMqmPlanTabSheet;
begin
  Plantab := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
  Plantab.p_ganttPanel.SortByResourceCode;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.Categoryresourcecode1Click(Sender: TObject);
var
  Plantab : TMqmPlanTabSheet;
begin
  Plantab := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
  Plantab.p_ganttPanel.SortByCategoryAndResCode;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.WCresourcecode1Click(Sender: TObject);
var
  Plantab : TMqmPlanTabSheet;
begin
  Plantab := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
  Plantab.p_ganttPanel.SortByWcAndRes;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.Wccategoryresource1Click(Sender: TObject);
var
  Plantab : TMqmPlanTabSheet;
begin
  Plantab := TMqmPlanTabSheet(m_pgcPlan.GetActiveView);
  Plantab.p_ganttPanel.SortByWcAndCatAndRes;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.Findjobinbin1Click(Sender: TObject);
begin
  if Assigned(Fbin) then
    Fbin.FocusBinOnJobID(TSchedId(m_popObj), True);
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MiSetBinConficurationClick(Sender: TObject);
begin
  TFConfigBin.CreateCfgBin(Self, true).ShowModal;
end;

//----------------------------------------------------------------------------//
{
 Deletes all the Jobs/steps from the Gannt and moves them back to the bin
 it checks for the following :
 1. the job isn't a progressed job
 2. the job isn't closed
 3. there are no dependant jobs upon this job

 }
procedure TFMQMPlan.IMoveAllJobsToBinClick(Sender: TObject);
begin
  MoveAllJobsToBin;
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

procedure MoveAllJobsToBin;
var
  id, IdGrp :      TSchedId;
  i, j, JobsInBinCount : integer;
//, loopcounter: Integer;
  linkInfo: TSQlinkInfo;
  ActTab : TBinTabSheet;
  ActBinGrid: TBinDrawGrid;
//  JobDeletedThisLoop: boolean;
  JobStillOnPlan, IsBelong: boolean;
  actArea, OldActArea: TMqmActArea;
  TmpLstActArea: TList;
  OptsMover: SetOptsMover;
  DeltaSetupObjToMove: double;
  MarkStack: TStackMark;
begin
  // Refactorized by fp - October 20th 2005
  // Refactorized by fp - November 10th 2005

  MarkStack := p_OpStack.MarkStack;

  JobStillOnPlan := false;
  TmpLstActArea := nil;

  if MessageDlg(_('Unschedule all jobs in current bin ?'), mtWarning, [mbYes,mbNo], 0) in [mrYes] then
  begin
    ActTab := FBin.GetActiveView;
    if not Assigned(ActTab) then
    begin
      MessageDlg(_('No bin available'), mtError, [mbOK], 0);
      exit;
    end;
    ActbinGrid := ActTab.GetBinGrid;
//    loopcounter := 0;

    p_opStack.MarkStackForButtonUndo(_('Unschedule all jobs in current bin'));

    TmpLstActArea := TList.Create;

//    repeat
      JobsInBinCount := TBinPanel(ActbinGrid.Parent).m_ObjList.GetLinkCount;
//      JobDeletedThisLoop := false;
//      loopcounter := loopcounter +1;
      //we must loop from end to start because each time we delete a job
      //the JobsInBinCount is reduced by one and so GetLink(i) must be
      //GetLink(0) to get the first object, but then we can't continue to loop
      //in case that the first id can't be deleted if it has some dependant ids
      for i := (JobsInBinCount - 1) downto 0 do
      begin
        actArea := nil;
        Id := TBinPanel(ActbinGrid.Parent).m_ObjList.GetLink(i);
        if id = CSchedIdNull then break;
        if p_sc.GetLinkInfo(id, linkInfo) = false then continue;
        if linkInfo.isOnPlan = false then continue;

        if DBAppSettings.ShowGroupLinesInBin then
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
        end;

        if not MoveToBin(id, false) then
        begin
          JobStillOnPlan := true;
          continue;
        end;

        TmpLstActArea.Add(actArea);
//        JobDeletedThisLoop := true;
      end; //for

//    until  (JobDeletedThisLoop = false) and (loopCounter > 1 );
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
          if ActArea.ReorganizeOcc(id, false, OptsMover, DeltaSetupObjToMove, nil) = CSM_No then
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
  FBin.ChangeTabBinforChangeTabPlan;

  if JobStillOnPlan then
    MessageDlg(_('Not all jobs were unscheduled'), mtWarning, [mbOK], 0);

  FMQMPlan.ActiveUndo;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.PupJobPopup(Sender: TObject);
var
  id : TSchedId;
  I : Integer;
begin
  for I := 0 to PupJob.Items.Count -1 do
    PupJob.Items.Items[I].Enabled := true;

  for I := 0 to PupJob.Items.Count -1 do
    PupJob.Items.Items[I].Visible := true;

  for I := 0 to MISetLevelTo.Count -1 do
    MISetLevelTo.Items[I].Visible := true;

  id := TSchedId(m_popObj);

  if (DBAppGlobals.ConfLevels = 0) then
    MISetLevelTo.Visible := false;
  if (DBAppGlobals.ConfLevels = 0) or (p_sc.GetSchedType(id) = '1') then
    MISetToTemp.Visible := false;
  if (DBAppGlobals.ConfLevels = 0) or (p_sc.GetSchedType(id) = '2') then
    MISetFinal.Visible := false;
  if (DBAppGlobals.ConfLevels <= 1) or (p_sc.GetSchedType(id) = '4') then
    MISetLevelTo1.Visible := false;
  if (DBAppGlobals.ConfLevels <= 2) or (p_sc.GetSchedType(id) = '5') then
    MISetLevelTo2.Visible := false;
  if (DBAppGlobals.ConfLevels <= 3) or (p_sc.GetSchedType(id) = '6') then
    MISetLevelTo3.Visible := false;
  if (DBAppGlobals.ConfLevels <= 4) or (p_sc.GetSchedType(id) = '7') then
    MISetLevelTo4.Visible := false;
  if (DBAppGlobals.ConfLevels <= 5) or (p_sc.GetSchedType(id) = '8') then
    MISetLevelTo5.Visible := false;

  if (DBAppGlobals.ConfLevels = 0) or (p_sc.GetSchedType(id) = '2') then
    MISetNextLevel.Visible := false
  else
  begin
    if (p_sc.GetSchedType(id) = '1') and (DBAppGlobals.ConfLevels > 1) then
      MISetNextLevel.Caption := _('Set to confirmation level 1')
    else if (p_sc.GetSchedType(id) = '4') and (DBAppGlobals.ConfLevels > 2) then
      MISetNextLevel.Caption := _('Set to confirmation level 2')
    else if (p_sc.GetSchedType(id) = '5') and (DBAppGlobals.ConfLevels > 3) then
      MISetNextLevel.Caption := _('Set to confirmation level 3')
    else if (p_sc.GetSchedType(id) = '6') and (DBAppGlobals.ConfLevels > 4) then
      MISetNextLevel.Caption := _('Set to confirmation level 4')
    else if (p_sc.GetSchedType(id) = '7') and (DBAppGlobals.ConfLevels > 5) then
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
      MISetIniFin.ImageIndex := 36;
    end else
    begin
      MISetIniFin.Caption := _('Set to initial');
      MISetIniFin.ImageIndex := 37;
    end
  end;

  if Assigned(p_sc.GetExtLinkPtr(id)) and not (p_sc.GetVisbleInBin(id) = CSB_Normal) then
     IMoveToBin.Enabled := false;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.PupGroupPopup(Sender: TObject);
var
  id : TSchedId;
  I : Integer;
begin
  for I := 0 to PupGroup.Items.Count -1 do
    PupGroup.Items.Items[I].Enabled := true;
  id := TSchedId(m_popObj);
  if (p_sc.GetVisbleInBin(id) = CSB_ReadOnly) then
    MIgrpToBin.Enabled := false;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIBinHtmlReportClick(Sender: TObject);
var
  saveDialog : TSaveDialog;
begin
  saveDialog := TSaveDialog.Create(self);
  saveDialog.Title := _('Save bin report as:');
  saveDialog.InitialDir := GetCurrentDir;
  saveDialog.Filter := 'Html file|*.htm';//'Text file|*.txt|Word file|*.doc';
  saveDialog.DefaultExt := 'htm';
  saveDialog.FilterIndex := 1;
  if saveDialog.Execute then
  begin
    PrintBinReport(saveDialog.FileName);
    ShowMessage(_('Bin extraction saved'));
   end
  else
    begin
      ShowMessage(_('Save file was cancelled'));
      exit;
    end;
  saveDialog.Free;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIBinExcelReportClick(Sender: TObject);
var
  //ExcelReport : TFBinToExcel;
  NativeExcel: TmxNativeExcel;
  saveDialog : TSaveDialog;
begin
  NativeExcel := TmxNativeExcel.Create(self);
  saveDialog := TSaveDialog.Create(self);
  saveDialog.Title := _('Save bin report as:');
  saveDialog.InitialDir := GetCurrentDir;
  saveDialog.Filter := 'Excel file|*.xsl';//'Text file|*.txt|Word file|*.doc';
  saveDialog.DefaultExt := 'xsl';
  saveDialog.FilterIndex := 1;
  if saveDialog.Execute then
  begin
    BinToExcelExport(NativeExcel,saveDialog.FileName);
    ShowMessage(_('Bin extraction saved'));
   end
  else
    begin
      ShowMessage(_('Save file was cancelled'));
      exit;
    end;
  saveDialog.Free;
  NativeExcel.Free;



  {
  ExcelReport := TFBinToExcel.Create(self);
  ExcelReport.ShowModal;
  ExcelReport.Free;
  }
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.RefreshTimerTimer(Sender: TObject);
begin
  RefreshTimer.Interval := 600;
  if (TbRefreshBtn.ImageIndex = -1) then
    TbRefreshBtn.ImageIndex := 45
  else
    TbRefreshBtn.ImageIndex := -1
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.TbRefreshBtnClick(Sender: TObject);
begin
  DBAppGlobals.MAINPLAN_Ignore_Save_Event := true;
  DBAppGlobals.MAINPLAN_Ignore_Pain_When_refresh := true;
  TFWait.CreateWaitForm(self, w_Refresh).ShowModal;
  DBAppGlobals.MAINPLAN_Ignore_Pain_When_refresh := false;
  DBAppGlobals.MAINPLAN_Ignore_Save_Event := false;
end;

//----------------------------------------------------------------------------//

function RefreshData : boolean;
const
  TRY_NUMBER = 14;
var
  qry:    TMqmQuery;
  trs:    TMqmTransaction;
  DispoList : TStringList;
//  srvLoadOn, canRead, canWrite : boolean;
  j, I: integer;
begin
  Result := false;
  qry := nil;
  trs := nil;
  if Assigned(FMQMPlan.MainProgBar) then
  begin
    FMQMPlan.MainProgBar.SetMax(TRY_NUMBER);
    FMQMPlan.MainProgBar.SetPosition(0);
  end;

  I := 0;

  while (I <= TRY_NUMBER) do
  begin

    try

      j := 0;

      while j <= TRY_NUMBER do
      begin
       // if SP_GET_ACCESS(IniAppGlobals.WkstCode, AT_Lock) then
        if GET_ACCESS(IniAppGlobals.WkstCode, AT_Lock) then
        begin
          Screen.Cursor := crHourGlass;
          trs := CreateTransaction(Main_DB, true);
          qry := CreateQuery(trs, Main_DB);
          trs.StartTransaction;
          DispoList := TStringList.Create;
          p_sc.UpdateClientForChanges(qry, p_pl.FindWrkCtrByCode, p_pl.PlanLinkJob, DispoList, FMQMPlan.MainProgBar);
          p_pl.m_today := GetDateForPlanLine;
          p_pl.m_todayAlgn := p_pl.m_Today;
          p_sc.P_ReorganizeAllEnd := false;
          p_pl.ReorganizeAll(nil, nil);
          p_sc.P_ReorganizeAllEnd := true;

      //    qry.Close;  //Vinc
      //    trs.Commit;
          trs.Free;
          qry.Free;

        //  SP_END_ACCESS(IniAppGlobals.WkstCode,false);
          END_ACCESS(IniAppGlobals.WkstCode);
          DBAppGlobals.MAINPLAN_Ignore_Pain_When_refresh := false;
          FMQMPlan.ActiveUndo;
          FMQMPlan.RefreshActiveTab;
          FBin.UpdateForChangeFilter;
          FMQMPlan.RefreshTimer.Enabled := false;
          FMQMPlan.TbRefreshBtn.ImageIndex := 45;
          FMQMPlan.TbRefreshBtn.Enabled := false;
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
              FMQMPlan.MainProgBar.SelEnd := j;
            Application.ProcessMessages;
            if SP_ASK_POLL then
            begin
              Sleep(2500);
              inc(j);
              if Assigned(FMQMPlan.MainProgBar) then
                FMQMPlan.MainProgBar.SelEnd := j;
              Application.ProcessMessages;
              Sleep(2500);
              SP_CHECK_POLL;
            end else
              Sleep(2500);
          end
        end;
      end;

    except
      if assigned(trs) then
      begin
        trs.Rollback;
        trs.Free;
      end;
      if assigned(qry) then
          qry.Free;
      inc(I);
      sleep(10);
    end;
  end;

end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MISaveAsSimClick(Sender: TObject);
var
  str : string;
begin
  FSimulations := TFSimulations.FrmCreate(self, em_Save);
  FSimulations.ShowModal;
  FSimulations.Free;

  if p_Sim.p_SimModeActive then
  begin
    str := _('Simulation mode active') + ': ' + p_Sim.p_CurrSimCode;
    if Trim(p_Sim.p_CurrSimDesc) <> '' then
      str := str + ' (' + p_Sim.p_CurrSimDesc + ')';
    PnlSimulation.Caption := str;
    PnlSimulation.Visible := true;
  end;

  MISaveAsMPlan.Enabled := true;
  MIOpenMainPlan.Enabled := true;
  MIDelCurrSim.Enabled := true;

  RefreshActiveTab;
  if Assigned(FBin) then
    FBin.ChangeTabBinforChangeTabPlan
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MISaveAsMPlanClick(Sender: TObject);
var
  EnvOK : boolean; // Not Used here
begin
  if not p_Sim.p_SimModeActive then
    MessageDlg(_('Simulation mode not active. Please use the normal save'), mtInformation, [mbOK], 0)
  else
  begin
    FMsgDlgSim := TFMsgDlgSim.Create(self);
    FMsgDlgSim.ShowModal;

    if FMsgDlgSim.m_ResultMode > 0 then
    begin
      SaveToDB(true);

      case FMsgDlgSim.m_ResultMode of
        1: p_Sim.DeleteAllSims(EnvOK);
        2: p_Sim.DeleteSimByCode(p_Sim.p_CurrSimCode, EnvOK);
      end;

      p_Sim.ExitFromSimMode;
      if not p_Sim.p_SimModeActive then
      begin
        PnlSimulation.Caption := '';
        PnlSimulation.Visible := false;
      end;

      MISaveAsMPlan.Enabled := false;
      MIOpenMainPlan.Enabled := false;
      MIDelCurrSim.Enabled := false;

    end;
    FMsgDlgSim.Free;

    RefreshActiveTab;
    FBin.ChangeTabBinforChangeTabPlan
  end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIOpenMainPlanClick(Sender: TObject);
var
  EnvOK: boolean; // not used here
begin
  if not p_Sim.p_SimModeActive then
    MessageDlg(_('The Plan you using now is already the main plan'), mtInformation, [mbOK], 0)
  else
  begin
    if p_pl.ChangesMade and
       (MessageDlg(_('Before load main plan do you want to save current simulation?'),
             mtConfirmation, [mbYes, mbNo], 0) = idYes) then
    begin
      if not p_Sim.SaveSim(p_Sim.p_CurrSimCode, p_Sim.p_CurrSimDesc,
                           MainProgBar, EnvOK) then
      begin
        MessageDlg(_('Not possible to save the simulation'), mtError, [mbOK], 0);
        exit
      end;
    end;

    // For avoid problem when reload calendar of main plan
    p_Sim.ExitFromSimMode;

    MIReloadClick(Sender);

    // Exit from Simulation mode
    if not p_Sim.p_SimModeActive then
    begin
      PnlSimulation.Caption := '';
      PnlSimulation.Visible := false;

      MISaveAsMPlan.Enabled := false;
      MIOpenMainPlan.Enabled := false;
      MIDelCurrSim.Enabled := false;
    end;

    RefreshActiveTab;
    if Assigned(FBin) then
      FBin.ChangeTabBinforChangeTabPlan
  end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIOpenOldSimClick(Sender: TObject);
var
  str: string;
begin

  FSimulations := TFSimulations.FrmCreate(self, em_Open);
  FSimulations.ShowModal;
  FSimulations.Free;

  if p_Sim.p_SimModeActive then
  begin
    str := _('Simulation mode active') + ': ' + p_Sim.p_CurrSimCode;
    if Trim(p_Sim.p_CurrSimDesc) <> '' then
      str := str + ' (' + p_Sim.p_CurrSimDesc + ')';
    PnlSimulation.Caption := str;
    PnlSimulation.Visible := true;

    MISaveAsMPlan.Enabled := true;
    MIOpenMainPlan.Enabled := true;
    MIDelCurrSim.Enabled := true;

    p_opStack.Clear;
    ActiveUndo;
  end;

  RefreshActiveTab;
  if Assigned(FBin) then
    FBin.ChangeTabBinforChangeTabPlan

end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIOpenNewSimClick(Sender: TObject);
begin
  MISaveAsSimClick(Sender);
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIDelCurrSimClick(Sender: TObject);
var
  w : word;
  EnvOK : boolean;
begin

  if not p_Sim.p_SimModeActive then
    MessageDlg(_('Simulation mode not active. Is not possible to delete'), mtInformation, [mbOK], 0)
  else
  begin
    w := MessageDlg(_('After deleting the current simulation, the main plan will be opened.')
                   + ' ' + _('Do you confirm?'),
            mtConfirmation, [mbYes, mbNo], 0);
    if w = mrNo then
      exit
    else
    begin
      if not p_Sim.DeleteSimByCode(p_Sim.p_CurrSimCode, EnvOK) then
         MessageDlg(_('Is not possible to delete the simulation'), mtWarning, [MbOk], 0)
      else
      begin
        MIReloadClick(Sender);
      end;
    end;
  end;

  p_Sim.ExitFromSimMode;
  if not p_Sim.p_SimModeActive then
  begin
    PnlSimulation.Caption := '';
    PnlSimulation.Visible := false;

    MISaveAsMPlan.Enabled := false;
    MIOpenMainPlan.Enabled := false;
    MIDelCurrSim.Enabled := false;
  end;

  RefreshActiveTab;
  if Assigned(FBin) then
    FBin.ChangeTabBinforChangeTabPlan

end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIDelSimSelClick(Sender: TObject);
begin

  FSimulations := TFSimulations.FrmCreate(self, em_Delete);
  FSimulations.ShowModal;
  FSimulations.Free;

  if not p_Sim.p_SimModeActive then
  begin
    PnlSimulation.Caption := '';
    PnlSimulation.Visible := false;

    MISaveAsMPlan.Enabled := false;
    MIOpenMainPlan.Enabled := false;
    MIDelCurrSim.Enabled := false;

    p_opStack.Clear;
    ActiveUndo;
  end;

  RefreshActiveTab;
  if Assigned(FBin) then
    FBin.ChangeTabBinforChangeTabPlan

end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIDelAllSimClick(Sender: TObject);
var
  str: string;
  EnvOK,
  ReloadMainPlan: boolean;
begin

  if p_Sim.p_SimNumCount = 0 then
  begin
    MessageDlg(_('There are no simulations to delete'), mtInformation, [MbOk], 0)
  end else
  begin
    if p_Sim.p_SimModeActive then
    begin
      str := _('After deleting all simulations, the main plan will be opened.') + ' ';
      ReloadMainPlan := true;
    end else
      ReloadMainPlan := false;
    if  MessageDlg(str + _('Do you confirm?'),
                   mtConfirmation, [mbYes, mbNo], 0) = mrNo then
      exit
    else
      if not p_Sim.DeleteAllSims(EnvOK) then
        MessageDlg(_('Is not possible to delete one or more Simulations'), mtWarning, [MbOk], 0)
      else
        if ReloadMainPlan then
        begin
          MIReloadClick(Sender);
        end;

    PnlSimulation.Caption := '';
    PnlSimulation.Visible := false;

    MISaveAsMPlan.Enabled := false;
    MIOpenMainPlan.Enabled := false;
    MIDelCurrSim.Enabled := false;

    RefreshActiveTab;
    if Assigned(FBin) then
      FBin.ChangeTabBinforChangeTabPlan
  end;

end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.FormShow(Sender: TObject);
begin
  if (m_planTbCfg.p_GetTabsCount > 0) then
  begin
    TrcBarZoom.SetFocus;
    TrcBarZoom.Position := TMqmPlanTabSheet(m_pgcPlan.GetActiveView).p_zoom;
    TrcBarZoomChange(self);
  end;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIJobBarConfigClick(Sender: TObject);
var
  FBarConfigSets: TFBarConfigSets;
begin
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
  ResourceReport : TFResourceReport;
begin
  ResourceReport := TFResourceReport.CreateResReport(self,'html');
  ResourceReport.ShowModal;
  ResourceReport.Free;
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

procedure TFMQMPlan.MIRollClick(Sender: TObject);
begin
{$ifdef ARO}
  if SaveCurrBin then
  begin
    if not Assigned(FQReportRoll) then
      FQReportRoll := TFQReportRoll.Create(Self);

    if FQReportRoll.Showing then
      FQReportRoll.SetFocus
    else
    begin
      with FQReportRoll do
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

  ProdStep := p_sc.GetFldDescr(id, CSC_ProdStep);
  WkcProc :=  p_sc.GetFldDescr(id, CSC_WkctProc);

  MachSetupCodeList := p_sc.GetStepIssMaterials(id);

  if planInfo.isOnPlan then
  begin
    Res := TMqmRes(TMqmActArea(p_sc.getExtLinkPtr(id)).p_res);
    if Assigned(Res) then
    begin
      MacSetupRec.ResCat := Res.p_ResCat.p_ResCatCode;
      MacSetupRec.ResCode := Res.p_ResCode;
      MacSetupRec.WrkCtrCode := TMqmWrkCtr(Res.p_WrkCtr).p_WrkCtrCode;

      IssArtList := TMQMIssuedArtList.Create;
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
  p_opStack.SetSchedType(id, '4');

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
  p_opStack.SetSchedType(id, '5');

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
  p_opStack.SetSchedType(id, '6');

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
  p_opStack.SetSchedType(id, '7');

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
  p_opStack.SetSchedType(id, '8');

  RefreshActiveTab;

  if Assigned(FBin) then
    FBin.ChangeTabBinforChangeTabPlan
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

procedure TFMQMPlan.MISetNextLevelClick(Sender: TObject);
var
  id : TSchedId;
begin
  id := TSchedId(m_popObj);

  if (p_sc.GetSchedType(id) = '1') and (DBAppGlobals.ConfLevels >= 2) then
    p_opStack.SetSchedType(id, '4')
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
  FAbout.ShowModal;
  FAbout.Free;
end;

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

  ProdStep := p_sc.GetFldDescr(id, CSC_ProdStep);
  WkcProc :=  p_sc.GetFldDescr(id, CSC_WkctProc);

  MachSetupCodeList := p_sc.GetStepIssMaterials(id);

  if planInfo.isOnPlan then
  begin
    Res := TMqmRes(TMqmActArea(p_sc.getExtLinkPtr(id)).p_res);
    if Assigned(Res) then
    begin
      MacSetupRec.ResCat := Res.p_ResCat.p_ResCatCode;
      MacSetupRec.ResCode := Res.p_ResCode;
      MacSetupRec.WrkCtrCode := TMqmWrkCtr(Res.p_WrkCtr).p_WrkCtrCode;

      IssArtList := TMQMIssuedArtList.Create;
      MachSetupCodeList.GetIssuedArtList(MacSetupRec, IssArtList);

      FrmMat := TFMaterialReq.CreateReqForm(self,id,IssArtList); //TFShowMaterials.CreateFrmShowMat(self, id, nil, nil, nil, IssArtList, p_sc.GetReqBalList(Id));
      FrmMat.ShowModal;
      FrmMat.Free;

      IssArtList.Free;
    end;
  end
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIResetBinClick(Sender: TObject);
begin
  if not assigned(FBin) then
  begin
    FBin := TFBin.Create(self);
    FBin.Show;
  end else
   FBin.ResetBinState;
end;

//----------------------------------------------------------------------------//

procedure TFMQMPlan.MIFileClick(Sender: TObject);
begin
  if not SP_SRVLOAD_GET_STATUS_OPENED_OR_CLOSED then
    MIDownLoadFromHost.Enabled := false;
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

procedure TFMQMPlan.ToolButton10Click(Sender: TObject);
begin
  p_sc.FillReportsID;
end;

procedure TFMQMPlan.BitBtn1Click(Sender: TObject);
begin
  p_sc.FillReportsID;
end;

initialization

  s_FMQMPlan := nil;

//----------------------------------------------------------------------------//

end.

