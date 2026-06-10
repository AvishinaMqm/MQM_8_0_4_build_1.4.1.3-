unit UMglobal;

interface

uses
  SysUtils,
  Graphics,
  Classes,
  UMCompat,
  UMTblDesc,
  Windows,
  UMCompatRules,
  DMsrvPc, UMCommon, Forms, StdCtrls, StrUtils,
  UMCompatSrv;

const
  // colores
  Cl_STNDRD_LIGHT_BLUE = 15972184;
  Cl_STNDRD_WARP_COLOR = $009547D9;
  // RELEINFO
  C_MQM_MAIN_VER   = '8';
  C_MQM_HOST_DB    = '0';
  C_MQM_MAIN_PC_DB = '4';
//  C_MQM_CFG_PC_DB  = '0';
  C_MQM_BUILD      = '1.4.1.3';

  csMqmMainBranch = 'main';
{$ifdef CUST_RELE}
  csMqmGroup      = 'mqm';
{$else}
  {$ifdef DEV_RELE}
    csMqmGroup      = 'mqm'+C_MQM_MAIN_VER+C_MQM_EXT_RELE+C_MQM_INT_RELE+C_MQM_BUILD;
  {$else}
    csMqmGroup      = 'mqmSched';
  {$endif}
{$endif}

type

  TDisplayBarColor = (Standard,PreDefinedPropList,DinamicPropList,ScheduleStatus);
  CScFrcOverlap = (FOL_No, FOL_Forceable, FOL_Yes);
  CBCreateNewBibTabForCompatible = (NewB_No, NewB_Yes_OnlyCompatibleAndToSchedJobs ,NewB_Yes_MarkCompatibleAndToSchedJobs, NewB_Yes_ShowOnlyCompatibles);
  SCShowCompatibleInExistingBINS = (ShowC_No, ShowC_Yes_MarkTheCompatibles ,ShowC_Yes_ShowOnlyCompatibles);
  SCShowScheduledJobsOfSelectedResource = (ShowS_No, ShowS_Yes);

  TPopUpCustomMenu = record
    Code  : String;
    Caption  : String;
    Visible: boolean;
  end;

  TLogInfo = record
    DateTimeCreate : TDateTime;
    LogOrig : string;
    Request : string;
    step : integer;
    Substep : integer;
    ReProcess : integer;
    OperationOnTable : string;
    ScheduleInfo : string;
    Resource : string;
    qty : double;
    StartScheduleDate : TDateTime;
    EndScheduleDate : TDateTime;
    SchedType : string;
    Reason : string;
  end;
  PTLogInfo = ^TLogInfo;

  TDetCmpClr = record
//    lim: integer;
    int: TColor;
    brd: TColor;
    txt: TColor;
    Dsc: String;   // Description
  end;
  TColorArray = array of TDetCmpClr;

  TSendMailParm = record
    TLS_SSL    : boolean;
    SmtpServer : string;
    Port       : string;
    Recipient : string;
    UserId : string;
    Password : string;
    Subject  : string;
    BodyText : string;
    AttachmentFilePath : string;
  end;

  TIniAppGlobals = record
    MainFormCreated : boolean;
    MyPollingNumber : integer;
    MySrvEvent      : boolean;
    Identifier : string;
    CheckTimer : string;
//    ClientConnectionCheck : string;
    StartCheck : string;
    EndCheck   : string;
    // Environment

    AliasOdbc:  string;
    downloadTo: String;
    downloadFrom: String;

    IBUserName: String;
    IBPassword: String;
    IBDataSource: String;

    NOWDB2InstanceName: String;
    NOWDB2UserName: String;
    NOWDB2Password: String;
    NOWDB2DataSource: String;
    NOWDB2SrvIP: String;
    NOWDB2PORT : string;

    NOWDB2InstanceNameLocal: String;
    NOWDB2UserNameLocal: String;
    NOWDB2PasswordLocal: String;
    NOWDB2DataSourceLocal: String;
    NOWDB2SrvIPLocal: String;
    NOWDB2PORTLocal : string;

    NOWOracleIp : string;
    NOWOracleTNSName: String;
    NOWOracleUserName: String;
    NOWOraclePassword: String;

    NOWOracleIpLocal : string;
    NOWOracleTNSNameLocal: String;
    NOWOracleUserNameLocal: String;
    NOWOraclePasswordLocal: String;

    ODBCDriverName: String;
    ODBCUserName: String;
    ODBCPassword: String;

    Server     : string;
    MainDBPath : string;
    CfgDBPath  : string;
    ArcDBPath : string;
    MainDBName : string;
    CfgDBName  : string;
    ArcDBName : string;

    // Data relevant for Now

    CompanyCode: string;
    CompanyInUsed : string;
    GroupCode  : string;
    EnvironmentCode : string;
    FormulaForMaterialAvailability, FormulaForMaterialAvailabilityToIgnore  : string;

    RefreshUTC, RefreshUTCNew : TDateTime;
    ShowPropColor_Standart_RGB : String;

//    MudulesServed : string;  // mqm,mcm,both
    SrvNameUserDefine : string;
 //   Alias      : string;
    PCAlias    : string;
    TimeLoop   : string;
    OperateTimeLoopDnldUpload : string;
	  OperateWaitingTimeUploadDnld : string;
    CopiedSchedTypeFromMqm : string;
    CBCopiedSchedTypeFromMqm : string;
    CBForceMqmScheduleDetails : string;
    CopiedBackwardFromMqmDays : string;
    CBCopiedBackwardFromMqmDays : string;
    DwnTypeMode   : string;
    DwnLoopWithMqmCg : string;
    PreparationExeName : string;
    DaysKeepHistory    : string;
    DaysKeepLogHistory : string;
    HostDateFormat : string;
//    LoginAuto      : string;
    TimePickerEndLoop : String;
    DndArchiveName : string;
//    User           : string;
//    Password       : string;
    HtmlRowNum     : string;
    ShowBinCaption : string;
    ShowBinCaptionBinReport : string;
    ShowCriteria   : string;
    ReportComment1 : String;
    PagePerResource  : String;
    IncDowntime      : String;
    ShowUnschedJobs  : String;
    FontBinCaption   : String;
    FontBinCapSize   : String;
    FontBinCapStyle  : String;
    FontBinCapColor  : String;
    FontBinCapChar   : String;
    FontCriteria     : String;
    FontCriteriaSize : String;
    FontCriteriaStyle: String;
    FontCriteriaColor: String;
    FontCriteriaChar : String;
    FontComment      : String;
    FontCommentSize  : String;
    FontCommentStyle : String;
    FontCommentColor : String;
    FontCommentChar  : String;
    FontColTitles    : String;
    FontColTitleSize : String;
    FontColTitleStyle: String;
    FontColTitleColor: String;
    FontColTitleChar : String;
    FontDataLine     : String;
    FontDataLineSize : String;
    FontDataLineStyle: String;
    FontDataLineColor: String;
    FontDataLineChar : String;
    HtmlColorBack    : String;
    HtmlColorTabTitle: String;
    HtmlColorTabEven : String;
    HtmlColorTabOdd  : String;
    ExcelTitle       : String;
    ExcelTitleBinReport  : String;

    SMTP_server : string;
    PORT : string;
    LOGINWithAUTHENTICATION : string;
    TLS_SSL  : string;

    Field1BinColReportStatic : string;
    Field2BinColReportStatic : string;
    Field3BinColReportStatic : string;
    Field4BinColReportStatic : string;
    Field5BinColReportStatic : string;
    Field6BinColReportStatic : string;
    Field7BinColReportStatic : string;
    Field8BinColReportStatic : string;
    Field9BinColReportStatic : string;
    Field10BinColReportStatic : string;

    Concatenation : string;
    Separator     : String;
    HeadingConcatination : string;
    HeadingSeparator     : String;
    ShowCaptionsAndTotal : string;
    ShowColumnCaptionsReport : string;
    ShowColumnCaptionsBinReport : string;
    ShowTotalReport : string;
    SelectedAtibute : string;

    // Machine period report

    MachineReportPeriodTitle        : string;
    MachineReportPeriod       : string;
    MachineReportPeriodFrom         : string;
    MachineReportPeriodNum  : string;
    MachineReportShowFromToHeader : string;
    MachineReportFileNameAutoOperation : string;
    MachineReportDaysMinusDoday : string;

    GroupingFields   : String;
    JumpingFields    : String;
    ShowGroups       : String;
    ShowResources    : String;

    SplitByDateTimeNumOfDec  : String;
    SplitByDateTimeRoundCrit : String;
    SplitByDateTimeReJoinBinJob : String;

    SplitFromPointNumOfDec  : String;
    SplitFromPointRoundCrit : String;
    SplitFromPointOnPreDefTime : string;
    SplitFromPointPreDefTime : string;

    NumOfDecJobQtyOnStatusBar : String;
    ShowStatusBarAsHint : boolean;
    // Setting for Workstation
    WkstCodeSelected : boolean;
    WkstCode : string;
    WkstDesc : string;
    Curr_Date_Signed : TDateTime;
    FilePlanPropRepo: string;
    InfoStringList : TStringList;

    External_Database_Update : string;
    ChangePassStation   : string;
    BalanceViewToUseInAvailability : string;
    VIEWTLSPODUpdateDeliveryDate : string;

    // disableButton
    Upload_Download_disable : string;
    // Arc_Not_To_Dwnload
    tbl_wkc_alt_NOT_Dwld : string;
    tbl_arty_NOT_Dwld    : string;
    tbl_resCat_NOT_Dwld  : string;
    tbl_res_sub_NOT_Dwld : string;
    tbl_ruleOccToOcc_NOT_Dwld : string;
    tbl_prop_NOT_Dwld         : string;
    tbl_res_NOT_Dwld          : string;
    tbl_ruleResToOcc_NOT_Dwld : string;
    tbl_prop_res_NOT_Dwld     : string;
    tbl_unit_NOT_Dwld         : string;
    tbl_wkc_NOT_Dwld          : string;
    tbl_wkc_proc_NOT_Dwld     : string;
    tbl_wkst_NOT_Dwld         : string;
    tbl_wkst_wkc_NOT_Dwld     : string;
    tbl_wkc_priority_NOT_Dwld  : string;
    tbl_machine_setup_code_NOT_Dwld  : string;
    tbl_wkc_dependency_NOT_Dwld      : string;
    tbl_material_sup_detail_NOT_Dwld : string;
    tbl_material_sup_header_NOT_Dwld : string;
    tbl_wkc_group_NOT_Dwld           : string;
    tbl_wkc_Category_NOT_Dwld        : string;
    tbl_CategoryDatesInfo_NOT_Dwld   : string;
    tbl_wkc_Penalties_NOT_Dwld       : string;
    tbl_LearningCurve_NOT_Dwld       : string;
    SetLimiDateUsingCapacity         : string;
    SetLimiDateUsingSecureNumDays    : string;


    Saved_HtmlRowNum : string;
    Saved_ShowBinCaption : string;
    Saved_ShowBinCaptionBinReport : string;
    Saved_ShowCriteria : string;
    Saved_ReportComment1 : string;
    Saved_PagePerResource : string;
    Saved_IncDowntime : string;
    Saved_ShowUnschedJobs : string;
    Saved_FontBinCaption : string;
    Saved_FontBinCapSize : string;
    Saved_FontBinCapStyle : string;
    Saved_FontBinCapColor : string;
    Saved_FontBinCapChar : string;
    Saved_FontCriteria : string;
    Saved_FontCriteriaSize : string;
    Saved_FontCriteriaStyle : string;
    Saved_FontCriteriaColor : string;
    Saved_FontCriteriaChar : string;
    Saved_FontComment : string;
    Saved_FontCommentSize : string;
    Saved_FontCommentStyle : string;
    Saved_FontCommentColor : string;
    Saved_FontCommentChar : string;
    Saved_FontColTitles : string;
    Saved_FontColTitleSize : string;
    Saved_FontColTitleStyle : string;
    Saved_FontColTitleColor : string;
    Saved_FontColTitleChar : string;
    Saved_FontDataLine : string;
    Saved_FontDataLineSize : string;
    Saved_FontDataLineStyle : string;
    Saved_FontDataLineColor : string;
    Saved_FontDataLineChar : string;
    Saved_HtmlColorBack : string;
    Saved_HtmlColorTabTitle : string;
    Saved_HtmlColorTabEven : string;
    Saved_HtmlColorTabOdd : string;
    Saved_ExcelTitle : string;
    Saved_ExcelTitleBinReport : string;
    Saved_SMTP_server : string;
    Saved_PORT : string;
    Saved_LOGINWITHAUTHENTICATION : string;
    Saved_TLS_SSL : string;

    Saved_GroupingFields : string;
    Saved_JumpingFields : string;
    Saved_ShowGroups : string;
    Saved_ShowResources : string;

    Saved_SplitByDateTimeNumOfDec : string;
    Saved_SplitByDateTimeRoundCrit : string;
    Saved_SplitByDateTimeReJoinBinJob : string;

    Saved_SplitFromPointNumOfDec : string;
    Saved_SplitFromPointRoundCrit : string;
    Saved_SplitFromPointOnPreDefTime : string;
    Saved_SplitFromPointPreDefTime : string;
    Saved_NumOfDecJobQtyOnStatusBar : string;
    Saved_Field1BinColReportStatic : string;
    Saved_Field2BinColReportStatic : string;
    Saved_Field3BinColReportStatic : string;
    Saved_Field4BinColReportStatic : string;
    Saved_Field5BinColReportStatic : string;
    Saved_Field6BinColReportStatic : string;
    Saved_Field7BinColReportStatic : string;
    Saved_Field8BinColReportStatic : string;
    Saved_Field9BinColReportStatic : string;
    Saved_Field10BinColReportStatic : string;
    Saved_Concatenation : string;
    Saved_Separator : string;
    Saved_HeadingConcatination : string;
    Saved_HeadingSeparator : string;
    Saved_ShowColumnCaptionsReport : string;
    Saved_ShowColumnCaptionsBinReport : string;
    Saved_ShowTotalReport : string;
    Saved_SelectedAtibute : string;
    Saved_MachineReportPeriodTitle : string;
    Saved_MachineReportPeriod : string;
    Saved_MachineReportPeriodFrom : string;
    Saved_MachineReportPeriodNum : string;
    Saved_MachineReportDaysMinusDoday : string;
    Saved_MachineReportShowFromToHeader : string;
    Saved_MachineReportFileNameAutoOperation : string;
    Saved_SetLimiDateUsingCapacity : string;
    Saved_SetLimiDateUsingSecureNumDays : string;
    Saved_SuggestedTextTabJobSequence : string;
    FontSize : Integer;

    // Log Information
    LogTimes : TStringList;
    Time_TotalTimeOpenMqm : double; // can be set in mqm.dpr
    Time_IssueMaterial : double;
    Time_PropertyRules : double;
    Time_LoadJobsproperties : double;
    Time_insertTheTuplesToProductionTables : double;
    Time_BigSql : double;
    Time_ToTal_Blockes : double;
    Time_searchInListLinear : double;
    Time_FULLITEMKEYDECODER_TOOL : double;
    Time_Fill_PRODUCT_SqlStart, Time_Fill_Tool_SqlStart : double;
    Time_fillADWithRelationToList : double;
    Time_FillGeneric : double;
    Time_For_Hgr : double;
    Time_For_Prodreq : double;
    Time_For_Article : double;
    Time_For_Material : double;
    Time_For_Reqconn : double;
    Time_For_StepTimes : double;
    Time_For_fillUnique_nonUniqueWorkCenterProcesses : double;
    Time_For_ifNeededAddToStepIdListForProgressList_PO : double;
    Time_For_ifNeededAddWorkCenterAndOperationToList : double;
    Time_For_getTimeTypeCode : double;
    Time_For_progress : double;
    Time_For_steps : double;
    Time_For_Batch_Size : double;
    Time_For_properties : double;
    Time_For_Additional_Data : double;
    Time_For_BuildAvailabilityStruct : double;
    Time_for_insertIntoBALANCE_HEADER_List : double;
    Time_for_operationAfter_Big_SQL : double;
    // operationAfter_BigSQL sub-timings
    Time_For_DeleteOldProdOrderGrp              : double;
    Time_For_LoadIntoStockDetails               : double;
    Time_For_PrepareProductionOrderStepQtyPct   : double;
    Time_For_fillProductsToList_2nd             : double;
    Time_For_checkIfNeedInsertNewWarpProd        : double;
    Time_For_RecalcBatchProductionOrder         : double;
    Time_For_TryToGroupStepTimesRows            : double;
    Time_For_ClearStructMemoryList              : double;
    Time_For_operationAfterBigSQL_cleanup       : double;
    // extra function timing
    Time_For_DownloadCompanyHandling                  : double;
    Time_For_BuildSCHEDULESDOWNLOAD_WARP            : double;
    // PrepareHandledWorkcenterTemplate sub-breakdown
    Time_For_PrepareHandledAttributeWorkCenter        : double;
    Time_For_LoadIntoWORKCENTERANDOPERATTRIBUTES     : double;
    Time_For_fillStructs                              : double;
    // Fill_MATERIAL_DETAIL_SCHEDULE (inside AtLeast_1_Wc_HandledWarp block)
    Time_For_Fill_MATERIAL_DETAIL_SCHEDULE            : double;
    // UNIQUEID helpers (conditional calls)
    Time_For_fillUserGenericGroupTypeUNIQUEID         : double;
    Time_For_fillColorTypeUNIQUEID                    : double;
    // Demand.pas — BuildProductionDemandFile sub-calls
    Time_For_BuildHandledProductionDemandTemplatesStr : double;
    Time_For_PrepareProdSchedProgress                 : double;
    Time_For_DeleteAllNotRelevantDemands              : double;
    Time_For_BuildHandledWcStr                        : double;
    Time_For_AddNewDemandsToDownloadDemands           : double;
    Time_For_DiscoverDemandsNotRelevantAndDeleteThem  : double;
    Time_For_AddNewDemandsToDownloadDemands2          : double;
    // UMProductionStructService — per-demand accumulators (conditional, once per demand)
    Time_For_UpdatePropertyLinkerToServingGroup       : double;
    Time_For_UpdatePropertyLinker_CurveFamily         : double;
    // Progress.pas — BuildProdSchedProgress + PrepareProdSchedProgress sub-calls
    Time_For_BuildProdSchedProgress                   : double;
    Time_For_BuildHandledProgressTemplatesList        : double;
    Time_For_DeleteAllNotRelevantProgresses           : double;
    Time_For_AddToSchedulesDownloadProgress           : double;
    // Thread wait times — idle time blocked at each .Wait call (0 = thread finished before wait; >0 = bottleneck)
    Time_For_Wait_DeleteProgress             : double;  // Demand: wait for DeleteAllNotRelevantProgresses thread
    Time_For_Wait_SetQryTblCompar            : double;  // UMProdMemory: WaitForAll(task1,task2,task3)
    Time_For_Wait_ComparPreload              : double;  // UMProdMemory: WaitAndAssignComparPreload
    Time_For_Wait_BuildProdSchedProgress     : double;  // UMProductionStruct: wait for ProgTask

    Time_for_CheckTableColumns : double;
    Time_for_fill_Production_Order_Grp_No_list : double;
    Time_for_fillProductionDemandTemplateStruct : double;
    Time_for_PrepareHandledProductionDemandTemplate : double;
    Time_For_BuildProductionDemandFile : double;
    Time_For_fillArticleTypeToList : double;
    Time_For_PrepareHandledWorkcenterTemplate : double;
    Time_For_fillPropertyStruct : double;
    Time_for_makeRelevantOperationsForColumns : double;
    Time_for_fillItemTypeLogicalWarehouseStruct : double;
    Time_For_Build_AD_SelectedColums : double;
    Time_For_fillUserGenericGroupType : double;
    Time_For_fillColorType : double;
    Time_For_fillItemTypesList : double;
    Time_for_fillLogicalWarehousesToList : double;
    Time_For_LoadProjectNumbers : double;
    Time_For_fillAlternativeUM : double;
    Time_for_fillAlternativeWarehouseStruct : double;
    Time_For_fillResTableToList : double;
    Time_for_fillRoutingStepTimeTypeToList : double;
    Time_for_fillProductsToList : double;
    Time_For_fillOperationsToList : double;
    Time_for_fillSalesOrderToList : double;
    Time_For_fillPurchaseOrderToList : double;
    Time_For_Fill_Products_properties : double;
    Time_for_fillItemTypeTemplatesToList : double;
    Time_for_fillProductionDemandCountersToList : double;
    Time_For_fillProductionProgressTemplateStruct : double;
    Time_For_ToTal_Download_Time : double;

    Time_UpdatePR, Time_DelPR, Time_InsertPR,
    Time_UpdatePH, Time_DelPH, Time_InsertPH,
    Time_UpdatePD, Time_DelPD, Time_InsertPD,
    Time_WriteLogLineToDBFromServer,
    Time_UpdatePS, Time_DelPS,
    Time_UpdateMS, Time_DelMS,
    Time_UpdatePP, Time_DelPP, Time_InsertPP,
    Time_UpdatePI, Time_DelPI, Time_InsertPI,
    Time_UpdateEC, Time_DelEC, Time_InsertEC,
    Time_UpdateIC, Time_DelIC, Time_InsertIC,
    Time_UpdateSB, Time_DelSB, Time_InsertSB,
    Time_UpdateSP, Time_DelSP, Time_InsertSP,
    Time_UpdateST, Time_DelST, Time_InsertST,
    Time_UpdateMT, Time_DelMT, Time_InsertMT,
    Time_UpdatePA, Time_DelPA, Time_InsertPA : double;

    // Untimed gaps inside UpdateStatusRequests
    Time_ClearChangeReqWcTables   : double;
    Time_UpdCodeReset              : double;  // UPDATE SET updCode='0' all rows
    Time_UpdCodeSet                : double;  // batched UPDATE SET updCode='1' IN (...)
    Time_DeletePS_Orphans          : double;  // DELETE PROD_SCHED orphans + commit
    Time_DeletePSMCM_Orphans       : double;  // DELETE PROD_SCHED_MCM orphans + commit
    Time_SrvQryPS_Open             : double;  // SELECT * FROM PROD_SCHED
    Time_SrvQryPSMCM_Open          : double;  // SELECT * FROM PROD_SCHED_MCM
    Time_InsertChangeReqToTable    : double;  // per-request call inside main loop

    // SetQryTblCompar per-table timings (Open+Load and Sort)
    Time_Compar_PR, Time_Compar_PH, Time_Compar_PD, Time_Compar_PP,
    Time_Compar_PI, Time_Compar_EC, Time_Compar_IC, Time_Compar_SB,
    Time_Compar_SP, Time_Compar_ST, Time_Compar_MT, Time_Compar_PA : double;
    Time_ComparSort_PR, Time_ComparSort_PH, Time_ComparSort_PD, Time_ComparSort_PP,
    Time_ComparSort_PI, Time_ComparSort_EC, Time_ComparSort_IC, Time_ComparSort_SB,
    Time_ComparSort_SP, Time_ComparSort_ST, Time_ComparSort_MT, Time_ComparSort_PA : double;
    Count_Compar_PR, Count_Compar_PH, Count_Compar_PD, Count_Compar_PP,
    Count_Compar_PI, Count_Compar_EC, Count_Compar_IC, Count_Compar_SB,
    Count_Compar_SP, Count_Compar_ST, Count_Compar_MT, Count_Compar_PA : Integer;

    // DB operation counts (populated during InsertReqListToDataBase)
    Count_ReqChanged: integer;
    Count_DelPR, Count_UpdatePR, Count_InsertPR,
    Count_DelPH, Count_UpdatePH, Count_InsertPH,
    Count_DelPD, Count_UpdatePD, Count_InsertPD,
    Count_DelPS, Count_UpdatePS,
    Count_DelPP, Count_UpdatePP, Count_InsertPP,
    Count_DelPI, Count_UpdatePI, Count_InsertPI,
    Count_DelEC, Count_UpdateEC, Count_InsertEC,
    Count_DelIC, Count_UpdateIC, Count_InsertIC,
    Count_DelSB, Count_UpdateSB, Count_InsertSB,
    Count_DelSP, Count_UpdateSP, Count_InsertSP,
    Count_DelST, Count_UpdateST, Count_InsertST,
    Count_DelMT, Count_UpdateMT, Count_InsertMT,
    Count_DelPA, Count_UpdatePA, Count_InsertPA: integer;

    MCMasMQM : integer;

  end;

  TLocAppGlobals = record
    // Environment
    AppDir    : string;
    AppDrive  : char;
    ImgDir    : string;
    LangDir   : string;
    IsDevelop : boolean;
  end;

  TDBAppSettings = record
    DisableCapRes: boolean;

    // tab filterings and sorting
    TabResSort:    boolean;
    TabKeepSort:   boolean;
    TabFilterRead: boolean;
    TabWorkcenter: boolean;
    TabNoTimings:  boolean;
    TabNoCompat:   boolean;

    FixColCompVis:   boolean;
    FixColStatVis:   boolean;
    FixColDelDVis:   boolean;
    FixColMatDVis:   boolean;
    FixColLowDVis:   boolean;
    FixColHigDVis:   boolean;
    FixColOvlpVis:   boolean;
    FixColDatesVis:  boolean;
    FixColJobMsgVis: boolean;

    ChkDelDate:    boolean;
    ChkMaterials:  boolean;
    ChkPrevStpQty: boolean;
    ChkAddRes:     boolean;
    ChkLowStart:   boolean;
    ChkHighEnd:    boolean;
    ChkLinkOvlp:   boolean;

    BinMultiLineTab : boolean;
    ShowInBinOnMove:    boolean;
    ForceOverlap : CScFrcOverlap;
  //  ShowContinueGroupLinesInBin: string; // not in use anymore
    ShowBatchGroupLinesInBin: boolean;   // not in use anymore
    JobMoveWitoutConfirmation : boolean;
    WarningWhenMaxNumCompChanged : boolean;
    ReportTimeFormat : string;
    ShowBinToolBar: boolean;
    ShowRowInBin:   boolean;

    // job schedule by sequencing
    CreateNewBinTabForCompatibles : CBCreateNewBibTabForCompatible;
    ShowCompatibleInExistingBINS  : SCShowCompatibleInExistingBINS;
    ShowScheduledJobsOfSelectedResource : SCShowScheduledJobsOfSelectedResource;
    SuggestedTextTabJobSequence   : string;

    RefreshBinByButton : boolean;
    EnterLinesToMatLog : boolean;
    GanttMultiLineTab : boolean;
    CalDayFormat : string;
    ShowBinPropColors : boolean;
    GenericPlanExist  : boolean;

    CapResStartEnd : Boolean;
  end;

  TDBAppGlobals = record

    // Environment
    EnvDescr       : string;   // description of the running environment
    Customer       : string;
    MqmVersion     : string;

    // General Date format string
    MonthBefore    : integer;    // Month before (Table VIPD on AS)
    StDateForPlan  : TDateTime;  // Start Date for Plan
    EndDateForPlan : TDateTime;  // End Date for Plan

    // Setting for Workstation
    Language       : string;
    MCM_App        : boolean;
    License_BOTH_MQM_MCM : boolean;
    License_MQM : boolean;
    License_MCM : boolean;
    Mcm_App_Resched_From_Mqm : boolean;

    // Last Setting for Plan
    CurrTScale  : integer;
    CurrDtTime  : TDateTime;
    ShowCal     : integer; // 0=no   1=yes
    CurrRscSort : integer; // Code Value for Sort Resources
    ShowZoom    : integer;

    // Setting for Select Resources Form
    SelRscOrderType : string;
    SelRscOrderItem : string;

    // Form Plan
    WdwPlanLeft   : integer;
    WdwPlanTop    : integer;
    WdwPlanWidth  : integer;
    WdwPlanHeight : integer;
    WdwPlanState  : boolean;

    // Form Bin
    WdwBinDock      : integer; // 0=Undocked  1=Right Dock    -1=Bottom Dock
    WdwBinLeft      : integer;
    WdwBinTop       : integer;
    WdwBinWidth     : integer;
    WdwBinHeight    : integer;
    WdwBinState     : boolean;
    WdwBinSplitterH : integer;
    BinCfg_Main     : string;
    BinCfg_SrcByNum : string;
    BinCfg_SrcByOrd : string;
    BinCfg_SrcByIss : string;
    BinCfg_SrcByArt : string;
    BinCfg_SrcByTD  : string;

    //Bin Icon Toolbar
    ToolBarDock      : integer; // 0=Undocked  1=Right Dock    -1=Bottom Dock
    ToolBarLeft      : integer;
    ToolBarTop       : integer;
    ToolBarWidth     : integer;
    ToolBarHeight    : integer;
    ToolBarState     : boolean;

    // Form Move
    WdwMoveLeft     : integer;
    WdwMoveTop      : integer;
    WdwMoveDetails  : boolean;

    // color arrays

    JobToJobCompColor    : TColorArray;
    SavedJobToJobCompColor    : TColorArray;

    JobToCapCompColor    : TColorArray;
    SavedJobToCapCompColor    : TColorArray;

    JobCapToRscCompColor : TColorArray;
    SavedJobCapToRscCompColor : TColorArray;

    JobStatusColor       : TColorArray;
    SavedJobStatusColor  : TColorArray;

    JobDateWarningColor  : TColorArray;
    SavedJobDateWarningColor  : TColorArray;

    JobMatWarningColor   : TColorArray;
    SavedJobMatWarningColor  : TColorArray;

    ResColors            : TColorArray;
    SavedResColors       : TColorArray;

    CapResColors         : TColorArray;
    SavedCapResColors    : TColorArray;

    ShowBinPropArry : array [0..59] of TPropID;

    //Application preferences

    m_RefreshProcessStarted, m_SaveProcessStartedAndNotCompleted  , m_Network_Stoped_Dur_Save, m_ClientConnectionCriticalRepaired : boolean;
    UnscheduleJobsOnStart : string;
    CheckStepSeq : boolean;
    CenterStartOnMove : boolean;
    WarnOnMoveFinal : boolean;
    WhenMoveShowErrorsIfExist : boolean;
    DefSchedType : integer;
    ConfLevels   : integer;
    MoveOption   : integer;
    LastUpdatNr  : Integer;              // Last Updated Number from Database.
    LastUpdatCapResNr  : Integer;

    Change_AutoRunDefinition : boolean;
    MAINPLAN_Ignore_Save_Event : boolean;
    MAINPLAN_Ignore_Pain_When_refresh : boolean;
    OrganizeJobsAfterDoday : boolean;
    ActAutoSched : string;
 //   LimitedJobsInGroup : Integer;

    NumOfMatFamiliyInGroup : integer;
    MinNumJobsInGroup : Integer;
    MaxNumJobsInGroup : Integer;
    MinQtyInGroup     : currency;
    MaxQtyInGFroup     : currency;
    ConvertToRscUomInGroup : boolean;
    ResUmInGroup : string;
    GapInDaysForLatestEndGroup : Integer;
    StockDetailsHandled : boolean;
    ShowColorJobMode :  TDisplayBarColor;
    ShowColorJobModeActivTab : TDisplayBarColor;
    LastPropColorInUseJobMode : string;
    MCMSlotDisplay : Integer;
    MCMCustomQty : Boolean;
    MCMCustomProp : string;
    MCMCustomPropSymbol : string;
    IsWarpHandled : boolean;
    WarpCngClientUpdate : boolean;
    WarpOnlyCngClientUpdate : boolean;
    BalanceOnlyClientUpdate : boolean;
  end;

{  TNowGlobalSettings = record
    FileNowMqmPath : string;

    Server     : string;
    MainDBPath : string;
    MainDBName : string;
    Alias      : string;
    PCAlias    : string;

    CompanyCode: string;
    CompanyInUsed : string;
    GroupCode  : string;
    EnvironmentCode : string;
    GetDownloadFrom : string;

    downloadTo: String;

    IBUserName: String;
    IBPassword: String;
    IBDataSource: String;

    DB2InstanceName: String;
    DB2UserName: String;
    DB2Password: String;
    DB2DataSource: String;
    DB2SrvIP: String;

    downloadFrom: String;

    NOWDB2InstanceName: String;
    NOWDB2UserName: String;
    NOWDB2Password: String;
    NOWDB2DataSource: String;
    NOWDB2SrvIP: String;

    NOWOracleTNSName: String;
    NOWOracleUserName: String;
    NOWOraclePassword: String;

    FormulaForMaterialAvailability : String;
    DownloadCalendarData: String;
    LimitNumbersOfThread : string;
    MuduleServed : string;
  end;  }

  Function Encrypt(const S :WideString) : String;
  Function Decrypt(const S :WideString) : String;

  function  SendEmail(SendMailParam : TSendMailParm) : boolean;
  procedure SavePropBin;
  procedure GlobLoadIniValues;
  procedure GlobLoadIniValuesNow;
  procedure GlobLoadIniValuesFromDB;
  procedure GlobSaveIniValues;
  procedure GlobSaveIniReportValues;
  procedure GlobLoadLocValues;
  procedure GlobLoadDbValues(ProgBar: TMqmProgBar; Status: TStaticText);
  procedure GlobLoadSettingsValues;
  procedure GlobSaveValues;
  procedure GlobSaveSettingsValues;
  procedure GlobSaveConfig;
  procedure GlobInitPosForm(value : integer);
  Procedure SaveLanguage;

  function GetGlobValueForProperty(pID: TPropID; mtx: TCompatMatrix): TPropRes;
  function GetGlobRuleRtoOfForProperty(pID: TPropID; prod: string; mtx: TCompatMatrix): TCompRules;
  function GetGlobRuleOtoOfForProperty(pID: TPropID; prod: string; mtx: TCompatMatrix): TCompRules;
  function GlobAddProperty(code: string; var val: TPropResRec; ErrList: TStringList): boolean;
  function GlobAddRtoOrule(code: string; var val: TRuleResRec; ErrList: TStringList): boolean;
  function GlobAddOtoOrule(code: string; var val: TRuleResRec; ErrList: TStringList): boolean;

  procedure GlobGetPropMtxs(lst: TList);
  function  GlobGetRulesRtoOMtxs: TList;
  function  GlobGetRulesOtoOMtxs: TList;

  function GetWorkStationForWc(wc: string; isDesc: boolean): string;
  function GetLastUpdatedNumber : Integer;
  function GetLastUpdatedCapResNumber : Integer;
  function IsCalendarLoaded: boolean;
  procedure CheckChangedProperties;
  function GetDateForPlanLine(): TDateTime;
  procedure DeleteRequest(Request : string; Step : integer; SubStep : Integer; Reprocess : Integer);
  procedure AddToListLogLines(LogList : TList; LogOrig : string; Request : string; step : integer; Substep : Integer;
                            ReProcess : integer; OperationOnTable : string; ScheduleInfo : string; Resource : string;
                            StartScheduleDate : TDateTime; EndScheduleDate : TDateTime; qty : double; SchedType : string; Reason : string);
  procedure WriteLogLineToDBFromParamList(LogList : TList; qry: TMqmQuery);

  procedure WriteLogLineToDB(qry: TMqmQuery; LogOrig : string; Request : string; step : integer; Substep : Integer;
                            ReProcess : integer; OperationOnTable : string; ScheduleInfo : string; Resource : string;
                            StartScheduleDate : TDateTime; EndScheduleDate : TDateTime; qty : double; SchedType : string; Reason : string);

  procedure WriteLogLineToDBFromServer(LogOrig : string; Request : string; step : integer; Substep : Integer;
                            ReProcess : integer; OperationOnTable : string; ScheduleInfo : string; Resource : string;
                            StartScheduleDate : TDateTime; EndScheduleDate : TDateTime; qty : double; SchedType : string; Reason : string);
  Procedure DefaultValuesForMenu;

var
  IniAppGlobals: TIniAppGlobals;
  LocAppGlobals: TLocAppGlobals;
  DBAppGlobals:  TDBAppGlobals;
  DBAppSettings: TDBAppSettings;
//  NowGlobalSettings : TNowGlobalSettings;

  s_suicide:     boolean;



const

  ArrLanguages: array [0..4] of string = (
    'English', 'Italian', 'German', 'Spanish', 'French');

  DfltCmpClr: array [0..99] of TDetCmpClr = (
  // Remember to modify the strings for translations in procedure "TranslationExtractionPurpose" of this unit
    (int: clWhite;   brd: $00000000; txt: $00000000; dsc: 'No description'), // 0
    (int: $0058E73E; brd: $00000000; txt: $00000000; dsc: 'No description'), // 1
    (int: $0021C007; brd: $00000000; txt: $00000000; dsc: 'No description'), // 2
    (int: $0017A301; brd: $00000000; txt: $00000000; dsc: 'No description'), // 3
    (int: $00118701; brd: $00000000; txt: $00000000; dsc: 'No description'), // 4
    (int: $00076000; brd: $00000000; txt: $00000000; dsc: 'No description'), // 5
    (int: $00304405; brd: $00000000; txt: $00000000; dsc: 'No description'), // 6
    (int: $003D5111; brd: $00000000; txt: $00000000; dsc: 'No description'), // 7
    (int: $004C5E1F; brd: $00000000; txt: $00000000; dsc: 'No description'), // 8
    (int: $005F702F; brd: $00000000; txt: $00000000; dsc: 'No description'), // 9
    (int: $00687C00; brd: $00000000; txt: $00000000; dsc: 'No description'), // 10
    (int: $00798E00; brd: $00000000; txt: $00000000; dsc: 'No description'), // 11

    (int: $008EA600; brd: $00000000; txt: $00000000; dsc: 'No description'), // 12
    (int: $009FBA00; brd: $00000000; txt: $00000000; dsc: 'No description'), // 13
    (int: $00BAD901; brd: $00000000; txt: $00000000; dsc: 'No description'), // 14

    (int: $00D6F177; brd: $00000000; txt: $00000000; dsc: 'No description'), // 15
    (int: $00E8F984; brd: $00000000; txt: $00000000; dsc: 'No description'), // 16
    (int: $00F1F071; brd: $00000000; txt: $00000000; dsc: 'No description'), // 17
    (int: $00EAE13F; brd: $00000000; txt: $00000000; dsc: 'No description'), // 18
    (int: $00E6D226; brd: $00000000; txt: $00000000; dsc: 'No description'), // 19
    (int: $00E5BD00; brd: $00000000; txt: $00000000; dsc: 'No description'), // 20



    (int: $00E0A600; brd: $00000000; txt: $00000000; dsc: 'No description'), // 21
    (int: $00D78600; brd: $00000000; txt: $00000000; dsc: 'No description'), // 22
    (int: $00DE6400; brd: $00000000; txt: $00000000; dsc: 'No description'), // 23
    (int: $00BD5001; brd: $00000000; txt: $00000000; dsc: 'No description'), // 24
    (int: $00A04000; brd: $00000000; txt: $00000000; dsc: 'No description'), // 25
    (int: $007E3500; brd: $00000000; txt: $00000000; dsc: 'No description'), // 26
    (int: $00752320; brd: $00000000; txt: $00000000; dsc: 'No description'), // 27
    (int: $0075002A; brd: $00000000; txt: $00000000; dsc: 'No description'), // 28
    (int: $00A50345; brd: $00000000; txt: $00000000; dsc: 'No description'), // 29
    (int: $00C61657; brd: $00000000; txt: $00000000; dsc: 'No description'), // 30

    (int: $00E63068; brd: $00000000; txt: $00000000; dsc: 'No description'), // 31
    (int: $00F35277; brd: $00000000; txt: $00000000; dsc: 'No description'), // 32
    (int: $00F3528D; brd: $00000000; txt: $00000000; dsc: 'No description'), // 33
    (int: $00E63281; brd: $00000000; txt: $00000000; dsc: 'No description'), // 34
    (int: $00CA1A73; brd: $00000000; txt: $00000000; dsc: 'No description'), // 35
    (int: $00840A65; brd: $00000000; txt: $00000000; dsc: 'No description'), // 36
    (int: $008C054D; brd: $00000000; txt: $00000000; dsc: 'No description'), // 37
    (int: $006F073E; brd: $00000000; txt: $00000000; dsc: 'No description'), // 38
    (int: $0057083B; brd: $00000000; txt: $00000000; dsc: 'No description'), // 39
    (int: $008F1F60; brd: $00000000; txt: $00000000; dsc: 'No description'), // 40
    (int: $00AB3278; brd: $00000000; txt: $00000000; dsc: 'No description'), // 41
    (int: $00CA5197; brd: $00000000; txt: $00000000; dsc: 'No description'), // 42
    (int: $00E471BD; brd: $00000000; txt: $00000000; dsc: 'No description'), // 43
    (int: $00FC9DEA; brd: $00000000; txt: $00000000; dsc: 'No description'), // 44
    (int: $00E390FF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 45
    (int: $00D87BFF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 46
    (int: $00D568FF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 47
    (int: $00C540FF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 48
    (int: $00A414EA; brd: $00000000; txt: $00000000; dsc: 'No description'), // 49
    (int: $008600CD; brd: $00000000; txt: $00000000; dsc: 'No description'), // 50
    (int: $007501B2; brd: $00000000; txt: $00000000; dsc: 'No description'), // 51
    (int: $004E009A; brd: $00000000; txt: $00000000; dsc: 'No description'), // 52
    (int: $00310084; brd: $00000000; txt: $00000000; dsc: 'No description'), // 53


    (int: $00001B42; brd: $00000000; txt: $00000000; dsc: 'No description'), // 54
    (int: $000B1D37; brd: $00000000; txt: $00000000; dsc: 'No description'), // 55
    (int: $001B2D41; brd: $00000000; txt: $00000000; dsc: 'No description'), // 56

    (int: $00253A4E; brd: $00000000; txt: $00000000; dsc: 'No description'), // 57
    (int: $00354E62; brd: $00000000; txt: $00000000; dsc: 'No description'), // 58
    (int: $004A6B7E; brd: $00000000; txt: $00000000; dsc: 'No description'), // 59
    (int: $006A8191; brd: $00000000; txt: $00000000; dsc: 'No description'), // 60
    (int: $00556979; brd: $00000000; txt: $00000000; dsc: 'No description'), // 61
    (int: $00435362; brd: $00000000; txt: $00000000; dsc: 'No description'), // 62
    (int: $00354350; brd: $00000000; txt: $00000000; dsc: 'No description'), // 63
    (int: $002A3541; brd: $00000000; txt: $00000000; dsc: 'No description'), // 64
    (int: $001D252F; brd: $00000000; txt: $00000000; dsc: 'No description'), // 65
    (int: $00171B21; brd: $00000000; txt: $00000000; dsc: 'No description'), // 66
    (int: $00171B21; brd: $00000000; txt: $00000000; dsc: 'No description'), // 67
    (int: $002A2C2D; brd: $00000000; txt: $00000000; dsc: 'No description'), // 68
    (int: $00424445; brd: $00000000; txt: $00000000; dsc: 'No description'), // 69
    (int: $005A5B5B; brd: $00000000; txt: $00000000; dsc: 'No description'), // 70

    (int: $00717171; brd: $00000000; txt: $00000000; dsc: 'No description'), // 71
    (int: $00979797; brd: $00000000; txt: $00000000; dsc: 'No description'), // 72
    (int: $00B2B2B2; brd: $00000000; txt: $00000000; dsc: 'No description'), // 73
    (int: $00D6D2CD; brd: $00000000; txt: $00000000; dsc: 'No description'), // 74
    (int: $00052656; brd: $00000000; txt: $00000000; dsc: 'No description'), // 75
    (int: $00063565; brd: $00000000; txt: $00000000; dsc: 'No description'), // 76
    (int: $001A467D; brd: $00000000; txt: $00000000; dsc: 'No description'), // 77
    (int: $002B5C94; brd: $00000000; txt: $00000000; dsc: 'No description'), // 78
    (int: $003B72AB; brd: $00000000; txt: $00000000; dsc: 'No description'), // 79
    (int: $005491C8; brd: $00000000; txt: $00000000; dsc: 'No description'), // 80
    (int: $0066C0EF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 81
    (int: $0091EBFF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 82
    (int: $0000F3FF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 83
    (int: $0000DEFF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 84

    (int: $0000CFFF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 85
    (int: $0000BFFF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 86
    (int: $0000ABFF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 87
    (int: $00009FFF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 88
    (int: $000090FF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 89
    (int: $000079FF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 90
    (int: $000C60F3; brd: $00000000; txt: $00000000; dsc: 'No description'), // 91
    (int: $001C4EE8; brd: $00000000; txt: $00000000; dsc: 'No description'), // 92
    (int: $000025BC; brd: $00000000; txt: $00000000; dsc: 'No description'), // 93
    (int: $000022AB; brd: $00000000; txt: $00000000; dsc: 'No description'), // 94
    (int: $0000008D; brd: $00000000; txt: $00000000; dsc: 'No description'), // 95
    (int: $000D00AA; brd: $00000000; txt: $00000000; dsc: 'No description'), // 96
    (int: $000F00BF; brd: $00000000; txt: $00000000; dsc: 'No description'), // 97
    (int: $001100D9; brd: $00000000; txt: $00000000; dsc: 'No description'), // 98
        // CLRED
    (int: $001400FF;     brd: $00000000; txt: $00000000; dsc: 'No description')  // 99
  );

  DfltJobStatusClr: array [0..12] of TDetCmpClr = (
  // Remember to modify the strings for translations in procedure "TranslationExtractionPurpose" of this unit
    (int: $00FFDDDD; brd: $00000000; txt: ClBlack; dsc: 'Initial schedule'),
    (int: $00FF00AA; brd: $00000000; txt: ClBlack; dsc: 'Confirmation level 1'),
    (int: $00FF00AA; brd: $00000000; txt: ClBlack; dsc: 'Confirmation level 2'),
    (int: $00FF00AA; brd: $00000000; txt: ClBlack; dsc: 'Confirmation level 3'),
    (int: $00FF00AA; brd: $00000000; txt: ClBlack; dsc: 'Confirmation level 4'),
    (int: $00FF00AA; brd: $00000000; txt: ClBlack; dsc: 'Confirmation level 5'),
  //  (int: $00EE0000; brd: $00000000; txt: ClWhite; dsc: 'Final scheduled'),
    (int: Cl_STNDRD_LIGHT_BLUE; brd: $00000000; txt: ClBlack; dsc: 'Final scheduled'),
    (int: $0033DD33; brd: $00000000; txt: ClBlack; dsc: 'Progressed'),
    (int: $00007700; brd: $00000000; txt: ClBlack; dsc: 'Progressed as final'),
    (int: $00007700; brd: $00000000; txt: ClBlack; dsc: 'Closed'),
    (int: $00D6F177; brd: $00000000; txt: ClBlack; dsc: 'Ignored Initial Progress'),
    (int: $00D6F177; brd: $00000000; txt: ClBlack; dsc: 'Ignored generic Progress'),
    (int: $00D6F177; brd: $00000000; txt: ClBlack; dsc: 'Ignored Final Progress')
  );

  DfltJobDateWrnClr: array [0..3] of TDetCmpClr = (
  // Remember to modify the strings for translations in procedure "TranslationExtractionPurpose" of this unit
    (int: $000000FF; brd: $00000000; txt: ClBlack; dsc: 'After delivery date' ), // 1
    (int: $000000FF; brd: $00000000; txt: ClBlack; dsc: 'After latest end'), // 3
    (int: $000088FF; brd: $00000000; txt: ClBlack; dsc: 'Before earliest start'), // 4
    (int: $00800080;  brd: $00000000; txt: ClBlack; dsc: 'Before approval date') // 4
  );

  DfltJobMatWrnClr: array [0..3] of TDetCmpClr = (
  // Remember to modify the strings for translations in procedure "TranslationExtractionPurpose" of this unit
    (int: $00FFFFFF; brd: $00000000; txt: ClBlack; dsc: 'Steps overlapping'), // 7 Overlaps
    (int: $0000FFFF; brd: $00000000; txt: ClBlack; dsc: 'Materials warning'), // 2
//    (int: $0011CCEE; brd: $00000000; txt: ClBlack; dsc: 'Materials warning'), // 2
    (int: $0000AAFF; brd: $00000000; txt: ClBlack; dsc: 'Additional resources warning'), // 2
    (int: $000000FF; brd: $00000000; txt: ClBlack; dsc: 'Materials and additional resources warning')  // 9 Overlaps
  );

  DfltRscClr: array [0..7] of TDetCmpClr = (
  // Remember to modify the strings for translations in procedure "TranslationExtractionPurpose" of this unit
    (int: Cl_STNDRD_LIGHT_BLUE; brd: Cl_STNDRD_LIGHT_BLUE; txt: clWhite; dsc: 'Continuous'), // 0  Continues
    (int: 16767411; brd: clBlack; txt: clBlack; dsc: 'Continuous (read only)'), // 1  Continues (Read only)
    (int: $00DD7777; brd: clBlack; txt: clBlack; dsc: 'Sub resource Continuous'), // 2  Sub resource Continues
    (int: $00DD7777; brd: clBlack; txt: clBlack; dsc: 'Sub resource Continuous (read only)'), // 3  Sub resource Continues(Read only)
    (int: $0099FF99; brd: clBlack; txt: clBlack; dsc: 'Batch'), // 4  Batch
    (int: $0099FF99; brd: clBlack; txt: clBlack; dsc: 'Batch (read Only)'),  // 5  Batch (Read Only)
    (int: $0066CC66; brd: clBlack; txt: clBlack; dsc: 'Sub resource Batch'), // 6  Batch
    (int: $0066CC66; brd: clBlack; txt: clBlack; dsc: 'Sub resource Batch (read Only)')  // 7  Batch (Read Only)
  );

  PopUpMenu: array[1..95] of TPopUpCustomMenu = (
    (Code: 'Resource'; Caption: 'MIWkcDet';             Visible: True),
    (Code: 'Resource'; Caption: 'MIResDetails';         Visible: True),
    (Code: 'Resource'; Caption: 'MICompatInBin';        Visible: True),
    (Code: 'Resource'; Caption: 'MIClearCompInBin';     Visible: True),
    (Code: 'Resource'; Caption: 'MIEditCal';            Visible: True),
    (Code: 'Resource'; Caption: 'MIEditCapacity';       Visible: True),
    (Code: 'Resource'; Caption: 'MICapResDynamic';      Visible: True),
    (Code: 'Resource'; Caption: 'MiShowScheduledJobs';  Visible: True),
    (Code: 'Resource'; Caption: 'MISubRes';             Visible: True),

    (Code: 'ActArea'; Caption: 'MIApaCrtCapRes';            Visible: True),
    (Code: 'ActArea'; Caption: 'MIApaCrtDownTime';          Visible: True),
    (Code: 'ActArea'; Caption: 'MISortresourcesby';         Visible: True),
    (Code: 'ActArea'; Caption: 'MiShowBarColorCreteriaTab'; Visible: True),
    (Code: 'ActArea'; Caption: 'MICngResSec';               Visible: True),
    (Code: 'ActArea'; Caption: 'MIApaEditPlan';             Visible: True),
    (Code: 'ActArea'; Caption: 'MIApaDelPlan';              Visible: True),
    (Code: 'ActArea'; Caption: 'MiUpdateTabUsingBinResource';   Visible: True),
    (Code: 'ActArea'; Caption: 'MiCreateNewTabFromBinResources';Visible: True),
    (Code: 'ActArea'; Caption: 'MiScheduleJobBySequence';       Visible: True),
    (Code: 'ActArea'; Caption: 'MiShowScheduledJobsFromPoint';  Visible: True),
    (Code: 'ActArea'; Caption: 'MiSetjobslimitdates';           Visible: True),
    (Code: 'ActArea'; Caption: 'MiSplitBySelectedDate';         Visible: True),
    (Code: 'ActArea'; Caption: 'MICompacAllScheduledFromThisPointOnThisResource'; Visible: True),
    (Code: 'ActArea'; Caption: 'MICompacAllScheduledFromThisPointForAllResource'; Visible: True),

    (Code: 'Group'; Caption: 'MISetNextLevelGrp'; Visible: True),
    (Code: 'Group'; Caption: 'MISetIniFinGrp';    Visible: True),
    (Code: 'Group'; Caption: 'MISetLevelToGrp';   Visible: True),
    (Code: 'Group'; Caption: 'MIgrpToBin';        Visible: True),
    (Code: 'Group'; Caption: 'MIGrpDetails';      Visible: True),
    (Code: 'Group'; Caption: 'MiSplitRemainGroup';Visible: True),
    (Code: 'Group'; Caption: 'MiSeedGrpChange';   Visible: True),
    (Code: 'Group'; Caption: 'MISplitGroup';      Visible: True),
    (Code: 'Group'; Caption: 'MiLearningCurveGrpChange'; Visible: true),
    (Code: 'Group'; Caption: 'MIIgnoreprogressGrp'; Visible: false),

    (Code: 'Job'; Caption: 'MISetNextLevel';    Visible: True),
    (Code: 'Job'; Caption: 'MISetIniFin';       Visible: True),
    (Code: 'Job'; Caption: 'MISetLevelTo';      Visible: True),
    (Code: 'Job'; Caption: 'MiSplitFromThisPointBehaviour'; Visible: True),
    (Code: 'Job'; Caption: 'MiSplitHere';       Visible: True),
    (Code: 'Job'; Caption: 'MIJobHandle';       Visible: True),
    (Code: 'Job'; Caption: 'MIStepDetails';     Visible: True),
    (Code: 'Job'; Caption: 'MIShowrequierments';Visible: True),
    (Code: 'Job'; Caption: 'MIStockDetails';    Visible: True),
    (Code: 'Job'; Caption: 'MIUnschedule';      Visible: True),
    (Code: 'Job'; Caption: 'MISearchProdReqby'; Visible: True),
    (Code: 'Job'; Caption: 'MIIgnoreprogress';  Visible: True),
    (Code: 'Job'; Caption: 'MIFindjobinbin';    Visible: True),
    (Code: 'Job'; Caption: 'MiSplitRemainJob';  Visible: True),
    (Code: 'Job'; Caption: 'MiSpeedChange';     Visible: false),
    (Code: 'Job'; Caption: 'MiLearningCurveChange'; Visible: true),

    (Code: 'Bin'; Caption: 'MIMoveOnPlan';            Visible: True),
    (Code: 'Bin'; Caption: 'MINextLevel';             Visible: True),
    (Code: 'Bin'; Caption: 'MISetFin';                Visible: True),
    (Code: 'Bin'; Caption: 'MISetConfirmLevelTo';     Visible: True),
    (Code: 'Bin'; Caption: 'MiRemoveJobsCalculatedLimitDates'; Visible: True),
    (Code: 'Bin'; Caption: 'MIUnschedule';            Visible: True),
    (Code: 'Bin'; Caption: 'MiLastOnGantt';           Visible: false),
    (Code: 'Bin'; Caption: 'MIJobHandling';           Visible: True),
    (Code: 'Bin'; Caption: 'MIShowOnPlan';            Visible: True),
    (Code: 'Bin'; Caption: 'MIShowrequirements';      Visible: True),
    (Code: 'Bin'; Caption: 'MIStockDetails';          Visible: true),
    (Code: 'Bin'; Caption: 'MIAutoSched';             Visible: True),
    (Code: 'Bin'; Caption: 'MiRepositionJobsToRealMachines';   Visible: false), // mcm
    (Code: 'Bin'; Caption: 'MiJobDetails';            Visible: True),
    (Code: 'Bin'; Caption: 'MICopy';                  Visible: True),
    (Code: 'Bin'; Caption: 'MINewGroup';              Visible: True),
    (Code: 'Bin'; Caption: 'MIAutoUnGroupingSelection'; Visible: True),
    (Code: 'Bin'; Caption: 'MIAutoGroupingSelection';   Visible: True),
    (Code: 'Bin'; Caption: 'MIAddToGroup';            Visible: True),
    (Code: 'Bin'; Caption: 'MIModiGrp';               Visible: True),
    (Code: 'Bin'; Caption: 'MiSearchBySelectedCellInGroupedBy';Visible: True),
    (Code: 'Bin'; Caption: 'MiSearchBySelectedCell';  Visible: True),
    (Code: 'Bin'; Caption: 'MINewTabMain';            Visible: True),
    (Code: 'Bin'; Caption: 'MiDrillDown';             Visible: True),
    (Code: 'Bin'; Caption: 'MIBinTab';                Visible: True),
    (Code: 'Bin'; Caption: 'MIShowtabtotals';         Visible: True),
    (Code: 'Bin'; Caption: 'MIWCenterHandle';         Visible: True),
    (Code: 'Bin'; Caption: 'MIClearAllMsgHost';       Visible: false),
    (Code: 'Bin'; Caption: 'MIClearJobHostMsg';       Visible: false),
    (Code: 'Bin'; Caption: 'MIAlterWorkCenterAndSplitAccordingToMcm';Visible: True),
    (Code: 'Bin'; Caption: 'MISplitJobsByStepNumberOfMachines'; Visible: True),
    (Code: 'Bin'; Caption: 'MIJoinAll';               Visible: True),
    (Code: 'Bin'; Caption: 'MiBalanceStep';           Visible: True),
    (Code: 'Bin'; Caption: 'MiBalanceImbalanceInBin'; Visible: True),
    (Code: 'Bin'; Caption: 'MiLearningCurveChange';   Visible: True),
    (Code: 'Bin'; Caption: 'MIMsgJobHandle';          Visible: true),
    (Code: 'Bin'; Caption: 'MiAssignedBooleanProp1';  Visible: True),
    (Code: 'Bin'; Caption: 'MIPropPlannerdef';        Visible: false),
    (Code: 'Bin'; Caption: 'MISplitOnHost';           Visible: True),
    (Code: 'Bin'; Caption: 'MiSeedChange';            Visible: false),
    (Code: 'Bin'; Caption: 'MiJoinAndSplitAccordingNextStep'; Visible: false),
    (Code: 'Bin'; Caption: 'MiCreateVersioning';      Visible: false),
    (Code: 'Bin'; Caption: 'MiFormularesult';         Visible: false),
    (Code: 'Bin'; Caption: 'MIUnscheduleSelectedAndForwardLinkedJobs'; Visible: false),
    (Code: 'Bin'; Caption: 'MiUnHalted'; Visible: false)
  );

implementation

uses
  Dialogs,
  gnugettext,
  UGprogCtrl,FireDAC.Stan.Error,
  IdSMTP, IdMessage, IdExplicitTLSClientServerBase, IDGlobal, IdSSLOpenSSL, IdAttachmentFile,
  UGRegItf, Menus;

const
  RegDefault    = 'Main';                     // default vip registry section
  RgNowMqmCfg   = '\Config';
  RgMqmSezCfg   = '\Config';                  // Vip configuration section
  RgMqmSezBin   = '\BinConfig';               // Vip Bin section
  RgMqmSezForm  = '\Forms';                   // Vip Forms section
  RgMqmEnvDesc  = 'EnvDescr';                 // Environment Description

  RgMqmSezCol   = RgMqmSezBin + '\Column';    // Vip Bin columns section
  RgMqmFormPlan = RgMqmSezForm + '\Plan';     // Section about Plan Form
  RgMqmFormBin  = RgMqmSezForm + '\Bin';      // Section about Bin Form
  RgMqmFormMove = RgMqmSezForm + '\Move';     // Section about Move Form

  // Environment mqm
  RgCfgServer     = 'Server';
  RgCfgMainDBPath = 'MainDBPath';
  RgCfgCfgDBPath  = 'CfgDBPath';
  RgCfgMainDBName = 'MainDBName';
  RgCfgCfgDBName  = 'CfgDBName';
  RgSrvNameDefine  = 'SrvNameDefine';
//  RgNowDBName     = 'NowDBName';
//  RgNowEnvironment = 'NowEnvironment';
//  RgCfgMudulesServed = 'MudulesServed';

  // Environment NOW

  RgCompanyCode = 'CompanyCode';                 // Last used Company Code
  RgEnvironmentCode = 'EnvironmentCode';         // Environment code
  RgGetDownloadFrom = 'GetDownloadFrom';         // GetDownloadFrom
  RgGroupCode = 'GroupCode';                     // GroupCode
  RgNowAlias  = 'Alias';

  RgStartCheck   = 'StartCheck';
  RgEndCheck     = 'EndCheck';
  RgCheckTimer   = 'CheckTimer';
//  RgClientConnectionCheck = 'ClientConnectionCheck';
  RgIdentifier   = 'Identifier';
  RgCfgOdbcAlias = 'AliasOdbc';
  RgDownloadTo   = 'DownloadTo';                 //Download to (0): IB, (1): DB2
  RgDownloadFrom = 'DownloadFrom';               //Download to (0): DB2, (1): Oracle

  RgIBUserName = 'IBUserName';                   //IB user name
  RgIBPassword = 'IBPassword';                   //IB password
  RgIBDataSource = 'IBDataSource';               //IB - ODBC Data source name

{  RgDB2InstanceName = 'DB2InstanceName';         //DB2 instance name
  RgDB2UserName = 'DB2UserName';                 //DB2 user name
  RgDB2Password = 'DB2Password';                 //DB2 password
  RgDB2DataSource = 'DB2DataSource';             //DB2 database name
  RgDB2SrvIP = 'DB2SrvIP';                       //DB2 server ip  }

  RgNOWDB2InstanceName = 'NOWDB2InstanceName';   //NOW - DB2 instance name
  RgNOWDB2UserName    = 'NOWDB2UserName';           //NOW - DB2 user name
  RgNOWDB2Password   = 'NOWDB2Password';           //NOW - DB2 password
  RgNOWDB2DataSource = 'NOWDB2DataSource';       //NOW - DB2 database name
  RgNOWDB2SrvIP      = 'NOWDB2SrvIP';                 //NOW - DB2 server ip
  RgNOWDB2PORT         = 'NOWDB2PORT';                 //NOW - Db2 port

  RgNOWDB2InstanceNameLocal = 'NOWDB2InstanceNameLocal';   //NOW - DB2 instance name
  RgNOWDB2UserNameLocal    = 'NOWDB2UserNameLocal';           //NOW - DB2 user name
  RgNOWDB2PasswordLocal   = 'NOWDB2PasswordLocal';           //NOW - DB2 password
  RgNOWDB2DataSourceLocal = 'NOWDB2DataSourceLocal';       //NOW - DB2 database name
  RgNOWDB2SrvIPLocal      = 'NOWDB2SrvIPLocal';                 //NOW - DB2 server ip
  RgNOWDB2PORTLocal         = 'NOWDB2PORTLocal';                 //NOW - Db2 port

  RgNOWOracleIp        = 'NOWOracleIp';
  RgNOWOracleTNSName = 'NOWOracleTNSName';           //NOW - Oracle TNS name
  RgNOWOracleUserName = 'NOWOracleUserName';     //NOW - Oracle user name
  RgNOWOraclePassword = 'NOWOraclePassword';     //NOW - Oracle password

  RgNOWOracleIpLocal        = 'NOWOracleIpLocal';
  RgNOWOracleTNSNameLocal = 'NOWOracleTNSNameLocal';           //NOW - Oracle TNS name
  RgNOWOracleUserNameLocal = 'NOWOracleUserNameLocal';     //NOW - Oracle user name
  RgNOWOraclePasswordLocal = 'NOWOraclePasswordLocal';     //NOW - Oracle password

  RgODBCDriver   = 'ODBCDriver';
  RgODBCUserName = 'ODBCUserName';
  RgODBCPassword = 'ODBCPassword';

  RgEncrypted = 'Encrypted';
  RgShowPropColor_Standart_RGB = 'ShowPropColor_Standart_RGB';
  RgFormulaForMaterialAvailability = 'FormulaForMaterialAvailability';
  RgFormulaForMaterialAvailabilityToIgnore = 'FormulaForMaterialAvailabilityToIgnore';
  RgDownloadCalendarData = 'DownloadCalendarData'; // Download calendar data (0): No, (1): Yes
  RgLimitNumbersOfThread = 'LimitNumbersOfThread';
  RgMuduleServed = 'MuduleServed';


  RgCfgArcDBPath = 'ArcDBPath';
  RgCfgArcDBName = 'ArcDBName';

  RgCfgAS400Alias = 'Alias';
  RgCfgPcalias    = 'PCalias';

  RgRepoPlanProp  = 'PlanPropFile';
  RgPreparationExeName = 'PreparationExeName';
  RgDaysKeepHistory   = 'DaysKeepHistory';
  RgDaysKeepLogHistory   = 'DaysKeepLogHistory';

  RgCfgASsysName      = 'ASsysName';               // AS Local Name
  RgCfgASSerNumb      = 'ASSerialNumber';          // AS Serial Number
  RgCfgASLibList      = 'ASLibList';               // AS library list
//  RgCfgODBCAlias      = '0DBCAlias';               // AS400 ODBC alias
  RgCfgLocAlias       = 'LocAlias';                // local database alias
  RgCfgCustomer       = 'Customer';                // Customer name
  RgCfgSrvPath        = 'SrvPath';                 // server database path
  RgCfgLastWkstCode   = 'LastWkstCode';            // last workstation Code
  RgCfgTimeSrvLoop    = 'TimeLoopAouto';           // Time Loop auto for mode
  RgCfgOperateTimeLoopDnldUpload = 'OperateTimeLoopDnldUpload';  // operate time loop
  RgCfgOperateWaitingTimeUploadDnld = 'OperateWaitingTimeUploadDnld';  // operate time loop
  RgCopiedSchedTypeFromMqm = 'CopiedSchedTypeFromMqm';
  RgCBCopiedSchedTypeFromMqm = 'CBCopiedSchedTypeFromMqm';
  RgCBForceMqmScheduleDetails = 'CBForceMqmScheduleDetails';
  RgCopiedBackwardFromMqmDays = 'CopiedBackwardFromMqmDays';
  RgCBCopiedBackwardFromMqmDays = 'CBCopiedBackwardFromMqmDays';
  RgLoopWithMqmCg     = 'LoopWithMqmCg';           // Using Mqmcg for second loop
  RgHostDateFormat    = 'HostDateFormat';          // Host Date Time Format
  RgLoginAuto         = 'LoginAuto';               // Host Automatic Connection User/Password
  RgTimePickerEndLoop = 'TimePickerEndLoop';     // TimePickerEndLoop
  RgDndArchiveName    = 'DndArchiveName';
  RgUser              = 'User';                    // Host User Name
  RgPassword          = 'Password';                // Host Password
  RgDwnTypeMode       = 'DowloadTypMode';          // All Files, Only archives, Only Production
  RgHtmlRowNum        = 'HtmlRowNum';              // Number of rows to print per HTML page
  RgShowBinCaption    = 'ShowBinCaption';          // do we show the bin caption in the report
  RgShowBinCaptionBinReport = 'ShowBinCaptionBinReport';  // do we show the bin caption in the report
  RgShowCriteria      = 'ShowCriteria ';           // Show criteria in the report
  RgReportComment1    = 'ReportComment1';          // comment to show in the report
  RgPagePerResource   = 'PagePerResource';         // new page for next resource in report
  RgIncDowntime       = 'IncDowntime';             // include downtimes in reports
  RgShowUnschedJobs   = 'ShowUnschedJobs';         // Show unscheduled jobs in extraction reports
  RgFontBinCaption    = 'FontCaption';             // font of bin caption in the report
  RgFontBinCapSize    = 'FontCaptionSize';         // font size of bin caption in the report
  RgFontBinCapStyle   = 'FontCapStyle';            // font style of bin caption in the report
  RgFontBinCapColor   = 'FontCapColor';            // font color of bin caption in the report
  RgFontBinCapChar    = 'FontCapChar';             // font charset of bin caption in the report
  RgFontCriteria      = 'FontCriteria';            // font of criteria in the report
  RgFontCriteriaSize  = 'FontCriteriaSize';        // font size of criteria in the report
  RgFontCriteriaStyle = 'FontCriteriaStyle';       // font style of criteria in the report
  RgFontCriteriaColor = 'FontCriteriaColor';       // font color of criteria in the report
  RgFontCriteriaChar  = 'FontCriteriaChar';        // font charset of criteria in the report
  RgFontComment       = 'FontComment';             // font of comment in the report
  RgFontCommentSize   = 'FontCommentSize';         // font size of comment in the report
  RgFontCommentStyle  = 'FontCommentStyle';        // font style of comment in the report
  RgFontCommentColor  = 'FontCommentColor';        // font color of comment in the report
  RgFontCommentChar   = 'FontCommentChar';         // font charset of comment in the report
  RgFontColTitles     = 'FontColTitles';           // font of column titles in the report
  RgFontColTitleSize  = 'FontColTitleSize';        // font size of column titles in the report
  RgFontColTitleStyle = 'FontColTitleStyle';       // font style of column titles in the report
  RgFontColTitleColor = 'FontColTitleColor';       // font color of column titles in the report
  RgFontColTitleChar  = 'FontColTitleChar';        // font charset of column titles in the report
  RgFontDataLines     = 'FontDataLines';           // font of data lines in the report
  RgFontDataLineSize  = 'FontDataLineSize';        // font size of data lines in the report
  RgFontDataLineStyle = 'FontDataLineStyle';       // font style of data lines in the report
  RgFontDataLineColor = 'FontDataLineColor';       // font color of data lines in the report
  RgFontDataLineChar  = 'FontDataLineChar';        // font charset of data lines in the report
  RgHtmlColorBack     = 'HtmlColorBack';           // background color in the report
  RgHtmlColorTabTitle = 'HtmlColorTabTitle';       // table title background color in the report
  RgHtmlColorTabEven  = 'HtmlColorTabEven';        // even table row background color in the report
  RgHtmlColorTabOdd   = 'HtmlColorTabOdd';         // odd table row background color in the report
  RgExcelTitle        = 'ExcelTitle';              // Excel report title
  RgExcelTitleBinReport = 'ExcelTitleBinReport';   // Excel report Bin report title

  RgSMTP_server = 'SMTP_SERVER';
  RgPORT        = 'PORT';
  RgLOGINWITHAUTHENTICATION = 'LOGINWITHAUTHENTICATION';
  RgTLS_SSL    = 'TLS_SSL';

  RgGroupingFields    = 'GroupingFields';          // number of gouping fields for reports
  RgJumpingFields     = 'JumpingFields';           // number of jumping fields for reports
  RgShowGroups        = 'ShowGroups';              // show group values in reports
  RgShowResources     = 'ShowResources';           // show resource descriptions in reports

  RgSplitByDateTimeNumOfDec = 'SplitByDateTimeNumOfDec';
  RgSplitByDateTimeRoundCrit = 'SplitByDateTimeRoundCrit';
  RgSplitByDateTimeReJoinBinJob = 'SplitByDateTimeReJoinBinJob';

  RgSplitFromPointNumOfDec = 'SplitFromPointNumOfDec';
  RgSplitFromPointRoundCrit = 'SplitFromPointRoundCrit';
  RgSplitFromPointOnPreDefTime = 'SplitFromPointOnPreDefTime';
  RgSplitFromPointPreDefTime   = 'SplitFromPointPreDefTime';
  RgNumOfDecJobQtyOnStatusBar = 'NumOfDecJobQtyOnStatusBar';
  RgShowStatusBarAsHint = 'ShowStatusBarAsHint';

  RgField1BinColReportStatic = 'Field1BinColStatic';
  RgField2BinColReportStatic = 'Field2BinColStatic';
  RgField3BinColReportStatic = 'Field3BinColStatic';
  RgField4BinColReportStatic = 'Field4BinColStatic';
  RgField5BinColReportStatic = 'Field5BinColStatic';
  RgField6BinColReportStatic = 'Field6BinColStatic';
  RgField7BinColReportStatic = 'Field7BinColStatic';
  RgField8BinColReportStatic = 'Field8BinColStatic';
  RgField9BinColReportStatic = 'Field9BinColStatic';
  RgField10BinColReportStatic = 'Field10BinColStatic';
  RgConcatenation             = 'Concatenation';
  RgSeparator                 = 'Separator';
  RgHeadingConcatination      = 'HeadingConcatination';
  RgHeadingSeparator          = 'HeadingSeparator';
  RgShowColumnCaptionsReport  = 'ShowColumnCaptionReport';
  RgShowColumnCaptionsBinReport = 'ShowColumnCaptionBinReport';
  RgShowTotalReport           = 'ShowTotalReport';
  RgSelectedAtibute           = 'SelectedAtibute';

  // Machine Period Report
  RgMachineReportPeriodTitle  = 'MachineReportPeriodTitle';
  RgMachineReportPeriod       = 'MachineReportPeriod';
  RgMachineReportPeriodFrom   = 'MachineReportPeriodFrom';
  RgMachineReportPeriodNum    = 'MachineReportPeriodNum';
  RgMachineReportShowFromToHeader = 'MachineReportShowFromToHeader';
  RgMachineReportFileNameAutoOperation = 'MachineReportFileNameAutoOpern';
  RgMachineReportDaysMinusDoday = 'MachineReportDaysMinusDoday';

  RgCfgLanguage       = 'Language';                // Current Language
  RgCfgLibForSP       = 'LibForSP';                // Library for Stored Procedure
  // Directories of environment
  RgCfgImgDir      = 'DirImg';                  // image files directory
  RgCfgLangDir     = 'DirLang';                 // Languages files directory
  // Calendar Setting
  RgCfgMnthBefore  = 'MonthBefore';             // MonthBefore (Table VIPD on AS)
  RgCfgShowCal     = 'ShowCal';                 // Show calendar shapes on Gantt
  RgCfgTScale      = 'TScale';                  // TimeScale of Plan selected
  RgCfgCurrDTime   = 'CurrDtTime';              // Current Date/Time choose by user
  RgCfgShowZoom    = 'ShowZoom';                // Zoom Gant is active or not
  RgCfgRunMode     = 'Check';                   // configuring the behaviour of the program
  // Various Ordering and setting
  RgCfgRscSort     = 'RscSort';                 // Current Sort of Plan resource
  RgCfgRscOrdType  = 'RscOrdType';              // Current Sort of resource 1(Resource form)
  RgCfgRscOrdItm   = 'RscOrdItm';               // Current Sort of resource 2(Resource form)
  RgCfgDelOccAlone = 'DelOccAlone';             // Delete Occ alone before upload
  RgCfgDrawProg    = 'DrawProg';                // Show if download with delay recalculation
  // Setting of Plan Form
  RgPlanLeft       = 'WdwPlanPosLeft';          // Left Position of Plan form
  RgPlanTop        = 'WdwPlanPosTop';           // Top Position of Plan form
  RgPlanWidth      = 'WdwPlanWidth';            // Width of Plan form
  RgPlanHeight     = 'WdwPlanHeight';           // Height of Plan form
  RgPlanState      = 'WdwPlanState';            // State of Plan form
  // Setting of Bin Form
  RgBinDock        = 'WdwBinDock';              // Docking Position of Bin Form
  RgBinLeft        = 'WdwBinPosLeft';           // Left Position of Bin form
  RgBinTop         = 'WdwBinPosTop';            // Top Position of Bin form
  RgBinWidth       = 'WdwBinWidth';             // Width of Bin form
  RgBinHeight      = 'WdwBinHeight';            // Height of Bin form
  RgBinState       = 'WdwBinState';             // State of Bin form
  RgBinSplitterH   = 'WdwBinSplitterH';         // Splitter Height for Bin Plan Form
  RgBinCfgMain     = 'BinCfg_Main';             // Main Bin Configuration
  RgBinCfgSrcByNum = 'BinCfg_SrcByNum';         // Search by number bin configuration
  RgBinCfgSrcByOrd = 'BinCfg_SrcByOrd';         // Search by order bin configuration
  RgBinCfgSrcByIss = 'BinCfg_SrcByIss';         // Search by issue bin configuration
  RgBinCfgSrcByArt = 'BinCfg_SrcByArt';         // Search by article bin configuration
  RgBinCfgSrcByTD  = 'BinCfg_SrcByTD';          // Search by tecnical data bin configuration

  // Setting of Move Form
  RgMoveLeft        = 'WdwMoveLeft';            // Left Position of Move form
  RgMoveTop         = 'WdwMoveTop';             // Top Position of Move form
  RgMoveDetails     = 'WdwMoveDetails';         // Move form Details open
  RgMoveOcc         = 'OccMove';                // Last move option selected for Occupations
  RgMoveVL          = 'VLMove';                 // Last move option selected for Vip Lines
  RgMoveOTP         = 'OTPMove';                // Last move option selected for Order to produce

  //Application Preferences
  RgCheckStepSeq    = 'CheckStepSeq';           // Check step sequence
  RgCenterStartOnMove = 'CenterStartOnMove';    // Center the planned start date on the gantt when moving from the bin
  RGWarnOnMoveFinal = 'WarnOnMoveFinal';         // Warning message when a movement need to move a final schedule on gantt
  RgDefSchedType    = 'DefSchedType';           // Default Schedulation type
  RgConfLevels      = 'ConfLevels';             // Confirmation levels
  RgCfgJobBarTextSet   = 'JobBarTextSet';             //Active Set of BarText
  RgCfgStatusBarTextSet   = 'StatusBarTextSet';             //Active Set of BarText

  Rg_External_Database_Update = 'External_Database_Update';
  Rg_ChangePassStation = 'ChangePassStation';
  Rg_Upload_Download_disable  = 'Upload_Download_disable';
  Rg_BalanceViewToUseInAvailability = 'BalanceViewToUseInAvailability';
  Rg_VIEWTLSPODUpdateDeliveryDate   = 'VIEWTLSPODUpdateDeliveryDate';

  //arc not to be downloaded
  Rg_tbl_wkc_alt_NOT_Dwld = 'tbl_wkc_alt_NOT_Dwld';
  Rg_tbl_arty_NOT_Dwld    = 'tbl_arty_NOT_Dwld';
  Rg_tbl_resCat_NOT_Dwld  = 'tbl_resCat_NOT_Dwld';
  Rg_tbl_res_sub_NOT_Dwld = 'tbl_res_sub_NOT_Dwld';
  Rg_tbl_ruleOccToOcc_NOT_Dwld = 'tbl_ruleOccToOcc_NOT_Dwld';
  Rg_tbl_prop_NOT_Dwld         = 'tbl_prop_NOT_Dwld';
  Rg_tbl_res_NOT_Dwld          = 'tbl_res_NOT_Dwld';
  Rg_tbl_ruleResToOcc_NOT_Dwld = 'tbl_ruleResToOcc_NOT_Dwld';
  Rg_tbl_prop_res_NOT_Dwld     = 'tbl_prop_res_NOT_Dwld';
  Rg_tbl_unit_NOT_Dwld         = 'tbl_unit_NOT_Dwld';
  Rg_tbl_wkc_NOT_Dwld          = 'tbl_wkc_NOT_Dwld';
  Rg_tbl_wkc_proc_NOT_Dwld     = 'tbl_wkc_proc_NOT_Dwld';
  Rg_tbl_wkst_NOT_Dwld         = 'tbl_wkst_NOT_Dwld';
  Rg_tbl_wkst_wkc_NOT_Dwld     = 'tbl_wkst_wkc_NOT_Dwld';
  Rg_tbl_wkc_priority_NOT_Dwld  = 'tbl_wkc_priority_NOT_Dwld';
  Rg_tbl_machine_setup_code_NOT_Dwld = 'tbl_machine_setup_code_NOT_Dwld';
  Rg_tbl_wkc_dependency_NOT_Dwld     = 'tbl_wkc_dependency_NOT_Dwld';
  Rg_tbl_material_sup_detail_NOT_Dwld = 'tbl_material_sup_detail_NOT_Dwld';
  Rg_tbl_material_sup_header_NOT_Dwld = 'tbl_material_sup_header_NOT_Dwld';
  Rg_tbl_wkc_group_NOT_Dwld           = 'tbl_wkc_group_NOT_Dwld';
  Rg_tbl_wkc_Category_NOT_Dwld        = 'tbl_wkc_Category_NOT_Dwld';
  Rg_tbl_CategoryDatesInfo_NOT_Dwld   = 'tbl_CategoryDatesInfo_NOT_Dwld';
  Rg_tbl_wkc_Penalties_NOT_Dwld       = 'tbl_wkc_Penalties_NOT_Dwld';
  Rg_tbl_LearningCurve_NOT_Dwld       = 'tbl_LearningCurve_NOT_Dwld';

  Rg_SetLimiDateUsingCapacity         = 'SetLimiDateUsingCapacity';
  Rg_SetLimiDateUsingSecureNumDays    = 'SetLimiDateUsingSecureNumDays';
  Rg_SuggestedTextTabJobSequence      = 'SuggestedTextTabJobSequence';
  Rg_FontSize                         = 'FontSize';

  Rg_MCMactsasMQM                     = 'MCMasMQM';

  CFG_LIMITOCC = $00000001;
  CFG_DEVELOP  = $00000002;

var

  // compatibility handling informations
  s_propMtx:      array[1..1] of TOrigMatrix;
  s_rulesRtoOMtx: array[1..2] of TOrigMatrix;
  s_rulesOtoOMtx: array[1..2] of TOrigMatrix;

const
  CKEY1 = 53761;
  CKEY2 = 32618;

  PropMtxMap: array[TCompatMatrix] of integer = (
        1,  // simple code
       -1,  // code and process
       -1,  // code and product type
       -1,  // code and resource category
       -1,  // code, product type and resource category
       -1   // code, product type and process
      );

  RulesRtoOMtxMap: array[TCompatMatrix] of integer = (
        1,  // simple code
       -1,  // code and process
        2,  // code and product type
       -1,  // code and resource category
       -1,  // code, product type and resource category
       -1   // code, product type and process
      );

  RulesOtoOMtxMap: array[TCompatMatrix] of integer = (
        1,  // simple code
       -1,  // code and process
        2,  // code and product type
       -1,  // code and resource category
       -1,  // code, product type and resource category
       -1   // code, product type and process
      );



procedure TranslationExtractionPurpose;
//These strings are not really used in the program and are here only
//for the translation extraction purpose
var
  notused1,notused2,notused3,notused4,notused5,notused6,notused7,notused8,
  notused9,notused10,notused11,notused12,notused13,notused14,notused15,notused16,
  notused17, notused18, notused19, notused21, notused22, notused23,
  notused24, notused25, notused26, notused27, notused28 : string;
begin
  notused1:= _('Initial schedule');
  notused2:= _('Confirmation level 1');
  notused3:= _('Confirmation level 2');
  notused4:= _('Confirmation level 3');
  notused5:= _('Confirmation level 4');
  notused6:= _('Confirmation level 5');
  notused7:= _('Final scheduled');
  notused8:= _('Progressed');
  notused9:= _('Progressed as final');
  notused10:= _('Closed');
  notused11:= _('After delivery date' );
  notused12:= _('After latest end');
  notused13:= _('Before earliest start');
  notused14:= _('Before approval date');

  notused15:= _('Steps overlapping');
  notused16:= _('Materials warning');
  notused17:= _('Additional resources warning');
  notused18:= _('Materials and additional resources warning');

  notused19:= _('Continuous');
  notused21:= _('Continuous (read only)');
  notused22:= _('Sub resource Continuous');
  notused23:= _('Sub resource Continuous (read only)');
  notused24:= _('Batch');
  notused25:= _('Batch (read Only)');
  notused26:= _('Sub resource Batch');
  notused27:= _('Sub resource Batch (read Only)');

  notused28:= _('No description');

end;


function Decrypt(const S: WideString): String;
var   i, tmpKey,a  :Integer;
      RStr       :RawByteString;
      RStrB      :TBytes Absolute RStr;
      tmpStr     :string;
      Key: Word;
begin
   tmpStr:= UpperCase(S);
  SetLength(RStr, Length(tmpStr) div 2);
  i:= 1;
  Key := 223;

  try
    while (i < Length(tmpStr)) do
    begin

      if TryStrToInt('$' + tmpStr[i] + tmpStr[i+1], a) then
        RStrB[i div 2]:= StrToInt('$' + tmpStr[i] + tmpStr[i+1])
      else
        RStrB[i div 2]:= 0;
      Inc(i, 2);
    end;
  except
    Result:= '';
    Exit;
  end;

  for i := 0 to Length(RStr)-1 do begin
    tmpKey:= RStrB[i];
    RStrB[i] := RStrB[i] xor (Key shr 8);
    Key := (tmpKey + Key) * CKEY1 + CKEY2;
  end;
  Result:= UTF8Decode(RStr);
end;

function Encrypt(const S :WideString): String;
var   i          :Integer;
      RStr       :RawByteString;
      RStrB      :TBytes Absolute RStr;
      Key: Word;
begin
  Result := '';
  Key := 223;
  if S <> '' then
  begin
    RStr:= UTF8Encode(S);
    for i := 0 to Length(RStr)-1 do begin
      RStrB[i] := RStrB[i] xor (Key shr 8);
      Key := (RStrB[i] + Key) * CKEY1 + CKEY2;
    end;

    for i := 0 to Length(RStr)-1 do begin
      Result:= Result + IntToHex(RStrB[i], 2);
    end;

  end;
end;

//----------------------------------------------------------------------------//
//                          Sending mail                           //
//----------------------------------------------------------------------------//

function SendEmail(SendMailParam : TSendMailParm) : boolean;
var
  IdSMTP: TIdSMTP;
  Email: TIdMessage;
  IdAttachmentFile : TIdAttachmentFile;
  SSLHandler: TIdSSLIOHandlerSocketOpenSSL;
begin
  result := false;
  //  SMTP servers require SSL authenï¿½tiï¿½caï¿½tion
  IdSMTP := TIdSMTP.Create(nil);
  Email := TIdMessage.Create(nil);
  try
    if SendMailParam.TLS_SSL then
    begin
      SSLHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
      SSLHandler.MaxLineAction := maException;
      SSLHandler.SSLOptions.Method := sslvSSLv23;
      SSLHandler.SSLOptions.Mode := sslmUnassigned;
      SSLHandler.SSLOptions.VerifyMode := [];
      SSLHandler.SSLOptions.VerifyDepth := 0;
      IdSMTP.IOHandler := SSLHandler;
      IdSMTP.UseTLS    := utUseExplicitTLS;
    end
    else
      IdSMTP.UseTLS := utNoTLSSupport;

    IdSMTP.Host := SendMailParam.SmtpServer;  //IniAppGlobals.SMTP_server;
    IdSMTP.Port := StrToInt(SendMailParam.Port);  //StrToInt(IniAppGlobals.PORT);
    IdSMTP.UseEhlo := true;
    IdSMTP.AuthType := satDefault;
    IdSMTP.Username := SendMailParam.UserId;
    IdSMTP.Password := SendMailParam.Password;

    Email.From.Address := SendMailParam.UserId;
    Email.Recipients.EmailAddresses := SendMailParam.Recipient;
    Email.Subject := SendMailParam.Subject;
    Email.Body.Text := SendMailParam.BodyText;

    if SendMailParam.AttachmentFilePath <> '' then
      IdAttachmentFile := TIdAttachmentFile.Create(Email.MessageParts, SendMailParam.AttachmentFilePath);
                                                                      //'C:\Environments\Mqm\A.xls');
    IdSMTP.Connect;
    if IdSMTP.Connected then
    begin
        IdSMTP.Authenticate;
        result := true;
        try
          IdSMTP.Send(Email);
        except
          result := false;
          raise
        end;
        IdSMTP.Disconnect;
    end;
  finally
      Email.Free;
  //    SSLHandler.Free;
      IdSMTP.Free;
  end;

end;

//----------------------------------------------------------------------------//
//                          COMPATIBILITY FUNCTIONS                           //
//----------------------------------------------------------------------------//

function GetGlobValueForProperty(pID: TPropID; mtx: TCompatMatrix): TPropRes;
begin
  Result := nil;
  Assert(mtx = CMX_code);
  if PropMtxMap[mtx] = -1 then exit;
  if not Assigned(s_propMtx[PropMtxMap[mtx]]) then exit;
  Result := TPropRes(TOneDmatrix(s_propMtx[PropMtxMap[mtx]]).GetObject(pID))
end;

//----------------------------------------------------------------------------//

function GetGlobRuleRtoOfForProperty(pID: TPropID; prod: string; mtx: TCompatMatrix): TCompRules;
var
  mtxVal: TOrigMatrix;
begin
  Result := nil;
  if RulesRtoOMtxMap[mtx] = -1 then exit;
  mtxVal := s_rulesRtoOMtx[RulesRtoOMtxMap[mtx]];
  if not Assigned(mtxVal) then exit;

  case mtx of
  CMX_code:      Result := TCompRules(TOneDmatrix(mtxVal).GetObject(pID));
  CMX_code_prod: Result := TCompRules(TTwoDmatrix(mtxVal).GetObject(pID,prod));
  else
    Assert(false)
  end
end;

//----------------------------------------------------------------------------//

function GetGlobRuleOtoOfForProperty(pID: TPropID; prod: string; mtx: TCompatMatrix): TCompRules;
var
  mtxVal: TOrigMatrix;
begin
  Result := nil;
  if RulesOtoOMtxMap[mtx] = -1 then exit;
  mtxVal := s_rulesOtoOMtx[RulesOtoOMtxMap[mtx]];
  if not Assigned(mtxVal) then exit;

  case mtx of
  CMX_code:      Result := TCompRules(TOneDmatrix(mtxVal).GetObject(pID));
  CMX_code_prod: Result := TCompRules(TTwoDmatrix(mtxVal).GetObject(pID,prod));
  else
    Assert(false)
  end
end;

//----------------------------------------------------------------------------//

function GlobAddProperty(code: string; var val: TPropResRec; ErrList: TStringList): boolean;
var
  propRes: TPropRes;
  pId:     TPropID;
  tpLink:  TCompatTopoLink;
  mtx:     TCompatMatrix;
  mtxVal:  TOrigMatrix;
  PropCode : string;
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
    ErrList.Add(_('Global') + ': ' + _('Error loading property') + ' ' + code);
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
  try
  Assert(tpLink = CTL_global);
  except
    PropCode := GetPropCodeFromID(pID);
    ErrList.Add(_('Global') + ': ' + _('Error loading property definition for property') + ' ' + PropCode + ' '
     + '- ' +  _('Global Level is expected.'));
    //Result := false;
  end;
  Assert(PropMtxMap[mtx] <> -1);
  if not Assigned(s_propMtx[PropMtxMap[mtx]]) then
    CreateMatrix(s_propMtx[PropMtxMap[mtx]], mtx);

  mtxVal := s_propMtx[PropMtxMap[mtx]];

  Assert(mtx = CMX_code);
  TOneDmatrix(mtxVal).AddObject(pId, propRes);

  Result := true
end;

//----------------------------------------------------------------------------//

procedure AssignRuleToMat(pId: TPropID; mtx: TCompatMatrix; mtxVal: TOrigMatrix;
                          isOtoO: boolean; var vrnt: variant; var val: TRuleResRec);
var
  oneDmtx: TOneDmatrix;
  twoDmtx: TTwoDmatrix;
  rule:    TCompRules;
  sup:     TSetupRec;
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

  CMX_code_prod: begin // code and product type
                   twoDmtx := TTwoDmatrix(mtxVal);
                   rule := TCompRules(twoDmtx.GetObject(pId, val.prodType));
                   if not Assigned(rule) then
                   begin
                     rule := TCompRules.Create;
                     twoDmtx.AddObject(pId, val.prodType, rule)
                   end
                 end;
  end;

  Assert(Assigned(rule));

  if not isOtoO then
    rule.AddItem(val.checkSeq, val.toBase, vrnt, val.op, val.comp, nil)
  else
  begin
    sup.Value          := ConvPropValue(pId, val.constStr);
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

    sup.teoreticl_wc     := val.teoreticl_wc;
    sup.duration         := val.duration;
    sup.LeadTime         := val.LeadTime;
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

function GlobAddRtoOrule(code: string; var val: TRuleResRec; ErrList: TStringList): boolean;
var
  pId:       TPropID;
  tpLink:    TCompatTopoLink;
  mtx:       TCompatMatrix;
  vrnt:      variant;
begin
  pId := DecodeProp(code, val.valStr, vrnt);
  if not Assigned(pId) then
  begin
    ErrList.Add(_('Global') + ': ' + _('Error loading property') + ' ' + code);
    Result := false;
    exit
  end;

  GetPropCoordForRtoOcomp(pId, tpLink, mtx);
 // Assert(tpLink = CTL_global);
  if tpLink <> CTL_global then exit;


  Assert(RulesRtoOMtxMap[mtx] <> -1);
  if not Assigned(s_rulesRtoOMtx[RulesRtoOMtxMap[mtx]]) then
    CreateMatrix(s_rulesRtoOMtx[RulesRtoOMtxMap[mtx]], mtx);

  AssignRuleToMat(pId, mtx, s_rulesRtoOMtx[RulesRtoOMtxMap[mtx]], false, vrnt, val);
  Result := true
end;

//----------------------------------------------------------------------------//

function GlobAddOtoOrule(code: string; var val: TRuleResRec; ErrList: TStringList): boolean;
var
  pId:    TPropID;
  tpLink: TCompatTopoLink;
  mtx:    TCompatMatrix;
  vrnt:   variant;
begin
  pId := DecodeProp(code, val.valStr, vrnt);
  if not Assigned(pId) then
  begin
    ErrList.Add(_('Global') + ': ' + _('Error loading property') + ' ' + code);
    Result := false;
    exit
  end;

  GetPropCoordForOtoOcomp(pId, tpLink, mtx);

  if tpLink <> CTL_global then
  begin
    ErrList.Add(_('Error loading property') + ' ' + code + ' ' + _('Wrong rule was defined'));
    Result := false;
    exit
  end;

//  Assert(tpLink = CTL_global);

  Assert(RulesOtoOMtxMap[mtx] <> -1);
  if not Assigned(s_rulesOtoOMtx[RulesOtoOMtxMap[mtx]]) then
    CreateMatrix(s_rulesOtoOMtx[RulesOtoOMtxMap[mtx]], mtx);

  AssignRuleToMat(pId, mtx, s_rulesOtoOMtx[RulesOtoOMtxMap[mtx]], true, vrnt, val);
  Result := true
end;

//----------------------------------------------------------------------------//

procedure GlobGetPropMtxs(lst: TList);
var
  cmpM: TCompatMatrix;
begin
  for cmpM := Low(TCompatMatrix) to High(TCompatMatrix) do
  begin
    if (PropMtxMap[cmpM] = -1) or
       (not Assigned(s_propMtx[PropMtxMap[cmpM]])) then continue;
    lst.Add(s_propMtx[PropMtxMap[cmpM]])
  end
end;

//----------------------------------------------------------------------------//

function GlobGetRulesRtoOMtxs: TList;
var
  cmpM: TCompatMatrix;
begin
  Result := TList.Create;

  for cmpM := Low(TCompatMatrix) to High(TCompatMatrix) do
  begin
    if (RulesRtoOMtxMap[cmpM] = -1) or
       (not Assigned(s_rulesRtoOMtx[RulesRtoOMtxMap[cmpM]])) then continue;
    Result.Add(s_rulesRtoOMtx[RulesRtoOMtxMap[cmpM]])
  end
end;

//----------------------------------------------------------------------------//

function GlobGetRulesOtoOMtxs: TList;
var
  cmpM: TCompatMatrix;
begin
  Result := TList.Create;

  for cmpM := Low(TCompatMatrix) to High(TCompatMatrix) do
  begin
    if (RulesOtoOMtxMap[cmpM] = -1) or
       (not Assigned(s_rulesOtoOMtx[RulesOtoOMtxMap[cmpM]])) then continue;
    Result.Add(s_rulesOtoOMtx[RulesOtoOMtxMap[cmpM]])
  end
end;

//----------------------------------------------------------------------------//

function GetWorkStationForWc(wc: string; isDesc: boolean): string;
var
  qry:      TMqmQuery;
  tbInfoww: ^TTblInfo;
  tbInfows: ^TTblInfo;
begin
  Result := '';
  tbInfoww := @tblInfo[tbl_wkst_wkc];
  tbInfows := @tblInfo[tbl_wkst];
  qry := CreateQuery(Main_DB);

  with qry do
  begin
    SQL.Clear;
    SQL.Add('select * from ' + tbInfoww.GetTableName);
    SQL.Add(' left join ' + tbInfows.GetTableName +  ' on ' + CreateFld(tbInfoww.pfx,fli_wkstCode) + '=' + CreateFld(tbInfows.pfx,fli_wkstCode));
    SQL.Add(' AND ' + CreateFld(tbInfoww.pfx,fli_Identifier) + '=' + CreateFld(tbInfows.pfx,fli_Identifier));
    SQL.Add(' where ' + CreateFld(tbInfoww.pfx,fli_wkCtrCode) + '=''' + WC + '''');
    SQL.Add(' and ' + CreateFld(tbInfoww.pfx,fli_TypeOfUse) +  ' = ' + '1');

    if DBAppGlobals.MCM_App then
      qry.SQL.Add(' and ' + CreateFld(tbInfows.pfx, fli_WorkStationType) + '=''1''')
    else
      qry.SQL.Add(' and ' + CreateFld(tbInfows.pfx, fli_WorkStationType) + '=''0''');

    SQL.Add(AND_IDF_Condition(CreateFld(tbInfoww.pfx, fli_Identifier)));
    open;
    if not IsDesc then
      Result := fieldByName(CreateFld(tbInfoww.pfx,fli_wkstCode)).AsString
    else
      Result := fieldByName(CreateFld(tbInfows.pfx,fli_wkDescr)).AsString;
    Close;
  end;

  qry.Free;
end;

//----------------------------------------------------------------------------//

procedure DecodeConfig(config: integer);
begin
  with LocAppGlobals do
    if (config and CFG_DEVELOP) > 0 then
      IsDevelop := true
end;

//----------------------------------------------------------------------------//

procedure GlobLoadIniValues;
begin
  with IniAppGlobals do
  begin
    ReadStrFromIniFile(RgMqmSezCfg, RgCfgLastWkstCode, WkstCode);

    ReadStrFromIniFile(RgMqmSezCfg, RgCfgServer,     Server);
    ReadStrFromIniFile(RgMqmSezCfg, RgCfgMainDBPath, MainDBPath);
    ReadStrFromIniFile(RgMqmSezCfg, RgCfgCfgDBPath,  CfgDBPath);
    ReadStrFromIniFile(RgMqmSezCfg, RgCfgMainDBName, MainDBName);
    ReadStrFromIniFile(RgMqmSezCfg, RgSrvNameDefine, SrvNameUserDefine);
    ReadStrFromIniFile(RgMqmSezCfg, RgCfgCfgDBName,  CfgDBName);
//    ReadStrFromIniFile(RgMqmSezCfg, RgCfgMudulesServed, MudulesServed);


    ReadStrFromIniFile(RgMqmSezCfg, RgCfgArcDBPath, ArcDBPath);
    ReadStrFromIniFile(RgMqmSezCfg, RgCfgArcDBName, ArcDBName);

//    ReadStrFromIniFile(RgMqmSezCfg, RgCfgAS400alias, Alias);
    ReadStrFromIniFile(RgMqmSezCfg, RgCfgPcalias, PCAlias);
    ReadStrFromIniFile(RgMqmSezCfg, RgRepoPlanProp,  FilePlanPropRepo);
    ReadStrFromIniFile(RgMqmSezCfg, RgPreparationExeName, PreparationExeName);
    ReadStrFromIniFile(RgMqmSezCfg, RgDaysKeepHistory, DaysKeepHistory);
    ReadStrFromIniFile(RgMqmSezCfg, RgDaysKeepLogHistory, DaysKeepLogHistory);
    ReadStrFromIniFile(RgMqmSezCfg, RgCfgTimeSrvLoop, TimeLoop);
    ReadStrFromIniFile(RgMqmSezCfg, Rg_External_Database_Update, External_Database_Update);
    ReadStrFromIniFile(RgMqmSezCfg, Rg_ChangePassStation, ChangePassStation);
    ReadStrFromIniFile(RgMqmSezCfg, RgCfgOperateTimeLoopDnldUpload, OperateTimeLoopDnldUpload);
    ReadStrFromIniFile(RgMqmSezCfg, RgCfgOperateWaitingTimeUploadDnld, OperateWaitingTimeUploadDnld);
    ReadStrFromIniFile(RgMqmSezCfg, RgCopiedSchedTypeFromMqm, CopiedSchedTypeFromMqm);
    ReadStrFromIniFile(RgMqmSezCfg, RgCBCopiedSchedTypeFromMqm, CBCopiedSchedTypeFromMqm);
//    ReadStrFromIniFile(RgMqmSezCfg, RgCBForceMqmScheduleDetails, CBForceMqmScheduleDetails);
    ReadStrFromIniFile(RgMqmSezCfg, RgCopiedBackwardFromMqmDays, CopiedBackwardFromMqmDays);
    ReadStrFromIniFile(RgMqmSezCfg, RgCBCopiedBackwardFromMqmDays, CBCopiedBackwardFromMqmDays);
    ReadStrFromIniFile(RgMqmSezCfg, RgDwnTypeMode, DwnTypeMode);
    ReadStrFromIniFile(RgMqmSezCfg, RgLoopWithMqmCg, DwnLoopWithMqmCg);
    ReadStrFromIniFile(RgMqmSezCfg, RgHostDateFormat,  HostDateFormat);
    ReadStrFromIniFile(RgMqmSezCfg, Rg_BalanceViewToUseInAvailability,  BalanceViewToUseInAvailability);
    ReadStrFromIniFile(RgMqmSezCfg, Rg_VIEWTLSPODUpdateDeliveryDate,  VIEWTLSPODUpdateDeliveryDate);

//    ReadStrFromIniFile(RgMqmSezCfg, RgLoginAuto, LoginAuto);
    ReadStrFromIniFile(RgMqmSezCfg, RgTimePickerEndLoop, TimePickerEndLoop);
    ReadStrFromIniFile(RgMqmSezCfg, RgDndArchiveName, DndArchiveName);
//    ReadStrFromIniFile(RgMqmSezCfg, RgUser, User);
//    ReadStrFromIniFile(RgMqmSezCfg, RgPassword, Password);

    ReadStrFromIniFile(RgMqmSezCfg, RgStartCheck, StartCheck);
    ReadStrFromIniFile(RgMqmSezCfg, RgEndCheck, EndCheck);

    ReadStrFromIniFile(RgMqmSezCfg, RgIdentifier, Identifier);
    if IniAppGlobals.Identifier = '' then
        IniAppGlobals.Identifier := '0';
    ReadStrFromIniFile(RgMqmSezCfg, RgCheckTimer, CheckTimer);
//    ReadStrFromIniFile(RgMqmSezCfg, RgClientConnectionCheck, ClientConnectionCheck);

    ReadStrFromIniFile(RgMqmSezCfg, RgCfgOdbcalias, AliasOdbc);
    ReadStrFromIniFile(RgMqmSezCfg, RgDownloadTo, DownloadTo);
    ReadStrFromIniFile(RgMqmSezCfg, RgDownloadFrom, DownloadFrom);

    ReadStrFromIniFile(RgMqmSezCfg, RgIBUserName, IBUserName);
    ReadStrFromIniFile(RgMqmSezCfg, RgIBPassword, IBPassword);
    ReadStrFromIniFile(RgMqmSezCfg, RgIBDataSource, IBDataSource);
{    ReadStrFromIniFile(RgMqmSezCfg, RgDB2InstanceName, DB2InstanceName);
    ReadStrFromIniFile(RgMqmSezCfg, RgDB2UserName, DB2UserName);
    ReadStrFromIniFile(RgMqmSezCfg, RgDB2Password, DB2Password);
    ReadStrFromIniFile(RgMqmSezCfg, RgDB2DataSource, DB2DataSource);
    ReadStrFromIniFile(RgMqmSezCfg, RgDB2SrvIP, DB2SrvIP );   }


{    ReadStrFromIniFile(RgMqmSezCfg, RgNOWDB2InstanceName, NOWDB2InstanceName);
    ReadStrFromIniFile(RgMqmSezCfg, RgNOWDB2UserName, NOWDB2UserName);
    ReadStrFromIniFile(RgMqmSezCfg, RgNOWDB2Password, NOWDB2Password);  }

    ReadStrFromIniFile(RgMqmSezCfg, RgNOWDB2InstanceName, NOWDB2InstanceName);
    ReadStrFromIniFile(RgMqmSezCfg, RgNOWDB2UserName, NOWDB2UserName);
    ReadStrFromIniFile(RgMqmSezCfg, RgNOWDB2Password, NOWDB2Password);
    ReadStrFromIniFile(RgMqmSezCfg, RgNOWDB2DataSource, NOWDB2DataSource);
    ReadStrFromIniFile(RgMqmSezCfg, RgNOWDB2SrvIP, NOWDB2SrvIP);
    ReadStrFromIniFile(RgMqmSezCfg, RgNOWDB2PORT,  NOWDB2PORT);

    ReadStrFromIniFile(RgMqmSezCfg, RgNOWDB2InstanceNameLocal, NOWDB2InstanceNameLocal);
    ReadStrFromIniFile(RgMqmSezCfg, RgNOWDB2UserNameLocal, NOWDB2UserNameLocal);
    ReadStrFromIniFile(RgMqmSezCfg, RgNOWDB2PasswordLocal, NOWDB2PasswordLocal);
    ReadStrFromIniFile(RgMqmSezCfg, RgNOWDB2DataSourceLocal, NOWDB2DataSourceLocal);
    ReadStrFromIniFile(RgMqmSezCfg, RgNOWDB2SrvIPLocal, NOWDB2SrvIPLocal);
    ReadStrFromIniFile(RgMqmSezCfg, RgNOWDB2PORTLocal,  NOWDB2PORTLocal);

    ReadStrFromIniFile(RgMqmSezCfg, RgNOWOracleIp, NOWOracleIp);
    ReadStrFromIniFile(RgMqmSezCfg, RgNOWOracleTNSName, NOWOracleTNSName);
    ReadStrFromIniFile(RgMqmSezCfg, RgNOWOracleUserName, NOWOracleUserName);
    ReadStrFromIniFile(RgMqmSezCfg, RgNOWOraclePassword, NOWOraclePassword);

    ReadStrFromIniFile(RgMqmSezCfg, RgNOWOracleIpLocal, NOWOracleIpLocal);
    ReadStrFromIniFile(RgMqmSezCfg, RgNOWOracleTNSNameLocal, NOWOracleTNSNameLocal);
    ReadStrFromIniFile(RgMqmSezCfg, RgNOWOracleUserNameLocal, NOWOracleUserNameLocal);
    ReadStrFromIniFile(RgMqmSezCfg, RgNOWOraclePasswordLocal, NOWOraclePasswordLocal);

    ReadStrFromIniFile(RgMqmSezCfg, RgODBCDriver, ODBCDriverName);
    ReadStrFromIniFile(RgMqmSezCfg, RgODBCUserName, ODBCUserName);
    ReadStrFromIniFile(RgMqmSezCfg, RgODBCPassword, ODBCPassword);

    ReadStrFromIniFile(RgMqmSezCfg, RgCompanyCode, CompanyCode);
    ReadStrFromIniFile(RgMqmSezCfg, RgEnvironmentCode, EnvironmentCode);
    ReadStrFromIniFile(RgMqmSezCfg, RgFormulaForMaterialAvailability, FormulaForMaterialAvailability);
    ReadStrFromIniFile(RgMqmSezCfg, RgFormulaForMaterialAvailabilityToIgnore, FormulaForMaterialAvailabilityToIgnore);

    ReadStrFromIniFile(RgMqmSezCfg, RgHtmlRowNum, HtmlRowNum);
    ReadStrFromIniFile(RgMqmSezCfg, Rg_Upload_Download_disable, Upload_Download_disable);
    ReadStrFromIniFile(RgMqmSezCfg, Rg_tbl_wkc_alt_NOT_Dwld, tbl_wkc_alt_NOT_Dwld);
    ReadStrFromIniFile(RgMqmSezCfg, Rg_tbl_arty_NOT_Dwld, tbl_arty_NOT_Dwld);
    ReadStrFromIniFile(RgMqmSezCfg, Rg_tbl_resCat_NOT_Dwld, tbl_resCat_NOT_Dwld);
    ReadStrFromIniFile(RgMqmSezCfg, Rg_tbl_res_sub_NOT_Dwld, tbl_res_sub_NOT_Dwld);
    ReadStrFromIniFile(RgMqmSezCfg, Rg_tbl_ruleOccToOcc_NOT_Dwld, tbl_ruleOccToOcc_NOT_Dwld);
    ReadStrFromIniFile(RgMqmSezCfg, Rg_tbl_prop_NOT_Dwld, tbl_prop_NOT_Dwld);
    ReadStrFromIniFile(RgMqmSezCfg, Rg_tbl_res_NOT_Dwld, tbl_res_NOT_Dwld);
    ReadStrFromIniFile(RgMqmSezCfg, Rg_tbl_ruleResToOcc_NOT_Dwld, tbl_ruleResToOcc_NOT_Dwld);
    ReadStrFromIniFile(RgMqmSezCfg, Rg_tbl_prop_res_NOT_Dwld, tbl_prop_res_NOT_Dwld);
    ReadStrFromIniFile(RgMqmSezCfg, Rg_tbl_unit_NOT_Dwld, tbl_unit_NOT_Dwld);
    ReadStrFromIniFile(RgMqmSezCfg, Rg_tbl_wkc_NOT_Dwld, tbl_wkc_NOT_Dwld);
    ReadStrFromIniFile(RgMqmSezCfg, Rg_tbl_wkc_proc_NOT_Dwld, tbl_wkc_proc_NOT_Dwld);
    ReadStrFromIniFile(RgMqmSezCfg, Rg_tbl_wkst_NOT_Dwld, tbl_wkst_NOT_Dwld);
    ReadStrFromIniFile(RgMqmSezCfg, Rg_tbl_wkst_wkc_NOT_Dwld, tbl_wkst_wkc_NOT_Dwld);
    ReadStrFromIniFile(RgMqmSezCfg, Rg_tbl_wkc_priority_NOT_Dwld, tbl_wkc_priority_NOT_Dwld);
    ReadStrFromIniFile(RgMqmSezCfg, Rg_tbl_machine_setup_code_NOT_Dwld, tbl_machine_setup_code_NOT_Dwld);
    ReadStrFromIniFile(RgMqmSezCfg, Rg_tbl_wkc_dependency_NOT_Dwld, tbl_wkc_dependency_NOT_Dwld);
    ReadStrFromIniFile(RgMqmSezCfg, Rg_tbl_material_sup_detail_NOT_Dwld, tbl_material_sup_detail_NOT_Dwld);
    ReadStrFromIniFile(RgMqmSezCfg, Rg_tbl_material_sup_header_NOT_Dwld, tbl_material_sup_header_NOT_Dwld);
    ReadStrFromIniFile(RgMqmSezCfg, Rg_tbl_wkc_group_NOT_Dwld, tbl_wkc_group_NOT_Dwld);
    ReadStrFromIniFile(RgMqmSezCfg, Rg_tbl_wkc_Category_NOT_Dwld, tbl_wkc_Category_NOT_Dwld);
    ReadStrFromIniFile(RgMqmSezCfg, Rg_tbl_CategoryDatesInfo_NOT_Dwld, tbl_CategoryDatesInfo_NOT_Dwld);
    ReadStrFromIniFile(RgMqmSezCfg, Rg_tbl_wkc_Penalties_NOT_Dwld, tbl_wkc_Penalties_NOT_Dwld);
    ReadStrFromIniFile(RgMqmSezCfg, Rg_tbl_LearningCurve_NOT_Dwld, tbl_LearningCurve_NOT_Dwld);

    ReadStrFromIniFile(RgMqmSezCfg, RgShowPropColor_Standart_RGB, ShowPropColor_Standart_RGB);

    ReadIntFromIniFile(RgMqmSezCfg, Rg_FontSize, FontSize);

    ReadIntFromIniFile(RgMqmSezCfg, Rg_MCMactsasMQM, MCMasMQM);

    {$ifdef Enc}
      NOWDB2Password := Decrypt(NOWDB2Password);
      NOWDB2PasswordLocal := Decrypt(NOWDB2PasswordLocal);
      NOWOraclePassword := Decrypt(NOWOraclePassword);
      NOWOraclePasswordLocal := Decrypt(NOWOraclePasswordLocal);
      ODBCPassword := Decrypt(ODBCPassword);
    {$endif}

  end
end;

//----------------------------------------------------------------------------//

function PosEx_Sha_Pas_2(const SubStr, S: string; Offset: Integer = 1): Integer;
Type
  PInteger =^Integer;
var
  len, lenSub: Integer;
  ch: char;
  p, pSub, pStart, pStop: pchar;
label
  Loop0, Loop4,
  TestT, Test0, Test1, Test2, Test3, Test4,
  AfterTestT, AfterTest0,
  Ret, Exit;
begin;
  pSub := pointer(SubStr);
  p := pointer(S);

  if (p = nil) or (pSub = nil) or (Offset < 1) then
  begin;
    Result := 0;
    goto Exit;
  end;

  lenSub := PLongInt(PByte(pSub) - 4)^ - 1; // <- Modified
  len := PLongInt(PByte(p) - 4)^; // <- Modified
  if (len < lenSub + Offset) or (lenSub < 0) then
  begin;
    Result := 0;
    goto Exit;
  end;

  pStop := p + len;
  p := p + lenSub;
  pSub := pSub + lenSub;
  pStart := p;
  p := p + Offset + 3;

  ch := pSub[0];
  lenSub := -lenSub;
  if p < pStop then
    goto Loop4;
  p := p - 4;
  goto Loop0;

Loop4:
  if ch = p[-4] then
    goto Test4;
  if ch = p[-3] then
    goto Test3;
  if ch = p[-2] then
    goto Test2;
  if ch = p[-1] then
    goto Test1;
Loop0:
  if ch = p[0] then
    goto Test0;
AfterTest0:
  if ch = p[1] then
    goto TestT;
AfterTestT:
  p := p + 6;
  if p < pStop then
    goto Loop4;
  p := p - 4;
  if p < pStop then
    goto Loop0;
  Result := 0;
  goto Exit;

Test3:
  p := p - 2;
Test1:
  p := p - 2;
TestT:
  len := lenSub;
  if lenSub <> 0 then
    repeat
      ;
      if (pSub[len] <> p[len + 1]) or (pSub[len + 1] <> p[len + 2]) then
        goto AfterTestT;
      len := len + 2;
    until len >= 0;
  p := p + 2;
  if p <= pStop then
    goto Ret;
  Result := 0;
  goto Exit;

Test4:
  p := p - 2;
Test2:
  p := p - 2;
Test0:
  len := lenSub;
  if lenSub <> 0 then
    repeat
      ;
      if (pSub[len] <> p[len]) or (pSub[len + 1] <> p[len + 1]) then
        goto AfterTest0;
      len := len + 2;
    until len >= 0;
  Inc(p);
Ret:
  Result := p - pStart;
Exit:
end;

//----------------------------------------------------------------------------//

procedure GlobLoadIniValuesNow;
begin
end;

//----------------------------------------------------------------------------//

procedure GlobLoadIniValuesFromDB;
begin
  FillListFromIniFileDB;
  with IniAppGlobals do
  begin
    ReadStrFromIniFileDB(RgMqmSezCfg, RgHtmlRowNum,  HtmlRowNum, WkstCode);
    Saved_HtmlRowNum := HtmlRowNum;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgShowBinCaption,  ShowBinCaption, WkstCode);
    Saved_ShowBinCaption := ShowBinCaption;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgShowBinCaptionBinReport, ShowBinCaptionBinReport, WkstCode);
    Saved_ShowBinCaptionBinReport := ShowBinCaptionBinReport;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgShowCriteria, ShowCriteria, WkstCode);
    Saved_ShowCriteria := ShowCriteria;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgReportComment1, ReportComment1 , WkstCode);
    Saved_ReportComment1 := ReportComment1;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgPagePerResource, PagePerResource , WkstCode);
    Saved_PagePerResource := PagePerResource;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgIncDowntime, IncDowntime , WkstCode);
    Saved_IncDowntime := IncDowntime;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgShowUnschedJobs, ShowUnschedJobs, WkstCode);
    Saved_ShowUnschedJobs := ShowUnschedJobs;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgFontBinCaption, FontBinCaption , WkstCode);
    Saved_FontBinCaption := FontBinCaption;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgFontBinCapSize, FontBinCapSize , WkstCode);
    Saved_FontBinCapSize := FontBinCapSize;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgFontBinCapStyle, FontBinCapStyle , WkstCode);
    Saved_FontBinCapStyle := FontBinCapStyle;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgFontBinCapColor, FontBinCapColor, WkstCode);
    Saved_FontBinCapColor := FontBinCapColor;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgFontBinCapChar, FontBinCapChar, WkstCode);
    Saved_FontBinCapChar := FontBinCapChar;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgFontCriteria, FontCriteria , WkstCode);
    Saved_FontCriteria := FontCriteria;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgFontCriteriaSize, FontCriteriaSize , WkstCode);
    Saved_FontCriteriaSize := FontCriteriaSize;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgFontCriteriaStyle, FontCriteriaStyle, WkstCode);
    Saved_FontCriteriaStyle := FontCriteriaStyle;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgFontCriteriaColor, FontCriteriaColor, WkstCode);
    Saved_FontCriteriaColor := FontCriteriaColor;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgFontCriteriaChar, FontCriteriaChar, WkstCode);
    Saved_FontCriteriaChar := FontCriteriaChar;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgFontComment, FontComment, WkstCode);
    Saved_FontComment := FontComment;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgFontCommentSize, FontCommentSize, WkstCode);
    Saved_FontCommentSize := FontCommentSize;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgFontCommentStyle, FontCommentStyle, WkstCode);
    Saved_FontCommentStyle := FontCommentStyle;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgFontCommentColor, FontCommentColor, WkstCode);
    Saved_FontCommentColor := FontCommentColor;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgFontCommentChar, FontCommentChar, WkstCode);
    Saved_FontCommentChar := FontCommentChar;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgFontColTitles, FontColTitles, WkstCode);
    Saved_FontColTitles := FontColTitles;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgFontColTitleSize, FontColTitleSize, WkstCode);
    Saved_FontColTitleSize := FontColTitleSize;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgFontColTitleStyle, FontColTitleStyle, WkstCode);
    Saved_FontColTitleStyle := FontColTitleStyle;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgFontColTitleColor, FontColTitleColor, WkstCode);
    Saved_FontColTitleColor := FontColTitleColor;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgFontColTitleChar, FontColTitleChar, WkstCode);
    Saved_FontColTitleChar := FontColTitleChar;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgFontDataLines, FontDataLine, WkstCode);
    Saved_FontDataLine := FontDataLine;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgFontDataLineSize, FontDataLineSize, WkstCode);
    Saved_FontDataLineSize := FontDataLineSize;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgFontDataLineStyle, FontDataLineStyle, WkstCode);
    Saved_FontDataLineStyle := FontDataLineStyle;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgFontDataLineColor, FontDataLineColor, WkstCode);
    Saved_FontDataLineColor := FontDataLineColor;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgFontDataLineChar, FontDataLineChar, WkstCode);
    Saved_FontDataLineChar := FontDataLineChar;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgHtmlColorBack, HtmlColorBack, WkstCode);
    Saved_HtmlColorBack := HtmlColorBack;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgHtmlColorTabTitle, HtmlColorTabTitle, WkstCode);
    Saved_HtmlColorTabTitle := HtmlColorTabTitle;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgHtmlColorTabEven, HtmlColorTabEven, WkstCode);
    Saved_HtmlColorTabEven := HtmlColorTabEven;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgHtmlColorTabOdd, HtmlColorTabOdd , WkstCode);
    Saved_HtmlColorTabOdd := HtmlColorTabOdd;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgExcelTitle, ExcelTitle , WkstCode);
    Saved_ExcelTitle := ExcelTitle;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgExcelTitleBinReport, ExcelTitleBinReport , WkstCode);
    Saved_ExcelTitleBinReport := ExcelTitleBinReport;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgSMTP_server, SMTP_server, WkstCode);
    Saved_SMTP_server := SMTP_server;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgPORT, PORT, WkstCode);
    Saved_PORT := PORT;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgLOGINWITHAUTHENTICATION, LOGINWITHAUTHENTICATION, WkstCode);
    Saved_LOGINWITHAUTHENTICATION := LOGINWITHAUTHENTICATION;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgTLS_SSL, TLS_SSL , WkstCode);
    Saved_TLS_SSL := TLS_SSL;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgGroupingFields, GroupingFields , WkstCode);
    Saved_GroupingFields := GroupingFields;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgJumpingFields, JumpingFields , WkstCode);
    Saved_JumpingFields := JumpingFields;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgShowGroups, ShowGroups , WkstCode);
    Saved_ShowGroups := ShowGroups;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgShowResources, ShowResources , WkstCode);
    Saved_ShowResources := ShowResources;

    ReadStrFromIniFileDB(RgMqmSezCfg, RgSplitByDateTimeNumOfDec,     SplitByDateTimeNumOfDec , WkstCode);
    Saved_SplitByDateTimeNumOfDec := SplitByDateTimeNumOfDec;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgSplitByDateTimeRoundCrit,    SplitByDateTimeRoundCrit , WkstCode);
    Saved_SplitByDateTimeRoundCrit := SplitByDateTimeRoundCrit;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgSplitByDateTimeReJoinBinJob, SplitByDateTimeReJoinBinJob , WkstCode);
    Saved_SplitByDateTimeReJoinBinJob := SplitByDateTimeReJoinBinJob;

    ReadStrFromIniFileDB(RgMqmSezCfg, RgSplitFromPointNumOfDec,     SplitFromPointNumOfDec , WkstCode);
    Saved_SplitFromPointNumOfDec := SplitFromPointNumOfDec;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgSplitFromPointRoundCrit,    SplitFromPointRoundCrit , WkstCode);
    Saved_SplitFromPointRoundCrit := SplitFromPointRoundCrit;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgSplitFromPointOnPreDefTime, SplitFromPointOnPreDefTime , WkstCode);
    Saved_SplitFromPointOnPreDefTime := SplitFromPointOnPreDefTime;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgSplitFromPointPreDefTime,   SplitFromPointPreDefTime , WkstCode);
    Saved_SplitFromPointPreDefTime := SplitFromPointPreDefTime;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgNumOfDecJobQtyOnStatusBar,   NumOfDecJobQtyOnStatusBar , WkstCode);
    Saved_NumOfDecJobQtyOnStatusBar := NumOfDecJobQtyOnStatusBar;
    var sHintTmp: string := '';
    ReadStrFromIniFileDB(RgMqmSezCfg, RgShowStatusBarAsHint, sHintTmp, WkstCode);
    ShowStatusBarAsHint := (sHintTmp = '1');
    ReadStrFromIniFileDB(RgMqmSezCfg, RgField1BinColReportStatic, Field1BinColReportStatic, WkstCode);
    Saved_Field1BinColReportStatic := Field1BinColReportStatic;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgField2BinColReportStatic, Field2BinColReportStatic, WkstCode);
    Saved_Field2BinColReportStatic := Field2BinColReportStatic;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgField3BinColReportStatic, Field3BinColReportStatic, WkstCode);
    Saved_Field3BinColReportStatic := Field3BinColReportStatic;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgField4BinColReportStatic, Field4BinColReportStatic, WkstCode);
    Saved_Field4BinColReportStatic := Field4BinColReportStatic;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgField5BinColReportStatic, Field5BinColReportStatic, WkstCode);
    Saved_Field5BinColReportStatic := Field5BinColReportStatic;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgField6BinColReportStatic, Field6BinColReportStatic, WkstCode);
    Saved_Field6BinColReportStatic := Field6BinColReportStatic;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgField7BinColReportStatic, Field7BinColReportStatic, WkstCode);
    Saved_Field7BinColReportStatic := Field7BinColReportStatic;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgField8BinColReportStatic, Field8BinColReportStatic, WkstCode);
    Saved_Field8BinColReportStatic := Field8BinColReportStatic;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgField9BinColReportStatic, Field9BinColReportStatic, WkstCode);
    Saved_Field9BinColReportStatic := Field9BinColReportStatic;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgField10BinColReportStatic, Field10BinColReportStatic, WkstCode);
    Saved_Field10BinColReportStatic := Field10BinColReportStatic;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgConcatenation, Concatenation, WkstCode);
    Saved_Concatenation := Concatenation;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgSeparator, Separator, WkstCode);
    Saved_Separator := Separator;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgHeadingConcatination, HeadingConcatination, WkstCode);
    Saved_HeadingConcatination := HeadingConcatination;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgHeadingSeparator, HeadingSeparator, WkstCode);
    Saved_HeadingSeparator := HeadingSeparator;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgShowColumnCaptionsReport, ShowColumnCaptionsReport, WkstCode);
    Saved_ShowColumnCaptionsReport := ShowColumnCaptionsReport;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgShowColumnCaptionsBinReport, ShowColumnCaptionsBinReport, WkstCode);
    Saved_ShowColumnCaptionsBinReport := ShowColumnCaptionsBinReport;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgShowTotalReport, ShowTotalReport, WkstCode);
    Saved_ShowTotalReport := ShowTotalReport;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgSelectedAtibute, SelectedAtibute, WkstCode);
    Saved_SelectedAtibute := SelectedAtibute;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgMachineReportPeriodTitle, MachineReportPeriodTitle, WkstCode);
    Saved_MachineReportPeriodTitle := MachineReportPeriodTitle;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgMachineReportPeriod, MachineReportPeriod, WkstCode);
    Saved_MachineReportPeriod := MachineReportPeriod;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgMachineReportPeriodFrom, MachineReportPeriodFrom, WkstCode);
    Saved_MachineReportPeriodFrom := MachineReportPeriodFrom;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgMachineReportPeriodNum, MachineReportPeriodNum, WkstCode);
    Saved_MachineReportPeriodNum := MachineReportPeriodNum;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgMachineReportDaysMinusDoday, MachineReportDaysMinusDoday, WkstCode);
    Saved_MachineReportDaysMinusDoday := MachineReportDaysMinusDoday;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgMachineReportShowFromToHeader, MachineReportShowFromToHeader, WkstCode);
    Saved_MachineReportShowFromToHeader := MachineReportShowFromToHeader;
    ReadStrFromIniFileDB(RgMqmSezCfg, RgMachineReportFileNameAutoOperation, MachineReportFileNameAutoOperation, WkstCode);
    Saved_MachineReportFileNameAutoOperation := MachineReportFileNameAutoOperation;
    ReadStrFromIniFileDB(RgMqmSezCfg, Rg_SetLimiDateUsingCapacity, SetLimiDateUsingCapacity, WkstCode);
    Saved_SetLimiDateUsingCapacity := SetLimiDateUsingCapacity;
    ReadStrFromIniFileDB(RgMqmSezCfg, Rg_SetLimiDateUsingSecureNumDays, SetLimiDateUsingSecureNumDays, WkstCode);
    Saved_SetLimiDateUsingSecureNumDays := SetLimiDateUsingSecureNumDays;
    ReadStrFromIniFileDB(RgMqmSezCfg, Rg_SuggestedTextTabJobSequence, DBAppSettings.SuggestedTextTabJobSequence, WkstCode);
    Saved_SuggestedTextTabJobSequence := DBAppSettings.SuggestedTextTabJobSequence;
  end;
end;

//----------------------------------------------------------------------------//

procedure DefaultComptColors(var DefaultCmptColr : TColorArray);
var
  I : Integer;
begin
  SetLength(DefaultCmptColr, Length(DfltCmpClr));
  for I := Low(DfltCmpClr) to High(DfltCmpClr) do
    DefaultCmptColr[I] := DfltCmpClr[I];
end;

//----------------------------------------------------------------------------//

procedure DefaultJobStatusColors(var DefaultStatusColor : TColorArray);
var
  I : Integer;
begin
  SetLength(DefaultStatusColor, Length(DfltJobStatusClr));
  for I := Low(DfltJobStatusClr) to High(DfltJobStatusClr) do
  begin
    DefaultStatusColor[I] := DfltJobStatusClr[I];
    DefaultStatusColor[I].Dsc := _(DfltJobStatusClr[I].Dsc);
  end;
end;

//----------------------------------------------------------------------------//

procedure DefaultJobDateWrnColors(var DefaultDateWrnColors : TColorArray);
var
  I : Integer;
begin
  SetLength(DefaultDateWrnColors, Length(DfltJobDateWrnClr));
  for I := Low(DfltJobDateWrnClr) to High(DfltJobDateWrnClr) do
  begin
    DefaultDateWrnColors[I] := DfltJobDateWrnClr[I];
    DefaultDateWrnColors[I].Dsc := _(DfltJobDateWrnClr[I].Dsc);
  end;
end;

//----------------------------------------------------------------------------//

procedure DefaultJobMatWrnColors(var DefaultMatWrnColors : TColorArray);
var
  I : Integer;
begin
  SetLength(DefaultMatWrnColors, Length(DfltJobMatWrnClr));
  for I := Low(DfltJobMatWrnClr) to High(DfltJobMatWrnClr) do
  begin
    DefaultMatWrnColors[I] := DfltJobMatWrnClr[I];
    DefaultMatWrnColors[I].Dsc := _(DfltJobMatWrnClr[I].Dsc);
  end;
end;

//----------------------------------------------------------------------------//

procedure DefaultResColors(var DefaultResColr : TColorArray);
var
  I : Integer;
begin
  SetLength(DefaultResColr, Length(DfltRscClr));
  for I := Low(DfltRscClr) to High(DfltRscClr) do
    DefaultResColr[I] := DfltRscClr[I];
end;

//----------------------------------------------------------------------------//

procedure DefaultCapResColors(var DefaultCapResColr : TColorArray);
var
  I : Integer;
begin
  SetLength(DefaultCapResColr, Length(DfltCmpClr));
  for I := Low(DfltCmpClr) to High(DfltCmpClr) do
    DefaultCapResColr[I] := DfltCmpClr[I];
end;

//----------------------------------------------------------------------------//

function GetLastUpdatedNumber : Integer;
var
  qry:       TMqmQuery;
  tbReqChange : ^TTblInfo;
begin
  tbReqChange := @tblInfo[tbl_Req_Change];
  qry := CreateQuery(Main_DB);

  // load the Last updated number for the request changed table

  with qry do
  begin
    SQL.Clear;

    if (IniAppGlobals.downloadTo = '0') or (IniAppGlobals.DownloadTo = '1') then
      sql.add('Select ' + CreateFld(tbReqChange.pfx, fli_updCode) + ' from ' + tbReqChange.GetTableName +
       WHERE_IDF_Condition(CreateFld(tbReqChange.pfx, fli_Identifier)) +
       ' Order by ' + CreateFld(tbReqChange.pfx, fli_updCode) + ' desc' )
    else
      sql.add('Select ' + CreateFld(tbReqChange.pfx, fli_updCode) + ' from ' + tbReqChange.GetTableName +
       WHERE_IDF_Condition(CreateFld(tbReqChange.pfx, fli_Identifier)) +
          ' Order by ' + CreateFld(tbReqChange.pfx, fli_updCode) + ' descending' );
    open;

//    SQL.Add('select ' + CreateFld(tbReqChange.pfx, fli_updCode));
//    SQL.Add(' from ' + tbReqChange.GetTableName);
//    SQL.Add(' Order by ' + CreateFld(tbReqChange.pfx, fli_updCode));
//    Open;
    if Eof then
      Result := -1
    else
    begin
//      Last;
      Result := FieldByName(CreateFld(tbReqChange.pfx, fli_updCode)).AsInteger;
    end;
    Close;
  end;
  qry.free;

end;

//----------------------------------------------------------------------------//

function GetLastUpdatedCapResNumber : Integer;
var
  qry:       TMqmQuery;
  tbCapResChange : ^TTblInfo;
begin
  tbCapResChange := @tblInfo[tbl_CapRsc_Change];
  qry := CreateQuery(Main_DB);

  // load the Last updated number for the request changed table

  with qry do
  begin
    SQL.Clear;

    if (IniAppGlobals.downloadTo = '0') or (IniAppGlobals.DownloadTo = '1') then
      sql.add('Select ' + CreateFld(tbCapResChange.pfx, fli_updCode) + ' from ' + tbCapResChange.GetTableName + WHERE_IDF_Condition(CreateFld(tbCapResChange.pfx, fli_Identifier)) + ' Order by ' + CreateFld(tbCapResChange.pfx, fli_updCode) + ' desc' )
    else
      sql.add('Select ' + CreateFld(tbCapResChange.pfx, fli_updCode) + ' from ' + tbCapResChange.GetTableName + WHERE_IDF_Condition(CreateFld(tbCapResChange.pfx, fli_Identifier)) + ' Order by ' + CreateFld(tbCapResChange.pfx, fli_updCode) + ' descending' );
    open;
//    SQL.Add('select ' + CreateFld(tbCapResChange.pfx, fli_updCode));
//    SQL.Add(' from ' + tbCapResChange.GetTableName);
//    SQL.Add(' Order by ' + CreateFld(tbCapResChange.pfx, fli_updCode));
//    Open;
    if Eof then
      Result := -1
    else
    begin
//      Last;
      Result := FieldByName(CreateFld(tbCapResChange.pfx, fli_updCode)).AsInteger;
    end;
    Close;
  end;
  qry.free;
end;

//----------------------------------------------------------------------------//

procedure LoadColors;
type
 TColors = record
   DummyIndex  : integer;
   ValueFrom : integer;
   intColor : integer;
   bdrColor : integer;
   txtColor : integer;
   Description : string;
 end;
 PTColors = ^TColors;
var
  qry: TMqmQuery;
  tbInfocolorJobToJob, tbInfoclrCapToJob, tbInfocolorJobToRes, tbInfocolorStatus,
  tbInfocolorDateWarn, tbInfocolorMatWarn, tbInfoclrRes, tbInfoclrCapRes : ^TTblInfo;
  I,color:integer;
  J, DummyIndex, Index : Integer;
  PColors : PTColors;
  ColorsList : TList;
  ValueFrom : integer;
  IndexFound : integer;
  Found : Boolean;
  Dummy : string;
begin
  ColorsList := TList.Create;
  qry := CreateQuery(Cfg_DB);
  Dummy := ' ';
  tbInfocolorJobToJob := @tblInfo[tbl_cfg_colorJobToJob];
  tbInfoclrCapToJob := @tblInfo[tbl_cfg_clrCapToJob];
  tbInfocolorJobToRes := @tblInfo[tbl_cfg_colorJobToRes];
  tbInfocolorStatus := @tblInfo[tbl_cfg_colorStatus];
  tbInfocolorDateWarn := @tblInfo[tbl_cfg_colorDateWarn];
  tbInfocolorMatWarn := @tblInfo[tbl_cfg_colorMatWarn];
  tbInfoclrRes := @tblInfo[tbl_cfg_clrRes];
  tbInfoclrCapRes := @tblInfo[tbl_cfg_clrCapRes];

  qry.SQL.Add('select ');
  qry.SQL.Add('0 DummyIndex, ');
  qry.SQL.Add(CreateFld(tbInfocolorJobToJob.pfx, fli_ValFrom) + ' ValueFrom, ');
  qry.SQL.Add(CreateFld(tbInfocolorJobToJob.pfx, Fli_intColor) + ' intcolor, ');
  qry.SQL.Add(CreateFld(tbInfocolorJobToJob.pfx, Fli_bdrColor) + ' bdrColor, ');
  qry.SQL.Add(CreateFld(tbInfocolorJobToJob.pfx, Fli_txtColor) + ' txtColor, ');
  qry.SQL.Add(' cast(' + QuotedStr(' ') + 'as varchar(50))' + 'Description');
  qry.SQL.Add('from ' + tbInfocolorJobToJob.GetTableName + ' where ' + CreateFld(tbInfocolorJobToJob.pfx, fli_wkstCode) + '=''' + IniAppGlobals.WkstCode + '''');
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfocolorJobToJob.pfx, fli_Identifier)));

  qry.SQL.Add(' union all ');
  qry.SQL.Add('select ');
  qry.SQL.Add('1 DummyIndex, ');
  qry.SQL.Add(CreateFld(tbInfoclrCapToJob.pfx, fli_ValFrom) + ' ValueFrom, ');
  qry.SQL.Add(CreateFld(tbInfoclrCapToJob.pfx, Fli_intColor) + ' intcolor, ');
  qry.SQL.Add(CreateFld(tbInfoclrCapToJob.pfx, Fli_bdrColor) + ' bdrColor, ');
  qry.SQL.Add(CreateFld(tbInfoclrCapToJob.pfx, Fli_txtColor) + ' txtColor, ');
  qry.SQL.Add(' cast(' + QuotedStr(' ') + 'as varchar(50))' + 'Description');
  qry.SQL.Add('from ' + tbInfoclrCapToJob.GetTableName + ' where ' + CreateFld(tbInfoclrCapToJob.pfx, fli_wkstCode) + '=''' + IniAppGlobals.WkstCode + '''');
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfoclrCapToJob.pfx, fli_Identifier)));

  qry.SQL.Add(' union all ');
  qry.SQL.Add('select ');
  qry.SQL.Add('2 DummyIndex, ');
  qry.SQL.Add(CreateFld(tbInfocolorJobToRes.pfx, fli_ValFrom) + ' ValueFrom, ');
  qry.SQL.Add(CreateFld(tbInfocolorJobToRes.pfx, Fli_intColor) + ' intcolor, ');
  qry.SQL.Add(CreateFld(tbInfocolorJobToRes.pfx, Fli_bdrColor) + ' bdrColor, ');
  qry.SQL.Add(CreateFld(tbInfocolorJobToRes.pfx, Fli_txtColor) + ' txtColor, ');
  qry.SQL.Add(' cast(' + QuotedStr(' ') + 'as varchar(50))' + 'Description');
  qry.SQL.Add('from ' + tbInfocolorJobToRes.GetTableName + ' where ' + CreateFld(tbInfocolorJobToRes.pfx, fli_wkstCode) + '=''' + IniAppGlobals.WkstCode + '''');
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfocolorJobToRes.pfx, fli_Identifier)));

  qry.SQL.Add(' union all ');
  qry.SQL.Add('select ');
  qry.SQL.Add('3 DummyIndex, ');
  qry.SQL.Add(CreateFld(tbInfocolorStatus.pfx, fli_ValFrom) + ' ValueFrom, ');
  qry.SQL.Add(CreateFld(tbInfocolorStatus.pfx, Fli_intColor) + ' intcolor, ');
  qry.SQL.Add(CreateFld(tbInfocolorStatus.pfx, Fli_bdrColor) + ' bdrColor, ');
  qry.SQL.Add(CreateFld(tbInfocolorStatus.pfx, Fli_txtColor) + ' txtColor, ');
  qry.SQL.Add(CreateFld(tbInfocolorStatus.pfx, Fli_txtDescription) + ' Description ');
  qry.SQL.Add('from ' + tbInfocolorStatus.GetTableName + ' where ' + CreateFld(tbInfocolorStatus.pfx, fli_wkstCode) + '=''' + IniAppGlobals.WkstCode + '''');
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfocolorStatus.pfx, fli_Identifier)));

  qry.SQL.Add(' union all ');
  qry.SQL.Add('select ');
  qry.SQL.Add('4 DummyIndex, ');
  qry.SQL.Add(CreateFld(tbInfocolorDateWarn.pfx, fli_ValFrom) + ' ValueFrom, ');
  qry.SQL.Add(CreateFld(tbInfocolorDateWarn.pfx, Fli_intColor) + ' intcolor, ');
  qry.SQL.Add(CreateFld(tbInfocolorDateWarn.pfx, Fli_bdrColor) + ' bdrColor, ');
  qry.SQL.Add(CreateFld(tbInfocolorDateWarn.pfx, Fli_txtColor) + ' txtColor, ');
  qry.SQL.Add(CreateFld(tbInfocolorDateWarn.pfx, Fli_txtDescription) + ' Description ');
  qry.SQL.Add('from ' + tbInfocolorDateWarn.GetTableName + ' where ' + CreateFld(tbInfocolorDateWarn.pfx, fli_wkstCode) + '=''' + IniAppGlobals.WkstCode + '''');
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfocolorDateWarn.pfx, fli_Identifier)));

  qry.SQL.Add(' union all ');
  qry.SQL.Add('select ');
  qry.SQL.Add('5 DummyIndex, ');
  qry.SQL.Add(CreateFld(tbInfocolorMatWarn.pfx, fli_ValFrom) + ' ValueFrom, ');
  qry.SQL.Add(CreateFld(tbInfocolorMatWarn.pfx, Fli_intColor) + ' intcolor, ');
  qry.SQL.Add(CreateFld(tbInfocolorMatWarn.pfx, Fli_bdrColor) + ' bdrColor, ');
  qry.SQL.Add(CreateFld(tbInfocolorMatWarn.pfx, Fli_txtColor) + ' txtColor, ');
  qry.SQL.Add(CreateFld(tbInfocolorMatWarn.pfx, Fli_txtDescription) + ' Description ');
  qry.SQL.Add('from ' + tbInfocolorMatWarn.GetTableName + ' where ' + CreateFld(tbInfocolorMatWarn.pfx, fli_wkstCode) + '=''' + IniAppGlobals.WkstCode + '''');
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfocolorMatWarn.pfx, fli_Identifier)));

  qry.SQL.Add(' union all ');
  qry.SQL.Add('select ');
  qry.SQL.Add('6 DummyIndex, ');
  qry.SQL.Add(CreateFld(tbInfoclrRes.pfx, fli_ValFrom) + ' ValueFrom, ');
  qry.SQL.Add(CreateFld(tbInfoclrRes.pfx, Fli_intColor) + ' intcolor, ');
  qry.SQL.Add(CreateFld(tbInfoclrRes.pfx, Fli_bdrColor) + ' bdrColor, ');
  qry.SQL.Add(CreateFld(tbInfoclrRes.pfx, Fli_txtColor) + ' txtColor, ');
  qry.SQL.Add(CreateFld(tbInfoclrRes.pfx, Fli_txtDescription) + ' Description ');
  qry.SQL.Add('from ' + tbInfoclrRes.GetTableName + ' where ' + CreateFld(tbInfoclrRes.pfx, fli_wkstCode) + '=''' + IniAppGlobals.WkstCode + '''');
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfoclrRes.pfx, fli_Identifier)));

  qry.SQL.Add(' union all ');
  qry.SQL.Add('select ');
  qry.SQL.Add('7 DummyIndex, ');
  qry.SQL.Add(CreateFld(tbInfoclrCapRes.pfx, fli_ValFrom) + ' ValueFrom, ');
  qry.SQL.Add(CreateFld(tbInfoclrCapRes.pfx, Fli_intColor) + ' intcolor, ');
  qry.SQL.Add(CreateFld(tbInfoclrCapRes.pfx, Fli_bdrColor) + ' bdrColor, ');
  qry.SQL.Add(CreateFld(tbInfoclrCapRes.pfx, Fli_txtColor) + ' txtColor, ');
  qry.SQL.Add(CreateFld(tbInfoclrCapRes.pfx, Fli_txtDescription) + ' Description ');
  qry.SQL.Add('from ' + tbInfoclrCapRes.GetTableName + ' where ' + CreateFld(tbInfoclrCapRes.pfx, fli_wkstCode) + '=''' + IniAppGlobals.WkstCode + '''');
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfoclrCapRes.pfx, fli_Identifier)));
  qry.open;

  while not qry.Eof do
  begin
    DummyIndex := qry.FieldByName('DummyIndex').AsInteger;
    ValueFrom := qry.FieldByName('ValueFrom').AsInteger;
    IndexFound := ColorsList.Count;
    for I := 0 to ColorsList.Count - 1 do
    begin
      if (DummyIndex < PTColors(ColorsList[I]).DummyIndex)
      or ((DummyIndex = PTColors(ColorsList[I]).DummyIndex)
        and (ValueFrom < PTColors(ColorsList[I]).ValueFrom)) then
      begin
        IndexFound := I;
        break;
      end;
    end;
    new(PColors);
    PColors.DummyIndex := DummyIndex;
    PColors.ValueFrom := ValueFrom;
    PColors.intColor := qry.FieldByName('intcolor').AsInteger;
    PColors.bdrColor := qry.FieldByName('bdrColor').AsInteger;
    PColors.txtColor := qry.FieldByName('txtColor').AsInteger;
    PColors.Description := qry.FieldByName('Description').AsString;
    ColorsList.insert(IndexFound, PColors);
    qry.Next;
  end;

  qry.Close;
  qry.SQL.Clear;
  qry.free;

  for J := 0 to 7 do
  begin
    Found := false;
    for I := 0 to ColorsList.Count - 1 do
    begin
      if J = PTColors(ColorsList[I]).DummyIndex then
      begin
        Found := true;
        Index := I;
        break;
      end;
    end;

    case J of
    0 : begin
          if not Found then
            DefaultComptColors(DBAppGlobals.JobToJobCompColor)
          else
          begin
            SetLength(DBAppGlobals.JobToJobCompColor, Length(DfltCmpClr));
            for i := 0 to high(DfltCmpClr) do
            begin
              color := PTColors(ColorsList[Index]).intColor;
              DBAppGlobals.JobToJobCompColor[I].int := TColor(color);
              color := PTColors(ColorsList[Index]).bdrColor;
              DBAppGlobals.JobToJobCompColor[I].brd := TColor(color);
              color := PTColors(ColorsList[Index]).txtColor;
              DBAppGlobals.JobToJobCompColor[I].txt := TColor(color);
              Index := Index + 1;
              if (Index = ColorsList.Count)
              or (PTColors(ColorsList[Index]).DummyIndex > J) then
                break;
            end;
          end;

          SetLength(DBAppGlobals.SavedJobToJobCompColor, Length(DfltCmpClr));
          for I := Low(DBAppGlobals.JobToJobCompColor) to High(DBAppGlobals.JobToJobCompColor) do
          begin
            DBAppGlobals.SavedJobToJobCompColor[I].int := DBAppGlobals.JobToJobCompColor[I].int;
            DBAppGlobals.SavedJobToJobCompColor[I].brd := DBAppGlobals.JobToJobCompColor[I].brd;
            DBAppGlobals.SavedJobToJobCompColor[I].txt := DBAppGlobals.JobToJobCompColor[I].txt;
            DBAppGlobals.SavedJobToJobCompColor[I].Dsc := DBAppGlobals.JobToJobCompColor[I].Dsc;
          end;

        end;
    1 : begin
          if not Found then
            DefaultComptColors(DBAppGlobals.JobToCapCompColor)
          else
          begin
            SetLength(DBAppGlobals.JobToCapCompColor, Length(DfltCmpClr));
            for i := 0 to high(DfltCmpClr) do
            begin
              color := PTColors(ColorsList[Index]).intColor;
              DBAppGlobals.JobToCapCompColor[I].int := TColor(color);
              color := PTColors(ColorsList[Index]).bdrColor;
              DBAppGlobals.JobToCapCompColor[I].brd := TColor(color);
              color := PTColors(ColorsList[Index]).txtColor;
              DBAppGlobals.JobToCapCompColor[I].txt := TColor(color);
              Index := Index + 1;
              if (Index = ColorsList.Count)
              or (PTColors(ColorsList[Index]).DummyIndex > J) then
                break;
            end;
          end;

          SetLength(DBAppGlobals.SavedJobToCapCompColor, Length(DfltCmpClr));
          for I := Low(DBAppGlobals.JobToCapCompColor) to High(DBAppGlobals.JobToCapCompColor) do
          begin
            DBAppGlobals.SavedJobToCapCompColor[I].int := DBAppGlobals.JobToCapCompColor[I].int;
            DBAppGlobals.SavedJobToCapCompColor[I].brd := DBAppGlobals.JobToCapCompColor[I].brd;
            DBAppGlobals.SavedJobToCapCompColor[I].txt := DBAppGlobals.JobToCapCompColor[I].txt;
            DBAppGlobals.SavedJobToCapCompColor[I].Dsc := DBAppGlobals.JobToCapCompColor[I].Dsc;
          end;

        end;
    2 : begin
          if not Found then
            DefaultComptColors(DBAppGlobals.JobCapToRscCompColor)
          else
          begin
            SetLength(DBAppGlobals.JobCapToRscCompColor, Length(DfltCmpClr));

            for i := 0 to high(DfltCmpClr) do
            begin
              color := PTColors(ColorsList[Index]).intColor;
              DBAppGlobals.JobCapToRscCompColor[I].int := TColor(color);
              color := PTColors(ColorsList[Index]).bdrColor;
              DBAppGlobals.JobCapToRscCompColor[I].brd := TColor(color);
              color := PTColors(ColorsList[Index]).txtColor;
              DBAppGlobals.JobCapToRscCompColor[I].txt := TColor(color);
              Index := Index + 1;
              if (Index = ColorsList.Count)
              or (PTColors(ColorsList[Index]).DummyIndex > J) then
                break;
            end;
          end;

          SetLength(DBAppGlobals.SavedJobCapToRscCompColor, Length(DfltCmpClr));
          for I := Low(DBAppGlobals.JobCapToRscCompColor) to High(DBAppGlobals.JobCapToRscCompColor) do
          begin
            DBAppGlobals.SavedJobCapToRscCompColor[I].int := DBAppGlobals.JobCapToRscCompColor[I].int;
            DBAppGlobals.SavedJobCapToRscCompColor[I].brd := DBAppGlobals.JobCapToRscCompColor[I].brd;
            DBAppGlobals.SavedJobCapToRscCompColor[I].txt := DBAppGlobals.JobCapToRscCompColor[I].txt;
            DBAppGlobals.SavedJobCapToRscCompColor[I].Dsc := DBAppGlobals.JobCapToRscCompColor[I].Dsc;
          end;

        end;
    3 : begin
          if not Found then
            DefaultJobStatusColors(DBAppGlobals.JobStatusColor)
          else
          begin
            SetLength(DBAppGlobals.JobStatusColor, Length(DfltJobStatusClr));
            for i := 0 to high(DfltJobStatusClr) do
            begin
              color := PTColors(ColorsList[Index]).intColor;
              DBAppGlobals.JobStatusColor[I].int := TColor(color);
              color := PTColors(ColorsList[Index]).bdrColor;
              DBAppGlobals.JobStatusColor[I].brd := TColor(color);
              color := PTColors(ColorsList[Index]).txtColor;
              DBAppGlobals.JobStatusColor[I].txt := TColor(color);
              DBAppGlobals.JobStatusColor[I].Dsc := PTColors(ColorsList[Index]).Description;
              Index := Index + 1;
              if (Index = ColorsList.Count)
              or (PTColors(ColorsList[Index]).DummyIndex > J) then
                break;
            end;
          end;

          for I := Low(DfltJobStatusClr) to High(DfltJobStatusClr) do
          begin
            if (DBAppGlobals.JobStatusColor[I].int = 0) and (DBAppGlobals.JobStatusColor[i].Dsc = '') then
            begin
              DBAppGlobals.JobStatusColor[I].int := DfltJobStatusClr[I].int;
              DBAppGlobals.JobStatusColor[I].brd := DfltJobStatusClr[I].brd;
              DBAppGlobals.JobStatusColor[I].txt := DfltJobStatusClr[I].txt;
              DBAppGlobals.JobStatusColor[I].Dsc := DfltJobStatusClr[I].Dsc;
            end;
          end;

          SetLength(DBAppGlobals.savedJobStatusColor, Length(DfltJobStatusClr));
          for I := Low(DBAppGlobals.JobStatusColor) to High(DBAppGlobals.JobStatusColor) do
          begin
            DBAppGlobals.SavedJobStatusColor[I].int := DBAppGlobals.JobStatusColor[I].int;
            DBAppGlobals.SavedJobStatusColor[I].brd := DBAppGlobals.JobStatusColor[I].brd;
            DBAppGlobals.SavedJobStatusColor[I].txt := DBAppGlobals.JobStatusColor[I].txt;
            DBAppGlobals.SavedJobStatusColor[I].Dsc := DBAppGlobals.JobStatusColor[I].Dsc;
          end;

        end;
    4 : begin
          if not Found then
            DefaultJobDateWrnColors(DBAppGlobals.JobDateWarningColor)
          else
          begin
            SetLength(DBAppGlobals.JobDateWarningColor, Length(DfltJobDateWrnClr));
            for i := 0 to high(DfltJobDateWrnClr) do
            begin
              color := PTColors(ColorsList[Index]).intColor;
              DBAppGlobals.JobDateWarningColor[I].int := TColor(color);
              color := PTColors(ColorsList[Index]).bdrColor;
              DBAppGlobals.JobDateWarningColor[I].brd := TColor(color);
              color := PTColors(ColorsList[Index]).txtColor;
              DBAppGlobals.JobDateWarningColor[I].txt := TColor(color);
              DBAppGlobals.JobDateWarningColor[I].Dsc := PTColors(ColorsList[Index]).Description;
              Index := Index + 1;
              if (Index = ColorsList.Count)
              or (PTColors(ColorsList[Index]).DummyIndex > J) then
                break;
            end;
          end;

          SetLength(DBAppGlobals.SavedJobDateWarningColor, Length(DfltJobDateWrnClr));
          for I := Low(DBAppGlobals.JobDateWarningColor) to High(DBAppGlobals.JobDateWarningColor) do
          begin
            DBAppGlobals.SavedJobDateWarningColor[I].int := DBAppGlobals.JobDateWarningColor[I].int;
            DBAppGlobals.SavedJobDateWarningColor[I].brd := DBAppGlobals.JobDateWarningColor[I].brd;
            DBAppGlobals.SavedJobDateWarningColor[I].txt := DBAppGlobals.JobDateWarningColor[I].txt;
            DBAppGlobals.SavedJobDateWarningColor[I].Dsc := DBAppGlobals.JobDateWarningColor[I].Dsc;
          end;

        end;
    5 : begin
          if not Found then
            DefaultJobMatWrnColors(DBAppGlobals.JobMatWarningColor)
          else
          begin
            SetLength(DBAppGlobals.JobMatWarningColor, Length(DfltJobMatWrnClr));
            for i := 0 to high(DfltJobMatWrnClr) do
            begin
              color := PTColors(ColorsList[Index]).intColor;
              DBAppGlobals.JobMatWarningColor[I].int := TColor(color);
              color := PTColors(ColorsList[Index]).bdrColor;
              DBAppGlobals.JobMatWarningColor[I].brd := TColor(color);
              color := PTColors(ColorsList[Index]).txtColor;
              DBAppGlobals.JobMatWarningColor[I].txt := TColor(color);
              DBAppGlobals.JobMatWarningColor[I].Dsc := PTColors(ColorsList[Index]).Description;
              Index := Index + 1;
              if (Index = ColorsList.Count)
              or (PTColors(ColorsList[Index]).DummyIndex > J) then
                break;
            end;
          end;

          SetLength(DBAppGlobals.SavedJobMatWarningColor, Length(DfltJobMatWrnClr));
          for I := Low(DBAppGlobals.JobMatWarningColor) to High(DBAppGlobals.JobMatWarningColor) do
          begin
            DBAppGlobals.SavedJobMatWarningColor[I].int := DBAppGlobals.JobMatWarningColor[I].int;
            DBAppGlobals.SavedJobMatWarningColor[I].brd := DBAppGlobals.JobMatWarningColor[I].brd;
            DBAppGlobals.SavedJobMatWarningColor[I].txt := DBAppGlobals.JobMatWarningColor[I].txt;
            DBAppGlobals.SavedJobMatWarningColor[I].Dsc := DBAppGlobals.JobMatWarningColor[I].Dsc;
          end;

        end;
    6 : begin
          if not Found then
            DefaultResColors(DBAppGlobals.ResColors)
          else
          begin
            SetLength(DBAppGlobals.ResColors, Length(DfltRscClr));
            for i := 0 to high(DfltCmpClr) do
            begin
              color := PTColors(ColorsList[Index]).intColor;
              DBAppGlobals.ResColors[I].int := TColor(color);
              color := PTColors(ColorsList[Index]).bdrColor;
              DBAppGlobals.ResColors[I].brd := TColor(color);
              color := PTColors(ColorsList[Index]).txtColor;
              DBAppGlobals.ResColors[I].txt := TColor(color);
              DBAppGlobals.ResColors[I].Dsc := PTColors(ColorsList[Index]).Description;
              Index := Index + 1;
              if (Index = ColorsList.Count)
              or (PTColors(ColorsList[Index]).DummyIndex > J) then
                break;
            end;
          end;

          SetLength(DBAppGlobals.SavedResColors, Length(DfltRscClr));
          for I := Low(DBAppGlobals.ResColors) to High(DBAppGlobals.ResColors) do
          begin
            DBAppGlobals.SavedResColors[I].int := DBAppGlobals.ResColors[I].int;
            DBAppGlobals.SavedResColors[I].brd := DBAppGlobals.ResColors[I].brd;
            DBAppGlobals.SavedResColors[I].txt := DBAppGlobals.ResColors[I].txt;
            DBAppGlobals.SavedResColors[I].Dsc := DBAppGlobals.ResColors[I].Dsc;
          end;

        end;
    7 : begin
          if not Found then
            DefaultCapResColors(DBAppGlobals.CapResColors)
          else
          begin
            SetLength(DBAppGlobals.CapResColors, Length(DfltCmpClr));
            for i := 0 to high(DfltCmpClr) do
            begin
              color := PTColors(ColorsList[Index]).intColor;
              DBAppGlobals.CapResColors[I].int := TColor(color);
              color := PTColors(ColorsList[Index]).bdrColor;
              DBAppGlobals.CapResColors[I].brd := TColor(color);
              color := PTColors(ColorsList[Index]).txtColor;
              DBAppGlobals.CapResColors[I].txt := TColor(color);
              DBAppGlobals.CapResColors[I].Dsc := PTColors(ColorsList[Index]).Description;
              Index := Index + 1;
              if (Index = ColorsList.Count)
              or (PTColors(ColorsList[Index]).DummyIndex > J) then
                break;
            end;
          end;

          SetLength(DBAppGlobals.SavedCapResColors, Length(DfltCmpClr));
          for I := Low(DBAppGlobals.CapResColors) to High(DBAppGlobals.CapResColors) do
          begin
            DBAppGlobals.SavedCapResColors[I].int := DBAppGlobals.CapResColors[I].int;
            DBAppGlobals.SavedCapResColors[I].brd := DBAppGlobals.CapResColors[I].brd;
            DBAppGlobals.SavedCapResColors[I].txt := DBAppGlobals.CapResColors[I].txt;
            DBAppGlobals.SavedCapResColors[I].Dsc := DBAppGlobals.CapResColors[I].Dsc;
          end;

        end;
    end;
  end;

  for I := 0 to ColorsList.Count - 1 do
     Dispose(PTColors(ColorsList[I]));
  ColorsList.free;

end;

procedure LoadColorsOld;
var
  qry: TMqmQuery;
  tbInfo: ^TTblInfo;
  I,color:integer;
  ColrCmptTbl : Table;
  J : Integer;
  Description : String;
begin

  ColrCmptTbl := tbl_cfg_colorJobToJob;
  qry := CreateQuery(Cfg_DB);

  for J := 0 to 7 do
  begin
    case J of
      0 : ColrCmptTbl := tbl_cfg_colorJobToJob;
      1 : ColrCmptTbl := tbl_cfg_clrCapToJob;
      2 : ColrCmptTbl := tbl_cfg_colorJobToRes;
      3 : ColrCmptTbl := tbl_cfg_colorStatus;
      4 : ColrCmptTbl := tbl_cfg_colorDateWarn;
      5 : ColrCmptTbl := tbl_cfg_colorMatWarn;
      6 : ColrCmptTbl := tbl_cfg_clrRes;
      7 : ColrCmptTbl := tbl_cfg_clrCapRes;
    end;

    tbInfo := @tblInfo[ColrCmptTbl];
//    SetFldPfx(tbInfo.pfx);

    qry.SQL.Add('select * from ' + tbInfo.GetTableName + ' where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + '=''' + IniAppGlobals.WkstCode + '''');
    qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
    qry.SQL.Add('Order by ' + CreateFld(tbInfo.pfx, fli_ValFrom));
    qry.open;

    case J of
      0 : begin

            if qry.Eof then
               DefaultComptColors(DBAppGlobals.JobToJobCompColor)
            else
            begin
              SetLength(DBAppGlobals.JobToJobCompColor, Length(DfltCmpClr));
              for i := 0 to high(DfltCmpClr) do
              begin
             //   numfrom := qry.FieldByName(CreatePfxFld(fli_ValFrom)).AsInteger;
             //   DBAppGlobals.JobToJobCompColor[I].lim := numfrom;
                color := qry.FieldByName(CreateFld(tbInfo.pfx, Fli_intColor)).AsInteger;
                DBAppGlobals.JobToJobCompColor[I].int := TColor(color);
                color := qry.FieldByName(CreateFld(tbInfo.pfx, Fli_bdrColor)).AsInteger;
                DBAppGlobals.JobToJobCompColor[I].brd := TColor(color);
                color := qry.FieldByName(CreateFld(tbInfo.pfx, Fli_txtColor)).AsInteger;
                DBAppGlobals.JobToJobCompColor[I].txt := TColor(color);
                qry.Next;
                if qry.Eof then break;
              end;
         {     while I < Length(DBAppGlobals.JobToJobCompColor) do
              begin
                DBAppGlobals.JobToJobCompColor[I] := DfltCmpClr[I];
                DBAppGlobals.JobToJobCompColor[I].Dsc := _(DfltCmpClr[I].Dsc);
                I := I +1;
              end;  }
            end;
          end;

      1 : begin

            if qry.Eof then
               DefaultComptColors(DBAppGlobals.JobToCapCompColor)
            else
            begin
              SetLength(DBAppGlobals.JobToCapCompColor, Length(DfltCmpClr));
              for i := 0 to high(DfltCmpClr) do
              begin
             //   numfrom := qry.FieldByName(CreatePfxFld(fli_ValFrom)).AsInteger;
             //   DBAppGlobals.JobToCapCompColor[I].lim := numfrom;
                color := qry.FieldByName(CreateFld(tbInfo.pfx, Fli_intColor)).AsInteger;
                DBAppGlobals.JobToCapCompColor[I].int := TColor(color);
                color := qry.FieldByName(CreateFld(tbInfo.pfx, Fli_bdrColor)).AsInteger;
                DBAppGlobals.JobToCapCompColor[I].brd := TColor(color);
                color := qry.FieldByName(CreateFld(tbInfo.pfx, Fli_txtColor)).AsInteger;
                DBAppGlobals.JobToCapCompColor[I].txt := TColor(color);
                qry.Next;
                if qry.Eof then break;
              end;
            {  while I < Length(DBAppGlobals.JobToCapCompColor) do
              begin
                DBAppGlobals.JobToCapCompColor[I] := DfltCmpClr[I];
                DBAppGlobals.JobToCapCompColor[I].Dsc := _(DfltCmpClr[I].Dsc);
                I := I +1;
              end;    }
            end;
          end;

      2 : begin

            if qry.Eof then
               DefaultComptColors(DBAppGlobals.JobCapToRscCompColor)
            else
            begin
              SetLength(DBAppGlobals.JobCapToRscCompColor, Length(DfltCmpClr));
              for i := 0 to high(DfltCmpClr) do
              begin
            //    numfrom := qry.FieldByName(CreatePfxFld(fli_ValFrom)).AsInteger;
            //    DBAppGlobals.JobCapToRscCompColor[I].lim := numfrom;
                color := qry.FieldByName(CreateFld(tbInfo.pfx, Fli_intColor)).AsInteger;
                DBAppGlobals.JobCapToRscCompColor[I].int := TColor(color);
                color := qry.FieldByName(CreateFld(tbInfo.pfx, Fli_bdrColor)).AsInteger;
                DBAppGlobals.JobCapToRscCompColor[I].brd := TColor(color);
                color := qry.FieldByName(CreateFld(tbInfo.pfx, Fli_txtColor)).AsInteger;
                DBAppGlobals.JobCapToRscCompColor[I].txt := TColor(color);
                qry.Next;
                if qry.Eof then break;
              end;
           {   while I < Length(DBAppGlobals.JobCapToRscCompColor) do
              begin
                DBAppGlobals.JobCapToRscCompColor[I] := DfltCmpClr[I];
                DBAppGlobals.JobCapToRscCompColor[I].Dsc := _(DfltCmpClr[I].Dsc);
                I := I +1;
              end;   }
            end;
          end;

      3 : begin

            if qry.Eof then
               DefaultJobStatusColors(DBAppGlobals.JobStatusColor)
            else
            begin
              SetLength(DBAppGlobals.JobStatusColor, Length(DfltJobStatusClr));
              for i := 0 to high(DfltJobStatusClr) do
              begin
//                SetLength(DBAppGlobals.ErrorsColor, I + 1);
           //     numfrom := qry.FieldByName(CreatePfxFld(fli_ValFrom)).AsInteger;
           //     DBAppGlobals.ErrorsColor[I].lim := numfrom;
                color := qry.FieldByName(CreateFld(tbInfo.pfx, Fli_intColor)).AsInteger;
                DBAppGlobals.JobStatusColor[I].int := TColor(color);
                color := qry.FieldByName(CreateFld(tbInfo.pfx, Fli_bdrColor)).AsInteger;
                DBAppGlobals.JobStatusColor[I].brd := TColor(color);
                color := qry.FieldByName(CreateFld(tbInfo.pfx, Fli_txtColor)).AsInteger;
                DBAppGlobals.JobStatusColor[I].txt := TColor(color);
                Description := qry.FieldByName(CreateFld(tbInfo.pfx, Fli_txtDescription)).AsString;
                DBAppGlobals.JobStatusColor[I].dsc := Description;
                qry.Next;
                if qry.Eof then break;
              end;
           {   while I < Length(DBAppGlobals.JobStatusColor) do
              begin
                DBAppGlobals.JobStatusColor[I] := DfltJobStatusClr[I];
                DBAppGlobals.JobStatusColor[I].Dsc := _(DfltJobStatusClr[I].Dsc);
                I := I +1;
              end;   }
            end;
          end;

      4 : begin

            if qry.Eof then
               DefaultJobDateWrnColors(DBAppGlobals.JobDateWarningColor)
            else
            begin
              DefaultJobDateWrnColors(DBAppGlobals.JobDateWarningColor);
              SetLength(DBAppGlobals.JobDateWarningColor, Length(DfltJobDateWrnClr));
              for i := 0 to high(DfltJobDateWrnClr) do
              begin
                color := qry.FieldByName(CreateFld(tbInfo.pfx, Fli_intColor)).AsInteger;
                DBAppGlobals.JobDateWarningColor[I].int := TColor(color);
                color := qry.FieldByName(CreateFld(tbInfo.pfx, Fli_bdrColor)).AsInteger;
                DBAppGlobals.JobDateWarningColor[I].brd := TColor(color);
                color := qry.FieldByName(CreateFld(tbInfo.pfx, Fli_txtColor)).AsInteger;
                DBAppGlobals.JobDateWarningColor[I].txt := TColor(color);
                Description := qry.FieldByName(CreateFld(tbInfo.pfx, Fli_txtDescription)).AsString;
                DBAppGlobals.JobDateWarningColor[I].dsc := Description;
                qry.Next;
                if qry.Eof then break;
              end;
           {   while I < Length(DBAppGlobals.JobDateWarningColor) do
              begin
                DBAppGlobals.JobDateWarningColor[I] := DfltJobDateWrnClr[I];
                DBAppGlobals.JobDateWarningColor[I].Dsc := _(DfltJobDateWrnClr[I].Dsc);
                I := I +1;
              end;  }
            end;
          end;

      5 : begin

            if qry.Eof then
               DefaultJobMatWrnColors(DBAppGlobals.JobMatWarningColor)
            else
            begin
              SetLength(DBAppGlobals.JobMatWarningColor, Length(DfltJobMatWrnClr));
              for i := 0 to high(DfltJobMatWrnClr) do
              begin
                color := qry.FieldByName(CreateFld(tbInfo.pfx, Fli_intColor)).AsInteger;
                DBAppGlobals.JobMatWarningColor[I].int := TColor(color);
                color := qry.FieldByName(CreateFld(tbInfo.pfx, Fli_bdrColor)).AsInteger;
                DBAppGlobals.JobMatWarningColor[I].brd := TColor(color);
                color := qry.FieldByName(CreateFld(tbInfo.pfx, Fli_txtColor)).AsInteger;
                DBAppGlobals.JobMatWarningColor[I].txt := TColor(color);
                Description := qry.FieldByName(CreateFld(tbInfo.pfx, Fli_txtDescription)).AsString;
                DBAppGlobals.JobMatWarningColor[I].dsc := Description;
                qry.Next;
                if qry.Eof then break;
              end;
           {   while I < Length(DBAppGlobals.JobMatWarningColor) do
              begin
                DBAppGlobals.JobMatWarningColor[I] := DfltJobMatWrnClr[I];
                DBAppGlobals.JobMatWarningColor[I].Dsc := _(DfltJobMatWrnClr[I].Dsc);
                I := I +1;
              end;   }
            end;
          end;

      6 : begin

            if qry.Eof then
               DefaultResColors(DBAppGlobals.ResColors)
            else
            begin
              SetLength(DBAppGlobals.ResColors, Length(DfltRscClr));
              for i := 0 to high(DfltRscClr) do
              begin
           //     numfrom := qry.FieldByName(CreatePfxFld(fli_ValFrom)).AsInteger;
           //     DBAppGlobals.ErrorsColor[I].lim := numfrom;
                color := qry.FieldByName(CreateFld(tbInfo.pfx, Fli_intColor)).AsInteger;
                DBAppGlobals.ResColors[I].int := TColor(color);
                color := qry.FieldByName(CreateFld(tbInfo.pfx, Fli_bdrColor)).AsInteger;
                DBAppGlobals.ResColors[I].brd := TColor(color);
                color := qry.FieldByName(CreateFld(tbInfo.pfx, Fli_txtColor)).AsInteger;
                DBAppGlobals.ResColors[I].txt := TColor(color);
                Description := qry.FieldByName(CreateFld(tbInfo.pfx, Fli_txtDescription)).AsString;
                DBAppGlobals.ResColors[I].dsc := Description ;
                qry.Next;
                if qry.Eof then break;
              end;
            {  while I < Length(DBAppGlobals.ResColors) do
              begin
                DBAppGlobals.ResColors[I] := DfltRscClr[I];
                DBAppGlobals.ResColors[I].Dsc := _(DfltRscClr[I].Dsc);
                I := I +1;
              end;   }
            end;
          end;


      7 : begin

            if qry.Eof then
               DefaultCapResColors(DBAppGlobals.CapResColors)
            else
            begin
              I := 0;
              while not qry.Eof do
              begin
                SetLength(DBAppGlobals.CapResColors, I + 1);
           //     numfrom := qry.FieldByName(CreatePfxFld(fli_ValFrom)).AsInteger;
           //     DBAppGlobals.ErrorsColor[I].lim := numfrom;
                color := qry.FieldByName(CreateFld(tbInfo.pfx, Fli_intColor)).AsInteger;
                DBAppGlobals.CapResColors[I].int := TColor(color);
                color := qry.FieldByName(CreateFld(tbInfo.pfx, Fli_bdrColor)).AsInteger;
                DBAppGlobals.CapResColors[I].brd := TColor(color);
                color := qry.FieldByName(CreateFld(tbInfo.pfx, Fli_txtColor)).AsInteger;
                DBAppGlobals.CapResColors[I].txt := TColor(color);
                Description := qry.FieldByName(CreateFld(tbInfo.pfx, Fli_txtDescription)).AsString;
                DBAppGlobals.CapResColors[I].dsc := Description ;
                I := I + 1;
                qry.Next;
              end;
            end;
          end;
    end;

    qry.Close;
    qry.SQL.Clear;

  end;

  qry.free;
end;

//----------------------------------------------------------------------------//

procedure GlobLoadLocValues;
begin
  with LocAppGlobals do
  begin
    ReadStrFromIniFile(RgMqmSezCfg, RgCfgImgDir, ImgDir);
    ReadStrFromIniFile(RgMqmSezCfg, RgCfgLangDir, LangDir);
  end;
end;

//----------------------------------------------------------------------------//

procedure LoadPropBin;
var
  qry:       TMqmQuery;
  tbBinProp :  ^TTblInfo;
  i: integer;
begin
  tbBinProp := @tblInfo[tbl_cfg_bin_showProp];
  qry := CreateQuery(Cfg_DB);

  // load the Properties to show in Bin

  with qry do
  begin
  //WARNING THE QUERY FIELDS ARE ACCESSED BY INDEX!
    SQL.Add('select');
    for i := 1 to 60 do
    begin
      if i < 60 then
        SQL.Add(CreateFld(tbBinProp.pfx, fli_FiltPropCode) + IntToStr(i) + ',')
      else
        SQL.Add(CreateFld(tbBinProp.pfx, fli_FiltPropCode) + IntToStr(i));
    end;
    SQL.Add(' from ' + tbBinProp.GetTableName);
    SQL.Add(' where ' + CreateFld(tbBinProp.pfx, fli_wkstCode) + '=');
    SQL.Add('''' + IniAppGlobals.WkstCode + '''');
    SQL.Add(AND_IDF_Condition(CreateFld(tbBinProp.pfx, fli_Identifier)));
    Open;
    First;

    for i := 1 to 60 do
    begin
      if (FieldByName(CreateFld(tbBinProp.pfx, fli_FiltPropCode) + IntToStr(i)).AsString) <> '' then
        DBAppGlobals.ShowBinPropArry[i-1] := GetIdFromCode(FieldByName(CreateFld(tbBinProp.pfx, fli_FiltPropCode) + IntToStr(i)).AsString)
      else
        DBAppGlobals.ShowBinPropArry[i-1] := nil;
    end;
    Close;
  end;

  qry.Free;
end;

//----------------------------------------------------------------------------//

procedure GlobLoadDbValues(ProgBar: TMqmProgBar; Status: TStaticText);
var
  qry, qryMain: TMqmQuery;
  tbInfoProdSched, tbInfoRes, tbInfoWorkCntrStation, tbInfoStockDetails, tbInfocfg_appGlob : ^TTblInfo;
  Str   : string;
  EarliestDate : TDateTime;
  TableNameProdSched, TableRes, WorkCntrStation : string;
begin

  if Assigned(Status) then
    Status.Caption := _('Loading global database values...');
  Application.ProcessMessages;

  LoadColors;
  LoadPropBin;

  DBAppGlobals.Change_AutoRunDefinition := false;

  DBAppGlobals.StDateForPlan := trunc(now) - 2 * 31;
  DBAppGlobals.EndDateForPlan := trunc(now) + 2 * 365 + 180;
  EarliestDate := trunc(now - 365);

  tbInfocfg_appGlob := @tblInfo[tbl_cfg_appGlob];
  tbInfoProdSched := @tblInfo[tbl_prod_sched];
  tbInfoRes := @tblInfo[tbl_res];
  tbInfoWorkCntrStation := @tblInfo[tbl_wkst_wkc];

  TableNameProdSched := tbInfoProdSched.GetTableName;
  TableRes           := tbInfoRes.GetTableName;
  WorkCntrStation      := tbInfoWorkCntrStation.GetTableName;

  qry := CreateQuery(Cfg_DB);

  qryMain := CreateQuery(main_DB);



  Str := '';
  str := ' select min(' + TableNameProdSched + '.' + CreateFld(tbInfoProdSched.pfx, fli_schedStart) + ')' + ' as LowestDate ';
  str := str + ' from ' + TableNameProdSched;
  str := str + ' left join ' + TableRes + ' on ' + TableRes + '.RS_RSC_CODE = ' + TableNameProdSched + '.' + CreateFld(tbInfoProdSched.pfx, fli_rsc) +
             ' AND ' + TableRes + '.RS_IDENTIFIER = ' + TableNameProdSched + '.' + CreateFld(tbInfoProdSched.pfx, fli_identifier);
  str := str + ' left join ' + WorkCntrStation + ' ON WW_WKST_CODE =''' + IniAppGlobals.WkstCode + '''' + ' and WW_WKCNTER = RS_WKCNTER ' +
               ' and WW_IDENTIFIER = RS_IDENTIFIER';
  if IniAppGlobals.DownloadTo = '2' then
    str := str + ' where WW_WKCNTER IS NOT NULL AND ' + CreateFld(tbInfoProdSched.pfx, fli_schedStart) + '  > ''' + FormatDateMMDDYYYYWithSlash(EarliestDate) + ''''
  else
    str := str + ' where WW_WKCNTER IS NOT NULL AND ' + CreateFld(tbInfoProdSched.pfx, fli_schedStart) + '  > ' + ConvertDateFormatDb2Oracle(EarliestDate, true, true);
  str := str + AND_IDF_Condition(CreateFld(tbInfoRes.pfx, fli_Identifier));

  qryMain.SQL.Clear;
  qryMain.SQL.Add(str);
  qryMain.Open;

  if not qryMain.Eof
  and not qryMain.FieldByName('LowestDate').IsNull
  and (qryMain.FieldByName('LowestDate').AsDateTime < DBAppGlobals.StDateForPlan) then
    DBAppGlobals.StDateForPlan := qryMain.FieldByName('LowestDate').AsDateTime - 1;
  qryMain.Close;

  qry.SQL.Clear;
  qry.SQL.Add('select * from ' + tbInfocfg_appGlob.GetTableName + ' where ' + CreateFld(tbInfocfg_appGlob.pfx, fli_wkstCode) + '=''' + IniAppGlobals.WkstCode + '''');
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfocfg_appGlob.pfx, fli_Identifier)));
  qry.Open;

  with DBAppGlobals do
  begin
    // set values from db into AppGlobals
    if not qry.EOF then
    begin
      EnvDescr        := qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_EnvDescr)).AsString;
      Customer        := qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_Customer)).AsString;
      Language        := qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_Language)).AsString;
      CurrTScale      := qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_CurrTScale)).AsInteger;
      CurrDtTime      := qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_CurrDtTime)).AsDateTime;
      ShowCal         := qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_ShowCal)).AsInteger;
      CurrRscSort     := qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_CurrRscSort)).AsInteger;
      ShowZoom        := qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_ShowZoom)).AsInteger;
      SelRscOrderType := qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_RscOrderType)).AsString;
      SelRscOrderItem := qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_RscOrderItem)).AsString;

      WdwPlanLeft   := qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_wdwPlanLeft)).AsInteger;
      WdwPlanTop    := qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_wdwPlanTop)).AsInteger;

      if qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_wdwPlanWidth)).AsInteger > WdwPlanWidth then
        WdwPlanWidth := qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_wdwPlanWidth)).AsInteger;
      if qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_wdwPlanHeight)).AsInteger > WdwPlanHeight then
        WdwPlanHeight := qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_wdwPlanHeight)).AsInteger;

      if qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_wdwPlanstate)).AsInteger = 1 then  // planstate
        WdwPlanState := true
      else
        WdwPlanState := false;

      WdwBinDock := qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_wdwBinDock)).AsInteger;
      Wdwbinleft := qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_wdwBinLeft)).AsInteger;
      Wdwbintop := qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_wdwBinTop)).AsInteger;
      Wdwbinwidth := qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_wdwBinWidth)).AsInteger;
      Wdwbinheight := qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_wdwBinHeight)).AsInteger;
      if (qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_wdwBinState)).AsInteger) = 1 then  // binstate
        WdwBinState := true
      else
        WdwBinState := false;
      WdwbinsplitterH := qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_wdwBinSplitter)).AsInteger;

      ToolBarDock      := qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_ToolBarDock)).AsInteger; // 0=Undocked  1=Right Dock    -1=Bottom Dock
      ToolBarLeft      := qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_ToolBarLeft)).AsInteger;
      ToolBarTop       := qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_ToolBarTop )).AsInteger;
      ToolBarWidth     := qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_ToolBarWidth)).AsInteger;
      ToolBarHeight    := qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_ToolBarHeight)).AsInteger;
      if ( qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_ToolBarState)).AsInteger) = 1 then
        ToolBarState := true
      else
        ToolBarState := false;

      if (qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_CheckStepSeq)).AsInteger) = 1 then  // Check step sequence
        CheckStepSeq := true
      else
        CheckStepSeq := false;

      if (qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_UnscheduleClosedJobsOnStart)).AsString) = '0' then
        UnscheduleJobsOnStart := '0'
      else if (qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_UnscheduleClosedJobsOnStart)).AsString) = '1' then
        UnscheduleJobsOnStart := '1'
      else if (qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_UnscheduleClosedJobsOnStart)).AsString) = '2' then
        UnscheduleJobsOnStart := '2'
      else
        UnscheduleJobsOnStart := '0';

      if (qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_CenterStartOnMove)).AsInteger) = 1 then
        CenterStartOnMove := true
      else
        CenterStartOnMove := false;

      if (qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_WarnOnMoveFinal)).AsInteger) = 1 then
        WarnOnMoveFinal := true
      else
        WarnOnMoveFinal := false;

      DefSchedType := qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_DefSchedType)).AsInteger;
      ConfLevels   := qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_ConfLevels)).AsInteger;
      MoveOption   := qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_MoveOption)).AsInteger;
      ActAutoSched := qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_ActAutoSchedCode)).AsString;

      if (qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_ShowColorJobMode)).AsString = '1') then
        ShowColorJobMode := PreDefinedPropList
      else if (qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_ShowColorJobMode)).AsString = '2') then
        ShowColorJobMode := DinamicPropList
      else
        ShowColorJobMode := Standard;
      if (ShowColorJobMode <> Standard) then
         LastPropColorInUseJobMode := qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_PropertyCode)).AsString;

    //  LastUpdatNr := GetLastUpdatedNumber;
    end;
    LastUpdatNr := GetLastUpdatedNumber;
    LastUpdatCapResNr := GetLastUpdatedCapResNumber;

    MCMSlotDisplay := qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_SlotDisplay)).AsInteger;

    if qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_CustomSlotDisplay)).asInteger = 1 then
      MCMCustomQty :=  True
    else
      MCMCustomQty := False;

    MCMCustomProp := qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_CustomPropDisplay)).AsString;
    MCMCustomPropSymbol := qry.FieldByName(CreateFld(tbInfocfg_appGlob.pfx, fli_CustomPROPSymbol)).AsString;

  end;

  qry.close;


  tbInfoStockDetails := @tblInfo[tbl_StockDetails];
  with qryMain do
  begin
    SQL.Clear;
    SQL.Add('select * From ' + tbInfoStockDetails.GetTableName);
    SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfoStockDetails.pfx, fli_Identifier)));
    Open;
    if not EOF then
      DBAppGlobals.StockDetailsHandled := true
    else
      DBAppGlobals.StockDetailsHandled := false;
    close;
  end;

  qry.Free;

end;

//----------------------------------------------------------------------------//

function EncodeSettings: string;
begin
  with DBAppSettings do
  begin
    if DisableCapRes then
      Result := '1'
    else
      Result := '0';

    if TabResSort then
      Result := Result + '1'
    else
      Result := Result + '0';

    if TabKeepSort then
      Result := Result + '1'
    else
      Result := Result + '0';

    if TabFilterRead then
      Result := Result + '1'
    else
      Result := Result + '0';

    if TabWorkcenter then
      Result := Result + '1'
    else
      Result := Result + '0';

    if TabNoTimings then
      Result := Result + '1'
    else
      Result := Result + '0';

    if TabNoCompat then
      Result := Result + '1'
    else
      Result := Result + '0';

    if FixColCompVis then
      Result := Result + '1'
    else
      Result := Result + '0';

    if FixColStatVis then
      Result := Result + '1'
    else
      Result := Result + '0';

    if FixColDelDVis then
      Result := Result + '1'
    else
      Result := Result + '0';

    if FixColMatDVis then
      Result := Result + '1'
    else
      Result := Result + '0';

    if FixColLowDVis then
      Result := Result + '1'
    else
      Result := Result + '0';

    if FixColHigDVis then
      Result := Result + '1'
    else
      Result := Result + '0';

    if FixColOvlpVis then
      Result := Result + '1'
    else
      Result := Result + '0';

    if FixColDatesVis then
      Result := Result + '1'
    else
      Result := Result + '0';

    if FixColJobMsgVis then
      Result := Result + '1'
    else
      Result := Result + '0';

    if ShowInBinOnMove then
      Result := Result + '1'
    else
      Result := Result + '0';

    if BinMultiLineTab then
      Result := Result + '1'
    else
      Result := Result + '0';

    if ForceOverlap = FOL_No then
       Result := Result + '0'
    else if ForceOverlap = FOL_Yes then
       Result := Result + '1'
    else if ForceOverlap = FOL_Forceable then
       Result := Result + '2';

//    else if ShowContinueGroupLinesInBin = '1' then  // (not in use anymore)
//      Result := Result + '1'
//    else
//      Result := Result + '2';

//    if ShowContinueGroupLinesInBin = '0' then // not in use anymore
//      Result := Result + '0'
//    else if ShowContinueGroupLinesInBin = '1' then  // (not in use anymore)
//      Result := Result + '1'
//    else
//      Result := Result + '2';

    if ShowBinToolBar then
      Result := Result + '1'
    else
      Result := Result + '0';

    if ChkDelDate then
      Result := Result + '1'
    else
      Result := Result + '0';

    if ChkMaterials then
      Result := Result + '1'
    else
      Result := Result + '0';

    if ChkPrevStpQty then
      Result := Result + '1'
    else
      Result := Result + '0';

    if ChkAddRes then
      Result := Result + '1'
    else
      Result := Result + '0';

    if ChkLowStart then
      Result := Result + '1'
    else
      Result := Result + '0';

    if ChkHighEnd then
      Result := Result + '1'
    else
      Result := Result + '0';

    if ChkLinkOvlp then
      Result := Result + '1'
    else
      Result := Result + '0';

    if ShowRowInBin then
      Result := Result + '1'
    else
      Result := Result + '0';

    if RefreshBinByButton then
      Result := Result + '1'
    else
      Result := Result + '0';

    if GanttMultiLineTab then
      Result := Result + '1'
    else
      Result := Result + '0';

    if ShowBatchGroupLinesInBin then  // not in use anymore
      Result := Result + '0'
    else
      Result := Result + '0';

    if JobMoveWitoutConfirmation then
      Result := Result + '1'
    else
      Result := Result + '0';

    if ReportTimeFormat = '1' then
      Result := Result + '1'
    else
      Result := Result + '0';

    if CalDayFormat = '0' then
      Result := Result + '0'
    else if CalDayFormat = '1' then
      Result := Result + '1'
    else if CalDayFormat = '2' then
      Result := Result + '2'
    else
      Result := Result + '3';

    if ShowBinPropColors then
      Result := Result + '1'
    else
      Result := Result + '0';

    if CreateNewBinTabForCompatibles = NewB_No then
       Result := Result + '0'
    else if CreateNewBinTabForCompatibles = NewB_Yes_OnlyCompatibleAndToSchedJobs then
       Result := Result + '1'
    else if CreateNewBinTabForCompatibles = NewB_Yes_MarkCompatibleAndToSchedJobs then
       Result := Result + '2'
    else if CreateNewBinTabForCompatibles = NewB_Yes_ShowOnlyCompatibles then
       Result := Result + '3';

    if ShowCompatibleInExistingBINS = ShowC_No then
       Result := Result + '0'
    else if ShowCompatibleInExistingBINS = ShowC_Yes_MarkTheCompatibles then
       Result := Result + '1'
    else if ShowCompatibleInExistingBINS = ShowC_Yes_ShowOnlyCompatibles then
       Result := Result + '2';

    if ShowScheduledJobsOfSelectedResource = ShowS_No then
       Result := Result + '0'
    else if ShowScheduledJobsOfSelectedResource = ShowS_Yes then
       Result := Result + '1';

    if WarningWhenMaxNumCompChanged then
      Result := Result + '1'
    else
      Result := Result + '0';

    if CapResStartEnd then
      Result := Result + '1'
    else
      Result := Result + '0';

  end
end;

//----------------------------------------------------------------------------//

procedure DecodeSettings(str: string);
var
  TempChar : string;
begin
  with DBAppSettings do
  begin
    DisableCapRes := (Copy(str, 1, 1) = '1');
    TabResSort    := (Copy(str, 2, 1) = '1');
    TabKeepSort   := (Copy(str, 3, 1) = '1');
    TabFilterRead := (Copy(str, 4, 1) = '1');
    TabWorkcenter := (Copy(str, 5, 1) = '1');
    TabNoTimings  := (Copy(str, 6, 1) = '1');
    TabNoCompat   := (Copy(str, 7, 1) = '1');
    FixColCompVis := (Copy(str, 8, 1) = '1');
    FixColStatVis := (Copy(str, 9, 1) = '1');
    FixColDelDVis := (Copy(str, 10, 1) = '1');
    FixColMatDVis := (Copy(str, 11, 1) = '1');
    FixColLowDVis := (Copy(str, 12, 1) = '1');
    FixColHigDVis := (Copy(str, 13, 1) = '1');
    FixColOvlpVis := (Copy(str, 14, 1) = '1');
    FixColDatesVis     := (Copy(str, 15, 1) = '1');
    FixColJobMsgVis    := (Copy(str, 16, 1) = '1');
    ShowInBinOnMove    := (Copy(str, 17, 1) = '1');
    BinMultiLineTab    := (Copy(str, 18, 1) = '1');
    TempChar           := Copy(str, 19, 1);
    if TempChar = '0' then
      ForceOverlap := FOL_No
    else if TempChar = '1' then
      ForceOverlap := FOL_Yes
    else if TempChar = '2' then
      ForceOverlap := FOL_Forceable;

    ShowBinToolBar := (Copy(str, 20, 1) = '1');
    ChkDelDate    := (Copy(str, 21, 1) = '1');
    ChkMaterials  := (Copy(str, 22, 1) = '1');
    ChkPrevStpQty := (Copy(str, 23, 1) = '1');
    ChkAddRes     := (Copy(str, 24, 1) = '1');
    ChkLowStart   := (Copy(str, 25, 1) = '1');
    ChkHighEnd    := (Copy(str, 26, 1) = '1');
    ChkLinkOvlp   := (Copy(str, 27, 1) = '1');
    ShowRowInBin  := (Copy(str, 28, 1) = '1');
    RefreshBinByButton := (Copy(str, 29, 1) = '1');
    GanttMultiLineTab := (Copy(str, 30, 1) = '1');
    ShowBatchGroupLinesInBin    := (Copy(str, 31, 1) = '1'); // not in use anymore
    JobMoveWitoutConfirmation   := (Copy(str, 32, 1) = '1');
    if (Copy(str, 33, 1) = '1') then
      ReportTimeFormat := '1'
    else
      ReportTimeFormat := '0';

    CalDayFormat := Copy(str, 34, 1);
    ShowBinPropColors := (Copy(str, 35, 1) = '1');

    TempChar           := Copy(str, 36, 1);
    if TempChar = '0' then
      CreateNewBinTabForCompatibles := NewB_No
    else if TempChar = '1' then
      CreateNewBinTabForCompatibles := NewB_Yes_OnlyCompatibleAndToSchedJobs
    else if TempChar = '2' then
      CreateNewBinTabForCompatibles := NewB_Yes_MarkCompatibleAndToSchedJobs
    else if TempChar = '3' then
      CreateNewBinTabForCompatibles := NewB_Yes_ShowOnlyCompatibles;

    TempChar           := Copy(str, 37, 1);
    if TempChar = '0' then
      ShowCompatibleInExistingBINS := ShowC_No
    else if TempChar = '1' then
      ShowCompatibleInExistingBINS := ShowC_Yes_MarkTheCompatibles
    else if TempChar = '2' then
      ShowCompatibleInExistingBINS := ShowC_Yes_ShowOnlyCompatibles;

    TempChar           := Copy(str, 38, 1);
    if TempChar = '0' then
      ShowScheduledJobsOfSelectedResource := ShowS_No
    else if TempChar = '1' then
      ShowScheduledJobsOfSelectedResource := ShowS_Yes;

    WarningWhenMaxNumCompChanged := (Copy(str, 39, 1) = '1');
    CapResStartEnd := (Copy(str, 40, 1) = '1');
  end
end;

//----------------------------------------------------------------------------//

function IsCalendarLoaded: boolean;
var
  qry: TMqmQuery;
//  trs: TMqmTransaction;
  tbInfo: ^TTblInfo;
  rowNum: Integer;
begin
  result := false;
  tbInfo := @tblInfo[tbl_calendar];
  qry := CreateQuery(Main_DB);
  qry.Transaction := CreateTransaction(Main_DB);
  qry.Transaction.StartTransaction;

  qry.SQL.Clear;
  qry.SQL.Add('select count(*) cnt from ' + tbInfo.GetTableName);
  qry.SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.Open;

  if not qry.EOF then
    rowNum := qry.FieldByName('cnt').asInteger;

  qry.Transaction.commit;
  qry.Close;

  qry.Free;

  if rowNum > 0 then
    result := true;

end;

//----------------------------------------------------------------------------//

procedure GlobLoadSettingsValues;
var
  qry: TMqmQuery;
  tbInfo: ^TTblInfo;
begin
  tbInfo := @tblInfo[tbl_cfg_appSettings];
  qry := CreateQuery(Cfg_DB);

  qry.SQL.Clear;
  qry.SQL.Add('select * from ' + tbInfo.GetTableName + ' where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + '=''' + IniAppGlobals.WkstCode + '''');
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.Open;

  if not qry.EOF then
    DecodeSettings(qry.FieldByName(CreateFld(tbInfo.pfx, fli_appSettings)).AsString);

  qry.Close;

  qry.Free;

end;

//----------------------------------------------------------------------------//

procedure GlobSaveSettingsValues;
var
  qry: TMqmQuery;
//  trs: TMqmTransaction;
  tbInfo: ^TTblInfo;
begin
  tbInfo := @tblInfo[tbl_cfg_appSettings];
//  SetFldPfx(tbInfo.pfx);

//  trs := CreateTransaction(Cfg_DB, false);
  qry := CreateQuery(Cfg_DB);
//  Qry.Transaction := CreateTransaction(Cfg_DB);
//  Qry.Transaction.StartTransaction;

//  trs.StartTransaction;
  qry.SQL.Clear;
  qry.SQL.Add('delete from ' +  tbInfo.GetTableName + ' where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + '=''' + IniAppGlobals.WkstCode+'''');
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.ExecSQL;
  Application.ProcessMessages;
  qry.Close;

//  trs.StartTransaction;
  qry.SQL.Clear;
  qry.SQL.Add('insert into ' + tbInfo.GetTableName + '(');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_identifier)     + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_wkstCode)     + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_appSettings)  + ')');
  qry.SQL.Add(' values (');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_identifier) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wkstCode) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_appSettings));
  qry.SQL.Add(')');
//  qry.Prepare;

  qry.ParamByName(CreateFld(tbInfo.pfx, fli_identifier)).AsString  := IniAppGlobals.Identifier;
  qry.ParamByName(CreateFld(tbInfo.pfx, fli_wkstCode)).AsString    := IniAppGlobals.WkstCode;
  qry.ParamByName(CreateFld(tbInfo.pfx, fli_appSettings)).AsString := EncodeSettings;

  qry.ExecSQL;
  Application.ProcessMessages;
  qry.Close;
  qry.connection.Commit;

  qry.Free;
//  trs.Free
end;

//----------------------------------------------------------------------------//

procedure GlobSaveConfig;
var
  cfg: integer;
begin
  cfg := 0;
  with LocAppGlobals do
  begin
    if IsDevelop then cfg := cfg or CFG_DEVELOP
  end;
  WriteIntToRegistry(RgMqmSezCfg, RgCfgRunMode, cfg)
end;

//----------------------------------------------------------------------------//

procedure SaveColors;
var
  qry: TMqmQuery;
  tbInfo: ^TTblInfo;
  I,J, color, arraysize :integer;
  ColrCmptTbl : Table;
  Description : String;
//  FaoundChange : boolean;

  FaoundChange_colorJobToJob,
  FaoundChange_clrCapToJob,
  FaoundChange_colorJobToRes,
  FaoundChange_colorStatus,
  FaoundChange_colorDateWarn,
  FaoundChange_colorMatWarn,
  FaoundChange_clrRes,
  FaoundChange_clrCapRes : boolean;
begin
//  exit;
  ColrCmptTbl := tbl_cfg_colorJobToJob;
  qry := CreateQuery(Cfg_DB);
  Qry.Transaction := CreateTransaction(Cfg_DB);
  Qry.Transaction.StartTransaction;
//  FaoundChange := false;

  FaoundChange_colorJobToJob := false;
  FaoundChange_clrCapToJob := false;
  FaoundChange_colorJobToRes := false;
  FaoundChange_colorStatus := false;
  FaoundChange_colorDateWarn := false;
  FaoundChange_colorMatWarn := false;
  FaoundChange_clrRes := false;
  FaoundChange_clrCapRes := false;

  for J := 0 to 7 do
  begin

   // if FaoundChange then break;

    case J of
      0 : ColrCmptTbl := tbl_cfg_colorJobToJob;
      1 : ColrCmptTbl := tbl_cfg_clrCapToJob;
      2 : ColrCmptTbl := tbl_cfg_colorJobToRes;
      3 : ColrCmptTbl := tbl_cfg_colorStatus;
      4 : ColrCmptTbl := tbl_cfg_colorDateWarn;
      5 : ColrCmptTbl := tbl_cfg_colorMatWarn;
      6 : ColrCmptTbl := tbl_cfg_clrRes;
      7 : ColrCmptTbl := tbl_cfg_clrCapRes;
    end;

    tbInfo := @tblInfo[ColrCmptTbl];

    if J = 0 then
    begin
      for i := Low(DBAppGlobals.JobToJobCompColor) to High(DBAppGlobals.JobToJobCompColor) do
      begin
        if (DBAppGlobals.SavedJobToJobCompColor[I].int <> DBAppGlobals.JobToJobCompColor[I].int) or
           (DBAppGlobals.SavedJobToJobCompColor[I].brd <> DBAppGlobals.JobToJobCompColor[I].brd) or
           (DBAppGlobals.SavedJobToJobCompColor[I].txt <> DBAppGlobals.JobToJobCompColor[I].txt) or
           (DBAppGlobals.SavedJobToJobCompColor[I].Dsc <> DBAppGlobals.JobToJobCompColor[I].Dsc) then
        begin
          FaoundChange_colorJobToJob := true;
          break
        end;
      end;
     { qry.SQL.Clear;
      qry.SQL.Add('select * from ' +  tbInfo.GetTableName + ' where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + '=''' + IniAppglobals.WkstCode+'''');
      qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
      qry.open;
      if qry.EOF then
         FaoundChange_colorJobToJob := true; }

     // if not FaoundChange_colorJobToJob then break;
    end;

    if J = 1 then
    begin
      for i := Low(DBAppGlobals.JobToCapCompColor) to High(DBAppGlobals.JobToCapCompColor) do
      begin
        if (DBAppGlobals.SavedJobToCapCompColor[I].int <> DBAppGlobals.JobToCapCompColor[I].int) or
           (DBAppGlobals.SavedJobToCapCompColor[I].brd <> DBAppGlobals.JobToCapCompColor[I].brd) or
           (DBAppGlobals.SavedJobToCapCompColor[I].txt <> DBAppGlobals.JobToCapCompColor[I].txt) or
           (DBAppGlobals.SavedJobToCapCompColor[I].Dsc <> DBAppGlobals.JobToCapCompColor[I].Dsc) then
        begin
          FaoundChange_clrCapToJob := true;
          break
        end;
      end;
     { qry.SQL.Clear;
      qry.SQL.Add('select * from ' +  tbInfo.GetTableName + ' where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + '=''' + IniAppglobals.WkstCode+'''');
      qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
      qry.open;
      if qry.EOF then
         FaoundChange_clrCapToJob := true;  }
      //if not FaoundChange then continue;
    end;

    if J = 2 then
    begin
      for i := Low(DBAppGlobals.JobCapToRscCompColor) to High(DBAppGlobals.JobCapToRscCompColor) do
      begin
        if (DBAppGlobals.SavedJobCapToRscCompColor[I].int <> DBAppGlobals.JobCapToRscCompColor[I].int) or
           (DBAppGlobals.SavedJobCapToRscCompColor[I].brd <> DBAppGlobals.JobCapToRscCompColor[I].brd) or
           (DBAppGlobals.SavedJobCapToRscCompColor[I].txt <> DBAppGlobals.JobCapToRscCompColor[I].txt) or
           (DBAppGlobals.SavedJobCapToRscCompColor[I].Dsc <> DBAppGlobals.JobCapToRscCompColor[I].Dsc) then
        begin
          FaoundChange_colorJobToRes := true;
          break
        end;
      end;
     { qry.SQL.Clear;
      qry.SQL.Add('select * from ' +  tbInfo.GetTableName + ' where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + '=''' + IniAppglobals.WkstCode+'''');
      qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
      qry.open;
      if qry.EOF then
         FaoundChange_colorJobToRes := true; }

     // if not FaoundChange then continue;
    end;

    if J = 3 then
    begin
      for i := Low(DBAppGlobals.JobStatusColor) to High(DBAppGlobals.JobStatusColor) do
      begin
        if (DBAppGlobals.SavedJobStatusColor[I].int <> DBAppGlobals.JobStatusColor[I].int) or
           (DBAppGlobals.SavedJobStatusColor[I].brd <> DBAppGlobals.JobStatusColor[I].brd) or
           (DBAppGlobals.SavedJobStatusColor[I].txt <> DBAppGlobals.JobStatusColor[I].txt) or
           (DBAppGlobals.SavedJobStatusColor[I].Dsc <> DBAppGlobals.JobStatusColor[I].Dsc) then
        begin
          FaoundChange_colorStatus := true;
          break
        end;
      end;
    {  qry.SQL.Clear;
      qry.SQL.Add('select * from ' +  tbInfo.GetTableName + ' where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + '=''' + IniAppglobals.WkstCode+'''');
      qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
      qry.open;
      if qry.EOF then
         FaoundChange_colorStatus := true; }

     // if not FaoundChange then continue;
    end;

    if J = 4 then
    begin
      for i := Low(DBAppGlobals.JobDateWarningColor) to High(DBAppGlobals.JobDateWarningColor) do
      begin
        if (DBAppGlobals.SavedJobDateWarningColor[I].int <> DBAppGlobals.JobDateWarningColor[I].int) or
           (DBAppGlobals.SavedJobDateWarningColor[I].brd <> DBAppGlobals.JobDateWarningColor[I].brd) or
           (DBAppGlobals.SavedJobDateWarningColor[I].txt <> DBAppGlobals.JobDateWarningColor[I].txt) or
           (DBAppGlobals.SavedJobDateWarningColor[I].Dsc <> DBAppGlobals.JobDateWarningColor[I].Dsc) then
        begin
          FaoundChange_colorDateWarn := true;
          break
        end;
      end;
     { qry.SQL.Clear;
      qry.SQL.Add('select * from ' +  tbInfo.GetTableName + ' where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + '=''' + IniAppglobals.WkstCode+'''');
      qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
      qry.open;
      if qry.EOF then
         FaoundChange_colorDateWarn := true; }

     // if not FaoundChange then continue;
    end;

    if J = 5 then
    begin
      for i := Low(DBAppGlobals.JobMatWarningColor) to High(DBAppGlobals.JobMatWarningColor) do
      begin
        if (DBAppGlobals.SavedJobMatWarningColor[I].int <> DBAppGlobals.JobMatWarningColor[I].int) or
           (DBAppGlobals.SavedJobMatWarningColor[I].brd <> DBAppGlobals.JobMatWarningColor[I].brd) or
           (DBAppGlobals.SavedJobMatWarningColor[I].txt <> DBAppGlobals.JobMatWarningColor[I].txt) or
           (DBAppGlobals.SavedJobMatWarningColor[I].Dsc <> DBAppGlobals.JobMatWarningColor[I].Dsc) then
        begin
          FaoundChange_colorMatWarn := true;
          break
        end;
      end;

    {  qry.SQL.Clear;
      qry.SQL.Add('select * from ' +  tbInfo.GetTableName + ' where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + '=''' + IniAppglobals.WkstCode+'''');
      qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
      qry.open;
      if qry.EOF then
         FaoundChange_colorMatWarn := true;   }
     // if not FaoundChange then continue;
    end;

    if J = 6 then
    begin
      for i := Low(DBAppGlobals.ResColors) to High(DBAppGlobals.ResColors) do
      begin
        if (DBAppGlobals.SavedResColors[I].int <> DBAppGlobals.ResColors[I].int) or
           (DBAppGlobals.SavedResColors[I].brd <> DBAppGlobals.ResColors[I].brd) or
           (DBAppGlobals.SavedResColors[I].txt <> DBAppGlobals.ResColors[I].txt) or
           (DBAppGlobals.SavedResColors[I].Dsc <> DBAppGlobals.ResColors[I].Dsc) then
        begin
          FaoundChange_clrRes := true;
          break
        end;
      end;
    {  qry.SQL.Clear;
      qry.SQL.Add('select * from ' +  tbInfo.GetTableName + ' where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + '=''' + IniAppglobals.WkstCode+'''');
      qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
      qry.open;
      if qry.EOF then
         FaoundChange_clrRes := true; }
    end;

    if J = 7 then
    begin
      for i := Low(DBAppGlobals.CapResColors) to High(DBAppGlobals.CapResColors) do
      begin
        if (DBAppGlobals.SavedCapResColors[I].int <> DBAppGlobals.CapResColors[I].int) or
           (DBAppGlobals.SavedCapResColors[I].brd <> DBAppGlobals.CapResColors[I].brd) or
           (DBAppGlobals.SavedCapResColors[I].txt <> DBAppGlobals.CapResColors[I].txt) or
           (DBAppGlobals.SavedCapResColors[I].Dsc <> DBAppGlobals.CapResColors[I].Dsc) then
        begin
          FaoundChange_clrCapRes := true;
          break
        end;
      end;

     { qry.SQL.Clear;
      qry.SQL.Add('select * from ' +  tbInfo.GetTableName + ' where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + '=''' + IniAppglobals.WkstCode+'''');
      qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
      qry.open;
      if qry.EOF then
         FaoundChange_clrCapRes := true;  }
    end;

{      if not FaoundChange then
      begin
        qry.connection.Commit;
        qry.Close;
        qry.free;
        exit;
      end;    }
    if not FaoundChange_colorJobToJob and not
           FaoundChange_clrCapToJob and not
           FaoundChange_colorJobToRes and not
           FaoundChange_colorStatus  and not
           FaoundChange_colorDateWarn and not
           FaoundChange_colorMatWarn and not
           FaoundChange_clrRes and not
           FaoundChange_clrCapRes
    then continue;

    FaoundChange_colorJobToJob := false;
    FaoundChange_clrCapToJob := false;
    FaoundChange_colorJobToRes := false;
    FaoundChange_colorStatus := false;
    FaoundChange_colorDateWarn := false;
    FaoundChange_colorMatWarn := false;
    FaoundChange_clrRes := false;
    FaoundChange_clrCapRes := false;

    qry.SQL.Clear;
    qry.SQL.Add('delete from ' +  tbInfo.GetTableName + ' where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + '=''' + IniAppglobals.WkstCode+'''');
    qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
    qry.ExecSQL;
    Qry.Transaction.Commit;
    qry.Close;
    qry.SQL.Clear;
    Qry.Transaction.StartTransaction;

    arraysize := -1;

    qry.SQL.Add('insert into ' + tbInfo.GetTableName + '(');
    qry.SQL.Add(CreateFld(tbInfo.pfx, fli_identifier) + ',');
    qry.SQL.Add(CreateFld(tbInfo.pfx, fli_wkstCode) + ',');
    qry.SQL.Add(CreateFld(tbInfo.pfx, fli_ValFrom) + ',');
    qry.SQL.Add(CreateFld(tbInfo.pfx, fli_intColor) + ',');
    qry.SQL.Add(CreateFld(tbInfo.pfx, fli_bdrColor) + ',');

    if J > 2 then   //if we are saving description
    begin
      qry.SQL.Add(CreateFld(tbInfo.pfx, fli_txtColor) + ',');
      qry.SQL.Add(CreateFld(tbInfo.pfx, fli_txtDescription) + ')');
    end
    else
      qry.SQL.Add(CreateFld(tbInfo.pfx, fli_txtColor) + ')');

    qry.SQL.Add(' values (');
    qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_identifier) + ',');
    qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wkstCode) + ',');
    qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_ValFrom) + ',');
    qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_intColor) + ',');
    qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_bdrColor) + ',');

    if J > 2 then   //if we are saving description
    begin
      qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_txtColor) + ',');
      qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_txtDescription));
    end
    else
      qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_txtColor));

    qry.SQL.Add(')');

    case J of
      0 : begin

            arraysize := -1;
            for i := Low(DBAppGlobals.JobToJobCompColor) to High(DBAppGlobals.JobToJobCompColor) do
            begin
              Inc(arraysize);
              qry.params.arraysize := arraysize + 1;
              qry.params[0].AsIntegers[arraysize] := StrToInt(IniAppGlobals.Identifier);
              qry.params[1].AsStrings[arraysize] := IniAppGlobals.WkstCode;
              qry.params[2].AsIntegers[arraysize] := I;
              color := Integer(DBAppGlobals.JobToJobCompColor[I].int);
              qry.params[3].AsIntegers[arraysize] := Color;
              color := Integer(DBAppGlobals.JobToJobCompColor[I].brd);
              qry.params[4].AsIntegers[arraysize] := Color;
              color := Integer(DBAppGlobals.JobToJobCompColor[I].txt);
              qry.params[5].AsIntegers[arraysize] := Color;

            {  qry.ParamByName(CreateFld(tbInfo.pfx, fli_wkstCode)).AsString := IniAppGlobals.WkstCode;
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_ValFrom)).AsInteger := I;
              color := Integer(DBAppGlobals.JobToJobCompColor[I].int);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_intColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.JobToJobCompColor[I].brd);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_bdrColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.JobToJobCompColor[I].txt);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_txtColor)).AsInteger := Color;
              qry.ExecSQL;  }
            end;
            if arraysize >= 0 then
              qry.execute(arraysize + 1);

          end;

      1 : begin

            arraysize := -1;
            for i := Low(DBAppGlobals.JobToCapCompColor) to High(DBAppGlobals.JobToCapCompColor) do
            begin
              Inc(arraysize);
              qry.params.arraysize := arraysize + 1;
              qry.params[0].AsIntegers[arraysize] := StrToInt(IniAppGlobals.Identifier);
              qry.params[1].AsStrings[arraysize] := IniAppGlobals.WkstCode;
              qry.params[2].AsIntegers[arraysize] := I;
              color := Integer(DBAppGlobals.JobToCapCompColor[I].int);
              qry.params[3].AsIntegers[arraysize] := Color;
              color := Integer(DBAppGlobals.JobToCapCompColor[I].brd);
              qry.params[4].AsIntegers[arraysize] := Color;
              color := Integer(DBAppGlobals.JobToCapCompColor[I].txt);
              qry.params[5].AsIntegers[arraysize] := Color;


            {  qry.ParamByName(CreateFld(tbInfo.pfx, fli_wkstCode)).AsString := IniAppGlobals.WkstCode;
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_ValFrom)).AsInteger := I;
              color := Integer(DBAppGlobals.JobToCapCompColor[I].int);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_intColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.JobToCapCompColor[I].brd);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_bdrColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.JobToCapCompColor[I].txt);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_txtColor)).AsInteger := Color;
              qry.ExecSQL; }
            end;

            if arraysize >= 0 then
              qry.execute(arraysize + 1);

          end;

      2 : begin
            arraysize := -1;

            for i := Low(DBAppGlobals.JobCapToRscCompColor) to High(DBAppGlobals.JobCapToRscCompColor) do
            begin
              Inc(arraysize);
              qry.params.arraysize := arraysize + 1;
              qry.params[0].AsIntegers[arraysize] := StrToInt(IniAppGlobals.Identifier);
              qry.params[1].AsStrings[arraysize] := IniAppGlobals.WkstCode;
              qry.params[2].AsIntegers[arraysize] := I;
              color := Integer(DBAppGlobals.JobCapToRscCompColor[I].int);
              qry.params[3].AsIntegers[arraysize] := Color;
              color := Integer(DBAppGlobals.JobCapToRscCompColor[I].brd);
              qry.params[4].AsIntegers[arraysize] := Color;
              color := Integer(DBAppGlobals.JobCapToRscCompColor[I].txt);
              qry.params[5].AsIntegers[arraysize] := Color;

            {  qry.ParamByName(CreateFld(tbInfo.pfx, fli_wkstCode)).AsString := IniAppGlobals.WkstCode;
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_ValFrom)).AsInteger := I;
              color := Integer(DBAppGlobals.JobCapToRscCompColor[I].int);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_intColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.JobCapToRscCompColor[I].brd);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_bdrColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.JobCapToRscCompColor[I].txt);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_txtColor)).AsInteger := Color;
              qry.ExecSQL;             }
            end;

            if arraysize >= 0 then
              qry.execute(arraysize + 1);

          end;

      3 : begin
            arraysize := -1;

            for i := Low(DBAppGlobals.JobStatusColor) to High(DBAppGlobals.JobStatusColor) do
            begin
              Inc(arraysize);
              qry.params.arraysize := arraysize + 1;
              qry.params[0].AsIntegers[arraysize] := StrToInt(IniAppGlobals.Identifier);
              qry.params[1].AsStrings[arraysize] := IniAppGlobals.WkstCode;
              qry.params[2].AsIntegers[arraysize] := I;
              color := Integer(DBAppGlobals.JobStatusColor[I].int);
              qry.params[3].AsIntegers[arraysize]  := Color;
              color := Integer(DBAppGlobals.JobStatusColor[I].brd);
              qry.params[4].AsIntegers[arraysize]  := Color;
              color := Integer(DBAppGlobals.JobStatusColor[I].txt);
              qry.params[5].AsIntegers[arraysize]  := Color;
              Description := DBAppGlobals.JobStatusColor[I].dsc;
              qry.params[6].AsStrings[arraysize]  := Description;

             { qry.ParamByName(CreateFld(tbInfo.pfx, fli_wkstCode)).AsString := IniAppGlobals.WkstCode;
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_ValFrom)).AsInteger := I;
              color := Integer(DBAppGlobals.JobStatusColor[I].int);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_intColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.JobStatusColor[I].brd);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_bdrColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.JobStatusColor[I].txt);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_txtColor)).AsInteger := Color;
              Description := DBAppGlobals.JobStatusColor[I].dsc;
              qry.ParamByName(CreateFld(tbInfo.pfx, Fli_txtDescription)).AsString := Description;
              qry.ExecSQL;  }
            end;

            if arraysize >= 0 then
              qry.execute(arraysize + 1);

          end;

      4 : begin

            arraysize := -1;
            for i := Low(DBAppGlobals.JobDateWarningColor) to High(DBAppGlobals.JobDateWarningColor) do
            begin
              Inc(arraysize);
              qry.params.arraysize := arraysize + 1;
              qry.params[0].AsIntegers[arraysize] := StrToInt(IniAppGlobals.Identifier);
              qry.params[1].AsStrings[arraysize] := IniAppGlobals.WkstCode;
              qry.params[2].AsIntegers[arraysize] := I;
              color := Integer(DBAppGlobals.JobDateWarningColor[I].int);
              qry.params[3].AsIntegers[arraysize] := Color;
              color := Integer(DBAppGlobals.JobDateWarningColor[I].brd);
              qry.params[4].AsIntegers[arraysize] := Color;
              color := Integer(DBAppGlobals.JobDateWarningColor[I].txt);
              qry.params[5].AsIntegers[arraysize] := Color;
              Description := DBAppGlobals.JobDateWarningColor[I].dsc;
              qry.params[6].AsStrings[arraysize] := Description;

            {  qry.ParamByName(CreateFld(tbInfo.pfx, fli_wkstCode)).AsString := IniAppGlobals.WkstCode;
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_ValFrom)).AsInteger := I;
              color := Integer(DBAppGlobals.JobDateWarningColor[I].int);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_intColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.JobDateWarningColor[I].brd);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_bdrColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.JobDateWarningColor[I].txt);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_txtColor)).AsInteger := Color;
              Description := DBAppGlobals.JobDateWarningColor[I].dsc;
              qry.ParamByName(CreateFld(tbInfo.pfx, Fli_txtDescription)).AsString := Description;
              qry.ExecSQL; }
            end;

            if arraysize >= 0 then
              qry.execute(arraysize + 1);

          end;

      5 : begin

            arraysize := -1;
            for i := Low(DBAppGlobals.JobMatWarningColor) to High(DBAppGlobals.JobMatWarningColor) do
            begin
             { if (DBAppGlobals.SavedJobMatWarningColor[I].int = DBAppGlobals.JobMatWarningColor[I].int) and
                 (DBAppGlobals.SavedJobMatWarningColor[I].brd = DBAppGlobals.JobMatWarningColor[I].brd) and
                 (DBAppGlobals.SavedJobMatWarningColor[I].txt = DBAppGlobals.JobMatWarningColor[I].txt) and
                 (DBAppGlobals.SavedJobMatWarningColor[I].Dsc = DBAppGlobals.JobMatWarningColor[I].Dsc) then continue;
                                            }
              Inc(arraysize);
              qry.params.arraysize := arraysize + 1;
              qry.params[0].AsIntegers[arraysize] := StrToInt(IniAppGlobals.Identifier);
              qry.params[1].AsStrings[arraysize] := IniAppGlobals.WkstCode;
              qry.params[2].AsIntegers[arraysize] := I;
              color := Integer(DBAppGlobals.JobMatWarningColor[I].int);
              qry.params[3].AsIntegers[arraysize] := Color;
              color := Integer(DBAppGlobals.JobMatWarningColor[I].brd);
              qry.params[4].AsIntegers[arraysize] := Color;
              color := Integer(DBAppGlobals.JobMatWarningColor[I].txt);
              qry.params[5].AsIntegers[arraysize] := Color;
              Description := DBAppGlobals.JobMatWarningColor[I].dsc;
              qry.params[6].AsStrings[arraysize] := Description;


            {  qry.ParamByName(CreateFld(tbInfo.pfx, fli_wkstCode)).AsString := IniAppGlobals.WkstCode;
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_ValFrom)).AsInteger := I;
              color := Integer(DBAppGlobals.JobMatWarningColor[I].int);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_intColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.JobMatWarningColor[I].brd);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_bdrColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.JobMatWarningColor[I].txt);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_txtColor)).AsInteger := Color;
              Description := DBAppGlobals.JobMatWarningColor[I].dsc;
              qry.ParamByName(CreateFld(tbInfo.pfx, Fli_txtDescription)).AsString := Description;
              qry.ExecSQL;      }

            end;

            if arraysize >= 0 then
              qry.execute(arraysize + 1);

          end;

      6 : begin

            arraysize := -1;
            for i := Low(DBAppGlobals.ResColors) to High(DBAppGlobals.ResColors) do
            begin
             { if (DBAppGlobals.SavedResColors[I].int = DBAppGlobals.ResColors[I].int) and
                 (DBAppGlobals.SavedResColors[I].brd = DBAppGlobals.ResColors[I].brd) and
                 (DBAppGlobals.SavedResColors[I].txt = DBAppGlobals.ResColors[I].txt) and
                 (DBAppGlobals.SavedResColors[I].Dsc = DBAppGlobals.ResColors[I].Dsc) then continue; }

              Inc(arraysize);
              qry.params.arraysize := arraysize + 1;
              qry.params[0].AsIntegers[arraysize] := StrToInt(IniAppGlobals.Identifier);
              qry.params[1].AsStrings[arraysize] := IniAppGlobals.WkstCode;
              qry.params[2].AsIntegers[arraysize] := I;
              color := Integer(DBAppGlobals.ResColors[I].int);
              qry.params[3].AsIntegers[arraysize] := Color;
              color := Integer(DBAppGlobals.ResColors[I].brd);
              qry.params[4].AsIntegers[arraysize] := Color;
              color := Integer(DBAppGlobals.ResColors[I].txt);
              qry.params[5].AsIntegers[arraysize] := Color;
              Description := DBAppGlobals.ResColors[I].dsc;
              qry.params[6].AsStrings[arraysize] := Description;

            {  qry.ParamByName(CreateFld(tbInfo.pfx, fli_wkstCode)).AsString := IniAppGlobals.WkstCode;
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_ValFrom)).AsInteger := I;
              color := Integer(DBAppGlobals.ResColors[I].int);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_intColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.ResColors[I].brd);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_bdrColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.ResColors[I].txt);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_txtColor)).AsInteger := Color;
              Description := DBAppGlobals.ResColors[I].dsc;
              qry.ParamByName(CreateFld(tbInfo.pfx, Fli_txtDescription)).AsString := Description;
              qry.ExecSQL;  }
            end;

            if arraysize >= 0 then
               qry.execute(arraysize + 1);

          end;

      7 : begin

            arraysize := -1;
            for i := Low(DBAppGlobals.CapResColors) to High(DBAppGlobals.CapResColors) do
            begin
              Inc(arraysize);
              qry.params.arraysize := arraysize + 1;
              qry.params[0].AsIntegers[arraysize] := StrToInt(IniAppGlobals.Identifier);
              qry.params[1].AsStrings[arraysize] := IniAppGlobals.WkstCode;
              qry.params[2].AsIntegers[arraysize] := I;

              color := Integer(DBAppGlobals.CapResColors[I].int);
              qry.params[3].AsIntegers[arraysize] := Color;
              color := Integer(DBAppGlobals.CapResColors[I].brd);
              qry.params[4].AsIntegers[arraysize] := Color;
              color := Integer(DBAppGlobals.CapResColors[I].txt);
              qry.params[5].AsIntegers[arraysize] := Color;

              Description := DBAppGlobals.CapResColors[I].dsc;
              qry.params[6].AsStrings[arraysize] := Description;


            {  qry.ParamByName(CreateFld(tbInfo.pfx, fli_wkstCode)).AsString := IniAppGlobals.WkstCode;
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_ValFrom)).AsInteger := I;
              color := Integer(DBAppGlobals.CapResColors[I].int);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_intColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.CapResColors[I].brd);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_bdrColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.CapResColors[I].txt);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_txtColor)).AsInteger := Color;

              Description := DBAppGlobals.CapResColors[I].dsc;
              qry.ParamByName(CreateFld(tbInfo.pfx, Fli_txtDescription)).AsString := Description;
              qry.ExecSQL;   }
            end;

            if arraysize >= 0 then
               qry.execute(arraysize + 1);

          end;

    end;

  end;

  qry.connection.Commit;
  qry.Close;
  qry.free;

end;


procedure SaveColorsOld;
var
  qry: TMqmQuery;
  tbInfo: ^TTblInfo;
  I,J, color, arraysize :integer;
  ColrCmptTbl : Table;
  Description : String;
//  FaoundChange : boolean;

  FaoundChange_colorJobToJob,
  FaoundChange_clrCapToJob,
  FaoundChange_colorJobToRes,
  FaoundChange_colorStatus,
  FaoundChange_colorDateWarn,
  FaoundChange_colorMatWarn,
  FaoundChange_clrRes,
  FaoundChange_clrCapRes : boolean;
begin
  ColrCmptTbl := tbl_cfg_colorJobToJob;
  qry := CreateQuery(Cfg_DB);
  Qry.Transaction := CreateTransaction(Cfg_DB);
  Qry.Transaction.StartTransaction;
//  FaoundChange := false;

  FaoundChange_colorJobToJob := false;
  FaoundChange_clrCapToJob := false;
  FaoundChange_colorJobToRes := false;
  FaoundChange_colorStatus := false;
  FaoundChange_colorDateWarn := false;
  FaoundChange_colorMatWarn := false;
  FaoundChange_clrRes := false;
  FaoundChange_clrCapRes := false;

  for J := 0 to 7 do
  begin

   // if FaoundChange then break;

    case J of
      0 : ColrCmptTbl := tbl_cfg_colorJobToJob;
      1 : ColrCmptTbl := tbl_cfg_clrCapToJob;
      2 : ColrCmptTbl := tbl_cfg_colorJobToRes;
      3 : ColrCmptTbl := tbl_cfg_colorStatus;
      4 : ColrCmptTbl := tbl_cfg_colorDateWarn;
      5 : ColrCmptTbl := tbl_cfg_colorMatWarn;
      6 : ColrCmptTbl := tbl_cfg_clrRes;
      7 : ColrCmptTbl := tbl_cfg_clrCapRes;
    end;

    tbInfo := @tblInfo[ColrCmptTbl];

    if J = 0 then
    begin
      for i := Low(DBAppGlobals.JobToJobCompColor) to High(DBAppGlobals.JobToJobCompColor) do
      begin
        if (DBAppGlobals.SavedJobToJobCompColor[I].int <> DBAppGlobals.JobToJobCompColor[I].int) or
           (DBAppGlobals.SavedJobToJobCompColor[I].brd <> DBAppGlobals.JobToJobCompColor[I].brd) or
           (DBAppGlobals.SavedJobToJobCompColor[I].txt <> DBAppGlobals.JobToJobCompColor[I].txt) or
           (DBAppGlobals.SavedJobToJobCompColor[I].Dsc <> DBAppGlobals.JobToJobCompColor[I].Dsc) then
        begin
          FaoundChange_colorJobToJob := true;
          break
        end;
      end;
      qry.SQL.Clear;
      qry.SQL.Add('select * from ' +  tbInfo.GetTableName + ' where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + '=''' + IniAppglobals.WkstCode+'''');
      qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
      qry.open;
      if qry.EOF then
         FaoundChange_colorJobToJob := true;

     // if not FaoundChange_colorJobToJob then break;
    end;

    if J = 1 then
    begin
      for i := Low(DBAppGlobals.JobToCapCompColor) to High(DBAppGlobals.JobToCapCompColor) do
      begin
        if (DBAppGlobals.SavedJobToCapCompColor[I].int <> DBAppGlobals.JobToCapCompColor[I].int) or
           (DBAppGlobals.SavedJobToCapCompColor[I].brd <> DBAppGlobals.JobToCapCompColor[I].brd) or
           (DBAppGlobals.SavedJobToCapCompColor[I].txt <> DBAppGlobals.JobToCapCompColor[I].txt) or
           (DBAppGlobals.SavedJobToCapCompColor[I].Dsc <> DBAppGlobals.JobToCapCompColor[I].Dsc) then
        begin
          FaoundChange_clrCapToJob := true;
          break
        end;
      end;
      qry.SQL.Clear;
      qry.SQL.Add('select * from ' +  tbInfo.GetTableName + ' where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + '=''' + IniAppglobals.WkstCode+'''');
      qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
      qry.open;
      if qry.EOF then
         FaoundChange_clrCapToJob := true;
      //if not FaoundChange then continue;
    end;

    if J = 2 then
    begin
      for i := Low(DBAppGlobals.JobCapToRscCompColor) to High(DBAppGlobals.JobCapToRscCompColor) do
      begin
        if (DBAppGlobals.SavedJobCapToRscCompColor[I].int <> DBAppGlobals.JobCapToRscCompColor[I].int) or
           (DBAppGlobals.SavedJobCapToRscCompColor[I].brd <> DBAppGlobals.JobCapToRscCompColor[I].brd) or
           (DBAppGlobals.SavedJobCapToRscCompColor[I].txt <> DBAppGlobals.JobCapToRscCompColor[I].txt) or
           (DBAppGlobals.SavedJobCapToRscCompColor[I].Dsc <> DBAppGlobals.JobCapToRscCompColor[I].Dsc) then
        begin
          FaoundChange_colorJobToRes := true;
          break
        end;
      end;
      qry.SQL.Clear;
      qry.SQL.Add('select * from ' +  tbInfo.GetTableName + ' where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + '=''' + IniAppglobals.WkstCode+'''');
      qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
      qry.open;
      if qry.EOF then
         FaoundChange_colorJobToRes := true;

     // if not FaoundChange then continue;
    end;

    if J = 3 then
    begin
      for i := Low(DBAppGlobals.JobStatusColor) to High(DBAppGlobals.JobStatusColor) do
      begin
        if (DBAppGlobals.SavedJobStatusColor[I].int <> DBAppGlobals.JobStatusColor[I].int) or
           (DBAppGlobals.SavedJobStatusColor[I].brd <> DBAppGlobals.JobStatusColor[I].brd) or
           (DBAppGlobals.SavedJobStatusColor[I].txt <> DBAppGlobals.JobStatusColor[I].txt) or
           (DBAppGlobals.SavedJobStatusColor[I].Dsc <> DBAppGlobals.JobStatusColor[I].Dsc) then
        begin
          FaoundChange_colorStatus := true;
          break
        end;
      end;
      qry.SQL.Clear;
      qry.SQL.Add('select * from ' +  tbInfo.GetTableName + ' where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + '=''' + IniAppglobals.WkstCode+'''');
      qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
      qry.open;
      if qry.EOF then
         FaoundChange_colorStatus := true;

     // if not FaoundChange then continue;
    end;

    if J = 4 then
    begin
      for i := Low(DBAppGlobals.JobDateWarningColor) to High(DBAppGlobals.JobDateWarningColor) do
      begin
        if (DBAppGlobals.SavedJobDateWarningColor[I].int <> DBAppGlobals.JobDateWarningColor[I].int) or
           (DBAppGlobals.SavedJobDateWarningColor[I].brd <> DBAppGlobals.JobDateWarningColor[I].brd) or
           (DBAppGlobals.SavedJobDateWarningColor[I].txt <> DBAppGlobals.JobDateWarningColor[I].txt) or
           (DBAppGlobals.SavedJobDateWarningColor[I].Dsc <> DBAppGlobals.JobDateWarningColor[I].Dsc) then
        begin
          FaoundChange_colorDateWarn := true;
          break
        end;
      end;
      qry.SQL.Clear;
      qry.SQL.Add('select * from ' +  tbInfo.GetTableName + ' where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + '=''' + IniAppglobals.WkstCode+'''');
      qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
      qry.open;
      if qry.EOF then
         FaoundChange_colorDateWarn := true;

     // if not FaoundChange then continue;
    end;

    if J = 5 then
    begin
      for i := Low(DBAppGlobals.JobMatWarningColor) to High(DBAppGlobals.JobMatWarningColor) do
      begin
        if (DBAppGlobals.SavedJobMatWarningColor[I].int <> DBAppGlobals.JobMatWarningColor[I].int) or
           (DBAppGlobals.SavedJobMatWarningColor[I].brd <> DBAppGlobals.JobMatWarningColor[I].brd) or
           (DBAppGlobals.SavedJobMatWarningColor[I].txt <> DBAppGlobals.JobMatWarningColor[I].txt) or
           (DBAppGlobals.SavedJobMatWarningColor[I].Dsc <> DBAppGlobals.JobMatWarningColor[I].Dsc) then
        begin
          FaoundChange_colorMatWarn := true;
          break
        end;
      end;

      qry.SQL.Clear;
      qry.SQL.Add('select * from ' +  tbInfo.GetTableName + ' where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + '=''' + IniAppglobals.WkstCode+'''');
      qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
      qry.open;
      if qry.EOF then
         FaoundChange_colorMatWarn := true;
     // if not FaoundChange then continue;
    end;

    if J = 6 then
    begin
      for i := Low(DBAppGlobals.ResColors) to High(DBAppGlobals.ResColors) do
      begin
        if (DBAppGlobals.SavedResColors[I].int <> DBAppGlobals.ResColors[I].int) or
           (DBAppGlobals.SavedResColors[I].brd <> DBAppGlobals.ResColors[I].brd) or
           (DBAppGlobals.SavedResColors[I].txt <> DBAppGlobals.ResColors[I].txt) or
           (DBAppGlobals.SavedResColors[I].Dsc <> DBAppGlobals.ResColors[I].Dsc) then
        begin
          FaoundChange_clrRes := true;
          break
        end;
      end;
      qry.SQL.Clear;
      qry.SQL.Add('select * from ' +  tbInfo.GetTableName + ' where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + '=''' + IniAppglobals.WkstCode+'''');
      qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
      qry.open;
      if qry.EOF then
         FaoundChange_clrRes := true;
    end;

    if J = 7 then
    begin
      for i := Low(DBAppGlobals.CapResColors) to High(DBAppGlobals.CapResColors) do
      begin
        if (DBAppGlobals.SavedCapResColors[I].int <> DBAppGlobals.CapResColors[I].int) or
           (DBAppGlobals.SavedCapResColors[I].brd <> DBAppGlobals.CapResColors[I].brd) or
           (DBAppGlobals.SavedCapResColors[I].txt <> DBAppGlobals.CapResColors[I].txt) or
           (DBAppGlobals.SavedCapResColors[I].Dsc <> DBAppGlobals.CapResColors[I].Dsc) then
        begin
          FaoundChange_clrCapRes := true;
          break
        end;
      end;

      qry.SQL.Clear;
      qry.SQL.Add('select * from ' +  tbInfo.GetTableName + ' where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + '=''' + IniAppglobals.WkstCode+'''');
      qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
      qry.open;
      if qry.EOF then
         FaoundChange_clrCapRes := true;
    end;

{      if not FaoundChange then
      begin
        qry.connection.Commit;
        qry.Close;
        qry.free;
        exit;
      end;    }
    if not FaoundChange_colorJobToJob and not
           FaoundChange_clrCapToJob and not
           FaoundChange_colorJobToRes and not
           FaoundChange_colorStatus  and not
           FaoundChange_colorDateWarn and not
           FaoundChange_colorMatWarn and not
           FaoundChange_clrRes and not
           FaoundChange_clrCapRes
    then continue;

    FaoundChange_colorJobToJob := false;
    FaoundChange_clrCapToJob := false;
    FaoundChange_colorJobToRes := false;
    FaoundChange_colorStatus := false;
    FaoundChange_colorDateWarn := false;
    FaoundChange_colorMatWarn := false;
    FaoundChange_clrRes := false;
    FaoundChange_clrCapRes := false;

    qry.SQL.Clear;
    qry.SQL.Add('delete from ' +  tbInfo.GetTableName + ' where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + '=''' + IniAppglobals.WkstCode+'''');
    qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
    qry.ExecSQL;
    qry.Close;
    qry.SQL.Clear;

    arraysize := -1;

    qry.SQL.Add('insert into ' + tbInfo.GetTableName + '(');
    qry.SQL.Add(CreateFld(tbInfo.pfx, fli_identifier) + ',');
    qry.SQL.Add(CreateFld(tbInfo.pfx, fli_wkstCode) + ',');
    qry.SQL.Add(CreateFld(tbInfo.pfx, fli_ValFrom) + ',');
    qry.SQL.Add(CreateFld(tbInfo.pfx, fli_intColor) + ',');
    qry.SQL.Add(CreateFld(tbInfo.pfx, fli_bdrColor) + ',');

    if J > 2 then   //if we are saving description
    begin
      qry.SQL.Add(CreateFld(tbInfo.pfx, fli_txtColor) + ',');
      qry.SQL.Add(CreateFld(tbInfo.pfx, fli_txtDescription) + ')');
    end
    else
      qry.SQL.Add(CreateFld(tbInfo.pfx, fli_txtColor) + ')');

    qry.SQL.Add(' values (');
    qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_identifier) + ',');
    qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wkstCode) + ',');
    qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_ValFrom) + ',');
    qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_intColor) + ',');
    qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_bdrColor) + ',');

    if J > 2 then   //if we are saving description
    begin
      qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_txtColor) + ',');
      qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_txtDescription));
    end
    else
      qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_txtColor));

    qry.SQL.Add(')');

    case J of
      0 : begin

            arraysize := -1;
            for i := Low(DBAppGlobals.JobToJobCompColor) to High(DBAppGlobals.JobToJobCompColor) do
            begin
             { Inc(arraysize);
              qry.params.arraysize := arraysize + 1;
              qry.params[0].AsStrings[arraysize] := IniAppGlobals.Identifier;
              qry.params[1].AsStrings[arraysize] := IniAppGlobals.WkstCode;
              qry.params[2].AsIntegers[arraysize] := I;
              color := Integer(DBAppGlobals.JobToJobCompColor[I].int);
              qry.params[3].AsIntegers[arraysize] := Color;
              color := Integer(DBAppGlobals.JobToJobCompColor[I].brd);
              qry.params[4].AsIntegers[arraysize] := Color;
              color := Integer(DBAppGlobals.JobToJobCompColor[I].txt);
              qry.params[5].AsIntegers[arraysize] := Color;  }

              qry.ParamByName(CreateFld(tbInfo.pfx, fli_identifier)).AsString := IniAppGlobals.Identifier;
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_wkstCode)).AsString := IniAppGlobals.WkstCode;
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_ValFrom)).AsInteger := I;
              color := Integer(DBAppGlobals.JobToJobCompColor[I].int);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_intColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.JobToJobCompColor[I].brd);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_bdrColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.JobToJobCompColor[I].txt);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_txtColor)).AsInteger := Color;
              qry.ExecSQL;
            end;
           // if arraysize >= 0 then
           //   qry.execute(arraysize + 1);

          end;

      1 : begin

            arraysize := -1;
            for i := Low(DBAppGlobals.JobToCapCompColor) to High(DBAppGlobals.JobToCapCompColor) do
            begin
            {  Inc(arraysize);
              qry.params.arraysize := arraysize + 1;
              qry.params[0].AsStrings[arraysize] := IniAppGlobals.Identifier;
              qry.params[1].AsStrings[arraysize] := IniAppGlobals.WkstCode;
              qry.params[2].AsIntegers[arraysize] := I;
              color := Integer(DBAppGlobals.JobToCapCompColor[I].int);
              qry.params[3].AsIntegers[arraysize] := Color;
              color := Integer(DBAppGlobals.JobToCapCompColor[I].brd);
              qry.params[4].AsIntegers[arraysize] := Color;
              color := Integer(DBAppGlobals.JobToCapCompColor[I].txt);
              qry.params[5].AsIntegers[arraysize] := Color;  }

              qry.ParamByName(CreateFld(tbInfo.pfx, fli_identifier)).AsString := IniAppGlobals.Identifier;
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_wkstCode)).AsString := IniAppGlobals.WkstCode;
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_ValFrom)).AsInteger := I;
              color := Integer(DBAppGlobals.JobToCapCompColor[I].int);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_intColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.JobToCapCompColor[I].brd);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_bdrColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.JobToCapCompColor[I].txt);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_txtColor)).AsInteger := Color;
              qry.ExecSQL;
            end;

           // if arraysize >= 0 then
           //   qry.execute(arraysize + 1);

          end;

      2 : begin
            arraysize := -1;

            for i := Low(DBAppGlobals.JobCapToRscCompColor) to High(DBAppGlobals.JobCapToRscCompColor) do
            begin
             { Inc(arraysize);
              qry.params.arraysize := arraysize + 1;
              qry.params[0].AsStrings[arraysize] := IniAppGlobals.Identifier;
              qry.params[1].AsStrings[arraysize] := IniAppGlobals.WkstCode;
              qry.params[2].AsIntegers[arraysize] := I;
              color := Integer(DBAppGlobals.JobCapToRscCompColor[I].int);
              qry.params[3].AsIntegers[arraysize] := Color;
              color := Integer(DBAppGlobals.JobCapToRscCompColor[I].brd);
              qry.params[4].AsIntegers[arraysize] := Color;
              color := Integer(DBAppGlobals.JobCapToRscCompColor[I].txt);
              qry.params[5].AsIntegers[arraysize] := Color;  }

              qry.ParamByName(CreateFld(tbInfo.pfx, fli_identifier)).AsString := IniAppGlobals.Identifier;
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_wkstCode)).AsString := IniAppGlobals.WkstCode;
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_ValFrom)).AsInteger := I;
              color := Integer(DBAppGlobals.JobCapToRscCompColor[I].int);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_intColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.JobCapToRscCompColor[I].brd);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_bdrColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.JobCapToRscCompColor[I].txt);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_txtColor)).AsInteger := Color;
              qry.ExecSQL;
            end;

           // if arraysize >= 0 then
           //   qry.execute(arraysize + 1);

          end;

      3 : begin
            arraysize := -1;

            for i := Low(DBAppGlobals.JobStatusColor) to High(DBAppGlobals.JobStatusColor) do
            begin
             { Inc(arraysize);
              qry.params.arraysize := arraysize + 1;
              qry.params[0].AsStrings[arraysize] := IniAppGlobals.Identifier;
              qry.params[1].AsStrings[arraysize] := IniAppGlobals.WkstCode;
              qry.params[2].AsIntegers[arraysize] := I;
              color := Integer(DBAppGlobals.JobStatusColor[I].int);
              qry.params[3].AsIntegers[arraysize]  := Color;
              color := Integer(DBAppGlobals.JobStatusColor[I].brd);
              qry.params[4].AsIntegers[arraysize]  := Color;
              color := Integer(DBAppGlobals.JobStatusColor[I].txt);
              qry.params[5].AsIntegers[arraysize]  := Color;
              Description := DBAppGlobals.JobStatusColor[I].dsc;
              qry.params[6].AsStrings[arraysize]  := Description;  }

              qry.ParamByName(CreateFld(tbInfo.pfx, fli_identifier)).AsString := IniAppGlobals.Identifier;
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_wkstCode)).AsString := IniAppGlobals.WkstCode;
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_ValFrom)).AsInteger := I;
              color := Integer(DBAppGlobals.JobStatusColor[I].int);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_intColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.JobStatusColor[I].brd);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_bdrColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.JobStatusColor[I].txt);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_txtColor)).AsInteger := Color;
              Description := DBAppGlobals.JobStatusColor[I].dsc;
              qry.ParamByName(CreateFld(tbInfo.pfx, Fli_txtDescription)).AsString := Description;
              qry.ExecSQL;
            end;

           // if arraysize >= 0 then
           //   qry.execute(arraysize + 1);

          end;

      4 : begin

            arraysize := -1;
            for i := Low(DBAppGlobals.JobDateWarningColor) to High(DBAppGlobals.JobDateWarningColor) do
            begin
            {  Inc(arraysize);
              qry.params.arraysize := arraysize + 1;
              qry.params[0].AsStrings[arraysize] := IniAppGlobals.Identifier;
              qry.params[1].AsStrings[arraysize] := IniAppGlobals.WkstCode;
              qry.params[2].AsIntegers[arraysize] := I;
              color := Integer(DBAppGlobals.JobDateWarningColor[I].int);
              qry.params[3].AsIntegers[arraysize] := Color;
              color := Integer(DBAppGlobals.JobDateWarningColor[I].brd);
              qry.params[4].AsIntegers[arraysize] := Color;
              color := Integer(DBAppGlobals.JobDateWarningColor[I].txt);
              qry.params[5].AsIntegers[arraysize] := Color;
              Description := DBAppGlobals.JobDateWarningColor[I].dsc;
              qry.params[6].AsStrings[arraysize] := Description;  }

              qry.ParamByName(CreateFld(tbInfo.pfx, fli_identifier)).AsString := IniAppGlobals.Identifier;
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_wkstCode)).AsString := IniAppGlobals.WkstCode;
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_ValFrom)).AsInteger := I;
              color := Integer(DBAppGlobals.JobDateWarningColor[I].int);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_intColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.JobDateWarningColor[I].brd);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_bdrColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.JobDateWarningColor[I].txt);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_txtColor)).AsInteger := Color;
              Description := DBAppGlobals.JobDateWarningColor[I].dsc;
              qry.ParamByName(CreateFld(tbInfo.pfx, Fli_txtDescription)).AsString := Description;
              qry.ExecSQL;
            end;

           // if arraysize >= 0 then
           //   qry.execute(arraysize + 1);

          end;

      5 : begin

            arraysize := -1;
            for i := Low(DBAppGlobals.JobMatWarningColor) to High(DBAppGlobals.JobMatWarningColor) do
            begin
             { if (DBAppGlobals.SavedJobMatWarningColor[I].int = DBAppGlobals.JobMatWarningColor[I].int) and
                 (DBAppGlobals.SavedJobMatWarningColor[I].brd = DBAppGlobals.JobMatWarningColor[I].brd) and
                 (DBAppGlobals.SavedJobMatWarningColor[I].txt = DBAppGlobals.JobMatWarningColor[I].txt) and
                 (DBAppGlobals.SavedJobMatWarningColor[I].Dsc = DBAppGlobals.JobMatWarningColor[I].Dsc) then continue;
                                            }
             { Inc(arraysize);
              qry.params.arraysize := arraysize + 1;
              qry.params[0].AsStrings[arraysize] := IniAppGlobals.Identifier;
              qry.params[1].AsStrings[arraysize] := IniAppGlobals.WkstCode;
              qry.params[2].AsIntegers[arraysize] := I;
              color := Integer(DBAppGlobals.JobMatWarningColor[I].int);
              qry.params[3].AsIntegers[arraysize] := Color;
              color := Integer(DBAppGlobals.JobMatWarningColor[I].brd);
              qry.params[4].AsIntegers[arraysize] := Color;
              color := Integer(DBAppGlobals.JobMatWarningColor[I].txt);
              qry.params[5].AsIntegers[arraysize] := Color;
              Description := DBAppGlobals.JobMatWarningColor[I].dsc;
              qry.params[6].AsStrings[arraysize] := Description;  }

              qry.ParamByName(CreateFld(tbInfo.pfx, fli_identifier)).AsString := IniAppGlobals.Identifier;
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_wkstCode)).AsString := IniAppGlobals.WkstCode;
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_ValFrom)).AsInteger := I;
              color := Integer(DBAppGlobals.JobMatWarningColor[I].int);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_intColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.JobMatWarningColor[I].brd);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_bdrColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.JobMatWarningColor[I].txt);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_txtColor)).AsInteger := Color;
              Description := DBAppGlobals.JobMatWarningColor[I].dsc;
              qry.ParamByName(CreateFld(tbInfo.pfx, Fli_txtDescription)).AsString := Description;
              qry.ExecSQL;

            end;

           // if arraysize >= 0 then
           //   qry.execute(arraysize + 1);

          end;

      6 : begin

            arraysize := -1;
            for i := Low(DBAppGlobals.ResColors) to High(DBAppGlobals.ResColors) do
            begin
             { if (DBAppGlobals.SavedResColors[I].int = DBAppGlobals.ResColors[I].int) and
                 (DBAppGlobals.SavedResColors[I].brd = DBAppGlobals.ResColors[I].brd) and
                 (DBAppGlobals.SavedResColors[I].txt = DBAppGlobals.ResColors[I].txt) and
                 (DBAppGlobals.SavedResColors[I].Dsc = DBAppGlobals.ResColors[I].Dsc) then continue; }

             { Inc(arraysize);
              qry.params.arraysize := arraysize + 1;
              qry.params[0].AsStrings[arraysize] := IniAppGlobals.Identifier;
              qry.params[1].AsStrings[arraysize] := IniAppGlobals.WkstCode;
              qry.params[2].AsIntegers[arraysize] := I;
              color := Integer(DBAppGlobals.ResColors[I].int);
              qry.params[3].AsIntegers[arraysize] := Color;
              color := Integer(DBAppGlobals.ResColors[I].brd);
              qry.params[4].AsIntegers[arraysize] := Color;
              color := Integer(DBAppGlobals.ResColors[I].txt);
              qry.params[5].AsIntegers[arraysize] := Color;
              Description := DBAppGlobals.ResColors[I].dsc;
              qry.params[6].AsStrings[arraysize] := Description; }

              qry.ParamByName(CreateFld(tbInfo.pfx, fli_identifier)).AsString := IniAppGlobals.Identifier;
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_wkstCode)).AsString := IniAppGlobals.WkstCode;
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_ValFrom)).AsInteger := I;
              color := Integer(DBAppGlobals.ResColors[I].int);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_intColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.ResColors[I].brd);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_bdrColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.ResColors[I].txt);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_txtColor)).AsInteger := Color;
              Description := DBAppGlobals.ResColors[I].dsc;
              qry.ParamByName(CreateFld(tbInfo.pfx, Fli_txtDescription)).AsString := Description;
              qry.ExecSQL;
            end;

          //  if arraysize >= 0 then
          //     qry.execute(arraysize + 1);

          end;

      7 : begin

            arraysize := -1;
            for i := Low(DBAppGlobals.CapResColors) to High(DBAppGlobals.CapResColors) do
            begin
             { Inc(arraysize);
              qry.params.arraysize := arraysize + 1;
              qry.params[0].AsStrings[arraysize] := IniAppGlobals.Identifier;
              qry.params[1].AsStrings[arraysize] := IniAppGlobals.WkstCode;
              qry.params[2].AsIntegers[arraysize] := I;

              color := Integer(DBAppGlobals.CapResColors[I].int);
              qry.params[3].AsIntegers[arraysize] := Color;
              color := Integer(DBAppGlobals.CapResColors[I].brd);
              qry.params[4].AsIntegers[arraysize] := Color;
              color := Integer(DBAppGlobals.CapResColors[I].txt);
              qry.params[5].AsIntegers[arraysize] := Color;

              Description := DBAppGlobals.CapResColors[I].dsc;
              qry.params[6].AsStrings[arraysize] := Description;  }

              qry.ParamByName(CreateFld(tbInfo.pfx, fli_identifier)).AsString := IniAppGlobals.Identifier;
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_wkstCode)).AsString := IniAppGlobals.WkstCode;
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_ValFrom)).AsInteger := I;
              color := Integer(DBAppGlobals.CapResColors[I].int);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_intColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.CapResColors[I].brd);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_bdrColor)).AsInteger := Color;
              color := Integer(DBAppGlobals.CapResColors[I].txt);
              qry.ParamByName(CreateFld(tbInfo.pfx, fli_txtColor)).AsInteger := Color;

              Description := DBAppGlobals.CapResColors[I].dsc;
              qry.ParamByName(CreateFld(tbInfo.pfx, Fli_txtDescription)).AsString := Description;
              qry.ExecSQL;
            end;

           // if arraysize >= 0 then
           //    qry.execute(arraysize + 1);

          end;

    end;

  end;

  qry.connection.Commit;
  qry.Close;
  qry.free;

end;

//----------------------------------------------------------------------------//

procedure SavePropBin;
var
  qry:    TMqmQuery;
  tbBinProp : ^TTblInfo;
  i: integer;
begin
  qry := CreateQuery(Cfg_DB);
//  Qry.Transaction := CreateTransaction(Cfg_DB);
//  Qry.Transaction.StartTransaction;

  // set the property into database

  tbBinProp := @tblInfo[tbl_cfg_bin_showProp];

  with qry do
  begin

    SQL.Clear;
    SQL.Add('delete from ' + tbBinProp.GetTableName + ' where ' + CreateFld(tbBinProp.pfx, fli_wkstCode) + ' = ''' +  IniAppGlobals.WkstCode + '''');
    SQL.Add(AND_IDF_Condition(CreateFld(tbBinProp.pfx, fli_Identifier)));
    ExecSQL;
    Close;

    SQL.Clear;
  //WARNING THE QUERY PARAMETERS ARE ACCESSED BY INDEX!
    SQL.Add('insert into ' + tbBinProp.GetTableName + '(');
    SQL.Add(CreateFld(tbBinProp.pfx, fli_Identifier) + ',');
    SQL.Add(CreateFld(tbBinProp.pfx, fli_wkstCode) + ',');
    for i := 1 to 60 do
    begin
      if i < 60 then
        SQL.Add(CreateFld(tbBinProp.pfx, fli_FiltPropCode) + IntToStr(i) + ',')
      else
        SQL.Add(CreateFld(tbBinProp.pfx, fli_FiltPropCode) + IntToStr(i));
    end;
    SQL.Add(') values (');
    SQL.Add(':' + CreateFld(tbBinProp.pfx, fli_Identifier) + ',');
    SQL.Add(':' + CreateFld(tbBinProp.pfx, fli_wkstCode) + ',');
    for i := 1 to 60 do
    begin
      if i < 60 then
        SQL.Add(':' + CreateFld(tbBinProp.pfx, fli_FiltPropCode) + IntToStr(i) + ',')
      else
        SQL.Add(':' + CreateFld(tbBinProp.pfx, fli_FiltPropCode) + IntToStr(i));
    end;
    SQL.Add(')');
  //  Prepare;

    ParamByName(CreateFld(tbBinProp.pfx, fli_Identifier)).AsString  := IniAppGlobals.Identifier;
    ParamByName(CreateFld(tbBinProp.pfx, fli_wkstCode)).AsString  := IniAppGlobals.WkstCode;

    for i := 1 to 60 do
    begin
      if DBAppGlobals.ShowBinPropArry[I-1] <> nil then
        ParamByName(CreateFld(tbBinProp.pfx, fli_FiltPropCode) + IntToStr(i)).AsString := GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[i-1])
      else
        ParamByName(CreateFld(tbBinProp.pfx, fli_FiltPropCode) + IntToStr(i)).AsString := '';
    end;

    ExecSQL;

    Close;
  end;

  qry.connection.Commit;

  qry.Free;


end;

//----------------------------------------------------------------------------//

Procedure SaveLanguage;
begin
   WriteStrToIniFile(RgMqmSezCfg, RgCfgLanguage, DBAppGlobals.Language, Iniappglobals.WkstCode, True);
end;

procedure GlobSaveIniValues;
begin

  //if not reCheckServerConnection then
  //  if not ReconnectMsg then Exit;

  with IniAppGlobals do
  begin

    // Environment
    WriteStrToIniFile(RgMqmSezCfg, RgCfgServer,     Server, WkstCode, true);

    WriteStrToIniFile(RgMqmSezCfg, RgCfgMainDBPath, MainDBPath, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgCfgMainDBName, MainDBName, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgCfgCfgDBPath,  CfgDBPath, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgCfgCfgDBName,  CfgDBName, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgSrvNameDefine, SrvNameUserDefine, WkstCode, true);
//    WriteStrToIniFile(RgMqmSezCfg, RgCfgMudulesServed, MudulesServed, WkstCode, true);

//    WriteStrToIniFile(RgMqmSezCfg, RgCfgAS400alias, Alias, WkstCode, true);

    // Temp DB
    WriteStrToIniFile(RgMqmSezCfg, RgCfgArcDBPath, ArcDBPath, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgCfgArcDBName, ArcDBName, WkstCode, true);

    WriteStrToIniFile(RgMqmSezCfg, RgCfgPcalias, PCAlias, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgRepoPlanProp,  FilePlanPropRepo, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgPreparationExeName, PreparationExeName, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgDaysKeepHistory, DaysKeepHistory, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgCfgTimeSrvLoop, TimeLoop, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgCfgOperateTimeLoopDnldUpload, OperateTimeLoopDnldUpload, WkstCode, true);
  	WriteStrToIniFile(RgMqmSezCfg, RgCfgOperateWaitingTimeUploadDnld, OperateWaitingTimeUploadDnld, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgCopiedSchedTypeFromMqm, CopiedSchedTypeFromMqm, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgCBCopiedSchedTypeFromMqm, CBCopiedSchedTypeFromMqm, WkstCode, true);
//    WriteStrToIniFile(RgMqmSezCfg, RgCBForceMqmScheduleDetails, CBForceMqmScheduleDetails, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgCopiedBackwardFromMqmDays, CopiedBackwardFromMqmDays, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgCBCopiedBackwardFromMqmDays, CBCopiedBackwardFromMqmDays, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgDwnTypeMode, DwnTypeMode, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgLoopWithMqmCg, DwnLoopWithMqmCg, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgHostDateFormat,  HostDateFormat, WkstCode, true);
//    WriteStrToIniFile(RgMqmSezCfg, RgLoginAuto, LoginAuto, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgTimePickerEndLoop, TimePickerEndLoop, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgDndArchiveName, DndArchiveName, WkstCode, true);
//    WriteStrToIniFile(RgMqmSezCfg, RgUser, User, WkstCode, true);
//    WriteStrToIniFile(RgMqmSezCfg, RgPassword, Password, WkstCode, true);

    WriteStrToIniFile(RgMqmSezCfg, RgIdentifier, Identifier, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgCfgOdbcalias, AliasOdbc, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgDownloadTo, DownloadTo, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgDownloadFrom, DownloadFrom , WkstCode, true);

    WriteStrToIniFile(RgMqmSezCfg, RgIBUserName, IBUserName, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgIBPassword, IBPassword, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgIBDataSource, IBDataSource, WkstCode, true);

    WriteStrToIniFile(RgMqmSezCfg, RgStartCheck, StartCheck, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgEndCheck, EndCheck, WkstCode, true);

    if ExtractFileName(Application.ExeName) = 'MqmConfig.exe' then
    begin

      {$ifdef Enc}
      NOWDB2Password      := Encrypt(NOWDB2Password);
      NOWDB2PasswordLocal := Encrypt(NOWDB2PasswordLocal);
      NOWOraclePassword   := Encrypt(NOWOraclePassword);
      NOWOraclePasswordLocal := Encrypt(NOWOraclePasswordLocal);
      ODBCPassword        := Encrypt(ODBCPassword);
      {$endif}

      WriteStrToIniFile(RgMqmSezCfg, RgNOWDB2InstanceName, NOWDB2InstanceName , WkstCode, true);
      WriteStrToIniFile(RgMqmSezCfg, RgNOWDB2UserName, NOWDB2UserName , WkstCode, true);
      WriteStrToIniFile(RgMqmSezCfg, RgNOWDB2Password, NOWDB2Password , WkstCode, true);
      WriteStrToIniFile(RgMqmSezCfg, RgNOWDB2DataSource, NOWDB2DataSource, WkstCode, true);
      WriteStrToIniFile(RgMqmSezCfg, RgNOWDB2SrvIP, NOWDB2SrvIP, WkstCode, true);
      WriteStrToIniFile(RgMqmSezCfg, RgNOWDB2PORT, NOWDB2PORT, WkstCode, true);

      WriteStrToIniFile(RgMqmSezCfg, RgNOWDB2InstanceNameLocal, NOWDB2InstanceNameLocal , WkstCode, true);
      WriteStrToIniFile(RgMqmSezCfg, RgNOWDB2UserNameLocal, NOWDB2UserNameLocal , WkstCode, true);
      WriteStrToIniFile(RgMqmSezCfg, RgNOWDB2PasswordLocal, NOWDB2PasswordLocal , WkstCode, true);
      WriteStrToIniFile(RgMqmSezCfg, RgNOWDB2DataSourceLocal, NOWDB2DataSourceLocal, WkstCode, true);
      WriteStrToIniFile(RgMqmSezCfg, RgNOWDB2SrvIPLocal, NOWDB2SrvIPLocal, WkstCode, true);
      WriteStrToIniFile(RgMqmSezCfg, RgNOWDB2PORTLocal, NOWDB2PORTLocal, WkstCode, true);

      WriteStrToIniFile(RgMqmSezCfg, RgNOWOracleIp, NOWOracleIp, WkstCode, true);
      WriteStrToIniFile(RgMqmSezCfg, RgNOWOracleTNSName, NOWOracleTNSName, WkstCode, true);
      WriteStrToIniFile(RgMqmSezCfg, RgNOWOracleUserName, NOWOracleUserName, WkstCode, true);
      WriteStrToIniFile(RgMqmSezCfg, RgNOWOraclePassword, NOWOraclePassword, WkstCode, true);

      WriteStrToIniFile(RgMqmSezCfg, RgNOWOracleIpLocal, NOWOracleIpLocal, WkstCode, true);
      WriteStrToIniFile(RgMqmSezCfg, RgNOWOracleTNSNameLocal, NOWOracleTNSNameLocal, WkstCode, true);
      WriteStrToIniFile(RgMqmSezCfg, RgNOWOracleUserNameLocal, NOWOracleUserNameLocal, WkstCode, true);
      WriteStrToIniFile(RgMqmSezCfg, RgNOWOraclePasswordLocal, NOWOraclePasswordLocal, WkstCode, true);

      WriteStrToIniFile(RgMqmSezCfg, RgODBCDriver, ODBCDriverName, WkstCode, true);
      WriteStrToIniFile(RgMqmSezCfg, RgODBCUserName, ODBCUserName, WkstCode, true);
      WriteStrToIniFile(RgMqmSezCfg, RgODBCPassword, ODBCPassword, WkstCode, true);

    end;

  	WriteStrToIniFile(RgMqmSezCfg, RgCheckTimer, CheckTimer, WkstCode, true);
//    WriteStrToIniFile(RgMqmSezCfg, RgClientConnectionCheck, ClientConnectionCheck, WkstCode, true);

    WriteStrToIniFile(RgMqmSezCfg, RgShowPropColor_Standart_RGB, ShowPropColor_Standart_RGB, WkstCode, true);
    if HtmlRowNum <> saved_HtmlRowNum then
      WriteStrToIniFile(RgMqmSezCfg, RgHtmlRowNum, HtmlRowNum, WkstCode, false);
    if ShowBinCaption <> saved_ShowBinCaption then
      WriteStrToIniFile(RgMqmSezCfg, RgShowBinCaption,  ShowBinCaption, WkstCode, false);
    if ShowBinCaptionBinReport <> saved_ShowBinCaptionBinReport then
      WriteStrToIniFile(RgMqmSezCfg, RgShowBinCaptionBinReport, ShowBinCaptionBinReport, WkstCode, false);
    if ShowCriteria <> saved_ShowCriteria then
      WriteStrToIniFile(RgMqmSezCfg, RgShowCriteria , ShowCriteria, WkstCode, false);
    if ReportComment1 <> saved_ReportComment1 then
      WriteStrToIniFile(RgMqmSezCfg, RgReportComment1, ReportComment1, WkstCode, false);
    if PagePerResource <> saved_PagePerResource then
      WriteStrToIniFile(RgMqmSezCfg, RgPagePerResource, PagePerResource, WkstCode, false);
    if IncDowntime <> saved_IncDowntime then
      WriteStrToIniFile(RgMqmSezCfg, RgIncDowntime, IncDowntime, WkstCode, false);
    if ShowUnschedJobs <> saved_ShowUnschedJobs then
      WriteStrToIniFile(RgMqmSezCfg, RgShowUnschedJobs, ShowUnschedJobs, WkstCode, false);
    if FontBinCaption <> saved_FontBinCaption then
      WriteStrToIniFile(RgMqmSezCfg, RgFontBinCaption, FontBinCaption, WkstCode, false);
    if FontBinCapSize <> saved_FontBinCapSize then
      WriteStrToIniFile(RgMqmSezCfg, RgFontBinCapSize, FontBinCapSize, WkstCode, false);
    if FontBinCapSize <> saved_FontBinCapStyle then
      WriteStrToIniFile(RgMqmSezCfg, RgFontBinCapStyle, FontBinCapStyle, WkstCode, false);
    if FontBinCapColor <> saved_FontBinCapColor then
      WriteStrToIniFile(RgMqmSezCfg, RgFontBinCapColor, FontBinCapColor, WkstCode, false);
    if FontBinCapChar <> saved_FontBinCapChar then
      WriteStrToIniFile(RgMqmSezCfg, RgFontBinCapChar, FontBinCapChar, WkstCode, false);
    if FontCriteria <> saved_FontCriteria then
      WriteStrToIniFile(RgMqmSezCfg, RgFontCriteria, FontCriteria, WkstCode, false);
    if FontCriteria <> saved_FontCriteriaSize then
      WriteStrToIniFile(RgMqmSezCfg, RgFontCriteriaSize, FontCriteriaSize, WkstCode, false);
    if FontCriteriaStyle <> saved_FontCriteriaStyle then
      WriteStrToIniFile(RgMqmSezCfg, RgFontCriteriaStyle, FontCriteriaStyle, WkstCode, false);
    if FontCriteriaColor <> saved_FontCriteriaColor then
      WriteStrToIniFile(RgMqmSezCfg, RgFontCriteriaColor, FontCriteriaColor, WkstCode, false);
    if FontCriteriaColor <> saved_FontCriteriaChar then
      WriteStrToIniFile(RgMqmSezCfg, RgFontCriteriaChar, FontCriteriaChar, WkstCode, false);
    if FontComment <> saved_FontComment then
      WriteStrToIniFile(RgMqmSezCfg, RgFontComment, FontComment, WkstCode, false);
    if FontCommentSize <> saved_FontCommentSize then
      WriteStrToIniFile(RgMqmSezCfg, RgFontCommentSize, FontCommentSize, WkstCode, false);
    if FontCommentStyle <> saved_FontCommentStyle then
      WriteStrToIniFile(RgMqmSezCfg, RgFontCommentStyle, FontCommentStyle, WkstCode, false);
    if FontCommentColor <> saved_FontCommentColor then
      WriteStrToIniFile(RgMqmSezCfg, RgFontCommentColor, FontCommentColor, WkstCode, false);
    if FontCommentColor <> saved_FontCommentColor then
      WriteStrToIniFile(RgMqmSezCfg, RgFontCommentChar, FontCommentChar, WkstCode, false);
    if FontColTitles <> saved_FontColTitles then
      WriteStrToIniFile(RgMqmSezCfg, RgFontColTitles, FontColTitles, WkstCode, false);
    if FontColTitleSize <> saved_FontColTitleSize then
      WriteStrToIniFile(RgMqmSezCfg, RgFontColTitleSize, FontColTitleSize, WkstCode, false);
    if FontColTitleStyle <> saved_FontColTitleStyle then
      WriteStrToIniFile(RgMqmSezCfg, RgFontColTitleStyle, FontColTitleStyle, WkstCode, false);
    if FontColTitleColor <> saved_FontColTitleColor then
      WriteStrToIniFile(RgMqmSezCfg, RgFontColTitleColor, FontColTitleColor, WkstCode, false);
    if FontColTitleChar <> saved_FontColTitleChar then
      WriteStrToIniFile(RgMqmSezCfg, RgFontColTitleChar, FontColTitleChar, WkstCode, false);
    if FontDataLine <> saved_FontDataLine then
      WriteStrToIniFile(RgMqmSezCfg, RgFontDataLines, FontDataLine, WkstCode, false);
    if FontDataLineSize <> saved_FontDataLineSize then
      WriteStrToIniFile(RgMqmSezCfg, RgFontDataLineSize, FontDataLineSize, WkstCode, false);
    if FontDataLineStyle <> saved_FontDataLineStyle then
      WriteStrToIniFile(RgMqmSezCfg, RgFontDataLineStyle, FontDataLineStyle, WkstCode, false);
    if FontDataLineColor <> saved_FontDataLineColor then
      WriteStrToIniFile(RgMqmSezCfg, RgFontDataLineColor, FontDataLineColor, WkstCode, false);
    if FontDataLineChar <> saved_FontDataLineChar then
      WriteStrToIniFile(RgMqmSezCfg, RgFontDataLineChar, FontDataLineChar, WkstCode, false);
    if HtmlColorBack <> saved_HtmlColorBack then
      WriteStrToIniFile(RgMqmSezCfg, RgHtmlColorBack, HtmlColorBack, WkstCode, false);
    if HtmlColorTabTitle <> saved_HtmlColorTabTitle then
      WriteStrToIniFile(RgMqmSezCfg, RgHtmlColorTabTitle, HtmlColorTabTitle, WkstCode, false);
    if HtmlColorTabEven <> saved_HtmlColorTabEven then
      WriteStrToIniFile(RgMqmSezCfg, RgHtmlColorTabEven, HtmlColorTabEven, WkstCode, false);
    if HtmlColorTabOdd <> saved_HtmlColorTabOdd then
      WriteStrToIniFile(RgMqmSezCfg, RgHtmlColorTabOdd, HtmlColorTabOdd, WkstCode, false);
    if ExcelTitle <> saved_ExcelTitle then
      WriteStrToIniFile(RgMqmSezCfg, RgExcelTitle, ExcelTitle, WkstCode, false);
    if ExcelTitleBinReport <> saved_ExcelTitleBinReport then
      WriteStrToIniFile(RgMqmSezCfg, RgExcelTitleBinReport, ExcelTitleBinReport, WkstCode, false);
    if SMTP_server <> saved_SMTP_server then
      WriteStrToIniFile(RgMqmSezCfg, RgSMTP_server, SMTP_server, WkstCode, false);
    if PORT <> saved_PORT then
      WriteStrToIniFile(RgMqmSezCfg, RgPORT, PORT, WkstCode, false);
    if LOGINWITHAUTHENTICATION <> saved_LOGINWITHAUTHENTICATION then
      WriteStrToIniFile(RgMqmSezCfg, RgLOGINWITHAUTHENTICATION, LOGINWITHAUTHENTICATION, WkstCode, false);
    if TLS_SSL <> saved_TLS_SSL then
      WriteStrToIniFile(RgMqmSezCfg, RgTLS_SSL, TLS_SSL , WkstCode, false);
    if GroupingFields <> saved_GroupingFields  then
      WriteStrToIniFile(RgMqmSezCfg, RgGroupingFields, GroupingFields, WkstCode, false);
    if JumpingFields <> saved_JumpingFields then
      WriteStrToIniFile(RgMqmSezCfg, RgJumpingFields, JumpingFields, WkstCode, false);
    if ShowGroups <> saved_ShowGroups then
      WriteStrToIniFile(RgMqmSezCfg, RgShowGroups, ShowGroups, WkstCode, false);
    if ShowResources <> saved_ShowResources then
      WriteStrToIniFile(RgMqmSezCfg, RgShowResources, ShowResources, WkstCode, false);
    if SplitByDateTimeNumOfDec <> saved_SplitByDateTimeNumOfDec then
      WriteStrToIniFile(RgMqmSezCfg, RgSplitByDateTimeNumOfDec, SplitByDateTimeNumOfDec, WkstCode, false);
    if SplitByDateTimeRoundCrit <> saved_SplitByDateTimeRoundCrit then
      WriteStrToIniFile(RgMqmSezCfg, RgSplitByDateTimeRoundCrit, SplitByDateTimeRoundCrit, WkstCode, false);
    if SplitByDateTimeReJoinBinJob <> saved_SplitByDateTimeReJoinBinJob then
      WriteStrToIniFile(RgMqmSezCfg, RgSplitByDateTimeReJoinBinJob, SplitByDateTimeReJoinBinJob, WkstCode, false);
    if SplitFromPointNumOfDec <> saved_SplitFromPointNumOfDec then
      WriteStrToIniFile(RgMqmSezCfg, RgSplitFromPointNumOfDec, SplitFromPointNumOfDec, WkstCode, false);
    if SplitFromPointRoundCrit <> saved_SplitFromPointRoundCrit then
      WriteStrToIniFile(RgMqmSezCfg, RgSplitFromPointRoundCrit, SplitFromPointRoundCrit, WkstCode, false);
    if SplitFromPointOnPreDefTime <> saved_SplitFromPointOnPreDefTime then
      WriteStrToIniFile(RgMqmSezCfg, RgSplitFromPointOnPreDefTime, SplitFromPointOnPreDefTime, WkstCode, false);
    if SplitFromPointPreDefTime <> saved_SplitFromPointPreDefTime then
      WriteStrToIniFile(RgMqmSezCfg, RgSplitFromPointPreDefTime, SplitFromPointPreDefTime, WkstCode, false);
    if NumOfDecJobQtyOnStatusBar <> saved_NumOfDecJobQtyOnStatusBar then
      WriteStrToIniFile(RgMqmSezCfg, RgNumOfDecJobQtyOnStatusBar, NumOfDecJobQtyOnStatusBar, WkstCode, false);
    WriteStrToIniFile(RgMqmSezCfg, RgShowStatusBarAsHint, IfThen(ShowStatusBarAsHint, '1', '0'), WkstCode, false);
    if Field1BinColReportStatic <> saved_Field1BinColReportStatic then
      WriteStrToIniFile(RgMqmSezCfg, RgField1BinColReportStatic, Field1BinColReportStatic, WkstCode, false);
    if Field2BinColReportStatic <> saved_Field2BinColReportStatic then
      WriteStrToIniFile(RgMqmSezCfg, RgField2BinColReportStatic, Field2BinColReportStatic, WkstCode, false);
    if Field3BinColReportStatic <> saved_Field3BinColReportStatic then
      WriteStrToIniFile(RgMqmSezCfg, RgField3BinColReportStatic, Field3BinColReportStatic, WkstCode, false);
    if Field4BinColReportStatic <> saved_Field4BinColReportStatic then
      WriteStrToIniFile(RgMqmSezCfg, RgField4BinColReportStatic, Field4BinColReportStatic, WkstCode, false);
    if Field5BinColReportStatic <> saved_Field5BinColReportStatic then
      WriteStrToIniFile(RgMqmSezCfg, RgField5BinColReportStatic, Field5BinColReportStatic, WkstCode, false);
    if Field6BinColReportStatic <> saved_Field6BinColReportStatic then
      WriteStrToIniFile(RgMqmSezCfg, RgField6BinColReportStatic, Field6BinColReportStatic, WkstCode, false);
    if Field7BinColReportStatic <> saved_Field7BinColReportStatic then
      WriteStrToIniFile(RgMqmSezCfg, RgField7BinColReportStatic, Field7BinColReportStatic, WkstCode, false);
    if Field8BinColReportStatic <> saved_Field8BinColReportStatic then
      WriteStrToIniFile(RgMqmSezCfg, RgField8BinColReportStatic, Field8BinColReportStatic, WkstCode, false);
    if Field9BinColReportStatic <> saved_Field9BinColReportStatic then
      WriteStrToIniFile(RgMqmSezCfg, RgField9BinColReportStatic, Field9BinColReportStatic, WkstCode, false);
    if Field10BinColReportStatic <> saved_Field10BinColReportStatic then
      WriteStrToIniFile(RgMqmSezCfg, RgField10BinColReportStatic, Field10BinColReportStatic, WkstCode, false);
    if Concatenation <> saved_Concatenation then
      WriteStrToIniFile(RgMqmSezCfg, RgConcatenation, Concatenation, WkstCode, false);
    if Separator <> saved_Separator then
      WriteStrToIniFile(RgMqmSezCfg, RgSeparator, Separator, WkstCode, false);
    if HeadingConcatination <> saved_HeadingConcatination then
      WriteStrToIniFile(RgMqmSezCfg, RgHeadingConcatination, HeadingConcatination, WkstCode, false);
    if HeadingSeparator <> saved_HeadingSeparator then
      WriteStrToIniFile(RgMqmSezCfg, RgHeadingSeparator, HeadingSeparator, WkstCode, false);
    if ShowColumnCaptionsReport <> saved_ShowColumnCaptionsReport then
      WriteStrToIniFile(RgMqmSezCfg, RgShowColumnCaptionsReport, ShowColumnCaptionsReport, WkstCode, false);
    if ShowColumnCaptionsBinReport <> saved_ShowColumnCaptionsBinReport then
      WriteStrToIniFile(RgMqmSezCfg, RgShowColumnCaptionsBinReport, ShowColumnCaptionsBinReport, WkstCode, false);
    if ShowTotalReport <> saved_ShowTotalReport then
      WriteStrToIniFile(RgMqmSezCfg, RgShowTotalReport, ShowTotalReport, WkstCode, false);
    if SelectedAtibute <> saved_SelectedAtibute then
      WriteStrToIniFile(RgMqmSezCfg, RgSelectedAtibute, SelectedAtibute, WkstCode, false);
    if MachineReportPeriodTitle <> saved_MachineReportPeriodTitle then
      WriteStrToIniFile(RgMqmSezCfg, RgMachineReportPeriodTitle, MachineReportPeriodTitle, WkstCode, false);
    if MachineReportPeriod <> saved_MachineReportPeriod then
      WriteStrToIniFile(RgMqmSezCfg, RgMachineReportPeriod, MachineReportPeriod, WkstCode, false);
    if MachineReportPeriodFrom <> saved_MachineReportPeriodFrom then
      WriteStrToIniFile(RgMqmSezCfg, RgMachineReportPeriodFrom, MachineReportPeriodFrom, WkstCode, false);
    if MachineReportPeriodNum <> saved_MachineReportPeriodNum then
      WriteStrToIniFile(RgMqmSezCfg, RgMachineReportPeriodNum, MachineReportPeriodNum, WkstCode, false);
    if MachineReportDaysMinusDoday <> saved_MachineReportDaysMinusDoday then
      WriteStrToIniFile(RgMqmSezCfg, RgMachineReportDaysMinusDoday, MachineReportDaysMinusDoday, WkstCode, false);
    if MachineReportShowFromToHeader <> saved_MachineReportShowFromToHeader then
      WriteStrToIniFile(RgMqmSezCfg, RgMachineReportShowFromToHeader, MachineReportShowFromToHeader, WkstCode, false);
    if MachineReportFileNameAutoOperation <> saved_MachineReportFileNameAutoOperation then
      WriteStrToIniFile(RgMqmSezCfg, RgMachineReportFileNameAutoOperation, MachineReportFileNameAutoOperation, WkstCode, false);
    if SetLimiDateUsingCapacity <> saved_SetLimiDateUsingCapacity then
      WriteStrToIniFile(RgMqmSezCfg, Rg_SetLimiDateUsingCapacity, SetLimiDateUsingCapacity, WkstCode, false);
    if SetLimiDateUsingSecureNumDays <> saved_SetLimiDateUsingSecureNumDays then
      WriteStrToIniFile(RgMqmSezCfg, Rg_SetLimiDateUsingSecureNumDays, SetLimiDateUsingSecureNumDays, WkstCode, false);
    if DBAppSettings.SuggestedTextTabJobSequence <> Saved_SuggestedTextTabJobSequence then
      WriteStrToIniFile(RgMqmSezCfg, Rg_SuggestedTextTabJobSequence, DBAppSettings.SuggestedTextTabJobSequence, WkstCode, false);

    WriteStrToIniFile(RgMqmSezCfg, Rg_FontSize, IntToStr(FontSize), WkstCode, true);
  end
end;

//----------------------------------------------------------------------------//

procedure GlobSaveIniReportValues;
begin
  with IniAppGlobals do
  begin

    // Environment
    WriteStrToIniFile(RgMqmSezCfg, RgCfgServer,     Server, WkstCode, true);

    WriteStrToIniFile(RgMqmSezCfg, RgCfgMainDBPath, MainDBPath, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgCfgMainDBName, MainDBName, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgCfgCfgDBPath,  CfgDBPath, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgCfgCfgDBName,  CfgDBName, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgSrvNameDefine, SrvNameUserDefine, WkstCode, true);
//    WriteStrToIniFile(RgMqmSezCfg, RgCfgMudulesServed, MudulesServed, WkstCode, true);

//    WriteStrToIniFile(RgMqmSezCfg, RgCfgAS400alias, Alias, WkstCode, true);

    // Temp DB
    WriteStrToIniFile(RgMqmSezCfg, RgCfgArcDBPath, ArcDBPath, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgCfgArcDBName, ArcDBName, WkstCode, true);

    WriteStrToIniFile(RgMqmSezCfg, RgCfgPcalias, PCAlias, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgRepoPlanProp,  FilePlanPropRepo, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgPreparationExeName, PreparationExeName, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgDaysKeepHistory, DaysKeepHistory, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgCfgTimeSrvLoop, TimeLoop, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgCfgOperateTimeLoopDnldUpload, OperateTimeLoopDnldUpload, WkstCode, true);
  	WriteStrToIniFile(RgMqmSezCfg, RgCfgOperateWaitingTimeUploadDnld, OperateWaitingTimeUploadDnld, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgCopiedSchedTypeFromMqm, CopiedSchedTypeFromMqm, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgCBCopiedSchedTypeFromMqm, CBCopiedSchedTypeFromMqm, WkstCode, true);
//    WriteStrToIniFile(RgMqmSezCfg, RgCBForceMqmScheduleDetails, CBForceMqmScheduleDetails, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgCopiedBackwardFromMqmDays, CopiedBackwardFromMqmDays, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgCBCopiedBackwardFromMqmDays, CBCopiedBackwardFromMqmDays, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgDwnTypeMode, DwnTypeMode, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgLoopWithMqmCg, DwnLoopWithMqmCg, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgHostDateFormat,  HostDateFormat, WkstCode, true);
//    WriteStrToIniFile(RgMqmSezCfg, RgLoginAuto, LoginAuto, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgTimePickerEndLoop, TimePickerEndLoop, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgDndArchiveName, DndArchiveName, WkstCode, true);
//    WriteStrToIniFile(RgMqmSezCfg, RgUser, User, WkstCode, true);
//    WriteStrToIniFile(RgMqmSezCfg, RgPassword, Password, WkstCode, true);

    WriteStrToIniFile(RgMqmSezCfg, RgIdentifier, Identifier, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgCfgOdbcalias, AliasOdbc, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgDownloadTo, DownloadTo, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgDownloadFrom, DownloadFrom , WkstCode, true);

    WriteStrToIniFile(RgMqmSezCfg, RgIBUserName, IBUserName, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgIBPassword, IBPassword, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgIBDataSource, IBDataSource, WkstCode, true);

    WriteStrToIniFile(RgMqmSezCfg, RgStartCheck, StartCheck, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgEndCheck, EndCheck, WkstCode, true);

{    WriteStrToIniFile(RgMqmSezCfg, RgNOWDB2InstanceName, NOWDB2InstanceName , WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgNOWDB2UserName, NOWDB2UserName , WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgNOWDB2Password, NOWDB2Password , WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgNOWDB2DataSource, NOWDB2DataSource, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgNOWDB2SrvIP, NOWDB2SrvIP, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgNOWDB2PORT, NOWDB2PORT, WkstCode, true);

    WriteStrToIniFile(RgMqmSezCfg, RgNOWDB2InstanceNameLocal, NOWDB2InstanceNameLocal , WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgNOWDB2UserNameLocal, NOWDB2UserNameLocal , WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgNOWDB2PasswordLocal, NOWDB2PasswordLocal , WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgNOWDB2DataSourceLocal, NOWDB2DataSourceLocal, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgNOWDB2SrvIPLocal, NOWDB2SrvIPLocal, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgNOWDB2PORTLocal, NOWDB2PORTLocal, WkstCode, true);

    WriteStrToIniFile(RgMqmSezCfg, RgNOWOracleIp, NOWOracleIp, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgNOWOracleTNSName, NOWOracleTNSName, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgNOWOracleUserName, NOWOracleUserName, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgNOWOraclePassword, NOWOraclePassword, WkstCode, true);

    WriteStrToIniFile(RgMqmSezCfg, RgNOWOracleIpLocal, NOWOracleIpLocal, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgNOWOracleTNSNameLocal, NOWOracleTNSNameLocal, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgNOWOracleUserNameLocal, NOWOracleUserNameLocal, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgNOWOraclePasswordLocal, NOWOraclePasswordLocal, WkstCode, true);

    WriteStrToIniFile(RgMqmSezCfg, RgODBCDriver, ODBCDriverName, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgODBCUserName, ODBCUserName, WkstCode, true);
    WriteStrToIniFile(RgMqmSezCfg, RgODBCPassword, ODBCPassword, WkstCode, true);

    Encrypted := '1';
    WriteStrToIniFile(RgMqmSezCfg, RgEncrypted, Encrypted, WkstCode, true); }
  	WriteStrToIniFile(RgMqmSezCfg, RgCheckTimer, CheckTimer, WkstCode, true);
//    WriteStrToIniFile(RgMqmSezCfg, RgClientConnectionCheck, ClientConnectionCheck, WkstCode, true);

    WriteStrToIniFile(RgMqmSezCfg, RgShowPropColor_Standart_RGB, ShowPropColor_Standart_RGB, WkstCode, true);
    if HtmlRowNum <> saved_HtmlRowNum then
      WriteStrToIniFile(RgMqmSezCfg, RgHtmlRowNum, HtmlRowNum, WkstCode, false);
    if ShowBinCaption <> saved_ShowBinCaption then
      WriteStrToIniFile(RgMqmSezCfg, RgShowBinCaption,  ShowBinCaption, WkstCode, false);
    if ShowBinCaptionBinReport <> saved_ShowBinCaptionBinReport then
      WriteStrToIniFile(RgMqmSezCfg, RgShowBinCaptionBinReport, ShowBinCaptionBinReport, WkstCode, false);
    if ShowCriteria <> saved_ShowCriteria then
      WriteStrToIniFile(RgMqmSezCfg, RgShowCriteria , ShowCriteria, WkstCode, false);
    if ReportComment1 <> saved_ReportComment1 then
      WriteStrToIniFile(RgMqmSezCfg, RgReportComment1, ReportComment1, WkstCode, false);
    if PagePerResource <> saved_PagePerResource then
      WriteStrToIniFile(RgMqmSezCfg, RgPagePerResource, PagePerResource, WkstCode, false);
    if IncDowntime <> saved_IncDowntime then
      WriteStrToIniFile(RgMqmSezCfg, RgIncDowntime, IncDowntime, WkstCode, false);
    if ShowUnschedJobs <> saved_ShowUnschedJobs then
      WriteStrToIniFile(RgMqmSezCfg, RgShowUnschedJobs, ShowUnschedJobs, WkstCode, false);
    if FontBinCaption <> saved_FontBinCaption then
      WriteStrToIniFile(RgMqmSezCfg, RgFontBinCaption, FontBinCaption, WkstCode, false);
    if FontBinCapSize <> saved_FontBinCapSize then
      WriteStrToIniFile(RgMqmSezCfg, RgFontBinCapSize, FontBinCapSize, WkstCode, false);
    if FontBinCapSize <> saved_FontBinCapStyle then
      WriteStrToIniFile(RgMqmSezCfg, RgFontBinCapStyle, FontBinCapStyle, WkstCode, false);
    if FontBinCapColor <> saved_FontBinCapColor then
      WriteStrToIniFile(RgMqmSezCfg, RgFontBinCapColor, FontBinCapColor, WkstCode, false);
    if FontBinCapChar <> saved_FontBinCapChar then
      WriteStrToIniFile(RgMqmSezCfg, RgFontBinCapChar, FontBinCapChar, WkstCode, false);
    if FontCriteria <> saved_FontCriteria then
      WriteStrToIniFile(RgMqmSezCfg, RgFontCriteria, FontCriteria, WkstCode, false);
    if FontCriteria <> saved_FontCriteriaSize then
      WriteStrToIniFile(RgMqmSezCfg, RgFontCriteriaSize, FontCriteriaSize, WkstCode, false);
    if FontCriteriaStyle <> saved_FontCriteriaStyle then
      WriteStrToIniFile(RgMqmSezCfg, RgFontCriteriaStyle, FontCriteriaStyle, WkstCode, false);
    if FontCriteriaColor <> saved_FontCriteriaColor then
      WriteStrToIniFile(RgMqmSezCfg, RgFontCriteriaColor, FontCriteriaColor, WkstCode, false);
    if FontCriteriaColor <> saved_FontCriteriaChar then
      WriteStrToIniFile(RgMqmSezCfg, RgFontCriteriaChar, FontCriteriaChar, WkstCode, false);
    if FontComment <> saved_FontComment then
      WriteStrToIniFile(RgMqmSezCfg, RgFontComment, FontComment, WkstCode, false);
    if FontCommentSize <> saved_FontCommentSize then
      WriteStrToIniFile(RgMqmSezCfg, RgFontCommentSize, FontCommentSize, WkstCode, false);
    if FontCommentStyle <> saved_FontCommentStyle then
      WriteStrToIniFile(RgMqmSezCfg, RgFontCommentStyle, FontCommentStyle, WkstCode, false);
    if FontCommentColor <> saved_FontCommentColor then
      WriteStrToIniFile(RgMqmSezCfg, RgFontCommentColor, FontCommentColor, WkstCode, false);
    if FontCommentColor <> saved_FontCommentColor then
      WriteStrToIniFile(RgMqmSezCfg, RgFontCommentChar, FontCommentChar, WkstCode, false);
    if FontColTitles <> saved_FontColTitles then
      WriteStrToIniFile(RgMqmSezCfg, RgFontColTitles, FontColTitles, WkstCode, false);
    if FontColTitleSize <> saved_FontColTitleSize then
      WriteStrToIniFile(RgMqmSezCfg, RgFontColTitleSize, FontColTitleSize, WkstCode, false);
    if FontColTitleStyle <> saved_FontColTitleStyle then
      WriteStrToIniFile(RgMqmSezCfg, RgFontColTitleStyle, FontColTitleStyle, WkstCode, false);
    if FontColTitleColor <> saved_FontColTitleColor then
      WriteStrToIniFile(RgMqmSezCfg, RgFontColTitleColor, FontColTitleColor, WkstCode, false);
    if FontColTitleChar <> saved_FontColTitleChar then
      WriteStrToIniFile(RgMqmSezCfg, RgFontColTitleChar, FontColTitleChar, WkstCode, false);
    if FontDataLine <> saved_FontDataLine then
      WriteStrToIniFile(RgMqmSezCfg, RgFontDataLines, FontDataLine, WkstCode, false);
    if FontDataLineSize <> saved_FontDataLineSize then
      WriteStrToIniFile(RgMqmSezCfg, RgFontDataLineSize, FontDataLineSize, WkstCode, false);
    if FontDataLineStyle <> saved_FontDataLineStyle then
      WriteStrToIniFile(RgMqmSezCfg, RgFontDataLineStyle, FontDataLineStyle, WkstCode, false);
    if FontDataLineColor <> saved_FontDataLineColor then
      WriteStrToIniFile(RgMqmSezCfg, RgFontDataLineColor, FontDataLineColor, WkstCode, false);
    if FontDataLineChar <> saved_FontDataLineChar then
      WriteStrToIniFile(RgMqmSezCfg, RgFontDataLineChar, FontDataLineChar, WkstCode, false);
    if HtmlColorBack <> saved_HtmlColorBack then
      WriteStrToIniFile(RgMqmSezCfg, RgHtmlColorBack, HtmlColorBack, WkstCode, false);
    if HtmlColorTabTitle <> saved_HtmlColorTabTitle then
      WriteStrToIniFile(RgMqmSezCfg, RgHtmlColorTabTitle, HtmlColorTabTitle, WkstCode, false);
    if HtmlColorTabEven <> saved_HtmlColorTabEven then
      WriteStrToIniFile(RgMqmSezCfg, RgHtmlColorTabEven, HtmlColorTabEven, WkstCode, false);
    if HtmlColorTabOdd <> saved_HtmlColorTabOdd then
      WriteStrToIniFile(RgMqmSezCfg, RgHtmlColorTabOdd, HtmlColorTabOdd, WkstCode, false);
    if ExcelTitle <> saved_ExcelTitle then
      WriteStrToIniFile(RgMqmSezCfg, RgExcelTitle, ExcelTitle, WkstCode, false);
    if ExcelTitleBinReport <> saved_ExcelTitleBinReport then
      WriteStrToIniFile(RgMqmSezCfg, RgExcelTitleBinReport, ExcelTitleBinReport, WkstCode, false);
    if SMTP_server <> saved_SMTP_server then
      WriteStrToIniFile(RgMqmSezCfg, RgSMTP_server, SMTP_server, WkstCode, false);
    if PORT <> saved_PORT then
      WriteStrToIniFile(RgMqmSezCfg, RgPORT, PORT, WkstCode, false);
    if LOGINWITHAUTHENTICATION <> saved_LOGINWITHAUTHENTICATION then
      WriteStrToIniFile(RgMqmSezCfg, RgLOGINWITHAUTHENTICATION, LOGINWITHAUTHENTICATION, WkstCode, false);
    if TLS_SSL <> saved_TLS_SSL then
      WriteStrToIniFile(RgMqmSezCfg, RgTLS_SSL, TLS_SSL , WkstCode, false);
    if GroupingFields <> saved_GroupingFields  then
      WriteStrToIniFile(RgMqmSezCfg, RgGroupingFields, GroupingFields, WkstCode, false);
    if JumpingFields <> saved_JumpingFields then
      WriteStrToIniFile(RgMqmSezCfg, RgJumpingFields, JumpingFields, WkstCode, false);
    if ShowGroups <> saved_ShowGroups then
      WriteStrToIniFile(RgMqmSezCfg, RgShowGroups, ShowGroups, WkstCode, false);
    if ShowResources <> saved_ShowResources then
      WriteStrToIniFile(RgMqmSezCfg, RgShowResources, ShowResources, WkstCode, false);
    if SplitByDateTimeNumOfDec <> saved_SplitByDateTimeNumOfDec then
      WriteStrToIniFile(RgMqmSezCfg, RgSplitByDateTimeNumOfDec, SplitByDateTimeNumOfDec, WkstCode, false);
    if SplitByDateTimeRoundCrit <> saved_SplitByDateTimeRoundCrit then
      WriteStrToIniFile(RgMqmSezCfg, RgSplitByDateTimeRoundCrit, SplitByDateTimeRoundCrit, WkstCode, false);
    if SplitByDateTimeReJoinBinJob <> saved_SplitByDateTimeReJoinBinJob then
      WriteStrToIniFile(RgMqmSezCfg, RgSplitByDateTimeReJoinBinJob, SplitByDateTimeReJoinBinJob, WkstCode, false);
    if SplitFromPointNumOfDec <> saved_SplitFromPointNumOfDec then
      WriteStrToIniFile(RgMqmSezCfg, RgSplitFromPointNumOfDec, SplitFromPointNumOfDec, WkstCode, false);
    if SplitFromPointRoundCrit <> saved_SplitFromPointRoundCrit then
      WriteStrToIniFile(RgMqmSezCfg, RgSplitFromPointRoundCrit, SplitFromPointRoundCrit, WkstCode, false);
    if SplitFromPointOnPreDefTime <> saved_SplitFromPointOnPreDefTime then
      WriteStrToIniFile(RgMqmSezCfg, RgSplitFromPointOnPreDefTime, SplitFromPointOnPreDefTime, WkstCode, false);
    if SplitFromPointPreDefTime <> saved_SplitFromPointPreDefTime then
      WriteStrToIniFile(RgMqmSezCfg, RgSplitFromPointPreDefTime, SplitFromPointPreDefTime, WkstCode, false);
    if NumOfDecJobQtyOnStatusBar <> saved_NumOfDecJobQtyOnStatusBar then
      WriteStrToIniFile(RgMqmSezCfg, RgNumOfDecJobQtyOnStatusBar, NumOfDecJobQtyOnStatusBar, WkstCode, false);
    WriteStrToIniFile(RgMqmSezCfg, RgShowStatusBarAsHint, IfThen(ShowStatusBarAsHint, '1', '0'), WkstCode, false);
    if Field1BinColReportStatic <> saved_Field1BinColReportStatic then
      WriteStrToIniFile(RgMqmSezCfg, RgField1BinColReportStatic, Field1BinColReportStatic, WkstCode, false);
    if Field2BinColReportStatic <> saved_Field2BinColReportStatic then
      WriteStrToIniFile(RgMqmSezCfg, RgField2BinColReportStatic, Field2BinColReportStatic, WkstCode, false);
    if Field3BinColReportStatic <> saved_Field3BinColReportStatic then
      WriteStrToIniFile(RgMqmSezCfg, RgField3BinColReportStatic, Field3BinColReportStatic, WkstCode, false);
    if Field4BinColReportStatic <> saved_Field4BinColReportStatic then
      WriteStrToIniFile(RgMqmSezCfg, RgField4BinColReportStatic, Field4BinColReportStatic, WkstCode, false);
    if Field5BinColReportStatic <> saved_Field5BinColReportStatic then
      WriteStrToIniFile(RgMqmSezCfg, RgField5BinColReportStatic, Field5BinColReportStatic, WkstCode, false);
    if Field6BinColReportStatic <> saved_Field6BinColReportStatic then
      WriteStrToIniFile(RgMqmSezCfg, RgField6BinColReportStatic, Field6BinColReportStatic, WkstCode, false);
    if Field7BinColReportStatic <> saved_Field7BinColReportStatic then
      WriteStrToIniFile(RgMqmSezCfg, RgField7BinColReportStatic, Field7BinColReportStatic, WkstCode, false);
    if Field8BinColReportStatic <> saved_Field8BinColReportStatic then
      WriteStrToIniFile(RgMqmSezCfg, RgField8BinColReportStatic, Field8BinColReportStatic, WkstCode, false);
    if Field9BinColReportStatic <> saved_Field9BinColReportStatic then
      WriteStrToIniFile(RgMqmSezCfg, RgField9BinColReportStatic, Field9BinColReportStatic, WkstCode, false);
    if Field10BinColReportStatic <> saved_Field10BinColReportStatic then
      WriteStrToIniFile(RgMqmSezCfg, RgField10BinColReportStatic, Field10BinColReportStatic, WkstCode, false);
    if Concatenation <> saved_Concatenation then
      WriteStrToIniFile(RgMqmSezCfg, RgConcatenation, Concatenation, WkstCode, false);
    if Separator <> saved_Separator then
      WriteStrToIniFile(RgMqmSezCfg, RgSeparator, Separator, WkstCode, false);
    if HeadingConcatination <> saved_HeadingConcatination then
      WriteStrToIniFile(RgMqmSezCfg, RgHeadingConcatination, HeadingConcatination, WkstCode, false);
    if HeadingSeparator <> saved_HeadingSeparator then
      WriteStrToIniFile(RgMqmSezCfg, RgHeadingSeparator, HeadingSeparator, WkstCode, false);
    if ShowColumnCaptionsReport <> saved_ShowColumnCaptionsReport then
      WriteStrToIniFile(RgMqmSezCfg, RgShowColumnCaptionsReport, ShowColumnCaptionsReport, WkstCode, false);
    if ShowColumnCaptionsBinReport <> saved_ShowColumnCaptionsBinReport then
      WriteStrToIniFile(RgMqmSezCfg, RgShowColumnCaptionsBinReport, ShowColumnCaptionsBinReport, WkstCode, false);
    if ShowTotalReport <> saved_ShowTotalReport then
      WriteStrToIniFile(RgMqmSezCfg, RgShowTotalReport, ShowTotalReport, WkstCode, false);
    if SelectedAtibute <> saved_SelectedAtibute then
      WriteStrToIniFile(RgMqmSezCfg, RgSelectedAtibute, SelectedAtibute, WkstCode, false);
    if MachineReportPeriodTitle <> saved_MachineReportPeriodTitle then
      WriteStrToIniFile(RgMqmSezCfg, RgMachineReportPeriodTitle, MachineReportPeriodTitle, WkstCode, false);
    if MachineReportPeriod <> saved_MachineReportPeriod then
      WriteStrToIniFile(RgMqmSezCfg, RgMachineReportPeriod, MachineReportPeriod, WkstCode, false);
    if MachineReportPeriodFrom <> saved_MachineReportPeriodFrom then
      WriteStrToIniFile(RgMqmSezCfg, RgMachineReportPeriodFrom, MachineReportPeriodFrom, WkstCode, false);
    if MachineReportPeriodNum <> saved_MachineReportPeriodNum then
      WriteStrToIniFile(RgMqmSezCfg, RgMachineReportPeriodNum, MachineReportPeriodNum, WkstCode, false);
    if MachineReportDaysMinusDoday <> saved_MachineReportDaysMinusDoday then
      WriteStrToIniFile(RgMqmSezCfg, RgMachineReportDaysMinusDoday, MachineReportDaysMinusDoday, WkstCode, false);
    if MachineReportShowFromToHeader <> saved_MachineReportShowFromToHeader then
      WriteStrToIniFile(RgMqmSezCfg, RgMachineReportShowFromToHeader, MachineReportShowFromToHeader, WkstCode, false);
    if MachineReportFileNameAutoOperation <> saved_MachineReportFileNameAutoOperation then
      WriteStrToIniFile(RgMqmSezCfg, RgMachineReportFileNameAutoOperation, MachineReportFileNameAutoOperation, WkstCode, false);
    if SetLimiDateUsingCapacity <> saved_SetLimiDateUsingCapacity then
      WriteStrToIniFile(RgMqmSezCfg, Rg_SetLimiDateUsingCapacity, SetLimiDateUsingCapacity, WkstCode, false);
    if SetLimiDateUsingSecureNumDays <> saved_SetLimiDateUsingSecureNumDays then
      WriteStrToIniFile(RgMqmSezCfg, Rg_SetLimiDateUsingSecureNumDays, SetLimiDateUsingSecureNumDays, WkstCode, false);
    if DBAppSettings.SuggestedTextTabJobSequence <> Saved_SuggestedTextTabJobSequence then
      WriteStrToIniFile(RgMqmSezCfg, Rg_SuggestedTextTabJobSequence, DBAppSettings.SuggestedTextTabJobSequence, WkstCode, false);
  end

end;

//----------------------------------------------------------------------------//
procedure GlobSaveValues;
var
  qry: TMqmQuery;
//  trs: TMqmTransaction;
  ChkStpSeq, CntrStrtOnMove, WrnOnMoveFnl,
  arraysize, binstate, planstate, TBState : integer;
  tbInfo: ^TTblInfo;
begin
  //if not reCheckServerConnection then
  //  if not ReconnectMsg then Exit;

  SaveColors;
  tbInfo := @tblInfo[tbl_cfg_appGlob];

  qry := CreateQuery(Cfg_DB);
  Qry.Transaction := CreateTransaction(Cfg_DB);
  Qry.Transaction.StartTransaction;

  with LocAppGlobals do
  begin
    WriteStrToRegistry(RgMqmSezCfg, RgCfgImgDir, ImgDir);
    WriteStrToRegistry(RgMqmSezCfg, RgCfgLangDir, LangDir);
  end;

  with IniAppGlobals do
  begin
    // Environment
    WriteStrToIniFile(RgMqmSezCfg, RgCfgLastWkstCode, WkstCode, WkstCode, true);
  end;

  with DBAppGlobals do
  begin
  //  qry.Transaction.Active := true;
    qry.SQL.Clear;
    qry.SQL.Add('delete from ' +  tbInfo.GetTableName + ' where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + '=''' + IniAppGlobals.WkstCode+'''');
    qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
    qry.ExecSQL;
    qry.Transaction.Commit;
    qry.Close;

    if WdwBinState = true then
       binstate := 1
    else
       binstate := 0;

    if ToolBarState = true then
       TBstate := 1
    else
       TBstate := 0;

    if WdwPlanState = true then
       planstate := 1
    else
      planstate:=0;

    if CheckStepSeq = true then
       ChkStpSeq := 1
    else
       ChkStpSeq := 0;

    if CenterStartOnMove = true then
       CntrStrtOnMove := 1
    else
       CntrStrtOnMove := 0;

    if WarnOnMoveFinal = true then
       WrnOnMoveFnl := 1
    else
       WrnOnMoveFnl := 0;

    arraysize := -1;

    with qry do
    begin
      Inc(arraysize);
      params.arraysize := arraysize + 1;
      Transaction.StartTransaction;
  //    Transaction.Active := true;
      SQL.Clear;
      SQL.Add('insert into ' + tbInfo.GetTableName + '(');
      SQL.Add(CreateFld(tbInfo.pfx, fli_Identifier)     + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_wkstCode)       + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_EnvDescr)       + ','); // environement description
      SQL.Add(CreateFld(tbInfo.pfx, fli_Customer)       + ','); // Customer
      SQL.Add(CreateFld(tbInfo.pfx, fli_MqmVersion)     + ','); // Mqm Version
      SQL.Add(CreateFld(tbInfo.pfx, fli_MonthBefore)    + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_StDateForPlan)  + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_Language)       + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_CurrTScale)     + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_CurrDtTime)     + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_ShowCal)        + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_CurrRscSort)    + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_ShowZoom)       + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_RscOrderType)   + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_RscOrderItem)   + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_wdwPlanLeft)    + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_wdwPlanTop)     + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_wdwPlanWidth)   + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_wdwPlanHeight)  + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_wdwPlanState)   + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_wdwBinDock)     + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_wdwBinLeft)     + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_wdwBinTop)      + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_wdwBinWidth)    + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_wdwBinHeight)   + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_wdwBinState)    + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_wdwBinSplitter) + ',');

      SQL.Add(CreateFld(tbInfo.pfx, fli_ToolBarDock )     + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_ToolBarLeft)     + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_ToolBarTop )      + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_ToolBarWidth)    + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_ToolBarHeight)   + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_ToolBarState)    + ',');

      SQL.Add(CreateFld(tbInfo.pfx, fli_UnscheduleClosedJobsOnStart)   + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_CheckStepSeq)   + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_CenterStartOnMove)+ ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_WarnOnMoveFinal) + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_DefSchedType)   + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_ConfLevels)      + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_ShowColorJobMode)+ ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_PropertyCode)    + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_MoveOption)     + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_ActAutoSchedCode)   + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_SlotDisplay)        + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_CustomSlotDisplay)  + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_CustomPropDisplay)  + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_CustomPROPSymbol)  + ')');
      SQL.Add(' values (');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Identifier)     + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wkstCode)       + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_EnvDescr)       + ','); // environement description
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Customer)       + ','); // Customer
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_MqmVersion)     + ','); // Mqm Version
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_MonthBefore)    + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_StDateForPlan)  + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Language)       + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_CurrTScale)     + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_CurrDtTime)     + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_ShowCal)        + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_CurrRscSort)    + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_ShowZoom)       + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_RscOrderType)   + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_RscOrderItem)   + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wdwPlanLeft)    + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wdwPlanTop)     + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wdwPlanWidth)   + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wdwPlanHeight)  + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wdwPlanState)   + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wdwBinDock)     + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wdwBinLeft)     + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wdwBinTop)      + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wdwBinWidth)    + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wdwBinHeight)   + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wdwBinState)    + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wdwBinSplitter) + ',');

      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_ToolBarDock )   + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_ToolBarLeft)    + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_ToolBarTop )    + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_ToolBarWidth)   + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_ToolBarHeight)  + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_ToolBarState)   + ',');

      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_UnscheduleClosedJobsOnStart)   + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_CheckStepSeq)   + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_CenterStartOnMove)+ ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_WarnOnMoveFinal)+ ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_DefSchedType)   + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_ConfLevels)     + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_ShowColorJobMode) + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_PropertyCode)     + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_MoveOption)   + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_ActAutoSchedCode) + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_SlotDisplay) + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_CustomSlotDisplay) + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_CustomPropDisplay) + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_CustomPROPSymbol));
      SQL.Add(')');
//      Prepare;
      Params[0].asIntegers[arraysize]   := StrToInt(IniAppGlobals.Identifier);
      Params[1].AsStrings[arraysize]    := IniAppGlobals.WkstCode;
      Params[2].AsStrings[arraysize]    := EnvDescr;
      Params[3].AsStrings[arraysize]    := Customer;
      Params[4].AsStrings[arraysize]    := MqmVersion;
      Params[5].AsIntegers[arraysize]   := MonthBefore;
      Params[6].AsDateTimes[arraysize]  := StDateForPlan;
      Params[7].AsStrings[arraysize]    := Language;
      Params[8].AsSmallInts[arraysize]  := CurrTScale;
      Params[9].AsDateTimes[arraysize]  := CurrDtTime;
      Params[10].AsSmallInts[arraysize] := ShowCal;
      Params[11].AsSmallInts[arraysize] := CurrRscSort;
      Params[12].AsSmallInts[arraysize] := ShowZoom;
      Params[13].AsStrings[arraysize]   := SelRscOrderType;
      Params[14].AsStrings[arraysize]   := SelRscOrderItem;
      Params[15].AsSmallInts[arraysize] := wdwplanleft;
      Params[16].AsSmallInts[arraysize] := wdwplantop;
      Params[17].AsSmallInts[arraysize] := wdwplanwidth;
      Params[18].AsSmallInts[arraysize] := wdwplanheight;
      Params[19].AsSmallInts[arraysize] := planstate;
      Params[20].AsSmallInts[arraysize] := WdwBinDock;
      Params[21].AsSmallInts[arraysize] := WdwBinLeft;
      Params[22].AsSmallInts[arraysize] := WdwBinTop;
      Params[23].AsSmallInts[arraysize] := WdwBinWidth;
      Params[24].AsSmallInts[arraysize] := WdwBinHeight;
      Params[25].AsSmallInts[arraysize] := binstate;
      Params[26].AsSmallInts[arraysize] := WdwBinSplitterH;
      Params[27].AsSmallInts[arraysize] := ToolBarDock;
      Params[28].AsSmallInts[arraysize] := ToolBarLeft;
      Params[29].AsSmallInts[arraysize] := ToolBarTop;
      Params[30].AsSmallInts[arraysize] := ToolBarWidth;
      Params[31].AsSmallInts[arraysize] := ToolBarHeight;
      Params[32].AsSmallInts[arraysize] := TBState;
      Params[33].AsStrings[arraysize]   := UnscheduleJobsOnStart;
      Params[34].AsSmallInts[arraysize] := ChkStpSeq;
      Params[35].AsSmallInts[arraysize] := CntrStrtOnMove;
      Params[36].AsSmallInts[arraysize] := WrnOnMoveFnl;
      Params[37].AsSmallInts[arraysize] := DefSchedType;
      Params[38].AsSmallInts[arraysize] := ConfLevels;
      Params[39].AsStrings[arraysize] := '';
      if (ShowColorJobMode = Standard) then
        Params[39].AsStrings[arraysize] := '0'
      else if (ShowColorJobMode = PreDefinedPropList) then
        Params[39].AsStrings[arraysize] := '1'
      else if (ShowColorJobMode = DinamicPropList) then
        Params[39].AsStrings[arraysize] := '2';
      Params[40].AsStrings[arraysize] := '';
      if (ShowColorJobMode <> Standard) then
          Params[40].AsStrings[arraysize] := LastPropColorInUseJobMode;
      Params[41].AsSmallInts[arraysize] := MoveOption;
      Params[42].AsStrings[arraysize]   := ActAutoSched;
      Params[43].AsSmallInts[arraysize]   := MCMSlotDisplay;
      Params[44].AsBooleans[arraysize]   := MCMCustomQty;
      Params[45].AsStrings[arraysize]   := MCMCustomProp;
      Params[46].AsStrings[arraysize]   := MCMCustomPropSymbol;
    end;

    if arraysize >= 0 then
    begin
      qry.execute(arraysize + 1);
      Qry.Transaction.Commit;
    end;

    qry.connection.Commit;
    qry.Close;
    qry.free;

  end
end;

//----------------------------------------------------------------------------//
{
procedure GlobSaveValues_old;
var
  qry: TMqmQuery;
//  trs: TMqmTransaction;
  ChkStpSeq, CntrStrtOnMove, WrnOnMoveFnl,
  binstate, planstate, TBState : integer;
  tbInfo: ^TTblInfo;
begin
  if IniAppGlobals.DownloadTo <> '2' then
    SaveColors
  else
    SaveColorsOld;

  tbInfo := @tblInfo[tbl_cfg_appGlob];

  qry := CreateQuery(Cfg_DB);
//  Qry.Transaction := CreateTransaction(Cfg_DB);
//  Qry.Transaction.StartTransaction;

  with LocAppGlobals do
  begin
    WriteStrToRegistry(RgMqmSezCfg, RgCfgImgDir, ImgDir);
    WriteStrToRegistry(RgMqmSezCfg, RgCfgLangDir, LangDir);
  end;

  with IniAppGlobals do
  begin
    // Environment
    WriteStrToIniFile(RgMqmSezCfg, RgCfgLastWkstCode, WkstCode, WkstCode, true);
  end;

  with DBAppGlobals do
  begin
  //  qry.Transaction.Active := true;
    qry.SQL.Clear;
    qry.SQL.Add('delete from ' +  tbInfo.GetTableName + ' where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + '=''' + IniAppGlobals.WkstCode+'''');
    qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
    qry.ExecSQL;
 //   qry.Transaction.Commit;
    qry.Close;

    if WdwBinState = true then
       binstate := 1
    else
       binstate := 0;

    if ToolBarState = true then
       TBstate := 1
    else
       TBstate := 0;

    if WdwPlanState = true then
       planstate := 1
    else
      planstate:=0;

    if CheckStepSeq = true then
       ChkStpSeq := 1
    else
       ChkStpSeq := 0;

    if CenterStartOnMove = true then
       CntrStrtOnMove := 1
    else
       CntrStrtOnMove := 0;

    if WarnOnMoveFinal = true then
       WrnOnMoveFnl := 1
    else
       WrnOnMoveFnl := 0;


    with qry do
    begin
  //    Transaction.Active := true;
      SQL.Clear;
      SQL.Add('insert into ' + tbInfo.GetTableName + '(');
      SQL.Add(CreateFld(tbInfo.pfx, fli_Identifier)     + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_wkstCode)       + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_EnvDescr)       + ','); // environement description
      SQL.Add(CreateFld(tbInfo.pfx, fli_Customer)       + ','); // Customer
      SQL.Add(CreateFld(tbInfo.pfx, fli_MqmVersion)     + ','); // Mqm Version
      SQL.Add(CreateFld(tbInfo.pfx, fli_MonthBefore)    + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_StDateForPlan)  + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_Language)       + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_CurrTScale)     + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_CurrDtTime)     + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_ShowCal)        + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_CurrRscSort)    + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_ShowZoom)       + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_RscOrderType)   + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_RscOrderItem)   + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_wdwPlanLeft)    + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_wdwPlanTop)     + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_wdwPlanWidth)   + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_wdwPlanHeight)  + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_wdwPlanState)   + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_wdwBinDock)     + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_wdwBinLeft)     + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_wdwBinTop)      + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_wdwBinWidth)    + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_wdwBinHeight)   + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_wdwBinState)    + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_wdwBinSplitter) + ',');

      SQL.Add(CreateFld(tbInfo.pfx, fli_ToolBarDock )     + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_ToolBarLeft)     + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_ToolBarTop )      + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_ToolBarWidth)    + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_ToolBarHeight)   + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_ToolBarState)    + ',');

      SQL.Add(CreateFld(tbInfo.pfx, fli_UnscheduleClosedJobsOnStart)   + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_CheckStepSeq)   + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_CenterStartOnMove)+ ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_WarnOnMoveFinal) + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_DefSchedType)   + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_ConfLevels)      + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_ShowColorJobMode)+ ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_PropertyCode)    + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_MoveOption)     + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_ActAutoSchedCode)   + ')');
      SQL.Add(' values (');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Identifier)     + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wkstCode)       + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_EnvDescr)       + ','); // environement description
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Customer)       + ','); // Customer
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_MqmVersion)     + ','); // Mqm Version
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_MonthBefore)    + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_StDateForPlan)  + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Language)       + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_CurrTScale)     + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_CurrDtTime)     + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_ShowCal)        + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_CurrRscSort)    + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_ShowZoom)       + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_RscOrderType)   + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_RscOrderItem)   + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wdwPlanLeft)    + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wdwPlanTop)     + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wdwPlanWidth)   + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wdwPlanHeight)  + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wdwPlanState)   + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wdwBinDock)     + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wdwBinLeft)     + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wdwBinTop)      + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wdwBinWidth)    + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wdwBinHeight)   + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wdwBinState)    + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wdwBinSplitter) + ',');

      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_ToolBarDock )   + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_ToolBarLeft)    + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_ToolBarTop )    + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_ToolBarWidth)   + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_ToolBarHeight)  + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_ToolBarState)   + ',');

      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_UnscheduleClosedJobsOnStart)   + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_CheckStepSeq)   + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_CenterStartOnMove)+ ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_WarnOnMoveFinal)+ ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_DefSchedType)   + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_ConfLevels)     + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_ShowColorJobMode) + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_PropertyCode)     + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_MoveOption)   + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_ActAutoSchedCode));
      SQL.Add(')');
//      Prepare;

      ParamByName(CreateFld(tbInfo.pfx, fli_Identifier)).AsString := IniAppGlobals.Identifier;
      ParamByName(CreateFld(tbInfo.pfx, fli_wkstCode)).AsString := IniAppGlobals.WkstCode;
      ParamByName(CreateFld(tbInfo.pfx, fli_EnvDescr)).AsString        := EnvDescr;
      ParamByName(CreateFld(tbInfo.pfx, fli_Customer)).AsString        := Customer;
      ParamByName(CreateFld(tbInfo.pfx, fli_MqmVersion)).AsString      := MqmVersion;
      ParamByName(CreateFld(tbInfo.pfx, fli_MonthBefore)).AsInteger    := MonthBefore;
      ParamByName(CreateFld(tbInfo.pfx, fli_StDateForPlan)).AsDateTime := StDateForPlan;

      ParamByName(CreateFld(tbInfo.pfx, fli_Language)).AsString        := Language;
      ParamByName(CreateFld(tbInfo.pfx, fli_CurrTScale)).AsSmallInt    := CurrTScale;
      ParamByName(CreateFld(tbInfo.pfx, fli_CurrDtTime)).AsDateTime    := CurrDtTime;
      ParamByName(CreateFld(tbInfo.pfx, fli_ShowCal)).AsSmallInt       := ShowCal;
      ParamByName(CreateFld(tbInfo.pfx, fli_CurrRscSort)).AsSmallInt   := CurrRscSort;
      ParamByName(CreateFld(tbInfo.pfx, fli_ShowZoom)).AsSmallInt      := ShowZoom;
      ParamByName(CreateFld(tbInfo.pfx, fli_RscOrderType)).AsString    := SelRscOrderType;
      ParamByName(CreateFld(tbInfo.pfx, fli_RscOrderItem)).AsString    := SelRscOrderItem;

      ParamByName(CreateFld(tbInfo.pfx, fli_wdwPlanLeft)).AsSmallInt   := wdwplanleft;
      ParamByName(CreateFld(tbInfo.pfx, fli_wdwPlanTop)).AsSmallInt    := wdwplantop;
      ParamByName(CreateFld(tbInfo.pfx, fli_wdwPlanWidth)).AsSmallInt  := wdwplanwidth;
      ParamByName(CreateFld(tbInfo.pfx, fli_wdwPlanHeight)).AsSmallInt := wdwplanheight;
      ParamByName(CreateFld(tbInfo.pfx, fli_wdwPlanState)).AsSmallInt  := planstate;
      ParamByName(CreateFld(tbInfo.pfx, fli_wdwBinDock)).AsSmallInt    := WdwBinDock;
      ParamByName(CreateFld(tbInfo.pfx, fli_wdwBinLeft)).AsSmallInt    := WdwBinLeft;
      ParamByName(CreateFld(tbInfo.pfx, fli_wdwBinTop)).AsSmallInt     := WdwBinTop;
      ParamByName(CreateFld(tbInfo.pfx, fli_wdwBinWidth)).AsSmallInt   := WdwBinWidth;
      ParamByName(CreateFld(tbInfo.pfx, fli_wdwBinHeight)).AsSmallInt  := WdwBinHeight;
      ParamByName(CreateFld(tbInfo.pfx, fli_wdwBinState)).AsSmallInt   := binstate;
      ParamByName(CreateFld(tbInfo.pfx, fli_wdwBinSplitter)).AsSmallInt := WdwBinSplitterH;

      ParamByName(CreateFld(tbInfo.pfx, fli_ToolBarDock)).AsSmallInt    := ToolBarDock;
      ParamByName(CreateFld(tbInfo.pfx, fli_ToolBarLeft)).AsSmallInt    := ToolBarLeft;
      ParamByName(CreateFld(tbInfo.pfx, fli_ToolBarTop )).AsSmallInt    := ToolBarTop;
      ParamByName(CreateFld(tbInfo.pfx, fli_ToolBarWidth)).AsSmallInt   := ToolBarWidth;
      ParamByName(CreateFld(tbInfo.pfx, fli_ToolBarHeight)).AsSmallInt  := ToolBarHeight;
      ParamByName(CreateFld(tbInfo.pfx, fli_ToolBarState)).AsSmallInt   := TBState;

      ParamByName(CreateFld(tbInfo.pfx, fli_UnscheduleClosedJobsOnStart)).AsString   := UnscheduleJobsOnStart;
      ParamByName(CreateFld(tbInfo.pfx, fli_CheckStepSeq)).AsSmallInt   := ChkStpSeq;
      ParamByName(CreateFld(tbInfo.pfx, fli_CenterStartOnMove)).AsSmallInt:= CntrStrtOnMove;
      ParamByName(CreateFld(tbInfo.pfx, fli_WarnOnMoveFinal)).AsSmallInt:= WrnOnMoveFnl;
      ParamByName(CreateFld(tbInfo.pfx, fli_DefSchedType)).AsSmallInt   := DefSchedType;
      ParamByName(CreateFld(tbInfo.pfx, fli_ConfLevels)).AsSmallInt     := ConfLevels;

      if (ShowColorJobMode = Standard) then
        ParamByName(CreateFld(tbInfo.pfx, fli_ShowColorJobMode)).AsString := '0'
      else if (ShowColorJobMode = PreDefinedPropList) then
        ParamByName(CreateFld(tbInfo.pfx, fli_ShowColorJobMode)).AsString := '1'
      else if (ShowColorJobMode = DinamicPropList) then
        ParamByName(CreateFld(tbInfo.pfx, fli_ShowColorJobMode)).AsString := '2';

      ParamByName(CreateFld(tbInfo.pfx, fli_PropertyCode)).AsString := '';
      if (ShowColorJobMode <> Standard) then
          ParamByName(CreateFld(tbInfo.pfx, fli_PropertyCode)).AsString := LastPropColorInUseJobMode;

      ParamByName(CreateFld(tbInfo.pfx, fli_MoveOption)).AsSmallInt     := MoveOption;
      ParamByName(CreateFld(tbInfo.pfx, fli_ActAutoSchedCode)).AsString := ActAutoSched;

      ParamByName(CreateFld(tbInfo.pfx, fli_wdwPlanLeft)).AsSmallInt   := wdwplanleft;
      ParamByName(CreateFld(tbInfo.pfx, fli_wdwPlanTop)).AsSmallInt    := wdwplantop;
      ParamByName(CreateFld(tbInfo.pfx, fli_wdwPlanWidth)).AsSmallInt  := wdwplanwidth;
      ParamByName(CreateFld(tbInfo.pfx, fli_wdwPlanHeight)).AsSmallInt := wdwplanheight;
      ParamByName(CreateFld(tbInfo.pfx, fli_wdwPlanState)).AsSmallInt  := planstate;

      ExecSQL
    end;

    qry.connection.Commit;
    qry.Close;
    qry.free;

  end
end;

//----------------------------------------------------------------------------//
}

procedure GlobInitPosForm(value : integer);
begin
  // Set the default value for position form
  // value:  -1=All Forms    0=Only Plan    1=Only Bin    2=Only Move
  if value <= 0 then
  begin
    // Form Plan
    with DBAppGlobals do begin
      WdwPlanLeft := 0;
      WdwPlanTop := 0;
      WdwPlanWidth := Screen.Width - 200;
      WdwPlanHeight := screen.Height - 100;
      WdwPlanState := false;
    end;
  end;
  if (value = -1) or (value = 1) then
  begin
    // Form Bin
    with DBAppGlobals do begin
      WdwBinDock := -1; // 0=Undocked  1=Right Dock    -1=Bottom Dock
      WdwBinLeft := 0;
      WdwBinTop := 0;
      WdwBinWidth := 500;
      WdwBinHeight := 70;
      WdwBinState := false;
      WdwBinSplitterH := 150;
    end;
  end;
  if (value = -1) or (value = 2) then
  begin
    // Form Move
    with DBAppGlobals do begin
      WdwMoveLeft := 0;
      WdwMoveTop := 0;
      WdwMoveDetails := false
    end
  end
end;

//----------------------------------------------------------------------------//

procedure CheckChangedProperties;
var
  qry:       TMqmQuery;
  tbBinProp :  ^TTblInfo;
  i,j : integer;
begin
  tbBinProp := @tblInfo[tbl_cfg_bin_showProp];
  qry := CreateQuery(Cfg_DB);

  for I := Low(DBAppGlobals.ShowBinPropArry) to High(DBAppGlobals.ShowBinPropArry) do
     DBAppGlobals.ShowBinPropArry[I] := nil;


  // load the Properties to show in Bin

  with qry do
  begin
  //WARNING THE QUERY FIELDS ARE ACCESSED BY INDEX!
    SQL.Add('select');
    for i := 1 to 60 do
    begin
      if i < 60 then
        SQL.Add(CreateFld(tbBinProp.pfx, fli_FiltPropCode) + IntToStr(i) + ',')
      else
        SQL.Add(CreateFld(tbBinProp.pfx, fli_FiltPropCode) + IntToStr(i));
    end;
    SQL.Add(' from ' + tbBinProp.GetTableName);
    SQL.Add(' where ' + CreateFld(tbBinProp.pfx, fli_wkstCode) + '=');
    SQL.Add('''' + IniAppGlobals.WkstCode + '''');
    SQL.Add(AND_IDF_Condition(CreateFld(tbBinProp.pfx, fli_Identifier)));
    Open;
    First;

    J := 0;
    for i := 1 to 60 do
    begin
      if ((FieldByName(CreateFld(tbBinProp.pfx, fli_FiltPropCode) + IntToStr(i)).AsString) <> '') and
         (GetIdFromCode(FieldByName(CreateFld(tbBinProp.pfx, fli_FiltPropCode) + IntToStr(i)).AsString) <> nil) then
      begin
        DBAppGlobals.ShowBinPropArry[j] := GetIdFromCode(FieldByName(CreateFld(tbBinProp.pfx, fli_FiltPropCode) + IntToStr(i)).AsString);
        j := j + 1;
      end
      else
        DBAppGlobals.ShowBinPropArry[j] := nil;
    end;
    Close;
  end;

  qry.Free;
end;

//----------------------------------------------------------------------------//

function GetDateForPlanLine(): TDateTime;
var
  qry:      TMqmQuery;
  tbDate: ^TTblInfo;
begin
  Result := now;
  tbDate := @tblInfo[tbl_download_time];
  qry := CreateQuery(Main_DB);

  with qry do
  begin
    SQL.Clear;
    SQL.Add('select ' + CreateFld(tbDate.pfx, fli_downloadTime) + ' from ' + tbDate.GetTableName );
    SQL.Add(WHERE_IDF_Condition(CreateFld(tbDate.pfx, fli_Identifier)));
    open;
    if not qry.EOF then
      Result := fieldByName(CreateFld(tbDate.pfx, fli_downloadTime)).AsDateTime;
    if Result = 0 then Result := now;
    Close
  end;
  qry.Free;
end;

//----------------------------------------------------------------------------//

procedure DeleteRequest(Request : string; Step : integer; SubStep : Integer; Reprocess : Integer);
var
  qry:      TMqmQuery;
  tbProdSched: ^TTblInfo;
begin
  tbProdSched := @tblInfo[tbl_prod_sched];
  qry := CreateQuery(Main_DB);

  with qry do
  begin
    SQL.Clear;
    SQL.Add('Delete from ' + tbProdSched.GetTableName);
    SQL.Add(' where ');

    SQL.Add(CreateFld(tbProdSched.pfx, fli_IDENTIFIER)         + ' = ');
    SQL.Add(':' + CreateFld(tbProdSched.pfx, fli_IDENTIFIER)   + ' and ');
    SQL.Add(CreateFld(tbProdSched.pfx, fli_preqNo)         + ' = ');
    SQL.Add(':' + CreateFld(tbProdSched.pfx, fli_preqNo)   + ' and ');
    SQL.Add(CreateFld(tbProdSched.pfx, fli_pstepId)        + ' = ');
    SQL.Add(':' + CreateFld(tbProdSched.pfx, fli_pstepId)  + ' and ');
    SQL.Add(CreateFld(tbProdSched.pfx, fli_psubstId)       + ' = ');
    SQL.Add(':' + CreateFld(tbProdSched.pfx, fli_psubstId) + ' and ');
    SQL.Add(CreateFld(tbProdSched.pfx, fli_reprocNo)       + ' = ');
    SQL.Add(':' + CreateFld(tbProdSched.pfx, fli_reprocNo));

    qry.ParamByName(CreateFld(tbProdSched.pfx, fli_identifier)).AsString  := IniAppGlobals.Identifier;
    qry.ParamByName(CreateFld(tbProdSched.pfx, fli_preqNo)).AsString  := Request;
    qry.ParamByName(CreateFld(tbProdSched.pfx, fli_pstepId)).AsInteger  := Step;
    qry.ParamByName(CreateFld(tbProdSched.pfx, fli_psubstId)).AsInteger  := SubStep;
    qry.ParamByName(CreateFld(tbProdSched.pfx, fli_reprocNo)).AsInteger  := Reprocess;
    ExecSQL;
    Close
  end;
  qry.Free;
end;

//----------------------------------------------------------------------------//

procedure AddToListLogLines(LogList : TList; LogOrig : string; Request : string; step : integer; Substep : Integer;
                            ReProcess : integer; OperationOnTable : string; ScheduleInfo : string; Resource : string;
                            StartScheduleDate : TDateTime; EndScheduleDate : TDateTime; qty : double; SchedType : string; Reason : string);
var
  LogInfo : PTLogInfo;
begin
  new(LogInfo);
  LogInfo.DateTimeCreate := now;
  LogInfo.LogOrig := LogOrig;
  LogInfo.Request := Request;
  LogInfo.step    := step;
  LogInfo.Substep := Substep;
  LogInfo.ReProcess := ReProcess;
  LogInfo.OperationOnTable := OperationOnTable;
  LogInfo.ScheduleInfo := ScheduleInfo;
  LogInfo.Resource     := Resource;
  LogInfo.qty          := qty;
  LogInfo.StartScheduleDate := StartScheduleDate;
  LogInfo.EndScheduleDate := EndScheduleDate;
  LogInfo.SchedType := SchedType;
  LogInfo.Reason := Reason;
  LogList.Add(LogInfo)
end;

//----------------------------------------------------------------------------//

procedure WriteLogLineToDBFromParamList(LogList : TList; qry: TMqmQuery);
var
  tbInfo: ^TTblInfo;
  StrSrvSql : string;
  arraysize, I : integer;
  LogInfo : PTLogInfo;
begin
  tbInfo := @tblInfo[tbl_Log];
  StrSrvSql := 'insert into ' + tbInfo.GetTableName + '(';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_Identifier)              + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_DateTime)                + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_LogOrigin)               + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_preqNo)                  + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_pstepId)                 + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_psubstId)                + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_reprocNo)                + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_Operation)               + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_ScheduleInfo)            + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_rsc)                     + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_quant)                   + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_schedStart)              + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_schedEnd)                + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_schedType)               + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_Reason)                  + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_Mqm_environment);
  StrSrvSql := StrSrvSql + ') values (';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_Identifier)        + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_DateTime)          + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_LogOrigin)         + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_preqNo)            + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_pstepId)           + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_psubstId)          + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_reprocNo)          + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_Operation)         + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_ScheduleInfo)      + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_rsc)               + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_quant)             + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_schedStart)        + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_schedEnd)          + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_schedType)         + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_Reason)            + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_Mqm_environment);
  StrSrvSql := StrSrvSql + ')';
  qry.sql.text := StrSrvSql;

  Application.ProcessMessages;

  arraysize := -1;

  for I := 0 to LogList.Count - 1 do
  begin

    if arraysize = 1000 then
    begin
      qry.execute(arraysize + 1);
      qry.SQL.Clear;
      qry.sql.text := StrSrvSql;
      arraysize := -1;
      Application.ProcessMessages;
    end;

    LogInfo := PTLogInfo(LogList[I]);
    Inc(arraysize);
    qry.params.arraysize := arraysize + 1;

    qry.params[0].AsIntegers[arraysize] := StrToInt(IniAppGlobals.Identifier);
    qry.params[1].AsDateTimes[arraysize] := LogInfo.DateTimeCreate;
    qry.params[2].AsStrings[arraysize]   := LogInfo.LogOrig;
    qry.params[3].AsStrings[arraysize]   := LogInfo.Request;
    qry.params[4].AsIntegers[arraysize]  := LogInfo.step;
    qry.params[5].AsIntegers[arraysize]  := LogInfo.Substep;
    qry.params[6].AsIntegers[arraysize]  := LogInfo.ReProcess;
    qry.params[7].AsStrings[arraysize]   := LogInfo.OperationOnTable;
    qry.params[8].AsStrings[arraysize]   := LogInfo.ScheduleInfo;
    qry.params[9].AsStrings[arraysize]   := LogInfo.Resource;
    qry.params[10].AsFloats[arraysize]    := LogInfo.qty;
    qry.params[11].AsDateTimes[arraysize] := LogInfo.StartScheduleDate;
    qry.params[12].AsDateTimes[arraysize] := LogInfo.EndScheduleDate;
    qry.params[13].AsStrings[arraysize] := LogInfo.SchedType;
    qry.params[14].AsStrings[arraysize] := LogInfo.Reason;
    if DBAppGlobals.MCM_App then
      qry.params[15].AsStrings[arraysize] := '0'
    else
      qry.params[15].AsStrings[arraysize] := '1'
  end;

//  if arraysize >= 0 then
//    qry.execute(arraysize + 1);

  try
    if arraysize >= 0 then
      qry.execute(arraysize + 1);
  except
    on E: EFDDBEngineException do
    begin
    end;
  end;

end;

//----------------------------------------------------------------------------//

procedure WriteLogLineToDB(qry: TMqmQuery; LogOrig : string; Request : string; step : integer; Substep : integer;
                            ReProcess : integer; OperationOnTable : string; ScheduleInfo : string; Resource : string;
                            StartScheduleDate : TDateTime; EndScheduleDate : TDateTime; qty : double; SchedType : string; Reason : string);
var
  tbInfo: ^TTblInfo;
  StrSrvSql : string;
begin
  tbInfo := @tblInfo[tbl_Log];

  StrSrvSql := 'insert into ' + tbInfo.GetTableName + '(';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_IDENTIFIER)              + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_DateTime)                + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_LogOrigin)               + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_preqNo)                  + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_pstepId)                 + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_psubstId)                + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_reprocNo)                + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_Operation)               + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_ScheduleInfo)            + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_rsc)                     + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_quant)                   + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_schedStart)              + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_schedEnd)                + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_schedType)               + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_Reason)                  + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_Mqm_environment);
  StrSrvSql := StrSrvSql + ') values (';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_IDENTIFIER)        + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_DateTime)          + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_LogOrigin)         + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_preqNo)            + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_pstepId)           + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_psubstId)          + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_reprocNo)          + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_Operation)         + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_ScheduleInfo)      + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_rsc)               + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_quant)             + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_schedStart)        + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_schedEnd)          + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_schedType)         + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_Reason)            + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_Mqm_environment);
  StrSrvSql := StrSrvSql + ')';
  qry.sql.text := StrSrvSql;

  Application.ProcessMessages;

  qry.ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsString        := IniAppGlobals.Identifier;
  qry.ParamByName(CreateFld(tbInfo.pfx, fli_DateTime)).AsDateTime        := now;
  qry.ParamByName(CreateFld(tbInfo.pfx, fli_LogOrigin)).AsString         := LogOrig;
  qry.ParamByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString            := Request;
  qry.ParamByName(CreateFld(tbInfo.pfx, fli_pstepId)).AsInteger          := step;
  qry.ParamByName(CreateFld(tbInfo.pfx, fli_psubstId)).AsInteger         := Substep;
  qry.ParamByName(CreateFld(tbInfo.pfx, fli_reprocNo)).AsInteger         := ReProcess;
  qry.ParamByName(CreateFld(tbInfo.pfx, fli_Operation)).AsString         := OperationOnTable;
  qry.ParamByName(CreateFld(tbInfo.pfx, fli_ScheduleInfo)).AsString      := ScheduleInfo;
  qry.ParamByName(CreateFld(tbInfo.pfx, fli_rsc)).AsString               := Resource;
  qry.ParamByName(CreateFld(tbInfo.pfx, fli_quant)).AsFloat              := qty;
  qry.ParamByName(CreateFld(tbInfo.pfx, fli_schedStart)).AsDateTime      := StartScheduleDate;
  qry.ParamByName(CreateFld(tbInfo.pfx, fli_schedEnd)).AsDateTime        := EndScheduleDate;
  qry.ParamByName(CreateFld(tbInfo.pfx, fli_schedType)).AsString         := SchedType;
  qry.ParamByName(CreateFld(tbInfo.pfx, fli_Reason)).AsString            := Reason;

  if DBAppGlobals.MCM_App then
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_Mqm_environment)).AsString := '0'
  else
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_Mqm_environment)).AsString := '1';

  try
    qry.ExecSQL;
  except
    qry.sql.clear;
//    trs.free;
//    Exit
  end;
//  trs.commit;
//  qry.free;
//  trs.free;
end;

//----------------------------------------------------------------------------//

procedure WriteLogLineToDBFromServer(LogOrig : string; Request : string; step : integer; Substep : Integer;
                            ReProcess : integer; OperationOnTable : string; ScheduleInfo : string; Resource : string;
                            StartScheduleDate : TDateTime; EndScheduleDate : TDateTime; qty : double; SchedType : string; Reason : string);
var
  tbInfo: ^TTblInfo;
  StrSrvSql : string;
  qry: TMqmQuery;
begin
  tbInfo := @tblInfo[tbl_Log];
  qry := CreateQuery(Main_DB);
  Qry.Transaction := CreateTransaction(Main_DB);
  Qry.Transaction.StartTransaction;

  StrSrvSql := 'insert into ' + tbInfo.GetTableName + '(';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_IDENTIFIER)              + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_DateTime)                + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_LogOrigin)               + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_preqNo)                  + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_pstepId)                 + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_psubstId)                + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_reprocNo)                + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_Operation)               + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_ScheduleInfo)            + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_rsc)                     + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_quant)                   + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_schedStart)              + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_schedEnd)                + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_schedType)               + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_Reason)                  + ',';
  StrSrvSql := StrSrvSql + CreateFld(tbInfo.pfx, fli_Mqm_environment);

  StrSrvSql := StrSrvSql + ') values (';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_IDENTIFIER)        + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_DateTime)          + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_LogOrigin)         + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_preqNo)            + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_pstepId)           + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_psubstId)          + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_reprocNo)          + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_Operation)         + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_ScheduleInfo)      + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_rsc)               + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_quant)             + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_schedStart)        + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_schedEnd)          + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_schedType)         + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_Reason)            + ',';
  StrSrvSql := StrSrvSql + ':' + CreateFld(tbInfo.pfx, fli_Mqm_environment);
  StrSrvSql := StrSrvSql + ')';
  qry.sql.text := StrSrvSql;

  Application.ProcessMessages;

  qry.ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsString        := IniAppGlobals.Identifier;
  qry.ParamByName(CreateFld(tbInfo.pfx, fli_DateTime)).AsDateTime        := now;
  qry.ParamByName(CreateFld(tbInfo.pfx, fli_LogOrigin)).AsString         := LogOrig;
  qry.ParamByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString            := Request;
  qry.ParamByName(CreateFld(tbInfo.pfx, fli_pstepId)).AsInteger          := step;
  qry.ParamByName(CreateFld(tbInfo.pfx, fli_psubstId)).AsInteger         := Substep;
  qry.ParamByName(CreateFld(tbInfo.pfx, fli_reprocNo)).AsInteger         := ReProcess;
  qry.ParamByName(CreateFld(tbInfo.pfx, fli_Operation)).AsString         := OperationOnTable;
  qry.ParamByName(CreateFld(tbInfo.pfx, fli_ScheduleInfo)).AsString      := ScheduleInfo;
  qry.ParamByName(CreateFld(tbInfo.pfx, fli_rsc)).AsString               := Resource;
  qry.ParamByName(CreateFld(tbInfo.pfx, fli_quant)).AsFloat              := qty;
  qry.ParamByName(CreateFld(tbInfo.pfx, fli_schedStart)).AsDateTime      := StartScheduleDate;
  qry.ParamByName(CreateFld(tbInfo.pfx, fli_schedEnd)).AsDateTime        := EndScheduleDate;
  qry.ParamByName(CreateFld(tbInfo.pfx, fli_schedType)).AsString         := SchedType;
  qry.ParamByName(CreateFld(tbInfo.pfx, fli_Reason)).AsString            := Reason;
  qry.ParamByName(CreateFld(tbInfo.pfx, fli_Mqm_environment)).AsString   := ' ';

  try
  qry.ExecSQL;
  except
    on E: Exception do
    begin
      ApplicationShowException(E);
    end;
  end;

  Qry.Transaction.Commit;
  qry.Close;
  qry.Free;

end;

//----------------------------------------------------------------------------//

Procedure DefaultValuesForMenu;
var qry : TmqmQuery;
    tbInfo : PTblInfo;
    arraysize, i : Integer;
begin
  Qry := CreateQuery(Cfg_DB);
  tbInfo := @tblInfo[tbl_CustomMenu];

  arraysize := -1;

  qry.SQL.text := 'Insert into ' + tbInfo.GetTableName + ' (CM_IDENTIFIER, CM_WKST_CODE, CM_MENUCODE, CM_MENUCAPTION, CM_VISIBLE)';
  qry.sql.add(' Values(:CM_IDENTIFIER, :CM_WKST_CODE, :CM_MENUCODE, :CM_MENUCAPTION, :CM_VISIBLE)');

  for i := Low(Popupmenu) to High(Popupmenu) do
  begin
    Inc(arraysize);
    qry.params.arraysize := arraysize + 1;

    qry.params[0].AsIntegers[arraysize] := StrToInt(IniAppGlobals.Identifier);
    qry.params[1].asStrings[arraysize] := IniAppGlobals.WkstCode;
    qry.params[2].asStrings[arraysize] := TPopUpCustomMenu(Popupmenu[i]).Code;
    qry.params[3].asStrings[arraysize] := TPopUpCustomMenu(Popupmenu[i]).Caption;

    if TPopUpCustomMenu(Popupmenu[i]).Visible = false then
      qry.params[4].AsIntegers[arraysize] := 0
    else
      qry.params[4].AsIntegers[arraysize] := 1;
  end;

  if arraysize >= 0 then
    qry.execute(arraysize + 1);

  qry.Close;
  qry.Free;
end;

//----------------------------------------------------------------------------//

initialization

  s_suicide := false;

  s_propMtx[1] := nil;
  s_rulesRtoOMtx[1] := nil;
  s_rulesRtoOMtx[2] := nil;
  s_rulesOtoOMtx[1] := nil;
  s_rulesOtoOMtx[2] := nil;

  with DBAppSettings do
  begin
    DisableCapRes := false;
    TabResSort    := true;
    TabKeepSort   := true;
    TabFilterRead := false;
    TabWorkcenter := false;
    TabNoTimings  := false;
    TabNoCompat   := false;
    FixColCompVis := true;
    FixColStatVis := true;
    FixColDelDVis := false;
    FixColMatDVis := false;
    FixColLowDVis := false;
    FixColHigDVis := false;
    FixColOvlpVis := true;
    FixColDatesVis  := true;
    FixColJobMsgVis := false;
    ShowInBinOnMove := true;
    BinMultiLineTab := false;
//    ShowContinueGroupLinesInBin := '0'; // not in use anymore..

    ForceOverlap := FOL_No;
    ShowBatchGroupLinesInBin := false; // not in use anymore..
    JobMoveWitoutConfirmation := false;
    ReportTimeFormat := '0';
    CalDayFormat     := '0';
    ShowBinPropColors := false;
    GanttMultiLineTab := false;
    ShowBinToolBar  := true;
    ChkDelDate    := true;
    ChkMaterials  := true;
    ChkPrevStpQty := true;
    ChkAddRes     := true;
    ChkLowStart   := true;
    ChkHighEnd    := true;
    ChkLinkOvlp   := true;
    GenericPlanExist := false;
    CreateNewBinTabForCompatibles := NewB_No;
    ShowCompatibleInExistingBINS  := ShowC_Yes_MarkTheCompatibles;
    ShowScheduledJobsOfSelectedResource := ShowS_No;
    SuggestedTextTabJobSequence   := _('Schedule Sequence');
  end;

  with LocAppGlobals do
  begin
    AppDir   := ExtractFilePath(Application.ExeName);
    AppDrive := AppDir[1];
    ImgDir := 'Images';
    LangDir := 'Languages';

    // Others
    IsDevelop   := false
  end;

  with IniAppGlobals do
  begin
    MainFormCreated := false;
    Identifier := '0';
    AliasOdbc := '';
    downloadTo:= '0';
    downloadFrom:= '0';

    IBUserName:= 'SYSDBA';
    IBPassword:= 'masterkey';
    IBDataSource:= '';

{    DB2InstanceName:= '';
    DB2UserName:= '';
    DB2Password:= '';
    DB2DataSource:= '';
    DB2SrvIP:= ''; }

    NOWDB2InstanceName:= '';
    NOWDB2UserName:= '';
    NOWDB2Password:= '';
    NOWDB2DataSource:= '';
    NOWDB2SrvIP:= '';
    NOWDB2PORT:= '';

    NOWDB2InstanceNameLocal:= '';
    NOWDB2UserNameLocal:= '';
    NOWDB2PasswordLocal:= '';
    NOWDB2DataSourceLocal:= '';
    NOWDB2SrvIPLocal:= '';
    NOWDB2PORTLocal:= '';

    NOWOracleIp:= '';
    NOWOracleTNSName:= '';
    NOWOracleUserName:= '';
    NOWOraclePassword:= '';

    NOWOracleIpLocal:= '';
    NOWOracleTNSNameLocal:= '';
    NOWOracleUserNameLocal:= '';
    NOWOraclePasswordLocal:= '';

    MainDbPath := LocAppGlobals.AppDir;
    MainDbName := 'MQM_Main.gdb';
//    Alias      := '';
    PCAlias    := 'MQM_DBPC';
    CfgDbPath  :=  LocAppGlobals.AppDir;
    CfgDbName  := 'MQM_Cfg.gdb';
    // Temp DB
    ArcDbPath  :=  LocAppGlobals.AppDir;
    ArcDbName  := 'NOW_MQM_MAIN.gdb';

    WkstCodeSelected := false;
    WkstCode   := 'UNKNOWN';
    TimePickerEndLoop := '20:00:00';
    CBCopiedSchedTypeFromMqm := '0';
    CBForceMqmScheduleDetails := '0';
    CBCopiedBackwardFromMqmDays := '0';
//    ClientConnectionCheck := '0';
    CheckTimer := '2';
    StartCheck := '7';
    EndCheck   := '19';

//    JobBarTextSet := 'Job default';
//    JobBarTextSet := 'Status default';
    PreparationExeName := '';
    DaysKeepHistory    := '25';
    DaysKeepLogHistory := '10';
    SrvNameUserDefine  := '';
    ShowColumnCaptionsReport    := '1';
    ShowTotalReport       := '1';
    SelectedAtibute       := '';
    OperateTimeLoopDnldUpload := '0';
    OperateWaitingTimeUploadDnld := '0';
    BalanceViewToUseInAvailability := '';
    VIEWTLSPODUpdateDeliveryDate := '';

    FilePlanPropRepo := LocAppGlobals.AppDir + 'PlanPropRepo.htm';

    External_Database_Update := '';
    ChangePassStation := '';
    Upload_Download_disable := '';
    // Arc not to download
    tbl_wkc_alt_NOT_Dwld := '';
    tbl_arty_NOT_Dwld    := '';
    tbl_resCat_NOT_Dwld  := '';
    tbl_res_sub_NOT_Dwld := '';
    tbl_ruleOccToOcc_NOT_Dwld := '';
    tbl_prop_NOT_Dwld         := '';
    tbl_res_NOT_Dwld          := '';
    tbl_ruleResToOcc_NOT_Dwld := '';
    tbl_prop_res_NOT_Dwld     := '';
    tbl_unit_NOT_Dwld         := '';
    tbl_wkc_NOT_Dwld          := '';
    tbl_wkc_proc_NOT_Dwld     := '';
    tbl_wkst_NOT_Dwld         := '';
    tbl_wkst_wkc_NOT_Dwld     := '';
    tbl_wkc_priority_NOT_Dwld  := '';
    tbl_machine_setup_code_NOT_Dwld := '';
    tbl_wkc_dependency_NOT_Dwld     := '';
    tbl_material_sup_detail_NOT_Dwld := '';
    tbl_material_sup_header_NOT_Dwld := '';
    tbl_wkc_group_NOT_Dwld           := '';
    tbl_wkc_Category_NOT_Dwld        := '';
    tbl_CategoryDatesInfo_NOT_Dwld   := '';
    tbl_wkc_Penalties_NOT_Dwld       := '';
    tbl_LearningCurve_NOT_Dwld       := '';
    LogTimes := TStringList.Create;

    Time_PropertyRules := 0;
    Time_insertTheTuplesToProductionTables := 0;
    Time_BigSql := 0;
    Time_ToTal_Blockes := 0;
    Time_searchInListLinear := 0;
    Time_FULLITEMKEYDECODER_TOOL := 0;
    Time_Fill_PRODUCT_SqlStart := 0;
    Time_Fill_Tool_SqlStart := 0;
    Time_fillADWithRelationToList := 0;
    Time_FillGeneric := 0;
    Time_For_fillUnique_nonUniqueWorkCenterProcesses := 0;
    Time_For_ifNeededAddToStepIdListForProgressList_PO := 0;
    Time_For_ifNeededAddWorkCenterAndOperationToList := 0;
    Time_For_getTimeTypeCode := 0;
    Time_For_progress := 0;
    Time_For_Hgr := 0;
    Time_For_Prodreq := 0;
    Time_For_Article := 0;
    Time_For_Material := 0;
    Time_For_Reqconn := 0;
    Time_For_StepTimes := 0;
    Time_For_steps := 0;
    Time_For_Batch_Size := 0;
    Time_For_properties := 0;
    Time_For_Additional_Data := 0;
    Time_For_BuildAvailabilityStruct := 0;
    Time_for_insertIntoBALANCE_HEADER_List := 0;
    Time_for_operationAfter_Big_SQL := 0;
    Time_For_DeleteOldProdOrderGrp              := 0;
    Time_For_LoadIntoStockDetails               := 0;
    Time_For_PrepareProductionOrderStepQtyPct   := 0;
    Time_For_fillProductsToList_2nd             := 0;
    Time_For_checkIfNeedInsertNewWarpProd        := 0;
    Time_For_RecalcBatchProductionOrder         := 0;
    Time_For_TryToGroupStepTimesRows            := 0;
    Time_For_ClearStructMemoryList              := 0;
    Time_For_operationAfterBigSQL_cleanup       := 0;
    Time_For_DownloadCompanyHandling                  := 0;
    Time_For_BuildSCHEDULESDOWNLOAD_WARP            := 0;
    Time_For_PrepareHandledAttributeWorkCenter        := 0;
    Time_For_LoadIntoWORKCENTERANDOPERATTRIBUTES     := 0;
    Time_For_fillStructs                              := 0;
    Time_For_Fill_MATERIAL_DETAIL_SCHEDULE            := 0;
    Time_For_fillUserGenericGroupTypeUNIQUEID         := 0;
    Time_For_fillColorTypeUNIQUEID                    := 0;
    Time_For_BuildHandledProductionDemandTemplatesStr := 0;
    Time_For_PrepareProdSchedProgress                 := 0;
    Time_For_DeleteAllNotRelevantDemands              := 0;
    Time_For_BuildHandledWcStr                        := 0;
    Time_For_AddNewDemandsToDownloadDemands           := 0;
    Time_For_DiscoverDemandsNotRelevantAndDeleteThem  := 0;
    Time_For_AddNewDemandsToDownloadDemands2          := 0;
    Time_For_UpdatePropertyLinkerToServingGroup       := 0;
    Time_For_UpdatePropertyLinker_CurveFamily         := 0;
    Time_For_BuildProdSchedProgress                   := 0;
    Time_For_BuildHandledProgressTemplatesList        := 0;
    Time_For_DeleteAllNotRelevantProgresses           := 0;
    Time_For_AddToSchedulesDownloadProgress           := 0;
    Time_For_Wait_DeleteProgress             := 0;
    Time_For_Wait_SetQryTblCompar            := 0;
    Time_For_Wait_ComparPreload              := 0;
    Time_For_Wait_BuildProdSchedProgress     := 0;
    Time_for_CheckTableColumns := 0;
    Time_for_fill_Production_Order_Grp_No_list := 0;
    Time_for_fillProductionDemandTemplateStruct := 0;
    Time_for_PrepareHandledProductionDemandTemplate := 0;
    Time_For_BuildProductionDemandFile := 0;
    Time_For_fillArticleTypeToList := 0;
    Time_For_PrepareHandledWorkcenterTemplate := 0;
    Time_For_fillPropertyStruct := 0;
    Time_for_makeRelevantOperationsForColumns := 0;
    Time_for_fillItemTypeLogicalWarehouseStruct := 0;
    Time_For_Build_AD_SelectedColums := 0;
    Time_For_fillUserGenericGroupType := 0;
    Time_For_fillColorType := 0;
    Time_For_fillItemTypesList := 0;
    Time_for_fillLogicalWarehousesToList := 0;
    Time_For_LoadProjectNumbers := 0;
    Time_For_fillAlternativeUM := 0;
    Time_for_fillAlternativeWarehouseStruct := 0;
    Time_For_fillResTableToList := 0;
    Time_for_fillRoutingStepTimeTypeToList := 0;
    Time_for_fillProductsToList := 0;
    Time_For_fillOperationsToList := 0;
    Time_for_fillSalesOrderToList := 0;
    Time_For_fillPurchaseOrderToList := 0;
    Time_For_Fill_Products_properties := 0;
    Time_for_fillItemTypeTemplatesToList := 0;
    Time_for_fillProductionDemandCountersToList := 0;
    Time_For_fillProductionProgressTemplateStruct := 0;

    Time_UpdatePR := 0;
    Time_DelPR    := 0;
    Time_InsertPR := 0;
    Time_UpdatePH := 0;
    Time_DelPH    := 0;
    Time_InsertPH := 0;
    Time_UpdatePD := 0;
    Time_DelPD    := 0;
    Time_InsertPD := 0;
    Time_WriteLogLineToDBFromServer := 0;
    Time_UpdatePS := 0;
    Time_DelPS    := 0;
    Time_UpdateMS := 0;
    Time_DelMS    := 0;
    Time_UpdatePP := 0;
    Time_DelPP    := 0;
    Time_InsertPP := 0;
    Time_UpdatePI := 0;
    Time_DelPI    := 0;
    Time_InsertPI := 0;
    Time_UpdateEC := 0;
    Time_DelEC    := 0;
    Time_InsertEC := 0;
    Time_UpdateIC := 0;
    Time_DelIC    := 0;
    Time_InsertIC := 0;
    Time_UpdateSB := 0;
    Time_DelSB    := 0;
    Time_InsertSB := 0;
    Time_UpdateSP := 0;
    Time_DelSP    := 0;
    Time_InsertSP := 0;
    Time_UpdateST := 0;
    Time_DelST    := 0;
    Time_InsertST := 0;
    Time_UpdateMT := 0;
    Time_DelMT    := 0;
    Time_InsertMT := 0;
    Time_UpdatePA := 0;
    Time_DelPA    := 0;
    Time_InsertPA := 0;

    Time_ClearChangeReqWcTables  := 0;
    Time_UpdCodeReset            := 0;
    Time_UpdCodeSet              := 0;
    Time_DeletePS_Orphans        := 0;
    Time_DeletePSMCM_Orphans     := 0;
    Time_SrvQryPS_Open           := 0;
    Time_SrvQryPSMCM_Open        := 0;
    Time_InsertChangeReqToTable  := 0;

    Time_Compar_PR := 0; Time_Compar_PH := 0; Time_Compar_PD := 0; Time_Compar_PP := 0;
    Time_Compar_PI := 0; Time_Compar_EC := 0; Time_Compar_IC := 0; Time_Compar_SB := 0;
    Time_Compar_SP := 0; Time_Compar_ST := 0; Time_Compar_MT := 0; Time_Compar_PA := 0;
    Time_ComparSort_PR := 0; Time_ComparSort_PH := 0; Time_ComparSort_PD := 0; Time_ComparSort_PP := 0;
    Time_ComparSort_PI := 0; Time_ComparSort_EC := 0; Time_ComparSort_IC := 0; Time_ComparSort_SB := 0;
    Time_ComparSort_SP := 0; Time_ComparSort_ST := 0; Time_ComparSort_MT := 0; Time_ComparSort_PA := 0;
    Count_Compar_PR := 0; Count_Compar_PH := 0; Count_Compar_PD := 0; Count_Compar_PP := 0;
    Count_Compar_PI := 0; Count_Compar_EC := 0; Count_Compar_IC := 0; Count_Compar_SB := 0;
    Count_Compar_SP := 0; Count_Compar_ST := 0; Count_Compar_MT := 0; Count_Compar_PA := 0;

    Count_ReqChanged := 0;
    Count_DelPR    := 0; Count_UpdatePR := 0; Count_InsertPR := 0;
    Count_DelPH    := 0; Count_UpdatePH := 0; Count_InsertPH := 0;
    Count_DelPD    := 0; Count_UpdatePD := 0; Count_InsertPD := 0;
    Count_DelPS    := 0; Count_UpdatePS := 0;
    Count_DelPP    := 0; Count_UpdatePP := 0; Count_InsertPP := 0;
    Count_DelPI    := 0; Count_UpdatePI := 0; Count_InsertPI := 0;
    Count_DelEC    := 0; Count_UpdateEC := 0; Count_InsertEC := 0;
    Count_DelIC    := 0; Count_UpdateIC := 0; Count_InsertIC := 0;
    Count_DelSB    := 0; Count_UpdateSB := 0; Count_InsertSB := 0;
    Count_DelSP    := 0; Count_UpdateSP := 0; Count_InsertSP := 0;
    Count_DelST    := 0; Count_UpdateST := 0; Count_InsertST := 0;
    Count_DelMT    := 0; Count_UpdateMT := 0; Count_InsertMT := 0;
    Count_DelPA    := 0; Count_UpdatePA := 0; Count_InsertPA := 0;



  end;

  with DBAppGlobals do
  begin
    // Environment
    EnvDescr := 'Standard';
    Customer := 'Datatex S.r.l.';

    // Language saved by MqmConfig in Ini - for MqmSrvLoad and MqmConfig
    ReadStrFromIniFile(RgMqmSezCfg, RgCfgLanguage, Language);
    MCM_App        := false;
    License_BOTH_MQM_MCM := false;
    License_MQM := false;
    License_MCM := false;
    Mcm_App_Resched_From_Mqm := false;

    // Last Setting for Plan
    CurrTScale := 3;
    CurrDtTime := now;
    ShowCal := 0;
    ShowZoom := 20;
    CurrRscSort := 0;  // Code Value for Sort Resources

    // Setting for Select Resources Form
    SelRscOrderType := '';
    SelRscOrderItem := '';

    // Form Position and setting
    GlobInitPosForm(-1);

    //Application preferences
    UnscheduleJobsOnStart := '0';
    m_RefreshProcessStarted := false;
    m_SaveProcessStartedAndNotCompleted    := false;
    m_Network_Stoped_Dur_Save := false;
    m_ClientConnectionCriticalRepaired := false;
    CheckStepSeq      := false;
    CenterStartOnMove := true;
    WarnOnMoveFinal   := false;
    WhenMoveShowErrorsIfExist := false;
    DefSchedType := 0;
    ConfLevels   := 1;
    MoveOption   := 0;
    ActAutoSched := 'DEFAULT';
 //   LimitedJobsInGroup := 0;
    ShowColorJobMode := Standard;
    ShowColorJobModeActivTab := Standard;
    MinNumJobsInGroup := 0;
    NumOfMatFamiliyInGroup := 0;
    MaxNumJobsInGroup := 999999999;
    MinQtyInGroup     := 0;
    MaxQtyInGFroup    := 999999999;
    ConvertToRscUomInGroup := false;
    ResUmInGroup := '';
    IsWarpHandled := false;
    WarpCngClientUpdate := false;
    WarpOnlyCngClientUpdate := false;
    BalanceOnlyClientUpdate := false;
    GapInDaysForLatestEndGroup := 0;

    // RELEINFO
    MqmVersion := C_MQM_MAIN_VER + '.' + C_MQM_HOST_DB + '.' +
                  C_MQM_MAIN_PC_DB + ' build ' + C_MQM_BUILD;

    DBAppSettings.EnterLinesToMatLog := true;
  end;

//----------------------------------------------------------------------------//

finalization

 IniAppGlobals.LogTimes.Free;

 if assigned(s_propMtx[1]) then
   TOrigMatrix(s_propMtx[1]).free;
 s_propMtx[1] := nil;

 if assigned(s_rulesRtoOMtx[1])then
    TOrigMatrix(s_rulesRtoOMtx[1]).free;
 s_rulesRtoOMtx[1] := nil;

 if assigned(s_rulesRtoOMtx[2]) then
   TOrigMatrix(s_rulesRtoOMtx[2]).free;
 s_rulesRtoOMtx[2] := nil;

 if assigned(s_rulesOtoOMtx[1]) then
   TOrigMatrix(s_rulesOtoOMtx[1]).free;
 s_rulesOtoOMtx[1] := nil;

 if assigned(s_rulesOtoOMtx[2]) then
   TOrigMatrix(s_rulesOtoOMtx[2]).free;
 s_rulesOtoOMtx[2] := nil;

end.




