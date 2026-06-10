unit UMProdMemory;

interface


uses
  classes, sysutils, DMSrvPC, Forms,
  UMTblDesc, UMCommon,
  gnugettext;

type

  TReqChange = (No, NewReq, Historical, DelReq, HeadrFieldsChange, HeadrPropChange,
                HeaderCosmeticChanged, StepChangeOnly);

  TStepChange = (NoChange ,NewStep ,DelStep , StepFieldChange, StepPropChange,
                StepCosmeticChanged, OnlyProgres_TimeCng);
  TCapResTypeChange = (NewCap,DeleteCap,UpdateCap);
  TDBOperation = (DBEqual, DBInsert, DBUpdate, DBDelete);

  THeaderDeleteType = (DeleteAll, DeleteHeaderDetail, DeleteHeader);
  TStepDeleteType = (DeleteStepAll, DeleteStep);
  THeaderInsertType = (InsertHeaderDetail, InsertHeader);

  TMQMPS = Record
    PS_PREQ_NO : string;
    PS_PSTEP_ID : Integer;
    PS_PSUBST_ID : SMALLINT;
    PS_REPROCCS  : SMALLINT;
    PS_WORK_CENTER : string;
    PS_QTY         : double;
    PS_RSC         : string;
    PS_RESC_CAT    : string;
    PS_MARKED      : boolean;
  end;
  PTMQMPS = ^TMQMPS;

  TMQMPR = Record
    PR_DIV_CODE : string;
    PR_DSP_CODE : string;
    PR_BCH_CODE : string;
    PR_REPROC_NO	: SMALLINT;
    PR_PREQ_NO	: string;
    PR_HISTORICAL_REQ : string;
    PR_USR_CG : string;
    PR_USR_TM_CG : TDateTime;
    PR_ModulHandled : string;
    PR_FAMILYCODE : string;
    PR_IS_FAMILY  : string;
  end;
  PTMQMPR = ^TMQMPR;

  TMQMPH = Record
    PH_PREQ_NO : string;
    PH_HISTORICAL_REQ : string;
    PH_REQ_ORIGIN : string;
    PH_PROD_LINE : string;
    PH_TYPE_PROD : string;
    PH_PROD_FAMILY : string;
    PH_MATERIAL_FAMILY : string;
    PH_PROD_UM : string;
    PH_PROD_LOW_TIME_STRT : TDate;
    PH_PROD_DELIVY_DATE : TDateTime;
    PH_FRC_DEL_DATE :	string;
    PH_SPLITCONFLEVELS : string;
    PH_LEAD_STEP_SPLITED  : Integer;
    PH_MQM_SPLIT_ID       : string;
    PH_Serving_Code       : string;
    PH_Served_Code        : string;
    PH_Curve_Family_Id_Code : string;
    PH_USR_CG : string;
    PH_USR_TM_CG : TDateTime;
    PH_ModulHandled          : string;
    PH_FAMILYCODE            : string;
    PH_CreateDateTimeUTC : TDateTime;
    PH_CrtOrUpdateDateTimeUTC : TDateTime;
  end;
  PTMQMPH = ^TMQMPH;

  TMQMPD = Record
    PD_PREQ_NO : string;
    PD_PSTEP_ID : Integer;
    PD_TO_SCHED : string;
    PD_PRV_STEP_SCHED_MQM : SMALLINT;
    PD_PRV_STEP_TRUE  : SMALLINT;
    PD_NEX_STEP_SCHED_MQM : SMALLINT;
    PD_NEX_STEP_TRUE	: SMALLINT;
    PD_STEP_TYP       : string;
    PD_MAT_ARRV_DATE :	TDateTime;
    PD_FRC_MAT_DATE   : string;
    PD_PLAN_START : TDateTime;
    PD_LOW_LIMIT_TIME_STRT :	TDateTime;
    PD_FRC_LOW_DATE : string;
    PD_PLAN_END : TDateTime;
    PD_HIGH_LIMIT_TIMEND : TDateTime;
    PD_FRC_HIGH_DATE :	string;
    PD_WKCNTER : string;
    PD_INITIALPLANSCHEDDATETIME : TDateTime;
    PD_FINALPLANSCHEDDATETIME : TDateTime;
    PD_WKCT_PROC : string;
    PD_INIT_QUENT : double;
    PD_FIN_QUENT : double;
    PD_WEIGHT : double;
    PD_DESC_UM : string;
    PD_CAL : string;
    PD_SETUP_TIME_STP : double;
    PD_EXC_TIME_STP : double;
    PD_RES_NUM_PLN : double;
    PD_NumResComponents : integer;
    PD_ALLOW_SPLIT : string;
    PD_STEP_HANDLE_REPROCES : string;
    PD_STEP_PART_GEN_PLAN : string;
    PD_STEP_CAN_GROUP : string;
    PD_FORCED_GRP_NO : double;
    PD_CONN_TYPE_PREV_STEP_SPLIT : string;
    PD_FRC_OVERLAPP :	string;
    PD_STEP_CLOSED : string;
    PD_USR_CG : string;
    PD_USR_TM_CG : TDateTime;
    PD_SchedulByMcm    : string;
    PD_SchedulByMqm    : string;
    PD_SplitFamily     : string;
    PD_LearningCurveCode : string;
    PD_LearningCurveType : string;
    PD_OVERLAP_WITH_OTHER_STEPS : string;
    PD_ApprovalDate      : TDateTime;
    PD_GRP_SEQUENCE      : string;
    PD_Prev_LeadTime_mqm  : double;
    PD_Next_LeadTime_mqm  : double;
    PD_Next_LeadTimeBatch_mqm : double;
    PD_Prev_LeadTimeBatch_mqm : double;
    PD_BatchSizePerStep  : string;
    PD_MinBatchSize      : double;
    PD_OptimumBatchSize  : double;
    PD_MaxBatchSize      : double;
    PD_FAMILYCODE        : string;
    PD_PRV_STEP_SCHED_MCM : SMALLINT;
    PD_NEX_STEP_SCHED_MCM : SMALLINT;
   	PD_Prev_LeadTime_Mcm  : double;
    PD_Next_LeadTime_Mcm  : double;
    PD_Prev_LeadTimeBatch_mcm : double;
    PD_Next_LeadTimeBatch_mcm : double;
    PD_MaxStartDateAutoSeq : TDateTime;
    PD_ALTERNATIVEQTY : double;
    PD_ALTERNATIVEUM  : string;
    PD_CreateDateTimeUTC : TDateTime;
    PD_CrtOrUpdateDateTimeUTC : TDateTime;

    WP_QUEUE_TIME : string;
    Wp_POST_PROCESS : string;
    QUEUE_TIME : double;
    POST_PROCESS : double;
  end;
  PTMQMPD = ^TMQMPD;

  TMQMPP = Record
    PP_PREQ_NO : string;
    PP_PSTEP_ID :	SMALLINT;
    PP_RSC_CODE :	string;
    PP_PROPERTY : string;
    PP_VALUE : string;
    PP_USR_CG : string;
    PP_USR_TM_CG : TDateTime;
    PP_NUMERIC_VALUE : double;
    PP_FAMILYCODE    : string;
    IsPropLinkerToServingGroup : boolean;
    PP_CreateDateTimeUTC : TDateTime;
    PP_CrtOrUpdateDateTimeUTC : TDateTime;
    PP_SortKey : string;
  end;
  PTMQMPP = ^TMQMPP;

  TMQMProductProperty = Record
    PDP_TYPE_PROD :    string;
    PDP_PRODUCT_CODE : string;
    PDP_PROPERTY :     string;
    PDP_VALUE : string;
  end;
  PMQMProductProperty = ^TMQMProductProperty;

  TMQMPI = Record
    PI_PREQ_NO : string;
    PI_PSTEP_ID :	SMALLINT;
    PI_INFO_TYPE : string;
    PI_INFO_LINE_NUM : SMALLINT;
    PI_INFO_AREA : string;
    PI_USR_CG : string;
    PI_USR_TM_CG : TDateTime;
    PI_FAMILYCODE    : string;
  end;
  PTMQMPI = ^TMQMPI;

  TMQMEC = Record
    EC_PREQ_NO : string;
    EC_CONNE_KEY : string;
    EC_NUM_LEVELS : SMALLINT;
    EC_CONN_CERTENT_LEVEL :	string;
    EC_USR_CG : string;
    EC_USR_TM_CG : TDateTime;
    EC_FAMILYCODE    : string;
  end;
  PTMQMEC = ^TMQMEC;

  TMQMIC = Record
    IC_PREQ_NO : string;
    IC_PREV_PREQ_NO : string;
    IC_USR_CG : string;
    IC_USR_TM_CG : TDateTime;
    IC_FAMILYCODE  : string;
    IC_CreateDateTimeUTC : TDateTime;
    IC_CrtOrUpdateDateTimeUTC : TDateTime;
  end;
  PTMQMIC = ^TMQMIC;

  TMQMSB = Record
    SB_PREQ_NO : string;
    SB_PSTEP_ID : SMALLINT;
    SB_BCH_UM : string;
    SB_MULTIPILR_TO_BATCH_UM : double;
    SB_FAMILYCODE  : string;
    SB_CreateDateTimeUTC : TDateTime;
    SB_CrtOrUpdateDateTimeUTC : TDateTime;
  end;
  PTMQMSB = ^TMQMSB;

  TMQMSP = Record
    SP_PREQ_NO : string;
    SP_PSTEP_ID :	SMALLINT;
    SP_PSUBST_ID : SMALLINT;
    SP_REPROC_NO :	SMALLINT;
    SP_LAST_PROG_TYPE :	string;
    SP_RSC_CODE : string;
    SP_PROGRESED_GROUP : INTEGER;
    SP_PROGRSTART : TDateTime;
    SP_CURR_PRG_DATE : TDateTime;
    SP_PROGREND : TDateTime;
    SP_QTY : double;
    SP_StartingQty : double;
    SP_REMAIN_TIME : double;
    SP_LAST_PROG_TYPE_HOST :	string;
    SP_RSC_CODE_HOST : string;
    SP_PROGRESED_GROUP_HOST : INTEGER;
    SP_PROGRSTART_HOST : TDateTime;
    SP_CURR_PRG_DATE_HOST : TDateTime;
    SP_PROGREND_HOST : TDateTime;
    SP_QTY_HOST : double;
    SP_REMAIN_TIME_HOST : double;
    SP_WORK_CENTER  : string;
    SP_RES_CAT      : string;
    SP_PD_INIT_QUENT : double;
//    SP_ProgressChange : TStepChange;
//    SP_Group_String_List : TStringList; ERAN 25/02/2024 - This list is not used anywhere - We assume it was used until all the logic of reorgenize progresses moved to MQM
    SP_Step_Type : string;
    SP_CreateDateTimeUTC : TDateTime;
    SP_CrtOrUpdateDateTimeUTC : TDateTime;
  end;
  PTMQMSP = ^TMQMSP;

  TMQMSPOVER = Record
    SPO_PREQ_NO : string;
    SPO_PSTEP_ID :	SMALLINT;
    SPO_PSUBST_ID : SMALLINT;
    SPO_REPROC_NO :	SMALLINT;
    SPO_LAST_PROG_TYPE :	string;
    SPO_RSC_CODE : string;
//    SPO_PROGRESED_GROUP : INTEGER;
    SPO_PROGRSTART : TDateTime;
    SPO_CURR_PRG_DATE : TDateTime;
    SPO_PROGREND : TDateTime;
    SPO_QTY : double;
    SPO_STARTQTY : double;
    SPO_REMAIN_TIME : double;
  end;
  PTMQMSPOVER = ^TMQMSPOVER;

  TPROGRESSES = record
    ProgressNumber : string;
    DemandCounterCode : string;
    DemandCode        : string;
    CounterCode       : string;
	  Request : string;
	  Step    : integer;
	  ProgressType {, ProgressTypeOrig } : string;
	  Resource     : string;
	  ProgressStart : TDateTime;
	  ProgressCurrent : TDateTime;
	  Qty             : double;
      StartingQty     : double;
	  Closed          : boolean;
	  Deleted         : boolean;
    Is_finalAndSplit : boolean;
    FAMILYCODE : string;
    ProductionOrderCode : string;
  end;
  PTPROGRESSES = ^TPROGRESSES;

  TMQMST = Record
    ST_PREQ_NO : string;
    ST_PSTEP_ID :	SMALLINT;
    ST_WKCNTER : string;
    ST_WKCT_PROC : string;
    ST_RES_CATEGORY : string;
    ST_RSC_CODE : string;
    ST_SEQCHAR :	string;
//    ST_SEQUENCE :	SMALLINT;
//    ST_TIME_DESCR : string;
    ST_SETUP_TIME_Mechin_Code : string;
    ST_SETUP_TIME_JOB : double;
    ST_EXC_TIME_INIT_QTY : double;
    ST_MATERIAL :	string;
    ST_FAMILYCODE : string;
    ST_timeTypeCode : string;

    // handle batch times
    ST_stepType : string;
    ST_multiplierExecution : double;
    ST_multiplierSetUp : double;
    ST_BatchTimeType : string;
    ST_ProductionOrderCode : string;
    ST_GroupStepNumber : string;
    ST_CalcTime2 : double;
    ST_CalcTime3 : double;
    ST_INITIALBASEPRIMARYQUANTITY : double;
    ST_STANDARDSTEPQUANTITY : double;
    ST_TimeArriveFromNowStep : boolean;
    ST_CreateDateTimeUTC : TDateTime;
    ST_CrtOrUpdateDateTimeUTC : TDateTime;
  end;
  PTMQMST = ^TMQMST;

  TMQMPA = Record
    PA_PROD_REQ_NR : string;
    PA_SEQUENCE    : string;
    PA_PROD_CODE : string;
    PA_NET_GROUP_Code : string;
    PA_ALL_REQ : string;
    PA_PROD_BALANCE : string;
    PA_RESOURCE : string;
    PA_SETTLED : string;
    PA_REQ_QUANTY  : double;
    PA_QTY_PRODUCED : double;
    PA_QTY_ALL : double;
    PRODUCTIONDEMANDTEMPLATECODE: String;
    PRODUCTIONDEMANDCOUNTERCODE: String;
    ITEMTYPECODE: String;
    PA_FAMILYCODE : string;
    PA_CreateDateTimeUTC : TDateTime;
    PA_CrtOrUpdateDateTimeUTC : TDateTime;
  end;
  PTMQMPA = ^TMQMPA;

  TMQMMT = Record
    MT_PROD_REQ_Nr  : string;
    MT_PSTEP_ID :	SMALLINT;
    MT_ORG_STEP     : SMALLINT;
    MT_WKCTR_CODE   : string;
//    MT_WKC_PROCESS  : string;
    MT_RES_CAT_CODE : string;
    MT_RES_CODE     : string;
    MT_MACHIN_SETUP_CODE : string;
    MT_ALTERNATIVE_CODE  : string;
    MT_PROD_TYPE    : string;
    MT_PROD_CODE    : string;
    MT_NET_GROUP_CODE : string;
//    MT_NET_GROUP_CODE_WITHOUT_PROGECTCODE : string;
    MT_ISSUE_CODE : string;
    MT_SEQ_ISSUED     : string;
    MT_MAT_BALACE     : string;
    MT_REQ_QUANTITY   : double;
    MT_QUANTITY_ISSUE : double;
    MT_SETTLED : string;
    MT_QUANTITY_ALLOC : double;
    MT_HIGH_DATe_ALLOC : TDateTime;
    MT_SEARCH_MAT_BY_ALLOC : string;
    ToBeDeleted : string;
    MT_FAMILYCODE : string;
    MT_CreateDateTimeUTC : TDateTime;
    MT_CrtOrUpdateDateTimeUTC : TDateTime;
  end;
  PTMQMMT = ^TMQMMT;

  TMQMCR = Record
    CR_CAPACY_RESRV    : integer;
    CR_RSC             : string;
    CR_SUB_LINE_RES    : integer;
    CR_WC_PROCESS      : string;
    CR_CAPRES_TYPE     : string;
    CR_CAPACITY_To_JOB : string;
    CR_COMMENTS        : string;
    CR_SCHEDULE_START  : TDateTime;
    CR_SCHEDULE_END    : TDateTime;
    CR_CAP_RES_TYPE_CHANGE : TCapResTypeChange;
    CR_USR_CG : string;
    CR_USR_TM_CG : TDateTime;
  end;
  PTMQMCR = ^TMQMCR;

  TMQMCRWKC = Record
    CRW_WKC             : string;
    CRW_RSC             : string;
  end;
  PTMQMCRWKC = ^TMQMCRWKC;

  TCapRes = Record
    CR_WKC             : string;
    CR_CAPACY_RESRV    : integer;
    CR_RSC             : string;
    CR_SUB_LINE_RES    : integer;
    CR_WC_PROCESS      : string;
    CR_CAPRES_TYPE     : string;
    CR_CAPACITY_To_JOB : string;
    CR_COMMENTS        : string;
    CR_SCHEDULE_START  : TDateTime;
    CR_SCHEDULE_END    : TDateTime;
    CR_CAP_RES_TYPE_CHANGE : TCapResTypeChange;
    CR_USR_CG : string;
    CR_USR_TM_CG : TDateTime;
  end;
  PTCapRes = ^TCapRes;

{  RecAR = record
    AR_ArtProdType : string;
    AR_ProdCode   : string;
    AR_ProductNature : string;
    AR_StartConsumPoint : string;
    AR_EndConsumPoint : string;
    AR_InfoArea       : string;
    AR_StdPurcOrProdTime : Integer;
    AR_Ignor_Mat_check   : boolean;
  end;
  PRecAR = ^RecAR;  }

  RecBH = record
    BH_ProdType : string;
    BH_InfoArea   : string;
    BH_ProdCode : string;
    BH_netGroupCode : string;
    BH_dueDate : TDateTime;
    BH_OrigdueDate : TDateTime;
    BH_quant : double;
    BH_usrCg : string;
    BH_usrTmCg : TDateTime;
  end;
  PRecBH = ^RecBH;

{  RecBD = record
    BD_dueDate : TDateTime;
    BD_InfoArea   : string;
    BD_netGroupCode : string;
    BD_occupyCode : string;
    BD_ProdCode : string;
    BD_quant : double;
    BD_ProdType : string;
  end;
  PRecBD = ^RecBD;  }

  RecEI = record
    EI_ConnKey : string;
    EI_infoLineNum : Integer;
    EI_InfoArea : string;
    EI_usrCg : string;
    EI_usrTmCg : TDateTime;
  end;
  PRecEI = ^RecEI;

  RecEH = record
    EH_ConnKey  : string;
    EH_ConnType : string;
    EH_DueDate  : TDateTime;
    EH_usrCg    : string;
    EH_usrTmCg  : TDateTime;
  end;
  PRecEH = ^RecEH;

  RecMS = record
    MS_Type_Prod    : string;
    MS_Product_Code : string;
    MS_Preq_No      : string;
    MS_Step         : integer;
    MS_Sub_Detail   : string;
    MS_Detail_Code  : string;
    MS_Quantity     : double;
    MS_Net_Group_Code : string;
    MS_UNITCODE       : string;
    MS_HostItemIndentifier : double;
    MS_HostWarehouse : string;
    MS_DetailCodeType : string;
    MS_SubDetailHostType : string;
    MS_RSC_CODE       : string;
    MS_OverridenSetupTime : double;
    MS_OverridenSpeed     : double;
    MS_SCH_START          : TDateTime;
    MS_SCH_END            : TDateTime;
    MS_FirstJobQuantityIncluded : double;
    MS_LastJobQuantityIncluded  : double;
  end;
  PRecMS = ^RecMS;
  
  RecRes = record
    RS_RSC_CODE  : string;
    RS_WKCNTER : string;
    RS_RES_CATEGORY  : string;
    RS_NUM_RSC_COMP    : Double;
  end;
  PRecRes = ^RecRes;

  RecDemandReservationLine = record  //DemandReservationLines
    ORDERCOUNTERCODE : string;
    ordercode  : string;
    reservationline : integer;
    PRODUCTIONORDERCODE  : string;
    groupline : integer;
    StepNumber  : integer;
  end;
  PRecDemandReservationLine = ^RecDemandReservationLine;

  RecDemandOrOrderReservationLine = record  //DemandOrOrderReservationLines
    Environment : String;
    CompanyCode : String;
    CounterCode : string;
    code  : string;
    reservationline : Integer;
  end;
  PRecDemandOrOrderReservationLine = ^RecDemandOrOrderReservationLine;

  function AddProdRq(tbl : table; srvQry: TMqmQuery; HostQry : TMqmQuery ; IsHostQry : boolean ;IsInsert : boolean): boolean;
  function AddProdRqHeader(tbl : table; srvQry: TMqmQuery; HostQry : TMqmQuery; IsHostQry : boolean; IsInsert : boolean): boolean;
  function AddProdRqDetails(tbl : table; srvQry: TMqmQuery; HostQry : TMqmQuery ;IsHostQry : boolean; IsInsert : boolean): boolean;
  function AddProdProperty(tbl : table; srvQry: TMqmQuery; HostQry : TMqmQuery; IsHostQry : boolean ;IsInsert : boolean): boolean;
  function AddProdImfo(tbl : table; srvQry: TMqmQuery; HostQry : TMqmQuery; IsHostQry : boolean ; IsInsert : boolean): boolean;
  function AddProdExternalConn(tbl : table; srvQry: TMqmQuery; HostQry : TMqmQuery; IsHostQry : boolean ; IsInsert : boolean): boolean;
  function AddProdInternalConn(tbl : table; srvQry: TMqmQuery; HostQry : TMqmQuery; IsHostQry : boolean ; IsInsert : boolean): boolean;
  function AddProdBatch(tbl : table; srvQry: TMqmQuery; HostQry : TMqmQuery; IsHostQry : boolean ; IsInsert : boolean): boolean;
  function AddProdProgress(tbl : table; srvQry: TMqmQuery; HostQry : TMqmQuery; IsHostQry : boolean ; IsInsert : boolean): boolean;
  function AddProdStepTimes(tbl : table; srvQry: TMqmQuery; HostQry : TMqmQuery; IsHostQry : boolean ;IsInsert : boolean): boolean;
  function AddProducedArticle(tbl : table; srvQry: TMqmQuery; HostQry : TMqmQuery; IsHostQry : boolean ;IsInsert : boolean): boolean;
  function AddMaterial(tbl : table; srvQry: TMqmQuery; HostQry : TMqmQuery; IsHostQry : boolean ;IsInsert : boolean): boolean;
  function AddCapRes(tbl : table; srvQry: TMqmQuery; HostQry : TMqmQuery; IsHostQry : boolean ;IsInsert : boolean): boolean;

  procedure CreateProdContMemory;
  procedure CheckChangeReq(HostQry : TMqmQuery);
  function  InsertReqListToDataBase(var GotAccess : boolean) : boolean;
  function  InsertCapResListToDataBase : boolean;
  procedure ClearMemoryList;
  procedure CopyProdSchedToProdSchedMcm(var srvTrs: TMqmTransaction);
  procedure SetPDThreadList(ThreadPDList : TList);
  function  GetReqListCount : Integer;
  function  GetCapResListCount : Integer;
//  procedure Check_FamilyStructureInNow;
  function  Get_DownloadFamilyFromNow : boolean;
  procedure Set_DownloadFamilyFromNow(Flag : boolean);
  procedure StartComparPreload;
  procedure WaitAndAssignComparPreload;

implementation

uses UMSaveLoad,UGconvert,UMsrvLoad,UMProdSortList,UMStoredProc,UMSrvConfig,Dialogs,Windows, UMglobal,
   DateUtils, DB, UMProductionStruct, Variants, UopThread, System.Threading;

type

  TypeCheck = (PR,PH,PD,PP,PI,EC,IC,SB,SP,ST,MT,PA);

  ReqTempProp = Record
    PropCode : string;
    PropVal  : string;
  end;
  PReqTempProp = ^ReqTempProp;

  ReqChange = Record
    ProdReq : string;
    ChangedType : TReqChange;
    Reactivate : boolean;
    HandledByMcm : boolean;
    PrevHandledByMcm : boolean;
    Reason : string;
{    Index_PR : Integer;
    Index_PH : Integer;
    Index_PD : Integer;
    Index_PP : Integer;
    Index_PI : Integer;
    Index_EC : Integer;
    Index_IC : Integer;
    Index_SB : Integer;
    Index_SP : Integer;
    Index_ST : Integer;
    Index_MT : Integer;
    Index_PA : Integer;  }
  end;
  PReqChange = ^ReqChange;

  StepChange = Record
    ProdReq : string;
    StepNr  : integer;
    ChangedType : TStepChange;
    HandledByMcm : boolean;
    PrevHandledByMcm : boolean;
    Reason : string;
 {   Index_PR : Integer;
    Index_PH : Integer;
    Index_PD : Integer;
    Index_PP : Integer;
    Index_PI : Integer;
    Index_SB : Integer;
    Index_SP : Integer;
    Index_ST : Integer;
    Index_MT : Integer;   }
  end;
  PStepChange = ^StepChange;

  McmReqChange = Record
    StartDwndTime : TDateTime;
    ProdReq : string;
    ChangedType : TReqChange;
    step    : integer;
  end;
  PMcmReqChange = ^McmReqChange;

  TProdCont = class
  private
    m_Req_Change_List : TList;
    m_Req_Step_Change_List : TList;
    m_Work_Cnter_Chang_List : TStringList;
    m_PropTabale : TStringList;
    m_Cap_Res_Changed_list : TList;
    m_Rsc_Change_List : TStringList;

    m_HostListPR : TList;
    m_HostListPH : TList;
    m_HostListPD : TList;
    m_HostListPP : TList;
    m_HostListPI : TList;
    m_HostlistPA : TList;
    m_HostListEC : TList;
    m_HostListIC : TList;
    m_HostListSB : TList;
    m_HostListSP : TList;
    m_HostListST : TList;
    m_HostlistMT : TList;

    m_LocalListPR : TList;
    m_LocalListPH : TList;
    m_LocalListPD : TList;
    m_LocalListPP : TList;
    m_LocalListPI : TList;
    m_LocalListEC : TList;
    m_LocalListIC : TList;
    m_LocalListSB : TList;
    m_LocalListSP : TList;
    m_LocalListST : TList;
    m_LocalListMT : TList;
    m_LocalListPA : TList;

    m_TmpPP_Memory : TList;
    m_TmpPP_Disk : TList;

    m_Local_IndexPR : Integer;
    m_Local_IndexPH : Integer;
    m_Local_IndexPD : Integer;
    m_Local_IndexPP : Integer;
    m_Local_IndexPI : Integer;
    m_Local_IndexEC : Integer;
    m_Local_IndexIC : Integer;
    m_Local_IndexSB : Integer;
    m_Local_IndexSP : Integer;
    m_Local_IndexST : Integer;
    m_Local_IndexMT : Integer;
    m_Local_IndexPA : Integer;

    m_Host_IndexPR : Integer;
    m_Host_IndexPH : Integer;
    m_Host_IndexPD : Integer;
    m_Host_IndexPP : Integer;
    m_Host_IndexPI : Integer;
    m_Host_IndexEC : Integer;
    m_Host_IndexIC : Integer;
    m_Host_IndexSB : Integer;
    m_Host_IndexSP : Integer;
    m_Host_IndexST : Integer;
    m_Host_IndexMT : Integer;
    m_Host_IndexPA : Integer;

    m_Host_Begin_IndexPR : Integer;
    m_Host_Begin_IndexPH : Integer;
    m_Host_Begin_IndexPD : Integer;
    m_Host_Begin_IndexPP : Integer;
    m_Host_Begin_IndexPI : Integer;
    m_Host_Begin_IndexEC : Integer;
    m_Host_Begin_IndexIC : Integer;
    m_Host_Begin_IndexSB : Integer;
    m_Host_Begin_IndexSP : Integer;
    m_Host_Begin_IndexST : Integer;
    m_Host_Begin_IndexMT : Integer;
    m_Host_Begin_IndexPA : Integer;

    m_Begin_StepIndexPD : Integer;
    m_Begin_StepIndexPP : Integer;
    m_Begin_StepIndexPI : Integer;
    m_Begin_StepIndexSB : Integer;
    m_Begin_StepIndexSP : Integer;
    m_Begin_StepIndexST : Integer;
    m_Begin_StepIndexMT : Integer;
    m_UpdatedGenNumber : Integer;
    m_Updated_Rsc_Change_Number : integer;
    m_Updated_CapRes_Number : integer;
    m_StartDownloadDateTime : TDateTime;
    m_DownloadFamilyFromNow : boolean;

  public
    constructor Create;
    destructor Destroy; override;
  private
    function AddReqToCngList(Request : string ; TypChange : TReqChange ; Req_Reactivate : boolean; HandledByMcm : string; PrevReqHandledByMcm : string; Reason : string) : Integer;
    function AddStepReqToCngList(Request : string ; Step : Integer ; TypChange : TStepChange; HandledByMcm : string ; PrevStepHandledByMcm : string; Reason : string) : Integer;
    function  EOL_Host(Typ : TypeCheck): boolean;
    function  EOL_Local(Typ : TypeCheck): boolean;
    function  SearchPropInList(InMemory : boolean; PropCode : string; var Value : string): boolean;
    procedure SetPosOnHostList(Request : string);
    procedure SetPosOnStepHostList(Request : string ; Step : integer);
    procedure SetPosOnLocalList(Request : string);
    procedure SetPosOnStepLocalList(Request : string ; Step : integer);
    procedure SetPosOnQry(Request : string; QryPH,QryPD,QryPP,QryPI,QryEC,QryIC,QrySB,QrySP,QryST,QryMT,QryPA : TMqmQuery);
    procedure SetStepPosOnQry(Request : string; step : Integer ; QryPP,QryPI,QrySB,QrySP,QryST,QryMT : TMqmQuery);
    procedure CheckChangeReq(HostQry : TMqmQuery);
    procedure GetPropFromTable;
    procedure updateExeMinProdSched;
    procedure ClearPPTempList;
    function  GetUpdatedReqNumber : Integer;
    function  GetUpdatedResChangedNumber : Integer;
    function  GetUpdatedCapResNumber : Integer;

    function  CheckWorkCenterChangeList(Wc : string) : boolean;
    function  InsertReqListToDataBase(var GotAccess : boolean) : boolean;
    function  InsertCapResListToDataBase : boolean;
    procedure InsertMcmReqRecordToDataBase(McmReqChange : PReqChange; var srvTrs: TMqmTransaction);
    procedure InsertMcmStepRecordToDataBase(McmStepChange : PStepChange; ReqChange : PReqChange;  var srvTrs: TMqmTransaction);
    function  ClearChangeReqWcTables : boolean;
    function  ClearChangeCapResTables(srvTrs: TMqmTransaction) : boolean;
    procedure InsertChangeReqToTable(LastUpdateRecord : boolean; Req : string; ReqChange : PReqChange ; var srvTrs: TMqmTransaction; PreparedQry: TMqmQuery = nil);
    procedure InsertWCChangeReqToTable(LastUpdateRecord : boolean; var srvTrs: TMqmTransaction ; WorkCenter : string);
    procedure InsertChangeCapResToTable(var srvTrs: TMqmTransaction);
    procedure InsertChangeCapResToTableAs400(var srvTrs: TMqmTransaction);
    procedure InsertResChangeCapResToTabl(var srvTrs: TMqmTransaction);
    procedure InsertChangeStepReqToTable(Req : string; StepId : Integer; StepChange : PStepChange; var srvTrs: TMqmTransaction);
    function  CheckProperty(PropCode : string) : boolean;
    function  CheckAlternativeWC(WC : string ; Process : string ; altWC : string ; altProcess : string): boolean;
    function  CopyProdSchedToProdSchedMcm(var srvTrs: TMqmTransaction) : boolean;
    function  UpdateStatusRequests : boolean;
    procedure OrganizeSubStepsForProgress(ListPs : TList; Ini_Index_Sp : Integer);
    procedure FreeListProd;
    procedure ClearMemoryList;
    procedure SetPDThreadList(ThreadPDList : TList);

  end;

var
  m_ProdCont : TProdCont;
  m_LowestNumber_CapRes : Integer;
  g_ComparTask1          : ITask;
  g_ComparTask2          : ITask;
  g_ComparTask3          : ITask;
  g_ComparPreloadApplied : Boolean;
  g_PreloadListPR : TList;
  g_PreloadListPH : TList;
  g_PreloadListPD : TList;
  g_PreloadListPP : TList;
  g_PreloadListPI : TList;
  g_PreloadListEC : TList;
  g_PreloadListIC : TList;
  g_PreloadListSB : TList;
  g_PreloadListSP : TList;
  g_PreloadListST : TList;
  g_PreloadListMT : TList;
  g_PreloadListPA : TList;
const
  fldListPR : array [0..8] of TQryLinkRec = (
    (fldPC: fli_divCode;        fldAS: 'KCDDIV'; fldType: TLD_string),
    (fldPC: fli_dispoCode;      fldAS: 'KCDDIS'; fldType: TLD_string),
    (fldPC: fli_bch;            fldAS: 'KNRLOT'; fldType: TLD_string),
    (fldPC: fli_reprocNo;       fldAS: 'KNRLOR'; fldType: TLD_integer),
    (fldPC: fli_preqNo;         fldAS: 'KPRREQ'; fldType: TLD_string),
    (fldPC: fli_HistoriclReq;   fldAS: 'KHSTRQ'; fldType: TLD_string),
    (fldPC: fli_usrCg;          fldAS: 'KUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;        fldAS: 'KDTOCH'; fldType: TLD_DateTime),
    (fldPC: fli_ModulHandled;   fldAS: 'KMODUL'; fldType: TLD_string)
  );

  fldListPH : array [0..19] of TQryLinkRec = (
    (fldPC: fli_preqNo;          fldAS: 'MPRREQ'; fldType: TLD_string),
    (fldPC: fli_HistoriclReq;    fldAS: 'MHSTRQ'; fldType: TLD_string),
    (fldPC: fli_ReqOrigin;       fldAS: 'MRQORG'; fldType: TLD_string),
    (fldPC: fli_ProdLine;        fldAS: 'MPRDLN'; fldType: TLD_string),
    (fldPC: fli_ProdType;        fldAS: 'MRECTY'; fldType: TLD_string),
    (fldPC: fli_ProdFamily;      fldAS: 'MPRDFM'; fldType: TLD_string),
    (fldPC: fli_MaterialFamily;  fldAS: 'MMTRFM'; fldType: TLD_string),
    (fldPC: fli_ProdUMCode;      fldAS: 'MPRDUM'; fldType: TLD_string),
    (fldPC: fli_ProdLowDataTime; fldAS: 'MPRLDT'; fldType: TLD_dateTime),
    (fldPC: fli_ProdDelivDate;   fldAS: 'MPRDDT'; fldType: TLD_dateTime),
    (fldPC: fli_FrcDelDate;      fldAS: 'MFRDDT'; fldType: TLD_string),
    (fldPC: fli_usrCg;           fldAS: 'MUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;         fldAS: 'MDTOCH'; fldType: TLD_dateTime),
    (fldPC: fli_ModulHandled;            fldAS: 'MMODUL'; fldType: TLD_string),
    (fldPC: fli_SplitConfLevels;         fldAS: 'MSPCNF'; fldType: TLD_string),
    (fldPC: fli_LeadpstepIdForSplit;     fldAS: 'MSPSTP'; fldType: TLD_Integer),
    (fldPC: fli_NewPreqUniqId;           fldAS: 'MMQMNR'; fldType: TLD_String),
    (fldPC: fli_Serving_Code;            fldAS: 'MSRVCD'; fldType: TLD_String),
    (fldPC: fli_Served_Code;             fldAS: 'MSRBCD'; fldType: TLD_String),
    (fldPC: fli_CurveFamilyIdCode;       fldAS: '';       fldType: TLD_String)
  );

  fldListPD: array [0..61] of TQryLinkRec = (
    (fldPC: fli_preqNo;                 fldAS: 'OPRREQ'; fldType: TLD_string),
    (fldPC: fli_pstepId;                fldAS: 'OPRSTP'; fldType: TLD_integer),
    (fldPC: fli_ToBeSched;              fldAS: 'OTBSCH'; fldType: TLD_string),
    (fldPC: fli_prevStepSched_Mqm;      fldAS: 'OPRVST'; fldType: TLD_integer),
    (fldPC: fli_prevStepTrue;           fldAS: 'OPRVSS'; fldType: TLD_integer),
    (fldPC: fli_NextStepSched_mqm;      fldAS: 'ONXTST'; fldType: TLD_integer),
    (fldPC: fli_NextStepTrue;           fldAS: 'ONXTSS'; fldType: TLD_integer),
    (fldPC: fli_StepType;               fldAS: 'OSTPTP'; fldType: TLD_string),
    (fldPC: fli_MaterialArrivDate;      fldAS: 'OMTADT'; fldType: TLD_dateTime),
    (fldPC: fli_FrcMatDate;             fldAS: 'OFRMTD'; fldType: TLD_string),
    (fldPC: fli_planStart;              fldAS: 'OPLSDT'; fldType: TLD_dateTime),
    (fldPC: fli_LowStartTimeLimit;      fldAS: 'OLSTDT'; fldType: TLD_dateTime),
    (fldPC: fli_FrcLowestDate;          fldAS: 'OFRLWD'; fldType: TLD_string),
    (fldPC: fli_planEnd;                fldAS: 'OPLEDT'; fldType: TLD_dateTime),
    (fldPC: fli_HighEndTimeLimit;       fldAS: 'OHSTDT'; fldType: TLD_dateTime),
    (fldPC: fli_FrcHighestDate;         fldAS: 'OFRHGD'; fldType: TLD_string),
    (fldPC: fli_wkCtrCode;              fldAS: 'OPLMAC'; fldType: TLD_string),
    (fldPC: fli_wkcProc;                fldAS: 'OPLMAP'; fldType: TLD_string),
    (fldPC: fli_quantInit;              fldAS: 'OINIQT'; fldType: TLD_float),
    (fldPC: fli_quantFinl;              fldAS: 'OFINQT'; fldType: TLD_float),
    (fldPC: fli_Weight;                 fldAS: 'OWEIGT'; fldType: TLD_float),
    (fldPC: fli_DescUM;                 fldAS: 'OWEIUM'; fldType: TLD_string),
    (fldPC: fli_CalCod;                 fldAS: 'OCDCAL'; fldType: TLD_string),
    (fldPC: fli_SetupTimStep;           fldAS: 'OTOTST'; fldType: TLD_float),
    (fldPC: fli_excTimeStep;            fldAS: 'OTOTET'; fldType: TLD_float),
    (fldPC: fli_NumResPlan;             fldAS: 'ONURSC'; fldType: TLD_float),
    (fldPC: fli_AllowSplit;             fldAS: 'OFLSPL'; fldType: TLD_string),
    (fldPC: fli_StepHandleReProc;       fldAS: 'OFLRPR'; fldType: TLD_string),
    (fldPC: fli_StepPartGenralPlan;     fldAS: 'OGENPL'; fldType: TLD_string),
    (fldPC: fli_StepCanGroup;           fldAS: 'OFLGRP'; fldType: TLD_string),
    (fldPC: fli_ForcedGroupNo;          fldAS: 'OSTPGR'; fldType: TLD_float),
    (fldPC: fli_ConnTypToPrevStepSplit; fldAS: 'OCNTYP'; fldType: TLD_string),
    (fldPC: fli_FrcOverlapp;            fldAS: 'OFRNOL'; fldType: TLD_string),
    (fldPC: fli_StepClosed;             fldAS: 'OSTCLO'; fldType: TLD_string),
    (fldPC: fli_usrCg;                  fldAS: 'OUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;                fldAS: 'ODTOCH'; fldType: TLD_dateTime),
    (fldPC: fli_SchedulByMcm;           fldAS: 'OSCMCM'; fldType: TLD_string),
    (fldPC: fli_SplitFamaly;            fldAS: ''; fldType: TLD_string),
    (fldPC: fli_LearningCurveCode;      fldAS: 'OLRNCV'; fldType: TLD_string),
    (fldPC: fli_LearningCurveType;      fldAS: 'OLRNTP'; fldType: TLD_string),
    (fldPC: fli_OverlapWithOtherSteps;  fldAS: '';       fldType: TLD_string),
    (fldPC: fli_ApprovalDate;            fldAS: 'OAPPDT'; fldType: TLD_dateTime),
    (fldPC: fli_GrpContinueSeq;          fldAS: 'OGRSEQ'; fldType: TLD_string),
    (fldPC: fli_PrevLeadTime_Mqm;        fldAS: ''; fldType: TLD_Float),
    (fldPC: fli_NextLeadTime_Mqm;        fldAS: ''; fldType: TLD_Float),
    (fldPC: fli_PrevLeadTimeBatch_Mqm;   fldAS: ''; fldType: TLD_Float),
    (fldPC: fli_NextLeadTimeBatch_Mqm;   fldAS: ''; fldType: TLD_Float),
   	(fldPC: fli_MinBatchSize;            fldAS: 'OMINBQ'; fldType: TLD_Float),
    (fldPC: fli_OptimumBatchSize;        fldAS: 'OOPTBQ'; fldType: TLD_Float),
    (fldPC: fli_MaxBatchSize;            fldAS: 'OMAXBQ'; fldType: TLD_Float),
    (fldPC: fli_BatchSizePerStep;        fldAS: 'OBQTJB'; fldType: TLD_string),
    (fldPC: fli_SchedulByMqm;            fldAS: ''; fldType: TLD_string),
    (fldPC: fli_prevStepSched_Mcm;       fldAS: ''; fldType: TLD_Float),
    (fldPC: fli_NextStepSched_Mcm;       fldAS: ''; fldType: TLD_Float),
   	(fldPC: fli_PrevLeadTime_Mcm;        fldAS: ''; fldType: TLD_Float),
    (fldPC: fli_NextLeadTime_Mcm;        fldAS: ''; fldType: TLD_Float),
    (fldPC: fli_PrevLeadTimeBatch_Mcm;   fldAS: ''; fldType: TLD_Float),
    (fldPC: fli_NextLeadTimeBatch_Mcm;   fldAS: ''; fldType: TLD_string),
    (fldPC: fli_InitialPlanScheduledDateTime;  fldAS: ''; fldType: TLD_dateTime),
    (fldPC: fli_FinalPlanScheduledDateTime;    fldAS: ''; fldType: TLD_dateTime),
    (fldPC: fli_NumSubRscComponents;    fldAS: ''; fldType: TLD_integer),
    (fldPC: fli_MaxStartDateAutoSeq;   fldAS: 'OMSDAS'; fldType: TLD_dateTime)
  );

  fldListPP: array [0..6] of TQryLinkRec = (
    (fldPC: fli_preqNo;       fldAS: 'LPRREQ'; fldType: TLD_string),
    (fldPC: fli_pstepId;      fldAS: 'LPRSTP'; fldType: TLD_integer),
    (fldPC: fli_rsc;          fldAS: 'LPRRSC'; fldType: TLD_string),
    (fldPC: fli_PropertyCode; fldAS: 'LCDPPT'; fldType: TLD_string),
    (fldPC: fli_PropValue;    fldAS: 'LPPTVL'; fldType: TLD_string),
    (fldPC: fli_usrCg;        fldAS: 'LUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;      fldAS: 'LDTOCH'; fldType: TLD_DateTime)
  );

  fldListPI: array [0..6] of TQryLinkRec = (
    (fldPC: fli_preqNo;      fldAS: 'NPRREQ'; fldType: TLD_string),
    (fldPC: fli_pstepId;     fldAS: 'NPRSTP'; fldType: TLD_integer),
    (fldPC: fli_infoType;    fldAS: 'NINFTY'; fldType: TLD_string),
    (fldPC: fli_infoLineNum; fldAS: 'NINFLN'; fldType: TLD_integer),
    (fldPC: fli_InfoArea;    fldAS: 'NINFAR'; fldType: TLD_string),
    (fldPC: fli_usrCg;       fldAS: 'NUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;     fldAS: 'NDTOCH'; fldType: TLD_dateTime)
  );

  fldListEC: array [0..5] of TQryLinkRec = (
    (fldPC: fli_preqNo;            fldAS: 'ZPRREQ'; fldType: TLD_string),
    (fldPC: fli_ConnKey;           fldAS: 'ZCNKEY'; fldType: TLD_string),
    (fldPC: fli_NumOfLevel;        fldAS: 'ZNBRLV'; fldType: TLD_integer),
    (fldPC: fli_ConnCertentyLevel; fldAS: 'ZCNCER'; fldType: TLD_string),
    (fldPC: fli_usrCg;             fldAS: 'ZUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;           fldAS: 'ZDTOCH'; fldType: TLD_dateTime)
  );

  fldListIC: array [0..3] of TQryLinkRec = (
    (fldPC: fli_preqNo;              fldAS: 'CPRREQ'; fldType: TLD_string),
    (fldPC: fli_PrevProdNum;         fldAS: 'CPRPRD'; fldType: TLD_string),
    (fldPC: fli_usrCg;               fldAS: 'CUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;             fldAS: 'CDTOCH'; fldType: TLD_dateTime)
  );

  fldListSB: array [0..3] of TQryLinkRec = (
    (fldPC: fli_preqNo;              fldAS: 'JPRREQ'; fldType: TLD_string),
    (fldPC: fli_pstepId;             fldAS: 'JPRSTP'; fldType: TLD_integer),
    (fldPC: fli_BchUM;               fldAS: 'JBSZUM'; fldType: TLD_string),
    (fldPC: fli_multipToBatchUm;     fldAS: 'JBTCML'; fldType: TLD_float)
  );

  fldListSP : array [0..19] of TQryLinkRec = (
    (fldPC: fli_preqNo;           fldAS: 'SPRREQ'; fldType: TLD_string),
    (fldPC: fli_pstepId;          fldAS: 'SPRSTP'; fldType: TLD_integer),
    (fldPC: fli_psubstId;         fldAS: 'SPRSST'; fldType: TLD_integer),
    (fldPC: fli_reprocNo;         fldAS: 'SRPRNB'; fldType: TLD_integer),
    (fldPC: fli_ProgressType;     fldAS: 'SLPRTY'; fldType: TLD_string),
    (fldPC: fli_rsc;              fldAS: 'SCDRSC'; fldType: TLD_string),
    (fldPC: fli_ProgressGroup;    fldAS: 'SPRGRP'; fldType: TLD_integer),
    (fldPC: fli_progrStart;       fldAS: 'SSTRDT'; fldType: TLD_dateTime),
    (fldPC: fli_prgCurrDate;      fldAS: 'SCURDT'; fldType: TLD_dateTime),
    (fldPC: fli_progrEnd;         fldAS: 'SENDDT'; fldType: TLD_dateTime),
    (fldPC: fli_quant;            fldAS: 'SPRQTY'; fldType: TLD_float),
    (fldPC: fli_StartingQty;      fldAS: '';       fldType: TLD_float),
    (fldPC: fli_prgRemTime;       fldAS: 'SRMNTM'; fldType: TLD_float),
    (fldPC: fli_ProgressTypeHost; fldAS: 'SLPRTY'; fldType: TLD_string),
    (fldPC: fli_rscHost;          fldAS: 'SCDRSC'; fldType: TLD_string),
    (fldPC: fli_progrStartHost;   fldAS: 'SSTRDT'; fldType: TLD_dateTime),
    (fldPC: fli_prgCurrDateHost;  fldAS: 'SCURDT'; fldType: TLD_dateTime),
    (fldPC: fli_progrEndHost;     fldAS: 'SENDDT'; fldType: TLD_dateTime),
    (fldPC: fli_quantHost;        fldAS: 'SPRQTY'; fldType: TLD_float),
    (fldPC: fli_prgRemTimeHost;   fldAS: 'SRMNTM'; fldType: TLD_float)
  );

  fldListST: array [0..8] of TQryLinkRec = (
    (fldPC: fli_preqNo;           fldAS: 'QPRREQ'; fldType: TLD_string),
    (fldPC: fli_pstepId;          fldAS: 'QPRSTP'; fldType: TLD_integer),
    (fldPC: fli_wkCtrCode;        fldAS: 'QCDMAC'; fldType: TLD_string),
    (fldPC: fli_wkcProc;          fldAS: 'QCDMAP'; fldType: TLD_string),
    (fldPC: fli_rscCat;           fldAS: 'QCATRS'; fldType: TLD_string),
    (fldPC: fli_rsc;              fldAS: 'QCDRSC'; fldType: TLD_string),
    (fldPC: fli_MachSetupCode;    fldAS: 'QSETCD'; fldType: TLD_string),
    (fldPC: fli_SetUpTimJob;      fldAS: 'QSETTM'; fldType: TLD_float),
    (fldPC: fli_ExecTimeInitQty;  fldAS: 'QEXCTM'; fldType: TLD_float)
  );

  fldListMT: array [0..19] of TQryLinkRec = (
    (fldPC: fli_preqNo;              fldAS: 'HPRREQ'; fldType: TLD_string),
    (fldPC: fli_pstepId;             fldAS: 'HTGSTP'; fldType: TLD_Integer),
    (fldPC: fli_orgStep;             fldAS: 'HPRSTP'; fldType: TLD_integer),
    (fldPC: fli_wkCtrCode;           fldAS: 'HCDMAC'; fldType: TLD_string),
    (fldPC: fli_ResCatcode;          fldAS: 'HCATRS'; fldType: TLD_string),
    (fldPC: fli_rsc;                 fldAS: 'HCDRSC'; fldType: TLD_string),
    (fldPC: fli_MachSetupCode;       fldAS: 'HSETCD'; fldType: TLD_string),
    (fldPC: fli_AlternativCode;      fldAS: 'HALTCD'; fldType: TLD_string),
    (fldPC: fli_prodtype;            fldAS: 'HRECTY'; fldType: TLD_string),
    (fldPC: fli_ProdCode;            fldAS: 'HPRDCD'; fldType: TLD_string),
    (fldPC: fli_netGroupCode;        fldAS: 'HNETCD'; fldType: TLD_string),
    (fldPC: fli_issueCode;           fldAS: 'HISSCD'; fldType: TLD_string),
    (fldPC: fli_seqIssued;           fldAS: 'HSEQNC'; fldType: TLD_string),
    (fldPC: fli_MatBalance;          fldAS: 'HMATBL'; fldType: TLD_string),
    (fldPC: fli_AllocQty;            fldAS: 'HALCQT'; fldType: TLD_float),
    (fldPC: fli_highDateAlloc;       fldAS: 'HDTMAX'; fldType: TLD_dateTime),
    (fldPC: fli_SearchMatByAlloc;    fldAS: 'HFLALC'; fldType: TLD_string),
    (fldPC: fli_settled;             fldAS: 'HFLSAL'; fldType: TLD_string),
    (fldPC: fli_quantityIssue;       fldAS: 'HISSQT'; fldType: TLD_float),
    (fldPC: fli_reqQuant;            fldAS: 'HREQQT'; fldType: TLD_float)
  );

  fldListPA: array [0..10] of TQryLinkRec = (
    (fldPC: fli_preqNo;              fldAS: 'APRREQ'; fldType: TLD_string),
    (fldPC: fli_sequenceChar;        fldAS: 'ASEQNC'; fldType: TLD_string),
    (fldPC: fli_ProdCode;            fldAS: 'APRDCD'; fldType: TLD_string),
    (fldPC: fli_netGroupCode;        fldAS: 'ANETCD'; fldType: TLD_string),
    (fldPC: fli_AllocReq;            fldAS: 'AALCRQ'; fldType: TLD_string),
    (fldPC: fli_Prod_Balance;        fldAS: 'APRDBL'; fldType: TLD_string),
    (fldPC: fli_Rsc;                 fldAS: 'ACDRSC'; fldType: TLD_string),
    (fldPC: fli_settled;             fldAS: 'AFLSAL'; fldType: TLD_string),
    (fldPC: fli_reqQuant;            fldAS: 'AREQQT'; fldType: TLD_float),
    (fldPC: fli_qtyProduced;         fldAS: 'APRDQT'; fldType: TLD_float),
    (fldPC: fli_AllocQty;            fldAS: 'AALCQT'; fldType: TLD_float)
   );

//----------------------------------------------------------------------------//

function LoadSrvTableCompar(tbl: table; Condition, OrderBy: string;
                   srvQry: TMqmQuery; SelectColumns: string = '*'): boolean;
var
  tbInfo:         ^TTblInfo;
  linkList:       TList;
  sl:             TStringList;
  GeneralSQL : string;
begin
  tbInfo := @tblInfo[tbl];

  linkList := nil;
  Result := true;

//  try
    // select the data from P.c server
      with srvQry do
      begin
        SQL.Clear;
        GeneralSQL := '';
        GeneralSQL := 'Select ' + SelectColumns + ' from ' + tbInfo.GetTableName;
        if Condition <> '' then
          GeneralSQL := GeneralSQL + Condition;
        if OrderBy <> '' then
          GeneralSQL := GeneralSQL + OrderBy;
        SQL.add(GeneralSQL);
        FetchOptions.RowsetSize := 5000;
        Application.ProcessMessages;
        Open
      end;

{  except
    on E: Exception do
      begin
        sl := TStringList.Create;
        sl.Add('while loading ' + tbInfo.GetTableName);
        sl.Add(E.Message);
        UpdateError(sl);
        sl.Free;
        if Assigned(linkList) then linkList.Free;
        Result := false
      end
  end;  }

end;

//----------------------------------------------------------------------------//

function LoadSrvTable(tbl: table; Condition, OrderBy: string;
                   linkArr: array of TQryLinkRec;
                   srvQry: TMqmQuery ; Srv_ProdRq : string): boolean;
var
  tbInfo:         ^TTblInfo;
  linkList:       TList;
  sl:             TStringList;
  GeneralSQL :    string;
  tbProdReqHeadr: ^TTblInfo;
begin
{  tbInfo := @tblInfo[tbl];

  tbProdReqHeadr := @tblInfo[tbl_prod_reqHdr];
  linkList := nil;
  Result := true;

//  select prop_prod.* from prop_prod inner join prod_reqHdr on PH_UPD_CODE = 0 and ph_preq_No = pp_preq_no

//  try
    // select the data from P.c server
      with srvQry do
      begin
        SQL.Clear;
        GeneralSQL := '';
        if tbInfo.GetTableName <> tbProdReqHeadr.GetTableName then
        begin
          GeneralSQL := 'Select ' + tbInfo.GetTableName + '.* ' + ' From ' +  tbInfo.GetTableName;
          GeneralSQL := GeneralSQL + ' inner join ' + tbProdReqHeadr.GetTableName + ' On ' + CreateFld(tbProdReqHeadr.pfx, fli_updCode) + '=' + IntToStr(1);
          GeneralSQL := GeneralSQL + ' AND ' + CreateFld(tbProdReqHeadr.pfx, fli_preqNo) + ' = ' + CreateFld(tbInfo.pfx, fli_preqNo);
        end
        else
        begin
          GeneralSQL := 'Select * From ' +  tbInfo.GetTableName;
          GeneralSQL := GeneralSQL + ' where ' + CreateFld(tbInfo.pfx, fli_updCode) + '=' + IntToStr(1);
        end;

        if condition <> '' then
            GeneralSQL := GeneralSQL + condition;
        if OrderBy <> '' then
          GeneralSQL := GeneralSQL + OrderBy;
        SQL.Add(GeneralSQL);

        Application.ProcessMessages;
        Open
      end;

  {except
    on E: Exception do
      begin
        sl := TStringList.Create;
        sl.Add('while loading ' + tbInfo.GetTableName);
        sl.Add(E.Message);
        UpdateError(sl);
        sl.Free;
        if Assigned(linkList) then linkList.Free;
        Result := false
      end
  end; }

end;

//----------------------------------------------------------------------------//

function LoadTable(tbl: table; ASLib, AScondition, PCCondition, OrderCondition : string;
                   linkArr: array of TQryLinkRec;
                   HostQry: TMqmQuery ; AS_ProdRq : string; PC_ProdRq : string): boolean;
var
  tbInfo:         ^TTblInfo;
  tblName:        string;
  linkList:       TList;
  Str:            string;
  sl:             TStringList;
  GeneralSQL:     String;
  DndArchiveHostName : TDndArchiveName;
  I : integer;
begin
  tbInfo := @tblInfo[tbl];

  linkList := nil;
  Result := true;

  DndArchiveHostName := GetDndArchiveHostName;

  if DndArchiveHostName = TD_AS_400 then
  begin
    UpdateOperation(_('Reading') + '  ' + tbInfo.ASname + '  ' + (_('from host . . .')));
    tblName  := ASLib + tbInfo.ASname;
  end
  else
  begin
    UpdateOperation(_('Reading') + '  ' + tbInfo.GetTableName + '  ' + (_('from host . . .')));
    tblName  := ASLib + tbInfo.GetTableName;
  end;

//  try
    // select the data from AS400
      with HostQry do
      begin
        SQL.Clear;

        if DndArchiveHostName = TD_AS_400 then
        begin

          if (not GetLoopMqmCG) then
          begin
            GeneralSQL := '';

            // Select only the columns we need — reduces WAN data transfer
            GeneralSQL := ' Select ';
            for i := 0 to High(linkArr)-1 do
              GeneralSQL := GeneralSQL + linkArr[i].fldAS + ',';
            GeneralSQL := GeneralSQL + linkArr[High(linkArr)].fldAS + ' from ' + tblName;

            if AScondition <> '' then
              GeneralSQL := GeneralSQL + AScondition;
            if OrderCondition <> '' then
              GeneralSQL := GeneralSQL + OrderCondition;
            Application.ProcessMessages;
            SQL.Add(GeneralSQL);
            Open
          end
          else
          begin
            GeneralSQL := '';
            GeneralSQL := 'select * from MQMCG00f,' + tblName;
            Str := tblName + '.' + AS_ProdRq;
            GeneralSQL := GeneralSQL + ' where MQMCG00f.JPRREQ ' + '= ' + Str;
            if AScondition <> '' then
            begin
            //  if tblName = 'MQMPR00F' then
                GeneralSQL := GeneralSQL + AScondition;
            end;

            if OrderCondition <> '' then
              GeneralSQL := GeneralSQL + OrderCondition;
            Application.ProcessMessages;
            SQL.Add(GeneralSQL);
            Open
          end

        end
        else
        begin

          if (not GetLoopMqmCG) then
          begin
            GeneralSQL := '';
            GeneralSQL := ' Select * from ' +  tblName;

            if Get_DownloadFamilyFromNow then
            begin
              if tblName <> 'PROD_REQ' then

                GeneralSQL := GeneralSQL + ' join Prod_req on ' +
                                         CreateFld(tbInfo.pfx, fli_preqNo) + ' = ' +
                                         ' Prod_req.pr_preq_no and Prod_req.Pr_Isfamily = ' + QuotedStr('1')
              else
                GeneralSQL := GeneralSQL + ' where Pr_Isfamily = ' + QuotedStr('1');
            end;

         //   for i := 0 to High(linkArr)-1 do
         //     GeneralSQL := GeneralSQL + CreateFld(tbInfo.pfx, linkArr[i].fldPc) + ',';
        //    GeneralSQL := GeneralSQL + CreateFld(tbInfo.pfx, linkArr[High(linkArr)].fldPC) + ' from ' + tblName;
            if PCcondition <> '' then
              GeneralSQL := GeneralSQL + PCcondition;
            if OrderCondition <> '' then
              GeneralSQL := GeneralSQL + OrderCondition;
            Application.ProcessMessages;
            SQL.Add(GeneralSQL);
            Open
          end
          else
          begin
            // not in use right now ...
            GeneralSQL := '';
            GeneralSQL := 'select * from MQMCG00f,' + tblName;
            Str := tblName + '.' + PC_ProdRq;
            GeneralSQL := GeneralSQL + ' where MQMCG00f.JPRREQ ' + '= ' + Str;
            if PCcondition <> '' then
            begin
             // if tblName = 'PROD_REQ' then
                GeneralSQL := GeneralSQL + PCcondition;
            end;
            if OrderCondition <> '' then
              GeneralSQL := GeneralSQL + OrderCondition;
            Application.ProcessMessages;
            SQL.Add(GeneralSQL);
            Open
          end
        end;

      end;

  {except
    on E: Exception do
      begin
        sl := TStringList.Create;
        sl.Add('while loading ' + tbInfo.GetTableName);
        sl.Add(E.Message);
        UpdateError(sl);
        sl.Free;
        if Assigned(linkList) then linkList.Free;
        Result := false;
        raise;
      end
  end; }

end;

//----------------------------------------------------------------------------//

function InsertTable(tbl: table; linkArr: array of TQryLinkRec; srvQry: TMqmQuery) : boolean;
var
  tbInfo:         ^TTblInfo;
  I : Integer;
  sl : TStringList;
  GenSql : string;
  DndArchiveLocalName : TDndArchiveName;
begin
  Result := true;
  tbInfo := @tblInfo[tbl];
  DndArchiveLocalName := GetDndArchiveLocalName;

  with srvQry do
  begin
//    if DndArchiveLocalName <> TD_AS_400 then
//    begin

    GenSql := '';
    GenSql := GenSql + ' insert into ' + tbInfo.GetTableName + ' (';
    for i := 0 to High(linkArr)-1 do
      GenSql := GenSql + '"' + CreateFld(tbInfo.pfx, linkArr[i].fldPC) + '"' + ',';
    GenSql := GenSql + '"' + CreateFld(tbInfo.pfx, linkArr[High(linkArr)].fldPC) + '"';
    GenSql := GenSql + ') values (';
    SQL.Clear;
    Sql.Add(GenSql);


  {  for i := 0 to High(linkArr)-1 do
      GenSql := GenSql + ':' + '"' + CreateFld(tbInfo.pfx, linkArr[i].fldPC) + '"' + ',';
    GenSql := GenSql + ':' + '"' +CreateFld(tbInfo.pfx, linkArr[High(linkArr)].fldPC) + '"' + ')';
    SQL.Clear;
    Sql.Add(GenSql);
    Application.ProcessMessages;  }

   // exit;
  end;

 {     GenSql := '';
      GenSql := GenSql + ' insert into ' + tbInfo.GetTableName + ' (';
      for i := 0 to High(linkArr)-1 do
        GenSql := GenSql + '"' + CreateFld(tbInfo.pfx, linkArr[i].fldPC) + '"' + ',';
      GenSql := GenSql + '"' + CreateFld(tbInfo.pfx, linkArr[High(linkArr)].fldPC) + '"';
      GenSql := GenSql + ') values (';
    end
    else
    begin
      GenSql := '';
      GenSql := GenSql + ' insert into ' + tbInfo.GetTableName + ' (';
      for i := 0 to High(linkArr)-1 do
        GenSql := GenSql + CreateFld(tbInfo.pfx, linkArr[i].fldPC) + ',';
      GenSql := GenSql + CreateFld(tbInfo.pfx, linkArr[High(linkArr)].fldPC);
      GenSql := GenSql + ') values (';
      for i := 0 to High(linkArr)-1 do
        GenSql := GenSql + ':' + CreateFld(tbInfo.pfx, linkArr[i].fldPC) + ',';
      GenSql := GenSql + ':' + CreateFld(tbInfo.pfx, linkArr[High(linkArr)].fldPC) + ')';
      SQL.Clear;
      Sql.Add(GenSql);
      Application.ProcessMessages;
    end;
  end;    }

end;

//----------------------------------------------------------------------------//

procedure CreateProdContMemory;
begin
  if not assigned(m_ProdCont) then
    m_ProdCont := TProdCont.Create;
  m_ProdCont.m_StartDownloadDateTime := now;
  m_ProdCont.GetPropFromTable;
  m_ProdCont.updateExeMinProdSched
end;

//----------------------------------------------------------------------------//

procedure CheckChangeReq(HostQry : TMqmQuery);
begin
  m_ProdCont.CheckChangeReq(HostQry);
end;

//----------------------------------------------------------------------------//
function InsertReqListToDataBase(var GotAccess : boolean) : boolean;
begin
  Result := m_ProdCont.InsertReqListToDataBase(GotAccess);
end;

//----------------------------------------------------------------------------//

function InsertCapResListToDataBase : boolean;
begin
  Result := m_ProdCont.InsertCapResListToDataBase
end;

//----------------------------------------------------------------------------//

procedure ClearMemoryList;
begin
  m_ProdCont.ClearMemoryList;
end;

//----------------------------------------------------------------------------//

procedure CopyProdSchedToProdSchedMcm(var srvTrs: TMqmTransaction);
begin
  m_ProdCont.CopyProdSchedToProdSchedMcm(srvTrs);
end;

//----------------------------------------------------------------------------//

procedure SetPDThreadList(ThreadPDList : TList);
begin
  m_ProdCont.SetPDThreadList(ThreadPDList);;
end;

//----------------------------------------------------------------------------//

function GetReqListCount : Integer;
begin
  Result := m_ProdCont.m_Req_Change_List.Count;
end;

//----------------------------------------------------------------------------//

function GetCapResListCount : Integer;
begin
  Result := 0;
  if Assigned(m_ProdCont.m_Cap_Res_Changed_list) then
    Result := m_ProdCont.m_Cap_Res_Changed_list.Count
end;

//----------------------------------------------------------------------------//

{procedure Check_FamilyStructureInNow;
var
  DndArchiveName : TDndArchiveName;
  HostQry :  TMqmQuery;
  HostSql : string;
begin
  DndArchiveName := GetDndArchiveName;
  if DndArchiveName = TD_PC_MqmDfn then
  begin
    HostQry := CreateHostQuery;
    HostSql := ' select PR_ISFAMILY from PROD_REQ where PR_ISFAMILY = ' + QuotedStr('1');
    HostQry.SQL.Text := HostSql;
    try
      HostQry.Open;
    except
    end;
    if HostQry.Eof then
      Set_DownloadFamilyFromNow(false)
    else
      Set_DownloadFamilyFromNow(true);
    HostQry.Close;
    HostQry.Free;
  end;

end;}

//----------------------------------------------------------------------------//

function Get_DownloadFamilyFromNow : boolean;
begin
  Result := m_ProdCont.m_DownloadFamilyFromNow
end;

//----------------------------------------------------------------------------//

procedure Set_DownloadFamilyFromNow(Flag : boolean);
begin
  m_ProdCont.m_DownloadFamilyFromNow := Flag
end;

//----------------------------------------------------------------------------//

function AddProdRq(tbl : table; srvQry: TMqmQuery; HostQry : TMqmQuery ; IsHostQry : boolean; IsInsert : boolean): boolean;
var
  RecMQMPR : PTMQMPR;
  tbProdReq:         ^TTblInfo;
  OrderBy : string;
  DateTimeFormat : TDateTimeFormat;
  DndArchiveHostName : TDndArchiveName;
  ASCondition, PCCondition : string;
  // Pre-cached TField references for AS400 path
  fldPR_0, fldPR_1, fldPR_2, fldPR_3, fldPR_4, fldPR_5, fldPR_6, fldPR_7 : TField;
begin
  Assert(tbl = tbl_prod_req);
  tbProdReq := @tblInfo[tbl];
  DndArchiveHostName := GetDndArchiveHostName;

  if DndArchiveHostName = TD_AS_400 then
  begin
    if GetLoopMqmCG then
      ASCondition := ' and KHSTRQ' + CHistorical
    else
      ASCondition := ' where KHSTRQ' + CHistorical;
  end;

  if IsInsert then
  begin
    Result := InsertTable(tbl,fldListPR,srvQry);
  end

  else if IsHostQry then
  begin
    if (Trim(IniAppGlobals.PreparationExeName) = '') then
    begin
      DateTimeFormat := GetDateTimeFormat;
  //    OrderBy := ' Order by KPRREQ';
      OrderBy := '';
      Result := LoadTable(tbl, AS400Speclib,ASCondition,PCCondition ,
                OrderBy, fldListPR, HostQry, 'KPRREQ', CreateFld(tbProdReq.pfx, fli_preqNo));
      if DndArchiveHostName = TD_AS_400 then
      begin
        fldPR_0 := HostQry.FieldByName(fldListPR[0].fldAS);
        fldPR_1 := HostQry.FieldByName(fldListPR[1].fldAS);
        fldPR_2 := HostQry.FieldByName(fldListPR[2].fldAS);
        fldPR_3 := HostQry.FieldByName(fldListPR[3].fldAS);
        fldPR_4 := HostQry.FieldByName(fldListPR[4].fldAS);
        fldPR_5 := HostQry.FieldByName(fldListPR[5].fldAS);
        fldPR_6 := HostQry.FieldByName(fldListPR[6].fldAS);
        fldPR_7 := HostQry.FieldByName(fldListPR[7].fldAS);
      end;
      while not HostQry.Eof do
      begin
        if (m_ProdCont.m_HostListPR.Count mod 500 = 0) then Application.ProcessMessages;
        New(RecMQMPR);
        RecMQMPR.PR_ModulHandled := '';
        if DndArchiveHostName = TD_AS_400 then
        begin
          RecMQMPR.PR_DIV_CODE  := Trim(fldPR_0.AsString);
          RecMQMPR.PR_DSP_CODE  := Trim(fldPR_1.AsString);
          RecMQMPR.PR_BCH_CODE  := Trim(fldPR_2.AsString);
          RecMQMPR.PR_REPROC_NO := fldPR_3.AsInteger;
          RecMQMPR.PR_PREQ_NO   := Trim(fldPR_4.AsString);
          RecMQMPR.PR_HISTORICAL_REQ := Trim(fldPR_5.AsString);
          RecMQMPR.PR_USR_CG         := Trim(fldPR_6.AsString);
          if (DateTimeFormat = Frm_As400) then
            RecMQMPR.PR_USR_TM_CG := TimDateTimeToDateTime(fldPR_7.AsFloat)
          else if (DateTimeFormat = Frm_TDateTimeExceptControl) or (DateTimeFormat = Frm_TDateTime) then
            RecMQMPR.PR_USR_TM_CG := fldPR_7.AsDateTime;
          RecMQMPR.PR_ModulHandled := '';//Trim(HostQry.FieldByName(fldListPR[8].fldAS).AsString);
        end
        else
        begin
          RecMQMPR.PR_DIV_CODE  := Trim(HostQry.FieldByName(CreateFld(tbProdReq.pfx, fldListPR[0].fldPC)).AsString);
          RecMQMPR.PR_DSP_CODE  := Trim(HostQry.FieldByName(CreateFld(tbProdReq.pfx, fldListPR[1].fldPC)).AsString);
          RecMQMPR.PR_BCH_CODE  := Trim(HostQry.FieldByName(CreateFld(tbProdReq.pfx, fldListPR[2].fldPC)).AsString);
          RecMQMPR.PR_REPROC_NO := HostQry.FieldByName(CreateFld(tbProdReq.pfx, fldListPR[3].fldPC)).AsInteger;
          RecMQMPR.PR_PREQ_NO   := Trim(HostQry.FieldByName(CreateFld(tbProdReq.pfx, fldListPR[4].fldPC)).AsString);
          RecMQMPR.PR_HISTORICAL_REQ := Trim(HostQry.FieldByName(CreateFld(tbProdReq.pfx, fldListPR[5].fldPC)).AsString);
          RecMQMPR.PR_USR_CG         := Trim(HostQry.FieldByName(CreateFld(tbProdReq.pfx, fldListPR[6].fldPC)).AsString);
          RecMQMPR.PR_USR_TM_CG := HostQry.FieldByName(CreateFld(tbProdReq.pfx, fldListPR[7].fldPC)).AsDateTime;
          RecMQMPR.PR_ModulHandled := '';//Trim(HostQry.FieldByName(CreateFld(tbProdReq.pfx, fldListPR[8].fldPC)).AsString);
        end;
        m_ProdCont.m_HostListPR.add(RecMQMPR);
        HostQry.Next;
      end;
      HostQry.Close;
      m_ProdCont.m_HostListPR.Sort(SortPR);
    end
    else
    begin
      UpdateOperation(_('Get prod_req list') + ' ' + (_('from host . . .')));
      m_ProdCont.m_HostListPR := Get_Host_prod_req_list;
      m_ProdCont.m_HostListPR.Sort(SortPR);
      Result := true
    end;
  end
  else
  begin
    OrderBy := ' Order by ' + CreateFld(tbProdReq.pfx, fli_preqNo);
    Result :=  LoadSrvTable(tbl,'', OrderBy, fldListPR, srvQry, '');
  end;
end;

//----------------------------------------------------------------------------//

function AddProdRqHeader(tbl : table; srvQry: TMqmQuery; HostQry : TMqmQuery; IsHostQry : boolean ;IsInsert : boolean): boolean;
var
  RecMQMPH : PTMQMPH;
  tbProdReqHeadr:         ^TTblInfo;
  OrderBy : string;
  DateTimeFormat : TDateTimeFormat;
  DndArchiveHostName : TDndArchiveName;
  // Pre-cached TField references for AS400 path
  fldPH_0,  fldPH_1,  fldPH_2,  fldPH_3,  fldPH_4,  fldPH_5,  fldPH_6,
  fldPH_7,  fldPH_8,  fldPH_9,  fldPH_10, fldPH_11, fldPH_12, fldPH_13 : TField;
  // Optional fields (may not exist in all AS400 schemas)
  fldPH_14, fldPH_15, fldPH_16, fldPH_17, fldPH_18 : TField;
begin
  Assert(tbl = tbl_prod_reqHdr);
  tbProdReqHeadr := @tblInfo[tbl];
  DndArchiveHostName := GetDndArchiveHostName;

  if IsInsert then
  begin
    Result := InsertTable(tbl,fldListPH,srvQry);
  end

  else if IsHostQry then
  begin
    if (Trim(IniAppGlobals.PreparationExeName) = '') then
    begin
      DateTimeFormat := GetDateTimeFormat;
      OrderBy := '';
      Result := LoadTable(tbl, AS400Speclib,'','',OrderBy, fldListPH, HostQry,'MPRREQ',CreateFld(tbProdReqHeadr.pfx, fli_preqNo));
      if DndArchiveHostName = TD_AS_400 then
      begin
        fldPH_0  := HostQry.FieldByName(fldListPH[0].fldAS);
        fldPH_1  := HostQry.FieldByName(fldListPH[1].fldAS);
        fldPH_2  := HostQry.FieldByName(fldListPH[2].fldAS);
        fldPH_3  := HostQry.FieldByName(fldListPH[3].fldAS);
        fldPH_4  := HostQry.FieldByName(fldListPH[4].fldAS);
        fldPH_5  := HostQry.FieldByName(fldListPH[5].fldAS);
        fldPH_6  := HostQry.FieldByName(fldListPH[6].fldAS);
        fldPH_7  := HostQry.FieldByName(fldListPH[7].fldAS);
        fldPH_8  := HostQry.FieldByName(fldListPH[8].fldAS);
        fldPH_9  := HostQry.FieldByName(fldListPH[9].fldAS);
        fldPH_10 := HostQry.FieldByName(fldListPH[10].fldAS);
        fldPH_11 := HostQry.FieldByName(fldListPH[11].fldAS);
        fldPH_12 := HostQry.FieldByName(fldListPH[12].fldAS);
        fldPH_13 := HostQry.FieldByName(fldListPH[13].fldAS);
        fldPH_14 := nil; try fldPH_14 := HostQry.FieldByName(fldListPH[14].fldAS); except end;
        fldPH_15 := nil; try fldPH_15 := HostQry.FieldByName(fldListPH[15].fldAS); except end;
        fldPH_16 := nil; try fldPH_16 := HostQry.FieldByName(fldListPH[16].fldAS); except end;
        fldPH_17 := nil; try fldPH_17 := HostQry.FieldByName(fldListPH[17].fldAS); except end;
        fldPH_18 := nil; try fldPH_18 := HostQry.FieldByName(fldListPH[18].fldAS); except end;
      end;
      while not HostQry.Eof do
      begin
        if (m_ProdCont.m_HostListPH.Count mod 500 = 0) then Application.ProcessMessages;
        New(RecMQMPH);
        RecMQMPH.PH_ModulHandled := '';
        RecMQMPH.PH_SPLITCONFLEVELS := '';
        RecMQMPH.PH_LEAD_STEP_SPLITED := 0;
        RecMQMPH.PH_MQM_SPLIT_ID := '';
        RecMQMPH.PH_Serving_Code := '';
        RecMQMPH.PH_Served_Code  := '';
        RecMQMPH.PH_Curve_Family_Id_Code := '';

        if DndArchiveHostName = TD_AS_400 then
        begin
          RecMQMPH.PH_PREQ_NO        := Trim(fldPH_0.AsString);
          RecMQMPH.PH_HISTORICAL_REQ := Trim(fldPH_1.AsString);
          RecMQMPH.PH_REQ_ORIGIN     := Trim(fldPH_2.AsString);
          RecMQMPH.PH_PROD_LINE      := Trim(fldPH_3.AsString);
          RecMQMPH.PH_TYPE_PROD      := Trim(fldPH_4.AsString);
          RecMQMPH.PH_PROD_FAMILY    := Trim(fldPH_5.AsString);
          RecMQMPH.PH_MATERIAL_FAMILY := Trim(fldPH_6.AsString);
          RecMQMPH.PH_PROD_UM         := Trim(fldPH_7.AsString);
          if (DateTimeFormat = Frm_As400) then
          begin
            RecMQMPH.PH_PROD_LOW_TIME_STRT := TimDateTimeToDateTime(fldPH_8.AsFloat);
            RecMQMPH.PH_PROD_DELIVY_DATE := TimDateTimeToDateTime(fldPH_9.AsFloat);
          end
          else if (DateTimeFormat = Frm_TDateTimeExceptControl) or (DateTimeFormat = Frm_TDateTime) then
          begin
            RecMQMPH.PH_PROD_LOW_TIME_STRT := fldPH_8.AsDateTime;
            RecMQMPH.PH_PROD_DELIVY_DATE := fldPH_9.AsDateTime;
          end;
          RecMQMPH.PH_FRC_DEL_DATE    := Trim(fldPH_10.AsString);
          RecMQMPH.PH_USR_CG         := Trim(fldPH_11.AsString);
          if (DateTimeFormat = Frm_As400) then
            RecMQMPH.PH_USR_TM_CG      := TimDateTimeToDateTime(fldPH_12.AsFloat)
          else if (DateTimeFormat = Frm_TDateTimeExceptControl) or (DateTimeFormat = Frm_TDateTime) then
            RecMQMPH.PH_USR_TM_CG      := fldPH_12.AsDateTime;

          RecMQMPH.PH_ModulHandled          := Trim(fldPH_13.AsString);

          try
            if (fldPH_14 <> nil) and (not fldPH_14.IsNull) then
              RecMQMPH.PH_SPLITCONFLEVELS    := Trim(fldPH_14.AsString);
            if (fldPH_15 <> nil) and (not fldPH_15.IsNull) then
              RecMQMPH.PH_LEAD_STEP_SPLITED  := fldPH_15.AsInteger;
            if (fldPH_16 <> nil) and (not fldPH_16.IsNull) then
              RecMQMPH.PH_MQM_SPLIT_ID := Trim(fldPH_16.AsString);
          except
            RecMQMPH.PH_SPLITCONFLEVELS := '';
            RecMQMPH.PH_LEAD_STEP_SPLITED := 0;
            RecMQMPH.PH_MQM_SPLIT_ID := '';
          end;

          try
            if (fldPH_17 <> nil) and (not fldPH_17.IsNull) then
              RecMQMPH.PH_Serving_Code    := Trim(fldPH_17.AsString);
            if (fldPH_18 <> nil) and (not fldPH_18.IsNull) then
              RecMQMPH.PH_Served_Code  := fldPH_18.AsString;
          except
            RecMQMPH.PH_Serving_Code := '';
            RecMQMPH.PH_Served_Code  := '';
          end;

        end
        else
        begin
          RecMQMPH.PH_PREQ_NO        := Trim(HostQry.FieldByName(CreateFld(tbProdReqHeadr.pfx, fldListPH[0].fldPC)).AsString);
          RecMQMPH.PH_HISTORICAL_REQ := Trim(HostQry.FieldByName(CreateFld(tbProdReqHeadr.pfx, fldListPH[1].fldPC)).AsString);
          RecMQMPH.PH_REQ_ORIGIN     := Trim(HostQry.FieldByName(CreateFld(tbProdReqHeadr.pfx, fldListPH[2].fldPC)).AsString);
          RecMQMPH.PH_PROD_LINE      := Trim(HostQry.FieldByName(CreateFld(tbProdReqHeadr.pfx, fldListPH[3].fldPC)).AsString);
          RecMQMPH.PH_TYPE_PROD      := Trim(HostQry.FieldByName(CreateFld(tbProdReqHeadr.pfx, fldListPH[4].fldPC)).AsString);
          RecMQMPH.PH_PROD_FAMILY    := Trim(HostQry.FieldByName(CreateFld(tbProdReqHeadr.pfx, fldListPH[5].fldPC)).AsString);
          RecMQMPH.PH_MATERIAL_FAMILY := Trim(HostQry.FieldByName(CreateFld(tbProdReqHeadr.pfx, fldListPH[6].fldPC)).AsString);
          RecMQMPH.PH_PROD_UM         := Trim(HostQry.FieldByName(CreateFld(tbProdReqHeadr.pfx, fldListPH[7].fldPC)).AsString);
          RecMQMPH.PH_PROD_LOW_TIME_STRT := HostQry.FieldByName(CreateFld(tbProdReqHeadr.pfx, fldListPH[8].fldPC)).AsDateTime;
          RecMQMPH.PH_PROD_DELIVY_DATE := HostQry.FieldByName(CreateFld(tbProdReqHeadr.pfx, fldListPH[9].fldPC)).AsDateTime;
          RecMQMPH.PH_FRC_DEL_DATE    := Trim(HostQry.FieldByName(CreateFld(tbProdReqHeadr.pfx, fldListPH[10].fldPC)).AsString);
          RecMQMPH.PH_USR_CG         := Trim(HostQry.FieldByName(CreateFld(tbProdReqHeadr.pfx, fldListPH[11].fldPC)).AsString);
          RecMQMPH.PH_USR_TM_CG      := HostQry.FieldByName(CreateFld(tbProdReqHeadr.pfx, fldListPH[12].fldPC)).AsDateTime;

          if not HostQry.FieldByName(CreateFld(tbProdReqHeadr.pfx, fldListPH[14].fldPC)).IsNull then
            RecMQMPH.PH_SPLITCONFLEVELS    := Trim(HostQry.FieldByName(CreateFld(tbProdReqHeadr.pfx, fldListPH[14].fldPC)).AsString);
          if not HostQry.FieldByName(CreateFld(tbProdReqHeadr.pfx, fldListPH[15].fldPC)).IsNull then
            RecMQMPH.PH_LEAD_STEP_SPLITED  := HostQry.FieldByName(CreateFld(tbProdReqHeadr.pfx, fldListPH[15].fldPC)).AsInteger;
          if not HostQry.FieldByName(CreateFld(tbProdReqHeadr.pfx, fldListPH[16].fldPC)).IsNull then
            RecMQMPH.PH_MQM_SPLIT_ID := Trim(HostQry.FieldByName(CreateFld(tbProdReqHeadr.pfx, fldListPH[16].fldPC)).AsString);
          if not HostQry.FieldByName(CreateFld(tbProdReqHeadr.pfx, fldListPH[17].fldPC)).IsNull then
            RecMQMPH.PH_Serving_Code := Trim(HostQry.FieldByName(CreateFld(tbProdReqHeadr.pfx, fldListPH[17].fldPC)).AsString);
          if not HostQry.FieldByName(CreateFld(tbProdReqHeadr.pfx, fldListPH[18].fldPC)).IsNull then
            RecMQMPH.PH_Served_Code := Trim(HostQry.FieldByName(CreateFld(tbProdReqHeadr.pfx, fldListPH[18].fldPC)).AsString);

        end;
        m_ProdCont.m_HostListPH.add(RecMQMPH);
        HostQry.Next;
      end;
      HostQry.Close;
      m_ProdCont.m_HostListPH.Sort(SortPH);
    end
    else
    begin
      UpdateOperation(_('Get prod_reqhdr list') + ' ' + (_('from host . . .')));
      m_ProdCont.m_HostListPH := Get_Host_prod_reqhdr_list;
      m_ProdCont.m_HostListPH.Sort(SortPH);
      Result := true
    end;
  end
  else
  begin
    OrderBy := ' Order by ' + CreateFld(tbProdReqHeadr.pfx, fli_preqNo);
    Result :=  LoadSrvTable(tbl,'', OrderBy, fldListPH, srvQry, '');
  end;
end;

//----------------------------------------------------------------------------//

function AddProdRqDetails(tbl : table; srvQry: TMqmQuery; HostQry : TMqmQuery;IsHostQry : boolean; IsInsert : boolean): boolean;
var
  RecMQMPD : PTMQMPD;
  tbProdReqDetails:         ^TTblInfo;
  OrderBy : string;
  DateTimeFormat : TDateTimeFormat;
  sl : TStringList;
  DndArchiveName : TDndArchiveName;
  PrevRequest : String;
  NumberOfResource : double;
  TotalLeadTime, TotalLeadTimeBatch : currency;
  PrevRecNo : longint;
  // Pre-cached TField references for AS400 path — avoids FieldByName string lookup per row
  fldPD_0,  fldPD_1,  fldPD_2,  fldPD_3,  fldPD_4,
  fldPD_5,  fldPD_6,  fldPD_7,  fldPD_8,  fldPD_9,
  fldPD_10, fldPD_11, fldPD_12, fldPD_13, fldPD_14,
  fldPD_15, fldPD_16, fldPD_17, fldPD_18, fldPD_19,
  fldPD_20, fldPD_21, fldPD_22, fldPD_23, fldPD_24,
  fldPD_25, fldPD_26, fldPD_27, fldPD_28, fldPD_29,
  fldPD_30, fldPD_31, fldPD_32, fldPD_33, fldPD_34,
  fldPD_35 : TField;
  // Optional fields (may not exist in all AS400 schemas)
  fldPD_36, fldPD_37, fldPD_38, fldPD_39,
  fldPD_40, fldPD_41, fldPD_42, fldPD_43, fldPD_44 : TField;
const
  fldListAS: array [0..44] of TQryLinkRec = (
    (fldPC: fli_preqNo;                 fldAS: 'OPRREQ'; fldType: TLD_string),
    (fldPC: fli_pstepId;                fldAS: 'OPRSTP'; fldType: TLD_integer),
    (fldPC: fli_ToBeSched;              fldAS: 'OTBSCH'; fldType: TLD_string),
    (fldPC: fli_prevStepSched_Mqm;      fldAS: 'OPRVST'; fldType: TLD_integer),
    (fldPC: fli_prevStepTrue;           fldAS: 'OPRVSS'; fldType: TLD_integer),
    (fldPC: fli_NextStepSched_Mqm;      fldAS: 'ONXTST'; fldType: TLD_integer),
    (fldPC: fli_NextStepTrue;           fldAS: 'ONXTSS'; fldType: TLD_integer),
    (fldPC: fli_StepType;               fldAS: 'OSTPTP'; fldType: TLD_string),
    (fldPC: fli_MaterialArrivDate;      fldAS: 'OMTADT'; fldType: TLD_dateTime),
    (fldPC: fli_FrcMatDate;             fldAS: 'OFRMTD'; fldType: TLD_string),
    (fldPC: fli_planStart;              fldAS: 'OPLSDT'; fldType: TLD_dateTime),
    (fldPC: fli_LowStartTimeLimit;      fldAS: 'OLSTDT'; fldType: TLD_dateTime),
    (fldPC: fli_FrcLowestDate;          fldAS: 'OFRLWD'; fldType: TLD_string),
    (fldPC: fli_planEnd;                fldAS: 'OPLEDT'; fldType: TLD_dateTime),
    (fldPC: fli_HighEndTimeLimit;       fldAS: 'OHSTDT'; fldType: TLD_dateTime),
    (fldPC: fli_FrcHighestDate;         fldAS: 'OFRHGD'; fldType: TLD_string),
    (fldPC: fli_wkCtrCode;              fldAS: 'OPLMAC'; fldType: TLD_string),
    (fldPC: fli_wkcProc;                fldAS: 'OPLMAP'; fldType: TLD_string),
    (fldPC: fli_quantInit;              fldAS: 'OINIQT'; fldType: TLD_float),
    (fldPC: fli_quantFinl;              fldAS: 'OFINQT'; fldType: TLD_float),
    (fldPC: fli_Weight;                 fldAS: 'OWEIGT'; fldType: TLD_float),
    (fldPC: fli_DescUM;                 fldAS: 'OWEIUM'; fldType: TLD_string),
    (fldPC: fli_CalCod;                 fldAS: 'OCDCAL'; fldType: TLD_string),
    (fldPC: fli_SetupTimStep;           fldAS: 'OTOTST'; fldType: TLD_float),
    (fldPC: fli_excTimeStep;            fldAS: 'OTOTET'; fldType: TLD_float),
    (fldPC: fli_NumResPlan;             fldAS: 'ONURSC'; fldType: TLD_float),
    (fldPC: fli_AllowSplit;             fldAS: 'OFLSPL'; fldType: TLD_string),
    (fldPC: fli_StepHandleReProc;       fldAS: 'OFLRPR'; fldType: TLD_string),
    (fldPC: fli_StepPartGenralPlan;     fldAS: 'OGENPL'; fldType: TLD_string),
    (fldPC: fli_StepCanGroup;           fldAS: 'OFLGRP'; fldType: TLD_string),
    (fldPC: fli_ForcedGroupNo;          fldAS: 'OSTPGR'; fldType: TLD_float),
    (fldPC: fli_ConnTypToPrevStepSplit; fldAS: 'OCNTYP'; fldType: TLD_string),
    (fldPC: fli_FrcOverlapp;            fldAS: 'OFRNOL'; fldType: TLD_string),
    (fldPC: fli_StepClosed;             fldAS: 'OSTCLO'; fldType: TLD_string),
    (fldPC: fli_usrCg;                  fldAS: 'OUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;                fldAS: 'ODTOCH'; fldType: TLD_dateTime),
    (fldPC: fli_LearningCurveCode;      fldAS: 'OLRNCV'; fldType: TLD_string),
    (fldPC: fli_LearningCurveType;      fldAS: 'OLRNTP'; fldType: TLD_string),
    (fldPC: fli_ApprovalDate;            fldAS: 'OAPPDT'; fldType: TLD_dateTime),
    (fldPC: fli_GrpContinueSeq;          fldAS: 'OGRSEQ'; fldType: TLD_string),
  	(fldPC: fli_MinBatchSize;            fldAS: 'OMINBQ'; fldType: TLD_Float),
    (fldPC: fli_OptimumBatchSize;        fldAS: 'OOPTBQ'; fldType: TLD_Float),
    (fldPC: fli_MaxBatchSize;            fldAS: 'OMAXBQ'; fldType: TLD_Float),
    (fldPC: fli_BatchSizePerStep;        fldAS: 'OBQTJB'; fldType: TLD_string),
    (fldPC: fli_MaxStartDateAutoSeq;     fldAS: 'OMSDAS'; fldType: TLD_dateTime)
  );

begin
  PrevRequest := '';
  PrevRecNo := -1;
  TotalLeadTime := 0;
  TotalLeadTimeBatch := 0;

  Assert(tbl = tbl_prod_step);
  tbProdReqDetails := @tblInfo[tbl];
  DndArchiveName := GetDndArchiveHostName;
  RecMQMPD := nil;

  if IsInsert then
  begin
    Result := InsertTable(tbl,fldListPD,srvQry);
  end

  else if IsHostQry then
  begin
    if (Trim(IniAppGlobals.PreparationExeName) = '') then
    begin
      DateTimeFormat := GetDateTimeFormat;

      if DndArchiveName = TD_AS_400 then
        OrderBy := ' Order by OPRREQ,OPRSTP'
      else
        OrderBy := ' Order by ' + CreateFld(tbProdReqDetails.pfx, fli_preqNo) + ',' + CreateFld(tbProdReqDetails.pfx,fli_pstepId);

      Result := LoadTable(tbl, AS400Speclib,'','',OrderBy, fldListAS, HostQry, 'OPRREQ', CreateFld(tbProdReqDetails.pfx,fli_preqNo));

      // Pre-cache TField references — avoids FieldByName string lookup on every row
      if DndArchiveName = TD_AS_400 then
      begin
        fldPD_0  := HostQry.FieldByName(fldListAS[0].fldAS);   fldPD_1  := HostQry.FieldByName(fldListAS[1].fldAS);
        fldPD_2  := HostQry.FieldByName(fldListAS[2].fldAS);   fldPD_3  := HostQry.FieldByName(fldListAS[3].fldAS);
        fldPD_4  := HostQry.FieldByName(fldListAS[4].fldAS);   fldPD_5  := HostQry.FieldByName(fldListAS[5].fldAS);
        fldPD_6  := HostQry.FieldByName(fldListAS[6].fldAS);   fldPD_7  := HostQry.FieldByName(fldListAS[7].fldAS);
        fldPD_8  := HostQry.FieldByName(fldListAS[8].fldAS);   fldPD_9  := HostQry.FieldByName(fldListAS[9].fldAS);
        fldPD_10 := HostQry.FieldByName(fldListAS[10].fldAS);  fldPD_11 := HostQry.FieldByName(fldListAS[11].fldAS);
        fldPD_12 := HostQry.FieldByName(fldListAS[12].fldAS);  fldPD_13 := HostQry.FieldByName(fldListAS[13].fldAS);
        fldPD_14 := HostQry.FieldByName(fldListAS[14].fldAS);  fldPD_15 := HostQry.FieldByName(fldListAS[15].fldAS);
        fldPD_16 := HostQry.FieldByName(fldListAS[16].fldAS);  fldPD_17 := HostQry.FieldByName(fldListAS[17].fldAS);
        fldPD_18 := HostQry.FieldByName(fldListAS[18].fldAS);  fldPD_19 := HostQry.FieldByName(fldListAS[19].fldAS);
        fldPD_20 := HostQry.FieldByName(fldListAS[20].fldAS);  fldPD_21 := HostQry.FieldByName(fldListAS[21].fldAS);
        fldPD_22 := HostQry.FieldByName(fldListAS[22].fldAS);  fldPD_23 := HostQry.FieldByName(fldListAS[23].fldAS);
        fldPD_24 := HostQry.FieldByName(fldListAS[24].fldAS);  fldPD_25 := HostQry.FieldByName(fldListAS[25].fldAS);
        fldPD_26 := HostQry.FieldByName(fldListAS[26].fldAS);  fldPD_27 := HostQry.FieldByName(fldListAS[27].fldAS);
        fldPD_28 := HostQry.FieldByName(fldListAS[28].fldAS);  fldPD_29 := HostQry.FieldByName(fldListAS[29].fldAS);
        fldPD_30 := HostQry.FieldByName(fldListAS[30].fldAS);  fldPD_31 := HostQry.FieldByName(fldListAS[31].fldAS);
        fldPD_32 := HostQry.FieldByName(fldListAS[32].fldAS);  fldPD_33 := HostQry.FieldByName(fldListAS[33].fldAS);
        fldPD_34 := HostQry.FieldByName(fldListAS[34].fldAS);  fldPD_35 := HostQry.FieldByName(fldListAS[35].fldAS);
        // Optional fields — nil if not present in this AS400 schema
        fldPD_36 := nil; try fldPD_36 := HostQry.FieldByName('OLRNCV'); except end;
        fldPD_37 := nil; try fldPD_37 := HostQry.FieldByName('OLRNTP'); except end;
        fldPD_38 := nil; try fldPD_38 := HostQry.FieldByName('OAPPDT'); except end;
        fldPD_39 := nil; try fldPD_39 := HostQry.FieldByName('OGRSEQ'); except end;
        fldPD_40 := nil; try fldPD_40 := HostQry.FieldByName('OMINBQ'); except end;
        fldPD_41 := nil; try fldPD_41 := HostQry.FieldByName('OOPTBQ'); except end;
        fldPD_42 := nil; try fldPD_42 := HostQry.FieldByName('OMAXBQ'); except end;
        fldPD_43 := nil; try fldPD_43 := HostQry.FieldByName('OBQTJB'); except end;
        fldPD_44 := nil; try fldPD_44 := HostQry.FieldByName('OMSDAS'); except end;
      end;

      try

      while not HostQry.Eof do
      begin
        if (m_ProdCont.m_HostListPD.Count mod 500 = 0) then Application.ProcessMessages;
        New(RecMQMPD);
        RecMQMPD.PD_SchedulByMcm              := '';
        RecMQMPD.PD_SchedulByMqm              := '';
        RecMQMPD.PD_SplitFamily               := '';
        RecMQMPD.PD_GRP_SEQUENCE              := '';
        RecMQMPD.PD_BatchSizePerStep          := '';
        RecMQMPD.PD_MinBatchSize              := 0;
        RecMQMPD.PD_OptimumBatchSize          := 0;
        RecMQMPD.PD_MaxBatchSize              := 0;
        RecMQMPD.PD_NumResComponents          := 0;
        RecMQMPD.PD_MaxStartDateAutoSeq       := 0;
        RecMQMPD.PD_INITIALPLANSCHEDDATETIME := 0;
        RecMQMPD.PD_FINALPLANSCHEDDATETIME := 0;


        if DndArchiveName = TD_AS_400 then
        begin
          RecMQMPD.PD_PREQ_NO  := Trim(fldPD_0.AsString);
          RecMQMPD.PD_PSTEP_ID := fldPD_1.AsInteger;
          RecMQMPD.PD_TO_SCHED := Trim(fldPD_2.AsString);
          if RecMQMPD.PD_TO_SCHED = '1' then
            RecMQMPD.PD_SchedulByMqm := '1';

          RecMQMPD.PD_PRV_STEP_SCHED_MQM := fldPD_3.AsInteger;
          RecMQMPD.PD_PRV_STEP_TRUE      := fldPD_4.AsInteger;
          RecMQMPD.PD_NEX_STEP_SCHED_MQM := fldPD_5.AsInteger;
          RecMQMPD.PD_NEX_STEP_TRUE      := fldPD_6.AsInteger;
          RecMQMPD.PD_STEP_TYP           := Trim(fldPD_7.AsString);
          if (DateTimeFormat = Frm_As400) then
            RecMQMPD.PD_MAT_ARRV_DATE  := TimDateTimeToDateTime(fldPD_8.AsFloat)
          else if (DateTimeFormat = Frm_TDateTimeExceptControl) or (DateTimeFormat = Frm_TDateTime) then
            RecMQMPD.PD_MAT_ARRV_DATE  := fldPD_8.AsDateTime;
          RecMQMPD.PD_FRC_MAT_DATE := Trim(fldPD_9.AsString);
          if (DateTimeFormat = Frm_As400) then
          begin
            RecMQMPD.PD_PLAN_START          := TimDateTimeToDateTime(fldPD_10.AsFloat);
            RecMQMPD.PD_LOW_LIMIT_TIME_STRT := TimDateTimeToDateTime(fldPD_11.AsFloat);
          end
          else if (DateTimeFormat = Frm_TDateTimeExceptControl) or (DateTimeFormat = Frm_TDateTime) then
          begin
            RecMQMPD.PD_PLAN_START          := fldPD_10.AsDateTime;
            RecMQMPD.PD_LOW_LIMIT_TIME_STRT := fldPD_11.AsDateTime;
          end;
          RecMQMPD.PD_FRC_LOW_DATE := Trim(fldPD_12.AsString);
          if (DateTimeFormat = Frm_As400) then
          begin
            RecMQMPD.PD_PLAN_END          := TimDateTimeToDateTime(fldPD_13.AsFloat);
            RecMQMPD.PD_HIGH_LIMIT_TIMEND := TimDateTimeToDateTime(fldPD_14.AsFloat);
          end
          else if (DateTimeFormat = Frm_TDateTimeExceptControl) or (DateTimeFormat = Frm_TDateTime) then
          begin
            RecMQMPD.PD_PLAN_END          := fldPD_13.AsDateTime;
            RecMQMPD.PD_HIGH_LIMIT_TIMEND := fldPD_14.AsDateTime;
          end;
          RecMQMPD.PD_FRC_HIGH_DATE            := Trim(fldPD_15.AsString);
          RecMQMPD.PD_WKCNTER                  := Trim(fldPD_16.AsString);
          RecMQMPD.PD_WKCT_PROC                := Trim(fldPD_17.AsString);
          RecMQMPD.PD_INIT_QUENT               := fldPD_18.AsFloat;
          RecMQMPD.PD_FIN_QUENT                := fldPD_19.AsFloat;
          RecMQMPD.PD_WEIGHT                   := fldPD_20.AsInteger;
          RecMQMPD.PD_DESC_UM                  := Trim(fldPD_21.AsString);
          RecMQMPD.PD_CAL                      := Trim(fldPD_22.AsString);
          RecMQMPD.PD_SETUP_TIME_STP           := fldPD_23.AsFloat;
          RecMQMPD.PD_EXC_TIME_STP             := fldPD_24.AsFloat;
          RecMQMPD.PD_RES_NUM_PLN              := fldPD_25.AsFloat;
          RecMQMPD.PD_ALLOW_SPLIT              := Trim(fldPD_26.AsString);
          RecMQMPD.PD_STEP_HANDLE_REPROCES     := Trim(fldPD_27.AsString);
          RecMQMPD.PD_STEP_PART_GEN_PLAN       := Trim(fldPD_28.AsString);
          RecMQMPD.PD_STEP_CAN_GROUP           := Trim(fldPD_29.AsString);
          RecMQMPD.PD_FORCED_GRP_NO            := fldPD_30.AsInteger;
          RecMQMPD.PD_CONN_TYPE_PREV_STEP_SPLIT := Trim(fldPD_31.AsString);
          RecMQMPD.PD_FRC_OVERLAPP             := Trim(fldPD_32.AsString);
          RecMQMPD.PD_STEP_CLOSED              := Trim(fldPD_33.AsString);
          RecMQMPD.PD_USR_CG                   := Trim(fldPD_34.AsString);
          if (DateTimeFormat = Frm_As400) then
            RecMQMPD.PD_USR_TM_CG := TimDateTimeToDateTime(fldPD_35.AsFloat)
          else if (DateTimeFormat = Frm_TDateTimeExceptControl) or (DateTimeFormat = Frm_TDateTime) then
            RecMQMPD.PD_USR_TM_CG := fldPD_35.AsDateTime;

          // Optional fields — checked once at start, no per-row exceptions
          if Assigned(fldPD_36) then RecMQMPD.PD_LearningCurveCode := Trim(fldPD_36.AsString)
          else RecMQMPD.PD_LearningCurveCode := '';
          if Assigned(fldPD_37) then RecMQMPD.PD_LearningCurveType := Trim(fldPD_37.AsString)
          else RecMQMPD.PD_LearningCurveType := '';
          if Assigned(fldPD_38) then RecMQMPD.PD_ApprovalDate := TimDateTimeToDateTime(fldPD_38.AsFloat)
          else RecMQMPD.PD_ApprovalDate := 0;
          if Assigned(fldPD_39) then RecMQMPD.PD_GRP_SEQUENCE := Trim(fldPD_39.AsString);
          if Assigned(fldPD_40) then
          begin
            RecMQMPD.PD_MinBatchSize     := fldPD_40.AsFloat;
            RecMQMPD.PD_OptimumBatchSize := fldPD_41.AsFloat;
            RecMQMPD.PD_MaxBatchSize     := fldPD_42.AsFloat;
            RecMQMPD.PD_BatchSizePerStep := Trim(fldPD_43.AsString);
          end;
          if Assigned(fldPD_44) then RecMQMPD.PD_MaxStartDateAutoSeq := TimDateTimeToDateTime(fldPD_44.AsFloat)
          else RecMQMPD.PD_MaxStartDateAutoSeq := 0;

        end
        else
        begin
          RecMQMPD.PD_PREQ_NO  := Trim(HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx, fldListPD[0].fldPC)).AsString);
          RecMQMPD.PD_PSTEP_ID := HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx, fldListPD[1].fldPC)).AsInteger;
          RecMQMPD.PD_TO_SCHED := Trim(HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx, fldListPD[2].fldPC)).AsString);
          RecMQMPD.PD_PRV_STEP_SCHED_MQM := HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx,fldListPD[3].fldPC)).AsInteger;
          RecMQMPD.PD_PRV_STEP_TRUE  := HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx,fldListPD[4].fldPC)).AsInteger;
          RecMQMPD.PD_NEX_STEP_SCHED_MQM := HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx,fldListPD[5].fldPC)).AsInteger;
          RecMQMPD.PD_NEX_STEP_TRUE  := HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx,fldListPD[6].fldPC)).AsInteger;
          RecMQMPD.PD_STEP_TYP       := Trim(HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx,fldListPD[7].fldPC)).AsString);
          RecMQMPD.PD_MAT_ARRV_DATE  := HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx,fldListPD[8].fldPC)).AsDateTime;
          RecMQMPD.PD_FRC_MAT_DATE   := Trim(HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx,fldListPD[9].fldPC)).AsString);
          RecMQMPD.PD_PLAN_START := HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx,fldListPD[10].fldPC)).AsDateTime;
          RecMQMPD.PD_LOW_LIMIT_TIME_STRT := HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx,fldListPD[11].fldPC)).AsDateTime;
          RecMQMPD.PD_FRC_LOW_DATE := Trim(HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx,fldListPD[12].fldPC)).AsString);
          RecMQMPD.PD_PLAN_END := HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx,fldListPD[13].fldPC)).AsDateTime;
          RecMQMPD.PD_HIGH_LIMIT_TIMEND := HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx,fldListPD[14].fldPC)).AsDateTime;
          RecMQMPD.PD_FRC_HIGH_DATE     := Trim(HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx,fldListPD[15].fldPC)).AsString);
          RecMQMPD.PD_WKCNTER           := Trim(HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx,fldListPD[16].fldPC)).AsString);
          RecMQMPD.PD_WKCT_PROC         := Trim(HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx,fldListPD[17].fldPC)).AsString);
          RecMQMPD.PD_INIT_QUENT        := HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx,fldListPD[18].fldPC)).AsFloat;
          RecMQMPD.PD_FIN_QUENT         := HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx,fldListPD[19].fldPC)).AsFloat;
          RecMQMPD.PD_WEIGHT            := HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx,fldListPD[20].fldPC)).AsInteger;
          RecMQMPD.PD_DESC_UM           := Trim(HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx,fldListPD[21].fldPC)).AsString);
          RecMQMPD.PD_CAL               := Trim(HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx,fldListPD[22].fldPC)).AsString);
          RecMQMPD.PD_SETUP_TIME_STP    := HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx,fldListPD[23].fldPC)).AsFloat;
          RecMQMPD.PD_EXC_TIME_STP      := HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx,fldListPD[24].fldPC)).AsFloat;
          RecMQMPD.PD_RES_NUM_PLN       := HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx,fldListPD[25].fldPC)).AsFloat;
          RecMQMPD.PD_ALLOW_SPLIT       := Trim(HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx,fldListPD[26].fldPC)).AsString);
          RecMQMPD.PD_STEP_HANDLE_REPROCES := Trim(HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx,fldListPD[27].fldPC)).AsString);
          RecMQMPD.PD_STEP_PART_GEN_PLAN   := Trim(HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx,fldListPD[28].fldPC)).AsString);
          RecMQMPD.PD_STEP_CAN_GROUP       := Trim(HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx,fldListPD[29].fldPC)).AsString);
          RecMQMPD.PD_FORCED_GRP_NO        := HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx,fldListPD[30].fldPC)).AsInteger;
          RecMQMPD.PD_CONN_TYPE_PREV_STEP_SPLIT := Trim(HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx,fldListPD[31].fldPC)).AsString);
          RecMQMPD.PD_FRC_OVERLAPP := Trim(HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx,fldListPD[32].fldPC)).AsString);
          RecMQMPD.PD_STEP_CLOSED  := Trim(HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx,fldListPD[33].fldPC)).AsString);
          RecMQMPD.PD_USR_CG         := Trim(HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx,fldListPD[34].fldPC)).AsString);
          RecMQMPD.PD_USR_TM_CG := HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx,fldListPD[35].fldPC)).AsDateTime;
          RecMQMPD.PD_SchedulByMqm := '1';
          if not HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx,fldListPD[41].fldPC)).IsNull then
            RecMQMPD.PD_SplitFamily               := Trim(HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx,fldListPD[41].fldPC)).AsString);
          if not HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx,fldListPD[42].fldPC)).IsNull then
            RecMQMPD.PD_LearningCurveCode               := Trim(HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx,fldListPD[42].fldPC)).AsString);
          if not HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx,fldListPD[43].fldPC)).IsNull then
            RecMQMPD.PD_LearningCurveType               := Trim(HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx,fldListPD[43].fldPC)).AsString);
          if not HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx,fldListPD[44].fldPC)).IsNull then
            RecMQMPD.PD_OVERLAP_WITH_OTHER_STEPS := Trim(HostQry.FieldByName(CreateFld(tbProdReqDetails.pfx,fldListPD[44].fldPC)).AsString);
          RecMQMPD.PD_GRP_SEQUENCE := '';
        end;

        RecMQMPD.PD_Prev_LeadTime_mqm := 0;
        RecMQMPD.PD_Next_LeadTime_mqm := 0;
        RecMQMPD.PD_Prev_LeadTimeBatch_mqm := 0;
        RecMQMPD.PD_Next_LeadTimeBatch_mqm := 0;

        RecMQMPD.PD_Prev_LeadTime_mcm := 0;
        RecMQMPD.PD_Next_LeadTime_mcm := 0;
        RecMQMPD.PD_Prev_LeadTimeBatch_mcm := 0;
        RecMQMPD.PD_Next_LeadTimeBatch_mcm := 0;

        if (PrevRequest <> '') and (PrevRequest <> RecMQMPD.PD_PREQ_NO) then
        begin
          if PrevRecNo > (-1) then
          begin
            PTMQMPD(m_ProdCont.m_HostListPD[PrevRecNo]).PD_Next_LeadTime_mqm := TotalLeadTime;
            PTMQMPD(m_ProdCont.m_HostListPD[PrevRecNo]).PD_Next_LeadTimeBatch_mqm := TotalLeadTimeBatch;
          end;
          PrevRecNo := -1;
          TotalLeadTime := 0;
          TotalLeadTimeBatch := 0;
        end;

        if (RecMQMPD.PD_TO_SCHED = '1') and (PrevRequest = RecMQMPD.PD_PREQ_NO) then
        begin
          RecMQMPD.PD_Prev_LeadTime_mqm := TotalLeadTime;
          RecMQMPD.PD_Prev_LeadTimeBatch_mqm := TotalLeadTimeBatch;
        end;

        m_ProdCont.m_HostListPD.add(RecMQMPD);

        if (RecMQMPD.PD_TO_SCHED = '1') then
        begin
          if PrevRecNo > (-1) then
          begin
            PTMQMPD(m_ProdCont.m_HostListPD[PrevRecNo]).PD_Next_LeadTime_mqm := TotalLeadTime;
            PTMQMPD(m_ProdCont.m_HostListPD[PrevRecNo]).PD_Next_LeadTimeBatch_mqm := TotalLeadTimeBatch;
          end;
          PrevRecNo := m_ProdCont.m_HostListPD.Count - 1;
          TotalLeadTime := 0;
          TotalLeadTimeBatch := 0;
        end;

        PrevRequest := RecMQMPD.PD_PREQ_NO;

        if RecMQMPD.PD_TO_SCHED <> '1' then
        begin
          if RecMQMPD.PD_RES_NUM_PLN > 0 then
            NumberOfResource := RecMQMPD.PD_RES_NUM_PLN
          else
            NumberOfResource := 1;

          if RecMQMPD.PD_STEP_TYP = 'B' then
             TotalLeadTimeBatch := TotalLeadTimeBatch + ((RecMQMPD.PD_SETUP_TIME_STP + RecMQMPD.PD_EXC_TIME_STP) / NumberOfResource)
          else
          TotalLeadTime := TotalLeadTime + ((RecMQMPD.PD_SETUP_TIME_STP + RecMQMPD.PD_EXC_TIME_STP) / NumberOfResource);
          if TotalLeadTime > 0 then
             TotalLeadTime := Trunc(TotalLeadTime * 100) / 100;
          if TotalLeadTime > 9999999 then TotalLeadTime := 9999999;
        end;

        HostQry.Next;
      end;

      if PrevRecNo > (-1) then
      begin
         PTMQMPD(m_ProdCont.m_HostListPD[PrevRecNo]).PD_Next_LeadTime_mqm := TotalLeadTime;
         PTMQMPD(m_ProdCont.m_HostListPD[PrevRecNo]).PD_Next_LeadTimeBatch_mqm := TotalLeadTimeBatch;
      end;

      except
      on E: Exception do
        begin
          sl := TStringList.Create;
          sl.Add('Error While loading From ' + tbProdReqDetails.ASname);
          sl.Add('Please check Record for Request : ' + RecMQMPD.PD_PREQ_NO + ' Step : ' + IntToStr(RecMQMPD.PD_PSTEP_ID));
          sl.Add(E.Message);
          UpdateError(sl);
          sl.Free;
          Result := false
        end
      end;

      HostQry.Close;
      m_ProdCont.m_HostListPD.Sort(SortPD);
    end
    else
    begin
      UpdateOperation(_('Get prod_step list') + ' ' + (_('from host . . .')));
      m_ProdCont.m_HostListPD := Get_Host_prod_step_list;
      m_ProdCont.m_HostListPD.Sort(SortPD);
      Result := true;
    end;

  end

  else
  begin
    OrderBy := ' Order by ' + CreateFld(tbProdReqDetails.pfx, fli_preqNo) + ',' + CreateFld(tbProdReqDetails.pfx,fli_pstepId);
    Result :=  LoadSrvTable(tbl,'', OrderBy, fldListPD, srvQry, '');
  end;
end;

//----------------------------------------------------------------------------//

function AddProdProperty(tbl : table; srvQry: TMqmQuery; HostQry : TMqmQuery; IsHostQry : boolean ; IsInsert : boolean): boolean;
var
  RecMQMPP : PTMQMPP;
  tbProdProp:         ^TTblInfo;
  OrderBy : string;
  DateTimeFormat : TDateTimeFormat;
  DndArchiveHostName : TDndArchiveName;
  // Pre-cached TField references for AS400 path
  fldPP_0, fldPP_1, fldPP_2, fldPP_3, fldPP_4, fldPP_5, fldPP_6 : TField;
  bSortNeeded : Boolean;
  sPrevKey    : string;
begin
  Assert(tbl = tbl_prop_prod);
  tbProdProp := @tblInfo[tbl];
  DndArchiveHostName := GetDndArchiveHostName;
  if IsInsert then
  begin
    Result := InsertTable(tbl,fldListPP,srvQry);
  end

  else if IsHostQry then
  begin

    if (Trim(IniAppGlobals.PreparationExeName) = '') then
    begin
      DateTimeFormat := GetDateTimeFormat;
      OrderBy := '';
      Result := LoadTable(tbl, AS400Speclib,'','',OrderBy, fldListPP, HostQry, 'LPRREQ', CreateFld(tbProdProp.pfx,fli_preqNo));
      if DndArchiveHostName = TD_AS_400 then
      begin
        fldPP_0 := HostQry.FieldByName(fldListPP[0].fldAS);
        fldPP_1 := HostQry.FieldByName(fldListPP[1].fldAS);
        fldPP_2 := HostQry.FieldByName(fldListPP[2].fldAS);
        fldPP_3 := HostQry.FieldByName(fldListPP[3].fldAS);
        fldPP_4 := HostQry.FieldByName(fldListPP[4].fldAS);
        fldPP_5 := HostQry.FieldByName(fldListPP[5].fldAS);
        fldPP_6 := HostQry.FieldByName(fldListPP[6].fldAS);
      end;
      bSortNeeded := False;
      sPrevKey    := '';
      while not HostQry.Eof do
      begin
        if (m_ProdCont.m_HostListPP.Count mod 500 = 0) then Application.ProcessMessages;
        New(RecMQMPP);
        if DndArchiveHostName = TD_AS_400 then
        begin
          RecMQMPP.PP_PREQ_NO := Trim(fldPP_0.AsString);
          RecMQMPP.PP_PSTEP_ID := fldPP_1.AsInteger;
          RecMQMPP.PP_RSC_CODE := Trim(fldPP_2.AsString);
          RecMQMPP.PP_PROPERTY := Trim(fldPP_3.AsString);
          RecMQMPP.PP_VALUE    := Trim(fldPP_4.AsString);
          RecMQMPP.PP_USR_CG         := Trim(fldPP_5.AsString);
          if (DateTimeFormat = Frm_As400) then
            RecMQMPP.PP_USR_TM_CG  := TimDateTimeToDateTime(fldPP_6.AsFloat)
          else if (DateTimeFormat = Frm_TDateTimeExceptControl) or (DateTimeFormat = Frm_TDateTime) then
            RecMQMPP.PP_USR_TM_CG  := fldPP_6.AsDateTime;
        end
        else
        begin
          RecMQMPP.PP_PREQ_NO := Trim(HostQry.FieldByName(CreateFld(tbProdProp.pfx, fldListPP[0].fldPC)).AsString);
          RecMQMPP.PP_PSTEP_ID := HostQry.FieldByName(CreateFld(tbProdProp.pfx, fldListPP[1].fldPC)).AsInteger;
          RecMQMPP.PP_RSC_CODE := Trim(HostQry.FieldByName(CreateFld(tbProdProp.pfx, fldListPP[2].fldPC)).AsString);
          RecMQMPP.PP_PROPERTY := Trim(HostQry.FieldByName(CreateFld(tbProdProp.pfx, fldListPP[3].fldPC)).AsString);
          RecMQMPP.PP_VALUE    := Trim(HostQry.FieldByName(CreateFld(tbProdProp.pfx, fldListPP[4].fldPC)).AsString);
          RecMQMPP.PP_USR_CG   := Trim(HostQry.FieldByName(CreateFld(tbProdProp.pfx, fldListPP[5].fldPC)).AsString);
          RecMQMPP.PP_USR_TM_CG  := HostQry.FieldByName(CreateFld(tbProdProp.pfx, fldListPP[6].fldPC)).AsDateTime;
        end;
        RecMQMPP.PP_SortKey := RecMQMPP.PP_PREQ_NO + Chr(1) +
                               Format('%010d', [RecMQMPP.PP_PSTEP_ID]) + Chr(1) +
                               RecMQMPP.PP_PROPERTY + Chr(1) +
                               RecMQMPP.PP_RSC_CODE;
        if RecMQMPP.PP_SortKey < sPrevKey then
          bSortNeeded := True;
        sPrevKey := RecMQMPP.PP_SortKey;
        m_ProdCont.m_HostListPP.add(RecMQMPP);
        HostQry.Next;
      end;
      HostQry.Close;
      if bSortNeeded then
        m_ProdCont.m_HostListPP.Sort(SortPP);
    end
    else
    begin
      UpdateOperation(_('Get prop_prod list') + ' ' + (_('from host . . .')));
      m_ProdCont.m_HostListPP := Get_Host_prop_prod_list(bSortNeeded);
      if bSortNeeded then
        m_ProdCont.m_HostListPP.Sort(SortPP);
      result := true
    end;

  end
  else
  begin
    OrderBy := ' Order by ' + CreateFld(tbProdProp.pfx,fli_preqNo) + ',' + CreateFld(tbProdProp.pfx,fli_pstepId) + ',' +
                 CreateFld(tbProdProp.pfx,fli_PropertyCode) + ',' + CreateFld(tbProdProp.pfx,fli_rsc);
    Result :=  LoadSrvTable(tbl,'', OrderBy, fldListPP, srvQry, '');
  end;
end;

//----------------------------------------------------------------------------//

function AddProdImfo(tbl : table; srvQry: TMqmQuery; HostQry : TMqmQuery ;IsHostQry : boolean; IsInsert : boolean): boolean;
var
  RecMQMPI : PTMQMPI;
  tbProdInfo:         ^TTblInfo;
  OrderBy : string;
  DateTimeFormat : TDateTimeFormat;
  DndArchiveHostName : TDndArchiveName;
  // Pre-cached TField references for AS400 path
  fldPI_0, fldPI_1, fldPI_2, fldPI_3, fldPI_4, fldPI_5, fldPI_6 : TField;
begin
  Assert(tbl = tbl_prod_info);
  tbProdInfo := @tblInfo[tbl];
  DndArchiveHostName := GetDndArchiveHostName;
  if IsInsert then
  begin
    Result := InsertTable(tbl,fldListPI,srvQry);
  end

  else if IsHostQry then
  begin
    if (Trim(IniAppGlobals.PreparationExeName) = '') then
    begin
      DateTimeFormat := GetDateTimeFormat;
      OrderBy := '';
      Result := LoadTable(tbl, AS400Speclib,'','',OrderBy, fldListPI, HostQry, 'NPRREQ',CreateFld(tbProdInfo.pfx,fli_preqNo));
      if DndArchiveHostName = TD_AS_400 then
      begin
        fldPI_0 := HostQry.FieldByName(fldListPI[0].fldAS);
        fldPI_1 := HostQry.FieldByName(fldListPI[1].fldAS);
        fldPI_2 := HostQry.FieldByName(fldListPI[2].fldAS);
        fldPI_3 := HostQry.FieldByName(fldListPI[3].fldAS);
        fldPI_4 := HostQry.FieldByName(fldListPI[4].fldAS);
        fldPI_5 := HostQry.FieldByName(fldListPI[5].fldAS);
        fldPI_6 := HostQry.FieldByName(fldListPI[6].fldAS);
      end;
      while not HostQry.Eof do
      begin
        if (m_ProdCont.m_HostListPI.Count mod 500 = 0) then Application.ProcessMessages;
        New(RecMQMPI);
        if DndArchiveHostName = TD_AS_400 then
        begin
          RecMQMPI.PI_PREQ_NO := Trim(fldPI_0.AsString);
          RecMQMPI.PI_PSTEP_ID := fldPI_1.AsInteger;
          RecMQMPI.PI_INFO_LINE_NUM := fldPI_2.AsInteger;
          RecMQMPI.PI_INFO_TYPE := Trim(fldPI_3.AsString);
          RecMQMPI.PI_INFO_AREA := Trim(fldPI_4.AsString);

          RecMQMPI.PI_USR_CG    := Trim(fldPI_5.AsString);
          if (DateTimeFormat = Frm_As400) then
            RecMQMPI.PI_USR_TM_CG := TimDateTimeToDateTime(fldPI_6.AsFloat)
          else if (DateTimeFormat = Frm_TDateTimeExceptControl) or (DateTimeFormat = Frm_TDateTime) then
            RecMQMPI.PI_USR_TM_CG := fldPI_6.AsDateTime;
        end
        else
        begin
          RecMQMPI.PI_PREQ_NO := Trim(HostQry.FieldByName(CreateFld(tbProdInfo.pfx, fldListPI[0].fldPC)).AsString);
          RecMQMPI.PI_PSTEP_ID := HostQry.FieldByName(CreateFld(tbProdInfo.pfx, fldListPI[1].fldPC)).AsInteger;
          RecMQMPI.PI_INFO_LINE_NUM := HostQry.FieldByName(CreateFld(tbProdInfo.pfx, fldListPI[2].fldPC)).AsInteger;
          RecMQMPI.PI_INFO_AREA := Trim(HostQry.FieldByName(CreateFld(tbProdInfo.pfx, fldListPI[3].fldPC)).AsString);
          RecMQMPI.PI_INFO_TYPE := Trim(HostQry.FieldByName(CreateFld(tbProdInfo.pfx, fldListPI[4].fldPC)).AsString);
          RecMQMPI.PI_USR_CG    := Trim(HostQry.FieldByName(CreateFld(tbProdInfo.pfx, fldListPI[5].fldPC)).AsString);
          RecMQMPI.PI_USR_TM_CG := HostQry.FieldByName(CreateFld(tbProdInfo.pfx, fldListPI[6].fldPC)).AsDateTime;
        end;
        m_ProdCont.m_HostListPI.add(RecMQMPI);
        HostQry.Next;
      end;
      HostQry.Close;
      m_ProdCont.m_HostListPI.Sort(SortPI)
    end
    else
    begin
      UpdateOperation(_('Get prod_info list') + ' ' + (_('from host . . .')));
      m_ProdCont.m_HostListPI := Get_Host_prod_info_list;
      m_ProdCont.m_HostListPI.Sort(SortPI);
      Result := true
    end;

  end
  else
  begin
    OrderBy := ' Order by ' + CreateFld(tbProdInfo.pfx,fli_preqNo) + ',' + CreateFld(tbProdInfo.pfx,fli_pstepId) + ',' +
               CreateFld(tbProdInfo.pfx,fli_infoType) + ',' + CreateFld(tbProdInfo.pfx,fli_infoLineNum);
    Result :=  LoadSrvTable(tbl,'', OrderBy, fldListPI, srvQry, '');
  end;
end;

//----------------------------------------------------------------------------//

function AddProdExternalConn(tbl : table; srvQry: TMqmQuery; HostQry : TMqmQuery ;IsHostQry : boolean; IsInsert : boolean): boolean;
var
  RecMQMEC : PTMQMEC;
  tbExtConn:         ^TTblInfo;
  OrderBy : string;
  DateTimeFormat : TDateTimeFormat;
  DndArchiveHostName : TDndArchiveName;
  // Pre-cached TField references for AS400 path
  fldEC_0, fldEC_1, fldEC_2, fldEC_3, fldEC_4, fldEC_5 : TField;
begin
  Assert(tbl = tbl_ext_connection);
  tbExtConn := @tblInfo[tbl];
  DndArchiveHostName := GetDndArchiveHostName;
  if IsInsert then
  begin
    Result := InsertTable(tbl,fldListEC,srvQry);
  end

  else if IsHostQry then
  begin
    if (Trim(IniAppGlobals.PreparationExeName) = '') then
    begin
      DateTimeFormat := GetDateTimeFormat;
      OrderBy := '';
      Result := LoadTable(tbl, AS400Speclib, '','',OrderBy, fldListEC, HostQry, 'ZPRREQ', CreateFld(tbExtConn.pfx,fli_preqNo));
      if DndArchiveHostName = TD_AS_400 then
      begin
        fldEC_0 := HostQry.FieldByName(fldListEC[0].fldAS);
        fldEC_1 := HostQry.FieldByName(fldListEC[1].fldAS);
        fldEC_2 := HostQry.FieldByName(fldListEC[2].fldAS);
        fldEC_3 := HostQry.FieldByName(fldListEC[3].fldAS);
        fldEC_4 := HostQry.FieldByName(fldListEC[4].fldAS);
        fldEC_5 := HostQry.FieldByName(fldListEC[5].fldAS);
      end;
      while not HostQry.Eof do
      begin
        if (m_ProdCont.m_HostListEC.Count mod 500 = 0) then Application.ProcessMessages;
        New(RecMQMEC);
        if DndArchiveHostName = TD_AS_400 then
        begin
          RecMQMEC.EC_PREQ_NO := Trim(fldEC_0.AsString);
          RecMQMEC.EC_CONNE_KEY := Trim(fldEC_1.AsString);
          RecMQMEC.EC_NUM_LEVELS := fldEC_2.AsInteger;
          RecMQMEC.EC_CONN_CERTENT_LEVEL := Trim(fldEC_3.AsString);
          RecMQMEC.EC_USR_CG         := Trim(fldEC_4.AsString);
          if (DateTimeFormat = Frm_As400) then
            RecMQMEC.EC_USR_TM_CG := TimDateTimeToDateTime(fldEC_5.AsFloat)
          else if (DateTimeFormat = Frm_TDateTimeExceptControl) or (DateTimeFormat = Frm_TDateTime) then
            RecMQMEC.EC_USR_TM_CG := fldEC_5.AsDateTime;
        end
        else
        begin
          RecMQMEC.EC_PREQ_NO := Trim(HostQry.FieldByName(CreateFld(tbExtConn.pfx, fldListEC[0].fldPC)).AsString);
          RecMQMEC.EC_CONNE_KEY := Trim(HostQry.FieldByName(CreateFld(tbExtConn.pfx, fldListEC[1].fldPC)).AsString);
          RecMQMEC.EC_NUM_LEVELS := HostQry.FieldByName(CreateFld(tbExtConn.pfx, fldListEC[2].fldPC)).AsInteger;
          RecMQMEC.EC_CONN_CERTENT_LEVEL := Trim(HostQry.FieldByName(CreateFld(tbExtConn.pfx, fldListEC[3].fldPC)).AsString);
          RecMQMEC.EC_USR_CG         := Trim(HostQry.FieldByName(CreateFld(tbExtConn.pfx, fldListEC[4].fldPC)).AsString);
          RecMQMEC.EC_USR_TM_CG := HostQry.FieldByName(CreateFld(tbExtConn.pfx, fldListEC[5].fldPC)).AsDateTime;
        end;
        m_ProdCont.m_HostListEC.add(RecMQMEC);
        HostQry.Next;
      end;
      HostQry.Close;
      m_ProdCont.m_HostListEC.Sort(SortEC)
    end
    else
    begin
      UpdateOperation(_('Get ext_connection list') + ' ' + (_('from host . . .')));
      m_ProdCont.m_HostListEC := Get_Host_ext_connection_list;
      m_ProdCont.m_HostListEC.Sort(SortEC);
      Result := true
    end;

  end
  else
  begin
    OrderBy := ' Order by ' + CreateFld(tbExtConn.pfx,fli_preqNo) + ',' + CreateFld(tbExtConn.pfx,fli_ConnKey);
    Result :=  LoadSrvTable(tbl,'', OrderBy, fldListEC, srvQry, '');
  end;

end;

//----------------------------------------------------------------------------//

function AddProdInternalConn(tbl : table; srvQry: TMqmQuery; HostQry : TMqmQuery; IsHostQry : boolean ; IsInsert : boolean): boolean;
var
  RecMQMIC : PTMQMIC;
  tbIntConn:         ^TTblInfo;
  OrderBy : string;
  DateTimeFormat : TDateTimeFormat;
  DndArchiveHostName : TDndArchiveName;
  // Pre-cached TField references for AS400 path
  fldIC_0, fldIC_1, fldIC_2, fldIC_3 : TField;
begin
  Assert(tbl = tbl_prod_reqConnection);
  tbIntConn := @tblInfo[tbl];
  DndArchiveHostName := GetDndArchiveHostName;
  if IsInsert then
  begin
    Result := InsertTable(tbl,fldListIC,srvQry);
  end

  else if IsHostQry then
  begin
    if (Trim(IniAppGlobals.PreparationExeName) = '') then
    begin
      DateTimeFormat := GetDateTimeFormat;
      OrderBy := '';
      Result := LoadTable(tbl, AS400Speclib,'','',OrderBy, fldListIC, HostQry, 'CPRREQ',CreateFld(tbIntConn.pfx, fli_preqNo));
      if DndArchiveHostName = TD_AS_400 then
      begin
        fldIC_0 := HostQry.FieldByName(fldListIC[0].fldAS);
        fldIC_1 := HostQry.FieldByName(fldListIC[1].fldAS);
        fldIC_2 := HostQry.FieldByName(fldListIC[2].fldAS);
        fldIC_3 := HostQry.FieldByName(fldListIC[3].fldAS);
      end;
      while not HostQry.Eof do
      begin
        if (m_ProdCont.m_HostListIC.Count mod 500 = 0) then Application.ProcessMessages;
        New(RecMQMIC);
        if DndArchiveHostName = TD_AS_400 then
        begin
          RecMQMIC.IC_PREQ_NO := Trim(fldIC_0.AsString);
          RecMQMIC.IC_PREV_PREQ_NO := Trim(fldIC_1.AsString);
          RecMQMIC.IC_USR_CG       := Trim(fldIC_2.AsString);
          if (DateTimeFormat = Frm_As400) then
            RecMQMIC.IC_USR_TM_CG := TimDateTimeToDateTime(fldIC_3.AsFloat)
          else if (DateTimeFormat = Frm_TDateTimeExceptControl) or (DateTimeFormat = Frm_TDateTime) then
            RecMQMIC.IC_USR_TM_CG := fldIC_3.AsDateTime;
        end
        else
        begin
          RecMQMIC.IC_PREQ_NO      := Trim(HostQry.FieldByName(CreateFld(tbIntConn.pfx, fldListIC[0].fldPC)).AsString);
          RecMQMIC.IC_PREV_PREQ_NO := Trim(HostQry.FieldByName(CreateFld(tbIntConn.pfx, fldListIC[1].fldPC)).AsString);
          RecMQMIC.IC_USR_CG       := Trim(HostQry.FieldByName(CreateFld(tbIntConn.pfx, fldListIC[2].fldPC)).AsString);
          RecMQMIC.IC_USR_TM_CG    := HostQry.FieldByName(CreateFld(tbIntConn.pfx, fldListIC[3].fldPC)).AsDateTime;
        end;
        m_ProdCont.m_HostListIC.add(RecMQMIC);
        HostQry.Next;
      end;
      HostQry.Close;
      m_ProdCont.m_HostListIC.Sort(SortIC)
    end
    else
    begin
      UpdateOperation(_('Get prod_reqConn list') + ' ' + (_('from host . . .')));
      m_ProdCont.m_HostListIC := Get_Host_prod_reqConn_list;
      m_ProdCont.m_HostListIC.Sort(SortIC);
      result := true
    end;

  end
  else
  begin
    OrderBy := ' Order by ' + CreateFld(tbIntConn.pfx, fli_preqNo) + ',' + CreateFld(tbIntConn.pfx,fli_PrevProdNum);
    Result :=  LoadSrvTable(tbl,'', OrderBy, fldListIC, srvQry, '');
  end;
end;

//----------------------------------------------------------------------------//

function AddProdBatch(tbl : table; srvQry: TMqmQuery; HostQry : TMqmQuery; IsHostQry : boolean; IsInsert : boolean): boolean;
var
  RecMQMSB : PTMQMSB;
  tbBatchSize:         ^TTblInfo;
  OrderBy : string;
  DndArchiveHostName : TDndArchiveName;
  // Pre-cached TField references for AS400 path
  fldSB_0, fldSB_1, fldSB_2, fldSB_3 : TField;
begin
  Assert(tbl = tbl_step_batchSize);
  tbBatchSize := @tblInfo[tbl];
  DndArchiveHostName := GetDndArchiveHostName;
  if IsInsert then
  begin
    Result := InsertTable(tbl,fldListSB,srvQry);
  end

  else if IsHostQry then
  begin
    if (Trim(IniAppGlobals.PreparationExeName) = '') then
    begin
      OrderBy := '';
      Result := LoadTable(tbl, AS400Speclib,'','',OrderBy, fldListSB, HostQry, 'JPRREQ',CreateFld(tbBatchSize.pfx, fli_preqNo));
      if DndArchiveHostName = TD_AS_400 then
      begin
        fldSB_0 := HostQry.FieldByName(fldListSB[0].fldAS);
        fldSB_1 := HostQry.FieldByName(fldListSB[1].fldAS);
        fldSB_2 := HostQry.FieldByName(fldListSB[2].fldAS);
        fldSB_3 := HostQry.FieldByName(fldListSB[3].fldAS);
      end;
      while not HostQry.Eof do
      begin
        if (m_ProdCont.m_HostListSB.Count mod 500 = 0) then Application.ProcessMessages;
        New(RecMQMSB);
        if DndArchiveHostName = TD_AS_400 then
        begin
          RecMQMSB.SB_PREQ_NO := Trim(fldSB_0.AsString);
          RecMQMSB.SB_PSTEP_ID := fldSB_1.AsInteger;
          RecMQMSB.SB_BCH_UM := Trim(fldSB_2.AsString);
          RecMQMSB.SB_MULTIPILR_TO_BATCH_UM := fldSB_3.AsFloat;
        end
        else
        begin
          RecMQMSB.SB_PREQ_NO := Trim(HostQry.FieldByName(CreateFld(tbBatchSize.pfx, fldListSB[0].fldPC)).AsString);
          RecMQMSB.SB_PSTEP_ID := HostQry.FieldByName(CreateFld(tbBatchSize.pfx, fldListSB[1].fldPC)).AsInteger;
          RecMQMSB.SB_BCH_UM := Trim(HostQry.FieldByName(CreateFld(tbBatchSize.pfx, fldListSB[2].fldPC)).AsString);
          RecMQMSB.SB_MULTIPILR_TO_BATCH_UM := HostQry.FieldByName(CreateFld(tbBatchSize.pfx, fldListSB[3].fldPC)).AsFloat;
        end;
        m_ProdCont.m_HostListSB.add(RecMQMSB);
        HostQry.Next;
      end;
      HostQry.Close;
      m_ProdCont.m_HostListSB.Sort(SortSB)
    end
    else
    begin
      UpdateOperation(_('Get prod_step_batch_size list') + ' ' + (_('from host . . .')));
      m_ProdCont.m_HostListSB := Get_Host_prod_step_batch_size_list;
      m_ProdCont.m_HostListSB.Sort(SortSB);
      result := true;
    end;

  end
  else
  begin
    OrderBy := ' Order by ' + CreateFld(tbBatchSize.pfx, fli_preqNo) + ',' + CreateFld(tbBatchSize.pfx, fli_pstepId) + ',' +
                 CreateFld(tbBatchSize.pfx, fli_BchUM);
    Result :=  LoadSrvTable(tbl,'', OrderBy, fldListSB, srvQry, '');
  end;
end;

//----------------------------------------------------------------------------//

function GetPDRecord(Request : string; Step : Integer) : PTMQMPD;
var
  I : Integer;
  Multiplier, NumberOfEntries : integer;
  TmpReq : String;
  TmpStep : Integer;
begin
  Result := nil;
  TmpStep := 0;
  NumberOfEntries := m_ProdCont.m_HostListPD.Count;
  if NumberOfEntries = 0 then exit;
  Multiplier := 1;
  while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
  i := Multiplier - 1;
  while (Multiplier > 0) do
  begin

    if i < NumberOfEntries then
    begin
      TmpReq := PTMQMPD(m_ProdCont.m_HostListPD[i]).PD_PREQ_NO;
      TmpStep := PTMQMPD(m_ProdCont.m_HostListPD[i]).PD_PSTEP_ID;
      if (TmpReq = Request) and (TmpStep = Step) then
      begin
        Result := m_ProdCont.m_HostListPD[I];
        exit;
      end;
    end;
    Multiplier := trunc(Multiplier / 2);
    if (i < NumberOfEntries) and
       ( (TmpReq < Request) or ( (TmpReq = Request) and (TmpStep < step) ) ) then
      i := i + Multiplier
    else
      i := i - Multiplier;

  end;

end;

//----------------------------------------------------------------------------//

function SortRes(item1, item2: pointer): integer;
var rr1, rr2: PRecRes;
begin
    rr1 := item1;
    rr2 := item2;

    if rr1.RS_RSC_Code < rr2.RS_RSC_Code then
      Result := -1
    else if rr1.RS_RSC_Code > rr2.RS_RSC_Code then
      Result :=  1
    else
      Result :=  0
end;

//----------------------------------------------------------------------------//

function AddProdProgress(tbl : table; srvQry: TMqmQuery; HostQry : TMqmQuery; IsHostQry : boolean; IsInsert : boolean): boolean;
var
  RecMQMSP,PrevRecMQMSP,CurrentRecMQMSP,NextRecMQMSP : PTMQMSP;
  RecMQMPD : PTMQMPD;
  RecMQMSP_OVERIDDE : PTMQMSPOVER;
  RecMQMPS : PTMQMPS;
  ListPS   : TList;
  tbProdProgress, tbProdProgressOverride:   ^TTblInfo;
  OrderBy, CurrentRequest : string;
  DateTimeFormat : TDateTimeFormat;
  Number_Of_Resource_Components : double;
  Previous_Resource : string;
  Previous_wc, Previous_Cat : string;
  Resource_Exist : boolean;
  QryRS, QryPS : TMqmQuery;
//  srvTrs : TMqmTransaction;
  tbRes, tbProdSched, tbProdStep, tb_res_sub : ^TTblInfo;
  I1,I,I3,Progresses_Index, IndexSp, CurrentStep: integer;
  Overlapping, FirstSplitProgress, SubStepMinusOneFound : boolean;
  ProgressSplitType : String;
  List_ProgressOverride : TList;
  DndArchiveHostName : TDndArchiveName;
  BatchGroupNumber : double;
  BatchInContinuesGroupSequence : String;
  I2, J : integer;
  Temp_PROGRESSES_List, RSC_List : TList;
  LowestStart, HighestCurrent, HighestEnd : TDateTime;
  ProgressType : String;
  ListIndex : integer;
  sl : TStringList;
  TempExt : Extended;
  S, TempStrQty : string;
  RecRes :PRecRes;
  // Pre-cached TField references for AS400 path (index 11 skipped — empty fldAS)
  fldSP_0,  fldSP_1,  fldSP_2,  fldSP_3,  fldSP_4,
  fldSP_5,  fldSP_6,  fldSP_7,  fldSP_8,  fldSP_9,
  fldSP_10, fldSP_12 : TField;
  // Pre-cached TField references for QryPS loop
  fldPS_preqNo, fldPS_pstepId, fldPS_psubstId, fldPS_reprocNo,
  fldPS_Rsc, fldPS_RscCat, fldPS_wkCtrCode, fldPS_quant : TField;
  //----
  function FindInRes(Res : string) : PRecRes;
  var
    I : Integer;
    Multiplier, NumberOfEntries : integer;
  begin
    Result := nil;

    NumberOfEntries := RSC_List.Count;
    if NumberOfEntries = 0 then exit;

    Multiplier := 1;
    while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;

    i := Multiplier - 1;

    while (Multiplier > 0) do
    begin

      Multiplier := trunc(Multiplier / 2);

      if (i >= NumberOfEntries) then
      begin
        i := i - Multiplier;
        continue;
      end;

      if (PRecRes(RSC_List[i]).RS_RSC_Code < Res) then
      begin
        i := i + Multiplier;
        continue;
      end;
      if (PRecRes(RSC_List[i]).RS_RSC_Code > Res) then
      begin
        i := i - Multiplier;
        continue;
      end;

      Result := PRecRes(RSC_List[i]);
      break;

    end;

  end;
  //----
  function FindInProgressOverride(MQMSP : PTMQMSP) : boolean;
  var
    J : Integer;
  begin
    Result := false;
    for J := 0 to List_ProgressOverride.Count - 1 do
    begin
      RecMQMSP_OVERIDDE := PTMQMSPOVER(List_ProgressOverride[J]);
      if (RecMQMSP_OVERIDDE.SPO_PREQ_NO = MQMSP.SP_PREQ_NO) and
         (RecMQMSP_OVERIDDE.SPO_PSTEP_ID = MQMSP.SP_PSTEP_ID) and
         (RecMQMSP_OVERIDDE.SPO_REPROC_NO = MQMSP.SP_REPROC_NO) and
         (RecMQMSP_OVERIDDE.SPO_LAST_PROG_TYPE = MQMSP.SP_LAST_PROG_TYPE) and
         (RecMQMSP_OVERIDDE.SPO_RSC_CODE       = MQMSP.SP_RSC_CODE) and
         (RecMQMSP_OVERIDDE.SPO_PROGRSTART      = MQMSP.SP_PROGRSTART) and
         (RecMQMSP_OVERIDDE.SPO_CURR_PRG_DATE   = MQMSP.SP_CURR_PRG_DATE) and
         (RecMQMSP_OVERIDDE.SPO_PROGREND        = MQMSP.SP_PROGREND) and
         (RecMQMSP_OVERIDDE.SPO_QTY             = MQMSP.SP_QTY) and
         (RecMQMSP_OVERIDDE.SPO_STARTQTY        = MQMSP.SP_StartingQty) and
         (RecMQMSP_OVERIDDE.SPO_REMAIN_TIME     = MQMSP.SP_REMAIN_TIME) then
      begin
        Result := true;
        Exit
      end
    end;
  end;

const
  fldListOver : array [0..11] of TQryLinkRec = (
    (fldPC: fli_preqNo;           fldAS: 'SPRREQ'; fldType: TLD_string),
    (fldPC: fli_pstepId;          fldAS: 'SPRSTP'; fldType: TLD_integer),
    (fldPC: fli_psubstId;         fldAS: 'SPRSST'; fldType: TLD_integer),
    (fldPC: fli_reprocNo;         fldAS: 'SRPRNB'; fldType: TLD_integer),
    (fldPC: fli_ProgressType;     fldAS: 'SLPRTY'; fldType: TLD_string),
    (fldPC: fli_rsc;              fldAS: 'SCDRSC'; fldType: TLD_string),
    (fldPC: fli_ProgressGroup;    fldAS: 'SPRGRP'; fldType: TLD_integer),
    (fldPC: fli_progrStart;       fldAS: 'SSTRDT'; fldType: TLD_dateTime),
    (fldPC: fli_prgCurrDate;      fldAS: 'SCURDT'; fldType: TLD_dateTime),
    (fldPC: fli_progrEnd;         fldAS: 'SENDDT'; fldType: TLD_dateTime),
    (fldPC: fli_quant;            fldAS: 'SPRQTY'; fldType: TLD_float),
    (fldPC: fli_prgRemTime;       fldAS: 'SRMNTM'; fldType: TLD_float)
  );

begin
  Assert(tbl = tbl_sched_progress);
  tbProdProgress := @tblInfo[tbl];
  tbProdProgressOverride := @tblInfo[tbl_sched_progress_override];
  DndArchiveHostName := GetDndArchiveHostName;

  QryRS := ThreadCreateQuery(Main_DB);
  QryPS := ThreadCreateQuery(Main_DB);

  //QryPD := ThreadCreateQuery(srvTrs, Main_DB);
  tbRes := @tblInfo[tbl_res];
  tb_res_sub := @tblInfo[tbl_res_sub];
  if not DBAppGlobals.License_MQM then
    tbProdSched := @tblInfo[tbl_prod_sched_mcm]
  else
    tbProdSched := @tblInfo[tbl_Prod_sched];
  tbProdStep  := @tblInfo[tbl_Prod_Step];
  Progresses_Index := -1;
  Number_Of_Resource_Components := 0;
  FirstSplitProgress := True;
  ProgressSplitType := '';
  SubStepMinusOneFound := false;
  List_ProgressOverride := nil;
  if IsInsert then
  begin
    Result := InsertTable(tbl,fldListSP,srvQry);
  end

  else if IsHostQry then
  begin
    srvQry.sql.Clear;
    srvQry.sql.add(' Select * from ' + tbProdProgressOverride.GetTableName);
    srvQry.SQL.Add(WHERE_IDF_Condition(CreateFld(tbProdProgressOverride.pfx, fli_IDENTIFIER)));
    srvQry.sql.add(' Order by ' + CreateFld(tbProdProgressOverride.pfx,fli_preqNo) + ',' + CreateFld(tbProdProgressOverride.pfx,fli_pstepId));
    srvQry.sql.add(',' + CreateFld(tbProdProgressOverride.pfx,fli_psubstId) + ',' + CreateFld(tbProdProgressOverride.pfx,fli_reprocNo));
    srvQry.Open;
    if not srvQry.Eof then
      List_ProgressOverride := TList.Create;
    while not srvQry.Eof do
    begin
      Application.ProcessMessages;
      New(RecMQMSP_OVERIDDE);
      RecMQMSP_OVERIDDE.SPO_PREQ_NO         := srvQry.FieldByName(CreateFld(tbProdProgressOverride.pfx, fli_preqNo)).AsString;
      RecMQMSP_OVERIDDE.SPO_PSTEP_ID        := srvQry.FieldByName(CreateFld(tbProdProgressOverride.pfx, fli_pstepId)).AsInteger;
      RecMQMSP_OVERIDDE.SPO_PSUBST_ID       := srvQry.FieldByName(CreateFld(tbProdProgressOverride.pfx, fli_psubstId)).AsInteger;
      RecMQMSP_OVERIDDE.SPO_REPROC_NO       := srvQry.FieldByName(CreateFld(tbProdProgressOverride.pfx, fli_reprocNo)).AsInteger;
      RecMQMSP_OVERIDDE.SPO_LAST_PROG_TYPE  := Trim(srvQry.FieldByName(CreateFld(tbProdProgressOverride.pfx, fli_ProgressType)).AsString);
      RecMQMSP_OVERIDDE.SPO_RSC_CODE        := srvQry.FieldByName(CreateFld(tbProdProgressOverride.pfx, fli_rsc)).AsString;
      RecMQMSP_OVERIDDE.SPO_PROGRSTART      := srvQry.FieldByName(CreateFld(tbProdProgressOverride.pfx, fli_progrStart)).AsDateTime;
      RecMQMSP_OVERIDDE.SPO_CURR_PRG_DATE   := srvQry.FieldByName(CreateFld(tbProdProgressOverride.pfx, fli_prgCurrDate)).AsDateTime;
      RecMQMSP_OVERIDDE.SPO_PROGREND        := srvQry.FieldByName(CreateFld(tbProdProgressOverride.pfx, fli_progrEnd)).AsDateTime;
      RecMQMSP_OVERIDDE.SPO_QTY             := srvQry.FieldByName(CreateFld(tbProdProgressOverride.pfx, fli_quant)).AsFloat;
      RecMQMSP_OVERIDDE.SPO_REMAIN_TIME     := srvQry.FieldByName(CreateFld(tbProdProgressOverride.pfx, fli_prgRemTime)).AsFloat;
      List_ProgressOverride.add(RecMQMSP_OVERIDDE);
      srvQry.Next;
    end;
    srvQry.Close;

    tbl := tbl_sched_progress;
    DateTimeFormat := GetDateTimeFormat;

    if DndArchiveHostName = TD_AS_400 then
      OrderBy := ' Order by SCDRSC,SSTRDT'
    else
      OrderBy := '';

    if (Trim(IniAppGlobals.PreparationExeName) = '') then
    begin

      try

      Result := LoadTable(tbl, AS400Speclib, '', '', OrderBy, fldListSP, HostQry, 'SPRREQ',CreateFld(tbProdProgress.pfx,fli_preqNo));
      if DndArchiveHostName = TD_AS_400 then
      begin
        fldSP_0  := HostQry.FieldByName(fldListSP[0].fldAS);
        fldSP_1  := HostQry.FieldByName(fldListSP[1].fldAS);
        fldSP_2  := HostQry.FieldByName(fldListSP[2].fldAS);
        fldSP_3  := HostQry.FieldByName(fldListSP[3].fldAS);
        fldSP_4  := HostQry.FieldByName(fldListSP[4].fldAS);
        fldSP_5  := HostQry.FieldByName(fldListSP[5].fldAS);
        fldSP_6  := HostQry.FieldByName(fldListSP[6].fldAS);
        fldSP_7  := HostQry.FieldByName(fldListSP[7].fldAS);
        fldSP_8  := HostQry.FieldByName(fldListSP[8].fldAS);
        fldSP_9  := HostQry.FieldByName(fldListSP[9].fldAS);
        fldSP_10 := HostQry.FieldByName(fldListSP[10].fldAS);
        fldSP_12 := HostQry.FieldByName(fldListSP[12].fldAS);
      end;
      Previous_Resource := '';
      Resource_Exist := false;
      while not HostQry.Eof do
      begin
        if (m_ProdCont.m_HostListSP.Count mod 500 = 0) then Application.ProcessMessages;
        New(RecMQMSP);
        if DndArchiveHostName = TD_AS_400 then
        begin
          RecMQMSP.SP_PREQ_NO := Trim(fldSP_0.AsString);
          RecMQMSP.SP_PSTEP_ID := fldSP_1.AsInteger;
          RecMQMSP.SP_PSUBST_ID := fldSP_2.AsInteger;
          RecMQMSP.SP_REPROC_NO := fldSP_3.AsInteger;
          RecMQMSP.SP_LAST_PROG_TYPE := Trim(fldSP_4.AsString);
          RecMQMSP.SP_RSC_CODE := Trim(fldSP_5.AsString);
          RecMQMSP.SP_PROGRESED_GROUP := fldSP_6.AsInteger;
          if (DateTimeFormat = Frm_As400) then
          begin
            RecMQMSP.SP_PROGRSTART := TimDateTimeToDateTime(fldSP_7.AsFloat);
            RecMQMSP.SP_CURR_PRG_DATE := TimDateTimeToDateTime(fldSP_8.AsFloat);
            RecMQMSP.SP_PROGREND := TimDateTimeToDateTime(fldSP_9.AsFloat)
          end
          else if (DateTimeFormat = Frm_TDateTimeExceptControl) or (DateTimeFormat = Frm_TDateTime) then
          begin
            RecMQMSP.SP_PROGRSTART := fldSP_7.AsDateTime;
            RecMQMSP.SP_CURR_PRG_DATE := fldSP_8.AsDateTime;
            RecMQMSP.SP_PROGREND := fldSP_9.AsDateTime;
          end;
          RecMQMSP.SP_QTY := fldSP_10.AsFloat;
          RecMQMSP.SP_StartingQty := 0;
          RecMQMSP.SP_REMAIN_TIME := fldSP_12.AsFloat;
//          RecMQMSP.SP_ProgressChange := NoChange;
        end
        else
        begin
          RecMQMSP.SP_PREQ_NO := Trim(HostQry.FieldByName(CreateFld(tbProdProgress.pfx, fldListSP[0].fldPC)).AsString);
          RecMQMSP.SP_PSTEP_ID := HostQry.FieldByName(CreateFld(tbProdProgress.pfx, fldListSP[1].fldPC)).AsInteger;
          RecMQMSP.SP_PSUBST_ID := HostQry.FieldByName(CreateFld(tbProdProgress.pfx, fldListSP[2].fldPC)).AsInteger;
          RecMQMSP.SP_REPROC_NO := HostQry.FieldByName(CreateFld(tbProdProgress.pfx, fldListSP[3].fldPC)).AsInteger;
          RecMQMSP.SP_LAST_PROG_TYPE := Trim(HostQry.FieldByName(CreateFld(tbProdProgress.pfx, fldListSP[4].fldPC)).AsString);
          RecMQMSP.SP_RSC_CODE := Trim(HostQry.FieldByName(CreateFld(tbProdProgress.pfx, fldListSP[5].fldPC)).AsString);
          RecMQMSP.SP_PROGRESED_GROUP := HostQry.FieldByName(CreateFld(tbProdProgress.pfx, fldListSP[6].fldPC)).AsInteger;
          RecMQMSP.SP_PROGRSTART := HostQry.FieldByName(CreateFld(tbProdProgress.pfx, fldListSP[7].fldPC)).AsDateTime;
          RecMQMSP.SP_CURR_PRG_DATE := HostQry.FieldByName(CreateFld(tbProdProgress.pfx, fldListSP[8].fldPC)).AsDateTime;
          RecMQMSP.SP_PROGREND := HostQry.FieldByName(CreateFld(tbProdProgress.pfx, fldListSP[9].fldPC)).AsDateTime;
          RecMQMSP.SP_QTY := HostQry.FieldByName(CreateFld(tbProdProgress.pfx, fldListSP[10].fldPC)).AsFloat;
          RecMQMSP.SP_REMAIN_TIME := HostQry.FieldByName(CreateFld(tbProdProgress.pfx, fldListSP[11].fldPC)).AsFloat;
        end;

        RecMQMSP.SP_LAST_PROG_TYPE_HOST := RecMQMSP.SP_LAST_PROG_TYPE;
        RecMQMSP.SP_RSC_CODE_HOST       := RecMQMSP.SP_RSC_CODE;
        RecMQMSP.SP_PROGRSTART_HOST     := RecMQMSP.SP_PROGRSTART;
        RecMQMSP.SP_CURR_PRG_DATE_HOST  := RecMQMSP.SP_CURR_PRG_DATE;
        RecMQMSP.SP_PROGREND_HOST       := RecMQMSP.SP_PROGREND;
        RecMQMSP.SP_QTY_HOST            := RecMQMSP.SP_QTY;
        RecMQMSP.SP_REMAIN_TIME_HOST    := RecMQMSP.SP_REMAIN_TIME;

        if (RecMQMSP.SP_LAST_PROG_TYPE <> '1') and (RecMQMSP.SP_LAST_PROG_TYPE <> '2')
        and (RecMQMSP.SP_LAST_PROG_TYPE <> '3') and (RecMQMSP.SP_LAST_PROG_TYPE <> '4') and
            (RecMQMSP.SP_LAST_PROG_TYPE <> '5') then
        begin
          Dispose(RecMQMSP);
          HostQry.Next;
          continue;
        end;

        if Assigned(List_ProgressOverride) and FindInProgressOverride(RecMQMSP) then
        begin
          Dispose(RecMQMSP);
          HostQry.Next;
          continue;
        end;

        if RecMQMSP.SP_RSC_CODE = '' then
        begin
          Dispose(RecMQMSP);
          HostQry.Next;
          continue;
        end;

        if ((RecMQMSP.SP_LAST_PROG_TYPE = '2') and (RecMQMSP.SP_PROGRSTART > RecMQMSP.SP_CURR_PRG_DATE)) or
           ((RecMQMSP.SP_LAST_PROG_TYPE = '3') and (RecMQMSP.SP_PROGRSTART > RecMQMSP.SP_PROGREND)) or
           ((RecMQMSP.SP_LAST_PROG_TYPE = '4') and (RecMQMSP.SP_PROGRSTART > RecMQMSP.SP_PROGREND)) or
           ((RecMQMSP.SP_LAST_PROG_TYPE = '5') and (RecMQMSP.SP_PROGRSTART > RecMQMSP.SP_PROGREND)) then
        begin
          Dispose(RecMQMSP);
          HostQry.Next;
          continue;
        end;

        //******************************
        RecMQMPD := GetPDRecord(RecMQMSP.SP_PREQ_NO,RecMQMSP.SP_PSTEP_ID);

        if RecMQMPD = nil then
        begin
          Dispose(RecMQMSP);
          HostQry.Next;
          continue;
        end;

        if (RecMQMPD.PD_STEP_CLOSED = '1') and ((RecMQMSP.SP_LAST_PROG_TYPE = '1') or (RecMQMSP.SP_LAST_PROG_TYPE = '2')) then
        begin
          RecMQMSP.SP_LAST_PROG_TYPE := '3';
          RecMQMSP.SP_PROGREND := RecMQMSP.SP_CURR_PRG_DATE;
        end;

        //******************************

        // Initial progress //
        if (RecMQMSP.SP_LAST_PROG_TYPE = '1') then
        begin
          if RecMQMSP.SP_PROGRSTART = 0 then
          begin
            Dispose(RecMQMSP);
            HostQry.Next;
            continue;
          end;
          RecMQMSP.SP_PROGREND := 0;
        end;

        // Generic progress //
        if (RecMQMSP.SP_LAST_PROG_TYPE = '2') then
        begin
          if (RecMQMSP.SP_CURR_PRG_DATE = 0) then
          begin
            Dispose(RecMQMSP);
            HostQry.Next;
            continue;
          end;
          RecMQMSP.SP_PROGREND := 0;
          if (RecMQMSP.SP_PROGRSTART = 0) then
            RecMQMSP.SP_PROGRSTART := RecMQMSP.SP_CURR_PRG_DATE;

          if (RecMQMSP.SP_PROGRSTART = RecMQMSP.SP_CURR_PRG_DATE) then
             RecMQMSP.SP_PROGRSTART := RecMQMSP.SP_PROGRSTART - (1 /24 /60/60);
        end;

        // End of End and split progress //
        if (RecMQMSP.SP_LAST_PROG_TYPE = '3') or (RecMQMSP.SP_LAST_PROG_TYPE = '4') then
        begin
          if (RecMQMSP.SP_PROGREND = 0) then
          begin
            Dispose(RecMQMSP);
            HostQry.Next;
            continue;
          end;

  //************************************************
  //********ERAN 22/08/06 start 2.0.0.3 build 7 ****
  //************************************************
          if ((RecMQMSP.SP_LAST_PROG_TYPE = '4') and (RecMQMSP.SP_QTY <= 0)) or
             ((RecMQMSP.SP_LAST_PROG_TYPE = '5') and (RecMQMSP.SP_QTY <= 0)) then
          begin
            Dispose(RecMQMSP);
            HostQry.Next;
            continue;
          end;
  //************************************************
  //********ERAN 22/08/06 End   2.0.0.3 build 7 ****
  //************************************************
          if (RecMQMSP.SP_LAST_PROG_TYPE = '4') and (RecMQMSP.SP_PSUBST_ID < 0) then
          begin
            Dispose(RecMQMSP);
            HostQry.Next;
            continue;
          end;

          if (RecMQMSP.SP_PROGRSTART = 0) then
            RecMQMSP.SP_PROGRSTART := RecMQMSP.SP_CURR_PRG_DATE;

          if (RecMQMSP.SP_PROGRSTART = 0) then
            RecMQMSP.SP_PROGRSTART := RecMQMSP.SP_PROGREND;
          if (RecMQMSP.SP_PROGRSTART = RecMQMSP.SP_PROGREND) then
             RecMQMSP.SP_PROGRSTART := RecMQMSP.SP_PROGRSTART - (1 /24 /60/60);
        end;

        if Previous_Resource <> RecMQMSP.SP_RSC_CODE then
        begin
          Previous_Resource := RecMQMSP.SP_RSC_CODE;
          Resource_Exist := false;
          with QryRS do
          begin
            sql.Clear;
            sql.add('Select * from ' + tbRes.GetTableName);
            SQL.Add(' where ' + CreateFld(tbRes.pfx, fli_Rsc) + '=');
            SQL.Add('''' + RecMQMSP.SP_RSC_CODE + '''');
            SQL.Add(AND_IDF_Condition(CreateFld(tbRes.pfx, fli_IDENTIFIER)));
            Open;
            if not Eof then
            begin
              Resource_Exist := true;
              Number_Of_Resource_Components := FieldByName(CreateFld(tbRes.pfx, fli_NumOfRsc)).AsFloat;
              RecMQMSP.SP_WORK_CENTER                := FieldByName(CreateFld(tbRes.pfx, fli_wkCtrCode)).AsString;
              RecMQMSP.SP_RES_CAT                    := FieldByName(CreateFld(tbRes.pfx, fli_RscCat)).AsString;
              Previous_wc  := RecMQMSP.SP_WORK_CENTER;
              Previous_Cat := RecMQMSP.SP_RES_CAT;
            end;
            close;
          end;
        end
        else
        begin
          RecMQMSP.SP_WORK_CENTER := Previous_wc;
          RecMQMSP.SP_RES_CAT     := Previous_Cat;
        end;

        if not Resource_Exist then
        begin
          Dispose(RecMQMSP);
          HostQry.Next;
          continue;
        end;

        RecMQMSP.SP_PD_INIT_QUENT := RecMQMPD.PD_INIT_QUENT;

        if (RecMQMSP.SP_LAST_PROG_TYPE = '4') or (RecMQMSP.SP_LAST_PROG_TYPE = '5') then
        begin
          if not FirstSplitProgress and (RecMQMSP.SP_LAST_PROG_TYPE <> ProgressSplitType) then
          begin
            Dispose(RecMQMSP);
            HostQry.Next;
            continue;
          end;
          ProgressSplitType := RecMQMSP.SP_LAST_PROG_TYPE;
          FirstSplitProgress := false;
        end;

        if RecMQMSP.SP_PSUBST_ID = (-1) then SubStepMinusOneFound := true;

        Progresses_Index := m_ProdCont.m_HostListSP.add(RecMQMSP);
        HostQry.Next;

      end;
      HostQry.Close;

      except
      on E: Exception do
        begin
          sl := TStringList.Create;
          sl.Add('Error While loading From ' + tbProdProgress.ASname);
          sl.Add('Please check Record for Request : ' + RecMQMSP.SP_PREQ_NO + ' Step : ' + IntToStr(RecMQMSP.SP_PSTEP_ID));
          sl.Add(E.Message);
          UpdateError(sl);
          sl.Free;
          Result := false;
          Raise;
        end
      end;

    end
    else
    begin
      UpdateOperation(_('Get Progress list') + ' ' + (_('from host . . .')));

      RSC_List := TList.Create;
      with QryRS do
      begin
        sql.Clear;
        sql.add('select  R.RS_RSC_CODE, R.RS_WKCNTER WKCNTER, R.RS_RES_CATEGORY CATEGORY, R.RS_NUM_RSC_COMP NUM_RSC_COMP '
          + ' from '+ tbRes.GetTableName + ' R '
          + ' where R.RS_IDENTIFIER = ' + IniAppGlobals.Identifier
          + ' order by R.RS_RSC_CODE');
        Open;

        while not Eof do
        Begin
          new(RecRes);
          RecRes.RS_RSC_CODE := FieldByName('RS_RSC_CODE').AsString;
          RecRes.RS_WKCNTER := FieldByName('WKCNTER').AsString;
          RecRes.RS_RES_CATEGORY := FieldByName('CATEGORY').AsString;
          RecRes.RS_NUM_RSC_COMP := FieldByName('NUM_RSC_COMP').asFloat;
          RSC_List.Add(RecRes);
          Next;
        End;

        RSC_List.Sort(SortRes);
        Close;
      end;

      Temp_PROGRESSES_List := Get_Host_Progress_List;
      for J := 0 to Temp_PROGRESSES_List.Count - 1 do
      begin
        if (J mod 500 = 0) then Application.ProcessMessages;
        New(RecMQMSP);

        RecMQMSP.SP_PREQ_NO := Trim(PTPROGRESSES(Temp_PROGRESSES_List[J]).Request);
        RecMQMSP.SP_PSTEP_ID := PTPROGRESSES(Temp_PROGRESSES_List[J]).Step;
        RecMQMSP.SP_PSUBST_ID := -1;
        RecMQMSP.SP_REPROC_NO := -1;
        RecMQMSP.SP_LAST_PROG_TYPE := Trim(PTPROGRESSES(Temp_PROGRESSES_List[J]).ProgressType);
        RecMQMSP.SP_RSC_CODE := Trim(PTPROGRESSES(Temp_PROGRESSES_List[J]).Resource);
        RecMQMSP.SP_PROGRESED_GROUP := 0;
        RecMQMSP.SP_PROGRSTART := PTPROGRESSES(Temp_PROGRESSES_List[J]).ProgressStart;
        RecMQMSP.SP_CURR_PRG_DATE := PTPROGRESSES(Temp_PROGRESSES_List[J]).ProgressCurrent;

        RecMQMSP.SP_PROGREND := 0;
        if (PTPROGRESSES(Temp_PROGRESSES_List[J]).ProgressType = '3') or
           (PTPROGRESSES(Temp_PROGRESSES_List[J]).ProgressType = '5') then
        RecMQMSP.SP_PROGREND := PTPROGRESSES(Temp_PROGRESSES_List[J]).ProgressCurrent;

        TempExt := Frac(PTPROGRESSES(Temp_PROGRESSES_List[J]).Qty);
        S := FloatToStr(TempExt);
        if Length(S) > 3 then
        begin
          S := Copy(s, 2, 3);
          TempStrQty := FloatToStr(trunc(PTPROGRESSES(Temp_PROGRESSES_List[J]).Qty));
          TempStrQty := TempStrQty + S;
          PTPROGRESSES(Temp_PROGRESSES_List[J]).Qty := StrToFloat(TempStrQty);
        end;

        RecMQMSP.SP_QTY := PTPROGRESSES(Temp_PROGRESSES_List[J]).Qty;

        TempExt := Frac(PTPROGRESSES(Temp_PROGRESSES_List[J]).StartingQty);
        S := FloatToStr(TempExt);
        if Length(S) > 3 then
        begin
          S := Copy(s, 2, 3);
          TempStrQty := FloatToStr(trunc(PTPROGRESSES(Temp_PROGRESSES_List[J]).StartingQty));
          TempStrQty := TempStrQty + S;
          PTPROGRESSES(Temp_PROGRESSES_List[J]).StartingQty := StrToFloat(TempStrQty);
        end;

        RecMQMSP.SP_StartingQty := PTPROGRESSES(Temp_PROGRESSES_List[J]).StartingQty;

        RecMQMSP.SP_REMAIN_TIME := -1;
//        RecMQMSP.SP_ProgressChange := NoChange;

        RecMQMSP.SP_LAST_PROG_TYPE_HOST := RecMQMSP.SP_LAST_PROG_TYPE;
        RecMQMSP.SP_RSC_CODE_HOST       := RecMQMSP.SP_RSC_CODE;
        RecMQMSP.SP_PROGRSTART_HOST     := RecMQMSP.SP_PROGRSTART;
        RecMQMSP.SP_CURR_PRG_DATE_HOST  := RecMQMSP.SP_CURR_PRG_DATE;
        RecMQMSP.SP_PROGREND_HOST       := RecMQMSP.SP_PROGREND;
        RecMQMSP.SP_QTY_HOST            := RecMQMSP.SP_QTY;
        RecMQMSP.SP_REMAIN_TIME_HOST    := RecMQMSP.SP_REMAIN_TIME;

        if (RecMQMSP.SP_LAST_PROG_TYPE <> '1') and (RecMQMSP.SP_LAST_PROG_TYPE <> '2')
        and (RecMQMSP.SP_LAST_PROG_TYPE <> '3') and (RecMQMSP.SP_LAST_PROG_TYPE <> '4') and
            (RecMQMSP.SP_LAST_PROG_TYPE <> '5') then
        begin
          Dispose(RecMQMSP);
          continue;
        end;

        if Assigned(List_ProgressOverride) and FindInProgressOverride(RecMQMSP) then
        begin
          Dispose(RecMQMSP);
          continue;
        end;

        if RecMQMSP.SP_RSC_CODE = '' then
        begin
          Dispose(RecMQMSP);
          continue;
        end;

        if ((RecMQMSP.SP_LAST_PROG_TYPE = '2') and (RecMQMSP.SP_PROGRSTART > RecMQMSP.SP_CURR_PRG_DATE)) or
           ((RecMQMSP.SP_LAST_PROG_TYPE = '3') and (RecMQMSP.SP_PROGRSTART > RecMQMSP.SP_PROGREND)) or
           ((RecMQMSP.SP_LAST_PROG_TYPE = '4') and (RecMQMSP.SP_PROGRSTART > RecMQMSP.SP_PROGREND)) or
           ((RecMQMSP.SP_LAST_PROG_TYPE = '5') and (RecMQMSP.SP_PROGRSTART > RecMQMSP.SP_PROGREND)) then
        begin
          Dispose(RecMQMSP);
          continue;
        end;

        // Initial progress //
        if (RecMQMSP.SP_LAST_PROG_TYPE = '1') then
        begin
          if RecMQMSP.SP_PROGRSTART = 0 then
          begin
            Dispose(RecMQMSP);
            continue;
          end;
          RecMQMSP.SP_PROGREND := 0;
        end;

        // Generic progress //
        if (RecMQMSP.SP_LAST_PROG_TYPE = '2') then
        begin
          if (RecMQMSP.SP_CURR_PRG_DATE = 0) then
          begin
            Dispose(RecMQMSP);
            continue;
          end;
          RecMQMSP.SP_PROGREND := 0;
          if (RecMQMSP.SP_PROGRSTART = 0) then
            RecMQMSP.SP_PROGRSTART := RecMQMSP.SP_CURR_PRG_DATE;

          if (RecMQMSP.SP_PROGRSTART = RecMQMSP.SP_CURR_PRG_DATE) then
             RecMQMSP.SP_PROGRSTART := RecMQMSP.SP_PROGRSTART - (1 /24 /60/60);
        end;

        // End of End and split progress //
        if (RecMQMSP.SP_LAST_PROG_TYPE = '3') or (RecMQMSP.SP_LAST_PROG_TYPE = '4') then
        begin
          if (RecMQMSP.SP_PROGREND = 0) then
          begin
            Dispose(RecMQMSP);
            continue;
          end;

  //************************************************
  //********ERAN 22/08/06 start 2.0.0.3 build 7 ****
  //************************************************
          if ((RecMQMSP.SP_LAST_PROG_TYPE = '4') and (RecMQMSP.SP_QTY <= 0)) or
             ((RecMQMSP.SP_LAST_PROG_TYPE = '5') and (RecMQMSP.SP_QTY <= 0)) then
          begin
            Dispose(RecMQMSP);
            continue;
          end;
  //************************************************
  //********ERAN 22/08/06 End   2.0.0.3 build 7 ****
  //************************************************
          if (RecMQMSP.SP_LAST_PROG_TYPE = '4') and (RecMQMSP.SP_PSUBST_ID < 0) then
          begin
            Dispose(RecMQMSP);
            continue;
          end;

          if (RecMQMSP.SP_PROGRSTART = 0) then
            RecMQMSP.SP_PROGRSTART := RecMQMSP.SP_CURR_PRG_DATE;

          if (RecMQMSP.SP_PROGRSTART = 0) then
            RecMQMSP.SP_PROGRSTART := RecMQMSP.SP_PROGREND;
          if (RecMQMSP.SP_PROGRSTART = RecMQMSP.SP_PROGREND) then
             RecMQMSP.SP_PROGRSTART := RecMQMSP.SP_PROGRSTART - (1 /24 /60/60);
        end;

        if Previous_Resource <> RecMQMSP.SP_RSC_CODE then
        begin
          Previous_Resource := RecMQMSP.SP_RSC_CODE;
          Resource_Exist := false;

          RecRes := FindInRes(RecMQMSP.SP_RSC_CODE);

          if RecRes <> nil then
          begin
            Resource_Exist := true;
            Number_Of_Resource_Components := RecRes.RS_NUM_RSC_COMP;
            RecMQMSP.SP_WORK_CENTER       := RecRes.RS_WKCNTER;
            RecMQMSP.SP_RES_CAT           := RecRes.RS_RES_CATEGORY;
            Previous_wc  := RecMQMSP.SP_WORK_CENTER;
            Previous_Cat := RecMQMSP.SP_RES_CAT;
          end;

        end
        else
        begin
          RecMQMSP.SP_WORK_CENTER := Previous_wc;
          RecMQMSP.SP_RES_CAT     := Previous_Cat;
        end;

        if not Resource_Exist then
        begin
          Dispose(RecMQMSP);
          continue;
        end;

        RecMQMPD := GetPDRecord(RecMQMSP.SP_PREQ_NO,RecMQMSP.SP_PSTEP_ID);

        if RecMQMPD = nil then
        begin
          Dispose(RecMQMSP);
          continue;
        end;

        RecMQMSP.SP_Step_Type := RecMQMPD.PD_STEP_TYP;
        if (RecMQMPD.PD_STEP_CLOSED = '1') and ((RecMQMSP.SP_LAST_PROG_TYPE = '1') or (RecMQMSP.SP_LAST_PROG_TYPE = '2')) then
        begin
          RecMQMSP.SP_LAST_PROG_TYPE := '3';
          RecMQMSP.SP_PROGREND := RecMQMSP.SP_CURR_PRG_DATE;
        end;

        RecMQMSP.SP_PD_INIT_QUENT := RecMQMPD.PD_INIT_QUENT;

        if (RecMQMSP.SP_LAST_PROG_TYPE = '4') or (RecMQMSP.SP_LAST_PROG_TYPE = '5') then
        begin
          if not FirstSplitProgress and (RecMQMSP.SP_LAST_PROG_TYPE <> ProgressSplitType) then
          begin
            Dispose(RecMQMSP);
            continue;
          end;
          ProgressSplitType := RecMQMSP.SP_LAST_PROG_TYPE;
          FirstSplitProgress := false;
        end;

        if RecMQMSP.SP_PSUBST_ID = (-1) then SubStepMinusOneFound := true;

        Progresses_Index := m_ProdCont.m_HostListSP.add(RecMQMSP);

      end;

      for J := Temp_PROGRESSES_List.Count - 1 downto 0 do
         dispose(PTPROGRESSES(Temp_PROGRESSES_List[J]));
      Temp_PROGRESSES_List.free;

      for j := 0 to RSC_List.Count - 1 do
         dispose(PRecRes(RSC_List[j]));
      RSC_List.Free;

      result := true;

    end;

    ////////////////////////// New Part ///////////////////////////////

    if (ProgressSplitType <> '4') and SubStepMinusOneFound then
    begin
      m_ProdCont.m_HostListSP.Sort(SortSPByReqStepDate);

      with QryPS do
      begin
        sql.Clear;
        sql.add('Select * from ' + tbProdSched.GetTableName);
        SQL.Add(' left join ' + tbRes.GetTableName + ' on ');
        SQL.Add(CreateFld(tbProdSched.pfx, fli_Rsc) + '=' + CreateFld(tbRes.pfx, fli_Rsc));
        SQL.Add(AND_IDF_Condition(CreateFld(tbRes.pfx, fli_IDENTIFIER)));
        SQL.Add(WHERE_IDF_Condition(CreateFld(tbProdSched.pfx, fli_IDENTIFIER)));
        sql.add(' Order by '  + CreateFld(tbProdSched.pfx,fli_preqNo)     + ',' + CreateFld(tbProdSched.pfx,fli_pstepId) +
                          ',' + CreateFld(tbProdSched.pfx,fli_schedStart) + ',' + CreateFld(tbProdSched.pfx,fli_psubstId) + ',' + CreateFld(tbProdSched.pfx,fli_reprocNo));
        Open;

        fldPS_preqNo   := FieldByName(CreateFld(tbProdSched.pfx, fli_preqNo));
        fldPS_pstepId  := FieldByName(CreateFld(tbProdSched.pfx, fli_pstepId));
        fldPS_psubstId := FieldByName(CreateFld(tbProdSched.pfx, fli_psubstId));
        fldPS_reprocNo := FieldByName(CreateFld(tbProdSched.pfx, fli_reprocNo));
        fldPS_Rsc      := FieldByName(CreateFld(tbProdSched.pfx, fli_Rsc));
        fldPS_RscCat   := FieldByName(CreateFld(tbRes.pfx, fli_RscCat));
        fldPS_wkCtrCode := FieldByName(CreateFld(tbRes.pfx, fli_wkCtrCode));
        fldPS_quant    := FieldByName(CreateFld(tbProdSched.pfx, fli_quant));

        IndexSp := 0;
        ListPS := nil;

        while (IndexSp <= m_ProdCont.m_HostListSP.count - 1) do
        begin

          CurrentRequest := PTMQMSP(m_ProdCont.m_HostListSP[IndexSp]).SP_PREQ_NO;
          CurrentStep    := PTMQMSP(m_ProdCont.m_HostListSP[IndexSp]).SP_PSTEP_ID;

          while (not QryPS.Eof) and (fldPS_preqNo.AsString < PTMQMSP(m_ProdCont.m_HostListSP[IndexSp]).SP_PREQ_NO) do
          begin
            Next;
          end;

          if not Assigned(ListPS) then
            ListPS := TList.Create;
          ListPS.Clear;

          while not Eof and (fldPS_preqNo.AsString = PTMQMSP(m_ProdCont.m_HostListSP[IndexSp]).SP_PREQ_NO)
                        and (fldPS_pstepId.AsInteger = PTMQMSP(m_ProdCont.m_HostListSP[IndexSp]).SP_PSTEP_ID) do
          begin
            New(RecMQMPS);
            RecMQMPS.PS_PREQ_NO     := fldPS_preqNo.AsString;
            RecMQMPS.PS_PSTEP_ID    := fldPS_pstepId.AsInteger;
            RecMQMPS.PS_PSUBST_ID   := fldPS_psubstId.AsInteger;
            RecMQMPS.PS_REPROCCS    := fldPS_reprocNo.AsInteger;
            RecMQMPS.PS_RSC         := fldPS_Rsc.AsString;
            RecMQMPS.PS_RESC_CAT    := fldPS_RscCat.AsString;
            RecMQMPS.PS_WORK_CENTER := fldPS_wkCtrCode.AsString;
            RecMQMPS.PS_QTY         := fldPS_quant.AsFloat;
            RecMQMPS.PS_MARKED      := false;
            ListPS.Add(RecMQMPS);
            Next
          end;

          if ListPS.Count = 0 then
          begin
            New(RecMQMPS);
            RecMQMPS.PS_PREQ_NO     := CurrentRequest;
            RecMQMPS.PS_PSTEP_ID    := CurrentStep;
            RecMQMPS.PS_PSUBST_ID   := 0;
            RecMQMPS.PS_REPROCCS    := 0;
            RecMQMPS.PS_QTY := PTMQMSP(m_ProdCont.m_HostListSP[IndexSp]).SP_PD_INIT_QUENT;
              RecMQMPS.PS_MARKED      := false;
              ListPS.Add(RecMQMPS);
          end;

          m_ProdCont.OrganizeSubStepsForProgress(ListPS, IndexSp);

          while (IndexSp <= m_ProdCont.m_HostListSP.count - 1) and (PTMQMSP(m_ProdCont.m_HostListSP[IndexSp]).SP_PREQ_NO = CurrentRequest) and
                (PTMQMSP(m_ProdCont.m_HostListSP[IndexSp]).SP_PSTEP_ID = CurrentStep) do
            Inc(IndexSp);
        end;

        if assigned(ListPS) then
        begin
          for I := 0 to ListPS.Count - 1 do
             Dispose(PTMQMPS(ListPS[I]));
          ListPS.free;
        end;

      end;

    end;

    //*******************************************************************/  }

    m_ProdCont.m_HostListSP.Sort(SortSP);

    if Assigned(List_ProgressOverride) then
    begin
      for I := List_ProgressOverride.Count -1 downto 0 do
        Dispose(PTMQMSPOVER(List_ProgressOverride[I]));
      List_ProgressOverride.Clear;
      List_ProgressOverride.free;
    end;

  end
  else
  begin
    OrderBy := ' Order by ' + CreateFld(tbProdProgress.pfx,fli_preqNo) + ',' + CreateFld(tbProdProgress.pfx,fli_pstepId) +
               ',' + CreateFld(tbProdProgress.pfx,fli_psubstId) + ',' + CreateFld(tbProdProgress.pfx,fli_reprocNo);
    Result :=  LoadSrvTable(tbl,'', OrderBy, fldListSP, srvQry, '');
  end;

  QryRS.Free;
  QryPS.Free;
end;

//----------------------------------------------------------------------------//

function AddProdStepTimes(tbl : table; srvQry: TMqmQuery; HostQry : TMqmQuery; IsHostQry : boolean; IsInsert : boolean): boolean;
var
  RecMQMST : PTMQMST;
  tbStepTimes:         ^TTblInfo;
  OrderBy : string;
  DndArchiveHostName : TDndArchiveName;
  PrevRequest, Request : String;
  PrevStep, Step : integer;
  PrevWorkCenter, WorkCenter : string;
  PrevCategory, Category : string;
  PrevResource, Resource : string;
  PrevMachineSetup, MachineSetup : string;
  // Pre-cached TField references for AS400 path
  fldST_0, fldST_1, fldST_2, fldST_3, fldST_4, fldST_5, fldST_6, fldST_7, fldST_8 : TField;
begin
  PrevRequest := '';
  Step := -1;
  PrevStep := -1;
  Assert(tbl = tbl_step_times);
  tbStepTimes := @tblInfo[tbl];
  DndArchiveHostName := GetDndArchiveHostName;
  if IsInsert then
  begin
    Result := InsertTable(tbl,fldListST,srvQry);
  end

  else if IsHostQry then
  begin

    if (Trim(IniAppGlobals.PreparationExeName) = '') then
    begin

      if DndArchiveHostName = TD_AS_400 then
        OrderBy := ' Order by QPRREQ,QPRSTP,QCDMAC,QCATRS,QCDRSC,QSETCD,QCDMAP'
      else
        OrderBy := ' Order by ' + CreateFld(tbStepTimes.pfx,fli_preqNo) + ',' + CreateFld(tbStepTimes.pfx,fli_pstepId) + ',' +
                   CreateFld(tbStepTimes.pfx,fli_wkCtrCode) + ',' + CreateFld(tbStepTimes.pfx,fli_rscCat) + ',' + CreateFld(tbStepTimes.pfx,fli_rsc) + ',' +
                   CreateFld(tbStepTimes.pfx,fli_MachSetupCode) + ',' + CreateFld(tbStepTimes.pfx,fli_wkcProc);

      Result := LoadTable(tbl, AS400Speclib, '','',OrderBy, fldListST, HostQry, 'QPRREQ', CreateFld(tbStepTimes.pfx,fli_preqNo));
      if DndArchiveHostName = TD_AS_400 then
      begin
        fldST_0 := HostQry.FieldByName(fldListST[0].fldAS);
        fldST_1 := HostQry.FieldByName(fldListST[1].fldAS);
        fldST_2 := HostQry.FieldByName(fldListST[2].fldAS);
        fldST_3 := HostQry.FieldByName(fldListST[3].fldAS);
        fldST_4 := HostQry.FieldByName(fldListST[4].fldAS);
        fldST_5 := HostQry.FieldByName(fldListST[5].fldAS);
        fldST_6 := HostQry.FieldByName(fldListST[6].fldAS);
        fldST_7 := HostQry.FieldByName(fldListST[7].fldAS);
        fldST_8 := HostQry.FieldByName(fldListST[8].fldAS);
      end;

      while not HostQry.Eof do
      begin
        if (m_ProdCont.m_HostListST.Count mod 500 = 0) then Application.ProcessMessages;

        if DndArchiveHostName = TD_AS_400 then
        begin
          Request := Trim(fldST_0.AsString);
          Step := fldST_1.AsInteger;
          WorkCenter := Trim(fldST_2.AsString);
          Category := Trim(fldST_4.AsString);
          Resource := Trim(fldST_5.AsString);
          MachineSetup := Trim(fldST_6.AsString);
        end
        else
        begin
          Request := Trim(HostQry.FieldByName(CreateFld(tbStepTimes.pfx, fldListST[0].fldPC)).AsString);
          Step := HostQry.FieldByName(CreateFld(tbStepTimes.pfx, fldListST[1].fldPC)).AsInteger;
          WorkCenter := Trim(HostQry.FieldByName(CreateFld(tbStepTimes.pfx, fldListST[2].fldPC)).AsString);
          Category := Trim(HostQry.FieldByName(CreateFld(tbStepTimes.pfx, fldListST[4].fldPC)).AsString);
          Resource := Trim(HostQry.FieldByName(CreateFld(tbStepTimes.pfx, fldListST[5].fldPC)).AsString);
          MachineSetup := Trim(HostQry.FieldByName(CreateFld(tbStepTimes.pfx, fldListST[6].fldPC)).AsString);
        end;

        if (PrevRequest <> '') and (PrevRequest = Request) and (PrevStep = Step) and
           (PrevWorkCenter = WorkCenter) and (PrevCategory = Category) and
           (PrevResource = Resource) and (PrevMachineSetup = MachineSetup) then
        begin
          HostQry.Next;
          continue;
        end;

        PrevRequest := Request;
        PrevStep := Step;
        PrevWorkCenter := WorkCenter;
        PrevCategory := Category;
        PrevResource := Resource;
        PrevMachineSetup := MachineSetup;

        New(RecMQMST);
        if DndArchiveHostName = TD_AS_400 then
        begin
          RecMQMST.ST_PREQ_NO                := Trim(fldST_0.AsString);
          RecMQMST.ST_PSTEP_ID               := fldST_1.AsInteger;
          RecMQMST.ST_WKCNTER                := Trim(fldST_2.AsString);
          RecMQMST.ST_WKCT_PROC              := Trim(fldST_3.AsString);
          RecMQMST.ST_RES_CATEGORY           := Trim(fldST_4.AsString);
          RecMQMST.ST_RSC_CODE               := Trim(fldST_5.AsString);
          RecMQMST.ST_SETUP_TIME_Mechin_Code := Trim(fldST_6.AsString);
          RecMQMST.ST_SETUP_TIME_JOB         := fldST_7.AsFloat;
          RecMQMST.ST_EXC_TIME_INIT_QTY      := fldST_8.AsFloat;
        end
        else
        begin
          RecMQMST.ST_PREQ_NO                := Trim(HostQry.FieldByName(CreateFld(tbStepTimes.pfx, fldListST[0].fldPC)).AsString);
          RecMQMST.ST_PSTEP_ID               :=      HostQry.FieldByName(CreateFld(tbStepTimes.pfx, fldListST[1].fldPC)).AsInteger;
          RecMQMST.ST_WKCNTER                := Trim(HostQry.FieldByName(CreateFld(tbStepTimes.pfx, fldListST[2].fldPC)).AsString);
          RecMQMST.ST_WKCT_PROC              := Trim(HostQry.FieldByName(CreateFld(tbStepTimes.pfx, fldListST[3].fldPC)).AsString);
          RecMQMST.ST_RES_CATEGORY           := Trim(HostQry.FieldByName(CreateFld(tbStepTimes.pfx, fldListST[4].fldPC)).AsString);
          RecMQMST.ST_RSC_CODE               := Trim(HostQry.FieldByName(CreateFld(tbStepTimes.pfx, fldListST[5].fldPC)).AsString);
          RecMQMST.ST_SETUP_TIME_Mechin_Code := Trim(HostQry.FieldByName(CreateFld(tbStepTimes.pfx, fldListST[6].fldPC)).AsString);
          RecMQMST.ST_SETUP_TIME_JOB         :=      HostQry.FieldByName(CreateFld(tbStepTimes.pfx, fldListST[7].fldPC)).AsFloat;
          RecMQMST.ST_EXC_TIME_INIT_QTY      :=      HostQry.FieldByName(CreateFld(tbStepTimes.pfx, fldListST[8].fldPC)).AsFloat;
        end;
        m_ProdCont.m_HostListST.add(RecMQMST);
        HostQry.Next;
      end;
      HostQry.Close;
      m_ProdCont.m_HostListST.Sort(SortST);
    end
    else
    begin
      UpdateOperation(_('Get prod_step_time list') + ' ' + (_('from host . . .')));
      m_ProdCont.m_HostListST := Get_Host_prod_step_time_list;
      m_ProdCont.m_HostListST.Sort(SortST);
      Result := true
    end;

  end
  else
  begin
    OrderBy := ' Order by ' + CreateFld(tbStepTimes.pfx,fli_preqNo) + ',' + CreateFld(tbStepTimes.pfx,fli_pstepId) + ',' +
                 CreateFld(tbStepTimes.pfx,fli_wkCtrCode) + ',' + CreateFld(tbStepTimes.pfx,fli_wkcProc) + ',' +
                 CreateFld(tbStepTimes.pfx,fli_rscCat) + ',' + CreateFld(tbStepTimes.pfx,fli_rsc) + ',' +
                 CreateFld(tbStepTimes.pfx,fli_MachSetupCode);
    Result :=  LoadSrvTable(tbl,'', OrderBy, fldListST, srvQry, '');
  end;

end;

//----------------------------------------------------------------------------//

function AddProducedArticle(tbl : table; srvQry: TMqmQuery; HostQry : TMqmQuery; IsHostQry : boolean ;IsInsert : boolean): boolean;
var
  RecMQMPA : PTMQMPA;
  tbProduced_Art : ^TTblInfo;
  OrderBy : string;
  DndArchiveHostName : TDndArchiveName;
  // Pre-cached TField references for AS400 path
  fldPA_0,  fldPA_1,  fldPA_2,  fldPA_3,  fldPA_4,
  fldPA_5,  fldPA_6,  fldPA_7,  fldPA_8,  fldPA_9, fldPA_10 : TField;
begin
  Assert(tbl = tbl_produced_article);
  tbProduced_Art := @tblInfo[tbl];
  DndArchiveHostName := GetDndArchiveHostName;
  if IsInsert then
  begin
    Result := InsertTable(tbl,fldListPA,srvQry);
  end

  else if IsHostQry then
  begin
    OrderBy := '';
    if (Trim(IniAppGlobals.PreparationExeName) = '') then
    begin

      Result := LoadTable(tbl, AS400Speclib, '', '',OrderBy, fldListPA, HostQry, 'APRREQ',CreateFld(tbProduced_Art.pfx,fli_preqNo));
      if DndArchiveHostName = TD_AS_400 then
      begin
        fldPA_0  := HostQry.FieldByName(fldListPA[0].fldAS);
        fldPA_1  := HostQry.FieldByName(fldListPA[1].fldAS);
        fldPA_2  := HostQry.FieldByName(fldListPA[2].fldAS);
        fldPA_3  := HostQry.FieldByName(fldListPA[3].fldAS);
        fldPA_4  := HostQry.FieldByName(fldListPA[4].fldAS);
        fldPA_5  := HostQry.FieldByName(fldListPA[5].fldAS);
        fldPA_6  := HostQry.FieldByName(fldListPA[6].fldAS);
        fldPA_7  := HostQry.FieldByName(fldListPA[7].fldAS);
        fldPA_8  := HostQry.FieldByName(fldListPA[8].fldAS);
        fldPA_9  := HostQry.FieldByName(fldListPA[9].fldAS);
        fldPA_10 := HostQry.FieldByName(fldListPA[10].fldAS);
      end;

      while not HostQry.Eof do
      begin
        if (m_ProdCont.m_HostListPA.Count mod 500 = 0) then Application.ProcessMessages;
        New(RecMQMPA);
        if DndArchiveHostName = TD_AS_400 then
        begin
          RecMQMPA.PA_PROD_REQ_NR         := Trim(fldPA_0.AsString);
          RecMQMPA.PA_SEQUENCE            := Trim(fldPA_1.AsString);
          RecMQMPA.PA_PROD_CODE           := Trim(fldPA_2.AsString);
          RecMQMPA.PA_NET_GROUP_Code      := Trim(fldPA_3.AsString);
          RecMQMPA.PA_ALL_REQ             := Trim(fldPA_4.AsString);
          RecMQMPA.PA_PROD_BALANCE        := Trim(fldPA_5.AsString);
          RecMQMPA.PA_RESOURCE            := Trim(fldPA_6.AsString);
          RecMQMPA.PA_SETTLED             := Trim(fldPA_7.AsString);
          RecMQMPA.PA_REQ_QUANTY          := fldPA_8.AsFloat;
          RecMQMPA.PA_QTY_PRODUCED        := fldPA_9.AsFloat;
          RecMQMPA.PA_QTY_ALL             := fldPA_10.AsFloat;
        end
        else
        begin
          RecMQMPA.PA_PROD_REQ_NR         := Trim(HostQry.FieldByName(CreateFld(tbProduced_Art.pfx, fldListPA[0].fldPC)).AsString);
          RecMQMPA.PA_SEQUENCE            := Trim(HostQry.FieldByName(CreateFld(tbProduced_Art.pfx, fldListPA[1].fldPC)).AsString);
          RecMQMPA.PA_PROD_CODE           := Trim(HostQry.FieldByName(CreateFld(tbProduced_Art.pfx, fldListPA[2].fldPC)).AsString);
          RecMQMPA.PA_NET_GROUP_Code      := Trim(HostQry.FieldByName(CreateFld(tbProduced_Art.pfx, fldListPA[3].fldPC)).AsString);
          RecMQMPA.PA_ALL_REQ             := Trim(HostQry.FieldByName(CreateFld(tbProduced_Art.pfx, fldListPA[4].fldPC)).AsString);
          RecMQMPA.PA_PROD_BALANCE        := Trim(HostQry.FieldByName(CreateFld(tbProduced_Art.pfx, fldListPA[5].fldPC)).AsString);
          RecMQMPA.PA_RESOURCE            := Trim(HostQry.FieldByName(CreateFld(tbProduced_Art.pfx, fldListPA[6].fldPC)).AsString);
          RecMQMPA.PA_SETTLED             := Trim(HostQry.FieldByName(CreateFld(tbProduced_Art.pfx, fldListPA[7].fldPC)).AsString);
          RecMQMPA.PA_REQ_QUANTY          := HostQry.FieldByName(CreateFld(tbProduced_Art.pfx, fldListPA[8].fldPC)).AsFloat;
          RecMQMPA.PA_QTY_PRODUCED        := HostQry.FieldByName(CreateFld(tbProduced_Art.pfx, fldListPA[9].fldPC)).AsFloat;
          RecMQMPA.PA_QTY_ALL             := HostQry.FieldByName(CreateFld(tbProduced_Art.pfx, fldListPA[10].fldPC)).AsFloat;
        end;
        m_ProdCont.m_HostlistPA.add(RecMQMPA);
        HostQry.Next;
      end;
      HostQry.Close;
      m_ProdCont.m_HostlistPA.Sort(SortPA)
    end
    else
    begin
      UpdateOperation(_('Get produced_article list') + ' ' + (_('from host . . .')));
      m_ProdCont.m_HostlistPA := Get_Host_produced_article_list;
      m_ProdCont.m_HostlistPA.Sort(SortPA);
      result := true
    end;

  end
  else
  begin
    OrderBy := ' Order by ' + CreateFld(tbProduced_Art.pfx,fli_preqNo) + ',' +
               CreateFld(tbProduced_Art.pfx,fli_sequenceChar) + ',' +
               CreateFld(tbProduced_Art.pfx,fli_ProdCode) + ',' +
               CreateFld(tbProduced_Art.pfx,fli_netGroupCode) + ',' +
               CreateFld(tbProduced_Art.pfx,fli_AllocReq);

    Result :=  LoadSrvTable(tbl,'', OrderBy, fldListPA, srvQry, '');
  end;
end;

//----------------------------------------------------------------------------//

function AddMaterial(tbl : table; srvQry: TMqmQuery; HostQry : TMqmQuery; IsHostQry : boolean ;IsInsert : boolean): boolean;
var
  RecMQMMT : PTMQMMT;
  tbMaterial : ^TTblInfo;
  OrderBy : string;
  DateTimeFormat : TDateTimeFormat;
  DndArchiveHostName : TDndArchiveName;
  ASCondition : string;
  // Pre-cached TField references for AS400 path
  fldMT_0,  fldMT_1,  fldMT_2,  fldMT_3,  fldMT_4,  fldMT_5,  fldMT_6,  fldMT_7,
  fldMT_8,  fldMT_9,  fldMT_10, fldMT_11, fldMT_12, fldMT_13, fldMT_14,
  fldMT_15, fldMT_16, fldMT_17, fldMT_18, fldMT_19 : TField;
begin
  Assert(tbl = tbl_Material);
  tbMaterial := @tblInfo[tbl];
  DndArchiveHostName := GetDndArchiveHostName;

  if DndArchiveHostName = TD_AS_400 then
  begin
    if GetLoopMqmCG then
      ASCondition := ' and HANNUL' + CAnnulFilter
    else
      ASCondition := ' where HANNUL' + CAnnulFilter;
  end;

  if IsInsert then
  begin
    Result := InsertTable(tbl,fldListMT,srvQry);
  end

  else if IsHostQry then
  begin
    if (Trim(IniAppGlobals.PreparationExeName) = '') then
    begin
      DateTimeFormat := GetDateTimeFormat;
      OrderBy := '';
      Result := LoadTable(tbl, AS400Speclib, ASCondition,'',OrderBy, fldListMT, HostQry, 'HPRREQ',CreateFld(tbMaterial.pfx,fli_preqNo));
      if DndArchiveHostName = TD_AS_400 then
      begin
        fldMT_0  := HostQry.FieldByName(fldListMT[0].fldAS);
        fldMT_1  := HostQry.FieldByName(fldListMT[1].fldAS);
        fldMT_2  := HostQry.FieldByName(fldListMT[2].fldAS);
        fldMT_3  := HostQry.FieldByName(fldListMT[3].fldAS);
        fldMT_4  := HostQry.FieldByName(fldListMT[4].fldAS);
        fldMT_5  := HostQry.FieldByName(fldListMT[5].fldAS);
        fldMT_6  := HostQry.FieldByName(fldListMT[6].fldAS);
        fldMT_7  := HostQry.FieldByName(fldListMT[7].fldAS);
        fldMT_8  := HostQry.FieldByName(fldListMT[8].fldAS);
        fldMT_9  := HostQry.FieldByName(fldListMT[9].fldAS);
        fldMT_10 := HostQry.FieldByName(fldListMT[10].fldAS);
        fldMT_11 := HostQry.FieldByName(fldListMT[11].fldAS);
        fldMT_12 := HostQry.FieldByName(fldListMT[12].fldAS);
        fldMT_13 := HostQry.FieldByName(fldListMT[13].fldAS);
        fldMT_14 := HostQry.FieldByName(fldListMT[14].fldAS);
        fldMT_15 := HostQry.FieldByName(fldListMT[15].fldAS);
        fldMT_16 := HostQry.FieldByName(fldListMT[16].fldAS);
        fldMT_17 := HostQry.FieldByName(fldListMT[17].fldAS);
        fldMT_18 := HostQry.FieldByName(fldListMT[18].fldAS);
        fldMT_19 := HostQry.FieldByName(fldListMT[19].fldAS);
      end;
      while not HostQry.Eof do
      begin
        if (m_ProdCont.m_HostListMT.Count mod 500 = 0) then Application.ProcessMessages;
        New(RecMQMMT);
        if DndArchiveHostName = TD_AS_400 then
        begin
          RecMQMMT.MT_PROD_REQ_Nr         := Trim(fldMT_0.AsString);
          RecMQMMT.MT_PSTEP_ID            := fldMT_1.AsInteger;
          RecMQMMT.MT_ORG_STEP            := fldMT_2.AsInteger;
          RecMQMMT.MT_WKCTR_CODE          := Trim(fldMT_3.AsString);
          RecMQMMT.MT_RES_CAT_CODE        := Trim(fldMT_4.AsString);
          RecMQMMT.MT_RES_CODE            := Trim(fldMT_5.AsString);
          RecMQMMT.MT_MACHIN_SETUP_CODE   := Trim(fldMT_6.AsString);
          RecMQMMT.MT_ALTERNATIVE_CODE    := Trim(fldMT_7.AsString);
          RecMQMMT.MT_PROD_TYPE           := Trim(fldMT_8.AsString);
          RecMQMMT.MT_PROD_CODE           := Trim(fldMT_9.AsString);
          RecMQMMT.MT_NET_GROUP_CODE      := Trim(fldMT_10.AsString);
          RecMQMMT.MT_ISSUE_CODE          := Trim(fldMT_11.AsString);
          RecMQMMT.MT_SEQ_ISSUED          := Trim(fldMT_12.AsString);
          RecMQMMT.MT_MAT_BALACE          := Trim(fldMT_13.AsString);
          RecMQMMT.MT_QUANTITY_ALLOC      := fldMT_14.AsFloat;
          if (DateTimeFormat = Frm_As400) then
            RecMQMMT.MT_HIGH_DATe_ALLOC := TimDateTimeToDateTime(fldMT_15.AsFloat)
          else if (DateTimeFormat = Frm_TDateTimeExceptControl) or (DateTimeFormat = Frm_TDateTime) then
            RecMQMMT.MT_HIGH_DATe_ALLOC := fldMT_15.AsFloat;
          RecMQMMT.MT_SEARCH_MAT_BY_ALLOC := Trim(fldMT_16.AsString);
          RecMQMMT.MT_SETTLED             := Trim(fldMT_17.AsString);
          RecMQMMT.MT_QUANTITY_ISSUE      := fldMT_18.AsFloat;
          RecMQMMT.MT_REQ_QUANTITY        := fldMT_19.AsFloat;
        end
        else
        begin
          RecMQMMT.MT_PROD_REQ_Nr         := Trim(HostQry.FieldByName(CreateFld(tbMaterial.pfx, fldListMT[0].fldPC)).AsString);
          RecMQMMT.MT_PSTEP_ID            := HostQry.FieldByName(CreateFld(tbMaterial.pfx, fldListMT[1].fldPC)).AsInteger;
          RecMQMMT.MT_ORG_STEP            := HostQry.FieldByName(CreateFld(tbMaterial.pfx, fldListMT[2].fldPC)).AsInteger;
          RecMQMMT.MT_WKCTR_CODE          := Trim(HostQry.FieldByName(CreateFld(tbMaterial.pfx, fldListMT[3].fldPC)).AsString);
          RecMQMMT.MT_RES_CAT_CODE        := Trim(HostQry.FieldByName(CreateFld(tbMaterial.pfx, fldListMT[4].fldPC)).AsString);
          RecMQMMT.MT_RES_CODE            := Trim(HostQry.FieldByName(CreateFld(tbMaterial.pfx, fldListMT[5].fldPC)).AsString);
          RecMQMMT.MT_MACHIN_SETUP_CODE   := Trim(HostQry.FieldByName(CreateFld(tbMaterial.pfx, fldListMT[6].fldPC)).AsString);
          RecMQMMT.MT_ALTERNATIVE_CODE    := Trim(HostQry.FieldByName(CreateFld(tbMaterial.pfx, fldListMT[7].fldPC)).AsString);
          RecMQMMT.MT_PROD_TYPE           := Trim(HostQry.FieldByName(CreateFld(tbMaterial.pfx, fldListMT[8].fldPC)).AsString);
          RecMQMMT.MT_PROD_CODE           := Trim(HostQry.FieldByName(CreateFld(tbMaterial.pfx, fldListMT[9].fldPC)).AsString);
          RecMQMMT.MT_NET_GROUP_CODE      := Trim(HostQry.FieldByName(CreateFld(tbMaterial.pfx, fldListMT[10].fldPC)).AsString);
          RecMQMMT.MT_ISSUE_CODE          := Trim(HostQry.FieldByName(CreateFld(tbMaterial.pfx, fldListMT[11].fldPC)).AsString);
          RecMQMMT.MT_SEQ_ISSUED          := Trim(HostQry.FieldByName(CreateFld(tbMaterial.pfx, fldListMT[12].fldPC)).AsString);
          RecMQMMT.MT_MAT_BALACE          := Trim(HostQry.FieldByName(CreateFld(tbMaterial.pfx, fldListMT[13].fldPC)).AsString);
          RecMQMMT.MT_QUANTITY_ALLOC      := HostQry.FieldByName(CreateFld(tbMaterial.pfx, fldListMT[14].fldPC)).AsFloat;
          RecMQMMT.MT_HIGH_DATe_ALLOC     := HostQry.FieldByName(CreateFld(tbMaterial.pfx, fldListMT[15].fldPC)).AsFloat;
          RecMQMMT.MT_SEARCH_MAT_BY_ALLOC := Trim(HostQry.FieldByName(CreateFld(tbMaterial.pfx, fldListMT[16].fldPC)).AsString);
          RecMQMMT.MT_SETTLED             := Trim(HostQry.FieldByName(CreateFld(tbMaterial.pfx, fldListMT[17].fldPC)).AsString);
          RecMQMMT.MT_QUANTITY_ISSUE      := HostQry.FieldByName(CreateFld(tbMaterial.pfx, fldListMT[18].fldPC)).AsFloat;
          RecMQMMT.MT_REQ_QUANTITY        := HostQry.FieldByName(CreateFld(tbMaterial.pfx, fldListMT[19].fldPC)).AsFloat;
        end;
        m_ProdCont.m_HostlistMT.add(RecMQMMT);
        HostQry.Next;
      end;
      HostQry.Close;
      m_ProdCont.m_HostlistMT.Sort(SortMT);
    end
    else
    begin
      UpdateOperation(_('Get material list') + ' ' + (_('from host . . .')));
      m_ProdCont.m_HostlistMT := Get_Host_material_list;
      m_ProdCont.m_HostlistMT.Sort(SortMT);
      result := true
    end;

  end
  else
  begin
    OrderBy := ' Order by ' + CreateFld(tbMaterial.pfx,fli_preqNo) + ',' +
               CreateFld(tbMaterial.pfx,fli_pstepId) + ',' +
         //      CreateFld(tbMaterial.pfx,fli_orgStep) + ',' +
               CreateFld(tbMaterial.pfx,fli_wkCtrCode) + ',' +
               CreateFld(tbMaterial.pfx,fli_ResCatcode) + ',' +
               CreateFld(tbMaterial.pfx,fli_rsc) + ',' +
               CreateFld(tbMaterial.pfx,fli_MachSetupCode) + ',' +
               CreateFld(tbMaterial.pfx,fli_AlternativCode) + ',' +
               CreateFld(tbMaterial.pfx,fli_prodtype) + ',' +
               CreateFld(tbMaterial.pfx,fli_ProdCode) + ',' +
               CreateFld(tbMaterial.pfx,fli_netGroupCode) + ',' +
               CreateFld(tbMaterial.pfx,fli_issueCode) + ',' +
               CreateFld(tbMaterial.pfx,fli_seqIssued);
    Result :=  LoadSrvTable(tbl,'', OrderBy, fldListMT, srvQry, '');
  end;

end;

//----------------------------------------------------------------------------//

function LoadTableCapRes(tbl: table; ASLib, AScondition, OrderCondition: string;
                   linkArr: array of TQryLinkRec;
                   HostQry: TMqmQuery ; AS_ProdRq : string): boolean;
var
  i     :          integer;
  tbInfo:         ^TTblInfo;
  tblName:        string;
  Str:            string;
  GeneralSQL:     String;
begin
  tbInfo := @tblInfo[tbl];

  UpdateOperation(_('Reading') + '  ' + tbInfo.ASname + '  ' + (_('from host . . .')));

  tblName  := ASLib + tbInfo.ASname;
  Result := true;

 // try
    // select the data from AS400
      with HostQry do
      begin
        SQL.Clear;
        if (not GetLoopMqmCG) then
        begin
          GeneralSQL := '';
          GeneralSQL := 'select ';
          for i := 0 to High(linkArr)-1 do
            GeneralSQL := GeneralSQL + linkArr[i].fldAS + ',';
          GeneralSQL := GeneralSQL + linkArr[High(linkArr)].fldAS + ' from ' + tblName;
          if AScondition <> '' then
            GeneralSQL := GeneralSQL + AScondition;
          if OrderCondition <> '' then
            GeneralSQL := GeneralSQL + OrderCondition;
          Application.ProcessMessages;
          SQL.Add(GeneralSQL);
          Open
        end
        else
        begin
          GeneralSQL := '';
          GeneralSQL := 'select * from MQMCG00f,' + tblName;
          Str := tblName + '.' + AS_ProdRq;
          GeneralSQL := GeneralSQL + ' where MQMCG00f.JPRREQ ' + '= ' + Str;
          if OrderCondition <> '' then
            GeneralSQL := GeneralSQL + OrderCondition;
          Application.ProcessMessages;
          SQL.Add(GeneralSQL);
          Open
        end
      end;

 // except
 //   Result := false;
 // end;

end;

//----------------------------------------------------------------------------//

procedure DeleteOldCapRes(CapDel : Integer);
var
  QryOldCapRes : TMqmQuery;
  tbInfo       : ^TTblInfo;
//  srvTrs       : TMqmTransaction;
begin
//  srvTrs := CreateTransaction;
  QryOldCapRes := ThreadCreateQuery(Main_DB);
  tbInfo := @tblInfo[tbl_capRes_Host];
  with QryOldCapRes do
  begin
    SQL.Clear;
  //  srvTrs.StartTransaction;
    SQL.Add('delete from ' + tbInfo.GetTableName);
    SQL.Add(' where ');
    SQL.Add(CreateFld(tbInfo.pfx, fli_CapacyResrv) + '=' + '''' + IntToStr(CapDel) + '''');
    ExecSQL;
    Application.ProcessMessages;
  end;
  QryOldCapRes.connection.Commit;
  QryOldCapRes.Close;
  QryOldCapRes.free;
end;

//----------------------------------------------------------------------------//

procedure DeleteOldCapResSrv(CapDel : Integer);
var
  QryOldCapRes : TMqmQuery;
  tbInfo       : ^TTblInfo;
//  srvTrs       : TMqmTransaction;
begin
//  srvTrs := CreateTransaction(Main_DB, false);
  QryOldCapRes := ThreadCreateQuery(Main_DB);
  tbInfo := @tblInfo[tbl_capRes];
  with QryOldCapRes do
  begin
    SQL.Clear;
   // srvTrs.StartTransaction;
    SQL.Add('delete from ' + tbInfo.GetTableName);
    SQL.Add(' where ');
    SQL.Add(CreateFld(tbInfo.pfx, fli_CapacyResrv) + '=' + '''' + IntToStr(CapDel) + '''');
    ExecSQL;
    Application.ProcessMessages;
  end;
  QryOldCapRes.Connection.Commit;
  QryOldCapRes.Close;
  QryOldCapRes.free;
end;

//----------------------------------------------------------------------------//

procedure PrepareListForCapResChange(HostList : TList; ServList : TList);
var
  J, IndexHost : Integer;
  RecMQMCR     : PTMQMCR;
  ToBeDelete   : boolean;
//  ListDelCapResSrv : TList;

{  function FindInOldHost(MQMCR : PTMQMCR) : boolean;
  var
    I : Integer;
  begin
    Result := false;
    for I := 0 to OLD_HostList.Count - 1 do
    begin
      if (MQMCR.CR_CAPACY_RESRV = PTMQMCR(OLD_HostList[I]).CR_CAPACY_RESRV) and
         (MQMCR.CR_RSC = PTMQMCR(OLD_HostList[I]).CR_RSC) and
         (MQMCR.CR_SCHEDULE_START = PTMQMCR(OLD_HostList[I]).CR_SCHEDULE_START) and
         (MQMCR.CR_SCHEDULE_END = PTMQMCR(OLD_HostList[I]).CR_SCHEDULE_END) then
      begin
        Result := true;
        Exit;
      end;
    end;
  end;  }

  function FindInHost(MQMCR : PTMQMCR ; var IndexHost : Integer) : boolean;
  var
    I : Integer;
  begin
    Result := false;
    for I := 0 to HostList.Count - 1 do
    begin
      if (MQMCR.CR_CAPACY_RESRV = PTMQMCR(HostList[I]).CR_CAPACY_RESRV) then
  //       (MQMCR.CR_RSC = PTMQMCR(HostList[I]).CR_RSC) and
  //       (MQMCR.CR_SCHEDULE_START = PTMQMCR(HostList[I]).CR_SCHEDULE_START) and
  //       (MQMCR.CR_SCHEDULE_END = PTMQMCR(HostList[I]).CR_SCHEDULE_END) then
      begin
        Result := true;
        IndexHost := I;
        Exit;
      end;
    end;
  end;

  function FindInSrvLod(MQMCR : PTMQMCR ; var ToBeDelete : boolean) : boolean;
  var
    I : Integer;
  begin
    Result := false;
    for I := 0 to ServList.Count - 1 do
    begin
      if (MQMCR.CR_CAPACY_RESRV = PTMQMCR(ServList[I]).CR_CAPACY_RESRV) then
      //   (MQMCR.CR_RSC = PTMQMCR(ServList[I]).CR_RSC) and
      //   (MQMCR.CR_SCHEDULE_START = PTMQMCR(ServList[I]).CR_SCHEDULE_START) and
      //   (MQMCR.CR_SCHEDULE_END = PTMQMCR(ServList[I]).CR_SCHEDULE_END) then
      begin
        Result := true;
        Exit;
      end;
      {else
      begin
        if (MQMCR.CR_CAPACY_RESRV = PTMQMCR(ServList[I]).CR_CAPACY_RESRV) then
           ToBeDelete := true;
      end; }

    end;
  end;

  function FindRscInList(Rscode : string) : boolean;
  var
    I : Integer;
  begin
    Result := false;
    for I := 0 to m_ProdCont.m_Rsc_Change_List.Count - 1 do
    begin
      if (Rscode = m_ProdCont.m_Rsc_Change_List.Strings[I]) then
      begin
        Result := true;
        Exit;
      end;
    end;
  end;

begin

  m_ProdCont.m_Cap_Res_Changed_list := TList.Create;
  m_ProdCont.m_Rsc_Change_List      := TStringList.Create;
//  ListDelCapResSrv := TList.Create;

  for J := 0 to ServList.Count - 1 do
  begin
    if FindInHost(PTMQMCR(ServList[J]), IndexHost) then
    begin
      if (PTMQMCR(ServList[J]).CR_RSC              <> PTMQMCR(HostList[IndexHost]).CR_RSC) or
         (PTMQMCR(ServList[J]).CR_SCHEDULE_START   <> PTMQMCR(HostList[IndexHost]).CR_SCHEDULE_START) or
         (PTMQMCR(ServList[J]).CR_SCHEDULE_END     <> PTMQMCR(HostList[IndexHost]).CR_SCHEDULE_END) or
         (PTMQMCR(ServList[J]).CR_SUB_LINE_RES     <> PTMQMCR(HostList[IndexHost]).CR_SUB_LINE_RES) or
         (PTMQMCR(ServList[J]).CR_WC_PROCESS       <> PTMQMCR(HostList[IndexHost]).CR_WC_PROCESS) or
         (PTMQMCR(ServList[J]).CR_CAPRES_TYPE      <> PTMQMCR(HostList[IndexHost]).CR_CAPRES_TYPE) or
         (PTMQMCR(ServList[J]).CR_CAPACITY_To_JOB  <> PTMQMCR(HostList[IndexHost]).CR_CAPACITY_To_JOB) or
         (PTMQMCR(ServList[J]).CR_COMMENTS         <> PTMQMCR(HostList[IndexHost]).CR_COMMENTS) then
      begin
        //  found Updated one
        new(RecMQMCR);
        RecMQMCR.CR_CAPACY_RESRV := PTMQMCR(HostList[IndexHost]).CR_CAPACY_RESRV;
        RecMQMCR.CR_RSC          := PTMQMCR(HostList[IndexHost]).CR_RSC;
        RecMQMCR.CR_SUB_LINE_RES := PTMQMCR(HostList[IndexHost]).CR_SUB_LINE_RES;
        RecMQMCR.CR_WC_PROCESS   := PTMQMCR(HostList[IndexHost]).CR_WC_PROCESS;
        RecMQMCR.CR_CAPRES_TYPE  := PTMQMCR(HostList[IndexHost]).CR_CAPRES_TYPE;
        RecMQMCR.CR_CAPACITY_To_JOB := PTMQMCR(HostList[IndexHost]).CR_CAPACITY_To_JOB;
        RecMQMCR.CR_COMMENTS        := PTMQMCR(HostList[IndexHost]).CR_COMMENTS;
        RecMQMCR.CR_SCHEDULE_START  := PTMQMCR(HostList[IndexHost]).CR_SCHEDULE_START;
        RecMQMCR.CR_SCHEDULE_END    := PTMQMCR(HostList[IndexHost]).CR_SCHEDULE_END;
        RecMQMCR.CR_USR_CG          := PTMQMCR(HostList[IndexHost]).CR_USR_CG;
        RecMQMCR.CR_USR_TM_CG       := PTMQMCR(HostList[IndexHost]).CR_USR_TM_CG;
        RecMQMCR.CR_CAP_RES_TYPE_CHANGE := UpdateCap;
        m_ProdCont.m_Cap_Res_Changed_list.Add(RecMQMCR);
      end;
    end
    else
    begin
      //  found deleted one
      new(RecMQMCR);
      RecMQMCR.CR_CAPACY_RESRV        := PTMQMCR(ServList[J]).CR_CAPACY_RESRV;
      RecMQMCR.CR_RSC                 := PTMQMCR(ServList[J]).CR_RSC;
      RecMQMCR.CR_CAP_RES_TYPE_CHANGE := DeleteCap;
      m_ProdCont.m_Cap_Res_Changed_list.Add(RecMQMCR);
    end;

  end;

  //  found new one
  for IndexHost := 0 to HostList.Count - 1 do
  begin
    ToBeDelete := false;
    if not FindInSrvLod(HostList[IndexHost], ToBeDelete) then
    begin
      //if ToBeDelete then
      //  ListDelCapResSrv.add(HostList[IndexHost]);

     // if FindInOldHost(HostList[IndexHost]) then
     //    continue;
      new(RecMQMCR);
      RecMQMCR.CR_CAPACY_RESRV        := PTMQMCR(HostList[IndexHost]).CR_CAPACY_RESRV;
      RecMQMCR.CR_RSC                 := PTMQMCR(HostList[IndexHost]).CR_RSC;
      RecMQMCR.CR_SUB_LINE_RES        := PTMQMCR(HostList[IndexHost]).CR_SUB_LINE_RES;
      RecMQMCR.CR_WC_PROCESS          := PTMQMCR(HostList[IndexHost]).CR_WC_PROCESS;
      RecMQMCR.CR_CAPRES_TYPE         := PTMQMCR(HostList[IndexHost]).CR_CAPRES_TYPE;
      RecMQMCR.CR_CAPACITY_To_JOB     := PTMQMCR(HostList[IndexHost]).CR_CAPACITY_To_JOB;
      RecMQMCR.CR_COMMENTS            := PTMQMCR(HostList[IndexHost]).CR_COMMENTS;
      RecMQMCR.CR_SCHEDULE_START      := PTMQMCR(HostList[IndexHost]).CR_SCHEDULE_START;
      RecMQMCR.CR_SCHEDULE_END        := PTMQMCR(HostList[IndexHost]).CR_SCHEDULE_END;
      RecMQMCR.CR_USR_CG              := PTMQMCR(HostList[IndexHost]).CR_USR_CG;
      RecMQMCR.CR_USR_TM_CG           := PTMQMCR(HostList[IndexHost]).CR_USR_TM_CG;
      RecMQMCR.CR_CAP_RES_TYPE_CHANGE := NewCap;
      m_ProdCont.m_Cap_Res_Changed_list.Add(RecMQMCR);
    end;
  end;

  for J := 0 to m_ProdCont.m_Cap_Res_Changed_list.Count - 1 do
  begin
    if not FindRscInList(PTMQMCR(m_ProdCont.m_Cap_Res_Changed_list[J]).CR_RSC) then
       m_ProdCont.m_Rsc_Change_List.add(PTMQMCR(m_ProdCont.m_Cap_Res_Changed_list[J]).CR_RSC);
  end;

{  if (OLD_HostList.Count > 0) then
  begin
    for J := 0 to OLD_HostList.Count - 1 do
    begin
      if not FindInHost(OLD_HostList[J], IndexHost) then
         DeleteOldCapRes(PTMQMCR(OLD_HostList[J]).CR_CAPACY_RESRV);
    end;
  end;

  if ListDelCapResSrv.Count > 0 then
  begin
    for J := 0 to ListDelCapResSrv.Count - 1 do
    begin
      DeleteOldCapResSrv(PTMQMCR(ListDelCapResSrv[J]).CR_CAPACY_RESRV);
    end;
  end;         }

//  ListDelCapResSrv.Free;

end;

//----------------------------------------------------------------------------//

procedure CapResCompare(tbl : table; HostList : TList; ServList : TList);
var
  J, IndexHost : Integer;
  RecMQMCR     : PTCapRes;
  ToBeDelete   : boolean;
  tbCapRes     : ^TTblInfo;
  sql : String;
  USDateFormat: TFormatSettings;

  function FindInHost(MQMCR : PTCapRes ; var IndexHost : Integer) : boolean;
  var
    I : Integer;
  begin
    Result := false;
    for I := 0 to HostList.Count - 1 do
    begin
      if (MQMCR.CR_COMMENTS = PTCapRes(HostList[I]).CR_COMMENTS) then
      begin
        Result := true;
        IndexHost := I;
        Exit;
      end;
    end;
  end;

  function FindInSrvLod(MQMCR : PTCapRes ; var ToBeDelete : boolean) : boolean;
  var
    I : Integer;
  begin
    Result := false;
    for I := 0 to ServList.Count - 1 do
    begin
      if (MQMCR.CR_COMMENTS = PTCapRes(ServList[I]).CR_COMMENTS) then
      begin
        Result := true;
        Exit;
      end;
    end;
  end;

  Function GetListForDelete : String;
  var
    I,j : Integer;
    found : Boolean;
  begin

      Result := '( ';

      for j := 0 to HostList.Count - 1 do
       Result := Result + QuotedStr(PTCapRes(HostList[j]).CR_COMMENTS) + ', ';

      Result := copy(Result,0,length(Result)-2);
      Result := Result + ')';

      if result = ')'  then result := '';

  end;

  function FindRscInList(Rscode : string) : boolean;
  var
    I : Integer;
  begin
    Result := false;
    for I := 0 to m_ProdCont.m_Rsc_Change_List.Count - 1 do
    begin
      if (Rscode = m_ProdCont.m_Rsc_Change_List.Strings[I]) then
      begin
        Result := true;
        Exit;
      end;
    end;
  end;


begin
  Assert(tbl = tbl_capRes);
  tbCapRes := @tblInfo[tbl];
  USDateFormat := TFormatSettings.Create('');

  m_ProdCont.m_Cap_Res_Changed_list := TList.Create;
  m_ProdCont.m_Rsc_Change_List      := TStringList.Create;


  for J := 0 to ServList.Count - 1 do
  begin
    if FindInHost(PTCapRes(ServList[J]), IndexHost) then
    begin
      if (PTCapRes(ServList[J]).CR_RSC              <> PTCapRes(HostList[IndexHost]).CR_RSC) or
         (DateTimeToStr(PTCapRes(ServList[J]).CR_SCHEDULE_START) <> DateTimeToStr(PTCapRes(HostList[IndexHost]).CR_SCHEDULE_START)) or
         (DateTimeToStr(PTCapRes(ServList[J]).CR_SCHEDULE_END)     <> DateTimeToStr(PTCapRes(HostList[IndexHost]).CR_SCHEDULE_END)) or
       //  (StrToDateTime(FormatDateTime('mm/dd/yyyy hh:mm:ss', PTCapRes(ServList[J]).CR_SCHEDULE_START))   <> PTCapRes(HostList[IndexHost]).CR_SCHEDULE_START) or
       //  (StrToDateTime(FormatDateTime('mm/dd/yyyy hh:mm:ss', PTCapRes(ServList[J]).CR_SCHEDULE_END))     <> PTCapRes(HostList[IndexHost]).CR_SCHEDULE_END) or
         (PTCapRes(ServList[J]).CR_CAPRES_TYPE      <> PTCapRes(HostList[IndexHost]).CR_CAPRES_TYPE) then
      begin
        //  found Updated one

        New(RecMQMCR);
       // RecMQMCR.CR_CAPACY_RESRV := PTCapRes(HostList[IndexHost]).CR_CAPACY_RESRV;
        RecMQMCR.CR_CAPACY_RESRV := PTCapRes(ServList[J]).CR_CAPACY_RESRV;
        RecMQMCR.CR_RSC          := PTCapRes(HostList[IndexHost]).CR_RSC;
        RecMQMCR.CR_SUB_LINE_RES := PTCapRes(HostList[IndexHost]).CR_SUB_LINE_RES;
        RecMQMCR.CR_WC_PROCESS   := PTCapRes(HostList[IndexHost]).CR_WC_PROCESS;
        RecMQMCR.CR_CAPRES_TYPE  := PTCapRes(HostList[IndexHost]).CR_CAPRES_TYPE;
        RecMQMCR.CR_CAPACITY_To_JOB := PTCapRes(HostList[IndexHost]).CR_CAPACITY_To_JOB;
        RecMQMCR.CR_COMMENTS        := PTCapRes(HostList[IndexHost]).CR_COMMENTS;
        RecMQMCR.CR_SCHEDULE_START  := PTCapRes(HostList[IndexHost]).CR_SCHEDULE_START;
        RecMQMCR.CR_SCHEDULE_END    := PTCapRes(HostList[IndexHost]).CR_SCHEDULE_END;
        RecMQMCR.CR_USR_CG          := PTCapRes(HostList[IndexHost]).CR_USR_CG;
        RecMQMCR.CR_USR_TM_CG       := PTCapRes(HostList[IndexHost]).CR_USR_TM_CG;
        RecMQMCR.CR_CAP_RES_TYPE_CHANGE := UpdateCap;
        m_ProdCont.m_Cap_Res_Changed_list.Add(RecMQMCR);
      end;
    end else
    begin
      //found deleted one
      new(RecMQMCR);
      RecMQMCR.CR_CAPACY_RESRV        := PTCapRes(ServList[J]).CR_CAPACY_RESRV;
      RecMQMCR.CR_RSC                 := PTCapRes(ServList[J]).CR_RSC;
    //  RecMQMCR.CR_COMMENTS            := PTCapRes(HostList[IndexHost]).CR_COMMENTS;
      RecMQMCR.CR_COMMENTS            := PTCapRes(ServList[J]).CR_COMMENTS;
      RecMQMCR.CR_CAP_RES_TYPE_CHANGE := DeleteCap;
      m_ProdCont.m_Cap_Res_Changed_list.Add(RecMQMCR);
    end;
  end;

  //  found new one
  for IndexHost := 0 to HostList.Count - 1 do
  begin
    ToBeDelete := false;
    if not FindInSrvLod(HostList[IndexHost], ToBeDelete) then
    begin
      new(RecMQMCR);
      RecMQMCR.CR_CAPACY_RESRV        := m_LowestNumber_CapRes;//PTCapRes(HostList[IndexHost]).CR_CAPACY_RESRV;
      RecMQMCR.CR_RSC                 := PTCapRes(HostList[IndexHost]).CR_RSC;
      RecMQMCR.CR_SUB_LINE_RES        := PTCapRes(HostList[IndexHost]).CR_SUB_LINE_RES;
      RecMQMCR.CR_WC_PROCESS          := PTCapRes(HostList[IndexHost]).CR_WC_PROCESS;
      RecMQMCR.CR_CAPRES_TYPE         := PTCapRes(HostList[IndexHost]).CR_CAPRES_TYPE;
      RecMQMCR.CR_CAPACITY_To_JOB     := PTCapRes(HostList[IndexHost]).CR_CAPACITY_To_JOB;
      RecMQMCR.CR_COMMENTS            := PTCapRes(HostList[IndexHost]).CR_COMMENTS;
      RecMQMCR.CR_SCHEDULE_START      := PTCapRes(HostList[IndexHost]).CR_SCHEDULE_START;
      RecMQMCR.CR_SCHEDULE_END        := PTCapRes(HostList[IndexHost]).CR_SCHEDULE_END;
      RecMQMCR.CR_USR_CG              := PTCapRes(HostList[IndexHost]).CR_USR_CG;
      RecMQMCR.CR_USR_TM_CG           := PTCapRes(HostList[IndexHost]).CR_USR_TM_CG;
      RecMQMCR.CR_CAP_RES_TYPE_CHANGE := NewCap;
      m_ProdCont.m_Cap_Res_Changed_list.Add(RecMQMCR);
      dec(m_LowestNumber_CapRes);
    end;
  end;

  for J := 0 to m_ProdCont.m_Cap_Res_Changed_list.Count - 1 do
  begin
    if not FindRscInList(PTCapRes(m_ProdCont.m_Cap_Res_Changed_list[J]).CR_RSC) then
       m_ProdCont.m_Rsc_Change_List.add(PTCapRes(m_ProdCont.m_Cap_Res_Changed_list[J]).CR_RSC);
  end;

end;

function AddCapRes(tbl : table; srvQry: TMqmQuery; HostQry : TMqmQuery; IsHostQry : boolean ;IsInsert : boolean): boolean;
var
  RecMQMCR : PTMQMCR;
  RecMQMCRWKC : PTMQMCRWKC;
  CapRes : PTCapRes;
  tbCapRes,tbWKC : ^TTblInfo;
  OrderBy : string;
  DateTimeFormat : TDateTimeFormat;
  HostList, ServList, ResWKC : TList;
  I : Integer;
  StartTime,sql, Comment, MACHINE, WKC : string;
  DndArchiveHostName : TDndArchiveName;
  DndArchiveLocName : TDndArchiveName;
  LastEnd ,LastStart : TDatetime;
//  ActiveWKC : TStringlist;
  ArcQry : TMQMQuery;
  TableName, tbName,TableNameLoc, tbNameLoc : string;
const
  fldList: array [0..8] of TQryLinkRec = (
    (fldPC: fli_CapacyResrv;     fldAS: 'UCAPNM'; fldType: TLD_integer),
    (fldPC: fli_rsc;             fldAS: 'UPRRSC'; fldType: TLD_string),
    (fldPC: fli_subLinRscId;     fldAS: 'URSCSL'; fldType: TLD_integer),
    (fldPC: fli_WCProcess;       fldAS: 'UCDMAP'; fldType: TLD_string),
    (fldPC: fli_CapacyResTyp;    fldAS: 'UCAPTP'; fldType: TLD_string),
    (fldPC: fli_Capacity_To_Job; fldAS: 'UCASEX'; fldType: TLD_string),
    (fldPC: fli_Comment;         fldAS: 'UCOMME'; fldType: TLD_string),
    (fldPC: fli_schedStart;      fldAS: 'USTSDT'; fldType: TLD_dateTime),
    (fldPC: fli_schedEnd;        fldAS: 'UENSDT'; fldType: TLD_dateTime)
//    (fldPC: fli_usrCr;           fldAS: 'UUSRCR'; fldType: TLD_string),
//    (fldPC: fli_usrTmCr;         fldAS: 'UDTOCR'; fldType: TLD_dateTime),
//    (fldPC: fli_usrCg;           fldAS: 'UUSRCH'; fldType: TLD_string),
//   (fldPC: fli_usrTmCg;         fldAS: 'UDTOCH'; fldType: TLD_dateTime)
  );

 { function GetWKCfromRes(rescode : String) : String;
  var i : Integer;
  begin
    Result := '';
    for I := 0 to ResWKC.Count - 1 do
    begin
      if PTMQMCRWKC(ResWkc[i]).CRW_RSC = rescode then
      begin
        result := PTMQMCRWKC(ResWkc[i]).CRW_Wkc;
        Exit;
      end;
    end;
  end; }

begin
  Assert(tbl = tbl_capRes);
  tbCapRes := @tblInfo[tbl];
  tbWkc := @tblInfo[tbl_wkc];
  Result := true;
  DndArchiveHostName := GetDndArchiveHostName;
  DndArchiveLocName := GetDndArchiveLocalName;
  ArcQry := ThreadCreateQueryArc;

  if DndArchiveHostName <> TD_AS_400 then
  begin
    UpdateOperation(_('Updating') + '  ' + _('MACHINE DOWN TIME') + ' ' + (_('from host . . .')));
    HostList := TList.Create;
    ServList := TList.Create;
   // ActiveWKC:= TStringList.Create;
  //  ResWKC   := TList.Create;

    HostQry.SQL.Clear;

    if IniAppGlobals.downloadFrom = '0' then
      HostQry.SQL.Add('Select * from syscat.columns '
        +' where tabname = '+QuotedStr('PRODUCTIONPROGRESS')+' AND COLNAME = '+QuotedStr('MACHINEDOWNTIMETYPE'))
    else if IniAppGlobals.downloadFrom = '1' then
      HostQry.SQL.Add('Select * from user_tab_columns '
        +' where table_name = '+QuotedStr('PRODUCTIONPROGRESS')+' AND column_name = '+QuotedStr('MACHINEDOWNTIMETYPE'));
    HostQry.open;
    if HostQry.FindField('MACHINEDOWNTIMETYPE') = nil then exit;

    SrvQry.Transaction := ThreadCreateTransaction(Main_DB);
    ArcQry := ThreadCreateQueryArc;

{    if DndArchiveHostName = TD_Interbase then
    begin
      TableName := 'WKC';
      tbName := 'RES';
    end else
    begin
      TableName := 'SCDA_WKC';
      tbName := 'SCDA_RES';
    end;    }

    if DndArchiveLocName = TD_Interbase then
    begin
      TableNameLoc := 'WKC';
      tbNameLoc := 'RES';
    end else
    begin
      TableNameLoc := 'SCDA_WKC';
      tbNameLoc := 'SCDA_RES';
    end;
      {
    //Collect all active WKC
    ArcQry.SQL.Text := 'SELECT * FROM ' + TableNameLoc +' WHERE ' +
               'WC_HANDLEDBYMQM = ' + QuotedStr('1') + ' OR ' +
               'WC_HANDLEDBYMCM = ' + QuotedStr('1') +
                AND_IDF_Condition('WC_IDENTIFIER') +
               'ORDER BY WC_WKCNTER';
    ArcQry.Open;

    while not ArcQry.eof do
    begin
      ActiveWKC.Add(Trim(ArcQry.FieldByName('WC_WKCNTER').AsString));
      ArcQry.Next
    end;

    ArcQry.Close;
    ArcQry.SQL.Text := 'SELECT RS_RSC_CODE,RS_WKCNTER FROM ' + tbNameLoc +
                WHERE_IDF_Condition('RS_IDENTIFIER')
                + ' and RS_WKCNTER is not null'
                + ' ORDER BY RS_RSC_CODE, RS_WKCNTER';
    ArcQry.Open;

    while not ArcQry.eof do
    begin
      New(RecMQMCRWKC);
      RecMQMCRWKC.CRW_WKC                 := ArcQry.FieldByName('RS_WKCNTER').AsString;
      RecMQMCRWKC.CRW_RSC                 := ArcQry.FieldByName('RS_RSC_CODE').AsString;
      ResWKC.add(RecMQMCRWKC);
      ArcQry.Next;
    end;    }

    HostQry.SQL.Clear;
    HostQry.SQL.Add('select WORKCENTERCODE, COMPANYCODE, PROGRESSNUMBER, PROGRESSTEMPLATECODE, PROGRESSSTARTQUEUEDATE'
      + ', PROGRESSSTARTQUEUETIME, PROGRESSENDDATE, PROGRESSENDTIME, MACHINECODE, MACHINEDOWNTIMETYPE ');
    HostQry.SQL.Add('From productionprogress ');
    HostQry.SQL.Add('WHERE COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode));
    HostQry.SQL.Add(' AND PROGRESSTYPE = ' + QuotedStr('A'));
    HostQry.SQL.Add(' AND INACTIVE = ' + IntToStr(1));
    HostQry.SQL.Add(' AND (PROGRESSSTARTQUEUEDATE is not null or PROGRESSENDDATE is not null)');
    HostQry.SQL.Add(' AND MACHINECODE is not null');
    HostQry.SQL.Add(' AND MACHINEDOWNTIMETYPE in ' + '(' + QuotedStr('1') + ',' + QuotedStr('2') + ')');
    if IniAppGlobals.downloadFrom = '1' then //oracle
    begin
      HostQry.SQL.Add(' and (PROGRESSSTARTQUEUEDATE is null or PROGRESSSTARTQUEUEDATE > current_date - 90)'); //Show only in last 3 months
      HostQry.SQL.Add(' and (PROGRESSENDDATE is null or PROGRESSENDDATE > current_date - 90)');
    end else //db2
    begin
      HostQry.SQL.Add(' and (PROGRESSSTARTQUEUEDATE is null or PROGRESSSTARTQUEUEDATE > current_date - 90 days)'); //Show only in last 3 months
      HostQry.SQL.Add(' and (PROGRESSENDDATE is null or PROGRESSENDDATE > current_date - 90 days)');
    end;
    HostQry.SQL.Add(' Order by MACHINECODE, COALESCE(PROGRESSSTARTQUEUEDATE, PROGRESSENDDATE), COALESCE(PROGRESSSTARTQUEUETIME, PROGRESSENDTIME)');
    HostQry.open;

    LastStart := 0;
    LastEnd := 0;

    while not HostQry.Eof do
    begin



      //If WKC does not exists in Server, then skip that resource
      {
      if (ActiveWKC.IndexOf(HostQry.FieldByName('WORKCENTERCODE').AsString) = -1)
      and (LastStart = 0) then
      begin
        HostQry.Next;
        Continue
      end;

      if (GetWkcFromRes(HostQry.FieldByName('MACHINECODE').AsString) = '')
      and (LastStart = 0) then
      begin
          HostQry.Next;
          Continue  ;
      end; }

      //LastStart := Now - 100;

      //    WAS UNTIL 6.18.2021.
    // if DateTimeToStr(HostQry.FieldByName('PROGRESSENDDATE').asDateTime) = '' then
    //  begin
    //    LastStart := StrToDateTime(FormatDateTIme(FormatSettings.ShortDateFormat,HostQry.FieldByName('PROGRESSSTARTQUEUEDATE').asDateTime)) + Frac(HostQry.FieldByName('PROGRESSSTARTQUEUETIME').AsDateTime) ;
    //    HostQry.Next;
    //  end else
    //    LastStart  := StrToDateTime(FormatDateTIme(FormatSettings.ShortDateFormat,Now - 100));

    //  LastEnd := StrToDateTime(FormatDateTIme(FormatSettings.ShortDateFormat,HostQry.FieldByName('PROGRESSENDDATE').asDateTime)) + Frac(HostQry.FieldByName('PROGRESSENDTIME').AsDateTime);
    //

        //NEW LOGIC

      if  (LastStart <> 0)  // Last Start <> 0
      and (HostQry.FieldByName('MACHINECODE').asString <> MACHINE)  //current machine <> previous machine
      and (LastEnd = 0)
      then
      begin
        LastEnd := LastStart + (1/1440);  //ADD 1 minute to EndDate

        New(CapRes);
        CapRes.CR_WKC                 := WKC;
        CapRes.CR_CAPACY_RESRV        := -1;
        CapRes.CR_RSC                 := MACHINE;
        CapRes.CR_SUB_LINE_RES        := -1;
        CapRes.CR_WC_PROCESS          := '';

        if HostQry.FieldByName('MACHINEDOWNTIMETYPE').asString = '1' then
          CapRes.CR_CAPRES_TYPE         := '3'
        else
          CapRes.CR_CAPRES_TYPE         := '2';

        CapRes.CR_CAPACITY_To_JOB     := '0';
        CapRes.CR_COMMENTS            := Comment;
        CapRes.CR_SCHEDULE_START      := LastStart;
        CapRes.CR_SCHEDULE_END        := LastEnd;
        CapRes.CR_USR_CG              := ' ';
        CapRes.CR_USR_TM_CG           := 0;

        HostList.add(CapRes);
        LastStart := 0;
        LastEnd := 0;
        Comment := '';
        WKC     := '';
        MACHINE := '';
      end;

      if  (HostQry.FieldByName('PROGRESSENDDATE').asDateTime <> 0) //end <> 0
      and (HostQry.FieldByName('PROGRESSSTARTQUEUEDATE').asDateTime <> 0) //start <> 0
      and (LastStart = 0)
      then
      begin
        if DndArchiveHostName = TD_Oracle then
        begin
          LastStart := StrToDateTime(FormatDateTIme(FormatSettings.ShortDateFormat,HostQry.FieldByName('PROGRESSSTARTQUEUEDATE').asDateTime)) + Frac(HostQry.FieldByName('PROGRESSSTARTQUEUETIME').AsDateTime) ;
          LastEnd := StrToDateTime(FormatDateTIme(FormatSettings.ShortDateFormat,HostQry.FieldByName('PROGRESSENDDATE').asDateTime)) + Frac(HostQry.FieldByName('PROGRESSENDTIME').AsDateTime) ;
        end else
        begin
          LastStart := StrToDateTime(FormatDateTIme(FormatSettings.ShortDateFormat,HostQry.FieldByName('PROGRESSSTARTQUEUEDATE').asDateTime)) + HostQry.FieldByName('PROGRESSSTARTQUEUETIME').AsDateTime ;
          LastEnd := StrToDateTime(FormatDateTIme(FormatSettings.ShortDateFormat,HostQry.FieldByName('PROGRESSENDDATE').asDateTime)) + HostQry.FieldByName('PROGRESSENDTIME').AsDateTime ;
        end;

        Comment := Trim(HostQry.FieldByName('COMPANYCODE').AsString) + ' ' + Trim(HostQry.FieldByName('PROGRESSNUMBER').AsString);
        WKC     := Trim(HostQry.FieldByName('WORKCENTERCODE').AsString);
        MACHINE := Trim(HostQry.FieldByName('MACHINECODE').AsString);
      end;

      if  (HostQry.FieldByName('PROGRESSENDDATE').asDateTime = 0)  // end = 0
      and (HostQry.FieldByName('PROGRESSSTARTQUEUEDATE').asDateTime <> 0)  //start <> 0
      and (LastEnd = 0)// and (LastStart <> 0)
      then
      begin
        if DndArchiveHostName = TD_Oracle then
          LastStart := StrToDateTime(FormatDateTIme(FormatSettings.ShortDateFormat,HostQry.FieldByName('PROGRESSSTARTQUEUEDATE').asDateTime)) + Frac(HostQry.FieldByName('PROGRESSSTARTQUEUETIME').AsDateTime)
        else
          LastStart := StrToDateTime(FormatDateTIme(FormatSettings.ShortDateFormat,HostQry.FieldByName('PROGRESSSTARTQUEUEDATE').asDateTime)) + HostQry.FieldByName('PROGRESSSTARTQUEUETIME').AsDateTime ;


        Comment := Trim(HostQry.FieldByName('COMPANYCODE').AsString) + ' ' + Trim(HostQry.FieldByName('PROGRESSNUMBER').AsString);
        WKC     := Trim(HostQry.FieldByName('WORKCENTERCODE').AsString);
        MACHINE := Trim(HostQry.FieldByName('MACHINECODE').AsString);
      end;

      if  (HostQry.FieldByName('PROGRESSENDDATE').asDateTime <> 0)  //end <> 0
      and (LastStart <> 0)  //Previous start <> 0
      and (HostQry.FieldByName('MACHINECODE').asString = MACHINE)
      then
      begin
        if DndArchiveHostName = TD_Oracle then
         LastEnd := StrToDateTime(FormatDateTIme(FormatSettings.ShortDateFormat,HostQry.FieldByName('PROGRESSENDDATE').asDateTime)) + Frac(HostQry.FieldByName('PROGRESSENDTIME').AsDateTime)
        else
         LastEnd := StrToDateTime(FormatDateTIme(FormatSettings.ShortDateFormat,HostQry.FieldByName('PROGRESSENDDATE').asDateTime)) + HostQry.FieldByName('PROGRESSENDTIME').AsDateTime ;
      end;

      if  (LastStart <> 0)  // Last Start = 0
      and (HostQry.FieldByName('MACHINECODE').asString <> MACHINE)  //current machine <> previous machine
      and (LastEnd = 0)
      then
      begin
        LastEnd := LastStart + (1/1440);  //ADD 1 minute to EndDate
        HostQry.Prior;
        Continue;
      end;

      if (LastStart = 0) or (LastEnd = 0) and (HostQry.RecNo < HostQry.RecordCount) then
      begin
        HostQry.Next;
        Continue;
      end;

      if (LastStart <> 0) and (LastEnd = 0) and (HostQry.RecNo = HostQry.RecordCount) then
      begin
        LastEnd := LastStart + (1/1440);
      end;

      New(CapRes);
      CapRes.CR_WKC                 := WKC;
      CapRes.CR_CAPACY_RESRV        := -1;
      CapRes.CR_RSC                 := MACHINE;
      CapRes.CR_SUB_LINE_RES        := -1;
      CapRes.CR_WC_PROCESS          := '';

      if HostQry.FieldByName('MACHINEDOWNTIMETYPE').asString = '1' then
        CapRes.CR_CAPRES_TYPE         := '3'
      else
        CapRes.CR_CAPRES_TYPE         := '2';

      CapRes.CR_CAPACITY_To_JOB     := '0';
      CapRes.CR_COMMENTS            := Comment;
      CapRes.CR_SCHEDULE_START      := LastStart;
      CapRes.CR_SCHEDULE_END        := LastEnd;

      CapRes.CR_USR_CG              := ' ';
      CapRes.CR_USR_TM_CG           := 0;
      HostList.add(CapRes);
      LastStart := 0;
      LastEnd := 0;
      Comment := '';
      WKC     := '';
      MACHINE := '';
      HostQry.Next;
    end;

    if IniAppGlobals.downloadTo = '0' then
      StartTime := ConvertDateFormatTo(trunc(Now - 360), TD_Db2)
    else if IniAppGlobals.downloadTo = '1' then
      StartTime := ConvertDateFormatTo(trunc(Now - 360), TD_Oracle)
    else
      StartTime := ConvertDateFormatTo(trunc(Now - 360), TD_Interbase);

    srvQry.Transaction := ThreadCreateTransaction(Main_DB);
    srvQry.Transaction.StartTransaction;

    srvQry.sql.Clear;
    srvQry.sql.add(' delete from ' + tbCapRes.GetTableName);
    srvQry.sql.add(' where ' + CreateFld(tbCapRes.pfx,fli_CapacyResrv) + ' < ' + IntToStr(0));
    srvQry.sql.add(' AND ' + '(' + CreateFld(tbCapRes.pfx, fli_schedStart) + '<' + StartTime + ')');
    srvQry.SQL.Add(AND_IDF_Condition(CreateFld(tbCapRes.pfx, fli_IDENTIFIER)));
    srvQry.ExecSQL;
    srvQry.Transaction.Commit;

    OrderBy := ' Order by ' + CreateFld(tbCapRes.pfx,fli_CapacyResrv);
    srvQry.sql.Clear;
    srvQry.sql.add(' Select * from ' + tbCapRes.GetTableName);
    srvQry.sql.add(' where ' + CreateFld(tbCapRes.pfx,fli_CapacyResrv) + ' < ' + IntToStr(0));
//    srvQry.sql.add(' and (' + CreateFld(tbCapRes.pfx,fli_CapacyResrvStatus) + ' <> ' + QuotedStr('2') );
//    srvQry.sql.add(' or ' + CreateFld(tbCapRes.pfx,fli_CapacyResrvStatus) + ' is null)');
    srvQry.SQL.Add(AND_IDF_Condition(CreateFld(tbCapRes.pfx, fli_IDENTIFIER)));
    srvQry.sql.add(' Order by ' + CreateFld(tbCapRes.pfx,fli_CapacyResrv));
    srvQry.Open;

    if srvQry.RecordCount = 0 then
        m_LowestNumber_CapRes        := -1
    else
    begin
      sql := 'select CR_CAPACTY_RESRV from '+ tbCapRes.GetTableName
          + ' where ' + CreateFld(tbCapRes.pfx,fli_CapacyResrv) + ' < ' + IntToStr(0)
        // + ' and (' + CreateFld(tbCapRes.pfx,fli_CapacyResrvStatus) + ' <> ' + QuotedStr('2')
        //  + ' or  ' + CreateFld(tbCapRes.pfx,fli_CapacyResrvStatus) + ' is null)'
          +  AND_IDF_Condition(CreateFld(tbCapRes.pfx, fli_IDENTIFIER));

      //select only 1 row
      if IniAppGlobals.DownloadTo = '0'  then
         sql := sql + ' Order by ' + CreateFld(tbCapRes.pfx,fli_CapacyResrv) + ' fetch first 1 row only'
      else if IniAppGlobals.DownloadTo = '1'  then
        sql := sql + ' and ROWNUM = 1 Order by ' + CreateFld(tbCapRes.pfx,fli_CapacyResrv)
      else if IniAppGlobals.DownloadTo = '2'  then
        sql := sql + ' Order by ' + CreateFld(tbCapRes.pfx,fli_CapacyResrv) + ' ROWS 1';

      m_LowestNumber_CapRes        := srvQry.Connection.ExecSQLScalar(sql) -1;


     // OrderBy := ' Order by ' + CreateFld(tbCapRes.pfx,fli_CapacyResrv);
      srvQry.sql.Clear;
      srvQry.sql.add(' Select * from ' + tbCapRes.GetTableName);
      srvQry.sql.add(' where ' + CreateFld(tbCapRes.pfx,fli_CapacyResrv) + ' < ' + IntToStr(0));
      srvQry.sql.add(' and (' + CreateFld(tbCapRes.pfx,fli_CapacyResrvStatus) + ' <> ' + QuotedStr('2') );
      srvQry.sql.add(' or ' + CreateFld(tbCapRes.pfx,fli_CapacyResrvStatus) + ' is null)');
      srvQry.SQL.Add(AND_IDF_Condition(CreateFld(tbCapRes.pfx, fli_IDENTIFIER)));
      srvQry.sql.add(' Order by ' + CreateFld(tbCapRes.pfx,fli_CapacyResrv));
      srvQry.Open;

      while not srvQry.Eof do
      begin
        Application.ProcessMessages;
        New(CapRes);
        CapRes.CR_CAPACY_RESRV        := srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_CapacyResrv)).AsInteger;
        CapRes.CR_RSC                 := Trim(srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_rsc)).AsString);
        CapRes.CR_SUB_LINE_RES        := srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_subLinRscId)).AsInteger;
        CapRes.CR_WC_PROCESS          := Trim(srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_WCProcess)).AsString);
        CapRes.CR_CAPRES_TYPE         := Trim(srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_CapacyResTyp)).AsString);
        CapRes.CR_CAPACITY_To_JOB     := Trim(srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_Capacity_To_Job)).AsString);
        CapRes.CR_COMMENTS            := Trim(srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_Comment)).AsString);
        CapRes.CR_SCHEDULE_START      := srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_schedStart)).AsDateTime;
        CapRes.CR_SCHEDULE_END        := srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_schedEnd)).AsDateTime;
      //  CapRes.CR_SCHEDULE_START      := StrToDateTime(FormatDateTIme('mm/dd/yyyy hh:mm:ss', srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_schedStart)).AsDateTime));
     //  CapRes.CR_SCHEDULE_END        := StrToDateTime(FormatDateTIme('mm/dd/yyyy hh:mm:ss', srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_schedEnd)).AsDateTime));

        ServList.add(CapRes);
        srvQry.Next;
      end;
    end;

    if (HostList.Count > 0) or (ServList.Count > 0) then
      CapResCompare(tbl, HostList,ServList);

    for I := HostList.Count -1 downto 0 do
        Dispose(PTCapRes(HostList[I]));

    //  for I := ResWKC.Count -1 downto 0 do
    //    Dispose(PTMQMCRWKC(ResWKC[I]));

      for I := ServList.Count -1 downto 0 do
         Dispose(PTCapRes(ServList[I]));

  end
  else
  begin

    if IsHostQry then
    begin
      DateTimeFormat := GetDateTimeFormat;
      OrderBy := ' Order by UCAPNM';
  //    Result := LoadTableCapRes(tbl, AS400Speclib, ' where UANNUL' + CAnnulFilter + ' And UCAPNM < 0 ' ,OrderBy, fldList, HostQry, FirstLoop,'HPRREQ');
      Result := LoadTableCapRes(tbl, AS400Speclib, ' where UCAPNM < 0 ' ,OrderBy, fldList, HostQry, 'HPRREQ');

      if not Result then
      begin
        Result := true;
        HostQry.Close;
        exit;
      end;

   //   OLD_HostList := TList.Create;
      HostList := TList.Create;
      ServList := TList.Create;

      while not HostQry.Eof do
      begin
        Application.ProcessMessages;
        New(RecMQMCR);
        RecMQMCR.CR_CAPACY_RESRV        := HostQry.FieldByName(fldList[0].fldAS).AsInteger;
        RecMQMCR.CR_RSC                 := Trim((HostQry.FieldByName(fldList[1].fldAS).AsString));
        RecMQMCR.CR_SUB_LINE_RES        := HostQry.FieldByName(fldList[2].fldAS).AsInteger;
        RecMQMCR.CR_WC_PROCESS          := Trim(HostQry.FieldByName(fldList[3].fldAS).AsString);
        RecMQMCR.CR_CAPRES_TYPE         := Trim(HostQry.FieldByName(fldList[4].fldAS).AsString);
        RecMQMCR.CR_CAPACITY_To_JOB     := Trim(HostQry.FieldByName(fldList[5].fldAS).AsString);
        RecMQMCR.CR_COMMENTS            := Trim(HostQry.FieldByName(fldList[6].fldAS).AsString);
        if (DateTimeFormat = Frm_As400) then
          RecMQMCR.CR_SCHEDULE_START    := TimDateTimeToDateTime(HostQry.FieldByName(fldList[7].fldAS).AsFloat)
        else if (DateTimeFormat = Frm_TDateTimeExceptControl) or (DateTimeFormat = Frm_TDateTime) then
          RecMQMCR.CR_SCHEDULE_START    := HostQry.FieldByName(fldList[7].fldAS).AsFloat;
        if (DateTimeFormat = Frm_As400) then
          RecMQMCR.CR_SCHEDULE_END        := TimDateTimeToDateTime(HostQry.FieldByName(fldList[8].fldAS).AsFloat)
        else if (DateTimeFormat = Frm_TDateTimeExceptControl) or (DateTimeFormat = Frm_TDateTime) then
          RecMQMCR.CR_SCHEDULE_END        := HostQry.FieldByName(fldList[8].fldAS).AsFloat;
   //     RecMQMCR.CR_USR_CG                := Trim(HostQry.FieldByName(fldList[9].fldAS).AsString);
    //    if (DateTimeFormat = Frm_As400) then
    //      RecMQMCR.CR_USR_TM_CG := TimDateTimeToDateTime(HostQry.FieldByName(fldList[10].fldAS).AsFloat)
   //     else if (DateTimeFormat = Frm_TDateTime) then
   //       RecMQMCR.CR_USR_TM_CG := HostQry.FieldByName(fldList[10].fldAS).AsDateTime;

        if (RecMQMCR.CR_SCHEDULE_START < (Now - 360)) then
        begin
          dispose(RecMQMCR);
          HostQry.Next;
          Continue
        end;

        HostList.add(RecMQMCR);
        HostQry.Next;
      end;

     { OrderBy := ' Order by ' + CreateFld(tbCapRes_Host.pfx,fli_CapacyResrv);
      LoadSrvTable(tbl_capRes_Host,' Where ' + CreateFld(tbCapRes_Host.pfx,fli_CapacyResrv) + ' < 0' , OrderBy, fldList, srvQry, '');
      while not srvQry.Eof do
      begin
        Application.ProcessMessages;
        New(RecMQMCR);
        RecMQMCR.CR_CAPACY_RESRV        := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_CapacyResrv)).AsInteger;
        RecMQMCR.CR_RSC                 := Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_rsc)).AsString);
        RecMQMCR.CR_SUB_LINE_RES        := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_subLinRscId)).AsInteger;
        RecMQMCR.CR_WC_PROCESS          := Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_WCProcess)).AsString);
        RecMQMCR.CR_CAPRES_TYPE         := Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_CapacyResTyp)).AsString);
        RecMQMCR.CR_CAPACITY_To_JOB     := Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_Capacity_To_Job)).AsString);
        RecMQMCR.CR_COMMENTS            := Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_Comment)).AsString);
        RecMQMCR.CR_SCHEDULE_START      := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_schedStart)).AsDateTime;
        RecMQMCR.CR_SCHEDULE_END        := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_schedEnd)).AsDateTime;
        OLD_HostList.add(RecMQMCR);
        srvQry.Next;
      end;   }

      StartTime := ConvertDateFormatTo(trunc(Now - 360), TD_Interbase);

      srvQry.Transaction := ThreadCreateTransaction(Main_DB);
      srvQry.Transaction.StartTransaction;

      srvQry.sql.Clear;
      srvQry.sql.add(' delete from ' + tbCapRes.GetTableName);
      srvQry.sql.add(' where ' + CreateFld(tbCapRes.pfx,fli_CapacyResrv) + ' < ' + IntToStr(0));
      srvQry.sql.add(' AND ' + '(' + CreateFld(tbCapRes.pfx, fli_schedStart) + '<' + StartTime + ')');
      srvQry.SQL.Add(AND_IDF_Condition(CreateFld(tbCapRes.pfx, fli_IDENTIFIER)));
      srvQry.ExecSQL;
      srvQry.Transaction.Commit;

      OrderBy := ' Order by ' + CreateFld(tbCapRes.pfx,fli_CapacyResrv);
    //  LoadSrvTable(tbl,' Where ' + CreateFld(tbCapRes.pfx,fli_CapacyResrv) + ' < 0' , OrderBy, fldList, srvQry, '');
      srvQry.sql.Clear;
      srvQry.sql.add(' Select * from ' + tbCapRes.GetTableName);
      srvQry.sql.add(' where ' + CreateFld(tbCapRes.pfx,fli_CapacyResrv) + ' < ' + IntToStr(0));
      srvQry.SQL.Add(AND_IDF_Condition(CreateFld(tbCapRes.pfx, fli_IDENTIFIER)));
      srvQry.sql.add(' Order by ' + CreateFld(tbCapRes.pfx,fli_CapacyResrv));
      srvQry.Open;

      while not srvQry.Eof do
      begin
        Application.ProcessMessages;
        New(RecMQMCR);
        RecMQMCR.CR_CAPACY_RESRV        := srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_CapacyResrv)).AsInteger;
        RecMQMCR.CR_RSC                 := Trim(srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_rsc)).AsString);
        RecMQMCR.CR_SUB_LINE_RES        := srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_subLinRscId)).AsInteger;
        RecMQMCR.CR_WC_PROCESS          := Trim(srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_WCProcess)).AsString);
        RecMQMCR.CR_CAPRES_TYPE         := Trim(srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_CapacyResTyp)).AsString);
        RecMQMCR.CR_CAPACITY_To_JOB     := Trim(srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_Capacity_To_Job)).AsString);
        RecMQMCR.CR_COMMENTS            := Trim(srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_Comment)).AsString);
        RecMQMCR.CR_SCHEDULE_START      := srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_schedStart)).AsDateTime;
        RecMQMCR.CR_SCHEDULE_END        := srvQry.FieldByName(CreateFld(tbCapRes.pfx, fli_schedEnd)).AsDateTime;
        ServList.add(RecMQMCR);
        srvQry.Next;
      end;
      if (HostList.Count > 0) or (ServList.Count > 0) then
        PrepareListForCapResChange(HostList,ServList);

  {    for I := OLD_HostList.Count -1 downto 0 do
         Dispose(PTMQMCR(OLD_HostList[I]));
      OLD_HostList.Clear;
      OLD_HostList.free;  }

      for I := HostList.Count -1 downto 0 do
        Dispose(PTMQMCR(HostList[I]));

     // for I := ResWKC.Count -1 downto 0 do
     //   Dispose(PTMQMCR(ResWKC[I]));

      for I := ServList.Count -1 downto 0 do
         Dispose(PTMQMCR(ServList[I]));

    end;
  end;

  HostList.Clear;
  HostList.free;

//  ResWKC.Clear;
//  ResWKC.free;

  ServList.Clear;
  ServList.free;

  HostQry.Close;
//  HostQry.Free;
  ArcQry.Close;
  ArcQry.Free;

end;

//----------------------------------------------------------------------------//

constructor TProdCont.Create;
begin
  inherited Create;
  m_Req_Change_List := TList.Create;
  m_Req_Step_Change_List := TList.Create;
  m_Work_Cnter_Chang_List := TStringList.Create;
  m_PropTabale := TStringList.Create;
  m_PropTabale.Sorted := true;
  m_LocalListPR := TList.Create;
  m_LocalListPH := TList.Create;
  m_LocalListPD := TList.Create;
  m_LocalListPP := TList.Create;
  m_LocalListPI := TList.Create;
  m_LocalListPA := TList.Create;
  m_LocalListEC := TList.Create;
  m_LocalListIC := TList.Create;
  m_LocalListSB := TList.Create;
  m_LocalListST := TList.Create;
  m_LocallistMT := TList.Create;
  m_LocallistSP := TList.Create;

  m_HostListSP := TList.Create;

  if IniAppGlobals.PreparationExeName = '' then
  begin
    m_HostListPR := TList.Create;
    m_HostListPH := TList.Create;
    m_HostListPD := TList.Create;
    m_HostListPP := TList.Create;
    m_HostListPI := TList.Create;
    m_HostlistPA := TList.Create;
    m_HostListEC := TList.Create;
    m_HostListIC := TList.Create;
    m_HostListSB := TList.Create;
  //  m_HostListSP := TList.Create;
    m_HostListST := TList.Create;
    m_HostlistMT := TList.Create;
  end;
  m_TmpPP_Memory := TList.Create;
  m_TmpPP_Disk := TList.Create;
end;

//----------------------------------------------------------------------------//

procedure TProdCont.FreeListProd;
begin
  m_Req_Change_List.free;
  m_Req_Step_Change_List.free;
  m_Work_Cnter_Chang_List.free;
  m_PropTabale.free;
  m_HostListPR.free;
  m_HostListPH.free;
  m_HostListPD.free;
  m_HostListPP.free;
  m_HostListPI.free;
  m_HostlistPA.free;
  m_HostListEC.free;
  m_HostListIC.free;
  m_HostListSB.free;
  m_HostListSP.free;
  m_HostListST.free;
  m_HostlistMT.free;
  m_LocalListPR.free;
  m_LocalListPH.free;
  m_LocalListPD.free;
  m_LocalListPP.free;
  m_LocalListPI.free;
  m_LocalListEC.free;
  m_LocalListIC.free;
  m_LocalListSB.free;
  m_LocalListSP.free;
  m_LocalListST.free;
  m_LocalListMT.free;
  m_LocalListPA.free;
  m_TmpPP_Memory.free;
  m_TmpPP_Disk.free;
end;

//----------------------------------------------------------------------------//

procedure TProdCont.ClearMemoryList;
var
  I : Integer;
begin
  for I := m_Req_Change_List.Count -1 downto 0 do
    Dispose(PReqChange(m_Req_Change_List[I]));
  m_Req_Change_List.Clear;

  for I := m_Req_Step_Change_List.Count - 1 downto 0 do
    Dispose(PStepChange(m_Req_Step_Change_List[I]));
  m_Req_Step_Change_List.Clear;

  m_Work_Cnter_Chang_List.clear;
  m_PropTabale.Clear;

  for I := m_HostListPR.Count -1 downto 0 do
    Dispose(PTMQMPR(m_HostListPR[I]));
  m_HostListPR.Clear;

  for I := m_HostListPH.Count -1 downto 0 do
    Dispose(PTMQMPH(m_HostListPH[I]));
  m_HostListPH.Clear;

  for I := m_HostListPD.Count -1 downto 0 do
    Dispose(PTMQMPD(m_HostListPD[I]));
  m_HostListPD.Clear;

  for I := m_HostListPP.Count -1 downto 0 do
    Dispose(PTMQMPP(m_HostListPP[I]));
  m_HostListPP.Clear;

  for I := m_HostListPI.Count -1 downto 0 do
    Dispose(PTMQMPI(m_HostListPI[I]));
  m_HostListPI.Clear;

  for I := m_HostListEC.Count -1 downto 0 do
    Dispose(PTMQMEC(m_HostListEC[I]));
  m_HostListEC.Clear;

  for I := m_HostListIC.Count -1 downto 0 do
    Dispose(PTMQMIC(m_HostListIC[I]));
  m_HostListIC.Clear;

  for I := m_HostListSB.Count -1 downto 0 do
    Dispose(PTMQMSB(m_HostListSB[I]));
  m_HostListSB.Clear;

  for I := m_HostListSP.Count -1 downto 0 do
    Dispose(PTMQMSP(m_HostListSP[I]));
  m_HostListSP.Clear;

  for I := m_HostListST.Count -1 downto 0 do
    Dispose(PTMQMST(m_HostListST[I]));
  m_HostListST.Clear;

  for I := m_HostlistMT.Count -1 downto 0 do
    Dispose(PTMQMMT(m_HostlistMT[I]));
  m_HostlistMT.Clear;

  for I := m_HostlistPA.Count -1 downto 0 do
    Dispose(PTMQMPA(m_HostlistPA[I]));
  m_HostlistPA.Clear;

  for I := m_TmpPP_Memory.Count -1 downto 0 do
    Dispose(PReqTempProp(m_TmpPP_Memory[I]));
  m_TmpPP_Memory.Clear;

  for I := m_TmpPP_Disk.Count -1 downto 0 do
    Dispose(PReqTempProp(m_TmpPP_Disk[I]));
  m_TmpPP_Disk.Clear;

  for I := m_LocalListPR.Count -1 downto 0 do
    Dispose(PTMQMPR(m_LocalListPR[I]));
  m_LocalListPR.Clear;

  for I := m_LocalListPH.Count -1 downto 0 do
    Dispose(PTMQMPH(m_LocalListPH[I]));
  m_LocalListPH.Clear;

  for I := m_LocalListPD.Count -1 downto 0 do
    Dispose(PTMQMPD(m_LocalListPD[I]));
  m_LocalListPD.Clear;

  for I := m_LocalListPP.Count -1 downto 0 do
    Dispose(PTMQMPP(m_LocalListPP[I]));
  m_LocalListPP.Clear;

  for I := m_LocalListPI.Count -1 downto 0 do
    Dispose(PTMQMPI(m_LocalListPI[I]));
  m_LocalListPI.Clear;

  for I := m_LocalListEC.Count -1 downto 0 do
    Dispose(PTMQMEC(m_LocalListEC[I]));
  m_LocalListEC.Clear;

  for I := m_LocalListIC.Count -1 downto 0 do
    Dispose(PTMQMIC(m_LocalListIC[I]));
  m_LocalListIC.Clear;

  for I := m_LocalListSB.Count -1 downto 0 do
    Dispose(PTMQMSB(m_LocalListSB[I]));
  m_LocalListSB.Clear;

  for I := m_LocalListSP.Count -1 downto 0 do
    Dispose(PTMQMSP(m_LocalListSP[I]));
  m_LocalListSP.Clear;

  for I := m_LocalListST.Count -1 downto 0 do
    Dispose(PTMQMST(m_LocalListST[I]));
  m_LocalListST.Clear;

  for I := m_LocalListMT.Count -1 downto 0 do
    Dispose(PTMQMMT(m_LocalListMT[I]));
  m_LocalListMT.Clear;

  for I := m_LocalListPA.Count -1 downto 0 do
    Dispose(PTMQMPA(m_LocalListPA[I]));
  m_LocalListPA.Clear;
end;

//----------------------------------------------------------------------------//

procedure TProdCont.SetPDThreadList(ThreadPDList : TList);
//var
//  I : Integer;
//  RecMQMPD : PTMQMPD;
//  LogPD : TStringList;
begin
{  for I := 0 to ThreadPDList.Count - 1 do
  begin
    new(RecMQMPD);
    RecMQMPD.PD_PREQ_NO := PTMQMPD(ThreadPDList[I]).PD_PREQ_NO;
    RecMQMPD.PD_PSTEP_ID := PTMQMPD(ThreadPDList[I]).PD_PSTEP_ID;
    RecMQMPD.PD_TO_SCHED := PTMQMPD(ThreadPDList[I]).PD_TO_SCHED;
    RecMQMPD.PD_PRV_STEP_SCHED := PTMQMPD(ThreadPDList[I]).PD_PRV_STEP_SCHED;
    RecMQMPD.PD_PRV_STEP_TRUE := PTMQMPD(ThreadPDList[I]).PD_PRV_STEP_TRUE;
    RecMQMPD.PD_NEX_STEP_SCHED := PTMQMPD(ThreadPDList[I]).PD_NEX_STEP_SCHED;
    RecMQMPD.PD_NEX_STEP_TRUE  := PTMQMPD(ThreadPDList[I]).PD_NEX_STEP_TRUE;
    RecMQMPD.PD_STEP_TYP       := PTMQMPD(ThreadPDList[I]).PD_STEP_TYP;
    RecMQMPD.PD_MAT_ARRV_DATE        := PTMQMPD(ThreadPDList[I]).PD_MAT_ARRV_DATE;
    RecMQMPD.PD_FRC_MAT_DATE         := PTMQMPD(ThreadPDList[I]).PD_FRC_MAT_DATE;
    RecMQMPD.PD_PLAN_START           := PTMQMPD(ThreadPDList[I]).PD_PLAN_START;
    RecMQMPD.PD_LOW_LIMIT_TIME_STRT  := PTMQMPD(ThreadPDList[I]).PD_LOW_LIMIT_TIME_STRT;
    RecMQMPD.PD_FRC_LOW_DATE       := PTMQMPD(ThreadPDList[I]).PD_FRC_LOW_DATE;
    RecMQMPD.PD_PLAN_END       := PTMQMPD(ThreadPDList[I]).PD_PLAN_END;
    RecMQMPD.PD_HIGH_LIMIT_TIMEND       := PTMQMPD(ThreadPDList[I]).PD_HIGH_LIMIT_TIMEND;
    RecMQMPD.PD_FRC_HIGH_DATE        := PTMQMPD(ThreadPDList[I]).PD_FRC_HIGH_DATE;
    RecMQMPD.PD_WKCNTER              := PTMQMPD(ThreadPDList[I]).PD_WKCNTER;
    RecMQMPD.PD_WKCT_PROC            := PTMQMPD(ThreadPDList[I]).PD_WKCT_PROC;
    RecMQMPD.PD_INIT_QUENT           := PTMQMPD(ThreadPDList[I]).PD_INIT_QUENT;
    RecMQMPD.PD_FIN_QUENT            := PTMQMPD(ThreadPDList[I]).PD_FIN_QUENT;
    RecMQMPD.PD_WEIGHT               := PTMQMPD(ThreadPDList[I]).PD_WEIGHT;
    RecMQMPD.PD_DESC_UM              := PTMQMPD(ThreadPDList[I]).PD_DESC_UM;
    RecMQMPD.PD_CAL                  := PTMQMPD(ThreadPDList[I]).PD_CAL;
    RecMQMPD.PD_SETUP_TIME_STP       := PTMQMPD(ThreadPDList[I]).PD_SETUP_TIME_STP;
    RecMQMPD.PD_EXC_TIME_STP         := PTMQMPD(ThreadPDList[I]).PD_EXC_TIME_STP;
    RecMQMPD.PD_RES_NUM_PLN          := PTMQMPD(ThreadPDList[I]).PD_RES_NUM_PLN;
    RecMQMPD.PD_ALLOW_SPLIT          := PTMQMPD(ThreadPDList[I]).PD_ALLOW_SPLIT;
    RecMQMPD.PD_STEP_HANDLE_REPROCES := PTMQMPD(ThreadPDList[I]).PD_STEP_HANDLE_REPROCES;
    RecMQMPD.PD_STEP_PART_GEN_PLAN   := PTMQMPD(ThreadPDList[I]).PD_STEP_PART_GEN_PLAN;
    RecMQMPD.PD_STEP_CAN_GROUP       := PTMQMPD(ThreadPDList[I]).PD_STEP_CAN_GROUP;
    RecMQMPD.PD_FORCED_GRP_NO              := PTMQMPD(ThreadPDList[I]).PD_FORCED_GRP_NO;
    RecMQMPD.PD_CONN_TYPE_PREV_STEP_SPLIT  := PTMQMPD(ThreadPDList[I]).PD_CONN_TYPE_PREV_STEP_SPLIT;
    RecMQMPD.PD_FRC_OVERLAPP               := PTMQMPD(ThreadPDList[I]).PD_FRC_OVERLAPP;
    RecMQMPD.PD_STEP_CLOSED                := PTMQMPD(ThreadPDList[I]).PD_STEP_CLOSED;
    RecMQMPD.PD_USR_CG                     := PTMQMPD(ThreadPDList[I]).PD_USR_CG;
    RecMQMPD.PD_USR_TM_CG       := PTMQMPD(ThreadPDList[I]).PD_USR_TM_CG;
    RecMQMPD.PD_MCM_ApplyDatePenalty         := PTMQMPD(ThreadPDList[I]).PD_MCM_ApplyDatePenalty;
    RecMQMPD.PD_MCM_LeadQueueTimePrevStep    := PTMQMPD(ThreadPDList[I]).PD_MCM_LeadQueueTimePrevStep;
    RecMQMPD.PD_MCM_MaxJobsGap               := PTMQMPD(ThreadPDList[I]).PD_MCM_MaxJobsGap;
    RecMQMPD.PD_MCM_MaxStepsGap              := PTMQMPD(ThreadPDList[I]).PD_MCM_MaxStepsGap;
    RecMQMPD.PD_SchedulByMcm                 := PTMQMPD(ThreadPDList[I]).PD_SchedulByMcm;
    RecMQMPD.PD_SplitFamily                  := PTMQMPD(ThreadPDList[I]).PD_SplitFamily;
    RecMQMPD.PD_LearningCurveCode            := PTMQMPD(ThreadPDList[I]).PD_LearningCurveCode;
    RecMQMPD.PD_LearningCurveType            := PTMQMPD(ThreadPDList[I]).PD_LearningCurveType;
    RecMQMPD.PD_ApprovalDate                 := PTMQMPD(ThreadPDList[I]).PD_ApprovalDate;
    RecMQMPD.PD_GRP_SEQUENCE                 := PTMQMPD(ThreadPDList[I]).PD_GRP_SEQUENCE;
    RecMQMPD.PD_Prev_LeadTime                := PTMQMPD(ThreadPDList[I]).PD_Prev_LeadTime;
    RecMQMPD.PD_Next_LeadTime                := PTMQMPD(ThreadPDList[I]).PD_Next_LeadTime;
    m_HostListPD.Add(RecMQMPD);
  end; }
  m_HostListPD := ThreadPDList;
//  LogPD := TStringList.Create;
//  LogPD.Add(PTMQMPD(ThreadPDList[0]).PD_PREQ_NO);

//  LogPD.Add(IntToStr(PTMQMPD(ThreadPDList[0]).PD_PSTEP_ID));

//  LogPD.SaveToFile('c:\listPD.txt');

end;

//----------------------------------------------------------------------------//

function TProdCont.CheckProperty(PropCode : string) : boolean;
var
  I : Integer;
begin
  Result := false;

  if m_PropTabale.IndexOf(PropCode) <> -1 then
    Result := true;

 { for I := 0 to m_PropTabale.Count - 1 do
  begin
    if (m_PropTabale.Strings[I] = PropCode) then
    begin
      Result := true;
      Break
    end;
  end;    }

end;

//----------------------------------------------------------------------------//

function TProdCont.CheckAlternativeWC(WC: string;    Process: string;
                                      altWC: string; altProcess: string): boolean;
var
//  srvTrs : TMqmTransaction;
  AltQry : TMqmQuery;
  tbInfo: ^TTblInfo;
begin
//  srvTrs := CreateTransaction(Main_DB, false);
  AltQry := ThreadCreateQuery(Main_DB);
  tbInfo := @tblInfo[tbl_wkc_alt];
  Result := false;
  with AltQry do
  begin
//    Transaction.StartTransaction;
    sql.Clear;
    sql.add('Select * from ' + tbInfo.GetTableName);
    SQL.Add(where_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
    open;
    Application.ProcessMessages;

    while not Eof do
    begin
//      if (FieldByName(CreateFld(tbInfo.pfx, fli_wkCtrCode)).AsString = altWC) and (FieldByName(CreateFld(tbInfo.pfx, fli_wkcProc)).AsString = altProcess) then
      if (FieldByName(CreateFld(tbInfo.pfx, fli_wkCtrCode)).AsString = WC) and (FieldByName(CreateFld(tbInfo.pfx, fli_wkcProc)).AsString = Process) then
      begin
//        if (FieldByName(CreateFld(tbInfo.pfx, fli_AlterWC)).AsString = WC) and (FieldByName(CreateFld(tbInfo.pfx, fli_AlterWCProces)).AsString = Process) then
        if (FieldByName(CreateFld(tbInfo.pfx, fli_AlterWC)).AsString = altWC) then//and (FieldByName(CreateFld(tbInfo.pfx, fli_AlterWCProces)).AsString = altProcess) then
        begin
          Result := true;
          break
        end
      end;
      Next;
    end;
    Close;
    AltQry.connection.Commit;
  end;

  AltQry.Free;
//  srvTrs.Free;

end;

//----------------------------------------------------------------------------//

procedure TProdCont.GetPropFromTable;
var
  srvTrs : TMqmTransaction;
  PropQry : TMqmQuery;
  tbInfo: ^TTblInfo;
begin
//  srvTrs := CreateTransaction(Main_DB, false);
  PropQry := ThreadCreateQuery(Main_DB);
  tbInfo := @tblInfo[tbl_prop];
  with PropQry do
  begin
   // Transaction.StartTransaction;
    sql.Clear;
    sql.add('Select * from ' + tbInfo.GetTableName);
    sql.add(' where ' + CreateFld(tbInfo.pfx, fli_ChgPropValCauseResched) + '=' + '''1''');
    Sql.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
    open;
    while not Eof do
    begin
      Application.ProcessMessages;
      m_PropTabale.add(Trim(FieldByName(CreateFld(tbInfo.pfx, fli_PropertyCode)).AsString));
      Next
    end;
    Close;
   // Transaction.Commit;
  end;

  PropQry.Free;
//  srvTrs.Free;
end;

//----------------------------------------------------------------------------//

procedure TProdCont.updateExeMinProdSched;
var
  SrvQry : TMqmQuery;
  tbiPS: ^TTblInfo;
begin
  SrvQry := ThreadCreateQuery(Main_DB);
  srvQry.Transaction := ThreadCreateTransaction(Main_DB);
  srvQry.Transaction.StartTransaction;

  tbiPS := @tblInfo[tbl_prod_sched];
  with SrvQry do
  begin
    Sql.Clear;
    Sql.Add('update ' + tbiPS.GetTableName + ' set ' + CreateFld(tbiPS.pfx, fli_exeMin) + ' = ' + IntToStr(0) + ' where ' + CreateFld(tbiPS.pfx, fli_exeMin) + ' < ' + IntToStr(0));
	  Sql.Add(AND_IDF_Condition(CreateFld(tbiPS.pfx, fli_IDENTIFIER)));
    ExecSQL;
    Connection.Commit;
    close;
  end;

  SrvQry.Free;
end;

//----------------------------------------------------------------------------//

procedure TProdCont.ClearPPTempList;
var
  I : Integer;
begin
  for I := m_TmpPP_Memory.Count -1 downto 0 do
    Dispose(PReqTempProp(m_TmpPP_Memory[I]));
  m_TmpPP_Memory.Clear;

  for I := m_TmpPP_Disk.Count -1 downto 0 do
    Dispose(PReqTempProp(m_TmpPP_Disk[I]));
  m_TmpPP_Disk.Clear;
end;

//----------------------------------------------------------------------------//

function TProdCont.GetUpdatedReqNumber : Integer;
var
//  srvTrs : TMqmTransaction;
  Qry : TMqmQuery;
  tbInfo: ^TTblInfo;
  LastWcChange : integer;
begin
  Result := 0;
  LastWcChange := 0;
  Qry := ThreadCreateQuery(Main_DB);
  Qry.Transaction := ThreadCreateTransaction(Main_DB);
  Qry.Transaction.StartTransaction;

  tbInfo := @tblInfo[tbl_Req_Change];
  with Qry do
  begin
    sql.Clear;
    if (IniAppGlobals.downloadTo = '0') or (IniAppGlobals.DownloadTo = '1') then
      sql.add('Select ' + CreateFld(tbInfo.pfx, fli_updCode) + ' from ' + tbInfo.GetTableName + WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)) + ' Order by ' + CreateFld(tbInfo.pfx, fli_updCode) + ' desc' )
    else
      sql.add('Select ' + CreateFld(tbInfo.pfx, fli_updCode) + ' from ' + tbInfo.GetTableName + WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)) + ' Order by ' + CreateFld(tbInfo.pfx, fli_updCode) + ' descending' );
    open;
    if not Eof then
    begin
      Application.ProcessMessages;
//      Last;
      Result := FieldByName(CreateFld(tbInfo.pfx, fli_updCode)).AsInteger + 1;
    end;
    close;
  end;

  with Qry do
  begin
    tbInfo := @tblInfo[tbl_wkc_Change];
    sql.Clear;
    if (IniAppGlobals.downloadTo = '0') or (IniAppGlobals.DownloadTo = '1') then
      sql.add('Select ' + CreateFld(tbInfo.pfx, fli_updCode) + ' from ' + tbInfo.GetTableName + WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)) + ' Order by ' + CreateFld(tbInfo.pfx, fli_updCode) + ' desc' )
    else
      sql.add('Select ' + CreateFld(tbInfo.pfx, fli_updCode) + ' from ' + tbInfo.GetTableName + WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)) + ' Order by ' + CreateFld(tbInfo.pfx, fli_updCode) + ' descending' );
    open;
    if not Eof then
    begin
      Application.ProcessMessages;
   //   Last;
      LastWcChange := FieldByName(CreateFld(tbInfo.pfx, fli_updCode)).AsInteger + 1;
    end;
    close;

    if LastWcChange > Result then
    begin
      SQL.Clear;
      SQL.Add('delete from ' +  tbInfo.GetTableName);
      SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_updCode) + '>' + '''' + IntToStr(Result) + '''');
      SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
      ExecSQL;
      Result := LastWcChange;
    end;
  end;

  Qry.Connection.Commit;

  Qry.Free;
end;

//----------------------------------------------------------------------------//

function TProdCont.GetUpdatedResChangedNumber : Integer;
var
  Qry : TMqmQuery;
  tbInfo: ^TTblInfo;
begin
  Result := 0;
  Qry := ThreadCreateQuery(Main_DB);
  tbInfo := @tblInfo[tbl_Rsc_Change];
  with Qry do
  begin
    sql.Clear;
    sql.add('Select * from ' + tbInfo.GetTableName);

    sql.Clear;
    if (IniAppGlobals.downloadTo = '0') or (IniAppGlobals.DownloadTo = '1') then
      sql.add('Select ' + CreateFld(tbInfo.pfx, fli_updCode) + ' from ' + tbInfo.GetTableName
      + WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER))
      + 'Order by ' +CreateFld(tbInfo.pfx, fli_updCode) + ' desc' )
    else
      sql.add('Select ' + CreateFld(tbInfo.pfx, fli_updCode) + ' from ' + tbInfo.GetTableName
      + WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER))
      + ' Order by '+CreateFld(tbInfo.pfx, fli_updCode)+ ' descending' );
    open;
    if not Eof then
    begin
      Application.ProcessMessages;
      Result := FieldByName(CreateFld(tbInfo.pfx, fli_updCode)).AsInteger + 1;
    end;
    close;
  end;
  Qry.Free;
end;

//----------------------------------------------------------------------------//

function TProdCont.GetUpdatedCapResNumber : Integer;
var
  Qry : TMqmQuery;
  tbInfo: ^TTblInfo;
begin
  Result := 0;
  Qry := ThreadCreateQuery(Main_DB);
  tbInfo := @tblInfo[tbl_CapRsc_Change];
  with Qry do
  begin
    sql.Clear;
    if (IniAppGlobals.downloadTo = '0') or (IniAppGlobals.DownloadTo = '1') then
      sql.add('Select ' + CreateFld(tbInfo.pfx, fli_updCode) + ' from ' + tbInfo.GetTableName
      + WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER))
      + ' Order by ' + CreateFld(tbInfo.pfx, fli_updCode) + ' desc' )

    else
      sql.add('Select ' + CreateFld(tbInfo.pfx, fli_updCode) + ' from ' + tbInfo.GetTableName
      + WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER))
      + ' Order by ' + CreateFld(tbInfo.pfx, fli_updCode)+ ' descending' );
    open;
    if not Eof then
    begin
      Application.ProcessMessages;
    //  Last;
      Result := FieldByName(CreateFld(tbInfo.pfx, fli_updCode)).AsInteger + 1;
    end;
    close;
//    Transaction.Commit
  end;

  Qry.Free;

end;

//----------------------------------------------------------------------------//

function SetQryTblCompar(var LocalListPR,LocalListPH,LocalListPD,LocalListPP,
                         LocalListPI,LocalListEC,LocalListIC,LocalListSB,
                         LocalListSP,LocalListST,LocalListMT,LocalListPA : TList;
                         TablesFilter : string = '') : boolean;
var
  SelectedColumns, OrderBy : string;
  tbInfo: ^TTblInfo;
  QryTmp  : TMqmQuery;
  GeneralSQL : string;
  tCurrent : TDateTime;
  DateTimeFormat : TDateTimeFormat;
  bSortNeeded_PP : Boolean;
  sPrevKey_PP    : string;
  RecMQMPR : PTMQMPR;
  RecMQMPH : PTMQMPH;
  RecMQMPD : PTMQMPD;
  RecMQMPP : PTMQMPP;
  RecMQMPI : PTMQMPI;
  RecMQMEC : PTMQMEC;
  RecMQMIC : PTMQMIC;
  RecMQMSB : PTMQMSB;
  RecMQMSP : PTMQMSP;
  RecMQMST : PTMQMST;
  RecMQMMT : PTMQMMT;
  RecMQMPA : PTMQMPA;
  QryPR, QryPH, QryPD, QryPP, QryPI, QryEC, QryIC, QrySB, QrySP, QryST, QryMT, QryPA : TMqmQuery;

  PR_DIV_CODE_FIELD, PR_DSP_CODE_FIELD, PR_BCH_CODE_FIELD, PR_REPROC_NO_FIELD, PR_PREQ_NO_FIELD,
  PR_HISTORICAL_REQ_FIELD, PR_USR_CG_FIELD, PR_USR_TM_CG_FIELD, PR_ModulHandled_FIELD,

  PH_PREQ_NO_FIELD, PH_HISTORICAL_REQ_FIELD,PH_REQ_ORIGIN_FIELD,PH_PROD_LINE_FIELD,PH_TYPE_PROD_FIELD,
  PH_PROD_FAMILY_FIELD,PH_MATERIAL_FAMILY_FIELD,PH_PROD_UM_FIELD,PH_PROD_LOW_TIME_STRT_FIELD,PH_PROD_DELIVY_DATE_FIELD,
  PH_FRC_DEL_DATE_FIELD,PH_USR_CG_FIELD,PH_USR_TM_CG_FIELD,PH_SPLITCONFLEVELS_FIELD,PH_LEAD_STEP_SPLITED_FIELD,
  PH_MQM_SPLIT_ID_FIELD,PH_Serving_Code_FIELD,PH_Served_Code_FIELD,PH_Curve_Family_Id_Code_FIELD,PH_ModulHandled_FIELD,

  PD_PREQ_NO_FIELD,PD_PSTEP_ID_FIELD,PD_TO_SCHED_FIELD,PD_PRV_STEP_SCHED_MQM_FIELD,PD_PRV_STEP_TRUE_FIELD,PD_NEX_STEP_SCHED_MQM_FIELD,
  PD_NEX_STEP_TRUE_FIELD,PD_STEP_TYP_FIELD,PD_MAT_ARRV_DATE_FIELD,PD_FRC_MAT_DATE_FIELD,PD_PLAN_START_FIELD,PD_LOW_LIMIT_TIME_STRT_FIELD,
  PD_FRC_LOW_DATE_FIELD,PD_PLAN_END_FIELD,PD_HIGH_LIMIT_TIMEND_FIELD,PD_FRC_HIGH_DATE_FIELD,PD_WKCNTER_FIELD,PD_WKCT_PROC_FIELD,
  PD_INIT_QUENT_FIELD,PD_FIN_QUENT_FIELD,PD_WEIGHT_FIELD,PD_DESC_UM_FIELD,PD_CAL_FIELD,PD_SETUP_TIME_STP_FIELD,PD_EXC_TIME_STP_FIELD,
  PD_RES_NUM_PLN_FIELD,PD_ALLOW_SPLIT_FIELD,PD_STEP_HANDLE_REPROCES_FIELD,PD_STEP_PART_GEN_PLAN_FIELD,PD_STEP_CAN_GROUP_FIELD,
  PD_FORCED_GRP_NO_FIELD,PD_CONN_TYPE_PREV_STEP_SPLIT_FIELD,PD_FRC_OVERLAPP_FIELD,PD_STEP_CLOSED_FIELD,
  PD_USR_CG_FIELD,PD_USR_TM_CG_FIELD,PD_SchedulByMcm_FIELD,PD_SplitFamily_FIELD,PD_LearningCurveCode_FIELD,PD_LearningCurveType_FIELD,PD_OVERLAP_WITH_OTHER_STEPS_FIELD,
  PD_ApprovalDate_FIELD,PD_GRP_SEQUENCE_FIELD,PD_Prev_LeadTime_mqm_FIELD,PD_Next_LeadTime_mqm_FIELD,PD_Prev_LeadTimeBatch_mqm_FIELD,
  PD_Next_LeadTimeBatch_mqm_FIELD,PD_MinBatchSize_FIELD,PD_OptimumBatchSize_FIELD,PD_MaxBatchSize_FIELD,PD_BatchSizePerStep_FIELD,
  PD_SchedulByMqm_FIELD,PD_PRV_STEP_SCHED_MCM_FIELD,PD_NEX_STEP_SCHED_MCM_FIELD,PD_Prev_LeadTime_Mcm_FIELD,PD_Next_LeadTime_Mcm_FIELD,
  PD_Prev_LeadTimeBatch_mcm_FIELD,PD_Next_LeadTimeBatch_mcm_FIELD,PD_INITIALPLANSCHEDDATETIME_FIELD,PD_FINALPLANSCHEDDATETIME_FIELD,
  PD_NumResComponents_FIELD, PD_MaxStartDateAutoSeq_FIELD, PD_ALTERNATIVEQTY_FIELD, PD_PD_ALTERNATIVEUM_FIELD,
  PP_PREQ_NO_FIELD,PP_PSTEP_ID_FIELD,PP_RSC_CODE_FIELD,PP_PROPERTY_FIELD,PP_VALUE_FIELD,
  PI_PREQ_NO_FIELD,PI_PSTEP_ID_FIELD,PI_INFO_TYPE_FIELD,PI_INFO_LINE_NUM_FIELD,  PI_INFO_AREA_FIELD,
  PI_USR_CG_FIELD, PI_USR_TM_CG_FIELD,
  SB_PREQ_NO_FIELD,SB_PSTEP_ID_FIELD,SB_BCH_UM_FIELD,SB_MULTIPILR_TO_BATCH_UM_FIELD,
  SP_PREQ_NO_FIELD,SP_PSTEP_ID_FIELD,SP_PSUBST_ID_FIELD,SP_REPROC_NO_FIELD,SP_LAST_PROG_TYPE_FIELD,SP_RSC_CODE_FIELD,
  SP_PROGRESED_GROUP_FIELD,SP_PROGRSTART_FIELD,SP_CURR_PRG_DATE_FIELD,SP_PROGREND_FIELD,SP_QTY_FIELD,
  SP_StartingQty_FIELD,SP_REMAIN_TIME_FIELD,SP_LAST_PROG_TYPE_HOST_FIELD,SP_RSC_CODE_HOST_FIELD,
  SP_PROGRSTART_HOST_FIELD,SP_CURR_PRG_DATE_HOST_FIELD,SP_PROGREND_HOST_FIELD,SP_QTY_HOST_FIELD,SP_REMAIN_TIME_HOST_FIELD,
  ST_PREQ_NO_FIELD,ST_PSTEP_ID_FIELD,ST_WKCNTER_FIELD,ST_WKCT_PROC_FIELD,ST_RES_CATEGORY_FIELD,
  ST_RSC_CODE_FIELD,ST_SETUP_TIME_Mechin_Code_FIELD,ST_SETUP_TIME_JOB_FIELD,ST_EXC_TIME_INIT_QTY_FIELD,
  MT_PROD_REQ_Nr_FIELD,MT_PSTEP_ID_FIELD,MT_ORG_STEP_FIELD,MT_WKCTR_CODE_FIELD,MT_RES_CAT_CODE_FIELD,
  MT_RES_CODE_FIELD,MT_MACHIN_SETUP_CODE_FIELD,MT_ALTERNATIVE_CODE_FIELD,MT_PROD_TYPE_FIELD,
  MT_PROD_CODE_FIELD,MT_NET_GROUP_CODE_FIELD,MT_ISSUE_CODE_FIELD,MT_SEQ_ISSUED_FIELD,MT_MAT_BALACE_FIELD,
  MT_QUANTITY_ALLOC_FIELD,MT_HIGH_DATe_ALLOC_FIELD,MT_SEARCH_MAT_BY_ALLOC_FIELD,MT_SETTLED_FIELD,
  MT_QUANTITY_ISSUE_FIELD,MT_REQ_QUANTITY_FIELD,
  PA_PROD_REQ_NR_FIELD,PA_SEQUENCE_FIELD,PA_PROD_CODE_FIELD,PA_NET_GROUP_Code_FIELD,PA_ALL_REQ_FIELD,PA_PROD_BALANCE_FIELD,
  PA_RESOURCE_FIELD,PA_SETTLED_FIELD,PA_REQ_QUANTY_FIELD,PA_QTY_PRODUCED_FIELD,
  PA_QTY_ALL_FIELD : TField;
begin

  var connTF : TMqmDatabase := nil;
  var sFlt   : string       := '';
  if TablesFilter <> '' then
  begin
    connTF := ThreadCloneMainConnection;
    sFlt   := ',' + TablesFilter + ',';
    QryPR  := TMqmQuery.Create(nil); QryPR.Connection  := connTF;
    QryPH  := TMqmQuery.Create(nil); QryPH.Connection  := connTF;
    QryPD  := TMqmQuery.Create(nil); QryPD.Connection  := connTF;
    QryPP  := TMqmQuery.Create(nil); QryPP.Connection  := connTF;
    QryPI  := TMqmQuery.Create(nil); QryPI.Connection  := connTF;
    QryEC  := TMqmQuery.Create(nil); QryEC.Connection  := connTF;
    QryIC  := TMqmQuery.Create(nil); QryIC.Connection  := connTF;
    QrySB  := TMqmQuery.Create(nil); QrySB.Connection  := connTF;
    QrySP  := TMqmQuery.Create(nil); QrySP.Connection  := connTF;
    QryST  := TMqmQuery.Create(nil); QryST.Connection  := connTF;
    QryMT  := TMqmQuery.Create(nil); QryMT.Connection  := connTF;
    QryPA  := TMqmQuery.Create(nil); QryPA.Connection  := connTF;
  end
  else
  begin
    QryPR := ThreadCreateQuery(Main_DB);
    QryPH := ThreadCreateQuery(Main_DB);
    QryPD := ThreadCreateQuery(Main_DB);
    QryPP := ThreadCreateQuery(Main_DB);
    QryPI := ThreadCreateQuery(Main_DB);
    QryEC := ThreadCreateQuery(Main_DB);
    QryIC := ThreadCreateQuery(Main_DB);
    QrySB := ThreadCreateQuery(Main_DB);
    QrySP := ThreadCreateQuery(Main_DB);
    QryST := ThreadCreateQuery(Main_DB);
    QryMT := ThreadCreateQuery(Main_DB);
    QryPA := ThreadCreateQuery(Main_DB);
  end;

  tCurrent := Now;
  tbInfo := @tblInfo[tbl_prod_req];
  if (sFlt = '') or (Pos(',PR,', sFlt) > 0) then
  begin
    Result := LoadSrvTableCompar(tbl_prod_req, WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)), '', QryPR);
    if result then
    begin
   //fldListPR[0].fldTfleld := QryPR.FieldByName(CreateFld(tbInfo.pfx, fldListPR[0].fldPC));
    PR_DIV_CODE_FIELD := QryPR.FieldByName(CreateFld(tbInfo.pfx, fldListPR[0].fldPC));
    PR_DSP_CODE_FIELD := QryPR.FieldByName(CreateFld(tbInfo.pfx, fldListPR[1].fldPC));
    PR_BCH_CODE_FIELD := QryPR.FieldByName(CreateFld(tbInfo.pfx, fldListPR[2].fldPC));
    PR_REPROC_NO_FIELD := QryPR.FieldByName(CreateFld(tbInfo.pfx, fldListPR[3].fldPC));
    PR_PREQ_NO_FIELD   := QryPR.FieldByName(CreateFld(tbInfo.pfx, fldListPR[4].fldPC));
    PR_HISTORICAL_REQ_FIELD := QryPR.FieldByName(CreateFld(tbInfo.pfx, fldListPR[5].fldPC));
    PR_USR_CG_FIELD := QryPR.FieldByName(CreateFld(tbInfo.pfx, fldListPR[6].fldPC));
    PR_USR_TM_CG_FIELD := QryPR.FieldByName(CreateFld(tbInfo.pfx, fldListPR[7].fldPC));

    while not QryPR.Eof do
    begin
      new(RecMQMPR);
      RecMQMPR.PR_DIV_CODE  := Trim(PR_DIV_CODE_FIELD.AsString);
      RecMQMPR.PR_DSP_CODE  := Trim(PR_DSP_CODE_FIELD.AsString);
      RecMQMPR.PR_BCH_CODE  := Trim(PR_BCH_CODE_FIELD.AsString);
      RecMQMPR.PR_REPROC_NO := PR_REPROC_NO_FIELD.AsInteger;
      RecMQMPR.PR_PREQ_NO   := Trim(PR_PREQ_NO_FIELD.AsString);
      RecMQMPR.PR_HISTORICAL_REQ := Trim(PR_HISTORICAL_REQ_FIELD.AsString);
      RecMQMPR.PR_USR_CG         := Trim(PR_USR_CG_FIELD.AsString);
      RecMQMPR.PR_USR_TM_CG := PR_USR_TM_CG_FIELD.AsDateTime;
      RecMQMPR.PR_ModulHandled := '';
      LocalListPR.add(RecMQMPR);
      Inc(IniAppGlobals.Count_Compar_PR);
      QryPR.Next;
    end;

    QryPR.Close;
    IniAppGlobals.Time_Compar_PR := IniAppGlobals.Time_Compar_PR + (Now - tCurrent);
    tCurrent := Now;
    LocalListPR.Sort(SortPR);
    IniAppGlobals.Time_ComparSort_PR := IniAppGlobals.Time_ComparSort_PR + (Now - tCurrent);
    end;
  end
  else
    Result := True;

  if Result and ((sFlt = '') or (Pos(',PH,', sFlt) > 0)) then
  begin
    tCurrent := Now;
    tbInfo := @tblInfo[tbl_prod_reqHdr];
    Result := LoadSrvTableCompar(tbl_prod_reqHdr, WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)), '', QryPH);
    if result then
    begin

      PH_PREQ_NO_FIELD        := QryPH.FieldByName(CreateFld(tbInfo.pfx, fldListPH[0].fldPC));
      PH_HISTORICAL_REQ_FIELD := QryPH.FieldByName(CreateFld(tbInfo.pfx, fldListPH[1].fldPC));
      PH_REQ_ORIGIN_FIELD     := QryPH.FieldByName(CreateFld(tbInfo.pfx, fldListPH[2].fldPC));
      PH_PROD_LINE_FIELD      := QryPH.FieldByName(CreateFld(tbInfo.pfx, fldListPH[3].fldPC));
      PH_TYPE_PROD_FIELD      := QryPH.FieldByName(CreateFld(tbInfo.pfx, fldListPH[4].fldPC));
      PH_PROD_FAMILY_FIELD    := QryPH.FieldByName(CreateFld(tbInfo.pfx, fldListPH[5].fldPC));
      PH_MATERIAL_FAMILY_FIELD := QryPH.FieldByName(CreateFld(tbInfo.pfx, fldListPH[6].fldPC));
      PH_PROD_UM_FIELD         := QryPH.FieldByName(CreateFld(tbInfo.pfx, fldListPH[7].fldPC));
      PH_PROD_LOW_TIME_STRT_FIELD := QryPH.FieldByName(CreateFld(tbInfo.pfx, fldListPH[8].fldPC));
      PH_PROD_DELIVY_DATE_FIELD := QryPH.FieldByName(CreateFld(tbInfo.pfx, fldListPH[9].fldPC));
      PH_FRC_DEL_DATE_FIELD    := QryPH.FieldByName(CreateFld(tbInfo.pfx, fldListPH[10].fldPC));
      PH_USR_CG_FIELD         := QryPH.FieldByName(CreateFld(tbInfo.pfx, fldListPH[11].fldPC));
      PH_USR_TM_CG_FIELD      := QryPH.FieldByName(CreateFld(tbInfo.pfx, fldListPH[12].fldPC));
      PH_SPLITCONFLEVELS_FIELD    := QryPH.FieldByName(CreateFld(tbInfo.pfx, fldListPH[14].fldPC));
      PH_LEAD_STEP_SPLITED_FIELD  := QryPH.FieldByName(CreateFld(tbInfo.pfx, fldListPH[15].fldPC));
      PH_MQM_SPLIT_ID_FIELD := QryPH.FieldByName(CreateFld(tbInfo.pfx, fldListPH[16].fldPC));
      PH_Serving_Code_FIELD := QryPH.FieldByName(CreateFld(tbInfo.pfx, fldListPH[17].fldPC));
      PH_Served_Code_FIELD := QryPH.FieldByName(CreateFld(tbInfo.pfx, fldListPH[18].fldPC));
      PH_Curve_Family_Id_Code_FIELD := QryPH.FieldByName(CreateFld(tbInfo.pfx, fldListPH[19].fldPC));
      PH_ModulHandled_FIELD := QryPH.FieldByName(CreateFld(tbInfo.pfx,fli_ModulHandled));

      while not QryPH.Eof do
      begin

        new(RecMQMPH);
        RecMQMPH.PH_PREQ_NO        := Trim(PH_PREQ_NO_FIELD.AsString);
        RecMQMPH.PH_HISTORICAL_REQ := Trim(PH_HISTORICAL_REQ_FIELD.AsString);
        RecMQMPH.PH_REQ_ORIGIN     := Trim(PH_REQ_ORIGIN_FIELD.AsString);
        RecMQMPH.PH_PROD_LINE      := Trim(PH_PROD_LINE_FIELD.AsString);
        RecMQMPH.PH_TYPE_PROD      := Trim(PH_TYPE_PROD_FIELD.AsString);
        RecMQMPH.PH_PROD_FAMILY    := Trim(PH_PROD_FAMILY_FIELD.AsString);
        RecMQMPH.PH_MATERIAL_FAMILY := Trim(PH_MATERIAL_FAMILY_FIELD.AsString);
        RecMQMPH.PH_PROD_UM         := Trim(PH_PROD_UM_FIELD.AsString);
        RecMQMPH.PH_PROD_LOW_TIME_STRT := PH_PROD_LOW_TIME_STRT_FIELD.AsDateTime;
        RecMQMPH.PH_PROD_DELIVY_DATE := PH_PROD_DELIVY_DATE_FIELD.AsDateTime;
        RecMQMPH.PH_FRC_DEL_DATE    := Trim(PH_FRC_DEL_DATE_FIELD.AsString);
        RecMQMPH.PH_USR_CG         := Trim(PH_USR_CG_FIELD.AsString);
        RecMQMPH.PH_USR_TM_CG      := PH_USR_TM_CG_FIELD.AsDateTime;
        RecMQMPH.PH_SPLITCONFLEVELS    := Trim(PH_SPLITCONFLEVELS_FIELD.AsString);
        RecMQMPH.PH_LEAD_STEP_SPLITED  := PH_LEAD_STEP_SPLITED_FIELD.AsInteger;
        RecMQMPH.PH_MQM_SPLIT_ID := Trim(PH_MQM_SPLIT_ID_FIELD.AsString);
        RecMQMPH.PH_Serving_Code := Trim(PH_Serving_Code_FIELD.AsString);
        RecMQMPH.PH_Served_Code := Trim(PH_Served_Code_FIELD.AsString);
        RecMQMPH.PH_Curve_Family_Id_Code := Trim(PH_Curve_Family_Id_Code_FIELD.AsString);
        RecMQMPH.PH_ModulHandled := PH_ModulHandled_FIELD.AsString;
        LocalListPH.add(RecMQMPH);
        Inc(IniAppGlobals.Count_Compar_PH);
        QryPH.Next;
      end;
      QryPH.Close;
      IniAppGlobals.Time_Compar_PH := IniAppGlobals.Time_Compar_PH + (Now - tCurrent);
      tCurrent := Now;
      LocalListPH.Sort(SortPH);
      IniAppGlobals.Time_ComparSort_PH := IniAppGlobals.Time_ComparSort_PH + (Now - tCurrent);
    end;
  end;
  if Result and ((sFlt = '') or (Pos(',PD,', sFlt) > 0)) then
  begin
    tCurrent := Now;
    tbInfo := @tblInfo[tbl_prod_step];
    Result := LoadSrvTableCompar(tbl_prod_step, WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)), '', QryPD);

    if result then
    begin

      PD_PREQ_NO_FIELD  := QryPD.FieldByName(CreateFld(tbInfo.pfx, fldListPD[0].fldPC));
      PD_PSTEP_ID_FIELD := QryPD.FieldByName(CreateFld(tbInfo.pfx, fldListPD[1].fldPC));
      PD_TO_SCHED_FIELD := QryPD.FieldByName(CreateFld(tbInfo.pfx, fldListPD[2].fldPC));
      PD_PRV_STEP_SCHED_MQM_FIELD := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[3].fldPC));
      PD_PRV_STEP_TRUE_FIELD  := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[4].fldPC));
      PD_NEX_STEP_SCHED_MQM_FIELD := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[5].fldPC));
      PD_NEX_STEP_TRUE_FIELD  := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[6].fldPC));
      PD_STEP_TYP_FIELD       := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[7].fldPC));
      PD_MAT_ARRV_DATE_FIELD  := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[8].fldPC));
      PD_FRC_MAT_DATE_FIELD   := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[9].fldPC));
      PD_PLAN_START_FIELD := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[10].fldPC));
      PD_LOW_LIMIT_TIME_STRT_FIELD := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[11].fldPC));
      PD_FRC_LOW_DATE_FIELD := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[12].fldPC));
      PD_PLAN_END_FIELD := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[13].fldPC));
      PD_HIGH_LIMIT_TIMEND_FIELD := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[14].fldPC));
      PD_FRC_HIGH_DATE_FIELD     := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[15].fldPC));
      PD_WKCNTER_FIELD           := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[16].fldPC));
      PD_WKCT_PROC_FIELD         := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[17].fldPC));
      PD_INIT_QUENT_FIELD        := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[18].fldPC));
      PD_FIN_QUENT_FIELD         := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[19].fldPC));
      PD_WEIGHT_FIELD            := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[20].fldPC));
      PD_DESC_UM_FIELD           := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[21].fldPC));
      PD_CAL_FIELD               := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[22].fldPC));
      PD_SETUP_TIME_STP_FIELD    := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[23].fldPC));
      PD_EXC_TIME_STP_FIELD      := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[24].fldPC));
      PD_RES_NUM_PLN_FIELD       := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[25].fldPC));
      PD_ALLOW_SPLIT_FIELD       := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[26].fldPC));
      PD_STEP_HANDLE_REPROCES_FIELD := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[27].fldPC));
      PD_STEP_PART_GEN_PLAN_FIELD   := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[28].fldPC));
      PD_STEP_CAN_GROUP_FIELD       := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[29].fldPC));
      PD_FORCED_GRP_NO_FIELD        := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[30].fldPC));
      PD_CONN_TYPE_PREV_STEP_SPLIT_FIELD := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[31].fldPC));
      PD_FRC_OVERLAPP_FIELD := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[32].fldPC));
      PD_STEP_CLOSED_FIELD  := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[33].fldPC));

      PD_USR_CG_FIELD         := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[34].fldPC));
      PD_USR_TM_CG_FIELD := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[35].fldPC));
      PD_SchedulByMcm_FIELD := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[36].fldPC));
      PD_SplitFamily_FIELD  := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[37].fldPC));
      PD_LearningCurveCode_FIELD               := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[38].fldPC));
      PD_LearningCurveType_FIELD               := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[39].fldPC));
      PD_OVERLAP_WITH_OTHER_STEPS_FIELD := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[40].fldPC));
      PD_ApprovalDate_FIELD := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[41].fldPC));
      PD_GRP_SEQUENCE_FIELD := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[42].fldPC));
      PD_Prev_LeadTime_mqm_FIELD  := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[43].fldPC));
      PD_Next_LeadTime_mqm_FIELD  := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[44].fldPC));

      PD_Prev_LeadTimeBatch_mqm_FIELD := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[45].fldPC));
      PD_Next_LeadTimeBatch_mqm_FIELD := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[46].fldPC));
      PD_MinBatchSize_FIELD     := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[47].fldPC));
      PD_OptimumBatchSize_FIELD := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[48].fldPC));
      PD_MaxBatchSize_FIELD     := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[49].fldPC));
      PD_BatchSizePerStep_FIELD  := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[50].fldPC));
      PD_SchedulByMqm_FIELD := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[51].fldPC));
      PD_PRV_STEP_SCHED_MCM_FIELD  := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[52].fldPC));
      PD_NEX_STEP_SCHED_MCM_FIELD  := QryPD.FieldByName(CreateFld(tbInfo.pfx,fldListPD[53].fldPC));
      PD_Prev_LeadTime_Mcm_FIELD   := QryPD.FieldByName(CreateFld(tbInfo.pfx,fli_PrevLeadTime_Mcm));
      PD_Next_LeadTime_Mcm_FIELD   :=  QryPD.FieldByName(CreateFld(tbInfo.pfx,fli_NextLeadTime_Mcm));
      PD_Prev_LeadTimeBatch_mcm_FIELD := QryPD.FieldByName(CreateFld(tbInfo.pfx,fli_PrevLeadTimeBatch_Mcm));
      PD_Next_LeadTimeBatch_mcm_FIELD := QryPD.FieldByName(CreateFld(tbInfo.pfx,fli_NextLeadTimeBatch_Mcm));
      PD_INITIALPLANSCHEDDATETIME_FIELD := QryPD.FieldByName(CreateFld(tbInfo.pfx,fli_InitialPlanScheduledDateTime));
      PD_FINALPLANSCHEDDATETIME_FIELD := QryPD.FieldByName(CreateFld(tbInfo.pfx,fli_FinalPlanScheduledDateTime));
      PD_NumResComponents_FIELD      := QryPD.FieldByName(CreateFld(tbInfo.pfx,fli_NumSubRscComponents));
      PD_MaxStartDateAutoSeq_FIELD   := QryPD.FieldByName(CreateFld(tbInfo.pfx,fli_MaxStartDateAutoSeq));
      PD_ALTERNATIVEQTY_FIELD        := QryPD.FieldByName(CreateFld(tbInfo.pfx,fli_alternative_Qty));
      PD_PD_ALTERNATIVEUM_FIELD      := QryPD.FieldByName(CreateFld(tbInfo.pfx,fli_alternative_UM));

      while not QryPD.Eof do
      begin
        new(RecMQMPD);
        RecMQMPD.PD_PREQ_NO  := Trim(PD_PREQ_NO_FIELD.AsString);
        RecMQMPD.PD_PSTEP_ID := PD_PSTEP_ID_FIELD.AsInteger;
        RecMQMPD.PD_TO_SCHED := Trim(PD_TO_SCHED_FIELD.AsString);
        RecMQMPD.PD_PRV_STEP_SCHED_MQM := PD_PRV_STEP_SCHED_MQM_FIELD.AsInteger;
        RecMQMPD.PD_PRV_STEP_TRUE  := PD_PRV_STEP_TRUE_FIELD.AsInteger;
        RecMQMPD.PD_NEX_STEP_SCHED_MQM := PD_NEX_STEP_SCHED_MQM_FIELD.AsInteger;
        RecMQMPD.PD_NEX_STEP_TRUE  := PD_NEX_STEP_TRUE_FIELD.AsInteger;
        RecMQMPD.PD_STEP_TYP       := Trim(PD_STEP_TYP_FIELD.AsString);
        RecMQMPD.PD_MAT_ARRV_DATE  := PD_MAT_ARRV_DATE_FIELD.AsDateTime;
        RecMQMPD.PD_FRC_MAT_DATE   := Trim(PD_FRC_MAT_DATE_FIELD.AsString);
        RecMQMPD.PD_PLAN_START     := PD_PLAN_START_FIELD.AsDateTime;
        RecMQMPD.PD_LOW_LIMIT_TIME_STRT := PD_LOW_LIMIT_TIME_STRT_FIELD.AsDateTime;
        RecMQMPD.PD_FRC_LOW_DATE      := Trim(PD_FRC_LOW_DATE_FIELD.AsString);
        RecMQMPD.PD_PLAN_END          := PD_PLAN_END_FIELD.AsDateTime;
        RecMQMPD.PD_HIGH_LIMIT_TIMEND := PD_HIGH_LIMIT_TIMEND_FIELD.AsDateTime;
        RecMQMPD.PD_FRC_HIGH_DATE     := Trim(PD_FRC_HIGH_DATE_FIELD.AsString);
        RecMQMPD.PD_WKCNTER           := Trim(PD_WKCNTER_FIELD.AsString);
        RecMQMPD.PD_WKCT_PROC         := Trim(PD_WKCT_PROC_FIELD.AsString);
        RecMQMPD.PD_INIT_QUENT        := PD_INIT_QUENT_FIELD.AsFloat;
        RecMQMPD.PD_FIN_QUENT         := PD_FIN_QUENT_FIELD.AsFloat;
        RecMQMPD.PD_WEIGHT            := PD_WEIGHT_FIELD.AsInteger;
        RecMQMPD.PD_DESC_UM           := Trim(PD_DESC_UM_FIELD.AsString);
        RecMQMPD.PD_CAL               := Trim(PD_CAL_FIELD.AsString);
        RecMQMPD.PD_SETUP_TIME_STP    := PD_SETUP_TIME_STP_FIELD.AsFloat;
        RecMQMPD.PD_EXC_TIME_STP      := PD_EXC_TIME_STP_FIELD.AsFloat;
        RecMQMPD.PD_RES_NUM_PLN       := PD_RES_NUM_PLN_FIELD.AsFloat;
        RecMQMPD.PD_ALLOW_SPLIT       := Trim(PD_ALLOW_SPLIT_FIELD.AsString);
        RecMQMPD.PD_STEP_HANDLE_REPROCES := Trim(PD_STEP_HANDLE_REPROCES_FIELD.AsString);
        RecMQMPD.PD_STEP_PART_GEN_PLAN   := Trim(PD_STEP_PART_GEN_PLAN_FIELD.AsString);
        RecMQMPD.PD_STEP_CAN_GROUP       := Trim(PD_STEP_CAN_GROUP_FIELD.AsString);
        RecMQMPD.PD_FORCED_GRP_NO        := PD_FORCED_GRP_NO_FIELD.AsInteger;
        RecMQMPD.PD_CONN_TYPE_PREV_STEP_SPLIT := Trim(PD_CONN_TYPE_PREV_STEP_SPLIT_FIELD.AsString);
        RecMQMPD.PD_FRC_OVERLAPP := Trim(PD_FRC_OVERLAPP_FIELD.AsString);
        RecMQMPD.PD_STEP_CLOSED  := Trim(PD_STEP_CLOSED_FIELD.AsString);

        RecMQMPD.PD_USR_CG         := Trim(PD_USR_CG_FIELD.AsString);
        RecMQMPD.PD_USR_TM_CG      := PD_USR_TM_CG_FIELD.AsDateTime;
        RecMQMPD.PD_SchedulByMcm := PD_SchedulByMcm_FIELD.AsString;
        RecMQMPD.PD_SplitFamily  := Trim(PD_SplitFamily_FIELD.AsString);
        RecMQMPD.PD_LearningCurveCode               := Trim(PD_LearningCurveCode_FIELD.AsString);
        RecMQMPD.PD_LearningCurveType               := Trim(PD_LearningCurveType_FIELD.AsString);
        RecMQMPD.PD_OVERLAP_WITH_OTHER_STEPS := Trim(PD_OVERLAP_WITH_OTHER_STEPS_FIELD.AsString);
        RecMQMPD.PD_ApprovalDate := PD_ApprovalDate_FIELD.AsDateTime;
        RecMQMPD.PD_GRP_SEQUENCE := PD_GRP_SEQUENCE_FIELD.AsString;
        RecMQMPD.PD_Prev_LeadTime_mqm  := PD_Prev_LeadTime_mqm_FIELD.AsFloat;
        RecMQMPD.PD_Next_LeadTime_mqm  := PD_Next_LeadTime_mqm_FIELD.AsFloat;

        RecMQMPD.PD_Prev_LeadTimeBatch_mqm := PD_Prev_LeadTimeBatch_mqm_FIELD.AsFloat;
        RecMQMPD.PD_Next_LeadTimeBatch_mqm := PD_Next_LeadTimeBatch_mqm_FIELD.AsFloat;
        RecMQMPD.PD_MinBatchSize     := PD_MinBatchSize_FIELD.AsFloat;
        RecMQMPD.PD_OptimumBatchSize := PD_OptimumBatchSize_FIELD.AsFloat;
        RecMQMPD.PD_MaxBatchSize     := PD_MaxBatchSize_FIELD.AsFloat;
        RecMQMPD.PD_BatchSizePerStep  := PD_BatchSizePerStep_FIELD.AsString;
        RecMQMPD.PD_SchedulByMqm      := PD_SchedulByMqm_FIELD.AsString;
        RecMQMPD.PD_PRV_STEP_SCHED_MCM  := PD_PRV_STEP_SCHED_MCM_FIELD.AsInteger;
        RecMQMPD.PD_NEX_STEP_SCHED_MCM  := PD_NEX_STEP_SCHED_MCM_FIELD.AsInteger;
        RecMQMPD.PD_Prev_LeadTime_Mcm   := PD_Prev_LeadTime_Mcm_FIELD.AsFloat;
        RecMQMPD.PD_Next_LeadTime_Mcm   :=  PD_Next_LeadTime_Mcm_FIELD.AsFloat;
        RecMQMPD.PD_Prev_LeadTimeBatch_mcm := PD_Prev_LeadTimeBatch_mcm_FIELD.AsFloat;
        RecMQMPD.PD_Next_LeadTimeBatch_mcm := PD_Next_LeadTimeBatch_mcm_FIELD.AsFloat;
        RecMQMPD.PD_INITIALPLANSCHEDDATETIME := PD_INITIALPLANSCHEDDATETIME_FIELD.AsFloat;
        RecMQMPD.PD_FINALPLANSCHEDDATETIME:= PD_FINALPLANSCHEDDATETIME_FIELD.AsFloat;
        RecMQMPD.PD_NumResComponents      := PD_NumResComponents_FIELD.Asinteger;
        RecMQMPD.PD_MaxStartDateAutoSeq   := PD_MaxStartDateAutoSeq_FIELD.AsDateTime;
        RecMQMPD.PD_ALTERNATIVEQTY        := PD_ALTERNATIVEQTY_FIELD.AsFloat;
        RecMQMPD.PD_ALTERNATIVEUM         := PD_PD_ALTERNATIVEUM_FIELD.AsString;
        LocalListPD.add(RecMQMPD);
        Inc(IniAppGlobals.Count_Compar_PD);
        QryPD.Next;
      end;
      QryPD.Close;
      IniAppGlobals.Time_Compar_PD := IniAppGlobals.Time_Compar_PD + (Now - tCurrent);
      tCurrent := Now;
      LocalListPD.Sort(SortPD);
      IniAppGlobals.Time_ComparSort_PD := IniAppGlobals.Time_ComparSort_PD + (Now - tCurrent);
    end;
  end;
  if Result and ((sFlt = '') or (Pos(',PP,', sFlt) > 0)) then
  begin
    tCurrent := Now;
    tbInfo := @tblInfo[tbl_prop_prod];
    SelectedColumns := CreateFld(tbInfo.pfx, fli_preqNo) + ',' + CreateFld(tbInfo.pfx, fli_pstepId) + ',' +
                       CreateFld(tbInfo.pfx, fli_PropertyCode) + ',' + CreateFld(tbInfo.pfx, fli_rsc) + ',' + CreateFld(tbInfo.pfx,fli_value);
    OrderBy := ' Order by ' + CreateFld(tbInfo.pfx,fli_preqNo) + ',' + CreateFld(tbInfo.pfx,fli_pstepId) + ',' +
                              CreateFld(tbInfo.pfx,fli_PropertyCode) + ',' + CreateFld(tbInfo.pfx,fli_rsc);
    Result := LoadSrvTableCompar(tbl_prop_prod, WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)), OrderBy, QryPP, SelectedColumns);

    if Result then
    begin

      PP_PREQ_NO_FIELD := QryPP.FieldByName(CreateFld(tbInfo.pfx, fldListPP[0].fldPC));
      PP_PSTEP_ID_FIELD := QryPP.FieldByName(CreateFld(tbInfo.pfx, fldListPP[1].fldPC));
      PP_RSC_CODE_FIELD := QryPP.FieldByName(CreateFld(tbInfo.pfx, fldListPP[2].fldPC));
      PP_PROPERTY_FIELD := QryPP.FieldByName(CreateFld(tbInfo.pfx, fldListPP[3].fldPC));
      PP_VALUE_FIELD    := QryPP.FieldByName(CreateFld(tbInfo.pfx, fldListPP[4].fldPC));

      bSortNeeded_PP := False;
      sPrevKey_PP    := '';
      while not QryPP.Eof do
      begin
        new(RecMQMPP);
        RecMQMPP.PP_PREQ_NO := Trim(PP_PREQ_NO_FIELD.AsString);
        RecMQMPP.PP_PSTEP_ID := PP_PSTEP_ID_FIELD.AsInteger;
        RecMQMPP.PP_RSC_CODE := Trim(PP_RSC_CODE_FIELD.AsString);
        RecMQMPP.PP_PROPERTY := Trim(PP_PROPERTY_FIELD.AsString);
        RecMQMPP.PP_VALUE    := Trim(PP_VALUE_FIELD.AsString);
        RecMQMPP.PP_SortKey := RecMQMPP.PP_PREQ_NO + Chr(1) +
                               Format('%010d', [RecMQMPP.PP_PSTEP_ID]) + Chr(1) +
                               RecMQMPP.PP_PROPERTY + Chr(1) +
                               RecMQMPP.PP_RSC_CODE;
        if RecMQMPP.PP_SortKey < sPrevKey_PP then
          bSortNeeded_PP := True;
        sPrevKey_PP := RecMQMPP.PP_SortKey;
        LocalListPP.add(RecMQMPP);
        Inc(IniAppGlobals.Count_Compar_PP);
        QryPP.Next;
      end;
      QryPP.Close;
      IniAppGlobals.Time_Compar_PP := IniAppGlobals.Time_Compar_PP + (Now - tCurrent);
      if bSortNeeded_PP then
      begin
        tCurrent := Now;
        LocalListPP.Sort(SortPP);
        IniAppGlobals.Time_ComparSort_PP := IniAppGlobals.Time_ComparSort_PP + (Now - tCurrent);
      end;
    end;

  end;
  if Result and ((sFlt = '') or (Pos(',PI,', sFlt) > 0)) then
  begin
    tCurrent := Now;
    tbInfo := @tblInfo[tbl_prod_info];
    Result := LoadSrvTableCompar(tbl_prod_info, WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)), '', QryPI);
    if Result then
    begin

      PI_PREQ_NO_FIELD       := QryPI.FieldByName(CreateFld(tbInfo.pfx, fldListPI[0].fldPC));
      PI_PSTEP_ID_FIELD      := QryPI.FieldByName(CreateFld(tbInfo.pfx, fldListPI[1].fldPC));
      PI_INFO_TYPE_FIELD     := QryPI.FieldByName(CreateFld(tbInfo.pfx, fldListPI[2].fldPC));
      PI_INFO_LINE_NUM_FIELD := QryPI.FieldByName(CreateFld(tbInfo.pfx, fldListPI[3].fldPC));
      PI_INFO_AREA_FIELD     := QryPI.FieldByName(CreateFld(tbInfo.pfx, fldListPI[4].fldPC));
      PI_USR_CG_FIELD        := QryPI.FieldByName(CreateFld(tbInfo.pfx, fldListPI[5].fldPC));
      PI_USR_TM_CG_FIELD     := QryPI.FieldByName(CreateFld(tbInfo.pfx, fldListPI[6].fldPC));

      while not QryPI.Eof do
      begin
        new(RecMQMPI);
        RecMQMPI.PI_PREQ_NO := Trim(PI_PREQ_NO_FIELD.AsString);
        RecMQMPI.PI_PSTEP_ID := PI_PSTEP_ID_FIELD.AsInteger;
        RecMQMPI.PI_INFO_TYPE := Trim(PI_INFO_TYPE_FIELD.AsString);
        RecMQMPI.PI_INFO_LINE_NUM := PI_INFO_LINE_NUM_FIELD.AsInteger;
        RecMQMPI.PI_INFO_AREA := Trim(PI_INFO_AREA_FIELD.AsString);
        RecMQMPI.PI_USR_CG    := Trim(PI_USR_CG_FIELD.AsString);
        RecMQMPI.PI_USR_TM_CG := PI_USR_TM_CG_FIELD.AsDateTime;

        LocalListPI.add(RecMQMPI);
        Inc(IniAppGlobals.Count_Compar_PI);
        QryPI.Next;
      end;
      QryPI.Close;
      IniAppGlobals.Time_Compar_PI := IniAppGlobals.Time_Compar_PI + (Now - tCurrent);
      tCurrent := Now;
      LocalListPI.Sort(SortPI);
      IniAppGlobals.Time_ComparSort_PI := IniAppGlobals.Time_ComparSort_PI + (Now - tCurrent);
    end;
  end;

  if Result and ((sFlt = '') or (Pos(',EC,', sFlt) > 0)) then
  begin
    tCurrent := Now;
    tbInfo := @tblInfo[tbl_ext_connection];
    Result := LoadSrvTableCompar(tbl_ext_connection, WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)), '', QryEC);
    if result then
    begin
      while not QryEC.Eof do
      begin
        new(RecMQMEC);
        RecMQMEC.EC_PREQ_NO := Trim(QryEC.FieldByName(CreateFld(tbInfo.pfx, fldListEC[0].fldPC)).AsString);
        RecMQMEC.EC_CONNE_KEY := Trim(QryEC.FieldByName(CreateFld(tbInfo.pfx, fldListEC[1].fldPC)).AsString);
        RecMQMEC.EC_NUM_LEVELS := QryEC.FieldByName(CreateFld(tbInfo.pfx, fldListEC[2].fldPC)).AsInteger;
        RecMQMEC.EC_CONN_CERTENT_LEVEL := Trim(QryEC.FieldByName(CreateFld(tbInfo.pfx, fldListEC[3].fldPC)).AsString);
        RecMQMEC.EC_USR_CG    := Trim(QryEC.FieldByName(CreateFld(tbInfo.pfx, fldListEC[4].fldPC)).AsString);
        RecMQMEC.EC_USR_TM_CG := QryEC.FieldByName(CreateFld(tbInfo.pfx, fldListEC[5].fldPC)).AsDateTime;
        LocalListEC.add(RecMQMEC);
        Inc(IniAppGlobals.Count_Compar_EC);
        QryEC.Next;
      end;
      QryEC.Close;
      IniAppGlobals.Time_Compar_EC := IniAppGlobals.Time_Compar_EC + (Now - tCurrent);
      tCurrent := Now;
      LocalListEC.Sort(SortEC);
      IniAppGlobals.Time_ComparSort_EC := IniAppGlobals.Time_ComparSort_EC + (Now - tCurrent);
    end;

  end;
  if Result and ((sFlt = '') or (Pos(',IC,', sFlt) > 0)) then
  begin
    tCurrent := Now;
    tbInfo := @tblInfo[tbl_prod_reqConnection];
    Result := LoadSrvTableCompar(tbl_prod_reqConnection, WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)), '', QryIC);
    if result then
    begin
      while not QryIC.Eof do
      begin
        new(RecMQMIC);
        RecMQMIC.IC_PREQ_NO      := Trim(QryIC.FieldByName(CreateFld(tbInfo.pfx, fldListIC[0].fldPC)).AsString);
        RecMQMIC.IC_PREV_PREQ_NO := Trim(QryIC.FieldByName(CreateFld(tbInfo.pfx, fldListIC[1].fldPC)).AsString);
        RecMQMIC.IC_USR_CG       := Trim(QryIC.FieldByName(CreateFld(tbInfo.pfx, fldListIC[2].fldPC)).AsString);
        RecMQMIC.IC_USR_TM_CG    := QryIC.FieldByName(CreateFld(tbInfo.pfx, fldListIC[3].fldPC)).AsDateTime;
        LocalListIC.add(RecMQMIC);
        Inc(IniAppGlobals.Count_Compar_IC);
        QryIC.Next;
      end;
      QryIC.Close;
      IniAppGlobals.Time_Compar_IC := IniAppGlobals.Time_Compar_IC + (Now - tCurrent);
      tCurrent := Now;
      LocalListIC.Sort(SortIC);
      IniAppGlobals.Time_ComparSort_IC := IniAppGlobals.Time_ComparSort_IC + (Now - tCurrent);
    end;
  end;
  if Result and ((sFlt = '') or (Pos(',SB,', sFlt) > 0)) then
  begin
    tCurrent := Now;
    tbInfo := @tblInfo[tbl_step_batchSize];
    Result := LoadSrvTableCompar(tbl_step_batchSize, WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)), '', QrySB);

    if result then
    begin
      SB_PREQ_NO_FIELD := QrySB.FieldByName(CreateFld(tbInfo.pfx, fldListSB[0].fldPC));
      SB_PSTEP_ID_FIELD := QrySB.FieldByName(CreateFld(tbInfo.pfx, fldListSB[1].fldPC));
      SB_BCH_UM_FIELD := QrySB.FieldByName(CreateFld(tbInfo.pfx, fldListSB[2].fldPC));
      SB_MULTIPILR_TO_BATCH_UM_FIELD := QrySB.FieldByName(CreateFld(tbInfo.pfx, fldListSB[3].fldPC));
      while not QrySB.Eof do
      begin
        new(RecMQMSB);
        RecMQMSB.SB_PREQ_NO  := Trim(SB_PREQ_NO_FIELD.AsString);
        RecMQMSB.SB_PSTEP_ID := SB_PSTEP_ID_FIELD.AsInteger;
        RecMQMSB.SB_BCH_UM   := Trim(SB_BCH_UM_FIELD.AsString);
        RecMQMSB.SB_MULTIPILR_TO_BATCH_UM := SB_MULTIPILR_TO_BATCH_UM_FIELD.AsFloat;
        LocalListSB.add(RecMQMSB);
        Inc(IniAppGlobals.Count_Compar_SB);
        QrySB.Next;
      end;
      QrySB.Close;
      IniAppGlobals.Time_Compar_SB := IniAppGlobals.Time_Compar_SB + (Now - tCurrent);
      tCurrent := Now;
      LocalListSB.Sort(SortSB);
      IniAppGlobals.Time_ComparSort_SB := IniAppGlobals.Time_ComparSort_SB + (Now - tCurrent);
    end;

  end;
  if Result and ((sFlt = '') or (Pos(',SP,', sFlt) > 0)) then
  begin
    tCurrent := Now;
    tbInfo := @tblInfo[tbl_sched_progress];
    Result := LoadSrvTableCompar(tbl_sched_progress, WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)), '', QrySP);

    if result then
    begin
      SP_PREQ_NO_FIELD := QrySP.FieldByName(CreateFld(tbInfo.pfx, fldListSP[0].fldPC));
      SP_PSTEP_ID_FIELD := QrySP.FieldByName(CreateFld(tbInfo.pfx, fldListSP[1].fldPC));
      SP_PSUBST_ID_FIELD := QrySP.FieldByName(CreateFld(tbInfo.pfx, fldListSP[2].fldPC));
      SP_REPROC_NO_FIELD := QrySP.FieldByName(CreateFld(tbInfo.pfx, fldListSP[3].fldPC));
      SP_LAST_PROG_TYPE_FIELD := QrySP.FieldByName(CreateFld(tbInfo.pfx, fldListSP[4].fldPC));
      SP_RSC_CODE_FIELD       := QrySP.FieldByName(CreateFld(tbInfo.pfx, fldListSP[5].fldPC));
      SP_PROGRESED_GROUP_FIELD := QrySP.FieldByName(CreateFld(tbInfo.pfx, fldListSP[6].fldPC));
      SP_PROGRSTART_FIELD      := QrySP.FieldByName(CreateFld(tbInfo.pfx, fldListSP[7].fldPC));
      SP_CURR_PRG_DATE_FIELD   := QrySP.FieldByName(CreateFld(tbInfo.pfx, fldListSP[8].fldPC));
      SP_PROGREND_FIELD        := QrySP.FieldByName(CreateFld(tbInfo.pfx, fldListSP[9].fldPC));
      SP_QTY_FIELD             := QrySP.FieldByName(CreateFld(tbInfo.pfx, fldListSP[10].fldPC));
      SP_StartingQty_FIELD     := QrySP.FieldByName(CreateFld(tbInfo.pfx, fldListSP[11].fldPC));
      SP_REMAIN_TIME_FIELD     := QrySP.FieldByName(CreateFld(tbInfo.pfx, fldListSP[12].fldPC));
      SP_LAST_PROG_TYPE_HOST_FIELD := QrySP.FieldByName(CreateFld(tbInfo.pfx, fldListSP[13].fldPC));
      SP_RSC_CODE_HOST_FIELD       := QrySP.FieldByName(CreateFld(tbInfo.pfx, fldListSP[14].fldPC));
      SP_PROGRSTART_HOST_FIELD     := QrySP.FieldByName(CreateFld(tbInfo.pfx, fldListSP[15].fldPC));
      SP_CURR_PRG_DATE_HOST_FIELD  := QrySP.FieldByName(CreateFld(tbInfo.pfx, fldListSP[16].fldPC));
      SP_PROGREND_HOST_FIELD       := QrySP.FieldByName(CreateFld(tbInfo.pfx, fldListSP[17].fldPC));
      SP_QTY_HOST_FIELD            := QrySP.FieldByName(CreateFld(tbInfo.pfx, fldListSP[18].fldPC));
      SP_REMAIN_TIME_HOST_FIELD    := QrySP.FieldByName(CreateFld(tbInfo.pfx, fldListSP[19].fldPC));

      while not QrySP.Eof do
      begin
        new(RecMQMSP);
        RecMQMSP.SP_PREQ_NO := Trim(SP_PREQ_NO_FIELD.AsString);
        RecMQMSP.SP_PSTEP_ID := SP_PSTEP_ID_FIELD.AsInteger;
        RecMQMSP.SP_PSUBST_ID := SP_PSUBST_ID_FIELD.AsInteger;
        RecMQMSP.SP_REPROC_NO := SP_REPROC_NO_FIELD.AsInteger;
        RecMQMSP.SP_LAST_PROG_TYPE := Trim(SP_LAST_PROG_TYPE_FIELD.AsString);
        RecMQMSP.SP_RSC_CODE := Trim(SP_RSC_CODE_FIELD.AsString);
        RecMQMSP.SP_PROGRESED_GROUP := SP_PROGRESED_GROUP_FIELD.AsInteger;
        RecMQMSP.SP_PROGRSTART := SP_PROGRSTART_FIELD.AsDateTime;
        RecMQMSP.SP_CURR_PRG_DATE := SP_CURR_PRG_DATE_FIELD.AsDateTime;
        RecMQMSP.SP_PROGREND := SP_PROGREND_FIELD.AsDateTime;
        RecMQMSP.SP_QTY := SP_QTY_FIELD.AsFloat;
        RecMQMSP.SP_StartingQty  := SP_StartingQty_FIELD.AsFloat;
        RecMQMSP.SP_REMAIN_TIME := SP_REMAIN_TIME_FIELD.AsFloat;
        RecMQMSP.SP_LAST_PROG_TYPE_HOST := Trim(SP_LAST_PROG_TYPE_HOST_FIELD.AsString);
        RecMQMSP.SP_RSC_CODE_HOST       := Trim(SP_RSC_CODE_HOST_FIELD.AsString);
        RecMQMSP.SP_PROGRSTART_HOST     := SP_PROGRSTART_HOST_FIELD.AsDateTime;
        RecMQMSP.SP_CURR_PRG_DATE_HOST  := SP_CURR_PRG_DATE_HOST_FIELD.AsDateTime;
        RecMQMSP.SP_PROGREND_HOST       := SP_PROGREND_HOST_FIELD.AsDateTime;
        RecMQMSP.SP_QTY_HOST            := SP_QTY_HOST_FIELD.AsFloat;
        RecMQMSP.SP_REMAIN_TIME_HOST    := SP_REMAIN_TIME_HOST_FIELD.AsFloat;

        LocalListSP.add(RecMQMSP);
        Inc(IniAppGlobals.Count_Compar_SP);
        QrySP.Next;
      end;
      QrySP.Close;
      IniAppGlobals.Time_Compar_SP := IniAppGlobals.Time_Compar_SP + (Now - tCurrent);
      tCurrent := Now;
      LocalListSP.Sort(SortSP);
      IniAppGlobals.Time_ComparSort_SP := IniAppGlobals.Time_ComparSort_SP + (Now - tCurrent);
    end;

  end;
  if Result and ((sFlt = '') or (Pos(',ST,', sFlt) > 0)) then
  begin
    tCurrent := Now;
    tbInfo := @tblInfo[tbl_step_times];
    Result := LoadSrvTableCompar(tbl_step_times, WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)), '', QryST);

    if result then
    begin
      ST_PREQ_NO_FIELD := QryST.FieldByName(CreateFld(tbInfo.pfx, fldListST[0].fldPC));
      ST_PSTEP_ID_FIELD := QryST.FieldByName(CreateFld(tbInfo.pfx, fldListST[1].fldPC));
      ST_WKCNTER_FIELD  := QryST.FieldByName(CreateFld(tbInfo.pfx, fldListST[2].fldPC));
      ST_WKCT_PROC_FIELD := QryST.FieldByName(CreateFld(tbInfo.pfx, fldListST[3].fldPC));
      ST_RES_CATEGORY_FIELD := QryST.FieldByName(CreateFld(tbInfo.pfx, fldListST[4].fldPC));
      ST_RSC_CODE_FIELD     := QryST.FieldByName(CreateFld(tbInfo.pfx, fldListST[5].fldPC));
      ST_SETUP_TIME_Mechin_Code_FIELD := QryST.FieldByName(CreateFld(tbInfo.pfx, fldListST[6].fldPC));
      ST_SETUP_TIME_JOB_FIELD := QryST.FieldByName(CreateFld(tbInfo.pfx, fldListST[7].fldPC));
      ST_EXC_TIME_INIT_QTY_FIELD := QryST.FieldByName(CreateFld(tbInfo.pfx, fldListST[8].fldPC));
      while not QryST.Eof do
      begin
        new(RecMQMST);
        RecMQMST.ST_PREQ_NO                := Trim(ST_PREQ_NO_FIELD.AsString);
        RecMQMST.ST_PSTEP_ID               := ST_PSTEP_ID_FIELD.AsInteger;
        RecMQMST.ST_WKCNTER                := Trim(ST_WKCNTER_FIELD.AsString);
        RecMQMST.ST_WKCT_PROC              := Trim(ST_WKCT_PROC_FIELD.AsString);
        RecMQMST.ST_RES_CATEGORY           := Trim(ST_RES_CATEGORY_FIELD.AsString);
        RecMQMST.ST_RSC_CODE               := Trim(ST_RSC_CODE_FIELD.AsString);
        RecMQMST.ST_SETUP_TIME_Mechin_Code := Trim(ST_SETUP_TIME_Mechin_Code_FIELD.AsString);
        RecMQMST.ST_SETUP_TIME_JOB         := ST_SETUP_TIME_JOB_FIELD.AsFloat;
        RecMQMST.ST_EXC_TIME_INIT_QTY      := ST_EXC_TIME_INIT_QTY_FIELD.AsFloat;
        LocalListST.add(RecMQMST);
        Inc(IniAppGlobals.Count_Compar_ST);
        QryST.Next;
      end;
      QryST.Close;
      IniAppGlobals.Time_Compar_ST := IniAppGlobals.Time_Compar_ST + (Now - tCurrent);
      tCurrent := Now;
      LocalListST.Sort(SortST);
      IniAppGlobals.Time_ComparSort_ST := IniAppGlobals.Time_ComparSort_ST + (Now - tCurrent);
    end;

  end;
  if Result and ((sFlt = '') or (Pos(',MT,', sFlt) > 0)) then
  begin
    tCurrent := Now;
    tbInfo := @tblInfo[tbl_Material];
    Result := LoadSrvTableCompar(tbl_Material, WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)), '', QryMT);

    if result then
    begin

      MT_PROD_REQ_Nr_FIELD := QryMT.FieldByName(CreateFld(tbInfo.pfx, fldListMT[0].fldPC));
      MT_PSTEP_ID_FIELD    := QryMT.FieldByName(CreateFld(tbInfo.pfx, fldListMT[1].fldPC));
      MT_ORG_STEP_FIELD    := QryMT.FieldByName(CreateFld(tbInfo.pfx, fldListMT[2].fldPC));
      MT_WKCTR_CODE_FIELD  := QryMT.FieldByName(CreateFld(tbInfo.pfx, fldListMT[3].fldPC));
      MT_RES_CAT_CODE_FIELD := QryMT.FieldByName(CreateFld(tbInfo.pfx, fldListMT[4].fldPC));
      MT_RES_CODE_FIELD     := QryMT.FieldByName(CreateFld(tbInfo.pfx, fldListMT[5].fldPC));
      MT_MACHIN_SETUP_CODE_FIELD := QryMT.FieldByName(CreateFld(tbInfo.pfx, fldListMT[6].fldPC));
      MT_ALTERNATIVE_CODE_FIELD  := QryMT.FieldByName(CreateFld(tbInfo.pfx, fldListMT[7].fldPC));
      MT_PROD_TYPE_FIELD         := QryMT.FieldByName(CreateFld(tbInfo.pfx, fldListMT[8].fldPC));
      MT_PROD_CODE_FIELD         := QryMT.FieldByName(CreateFld(tbInfo.pfx, fldListMT[9].fldPC));
      MT_NET_GROUP_CODE_FIELD    := QryMT.FieldByName(CreateFld(tbInfo.pfx, fldListMT[10].fldPC));
      MT_ISSUE_CODE_FIELD        := QryMT.FieldByName(CreateFld(tbInfo.pfx, fldListMT[11].fldPC));
      MT_SEQ_ISSUED_FIELD        := QryMT.FieldByName(CreateFld(tbInfo.pfx, fldListMT[12].fldPC));
      MT_MAT_BALACE_FIELD        := QryMT.FieldByName(CreateFld(tbInfo.pfx, fldListMT[13].fldPC));
      MT_QUANTITY_ALLOC_FIELD    := QryMT.FieldByName(CreateFld(tbInfo.pfx, fldListMT[14].fldPC));
      MT_HIGH_DATe_ALLOC_FIELD   := QryMT.FieldByName(CreateFld(tbInfo.pfx, fldListMT[15].fldPC));
      MT_SEARCH_MAT_BY_ALLOC_FIELD := QryMT.FieldByName(CreateFld(tbInfo.pfx, fldListMT[16].fldPC));
      MT_SETTLED_FIELD             := QryMT.FieldByName(CreateFld(tbInfo.pfx, fldListMT[17].fldPC));
      MT_QUANTITY_ISSUE_FIELD      := QryMT.FieldByName(CreateFld(tbInfo.pfx, fldListMT[18].fldPC));
      MT_REQ_QUANTITY_FIELD        := QryMT.FieldByName(CreateFld(tbInfo.pfx, fldListMT[19].fldPC));

      while not QryMT.Eof do
      begin
        new(RecMQMMT);
        RecMQMMT.MT_PROD_REQ_Nr         := Trim(MT_PROD_REQ_Nr_FIELD.AsString);
        RecMQMMT.MT_PSTEP_ID            := MT_PSTEP_ID_FIELD.AsInteger;
        RecMQMMT.MT_ORG_STEP            := MT_ORG_STEP_FIELD.AsInteger;
        RecMQMMT.MT_WKCTR_CODE          := Trim(MT_WKCTR_CODE_FIELD.AsString);
        RecMQMMT.MT_RES_CAT_CODE        := Trim(MT_RES_CAT_CODE_FIELD.AsString);
        RecMQMMT.MT_RES_CODE            := Trim(MT_RES_CODE_FIELD.AsString);
        RecMQMMT.MT_MACHIN_SETUP_CODE   := Trim(MT_MACHIN_SETUP_CODE_FIELD.AsString);
        RecMQMMT.MT_ALTERNATIVE_CODE    := Trim(MT_ALTERNATIVE_CODE_FIELD.AsString);
        RecMQMMT.MT_PROD_TYPE           := Trim(MT_PROD_TYPE_FIELD.AsString);
        RecMQMMT.MT_PROD_CODE           := Trim(MT_PROD_CODE_FIELD.AsString);
        RecMQMMT.MT_NET_GROUP_CODE      := Trim(MT_NET_GROUP_CODE_FIELD.AsString);
        RecMQMMT.MT_ISSUE_CODE          := Trim(MT_ISSUE_CODE_FIELD.AsString);
        RecMQMMT.MT_SEQ_ISSUED          := Trim(MT_SEQ_ISSUED_FIELD.AsString);
        RecMQMMT.MT_MAT_BALACE          := Trim(MT_MAT_BALACE_FIELD.AsString);
        RecMQMMT.MT_QUANTITY_ALLOC      := MT_QUANTITY_ALLOC_FIELD.AsFloat;
        RecMQMMT.MT_HIGH_DATe_ALLOC     := MT_HIGH_DATe_ALLOC_FIELD.AsFloat;
        RecMQMMT.MT_SEARCH_MAT_BY_ALLOC := Trim(MT_SEARCH_MAT_BY_ALLOC_FIELD.AsString);
        RecMQMMT.MT_SETTLED             := Trim(MT_SETTLED_FIELD.AsString);
        RecMQMMT.MT_QUANTITY_ISSUE      := MT_QUANTITY_ISSUE_FIELD.AsFloat;
        RecMQMMT.MT_REQ_QUANTITY        := MT_REQ_QUANTITY_FIELD.AsFloat;

        LocalListMT.add(RecMQMMT);
        Inc(IniAppGlobals.Count_Compar_MT);
        QryMT.Next;
      end;
      QryMT.Close;
      IniAppGlobals.Time_Compar_MT := IniAppGlobals.Time_Compar_MT + (Now - tCurrent);
      tCurrent := Now;
      LocalListMT.Sort(SortMT);
      IniAppGlobals.Time_ComparSort_MT := IniAppGlobals.Time_ComparSort_MT + (Now - tCurrent);
    end;

  end;
  if Result and ((sFlt = '') or (Pos(',PA,', sFlt) > 0)) then
  begin
    tCurrent := Now;
    tbInfo := @tblInfo[tbl_produced_article];
    Result := LoadSrvTableCompar(tbl_produced_article, WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)), '', QryPA);

    if result then
    begin

      PA_PROD_REQ_NR_FIELD := QryPA.FieldByName(CreateFld(tbInfo.pfx, fldListPA[0].fldPC));
      PA_SEQUENCE_FIELD    := QryPA.FieldByName(CreateFld(tbInfo.pfx, fldListPA[1].fldPC));
      PA_PROD_CODE_FIELD   := QryPA.FieldByName(CreateFld(tbInfo.pfx, fldListPA[2].fldPC));
      PA_NET_GROUP_Code_FIELD := QryPA.FieldByName(CreateFld(tbInfo.pfx, fldListPA[3].fldPC));
      PA_ALL_REQ_FIELD        := QryPA.FieldByName(CreateFld(tbInfo.pfx, fldListPA[4].fldPC));
      PA_PROD_BALANCE_FIELD   := QryPA.FieldByName(CreateFld(tbInfo.pfx, fldListPA[5].fldPC));
      PA_RESOURCE_FIELD       := QryPA.FieldByName(CreateFld(tbInfo.pfx, fldListPA[6].fldPC));
      PA_SETTLED_FIELD        := QryPA.FieldByName(CreateFld(tbInfo.pfx, fldListPA[7].fldPC));
      PA_REQ_QUANTY_FIELD     := QryPA.FieldByName(CreateFld(tbInfo.pfx, fldListPA[8].fldPC));
      PA_QTY_PRODUCED_FIELD   := QryPA.FieldByName(CreateFld(tbInfo.pfx, fldListPA[9].fldPC));
      PA_QTY_ALL_FIELD        := QryPA.FieldByName(CreateFld(tbInfo.pfx, fldListPA[10].fldPC));

      while not QryPA.Eof do
      begin
        new(RecMQMPA);
        RecMQMPA.PA_PROD_REQ_NR         := Trim(PA_PROD_REQ_NR_FIELD.AsString);
        RecMQMPA.PA_SEQUENCE            := Trim(PA_SEQUENCE_FIELD.AsString);
        RecMQMPA.PA_PROD_CODE           := Trim(PA_PROD_CODE_FIELD.AsString);
        RecMQMPA.PA_NET_GROUP_Code      := Trim(PA_NET_GROUP_Code_FIELD.AsString);
        RecMQMPA.PA_ALL_REQ             := Trim(PA_ALL_REQ_FIELD.AsString);
        RecMQMPA.PA_PROD_BALANCE        := Trim(PA_PROD_BALANCE_FIELD.AsString);
        RecMQMPA.PA_RESOURCE            := Trim(PA_RESOURCE_FIELD.AsString);
        RecMQMPA.PA_SETTLED             := Trim(PA_SETTLED_FIELD.AsString);
        RecMQMPA.PA_REQ_QUANTY          := PA_REQ_QUANTY_FIELD.AsFloat;
        RecMQMPA.PA_QTY_PRODUCED        := PA_QTY_PRODUCED_FIELD.AsFloat;
        RecMQMPA.PA_QTY_ALL             := PA_QTY_ALL_FIELD.AsFloat;
        LocalListPA.add(RecMQMPA);
        Inc(IniAppGlobals.Count_Compar_PA);
        QryPA.Next;
      end;
      QryPA.Close;
      IniAppGlobals.Time_Compar_PA := IniAppGlobals.Time_Compar_PA + (Now - tCurrent);
      tCurrent := Now;
      LocalListPA.Sort(SortPA);
      IniAppGlobals.Time_ComparSort_PA := IniAppGlobals.Time_ComparSort_PA + (Now - tCurrent);
    end;
  end;

  QryPR.Close;
  QryPH.Close;
  QryPD.Close;
  QryPP.Close;
  QryPI.Close;
  QryEC.Close;
  QryIC.Close;
  QrySB.Close;
  QrySP.Close;
  QryST.Close;
  QryMT.Close;
  QryPA.Close;

  QryPR.Free;
  QryPH.Free;
  QryPD.Free;
  QryPP.Free;
  QryPI.Free;
  QryEC.Free;
  QryIC.Free;
  QrySB.Free;
  QrySP.Free;
  QryST.Free;
  QryMT.Free;
  QryPA.Free;
  if Assigned(connTF) then connTF.Free;

end;

//----------------------------------------------------------------------------//

function SetQryTbl(var QryPA : TMqmQuery) : boolean;
begin
 // QryPR := ThreadCreateQuery(Main_DB);
//  QryPH := ThreadCreateQuery(Main_DB);
//  QryPD := ThreadCreateQuery(Main_DB);
//  QryPP := ThreadCreateQuery(Main_DB);
//  QryPI := ThreadCreateQuery(Main_DB);
//  QryEC := ThreadCreateQuery(Main_DB);
//  QryIC := ThreadCreateQuery(Main_DB);
//  QrySB := ThreadCreateQuery(Main_DB);
//  QrySP := ThreadCreateQuery(Main_DB);
//  QryST := ThreadCreateQuery(Main_DB);
//  QryMT := ThreadCreateQuery(Main_DB);
  QryPA := ThreadCreateQuery(Main_DB);

//  Result := AddProdRq(tbl_prod_req, QryPR, nil, false, false);
//  if Result then
//     Result := AddProdRqHeader(tbl_prod_reqHdr,QryPH, nil, false, false);
//  if Result then
//     Result := AddProdRqDetails(tbl_prod_step,QryPD, nil, false, false);
//  if Result then
//     Result := AddProdProperty(tbl_prop_prod,QryPP, nil, false, false);
//  if Result then
//     Result := AddProdImfo(tbl_prod_info,QryPI, nil, false, false);
//  if Result then
//     Result := AddProdExternalConn(tbl_ext_connection,QryEC, nil, false, false);
//  if Result then
//     Result := AddProdInternalConn(tbl_prod_reqConnection,QryIC, nil, false, false);
//  if Result then
//     Result := AddProdBatch(tbl_step_batchSize,QrySB, nil, false, false);
//  if Result then
//     Result := AddProdProgress(tbl_sched_progress,QrySP, nil, false, false);
//  if Result then
//     Result := AddProdStepTimes(tbl_step_times,QryST, nil, false, false);
//  if Result then
//     Result := AddMaterial(tbl_Material,QryMT, nil, false, false);
  if Result then
     Result := AddProducedArticle(tbl_produced_article,QryPA, nil, false, false);

end;

//----------------------------------------------------------------------------//

//*********************************************************************************//
//************           Compare New-Old requests procedure       *****************//
//*********************************************************************************//
//*********************************************************************************//

//----------------------------------------------------------------------------//

procedure StartComparPreload;
begin
  g_PreloadListPR := TList.Create;  g_PreloadListPH := TList.Create;
  g_PreloadListPD := TList.Create;  g_PreloadListPP := TList.Create;
  g_PreloadListPI := TList.Create;  g_PreloadListEC := TList.Create;
  g_PreloadListIC := TList.Create;  g_PreloadListSB := TList.Create;
  g_PreloadListSP := TList.Create;  g_PreloadListST := TList.Create;
  g_PreloadListMT := TList.Create;  g_PreloadListPA := TList.Create;
  g_ComparTask1 := TTask.Run(procedure
  begin
    SetQryTblCompar(
      g_PreloadListPR, g_PreloadListPH, g_PreloadListPD, g_PreloadListPP,
      g_PreloadListPI, g_PreloadListEC, g_PreloadListIC, g_PreloadListSB,
      g_PreloadListSP, g_PreloadListST, g_PreloadListMT, g_PreloadListPA, 'PP');
  end);
  g_ComparTask2 := TTask.Run(procedure
  begin
    SetQryTblCompar(
      g_PreloadListPR, g_PreloadListPH, g_PreloadListPD, g_PreloadListPP,
      g_PreloadListPI, g_PreloadListEC, g_PreloadListIC, g_PreloadListSB,
      g_PreloadListSP, g_PreloadListST, g_PreloadListMT, g_PreloadListPA, 'MT,PD');
  end);
  g_ComparTask3 := TTask.Run(procedure
  begin
    SetQryTblCompar(
      g_PreloadListPR, g_PreloadListPH, g_PreloadListPD, g_PreloadListPP,
      g_PreloadListPI, g_PreloadListEC, g_PreloadListIC, g_PreloadListSB,
      g_PreloadListSP, g_PreloadListST, g_PreloadListMT, g_PreloadListPA,
      'SP,ST,PH,PA,PR,IC,SB,PI,EC');
  end);
end;

procedure WaitAndAssignComparPreload;
var
  tWait : TDateTime;
begin
  if not Assigned(g_ComparTask1) and not Assigned(g_ComparTask2) and not Assigned(g_ComparTask3) then Exit;
  tWait := Now;
  TTask.WaitForAll([g_ComparTask1, g_ComparTask2, g_ComparTask3]);
  IniAppGlobals.Time_For_Wait_ComparPreload := IniAppGlobals.Time_For_Wait_ComparPreload + (Now - tWait);
  g_ComparTask1 := nil; g_ComparTask2 := nil; g_ComparTask3 := nil;
  m_ProdCont.m_LocalListPR.Free; m_ProdCont.m_LocalListPR := g_PreloadListPR; g_PreloadListPR := nil;
  m_ProdCont.m_LocalListPH.Free; m_ProdCont.m_LocalListPH := g_PreloadListPH; g_PreloadListPH := nil;
  m_ProdCont.m_LocalListPD.Free; m_ProdCont.m_LocalListPD := g_PreloadListPD; g_PreloadListPD := nil;
  m_ProdCont.m_LocalListPP.Free; m_ProdCont.m_LocalListPP := g_PreloadListPP; g_PreloadListPP := nil;
  m_ProdCont.m_LocalListPI.Free; m_ProdCont.m_LocalListPI := g_PreloadListPI; g_PreloadListPI := nil;
  m_ProdCont.m_LocalListEC.Free; m_ProdCont.m_LocalListEC := g_PreloadListEC; g_PreloadListEC := nil;
  m_ProdCont.m_LocalListIC.Free; m_ProdCont.m_LocalListIC := g_PreloadListIC; g_PreloadListIC := nil;
  m_ProdCont.m_LocalListSB.Free; m_ProdCont.m_LocalListSB := g_PreloadListSB; g_PreloadListSB := nil;
  m_ProdCont.m_LocalListSP.Free; m_ProdCont.m_LocalListSP := g_PreloadListSP; g_PreloadListSP := nil;
  m_ProdCont.m_LocalListST.Free; m_ProdCont.m_LocalListST := g_PreloadListST; g_PreloadListST := nil;
  m_ProdCont.m_LocalListMT.Free; m_ProdCont.m_LocalListMT := g_PreloadListMT; g_PreloadListMT := nil;
  m_ProdCont.m_LocalListPA.Free; m_ProdCont.m_LocalListPA := g_PreloadListPA; g_PreloadListPA := nil;
  g_ComparPreloadApplied := True;
end;

//----------------------------------------------------------------------------//

procedure TProdCont.CheckChangeReq(HostQry : TMqmQuery);
label EndOfPRLoop;
label EndOfPDLoop;
var
 // QryPR,   QryPH,  QryPD, QryPD , QryPP, QryPI, QryEC, QryIC, QrySB, QrySP, QryST, QryMT,

//  QryPA : TMqmQuery;
  tbInfo: ^TTblInfo;
  ReqTempProp : PReqTempProp;
  PropVal, RequestPH : string;
  Curr_Req : string;
  ReqHandledByMcm, StepHandledByMcm, PrevReqHandledByMcm, PrevStepHandledByMcm : string;
  Curr_Req_Flag : TReqChange;
  PropCode, PropHost, PropLocal : string;
  Reason : string;
  Curr_Req_Reactivate : boolean;
  Curr_Req_Step, I : Integer;
  Curr_Req_Step_Flag : TStepChange;
  FlagEof : boolean;
  FlagEol : boolean;
  DndArchiveHostName : TDndArchiveName;
  MT_REQ_QUANTITY_Tmp1 : currency;
  MT_REQ_QUANTITY_Tmp2 : currency;
  IsCHSwap: Boolean;
  LocalStepTypUC, HostStepTypUC: string;
begin
  m_Host_IndexPR := -1;
  if (m_HostListPR.Count <> 0) then
    m_Host_IndexPR := 0;
  m_Host_IndexPH := -1;
  m_Host_IndexPD := -1;
  m_Host_IndexPP := -1;
  m_Host_IndexPI := -1;
  m_Host_IndexEC := -1;
  m_Host_IndexIC := -1;
  m_Host_IndexSB := -1;
  m_Host_IndexSP := -1;
  m_Host_IndexST := -1;
  m_Host_IndexMT := -1;
  m_Host_IndexPA := -1;

  ReqHandledbyMcm := '';
  PrevReqHandledByMcm := '';
  StepHandledByMcm    := '';
  PrevStepHandledByMcm := '';

  Curr_Req_Flag := No;
  Curr_Req_Reactivate := false;

  if g_ComparPreloadApplied then
    g_ComparPreloadApplied := False
  else
    SetQryTblCompar(m_LocalListPR, m_LocalListPH, m_LocalListPD, m_LocalListPP,
                    m_LocalListPI, m_LocalListEC, m_LocalListIC, m_LocalListSB,
                    m_LocalListSP, m_LocalListST, m_LocalListMT, m_LocalListPA);
  m_Local_IndexPR := -1;
  if (m_LocalListPR.Count <> 0) then
    m_Local_IndexPR := 0;
  m_Local_IndexPH := -1;
  m_Local_IndexPD := -1;
  m_Local_IndexPP := -1;
  m_Local_IndexPI := -1;
  m_Local_IndexEC := -1;
  m_Local_IndexIC := -1;
  m_Local_IndexSB := -1;
  m_Local_IndexSP := -1;
  m_Local_IndexST := -1;
  m_Local_IndexMT := -1;
  m_Local_IndexPA := -1;

  DndArchiveHostName := GetDndArchiveHostName;

  while true do
  begin
    if (m_Req_Change_List.Count mod 500 = 0) then Application.ProcessMessages;
    if (Curr_Req_Flag <> No) then
    begin
       // add new
      //if ((Curr_Req_Flag <> DelReq) or ((Curr_Req_Flag = DelReq) and FirstCycle) or
      //    (not Use_CG_loop)) then
      AddReqToCngList(Curr_Req, Curr_Req_Flag, Curr_Req_Reactivate, ReqHandledByMcm, PrevReqHandledByMcm, reason);
      Curr_Req_Flag := No;
      Curr_Req_Reactivate := false;

    end;

    m_Host_Begin_IndexPR := m_Host_IndexPR;

    if EOL_Host(PR) and EOL_Local(PR) then
      Break;

    if EOL_Host(PR) then
    begin
      tbInfo := @tblInfo[tbl_prod_req];
      Curr_Req := PTMQMPR(m_LocalListPR[m_Local_IndexPR]).PR_PREQ_NO;
      ReqHandledByMcm := PTMQMPR(m_LocalListPR[m_Local_IndexPR]).PR_ModulHandled;
      Curr_Req_Flag := DelReq;
      inc(m_Local_IndexPR);
      continue;
    end;

    if EOL_Local(PR) then
    begin
      Curr_Req := PTMQMPR(m_HostListPR[m_Host_IndexPR]).PR_PREQ_NO;
      ReqHandledByMcm := PTMQMPR(m_HostListPR[m_Host_IndexPR]).PR_ModulHandled;
      SetPosOnHostList(Curr_Req);
      if EOL_Host(PH) then
        Break;
      if (PTMQMPH(m_HostListPH[m_Host_IndexPH]).PH_PREQ_NO > Curr_Req) then
      begin
        m_Host_IndexPR := m_Host_IndexPR + 1;
        continue;
      end;

      Curr_Req_Flag := NewReq;
      m_Host_IndexPR := m_Host_IndexPR + 1;
      Continue;
    end;

    tbInfo := @tblInfo[tbl_prod_req];
    if PTMQMPR(m_HostListPR[m_Host_IndexPR]).PR_PREQ_NO > PTMQMPR(m_LocalListPR[m_Local_IndexPR]).PR_PREQ_NO then
    begin
      //tbInfo := @tblInfo[tbl_prod_req];
      Curr_Req := PTMQMPR(m_LocalListPR[m_Local_IndexPR]).PR_PREQ_NO;
      ReqHandledByMcm := PTMQMPR(m_HostListPR[m_Host_IndexPR]).PR_ModulHandled;
      Curr_Req_Flag := DelReq;
      inc(m_Local_IndexPR);
      continue;
    end;

    tbInfo := @tblInfo[tbl_prod_req];
    if PTMQMPR(m_HostListPR[m_Host_IndexPR]).PR_PREQ_NO < PTMQMPR(m_LocalListPR[m_Local_IndexPR]).PR_PREQ_NO then
    begin
      Curr_Req := PTMQMPR(m_HostListPR[m_Host_IndexPR]).PR_PREQ_NO;
      ReqHandledByMcm := PTMQMPR(m_HostListPR[m_Host_IndexPR]).PR_ModulHandled;
      SetPosOnHostList(Curr_Req);
      if (EOL_Host(PH) or (PTMQMPH(m_HostListPH[m_Host_IndexPH]).PH_PREQ_NO > Curr_Req)) then
      begin
        m_Host_IndexPR := m_Host_IndexPR + 1;
        continue;
      end;

      Curr_Req_Flag := NewReq;
      m_Host_IndexPR := m_Host_IndexPR + 1;
      Continue;
    end;

    // At this point we know that we have the same request in PR memory and PR Disk
    Curr_Req := PTMQMPR(m_HostListPR[m_Host_IndexPR]).PR_PREQ_NO;
    ReqHandledByMcm := PTMQMPR(m_HostListPR[m_Host_IndexPR]).PR_ModulHandled;

    SetPosOnHostList(Curr_Req);
    SetPosOnLocalList(Curr_Req);
  //  SetPosOnQry(Curr_Req,QryPH,QryPD,QryPP,QryPI,QryEC,QryIC,QrySB,QrySP,QryST,QryMT,QryPA);

    if (EOL_Host(PH) or (PTMQMPH(m_HostListPH[m_Host_IndexPH]).PH_PREQ_NO > Curr_Req)) then
    begin
      tbInfo := @tblInfo[tbl_prod_req];
    //  if PTMQMPR(m_LocalListPR[m_Local_IndexPR]).PR_HISTORICAL_REQ <> '1' then
    //    Curr_Req_Flag := Historical;
//************************************************
//********ERAN 20/08/06 start 2.0.0.3 build 7 ****
//************************************************
     // if Curr_Req_Flag <> Historical then
      if PTMQMPR(m_LocalListPR[m_Local_IndexPR]).PR_HISTORICAL_REQ <> '1' then
      begin
        tbInfo := @tblInfo[tbl_sched_progress];
        while true do
        begin
           if (EOL_Host(SP) or (PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_PREQ_NO > Curr_Req)) and
              (EOL_Local(SP) or (PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_PREQ_NO > Curr_Req)) then
            break;

          if (EOL_Host(SP) or (PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_PREQ_NO > Curr_Req)) then
          begin
            Curr_Req_Flag := Historical;
            break;
          end;

          if (EOL_Local(SP) or (PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_PREQ_NO > Curr_Req)) then
          begin
            Curr_Req_Flag := Historical;
            break;
          end;

	        if (PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_PSTEP_ID <> PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_PSTEP_ID) or
             (PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_PSUBST_ID <> PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_PSUBST_ID) or
             (PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_REPROC_NO <> PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_REPROC_NO) or
             (PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_LAST_PROG_TYPE <> PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_LAST_PROG_TYPE) or
             (PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_RSC_CODE <> PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_RSC_CODE) or
             (PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_PROGRESED_GROUP <> PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_PROGRESED_GROUP) or
             (DateTimeToStr(PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_PROGRSTART) <> DateTimeToStr(PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_PROGRSTART)) or
             (DateTimeToStr(PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_CURR_PRG_DATE) <> DateTimeToStr(PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_CURR_PRG_DATE)) or
             (DateTimeToStr(PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_PROGREND) <> DateTimeToStr(PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_PROGREND)) or
             (FloatToStr(PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_QTY) <> FloatToStr(PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_QTY)) or
             (FloatToStr(PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_StartingQty) <> FloatToStr(PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_StartingQty)) or
             (FloatToStr(PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_REMAIN_TIME) <> FloatToStr(PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_REMAIN_TIME)) or
             (PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_LAST_PROG_TYPE_HOST <> PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_LAST_PROG_TYPE_HOST) or
             (PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_RSC_CODE_HOST <> PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_RSC_CODE_HOST) or
             (DateTimeToStr(PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_PROGRSTART_HOST) <> DateTimeToStr(PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_PROGRSTART_HOST)) or
             (DateTimeToStr(PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_CURR_PRG_DATE_HOST) <> DateTimeToStr(PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_CURR_PRG_DATE_HOST)) or
             (DateTimeToStr(PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_PROGREND_HOST) <> DateTimeToStr(PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_PROGREND_HOST)) or
             (FloatToStr(PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_QTY_HOST) <> FloatToStr(PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_QTY_HOST)) or
             (FloatToStr(PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_REMAIN_TIME_HOST) <> FloatToStr(PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_REMAIN_TIME_HOST)) then
          begin
            Curr_Req_Flag := Historical;
            break;
          end;

          inc(m_Local_IndexSP);
          m_Host_IndexSP := m_Host_IndexSP + 1;
        end

      end;

//************************************************
//********ERAN 20/08/06 end 2.0.0.3 build 7 ****
//************************************************

      m_Host_IndexPR := m_Host_IndexPR + 1;
      inc(m_Local_IndexPR);
      Continue;
    end;

    tbInfo := @tblInfo[tbl_prod_req];
    if PTMQMPR(m_LocalListPR[m_Local_IndexPR]).PR_HISTORICAL_REQ = '1' then
      Curr_Req_Reactivate := true;

    tbInfo := @tblInfo[tbl_prod_reqHdr];
    if (PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_PROD_LINE <> PTMQMPH(m_HostListPH[m_Host_IndexPH]).PH_PROD_LINE) or
        (PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_TYPE_PROD <> PTMQMPH(m_HostListPH[m_Host_IndexPH]).PH_TYPE_PROD) or
        (PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_PROD_UM <> PTMQMPH(m_HostListPH[m_Host_IndexPH]).PH_PROD_UM) then
    begin
      Curr_Req_Flag := HeadrFieldsChange;
      if (PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_PROD_LINE <> PTMQMPH(m_HostListPH[m_Host_IndexPH]).PH_PROD_LINE) then
        Reason := 'Prod Line was Cng from ' + PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_PROD_LINE + ' To ' + PTMQMPH(m_HostListPH[m_Host_IndexPH]).PH_PROD_LINE
      else if PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_TYPE_PROD <> PTMQMPH(m_HostListPH[m_Host_IndexPH]).PH_TYPE_PROD then
        Reason := 'Prod type was cng from ' + PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_TYPE_PROD + ' To ' + PTMQMPH(m_HostListPH[m_Host_IndexPH]).PH_TYPE_PROD
      else Reason := 'Prod UM was cng from ' + PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_PROD_UM + ' To ' + PTMQMPH(m_HostListPH[m_Host_IndexPH]).PH_PROD_UM;
      m_Host_IndexPR := m_Host_IndexPR + 1;
      inc(m_Local_IndexPR);
      Continue
    end;
        // Light Change

    if (PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_HISTORICAL_REQ <> PTMQMPH(m_HostListPH[m_Host_IndexPH]).PH_HISTORICAL_REQ) or
       (PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_REQ_ORIGIN <> PTMQMPH(m_HostListPH[m_Host_IndexPH]).PH_REQ_ORIGIN) or
       (PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_PROD_FAMILY <> PTMQMPH(m_HostListPH[m_Host_IndexPH]).PH_PROD_FAMILY) or
       (PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_MATERIAL_FAMILY <> PTMQMPH(m_HostListPH[m_Host_IndexPH]).PH_MATERIAL_FAMILY) or
       (DateTimeToStr(PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_PROD_DELIVY_DATE) <> DateTimeToStr(PTMQMPH(m_HostListPH[m_Host_IndexPH]).PH_PROD_DELIVY_DATE)) or
       (DateTimeToStr(PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_PROD_LOW_TIME_STRT) <> DateTimeToStr(PTMQMPH(m_HostListPH[m_Host_IndexPH]).PH_PROD_LOW_TIME_STRT)) or
       (PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_FRC_DEL_DATE <> PTMQMPH(m_HostListPH[m_Host_IndexPH]).PH_FRC_DEL_DATE) then
    begin
      Curr_Req_Flag := HeaderCosmeticChanged;
    end;

    if (PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_SPLITCONFLEVELS <> PTMQMPH(m_HostListPH[m_Host_IndexPH]).PH_SPLITCONFLEVELS) or
      (PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_LEAD_STEP_SPLITED <> PTMQMPH(m_HostListPH[m_Host_IndexPH]).PH_LEAD_STEP_SPLITED) or
      (PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_MQM_SPLIT_ID <> PTMQMPH(m_HostListPH[m_Host_IndexPH]).PH_MQM_SPLIT_ID) then
    begin
      Curr_Req_Flag := HeaderCosmeticChanged;
    end;

    if (PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_Serving_Code <> Trim(PTMQMPH(m_HostListPH[m_Host_IndexPH]).PH_Serving_Code)) or
      (PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_Served_Code <> Trim(PTMQMPH(m_HostListPH[m_Host_IndexPH]).PH_Served_Code)) or
      (PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_Curve_Family_Id_Code <> Trim(PTMQMPH(m_HostListPH[m_Host_IndexPH]).PH_Curve_Family_Id_Code)) then
//    if (PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_Served_Code <> Trim(PTMQMPH(m_HostListPH[m_Host_IndexPH]).PH_Served_Code)) or
  //  if (PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_Curve_Family_Id_Code <> Trim(PTMQMPH(m_HostListPH[m_Host_IndexPH]).PH_Curve_Family_Id_Code)) then
    begin
      Curr_Req_Flag := HeaderCosmeticChanged;
    end;

    tbInfo := @tblInfo[tbl_prod_req];
    if (PTMQMPR(m_LocalListPR[m_Local_IndexPR]).PR_DIV_CODE <> PTMQMPR(m_HostListPR[m_Host_IndexPR]).PR_DIV_CODE) or
       (PTMQMPR(m_LocalListPR[m_Local_IndexPR]).PR_DSP_CODE <> PTMQMPR(m_HostListPR[m_Host_IndexPR]).PR_DSP_CODE) or
       (PTMQMPR(m_LocalListPR[m_Local_IndexPR]).PR_BCH_CODE <> PTMQMPR(m_HostListPR[m_Host_IndexPR]).PR_BCH_CODE) or
       (PTMQMPR(m_LocalListPR[m_Local_IndexPR]).PR_REPROC_NO <> PTMQMPR(m_HostListPR[m_Host_IndexPR]).PR_REPROC_NO) or
       (PTMQMPR(m_LocalListPR[m_Local_IndexPR]).PR_PREQ_NO <> PTMQMPR(m_HostListPR[m_Host_IndexPR]).PR_PREQ_NO) then
    begin
      Curr_Req_Flag := HeaderCosmeticChanged;
    end;

    //*********************************************************************************//
    //*********************************************************************************//
    //************           Property header loop                     *****************//
    //*********************************************************************************//
    //*********************************************************************************//

    tbInfo := @tblInfo[tbl_prop_Prod];
    //m_TmpPP_Disk.Clear;
    //m_TmpPP_Memory.Clear;
    ClearPPTempList;
    while true do
    begin
        FlagEol := false;
        if EOL_Host(PP) or (PTMQMPP(m_HostListPP[m_Host_IndexPP]).PP_PREQ_NO > Curr_Req) then
           FlagEol := true
        else
        begin
          if (PTMQMPP(m_HostListPP[m_Host_IndexPP]).PP_PSTEP_ID > 0) then
              FlagEol := true
        end;

        FlagEof := false;
        if (EOL_Local(PP) or
           (PTMQMPP(m_LocalListPP[m_Local_IndexPP]).PP_PREQ_NO > Curr_Req)) then
             FlagEof := true
        else
        begin
           if (PTMQMPP(m_LocalListPP[m_Local_IndexPP]).PP_PSTEP_ID > 0) then
              FlagEof := true
        end;

      if FlagEol and FlagEof then
         break;

      if FlagEol then
      begin
        New(ReqTempProp);
        ReqTempProp.PropCode := PTMQMPP(m_LocalListPP[m_Local_IndexPP]).PP_PROPERTY;
        ReqTempProp.PropVal := PTMQMPP(m_LocalListPP[m_Local_IndexPP]).PP_VALUE;
        m_TmpPP_Disk.add(ReqTempProp);
        Inc(m_Local_IndexPP);
        Curr_Req_Flag := HeaderCosmeticChanged;
        continue
      end;

      if FlagEof then
      begin
        New(ReqTempProp);
        ReqTempProp.PropCode := PTMQMPP(m_HostListPP[m_Host_IndexPP]).PP_PROPERTY;
        ReqTempProp.PropVal := PTMQMPP(m_HostListPP[m_Host_IndexPP]).PP_VALUE;
        m_TmpPP_Memory.add(ReqTempProp);
        m_Host_IndexPP := m_Host_IndexPP + 1;
        Curr_Req_Flag := HeaderCosmeticChanged;
        continue
      end;

      if (PTMQMPP(m_HostListPP[m_Host_IndexPP]).PP_PROPERTY > PTMQMPP(m_LocalListPP[m_Local_IndexPP]).PP_PROPERTY) then
      begin
        New(ReqTempProp);
        ReqTempProp.PropCode := PTMQMPP(m_LocalListPP[m_Local_IndexPP]).PP_PROPERTY;
        ReqTempProp.PropVal  := PTMQMPP(m_LocalListPP[m_Local_IndexPP]).PP_VALUE;
        m_TmpPP_Disk.add(ReqTempProp);
        Inc(m_Local_IndexPP);
        Curr_Req_Flag := HeaderCosmeticChanged;
        continue
      end;

      if (PTMQMPP(m_LocalListPP[m_Local_IndexPP]).PP_PROPERTY > PTMQMPP(m_HostListPP[m_Host_IndexPP]).PP_PROPERTY) then
      begin
        New(ReqTempProp);
        ReqTempProp.PropCode := PTMQMPP(m_HostListPP[m_Host_IndexPP]).PP_PROPERTY;
        ReqTempProp.PropVal := PTMQMPP(m_HostListPP[m_Host_IndexPP]).PP_VALUE;
        m_TmpPP_Memory.add(ReqTempProp);
        m_Host_IndexPP := m_Host_IndexPP + 1;
        Curr_Req_Flag := HeaderCosmeticChanged;
        continue
      end;

      if (PTMQMPP(m_LocalListPP[m_Local_IndexPP]).PP_VALUE <> PTMQMPP(m_HostListPP[m_Host_IndexPP]).PP_VALUE) then
      begin
        if CheckProperty(PTMQMPP(m_LocalListPP[m_Local_IndexPP]).PP_PROPERTY) then
        begin
          Curr_Req_Flag := HeadrPropChange;
          PropCode  := PTMQMPP(m_HostListPP[m_Host_IndexPP]).PP_PROPERTY;
          PropHost  := PTMQMPP(m_HostListPP[m_Host_IndexPP]).PP_VALUE;
          PropLocal := PTMQMPP(m_LocalListPP[m_Local_IndexPP]).PP_VALUE;
          Reason := 'PropCode :' + PropCode + ' Chg From ' + PropLocal + ' To:' + PropHost;
          goto EndOfPRLoop;
        end
        else
          Curr_Req_Flag := HeaderCosmeticChanged;
      end;
      inc(m_Local_IndexPP);
      m_Host_IndexPP := m_Host_IndexPP + 1;
      continue

    end;

    //*********************************************************************************//
    //*********************************************************************************//
    //************           EC Loop                                  *****************//
    //*********************************************************************************//
    //*********************************************************************************//

    if Curr_Req_Flag = No then
    begin
      tbInfo := @tblInfo[tbl_ext_connection];
      while true do
      begin
        if (EOL_Host(EC) or (PTMQMEC(m_HostListEC[m_Host_IndexEC]).EC_PREQ_NO > Curr_Req)) and
           (EOL_Local(EC) or (PTMQMEC(m_LocalListEC[m_Local_IndexEC]).EC_PREQ_NO > Curr_Req)) then
          break;

        if (EOL_Host(EC) or (PTMQMEC(m_HostListEC[m_Host_IndexEC]).EC_PREQ_NO > Curr_Req)) then
        begin
          Curr_Req_Flag := HeaderCosmeticChanged;
          break;
        end;

        if (EOL_Local(EC) or (PTMQMEC(m_LocalListEC[m_Local_IndexEC]).EC_PREQ_NO > Curr_Req)) then
        begin
          Curr_Req_Flag := HeaderCosmeticChanged;
          break
        end;

        if (PTMQMEC(m_HostListEC[m_Host_IndexEC]).EC_CONNE_KEY <> PTMQMEC(m_LocalListEC[m_Local_IndexEC]).EC_CONNE_KEY) or
           (PTMQMEC(m_HostListEC[m_Host_IndexEC]).EC_NUM_LEVELS <> PTMQMEC(m_LocalListEC[m_Local_IndexEC]).EC_NUM_LEVELS) or
           (PTMQMEC(m_HostListEC[m_Host_IndexEC]).EC_CONN_CERTENT_LEVEL <> PTMQMEC(m_LocalListEC[m_Local_IndexEC]).EC_CONN_CERTENT_LEVEL) then
        begin
          Curr_Req_Flag := HeaderCosmeticChanged;
          Break
        end;

        inc(m_Local_IndexEC);
        m_Host_IndexEC := m_Host_IndexEC + 1;

      end;
    end;
    //*********************************************************************************//
    //*********************************************************************************//
    //************           IC Loop                                  *****************//
    //*********************************************************************************//
    //*********************************************************************************//

    if Curr_Req_Flag = No then
    begin
      tbInfo := @tblInfo[tbl_prod_reqConnection];
      while true do
      begin
        if (EOL_Host(IC) or (PTMQMIC(m_HostListIC[m_Host_IndexIC]).IC_PREQ_NO > Curr_Req)) and
           (EOL_Local(IC) or (PTMQMIC(m_LocalListIC[m_Local_IndexIC]).IC_PREQ_NO > Curr_Req)) then
          break;

        if (EOL_Host(IC) or (PTMQMIC(m_HostListIC[m_Host_IndexIC]).IC_PREQ_NO > Curr_Req)) then
        begin
          Curr_Req_Flag := HeaderCosmeticChanged;
          break;
        end;

        if (EOL_Local(IC) or (PTMQMIC(m_LocalListIC[m_Local_IndexIC]).IC_PREQ_NO > Curr_Req)) then
        begin
          Curr_Req_Flag := HeaderCosmeticChanged;
          break
        end;

        if (PTMQMIC(m_HostListIC[m_Host_IndexIC]).IC_PREV_PREQ_NO <> PTMQMIC(m_LocalListIC[m_Local_IndexIC]).IC_PREV_PREQ_NO) then
        begin
          Curr_Req_Flag := HeaderCosmeticChanged;
          Break
        end;

        inc(m_Local_IndexIC);
        m_Host_IndexIC := m_Host_IndexIC + 1;

      end;
    end;

    //******************************************************************//
    //************           PA Loop                   *****************//
    //******************************************************************//

    if Curr_Req_Flag = No then
    begin
      tbInfo := @tblInfo[tbl_produced_article];
      while true do
      begin
        if (EOL_Host(PA) or (PTMQMPA(m_HostlistPA[m_Host_IndexPA]).PA_PROD_REQ_NR > Curr_Req)) and
           (EOL_Local(PA) or (PTMQMPA(m_LocallistPA[m_Local_IndexPA]).PA_PROD_REQ_NR > Curr_Req)) then
          break;

        if (EOL_Host(PA) or (PTMQMPA(m_HostlistPA[m_Host_IndexPA]).PA_PROD_REQ_NR > Curr_Req)) then
        begin
          Curr_Req_Flag := HeaderCosmeticChanged;
          break;
        end;

        if (EOL_Local(PA) or (PTMQMPA(m_LocallistPA[m_Local_IndexPA]).PA_PROD_REQ_NR > Curr_Req)) then
        begin
          Curr_Req_Flag := HeaderCosmeticChanged;
          break
        end;

        if (PTMQMPA(m_HostlistPA[m_Host_IndexPA]).PA_SEQUENCE       <> PTMQMPA(m_LocallistPA[m_Local_IndexPA]).PA_SEQUENCE) or
           (PTMQMPA(m_HostlistPA[m_Host_IndexPA]).PA_PROD_CODE      <> PTMQMPA(m_LocallistPA[m_Local_IndexPA]).PA_PROD_CODE) or
           (PTMQMPA(m_HostlistPA[m_Host_IndexPA]).PA_NET_GROUP_Code <> PTMQMPA(m_LocallistPA[m_Local_IndexPA]).PA_NET_GROUP_Code) or
           (PTMQMPA(m_HostlistPA[m_Host_IndexPA]).PA_ALL_REQ        <> PTMQMPA(m_LocallistPA[m_Local_IndexPA]).PA_ALL_REQ) or
           (PTMQMPA(m_HostlistPA[m_Host_IndexPA]).PA_PROD_BALANCE   <> PTMQMPA(m_LocallistPA[m_Local_IndexPA]).PA_PROD_BALANCE) or
           (PTMQMPA(m_HostlistPA[m_Host_IndexPA]).PA_RESOURCE       <> PTMQMPA(m_LocallistPA[m_Local_IndexPA]).PA_RESOURCE) or
           (PTMQMPA(m_HostlistPA[m_Host_IndexPA]).PA_SETTLED        <> PTMQMPA(m_LocallistPA[m_Local_IndexPA]).PA_SETTLED) or
           (FloatToStr(PTMQMPA(m_HostlistPA[m_Host_IndexPA]).PA_REQ_QUANTY) <> FloatToStr(PTMQMPA(m_LocallistPA[m_Local_IndexPA]).PA_REQ_QUANTY)) or
           (FloatToStr(PTMQMPA(m_HostlistPA[m_Host_IndexPA]).PA_QTY_PRODUCED)  <> FloatToStr(PTMQMPA(m_LocallistPA[m_Local_IndexPA]).PA_QTY_PRODUCED)) or
           (FloatToStr(PTMQMPA(m_HostlistPA[m_Host_IndexPA]).PA_QTY_ALL)        <> FloatToStr(PTMQMPA(m_LocallistPA[m_Local_IndexPA]).PA_QTY_ALL)) then
        begin
          Curr_Req_Flag := HeaderCosmeticChanged;
          Break
        end;

        Inc(m_Local_IndexPA);
        m_Host_IndexPA := m_Host_IndexPA + 1;

      end;
    end;

    //*********************************************************************************//
    //*********************************************************************************//
    //************           PI header Loop                           *****************//
    //*********************************************************************************//
    //*********************************************************************************//

    if Curr_Req_Flag = No then
    begin
      tbInfo := @tblInfo[tbl_prod_info];
      while true do
      begin
        FlagEol := false;

        if (EOL_Host(PI) or (PTMQMPI(m_HostListPI[m_Host_IndexPI]).PI_PREQ_NO > Curr_Req)) and
           (EOL_Local(PI) or (PTMQMPI(m_LocalListPI[m_Local_IndexPI]).PI_PREQ_NO > Curr_Req)) then
          break;

        if (EOL_Host(PI) or (PTMQMPI(m_HostListPI[m_Host_IndexPI]).PI_PREQ_NO > Curr_Req)) then
        begin
          Curr_Req_Flag := HeaderCosmeticChanged;
          break;
        end;

        if (EOL_Local(PI) or (PTMQMPI(m_LocalListPI[m_Local_IndexPI]).PI_PREQ_NO > Curr_Req)) then
        begin
          Curr_Req_Flag := HeaderCosmeticChanged;
          break
        end;

        if (PTMQMPI(m_HostListPI[m_Host_IndexPI]).PI_INFO_TYPE <> PTMQMPI(m_LocalListPI[m_Local_IndexPI]).PI_INFO_TYPE) or
           (PTMQMPI(m_HostListPI[m_Host_IndexPI]).PI_INFO_LINE_NUM <> PTMQMPI(m_LocalListPI[m_Local_IndexPI]).PI_INFO_LINE_NUM) or
           (PTMQMPI(m_HostListPI[m_Host_IndexPI]).PI_INFO_AREA <> PTMQMPI(m_LocalListPI[m_Local_IndexPI]).PI_INFO_AREA) then
        begin
          Curr_Req_Flag := HeaderCosmeticChanged;
          Break
        end;

        inc(m_Local_IndexPI);
        m_Host_IndexPI := m_Host_IndexPI + 1;

      end;
    end;

    //*********************************************************************************//
    //*********************************************************************************//
    //************           PD Loop                                  *****************//
    //*********************************************************************************//
    //*********************************************************************************//

    Curr_Req_Step := 0;
    Curr_Req_Step_Flag := NoChange;

    while true do
    begin
      // tbInfo := @tblInfo[tbl_prod_step];
      if (Curr_Req_Step_Flag <> NoChange) then
      begin
        AddStepReqToCngList(Curr_Req,Curr_Req_Step,Curr_Req_Step_Flag, StepHandledByMcm,PrevStepHandledByMcm, Reason);
        if (Curr_Req_Flag = No) then
          Curr_Req_Flag := StepChangeOnly;
      end;

      Curr_Req_Step_Flag := NoChange;
      m_Begin_StepIndexPD := m_Host_IndexPD;

      tbInfo := @tblInfo[tbl_prod_reqHdr];
      RequestPH := PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_PREQ_NO;
      tbInfo := @tblInfo[tbl_prod_step];

      if (EOL_Host(PD) or (PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_PREQ_NO > PTMQMPH(m_HostListPH[m_Host_IndexPH]).PH_PREQ_NO)) and
        (EOL_Local(PD) or (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_PREQ_NO > RequestPH)) then
         break;

      if (EOL_Host(PD) or (PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_PREQ_NO > PTMQMPH(m_HostListPH[m_Host_IndexPH]).PH_PREQ_NO)) then
      begin
        Curr_Req_Step := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_PSTEP_ID;
        StepHandledByMcm := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_SchedulByMcm;
        Curr_Req_Step_Flag := DelStep;
        inc(m_Local_IndexPD);
        continue
      end;

      tbInfo := @tblInfo[tbl_prod_reqHdr];
      RequestPH := PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_PREQ_NO;
      tbInfo := @tblInfo[tbl_prod_step];

      if (EOL_Local(PD) or (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_PREQ_NO > RequestPH)) then
      begin
        Curr_Req_Step := PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_PSTEP_ID;
        StepHandledByMcm := PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_SchedulByMcm;
        Curr_Req_Step_Flag := NewStep;
        SetPosOnStepHostList(Curr_Req,Curr_Req_Step);
        m_Host_IndexPD :=  m_Host_IndexPD + 1;
        continue
      end;

      if (PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_PSTEP_ID > PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_PSTEP_ID) then
      begin
        Curr_Req_Step := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_PSTEP_ID;
        StepHandledByMcm := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_SchedulByMcm;
        Curr_Req_Step_Flag := DelStep;
        inc(m_Local_IndexPD);
        continue
      end;

      if (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_PSTEP_ID > PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_PSTEP_ID) then
      begin
        Curr_Req_Step := PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_PSTEP_ID;
        Curr_Req_Step_Flag := NewStep;
        StepHandledByMcm := PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_SchedulByMcm;
        SetPosOnStepHostList(Curr_Req,Curr_Req_Step);
        m_Host_IndexPD :=  m_Host_IndexPD + 1;
        continue
      end;

      // At this point we know we have the same request step in the memory & disk
      Curr_Req_Step := PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_PSTEP_ID;
      StepHandledByMcm := PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_SchedulByMcm;
      PrevStepHandledByMcm := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_SchedulByMcm;
      SetPosOnStepHostList(Curr_Req,Curr_Req_Step);
      SetPosOnStepLocalList(Curr_Req,Curr_Req_Step);
//      SetStepPosOnQry(Curr_Req,Curr_Req_Step,QryPP,QryPI,QrySB,QrySP,QryST,QryMT);

      if (FloatToStr(PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_INIT_QUENT) <> FloatToStr(0))
      and (FloatToStr(PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_FIN_QUENT) <> FloatToStr(0)) then
      begin
        if (PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_INIT_QUENT = 0)
        or (PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_FIN_QUENT = 0) then
        begin
          Curr_Req_Step_Flag := StepFieldChange;
          if (PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_INIT_QUENT = 0) and (PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_FIN_QUENT = 0) then
            Reason := 'Ini and Fin qty values are 0 '
          else if (PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_INIT_QUENT = 0) then
            Reason := 'Ini qty is 0'
          else
            Reason := 'Fin qty is 0';
          SetPosOnStepHostList(Curr_Req,Curr_Req_Step);
          m_Host_IndexPD := m_Host_IndexPD + 1;
          inc(m_Local_IndexPD);
          continue;
        end;
      end;

     { if (UpperCase(PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_STEP_TYP) <> UpperCase(PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_STEP_TYP)) or
         (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_STEP_CAN_GROUP <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_STEP_CAN_GROUP) or
         (FloatToStr(PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_FORCED_GRP_NO) <> FloatToStr(PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_FORCED_GRP_NO)) or
         (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_TO_SCHED <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_TO_SCHED) then
      begin
        Curr_Req_Step_Flag := StepFieldChange;
        if PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_STEP_TYP <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_STEP_TYP then
          Reason := 'Step Type chg from ' + PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_STEP_TYP + ' To : ' + PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_STEP_TYP
        else if PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_STEP_CAN_GROUP <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_STEP_CAN_GROUP then
          Reason := 'StepCanGroup chg from ' + PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_STEP_CAN_GROUP + ' To ' + PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_STEP_CAN_GROUP
        else if FloatToStr(PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_FORCED_GRP_NO) <> FloatToStr(PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_FORCED_GRP_NO) then
          Reason := 'ForcedGroupNo chg from ' + FloatToStr(PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_FORCED_GRP_NO) + ' To ' + FloatToStr(PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_FORCED_GRP_NO)
        else Reason := 'ToBeSched chg from ' + PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_TO_SCHED + ' To ' + PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_TO_SCHED;
        SetPosOnStepHostList(Curr_Req,Curr_Req_Step);
        m_Host_IndexPD := m_Host_IndexPD + 1;
        inc(m_Local_IndexPD);
        continue
      end  }

     // Ignore Step Type change between C <-> H
      LocalStepTypUC := UpperCase(PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_STEP_TYP);
      HostStepTypUC  := UpperCase(PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_STEP_TYP);
      IsCHSwap :=
        ((LocalStepTypUC = 'C') and (HostStepTypUC = 'H')) or
        ((LocalStepTypUC = 'H') and (HostStepTypUC = 'C'));
      if (
           (
             (LocalStepTypUC <> HostStepTypUC) and not IsCHSwap
           ) or
          // (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_STEP_CAN_GROUP <>
          //  PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_STEP_CAN_GROUP) or
           (FloatToStr(PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_FORCED_GRP_NO) <>
            FloatToStr(PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_FORCED_GRP_NO)) or
           (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_TO_SCHED <>
            PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_TO_SCHED)
         ) then
      begin
        Curr_Req_Step_Flag := StepFieldChange;

        if (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_STEP_TYP <>
            PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_STEP_TYP) and not IsCHSwap then
          Reason := 'Step Type chg from ' +
                    PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_STEP_TYP +
                    ' To : ' +
                    PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_STEP_TYP

        {else if PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_STEP_CAN_GROUP <>
                PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_STEP_CAN_GROUP then
          Reason := 'StepCanGroup chg from ' +
                    PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_STEP_CAN_GROUP +
                    ' To ' +
                    PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_STEP_CAN_GROUP }

        else if FloatToStr(PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_FORCED_GRP_NO) <>
                FloatToStr(PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_FORCED_GRP_NO) then
          Reason := 'ForcedGroupNo chg from ' +
                    FloatToStr(PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_FORCED_GRP_NO) +
                    ' To ' +
                    FloatToStr(PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_FORCED_GRP_NO)

        else
          Reason := 'ToBeSched chg from ' +
                    PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_TO_SCHED +
                    ' To ' +
                    PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_TO_SCHED;

        SetPosOnStepHostList(Curr_Req, Curr_Req_Step);
        m_Host_IndexPD := m_Host_IndexPD + 1;
        Inc(m_Local_IndexPD);
        Continue;
      end
      else
      begin

        if (PTMQMPD(m_LocalListPD[m_Local_IndexPD])^.PD_WKCNTER <>
            PTMQMPD(m_HostListPD[m_Host_IndexPD])^.PD_WKCNTER) and
           not CheckAlternativeWC(
             PTMQMPD(m_LocalListPD[m_Local_IndexPD])^.PD_WKCNTER,
             PTMQMPD(m_LocalListPD[m_Local_IndexPD])^.PD_WKCT_PROC,
             PTMQMPD(m_HostListPD[m_Host_IndexPD])^.PD_WKCNTER,
             PTMQMPD(m_HostListPD[m_Host_IndexPD])^.PD_WKCT_PROC
           ) then

       { if (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_WKCNTER <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_WKCNTER) and
          //(m_LocalListPD[m_Local_IndexPD]).PD_WKCT_PROC <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_WKCT_PROC)) and
           not (CheckAlternativeWC(PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_WKCNTER,
               PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_WKCT_PROC,
               PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_WKCNTER,
               PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_WKCT_PROC)) then  }

        begin
          Curr_Req_Step_Flag := StepFieldChange;

          if PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_WKCNTER <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_WKCNTER then
             Reason := 'WkCtrCode chg from : ' + PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_WKCNTER + ' To ' + PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_WKCNTER
          else
             Reason := 'WkcProc chg from : ' + PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_WKCT_PROC + ' To ' + PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_WKCT_PROC;

          SetPosOnStepHostList(Curr_Req,Curr_Req_Step);
          m_Host_IndexPD :=  m_Host_IndexPD + 1;
          inc(m_Local_IndexPD);
          continue
        end
      end;

      if (Curr_Req_Step_Flag = StepPropChange) then
      begin
        Curr_Req_Step_Flag := StepPropChange;
        SetPosOnStepHostList(Curr_Req,Curr_Req_Step);
        m_Host_IndexPD :=  m_Host_IndexPD + 1;
        inc(m_Local_IndexPD);
        continue
      end;

      // check light change

      if (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_WKCNTER <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_WKCNTER) or
         (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_WKCT_PROC <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_WKCT_PROC) or
         (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_TO_SCHED <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_TO_SCHED) or
         (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_PRV_STEP_SCHED_MQM <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_PRV_STEP_SCHED_MQM) or
         (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_PRV_STEP_TRUE <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_PRV_STEP_TRUE) or
         (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_NEX_STEP_SCHED_MQM <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_NEX_STEP_SCHED_MQM) or
         (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_NEX_STEP_TRUE <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_NEX_STEP_TRUE) or
         (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_STEP_TYP <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_STEP_TYP) or
        // (DateTimeToStr(PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_MAT_ARRV_DATE) <> DateTimeToStr(PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_MAT_ARRV_DATE)) or
         (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_FRC_MAT_DATE <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_FRC_MAT_DATE) or
         (DateTimeToStr(PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_PLAN_START) <> DateTimeToStr(PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_PLAN_START)) or
         (DateTimeToStr(PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_LOW_LIMIT_TIME_STRT) <> DateTimeToStr(PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_LOW_LIMIT_TIME_STRT)) or
         (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_FRC_LOW_DATE <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_FRC_LOW_DATE) or
         (DateTimeToStr(PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_PLAN_END) <> DateTimeToStr(PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_PLAN_END)) or
         (DateTimeToStr(PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_HIGH_LIMIT_TIMEND) <> DateTimeToStr(PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_HIGH_LIMIT_TIMEND)) or
         (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_FRC_HIGH_DATE <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_FRC_HIGH_DATE) or
         (FloatToStr(PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_INIT_QUENT) <> FloatToStr(PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_INIT_QUENT)) or
         (FloatToStr(PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_FIN_QUENT) <> FloatToStr(PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_FIN_QUENT)) or
         (FloatToStr(PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_WEIGHT) <> FloatToStr(PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_WEIGHT)) or
         (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_DESC_UM <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_DESC_UM) or
         (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_CAL <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_CAL) or
         (FloatToStr(PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_SETUP_TIME_STP) <> FloatToStr(PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_SETUP_TIME_STP)) or
         (FloatToStr(PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_EXC_TIME_STP) <> FloatToStr(PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_EXC_TIME_STP)) or
         (FloatToStr(PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_RES_NUM_PLN) <> FloatToStr(PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_RES_NUM_PLN)) or
         (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_ALLOW_SPLIT <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_ALLOW_SPLIT) or
         (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_STEP_HANDLE_REPROCES <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_STEP_HANDLE_REPROCES) or
         (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_STEP_PART_GEN_PLAN <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_STEP_PART_GEN_PLAN) or
         (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_CONN_TYPE_PREV_STEP_SPLIT <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_CONN_TYPE_PREV_STEP_SPLIT) or
         (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_FRC_OVERLAPP <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_FRC_OVERLAPP) or
         (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_STEP_CLOSED <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_STEP_CLOSED) or
         (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_ALTERNATIVEQTY <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_ALTERNATIVEQTY) or
         (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_ALTERNATIVEUM <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_ALTERNATIVEUM) or
         (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_SchedulByMqm <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_SchedulByMqm) or
         (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_SchedulByMcm <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_SchedulByMcm) then //or
      begin
        Curr_Req_Step_Flag := StepCosmeticChanged;
      end;

      if (DndArchiveHostName = TD_AS_400) then
      begin
        try
          if (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_LearningCurveCode <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_LearningCurveCode) or
             (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_LearningCurveType <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_LearningCurveType) or
             (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_MaxStartDateAutoSeq <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_MaxStartDateAutoSeq) or
             (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_ApprovalDate <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_ApprovalDate) then
          begin
             Curr_Req_Step_Flag := StepCosmeticChanged;
          end;
        except
        end;

        try
          if (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_GRP_SEQUENCE <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_GRP_SEQUENCE) then
             Curr_Req_Step_Flag := StepCosmeticChanged;
        except
        end;

        try
          if (FloatToStr(PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_MinBatchSize) <> FloatToStr(PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_MinBatchSize)) or
             (FloatToStr(PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_OptimumBatchSize) <> FloatToStr(PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_OptimumBatchSize)) or
             (FloatToStr(PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_MaxBatchSize) <> FloatToStr(PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_MaxBatchSize)) or
             (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_BatchSizePerStep <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_BatchSizePerStep) then
          begin
             Curr_Req_Step_Flag := StepCosmeticChanged;
          end;
        except
        end;


      end;

      if (DndArchiveHostName <> TD_AS_400) then
      begin

         try
          if (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_LearningCurveCode <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_LearningCurveCode) or
             (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_LearningCurveType <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_LearningCurveType) or
             (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_ApprovalDate <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_ApprovalDate) then
            begin
              Curr_Req_Step_Flag := StepCosmeticChanged;
            end;
         except
         end;

         if (DateTimeToStr(PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_INITIALPLANSCHEDDATETIME) <> DateTimeToStr(PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_INITIALPLANSCHEDDATETIME)) or
            (DateTimeToStr(PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_FINALPLANSCHEDDATETIME) <> DateTimeToStr(PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_FINALPLANSCHEDDATETIME)) then
               Curr_Req_Step_Flag := StepCosmeticChanged;

         if (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_SplitFamily <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_SplitFamily) or
            (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_LearningCurveCode <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_LearningCurveCode) or
            (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_LearningCurveType <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_LearningCurveType) or
            (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_SchedulByMcm <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_SchedulByMcm) or
            (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_SchedulByMqm <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_SchedulByMqm) or
            (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_Prev_LeadTime_mqm <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_Prev_LeadTime_mqm) or
            (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_Next_LeadTime_mqm <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_Next_LeadTime_mqm) or
            (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_Prev_LeadTimeBatch_mqm <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_Prev_LeadTimeBatch_mqm) or
            (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_Next_LeadTimeBatch_mqm <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_Next_LeadTimeBatch_mqm) then
         begin
           Curr_Req_Step_Flag := StepCosmeticChanged;
         end;

         if PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_SchedulByMqm = '1' then
         begin
           if (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_PRV_STEP_SCHED_MCM <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_PRV_STEP_SCHED_MCM) or
              (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_NEX_STEP_SCHED_MCM <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_NEX_STEP_SCHED_MCM) or
              (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_Prev_LeadTime_mcm <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_Prev_LeadTime_mcm) or
              (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_Next_LeadTime_mcm <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_Next_LeadTime_mcm) or
              (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_Prev_LeadTimeBatch_mcm <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_Prev_LeadTimeBatch_mcm) or
              (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_Next_LeadTimeBatch_mcm <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_Next_LeadTimeBatch_mcm) then
           begin
             Curr_Req_Step_Flag := StepCosmeticChanged;
           end;
         end;

         if (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_OVERLAP_WITH_OTHER_STEPS <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_OVERLAP_WITH_OTHER_STEPS) OR
            (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_NumResComponents <> PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_NumResComponents) then
         begin
           Curr_Req_Step_Flag := StepCosmeticChanged;
         end;
      end;

      //******************************************************************//
      //************           PP Loop                   *****************//
      //******************************************************************//

      tbInfo := @tblInfo[tbl_prop_prod];
      while true  do
      begin
        FlagEol := false;
        if EOL_Host(PP) or (PTMQMPP(m_HostListPP[m_Host_IndexPP]).PP_PREQ_NO > Curr_Req) then
           FlagEol := true
        else
        begin
          if (PTMQMPP(m_HostListPP[m_Host_IndexPP]).PP_PSTEP_ID > Curr_Req_Step) then
              FlagEol := true
        end;

        FlagEof := false;
        if (EOL_Local(PP) or
           (PTMQMPP(m_LocalListPP[m_Local_IndexPP]).PP_PREQ_NO > Curr_Req)) then
             FlagEof := true
        else
        begin
           if (PTMQMPP(m_LocalListPP[m_Local_IndexPP]).PP_PSTEP_ID > Curr_Req_Step) then
              FlagEof := true
        end;

        if FlagEol and FlagEof then
           break;

        if FlagEol or
         (not FlagEol and not FlagEof and (PTMQMPP(m_HostListPP[m_Host_IndexPP]).PP_PROPERTY > PTMQMPP(m_LocalListPP[m_Local_IndexPP]).PP_PROPERTY)) then
        begin
          Curr_Req_Step_Flag := StepCosmeticChanged;
          if not SearchPropInList(true, PTMQMPP(m_LocalListPP[m_Local_IndexPP]).PP_PROPERTY, PropVal) then
          begin
            inc(m_Local_IndexPP);
            continue;
          end;

          if (not EOL_Host(PP)) and ((PTMQMPP(m_LocalListPP[m_Local_IndexPP]).PP_VALUE <> PropVal)) then
          begin
              // check out the prop table for the ReSchedul Value with the prop code
            if CheckProperty(PTMQMPP(m_LocalListPP[m_Local_IndexPP]).PP_PROPERTY) then
            begin
              Curr_Req_Step_Flag := StepPropChange;
              PropCode  := PTMQMPP(m_HostListPP[m_Host_IndexPP]).PP_PROPERTY;
              PropLocal := PTMQMPP(m_LocalListPP[m_Local_IndexPP]).PP_VALUE;
              Reason := 'PropCode :' + PropCode + ' Chg From ' + PropLocal + ' To:' + PropVal;
              GoTo EndOfPDLoop;
            end;
          end;
          inc(m_Local_IndexPP);
          continue;
        end;

        if FlagEof or
         (not FlagEof and not FlagEol and (PTMQMPP(m_LocalListPP[m_Local_IndexPP]).PP_PROPERTY > PTMQMPP(m_HostListPP[m_Host_IndexPP]).PP_PROPERTY)) then
        begin
          Curr_Req_Step_Flag := StepCosmeticChanged;
          if not SearchPropInList(false, PTMQMPP(m_HostListPP[m_Host_IndexPP]).PP_PROPERTY , PropVal) then
          begin
            // check out the prop table with the prop code
            if CheckProperty(PTMQMPP(m_HostListPP[m_Host_IndexPP]).PP_PROPERTY) then
            begin
              Curr_Req_Step_Flag := StepPropChange;
              PropCode  := PTMQMPP(m_HostListPP[m_Host_IndexPP]).PP_PROPERTY;
              Reason := 'PropCode :' + PropCode + ' was added ';
              GoTo EndOfPDLoop;
            end;
            m_Host_IndexPP := m_Host_IndexPP + 1;
            continue;
          end;

          if (PTMQMPP(m_HostListPP[m_Host_IndexPP]).PP_VALUE <> PropVal) then
          begin
            // check out the prop table with the prop code
            if CheckProperty(PTMQMPP(m_HostListPP[m_Host_IndexPP]).PP_PROPERTY) then
            begin
              Curr_Req_Step_Flag := StepPropChange;
              PropCode  := PTMQMPP(m_HostListPP[m_Host_IndexPP]).PP_PROPERTY;
              PropHost  := PTMQMPP(m_HostListPP[m_Host_IndexPP]).PP_VALUE;
              Reason := 'PropCode :' + PropCode + ' Chg From ' + PropVal + ' To:' + PropHost;
              GoTo EndOfPDLoop;
            end;
          end;
          m_Host_IndexPP := m_Host_IndexPP + 1;
          continue
        end;

        if (PTMQMPP(m_LocalListPP[m_Local_IndexPP]).PP_VALUE <> PTMQMPP(m_HostListPP[m_Host_IndexPP]).PP_VALUE) then
        begin
          Curr_Req_Step_Flag := StepCosmeticChanged;
          if CheckProperty(PTMQMPP(m_HostListPP[m_Host_IndexPP]).PP_PROPERTY) then
          begin
            Curr_Req_Step_Flag := StepPropChange;
            PropCode  := PTMQMPP(m_HostListPP[m_Host_IndexPP]).PP_PROPERTY;
            PropLocal := PTMQMPP(m_LocalListPP[m_Local_IndexPP]).PP_VALUE;
            PropHost  := PTMQMPP(m_HostListPP[m_Host_IndexPP]).PP_VALUE;
            Reason := 'PropCode :' + PropCode + ' Chg From ' + PropLocal + ' To:' + PropHost;
            GoTo EndOfPDLoop;
          end
        end;

        Inc(m_Local_IndexPP);
        m_Host_IndexPP := m_Host_IndexPP + 1;
      end;

      //******************************************************************//
      //************           PI Loop                   *****************//
      //******************************************************************//

      if (Curr_Req_Step_Flag = NoChange) then
      begin
        tbInfo := @tblInfo[tbl_prod_info];
        while true do
        begin
          if (EOL_Host(PI) or (PTMQMPI(m_HostListPI[m_Host_IndexPI]).PI_PREQ_NO > Curr_Req) or
             (PTMQMPI(m_HostListPI[m_Host_IndexPI]).PI_PSTEP_ID > Curr_Req_Step)) and
             (EOL_Local(PI) or (PTMQMPI(m_LocalListPI[m_Local_IndexPI]).PI_PREQ_NO > Curr_Req) or
             (PTMQMPI(m_LocalListPI[m_Local_IndexPI]).PI_PSTEP_ID > Curr_Req_Step)) then
          break;

          if (EOL_Host(PI) or (PTMQMPI(m_HostListPI[m_Host_IndexPI]).PI_PREQ_NO > Curr_Req) or
             (PTMQMPI(m_HostListPI[m_Host_IndexPI]).PI_PSTEP_ID > Curr_Req_Step)) then
          begin
            Curr_Req_Step_Flag := StepCosmeticChanged;
            break;
          end;

          if (EOL_Host(PI) or (PTMQMPI(m_LocalListPI[m_Local_IndexPI]).PI_PREQ_NO > Curr_Req) or
             (PTMQMPI(m_LocalListPI[m_Local_IndexPI]).PI_PSTEP_ID > Curr_Req_Step)) then
          begin
            Curr_Req_Step_Flag := StepCosmeticChanged;
            break
          end;

          if (PTMQMPI(m_HostListPI[m_Host_IndexPI]).PI_INFO_TYPE <> PTMQMPI(m_LocalListPI[m_Local_IndexPI]).PI_INFO_TYPE) or
             (PTMQMPI(m_HostListPI[m_Host_IndexPI]).PI_INFO_LINE_NUM <> PTMQMPI(m_LocalListPI[m_Local_IndexPI]).PI_INFO_LINE_NUM) or
             (PTMQMPI(m_HostListPI[m_Host_IndexPI]).PI_INFO_AREA <> PTMQMPI(m_LocalListPI[m_Local_IndexPI]).PI_INFO_AREA) then
          begin
            Curr_Req_Step_Flag := StepCosmeticChanged;
            break
          end;

          inc(m_Local_IndexPI);

          m_Host_IndexPI := m_Host_IndexPI + 1;

        end

      end;

      //******************************************************************//
      //************           SB Loop                   *****************//
      //******************************************************************//

      if (Curr_Req_Step_Flag = NoChange) then
      begin
        tbInfo := @tblInfo[tbl_step_batchSize];
        while true do
        begin
          if (EOL_Host(SB) or (PTMQMSB(m_HostListSB[m_Host_IndexSB]).SB_PREQ_NO > Curr_Req) or
             (PTMQMSB(m_HostListSB[m_Host_IndexSB]).SB_PSTEP_ID > Curr_Req_Step)) and
             (EOL_Local(SB) or (PTMQMSB(m_LocalListSB[m_Local_IndexSB]).SB_PREQ_NO > Curr_Req) or
             (PTMQMSB(m_LocalListSB[m_Local_IndexSB]).SB_PSTEP_ID > Curr_Req_Step)) then
          break;

          if (EOL_Host(SB) or (PTMQMSB(m_HostListSB[m_Host_IndexSB]).SB_PREQ_NO > Curr_Req) or
             (PTMQMSB(m_HostListSB[m_Host_IndexSB]).SB_PSTEP_ID > Curr_Req_Step)) then
          begin
            Curr_Req_Step_Flag := StepCosmeticChanged;
            break;
          end;

          if (EOL_Local(SB) or (PTMQMSB(m_LocalListSB[m_Local_IndexSB]).SB_PREQ_NO > Curr_Req) or
             (PTMQMSB(m_LocalListSB[m_Local_IndexSB]).SB_PSTEP_ID > Curr_Req_Step)) then
          begin
            Curr_Req_Step_Flag := StepCosmeticChanged;
            break
          end;

          if (PTMQMSB(m_HostListSB[m_Host_IndexSB]).SB_BCH_UM <> PTMQMSB(m_LocalListSB[m_Local_IndexSB]).SB_BCH_UM) or
             (FloatToStr(PTMQMSB(m_HostListSB[m_Host_IndexSB]).SB_MULTIPILR_TO_BATCH_UM) <> FloatToStr(PTMQMSB(m_LocalListSB[m_Local_IndexSB]).SB_MULTIPILR_TO_BATCH_UM)) then
          begin
            Curr_Req_Step_Flag := StepCosmeticChanged;
            break
          end;

          inc(m_Local_IndexSB);
          m_Host_IndexSB := m_Host_IndexSB + 1;

        end

      end;

      //******************************************************************//
      //************           MT Loop                   *****************//
      //******************************************************************//

      if (Curr_Req_Step_Flag = NoChange) then
      begin
        tbInfo := @tblInfo[tbl_Material];
        while true do
        begin
          if (EOL_Host(MT) or (PTMQMMT(m_HostlistMT[m_Host_IndexMT]).MT_PROD_REQ_Nr > Curr_Req) or
             (PTMQMMT(m_HostlistMT[m_Host_IndexMT]).MT_PSTEP_ID > Curr_Req_Step)) and
             (EOL_Local(MT) or (PTMQMMT(m_LocallistMT[m_Local_IndexMT]).MT_PROD_REQ_Nr > Curr_Req) or
             (PTMQMMT(m_LocallistMT[m_Local_IndexMT]).MT_PSTEP_ID > Curr_Req_Step)) then
          break;

          if (EOL_Host(MT) or (PTMQMMT(m_HostlistMT[m_Host_IndexMT]).MT_PROD_REQ_Nr > Curr_Req) or
             (PTMQMMT(m_HostlistMT[m_Host_IndexMT]).MT_PSTEP_ID > Curr_Req_Step)) then
          begin
            Curr_Req_Step_Flag := StepCosmeticChanged;
            break;
          end;

          if (EOL_Local(MT) or (PTMQMMT(m_LocallistMT[m_Local_IndexMT]).MT_PROD_REQ_Nr > Curr_Req) or
             (PTMQMMT(m_LocallistMT[m_Local_IndexMT]).MT_PSTEP_ID > Curr_Req_Step)) then
          begin
            Curr_Req_Step_Flag := StepCosmeticChanged;
            break;
          end;

          MT_REQ_QUANTITY_Tmp1 := PTMQMMT(m_HostlistMT[m_Host_IndexMT]).MT_REQ_QUANTITY;
          MT_REQ_QUANTITY_Tmp2 := PTMQMMT(m_LocallistMT[m_Local_IndexMT]).MT_REQ_QUANTITY;

          if (PTMQMMT(m_HostlistMT[m_Host_IndexMT]).MT_ORG_STEP <> PTMQMMT(m_LocallistMT[m_Local_IndexMT]).MT_ORG_STEP) or
             (PTMQMMT(m_HostlistMT[m_Host_IndexMT]).MT_WKCTR_CODE <> PTMQMMT(m_LocallistMT[m_Local_IndexMT]).MT_WKCTR_CODE) or
             (PTMQMMT(m_HostlistMT[m_Host_IndexMT]).MT_RES_CAT_CODE <> PTMQMMT(m_LocallistMT[m_Local_IndexMT]).MT_RES_CAT_CODE) or
             (PTMQMMT(m_HostlistMT[m_Host_IndexMT]).MT_RES_CODE <> PTMQMMT(m_LocallistMT[m_Local_IndexMT]).MT_RES_CODE) or
             (PTMQMMT(m_HostlistMT[m_Host_IndexMT]).MT_MACHIN_SETUP_CODE <> PTMQMMT(m_LocallistMT[m_Local_IndexMT]).MT_MACHIN_SETUP_CODE) or
             (PTMQMMT(m_HostlistMT[m_Host_IndexMT]).MT_ALTERNATIVE_CODE <> PTMQMMT(m_LocallistMT[m_Local_IndexMT]).MT_ALTERNATIVE_CODE) or
             (PTMQMMT(m_HostlistMT[m_Host_IndexMT]).MT_PROD_TYPE <> PTMQMMT(m_LocallistMT[m_Local_IndexMT]).MT_PROD_TYPE) or
             (PTMQMMT(m_HostlistMT[m_Host_IndexMT]).MT_PROD_CODE <> PTMQMMT(m_LocallistMT[m_Local_IndexMT]).MT_PROD_CODE) or
             (PTMQMMT(m_HostlistMT[m_Host_IndexMT]).MT_NET_GROUP_CODE <> PTMQMMT(m_LocallistMT[m_Local_IndexMT]).MT_NET_GROUP_CODE) or
             (PTMQMMT(m_HostlistMT[m_Host_IndexMT]).MT_ISSUE_CODE <> PTMQMMT(m_LocallistMT[m_Local_IndexMT]).MT_ISSUE_CODE) or
             (PTMQMMT(m_HostlistMT[m_Host_IndexMT]).MT_SEQ_ISSUED <> PTMQMMT(m_LocallistMT[m_Local_IndexMT]).MT_SEQ_ISSUED) or
             (PTMQMMT(m_HostlistMT[m_Host_IndexMT]).MT_MAT_BALACE <> PTMQMMT(m_LocallistMT[m_Local_IndexMT]).MT_MAT_BALACE) or
             (MT_REQ_QUANTITY_Tmp1 <> MT_REQ_QUANTITY_Tmp2) or
             (FloatToStr(PTMQMMT(m_HostlistMT[m_Host_IndexMT]).MT_QUANTITY_ISSUE) <> FloatToStr(PTMQMMT(m_LocallistMT[m_Local_IndexMT]).MT_QUANTITY_ISSUE)) or
             (PTMQMMT(m_HostlistMT[m_Host_IndexMT]).MT_SETTLED <> PTMQMMT(m_LocallistMT[m_Local_IndexMT]).MT_SETTLED) or
             (FloatToStr(PTMQMMT(m_HostlistMT[m_Host_IndexMT]).MT_QUANTITY_ALLOC) <> FloatToStr(PTMQMMT(m_LocallistMT[m_Local_IndexMT]).MT_QUANTITY_ALLOC)) or
             (DateTimeToStr(PTMQMMT(m_HostlistMT[m_Host_IndexMT]).MT_HIGH_DATe_ALLOC) <> DateTimeToStr(PTMQMMT(m_LocallistMT[m_Local_IndexMT]).MT_HIGH_DATe_ALLOC)) or
             (PTMQMMT(m_HostlistMT[m_Host_IndexMT]).MT_SEARCH_MAT_BY_ALLOC <> PTMQMMT(m_LocallistMT[m_Local_IndexMT]).MT_SEARCH_MAT_BY_ALLOC) then
          begin
            Curr_Req_Step_Flag := StepCosmeticChanged;
            break;
          end;

          inc(m_Local_IndexMT);
          m_Host_IndexMT := m_Host_IndexMT + 1;

        end

      end;

      //******************************************************************//
      //************           SP Loop                   *****************//
      //******************************************************************//

      if (Curr_Req_Step_Flag = NoChange)
      or (Curr_Req_Step_Flag = StepPropChange)
      or (Curr_Req_Step_Flag = StepCosmeticChanged)
      or (Curr_Req_Step_Flag = OnlyProgres_TimeCng) then
      begin
        tbInfo := @tblInfo[tbl_sched_progress];
        while true do
        begin
          if (EOL_Host(SP) or (PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_PREQ_NO > Curr_Req) or
             (PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_PSTEP_ID > Curr_Req_Step)) and
             (EOL_Local(SP) or (PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_PREQ_NO > Curr_Req) or
             (PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_PSTEP_ID > Curr_Req_Step)) then
          break;

          if (EOL_Host(SP) or (PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_PREQ_NO > Curr_Req) or
             (PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_PSTEP_ID > Curr_Req_Step)) then
          begin
            if Curr_Req_Step_Flag = NoChange then
              Curr_Req_Step_Flag := OnlyProgres_TimeCng;
            break;
          end;

          if (EOL_Local(SP) or (PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_PREQ_NO > Curr_Req) or
             (PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_PSTEP_ID > Curr_Req_Step)) then
          begin
            if Curr_Req_Step_Flag = NoChange then
              Curr_Req_Step_Flag := OnlyProgres_TimeCng;
            break;
          end;

          {if PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_ProgressChange = StepFieldChange then
          begin
            Curr_Req_Step_Flag := StepFieldChange;
            break;
          end;}

          if (PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_PSUBST_ID <> PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_PSUBST_ID) or
             (PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_REPROC_NO <> PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_REPROC_NO) or
             (PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_LAST_PROG_TYPE <> PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_LAST_PROG_TYPE) or
             (PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_RSC_CODE <> PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_RSC_CODE) or
             (PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_PROGRESED_GROUP <> PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_PROGRESED_GROUP) or
             (DateTimeToStr(PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_PROGRSTART) <> DateTimeToStr(PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_PROGRSTART)) or
             (DateTimeToStr(PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_CURR_PRG_DATE) <> DateTimeToStr(PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_CURR_PRG_DATE)) or
             (DateTimeToStr(PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_PROGREND) <> DateTimeToStr(PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_PROGREND)) or
             (FloatToStr(PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_QTY) <> FloatToStr(PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_QTY)) or
             (FloatToStr(PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_StartingQty) <> FloatToStr(PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_StartingQty)) or
             (FloatToStr(PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_REMAIN_TIME) <> FloatToStr(PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_REMAIN_TIME)) or
             (PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_LAST_PROG_TYPE_HOST <> PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_LAST_PROG_TYPE_HOST) or
             (PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_RSC_CODE_HOST <> PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_RSC_CODE_HOST) or
             (DateTimeToStr(PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_PROGRSTART_HOST) <> DateTimeToStr(PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_PROGRSTART_HOST)) or
             (DateTimeToStr(PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_CURR_PRG_DATE_HOST) <> DateTimeToStr(PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_CURR_PRG_DATE_HOST)) or
             (DateTimeToStr(PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_PROGREND_HOST) <> DateTimeToStr(PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_PROGREND_HOST)) or
             (FloatToStr(PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_QTY_HOST) <> FloatToStr(PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_QTY_HOST)) or
             (FloatToStr(PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_REMAIN_TIME_HOST) <> FloatToStr(PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_REMAIN_TIME_HOST)) then
          begin
            if Curr_Req_Step_Flag = NoChange then
              Curr_Req_Step_Flag := OnlyProgres_TimeCng;
            break;
          end;

          Inc(m_Local_IndexSP);
          m_Host_IndexSP := m_Host_IndexSP + 1;

        end

      end;

      //******************************************************************//
      //************           ST Loop                   *****************//
      //******************************************************************//

      {if (Curr_Req_Step_Flag = NoChange) then}     {Eran}
      {begin}                                       {Eran}

      tbInfo := @tblInfo[tbl_step_times];
      while true do
      begin
        if (EOL_Host(ST) or (PTMQMST(m_HostListST[m_Host_IndexST]).ST_PREQ_NO > Curr_Req) or
           (PTMQMST(m_HostListST[m_Host_IndexST]).ST_PSTEP_ID > Curr_Req_Step)) and
           (EOL_Local(ST) or (PTMQMST(m_LocalListST[m_Local_IndexST]).ST_PREQ_NO > Curr_Req) or
           (PTMQMST(m_LocalListST[m_Local_IndexST]).ST_PSTEP_ID > Curr_Req_Step)) then
        break;

        if (EOL_Host(ST) or (PTMQMST(m_HostListST[m_Host_IndexST]).ST_PREQ_NO > Curr_Req) or
           (PTMQMST(m_HostListST[m_Host_IndexST]).ST_PSTEP_ID > Curr_Req_Step)) then
        begin
          if (Curr_Req_Step_Flag = NoChange) then
             Curr_Req_Step_Flag := OnlyProgres_TimeCng;
          break;
        end;

        if (EOL_Local(ST) or (PTMQMST(m_LocalListST[m_Local_IndexST]).ST_PREQ_NO > Curr_Req) or
           (PTMQMST(m_LocalListST[m_Local_IndexST]).ST_PSTEP_ID > Curr_Req_Step)) then
        begin
          {Curr_Req_Step_Flag := OnlyProgres_TimeCng;}     {Eran}
  //        Curr_Req_Step_Flag := StepFieldChange;           {Eran }
          Curr_Req_Step_Flag := OnlyProgres_TimeCng;
          break;
        end;

    {Eran}
        if (PTMQMST(m_HostListST[m_Host_IndexST]).ST_WKCNTER < PTMQMST(m_LocalListST[m_Local_IndexST]).ST_WKCNTER) then
        begin
  //        Curr_Req_Step_Flag := StepFieldChange;
          Curr_Req_Step_Flag := OnlyProgres_TimeCng;
          break;
        end;
        if (PTMQMST(m_HostListST[m_Host_IndexST]).ST_WKCNTER > PTMQMST(m_LocalListST[m_Local_IndexST]).ST_WKCNTER) then
        begin
          if (Curr_Req_Step_Flag = NoChange) then
             Curr_Req_Step_Flag := OnlyProgres_TimeCng;
          m_Host_IndexST := m_Host_IndexST + 1;
          continue;
        end;
        if (PTMQMST(m_HostListST[m_Host_IndexST]).ST_WKCT_PROC < PTMQMST(m_LocalListST[m_Local_IndexST]).ST_WKCT_PROC) then
        begin
  //        Curr_Req_Step_Flag := StepFieldChange;
          Curr_Req_Step_Flag := OnlyProgres_TimeCng;
          break;
        end;
        if (PTMQMST(m_HostListST[m_Host_IndexST]).ST_WKCT_PROC > PTMQMST(m_LocalListST[m_Local_IndexST]).ST_WKCT_PROC) then
        begin
          if (Curr_Req_Step_Flag = NoChange) then
             Curr_Req_Step_Flag := OnlyProgres_TimeCng;
          m_Host_IndexST := m_Host_IndexST + 1;
          continue;
        end;
        if (PTMQMST(m_HostListST[m_Host_IndexST]).ST_RES_CATEGORY < PTMQMST(m_LocalListST[m_Local_IndexST]).ST_RES_CATEGORY) then
        begin
   //       Curr_Req_Step_Flag := StepFieldChange;
          Curr_Req_Step_Flag := OnlyProgres_TimeCng;
          break;
        end;
        if (PTMQMST(m_HostListST[m_Host_IndexST]).ST_RES_CATEGORY > PTMQMST(m_LocalListST[m_Local_IndexST]).ST_RES_CATEGORY) then
        begin
          if (Curr_Req_Step_Flag = NoChange) then
             Curr_Req_Step_Flag := OnlyProgres_TimeCng;
          m_Host_IndexST := m_Host_IndexST + 1;
          continue;
        end;
        if (PTMQMST(m_HostListST[m_Host_IndexST]).ST_RSC_CODE < PTMQMST(m_LocalListST[m_Local_IndexST]).ST_RSC_CODE) then
        begin
   //       Curr_Req_Step_Flag := StepFieldChange;
          Curr_Req_Step_Flag := OnlyProgres_TimeCng;
          break;
        end;
        if (PTMQMST(m_HostListST[m_Host_IndexST]).ST_RSC_CODE > PTMQMST(m_LocalListST[m_Local_IndexST]).ST_RSC_CODE) then
        begin
          if (Curr_Req_Step_Flag = NoChange) then
             Curr_Req_Step_Flag := OnlyProgres_TimeCng;
          m_Host_IndexST := m_Host_IndexST + 1;
          continue;
        end;
        if (PTMQMST(m_HostListST[m_Host_IndexST]).ST_SETUP_TIME_Mechin_Code < PTMQMST(m_LocalListST[m_Local_IndexST]).ST_SETUP_TIME_Mechin_Code) then
        begin
   //       Curr_Req_Step_Flag := StepFieldChange;
          Curr_Req_Step_Flag := OnlyProgres_TimeCng;
          break;
        end;
        if (PTMQMST(m_HostListST[m_Host_IndexST]).ST_SETUP_TIME_Mechin_Code > PTMQMST(m_LocalListST[m_Local_IndexST]).ST_SETUP_TIME_Mechin_Code) then
        begin
          if (Curr_Req_Step_Flag = NoChange) then
             Curr_Req_Step_Flag := OnlyProgres_TimeCng;
          m_Host_IndexST := m_Host_IndexST + 1;
          continue;
        end;
     {Eran end}

   {    if (PTMQMST(m_HostListST[m_Host_IndexST]).ST_WKCNTER <> Trim(QryST.FieldByName(CreateFld(tbInfo.pfx, fli_wkCtrCode)).AsString)) or
           (PTMQMST(m_HostListST[m_Host_IndexST]).ST_WKCT_PROC <> Trim(QryST.FieldByName(CreateFld(tbInfo.pfx, fli_wkcProc)).AsString)) or
           (PTMQMST(m_HostListST[m_Host_IndexST]).ST_RES_CATEGORY <> Trim(QryST.FieldByName(CreateFld(tbInfo.pfx, fli_rscCat)).AsString)) or
           (PTMQMST(m_HostListST[m_Host_IndexST]).ST_RSC_CODE <> Trim(QryST.FieldByName(CreateFld(tbInfo.pfx, fli_rsc)).AsString)) or
           (PTMQMST(m_HostListST[m_Host_IndexST]).ST_SETUP_TIME_Mechin_Code <> Trim(QryST.FieldByName(CreateFld(tbInfo.pfx, fli_MachSetupCode)).AsString)) or   }
         if
{$ifdef ARO}
           (PTMQMST(m_HostListST[m_Host_IndexST]).ST_SEQCHAR <> PTMQMST(m_LocalListST[m_Local_IndexST]).ST_SEQCHAR) or
{$endif}
           (FloatToStr(PTMQMST(m_HostListST[m_Host_IndexST]).ST_SETUP_TIME_JOB) <> FloatToStr(PTMQMST(m_LocalListST[m_Local_IndexST]).ST_SETUP_TIME_JOB)) or
           (FloatToStr(PTMQMST(m_HostListST[m_Host_IndexST]).ST_EXC_TIME_INIT_QTY) <> FloatToStr(PTMQMST(m_LocalListST[m_Local_IndexST]).ST_EXC_TIME_INIT_QTY)) then
        begin
           if (Curr_Req_Step_Flag = NoChange) then
              Curr_Req_Step_Flag := OnlyProgres_TimeCng;
          {break;}       {Eran}
        end;

        Inc(m_Local_IndexST);
        m_Host_IndexST := m_Host_IndexST + 1;

      end;

      {end;}        {Eran}

      EndOfPDLoop:
      inc(m_Local_IndexPD);
      m_Host_IndexPD := m_Host_IndexPD + 1;

    end;

    EndOfPRLoop:
    m_Host_IndexPR := m_Host_IndexPR + 1;
    inc(m_Local_IndexPR);

  end;

{  for I := m_LocalListPR.Count -1 downto 0 do
    Dispose(PTMQMPR(m_LocalListPR[I]));
  m_LocalListPR.clear;

  for I := m_LocalListPH.Count -1 downto 0 do
    Dispose(PTMQMPH(m_LocalListPH[I]));
  m_LocalListPH.clear;

  for I := m_LocalListPD.Count -1 downto 0 do
    Dispose(PTMQMPD(m_LocalListPD[I]));
  m_LocalListPD.clear;

  for I := m_LocalListPP.Count -1 downto 0 do
    Dispose(PTMQMPP(m_LocalListPP[I]));
  m_LocalListPP.clear;;

  for I := m_LocalListPI.Count -1 downto 0 do
    Dispose(PTMQMPI(m_LocalListPI[I]));
  m_LocalListPI.clear;

  for I := m_LocalListEC.Count -1 downto 0 do
    Dispose(PTMQMEC(m_LocalListEC[I]));
  m_LocalListEC.clear;

  for I := m_LocalListIC.Count -1 downto 0 do
    Dispose(PTMQMIC(m_LocalListIC[I]));
  m_LocalListIC.clear;

  for I := m_LocalListSB.Count -1 downto 0 do
    Dispose(PTMQMSB(m_LocalListSB[I]));
  m_LocalListSB.clear;

  for I := m_LocalListSP.Count -1 downto 0 do
    Dispose(PTMQMSP(m_LocalListSP[I]));
  m_LocalListSP.clear;

  for I := m_LocalListST.Count -1 downto 0 do
    Dispose(PTMQMST(m_LocalListST[I]));
  m_LocalListST.clear;

  for I := m_LocalListMT.Count -1 downto 0 do
    Dispose(PTMQMMT(m_LocalListMT[I]));
  m_LocalListMT.clear;

  for I := m_LocalListPA.Count -1 downto 0 do
    Dispose(PTMQMPA(m_LocalListPA[I]));
  m_LocalListPA.clear;  }

end;

//----------------------------------------------------------------------------//

destructor TProdCont.Destroy;
begin
  FreeListProd;
  inherited Destroy;
end;

//----------------------------------------------------------------------------//

function CompareKeys(TableNumberOfKeys, TableNumberOfFields : integer; var HostFields : Array of variant; var LocalFields : Array of variant) : TDBOperation;
var
  Index : integer;
begin
  Result := DBEqual;
  for Index := 0 to TableNumberOfFields - 1 do
  begin
    if HostFields[Index] = LocalFields[Index] then continue;
    if Index > TableNumberOfKeys - 1  then
    begin
      Result := DBUpdate;
      exit;
    end;
    if HostFields[Index] > LocalFields[Index] then
      Result := DBDelete
    else
      Result := DBInsert;
    exit;
  end;
end;

//----------------------------------------------------------------------------//

Function SetDecSeparator(S : String) : String;
begin

  if FormatSettings.DecimalSeparator = ',' then
  begin
      s := StringReplace(s,',','.', [rfReplaceAll, rfIgnoreCase]);
      s := StringReplace(s,'|',',', [rfReplaceAll, rfIgnoreCase]);
  end;

  Result := S;

end;


procedure BuildSql(tbl: table; linkArr: array of TQryLinkRec; NumberKeys : Integer; var SqlUpdate, SqlDel : string);
var
  tbInfo:         ^TTblInfo;
  I : Integer;
  Str : string;
begin
  tbInfo := @tblInfo[tbl];
  SqlUpdate := '';
  SqlDel := '';

  Str := '';
  SqlUpdate := 'update ' + tbinfo.GetTableName + ' set ';
  for i := 0 to High(linkArr) do
  begin
    SqlUpdate :=  SqlUpdate + Str;
    SqlUpdate :=  SqlUpdate + CreateFld(tbInfo.pfx, linkArr[i].fldPC) + '=:' + CreateFld(tbInfo.pfx, linkArr[i].fldPC);
    Str := DecSep;
  end;

  Str := '';
  SqlUpdate := SetDecSeparator(SqlUpdate);
  SqlUpdate :=  SqlUpdate + ' Where ';
  for i := 0 to NumberKeys - 1 do
  begin
    SqlUpdate :=  SqlUpdate + Str;
    SqlUpdate :=  SqlUpdate + CreateFld(tbInfo.pfx, linkArr[i].fldPC) + '=:' + CreateFld(tbInfo.pfx, linkArr[i].fldPC);
    Str := ' and ';
  end;

  Str := '';
  SqlUpdate :=  SqlUpdate + AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER));
  SqlDel := ' delete from ' + tbinfo.GetTableName + ' where ';
  for i := 0 to NumberKeys - 1 do
  begin
    SqlDel :=  SqlDel + Str;
    SqlDel :=  SqlDel + CreateFld(tbInfo.pfx, linkArr[i].fldPC) + '=:' + CreateFld(tbInfo.pfx, linkArr[i].fldPC);
    Str := ' and ';
  end;
  Str := '';
  SqlDel :=  SqlDel + AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER));

end;

//----------------------------------------------------------------------------//

function TProdCont.CopyProdSchedToProdSchedMcm(var srvTrs: TMqmTransaction) : boolean;
var
  ConFirmLvl : string;
  NumDaysFromToday : TDateTime;
  SrvQry : TMqmQuery;
  TempDateTime : TDateTime;
  SelectionDateTime, PROD_SCHED, PROD_SCHED_MCM : string;
  Month, Day, Year, AHour, AMinute, ASecond, AMilliSecond : word;
  DndArchiveLocalName : TDndArchiveName;
begin
//  if SP_IS_CLIENT_EXIST then exit;

  DndArchiveLocalName := GetDndArchiveLocalName;
  if DndArchiveLocalName = TD_Interbase then
  begin
    PROD_SCHED := 'PROD_SCHED';
    PROD_SCHED_MCM := 'PROD_SCHED_MCM'
  end
  else
  begin
    PROD_SCHED := 'SCDM_PROD_SCHED';
    PROD_SCHED_MCM := 'SCDM_PROD_SCHED_MCM'
  end;

  if (IniAppGlobals.CBCopiedSchedTypeFromMqm <> '1') and
     (IniAppGlobals.CBCopiedBackwardFromMqmDays <> '1') then exit;

  SrvQry := ThreadCreateQuery(Main_DB);
  srvQry.Transaction := srvTrs;
  srvQry.Transaction.StartTransaction;

  // Delete old prod_sched before write
  with SrvQry do
  begin

    SQL.Clear;
    SQL.Add('update ' + PROD_SCHED_MCM + ' set MS_MQM_ENV = ' + QuotedStr('0') + ' Where MS_MQM_ENV = ' + QuotedStr('1'));
    SQL.Add(AND_IDF_Condition('MS_IDENTIFIER'));
    ExecSQL;

    UpdateOperation('Delete old ' + 'PROD_SCHED_MCM');
    SQL.Clear;

    SQL.Add('delete from ' + PROD_SCHED_MCM + ' PSM where exists (select PS.PS_PREQ_NO from ' + PROD_SCHED + ' PS ' +
            'where PS.PS_SCHED_TYPE ' + ' <> ' + QuotedStr('0') + AND_IDF_Condition('PS.PS_IDENTIFIER') + AND_IDF_Condition('PSM.MS_IDENTIFIER') + ' AND PS.PS_PREQ_NO = PSM.MS_PREQ_NO and PS.PS_PSTEP_ID = PSM.MS_PSTEP_ID AND');

    if IniAppGlobals.CBCopiedSchedTypeFromMqm = '1' then
    begin

      if IniAppGlobals.CopiedSchedTypeFromMqm = '0' then
        ConFirmLvl := QuotedStr('2')
      else if IniAppGlobals.CopiedSchedTypeFromMqm = '1' then
        ConFirmLvl := QuotedStr('2') + ',' +  QuotedStr('1') + ',' + QuotedStr('3') + ',' + QuotedStr('4') + ',' + QuotedStr('5') + ',' + QuotedStr('6') + ',' + QuotedStr('7')
      else if IniAppGlobals.CopiedSchedTypeFromMqm = '2' then
        ConFirmLvl := QuotedStr('2') + ',' + QuotedStr('3') + ',' + QuotedStr('4') + ',' + QuotedStr('5') + QuotedStr('6') + ',' + QuotedStr('7')
      else if IniAppGlobals.CopiedSchedTypeFromMqm = '3' then
        ConFirmLvl := QuotedStr('2') + ',' + QuotedStr('4') + ',' + QuotedStr('5') + ',' + QuotedStr('6') + ',' + QuotedStr('7')
      else if IniAppGlobals.CopiedSchedTypeFromMqm = '4' then
        ConFirmLvl := QuotedStr('2') + ',' + QuotedStr('5') + ',' + QuotedStr('6') + ',' + QuotedStr('7')
      else if IniAppGlobals.CopiedSchedTypeFromMqm = '5' then
        ConFirmLvl := QuotedStr('2') + ',' + QuotedStr('6') + ',' + QuotedStr('7')
      else if IniAppGlobals.CopiedSchedTypeFromMqm = '6' then
        ConFirmLvl := QuotedStr('2') + ',' + QuotedStr('7');

      SQL.Add(' PS_SCHED_TYPE ' + ' in (' + ConFirmLvl + ')');

      if IniAppGlobals.CBCopiedBackwardFromMqmDays = '1' then
        SQL.Add(' AND ')
      else
        SQL.Add(')')
    end;

    if IniAppGlobals.CBCopiedBackwardFromMqmDays = '1' then
    begin
      NumDaysFromToday := now + StrToInt(IniAppGlobals.CopiedBackwardFromMqmDays);

      TempDateTime := NumDaysFromToday;
      DecodeDate(TempDateTime, year, month, day);
      SelectionDateTime := ConvertDateFormatDb2Oracle(TempDateTime, true, true);  //QuotedStr(IntToStr(Month) + '/' + IntToStr(Day) + '/' + IntToStr(Year));

      SQL.Add(' PS_SCH_START ' + ' <= ' + SelectionDateTime);
      SQL.Add(')');
    end;

    ExecSQL;
  end;

  SrvQry.sql.Clear;
  SrvQry.SQL.Add('insert into ' + PROD_SCHED_MCM + ' select * from ' + prod_sched + ' ps where exists ( ' +
                     'select PS1.PS_PREQ_NO from ' + PROD_SCHED + ' PS1 ' +
                     'where PS1.PS_SCHED_TYPE ' + ' <> ' + QuotedStr('0') + AND_IDF_Condition('PS1.PS_IDENTIFIER') + AND_IDF_Condition('PS.PS_IDENTIFIER') + ' AND PS1.PS_PREQ_NO = PS.PS_PREQ_NO and PS1.PS_PSTEP_ID = PS.PS_PSTEP_ID AND ');

  if IniAppGlobals.CBCopiedSchedTypeFromMqm = '1' then
  begin

    if IniAppGlobals.CopiedSchedTypeFromMqm = '0' then
      ConFirmLvl := QuotedStr('2')
    else if IniAppGlobals.CopiedSchedTypeFromMqm = '1' then
      ConFirmLvl := QuotedStr('2') + DecSep +  QuotedStr('1') + DecSep + QuotedStr('3') + DecSep + QuotedStr('4') + DecSep + QuotedStr('5') + QuotedStr('6') + DecSep + QuotedStr('7')
    else if IniAppGlobals.CopiedSchedTypeFromMqm = '2' then
      ConFirmLvl := QuotedStr('2') + DecSep + QuotedStr('3') + DecSep + QuotedStr('4') + DecSep + QuotedStr('5') + DecSep + QuotedStr('6') + DecSep + QuotedStr('7')
    else if IniAppGlobals.CopiedSchedTypeFromMqm = '3' then
      ConFirmLvl := QuotedStr('2') + DecSep + QuotedStr('4') + DecSep + QuotedStr('5') + DecSep + QuotedStr('6') + DecSep + QuotedStr('7')
    else if IniAppGlobals.CopiedSchedTypeFromMqm = '4' then
      ConFirmLvl := QuotedStr('2') + DecSep + QuotedStr('5') + DecSep + QuotedStr('6') + DecSep + QuotedStr('7')
    else if IniAppGlobals.CopiedSchedTypeFromMqm = '5' then
      ConFirmLvl := QuotedStr('2') + DecSep + QuotedStr('6') + DecSep + QuotedStr('7')
    else if IniAppGlobals.CopiedSchedTypeFromMqm = '6' then
      ConFirmLvl := QuotedStr('2') + DecSep + QuotedStr('7');

    ConFirmLvl := SetDecSeparator(ConFirmLvl);

    SrvQry.SQL.Add('PS1.' + 'PS_SCHED_TYPE ' + ' in (' + ConFirmLvl + ')');

    if IniAppGlobals.CBCopiedBackwardFromMqmDays = '1' then
      SrvQry.SQL.Add(' AND ')

  end;

  if IniAppGlobals.CBCopiedBackwardFromMqmDays = '1' then
  begin
    NumDaysFromToday := now + StrToInt(IniAppGlobals.CopiedBackwardFromMqmDays);

    TempDateTime := NumDaysFromToday;
    DecodeDate(TempDateTime, year, month, day);
    SelectionDateTime := ConvertDateFormatDb2Oracle(TempDateTime, true, true);//QuotedStr(IntToStr(Month) + '/' + IntToStr(Day) + '/' + IntToStr(Year));

    SrvQry.SQL.Add('PS1.' + 'PS_SCH_START ' + ' <= ' + SelectionDateTime);
  end;

  SrvQry.SQL.Add(')');

  SrvQry.ExecSQL;
  srvQry.Transaction.Commit;

  SrvQry.Close;
  SrvQry.Free;
end;

//----------------------------------------------------------------------------//

function TProdCont.UpdateStatusRequests : boolean;
var
  tblInf : ^TTblInfo;
  LocalListPR,LocalListPH,LocalListPD,LocalListPP,LocalListPI,LocalListEC,LocalListIC,
  LocalListSB,LocalListSP,LocalListST,LocalListMT,LocalListPA : TList;
  QryTmp : TMqmQuery;
  QryUpdatePR, QryDelPR, QryUpdatePH, QryDelPH, QryUpdatePD, QryDelPD : TMqmQuery;
  QryUpdatePP, QryDelPP, QryUpdatePI, QryDelPI, QryUpdateEC, QryDelEC : TMqmQuery;
  QryUpdateIC, QryDelIC, QryUpdateSB, QryDelSB, QryUpdateSP, QryDelSP : TMqmQuery;
  QryUpdateST, QryDelST, QryUpdateMT, QryDelMT, QryUpdatePA, QryDelPA : TMqmQuery;
  SqlUpdate, SqlDel : string;
//  SrvQryPR, SrvQryPH, SrvQryPD, SrvQryPP, SrvQryPI, SrvQryEC SrvQryIC, SrvQrySB, SrvQrySP, SrvQryST,  SrvQryMT,

//  SrvQryPA : TMqmQuery;
  SrvQryPS, SrvQryPSMCM : TMqmQuery;
  QryUpdatePS, QryDelPS, QryUpdatePSMCM, QryDelPSMCM : TMqmQuery;
  QryInsertEc, QryInsertIC, QryInsertPA, QryInsertPI, QryInsertSB, QryInsertST : TMqmQuery;
  QryInsertMT, QryInsertSP, QryInsertPR, QryInsertPH, QryInsertPD, QryInsertPP : TMqmQuery;
  QryInsertCR : TMqmQuery;
  QryInsertSql : string;
  MqmTrs : TMqmTransaction;
//  srvTrsPS : TMqmTransaction;
  IndexPR, IndexPH, IndexPD, IndexPP, IndexPI, IndexEC, IndexIC, IndexSB, IndexSP : Integer;
  IndexST, IndexMT, IndexPA : Integer;
  IndexPR_Local, IndexPH_Local, IndexPD_Local, IndexPP_Local, IndexPI_Local, IndexEC_Local,
  IndexIC_Local, IndexSB_Local, IndexSP_Local, IndexST_Local, IndexMT_Local, IndexPA_Local : Integer;
  HostFields : array[1..65] of variant;
  LocalFields : array[1..65] of variant;
  TableNumberOfKeys, TableNumberOfFields : Integer;
  Operation : TDBOperation;
  I, J, IndexStep, StepToCheck : Integer;
  Request, WorkCenterToUpdate, ToBeSched : String;
  FirstCycle, HostHaveData, EndRequestDataHost, EndRequestDataLocal,
  RequestHasStepsInList, UpdatedWorkCenter, IsClientOpen, PSDelete,
  PSUnsched, Use_CG_loop, pdstr, WcRecEntered : boolean;
  Req, Reason, Resource, schedType, PROD_REQ_HDR : string;
  StartDate, EndDate : TDateTime;
  Step ,SubStep ,RePRoc : integer;
  Qty, Temp_TimeVal : double;
  DndArchiveLocalName, DndArchiveHostName : TDndArchiveName;
  RunCommit : boolean;
  LogPP : TStringList;
  InList : string;
  BatchStart, BatchEnd : integer;
const
  fldListECStruct : array [0..6] of TQryLinkRec = (
    (fldPC: fli_preqNo;            fldAS: 'ZPRREQ'; fldType: TLD_string),
    (fldPC: fli_ConnKey;           fldAS: 'ZCNKEY'; fldType: TLD_string),
    (fldPC: fli_NumOfLevel;        fldAS: 'ZNBRLV'; fldType: TLD_integer),
    (fldPC: fli_ConnCertentyLevel; fldAS: 'ZCNCER'; fldType: TLD_string),
    (fldPC: fli_usrCg;             fldAS: 'ZUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;           fldAS: 'ZDTOCH'; fldType: TLD_dateTime),
    (fldPC: fli_IDENTIFIER;        fldAS: '';       fldType: TLD_string)
  );
  KeyNumEC = 2;
  fldListICStruct : array [0..6] of TQryLinkRec = (
    (fldPC: fli_preqNo;              fldAS: 'CPRREQ'; fldType: TLD_string),
    (fldPC: fli_PrevProdNum;         fldAS: 'CPRPRD'; fldType: TLD_string),
    (fldPC: fli_usrCg;               fldAS: 'CUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;             fldAS: 'CDTOCH'; fldType: TLD_dateTime),
    (fldPC: fli_CreateDateTimeUTC;      fldAS: '';    fldType: TLD_dateTime),
    (fldPC: fli_CrtOrUpdateDateTimeUTC; fldAS: '';    fldType: TLD_dateTime),
    (fldPC: fli_IDENTIFIER;          fldAS: '';       fldType: TLD_string)
  );
  KeyNumIC = 2;
  fldListPAStruct : array [0..13] of TQryLinkRec = (
    (fldPC: fli_preqNo;              fldAS: 'APRREQ'; fldType: TLD_string),
    (fldPC: fli_sequenceChar;        fldAS: 'ASEQNC'; fldType: TLD_string),
    (fldPC: fli_ProdCode;            fldAS: 'APRDCD'; fldType: TLD_string),
    (fldPC: fli_netGroupCode;        fldAS: 'ANETCD'; fldType: TLD_string),
    (fldPC: fli_AllocReq;            fldAS: 'AALCRQ'; fldType: TLD_string),
    (fldPC: fli_Prod_Balance;        fldAS: 'APRDBL'; fldType: TLD_string),
    (fldPC: fli_Rsc;                 fldAS: 'ACDRSC'; fldType: TLD_string),
    (fldPC: fli_settled;             fldAS: 'AFLSAL'; fldType: TLD_string),
    (fldPC: fli_reqQuant;            fldAS: 'AREQQT'; fldType: TLD_float),
    (fldPC: fli_qtyProduced;         fldAS: 'APRDQT'; fldType: TLD_float),
    (fldPC: fli_AllocQty;            fldAS: 'AALCQT'; fldType: TLD_float),
    (fldPC: fli_CreateDateTimeUTC;      fldAS: '';    fldType: TLD_dateTime),
    (fldPC: fli_CrtOrUpdateDateTimeUTC; fldAS: '';    fldType: TLD_dateTime),
    (fldPC: fli_IDENTIFIER;          fldAS: '';       fldType: TLD_string)
   );
   KeyNumPA = 5;
  fldListPIStruct : array [0..7] of TQryLinkRec = (
    (fldPC: fli_preqNo;      fldAS: 'NPRREQ'; fldType: TLD_string),
    (fldPC: fli_pstepId;     fldAS: 'NPRSTP'; fldType: TLD_integer),
    (fldPC: fli_infoType;    fldAS: 'NINFTY'; fldType: TLD_string),
    (fldPC: fli_infoLineNum; fldAS: 'NINFLN'; fldType: TLD_integer),
    (fldPC: fli_InfoArea;    fldAS: 'NINFAR'; fldType: TLD_string),
    (fldPC: fli_usrCg;       fldAS: 'NUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;     fldAS: 'NDTOCH'; fldType: TLD_dateTime),
    (fldPC: fli_IDENTIFIER;  fldAS: '';       fldType: TLD_string)
  );
   KeyNumPI = 4;
  fldListSBStruct : array [0..6] of TQryLinkRec = (
    (fldPC: fli_preqNo;              fldAS: 'JPRREQ'; fldType: TLD_string),
    (fldPC: fli_pstepId;             fldAS: 'JPRSTP'; fldType: TLD_integer),
    (fldPC: fli_BchUM;               fldAS: 'JBSZUM'; fldType: TLD_string),
    (fldPC: fli_multipToBatchUm;     fldAS: 'JBTCML'; fldType: TLD_float),
    (fldPC: fli_CreateDateTimeUTC;      fldAS: '';    fldType: TLD_dateTime),
    (fldPC: fli_CrtOrUpdateDateTimeUTC; fldAS: '';    fldType: TLD_dateTime),
    (fldPC: fli_IDENTIFIER;          fldAS: '';       fldType: TLD_string)
  );
   KeyNumSB = 3;
  fldListSTStruct : array [0..11] of TQryLinkRec = (
    (fldPC: fli_preqNo;           fldAS: 'QPRREQ'; fldType: TLD_string),
    (fldPC: fli_pstepId;          fldAS: 'QPRSTP'; fldType: TLD_integer),
    (fldPC: fli_wkCtrCode;        fldAS: 'QCDMAC'; fldType: TLD_string),
    (fldPC: fli_wkcProc;          fldAS: 'QCDMAP'; fldType: TLD_string),
    (fldPC: fli_rscCat;           fldAS: 'QCATRS'; fldType: TLD_string),
    (fldPC: fli_rsc;              fldAS: 'QCDRSC'; fldType: TLD_string),
    (fldPC: fli_MachSetupCode;    fldAS: 'QSETCD'; fldType: TLD_string),
    (fldPC: fli_SetUpTimJob;      fldAS: 'QSETTM'; fldType: TLD_float),
    (fldPC: fli_ExecTimeInitQty;  fldAS: 'QEXCTM'; fldType: TLD_float),
    (fldPC: fli_CreateDateTimeUTC;      fldAS: '';    fldType: TLD_dateTime),
    (fldPC: fli_CrtOrUpdateDateTimeUTC; fldAS: '';    fldType: TLD_dateTime),
    (fldPC: fli_IDENTIFIER;       fldAS: '';       fldType: TLD_string)
  );
   KeyNumST = 7;
  fldListMTStruct : array [0..22] of TQryLinkRec = (
    (fldPC: fli_preqNo;              fldAS: 'HPRREQ'; fldType: TLD_string),
    (fldPC: fli_pstepId;             fldAS: 'HTGSTP'; fldType: TLD_Integer),
    (fldPC: fli_orgStep;             fldAS: 'HPRSTP'; fldType: TLD_integer),
    (fldPC: fli_wkCtrCode;           fldAS: 'HCDMAC'; fldType: TLD_string),
    (fldPC: fli_ResCatcode;          fldAS: 'HCATRS'; fldType: TLD_string),
    (fldPC: fli_rsc;                 fldAS: 'HCDRSC'; fldType: TLD_string),
    (fldPC: fli_MachSetupCode;       fldAS: 'HSETCD'; fldType: TLD_string),
    (fldPC: fli_AlternativCode;      fldAS: 'HALTCD'; fldType: TLD_string),
    (fldPC: fli_prodtype;            fldAS: 'HRECTY'; fldType: TLD_string),
    (fldPC: fli_ProdCode;            fldAS: 'HPRDCD'; fldType: TLD_string),
    (fldPC: fli_netGroupCode;        fldAS: 'HNETCD'; fldType: TLD_string),
    (fldPC: fli_issueCode;           fldAS: 'HISSCD'; fldType: TLD_string),
    (fldPC: fli_seqIssued;           fldAS: 'HSEQNC'; fldType: TLD_string),
    (fldPC: fli_MatBalance;          fldAS: 'HMATBL'; fldType: TLD_string),
    (fldPC: fli_AllocQty;            fldAS: 'HALCQT'; fldType: TLD_float),
    (fldPC: fli_highDateAlloc;       fldAS: 'HDTMAX'; fldType: TLD_dateTime),
    (fldPC: fli_SearchMatByAlloc;    fldAS: 'HFLALC'; fldType: TLD_string),
    (fldPC: fli_settled;             fldAS: 'HFLSAL'; fldType: TLD_string),
    (fldPC: fli_quantityIssue;       fldAS: 'HISSQT'; fldType: TLD_float),
    (fldPC: fli_reqQuant;            fldAS: 'HREQQT'; fldType: TLD_float),
    (fldPC: fli_CreateDateTimeUTC;      fldAS: '';    fldType: TLD_dateTime),
    (fldPC: fli_CrtOrUpdateDateTimeUTC; fldAS: '';    fldType: TLD_dateTime),
    (fldPC: fli_IDENTIFIER;          fldAS: '';       fldType: TLD_string)
  );
   KeyNumMT = 13;

  fldListSPStruct: array [0..22] of TQryLinkRec = (
    (fldPC: fli_preqNo;           fldAS: 'SPRREQ'; fldType: TLD_string),
    (fldPC: fli_pstepId;          fldAS: 'SPRSTP'; fldType: TLD_integer),
    (fldPC: fli_psubstId;         fldAS: 'SPRSST'; fldType: TLD_integer),
    (fldPC: fli_reprocNo;         fldAS: 'SRPRNB'; fldType: TLD_integer),
    (fldPC: fli_ProgressType;     fldAS: 'SLPRTY'; fldType: TLD_string),
    (fldPC: fli_rsc;              fldAS: 'SCDRSC'; fldType: TLD_string),
    (fldPC: fli_ProgressGroup;    fldAS: 'SPRGRP'; fldType: TLD_integer),
    (fldPC: fli_progrStart;       fldAS: 'SSTRDT'; fldType: TLD_dateTime),
    (fldPC: fli_prgCurrDate;      fldAS: 'SCURDT'; fldType: TLD_dateTime),
    (fldPC: fli_progrEnd;         fldAS: 'SENDDT'; fldType: TLD_dateTime),
    (fldPC: fli_quant;            fldAS: 'SPRQTY'; fldType: TLD_float),
    (fldPC: fli_StartingQty;      fldAS: '';       fldType: TLD_float),
    (fldPC: fli_prgRemTime;       fldAS: 'SRMNTM'; fldType: TLD_float),
    (fldPC: fli_ProgressTypeHost; fldAS: 'SLPRTY'; fldType: TLD_string),
    (fldPC: fli_rscHost;          fldAS: 'SCDRSC'; fldType: TLD_string),
    (fldPC: fli_progrStartHost;   fldAS: 'SSTRDT'; fldType: TLD_dateTime),
    (fldPC: fli_prgCurrDateHost;  fldAS: 'SCURDT'; fldType: TLD_dateTime),
    (fldPC: fli_progrEndHost;     fldAS: 'SENDDT'; fldType: TLD_dateTime),
    (fldPC: fli_quantHost;        fldAS: 'SPRQTY'; fldType: TLD_float),
    (fldPC: fli_prgRemTimeHost;   fldAS: 'SRMNTM'; fldType: TLD_float),
    (fldPC: fli_CreateDateTimeUTC;      fldAS: '';    fldType: TLD_dateTime),
    (fldPC: fli_CrtOrUpdateDateTimeUTC; fldAS: '';    fldType: TLD_dateTime),
    (fldPC: fli_IDENTIFIER;       fldAS: '';       fldType: TLD_string)
  );

   KeyNumSP = 4;
  fldListPDStruct : array [0..66] of TQryLinkRec = (
    (fldPC: fli_preqNo;                 fldAS: 'OPRREQ'; fldType: TLD_string),
    (fldPC: fli_pstepId;                fldAS: 'OPRSTP'; fldType: TLD_integer),
    (fldPC: fli_ToBeSched;              fldAS: 'OTBSCH'; fldType: TLD_string),
    (fldPC: fli_prevStepSched_mqm;      fldAS: 'OPRVST'; fldType: TLD_integer),
    (fldPC: fli_prevStepTrue;           fldAS: 'OPRVSS'; fldType: TLD_integer),
    (fldPC: fli_NextStepSched_Mqm;      fldAS: 'ONXTST'; fldType: TLD_integer),
    (fldPC: fli_NextStepTrue;           fldAS: 'ONXTSS'; fldType: TLD_integer),
    (fldPC: fli_StepType;               fldAS: 'OSTPTP'; fldType: TLD_string),
    (fldPC: fli_MaterialArrivDate;      fldAS: 'OMTADT'; fldType: TLD_dateTime),
    (fldPC: fli_FrcMatDate;             fldAS: 'OFRMTD'; fldType: TLD_string),
    (fldPC: fli_planStart;              fldAS: 'OPLSDT'; fldType: TLD_dateTime),
    (fldPC: fli_LowStartTimeLimit;      fldAS: 'OLSTDT'; fldType: TLD_dateTime),
    (fldPC: fli_FrcLowestDate;          fldAS: 'OFRLWD'; fldType: TLD_string),
    (fldPC: fli_planEnd;                fldAS: 'OPLEDT'; fldType: TLD_dateTime),
    (fldPC: fli_HighEndTimeLimit;       fldAS: 'OHSTDT'; fldType: TLD_dateTime),
    (fldPC: fli_FrcHighestDate;         fldAS: 'OFRHGD'; fldType: TLD_string),
    (fldPC: fli_InitialPlanScheduledDateTime; fldAS: ''; fldType: TLD_dateTime),
    (fldPC: fli_FinalPlanScheduledDateTime;   fldAS: ''; fldType: TLD_dateTime),
    (fldPC: fli_wkCtrCode;              fldAS: 'OPLMAC'; fldType: TLD_string),
    (fldPC: fli_wkcProc;                fldAS: 'OPLMAP'; fldType: TLD_string),
    (fldPC: fli_quantInit;              fldAS: 'OINIQT'; fldType: TLD_float),
    (fldPC: fli_quantFinl;              fldAS: 'OFINQT'; fldType: TLD_float),
    (fldPC: fli_Weight;                 fldAS: 'OWEIGT'; fldType: TLD_float),
    (fldPC: fli_DescUM;                 fldAS: 'OWEIUM'; fldType: TLD_string),
    (fldPC: fli_CalCod;                 fldAS: 'OCDCAL'; fldType: TLD_string),
    (fldPC: fli_SetupTimStep;           fldAS: 'OTOTST'; fldType: TLD_float),
    (fldPC: fli_excTimeStep;            fldAS: 'OTOTET'; fldType: TLD_float),
    (fldPC: fli_NumResPlan;             fldAS: 'ONURSC'; fldType: TLD_float),
    (fldPC: fli_AllowSplit;             fldAS: 'OFLSPL'; fldType: TLD_string),
    (fldPC: fli_StepHandleReProc;       fldAS: 'OFLRPR'; fldType: TLD_string),
    (fldPC: fli_StepPartGenralPlan;     fldAS: 'OGENPL'; fldType: TLD_string),
    (fldPC: fli_StepCanGroup;           fldAS: 'OFLGRP'; fldType: TLD_string),
    (fldPC: fli_ForcedGroupNo;          fldAS: 'OSTPGR'; fldType: TLD_float),
    (fldPC: fli_ConnTypToPrevStepSplit; fldAS: 'OCNTYP'; fldType: TLD_string),
    (fldPC: fli_FrcOverlapp;            fldAS: 'OFRNOL'; fldType: TLD_string),
    (fldPC: fli_StepClosed;             fldAS: 'OSTCLO'; fldType: TLD_string),
    (fldPC: fli_usrCg;                  fldAS: 'OUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;                fldAS: 'ODTOCH'; fldType: TLD_dateTime),
    (fldPC: fli_SchedulByMcm;              fldAS: 'OSCMCM'; fldType: TLD_string),
    (fldPC: fli_SplitFamaly;               fldAS: ''; fldType: TLD_string),
    (fldPC: fli_LearningCurveCode;         fldAS: 'OLRNCV'; fldType: TLD_string),
    (fldPC: fli_LearningCurveType;         fldAS: 'OLRNTP'; fldType: TLD_string),
    (fldPC: fli_OverlapWithOtherSteps;     fldAS: ''; fldType: TLD_string),
    (fldPC: fli_ApprovalDate;              fldAS: 'OAPPDT'; fldType: TLD_dateTime),
    (fldPC: fli_GrpContinueSeq;            fldAS: 'OGRSEQ'; fldType: TLD_dateTime),
    (fldPC: fli_PrevLeadtime_Mqm;          fldAS: ''; fldType: TLD_Float),
    (fldPC: fli_NextLeadtime_Mqm;          fldAS: ''; fldType: TLD_Float),
    (fldPC: fli_PrevLeadTimeBatch_Mqm;     fldAS: ''; fldType: TLD_Float),
    (fldPC: fli_NextLeadTimeBatch_Mqm;     fldAS: ''; fldType: TLD_Float),
	  (fldPC: fli_BatchSizePerStep;          fldAS: 'OBQTJB'; fldType: TLD_string),
    (fldPC: fli_MinBatchSize;              fldAS: 'OMINBQ'; fldType: TLD_Float),
    (fldPC: fli_OptimumBatchSize;          fldAS: 'OOPTBQ'; fldType: TLD_Float),
    (fldPC: fli_MaxBatchSize;              fldAS: 'OMAXBQ'; fldType: TLD_Float),
    (fldPC: fli_SchedulByMqm;              fldAS: ''; fldType: TLD_string),
    (fldPC: fli_prevStepSched_Mcm;         fldAS: ''; fldType: TLD_integer),
    (fldPC: fli_NextStepSched_Mcm;         fldAS: ''; fldType: TLD_integer),
   	(fldPC: fli_PrevLeadTime_Mcm;          fldAS: ''; fldType: TLD_Float),
    (fldPC: fli_NextLeadTime_Mcm;          fldAS: ''; fldType: TLD_Float),
    (fldPC: fli_PrevLeadTimeBatch_Mcm;     fldAS: ''; fldType: TLD_Float),
    (fldPC: fli_NextLeadTimeBatch_Mcm;     fldAS: ''; fldType: TLD_Float),
    (fldPC: fli_NumSubRscComponents;       fldAS: ''; fldType: TLD_integer),
    (fldPC: fli_MaxStartDateAutoSeq;       fldAS: 'OMSDAS'; fldType: TLD_dateTime),
    (fldPC: fli_alternative_Qty;           fldAS: ''; fldType: TLD_float),
    (fldPC: fli_alternative_UM;            fldAS: ''; fldType: TLD_string),
    (fldPC: fli_CreateDateTimeUTC;      fldAS: '';    fldType: TLD_dateTime),
    (fldPC: fli_CrtOrUpdateDateTimeUTC; fldAS: '';    fldType: TLD_dateTime),
    (fldPC: fli_IDENTIFIER;                fldAS: ''; fldType: TLD_string)
  );

   KeyNumPD = 2;
  fldListPHStruct : array [0..22] of TQryLinkRec = (
    (fldPC: fli_preqNo;          fldAS: 'MPRREQ'; fldType: TLD_string),
    (fldPC: fli_HistoriclReq;    fldAS: 'MHSTRQ'; fldType: TLD_string),
    (fldPC: fli_ReqOrigin;       fldAS: 'MRQORG'; fldType: TLD_string),
    (fldPC: fli_ProdLine;        fldAS: 'MPRDLN'; fldType: TLD_string),
    (fldPC: fli_ProdType;        fldAS: 'MRECTY'; fldType: TLD_string),
    (fldPC: fli_ProdFamily;      fldAS: 'MPRDFM'; fldType: TLD_string),
    (fldPC: fli_MaterialFamily;  fldAS: 'MMTRFM'; fldType: TLD_string),
    (fldPC: fli_ProdUMCode;      fldAS: 'MPRDUM'; fldType: TLD_string),
    (fldPC: fli_ProdLowDataTime; fldAS: 'MPRLDT'; fldType: TLD_dateTime),
    (fldPC: fli_ProdDelivDate;   fldAS: 'MPRDDT'; fldType: TLD_dateTime),
    (fldPC: fli_FrcDelDate;      fldAS: 'MFRDDT'; fldType: TLD_string),
    (fldPC: fli_usrCg;           fldAS: 'MUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;         fldAS: 'MDTOCH'; fldType: TLD_dateTime),
    (fldPC: fli_ModulHandled;            fldAS: 'MMODUL'; fldType: TLD_string),
    (fldPC: fli_SplitConfLevels;         fldAS: ''; fldType: TLD_string),
    (fldPC: fli_LeadpstepIdForSplit;     fldAS: ''; fldType: TLD_Integer),
    (fldPC: fli_NewPreqUniqId;           fldAS: ''; fldType: TLD_string),
    (fldPC: fli_Serving_Code;            fldAS: 'MSRVCD'; fldType: TLD_string),
    (fldPC: fli_Served_Code;             fldAS: 'MSRBCD'; fldType: TLD_string),
    (fldPC: fli_CurveFamilyIdCode;       fldAS: '';       fldType: TLD_string),
    (fldPC: fli_CreateDateTimeUTC;      fldAS: '';    fldType: TLD_dateTime),
    (fldPC: fli_CrtOrUpdateDateTimeUTC; fldAS: '';    fldType: TLD_dateTime),
    (fldPC: fli_IDENTIFIER;              fldAS: '';       fldType: TLD_string)
  );
   KeyNumPH = 1;

    fldListPRStruct : array [0..9] of TQryLinkRec = (
    (fldPC: fli_preqNo;         fldAS: 'KPRREQ'; fldType: TLD_string),
    (fldPC: fli_divCode;        fldAS: 'KCDDIV'; fldType: TLD_string),
    (fldPC: fli_dispoCode;      fldAS: 'KCDDIS'; fldType: TLD_string),
    (fldPC: fli_bch;            fldAS: 'KNRLOT'; fldType: TLD_string),
    (fldPC: fli_reprocNo;       fldAS: 'KNRLOR'; fldType: TLD_integer),
    (fldPC: fli_HistoriclReq;   fldAS: 'KHSTRQ'; fldType: TLD_string),
    (fldPC: fli_usrCg;          fldAS: 'KUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;        fldAS: 'KDTOCH'; fldType: TLD_DateTime),
    (fldPC: fli_ModulHandled;   fldAS: 'KMODUL'; fldType: TLD_string),
    (fldPC: fli_IDENTIFIER;     fldAS: '';       fldType: TLD_string)
  );
   KeyNumPR = 1;

  fldListPPStruct : array [0..7] of TQryLinkRec = (
    (fldPC: fli_preqNo;       fldAS: 'LPRREQ'; fldType: TLD_string),
    (fldPC: fli_pstepId;      fldAS: 'LPRSTP'; fldType: TLD_integer),
    (fldPC: fli_PropertyCode; fldAS: 'LCDPPT'; fldType: TLD_string),
    (fldPC: fli_rsc;          fldAS: 'LPRRSC'; fldType: TLD_string),
    (fldPC: fli_PropValue;    fldAS: 'LPPTVL'; fldType: TLD_string),
    (fldPC: fli_CreateDateTimeUTC;      fldAS: '';    fldType: TLD_dateTime),
    (fldPC: fli_CrtOrUpdateDateTimeUTC; fldAS: '';    fldType: TLD_dateTime),
    (fldPC: fli_IDENTIFIER;     fldAS: '';       fldType: TLD_string)
  );
   KeyNumPP = 4;

begin
  Result := false;
  WcRecEntered := false;
  J := 0;
  DndArchiveLocalName := GetDndArchiveLocalName;
  DndArchiveHostName  := GetDndArchiveHostName;

  MqmTrs := ThreadCreateTransaction(Main_DB);
  Temp_TimeVal := NOW;
  IsClientOpen := ClearChangeReqWcTables;
  IniAppGlobals.Time_ClearChangeReqWcTables := IniAppGlobals.Time_ClearChangeReqWcTables + (NOW - Temp_TimeVal);

//  srvTrs := CreateTransaction(Main_DB);
//  srvTrs.StartTransaction;

  QryInsertPR := ThreadCreateQuery(Main_DB);
  QryInsertPR.Transaction := MqmTrs;
//  QryInsertPR.Transaction.StartTransaction;

  QryInsertPH := ThreadCreateQuery(Main_DB);
  QryInsertPH.Transaction := MqmTrs;
//  QryInsertPH.Transaction.StartTransaction;

  QryInsertPD := ThreadCreateQuery(Main_DB);
  QryInsertPD.Transaction := MqmTrs;
//  QryInsertPD.Transaction.StartTransaction;

  QryInsertPP := ThreadCreateQuery(Main_DB);
  QryInsertPP.Transaction := MqmTrs;
//  QryInsertPP.Transaction.StartTransaction;

  QryInsertPI := ThreadCreateQuery(Main_DB);
  QryInsertPI.Transaction := MqmTrs;
  //QryInsertPI.Transaction.StartTransaction;

  QryInsertEC := ThreadCreateQuery(Main_DB);
  QryInsertEC.Transaction := MqmTrs;
//  QryInsertEC.Transaction.StartTransaction;

  QryInsertIC := ThreadCreateQuery(Main_DB);
  QryInsertIC.Transaction := MqmTrs;
//  QryInsertIC.Transaction.StartTransaction;

  QryInsertSB := ThreadCreateQuery(Main_DB);
  QryInsertSB.Transaction := MqmTrs;
//  QryInsertSB.Transaction.StartTransaction;

  QryInsertSP := ThreadCreateQuery(Main_DB);
  QryInsertSP.Transaction := MqmTrs;
//  QryInsertSP.Transaction.StartTransaction;

  QryInsertST := ThreadCreateQuery(Main_DB);
  QryInsertST.Transaction := MqmTrs;
//  QryInsertST.Transaction.StartTransaction;

  QryInsertMT := ThreadCreateQuery(Main_DB);
  QryInsertMT.Transaction := MqmTrs;
//  QryInsertMT.Transaction.StartTransaction;

  QryInsertPA := ThreadCreateQuery(Main_DB);
  QryInsertPA.Transaction := MqmTrs;
//  QryInsertPA.Transaction.StartTransaction;

  QryInsertCR := ThreadCreateQuery(Main_DB);
  QryInsertCR.Transaction := MqmTrs;
  tblInf := @tblInfo[tbl_Req_Change];
  QryInsertCR.SQL.Add('insert into ' + tblInf.GetTableName        + '(');
  QryInsertCR.SQL.Add(CreateFld(tblInf.pfx, fli_IDENTIFIER)       + ',');
  QryInsertCR.SQL.Add(CreateFld(tblInf.pfx, fli_preqNo)           + ',');
  QryInsertCR.SQL.Add(CreateFld(tblInf.pfx, fli_pstepId)          + ',');
  QryInsertCR.SQL.Add(CreateFld(tblInf.pfx, fli_updCode)          + ',');
  QryInsertCR.SQL.Add(CreateFld(tblInf.pfx, fli_ChangeType)       + ',');
  QryInsertCR.SQL.Add(CreateFld(tblInf.pfx, fli_ReactivateReq));
  QryInsertCR.SQL.Add(') values (');
  QryInsertCR.SQL.Add(':' + CreateFld(tblInf.pfx, fli_IDENTIFIER) + ',');
  QryInsertCR.SQL.Add(':' + CreateFld(tblInf.pfx, fli_preqNo)     + ',');
  QryInsertCR.SQL.Add(':' + CreateFld(tblInf.pfx, fli_pstepId)    + ',');
  QryInsertCR.SQL.Add(':' + CreateFld(tblInf.pfx, fli_updCode)    + ',');
  QryInsertCR.SQL.Add(':' + CreateFld(tblInf.pfx, fli_ChangeType) + ',');
  QryInsertCR.SQL.Add(':' + CreateFld(tblInf.pfx, fli_ReactivateReq));
  QryInsertCR.SQL.Add(')');

  QryTmp  := ThreadCreateQuery(Main_DB);
  QryTmp.Transaction := MqmTrs;
//  QryTmp.Transaction.StartTransaction;

  InsertTable(tbl_prod_req,fldListPRStruct,QryInsertPR);
  QryInsertPR.SQL.Add(
    ':PR_PREQ_NO, :PR_DIV_CODE, :PR_DSP_CODE, :PR_BCH_CODE, :PR_REPROC_NO, ' +
    ':PR_HISTORICAL_REQ, :PR_USR_NAMECG, :PR_USR_TIMECG, :PR_MODULEHANDLE, :PR_IDENTIFIER)');

  BuildSql(tbl_prod_req, fldListPRStruct, KeyNumPR, SqlUpdate, SqlDel);
  QryUpdatePR := ThreadCreateQuery(Main_DB);
  QryUpdatePR.Transaction := MqmTrs;
  QryUpdatePR.SQL.Add(
    'update ' + tblInfo[tbl_prod_req].GetTableName + ' set ' +
    '"PR_DIV_CODE"=:PR_DIV_CODE, "PR_DSP_CODE"=:PR_DSP_CODE, "PR_BCH_CODE"=:PR_BCH_CODE, ' +
    '"PR_REPROC_NO"=:PR_REPROC_NO, "PR_HISTORICAL_REQ"=:PR_HISTORICAL_REQ, ' +
    '"PR_USR_NAMECG"=:PR_USR_NAMECG, "PR_USR_TIMECG"=:PR_USR_TIMECG, ' +
    '"PR_MODULEHANDLE"=:PR_MODULEHANDLE ' +
    'WHERE "PR_PREQ_NO"=:PR_PREQ_NO' +
    AND_IDF_Condition(CreateFld(tblInfo[tbl_prod_req].pfx, fli_IDENTIFIER)));

  QryDelPR := ThreadCreateQuery(Main_DB);
  QryDelPR.Transaction := MqmTrs;
  QryDelPR.SQL.Add(SqlDel);

  InsertTable(tbl_prod_reqHdr,fldListPHStruct,QryInsertPH);
  QryInsertPH.SQL.Add(
    ':PH_PREQ_NO, :PH_HISTORICAL_REQ, :PH_REQ_ORIGIN, :PH_PROD_LINE, :PH_TYPE_PROD, ' +
    ':PH_PROD_FAMILY, :PH_MATERIAL_FAMILY, :PH_PROD_UM, :PH_PROD_LOW_TIME_STRT, ' +
    ':PH_PROD_DELIVY_DATE, :PH_FRC_DEL_DATE, :PH_USR_NAMECG, :PH_USR_TIMECG, ' +
    ':PH_MODULEHANDLE, :PH_SPLITCONFLEVELS, :PH_LEAD_STEP_SPLITED, :PH_NEW_PREQ_UNIQ_ID, ' +
    ':PH_SERVING_CODE, :PH_SERVED_CODE, :PH_CURVE_FAMILY_ID_CODE, ' +
    ':PH_CREATE_DATE_TIME_UTC, :PH_UPDATED_DATE_TIME_UTC, :PH_IDENTIFIER)');

  BuildSql(tbl_prod_reqHdr, fldListPH, KeyNumPH, SqlUpdate, SqlDel);
  QryUpdatePH := ThreadCreateQuery(Main_DB);
  QryUpdatePH.Transaction := MqmTrs;
  QryUpdatePH.SQL.Add(
    'update ' + tblInfo[tbl_prod_reqHdr].GetTableName + ' set ' +
    '"PH_HISTORICAL_REQ"=:PH_HISTORICAL_REQ, "PH_REQ_ORIGIN"=:PH_REQ_ORIGIN, ' +
    '"PH_PROD_LINE"=:PH_PROD_LINE, "PH_TYPE_PROD"=:PH_TYPE_PROD, ' +
    '"PH_PROD_FAMILY"=:PH_PROD_FAMILY, "PH_MATERIAL_FAMILY"=:PH_MATERIAL_FAMILY, ' +
    '"PH_PROD_UM"=:PH_PROD_UM, "PH_PROD_LOW_TIME_STRT"=:PH_PROD_LOW_TIME_STRT, ' +
    '"PH_PROD_DELIVY_DATE"=:PH_PROD_DELIVY_DATE, "PH_FRC_DEL_DATE"=:PH_FRC_DEL_DATE, ' +
    '"PH_USR_NAMECG"=:PH_USR_NAMECG, "PH_USR_TIMECG"=:PH_USR_TIMECG, ' +
    '"PH_MODULEHANDLE"=:PH_MODULEHANDLE, "PH_SPLITCONFLEVELS"=:PH_SPLITCONFLEVELS, ' +
    '"PH_LEAD_STEP_SPLITED"=:PH_LEAD_STEP_SPLITED, "PH_NEW_PREQ_UNIQ_ID"=:PH_NEW_PREQ_UNIQ_ID, ' +
    '"PH_SERVING_CODE"=:PH_SERVING_CODE, "PH_SERVED_CODE"=:PH_SERVED_CODE, ' +
    '"PH_CURVE_FAMILY_ID_CODE"=:PH_CURVE_FAMILY_ID_CODE, ' +
    '"PH_UPDATED_DATE_TIME_UTC"=:PH_UPDATED_DATE_TIME_UTC ' +
    'WHERE "PH_PREQ_NO"=:PH_PREQ_NO' +
    AND_IDF_Condition(CreateFld(tblInfo[tbl_prod_reqHdr].pfx, fli_IDENTIFIER)));

  QryDelPH := ThreadCreateQuery(Main_DB);
  QryDelPH.Transaction := MqmTrs;
  QryDelPH.SQL.Add(SqlDel);

  // PD INSERT — build parameterized SQL once, prepare once before loop
  InsertTable(tbl_Prod_step, fldListPDStruct, QryInsertPD);
  QryInsertPD.SQL.Add(
    ':PD_PREQ_NO, :PD_PSTEP_ID, :PD_TO_SCHED, :PD_PRV_STEP_SCHED_MQM, ' +
    ':PD_PRV_STEP_TRUE, :PD_NEX_STEP_SCHED_MQM, :PD_NEX_STEP_TRUE, :PD_STEP_TYP, ' +
    ':PD_MAT_ARRV_DATE, :PD_FRC_MAT_DATE, :PD_PLAN_START, :PD_LOW_LIMIT_TIME_STRT, ' +
    ':PD_FRC_LOW_DATE, :PD_PLAN_END, :PD_HIGH_LIMIT_TIMEND, :PD_FRC_HIGH_DATE, ' +
    ':PD_INI_PLAN_SCHED_DATE_TIME, :PD_FIN_PLAN_SCHED_DATE_TIME, ' +
    ':PD_WKCNTER, :PD_WKCT_PROC, :PD_INIT_QUENT, :PD_FIN_QUENT, :PD_WEIGHT, ' +
    ':PD_DESC_UM, :PD_CAL, :PD_SETUP_TIME_STP, :PD_EXC_TIME_STP, :PD_RES_NUM_PLN, ' +
    ':PD_ALLOW_SPLIT, :PD_STEP_HANDLE_REPROCES, :PD_STEP_PART_GEN_PLAN, :PD_STEP_CAN_GROUP, ' +
    ':PD_FORCED_GRP_NO, :PD_CONN_TYPE_PREV_STEP_SPLIT, :PD_FRC_OVERLAPP, :PD_STEP_CLOSED, ' +
    ':PD_USR_NAMECG, :PD_USR_TIMECG, :PD_SCHDULE_BY_MCM, :PD_SPLITED_FAMILY, ' +
    ':PD_LEARNING_CURVE_CODE, :PD_LEARNING_CURVE_TYPE, :PD_OVERLAP_WITH_OTHER_STEPS, ' +
    ':PD_APPROVAL_DATE, :PD_GRP_SEQUENCE, ' +
    ':PD_PREV_LEAD_TIME_MQM, :PD_NEXT_LEAD_TIME_MQM, ' +
    ':PD_PREV_LEAD_TIME_BATCH_MQM, :PD_NEXT_LEAD_TIME_BATCH_MQM, ' +
    ':PD_BATCH_SIZE_PER_STEP, :PD_MIN_BATCH_SIZE, :PD_OPTIMUM_BATCH_SIZE, :PD_MAX_BATCH_SIZE, ' +
    ':PD_SCHDULE_BY_MQM, :PD_PRV_STEP_SCHED_MCM, :PD_NEX_STEP_SCHED_MCM, ' +
    ':PD_PREV_LEAD_TIME_MCM, :PD_NEXT_LEAD_TIME_MCM, ' +
    ':PD_PREV_LEAD_TIME_BATCH_MCM, :PD_NEXT_LEAD_TIME_BATCH_MCM, ' +
    ':PD_NUM_RSC_COMPONENTS, :PD_MAX_STARTDATE_AUTOSEQ, ' +
    ':PD_ALTERNATIVEQTY, :PD_ALTERNATIVEUM, ' +
    ':PD_CREATE_DATE_TIME_UTC, :PD_UPDATED_DATE_TIME_UTC, :PD_IDENTIFIER)');

  // PD UPDATE — build parameterized SQL once, prepare once before loop
  BuildSql(tbl_Prod_Step, fldListPD, KeyNumPD, SqlUpdate, SqlDel);
  QryUpdatePD := ThreadCreateQuery(Main_DB);
  QryUpdatePD.Transaction := MqmTrs;
  QryUpdatePD.SQL.Add(
    'update ' + tblInfo[tbl_Prod_Step].GetTableName + ' set ' +
    '"PD_TO_SCHED"=:PD_TO_SCHED, "PD_PRV_STEP_SCHED_MQM"=:PD_PRV_STEP_SCHED_MQM, ' +
    '"PD_PRV_STEP_TRUE"=:PD_PRV_STEP_TRUE, "PD_NEX_STEP_SCHED_MQM"=:PD_NEX_STEP_SCHED_MQM, ' +
    '"PD_NEX_STEP_TRUE"=:PD_NEX_STEP_TRUE, "PD_STEP_TYP"=:PD_STEP_TYP, ' +
    '"PD_MAT_ARRV_DATE"=:PD_MAT_ARRV_DATE, "PD_FRC_MAT_DATE"=:PD_FRC_MAT_DATE, ' +
    '"PD_PLAN_START"=:PD_PLAN_START, "PD_LOW_LIMIT_TIME_STRT"=:PD_LOW_LIMIT_TIME_STRT, ' +
    '"PD_FRC_LOW_DATE"=:PD_FRC_LOW_DATE, "PD_PLAN_END"=:PD_PLAN_END, ' +
    '"PD_HIGH_LIMIT_TIMEND"=:PD_HIGH_LIMIT_TIMEND, "PD_FRC_HIGH_DATE"=:PD_FRC_HIGH_DATE, ' +
    '"PD_INI_PLAN_SCHED_DATE_TIME"=:PD_INI_PLAN_SCHED_DATE_TIME, ' +
    '"PD_FIN_PLAN_SCHED_DATE_TIME"=:PD_FIN_PLAN_SCHED_DATE_TIME, ' +
    '"PD_WKCNTER"=:PD_WKCNTER, "PD_WKCT_PROC"=:PD_WKCT_PROC, ' +
    '"PD_INIT_QUENT"=:PD_INIT_QUENT, "PD_FIN_QUENT"=:PD_FIN_QUENT, "PD_WEIGHT"=:PD_WEIGHT, ' +
    '"PD_DESC_UM"=:PD_DESC_UM, "PD_CAL"=:PD_CAL, ' +
    '"PD_SETUP_TIME_STP"=:PD_SETUP_TIME_STP, "PD_EXC_TIME_STP"=:PD_EXC_TIME_STP, ' +
    '"PD_RES_NUM_PLN"=:PD_RES_NUM_PLN, "PD_NUM_RSC_COMPONENTS"=:PD_NUM_RSC_COMPONENTS, ' +
    '"PD_ALLOW_SPLIT"=:PD_ALLOW_SPLIT, "PD_STEP_HANDLE_REPROCES"=:PD_STEP_HANDLE_REPROCES, ' +
    '"PD_STEP_PART_GEN_PLAN"=:PD_STEP_PART_GEN_PLAN, "PD_STEP_CAN_GROUP"=:PD_STEP_CAN_GROUP, ' +
    '"PD_FORCED_GRP_NO"=:PD_FORCED_GRP_NO, ' +
    '"PD_CONN_TYPE_PREV_STEP_SPLIT"=:PD_CONN_TYPE_PREV_STEP_SPLIT, ' +
    '"PD_FRC_OVERLAPP"=:PD_FRC_OVERLAPP, "PD_STEP_CLOSED"=:PD_STEP_CLOSED, ' +
    '"PD_USR_NAMECG"=:PD_USR_NAMECG, "PD_USR_TIMECG"=:PD_USR_TIMECG, ' +
    '"PD_SCHDULE_BY_MCM"=:PD_SCHDULE_BY_MCM, "PD_SCHDULE_BY_MQM"=:PD_SCHDULE_BY_MQM, ' +
    '"PD_PREV_LEAD_TIME_MQM"=:PD_PREV_LEAD_TIME_MQM, ' +
    '"PD_NEXT_LEAD_TIME_MQM"=:PD_NEXT_LEAD_TIME_MQM, ' +
    '"PD_PREV_LEAD_TIME_BATCH_MQM"=:PD_PREV_LEAD_TIME_BATCH_MQM, ' +
    '"PD_NEXT_LEAD_TIME_BATCH_MQM"=:PD_NEXT_LEAD_TIME_BATCH_MQM, ' +
    '"PD_PRV_STEP_SCHED_MCM"=:PD_PRV_STEP_SCHED_MCM, "PD_NEX_STEP_SCHED_MCM"=:PD_NEX_STEP_SCHED_MCM, ' +
    '"PD_PREV_LEAD_TIME_MCM"=:PD_PREV_LEAD_TIME_MCM, "PD_NEXT_LEAD_TIME_MCM"=:PD_NEXT_LEAD_TIME_MCM, ' +
    '"PD_PREV_LEAD_TIME_BATCH_MCM"=:PD_PREV_LEAD_TIME_BATCH_MCM, ' +
    '"PD_NEXT_LEAD_TIME_BATCH_MCM"=:PD_NEXT_LEAD_TIME_BATCH_MCM, ' +
    '"PD_APPROVAL_DATE"=:PD_APPROVAL_DATE, "PD_GRP_SEQUENCE"=:PD_GRP_SEQUENCE, ' +
    '"PD_LEARNING_CURVE_CODE"=:PD_LEARNING_CURVE_CODE, ' +
    '"PD_LEARNING_CURVE_TYPE"=:PD_LEARNING_CURVE_TYPE, ' +
    '"PD_BATCH_SIZE_PER_STEP"=:PD_BATCH_SIZE_PER_STEP, ' +
    '"PD_MIN_BATCH_SIZE"=:PD_MIN_BATCH_SIZE, "PD_OPTIMUM_BATCH_SIZE"=:PD_OPTIMUM_BATCH_SIZE, ' +
    '"PD_MAX_BATCH_SIZE"=:PD_MAX_BATCH_SIZE, "PD_MAX_STARTDATE_AUTOSEQ"=:PD_MAX_STARTDATE_AUTOSEQ, ' +
    '"PD_ALTERNATIVEQTY"=:PD_ALTERNATIVEQTY, "PD_ALTERNATIVEUM"=:PD_ALTERNATIVEUM, ' +
    '"PD_SPLITED_FAMILY"=:PD_SPLITED_FAMILY, ' +
    '"PD_OVERLAP_WITH_OTHER_STEPS"=:PD_OVERLAP_WITH_OTHER_STEPS, ' +
    '"PD_UPDATED_DATE_TIME_UTC"=:PD_UPDATED_DATE_TIME_UTC ' +
    'WHERE "PD_PREQ_NO"=:PD_PREQ_NO AND "PD_PSTEP_ID"=:PD_PSTEP_ID' +
    AND_IDF_Condition(CreateFld('PD_', fli_IDENTIFIER)));

  QryDelPD := ThreadCreateQuery(Main_DB);
  QryDelPD.Transaction := MqmTrs;
  QryDelPD.SQL.Add(SqlDel);

  InsertTable(tbl_prop_prod,fldListPPStruct,QryInsertPP);
  QryInsertPP.SQL.Add(':Preq, :id, :Prop, :c, :Value, :CrtUTC, :UpdUTC, :identifier)');

  BuildSql(tbl_prop_prod, fldListPP, KeyNumPP, SqlUpdate, SqlDel);
  QryUpdatePP := ThreadCreateQuery(Main_DB);
  QryUpdatePP.Transaction := MqmTrs;
  QryUpdatePP.SQL.Text :=
    'update ' + tblInfo[tbl_prop_prod].GetTableName + ' set ' +
    ' PP_VALUE = :Value , ' +
    ' PP_UPDATED_DATE_TIME_UTC = :UpdUtc' +
    ' where PP_PREQ_NO = :PREQ and PP_PSTEP_ID = :id and PP_PROPERTY = :Prop and pp_identifier = :identifier';

  QryDelPP := ThreadCreateQuery(Main_DB);
  QryDelPP.Transaction := MqmTrs;
  QryDelPP.SQL.Add(SqlDel);

  InsertTable(tbl_prod_info,fldListPIStruct,QryInsertPI);
  QryInsertPI.SQL.Add(
    ':PI_PREQ_NO, :PI_PSTEP_ID, :PI_INFO_TYPE, :PI_INFO_LINE_NUM, ' +
    ':PI_INFO_AREA, :PI_USR_NAMECG, :PI_USR_TIMECG, :PI_IDENTIFIER)');

  BuildSql(tbl_prod_info, fldListPI, KeyNumPI, SqlUpdate, SqlDel);
  QryUpdatePI := ThreadCreateQuery(Main_DB);
  QryUpdatePI.Transaction := MqmTrs;
  QryUpdatePI.SQL.Add(
    'update ' + tblInfo[tbl_prod_info].GetTableName + ' set ' +
    '"PI_INFO_AREA"=:PI_INFO_AREA ' +
    'WHERE "PI_PREQ_NO"=:PI_PREQ_NO AND "PI_INFO_TYPE"=:PI_INFO_TYPE AND ' +
    '"PI_PSTEP_ID"=:PI_PSTEP_ID AND "PI_INFO_LINE_NUM"=:PI_INFO_LINE_NUM' +
    AND_IDF_Condition(CreateFld(tblInfo[tbl_prod_info].pfx, fli_IDENTIFIER)));

  QryDelPI := ThreadCreateQuery(Main_DB);
  QryDelPI.Transaction := MqmTrs;
  QryDelPI.SQL.Add(SqlDel);

  InsertTable(tbl_ext_connection,fldListECStruct,QryInsertEC);
  QryInsertEC.SQL.Add(
    ':EC_PREQ_NO, :EC_CONNE_KEY, :EC_NUM_LEVELS, :EC_CONN_CERTENT_LEVEL, ' +
    ':EC_USR_NAMECG, :EC_USR_TIMECG, :EC_IDENTIFIER)');

  BuildSql(tbl_ext_connection, fldListEC, KeyNumEC, SqlUpdate, SqlDel);
  QryUpdateEC := ThreadCreateQuery(Main_DB);
  QryUpdateEC.Transaction := MqmTrs;
  QryUpdateEC.SQL.Add(
    'update ' + tblInfo[tbl_ext_connection].GetTableName + ' set ' +
    '"EC_NUM_LEVELS"=:EC_NUM_LEVELS, "EC_USR_NAMECG"=:EC_USR_NAMECG, ' +
    '"EC_USR_TIMECG"=:EC_USR_TIMECG ' +
    'WHERE "EC_PREQ_NO"=:EC_PREQ_NO AND "EC_CONNE_KEY"=:EC_CONNE_KEY' +
    AND_IDF_Condition(CreateFld(tblInfo[tbl_ext_connection].pfx, fli_IDENTIFIER)));
  QryDelEC := ThreadCreateQuery(Main_DB);
  QryDelEC.Transaction := MqmTrs;
  QryDelEC.SQL.Add(SqlDel);

  InsertTable(tbl_prod_reqConnection,fldListICStruct,QryInsertIC);
  QryInsertIC.SQL.Add(
    ':IC_PREQ_NO, :IC_PREV_PREQ_NO, :IC_USR_NAMECG, :IC_USR_TIMECG, ' +
    ':IC_CREATE_DATE_TIME_UTC, :IC_UPDATED_DATE_TIME_UTC, :IC_IDENTIFIER)');
  BuildSql(tbl_prod_reqConnection, fldListIC, KeyNumIC, SqlUpdate, SqlDel);
  QryUpdateIC := ThreadCreateQuery(Main_DB);
  QryUpdateIC.Transaction := MqmTrs;
  QryUpdateIC.SQL.Add(
    'update ' + tblInfo[tbl_prod_reqConnection].GetTableName + ' set ' +
    '"IC_UPDATED_DATE_TIME_UTC"=:IC_UPDATED_DATE_TIME_UTC, ' +
    '"IC_USR_NAMECG"=:IC_USR_NAMECG ' +
    'WHERE "IC_PREQ_NO"=:IC_PREQ_NO AND "IC_PREV_PREQ_NO"=:IC_PREV_PREQ_NO' +
    AND_IDF_Condition(CreateFld(tblInfo[tbl_prod_reqConnection].pfx, fli_IDENTIFIER)));
  QryDelIC := ThreadCreateQuery(Main_DB);
  QryDelIC.Transaction := MqmTrs;
  QryDelIC.SQL.Add(SqlDel);

  InsertTable(tbl_step_batchSize,fldListSBStruct,QryInsertSB);
  QryInsertSB.SQL.Add(
    ':SB_PREQ_NO, :SB_PSTEP_ID, :SB_BCH_UM, :SB_MULTIPILR_TO_BATCH_UM, ' +
    ':SB_CREATE_DATE_TIME_UTC, :SB_UPDATED_DATE_TIME_UTC, :SB_IDENTIFIER)');
  BuildSql(tbl_step_batchSize, fldListSB, KeyNumSB, SqlUpdate, SqlDel);
  QryUpdateSB := ThreadCreateQuery(Main_DB);
  QryUpdateSB.Transaction := MqmTrs;
  QryUpdateSB.SQL.Add(
    'update ' + tblInfo[tbl_step_batchSize].GetTableName + ' set ' +
    '"SB_MULTIPILR_TO_BATCH_UM"=:SB_MULTIPILR_TO_BATCH_UM, ' +
    '"SB_UPDATED_DATE_TIME_UTC"=:SB_UPDATED_DATE_TIME_UTC ' +
    'WHERE "SB_PREQ_NO"=:SB_PREQ_NO AND "SB_PSTEP_ID"=:SB_PSTEP_ID AND "SB_BCH_UM"=:SB_BCH_UM' +
    AND_IDF_Condition(CreateFld(tblInfo[tbl_step_batchSize].pfx, fli_IDENTIFIER)));
  QryDelSB := ThreadCreateQuery(Main_DB);
  QryDelSB.Transaction := MqmTrs;
  QryDelSB.SQL.Add(SqlDel);

  InsertTable(tbl_sched_progress,fldListSPStruct,QryInsertSP);
  QryInsertSP.SQL.Add(
    ':SP_PREQ_NO, :SP_PSTEP_ID, :SP_PSUBST_ID, :SP_REPROC_NO, ' +
    ':SP_LAST_PROG_TYPE, :SP_RSC_CODE, :SP_PROGRESED_GROUP, ' +
    ':SP_PROGRSTART, :SP_CURR_PRG_DATE, :SP_PROGREND, ' +
    ':SP_QTY, :SP_START_QTY, :SP_REMAIN_TIME, ' +
    ':SP_LAST_PROG_TYPE_HOST, :SP_RSC_CODE_HOST, ' +
    ':SP_PROGRSTART_HOST, :SP_CURR_PRG_DATE_HOST, :SP_PROGREND_HOST, ' +
    ':SP_QTY_HOST, :SP_REMAIN_TIME_HOST, ' +
    ':SP_CREATE_DATE_TIME_UTC, :SP_UPDATED_DATE_TIME_UTC, :SP_IDENTIFIER)');
  BuildSql(tbl_sched_progress, fldListSP, KeyNumSP, SqlUpdate, SqlDel);
  QryUpdateSP := ThreadCreateQuery(Main_DB);
  QryUpdateSP.Transaction := MqmTrs;
  QryUpdateSP.SQL.Add(
    'update ' + tblInfo[tbl_sched_progress].GetTableName + ' set ' +
    '"SP_LAST_PROG_TYPE"=:SP_LAST_PROG_TYPE, "SP_RSC_CODE"=:SP_RSC_CODE, ' +
    '"SP_PROGRESED_GROUP"=:SP_PROGRESED_GROUP, ' +
    '"SP_PROGRSTART"=:SP_PROGRSTART, "SP_CURR_PRG_DATE"=:SP_CURR_PRG_DATE, ' +
    '"SP_PROGREND"=:SP_PROGREND, "SP_QTY"=:SP_QTY, "SP_START_QTY"=:SP_START_QTY, ' +
    '"SP_REMAIN_TIME"=:SP_REMAIN_TIME, ' +
    '"SP_LAST_PROG_TYPE_HOST"=:SP_LAST_PROG_TYPE_HOST, ' +
    '"SP_RSC_CODE_HOST"=:SP_RSC_CODE_HOST, ' +
    '"SP_PROGRSTART_HOST"=:SP_PROGRSTART_HOST, ' +
    '"SP_CURR_PRG_DATE_HOST"=:SP_CURR_PRG_DATE_HOST, ' +
    '"SP_PROGREND_HOST"=:SP_PROGREND_HOST, ' +
    '"SP_QTY_HOST"=:SP_QTY_HOST, "SP_REMAIN_TIME_HOST"=:SP_REMAIN_TIME_HOST, ' +
    '"SP_UPDATED_DATE_TIME_UTC"=:SP_UPDATED_DATE_TIME_UTC ' +
    'WHERE "SP_PREQ_NO"=:SP_PREQ_NO AND "SP_PSTEP_ID"=:SP_PSTEP_ID AND ' +
    '"SP_PSUBST_ID"=:SP_PSUBST_ID AND "SP_REPROC_NO"=:SP_REPROC_NO' +
    AND_IDF_Condition(CreateFld(tblInfo[tbl_sched_progress].pfx, fli_IDENTIFIER)));
  QryDelSP := ThreadCreateQuery(Main_DB);
  QryDelSP.Transaction := MqmTrs;
  QryDelSP.SQL.Add(SqlDel);

  InsertTable(tbl_step_times,fldListSTStruct,QryInsertST);
  QryInsertST.SQL.Add(
    ':ST_PREQ_NO, :ST_PSTEP_ID, :ST_WKCNTER, :ST_WKCT_PROC, ' +
    ':ST_RES_CATEGORY, :ST_RSC_CODE, :ST_MACHINE_SETUP_CODE, ' +
    ':ST_SETUP_TIME_JOB, :ST_EXC_TIME_INIT_QTY, ' +
    ':ST_CREATE_DATE_TIME_UTC, :ST_UPDATED_DATE_TIME_UTC, :ST_IDENTIFIER)');
  BuildSql(tbl_step_times, fldListST, KeyNumST, SqlUpdate, SqlDel);
  QryUpdateST := ThreadCreateQuery(Main_DB);
  QryUpdateST.Transaction := MqmTrs;
  QryUpdateST.SQL.Add(
    'update ' + tblInfo[tbl_step_times].GetTableName + ' set ' +
    '"ST_EXC_TIME_INIT_QTY"=:ST_EXC_TIME_INIT_QTY, ' +
    '"ST_SETUP_TIME_JOB"=:ST_SETUP_TIME_JOB, ' +
    '"ST_UPDATED_DATE_TIME_UTC"=:ST_UPDATED_DATE_TIME_UTC ' +
    'WHERE "ST_PREQ_NO"=:ST_PREQ_NO AND "ST_PSTEP_ID"=:ST_PSTEP_ID AND ' +
    '"ST_WKCNTER"=:ST_WKCNTER AND "ST_WKCT_PROC"=:ST_WKCT_PROC AND ' +
    '"ST_RES_CATEGORY"=:ST_RES_CATEGORY AND "ST_RSC_CODE"=:ST_RSC_CODE AND ' +
    '"ST_MACHINE_SETUP_CODE"=:ST_MACHINE_SETUP_CODE' +
    AND_IDF_Condition(CreateFld(tblInfo[tbl_step_times].pfx, fli_IDENTIFIER)));
  QryDelST := ThreadCreateQuery(Main_DB);
  QryDelST.Transaction := MqmTrs;
  QryDelST.SQL.Add(SqlDel);

  InsertTable(tbl_Material,fldListMTStruct,QryInsertMT);
  QryInsertMT.SQL.Add(
    ':MT_PREQ_NO, :MT_PSTEP_ID, :MT_ORG_STEP, :MT_WKCNTER, :MT_RES_CAT_CODE, ' +
    ':MT_RSC_CODE, :MT_MACHINE_SETUP_CODE, :MT_ALTERNATIVE_CODE, :MT_TYPE_PROD, ' +
    ':MT_PRODUCT_CODE, :MT_NET_GROUP_CODE, :MT_ISSUE_CODE, :MT_SEQ_ISSUED, ' +
    ':MT_MAT_BALANCE, :MT_QTY_ALLOC, :MT_HIGH_DATE_ALLOC, :MT_SEARCH_MAT_ALLOC, ' +
    ':MT_SETTLED, :MT_QUANTITY_ISSUE, :MT_REQ_QUANTITY, ' +
    ':MT_CREATE_DATE_TIME_UTC, :MT_UPDATED_DATE_TIME_UTC, :MT_IDENTIFIER)');
  BuildSql(tbl_Material, fldListMT, KeyNumMT, SqlUpdate, SqlDel);
  QryUpdateMT := ThreadCreateQuery(Main_DB);
  QryUpdateMT.Transaction := MqmTrs;
  QryUpdateMT.SQL.Add(
    'update ' + tblInfo[tbl_Material].GetTableName + ' set ' +
    '"MT_ORG_STEP"=:MT_ORG_STEP, "MT_MAT_BALANCE"=:MT_MAT_BALANCE, ' +
    '"MT_QTY_ALLOC"=:MT_QTY_ALLOC, "MT_HIGH_DATE_ALLOC"=:MT_HIGH_DATE_ALLOC, ' +
    '"MT_SEARCH_MAT_ALLOC"=:MT_SEARCH_MAT_ALLOC, "MT_SETTLED"=:MT_SETTLED, ' +
    '"MT_QUANTITY_ISSUE"=:MT_QUANTITY_ISSUE, "MT_REQ_QUANTITY"=:MT_REQ_QUANTITY, ' +
    '"MT_UPDATED_DATE_TIME_UTC"=:MT_UPDATED_DATE_TIME_UTC ' +
    'WHERE "MT_PREQ_NO"=:MT_PREQ_NO AND "MT_PSTEP_ID"=:MT_PSTEP_ID AND ' +
    '"MT_WKCNTER"=:MT_WKCNTER AND "MT_RES_CAT_CODE"=:MT_RES_CAT_CODE AND ' +
    '"MT_RSC_CODE"=:MT_RSC_CODE AND "MT_MACHINE_SETUP_CODE"=:MT_MACHINE_SETUP_CODE AND ' +
    '"MT_ALTERNATIVE_CODE"=:MT_ALTERNATIVE_CODE AND "MT_TYPE_PROD"=:MT_TYPE_PROD AND ' +
    '"MT_PRODUCT_CODE"=:MT_PRODUCT_CODE AND "MT_NET_GROUP_CODE"=:MT_NET_GROUP_CODE AND ' +
    '"MT_ISSUE_CODE"=:MT_ISSUE_CODE AND "MT_SEQ_ISSUED"=:MT_SEQ_ISSUED' +
    AND_IDF_Condition(CreateFld(tblInfo[tbl_Material].pfx, fli_IDENTIFIER)));
  QryDelMT := ThreadCreateQuery(Main_DB);
  QryDelMT.Transaction := MqmTrs;
  QryDelMT.SQL.Add(SqlDel);

  InsertTable(tbl_produced_article,fldListPAStruct,QryInsertPA);
  QryInsertPA.SQL.Add(
    ':PA_PREQ_NO, :PA_SEQUENCE, :PA_PRODUCT_CODE, :PA_NET_GROUP_CODE, :PA_ALLOC_REQ, ' +
    ':PA_PROD_BALANCE, :PA_RSC_CODE, :PA_SETTLED, :PA_REQ_QUANTITY, ' +
    ':PA_QTY_PRODUCED, :PA_QTY_ALLOC, ' +
    ':PA_CREATE_DATE_TIME_UTC, :PA_UPDATED_DATE_TIME_UTC, :PA_IDENTIFIER)');
  BuildSql(tbl_produced_article, fldListPA, KeyNumPA, SqlUpdate, SqlDel);
  QryUpdatePA := ThreadCreateQuery(Main_DB);
  QryUpdatePA.Transaction := MqmTrs;
  QryUpdatePA.SQL.Add(
    'update ' + tblInfo[tbl_produced_article].GetTableName + ' set ' +
    '"PA_PROD_BALANCE"=:PA_PROD_BALANCE, "PA_RSC_CODE"=:PA_RSC_CODE, ' +
    '"PA_SETTLED"=:PA_SETTLED, "PA_REQ_QUANTITY"=:PA_REQ_QUANTITY, ' +
    '"PA_QTY_PRODUCED"=:PA_QTY_PRODUCED, "PA_QTY_ALLOC"=:PA_QTY_ALLOC, ' +
    '"PA_UPDATED_DATE_TIME_UTC"=:PA_UPDATED_DATE_TIME_UTC ' +
    'WHERE "PA_PREQ_NO"=:PA_PREQ_NO AND "PA_SEQUENCE"=:PA_SEQUENCE AND ' +
    '"PA_PRODUCT_CODE"=:PA_PRODUCT_CODE AND "PA_NET_GROUP_CODE"=:PA_NET_GROUP_CODE AND ' +
    '"PA_ALLOC_REQ"=:PA_ALLOC_REQ' +
    AND_IDF_Condition(CreateFld(tblInfo[tbl_produced_article].pfx, fli_IDENTIFIER)));
  QryDelPA := ThreadCreateQuery(Main_DB);
  QryDelPA.Transaction := MqmTrs;
  QryDelPA.SQL.Add(SqlDel);

  tblInf := @tblInfo[tbl_prod_reqHdr];
  Temp_TimeVal := NOW;
  QryTmp.sql.Clear;
  QryTmp.sql.add(' update ' + tblInf.GetTableName);
  QryTmp.sql.add(' set ' + CreateFld(tblInf.pfx, fli_updCode) + '=' + QuotedStr('0'));
  QryTmp.sql.add(' where ' + CreateFld(tblInf.pfx, fli_updCode) + '=' + QuotedStr('1'));
  QryTmp.sql.add(AND_IDF_Condition(CreateFld(tblInf.pfx, fli_IDENTIFIER)));
  QryTmp.ExecSQL;
  IniAppGlobals.Time_UpdCodeReset := IniAppGlobals.Time_UpdCodeReset + (NOW - Temp_TimeVal);

  Temp_TimeVal := NOW;
  BatchStart := 0;
  while BatchStart < m_Req_Change_List.count do
  begin
    BatchEnd := BatchStart + 899;
    if BatchEnd >= m_Req_Change_List.count then
      BatchEnd := m_Req_Change_List.count - 1;
    InList := '';
    for I := BatchStart to BatchEnd do
    begin
      if InList <> '' then InList := InList + ',';
      InList := InList + QuotedStr(PReqChange(m_Req_Change_List[I]).ProdReq);
    end;
    QryTmp.sql.Clear;
    QryTmp.sql.add(' update ' + tblInf.GetTableName);
    QryTmp.sql.add(' set ' + CreateFld(tblInf.pfx, fli_updCode) + '=' + QuotedStr('1'));
    QryTmp.sql.add(' where ' + CreateFld(tblInf.pfx, fli_preqNo) + ' IN (' + InList + ')');
    QryTmp.sql.add(AND_IDF_Condition(CreateFld(tblInf.pfx, fli_IDENTIFIER)));
    QryTmp.ExecSQL;
    BatchStart := BatchStart + 900;
  end;
  QryTmp.Connection.Commit;
  IniAppGlobals.Time_UpdCodeSet := IniAppGlobals.Time_UpdCodeSet + (NOW - Temp_TimeVal);

//  SetQryTbl(SrvQryPA);

//  SetQryTblCompar(m_LocalListPR,m_LocalListPH,m_LocalListPD,m_LocalListPP,
//                  m_LocalListPI,m_LocalListEC,m_LocalListIC,m_LocalListSB,
//                  m_LocalListSP,m_LocalListST,m_LocalListMT,m_LocalListPA);

  SrvQryPS := ThreadCreateQuery(Main_DB);
  SrvQryPSMCM := ThreadCreateQuery(Main_DB);
  QryUpdatePS := ThreadCreateQuery(Main_DB);
  QryUpdatePS.Transaction := MqmTrs;

  QryDelPS    := ThreadCreateQuery(Main_DB);
  QryDelPS.Transaction := MqmTrs;

  QryUpdatePSMCM := ThreadCreateQuery(Main_DB);
  QryUpdatePSMCM.Transaction := MqmTrs;

  QryDelPSMCM    := ThreadCreateQuery(Main_DB);
  QryDelPSMCM.Transaction := MqmTrs;

  if DndArchiveLocalName = TD_Interbase then
    PROD_REQ_HDR := 'PROD_REQHDR'
  else
     PROD_REQ_HDR := 'SCDM_PROD_REQHDR';

  tblInf := @tblInfo[tbl_prod_sched];
  Temp_TimeVal := NOW;
  QryTmp.sql.Clear;
  QryTmp.sql.add(' DELETE FROM ' + tblInf.GetTableName + ' ps WHERE not exists '); // + CreateFld(tblInf.pfx, fli_preqNo) + ' NOT IN ');
  QryTmp.sql.add(' (select 1 from ' + PROD_REQ_HDR + ' ph where ph.ph_preq_no = ps.ps_preq_no and ph.ph_identifier = ps.ps_identifier) ');
  QryTmp.ExecSQL;
  QryTmp.Connection.Commit;
  IniAppGlobals.Time_DeletePS_Orphans := IniAppGlobals.Time_DeletePS_Orphans + (NOW - Temp_TimeVal);

  Temp_TimeVal := NOW;
  SrvQryPS.sql.Clear;
  SrvQryPS.sql.add(' Select ' +
    CreateFld(tblInf.pfx, fli_preqNo)    + ',' +
    CreateFld(tblInf.pfx, fli_pstepId)   + ',' +
    CreateFld(tblInf.pfx, fli_psubstId)  + ',' +
    CreateFld(tblInf.pfx, fli_reprocNo)  + ',' +
    CreateFld(tblInf.pfx, fli_rsc)       + ',' +
    CreateFld(tblInf.pfx, fli_schedType) + ',' +
    CreateFld(tblInf.pfx, fli_schedStart)+ ',' +
    CreateFld(tblInf.pfx, fli_schedEnd)  + ',' +
    CreateFld(tblInf.pfx, fli_quant) +
    ' from ' + tblInf.GetTableName);
  SrvQryPS.sql.add(WHERE_IDF_Condition(CreateFld(tblInf.pfx, fli_IDENTIFIER)));
  SrvQryPS.sql.add(' Order by ' + CreateFld(tblInf.pfx, fli_preqNo) + ',' + CreateFld(tblInf.pfx,fli_pstepId));
  SrvQryPS.Open;
  IniAppGlobals.Time_SrvQryPS_Open := IniAppGlobals.Time_SrvQryPS_Open + (NOW - Temp_TimeVal);

  tblInf := @tblInfo[tbl_prod_sched_mcm];
  Temp_TimeVal := NOW;
  QryTmp.sql.Clear;
  QryTmp.sql.add(' DELETE FROM ' + tblInf.GetTableName + ' ms WHERE not exists '); // + CreateFld(tblInf.pfx, fli_preqNo) + ' NOT IN ');
  QryTmp.sql.add(' (select 1 from ' + PROD_REQ_HDR + ' ph where ph.ph_preq_no = ms.ms_preq_no and ph.ph_identifier = ms.ms_identifier) ');
  QryTmp.ExecSQL;
  QryTmp.Connection.Commit;
  IniAppGlobals.Time_DeletePSMCM_Orphans := IniAppGlobals.Time_DeletePSMCM_Orphans + (NOW - Temp_TimeVal);

  Temp_TimeVal := NOW;
  SrvQryPSMCM.sql.Clear;
  SrvQryPSMCM.sql.add(' Select ' +
    CreateFld(tblInf.pfx, fli_preqNo)    + ',' +
    CreateFld(tblInf.pfx, fli_pstepId)   + ',' +
    CreateFld(tblInf.pfx, fli_psubstId)  + ',' +
    CreateFld(tblInf.pfx, fli_reprocNo)  + ',' +
    CreateFld(tblInf.pfx, fli_rsc)       + ',' +
    CreateFld(tblInf.pfx, fli_schedType) + ',' +
    CreateFld(tblInf.pfx, fli_schedStart)+ ',' +
    CreateFld(tblInf.pfx, fli_schedEnd)  + ',' +
    CreateFld(tblInf.pfx, fli_quant) +
    ' from ' + tblInf.GetTableName);
  SrvQryPSMCM.sql.add(WHERE_IDF_Condition(CreateFld(tblInf.pfx, fli_IDENTIFIER)));
  SrvQryPSMCM.sql.add(' Order by ' + CreateFld(tblInf.pfx, fli_preqNo) + ',' + CreateFld(tblInf.pfx,fli_pstepId));
  SrvQryPSMCM.Open;
  IniAppGlobals.Time_SrvQryPSMCM_Open := IniAppGlobals.Time_SrvQryPSMCM_Open + (NOW - Temp_TimeVal);

  m_Local_IndexPR := 0;
  m_Local_IndexPH := 0;
  m_Local_IndexPD := 0;
  m_Local_IndexPP := 0;
  m_Local_IndexPI := 0;
  m_Local_IndexEC := 0;
  m_Local_IndexIC := 0;
  m_Local_IndexSB := 0;
  m_Local_IndexSP := 0;
  m_Local_IndexST := 0;
  m_Local_IndexMT := 0;
  m_Local_IndexPA := 0;

  IndexPR := 0;
  IndexPH := 0;
  IndexPD := 0;
  IndexPP := 0;
  IndexPI := 0;
  IndexEC := 0;
  IndexIC := 0;
  IndexSB := 0;
  IndexSP := 0;
  IndexST := 0;
  IndexMT := 0;
  IndexPA := 0;
  IndexStep := 0;
  pdstr := false;

  try

  for I := 0 to m_Req_Change_List.count - 1 do
  begin
    if (I mod 100 = 0) then Application.ProcessMessages;
    RunCommit := false;
    MqmTrs.StartTransaction;
    Request := PReqChange(m_Req_Change_List[I]).ProdReq;
    if (PReqChange(m_Req_Change_List[I]).ChangedType = NewReq) then
       UpdateOperation(_('Inserting Request -')+ ' ' + Request);
    if (PReqChange(m_Req_Change_List[I]).ChangedType = Historical) then
       UpdateOperation(_('Closing Request -')+ ' ' + Request);
    if (PReqChange(m_Req_Change_List[I]).ChangedType = DelReq) then
       UpdateOperation(_('Deleting Request -')+ ' ' + Request);
    if (PReqChange(m_Req_Change_List[I]).ChangedType <> NewReq)
    and (PReqChange(m_Req_Change_List[I]).ChangedType <> Historical)
    and (PReqChange(m_Req_Change_List[I]).ChangedType <> DelReq) then
       UpdateOperation(_('Updating Request -')+ ' ' + Request);

   // InsertMcmReqRecordToDataBase(PReqChange(m_Req_Change_List[I]), srvTrs);

    if IsClientOpen then
    begin
      Temp_TimeVal := NOW;
      InsertChangeReqToTable(false ,PReqChange(m_Req_Change_List[I]).ProdReq, PReqChange(m_Req_Change_List[I]), MqmTrs, QryInsertCR);
      IniAppGlobals.Time_InsertChangeReqToTable := IniAppGlobals.Time_InsertChangeReqToTable + (NOW - Temp_TimeVal);
      Result := true;
    end;

    While (IndexStep <= m_Req_Step_Change_List.count - 1)
    and   (Request > PStepChange(m_Req_Step_Change_List[IndexStep]).ProdReq) do
    begin
       inc(IndexStep);
    end;
    if  (IndexStep <= m_Req_Step_Change_List.count - 1)
    and (Request = PStepChange(m_Req_Step_Change_List[IndexStep]).ProdReq) then
       RequestHasStepsInList := True
    else
       RequestHasStepsInList := False;

    if RequestHasStepsInList then
    begin
      J := IndexStep;
      While true do
      begin
        if (J > m_Req_Step_Change_List.count - 1) then break;
        if (Request < PStepChange(m_Req_Step_Change_List[J]).ProdReq) then break;

        if IsClientOpen then
          InsertChangeStepReqToTable(PStepChange(m_Req_Step_Change_List[J]).ProdReq,
                                     PStepChange(m_Req_Step_Change_List[J]).StepNr,
                                     PStepChange(m_Req_Step_Change_List[J]), MqmTrs);

      //  InsertMcmStepRecordToDataBase(PStepChange(m_Req_Step_Change_List[J]), PReqChange(m_Req_Change_List[I]), srvTrs);
        Inc(J);
      end;
    end;

    //*******************************************************************************//
    //**************************** tbl_prod_req *************************************//
    //*******************************************************************************//
    tblInf := @tblInfo[tbl_prod_req];

    while (IndexPR <= m_HostListPR.count - 1) and (Request > PTMQMPR(m_HostListPR[IndexPR]).PR_PREQ_NO) do
    begin
      inc(IndexPR);
    end;
    while (not EOL_Local(PR)) and (Request > PTMQMPR(m_LocalListPR[m_Local_IndexPR]).PR_PREQ_NO) do
    begin
      Inc(m_Local_IndexPR);
    end;

    EndRequestDataHost := false;
    EndRequestDataLocal := false;
    while true do
    begin
      if (IndexPR > m_HostListPR.count - 1) or (Request < PTMQMPR(m_HostListPR[IndexPR]).PR_PREQ_NO)
      or (PReqChange(m_Req_Change_List[I]).ChangedType = DelReq) then EndRequestDataHost := true;
      if (EOL_Local(PR) or (Request < PTMQMPR(m_LocalListPR[m_Local_IndexPR]).PR_PREQ_NO))
      then EndRequestDataLocal := true;

      if EndRequestDataHost and EndRequestDataLocal then break;

      if (PReqChange(m_Req_Change_List[I]).ChangedType = Historical) then
      begin
        with QryTmp do
        begin
          SqlUpdate := '';
          SqlUpdate :=  SqlUpdate + 'update ' + tblInf.GetTableName + ' set ';
          SqlUpdate :=  SqlUpdate + CreateFld(tblInf.pfx, fli_HistoriclReq) + ' = ''1''';
          SqlUpdate :=  SqlUpdate + ' where ';
          SqlUpdate :=  SqlUpdate + CreateFld(tblInf.pfx, fli_preqNo) + '=' +  '''' + Request + '''';
          SqlUpdate :=  SqlUpdate + AND_IDF_Condition(CreateFld(tblInf.pfx, fli_IDENTIFIER));
          SQL.Clear;
          SQL.Add(SqlUpdate);
          ExecSQL;
          RunCommit := true;
        end;
        break;
      end;

      Operation := DBEqual;
      if EndRequestDataHost then Operation := DBDelete;
      if EndRequestDataLocal then Operation := DBInsert;

      if Operation = DBEqual then
      begin
         TableNumberOfKeys := KeyNumPR;
         TableNumberOfFields := 7;
         HostFields[1] := PTMQMPR(m_HostListPR[IndexPR]).PR_PREQ_NO;
         HostFields[2] := PTMQMPR(m_HostListPR[IndexPR]).PR_DSP_CODE;
         HostFields[3] := PTMQMPR(m_HostListPR[IndexPR]).PR_BCH_CODE;
         HostFields[4] := PTMQMPR(m_HostListPR[IndexPR]).PR_REPROC_NO;
         HostFields[5] := PTMQMPR(m_HostListPR[IndexPR]).PR_DIV_CODE;
         HostFields[6] := PTMQMPR(m_HostListPR[IndexPR]).PR_HISTORICAL_REQ;
        // HostFields[7] := PTMQMPR(m_HostListPR[IndexPR]).PR_ModulHandled;
         LocalFields[1] := PTMQMPR(m_LocalListPR[m_Local_IndexPR]).PR_PREQ_NO;
         LocalFields[2] := PTMQMPR(m_LocalListPR[m_Local_IndexPR]).PR_DSP_CODE;
         LocalFields[3] := PTMQMPR(m_LocalListPR[m_Local_IndexPR]).PR_BCH_CODE;
         LocalFields[4] := PTMQMPR(m_LocalListPR[m_Local_IndexPR]).PR_REPROC_NO;
         LocalFields[5] := PTMQMPR(m_LocalListPR[m_Local_IndexPR]).PR_DIV_CODE;
         LocalFields[6] := PTMQMPR(m_LocalListPR[m_Local_IndexPR]).PR_HISTORICAL_REQ;
        // LocalFields[7] := PTMQMPR(m_LocalListPR[m_Local_IndexPR]).PR_ModulHandled;
         Operation := CompareKeys(TableNumberOfKeys, TableNumberOfFields, HostFields, LocalFields);
      end;

      if Operation = DBDelete then
      begin
        with QryDelPR do
        begin
          Temp_TimeVal := NOW;
          ParamByName(CreateFld(tblInf.pfx, fli_preqNo)).AsString := PTMQMPR(m_LocalListPR[m_Local_IndexPR]).PR_PREQ_NO;
         // Prepare;
          ExecSQL;
          Temp_TimeVal := NOW - Temp_TimeVal;
          IniAppGlobals.Time_DelPR := IniAppGlobals.Time_DelPR + Temp_TimeVal;
          Inc(IniAppGlobals.Count_DelPR);
          RunCommit := true;
        end;
        Inc(m_Local_IndexPR);
        continue;
      end;

      if Operation = DBInsert then
      begin
        with QryInsertPR do
        begin
          Temp_TimeVal := NOW;
          ParamByName('PR_PREQ_NO').AsString := PTMQMPR(m_HostListPR[IndexPR]).PR_PREQ_NO;
          ParamByName('PR_DIV_CODE').AsString := PTMQMPR(m_HostListPR[IndexPR]).PR_DIV_CODE;
          ParamByName('PR_DSP_CODE').AsString := PTMQMPR(m_HostListPR[IndexPR]).PR_DSP_CODE;
          ParamByName('PR_BCH_CODE').AsString := PTMQMPR(m_HostListPR[IndexPR]).PR_BCH_CODE;
          ParamByName('PR_REPROC_NO').AsInteger := PTMQMPR(m_HostListPR[IndexPR]).PR_REPROC_NO;
          ParamByName('PR_HISTORICAL_REQ').AsString := PTMQMPR(m_HostListPR[IndexPR]).PR_HISTORICAL_REQ;
          ParamByName('PR_USR_NAMECG').AsString := PTMQMPR(m_HostListPR[IndexPR]).PR_USR_CG;
          ParamByName('PR_USR_TIMECG').AsDateTime := PTMQMPR(m_HostListPR[IndexPR]).PR_USR_TM_CG;
          ParamByName('PR_MODULEHANDLE').AsString := PTMQMPR(m_HostListPR[IndexPR]).PR_ModulHandled;
          ParamByName('PR_IDENTIFIER').AsString := IniAppGlobals.Identifier;
          try
            ExecSQL;

            RunCommit := true;
          except
            on E: Exception do
            begin
              ApplicationShowException(E);
            end;
          end;

          Temp_TimeVal := NOW - Temp_TimeVal;
            IniAppGlobals.Time_InsertPR := IniAppGlobals.Time_InsertPR + Temp_TimeVal;
            Inc(IniAppGlobals.Count_InsertPR);
        end;
        IndexPR:= IndexPR+ 1;
        continue;
      end;

      if Operation = DBUpdate then
      begin

        with QryUpdatePR do
        begin
          Temp_TimeVal := NOW;
          ParamByName('PR_DIV_CODE').AsString := PTMQMPR(m_HostListPR[IndexPR]).PR_DIV_CODE;
          ParamByName('PR_DSP_CODE').AsString := PTMQMPR(m_HostListPR[IndexPR]).PR_DSP_CODE;
          ParamByName('PR_BCH_CODE').AsString := PTMQMPR(m_HostListPR[IndexPR]).PR_BCH_CODE;
          ParamByName('PR_REPROC_NO').AsInteger := PTMQMPR(m_HostListPR[IndexPR]).PR_REPROC_NO;
          ParamByName('PR_HISTORICAL_REQ').AsString := PTMQMPR(m_HostListPR[IndexPR]).PR_HISTORICAL_REQ;
          ParamByName('PR_USR_NAMECG').AsString := PTMQMPR(m_HostListPR[IndexPR]).PR_USR_CG;
          ParamByName('PR_USR_TIMECG').AsDateTime := PTMQMPR(m_HostListPR[IndexPR]).PR_USR_TM_CG;
          ParamByName('PR_MODULEHANDLE').AsString := PTMQMPR(m_HostListPR[IndexPR]).PR_ModulHandled;
          ParamByName('PR_PREQ_NO').AsString := PTMQMPR(m_HostListPR[IndexPR]).PR_PREQ_NO;

          try
            ExecSQL;

          except
          end;
          Temp_TimeVal := NOW - Temp_TimeVal;
            IniAppGlobals.Time_UpdatePR := IniAppGlobals.Time_UpdatePR + Temp_TimeVal;
            Inc(IniAppGlobals.Count_UpdatePR);
          RunCommit := true;
        end;
      end;
      Inc(m_Local_IndexPR);
      IndexPR:= IndexPR + 1;
    end;

    //*******************************************************************************//
    //**************************** tbl_prod_reqHdr **********************************//
    //*******************************************************************************//
    tblInf := @tblInfo[tbl_prod_reqHdr];

    while (IndexPH <= m_HostListPH.count - 1) and (Request > PTMQMPH(m_HostListPH[IndexPH]).PH_PREQ_NO) do
    begin
      inc(IndexPH);
    end;
    while (not EOL_Local(PH)) and (Request > PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_PREQ_NO) do
    begin
      Inc(m_Local_IndexPH);
    end;

    EndRequestDataHost := false;
    EndRequestDataLocal := false;
    while true do
    begin
      if (IndexPH > m_HostListPH.count - 1) or (Request < PTMQMPH(m_HostListPH[IndexPH]).PH_PREQ_NO)
      or (PReqChange(m_Req_Change_List[I]).ChangedType = DelReq) then EndRequestDataHost := true;
      if (EOL_Local(PH) or (Request < PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_PREQ_NO))
      then EndRequestDataLocal := true;

      if EndRequestDataHost and EndRequestDataLocal then break;

      if (PReqChange(m_Req_Change_List[I]).ChangedType = Historical) then
      begin
        with QryTmp do
        begin
          SqlUpdate := '';
          SqlUpdate :=  SqlUpdate + 'update ' + tblInf.GetTableName + ' set ';
          SqlUpdate :=  SqlUpdate + CreateFld(tblInf.pfx, fli_HistoriclReq) + ' = ''1''';
          SqlUpdate :=  SqlUpdate + ' where ';
          SqlUpdate :=  SqlUpdate + CreateFld(tblInf.pfx, fli_preqNo) + '=' +  '''' + Request + '''';
          SqlUpdate :=  SqlUpdate + AND_IDF_Condition(CreateFld(tblInf.pfx, fli_IDENTIFIER));
          SQL.Clear;
          SQL.Add(SqlUpdate);
          try
            ExecSQL;
          except
          end;
          RunCommit := true;
        end;
        break;
      end;

      Operation := DBEqual;
      if EndRequestDataHost then Operation := DBDelete;
      if EndRequestDataLocal then Operation := DBInsert;

      if Operation = DBEqual then
      begin
        TableNumberOfKeys := KeyNumPH;
        TableNumberOfFields := 21;
        HostFields[1]  := PTMQMPH(m_HostListPH[IndexPH]).PH_PREQ_NO;
        HostFields[2]  := PTMQMPH(m_HostListPH[IndexPH]).PH_HISTORICAL_REQ;
        HostFields[3]  := PTMQMPH(m_HostListPH[IndexPH]).PH_REQ_ORIGIN;
        HostFields[4]  := PTMQMPH(m_HostListPH[IndexPH]).PH_PROD_LINE;
        HostFields[5]  := PTMQMPH(m_HostListPH[IndexPH]).PH_TYPE_PROD;
        HostFields[6]  := PTMQMPH(m_HostListPH[IndexPH]).PH_PROD_FAMILY;
        HostFields[7]  := PTMQMPH(m_HostListPH[IndexPH]).PH_MATERIAL_FAMILY;
        HostFields[8]  := PTMQMPH(m_HostListPH[IndexPH]).PH_PROD_UM;
        HostFields[9]  := PTMQMPH(m_HostListPH[IndexPH]).PH_PROD_LOW_TIME_STRT;
        HostFields[10] := PTMQMPH(m_HostListPH[IndexPH]).PH_PROD_DELIVY_DATE;
        HostFields[11] := PTMQMPH(m_HostListPH[IndexPH]).PH_FRC_DEL_DATE;
        HostFields[12] := 0;//PTMQMPH(m_HostListPH[IndexPH]).PH_USR_CG;
        HostFields[13] := 0;//PTMQMPH(m_HostListPH[IndexPH]).PH_USR_TM_CG;
        HostFields[14] := PTMQMPH(m_HostListPH[IndexPH]).PH_ModulHandled;
        HostFields[15] := PTMQMPH(m_HostListPH[IndexPH]).PH_SPLITCONFLEVELS;
        HostFields[16] := PTMQMPH(m_HostListPH[IndexPH]).PH_LEAD_STEP_SPLITED;
        HostFields[17] := PTMQMPH(m_HostListPH[IndexPH]).PH_MQM_SPLIT_ID;
        HostFields[18] := PTMQMPH(m_HostListPH[IndexPH]).PH_Serving_Code;
        HostFields[19] := PTMQMPH(m_HostListPH[IndexPH]).PH_Served_Code;
        HostFields[20] := PTMQMPH(m_HostListPH[IndexPH]).PH_Curve_Family_Id_Code;

        LocalFields[1] := PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_PREQ_NO;
        LocalFields[2] := PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_HISTORICAL_REQ;
        LocalFields[3] := PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_REQ_ORIGIN;
        LocalFields[4] := PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_PROD_LINE;
        LocalFields[5] := PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_TYPE_PROD;
        LocalFields[6] := PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_PROD_FAMILY;
        LocalFields[7] := PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_MATERIAL_FAMILY;
        LocalFields[8] := PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_PROD_UM;
        LocalFields[9] := PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_PROD_LOW_TIME_STRT;
        LocalFields[10] := PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_PROD_DELIVY_DATE;
        LocalFields[11] := PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_FRC_DEL_DATE;
        LocalFields[12] := 0;//Trim(srvQryPH.FieldByName(CreateFld(tblInf.pfx, fli_usrCg)).AsString);
        LocalFields[13] := 0;//srvQryPH.FieldByName(CreateFld(tblInf.pfx, fli_usrTmCg)).AsDateTime;
        LocalFields[14] := PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_ModulHandled;
        LocalFields[15] := PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_SPLITCONFLEVELS;
        LocalFields[16] := PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_LEAD_STEP_SPLITED;
        LocalFields[17] := PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_MQM_SPLIT_ID;
        LocalFields[18] := PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_Serving_Code;
        LocalFields[19] := PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_Served_Code;
        LocalFields[20] := PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_Curve_Family_Id_Code;
        Operation := CompareKeys(TableNumberOfKeys, TableNumberOfFields, HostFields, LocalFields);
      end;

      if Operation = DBDelete then
      begin
        with QryDelPH do
        begin
          ParamByName(CreateFld(tblInf.pfx, fli_preqNo)).AsString := PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_PREQ_NO;
          Temp_TimeVal := NOW;
          ExecSQL;
          Temp_TimeVal := NOW - Temp_TimeVal;
          IniAppGlobals.Time_DelPH := IniAppGlobals.Time_DelPH + Temp_TimeVal;
          Inc(IniAppGlobals.Count_DelPH);
          RunCommit := true;
        end;
        Inc(m_Local_IndexPH);
        continue;
      end;

      if Operation = DBInsert then
      begin
      //  QryInsertPH.Connection.StartTransaction;

        PTMQMPH(m_HostListPH[IndexPH]).PH_CreateDateTimeUTC := UTCNow;
        PTMQMPH(m_HostListPH[IndexPH]).PH_CrtOrUpdateDateTimeUTC := UTCNow;

        with QryInsertPH do
        begin
          Temp_TimeVal := NOW;
          ParamByName('PH_PREQ_NO').AsString := PTMQMPH(m_HostListPH[IndexPH]).PH_PREQ_NO;
          ParamByName('PH_HISTORICAL_REQ').AsString := PTMQMPH(m_HostListPH[IndexPH]).PH_HISTORICAL_REQ;
          ParamByName('PH_REQ_ORIGIN').AsString := PTMQMPH(m_HostListPH[IndexPH]).PH_REQ_ORIGIN;
          ParamByName('PH_PROD_LINE').AsString := PTMQMPH(m_HostListPH[IndexPH]).PH_PROD_LINE;
          ParamByName('PH_TYPE_PROD').AsString := PTMQMPH(m_HostListPH[IndexPH]).PH_TYPE_PROD;
          ParamByName('PH_PROD_FAMILY').AsString := PTMQMPH(m_HostListPH[IndexPH]).PH_PROD_FAMILY;
          ParamByName('PH_MATERIAL_FAMILY').AsString := PTMQMPH(m_HostListPH[IndexPH]).PH_MATERIAL_FAMILY;
          ParamByName('PH_PROD_UM').AsString := PTMQMPH(m_HostListPH[IndexPH]).PH_PROD_UM;
          ParamByName('PH_PROD_LOW_TIME_STRT').AsDateTime := PTMQMPH(m_HostListPH[IndexPH]).PH_PROD_LOW_TIME_STRT;
          ParamByName('PH_PROD_DELIVY_DATE').AsDateTime := PTMQMPH(m_HostListPH[IndexPH]).PH_PROD_DELIVY_DATE;
          ParamByName('PH_FRC_DEL_DATE').AsString := PTMQMPH(m_HostListPH[IndexPH]).PH_FRC_DEL_DATE;
          ParamByName('PH_USR_NAMECG').AsString := PTMQMPH(m_HostListPH[IndexPH]).PH_USR_CG;
          ParamByName('PH_USR_TIMECG').AsDateTime := PTMQMPH(m_HostListPH[IndexPH]).PH_USR_TM_CG;
          ParamByName('PH_MODULEHANDLE').AsString := PTMQMPH(m_HostListPH[IndexPH]).PH_ModulHandled;
          ParamByName('PH_SPLITCONFLEVELS').AsString := PTMQMPH(m_HostListPH[IndexPH]).PH_SPLITCONFLEVELS;
          ParamByName('PH_LEAD_STEP_SPLITED').AsInteger := PTMQMPH(m_HostListPH[IndexPH]).PH_LEAD_STEP_SPLITED;
          ParamByName('PH_NEW_PREQ_UNIQ_ID').AsString := PTMQMPH(m_HostListPH[IndexPH]).PH_MQM_SPLIT_ID;
          ParamByName('PH_SERVING_CODE').AsString := PTMQMPH(m_HostListPH[IndexPH]).PH_Serving_Code;
          ParamByName('PH_SERVED_CODE').AsString := PTMQMPH(m_HostListPH[IndexPH]).PH_Served_Code;
          ParamByName('PH_CURVE_FAMILY_ID_CODE').AsString := PTMQMPH(m_HostListPH[IndexPH]).PH_Curve_Family_Id_Code;
          ParamByName('PH_CREATE_DATE_TIME_UTC').AsDateTime := PTMQMPH(m_HostListPH[IndexPH]).PH_CreateDateTimeUTC;
          ParamByName('PH_UPDATED_DATE_TIME_UTC').AsDateTime := PTMQMPH(m_HostListPH[IndexPH]).PH_CrtOrUpdateDateTimeUTC;
          ParamByName('PH_IDENTIFIER').AsString := IniAppGlobals.Identifier;
          try
            ExecSQL;

            RunCommit := true;
          except
          end;
          Temp_TimeVal := NOW - Temp_TimeVal;
            IniAppGlobals.Time_InsertPH := IniAppGlobals.Time_InsertPH + Temp_TimeVal;
            Inc(IniAppGlobals.Count_InsertPH);
        end;
        IndexPH := IndexPH + 1;
        continue;
      end;

      if Operation = DBUpdate then
      begin

        PTMQMPH(m_HostListPH[IndexPH]).PH_CrtOrUpdateDateTimeUTC := UTCNow;

        with QryUpdatePH do
        begin
          Temp_TimeVal := NOW;
          ParamByName('PH_HISTORICAL_REQ').AsString := PTMQMPH(m_HostListPH[IndexPH]).PH_HISTORICAL_REQ;
          ParamByName('PH_REQ_ORIGIN').AsString := PTMQMPH(m_HostListPH[IndexPH]).PH_REQ_ORIGIN;
          ParamByName('PH_PROD_LINE').AsString := PTMQMPH(m_HostListPH[IndexPH]).PH_PROD_LINE;
          ParamByName('PH_TYPE_PROD').AsString := PTMQMPH(m_HostListPH[IndexPH]).PH_TYPE_PROD;
          ParamByName('PH_PROD_FAMILY').AsString := PTMQMPH(m_HostListPH[IndexPH]).PH_PROD_FAMILY;
          ParamByName('PH_MATERIAL_FAMILY').AsString := PTMQMPH(m_HostListPH[IndexPH]).PH_MATERIAL_FAMILY;
          ParamByName('PH_PROD_UM').AsString := PTMQMPH(m_HostListPH[IndexPH]).PH_PROD_UM;
          ParamByName('PH_PROD_LOW_TIME_STRT').AsDateTime := PTMQMPH(m_HostListPH[IndexPH]).PH_PROD_LOW_TIME_STRT;
          ParamByName('PH_PROD_DELIVY_DATE').AsDateTime := PTMQMPH(m_HostListPH[IndexPH]).PH_PROD_DELIVY_DATE;
          ParamByName('PH_FRC_DEL_DATE').AsString := PTMQMPH(m_HostListPH[IndexPH]).PH_FRC_DEL_DATE;
          ParamByName('PH_USR_NAMECG').AsString := PTMQMPH(m_HostListPH[IndexPH]).PH_USR_CG;
          ParamByName('PH_USR_TIMECG').AsDateTime := PTMQMPH(m_HostListPH[IndexPH]).PH_USR_TM_CG;
          ParamByName('PH_MODULEHANDLE').AsString := PTMQMPH(m_HostListPH[IndexPH]).PH_ModulHandled;
          ParamByName('PH_SPLITCONFLEVELS').AsString := PTMQMPH(m_HostListPH[IndexPH]).PH_SPLITCONFLEVELS;
          ParamByName('PH_LEAD_STEP_SPLITED').AsInteger := PTMQMPH(m_HostListPH[IndexPH]).PH_LEAD_STEP_SPLITED;
          ParamByName('PH_NEW_PREQ_UNIQ_ID').AsString := PTMQMPH(m_HostListPH[IndexPH]).PH_MQM_SPLIT_ID;
          ParamByName('PH_SERVING_CODE').AsString := PTMQMPH(m_HostListPH[IndexPH]).PH_Serving_Code;
          ParamByName('PH_SERVED_CODE').AsString := PTMQMPH(m_HostListPH[IndexPH]).PH_Served_Code;
          ParamByName('PH_CURVE_FAMILY_ID_CODE').AsString := PTMQMPH(m_HostListPH[IndexPH]).PH_Curve_Family_Id_Code;
          ParamByName('PH_UPDATED_DATE_TIME_UTC').AsDateTime := PTMQMPH(m_HostListPH[IndexPH]).PH_CrtOrUpdateDateTimeUTC;
          ParamByName('PH_PREQ_NO').AsString := PTMQMPH(m_HostListPH[IndexPH]).PH_PREQ_NO;

          try
            ExecSQL;

          except
          end;
          Temp_TimeVal := NOW - Temp_TimeVal;
            IniAppGlobals.Time_UpdatePH := IniAppGlobals.Time_UpdatePH + Temp_TimeVal;
            Inc(IniAppGlobals.Count_UpdatePH);
          RunCommit := true;
        end;
      end;
      Inc(m_Local_IndexPH);
      IndexPH := IndexPH + 1;
    end;

    //*******************************************************************************//
    //**************************** tbl_Prod_step ************************************//
    //*******************************************************************************//

    tblInf := @tblInfo[tbl_Prod_Step];
    while (IndexPD <= m_HostListPD.count - 1) and (Request > PTMQMPD(m_HostListPD[IndexPD]).PD_PREQ_NO) do
    begin
      inc(IndexPD);
    end;
    while (not EOL_Local(PD)) and (Request > PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_PREQ_NO) do
    begin
      Inc(m_Local_IndexPD);
    end;

    FirstCycle := true;
    HostHaveData := true;
    EndRequestDataHost := false;
    EndRequestDataLocal := false;
    while true do
    begin
      if (IndexPD > m_HostListPD.count - 1) or (Request < PTMQMPD(m_HostListPD[IndexPD]).PD_PREQ_NO)
      or (PReqChange(m_Req_Change_List[I]).ChangedType = DelReq) then EndRequestDataHost := true;
      if (EOL_Local(PD) or (Request < PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_PREQ_NO))
      then EndRequestDataLocal := true;

      if EndRequestDataHost and EndRequestDataLocal then break;

      Operation := DBEqual;

      if EndRequestDataHost then
      begin
        Operation := DBDelete;
        if FirstCycle then HostHaveData := false;
      end;
      FirstCycle := False;

      if EndRequestDataLocal then Operation := DBInsert;

      if Operation = DBEqual then
       begin
        TableNumberOfKeys := KeyNumPD;
        TableNumberOfFields := 64;
        HostFields[1] := PTMQMPD(m_HostListPD[IndexPD]).PD_PREQ_NO;
        HostFields[2] := PTMQMPD(m_HostListPD[IndexPD]).PD_PSTEP_ID;
        HostFields[3] := PTMQMPD(m_HostListPD[IndexPD]).PD_TO_SCHED;
        HostFields[4] := PTMQMPD(m_HostListPD[IndexPD]).PD_PRV_STEP_SCHED_MQM;
        HostFields[5] := PTMQMPD(m_HostListPD[IndexPD]).PD_PRV_STEP_TRUE;
        HostFields[6] := PTMQMPD(m_HostListPD[IndexPD]).PD_NEX_STEP_SCHED_MQM;
        HostFields[7] := PTMQMPD(m_HostListPD[IndexPD]).PD_NEX_STEP_TRUE;
        HostFields[8] := PTMQMPD(m_HostListPD[IndexPD]).PD_STEP_TYP;
      //  HostFields[9] := PTMQMPD(m_HostListPD[IndexPD]).PD_MAT_ARRV_DATE;
        HostFields[10] := PTMQMPD(m_HostListPD[IndexPD]).PD_FRC_MAT_DATE;
        HostFields[11] := PTMQMPD(m_HostListPD[IndexPD]).PD_PLAN_START;
        HostFields[12] := PTMQMPD(m_HostListPD[IndexPD]).PD_LOW_LIMIT_TIME_STRT;
        HostFields[13] := PTMQMPD(m_HostListPD[IndexPD]).PD_FRC_LOW_DATE;
        HostFields[14] := PTMQMPD(m_HostListPD[IndexPD]).PD_PLAN_END;
        HostFields[15] := PTMQMPD(m_HostListPD[IndexPD]).PD_HIGH_LIMIT_TIMEND;
        HostFields[16] := PTMQMPD(m_HostListPD[IndexPD]).PD_FRC_HIGH_DATE;
        HostFields[17] := PTMQMPD(m_HostListPD[IndexPD]).PD_WKCNTER;
        HostFields[18] := PTMQMPD(m_HostListPD[IndexPD]).PD_WKCT_PROC;
        HostFields[19] := PTMQMPD(m_HostListPD[IndexPD]).PD_INIT_QUENT;
        HostFields[20] := PTMQMPD(m_HostListPD[IndexPD]).PD_FIN_QUENT;
        HostFields[21] := PTMQMPD(m_HostListPD[IndexPD]).PD_WEIGHT;
        HostFields[22] := PTMQMPD(m_HostListPD[IndexPD]).PD_DESC_UM;
        HostFields[23] := PTMQMPD(m_HostListPD[IndexPD]).PD_CAL;
        HostFields[24] := FloatToStr(PTMQMPD(m_HostListPD[IndexPD]).PD_SETUP_TIME_STP);
        HostFields[25] := FloatToStr(PTMQMPD(m_HostListPD[IndexPD]).PD_EXC_TIME_STP);
        HostFields[26] := PTMQMPD(m_HostListPD[IndexPD]).PD_RES_NUM_PLN;
        HostFields[27] := PTMQMPD(m_HostListPD[IndexPD]).PD_ALLOW_SPLIT;
        HostFields[28] := PTMQMPD(m_HostListPD[IndexPD]).PD_STEP_HANDLE_REPROCES;
        HostFields[29] := PTMQMPD(m_HostListPD[IndexPD]).PD_STEP_PART_GEN_PLAN;
        HostFields[30] := PTMQMPD(m_HostListPD[IndexPD]).PD_STEP_CAN_GROUP;
        HostFields[31] := PTMQMPD(m_HostListPD[IndexPD]).PD_FORCED_GRP_NO;
        HostFields[32] := PTMQMPD(m_HostListPD[IndexPD]).PD_CONN_TYPE_PREV_STEP_SPLIT;
        HostFields[33] := PTMQMPD(m_HostListPD[IndexPD]).PD_FRC_OVERLAPP;
        HostFields[34] := PTMQMPD(m_HostListPD[IndexPD]).PD_STEP_CLOSED;
        HostFields[35] := 0;//PTMQMPD(m_HostListPD[IndexPD]).PD_USR_CG;
        HostFields[36] := 0;//PTMQMPD(m_HostListPD[IndexPD]).PD_USR_TM_CG;
        HostFields[37] := PTMQMPD(m_HostListPD[IndexPD]).PD_SchedulByMcm;
        HostFields[38] := PTMQMPD(m_HostListPD[IndexPD]).PD_SchedulByMqm;
        HostFields[39] := PTMQMPD(m_HostListPD[IndexPD]).PD_SplitFamily;
        HostFields[40] := PTMQMPD(m_HostListPD[IndexPD]).PD_LearningCurveCode;
        HostFields[41] := PTMQMPD(m_HostListPD[IndexPD]).PD_LearningCurveType;
        HostFields[42] := PTMQMPD(m_HostListPD[IndexPD]).PD_ApprovalDate;
        HostFields[43] := PTMQMPD(m_HostListPD[IndexPD]).PD_GRP_SEQUENCE;
        HostFields[44] := PTMQMPD(m_HostListPD[IndexPD]).PD_Prev_LeadTime_mqm;
        HostFields[45] := PTMQMPD(m_HostListPD[IndexPD]).PD_Next_LeadTime_mqm;
        HostFields[46] := PTMQMPD(m_HostListPD[IndexPD]).PD_Prev_LeadTimeBatch_mqm;
		    HostFields[47] := PTMQMPD(m_HostListPD[IndexPD]).PD_Next_LeadTimeBatch_mqm;
		    HostFields[48] := PTMQMPD(m_HostListPD[IndexPD]).PD_BatchSizePerStep;
        HostFields[49] := PTMQMPD(m_HostListPD[IndexPD]).PD_MinBatchSize;
        HostFields[50] := PTMQMPD(m_HostListPD[IndexPD]).PD_OptimumBatchSize;
        HostFields[51] := PTMQMPD(m_HostListPD[IndexPD]).PD_MaxBatchSize;
        HostFields[52] := PTMQMPD(m_HostListPD[IndexPD]).PD_OVERLAP_WITH_OTHER_STEPS;
		    HostFields[53] := PTMQMPD(m_HostListPD[IndexPD]).PD_PRV_STEP_SCHED_MCM;
		    HostFields[54] := PTMQMPD(m_HostListPD[IndexPD]).PD_NEX_STEP_SCHED_MCM;
        HostFields[55] := PTMQMPD(m_HostListPD[IndexPD]).PD_Prev_LeadTime_mcm;
        HostFields[56] := PTMQMPD(m_HostListPD[IndexPD]).PD_Next_LeadTime_mcm;
        HostFields[57] := PTMQMPD(m_HostListPD[IndexPD]).PD_Prev_LeadTimeBatch_mcm;
		    HostFields[58] := PTMQMPD(m_HostListPD[IndexPD]).PD_Next_LeadTimeBatch_mcm;
        HostFields[59] := PTMQMPD(m_HostListPD[IndexPD]).PD_INITIALPLANSCHEDDATETIME;
		    HostFields[60] := PTMQMPD(m_HostListPD[IndexPD]).PD_FINALPLANSCHEDDATETIME;
		    HostFields[61] := PTMQMPD(m_HostListPD[IndexPD]).PD_NumResComponents;
        HostFields[62] := PTMQMPD(m_HostListPD[IndexPD]).PD_MaxStartDateAutoSeq;
        HostFields[63] := PTMQMPD(m_HostListPD[IndexPD]).PD_ALTERNATIVEQTY;
        HostFields[64] := PTMQMPD(m_HostListPD[IndexPD]).PD_ALTERNATIVEUM;

        LocalFields[1] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_PREQ_NO;
        LocalFields[2] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_PSTEP_ID;
        LocalFields[3] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_TO_SCHED;
        LocalFields[4] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_PRV_STEP_SCHED_MQM;
        LocalFields[5] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_PRV_STEP_TRUE;
        LocalFields[6] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_NEX_STEP_SCHED_MQM;
        LocalFields[7] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_NEX_STEP_TRUE;
        LocalFields[8] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_STEP_TYP;
      //  LocalFields[9] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_MAT_ARRV_DATE;
        LocalFields[10] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_FRC_MAT_DATE;
        LocalFields[11] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_PLAN_START;
        LocalFields[12] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_LOW_LIMIT_TIME_STRT;
        LocalFields[13] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_FRC_LOW_DATE;
        LocalFields[14] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_PLAN_END;
        LocalFields[15] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_HIGH_LIMIT_TIMEND;
        LocalFields[16] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_FRC_HIGH_DATE;
        LocalFields[17] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_WKCNTER;
        LocalFields[18] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_WKCT_PROC;
        LocalFields[19] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_INIT_QUENT;
        LocalFields[20] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_FIN_QUENT;
        LocalFields[21] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_WEIGHT;
        LocalFields[22] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_DESC_UM;
        LocalFields[23] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_CAL;
        LocalFields[24] := FloatToStr(PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_SETUP_TIME_STP);
        LocalFields[25] := FloatToStr(PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_EXC_TIME_STP);
        LocalFields[26] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_RES_NUM_PLN;
        LocalFields[27] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_ALLOW_SPLIT;
        LocalFields[28] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_STEP_HANDLE_REPROCES;
        LocalFields[29] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_STEP_PART_GEN_PLAN;
        LocalFields[30] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_STEP_CAN_GROUP;
        LocalFields[31] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_FORCED_GRP_NO;
        LocalFields[32] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_CONN_TYPE_PREV_STEP_SPLIT;
        LocalFields[33] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_FRC_OVERLAPP;
        LocalFields[34] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_STEP_CLOSED;
        LocalFields[35] := 0;//PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_USR_CG;
        LocalFields[36] := 0;//PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_USR_TM_CG;
        LocalFields[37] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_SchedulByMcm;
        LocalFields[38] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_SchedulByMqm;
        LocalFields[39] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_SplitFamily;
        LocalFields[40] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_LearningCurveCode;
        LocalFields[41] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_LearningCurveType;
        LocalFields[42] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_ApprovalDate;
        LocalFields[43] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_GRP_SEQUENCE;
        LocalFields[44] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_Prev_LeadTime_mqm;
        LocalFields[45] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_Next_LeadTime_mqm;
        LocalFields[46] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_Prev_LeadTimeBatch_mqm;
		    LocalFields[47] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_Next_LeadTimeBatch_mqm;
		    LocalFields[48] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_BatchSizePerStep;
        LocalFields[49] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_MinBatchSize;
        LocalFields[50] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_OptimumBatchSize;
        LocalFields[51] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_MaxBatchSize;
        LocalFields[52] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_OVERLAP_WITH_OTHER_STEPS;
		    LocalFields[53] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_PRV_STEP_SCHED_MCM;
		    LocalFields[54] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_NEX_STEP_SCHED_MCM;
        LocalFields[55] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_Prev_LeadTime_mcm;
        LocalFields[56] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_Next_LeadTime_mcm;
        LocalFields[57] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_Prev_LeadTimeBatch_mcm;
		    LocalFields[58] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_Next_LeadTimeBatch_mcm;
        LocalFields[59] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_INITIALPLANSCHEDDATETIME;
		    LocalFields[60] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_FINALPLANSCHEDDATETIME;
        LocalFields[61] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_NumResComponents;
        LocalFields[62] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_MaxStartDateAutoSeq;
        LocalFields[63] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_ALTERNATIVEQTY;
        LocalFields[64] := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_ALTERNATIVEUM;

        Operation := CompareKeys(TableNumberOfKeys, TableNumberOfFields, HostFields, LocalFields);
      end;

      if (PReqChange(m_Req_Change_List[I]).ChangedType <> No)
      and (PReqChange(m_Req_Change_List[I]).ChangedType <> StepChangeOnly) then
           UpdatedWorkCenter := True
      else UpdatedWorkCenter := False;

      if (PReqChange(m_Req_Change_List[I]).ChangedType = StepChangeOnly) and RequestHasStepsInList then
      begin
        if Operation = DBDelete then
           StepToCheck := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_PSTEP_ID
        else
           StepToCheck := PTMQMPD(m_HostListPD[IndexPD]).PD_PSTEP_ID;
        J := IndexStep;
        While true do
        begin
          if (J > m_Req_Step_Change_List.count - 1) then break;
          if (Request < PStepChange(m_Req_Step_Change_List[J]).ProdReq) then break;
          if (StepToCheck < PStepChange(m_Req_Step_Change_List[J]).StepNr) then break;
          if (StepToCheck = PStepChange(m_Req_Step_Change_List[J]).StepNr) then
          begin
            if PStepChange(m_Req_Step_Change_List[J]).ChangedType <> NoChange then
               UpdatedWorkCenter := True;
            break;
          end;
          Inc(J);
        end;
      end;

      if UpdatedWorkCenter then
      begin
        if (Operation <> DBInsert) then
        begin
          WorkCenterToUpdate := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_WKCNTER;
          ToBeSched := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_TO_SCHED;
          if (ToBeSched = '1') and IsClientOpen and CheckWorkCenterChangeList(WorkCenterToUpdate) then
          begin
            InsertWCChangeReqToTable(false, MqmTrs, WorkCenterToUpdate);
            WcRecEntered := true
          end;
        end;

        if (Operation <> DBDelete) then
        begin
          WorkCenterToUpdate := PTMQMPD(m_HostListPD[IndexPD]).PD_WKCNTER;
          ToBeSched := PTMQMPD(m_HostListPD[IndexPD]).PD_TO_SCHED;
          if (ToBeSched = '1') and IsClientOpen and CheckWorkCenterChangeList(WorkCenterToUpdate) then
          begin
            InsertWCChangeReqToTable(false, MqmTrs, WorkCenterToUpdate);
            WcRecEntered := true
          end;
        end;
      end;

      if (not HostHaveData) and (PReqChange(m_Req_Change_List[I]).ChangedType = Historical) then
      begin
        if Operation = DBDelete then Inc(m_Local_IndexPD);
        if Operation = DBInsert then IndexPD := IndexPD + 1;
        if (Operation <> DBDelete) and (Operation <> DBInsert) then
        begin
          Inc(m_Local_IndexPD);
          IndexPD := IndexPD + 1;
        end;
        continue;
      end;

      if Operation = DBDelete then
      begin
        Temp_TimeVal := NOW;
        with QryDelPD do
        begin
          ParamByName(CreateFld(tblInf.pfx, fli_preqNo)).AsString := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_PREQ_NO;
          ParamByName(CreateFld(tblInf.pfx, fli_pstepId)).AsInteger := PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_PSTEP_ID;
        //  Prepare;
          ExecSQL;
          Temp_TimeVal := NOW - Temp_TimeVal;
          IniAppGlobals.Time_DelPD := IniAppGlobals.Time_DelPD + Temp_TimeVal;
          Inc(IniAppGlobals.Count_DelPD);
          RunCommit := true;
        end;

        Inc(m_Local_IndexPD);
        continue;
      end;

      if Operation = DBInsert then
      begin
      //  QryInsertPD.Connection.StartTransaction;
        Temp_TimeVal := NOW;
        with QryInsertPD do
        begin
          try
            ConvertDateFormatTo(PTMQMPD(m_HostListPD[IndexPD]).PD_ApprovalDate, DndArchiveLocalName);
          except
            PTMQMPD(m_HostListPD[IndexPD]).PD_ApprovalDate := 0;
          end;

          PTMQMPD(m_HostListPD[IndexPD]).PD_CreateDateTimeUTC := UTCNow;
          PTMQMPD(m_HostListPD[IndexPD]).PD_CrtOrUpdateDateTimeUTC := UTCNow;

          ParamByName('PD_PREQ_NO').AsString             := PTMQMPD(m_HostListPD[IndexPD]).PD_PREQ_NO;
          ParamByName('PD_PSTEP_ID').AsInteger           := PTMQMPD(m_HostListPD[IndexPD]).PD_PSTEP_ID;
          ParamByName('PD_TO_SCHED').AsString            := PTMQMPD(m_HostListPD[IndexPD]).PD_TO_SCHED;
          ParamByName('PD_PRV_STEP_SCHED_MQM').AsInteger := PTMQMPD(m_HostListPD[IndexPD]).PD_PRV_STEP_SCHED_MQM;
          ParamByName('PD_PRV_STEP_TRUE').AsInteger      := PTMQMPD(m_HostListPD[IndexPD]).PD_PRV_STEP_TRUE;
          ParamByName('PD_NEX_STEP_SCHED_MQM').AsInteger := PTMQMPD(m_HostListPD[IndexPD]).PD_NEX_STEP_SCHED_MQM;
          ParamByName('PD_NEX_STEP_TRUE').AsInteger      := PTMQMPD(m_HostListPD[IndexPD]).PD_NEX_STEP_TRUE;
          ParamByName('PD_STEP_TYP').AsString            := PTMQMPD(m_HostListPD[IndexPD]).PD_STEP_TYP;
          ParamByName('PD_MAT_ARRV_DATE').AsDateTime     := PTMQMPD(m_HostListPD[IndexPD]).PD_MAT_ARRV_DATE;
          ParamByName('PD_FRC_MAT_DATE').AsString        := PTMQMPD(m_HostListPD[IndexPD]).PD_FRC_MAT_DATE;
          ParamByName('PD_PLAN_START').AsDateTime        := PTMQMPD(m_HostListPD[IndexPD]).PD_PLAN_START;
          ParamByName('PD_LOW_LIMIT_TIME_STRT').AsDateTime := PTMQMPD(m_HostListPD[IndexPD]).PD_LOW_LIMIT_TIME_STRT;
          ParamByName('PD_FRC_LOW_DATE').AsString        := PTMQMPD(m_HostListPD[IndexPD]).PD_FRC_LOW_DATE;
          ParamByName('PD_PLAN_END').AsDateTime          := PTMQMPD(m_HostListPD[IndexPD]).PD_PLAN_END;
          ParamByName('PD_HIGH_LIMIT_TIMEND').AsDateTime := PTMQMPD(m_HostListPD[IndexPD]).PD_HIGH_LIMIT_TIMEND;
          ParamByName('PD_FRC_HIGH_DATE').AsString       := PTMQMPD(m_HostListPD[IndexPD]).PD_FRC_HIGH_DATE;
          ParamByName('PD_INI_PLAN_SCHED_DATE_TIME').AsDateTime := PTMQMPD(m_HostListPD[IndexPD]).PD_INITIALPLANSCHEDDATETIME;
          ParamByName('PD_FIN_PLAN_SCHED_DATE_TIME').AsDateTime := PTMQMPD(m_HostListPD[IndexPD]).PD_FINALPLANSCHEDDATETIME;
          ParamByName('PD_WKCNTER').AsString             := PTMQMPD(m_HostListPD[IndexPD]).PD_WKCNTER;
          ParamByName('PD_WKCT_PROC').AsString           := PTMQMPD(m_HostListPD[IndexPD]).PD_WKCT_PROC;
          ParamByName('PD_INIT_QUENT').AsFloat           := PTMQMPD(m_HostListPD[IndexPD]).PD_INIT_QUENT;
          ParamByName('PD_FIN_QUENT').AsFloat            := PTMQMPD(m_HostListPD[IndexPD]).PD_FIN_QUENT;
          ParamByName('PD_WEIGHT').AsFloat               := PTMQMPD(m_HostListPD[IndexPD]).PD_WEIGHT;
          ParamByName('PD_DESC_UM').AsString             := PTMQMPD(m_HostListPD[IndexPD]).PD_DESC_UM;
          ParamByName('PD_CAL').AsString                 := PTMQMPD(m_HostListPD[IndexPD]).PD_CAL;
          ParamByName('PD_SETUP_TIME_STP').AsFloat       := PTMQMPD(m_HostListPD[IndexPD]).PD_SETUP_TIME_STP;
          ParamByName('PD_EXC_TIME_STP').AsFloat         := PTMQMPD(m_HostListPD[IndexPD]).PD_EXC_TIME_STP;
          ParamByName('PD_RES_NUM_PLN').AsFloat          := PTMQMPD(m_HostListPD[IndexPD]).PD_RES_NUM_PLN;
          ParamByName('PD_ALLOW_SPLIT').AsString         := PTMQMPD(m_HostListPD[IndexPD]).PD_ALLOW_SPLIT;
          ParamByName('PD_STEP_HANDLE_REPROCES').AsString := PTMQMPD(m_HostListPD[IndexPD]).PD_STEP_HANDLE_REPROCES;
          ParamByName('PD_STEP_PART_GEN_PLAN').AsString  := PTMQMPD(m_HostListPD[IndexPD]).PD_STEP_PART_GEN_PLAN;
          ParamByName('PD_STEP_CAN_GROUP').AsString      := PTMQMPD(m_HostListPD[IndexPD]).PD_STEP_CAN_GROUP;
          ParamByName('PD_FORCED_GRP_NO').AsFloat        := PTMQMPD(m_HostListPD[IndexPD]).PD_FORCED_GRP_NO;
          ParamByName('PD_CONN_TYPE_PREV_STEP_SPLIT').AsString := PTMQMPD(m_HostListPD[IndexPD]).PD_CONN_TYPE_PREV_STEP_SPLIT;
          ParamByName('PD_FRC_OVERLAPP').AsString        := PTMQMPD(m_HostListPD[IndexPD]).PD_FRC_OVERLAPP;
          ParamByName('PD_STEP_CLOSED').AsString         := PTMQMPD(m_HostListPD[IndexPD]).PD_STEP_CLOSED;
          ParamByName('PD_USR_NAMECG').AsString          := PTMQMPD(m_HostListPD[IndexPD]).PD_USR_CG;
          ParamByName('PD_USR_TIMECG').AsDateTime        := PTMQMPD(m_HostListPD[IndexPD]).PD_USR_TM_CG;
          ParamByName('PD_SCHDULE_BY_MCM').AsString      := PTMQMPD(m_HostListPD[IndexPD]).PD_SchedulByMcm;
          ParamByName('PD_SPLITED_FAMILY').AsString      := PTMQMPD(m_HostListPD[IndexPD]).PD_SplitFamily;
          ParamByName('PD_LEARNING_CURVE_CODE').AsString := PTMQMPD(m_HostListPD[IndexPD]).PD_LearningCurveCode;
          ParamByName('PD_LEARNING_CURVE_TYPE').AsString := PTMQMPD(m_HostListPD[IndexPD]).PD_LearningCurveType;
          ParamByName('PD_OVERLAP_WITH_OTHER_STEPS').AsString := PTMQMPD(m_HostListPD[IndexPD]).PD_OVERLAP_WITH_OTHER_STEPS;
          ParamByName('PD_APPROVAL_DATE').AsDateTime     := PTMQMPD(m_HostListPD[IndexPD]).PD_ApprovalDate;
          ParamByName('PD_GRP_SEQUENCE').AsString        := PTMQMPD(m_HostListPD[IndexPD]).PD_GRP_SEQUENCE;
          ParamByName('PD_PREV_LEAD_TIME_MQM').AsFloat   := PTMQMPD(m_HostListPD[IndexPD]).PD_Prev_LeadTime_mqm;
          ParamByName('PD_NEXT_LEAD_TIME_MQM').AsFloat   := PTMQMPD(m_HostListPD[IndexPD]).PD_Next_LeadTime_mqm;
          ParamByName('PD_PREV_LEAD_TIME_BATCH_MQM').AsFloat := PTMQMPD(m_HostListPD[IndexPD]).PD_Prev_LeadTimeBatch_mqm;
          ParamByName('PD_NEXT_LEAD_TIME_BATCH_MQM').AsFloat := PTMQMPD(m_HostListPD[IndexPD]).PD_Next_LeadTimeBatch_mqm;
          ParamByName('PD_BATCH_SIZE_PER_STEP').AsString := PTMQMPD(m_HostListPD[IndexPD]).PD_BatchSizePerStep;
          ParamByName('PD_MIN_BATCH_SIZE').AsFloat       := PTMQMPD(m_HostListPD[IndexPD]).PD_MinBatchSize;
          ParamByName('PD_OPTIMUM_BATCH_SIZE').AsFloat   := PTMQMPD(m_HostListPD[IndexPD]).PD_OptimumBatchSize;
          ParamByName('PD_MAX_BATCH_SIZE').AsFloat       := PTMQMPD(m_HostListPD[IndexPD]).PD_MaxBatchSize;
          ParamByName('PD_SCHDULE_BY_MQM').AsString      := PTMQMPD(m_HostListPD[IndexPD]).PD_SchedulByMqm;
          ParamByName('PD_PRV_STEP_SCHED_MCM').AsInteger := PTMQMPD(m_HostListPD[IndexPD]).PD_PRV_STEP_SCHED_MCM;
          ParamByName('PD_NEX_STEP_SCHED_MCM').AsInteger := PTMQMPD(m_HostListPD[IndexPD]).PD_NEX_STEP_SCHED_MCM;
          ParamByName('PD_PREV_LEAD_TIME_MCM').AsFloat   := PTMQMPD(m_HostListPD[IndexPD]).PD_Prev_LeadTime_Mcm;
          ParamByName('PD_NEXT_LEAD_TIME_MCM').AsFloat   := PTMQMPD(m_HostListPD[IndexPD]).PD_Next_LeadTime_Mcm;
          ParamByName('PD_PREV_LEAD_TIME_BATCH_MCM').AsFloat := PTMQMPD(m_HostListPD[IndexPD]).PD_Prev_LeadTimeBatch_mcm;
          ParamByName('PD_NEXT_LEAD_TIME_BATCH_MCM').AsFloat := PTMQMPD(m_HostListPD[IndexPD]).PD_Next_LeadTimeBatch_mcm;
          ParamByName('PD_NUM_RSC_COMPONENTS').AsInteger := PTMQMPD(m_HostListPD[IndexPD]).PD_NumResComponents;
          ParamByName('PD_MAX_STARTDATE_AUTOSEQ').AsDateTime := PTMQMPD(m_HostListPD[IndexPD]).PD_MaxStartDateAutoSeq;
          ParamByName('PD_ALTERNATIVEQTY').AsFloat       := PTMQMPD(m_HostListPD[IndexPD]).PD_ALTERNATIVEQTY;
          ParamByName('PD_ALTERNATIVEUM').AsString       := PTMQMPD(m_HostListPD[IndexPD]).PD_ALTERNATIVEUM;
          ParamByName('PD_CREATE_DATE_TIME_UTC').AsDateTime  := PTMQMPD(m_HostListPD[IndexPD]).PD_CreateDateTimeUTC;
          ParamByName('PD_UPDATED_DATE_TIME_UTC').AsDateTime := PTMQMPD(m_HostListPD[IndexPD]).PD_CrtOrUpdateDateTimeUTC;
          ParamByName('PD_IDENTIFIER').AsString          := IniAppGlobals.Identifier;

          try
            ExecSQL;
            RunCommit := true;
          except
          end;
          Temp_TimeVal := NOW - Temp_TimeVal;
          IniAppGlobals.Time_InsertPD := IniAppGlobals.Time_InsertPD + Temp_TimeVal;
          Inc(IniAppGlobals.Count_InsertPD);
        end;
        IndexPD := IndexPD + 1;
        continue;
      end;

      if Operation = DBUpdate then
      begin
        Temp_TimeVal := NOW;
        with QryUpdatePD do
        begin
          if PTMQMPD(m_HostListPD[IndexPD]).PD_WEIGHT > 999999999 then
            PTMQMPD(m_HostListPD[IndexPD]).PD_WEIGHT := 999999999;

          PTMQMPD(m_HostListPD[IndexPD]).PD_CrtOrUpdateDateTimeUTC := UTCNow;

          ParamByName('PD_TO_SCHED').AsString            := PTMQMPD(m_HostListPD[IndexPD]).PD_TO_SCHED;
          ParamByName('PD_PRV_STEP_SCHED_MQM').AsInteger := PTMQMPD(m_HostListPD[IndexPD]).PD_PRV_STEP_SCHED_MQM;
          ParamByName('PD_PRV_STEP_TRUE').AsInteger      := PTMQMPD(m_HostListPD[IndexPD]).PD_PRV_STEP_TRUE;
          ParamByName('PD_NEX_STEP_SCHED_MQM').AsInteger := PTMQMPD(m_HostListPD[IndexPD]).PD_NEX_STEP_SCHED_MQM;
          ParamByName('PD_NEX_STEP_TRUE').AsInteger      := PTMQMPD(m_HostListPD[IndexPD]).PD_NEX_STEP_TRUE;
          ParamByName('PD_STEP_TYP').AsString            := PTMQMPD(m_HostListPD[IndexPD]).PD_STEP_TYP;
          ParamByName('PD_MAT_ARRV_DATE').AsDateTime     := PTMQMPD(m_HostListPD[IndexPD]).PD_MAT_ARRV_DATE;
          ParamByName('PD_FRC_MAT_DATE').AsString        := PTMQMPD(m_HostListPD[IndexPD]).PD_FRC_MAT_DATE;
          ParamByName('PD_PLAN_START').AsDateTime        := PTMQMPD(m_HostListPD[IndexPD]).PD_PLAN_START;
          ParamByName('PD_LOW_LIMIT_TIME_STRT').AsDateTime := PTMQMPD(m_HostListPD[IndexPD]).PD_LOW_LIMIT_TIME_STRT;
          ParamByName('PD_FRC_LOW_DATE').AsString        := PTMQMPD(m_HostListPD[IndexPD]).PD_FRC_LOW_DATE;
          ParamByName('PD_PLAN_END').AsDateTime          := PTMQMPD(m_HostListPD[IndexPD]).PD_PLAN_END;
          ParamByName('PD_HIGH_LIMIT_TIMEND').AsDateTime := PTMQMPD(m_HostListPD[IndexPD]).PD_HIGH_LIMIT_TIMEND;
          ParamByName('PD_FRC_HIGH_DATE').AsString       := PTMQMPD(m_HostListPD[IndexPD]).PD_FRC_HIGH_DATE;
          ParamByName('PD_INI_PLAN_SCHED_DATE_TIME').AsDateTime := PTMQMPD(m_HostListPD[IndexPD]).PD_INITIALPLANSCHEDDATETIME;
          ParamByName('PD_FIN_PLAN_SCHED_DATE_TIME').AsDateTime := PTMQMPD(m_HostListPD[IndexPD]).PD_FINALPLANSCHEDDATETIME;
          ParamByName('PD_WKCNTER').AsString             := PTMQMPD(m_HostListPD[IndexPD]).PD_WKCNTER;
          ParamByName('PD_WKCT_PROC').AsString           := PTMQMPD(m_HostListPD[IndexPD]).PD_WKCT_PROC;
          ParamByName('PD_INIT_QUENT').AsFloat           := PTMQMPD(m_HostListPD[IndexPD]).PD_INIT_QUENT;
          ParamByName('PD_FIN_QUENT').AsFloat            := PTMQMPD(m_HostListPD[IndexPD]).PD_FIN_QUENT;
          ParamByName('PD_WEIGHT').AsFloat               := PTMQMPD(m_HostListPD[IndexPD]).PD_WEIGHT;
          ParamByName('PD_DESC_UM').AsString             := PTMQMPD(m_HostListPD[IndexPD]).PD_DESC_UM;
          ParamByName('PD_CAL').AsString                 := PTMQMPD(m_HostListPD[IndexPD]).PD_CAL;
          ParamByName('PD_SETUP_TIME_STP').AsFloat       := PTMQMPD(m_HostListPD[IndexPD]).PD_SETUP_TIME_STP;
          ParamByName('PD_EXC_TIME_STP').AsFloat         := PTMQMPD(m_HostListPD[IndexPD]).PD_EXC_TIME_STP;
          ParamByName('PD_RES_NUM_PLN').AsFloat          := PTMQMPD(m_HostListPD[IndexPD]).PD_RES_NUM_PLN;
          ParamByName('PD_NUM_RSC_COMPONENTS').AsInteger := PTMQMPD(m_HostListPD[IndexPD]).PD_NumResComponents;
          ParamByName('PD_ALLOW_SPLIT').AsString         := PTMQMPD(m_HostListPD[IndexPD]).PD_ALLOW_SPLIT;
          ParamByName('PD_STEP_HANDLE_REPROCES').AsString := PTMQMPD(m_HostListPD[IndexPD]).PD_STEP_HANDLE_REPROCES;
          ParamByName('PD_STEP_PART_GEN_PLAN').AsString  := PTMQMPD(m_HostListPD[IndexPD]).PD_STEP_PART_GEN_PLAN;
          ParamByName('PD_STEP_CAN_GROUP').AsString      := PTMQMPD(m_HostListPD[IndexPD]).PD_STEP_CAN_GROUP;
          ParamByName('PD_FORCED_GRP_NO').AsFloat        := PTMQMPD(m_HostListPD[IndexPD]).PD_FORCED_GRP_NO;
          ParamByName('PD_CONN_TYPE_PREV_STEP_SPLIT').AsString := PTMQMPD(m_HostListPD[IndexPD]).PD_CONN_TYPE_PREV_STEP_SPLIT;
          ParamByName('PD_FRC_OVERLAPP').AsString        := PTMQMPD(m_HostListPD[IndexPD]).PD_FRC_OVERLAPP;
          ParamByName('PD_STEP_CLOSED').AsString         := PTMQMPD(m_HostListPD[IndexPD]).PD_STEP_CLOSED;
          ParamByName('PD_USR_NAMECG').AsString          := PTMQMPD(m_HostListPD[IndexPD]).PD_USR_CG;
          ParamByName('PD_USR_TIMECG').AsDateTime        := PTMQMPD(m_HostListPD[IndexPD]).PD_USR_TM_CG;
          ParamByName('PD_SCHDULE_BY_MCM').AsString      := PTMQMPD(m_HostListPD[IndexPD]).PD_SchedulByMcm;
          ParamByName('PD_SCHDULE_BY_MQM').AsString      := PTMQMPD(m_HostListPD[IndexPD]).PD_SchedulByMqm;
          ParamByName('PD_PREV_LEAD_TIME_MQM').AsFloat   := PTMQMPD(m_HostListPD[IndexPD]).PD_Prev_LeadTime_mqm;
          ParamByName('PD_NEXT_LEAD_TIME_MQM').AsFloat   := PTMQMPD(m_HostListPD[IndexPD]).PD_Next_LeadTime_mqm;
          ParamByName('PD_PREV_LEAD_TIME_BATCH_MQM').AsFloat := PTMQMPD(m_HostListPD[IndexPD]).PD_Prev_LeadTimeBatch_mqm;
          ParamByName('PD_NEXT_LEAD_TIME_BATCH_MQM').AsFloat := PTMQMPD(m_HostListPD[IndexPD]).PD_Next_LeadTimeBatch_mqm;
          ParamByName('PD_PRV_STEP_SCHED_MCM').AsInteger := PTMQMPD(m_HostListPD[IndexPD]).PD_PRV_STEP_SCHED_MCM;
          ParamByName('PD_NEX_STEP_SCHED_MCM').AsInteger := PTMQMPD(m_HostListPD[IndexPD]).PD_NEX_STEP_SCHED_MCM;
          ParamByName('PD_PREV_LEAD_TIME_MCM').AsFloat   := PTMQMPD(m_HostListPD[IndexPD]).PD_Prev_LeadTime_Mcm;
          ParamByName('PD_NEXT_LEAD_TIME_MCM').AsFloat   := PTMQMPD(m_HostListPD[IndexPD]).PD_Next_LeadTime_Mcm;
          ParamByName('PD_PREV_LEAD_TIME_BATCH_MCM').AsFloat := PTMQMPD(m_HostListPD[IndexPD]).PD_Prev_LeadTimeBatch_mcm;
          ParamByName('PD_NEXT_LEAD_TIME_BATCH_MCM').AsFloat := PTMQMPD(m_HostListPD[IndexPD]).PD_Next_LeadTimeBatch_mcm;
          ParamByName('PD_APPROVAL_DATE').AsDateTime     := PTMQMPD(m_HostListPD[IndexPD]).PD_ApprovalDate;
          ParamByName('PD_GRP_SEQUENCE').AsString        := PTMQMPD(m_HostListPD[IndexPD]).PD_GRP_SEQUENCE;
          ParamByName('PD_LEARNING_CURVE_CODE').AsString := PTMQMPD(m_HostListPD[IndexPD]).PD_LearningCurveCode;
          ParamByName('PD_LEARNING_CURVE_TYPE').AsString := PTMQMPD(m_HostListPD[IndexPD]).PD_LearningCurveType;
          ParamByName('PD_BATCH_SIZE_PER_STEP').AsString := PTMQMPD(m_HostListPD[IndexPD]).PD_BatchSizePerStep;
          ParamByName('PD_MIN_BATCH_SIZE').AsFloat       := PTMQMPD(m_HostListPD[IndexPD]).PD_MinBatchSize;
          ParamByName('PD_OPTIMUM_BATCH_SIZE').AsFloat   := PTMQMPD(m_HostListPD[IndexPD]).PD_OptimumBatchSize;
          ParamByName('PD_MAX_BATCH_SIZE').AsFloat       := PTMQMPD(m_HostListPD[IndexPD]).PD_MaxBatchSize;
          ParamByName('PD_MAX_STARTDATE_AUTOSEQ').AsDateTime := PTMQMPD(m_HostListPD[IndexPD]).PD_MaxStartDateAutoSeq;
          ParamByName('PD_ALTERNATIVEQTY').AsFloat       := PTMQMPD(m_HostListPD[IndexPD]).PD_ALTERNATIVEQTY;
          ParamByName('PD_ALTERNATIVEUM').AsString       := PTMQMPD(m_HostListPD[IndexPD]).PD_ALTERNATIVEUM;
          ParamByName('PD_SPLITED_FAMILY').AsString      := PTMQMPD(m_HostListPD[IndexPD]).PD_SplitFamily;
          ParamByName('PD_OVERLAP_WITH_OTHER_STEPS').AsString := PTMQMPD(m_HostListPD[IndexPD]).PD_OVERLAP_WITH_OTHER_STEPS;
          ParamByName('PD_UPDATED_DATE_TIME_UTC').AsDateTime := PTMQMPD(m_HostListPD[IndexPD]).PD_CrtOrUpdateDateTimeUTC;
          ParamByName('PD_PREQ_NO').AsString             := PTMQMPD(m_HostListPD[IndexPD]).PD_PREQ_NO;
          ParamByName('PD_PSTEP_ID').AsInteger           := PTMQMPD(m_HostListPD[IndexPD]).PD_PSTEP_ID;

          try
            ExecSQL;
          except
          end;
          Temp_TimeVal := NOW - Temp_TimeVal;
          IniAppGlobals.Time_UpdatePD := IniAppGlobals.Time_UpdatePD + Temp_TimeVal;
          Inc(IniAppGlobals.Count_UpdatePD);
          RunCommit := true;
        end;
      end;
      Inc(m_Local_IndexPD);
      IndexPD := IndexPD + 1;
    end;

    //*******************************************************************************//
    //**************************** tbl_Prod_sched ***********************************//
    //*******************************************************************************//

    tblInf := @tblInfo[tbl_prod_sched];

    while (not SrvQryPS.Eof) and (Request > Trim(SrvQryPS.FieldByName(CreateFld(tblInf.pfx, fli_preqNo)).AsString)) do
    begin
      SrvQryPS.next;
    end;

    while true do
    begin
      if SrvQryPS.Eof then break;
      if Request < Trim(SrvQryPS.FieldByName(CreateFld(tblInf.pfx, fli_preqNo)).AsString) then break;

      PSDelete  := False;
      PSUnsched := False;

      if (PReqChange(m_Req_Change_List[I]).ChangedType = NewReq) then
      begin
        PSDelete  := True;
        Reason := 'New Req';
      end;
      if (PReqChange(m_Req_Change_List[I]).ChangedType = DelReq) then
      begin
        PSDelete  := True;
        Reason := 'deleted Req';
      end;

      if (PReqChange(m_Req_Change_List[I]).ChangedType = HeadrFieldsChange) then
      begin
        PSDelete  := True;
        Reason := 'HeadrFieldsChange';
      end;

      if (PReqChange(m_Req_Change_List[I]).ChangedType = HeadrPropChange) then
      begin
        PSUnsched := True;
        Reason := 'HeadrPropChange';
      end;

      //if (PReqChange(m_Req_Change_List[I]).ChangedType = StepChangeOnly) and RequestHasStepsInList then
      if RequestHasStepsInList then
      begin
        StepToCheck := srvQryPS.FieldByName(CreateFld(tblInf.pfx, fli_pstepId)).AsInteger;
        J := IndexStep;
        While true do
        begin
          if (J > m_Req_Step_Change_List.count - 1) then break;
          if (Request < PStepChange(m_Req_Step_Change_List[J]).ProdReq) then break;
          if (StepToCheck < PStepChange(m_Req_Step_Change_List[J]).StepNr) then break;
          if (StepToCheck = PStepChange(m_Req_Step_Change_List[J]).StepNr) then
          begin
            if (PStepChange(m_Req_Step_Change_List[J]).ChangedType = NewStep) then
            begin
              PSDelete  := True;
              Reason := 'New Step';
            end;
            if (PStepChange(m_Req_Step_Change_List[J]).ChangedType = DelStep) then
            begin
              PSDelete  := True;
              Reason := 'Deleted Step';
            end;

            if (PStepChange(m_Req_Step_Change_List[J]).ChangedType = StepFieldChange) then
            begin
              PSDelete  := True;
              Reason := 'StepFieldChange';
            end;
            if (PStepChange(m_Req_Step_Change_List[J]).ChangedType = StepPropChange) then
            begin
              PSUnsched := True;
              Reason := 'StepPropChange';
            end;
            break;
          end;
          Inc(J);
        end;
      end;

      if PSDelete then
      begin
        with QryDelPS do
        begin
          Req  := Trim(srvQryPS.FieldByName(CreateFld(tblInf.pfx, fli_preqNo)).AsString);
          Step := srvQryPS.FieldByName(CreateFld(tblInf.pfx, fli_pstepId)).AsInteger;
          SubStep := srvQryPS.FieldByName(CreateFld(tblInf.pfx, fli_psubstId)).AsInteger;
          RePRoc  := srvQryPS.FieldByName(CreateFld(tblInf.pfx, fli_reprocNo)).AsInteger;
          Resource := Trim(srvQryPS.FieldByName(CreateFld(tblInf.pfx, fli_rsc)).AsString);
          schedType := Trim(srvQryPS.FieldByName(CreateFld(tblInf.pfx, fli_schedType)).AsString);
          StartDate := srvQryPS.FieldByName(CreateFld(tblInf.pfx, fli_schedStart)).AsDateTime;
          EndDate   := srvQryPS.FieldByName(CreateFld(tblInf.pfx, fli_schedEnd)).AsDateTime;
          Qty       := srvQryPS.FieldByName(CreateFld(tblInf.pfx, fli_quant)).AsFloat;
          Temp_TimeVal := NOW;
       //   try
            if Reason = 'HeadrFieldsChange' then
              WriteLogLineToDBFromServer('S', Req , Step, SubStep, RePRoc,'Dlt','D',Resource,StartDate, EndDate, Qty, schedType, PReqChange(m_Req_Change_List[I]).Reason)
            else if Reason = 'StepFieldChange' then
              WriteLogLineToDBFromServer('S', Req , Step, SubStep, RePRoc,'Dlt','D',Resource,StartDate, EndDate, Qty, schedType, PStepChange(m_Req_Step_Change_List[J]).Reason)
            else
              WriteLogLineToDBFromServer('S', Req , Step, SubStep, RePRoc,'Dlt','D',Resource,StartDate, EndDate, Qty, schedType, Reason);

          Temp_TimeVal := NOW - Temp_TimeVal;
          IniAppGlobals.Time_WriteLogLineToDBFromServer := IniAppGlobals.Time_WriteLogLineToDBFromServer + Temp_TimeVal;
        //  except
        //  end;
          Temp_TimeVal := NOW;
          SqlUpdate := '';
          SqlUpdate :=  SqlUpdate + ' delete from ' + tblInf.GetTableName + ' where ';
          SqlUpdate :=  SqlUpdate + CreateFld(tblInf.pfx, fli_preqNo) + '=' + '''' + Trim(srvQryPS.FieldByName(CreateFld(tblInf.pfx, fli_preqNo)).AsString) + '''' + ' AND ';
          SqlUpdate :=  SqlUpdate + CreateFld(tblInf.pfx, fli_pstepId) + '=' + '''' + IntToStr(srvQryPS.FieldByName(CreateFld(tblInf.pfx, fli_pstepId)).AsInteger) + '''' + ' AND ';
          SqlUpdate :=  SqlUpdate + CreateFld(tblInf.pfx, fli_psubstId) + '=' + '''' + IntToStr(srvQryPS.FieldByName(CreateFld(tblInf.pfx, fli_psubstId)).AsInteger) + '''' + ' AND ';
          SqlUpdate :=  SqlUpdate + CreateFld(tblInf.pfx, fli_reprocNo) + '=' + '''' + IntToStr(srvQryPS.FieldByName(CreateFld(tblInf.pfx, fli_reprocNo)).AsInteger) + '''';
          SqlUpdate :=  SqlUpdate + AND_IDF_Condition(CreateFld(tblInf.pfx, fli_IDENTIFIER));
          Sql.Clear;
          SQL.Add(SqlUpdate);
        //  Prepare;
          ExecSQL;
          Temp_TimeVal := NOW - Temp_TimeVal;
          IniAppGlobals.Time_DelPS := IniAppGlobals.Time_DelPS + Temp_TimeVal;
          Inc(IniAppGlobals.Count_DelPS);
          RunCommit := true;
        end;
      end;

      if PSUnsched then
      begin
        with QryUpdatePS do
        begin
          Req  := Trim(srvQryPS.FieldByName(CreateFld(tblInf.pfx, fli_preqNo)).AsString);
          Step := srvQryPS.FieldByName(CreateFld(tblInf.pfx, fli_pstepId)).AsInteger;
          SubStep := srvQryPS.FieldByName(CreateFld(tblInf.pfx, fli_psubstId)).AsInteger;
          RePRoc  := srvQryPS.FieldByName(CreateFld(tblInf.pfx, fli_reprocNo)).AsInteger;
          Resource := Trim(srvQryPS.FieldByName(CreateFld(tblInf.pfx, fli_rsc)).AsString);
          schedType := Trim(srvQryPS.FieldByName(CreateFld(tblInf.pfx, fli_schedType)).AsString);
          StartDate := srvQryPS.FieldByName(CreateFld(tblInf.pfx, fli_schedStart)).AsDateTime;
          EndDate   := srvQryPS.FieldByName(CreateFld(tblInf.pfx, fli_schedEnd)).AsDateTime;
          Qty       := srvQryPS.FieldByName(CreateFld(tblInf.pfx, fli_quant)).AsFloat;
          Temp_TimeVal := NOW;
       //   try
            if Reason = 'HeadrPropChange' then
              WriteLogLineToDBFromServer('S', Req , Step, SubStep, RePRoc,'Upd','U',Resource,StartDate, EndDate, Qty, schedType, PReqChange(m_Req_Change_List[I]).Reason)
            else if Reason = 'StepPropChange' then
              WriteLogLineToDBFromServer('S', Req , Step, SubStep, RePRoc,'Upd','U',Resource,StartDate, EndDate, Qty, schedType, PStepChange(m_Req_Step_Change_List[J]).Reason)
            else
              WriteLogLineToDBFromServer('S', Req , Step, SubStep, RePRoc,'Upd','U',Resource,StartDate, EndDate, Qty, schedType, Reason);
          Temp_TimeVal := NOW - Temp_TimeVal;
          IniAppGlobals.Time_WriteLogLineToDBFromServer := IniAppGlobals.Time_WriteLogLineToDBFromServer + Temp_TimeVal;

        //  except
       //   end;
          Temp_TimeVal := NOW;
          SqlUpdate := '';
          SqlUpdate :=  SqlUpdate + 'update ' + tblInf.GetTableName + ' set ';
          SqlUpdate :=  SqlUpdate + 'PS_RSC_CODE = :PS_RSC_CODE' + DecSep;
          SqlUpdate :=  SqlUpdate + 'PS_WKCNTER = :PS_WKCNTER' + DecSep;
          SqlUpdate :=  SqlUpdate + 'PS_WKCT_PROC = :PS_WKCT_PROC' + DecSep;
          SqlUpdate :=  SqlUpdate + 'PS_SCHED_TYPE = :PS_SCHED_TYPE';
          SqlUpdate :=  SqlUpdate + ' Where';
          SqlUpdate :=  SqlUpdate + ' PS_PREQ_NO = :PS_PREQ_NO';
          SqlUpdate :=  SqlUpdate + ' AND';
          SqlUpdate :=  SqlUpdate + ' PS_PSTEP_ID = :PS_PSTEP_ID';
          SqlUpdate :=  SqlUpdate + ' AND';
          SqlUpdate :=  SqlUpdate + ' PS_PSUBST_ID = :PS_PSUBST_ID';
          SqlUpdate :=  SqlUpdate + ' AND';
          SqlUpdate :=  SqlUpdate + ' PS_REPROC_NO = :PS_REPROC_NO';
          SqlUpdate :=  SqlUpdate + AND_IDF_Condition(CreateFld(tblInf.pfx, fli_IDENTIFIER));
          Sql.Clear;

          SqlUpdate := SetDecSeparator(SqlUpdate);
          SQL.Add(SqlUpdate);
          ParamByName('PS_RSC_CODE').Value       := '';
          ParamByName('PS_WKCNTER').Value        := '';
          ParamByName('PS_WKCT_PROC').Value      := '';
          ParamByName('PS_SCHED_TYPE').Value     := '0';
          ParamByName('PS_PREQ_NO').Value := srvQryPS.FieldByName(CreateFld(tblInf.pfx, fli_preqNo)).AsString;
          ParamByName('PS_PSTEP_ID').Value := srvQryPS.FieldByName(CreateFld(tblInf.pfx, fli_pstepId)).AsInteger;
          ParamByName('PS_PSUBST_ID').Value := srvQryPS.FieldByName(CreateFld(tblInf.pfx, fli_psubstId)).AsInteger;
          ParamByName('PS_REPROC_NO').Value := srvQryPS.FieldByName(CreateFld(tblInf.pfx, fli_reprocNo)).AsInteger;
          try
            ExecSQL;

          except
          end;
          Temp_TimeVal := NOW - Temp_TimeVal;
            IniAppGlobals.Time_UpdatePS := IniAppGlobals.Time_UpdatePS + Temp_TimeVal;
            Inc(IniAppGlobals.Count_UpdatePS);
          RunCommit := true;
        end;
      end;

      srvQryPS.next;
      continue;
    end;

    //*******************************************************************************//
    //**************************** tbl_Prod_sched_mcm ***********************************//
    //*******************************************************************************//

    tblInf := @tblInfo[tbl_prod_sched_mcm];

    while (not SrvQryPSMCM.Eof) and (Request > Trim(SrvQryPSMCM.FieldByName(CreateFld(tblInf.pfx, fli_preqNo)).AsString)) do
    begin
      SrvQryPSMCM.next;
    end;

    while true do
    begin
      if SrvQryPSMCM.Eof then break;
      if Request < Trim(SrvQryPSMCM.FieldByName(CreateFld(tblInf.pfx, fli_preqNo)).AsString) then break;

      PSDelete  := False;
      PSUnsched := False;

      if (PReqChange(m_Req_Change_List[I]).ChangedType = NewReq) then
      begin
        PSDelete  := True;
        Reason := 'New Req';
      end;

      if (PReqChange(m_Req_Change_List[I]).ChangedType = DelReq) then
      begin
        PSDelete  := True;
        Reason := 'Deleted Req';
      end;

      if (PReqChange(m_Req_Change_List[I]).ChangedType = HeadrFieldsChange) then
      begin
        PSDelete  := True;
        Reason := 'HeadrFieldsChange';
      end;

      if (PReqChange(m_Req_Change_List[I]).ChangedType = HeadrPropChange) then
      begin
        PSUnsched := True;
        Reason := 'HeadrPropChange';
      end;

      //if (PReqChange(m_Req_Change_List[I]).ChangedType = StepChangeOnly) and RequestHasStepsInList then
      if RequestHasStepsInList then
      begin
        StepToCheck := SrvQryPSMCM.FieldByName(CreateFld(tblInf.pfx, fli_pstepId)).AsInteger;
        J := IndexStep;
        While true do
        begin
          if (J > m_Req_Step_Change_List.count - 1) then break;
          if (Request < PStepChange(m_Req_Step_Change_List[J]).ProdReq) then break;
          if (StepToCheck < PStepChange(m_Req_Step_Change_List[J]).StepNr) then break;
          if (StepToCheck = PStepChange(m_Req_Step_Change_List[J]).StepNr) then
          begin
            if (PStepChange(m_Req_Step_Change_List[J]).ChangedType = NewStep) then
            begin
              PSDelete  := True;
              Reason := 'New Step';
            end;

            if (PStepChange(m_Req_Step_Change_List[J]).ChangedType = DelStep) then
            begin
              PSDelete  := True;
              Reason := 'Deleted Step';
            end;

            if (PStepChange(m_Req_Step_Change_List[J]).ChangedType = StepFieldChange) then
            begin
              PSDelete  := True;
              Reason := 'StepFieldChange';
            end;
            if (PStepChange(m_Req_Step_Change_List[J]).ChangedType = StepPropChange) then
            begin
              PSUnsched := True;
              Reason := 'StepPropChange';
            end;
            break;
          end;
          Inc(J);
        end;
      end;

      if PSDelete then
      begin
        with QryDelPSMCM do
        begin
          Req  := Trim(SrvQryPSMCM.FieldByName(CreateFld(tblInf.pfx, fli_preqNo)).AsString);
          Step := SrvQryPSMCM.FieldByName(CreateFld(tblInf.pfx, fli_pstepId)).AsInteger;
          SubStep := SrvQryPSMCM.FieldByName(CreateFld(tblInf.pfx, fli_psubstId)).AsInteger;
          RePRoc  := SrvQryPSMCM.FieldByName(CreateFld(tblInf.pfx, fli_reprocNo)).AsInteger;
          Resource := Trim(SrvQryPSMCM.FieldByName(CreateFld(tblInf.pfx, fli_rsc)).AsString);
          schedType := Trim(SrvQryPSMCM.FieldByName(CreateFld(tblInf.pfx, fli_schedType)).AsString);
          StartDate := SrvQryPSMCM.FieldByName(CreateFld(tblInf.pfx, fli_schedStart)).AsDateTime;
          EndDate   := SrvQryPSMCM.FieldByName(CreateFld(tblInf.pfx, fli_schedEnd)).AsDateTime;
          Qty       := SrvQryPSMCM.FieldByName(CreateFld(tblInf.pfx, fli_quant)).AsFloat;
          Temp_TimeVal := NOW;
        //  try
            if Reason = 'HeadrFieldsChange' then
              WriteLogLineToDBFromServer('S', Req , Step, SubStep, RePRoc,'Dlt','D',Resource,StartDate, EndDate, Qty, schedType, PReqChange(m_Req_Change_List[I]).Reason)
            else if Reason = 'StepFieldChange' then
              WriteLogLineToDBFromServer('S', Req , Step, SubStep, RePRoc,'Dlt','D',Resource,StartDate, EndDate, Qty, schedType, PStepChange(m_Req_Step_Change_List[J]).Reason)
            else
              WriteLogLineToDBFromServer('S', Req , Step, SubStep, RePRoc,'Dlt','D',Resource,StartDate, EndDate, Qty, schedType, Reason);
          Temp_TimeVal := NOW - Temp_TimeVal;
          IniAppGlobals.Time_WriteLogLineToDBFromServer := IniAppGlobals.Time_WriteLogLineToDBFromServer + Temp_TimeVal;
        //  except
        //  end;
          Temp_TimeVal := NOW;
          SqlUpdate := '';
          SqlUpdate :=  SqlUpdate + ' delete from ' + tblInf.GetTableName + ' where ';
          SqlUpdate :=  SqlUpdate + CreateFld(tblInf.pfx, fli_preqNo) + '=' + '''' + Trim(SrvQryPSMCM.FieldByName(CreateFld(tblInf.pfx, fli_preqNo)).AsString) + '''' + ' AND ';
          SqlUpdate :=  SqlUpdate + CreateFld(tblInf.pfx, fli_pstepId) + '=' + '''' + IntToStr(SrvQryPSMCM.FieldByName(CreateFld(tblInf.pfx, fli_pstepId)).AsInteger) + '''' + ' AND ';
          SqlUpdate :=  SqlUpdate + CreateFld(tblInf.pfx, fli_psubstId) + '=' + '''' + IntToStr(SrvQryPSMCM.FieldByName(CreateFld(tblInf.pfx, fli_psubstId)).AsInteger) + '''' + ' AND ';
          SqlUpdate :=  SqlUpdate + CreateFld(tblInf.pfx, fli_reprocNo) + '=' + '''' + IntToStr(SrvQryPSMCM.FieldByName(CreateFld(tblInf.pfx, fli_reprocNo)).AsInteger) + '''';
          SqlUpdate :=  SqlUpdate + AND_IDF_Condition(CreateFld(tblInf.pfx, fli_IDENTIFIER));

          Sql.Clear;
          SQL.Add(SqlUpdate);
        //  Prepare;
          ExecSQL;
          Temp_TimeVal := NOW - Temp_TimeVal;
          IniAppGlobals.Time_DelPS := IniAppGlobals.Time_DelPS + Temp_TimeVal;
          Inc(IniAppGlobals.Count_DelPS);
          RunCommit := true;
        end;
      end;

      if PSUnsched then
      begin
        with QryUpdatePSMCM do
        begin
          Req  := Trim(SrvQryPSMCM.FieldByName(CreateFld(tblInf.pfx, fli_preqNo)).AsString);
          Step := SrvQryPSMCM.FieldByName(CreateFld(tblInf.pfx, fli_pstepId)).AsInteger;
          SubStep := SrvQryPSMCM.FieldByName(CreateFld(tblInf.pfx, fli_psubstId)).AsInteger;
          RePRoc  := SrvQryPSMCM.FieldByName(CreateFld(tblInf.pfx, fli_reprocNo)).AsInteger;
          Resource := Trim(SrvQryPSMCM.FieldByName(CreateFld(tblInf.pfx, fli_rsc)).AsString);
          schedType := Trim(SrvQryPSMCM.FieldByName(CreateFld(tblInf.pfx, fli_schedType)).AsString);
          StartDate := SrvQryPSMCM.FieldByName(CreateFld(tblInf.pfx, fli_schedStart)).AsDateTime;
          EndDate   := SrvQryPSMCM.FieldByName(CreateFld(tblInf.pfx, fli_schedEnd)).AsDateTime;
          Qty       := SrvQryPSMCM.FieldByName(CreateFld(tblInf.pfx, fli_quant)).AsFloat;
          Temp_TimeVal := NOW;
          try
            if Reason = 'HeadrPropChange' then
              WriteLogLineToDBFromServer('S', Req , Step, SubStep, RePRoc,'Upd','U',Resource,StartDate, EndDate, Qty, schedType, PReqChange(m_Req_Change_List[I]).Reason)
            else if Reason = 'StepPropChange' then
              WriteLogLineToDBFromServer('S', Req , Step, SubStep, RePRoc,'Upd','U',Resource,StartDate, EndDate, Qty, schedType, PStepChange(m_Req_Step_Change_List[J]).Reason)
            else
              WriteLogLineToDBFromServer('S', Req , Step, SubStep, RePRoc,'Upd','U',Resource,StartDate, EndDate, Qty, schedType, Reason);
          Temp_TimeVal := NOW - Temp_TimeVal;
          IniAppGlobals.Time_WriteLogLineToDBFromServer := IniAppGlobals.Time_WriteLogLineToDBFromServer + Temp_TimeVal;
          except
          end;
          Temp_TimeVal := NOW;
          SqlUpdate := '';
          SqlUpdate :=  SqlUpdate + 'update ' + tblInf.GetTableName + ' set ';
          SqlUpdate :=  SqlUpdate + 'MS_RSC_CODE = :MS_RSC_CODE' + DecSep;
          SqlUpdate :=  SqlUpdate + 'MS_WKCNTER = :MS_WKCNTER' + DecSep;
          SqlUpdate :=  SqlUpdate + 'MS_WKCT_PROC = :MS_WKCT_PROC' + DecSep;
          SqlUpdate :=  SqlUpdate + 'MS_SCHED_TYPE = :MS_SCHED_TYPE';
          SqlUpdate :=  SqlUpdate + ' Where';
          SqlUpdate :=  SqlUpdate + ' MS_PREQ_NO = :MS_PREQ_NO';
          SqlUpdate :=  SqlUpdate + ' AND';
          SqlUpdate :=  SqlUpdate + ' MS_PSTEP_ID = :MS_PSTEP_ID';
          SqlUpdate :=  SqlUpdate + ' AND';
          SqlUpdate :=  SqlUpdate + ' MS_PSUBST_ID = :MS_PSUBST_ID';
          SqlUpdate :=  SqlUpdate + ' AND';
          SqlUpdate :=  SqlUpdate + ' MS_REPROC_NO = :MS_REPROC_NO';
          SqlUpdate :=  SqlUpdate + AND_IDF_Condition(CreateFld(tblInf.pfx, fli_IDENTIFIER));
          Sql.Clear;
          SqlUpdate := SetDecSeparator(SqlUpdate);
          SQL.Add(SqlUpdate);
          ParamByName('MS_RSC_CODE').Value       := '';
          ParamByName('MS_WKCNTER').Value        := '';
          ParamByName('MS_WKCT_PROC').Value      := '';
          ParamByName('MS_SCHED_TYPE').Value     := '0';
          ParamByName('MS_PREQ_NO').Value := SrvQryPSMCM.FieldByName(CreateFld(tblInf.pfx, fli_preqNo)).AsString;
          ParamByName('MS_PSTEP_ID').Value := SrvQryPSMCM.FieldByName(CreateFld(tblInf.pfx, fli_pstepId)).AsInteger;
          ParamByName('MS_PSUBST_ID').Value := SrvQryPSMCM.FieldByName(CreateFld(tblInf.pfx, fli_psubstId)).AsInteger;
          ParamByName('MS_REPROC_NO').Value := SrvQryPSMCM.FieldByName(CreateFld(tblInf.pfx, fli_reprocNo)).AsInteger;
          try
            ExecSQL;

          except
          end;
          Temp_TimeVal := NOW - Temp_TimeVal;
            IniAppGlobals.Time_UpdatePS := IniAppGlobals.Time_UpdatePS + Temp_TimeVal;
            Inc(IniAppGlobals.Count_UpdatePS);
          RunCommit := true;
        end;
      end;

      SrvQryPSMCM.next;
      continue;
    end;

    //*******************************************************************************//
    //*********************************** tbl_prop_prod *****************************//
    //*******************************************************************************//

    tblInf := @tblInfo[tbl_prop_prod];
    while (IndexPP <= m_HostListPP.count - 1) and (Request > PTMQMPP(m_HostListPP[IndexPP]).PP_PREQ_NO) do
    begin
      inc(IndexPP);
    end;
    while (not EOL_Local(PP)) and (Request > PTMQMPP(m_LocalListPP[m_Local_IndexPP]).PP_PREQ_NO) do
    begin
      Inc(m_Local_IndexPP);
    end;

    FirstCycle := true;
    HostHaveData := true;
    EndRequestDataHost := false;
    EndRequestDataLocal := false;
    while true do
    begin
      if (IndexPP > m_HostListPP.count - 1) or (Request < PTMQMPP(m_HostListPP[IndexPP]).PP_PREQ_NO)
      or (PReqChange(m_Req_Change_List[I]).ChangedType = DelReq) then EndRequestDataHost := true;
      if (EOL_Local(PP) or (Request < PTMQMPP(m_LocalListPP[m_Local_IndexPP]).PP_PREQ_NO))
      then EndRequestDataLocal := true;

      if EndRequestDataHost and EndRequestDataLocal then break;

      Operation := DBEqual;

      if EndRequestDataHost then
      begin
        Operation := DBDelete;
        if FirstCycle then HostHaveData := false;
      end;
      FirstCycle := False;

      if EndRequestDataLocal then Operation := DBInsert;

      if Operation = DBEqual then
       begin
        TableNumberOfKeys := KeyNumPP;
        TableNumberOfFields := 5;
        HostFields[1]  := PTMQMPP(m_HostListPP[IndexPP]).PP_PREQ_NO;
        HostFields[2]  := PTMQMPP(m_HostListPP[IndexPP]).PP_PSTEP_ID;
        HostFields[3]  := PTMQMPP(m_HostListPP[IndexPP]).PP_PROPERTY;
        HostFields[4]  := PTMQMPP(m_HostListPP[IndexPP]).PP_RSC_CODE;
        HostFields[5]  := PTMQMPP(m_HostListPP[IndexPP]).PP_VALUE;
        LocalFields[1]  := PTMQMPP(m_LocalListPP[m_Local_IndexPP]).PP_PREQ_NO;
        LocalFields[2]  := PTMQMPP(m_LocalListPP[m_Local_IndexPP]).PP_PSTEP_ID;
        LocalFields[3]  := PTMQMPP(m_LocalListPP[m_Local_IndexPP]).PP_PROPERTY;
        LocalFields[4]  := PTMQMPP(m_LocalListPP[m_Local_IndexPP]).PP_RSC_CODE;
        LocalFields[5]  := PTMQMPP(m_LocalListPP[m_Local_IndexPP]).PP_VALUE;
        Operation := CompareKeys(TableNumberOfKeys, TableNumberOfFields, HostFields, LocalFields);
      end;

      if (not HostHaveData) and (PReqChange(m_Req_Change_List[I]).ChangedType = Historical) then
      begin
        if Operation = DBDelete then Inc(m_Local_IndexPP);
        if Operation = DBInsert then IndexPP := IndexPP + 1;
        if (Operation <> DBDelete) and (Operation <> DBInsert) then
        begin
          Inc(m_Local_IndexPP);
          IndexPP := IndexPP + 1;
        end;
        continue;
      end;

      if Operation = DBDelete then
      begin
        Temp_TimeVal := NOW;
        with QryDelPP do
        begin
          ParamByName(CreateFld(tblInf.pfx, fli_preqNo)).AsString := PTMQMPP(m_LocalListPP[m_Local_IndexPP]).PP_PREQ_NO;
          ParamByName(CreateFld(tblInf.pfx, fli_pstepId)).AsInteger := PTMQMPP(m_LocalListPP[m_Local_IndexPP]).PP_PSTEP_ID;
          ParamByName(CreateFld(tblInf.pfx, fli_PropertyCode)).AsString := PTMQMPP(m_LocalListPP[m_Local_IndexPP]).PP_PROPERTY;
          if (DndArchiveLocalName = TD_Oracle) then
          begin
            if PTMQMPP(m_LocalListPP[m_Local_IndexPP]).PP_RSC_CODE = '' then
              PTMQMPP(m_LocalListPP[m_Local_IndexPP]).PP_RSC_CODE := ' ';
          end;
          ParamByName(CreateFld(tblInf.pfx, fli_rsc)).AsString := PTMQMPP(m_LocalListPP[m_Local_IndexPP]).PP_RSC_CODE;
        //  Prepare;
          ExecSQL;
          Temp_TimeVal := NOW - Temp_TimeVal;
          IniAppGlobals.Time_DelPP := IniAppGlobals.Time_DelPP + Temp_TimeVal;
          Inc(IniAppGlobals.Count_DelPP);
          RunCommit := true;
        end;
        Inc(m_Local_IndexPP);
        continue;
      end;

      if Operation = DBInsert then
      begin
        PTMQMPP(m_HostListPP[IndexPP]).PP_CreateDateTimeUTC := UTCNow;
        PTMQMPP(m_HostListPP[IndexPP]).PP_CrtOrUpdateDateTimeUTC := UTCNow;
        with QryInsertPP do
        begin
          Temp_TimeVal := NOW;

            Params.ParamByName('PREQ').AsString:= PTMQMPP(m_HostListPP[IndexPP]).PP_PREQ_NO;
            Params.ParamByName('id').asInteger := PTMQMPP(m_HostListPP[IndexPP]).PP_PSTEP_ID;
            Params.ParamByName('Prop').AsString:= PTMQMPP(m_HostListPP[IndexPP]).PP_PROPERTY;
            if DndArchiveLocalName = TD_Oracle then
              Params.ParamByName('c').AsString:= ' '
            else
              Params.ParamByName('c').AsString:= '';
            Params.ParamByName('Value').AsString:= PTMQMPP(m_HostListPP[IndexPP]).PP_VALUE;
            Params.ParamByName('identifier').asString := IniAppGlobals.Identifier;

            Params.ParamByName('CrtUTC').asDatetime := PTMQMPP(m_HostListPP[IndexPP]).PP_CreateDateTimeUTC;
            Params.ParamByName('UpdUTC').asDatetime := PTMQMPP(m_HostListPP[IndexPP]).PP_CrtOrUpdateDateTimeUTC;
            //Params.ParamByName('CrtUTC').asDatetime := StrToDateTime(ConvertDateFormatTo(PTMQMPP(m_HostListPP[IndexPP]).PP_CreateDateTimeUTC , DndArchiveLocalName));
            //Params.ParamByName('UpdUTC').asDatetime := StrToDateTime(ConvertDateFormatTo(PTMQMPP(m_HostListPP[IndexPP]).PP_CrtOrUpdateDateTimeUTC , DndArchiveLocalName));


          {QuotedStr(PTMQMPP(m_HostListPP[IndexPP]).PP_PREQ_NO)  + ', ' +
          IntToStr(PTMQMPP(m_HostListPP[IndexPP]).PP_PSTEP_ID)  + ', ' +
          QuotedStr(PTMQMPP(m_HostListPP[IndexPP]).PP_PROPERTY) + ', ' +
          QuotedStr(' ') + ', ' +
          QuotedStr(PTMQMPP(m_HostListPP[IndexPP]).PP_VALUE)    + ', ' +
          IniAppGlobals.Identifier + ')';  }

          try
            ExecSQL;

          except
          end;
          Temp_TimeVal := NOW - Temp_TimeVal;
            IniAppGlobals.Time_InsertPP := IniAppGlobals.Time_InsertPP + Temp_TimeVal;
            Inc(IniAppGlobals.Count_InsertPP);
          RunCommit := true;


      {    QryInsertSql := 'insert into ' + tblInf.GetTableName  + '(';
          QryInsertSql := QryInsertSql + 'PP_PREQ_NO,';
          QryInsertSql := QryInsertSql + 'PP_PSTEP_ID,';
          QryInsertSql := QryInsertSql + 'PP_PROPERTY, ';
          QryInsertSql := QryInsertSql + 'PP_RSC_CODE, ';
          QryInsertSql := QryInsertSql + 'PP_VALUE';
          QryInsertSql := QryInsertSql + ') values (';
          QryInsertSql := QryInsertSql + QuotedStr(PTMQMPP(m_HostListPP[IndexPP]).PP_PREQ_NO) + ',';
          QryInsertSql := QryInsertSql + IntToStr(PTMQMPP(m_HostListPP[IndexPP]).PP_PSTEP_ID) + ',';
          QryInsertSql := QryInsertSql + QuotedStr(PTMQMPP(m_HostListPP[IndexPP]).PP_PROPERTY) + ',';
          QryInsertSql := QryInsertSql + QuotedStr('') + ',';
          QryInsertSql := QryInsertSql + QuotedStr(PTMQMPP(m_HostListPP[IndexPP]).PP_VALUE);
          QryInsertSql := QryInsertSql + ');';
          QryInsertPP.SQL.Clear;
          QryInsertPP.SQL.Add(QryInsertSql);    }


      {    QryInsertPP.SQL.Clear;
          QryInsertPP.SQL.Add('insert into Prop_Prod ' + '(');
          QryInsertPP.SQL.Add('PP_PREQ_NO,');
          QryInsertPP.SQL.Add('PP_PSTEP_ID,');
          QryInsertPP.SQL.Add('PP_PROPERTY, ');
          QryInsertPP.SQL.Add('PP_RSC_CODE, ');
          QryInsertPP.SQL.Add('PP_VALUE');
          QryInsertPP.SQL.Add(') values (');
          QryInsertPP.SQL.Add(QuotedStr(PTMQMPP(m_HostListPP[IndexPP]).PP_PREQ_NO) + ',');
          QryInsertPP.SQL.Add(IntToStr(PTMQMPP(m_HostListPP[IndexPP]).PP_PSTEP_ID) + ',');
          QryInsertPP.SQL.Add(QuotedStr(PTMQMPP(m_HostListPP[IndexPP]).PP_PROPERTY) + ',');
          QryInsertPP.SQL.Add(QuotedStr('') + ',');
          QryInsertPP.SQL.Add(QuotedStr(PTMQMPP(m_HostListPP[IndexPP]).PP_VALUE));
          QryInsertPP.SQL.Add(');');    }

          {

          ParamByName(CreateFld(tblInf.pfx, fli_preqNo)).AsString := PTMQMPP(m_HostListPP[IndexPP]).PP_PREQ_NO;
          ParamByName(CreateFld(tblInf.pfx, fli_pstepId)).AsInteger := PTMQMPP(m_HostListPP[IndexPP]).PP_PSTEP_ID;
          ParamByName(CreateFld(tblInf.pfx, fli_rsc)).AsString := PTMQMPP(m_HostListPP[IndexPP]).PP_RSC_CODE;
          ParamByName(CreateFld(tblInf.pfx, fli_PropertyCode)).AsString := PTMQMPP(m_HostListPP[IndexPP]).PP_PROPERTY;
          PTMQMPP(m_HostListPP[IndexPP]).PP_PROPERTY := 'PA600L01UM0055013/01';
          if CheckValue(PTMQMPP(m_HostListPP[IndexPP]).PP_PROPERTY, Val1, Val2) then
          begin
            ParamByName(CreateFld(tblInf.pfx, fli_PropValue)).AsString := Val1;
            ParamByName(CreateFld(tblInf.pfx, fli_PropValue)).AsString := ParamByName(CreateFld(tblInf.pfx, fli_PropValue)).AsString + Val2;

          end
          else
            ParamByName(CreateFld(tblInf.pfx, fli_PropValue)).AsString := PTMQMPP(m_HostListPP[IndexPP]).PP_VALUE;

          ParamByName(CreateFld(tblInf.pfx, fli_usrCg)).AsString := PTMQMPP(m_HostListPP[IndexPP]).PP_USR_CG;
          ParamByName(CreateFld(tblInf.pfx, fli_usrTmCg)).AsDateTime := PTMQMPP(m_HostListPP[IndexPP]).PP_USR_TM_CG;   }
        //  try
            //ListStrPropIndex.add('Property Index error :  ' + IntToStr(IndexPP));
            //ListStrPropIndex.add(QryInsertPP.SQL.Text);

           // ListStrPropIndex.SaveToFile('c:\listPPIndex.txt');

            //if PTMQMPP(m_HostListPP[IndexPP]).PP_PREQ_NO = 'PROD3B     00001429' and
           // if IndexPP <> 14923 then

     {        try
              ExecSQL;
              RunCommit := true;

             except
             on E: Exception do
             begin
                E.Message := E.Message + ('  Request : ' + PTMQMPP(m_HostListPP[IndexPP]).PP_PREQ_NO + '   Step :' + IntToStr(PTMQMPP(m_HostListPP[IndexPP]).PP_PSTEP_ID) +
                                        '  Property Code : ' + PTMQMPP(m_HostListPP[IndexPP]).PP_PROPERTY  +
                                        '  Property Value : ' + PTMQMPP(m_HostListPP[IndexPP]).PP_VALUE +
                                        '  Resource Code : ' + PTMQMPP(m_HostListPP[IndexPP]).PP_RSC_CODE);


              raise;

             end;
             end;   }

         {   LogPP := TStringList.create;
            LogPP.Add('  Request : ' + PTMQMPP(m_HostListPP[IndexPP]).PP_PREQ_NO + '   Step :' + IntToStr(PTMQMPP(m_HostListPP[IndexPP]).PP_PSTEP_ID) +
                                        '  Property Code : ' + PTMQMPP(m_HostListPP[IndexPP]).PP_PROPERTY  +
                                        '  Property Value : ' + PTMQMPP(m_HostListPP[IndexPP]).PP_VALUE +
                                        '  Resource Code : ' + PTMQMPP(m_HostListPP[IndexPP]).PP_RSC_CODE);
            LogPP.SaveToFile('c:\LOG_PP_Ins.txt');
            LogPP.free;

          end;}
        end;
        IndexPP := IndexPP + 1;
        continue;
      end;

      if Operation = DBUpdate then
      begin
        PTMQMPP(m_HostListPP[IndexPP]).PP_CrtOrUpdateDateTimeUTC := UTCNow;
        with QryUpdatePP do
        begin
         // try
          Temp_TimeVal := NOW;

            Params.ParamByName('Value').AsString:= PTMQMPP(m_HostListPP[IndexPP]).PP_VALUE;
            Params.ParamByName('UpdUtc').asDateTime:= PTMQMPP(m_HostListPP[IndexPP]).PP_CrtOrUpdateDateTimeUTC;
            Params.ParamByName('PREQ').AsString:= PTMQMPP(m_HostListPP[IndexPP]).PP_PREQ_NO;
            Params.ParamByName('id').asInteger := PTMQMPP(m_HostListPP[IndexPP]).PP_PSTEP_ID;
            Params.ParamByName('Prop').AsString:= PTMQMPP(m_HostListPP[IndexPP]).PP_PROPERTY;
            Params.ParamByName('identifier').asString := IniAppGlobals.Identifier;

           { SqlUpdate := 'update ' + tblInf.GetTableName + ' set ' +
                     '"PP_VALUE" = ' + QuotedStr(sym) +
                     ' WHERE "PP_PREQ_NO" = ' + QuotedStr(PTMQMPP(m_HostListPP[IndexPP]).PP_PREQ_NO) + ' AND ' +
                     '"PP_PSTEP_ID" = ' + IntToStr(PTMQMPP(m_HostListPP[IndexPP]).PP_PSTEP_ID) + ' AND ' +
                     '"PP_PROPERTY" = ' + QuotedStr(PTMQMPP(m_HostListPP[IndexPP]).PP_PROPERTY);// + ' AND ' +
                  //   '"PP_RSC_CODE" = ' + QuotedStr(PTMQMPP(m_HostListPP[IndexPP]).PP_RSC_CODE) + AND_IDF_Condition(CreateFld(tblInf.pfx, fli_IDENTIFIER));
               }

           // SQL.Clear;
           // SQL.Add(SqlUpdate);
          try
            ExecSQL;

         // except
         // end;
            RunCommit := true;
            except

{            on E: Exception do
            begin
              E.Message := E.Message + ('  Request : ' + PTMQMPP(m_HostListPP[IndexPP]).PP_PREQ_NO + '   Step :' + IntToStr(PTMQMPP(m_HostListPP[IndexPP]).PP_PSTEP_ID) +
                                        '  Property Code : ' + PTMQMPP(m_HostListPP[IndexPP]).PP_PROPERTY  +
                                        '  Property Value : ' + PTMQMPP(m_HostListPP[IndexPP]).PP_VALUE +
                                        '  Resource Code : ' + PTMQMPP(m_HostListPP[IndexPP]).PP_RSC_CODE);
              raise;


            end;  }
            end;
            Temp_TimeVal := NOW - Temp_TimeVal;
            IniAppGlobals.Time_UpdatePP := IniAppGlobals.Time_UpdatePP + Temp_TimeVal;
            Inc(IniAppGlobals.Count_UpdatePP);
          //  LogPP := TStringList.create;
          //  LogPP.Add('  Request : ' + PTMQMPP(m_HostListPP[IndexPP]).PP_PREQ_NO + '   Step :' + IntToStr(PTMQMPP(m_HostListPP[IndexPP]).PP_PSTEP_ID) +
          //                              '  Property Code : ' + PTMQMPP(m_HostListPP[IndexPP]).PP_PROPERTY  +
          //                              '  Property Value : ' + PTMQMPP(m_HostListPP[IndexPP]).PP_VALUE +
          //                              '  Resource Code : ' + PTMQMPP(m_HostListPP[IndexPP]).PP_RSC_CODE);
          //  LogPP.SaveToFile('c:\LOG_PP_Upt.txt');
          //  LogPP.free;
          //end;
        end;
      end;
      Inc(m_Local_IndexPP);
      IndexPP := IndexPP + 1;
    end;

    //*******************************************************************************//
    //**************************** tbl_prod_info *******************************//
    //*******************************************************************************//

    tblInf := @tblInfo[tbl_prod_info];
    while (IndexPI <= m_HostListPI.count - 1) and (Request > PTMQMPI(m_HostListPI[IndexPI]).PI_PREQ_NO) do
    begin
      inc(IndexPI);
    end;
    while (not EOL_Local(PI)) and (Request > PTMQMPI(m_LocalListPI[m_Local_IndexPI]).PI_PREQ_NO) do
    begin
      Inc(m_Local_IndexPI);
    end;

    FirstCycle := true;
    HostHaveData := true;
    EndRequestDataHost := false;
    EndRequestDataLocal := false;
    while true do
    begin
      if (IndexPI > m_HostListPI.count - 1) or (Request < PTMQMPI(m_HostListPI[IndexPI]).PI_PREQ_NO)
      or (PReqChange(m_Req_Change_List[I]).ChangedType = DelReq) then EndRequestDataHost := true;
      if (EOL_Local(PI) or (Request < PTMQMPI(m_LocalListPI[m_Local_IndexPI]).PI_PREQ_NO))
      then EndRequestDataLocal := true;

      if EndRequestDataHost and EndRequestDataLocal then break;

      Operation := DBEqual;

      if EndRequestDataHost then
      begin
        Operation := DBDelete;
        if FirstCycle then HostHaveData := false;
      end;
      FirstCycle := False;

      if EndRequestDataLocal then Operation := DBInsert;

      if Operation = DBEqual then
      begin
         TableNumberOfKeys := KeyNumPI;
         TableNumberOfFields := 4;
         HostFields[1] := PTMQMPI(m_HostListPI[IndexPI]).PI_PREQ_NO;
         HostFields[2] := PTMQMPI(m_HostListPI[IndexPI]).PI_PSTEP_ID;
         HostFields[3] := PTMQMPI(m_HostListPI[IndexPI]).PI_INFO_TYPE;
         HostFields[4] := PTMQMPI(m_HostListPI[IndexPI]).PI_INFO_LINE_NUM;
         HostFields[5] := PTMQMPI(m_HostListPI[IndexPI]).PI_INFO_AREA;
         LocalFields[1] := PTMQMPI(m_LocalListPI[m_Local_IndexPI]).PI_PREQ_NO;
         LocalFields[2] := PTMQMPI(m_LocalListPI[m_Local_IndexPI]).PI_PSTEP_ID;
         LocalFields[3] := PTMQMPI(m_LocalListPI[m_Local_IndexPI]).PI_INFO_TYPE;
         LocalFields[4] := PTMQMPI(m_LocalListPI[m_Local_IndexPI]).PI_INFO_LINE_NUM;
         LocalFields[5] := PTMQMPI(m_LocalListPI[m_Local_IndexPI]).PI_INFO_AREA;
         Operation := CompareKeys(TableNumberOfKeys, TableNumberOfFields, HostFields, LocalFields);
      end;

      if (not HostHaveData) and (PReqChange(m_Req_Change_List[I]).ChangedType = Historical) then
      begin
        if Operation = DBDelete then Inc(m_Local_IndexPI);
        if Operation = DBInsert then IndexPI := IndexPI + 1;
        if (Operation <> DBDelete) and (Operation <> DBInsert) then
        begin
          Inc(m_Local_IndexPI);
          IndexPI := IndexPI + 1;
        end;
        continue;
      end;

      if Operation = DBDelete then
      begin
        Temp_TimeVal := NOW;
        with QryDelPI do
        begin
          ParamByName(CreateFld(tblInf.pfx, fli_preqNo)).AsString       := PTMQMPI(m_LocalListPI[m_Local_IndexPI]).PI_PREQ_NO;
          ParamByName(CreateFld(tblInf.pfx, fli_pstepId)).AsInteger     := PTMQMPI(m_LocalListPI[m_Local_IndexPI]).PI_PSTEP_ID;
          ParamByName(CreateFld(tblInf.pfx, fli_infoLineNum)).AsInteger := PTMQMPI(m_LocalListPI[m_Local_IndexPI]).PI_INFO_LINE_NUM;
          ParamByName(CreateFld(tblInf.pfx, fli_infoType)).AsString     := PTMQMPI(m_LocalListPI[m_Local_IndexPI]).PI_INFO_TYPE;

         // Prepare;
          ExecSQL;
          Temp_TimeVal := NOW - Temp_TimeVal;
          IniAppGlobals.Time_DelPI := IniAppGlobals.Time_DelPI + Temp_TimeVal;
          Inc(IniAppGlobals.Count_DelPI);
          RunCommit := true;
        end;
        Inc(m_Local_IndexPI);
        continue;
      end;

      if Operation = DBInsert then
      begin
        with QryInsertPI do
        begin
          Temp_TimeVal := NOW;
          ParamByName('PI_PREQ_NO').AsString := PTMQMPI(m_HostListPI[IndexPI]).PI_PREQ_NO;
          ParamByName('PI_PSTEP_ID').AsInteger := PTMQMPI(m_HostListPI[IndexPI]).PI_PSTEP_ID;
          ParamByName('PI_INFO_TYPE').AsString := PTMQMPI(m_HostListPI[IndexPI]).PI_INFO_TYPE;
          ParamByName('PI_INFO_LINE_NUM').AsInteger := PTMQMPI(m_HostListPI[IndexPI]).PI_INFO_LINE_NUM;
          ParamByName('PI_INFO_AREA').AsString := PTMQMPI(m_HostListPI[IndexPI]).PI_INFO_AREA;
          ParamByName('PI_USR_NAMECG').AsString := PTMQMPI(m_HostListPI[IndexPI]).PI_USR_CG;
          ParamByName('PI_USR_TIMECG').AsDateTime := PTMQMPI(m_HostListPI[IndexPI]).PI_USR_TM_CG;
          ParamByName('PI_IDENTIFIER').AsString := IniAppGlobals.Identifier;
          try
            ExecSQL;

          except
            on E: Exception do
            begin
              ApplicationShowException(E);
            end;
          end;
          Temp_TimeVal := NOW - Temp_TimeVal;
            IniAppGlobals.Time_InsertPI := IniAppGlobals.Time_InsertPI + Temp_TimeVal;
            Inc(IniAppGlobals.Count_InsertPI);
          RunCommit := true;
        end;
        IndexPI := IndexPI + 1;
        continue;
      end;

      if Operation = DBUpdate then
      begin
        with QryUpdatePI do
        begin
          Temp_TimeVal := NOW;
          ParamByName('PI_INFO_AREA').AsString := PTMQMPI(m_HostListPI[IndexPI]).PI_INFO_AREA;
          ParamByName('PI_PREQ_NO').AsString := PTMQMPI(m_HostListPI[IndexPI]).PI_PREQ_NO;
          ParamByName('PI_INFO_TYPE').AsString := PTMQMPI(m_HostListPI[IndexPI]).PI_INFO_TYPE;
          ParamByName('PI_PSTEP_ID').AsInteger := PTMQMPI(m_HostListPI[IndexPI]).PI_PSTEP_ID;
          ParamByName('PI_INFO_LINE_NUM').AsInteger := PTMQMPI(m_HostListPI[IndexPI]).PI_INFO_LINE_NUM;
          try
            ExecSQL;

          except
          end;
          Temp_TimeVal := NOW - Temp_TimeVal;
            IniAppGlobals.Time_UpdatePI := IniAppGlobals.Time_UpdatePI + Temp_TimeVal;
            Inc(IniAppGlobals.Count_UpdatePI);
          RunCommit := true;
        end;
      end;
      Inc(m_Local_IndexPI);
      IndexPI := IndexPI + 1;
    end;

    //*******************************************************************************//
    //**************************** tbl_ext_connection *******************************//
    //*******************************************************************************//

    tblInf := @tblInfo[tbl_ext_connection];

    while (IndexEC <= m_HostListEC.count - 1) and (Request > PTMQMEC(m_HostListEC[IndexEC]).EC_PREQ_NO) do
    begin
      inc(IndexEC);
    end;
    while (not EOL_Local(EC)) and (Request > PTMQMEC(m_LocalListEC[m_Local_IndexEC]).EC_PREQ_NO) do
    begin
      Inc(m_Local_IndexEC);
    end;

    FirstCycle := true;
    HostHaveData := true;
    EndRequestDataHost := false;
    EndRequestDataLocal := false;
    while true do
    begin
      if (IndexEC > m_HostListEC.count - 1) or (Request < PTMQMEC(m_HostListEC[IndexEC]).EC_PREQ_NO)
      or (PReqChange(m_Req_Change_List[I]).ChangedType = DelReq) then EndRequestDataHost := true;
      if (EOL_Local(EC) or (Request < PTMQMEC(m_LocalListEC[m_Local_IndexEC]).EC_PREQ_NO))
      then EndRequestDataLocal := true;

      if EndRequestDataHost and EndRequestDataLocal then break;

      Operation := DBEqual;

      if EndRequestDataHost then
      begin
        Operation := DBDelete;
        if FirstCycle then HostHaveData := false;
      end;
      FirstCycle := False;

      if EndRequestDataLocal then Operation := DBInsert;

      if Operation = DBEqual then
      begin
        TableNumberOfKeys := KeyNumEC;
        TableNumberOfFields := 4;
        HostFields[1] := PTMQMEC(m_HostListEC[IndexEC]).EC_PREQ_NO;
        HostFields[2] := PTMQMEC(m_HostListEC[IndexEC]).EC_CONNE_KEY;
        HostFields[3] := PTMQMEC(m_HostListEC[IndexEC]).EC_NUM_LEVELS;
        HostFields[4] := PTMQMEC(m_HostListEC[IndexEC]).EC_CONN_CERTENT_LEVEL;
        LocalFields[1] := PTMQMEC(m_LocalListEC[m_Local_IndexEC]).EC_PREQ_NO;
        LocalFields[2] := PTMQMEC(m_LocalListEC[m_Local_IndexEC]).EC_CONNE_KEY;
        LocalFields[3] := PTMQMEC(m_LocalListEC[m_Local_IndexEC]).EC_NUM_LEVELS;
        LocalFields[4] := PTMQMEC(m_LocalListEC[m_Local_IndexEC]).EC_CONN_CERTENT_LEVEL;
        Operation := CompareKeys(TableNumberOfKeys, TableNumberOfFields, HostFields, LocalFields);
      end;

      if (not HostHaveData) and (PReqChange(m_Req_Change_List[I]).ChangedType = Historical) then
      begin
        if Operation = DBDelete then Inc(m_Local_IndexEC);
        if Operation = DBInsert then IndexEC := IndexEC + 1;
        if (Operation <> DBDelete) and (Operation <> DBInsert) then
        begin
          Inc(m_Local_IndexEC);
          IndexEC := IndexEC + 1;
        end;
        continue;
      end;

      if Operation = DBDelete then
      begin
        with QryDelEC do
        begin
          Temp_TimeVal := NOW;
          ParamByName(CreateFld(tblInf.pfx, fli_preqNo)).AsString := PTMQMEC(m_LocalListEC[m_Local_IndexEC]).EC_PREQ_NO;
          ParamByName(CreateFld(tblInf.pfx, fli_ConnKey)).AsString := PTMQMEC(m_LocalListEC[m_Local_IndexEC]).EC_CONNE_KEY;
       //   Prepare;
          ExecSQL;
          Temp_TimeVal := NOW - Temp_TimeVal;
          IniAppGlobals.Time_DelEC := IniAppGlobals.Time_DelEC + Temp_TimeVal;
          Inc(IniAppGlobals.Count_DelEC);
          RunCommit := true;
        end;
        Inc(m_Local_IndexEC);
        continue;
      end;

      if Operation = DBInsert then
      begin
        with QryInsertEC do
        begin
          Temp_TimeVal := NOW;
          ParamByName('EC_PREQ_NO').AsString := PTMQMEC(m_HostListEC[IndexEC]).EC_PREQ_NO;
          ParamByName('EC_CONNE_KEY').AsString := PTMQMEC(m_HostListEC[IndexEC]).EC_CONNE_KEY;
          ParamByName('EC_NUM_LEVELS').AsInteger := PTMQMEC(m_HostListEC[IndexEC]).EC_NUM_LEVELS;
          ParamByName('EC_CONN_CERTENT_LEVEL').AsString := PTMQMEC(m_HostListEC[IndexEC]).EC_CONN_CERTENT_LEVEL;
          ParamByName('EC_USR_NAMECG').AsString := PTMQMEC(m_HostListEC[IndexEC]).EC_USR_CG;
          ParamByName('EC_USR_TIMECG').AsDateTime := PTMQMEC(m_HostListEC[IndexEC]).EC_USR_TM_CG;
          ParamByName('EC_IDENTIFIER').AsString := IniAppGlobals.Identifier;
          try
            ExecSQL;

          except
            on E: Exception do
            begin
              ApplicationShowException(E);
            end;
          end;
          Temp_TimeVal := NOW - Temp_TimeVal;
            IniAppGlobals.Time_InsertEC := IniAppGlobals.Time_InsertEC + Temp_TimeVal;
            Inc(IniAppGlobals.Count_InsertEC);
          RunCommit := true;
        end;
        IndexEC := IndexEC + 1;
        continue;
      end;

      if Operation = DBUpdate then
      begin
        with QryUpdateEC do
        begin
          Temp_TimeVal := NOW;
          ParamByName('EC_NUM_LEVELS').AsInteger := PTMQMEC(m_HostListEC[IndexEC]).EC_NUM_LEVELS;
          ParamByName('EC_USR_NAMECG').AsString := PTMQMPR(m_HostListPR[IndexPR]).PR_USR_CG; // original bug preserved
          ParamByName('EC_USR_TIMECG').AsDateTime := PTMQMEC(m_HostListEC[IndexEC]).EC_USR_TM_CG;
          ParamByName('EC_PREQ_NO').AsString := PTMQMEC(m_HostListEC[IndexEC]).EC_PREQ_NO;
          ParamByName('EC_CONNE_KEY').AsString := PTMQMEC(m_HostListEC[IndexEC]).EC_CONNE_KEY;
          try
            ExecSQL;

          except
          end;
          Temp_TimeVal := NOW - Temp_TimeVal;
            IniAppGlobals.Time_UpdateEC := IniAppGlobals.Time_UpdateEC + Temp_TimeVal;
            Inc(IniAppGlobals.Count_UpdateEC);
          RunCommit := true;
        end;
      end;

      Inc(m_Local_IndexEC);
      IndexEC := IndexEC + 1;
    end;

    //*******************************************************************************//
    //**************************** tbl_prod_reqConnection *******************************//
    //*******************************************************************************//

    tblInf := @tblInfo[tbl_prod_reqConnection];
    while (IndexIC <= m_HostListIC.count - 1) and (Request > PTMQMIC(m_HostListIC[IndexIC]).IC_PREQ_NO) do
    begin
      inc(IndexIC);
    end;
    while (not EOL_Local(IC)) and (Request > PTMQMIC(m_LocalListIC[m_Local_IndexIC]).IC_PREQ_NO) do
    begin
      Inc(m_Local_IndexIC);
    end;

    FirstCycle := true;
    HostHaveData := true;
    EndRequestDataHost := false;
    EndRequestDataLocal := false;
    while true do
    begin
      if (IndexIC > m_HostListIC.count - 1) or (Request < PTMQMIC(m_HostListIC[IndexIC]).IC_PREQ_NO)
      or (PReqChange(m_Req_Change_List[I]).ChangedType = DelReq) then EndRequestDataHost := true;
      if (EOL_Local(IC) or (Request < PTMQMIC(m_LocalListIC[m_Local_IndexIC]).IC_PREQ_NO))
      then EndRequestDataLocal := true;

      if EndRequestDataHost and EndRequestDataLocal then break;

      Operation := DBEqual;

      if EndRequestDataHost then
      begin
        Operation := DBDelete;
        if FirstCycle then HostHaveData := false;
      end;
      FirstCycle := False;

      if EndRequestDataLocal then Operation := DBInsert;

      if Operation = DBEqual then
      begin
        TableNumberOfKeys := KeyNumIC;
        TableNumberOfFields := 2;
        HostFields[1] := PTMQMIC(m_HostListIC[IndexIC]).IC_PREQ_NO;
        HostFields[2] := PTMQMIC(m_HostListIC[IndexIC]).IC_PREV_PREQ_NO;
        LocalFields[1] := PTMQMIC(m_LocalListIC[m_Local_IndexIC]).IC_PREQ_NO;
        LocalFields[2] := PTMQMIC(m_LocalListIC[m_Local_IndexIC]).IC_PREV_PREQ_NO;
        Operation := CompareKeys(TableNumberOfKeys, TableNumberOfFields, HostFields, LocalFields);
      end;

      if (not HostHaveData) and (PReqChange(m_Req_Change_List[I]).ChangedType = Historical) then
      begin
        if Operation = DBDelete then Inc(m_Local_IndexIC);
        if Operation = DBInsert then IndexIC := IndexiC + 1;
        if (Operation <> DBDelete) and (Operation <> DBInsert) then
        begin
          Inc(m_Local_IndexIC);
          IndexIC := IndexIC + 1;
        end;
        continue;
      end;

      if Operation = DBDelete then
      begin
        with QryDelIC do
        begin
          Temp_TimeVal := NOW;
          ParamByName(CreateFld(tblInf.pfx, fli_preqNo)).AsString := PTMQMIC(m_LocalListIC[m_Local_IndexIC]).IC_PREQ_NO;
          ParamByName(CreateFld(tblInf.pfx, fli_PrevProdNum)).AsString := PTMQMIC(m_LocalListIC[m_Local_IndexIC]).IC_PREV_PREQ_NO;
        //  Prepare;
          ExecSQL;
          Temp_TimeVal := NOW - Temp_TimeVal;
          IniAppGlobals.Time_DelIC := IniAppGlobals.Time_DelIC + Temp_TimeVal;
          Inc(IniAppGlobals.Count_DelIC);
          RunCommit := true;
        end;
        Inc(m_Local_IndexIC);
        continue;
      end;

      if Operation = DBInsert then
      begin
        with QryInsertIC do
        begin
          Temp_TimeVal := NOW;
          PTMQMIC(m_HostlistIC[IndexIC]).IC_CreateDateTimeUTC := UTCNow;
          PTMQMIC(m_HostlistIC[IndexIC]).IC_CrtOrUpdateDateTimeUTC := UTCNow;

          ParamByName('IC_PREQ_NO').AsString := PTMQMIC(m_HostListIC[IndexIC]).IC_PREQ_NO;
          ParamByName('IC_PREV_PREQ_NO').AsString := PTMQMIC(m_HostListIC[IndexIC]).IC_PREV_PREQ_NO;
          ParamByName('IC_USR_NAMECG').AsString := PTMQMIC(m_HostListIC[IndexIC]).IC_USR_CG;
          ParamByName('IC_USR_TIMECG').AsDateTime := PTMQMIC(m_HostListIC[IndexIC]).IC_USR_TM_CG;
          ParamByName('IC_CREATE_DATE_TIME_UTC').AsDateTime := PTMQMIC(m_HostlistIC[IndexIC]).IC_CreateDateTimeUTC;
          ParamByName('IC_UPDATED_DATE_TIME_UTC').AsDateTime := PTMQMIC(m_HostlistIC[IndexIC]).IC_CrtOrUpdateDateTimeUTC;
          ParamByName('IC_IDENTIFIER').AsString := IniAppGlobals.Identifier;
          try
            ExecSQL;

          Except
          end;
          Temp_TimeVal := NOW - Temp_TimeVal;
            IniAppGlobals.Time_InsertIC := IniAppGlobals.Time_InsertIC + Temp_TimeVal;
            Inc(IniAppGlobals.Count_InsertIC);
          RunCommit := true;
        end;
        IndexIC := IndexIC + 1;
        continue;
      end;

      if Operation = DBUpdate then
      begin
        with QryUpdateIC do
        begin
          Temp_TimeVal := NOW;
          PTMQMIC(m_HostlistIC[IndexIC]).IC_CrtOrUpdateDateTimeUTC := UTCNow;
          ParamByName('IC_UPDATED_DATE_TIME_UTC').AsDateTime := PTMQMIC(m_HostListIC[IndexIC]).IC_CrtOrUpdateDateTimeUTC;
          ParamByName('IC_USR_NAMECG').AsString := PTMQMIC(m_HostListIC[IndexIC]).IC_USR_CG;
          ParamByName('IC_PREQ_NO').AsString := PTMQMIC(m_HostListIC[IndexIC]).IC_PREQ_NO;
          ParamByName('IC_PREV_PREQ_NO').AsString := PTMQMIC(m_HostListIC[IndexIC]).IC_PREV_PREQ_NO;
          try
            ExecSQL;

          except
          end;
          Temp_TimeVal := NOW - Temp_TimeVal;
            IniAppGlobals.Time_UpdateIC := IniAppGlobals.Time_UpdateIC + Temp_TimeVal;
            Inc(IniAppGlobals.Count_UpdateIC);
          RunCommit := true;
        end;
      end;

      Inc(m_Local_IndexIC);
      IndexIC := IndexIC + 1;
    end;

    //*******************************************************************************//
    //**************************** tbl_step_batchSize *******************************//
    //*******************************************************************************//

    tblInf := @tblInfo[tbl_step_batchSize];
    while (IndexSB <= m_HostListSB.count - 1) and (Request > PTMQMSB(m_HostListSB[IndexSB]).SB_PREQ_NO) do
    begin
      inc(IndexSB);
    end;
    while (not EOL_Local(SB)) and (Request > PTMQMSB(m_LocalListSB[m_Local_IndexSB]).SB_PREQ_NO) do
    begin
      Inc(m_Local_IndexSB);
    end;

    FirstCycle := true;
    HostHaveData := true;
    EndRequestDataHost := false;
    EndRequestDataLocal := false;
    while true do
    begin
      if (IndexSB > m_HostListSB.count - 1) or (Request < PTMQMSB(m_HostListSB[IndexSB]).SB_PREQ_NO)
      or (PReqChange(m_Req_Change_List[I]).ChangedType = DelReq) then EndRequestDataHost := true;
      if (EOL_Local(SB) or (Request < PTMQMSB(m_LocalListSB[m_Local_IndexSB]).SB_PREQ_NO))
      then EndRequestDataLocal := true;

      if EndRequestDataHost and EndRequestDataLocal then break;

      Operation := DBEqual;

      if EndRequestDataHost then
      begin
        Operation := DBDelete;
        if FirstCycle then HostHaveData := false;
      end;
      FirstCycle := False;

      if EndRequestDataLocal then Operation := DBInsert;

      if Operation = DBEqual then
      begin
         TableNumberOfKeys := KeyNumSB;
         TableNumberOfFields := 4;
         HostFields[1]  := PTMQMSB(m_HostListSB[IndexSB]).SB_PREQ_NO;
         HostFields[2]  := PTMQMSB(m_HostListSB[IndexSB]).SB_PSTEP_ID;
         HostFields[3]  := PTMQMSB(m_HostListSB[IndexSB]).SB_BCH_UM;
         HostFields[4]  := PTMQMSB(m_HostListSB[IndexSB]).SB_MULTIPILR_TO_BATCH_UM;
         LocalFields[1] := PTMQMSB(m_LocalListSB[m_Local_IndexSB]).SB_PREQ_NO;
         LocalFields[2] := PTMQMSB(m_LocalListSB[m_Local_IndexSB]).SB_PSTEP_ID;
         LocalFields[3] := PTMQMSB(m_LocalListSB[m_Local_IndexSB]).SB_BCH_UM;
         LocalFields[4] := PTMQMSB(m_LocalListSB[m_Local_IndexSB]).SB_MULTIPILR_TO_BATCH_UM;
         Operation := CompareKeys(TableNumberOfKeys, TableNumberOfFields, HostFields, LocalFields);
      end;

      if (not HostHaveData) and (PReqChange(m_Req_Change_List[I]).ChangedType = Historical) then
      begin
        if Operation = DBDelete then Inc(m_Local_IndexSB);
        if Operation = DBInsert then IndexSB := IndexSB + 1;
        if (Operation <> DBDelete) and (Operation <> DBInsert) then
        begin
          Inc(m_Local_IndexSB);
          IndexSB := IndexSB + 1;
        end;
        continue;
      end;

      if Operation = DBDelete then
      begin
        with QryDelSB do
        begin
          Temp_TimeVal := NOW;
          ParamByName(CreateFld(tblInf.pfx, fli_preqNo)).AsString         := PTMQMSB(m_LocalListSB[m_Local_IndexSB]).SB_PREQ_NO;
          ParamByName(CreateFld(tblInf.pfx, fli_pstepId)).AsInteger       := PTMQMSB(m_LocalListSB[m_Local_IndexSB]).SB_PSTEP_ID;
          ParamByName(CreateFld(tblInf.pfx, fli_BchUM)).AsString          := PTMQMSB(m_LocalListSB[m_Local_IndexSB]).SB_BCH_UM;
       //   Prepare;
          ExecSQL;
          Temp_TimeVal := NOW - Temp_TimeVal;
          IniAppGlobals.Time_DelSB := IniAppGlobals.Time_DelSB + Temp_TimeVal;
          Inc(IniAppGlobals.Count_DelSB);
          RunCommit := true;
        end;
        Inc(m_Local_IndexSB);
        continue;
      end;

      if Operation = DBInsert then
      begin
        with QryInsertSB do
        begin
          Temp_TimeVal := NOW;
          PTMQMSB(m_HostListSB[IndexSB]).SB_CreateDateTimeUTC := UTCNow;
          PTMQMSB(m_HostListSB[IndexSB]).SB_CrtOrUpdateDateTimeUTC := UTCNow;
          ParamByName('SB_PREQ_NO').AsString := PTMQMSB(m_HostListSB[IndexSB]).SB_PREQ_NO;
          ParamByName('SB_PSTEP_ID').AsInteger := PTMQMSB(m_HostListSB[IndexSB]).SB_PSTEP_ID;
          ParamByName('SB_BCH_UM').AsString := PTMQMSB(m_HostListSB[IndexSB]).SB_BCH_UM;
          ParamByName('SB_MULTIPILR_TO_BATCH_UM').AsFloat := PTMQMSB(m_HostListSB[IndexSB]).SB_MULTIPILR_TO_BATCH_UM;
          ParamByName('SB_CREATE_DATE_TIME_UTC').AsDateTime := PTMQMSB(m_HostListSB[IndexSB]).SB_CreateDateTimeUTC;
          ParamByName('SB_UPDATED_DATE_TIME_UTC').AsDateTime := PTMQMSB(m_HostListSB[IndexSB]).SB_CrtOrUpdateDateTimeUTC;
          ParamByName('SB_IDENTIFIER').AsString := IniAppGlobals.Identifier;
          try
            ExecSQL;

            RunCommit := true;
            except
            on E: Exception do
            begin
              E.Message := E.Message + ('  Request : ' + PTMQMSB(m_HostListSB[IndexSB]).SB_PREQ_NO + '   Step :' + IntToStr(PTMQMSB(m_HostListSB[IndexSB]).SB_PSTEP_ID) +
                                       '  Batch Um  : ' + PTMQMSB(m_HostListSB[IndexSB]).SB_BCH_UM);
              raise;
            end;
          end;
          Temp_TimeVal := NOW - Temp_TimeVal;
            IniAppGlobals.Time_InsertSB := IniAppGlobals.Time_InsertSB + Temp_TimeVal;
            Inc(IniAppGlobals.Count_InsertSB);
        end;
        IndexSB := IndexSB + 1;
        continue;
      end;

      if Operation = DBUpdate then
      begin
        with QryUpdateSB do
        begin
          Temp_TimeVal := NOW;
          PTMQMSB(m_HostListSB[IndexSB]).SB_CrtOrUpdateDateTimeUTC := UTCNow;
          ParamByName('SB_MULTIPILR_TO_BATCH_UM').AsFloat := PTMQMSB(m_HostListSB[IndexSB]).SB_MULTIPILR_TO_BATCH_UM;
          ParamByName('SB_UPDATED_DATE_TIME_UTC').AsDateTime := PTMQMSB(m_HostListSB[IndexSB]).SB_CrtOrUpdateDateTimeUTC;
          ParamByName('SB_PREQ_NO').AsString := PTMQMSB(m_HostListSB[IndexSB]).SB_PREQ_NO;
          ParamByName('SB_PSTEP_ID').AsInteger := PTMQMSB(m_HostListSB[IndexSB]).SB_PSTEP_ID;
          ParamByName('SB_BCH_UM').AsString := PTMQMSB(m_HostListSB[IndexSB]).SB_BCH_UM;
          try
            ExecSQL;

          except
          end;
          Temp_TimeVal := NOW - Temp_TimeVal;
            IniAppGlobals.Time_UpdateSB := IniAppGlobals.Time_UpdateSB + Temp_TimeVal;
            Inc(IniAppGlobals.Count_UpdateSB);
          RunCommit := true;
        end;
      end;
      Inc(m_Local_IndexSB);
      IndexSB := IndexSB + 1;
    end;

    //*******************************************************************************//
    //**************************** tbl_sched_progress *******************************//
    //*******************************************************************************//

    tblInf := @tblInfo[tbl_sched_progress];
    while (IndexSP <= m_HostListSP.count - 1) and (Request > PTMQMSP(m_HostListSP[IndexSP]).SP_PREQ_NO) do
    begin
      inc(IndexSP);
    end;
    while (not EOL_Local(SP)) and (Request > PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_PREQ_NO) do
    begin
      Inc(m_Local_IndexSP);
    end;

    FirstCycle := true;
    HostHaveData := true;
    EndRequestDataHost := false;
    EndRequestDataLocal := false;
    while true do
    begin
      if (IndexSP > m_HostListSP.count - 1) or (Request < PTMQMSP(m_HostListSP[IndexSP]).SP_PREQ_NO)
      or (PReqChange(m_Req_Change_List[I]).ChangedType = DelReq) then EndRequestDataHost := true;
      if (EOL_Local(SP) or (Request < PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_PREQ_NO))
      then EndRequestDataLocal := true;

      if EndRequestDataHost and EndRequestDataLocal then break;

      Operation := DBEqual;

      if EndRequestDataHost then
      begin
        Operation := DBDelete;
        if FirstCycle then HostHaveData := false;
      end;
      FirstCycle := False;

      if EndRequestDataLocal then Operation := DBInsert;

      if Operation = DBEqual then
      begin
        TableNumberOfKeys := KeyNumSP;
        TableNumberOfFields := 20;
        HostFields[1]  := PTMQMSP(m_HostListSP[IndexSP]).SP_PREQ_NO;
        HostFields[2]  := PTMQMSP(m_HostListSP[IndexSP]).SP_PSTEP_ID;
        HostFields[3]  := PTMQMSP(m_HostListSP[IndexSP]).SP_PSUBST_ID;
        HostFields[4]  := PTMQMSP(m_HostListSP[IndexSP]).SP_REPROC_NO;
        HostFields[5]  := PTMQMSP(m_HostListSP[IndexSP]).SP_LAST_PROG_TYPE;
        HostFields[6]  := PTMQMSP(m_HostListSP[IndexSP]).SP_RSC_CODE;
        HostFields[7]  := PTMQMSP(m_HostListSP[IndexSP]).SP_PROGRESED_GROUP;
        HostFields[8]  := DateTimeToStr(PTMQMSP(m_HostListSP[IndexSP]).SP_PROGRSTART);
        HostFields[9]  := DateTimeToStr(PTMQMSP(m_HostListSP[IndexSP]).SP_CURR_PRG_DATE);
        HostFields[10] := DateTimeToStr(PTMQMSP(m_HostListSP[IndexSP]).SP_PROGREND);
        HostFields[11] := FloatToStr(PTMQMSP(m_HostListSP[IndexSP]).SP_QTY);
        HostFields[12] := FloatToStr(PTMQMSP(m_HostListSP[IndexSP]).SP_StartingQty);
        HostFields[13] := PTMQMSP(m_HostListSP[IndexSP]).SP_REMAIN_TIME;
        HostFields[14] := PTMQMSP(m_HostListSP[IndexSP]).SP_LAST_PROG_TYPE_HOST;
        HostFields[15] := PTMQMSP(m_HostListSP[IndexSP]).SP_RSC_CODE_HOST;
        HostFields[16] := PTMQMSP(m_HostListSP[IndexSP]).SP_PROGRSTART_HOST;
        HostFields[17] := PTMQMSP(m_HostListSP[IndexSP]).SP_CURR_PRG_DATE_HOST;
        HostFields[18] := PTMQMSP(m_HostListSP[IndexSP]).SP_PROGREND_HOST;
        HostFields[19] := PTMQMSP(m_HostListSP[IndexSP]).SP_QTY_HOST;
        HostFields[20] := PTMQMSP(m_HostListSP[IndexSP]).SP_REMAIN_TIME_HOST;
        LocalFields[1]  := PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_PREQ_NO;
        LocalFields[2]  := PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_PSTEP_ID;
        LocalFields[3]  := PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_PSUBST_ID;
        LocalFields[4]  := PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_REPROC_NO;
        LocalFields[5]  := PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_LAST_PROG_TYPE;
        LocalFields[6]  := PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_RSC_CODE;
        LocalFields[7]  := PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_PROGRESED_GROUP;
        LocalFields[8]  := DateTimeToStr(PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_PROGRSTART);
        LocalFields[9]  := DateTimeToStr(PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_CURR_PRG_DATE);
        LocalFields[10] := DateTimeToStr(PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_PROGREND);
        LocalFields[11] := FloatToStr(PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_QTY);
        LocalFields[12] := FloatToStr(PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_StartingQty);
        LocalFields[13] := PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_REMAIN_TIME;
        LocalFields[14] := PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_LAST_PROG_TYPE_HOST;
        LocalFields[15] := PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_RSC_CODE_HOST;
        LocalFields[16] := PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_PROGRSTART_HOST;
        LocalFields[17] := PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_CURR_PRG_DATE_HOST;
        LocalFields[18] := PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_PROGREND_HOST;
        LocalFields[19] := PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_QTY_HOST;
        LocalFields[20] := PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_REMAIN_TIME_HOST;
        Operation := CompareKeys(TableNumberOfKeys, TableNumberOfFields, HostFields, LocalFields);
      end;

      if (not HostHaveData) and (PReqChange(m_Req_Change_List[I]).ChangedType = Historical) then
      begin
        if Operation = DBDelete then Inc(m_Local_IndexSP);
        if Operation = DBInsert then IndexSP := IndexSP + 1;
        if (Operation <> DBDelete) and (Operation <> DBInsert) then
        begin
          Inc(m_Local_IndexSP);
          IndexSP := IndexSP + 1;
        end;
        continue;
      end;

      if Operation = DBDelete then
      begin
        with QryDelSP do
        begin
          Temp_TimeVal := NOW;
          ParamByName(CreateFld(tblInf.pfx, fli_preqNo)).AsString := PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_PREQ_NO;
          ParamByName(CreateFld(tblInf.pfx, fli_PStepId)).AsInteger := PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_PSTEP_ID;
          ParamByName(CreateFld(tblInf.pfx, fli_psubstId)).AsInteger := PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_PSUBST_ID;
          ParamByName(CreateFld(tblInf.pfx, fli_reprocNo)).AsInteger := PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_REPROC_NO;
       //   Prepare;
          ExecSQL;
          Temp_TimeVal := NOW - Temp_TimeVal;
          IniAppGlobals.Time_DelSP := IniAppGlobals.Time_DelSP + Temp_TimeVal;
          Inc(IniAppGlobals.Count_DelSP);
          RunCommit := true;
        end;
        Inc(m_Local_IndexSP);
        continue;
      end;

      if Operation = DBInsert then
      begin

        with QryInsertSP do
        begin

{    (fldPC: fli_preqNo;           fldAS: 'SPRREQ'; fldType: TLD_string),
    (fldPC: fli_pstepId;          fldAS: 'SPRSTP'; fldType: TLD_integer),
    (fldPC: fli_psubstId;         fldAS: 'SPRSST'; fldType: TLD_integer),
    (fldPC: fli_reprocNo;         fldAS: 'SRPRNB'; fldType: TLD_integer),
    (fldPC: fli_ProgressType;     fldAS: 'SLPRTY'; fldType: TLD_string),
    (fldPC: fli_rsc;              fldAS: 'SCDRSC'; fldType: TLD_string),
    (fldPC: fli_ProgressGroup;    fldAS: 'SPRGRP'; fldType: TLD_integer),
    (fldPC: fli_progrStart;       fldAS: 'SSTRDT'; fldType: TLD_dateTime),
    (fldPC: fli_prgCurrDate;      fldAS: 'SCURDT'; fldType: TLD_dateTime),
    (fldPC: fli_progrEnd;         fldAS: 'SENDDT'; fldType: TLD_dateTime),
    (fldPC: fli_quant;            fldAS: 'SPRQTY'; fldType: TLD_float),
    (fldPC: fli_prgRemTime;       fldAS: 'SRMNTM'; fldType: TLD_float),
    (fldPC: fli_ProgressTypeHost; fldAS: 'SLPRTY'; fldType: TLD_string),
    (fldPC: fli_rscHost;          fldAS: 'SCDRSC'; fldType: TLD_string),
    (fldPC: fli_progrStartHost;   fldAS: 'SSTRDT'; fldType: TLD_dateTime),
    (fldPC: fli_prgCurrDateHost;  fldAS: 'SCURDT'; fldType: TLD_dateTime),
    (fldPC: fli_progrEndHost;     fldAS: 'SENDDT'; fldType: TLD_dateTime),
    (fldPC: fli_quantHost;        fldAS: 'SPRQTY'; fldType: TLD_float),
    (fldPC: fli_prgRemTimeHost;   fldAS: 'SRMNTM'; fldType: TLD_float)   }

          PTMQMSP(m_HostListSP[IndexSP]).SP_CreateDateTimeUTC := UTCNow;
          PTMQMSP(m_HostListSP[IndexSP]).SP_CrtOrUpdateDateTimeUTC := UTCNow;

          Temp_TimeVal := NOW;
          ParamByName('SP_PREQ_NO').AsString := PTMQMSP(m_HostListSP[IndexSP]).SP_PREQ_NO;
          ParamByName('SP_PSTEP_ID').AsInteger := PTMQMSP(m_HostListSP[IndexSP]).SP_PSTEP_ID;
          ParamByName('SP_PSUBST_ID').AsInteger := PTMQMSP(m_HostListSP[IndexSP]).SP_PSUBST_ID;
          ParamByName('SP_REPROC_NO').AsInteger := PTMQMSP(m_HostListSP[IndexSP]).SP_REPROC_NO;
          ParamByName('SP_LAST_PROG_TYPE').AsString := PTMQMSP(m_HostListSP[IndexSP]).SP_LAST_PROG_TYPE;
          ParamByName('SP_RSC_CODE').AsString := PTMQMSP(m_HostListSP[IndexSP]).SP_RSC_CODE;
          ParamByName('SP_PROGRESED_GROUP').AsInteger := PTMQMSP(m_HostListSP[IndexSP]).SP_PROGRESED_GROUP;
          ParamByName('SP_PROGRSTART').AsDateTime := PTMQMSP(m_HostListSP[IndexSP]).SP_PROGRSTART;
          ParamByName('SP_CURR_PRG_DATE').AsDateTime := PTMQMSP(m_HostListSP[IndexSP]).SP_CURR_PRG_DATE;
          ParamByName('SP_PROGREND').AsDateTime := PTMQMSP(m_HostListSP[IndexSP]).SP_PROGREND;
          ParamByName('SP_QTY').AsFloat := PTMQMSP(m_HostListSP[IndexSP]).SP_QTY;
          ParamByName('SP_START_QTY').AsFloat := PTMQMSP(m_HostListSP[IndexSP]).SP_StartingQty;
          ParamByName('SP_REMAIN_TIME').AsFloat := PTMQMSP(m_HostListSP[IndexSP]).SP_REMAIN_TIME;
          ParamByName('SP_LAST_PROG_TYPE_HOST').AsString := PTMQMSP(m_HostListSP[IndexSP]).SP_LAST_PROG_TYPE_HOST;
          ParamByName('SP_RSC_CODE_HOST').AsString := PTMQMSP(m_HostListSP[IndexSP]).SP_RSC_CODE_HOST;
          ParamByName('SP_PROGRSTART_HOST').AsDateTime := PTMQMSP(m_HostListSP[IndexSP]).SP_PROGRSTART_HOST;
          ParamByName('SP_CURR_PRG_DATE_HOST').AsDateTime := PTMQMSP(m_HostListSP[IndexSP]).SP_CURR_PRG_DATE_HOST;
          ParamByName('SP_PROGREND_HOST').AsDateTime := PTMQMSP(m_HostListSP[IndexSP]).SP_PROGREND_HOST;
          ParamByName('SP_QTY_HOST').AsFloat := PTMQMSP(m_HostListSP[IndexSP]).SP_QTY_HOST;
          ParamByName('SP_REMAIN_TIME_HOST').AsFloat := PTMQMSP(m_HostListSP[IndexSP]).SP_REMAIN_TIME_HOST;
          ParamByName('SP_CREATE_DATE_TIME_UTC').AsDateTime := PTMQMSP(m_HostListSP[IndexSP]).SP_CreateDateTimeUTC;
          ParamByName('SP_UPDATED_DATE_TIME_UTC').AsDateTime := PTMQMSP(m_HostListSP[IndexSP]).SP_CrtOrUpdateDateTimeUTC;
          ParamByName('SP_IDENTIFIER').AsString := IniAppGlobals.Identifier;

          try
            ExecSQL;

            RunCommit := true;
          except
         {   except
            on E: Exception do
            begin
              E.Message := E.Message + ('  Request : ' + PTMQMSP(m_HostListSP[IndexSP]).SP_PREQ_NO + '   Step :' + IntToStr(PTMQMSP(m_HostListSP[IndexSP]).SP_PSTEP_ID) +
                                        '  Sub Step : ' + IntToStr(PTMQMSP(m_HostListSP[IndexSP]).SP_PSUBST_ID));
              raise;
            end;  }
          end;
        end;
        Temp_TimeVal := NOW - Temp_TimeVal;
            IniAppGlobals.Time_InsertSP := IniAppGlobals.Time_InsertSP + Temp_TimeVal;
            Inc(IniAppGlobals.Count_InsertSP);
        IndexSP := IndexSP + 1;
        continue;
      end;

      if Operation = DBUpdate then
      begin
        with QryUpdateSP do
        begin
          Temp_TimeVal := NOW;
          PTMQMSP(m_HostListSP[IndexSP]).SP_CrtOrUpdateDateTimeUTC := UTCNow;
          ParamByName('SP_LAST_PROG_TYPE').AsString := PTMQMSP(m_HostListSP[IndexSP]).SP_LAST_PROG_TYPE;
          ParamByName('SP_RSC_CODE').AsString := PTMQMSP(m_HostListSP[IndexSP]).SP_RSC_CODE;
          ParamByName('SP_PROGRESED_GROUP').AsInteger := PTMQMSP(m_HostListSP[IndexSP]).SP_PROGRESED_GROUP;
          ParamByName('SP_PROGRSTART').AsDateTime := PTMQMSP(m_HostListSP[IndexSP]).SP_PROGRSTART;
          ParamByName('SP_CURR_PRG_DATE').AsDateTime := PTMQMSP(m_HostListSP[IndexSP]).SP_CURR_PRG_DATE;
          ParamByName('SP_PROGREND').AsDateTime := PTMQMSP(m_HostListSP[IndexSP]).SP_PROGREND;
          ParamByName('SP_QTY').AsFloat := PTMQMSP(m_HostListSP[IndexSP]).SP_QTY;
          ParamByName('SP_START_QTY').AsFloat := PTMQMSP(m_HostListSP[IndexSP]).SP_StartingQty;
          ParamByName('SP_REMAIN_TIME').AsFloat := PTMQMSP(m_HostListSP[IndexSP]).SP_REMAIN_TIME;
          ParamByName('SP_LAST_PROG_TYPE_HOST').AsString := PTMQMSP(m_HostListSP[IndexSP]).SP_LAST_PROG_TYPE_HOST;
          ParamByName('SP_RSC_CODE_HOST').AsString := PTMQMSP(m_HostListSP[IndexSP]).SP_RSC_CODE_HOST;
          ParamByName('SP_PROGRSTART_HOST').AsDateTime := PTMQMSP(m_HostListSP[IndexSP]).SP_PROGRSTART_HOST;
          ParamByName('SP_CURR_PRG_DATE_HOST').AsDateTime := PTMQMSP(m_HostListSP[IndexSP]).SP_CURR_PRG_DATE_HOST;
          ParamByName('SP_PROGREND_HOST').AsDateTime := PTMQMSP(m_HostListSP[IndexSP]).SP_PROGREND_HOST;
          ParamByName('SP_QTY_HOST').AsFloat := PTMQMSP(m_HostListSP[IndexSP]).SP_QTY_HOST;
          ParamByName('SP_REMAIN_TIME_HOST').AsFloat := PTMQMSP(m_HostListSP[IndexSP]).SP_REMAIN_TIME_HOST;
          ParamByName('SP_UPDATED_DATE_TIME_UTC').AsDateTime := PTMQMSP(m_HostListSP[IndexSP]).SP_CrtOrUpdateDateTimeUTC;
          ParamByName('SP_PREQ_NO').AsString := PTMQMSP(m_HostListSP[IndexSP]).SP_PREQ_NO;
          ParamByName('SP_PSTEP_ID').AsInteger := PTMQMSP(m_HostListSP[IndexSP]).SP_PSTEP_ID;
          ParamByName('SP_PSUBST_ID').AsInteger := PTMQMSP(m_HostListSP[IndexSP]).SP_PSUBST_ID;
          ParamByName('SP_REPROC_NO').AsInteger := PTMQMSP(m_HostListSP[IndexSP]).SP_REPROC_NO;
          try
            ExecSQL;

          except
          end;
          Temp_TimeVal := NOW - Temp_TimeVal;
            IniAppGlobals.Time_UpdateSP := IniAppGlobals.Time_UpdateSP + Temp_TimeVal;
            Inc(IniAppGlobals.Count_UpdateSP);
          RunCommit := true;
        end;

      end;
      Inc(m_Local_IndexSP);
      IndexSP := IndexSP + 1;
    end;

    //*******************************************************************************//
    //**************************** tbl_step_times *******************************//
    //*******************************************************************************//

    tblInf := @tblInfo[tbl_step_times];
    while (IndexST <= m_HostListST.count - 1) and (Request > PTMQMST(m_HostListST[IndexST]).ST_PREQ_NO) do
    begin
      inc(IndexST);
    end;
    while (not EOL_Local(ST)) and (Request > PTMQMST(m_LocalListST[m_Local_IndexST]).ST_PREQ_NO) do
    begin
      Inc(m_Local_IndexST);
    end;

    FirstCycle := true;
    HostHaveData := true;
    EndRequestDataHost := false;
    EndRequestDataLocal := false;
    while true do
    begin
      if (IndexST > m_HostListST.count - 1) or (Request < PTMQMST(m_HostListST[IndexST]).ST_PREQ_NO)
      or (PReqChange(m_Req_Change_List[I]).ChangedType = DelReq) then EndRequestDataHost := true;
      if (EOL_Local(ST) or (Request < PTMQMST(m_LocalListST[m_Local_IndexST]).ST_PREQ_NO))
      then EndRequestDataLocal := true;

      if EndRequestDataHost and EndRequestDataLocal then break;

      Operation := DBEqual;

      if EndRequestDataHost then
      begin
        Operation := DBDelete;
        if FirstCycle then HostHaveData := false;
      end;
      FirstCycle := False;

      if EndRequestDataLocal then Operation := DBInsert;

      if Operation = DBEqual then
      begin
        TableNumberOfKeys := KeyNumST;
        TableNumberOfFields := 9;
        HostFields[1] := PTMQMST(m_HostListST[IndexST]).ST_PREQ_NO;
        HostFields[2] := PTMQMST(m_HostListST[IndexST]).ST_PSTEP_ID;
        HostFields[3] := PTMQMST(m_HostListST[IndexST]).ST_WKCNTER;
        HostFields[4] := PTMQMST(m_HostListST[IndexST]).ST_WKCT_PROC;
        HostFields[5] := PTMQMST(m_HostListST[IndexST]).ST_RES_CATEGORY;
        HostFields[6] := PTMQMST(m_HostListST[IndexST]).ST_RSC_CODE;
        HostFields[7] := PTMQMST(m_HostListST[IndexST]).ST_SETUP_TIME_Mechin_Code;
        HostFields[8] := PTMQMST(m_HostListST[IndexST]).ST_SETUP_TIME_JOB;
        HostFields[9] := PTMQMST(m_HostListST[IndexST]).ST_EXC_TIME_INIT_QTY;
        LocalFields[1] := PTMQMST(m_LocalListST[m_Local_IndexST]).ST_PREQ_NO;
        LocalFields[2] := PTMQMST(m_LocalListST[m_Local_IndexST]).ST_PSTEP_ID;
        LocalFields[3] := PTMQMST(m_LocalListST[m_Local_IndexST]).ST_WKCNTER;
        LocalFields[4] := PTMQMST(m_LocalListST[m_Local_IndexST]).ST_WKCT_PROC;
        LocalFields[5] := PTMQMST(m_LocalListST[m_Local_IndexST]).ST_RES_CATEGORY;
        LocalFields[6] := PTMQMST(m_LocalListST[m_Local_IndexST]).ST_RSC_CODE;
        LocalFields[7] := PTMQMST(m_LocalListST[m_Local_IndexST]).ST_SETUP_TIME_Mechin_Code;
        LocalFields[8] := PTMQMST(m_LocalListST[m_Local_IndexST]).ST_SETUP_TIME_JOB;
        LocalFields[9] := PTMQMST(m_LocalListST[m_Local_IndexST]).ST_EXC_TIME_INIT_QTY;
        Operation := CompareKeys(TableNumberOfKeys, TableNumberOfFields, HostFields, LocalFields);
      end;

      if (not HostHaveData) and (PReqChange(m_Req_Change_List[I]).ChangedType = Historical) then
      begin
        if Operation = DBDelete then Inc(m_Local_IndexST);
        if Operation = DBInsert then IndexST := IndexST + 1;
        if (Operation <> DBDelete) and (Operation <> DBInsert) then
        begin
          Inc(m_Local_IndexST);
          IndexST := IndexST + 1;
        end;
        continue;
      end;

      if Operation = DBDelete then
      begin

        if DndArchiveLocalName = TD_Oracle then
        begin
          if PTMQMST(m_LocalListST[m_Local_IndexST]).ST_WKCNTER = '' then
             PTMQMST(m_LocalListST[m_Local_IndexST]).ST_WKCNTER := ' ';
          if PTMQMST(m_LocalListST[m_Local_IndexST]).ST_WKCT_PROC = '' then
             PTMQMST(m_LocalListST[m_Local_IndexST]).ST_WKCT_PROC := ' ';
          if PTMQMST(m_LocalListST[m_Local_IndexST]).ST_RES_CATEGORY = '' then
             PTMQMST(m_LocalListST[m_Local_IndexST]).ST_RES_CATEGORY := ' ';
          if PTMQMST(m_LocalListST[m_Local_IndexST]).ST_RSC_CODE = '' then
             PTMQMST(m_LocalListST[m_Local_IndexST]).ST_RSC_CODE := ' ' ;
          if PTMQMST(m_LocalListST[m_Local_IndexST]).ST_SETUP_TIME_Mechin_Code = '' then
             PTMQMST(m_LocalListST[m_Local_IndexST]).ST_SETUP_TIME_Mechin_Code := ' ' ;
        end;

        with QryDelST do
        begin
          Temp_TimeVal := NOW;
          ParamByName(CreateFld(tblInf.pfx, fli_preqNo)).AsString           := PTMQMST(m_LocalListST[m_Local_IndexST]).ST_PREQ_NO;
          ParamByName(CreateFld(tblInf.pfx, fli_pstepId)).AsInteger         := PTMQMST(m_LocalListST[m_Local_IndexST]).ST_PSTEP_ID;
          ParamByName(CreateFld(tblInf.pfx, fli_wkCtrCode)).AsString        := PTMQMST(m_LocalListST[m_Local_IndexST]).ST_WKCNTER;
          ParamByName(CreateFld(tblInf.pfx, fli_wkcProc)).AsString          := PTMQMST(m_LocalListST[m_Local_IndexST]).ST_WKCT_PROC;
          ParamByName(CreateFld(tblInf.pfx, fli_rscCat)).AsString           := PTMQMST(m_LocalListST[m_Local_IndexST]).ST_RES_CATEGORY;
          ParamByName(CreateFld(tblInf.pfx, fli_rsc)).AsString              := PTMQMST(m_LocalListST[m_Local_IndexST]).ST_RSC_CODE;
          ParamByName(CreateFld(tblInf.pfx, fli_MachSetupCode)).AsString    := PTMQMST(m_LocalListST[m_Local_IndexST]).ST_SETUP_TIME_Mechin_Code;
        //  Prepare;
          ExecSQL;
          Temp_TimeVal := NOW - Temp_TimeVal;
          IniAppGlobals.Time_DelST := IniAppGlobals.Time_DelST + Temp_TimeVal;
          Inc(IniAppGlobals.Count_DelST);
          RunCommit := true;
        end;
        Inc(m_Local_IndexST);
        continue;
      end;

      if Operation = DBInsert then
      begin
        PTMQMST(m_HostListST[IndexST]).ST_CreateDateTimeUTC := UTCNow;
        PTMQMST(m_HostListST[IndexST]).ST_CrtOrUpdateDateTimeUTC := UTCNow;
        with QryInsertST do
        begin
          Temp_TimeVal := NOW;
          if DndArchiveLocalName = TD_Oracle then
          begin
            if PTMQMST(m_HostListST[IndexST]).ST_WKCNTER = '' then
               PTMQMST(m_HostListST[IndexST]).ST_WKCNTER := ' ';
            if PTMQMST(m_HostListST[IndexST]).ST_WKCT_PROC = '' then
               PTMQMST(m_HostListST[IndexST]).ST_WKCT_PROC := ' ';
            if PTMQMST(m_HostListST[IndexST]).ST_RES_CATEGORY = '' then
               PTMQMST(m_HostListST[IndexST]).ST_RES_CATEGORY := ' ';
            if PTMQMST(m_HostListST[IndexST]).ST_RSC_CODE = '' then
               PTMQMST(m_HostListST[IndexST]).ST_RSC_CODE := ' ' ;
            if PTMQMST(m_HostListST[IndexST]).ST_SETUP_TIME_Mechin_Code = '' then
               PTMQMST(m_HostListST[IndexST]).ST_SETUP_TIME_Mechin_Code := ' ' ;
          end;

          ParamByName('ST_PREQ_NO').AsString := PTMQMST(m_HostListST[IndexST]).ST_PREQ_NO;
          ParamByName('ST_PSTEP_ID').AsInteger := PTMQMST(m_HostListST[IndexST]).ST_PSTEP_ID;
          ParamByName('ST_WKCNTER').AsString := PTMQMST(m_HostListST[IndexST]).ST_WKCNTER;
          ParamByName('ST_WKCT_PROC').AsString := PTMQMST(m_HostListST[IndexST]).ST_WKCT_PROC;
          ParamByName('ST_RES_CATEGORY').AsString := PTMQMST(m_HostListST[IndexST]).ST_RES_CATEGORY;
          ParamByName('ST_RSC_CODE').AsString := PTMQMST(m_HostListST[IndexST]).ST_RSC_CODE;
          ParamByName('ST_MACHINE_SETUP_CODE').AsString := PTMQMST(m_HostListST[IndexST]).ST_SETUP_TIME_Mechin_Code;
          ParamByName('ST_SETUP_TIME_JOB').AsFloat := PTMQMST(m_HostListST[IndexST]).ST_SETUP_TIME_JOB;
          ParamByName('ST_EXC_TIME_INIT_QTY').AsFloat := PTMQMST(m_HostListST[IndexST]).ST_EXC_TIME_INIT_QTY;
          ParamByName('ST_CREATE_DATE_TIME_UTC').AsDateTime := PTMQMST(m_HostListST[IndexST]).ST_CreateDateTimeUTC;
          ParamByName('ST_UPDATED_DATE_TIME_UTC').AsDateTime := PTMQMST(m_HostListST[IndexST]).ST_CrtOrUpdateDateTimeUTC;
          ParamByName('ST_IDENTIFIER').AsString := IniAppGlobals.Identifier;
          try
            ExecSQL;
            RunCommit := true;
          except
          end;

          Temp_TimeVal := NOW - Temp_TimeVal;
          IniAppGlobals.Time_InsertST := IniAppGlobals.Time_InsertST + Temp_TimeVal;
          Inc(IniAppGlobals.Count_InsertST);
        end;
        IndexST := IndexST + 1;
        continue;
      end;

      if Operation = DBUpdate then
      begin
        with QryUpdateST do
        begin

          PTMQMST(m_HostListST[IndexST]).ST_CrtOrUpdateDateTimeUTC := UTCNow;
          if DndArchiveLocalName = TD_Oracle then
          begin
            if PTMQMST(m_HostListST[IndexST]).ST_WKCNTER = '' then
               PTMQMST(m_HostListST[IndexST]).ST_WKCNTER := ' ';
            if PTMQMST(m_HostListST[IndexST]).ST_WKCT_PROC = '' then
               PTMQMST(m_HostListST[IndexST]).ST_WKCT_PROC := ' ';
            if PTMQMST(m_HostListST[IndexST]).ST_RES_CATEGORY = '' then
               PTMQMST(m_HostListST[IndexST]).ST_RES_CATEGORY := ' ';
            if PTMQMST(m_HostListST[IndexST]).ST_RSC_CODE = '' then
               PTMQMST(m_HostListST[IndexST]).ST_RSC_CODE := ' ' ;
            if PTMQMST(m_HostListST[IndexST]).ST_SETUP_TIME_Mechin_Code = '' then
               PTMQMST(m_HostListST[IndexST]).ST_SETUP_TIME_Mechin_Code := ' ' ;
          end;

          Temp_TimeVal := NOW;
          ParamByName('ST_EXC_TIME_INIT_QTY').AsFloat := PTMQMST(m_HostListST[IndexST]).ST_EXC_TIME_INIT_QTY;
          ParamByName('ST_SETUP_TIME_JOB').AsFloat := PTMQMST(m_HostListST[IndexST]).ST_SETUP_TIME_JOB;
          ParamByName('ST_UPDATED_DATE_TIME_UTC').AsDateTime := PTMQMST(m_HostListST[IndexST]).ST_CrtOrUpdateDateTimeUTC;
          ParamByName('ST_PREQ_NO').AsString := PTMQMST(m_HostListST[IndexST]).ST_PREQ_NO;
          ParamByName('ST_PSTEP_ID').AsInteger := PTMQMST(m_HostListST[IndexST]).ST_PSTEP_ID;
          ParamByName('ST_WKCNTER').AsString := PTMQMST(m_HostListST[IndexST]).ST_WKCNTER;
          ParamByName('ST_WKCT_PROC').AsString := PTMQMST(m_HostListST[IndexST]).ST_WKCT_PROC;
          ParamByName('ST_RES_CATEGORY').AsString := PTMQMST(m_HostListST[IndexST]).ST_RES_CATEGORY;
          ParamByName('ST_RSC_CODE').AsString := PTMQMST(m_HostListST[IndexST]).ST_RSC_CODE;
          ParamByName('ST_MACHINE_SETUP_CODE').AsString := PTMQMST(m_HostListST[IndexST]).ST_SETUP_TIME_Mechin_Code;

          try
            ExecSQL;
          except
          end;
          Temp_TimeVal := NOW - Temp_TimeVal;
          IniAppGlobals.Time_UpdateST := IniAppGlobals.Time_UpdateST + Temp_TimeVal;
          Inc(IniAppGlobals.Count_UpdateST);
          RunCommit := true;
        end;
      end;
      Inc(m_Local_IndexST);
      IndexST := IndexST + 1;
    end;

    //*******************************************************************************//
    //**************************** tbl_Material *******************************//
    //*******************************************************************************//

    tblInf := @tblInfo[tbl_Material];
    while (IndexMT <= m_HostlistMT.count - 1) and (Request > PTMQMMT(m_HostlistMT[IndexMT]).MT_PROD_REQ_Nr) do
    begin
      inc(IndexMT);
    end;
    while (not EOL_Local(MT)) and (Request > PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_PROD_REQ_Nr) do
    begin
      Inc(m_Local_IndexMT);
    end;

    FirstCycle := true;
    HostHaveData := true;
    EndRequestDataHost := false;
    EndRequestDataLocal := false;
    while true do
    begin
      if (IndexMT > m_HostlistMT.count - 1) or (Request < PTMQMMT(m_HostlistMT[IndexMT]).MT_PROD_REQ_Nr)
      or (PReqChange(m_Req_Change_List[I]).ChangedType = DelReq) then EndRequestDataHost := true;
      if (EOL_Local(MT) or (Request < PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_PROD_REQ_Nr))
      then EndRequestDataLocal := true;

      if EndRequestDataHost and EndRequestDataLocal then break;

      Operation := DBEqual;

      if EndRequestDataHost then
      begin
        Operation := DBDelete;
        if FirstCycle then HostHaveData := false;
      end;
      FirstCycle := False;

      if EndRequestDataLocal then Operation := DBInsert;

      if Operation = DBEqual then
      begin
        TableNumberOfKeys := KeyNumMT;
        TableNumberOfFields := 20;
        HostFields[1]  := PTMQMMT(m_HostlistMT[IndexMT]).MT_PROD_REQ_Nr;
        HostFields[2]  := PTMQMMT(m_HostlistMT[IndexMT]).MT_PSTEP_ID;
        HostFields[3]  := PTMQMMT(m_HostlistMT[IndexMT]).MT_ORG_STEP;
        HostFields[4]  := PTMQMMT(m_HostlistMT[IndexMT]).MT_WKCTR_CODE;
        HostFields[5]  := PTMQMMT(m_HostlistMT[IndexMT]).MT_RES_CAT_CODE;
        HostFields[6]  := PTMQMMT(m_HostlistMT[IndexMT]).MT_RES_CODE;
        HostFields[7]  := PTMQMMT(m_HostlistMT[IndexMT]).MT_MACHIN_SETUP_CODE;
        HostFields[8]  := PTMQMMT(m_HostlistMT[IndexMT]).MT_ALTERNATIVE_CODE;
        HostFields[9]  := PTMQMMT(m_HostlistMT[IndexMT]).MT_PROD_TYPE;
        HostFields[10]  := PTMQMMT(m_HostlistMT[IndexMT]).MT_PROD_CODE;
        HostFields[11] := PTMQMMT(m_HostlistMT[IndexMT]).MT_NET_GROUP_CODE;
        HostFields[12] := PTMQMMT(m_HostlistMT[IndexMT]).MT_ISSUE_CODE;
        HostFields[13] := PTMQMMT(m_HostlistMT[IndexMT]).MT_SEQ_ISSUED;
        HostFields[14] := PTMQMMT(m_HostlistMT[IndexMT]).MT_MAT_BALACE;
        HostFields[15] := PTMQMMT(m_HostlistMT[IndexMT]).MT_QUANTITY_ALLOC;
        HostFields[16] := PTMQMMT(m_HostlistMT[IndexMT]).MT_HIGH_DATe_ALLOC;
        HostFields[17] := PTMQMMT(m_HostlistMT[IndexMT]).MT_SEARCH_MAT_BY_ALLOC;
        HostFields[18] := PTMQMMT(m_HostlistMT[IndexMT]).MT_SETTLED;
        HostFields[19] := PTMQMMT(m_HostlistMT[IndexMT]).MT_QUANTITY_ISSUE;
        HostFields[20] := PTMQMMT(m_HostlistMT[IndexMT]).MT_REQ_QUANTITY;
        HostFields[21] := PTMQMMT(m_HostlistMT[IndexMT]).MT_ORG_STEP;
        LocalFields[1]  := PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_PROD_REQ_Nr;
        LocalFields[2]  := PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_PSTEP_ID;
        LocalFields[3]  := PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_ORG_STEP;
        LocalFields[4]  := PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_WKCTR_CODE;
        LocalFields[5]  := PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_RES_CAT_CODE;
        LocalFields[6]  := PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_RES_CODE;
        LocalFields[7]  := PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_MACHIN_SETUP_CODE;
        LocalFields[8]  := PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_ALTERNATIVE_CODE;
        LocalFields[9]  := PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_PROD_TYPE;
        LocalFields[10]  := PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_PROD_CODE;
        LocalFields[11] := PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_NET_GROUP_CODE;
        LocalFields[12] := PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_ISSUE_CODE;
        LocalFields[13] := PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_SEQ_ISSUED;
        LocalFields[14] := PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_MAT_BALACE;
        LocalFields[15] := PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_QUANTITY_ALLOC;
        LocalFields[16] := PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_HIGH_DATe_ALLOC;
        LocalFields[17] := PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_SEARCH_MAT_BY_ALLOC;
        LocalFields[18] := PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_SETTLED;
        LocalFields[19] := PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_QUANTITY_ISSUE;
        LocalFields[20] := PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_REQ_QUANTITY;
        LocalFields[21] := PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_ORG_STEP;
        Operation := CompareKeys(TableNumberOfKeys, TableNumberOfFields, HostFields, LocalFields);
      end;

      if (not HostHaveData) and (PReqChange(m_Req_Change_List[I]).ChangedType = Historical) then
      begin
        if Operation = DBDelete then Inc(m_Local_IndexMT);
        if Operation = DBInsert then IndexMT := IndexMT + 1;
        if (Operation <> DBDelete) and (Operation <> DBInsert) then
        begin
          Inc(m_Local_IndexMT);
          IndexMT := IndexMT + 1;
        end;
        continue;
      end;

      if Operation = DBDelete then
      begin

          if DndArchiveLocalName = TD_Oracle then
          begin
            if PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_WKCTR_CODE = '' then
               PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_WKCTR_CODE := ' ';
            if PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_RES_CAT_CODE = '' then
               PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_RES_CAT_CODE := ' ';
            if PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_MACHIN_SETUP_CODE = '' then
               PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_MACHIN_SETUP_CODE := ' ';
            if PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_ALTERNATIVE_CODE = '' then
               PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_ALTERNATIVE_CODE := ' ' ;
            if PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_PROD_TYPE = '' then
               PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_PROD_TYPE := ' ' ;
            if PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_RES_CODE = '' then
               PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_RES_CODE := ' ' ;
            if PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_NET_GROUP_CODE = '' then
               PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_NET_GROUP_CODE := ' ' ;
            if PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_ISSUE_CODE = '' then
               PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_ISSUE_CODE := ' ' ;
            if PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_SEQ_ISSUED = '' then
               PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_SEQ_ISSUED := ' ' ;
          end;

        with QryDelMT do
        begin
          Temp_TimeVal := NOW;
          ParamByName(CreateFld(tblInf.pfx, fli_preqNo)).AsString := PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_PROD_REQ_Nr;
          ParamByName(CreateFld(tblInf.pfx, fli_PStepId)).AsInteger := PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_PSTEP_ID;
          ParamByName(CreateFld(tblInf.pfx, fli_orgStep)).AsInteger := PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_PSTEP_ID;
          ParamByName(CreateFld(tblInf.pfx, fli_wkCtrCode)).AsString := PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_WKCTR_CODE;
          ParamByName(CreateFld(tblInf.pfx, fli_ResCatcode)).AsString := PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_RES_CAT_CODE;
          ParamByName(CreateFld(tblInf.pfx, fli_Rsc)).AsString := PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_RES_CODE;
          ParamByName(CreateFld(tblInf.pfx, fli_MachSetupCode)).AsString := PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_MACHIN_SETUP_CODE;
          ParamByName(CreateFld(tblInf.pfx, fli_AlternativCode)).AsString :=PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_ALTERNATIVE_CODE;
          ParamByName(CreateFld(tblInf.pfx, fli_prodtype)).AsString := PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_PROD_TYPE;
          ParamByName(CreateFld(tblInf.pfx, fli_ProdCode)).AsString := PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_PROD_CODE;
          ParamByName(CreateFld(tblInf.pfx, fli_netGroupCode)).AsString := PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_NET_GROUP_CODE;
          ParamByName(CreateFld(tblInf.pfx, fli_issueCode)).AsString := PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_ISSUE_CODE;
          ParamByName(CreateFld(tblInf.pfx, fli_seqIssued)).AsString := PTMQMMT(m_LocalListMT[m_Local_IndexMT]).MT_SEQ_ISSUED;
       //   Prepare;
          try
            ExecSQL;

            RunCommit := true;
           except
            on E: Exception do
            begin
              ShowMessage(QryInsertMT.SQL.Text + '    ' + QryInsertSql);
              E.Message := E.Message + ('  Request : ' + PTMQMMT(m_HostlistMT[IndexMT]).MT_PROD_REQ_Nr + '   Step :' + IntToStr(PTMQMMT(m_HostlistMT[IndexMT]).MT_PSTEP_ID));
              raise;
            end;
          end;
          Temp_TimeVal := NOW - Temp_TimeVal;
            IniAppGlobals.Time_DelMT := IniAppGlobals.Time_DelMT + Temp_TimeVal;
            Inc(IniAppGlobals.Count_DelMT);

        end;
        Inc(m_Local_IndexMT);
        continue;
      end;

      if Operation = DBInsert then
      begin
        with QryInsertMT do
        begin

          if DndArchiveLocalName = TD_Oracle then
          begin
            if PTMQMMT(m_HostlistMT[IndexMT]).MT_WKCTR_CODE = '' then
               PTMQMMT(m_HostlistMT[IndexMT]).MT_WKCTR_CODE := ' ';
            if PTMQMMT(m_HostlistMT[IndexMT]).MT_RES_CAT_CODE = '' then
               PTMQMMT(m_HostlistMT[IndexMT]).MT_RES_CAT_CODE := ' ';
            if PTMQMMT(m_HostlistMT[IndexMT]).MT_MACHIN_SETUP_CODE = '' then
               PTMQMMT(m_HostlistMT[IndexMT]).MT_MACHIN_SETUP_CODE := ' ';
            if PTMQMMT(m_HostlistMT[IndexMT]).MT_ALTERNATIVE_CODE = '' then
               PTMQMMT(m_HostlistMT[IndexMT]).MT_ALTERNATIVE_CODE := ' ' ;
            if PTMQMMT(m_HostlistMT[IndexMT]).MT_PROD_TYPE = '' then
               PTMQMMT(m_HostlistMT[IndexMT]).MT_PROD_TYPE := ' ' ;
            if PTMQMMT(m_HostlistMT[IndexMT]).MT_RES_CODE = '' then
               PTMQMMT(m_HostlistMT[IndexMT]).MT_RES_CODE := ' ' ;
            if PTMQMMT(m_HostlistMT[IndexMT]).MT_NET_GROUP_CODE = '' then
               PTMQMMT(m_HostlistMT[IndexMT]).MT_NET_GROUP_CODE := ' ' ;
            if PTMQMMT(m_HostlistMT[IndexMT]).MT_ISSUE_CODE = '' then
               PTMQMMT(m_HostlistMT[IndexMT]).MT_ISSUE_CODE := ' ' ;
            if PTMQMMT(m_HostlistMT[IndexMT]).MT_SEQ_ISSUED = '' then
               PTMQMMT(m_HostlistMT[IndexMT]).MT_SEQ_ISSUED := ' ' ;
          end;

          // currently MT_REQ_QUANTITY field is 11,2
          if PTMQMMT(m_HostlistMT[IndexMT]).MT_REQ_QUANTITY > 999999999 then
              PTMQMMT(m_HostlistMT[IndexMT]).MT_REQ_QUANTITY := 999999999;

          PTMQMMT(m_HostlistMT[IndexMT]).MT_CreateDateTimeUTC := UTCNow;
          PTMQMMT(m_HostlistMT[IndexMT]).MT_CrtOrUpdateDateTimeUTC := UTCNow;
          Temp_TimeVal := NOW;
          ParamByName('MT_PREQ_NO').AsString := PTMQMMT(m_HostlistMT[IndexMT]).MT_PROD_REQ_Nr;
          ParamByName('MT_PSTEP_ID').AsInteger := PTMQMMT(m_HostlistMT[IndexMT]).MT_PSTEP_ID;
          ParamByName('MT_ORG_STEP').AsInteger := PTMQMMT(m_HostlistMT[IndexMT]).MT_ORG_STEP;
          ParamByName('MT_WKCNTER').AsString := PTMQMMT(m_HostlistMT[IndexMT]).MT_WKCTR_CODE;
          ParamByName('MT_RES_CAT_CODE').AsString := PTMQMMT(m_HostlistMT[IndexMT]).MT_RES_CAT_CODE;
          ParamByName('MT_RSC_CODE').AsString := PTMQMMT(m_HostlistMT[IndexMT]).MT_RES_CODE;
          ParamByName('MT_MACHINE_SETUP_CODE').AsString := PTMQMMT(m_HostlistMT[IndexMT]).MT_MACHIN_SETUP_CODE;
          ParamByName('MT_ALTERNATIVE_CODE').AsString := PTMQMMT(m_HostlistMT[IndexMT]).MT_ALTERNATIVE_CODE;
          ParamByName('MT_TYPE_PROD').AsString := PTMQMMT(m_HostlistMT[IndexMT]).MT_PROD_TYPE;
          ParamByName('MT_PRODUCT_CODE').AsString := PTMQMMT(m_HostlistMT[IndexMT]).MT_PROD_CODE;
          ParamByName('MT_NET_GROUP_CODE').AsString := PTMQMMT(m_HostlistMT[IndexMT]).MT_NET_GROUP_CODE;
          ParamByName('MT_ISSUE_CODE').AsString := PTMQMMT(m_HostlistMT[IndexMT]).MT_ISSUE_CODE;
          ParamByName('MT_SEQ_ISSUED').AsString := PTMQMMT(m_HostlistMT[IndexMT]).MT_SEQ_ISSUED;
          ParamByName('MT_MAT_BALANCE').AsString := PTMQMMT(m_HostlistMT[IndexMT]).MT_MAT_BALACE;
          ParamByName('MT_QTY_ALLOC').AsFloat := PTMQMMT(m_HostlistMT[IndexMT]).MT_QUANTITY_ALLOC;
          ParamByName('MT_HIGH_DATE_ALLOC').AsDateTime := PTMQMMT(m_HostlistMT[IndexMT]).MT_HIGH_DATe_ALLOC;
          ParamByName('MT_SEARCH_MAT_ALLOC').AsString := PTMQMMT(m_HostlistMT[IndexMT]).MT_SEARCH_MAT_BY_ALLOC;
          ParamByName('MT_SETTLED').AsString := PTMQMMT(m_HostlistMT[IndexMT]).MT_SETTLED;
          ParamByName('MT_QUANTITY_ISSUE').AsFloat := PTMQMMT(m_HostlistMT[IndexMT]).MT_QUANTITY_ISSUE;
          ParamByName('MT_REQ_QUANTITY').AsFloat := PTMQMMT(m_HostlistMT[IndexMT]).MT_REQ_QUANTITY;
          ParamByName('MT_CREATE_DATE_TIME_UTC').AsDateTime := PTMQMMT(m_HostlistMT[IndexMT]).MT_CreateDateTimeUTC;
          ParamByName('MT_UPDATED_DATE_TIME_UTC').AsDateTime := PTMQMMT(m_HostlistMT[IndexMT]).MT_CrtOrUpdateDateTimeUTC;
          ParamByName('MT_IDENTIFIER').AsString := IniAppGlobals.Identifier;
          try
            ExecSQL;

          except
          end;
          Temp_TimeVal := NOW - Temp_TimeVal;
            IniAppGlobals.Time_InsertMT := IniAppGlobals.Time_InsertMT + Temp_TimeVal;
            Inc(IniAppGlobals.Count_InsertMT);
          RunCommit := true;
          { except
            on E: Exception do
            begin
              E.Message := E.Message + ('  Request : ' + PTMQMMT(m_HostlistMT[IndexMT]).MT_PROD_REQ_Nr + '   Step :' + IntToStr(PTMQMMT(m_HostlistMT[IndexMT]).MT_PSTEP_ID));
              raise;
            end;
          end;    }
        end;
        IndexMT := IndexMT + 1;
        continue;
      end;

      if Operation = DBUpdate then
      begin
        with QryUpdateMT do
        begin

          if PTMQMMT(m_HostlistMT[IndexMT]).MT_REQ_QUANTITY > 999999999 then
              PTMQMMT(m_HostlistMT[IndexMT]).MT_REQ_QUANTITY := 999999999;


          if DndArchiveLocalName = TD_Oracle then
          begin
            if PTMQMMT(m_HostlistMT[IndexMT]).MT_WKCTR_CODE = '' then
               PTMQMMT(m_HostlistMT[IndexMT]).MT_WKCTR_CODE := ' ';
            if PTMQMMT(m_HostlistMT[IndexMT]).MT_RES_CAT_CODE = '' then
               PTMQMMT(m_HostlistMT[IndexMT]).MT_RES_CAT_CODE := ' ';
            if PTMQMMT(m_HostlistMT[IndexMT]).MT_MACHIN_SETUP_CODE = '' then
               PTMQMMT(m_HostlistMT[IndexMT]).MT_MACHIN_SETUP_CODE := ' ';
            if PTMQMMT(m_HostlistMT[IndexMT]).MT_ALTERNATIVE_CODE = '' then
               PTMQMMT(m_HostlistMT[IndexMT]).MT_ALTERNATIVE_CODE := ' ' ;
            if PTMQMMT(m_HostlistMT[IndexMT]).MT_PROD_TYPE = '' then
               PTMQMMT(m_HostlistMT[IndexMT]).MT_PROD_TYPE := ' ' ;
            if PTMQMMT(m_HostlistMT[IndexMT]).MT_RES_CODE = '' then
               PTMQMMT(m_HostlistMT[IndexMT]).MT_RES_CODE := ' ' ;
            if PTMQMMT(m_HostlistMT[IndexMT]).MT_NET_GROUP_CODE = '' then
               PTMQMMT(m_HostlistMT[IndexMT]).MT_NET_GROUP_CODE := ' ' ;
            if PTMQMMT(m_HostlistMT[IndexMT]).MT_ISSUE_CODE = '' then
               PTMQMMT(m_HostlistMT[IndexMT]).MT_ISSUE_CODE := ' ' ;
            if PTMQMMT(m_HostlistMT[IndexMT]).MT_SEQ_ISSUED = '' then
               PTMQMMT(m_HostlistMT[IndexMT]).MT_SEQ_ISSUED := ' ' ;
          end;

          PTMQMMT(m_HostlistMT[IndexMT]).MT_CrtOrUpdateDateTimeUTC := UTCNow;
          Temp_TimeVal := NOW;
          ParamByName('MT_ORG_STEP').AsInteger := PTMQMMT(m_HostlistMT[IndexMT]).MT_ORG_STEP;
          ParamByName('MT_MAT_BALANCE').AsString := PTMQMMT(m_HostlistMT[IndexMT]).MT_MAT_BALACE;
          ParamByName('MT_QTY_ALLOC').AsFloat := PTMQMMT(m_HostlistMT[IndexMT]).MT_QUANTITY_ALLOC;
          ParamByName('MT_HIGH_DATE_ALLOC').AsDateTime := PTMQMMT(m_HostlistMT[IndexMT]).MT_HIGH_DATe_ALLOC;
          ParamByName('MT_SEARCH_MAT_ALLOC').AsString := PTMQMMT(m_HostlistMT[IndexMT]).MT_SEARCH_MAT_BY_ALLOC;
          ParamByName('MT_SETTLED').AsString := PTMQMMT(m_HostlistMT[IndexMT]).MT_SETTLED;
          ParamByName('MT_QUANTITY_ISSUE').AsFloat := PTMQMMT(m_HostlistMT[IndexMT]).MT_QUANTITY_ISSUE;
          ParamByName('MT_REQ_QUANTITY').AsFloat := PTMQMMT(m_HostlistMT[IndexMT]).MT_REQ_QUANTITY;
          ParamByName('MT_UPDATED_DATE_TIME_UTC').AsDateTime := PTMQMMT(m_HostlistMT[IndexMT]).MT_CrtOrUpdateDateTimeUTC;
          ParamByName('MT_PREQ_NO').AsString := PTMQMMT(m_HostlistMT[IndexMT]).MT_PROD_REQ_Nr;
          ParamByName('MT_PSTEP_ID').AsInteger := PTMQMMT(m_HostlistMT[IndexMT]).MT_PSTEP_ID;
          ParamByName('MT_WKCNTER').AsString := PTMQMMT(m_HostlistMT[IndexMT]).MT_WKCTR_CODE;
          ParamByName('MT_RES_CAT_CODE').AsString := PTMQMMT(m_HostlistMT[IndexMT]).MT_RES_CAT_CODE;
          ParamByName('MT_RSC_CODE').AsString := PTMQMMT(m_HostlistMT[IndexMT]).MT_RES_CODE;
          ParamByName('MT_MACHINE_SETUP_CODE').AsString := PTMQMMT(m_HostlistMT[IndexMT]).MT_MACHIN_SETUP_CODE;
          ParamByName('MT_ALTERNATIVE_CODE').AsString := PTMQMMT(m_HostlistMT[IndexMT]).MT_ALTERNATIVE_CODE;
          ParamByName('MT_TYPE_PROD').AsString := PTMQMMT(m_HostlistMT[IndexMT]).MT_PROD_TYPE;
          ParamByName('MT_PRODUCT_CODE').AsString := PTMQMMT(m_HostlistMT[IndexMT]).MT_PROD_CODE;
          ParamByName('MT_NET_GROUP_CODE').AsString := PTMQMMT(m_HostlistMT[IndexMT]).MT_NET_GROUP_CODE;
          ParamByName('MT_ISSUE_CODE').AsString := PTMQMMT(m_HostlistMT[IndexMT]).MT_ISSUE_CODE;
          ParamByName('MT_SEQ_ISSUED').AsString := PTMQMMT(m_HostlistMT[IndexMT]).MT_SEQ_ISSUED;

          try
            ExecSQL;

          except
          end;
          Temp_TimeVal := NOW - Temp_TimeVal;
            IniAppGlobals.Time_UpdateMT := IniAppGlobals.Time_UpdateMT + Temp_TimeVal;
            Inc(IniAppGlobals.Count_UpdateMT);
          RunCommit := true;
        end;
      end;
      Inc(m_Local_IndexMT);
      IndexMT := IndexMT + 1;
    end;

    //*******************************************************************************//
    //**************************** tbl_produced_article *******************************//
    //*******************************************************************************//

    tblInf := @tblInfo[tbl_produced_article];
    while (IndexPA <= m_HostlistPA.count - 1) and (Request > PTMQMPA(m_HostlistPA[IndexPA]).PA_PROD_REQ_NR) do
    begin
      inc(IndexPA);
    end;
    while (not EOL_Local(PA)) and (Request > PTMQMPA(m_LocalListPA[m_Local_IndexPA]).PA_PROD_REQ_NR) do
    begin
      Inc(m_Local_IndexPA);
    end;

    FirstCycle := true;
    HostHaveData := true;
    EndRequestDataHost := false;
    EndRequestDataLocal := false;
    while true do
    begin
      if (IndexPA > m_HostlistPA.count - 1) or (Request < PTMQMPA(m_HostlistPA[IndexPA]).PA_PROD_REQ_NR)
      or (PReqChange(m_Req_Change_List[I]).ChangedType = DelReq) then EndRequestDataHost := true;
      if (EOL_Local(PA) or (Request < PTMQMPA(m_LocalListPA[m_Local_IndexPA]).PA_PROD_REQ_NR))
      then EndRequestDataLocal := true;

      if EndRequestDataHost and EndRequestDataLocal then break;

      Operation := DBEqual;

      if EndRequestDataHost then
      begin
        Operation := DBDelete;
        if FirstCycle then HostHaveData := false;
      end;
      FirstCycle := False;

      if EndRequestDataLocal then Operation := DBInsert;

      if Operation = DBEqual then
      begin
         TableNumberOfKeys := KeyNumPA;
         TableNumberOfFields := 11;
         HostFields[1]  := PTMQMPA(m_HostlistPA[IndexPA]).PA_PROD_REQ_NR;
         HostFields[2]  := PTMQMPA(m_HostlistPA[IndexPA]).PA_SEQUENCE;
         HostFields[3]  := PTMQMPA(m_HostlistPA[IndexPA]).PA_PROD_CODE;
         HostFields[4]  := PTMQMPA(m_HostlistPA[IndexPA]).PA_NET_GROUP_Code;
         HostFields[5]  := PTMQMPA(m_HostlistPA[IndexPA]).PA_ALL_REQ;
         HostFields[6]  := PTMQMPA(m_HostlistPA[IndexPA]).PA_PROD_BALANCE;
         HostFields[7]  := PTMQMPA(m_HostlistPA[IndexPA]).PA_RESOURCE;
         HostFields[8]  := PTMQMPA(m_HostlistPA[IndexPA]).PA_SETTLED;
         HostFields[9]  := FloatToStr(PTMQMPA(m_HostlistPA[IndexPA]).PA_REQ_QUANTY);
         HostFields[10] := FloatToStr(PTMQMPA(m_HostlistPA[IndexPA]).PA_QTY_PRODUCED);
         HostFields[11] := PTMQMPA(m_HostlistPA[IndexPA]).PA_QTY_ALL;
         LocalFields[1] := PTMQMPA(m_LocalListPA[m_Local_IndexPA]).PA_PROD_REQ_NR;
         LocalFields[2] := PTMQMPA(m_LocalListPA[m_Local_IndexPA]).PA_SEQUENCE;
         LocalFields[3] := PTMQMPA(m_LocalListPA[m_Local_IndexPA]).PA_PROD_CODE;
         LocalFields[4] := PTMQMPA(m_LocalListPA[m_Local_IndexPA]).PA_NET_GROUP_Code;
         LocalFields[5] := PTMQMPA(m_LocalListPA[m_Local_IndexPA]).PA_ALL_REQ;
         LocalFields[6] := PTMQMPA(m_LocalListPA[m_Local_IndexPA]).PA_PROD_BALANCE;
         LocalFields[7] := PTMQMPA(m_LocalListPA[m_Local_IndexPA]).PA_RESOURCE;
         LocalFields[8] := PTMQMPA(m_LocalListPA[m_Local_IndexPA]).PA_SETTLED;
         LocalFields[9] := FloatToStr(PTMQMPA(m_LocalListPA[m_Local_IndexPA]).PA_REQ_QUANTY);
         LocalFields[10] := FloatToStr(PTMQMPA(m_LocalListPA[m_Local_IndexPA]).PA_QTY_PRODUCED);
         LocalFields[11] := PTMQMPA(m_LocalListPA[m_Local_IndexPA]).PA_QTY_ALL;
         Operation := CompareKeys(TableNumberOfKeys, TableNumberOfFields, HostFields, LocalFields);
      end;

      if (not HostHaveData) and (PReqChange(m_Req_Change_List[I]).ChangedType = Historical) then
      begin
        if Operation = DBDelete then Inc(m_Local_IndexPA);
        if Operation = DBInsert then IndexPA := IndexPA + 1;
        if (Operation <> DBDelete) and (Operation <> DBInsert) then
        begin
          Inc(m_Local_IndexPA);
          IndexPA := IndexPA + 1;
        end;
        continue;
      end;

      if Operation = DBDelete then
      begin

        if DndArchiveLocalName = TD_Oracle then
        begin
          if PTMQMPA(m_LocalListPA[m_Local_IndexPA]).PA_SEQUENCE = '' then
             PTMQMPA(m_LocalListPA[m_Local_IndexPA]).PA_SEQUENCE := ' ';
          if PTMQMPA(m_LocalListPA[m_Local_IndexPA]).PA_PROD_CODE = '' then
             PTMQMPA(m_LocalListPA[m_Local_IndexPA]).PA_PROD_CODE := ' ';
          if PTMQMPA(m_LocalListPA[m_Local_IndexPA]).PA_NET_GROUP_Code = '' then
             PTMQMPA(m_LocalListPA[m_Local_IndexPA]).PA_NET_GROUP_Code := ' ';
          if PTMQMPA(m_LocalListPA[m_Local_IndexPA]).PA_ALL_REQ = '' then
             PTMQMPA(m_LocalListPA[m_Local_IndexPA]).PA_ALL_REQ := ' ' ;
        end;

        with QryDelPA do
        begin
          Temp_TimeVal := NOW;
          ParamByName(CreateFld(tblInf.pfx, fli_preqNo)).AsString := PTMQMPA(m_LocalListPA[m_Local_IndexPA]).PA_PROD_REQ_NR;
          ParamByName(CreateFld(tblInf.pfx, fli_sequenceChar)).AsString := PTMQMPA(m_LocalListPA[m_Local_IndexPA]).PA_SEQUENCE;
          ParamByName(CreateFld(tblInf.pfx, fli_ProdCode)).AsString := PTMQMPA(m_LocalListPA[m_Local_IndexPA]).PA_PROD_CODE;
          ParamByName(CreateFld(tblInf.pfx, fli_netGroupCode)).AsString := PTMQMPA(m_LocalListPA[m_Local_IndexPA]).PA_NET_GROUP_Code;
          ParamByName(CreateFld(tblInf.pfx, fli_AllocReq)).AsString := PTMQMPA(m_LocalListPA[m_Local_IndexPA]).PA_ALL_REQ;
        //  Prepare;
          ExecSQL;
          Temp_TimeVal := NOW - Temp_TimeVal;
          IniAppGlobals.Time_DelPA := IniAppGlobals.Time_DelPA + Temp_TimeVal;
          Inc(IniAppGlobals.Count_DelPA);
          RunCommit := true;
        end;
        Inc(m_Local_IndexPA);
        continue;
      end;

      if Operation = DBInsert then
      begin
        PTMQMPA(m_HostListPA[IndexPA]).PA_CreateDateTimeUTC := UTCNow;
        PTMQMPA(m_HostListPA[IndexPA]).PA_CrtOrUpdateDateTimeUTC := UTCNow;
        with QryInsertPA do
        begin

          if DndArchiveLocalName = TD_Oracle then
          begin
            if PTMQMPA(m_HostlistPA[IndexPA]).PA_SEQUENCE = '' then
               PTMQMPA(m_HostlistPA[IndexPA]).PA_SEQUENCE := ' ';
            if PTMQMPA(m_HostlistPA[IndexPA]).PA_PROD_CODE = '' then
               PTMQMPA(m_HostlistPA[IndexPA]).PA_PROD_CODE := ' ';
            if PTMQMPA(m_HostlistPA[IndexPA]).PA_NET_GROUP_Code = '' then
               PTMQMPA(m_HostlistPA[IndexPA]).PA_NET_GROUP_Code := ' ';
            if PTMQMPA(m_HostlistPA[IndexPA]).PA_ALL_REQ = '' then
               PTMQMPA(m_HostlistPA[IndexPA]).PA_ALL_REQ := ' ' ;
          end;

          Temp_TimeVal := NOW;
          ParamByName('PA_PREQ_NO').AsString := PTMQMPA(m_HostlistPA[IndexPA]).PA_PROD_REQ_NR;
          ParamByName('PA_SEQUENCE').AsString := PTMQMPA(m_HostlistPA[IndexPA]).PA_SEQUENCE;
          ParamByName('PA_PRODUCT_CODE').AsString := PTMQMPA(m_HostlistPA[IndexPA]).PA_PROD_CODE;
          ParamByName('PA_NET_GROUP_CODE').AsString := PTMQMPA(m_HostlistPA[IndexPA]).PA_NET_GROUP_Code;
          ParamByName('PA_ALLOC_REQ').AsString := PTMQMPA(m_HostlistPA[IndexPA]).PA_ALL_REQ;
          ParamByName('PA_PROD_BALANCE').AsString := PTMQMPA(m_HostlistPA[IndexPA]).PA_PROD_BALANCE;
          ParamByName('PA_RSC_CODE').AsString := PTMQMPA(m_HostlistPA[IndexPA]).PA_RESOURCE;
          ParamByName('PA_SETTLED').AsString := PTMQMPA(m_HostlistPA[IndexPA]).PA_SETTLED;
          ParamByName('PA_REQ_QUANTITY').AsFloat := PTMQMPA(m_HostlistPA[IndexPA]).PA_REQ_QUANTY;
          ParamByName('PA_QTY_PRODUCED').AsFloat := PTMQMPA(m_HostlistPA[IndexPA]).PA_QTY_PRODUCED;
          ParamByName('PA_QTY_ALLOC').AsFloat := PTMQMPA(m_HostlistPA[IndexPA]).PA_QTY_ALL;
          ParamByName('PA_CREATE_DATE_TIME_UTC').AsDateTime := PTMQMPA(m_HostlistPA[IndexPA]).PA_CreateDateTimeUTC;
          ParamByName('PA_UPDATED_DATE_TIME_UTC').AsDateTime := PTMQMPA(m_HostlistPA[IndexPA]).PA_CrtOrUpdateDateTimeUTC;
          ParamByName('PA_IDENTIFIER').AsString := IniAppGlobals.Identifier;

          try
            ExecSQL;

            RunCommit := true;
          except
          end;
          Temp_TimeVal := NOW - Temp_TimeVal;
            IniAppGlobals.Time_InsertPA := IniAppGlobals.Time_InsertPA + Temp_TimeVal;
            Inc(IniAppGlobals.Count_InsertPA);
        end;
        IndexPA := IndexPA + 1;
        continue;
      end;

      if Operation = DBUpdate then
      begin
        with QryUpdatePA do
        begin

          if DndArchiveLocalName = TD_Oracle then
          begin
            if PTMQMPA(m_HostlistPA[IndexPA]).PA_SEQUENCE = '' then
               PTMQMPA(m_HostlistPA[IndexPA]).PA_SEQUENCE := ' ';
            if PTMQMPA(m_HostlistPA[IndexPA]).PA_PROD_CODE = '' then
               PTMQMPA(m_HostlistPA[IndexPA]).PA_PROD_CODE := ' ';
            if PTMQMPA(m_HostlistPA[IndexPA]).PA_NET_GROUP_Code = '' then
               PTMQMPA(m_HostlistPA[IndexPA]).PA_NET_GROUP_Code := ' ';
            if PTMQMPA(m_HostlistPA[IndexPA]).PA_ALL_REQ = '' then
               PTMQMPA(m_HostlistPA[IndexPA]).PA_ALL_REQ := ' ' ;
          end;

          PTMQMPA(m_HostListPA[IndexPA]).PA_CrtOrUpdateDateTimeUTC := UTCNow;
          Temp_TimeVal := NOW;
          ParamByName('PA_PROD_BALANCE').AsString := PTMQMPA(m_HostlistPA[IndexPA]).PA_PROD_BALANCE;
          ParamByName('PA_RSC_CODE').AsString := PTMQMPA(m_HostlistPA[IndexPA]).PA_RESOURCE;
          ParamByName('PA_SETTLED').AsString := PTMQMPA(m_HostlistPA[IndexPA]).PA_SETTLED;
          ParamByName('PA_REQ_QUANTITY').AsFloat := PTMQMPA(m_HostlistPA[IndexPA]).PA_REQ_QUANTY;
          ParamByName('PA_QTY_PRODUCED').AsFloat := PTMQMPA(m_HostlistPA[IndexPA]).PA_QTY_PRODUCED;
          ParamByName('PA_QTY_ALLOC').AsFloat := PTMQMPA(m_HostlistPA[IndexPA]).PA_QTY_ALL;
          ParamByName('PA_UPDATED_DATE_TIME_UTC').AsDateTime := PTMQMPA(m_HostlistPA[IndexPA]).PA_CrtOrUpdateDateTimeUTC;
          ParamByName('PA_PREQ_NO').AsString := PTMQMPA(m_HostlistPA[IndexPA]).PA_PROD_REQ_NR;
          ParamByName('PA_SEQUENCE').AsString := PTMQMPA(m_HostlistPA[IndexPA]).PA_SEQUENCE;
          ParamByName('PA_PRODUCT_CODE').AsString := PTMQMPA(m_HostlistPA[IndexPA]).PA_PROD_CODE;
          ParamByName('PA_NET_GROUP_CODE').AsString := PTMQMPA(m_HostlistPA[IndexPA]).PA_NET_GROUP_CODE;
          ParamByName('PA_ALLOC_REQ').AsString := PTMQMPA(m_HostlistPA[IndexPA]).PA_ALL_REQ;

          try
            ExecSQL;

          except
          end;
          Temp_TimeVal := NOW - Temp_TimeVal;
            IniAppGlobals.Time_UpdatePA := IniAppGlobals.Time_UpdatePA + Temp_TimeVal;
            Inc(IniAppGlobals.Count_UpdatePA);
          RunCommit := true;
        end;
      end;
      Inc(m_Local_IndexPA);
      IndexPA := IndexPA + 1;
    end;

    if RunCommit then
    begin
      MqmTrs.Commit;
    end;

  end;

  if IsClientOpen and (m_Req_Change_List.Count > 0) then
  begin
    MqmTrs.StartTransaction;
    InsertChangeReqToTable(true, '', nil, MqmTrs);
    MqmTrs.Commit;
  end;

  if WcRecEntered then
  begin
    MqmTrs.StartTransaction;
    InsertWCChangeReqToTable(true, MqmTrs, WorkCenterToUpdate);
    MqmTrs.Commit;
  end;

  except
    on E: Exception do
    begin
      ApplicationShowException(E);
    end;
  end;

{  if DBAppGlobals.License_BOTH_MQM_MCM then
  begin
    if (IniAppGlobals.CBCopiedSchedTypeFromMqm = '1') or
    (IniAppGlobals.CBCopiedBackwardFromMqmDays = '1') then
    begin
      MqmTrs.StartTransaction;
      CopyProdSchedToProdSchedMcm(MqmTrs);
      MqmTrs.Commit;
    end;

  end;  }

  SrvQryPSMCM.Close;

  QryTmp.Close;
  QryUpdatePR.Close;
  QryDelPR.Close;
  QryUpdatePH.Close;
  QryDelPH.Close;
  QryUpdatePD.Close;
  QryDelPD.Close;
  QryUpdatePP.Close;
  QryDelPP.Close;
  QryUpdatePI.Close;
  QryDelPI.Close;
  QryUpdateEC.Close;
  QryDelEC.Close;
  QryUpdateIC.Close;
  QryDelIC.Close;
  QryUpdateSB.Close;
  QryDelSB.Close;
  QryUpdateSP.Close;
  QryDelSP.Close;
  QryUpdateST.Close;
  QryDelST.Close;
  QryUpdateMT.Close;
  QryDelMT.Close;
  QryUpdatePA.Close;
  QryDelPA.Close;
  QryUpdatePS.Close;
  QryDelPS.Close;
  QryUpdatePSMCM.Close;
  QryDelPSMCM.Close;

  SrvQryPS.Free;

  SrvQryPSMCM.Free;

  QryInsertPR.Free;
  QryInsertPH.Free;
  QryInsertPD.Free;
  QryInsertPP.Free;
  QryInsertPI.Free;
  QryInsertEC.Free;
  QryInsertIC.Free;
  QryInsertSB.Free;
  QryInsertSP.Free;
  QryInsertST.Free;
  QryInsertMT.Free;
  QryInsertPA.Free;
  QryInsertCR.Free;

  QryTmp.Free;
  QryUpdatePR.Free;
  QryDelPR.Free;
  QryUpdatePH.Free;
  QryDelPH.Free;
  QryUpdatePD.Free;
  QryDelPD.Free;
  QryUpdatePP.Free;
  QryDelPP.Free;
  QryUpdatePI.Free;
  QryDelPI.Free;
  QryUpdateEC.Free;
  QryDelEC.Free;
  QryUpdateIC.Free;
  QryDelIC.Free;
  QryUpdateSB.Free;
  QryDelSB.Free;
  QryUpdateSP.Free;
  QryDelSP.Free;
  QryUpdateST.Free;
  QryDelST.Free;
  QryUpdateMT.Free;
  QryDelMT.Free;
  QryUpdatePA.Free;
  QryDelPA.Free;
  QryUpdatePS.Free;
  QryDelPS.Free;
  QryUpdatePSMCM.Free;
  QryDelPSMCM.Free;

end;

//----------------------------------------------------------------------------//

procedure TProdCont.OrganizeSubStepsForProgress(ListPs : TList; Ini_Index_Sp : Integer);
var
  RecMQMPS : PTMQMPS;
  Index_Sp, Tmp_Index_Sp, J : Integer;
  SubStep, RePRocess : Integer;
  CurrentRequest : string;
  CurrentStep    : Integer;
  HigherSP  : Integer;
  HigherNumPS  : Integer;
  HigherNumSP  : Integer;
  AllProgressesForSubStepMinusOne, UpToSubStep900  : boolean;
  RecMQMPD : PTMQMPD;

  procedure MarkInPsList(SubStep : Integer);
  var
    J : Integer;

  begin
    for J := 0 to ListPS.Count - 1 do
    begin
      if (PTMQMPS(ListPS[J]).PS_PSUBST_ID = SubStep) then
      begin
        PTMQMPS(ListPS[J]).PS_MARKED := true;
      end;
    end;
  end;

  function SearchSubByResource(Rsc : string; var SubStep : Integer; var RePRocess : Integer) : boolean;
  var
    J : Integer;
  begin
    Result := false;
    for J := 0 to ListPS.Count - 1 do
    begin
      if (PTMQMPS(ListPS[J]).PS_RSC = Rsc) then
      begin
        if (PTMQMPS(ListPS[J]).PS_MARKED) or (UpToSubStep900 and (PTMQMPS(ListPS[J]).PS_PSUBST_ID >= 900)) then
            continue;
        PTMQMPS(ListPS[J]).PS_MARKED := true;
        Result := true;
        SubStep := PTMQMPS(ListPS[J]).PS_PSUBST_ID;
        RePRocess := PTMQMPS(ListPS[J]).PS_REPROCCS;
        exit;
      end;
    end;
  end;

  function SearchSubByWCenterCategory(Wc : string; Category : string; var SubStep : Integer; var RePRocess : integer) : boolean;
  var
    J : Integer;
  begin
    Result := false;
    for J := 0 to ListPS.Count - 1 do
    begin
      if (PTMQMPS(ListPS[J]).PS_WORK_CENTER = Wc) and (PTMQMPS(ListPS[J]).PS_RESC_CAT = Category) then
      begin
        if (PTMQMPS(ListPS[J]).PS_MARKED) or (UpToSubStep900 and (PTMQMPS(ListPS[J]).PS_PSUBST_ID >= 900)) then
           continue;
        Result := true;
        PTMQMPS(ListPS[J]).PS_MARKED := true;
        SubStep := PTMQMPS(ListPS[J]).PS_PSUBST_ID;
        RePRocess := PTMQMPS(ListPS[J]).PS_REPROCCS;
        exit;
      end;
    end;
  end;

  function SearchSubByWCenter(Wc : string; var SubStep : Integer; var RePRocess : integer) : boolean;
  var
    J : Integer;
  begin
    Result := false;
    for J := 0 to ListPS.Count - 1 do
    begin
      if (PTMQMPS(ListPS[J]).PS_WORK_CENTER = Wc) then
      begin
        if (PTMQMPS(ListPS[J]).PS_MARKED) or (UpToSubStep900 and (PTMQMPS(ListPS[J]).PS_PSUBST_ID >= 900)) then
           continue;
        Result := true;
        PTMQMPS(ListPS[J]).PS_MARKED := true;
        SubStep := PTMQMPS(ListPS[J]).PS_PSUBST_ID;
        RePRocess := PTMQMPS(ListPS[J]).PS_REPROCCS;
        exit;
      end;
    end;
  end;

  function SearchSubByReqStep(Req : string; Step : integer; var SubStep : Integer; var RePRocess : integer) : boolean;
  var
    J : Integer;
  begin
    Result := false;
    for J := 0 to ListPS.Count - 1 do
    begin
      if (PTMQMPS(ListPS[J]).PS_PREQ_NO = Req) and (PTMQMPS(ListPS[J]).PS_PSTEP_ID = step) then
      begin
        if (PTMQMPS(ListPS[J]).PS_MARKED) or (UpToSubStep900 and (PTMQMPS(ListPS[J]).PS_PSUBST_ID >= 900)) then
           continue;
        Result := true;
        PTMQMPS(ListPS[J]).PS_MARKED := true;
        SubStep := PTMQMPS(ListPS[J]).PS_PSUBST_ID;
        RePRocess := PTMQMPS(ListPS[J]).PS_REPROCCS;
        exit;
      end;
    end;
  end;

begin
  CurrentRequest := PTMQMSP(m_ProdCont.m_HostListSP[Ini_Index_Sp]).SP_PREQ_NO;
  CurrentStep    := PTMQMSP(m_ProdCont.m_HostListSP[Ini_Index_Sp]).SP_PSTEP_ID;

  Index_Sp := Ini_Index_Sp;
  AllProgressesForSubStepMinusOne := true;
  while (Index_SP <= m_ProdCont.m_HostListSP.Count - 1) and (PTMQMSP(m_ProdCont.m_HostListSP[Index_SP]).SP_PREQ_NO = CurrentRequest) and
        (PTMQMSP(m_ProdCont.m_HostListSP[Index_SP]).SP_PSTEP_ID = CurrentStep) do
  begin
    if (PTMQMSP(m_ProdCont.m_HostListSP[Index_SP]).SP_PSUBST_ID > -1) then
    begin
      MarkInPsList(PTMQMSP(m_ProdCont.m_HostListSP[Index_SP]).SP_PSUBST_ID);
      AllProgressesForSubStepMinusOne := false;
    end;
    inc(Index_SP);
  end;

  UpToSubStep900 := true;
  while True do
  begin

    Index_Sp := Ini_Index_Sp;
    while (Index_SP <= m_ProdCont.m_HostListSP.Count - 1) and (PTMQMSP(m_ProdCont.m_HostListSP[Index_SP]).SP_PREQ_NO = CurrentRequest) and
          (PTMQMSP(m_ProdCont.m_HostListSP[Index_SP]).SP_PSTEP_ID = CurrentStep) do
    begin
      if (PTMQMSP(m_ProdCont.m_HostListSP[Index_SP]).SP_PSUBST_ID = -1) then
      begin
        if SearchSubByResource(PTMQMSP(m_ProdCont.m_HostListSP[Index_SP]).SP_RSC_CODE, SubStep, RePRocess) then
        begin
          PTMQMSP(m_ProdCont.m_HostListSP[Index_SP]).SP_PSUBST_ID := SubStep;
          PTMQMSP(m_ProdCont.m_HostListSP[Index_SP]).SP_REPROC_NO := RePRocess;
        end;
      end;
      inc(Index_SP);
    end;

    Index_Sp := Ini_Index_Sp;
    while (Index_SP <= m_ProdCont.m_HostListSP.Count - 1) and (PTMQMSP(m_ProdCont.m_HostListSP[Index_SP]).SP_PREQ_NO = CurrentRequest) and
          (PTMQMSP(m_ProdCont.m_HostListSP[Index_SP]).SP_PSTEP_ID = CurrentStep) do
    begin
      if (PTMQMSP(m_ProdCont.m_HostListSP[Index_SP]).SP_PSUBST_ID = -1) then
      begin
        if SearchSubByWCenterCategory(PTMQMSP(m_ProdCont.m_HostListSP[Index_SP]).SP_WORK_CENTER,
             PTMQMSP(m_ProdCont.m_HostListSP[Index_SP]).SP_RES_CAT, SubStep,RePRocess) then
        begin
          PTMQMSP(m_ProdCont.m_HostListSP[Index_SP]).SP_PSUBST_ID := SubStep;
          PTMQMSP(m_ProdCont.m_HostListSP[Index_SP]).SP_REPROC_NO := RePRocess;
        end;
      end;
      inc(Index_SP);
    end;

    Index_Sp := Ini_Index_Sp;
    while (Index_SP <= m_ProdCont.m_HostListSP.Count - 1) and (PTMQMSP(m_ProdCont.m_HostListSP[Index_SP]).SP_PREQ_NO = CurrentRequest) and
          (PTMQMSP(m_ProdCont.m_HostListSP[Index_SP]).SP_PSTEP_ID = CurrentStep) do
    begin
      if (PTMQMSP(m_ProdCont.m_HostListSP[Index_SP]).SP_PSUBST_ID = -1) then
      begin
        if SearchSubByWCenter(PTMQMSP(m_ProdCont.m_HostListSP[Index_SP]).SP_WORK_CENTER, SubStep, RePRocess) then
        begin
          PTMQMSP(m_ProdCont.m_HostListSP[Index_SP]).SP_PSUBST_ID := SubStep;
          PTMQMSP(m_ProdCont.m_HostListSP[Index_SP]).SP_REPROC_NO := RePRocess;
        end;
      end;
      inc(Index_SP);
    end;

    Index_Sp := Ini_Index_Sp;
    while (Index_SP <= m_ProdCont.m_HostListSP.Count - 1) and (PTMQMSP(m_ProdCont.m_HostListSP[Index_SP]).SP_PREQ_NO = CurrentRequest) and
          (PTMQMSP(m_ProdCont.m_HostListSP[Index_SP]).SP_PSTEP_ID = CurrentStep) do
    begin
      if (PTMQMSP(m_ProdCont.m_HostListSP[Index_SP]).SP_PSUBST_ID = -1) then
      begin
        if SearchSubByReqStep(PTMQMSP(m_ProdCont.m_HostListSP[Index_SP]).SP_PREQ_NO, PTMQMSP(m_ProdCont.m_HostListSP[Index_SP]).SP_PSTEP_ID, SubStep, RePRocess) then
        begin
          PTMQMSP(m_ProdCont.m_HostListSP[Index_SP]).SP_PSUBST_ID := SubStep;
          PTMQMSP(m_ProdCont.m_HostListSP[Index_SP]).SP_REPROC_NO := RePRocess;
        end;
      end;
      inc(Index_SP);
    end;

    if not UpToSubStep900 then
      break;
    UpToSubStep900 := false;

  end;

  Index_Sp := Ini_Index_Sp;
  HigherSP := -1;
  while (Index_SP <= m_ProdCont.m_HostListSP.Count - 1) and (PTMQMSP(m_ProdCont.m_HostListSP[Index_SP]).SP_PREQ_NO = CurrentRequest) and
        (PTMQMSP(m_ProdCont.m_HostListSP[Index_SP]).SP_PSTEP_ID = CurrentStep) do
  begin
    if (PTMQMSP(m_ProdCont.m_HostListSP[Index_SP]).SP_PSUBST_ID > HigherSP) then
      HigherSP := PTMQMSP(m_ProdCont.m_HostListSP[Index_SP]).SP_PSUBST_ID;
    inc(Index_SP);
  end;
  inc(HigherSP);
  if HigherSP < 900 then
    HigherSP := 900;

  Index_Sp := Ini_Index_Sp;
  while (Index_SP <= m_ProdCont.m_HostListSP.Count - 1) and (PTMQMSP(m_ProdCont.m_HostListSP[Index_SP]).SP_PREQ_NO = CurrentRequest) and
        (PTMQMSP(m_ProdCont.m_HostListSP[Index_SP]).SP_PSTEP_ID = CurrentStep) do
  begin
    if (PTMQMSP(m_ProdCont.m_HostListSP[Index_SP]).SP_PSUBST_ID = -1) then
    begin
      PTMQMSP(m_ProdCont.m_HostListSP[Index_SP]).SP_PSUBST_ID := HigherSP;
      PTMQMSP(m_ProdCont.m_HostListSP[Index_SP]).SP_REPROC_NO := 0;
      inc(HigherSP);
    end;
    inc(Index_SP);
  end;

end;

//----------------------------------------------------------------------------//

function TProdCont.EOL_Host(Typ : TypeCheck): boolean;
begin
  Result := true;
  case Typ of
    PR : begin
           if (m_Host_IndexPR <> -1) and (m_Host_IndexPR <= m_HostListPR.count - 1) then
              Result := false;
         end;
    PH : begin
           if (m_Host_IndexPH <> -1) and (m_Host_IndexPH <= m_HostListPH.count - 1) then
              Result := false;
         end;
    PD : begin
           if (m_Host_IndexPD <> -1) and (m_Host_IndexPD <= m_HostListPD.count - 1) then
              Result := false;
         end;
    PP : begin
           if (m_Host_IndexPP <> -1) and (m_Host_IndexPP <= m_HostListPP.count - 1) then
              Result := false;
         end;
    PI : begin
           if (m_Host_IndexPI <> -1) and (m_Host_IndexPI <= m_HostListPI.count - 1) then
              Result := false;
         end;
    EC : begin
           if (m_Host_IndexEC <> -1) and (m_Host_IndexEC <= m_HostListEC.count - 1) then
              Result := false;
         end;
    IC : begin
           if (m_Host_IndexIC <> -1) and (m_Host_IndexIC <= m_HostListIC.count - 1) then
              Result := false;
         end;
    SB : begin
           if (m_Host_IndexSB <> -1) and (m_Host_IndexSB <= m_HostListSB.count - 1) then
              Result := false;
         end;
    SP : begin
           if (m_Host_IndexSP <> -1) and (m_Host_IndexSP <= m_HostListSP.count - 1) then
              Result := false;
         end;
    ST : begin
           if (m_Host_IndexST <> -1) and (m_Host_IndexST <= m_HostListST.count - 1) then
              Result := false;
         end;
    MT : begin
           if (m_Host_IndexMT <> -1) and (m_Host_IndexMT <= m_HostlistMT.count - 1) then
              Result := false;
         end;
    PA : begin
           if (m_Host_IndexPA <> -1) and (m_Host_IndexPA <= m_HostlistPA.count - 1) then
              Result := false;
         end;
  end;
end;

//----------------------------------------------------------------------------//

function TProdCont.EOL_Local(Typ : TypeCheck): boolean;
begin
  Result := true;
  case Typ of
    PR : begin
           if (m_Local_IndexPR <> -1) and (m_Local_IndexPR <= m_LocalListPR.count - 1) then
              Result := false;
         end;
    PH : begin
           if (m_Local_IndexPH <> -1) and (m_Local_IndexPH <= m_LocalListPH.count - 1) then
              Result := false;
         end;
    PD : begin
           if (m_Local_IndexPD <> -1) and (m_Local_IndexPD <= m_LocalListPD.count - 1) then
              Result := false;
         end;
    PP : begin
           if (m_Local_IndexPP <> -1) and (m_Local_IndexPP <= m_LocalListPP.count - 1) then
              Result := false;
         end;
    PI : begin
           if (m_Local_IndexPI <> -1) and (m_Local_IndexPI <= m_LocalListPI.count - 1) then
              Result := false;
         end;
    EC : begin
           if (m_Local_IndexEC <> -1) and (m_Local_IndexEC <= m_LocalListEC.count - 1) then
              Result := false;
         end;
    IC : begin
           if (m_Local_IndexIC <> -1) and (m_Local_IndexIC <= m_LocalListIC.count - 1) then
              Result := false;
         end;
    SB : begin
           if (m_Local_IndexSB <> -1) and (m_Local_IndexSB <= m_LocalListSB.count - 1) then
              Result := false;
         end;
    SP : begin
           if (m_Local_IndexSP <> -1) and (m_Local_IndexSP <= m_LocalListSP.count - 1) then
              Result := false;
         end;
    ST : begin
           if (m_Local_IndexST <> -1) and (m_Local_IndexST <= m_LocalListST.count - 1) then
              Result := false;
         end;
    MT : begin
           if (m_Local_IndexMT <> -1) and (m_Local_IndexMT <= m_LocallistMT.count - 1) then
              Result := false;
         end;
    PA : begin
           if (m_Local_IndexPA <> -1) and (m_Local_IndexPA <= m_LocallistPA.count - 1) then
              Result := false;
         end;
  end;
end;

//----------------------------------------------------------------------------//

function TProdCont.SearchPropInList(InMemory : boolean; PropCode : string; var Value : string): boolean;
var
  I : Integer;
begin
  Result := false;
  if InMemory then
  begin
    for I := 0 to m_TmpPP_Memory.Count - 1 do
    begin
      if (PropCode = PReqTempProp(m_TmpPP_Memory[I]).PropCode) then
      begin
        Result := true;
        Value := PReqTempProp(m_TmpPP_Memory[I]).PropVal;
      end
    end;
  end
  else
  begin
    for I := 0 to m_TmpPP_Disk.Count - 1 do
    begin
      if (PropCode = PReqTempProp(m_TmpPP_Disk[I]).PropCode) then
      begin
        Result := true;
        Value := PReqTempProp(m_TmpPP_Disk[I]).PropVal;
      end
    end;
  end
end;

//----------------------------------------------------------------------------//

procedure TProdCont.SetPosOnHostList(Request : string);
begin
  m_Host_Begin_IndexPH := -1;
  if m_HostListPH.Count <> 0 then
  begin
    if (m_Host_IndexPH = -1) then
       m_Host_IndexPH := 0;
    while (m_Host_IndexPH < m_HostListPH.Count) and (PTMQMPH(m_HostListPH[m_Host_IndexPH]).PH_PREQ_NO < Request) do
        m_Host_IndexPH := m_Host_IndexPH + 1;
    if (m_Host_IndexPH < m_HostListPH.Count) and (PTMQMPH(m_HostListPH[m_Host_IndexPH]).PH_PREQ_NO = Request) then
      m_Host_Begin_IndexPH := m_Host_IndexPH
  end;

  m_Host_Begin_IndexPD := -1;
  if m_HostListPD.Count <> 0 then
  begin
    if (m_Host_IndexPD = -1) then
       m_Host_IndexPD := 0;
    while (m_Host_IndexPD < m_HostListPD.Count) and (PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_PREQ_NO < Request) do
        m_Host_IndexPD := m_Host_IndexPD + 1;
    if (m_Host_IndexPD < m_HostListPD.Count) and (PTMQMPD(m_HostListPD[m_Host_IndexPD]).PD_PREQ_NO = Request) then
      m_Host_Begin_IndexPD := m_Host_IndexPD
  end;

  m_Host_Begin_IndexPP := -1;
  if m_HostListPP.Count <> 0 then
  begin
    if (m_Host_IndexPP = -1) then
       m_Host_IndexPP := 0;
    while (m_Host_IndexPP < m_HostListPP.Count) and (PTMQMPP(m_HostListPP[m_Host_IndexPP]).PP_PREQ_NO < Request) do
        m_Host_IndexPP := m_Host_IndexPP + 1;
    if (m_Host_IndexPP < m_HostListPP.Count) and (PTMQMPP(m_HostListPP[m_Host_IndexPP]).PP_PREQ_NO = Request) then
      m_Host_Begin_IndexPP := m_Host_IndexPP
  end;

  m_Host_Begin_IndexPI := -1;
  if m_HostListPI.Count <> 0 then
  begin
    if (m_Host_IndexPI = -1) then
       m_Host_IndexPI := 0;
    while (m_Host_IndexPI < m_HostListPI.Count) and (PTMQMPI(m_HostListPI[m_Host_IndexPI]).PI_PREQ_NO < Request) do
        m_Host_IndexPI := m_Host_IndexPI + 1;
    if (m_Host_IndexPI < m_HostListPI.Count) and (PTMQMPI(m_HostListPI[m_Host_IndexPI]).PI_PREQ_NO = Request) then
      m_Host_Begin_IndexPI := m_Host_IndexPI
  end;

  m_Host_Begin_IndexEC := -1;
  if m_HostListEC.Count <> 0 then
  begin
    if (m_Host_IndexEC = -1) then
       m_Host_IndexEC := 0;
    while (m_Host_IndexEC < m_HostListEC.Count) and (PTMQMEC(m_HostListEC[m_Host_IndexEC]).EC_PREQ_NO < Request) do
        m_Host_IndexEC := m_Host_IndexEC + 1;
    if (m_Host_IndexEC < m_HostListEC.Count) and (PTMQMEC(m_HostListEC[m_Host_IndexEC]).EC_PREQ_NO = Request) then
      m_Host_Begin_IndexEC := m_Host_IndexEC
  end;

  m_Host_Begin_IndexIC := -1;
  if m_HostListIC.Count <> 0 then
  begin
    if (m_Host_IndexIC = -1) then
       m_Host_IndexIC := 0;
    while (m_Host_IndexIC < m_HostListIC.Count) and (PTMQMIC(m_HostListIC[m_Host_IndexIC]).IC_PREQ_NO < Request) do
        m_Host_IndexIC := m_Host_IndexIC + 1;
    if (m_Host_IndexIC < m_HostListIC.Count) and (PTMQMIC(m_HostListIC[m_Host_IndexIC]).IC_PREQ_NO = Request) then
      m_Host_Begin_IndexIC := m_Host_IndexIC
  end;

  m_Host_Begin_IndexSB := -1;
  if m_HostListSB.Count <> 0 then
  begin
    if (m_Host_IndexSB = -1) then
       m_Host_IndexSB := 0;
    while (m_Host_IndexSB < m_HostListSB.Count) and (PTMQMSB(m_HostListSB[m_Host_IndexSB]).SB_PREQ_NO < Request) do
        m_Host_IndexSB := m_Host_IndexSB + 1;
    if (m_Host_IndexSB < m_HostListSB.Count) and (PTMQMSB(m_HostListSB[m_Host_IndexSB]).SB_PREQ_NO = Request) then
      m_Host_Begin_IndexSB := m_Host_IndexSB
  end;

  m_Host_Begin_IndexSP := -1;
  if m_HostListSP.Count <> 0 then
  begin
    if (m_Host_IndexSP = -1) then
       m_Host_IndexSP := 0;
    while (m_Host_IndexSP < m_HostListSP.Count) and (PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_PREQ_NO < Request) do
        m_Host_IndexSP := m_Host_IndexSP + 1;
    if (m_Host_IndexSP < m_HostListSP.Count) and (PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_PREQ_NO = Request) then
      m_Host_Begin_IndexSP := m_Host_IndexSP
  end;

  m_Host_Begin_IndexST := -1;
  if m_HostListST.Count <> 0 then
  begin
    if (m_Host_IndexST = -1) then
       m_Host_IndexST := 0;
    while (m_Host_IndexST < m_HostListST.Count) and (PTMQMST(m_HostListST[m_Host_IndexST]).ST_PREQ_NO < Request) do
        m_Host_IndexST := m_Host_IndexST + 1;
    if (m_Host_IndexST < m_HostListST.Count) and (PTMQMST(m_HostListST[m_Host_IndexST]).ST_PREQ_NO = Request) then
      m_Host_Begin_IndexST := m_Host_IndexST
  end;

  m_Host_Begin_IndexMT := -1;
  if m_HostlistMT.Count <> 0 then
  begin
    if (m_Host_IndexMT = -1) then
       m_Host_IndexMT := 0;
    while (m_Host_IndexMT < m_HostlistMT.Count) and (PTMQMMT(m_HostlistMT[m_Host_IndexMT]).MT_PROD_REQ_Nr < Request) do
        m_Host_IndexMT := m_Host_IndexMT + 1;
    if (m_Host_IndexMT < m_HostlistMT.Count) and (PTMQMMT(m_HostlistMT[m_Host_IndexMT]).MT_PROD_REQ_Nr = Request) then
      m_Host_Begin_IndexMT := m_Host_IndexMT
  end;

  m_Host_Begin_IndexPA := -1;
  if m_HostlistPA.Count <> 0 then
  begin
    if (m_Host_IndexPA = -1) then
       m_Host_IndexPA := 0;
    while (m_Host_IndexPA < m_HostlistPA.Count) and (PTMQMPA(m_HostlistPA[m_Host_IndexPA]).PA_PROD_REQ_NR < Request) do
        m_Host_IndexPA := m_Host_IndexPA + 1;
    if (m_Host_IndexPA < m_HostlistPA.Count) and (PTMQMPA(m_HostlistPA[m_Host_IndexPA]).PA_PROD_REQ_NR = Request) then
      m_Host_Begin_IndexPA := m_Host_IndexPA
  end;

end;

//----------------------------------------------------------------------------//

procedure TProdCont.SetPosOnStepHostList(Request : string ; Step : integer);
begin
  m_Begin_StepIndexPP := -1;
  if m_HostListPP.Count <> 0 then
  begin
    if (m_Host_IndexPP = -1) then
      m_Host_IndexPP := 0;
    while (m_Host_IndexPP < m_HostListPP.Count) and
     ((PTMQMPP(m_HostListPP[m_Host_IndexPP]).PP_PREQ_NO < Request) or
      ((PTMQMPP(m_HostListPP[m_Host_IndexPP]).PP_PREQ_NO = Request) and
      (PTMQMPP(m_HostListPP[m_Host_IndexPP]).PP_PSTEP_ID < Step))) do
        m_Host_IndexPP := m_Host_IndexPP + 1;
    if (m_Host_IndexPP < m_HostListPP.Count) and (PTMQMPP(m_HostListPP[m_Host_IndexPP]).PP_PREQ_NO = Request) and (PTMQMPP(m_HostListPP[m_Host_IndexPP]).PP_PSTEP_ID = Step) then
      m_Begin_StepIndexPP := m_Host_IndexPP
  end;

  m_Begin_StepIndexPI := -1;
  if m_HostListPI.Count <> 0 then
  begin
    if (m_Host_IndexPI = -1) then
       m_Host_IndexPI := 0;
    while (m_Host_IndexPI < m_HostListPI.Count) and
       ((PTMQMPI(m_HostListPI[m_Host_IndexPI]).PI_PREQ_NO < Request) or
       ((PTMQMPI(m_HostListPI[m_Host_IndexPI]).PI_PREQ_NO = Request) and
        (PTMQMPI(m_HostListPI[m_Host_IndexPI]).PI_PSTEP_ID < Step))) do
        m_Host_IndexPI := m_Host_IndexPI + 1;
    if (m_Host_IndexPI < m_HostListPI.Count) and (PTMQMPI(m_HostListPI[m_Host_IndexPI]).PI_PREQ_NO = Request) and (PTMQMPI(m_HostListPI[m_Host_IndexPI]).PI_PSTEP_ID = Step) then
      m_Begin_StepIndexPI := m_Host_IndexPI
  end;

  m_Begin_StepIndexSB := -1;
  if m_HostListSB.Count <> 0 then
  begin
    if (m_Host_IndexSB = -1) then
       m_Host_IndexSB := 0;
    while (m_Host_IndexSB < m_HostListSB.Count) and
      ((PTMQMSB(m_HostListSB[m_Host_IndexSB]).SB_PREQ_NO < Request) or
      ((PTMQMSB(m_HostListSB[m_Host_IndexSB]).SB_PREQ_NO = Request) and
      (PTMQMSB(m_HostListSB[m_Host_IndexSB]).SB_PSTEP_ID < Step))) do
        m_Host_IndexSB := m_Host_IndexSB + 1;
    if (m_Host_IndexSB < m_HostListSB.Count) and (PTMQMSB(m_HostListSB[m_Host_IndexSB]).SB_PREQ_NO = Request) and (PTMQMSB(m_HostListSB[m_Host_IndexSB]).SB_PSTEP_ID = Step) then
      m_Begin_StepIndexSB := m_Host_IndexSB
  end;

  m_Begin_StepIndexSP := -1;
  if m_HostListSP.Count <> 0 then
  begin
    if (m_Host_IndexSP = -1) then
       m_Host_IndexSP := 0;
    while (m_Host_IndexSP < m_HostListSP.Count) and
      ((PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_PREQ_NO < Request) or
      ((PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_PREQ_NO = Request) and
      (PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_PSTEP_ID < Step))) do
        m_Host_IndexSP := m_Host_IndexSP + 1;
    if (m_Host_IndexSP < m_HostListSP.Count) and (PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_PREQ_NO = Request) and (PTMQMSP(m_HostListSP[m_Host_IndexSP]).SP_PSTEP_ID = Step) then
      m_Begin_StepIndexSP := m_Host_IndexSP
  end;

  m_Begin_StepIndexST := -1;
  if m_HostListST.Count <> 0 then
  begin
    if (m_Host_IndexST = -1) then
       m_Host_IndexST := 0;
    while (m_Host_IndexST < m_HostListST.Count) and
      ((PTMQMST(m_HostListST[m_Host_IndexST]).ST_PREQ_NO < Request) or
      ((PTMQMST(m_HostListST[m_Host_IndexST]).ST_PREQ_NO = Request) and
      (PTMQMST(m_HostListST[m_Host_IndexST]).ST_PSTEP_ID < Step))) do
        m_Host_IndexST := m_Host_IndexST + 1;
    if (m_Host_IndexST < m_HostListST.Count) and (PTMQMST(m_HostListST[m_Host_IndexST]).ST_PREQ_NO = Request) and
       (PTMQMST(m_HostListST[m_Host_IndexST]).ST_PSTEP_ID = Step) then
      m_Begin_StepIndexST := m_Host_IndexST
  end;

  m_Begin_StepIndexMT := -1;
  if m_HostlistMT.Count <> 0 then
  begin
    if (m_Host_IndexMT = -1) then
       m_Host_IndexMT := 0;
    while (m_Host_IndexMT < m_HostlistMT.Count) and
      ((PTMQMMT(m_HostlistMT[m_Host_IndexMT]).MT_PROD_REQ_Nr < Request) or
      ((PTMQMMT(m_HostlistMT[m_Host_IndexMT]).MT_PROD_REQ_Nr = Request) and
      (PTMQMMT(m_HostlistMT[m_Host_IndexMT]).MT_PSTEP_ID < Step))) do
        m_Host_IndexMT := m_Host_IndexMT + 1;
    if (m_Host_IndexMT < m_HostlistMT.Count) and (PTMQMMT(m_HostlistMT[m_Host_IndexMT]).MT_PROD_REQ_Nr = Request) and
       (PTMQMMT(m_HostlistMT[m_Host_IndexMT]).MT_PSTEP_ID = Step) then
      m_Begin_StepIndexMT := m_Host_IndexMT
  end;

end;

//----------------------------------------------------------------------------//

procedure TProdCont.SetPosOnLocalList(Request : string);
begin
//  m_Local_Begin_IndexPH := -1;
  if m_LocalListPH.Count <> 0 then
  begin
    if (m_Local_IndexPH = -1) then
       m_Local_IndexPH := 0;
    while (m_Local_IndexPH < m_LocalListPH.Count) and (PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_PREQ_NO < Request) do
        m_Local_IndexPH := m_Local_IndexPH + 1;
    if (m_Local_IndexPH < m_LocalListPH.Count) and (PTMQMPH(m_LocalListPH[m_Local_IndexPH]).PH_PREQ_NO = Request) then
//      m_Local_Begin_IndexPH := m_Local_IndexPH
  end;

//  m_Local_Begin_IndexPD := -1;
  if m_LocalListPD.Count <> 0 then
  begin
    if (m_Local_IndexPD = -1) then
       m_Local_IndexPD := 0;
    while (m_Local_IndexPD < m_LocalListPD.Count) and (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_PREQ_NO < Request) do
        m_Local_IndexPD := m_Local_IndexPD + 1;
    if (m_Local_IndexPD < m_LocalListPD.Count) and (PTMQMPD(m_LocalListPD[m_Local_IndexPD]).PD_PREQ_NO = Request) then
  //    m_Local_Begin_IndexPD := m_Local_IndexPD
  end;

//  m_Local_Begin_IndexPP := -1;
  if m_LocalListPP.Count <> 0 then
  begin
    if (m_Local_IndexPP = -1) then
       m_Local_IndexPP := 0;
    while (m_Local_IndexPP < m_LocalListPP.Count) and (PTMQMPP(m_LocalListPP[m_Local_IndexPP]).PP_PREQ_NO < Request) do
        m_Local_IndexPP := m_Local_IndexPP + 1;
    if (m_Local_IndexPP < m_LocalListPP.Count) and (PTMQMPP(m_LocalListPP[m_Local_IndexPP]).PP_PREQ_NO = Request) then
//      m_Local_Begin_IndexPP := m_Local_IndexPP
  end;

//  m_Local_Begin_IndexPI := -1;
  if m_LocalListPI.Count <> 0 then
  begin
    if (m_Local_IndexPI = -1) then
       m_Local_IndexPI := 0;
    while (m_Local_IndexPI < m_LocalListPI.Count) and (PTMQMPI(m_LocalListPI[m_Local_IndexPI]).PI_PREQ_NO < Request) do
        m_Local_IndexPI := m_Local_IndexPI + 1;
    if (m_Local_IndexPI < m_LocalListPI.Count) and (PTMQMPI(m_LocalListPI[m_Local_IndexPI]).PI_PREQ_NO = Request) then
//      m_Local_Begin_IndexPI := m_Local_IndexPI
  end;

//  m_Local_Begin_IndexEC := -1;
  if m_LocalListEC.Count <> 0 then
  begin
    if (m_Local_IndexEC = -1) then
       m_Local_IndexEC := 0;
    while (m_Local_IndexEC < m_LocalListEC.Count) and (PTMQMEC(m_LocalListEC[m_Local_IndexEC]).EC_PREQ_NO < Request) do
        m_Local_IndexEC := m_Local_IndexEC + 1;
    if (m_Local_IndexEC < m_LocalListEC.Count) and (PTMQMEC(m_LocalListEC[m_Local_IndexEC]).EC_PREQ_NO = Request) then
//      m_Local_Begin_IndexEC := m_Local_IndexEC
  end;

//  m_Local_Begin_IndexIC := -1;
  if m_LocalListIC.Count <> 0 then
  begin
    if (m_Local_IndexIC = -1) then
       m_Local_IndexIC := 0;
    while (m_Local_IndexIC < m_LocalListIC.Count) and (PTMQMIC(m_LocalListIC[m_Local_IndexIC]).IC_PREQ_NO < Request) do
        m_Local_IndexIC := m_Local_IndexIC + 1;
    if (m_Local_IndexIC < m_LocalListIC.Count) and (PTMQMIC(m_LocalListIC[m_Local_IndexIC]).IC_PREQ_NO = Request) then
//      m_Local_Begin_IndexIC := m_Local_IndexIC
  end;

//  m_Local_Begin_IndexSB := -1;
  if m_LocalListSB.Count <> 0 then
  begin
    if (m_Local_IndexSB = -1) then
       m_Local_IndexSB := 0;
    while (m_Local_IndexSB < m_LocalListSB.Count) and (PTMQMSB(m_LocalListSB[m_Local_IndexSB]).SB_PREQ_NO < Request) do
        m_Local_IndexSB := m_Local_IndexSB + 1;
    if (m_Local_IndexSB < m_LocalListSB.Count) and (PTMQMSB(m_LocalListSB[m_Local_IndexSB]).SB_PREQ_NO = Request) then
//      m_Local_Begin_IndexSB := m_Local_IndexSB
  end;

//  m_Local_Begin_IndexSP := -1;
  if m_LocalListSP.Count <> 0 then
  begin
    if (m_Local_IndexSP = -1) then
       m_Local_IndexSP := 0;
    while (m_Local_IndexSP < m_LocalListSP.Count) and (PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_PREQ_NO < Request) do
        m_Local_IndexSP := m_Local_IndexSP + 1;
    if (m_Local_IndexSP < m_LocalListSP.Count) and (PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_PREQ_NO = Request) then
  //    m_Local_Begin_IndexSP := m_Local_IndexSP
  end;

//  m_Local_Begin_IndexST := -1;
  if m_LocalListST.Count <> 0 then
  begin
    if (m_Local_IndexST = -1) then
       m_Local_IndexST := 0;
    while (m_Local_IndexST < m_LocalListST.Count) and (PTMQMST(m_LocalListST[m_Local_IndexST]).ST_PREQ_NO < Request) do
        m_Local_IndexST := m_Local_IndexST + 1;
    if (m_Local_IndexST < m_LocalListST.Count) and (PTMQMST(m_LocalListST[m_Local_IndexST]).ST_PREQ_NO = Request) then
//      m_Local_Begin_IndexST := m_Local_IndexST
  end;

//  m_Local_Begin_IndexMT := -1;
  if m_LocallistMT.Count <> 0 then
  begin
    if (m_Local_IndexMT = -1) then
       m_Local_IndexMT := 0;
    while (m_Local_IndexMT < m_LocallistMT.Count) and (PTMQMMT(m_LocallistMT[m_Local_IndexMT]).MT_PROD_REQ_Nr < Request) do
        m_Local_IndexMT := m_Local_IndexMT + 1;
    if (m_Local_IndexMT < m_LocallistMT.Count) and (PTMQMMT(m_LocallistMT[m_Local_IndexMT]).MT_PROD_REQ_Nr = Request) then
//      m_Local_Begin_IndexMT := m_Local_IndexMT
  end;

//  m_Local_Begin_IndexPA := -1;
  if m_LocallistPA.Count <> 0 then
  begin
    if (m_Local_IndexPA = -1) then
       m_Local_IndexPA := 0;
    while (m_Local_IndexPA < m_LocallistPA.Count) and (PTMQMPA(m_LocallistPA[m_Local_IndexPA]).PA_PROD_REQ_NR < Request) do
        m_Local_IndexPA := m_Local_IndexPA + 1;
    if (m_Local_IndexPA < m_LocallistPA.Count) and (PTMQMPA(m_LocallistPA[m_Local_IndexPA]).PA_PROD_REQ_NR = Request) then
//      m_Local_Begin_IndexPA := m_Local_IndexPA
  end;
end;

//----------------------------------------------------------------------------//

procedure TProdCont.SetPosOnStepLocalList(Request : string ; Step : integer);
begin
  m_Begin_StepIndexPP := -1;
  if m_LocalListPP.Count <> 0 then
  begin
    if (m_Local_IndexPP = -1) then
      m_Local_IndexPP := 0;
    while (m_Local_IndexPP < m_LocalListPP.Count) and
     ((PTMQMPP(m_LocalListPP[m_Local_IndexPP]).PP_PREQ_NO < Request) or
      ((PTMQMPP(m_LocalListPP[m_Local_IndexPP]).PP_PREQ_NO = Request) and
      (PTMQMPP(m_LocalListPP[m_Local_IndexPP]).PP_PSTEP_ID < Step))) do
        m_Local_IndexPP := m_Local_IndexPP + 1;
    if (m_Local_IndexPP < m_LocalListPP.Count) and (PTMQMPP(m_LocalListPP[m_Local_IndexPP]).PP_PREQ_NO = Request) and (PTMQMPP(m_LocalListPP[m_Local_IndexPP]).PP_PSTEP_ID = Step) then
      m_Begin_StepIndexPP := m_Local_IndexPP
  end;

  m_Begin_StepIndexPI := -1;
  if m_LocalListPI.Count <> 0 then
  begin
    if (m_Local_IndexPI = -1) then
       m_Local_IndexPI := 0;
    while (m_Local_IndexPI < m_LocalListPI.Count) and
       ((PTMQMPI(m_LocalListPI[m_Local_IndexPI]).PI_PREQ_NO < Request) or
       ((PTMQMPI(m_LocalListPI[m_Local_IndexPI]).PI_PREQ_NO = Request) and
        (PTMQMPI(m_LocalListPI[m_Local_IndexPI]).PI_PSTEP_ID < Step))) do
        m_Local_IndexPI := m_Local_IndexPI + 1;
    if (m_Local_IndexPI < m_LocalListPI.Count) and (PTMQMPI(m_LocalListPI[m_Local_IndexPI]).PI_PREQ_NO = Request) and (PTMQMPI(m_LocalListPI[m_Local_IndexPI]).PI_PSTEP_ID = Step) then
      m_Begin_StepIndexPI := m_Local_IndexPI
  end;

  m_Begin_StepIndexSB := -1;
  if m_LocalListSB.Count <> 0 then
  begin
    if (m_Local_IndexSB = -1) then
       m_Local_IndexSB := 0;
    while (m_Local_IndexSB < m_LocalListSB.Count) and
      ((PTMQMSB(m_LocalListSB[m_Local_IndexSB]).SB_PREQ_NO < Request) or
      ((PTMQMSB(m_LocalListSB[m_Local_IndexSB]).SB_PREQ_NO = Request) and
      (PTMQMSB(m_LocalListSB[m_Local_IndexSB]).SB_PSTEP_ID < Step))) do
        m_Local_IndexSB := m_Local_IndexSB + 1;
    if (m_Local_IndexSB < m_LocalListSB.Count) and (PTMQMSB(m_LocalListSB[m_Local_IndexSB]).SB_PREQ_NO = Request) and (PTMQMSB(m_LocalListSB[m_Local_IndexSB]).SB_PSTEP_ID = Step) then
      m_Begin_StepIndexSB := m_Local_IndexSB
  end;

  m_Begin_StepIndexSP := -1;
  if m_LocalListSP.Count <> 0 then
  begin
    if (m_Local_IndexSP = -1) then
       m_Local_IndexSP := 0;
    while (m_Local_IndexSP < m_LocalListSP.Count) and
      ((PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_PREQ_NO < Request) or
      ((PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_PREQ_NO = Request) and
      (PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_PSTEP_ID < Step))) do
        m_Local_IndexSP := m_Local_IndexSP + 1;
    if (m_Local_IndexSP < m_LocalListSP.Count) and (PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_PREQ_NO = Request) and (PTMQMSP(m_LocalListSP[m_Local_IndexSP]).SP_PSTEP_ID = Step) then
      m_Begin_StepIndexSP := m_Local_IndexSP
  end;

  m_Begin_StepIndexST := -1;
  if m_LocalListST.Count <> 0 then
  begin
    if (m_Local_IndexST = -1) then
       m_Local_IndexST := 0;
    while (m_Local_IndexST < m_LocalListST.Count) and
      ((PTMQMST(m_LocalListST[m_Local_IndexST]).ST_PREQ_NO < Request) or
      ((PTMQMST(m_LocalListST[m_Local_IndexST]).ST_PREQ_NO = Request) and
      (PTMQMST(m_LocalListST[m_Local_IndexST]).ST_PSTEP_ID < Step))) do
        m_Local_IndexST := m_Local_IndexST + 1;
    if (m_Local_IndexST < m_LocalListST.Count) and (PTMQMST(m_LocalListST[m_Local_IndexST]).ST_PREQ_NO = Request) and
       (PTMQMST(m_LocalListST[m_Local_IndexST]).ST_PSTEP_ID = Step) then
      m_Begin_StepIndexST := m_Local_IndexST
  end;

  m_Begin_StepIndexMT := -1;
  if m_LocallistMT.Count <> 0 then
  begin
    if (m_Local_IndexMT = -1) then
       m_Local_IndexMT := 0;
    while (m_Local_IndexMT < m_LocallistMT.Count) and
      ((PTMQMMT(m_LocallistMT[m_Local_IndexMT]).MT_PROD_REQ_Nr < Request) or
      ((PTMQMMT(m_LocallistMT[m_Local_IndexMT]).MT_PROD_REQ_Nr = Request) and
      (PTMQMMT(m_LocallistMT[m_Local_IndexMT]).MT_PSTEP_ID < Step))) do
        m_Local_IndexMT := m_Local_IndexMT + 1;
    if (m_Local_IndexMT < m_LocallistMT.Count) and (PTMQMMT(m_LocallistMT[m_Local_IndexMT]).MT_PROD_REQ_Nr = Request) and
       (PTMQMMT(m_LocallistMT[m_Local_IndexMT]).MT_PSTEP_ID = Step) then
      m_Begin_StepIndexMT := m_Local_IndexMT
  end;

end;

//----------------------------------------------------------------------------//

procedure TProdCont.SetPosOnQry(Request : string; QryPH,QryPD,QryPP,QryPI,QryEC,QryIC,QrySB,QrySP,QryST,QryMT,QryPA : TMqmQuery);
var
  tbInfo: ^TTblInfo;
begin
  tbInfo := @tblInfo[tbl_prod_reqHdr];
  while (not QryPH.Eof) and (Trim(QryPH.FieldByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString) < Request) do
  begin
    QryPH.Next;
    Application.ProcessMessages;
  end;

  tbInfo := @tblInfo[tbl_prod_step];
  while (not QryPD.Eof) and (Trim(QryPD.FieldByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString) < Request) do
  begin
    QryPD.Next;
    Application.ProcessMessages;
  end;

  tbInfo := @tblInfo[tbl_prop_prod];
  while (not QryPP.Eof) and (Trim(QryPP.FieldByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString) < Request) do
  begin
    QryPP.Next;
    Application.ProcessMessages;
  end;

  tbInfo := @tblInfo[tbl_prod_info];
  while (not QryPI.Eof) and (Trim(QryPI.FieldByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString) < Request) do
  begin
    QryPI.Next;
    Application.ProcessMessages;
  end;

  tbInfo := @tblInfo[tbl_ext_connection];
  while (not QryEC.Eof) and (Trim(QryEC.FieldByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString) < Request) do
  begin
    QryEC.Next;
    Application.ProcessMessages;
  end;

  tbInfo := @tblInfo[tbl_prod_reqConnection];
  while (not QryIC.Eof) and (Trim(QryIC.FieldByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString) < Request) do
  begin
    QryIC.Next;
    Application.ProcessMessages;
  end;

  tbInfo := @tblInfo[tbl_step_batchSize];
  while (not QrySB.Eof) and (Trim(QrySB.FieldByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString) < Request) do
  begin
    QrySB.Next;
    Application.ProcessMessages;
  end;

  tbInfo := @tblInfo[tbl_sched_progress];
  while (not QrySP.Eof) and (Trim(QrySP.FieldByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString) < Request) do
  begin
    QrySP.Next;
    Application.ProcessMessages;
  end;

  tbInfo := @tblInfo[tbl_step_times];
  while (not QryST.Eof) and (Trim(QryST.FieldByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString) < Request) do
  begin
    QryST.Next;
    Application.ProcessMessages;
  end;

  tbInfo := @tblInfo[tbl_material];
  while (not QryMT.Eof) and (Trim(QryMT.FieldByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString) < Request) do
  begin
    QryMT.Next;
    Application.ProcessMessages;
  end;

  tbInfo := @tblInfo[tbl_produced_Article];
  while (not QryPA.Eof) and (Trim(QryPA.FieldByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString) < Request) do
  begin
    QryPA.Next;
    Application.ProcessMessages;
  end;
end;

//----------------------------------------------------------------------------//

procedure TProdCont.SetStepPosOnQry(Request : string; step : Integer ; QryPP,QryPI,QrySB,QrySP,QryST,QryMT : TMqmQuery);
var
  tbInfo: ^TTblInfo;
begin

  tbInfo := @tblInfo[tbl_prop_prod];
  while (not QryPP.Eof) and
      ((Trim(QryPP.FieldByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString) < Request) or
      ((Trim(QryPP.FieldByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString) = Request) and
       (QryPP.FieldByName(CreateFld(tbInfo.pfx, fli_pstepId)).AsInteger < Step))) do
  begin
    QryPP.Next;
    Application.ProcessMessages;
  end;

  tbInfo := @tblInfo[tbl_prod_info];
  while (not QryPI.Eof) and
      ((Trim(QryPI.FieldByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString) < Request) or
      ((Trim(QryPI.FieldByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString) = Request) and
      (QryPI.FieldByName(CreateFld(tbInfo.pfx, fli_pstepId)).AsInteger < Step))) do
  begin
    QryPI.Next;
    Application.ProcessMessages;
  end;

  tbInfo := @tblInfo[tbl_step_batchSize];
  while (not QrySB.Eof) and
      ((Trim(QrySB.FieldByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString) < Request) or
      ((Trim(QrySB.FieldByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString) = Request) and
      (QrySB.FieldByName(CreateFld(tbInfo.pfx, fli_pstepId)).AsInteger < Step))) do
  begin
    QrySB.Next;
    Application.ProcessMessages;
  end;

  tbInfo := @tblInfo[tbl_sched_progress];
  while (not QrySP.Eof) and
      ((Trim(QrySP.FieldByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString) < Request) or
      ((Trim(QrySP.FieldByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString) = Request) and
       (QrySP.FieldByName(CreateFld(tbInfo.pfx, fli_pstepId)).AsInteger < Step))) do
  begin
    QrySP.Next;
    Application.ProcessMessages;
  end;

  tbInfo := @tblInfo[tbl_step_times];
  while (not QryST.Eof) and
      ((Trim(QryST.FieldByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString) < Request) or
      ((Trim(QryST.FieldByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString) = Request) and
       (QryST.FieldByName(CreateFld(tbInfo.pfx, fli_pstepId)).AsInteger < Step))) do
  begin
    QryST.Next;
    Application.ProcessMessages;
  end;

  tbInfo := @tblInfo[tbl_material];
  while (not QryMT.Eof) and
      ((Trim(QryMT.FieldByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString) < Request) or
      ((Trim(QryMT.FieldByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString) = Request) and
      (QryMT.FieldByName(CreateFld(tbInfo.pfx, fli_pstepId)).AsInteger < Step))) do
  begin
    QryMT.Next;
    Application.ProcessMessages;
  end;
end;

//----------------------------------------------------------------------------//

function TProdCont.AddReqToCngList(Request : string ; TypChange : TReqChange ; Req_Reactivate : boolean; HandledByMcm : string; PrevReqHandledByMcm : string; Reason : string) : Integer;
var
  ReqChange : PReqChange;
begin
  New(ReqChange);
  // in case of deleted , no meening for the indexes

{  ReqChange.Index_PR := m_Begin_IndexPR;
  ReqChange.Index_PH := m_Begin_IndexPH;
  ReqChange.Index_PD := m_Begin_IndexPD;
  ReqChange.Index_PP := m_Begin_IndexPP;
  ReqChange.Index_PI := m_Begin_IndexPI;
  ReqChange.Index_EC := m_Begin_IndexEC;
  ReqChange.Index_IC := m_Begin_IndexIC;
  ReqChange.Index_SB := m_Begin_IndexSB;
  ReqChange.Index_SP := m_Begin_IndexSP;
  ReqChange.Index_ST := m_Begin_IndexST;
  ReqChange.Index_MT := m_Begin_IndexMT;
  ReqChange.Index_PA := m_Begin_IndexPA;  }

  ReqChange.ProdReq := Request;
  ReqChange.ChangedType := TypChange;
  ReqChange.Reason := Reason;
  ReqChange.Reactivate := Req_Reactivate;
  ReqChange.HandledByMcm := false;
  ReqChange.PrevHandledByMcm := false;
{  if (IniAppGlobals.MudulesServed = '1') or (IniAppGlobals.MudulesServed = '2') then
  begin
    if (HandledByMcm = '1') or (HandledByMcm = '2') then
        ReqChange.HandledByMcm := true;
    if (PrevReqHandledByMcm = '1') or (PrevReqHandledByMcm = '2') then
        ReqChange.PrevHandledByMcm := true;
  end; }
  Result := m_Req_Change_List.Add(ReqChange);
end;

//----------------------------------------------------------------------------//
function TProdCont.AddStepReqToCngList(Request : string ; Step : Integer ; TypChange : TStepChange; HandledByMcm : string ; PrevstepHandledByMcm : string; reason : string) : Integer;
var
  StepChange : PStepChange;
begin
  New(StepChange);
  StepChange.ProdReq := Request;
  StepChange.StepNr := Step;
  StepChange.ChangedType := TypChange;
  StepChange.Reason := reason;
 { StepChange.Index_PD := m_Begin_StepIndexPD;
  StepChange.Index_PP := m_Begin_StepIndexPP;
  StepChange.Index_PI := m_Begin_StepIndexPI;
  StepChange.Index_SB := m_Begin_StepIndexSB;
  StepChange.Index_SP := m_Begin_StepIndexSP;
  StepChange.Index_ST := m_Begin_StepIndexST;
  StepChange.Index_MT := m_Begin_StepIndexMT;  }
  StepChange.HandledByMcm := false;
  StepChange.PrevHandledByMcm := false;
{  if (IniAppGlobals.MudulesServed = '1') or (IniAppGlobals.MudulesServed = '2') then
  begin
    if (HandledByMcm = '1') then
      StepChange.HandledByMcm := true;
    if (PrevStepHandledByMcm = '1') then
      StepChange.PrevHandledByMcm := true;
  end;  }
  Result := m_Req_Step_Change_List.add(StepChange);
end;

//----------------------------------------------------------------------------//

function TProdCont.CheckWorkCenterChangeList(Wc : string) : boolean;
var
  I : Integer;
begin
  Result := true;
  for I := 0 to m_Work_Cnter_Chang_List.count - 1 do
  begin
    if (m_Work_Cnter_Chang_List.Strings[I] = Wc) then
    begin
      Result := false;
      exit
    end;
  end;
  m_Work_Cnter_Chang_List.add(Wc);
end;

//----------------------------------------------------------------------------//

function GetAccessWriteToDB : boolean;
const
  TRY_NUMBER = 200;
var
  J : Integer;
  Temp : TDateTime;
begin
  Result := true;
  j := 0;
  while j <= TRY_NUMBER do
  begin
    if GET_ACCESS('SERVER', AT_write) then
    begin
      Break;
    end
    else
    begin
      inc(j);
      if (j > TRY_NUMBER) then
      begin
        if (ParamCount = 0) then
        begin
          Result := false;
          FSrvLoad.MmErrors.Lines.Clear;
          FSrvLoad.MmErrors.Lines.Add(_('Can not currently perform a download a planner is writing/Reading to the database. Please Try again'));
          FSrvLoad.PGCmain.TabIndex := 1;
          UpdateOperation('');
        end;
        break;
        j := 0;
      end else
      begin
        Application.ProcessMessages;
       { if AskPolling then
        begin
          Sleep(2500);
          inc(j);
          Application.ProcessMessages;
          Sleep(2500);
          CheckPolling;
        end else
          Sleep(2500);  }
        REMOVE_UNACTIVATED_STATIONS;
        Application.ProcessMessages;
      end
    end;
  end;
end;

//----------------------------------------------------------------------------//

function TProdCont.InsertReqListToDataBase(var GotAccess : boolean) : boolean;
var
  Temp : TDateTime;
begin
  Result := false;
  GotAccess := false;
  m_UpdatedGenNumber := GetUpdatedReqNumber;
  IniAppGlobals.Count_ReqChanged := m_Req_Change_List.count;
  if m_Req_Change_List.count > 0 then
  begin
    if GetAccessWriteToDB then
       GotAccess := true
    else
      exit;
    Result := UpdateStatusRequests;
    END_ACCESS('SERVER');
  //  Sleep(500);
  end;
end;

//----------------------------------------------------------------------------//

function TProdCont.InsertCapResListToDataBase : boolean;
var
  I : Integer;
  srvTrs: TMqmTransaction;
  IsClientOpen : boolean;
  DndArchiveHostName : TDndArchiveName;
begin
  Result := false;
  DndArchiveHostName := GetDndArchiveHostName;

  srvTrs := ThreadCreateTransaction(Main_DB);
  srvTrs.StartTransaction;

  m_Updated_CapRes_Number := GetUpdatedCapResNumber;
  m_Updated_Rsc_Change_Number := GetUpdatedResChangedNumber;

  IsClientOpen := ClearChangeCapResTables(srvTrs);
  if not IsClientOpen then
    srvTrs.Commit;
  srvTrs.free;

  srvTrs := nil;
  if Assigned(m_Cap_Res_Changed_list) and (m_Cap_Res_Changed_list.Count > 0) then
  begin
    srvTrs := ThreadCreateTransaction(Main_DB);
    srvTrs.StartTransaction;
    if DndArchiveHostName <> TD_AS_400 then
      InsertChangeCapResToTable(srvTrs)
    else
      InsertChangeCapResToTableAs400(srvTrs);
    srvTrs.Commit;
    srvTrs.free;
    if IsClientOpen then
    begin
      Result := true;
      srvTrs := ThreadCreateTransaction(Main_DB);
      InsertResChangeCapResToTabl(srvTrs);
      if srvTrs.Active then
        srvTrs.Commit;
      srvTrs.Free;
    end;

    if assigned(m_Cap_Res_Changed_list) then
    begin
      if DndArchiveHostName <> TD_AS_400 then
      begin
        //changed from PTMQMCR to PTCapRes
        for I := m_Cap_Res_Changed_list.Count -1 downto 0 do
           Dispose(PTCapRes(m_Cap_Res_Changed_list[I]));
      end
      else
      begin
        for I := m_Cap_Res_Changed_list.Count -1 downto 0 do
           Dispose(PTMQMCR(m_Cap_Res_Changed_list[I]));
      end;
      m_Cap_Res_Changed_list.Clear;
      m_Cap_Res_Changed_list.free;
    end;
    if assigned(m_Rsc_Change_List) then
    begin
      m_Rsc_Change_List.Clear;
      m_Rsc_Change_List.free;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TProdCont.InsertMcmReqRecordToDataBase(McmReqChange : PReqChange; var srvTrs: TMqmTransaction);
var
//  QryMcmReqCng : TMqmQuery;
  tbInfo: ^TTblInfo;
  ReqChange : string;
const
  fldList: array [0..3] of TQryLinkRec = (
    (fldPC: fli_StartDownloadDateTime;  fldAS: ''; fldType: TLD_dateTime),
    (fldPC: fli_preqNo;                 fldAS: ''; fldType: TLD_string),
    (fldPC: fli_pstepId;                fldAS: ''; fldType: TLD_integer),
    (fldPC: fli_ChangeType;             fldAS: ''; fldType: TLD_string)
  );
begin
  if (not McmReqChange.HandledByMcm) and (not McmReqChange.PrevHandledByMcm) then
     exit;

  case McmReqChange.ChangedType of
    NewReq : ReqChange     := '1';
    DelReq : ReqChange     := '3';

    HeadrFieldsChange : begin
                          if (McmReqChange.HandledByMcm) and (McmReqChange.PrevHandledByMcm) then
                             ReqChange     := '2' // re-schedule
                          else if (not McmReqChange.HandledByMcm) and (McmReqChange.PrevHandledByMcm) then
                             ReqChange     := '3' // delete
                          else if (McmReqChange.HandledByMcm) and (not McmReqChange.PrevHandledByMcm) then
                             ReqChange     := '1' // new
                        end;
    HeadrPropChange, HeaderCosmeticChanged, StepChangeOnly :
                        begin
                          if (McmReqChange.HandledByMcm) and (McmReqChange.PrevHandledByMcm) then
                             ReqChange     := '4' // other
                          else if (not McmReqChange.HandledByMcm) and (McmReqChange.PrevHandledByMcm) then
                             ReqChange     := '3' // delete
                          else if (McmReqChange.HandledByMcm) and (not McmReqChange.PrevHandledByMcm) then
                             ReqChange     := '1' // new
                        end;
  else
    exit;
  end;

{  QryMcmReqCng := ThreadCreateQuery(Main_DB);
//  InsertTable(tbl_MCM_Changes_List,fldList,QryMcmReqCng);
//  tbInfo := @tblInfo[tbl_MCM_Changes_List];

  with QryMcmReqCng do
  begin
    ParamByName(CreateFld(tbInfo.pfx, fli_StartDownloadDateTime)).AsDateTime := m_StartDownloadDateTime;
    ParamByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString                  := McmReqChange.ProdReq;
    ParamByName(CreateFld(tbInfo.pfx, fli_pstepId)).AsInteger                := 0;
    ParamByName(CreateFld(tbInfo.pfx, fli_ChangeType)).AsString              := ReqChange;
    ExecSQL;
    Application.ProcessMessages;
  end;

  QryMcmReqCng.Free; }
end;

//----------------------------------------------------------------------------//

procedure TProdCont.InsertMcmStepRecordToDataBase(McmStepChange : PStepChange; ReqChange : PReqChange;  var srvTrs: TMqmTransaction);
var
//  QryMcmStepCng : TMqmQuery;
  tbInfo: ^TTblInfo;
  StepChange : string;
const
  fldList: array [0..3] of TQryLinkRec = (
    (fldPC: fli_StartDownloadDateTime;  fldAS: ''; fldType: TLD_dateTime),
    (fldPC: fli_preqNo;                 fldAS: ''; fldType: TLD_string),
    (fldPC: fli_pstepId;                fldAS: ''; fldType: TLD_integer),
    (fldPC: fli_ChangeType;             fldAS: ''; fldType: TLD_string)
  );
begin
  if not ReqChange.HandledByMcm then exit;
  if not ReqChange.PrevHandledByMcm then exit;
  if (not McmStepChange.HandledByMcm) and (not McmStepChange.PrevHandledByMcm) then
     exit;

  case McmStepChange.ChangedType of
    NewStep : StepChange     := '1';
    DelStep : StepChange     := '3';

    StepFieldChange : begin
                          if (McmStepChange.HandledByMcm) and (McmStepChange.PrevHandledByMcm) then
                             StepChange     := '2' // re-schedule
                          else if (not McmStepChange.HandledByMcm) and (McmStepChange.PrevHandledByMcm) then
                             StepChange     := '3' // delete
                          else if (McmStepChange.HandledByMcm) and (not McmStepChange.PrevHandledByMcm) then
                             StepChange     := '1' // new
                        end;
    StepPropChange, StepCosmeticChanged, OnlyProgres_TimeCng :
                        begin
                          if (McmStepChange.HandledByMcm) and (McmStepChange.PrevHandledByMcm) then
                             StepChange     := '4' // other
                          else if (not McmStepChange.HandledByMcm) and (McmStepChange.PrevHandledByMcm) then
                             StepChange     := '3' // delete
                          else if (McmStepChange.HandledByMcm) and (not McmStepChange.PrevHandledByMcm) then
                             StepChange     := '1' // new
                        end;
  else
    exit;
  end;

//  TStepChange = (NoChange ,NewStep ,DelStep , StepFieldChange, StepPropChange,
//                StepCosmeticChanged, OnlyProgres_TimeCng);

{  QryMcmStepCng := ThreadCreateQuery(srvTrs, Main_DB);
//  InsertTable(tbl_MCM_Changes_List,fldList,QryMcmStepCng);
//  tbInfo := @tblInfo[tbl_MCM_Changes_List];

  with QryMcmStepCng do
  begin
    ParamByName(CreateFld(tbInfo.pfx, fli_StartDownloadDateTime)).AsDateTime := m_StartDownloadDateTime;
    ParamByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString                  := McmStepChange.ProdReq;
    ParamByName(CreateFld(tbInfo.pfx, fli_pstepId)).AsInteger                := McmStepChange.StepNr;
    ParamByName(CreateFld(tbInfo.pfx, fli_ChangeType)).AsString              := StepChange;
    ExecSQL;
    Application.ProcessMessages;
  end;

  QryMcmStepCng.Free;  }
end;

//----------------------------------------------------------------------------//

function TProdCont.ClearChangeReqWcTables : boolean;
var
  QryPR,QryWC,QryPS : TMqmQuery;
  tbInfo: ^TTblInfo;
//  LocSrvTrs: TMqmTransaction;
begin
 Result := true;
  if not EXIST_ACTIVE_STATIONS then//SP_IS_CLIENT_EXIST then
  begin
    Result := false;
   // LocSrvTrs := CreateTransaction(Main_DB);
    QryPR := ThreadCreateQuery(Main_DB);
    QryPR.Transaction := ThreadCreateTransaction(Main_DB);
    QryPR.Transaction.StartTransaction;
    tbInfo := @tblInfo[tbl_Req_Change];
    with QryPR do
    begin
      SQL.Clear;
      SQL.Add('delete from ' + tbInfo.GetTableName);
      SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
      ExecSQL;
      QryPR.Close;
     // QryPR.Free;
    end;
    QryWC := ThreadCreateQuery(Main_DB);
    QryWC.Transaction := ThreadCreateTransaction(Main_DB);
    QryWC.Transaction.StartTransaction;

    tbInfo := @tblInfo[tbl_wkc_Change];
    with QryWC do
    begin
      SQL.Clear;
      SQL.Add('delete from ' + tbInfo.GetTableName);
      SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
      ExecSQL;
      QryWC.Close;
     // QryWC.Free;
    end;
    QryPS := ThreadCreateQuery(Main_DB);
    QryPS.Transaction := ThreadCreateTransaction(Main_DB);
    QryPS.Transaction.StartTransaction;

    if not DBAppGlobals.License_MQM then
      tbInfo := @tblInfo[tbl_prod_sched_mcm]
    else
      tbInfo := @tblInfo[tbl_prod_sched];

    with QryPS do
    begin
      SQL.Clear;
      SQL.Add(' Update ' + tbInfo.GetTableName);
      SQL.Add(' set '    + CreateFld(tbInfo.pfx, fli_updCode) + ' = 0');
      SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
      ExecSQL;
      QryPS.Close;
    //  QryPS.Free;
    end;
    QryPR.Transaction.Commit;
    QryWC.Transaction.Commit;
    QryPS.Transaction.Commit;

    QryPR.free;
    QryWC.free;
    QryPS.free;

  end;
end;

//----------------------------------------------------------------------------//

function TProdCont.ClearChangeCapResTables(srvTrs: TMqmTransaction) : boolean;
var
  QryCapRes,QryResList : TMqmQuery;
  tbInfo: ^TTblInfo;
begin
  Result := true;
  if EXIST_ACTIVE_STATIONS then //SP_IS_CLIENT_EXIST then
  begin
    Result := false;
    QryCapRes := ThreadCreateQuery(Main_DB);
    QryCapRes.Transaction := srvTrs;
    tbInfo := @tblInfo[tbl_CapRsc_Change];
    with QryCapRes do
    begin
      SQL.Clear;
      SQL.Add('delete from ' + tbInfo.GetTableName);
      SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
      ExecSQL;
      QryCapRes.Close;
      QryCapRes.Free;
    end;
    QryResList := ThreadCreateQuery(Main_DB);
    QryResList.Transaction := srvTrs;
    tbInfo := @tblInfo[tbl_rsc_Change];
    with QryResList do
    begin
      SQL.Clear;
      SQL.Add('delete from ' + tbInfo.GetTableName);
      SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
      ExecSQL;
      QryResList.Close;
      QryResList.Free;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TProdCont.InsertChangeReqToTable(LastUpdateRecord : boolean; Req : string ; ReqChange : PReqChange ; var srvTrs: TMqmTransaction; PreparedQry: TMqmQuery = nil);
var
  tbInfo: ^TTblInfo;
  QryProdReq : TMqmQuery;
  OwnQuery : boolean;
begin
  tbInfo := @tblInfo[tbl_Req_Change];

  OwnQuery := PreparedQry = nil;
  if OwnQuery then
  begin
    QryProdReq := ThreadCreateQuery(Main_DB);
    QryProdReq.Transaction := srvTrs;
    QryProdReq.SQL.Clear;
    QryProdReq.SQL.Add('insert into ' + tbInfo.GetTableName        + '(');
    QryProdReq.SQL.Add(CreateFld(tbInfo.pfx, fli_IDENTIFIER)       + ',');
    QryProdReq.SQL.Add(CreateFld(tbInfo.pfx, fli_preqNo)           + ',');
    QryProdReq.SQL.Add(CreateFld(tbInfo.pfx, fli_pstepId)          + ',');
    QryProdReq.SQL.Add(CreateFld(tbInfo.pfx, fli_updCode)          + ',');
    QryProdReq.SQL.Add(CreateFld(tbInfo.pfx, fli_ChangeType)       + ',');
    QryProdReq.SQL.Add(CreateFld(tbInfo.pfx, fli_ReactivateReq));
    QryProdReq.SQL.Add(') values (');
    QryProdReq.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_IDENTIFIER) + ',');
    QryProdReq.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_preqNo)     + ',');
    QryProdReq.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_pstepId)    + ',');
    QryProdReq.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_updCode)    + ',');
    QryProdReq.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_ChangeType) + ',');
    QryProdReq.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_ReactivateReq));
    QryProdReq.SQL.Add(')');
  end
  else
    QryProdReq := PreparedQry;

  with QryProdReq do
  begin
    if LastUpdateRecord then
    begin
      ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).Value := IniAppGlobals.Identifier;
      ParamByName(CreateFld(tbInfo.pfx, fli_preqNo)).Value := '_ _';
      ParamByName(CreateFld(tbInfo.pfx, fli_pstepId)).Value := 0;
      ParamByName(CreateFld(tbInfo.pfx, fli_updCode)).Value := m_UpdatedGenNumber;
      ParamByName(CreateFld(tbInfo.pfx, fli_ChangeType)).Value := 'X';
      ParamByName(CreateFld(tbInfo.pfx, fli_ReactivateReq)).Value := '';
      ExecSQL;
    end
    else
    begin
      ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).Value := IniAppGlobals.Identifier;
      ParamByName(CreateFld(tbInfo.pfx, fli_preqNo)).Value := Req;
      ParamByName(CreateFld(tbInfo.pfx, fli_pstepId)).Value := 0;
      ParamByName(CreateFld(tbInfo.pfx, fli_updCode)).Value := m_UpdatedGenNumber;
      ParamByName(CreateFld(tbInfo.pfx, fli_ChangeType)).Value := IntToStr((Ord(ReqChange.ChangedType) + 1));
      if ReqChange.Reactivate then
        ParamByName(CreateFld(tbInfo.pfx, fli_ReactivateReq)).Value := '1'
      else
        ParamByName(CreateFld(tbInfo.pfx, fli_ReactivateReq)).Value := '0';
      ExecSQL;
    end;
    if OwnQuery then
      Application.ProcessMessages;
  end;

  if OwnQuery then
    QryProdReq.Free;

end;

//----------------------------------------------------------------------------//

procedure TProdCont.InsertWCChangeReqToTable(LastUpdateRecord : boolean; var srvTrs: TMqmTransaction; WorkCenter : string);
var
  tbInfo: ^TTblInfo;
  QryWc : TMqmQuery;
//  I : Integer;
begin
  tbInfo := @tblInfo[tbl_wkc_Change];
  QryWC := ThreadCreateQuery(Main_DB);
  QryWC.transaction := srvTrs;

  with QryWC do
  begin
    SQL.Clear;
    SQL.Add('insert into ' + tbInfo.GetTableName         + '(');
    SQL.Add(CreateFld(tbInfo.pfx, fli_IDENTIFIER)        + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_wkCtrCode)         + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_updCode));
    SQL.Add(') values (');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_IDENTIFIER)  + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wkCtrCode)   + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_updCode));
    SQL.Add(')');
  //  Prepare;

    if LastUpdateRecord then
    begin
      ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsInteger := StrToInt(IniAppGlobals.Identifier);
      ParamByName(CreateFld(tbInfo.pfx, fli_wkCtrCode)).AsString := '_ _';
      ParamByName(CreateFld(tbInfo.pfx, fli_updCode)).AsInteger := m_UpdatedGenNumber;
    end
    else
    begin
      ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsInteger := StrToInt(IniAppGlobals.Identifier);
      ParamByName(CreateFld(tbInfo.pfx, fli_wkCtrCode)).AsString := WorkCenter;
      ParamByName(CreateFld(tbInfo.pfx, fli_updCode)).AsInteger := m_UpdatedGenNumber;
    end;
    ExecSQL;
    Application.ProcessMessages;
  end;

  QryWc.Free;
end;

//----------------------------------------------------------------------------//

procedure TProdCont.InsertChangeCapResToTableAs400(var srvTrs: TMqmTransaction);
var
  tbInfo: ^TTblInfo;
  Qry : TMqmQuery;
  I : Integer;
begin
  tbInfo := @tblInfo[tbl_capRes];
  Qry := ThreadCreateQuery(Main_DB);
  Qry.Transaction := srvTrs;

  for I := 0 to m_Cap_Res_Changed_list.Count - 1 do
  begin
    if (PTMQMCR(m_Cap_Res_Changed_list[I]).CR_CAP_RES_TYPE_CHANGE = NewCap) then
    begin
      with Qry do
      begin
        tbInfo := @tblInfo[tbl_capRes];
        SQL.Clear;
        SQL.Add('insert into ' + tbInfo.GetTableName       + '(');
        SQL.Add(CreateFld(tbInfo.pfx, fli_IDENTIFIER)      + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_CapacyResrv)     + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_rsc)             + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_subLinRscId)     + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_WCProcess)       + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_CapacyResTyp)    + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_Capacity_To_Job) + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_Comment)         + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_schedStart)      + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_schedEnd)        + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_usrCr)           + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_usrTmCr));
        SQL.Add(') values (');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_IDENTIFIER)      + ',');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_CapacyResrv)     + ',');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_rsc)             + ',');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_subLinRscId)     + ',');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_WCProcess)       + ',');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_CapacyResTyp)    + ',');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Capacity_To_Job) + ',');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Comment)         + ',');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_schedStart)      + ',');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_schedEnd)        + ',');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_usrCr)           + ',');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_usrTmCr));
        SQL.Add(')');
      //  Prepare;

        ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsInteger    := StrToInt(IniAppGlobals.Identifier);
        ParamByName(CreateFld(tbInfo.pfx, fli_CapacyResrv)).AsInteger    := PTMQMCR(m_Cap_Res_Changed_list[I]).CR_CAPACY_RESRV;
        ParamByName(CreateFld(tbInfo.pfx, fli_Rsc)).AsString             := PTMQMCR(m_Cap_Res_Changed_list[I]).CR_RSC;
        ParamByName(CreateFld(tbInfo.pfx, fli_subLinRscId)).AsInteger    := PTMQMCR(m_Cap_Res_Changed_list[I]).CR_SUB_LINE_RES;
        ParamByName(CreateFld(tbInfo.pfx, fli_WCProcess)).AsString       := PTMQMCR(m_Cap_Res_Changed_list[I]).CR_WC_PROCESS;
        ParamByName(CreateFld(tbInfo.pfx, fli_CapacyResTyp)).AsString    := PTMQMCR(m_Cap_Res_Changed_list[I]).CR_CAPRES_TYPE;
        ParamByName(CreateFld(tbInfo.pfx, fli_Capacity_To_Job)).AsString := PTMQMCR(m_Cap_Res_Changed_list[I]).CR_CAPACITY_To_JOB;
        ParamByName(CreateFld(tbInfo.pfx, fli_Comment)).AsString         := PTMQMCR(m_Cap_Res_Changed_list[I]).CR_COMMENTS;
        ParamByName(CreateFld(tbInfo.pfx, fli_schedStart)).AsDateTime    := PTMQMCR(m_Cap_Res_Changed_list[I]).CR_SCHEDULE_START;
        ParamByName(CreateFld(tbInfo.pfx, fli_schedEnd)).AsDateTime      := PTMQMCR(m_Cap_Res_Changed_list[I]).CR_SCHEDULE_END;
        ParamByName(CreateFld(tbInfo.pfx, fli_usrCr)).AsString           := PTMQMCR(m_Cap_Res_Changed_list[I]).CR_USR_CG;
        ParamByName(CreateFld(tbInfo.pfx, fli_usrTmCr)).AsDateTime       := PTMQMCR(m_Cap_Res_Changed_list[I]).CR_USR_TM_CG;
      //  try
          ExecSQL;
      //  except
            {on E: Exception do
            begin
              E.Message := E.Message + (' Cap res number : ' + IntToStr((PTMQMCR(m_Cap_Res_Changed_list[I]).CR_CAPACY_RESRV * (-1))) );
              raise;
            end;      }
      //  end;

        Application.ProcessMessages;

    {    // Insert also to host
        tbInfo := @tblInfo[tbl_capRes_Host];
        SQL.Clear;
        SQL.Add('insert into ' + tbInfo.GetTableName             + '(');
        SQL.Add(CreateFld(tbInfo.pfx, fli_CapacyResrv)     + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_rsc)             + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_subLinRscId)     + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_WCProcess)       + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_CapacyResTyp)    + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_Capacity_To_Job) + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_Comment)         + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_schedStart)      + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_schedEnd)        + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_usrCr)           + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_usrTmCr));
        SQL.Add(') values (');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_CapacyResrv)     + ',');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_rsc)             + ',');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_subLinRscId)     + ',');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_WCProcess)       + ',');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_CapacyResTyp)    + ',');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Capacity_To_Job) + ',');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Comment)         + ',');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_schedStart)      + ',');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_schedEnd)        + ',');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_usrCr)           + ',');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_usrTmCr));
        SQL.Add(')');
        Prepare;
        ParamByName(CreateFld(tbInfo.pfx, fli_CapacyResrv)).AsInteger    := PTMQMCR(m_Cap_Res_Changed_list[I]).CR_CAPACY_RESRV;
        ParamByName(CreateFld(tbInfo.pfx, fli_Rsc)).AsString             := PTMQMCR(m_Cap_Res_Changed_list[I]).CR_RSC;
        ParamByName(CreateFld(tbInfo.pfx, fli_subLinRscId)).AsInteger    := PTMQMCR(m_Cap_Res_Changed_list[I]).CR_SUB_LINE_RES;
        ParamByName(CreateFld(tbInfo.pfx, fli_WCProcess)).AsString       := PTMQMCR(m_Cap_Res_Changed_list[I]).CR_WC_PROCESS;
        ParamByName(CreateFld(tbInfo.pfx, fli_CapacyResTyp)).AsString    := PTMQMCR(m_Cap_Res_Changed_list[I]).CR_CAPRES_TYPE;
        ParamByName(CreateFld(tbInfo.pfx, fli_Capacity_To_Job)).AsString := PTMQMCR(m_Cap_Res_Changed_list[I]).CR_CAPACITY_To_JOB;
        ParamByName(CreateFld(tbInfo.pfx, fli_Comment)).AsString         := PTMQMCR(m_Cap_Res_Changed_list[I]).CR_COMMENTS;
        ParamByName(CreateFld(tbInfo.pfx, fli_schedStart)).AsDateTime    := PTMQMCR(m_Cap_Res_Changed_list[I]).CR_SCHEDULE_START;
        ParamByName(CreateFld(tbInfo.pfx, fli_schedEnd)).AsDateTime      := PTMQMCR(m_Cap_Res_Changed_list[I]).CR_SCHEDULE_END;
        ParamByName(CreateFld(tbInfo.pfx, fli_usrCr)).AsString           := PTMQMCR(m_Cap_Res_Changed_list[I]).CR_USR_CG;
        ParamByName(CreateFld(tbInfo.pfx, fli_usrTmCr)).AsDateTime       := PTMQMCR(m_Cap_Res_Changed_list[I]).CR_USR_TM_CG;
        ExecSQL;
        Application.ProcessMessages;     }
      end;
    end;
  end;

  for I := 0 to m_Cap_Res_Changed_list.Count - 1 do
  begin
    if (PTMQMCR(m_Cap_Res_Changed_list[I]).CR_CAP_RES_TYPE_CHANGE = UpdateCap) then
    begin
      with qry do
      begin
        SQL.Clear;
        SQL.Add(' update ' + tbInfo.GetTableName + ' set ');
      //  SQL.Add(CreateFld(tbInfo.pfx, fli_IDENTIFIER)                + '=');
      //  SQL.Add(':' + CreateFld(tbInfo.pfx, fli_IDENTIFIER)          + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_rsc)                       + '=');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_rsc)                 + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_subLinRscId)               + '=');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_subLinRscId)         + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_WCProcess)                 + '=');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_WCProcess)           + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_CapacyResTyp)              + '=');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_CapacyResTyp)        + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_Capacity_To_Job)           + '=');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Capacity_To_Job)     + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_Comment)                   + '=');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Comment)             + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_schedStart)                + '=');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_schedStart)          + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_schedEnd)                  + '=');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_schedEnd)            + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_usrCr)                     + '=');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_usrCr)               + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_usrTmCr)                   + '=');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_usrTmCr));
        SQL.Add(' where ');
        SQL.Add(CreateFld(tbInfo.pfx, fli_CapacyResrv)              + '=');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_CapacyResrv));
        SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
     //   Prepare;
        Application.ProcessMessages;
    //  end;
      end;

      if PTMQMCR(m_Cap_Res_Changed_list[I]).CR_CAP_RES_TYPE_CHANGE = UpdateCap then
      begin
        with qry do
        begin
         // ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsInteger    := StrToInt(IniAppGlobals.Identifier);
          ParamByName(CreateFld(tbInfo.pfx, fli_CapacyResrv)).AsInteger   := PTMQMCR(m_Cap_Res_Changed_list[I]).CR_CAPACY_RESRV;
          ParamByName(CreateFld(tbInfo.pfx, fli_Rsc)).AsString   := PTMQMCR(m_Cap_Res_Changed_list[I]).CR_RSC;
          ParamByName(CreateFld(tbInfo.pfx, fli_subLinRscId)).AsInteger    := PTMQMCR(m_Cap_Res_Changed_list[I]).CR_SUB_LINE_RES;
          ParamByName(CreateFld(tbInfo.pfx, fli_WCProcess)).AsString       := PTMQMCR(m_Cap_Res_Changed_list[I]).CR_WC_PROCESS;
          ParamByName(CreateFld(tbInfo.pfx, fli_CapacyResTyp)).AsString    := PTMQMCR(m_Cap_Res_Changed_list[I]).CR_CAPRES_TYPE;
          ParamByName(CreateFld(tbInfo.pfx, fli_Capacity_To_Job)).AsString := PTMQMCR(m_Cap_Res_Changed_list[I]).CR_CAPACITY_To_JOB;
          ParamByName(CreateFld(tbInfo.pfx, fli_Comment)).AsString         := PTMQMCR(m_Cap_Res_Changed_list[I]).CR_COMMENTS;
          ParamByName(CreateFld(tbInfo.pfx, fli_schedStart)).AsDateTime    := PTMQMCR(m_Cap_Res_Changed_list[I]).CR_SCHEDULE_START;
          ParamByName(CreateFld(tbInfo.pfx, fli_schedEnd)).AsDateTime      := PTMQMCR(m_Cap_Res_Changed_list[I]).CR_SCHEDULE_END;
          ParamByName(CreateFld(tbInfo.pfx, fli_usrCr)).AsString           := PTMQMCR(m_Cap_Res_Changed_list[I]).CR_USR_CG;
          ParamByName(CreateFld(tbInfo.pfx, fli_usrTmCr)).AsDateTime       := PTMQMCR(m_Cap_Res_Changed_list[I]).CR_USR_TM_CG;
          ExecSQL;
          Application.ProcessMessages;
        end;
      end;
    end;
  end;

  for I := 0 to m_Cap_Res_Changed_list.Count - 1 do
  begin
    if (PTMQMCR(m_Cap_Res_Changed_list[I]).CR_CAP_RES_TYPE_CHANGE = DeleteCap) then
    begin
      with qry do
      begin
        SQL.Clear;
        SQL.Add('Delete from ' + tbInfo.GetTableName);
        SQL.Add(' where ');
        SQL.Add(CreateFld(tbInfo.pfx, fli_CapacyResrv)       + ' = ');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_CapacyResrv));
        SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
     //   Prepare;
      end;
      Qry.ParamByName(CreateFld(tbInfo.pfx, fli_CapacyResrv)).AsInteger := PTMQMCR(m_Cap_Res_Changed_list[I]).CR_CAPACY_RESRV;
      Qry.ParamByName(CreateFld(tbInfo.pfx, fli_CapacyResrvStatus)).AsString := '2';  // delete
      Qry.ExecSQL;
    end;
  end;

  Qry.close;
  Qry.free;
end;

//----------------------------------------------------------------------------//

procedure TProdCont.InsertChangeCapResToTable(var srvTrs: TMqmTransaction);
var
  tbInfo: ^TTblInfo;
  Qry : TMqmQuery;
  I : Integer;
begin
  tbInfo := @tblInfo[tbl_capRes];
  Qry := ThreadCreateQuery(Main_DB);
  Qry.Transaction := srvTrs;

  for I := 0 to m_Cap_Res_Changed_list.Count - 1 do
  begin
    if (PTCapRes(m_Cap_Res_Changed_list[I]).CR_CAP_RES_TYPE_CHANGE = NewCap) then   ///NEW RECORD
    begin
      with Qry do
      begin
        SQL.Clear;
        SQL.Add('insert into ' + tbInfo.GetTableName       + '(');
        SQL.Add(CreateFld(tbInfo.pfx, fli_IDENTIFIER)      + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_CapacyResrv)     + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_rsc)             + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_subLinRscId)     + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_WCProcess)       + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_CapacyResTyp)    + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_Capacity_To_Job) + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_Comment)         + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_schedStart)      + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_schedEnd)        + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_usrCr)           + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_usrTmCr));
        SQL.Add(') values (');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_IDENTIFIER)      + ',');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_CapacyResrv)     + ',');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_rsc)             + ',');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_subLinRscId)     + ',');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_WCProcess)       + ',');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_CapacyResTyp)    + ',');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Capacity_To_Job) + ',');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Comment)         + ',');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_schedStart)      + ',');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_schedEnd)        + ',');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_usrCr)           + ',');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_usrTmCr));
        SQL.Add(')');
      //  Prepare;

        ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsInteger    := StrToInt(IniAppGlobals.Identifier);
        ParamByName(CreateFld(tbInfo.pfx, fli_CapacyResrv)).AsInteger    := PTCapRes(m_Cap_Res_Changed_list[I]).CR_CAPACY_RESRV;
        ParamByName(CreateFld(tbInfo.pfx, fli_Rsc)).AsString             := PTCapRes(m_Cap_Res_Changed_list[I]).CR_RSC;
        ParamByName(CreateFld(tbInfo.pfx, fli_subLinRscId)).AsInteger    := PTCapRes(m_Cap_Res_Changed_list[I]).CR_SUB_LINE_RES;
        ParamByName(CreateFld(tbInfo.pfx, fli_WCProcess)).AsString       := PTCapRes(m_Cap_Res_Changed_list[I]).CR_WC_PROCESS;
        ParamByName(CreateFld(tbInfo.pfx, fli_CapacyResTyp)).AsString    := PTCapRes(m_Cap_Res_Changed_list[I]).CR_CAPRES_TYPE;
        ParamByName(CreateFld(tbInfo.pfx, fli_Capacity_To_Job)).AsString := PTCapRes(m_Cap_Res_Changed_list[I]).CR_CAPACITY_To_JOB;
        ParamByName(CreateFld(tbInfo.pfx, fli_Comment)).AsString         := PTCapRes(m_Cap_Res_Changed_list[I]).CR_COMMENTS;
        ParamByName(CreateFld(tbInfo.pfx, fli_schedStart)).AsDateTime    := PTCapRes(m_Cap_Res_Changed_list[I]).CR_SCHEDULE_START;
        ParamByName(CreateFld(tbInfo.pfx, fli_schedEnd)).AsDateTime      := PTCapRes(m_Cap_Res_Changed_list[I]).CR_SCHEDULE_END;
        ParamByName(CreateFld(tbInfo.pfx, fli_usrCr)).AsString           := PTCapRes(m_Cap_Res_Changed_list[I]).CR_USR_CG;
        ParamByName(CreateFld(tbInfo.pfx, fli_usrTmCr)).AsDateTime       := PTCapRes(m_Cap_Res_Changed_list[I]).CR_USR_TM_CG;
        try
          ExecSQL;
        except
            {on E: Exception do
            begin
              E.Message := E.Message + (' Cap res number : ' + IntToStr((PTMQMCR(m_Cap_Res_Changed_list[I]).CR_CAPACY_RESRV * (-1))) );
              raise;
            end;      }
        end;

        Application.ProcessMessages;

      end;
    end;

    if (PTCapRes(m_Cap_Res_Changed_list[I]).CR_CAP_RES_TYPE_CHANGE = UpdateCap) then  //UPDATE
    begin
      with qry do
      begin
        SQL.Clear;
        SQL.Add(' update ' + tbInfo.GetTableName + ' set ');
//        SQL.Add(CreateFld(tbInfo.pfx, fli_IDENTIFIER)                + '=');
//        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_IDENTIFIER)          + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_rsc)                       + '=');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_rsc)                 + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_subLinRscId)               + '=');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_subLinRscId)         + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_WCProcess)                 + '=');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_WCProcess)           + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_CapacyResTyp)              + '=');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_CapacyResTyp)        + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_Capacity_To_Job)           + '=');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Capacity_To_Job)     + ',');
//        SQL.Add(CreateFld(tbInfo.pfx, fli_Comment)                   + '=');
//        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Comment)             + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_schedStart)                + '=');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_schedStart)          + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_schedEnd)                  + '=');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_schedEnd)            + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_usrCr)                     + '=');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_usrCr)               + ',');
        SQL.Add(CreateFld(tbInfo.pfx, fli_usrTmCr)                   + '=');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_usrTmCr));
        SQL.Add(' where ');
        SQL.Add(CreateFld(tbInfo.pfx, fli_CapacyResrv)               + '=');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_CapacyResrv)         + ' and ');
        SQL.Add(CreateFld(tbInfo.pfx, fli_Comment)                   + '=');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Comment));

        SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));

     //   Prepare;
        Application.ProcessMessages;
      //  end;
      end;

      if PTCapRes(m_Cap_Res_Changed_list[I]).CR_CAP_RES_TYPE_CHANGE = UpdateCap then
      begin
        with qry do
        begin
        //  ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsInteger    := StrToInt(IniAppGlobals.Identifier);
          ParamByName(CreateFld(tbInfo.pfx, fli_CapacyResrv)).AsInteger   := PTCapRes(m_Cap_Res_Changed_list[I]).CR_CAPACY_RESRV;
          ParamByName(CreateFld(tbInfo.pfx, fli_Rsc)).AsString   := PTCapRes(m_Cap_Res_Changed_list[I]).CR_RSC;
          ParamByName(CreateFld(tbInfo.pfx, fli_subLinRscId)).AsInteger    := PTCapRes(m_Cap_Res_Changed_list[I]).CR_SUB_LINE_RES;
          ParamByName(CreateFld(tbInfo.pfx, fli_WCProcess)).AsString       := PTCapRes(m_Cap_Res_Changed_list[I]).CR_WC_PROCESS;
          ParamByName(CreateFld(tbInfo.pfx, fli_CapacyResTyp)).AsString    := PTCapRes(m_Cap_Res_Changed_list[I]).CR_CAPRES_TYPE;
          ParamByName(CreateFld(tbInfo.pfx, fli_Capacity_To_Job)).AsString := PTCapRes(m_Cap_Res_Changed_list[I]).CR_CAPACITY_To_JOB;
          ParamByName(CreateFld(tbInfo.pfx, fli_Comment)).AsString         := PTCapRes(m_Cap_Res_Changed_list[I]).CR_COMMENTS;
          ParamByName(CreateFld(tbInfo.pfx, fli_schedStart)).AsDateTime    := PTCapRes(m_Cap_Res_Changed_list[I]).CR_SCHEDULE_START;
          ParamByName(CreateFld(tbInfo.pfx, fli_schedEnd)).AsDateTime      := PTCapRes(m_Cap_Res_Changed_list[I]).CR_SCHEDULE_END;
          ParamByName(CreateFld(tbInfo.pfx, fli_usrCr)).AsString           := PTCapRes(m_Cap_Res_Changed_list[I]).CR_USR_CG;
          ParamByName(CreateFld(tbInfo.pfx, fli_usrTmCr)).AsDateTime       := PTCapRes(m_Cap_Res_Changed_list[I]).CR_USR_TM_CG;
          ExecSQL;
          Application.ProcessMessages;
        end;
      end;
    end;

    if (PTCapRes(m_Cap_Res_Changed_list[I]).CR_CAP_RES_TYPE_CHANGE = DeleteCap) then    //DELETE
    begin
      with qry do
      begin
        SQL.Clear;
        SQL.Add(' update ' + tbInfo.GetTableName + ' set ');
        SQL.Add(CreateFld(tbInfo.pfx, fli_CapacyResrvStatus)         + '=');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_CapacyResrvStatus));
        SQL.Add(' where ');
        SQL.Add(CreateFld(tbInfo.pfx, fli_CapacyResrv)       + ' = ');
        SQL.Add(':' + CreateFld(tbInfo.pfx, fli_CapacyResrv));
        SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
     //   Prepare;
      end;
      Qry.ParamByName(CreateFld(tbInfo.pfx, fli_CapacyResrv)).AsInteger   := PTCapRes(m_Cap_Res_Changed_list[I]).CR_CAPACY_RESRV;
      Qry.ParamByName(CreateFld(tbInfo.pfx, fli_CapacyResrvStatus)).AsString := '2';  // delete
      Qry.ExecSQL;
    end;

  end;

  Qry.close;
  Qry.free;
end;

//----------------------------------------------------------------------------//

procedure TProdCont.InsertResChangeCapResToTabl(var srvTrs: TMqmTransaction);
var
  tbInfo: ^TTblInfo;
  Qry : TMqmQuery;
  I : Integer;
  DndArchiveHostName : TDndArchiveName;
begin
  DndArchiveHostName := GetDndArchiveHostName;
  tbInfo := @tblInfo[tbl_CapRsc_Change];
  Qry := ThreadCreateQuery(Main_DB);
  Qry.Transaction := SrvTrs;
  for I := 0 to m_Cap_Res_Changed_list.Count - 1 do
  begin
    with Qry do
    begin
      SQL.Clear;
      SQL.Add('insert into ' + tbInfo.GetTableName         + '(');
      SQL.Add(CreateFld(tbInfo.pfx, fli_IDENTIFIER)       + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_CapacyResrv)       + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_updCode)           + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_ChangeType));
      SQL.Add(') values (');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_IDENTIFIER) + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_CapacyResrv) + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_updCode)     + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_ChangeType));
      SQL.Add(')');
    //  Prepare;
      ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsInteger := StrToInt(IniAppGlobals.Identifier);
      if DndArchiveHostName <> TD_AS_400 then
      begin
        ParamByName(CreateFld(tbInfo.pfx, fli_CapacyResrv)).AsInteger    := PTCapRes(m_Cap_Res_Changed_list[I]).CR_CAPACY_RESRV;
        case (PTCapRes(m_Cap_Res_Changed_list[I]).CR_CAP_RES_TYPE_CHANGE) of
          NewCap :  ParamByName(CreateFld(tbInfo.pfx, fli_ChangeType)).AsString := '1';
          DeleteCap : ParamByName(CreateFld(tbInfo.pfx, fli_ChangeType)).AsString := '2';
          UpdateCap : ParamByName(CreateFld(tbInfo.pfx, fli_ChangeType)).AsString := '3';
        end
      end
      else
      begin
        ParamByName(CreateFld(tbInfo.pfx, fli_CapacyResrv)).AsInteger    := PTMQMCR(m_Cap_Res_Changed_list[I]).CR_CAPACY_RESRV;
        case (PTMQMCR(m_Cap_Res_Changed_list[I]).CR_CAP_RES_TYPE_CHANGE) of
          NewCap :  ParamByName(CreateFld(tbInfo.pfx, fli_ChangeType)).AsString := '1';
          DeleteCap : ParamByName(CreateFld(tbInfo.pfx, fli_ChangeType)).AsString := '2';
          UpdateCap : ParamByName(CreateFld(tbInfo.pfx, fli_ChangeType)).AsString := '3';
        end;
      end;

      ParamByName(CreateFld(tbInfo.pfx, fli_updCode)).AsInteger := m_Updated_CapRes_Number;
      inc(m_Updated_CapRes_Number);
      ExecSQL;
      Application.ProcessMessages;
    end;
  end;

  tbInfo := @tblInfo[tbl_Rsc_Change];

  for I := 0 to m_Rsc_Change_List.Count - 1 do
  begin
    with Qry do
    begin
      SQL.Clear;
      SQL.Add('insert into ' + tbInfo.GetTableName             + '(');
      SQL.Add(CreateFld(tbInfo.pfx, fli_rsc)             + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_updCode)+',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_IDENTIFIER));
      SQL.Add(') values (');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_rsc)       + ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_updCode)+ ',');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_IDENTIFIER));
      SQL.Add(')');
    //  Prepare;

      ParamByName(CreateFld(tbInfo.pfx, fli_rsc)).AsString        := PTCapRes(m_Cap_Res_Changed_list[I]).CR_RSC;
      ParamByName(CreateFld(tbInfo.pfx, fli_updCode)).AsInteger   := m_Updated_Rsc_Change_Number;
      ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsInteger   := StrToInt(IniAppGlobals.Identifier);
      try
        ExecSQL;
        inc(m_Updated_Rsc_Change_Number);
      except
      end;
      Application.ProcessMessages;
    end;
  end;
  Qry.Close;
  Qry.Free;
end;

//----------------------------------------------------------------------------//

procedure TProdCont.InsertChangeStepReqToTable(Req : string; StepId : Integer; StepChange : PStepChange; var srvTrs: TMqmTransaction);
var
  tbInfo: ^TTblInfo;
  QryProdReq : TMqmQuery;
begin
  QryProdReq := ThreadCreateQuery(Main_DB);
  QryProdReq.Transaction := srvTrs;
  tbInfo := @tblInfo[tbl_Req_Change];
  with QryProdReq do
  begin
    SQL.Clear;
    SQL.Add('insert into ' + tbInfo.GetTableName        + '(');
    SQL.Add(CreateFld(tbInfo.pfx, fli_IDENTIFIER)       + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_preqNo)           + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_pstepId)          + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_updCode)          + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_ChangeType)       + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_ReactivateReq));
    SQL.Add(') values (');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_IDENTIFIER) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_preqNo)     + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_pstepId)    + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_updCode)    + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_ChangeType) + ',');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_ReactivateReq));
    SQL.Add(')');
   // Prepare;

    ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).Value := IniAppGlobals.Identifier;
    ParamByName(CreateFld(tbInfo.pfx, fli_preqNo)).Value := Req;
    ParamByName(CreateFld(tbInfo.pfx, fli_pstepId)).Value := StepId;
    ParamByName(CreateFld(tbInfo.pfx, fli_updCode)).Value := m_UpdatedGenNumber;
    ParamByName(CreateFld(tbInfo.pfx, fli_ChangeType)).Value := IntToStr((Ord(StepChange.ChangedType) + 1));
    ParamByName(CreateFld(tbInfo.pfx, fli_ReactivateReq)).Value := '';
    ExecSQL;
    Application.ProcessMessages;
  end;
  QryProdReq.free;
end;

//----------------------------------------------------------------------------//

initialization
  m_ProdCont := nil;

finalization
  if Assigned(m_ProdCont) then
    m_ProdCont.free;

end.
