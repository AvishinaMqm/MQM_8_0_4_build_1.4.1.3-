unit UMProductionStruct;

interface
uses
  System.Generics.Collections,
  classes, sysutils,
  UMTblDesc,
  gnugettext,
  DMsrvPc,
  math, UMCommon, Db, Controls, DateUtils, Variants,
  ADODB;

type

  TReqChange = (No, NewReq, Historical, DelReq, HeadrFieldsChange, HeadrPropChange,
                HeaderCosmeticChanged, StepChangeOnly);

  TStepChange = (NoChange ,NewStep ,DelStep , StepFieldChange, StepPropChange,
                StepCosmeticChanged, OnlyProgres_TimeCng);

  TPROJECT_NUMBER = Record
    CODE: String;
    NUMBER : string;
  end;
  PTPROJECT_NUMBER = ^TPROJECT_NUMBER;

  TPRODUCTIONDEMANDTEMPLATES = Record
    CODE: String;
    SHORTDESCRIPTION: String;
    HANDLEDBYMQM: String;
    HANDLEDBYMCM: String;
 //   DAYSTOKEEPHISTORY: String;
 //   DEMANDKEYLINKADDITIONALDATA: String;
    SERVEDCODETABLENAME : string;
    SERVEDCODECOLUMNAME : string;
    SERVINGCODETABLENAME : string;
    SERVINGCODECOLUMNAME : string;
    SERVINGCODEDEFNITION : string;
    SERVEDCODEDEFNITION  : string;
    ITEMTYPESERVED       : string;
    TNAORIGIN            : string;
  end;
  PPRODUCTIONDEMANDTEMPLATES = ^TPRODUCTIONDEMANDTEMPLATES;

  TWORKCENTERS = Record
    WC_WKCNTER: String;
    WC_HANDLEDBYMQM: String;
    WC_HANDLEDBYMCM: String;
    WC_HANDLE_WARP: String;
    WC_HANDLE_LEARNINGCURVE : string;
    WC_AD_LEARNINGCURVE_CODE : string;
    WC_OVERLAP_WITH_OTHER_STEPS : string;
    WC_AD_OVERLAP_WITH_OTHER_STEPS : string;
    WC_HANDLEGERERICPLAN : boolean;
    WC_RES_NUM_PLN : integer;
    Process_List: TList;
    WC_Batch_UoM : TStringList;
    WC_APPROVALDATE_BY_TNA : boolean;
  end;
  PWORKCENTERS = ^TWORKCENTERS;

  TPROCESSES = Record
    WP_WKCT_PROC: String;
    WP_ISNOWPRDORD_MQMGROUP: String;
    WP_CANBEGROUPEDINMQM: String;
    WP_DEFAULTFORALLOWEDSPLIT: String;
    WP_ADFORALLOWEDSPLIT: String;
    WP_ADFORSPLITFAMILYCODE: String;
    WP_TYPE: String;
    WP_BATCHSTANDARDTIME : string;
    Properties_List: TList;
    Alternatives_List: TStringList;
    OperAttributes_List: TList;
    ProductionTimesLevel_List: TList;
    CONSIDER_QUEUE_TIME_AS_LEADTIME_To_PREVIOUS_STEP  : string;
    CONSIDER_POST_PROCESS_TIME_LEADTIME_NEXT_STEP  : string;

   // Penalties_List: TList;
  end;
  PPROCESSES = ^TPROCESSES;

  TPROPERTIES = Record
    RP_RES_CATEGORY: String;
    RP_RSC_CODE: String;
    RP_PROPERTY: String;
    RP_PROPTY_VALUE: String;
    RP_ADD_RSC_OCC: String;
    RP_VAL_ADDED: String;
    RP_VAL_TAKE_FOR_GROUP: String;
    RP_DFT_CASE_RSC_OCC_RULS: String;
    RP_DFT_CASE_OCC_OCC_RULS: String;
    RP_DFT_SAME_GRP_OCC_OCC_RULS: String;
  end;
  PPROPERTIES = ^TPROPERTIES;

  TPROPERTY_BUILD_FROM_OTHER = Record
    PROPERTYCODE : string;
    PROPCODE1: String;
    PROPCODE2: String;
    PROPCODE3: String;
    PROPCODE4: String;
    PROPCODE5: String;
    TYPE1 : string;
    TYPE2 : string;
    TYPE3 : string;
    TYPE4 : string;
    TYPE5 : string;
    LEN1  : integer;
    LEN2  : integer;
    LEN3  : integer;
    LEN4  : integer;
    LEN5  : integer;
	Separator : String;
    IsPropLinkerToServingGroup : boolean;
  end;
  PTPROPERTY_BUILD_FROM_OTHER = ^TPROPERTY_BUILD_FROM_OTHER;

  TOPERATTRIBUTES = Record
    WORKCENTERCODE: String;
    OPERATIONCODE: String;
    CODE: String;
    SHORTDESCRIPTION: String;
    STANDARDSTEPQUANTITY: String;
    STANDARDSTEPQTYUOMCODE: String;
    STEPEFFICIENCYAPPLY: String;
    STEPEFFICIENCY: String;
    TIMETYPE1CODE: String;
    TIME1: String;
    TIMEUNIT1: String;
    TIMEREFQTY1: String;
    TIMEREFUOM1CODE: String;
    TIMETYPE2CODE: String;
    TIME2: String;
    TIMEUNIT2: String;
    TIMEREFQTY2: String;
    TIMEREFUOM2CODE: String;
    TIMETYPE3CODE: String;
    TIME3: String;
    TIMEUNIT3: String;
    TIMEREFQTY3: String;
    TIMEREFUOM3CODE: String;
    TIMETYPE4CODE: String;
    TIME4: String;
    TIMEUNIT4: String;
    TIMEREFQTY4: String;
    TIMEREFUOM4CODE: String;
    TIMETYPE5CODE: String;
    TIME5: String;
    TIMEUNIT5: String;
    TIMEREFQTY5: String;
    TIMEREFUOM5CODE: String;
    REPETITIONNUMBER : double;
  end;
  POPERATTRIBUTES = ^TOPERATTRIBUTES;

  TPRODUCTIONTIMESLEVELS = Record
    PRODUCT_TYPE: String;
    HANDLE_TIMES_BY: String;
    TABLENAME1: String;
    COLUMNNAME1: String;
    TABLENAME2: String;
    COLUMNNAME2: String;
    TABLENAME3: String;
    COLUMNNAME3: String;
    TABLENAME4: String;
    COLUMNNAME4: String;
    TABLENAME5: String;
    COLUMNNAME5: String;
    TABLENAME6: String;
    COLUMNNAME6: String;
    TABLENAME7: String;
    COLUMNNAME7: String;
    TABLENAME8: String;
    COLUMNNAME8: String;
    TABLENAME9: String;
    COLUMNNAME9: String;
    TABLENAME10: String;
    COLUMNNAME10: String;
    ProductionTimes_List: TList;
  end;
  PPRODUCTIONTIMESLEVELS = ^TPRODUCTIONTIMESLEVELS;

  TPRODUCTIONTIMES = Record
    TABLENAME1_COLUMNNAME1_VALUE: String;
    TABLENAME1_COLUMNNAME2_VALUE: String;
    TABLENAME1_COLUMNNAME3_VALUE: String;
    TABLENAME1_COLUMNNAME4_VALUE: String;
    TABLENAME1_COLUMNNAME5_VALUE: String;
    TABlENAME1_COLUMNNAME6_VALUE: String;
    TABLENAME1_COLUMNNAME7_VALUE: String;
    TABLENAME1_COLUMNNAME8_VALUE: String;
    TABLENAME1_COLUMNNAME9_VALUE: String;
    TABLENAME1_COLUMNNAME10_VALUE: String;
    RESOURCE_CATEGORY: String;
    RESOURCE: String;
    SETUP_TIME: String;
    BATCH_TIME: String;
    CONTINUOUS_TIME: String;
    CONTINUOUS_OPERATION_UM: String;
    CONSIDER_STEP_EFFICIENCY: String;
    CODE: String;
    SETUP_TIME_MULTIPLIER: String;
    OPERATION_TIME_MULTIPLIER: String;
    StrConcatination : string;
  end;
  PPRODUCTIONTIMES = ^TPRODUCTIONTIMES;

  TUserGenericGroupType = Record
    ITEMTYPECODE : string;
    POSITION     : integer;
    GROUPTYPECODE : string;
  end;
  PTUserGenericGroupType = ^TUserGenericGroupType;

  TUserGenericGroupAttributes = Record
    USERGENERICGROUPTYPECODE : string;
    CODE : string;
    ABSUNIQUEID : string;
    LONGDESCRIPTION, SHORTDESCRIPTION, SEARCHDESCRIPTION : String;
  end;
  PTUserGenericGroupAttributes = ^TUserGenericGroupAttributes;

  TColorType = Record
    ITEMTYPECODE : string;
    POSITION     : integer;
    GROUPTYPECODE : string
  end;
  PTColorType = ^TColorType;

  TColorUNIQUEID = Record
    COLORTYPECODE : string;
    CODE : string;
    ABSUNIQUEID : string;
  end;
  PTColorUNIQUEID = ^TColorUNIQUEID;

  TADDITIONALDATA_HEADERS = Record
    ABSUNIQUEID: String;
    ABSUNIQUEIDINT: Int64;
    productADList: TList;
    fullItemKeyDecoderADList: TList;
    productionDemandADList: TList;
    productionDemandStepADList: TList;
    RecipeADList: TList;
    DesignADList: TList;
    SalesOrderADList: TList;
    SalesOrderLineADList: TList;
    SalesOrderDeliveryADList: TList;
    ProjectADList: TList;
    UserGenericGroupADList: TList;
    ColorADList: TList;
  end;
  PADDITIONALDATA_HEADERS = ^TADDITIONALDATA_HEADERS;

  TADDITIONALDATA_DETAILS = Record
    FIELDNAME: String;
    VALUE: String;
    DataType : Integer;
  end;
  PADDITIONALDATA_DETAILS = ^TADDITIONALDATA_DETAILS;

  TADDITIONALDATA_WITH_RELATIONS = Record
    RELATEDCLASSENTITYNAME: String;
    columnNameStringList: TStringList;
  end;
  PADDITIONALDATA_WITH_RELATIONS = ^TADDITIONALDATA_WITH_RELATIONS;

  TITEMTYPES = Record
    CODE: String;
    LASTSUBCODENR: String;
    SUBCODELENGTHS: TStringList;
  end;
  PITEMTYPES = ^TITEMTYPES;

  TROUTING_STEP_TIME_TYPES = Record
    RSTT_CODE : String;
    RSTT_SHORTDESCRIPTION : String;
    RSTT_APPLY : string;
    RSTT_TYPE : String;
    RSTT_APPLYTYPECODE : String;
    RSTT_EFFICIENCYSTEPUSED : string;
    RSTT_REPETITIONSTEPUSED : string;
    RSTT_PRINTINGSETUPTIMETYPE : string;
  End;
  PROUTING_STEP_TIME_TYPES = ^TROUTING_STEP_TIME_TYPES;

{  TNOTE_HEADERS = Record
    FATHERID: String;
    noteList: TList;
  end;
  PNOTE_HEADERS = ^TNOTE_HEADERS; }

  ItemWarehouseLinkRec = record
    ProjectControlled : boolean;
    StatisticalGroupControlled : boolean;
    CustomerControlled : boolean;
    SupplierControlled : boolean;
    LogicalWarehouseCode : string;
  end;
  PItemWarehouseLinkRec = ^ItemWarehouseLinkRec;

  TITEMS = record
    ABSUNIQUEID : string;
    ABSUNIQUEIDINT : Int64;
    ABSUNIQUEID_P : string;
    ITEMTYPEAFICODE : string;
    SECONDARYUNSTEADYCVSFACTOR : string;
    SEARCHDESCRIPTION : string;
         SEARCHDESCRIPTION_P : string;
    SEARCHDESCRIPTION_T : string;
    ITEMTYPECODE_T : string;
    SUBCODE01 : string;
    SUBCODE02 : string;
    SUBCODE03 : string;
    SUBCODE04 : string;
    SUBCODE05 : string;
    SUBCODE06 : string;
    SUBCODE07 : string;
    SUBCODE08 : string;
    SUBCODE09 : string;
    SUBCODE10 : string;
    ProductColumnNames : TStringList;
    ProductColumnValue : TStringList;
    ProductColumn_Created : boolean;
    ProductSpecializedGreigeColumnNames : TStringList;
    ProductSpecializedGreigeColumnValue : TStringList;
    ProductSpecializedGreigeColumn_created : boolean;
    ProductSpecializedSizeColumnNames : TStringList;
    ProductSpecializedSizeColumnValue : TStringList;
    ProductSpecializedSizeColumn_created : boolean;
    ProductSpecializedYarnColumnNames : TStringList;
    ProductSpecializedYarnColumnValue : TStringList;
    ProductSpecializedYarnColumn_created : boolean;
    FullItemKeyDecoderColumnNames : TStringList;
    FullItemKeyDecoderColumnValue : TStringList;
    FullItemKeyDecoderColumn_created : boolean;
    ProjectControlled, StatisticalGroupControlled, CustomerControlled, SupplierControlled : boolean;
    PURCHASELEADTIME  : Integer;
    ItemWarehouseLink : TList;
    MAT_SCHEDULE_Type_Warp : string;
    MAT_STANDARD_SPEED_Warp : double;
    MAT_STANDARD_SETMIN_Warp : double;
  end;
  PTITEMS = ^TITEMS;

  RGeneric = record
    Entity : String;
    NumberOfKeys : integer;
    Key1, Key2, Key3, Key4, Key5, Key6 : Variant;
    ABSUniqueId : String;
    ColumnNames : TStringList;
    ColumnValue : TStringList;
  end;
  PRGeneric = ^RGeneric;

  // new records to hold the fields from the sql except the ABSUniqueId ...

  T_TNA_FIELDS = record
    HEADERCODE : string;
    ACTIVITYCODE : string;
    SEQUENCENUMBER : Integer;
    STARTDATE : TDateTime;
    ENDDATE : TDateTime;
  end;
  PT_TNA_FIELDS = ^T_TNA_FIELDS;

  T_TNA = record
    Entity : String;
    ABSUniqueId : String;
    ApprovalDate : TDate;
    TNA_List : TList;
  end;
  PT_TNA = ^T_TNA;

  TNOTE_DETAILS = Record
    CODE: String;
    NOTE_VALUE: String;
  end;
  PNOTE_DETAILS = ^TNOTE_DETAILS;

  TPROPS = Record
    PY_PROPERTY: String;
    ITEMTYPE: String;
    PY_TYPE: String;
    PY_PROP_LEN: integer;
    PY_NUM_OF_DEC: integer;
    PY_RP_CONN_LEV_MAIN: String;
    PY_RP_ADD_WC_PROC: String;
    PY_DESIGNATEDPROPERTY: String;
    PY_PROP_VAL_TAKE_FOR_MERGE_DEMANDS : string;
    PY_IS_PROP_BUILD_FROM_PROP : boolean;
    PY_Planner_Prop : boolean;
    PY_MQM_Prop_Rtv_Value : boolean;
    PY_MCM_Prop_Rtv_Value : boolean;
    PY_IS_Date_Prop : boolean;
    PY_BUILD_PROPCODE1: String;
    PY_BUILD_PROPCODE2: String;
    PY_BUILD_PROPCODE3: String;
    PY_BUILD_PROPCODE4: String;
    PY_BUILD_PROPCODE5: String;

    TABLE_NAME: String;
    COLUMN_NAME: String;
    propRtvValueList: TList;
    HasAtLeastOneConnectionToResource : boolean;
    PropWorkCentersCode : TStringList;
    PropWorkCentersCodePerOperation : TStringList;
  End;
  PPROPS = ^TPROPS;

  TPROP_RTV_VALUES = Record
    ITEMTYPE: String;
	  TABLE_NAME: String;
    COLUMN_NAME: String;
    From_Position : integer;
    Length_From_Pos : integer;
   // DATEFORMAT : string;
  End;
  PPROP_RTV_VALUES = ^TPROP_RTV_VALUES;

  TMQMRes = Record
    RS_RSC_CODE : string;
    RS_WKCNTER : string;
    RS_STANDRD_BCH_SIZE : string;
    RS_MIN_BCH_SIZE : string;
    RS_MAX_BCH_SIZE : string;
    RS_BCH_UM : string;
  End;
  PMQMRes = ^TMQMRes;

  TPRODUCTS = Record
    PRODUCT_KEY: String;
    PAR_TYPE_PROD: String;
    PAR_PRODUCT_CODE: String;
    PAR_PRODUT_NATURE: String;
    PAR_STR_CONS_POINT: String;
    PAR_END_CONS_POINT: String;
    PAR_INFO_AREA: String;
    PAR_STDPURCORPRODTIME: String;
    PAR_MATERIAL_TOLLERANCE_CODE : string;
	  PAR_HOURSTODOWNFROMMACHINE : integer;
    PAR_SCHEDULE_Warp : string;
    PAR_STANDARD_SPEED_Warp : double;
    PAR_STANDARD_SETMIN_Warp : double;
  End;
  PPRODUCTS = ^TPRODUCTS;

  TMQMProductionColumnValues = Record
    columnValues: TStringList;
  End;
  PMQMProductionColumnValues = ^TMQMProductionColumnValues;

  TProductionOrderStepStruct = Record
    ProductionOrder : string;
    LineNumber      : Integer;
    GroupStepNumber : string;
    DemandCounterCode : string;
    DemandCode      : string;
    StepNumber      : string;
    FinalBasePrimaryQuantity : string;
    Percent : double;
    WorkCenter : string;
    Operation  : string;
    INITIALQUANTITY : string;
    FINALQUANTITY   : string;
    PRIMARYQTY      : string;
    SetUp           : string;
    Execution       : string;
    TotalSetUp      : double;
    TotalExecution  : double;
  End;
  PTProductionOrderStepStruct = ^TProductionOrderStepStruct;

  TMQMProductionReservation = Record
    Code : string;
    PRSV_ITEMTYPEAFICODE : string;
    PRSV_SUBCODE01 : string;
    PRSV_SUBCODE02 : string;
    PRSV_SUBCODE03 : string;
    PRSV_SUBCODE04 : string;
    PRSV_SUBCODE05 : string;
    PRSV_SUBCODE06 : string;
    PRSV_SUBCODE07 : string;
    PRSV_SUBCODE08 : string;
    PRSV_SUBCODE09 : string;
    PRSV_SUBCODE10 : string;
    PRSV_BASEPRIMARYQUANTITY : string;
    PRSV_USEDBASEPRIMARYQUANTITY : string;
    PRSV_PROGRESSSTATUS : string;
    STEP_NUMBER: String;
    PRSV_WAREHOUSECODE: String;
    PRSV_REFERENCEITEM: String;
    PRSV_ABSUNIQUEID  : string;
    PRSV_PROJECTCODE  : string;
    RSV_FIKD_IDENTIFIER : string;
    SEARCH_DESCRIPTION: String;
    ITEM_NATURE: String;
    IndexOfItem : integer;
    QUANTITY_ALLOC : double;
  End;
  PMQMProductionReservation = ^TMQMProductionReservation;

  TMQMProductionReservationLine = Record
    ORDERCOUNTERCODE : string;
    ORDERCODE        : string;
    RESERVATION_LINE  : integer;
    UserQuantity     : double;
    BaseQuantity     : double;
    AllocatedQuantity : double;
    PRODUCTIONORDERCODE : string;
    groupline : integer;
  End;
  PMQMProductionReservationLine = ^TMQMProductionReservationLine;

  TMQMAllocations = Record
    CODE : string;
    LINENUMBER        : integer;
    COMPONENTLINENUMBER  : integer;
  End;
  PMQMAllocations = ^TMQMAllocations;

  TMQMProductionOrderLines = Record
    PRODUCTIONORDERCODE : string;
    groupline        : integer;
    UserQuantity     : double;
    BaseQuantity     : double;
    AllocatedQuantity : double;
  End;
  PMQMProductionOrderLines = ^TMQMProductionOrderLines;

  TPRODUCT_UOM_CONVERSIONS = Record
    PRODUCT_CODE: String;
    measureConversionList: TList;
  End;
  PPRODUCT_UOM_CONVERSIONS = ^TPRODUCT_UOM_CONVERSIONS;

  TSTD_UNIT_CATEGORY_CONVERSIONS = Record
    STANDART_UNIT_CATEGORY_TYPE: String;
    measureConversionList: TList;
  End;
  PSTD_UNIT_CATEGORY_CONVERSIONS = ^TSTD_UNIT_CATEGORY_CONVERSIONS;

  TMEASURE_CONVERSIONS = Record
    UNITOFMEASURECODE: String;
    FACTOR: String;
  End;
  PMEASURE_CONVERSIONS = ^TMEASURE_CONVERSIONS;

  TOPERATIONS = Record
    CODE: String;
    LINKEDTIME1: String;
    LINKEDTIME2: String;
    LINKEDTIME3: String;
    LINKEDTIME4: String;
    LINKEDTIME5: String;
  End;
  POPERATIONS = ^TOPERATIONS;

  TARTICLE_TYPES = Record
    AT_ART_TYPE: String;
    AT_BALHANDLEDBYMQM: String;
    AT_ADDDATACOLUMNNAME: String;
    AT_PRODUCTTYPENATURE: String;
    AT_RESTIMEBEGINNING: String;
    AT_RESTIMEENDING: String;
    AT_MaterialTolleranceCode : string;
	AT_HoursToDownloadFromMachine : integer;
    AT_TABLE_NAME : string;
    AT_RELATED_COLUMN_NAME : string;	
    AT_IS_WARP_TYPE : boolean;
  End;
  PARTICLE_TYPES = ^TARTICLE_TYPES;

  TLOGICALWAREHOUSES = Record
    CODE: String;
    MQMGROUPCODE: String;
    ProjectControlled : boolean;
    StatisticalGroupControlled : boolean;
    CustomerControlled : boolean;
    SupplierControlled : boolean;
  End;
  PLOGICALWAREHOUSES = ^TLOGICALWAREHOUSES;

  TSALESORDERS = Record
    CODE: String;
    ORDERDATE: String;
    DESCRIPTION: String;
  End;
  PSALESORDERS = ^TSALESORDERS;

  TPURCHASEORDERS = Record
    CODE: String;
    ORDERDATE: String;
    DESCRIPTION: String;
  End;
  PPURCHASEORDERS = ^TPURCHASEORDERS;

  TPRODUCTIONPROGRESSTEMPLATES = Record
    CODE: String;
    HANDLEDBYMQM_OR_MCM : String;
    QUANTITYTYPE: String;
  end;
  PPRODUCTIONPROGRESSTEMPLATES = ^TPRODUCTIONPROGRESSTEMPLATES;

  TPROGRESSES = Record
    PROGRESSNUMBER: String;
    PROGRESSSTATUS: String;
    PRODUCTIONORDERCODE: String;
    DEMANDCOUNTERCODE: String;
    DEMANDCODE: String;
    STEPNUMBER: String;
    PROGRESSTYPE: String;
    PROGRESSSTARTQUEUEDATE: TDate;
    PROGRESSSTARTPREPROCESSDATE: TDate;
    PROGRESSSTARTPROCESSDATE: TDate;
    PROGRESSSTARTPOSTPROCESSDATE: TDate;
    PROGRESSPARTIALENDDATE: TDate;
    PROGRESSENDDATE: TDate;
    PROGRESSSTARTQUEUETIME: TTime;
    PROGRESSSTARTPREPROCESSTIME: TTime;
    PROGRESSSTARTPROCESSTIME: TTime;
    PROGRESSSTARTPOSTPROCESSTIME: TTime;
    PROGRESSPARTIALENDTIME: TTime;
    PROGRESSENDTIME: TTime;
    PRIMARYQTY: String;
    PRIMARYUOMCODE: String;
    MACHINECODE: String;
    WORKCENTERCODE: String;
    OPERATIONCODE: String;
    KEY_CODE: String;
    KEY_DATETIME: TDateTime;
    TEMPLATE_QUANTITYTYPE: String;
    STEPINITIALQUANTITY: String;
    STEPFINALQUANTITY: String;
    PRODUCTIONORDERFLAG: String;
  end;
  PPROGRESSES = ^TPROGRESSES;

  TPROD_SCHED_PROGRESSES = Record
    SP_PREQ_NO: String;
    SP_PSTEP_ID: String;
    SP_PSUBST_ID: String;
    SP_REPROC_NO: String;
    SP_LAST_PROG_TYPE: String;
    SP_RSC_CODE: String;
    SP_PROGRESED_GROUP: String;
    SP_PROGRSTART: TDateTime;
    SP_CURR_PRG_DATE: TDateTime;
    SP_PROGREND: TDateTime;
    SP_QTY: String;
    SP_REMAIN_TIME: String;
    PRODUCTIONORDERFLAG: String;
    PRODUCTIONORDERCODE: String;
    DEMANDCOUNTERCODE  : string;
  end;
  PPROD_SCHED_PROGRESSES = ^TPROD_SCHED_PROGRESSES;

  TSTEP_ID_PRODUCTIONDEMANDSANDORDERS = Record
    Code: String;
    workCenterList: TList;
    operationList: TList;
    stepIdList: TList;
  end;
  PSTEP_ID_PRODUCTIONDEMANDSANDORDERS = ^TSTEP_ID_PRODUCTIONDEMANDSANDORDERS;

  TSTEP_ID_STEPS = Record
    stepNumber: String;
    initialBasePrimaryQuantity: String;
    finalBasePrimaryQuantity: String;
  end;
  PSTEP_ID_STEPS = ^TSTEP_ID_STEPS;

  TSTEP_ID_WORKCENTERS = Record
    workCenterCode: String;
    operationList: TList;
  end;
  PSTEP_ID_WORKCENTERS = ^TSTEP_ID_WORKCENTERS;

  TSTEP_ID_WORKCENTERDATAS = Record
    operationCode: String;
    stepNumber: String;
    initialBasePrimaryQuantity: String;
    finalBasePrimaryQuantity: String;
  end;
  PSTEP_ID_WORKCENTERDATAS = ^TSTEP_ID_WORKCENTERDATAS;

  TSTEP_ID_OPERATIONS = Record
    operationCode: String;
    workCenterList: TList;
  end;
  PSTEP_ID_OPERATIONS = ^TSTEP_ID_OPERATIONS;

  TSTEP_ID_OPERATIONDATAS = Record
    workCenterCode: String;
    stepNumber: String;
    initialBasePrimaryQuantity: String;
    finalBasePrimaryQuantity: String;
  end;
  PSTEP_ID_OPERATIONDATAS = ^TSTEP_ID_OPERATIONDATAS;

  THANDLED_PRODUCTION_DEMANDS = Record
    Code: String;
    stepList: TStringList;
  end;
  PHANDLED_PRODUCTION_DEMANDS = ^THANDLED_PRODUCTION_DEMANDS;

  THANDLED_PRODUCTION_ORDERS = Record
    Code: String;
    stepList: TStringList;
    DemandCodeList: TStringList;
  end;
  PHANDLED_PRODUCTION_ORDERS = ^THANDLED_PRODUCTION_ORDERS;

  TPROG_MACHINES = Record
    MachineCode: String;
    demandAndOrderList: TList;
  end;
  PPROG_MACHINES = ^TPROG_MACHINES;

  TPROG_DEMANDANDORDERS = Record
    demandAndOrderCode: String;
    progList: TList;
  end;
  PPROG_DEMANDANDORDERS = ^TPROG_DEMANDANDORDERS;

  TPROGRESS_ITEMS = Record
    PROGRESSNUMBER: String;
    PROGRESSSTATUS: String;
    PRODUCTIONORDERCODE: String;
    DEMANDCOUNTERCODE: String;
    DEMANDCODE: String;
    STEPNUMBER: String;
    PROGRESSTYPE: String;
    PROGRESSSTARTQUEUEDATE: TDate;
    PROGRESSSTARTPREPROCESSDATE: TDate;
    PROGRESSSTARTPROCESSDATE: TDate;
    PROGRESSSTARTPOSTPROCESSDATE: TDate;
    PROGRESSPARTIALENDDATE: TDate;
    PROGRESSENDDATE: TDate;
    PROGRESSSTARTQUEUETIME: TTime;
    PROGRESSSTARTPREPROCESSTIME: TTime;
    PROGRESSSTARTPROCESSTIME: TTime;
    PROGRESSSTARTPOSTPROCESSTIME: TTime;
    PROGRESSPARTIALENDTIME: TTime;
    PROGRESSENDTIME: TTime;
    PRIMARYQTY: String;
    PRIMARYUOMCODE: String;
    MACHINECODE: String;
    WORKCENTERCODE: String;
    OPERATIONCODE: String;
    KEY_CODE: String;
    KEY_DATETIME: TDateTime;
    TEMPLATE_QUANTITYTYPE: String;
    STEPINITIALQUANTITY: String;
    STEPFINALQUANTITY: String;
    progressIndex: Integer;
    PRODUCTIONORDERFLAG: String;
  end;
  PPROGRESS_ITEMS = ^TPROGRESS_ITEMS;

  TITEMTYPETEMPLATES = Record
    ITEMTYPECODE: String;
    productionDemandTemplateList: TList;
  end;
  PITEMTYPETEMPLATES = ^TITEMTYPETEMPLATES;

  TITEMTYPEPRODUCTIONDEMANDTEMPLATES = Record
    PRODUCTIONDEMANDTEMPLATECODE: String;
    HOSTSPLITCONFIRMLEVEL: String;
    WORKCENTERFORSPLIT: String;
    OPERATIONFORSPLIT: String;
  end;
  PITEMTYPEPRODUCTIONDEMANDTEMPLATES = ^TITEMTYPEPRODUCTIONDEMANDTEMPLATES;

  TPRODUCTIONDEMANDCOUNTERS = Record
    CODE: String;
    FAMILYCODEENDPOSITION: String;
  end;
  PPRODUCTIONDEMANDCOUNTERS = ^TPRODUCTIONDEMANDCOUNTERS;

  TALT_WAREHOUSE_WKCS = Record
    WORKCENTER: String;
    NET_GROUP_CODE : string;
    ISSUE_ITEM_TYPE : string;
    ALTERN_WC : string;
    ALTERN_NET_GROUP_CODE : string;
    groupCodeList: TList;
  end;
  PALT_WAREHOUSE_WKCS = ^TALT_WAREHOUSE_WKCS;

  TALT_WAREHOUSE_WKC_GROUPS = Record
    NET_GROUP: String;
    itemTypeList: TList;
  end;
  PALT_WAREHOUSE_WKC_GROUPS = ^TALT_WAREHOUSE_WKC_GROUPS;

  TALT_WAREHOUSE_WKC_GROUP_ITEM_TYPES = Record
    ITEM_TYPE: String;
    alternativeList: TList;
  end;
  PALT_WAREHOUSE_WKC_GROUP_ITEM_TYPES = ^TALT_WAREHOUSE_WKC_GROUP_ITEM_TYPES;

  TALT_WAREHOUSES = Record
    ALT_WORKCENTER: String;
    ALT_NET_GROUP: String;
  end;
  PALT_WAREHOUSES = ^TALT_WAREHOUSES;

  TITEMTYPELOGICALWAREHOUSE_ITEMTYPES = Record
    ITEMTYPECODE: String;
    logicalWarehouseList: TList;
  end;
  PITEMTYPELOGICALWAREHOUSE_ITEMTYPES = ^TITEMTYPELOGICALWAREHOUSE_ITEMTYPES;

  TITEMTYPELOGICALWAREHOUSES = Record
    LOGICALWAREHOUSECODE: String;
    RESERVATIONTABLENAME: String;
    RESERVATIONCOLUMNNAME: String;
    DEMANDTABLENAME: String;
    DEMANDCOLUMNNAME: String;
    NET_GRP_LOT : string;
    Reservation_RELATED_COLUMN : string;
    Demand_RELATED_COLUMN : string;
  end;
  PITEMTYPELOGICALWAREHOUSES = ^TITEMTYPELOGICALWAREHOUSES;

  TPROD_REQ_VALUES = Record
    original_PreqNo: String;
    new_PreqNo: String;
  end;
  PPROD_REQ_VALUES = ^TPROD_REQ_VALUES;

  TPRODUCTION_ORDER_GRP_NOS = Record
    productionOrderCode: String;
    GroupStep : integer;
    productionOrderCodeGrpStep : string;
    groupNo: integer;
    ToBedelete : boolean;
  end;
  PPRODUCTION_ORDER_GRP_NOS = ^TPRODUCTION_ORDER_GRP_NOS;

  function CheckMerge(Var ProdReqStr : string ; CounterCode : string; productionDemandCounters : TList) : boolean;
  function FillProdListsStructure(LocalQry: TMqmQuery; HostQry : TMqmQuery; ArcQry :  TMqmQuery): boolean;
  procedure fillStructs(ArcQry :  TMqmQuery; handledWorkCentersList: TList; unhandledWorkCentersList: TList; OperAttributesList : TList; var AtLeast_1_Wc_HandledWarp : boolean; var AD_ProductionDemandStep_FieldsList : TStringList; var AD_Product_FieldsList : TStringList; var AD_ProductionDemand_FieldsList : TStringList);
  procedure fillProcessListOfWorkCenter(NEWWORKCENTER: PWORKCENTERS; OperAttributesList : TList; var AD_ProductionDemand_FieldsList : TStringlist);
  procedure fillPropertyListOfWorkCenterProcess(workCenterCode: String; NEWPROCESS: PPROCESSES);
  procedure fillAlternativeListOfWorkCenterProcess(workCenterCode: String; NEWPROCESS: PPROCESSES);
  procedure fillOperAttributeListOfWorkCenterProcess(OperAttributesList : TList; workCenterCode: String; NEWPROCESS: PPROCESSES);
  procedure fillProductionTimesLevelListOfWorkCenterProcess(workCenterCode: String; NEWPROCESS: PPROCESSES);
  procedure fillProductionTimesListOfProductionTimesLevel(workCenterCode: String; processCode: String; NEWPRODUCTIONTIMESLEVEL: PPRODUCTIONTIMESLEVELS);
  procedure fillUserGenericGroupTypeAttributes(HostQry: TMqmQuery; UserGenericGroupTypeAttributesList : TList; HandledUserGenericGroupTypesStr : string);
  procedure fillUserGenericGroupType(HostQry: TMqmQuery; UserGenericGroupTypeList : TList);
  procedure fillColorTypeUNIQUEID(HostQry: TMqmQuery; ColorTypeUNIQUEIDList : TList; HandledColorTypesStr : string);
  procedure fillColorType(HostQry: TMqmQuery; ColorTypeList : TList);
  procedure fillAdditionalDataStruct(HostQry: TMqmQuery; additionalDataList, UserGenericGroupTypeList, ColorTypeList : TList; AD_Product_SelectColums : string; AD_FullItemKeyDecoder_SelectColums : string;
            AD_ProductionDemand_SelectColums : string; AD_ProductionDemandStep_SelectColums : string;
            HandledProductionDemandMqinSql : String; var HandledUserGenericGroupTypesStr, HandledColorTypesStr : string; AtLeast_1_Wc_HandledWarp : boolean; WarpItemHandledStr : string);
  procedure fillPropertyStruct(ArcQry : TMqmQuery; propertyList: TList; handledWorkCentersList: Tlist);
  procedure Fill_Products_properties(read_Productproperty_list : TList; additionalDataList : TList; propertyList: TList; WarpItemHandledStrList : TStringList; List_Items : TList);
  procedure fillAlternativeWarehouseStruct(ArcQry : TMqmQuery; alternativeWarehouseList: TList);
  procedure fillItemTypeLogicalWarehouseStruct(ArcQry: TMqmQuery; itemTypeLogicalWarehouseList: TList; var NETGROUP_IS_LOT_Handaled : boolean;
            var AD_Product_FieldsList : TStringlist; var AD_FullItemKeyDecoder_FieldsList  : TStringlist;
            var AD_ProductionDemandStep_FieldsList  : TStringlist; var AD_ProductionDemand_FieldsList : TStringlist);
  function searchInList(listToSearch: TList; flag: integer; valueToSearch: String;
                        minIndex: integer; maxIndex: integer): integer;
  function  searchInListLinear(listToSearch: TList; flag: integer; valueToSearch: String): integer;
  procedure insertIntoBALANCE_HEADER_List(HostQry : TMqmQuery;
                                          logicalWarehouseList: TList; itemTypeLogicalWarehouseList : TList; read_balance_header_list: TList;
                                          articleTypeList: TList;
                                          additionalDataList, UserGenericGroupTypeList, UserGenericGroupAttributesList : Tlist);

  procedure fillItemTypesList(HostQry: TMqmQuery; companyCode: String;
                              itemTypesList: TList);

  procedure PrepareAllocationLists(HostQry: TMqmQuery; CompanyCode : string; articleTypeList : Tlist; ReservationLines : TList);

  procedure fillAlternativeUM(ArcQry :  TMqmQuery; companyCode: String);

  procedure makeRelevantOperationsForColumns(ArcQry: TMqmQuery; var firstSentenceColumnNames: String;
                                             var secondSentenceColumnNames: String;
            var AD_Product_FieldsList : TStringlist; var AD_FullItemKeyDecoder_FieldsList  : TStringlist;
            var AD_ProductionDemandStep_FieldsList  : TStringlist; var AD_ProductionDemand_FieldsList : TStringlist);

  function addToSelectedColumns(tablePrefix: String; columnPrefix: String;
                                 columnName: String; var selectedColumnNames: String;
                                 columnNamesStringList: TStringList) : integer;

  procedure AddAllDemandsToList(HostQry: TMqmQuery);
  procedure insertTupleToMemoryList(HostQry : TMqmQuery);
  procedure addProductionReservationToList(HostQry: TMqmQuery; productionReservationList: TList; ReservationLines : TList;
                                           productionReservationStringList: TStringList);

  function GetIndexForUserGenericGroupTable(SUBCODE : string; MQMProductionColumnValues : PMQMProductionColumnValues;
           additionalDataList, UserGenericGroupTypeList, UserGenericGroupAttributesList : TList) : integer;
  function GetIndexForColorTable(SUBCODE : string; MQMProductionColumnValues : PMQMProductionColumnValues;
           additionalDataList, ColorTypeList, ColorTypeUNIQUEIDList : TList) : integer;
  function getValueOfTheProductionColumnByFindPos(MQMProductionColumnValues: PMQMProductionColumnValues;
                                       colName: String): String;
  function getValueOfTheProductionColumn(MQMProductionColumnValues: PMQMProductionColumnValues;
                                         colName: string; colNameInt: Integer): String;

  procedure insertTheTuplesToProductionTables(productionDemandTemplates: TList;
                                              handledWorkCentersList: TList;
                                              unhandledWorkCentersList: TList;
                                              srvQryFD: TMqmQuery;
                                              propertyList: TList;
                                              resList : TList;
                                              additionalDataList,
                                              UserGenericGroupTypeList, UserGenericGroupTypeAttributesList : TList;
                                              ColorTypeList, ColorTypeUNIQUEIDList : TList;
                                              productionReservationList: TList;
                                              routingStepTimeTypeList: TList;
                                              operationList: TList; articleTypeList: TList;
                                              productsList: TList;
                                              read_produced_article_list: TList;
                                              read_material_list: TList;
                                              currentProductsList: TList;
                                              logicalWarehouseList: TList;
                                              read_prod_req_list: TList;
                                              read_prod_reqhdr_list: TList;
                                              read_prod_step_list: TList;
                                              read_prod_step_time_list: TList;
                                              read_prop_prod_list: TList;
                                              read_prod_step_batch_size_list: TList;
                                              stepIdListForProgressList_PD: TList;
                                              stepIdListForProgressList_PO: TList;
                                              stepIdListForProgressList_PO_SL: TStringList;
                                              itemTypeTemplates: TList;
                                              productionDemandCounters: TList;
                                              alternativeWarehouseList: TList;
                                              read_prod_reqConn_list: TList;
                                              alreadyAddedPROD_REQCONN: TStringList;
                                              additionalDataWithRelationList: TList;
                                              itemTypeLogicalWarehouseList: TList;
                                              //Items : PTItems;
                                              Steps, Recipes, Designs : TStringList;
                                              standardWeightUnit: String);

  function checkWhetherAnyWorkCentersHandled(handledWorkCentersList: TList): boolean;

  function checkWhetherAnyProductionOrderCodeIsNotBlank(): boolean;
  procedure insertProductionDemandDataIntoTables(srvQryFD: TMqmQuery;
                                                 handledWorkCentersList: TList;
                                                 unhandledWorkCentersList: TList;
                                                 propertyList: TList; resList : TList;
                                                 additionalDataList,
                                                 UserGenericGroupTypeList, UserGenericGroupTypeAttributesList : TList;
                                                 ColorTypeList, ColorTypeUNIQUEIDList : TList;
                                                 productionReservationList: TList;
                                                 routingStepTimeTypeList: TList;
                                                 operationList: TList; articleTypeList: TList;
                                                 productsList: TList;
                                                 read_produced_article_list: TList;
                                                 read_material_list: TList;
                                                 currentProductsList: TList;
                                                 logicalWarehouseList: TList;
                                                 CUR_PRODUCTIONDEMANDTEMPLATE: PPRODUCTIONDEMANDTEMPLATES;
                                                 read_prod_req_list: TList;
                                                 read_prod_reqhdr_list: TList;
                                                 read_prod_step_list: TList;
                                                 read_prod_step_time_list: TList;
                                                 read_prop_prod_list: TList;
                                                 read_prod_step_batch_size_list: TList;
                                                 stepIdListForProgressList_PD: TList;
                                                 stepIdListForProgressList_PO: TList;
                                                 stepIdListForProgressList_PO_SL: TStringList;
                                                 itemTypeTemplates: TList;
                                                 productionDemandCounters: TList;
                                                 alternativeWarehouseList: TList;
                                                 read_prod_reqConn_list: TList;
                                                 alreadyAddedPROD_REQCONN: TStringList;
                                                 additionalDataWithRelationList: TList;
                                                 itemTypeLogicalWarehouseList: TList;
                                                 //Items : PTItems;
                                                 Steps, Recipes, Designs : TStringList;
                                                 standardWeightUnit: String);

  procedure insertIntoPROD_REQ_List(MQMProductionColumnValues: PMQMProductionColumnValues;
                                    CUR_PRODUCTIONDEMANDTEMPLATE: PPRODUCTIONDEMANDTEMPLATES;
                                    read_prod_req_list: TList; productionDemandCounters: TList);

  procedure insertIntoPROD_REQHDR_List(additionalDataList: TList;
                                  MQMProductionColumnValues: PMQMProductionColumnValues;
                                  CUR_PRODUCTIONDEMANDTEMPLATE: PPRODUCTIONDEMANDTEMPLATES;
                                  read_prod_reqhdr_list: TList;
                                  uniqueWorkCenterProcesses: TStringlist;
                                  itemTypeTemplates: TList;
                                  productionDemandCounters: TList;
                                  ContainProductionOrderCode : boolean;
                                  Items : PTItems;
                                  LastStepMQMProductionColumnValues: PMQMProductionColumnValues);

  procedure ifNeededUpdatePROD_REQHDR_List(additionalDataList: TList;
                                  MQMProductionColumnValues: PMQMProductionColumnValues;
                                  CUR_PRODUCTIONDEMANDTEMPLATE: PPRODUCTIONDEMANDTEMPLATES;
                                  read_prod_reqhdr_list: TList;
                                  uniqueWorkCenterProcesses: TStringlist;
                                  itemTypeTemplates: TList;
                                  productionDemandCounters: TList;
                                  LastStepMQMProductionColumnValues: PMQMProductionColumnValues);

  function getAdditionalDataValue(defaultValue: String; additionalDataTableName: String;
                                  additionalDataColumnName: String; additionalDataList: TList;
                                  p_uniqueId: String; fikd_uniqueId: String;
                                  pd_uniqueId: String; pds_uniqueId: String): String;

  procedure prepareValuesToInsertPRODUCED_ARTICLE(srvQryFD: TMqmQuery; MQMProductionColumnValues: PMQMProductionColumnValues;
                                                  articleTypeList: TList;
                                                  additionalDataList, UserGenericGroupTypeList, UserGenericGroupTypeAttributesList : TList;
                                                  productsList: TList;
                                                  read_produced_article_list: TList;
                                                  currentProductsList: TList;
                                                  logicalWarehouseList: TList;
                                                  CUR_PRODUCTIONDEMANDTEMPLATE: PPRODUCTIONDEMANDTEMPLATES;
                                                  Items : PTItems;
                                                  productionDemandCounters : TList;
                                                  itemTypeLogicalWarehouseList: TList);

{  procedure updateProducedArticleValuesFromAllocations(srvQryFD: TMqmQuery; HostQry: TMqmQuery;
                                                       read_produced_article_list: TList;
                                                       salesOrderList: TList;
                                                       addedKeys: TStringList;
                                                       logicalWarehouseList: TList;
                                                       read_prod_reqConn_list: TList;
                                                       read_ext_connection_list: TList;
                                                       read_ext_info_hdr_list: TList;
                                                       productionDemandCounters : TList;
                                                       read_ext_info_list: TList;
                                                       alreadyAddedPROD_REQCONN: TStringList); }

  procedure insertIntoEXTtables(srvQryFD: TMqmQuery; prodReqNo: String;
                                connectedKey: String; connectionType: String;
                                itemTypeCode: String; demandCounterCode: String;
                                demandTemplateCode: String; listToCheck: TList;
                                productionDemandCounters : TList;
                                addedList: TStringList; read_ext_connection_list: TList;
                                read_ext_info_hdr_list: TList; read_ext_info_list: TList);

  procedure insertIntoEXT_CONNECTION_List(prodReqNo: String; connectedKey: String;
                                          dateToUse: TDate; itemTypeCode: String;
                                          demandCounterCode: String;
                                          productionDemandCounters : TList;
                                          demandTemplateCode: String;
                                          read_ext_connection_list: TList);

  procedure insertIntoEXT_INFO_HDR_List(connectedKey: String; connectionType: String;
                                        itemTypeCode: String; demandCounterCode: String;
                                        demandTemplateCode: String; dueDate: String;
                                        dateToUse: TDate; read_ext_info_hdr_list: TList);

  procedure insertIntoEXT_INFO_List(connectedKey: String; info: String;
                                    itemTypeCode: String; demandCounterCode: String;
                                    demandTemplateCode: String; dateToUse: TDate;
                                    productionDemandCounters : TList;
                                    read_ext_info_list: TList);


  procedure insertIntoPROD_REQCONN_List(fromProdReq: String; toProdReq: String;
                                        itemTypeCode: String; demandCounterCode: String;
                                        demandTemplateCode: String;
                                        productionDemandCounters : TList;
                                        read_prod_reqConn_list: TList);

  procedure insertIntoPRODUCED_ARTICLE_List(preqNo: String; sequence: String;
                                            productCode: String; netGroupCode: String;
                                            allocReq: String; prodBalance: String;
                                            rscCode: String; settled: String;
                                            reqQuantity: String; qtyProduced: String;
                                            qtyAlloc: String; demandTemplateCode: String;
                                            demandCounterCode: String; itemTypeCode: String;
                                            read_produced_article_list: TList;
                                            isFromOtherProducedArticle: boolean;
                                            logicalWarehouse: String;
                                            itemTypeLogicalWarehouseList: TList;
                                            MQMProductionColumnValues: PMQMProductionColumnValues;
                                            Items : PTItems;
                                            productionDemandCounters : TList;
                                            additionalDataList: TList);

  procedure prepareValuesToInsertMATERIAL(srvQryFD: TMqmQuery; productionReservationList: TList;
                                          stepNumbersOfHandledWorkCenters, stepNumbersOfHandledNameOfWorkCenters: TStringList;
                                          MQMProductionColumnValues: PMQMProductionColumnValues;
                                          articleTypeList: TList; additionalDataList, UserGenericGroupTypeList, UserGenericGroupTypeAttributesList: TList;
                                          productsList: TList; read_material_list: TList;
                                          currentProductsList: TList;
                                          logicalWarehouseList: TList;
                                          CUR_PRODUCTIONDEMANDTEMPLATE: PPRODUCTIONDEMANDTEMPLATES;
                                          alternativeWarehouseList: TList;
                                          List_Items : TList;
                                          productionDemandCounters: TList;
                                          itemTypeLogicalWarehouseList: TList; var PRODUCT_CODE : string);

{  procedure updateMaterialValuesFromAllocations(srvQryFD: TMqmQuery; HostQry: TMqmQuery;
                                                read_material_list: TList;
                                                purchaseOrderList: TList;
                                                addedKeys: TStringList;
                                                logicalWarehouseList: TList;
                                                read_ext_connection_list: TList;
                                                read_ext_info_hdr_list: TList;
                                                read_ext_info_list: TList;
                                                read_balance_header_list: TList;
                                                articleTypeList: TList;
                                                productionDemandCounters: TList;
                                                additionalDataList: TList;
                                                alternativeWarehouseList: TList);   }

{  procedure createNegativeBalancesFromAllocations(srvQryFD: TMqmQuery; HostQry: TMqmQuery;
                                                  logicalWarehouseList: TList;
                                                  read_balance_header_list: TList;
                                                  articleTypeList: TList;
                                                  additionalDataList: TList; CompanyCodeInUsed : string);  }

{  procedure executeInsertCommandForBalanceHeader_List(HostQry: TMqmQuery; useDate: boolean;
                                                      logicalWarehouseList: TList;
                                                      read_balance_header_list: TList;
                                                      articleTypeList: TList;
                                                      additionalDataList: TList);  }


  function insertIntoMaterialList(preqNo: String; pstepId: String;
                                   orgStep: String; wkcnter: String;
                                   resCatCode: String; rscCode: String;
                                   machineSetupCode: String; alternativeCode: String;
                                   typeProd: String; productCode: String;
                                   netGroupCode: String; issueCode: String;
                                   seqIssued: String; matBalance: String;
                                   qtyAlloc: double; highDateAlloc: TDate;
                                   searchMatAlloc: String; settled: String;
                                   quantitiyIssue: String; reqQuantity: String;
                                   demandTemplateCode: String; demandCounterCode: String;
                                   read_material_list: TList;
                                   alternativeWarehouseList: TList;
                            //       flagForAlternatives: boolean;
                            //       isFromOtherMaterial: boolean;
                                   logicalWarehouse: String;
                                   itemTypeLogicalWarehouseList: TList;
                                   MQMProductionColumnValues: PMQMProductionColumnValues;
                                   Items : PTItems;
                                   productionDemandCounters : TList;
                                   ProjectCode : string;
                                   additionalDataList: TList) : pointer;

  function isBalanceHandledByMqm(articleTypeList: TList; itemTypeCode: String;
                                 additionalDataList, UserGenericGroupTypeList, UserGenericGroupAttributesList : TList;
                                 uniqueId: String; var MATERIAL_TOLLERANCE_CODE : string;
                                 SUBCODE01,SUBCODE02,SUBCODE03,SUBCODE04,SUBCODE05,SUBCODE06,SUBCODE07,SUBCODE08,SUBCODE09,SUBCODE10 : string): String;								 
  function getLogicalWHStruct(WarehouseCode: String; logicalWarehouseList: TList): PLOGICALWAREHOUSES;
  function getTimeTypeCode(MQMProductionColumnValues: PMQMProductionColumnValues;
                           routingStepTimeTypeList: TList;
                           handledWorkCentersList: TList): String;

  procedure insertIntoPROD_STEP_List(MQMProductionColumnValues: PMQMProductionColumnValues;
                                CUR_WORKCENTER: PWORKCENTERS;
                                previousStepHandledByMcm : string;
                                nextStepHandledByMcm     : string;
                                previousStepHandledByMqm: String; previousStepInDemand: String;
                                nextStepHandledByMqm: String; nextStepInDemand: String;
                                timeTypeCode: String;
                                read_prod_step_list: TList; handledWorkCentersList, unhandledWorkCentersList : TList;
                                CUR_PRODUCTIONDEMANDTEMPLATE: PPRODUCTIONDEMANDTEMPLATES;
                                Items : PTItems;
                                additionalDataList: TList; standardWeightUnit: String;
                                itemTypeTemplates: TList;
                                PTNA_REC : PT_TNA;
                                productionDemandCounters: TList
                            //    productPrimaryUomConversionDataList: TList;
                            //    secondaryUnitCategoryConversionList: TList;
                            //    stdUnitCategoryConversionList: TList
                               );

  function insertIntoPROD_STEP_TIMES_List( MQMProductionColumnValues: PMQMProductionColumnValues;
                                     timeTypeCode: String;
                                     UserGenericGroupTypeList, UserGenericGroupTypeAttributesList : TList;
                                     routingStepTimeTypeList: TList;
                                     CUR_WORKCENTER: PWORKCENTERS;
                                     handledWorkCentersList: TList;
                                     operationList: TList;
                                     propertyList,
                                     ColorTypeList, ColorTypeUNIQUEIDList,
                                     productionDemandCounters : TList;
                                     additionalDataList: TList;
                                     read_prod_step_time_list: TList;
                                     Items : PTItems;
                                     CUR_PRODUCTIONDEMANDTEMPLATE: PPRODUCTIONDEMANDTEMPLATES
                                    ): double;


  procedure insertProdStepTime_List(WORKCENTER: PWORKCENTERS; MQMProductionColumnValues: PMQMProductionColumnValues;
                                   workCenterCode: String; operation: String;
                                   resourceCategory: String; resource: String;
                                   OPERATION_TIME_MULTIPLIER : string;
                                   SETUP_TIME_MULTIPLIER : string;
                                   CUR_PRODUCTIONTIMESLEVEL: PPRODUCTIONTIMESLEVELS;
                                   setupTime: String; executeTime: String; executeTimeAlt : String;
                                   read_prod_step_time_list: TList;
                                   handledWorkCentersList: TList;
                                   productionDemandCounters : TList;
                                   additionalDataList: TList;
                    							 timeTypeCode: String;
                                   propertyList  : TList;
                                   ColorTypeList : TList;
                                   ColorTypeUNIQUEIDList : TList;
                                   BATCHSTANDARDTIME : boolean;
                                   WC_BATCHSTANDARDTIME : string;
                                   stepStdQtyValue : double;
                                   routingStepTimeTypeList: TList;
                     							 operationList: TList;
                                   Items : PTItems;
                                   UserGenericGroupTypeList, UserGenericGroupTypeAttributesList : TList;
                                   CUR_PRODUCTIONDEMANDTEMPLATE: PPRODUCTIONDEMANDTEMPLATES);


  function needToInsertPRODUCTS(LocalQry: TMqmQuery; prodType: String; prodCode: String;
                                prodNature: String; startPoint: String; endPoint: String;
                                infoArea: String; stdPurCorProdTime: String;
                                currentProductsList: TList; MATERIAL_TOLLERANCE_CODE : string; HoursToDownFromMachin : integer; Items : PTItems): boolean;

  procedure insertIntoPRODUCTS(LocalQry: TMqmQuery; prodType: String; prodCode: String;
                               prodNature: String; startPoint: String; endPoint: String;
                               infoArea: String; stdPurCorProdTime: String; MATERIAL_TOLLERANCE_CODE : string; HoursToDownFromMachin : integer;
                               MAT_STANDARD_SPEED_Warp : double; MAT_STANDARD_SETMIN_Warp : double; MAT_SCHEDULE_Type_Warp : string);

  procedure getTimeValue(var setupTime: double; var executeTime: double; index: integer;
                         CUR_OPERATTRIBUTE: POPERATTRIBUTES;
                         routingStepTimeTypeList: TList;
                         MQMProductionColumnValues: PMQMProductionColumnValues;
                         operationList: TList;
                         operationCode: String; Items : PTItems; OverridenTimeOrQty, StepRepetition : String; Eficiency100Percent : boolean);
  function getCalculatedTimeValue(applyTypeCode: String; EfficiencyStepUsed : string; index: integer;
                         CUR_OPERATTRIBUTE: POPERATTRIBUTES;
                         MQMProductionColumnValues: PMQMProductionColumnValues;
                         CUR_OPERATION: POPERATIONS; Items : PTItems; OverridenTimeOrQty, StepRepetition : String; Eficiency100Percent : boolean): double;
  function getDoubleFromStr(str: String): double;
  function calculateTimeForBatch(POExists : boolean; quantity: double; batchQuantity: double;
                                 time: double; uomCode: string): double;
  function calculateTimeForContinuos(POExists : boolean; quantity: double; stdQuantity: double;
                                     time: double; uomCode: string): double;
  function calculateTimeForFix(time: double; uomCode: string): double;
  function calculateTimeForPercentage(percentage: double; linkedTime: double;
                                      uomCode: string): double;
  function calculateTimeForPrimary(quantity: double; refQuantity: double; uomCode: string): double;
  function calculateTimeForSecondary(secondaryQuantity: double; refQuantity: double; uomCode: string): double;
  function calculateTimeForUnit(quantity: double; time: double; uomCode: string): double;
  function convertTimeToMin(time: double; uomCode: String): double;

  procedure ifNeededInsertIntoPROP_PROD_List(MQMProductionColumnValues: PMQMProductionColumnValues;
                                             propertyList: TList; resList : TList;
                                             additionalDataList,
                                             UserGenericGroupTypeList, UserGenericGroupTypeAttributesList : TList;
                                             ColorTypeList, ColorTypeUNIQUEIDList : TList;
                                             handledWorkCentersList: TList;
                                             read_prop_prod_list: TList;
                                             CUR_PRODUCTIONDEMANDTEMPLATE: PPRODUCTIONDEMANDTEMPLATES;
                                             Items : PTItems;
                                             Steps, Recipes, Designs : TStringList;
                                             GenericOrder, GenericLine, GenericDelivery, GenericProject, GenericBusinessPartner : PRGeneric;
                                             var HeaderPropList : TList;
                                             productionDemandCounters: TList; var ServingCode : string; var CurveFamily_IdCode : string; var CurveFamily_IdCode_BuildFromProp : boolean;
                                             isWorkCenterHandledByMqm : String; isWorkCenterHandledByMcm : String);

  procedure insertIntoPROD_STEP_BATCH_SIZE_List(MQMProductionColumnValues: PMQMProductionColumnValues;
                                                handledWorkCentersList: TList;
                                                resList : TList;
                                                workCenterCode: String;
                                                read_prod_step_batch_size_list: TList;
                                                Items : PTItems;
                                                productionDemandCounters : TList;
                                                CUR_PRODUCTIONDEMANDTEMPLATE: PPRODUCTIONDEMANDTEMPLATES);


  function getValueFromTable(MQMProductionColumnValues: PMQMProductionColumnValues;
                             tableName: String; columnName: String;
                             Items : PTItems;
                             additionalDataList: TList;
                             var DataType : Integer): String;

  function getAdditionalData(listOfAdditionalData: TList; columnName: String; var DataType : Integer): String;

  procedure fillAlternativeWorkCentersAndProcesses(handledWorkCentersList: TList;
                                         alternativeWorkCenters: TStringList;
                                         alternativeWorkCenterProcesses: TStringList;
                                         workCenterCode: String; operationCode: String);

  procedure fillResTableToList(ArcQry : TMqmQuery; resList: TList);
  procedure fillProductsToList(LocalQry: TMqmQuery;  currentProductsList: TList);
  procedure checkIfNeedToInsertNewWarpProductionToDatabase(LocalQry : TMqmQuery; currentProductsList : TList; List_Items : TList);
  procedure fillProductionDemandTemplateStruct(LocalQry: TMqmQuery;  ArcQry : TMqmQuery; productionDemandTemplates: TList;
       var AD_Recipe_FieldsList : TStringList; var AD_Design_FieldsList : TStringList;
       var AD_Product_FieldsList : TStringList; var AD_FullItemKeyDecoder_FieldsList : TStringList;
       var AD_ProductionDemandStep_FieldsList : TStringList;
       var AD_ProductionDemand_FieldsList : TStringList; var TNA_List1 : TStringList; var TNA_List2 : TStringList);

  function getStandardUnitCategoryForWeight(HostQry: TMqmQuery): String;

  procedure fillOperationsToList(HostQry: TMqmQuery; companyCode: String;
                                 operationList: TList);
  procedure fillSalesOrderToList(HostQry: TMqmQuery; companyCode: String;
                                 salesOrderList: TList);
  procedure fillPurchaseOrderToList(HostQry: TMqmQuery; companyCode: String;
                               purchaseOrderList: TList);
  procedure fillLogicalWarehousesToList(ArcQry: TMqmQuery; HostQry: TMqmQuery; logicalWarehouseList: TList);
  procedure fillItemTypeTemplatesToList(ArcQry: TMqmQuery; itemTypeTemplatesList: TList);
  function fillProductionDemandCountersToList(ArcQry: TMqmQuery; productionDemandCountersList: TList): boolean;
  procedure fillArticleTypeToList(ArcQry: TMqmQuery; articleTypeList: TList);

  function GetAColumnValue (CUR_PRODUCTIONTIMESLEVEL: PPRODUCTIONTIMESLEVELS;
                       MQMProductionColumnValues: PMQMProductionColumnValues;
                       Items : PTItems;
                       additionalDataList: TList; ColumnNumber : integer
                       ): string;

  function GetValues(CUR_PRODUCTIONTIMESLEVEL: PPRODUCTIONTIMESLEVELS;
                     MQMProductionColumnValues: PMQMProductionColumnValues;
                     Items : PTItems;
                     UserGenericGroupTypeList, UserGenericGroupTypeAttributesList : TList;
                     propertyList : TList;
                     ColorTypeList: TList;
                     ColorTypeUNIQUEIDList : TList;
                     additionalDataList: TList;
                     var ConcatinatedStr : String): boolean;
  function GetTimeStartingIndex(CUR_PRODUCTIONTIMESLEVEL: PPRODUCTIONTIMESLEVELS; str : string) : Integer;

  function GetValueOfAdditionalData(listOfAdditionalData: TList;
                                      columnName: String; var value : string): boolean;

  function getTablePrefix(tableName: String): String;


  function getFullItemKeyCode(itemType: String; code01: String; code02: String;
                              code03: String; code04: String; code05: String;
                              code06: String; code07: String; code08: String;
                              code09: String; code10: String): String;

  function compareValuesOfListsToSort(firstList: TStringList; secondList: TStringList): Integer;

  function SortProductionOrderStepStruct(Item1: Pointer; Item2: Pointer): Integer;

  procedure fillProductionProgressTemplateStruct(ArcQry: TMqmQuery;
                                                 productionProgressTemplates: TList);

  procedure fillWorkCentersBatchSizes(handledWorkCentersList, resList : TList);
  procedure fillADWithRelationToList(ArcQry: TMqmQuery; additionalDataWithRelationList: TList);

  procedure setLowestAndHigestDates(var lowestDate: TDateTime; var highestDate: TDateTime; CUR_PROGRESS_ITEM: PPROGRESS_ITEMS; var IsEndExist : boolean);

  function getPSTEP_IDForProgress(stepNumber: String; code: String;
                                  workCenterCode: String; operationCode: String;
                                  stepIdListForProgressList_PD: TList;
                                  stepIdListForProgressList_PO: TList;
                                  var stepInitialQuantity: double;
                                  var stepFinalQuantity: double): String;

  procedure ifNeededAddWorkCenterAndOperationToList(workCenterCode: String;
                                                    operationCode: String;
                                                    stepNumber: String;
                                                    initialBasePrimaryQuantity: String;
                                                    finalBasePrimaryQuantity: String;
                                                    workCenterList: TList;
                                                    operationList: TList;
                                                    stepIdList: TList);

  procedure ifNeededAddToStepIdListForProgressList_PO(orderCode: String;
                                                      workCenterCode: String;
                                                      operationCode: String;
                                                      stepNumber: String;
                                                      initialBasePrimaryQuantity: String;
                                                      finalBasePrimaryQuantity: String;
                                                      stepIdListForProgressList_PO: TList;
                                                      stepIdListForProgressList_PO_SL: TStringList);

  procedure addToHandled_PD_PO(productionDemandCode: String; productionDemandStep: String;
                               productionOrderCode: String; productionOrderStep: String);

  function isStepHandled(stepList: TStringList; stepIdListForProgressList_PD: TList;
                         stepIdListForProgressList_PO: TList; HostQry: TMqmQuery;
                         var StepId: String; var StepInitialQuantity: String;
                         var StepFinalQuantity: String; ProductionStruct : TProductionOrderStepStruct): boolean;

  function setStepId(stepIdListForProgressList: TList; code: String; workcenterCode: String;
                     operationCode: String; var StepId: String; var StepInitialQuantity: String;
                     var StepFinalQuantity: String): boolean;

  procedure setStepInitialFinalQuantities(stepIdListForProgressList: TList; code: String;
                                          StepId: String; var StepInitialQuantity: String;
                                          var StepFinalQuantity: String);

  procedure convertListToStruct(progressList: TList; progressStruct: TList; needToHandleMergeOperation : boolean ; productionDemandCounters : TList);
  procedure addDemandAndOrderToProg_Machine(CUR_PROG_MACHINE: PPROG_MACHINES;
                                            NEW_PROG_DEMANDANDORDER: PPROG_DEMANDANDORDERS;
                                            CUR_PROGRESS: PPROGRESSES);
  procedure addProgressItemToProg_DemandAndOrder(CUR_PROG_DEMANDANDORDER: PPROG_DEMANDANDORDERS;
                                                 NEW_PROGRESS_ITEM: PPROGRESS_ITEMS;
                                                 CUR_PROGRESS: PPROGRESSES;
                                                 progressIndex: Integer);



  function getBalanceHeaderInfoArea(typeStr: String; code: String): String;


  procedure addNewPROD_SCHED_PROGRESSWithPercentage(PREQ_NO: String; PROD_SCHED_PROGRESS: PPROD_SCHED_PROGRESSES;
                                      percentageStr: String; read_prod_sched_progress_list: TList);

  function addNewPROD_SCHED_PROGRESSWithQty(PREQ_NO: String; PROD_SCHED_PROGRESS: PPROD_SCHED_PROGRESSES;
                                      Qty: String; read_prod_sched_progress_list: TList): boolean;


  procedure fillUnique_nonUniqueWorkCenterProcesses(workCenterCode: String; processCode: String;
                                                  uniqueWorkCenterProcesses: TStringlist;
                                                  nonUniqueWorkCenterProcesses: TStringList);

  function setItemTypeTemplate(itemTypeTemplates: TList; itemTypeCode: String;
                               productionDemandTemplateCode: String;
                               workCenterCode: String; ProcessCode: String): PITEMTYPEPRODUCTIONDEMANDTEMPLATES;

  function setProductionDemandCounter(productionDemandCounters: TList;
                                       counterCode: String): PPRODUCTIONDEMANDCOUNTERS;

  function insertAlternativesToProdStepTime_List(workCenterCode: String;
                                                 operationCode: String;
                                                 itemType: String;
                                                 UserGenericGroupTypeList, UserGenericGroupTypeAttributesList : TList;
                                                 handledWorkCentersList: TList;
                                                 MQMProductionColumnValues: PMQMProductionColumnValues;
                                                 productionDemandCounters : TList;
                                                 additionalDataList: TList;
                                                 timeTypeCode: String;
                                                 propertyList  : TList;
                                                 ColorTypeList : TList;
                                                 ColorTypeUNIQUEIDList : TList;
                                                 resourceCategory: String; resource: String;
                                                 read_prod_step_time_list: TList;
                                                  routingStepTimeTypeList: TList;
                                                 Items : PTItems;
                                                 operationList: TList
                                                ): boolean;

  function  UpdateBatchStepTime(PREQ_NO : string; STEP_ID : string; var SETUP_TIME : string; var EXC_TIME_QTY : string) : boolean;

  function checkWhetherNeedToMerge(base: TStringList; current: TStringList;
                                   endPosition: Integer): boolean;
  function getEndPosition(productionDemandCounters: TList; code: String): Integer;

  procedure addAlternativesOfMaterial(read_material_list: TList; alternativeWarehouseList: TList; ProjectDode : string);

  function getAllowSplitValueFromWkc_Proc(CUR_WORKCENTER: PWORKCENTERS; CUR_PROCESS: PPROCESSES;
                                          additionalDataList: TList;
                                          Items : PTItems;
                                          MQMProductionColumnValues: PMQMProductionColumnValues; itemTypeTemplates: TList): String;
  function getSplitFamilyValueFromWkc_Proc(CUR_WORKCENTER: PWORKCENTERS; CUR_PROCESS: PPROCESSES;
                                           additionalDataList: TList;
                                           Items : PTItems;
                                           MQMProductionColumnValues: PMQMProductionColumnValues): String;

  procedure insertIntoPROD_REQCONN_List_From_Demand(MQMProductionColumnValues: PMQMProductionColumnValues;
                                                    read_prod_reqConn_list: TList;
                                                    alreadyAddedPROD_REQCONN: TStringList;
                                                    additionalDataWithRelationList: TList;
                                                    Items : PTItems;
                                                    productionDemandCounters : TList;
                                                    additionalDataList: TList);

  procedure insertIntoPROD_REQCONN_List_From_Demand_AD(MQMProductionColumnValues: PMQMProductionColumnValues;
                                                       read_prod_reqConn_list: TList;
                                                       alreadyAddedPROD_REQCONN: TStringList;
                                                       additionalDataWithRelationList: TList;
                                                       Items : PTItems;
                                                       productionDemandCounters : TList;
                                                       additionalDataList: TList);

  function getNetGroupCode(defaultValue: String; isForProducedArticle: boolean;
                           itemType: String; logicalWarehouse: String;
                           itemTypeLogicalWarehouseList: TList;
                           MQMProductionColumnValues: PMQMProductionColumnValues;
                           Items : PTItems;
                           additionalDataList: TList): String;

  function formatPropertyValue(propertyList: TList; propertyCode: String; propertyValue: String; CompleteMqmFormat : boolean; CUR_PROP_RTV_VALUE: PPROP_RTV_VALUES): String;
  function formatPropertyValueDirect(CUR_PROP: PPROPS; propertyValue: String; CompleteMqmFormat: Boolean; CUR_PROP_RTV_VALUE: PPROP_RTV_VALUES): String;
  function toMQMFormat(PropLen: Integer; PropDecNum: Integer; Value: String): String;
  function TxtToFloat ( s: AnsiString; var ok: Boolean ): Double;
  procedure CheckTxt(var s: AnsiString; var ok: Boolean);

  procedure getProductNatureAndReservationTimes(articleTypeList: TList; itemTypeCode: String;
                                                var nature: String; var beginTime: String;
                                                var endTime: String; var HoursToDownFromMachin : integer; defaultNature: String;
                                                defaultBeginTime: String; defaultEndTime: String);

  function getBalanceHandledItemTypes(articleTypeList: TList; Include_ADDDATACOLUMNNAME : boolean): String;
  function sortHandledProductionOrder(Item1: Pointer; Item2: Pointer): Integer;
  function FindGenericBinarSearch(List : TList; Entity : String; Key1,Key2,Key3,Key4,Key5,Key6 : variant): PRGeneric;
  function FindTNA_BinarSearch(List : TList; Entity : String) : PT_TNA;

  procedure CreateProdCont;
  procedure ClearStructMemoryList;
  procedure UpdateBuildedPropertyFromOtherProperty;
  procedure BuildFamilyStructure;
  procedure RecalcBatchProductionOrder;
  procedure TryToGroupStepTimesRows;

  function Get_Host_prod_req_list : TList;
  function Get_Host_prod_reqhdr_list : TList;
  function Get_Host_prod_step_list : TList;
  function Get_Host_prod_step_time_list : TList;
  function Get_Host_prop_prod_list(out bSortNeeded: Boolean) : TList;
  function Get_Host_prod_step_batch_size_list : TList;
  function Get_Host_prod_info_list : TList;
  function Get_Host_prod_reqConn_list : TList;
  function Get_Host_ext_connection_list : TList;
  function Get_Host_ext_info_hdr_list : TList;
  function Get_Host_ext_info_list : TList;
  function Get_Host_Material_Schedule : TList;
  function Get_Host_Material_Schedule_Link : TList;
  function Get_Host_balance_header_list : TList;
  procedure Merge_Host_balance_header_list(list : TList);
  function Get_Host_produced_article_list : TList;
  function Get_Host_material_list : TList;
  function Get_Host_Progress_List : TList;
  function Get_Host_Productproperty : TList;

  function Get_PDS_BASEPRIMARYUOMCODE_Index : integer;
  function Get_PDS_USERPRIMARYUOMCODE_Index : integer;
  function Get_PDS_BASESECONDARYUOMCODE_Index : integer;
  function Get_PDS_USERSECONDARYUOMCODE_Index : integer;
  function Get_PDS_USERPACKAGINGUOMCODE_Index : integer;
  function Get_PDS_INITIALBASEPRIMARYQUANTITY_Index : integer;
  function Get_PDS_INITIALUSERPRIMARYQUANTITY_Index : integer;
  function Get_PDS_INITIALBASESECONDARYQUANTITY_Index : integer;
  function Get_PDS_INITIALUSERSECONDARYQUANTITY_Index : integer;
  function Get_PDS_INITIALUSERPACKAGINGQUANTITY_Index : integer;
implementation

uses UMSaveLoad,UMsrvLoad, Dialogs,Windows, System.Threading, //FamilyHandling,
  UMDbFunc,UMglobal, UMProductionStructService,
  Progress,
  Demand,
  UMNotes,
  UMProdMemory,
  UMProdSortList,
  UMSrvConfig,
  UOpThread,
//  UpdateLocalDatabase,
  UMConvert,
  StrUtils;

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
  end;
  PReqChange = ^ReqChange;

  StepChange = Record
    ProdReq : string;
    StepNr  : integer;
    ChangedType : TStepChange;
    Index_PR : Integer;
    Index_PH : Integer;
    Index_PD : Integer;
    Index_PP : Integer;
    Index_PI : Integer;
    Index_SB : Integer;
    Index_SP : Integer;
    Index_ST : Integer;
    Index_MT : Integer;
  end;
  PStepChange = ^StepChange;

  TProdCont = class
  private
    m_Req_Change_List : TList;
    m_Demand_list     : TList;
  public
    constructor Create;
    destructor Destroy; override;
  private
    procedure ClearStructMemoryList;
    procedure FreeListProd;
  end;

var
  m_ProdCont : TProdCont;
  productionColumnNames: TStringList;
  insertedProducts: TStringList;
  handledProductionDemands: TStringList;
  Production_Order_Grp_No_list : TList;
  handledProductionDemandList: TList;
  handledProductionOrderList: TList;
  itemTypesList: TList;
  ProcessListAlternativeUM_Primary : TStringList;
  ProcessListAlternativeUM_secondary : TStringList;
  PackagingAlternativeUoM : TStringList;

//  minProductionOrderGroupNo: integer;
  ProductionOrderStepStructList : TList;
  ProjectNumberList : TList;

  List_Items, List_Generic, List_TNA : TList;
  read_prod_req_list: TList;
  read_prod_reqhdr_list: TList;
  read_prod_step_list: TList;
  read_prod_step_time_list: TList;
  read_prop_prod_list: TList;
  read_prod_step_batch_size_list: TList;
  read_prod_info_list: TList;
  read_prod_reqConn_list: TList;
  read_ext_connection_list: TList;
  read_ext_info_hdr_list: TList;
  read_ext_info_list: TList;
  read_Material_Schedule_list: TList;
  read_Material_Schedule_list_Link : TList;
  read_balance_header_list: TList;
  read_produced_article_list: TList;
  read_material_list: TList;
  read_Progress_list: TList;
  read_Productproperty_list : TList;
  m_NeedToMakeMerge : boolean;
  m_Exist_INITIALPLANSCHEDDATETIME : boolean;
  m_Exist_FINALPLANSCHEDDATETIME : boolean;
  m_Exist_INITIALPLANNEDSCHEDULEDDATE : boolean;
  m_Exist_FINALPLANNEDSCHEDULEDDATE : boolean;
  m_Exist_MQMSPLITREFERENCE : boolean;

  FIKD_ABSUNIQUEID, FIKD_IDENTIFIER, PD_COMPANYCODE, PD_COUNTERCODE, PD_CODE,PD_DIVISIONCODE, PD_TEMPLATECODE, PD_ENTRYWAREHOUSECODE, PD_BASEPRIMARYQUANTITY,
  PD_BASEPRIMARYUOMCODE, PD_BASESECONDARYUOMCODE, PD_UOMTYPE, PD_ENTEREDBASEPRIMARYQUANTITY, PD_ITEMTYPEAFICODE, PD_PROGRESSSTATUS,
  PD_STDPRODUCTIONBATCH, PD_STDPRODUCTIONBATCHUOMCODE, PD_INITIALPLANNEDDATE, PD_FINALPLANNEDDATE, PD_RESERVATIONORDERCOUNTERCODE,
  PD_RESERVATIONORDERCODE, PD_ABSUNIQUEID, PD_PROJECTCODE, PD_CUSTOMERCODE, PD_ORIGDLVSALORDLINESALORDCNTCOD, PD_ORIGDLVSALORDLINESALORDERCODE,
  PD_ORIGDLVSALORDERLINEORDERLINE, PD_ORIGDLVSALORDLINEORDERSUBLINE, PD_ORIGDLVSALORDLINECMPORDERLINE, PD_ORIGDELIVERYDELIVERYLINE,
  PD_INITIALPLANNEDSCHEDULEDDATE, PD_FINALPLANNEDSCHEDULEDDATE, PD_MQMSPLITREFERENCE,
  PD_SUBCODE01, PD_SUBCODE02, PD_SUBCODE03, PD_SUBCODE04, PD_SUBCODE05, PD_SUBCODE06, PD_SUBCODE07, PD_SUBCODE08, PD_SUBCODE09, PD_SUBCODE10,
  PDS_WORKCENTERCODE, PDS_PRODUCTIONORDERCODE, PDS_GROUPSTEPNUMBER, PDS_STEPNUMBER, PDS_TIMETYPE1CODE, PDS_TIMETYPE2CODE,
  PDS_TIMETYPE3CODE, PDS_TIMETYPE4CODE, PDS_TIMETYPE5CODE, PDS_TIME1, PDS_TIME2, PDS_TIME3, PDS_TIME4, PDS_TIME5, PDS_INITIALPLANSCHEDDATETIME, PDS_FINALPLANSCHEDDATETIME,
  PDS_MINBEGINQUEUE, PDS_MINBEGINQUEUETIME, PDS_MAXENDSTEP, PDS_MAXENDSTEPTIME, PDS_STDBEGINPRESETUP, PDS_STDBEGINPRESETUPTIME, PDS_STDENDSTEP,
  PDS_STDENDSTEPTIME, PDS_INITIALBASEPRIMARYQUANTITY, PDS_FINALBASEPRIMARYQUANTITY, PDS_INITIALBASESECONDARYQUANTITY,
  PDS_INITIALUSERPRIMARYQUANTITY, PDS_INITIALUSERSECONDARYQUANTITY, PDS_INITIALUSERPACKAGINGQUANTITY, PDS_BASEPRIMARYUOMCODE, PDS_BASESECONDARYUOMCODE,
  PDS_USERPRIMARYUOMCODE, PDS_USERSECONDARYUOMCODE, PDS_USERPACKAGINGUOMCODE, PDS_CALENDARCODE, PDS_CALCULATEDTIME1, PDS_CALCULATEDTIME2, PDS_CALCULATEDTIME3, PDS_CALCULATEDTIME4, PDS_NROFMACHINE,
  PDS_PROGRESSSTATUS, PDS_OPERATIONCODE, PDS_WORKCENTERANDOPERATTRIBUTESCOD, PDS_REPETITIONNUMBER,
  PDS_ITEMTYPEAFICODE, PDS_STEPEFFICIENCY, PDS_ABSUNIQUEID, PDS_STANDARDSTEPQUANTITY,
  PDS_STANDARDSTEPQUANTITYUOMCODE,
  PRSV_ITEMTYPEAFICODE, PRSV_RESERVATIONLINE, PRSV_BASEPRIMARYQUANTITY, PRSV_USEDBASEPRIMARYQUANTITY, PRSV_WAREHOUSECODE,
  PRSV_REFERENCEITEM, RSV_FIKD_IDENTIFIER, PRSV_ITEMNATURE, PRSV_ISSUEDATE, PRSV_PROJECTCODE, PRSV_PROGRESSSTATUS, RSV_FIKD_ABSUNIQUEID : Integer;
//----------------------------------------------------------------------------//

function Get_Host_prod_req_list : TList;
var
  I : Integer;
begin
  for I := 0 to read_prod_req_list.Count - 1 do
  begin
    PTMQMPR(read_prod_req_list[I]).PR_DIV_CODE := trim(PTMQMPR(read_prod_req_list[I]).PR_DIV_CODE);
    PTMQMPR(read_prod_req_list[I]).PR_DSP_CODE := trim(PTMQMPR(read_prod_req_list[I]).PR_DSP_CODE);
    PTMQMPR(read_prod_req_list[I]).PR_BCH_CODE := trim(PTMQMPR(read_prod_req_list[I]).PR_BCH_CODE);
    PTMQMPR(read_prod_req_list[I]).PR_PREQ_NO := trim(PTMQMPR(read_prod_req_list[I]).PR_PREQ_NO);
    PTMQMPR(read_prod_req_list[I]).PR_HISTORICAL_REQ := trim(PTMQMPR(read_prod_req_list[I]).PR_HISTORICAL_REQ);
    PTMQMPR(read_prod_req_list[I]).PR_USR_CG := trim(PTMQMPR(read_prod_req_list[I]).PR_USR_CG);
    PTMQMPR(read_prod_req_list[I]).PR_ModulHandled := trim(PTMQMPR(read_prod_req_list[I]).PR_ModulHandled);
    PTMQMPR(read_prod_req_list[I]).PR_FAMILYCODE := trim(PTMQMPR(read_prod_req_list[I]).PR_FAMILYCODE);
//    PTMQMPR(read_prod_req_list[I]).PR_IS_FAMILY := trim(PTMQMPR(read_prod_req_list[I]).PR_IS_FAMILY);
  end;

  result := read_prod_req_list
end;

//----------------------------------------------------------------------------//

function Get_Host_prod_reqhdr_list : TList;
var
  I : Integer;
begin
  for I := 0 to read_prod_reqhdr_list.Count - 1 do
  begin
    PTMQMPH(read_prod_reqhdr_list[I]).PH_PREQ_NO := trim(PTMQMPH(read_prod_reqhdr_list[I]).PH_PREQ_NO);
    PTMQMPH(read_prod_reqhdr_list[I]).PH_HISTORICAL_REQ := trim(PTMQMPH(read_prod_reqhdr_list[I]).PH_HISTORICAL_REQ);
    PTMQMPH(read_prod_reqhdr_list[I]).PH_REQ_ORIGIN := trim(PTMQMPH(read_prod_reqhdr_list[I]).PH_REQ_ORIGIN);
    PTMQMPH(read_prod_reqhdr_list[I]).PH_PROD_LINE := trim(PTMQMPH(read_prod_reqhdr_list[I]).PH_PROD_LINE);
    PTMQMPH(read_prod_reqhdr_list[I]).PH_TYPE_PROD := trim(PTMQMPH(read_prod_reqhdr_list[I]).PH_TYPE_PROD);
    PTMQMPH(read_prod_reqhdr_list[I]).PH_PROD_FAMILY := trim(PTMQMPH(read_prod_reqhdr_list[I]).PH_PROD_FAMILY);
    PTMQMPH(read_prod_reqhdr_list[I]).PH_MATERIAL_FAMILY := trim(PTMQMPH(read_prod_reqhdr_list[I]).PH_MATERIAL_FAMILY);
    PTMQMPH(read_prod_reqhdr_list[I]).PH_PROD_UM := trim(PTMQMPH(read_prod_reqhdr_list[I]).PH_PROD_UM);
    PTMQMPH(read_prod_reqhdr_list[I]).PH_FRC_DEL_DATE := trim(PTMQMPH(read_prod_reqhdr_list[I]).PH_FRC_DEL_DATE);
    PTMQMPH(read_prod_reqhdr_list[I]).PH_SPLITCONFLEVELS := trim(PTMQMPH(read_prod_reqhdr_list[I]).PH_SPLITCONFLEVELS);
    PTMQMPH(read_prod_reqhdr_list[I]).PH_MQM_SPLIT_ID := trim(PTMQMPH(read_prod_reqhdr_list[I]).PH_MQM_SPLIT_ID);
    PTMQMPH(read_prod_reqhdr_list[I]).PH_Serving_Code := trim(PTMQMPH(read_prod_reqhdr_list[I]).PH_Serving_Code);
    PTMQMPH(read_prod_reqhdr_list[I]).PH_Served_Code := trim(PTMQMPH(read_prod_reqhdr_list[I]).PH_Served_Code);
//    PTMQMPH(read_prod_reqhdr_list[I]).PH_MCM_RequestType := trim(PTMQMPH(read_prod_reqhdr_list[I]).PH_MCM_RequestType);
//    PTMQMPH(read_prod_reqhdr_list[I]).PH_MCM_CapacitySearch := trim(PTMQMPH(read_prod_reqhdr_list[I]).PH_MCM_CapacitySearch);
//    PTMQMPH(read_prod_reqhdr_list[I]).PH_MCM_MaterialSearch := trim(PTMQMPH(read_prod_reqhdr_list[I]).PH_MCM_MaterialSearch);
//    PTMQMPH(read_prod_reqhdr_list[I]).PH_MCM_RequestedDateType := trim(PTMQMPH(read_prod_reqhdr_list[I]).PH_MCM_RequestedDateType);
    PTMQMPH(read_prod_reqhdr_list[I]).PH_ModulHandled := trim(PTMQMPH(read_prod_reqhdr_list[I]).PH_ModulHandled);
    PTMQMPH(read_prod_reqhdr_list[I]).PH_Curve_Family_Id_Code := trim(PTMQMPH(read_prod_reqhdr_list[I]).PH_Curve_Family_Id_Code);
  end;

  result := read_prod_reqhdr_list
end;

//----------------------------------------------------------------------------//

function SortPD(Item1, Item2: Pointer) : integer;
var
  MQMPD1 : PTMQMPD;
  MQMPD2 : PTMQMPD;
begin
  MQMPD1 := PTMQMPD(Item1);
  MQMPD2 := PTMQMPD(Item2);
  if (MQMPD1.PD_PREQ_NO < MQMPD2.PD_PREQ_NO) then
    Result := -1
  else if (MQMPD1.PD_PREQ_NO = MQMPD2.PD_PREQ_NO) then
  begin
    if (MQMPD1.PD_PSTEP_ID < MQMPD2.PD_PSTEP_ID) then
      Result := -1
    else if (MQMPD1.PD_PSTEP_ID = MQMPD2.PD_PSTEP_ID) then
      Result := 0
    else
      Result := 1;
  end
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function Get_Host_prod_step_list : TList;
var
  I : Integer;
  PrevRequest1, PrevRequest2, S, TempStrQty : string;
  PrevRecNo1, PrevRecNo2 : longint;
  TotalLeadTimeMqm, TotalLeadTimeBatchMqm, TotalLeadTimeMcm, TotalLeadTimeBatchMcm : currency;
  NumberOfResource, TempNumber : double;
  TempExt : Extended;
begin
  PrevRequest1 := '';
  PrevRecNo1 := -1;
  TotalLeadTimeMqm := 0;
  TotalLeadTimeBatchMqm := 0;
  read_prod_step_list.sort(SortPD);

  PrevRequest2 := '';
  PrevRecNo2 := -1;
  TotalLeadTimeMcm := 0;
  TotalLeadTimeBatchMcm := 0;

  for I := 0 to read_prod_step_list.Count - 1 do
  begin
    PTMQMPD(read_prod_step_list[I]).PD_PREQ_NO := trim(PTMQMPD(read_prod_step_list[I]).PD_PREQ_NO);
    PTMQMPD(read_prod_step_list[I]).PD_TO_SCHED := trim(PTMQMPD(read_prod_step_list[I]).PD_TO_SCHED);
    PTMQMPD(read_prod_step_list[I]).PD_STEP_TYP := trim(PTMQMPD(read_prod_step_list[I]).PD_STEP_TYP);
    PTMQMPD(read_prod_step_list[I]).PD_FRC_MAT_DATE := trim(PTMQMPD(read_prod_step_list[I]).PD_FRC_MAT_DATE);
    PTMQMPD(read_prod_step_list[I]).PD_FRC_LOW_DATE := trim(PTMQMPD(read_prod_step_list[I]).PD_FRC_LOW_DATE);
    PTMQMPD(read_prod_step_list[I]).PD_FRC_HIGH_DATE := trim(PTMQMPD(read_prod_step_list[I]).PD_FRC_HIGH_DATE);
    PTMQMPD(read_prod_step_list[I]).PD_WKCNTER := trim(PTMQMPD(read_prod_step_list[I]).PD_WKCNTER);
    PTMQMPD(read_prod_step_list[I]).PD_WKCT_PROC := trim(PTMQMPD(read_prod_step_list[I]).PD_WKCT_PROC);
    PTMQMPD(read_prod_step_list[I]).PD_DESC_UM := trim(PTMQMPD(read_prod_step_list[I]).PD_DESC_UM);
    PTMQMPD(read_prod_step_list[I]).PD_CAL := trim(PTMQMPD(read_prod_step_list[I]).PD_CAL);
    PTMQMPD(read_prod_step_list[I]).PD_ALLOW_SPLIT := trim(PTMQMPD(read_prod_step_list[I]).PD_ALLOW_SPLIT);
    PTMQMPD(read_prod_step_list[I]).PD_STEP_HANDLE_REPROCES := trim(PTMQMPD(read_prod_step_list[I]).PD_STEP_HANDLE_REPROCES);
    PTMQMPD(read_prod_step_list[I]).PD_STEP_PART_GEN_PLAN := trim(PTMQMPD(read_prod_step_list[I]).PD_STEP_PART_GEN_PLAN);
    PTMQMPD(read_prod_step_list[I]).PD_STEP_CAN_GROUP := trim(PTMQMPD(read_prod_step_list[I]).PD_STEP_CAN_GROUP);
    PTMQMPD(read_prod_step_list[I]).PD_CONN_TYPE_PREV_STEP_SPLIT := trim(PTMQMPD(read_prod_step_list[I]).PD_CONN_TYPE_PREV_STEP_SPLIT);
    PTMQMPD(read_prod_step_list[I]).PD_FRC_OVERLAPP := trim(PTMQMPD(read_prod_step_list[I]).PD_FRC_OVERLAPP);
    PTMQMPD(read_prod_step_list[I]).PD_STEP_CLOSED := trim(PTMQMPD(read_prod_step_list[I]).PD_STEP_CLOSED);
    PTMQMPD(read_prod_step_list[I]).PD_USR_CG := trim(PTMQMPD(read_prod_step_list[I]).PD_USR_CG);
//    PTMQMPD(read_prod_step_list[I]).PD_MCM_ApplyDatePenalty := trim(PTMQMPD(read_prod_step_list[I]).PD_MCM_ApplyDatePenalty);
    PTMQMPD(read_prod_step_list[I]).PD_SchedulByMcm := trim(PTMQMPD(read_prod_step_list[I]).PD_SchedulByMcm);
    PTMQMPD(read_prod_step_list[I]).PD_SplitFamily := trim(PTMQMPD(read_prod_step_list[I]).PD_SplitFamily);
    PTMQMPD(read_prod_step_list[I]).PD_LearningCurveCode := trim(PTMQMPD(read_prod_step_list[I]).PD_LearningCurveCode);
    PTMQMPD(read_prod_step_list[I]).PD_LearningCurveType := trim(PTMQMPD(read_prod_step_list[I]).PD_LearningCurveType);
    PTMQMPD(read_prod_step_list[I]).PD_GRP_SEQUENCE := trim(PTMQMPD(read_prod_step_list[I]).PD_GRP_SEQUENCE);
    PTMQMPD(read_prod_step_list[I]).PD_BatchSizePerStep := trim(PTMQMPD(read_prod_step_list[I]).PD_BatchSizePerStep);
    PTMQMPD(read_prod_step_list[I]).PD_OVERLAP_WITH_OTHER_STEPS := trim(PTMQMPD(read_prod_step_list[I]).PD_OVERLAP_WITH_OTHER_STEPS);

    PTMQMPD(read_prod_step_list[I]).PD_Prev_LeadTime_mqm := 0;
    PTMQMPD(read_prod_step_list[I]).PD_Next_LeadTime_mqm := 0;
    PTMQMPD(read_prod_step_list[I]).PD_Prev_LeadTimeBatch_mqm := 0;
    PTMQMPD(read_prod_step_list[I]).PD_Next_LeadTimeBatch_mqm := 0;

    PTMQMPD(read_prod_step_list[I]).PD_Prev_LeadTime_mcm := 0;
    PTMQMPD(read_prod_step_list[I]).PD_Next_LeadTime_mcm := 0;
    PTMQMPD(read_prod_step_list[I]).PD_Prev_LeadTimeBatch_mcm := 0;
    PTMQMPD(read_prod_step_list[I]).PD_Next_LeadTimeBatch_mcm := 0;

    if (PrevRequest1 <> '') and (PrevRequest1 <> PTMQMPD(read_prod_step_list[I]).PD_PREQ_NO) then
    begin
      if PrevRecNo1 > (-1) then
      begin
        PTMQMPD(read_prod_step_list[PrevRecNo1]).PD_Next_LeadTime_mqm := TotalLeadTimeMqm;
        PTMQMPD(read_prod_step_list[PrevRecNo1]).PD_Next_LeadTimeBatch_mqm := TotalLeadTimeBatchMqm;
      end;

      PrevRecNo1 := -1;
      TotalLeadTimeMqm := 0;
      TotalLeadTimeBatchMqm := 0;
    end;

    // First step of request
    if (PrevRequest1 <> PTMQMPD(read_prod_step_list[I]).PD_PREQ_NO) and (PTMQMPD(read_prod_step_list[I]).PD_SchedulByMqm = '1') then
    begin
      if PTMQMPD(read_prod_step_list[I]).WP_QUEUE_TIME = '1' then
      begin
        TempNumber := PTMQMPD(read_prod_step_list[I]).QUEUE_TIME;
        if (PTMQMPD(read_prod_step_list[I]).QUEUE_TIME > 0) then
          TempNumber :=  Trunc(TempNumber * 100) / 100;
        if TempNumber > 9999999 then TempNumber := 9999999;

        //if PTMQMPD(read_prod_step_list[I]).PD_STEP_TYP = 'B' then
        PTMQMPD(read_prod_step_list[I]).PD_Prev_LeadTimeBatch_mqm := TempNumber
        //else
        //  PTMQMPD(read_prod_step_list[I]).PD_Prev_LeadTime_mqm := TempNumber;
      end;
    end;

    // Last step of request
    if (PTMQMPD(read_prod_step_list[I]).PD_SchedulByMqm = '1') and (PTMQMPD(read_prod_step_list[I]).Wp_POST_PROCESS = '1') then
    begin
      if (I = (read_prod_step_list.Count - 1)) or
         ((I < (read_prod_step_list.Count - 1)) and
         (PTMQMPD(read_prod_step_list[I]).PD_PREQ_NO <> PTMQMPD(read_prod_step_list[I + 1]).PD_PREQ_NO)) then
      begin
         TempNumber := PTMQMPD(read_prod_step_list[I]).POST_PROCESS;
         if (PTMQMPD(read_prod_step_list[I]).POST_PROCESS > 0) then
           TempNumber :=  Trunc(TempNumber * 100) / 100;
         if TempNumber > 9999999 then TempNumber := 9999999;

         //if PTMQMPD(read_prod_step_list[I]).PD_STEP_TYP = 'B' then
         PTMQMPD(read_prod_step_list[I]).PD_Next_LeadTimeBatch_mqm := TempNumber
         //else
         //  PTMQMPD(read_prod_step_list[I]).PD_Next_LeadTime_mqm := TempNumber;
      end;
    end;

    if (PTMQMPD(read_prod_step_list[I]).PD_SchedulByMqm = '1') and (PrevRequest1 = PTMQMPD(read_prod_step_list[I]).PD_PREQ_NO) then
    begin
      if PTMQMPD(read_prod_step_list[I]).WP_QUEUE_TIME = '1' then
      begin
        TempNumber := PTMQMPD(read_prod_step_list[I]).QUEUE_TIME;
        if (PTMQMPD(read_prod_step_list[I]).QUEUE_TIME > 0) then
          TempNumber :=  Trunc(TempNumber * 100) / 100;
        if TempNumber > 9999999 then TempNumber := 9999999;
        //if PTMQMPD(read_prod_step_list[I]).PD_STEP_TYP = 'B' then
        TotalLeadTimeBatchMqm := TotalLeadTimeBatchMqm + TempNumber
        //else
        //  TotalLeadTimeMqm := TotalLeadTimeMqm + TempNumber;
      end;

      if TotalLeadTimeMqm > 9999999 then TotalLeadTimeMqm := 9999999;
      if TotalLeadTimeBatchMqm > 9999999 then TotalLeadTimeBatchMqm := 9999999;

      PTMQMPD(read_prod_step_list[I]).PD_Prev_LeadTime_mqm := TotalLeadTimeMqm;
      PTMQMPD(read_prod_step_list[I]).PD_Prev_LeadTimeBatch_mqm := TotalLeadTimeBatchMqm;
    end;

    if (PTMQMPD(read_prod_step_list[I]).PD_SchedulByMqm = '1') then
    begin
      if PrevRecNo1 > (-1) then
      begin
        PTMQMPD(read_prod_step_list[PrevRecNo1]).PD_Next_LeadTime_mqm := TotalLeadTimeMqm;
        PTMQMPD(read_prod_step_list[PrevRecNo1]).PD_Next_LeadTimeBatch_mqm := TotalLeadTimeBatchMqm;
      end;
      PrevRecNo1 :=  I; // I - 1;
      TotalLeadTimeMqm := 0;
      TotalLeadTimeBatchMqm := 0;
      if PTMQMPD(read_prod_step_list[I]).Wp_POST_PROCESS = '1' then
      begin
        TempNumber := PTMQMPD(read_prod_step_list[I]).POST_PROCESS;
        if (PTMQMPD(read_prod_step_list[I]).POST_PROCESS > 0) then
          TempNumber :=  Trunc(TempNumber * 100) / 100;
        if TempNumber > 9999999 then TempNumber := 9999999;
        //if PTMQMPD(read_prod_step_list[I]).PD_STEP_TYP = 'B' then
        TotalLeadTimeBatchMqm := TempNumber
        //else
        //TotalLeadTimeMqm := TempNumber;
      end;
    end;

    PrevRequest1 := PTMQMPD(read_prod_step_list[I]).PD_PREQ_NO;

    if PTMQMPD(read_prod_step_list[I]).PD_SchedulByMqm <> '1' then
    begin
      if PTMQMPD(read_prod_step_list[I]).PD_RES_NUM_PLN > 0 then
        NumberOfResource := PTMQMPD(read_prod_step_list[I]).PD_RES_NUM_PLN
      else
        NumberOfResource := 1;

      if PTMQMPD(read_prod_step_list[I]).PD_STEP_TYP = 'B' then
      begin
        TotalLeadTimeBatchMqm := TotalLeadTimeBatchMqm + ((PTMQMPD(read_prod_step_list[I]).PD_SETUP_TIME_STP + PTMQMPD(read_prod_step_list[I]).PD_EXC_TIME_STP) / NumberOfResource);

        if PTMQMPD(read_prod_step_list[I]).WP_QUEUE_TIME = '1' then
          TotalLeadTimeBatchMqm := TotalLeadTimeBatchMqm + PTMQMPD(read_prod_step_list[I]).QUEUE_TIME;

        if PTMQMPD(read_prod_step_list[I]).Wp_POST_PROCESS = '1' then
          TotalLeadTimeBatchMqm := TotalLeadTimeBatchMqm + PTMQMPD(read_prod_step_list[I]).POST_PROCESS;

        if TotalLeadTimeBatchMqm > 0 then
           TotalLeadTimeBatchMqm := Trunc(TotalLeadTimeBatchMqm * 100) / 100;
        if TotalLeadTimeBatchMqm > 9999999 then TotalLeadTimeBatchMqm := 9999999;

      end
      else
      begin
        TotalLeadTimeMqm := TotalLeadTimeMqm + ((PTMQMPD(read_prod_step_list[I]).PD_SETUP_TIME_STP + PTMQMPD(read_prod_step_list[I]).PD_EXC_TIME_STP) / NumberOfResource);

        if PTMQMPD(read_prod_step_list[I]).WP_QUEUE_TIME = '1' then
          TotalLeadTimeBatchMqm := TotalLeadTimeBatchMqm + PTMQMPD(read_prod_step_list[I]).QUEUE_TIME;

        if PTMQMPD(read_prod_step_list[I]).Wp_POST_PROCESS = '1' then
          TotalLeadTimeBatchMqm := TotalLeadTimeBatchMqm + PTMQMPD(read_prod_step_list[I]).POST_PROCESS;

        if TotalLeadTimeMqm > 0 then
           TotalLeadTimeMqm := Trunc(TotalLeadTimeMqm * 100) / 100;
        if TotalLeadTimeMqm > 9999999 then TotalLeadTimeMqm := 9999999;

      end;

    end;

    // Mcm handling
    ///////////////////////////////////////////////////////////////////////////////////////////////

    if (PrevRequest2 <> '') and (PrevRequest2 <> PTMQMPD(read_prod_step_list[I]).PD_PREQ_NO) then
    begin
      if PrevRecNo2 > (-1) then
      begin
        PTMQMPD(read_prod_step_list[PrevRecNo2]).PD_Next_LeadTime_mcm := TotalLeadTimeMcm;
        PTMQMPD(read_prod_step_list[PrevRecNo2]).PD_Next_LeadTimeBatch_mcm := TotalLeadTimeBatchMcm;
      end;
      PrevRecNo2 := -1;
      TotalLeadTimeMcm := 0;
      TotalLeadTimeBatchMcm := 0;
    end;


    // First step of request
    if (PrevRequest2 <> PTMQMPD(read_prod_step_list[I]).PD_PREQ_NO) and (PTMQMPD(read_prod_step_list[I]).PD_SchedulByMcm = '1') then
    begin
      if PTMQMPD(read_prod_step_list[I]).WP_QUEUE_TIME = '1' then
      begin
        TempNumber := PTMQMPD(read_prod_step_list[I]).QUEUE_TIME;
        if (PTMQMPD(read_prod_step_list[I]).QUEUE_TIME > 0) then
          TempNumber :=  Trunc(TempNumber * 100) / 100;
        if TempNumber > 9999999 then TempNumber := 9999999;

        //if PTMQMPD(read_prod_step_list[I]).PD_STEP_TYP = 'B' then
        PTMQMPD(read_prod_step_list[I]).PD_Prev_LeadTimeBatch_mcm := TempNumber
        //else
        //  PTMQMPD(read_prod_step_list[I]).PD_Prev_LeadTime_Mcm := TempNumber;
      end;
    end;

    // Last step of request
    if (PTMQMPD(read_prod_step_list[I]).PD_SchedulByMcm = '1') and (PTMQMPD(read_prod_step_list[I]).Wp_POST_PROCESS = '1') then
    begin
      if (I = (read_prod_step_list.Count - 1)) or
         ((I < (read_prod_step_list.Count - 1)) and
         (PTMQMPD(read_prod_step_list[I]).PD_PREQ_NO <> PTMQMPD(read_prod_step_list[I + 1]).PD_PREQ_NO)) then
      begin
         TempNumber := PTMQMPD(read_prod_step_list[I]).POST_PROCESS;
         if (PTMQMPD(read_prod_step_list[I]).POST_PROCESS > 0) then
           TempNumber :=  Trunc(TempNumber * 100) / 100;
         if TempNumber > 9999999 then TempNumber := 9999999;

         //if PTMQMPD(read_prod_step_list[I]).PD_STEP_TYP = 'B' then
         PTMQMPD(read_prod_step_list[I]).PD_Next_LeadTimeBatch_mcm := TempNumber
         //else
         //  PTMQMPD(read_prod_step_list[I]).PD_Next_LeadTime_Mcm := TempNumber;
      end;
    end;

    if (PTMQMPD(read_prod_step_list[I]).PD_SchedulByMcm = '1') and (PrevRequest2 = PTMQMPD(read_prod_step_list[I]).PD_PREQ_NO) then
    begin
      if PTMQMPD(read_prod_step_list[I]).WP_QUEUE_TIME = '1' then
      begin
        TempNumber := PTMQMPD(read_prod_step_list[I]).QUEUE_TIME;
        if (PTMQMPD(read_prod_step_list[I]).QUEUE_TIME > 0) then
          TempNumber :=  Trunc(TempNumber * 100) / 100;
        if TempNumber > 9999999 then TempNumber := 9999999;
        //if PTMQMPD(read_prod_step_list[I]).PD_STEP_TYP = 'B' then
        TotalLeadTimeBatchMcm := TotalLeadTimeBatchMcm + TempNumber
        //else
         // TotalLeadTimeMcm := TotalLeadTimeMcm + TempNumber;
      end;

      if TotalLeadTimeMcm > 9999999 then TotalLeadTimeMcm := 9999999;
      if TotalLeadTimeBatchMcm > 9999999 then TotalLeadTimeBatchMcm := 9999999;

      PTMQMPD(read_prod_step_list[I]).PD_Prev_LeadTime_mcm := TotalLeadTimeMcm;
      PTMQMPD(read_prod_step_list[I]).PD_Prev_LeadTimeBatch_mcm := TotalLeadTimeBatchMcm;
    end;

    if (PTMQMPD(read_prod_step_list[I]).PD_SchedulByMcm = '1') then
    begin
      if PrevRecNo2 > (-1) then
      begin
        PTMQMPD(read_prod_step_list[PrevRecNo2]).PD_Next_LeadTime_mcm := TotalLeadTimeMcm;
        PTMQMPD(read_prod_step_list[PrevRecNo2]).PD_Next_LeadTimeBatch_mcm := TotalLeadTimeBatchMcm;
      end;
      PrevRecNo2 :=  I; // I - 1;
      TotalLeadTimeMcm := 0;
      TotalLeadTimeBatchMcm := 0;
      if PTMQMPD(read_prod_step_list[I]).Wp_POST_PROCESS = '1' then
      begin
        TempNumber := PTMQMPD(read_prod_step_list[I]).POST_PROCESS;
        if (PTMQMPD(read_prod_step_list[I]).POST_PROCESS > 0) then
          TempNumber :=  Trunc(TempNumber * 100) / 100;
        if TempNumber > 9999999 then TempNumber := 9999999;
        //if PTMQMPD(read_prod_step_list[I]).PD_STEP_TYP = 'B' then
        TotalLeadTimeBatchMcm := TempNumber
        //else
        //  TotalLeadTimeMcm := TempNumber;
      end;
    end;

    PrevRequest2 := PTMQMPD(read_prod_step_list[I]).PD_PREQ_NO;

    if PTMQMPD(read_prod_step_list[I]).PD_SchedulByMcm <> '1' then
    begin
      if PTMQMPD(read_prod_step_list[I]).PD_RES_NUM_PLN > 0 then
        NumberOfResource := PTMQMPD(read_prod_step_list[I]).PD_RES_NUM_PLN
      else
        NumberOfResource := 1;

      if PTMQMPD(read_prod_step_list[I]).PD_STEP_TYP = 'B' then
      begin
        TotalLeadTimeBatchMcm := TotalLeadTimeBatchMcm + ((PTMQMPD(read_prod_step_list[I]).PD_SETUP_TIME_STP + PTMQMPD(read_prod_step_list[I]).PD_EXC_TIME_STP) / NumberOfResource);

        if PTMQMPD(read_prod_step_list[I]).WP_QUEUE_TIME = '1' then
          TotalLeadTimeBatchMcm := TotalLeadTimeBatchMcm + PTMQMPD(read_prod_step_list[I]).QUEUE_TIME;

        if PTMQMPD(read_prod_step_list[I]).Wp_POST_PROCESS = '1' then
          TotalLeadTimeBatchMcm := TotalLeadTimeBatchMcm + PTMQMPD(read_prod_step_list[I]).POST_PROCESS;

        if TotalLeadTimeBatchMcm > 0 then
           TotalLeadTimeBatchMcm := Trunc(TotalLeadTimeBatchMcm * 100) / 100;
        if TotalLeadTimeBatchMcm > 9999999 then TotalLeadTimeBatchMcm := 9999999;

      end
      else
      begin
        TotalLeadTimeMcm := TotalLeadTimeMcm + ((PTMQMPD(read_prod_step_list[I]).PD_SETUP_TIME_STP + PTMQMPD(read_prod_step_list[I]).PD_EXC_TIME_STP) / NumberOfResource);

        if PTMQMPD(read_prod_step_list[I]).WP_QUEUE_TIME = '1' then
          TotalLeadTimeBatchMcm := TotalLeadTimeBatchMcm + PTMQMPD(read_prod_step_list[I]).QUEUE_TIME;

        if PTMQMPD(read_prod_step_list[I]).Wp_POST_PROCESS = '1' then
          TotalLeadTimeBatchMcm := TotalLeadTimeBatchMcm + PTMQMPD(read_prod_step_list[I]).POST_PROCESS;

        if TotalLeadTimeMcm > 0 then
           TotalLeadTimeMcm := Trunc(TotalLeadTimeMcm * 100) / 100;
        if TotalLeadTimeMcm > 9999999 then TotalLeadTimeMcm := 9999999;

      end;

    end;


    //old part mcm

    {if (PTMQMPD(read_prod_step_list[I]).PD_SchedulByMcm = '1') and (PrevRequest2 = PTMQMPD(read_prod_step_list[I]).PD_PREQ_NO) then
    begin
      PTMQMPD(read_prod_step_list[I]).PD_Prev_LeadTime_mcm := TotalLeadTimeMcm;
      PTMQMPD(read_prod_step_list[I]).PD_Prev_LeadTimeBatch_mcm := TotalLeadTimeBatchMcm;
    end;

    if (PTMQMPD(read_prod_step_list[I]).PD_SchedulByMcm = '1') then
    begin
      if PrevRecNo2 > (-1) then
      begin
        PTMQMPD(read_prod_step_list[PrevRecNo2]).PD_Next_LeadTime_mcm := TotalLeadTimeMcm;
        PTMQMPD(read_prod_step_list[PrevRecNo2]).PD_Next_LeadTimeBatch_mcm := TotalLeadTimeBatchMcm;
      end;
      PrevRecNo2 :=  I; // I - 1;
      TotalLeadTimeMcm := 0;
      TotalLeadTimeBatchMcm := 0;
    end;

    PrevRequest2 := PTMQMPD(read_prod_step_list[I]).PD_PREQ_NO;

    if PTMQMPD(read_prod_step_list[I]).PD_SchedulByMcm <> '1' then
    begin
      if PTMQMPD(read_prod_step_list[I]).PD_RES_NUM_PLN > 0 then
        NumberOfResource := PTMQMPD(read_prod_step_list[I]).PD_RES_NUM_PLN
      else
        NumberOfResource := 1;

      if PTMQMPD(read_prod_step_list[I]).PD_STEP_TYP = 'B' then
         TotalLeadTimeBatchMcm := TotalLeadTimeBatchMcm + ((PTMQMPD(read_prod_step_list[I]).PD_SETUP_TIME_STP + PTMQMPD(read_prod_step_list[I]).PD_EXC_TIME_STP) / NumberOfResource)
      else
      TotalLeadTimeMcm := TotalLeadTimeMcm + ((PTMQMPD(read_prod_step_list[I]).PD_SETUP_TIME_STP + PTMQMPD(read_prod_step_list[I]).PD_EXC_TIME_STP) / NumberOfResource);
      if TotalLeadTimeMcm > 0 then
         TotalLeadTimeMcm := Trunc(TotalLeadTimeMcm * 100) / 100;
      if TotalLeadTimeMcm > 9999999 then TotalLeadTimeMcm := 9999999;

    end;   }

  end;

  if PrevRecNo1 > (-1) then
  begin
     PTMQMPD(read_prod_step_list[PrevRecNo1]).PD_Next_LeadTime_mqm := TotalLeadTimeMqm;
     PTMQMPD(read_prod_step_list[PrevRecNo1]).PD_Next_LeadTimeBatch_mqm := TotalLeadTimeBatchMqm;
  end;

  if PrevRecNo2 > (-1) then
  begin
     PTMQMPD(read_prod_step_list[PrevRecNo2]).PD_Next_LeadTime_mcm := TotalLeadTimeMcm;
     PTMQMPD(read_prod_step_list[PrevRecNo2]).PD_Next_LeadTimeBatch_mcm := TotalLeadTimeBatchMcm;
  end;

  for I := 0 to read_prod_step_list.Count - 1 do
  begin
    if PTMQMPD(read_prod_step_list[I]).PD_Next_LeadTime_mqm > 0 then
    begin
      TempExt := Frac(PTMQMPD(read_prod_step_list[I]).PD_Next_LeadTime_mqm);
      S := FloatToStr(TempExt);
      if Length(S) > 4 then
      begin
        S := Copy(s, 2, 3);
        TempStrQty := FloatToStr(trunc(PTMQMPD(read_prod_step_list[I]).PD_Next_LeadTime_mqm));
        TempStrQty := TempStrQty + s;
        PTMQMPD(read_prod_step_list[I]).PD_Next_LeadTime_mqm := StrToFloat(TempStrQty);
      end;
    end;

    if PTMQMPD(read_prod_step_list[I]).PD_Next_LeadTimeBatch_mqm > 0 then
    begin
      TempExt := Frac(PTMQMPD(read_prod_step_list[I]).PD_Next_LeadTimeBatch_mqm);
      S := FloatToStr(TempExt);
      if Length(S) > 4 then
      begin
        S := Copy(s, 2, 3);
        TempStrQty := FloatToStr(trunc(PTMQMPD(read_prod_step_list[I]).PD_Next_LeadTimeBatch_mqm));
        TempStrQty := TempStrQty + s;
        PTMQMPD(read_prod_step_list[I]).PD_Next_LeadTimeBatch_mqm := StrToFloat(TempStrQty);
      end;
    end;

    if PTMQMPD(read_prod_step_list[I]).PD_Prev_LeadTime_mqm > 0 then
    begin
      TempExt := Frac(PTMQMPD(read_prod_step_list[I]).PD_Prev_LeadTime_mqm);
      S := FloatToStr(TempExt);
      if Length(S) > 4 then
      begin
        S := Copy(s, 2, 3);
        TempStrQty := FloatToStr(trunc(PTMQMPD(read_prod_step_list[I]).PD_Prev_LeadTime_mqm));
        TempStrQty := TempStrQty + s;
        PTMQMPD(read_prod_step_list[I]).PD_Prev_LeadTime_mqm := StrToFloat(TempStrQty);
      end;
    end;

    if PTMQMPD(read_prod_step_list[I]).PD_Prev_LeadTimeBatch_mqm > 0 then
    begin
      TempExt := Frac(PTMQMPD(read_prod_step_list[I]).PD_Prev_LeadTimeBatch_mqm);
      S := FloatToStr(TempExt);
      if Length(S) > 4 then
      begin
        S := Copy(s, 2, 3);
        TempStrQty := FloatToStr(trunc(PTMQMPD(read_prod_step_list[I]).PD_Prev_LeadTimeBatch_mqm));
        TempStrQty := TempStrQty + s;
        PTMQMPD(read_prod_step_list[I]).PD_Prev_LeadTimeBatch_mqm := StrToFloat(TempStrQty);
      end;
    end;

    if PTMQMPD(read_prod_step_list[I]).PD_Next_LeadTime_mcm > 0 then
    begin
      TempExt := Frac(PTMQMPD(read_prod_step_list[I]).PD_Next_LeadTime_mcm);
      S := FloatToStr(TempExt);
      if Length(S) > 4 then
      begin
        S := Copy(s, 2, 3);
        TempStrQty := FloatToStr(trunc(PTMQMPD(read_prod_step_list[I]).PD_Next_LeadTime_mcm));
        TempStrQty := TempStrQty + s;
        PTMQMPD(read_prod_step_list[I]).PD_Next_LeadTime_mcm := StrToFloat(TempStrQty);
      end;
    end;

    if PTMQMPD(read_prod_step_list[I]).PD_Next_LeadTimeBatch_mcm > 0 then
    begin
      TempExt := Frac(PTMQMPD(read_prod_step_list[I]).PD_Next_LeadTimeBatch_mcm);
      S := FloatToStr(TempExt);
      if Length(S) > 4 then
      begin
        S := Copy(s, 2, 3);
        TempStrQty := FloatToStr(trunc(PTMQMPD(read_prod_step_list[I]).PD_Next_LeadTimeBatch_mcm));
        TempStrQty := TempStrQty + s;
        PTMQMPD(read_prod_step_list[I]).PD_Next_LeadTimeBatch_mcm := StrToFloat(TempStrQty);
      end;
    end;

    if PTMQMPD(read_prod_step_list[I]).PD_Prev_LeadTime_mcm > 0 then
    begin
      TempExt := Frac(PTMQMPD(read_prod_step_list[I]).PD_Prev_LeadTime_mcm);
      S := FloatToStr(TempExt);
      if Length(S) > 4 then
      begin
        S := Copy(s, 2, 3);
        TempStrQty := FloatToStr(trunc(PTMQMPD(read_prod_step_list[I]).PD_Prev_LeadTime_mcm));
        TempStrQty := TempStrQty + s;
        PTMQMPD(read_prod_step_list[I]).PD_Prev_LeadTime_mcm := StrToFloat(TempStrQty);
      end;
    end;

    if PTMQMPD(read_prod_step_list[I]).PD_Prev_LeadTimeBatch_mcm > 0 then
    begin
      TempExt := Frac(PTMQMPD(read_prod_step_list[I]).PD_Prev_LeadTimeBatch_mcm);
      S := FloatToStr(TempExt);
      if Length(S) > 4 then
      begin
        S := Copy(s, 2, 3);
        TempStrQty := FloatToStr(trunc(PTMQMPD(read_prod_step_list[I]).PD_Prev_LeadTimeBatch_mcm));
        TempStrQty := TempStrQty + s;
        PTMQMPD(read_prod_step_list[I]).PD_Prev_LeadTimeBatch_mcm := StrToFloat(TempStrQty);
      end;

    end;
  end;


  result := read_prod_step_list

end;

//----------------------------------------------------------------------------//

function Get_Host_prod_step_time_list : TList;
var
  I : Integer;
  TempExt : Extended;
  S : string;
  TempStrQty : String;
begin
  for I := 0 to read_prod_step_time_list.Count - 1 do
  begin
    PTMQMST(read_prod_step_time_list[I]).ST_PREQ_NO := trim(PTMQMST(read_prod_step_time_list[I]).ST_PREQ_NO);
    PTMQMST(read_prod_step_time_list[I]).ST_PSTEP_ID := PTMQMST(read_prod_step_time_list[I]).ST_PSTEP_ID;
    PTMQMST(read_prod_step_time_list[I]).ST_WKCNTER := trim(PTMQMST(read_prod_step_time_list[I]).ST_WKCNTER);
    PTMQMST(read_prod_step_time_list[I]).ST_WKCT_PROC := trim(PTMQMST(read_prod_step_time_list[I]).ST_WKCT_PROC);
    PTMQMST(read_prod_step_time_list[I]).ST_RES_CATEGORY := trim(PTMQMST(read_prod_step_time_list[I]).ST_RES_CATEGORY);
    PTMQMST(read_prod_step_time_list[I]).ST_RSC_CODE := trim(PTMQMST(read_prod_step_time_list[I]).ST_RSC_CODE);
    PTMQMST(read_prod_step_time_list[I]).ST_SEQCHAR := trim(PTMQMST(read_prod_step_time_list[I]).ST_SEQCHAR);
    PTMQMST(read_prod_step_time_list[I]).ST_SETUP_TIME_Mechin_Code := trim(PTMQMST(read_prod_step_time_list[I]).ST_SETUP_TIME_Mechin_Code);
    PTMQMST(read_prod_step_time_list[I]).ST_MATERIAL := trim(PTMQMST(read_prod_step_time_list[I]).ST_MATERIAL);

    TempExt := Frac(PTMQMST(read_prod_step_time_list[I]).ST_SETUP_TIME_JOB);
    S := FloatToStr(TempExt);
    if Length(S) > 4 then
    begin
      S := Copy(s, 2, 4);
      TempStrQty := FloatToStr(trunc(PTMQMST(read_prod_step_time_list[I]).ST_SETUP_TIME_JOB));
      TempStrQty := TempStrQty + S;
      PTMQMST(read_prod_step_time_list[I]).ST_SETUP_TIME_JOB := StrToFloat(TempStrQty);
    end;

    TempExt := Frac(PTMQMST(read_prod_step_time_list[I]).ST_EXC_TIME_INIT_QTY);
    S := FloatToStr(TempExt);
    if Length(S) > 4 then
    begin
      S := Copy(s, 2, 4);
      TempStrQty := FloatToStr(trunc(PTMQMST(read_prod_step_time_list[I]).ST_EXC_TIME_INIT_QTY));
      TempStrQty := TempStrQty + S;
      PTMQMST(read_prod_step_time_list[I]).ST_EXC_TIME_INIT_QTY := StrToFloat(TempStrQty);
    end;

  end;

  result := read_prod_step_time_list
end;

//----------------------------------------------------------------------------//

function Get_Host_prop_prod_list(out bSortNeeded: Boolean) : TList;
var
  I        : Integer;
  Rec      : PTMQMPP;
  sPrevKey : string;
begin
  bSortNeeded := False;
  sPrevKey    := '';
  for I := 0 to read_prop_prod_list.Count - 1 do
  begin
    Rec := PTMQMPP(read_prop_prod_list[I]);
    Rec.PP_PREQ_NO  := Trim(Rec.PP_PREQ_NO);
    Rec.PP_RSC_CODE := Trim(Rec.PP_RSC_CODE);
    Rec.PP_PROPERTY := Trim(Rec.PP_PROPERTY);
    Rec.PP_VALUE    := Trim(Rec.PP_VALUE);
    Rec.PP_USR_CG   := Trim(Rec.PP_USR_CG);
    Rec.PP_SortKey  := Rec.PP_PREQ_NO + Chr(1) +
                       Format('%010d', [Rec.PP_PSTEP_ID]) + Chr(1) +
                       Rec.PP_PROPERTY + Chr(1) +
                       Rec.PP_RSC_CODE;
    if Rec.PP_SortKey < sPrevKey then
      bSortNeeded := True;
    sPrevKey := Rec.PP_SortKey;
  end;
  Result := read_prop_prod_list;
end;

//----------------------------------------------------------------------------//

function Get_Host_prod_step_batch_size_list : TList;
var
  I : Integer;
  TempExt : Extended;
  S : string;
  TempStrQty : String;
begin
  for I := 0 to read_prod_step_batch_size_list.Count - 1 do
  begin
    PTMQMSB(read_prod_step_batch_size_list[I]).SB_PREQ_NO := trim(PTMQMSB(read_prod_step_batch_size_list[I]).SB_PREQ_NO);
    PTMQMSB(read_prod_step_batch_size_list[I]).SB_BCH_UM := trim(PTMQMSB(read_prod_step_batch_size_list[I]).SB_BCH_UM);
    TempExt := Frac(PTMQMSB(read_prod_step_batch_size_list[I]).SB_MULTIPILR_TO_BATCH_UM);
    S := FloatToStr(TempExt);
    if Length(S) > 5 then
    begin
      S := Copy(s, 2, 5);
      TempStrQty := FloatToStr(trunc(PTMQMSB(read_prod_step_batch_size_list[I]).SB_MULTIPILR_TO_BATCH_UM));
      TempStrQty := TempStrQty + S;
      PTMQMSB(read_prod_step_batch_size_list[I]).SB_MULTIPILR_TO_BATCH_UM := StrToFloat(TempStrQty);
    end;
  end;
  result := read_prod_step_batch_size_list
end;

//----------------------------------------------------------------------------//

function Get_Host_prod_info_list : TList;
var
  I : Integer;
begin
  for I := 0 to read_prod_info_list.Count - 1 do
  begin
    PTMQMPI(read_prod_info_list[I]).PI_PREQ_NO := trim(PTMQMPI(read_prod_info_list[I]).PI_PREQ_NO);
    PTMQMPI(read_prod_info_list[I]).PI_INFO_TYPE := trim(PTMQMPI(read_prod_info_list[I]).PI_INFO_TYPE);
    PTMQMPI(read_prod_info_list[I]).PI_INFO_AREA := trim(PTMQMPI(read_prod_info_list[I]).PI_INFO_AREA);
    PTMQMPI(read_prod_info_list[I]).PI_USR_CG := trim(PTMQMPI(read_prod_info_list[I]).PI_USR_CG);
  end;

  result := read_prod_info_list
end;

//----------------------------------------------------------------------------//

function Get_Host_prod_reqConn_list : TList;
var
  I : Integer;
begin
  for I := 0 to read_prod_reqConn_list.Count - 1 do
  begin
    PTMQMIC(read_prod_reqConn_list[I]).IC_PREQ_NO := trim(PTMQMIC(read_prod_reqConn_list[I]).IC_PREQ_NO);
    PTMQMIC(read_prod_reqConn_list[I]).IC_PREV_PREQ_NO := trim(PTMQMIC(read_prod_reqConn_list[I]).IC_PREV_PREQ_NO);
    PTMQMIC(read_prod_reqConn_list[I]).IC_USR_CG := trim(PTMQMIC(read_prod_reqConn_list[I]).IC_USR_CG);
  end;
  result := read_prod_reqConn_list
end;

//----------------------------------------------------------------------------//

function Get_Host_ext_connection_list : TList;
var
  I : Integer;
begin
  for I := 0 to read_ext_connection_list.Count - 1 do
  begin
    PTMQMEC(read_ext_connection_list[I]).EC_PREQ_NO := trim(PTMQMEC(read_ext_connection_list[I]).EC_PREQ_NO);
    PTMQMEC(read_ext_connection_list[I]).EC_CONNE_KEY := trim(PTMQMEC(read_ext_connection_list[I]).EC_CONNE_KEY);
    PTMQMEC(read_ext_connection_list[I]).EC_CONN_CERTENT_LEVEL := trim(PTMQMEC(read_ext_connection_list[I]).EC_CONN_CERTENT_LEVEL);
    PTMQMEC(read_ext_connection_list[I]).EC_USR_CG := trim(PTMQMEC(read_ext_connection_list[I]).EC_USR_CG);
  end;
  result := read_ext_connection_list
end;

//----------------------------------------------------------------------------//

function Get_Host_ext_info_hdr_list : TList;
var
  I : Integer;
begin
  for I := 0 to read_ext_info_hdr_list.Count - 1 do
  begin
    PRecEH(read_ext_info_hdr_list[I]).EH_ConnKey := trim(PRecEH(read_ext_info_hdr_list[I]).EH_ConnKey);
    PRecEH(read_ext_info_hdr_list[I]).EH_ConnType := trim(PRecEH(read_ext_info_hdr_list[I]).EH_ConnType);
    PRecEH(read_ext_info_hdr_list[I]).EH_usrCg := trim(PRecEH(read_ext_info_hdr_list[I]).EH_usrCg);
  end;
  result := read_ext_info_hdr_list
end;

//----------------------------------------------------------------------------//

function Get_Host_ext_info_list : TList;
var
  I : Integer;
begin
  for I := 0 to read_ext_info_list.Count - 1 do
  begin
    PRecEI(read_ext_info_list[I]).EI_ConnKey := trim(PRecEI(read_ext_info_list[I]).EI_ConnKey);
    PRecEI(read_ext_info_list[I]).EI_InfoArea := trim(PRecEI(read_ext_info_list[I]).EI_InfoArea);
    PRecEI(read_ext_info_list[I]).EI_usrCg := trim(PRecEI(read_ext_info_list[I]).EI_usrCg);
  end;
  result := read_ext_info_list
end;

//----------------------------------------------------------------------------//

function Get_Host_Material_Schedule : TList;
var
  I : Integer;
  TempExt : Extended;
  S : string;
  TempStrQty : String;
begin
  for I := 0 to read_Material_Schedule_list.Count - 1 do
  begin
    TempExt := Frac(PRecMS(read_Material_Schedule_list[I]).MS_Quantity);
    S := FloatToStr(TempExt);
    if Length(S) > 3 then
    begin
      S := Copy(s, 2, 3);
      TempStrQty := FloatToStr(trunc(PRecMS(read_Material_Schedule_list[I]).MS_Quantity));
      TempStrQty := TempStrQty + S;
      PRecMS(read_Material_Schedule_list[I]).MS_Quantity := StrToFloat(TempStrQty);
    end;
  end;
  result := read_Material_Schedule_list
end;

//----------------------------------------------------------------------------//

function Get_Host_Material_Schedule_Link : TList;
begin
  result := read_Material_Schedule_list_Link
end;

//----------------------------------------------------------------------------//

{function Get_Host_balance_header_list : TList;
type
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
var
  I : Integer;
begin
  for I := 0 to read_balance_header_list.Count - 1 do
  begin
    PRecBH(read_balance_header_list[I]).BH_ProdType := trim(PRecBH(read_balance_header_list[I]).BH_ProdType);
    PRecBH(read_balance_header_list[I]).BH_InfoArea := trim(PRecBH(read_balance_header_list[I]).BH_InfoArea);
    PRecBH(read_balance_header_list[I]).BH_ProdCode := trim(PRecBH(read_balance_header_list[I]).BH_ProdCode);
    PRecBH(read_balance_header_list[I]).BH_netGroupCode := trim(PRecBH(read_balance_header_list[I]).BH_netGroupCode);
    PRecBH(read_balance_header_list[I]).BH_usrCg := trim(PRecBH(read_balance_header_list[I]).BH_usrCg);
  end;
  result := read_balance_header_list
end; }

//----------------------------------------------------------------------------//

function Get_Host_balance_header_list: TList;
var
  I : Integer;
  RecI : PRecBH;
begin
  // First: trim fields
  for I := 0 to read_balance_header_list.Count - 1 do
  begin
    RecI := PRecBH(read_balance_header_list[I]);
    RecI^.BH_ProdType := Trim(RecI^.BH_ProdType);
    RecI^.BH_InfoArea := Trim(RecI^.BH_InfoArea);
    RecI^.BH_ProdCode := Trim(RecI^.BH_ProdCode);
    RecI^.BH_netGroupCode := Trim(RecI^.BH_netGroupCode);
    RecI^.BH_usrCg := Trim(RecI^.BH_usrCg);
  end;

  Result := read_balance_header_list;
end;

//----------------------------------------------------------------------------//

procedure Merge_Host_balance_header_list(list : TList);
var
  I, J: Integer;
  RecI, RecJ: PRecBH;
begin
  // Second: group + sum duplicates
  I := 0;
  while I < read_balance_header_list.Count do
  begin
    RecI := PRecBH(read_balance_header_list[I]);

    J := I + 1;
    while J < read_balance_header_list.Count do
    begin
      RecJ := PRecBH(read_balance_header_list[J]);

      // Compare the 4 key fields
      if (RecI^.BH_ProdType = RecJ^.BH_ProdType) and
         (RecI^.BH_dueDate  = RecJ^.BH_dueDate)  and
         (RecI^.BH_InfoArea = RecJ^.BH_InfoArea) and
         (RecI^.BH_ProdCode = RecJ^.BH_ProdCode) and
         (RecI^.BH_netGroupCode = RecJ^.BH_netGroupCode) then
      begin
        RecI^.BH_quant := RecI^.BH_quant + RecJ^.BH_quant;
        Dispose(RecJ);
        read_balance_header_list.Delete(J);
        // DO NOT increment J (list shifted)
        continue
      end;
      break;
    end;

    Inc(I);
  end;
end;

//----------------------------------------------------------------------------//

function Get_Host_produced_article_list : TList;
var
  I : Integer;
begin
  for I := 0 to read_produced_article_list.Count - 1 do
  begin
    PTMQMPA(read_produced_article_list[I]).PA_PROD_REQ_NR := trim(PTMQMPA(read_produced_article_list[I]).PA_PROD_REQ_NR);
    PTMQMPA(read_produced_article_list[I]).PA_SEQUENCE := trim(PTMQMPA(read_produced_article_list[I]).PA_SEQUENCE);
    PTMQMPA(read_produced_article_list[I]).PA_PROD_CODE := trim(PTMQMPA(read_produced_article_list[I]).PA_PROD_CODE);
    PTMQMPA(read_produced_article_list[I]).PA_NET_GROUP_Code := trim(PTMQMPA(read_produced_article_list[I]).PA_NET_GROUP_Code);
    PTMQMPA(read_produced_article_list[I]).PA_ALL_REQ := trim(PTMQMPA(read_produced_article_list[I]).PA_ALL_REQ);
    PTMQMPA(read_produced_article_list[I]).PA_PROD_BALANCE := trim(PTMQMPA(read_produced_article_list[I]).PA_PROD_BALANCE);
    PTMQMPA(read_produced_article_list[I]).PA_RESOURCE := trim(PTMQMPA(read_produced_article_list[I]).PA_RESOURCE);
    PTMQMPA(read_produced_article_list[I]).PA_SETTLED := trim(PTMQMPA(read_produced_article_list[I]).PA_SETTLED);
  end;
  result := read_produced_article_list
end;

//----------------------------------------------------------------------------//

function Get_Host_material_list : TList;
var
  I : Integer;
  TempExt : Extended;
  S : string;
  TempStrQty : String;
begin
  for I := 0 to read_material_list.Count - 1 do
  begin
    PTMQMMT(read_material_list[I]).MT_PROD_REQ_Nr := trim(PTMQMMT(read_material_list[I]).MT_PROD_REQ_Nr);
    PTMQMMT(read_material_list[I]).MT_WKCTR_CODE := trim(PTMQMMT(read_material_list[I]).MT_WKCTR_CODE);
    PTMQMMT(read_material_list[I]).MT_RES_CAT_CODE := trim(PTMQMMT(read_material_list[I]).MT_RES_CAT_CODE);
    PTMQMMT(read_material_list[I]).MT_RES_CODE := trim(PTMQMMT(read_material_list[I]).MT_RES_CODE);
    PTMQMMT(read_material_list[I]).MT_MACHIN_SETUP_CODE := trim(PTMQMMT(read_material_list[I]).MT_MACHIN_SETUP_CODE);
    PTMQMMT(read_material_list[I]).MT_ALTERNATIVE_CODE := trim(PTMQMMT(read_material_list[I]).MT_ALTERNATIVE_CODE);
    PTMQMMT(read_material_list[I]).MT_PROD_TYPE := trim(PTMQMMT(read_material_list[I]).MT_PROD_TYPE);
    PTMQMMT(read_material_list[I]).MT_PROD_CODE := trim(PTMQMMT(read_material_list[I]).MT_PROD_CODE);
    PTMQMMT(read_material_list[I]).MT_NET_GROUP_CODE := trim(PTMQMMT(read_material_list[I]).MT_NET_GROUP_CODE);
    PTMQMMT(read_material_list[I]).MT_ISSUE_CODE := trim(PTMQMMT(read_material_list[I]).MT_ISSUE_CODE);
    PTMQMMT(read_material_list[I]).MT_SEQ_ISSUED := trim(PTMQMMT(read_material_list[I]).MT_SEQ_ISSUED);
    PTMQMMT(read_material_list[I]).MT_MAT_BALACE := trim(PTMQMMT(read_material_list[I]).MT_MAT_BALACE);
    PTMQMMT(read_material_list[I]).MT_SETTLED := trim(PTMQMMT(read_material_list[I]).MT_SETTLED);
    PTMQMMT(read_material_list[I]).MT_SEARCH_MAT_BY_ALLOC := trim(PTMQMMT(read_material_list[I]).MT_SEARCH_MAT_BY_ALLOC);
    PTMQMMT(read_material_list[I]).ToBeDeleted := trim(PTMQMMT(read_material_list[I]).ToBeDeleted);
    TempExt := Frac(PTMQMMT(read_material_list[I]).MT_QUANTITY_ISSUE);
    S := FloatToStr(TempExt);
    if Length(S) > 3 then
    begin
      S := Copy(s, 2, 3);
      TempStrQty := FloatToStr(trunc(PTMQMMT(read_material_list[I]).MT_QUANTITY_ISSUE));
      TempStrQty := TempStrQty + S;
      PTMQMMT(read_material_list[I]).MT_QUANTITY_ISSUE := StrToFloat(TempStrQty);
    end;
  end;

  result := read_material_list
end;

//----------------------------------------------------------------------------//

function Get_Host_Progress_List : TList;
begin
  result := read_Progress_list
end;

//----------------------------------------------------------------------------//

function Get_Host_Productproperty : TList;
begin
  result := read_Productproperty_list
end;

//----------------------------------------------------------------------------//

function Get_PDS_BASEPRIMARYUOMCODE_Index : integer;
begin
  Result := PDS_BASEPRIMARYUOMCODE
end;

//----------------------------------------------------------------------------//

function Get_PDS_USERPRIMARYUOMCODE_Index : integer;
begin
  Result := PDS_USERPRIMARYUOMCODE
end;

//----------------------------------------------------------------------------//

function Get_PDS_BASESECONDARYUOMCODE_Index : integer;
begin
  Result := PDS_BASESECONDARYUOMCODE
end;

//----------------------------------------------------------------------------//

function Get_PDS_USERSECONDARYUOMCODE_Index : integer;
begin
  Result := PDS_USERSECONDARYUOMCODE
end;

//----------------------------------------------------------------------------//

function Get_PDS_USERPACKAGINGUOMCODE_Index : integer;
begin
  Result := PDS_USERPACKAGINGUOMCODE
end;


//----------------------------------------------------------------------------//

function Get_PDS_INITIALBASEPRIMARYQUANTITY_Index : integer;
begin
  Result := PDS_INITIALBASEPRIMARYQUANTITY
end;

//----------------------------------------------------------------------------//

function Get_PDS_INITIALUSERPRIMARYQUANTITY_Index : integer;
begin
  Result := PDS_INITIALUSERPRIMARYQUANTITY
end;

//----------------------------------------------------------------------------//

function Get_PDS_INITIALBASESECONDARYQUANTITY_Index : integer;
begin
  Result := PDS_INITIALBASESECONDARYQUANTITY
end;

//----------------------------------------------------------------------------//

function Get_PDS_INITIALUSERSECONDARYQUANTITY_Index : integer;
begin
  Result := PDS_INITIALUSERSECONDARYQUANTITY
end;

//----------------------------------------------------------------------------//

function Get_PDS_INITIALUSERPACKAGINGQUANTITY_Index : integer;
begin
  Result := PDS_INITIALUSERPACKAGINGQUANTITY
end;

//----------------------------------------------------------------------------//

procedure CreateProdCont;
begin
  if not assigned(m_ProdCont) then
    m_ProdCont := TProdCont.Create;
 end;

//----------------------------------------------------------------------------//

procedure ClearStructMemoryList;
begin
  m_ProdCont.ClearStructMemoryList;
end;

//----------------------------------------------------------------------------//

function SortProp_Prod_For_BuiltProp(Item1, Item2: Pointer) : integer;
var
  MQMPP1 : PTMQMPP;
  MQMPP2 : PTMQMPP;
begin
  MQMPP1 := PTMQMPP(Item1);
  MQMPP2 := PTMQMPP(Item2);
  if (MQMPP1.PP_PREQ_NO < MQMPP2.PP_PREQ_NO) then
    Result := -1
  else if (MQMPP1.PP_PREQ_NO = MQMPP2.PP_PREQ_NO) then
  begin
    if (MQMPP1.PP_PSTEP_ID < MQMPP2.PP_PSTEP_ID) then
      Result := -1
    else if (MQMPP1.PP_PSTEP_ID = MQMPP2.PP_PSTEP_ID) then
      Result := 0
    else
      Result := 1;
  end
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function FindBuildedProp(PropsList : TList; PropCode : string; var PosInList : integer) : boolean;
var
  J : Integer;
begin
  result := false;
  PosInList := -1;
  for J := 0 to PropsList.Count - 1 do
  begin
    if (PTMQMPP(PropsList[J]).PP_PROPERTY = PropCode) then
    begin
      Result := true;
      PosInList := J;
      Exit;
    end;
  end;
end;

//----------------------------------------------------------------------------//

{procedure UpdateBuildedPropertyFromOtherProperty;
var
  PropBuildFromOtherPropsList, TempList, AddToPropProdList : TList;
  I, J, P, V, Pos : Integer;
  Value1 ,Value2, Value3 ,Value4, Value5 : string;
  NEW_PROP_PROD: PTMQMPP;
  Request, NewRequest : string;
  step, NewStep : integer;
  IncValues : integer;
  PROPERTY_BUILD_FROM_OTHER : PTPROPERTY_BUILD_FROM_OTHER;
begin
  PropBuildFromOtherPropsList := TList.Create;
  if not GetPropBuildFromOtherPropsList(PropBuildFromOtherPropsList) then
  begin
    PropBuildFromOtherPropsList.Free;
    Exit;
  end;

  Request := '';
  step    := -1;
  TempList := TList.Create;
  AddToPropProdList := TList.Create;
  read_prop_prod_list.Sort(SortProp_Prod_For_BuiltProp);

  for I := 0 to read_prop_prod_list.Count - 1 do
  begin
    NEW_PROP_PROD := PTMQMPP(read_prop_prod_list[I]);

    if (Request = '') or ((Request = NEW_PROP_PROD.PP_PREQ_NO) and (step = NEW_PROP_PROD.PP_PSTEP_ID)) or
       (I = read_prop_prod_list.Count - 1) then

    begin
      TempList.Add(NEW_PROP_PROD);
    end
    else
    begin
      if TempList.Count = 0 then continue;
      for P := 0 to PropBuildFromOtherPropsList.Count - 1 do
      begin
        PROPERTY_BUILD_FROM_OTHER := PTPROPERTY_BUILD_FROM_OTHER(PropBuildFromOtherPropsList[P]);
        value1 := '';
        value2 := '';
        value3 := '';
        value4 := '';
        value5 := '';
        IncValues := 0;

        for V := 0 to TempList.Count - 1 do
        begin

          if V = 0 then
          begin
            NewRequest := PTMQMPP(TempList[v]).PP_PREQ_NO;
            NEWStep := PTMQMPP(TempList[v]).PP_PSTEP_ID;
          end;

          if (PTMQMPP(TempList[v]).PP_PROPERTY = PROPERTY_BUILD_FROM_OTHER.PROPCODE1) then
          begin
            value1 := PTMQMPP(TempList[v]).PP_VALUE;
            Inc(IncValues);
          end;
          if (PTMQMPP(TempList[v]).PP_PROPERTY = PROPERTY_BUILD_FROM_OTHER.PROPCODE2) then
          begin
            value2 := PTMQMPP(TempList[v]).PP_VALUE;
            Inc(IncValues);
          end;
          if (PTMQMPP(TempList[v]).PP_PROPERTY = PROPERTY_BUILD_FROM_OTHER.PROPCODE3) then
          begin
            value3 := PTMQMPP(TempList[v]).PP_VALUE;
            Inc(IncValues);
          end;
          if (PTMQMPP(TempList[v]).PP_PROPERTY = PROPERTY_BUILD_FROM_OTHER.PROPCODE4) then
          begin
            value4 := PTMQMPP(TempList[v]).PP_VALUE;
            Inc(IncValues);
          end;
          if (PTMQMPP(TempList[v]).PP_PROPERTY = PROPERTY_BUILD_FROM_OTHER.PROPCODE5) then
          begin
            value5 := PTMQMPP(TempList[v]).PP_VALUE;
            Inc(IncValues);
          end;

        end;

        if (IncValues > 1) then
        begin
          new(NEW_PROP_PROD);
          if (PROPERTY_BUILD_FROM_OTHER.TYPE1 = '2') and (Length(value1) = 20) then
            value1 := copy(trim(value1), PROPERTY_BUILD_FROM_OTHER.LEN1 + 1 , 20);

          if (PROPERTY_BUILD_FROM_OTHER.TYPE2 = '2') and (Length(value1) = 20) then
            value2 := copy(trim(value2), PROPERTY_BUILD_FROM_OTHER.LEN2 + 1 , 20);

          if (PROPERTY_BUILD_FROM_OTHER.TYPE3 = '2') and (Length(value1) = 20) then
            value3 := copy(trim(value3), PROPERTY_BUILD_FROM_OTHER.LEN3 + 1 , 20);

          if (PROPERTY_BUILD_FROM_OTHER.TYPE4 = '2') and (Length(value1) = 20) then
            value4 := copy(trim(value4), PROPERTY_BUILD_FROM_OTHER.LEN4 + 1 , 20);

          if (PROPERTY_BUILD_FROM_OTHER.TYPE5 = '2') and (Length(value1) = 20) then
            value5 := copy(trim(value5), PROPERTY_BUILD_FROM_OTHER.LEN5 + 1 , 20);

          NEW_PROP_PROD.PP_PREQ_NO := NewRequest;
          NEW_PROP_PROD.PP_PSTEP_ID := NEWStep;
          NEW_PROP_PROD.PP_PROPERTY := PROPERTY_BUILD_FROM_OTHER.PROPERTYCODE;
          NEW_PROP_PROD.PP_VALUE := trim(value1) + trim(value2) + trim(value3) + trim(value4) + trim(value5);
          AddToPropProdList.add(NEW_PROP_PROD);
        end;
      end;

      TempList.clear;
      TempList.add(NEW_PROP_PROD);
    end;

    Request := NEW_PROP_PROD.PP_PREQ_NO;
    Step    := NEW_PROP_PROD.PP_PSTEP_ID;

  end;

  for I := 0 to AddToPropProdList.Count - 1 do
    read_prop_prod_list.add(AddToPropProdList[I]);

  AddToPropProdList.free;
  TempList.Free;
end; }

//----------------------------------------------------------------------------//

function FindProdReqHdrInProdReqList(Prod_req : string) : Integer;
var
  i: integer;
  Multiplier, NumberOfEntries : integer;
begin
  Result := -1;

  NumberOfEntries := read_prod_reqhdr_list.Count;
  if NumberOfEntries = 0 then
  begin
    Exit;
  end;

  Multiplier := 1;
  while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    i := Multiplier - 1;

  while (Multiplier > 0) do
  begin

    if  (i < NumberOfEntries)
      and (PTMQMPH(read_prod_reqhdr_list[i]).PH_PREQ_NO = Prod_req) then break;

    Multiplier := trunc(Multiplier / 2);

    if  (i < NumberOfEntries) and (PTMQMPH(read_prod_reqhdr_list[i]).PH_PREQ_NO < Prod_req) then
      i := i + Multiplier
    else
      i := i - Multiplier;
  end;

  if Multiplier > 0 then
    Result := I;
end;

//----------------------------------------------------------------------------//

function SortProductionReservation(Item1, Item2: Pointer) : integer;
var
  MQMPTMQMPH1 : PTMQMPH;
  MQMPTMQMPH2 : PTMQMPH;
begin
  MQMPTMQMPH1 := PTMQMPH(Item1);
  MQMPTMQMPH2 := PTMQMPH(Item2);
  if MQMPTMQMPH1.PH_PREQ_NO < MQMPTMQMPH2.PH_PREQ_NO then
    Result := -1
  else if (MQMPTMQMPH1.PH_PREQ_NO = MQMPTMQMPH2.PH_PREQ_NO) then
    Result := 0
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

procedure UpdateBuildedPropertyFromOtherProperty;
var
  PropBuildFromOtherPropsList, read_prop_prod_list_Tmp : TList;
  Properties, PropertiesType, PropertiesLength,  Steps : TStringList;
  PrevStep, Step, I, J, K, L, RequestBeginIdx, NextRequestBeginIdx, PropListSize, ProdReqHdrIndex : Integer;
  Request, PropertyCode, Value, ValueTmp : string;
  ValueFound : boolean;
  NEW_PROP_PROD: PTMQMPP;
  PROPERTY_BUILD_FROM_OTHER : PTPROPERTY_BUILD_FROM_OTHER;
begin
  if read_prop_prod_list.Count = 0 then exit;

  read_prop_prod_list_Tmp := TList.Create;
  PropBuildFromOtherPropsList := TList.Create;
  if not GetPropBuildFromOtherPropsList(PropBuildFromOtherPropsList) then
  begin
    PropBuildFromOtherPropsList.Free;
    read_prop_prod_list_Tmp.Free;
    Exit;
  end;
  read_prop_prod_list.Sort(SortProp_Prod_For_BuiltProp);

  PropListSize := read_prop_prod_list.Count;
  NextRequestBeginIdx := 0;
  while true do
  begin
    if NextRequestBeginIdx > (PropListSize - 1) then break;
    Request := PTMQMPP(read_prop_prod_list[NextRequestBeginIdx]).PP_PREQ_NO;

    RequestBeginIdx := NextRequestBeginIdx;
    while True do
    begin
      NextRequestBeginIdx := NextRequestBeginIdx + 1;
      if NextRequestBeginIdx > (PropListSize - 1) then break;
      if Request <> PTMQMPP(read_prop_prod_list[NextRequestBeginIdx]).PP_PREQ_NO then break;
    end;

    for I := 0 to PropBuildFromOtherPropsList.Count - 1 do
    begin
      PROPERTY_BUILD_FROM_OTHER := PTPROPERTY_BUILD_FROM_OTHER(PropBuildFromOtherPropsList[I]);

      Properties := TStringList.Create;
      if PROPERTY_BUILD_FROM_OTHER.PROPCODE1 <> '' then Properties.Add(PROPERTY_BUILD_FROM_OTHER.PROPCODE1);
      if PROPERTY_BUILD_FROM_OTHER.PROPCODE2 <> '' then Properties.Add(PROPERTY_BUILD_FROM_OTHER.PROPCODE2);
      if PROPERTY_BUILD_FROM_OTHER.PROPCODE3 <> '' then Properties.Add(PROPERTY_BUILD_FROM_OTHER.PROPCODE3);
      if PROPERTY_BUILD_FROM_OTHER.PROPCODE4 <> '' then Properties.Add(PROPERTY_BUILD_FROM_OTHER.PROPCODE4);
      if PROPERTY_BUILD_FROM_OTHER.PROPCODE5 <> '' then Properties.Add(PROPERTY_BUILD_FROM_OTHER.PROPCODE5);

      PropertiesType := TStringList.Create;
      if PROPERTY_BUILD_FROM_OTHER.PROPCODE1 <> '' then PropertiesType.Add(PROPERTY_BUILD_FROM_OTHER.TYPE1);
      if PROPERTY_BUILD_FROM_OTHER.PROPCODE2 <> '' then PropertiesType.Add(PROPERTY_BUILD_FROM_OTHER.TYPE2);
      if PROPERTY_BUILD_FROM_OTHER.PROPCODE3 <> '' then PropertiesType.Add(PROPERTY_BUILD_FROM_OTHER.TYPE3);
      if PROPERTY_BUILD_FROM_OTHER.PROPCODE4 <> '' then PropertiesType.Add(PROPERTY_BUILD_FROM_OTHER.TYPE4);
      if PROPERTY_BUILD_FROM_OTHER.PROPCODE5 <> '' then PropertiesType.Add(PROPERTY_BUILD_FROM_OTHER.TYPE5);

      PropertiesLength := TStringList.Create;
      if PROPERTY_BUILD_FROM_OTHER.PROPCODE1 <> '' then PropertiesLength.Add(IntToStr(PROPERTY_BUILD_FROM_OTHER.LEN1));
      if PROPERTY_BUILD_FROM_OTHER.PROPCODE2 <> '' then PropertiesLength.Add(IntToStr(PROPERTY_BUILD_FROM_OTHER.LEN2));
      if PROPERTY_BUILD_FROM_OTHER.PROPCODE3 <> '' then PropertiesLength.Add(IntToStr(PROPERTY_BUILD_FROM_OTHER.LEN3));
      if PROPERTY_BUILD_FROM_OTHER.PROPCODE4 <> '' then PropertiesLength.Add(IntToStr(PROPERTY_BUILD_FROM_OTHER.LEN4));
      if PROPERTY_BUILD_FROM_OTHER.PROPCODE5 <> '' then PropertiesLength.Add(IntToStr(PROPERTY_BUILD_FROM_OTHER.LEN5));

      if Properties.Count < 2 then continue;
	  
	  Var Separator := PROPERTY_BUILD_FROM_OTHER.Separator;

      Steps := TStringList.Create;
      PrevStep := -1;
      J := RequestBeginIdx - 1;
      while True do
      begin
        J := J + 1;
        if J = NextRequestBeginIdx then break;
        if PrevStep = PTMQMPP(read_prop_prod_list[J]).PP_PSTEP_ID then continue;
        PropertyCode :=  PTMQMPP(read_prop_prod_list[J]).PP_PROPERTY;
        for K := 0 to Properties.Count - 1 do
        begin
          if PropertyCode <> Properties.Strings[K] then continue;
          if (PTMQMPP(read_prop_prod_list[J]).PP_PSTEP_ID <> PrevStep) then
          begin
            PrevStep := PTMQMPP(read_prop_prod_list[J]).PP_PSTEP_ID;
            Steps.Add(IntToStr(PrevStep));
          end;
          break;
        end;
      end;

      J := -1;
      if (Steps.Count > 1) and (StrToInt(Steps.Strings[0]) = 0) then J := 0;
      while True do
      begin
        J := J + 1;
        if J >= Steps.Count then break;
        Step := StrToInt(Steps.Strings[J]);
        Value := '';
        for K := 0 to Properties.Count - 1 do
        begin
          ValueFound := false;
          PropertyCode := Properties.Strings[K];
          L := RequestBeginIdx - 1;
          while True do
          begin
            L := L + 1;
            if L = NextRequestBeginIdx then break;
            if PTMQMPP(read_prop_prod_list[L]).PP_PSTEP_ID > Step then break;
            if (PTMQMPP(read_prop_prod_list[L]).PP_PSTEP_ID < Step)
            and (PTMQMPP(read_prop_prod_list[L]).PP_PSTEP_ID > 0) then continue;
            if PTMQMPP(read_prop_prod_list[L]).PP_PROPERTY <> PropertyCode  then continue;
            ValueFound := true;
            ValueTmp := trim(PTMQMPP(read_prop_prod_list[L]).PP_VALUE);
            if (PropertiesType.Strings[K] = '2') then//and (Length(ValueTmp) = 90) then
              value := value + copy(ValueTmp, 91 - StrToInt(PropertiesLength.Strings[K]) , StrToInt(PropertiesLength.Strings[K]))
            else                                  //21 avi 050921
            begin
              if (trim(value) = '') or (ValueTmp = '') then
                value := value + copy(ValueTmp, 1, StrToInt(PropertiesLength.Strings[K]))
              else                             //21 avi 050921
                value := value + Separator + copy(ValueTmp, 1, StrToInt(PropertiesLength.Strings[K]));
            end;			  
          end;
          if not ValueFound then break;
        end;
        if not ValueFound then continue;
        new(NEW_PROP_PROD);
        NEW_PROP_PROD.PP_PREQ_NO := Request;
        NEW_PROP_PROD.PP_PSTEP_ID := Step;
        NEW_PROP_PROD.PP_PROPERTY := PROPERTY_BUILD_FROM_OTHER.PROPERTYCODE;
        if Length(Value) > 90 then
          NEW_PROP_PROD.PP_VALUE := copy(trim(Value), 1, 90)
        else
          NEW_PROP_PROD.PP_VALUE := value;
        //read_prop_prod_list.add(NEW_PROP_PROD);
        NEW_PROP_PROD.IsPropLinkerToServingGroup := PROPERTY_BUILD_FROM_OTHER.IsPropLinkerToServingGroup;
        read_prop_prod_list_Tmp.add(NEW_PROP_PROD);
      end;

      Steps.Free;
      Properties.Free;
      PropertiesType.Free;
      PropertiesLength.Free;
    end;
  end;

  for I := PropBuildFromOtherPropsList.Count - 1 downto 0 do
    Dispose(PTPROPERTY_BUILD_FROM_OTHER(PropBuildFromOtherPropsList[I]));
  PropBuildFromOtherPropsList.Free;

  for I := 0 to read_prop_prod_list_Tmp.Count - 1 do
  begin
    read_prop_prod_list.add(read_prop_prod_list_Tmp[I]);
    if PTMQMPP(read_prop_prod_list_Tmp[I]).IsPropLinkerToServingGroup then
    begin
      ProdReqHdrIndex := FindProdReqHdrInProdReqList(PTMQMPP(read_prop_prod_list_Tmp[I]).PP_PREQ_NO);
      if ProdReqHdrIndex <> -1  then
        PTMQMPH(read_prod_reqhdr_list[ProdReqHdrIndex]).PH_Serving_Code := PTMQMPP(read_prop_prod_list_Tmp[I]).PP_VALUE;
    end;
  end;

  read_prop_prod_list.Sort(SortProp_Prod_For_BuiltProp);

  read_prop_prod_list_Tmp.free;
end;

//----------------------------------------------------------------------------//

procedure BuildFamilyStructure;
var
  I : Integer;
  Tmp_read_prod_req_list, Tmp_read_prod_reqHdr_list, Tmp_read_prod_Step_list, Tmp_read_prod_prop_list : TList;
  Tmp_prod_step_time_list, Tmp_Material_list, Tmp_read_prod_info_list, Tmp_read_Step_Batch_size_list : TList;
  Tmp_PRODUCED_ARTICLE_list, Tmp_PROD_REQCONN_list, Tmp_EXT_CONNECTION_list : TList;
begin
  if not m_NeedToMakeMerge then exit;

  Tmp_read_prod_req_list    := TList.Create;
  Tmp_read_prod_reqHdr_list := TList.Create;
  Tmp_read_prod_Step_list   := TList.Create;
  Tmp_read_prod_prop_list   := TList.Create;
  Tmp_prod_step_time_list   := TList.Create;
  Tmp_Material_list         := TList.Create;
  Tmp_read_prod_info_list   := TList.Create;
  Tmp_read_Step_Batch_size_list := TList.Create;
  Tmp_PRODUCED_ARTICLE_list := TList.Create;
  Tmp_PROD_REQCONN_list     := TList.Create;
  Tmp_EXT_CONNECTION_list   := TList.Create;

  for I := 0 to read_prod_req_list.Count - 1 do
    Find_prod_req_OR_AddToList_FamilyMerge(Tmp_read_prod_req_list, read_prod_req_list[I]);
  for I := read_prod_req_list.Count - 1 downto 0 do
    dispose(PTMQMPR(read_prod_req_list[I]));
  read_prod_req_list.clear;
  read_prod_req_list := Tmp_read_prod_req_list;

  for I := 0 to read_prod_reqhdr_list.Count - 1 do
    Find_prod_reqHdr_OR_AddToList_FamilyMerge(Tmp_read_prod_reqHdr_list, read_prod_reqhdr_list[I]);
  for I := read_prod_reqhdr_list.Count - 1 downto 0 do
    dispose(PTMQMPH(read_prod_reqhdr_list[I]));
  read_prod_reqhdr_list.clear;
  read_prod_reqhdr_list := Tmp_read_prod_reqHdr_list;

  for I := 0 to read_prod_step_list.Count - 1 do
    Find_prod_Step_OR_AddToList_FamilyMerge(Tmp_read_prod_Step_list, read_prod_step_list[I]);
  for I := read_prod_step_list.Count - 1 downto 0 do
    dispose(PTMQMPD(read_prod_step_list[I]));
  read_prod_step_list.clear;
  read_prod_step_list := Tmp_read_prod_Step_list;

  for I := 0 to read_prop_prod_list.Count - 1 do
    Find_prod_prop_OR_AddToList_FamilyMerge(Tmp_read_prod_prop_list, read_prop_prod_list[I]);
  for I := read_prop_prod_list.Count - 1 downto 0 do
    dispose(PTMQMPP(read_prop_prod_list[I]));
  read_prop_prod_list.clear;
  read_prop_prod_list := Tmp_read_prod_prop_list;

  for I := 0 to read_prod_step_time_list.Count - 1 do
    Find_prod_Step_Time_OR_AddToList_FamilyMerge(Tmp_prod_step_time_list, read_prod_step_time_list[I]);
  for I := read_prod_step_time_list.Count - 1 downto 0 do
    dispose(PTMQMST(read_prod_step_time_list[I]));
  read_prod_step_time_list.Free;
  read_prod_step_time_list := Tmp_prod_step_time_list;

  for I := 0 to read_material_list.Count - 1 do
    Find_Material_OR_AddToList_FamilyMerge(Tmp_Material_list, read_material_list[I]);
  for I := read_material_list.Count - 1 downto 0 do
    dispose(PTMQMMT(read_material_list[I]));
  read_material_list.clear;
  read_material_list := Tmp_Material_list;

  for I := 0 to read_prod_info_list.Count - 1 do
    Find_prod_info_OR_AddToList_FamilyMerge(Tmp_read_prod_info_list, read_prod_info_list[I]);
  for I := read_prod_info_list.Count - 1 downto 0 do
    dispose(PTMQMPI(read_prod_info_list[I]));
  read_prod_info_list.clear;
  read_prod_info_list := Tmp_read_prod_info_list;

  for I := 0 to read_prod_step_batch_size_list.Count - 1 do
    Find_STEP_BATCH_SIZE_FamilyMerge(Tmp_read_Step_Batch_size_list, read_prod_step_batch_size_list[I]);
  for I := read_prod_step_batch_size_list.Count - 1 downto 0 do
    dispose(PTMQMSB(read_prod_step_batch_size_list[I]));
  read_prod_step_batch_size_list.clear;
  read_prod_step_batch_size_list := Tmp_read_Step_Batch_size_list;

  for I := 0 to read_produced_article_list.Count - 1 do
    Find_PRODUCED_ARTICLE_FamilyMerge(Tmp_PRODUCED_ARTICLE_list, read_produced_article_list[I]);
  for I := read_produced_article_list.Count - 1 downto 0 do
    dispose(PTMQMPA(read_produced_article_list[I]));
  read_produced_article_list.clear;
  read_produced_article_list := Tmp_PRODUCED_ARTICLE_list;

  for I := 0 to read_prod_reqConn_list.Count - 1 do
    Find_REQCONN_list_FamilyMerge(Tmp_PROD_REQCONN_list, read_prod_reqConn_list[I]);
  for I := read_prod_reqConn_list.Count - 1 downto 0 do
    dispose(PTMQMIC(read_prod_reqConn_list[I]));
  read_prod_reqConn_list.clear;
  read_prod_reqConn_list := Tmp_PROD_REQCONN_list;

  for I := 0 to read_ext_connection_list.Count - 1 do
    Find_EXT_CONNECTION_list_FamilyMerge(Tmp_EXT_CONNECTION_list, read_ext_connection_list[I]);
  for I := read_ext_connection_list.Count - 1 downto 0 do
    dispose(PTMQMEC(read_ext_connection_list[I]));
  read_ext_connection_list.clear;
  read_ext_connection_list := Tmp_EXT_CONNECTION_list;

end;

//----------------------------------------------------------------------------//

procedure FindAndAdd_RecalcBatchProductionOrder(prod_step_time_list_for_calc : TList; MQMST : PTMQMST; var LastMultiplier : Integer);
var
  I: integer;
  Multiplier, NumberOfEntries, LowestHighestValue : integer;
begin
  NumberOfEntries := prod_step_time_list_for_calc.Count;
  LowestHighestValue := NumberOfEntries;

  if NumberOfEntries > 0 then
  begin

    Multiplier := LastMultiplier;
    while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    LastMultiplier := Multiplier;
    I := Multiplier - 1;

    while (Multiplier > 0) do
    begin
      Multiplier := trunc(Multiplier / 2);

      if (i >= NumberOfEntries) then
      begin
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMST(prod_step_time_list_for_calc[I]).ST_ProductionOrderCode < MQMST.ST_ProductionOrderCode then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMST(prod_step_time_list_for_calc[I]).ST_ProductionOrderCode > MQMST.ST_ProductionOrderCode) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMST(prod_step_time_list_for_calc[I]).ST_GroupStepNumber < MQMST.ST_GroupStepNumber then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMST(prod_step_time_list_for_calc[I]).ST_GroupStepNumber > MQMST.ST_GroupStepNumber) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMST(prod_step_time_list_for_calc[I]).ST_WKCNTER < MQMST.ST_WKCNTER then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMST(prod_step_time_list_for_calc[I]).ST_WKCNTER > MQMST.ST_WKCNTER) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMST(prod_step_time_list_for_calc[I]).ST_WKCT_PROC < MQMST.ST_WKCT_PROC then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMST(prod_step_time_list_for_calc[I]).ST_WKCT_PROC > MQMST.ST_WKCT_PROC) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMST(prod_step_time_list_for_calc[I]).ST_RES_CATEGORY < MQMST.ST_RES_CATEGORY then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMST(prod_step_time_list_for_calc[I]).ST_RES_CATEGORY > MQMST.ST_RES_CATEGORY) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMST(prod_step_time_list_for_calc[I]).ST_RSC_CODE < MQMST.ST_RSC_CODE then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMST(prod_step_time_list_for_calc[I]).ST_RSC_CODE > MQMST.ST_RSC_CODE) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMST(prod_step_time_list_for_calc[I]).ST_SETUP_TIME_Mechin_Code < MQMST.ST_SETUP_TIME_Mechin_Code then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMST(prod_step_time_list_for_calc[I]).ST_SETUP_TIME_Mechin_Code > MQMST.ST_SETUP_TIME_Mechin_Code) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      LowestHighestValue := I;
      break;

    end;
  end;

  prod_step_time_list_for_calc.Insert(LowestHighestValue, MQMST);
end;

//----------------------------------------------------------------------------//

procedure RecalcBatchProductionOrder;
var
  I, J, StartPOStepIdx : Integer;
  ProductionOrderCode, GroupStepNumber, TimeTypeCode, BatchTimeType : String;
  WKCNTER, WKCT_PROC, RES_CATEGORY, RSC_CODE, SETUP_TIME_Mechin_Code : string;
  MultiplierExecution, MultiplierSetUp, CalcTime2, CalcTime3, InitialBasePrimaryQuanity, StandardStepQuantity  : double;
  Quantity, SetupTime, executionTime : double;
  TimeArriveFromNowStep, ToRecalc, ToRecalc_General : boolean;
  read_prod_step_time_list_With_PO : TList;
  MQMST : PTMQMST;
  LastMultiplier : Integer;
begin
  ToRecalc_General := false;
  read_prod_step_time_list_With_PO := TList.Create;
  UpdateOperation(_('Recalc Batch Production Order'));
  ProductionOrderCode := '';
  StartPOStepIdx := 0;
  LastMultiplier := 1;

  for I := 0 to read_prod_step_time_list.Count - 1 do
  begin
    if PTMQMST(read_prod_step_time_list[I]).ST_ProductionOrderCode = '' then continue;

    ToRecalc := true;

    if (PTMQMST(read_prod_step_time_list[I]).ST_timeTypeCode <> 'B') and (PTMQMST(read_prod_step_time_list[I]).ST_timeTypeCode <> 'P') then ToRecalc := false;
    if (PTMQMST(read_prod_step_time_list[I]).ST_timeTypeCode = 'B') and (PTMQMST(read_prod_step_time_list[I]).ST_BatchTimeType = '2') then ToRecalc := false;
    if (PTMQMST(read_prod_step_time_list[I]).ST_timeTypeCode = 'P') and not PTMQMST(read_prod_step_time_list[I]).ST_TimeArriveFromNowStep then ToRecalc := false;
    if (PTMQMST(read_prod_step_time_list[I]).ST_multiplierExecution = 0) then ToRecalc := false;

    if ToRecalc then ToRecalc_General := true;

    FindAndAdd_RecalcBatchProductionOrder(read_prod_step_time_list_With_PO, PTMQMST(read_prod_step_time_list[I]), LastMultiplier);
  end;

  if not ToRecalc_General then
  begin
    read_prod_step_time_list_With_PO.Free;
    exit;
  end;

  for I := 0 to read_prod_step_time_list_With_PO.Count - 1 do
  begin
   // if PTMQMST(read_prod_step_time_list[I]).ST_ProductionOrderCode = '' then continue;

    if  (ProductionOrderCode = PTMQMST(read_prod_step_time_list_With_PO[I]).ST_ProductionOrderCode)
    and (GroupStepNumber = PTMQMST(read_prod_step_time_list_With_PO[I]).ST_GroupStepNumber)
    and (WKCNTER = PTMQMST(read_prod_step_time_list_With_PO[I]).ST_WKCNTER)
    and (WKCT_PROC = PTMQMST(read_prod_step_time_list_With_PO[I]).ST_WKCT_PROC)
    and (RES_CATEGORY = PTMQMST(read_prod_step_time_list_With_PO[I]).ST_RES_CATEGORY)
    and (RSC_CODE = PTMQMST(read_prod_step_time_list_With_PO[I]).ST_RSC_CODE)
    and (SETUP_TIME_Mechin_Code = PTMQMST(read_prod_step_time_list_With_PO[I]).ST_SETUP_TIME_Mechin_Code) then
    begin
      CalcTime2 := CalcTime2 + PTMQMST(read_prod_step_time_list_With_PO[I]).ST_CalcTime2;
      CalcTime3 := CalcTime3 + PTMQMST(read_prod_step_time_list_With_PO[I]).ST_CalcTime3;
      InitialBasePrimaryQuanity := InitialBasePrimaryQuanity + PTMQMST(read_prod_step_time_list_With_PO[I]).ST_INITIALBASEPRIMARYQUANTITY;
      continue;
    end;

    ToRecalc := true;
 //   if ProductionOrderCode = '' then ToRecalc := false;
    if (TimeTypeCode <> 'B') and (TimeTypeCode <> 'P') then ToRecalc := false;
    if (TimeTypeCode = 'B') and (BatchTimeType = '2') then ToRecalc := false;
    if (TimeTypeCode = 'P') and not TimeArriveFromNowStep then ToRecalc := false;
    if (MultiplierExecution = 0) then ToRecalc := false;

    if ToRecalc then
    begin
      quantity := 1;
      if (BatchTimeType = '1') and (InitialBasePrimaryQuanity > 0) and (StandardStepQuantity > 0) and (TimeTypeCode = 'B') then
        quantity := Ceil(InitialBasePrimaryQuanity / StandardStepQuantity);
      setupTime := (CalcTime2 / quantity) * 60 * MultiplierSetUp;
      executionTime := (CalcTime3 / quantity) * 60 * MultiplierExecution;
      for J := StartPOStepIdx to I - 1 do
      begin
        PTMQMST(read_prod_step_time_list_With_PO[j]).ST_SETUP_TIME_JOB := setupTime;
        PTMQMST(read_prod_step_time_list_With_PO[j]).ST_EXC_TIME_INIT_QTY := executionTime;
      end;
    end;

    ProductionOrderCode := PTMQMST(read_prod_step_time_list_With_PO[I]).ST_ProductionOrderCode;
    GroupStepNumber := PTMQMST(read_prod_step_time_list_With_PO[I]).ST_GroupStepNumber;
    WKCNTER := PTMQMST(read_prod_step_time_list_With_PO[I]).ST_WKCNTER;
    WKCT_PROC := PTMQMST(read_prod_step_time_list_With_PO[I]).ST_WKCT_PROC;
    RES_CATEGORY := PTMQMST(read_prod_step_time_list_With_PO[I]).ST_RES_CATEGORY;
    RSC_CODE     := PTMQMST(read_prod_step_time_list_With_PO[I]).ST_RSC_CODE;
    SETUP_TIME_Mechin_Code := PTMQMST(read_prod_step_time_list_With_PO[I]).ST_SETUP_TIME_Mechin_Code;
    TimeTypeCode := PTMQMST(read_prod_step_time_list_With_PO[I]).ST_timeTypeCode;
    BatchTimeType := PTMQMST(read_prod_step_time_list_With_PO[I]).ST_BatchTimeType;
    MultiplierSetUp := PTMQMST(read_prod_step_time_list_With_PO[I]).ST_multiplierSetUp;
    MultiplierExecution := PTMQMST(read_prod_step_time_list_With_PO[I]).ST_multiplierExecution;
    CalcTime2 := PTMQMST(read_prod_step_time_list_With_PO[I]).ST_CalcTime2;
    CalcTime3 := PTMQMST(read_prod_step_time_list_With_PO[I]).ST_CalcTime3;
    InitialBasePrimaryQuanity := PTMQMST(read_prod_step_time_list_With_PO[I]).ST_INITIALBASEPRIMARYQUANTITY;
    StandardStepQuantity := PTMQMST(read_prod_step_time_list_With_PO[I]).ST_STANDARDSTEPQUANTITY;
    StartPOStepIdx := I;
    TimeArriveFromNowStep := PTMQMST(read_prod_step_time_list_With_PO[I]).ST_TimeArriveFromNowStep;

  end;

  ToRecalc := true;
 // if ProductionOrderCode = '' then ToRecalc := false;
  if (TimeTypeCode <> 'B') and (TimeTypeCode <> 'P') then ToRecalc := false;
  if (TimeTypeCode = 'B') and (BatchTimeType = '2') then ToRecalc := false;
  if (TimeTypeCode = 'P') and not TimeArriveFromNowStep then ToRecalc := false;
  if (MultiplierExecution = 0) then ToRecalc := false;

  if ToRecalc then
  begin
    quantity := 1;
    if (BatchTimeType = '1') and (InitialBasePrimaryQuanity > 0) and (StandardStepQuantity > 0) and (TimeTypeCode = 'B') then
      quantity := Ceil(InitialBasePrimaryQuanity / StandardStepQuantity);
    setupTime := (CalcTime2 / quantity) * 60 * MultiplierSetUp;
    executionTime := (CalcTime3 / quantity) * 60 * MultiplierExecution;
    for J := StartPOStepIdx to read_prod_step_time_list_With_PO.Count - 1 do
    begin
      PTMQMST(read_prod_step_time_list_With_PO[j]).ST_SETUP_TIME_JOB := setupTime;
      PTMQMST(read_prod_step_time_list_With_PO[j]).ST_EXC_TIME_INIT_QTY := executionTime;
    end;
  end;

  read_prod_step_time_list_With_PO.Free;

end;


//----------------------------------------------------------------------------//

procedure TryToGroupStepTimesRows;
type
 TStepTime = record
   Setup : double;
   Execusion : double;
   Count : Integer;
 end;
 PTStepTime = ^TStepTime;
var
  Idx, IdxTimes, HighestCount, HighestCountIdx, RequestStepStartIdx, I : Integer;
  PrevRequest : String;
  PrevStep : SmallInt;
  First, RequestCanGroup, CategoryDefined, ResourceDefined, Found : Boolean;
  StepTimeList, TempTimeList : TList;
  PStepTime : PTStepTime;
  PMQMST, PMQMSTTemp : PTMQMST;
begin
  read_prod_step_time_list.Sort(SortST);

  First := true;
  StepTimeList := TList.Create;
  TempTimeList := Tlist.Create;

  for Idx := 0 to read_prod_step_time_list.Count - 1 do
  begin
    PMQMST := PTMQMST(read_prod_step_time_list[Idx]);

    if not First
    and ((PrevRequest <> PMQMST.ST_PREQ_NO) or (PrevStep <> PMQMST.ST_PSTEP_ID)) then
    begin
      Found := false;
      if RequestCanGroup and (HighestCount > 1) then
        PStepTime := PTStepTime(StepTimeList[HighestCountIdx]);
      for I := RequestStepStartIdx to Idx - 1 do
      begin
        PMQMSTTemp := PTMQMST(read_prod_step_time_list[I]);
        if RequestCanGroup and (HighestCount > 1) then
        begin
          if  (PMQMSTTemp.ST_SETUP_TIME_JOB = PStepTime.Setup)
          and (PMQMSTTemp.ST_EXC_TIME_INIT_QTY = PStepTime.Execusion) then
          begin
            if Found then
            begin
              dispose(PMQMSTTemp);
              continue;
            end;
            Found := true;
            PMQMSTTemp.ST_WKCNTER := '';
            PMQMSTTemp.ST_WKCT_PROC := '';
            PMQMSTTemp.ST_RES_CATEGORY := '';
            PMQMSTTemp.ST_RSC_CODE := '';
          end;
        end;
        TempTimeList.Add(PMQMSTTemp);
      end;
    end;

    if First
    or (PrevRequest <> PMQMST.ST_PREQ_NO)
    or (PrevStep <> PMQMST.ST_PSTEP_ID) then
    begin
      First := false;
      PrevRequest := PMQMST.ST_PREQ_NO;
      PrevStep := PMQMST.ST_PSTEP_ID;
      RequestCanGroup := true;
      HighestCount := 1;
      HighestCountIdx := 0;
      RequestStepStartIdx := Idx;
      if (TRIM(PMQMST.ST_RES_CATEGORY) = '') then
        CategoryDefined := false
      else
        CategoryDefined := true;
      if (TRIM(PMQMST.ST_RSC_CODE) = '') then
        ResourceDefined := false
      else
        ResourceDefined := true;
      for IdxTimes := 0 to StepTimeList.Count - 1 do
        dispose(PTStepTime(StepTimeList[IdxTimes]));
      StepTimeList.Clear;
    end;

    if (PMQMST.ST_WKCNTER = '')
    or ((TRIM(PMQMST.ST_RES_CATEGORY) = '') and CategoryDefined)
    or ((TRIM(PMQMST.ST_RES_CATEGORY) <> '') and not CategoryDefined)
    or ((TRIM(PMQMST.ST_RSC_CODE) = '') and ResourceDefined)
    or ((TRIM(PMQMST.ST_RSC_CODE) <> '') and not ResourceDefined) then
      RequestCanGroup := false;

    Found := false;
    for IdxTimes := 0 to StepTimeList.Count - 1 do
    begin
      PStepTime := PTStepTime(StepTimeList[IdxTimes]);
      if  (PMQMST.ST_SETUP_TIME_JOB = PStepTime.Setup)
      and (PMQMST.ST_EXC_TIME_INIT_QTY = PStepTime.Execusion) then
      begin
        Found := true;
        PStepTime.Count := PStepTime.Count + 1;
        if HighestCount < PStepTime.Count then
        begin
          HighestCount := PStepTime.Count;
          HighestCountIdx := IdxTimes;
        end;
        break;
      end;
    end;

    if not Found then
    begin
      New(PStepTime);
      PStepTime.Setup := PMQMST.ST_SETUP_TIME_JOB;
      PStepTime.Execusion := PMQMST.ST_EXC_TIME_INIT_QTY;
      PStepTime.Count := 1;
      StepTimeList.Add(PStepTime);
    end;

  end;

  if not First then
  begin
    Found := false;
    if RequestCanGroup and (HighestCount > 1) then
      PStepTime := PTStepTime(StepTimeList[HighestCountIdx]);
    for I := RequestStepStartIdx to read_prod_step_time_list.Count - 1 do
    begin
      PMQMSTTemp := PTMQMST(read_prod_step_time_list[I]);
      if RequestCanGroup and (HighestCount > 1) then
      begin
        if  (PMQMSTTemp.ST_SETUP_TIME_JOB = PStepTime.Setup)
        and (PMQMSTTemp.ST_EXC_TIME_INIT_QTY = PStepTime.Execusion) then
        begin
          if Found then
          begin
            dispose(PMQMSTTemp);
            continue
          end;
          Found := true;
          PMQMSTTemp.ST_WKCNTER := '';
          PMQMSTTemp.ST_WKCT_PROC := '';
          PMQMSTTemp.ST_RES_CATEGORY := '';
          PMQMSTTemp.ST_RSC_CODE := '';
        end;
      end;
      TempTimeList.Add(PMQMSTTemp);
    end;
    read_prod_step_time_list.Clear;
    for Idx := 0 to TempTimeList.Count - 1 do
    begin
      PMQMST := PTMQMST(TempTimeList[Idx]);
      read_prod_step_time_list.Add(PMQMST);
    end;
    for IdxTimes := 0 to StepTimeList.Count - 1 do
      dispose(PTStepTime(StepTimeList[IdxTimes]));
  end;

  TempTimeList.Free;
  StepTimeList.Free;

end;

//----------------------------------------------------------------------------//

procedure fillStructs(ArcQry :  TMqmQuery; handledWorkCentersList: TList; unhandledWorkCentersList: TList; OperAttributesList : TList; var AtLeast_1_Wc_HandledWarp : boolean; var AD_ProductionDemandStep_FieldsList : TStringList; var AD_Product_FieldsList : TStringList; var AD_ProductionDemand_FieldsList : TStringList);
var
  srvSqlStr, tblArcName: String;
  NEWWORKCENTER: PWORKCENTERS;
  DndArchiveArcName : TDndArchiveName;
begin
  DndArchiveArcName := GetDndArchiveLocalName;
  AtLeast_1_Wc_HandledWarp := false;
  if DndArchiveArcName = TD_Interbase then
    tblArcName  := 'WKC'
  else
    tblArcName  := 'SCDA_' + 'WKC';

  srvSqlStr := 'SELECT WC_WKCNTER, WC_HANDLEDBYMQM, WC_HANDLEDBYMCM, ' +
               'WC_HANDLE_LEARNINGCURVE, WC_AD_LEARNINGCURVE_CODE, WC_OVERLAP_WITH_OTHER_STEPS, WC_AD_OVERLAP_WITH_OTHER_STEPS , WC_HANDLEGERERICPLAN, WC_WARP_HANDLE, WC_APPROVALDATEBYTNA FROM ' + tblArcName + ' WHERE ' +
               '(WC_HANDLEDBYMQM = ' + QuotedStr('1') + ' OR ' +
               'WC_HANDLEDBYMCM = ' + QuotedStr('1') + ')' + AND_IDF_Condition('WC_IDENTIFIER') +
               'ORDER BY WC_WKCNTER';
  ArcQry.SQL.Text := srvSqlStr;
  ArcQry.Open;

  var WC_WKCNTER_FIELD:= ArcQry.FieldByName('WC_WKCNTER');
  var WC_HANDLEDBYMQM_FIELD := ArcQry.FieldByName('WC_HANDLEDBYMQM');
  var WC_HANDLEDBYMCM_FIELD := ArcQry.FieldByName('WC_HANDLEDBYMCM');
  var WC_HANDLE_LEARNINGCURVE_FIELD := ArcQry.FieldByName('WC_HANDLE_LEARNINGCURVE');
  var WC_AD_LEARNINGCURVE_CODE_FIELD := ArcQry.FieldByName('WC_AD_LEARNINGCURVE_CODE');
  var WC_OVERLAP_WITH_OTHER_STEPS_FIELD := ArcQry.FieldByName('WC_OVERLAP_WITH_OTHER_STEPS');
  var WC_AD_OVERLAP_WITH_OTHER_STEPS_FIELD := ArcQry.FieldByName('WC_AD_OVERLAP_WITH_OTHER_STEPS');
  var WC_HANDLEGERERICPLAN_FIELD := ArcQry.FieldByName('WC_HANDLEGERERICPLAN');
  var WC_APPROVALDATE_BY_TNA_FIELD := ArcQry.FieldByName('WC_APPROVALDATEBYTNA');
  var WC_WARP_HANDLE := ArcQry.FieldByName('WC_WARP_HANDLE');

  while (not ArcQry.Eof) do
  begin
    New(NEWWORKCENTER);

    NEWWORKCENTER.WC_WKCNTER := Trim(WC_WKCNTER_FIELD.AsString);
    NEWWORKCENTER.WC_HANDLEDBYMQM := Trim(WC_HANDLEDBYMQM_FIELD.AsString);
    NEWWORKCENTER.WC_HANDLEDBYMCM := Trim(WC_HANDLEDBYMCM_FIELD.AsString);
    NEWWORKCENTER.WC_HANDLE_LEARNINGCURVE := Trim(WC_HANDLE_LEARNINGCURVE_FIELD.AsString);
    NEWWORKCENTER.WC_AD_LEARNINGCURVE_CODE := Trim(WC_AD_LEARNINGCURVE_CODE_FIELD.AsString);
    NEWWORKCENTER.WC_OVERLAP_WITH_OTHER_STEPS := Trim(WC_OVERLAP_WITH_OTHER_STEPS_FIELD.AsString);
    NEWWORKCENTER.WC_AD_OVERLAP_WITH_OTHER_STEPS := Trim(WC_AD_OVERLAP_WITH_OTHER_STEPS_FIELD.AsString);
    NEWWORKCENTER.WC_HANDLEGERERICPLAN := false;
    if Trim(WC_HANDLEGERERICPLAN_FIELD.AsString) = '1' then
       NEWWORKCENTER.WC_HANDLEGERERICPLAN := true;
    NEWWORKCENTER.WC_APPROVALDATE_BY_TNA := false;
    if Trim(WC_APPROVALDATE_BY_TNA_FIELD.AsString) = '1' then
       NEWWORKCENTER.WC_APPROVALDATE_BY_TNA := true;
    NEWWORKCENTER.Process_List := TList.Create;
    NEWWORKCENTER.WC_Batch_UoM := TStringList.Create;
    if (Trim(WC_WARP_HANDLE.AsString) = '1') or (Trim(WC_WARP_HANDLE.AsString) = '2') then
       AtLeast_1_Wc_HandledWarp := true;
    NEWWORKCENTER.WC_HANDLE_WARP := Trim(WC_WARP_HANDLE.AsString);

    fillProcessListOfWorkCenter(NEWWORKCENTER, OperAttributesList, AD_ProductionDemand_FieldsList);

{    if (NEWWORKCENTER.WC_AD_LEARNINGCURVE_CODE <> '') then
      if AD_Product_FieldsList.IndexOf(NEWWORKCENTER.WC_AD_LEARNINGCURVE_CODE) = -1 then
          AD_Product_FieldsList.add(NEWWORKCENTER.WC_AD_LEARNINGCURVE_CODE);  }

    if (NEWWORKCENTER.WC_AD_LEARNINGCURVE_CODE <> '') then
      if AD_ProductionDemandStep_FieldsList.IndexOf(NEWWORKCENTER.WC_AD_LEARNINGCURVE_CODE) = -1 then
          AD_ProductionDemandStep_FieldsList.add(NEWWORKCENTER.WC_AD_LEARNINGCURVE_CODE);

    if (NEWWORKCENTER.WC_AD_OVERLAP_WITH_OTHER_STEPS <> '') then
      if AD_ProductionDemandStep_FieldsList.IndexOf(NEWWORKCENTER.WC_AD_OVERLAP_WITH_OTHER_STEPS) = -1 then
          AD_ProductionDemandStep_FieldsList.add(NEWWORKCENTER.WC_AD_OVERLAP_WITH_OTHER_STEPS);

    handledWorkCentersList.Add(NEWWORKCENTER);

    ArcQry.Next;
  end;
  handledWorkCentersList.Sort(Sort_WORKCENTER);

  // Fill unhandled w.c
  srvSqlStr := 'SELECT WC_WKCNTER, WC_RES_NUM_PLN FROM ' + tblArcName + '  WHERE ' +
               'WC_HANDLEDBYMQM <> ' + QuotedStr('1') + ' AND ' +
               'WC_HANDLEDBYMCM <> ' + QuotedStr('1') + ' AND WC_RES_NUM_PLN > ' + IntToStr(0) +
                AND_IDF_Condition('WC_IDENTIFIER') +
               'ORDER BY WC_WKCNTER';
  ArcQry.SQL.Text := srvSqlStr;
  ArcQry.Open;

  var WC_WKCNTER_FIELD1 := ArcQry.FieldByName('WC_WKCNTER');
  var WC_RES_NUM_PLN_FIELD := ArcQry.FieldByName('WC_RES_NUM_PLN');

  while (not ArcQry.Eof) do
  begin
    New(NEWWORKCENTER);
    NEWWORKCENTER.WC_WKCNTER := Trim(WC_WKCNTER_FIELD1.AsString);
    NEWWORKCENTER.WC_RES_NUM_PLN := WC_RES_NUM_PLN_FIELD.AsInteger;
    unhandledWorkCentersList.Add(NEWWORKCENTER);
    ArcQry.Next;
  end;
  unhandledWorkCentersList.Sort(Sort_WORKCENTER);

  ArcQry.Close;
//  ArcQry.Free;

end;

//----------------------------------------------------------------------------//

procedure fillProcessListOfWorkCenter(NEWWORKCENTER: PWORKCENTERS; OperAttributesList : TList; var AD_ProductionDemand_FieldsList : TStringList);
var
  srvQryFD:    TMqmQuery;
  srvSqlStr,tblArcName: String;
  NEWPROCESS: PPROCESSES;
  DndArchiveArcName : TDndArchiveName;
begin
  DndArchiveArcName := GetDndArchiveLocalName;
  if DndArchiveArcName = TD_Interbase then
    tblArcName  := 'WKC_PROC'
  else
    tblArcName  := 'SCDA_' + 'WKC_PROC';

  srvQryFD := ThreadCreateQueryArc;

  srvSqlStr := 'SELECT WP_WKCT_PROC, WP_ISNOWPRDORD_MQMGROUP, ' +
               'WP_CANBEGROUPEDINMQM, WP_DEFAULTFORALLOWEDSPLIT, ' +
               'WP_ADFORALLOWEDSPLIT, WP_ADFORSPLITFAMILYCODE, WP_TYPE, WP_BATCHSTANDARDTIME, WP_QUEUE_TIME_AS_PREV_STEP, WP_POST_PROCESS_AS_NEXT_STEP ' +
               'FROM ' + tblArcName + ' WHERE ' +
               'WP_WKCNTER= ' + QuotedStr(NEWWORKCENTER.WC_WKCNTER) + ' ' +
                AND_IDF_Condition('WP_IDENTIFIER') +
               'ORDER BY WP_WKCT_PROC';
  srvQryFD.SQL.Text := srvSqlStr;
  srvQryFD.Open;

  var fldWP_WKCT_PROC                := srvQryFD.FieldByName('WP_WKCT_PROC');
  var fldWP_ISNOWPRDORD_MQMGROUP     := srvQryFD.FieldByName('WP_ISNOWPRDORD_MQMGROUP');
  var fldWP_CANBEGROUPEDINMQM        := srvQryFD.FieldByName('WP_CANBEGROUPEDINMQM');
  var fldWP_DEFAULTFORALLOWEDSPLIT   := srvQryFD.FieldByName('WP_DEFAULTFORALLOWEDSPLIT');
  var fldWP_ADFORALLOWEDSPLIT        := srvQryFD.FieldByName('WP_ADFORALLOWEDSPLIT');
  var fldWP_ADFORSPLITFAMILYCODE     := srvQryFD.FieldByName('WP_ADFORSPLITFAMILYCODE');
  var fldWP_TYPE                     := srvQryFD.FieldByName('WP_TYPE');
  var fldWP_BATCHSTANDARDTIME        := srvQryFD.FieldByName('WP_BATCHSTANDARDTIME');
  var fldWP_QUEUE_TIME_AS_PREV_STEP  := srvQryFD.FieldByName('WP_QUEUE_TIME_AS_PREV_STEP');
  var fldWP_POST_PROCESS_AS_NEXT_STEP := srvQryFD.FieldByName('WP_POST_PROCESS_AS_NEXT_STEP');

  while (not srvQryFD.Eof) do
  begin
    New(NEWPROCESS);

    NEWPROCESS.WP_WKCT_PROC := Trim(fldWP_WKCT_PROC.AsString);

    if (Trim(fldWP_ISNOWPRDORD_MQMGROUP.AsString) <> '') then
      NEWPROCESS.WP_ISNOWPRDORD_MQMGROUP := Trim(fldWP_ISNOWPRDORD_MQMGROUP.AsString)
    else
      NEWPROCESS.WP_ISNOWPRDORD_MQMGROUP := '0';

    if (Trim(fldWP_CANBEGROUPEDINMQM.AsString) <> '') then
      NEWPROCESS.WP_CANBEGROUPEDINMQM := Trim(fldWP_CANBEGROUPEDINMQM.AsString)
    else
      NEWPROCESS.WP_CANBEGROUPEDINMQM := '0';

    NEWPROCESS.WP_DEFAULTFORALLOWEDSPLIT := Trim(fldWP_DEFAULTFORALLOWEDSPLIT.AsString);
    NEWPROCESS.WP_ADFORALLOWEDSPLIT := Trim(fldWP_ADFORALLOWEDSPLIT.AsString);
    NEWPROCESS.WP_ADFORSPLITFAMILYCODE := Trim(fldWP_ADFORSPLITFAMILYCODE.AsString);
    NEWPROCESS.WP_TYPE := Trim(fldWP_TYPE.AsString);
    NEWPROCESS.WP_BATCHSTANDARDTIME := Trim(fldWP_BATCHSTANDARDTIME.AsString);

    NEWPROCESS.CONSIDER_QUEUE_TIME_AS_LEADTIME_To_PREVIOUS_STEP := Trim(fldWP_QUEUE_TIME_AS_PREV_STEP.AsString);
    NEWPROCESS.CONSIDER_POST_PROCESS_TIME_LEADTIME_NEXT_STEP  := Trim(fldWP_POST_PROCESS_AS_NEXT_STEP.AsString);

    if NEWPROCESS.WP_ADFORALLOWEDSPLIT <> '' then
      if AD_ProductionDemand_FieldsList.IndexOf(NEWPROCESS.WP_ADFORALLOWEDSPLIT) = -1 then
        AD_ProductionDemand_FieldsList.add(NEWPROCESS.WP_ADFORALLOWEDSPLIT);
    if NEWPROCESS.WP_ADFORSPLITFAMILYCODE <> '' then
      if AD_ProductionDemand_FieldsList.IndexOf(NEWPROCESS.WP_ADFORSPLITFAMILYCODE) = -1 then
        AD_ProductionDemand_FieldsList.add(NEWPROCESS.WP_ADFORSPLITFAMILYCODE);

    NEWPROCESS.Properties_List := TList.Create;
    NEWPROCESS.Alternatives_List := TStringList.Create;
    NEWPROCESS.Alternatives_List.Sorted := true;
    NEWPROCESS.OperAttributes_List := TList.Create;
    NEWPROCESS.ProductionTimesLevel_List := TList.Create;
   // NEWPROCESS.Penalties_List := TList.Create;

    fillPropertyListOfWorkCenterProcess(NEWWORKCENTER.WC_WKCNTER, NEWPROCESS);
    fillAlternativeListOfWorkCenterProcess(NEWWORKCENTER.WC_WKCNTER, NEWPROCESS);
    fillOperAttributeListOfWorkCenterProcess(OperAttributesList, NEWWORKCENTER.WC_WKCNTER, NEWPROCESS);
    fillProductionTimesLevelListOfWorkCenterProcess(NEWWORKCENTER.WC_WKCNTER, NEWPROCESS);

    NEWWORKCENTER.Process_List.Add(NEWPROCESS);

    srvQryFD.Next;
  end;
  NEWWORKCENTER.Process_List.sort(Sort_PPROCESSES);

  srvQryFD.Close;
  srvQryFD.Free;

end;

//----------------------------------------------------------------------------//

procedure fillPropertyListOfWorkCenterProcess(workCenterCode: String; NEWPROCESS: PPROCESSES);
var
  srvQryFD:    TMqmQuery;
  srvSqlStr, tblArcName: String;
  NEWPROPERTY: PPROPERTIES;
  DndArchiveArcName : TDndArchiveName;
begin
  DndArchiveArcName := GetDndArchiveLocalName;
  if DndArchiveArcName = TD_Interbase then
    tblArcName  := 'PROP_RES'
  else
    tblArcName  := 'SCDA_' + 'PROP_RES';
  srvQryFD := ThreadCreateQueryArc;

  srvSqlStr := 'SELECT RP_RES_CATEGORY, RP_RSC_CODE, RP_PROPERTY, ' +
               'RP_PROPTY_VALUE, RP_ADD_RSC_OCC, RP_VAL_ADDED, ' +
               'RP_VAL_TAKE_FOR_GROUP, RP_DFT_CASE_RSC_OCC_RULS, ' +
               'RP_DFT_CASE_OCC_OCC_RULS, RP_DFT_SAME_GRP_OCC_OCC_RULS ' +
               'FROM ' + tblArcName + ' WHERE ' +
               'RP_WKCNTER = ' + QuotedStr(workCenterCode) + ' AND ' +
               'RP_WC_PROCESS = ' + QuotedStr(NEWPROCESS.WP_WKCT_PROC) +
                AND_IDF_Condition('RP_IDENTIFIER');
  srvQryFD.SQL.Text := srvSqlStr;
  srvQryFD.Open;

  var fldRP_RES_CATEGORY            := srvQryFD.FieldByName('RP_RES_CATEGORY');
  var fldRP_RSC_CODE                := srvQryFD.FieldByName('RP_RSC_CODE');
  var fldRP_PROPERTY                := srvQryFD.FieldByName('RP_PROPERTY');
  var fldRP_PROPTY_VALUE            := srvQryFD.FieldByName('RP_PROPTY_VALUE');
  var fldRP_ADD_RSC_OCC             := srvQryFD.FieldByName('RP_ADD_RSC_OCC');
  var fldRP_VAL_ADDED               := srvQryFD.FieldByName('RP_VAL_ADDED');
  var fldRP_VAL_TAKE_FOR_GROUP      := srvQryFD.FieldByName('RP_VAL_TAKE_FOR_GROUP');
  var fldRP_DFT_CASE_RSC_OCC_RULS   := srvQryFD.FieldByName('RP_DFT_CASE_RSC_OCC_RULS');
  var fldRP_DFT_CASE_OCC_OCC_RULS   := srvQryFD.FieldByName('RP_DFT_CASE_OCC_OCC_RULS');
  var fldRP_DFT_SAME_GRP_OCC_OCC_RULS := srvQryFD.FieldByName('RP_DFT_SAME_GRP_OCC_OCC_RULS');

  while (not srvQryFD.Eof) do
  begin
    New(NEWPROPERTY);

    NEWPROPERTY.RP_RES_CATEGORY := Trim(fldRP_RES_CATEGORY.AsString);
    NEWPROPERTY.RP_RSC_CODE := Trim(fldRP_RSC_CODE.AsString);
    NEWPROPERTY.RP_PROPERTY := Trim(fldRP_PROPERTY.AsString);
    NEWPROPERTY.RP_PROPTY_VALUE := Trim(fldRP_PROPTY_VALUE.AsString);
    NEWPROPERTY.RP_ADD_RSC_OCC := Trim(fldRP_ADD_RSC_OCC.AsString);
    NEWPROPERTY.RP_VAL_ADDED := Trim(fldRP_VAL_ADDED.AsString);
    NEWPROPERTY.RP_VAL_TAKE_FOR_GROUP := Trim(fldRP_VAL_TAKE_FOR_GROUP.AsString);
    NEWPROPERTY.RP_DFT_CASE_RSC_OCC_RULS := Trim(fldRP_DFT_CASE_RSC_OCC_RULS.AsString);
    NEWPROPERTY.RP_DFT_CASE_OCC_OCC_RULS := Trim(fldRP_DFT_CASE_OCC_OCC_RULS.AsString);
    NEWPROPERTY.RP_DFT_SAME_GRP_OCC_OCC_RULS := Trim(fldRP_DFT_SAME_GRP_OCC_OCC_RULS.AsString);

    NEWPROCESS.Properties_List.Add(NEWPROPERTY);

    srvQryFD.Next;
  end;

  srvQryFD.Close;
  srvQryFD.Free;
end;

//----------------------------------------------------------------------------//

procedure fillAlternativeListOfWorkCenterProcess(workCenterCode: String; NEWPROCESS: PPROCESSES);
var
  srvSqlStr, tblArcName: String;
  srvQryFD:    TMqmQuery;
  DndArchiveArcName : TDndArchiveName;
  fldAlternWC: TField;
begin
  DndArchiveArcName := GetDndArchiveLocalName;
  if DndArchiveArcName = TD_Interbase then
    tblArcName  := 'ALT_WKC'
  else
    tblArcName  := 'SCDA_' + 'ALT_WKC';
  srvQryFD := ThreadCreateQueryArc;

  srvSqlStr := 'SELECT AW_ALTERN_WC FROM ' + tblArcName + ' WHERE ' +
               'AW_WKCNTER = ' + QuotedStr(workCenterCode) + ' AND ' +
               'AW_WKCT_PROC = ' + QuotedStr(NEWPROCESS.WP_WKCT_PROC) + ' ' +
                AND_IDF_Condition('AW_IDENTIFIER') +
               'ORDER BY AW_ALTERN_WC';
  srvQryFD.SQL.Text := srvSqlStr;
  srvQryFD.Open;
  fldAlternWC := srvQryFD.FieldByName('AW_ALTERN_WC');

  while (not srvQryFD.Eof) do
  begin
    NEWPROCESS.Alternatives_List.Add(Trim(fldAlternWC.AsString));
    srvQryFD.Next;
  end;

  srvQryFD.Close;
  srvQryFD.Free;
end;

//----------------------------------------------------------------------------//

function SortOPERATTRIBUTESByCode(Item1: Pointer; Item2: Pointer): Integer;
var
  firstAttribute : POPERATTRIBUTES;
  secondAttribute : POPERATTRIBUTES;
  firstList: TStringList;
  secondList: TStringList;
begin
  firstAttribute := Item1;
  secondAttribute := Item2;
  firstList := TStringList.Create;
  firstList.Add(firstAttribute.Code);
  secondList := TStringList.Create;
  secondList.Add(secondAttribute.Code);
  Result := compareValuesOfListsToSort(firstList, secondList);
  firstList.Free;
  secondList.Free;
end;

//----------------------------------------------------------------------------//

procedure fillOperAttributeListOfWorkCenterProcess(OperAttributesList : TList; workCenterCode: String; NEWPROCESS: PPROCESSES);
var
  NEWOPERATTRIBUTE: POPERATTRIBUTES;
  WcOperAttributesList : TList;
  I : integer;
begin
  WcOperAttributesList :=  FindWORKCENTERANDOPERATTRIBUTES(workCenterCode, NEWPROCESS.WP_WKCT_PROC, OperAttributesList);
  if WcOperAttributesList <> nil then
  begin
    for I := 0 to WcOperAttributesList.Count - 1 do
    begin
      new(NEWOPERATTRIBUTE);
      NEWOPERATTRIBUTE^ := POPERATTRIBUTES(WcOperAttributesList[I])^;
      NEWPROCESS.OperAttributes_List.Add(NEWOPERATTRIBUTE);
    end;
    NEWPROCESS.OperAttributes_List.Sort(SortOPERATTRIBUTESByCode);
    WcOperAttributesList.Free;
  end;

end;

//----------------------------------------------------------------------------//

function SortProductionTimesLevel(Item1, Item2: Pointer) : integer;
var
  PRODUCTIONTIMESLEVEL1 : PPRODUCTIONTIMESLEVELS;
  PRODUCTIONTIMESLEVEL2 : PPRODUCTIONTIMESLEVELS;
begin
  PRODUCTIONTIMESLEVEL1 := PPRODUCTIONTIMESLEVELS(Item1);
  PRODUCTIONTIMESLEVEL2 := PPRODUCTIONTIMESLEVELS(Item2);
  if PRODUCTIONTIMESLEVEL1.PRODUCT_TYPE < PRODUCTIONTIMESLEVEL2.PRODUCT_TYPE then
    Result := -1
  else if (PRODUCTIONTIMESLEVEL1.PRODUCT_TYPE = PRODUCTIONTIMESLEVEL2.PRODUCT_TYPE) then
    Result := 0
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

procedure fillProductionTimesLevelListOfWorkCenterProcess(workCenterCode: String; NEWPROCESS: PPROCESSES);
var
  srvSqlStr,tblArcName : String;
  NEWPRODUCTIONTIMESLEVEL: PPRODUCTIONTIMESLEVELS;
  srvQryFD:    TMqmQuery;
  DndArchiveArcName : TDndArchiveName;
  fldProductType, fldHandleTimesBy: TField;
  fldTableName1, fldColumnName1: TField;
  fldTableName2, fldColumnName2: TField;
  fldTableName3, fldColumnName3: TField;
  fldTableName4, fldColumnName4: TField;
  fldTableName5, fldColumnName5: TField;
  fldTableName6, fldColumnName6: TField;
  fldTableName7, fldColumnName7: TField;
  fldTableName8, fldColumnName8: TField;
  fldTableName9, fldColumnName9: TField;
  fldTableName10, fldColumnName10: TField;
begin
  DndArchiveArcName := GetDndArchiveLocalName;
  if DndArchiveArcName = TD_Interbase then
    tblArcName  := 'PRODUCTION_TIMES_LEVEL'
  else
    tblArcName  := 'SCDA_' + 'PRODUCTION_TIMES_LEVEL';
  srvQryFD := ThreadCreateQueryArc;

  srvSqlStr := 'SELECT DISTINCT PRODUCT_TYPE, HANDLE_TIMES_BY, TABLENAME1, COLUMNNAME1, ' +
 // srvSqlStr := 'SELECT PRODUCT_TYPE, HANDLE_TIMES_BY, TABLENAME1, COLUMNNAME1, ' +
               'TABLENAME2, COLUMNNAME2, TABLENAME3, COLUMNNAME3, ' +
               'TABLENAME4, COLUMNNAME4, TABLENAME5, COLUMNNAME5, ' +
               'TABLENAME6, COLUMNNAME6, TABLENAME7, COLUMNNAME7, ' +
               'TABLENAME8, COLUMNNAME8, TABLENAME9, COLUMNNAME9, ' +
               'TABLENAME10, COLUMNNAME10 FROM ' + tblArcName + ' WHERE ' +
               'WORK_CENTER_CODE = ' + QuotedStr(workCenterCode) + ' AND ' +
               'OPERATION = ' + QuotedStr(NEWPROCESS.WP_WKCT_PROC) +
                AND_IDF_Condition('IDENTIFIER');
  srvQryFD.SQL.Text := srvSqlStr;
  srvQryFD.Open;
  fldProductType  := srvQryFD.FieldByName('PRODUCT_TYPE');
  fldHandleTimesBy := srvQryFD.FieldByName('HANDLE_TIMES_BY');
  fldTableName1   := srvQryFD.FieldByName('TABLENAME1');
  fldColumnName1  := srvQryFD.FieldByName('COLUMNNAME1');
  fldTableName2   := srvQryFD.FieldByName('TABLENAME2');
  fldColumnName2  := srvQryFD.FieldByName('COLUMNNAME2');
  fldTableName3   := srvQryFD.FieldByName('TABLENAME3');
  fldColumnName3  := srvQryFD.FieldByName('COLUMNNAME3');
  fldTableName4   := srvQryFD.FieldByName('TABLENAME4');
  fldColumnName4  := srvQryFD.FieldByName('COLUMNNAME4');
  fldTableName5   := srvQryFD.FieldByName('TABLENAME5');
  fldColumnName5  := srvQryFD.FieldByName('COLUMNNAME5');
  fldTableName6   := srvQryFD.FieldByName('TABLENAME6');
  fldColumnName6  := srvQryFD.FieldByName('COLUMNNAME6');
  fldTableName7   := srvQryFD.FieldByName('TABLENAME7');
  fldColumnName7  := srvQryFD.FieldByName('COLUMNNAME7');
  fldTableName8   := srvQryFD.FieldByName('TABLENAME8');
  fldColumnName8  := srvQryFD.FieldByName('COLUMNNAME8');
  fldTableName9   := srvQryFD.FieldByName('TABLENAME9');
  fldColumnName9  := srvQryFD.FieldByName('COLUMNNAME9');
  fldTableName10  := srvQryFD.FieldByName('TABLENAME10');
  fldColumnName10 := srvQryFD.FieldByName('COLUMNNAME10');

  while (not srvQryFD.Eof) do
  begin
    New(NEWPRODUCTIONTIMESLEVEL);

    NEWPRODUCTIONTIMESLEVEL.PRODUCT_TYPE := Trim(fldProductType.AsString);
    NEWPRODUCTIONTIMESLEVEL.HANDLE_TIMES_BY := fldHandleTimesBy.AsString;
    NEWPRODUCTIONTIMESLEVEL.TABLENAME1 := fldTableName1.AsString;
    NEWPRODUCTIONTIMESLEVEL.COLUMNNAME1 := fldColumnName1.AsString;
    NEWPRODUCTIONTIMESLEVEL.TABLENAME2 := fldTableName2.AsString;
    NEWPRODUCTIONTIMESLEVEL.COLUMNNAME2 := fldColumnName2.AsString;
    NEWPRODUCTIONTIMESLEVEL.TABLENAME3 := fldTableName3.AsString;
    NEWPRODUCTIONTIMESLEVEL.COLUMNNAME3 := fldColumnName3.AsString;
    NEWPRODUCTIONTIMESLEVEL.TABLENAME4 := fldTableName4.AsString;
    NEWPRODUCTIONTIMESLEVEL.COLUMNNAME4 := fldColumnName4.AsString;
    NEWPRODUCTIONTIMESLEVEL.TABLENAME5 := fldTableName5.AsString;
    NEWPRODUCTIONTIMESLEVEL.COLUMNNAME5 := fldColumnName5.AsString;
    NEWPRODUCTIONTIMESLEVEL.TABLENAME6 := fldTableName6.AsString;
    NEWPRODUCTIONTIMESLEVEL.COLUMNNAME6 := fldColumnName6.AsString;
    NEWPRODUCTIONTIMESLEVEL.TABLENAME7 := fldTableName7.AsString;
    NEWPRODUCTIONTIMESLEVEL.COLUMNNAME7 := fldColumnName7.AsString;
    NEWPRODUCTIONTIMESLEVEL.TABLENAME8 := fldTableName8.AsString;
    NEWPRODUCTIONTIMESLEVEL.COLUMNNAME8 := fldColumnName8.AsString;
    NEWPRODUCTIONTIMESLEVEL.TABLENAME9 := fldTableName9.AsString;
    NEWPRODUCTIONTIMESLEVEL.COLUMNNAME9 := fldColumnName9.AsString;
    NEWPRODUCTIONTIMESLEVEL.TABLENAME10 := fldTableName10.AsString;
    NEWPRODUCTIONTIMESLEVEL.COLUMNNAME10 := fldColumnName10.AsString;
    NEWPRODUCTIONTIMESLEVEL.ProductionTimes_List := TList.Create;

    fillProductionTimesListOfProductionTimesLevel(workCenterCode, NEWPROCESS.WP_WKCT_PROC, NEWPRODUCTIONTIMESLEVEL);

    NEWPROCESS.ProductionTimesLevel_List.Add(NEWPRODUCTIONTIMESLEVEL);

    srvQryFD.Next;
  end;

  NEWPROCESS.ProductionTimesLevel_List.Sort(SortProductionTimesLevel);

  srvQryFD.Close;
  srvQryFD.Free;
end;

//----------------------------------------------------------------------------//

procedure fillProductionTimesListOfProductionTimesLevel(workCenterCode: String; processCode: String; NEWPRODUCTIONTIMESLEVEL: PPRODUCTIONTIMESLEVELS);
var
  srvSqlStr, tblArcName: String;
  NEWPRODUCTIONTIME : PPRODUCTIONTIMES;
  srvQryFD:    TMqmQuery;
  DndArchiveArcName : TDndArchiveName;
  Prev_PRODUCTIONTIME : TPRODUCTIONTIMES;
  Firsttime : boolean;
  fldColVal1, fldColVal2, fldColVal3, fldColVal4, fldColVal5: TField;
  fldColVal6, fldColVal7, fldColVal8, fldColVal9, fldColVal10: TField;
  fldResCategory, fldRes: TField;
  fldSetupTime, fldBatchTime, fldContinuousTime: TField;
  fldContinuousOperationUM, fldConsiderStepEfficiency: TField;
  fldCode, fldSetupTimeMult, fldOperationTimeMult: TField;
begin
  DndArchiveArcName := GetDndArchiveLocalName;
  if DndArchiveArcName = TD_Interbase then
    tblArcName  := 'PRODUCTION_TIMES'
  else
    tblArcName  := 'SCDA_' + 'PRODUCTION_TIMES';
  srvQryFD := ThreadCreateQueryArc;

  srvSqlStr := 'SELECT DISTINCT TBLNAME1_COL_NAME1_VAL, TBLNAME1_COL_NAME2_VAL, TBLNAME1_COL_NAME3_VAL, ' +
               'TBLNAME1_COL_NAME4_VAL, TBLNAME1_COL_NAME5_VAL, TBLNAME1_COL_NAME6_VAL, TBLNAME1_COL_NAME7_VAL, ' +
               'TBLNAME1_COL_NAME8_VAL, TBLNAME1_COL_NAME9_VAL, TBLNAME1_COL_NAME10_VAL, ' +
               'RES_CATEGORY, RES, SETUP_TIME, BATCH_TIME, ' +
               'CONTINUOUS_TIME, CONTINUOUS_OPERATION_UM, CONSIDER_STEP_EFFICIENCY, ' +
               'CODE, SETUP_TIME_MULTIPLIER, OPERATION_TIME_MULTIPLIER FROM ' + tblArcName + ' WHERE ' +
               'WORK_CENTER = ' + QuotedStr(workCenterCode) + ' AND ' +
               'OPERATION = ' + QuotedStr(processCode) + ' AND ' +
               'PRODUCT_TYPE = ' + QuotedStr(NEWPRODUCTIONTIMESLEVEL.PRODUCT_TYPE) +
               AND_IDF_Condition('IDENTIFIER') +
               'order by TBLNAME1_COL_NAME1_VAL, TBLNAME1_COL_NAME2_VAL, TBLNAME1_COL_NAME3_VAL, ' +
               'TBLNAME1_COL_NAME4_VAL, TBLNAME1_COL_NAME5_VAL, TBLNAME1_COL_NAME6_VAL, TBLNAME1_COL_NAME7_VAL, ' +
               'TBLNAME1_COL_NAME8_VAL, TBLNAME1_COL_NAME9_VAL, TBLNAME1_COL_NAME10_VAL, ' +
               'RES_CATEGORY, RES';

 { srvSqlStr := 'SELECT * FROM ' + tblArcName + ' WHERE ' +
               'WORK_CENTER = ' + QuotedStr(workCenterCode) + ' AND ' +
               'OPERATION = ' + QuotedStr(processCode) + ' AND ' +
               'PRODUCT_TYPE = ' + QuotedStr(NEWPRODUCTIONTIMESLEVEL.PRODUCT_TYPE) +
               AND_IDF_Condition('IDENTIFIER');  }
  srvQryFD.SQL.Text := srvSqlStr;
  srvQryFD.Open;
  fldColVal1  := srvQryFD.FieldByName('TBLNAME1_COL_NAME1_VAL');
  fldColVal2  := srvQryFD.FieldByName('TBLNAME1_COL_NAME2_VAL');
  fldColVal3  := srvQryFD.FieldByName('TBLNAME1_COL_NAME3_VAL');
  fldColVal4  := srvQryFD.FieldByName('TBLNAME1_COL_NAME4_VAL');
  fldColVal5  := srvQryFD.FieldByName('TBLNAME1_COL_NAME5_VAL');
  fldColVal6  := srvQryFD.FieldByName('TBLNAME1_COL_NAME6_VAL');
  fldColVal7  := srvQryFD.FieldByName('TBLNAME1_COL_NAME7_VAL');
  fldColVal8  := srvQryFD.FieldByName('TBLNAME1_COL_NAME8_VAL');
  fldColVal9  := srvQryFD.FieldByName('TBLNAME1_COL_NAME9_VAL');
  fldColVal10 := srvQryFD.FieldByName('TBLNAME1_COL_NAME10_VAL');
  fldResCategory          := srvQryFD.FieldByName('RES_CATEGORY');
  fldRes                  := srvQryFD.FieldByName('RES');
  fldSetupTime            := srvQryFD.FieldByName('SETUP_TIME');
  fldBatchTime            := srvQryFD.FieldByName('BATCH_TIME');
  fldContinuousTime       := srvQryFD.FieldByName('CONTINUOUS_TIME');
  fldContinuousOperationUM    := srvQryFD.FieldByName('CONTINUOUS_OPERATION_UM');
  fldConsiderStepEfficiency   := srvQryFD.FieldByName('CONSIDER_STEP_EFFICIENCY');
  fldCode                 := srvQryFD.FieldByName('CODE');
  fldSetupTimeMult        := srvQryFD.FieldByName('SETUP_TIME_MULTIPLIER');
  fldOperationTimeMult    := srvQryFD.FieldByName('OPERATION_TIME_MULTIPLIER');
  Firsttime := true;

  while (not srvQryFD.Eof) do
  begin
    if not Firsttime then
    begin
      if ((Prev_PRODUCTIONTIME.TABLENAME1_COLUMNNAME1_VALUE = fldColVal1.AsString) and
         (Prev_PRODUCTIONTIME.TABLENAME1_COLUMNNAME2_VALUE = fldColVal2.AsString) and
         (Prev_PRODUCTIONTIME.TABLENAME1_COLUMNNAME3_VALUE = fldColVal3.AsString) and
         (Prev_PRODUCTIONTIME.TABLENAME1_COLUMNNAME4_VALUE = fldColVal4.AsString) and
         (Prev_PRODUCTIONTIME.TABLENAME1_COLUMNNAME5_VALUE = fldColVal5.AsString) and
         (Prev_PRODUCTIONTIME.TABLENAME1_COLUMNNAME6_VALUE = fldColVal6.AsString) and
         (Prev_PRODUCTIONTIME.TABLENAME1_COLUMNNAME7_VALUE = fldColVal7.AsString) and
         (Prev_PRODUCTIONTIME.TABLENAME1_COLUMNNAME8_VALUE = fldColVal8.AsString) and
         (Prev_PRODUCTIONTIME.TABLENAME1_COLUMNNAME9_VALUE = fldColVal9.AsString) and
         (Prev_PRODUCTIONTIME.TABLENAME1_COLUMNNAME10_VALUE = fldColVal10.AsString) and
         (Prev_PRODUCTIONTIME.RESOURCE_CATEGORY = Trim(fldResCategory.AsString)) and
         (Prev_PRODUCTIONTIME.RESOURCE = Trim(fldRes.AsString))) then
       begin
         srvQryFD.Next;
         continue;
       end;
    end;

    New(NEWPRODUCTIONTIME);

    NEWPRODUCTIONTIME.TABLENAME1_COLUMNNAME1_VALUE := fldColVal1.AsString;
    NEWPRODUCTIONTIME.TABLENAME1_COLUMNNAME2_VALUE := fldColVal2.AsString;
    NEWPRODUCTIONTIME.TABLENAME1_COLUMNNAME3_VALUE := fldColVal3.AsString;
    NEWPRODUCTIONTIME.TABLENAME1_COLUMNNAME4_VALUE := fldColVal4.AsString;
    NEWPRODUCTIONTIME.TABLENAME1_COLUMNNAME5_VALUE := fldColVal5.AsString;
    NEWPRODUCTIONTIME.TABLENAME1_COLUMNNAME6_VALUE := fldColVal6.AsString;
    NEWPRODUCTIONTIME.TABLENAME1_COLUMNNAME7_VALUE := fldColVal7.AsString;
    NEWPRODUCTIONTIME.TABLENAME1_COLUMNNAME8_VALUE := fldColVal8.AsString;
    NEWPRODUCTIONTIME.TABLENAME1_COLUMNNAME9_VALUE := fldColVal9.AsString;
    NEWPRODUCTIONTIME.TABLENAME1_COLUMNNAME10_VALUE := fldColVal10.AsString;

    NEWPRODUCTIONTIME.StrConcatination := '';
    if (NEWPRODUCTIONTIMESLEVEL.TABLENAME1 <> '') and (NEWPRODUCTIONTIMESLEVEL.COLUMNNAME1 <> '') then
        NEWPRODUCTIONTIME.StrConcatination := trim(NEWPRODUCTIONTIME.TABLENAME1_COLUMNNAME1_VALUE); //+ '||';
    if (NEWPRODUCTIONTIMESLEVEL.TABLENAME2 <> '') and (NEWPRODUCTIONTIMESLEVEL.COLUMNNAME2 <> '') then
    begin
      if NEWPRODUCTIONTIME.StrConcatination <> '' then
        NEWPRODUCTIONTIME.StrConcatination := NEWPRODUCTIONTIME.StrConcatination + '||';
      NEWPRODUCTIONTIME.StrConcatination := NEWPRODUCTIONTIME.StrConcatination + trim(NEWPRODUCTIONTIME.TABLENAME1_COLUMNNAME2_VALUE);
    end;
    if (NEWPRODUCTIONTIMESLEVEL.TABLENAME3 <> '') and (NEWPRODUCTIONTIMESLEVEL.COLUMNNAME3 <> '') then
    begin
      if NEWPRODUCTIONTIME.StrConcatination <> '' then
        NEWPRODUCTIONTIME.StrConcatination := NEWPRODUCTIONTIME.StrConcatination + '||';
      NEWPRODUCTIONTIME.StrConcatination := NEWPRODUCTIONTIME.StrConcatination + trim(NEWPRODUCTIONTIME.TABLENAME1_COLUMNNAME3_VALUE);
    end;
    if (NEWPRODUCTIONTIMESLEVEL.TABLENAME4 <> '') and (NEWPRODUCTIONTIMESLEVEL.COLUMNNAME4 <> '') then
    begin
      if NEWPRODUCTIONTIME.StrConcatination <> '' then
        NEWPRODUCTIONTIME.StrConcatination := NEWPRODUCTIONTIME.StrConcatination + '||';
      NEWPRODUCTIONTIME.StrConcatination := NEWPRODUCTIONTIME.StrConcatination + trim(NEWPRODUCTIONTIME.TABLENAME1_COLUMNNAME4_VALUE);
    end;
    if (NEWPRODUCTIONTIMESLEVEL.TABLENAME5 <> '') and (NEWPRODUCTIONTIMESLEVEL.COLUMNNAME5 <> '') then
    begin
      if NEWPRODUCTIONTIME.StrConcatination <> '' then
        NEWPRODUCTIONTIME.StrConcatination := NEWPRODUCTIONTIME.StrConcatination + '||';
      NEWPRODUCTIONTIME.StrConcatination := NEWPRODUCTIONTIME.StrConcatination + trim(NEWPRODUCTIONTIME.TABLENAME1_COLUMNNAME5_VALUE);
    end;
    if (NEWPRODUCTIONTIMESLEVEL.TABLENAME6 <> '') and (NEWPRODUCTIONTIMESLEVEL.COLUMNNAME6 <> '') then
    begin
      if NEWPRODUCTIONTIME.StrConcatination <> '' then
        NEWPRODUCTIONTIME.StrConcatination := NEWPRODUCTIONTIME.StrConcatination + '||';
      NEWPRODUCTIONTIME.StrConcatination := NEWPRODUCTIONTIME.StrConcatination + trim(NEWPRODUCTIONTIME.TABLENAME1_COLUMNNAME6_VALUE);
    end;
    if (NEWPRODUCTIONTIMESLEVEL.TABLENAME7 <> '') and (NEWPRODUCTIONTIMESLEVEL.COLUMNNAME7 <> '') then
    begin
      if NEWPRODUCTIONTIME.StrConcatination <> '' then
        NEWPRODUCTIONTIME.StrConcatination := NEWPRODUCTIONTIME.StrConcatination + '||';
      NEWPRODUCTIONTIME.StrConcatination := NEWPRODUCTIONTIME.StrConcatination + trim(NEWPRODUCTIONTIME.TABLENAME1_COLUMNNAME7_VALUE);
    end;
    if (NEWPRODUCTIONTIMESLEVEL.TABLENAME8 <> '') and (NEWPRODUCTIONTIMESLEVEL.COLUMNNAME8 <> '') then
    begin
      if NEWPRODUCTIONTIME.StrConcatination <> '' then
        NEWPRODUCTIONTIME.StrConcatination := NEWPRODUCTIONTIME.StrConcatination + '||';
      NEWPRODUCTIONTIME.StrConcatination := NEWPRODUCTIONTIME.StrConcatination + trim(NEWPRODUCTIONTIME.TABLENAME1_COLUMNNAME8_VALUE);
    end;
    if (NEWPRODUCTIONTIMESLEVEL.TABLENAME9 <> '') and (NEWPRODUCTIONTIMESLEVEL.COLUMNNAME9 <> '') then
    begin
      if NEWPRODUCTIONTIME.StrConcatination <> '' then
        NEWPRODUCTIONTIME.StrConcatination := NEWPRODUCTIONTIME.StrConcatination + '||';
      NEWPRODUCTIONTIME.StrConcatination := NEWPRODUCTIONTIME.StrConcatination + trim(NEWPRODUCTIONTIME.TABLENAME1_COLUMNNAME9_VALUE);
    end;
    if (NEWPRODUCTIONTIMESLEVEL.TABLENAME10 <> '') and (NEWPRODUCTIONTIMESLEVEL.COLUMNNAME10 <> '') then
    begin
      if NEWPRODUCTIONTIME.StrConcatination <> '' then
        NEWPRODUCTIONTIME.StrConcatination := NEWPRODUCTIONTIME.StrConcatination + '||';
      NEWPRODUCTIONTIME.StrConcatination := NEWPRODUCTIONTIME.StrConcatination + trim(NEWPRODUCTIONTIME.TABLENAME1_COLUMNNAME10_VALUE);
    end;
    NEWPRODUCTIONTIME.RESOURCE_CATEGORY := Trim(fldResCategory.AsString);
    NEWPRODUCTIONTIME.RESOURCE := Trim(fldRes.AsString);
    NEWPRODUCTIONTIME.SETUP_TIME := Trim(fldSetupTime.AsString);
    NEWPRODUCTIONTIME.BATCH_TIME := Trim(fldBatchTime.AsString);
    NEWPRODUCTIONTIME.CONTINUOUS_TIME := Trim(fldContinuousTime.AsString);
    NEWPRODUCTIONTIME.CONTINUOUS_OPERATION_UM := Trim(fldContinuousOperationUM.AsString);
    NEWPRODUCTIONTIME.CONSIDER_STEP_EFFICIENCY := Trim(fldConsiderStepEfficiency.AsString);
    NEWPRODUCTIONTIME.CODE := Trim(fldCode.AsString);
    NEWPRODUCTIONTIME.SETUP_TIME_MULTIPLIER := Trim(fldSetupTimeMult.AsString);
    NEWPRODUCTIONTIME.OPERATION_TIME_MULTIPLIER := Trim(fldOperationTimeMult.AsString);

    NEWPRODUCTIONTIMESLEVEL.ProductionTimes_List.Add(NEWPRODUCTIONTIME);

    Prev_PRODUCTIONTIME := NEWPRODUCTIONTIME^;
    firstTime := false;

    srvQryFD.Next;
  end;

  NEWPRODUCTIONTIMESLEVEL.ProductionTimes_List.Sort(Sort_Concatinated);

  srvQryFD.Close;
  srvQryFD.Free;
end;

//----------------------------------------------------------------------------//

function getUserGenericGroupTypeAttributes(USERGENERICGROUPTYPECODE, CODE : string; List : TList) : PTUserGenericGroupAttributes;
var
  i: integer;
  Multiplier, NumberOfEntries, NumberOfEntriesMinusOne : integer;
  Request, step : variant;
begin
  NumberOfEntries := List.Count;
  Result := nil;

  if NumberOfEntries = 0 then exit;

  NumberOfEntriesMinusOne := NumberOfEntries - 1;
  Multiplier := 1;
  while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
  i := Multiplier - 1;

  while (Multiplier > 0) do
  begin
    Multiplier := trunc(Multiplier / 2);

    if (i > NumberOfEntriesMinusOne) then
    begin
      i := i - Multiplier;
      Continue;
    end;

    if (PTUserGenericGroupAttributes(List[i]).USERGENERICGROUPTYPECODE > USERGENERICGROUPTYPECODE) then
    begin
   //   if I < Index then Index := I;
      i := i - Multiplier;
      Continue;
    end;

    if  (PTUserGenericGroupAttributes(List[i]).USERGENERICGROUPTYPECODE < USERGENERICGROUPTYPECODE) then
    begin
      i := i + Multiplier;
      Continue;
    end;

    if  (PTUserGenericGroupAttributes(List[i]).CODE > CODE) then
    begin
     // if I < Index then Index := I;
      i := i - Multiplier;
      Continue;
    end;

    if  (PTUserGenericGroupAttributes(List[i]).CODE < CODE) then
    begin
      i := i + Multiplier;
      Continue;
    end;

    Result := PTUserGenericGroupAttributes(List[i]);
   // Index := i;
    Break;

  end;

end;

//----------------------------------------------------------------------------//

function getUserGenericGroupType(ITEMTYPECODE : string; POSITION : integer; List : TList) : string;
var
  i: integer;
  Multiplier, NumberOfEntries, NumberOfEntriesMinusOne : integer;
  Request, step : variant;
  UserGenericGroupType : PTUserGenericGroupType;
begin
  NumberOfEntries := List.Count;
  Result := '';

  if NumberOfEntries = 0 then exit;

  NumberOfEntriesMinusOne := NumberOfEntries - 1;
  Multiplier := 1;
  while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
  i := Multiplier - 1;

  while (Multiplier > 0) do
  begin
    Multiplier := trunc(Multiplier / 2);

    if (i > NumberOfEntriesMinusOne) then
    begin
      i := i - Multiplier;
      Continue;
    end;

    if (PTUserGenericGroupType(List[i]).ITEMTYPECODE > ITEMTYPECODE) then
    begin
   //   if I < Index then Index := I;
      i := i - Multiplier;
      Continue;
    end;

    if  (PTUserGenericGroupType(List[i]).ITEMTYPECODE < ITEMTYPECODE) then
    begin
      i := i + Multiplier;
      Continue;
    end;

    if  (PTUserGenericGroupType(List[i]).POSITION > POSITION) then
    begin
     // if I < Index then Index := I;
      i := i - Multiplier;
      Continue;
    end;

    if  (PTUserGenericGroupType(List[i]).POSITION < POSITION) then
    begin
      i := i + Multiplier;
      Continue;
    end;

    Result := PTUserGenericGroupType(List[i]).GROUPTYPECODE;
   // Index := i;
    Break;

  end;

end;

//----------------------------------------------------------------------------//

function UserGenericGroup(Item1, Item2: Pointer) : integer;
var
  UserGenericGroupTypeAttributes1 : PTUserGenericGroupAttributes;
  UserGenericGroupTypeAttributes2 : PTUserGenericGroupAttributes;
begin
  UserGenericGroupTypeAttributes1 := PTUserGenericGroupAttributes(Item1);
  UserGenericGroupTypeAttributes2 := PTUserGenericGroupAttributes(Item2);
  if (UserGenericGroupTypeAttributes1.USERGENERICGROUPTYPECODE < UserGenericGroupTypeAttributes2.USERGENERICGROUPTYPECODE) then
    Result := -1
  else if (UserGenericGroupTypeAttributes1.USERGENERICGROUPTYPECODE = UserGenericGroupTypeAttributes2.USERGENERICGROUPTYPECODE) then
  begin
    if (UserGenericGroupTypeAttributes1.CODE < UserGenericGroupTypeAttributes2.CODE) then
      Result := -1
    else if (UserGenericGroupTypeAttributes1.CODE = UserGenericGroupTypeAttributes2.CODE) then
      Result := 0
    else
      Result := 1;
  end
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

procedure fillUserGenericGroupTypeAttributes(HostQry: TMqmQuery; UserGenericGroupTypeAttributesList : TList; HandledUserGenericGroupTypesStr : string);
var
  hostSqlStr, CompanyInUsed: String;
  UserGenericGroupTypeAttributes : PTUserGenericGroupAttributes;
begin
  if not GetCompanyLevelHandlingByEntityName('USERGENERICGROUP',  CompanyInUsed) then
     CompanyInUsed := IniAppGlobals.CompanyCode;

  hostSqlStr := 'select USERGENERICGROUPTYPECODE, CODE, ABSUNIQUEID, LONGDESCRIPTION, SHORTDESCRIPTION, SEARCHDESCRIPTION ' +
                'from USERGENERICGROUP where USERGENGROUPTYPECOMPANYCODE = ' + QuotedStr(CompanyInUsed) + ' ' +
                'and USERGENERICGROUPTYPECODE in ( ' + HandledUserGenericGroupTypesStr + ') ' +
                ' order by USERGENERICGROUPTYPECODE, CODE ';

  HostQry.SQL.Text := hostSqlStr;
  HostQry.open;

  var USERGENERICGROUPTYPECODE_FIELD := HostQry.FieldByName('USERGENERICGROUPTYPECODE');
  var CODE_FIELD := HostQry.FieldByName('CODE');
  var ABSUNIQUEID_FIELD := HostQry.FieldByName('ABSUNIQUEID');
  var LONGDESCRIPTION_FIELD := HostQry.FieldByName('LONGDESCRIPTION');
  var SHORTDESCRIPTION_FIELD := HostQry.FieldByName('SHORTDESCRIPTION');
  var SEARCHDESCRIPTION_FIELD := HostQry.FieldByName('SEARCHDESCRIPTION');

  while Not HostQry.EOF do
  begin
    new(UserGenericGroupTypeAttributes);
    UserGenericGroupTypeAttributes.USERGENERICGROUPTYPECODE := Trim(USERGENERICGROUPTYPECODE_FIELD.AsString);
    UserGenericGroupTypeAttributes.CODE     := Trim(CODE_FIELD.AsString);
    UserGenericGroupTypeAttributes.ABSUNIQUEID     := Trim(ABSUNIQUEID_FIELD.AsString);
    UserGenericGroupTypeAttributes.LONGDESCRIPTION   := Trim(LONGDESCRIPTION_FIELD.AsString);
    UserGenericGroupTypeAttributes.SHORTDESCRIPTION  := Trim(SHORTDESCRIPTION_FIELD.AsString);
    UserGenericGroupTypeAttributes.SEARCHDESCRIPTION := Trim(SEARCHDESCRIPTION_FIELD.AsString);
    UserGenericGroupTypeAttributesList.Add(UserGenericGroupTypeAttributes);
    HostQry.next;
  end;
  UserGenericGroupTypeAttributesList.Sort(UserGenericGroup);
end;

//----------------------------------------------------------------------------//

function getColorTypeUNIQUEID(ColorTYPECODE, CODE : string; List : TList) : string;
var
  i: integer;
  Multiplier, NumberOfEntries, NumberOfEntriesMinusOne : integer;
  Request, step : variant;
  ColorType : PTColorUNIQUEID;
begin
  NumberOfEntries := List.Count;
  Result := '';

  if NumberOfEntries = 0 then exit;

  NumberOfEntriesMinusOne := NumberOfEntries - 1;
  Multiplier := 1;
  while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
  i := Multiplier - 1;

  while (Multiplier > 0) do
  begin
    Multiplier := trunc(Multiplier / 2);

    if (i > NumberOfEntriesMinusOne) then
    begin
      i := i - Multiplier;
      Continue;
    end;

    if (PTColorUNIQUEID(List[i]).COLORTYPECODE > ColorTYPECODE) then
    begin
   //   if I < Index then Index := I;
      i := i - Multiplier;
      Continue;
    end;

    if  (PTColorUNIQUEID(List[i]).COLORTYPECODE < ColorTYPECODE) then
    begin
      i := i + Multiplier;
      Continue;
    end;

    if  (PTColorUNIQUEID(List[i]).CODE > CODE) then
    begin
     // if I < Index then Index := I;
      i := i - Multiplier;
      Continue;
    end;

    if  (PTColorUNIQUEID(List[i]).CODE < CODE) then
    begin
      i := i + Multiplier;
      Continue;
    end;

    Result := PTColorUNIQUEID(List[i]).ABSUNIQUEID;
   // Index := i;
    Break;

  end;

end;

//----------------------------------------------------------------------------//

function getColorType(ITEMTYPECODE : string; POSITION : integer; List : TList) : string;
var
  i: integer;
  Multiplier, NumberOfEntries, NumberOfEntriesMinusOne : integer;
  Request, step : variant;
  ColorType : PTColorType;
begin
  NumberOfEntries := List.Count;
  Result := '';

  if NumberOfEntries = 0 then exit;

  NumberOfEntriesMinusOne := NumberOfEntries - 1;
  Multiplier := 1;
  while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
  i := Multiplier - 1;

  while (Multiplier > 0) do
  begin
    Multiplier := trunc(Multiplier / 2);

    if (i > NumberOfEntriesMinusOne) then
    begin
      i := i - Multiplier;
      Continue;
    end;

    if (PTColorType(List[i]).ITEMTYPECODE > ITEMTYPECODE) then
    begin
   //   if I < Index then Index := I;
      i := i - Multiplier;
      Continue;
    end;

    if  (PTColorType(List[i]).ITEMTYPECODE < ITEMTYPECODE) then
    begin
      i := i + Multiplier;
      Continue;
    end;

    if  (PTColorType(List[i]).POSITION > POSITION) then
    begin
     // if I < Index then Index := I;
      i := i - Multiplier;
      Continue;
    end;

    if  (PTColorType(List[i]).POSITION < POSITION) then
    begin
      i := i + Multiplier;
      Continue;
    end;

    Result := PTColorType(List[i]).GROUPTYPECODE;
   // Index := i;
    Break;

  end;

end;

//----------------------------------------------------------------------------//

function Color(Item1, Item2: Pointer) : integer;
var
  ColorTypeUNIQUEID1 : PTColorUNIQUEID;
  ColorTypeUNIQUEID2 : PTColorUNIQUEID;
begin
  ColorTypeUNIQUEID1 := PTColorUNIQUEID(Item1);
  ColorTypeUNIQUEID2 := PTColorUNIQUEID(Item2);
  if (ColorTypeUNIQUEID1.COLORTYPECODE < ColorTypeUNIQUEID2.COLORTYPECODE) then
    Result := -1
  else if (ColorTypeUNIQUEID1.COLORTYPECODE = ColorTypeUNIQUEID2.COLORTYPECODE) then
  begin
    if (ColorTypeUNIQUEID1.CODE < ColorTypeUNIQUEID2.CODE) then
      Result := -1
    else if (ColorTypeUNIQUEID1.CODE = ColorTypeUNIQUEID2.CODE) then
      Result := 0
    else
      Result := 1;
  end
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

procedure fillUserGenericGroupType(HostQry: TMqmQuery; UserGenericGroupTypeList : TList);
var
  hostSqlStr, CompanyInUsed: String;
  UserGenericGroupType : PTUserGenericGroupType;
begin
  if not GetCompanyLevelHandlingByEntityName('ITEMSUBCODETEMPLATE',  CompanyInUsed) then
     CompanyInUsed := IniAppGlobals.CompanyCode;

  hostSqlStr := ' Select ITEMTYPECODE, POSITION, GROUPTYPECODE ' +
                'from ITEMSUBCODETEMPLATE ' +
                'where itemtypecompanycode = ' + QuotedStr(CompanyInUsed) + ' ' +
                'and CHECKCODE = ' + QuotedStr('99') +
                ' and GROUPTYPECODE is not null ' +
                ' order by ITEMTYPECODE, POSITION ';
  HostQry.SQL.Text := hostSqlStr;
  HostQry.open;

  var ITEMTYPECODE_FIELD := HostQry.FieldByName('ITEMTYPECODE');
  var POSITION_FIELD := HostQry.FieldByName('POSITION');
  var GROUPTYPECODE_FIELD := HostQry.FieldByName('GROUPTYPECODE');

  while Not HostQry.EOF do
  begin
    new(UserGenericGroupType);
    UserGenericGroupType.ITEMTYPECODE := Trim(ITEMTYPECODE_FIELD.AsString);
    UserGenericGroupType.POSITION     := POSITION_FIELD.AsInteger;
    UserGenericGroupType.GROUPTYPECODE     := Trim(GROUPTYPECODE_FIELD.AsString);
    UserGenericGroupTypeList.Add(UserGenericGroupType);
    HostQry.next;
  end;
  UserGenericGroupTypeList.Sort(Sort_UserGenericGroupType)
end;

//----------------------------------------------------------------------------//

procedure fillColorTypeUNIQUEID(HostQry: TMqmQuery; ColorTypeUNIQUEIDList : TList; HandledColorTypesStr : string);
var
  hostSqlStr, CompanyInUsed: String;
  ColorTypeUNIQUEID : PTColorUNIQUEID;
  fldColorFolderCode, fldCode, fldAbsUniqueId: TField;
begin
  if not GetCompanyLevelHandlingByEntityName('COLOR',  CompanyInUsed) then
     CompanyInUsed := IniAppGlobals.CompanyCode;

  hostSqlStr := 'select COLORFOLDERCODE, CODE, ABSUNIQUEID ' +
                'from COLOR where COLORFOLDERCOMPANYCODE = ' + QuotedStr(CompanyInUsed) + ' ' +
                'and COLORFOLDERCODE in ( ' + HandledColorTypesStr + ') ' +
                ' order by COLORFOLDERCODE, CODE ';

  HostQry.SQL.Text := hostSqlStr;
  HostQry.open;
  fldColorFolderCode := HostQry.FieldByName('COLORFOLDERCODE');
  fldCode            := HostQry.FieldByName('CODE');
  fldAbsUniqueId     := HostQry.FieldByName('ABSUNIQUEID');
  while Not HostQry.EOF do
  begin
    new(ColorTypeUNIQUEID);
    ColorTypeUNIQUEID.COLORTYPECODE := Trim(fldColorFolderCode.AsString);
    ColorTypeUNIQUEID.CODE     := Trim(fldCode.AsString);
    ColorTypeUNIQUEID.ABSUNIQUEID     := Trim(fldAbsUniqueId.AsString);
    ColorTypeUNIQUEIDList.Add(ColorTypeUNIQUEID);
    HostQry.next;
  end;
  ColorTypeUNIQUEIDList.Sort(Color);
end;

//----------------------------------------------------------------------------//

procedure fillColorType(HostQry: TMqmQuery; ColorTypeList : TList);
var
  hostSqlStr, CompanyInUsed: String;
  ColorType : PTColorType;
  fldItemTypeCode, fldPosition, fldGroupTypeCode: TField;
begin
  if not GetCompanyLevelHandlingByEntityName('ITEMSUBCODETEMPLATE',  CompanyInUsed) then
     CompanyInUsed := IniAppGlobals.CompanyCode;

  hostSqlStr := ' Select ITEMTYPECODE, POSITION, GROUPTYPECODE ' +
                'from ITEMSUBCODETEMPLATE ' +
                'where itemtypecompanycode = ' + QuotedStr(CompanyInUsed) + ' ' +
                'and CHECKCODE = ' + QuotedStr('97') +
                ' and GROUPTYPECODE is not null ' +
                ' order by ITEMTYPECODE, POSITION ';
  HostQry.SQL.Text := hostSqlStr;
  HostQry.open;
  fldItemTypeCode  := HostQry.FieldByName('ITEMTYPECODE');
  fldPosition      := HostQry.FieldByName('POSITION');
  fldGroupTypeCode := HostQry.FieldByName('GROUPTYPECODE');
  while Not HostQry.EOF do
  begin
    new(ColorType);
    ColorType.ITEMTYPECODE := Trim(fldItemTypeCode.AsString);
    ColorType.POSITION     := fldPosition.AsInteger;
    ColorType.GROUPTYPECODE     := Trim(fldGroupTypeCode.AsString);
    ColorTypeList.Add(ColorType);
    HostQry.next;
  end;
  ColorTypeList.Sort(Sort_ColorType)
end;

//----------------------------------------------------------------------------//

function Sort_ADDITIONALDATA_DETAIL(Item1, Item2: Pointer) : integer;
var
  AD_Details1 : PADDITIONALDATA_DETAILS;
  AD_Details2 : PADDITIONALDATA_DETAILS;
begin
  AD_Details1 := PADDITIONALDATA_DETAILS(Item1);
  AD_Details2 := PADDITIONALDATA_DETAILS(Item2);
  if AD_Details1.FIELDNAME < AD_Details2.FIELDNAME then
    Result := -1
  else if (AD_Details1.FIELDNAME = AD_Details2.FIELDNAME) then
    Result := 0
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

procedure fillAdditionalDataStruct(HostQry: TMqmQuery; additionalDataList, UserGenericGroupTypeList, ColorTypeList : TList; AD_Product_SelectColums : string; AD_FullItemKeyDecoder_SelectColums : string;
            AD_ProductionDemand_SelectColums : string; AD_ProductionDemandStep_SelectColums : string;
            HandledProductionDemandMqinSql : String; var HandledUserGenericGroupTypesStr, HandledColorTypesStr : string; AtLeast_1_Wc_HandledWarp : boolean; WarpItemHandledStr : string);
var
  hostSqlStr: String;
  NEWADDITIONALDATA_HEADER, CurrentADDITIONALDATA_HEADER: PADDITIONALDATA_HEADERS;
  NEWADDITIONALDATA_DETAIL: PADDITIONALDATA_DETAILS;
  AD_Recipe_SelectColums, AD_Design_SelectColums, AD_SalesOrder_SelectColums : string;
  AD_SalesOrderLine_SelectColums, AD_SalesOrderDelivery_SelectColums, AD_Project_SelectColums : string;
  UserGenericGroup_AD, Color_AD, Project_AD : string;
  UserGenericGroupKeyNumber, ColorKeyNumber : integer;
  lastReadUniqueId, tblArcName, columnNameTemp, TableNameTemp : String;
  CompanyInUsed_IT, CompanyInUsed_PD, CompanyInUsed_P, CompanyInUsed_FIKD, CompanyInUsed_PDS, CompanyInUsed_Recipe, CompanyInUsed_Design, CompanyInUsed_UGG, CompanyInUsed_Color  : string;
  srvSqlStr, columnName, ItemType, GenericGroupCodeType, ColorCodeType : String;
  UserGenericGroupTypeCodeStrList, ColorTypeCodeStrList, ColorTimeList, ProjectADList : TStringList;
  srvQry : TMqmQuery;
  AddUnion : boolean;
  DndArchiveArcName, DndArchiveHostName : TDndArchiveName;
  I : Integer;
  SqlLog : TStringList;
  COLUMN_NAME_FIELD, ITEMTYPE_FIELD, TABLE_NAME_FIELD : Tfield;
begin
  HandledUserGenericGroupTypesStr := '';
  HandledColorTypesStr := '';
  DndArchiveHostName := GetDndArchiveLocalName;

  HostQry := ThreadCreateQueryHost;

  if not GetCompanyLevelHandlingByEntityName('PRODUCTIONDEMAND',  CompanyInUsed_PD) then
     CompanyInUsed_PD := IniAppGlobals.CompanyCode;

  if not GetCompanyLevelHandlingByEntityName('ITEMTYPE',  CompanyInUsed_IT) then
     CompanyInUsed_IT := IniAppGlobals.CompanyCode;

  if not GetCompanyLevelHandlingByEntityName('PRODUCT',  CompanyInUsed_P) then
     CompanyInUsed_P := IniAppGlobals.CompanyCode;

  if not GetCompanyLevelHandlingByEntityName('FULLITEMKEYDECODER',  CompanyInUsed_FIKD) then
     CompanyInUsed_FIKD := IniAppGlobals.CompanyCode;

  if not GetCompanyLevelHandlingByEntityName('PRODUCTIONDEMANDSTEP',  CompanyInUsed_PDS) then
     CompanyInUsed_PDS := IniAppGlobals.CompanyCode;

  if not GetCompanyLevelHandlingByEntityName('RECIPE',  CompanyInUsed_Recipe) then
     CompanyInUsed_Recipe := IniAppGlobals.CompanyCode;

  if not GetCompanyLevelHandlingByEntityName('DESIGN',  CompanyInUsed_Design) then
     CompanyInUsed_Design := IniAppGlobals.CompanyCode;

  if not GetCompanyLevelHandlingByEntityName('USERGENERICGROUP', CompanyInUsed_UGG) then
     CompanyInUsed_UGG := IniAppGlobals.CompanyCode;

  if not GetCompanyLevelHandlingByEntityName('COLOR', CompanyInUsed_Color) then
     CompanyInUsed_Color := IniAppGlobals.CompanyCode;
  srvQry := ThreadCreateQueryArc;

  UserGenericGroupTypeCodeStrList := TStringList.Create;
  ColorTypeCodeStrList := TStringList.Create;
  ColorTimeList := TStringList.Create;
  ProjectADList := TStringList.Create;

  DndArchiveArcName := GetDndArchiveLocalName;
  if DndArchiveArcName = TD_Interbase then
    tblArcName  := 'PROPERTY_RTV_VALUE'
  else
    tblArcName  := 'SCDA_' + 'PROPERTY_RTV_VALUE';

  srvSqlStr := 'SELECT DISTINCT COLUMN_NAME FROM ' + tblArcName + ' WHERE TABLE_NAME = ' + QuotedStr('Recipe AD') + AND_IDF_Condition('IDENTIFIER');
  srvQry.SQL.Text := srvSqlStr;
  srvQry.Active := true;
  AD_Recipe_SelectColums := '';

  COLUMN_NAME_FIELD := srvQry.FieldByName('COLUMN_NAME');
  while (not srvQry.Eof ) do
  begin
    columnName := Trim(COLUMN_NAME_FIELD.AsString);
    if AD_Recipe_SelectColums <> '' then AD_Recipe_SelectColums := AD_Recipe_SelectColums + ',';
    AD_Recipe_SelectColums := AD_Recipe_SelectColums + QuotedStr(columnName);
    srvQry.Next;
  end;
  srvQry.Active := false;

  srvSqlStr := 'SELECT DISTINCT COLUMN_NAME FROM ' + tblArcName + ' WHERE TABLE_NAME = ' + QuotedStr('Design AD') + AND_IDF_Condition('IDENTIFIER');
  srvQry.SQL.Text := srvSqlStr;
  srvQry.Active := true;
  var COLUMN_NAME_FIELD1 := srvQry.FieldByName('COLUMN_NAME');
  AD_Design_SelectColums := '';
  while (not srvQry.Eof ) do
  begin
    columnName := Trim(COLUMN_NAME_FIELD1.AsString);
    if AD_Design_SelectColums <> '' then AD_Design_SelectColums := AD_Design_SelectColums + ',';
    AD_Design_SelectColums := AD_Design_SelectColums + QuotedStr(columnName);
    srvQry.Next;
  end;
  srvQry.Active := false;

  srvSqlStr := 'SELECT DISTINCT COLUMN_NAME FROM ' + tblArcName + ' WHERE TABLE_NAME = ' + QuotedStr('SalesOrder AD') + AND_IDF_Condition('IDENTIFIER');
  srvQry.SQL.Text := srvSqlStr;
  srvQry.Active := true;
  var COLUMN_NAME_FIELD2 := srvQry.FieldByName('COLUMN_NAME');
  AD_SalesOrder_SelectColums := '';
  while (not srvQry.Eof ) do
  begin
    columnName := Trim(COLUMN_NAME_FIELD2.AsString);
    if AD_SalesOrder_SelectColums <> '' then AD_SalesOrder_SelectColums := AD_SalesOrder_SelectColums + ',';
    AD_SalesOrder_SelectColums := AD_SalesOrder_SelectColums + QuotedStr(columnName);
    srvQry.Next;
  end;
  srvQry.Active := false;

  srvSqlStr := 'SELECT DISTINCT COLUMN_NAME FROM ' + tblArcName + ' WHERE TABLE_NAME = ' + QuotedStr('SalesOrderLine AD') + AND_IDF_Condition('IDENTIFIER');
  srvQry.SQL.Text := srvSqlStr;
  srvQry.Active := true;
  var COLUMN_NAME_FIELD3 := srvQry.FieldByName('COLUMN_NAME');
  AD_SalesOrderLine_SelectColums := '';
  while (not srvQry.Eof ) do
  begin
    columnName := Trim(COLUMN_NAME_FIELD3.AsString);
    if AD_SalesOrderLine_SelectColums <> '' then AD_SalesOrderLine_SelectColums := AD_SalesOrderLine_SelectColums + ',';
    AD_SalesOrderLine_SelectColums := AD_SalesOrderLine_SelectColums + QuotedStr(columnName);
    srvQry.Next;
  end;
  srvQry.Active := false;

  srvSqlStr := 'SELECT DISTINCT COLUMN_NAME FROM ' + tblArcName + ' WHERE TABLE_NAME = ' + QuotedStr('SalesOrderDelivery AD') + AND_IDF_Condition('IDENTIFIER');
  srvQry.SQL.Text := srvSqlStr;
  srvQry.Active := true;
  var COLUMN_NAME_FIELD4 := srvQry.FieldByName('COLUMN_NAME');
  AD_SalesOrderDelivery_SelectColums := '';
  while (not srvQry.Eof ) do
  begin
    columnName := Trim(COLUMN_NAME_FIELD4.AsString);
    if AD_SalesOrderDelivery_SelectColums <> '' then AD_SalesOrderDelivery_SelectColums := AD_SalesOrderDelivery_SelectColums + ',';
    AD_SalesOrderDelivery_SelectColums := AD_SalesOrderDelivery_SelectColums + QuotedStr(columnName);
    srvQry.Next;
  end;
  srvQry.Active := false;

  srvSqlStr := 'SELECT DISTINCT COLUMN_NAME FROM ' + tblArcName + ' WHERE TABLE_NAME = ' + QuotedStr('Project AD') + AND_IDF_Condition('IDENTIFIER');
  srvQry.SQL.Text := srvSqlStr;
  srvQry.Active := true;
  var COLUMN_NAME_FIELD5 := srvQry.FieldByName('COLUMN_NAME');
  AD_Project_SelectColums := '';
  while (not srvQry.Eof ) do
  begin
    columnName := Trim(COLUMN_NAME_FIELD5.AsString);
    ProjectADList.Add(columnName);
    if AD_Project_SelectColums <> '' then AD_Project_SelectColums := AD_Project_SelectColums + ',';
    AD_Project_SelectColums := AD_Project_SelectColums + QuotedStr(columnName);
    srvQry.Next;
  end;
  srvQry.Active := false;

  srvSqlStr := 'SELECT DISTINCT TABLE_NAME, COLUMN_NAME, ITEMTYPE FROM ' + tblArcName + ' WHERE TABLE_NAME LIKE ' + QuotedStr('UserGenericGroup AD%') + AND_IDF_Condition('IDENTIFIER');
  srvQry.SQL.Text := srvSqlStr;
  srvQry.Active := true;
  var COLUMN_NAME_FIELD6 := srvQry.FieldByName('COLUMN_NAME');
  ITEMTYPE_FIELD := srvQry.FieldByName('ITEMTYPE');
  TABLE_NAME_FIELD := srvQry.FieldByName('TABLE_NAME');
  UserGenericGroup_AD := '';
  while (not srvQry.Eof ) do
  begin
    columnName := Trim(COLUMN_NAME_FIELD6.AsString);
    ItemType   := Trim(ITEMTYPE_FIELD.AsString);
    UserGenericGroupKeyNumber := strtoint(copy(TABLE_NAME_FIELD.AsString, 28, 2));
    GenericGroupCodeType := getUserGenericGroupType(ItemType, UserGenericGroupKeyNumber, UserGenericGroupTypeList);
    if (GenericGroupCodeType <> '') and (UserGenericGroupTypeCodeStrList.IndexOf(GenericGroupCodeType) = -1) then
      UserGenericGroupTypeCodeStrList.Add(GenericGroupCodeType);
    if UserGenericGroup_AD <> '' then UserGenericGroup_AD := UserGenericGroup_AD + ',';
    UserGenericGroup_AD := UserGenericGroup_AD + QuotedStr(columnName);
    ColorTimeList.Add(columnName);
    srvQry.Next;
  end;
  srvQry.Active := false;

  srvSqlStr := 'SELECT DISTINCT TABLE_NAME, COLUMN_NAME, ITEMTYPE FROM ' + tblArcName + ' WHERE TABLE_NAME LIKE ' + QuotedStr('Color AD%') + AND_IDF_Condition('IDENTIFIER');
  srvQry.SQL.Text := srvSqlStr;
  srvQry.Active := true;
  var COLUMN_NAME_FIELD7 := srvQry.FieldByName('COLUMN_NAME');
  var ITEMTYPE_FIELD2 := srvQry.FieldByName('ITEMTYPE');
  var TABLE_NAME_FIELD2 := srvQry.FieldByName('TABLE_NAME');
  Color_AD := '';
  while (not srvQry.Eof ) do
  begin
    columnName := Trim(COLUMN_NAME_FIELD7.AsString);
    ItemType   := Trim(ITEMTYPE_FIELD2.AsString);
    ColorKeyNumber := strtoint(copy(TABLE_NAME_FIELD2.AsString, 17, 2));
    ColorCodeType := getColorType(ItemType, ColorKeyNumber, ColorTypeList);
    if (ColorCodeType <> '') and (ColorTypeCodeStrList.IndexOf(ColorCodeType) = -1) then
      ColorTypeCodeStrList.Add(ColorCodeType);
    if Color_AD <> '' then Color_AD := Color_AD + ',';
    Color_AD := Color_AD + QuotedStr(columnName);
    ColorTimeList.Add(columnName);
    srvQry.Next;
  end;
  srvQry.Active := false;

  if DndArchiveArcName = TD_Interbase then
    tblArcName  := 'PRODUCTION_TIMES_LEVEL'
  else
    tblArcName  := 'SCDA_' + 'PRODUCTION_TIMES_LEVEL';

/////////////

  srvSqlStr := 'SELECT DISTINCT TABLENAME1, COLUMNNAME1, TABLENAME2, COLUMNNAME2, TABLENAME3, COLUMNNAME3, ' +
               ' TABLENAME4, COLUMNNAME4, TABLENAME5, COLUMNNAME5, TABLENAME6, COLUMNNAME6, ' +
               ' TABLENAME7, COLUMNNAME7, TABLENAME8, COLUMNNAME8, TABLENAME9, COLUMNNAME9, TABLENAME10, COLUMNNAME10 ' +
               ' FROM ' + tblArcName +
               ' WHERE (TABLENAME1 = ' + QuotedStr('Project AD') + AND_IDF_Condition('IDENTIFIER') + ')' + ' OR ' +
               ' (TABLENAME2 = ' + QuotedStr('Project AD') + AND_IDF_Condition('IDENTIFIER') + ')' + ' OR ' +
               ' (TABLENAME3 = ' + QuotedStr('Project AD') + AND_IDF_Condition('IDENTIFIER') + ')' + ' OR ' +
               ' (TABLENAME4 = ' + QuotedStr('Project AD') + AND_IDF_Condition('IDENTIFIER') + ')' + ' OR ' +
               ' (TABLENAME5 = ' + QuotedStr('Project AD') + AND_IDF_Condition('IDENTIFIER') + ')' + ' OR ' +
               ' (TABLENAME6 = ' + QuotedStr('Project AD') + AND_IDF_Condition('IDENTIFIER') + ')' + ' OR ' +
               ' (TABLENAME7 = ' + QuotedStr('Project AD') + AND_IDF_Condition('IDENTIFIER') + ')' + ' OR ' +
               ' (TABLENAME8 = ' + QuotedStr('Project AD') + AND_IDF_Condition('IDENTIFIER') + ')' + ' OR ' +
               ' (TABLENAME9 = ' + QuotedStr('Project AD') + AND_IDF_Condition('IDENTIFIER') + ')' + ' OR ' +
               ' (TABLENAME10 = ' + QuotedStr('Project AD') + AND_IDF_Condition('IDENTIFIER') + ')';

  srvQry.SQL.Text := srvSqlStr;
  srvQry.Active := true;

  while (not srvQry.Eof ) do
  begin
    TableNameTemp := srvQry.FieldByName('TABLENAME1').AsString;
    if (copy(TableNameTemp, 1, 10) = 'Project AD') then
    begin
      columnNameTemp := Trim(srvQry.FieldByName('COLUMNNAME1').AsString);
      if (ProjectADList.IndexOf(columnNameTemp) = -1) then
      begin
        if AD_Project_SelectColums <> '' then AD_Project_SelectColums := AD_Project_SelectColums + ',';
        AD_Project_SelectColums := AD_Project_SelectColums + QuotedStr(columnNameTemp)
      end;
    end;

    TableNameTemp := srvQry.FieldByName('TABLENAME2').AsString;
    if (copy(TableNameTemp, 1, 10) = 'Project AD') then
    begin
      TableNameTemp := srvQry.FieldByName('TABLENAME2').AsString;
      if (ProjectADList.IndexOf(columnNameTemp) = -1) then
      begin
        if AD_Project_SelectColums <> '' then AD_Project_SelectColums := AD_Project_SelectColums + ',';
        AD_Project_SelectColums := AD_Project_SelectColums + QuotedStr(columnNameTemp);
      end;
    end;

    TableNameTemp := srvQry.FieldByName('TABLENAME3').AsString;
    if (copy(TableNameTemp, 1, 10) = 'Project AD') then
    begin
      columnNameTemp := Trim(srvQry.FieldByName('COLUMNNAME3').AsString);
      if (ProjectADList.IndexOf(columnNameTemp) = -1) then
      begin
        if AD_Project_SelectColums <> '' then AD_Project_SelectColums := AD_Project_SelectColums + ',';
        AD_Project_SelectColums := AD_Project_SelectColums + QuotedStr(columnNameTemp);
      end;
    end;

    TableNameTemp := srvQry.FieldByName('TABLENAME4').AsString;
    if (copy(TableNameTemp, 1, 10) = 'Project AD') then
    begin
      columnNameTemp := Trim(srvQry.FieldByName('COLUMNNAME4').AsString);
      if (ProjectADList.IndexOf(columnNameTemp) = -1) then
      begin
        if AD_Project_SelectColums <> '' then AD_Project_SelectColums := AD_Project_SelectColums + ',';
        AD_Project_SelectColums := AD_Project_SelectColums + QuotedStr(columnNameTemp);
      end;
    end;

    TableNameTemp := srvQry.FieldByName('TABLENAME5').AsString;
    if (copy(TableNameTemp, 1, 10) = 'Project AD') then
    begin
      columnNameTemp := Trim(srvQry.FieldByName('COLUMNNAME5').AsString);
      if (ProjectADList.IndexOf(columnNameTemp) = -1) then
      begin
        if AD_Project_SelectColums <> '' then AD_Project_SelectColums := AD_Project_SelectColums + ',';
        AD_Project_SelectColums := AD_Project_SelectColums + QuotedStr(columnNameTemp);
      end;
    end;

    TableNameTemp := srvQry.FieldByName('TABLENAME6').AsString;
    if (copy(TableNameTemp, 1, 10) = 'Project AD') then
    begin
      columnNameTemp := Trim(srvQry.FieldByName('COLUMNNAME6').AsString);
      if (ProjectADList.IndexOf(columnNameTemp) = -1) then
      begin
        if AD_Project_SelectColums <> '' then AD_Project_SelectColums := AD_Project_SelectColums + ',';
        AD_Project_SelectColums := AD_Project_SelectColums + QuotedStr(columnNameTemp);
      end;
    end;

    TableNameTemp := srvQry.FieldByName('TABLENAME7').AsString;
    if (copy(TableNameTemp, 1, 10) = 'Project AD') then
    begin
      columnNameTemp := Trim(srvQry.FieldByName('COLUMNNAME7').AsString);
      if (ProjectADList.IndexOf(columnNameTemp) = -1) then
      begin
        if AD_Project_SelectColums <> '' then AD_Project_SelectColums := AD_Project_SelectColums + ',';
        AD_Project_SelectColums := AD_Project_SelectColums + QuotedStr(columnNameTemp);
      end;
    end;

    TableNameTemp := srvQry.FieldByName('TABLENAME8').AsString;
    if (copy(TableNameTemp, 1, 10) = 'Project AD') then
    begin
      columnNameTemp := Trim(srvQry.FieldByName('COLUMNNAME8').AsString);
      if (ProjectADList.IndexOf(columnNameTemp) = -1) then
      begin
        if AD_Project_SelectColums <> '' then AD_Project_SelectColums := AD_Project_SelectColums + ',';
        AD_Project_SelectColums := AD_Project_SelectColums + QuotedStr(columnNameTemp);
      end;
    end;

    TableNameTemp := srvQry.FieldByName('TABLENAME9').AsString;
    if (copy(TableNameTemp, 1, 10) = 'Project AD') then
    begin
      columnNameTemp := Trim(srvQry.FieldByName('COLUMNNAME9').AsString);
      if (ProjectADList.IndexOf(columnNameTemp) = -1) then
      begin
        if AD_Project_SelectColums <> '' then AD_Project_SelectColums := AD_Project_SelectColums + ',';
        AD_Project_SelectColums := AD_Project_SelectColums + QuotedStr(columnNameTemp);
      end;
    end;

    TableNameTemp := srvQry.FieldByName('TABLENAME10').AsString;
    if (copy(TableNameTemp, 1, 10) = 'Project AD') then
    begin
      columnNameTemp := Trim(srvQry.FieldByName('COLUMNNAME10').AsString);
      if (ProjectADList.IndexOf(columnNameTemp) = -1) then
      begin
        if AD_Project_SelectColums <> '' then AD_Project_SelectColums := AD_Project_SelectColums + ',';
        AD_Project_SelectColums := AD_Project_SelectColums + QuotedStr(columnNameTemp);
      end;
    end;

    srvQry.Next;
  end;

  srvQry.Close;

/////////////

  srvSqlStr := 'SELECT DISTINCT TABLENAME1, COLUMNNAME1, TABLENAME2, COLUMNNAME2, TABLENAME3, COLUMNNAME3, ' +
               ' TABLENAME4, COLUMNNAME4, TABLENAME5, COLUMNNAME5, TABLENAME6, COLUMNNAME6, ' +
               ' TABLENAME7, COLUMNNAME7, TABLENAME8, COLUMNNAME8, TABLENAME9, COLUMNNAME9, TABLENAME10, COLUMNNAME10 ' +
               ' FROM ' + tblArcName +
               ' WHERE (TABLENAME1 LIKE ' + QuotedStr('Color AD%') + AND_IDF_Condition('IDENTIFIER') + ')' + ' OR ' +
               ' (TABLENAME2 LIKE ' + QuotedStr('Color AD%') + AND_IDF_Condition('IDENTIFIER') + ')' + ' OR ' +
               ' (TABLENAME3 LIKE ' + QuotedStr('Color AD%') + AND_IDF_Condition('IDENTIFIER') + ')' + ' OR ' +
               ' (TABLENAME4 LIKE ' + QuotedStr('Color AD%') + AND_IDF_Condition('IDENTIFIER') + ')' + ' OR ' +
               ' (TABLENAME5 LIKE ' + QuotedStr('Color AD%') + AND_IDF_Condition('IDENTIFIER') + ')' + ' OR ' +
               ' (TABLENAME6 LIKE ' + QuotedStr('Color AD%') + AND_IDF_Condition('IDENTIFIER') + ')' + ' OR ' +
               ' (TABLENAME7 LIKE ' + QuotedStr('Color AD%') + AND_IDF_Condition('IDENTIFIER') + ')' + ' OR ' +
               ' (TABLENAME8 LIKE ' + QuotedStr('Color AD%') + AND_IDF_Condition('IDENTIFIER') + ')' + ' OR ' +
               ' (TABLENAME9 LIKE ' + QuotedStr('Color AD%') + AND_IDF_Condition('IDENTIFIER') + ')' + ' OR ' +
               ' (TABLENAME10 LIKE ' + QuotedStr('Color AD%') + AND_IDF_Condition('IDENTIFIER') + ')';

  srvQry.SQL.Text := srvSqlStr;
  srvQry.Active := true;

  while (not srvQry.Eof ) do
  begin
    TableNameTemp := srvQry.FieldByName('TABLENAME1').AsString;
    if (copy(TableNameTemp, 1, 8) = 'Color AD') then
    begin
      columnNameTemp := srvQry.FieldByName('COLUMNNAME1').AsString;
      if (ColorTimeList.IndexOf(columnNameTemp) = -1) then
      begin
        ColorTimeList.Add(columnNameTemp);
        if Color_AD <> '' then Color_AD := Color_AD + ',';
        Color_AD := Color_AD + QuotedStr(columnNameTemp);
      end;
    end;

    TableNameTemp := srvQry.FieldByName('TABLENAME2').AsString;
    if (copy(TableNameTemp, 1, 8) = 'Color AD') then
    begin
      columnNameTemp := srvQry.FieldByName('COLUMNNAME2').AsString;
      if (ColorTimeList.IndexOf(columnNameTemp) = -1) then
      begin
        ColorTimeList.Add(columnNameTemp);
        if Color_AD <> '' then Color_AD := Color_AD + ',';
        Color_AD := Color_AD + QuotedStr(columnNameTemp);
      end;
    end;

    TableNameTemp := srvQry.FieldByName('TABLENAME3').AsString;
    if (copy(TableNameTemp, 1, 8) = 'Color AD') then
    begin
      columnNameTemp := srvQry.FieldByName('COLUMNNAME3').AsString;
      if (ColorTimeList.IndexOf(columnNameTemp) = -1) then
      begin
        ColorTimeList.Add(columnNameTemp);
        if Color_AD <> '' then Color_AD := Color_AD + ',';
        Color_AD := Color_AD + QuotedStr(columnNameTemp);
      end;
    end;

    TableNameTemp := srvQry.FieldByName('TABLENAME4').AsString;
    if (copy(TableNameTemp, 1, 8) = 'Color AD') then
    begin
      columnNameTemp := srvQry.FieldByName('COLUMNNAME4').AsString;
      if (ColorTimeList.IndexOf(columnNameTemp) = -1) then
      begin
        ColorTimeList.Add(columnNameTemp);
        if Color_AD <> '' then Color_AD := Color_AD + ',';
        Color_AD := Color_AD + QuotedStr(columnNameTemp);
      end;
    end;

    TableNameTemp := srvQry.FieldByName('TABLENAME5').AsString;
    if (copy(TableNameTemp, 1, 8) = 'Color AD') then
    begin
      columnNameTemp := srvQry.FieldByName('COLUMNNAME5').AsString;
      if (ColorTimeList.IndexOf(columnNameTemp) = -1) then
      begin
        ColorTimeList.Add(columnNameTemp);
        if Color_AD <> '' then Color_AD := Color_AD + ',';
        Color_AD := Color_AD + QuotedStr(columnNameTemp);
      end;
    end;

    TableNameTemp := srvQry.FieldByName('TABLENAME6').AsString;
    if (copy(TableNameTemp, 1, 8) = 'Color AD') then
    begin
      columnNameTemp := srvQry.FieldByName('COLUMNNAME6').AsString;
      if (ColorTimeList.IndexOf(columnNameTemp) = -1) then
      begin
        ColorTimeList.Add(columnNameTemp);
        if Color_AD <> '' then Color_AD := Color_AD + ',';
        Color_AD := Color_AD + QuotedStr(columnNameTemp);
      end;
    end;

    TableNameTemp := srvQry.FieldByName('TABLENAME7').AsString;
    if (copy(TableNameTemp, 1, 8) = 'Color AD') then
    begin
      columnNameTemp := srvQry.FieldByName('COLUMNNAME7').AsString;
      if (ColorTimeList.IndexOf(columnNameTemp) = -1) then
      begin
        ColorTimeList.Add(columnNameTemp);
        if Color_AD <> '' then Color_AD := Color_AD + ',';
        Color_AD := Color_AD + QuotedStr(columnNameTemp);
      end;
    end;

    TableNameTemp := srvQry.FieldByName('TABLENAME8').AsString;
    if (copy(TableNameTemp, 1, 8) = 'Color AD') then
    begin
      columnNameTemp := srvQry.FieldByName('COLUMNNAME8').AsString;
      if (ColorTimeList.IndexOf(columnNameTemp) = -1) then
      begin
        ColorTimeList.Add(columnNameTemp);
        if Color_AD <> '' then Color_AD := Color_AD + ',';
        Color_AD := Color_AD + QuotedStr(columnNameTemp);
      end;
    end;

    TableNameTemp := srvQry.FieldByName('TABLENAME9').AsString;
    if (copy(TableNameTemp, 1, 8) = 'Color AD') then
    begin
      columnNameTemp := srvQry.FieldByName('COLUMNNAME9').AsString;
      if (ColorTimeList.IndexOf(columnNameTemp) = -1) then
      begin
        ColorTimeList.Add(columnNameTemp);
        if Color_AD <> '' then Color_AD := Color_AD + ',';
        Color_AD := Color_AD + QuotedStr(columnNameTemp);
      end;
    end;

    TableNameTemp := srvQry.FieldByName('TABLENAME10').AsString;
    if (copy(TableNameTemp, 1, 8) = 'Color AD') then
    begin
      columnNameTemp := srvQry.FieldByName('COLUMNNAME10').AsString;
      if (ColorTimeList.IndexOf(columnNameTemp) = -1) then
      begin
        ColorTimeList.Add(columnNameTemp);
        if Color_AD <> '' then Color_AD := Color_AD + ',';
        Color_AD := Color_AD + QuotedStr(columnNameTemp);
      end;
    end;

    srvQry.Next;
  end;

/////////////

  srvSqlStr := 'SELECT DISTINCT PRODUCT_TYPE, TABLENAME1, COLUMNNAME1, TABLENAME2, COLUMNNAME2, TABLENAME3, COLUMNNAME3, ' +
               ' TABLENAME4, COLUMNNAME4, TABLENAME5, COLUMNNAME5, TABLENAME6, COLUMNNAME6, ' +
               ' TABLENAME7, COLUMNNAME7, TABLENAME8, COLUMNNAME8, TABLENAME9, COLUMNNAME9, TABLENAME10, COLUMNNAME10 ' +
               ' FROM ' + tblArcName +
               ' WHERE (TABLENAME1 LIKE ' + QuotedStr('UserGenericGroup AD%') + AND_IDF_Condition('IDENTIFIER') + ')' + ' OR ' +
               ' (TABLENAME2 LIKE ' + QuotedStr('UserGenericGroup AD%') + AND_IDF_Condition('IDENTIFIER') + ')' + ' OR ' +
               ' (TABLENAME3 LIKE ' + QuotedStr('UserGenericGroup AD%') + AND_IDF_Condition('IDENTIFIER') + ')' + ' OR ' +
               ' (TABLENAME4 LIKE ' + QuotedStr('UserGenericGroup AD%') + AND_IDF_Condition('IDENTIFIER') + ')' + ' OR ' +
               ' (TABLENAME5 LIKE ' + QuotedStr('UserGenericGroup AD%') + AND_IDF_Condition('IDENTIFIER') + ')' + ' OR ' +
               ' (TABLENAME6 LIKE ' + QuotedStr('UserGenericGroup AD%') + AND_IDF_Condition('IDENTIFIER') + ')' + ' OR ' +
               ' (TABLENAME7 LIKE ' + QuotedStr('UserGenericGroup AD%') + AND_IDF_Condition('IDENTIFIER') + ')' + ' OR ' +
               ' (TABLENAME8 LIKE ' + QuotedStr('UserGenericGroup AD%') + AND_IDF_Condition('IDENTIFIER') + ')' + ' OR ' +
               ' (TABLENAME9 LIKE ' + QuotedStr('UserGenericGroup AD%') + AND_IDF_Condition('IDENTIFIER') + ')' + ' OR ' +
               ' (TABLENAME10 LIKE ' + QuotedStr('UserGenericGroup AD%') + AND_IDF_Condition('IDENTIFIER') + ')';

  srvQry.SQL.Text := srvSqlStr;
  srvQry.Active := true;

  while (not srvQry.Eof ) do
  begin
    ItemType   := Trim(srvQry.FieldByName('PRODUCT_TYPE').AsString);
    for I := 1 to 10 do
    begin
      case I of
        1: TableNameTemp := srvQry.FieldByName('TABLENAME1').AsString;
        2: TableNameTemp := srvQry.FieldByName('TABLENAME2').AsString;
        3: TableNameTemp := srvQry.FieldByName('TABLENAME3').AsString;
        4: TableNameTemp := srvQry.FieldByName('TABLENAME4').AsString;
        5: TableNameTemp := srvQry.FieldByName('TABLENAME5').AsString;
        6: TableNameTemp := srvQry.FieldByName('TABLENAME6').AsString;
        7: TableNameTemp := srvQry.FieldByName('TABLENAME7').AsString;
        8: TableNameTemp := srvQry.FieldByName('TABLENAME8').AsString;
        9: TableNameTemp := srvQry.FieldByName('TABLENAME9').AsString;
        10: TableNameTemp := srvQry.FieldByName('TABLENAME10').AsString;
      end;
      case I of
        1: columnNameTemp := srvQry.FieldByName('COLUMNNAME1').AsString;
        2: columnNameTemp := srvQry.FieldByName('COLUMNNAME2').AsString;
        3: columnNameTemp := srvQry.FieldByName('COLUMNNAME3').AsString;
        4: columnNameTemp := srvQry.FieldByName('COLUMNNAME4').AsString;
        5: columnNameTemp := srvQry.FieldByName('COLUMNNAME5').AsString;
        6: columnNameTemp := srvQry.FieldByName('COLUMNNAME6').AsString;
        7: columnNameTemp := srvQry.FieldByName('COLUMNNAME7').AsString;
        8: columnNameTemp := srvQry.FieldByName('COLUMNNAME8').AsString;
        9: columnNameTemp := srvQry.FieldByName('COLUMNNAME9').AsString;
        10: columnNameTemp := srvQry.FieldByName('COLUMNNAME10').AsString;
      end;
      if (copy(TableNameTemp, 1, 19) = 'UserGenericGroup AD') then
      begin
        UserGenericGroupKeyNumber := strtoint(copy(TableNameTemp, 28, 2));
        GenericGroupCodeType := getUserGenericGroupType(ItemType, UserGenericGroupKeyNumber, UserGenericGroupTypeList);
        if (GenericGroupCodeType <> '') and (UserGenericGroupTypeCodeStrList.IndexOf(GenericGroupCodeType) = -1) then
          UserGenericGroupTypeCodeStrList.Add(GenericGroupCodeType);
        if UserGenericGroup_AD <> '' then UserGenericGroup_AD := UserGenericGroup_AD + ',';
        UserGenericGroup_AD := UserGenericGroup_AD + QuotedStr(columnNameTemp);
      end;
    end;
    srvQry.Next;
  end;

  srvQry.Close;

////////////////////

  if DndArchiveArcName = TD_Interbase then
    tblArcName  := 'ARTICLE_TYPE'
  else
    tblArcName  := 'SCDA_' + 'ARTICLE_TYPE';

  srvSqlStr := 'SELECT DISTINCT AT_ART_TYPE, AT_TABLE_NAME, AT_RELATED_COLUMN_NAME ' +
               ' FROM ' + tblArcName +
               ' WHERE AT_TABLE_NAME LIKE ' + QuotedStr('UserGenericGroup AD%') + AND_IDF_Condition('AT_IDENTIFIER');

  srvQry.SQL.Text := srvSqlStr;
  srvQry.Active := true;

  while (not srvQry.Eof ) do
  begin
    ItemType   := Trim(srvQry.FieldByName('AT_ART_TYPE').AsString);
    TableNameTemp := srvQry.FieldByName('AT_TABLE_NAME').AsString;
    if (copy(TableNameTemp, 1, 19) = 'UserGenericGroup AD') then
    begin
      UserGenericGroupKeyNumber := strtoint(copy(TableNameTemp, 28, 2));
      GenericGroupCodeType := getUserGenericGroupType(ItemType, UserGenericGroupKeyNumber, UserGenericGroupTypeList);
      if (GenericGroupCodeType <> '') and (UserGenericGroupTypeCodeStrList.IndexOf(GenericGroupCodeType) = -1) then
        UserGenericGroupTypeCodeStrList.Add(GenericGroupCodeType);
      if UserGenericGroup_AD <> '' then UserGenericGroup_AD := UserGenericGroup_AD + ',';
      UserGenericGroup_AD := UserGenericGroup_AD + QuotedStr(columnNameTemp);
    end;
    srvQry.Next;
  end;
  srvQry.Close;

//////////////////////

  if  (AD_Product_SelectColums = QuotedStr(''))
  and (AD_FullItemKeyDecoder_SelectColums = QuotedStr(''))
  and (AD_ProductionDemand_SelectColums = QuotedStr(''))
  and (AD_ProductionDemandStep_SelectColums = QuotedStr(''))
  and (AD_Recipe_SelectColums = '')
  and (AD_Design_SelectColums = '')
  and (AD_SalesOrder_SelectColums = '')
  and (AD_SalesOrderLine_SelectColums = '')
  and (AD_SalesOrderDelivery_SelectColums = '')
  and (AD_Project_SelectColums = '')
  and (Color_AD = '')
  and (UserGenericGroup_AD = '') then exit;

  AddUnion := false;
  hostSqlStr := 'select * from ( ';

  if AD_Product_SelectColums <> QuotedStr('') then
  begin

    if AtLeast_1_Wc_HandledWarp and (trim(WarpItemHandledStr) <> '') then
    begin
      AddUnion := true;
      hostSqlStr := hostSqlStr +
      'SELECT UNIQUEID, NAMEENTITYNAME, NAMENAME, FIELDNAME, DATATYPE, VALUESTRING, VALUEINT, VALUEBOOLEAN, VALUEDATE, VALUEDECIMAL, VALUELONG, VALUETIMESTAMP ' +
      ' FROM (' +
      ' SELECT distinct P.ABSUNIQUEID FROM SchedulesDownloadDemands SDD JOIN PRODUCTIONDEMAND PD ' +
      ' On PD.CompanyCode = SDD.CompanyCode And PD.CounterCode = SDD.CounterCode And PD.Code = SDD.Code ' +
      ' JOIN PRODUCT P ON P.COMPANYCODE = ' + QuotedStr(CompanyInUsed_P) + ' ' +
      ' AND P.ITEMTYPECODE = PD.ITEMTYPEAFICODE ' +
      ' AND P.SUBCODE01 = PD.SUBCODE01 ' +
      ' AND (P.SUBCODE02 = PD.SUBCODE02 OR P.SUBCODE02 = ' + QuotedStr(' ') + ') ' +
      ' AND (P.SUBCODE03 = PD.SUBCODE03 OR P.SUBCODE03 = ' + QuotedStr(' ') + ') ' +
      ' AND (P.SUBCODE04 = PD.SUBCODE04 OR P.SUBCODE04 = ' + QuotedStr(' ') + ') ' +
      ' AND (P.SUBCODE05 = PD.SUBCODE05 OR P.SUBCODE05 = ' + QuotedStr(' ') + ') ' +
      ' AND (P.SUBCODE06 = PD.SUBCODE06 OR P.SUBCODE06 = ' + QuotedStr(' ') + ') ' +
      ' AND (P.SUBCODE07 = PD.SUBCODE07 OR P.SUBCODE07 = ' + QuotedStr(' ') + ') ' +
      ' AND (P.SUBCODE08 = PD.SUBCODE08 OR P.SUBCODE08 = ' + QuotedStr(' ') + ') ' +
      ' AND (P.SUBCODE09 = PD.SUBCODE09 OR P.SUBCODE09 = ' + QuotedStr(' ') + ') ' +
      ' AND (P.SUBCODE10 = PD.SUBCODE10 OR P.SUBCODE10 = ' + QuotedStr(' ') + ') ' +
      ' WHERE SDD.COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ' +
      ' AND SDD.EnvironmentCode = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' ' +
      ' AND SDD.TemplateCode IN (' + HandledProductionDemandMqinSql + ') ' +
      ' union ' +
      ' select distinct P.ABSUNIQUEID from balance b ' +
      ' JOIN PRODUCT P ON P.COMPANYCODE = ' + QuotedStr(CompanyInUsed_P) + ' ' +
      ' AND P.ITEMTYPECODE = b.ITEMTYPECODE ' +
      ' AND P.SUBCODE01 = b.DECOSUBCODE01 ' +

      ' AND (P.SUBCODE02 = b.DECOSUBCODE02 OR P.SUBCODE02 = ' + QuotedStr(' ') + ') ' +
      ' AND (P.SUBCODE03 = b.DECOSUBCODE03 OR P.SUBCODE03 = ' + QuotedStr(' ') + ') ' +
      ' AND (P.SUBCODE04 = b.DECOSUBCODE04 OR P.SUBCODE04 = ' + QuotedStr(' ') + ') ' +
      ' AND (P.SUBCODE05 = b.DECOSUBCODE05 OR P.SUBCODE05 = ' + QuotedStr(' ') + ') ' +
      ' AND (P.SUBCODE06 = b.DECOSUBCODE06 OR P.SUBCODE06 = ' + QuotedStr(' ') + ') ' +
      ' AND (P.SUBCODE07 = b.DECOSUBCODE07 OR P.SUBCODE07 = ' + QuotedStr(' ') + ') ' +
      ' AND (P.SUBCODE08 = b.DECOSUBCODE08 OR P.SUBCODE08 = ' + QuotedStr(' ') + ') ' +
      ' AND (P.SUBCODE09 = b.DECOSUBCODE09 OR P.SUBCODE09 = ' + QuotedStr(' ') + ') ' +
      ' AND (P.SUBCODE10 = b.DECOSUBCODE10 OR P.SUBCODE10 = ' + QuotedStr(' ') + ') ' +
      ' where b.COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ' +
      ' and b.itemtypecode in (' + WarpItemHandledStr + ') ' +
      ' ) SS1 ' +
      ' JOIN ADSTORAGE ON NAMEENTITYNAME = ' + QuotedStr('Product') + ' ' +
      ' AND  NAMENAME IN (' + AD_Product_SelectColums + ')' + ' ' +
      ' AND ADSTORAGE.UNIQUEID = SS1.ABSUNIQUEID ' +
      ' WHERE FIELDNAME is not null ';

    end
    else
    begin
      AddUnion := true;
      hostSqlStr := hostSqlStr +
      'SELECT UNIQUEID, NAMEENTITYNAME, NAMENAME, FIELDNAME, DATATYPE, VALUESTRING, ' +
             'VALUEINT, VALUEBOOLEAN, VALUEDATE, VALUEDECIMAL, VALUELONG, VALUETIMESTAMP ' +
      'FROM ' +
        '(SELECT DISTINCT P.ABSUNIQUEID ' +
        'FROM ' +
          '(SELECT * FROM SchedulesDownloadDemands ' +
          'WHERE COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ' +
          'AND   EnvironmentCode = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' ' +
          'AND   TemplateCode IN (' + HandledProductionDemandMqinSql + ')) SDD ' +
        'JOIN PRODUCTIONDEMAND PD ' +
        'On PD.CompanyCode = SDD.CompanyCode And PD.CounterCode = SDD.CounterCode And PD.Code = SDD.Code ' +
       // 'JOIN ITEMTYPE IT ON IT.COMPANYCODE = ' + QuotedStr(CompanyInUsed_IT) + ' AND IT.CODE = PD.ITEMTYPEAFICODE ' +
        'JOIN PRODUCT P ' +
        'ON   P.COMPANYCODE = ' + QuotedStr(CompanyInUsed_P) + ' ' +
        'AND  P.ITEMTYPECODE = PD.ITEMTYPEAFICODE  ' +
        'AND  P.SUBCODE01 = PD.SUBCODE01 ' +
        'AND (P.SUBCODE02 = PD.SUBCODE02 OR P.SUBCODE02 = ' + QuotedStr(' ') + ') ' +
        'AND (P.SUBCODE03 = PD.SUBCODE03 OR P.SUBCODE03 = ' + QuotedStr(' ') + ') ' +
        'AND (P.SUBCODE04 = PD.SUBCODE04 OR P.SUBCODE04 = ' + QuotedStr(' ') + ') ' +
        'AND (P.SUBCODE05 = PD.SUBCODE05 OR P.SUBCODE05 = ' + QuotedStr(' ') + ') ' +
        'AND (P.SUBCODE06 = PD.SUBCODE06 OR P.SUBCODE06 = ' + QuotedStr(' ') + ') ' +
        'AND (P.SUBCODE07 = PD.SUBCODE07 OR P.SUBCODE07 = ' + QuotedStr(' ') + ') ' +
        'AND (P.SUBCODE08 = PD.SUBCODE08 OR P.SUBCODE08 = ' + QuotedStr(' ') + ') ' +
        'AND (P.SUBCODE09 = PD.SUBCODE09 OR P.SUBCODE09 = ' + QuotedStr(' ') + ') ' +
        'AND (P.SUBCODE10 = PD.SUBCODE10 OR P.SUBCODE10 = ' + QuotedStr(' ') + ')) SS1 ' +
       // 'AND  P.SUBCODE10 = PD.SUBCODE10 ) SS1 ' +
      'JOIN ADSTORAGE ' +
      'ON   NAMEENTITYNAME = ' + QuotedStr('Product') + ' ' +
      'AND  NAMENAME IN (' + AD_Product_SelectColums + ')' + ' ' +
      'AND  ADSTORAGE.UNIQUEID = SS1.ABSUNIQUEID ' +
      'WHERE FIELDNAME is not null ';
    end;
  end;

   if AD_FullItemKeyDecoder_SelectColums <> QuotedStr('') then
   begin

    if AtLeast_1_Wc_HandledWarp and (trim(WarpItemHandledStr) <> '') then
    begin
      if AddUnion then hostSqlStr := hostSqlStr + 'Union all ';
      AddUnion := true;
      hostSqlStr := hostSqlStr +
      ' SELECT UNIQUEID, NAMEENTITYNAME, NAMENAME, FIELDNAME, DATATYPE, VALUESTRING, VALUEINT, VALUEBOOLEAN, VALUEDATE, VALUEDECIMAL, VALUELONG, VALUETIMESTAMP ' +
      ' FROM ( ' +
      ' SELECT DISTINCT FIKD.ABSUNIQUEID ' +
      ' FROM SchedulesDownloadDemands SDD ' +
      ' JOIN PRODUCTIONDEMAND PD ' +
      ' On PD.CompanyCode = SDD.CompanyCode And PD.CounterCode = SDD.CounterCode And PD.Code = SDD.Code ' +
      ' JOIN FULLITEMKEYDECODER FIKD ' +
      ' ON FIKD.COMPANYCODE = ' + QuotedStr(CompanyInUsed_FIKD) + ' ' +
      ' AND FIKD.ITEMTYPECODE = PD.ITEMTYPEAFICODE ' +
      ' AND FIKD.SUBCODE01 = PD.SUBCODE01 ' +
      ' AND FIKD.SUBCODE02 = PD.SUBCODE02 ' +
      ' AND FIKD.SUBCODE03 = PD.SUBCODE03 ' +
      ' AND FIKD.SUBCODE04 = PD.SUBCODE04 ' +
      ' AND FIKD.SUBCODE05 = PD.SUBCODE05 ' +
      ' AND FIKD.SUBCODE06 = PD.SUBCODE06 ' +
      ' AND FIKD.SUBCODE07 = PD.SUBCODE07 ' +
      ' AND FIKD.SUBCODE08 = PD.SUBCODE08 ' +
      ' AND FIKD.SUBCODE09 = PD.SUBCODE09 ' +
      ' AND FIKD.SUBCODE10 = PD.SUBCODE10 ' +
      ' union ' +
      ' select distinct FIKD.ABSUNIQUEID ' +
      ' from balance b ' +
      ' JOIN FULLITEMKEYDECODER FIKD ' +
      ' ON  FIKD.COMPANYCODE = ' + QuotedStr(CompanyInUsed_FIKD) + ' ' +
      ' AND FIKD.ITEMTYPECODE = b.ITEMTYPECODE ' +
      ' AND FIKD.SUBCODE01 = b.DECOSUBCODE01 ' +
      ' AND FIKD.SUBCODE02 = b.DECOSUBCODE02 ' +
      ' AND FIKD.SUBCODE03 = b.DECOSUBCODE03 ' +
      ' AND FIKD.SUBCODE04 = b.DECOSUBCODE04 ' +
      ' AND FIKD.SUBCODE05 = b.DECOSUBCODE05 ' +
      ' AND FIKD.SUBCODE06 = b.DECOSUBCODE06 ' +
      ' AND FIKD.SUBCODE07 = b.DECOSUBCODE07 ' +
      ' AND FIKD.SUBCODE08 = b.DECOSUBCODE08 ' +
      ' AND FIKD.SUBCODE09 = b.DECOSUBCODE09 ' +
      ' AND FIKD.SUBCODE10 = b.DECOSUBCODE10 ' +
      ' where b.COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ' +
      ' and b.itemtypecode in (' + WarpItemHandledStr + ') ' +
      ' ) SS1 ' +
      ' JOIN ADSTORAGE ON NAMEENTITYNAME = ' + QuotedStr('FullItemKeyDecoder') + ' ' +
      ' AND  NAMENAME IN (' + AD_FullItemKeyDecoder_SelectColums + ')' + ' ' +
      ' AND ADSTORAGE.UNIQUEID = SS1.ABSUNIQUEID ' +
      ' WHERE FIELDNAME is not null ';
    end
    else
    begin
      if AddUnion then hostSqlStr := hostSqlStr + 'Union all ';
      AddUnion := true;
      hostSqlStr := hostSqlStr +
      'SELECT UNIQUEID, NAMEENTITYNAME, NAMENAME, FIELDNAME, DATATYPE, VALUESTRING, ' +
             'VALUEINT, VALUEBOOLEAN, VALUEDATE, VALUEDECIMAL, VALUELONG, VALUETIMESTAMP ' +
      'FROM ' +
        '(SELECT DISTINCT FIKD.ABSUNIQUEID ' +
        'FROM ' +
          '(SELECT * FROM SchedulesDownloadDemands ' +
          'WHERE COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ' +
          'AND   EnvironmentCode = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' ' +
          'AND   TemplateCode IN (' + HandledProductionDemandMqinSql + ')) SDD ' +
        'JOIN PRODUCTIONDEMAND PD ' +
        'On PD.CompanyCode = SDD.CompanyCode And PD.CounterCode = SDD.CounterCode And PD.Code = SDD.Code ' +
        'JOIN FULLITEMKEYDECODER FIKD ' +
        'ON   FIKD.COMPANYCODE = ' + QuotedStr(CompanyInUsed_FIKD) + ' ' +
        'AND  FIKD.ITEMTYPECODE = PD.ITEMTYPEAFICODE  ' +
        'AND  FIKD.SUBCODE01 = PD.SUBCODE01 ' +
        'AND  FIKD.SUBCODE02 = PD.SUBCODE02 ' +
        'AND  FIKD.SUBCODE03 = PD.SUBCODE03 ' +
        'AND  FIKD.SUBCODE04 = PD.SUBCODE04 ' +
        'AND  FIKD.SUBCODE05 = PD.SUBCODE05 ' +
        'AND  FIKD.SUBCODE06 = PD.SUBCODE06 ' +
        'AND  FIKD.SUBCODE07 = PD.SUBCODE07 ' +
        'AND  FIKD.SUBCODE08 = PD.SUBCODE08 ' +
        'AND  FIKD.SUBCODE09 = PD.SUBCODE09 ' +
        'AND  FIKD.SUBCODE10 = PD.SUBCODE10) SS1 ' +
      'JOIN ADSTORAGE ' +
      'ON   NAMEENTITYNAME = ' + QuotedStr('FullItemKeyDecoder') + ' ' +
      'AND  NAMENAME IN (' + AD_FullItemKeyDecoder_SelectColums + ')' + ' ' +
      'AND  ADSTORAGE.UNIQUEID = SS1.ABSUNIQUEID ' +
      'WHERE FIELDNAME is not null ';
    end;
  end;

   if AD_Recipe_SelectColums <> '' then
   begin
     if AddUnion then hostSqlStr := hostSqlStr + 'Union all ';
     AddUnion := true;
     hostSqlStr := hostSqlStr +
    'SELECT UNIQUEID, NAMEENTITYNAME, NAMENAME, FIELDNAME, DATATYPE, VALUESTRING, ' +
           'VALUEINT, VALUEBOOLEAN, VALUEDATE, VALUEDECIMAL,VALUELONG, VALUETIMESTAMP ' +
    'FROM ' +
      '(SELECT DISTINCT R.ABSUNIQUEID ' +
      'FROM ' +
        '(SELECT * FROM SchedulesDownloadDemands ' +
        'WHERE COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ' +
        'AND   EnvironmentCode = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' ' +
        'AND   TemplateCode IN (' + HandledProductionDemandMqinSql + ')) SDD ' +
      'JOIN PRODUCTIONRESERVATION PRSV ' +
      'ON PRSV.CompanyCode = SDD.CompanyCode AND PRSV.OrderCounterCode = SDD.CounterCode ' +
      'AND PRSV.OrderCode = SDD.Code AND PRSV.ITEMNATURE = ' + QuotedStr('9') + ' ' +
      'JOIN RECIPE R ' +
      'ON   R.COMPANYCODE = ' + QuotedStr(CompanyInUsed_Recipe) + ' ' +
      'AND  R.ITEMTYPECODE = PRSV.ITEMTYPEAFICODE ' +
      'AND  R.SUBCODE01 = PRSV.SUBCODE01 AND R.SUBCODE02 = PRSV.SUBCODE02 ' +
      'AND  R.SUBCODE03 = PRSV.SUBCODE03 AND R.SUBCODE04 = PRSV.SUBCODE04 ' +
      'AND  R.SUBCODE05 = PRSV.SUBCODE05 AND R.SUBCODE06 = PRSV.SUBCODE06 ' +
      'AND  R.SUBCODE07 = PRSV.SUBCODE07 AND R.SUBCODE08 = PRSV.SUBCODE08 ' +
      'AND  R.SUBCODE09 = PRSV.SUBCODE09 AND R.SUBCODE10 = PRSV.SUBCODE10 ' +
      'AND  R.SUFFIXCODE = PRSV.SUFFIXCODE) SS1 ' +
    'JOIN ADSTORAGE ' +
    'ON   NAMEENTITYNAME = ' + QuotedStr('Recipe') + ' ' +
    'AND  NAMENAME IN (' + AD_Recipe_SelectColums + ')' + ' ' +
    'AND  ADSTORAGE.UNIQUEID = SS1.ABSUNIQUEID ' +
    'WHERE FIELDNAME is not null ';
   end;

   if AD_Design_SelectColums <> '' then
   begin
     if AddUnion then hostSqlStr := hostSqlStr + 'Union all ';
     AddUnion := true;
     hostSqlStr := hostSqlStr +
    'SELECT UNIQUEID, NAMEENTITYNAME, NAMENAME, FIELDNAME, DATATYPE, VALUESTRING, ' +
           'VALUEINT, VALUEBOOLEAN, VALUEDATE, VALUEDECIMAL, VALUELONG, VALUETIMESTAMP ' +
    'FROM ' +
      '(SELECT DISTINCT D.ABSUNIQUEID ' +
      'FROM ' +
        '(SELECT * FROM SchedulesDownloadDemands ' +
        'WHERE COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ' +
        'AND   EnvironmentCode = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' ' +
        'AND   TemplateCode IN (' + HandledProductionDemandMqinSql + ')) SDD ' +
      'JOIN PRODUCTIONRESERVATION PRSV ' +
      'ON PRSV.CompanyCode = SDD.CompanyCode AND PRSV.OrderCounterCode = SDD.CounterCode ' +
      'AND PRSV.OrderCode = SDD.Code AND PRSV.ITEMNATURE = ' + QuotedStr('A') + ' ' +
      'JOIN DESIGN D ' +
      'ON   D.COMPANYCODE = ' + QuotedStr(CompanyInUsed_Design) + ' ' +
      'AND  D.ITEMTYPECODE = PRSV.ITEMTYPEAFICODE ' +
      'AND  D.SUBCODE01 = PRSV.SUBCODE01 AND D.SUBCODE02 = PRSV.SUBCODE02 ' +
      'AND  D.SUBCODE03 = PRSV.SUBCODE03 AND D.SUBCODE04 = PRSV.SUBCODE04 ' +
      'AND  D.SUBCODE05 = PRSV.SUBCODE05 AND D.SUBCODE06 = PRSV.SUBCODE06 ' +
      'AND  D.SUBCODE07 = PRSV.SUBCODE07 AND D.SUBCODE08 = PRSV.SUBCODE08 ' +
      'AND  D.SUBCODE09 = PRSV.SUBCODE09 AND D.SUBCODE10 = PRSV.SUBCODE10 ' +
      'AND  D.SUFFIXCODE = PRSV.SUFFIXCODE) SS1 ' +
    'JOIN ADSTORAGE ' +
    'ON   NAMEENTITYNAME = ' + QuotedStr('Design') + ' ' +
    'AND  NAMENAME IN (' + AD_Design_SelectColums + ')' + ' ' +
    'AND  ADSTORAGE.UNIQUEID = SS1.ABSUNIQUEID ' +
    'WHERE FIELDNAME is not null ';
   end;

   if AD_SalesOrder_SelectColums <> '' then
   begin
     if AddUnion then hostSqlStr := hostSqlStr + 'Union all ';
     AddUnion := true;
     hostSqlStr := hostSqlStr +
    'SELECT UNIQUEID, NAMEENTITYNAME, NAMENAME, FIELDNAME, DATATYPE, VALUESTRING, ' +
           'VALUEINT, VALUEBOOLEAN, VALUEDATE, VALUEDECIMAL, VALUELONG, VALUETIMESTAMP ' +
    'FROM ' +
      '(SELECT DISTINCT SO.ABSUNIQUEID ' +
       'FROM ' +
       'SCHEDULESDOWNLOADDEMANDS SDD ' +
       'JOIN PRODUCTIONDEMAND PD ' +
       'ON  PD.COMPANYCODE = SDD.COMPANYCODE AND PD.COUNTERCODE = SDD.COUNTERCODE AND PD.CODE = SDD.CODE ' +
       'JOIN SALESORDER SO ' +
       'ON  SO.COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ' +
       'AND SO.COUNTERCODE = PD.ORIGDLVSALORDLINESALORDCNTCOD ' +
       'AND SO.CODE = PD.ORIGDLVSALORDLINESALORDERCODE ' +
       'WHERE ' +
       'SDD.COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' AND ' +
       'SDD.ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' AND ' +
       'SDD.TEMPLATECODE IN (' + HandledProductionDemandMqinSql + ') ' +
       'UNION ' +
       'SELECT DISTINCT SO.ABSUNIQUEID ' +
       'FROM ' +
       'SCHEDULESDOWNLOADDEMANDS SDD ' +
       'JOIN PRODUCTIONDEMAND PD ' +
       'ON  PD.COMPANYCODE = SDD.COMPANYCODE AND PD.COUNTERCODE = SDD.COUNTERCODE AND PD.CODE = SDD.CODE ' +
       'JOIN SALESORDERDELIVERY SOD ' +
       'ON  SOD.SALORDLINESALORDERCOMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ' +
       'AND SOD.PROJECTCODE = PD.PROJECTCODE ' +
       'JOIN SALESORDER SO ' +
       'ON  SO.COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ' +
       'AND SO.COUNTERCODE = SOD.SALORDLINESALORDERCOUNTERCODE ' +
       'AND SO.CODE = SOD.SALESORDERLINESALESORDERCODE ' +
       'WHERE ' +
       'SDD.COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' AND ' +
       'SDD.ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' AND ' +
       'SDD.TEMPLATECODE IN (' + HandledProductionDemandMqinSql + ')) SS1 ' +
    'JOIN ADSTORAGE ' +
    'ON   NAMEENTITYNAME = ' + QuotedStr('SalesOrder') + ' ' +
    'AND  NAMENAME IN (' + AD_SalesOrder_SelectColums + ')' + ' ' +
    'AND  ADSTORAGE.UNIQUEID = SS1.ABSUNIQUEID ' +
    'WHERE FIELDNAME is not null ';
   end;

   if AD_SalesOrderLine_SelectColums <> '' then
   begin
     if AddUnion then hostSqlStr := hostSqlStr + 'Union all ';
     AddUnion := true;
     hostSqlStr := hostSqlStr +
    'SELECT UNIQUEID, NAMEENTITYNAME, NAMENAME, FIELDNAME, DATATYPE, VALUESTRING, ' +
           'VALUEINT, VALUEBOOLEAN, VALUEDATE, VALUEDECIMAL, VALUELONG, VALUETIMESTAMP ' +
    'FROM ' +
      '(SELECT DISTINCT SOL.ABSUNIQUEID ' +
      'FROM ' +
      'SCHEDULESDOWNLOADDEMANDS SDD ' +
      'JOIN PRODUCTIONDEMAND PD ' +
      'ON  PD.COMPANYCODE = SDD.COMPANYCODE AND PD.COUNTERCODE = SDD.COUNTERCODE AND PD.CODE = SDD.CODE ' +
      'JOIN SALESORDERLINE SOL ' +
      'ON  SOL.SALESORDERCOMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ' +
      'AND SOL.SALESORDERCOUNTERCODE = PD.ORIGDLVSALORDLINESALORDCNTCOD ' +
      'AND SOL.SALESORDERCODE = PD.ORIGDLVSALORDLINESALORDERCODE ' +
      'AND SOL.ORDERLINE = PD.ORIGDLVSALORDERLINEORDERLINE ' +
      'AND SOL.ORDERSUBLINE = PD.ORIGDLVSALORDLINEORDERSUBLINE ' +
      'AND SOL.COMPONENTORDERLINE = PD.ORIGDLVSALORDLINECMPORDERLINE ' +
      'WHERE ' +
      'SDD.COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' AND ' +
      'SDD.ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' AND ' +
      'SDD.TEMPLATECODE IN (' + HandledProductionDemandMqinSql + ') ' +
      'UNION ' +
      'SELECT DISTINCT SOL.ABSUNIQUEID ' +
      'FROM ' +
      'SCHEDULESDOWNLOADDEMANDS SDD ' +
      'JOIN PRODUCTIONDEMAND PD ' +
      'ON  PD.COMPANYCODE = SDD.COMPANYCODE AND PD.COUNTERCODE = SDD.COUNTERCODE AND PD.CODE = SDD.CODE ' +
      'JOIN SALESORDERDELIVERY SOD ' +
      'ON  SOD.SALORDLINESALORDERCOMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ' +
      'AND SOD.PROJECTCODE = PD.PROJECTCODE ' +
      'JOIN SALESORDERLINE SOL ' +
      'ON  SOL.SALESORDERCOMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ' +
      'AND SOL.SALESORDERCOUNTERCODE = SOD.SALORDLINESALORDERCOUNTERCODE ' +
      'AND SOL.SALESORDERCODE = SOD.SALESORDERLINESALESORDERCODE ' +
      'AND SOL.ORDERLINE = SOD.SALESORDERLINEORDERLINE ' +
      'AND SOL.ORDERSUBLINE = SOD.SALESORDERLINEORDERSUBLINE ' +
      'AND SOL.COMPONENTORDERLINE = SOD.SALORDLINECOMPONENTORDERLINE ' +
      'WHERE ' +
      'SDD.COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' AND ' +
      'SDD.ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' AND ' +
      'SDD.TEMPLATECODE IN (' + HandledProductionDemandMqinSql + ')) SS1 ' +
    'JOIN ADSTORAGE ' +
    'ON   NAMEENTITYNAME = ' + QuotedStr('SalesOrderLine') + ' ' +
    'AND  NAMENAME IN (' + AD_SalesOrderLine_SelectColums + ')' + ' ' +
    'AND  ADSTORAGE.UNIQUEID = SS1.ABSUNIQUEID ' +
    'WHERE FIELDNAME is not null ';
   end;

   if AD_SalesOrderDelivery_SelectColums <> '' then
   begin
     if AddUnion then hostSqlStr := hostSqlStr + 'Union all ';
     AddUnion := true;
     hostSqlStr := hostSqlStr +
    'SELECT UNIQUEID, NAMEENTITYNAME, NAMENAME, FIELDNAME, DATATYPE, VALUESTRING, ' +
           'VALUEINT, VALUEBOOLEAN, VALUEDATE, VALUEDECIMAL, VALUELONG, VALUETIMESTAMP ' +
    'FROM ' +
      '(SELECT DISTINCT SOD.ABSUNIQUEID ' +
      'FROM ' +
      'SCHEDULESDOWNLOADDEMANDS SDD ' +
      'JOIN PRODUCTIONDEMAND PD ' +
      'ON  PD.COMPANYCODE = SDD.COMPANYCODE AND PD.COUNTERCODE = SDD.COUNTERCODE AND PD.CODE = SDD.CODE ' +
      'JOIN SALESORDERDELIVERY SOD ' +
      'ON  SOD.SALORDLINESALORDERCOMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ' +
      'AND SOD.SALORDLINESALORDERCOUNTERCODE = PD.ORIGDLVSALORDLINESALORDCNTCOD ' +
      'AND SOD.SALESORDERLINESALESORDERCODE = PD.ORIGDLVSALORDLINESALORDERCODE ' +
      'AND SOD.SALESORDERLINEORDERLINE = PD.ORIGDLVSALORDERLINEORDERLINE ' +
      'AND SOD.SALESORDERLINEORDERSUBLINE = PD.ORIGDLVSALORDLINEORDERSUBLINE ' +
      'AND SOD.SALORDLINECOMPONENTORDERLINE = PD.ORIGDLVSALORDLINECMPORDERLINE ' +
      'AND SOD.DELIVERYLINE = PD.ORIGDELIVERYDELIVERYLINE ' +
      'WHERE ' +
      'SDD.COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' AND ' +
      'SDD.ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' AND ' +
      'SDD.TEMPLATECODE IN (' + HandledProductionDemandMqinSql + ') ' +
      'UNION ' +
      'SELECT DISTINCT SOD.ABSUNIQUEID ' +
      'FROM ' +
      'SCHEDULESDOWNLOADDEMANDS SDD ' +
      'JOIN PRODUCTIONDEMAND PD ' +
      'ON  PD.COMPANYCODE = SDD.COMPANYCODE AND PD.COUNTERCODE = SDD.COUNTERCODE AND PD.CODE = SDD.CODE ' +
      'JOIN SALESORDERDELIVERY SOD ' +
      'ON  SOD.SALORDLINESALORDERCOMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ' +
      'AND SOD.PROJECTCODE = PD.PROJECTCODE ' +
      'WHERE ' +
      'SDD.COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' AND ' +
      'SDD.ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' AND ' +
      'SDD.TEMPLATECODE IN (' + HandledProductionDemandMqinSql + ')) SS1 ' +
    'JOIN ADSTORAGE ' +
    'ON   NAMEENTITYNAME = ' + QuotedStr('SalesOrderDelivery') + ' ' +
    'AND  NAMENAME IN (' + AD_SalesOrderDelivery_SelectColums + ')' + ' ' +
    'AND  ADSTORAGE.UNIQUEID = SS1.ABSUNIQUEID ' +
    'WHERE FIELDNAME is not null ';
   end;

   if AD_Project_SelectColums <> '' then
   begin
     if AddUnion then hostSqlStr := hostSqlStr + 'Union all ';
     AddUnion := true;
     hostSqlStr := hostSqlStr +
    'SELECT UNIQUEID, NAMEENTITYNAME, NAMENAME, FIELDNAME, DATATYPE, VALUESTRING, ' +
           'VALUEINT, VALUEBOOLEAN, VALUEDATE, VALUEDECIMAL, VALUELONG, VALUETIMESTAMP ' +
    'FROM ' +
      '(SELECT DISTINCT P.ABSUNIQUEID ' +
      'FROM ' +
        '(SELECT * FROM SchedulesDownloadDemands ' +
        'WHERE COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ' +
        'AND   EnvironmentCode = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' ' +
        'AND   TemplateCode IN (' + HandledProductionDemandMqinSql + ')) SDD ' +
      'JOIN PRODUCTIONDEMAND PD ' +
      'ON  PD.CompanyCode = SDD.CompanyCode AND PD.CounterCode = SDD.CounterCode AND PD.Code = SDD.Code ' +
      'JOIN PROJECT P ' +
      'ON  P.COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ' +
      'AND P.CODE = PD.PROJECTCODE ) SS1 ' +
    'JOIN ADSTORAGE ' +
    'ON   NAMEENTITYNAME = ' + QuotedStr('Project') + ' ' +
    'AND  NAMENAME IN (' + AD_Project_SelectColums + ')' + ' ' +
    'AND  ADSTORAGE.UNIQUEID = SS1.ABSUNIQUEID ' +
    'WHERE FIELDNAME is not null ';
   end;

   if AD_ProductionDemand_SelectColums <> QuotedStr('') then
   begin
     if AddUnion then hostSqlStr := hostSqlStr + 'Union all ';
     AddUnion := true;
     hostSqlStr := hostSqlStr +
     'SELECT UNIQUEID, NAMEENTITYNAME, NAMENAME, FIELDNAME, DATATYPE, VALUESTRING, ' +
           'VALUEINT, VALUEBOOLEAN, VALUEDATE, VALUEDECIMAL, VALUELONG, VALUETIMESTAMP ' +
    'FROM ' +
      '(SELECT * FROM SchedulesDownloadDemands ' +
      'WHERE COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ' +
      'AND   EnvironmentCode = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' ' +
      'AND   TemplateCode IN (' + HandledProductionDemandMqinSql + ')) SDD ' +
    'JOIN PRODUCTIONDEMAND PD ' +
    'On PD.CompanyCode = SDD.CompanyCode And PD.CounterCode = SDD.CounterCode And PD.Code = SDD.Code ' +
    'JOIN ADSTORAGE ' +
    'ON   NAMEENTITYNAME = ' + QuotedStr('ProductionDemand') + ' ' +
    'AND  NAMENAME IN (' + AD_ProductionDemand_SelectColums + ')' + ' ' +
    'AND  ADSTORAGE.UNIQUEID = PD.ABSUNIQUEID ' +
    'WHERE FIELDNAME is not null ';
   end;

   if AD_ProductionDemandStep_SelectColums <> QuotedStr('') then
   begin
     if AddUnion then hostSqlStr := hostSqlStr + 'Union all ';
     AddUnion := true;
     hostSqlStr := hostSqlStr +
    'SELECT UNIQUEID, NAMEENTITYNAME, NAMENAME, FIELDNAME, DATATYPE, VALUESTRING, ' +
           'VALUEINT, VALUEBOOLEAN, VALUEDATE, VALUEDECIMAL, VALUELONG, VALUETIMESTAMP ' +
    'FROM ' +
      '(SELECT * FROM SchedulesDownloadDemands ' +
      'WHERE COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ' +
      'AND   EnvironmentCode = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' ' +
      'AND   TemplateCode IN (' + HandledProductionDemandMqinSql + ')) SDD ' +
    'JOIN PRODUCTIONDEMANDSTEP PDS ' +
    'On PDS.PRODUCTIONDEMANDCOMPANYCODE = SDD.CompanyCode And PDS.PRODUCTIONDEMANDCOUNTERCODE = SDD.CounterCode And PDS.PRODUCTIONDEMANDCODE = SDD.Code ' +
    'JOIN ADSTORAGE ' +
    'ON   NAMEENTITYNAME = ' + QuotedStr('ProductionDemandStep') + ' ' +
    'AND  NAMENAME IN (' + AD_ProductionDemandStep_SelectColums + ')' + ' ' +
    'AND  ADSTORAGE.UNIQUEID = PDS.ABSUNIQUEID ' +
    'WHERE FIELDNAME is not null';
   end;

   if (UserGenericGroup_AD <> '') then
   begin

      for i := 0 to UserGenericGroupTypeCodeStrList.Count - 1 do
      begin
        if trim(HandledUserGenericGroupTypesStr) <> '' then
          HandledUserGenericGroupTypesStr := HandledUserGenericGroupTypesStr + ', ';
        HandledUserGenericGroupTypesStr := HandledUserGenericGroupTypesStr + QuotedStr(UserGenericGroupTypeCodeStrList.Strings[I]);
      end;

      if HandledUserGenericGroupTypesStr = '' then
        HandledUserGenericGroupTypesStr := QuotedStr('&&&');

      if AddUnion then hostSqlStr := hostSqlStr + ' Union all ';
      AddUnion := true;
      hostSqlStr := hostSqlStr +
       ' SELECT UNIQUEID, NAMEENTITYNAME, NAMENAME, FIELDNAME, DATATYPE, VALUESTRING, ' +
              'VALUEINT, VALUEBOOLEAN, VALUEDATE, VALUEDECIMAL, VALUELONG, VALUETIMESTAMP ' +
       'FROM ' +
       'USERGENERICGROUP UGG JOIN ADSTORAGE ON NAMEENTITYNAME = ' + QuotedStr('UserGenericGroup') +
       ' AND NAMENAME IN (' + UserGenericGroup_AD + ')' + ' ' +
       ' AND ADSTORAGE.UNIQUEID = UGG.ABSUNIQUEID AND FIELDNAME is not null ' +
       ' WHERE ugg.USERGENGROUPTYPECOMPANYCODE = ' + QuotedStr(CompanyInUsed_UGG) + ' ' +
       ' and ugg.USERGENERICGROUPTYPECODE IN (' + HandledUserGenericGroupTypesStr + ')'

   end;

   if (Color_AD <> '') then
   begin

      for i := 0 to ColorTypeCodeStrList.Count - 1 do
      begin
        if trim(HandledColorTypesStr) <> '' then
          HandledColorTypesStr := HandledColorTypesStr + ', ';
        HandledColorTypesStr := HandledColorTypesStr + QuotedStr(ColorTypeCodeStrList.Strings[I]);
      end;

      if HandledColorTypesStr = '' then
        HandledColorTypesStr := QuotedStr('&&&');

      if AddUnion then hostSqlStr := hostSqlStr + ' Union all ';
      AddUnion := true;
      hostSqlStr := hostSqlStr +
       ' SELECT UNIQUEID, NAMEENTITYNAME, NAMENAME, FIELDNAME, DATATYPE, VALUESTRING, ' +
              'VALUEINT, VALUEBOOLEAN, VALUEDATE, VALUEDECIMAL, VALUELONG, VALUETIMESTAMP ' +
       'FROM ' +
       'COLOR CLR JOIN ADSTORAGE ON NAMEENTITYNAME = ' + QuotedStr('Color') +
       ' AND NAMENAME IN (' + Color_AD + ')' + ' ' +
       ' AND ADSTORAGE.UNIQUEID = CLR.ABSUNIQUEID AND FIELDNAME is not null ' +
       ' WHERE CLR.COLORFOLDERCOMPANYCODE = ' + QuotedStr(CompanyInUsed_Color) + ' ' +
       ' and CLR.COLORFOLDERCODE IN (' + HandledColorTypesStr + ')'

   end;

  hostSqlStr := hostSqlStr + ' ) AA ORDER BY UNIQUEID, NAMEENTITYNAME, NAMENAME, FIELDNAME';

  try
    SqlLog := TStringList.Create;
    SqlLog.Add(hostSqlStr);
    SqlLog.SaveToFile(LocAppGlobals.AppDir + '\SqlADStorage.txt');
    SqlLog.free;
  except
  end;

  HostQry.SQL.Text := hostSqlStr;
  HostQry.Open;

  NEWADDITIONALDATA_HEADER := nil;
  lastReadUniqueId := '';
  var UNIQUEID_FIELD := HostQry.FieldByName('UNIQUEID');
  while (not HostQry.Eof) do
  begin

    if (lastReadUniqueId <> Trim(UNIQUEID_FIELD.AsString) ) then
    begin
      if lastReadUniqueId <> '' then
      begin
        NEWADDITIONALDATA_HEADER.productADList.Sort(Sort_ADDITIONALDATA_DETAIL);
        NEWADDITIONALDATA_HEADER.fullItemKeyDecoderADList.Sort(Sort_ADDITIONALDATA_DETAIL);
        NEWADDITIONALDATA_HEADER.productionDemandADList.Sort(Sort_ADDITIONALDATA_DETAIL);
        NEWADDITIONALDATA_HEADER.productionDemandStepADList.Sort(Sort_ADDITIONALDATA_DETAIL);
        NEWADDITIONALDATA_HEADER.RecipeADList.Sort(Sort_ADDITIONALDATA_DETAIL);
        NEWADDITIONALDATA_HEADER.DesignADList.Sort(Sort_ADDITIONALDATA_DETAIL);
        NEWADDITIONALDATA_HEADER.SalesOrderADList.Sort(Sort_ADDITIONALDATA_DETAIL);
        NEWADDITIONALDATA_HEADER.SalesOrderLineADList.Sort(Sort_ADDITIONALDATA_DETAIL);
        NEWADDITIONALDATA_HEADER.SalesOrderDeliveryADList.Sort(Sort_ADDITIONALDATA_DETAIL);
        NEWADDITIONALDATA_HEADER.ProjectADList.Sort(Sort_ADDITIONALDATA_DETAIL);
        NEWADDITIONALDATA_HEADER.UserGenericGroupADList.Sort(Sort_ADDITIONALDATA_DETAIL);
        NEWADDITIONALDATA_HEADER.ColorADList.Sort(Sort_ADDITIONALDATA_DETAIL);
      end;

      lastReadUniqueId := Trim(UNIQUEID_FIELD.AsString);

      New(NEWADDITIONALDATA_HEADER);

      NEWADDITIONALDATA_HEADER.ABSUNIQUEID := lastReadUniqueId;
      NEWADDITIONALDATA_HEADER.ABSUNIQUEIDINT := StrToInt64Def(lastReadUniqueId, 0);

      NEWADDITIONALDATA_HEADER.productADList              := TList.Create;
      NEWADDITIONALDATA_HEADER.fullItemKeyDecoderADList   := TList.Create;
      NEWADDITIONALDATA_HEADER.productionDemandADList     := TList.Create;
      NEWADDITIONALDATA_HEADER.productionDemandStepADList := TList.Create;
      NEWADDITIONALDATA_HEADER.RecipeADList               := TList.Create;
      NEWADDITIONALDATA_HEADER.DesignADList               := TList.Create;
      NEWADDITIONALDATA_HEADER.SalesOrderADList           := TList.Create;
      NEWADDITIONALDATA_HEADER.SalesOrderLineADList       := TList.Create;
      NEWADDITIONALDATA_HEADER.SalesOrderDeliveryADList   := TList.Create;
      NEWADDITIONALDATA_HEADER.ProjectADList              := TList.Create;
      NEWADDITIONALDATA_HEADER.UserGenericGroupADList     := TList.Create;
      NEWADDITIONALDATA_HEADER.ColorADList                := TList.Create;

      additionalDataList.Add(NEWADDITIONALDATA_HEADER);
    end;

    New(NEWADDITIONALDATA_DETAIL);

    var FIELDNAME_FIELD := HostQry.FieldByName('FIELDNAME');
    var DATATYPE_FIELD := HostQry.FieldByName('DATATYPE');
    var VALUESTRING_FIELD := HostQry.FieldByName('VALUESTRING');
    var VALUEINT_FIELD := HostQry.FieldByName('VALUEINT');
    var VALUEBOOLEAN_FIELD := HostQry.FieldByName('VALUEBOOLEAN');
    var VALUEDATE_FIELD := HostQry.FieldByName('VALUEDATE');
    var VALUEDECIMAL_FIELD := HostQry.FieldByName('VALUEDECIMAL');
    var VALUELONG_FIELD := HostQry.FieldByName('VALUELONG');
    var VALUETIMESTAMP_FIELD := HostQry.FieldByName('VALUETIMESTAMP');
    var NAMEENTITYNAME_FIELD := HostQry.FieldByName('NAMEENTITYNAME');

    NEWADDITIONALDATA_DETAIL.FIELDNAME := Trim(FIELDNAME_FIELD.AsString);

    case DATATYPE_FIELD.AsInteger of
      0: NEWADDITIONALDATA_DETAIL.VALUE := VALUESTRING_FIELD.AsString;
      1: NEWADDITIONALDATA_DETAIL.VALUE := VALUEINT_FIELD.AsString;
      2: NEWADDITIONALDATA_DETAIL.VALUE := VALUEBOOLEAN_FIELD.AsString;
      3: NEWADDITIONALDATA_DETAIL.VALUE := VALUEDATE_FIELD.AsString;
      4: NEWADDITIONALDATA_DETAIL.VALUE := VALUEDECIMAL_FIELD.AsString;
      5: NEWADDITIONALDATA_DETAIL.VALUE := VALUELONG_FIELD.AsString;
      7: NEWADDITIONALDATA_DETAIL.VALUE := VALUETIMESTAMP_FIELD.AsString;
      8: NEWADDITIONALDATA_DETAIL.VALUE := VALUESTRING_FIELD.AsString;
    end;
    NEWADDITIONALDATA_DETAIL.DataType := DATATYPE_FIELD.AsInteger;

    if ( Trim(NAMEENTITYNAME_FIELD.AsString) = 'Product' ) then
      NEWADDITIONALDATA_HEADER.productADList.Add(NEWADDITIONALDATA_DETAIL)
    else if ( Trim(NAMEENTITYNAME_FIELD.AsString) = 'FullItemKeyDecoder' ) then
      NEWADDITIONALDATA_HEADER.fullItemKeyDecoderADList.Add(NEWADDITIONALDATA_DETAIL)
    else if ( Trim(NAMEENTITYNAME_FIELD.AsString) = 'ProductionDemand' ) then
      NEWADDITIONALDATA_HEADER.productionDemandADList.Add(NEWADDITIONALDATA_DETAIL)
    else if ( Trim(NAMEENTITYNAME_FIELD.AsString) = 'Recipe' ) then
      NEWADDITIONALDATA_HEADER.RecipeADList.Add(NEWADDITIONALDATA_DETAIL)
    else if ( Trim(NAMEENTITYNAME_FIELD.AsString) = 'Design' ) then
      NEWADDITIONALDATA_HEADER.DesignADList.Add(NEWADDITIONALDATA_DETAIL)
    else if ( Trim(NAMEENTITYNAME_FIELD.AsString) = 'SalesOrder' ) then
      NEWADDITIONALDATA_HEADER.SalesOrderADList.Add(NEWADDITIONALDATA_DETAIL)
    else if ( Trim(NAMEENTITYNAME_FIELD.AsString) = 'SalesOrderLine' ) then
      NEWADDITIONALDATA_HEADER.SalesOrderLineADList.Add(NEWADDITIONALDATA_DETAIL)
    else if ( Trim(NAMEENTITYNAME_FIELD.AsString) = 'SalesOrderDelivery' ) then
      NEWADDITIONALDATA_HEADER.SalesOrderDeliveryADList.Add(NEWADDITIONALDATA_DETAIL)
    else if ( Trim(NAMEENTITYNAME_FIELD.AsString) = 'Project' ) then
      NEWADDITIONALDATA_HEADER.ProjectADList.Add(NEWADDITIONALDATA_DETAIL)
    else if ( Trim(NAMEENTITYNAME_FIELD.AsString) = 'ProductionDemandStep' ) then
      NEWADDITIONALDATA_HEADER.productionDemandStepADList.Add(NEWADDITIONALDATA_DETAIL)
    else if ( Trim(NAMEENTITYNAME_FIELD.AsString) = 'UserGenericGroup' ) then
      NEWADDITIONALDATA_HEADER.UserGenericGroupADList.Add(NEWADDITIONALDATA_DETAIL)
    else if ( Trim(NAMEENTITYNAME_FIELD.AsString) = 'Color' ) then
      NEWADDITIONALDATA_HEADER.ColorADList.Add(NEWADDITIONALDATA_DETAIL);

    HostQry.Next;
  end;

  if lastReadUniqueId <> '' then
  begin
    NEWADDITIONALDATA_HEADER.productADList.Sort(Sort_ADDITIONALDATA_DETAIL);
    NEWADDITIONALDATA_HEADER.fullItemKeyDecoderADList.Sort(Sort_ADDITIONALDATA_DETAIL);
    NEWADDITIONALDATA_HEADER.productionDemandADList.Sort(Sort_ADDITIONALDATA_DETAIL);
    NEWADDITIONALDATA_HEADER.productionDemandStepADList.Sort(Sort_ADDITIONALDATA_DETAIL);
    NEWADDITIONALDATA_HEADER.RecipeADList.Sort(Sort_ADDITIONALDATA_DETAIL);
    NEWADDITIONALDATA_HEADER.DesignADList.Sort(Sort_ADDITIONALDATA_DETAIL);
    NEWADDITIONALDATA_HEADER.SalesOrderADList.Sort(Sort_ADDITIONALDATA_DETAIL);
    NEWADDITIONALDATA_HEADER.SalesOrderLineADList.Sort(Sort_ADDITIONALDATA_DETAIL);
    NEWADDITIONALDATA_HEADER.SalesOrderDeliveryADList.Sort(Sort_ADDITIONALDATA_DETAIL);
    NEWADDITIONALDATA_HEADER.ProjectADList.Sort(Sort_ADDITIONALDATA_DETAIL);
    NEWADDITIONALDATA_HEADER.UserGenericGroupADList.Sort(Sort_ADDITIONALDATA_DETAIL);
    NEWADDITIONALDATA_HEADER.ColorADList.Sort(Sort_ADDITIONALDATA_DETAIL);
  end;

  DndArchiveArcName := GetDndArchiveLocalName;
  if DndArchiveArcName = TD_Interbase then
    tblArcName  := 'PROPERTY_RTV_VALUE'
  else
    tblArcName  := 'SCDA_' + 'PROPERTY_RTV_VALUE';
  srvSqlStr := 'SELECT DISTINCT TABLE_NAME, COLUMN_NAME, ITEMTYPE FROM ' + tblArcName + ' WHERE TABLE_NAME LIKE ' + QuotedStr('UserGenericGroup Subcode%') + AND_IDF_Condition('IDENTIFIER');
  srvQry.SQL.Text := srvSqlStr;
  srvQry.Active := true;
  COLUMN_NAME_FIELD := srvQry.FieldByName('COLUMN_NAME');
  ITEMTYPE_FIELD := srvQry.FieldByName('ITEMTYPE');
  TABLE_NAME_FIELD := srvQry.FieldByName('TABLE_NAME');
  UserGenericGroup_AD := '';
  while (not srvQry.Eof ) do
  begin
    columnName := Trim(COLUMN_NAME_FIELD.AsString);
    ItemType   := Trim(ITEMTYPE_FIELD.AsString);
    UserGenericGroupKeyNumber := strtoint(copy(TABLE_NAME_FIELD.AsString, 25, 2));
    GenericGroupCodeType := getUserGenericGroupType(ItemType, UserGenericGroupKeyNumber, UserGenericGroupTypeList);
    if (GenericGroupCodeType <> '') and (UserGenericGroupTypeCodeStrList.IndexOf(GenericGroupCodeType) = -1) then
      UserGenericGroupTypeCodeStrList.Add(GenericGroupCodeType);
     srvQry.Next;
  end;

  HandledUserGenericGroupTypesStr := '';
  for i := 0 to UserGenericGroupTypeCodeStrList.Count - 1 do
  begin
     if trim(HandledUserGenericGroupTypesStr) <> '' then
       HandledUserGenericGroupTypesStr := HandledUserGenericGroupTypesStr + ', ';
     HandledUserGenericGroupTypesStr := HandledUserGenericGroupTypesStr + QuotedStr(UserGenericGroupTypeCodeStrList.Strings[I]);
  end;
  srvQry.Active := false;
  srvQry.Free;

  UserGenericGroupTypeCodeStrList.Free;
  ColorTypeCodeStrList.Free;
  ColorTimeList.Free;
  HostQry.Close;
  HostQry.free;
end;

//----------------------------------------------------------------------------//

procedure fillPropertyStruct(ArcQry : TMqmQuery; propertyList: TList; handledWorkCentersList: Tlist);
var
  srvSqlStr: String;
  NEWPROP: PPROPS;
  NEWPROP_RTV_VALUE: PPROP_RTV_VALUES;
  WorkCenterStr, CategoryStr : TStringlist;
  TBL_RES, TBL_PROP, TBL_PROPERTY_RTV_VALUE, TBL_PROP_RES : String;
  I, J, K, L, WorkCenterIndex : Integer;
  lastProp: String;
  DndArchiveArcName : TDndArchiveName;
  WorkCenterCode, OperationAndWorkCenterCode : String;
  CUR_WORKCENTER : PWORKCENTERS;
  CUR_PROCESS: PPROCESSES;
begin
  DndArchiveArcName := GetDndArchiveLocalName;
  TBL_RES := 'RES';
  if DndArchiveArcName <> TD_Interbase then
    TBL_RES  := 'SCDA_' + 'RES';
  WorkCenterStr := TStringlist.Create;
  CategoryStr := TStringlist.Create;

  srvSqlStr := 'select distinct RS_WKCNTER, RS_RES_CATEGORY from ' + TBL_RES + WHERE_IDF_Condition('RS_IDENTIFIER');
  ArcQry.SQL.Text := srvSqlStr;
  ArcQry.Open;
  var fldPS1_RS_WKCNTER     := ArcQry.FieldByName('RS_WKCNTER');
  var fldPS1_RS_RES_CATEGORY := ArcQry.FieldByName('RS_RES_CATEGORY');
  while (not ArcQry.Eof) do
  begin
    if (Trim(fldPS1_RS_WKCNTER.AsString) <> '') and
       (Trim(fldPS1_RS_RES_CATEGORY.AsString) <> '') then
    begin
      WorkCenterStr.Add(Trim(fldPS1_RS_WKCNTER.AsString));
      CategoryStr.Add(Trim(fldPS1_RS_RES_CATEGORY.AsString));
    end;
    ArcQry.Next;
  end;
  ArcQry.close;

  TBL_PROP := 'PROP';
  if DndArchiveArcName <> TD_Interbase then
    TBL_PROP  := 'SCDA_' + 'PROP';

  TBL_PROPERTY_RTV_VALUE := 'PROPERTY_RTV_VALUE';
  if DndArchiveArcName <> TD_Interbase then
    TBL_PROPERTY_RTV_VALUE  := 'SCDA_' + 'PROPERTY_RTV_VALUE';

  srvSqlStr := 'SELECT PY_PROPERTY, PY_TYPE, PY_PROP_LEN, PY_NUM_OF_DEC, PY_PROP_IS_DATE, PY_MQMRELEVANCE, PY_MCMRELEVANCE, ' +
               'PY_RP_CONN_LEV_MAIN, PY_RP_ADD_WC_PROC, PY_PROP_VAL_TAKE_FOR_MERGE, PY_IS_PROP_BUILD_FROM_PROP, PY_DESIGNATEDPROPERTY, ' +
               'PY_PROP_VAL_BUILDED1, PY_PROP_VAL_BUILDED2, PY_PROP_VAL_BUILDED3, PY_PROP_VAL_BUILDED4, PY_PROP_VAL_BUILDED5, ' +
               'ITEMTYPE, TABLE_NAME, COLUMN_NAME, FROM_POSITION, LENGTH_FROM_POS, RELATED_COLUMN_NAME ' +
               'FROM ' +
                TBL_PROP + ' LEFT JOIN ' + TBL_PROPERTY_RTV_VALUE + ' ON IDENTIFIER = PY_IDENTIFIER and PROPERTY = PY_PROPERTY ' +
               'WHERE (PY_MQMRELEVANCE <> ' + QuotedStr('0') + ' or ' +
               'PY_MCMRELEVANCE <> ' + QuotedStr('0') + ')' +
                AND_IDF_Condition('PY_IDENTIFIER') +
               'ORDER BY PY_PROPERTY, ITEMTYPE';
  ArcQry.SQL.Text := srvSqlStr;
  ArcQry.Open;
  var fldPS2_PY_PROPERTY             := ArcQry.FieldByName('PY_PROPERTY');
  var fldPS2_PY_TYPE                 := ArcQry.FieldByName('PY_TYPE');
  var fldPS2_PY_PROP_LEN             := ArcQry.FieldByName('PY_PROP_LEN');
  var fldPS2_PY_NUM_OF_DEC           := ArcQry.FieldByName('PY_NUM_OF_DEC');
  var fldPS2_PY_PROP_IS_DATE         := ArcQry.FieldByName('PY_PROP_IS_DATE');
  var fldPS2_PY_RP_CONN_LEV_MAIN     := ArcQry.FieldByName('PY_RP_CONN_LEV_MAIN');
  var fldPS2_PY_RP_ADD_WC_PROC       := ArcQry.FieldByName('PY_RP_ADD_WC_PROC');
  var fldPS2_PY_DESIGNATEDPROPERTY   := ArcQry.FieldByName('PY_DESIGNATEDPROPERTY');
  var fldPS2_PY_IS_PROP_BUILD        := ArcQry.FieldByName('PY_IS_PROP_BUILD_FROM_PROP');
  var fldPS2_PY_BUILDED1             := ArcQry.FieldByName('PY_PROP_VAL_BUILDED1');
  var fldPS2_PY_BUILDED2             := ArcQry.FieldByName('PY_PROP_VAL_BUILDED2');
  var fldPS2_PY_BUILDED3             := ArcQry.FieldByName('PY_PROP_VAL_BUILDED3');
  var fldPS2_PY_BUILDED4             := ArcQry.FieldByName('PY_PROP_VAL_BUILDED4');
  var fldPS2_PY_BUILDED5             := ArcQry.FieldByName('PY_PROP_VAL_BUILDED5');
  var fldPS2_PY_PROP_VAL_TAKE        := ArcQry.FieldByName('PY_PROP_VAL_TAKE_FOR_MERGE');
  var fldPS2_PY_MQMRELEVANCE         := ArcQry.FieldByName('PY_MQMRELEVANCE');
  var fldPS2_PY_MCMRELEVANCE         := ArcQry.FieldByName('PY_MCMRELEVANCE');
  var fldPS2_ITEMTYPE                := ArcQry.FieldByName('ITEMTYPE');
  var fldPS2_TABLE_NAME              := ArcQry.FieldByName('TABLE_NAME');
  var fldPS2_COLUMN_NAME             := ArcQry.FieldByName('COLUMN_NAME');
  var fldPS2_RELATED_COLUMN_NAME     := ArcQry.FieldByName('RELATED_COLUMN_NAME');
  var fldPS2_FROM_POSITION           := ArcQry.FieldByName('FROM_POSITION');
  var fldPS2_LENGTH_FROM_POS         := ArcQry.FieldByName('LENGTH_FROM_POS');

  NEWPROP := nil;
  lastProp := '';

  // if one of them is not '0' this is the value i take
  // and if the prop is planned i put bool true

  while (not ArcQry.Eof) do
  begin
    if ( lastProp <> Trim(fldPS2_PY_PROPERTY.AsString) ) then
    begin
      if lastProp <> '' then
      begin
        NEWPROP.propRtvValueList.Sort(Sort_propRtvValueListByItemType);
      end;
      lastProp := Trim(fldPS2_PY_PROPERTY.AsString);

      New(NEWPROP);

      NEWPROP.PY_Planner_Prop := false;
      NEWPROP.PY_PROPERTY := lastProp;

      NEWPROP.PY_IS_Date_Prop := false;

      NEWPROP.PY_TYPE := Trim(fldPS2_PY_TYPE.AsString);
      NEWPROP.PY_PROP_LEN := fldPS2_PY_PROP_LEN.AsInteger;
      NEWPROP.PY_NUM_OF_DEC := fldPS2_PY_NUM_OF_DEC.AsInteger;

      if Trim(fldPS2_PY_PROP_IS_DATE.AsString) > '' then
      if fldPS2_PY_PROP_IS_DATE.AsInteger = 1 then
         NEWPROP.PY_IS_Date_Prop := true;

      NEWPROP.PY_RP_CONN_LEV_MAIN := Trim(fldPS2_PY_RP_CONN_LEV_MAIN.AsString);
      NEWPROP.PY_RP_ADD_WC_PROC := Trim(fldPS2_PY_RP_ADD_WC_PROC.AsString);
      NEWPROP.PY_DESIGNATEDPROPERTY := Trim(fldPS2_PY_DESIGNATEDPROPERTY.AsString);

      if ((NEWPROP.PY_DESIGNATEDPROPERTY = '3') or (NEWPROP.PY_DESIGNATEDPROPERTY = '6')) and (fldPS2_PY_IS_PROP_BUILD.AsString = '1') then
      begin
        NEWPROP.PY_BUILD_PROPCODE1 := Trim(fldPS2_PY_BUILDED1.AsString);
        NEWPROP.PY_BUILD_PROPCODE2 := Trim(fldPS2_PY_BUILDED2.AsString);
        NEWPROP.PY_BUILD_PROPCODE3 := Trim(fldPS2_PY_BUILDED3.AsString);
        NEWPROP.PY_BUILD_PROPCODE4 := Trim(fldPS2_PY_BUILDED4.AsString);
        NEWPROP.PY_BUILD_PROPCODE5 := Trim(fldPS2_PY_BUILDED5.AsString);
      end;

      NEWPROP.PY_PROP_VAL_TAKE_FOR_MERGE_DEMANDS := Trim(fldPS2_PY_PROP_VAL_TAKE.AsString);
      NEWPROP.PY_IS_PROP_BUILD_FROM_PROP := false;
      if Trim(fldPS2_PY_IS_PROP_BUILD.AsString) = '1' then
        NEWPROP.PY_IS_PROP_BUILD_FROM_PROP := true;
      if (Trim(fldPS2_PY_MQMRELEVANCE.AsString) = '3') or (Trim(fldPS2_PY_MCMRELEVANCE.AsString) = '3') then
        NEWPROP.PY_Planner_Prop := true;

      if (Trim(fldPS2_PY_MQMRELEVANCE.AsString) = '1') then
        NEWPROP.PY_MQM_Prop_Rtv_Value := true
      else
        NEWPROP.PY_MQM_Prop_Rtv_Value := false;
      if (Trim(fldPS2_PY_MCMRELEVANCE.AsString) = '1') then
        NEWPROP.PY_MCM_Prop_Rtv_Value := true
      else
        NEWPROP.PY_MCM_Prop_Rtv_Value := false;

      NEWPROP.propRtvValueList := TList.Create;
      NEWPROP.HasAtLeastOneConnectionToResource := false;
      NEWPROP.PropWorkCentersCode := TStringList.Create;
      NEWPROP.PropWorkCentersCode.Sorted := true;
      NEWPROP.PropWorkCentersCodePerOperation := TStringList.Create;
      NEWPROP.PropWorkCentersCodePerOperation.Sorted := true;

      propertyList.Add(NEWPROP);
    end;

    if (Trim(fldPS2_PY_DESIGNATEDPROPERTY.AsString) = '1') then
    begin
  	  New(NEWPROP_RTV_VALUE);
	    NEWPROP_RTV_VALUE.ITEMTYPE    := '';
	    NEWPROP_RTV_VALUE.TABLE_NAME  := 'PRODUCTIONDEMANDSTEP';
      NEWPROP_RTV_VALUE.COLUMN_NAME := 'PRODUCTIONORDERCODE';
      NEWPROP_RTV_VALUE.From_Position := 0;
      NEWPROP_RTV_VALUE.Length_From_Pos := 0;

  	  NEWPROP.propRtvValueList.Add(NEWPROP_RTV_VALUE);
    end
    else
    begin
      New(NEWPROP_RTV_VALUE);
  	  NEWPROP_RTV_VALUE.ITEMTYPE    := fldPS2_ITEMTYPE.AsString;
	    NEWPROP_RTV_VALUE.TABLE_NAME  := fldPS2_TABLE_NAME.AsString;
      NEWPROP_RTV_VALUE.COLUMN_NAME := fldPS2_COLUMN_NAME.AsString + Trim(fldPS2_RELATED_COLUMN_NAME.AsString);
      NEWPROP_RTV_VALUE.From_Position := fldPS2_FROM_POSITION.AsInteger;
      NEWPROP_RTV_VALUE.Length_From_Pos := fldPS2_LENGTH_FROM_POS.AsInteger;
    //  NEWPROP_RTV_VALUE.DATEFORMAT := ArcQry.FieldByName('DATEFORMAT').AsString;
	    NEWPROP.propRtvValueList.Add(NEWPROP_RTV_VALUE);
    end;

    ArcQry.Next;
  end;

  ArcQry.Close;

  if lastProp <> '' then
  begin
    NEWPROP.propRtvValueList.Sort(Sort_propRtvValueListByItemType);
  end;

  propertyList.Sort(Sort_PropListByCode);

//=====================================================================================================================================================

  TBL_PROP_RES := 'PROP_RES';
  if DndArchiveArcName <> TD_Interbase then
    TBL_PROP_RES := 'SCDA_' + 'PROP_RES';

  srvSqlStr := 'SELECT PY_PROPERTY, PY_TYPE, PY_PROP_LEN, PY_NUM_OF_DEC, PY_PROP_IS_DATE, PY_MQMRELEVANCE, PY_MCMRELEVANCE, ' +
               'PY_RP_CONN_LEV_MAIN, PY_RP_ADD_WC_PROC, PY_PROP_VAL_TAKE_FOR_MERGE, PY_IS_PROP_BUILD_FROM_PROP, PY_DESIGNATEDPROPERTY, ' +
               'PY_PROP_VAL_BUILDED1, PY_PROP_VAL_BUILDED2, PY_PROP_VAL_BUILDED3, PY_PROP_VAL_BUILDED4, PY_PROP_VAL_BUILDED5, ' +
               'RP_WKCNTER, RP_PROPERTY, RP_WC_PROCESS, RP_RES_CATEGORY, RP_RSC_CODE, RS_WKCNTER ' +
               'FROM ' +
                TBL_PROP +
               ' JOIN ' + TBL_PROP_RES + ' ON RP_IDENTIFIER = PY_IDENTIFIER and RP_PROPERTY = PY_PROPERTY ' +
               'LEFT JOIN ' + TBL_RES + ' ON RS_IDENTIFIER = RP_IDENTIFIER and RS_RSC_CODE = RP_RSC_CODE ' +
               'WHERE (PY_MQMRELEVANCE <> ' + QuotedStr('0') + ' or ' +
               'PY_MCMRELEVANCE <> ' + QuotedStr('0') + ')' +
                AND_IDF_Condition('PY_IDENTIFIER') +
               'ORDER BY PY_PROPERTY';
  ArcQry.SQL.Text := srvSqlStr;
  ArcQry.Open;
  var fldPS3_PY_PROPERTY         := ArcQry.FieldByName('PY_PROPERTY');
  var fldPS3_PY_RP_ADD_WC_PROC   := ArcQry.FieldByName('PY_RP_ADD_WC_PROC');
  var fldPS3_RP_WC_PROCESS        := ArcQry.FieldByName('RP_WC_PROCESS');
  var fldPS3_PY_RP_CONN_LEV_MAIN := ArcQry.FieldByName('PY_RP_CONN_LEV_MAIN');
  var fldPS3_RP_WKCNTER           := ArcQry.FieldByName('RP_WKCNTER');
  var fldPS3_RP_RES_CATEGORY      := ArcQry.FieldByName('RP_RES_CATEGORY');
  var fldPS3_RP_RSC_CODE          := ArcQry.FieldByName('RP_RSC_CODE');
  var fldPS3_RS_WKCNTER           := ArcQry.FieldByName('RS_WKCNTER');

  lastProp := '';

  while (not ArcQry.Eof) do
  begin
    if ( lastProp <> Trim(fldPS3_PY_PROPERTY.AsString) ) then
    begin
      lastProp := Trim(fldPS3_PY_PROPERTY.AsString);
      for I := 0 to propertyList.Count - 1 do
      begin
        NEWPROP := PPROPS(propertyList[I]);
        if NEWPROP.PY_PROPERTY <> lastProp then
        begin
          NEWPROP := nil;
          continue;
        end;
        break;
      end;
    end;
    if NEWPROP = nil then // will probably never happen
    begin
      ArcQry.Next;
      continue;
    end;

    if (Trim(fldPS3_PY_RP_ADD_WC_PROC.AsString) = '1') and (Trim(fldPS3_RP_WC_PROCESS.AsString) = '') then
    begin
      ArcQry.Next;
      continue;
    end;

    if (Trim(fldPS3_PY_RP_ADD_WC_PROC.AsString) <> '1') and (Trim(fldPS3_RP_WC_PROCESS.AsString) <> '') then
    begin
      ArcQry.Next;
      continue;
    end;

    if (Trim(fldPS3_PY_RP_CONN_LEV_MAIN.AsString) = '1')  // All resources
    and ( (Trim(fldPS3_RP_WKCNTER.AsString) <> '') OR
           (Trim(fldPS3_RP_RES_CATEGORY.AsString) <> '') OR
           (Trim(fldPS3_RP_RSC_CODE.AsString) <> '') or
           (Trim(fldPS3_PY_RP_ADD_WC_PROC.AsString) = '1') ) then
    begin
      ArcQry.Next;
      continue;
    end;

    if (Trim(fldPS3_PY_RP_CONN_LEV_MAIN.AsString) = '2')  // Depending on work center
    and ( (Trim(fldPS3_RP_WKCNTER.AsString) = '') OR
           (Trim(fldPS3_RP_RES_CATEGORY.AsString) <> '') OR
           (Trim(fldPS3_RP_RSC_CODE.AsString) <> '') ) then
    begin
      ArcQry.Next;
      continue;
    end;

    if (Trim(fldPS3_PY_RP_CONN_LEV_MAIN.AsString) = '3')  // Depending on category
    and ( (Trim(fldPS3_RP_WKCNTER.AsString) <> '') OR
           (Trim(fldPS3_RP_RES_CATEGORY.AsString) = '') OR
           (Trim(fldPS3_RP_RSC_CODE.AsString) <> '') ) then
    begin
      ArcQry.Next;
      continue;
    end;

    if (Trim(fldPS3_PY_RP_CONN_LEV_MAIN.AsString) = '4')  // Depending on resource
    and ( (Trim(fldPS3_RP_WKCNTER.AsString) <> '') OR
           (Trim(fldPS3_RP_RES_CATEGORY.AsString) <> '') OR
           (Trim(fldPS3_RP_RSC_CODE.AsString) = '') OR
           (fldPS3_RS_WKCNTER.IsNull) OR
           (Trim(fldPS3_RS_WKCNTER.AsString) = '') ) then
    begin
      ArcQry.Next;
      continue;
    end;

    if (Trim(fldPS3_PY_RP_CONN_LEV_MAIN.AsString) = '5')  // Depending on work center and category
    and ( (Trim(fldPS3_RP_WKCNTER.AsString) = '') OR
           (Trim(fldPS3_RP_RES_CATEGORY.AsString) = '') OR
           (Trim(fldPS3_RP_RSC_CODE.AsString) <> '') ) then
    begin
      ArcQry.Next;
      continue;
    end;

    NEWPROP.HasAtLeastOneConnectionToResource := true;

    if (Trim(fldPS3_PY_RP_CONN_LEV_MAIN.AsString) = '2')      // Depending on work center
    or (Trim(fldPS3_PY_RP_CONN_LEV_MAIN.AsString) = '4')      // Depending on resource
    or (Trim(fldPS3_PY_RP_CONN_LEV_MAIN.AsString) = '5') then // Depending on work center and category
    begin
      if (Trim(fldPS3_PY_RP_CONN_LEV_MAIN.AsString) = '4')  then
        WorkCenterCode := Trim(fldPS3_RS_WKCNTER.AsString)
      else
        WorkCenterCode := Trim(fldPS3_RP_WKCNTER.AsString);
      if (Trim(fldPS3_PY_RP_ADD_WC_PROC.AsString) = '1') then
      begin
        OperationAndWorkCenterCode := Trim(fldPS3_RP_WC_PROCESS.AsString)  + '||' + WorkCenterCode;
        if NEWPROP.PropWorkCentersCodePerOperation.IndexOf(OperationAndWorkCenterCode) = -1 then
          NEWPROP.PropWorkCentersCodePerOperation.Add(OperationAndWorkCenterCode);
        WorkCenterIndex := searchInList(handledWorkCentersList, 1, workCenterCode, 0, handledWorkCentersList.Count - 1);
        if WorkCenterIndex <> -1 then
        begin
          CUR_WORKCENTER := handledWorkCentersList.Items[WorkCenterIndex];
          for K := 0 to CUR_WORKCENTER.Process_List.Count -1 do
          begin
            CUR_PROCESS := CUR_WORKCENTER.Process_List.Items[K];
            if trim(CUR_PROCESS.WP_WKCT_PROC) = Trim(fldPS3_RP_WC_PROCESS.AsString) then
            begin
              for L := 0 to CUR_PROCESS.Alternatives_List.Count - 1 do
              begin
                WorkCenterCode := trim(CUR_PROCESS.Alternatives_List[L]);
                OperationAndWorkCenterCode := trim(CUR_PROCESS.WP_WKCT_PROC) + '||' + WorkCenterCode;
                if NEWPROP.PropWorkCentersCodePerOperation.IndexOf(OperationAndWorkCenterCode) = -1 then
                  NEWPROP.PropWorkCentersCodePerOperation.Add(OperationAndWorkCenterCode);
              end;
            end;
          end;
        end;
      end
      else
      begin
        if NEWPROP.PropWorkCentersCode.IndexOf(WorkCenterCode) = -1 then
           NEWPROP.PropWorkCentersCode.Add(WorkCenterCode);
      end;
    end;

    if (Trim(fldPS3_PY_RP_CONN_LEV_MAIN.AsString) = '3') then  // Depending on category
    begin
      for I := 0 to CategoryStr.Count -1 do
      begin
        if Trim(fldPS3_RP_RES_CATEGORY.AsString) = CategoryStr.Strings[I] then
        begin
          WorkCenterCode := WorkCenterStr.Strings[I];
          if (Trim(fldPS3_PY_RP_ADD_WC_PROC.AsString) = '1') then
          begin
            OperationAndWorkCenterCode := Trim(fldPS3_RP_WC_PROCESS.AsString)  + '||' + WorkCenterCode;
            if NEWPROP.PropWorkCentersCodePerOperation.IndexOf(OperationAndWorkCenterCode) = -1 then
              NEWPROP.PropWorkCentersCodePerOperation.Add(OperationAndWorkCenterCode);
            WorkCenterIndex := searchInList(handledWorkCentersList, 1, workCenterCode, 0, handledWorkCentersList.Count - 1);
            if WorkCenterIndex <> -1 then
            begin
              CUR_WORKCENTER := handledWorkCentersList.Items[WorkCenterIndex];
              for K := 0 to CUR_WORKCENTER.Process_List.Count -1 do
              begin
                CUR_PROCESS := CUR_WORKCENTER.Process_List.Items[K];
                if trim(CUR_PROCESS.WP_WKCT_PROC) = Trim(fldPS3_RP_WC_PROCESS.AsString) then
                begin
                  for L := 0 to CUR_PROCESS.Alternatives_List.Count - 1 do
                  begin
                    WorkCenterCode := trim(CUR_PROCESS.Alternatives_List[L]);
                    OperationAndWorkCenterCode := trim(CUR_PROCESS.WP_WKCT_PROC) + '||' + WorkCenterCode;
                    if NEWPROP.PropWorkCentersCodePerOperation.IndexOf(OperationAndWorkCenterCode) = -1 then
                      NEWPROP.PropWorkCentersCodePerOperation.Add(OperationAndWorkCenterCode);
                  end;
                end;
              end;
            end;
          end
          else
          begin
            if NEWPROP.PropWorkCentersCode.IndexOf(WorkCenterCode) = -1 then
               NEWPROP.PropWorkCentersCode.Add(WorkCenterCode);
          end;
        end;
      end;
    end;

    ArcQry.Next;
  end;

  for I := 0 to propertyList.Count - 1 do
  begin
    NEWPROP := PPROPS(propertyList[I]);
    for J := 0 to NEWPROP.PropWorkCentersCode.Count - 1 do
    begin
      WorkCenterCode := NEWPROP.PropWorkCentersCode[J];
      WorkCenterIndex := searchInList(handledWorkCentersList, 1, workCenterCode, 0, handledWorkCentersList.Count - 1);
      if WorkCenterIndex <> -1 then
      begin
        CUR_WORKCENTER := handledWorkCentersList.Items[WorkCenterIndex];
        for K := 0 to CUR_WORKCENTER.Process_List.Count -1 do
        begin
          CUR_PROCESS := CUR_WORKCENTER.Process_List.Items[K];
          for L := 0 to CUR_PROCESS.Alternatives_List.Count - 1 do
          begin
            WorkCenterCode := trim(CUR_PROCESS.Alternatives_List[L]);
            if NEWPROP.PropWorkCentersCode.IndexOf(WorkCenterCode) = -1 then
            begin
              OperationAndWorkCenterCode := trim(CUR_PROCESS.WP_WKCT_PROC) + '||' + WorkCenterCode;
              if NEWPROP.PropWorkCentersCodePerOperation.IndexOf(OperationAndWorkCenterCode) = -1 then
                NEWPROP.PropWorkCentersCodePerOperation.Add(OperationAndWorkCenterCode);
            end;
          end;
        end;
      end;
    end;
  end;

  ArcQry.Close;
  WorkCenterStr.Free;
  CategoryStr.Free;

end;

//----------------------------------------------------------------------------//

procedure Fill_Products_properties(read_Productproperty_list : TList; additionalDataList : TList; propertyList: TList; WarpItemHandledStrList : TStringList; List_Items : TList);
var
  I, p, index, IndexProduct : Integer;
  prodCode, RTV_VALUE, ProductValue, propertyValue, ValueFromTable : string;
  Items : PTITEMS;
  CUR_PROP: PPROPS;
  CUR_PROP_RTV_VALUE: PPROP_RTV_VALUES;
  MQMProductProperty : PMQMProductProperty;
  CUR_ADDITIONALDATA_HEADER: PADDITIONALDATA_HEADERS;
  DataType : Integer;
  CompleteMqmFormat : boolean;
begin
  DataType := 0;
  for I := 0 to List_Items.Count - 1 do
  begin
    Items := PTITEMS(List_Items[I]);
    if WarpItemHandledStrList.IndexOf(Items.ITEMTYPEAFICODE) = -1 then continue;

    for p := 0 to propertyList.Count - 1 do
    begin
      CUR_PROP := propertyList.Items[p];
      if (trim(CUR_PROP.PY_DESIGNATEDPROPERTY) <> '7') and (CUR_PROP.PY_DESIGNATEDPROPERTY <> '8')
         and (trim(CUR_PROP.PY_DESIGNATEDPROPERTY) <> '9') and (trim(CUR_PROP.PY_DESIGNATEDPROPERTY) <> '0')
            and (trim(CUR_PROP.PY_DESIGNATEDPROPERTY) <> '') then Continue;

      index := searchInList(CUR_PROP.propRtvValueList, 43,
                                Trim(Items.ITEMTYPEAFICODE),
                                0, CUR_PROP.propRtvValueList.Count - 1);
      if ( index <> -1 ) then
      begin
        CUR_PROP_RTV_VALUE := CUR_PROP.propRtvValueList.Items[index];
        if not ((CUR_PROP_RTV_VALUE.TABLE_NAME = 'PRODUCT') or
          (CUR_PROP_RTV_VALUE.TABLE_NAME = 'FULLITEMKEYDECODER') or
          (CUR_PROP_RTV_VALUE.TABLE_NAME = 'PRODUCTSPECIALIZEDGREIGE') or
          (CUR_PROP_RTV_VALUE.TABLE_NAME = 'PRODUCTSPECIALIZEDSIZE') or
          (CUR_PROP_RTV_VALUE.TABLE_NAME = 'PRODUCTSPECIALIZEDYARN') or
          (CUR_PROP_RTV_VALUE.TABLE_NAME = 'Product AD') or
          (CUR_PROP_RTV_VALUE.TABLE_NAME = 'FullItemKeyDecoder AD') or
          (copy(CUR_PROP_RTV_VALUE.TABLE_NAME, 1, 19) = 'UserGenericGroup AD')) then continue;

        prodCode := getFullItemKeyCode(Items.ITEMTYPEAFICODE,
                                     Items.SUBCODE01,
                                     Items.SUBCODE02,
                                     Items.SUBCODE03,
                                     Items.SUBCODE04,
                                     Items.SUBCODE05,
                                     Items.SUBCODE06,
                                     Items.SUBCODE07,
                                     Items.SUBCODE08,
                                     Items.SUBCODE09,
                                     Items.SUBCODE10);

       // RtvFromIsFound := true;
        CUR_PROP_RTV_VALUE := CUR_PROP.propRtvValueList.Items[index];

        CompleteMqmFormat := true;
        if (CUR_PROP.PY_TYPE = '2') and ((CUR_PROP_RTV_VALUE.From_Position > 0) and (CUR_PROP_RTV_VALUE.From_Position < 90))
           and ((CUR_PROP_RTV_VALUE.Length_From_Pos > 0) and (CUR_PROP_RTV_VALUE.Length_From_Pos < 90)) then
        begin
          CompleteMqmFormat := false;
        end;

        if (CUR_PROP_RTV_VALUE.TABLE_NAME = 'PRODUCT') then
        begin
          RTV_VALUE := copy('P_' + CUR_PROP_RTV_VALUE.COLUMN_NAME, 1, 30);
          IndexProduct := Items.productColumnNames.IndexOf(RTV_VALUE);
          if IndexProduct <> -1 then
          begin
            ProductValue := Items.ProductColumnValue.Strings[IndexProduct];
            propertyValue := formatPropertyValueDirect(CUR_PROP, ProductValue, CompleteMqmFormat, CUR_PROP_RTV_VALUE)
          end;
        end

        else if (CUR_PROP_RTV_VALUE.TABLE_NAME = 'FULLITEMKEYDECODER') then
        begin
          RTV_VALUE := copy('FIKD_' + CUR_PROP_RTV_VALUE.COLUMN_NAME, 1, 30);
          if assigned(Items) then
          begin
	          IndexProduct := Items.FullItemKeyDecoderColumnNames.IndexOf(RTV_VALUE);
	          if IndexProduct <> -1 then
	          begin
	            ProductValue := Items.FullItemKeyDecoderColumnValue.Strings[IndexProduct];
	            propertyValue := formatPropertyValueDirect(CUR_PROP, ProductValue, CompleteMqmFormat, CUR_PROP_RTV_VALUE);
	          end
          end;
        end

        else if (CUR_PROP_RTV_VALUE.TABLE_NAME = 'PRODUCTSPECIALIZEDGREIGE') then
        begin
          RTV_VALUE := copy('PSG_' + CUR_PROP_RTV_VALUE.COLUMN_NAME, 1, 30);
          if assigned(Items) and Items.ProductSpecializedGreigeColumn_created then
          begin
            IndexProduct := Items.productSpecializedGreigeColumnNames.IndexOf(RTV_VALUE);
            if IndexProduct <> -1 then
            begin
              ProductValue := Items.ProductSpecializedGreigeColumnValue.Strings[IndexProduct];
              propertyValue := formatPropertyValueDirect(CUR_PROP, ProductValue, CompleteMqmFormat, CUR_PROP_RTV_VALUE);
            end;
          end;
        end

        else if (CUR_PROP_RTV_VALUE.TABLE_NAME = 'PRODUCTSPECIALIZEDSIZE') then
        begin
          RTV_VALUE := copy('PSY_' + CUR_PROP_RTV_VALUE.COLUMN_NAME, 1, 30);
          if assigned(Items) and Items.ProductSpecializedSizeColumn_created then
          begin
            IndexProduct := Items.ProductSpecializedSizeColumnNames.IndexOf(RTV_VALUE);
            if IndexProduct <> -1 then
            begin
              ProductValue := Items.ProductSpecializedSizeColumnValue.Strings[IndexProduct];
              propertyValue := formatPropertyValueDirect(CUR_PROP, ProductValue, CompleteMqmFormat, CUR_PROP_RTV_VALUE);
            end;
          end;
        end

        else if (CUR_PROP_RTV_VALUE.TABLE_NAME = 'PRODUCTSPECIALIZEDYARN') then
        begin
          RTV_VALUE := copy('PSY_' + CUR_PROP_RTV_VALUE.COLUMN_NAME, 1, 30);
          if assigned(Items) and Items.ProductSpecializedYarnColumn_created then
          begin
            IndexProduct := Items.productSpecializedYarnColumnNames.IndexOf(RTV_VALUE);
            if IndexProduct <> -1 then
            begin
              ProductValue := Items.ProductSpecializedYarnColumnValue.Strings[IndexProduct];
              propertyValue := formatPropertyValueDirect(CUR_PROP, ProductValue, CompleteMqmFormat, CUR_PROP_RTV_VALUE);
            end;
          end;
        end

        else if (CUR_PROP_RTV_VALUE.TABLE_NAME = 'FullItemKeyDecoder AD') then
        begin
          ValueFromTable := '';
          if Assigned(Items) then
            index := searchInList(additionalDataList, 8, Items.ABSUNIQUEID,
                        0, additionalDataList.Count - 1);

          CUR_ADDITIONALDATA_HEADER := nil;
          if ( index <> -1 ) then
          begin
            CUR_ADDITIONALDATA_HEADER := additionalDataList.Items[index];
            ValueFromTable := getAdditionalData(CUR_ADDITIONALDATA_HEADER.fullItemKeyDecoderADList, CUR_PROP_RTV_VALUE.COLUMN_NAME,DataType);
          end;

          try
            propertyValue := formatPropertyValueDirect(CUR_PROP,ValueFromTable, CompleteMqmFormat, CUR_PROP_RTV_VALUE);
          except
            propertyValue := '';
          end;
        end

        else if (CUR_PROP_RTV_VALUE.TABLE_NAME = 'Product AD') then
        begin
          ValueFromTable := '';
          if Assigned(Items) then
            index := searchInList(additionalDataList, 8, Items.ABSUNIQUEID_P,
                        0, additionalDataList.Count - 1);

          CUR_ADDITIONALDATA_HEADER := nil;
          if ( index <> -1 ) then
          begin
            CUR_ADDITIONALDATA_HEADER := additionalDataList.Items[index];
            ValueFromTable := getAdditionalData(CUR_ADDITIONALDATA_HEADER.productADList, CUR_PROP_RTV_VALUE.COLUMN_NAME, DataType);
          end;

          propertyValue := formatPropertyValueDirect(CUR_PROP,ValueFromTable, CompleteMqmFormat, CUR_PROP_RTV_VALUE);
        end;

        if (DataType = 1) or (DataType = 4) or (DataType = 5) then
        begin
          if Trim(ValueFromTable) = '' then
               ValueFromTable := '0';
          if (trim(CUR_PROP.PY_DESIGNATEDPROPERTY) = '7') then
             Items.MAT_STANDARD_SPEED_Warp := StrToFloat(ValueFromTable);
          if (trim(CUR_PROP.PY_DESIGNATEDPROPERTY) = '8') then
             Items.MAT_STANDARD_SETMIN_Warp :=  StrToFloat(ValueFromTable);
        end;

        if (trim(CUR_PROP.PY_DESIGNATEDPROPERTY) = '9') then     // warp lvl to change it
           Items.MAT_SCHEDULE_Type_Warp :=  propertyValue;

        if (trim(CUR_PROP.PY_DESIGNATEDPROPERTY) <> '') and (trim(CUR_PROP.PY_DESIGNATEDPROPERTY) <> '0') then     // warp lvl to change it
           continue;


        //if (trim(CUR_PROP.PY_DESIGNATEDPROPERTY) = '7') or (trim(CUR_PROP.PY_DESIGNATEDPROPERTY) = '8') then
        //begin

          {  if (trim(CUR_PROP.PY_DESIGNATEDPROPERTY) = '7') or (trim(CUR_PROP.PY_DESIGNATEDPROPERTY) = '8') then
            begin
              if trim(ValueFromTable) = '' then
                ValueFromTable := '0';
              SpeedOrSetupValue := ValueFromTable;
              SpeedOrSetupValue := StrToFloat(SpeedOrSetupValue);
              if (trim(CUR_PROP.PY_DESIGNATEDPROPERTY) = '7') then
                Items.MAT_STANDARD_SPEED_Warp := SpeedOrSetupValue
              else if (trim(CUR_PROP.PY_DESIGNATEDPROPERTY) = '8') then
                Items.MAT_STANDARD_SETMIN_Warp := SpeedOrSetupValue;
              continue; }
          //  end

        //end;

        new(MQMProductProperty);
        MQMProductProperty.PDP_TYPE_PROD := items.ITEMTYPEAFICODE;
        MQMProductProperty.PDP_PRODUCT_CODE := prodCode;
        MQMProductProperty.PDP_PROPERTY := CUR_PROP.PY_PROPERTY;
        MQMProductProperty.PDP_VALUE := propertyValue;
        read_Productproperty_list.add(MQMProductProperty);

      end;
    end;

  end;
end;

//----------------------------------------------------------------------------//

procedure fillAlternativeWarehouseStruct(ArcQry : TMqmQuery; alternativeWarehouseList: TList);
var
  srvSqlStr: String;
  NEW_ALT_WAREHOUSE_WKC: PALT_WAREHOUSE_WKCS;
  NEW_ALT_WAREHOUSE_WKC_GROUP: PALT_WAREHOUSE_WKC_GROUPS;
  NEW_ALT_WAREHOUSE_WKC_GROUP_ITEM_TYPE: PALT_WAREHOUSE_WKC_GROUP_ITEM_TYPES;
  NEW_ALT_WAREHOUSE: PALT_WAREHOUSES;
  fldWkcnter, fldNetGroupCode, fldIssueItemType, fldAlternWC, fldAlternNetGroupCode: TField;

  lastAlternativeWarehouseWkc: String;
  lastAlternativeWarehouseWkcGroup: String;
  lastAlternativeWarehouseWkcGroupItemType, TableName: String;
  DndArchiveArcName : TDndArchiveName;
  ALT_WAREHOUSE_WKC_List : Tlist;
  I : integer;
begin
  ALT_WAREHOUSE_WKC_List := TList.Create;
  DndArchiveArcName := GetDndArchiveLocalName;
  TableName := 'ALTERNATIVEWAREHOUSE';
  if DndArchiveArcName <> TD_Interbase then
    TableName  := 'SCDA_' + 'ALTERNATIVEWAREHOUSE';

  srvSqlStr := 'SELECT WKCNTER, NET_GROUP_CODE, ISSUE_ITEM_TYPE, ALTERN_WC, ' +
               'ALTERN_NET_GROUP_CODE FROM ' + TableName +
                WHERE_IDF_Condition('IDENTIFIER') +
               ' ORDER BY WKCNTER ASC, NET_GROUP_CODE, ISSUE_ITEM_TYPE, ALTERN_WC';
  ArcQry.SQL.Text := srvSqlStr;
  ArcQry.Open;
  fldWkcnter             := ArcQry.FieldByName('WKCNTER');
  fldNetGroupCode        := ArcQry.FieldByName('NET_GROUP_CODE');
  fldIssueItemType       := ArcQry.FieldByName('ISSUE_ITEM_TYPE');
  fldAlternWC            := ArcQry.FieldByName('ALTERN_WC');
  fldAlternNetGroupCode  := ArcQry.FieldByName('ALTERN_NET_GROUP_CODE');

  while (not ArcQry.Eof) do
  begin
    New(NEW_ALT_WAREHOUSE_WKC);
    NEW_ALT_WAREHOUSE_WKC.WORKCENTER := Trim(fldWkcnter.AsString);
    NEW_ALT_WAREHOUSE_WKC.NET_GROUP_CODE := Trim(fldNetGroupCode.AsString);
    NEW_ALT_WAREHOUSE_WKC.ISSUE_ITEM_TYPE := Trim(fldIssueItemType.AsString);
    NEW_ALT_WAREHOUSE_WKC.ALTERN_WC := Trim(fldAlternWC.AsString);
    NEW_ALT_WAREHOUSE_WKC.ALTERN_NET_GROUP_CODE := Trim(fldAlternNetGroupCode.AsString);
    ALT_WAREHOUSE_WKC_List.Add(NEW_ALT_WAREHOUSE_WKC);
    ArcQry.Next;
  end;
  ALT_WAREHOUSE_WKC_List.Sort(Sort_ALT_WAREHOUSE_WKC);

  NEW_ALT_WAREHOUSE_WKC := nil;
  NEW_ALT_WAREHOUSE_WKC_GROUP := nil;
  NEW_ALT_WAREHOUSE_WKC_GROUP_ITEM_TYPE := nil;

  lastAlternativeWarehouseWkc := '';
  lastAlternativeWarehouseWkcGroup := '';
  lastAlternativeWarehouseWkcGroupItemType := '';

  for I := 0 to ALT_WAREHOUSE_WKC_List.Count - 1 do
  begin
    if ( lastAlternativeWarehouseWkc <> PALT_WAREHOUSE_WKCS(ALT_WAREHOUSE_WKC_List[I]).WORKCENTER) then
    begin
      lastAlternativeWarehouseWkc := PALT_WAREHOUSE_WKCS(ALT_WAREHOUSE_WKC_List[I]).WORKCENTER;
      lastAlternativeWarehouseWkcGroup := PALT_WAREHOUSE_WKCS(ALT_WAREHOUSE_WKC_List[I]).NET_GROUP_CODE;
      lastAlternativeWarehouseWkcGroupItemType := PALT_WAREHOUSE_WKCS(ALT_WAREHOUSE_WKC_List[I]).ISSUE_ITEM_TYPE;

      New(NEW_ALT_WAREHOUSE_WKC);

      NEW_ALT_WAREHOUSE_WKC.WORKCENTER := lastAlternativeWarehouseWkc;
      NEW_ALT_WAREHOUSE_WKC.groupCodeList := TList.Create;

      New(NEW_ALT_WAREHOUSE_WKC_GROUP);
      NEW_ALT_WAREHOUSE_WKC_GROUP.NET_GROUP := lastAlternativeWarehouseWkcGroup;
      NEW_ALT_WAREHOUSE_WKC_GROUP.itemTypeList := TList.Create;

      New(NEW_ALT_WAREHOUSE_WKC_GROUP_ITEM_TYPE);
      NEW_ALT_WAREHOUSE_WKC_GROUP_ITEM_TYPE.ITEM_TYPE := lastAlternativeWarehouseWkcGroupItemType;
      NEW_ALT_WAREHOUSE_WKC_GROUP_ITEM_TYPE.alternativeList := TList.Create;

      New(NEW_ALT_WAREHOUSE);
      NEW_ALT_WAREHOUSE.ALT_WORKCENTER := PALT_WAREHOUSE_WKCS(ALT_WAREHOUSE_WKC_List[I]).ALTERN_WC;
      NEW_ALT_WAREHOUSE.ALT_NET_GROUP := PALT_WAREHOUSE_WKCS(ALT_WAREHOUSE_WKC_List[I]).ALTERN_NET_GROUP_CODE;

      NEW_ALT_WAREHOUSE_WKC_GROUP_ITEM_TYPE.alternativeList.Add(NEW_ALT_WAREHOUSE);
      NEW_ALT_WAREHOUSE_WKC_GROUP.itemTypeList.Add(NEW_ALT_WAREHOUSE_WKC_GROUP_ITEM_TYPE);
      NEW_ALT_WAREHOUSE_WKC.groupCodeList.Add(NEW_ALT_WAREHOUSE_WKC_GROUP);
      alternativeWarehouseList.Add(NEW_ALT_WAREHOUSE_WKC);
    end
    else if ( lastAlternativeWarehouseWkcGroup <> PALT_WAREHOUSE_WKCS(ALT_WAREHOUSE_WKC_List[I]).NET_GROUP_CODE ) then
    begin
      lastAlternativeWarehouseWkcGroup := PALT_WAREHOUSE_WKCS(ALT_WAREHOUSE_WKC_List[I]).NET_GROUP_CODE;
      lastAlternativeWarehouseWkcGroupItemType := PALT_WAREHOUSE_WKCS(ALT_WAREHOUSE_WKC_List[I]).ISSUE_ITEM_TYPE;

      New(NEW_ALT_WAREHOUSE_WKC_GROUP);
      NEW_ALT_WAREHOUSE_WKC_GROUP.NET_GROUP := lastAlternativeWarehouseWkcGroup;
      NEW_ALT_WAREHOUSE_WKC_GROUP.itemTypeList := TList.Create;

      New(NEW_ALT_WAREHOUSE_WKC_GROUP_ITEM_TYPE);
      NEW_ALT_WAREHOUSE_WKC_GROUP_ITEM_TYPE.ITEM_TYPE := lastAlternativeWarehouseWkcGroupItemType;
      NEW_ALT_WAREHOUSE_WKC_GROUP_ITEM_TYPE.alternativeList := TList.Create;

      New(NEW_ALT_WAREHOUSE);
      NEW_ALT_WAREHOUSE.ALT_WORKCENTER := PALT_WAREHOUSE_WKCS(ALT_WAREHOUSE_WKC_List[I]).ALTERN_WC;
      NEW_ALT_WAREHOUSE.ALT_NET_GROUP := PALT_WAREHOUSE_WKCS(ALT_WAREHOUSE_WKC_List[I]).ALTERN_NET_GROUP_CODE;

      NEW_ALT_WAREHOUSE_WKC_GROUP_ITEM_TYPE.alternativeList.Add(NEW_ALT_WAREHOUSE);
      NEW_ALT_WAREHOUSE_WKC_GROUP.itemTypeList.Add(NEW_ALT_WAREHOUSE_WKC_GROUP_ITEM_TYPE);
      NEW_ALT_WAREHOUSE_WKC.groupCodeList.Add(NEW_ALT_WAREHOUSE_WKC_GROUP);
    end
    else if ( lastAlternativeWarehouseWkcGroupItemType <> PALT_WAREHOUSE_WKCS(ALT_WAREHOUSE_WKC_List[I]).ISSUE_ITEM_TYPE) then
    begin
      lastAlternativeWarehouseWkcGroupItemType := PALT_WAREHOUSE_WKCS(ALT_WAREHOUSE_WKC_List[I]).ISSUE_ITEM_TYPE;

      New(NEW_ALT_WAREHOUSE_WKC_GROUP_ITEM_TYPE);
      NEW_ALT_WAREHOUSE_WKC_GROUP_ITEM_TYPE.ITEM_TYPE := lastAlternativeWarehouseWkcGroupItemType;
      NEW_ALT_WAREHOUSE_WKC_GROUP_ITEM_TYPE.alternativeList := TList.Create;

      New(NEW_ALT_WAREHOUSE);
      NEW_ALT_WAREHOUSE.ALT_WORKCENTER := PALT_WAREHOUSE_WKCS(ALT_WAREHOUSE_WKC_List[I]).ALTERN_WC;
      NEW_ALT_WAREHOUSE.ALT_NET_GROUP := PALT_WAREHOUSE_WKCS(ALT_WAREHOUSE_WKC_List[I]).ALTERN_NET_GROUP_CODE;

      NEW_ALT_WAREHOUSE_WKC_GROUP_ITEM_TYPE.alternativeList.Add(NEW_ALT_WAREHOUSE);
      NEW_ALT_WAREHOUSE_WKC_GROUP.itemTypeList.Add(NEW_ALT_WAREHOUSE_WKC_GROUP_ITEM_TYPE);
    end
    else
    begin
      New(NEW_ALT_WAREHOUSE);
      NEW_ALT_WAREHOUSE.ALT_WORKCENTER := PALT_WAREHOUSE_WKCS(ALT_WAREHOUSE_WKC_List[I]).ALTERN_WC;
      NEW_ALT_WAREHOUSE.ALT_NET_GROUP := PALT_WAREHOUSE_WKCS(ALT_WAREHOUSE_WKC_List[I]).ALTERN_NET_GROUP_CODE;

      NEW_ALT_WAREHOUSE_WKC_GROUP_ITEM_TYPE.alternativeList.Add(NEW_ALT_WAREHOUSE);
    end;

  end;

  for I := 0 to ALT_WAREHOUSE_WKC_List.Count - 1 do
     dispose(PALT_WAREHOUSE_WKCS(ALT_WAREHOUSE_WKC_List[I]));
  ALT_WAREHOUSE_WKC_List.Free;
  ArcQry.Close;
end;

//----------------------------------------------------------------------------//

procedure fillItemTypeLogicalWarehouseStruct(ArcQry: TMqmQuery; itemTypeLogicalWarehouseList: TList; var NETGROUP_IS_LOT_Handaled : boolean;
            var AD_Product_FieldsList : TStringlist; var AD_FullItemKeyDecoder_FieldsList  : TStringlist;
            var AD_ProductionDemandStep_FieldsList  : TStringlist; var AD_ProductionDemand_FieldsList : TStringlist);

var
  srvSqlStr: String;
  NEWITEMTYPELOGICALWAREHOUSE_ITEMTYPE: PITEMTYPELOGICALWAREHOUSE_ITEMTYPES;
  NEWITEMTYPELOGICALWAREHOUSE: PITEMTYPELOGICALWAREHOUSES;
  lastItemType, TableName: String;
  DndArchiveArcName : TDndArchiveName;
begin
  DndArchiveArcName := GetDndArchiveLocalName;
  NETGROUP_IS_LOT_Handaled := false;
  TableName := 'ITEMTYPELOGICALWAREHOUSE';
  if DndArchiveArcName <> TD_Interbase then
    TableName  := 'SCDA_' + 'ITEMTYPELOGICALWAREHOUSE';

  srvSqlStr := 'SELECT * FROM ' + TableName + WHERE_IDF_Condition('IDENTIFIER') +
               ' ORDER BY ITEMTYPECODE, LOGICALWAREHOUSECODE';
  ArcQry.SQL.Text := srvSqlStr;
  ArcQry.Open;
  NEWITEMTYPELOGICALWAREHOUSE_ITEMTYPE := nil;
  lastItemType := '';

  var ITEMTYPECODE_FIELD := ArcQry.FieldByName('ITEMTYPECODE');
  var LOGICALWAREHOUSECODE_FIELD := ArcQry.FieldByName('LOGICALWAREHOUSECODE');
  var RESERVATIONTABLENAME_FIELD := ArcQry.FieldByName('RESERVATIONTABLENAME');
  var RESERVATIONCOLUMNNAME_FIELD := ArcQry.FieldByName('RESERVATIONCOLUMNNAME');
  var DEMANDTABLENAME_FIELD := ArcQry.FieldByName('DEMANDTABLENAME');
  var DEMANDCOLUMNNAME_FIELD := ArcQry.FieldByName('DEMANDCOLUMNNAME');
  var NET_GRP_LOT_FIELD      := ArcQry.FieldByName('NET_GRP_LOT');
  var Reservation_RELATED_COLUMN := ArcQry.FieldByName('RES_RELATED_COLUMN');
  var Demand_RELATED_COLUMN      := ArcQry.FieldByName('DEM_RELATED_COLUMN');

  while (not ArcQry.Eof) do
  begin
    if (lastItemType <> Trim(ITEMTYPECODE_FIELD.AsString)) then
    begin
      if (lastItemType <> '') then
        itemTypeLogicalWarehouseList.Add(NEWITEMTYPELOGICALWAREHOUSE_ITEMTYPE);

      lastItemType := Trim(ITEMTYPECODE_FIELD.AsString);

      New(NEWITEMTYPELOGICALWAREHOUSE_ITEMTYPE);
      NEWITEMTYPELOGICALWAREHOUSE_ITEMTYPE.ITEMTYPECODE := Trim(ITEMTYPECODE_FIELD.AsString);
      NEWITEMTYPELOGICALWAREHOUSE_ITEMTYPE.logicalWarehouseList := TList.Create;
    end;

    New(NEWITEMTYPELOGICALWAREHOUSE);
    NEWITEMTYPELOGICALWAREHOUSE.LOGICALWAREHOUSECODE := Trim(LOGICALWAREHOUSECODE_FIELD.AsString);
    NEWITEMTYPELOGICALWAREHOUSE.RESERVATIONTABLENAME := Trim(RESERVATIONTABLENAME_FIELD.AsString);
    NEWITEMTYPELOGICALWAREHOUSE.RESERVATIONCOLUMNNAME := Trim(RESERVATIONCOLUMNNAME_FIELD.AsString);
    NEWITEMTYPELOGICALWAREHOUSE.DEMANDTABLENAME := Trim(DEMANDTABLENAME_FIELD.AsString);
    NEWITEMTYPELOGICALWAREHOUSE.DEMANDCOLUMNNAME := Trim(DEMANDCOLUMNNAME_FIELD.AsString);
    NEWITEMTYPELOGICALWAREHOUSE.NET_GRP_LOT      := Trim(NET_GRP_LOT_FIELD.AsString);
    NEWITEMTYPELOGICALWAREHOUSE.Reservation_RELATED_COLUMN := Trim(Reservation_RELATED_COLUMN.AsString);
    NEWITEMTYPELOGICALWAREHOUSE.Demand_RELATED_COLUMN      := Trim(Demand_RELATED_COLUMN.AsString);

    if (NEWITEMTYPELOGICALWAREHOUSE.NET_GRP_LOT = '1') or (NEWITEMTYPELOGICALWAREHOUSE.NET_GRP_LOT = '2') then
      NETGROUP_IS_LOT_Handaled := true;
    NEWITEMTYPELOGICALWAREHOUSE_ITEMTYPE.logicalWarehouseList.Add(NEWITEMTYPELOGICALWAREHOUSE);

    if NEWITEMTYPELOGICALWAREHOUSE.RESERVATIONTABLENAME = 'Product AD' then
    begin
      if NEWITEMTYPELOGICALWAREHOUSE.RESERVATIONCOLUMNNAME <> '' then
        if AD_Product_FieldsList.IndexOf(NEWITEMTYPELOGICALWAREHOUSE.RESERVATIONCOLUMNNAME) = -1 then
           AD_Product_FieldsList.add(NEWITEMTYPELOGICALWAREHOUSE.RESERVATIONCOLUMNNAME);
    end
    else if NEWITEMTYPELOGICALWAREHOUSE.RESERVATIONTABLENAME = 'FullItemKeyDecoder AD' then
    begin
      if NEWITEMTYPELOGICALWAREHOUSE.RESERVATIONCOLUMNNAME <> '' then
        if AD_FullItemKeyDecoder_FieldsList.IndexOf(NEWITEMTYPELOGICALWAREHOUSE.RESERVATIONCOLUMNNAME) = -1 then
           AD_FullItemKeyDecoder_FieldsList.add(NEWITEMTYPELOGICALWAREHOUSE.RESERVATIONCOLUMNNAME);
    end
    else if NEWITEMTYPELOGICALWAREHOUSE.RESERVATIONTABLENAME = 'ProductionDemandStep AD' then
    begin
      if NEWITEMTYPELOGICALWAREHOUSE.RESERVATIONCOLUMNNAME <> '' then
        if AD_ProductionDemandStep_FieldsList.IndexOf(NEWITEMTYPELOGICALWAREHOUSE.RESERVATIONCOLUMNNAME) = -1 then
           AD_ProductionDemandStep_FieldsList.add(NEWITEMTYPELOGICALWAREHOUSE.RESERVATIONCOLUMNNAME);
    end
    else if NEWITEMTYPELOGICALWAREHOUSE.RESERVATIONTABLENAME = 'ProductionDemand AD' then
    begin
      if NEWITEMTYPELOGICALWAREHOUSE.RESERVATIONCOLUMNNAME <> '' then
        if AD_ProductionDemand_FieldsList.IndexOf(NEWITEMTYPELOGICALWAREHOUSE.RESERVATIONCOLUMNNAME) = -1 then
          AD_ProductionDemand_FieldsList.add(NEWITEMTYPELOGICALWAREHOUSE.RESERVATIONCOLUMNNAME);
    end;

    if NEWITEMTYPELOGICALWAREHOUSE.DEMANDTABLENAME = 'Product AD' then
    begin
      if NEWITEMTYPELOGICALWAREHOUSE.DEMANDCOLUMNNAME <> '' then
        if AD_Product_FieldsList.IndexOf(NEWITEMTYPELOGICALWAREHOUSE.DEMANDCOLUMNNAME) = -1 then
           AD_Product_FieldsList.add(NEWITEMTYPELOGICALWAREHOUSE.DEMANDCOLUMNNAME);
    end
    else if NEWITEMTYPELOGICALWAREHOUSE.DEMANDTABLENAME = 'FullItemKeyDecoder AD' then
    begin
      if NEWITEMTYPELOGICALWAREHOUSE.DEMANDCOLUMNNAME <> '' then
        if AD_FullItemKeyDecoder_FieldsList.IndexOf(NEWITEMTYPELOGICALWAREHOUSE.DEMANDCOLUMNNAME) = -1 then
           AD_FullItemKeyDecoder_FieldsList.add(NEWITEMTYPELOGICALWAREHOUSE.DEMANDCOLUMNNAME);
    end
    else if NEWITEMTYPELOGICALWAREHOUSE.DEMANDTABLENAME = 'ProductionDemandStep AD' then
    begin
      if NEWITEMTYPELOGICALWAREHOUSE.DEMANDCOLUMNNAME <> '' then
        if AD_FullItemKeyDecoder_FieldsList.IndexOf(NEWITEMTYPELOGICALWAREHOUSE.DEMANDCOLUMNNAME) = -1 then
           AD_FullItemKeyDecoder_FieldsList.add(NEWITEMTYPELOGICALWAREHOUSE.DEMANDCOLUMNNAME);
    end
    else if NEWITEMTYPELOGICALWAREHOUSE.DEMANDTABLENAME = 'ProductionDemand AD' then
    begin
      if NEWITEMTYPELOGICALWAREHOUSE.DEMANDCOLUMNNAME <> '' then
        if AD_ProductionDemand_FieldsList.IndexOf(NEWITEMTYPELOGICALWAREHOUSE.DEMANDCOLUMNNAME) = -1 then
          AD_ProductionDemand_FieldsList.add(NEWITEMTYPELOGICALWAREHOUSE.DEMANDCOLUMNNAME);
    end;

    ArcQry.Next;
  end;

  if (lastItemType <> '') then
    itemTypeLogicalWarehouseList.Add(NEWITEMTYPELOGICALWAREHOUSE_ITEMTYPE);

  ArcQry.Active := false;

  ArcQry.Close;
end;

//----------------------------------------------------------------------------//

function FindItemBinarSearch(List : TList; Item: string): PTITEMS;
var
  i: integer;
  Multiplier, NumberOfEntries : integer; // Eran25062010
begin

  Result := nil;

  NumberOfEntries := List.Count;
  if NumberOfEntries = 0 then exit;

  Multiplier := 1;
  while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    i := Multiplier - 1;

  while (Multiplier > 0) do
  begin

    if (i < NumberOfEntries)
    and (PTITEMS(List[i]).ABSUNIQUEID = Item) then break;

    Multiplier := trunc(Multiplier / 2);

    if  (i < NumberOfEntries)
    and (PTITEMS(List[i]).ABSUNIQUEID < Item) then
      i := i + Multiplier
    else
      i := i - Multiplier;

  end;

  if Multiplier > 0 then Result := PTITEMS(List[i]);

end;

//----------------------------------------------------------------------------//

function FindGenericBinarSearch(List : TList; Entity : String; Key1,Key2,Key3,Key4,Key5,Key6 : variant): PRGeneric;
var
  i: integer;
  Multiplier, NumberOfEntries, NumberOfKeys : integer;
  Value: Extended;
begin
  Result := nil;
  NumberOfEntries := List.Count;
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

    if (PRGeneric(List[i]).Entity < Entity) then
    begin
      i := i + Multiplier;
      continue;
    end;
    if (PRGeneric(List[i]).Entity > Entity) then
    begin
      i := i - Multiplier;
      continue;
    end;

    if (PRGeneric(List[i]).Key1 < Key1) then
    begin
      i := i + Multiplier;
      continue;
    end;

    if (PRGeneric(List[i]).Key1 > Key1) then
    begin
      i := i - Multiplier;
      continue;
    end;

    NumberOfKeys := PRGeneric(List[i]).NumberOfKeys;

    if NumberOfKeys > 1 then
    begin
      if (PRGeneric(List[i]).Key2 < Key2) then
      begin
        i := i + Multiplier;
        continue;
      end;
      if (PRGeneric(List[i]).Key2 > Key2) then
      begin
        i := i - Multiplier;
        continue;
      end;
    end;

    if NumberOfKeys > 2 then
    begin

      if (PRGeneric(List[i]).Key3 < Key3) then
      begin
        i := i + Multiplier;
        continue;
      end;
      if (PRGeneric(List[i]).Key3 > Key3) then
      begin
        i := i - Multiplier;
        continue;
      end;
    end;

    if NumberOfKeys > 3 then
    begin

      if (PRGeneric(List[i]).Key4 < Key4) then
      begin
        i := i + Multiplier;
        continue;
      end;
      if (PRGeneric(List[i]).Key4 > Key4) then
      begin
        i := i - Multiplier;
        continue;
      end;
    end;

    if NumberOfKeys > 4 then
    begin

      if (PRGeneric(List[i]).Key5 < Key5) then
      begin
        i := i + Multiplier;
        continue;
      end;
      if (PRGeneric(List[i]).Key5 > Key5) then
      begin
        i := i - Multiplier;
        continue;
      end;
    end;

    if NumberOfKeys > 5 then
    begin

      if (PRGeneric(List[i]).Key6 < Key6) then
      begin
        i := i + Multiplier;
        continue;
      end;
      if (PRGeneric(List[i]).Key6 > Key6) then
      begin
        i := i - Multiplier;
        continue;
      end;
    end;

    Result := PRGeneric(List[i]);
    break;

  end;

end;

//------------------------------------------------------

function FindTNA_BinarSearch(List : TList; Entity : String) : PT_TNA;
var
  i: integer;
  Multiplier, NumberOfEntries : integer;
begin

  Result := nil;

  NumberOfEntries := List.Count;
  if NumberOfEntries = 0 then exit;

  Multiplier := 1;
  while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    i := Multiplier - 1;

  while (Multiplier > 0) do
  begin

    if (i < NumberOfEntries)
    and (PT_TNA(List[i]).ABSUniqueId = Entity) then break;

    Multiplier := trunc(Multiplier / 2);

    if  (i < NumberOfEntries)
    and (PT_TNA(List[i]).ABSUniqueId < Entity) then
      i := i + Multiplier
    else
      i := i - Multiplier;

  end;

  if Multiplier > 0 then Result := PT_TNA(List[i]);
end;

//------------------------------------------------------

function searchInList(listToSearch: TList; flag: integer; valueToSearch: String;
                      minIndex: integer; maxIndex: integer): integer;
var
  CUR_WORKCENTER: PWORKCENTERS;
  CUR_PROCESS: PPROCESSES;
  CUR_PROPERTY: PPROPERTIES;
  CUR_OPERATTRIBUTE: POPERATTRIBUTES;
  CUR_PRODUCTIONTIMESLEVEL: PPRODUCTIONTIMESLEVELS;
  CUR_PRODUCTIONTIME: PPRODUCTIONTIMES;
  CUR_ADDITIONALDATA_HEADER: PADDITIONALDATA_HEADERS;
  CUR_ADDITIONALDATA_DETAIL: PADDITIONALDATA_DETAILS;
  CUR_ITEMTYPE: PITEMTYPES;
  CUR_ROUTING_STEP_TIME_TYPE: PROUTING_STEP_TIME_TYPES;
//  CUR_NOTE_HEADER: PNOTE_HEADERS;
  CUR_PRODUCT: PPRODUCTS;
  CUR_OPERATION: POPERATIONS;
  CUR_ARTICLE_TYPE: PARTICLE_TYPES;
  CUR_SALESORDER: PSALESORDERS;
  CUR_PURCHASEORDER: PPURCHASEORDERS;
  CUR_LOGICALWAREHOUSE: PLOGICALWAREHOUSES;
  CUR_PRODUCT_UOM_CONVERSION: PPRODUCT_UOM_CONVERSIONS;
  CUR_STD_UNIT_CATEGORY_CONVERSION: PSTD_UNIT_CATEGORY_CONVERSIONS;
  CUR_MEASURE_CONVERSION: PMEASURE_CONVERSIONS;
  CUR_PRODUCTIONDEMANDTEMPLATE: PPRODUCTIONDEMANDTEMPLATES;
  CUR_PRODUCTIONPROGRESSTEMPLATE: PPRODUCTIONPROGRESSTEMPLATES;
  CUR_STEP_ID_PRODUCTIONDEMANDSANDORDERS: PSTEP_ID_PRODUCTIONDEMANDSANDORDERS;
  CUR_STEP_ID_WORKCENTER: PSTEP_ID_WORKCENTERS;
  CUR_STEP_ID_WORKCENTERDATA: PSTEP_ID_WORKCENTERDATAS;
  CUR_HANDLED_PRODUCTION_DEMAND: PHANDLED_PRODUCTION_DEMANDS;
  CUR_HANDLED_PRODUCTION_ORDER: PHANDLED_PRODUCTION_ORDERS;
  CUR_STEP_ID_STEP: PSTEP_ID_STEPS;
  CUR_PROG_MACHINE: PPROG_MACHINES;
  CUR_PROG_DEMANDANDORDER: PPROG_DEMANDANDORDERS;
  CUR_PROD_STEP: PTMQMPD;
  CUR_ITEMTYPETEMPLATE: PITEMTYPETEMPLATES;
  CUR_ITEMTYPEPRODUCTIONDEMANDTEMPLATE: PITEMTYPEPRODUCTIONDEMANDTEMPLATES;
  CUR_PRODUCTIONDEMANDCOUNTER: PPRODUCTIONDEMANDCOUNTERS;
  CUR_ALT_WAREHOUSE_WKC: PALT_WAREHOUSE_WKCS;
  CUR_ALT_WAREHOUSE_WKC_GROUP: PALT_WAREHOUSE_WKC_GROUPS;
  CUR_ALT_WAREHOUSE_WKC_GROUP_ITEM_TYPE: PALT_WAREHOUSE_WKC_GROUP_ITEM_TYPES;
  CUR_ITEMTYPELOGICALWAREHOUSE_ITEMTYPE: PITEMTYPELOGICALWAREHOUSE_ITEMTYPES;
  CUR_ITEMTYPELOGICALWAREHOUSE: PITEMTYPELOGICALWAREHOUSES;
  CUR_PROP: PPROPS;
  CUR_PROP_RTV_VALUE: PPROP_RTV_VALUES;
  CurrItem : PTITEMS;
  searchIndex: integer;
  valueToCheck: String;
  trimmedSearch: String;
  intSearch: Int64;
  intCheck: Int64;
begin
  //NEWWORKCENTER                          :  1
  //NEWPROCESS                             :  2
  //NEWPROPERTY                            :  3
  //NEWALTERNATIVE                         :  4
  //NEWOPERATTRIBUTE                       :  5
  //NEWPRODUCTIONTIMESLEVEL                :  6
  //NEWPRODUCTIONTIME                      :  7
  //NEWADDITIONALDATA_HEADER               :  8
  //NEWADDITIONALDATA_DETAIL               :  9
  //NEWITEMTYPE                            : 10
  //NEWROUTING_STEP_TIME_TYPE              : 11
  //NEWNOTE_HEADER                         : 12
  //NEWPRODUCT                             : 13
  //NEWOPERATION                           : 14
  //NEWARTICLE_TYPE                        : 15
  //NEWSALES_ORDER                         : 16
  //NEWPURCHASE_ORDER                      : 17
  //NEWLOGICALWAREHOUSE                    : 18
  //NEWPRODUCT_UOM_CONVERSION              : 19
  //NEWSTD_UNIT_CATEGORY_CONVERSION        : 20
  //NEWMEASURE_CONVERSION                  : 21
  //NEWPRODUCTIONDEMANDTEMPLATE            : 22
  //NEWPRODUCTIONPROGRESSTEMPLATE          : 23
  //NEW_STEP_ID_PRODUCTIONDEMANDSANDORDERS : 24
  //NEW_STEP_ID_WORKCENTER                 : 25
  //NEW_STEP_ID_OPERATION                  : 26
  //NEW_HANDLED_PRODUCTION_DEMAND          : 27
  //NEW_HANDLED_PRODUCTION_ORDER           : 28
  //NEW_STEP_ID_STEP                       : 29
  //NEW_PROG_MACHINE                       : 30
  //NEW_PROG_DEMANDANDORDER                : 31
  //NEW_PROD_STEP                          : 32,33
  //NEW_ITEMTYPETEMPLATE                   : 34
  //NEWITEMTYPEPRODUCTIONDEMANDTEMPLATE    : 35
  //NEWPRODUCTIONDEMANDCOUNTER             : 36
  //NEWALT_WAREHOUSE_WKC                   : 37
  //NEWALT_WAREHOUSE_WKC_GROUP             : 38
  //NEWALT_WAREHOUSE_WKC_GROUP_ITEM_TYPE   : 39
  //NEWITEMTYPELOGICALWAREHOUSE_ITEMTYPE   : 40
  //NEWITEMTYPELOGICALWAREHOUSE            : 41
  //NEWPROP                                : 42
  //NEWPROP_RTV_VALUE                      : 43

  Result := -1;

  trimmedSearch := Trim(valueToSearch);
  if (flag = 8) or (flag = 44) then
  begin
    if trimmedSearch = '' then Exit;
    intSearch := StrToInt64(trimmedSearch);
  end;

  while True do
  begin

    if ( maxIndex < minIndex ) then break;

    searchIndex := (minIndex + maxIndex) div 2;

    case flag of
      1:
      begin
        CUR_WORKCENTER := listToSearch.Items[searchIndex];
        valueToCheck := CUR_WORKCENTER.WC_WKCNTER;
      end;
      2:
      begin
        CUR_PROCESS := listToSearch.Items[searchIndex];
        valueToCheck := CUR_PROCESS.WP_WKCT_PROC;
      end;
      3:
      begin
        CUR_PROPERTY := listToSearch.Items[searchIndex];
        valueToCheck := CUR_PROPERTY.RP_PROPERTY;
      end;
//        4:
//        begin
//          CUR_ALTERNATIVE := listToSearch.Items[searchIndex];
//          valueToCheck := CUR_ALTERNATIVE.AW_ALTERN_WC;
//        end;
      5:
      begin
        CUR_OPERATTRIBUTE := listToSearch.Items[searchIndex];
        valueToCheck := CUR_OPERATTRIBUTE.CODE;
      end;
      6:
      begin
        CUR_PRODUCTIONTIMESLEVEL := listToSearch.Items[searchIndex];
        valueToCheck := CUR_PRODUCTIONTIMESLEVEL.PRODUCT_TYPE;
      end;
      7:
      begin
        CUR_PRODUCTIONTIME := listToSearch.Items[searchIndex];
        valueToCheck := CUR_PRODUCTIONTIME.TABLENAME1_COLUMNNAME1_VALUE;
      end;
      8:
      begin
        CUR_ADDITIONALDATA_HEADER := listToSearch.Items[searchIndex];
      end;
      9:
      begin
        CUR_ADDITIONALDATA_DETAIL := listToSearch.Items[searchIndex];
        valueToCheck := CUR_ADDITIONALDATA_DETAIL.FIELDNAME;
      end;
      10:
      begin
        CUR_ITEMTYPE := listToSearch.Items[searchIndex];
        valueToCheck := CUR_ITEMTYPE.CODE;
      end;
      11:
      begin
        CUR_ROUTING_STEP_TIME_TYPE := listToSearch.Items[searchIndex];
        valueToCheck := CUR_ROUTING_STEP_TIME_TYPE.RSTT_CODE;
      end;
      12:
      begin
        //CUR_NOTE_HEADER := listToSearch.Items[searchIndex];
        //valueToCheck := CUR_NOTE_HEADER.FATHERID;
      end;
      13:
      begin
        CUR_PRODUCT := listToSearch.Items[searchIndex];
        valueToCheck := CUR_PRODUCT.PRODUCT_KEY;
      end;
      14:
      begin
        CUR_OPERATION := listToSearch.Items[searchIndex];
        valueToCheck := CUR_OPERATION.CODE;
      end;
      15:
      begin
        CUR_ARTICLE_TYPE := listToSearch.Items[searchIndex];
        valueToCheck := CUR_ARTICLE_TYPE.AT_ART_TYPE;
      end;
      16:
      begin
        CUR_SALESORDER := listToSearch.Items[searchIndex];
        valueToCheck := CUR_SALESORDER.CODE;
      end;
      17:
      begin
        CUR_PURCHASEORDER := listToSearch.Items[searchIndex];
        valueToCheck := CUR_PURCHASEORDER.CODE;
      end;
      18:
      begin
        CUR_LOGICALWAREHOUSE := listToSearch.Items[searchIndex];
        valueToCheck := CUR_LOGICALWAREHOUSE.CODE;
      end;
      19:
      begin
        CUR_PRODUCT_UOM_CONVERSION := listToSearch.Items[searchIndex];
        valueToCheck := CUR_PRODUCT_UOM_CONVERSION.PRODUCT_CODE;
      end;
      20:
      begin
        CUR_STD_UNIT_CATEGORY_CONVERSION := listToSearch.Items[searchIndex];
        valueToCheck := CUR_STD_UNIT_CATEGORY_CONVERSION.STANDART_UNIT_CATEGORY_TYPE;
      end;
      21:
      begin
        CUR_MEASURE_CONVERSION := listToSearch.Items[searchIndex];
        valueToCheck := CUR_MEASURE_CONVERSION.UNITOFMEASURECODE;
      end;
      22:
      begin
        CUR_PRODUCTIONDEMANDTEMPLATE := listToSearch.Items[searchIndex];
        valueToCheck := CUR_PRODUCTIONDEMANDTEMPLATE.CODE;
      end;
      23:
      begin
        CUR_PRODUCTIONPROGRESSTEMPLATE := listToSearch.Items[searchIndex];
        valueToCheck := CUR_PRODUCTIONPROGRESSTEMPLATE.CODE;
      end;
      24:
      begin
        CUR_STEP_ID_PRODUCTIONDEMANDSANDORDERS := listToSearch.Items[searchIndex];
        valueToCheck := CUR_STEP_ID_PRODUCTIONDEMANDSANDORDERS.Code;
      end;
      25:
      begin
        CUR_STEP_ID_WORKCENTER := listToSearch.Items[searchIndex];
        valueToCheck := CUR_STEP_ID_WORKCENTER.workCenterCode;
      end;
      26:
      begin
        CUR_STEP_ID_WORKCENTERDATA := listToSearch.Items[searchIndex];
        valueToCheck := CUR_STEP_ID_WORKCENTERDATA.operationCode;
      end;
      27:
      begin
        CUR_HANDLED_PRODUCTION_DEMAND := listToSearch.Items[searchIndex];
        valueToCheck := CUR_HANDLED_PRODUCTION_DEMAND.Code;
      end;
      28:
      begin
        CUR_HANDLED_PRODUCTION_ORDER := listToSearch.Items[searchIndex];
        valueToCheck := CUR_HANDLED_PRODUCTION_ORDER.Code;
      end;
      29:
      begin
        CUR_STEP_ID_STEP := listToSearch.Items[searchIndex];
        valueToCheck := CUR_STEP_ID_STEP.stepNumber;
      end;
      30:
      begin
        CUR_PROG_MACHINE := listToSearch.Items[searchIndex];
        valueToCheck := CUR_PROG_MACHINE.MachineCode;
      end;
      31:
      begin
        CUR_PROG_DEMANDANDORDER := listToSearch.Items[searchIndex];
        valueToCheck := Trim(CUR_PROG_DEMANDANDORDER.demandAndOrderCode);
      end;
      32:
      begin
        CUR_PROD_STEP := listToSearch.Items[searchIndex];
        valueToCheck := Trim(CUR_PROD_STEP.PD_PREQ_NO);
      end;
      33:
      begin
        CUR_PROD_STEP := listToSearch.Items[searchIndex];
        valueToCheck := Trim(CUR_PROD_STEP.PD_PREQ_NO) + IntToStr(CUR_PROD_STEP.PD_PSTEP_ID);
      end;
      34:
      begin
        CUR_ITEMTYPETEMPLATE := listToSearch.Items[searchIndex];
        valueToCheck := Trim(CUR_ITEMTYPETEMPLATE.ITEMTYPECODE);
      end;
      35:
      begin
        CUR_ITEMTYPEPRODUCTIONDEMANDTEMPLATE := listToSearch.Items[searchIndex];
        valueToCheck := Trim(CUR_ITEMTYPEPRODUCTIONDEMANDTEMPLATE.PRODUCTIONDEMANDTEMPLATECODE);
      end;
      36:
      begin
        CUR_PRODUCTIONDEMANDCOUNTER := listToSearch.Items[searchIndex];
        valueToCheck := Trim(CUR_PRODUCTIONDEMANDCOUNTER.CODE);
      end;
      37:
      begin
        CUR_ALT_WAREHOUSE_WKC := listToSearch.Items[searchIndex];
        valueToCheck := Trim(CUR_ALT_WAREHOUSE_WKC.WORKCENTER);
      end;
      38:
      begin
        CUR_ALT_WAREHOUSE_WKC_GROUP := listToSearch.Items[searchIndex];
        valueToCheck := Trim(CUR_ALT_WAREHOUSE_WKC_GROUP.NET_GROUP);
      end;
      39:
      begin
        CUR_ALT_WAREHOUSE_WKC_GROUP_ITEM_TYPE := listToSearch.Items[searchIndex];
        valueToCheck := Trim(CUR_ALT_WAREHOUSE_WKC_GROUP_ITEM_TYPE.ITEM_TYPE);
      end;
      40:
      begin
        CUR_ITEMTYPELOGICALWAREHOUSE_ITEMTYPE := listToSearch.Items[searchIndex];
        valueToCheck := Trim(CUR_ITEMTYPELOGICALWAREHOUSE_ITEMTYPE.ITEMTYPECODE);
      end;
      41:
      begin
        CUR_ITEMTYPELOGICALWAREHOUSE := listToSearch.Items[searchIndex];
        valueToCheck := Trim(CUR_ITEMTYPELOGICALWAREHOUSE.LOGICALWAREHOUSECODE);
      end;
      42:
      begin
        CUR_PROP := listToSearch.Items[searchIndex];
        valueToCheck := Trim(CUR_PROP.PY_PROPERTY);
      end;
      43:
      begin
        CUR_PROP_RTV_VALUE := listToSearch.Items[searchIndex];
        valueToCheck := Trim(CUR_PROP_RTV_VALUE.ITEMTYPE);
      end;
      44:
      begin
        CurrItem := listToSearch.Items[searchIndex];
      end;
      45:
      begin
      //  ProductNeededForReservation := listToSearch.Items[searchIndex];
      //  valueToCheck := ProductNeededForReservation.ABSUNIQUEID;
      end;
    end;

    if (flag = 8) or (flag = 44) then
    begin
      if flag = 44 then
        intCheck := CurrItem.ABSUNIQUEIDINT
      else
        intCheck := CUR_ADDITIONALDATA_HEADER.ABSUNIQUEIDINT;
      if intCheck > intSearch then
      begin
        maxIndex := searchIndex - 1;
        continue;
      end;
      if intCheck < intSearch then
      begin
        minIndex := searchIndex + 1;
        continue;
      end;
      Result := searchIndex;
      break;
    end;

    if flag = 22 then
    begin
      if (TRIM(valueToCheck) > valueToSearch) then
      begin
        maxIndex := searchIndex - 1;
        continue;
      end;
      if (TRIM(valueToCheck) < valueToSearch) then
      begin
        minIndex := searchIndex + 1;
        continue;
      end;
      Result := searchIndex;
      break;
    end;

    if ( valueToCheck > trimmedSearch ) then
    begin
      maxIndex := searchIndex - 1;
      continue;
    end;
    if ( valueToCheck < trimmedSearch ) then
    begin
      minIndex := searchIndex + 1;
      continue;
    end;
    Result := searchIndex;
    break;

  end;
end;

//----------------------------------------------------------------------------//

function searchInListLinear(listToSearch: TList; flag: integer; valueToSearch: String): integer;
var
  CUR_STEP_ID_WORKCENTER: PSTEP_ID_WORKCENTERS;
  CUR_STEP_ID_WORKCENTERDATA: PSTEP_ID_WORKCENTERDATAS;
  CUR_STEP_ID_OPERATION: PSTEP_ID_OPERATIONS;
  CUR_STEP_ID_OPERATIONDATA: PSTEP_ID_OPERATIONDATAS;
  CUR_STEP_ID_PRODUCTIONORDER: PSTEP_ID_PRODUCTIONDEMANDSANDORDERS;

  CUR_PRODUCTION_ORDER_GRP_NO: PPRODUCTION_ORDER_GRP_NOS;

  searchIndex: integer;
  valueToCheck: String;
begin

  //NEW_STEP_ID_WORKCENTER                 : 1
  //NEW_STEP_ID_WORKCENTERDATA             : 2
  //NEW_STEP_ID_OPERATION                  : 3
  //NEW_STEP_ID_OPERATIONDATA              : 4
  //NEW_STEP_ID_PRODUCTIONORDER            : 5
  //NEW_PRODUCTION_ORDER_GRP_NO            : 6

  result := -1;

  for searchIndex := 0 to listToSearch.Count - 1 do
  begin
    case flag of
      1:
      begin
        CUR_STEP_ID_WORKCENTER := listToSearch.Items[searchIndex];
        valueToCheck := CUR_STEP_ID_WORKCENTER.workCenterCode;
      end;
      2:
      begin
        CUR_STEP_ID_WORKCENTERDATA := listToSearch.Items[searchIndex];
        valueToCheck := CUR_STEP_ID_WORKCENTERDATA.operationCode;
      end;
      3:
      begin
        CUR_STEP_ID_OPERATION := listToSearch.Items[searchIndex];
        valueToCheck := CUR_STEP_ID_OPERATION.operationCode;
      end;
      4:
      begin
        CUR_STEP_ID_OPERATIONDATA := listToSearch.Items[searchIndex];
        valueToCheck := CUR_STEP_ID_OPERATIONDATA.workCenterCode;
      end;
      5:
      begin
        CUR_STEP_ID_PRODUCTIONORDER := listToSearch.Items[searchIndex];
        valueToCheck := CUR_STEP_ID_PRODUCTIONORDER.Code;
      end;
      6:
      begin
        CUR_PRODUCTION_ORDER_GRP_NO := listToSearch.Items[searchIndex];
        valueToCheck := CUR_PRODUCTION_ORDER_GRP_NO.productionOrderCodeGrpStep;
      end;
    end;

    if valueToCheck = valueToSearch then
    begin
      result := searchIndex;
      break;
    end;
  end;

end;

//----------------------------------------------------------------------------//

function PrepareTNA_code_list(var TNA_List : TStringList) : string;
var  i: integer;
  str: String;
begin
  str := '';

  for i := 0 to TNA_List.Count - 1 do
  begin

    if (trim(TNA_List[i]) <> '') and (I > 0) then
      str := str + ', ';
    str := str + QuotedStr(TNA_List[i]);
  end;

  result := str;
end;

//----------------------------------------------------------------------------//

function PrepareHandledProductionDemandTemplate(var productionDemandTemplates : TList) : string;
var
  PRODUCTIONDEMANDTEMPLATE: PPRODUCTIONDEMANDTEMPLATES;
  i: integer;
  str: String;
begin
  str := '';
  for i := 0 to productionDemandTemplates.Count - 1 do
  begin
    PRODUCTIONDEMANDTEMPLATE := PPRODUCTIONDEMANDTEMPLATES(productionDemandTemplates.Items[i]);
    if trim(str) <> '' then
      str := str + ', ';
    str := str + QuotedStr(PRODUCTIONDEMANDTEMPLATE.CODE);
  end;

  result := str;
end;

//----------------------------------------------------------------------------//

function PrepareHandledWorkcenterTemplate(var handledWorkCentersList : TList) : string;
var
  NEWWORKCENTER: PWORKCENTERS;
  i: integer;
  str: String;
begin
  str := '';
  for i := 0 to handledWorkCentersList.Count - 1 do
  begin
    NEWWORKCENTER := PWORKCENTERS(handledWorkCentersList.Items[i]);
    if trim(str) <> '' then
      str := str + ', ';
    str := str + QuotedStr(NEWWORKCENTER.WC_WKCNTER);
  end;

  result := str;
end;

//----------------------------------------------------------------------------//

procedure PrepareProductionOrderStepQtyPercent(ProductionOrderStepStruct : Tlist);
var
  I, J, ProductionOrderStepStart : integer;
  OrderStepStruct : PTProductionOrderStepStruct;
  TotalQty, Percent, TotalSetUp, TotalExecution : double;
  PrevProductionOrder, PrevProductionOrderStep : String;
  FirstProductionOrder : boolean;
  LineNumber : Integer;
//  LogInfo : TStringList;
begin
  ProductionOrderStepStart := -1;
  TotalQty := 0;
  TotalSetUp := 0;
  TotalExecution := 0;
//  LogInfo := TStringList.Create;
//  LogInfo.add('Prepare Production Order Step Qty Percent Start time : ' + DateTimeToStr(Now));
  UpdateOperation(_('Prepare Production Order Step Qty Percent ...'));

  FirstProductionOrder := true;
  LineNumber := 1;

  for I := 0 to ProductionOrderStepStruct.Count - 1 do
  begin
    OrderStepStruct := PTProductionOrderStepStruct(ProductionOrderStepStruct[I]);
    if OrderStepStruct.ProductionOrder = '' then continue;

    if FirstProductionOrder then
    begin
      FirstProductionOrder := false;
      PrevProductionOrder :=PTProductionOrderStepStruct(ProductionOrderStepStruct[I]).ProductionOrder;
      PrevProductionOrderStep :=PTProductionOrderStepStruct(ProductionOrderStepStruct[I]).GroupStepNumber;
      ProductionOrderStepStart := I;
      TotalQty := StrToFloat(OrderStepStruct.FinalBasePrimaryQuantity);
      TotalSetUp := StrToFloat(OrderStepStruct.SetUp);
      TotalExecution := StrToFloat(OrderStepStruct.Execution);
      OrderStepStruct.LineNumber := LineNumber;
      continue;
    end;

    if (OrderStepStruct.ProductionOrder = PrevProductionOrder) then
      LineNumber := LineNumber + 1
    else
      LineNumber := 1;
    OrderStepStruct.LineNumber := LineNumber;

    if (OrderStepStruct.ProductionOrder = PrevProductionOrder)
    and (OrderStepStruct.GroupStepNumber = PrevProductionOrderStep) then
    begin
      TotalQty := TotalQty + StrToFloat(OrderStepStruct.FinalBasePrimaryQuantity);
      TotalSetUp := TotalSetUp + StrToFloat(OrderStepStruct.SetUp);
      TotalExecution := TotalExecution + StrToFloat(OrderStepStruct.Execution);
      Continue;
    end;

    for J := ProductionOrderStepStart to I - 1 do
    begin
      Percent := 0;
      if TotalQty > 0 then
         Percent := StrToFloat(PTProductionOrderStepStruct(ProductionOrderStepStruct[J]).FinalBasePrimaryQuantity)/TotalQty;
      PTProductionOrderStepStruct(ProductionOrderStepStruct[J]).Percent := Percent;
      PTProductionOrderStepStruct(ProductionOrderStepStruct[J]).TotalSetUp := TotalSetUp;
      PTProductionOrderStepStruct(ProductionOrderStepStruct[J]).TotalExecution := TotalExecution;
    end;

    PrevProductionOrder :=PTProductionOrderStepStruct(ProductionOrderStepStruct[I]).ProductionOrder;
    PrevProductionOrderStep :=PTProductionOrderStepStruct(ProductionOrderStepStruct[I]).GroupStepNumber;
    ProductionOrderStepStart := I;
    TotalQty := StrToFloat(PTProductionOrderStepStruct(ProductionOrderStepStruct[I]).FinalBasePrimaryQuantity);
    TotalSetUp := StrToFloat(PTProductionOrderStepStruct(ProductionOrderStepStruct[I]).SetUp);
    TotalExecution := StrToFloat(PTProductionOrderStepStruct(ProductionOrderStepStruct[I]).Execution);
  end;

  if FirstProductionOrder then exit;

  for J := ProductionOrderStepStart to ProductionOrderStepStruct.Count - 1 do
  begin
    Percent := 0;
    if TotalQty > 0 then
      Percent := StrToFloat(PTProductionOrderStepStruct(ProductionOrderStepStruct[J]).FinalBasePrimaryQuantity)/TotalQty;
    PTProductionOrderStepStruct(ProductionOrderStepStruct[J]).Percent := Percent;
    PTProductionOrderStepStruct(ProductionOrderStepStruct[J]).TotalSetUp := TotalSetUp;
    PTProductionOrderStepStruct(ProductionOrderStepStruct[J]).TotalExecution := TotalExecution;
  end;
//  LogInfo.add('Prepare Production Order Step Qty Percent End time : ' + DateTimeToStr(Now));
//  LogInfo.SaveToFile(LocAppGlobals.AppDir + '\PrepareProductionOrderStep.txt' );
end;

//----------------------------------------------------------------------------//

procedure Build_AD_SelectedColums(var AD_Product_SelectColums : string; var AD_FullItemKeyDecoder_SelectColums : string;
  var AD_ProductionDemand_SelectColums : string; var AD_ProductionDemandStep_SelectColums : string;
  var AD_Product_FieldsList : TStringlist; var AD_FullItemKeyDecoder_FieldsList : TStringlist;
  var AD_ProductionDemand_FieldsList : TStringlist; var AD_ProductionDemandStep_FieldsList : TStringList);
var
  I : integer;
begin
  AD_Product_SelectColums := '';
  AD_FullItemKeyDecoder_SelectColums := '';
  AD_ProductionDemand_SelectColums := '';
  AD_ProductionDemandStep_SelectColums := '';

  for I  := 0 to AD_Product_FieldsList.Count - 1 do
  begin
    if AD_Product_SelectColums <> '' then
      AD_Product_SelectColums := AD_Product_SelectColums + ', ';
    AD_Product_SelectColums := AD_Product_SelectColums + QuotedStr(AD_Product_FieldsList.Strings[I]);
  end;
  if AD_Product_SelectColums = '' then
     AD_Product_SelectColums := QuotedStr(AD_Product_SelectColums);

  for I  := 0 to AD_FullItemKeyDecoder_FieldsList.Count - 1 do
  begin
    if AD_FullItemKeyDecoder_SelectColums <> '' then
      AD_FullItemKeyDecoder_SelectColums := AD_FullItemKeyDecoder_SelectColums + ', ';
    AD_FullItemKeyDecoder_SelectColums := AD_FullItemKeyDecoder_SelectColums + QuotedStr(AD_FullItemKeyDecoder_FieldsList.Strings[I]);
  end;
  if AD_FullItemKeyDecoder_SelectColums = '' then
    AD_FullItemKeyDecoder_SelectColums := QuotedStr(AD_FullItemKeyDecoder_SelectColums);

  if AD_ProductionDemand_FieldsList.IndexOf('NewDemandUniqueId') = -1 then
    AD_ProductionDemand_FieldsList.add('NewDemandUniqueId');

  for I  := 0 to AD_ProductionDemand_FieldsList.Count - 1 do
  begin
    if AD_ProductionDemand_SelectColums <> '' then
      AD_ProductionDemand_SelectColums := AD_ProductionDemand_SelectColums + ', ';
    AD_ProductionDemand_SelectColums := AD_ProductionDemand_SelectColums + QuotedStr(AD_ProductionDemand_FieldsList.Strings[I]);
  end;
  if AD_ProductionDemand_SelectColums = '' then
    AD_ProductionDemand_SelectColums := QuotedStr(AD_ProductionDemand_SelectColums);

  for I  := 0 to AD_ProductionDemandStep_FieldsList.Count - 1 do
  begin
    if AD_ProductionDemandStep_SelectColums <> '' then
      AD_ProductionDemandStep_SelectColums := AD_ProductionDemandStep_SelectColums + ', ';
    AD_ProductionDemandStep_SelectColums := AD_ProductionDemandStep_SelectColums + QuotedStr(AD_ProductionDemandStep_FieldsList.Strings[I]);
  end;
  if AD_ProductionDemandStep_SelectColums = '' then
     AD_ProductionDemandStep_SelectColums := QuotedStr(AD_ProductionDemandStep_SelectColums);
end;

//----------------------------------------------------------------------------//

function FillProdListsStructure(LocalQry: TMqmQuery; HostQry : TMqmQuery; ArcQry :  TMqmQuery): boolean;
var                                      // tbProdReq:   ^TTblInfo;
  //Items : PTITEMS;
  Steps, Recipes, Designs : TStringList;
//  toolsForReservation : PTtoolsForReservation;
  ItemTypeCompanyInUsed, ToolsCompanyInUsed, FIKDCompanyInUsed : string;
  hostSqlStr:  String;
  prodReqNo:   String;
  lastCounterCode: String;
  lastCode:        String;
//  lastProductionDemandTemplate: String;
//  lastStepNumber: String;

  productionDemandTemplates: TList;

  productionReservationStringList : TStringList;

  propertyList: TList;
  resList : TList;
  routingStepTimeTypeList : TList;

  currentProductsList: TList;

  productionReservationList : TList;
  ReservationLines : TList;
  operationList : TList;
  articleTypeList : TList;
  productsList : TList;
  salesOrderList: TList;
  purchaseOrderList: TList;

  addedKeysToProduction: TStringList;
  addedKeysFromProduction: TStringList;

  dummyVar, DamiStr : String;

  handledWorkCentersList: TList;
  unhandledWorkCentersList: TList;
  additionalDataList: TList;
  UserGenericGroupTypeList, UserGenericGroupTypeAttributesList : TList;
  ColorTypeList, ColorTypeUNIQUEIDList : TList;

  firstSentenceColumnNames: String;
  secondSentenceColumnNames: String;

  HostQryForVAA: TMqmQuery;

  STOCKTYPECODES : string;

  logicalWarehouseList: TList;
  alreadyAddedPROD_REQCONN: TStringList;


{  read_prod_req_list: TList;
  read_prod_reqhdr_list: TList;
  read_prod_step_list: TList;
  read_prod_step_time_list: TList;
  read_prop_prod_list: TList;
  read_prod_step_batch_size_list: TList;
  read_prod_info_list: TList;
  read_prod_reqConn_list: TList;
  read_ext_connection_list: TList;
  read_ext_info_hdr_list: TList;
  read_ext_info_list: TList;
  read_balance_header_list: TList;
  read_produced_article_list: TList;
  read_material_list: TList; }

  prod_req_list: TStringList;

  stepIdListForProgressList_PD: TList;
  stepIdListForProgressList_PO: TList;
  stepIdListForProgressList_PO_SL: TStringList;
  productionProgressTemplates: TList;

  itemTypeTemplates: TList;
  productionDemandCounters: TList;

  additionalDataWithRelationList: TList;

  alternativeWarehouseList: TList;
  itemTypeLogicalWarehouseList: TList;
  OperAttributesList : TList;

  needToHandleMergeOperation, NETGROUP_IS_LOT_Handaled, AtLeast_1_Wc_HandledWarp : boolean;

  standardWeightUnit: String;

  balanceHandledItemTypeCodes: String;

  ALT_WAREHOUSE_WKCS : PALT_WAREHOUSE_WKCS;
  ALT_WAREHOUSE_WKC_GROUPS : PALT_WAREHOUSE_WKC_GROUPS;
  ALT_WAREHOUSE_WKC_GROUP_ITEM_TYPE: PALT_WAREHOUSE_WKC_GROUP_ITEM_TYPES;
  ALT_WAREHOUSE: PALT_WAREHOUSES;
  STEP_ID_OPERATIONS : PSTEP_ID_OPERATIONS;
  STEP_ID_OPERATIONDATA : PSTEP_ID_OPERATIONDATAS;
  STEP_ID_WORKCENTERS : PSTEP_ID_WORKCENTERS;

  TEMTYPELOGICALWAREHOUSE_ITEMTYPES : PITEMTYPELOGICALWAREHOUSE_ITEMTYPES;
  ITEMTYPELOGICALWAREHOUSE: PITEMTYPELOGICALWAREHOUSES;

  STEP_ID_PRODUCTIONDEMANDSANDORDERS : PSTEP_ID_PRODUCTIONDEMANDSANDORDERS;

  I, J, W, P, A, counter : integer;
  MQMProductionColumnValues: PMQMProductionColumnValues;
  HandledProductionDemandMqinSql, HandledWorkCenterSql, HandledWorkCenterAttribute, HandledUserGenericGroupTypesStr, HandledColorGroupTypesStr : string;
  AD_Product_SelectColums, AD_FullItemKeyDecoder_SelectColums ,
  AD_ProductionDemand_SelectColums,AD_ProductionDemandStep_SelectColums : string;
  AD_Product_FieldsList, AD_FullItemKeyDecoder_FieldsList , AD_Recipe_FieldsList, AD_design_FieldsList,
  AD_ProductionDemand_FieldsList,AD_ProductionDemandStep_FieldsList, TNA_List1, TNA_List2 : TStringList;
  DemandCount, index : Integer;
  CompanyInUsed_IT, CompanyInUsed_PD, CompanyInUsed_P, CompanyInUsed_FIKD,CompanyInUsed_RCP,CompanyInUsed_DSN,
  CompanyInUsed_PDS, CompanyInUsed_TOOL, CompanyInUsed_PRSV, CompanyInUsed_AvailabilityFormulaDetail : string;
  SqlPrint : TStringList;
  {ABSUNIQUEID,} ItemNature, ABSUNIQUEIDRCP, ABSUNIQUEIDDSN, PREQ_NO, StepNumber : string;
//  LogReq : TStringList;
  ISSUEDATE, TempIssueDate : TDate;
  ColumnNamesSql_Items : string;
  PGeneric : PRGeneric;
  WORKCENTERS : PWORKCENTERS;
  CUR_PROCESS : PPROCESSES;
  PROPERTIES  : PPROPERTIES;
  POPERATTRIBUTE: POPERATTRIBUTES;
  PPRODUCTIONTIMESLEVEL: PPRODUCTIONTIMESLEVELS;
  ADDITIONALDATA_HEADERS : PADDITIONALDATA_HEADERS;
  ADDITIONALDATA_DETAIL  : PADDITIONALDATA_DETAILS;
  PROP : PPROPS;
  FIKD_ABSUNIQUEID, PRSV_ITEMNATURE, PD_COUNTERCODE, PD_CODE, PDS_STEPNUMBER_TFIELD,
  PRSV_ISSUEDATE_TFIELD, RSV_FIKD_ABSUNIQUEID, PD_COMPANYCODE : TField;
  StartTimeBeforeOpenSql, StartTimeAfterOpenSql : TDateTime;
  WarpItemHandledStr : string;
  WarpItemHandledStrList : TStringList;
  Counters, CountersCount : TStringList;
  EndingIndex, NumberOfDemands, NumberOfDemandsBlock, BlockNumber : Integer;
  StartingCounterCode, EndingCounterCode, StartingDemandCode, EndingDemandCode : String;
  InsideCounter : boolean;
//  SqlPrint : TStringList;
  fldCounterCode, fldCnt: TField;
begin
//  LogReq := TStringList.Create;
  SqlPrint := TStringList.Create;
  Production_Order_Grp_No_list := TList.Create;
  DemandCount := 0;

  AD_Product_FieldsList := TStringList.Create;
  AD_Recipe_FieldsList := TStringList.Create;
  AD_design_FieldsList := TStringList.Create;

  AD_FullItemKeyDecoder_FieldsList := TStringList.Create;
  AD_ProductionDemand_FieldsList   := TStringList.Create;
  AD_ProductionDemandStep_FieldsList := TStringList.Create;
  TNA_List1 := TStringList.Create;
  TNA_List2 := TStringList.Create;

  ProductionOrderStepStructList := TList.Create;
  ProjectNumberList := TList.Create;
  productionDemandTemplates := TList.Create;
  m_Exist_INITIALPLANSCHEDDATETIME := false;
  m_Exist_FINALPLANSCHEDDATETIME   := false;
  m_Exist_INITIALPLANNEDSCHEDULEDDATE := false;
  m_Exist_FINALPLANNEDSCHEDULEDDATE := false;
  m_Exist_MQMSPLITREFERENCE := false;

  UpdateOperation(_('Check Table Columns'));
  IniAppGlobals.Time_for_CheckTableColumns := NOW;
  CheckTableColumns(ArcQry, m_Exist_INITIALPLANSCHEDDATETIME, m_Exist_FINALPLANSCHEDDATETIME, m_Exist_INITIALPLANNEDSCHEDULEDDATE, m_Exist_FINALPLANNEDSCHEDULEDDATE, m_Exist_MQMSPLITREFERENCE);
  IniAppGlobals.Time_for_CheckTableColumns := NOW - IniAppGlobals.Time_for_CheckTableColumns;

  IniAppGlobals.Time_for_fill_Production_Order_Grp_No_list := NOW;
  UpdateOperation(_('Fill demands group struct'));
  fill_Production_Order_Grp_No_list(Production_Order_Grp_No_list);
  IniAppGlobals.Time_for_fill_Production_Order_Grp_No_list := NOW - IniAppGlobals.Time_for_fill_Production_Order_Grp_No_list;

  //UpdateOperation(_('Create struct for production demand templates'));
  IniAppGlobals.Time_for_fillProductionDemandTemplateStruct := NOW;
  UpdateOperation(_('Create struct for production demand templates'));
  fillProductionDemandTemplateStruct(LocalQry, ArcQry, productionDemandTemplates,
     AD_Recipe_FieldsList, AD_Design_FieldsList,
     AD_Product_FieldsList, AD_FullItemKeyDecoder_FieldsList, AD_ProductionDemandStep_FieldsList,
     AD_ProductionDemand_FieldsList, TNA_List1, TNA_List2);
  IniAppGlobals.Time_for_fillProductionDemandTemplateStruct := NOW- IniAppGlobals.Time_for_fillProductionDemandTemplateStruct;

  IniAppGlobals.Time_for_PrepareHandledProductionDemandTemplate := NOW;
  HandledProductionDemandMqinSql := PrepareHandledProductionDemandTemplate(productionDemandTemplates);
  if HandledProductionDemandMqinSql = '' then
    HandledProductionDemandMqinSql := QuotedStr('&&&');
  IniAppGlobals.Time_for_PrepareHandledProductionDemandTemplate := NOW - IniAppGlobals.Time_for_PrepareHandledProductionDemandTemplate;

  var TNA_code_list1 := PrepareTNA_code_list(TNA_List1);
  var TNA_code_list2 := PrepareTNA_code_list(TNA_List2);

  IniAppGlobals.Time_For_BuildProductionDemandFile := NOW;
  var DelProg2WcStr: string;
  DelProg2WcStr := BuildProductionDemandFile(ArcQry, HostQry);
  IniAppGlobals.Time_For_BuildProductionDemandFile := NOW- IniAppGlobals.Time_For_BuildProductionDemandFile;

  var DelProgTask2: ITask := nil;
  if (IniAppGlobals.DownloadTo <> '2') and (DelProg2WcStr <> '') then
    DelProgTask2 := TTask.Run(procedure
    var
      connHost : TMqmDatabase;
      qryHost  : TMqmQuery;
    begin
      connHost := nil;
      try
        connHost := ThreadCloneHostConnection;
        qryHost := TMqmQuery.Create(nil);
        try
          qryHost.Connection := connHost;
          DeleteAllNotRelevantProgresses2begin(qryHost, DelProg2WcStr);
        finally
          qryHost.Free;
        end;
      except
      end;
      if Assigned(connHost) then connHost.Free;
    end);

  IniAppGlobals.Time_For_BuildSCHEDULESDOWNLOAD_WARP := NOW;
  BuildSCHEDULESDOWNLOAD_WARP_RESERVATION_FILE(ArcQry, HostQry);
  IniAppGlobals.Time_For_BuildSCHEDULESDOWNLOAD_WARP := NOW - IniAppGlobals.Time_For_BuildSCHEDULESDOWNLOAD_WARP;

  // Fill all ARTICLE_TYPE
  IniAppGlobals.Time_For_fillArticleTypeToList := NOW;
  UpdateOperation(_('Fill item type list'));
  articleTypeList := TList.Create;
  fillArticleTypeToList(ArcQry, articleTypeList);
  IniAppGlobals.Time_For_fillArticleTypeToList := NOW - IniAppGlobals.Time_For_fillArticleTypeToList;

  List_Generic := TList.Create;
  List_TNA := TList.Create;
  IniAppGlobals.Time_FillGeneric := NOW;
  Fill_Generic(ArcQry, HostQry, List_Generic, List_TNA, HandledProductionDemandMqinSql, TNA_code_list1, TNA_code_list2);
  List_TNA.sort(Sort_List_TNA_By_ABSUNIQUEID);
  IniAppGlobals.Time_FillGeneric := NOW - IniAppGlobals.Time_FillGeneric;
  UpdateOperation(_('Create struct for workcenters'));
  handledWorkCentersList := TList.Create;
  unhandledWorkCentersList := TList.Create;
  OperAttributesList := TList.Create;

  IniAppGlobals.Time_For_PrepareHandledWorkcenterTemplate := NOW;
  IniAppGlobals.Time_For_PrepareHandledAttributeWorkCenter := NOW;
  HandledWorkCenterAttribute := PrepareHandledAttributeWorkCenter(ArcQry);
  IniAppGlobals.Time_For_PrepareHandledAttributeWorkCenter := NOW - IniAppGlobals.Time_For_PrepareHandledAttributeWorkCenter;
  if HandledWorkCenterAttribute <> '' then
  begin
    IniAppGlobals.Time_For_LoadIntoWORKCENTERANDOPERATTRIBUTES := NOW;
    LoadIntoWORKCENTERANDOPERATTRIBUTES(OperAttributesList, HostQry, HandledWorkCenterAttribute);
    IniAppGlobals.Time_For_LoadIntoWORKCENTERANDOPERATTRIBUTES := NOW - IniAppGlobals.Time_For_LoadIntoWORKCENTERANDOPERATTRIBUTES;
  end;
  IniAppGlobals.Time_For_fillStructs := NOW;
  fillStructs(ArcQry, handledWorkCentersList, unhandledWorkCentersList, OperAttributesList, AtLeast_1_Wc_HandledWarp, AD_ProductionDemandStep_FieldsList, AD_Product_FieldsList, AD_ProductionDemand_FieldsList);
  IniAppGlobals.Time_For_fillStructs := NOW - IniAppGlobals.Time_For_fillStructs;
  HandledWorkCenterSql := PrepareHandledWorkcenterTemplate(handledWorkCentersList);
  IniAppGlobals.Time_For_PrepareHandledWorkcenterTemplate := NOW - IniAppGlobals.Time_For_PrepareHandledWorkcenterTemplate;
  if HandledWorkCenterSql = '' then
    HandledWorkCenterSql := QuotedStr('&&&');

  IniAppGlobals.Time_For_fillPropertyStruct := NOW;
  UpdateOperation(_('Create struct for properties'));
  propertyList := TList.Create;
  fillPropertyStruct(ArcQry, propertyList, handledWorkCentersList);
  IniAppGlobals.Time_For_fillPropertyStruct := NOW - IniAppGlobals.Time_For_fillPropertyStruct;

  IniAppGlobals.Time_for_makeRelevantOperationsForColumns := NOW;
  UpdateOperation(_('Create field names'));
  makeRelevantOperationsForColumns(ArcQry, firstSentenceColumnNames,
  secondSentenceColumnNames, AD_Product_FieldsList, AD_FullItemKeyDecoder_FieldsList,
  AD_ProductionDemandStep_FieldsList,AD_ProductionDemand_FieldsList);
  IniAppGlobals.Time_for_makeRelevantOperationsForColumns := NOW - IniAppGlobals.Time_for_makeRelevantOperationsForColumns;

  IniAppGlobals.Time_for_fillItemTypeLogicalWarehouseStruct := NOW;
  UpdateOperation(_('Create struct for item type logical warehouses'));
  itemTypeLogicalWarehouseList := TList.Create;
  fillItemTypeLogicalWarehouseStruct(ArcQry, itemTypeLogicalWarehouseList, NETGROUP_IS_LOT_Handaled,
  AD_Product_FieldsList, AD_FullItemKeyDecoder_FieldsList,
  AD_ProductionDemandStep_FieldsList,AD_ProductionDemand_FieldsList);
  IniAppGlobals.Time_for_fillItemTypeLogicalWarehouseStruct := NOW - IniAppGlobals.Time_for_fillItemTypeLogicalWarehouseStruct;

  IniAppGlobals.Time_For_Build_AD_SelectedColums := NOW;
  Build_AD_SelectedColums(AD_Product_SelectColums ,AD_FullItemKeyDecoder_SelectColums,
        AD_ProductionDemand_SelectColums, AD_ProductionDemandStep_SelectColums,
        AD_Product_FieldsList , AD_FullItemKeyDecoder_FieldsList ,
        AD_ProductionDemand_FieldsList ,AD_ProductionDemandStep_FieldsList);
  IniAppGlobals.Time_For_Build_AD_SelectedColums := NOW - IniAppGlobals.Time_For_Build_AD_SelectedColums;

  IniAppGlobals.Time_For_fillUserGenericGroupType := NOW;
  UpdateOperation(_('Create struct for User Generic Group'));
  UserGenericGroupTypeList := TList.Create;
  fillUserGenericGroupType(HostQry, UserGenericGroupTypeList);
  IniAppGlobals.Time_For_fillUserGenericGroupType := NOW - IniAppGlobals.Time_For_fillUserGenericGroupType;

  IniAppGlobals.Time_For_fillColorType := NOW;
  UpdateOperation(_('Create struct for Color'));
  ColorTypeList := TList.Create;
  fillColorType(HostQry, ColorTypeList);
  IniAppGlobals.Time_For_fillColorType := NOW - IniAppGlobals.Time_For_fillColorType;

  IniAppGlobals.Time_For_fillItemTypesList := NOW;
  UpdateOperation(_('Create struct for item types'));
  itemTypesList := TList.Create;
  fillItemTypesList(HostQry, IniAppGlobals.CompanyCode,
                    itemTypesList);

  IniAppGlobals.Time_For_fillItemTypesList := NOW - IniAppGlobals.Time_For_fillItemTypesList;

  read_Material_Schedule_list := TList.Create;
  read_Material_Schedule_list_Link := TList.Create;

  WarpItemHandledStrList := TStringList.Create;
  WarpItemHandledStrList.Sorted := true;

  // Fill all LOGICALWAREHOUSE from host
  IniAppGlobals.Time_for_fillLogicalWarehousesToList := NOW;
  UpdateOperation(_('Fill warehouse list'));
  logicalWarehouseList := TList.Create;
  fillLogicalWarehousesToList(ArcQry, HostQry, logicalWarehouseList);
  IniAppGlobals.Time_for_fillLogicalWarehousesToList := NOW - IniAppGlobals.Time_for_fillLogicalWarehousesToList;

  if AtLeast_1_Wc_HandledWarp then
  begin
    UpdateOperation(_('Downloading data for Material schedule'));
    IniAppGlobals.Time_For_Fill_MATERIAL_DETAIL_SCHEDULE := NOW;
    Fill_MATERIAL_DETAIL_SCHEDULE(HostQry, LocalQry, HandledProductionDemandMqinSql, WarpItemHandledStrList, WarpItemHandledStr, read_Material_Schedule_list, read_Material_Schedule_list_Link, articleTypeList, logicalWarehouseList, HandledWorkCenterSql, handledWorkCentersList);
    IniAppGlobals.Time_For_Fill_MATERIAL_DETAIL_SCHEDULE := NOW - IniAppGlobals.Time_For_Fill_MATERIAL_DETAIL_SCHEDULE;
  end;

  UpdateOperation(_('Create struct for additional data'));
  additionalDataList := TList.Create;
  IniAppGlobals.Time_For_Additional_Data := Now;
  fillAdditionalDataStruct(HostQry, additionalDataList, UserGenericGroupTypeList, ColorTypeList, AD_Product_SelectColums ,AD_FullItemKeyDecoder_SelectColums,
     AD_ProductionDemand_SelectColums, AD_ProductionDemandStep_SelectColums, HandledProductionDemandMqinSql, HandledUserGenericGroupTypesStr,
     HandledColorGroupTypesStr, AtLeast_1_Wc_HandledWarp, WarpItemHandledStr);
  IniAppGlobals.Time_For_Additional_Data := Now - IniAppGlobals.Time_For_Additional_Data;

  ColumnNamesSql_Items := '';
  List_Items := TList.Create;

  IniAppGlobals.Time_FULLITEMKEYDECODER_TOOL := NOW;
  Fill_PRODUCT_FULLITEMKEYDECODER_TOOL(ArcQry, HostQry, WarpItemHandledStr, ColumnNamesSql_Items, List_Items, HandledProductionDemandMqinSql);
  IniAppGlobals.Time_FULLITEMKEYDECODER_TOOL := NOW - IniAppGlobals.Time_FULLITEMKEYDECODER_TOOL;

  UserGenericGroupTypeAttributesList := TList.Create;
  if (HandledUserGenericGroupTypesStr <> '') and (HandledUserGenericGroupTypesStr <> '&&&') then   
  begin
    IniAppGlobals.Time_For_fillUserGenericGroupTypeUNIQUEID := NOW;
    fillUserGenericGroupTypeAttributes(HostQry, UserGenericGroupTypeAttributesList, HandledUserGenericGroupTypesStr);
    IniAppGlobals.Time_For_fillUserGenericGroupTypeUNIQUEID := NOW - IniAppGlobals.Time_For_fillUserGenericGroupTypeUNIQUEID;
  end;

  ColorTypeUNIQUEIDList := TList.Create;
  if (HandledColorGroupTypesStr <> '') and (HandledColorGroupTypesStr <> '&&&') then
  begin
    IniAppGlobals.Time_For_fillColorTypeUNIQUEID := NOW;
    fillColorTypeUNIQUEID(HostQry, ColorTypeUNIQUEIDList, HandledColorGroupTypesStr);
    IniAppGlobals.Time_For_fillColorTypeUNIQUEID := NOW - IniAppGlobals.Time_For_fillColorTypeUNIQUEID;
  end;

  if not GetCompanyLevelHandlingByEntityName('PRODUCTIONDEMAND',  CompanyInUsed_PD) then
     CompanyInUsed_PD := IniAppGlobals.CompanyCode;

  if not GetCompanyLevelHandlingByEntityName('ITEMTYPE',  CompanyInUsed_IT) then
     CompanyInUsed_IT := IniAppGlobals.CompanyCode;

  if not GetCompanyLevelHandlingByEntityName('PRODUCT',  CompanyInUsed_P) then
     CompanyInUsed_P := IniAppGlobals.CompanyCode;

  if not GetCompanyLevelHandlingByEntityName('FULLITEMKEYDECODER',  CompanyInUsed_FIKD) then
     CompanyInUsed_FIKD := IniAppGlobals.CompanyCode;

   if not GetCompanyLevelHandlingByEntityName('RECIPE',  CompanyInUsed_RCP) then
     CompanyInUsed_RCP := IniAppGlobals.CompanyCode;

   if not GetCompanyLevelHandlingByEntityName('DESIGN',  CompanyInUsed_DSN) then
     CompanyInUsed_DSN := IniAppGlobals.CompanyCode;

  if not GetCompanyLevelHandlingByEntityName('PRODUCTIONDEMANDSTEP',  CompanyInUsed_PDS) then
     CompanyInUsed_PDS := IniAppGlobals.CompanyCode;

  if not GetCompanyLevelHandlingByEntityName('PRODUCTIONRESERVATION',  CompanyInUsed_PRSV) then
     CompanyInUsed_PRSV := IniAppGlobals.CompanyCode;

  if not GetCompanyLevelHandlingByEntityName('TOOL',  CompanyInUsed_TOOL) then
     CompanyInUsed_TOOL := IniAppGlobals.CompanyCode;
  if not GetCompanyLevelHandlingByEntityName('AVAILABILITYFORMULADETAIL',  CompanyInUsed_AvailabilityFormulaDetail) then
     CompanyInUsed_AvailabilityFormulaDetail := IniAppGlobals.CompanyCode;

  IniAppGlobals.Time_For_LoadProjectNumbers := NOW;
  LoadProjectNumbers(ArcQry , ProjectNumberList);
  IniAppGlobals.Time_For_LoadProjectNumbers := NOW - IniAppGlobals.Time_For_LoadProjectNumbers;

  insertedProducts := TStringList.Create;
  insertedProducts.Sorted := true;

  productsList := TList.Create;
  addedKeysToProduction := TStringList.Create;
  addedKeysFromProduction := TStringList.Create;

  ProcessListAlternativeUM_Primary   := TStringList.Create;
  ProcessListAlternativeUM_secondary := TStringList.Create;
  PackagingAlternativeUoM := TStringList.Create;

  IniAppGlobals.Time_For_fillAlternativeUM := NOW;
  fillAlternativeUM(ArcQry, IniAppGlobals.CompanyCode);
  IniAppGlobals.Time_For_fillAlternativeUM := NOW - IniAppGlobals.Time_For_fillAlternativeUM;

  UpdateOperation(_('Create struct for alternative warehouses'));
  alternativeWarehouseList := TList.Create;
  IniAppGlobals.Time_for_fillAlternativeWarehouseStruct := NOW;
  fillAlternativeWarehouseStruct(ArcQry, alternativeWarehouseList);
  IniAppGlobals.Time_for_fillAlternativeWarehouseStruct := NOW - IniAppGlobals.Time_for_fillAlternativeWarehouseStruct;

  // Fill all RES
  UpdateOperation(_('Fill resource list'));
  resList := TList.Create;
  IniAppGlobals.Time_For_fillResTableToList := NOW;
  fillResTableToList(ArcQry, resList);
  IniAppGlobals.Time_For_fillResTableToList := NOW - IniAppGlobals.Time_For_fillResTableToList;

  // Fill all ROUTINGSTEPTIMETYPE
  UpdateOperation(_('Fill routing step time type list'));
  routingStepTimeTypeList := TList.Create;
  IniAppGlobals.Time_for_fillRoutingStepTimeTypeToList := NOW;
  fillRoutingStepTimeTypeToList(HostQry, routingStepTimeTypeList);
  IniAppGlobals.Time_for_fillRoutingStepTimeTypeToList := NOW - IniAppGlobals.Time_for_fillRoutingStepTimeTypeToList;

  // Fill all PRODUCTS
  UpdateOperation(_('Fill products list'));
  currentProductsList := TList.Create;
  IniAppGlobals.Time_for_fillProductsToList := NOW;
  fillProductsToList(LocalQry, currentProductsList);
  IniAppGlobals.Time_for_fillProductsToList := NOW - IniAppGlobals.Time_for_fillProductsToList;

  // Get standard unit category for weight
  standardWeightUnit := getStandardUnitCategoryForWeight(HostQry);

  // Fill all OPERATION from host
  operationList := TList.Create;
  UpdateOperation(_('Fill operations list'));
  IniAppGlobals.Time_For_fillOperationsToList := NOW;
  fillOperationsToList(HostQry, IniAppGlobals.CompanyCode, operationList);
  IniAppGlobals.Time_For_fillOperationsToList := NOW - IniAppGlobals.Time_For_fillOperationsToList;

  // Fill all SALESORDER from host
  salesOrderList := TList.Create;
  UpdateOperation(_('Fill sales order list'));
  IniAppGlobals.Time_for_fillSalesOrderToList := NOW;
  fillSalesOrderToList(HostQry, IniAppGlobals.CompanyCode, salesOrderList);
  IniAppGlobals.Time_for_fillSalesOrderToList := NOW - IniAppGlobals.Time_for_fillSalesOrderToList;

  // Fill all PURCHASEORDER from host
  UpdateOperation(_('Fill purchase order list'));
  purchaseOrderList := TList.Create;
  IniAppGlobals.Time_For_fillPurchaseOrderToList := NOW;
  fillPurchaseOrderToList(HostQry, IniAppGlobals.CompanyCode, purchaseOrderList);
  IniAppGlobals.Time_For_fillPurchaseOrderToList := NOW - IniAppGlobals.Time_For_fillPurchaseOrderToList;

{  // Fill all LOGICALWAREHOUSE from host
  UpdateOperation(_('Fill warehouse list'));
  logicalWarehouseList := TList.Create;
  fillLogicalWarehousesToList(ArcQry, HostQry, logicalWarehouseList);

  if AtLeast_1_Wc_HandledWarp then
  begin
    UpdateOperation(_('Downloading data for Material schedule'));
    Fill_MATERIAL_DETAIL_SCHEDULE(HostQry, HandledProductionDemandMqinSql, WarpItemHandledStrList, WarpItemHandledStr, read_Material_Schedule_list, articleTypeList, logicalWarehouseList);
  end;}

  read_Productproperty_list := TList.create;
  IniAppGlobals.Time_For_Fill_Products_properties := NOW;
  Fill_Products_properties(read_Productproperty_list, additionalDataList, propertyList, WarpItemHandledStrList, List_Items);
  IniAppGlobals.Time_For_Fill_Products_properties := NOW - IniAppGlobals.Time_For_Fill_Products_properties;

  // Fill all ITEMTYPETEMPLATE from host
  UpdateOperation(_('Fill item type template list'));
  itemTypeTemplates := TList.Create;
  IniAppGlobals.Time_for_fillItemTypeTemplatesToList := NOW;
  fillItemTypeTemplatesToList(ArcQry, itemTypeTemplates);
  IniAppGlobals.Time_for_fillItemTypeTemplatesToList := NOW - IniAppGlobals.Time_for_fillItemTypeTemplatesToList;

  // Fill all PRODUCTIONDEMANDCOUNTER from host
  UpdateOperation(_('Fill production demand counter list'));
  productionDemandCounters := TList.Create;
  IniAppGlobals.Time_for_fillProductionDemandCountersToList := NOW;
  needToHandleMergeOperation := fillProductionDemandCountersToList(ArcQry, productionDemandCounters);
  IniAppGlobals.Time_for_fillProductionDemandCountersToList := NOW - IniAppGlobals.Time_for_fillProductionDemandCountersToList;

  // Fill Additional data with relation to list
  UpdateOperation(_('Fill additional data with relation list'));
  additionalDataWithRelationList := TList.Create;
  IniAppGlobals.Time_fillADWithRelationToList := NOW;
  fillADWithRelationToList(ArcQry, additionalDataWithRelationList);
  IniAppGlobals.Time_fillADWithRelationToList := Now - IniAppGlobals.Time_fillADWithRelationToList;

  // Fill all PRODUCTIONPROGRESSTEMPLATE from host
  UpdateOperation(_('Fill production progress template list'));
  productionProgressTemplates := TList.Create;
  IniAppGlobals.Time_For_fillProductionProgressTemplateStruct := NOW;
  fillProductionProgressTemplateStruct(ArcQry, productionProgressTemplates);
  IniAppGlobals.Time_For_fillProductionProgressTemplateStruct := NOW - IniAppGlobals.Time_For_fillProductionProgressTemplateStruct;

  fillWorkCentersBatchSizes(handledWorkCentersList, resList);
  handledProductionDemands := TStringList.Create;

  handledProductionDemandList := TList.Create;
  handledProductionOrderList := TList.Create;

  productionReservationList := TList.Create;
  ReservationLines := TList.Create;
  productionReservationStringList := TStringList.Create;
  productionReservationStringList.sorted := true;

  prod_req_list := TStringList.Create;
  stepIdListForProgressList_PD := TList.Create;
  stepIdListForProgressList_PO := TList.Create;
  stepIdListForProgressList_PO_SL := TStringList.Create;
  stepIdListForProgressList_PO_SL.CaseSensitive := True;
  stepIdListForProgressList_PO_SL.Sorted := True;

  read_prod_req_list := TList.Create;
  read_prod_reqhdr_list := TList.Create;

  read_prod_step_list := TList.Create;
  read_prod_step_time_list := TList.Create;
  read_prop_prod_list := TList.Create;
  read_prod_step_batch_size_list := TList.Create;
  read_prod_info_list := TList.Create;

  read_prod_reqConn_list := TList.Create;
  alreadyAddedPROD_REQCONN := TStringList.Create;

  read_ext_connection_list := TList.Create;
  read_ext_info_hdr_list := TList.Create;
  read_ext_info_list := TList.Create;
  read_balance_header_list := TList.Create;
  read_produced_article_list := TList.Create;
  read_material_list := TList.Create;

  Steps := TStringList.Create;
  Recipes := TStringList.Create;
  Designs := TStringList.Create;

  lastCounterCode := '';
  lastCode := '';
//  lastProductionDemandTemplate := '';
//  lastStepNumber := '';
  dummyVar := '';

  UpdateOperation(_('Prepare allocation lists'));
  PrepareAllocationLists(HostQry, IniAppGlobals.CompanyCode, articleTypeList, ReservationLines);
  UpdateOperation('');

  // Start BuildProdSchedProgress in background thread (DB2/Oracle only — not InterBase)
  var ProgTask: ITask := nil;
  var ProgTaskResult: TList := nil;
  if IniAppGlobals.DownloadTo <> '2' then
    ProgTask := TTask.Run(procedure
    begin
      ProgTaskResult := BuildProdSchedProgress(m_NeedToMakeMerge, HandledWorkCenterSql, productionDemandCounters, true);
    end);

  hostQry.Close;

  ISSUEDATE := 0;
  TempIssueDate := 0;
  ABSUNIQUEIDRCP := '';
  ABSUNIQUEIDDSN := '';
  StepNumber := '';
  ClearStructMemoryList;

  Counters := TStringList.Create;
  CountersCount := TStringList.Create;
  hostSqlStr := '';
  hostSqlStr := hostSqlStr + ' SELECT CounterCode, Count(*) Cnt FROM SchedulesDownloadDemands WHERE ';
  hostSqlStr := hostSqlStr + ' COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' and ';
  hostSqlStr := hostSqlStr + ' EnvironmentCode = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' and ';
  hostSqlStr := hostSqlStr + ' TemplateCode in (' + HandledProductionDemandMqinSql + ') ';
  hostSqlStr := hostSqlStr + ' Group by CounterCode Order by CounterCode ';
  HostQry.SQL.Text := hostSqlStr;
  hostQry.Open;
  fldCounterCode := hostQry.FieldByName('CounterCode');
  fldCnt         := hostQry.FieldByName('Cnt');
  while ( not hostQry.Eof ) do
  begin
    Counters.Add(fldCounterCode.AsString);
    CountersCount.Add(IntToStr(fldCnt.AsInteger));
    hostQry.Next;
  end;
  hostQry.Close;

  EndingIndex := -1;
  InsideCounter := false;
  NumberOfDemandsBlock := 25000;
  EndingCounterCode := '';
  BlockNumber := 0;

  while true do
  begin

    if InsideCounter and (EndingDemandCode = '') then
      InsideCounter := false;

    if not InsideCounter then
    begin
      inc(EndingIndex);
      if EndingIndex > (Counters.Count - 1) then
        break;
      StartingCounterCode := EndingCounterCode;
      EndingCounterCode := Counters[EndingIndex];
      NumberOfDemands := StrToInt(CountersCount[EndingIndex]);
      while True do
      begin
        if (EndingIndex + 1) > (Counters.Count - 1) then
          break;
        if (NumberOfDemands + StrToInt(CountersCount[EndingIndex + 1])) > NumberOfDemandsBlock then
          break;
        inc(EndingIndex);
        EndingCounterCode := Counters[EndingIndex];
        NumberOfDemands := NumberOfDemands + StrToInt(CountersCount[EndingIndex]);
      end;
      if (NumberOfDemands > NumberOfDemandsBlock) then
      begin
        InsideCounter := true;
        StartingDemandCode := '';
        EndingDemandCode := '';
      end;
    end;

    if not InsideCounter and (EndingIndex = (counters.Count - 1)) then
      EndingCounterCode := '';

    if InsideCounter then
    begin
      StartingDemandCode := EndingDemandCode;
      hostSqlStr := '';
      hostSqlStr := hostSqlStr + ' SELECT Code FROM SchedulesDownloadDemands WHERE ';
      hostSqlStr := hostSqlStr + ' COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' and ';
      hostSqlStr := hostSqlStr + ' EnvironmentCode = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' and ';
      hostSqlStr := hostSqlStr + ' TemplateCode in (' + HandledProductionDemandMqinSql + ') ';
      hostSqlStr := hostSqlStr + ' and CounterCode = ' + QuotedStr(EndingCounterCode);
      if StartingDemandCode <> '' then
        hostSqlStr := hostSqlStr + ' and Code > ' + QuotedStr(StartingDemandCode);
      hostSqlStr := hostSqlStr + ' Order by CounterCode, Code ';
      hostSqlStr := hostSqlStr + ' offset ' + inttostr(NumberOfDemandsBlock - 1) + ' rows fetch first 1 rows only ';
      HostQry.SQL.Text := hostSqlStr;

      IniAppGlobals.Time_BigSql := NOW;
      hostQry.Open;
      IniAppGlobals.Time_BigSql := Now - IniAppGlobals.Time_BigSql;
      IniAppGlobals.Time_ToTal_Blockes := IniAppGlobals.Time_ToTal_Blockes + IniAppGlobals.Time_BigSql;

      if hostQry.Eof then
        EndingDemandCode := ''
      else
        EndingDemandCode := HostQry.FieldByName('Code').AsString;
      hostQry.Close;
    end;

    inc(BlockNumber);
    UpdateOperation(_('Executing block ') + inttostr(BlockNumber) + _(' query on production demands'));

    // need to take the ibs unieq id from the
    hostSqlStr := '';
    hostSqlStr := hostSqlStr + 'SELECT ' + firstSentenceColumnNames + ', ' + secondSentenceColumnNames;

    hostSqlStr := hostSqlStr + ' FROM (SELECT companycode, countercode, code FROM SchedulesDownloadDemands WHERE ';
    hostSqlStr := hostSqlStr + ' COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' and ';
    hostSqlStr := hostSqlStr + ' EnvironmentCode = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' and ';
    hostSqlStr := hostSqlStr + ' TemplateCode in (' + HandledProductionDemandMqinSql + ') ';

    if InsideCounter then
    begin
      hostSqlStr := hostSqlStr + ' and CounterCode = ' + QuotedStr(EndingCounterCode);
      if (StartingDemandCode <> '') then
        hostSqlStr := hostSqlStr + ' and Code > ' + QuotedStr(StartingDemandCode);
      if (EndingDemandCode <> '') then
        hostSqlStr := hostSqlStr + ' and Code <= ' + QuotedStr(EndingDemandCode);
    end
    else
    begin
      if (StartingCounterCode <> '') then
        hostSqlStr := hostSqlStr + ' and CounterCode > ' + QuotedStr(StartingCounterCode);
      if (EndingCounterCode <> '') then
        hostSqlStr := hostSqlStr + ' and CounterCode <= ' + QuotedStr(EndingCounterCode);
    end;

    hostSqlStr := hostSqlStr + ' ) SDD ';

    hostSqlStr := hostSqlStr + ' JOIN PRODUCTIONDEMAND PD ';
    hostSqlStr := hostSqlStr + ' ON  PD.CompanyCode = SDD.CompanyCode ';
    hostSqlStr := hostSqlStr + ' AND PD.CounterCode = SDD.CounterCode ';
    hostSqlStr := hostSqlStr + ' AND PD.Code = SDD.Code ';

    hostSqlStr := hostSqlStr + 'JOIN FULLITEMKEYDECODER FIKD ON ';
    hostSqlStr := hostSqlStr + 'FIKD.IDENTIFIER = PD.FULLITEMIDENTIFIER ';

    hostSqlStr := hostSqlStr + 'LEFT JOIN PRODUCTIONDEMANDSTEP PDS ON ';
    hostSqlStr := hostSqlStr + '(PDS.PRODUCTIONDEMANDCOMPANYCODE = ' + QuotedStr(CompanyInUsed_PDS) + ' AND ';
    hostSqlStr := hostSqlStr + 'PDS.PRODUCTIONDEMANDCOUNTERCODE = PD.COUNTERCODE AND ';
    hostSqlStr := hostSqlStr + 'PDS.PRODUCTIONDEMANDCODE = PD.CODE) ';
    hostSqlStr := hostSqlStr + 'LEFT JOIN PRODUCTIONRESERVATION PRSV ON ';
  //  hostSqlStr := hostSqlStr + '((PRSV.ITEMNATURE =' + QuotedStr('1') + ' OR PRSV.ITEMNATURE =' + QuotedStr('4') + ') AND ';
    hostSqlStr := hostSqlStr + '(PRSV.ITEMNATURE in (' + QuotedStr('1') + ',' + QuotedStr('4') + ',' + QuotedStr('9') + ',' + QuotedStr('A') + ') AND ' + ' PRSV.PROGRESSSTATUS in (' + QuotedStr('0') + ',' + QuotedStr('1') + ')' + ' AND ';
    hostSqlStr := hostSqlStr + 'PRSV.COMPANYCODE = ' + QuotedStr(CompanyInUsed_PRSV) + ' AND PRSV.ORDERCOUNTERCODE = PD.COUNTERCODE AND ';
    hostSqlStr := hostSqlStr + 'PRSV.ORDERCODE = PD.CODE AND PRSV.STEPNUMBER = PDS.STEPNUMBER) ';

    hostSqlStr := hostSqlStr + 'LEFT JOIN FULLITEMKEYDECODER FIKDRSR ON ';
    hostSqlStr := hostSqlStr + 'PRSV.ITEMNATURE = ' + QuotedStr('1') + ' AND ';
    hostSqlStr := hostSqlStr + 'FIKDRSR.IDENTIFIER = PRSV.FULLITEMIDENTIFIER ';

    hostSqlStr := hostSqlStr + 'LEFT JOIN RECIPE R ON ';
    hostSqlStr := hostSqlStr + 'PRSV.ITEMNATURE = ' + QuotedStr('9') + ' AND ';
    hostSqlStr := hostSqlStr + 'R.COMPANYCODE = ' + QuotedStr(CompanyInUsed_RCP) + ' AND ';
    hostSqlStr := hostSqlStr + 'R.ITEMTYPECODE = PRSV.ITEMTYPEAFICODE AND ';
    hostSqlStr := hostSqlStr + 'R.SUBCODE01 = PRSV.SUBCODE01 AND ';
    hostSqlStr := hostSqlStr + 'R.SUFFIXCODE = PRSV.SUFFIXCODE ';

    hostSqlStr := hostSqlStr + 'LEFT JOIN DESIGN D ON ';
    hostSqlStr := hostSqlStr + 'PRSV.ITEMNATURE = ' + QuotedStr('A') + ' AND ';
    hostSqlStr := hostSqlStr + 'D.COMPANYCODE = ' + QuotedStr(CompanyInUsed_DSN) + ' AND ';
    hostSqlStr := hostSqlStr + 'D.ITEMTYPECODE = PRSV.ITEMTYPEAFICODE AND ';
    hostSqlStr := hostSqlStr + 'D.SUBCODE01 = PRSV.SUBCODE01 AND D.SUBCODE02 = PRSV.SUBCODE02 AND ';
    hostSqlStr := hostSqlStr + 'D.SUFFIXCODE = PRSV.SUFFIXCODE ';

    hostSqlStr := hostSqlStr + 'LEFT JOIN TOOL T ON ';
    hostSqlStr := hostSqlStr + 'PRSV.ITEMNATURE = ' + QuotedStr('4') + ' AND ';
    hostSqlStr := hostSqlStr + 'T.COMPANYCODE = ' + QuotedStr(CompanyInUsed_TOOL) + ' AND ';
    hostSqlStr := hostSqlStr + 'T.ITEMTYPECODE = PRSV.ITEMTYPEAFICODE AND T.SUBCODE01 = PRSV.SUBCODE01 ';

   // hostSqlStr := hostSqlStr + ' where PD.Code = ' + QuotedStr('190000000663') + ' ';

    hostSqlStr := hostSqlStr + ' ORDER BY PD.COUNTERCODE, PD.CODE, PDS.STEPNUMBER, PRSV.RESERVATIONLINE ';

    SqlPrint.Add(hostSqlStr);
    SqlPrint.SaveToFile(LocAppGlobals.AppDir + '\MainSql.txt');

    HostQry.SQL.Text := hostSqlStr;
    IniAppGlobals.Time_BigSql := NOW;
    hostQry.Open;
    IniAppGlobals.Time_BigSql := Now - IniAppGlobals.Time_BigSql;
    IniAppGlobals.Time_ToTal_Blockes := IniAppGlobals.Time_ToTal_Blockes + IniAppGlobals.Time_BigSql;

    UpdateOperation(_('Downloading block ') + inttostr(BlockNumber) + _(' of production demands'));

    FIKD_ABSUNIQUEID          := HostQry.FieldByName('FIKD_ABSUNIQUEID');
    PRSV_ITEMNATURE           := HostQry.FieldByName('PRSV_ITEMNATURE');
    PD_COUNTERCODE            := HostQry.FieldByName('PD_COUNTERCODE');
    PD_CODE                   := HostQry.FieldByName('PD_CODE');
    PDS_STEPNUMBER_TFIELD     := HostQry.FieldByName('PDS_STEPNUMBER');
    PRSV_ISSUEDATE_TFIELD     := HostQry.FieldByName('PRSV_ISSUEDATE');
    RSV_FIKD_ABSUNIQUEID      := HostQry.FieldByName('RSV_FIKD_ABSUNIQUEID');
    PD_COMPANYCODE            := HostQry.FieldByName('PD_COMPANYCODE');
    while ( not hostQry.Eof ) do
    begin
     // hostQry.next;
     // continue;

   //   ABSUNIQUEID := HostQry.Fields.FieldByName('FIKD_ABSUNIQUEID').AsString;
  //    if trim(ABSUNIQUEID) = '' then
      if trim(FIKD_ABSUNIQUEID.AsString) = '' then
      begin
        HostQry.Next;
        continue
      end;

      ItemNature := PRSV_ITEMNATURE.AsString;

      //  to check wether if it is a new demand - step or new demand
      if ( dummyVar <> (setStringLengthTo(PD_COUNTERCODE.AsString, 8)  +
                        setStringLengthTo(PD_CODE.AsString, 15) +
                        PDS_STEPNUMBER_TFIELD.AsString)
         ) then
      begin

        if dummyVar <> '' then
        begin
          Steps.Add(StepNumber);
          Recipes.Add(ABSUNIQUEIDRCP);
          Designs.Add(ABSUNIQUEIDDSN);
          ABSUNIQUEIDRCP := '';
          ABSUNIQUEIDDSN := '';
          for I := 0 to m_ProdCont.m_Req_Change_List.Count - 1 do
          begin
            MQMProductionColumnValues := PMQMProductionColumnValues(m_ProdCont.m_Req_Change_List[I]);
            if (getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_STEPNUMBER', PDS_STEPNUMBER) <>  StepNumber) then continue;
          //  index := productionColumnNames.IndexOf('PRSV_ISSUEDATE');
            MQMProductionColumnValues.columnValues.Strings[PRSV_ISSUEDATE] := DateToStr(ISSUEDATE);
            break;
          end;
        end;

        ISSUEDATE := PRSV_ISSUEDATE_TFIELD.AsDateTime;
        StepNumber := PDS_STEPNUMBER_TFIELD.AsString;
        if ItemNature = '9' then
          ABSUNIQUEIDRCP := RSV_FIKD_ABSUNIQUEID.AsString;
        if ItemNature = 'A' then
          ABSUNIQUEIDDSN := RSV_FIKD_ABSUNIQUEID.AsString;

        dummyVar := setStringLengthTo(PD_COUNTERCODE.AsString, 8)  +
                    setStringLengthTo(PD_CODE.AsString, 15) +
                    PDS_STEPNUMBER_TFIELD.AsString;

        // check if productionRequestNumber Changed
        if( lastCounterCode + lastCode <>
                setStringLengthTo(PD_COUNTERCODE.AsString, 8) + PD_CODE.AsString
          ) then
        begin
          if ( m_ProdCont.m_Req_Change_List.Count > 0 ) then
          begin
            inc(DemandCount);
            if (DemandCount mod 500 = 0) then
              UpdateOperation(_(setStringLengthTo(PD_COUNTERCODE.AsString, 8) + setStringLengthTo(PD_CODE.AsString, 15))  +  '      ' + IntToStr(DemandCount));

            insertTheTuplesToProductionTables(productionDemandTemplates,
                                              handledWorkCentersList,
                                              unhandledWorkCentersList,
                                              LocalQry,
                                              propertyList, resList,
                                              additionalDataList,
                                              UserGenericGroupTypeList, UserGenericGroupTypeAttributesList,
                                              ColorTypeList, ColorTypeUNIQUEIDList,
                                              productionReservationList,
                                           //   productPrimaryUomConversionDataList,
                                           //   secondaryUnitCategoryConversionList,
                                           //   stdUnitCategoryConversionList,
                                              routingStepTimeTypeList,
                                              operationList, articleTypeList,
                                              productsList,
                                              read_produced_article_list,
                                              read_material_list,
                                              currentProductsList,
                                              logicalWarehouseList,
                                              read_prod_req_list, read_prod_reqhdr_list,
                                              read_prod_step_list, read_prod_step_time_list,
                                              read_prop_prod_list, read_prod_step_batch_size_list,
                                              stepIdListForProgressList_PD,
                                              stepIdListForProgressList_PO,
                                              stepIdListForProgressList_PO_SL,
                                              itemTypeTemplates, productionDemandCounters,
                                              alternativeWarehouseList, read_prod_reqConn_list,
                                              alreadyAddedPROD_REQCONN,
                                              additionalDataWithRelationList,
                                              itemTypeLogicalWarehouseList,
                                              {Items,} Steps, Recipes, Designs,
                                              standardWeightUnit);

            productionReservationStringList.Clear;
            Steps.Clear;
            Recipes.Clear;
            Designs.Clear;
            for I := 0 to productionReservationList.Count - 1 do
              Dispose(PMQMProductionReservation(productionReservationList[I]));
            productionReservationList.Clear;
          end;

          // clear the list in memory
         // m_ProdCont.m_Req_Change_List.Clear;

          for I := 0 to m_ProdCont.m_Req_Change_List.Count - 1 do
          begin
            MQMProductionColumnValues := PMQMProductionColumnValues(m_ProdCont.m_Req_Change_List[I]);
            MQMProductionColumnValues.columnValues.Free;
            Dispose(MQMProductionColumnValues);
          end;
          m_ProdCont.m_Req_Change_List.Clear;

          lastCounterCode := setStringLengthTo(PD_COUNTERCODE.AsString, 8);
          lastCode := PD_CODE.AsString;
  //        lastProductionDemandTemplate := setStringLengthTo(HostQry.FieldByName('PD_TEMPLATECODE').AsString, 3);
  //        lastStepNumber := HostQry.FieldByName('PDS_STEPNUMBER').AsString;

          prodReqNo := setStringLengthTo(PD_COMPANYCODE.AsString, 3) +
                       lastCounterCode + lastCode;

          prod_req_list.Add(prodReqNo);

          //Items := nil;
          //index := searchInList(List_Items, 44, ABSUNIQUEID, 0, List_Items.Count - 1);
          //if Index <> -1 then Items := PTITEMS(List_Items[Index]);
        end;

        insertTupleToMemoryList(HostQry);

      end
      else
      begin
        if (ItemNature = '9') and (ABSUNIQUEIDRCP = '') then
          ABSUNIQUEIDRCP := RSV_FIKD_ABSUNIQUEID.AsString;
        if (ItemNature = 'A') and (ABSUNIQUEIDDSN = '') then
          ABSUNIQUEIDDSN := RSV_FIKD_ABSUNIQUEID.AsString;
        if PRSV_ISSUEDATE_TFIELD.AsDateTime > ISSUEDATE  then
          ISSUEDATE := PRSV_ISSUEDATE_TFIELD.AsDateTime;
      end;

      if (ItemNature = '1') or (ItemNature = '4') then
         addProductionReservationToList(HostQry, productionReservationList, ReservationLines, productionReservationStringList);

      HostQry.Next;
    end;

  end;

  Counters.Free;
  CountersCount.Free;

//  LogReq.SaveToFile(LocAppGlobals.AppDir + '\RecFound.txt');

  // only for the last demand ...
  if ( m_ProdCont.m_Req_Change_List.Count > 0 ) then
  begin
    if dummyVar <> '' then
    begin
      Steps.Add(StepNumber);
      Recipes.Add(ABSUNIQUEIDRCP);
      Designs.Add(ABSUNIQUEIDDSN);
      for I := 0 to m_ProdCont.m_Req_Change_List.Count - 1 do
      begin
        MQMProductionColumnValues := PMQMProductionColumnValues(m_ProdCont.m_Req_Change_List[I]);
        if (getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_STEPNUMBER', PDS_STEPNUMBER) <>  StepNumber) then continue;
       // index := productionColumnNames.IndexOf('PRSV_ISSUEDATE');
        MQMProductionColumnValues.columnValues.Strings[PRSV_ISSUEDATE] := DateToStr(ISSUEDATE);
        break;
      end;
    end;
    insertTheTuplesToProductionTables(productionDemandTemplates,
                                      handledWorkCentersList,
                                      unhandledWorkCentersList,
                                      LocalQry,
                                      propertyList, resList,
                                      additionalDataList,
                                      UserGenericGroupTypeList, UserGenericGroupTypeAttributesList,
                                      ColorTypeList, ColorTypeUNIQUEIDList,
                                      productionReservationList,
                                   //   productPrimaryUomConversionDataList,
                                   //   secondaryUnitCategoryConversionList,
                                   //   stdUnitCategoryConversionList,
                                      routingStepTimeTypeList,
                                      operationList, articleTypeList,
                                      productsList,
                                      read_produced_article_list, read_material_list,
                                      currentProductsList,
                                      logicalWarehouseList,
                                      read_prod_req_list, read_prod_reqhdr_list,
                                      read_prod_step_list, read_prod_step_time_list,
                                      read_prop_prod_list, read_prod_step_batch_size_list,
                                      stepIdListForProgressList_PD,
                                      stepIdListForProgressList_PO,
                                      stepIdListForProgressList_PO_SL,
                                      itemTypeTemplates,
                                      productionDemandCounters, alternativeWarehouseList,
                                      read_prod_reqConn_list, alreadyAddedPROD_REQCONN,
                                      additionalDataWithRelationList,
                                      itemTypeLogicalWarehouseList,
                                      {Items,} Steps, Recipes, Designs,
                                      standardWeightUnit);
    productionReservationStringList.Clear;

    for I := 0 to productionReservationList.Count - 1 do
      Dispose(PMQMProductionReservation(productionReservationList[I]));
    productionReservationList.Clear;
  end;

  HostQry.Close;

  UpdateOperation(_(''));

{  updateMaterialValuesFromAllocations(srvQryFD, HostQry, read_material_list, purchaseOrderList,
                                      addedKeysFromProduction,
                                      logicalWarehouseList, read_ext_connection_list,
                                      read_ext_info_hdr_list, read_ext_info_list,
                                      read_balance_header_list,
                                      articleTypeList, productionDemandCounters, additionalDataList, alternativeWarehouseList); }

{  updateProducedArticleValuesFromAllocations(srvQryFD, HostQry, read_produced_article_list,
                                             salesOrderList, addedKeysToProduction,
                                             logicalWarehouseList, read_prod_reqConn_list,
                                             read_ext_connection_list, read_ext_info_hdr_list, productionDemandCounters,
                                             read_ext_info_list, alreadyAddedPROD_REQCONN);  }


  balanceHandledItemTypeCodes := getBalanceHandledItemTypes(articleTypeList, false);

  if Trim(balanceHandledItemTypeCodes) <> '' then
  begin

    UpdateOperation(_('Downloading AVAILABILITY'));
    HostQryForVAA := ThreadCreateQueryHost;
    hostSqlStr := 'SELECT STOCKTYPECODE FROM AVAILABILITYFORMULADETAIL WHERE ' +
                  'AVAILABILITYFORMULACOMPANYCODE = ' + QuotedStr(CompanyInUsed_AvailabilityFormulaDetail) +
                  ' AND AVAILABILITYFORMULACODE = ' + QuotedStr(IniAppGlobals.FormulaForMaterialAvailability);
    HostQryForVAA.SQL.Text := hostSqlStr;
    HostQryForVAA.Open;
    STOCKTYPECODES := '';
    while not HostQryForVAA.EOF do
    begin
      if trim(STOCKTYPECODES) <> '' then
        STOCKTYPECODES := STOCKTYPECODES + ', ';
      STOCKTYPECODES := STOCKTYPECODES + QuotedStr(HostQryForVAA.FieldByName('STOCKTYPECODE').AsString);
      HostQryForVAA.Next;
    end;

    if STOCKTYPECODES = '' then
      STOCKTYPECODES := QuotedStr(STOCKTYPECODES);
    HostQryForVAA.Close;
    IniAppGlobals.Time_For_BuildAvailabilityStruct := NOW;
    hostSqlStr := BuildAvailabilityStruct(balanceHandledItemTypeCodes, STOCKTYPECODES, NETGROUP_IS_LOT_Handaled);
    IniAppGlobals.Time_For_BuildAvailabilityStruct := Now - IniAppGlobals.Time_For_BuildAvailabilityStruct;

    HostQryForVAA.SQL.Text := hostSqlStr;

    SqlPrint.Clear;
    SqlPrint.Add(hostSqlStr);
    SqlPrint.SaveToFile(LocAppGlobals.AppDir + '\BuildAvailabilityStruct.txt');

    HostQryForVAA.Open;

    IniAppGlobals.Time_For_insertIntoBALANCE_HEADER_List := NOW;
    insertIntoBALANCE_HEADER_List(HostQryForVAA, logicalWarehouseList, itemTypeLogicalWarehouseList, read_balance_header_list,
                                articleTypeList, additionalDataList, UserGenericGroupTypeList, UserGenericGroupTypeAttributesList);
    IniAppGlobals.Time_For_insertIntoBALANCE_HEADER_List := Now - IniAppGlobals.Time_For_insertIntoBALANCE_HEADER_List;

    HostQryForVAA.free;

 {   if not GetCompanyLevelHandlingByEntityName('ITEMTYPE',  ItemTypeCompanyInUsed) then
      ItemTypeCompanyInUsed := IniAppGlobals.CompanyCode;
    if not GetCompanyLevelHandlingByEntityName('TOOL',  ToolsCompanyInUsed) then
      ToolsCompanyInUsed := IniAppGlobals.CompanyCode;
    if not GetCompanyLevelHandlingByEntityName('FULLITEMKEYDECODER',  FIKDCompanyInUsed) then
      FIKDCompanyInUsed := IniAppGlobals.CompanyCode;

    hostSqlStr    := ' select * from (' +
                     ' select ' +
                     ' CASE WHEN IT.ITEMNATURE = ' + QuotedStr('1') + ' THEN FIKD.ABSUNIQUEID ' +
                     ' WHEN IT.ITEMNATURE = ' + QuotedStr('4') + ' THEN TOOL.ABSUNIQUEID ' +
                     ' ELSE 0 END ABSUNIQUEID, VAA.* ' +
                     ' FROM (' +
                     ' SELECT ' +

                     ' SUM(VAA.BASEPRIMARYQUANTITY) QTY, VAA.TYPE, VAA.LOGICALWAREHOUSECODE, ' +
                     ' VAA.COUNTERCODE, VAA.ISTANCECODE, VAA.DUEDATE,  VAA.ITEMTYPECODE, VAA.DECOSUBCODE01, VAA.DECOSUBCODE02, ' +
                     ' VAA.DECOSUBCODE03, VAA.DECOSUBCODE04, VAA.DECOSUBCODE05, VAA.DECOSUBCODE06, VAA.DECOSUBCODE07, ' +
                     ' VAA.DECOSUBCODE08, VAA.DECOSUBCODE09, VAA.DECOSUBCODE10, VAA.PROJECTCODE ' +
                     ' FROM (SELECT BASEPRIMARYQUANTITY, TYPE, LOGICALWAREHOUSECODE, COUNTERCODE,	ISTANCECODE, DUEDATE, ITEMTYPECODE, ' +
                     ' DECOSUBCODE01, ' +
                     ' COALESCE(DECOSUBCODE02, ' + QuotedStr(' ') + ') AS DECOSUBCODE02, COALESCE(DECOSUBCODE03,  ' + QuotedStr(' ') + ') AS DECOSUBCODE03, ' +
                     ' COALESCE(DECOSUBCODE04, ' + QuotedStr(' ') + ') AS DECOSUBCODE04, COALESCE(DECOSUBCODE05, ' + QuotedStr(' ') + ') AS DECOSUBCODE05, ' +
                     ' COALESCE(DECOSUBCODE06, ' + QuotedStr(' ') + ') AS DECOSUBCODE06, COALESCE(DECOSUBCODE07, ' + QuotedStr(' ') + ') AS DECOSUBCODE07, ' +
                     ' COALESCE(DECOSUBCODE08, ' + QuotedStr(' ') + ') AS DECOSUBCODE08, COALESCE(DECOSUBCODE09, ' + QuotedStr(' ') + ') AS DECOSUBCODE09, ' +
                     ' COALESCE(DECOSUBCODE10, ' + QuotedStr(' ') + ') AS DECOSUBCODE10, ' +
                     ' PROJECTCODE ' +
                     ' FROM VIEWAVAILABILITYANALYSISMQM ' +
                  //   ' FROM VIEWAVAILABILITYANALYSIS ' +
                     ' WHERE COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' AND ISTANCETYPE NOT IN (' + QuotedStr('0') + ',' + QuotedStr('1') + ')' +
                     ' AND STOCKTYPECODE IN (' + STOCKTYPECODES + ')' +
                     ' AND BASEPRIMARYQUANTITY > 0.0 AND ITEMTYPECODE IN (' + balanceHandledItemTypeCodes + ')) VAA ' +

                     ' GROUP BY ' +
                     ' VAA.TYPE, VAA.LOGICALWAREHOUSECODE, VAA.COUNTERCODE,  VAA.ISTANCECODE, VAA.DUEDATE, ' +
                     ' VAA.ITEMTYPECODE, VAA.DECOSUBCODE01, VAA.DECOSUBCODE02, VAA.DECOSUBCODE03, VAA.DECOSUBCODE04, ' +
                     ' VAA.DECOSUBCODE05, VAA.DECOSUBCODE06,  VAA.DECOSUBCODE07, VAA.DECOSUBCODE08, VAA.DECOSUBCODE09, ' +
                     ' VAA.DECOSUBCODE10, VAA.PROJECTCODE ) VAA ' +

                     ' JOIN ITEMTYPE IT ON ' +
                     ' IT.companycode = ' + QuotedStr(ItemTypeCompanyInUsed) + ' and it.code = VAA.ITEMTYPECODE ' +

                     ' LEFT JOIN FULLITEMKEYDECODER FIKD ON ' +
                     ' FIKD.COMPANYCODE = ' + QuotedStr(FIKDCompanyInUsed) + ' ' +
                     ' AND FIKD.ITEMTYPECODE = VAA.ITEMTYPECODE AND FIKD.SUBCODE01 = VAA.DECOSUBCODE01 ' +
                     ' AND FIKD.SUBCODE02 = VAA.DECOSUBCODE02 AND FIKD.SUBCODE03 = VAA.DECOSUBCODE03 ' +
                     ' AND FIKD.SUBCODE04 = VAA.DECOSUBCODE04 AND FIKD.SUBCODE05 = VAA.DECOSUBCODE05 ' +
                     ' AND FIKD.SUBCODE06 = VAA.DECOSUBCODE06 AND FIKD.SUBCODE07 = VAA.DECOSUBCODE07 ' +
                     ' AND FIKD.SUBCODE08 = VAA.DECOSUBCODE08 AND FIKD.SUBCODE09 = VAA.DECOSUBCODE09 ' +
                     ' AND FIKD.SUBCODE10 = VAA.DECOSUBCODE10	' +

                     ' Left join TOOL on TOOL.COMPANYCODE = ' + QuotedStr(ToolsCompanyInUsed) + ' AND TOOL.ITEMTYPECODE = VAA.ITEMTYPECODE AND ' +
                     ' TOOL.SUBCODE01 = VAA.DECOSUBCODE01) VAA ' +

                     ' where VAA.ABSUNIQUEID is not null and VAA.ABSUNIQUEID  > 0 ';

    HostQryForVAA.SQL.Text := hostSqlStr;
    HostQryForVAA.Open;
    insertIntoBALANCE_HEADER_List(HostQryForVAA, logicalWarehouseList, read_balance_header_list,
                                articleTypeList, additionalDataList);
    HostQryForVAA.Close;
    HostQryForVAA.Free;
//    checkBalanceHeadersToMadeDBOperation(read_balance_header_list);   }
  end;
  IniAppGlobals.Time_for_operationAfter_Big_SQL := NOW;

  IniAppGlobals.Time_For_DeleteOldProdOrderGrp := NOW;
  DeleteOldProduction_Order_Grp(Production_Order_Grp_No_list);
  IniAppGlobals.Time_For_DeleteOldProdOrderGrp := NOW - IniAppGlobals.Time_For_DeleteOldProdOrderGrp;

  IniAppGlobals.Time_For_LoadIntoStockDetails := NOW;
  LoadIntoStockDetails(logicalWarehouseList,itemTypesList, ProjectNumberList, List_Items);
  IniAppGlobals.Time_For_LoadIntoStockDetails := NOW - IniAppGlobals.Time_For_LoadIntoStockDetails;

  ProductionOrderStepStructList.Sort(SortProductionOrderStepStruct);
  IniAppGlobals.Time_For_PrepareProductionOrderStepQtyPct := NOW;
  PrepareProductionOrderStepQtyPercent(ProductionOrderStepStructList);
  IniAppGlobals.Time_For_PrepareProductionOrderStepQtyPct := NOW - IniAppGlobals.Time_For_PrepareProductionOrderStepQtyPct;

  for I := Production_Order_Grp_No_list.Count - 1 downto 0 do
    dispose(PPRODUCTION_ORDER_GRP_NOS(Production_Order_Grp_No_list[I]));
  Production_Order_Grp_No_list.Free;

{  for I := 0 to read_balance_header_list.Count - 1 do
        dispose(PRecBH(read_balance_header_list[I]));
  read_balance_header_list.Free;  }

  for I := 0 to m_ProdCont.m_Req_Change_List.Count - 1 do
  begin
    MQMProductionColumnValues := PMQMProductionColumnValues(m_ProdCont.m_Req_Change_List[I]);
    MQMProductionColumnValues.columnValues.Free;
    Dispose(MQMProductionColumnValues);
  end;
  m_ProdCont.m_Req_Change_List.Clear;

  for I := 0 to ProductionOrderStepStructList.Count - 1 do
    dispose(PTProductionOrderStepStruct(ProductionOrderStepStructList[I]));
  ProductionOrderStepStructList.Free;

  ProcessListAlternativeUM_Primary.Free;
  ProcessListAlternativeUM_secondary.Free;
  PackagingAlternativeUoM.Free;
  productionColumnNames.Free;
  insertedProducts.Free;
  handledProductionDemands.Free;
  productsList.Free;
  for I := 0 to currentProductsList.Count - 1 do
    dispose(PPRODUCTS(currentProductsList[I]));
  currentProductsList.Clear;
  UpdateOperation(_('Checking additional product for warp'));
  IniAppGlobals.Time_For_fillProductsToList_2nd := NOW;
  fillProductsToList(LocalQry, currentProductsList);
  IniAppGlobals.Time_For_fillProductsToList_2nd := NOW - IniAppGlobals.Time_For_fillProductsToList_2nd;
  IniAppGlobals.Time_For_checkIfNeedInsertNewWarpProd := NOW;
  checkIfNeedToInsertNewWarpProductionToDatabase(LocalQry, currentProductsList, List_Items);
  IniAppGlobals.Time_For_checkIfNeedInsertNewWarpProd := NOW - IniAppGlobals.Time_For_checkIfNeedInsertNewWarpProd;
  for I := 0 to currentProductsList.Count - 1 do
    dispose(PPRODUCTS(currentProductsList[I]));
  currentProductsList.Free;
  productionReservationStringList.Free;

  for I := 0 to propertyList.Count - 1 do
  begin
    PROP := PPROPS(propertyList[I]);
    for P := 0 to PROP.propRtvValueList.Count - 1 do
      dispose(PPROP_RTV_VALUES(PROP.propRtvValueList[P]));
    PROP.propRtvValueList.Free;
    PROP.PropWorkCentersCode.Free;
    PROP.PropWorkCentersCodePerOperation.Free;
    dispose(PROP);
  end;
  propertyList.Free;

  for I := 0 to OperAttributesList.Count - 1 do
        dispose(POPERATTRIBUTES(OperAttributesList[I]));
  OperAttributesList.Free;

  for I := 0 to resList.Count - 1 do
        dispose(PMQMRes(resList[I]));
  resList.Free;

  for I := 0 to routingStepTimeTypeList.Count - 1 do
        dispose(PROUTING_STEP_TIME_TYPES(routingStepTimeTypeList[I]));
  routingStepTimeTypeList.Free;

  for I := 0 to productionDemandTemplates.Count - 1 do
        dispose(PPRODUCTIONDEMANDTEMPLATES(productionDemandTemplates[I]));
  productionDemandTemplates.Free;

  for I := 0 to productionReservationList.Count - 1 do
        dispose(PMQMProductionReservation(productionReservationList[I]));
  productionReservationList.Free;

  for I := 0 to ReservationLines.Count - 1 do
        dispose(PMQMProductionReservationLine(ReservationLines[I]));
  ReservationLines.Free;

  for I := 0 to operationList.Count - 1 do
        dispose(POPERATIONS(operationList[I]));
  operationList.Free;

  for I := 0 to articleTypeList.Count - 1 do
        dispose(PARTICLE_TYPES(articleTypeList[I]));
  articleTypeList.Free;

  for I := 0 to salesOrderList.Count - 1 do
        dispose(PSALESORDERS(salesOrderList[I]));
  salesOrderList.Free;

  for I := 0 to purchaseOrderList.Count - 1 do
        dispose(PPURCHASEORDERS(purchaseOrderList[I]));
  purchaseOrderList.Free;
  addedKeysToProduction.Free;
  addedKeysFromProduction.Free;

  for I := 0 to UserGenericGroupTypeList.Count - 1 do
        dispose(PTUserGenericGroupType(UserGenericGroupTypeList[I]));
  UserGenericGroupTypeList.Free;

  for I := 0 to UserGenericGroupTypeAttributesList.Count - 1 do
        dispose(PTUserGenericGroupAttributes(UserGenericGroupTypeAttributesList[I]));
  UserGenericGroupTypeAttributesList.Free;

  for I := 0 to ColorTypeList.Count - 1 do
        dispose(PTColorType(ColorTypeList[I]));
  ColorTypeList.Free;

  for I := 0 to ColorTypeUNIQUEIDList.Count - 1 do
        dispose(PTColorUNIQUEID(ColorTypeUNIQUEIDList[I]));
  ColorTypeUNIQUEIDList.Free;

  for I := 0 to logicalWarehouseList.Count - 1 do
        dispose(PLOGICALWAREHOUSES(logicalWarehouseList[I]));
  logicalWarehouseList.Free;

  for I := 0 to handledProductionOrderList.Count - 1 do
        dispose(PHANDLED_PRODUCTION_ORDERS(handledProductionOrderList[I]));
  handledProductionOrderList.Free;

  for I := 0 to itemTypesList.Count - 1 do
  begin
    PITEMTYPES(itemTypesList[I]).SUBCODELENGTHS.Free;
    dispose(PITEMTYPES(itemTypesList[I]));
  end;
  itemTypesList.Free;

  for I := 0 to handledWorkCentersList.Count - 1 do
  begin
    WORKCENTERS := PWORKCENTERS(handledWorkCentersList[I]);
    WORKCENTERS.WC_Batch_UoM.Free;
    for W := 0 to WORKCENTERS.Process_List.Count - 1 do
    begin
      CUR_PROCESS := PPROCESSES(WORKCENTERS.Process_List[W]);
      for P := 0 to CUR_PROCESS.Properties_List.Count - 1 do
      begin
        PROPERTIES := PPROPERTIES(CUR_PROCESS.Properties_List[P]);
        dispose(PROPERTIES);
      end;

      for P := 0 to CUR_PROCESS.OperAttributes_List.Count - 1 do
      begin
        POPERATTRIBUTE := POPERATTRIBUTES(CUR_PROCESS.OperAttributes_List[P]);
        dispose(POPERATTRIBUTE);
      end;

      for P := CUR_PROCESS.ProductionTimesLevel_List.Count - 1 downto 0 do
      begin
        PPRODUCTIONTIMESLEVEL := PPRODUCTIONTIMESLEVELS(CUR_PROCESS.ProductionTimesLevel_List[P]);
        for A := PPRODUCTIONTIMESLEVEL.ProductionTimes_List.Count - 1 downto 0 do
          Dispose(PPRODUCTIONTIMES(PPRODUCTIONTIMESLEVEL.ProductionTimes_List[A]));
        PPRODUCTIONTIMESLEVEL.ProductionTimes_List.free;
        dispose(PPRODUCTIONTIMESLEVEL);
      end;

      CUR_PROCESS.Properties_List.Free;
      CUR_PROCESS.Alternatives_List.Free;
      CUR_PROCESS.OperAttributes_List.Free;
      CUR_PROCESS.ProductionTimesLevel_List.Free;
      dispose(CUR_PROCESS);
    end;
    PWORKCENTERS(handledWorkCentersList[I]).Process_List.Free;
    dispose(PWORKCENTERS(handledWorkCentersList[I]));
  end;
  handledWorkCentersList.Free;

  unhandledWorkCentersList.Free;

  for I := 0 to additionalDataList.Count - 1 do
  begin
    ADDITIONALDATA_HEADERS := PADDITIONALDATA_HEADERS(additionalDataList[I]);
    for P := 0 to ADDITIONALDATA_HEADERS.productADList.Count - 1 do
      dispose(PADDITIONALDATA_DETAILS(ADDITIONALDATA_HEADERS.productADList[P]));
    for P := 0 to ADDITIONALDATA_HEADERS.fullItemKeyDecoderADList.Count - 1 do
      dispose(PADDITIONALDATA_DETAILS(ADDITIONALDATA_HEADERS.fullItemKeyDecoderADList[P]));
    for P := 0 to ADDITIONALDATA_HEADERS.productionDemandADList.Count - 1 do
      dispose(PADDITIONALDATA_DETAILS(ADDITIONALDATA_HEADERS.productionDemandADList[P]));
    for P := 0 to ADDITIONALDATA_HEADERS.productionDemandStepADList.Count - 1 do
      dispose(PADDITIONALDATA_DETAILS(ADDITIONALDATA_HEADERS.productionDemandStepADList[P]));
    for P := 0 to ADDITIONALDATA_HEADERS.DesignADList.Count - 1 do
      dispose(PADDITIONALDATA_DETAILS(ADDITIONALDATA_HEADERS.DesignADList[P]));
    for P := 0 to ADDITIONALDATA_HEADERS.RecipeADList.Count - 1 do
      dispose(PADDITIONALDATA_DETAILS(ADDITIONALDATA_HEADERS.RecipeADList[P]));
    for P := 0 to ADDITIONALDATA_HEADERS.SalesOrderADList.Count - 1 do
      dispose(PADDITIONALDATA_DETAILS(ADDITIONALDATA_HEADERS.SalesOrderADList[P]));
    for P := 0 to ADDITIONALDATA_HEADERS.SalesOrderLineADList.Count - 1 do
      dispose(PADDITIONALDATA_DETAILS(ADDITIONALDATA_HEADERS.SalesOrderLineADList[P]));
    for P := 0 to ADDITIONALDATA_HEADERS.SalesOrderDeliveryADList.Count - 1 do
      dispose(PADDITIONALDATA_DETAILS(ADDITIONALDATA_HEADERS.SalesOrderDeliveryADList[P]));
    for P := 0 to ADDITIONALDATA_HEADERS.ProjectADList.Count - 1 do
      dispose(PADDITIONALDATA_DETAILS(ADDITIONALDATA_HEADERS.ProjectADList[P]));
    for P := 0 to ADDITIONALDATA_HEADERS.UserGenericGroupADList.Count - 1 do
      dispose(PADDITIONALDATA_DETAILS(ADDITIONALDATA_HEADERS.UserGenericGroupADList[P]));
    for P := 0 to ADDITIONALDATA_HEADERS.ColorADList.Count - 1 do
      dispose(PADDITIONALDATA_DETAILS(ADDITIONALDATA_HEADERS.ColorADList[P]));

    ADDITIONALDATA_HEADERS.productADList.Free;
    ADDITIONALDATA_HEADERS.fullItemKeyDecoderADList.Free;
    ADDITIONALDATA_HEADERS.productionDemandADList.Free;
    ADDITIONALDATA_HEADERS.productionDemandStepADList.Free;
    ADDITIONALDATA_HEADERS.RecipeADList.Free;
    ADDITIONALDATA_HEADERS.DesignADList.Free;
    ADDITIONALDATA_HEADERS.SalesOrderADList.Free;
    ADDITIONALDATA_HEADERS.SalesOrderLineADList.Free;
    ADDITIONALDATA_HEADERS.SalesOrderDeliveryADList.Free;
    ADDITIONALDATA_HEADERS.ProjectADList.Free;
    ADDITIONALDATA_HEADERS.UserGenericGroupADList.Free;
    ADDITIONALDATA_HEADERS.ColorADList.Free;
    dispose(PADDITIONALDATA_HEADERS(additionalDataList[I]));

  end;
  additionalDataList.Free;

  IniAppGlobals.Time_For_RecalcBatchProductionOrder := NOW;
  RecalcBatchProductionOrder;
  IniAppGlobals.Time_For_RecalcBatchProductionOrder := NOW - IniAppGlobals.Time_For_RecalcBatchProductionOrder;

  IniAppGlobals.Time_For_TryToGroupStepTimesRows := NOW;
  TryToGroupStepTimesRows;
  IniAppGlobals.Time_For_TryToGroupStepTimesRows := NOW - IniAppGlobals.Time_For_TryToGroupStepTimesRows;

  IniAppGlobals.Time_For_ClearStructMemoryList := NOW;
  ClearStructMemoryList;
  IniAppGlobals.Time_For_ClearStructMemoryList := NOW - IniAppGlobals.Time_For_ClearStructMemoryList;

  IniAppGlobals.Time_for_operationAfter_Big_SQL := Now - IniAppGlobals.Time_for_operationAfter_Big_SQL;


  IniAppGlobals.Time_For_BuildProdSchedProgress := NOW;
  if Assigned(ProgTask) then
  begin
    IniAppGlobals.Time_For_Wait_BuildProdSchedProgress := NOW;
    ProgTask.Wait;
    IniAppGlobals.Time_For_Wait_BuildProdSchedProgress := NOW - IniAppGlobals.Time_For_Wait_BuildProdSchedProgress;
    read_Progress_list := ProgTaskResult;
  end
  else
    read_Progress_list := BuildProdSchedProgress(m_NeedToMakeMerge, HandledWorkCenterSql, productionDemandCounters);
  IniAppGlobals.Time_For_BuildProdSchedProgress := NOW - IniAppGlobals.Time_For_BuildProdSchedProgress;
//  read_Progress_list := TList.Create;

  Handling_PROD_INFO_Notes(read_prod_info_list, m_NeedToMakeMerge, productionDemandCounters);

  for I := 0 to handledProductionDemandList.Count - 1 do
        dispose(PHANDLED_PRODUCTION_DEMANDS(handledProductionDemandList[I]));
  handledProductionDemandList.Free;

  for I := 0 to productionProgressTemplates.Count - 1 do
        dispose(PPRODUCTIONPROGRESSTEMPLATES(productionProgressTemplates[I]));
  productionProgressTemplates.Free;

  AD_Product_FieldsList.Free;
  AD_FullItemKeyDecoder_FieldsList.Free;
  AD_ProductionDemand_FieldsList.Free;
  AD_ProductionDemandStep_FieldsList.Free;
  TNA_List1.Free;
  TNA_List2.free;

  for I := itemTypeTemplates.Count - 1 downto 0 do
  begin
    for J := PITEMTYPETEMPLATES(itemTypeTemplates[I]).productionDemandTemplateList.Count - 1 downto 0 do
        dispose(PITEMTYPEPRODUCTIONDEMANDTEMPLATES(PITEMTYPETEMPLATES(itemTypeTemplates[I]).productionDemandTemplateList[J]));
    PITEMTYPETEMPLATES(itemTypeTemplates[I]).productionDemandTemplateList.Free;
    dispose(PITEMTYPETEMPLATES(itemTypeTemplates[I]));
  end;
  itemTypeTemplates.Free;

  for I := alternativeWarehouseList.Count - 1 downto 0 do
  begin
    ALT_WAREHOUSE_WKCS := PALT_WAREHOUSE_WKCS(alternativeWarehouseList[I]);

    for J := ALT_WAREHOUSE_WKCS.groupCodeList.Count - 1 downto 0 do
    begin
      ALT_WAREHOUSE_WKC_GROUPS := PALT_WAREHOUSE_WKC_GROUPS(ALT_WAREHOUSE_WKCS.groupCodeList[J]);

      for P := ALT_WAREHOUSE_WKC_GROUPS.itemTypeList.Count - 1 downto 0 do
      begin
        ALT_WAREHOUSE_WKC_GROUP_ITEM_TYPE := PALT_WAREHOUSE_WKC_GROUP_ITEM_TYPES(ALT_WAREHOUSE_WKC_GROUPS.itemTypeList[P]);

        for w := ALT_WAREHOUSE_WKC_GROUP_ITEM_TYPE.alternativeList.Count - 1 downto 0 do
        begin
          ALT_WAREHOUSE := PALT_WAREHOUSES(ALT_WAREHOUSE_WKC_GROUP_ITEM_TYPE.alternativeList[w]);
          dispose(ALT_WAREHOUSE);
        end;
        ALT_WAREHOUSE_WKC_GROUP_ITEM_TYPE.alternativeList.free;
        dispose(ALT_WAREHOUSE_WKC_GROUP_ITEM_TYPE);
      end;
      ALT_WAREHOUSE_WKC_GROUPS.itemTypeList.free;
      dispose(ALT_WAREHOUSE_WKC_GROUPS);

    end;
    ALT_WAREHOUSE_WKCS.groupCodeList.Free;
    dispose(ALT_WAREHOUSE_WKCS);
  end;
  alternativeWarehouseList.Free;

  for I := itemTypeLogicalWarehouseList.Count - 1 downto 0 do
  begin
    TEMTYPELOGICALWAREHOUSE_ITEMTYPES := PITEMTYPELOGICALWAREHOUSE_ITEMTYPES(itemTypeLogicalWarehouseList[I]);
    for J := TEMTYPELOGICALWAREHOUSE_ITEMTYPES.logicalWarehouseList.Count - 1 downto 0 do
    begin
      ITEMTYPELOGICALWAREHOUSE := PITEMTYPELOGICALWAREHOUSES(TEMTYPELOGICALWAREHOUSE_ITEMTYPES.logicalWarehouseList[J]);
      dispose(ITEMTYPELOGICALWAREHOUSE);
    end;
    TEMTYPELOGICALWAREHOUSE_ITEMTYPES.logicalWarehouseList.free;
    dispose(TEMTYPELOGICALWAREHOUSE_ITEMTYPES);
  end;
  itemTypeLogicalWarehouseList.Free;

  for I := List_Items.Count - 1 downto 0 do
  begin
    for J := PTITEMS(List_Items[I]).ItemWarehouseLink.Count - 1 downto 0 do
        dispose(PItemWarehouseLinkRec(PTITEMS(List_Items[I]).ItemWarehouseLink[J]));
      PTITEMS(List_Items[I]).ItemWarehouseLink.Free;

    if ColumnNamesSql_Items <> '' then
    begin
      if PTITEMS(List_Items[I]).ProductColumn_Created then
      begin
        PTITEMS(List_Items[I]).ProductColumn_Created := false;
        PTITEMS(List_Items[I]).ProductColumnNames.Free;
        PTITEMS(List_Items[I]).ProductColumnNames := nil;
        PTITEMS(List_Items[I]).ProductColumnValue.Free;
        PTITEMS(List_Items[I]).ProductColumnValue := nil;
      end;
      if PTITEMS(List_Items[I]).ProductSpecializedGreigeColumn_Created then
      begin
        PTITEMS(List_Items[I]).ProductSpecializedGreigeColumn_Created := false;
        PTITEMS(List_Items[I]).ProductSpecializedGreigeColumnNames.Free;
        PTITEMS(List_Items[I]).ProductSpecializedGreigeColumnNames := nil;
        PTITEMS(List_Items[I]).ProductSpecializedGreigeColumnValue.Free;
        PTITEMS(List_Items[I]).ProductSpecializedGreigeColumnValue := nil;
      end;
      if PTITEMS(List_Items[I]).ProductSpecializedSizeColumn_Created then
      begin
        PTITEMS(List_Items[I]).ProductSpecializedSizeColumn_Created := false;
        PTITEMS(List_Items[I]).ProductSpecializedSizeColumnNames.Free;
        PTITEMS(List_Items[I]).ProductSpecializedSizeColumnNames := nil;
        PTITEMS(List_Items[I]).ProductSpecializedSizeColumnValue.Free;
        PTITEMS(List_Items[I]).ProductSpecializedSizeColumnValue := nil;
      end;
      if PTITEMS(List_Items[I]).ProductSpecializedYarnColumn_Created then
      begin
        PTITEMS(List_Items[I]).ProductSpecializedYarnColumn_Created := false;
        PTITEMS(List_Items[I]).ProductSpecializedYarnColumnNames.Free;
        PTITEMS(List_Items[I]).ProductSpecializedYarnColumnNames := nil;
        PTITEMS(List_Items[I]).ProductSpecializedYarnColumnValue.Free;
        PTITEMS(List_Items[I]).ProductSpecializedYarnColumnValue := nil;
      end;
      if PTITEMS(List_Items[I]).FullItemKeyDecoderColumn_Created then
      begin
        PTITEMS(List_Items[I]).FullItemKeyDecoderColumn_Created := false;
        PTITEMS(List_Items[I]).FullItemKeyDecoderColumnNames.Free;
        PTITEMS(List_Items[I]).FullItemKeyDecoderColumnNames := nil;
        PTITEMS(List_Items[I]).FullItemKeyDecoderColumnValue.Free;
        PTITEMS(List_Items[I]).FullItemKeyDecoderColumnValue := nil;
      end;
    end;

    dispose(PTITEMS(List_Items[I]));
    List_Items[I] := nil;
  end;
  List_Items.free;

  for I := productionDemandCounters.Count - 1 downto 0 do
    dispose(PPRODUCTIONDEMANDCOUNTERS(productionDemandCounters[I]));
  productionDemandCounters.free;

  for I := ProjectNumberList.Count - 1 downto 0 do
    dispose(PTPROJECT_NUMBER(ProjectNumberList[I]));

  ProjectNumberList.Free;

  for I := List_Generic.Count - 1 downto 0 do
  begin
    PGeneric := PRGeneric(List_Generic[I]);
    PGeneric.ColumnNames.Free;
    PGeneric.ColumnValue.Free;
    dispose(PRGeneric(List_Generic[I]));
  end;
  List_Generic.free;

  for I := stepIdListForProgressList_PD.Count - 1 downto 0 do
  begin
    STEP_ID_PRODUCTIONDEMANDSANDORDERS := PSTEP_ID_PRODUCTIONDEMANDSANDORDERS(stepIdListForProgressList_PD[I]);
    if Assigned(STEP_ID_PRODUCTIONDEMANDSANDORDERS.workCenterList) then
    begin
      for j := STEP_ID_PRODUCTIONDEMANDSANDORDERS.workCenterList.Count - 1 downto 0 do
      begin
        STEP_ID_WORKCENTERS := PSTEP_ID_WORKCENTERS(STEP_ID_PRODUCTIONDEMANDSANDORDERS.workCenterList[J]);

        for P := STEP_ID_WORKCENTERS.operationList.Count - 1 downto 0 do
        begin
          STEP_ID_OPERATIONDATA := PSTEP_ID_OPERATIONDATAS(STEP_ID_WORKCENTERS.operationList[P]);
          dispose(STEP_ID_OPERATIONDATA);
        end;
        STEP_ID_WORKCENTERS.operationList.free;
        dispose(STEP_ID_WORKCENTERS);
      end;
      STEP_ID_PRODUCTIONDEMANDSANDORDERS.workCenterList.Free;
    end;

    if Assigned(STEP_ID_PRODUCTIONDEMANDSANDORDERS.operationList) then
    begin
      for j := STEP_ID_PRODUCTIONDEMANDSANDORDERS.operationList.Count - 1 downto 0 do
      begin
        STEP_ID_OPERATIONS := PSTEP_ID_OPERATIONS(STEP_ID_PRODUCTIONDEMANDSANDORDERS.operationList[J]);
        for P := STEP_ID_OPERATIONS.workCenterList.Count - 1 downto 0 do
        begin
          STEP_ID_OPERATIONDATA := PSTEP_ID_OPERATIONDATAS(STEP_ID_OPERATIONS.workCenterList[P]);
          dispose(STEP_ID_OPERATIONDATA);
        end;
        STEP_ID_OPERATIONS.workCenterList.Free;
        dispose(STEP_ID_OPERATIONS);
      end;
      STEP_ID_PRODUCTIONDEMANDSANDORDERS.operationList.Free;
    end;

    if Assigned(STEP_ID_PRODUCTIONDEMANDSANDORDERS.stepIdList) then
    begin
      for j := STEP_ID_PRODUCTIONDEMANDSANDORDERS.stepIdList.Count - 1 downto 0 do
        dispose(PSTEP_ID_STEPS(STEP_ID_PRODUCTIONDEMANDSANDORDERS.stepIdList[J]));
      STEP_ID_PRODUCTIONDEMANDSANDORDERS.stepIdList.Free;
    end;

    dispose(PSTEP_ID_PRODUCTIONDEMANDSANDORDERS(stepIdListForProgressList_PD[I]));
  end;

  stepIdListForProgressList_PD.Free;

  for I := stepIdListForProgressList_PO.Count - 1 downto 0 do
  begin
    STEP_ID_PRODUCTIONDEMANDSANDORDERS := PSTEP_ID_PRODUCTIONDEMANDSANDORDERS(stepIdListForProgressList_PO[I]);
    if Assigned(STEP_ID_PRODUCTIONDEMANDSANDORDERS.workCenterList) then
    begin
      for j := STEP_ID_PRODUCTIONDEMANDSANDORDERS.workCenterList.Count - 1 downto 0 do
      begin
        STEP_ID_WORKCENTERS := PSTEP_ID_WORKCENTERS(STEP_ID_PRODUCTIONDEMANDSANDORDERS.workCenterList[J]);

        for P := STEP_ID_WORKCENTERS.operationList.Count - 1 downto 0 do
        begin
          STEP_ID_OPERATIONDATA := PSTEP_ID_OPERATIONDATAS(STEP_ID_WORKCENTERS.operationList[P]);
          dispose(STEP_ID_OPERATIONDATA);
        end;
        STEP_ID_WORKCENTERS.operationList.free;
        dispose(STEP_ID_WORKCENTERS);
      end;
      STEP_ID_PRODUCTIONDEMANDSANDORDERS.workCenterList.Free;
    end;

    if Assigned(STEP_ID_PRODUCTIONDEMANDSANDORDERS.operationList) then
    begin
      for j := STEP_ID_PRODUCTIONDEMANDSANDORDERS.operationList.Count - 1 downto 0 do
      begin
        STEP_ID_OPERATIONS := PSTEP_ID_OPERATIONS(STEP_ID_PRODUCTIONDEMANDSANDORDERS.operationList[J]);
        for P := STEP_ID_OPERATIONS.workCenterList.Count - 1 downto 0 do
        begin
          STEP_ID_OPERATIONDATA := PSTEP_ID_OPERATIONDATAS(STEP_ID_OPERATIONS.workCenterList[P]);
          dispose(STEP_ID_OPERATIONDATA);
        end;
        STEP_ID_OPERATIONS.workCenterList.Free;
        dispose(STEP_ID_OPERATIONS);
      end;
      STEP_ID_PRODUCTIONDEMANDSANDORDERS.operationList.Free;
    end;

    if Assigned(STEP_ID_PRODUCTIONDEMANDSANDORDERS.stepIdList) then
    begin
      for j := STEP_ID_PRODUCTIONDEMANDSANDORDERS.stepIdList.Count - 1 downto 0 do
        dispose(PSTEP_ID_STEPS(STEP_ID_PRODUCTIONDEMANDSANDORDERS.stepIdList[J]));
      STEP_ID_PRODUCTIONDEMANDSANDORDERS.stepIdList.Free;
    end;

    dispose(PSTEP_ID_PRODUCTIONDEMANDSANDORDERS(stepIdListForProgressList_PO[I]));

  end;
  stepIdListForProgressList_PO_SL.Free;
  stepIdListForProgressList_PO.Free;
  WarpItemHandledStrList.Free;
  additionalDataWithRelationList.Free;
  prod_req_list.Free;
  alreadyAddedPROD_REQCONN.Free;
  Steps.free;
  Recipes.free;
  Designs.free;
//  LogReq.Free;
  AD_Recipe_FieldsList.Free;
  AD_design_FieldsList.Free;
  SqlPrint.free;

  if Assigned(DelProgTask2) then
    DelProgTask2.Wait;

  Result := true;
end;

//----------------------------------------------------------------------------//

function getRelevantMaterial(preqNo: String; StepNumber: integer; itemTypeCode: String;
                             fullItemKeyCode: String; materialList: TList;
                             startIndex: integer): PTMQMMT;
var
  i: integer;
  CUR_MATERIAL: PTMQMMT;
//  Multiplier, NumberOfEntries, LowestHighestValue : integer;
begin
  Result := nil;

{  for i:= startIndex to materialList.Count - 1 do
  begin
    CUR_MATERIAL := materialList.Items[i];

    if ( (CUR_MATERIAL.MT_PROD_REQ_Nr = preqNo) AND
         (CUR_MATERIAL.MT_PROD_TYPE = itemTypeCode) AND
         (CUR_MATERIAL.MT_PROD_CODE = fullItemKeyCode)
       )then
    begin
      Result := CUR_MATERIAL;
      startIndex := i;
      break;
    end;
  end; }

{  NumberOfEntries := materialList.Count;

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

      if (PTMQMMT(materialList[I]).MT_PROD_REQ_Nr < preqNo) then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMMT(materialList[I]).MT_PROD_REQ_Nr > preqNo) then
      begin
        i := i - Multiplier;
        Continue;
      end;

      if (PTMQMMT(materialList[I]).MT_PROD_TYPE < itemTypeCode) then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMMT(materialList[I]).MT_PROD_TYPE > itemTypeCode) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if (PTMQMMT(materialList[I]).MT_PROD_CODE < fullItemKeyCode) then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMMT(materialList[I]).MT_PROD_CODE > fullItemKeyCode) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      Result := PTMQMMT(materialList[I]);
      startIndex := I;

      Exit;

    end;
  end;   }

  for i:= startIndex to materialList.Count - 1 do
  begin
    if PTMQMMT(materialList[i]).MT_PROD_REQ_Nr <> preqNo then continue; // CAN NERVER HAPPEN : ERAN
    if PTMQMMT(materialList[I]).MT_PROD_TYPE <> itemTypeCode then  continue;
    if PTMQMMT(materialList[I]).MT_PROD_CODE <> fullItemKeyCode then continue;
    if PTMQMMT(materialList[I]).MT_PSTEP_ID <> StepNumber then continue;
    Result := PTMQMMT(materialList[I]);
    break;
  end;

end;

//----------------------------------------------------------------------------//

{procedure updateMaterialValuesFromAllocations(srvQryFD: TMqmQuery; HostQry: TMqmQuery;
                                              read_material_list: TList;
                                              purchaseOrderList: TList;
                                              addedKeys: TStringList;
                                              logicalWarehouseList: TList;
                                              read_ext_connection_list: TList;
                                              read_ext_info_hdr_list: TList;
                                              read_ext_info_list: TList;
                                              read_balance_header_list: TList;
                                              articleTypeList: TList;
                                              productionDemandCounters: TList;
                                              additionalDataList: TList;
                                              alternativeWarehouseList: TList);
var
  NEW_BALANCE_HEADER: PRecBH;
  hostSqlStr: String;
  settled: String;
  toProdReq: String;
  CUR_MATERIAL, MATERIAL_REC: PTMQMMT;
  balanceHandledByMqm: String;
  fieldNames: String;
  materialSearchStartIndex: integer;
  CompanyInUsed_ALOC : string;
  TempExt : Extended;
  S : string;
  TempStrQty, PREQ_NO : string;
begin
  UpdateOperation(_('Update materials from allocations'));

  if not GetCompanyLevelHandlingByEntityName('ALLOCATION',  CompanyInUsed_ALOC) then
     CompanyInUsed_ALOC := IniAppGlobals.CompanyCode;

  fieldNames := 'ALLOCATION.COMPANYCODE, ALLOCATION.COUNTERCODE, ALLOCATION.ORDERCODE, ' +
                'ALLOCATION.ITEMTYPECODE, ALLOCATION.DECOSUBCODE01, ALLOCATION.DECOSUBCODE02, ' +
                'ALLOCATION.DECOSUBCODE03, ALLOCATION.DECOSUBCODE04, ALLOCATION.DECOSUBCODE05, ' +
                'ALLOCATION.DECOSUBCODE06, ALLOCATION.DECOSUBCODE07, ALLOCATION.DECOSUBCODE08, ' +
                'ALLOCATION.DECOSUBCODE09, ALLOCATION.DECOSUBCODE10, ALLOCATION.DETAILTYPE, ' +
                'ALLOCATION.PROGRESSSTATUS, ALLOCATION.CODE, ALLOCATION.BASEPRIMARYQUANTITY, ' +
                'ALLOCATION.ORIGINTYPE, ALLOCATION.THEORETICISSUEDATE, ALLOCATION.ABSUNIQUEID, ALLOCATION.PROJECTCODE ';

  hostSqlStr := 'SELECT ' + fieldNames + ' FROM ALLOCATION LEFT JOIN PRODUCT ON ' +
                '( ' +
                  'ALLOCATION.COMPANYCODE = PRODUCT.COMPANYCODE AND ' +
                  'ALLOCATION.ITEMTYPECODE = PRODUCT.ITEMTYPECODE AND ' +
                  '( (ALLOCATION.DECOSUBCODE01 IS NULL) OR (ALLOCATION.DECOSUBCODE01 = PRODUCT.SUBCODE01) ) AND ' +
                  '( (ALLOCATION.DECOSUBCODE02 IS NULL) OR (ALLOCATION.DECOSUBCODE02 = PRODUCT.SUBCODE02) ) AND ' +
                  '( (ALLOCATION.DECOSUBCODE03 IS NULL) OR (ALLOCATION.DECOSUBCODE03 = PRODUCT.SUBCODE03) ) AND ' +
                  '( (ALLOCATION.DECOSUBCODE04 IS NULL) OR (ALLOCATION.DECOSUBCODE04 = PRODUCT.SUBCODE04) ) AND ' +
                  '( (ALLOCATION.DECOSUBCODE05 IS NULL) OR (ALLOCATION.DECOSUBCODE05 = PRODUCT.SUBCODE05) ) AND ' +
                  '( (ALLOCATION.DECOSUBCODE06 IS NULL) OR (ALLOCATION.DECOSUBCODE06 = PRODUCT.SUBCODE06) ) AND ' +
                  '( (ALLOCATION.DECOSUBCODE07 IS NULL) OR (ALLOCATION.DECOSUBCODE07 = PRODUCT.SUBCODE07) ) AND ' +
                  '( (ALLOCATION.DECOSUBCODE08 IS NULL) OR (ALLOCATION.DECOSUBCODE08 = PRODUCT.SUBCODE08) ) AND ' +
                  '( (ALLOCATION.DECOSUBCODE09 IS NULL) OR (ALLOCATION.DECOSUBCODE09 = PRODUCT.SUBCODE09) ) AND ' +
                  '( (ALLOCATION.DECOSUBCODE10 IS NULL) OR (ALLOCATION.DECOSUBCODE10 = PRODUCT.SUBCODE10) ) ' +
                ') ' +
                'WHERE ALLOCATION.COMPANYCODE = ' + QuotedStr(CompanyInUsed_ALOC) + ' ' +
                'AND ALLOCATION.DESTINATIONTYPE = ' + QuotedStr('4') + ' ' +
          //      'AND ALLOCATION.DESTINATIONTYPE = ' + QuotedStr('xxx') + ' ' + // Avi EOS
                'ORDER BY ALLOCATION.CODE, ALLOCATION.DETAILTYPE';

  HostQry.SQL.Text := hostSqlStr;
  HostQry.FetchOptions.RowsetSize := 5000;
  HostQry.Open;

  var ALOC_DETAILTYPE_FIELD        := HostQry.FieldByName('DETAILTYPE');
  var ALOC_PROGRESSSTATUS_FIELD    := HostQry.FieldByName('PROGRESSSTATUS');
  var ALOC_COMPANYCODE_FIELD       := HostQry.FieldByName('COMPANYCODE');
  var ALOC_COUNTERCODE_FIELD       := HostQry.FieldByName('COUNTERCODE');
  var ALOC_ORDERCODE_FIELD         := HostQry.FieldByName('ORDERCODE');
  var ALOC_ITEMTYPECODE_FIELD      := HostQry.FieldByName('ITEMTYPECODE');
  var ALOC_DECOSUBCODE01_FIELD     := HostQry.FieldByName('DECOSUBCODE01');
  var ALOC_DECOSUBCODE02_FIELD     := HostQry.FieldByName('DECOSUBCODE02');
  var ALOC_DECOSUBCODE03_FIELD     := HostQry.FieldByName('DECOSUBCODE03');
  var ALOC_DECOSUBCODE04_FIELD     := HostQry.FieldByName('DECOSUBCODE04');
  var ALOC_DECOSUBCODE05_FIELD     := HostQry.FieldByName('DECOSUBCODE05');
  var ALOC_DECOSUBCODE06_FIELD     := HostQry.FieldByName('DECOSUBCODE06');
  var ALOC_DECOSUBCODE07_FIELD     := HostQry.FieldByName('DECOSUBCODE07');
  var ALOC_DECOSUBCODE08_FIELD     := HostQry.FieldByName('DECOSUBCODE08');
  var ALOC_DECOSUBCODE09_FIELD     := HostQry.FieldByName('DECOSUBCODE09');
  var ALOC_DECOSUBCODE10_FIELD     := HostQry.FieldByName('DECOSUBCODE10');
  var ALOC_ORIGINTYPE_FIELD        := HostQry.FieldByName('ORIGINTYPE');
  var ALOC_CODE_FIELD              := HostQry.FieldByName('CODE');
  var ALOC_BASEPRIMARYQUANTITY_FIELD := HostQry.FieldByName('BASEPRIMARYQUANTITY');
  var ALOC_ABSUNIQUEID_FIELD       := HostQry.FieldByName('ABSUNIQUEID');
  var ALOC_THEORETICISSUEDATE_FIELD := HostQry.FieldByName('THEORETICISSUEDATE');

  while ( not HostQry.Eof ) do
  begin
    if (ALOC_DETAILTYPE_FIELD.AsString = '1') then
    begin

      if ( Trim(ALOC_PROGRESSSTATUS_FIELD.AsString) <> '3' ) then
        settled := '0'
      else
        settled := '1';

      materialSearchStartIndex := 0;
      CUR_MATERIAL := getRelevantMaterial(setStringLengthTo(ALOC_COMPANYCODE_FIELD.AsString, 3) +
                                           setStringLengthTo(ALOC_COUNTERCODE_FIELD.AsString, 8) +
                                           ALOC_ORDERCODE_FIELD.AsString,
                                          ALOC_ITEMTYPECODE_FIELD.AsString,
                                          getFullItemKeyCode(ALOC_ITEMTYPECODE_FIELD.AsString,
                                                             ALOC_DECOSUBCODE01_FIELD.AsString,
                                                             ALOC_DECOSUBCODE02_FIELD.AsString,
                                                             ALOC_DECOSUBCODE03_FIELD.AsString,
                                                             ALOC_DECOSUBCODE04_FIELD.AsString,
                                                             ALOC_DECOSUBCODE05_FIELD.AsString,
                                                             ALOC_DECOSUBCODE06_FIELD.AsString,
                                                             ALOC_DECOSUBCODE07_FIELD.AsString,
                                                             ALOC_DECOSUBCODE08_FIELD.AsString,
                                                             ALOC_DECOSUBCODE09_FIELD.AsString,
                                                             ALOC_DECOSUBCODE10_FIELD.AsString),
                                          read_material_list, materialSearchStartIndex);

      if (CUR_MATERIAL <> nil ) then
      begin
        if ( Trim(ALOC_ORIGINTYPE_FIELD.AsString) <> '1' ) then
        begin
          MATERIAL_REC :=        PTMQMMT(insertIntoMaterialList(CUR_MATERIAL.MT_PROD_REQ_Nr,
                                 IntToStr(CUR_MATERIAL.MT_PSTEP_ID),
                                 IntToStr(CUR_MATERIAL.MT_ORG_STEP),
                                 CUR_MATERIAL.MT_WKCTR_CODE,
                                 CUR_MATERIAL.MT_RES_CAT_CODE,
                                 CUR_MATERIAL.MT_RES_CODE,
                                 CUR_MATERIAL.MT_MACHIN_SETUP_CODE,
                                 CUR_MATERIAL.MT_ALTERNATIVE_CODE,
                                 CUR_MATERIAL.MT_PROD_TYPE,
                                 CUR_MATERIAL.MT_PROD_CODE,
                                 '_' + ALOC_CODE_FIELD.AsString,
                                 CUR_MATERIAL.MT_ISSUE_CODE,
                                 CUR_MATERIAL.MT_SEQ_ISSUED,
                                 CUR_MATERIAL.MT_MAT_BALACE,
                                 FloatToStr(CUR_MATERIAL.MT_QUANTITY_ALLOC),
                                 CUR_MATERIAL.MT_HIGH_DATE_ALLOC,
                                 CUR_MATERIAL.MT_SEARCH_MAT_BY_ALLOC,
                                 settled,
                                 '0',
                                 ALOC_BASEPRIMARYQUANTITY_FIELD.AsString,
                               //  CUR_MATERIAL.PRODUCTIONDEMANDTEMPLATECODE,
                               //  CUR_MATERIAL.PRODUCTIONDEMANDCOUNTERCODE,
                                 '',
                                 '',
                                 read_material_list,
                                 alternativeWarehouseList, false,
                                 true, '', nil, nil, nil, productionDemandCounters, nil
                                 ));

 //       if ( Trim(HostQry.FieldByName('ORIGINTYPE').AsString) <> '1' ) then
 //       begin
          if assigned(MATERIAL_REC) then
          begin
            if m_NeedToMakeMerge then
            begin
              PREQ_NO := MATERIAL_REC.MT_PROD_REQ_Nr;
              if CheckMerge(PREQ_NO, setStringLengthTo(ALOC_COUNTERCODE_FIELD.AsString, 8), productionDemandCounters) then
              begin
                MATERIAL_REC.MT_FAMILYCODE := PREQ_NO;
              end;
            end;
          end;

          CUR_MATERIAL.MT_REQ_QUANTITY := (CUR_MATERIAL.MT_REQ_QUANTITY -
                                                    ALOC_BASEPRIMARYQUANTITY_FIELD.AsFloat);

          TempExt := Frac(CUR_MATERIAL.MT_REQ_QUANTITY);
          S := FloatToStr(TempExt);
          if Length(S) > 4 then
          begin
            S := Copy(s, 2, 3);
            TempStrQty := FloatToStr(trunc(CUR_MATERIAL.MT_REQ_QUANTITY));
            TempStrQty := TempStrQty + s;
            CUR_MATERIAL.MT_REQ_QUANTITY := StrToFloat(TempStrQty);
          end;

          balanceHandledByMqm := isBalanceHandledByMqm(articleTypeList, ALOC_ITEMTYPECODE_FIELD.AsString,
                                       additionalDataList,
                                       ALOC_ABSUNIQUEID_FIELD.AsString);


          // commented by erbil on 24.09.2009
          if (balanceHandledByMqm = '0') then
          begin
            New(NEW_BALANCE_HEADER);
            NEW_BALANCE_HEADER.BH_ProdType := ALOC_ITEMTYPECODE_FIELD.AsString;
            NEW_BALANCE_HEADER.BH_ProdCode :=getFullItemKeyCode(ALOC_ITEMTYPECODE_FIELD.AsString,
                                                      ALOC_DECOSUBCODE01_FIELD.AsString,
                                                      ALOC_DECOSUBCODE02_FIELD.AsString,
                                                      ALOC_DECOSUBCODE03_FIELD.AsString,
                                                      ALOC_DECOSUBCODE04_FIELD.AsString,
                                                      ALOC_DECOSUBCODE05_FIELD.AsString,
                                                      ALOC_DECOSUBCODE06_FIELD.AsString,
                                                      ALOC_DECOSUBCODE07_FIELD.AsString,
                                                      ALOC_DECOSUBCODE08_FIELD.AsString,
                                                      ALOC_DECOSUBCODE09_FIELD.AsString,
                                                      ALOC_DECOSUBCODE10_FIELD.AsString);
            NEW_BALANCE_HEADER.BH_netGroupCode := '_' + ALOC_CODE_FIELD.AsString;
            NEW_BALANCE_HEADER.BH_dueDate := ALOC_THEORETICISSUEDATE_FIELD.AsDateTime;
            NEW_BALANCE_HEADER.BH_quant := ALOC_BASEPRIMARYQUANTITY_FIELD.AsFloat;

            // Changed by Erbil  on 09.09.2008
            NEW_BALANCE_HEADER.BH_InfoArea := 'Material allocation';
            //NEW_BALANCE_HEADER.BH_INFO_AREA := '';

            NEW_BALANCE_HEADER.BH_usrCg := 'USERNAME';
            NEW_BALANCE_HEADER.BH_usrTmCg := Now;

            read_balance_header_list.Add(NEW_BALANCE_HEADER)
          end;
        end
        else
        begin
          CUR_MATERIAL.MT_QUANTITY_ALLOC := StrToFloat(addUpFields(FloatToStr(CUR_MATERIAL.MT_QUANTITY_ALLOC), ALOC_BASEPRIMARYQUANTITY_FIELD.AsString, false));
          TempExt := Frac(CUR_MATERIAL.MT_QUANTITY_ALLOC);
          S := FloatToStr(TempExt);
          if Length(S) > 4 then
          begin
            S := Copy(s, 2, 3);
            TempStrQty := FloatToStr(trunc(CUR_MATERIAL.MT_QUANTITY_ALLOC));
            TempStrQty := TempStrQty + s;
            CUR_MATERIAL.MT_QUANTITY_ALLOC := StrToFloat(TempStrQty);
          end;
        end;
      end;

      toProdReq := setStringLengthTo(ALOC_COMPANYCODE_FIELD.AsString, 3) +
                     setStringLengthTo(ALOC_COUNTERCODE_FIELD.AsString, 8) +
                     ALOC_ORDERCODE_FIELD.AsString;

      HostQry.Next;
    end
    else
    begin
      if (Trim(ALOC_ORIGINTYPE_FIELD.AsString) = '2') then
      begin
        insertIntoEXTtables(srvQryFD, setStringLengthTo(ALOC_COMPANYCODE_FIELD.AsString, 3) +
                                    setStringLengthTo(ALOC_COUNTERCODE_FIELD.AsString, 8) +
                                    ALOC_ORDERCODE_FIELD.AsString,
                            toProdReq, '1',
                            //itemTypeCode, demandCounterCode, demandTemplateCode,
                            '','','',
                            purchaseOrderList, productionDemandCounters, addedKeys,
                            read_ext_connection_list, read_ext_info_hdr_list, read_ext_info_list);
      end;

      HostQry.Next;
    end;
  end;

  HostQry.Close;

  createNegativeBalancesFromAllocations(srvQryFD, HostQry, logicalWarehouseList, read_balance_header_list,
                                        articleTypeList, additionalDataList, CompanyInUsed_ALOC);

end;

//----------------------------------------------------------------------------//

procedure createNegativeBalancesFromAllocations(srvQryFD: TMqmQuery; HostQry: TMqmQuery;
                                                logicalWarehouseList: TList;
                                                read_balance_header_list: TList;
                                                articleTypeList: TList;
                                                additionalDataList: TList; CompanyCodeInUsed : string);
var
  hostSqlStr: String;

  nameOfOT: String;
  columnsFromOT: String;
  clauseForOT: String;
  originType: String;
  i: Integer;
begin
  clauseForOT := ' AND A.COMPANYCODE = OT.COMPANYCODE' +
                 ' AND A.COUNTERCODE = OT.COUNTERCODE' +
                 ' AND A.ORDERCODE = OT.CODE';

  for i := 0 to 3 do
  begin
    case i of
      0:
      begin
        columnsFromOT := ', A.LOGICALWAREHOUSECODE WAREHOUSECODE';
        nameOfOT := '';
        originType := '1';
      end;
      1:
      begin
        columnsFromOT := ', OT.WAREHOUSECODE WAREHOUSECODE, ' +
                         'OT.REQUIREDDUEDATE DATETOUSE';
        nameOfOT := ', PURCHASEORDER OT';
        originType := '2';
      end;
      2:
      begin
        columnsFromOT := ', OT.ENTRYWAREHOUSECODE WAREHOUSECODE, ' +
                         'OT.FINALPLANNEDDATE DATETOUSE';
        nameOfOT := ', PRODUCTIONDEMAND OT';
        originType := '4';
      end;
      3:
      begin
        columnsFromOT := ', OT.WAREHOUSECODE WAREHOUSECODE, ' +
                         'OT.DEFINITIVEDOCUMENTDATE DATETOUSE';
        nameOfOT := ', INTERNALDOCUMENT OT';

        clauseForOT := ' AND A.COMPANYCODE = OT.COMPANYCODE' +
                       ' AND A.COUNTERCODE = OT.DEFINITIVECOUNTERCODE' +
                       ' AND A.ORDERCODE = OT.DEFINITIVECODE';
        originType := '5';
      end;
    end;

    hostSqlStr := 'SELECT A.ITEMTYPECODE, A.DECOSUBCODE01, A.DECOSUBCODE02, ' +
                  'A.DECOSUBCODE03, A.DECOSUBCODE04, A.DECOSUBCODE05, ' +
                  'A.DECOSUBCODE06, A.DECOSUBCODE07, A.DECOSUBCODE08, ' +
                  'A.DECOSUBCODE09, A.DECOSUBCODE10, A.BASEPRIMARYQUANTITY, ' +
                  'A.COUNTERCODE, A.ORDERCODE, P.ABSUNIQUEID' + //, P.*
                  columnsFromOT + ' FROM ALLOCATION A LEFT JOIN PRODUCT P ON ' +
                  '( ' +
                    'A.COMPANYCODE = P.COMPANYCODE AND ' +
                     'A.ITEMTYPECODE = P.ITEMTYPECODE AND ' +
                    '( (A.DECOSUBCODE01 IS NULL) OR (A.DECOSUBCODE01 = P.SUBCODE01) ) AND ' +
                    '( (A.DECOSUBCODE02 IS NULL) OR (A.DECOSUBCODE02 = P.SUBCODE02) ) AND ' +
                    '( (A.DECOSUBCODE03 IS NULL) OR (A.DECOSUBCODE03 = P.SUBCODE03) ) AND ' +
                    '( (A.DECOSUBCODE04 IS NULL) OR (A.DECOSUBCODE04 = P.SUBCODE04) ) AND ' +
                    '( (A.DECOSUBCODE05 IS NULL) OR (A.DECOSUBCODE05 = P.SUBCODE05) ) AND ' +
                    '( (A.DECOSUBCODE06 IS NULL) OR (A.DECOSUBCODE06 = P.SUBCODE06) ) AND ' +
                    '( (A.DECOSUBCODE07 IS NULL) OR (A.DECOSUBCODE07 = P.SUBCODE07) ) AND ' +
                    '( (A.DECOSUBCODE08 IS NULL) OR (A.DECOSUBCODE08 = P.SUBCODE08) ) AND ' +
                    '( (A.DECOSUBCODE09 IS NULL) OR (A.DECOSUBCODE09 = P.SUBCODE09) ) AND ' +
                    '( (A.DECOSUBCODE10 IS NULL) OR (A.DECOSUBCODE10 = P.SUBCODE10) ) ' +
                  ') ' + nameOfOT + ' ' +
                  ' WHERE A.COMPANYCODE = ' + QuotedStr(CompanyCodeInUsed) + ' AND ' +
                  'A.DESTINATIONTYPE = ' + QuotedStr('4') + ' AND ' +
                  'A.ORIGINTYPE = ' + QuotedStr(originType) + ' AND ' +
                  'A.DETAILTYPE = ' + QuotedStr('0');

    if originType <> '1' then
      hostSqlStr := hostSqlStr + clauseForOT + ' ORDER BY A.ORDERCODE'
    else
      hostSqlStr := hostSqlStr + ' ORDER BY A.ORDERCODE';

    HostQry.SQL.Text := hostSqlStr;
    hostQry.Open;

    while ( not hostQry.Eof ) do
    begin
      executeInsertCommandForBalanceHeader_List(HostQry, (originType <> '1'),
                                                logicalWarehouseList, read_balance_header_list,
                                                articleTypeList, additionalDataList);
      HostQry.Next;
    end;

    hostQry.Close;
  end;
end;

//----------------------------------------------------------------------------//    }

{procedure executeInsertCommandForBalanceHeader_List(HostQry: TMqmQuery; useDate: boolean;
                                               logicalWarehouseList: TList;
                                               read_balance_header_list: TList;
                                               articleTypeList: TList;
                                               additionalDataList: TList);
var
  NEW_BALANCE_HEADER: PRecBH;
  tempDate: TDate;
  dateToUse: TDate;

  balanceHandledByMqm: String;
  strData: String;
begin
  balanceHandledByMqm := isBalanceHandledByMqm(articleTypeList, HostQry.FieldByName('ITEMTYPECODE').AsString,
                             additionalDataList,
                             HostQry.FieldByName('ABSUNIQUEID').AsString);

  // commented by erbil on 24.09.2009
  if (balanceHandledByMqm = '0') then
  begin

    tempDate := Now;

    if useDate then
      dateToUse := HostQry.FieldByName('DATETOUSE').AsDateTime
    else
      dateToUse := tempDate;

    New(NEW_BALANCE_HEADER);
    NEW_BALANCE_HEADER.BH_ProdType := HostQry.FieldByName('ITEMTYPECODE').AsString;
    NEW_BALANCE_HEADER.BH_ProdCode := getFullItemKeyCode(HostQry.FieldByName('ITEMTYPECODE').AsString,
                                              HostQry.FieldByName('DECOSUBCODE01').AsString,
                                              HostQry.FieldByName('DECOSUBCODE02').AsString,
                                              HostQry.FieldByName('DECOSUBCODE03').AsString,
                                              HostQry.FieldByName('DECOSUBCODE04').AsString,
                                              HostQry.FieldByName('DECOSUBCODE05').AsString,
                                              HostQry.FieldByName('DECOSUBCODE06').AsString,
                                              HostQry.FieldByName('DECOSUBCODE07').AsString,
                                              HostQry.FieldByName('DECOSUBCODE08').AsString,
                                              HostQry.FieldByName('DECOSUBCODE09').AsString,
                                              HostQry.FieldByName('DECOSUBCODE10').AsString);
    NEW_BALANCE_HEADER.BH_netGroupCode := getMqmGroupCode(HostQry.FieldByName('WAREHOUSECODE').AsString,
                                                            logicalWarehouseList);
    NEW_BALANCE_HEADER.BH_dueDate := dateToUse;
  //  NEW_BALANCE_HEADER.BH_quant := '-' + HostQry.FieldByName('BASEPRIMARYQUANTITY').AsString;
    NEW_BALANCE_HEADER.BH_quant := (-1) * HostQry.FieldByName('BASEPRIMARYQUANTITY').AsFloat; // avi

    // Changed by Erbil  on 09.09.2008
    if (Trim(HostQry.FieldByName('COUNTERCODE').AsString) <> '') then
      strData := 'Negative stock from allocation:' +
                 setStringLengthTo(HostQry.FieldByName('COUNTERCODE').AsString, 8) +
                 HostQry.FieldByName('ORDERCODE').AsString
    else
      strData := 'Negative stock from allocation';

    NEW_BALANCE_HEADER.BH_InfoArea := copy(strData, 1, 70);
    //NEW_BALANCE_HEADER.BH_INFO_AREA := '';

    NEW_BALANCE_HEADER.BH_usrCg := 'USERNAME';
    NEW_BALANCE_HEADER.BH_usrTmCg := tempDate;

    read_balance_header_list.Add(NEW_BALANCE_HEADER)
  end;
end;  }

//----------------------------------------------------------------------------//

function getRelevantProducedArticle(preqNo: String; fullItemKeyCode: String;
                                    netGroupCode: String; read_produced_article_List: TList;
                                    isFromAllocation: boolean): PTMQMPA;
var
  i: integer;
  CUR_PRODUCED_ARTICLE: PTMQMPA;
  prefix: String;
begin
  Result := nil;

  if (isFromAllocation) then
    prefix := '_ '
  else
    prefix := ' ';

  for i := 0 to read_produced_article_List.Count - 1 do
  begin
    CUR_PRODUCED_ARTICLE := read_produced_article_List.Items[i];

    if ( (CUR_PRODUCED_ARTICLE.PA_PROD_REQ_NR = preqNo) AND
         (CUR_PRODUCED_ARTICLE.PA_PROD_CODE = fullItemKeyCode) AND
         (CUR_PRODUCED_ARTICLE.PA_NET_GROUP_Code = prefix + netGroupCode)
       )then
    begin
      Result := CUR_PRODUCED_ARTICLE;
      break;
    end;
  end;
end;

//----------------------------------------------------------------------------//

{procedure updateProducedArticleValuesFromAllocations(srvQryFD: TMqmQuery; HostQry: TMqmQuery;
                                                     read_produced_article_list: TList;
                                                     salesOrderList: TList;
                                                     addedKeys: TStringList;
                                                     logicalWarehouseList: TList;
                                                     read_prod_reqConn_list: TList;
                                                     read_ext_connection_list: TList;
                                                     read_ext_info_hdr_list: TList;
                                                     productionDemandCounters : TList;
                                                     read_ext_info_list: TList;
                                                     alreadyAddedPROD_REQCONN: TStringList);
var
  hostSqlStr: String;
  CUR_PRODUCED_ARTICLE: PTMQMPA;
  CUR_PRODUCED_ARTICLE_FROM_ALLOCATION: PTMQMPA;
  settled: String;
  toProdReq: String;
  //alreadyAddedPROD_REQCONN: TStringList;
  fieldNames: String;
  CompanyInUsed_ALOC : string;
begin
  UpdateOperation(_('Update produced articals from allocations'));

  if not GetCompanyLevelHandlingByEntityName('ALLOCATION',  CompanyInUsed_ALOC) then
     CompanyInUsed_ALOC := IniAppGlobals.CompanyCode;

  fieldNames := 'ALLOCATION.COMPANYCODE, ALLOCATION.COUNTERCODE, ALLOCATION.ORDERCODE, ' +
                'ALLOCATION.PROGRESSSTATUS, ALLOCATION.ITEMTYPECODE, ALLOCATION.DECOSUBCODE01, ' +
                'ALLOCATION.DECOSUBCODE02, ALLOCATION.DECOSUBCODE03, ALLOCATION.DECOSUBCODE04, ' +
                'ALLOCATION.DECOSUBCODE05, ALLOCATION.DECOSUBCODE06, ALLOCATION.DECOSUBCODE07, ' +
                'ALLOCATION.DECOSUBCODE08, ALLOCATION.DECOSUBCODE09, ALLOCATION.DECOSUBCODE10, ' +
                'ALLOCATION.LOGICALWAREHOUSECODE, ALLOCATION.DETAILTYPE, ALLOCATION.DESTINATIONTYPE, ' +
                'ALLOCATION.BASEPRIMARYQUANTITY, ALLOCATION.PROJECTCODE, PRODUCTIONDEMAND.TEMPLATECODE AS PD_TEMPLATECODE';

  hostSqlStr := 'SELECT ' + fieldNames + ' FROM ALLOCATION ' +
                'LEFT JOIN PRODUCTIONDEMAND ON ' +
                '(ALLOCATION.COMPANYCODE = PRODUCTIONDEMAND.COMPANYCODE AND ' +
                  'ALLOCATION.COUNTERCODE = PRODUCTIONDEMAND.COUNTERCODE AND ' +
                  'ALLOCATION.ORDERCODE = PRODUCTIONDEMAND.CODE) ' +
                'WHERE ALLOCATION.COMPANYCODE = ' + QuotedStr(CompanyInUsed_ALOC) + ' ' +
                'AND ALLOCATION.ORIGINTYPE = ' + QuotedStr('4') + ' ' +
                'ORDER BY ALLOCATION.CODE, ALLOCATION.DETAILTYPE DESC';

  HostQry.SQL.Text := hostSqlStr;
  hostQry.Open;

  //alreadyAddedPROD_REQCONN := TStringList.Create;

  while ( not hostQry.Eof ) do
  begin
    if (HostQry.FieldByName('DETAILTYPE').AsString = '1') then
    begin
      toProdReq := setStringLengthTo(HostQry.FieldByName('COMPANYCODE').AsString, 3) +
                     setStringLengthTo(HostQry.FieldByName('COUNTERCODE').AsString, 8) +
                     HostQry.FieldByName('ORDERCODE').AsString;

      HostQry.Next;
    end
    else
    begin
      if ( HostQry.FieldByName('PROGRESSSTATUS').AsString <> '3' ) then //SETTLED
        settled := '0'
      else
        settled := '1';

      CUR_PRODUCED_ARTICLE := getRelevantProducedArticle(setStringLengthTo(HostQry.FieldByName('COMPANYCODE').AsString, 3) +
                                                          setStringLengthTo(HostQry.FieldByName('COUNTERCODE').AsString, 8) +
                                                          HostQry.FieldByName('ORDERCODE').AsString,
                                                        getFullItemKeyCode(HostQry.FieldByName('ITEMTYPECODE').AsString,
                                                                           HostQry.FieldByName('DECOSUBCODE01').AsString,
                                                                           HostQry.FieldByName('DECOSUBCODE02').AsString,
                                                                           HostQry.FieldByName('DECOSUBCODE03').AsString,
                                                                           HostQry.FieldByName('DECOSUBCODE04').AsString,
                                                                           HostQry.FieldByName('DECOSUBCODE05').AsString,
                                                                           HostQry.FieldByName('DECOSUBCODE06').AsString,
                                                                           HostQry.FieldByName('DECOSUBCODE07').AsString,
                                                                           HostQry.FieldByName('DECOSUBCODE08').AsString,
                                                                           HostQry.FieldByName('DECOSUBCODE09').AsString,
                                                                           HostQry.FieldByName('DECOSUBCODE10').AsString),
                                                        getMqmGroupCode(HostQry.FieldByName('LOGICALWAREHOUSECODE').AsString,
                                                                        logicalWarehouseList),
                                                        read_produced_article_list,
                                                        false);

      if ( alreadyAddedPROD_REQCONN.IndexOf( setStringLengthTo(HostQry.FieldByName('COMPANYCODE').AsString, 3) +
                                             setStringLengthTo(HostQry.FieldByName('COUNTERCODE').AsString, 8) +
                                             HostQry.FieldByName('ORDERCODE').AsString +
                                             toProdReq ) <> -1 ) then
      begin
        insertIntoPROD_REQCONN_List(setStringLengthTo(HostQry.FieldByName('COMPANYCODE').AsString, 3) +
                                      setStringLengthTo(HostQry.FieldByName('COUNTERCODE').AsString, 8) +
                                      HostQry.FieldByName('ORDERCODE').AsString,
                                    toProdReq,
                                    HostQry.FieldByName('ITEMTYPECODE').AsString,
                                    HostQry.FieldByName('COUNTERCODE').AsString,
                                    HostQry.FieldByName('PD_TEMPLATECODE').AsString,
                                    productionDemandCounters,
                                    read_prod_reqConn_list);

        alreadyAddedPROD_REQCONN.Add(setStringLengthTo(HostQry.FieldByName('COMPANYCODE').AsString, 3) +
                                     setStringLengthTo(HostQry.FieldByName('COUNTERCODE').AsString, 8) +
                                     HostQry.FieldByName('ORDERCODE').AsString +
                                     toProdReq);
      end;



      if (Trim(HostQry.FieldByName('DESTINATIONTYPE').AsString) = '2') then
      begin
        insertIntoEXTtables(srvQryFD, setStringLengthTo(HostQry.FieldByName('COMPANYCODE').AsString, 3) +
                                    setStringLengthTo(HostQry.FieldByName('COUNTERCODE').AsString, 8) +
                                    HostQry.FieldByName('ORDERCODE').AsString,
                            toProdReq, '2',
                            HostQry.FieldByName('ITEMTYPECODE').AsString,
                            HostQry.FieldByName('COUNTERCODE').AsString,
                            HostQry.FieldByName('PD_TEMPLATECODE').AsString,
                            salesOrderList, productionDemandCounters, addedKeys, read_ext_connection_list,
                            read_ext_info_hdr_list, read_ext_info_list);
      end;

      if (CUR_PRODUCED_ARTICLE <> nil ) then
      begin
        if ((Trim(HostQry.FieldByName('DESTINATIONTYPE').AsString) = '4') AND
            (handledProductionDemands.IndexOf(setStringLengthTo(HostQry.FieldByName('COUNTERCODE').AsString, 8) +
                                              HostQry.FieldByName('ORDERCODE').AsString) <> -1)
           ) then
        begin
          CUR_PRODUCED_ARTICLE_FROM_ALLOCATION := getRelevantProducedArticle(setStringLengthTo(HostQry.FieldByName('COMPANYCODE').AsString, 3) +
                                                          setStringLengthTo(HostQry.FieldByName('COUNTERCODE').AsString, 8) +
                                                          HostQry.FieldByName('ORDERCODE').AsString,
                                                        getFullItemKeyCode(HostQry.FieldByName('ITEMTYPECODE').AsString,
                                                                           HostQry.FieldByName('DECOSUBCODE01').AsString,
                                                                           HostQry.FieldByName('DECOSUBCODE02').AsString,
                                                                           HostQry.FieldByName('DECOSUBCODE03').AsString,
                                                                           HostQry.FieldByName('DECOSUBCODE04').AsString,
                                                                           HostQry.FieldByName('DECOSUBCODE05').AsString,
                                                                           HostQry.FieldByName('DECOSUBCODE06').AsString,
                                                                           HostQry.FieldByName('DECOSUBCODE07').AsString,
                                                                           HostQry.FieldByName('DECOSUBCODE08').AsString,
                                                                           HostQry.FieldByName('DECOSUBCODE09').AsString,
                                                                           HostQry.FieldByName('DECOSUBCODE10').AsString),
                                                        getMqmGroupCode(HostQry.FieldByName('LOGICALWAREHOUSECODE').AsString,
                                                                        logicalWarehouseList),
                                                        read_produced_article_list,
                                                        true);

          if (CUR_PRODUCED_ARTICLE_FROM_ALLOCATION = nil ) then
            insertIntoPRODUCED_ARTICLE_List(CUR_PRODUCED_ARTICLE.PA_PROD_REQ_NR,
                                            CUR_PRODUCED_ARTICLE.PA_SEQUENCE,
                                            CUR_PRODUCED_ARTICLE.PA_PROD_CODE,
                                            '_' + CUR_PRODUCED_ARTICLE.PA_NET_GROUP_CODE,
                                            CUR_PRODUCED_ARTICLE.PA_ALL_REQ,
                                            CUR_PRODUCED_ARTICLE.PA_PROD_BALANCE,
                                            CUR_PRODUCED_ARTICLE.PA_RESOURCE,
                                            settled,
                                            FloatToStr(CUR_PRODUCED_ARTICLE.PA_REQ_QUANTY),
                                            FloatToStr(CUR_PRODUCED_ARTICLE.PA_QTY_PRODUCED),
                                            FloatToStr(CUR_PRODUCED_ARTICLE.PA_QTY_ALL),
                                            CUR_PRODUCED_ARTICLE.PRODUCTIONDEMANDTEMPLATECODE,
                                            CUR_PRODUCED_ARTICLE.PRODUCTIONDEMANDCOUNTERCODE,
                                            CUR_PRODUCED_ARTICLE.ITEMTYPECODE,
                                            read_produced_article_list,
                                            true, '', nil, nil, nil, productionDemandCounters, nil
                                           )
          else
            CUR_PRODUCED_ARTICLE_FROM_ALLOCATION.PA_REQ_QUANTY := (CUR_PRODUCED_ARTICLE_FROM_ALLOCATION.PA_REQ_QUANTY +
                                                                               HostQry.FieldByName('BASEPRIMARYQUANTITY').AsFloat);


          CUR_PRODUCED_ARTICLE.PA_REQ_QUANTY := (CUR_PRODUCED_ARTICLE.PA_REQ_QUANTY -
                                                            HostQry.FieldByName('BASEPRIMARYQUANTITY').AsFloat);


        end
        else
        begin
          CUR_PRODUCED_ARTICLE.PA_QTY_ALL := (CUR_PRODUCED_ARTICLE.PA_QTY_ALL +
                                                          HostQry.FieldByName('BASEPRIMARYQUANTITY').AsFloat);

        end;
      end;

      HostQry.Next;
    end;
  end;

  HostQry.Close;
end;
}
//----------------------------------------------------------------------------//

procedure insertIntoEXTtables(srvQryFD: TMqmQuery; prodReqNo: String;
                              connectedKey: String; connectionType: String;
                              itemTypeCode: String; demandCounterCode: String;
                              demandTemplateCode: String; listToCheck: TList;
                              productionDemandCounters : TList;
                              addedList: TStringList; read_ext_connection_list: TList;
                              read_ext_info_hdr_list: TList; read_ext_info_list: TList);
var
  tempDate: TDate;
  info: String;
  dueDate: String;

  CUR_SALESORDER: PSALESORDERS;
  CUR_PURCHASEORDER: PPURCHASEORDERS;
  index: integer;
begin
  tempDate := Now;

  if (connectionType = '1') then
  begin
    index := searchInList(listToCheck, 17, Trim(connectedKey), 0, listToCheck.Count - 1);

    if ( index <> -1 ) then
    begin
      CUR_PURCHASEORDER := listToCheck.Items[index];
      dueDate := CUR_PURCHASEORDER.ORDERDATE;
      info := CUR_PURCHASEORDER.DESCRIPTION;
    end
    else
    begin
      dueDate := DateToStr(Now);
      info := '';
    end;
  end
  else
  begin
    index := searchInList(listToCheck, 16, Trim(connectedKey), 0, listToCheck.Count - 1);

    if ( index <> -1 ) then
    begin
      CUR_SALESORDER := listToCheck.Items[index];
      dueDate := CUR_SALESORDER.ORDERDATE;
      info := CUR_SALESORDER.DESCRIPTION;
    end
    else
    begin
      dueDate := DateToStr(Now);
      info := '';
    end;
  end;

  insertIntoEXT_CONNECTION_List(prodReqNo, connectedKey, tempDate, itemTypeCode,
                                demandCounterCode, productionDemandCounters, demandTemplateCode, read_ext_connection_list);

  if (addedList.IndexOf(connectedKey) = -1) then
  begin
    insertIntoEXT_INFO_HDR_List(connectedKey, connectionType, itemTypeCode,
                                demandCounterCode, demandTemplateCode, dueDate,
                                tempDate, read_ext_info_hdr_list);
    insertIntoEXT_INFO_List(connectedKey, info, itemTypeCode, demandCounterCode,
                            demandTemplateCode, tempDate, productionDemandCounters, read_ext_info_list);
    addedList.Add(connectedKey);
  end;
end;

//----------------------------------------------------------------------------//

procedure insertIntoEXT_CONNECTION_List(prodReqNo: String; connectedKey: String;
                                        dateToUse: TDate; itemTypeCode: String;
                                        demandCounterCode: String;
                                        productionDemandCounters : TList;
                                        demandTemplateCode: String;
                                        read_ext_connection_list: TList);
var
  NEW_EXT_CONNECTION: PTMQMEC;
  PREQ_NO : string;
begin
  New(NEW_EXT_CONNECTION);
  NEW_EXT_CONNECTION.EC_PREQ_NO := prodReqNo;
  NEW_EXT_CONNECTION.EC_CONNE_KEY := connectedKey;
  NEW_EXT_CONNECTION.EC_NUM_LEVELS := 0;
  NEW_EXT_CONNECTION.EC_CONN_CERTENT_LEVEL := '1';
  NEW_EXT_CONNECTION.EC_USR_CG := 'USERNAME';
  NEW_EXT_CONNECTION.EC_USR_TM_CG := dateToUse;

  PREQ_NO := NEW_EXT_CONNECTION.EC_PREQ_NO;
  if CheckMerge(PREQ_NO, setStringLengthTo(demandCounterCode , 8), productionDemandCounters) then
  begin
    NEW_EXT_CONNECTION.EC_FAMILYCODE := PREQ_NO;
  end;

  read_ext_connection_list.Add(NEW_EXT_CONNECTION);
end;

//----------------------------------------------------------------------------//

procedure insertIntoEXT_INFO_HDR_List(connectedKey: String; connectionType: String;
                                      itemTypeCode: String; demandCounterCode: String;
                                      demandTemplateCode: String; dueDate: String;
                                      dateToUse: TDate; read_ext_info_hdr_list: TList);
var
  NEW_EXT_INFO_HDR: PRecEH;
begin
  New(NEW_EXT_INFO_HDR);
  NEW_EXT_INFO_HDR.EH_ConnKey := connectedKey;
  NEW_EXT_INFO_HDR.EH_ConnType := connectionType;
  NEW_EXT_INFO_HDR.EH_DueDate := StrToDateTime(dueDate);
  NEW_EXT_INFO_HDR.EH_usrCg := 'USERNAME';
  NEW_EXT_INFO_HDR.EH_usrTmCg := dateToUse;

//  NEW_EXT_INFO_HDR.ITEMTYPECODE := itemTypeCode;
//  NEW_EXT_INFO_HDR.PRODUCTIONDEMANDCOUNTERCODE := demandCounterCode;
//  NEW_EXT_INFO_HDR.PRODUCTIONDEMANDTEMPLATECODE := demandTemplateCode;

  read_ext_info_hdr_list.Add(NEW_EXT_INFO_HDR);
end;

//----------------------------------------------------------------------------//

procedure insertIntoEXT_INFO_List(connectedKey: String; info: String;
                                  itemTypeCode: String; demandCounterCode: String;
                                  demandTemplateCode: String; dateToUse: TDate;
                                  productionDemandCounters : TList;
                                  read_ext_info_list: TList);
var
  NEW_EXT_INFO: PRecEI;
begin
  New(NEW_EXT_INFO);
  NEW_EXT_INFO.EI_ConnKey := connectedKey;
  NEW_EXT_INFO.EI_infoLineNum := 1;
  NEW_EXT_INFO.EI_InfoArea := info;
  NEW_EXT_INFO.EI_usrCg := 'USERNAME';
  NEW_EXT_INFO.EI_usrTmCg := dateToUse;

//  NEW_EXT_INFO.ITEMTYPECODE := itemTypeCode;
//  NEW_EXT_INFO.PRODUCTIONDEMANDCOUNTERCODE := demandCounterCode;
//  NEW_EXT_INFO.PRODUCTIONDEMANDTEMPLATECODE := demandTemplateCode;

  read_ext_info_list.Add(NEW_EXT_INFO);
end;

//----------------------------------------------------------------------------//

procedure insertIntoPROD_REQCONN_List(fromProdReq: String; toProdReq: String;
                                      itemTypeCode: String; demandCounterCode: String;
                                      demandTemplateCode: String;
                                      productionDemandCounters : TList;
                                      read_prod_reqConn_list: TList);
var
  NEW_PROD_REQCONN: PTMQMIC;
  PREQ_NO : string;
begin
  New(NEW_PROD_REQCONN);
  NEW_PROD_REQCONN.IC_PREQ_NO := fromProdReq;
  NEW_PROD_REQCONN.IC_PREV_PREQ_NO := toProdReq;
  NEW_PROD_REQCONN.IC_USR_CG := 'USERNAME';
  NEW_PROD_REQCONN.IC_USR_TM_CG := Now;

  PREQ_NO := NEW_PROD_REQCONN.IC_PREQ_NO;
  if CheckMerge(PREQ_NO, setStringLengthTo(demandCounterCode , 8), productionDemandCounters) then
  begin
    NEW_PROD_REQCONN.IC_FAMILYCODE := PREQ_NO;
  end;

  read_prod_reqConn_list.Add(NEW_PROD_REQCONN);
end;

//----------------------------------------------------------------------------//

procedure insertIntoBALANCE_HEADER_List(HostQry : TMqmQuery; logicalWarehouseList: TList; itemTypeLogicalWarehouseList : TList;
                                        read_balance_header_list: TList;
                                        articleTypeList: TList;
                                        additionalDataList, UserGenericGroupTypeList, UserGenericGroupAttributesList : TList
                                        );
var
  NEW_BALANCE_HEADER: PRecBH;
  tempDate: TDate;
  ITEMTYPELOGICALWAREHOUSE : PITEMTYPELOGICALWAREHOUSES;
  CUR_ITEMTYPELOGICALWAREHOUSE_ITEMTYPE: PITEMTYPELOGICALWAREHOUSE_ITEMTYPES;
  balanceHandledByMqm: String;
  FIKD_ABSUNIQUEID, ProjectDode, NetGroupCode, ABSUNIQUEID, Saved_ABSUNIQUEID  : string;
  Items : PTITEMS;
  I, Index : Integer;
  FoundWhLink : boolean;
  MATERIAL_TOLLERANCE_CODE : string;
  Curr_LOGICALWAREHOUSE: PLOGICALWAREHOUSES;
begin
  UpdateOperation(_('Downloading data for BALANCE_HEADER table'));
  Items := nil;
  tempDate := Now;
  FIKD_ABSUNIQUEID := '';
  var fldBH_T_ABSUNIQUEID      := HostQry.FieldByName('T_ABSUNIQUEID');
  var fldBH_FIKD_ABSUNIQUEID   := HostQry.FieldByName('FIKD_ABSUNIQUEID');
  var fldBH_ITEMTYPECODE       := HostQry.FieldByName('ITEMTYPECODE');
  var fldBH_DECOSUBCODE01      := HostQry.FieldByName('DECOSUBCODE01');
  var fldBH_DECOSUBCODE02      := HostQry.FieldByName('DECOSUBCODE02');
  var fldBH_DECOSUBCODE03      := HostQry.FieldByName('DECOSUBCODE03');
  var fldBH_DECOSUBCODE04      := HostQry.FieldByName('DECOSUBCODE04');
  var fldBH_DECOSUBCODE05      := HostQry.FieldByName('DECOSUBCODE05');
  var fldBH_DECOSUBCODE06      := HostQry.FieldByName('DECOSUBCODE06');
  var fldBH_DECOSUBCODE07      := HostQry.FieldByName('DECOSUBCODE07');
  var fldBH_DECOSUBCODE08      := HostQry.FieldByName('DECOSUBCODE08');
  var fldBH_DECOSUBCODE09      := HostQry.FieldByName('DECOSUBCODE09');
  var fldBH_DECOSUBCODE10      := HostQry.FieldByName('DECOSUBCODE10');
  var fldBH_LOGICALWAREHOUSECODE := HostQry.FieldByName('LOGICALWAREHOUSECODE');
  var fldBH_PROJECTCODE        := HostQry.FieldByName('PROJECTCODE');
  var fldBH_LOTCODE            := HostQry.FieldByName('LOTCODE');
  var fldBH_DUEDATE            := HostQry.FieldByName('DUEDATE');
  var fldBH_QTY                := HostQry.FieldByName('QTY');
  var fldBH_INFOAREA           := HostQry.FieldByName('INFOAREA');

  while ( not hostQry.Eof ) do
  begin

 //   if not HostQry.FieldByName('FIKD_ABSUNIQUEID').Isnull then
    if fldBH_T_ABSUNIQUEID.Isnull then
       ABSUNIQUEID := fldBH_FIKD_ABSUNIQUEID.AsString
    else
      ABSUNIQUEID := fldBH_T_ABSUNIQUEID.AsString;

    if ABSUNIQUEID <> Saved_ABSUNIQUEID then
    begin

      Items := FindProductItem(ABSUNIQUEID , List_Items);

      if Items = nil then
      begin
        HostQry.Next;
        continue;
      end;

      Saved_ABSUNIQUEID := ABSUNIQUEID;

    end;
    NetGroupCode := '';

    if (Items <> nil) then
      balanceHandledByMqm := isBalanceHandledByMqm(articleTypeList, HostQry.FieldByName('ITEMTYPECODE').AsString,
                               additionalDataList, UserGenericGroupTypeList, UserGenericGroupAttributesList,
                               Items.ABSUNIQUEID_P, MATERIAL_TOLLERANCE_CODE,
                               HostQry.FieldByName('DECOSUBCODE01').AsString,
                               HostQry.FieldByName('DECOSUBCODE02').AsString,
                               HostQry.FieldByName('DECOSUBCODE03').AsString,
                               HostQry.FieldByName('DECOSUBCODE04').AsString,
                               HostQry.FieldByName('DECOSUBCODE05').AsString,
                               HostQry.FieldByName('DECOSUBCODE06').AsString,
                               HostQry.FieldByName('DECOSUBCODE07').AsString,
                               HostQry.FieldByName('DECOSUBCODE08').AsString,
                               HostQry.FieldByName('DECOSUBCODE09').AsString,
                               HostQry.FieldByName('DECOSUBCODE10').AsString);
                             //  HostQry.FieldByName('ABSUNIQUEID').AsString);

    // commented by erbil on 24.09.2009
    if (balanceHandledByMqm = '0') then
    begin

      New(NEW_BALANCE_HEADER);

      NEW_BALANCE_HEADER.BH_ProdType := fldBH_ITEMTYPECODE.AsString;
      NEW_BALANCE_HEADER.BH_ProdCode := getFullItemKeyCode(fldBH_ITEMTYPECODE.AsString,
                                                fldBH_DECOSUBCODE01.AsString,
                                                fldBH_DECOSUBCODE02.AsString,
                                                fldBH_DECOSUBCODE03.AsString,
                                                fldBH_DECOSUBCODE04.AsString,
                                                fldBH_DECOSUBCODE05.AsString,
                                                fldBH_DECOSUBCODE06.AsString,
                                                fldBH_DECOSUBCODE07.AsString,
                                                fldBH_DECOSUBCODE08.AsString,
                                                fldBH_DECOSUBCODE09.AsString,
                                                fldBH_DECOSUBCODE10.AsString);

      Curr_LOGICALWAREHOUSE := getLogicalWHStruct(fldBH_LOGICALWAREHOUSECODE.AsString, logicalWarehouseList);
      if Curr_LOGICALWAREHOUSE = nil then
        NEW_BALANCE_HEADER.BH_netGroupCode := ''
      else
        NEW_BALANCE_HEADER.BH_netGroupCode := Curr_LOGICALWAREHOUSE.MQMGROUPCODE;

      if Assigned(Items) then
      begin
        FoundWhLink := false;
        for I := 0 to Items.ItemWarehouseLink.Count - 1 do
        begin
          if trim(fldBH_LOGICALWAREHOUSECODE.AsString) = trim(PItemWarehouseLinkRec(Items.ItemWarehouseLink[I]).LogicalWarehouseCode) then
          begin
            FoundWhLink := true;
            if PItemWarehouseLinkRec(Items.ItemWarehouseLink[I]).ProjectControlled then
            begin
              if trim(fldBH_PROJECTCODE.AsString) <> '' then
              begin
                ProjectDode := trim(fldBH_PROJECTCODE.AsString);
                NetGroupCode := NEW_BALANCE_HEADER.BH_netGroupCode + '_' + GetNumberByProject(ProjectNumberList, ProjectDode);
                NEW_BALANCE_HEADER.BH_netGroupCode := NetGroupCode;
              end;
            end;
            break;
          end;
        end;
        if not FoundWhLink
           and Items.ProjectControlled
           and (trim(fldBH_PROJECTCODE.AsString) <> '') and (Curr_LOGICALWAREHOUSE <> nil)
           and Curr_LOGICALWAREHOUSE.ProjectControlled then
        begin
          ProjectDode := trim(fldBH_PROJECTCODE.AsString);
          NetGroupCode := NEW_BALANCE_HEADER.BH_netGroupCode + '_' + GetNumberByProject(ProjectNumberList, ProjectDode);
          NEW_BALANCE_HEADER.BH_netGroupCode := NetGroupCode;
        end;
      end;

      if trim(fldBH_LOTCODE.AsString) <> '' then
      begin

        index := searchInList(itemTypeLogicalWarehouseList, 40, Trim(NEW_BALANCE_HEADER.BH_ProdType),
                        0, itemTypeLogicalWarehouseList.Count - 1);

        if (index <> -1) then
        begin
          CUR_ITEMTYPELOGICALWAREHOUSE_ITEMTYPE := itemTypeLogicalWarehouseList.Items[index];

          index := searchInList(CUR_ITEMTYPELOGICALWAREHOUSE_ITEMTYPE.logicalWarehouseList, 41,
                          Trim(Curr_LOGICALWAREHOUSE.CODE), 0,
                          CUR_ITEMTYPELOGICALWAREHOUSE_ITEMTYPE.logicalWarehouseList.Count - 1);

          if (index <> -1) then
          begin
            ITEMTYPELOGICALWAREHOUSE := CUR_ITEMTYPELOGICALWAREHOUSE_ITEMTYPE.logicalWarehouseList.Items[index];
            if trim(ITEMTYPELOGICALWAREHOUSE.NET_GRP_LOT) = '1' then
              NEW_BALANCE_HEADER.BH_netGroupCode := trim(fldBH_LOTCODE.AsString)
            else if trim(ITEMTYPELOGICALWAREHOUSE.NET_GRP_LOT) = '2' then
            begin
              NEW_BALANCE_HEADER.BH_netGroupCode := NEW_BALANCE_HEADER.BH_netGroupCode + '_' + trim(fldBH_LOTCODE.AsString);
              NEW_BALANCE_HEADER.BH_netGroupCode := copy(NEW_BALANCE_HEADER.BH_netGroupCode, 1, 16);
            end;
          end;

        end;

      end;

      NEW_BALANCE_HEADER.BH_dueDate := fldBH_DUEDATE.AsDateTime;
      NEW_BALANCE_HEADER.BH_quant := fldBH_QTY.AsFloat;

      NEW_BALANCE_HEADER.BH_InfoArea := Trim(fldBH_INFOAREA.AsString);

      NEW_BALANCE_HEADER.BH_usrCg := 'USERNAME';
      NEW_BALANCE_HEADER.BH_usrTmCg := tempDate;

      read_balance_header_list.Add(NEW_BALANCE_HEADER);

    end;
    HostQry.Next
  end;

{  while ( not hostQry.Eof ) do
  begin

    if HostQry.FieldByName('ABSUNIQUEID').AsString <> FIKD_ABSUNIQUEID then
    begin
      Items := FindProductItem(HostQry.FieldByName('ABSUNIQUEID').AsString , List_Items);

      if Items = nil then
      begin
        HostQry.Next;
        continue;
      end;

      FIKD_ABSUNIQUEID := HostQry.FieldByName('ABSUNIQUEID').AsString;

    end;
    NetGroupCode := '';

    if (Items <> nil) then
      balanceHandledByMqm := isBalanceHandledByMqm(articleTypeList, HostQry.FieldByName('ITEMTYPECODE').AsString,
                               additionalDataList,
                               Items.ABSUNIQUEID_P);
                             //  HostQry.FieldByName('ABSUNIQUEID').AsString);

    // commented by erbil on 24.09.2009
    if (balanceHandledByMqm = '0') then
    begin

      New(NEW_BALANCE_HEADER);

      NEW_BALANCE_HEADER.BH_ProdType := HostQry.FieldByName('ITEMTYPECODE').AsString;
      NEW_BALANCE_HEADER.BH_ProdCode := getFullItemKeyCode(HostQry.FieldByName('ITEMTYPECODE').AsString,
                                                HostQry.FieldByName('DECOSUBCODE01').AsString,
                                                HostQry.FieldByName('DECOSUBCODE02').AsString,
                                                HostQry.FieldByName('DECOSUBCODE03').AsString,
                                                HostQry.FieldByName('DECOSUBCODE04').AsString,
                                                HostQry.FieldByName('DECOSUBCODE05').AsString,
                                                HostQry.FieldByName('DECOSUBCODE06').AsString,
                                                HostQry.FieldByName('DECOSUBCODE07').AsString,
                                                HostQry.FieldByName('DECOSUBCODE08').AsString,
                                                HostQry.FieldByName('DECOSUBCODE09').AsString,
                                                HostQry.FieldByName('DECOSUBCODE10').AsString);

      NEW_BALANCE_HEADER.BH_netGroupCode := getMqmGroupCode(HostQry.FieldByName('LOGICALWAREHOUSECODE').AsString, logicalWarehouseList);

    //  NEW_BALANCE_HEADER.BH_NET_GROUP_CODE := GetNetGroupCodeByProjectCode(List_Items, ProjectNumberList, HostQry);
      if Assigned(Items) then
      begin
        for I := 0 to Items.ItemWarehouseLink.Count - 1 do
        begin
          if trim(HostQry.FieldByName('LOGICALWAREHOUSECODE').AsString) = trim(PItemWarehouseLinkRec(Items.ItemWarehouseLink[I]).LogicalWarehouseCode) then
          begin
            if PItemWarehouseLinkRec(Items.ItemWarehouseLink[I]).ProjectControlled then
            begin
              if trim(HostQry.FieldByName('PROJECTCODE').AsString) <> '' then
              begin
                ProjectDode := trim(HostQry.FieldByName('PROJECTCODE').AsString);
                NetGroupCode := NEW_BALANCE_HEADER.BH_netGroupCode + GetNumberByProject(ProjectNumberList, ProjectDode);
                NEW_BALANCE_HEADER.BH_netGroupCode := NetGroupCode;
              end;
            end;
            break;
          end;
        end;
      end;

      NEW_BALANCE_HEADER.BH_dueDate := HostQry.FieldByName('DUEDATE').AsDateTime;
      NEW_BALANCE_HEADER.BH_quant := HostQry.FieldByName('QTY').AsFloat;

      // Changed by Erbil  on 09.09.2008
      NEW_BALANCE_HEADER.BH_InfoArea := getBalanceHeaderInfoArea(Trim(HostQry.FieldByName('TYPE').AsString), HostQry.FieldByName('COUNTERCODE').AsString + HostQry.FieldByName('ISTANCECODE').AsString);

      NEW_BALANCE_HEADER.BH_usrCg := 'USERNAME';
      NEW_BALANCE_HEADER.BH_usrTmCg := tempDate;

      if ( (HostQry.FieldByName('TYPE').AsString = 'P') OR
           (HostQry.FieldByName('TYPE').AsString = 'PO') OR
           (HostQry.FieldByName('TYPE').AsString = 'PS') OR
           (HostQry.FieldByName('TYPE').AsString = 'PP')
         ) then
      begin
        if (handledProductionDemands.IndexOf( setStringLengthTo(HostQry.FieldByName('COUNTERCODE').AsString, 8) +
                                              HostQry.FieldByName('ISTANCECODE').AsString ) = -1
           ) then
          read_balance_header_list.Add(NEW_BALANCE_HEADER);
      end
      else
        read_balance_header_list.Add(NEW_BALANCE_HEADER);

    end;
    HostQry.Next
  end;
                  }
end;

//----------------------------------------------------------------------------//

procedure fillItemTypesList(HostQry: TMqmQuery; companyCode: String;
                            itemTypesList: TList);
var
  NEW_ITEMTYPE: PITEMTYPES;
  hostSqlStr: String;
  lastItemTypeCode: String;
  CompanyInUsed : string;
begin
  NEW_ITEMTYPE := nil;
  if not GetCompanyLevelHandlingByEntityName('ITEMSUBCODETEMPLATE',  CompanyInUsed) then
     CompanyInUsed := IniAppGlobals.CompanyCode;

  hostSqlStr := 'SELECT ITEMTYPECODE, LENGTH FROM ITEMSUBCODETEMPLATE WHERE ' +
                'ITEMTYPECOMPANYCODE = ' + QuotedStr(CompanyInUsed) + ' ' +
                'ORDER BY ITEMTYPECODE, POSITION';

  HostQry.SQL.Text := hostSqlStr;
  HostQry.Open;

  lastItemTypeCode := '';
  var ITEMTYPECODE_FIELD := HostQry.FieldByName('ITEMTYPECODE');
  var LENGTH_FIELD := HostQry.FieldByName('LENGTH');
  while ( not HostQry.Eof ) do
  begin
    if (lastItemTypeCode <> Trim(ITEMTYPECODE_FIELD.AsString)) then
    begin
      if (Trim(lastItemTypeCode) <> '')then
      begin
        NEW_ITEMTYPE.LASTSUBCODENR := IntToStr(NEW_ITEMTYPE.SUBCODELENGTHS.Count);

        while (NEW_ITEMTYPE.SUBCODELENGTHS.Count < 10) do
          NEW_ITEMTYPE.SUBCODELENGTHS.Add('0');

        itemTypesList.Add(NEW_ITEMTYPE);
      end;

      lastItemTypeCode := Trim(ITEMTYPECODE_FIELD.AsString);

      New(NEW_ITEMTYPE);
      NEW_ITEMTYPE.CODE := lastItemTypeCode;
      NEW_ITEMTYPE.SUBCODELENGTHS := TStringList.Create;
    end;

    NEW_ITEMTYPE.SUBCODELENGTHS.Add(Trim(LENGTH_FIELD.AsString));

    HostQry.Next;
  end;

  if (Trim(lastItemTypeCode) <> '')then
  begin
    NEW_ITEMTYPE.LASTSUBCODENR := IntToStr(NEW_ITEMTYPE.SUBCODELENGTHS.Count);

    while (NEW_ITEMTYPE.SUBCODELENGTHS.Count < 10) do
      NEW_ITEMTYPE.SUBCODELENGTHS.Add('0');

    itemTypesList.Add(NEW_ITEMTYPE);
  end;

  HostQry.Close;
end;

//----------------------------------------------------------------------------//

procedure PrepareAllocationLists(HostQry: TMqmQuery; CompanyCode : string; articleTypeList : Tlist; ReservationLines : TList);
var
  balanceHandledItemTypeCodes, productionOrderCode, productionDemandCode, hostSqlStr : string;
  productionDemandCountersListStr, productionOrderCountersListStr : string;
  AllocationsList, ProductionOrderLines : TList;
  I : Integer;
  SqlLog : TStringList;
  MQMAllocation : PMQMAllocations;
  MQMProductionOrderLine : PMQMProductionOrderLines;
  MQMProductionReservationLine : PMQMProductionReservationLine;
  Code, ORDERCOUNTERCODE, ORDERCODE, RESERVATIONLINE, CompanyInUsed : string;
  LineNumber, COMPONENTLINENUMBER, RESERVATION_LINE : Integer;
  groupline, Index : integer;
  IsNewRecordAllocation, IsNewRecordReservation, IsNewRecordOrderLines : boolean;
  AllocatedQuantity : double;
  STOCKTYPECODES, CompanyInUsed_AvailabilityFormulaDetail : string;
begin
  productionDemandCountersListStr := '';
  productionOrderCountersListStr  := '';

  AllocationsList := TList.Create;
  ProductionOrderLines := TList.Create;

  balanceHandledItemTypeCodes := getBalanceHandledItemTypes(articleTypeList, true);

  if not GetCompanyLevelHandlingByEntityName('COUNTER',  CompanyInUsed) then
     CompanyInUsed := IniAppGlobals.CompanyCode;

  hostSqlStr := 'select c.countertypecode as countertypecode, c.code from counter c ' +
                ' where c.companycode = ' + QuotedStr(CompanyInUsed) + ' and c.countertypecode in (' + QuotedStr('60') + ',' + QuotedStr('64') + ') ';

  HostQry.SQL.Text := hostSqlStr;
  HostQry.Open;

  while not HostQry.Eof do
  begin
    if HostQry.FieldByName('countertypecode').AsString = '60' then
    begin
      if trim(productionDemandCountersListStr) <> '' then
        productionDemandCountersListStr := productionDemandCountersListStr + ', ';
      productionDemandCountersListStr := productionDemandCountersListStr + QuotedStr(HostQry.FieldByName('code').AsString);
    end
    else if HostQry.FieldByName('countertypecode').AsString = '64' then
    begin
      if trim(productionOrderCountersListStr) <> '' then
        productionOrderCountersListStr := productionOrderCountersListStr + ', ';
      productionOrderCountersListStr := productionOrderCountersListStr + QuotedStr(HostQry.FieldByName('code').AsString);
    end;

    HostQry.Next;
  end;

  HostQry.close;


  STOCKTYPECODES := '';

  if IniAppGlobals.FormulaForMaterialAvailabilityToIgnore <> '' then
  begin
    if not GetCompanyLevelHandlingByEntityName('AVAILABILITYFORMULADETAIL',  CompanyInUsed_AvailabilityFormulaDetail) then
      CompanyInUsed_AvailabilityFormulaDetail := IniAppGlobals.CompanyCode;

    hostSqlStr := 'SELECT STOCKTYPECODE FROM AVAILABILITYFORMULADETAIL WHERE ' +
                  'AVAILABILITYFORMULACOMPANYCODE = ' + QuotedStr(CompanyInUsed_AvailabilityFormulaDetail) +
                  ' AND AVAILABILITYFORMULACODE = ' + QuotedStr(IniAppGlobals.FormulaForMaterialAvailabilityToIgnore);
    HostQry.SQL.Text := hostSqlStr;
    HostQry.Open;

    while not HostQry.EOF do
    begin
      if trim(STOCKTYPECODES) <> '' then
        STOCKTYPECODES := STOCKTYPECODES + ', ';
      STOCKTYPECODES := STOCKTYPECODES + QuotedStr(HostQry.FieldByName('STOCKTYPECODE').AsString);
      HostQry.Next;
    end;

    if STOCKTYPECODES = '' then
      STOCKTYPECODES := QuotedStr(STOCKTYPECODES);
    HostQry.Close;
  end;

  if productionDemandCountersListStr = '' then
     productionDemandCountersListStr := QuotedStr('&&&');
  if productionOrderCountersListStr = '' then
     productionOrderCountersListStr := QuotedStr('&&&');
  if balanceHandledItemTypeCodes = '' then
     balanceHandledItemTypeCodes := QuotedStr('&&&');

  hostSqlStr := 'select 1 Type, a.code, a.LINENUMBER, a.COMPONENTLINENUMBER, (a.BASEPRIMARYQUANTITY - a.BASEPRIMARYUSEDQUANTITY) AllocatedBaseQuantity, ' +
                'pr.PRODUCTIONORDERCODE, pr.groupline, pr.ORDERCOUNTERCODE, pr.ORDERCODE, pr.RESERVATIONLINE, pr.USERPRIMARYQUANTITY, pr.USEDUSERPRIMARYQUANTITY, pr.BASEPRIMARYQUANTITY, pr.USEDBASEPRIMARYQUANTITY ' +
                'from allocation a ' +
                'join PRODUCTIONRESERVATION pr ' +
                'on pr.companycode = a.COMPANYCODE ' +
                'and pr.RESERVATIONINGROUPORDER = 1 ' +
                'and pr.PRODUCTIONORDERCODE = a.ordercode ' +
                'and pr.GROUPLINE = a.orderline and ' +
                'pr.PROGRESSSTATUS in (' + QuotedStr('0') + ',' + QuotedStr('1') + ') ' +
                'where a.companycode = ' + QuotedStr(CompanyCode) +
                'and a.PROGRESSSTATUS in (' + QuotedStr('0') + ',' + QuotedStr('1') + ') ' +
                'and a.detailtype = ' + QuotedStr('1') +
                'and a.DESTINATIONTYPE = ' + QuotedStr('4') +
                'and a.countercode in (' + productionOrderCountersListStr +  ')' +
                'and a.ITEMTYPECODE in (' + balanceHandledItemTypeCodes + ')';

                if STOCKTYPECODES <> '' then
                  hostSqlStr := hostSqlStr + ' and a.stocktypecode not in (' + STOCKTYPECODES + ')';

                hostSqlStr := hostSqlStr + ' union all ' +
                'select 2 Type, a.code, a.LINENUMBER, a.COMPONENTLINENUMBER, (a.BASEPRIMARYQUANTITY - a.BASEPRIMARYUSEDQUANTITY) AllocatedBaseQuantity, ' +
                'pr.PRODUCTIONORDERCODE, pr.groupline, pr.ORDERCOUNTERCODE, pr.ORDERCODE, pr.RESERVATIONLINE, pr.USERPRIMARYQUANTITY, pr.USEDUSERPRIMARYQUANTITY, pr.BASEPRIMARYQUANTITY, pr.USEDBASEPRIMARYQUANTITY ' +
                'from allocation a ' +
                'join PRODUCTIONRESERVATION pr ' +
                'on pr.companycode = a.COMPANYCODE ' +
                ' and pr.RESERVATIONINGROUPORDER = 0 ' +
                ' and pr.ORDERCOUNTERCODE = a.COUNTERCODE ' +
                ' and pr.ordercode = a.ordercode ' +
                ' and pr.RESERVATIONLINE = a.orderline ' +
                ' and pr.PROGRESSSTATUS in (' + QuotedStr('0') + ',' + QuotedStr('1') + ') ' +
                'where a.companycode = ' + QuotedStr(CompanyCode) +
                'and a.PROGRESSSTATUS in (' + QuotedStr('0') + ',' + QuotedStr('1') + ') ' +
                'and a.detailtype = ' + QuotedStr('1') +
                'and a.DESTINATIONTYPE = ' + QuotedStr('4') +
                'and a.countercode in (' + productionDemandCountersListStr +  ')' +
                'and a.ITEMTYPECODE in (' + balanceHandledItemTypeCodes + ')';

                if STOCKTYPECODES <> '' then
                  hostSqlStr := hostSqlStr + ' and a.stocktypecode not in (' + STOCKTYPECODES + ')';

  SqlLog := TStringList.Create;
  SqlLog.Add(hostSqlStr);
  SqlLog.SaveToFile(LocAppGlobals.AppDir + '\PrepareAllocationLists.txt');
  SqlLog.free;

  HostQry.SQL.Text := hostSqlStr;
  HostQry.FetchOptions.RowsetSize := 5000;
  HostQry.Open;

  var CODE_FIELD                      := HostQry.FieldByName('code');
  var LINENUMBER_FIELD                := HostQry.FieldByName('LINENUMBER');
  var PRODUCTIONORDERCODE_FIELD       := HostQry.FieldByName('PRODUCTIONORDERCODE');
  var GROUPLINE_FIELD                 := HostQry.FieldByName('groupline');
  var ORDERCOUNTERCODE_FIELD          := HostQry.FieldByName('ORDERCOUNTERCODE');
  var ORDERCODE_FIELD                 := HostQry.FieldByName('ORDERCODE');
  var RESERVATIONLINE_FIELD           := HostQry.FieldByName('RESERVATIONLINE');
  var USERPRIMARYQUANTITY_FIELD       := HostQry.FieldByName('USERPRIMARYQUANTITY');
  var USEDUSERPRIMARYQUANTITY_FIELD   := HostQry.FieldByName('USEDUSERPRIMARYQUANTITY');
  var BASEPRIMARYQUANTITY_FIELD       := HostQry.FieldByName('BASEPRIMARYQUANTITY');
  var USEDBASEPRIMARYQUANTITY_FIELD   := HostQry.FieldByName('USEDBASEPRIMARYQUANTITY');
  var TYPE_FIELD                      := HostQry.FieldByName('type');
  var ALLOCATEDBASEQUANTITY_FIELD     := HostQry.FieldByName('AllocatedBaseQuantity');

  while not HostQry.Eof do
  begin

    Code := CODE_FIELD.AsString;
    LineNumber := LINENUMBER_FIELD.AsInteger;
    COMPONENTLINENUMBER := LineNumber;

    MQMAllocation := FindAndAdd_Allocations(AllocationsList,Code,LineNumber,COMPONENTLINENUMBER, IsNewRecordAllocation);

    PRODUCTIONORDERCODE := Trim(PRODUCTIONORDERCODE_FIELD.AsString);
    groupline           := GROUPLINE_FIELD.AsInteger;
    ORDERCOUNTERCODE    := Trim(ORDERCOUNTERCODE_FIELD.AsString);
    ORDERCODE           := Trim(ORDERCODE_FIELD.AsString);
    RESERVATION_LINE    := RESERVATIONLINE_FIELD.AsInteger;

    MQMProductionReservationLine := FindAndAdd_ReservationLines(ReservationLines, false, ORDERCOUNTERCODE, ORDERCODE, RESERVATION_LINE, IsNewRecordReservation);
    if IsNewRecordReservation then
    begin
      MQMProductionReservationLine.PRODUCTIONORDERCODE := PRODUCTIONORDERCODE;
      MQMProductionReservationLine.groupline := groupline;
      MQMProductionReservationLine.UserQuantity := USERPRIMARYQUANTITY_FIELD.AsFloat - USEDUSERPRIMARYQUANTITY_FIELD.AsFloat;
      MQMProductionReservationLine.BaseQuantity := BASEPRIMARYQUANTITY_FIELD.AsFloat - USEDBASEPRIMARYQUANTITY_FIELD.AsFloat;
      MQMProductionReservationLine.AllocatedQuantity := 0;
    end;

    var rowType := TYPE_FIELD.AsString;

    if rowType = '2' then
      MQMProductionReservationLine.AllocatedQuantity := MQMProductionReservationLine.AllocatedQuantity + ALLOCATEDBASEQUANTITY_FIELD.AsFloat;

    if rowType = '1' then
    begin
      MQMProductionOrderLine := FindAndAdd_ProductionOrderLines(ProductionOrderLines, false, PRODUCTIONORDERCODE, groupline, IsNewRecordOrderLines);
      if IsNewRecordOrderLines then
      begin
        MQMProductionOrderLine.UserQuantity := 0;
        MQMProductionOrderLine.BaseQuantity := 0;
        MQMProductionOrderLine.AllocatedQuantity := 0
      end;

      if IsNewRecordReservation then
      begin
        MQMProductionOrderLine.UserQuantity := MQMProductionOrderLine.UserQuantity + (USERPRIMARYQUANTITY_FIELD.AsFloat - USEDUSERPRIMARYQUANTITY_FIELD.AsFloat);
        MQMProductionOrderLine.BaseQuantity := MQMProductionOrderLine.BaseQuantity + (BASEPRIMARYQUANTITY_FIELD.AsFloat - USEDBASEPRIMARYQUANTITY_FIELD.AsFloat);
      end;

      if IsNewRecordAllocation then
        MQMProductionOrderLine.AllocatedQuantity := MQMProductionOrderLine.AllocatedQuantity + ALLOCATEDBASEQUANTITY_FIELD.AsFloat;

    end;

    HostQry.Next

  end;

  for I := 0 to ReservationLines.Count - 1 do
  begin
    MQMProductionOrderLine := FindAndAdd_ProductionOrderLines(ProductionOrderLines, true, PMQMProductionReservationLine(ReservationLines[I]).PRODUCTIONORDERCODE, PMQMProductionReservationLine(ReservationLines[I]).groupline, IsNewRecordOrderLines);
    if assigned(MQMProductionOrderLine) then
    begin
      PMQMProductionReservationLine(ReservationLines[I]).AllocatedQuantity := PMQMProductionReservationLine(ReservationLines[I]).AllocatedQuantity +
        (PMQMProductionReservationLine(ReservationLines[I]).UserQuantity / MQMProductionOrderLine.UserQuantity * MQMProductionOrderLine.AllocatedQuantity);
    end;
    if PMQMProductionReservationLine(ReservationLines[I]).AllocatedQuantity > 0 then
      PMQMProductionReservationLine(ReservationLines[I]).AllocatedQuantity := RoundTo(PMQMProductionReservationLine(ReservationLines[I]).AllocatedQuantity, -2);
  end;

  for I := 0 to AllocationsList.Count - 1 do
     dispose(PMQMAllocations(AllocationsList[I]));
  AllocationsList.Free;

  for I := 0 to ProductionOrderLines.Count - 1 do
     dispose(PMQMProductionOrderLines(ProductionOrderLines[I]));
  ProductionOrderLines.Free;
end;

//----------------------------------------------------------------------------//

procedure fillAlternativeUM(ArcQry :  TMqmQuery; companyCode: String);
var
  DndArchiveArcName : TDndArchiveName;
  Tbl_Process, SqlStr : string;
  fldAltUMHandled, fldWkctProc: TField;
begin
  DndArchiveArcName := GetDndArchiveLocalName;

  Tbl_Process := 'PROC';
  if DndArchiveArcName <> TD_Interbase then
    Tbl_Process  := 'SCDA_' + 'PROC';
  SqlStr := 'SELECT * FROM ' + Tbl_Process + ' WHERE ' +
            'PR_ALTERNATIVE_UM_HANDLED in (' + QuotedStr('1') + ' , ' + QuotedStr('2') + ' , ' + QuotedStr('3') + ')' +
             AND_IDF_Condition('PR_IDENTIFIER') + ' ORDER BY PR_WKCT_PROC';

  ArcQry.SQL.Text := SqlStr;
  ArcQry.Active := true;
  fldAltUMHandled := ArcQry.FieldByName('PR_ALTERNATIVE_UM_HANDLED');
  fldWkctProc     := ArcQry.FieldByName('PR_WKCT_PROC');

  while ( not ArcQry.Eof ) do
  begin
    if (fldAltUMHandled.AsString = '1') then
      ProcessListAlternativeUM_Primary.Add(fldWkctProc.AsString)
    else if (fldAltUMHandled.AsString = '2') then
      ProcessListAlternativeUM_secondary.Add(fldWkctProc.AsString)
    else
      PackagingAlternativeUoM.Add(fldWkctProc.AsString);
    ArcQry.next
  end;

  end;

//----------------------------------------------------------------------------//

procedure makeRelevantOperationsForColumns(ArcQry: TMqmQuery; var firstSentenceColumnNames: String;
            var secondSentenceColumnNames: String;
            var AD_Product_FieldsList : TStringlist; var AD_FullItemKeyDecoder_FieldsList  : TStringlist;
            var AD_ProductionDemandStep_FieldsList  : TStringlist; var AD_ProductionDemand_FieldsList : TStringlist);
var
  srvSqlStr: String;
  tableName, TableNameSql: String;
  columnName: String;
  tablePrefix: String;
  i: Integer;
  Pos : integer;
  DndArchiveArcName : TDndArchiveName;
  fldTableNameF, fldColumnNameF: TField;
begin
  DndArchiveArcName := GetDndArchiveLocalName;

  productionColumnNames := TStringList.Create;
//  productionColumnNames.Sorted := true;

  FIKD_ABSUNIQUEID := addToSelectedColumns('FIKD', '', 'ABSUNIQUEID', firstSentenceColumnNames, productionColumnNames);
  FIKD_IDENTIFIER := addToSelectedColumns('FIKD', '', 'IDENTIFIER', firstSentenceColumnNames, productionColumnNames);
  PD_COMPANYCODE := addToSelectedColumns('PD', '', 'COMPANYCODE', firstSentenceColumnNames, productionColumnNames);
  PD_COUNTERCODE := addToSelectedColumns('PD', '', 'COUNTERCODE', firstSentenceColumnNames, productionColumnNames);
  PD_CODE := addToSelectedColumns('PD', '', 'CODE', firstSentenceColumnNames, productionColumnNames);
  PD_DIVISIONCODE := addToSelectedColumns('PD', '', 'DIVISIONCODE', firstSentenceColumnNames, productionColumnNames);
  PD_TEMPLATECODE := addToSelectedColumns('PD', '', 'TEMPLATECODE', firstSentenceColumnNames, productionColumnNames);
  PD_ENTRYWAREHOUSECODE := addToSelectedColumns('PD', '', 'ENTRYWAREHOUSECODE', firstSentenceColumnNames, productionColumnNames);
  PD_BASEPRIMARYQUANTITY := addToSelectedColumns('PD', '', 'BASEPRIMARYQUANTITY', firstSentenceColumnNames, productionColumnNames);
  PD_BASEPRIMARYUOMCODE := addToSelectedColumns('PD', '', 'BASEPRIMARYUOMCODE', firstSentenceColumnNames, productionColumnNames);
  PD_BASESECONDARYUOMCODE := addToSelectedColumns('PD', '', 'BASESECONDARYUOMCODE', firstSentenceColumnNames, productionColumnNames);
  PD_UOMTYPE := addToSelectedColumns('PD', '', 'UOMTYPE', firstSentenceColumnNames, productionColumnNames);
  PD_ENTEREDBASEPRIMARYQUANTITY := addToSelectedColumns('PD', '', 'ENTEREDBASEPRIMARYQUANTITY', firstSentenceColumnNames, productionColumnNames);
  PD_ITEMTYPEAFICODE := addToSelectedColumns('PD', '', 'ITEMTYPEAFICODE', firstSentenceColumnNames, productionColumnNames);
  PD_PROGRESSSTATUS := addToSelectedColumns('PD', '', 'PROGRESSSTATUS', firstSentenceColumnNames, productionColumnNames);
  PD_STDPRODUCTIONBATCH := addToSelectedColumns('PD', '', 'STDPRODUCTIONBATCH', firstSentenceColumnNames, productionColumnNames);
  PD_STDPRODUCTIONBATCHUOMCODE := addToSelectedColumns('PD', '', 'STDPRODUCTIONBATCHUOMCODE', firstSentenceColumnNames, productionColumnNames);
  PD_INITIALPLANNEDDATE := addToSelectedColumns('PD', '', 'INITIALPLANNEDDATE', firstSentenceColumnNames, productionColumnNames);
  PD_FINALPLANNEDDATE := addToSelectedColumns('PD', '', 'FINALPLANNEDDATE', firstSentenceColumnNames, productionColumnNames);
  PD_RESERVATIONORDERCOUNTERCODE := addToSelectedColumns('PD', '', 'RESERVATIONORDERCOUNTERCODE', firstSentenceColumnNames, productionColumnNames);
  PD_RESERVATIONORDERCODE := addToSelectedColumns('PD', '', 'RESERVATIONORDERCODE', firstSentenceColumnNames, productionColumnNames);
  PD_ABSUNIQUEID := addToSelectedColumns('PD', '', 'ABSUNIQUEID', firstSentenceColumnNames, productionColumnNames);
  PD_PROJECTCODE := addToSelectedColumns('PD', '', 'PROJECTCODE', firstSentenceColumnNames, productionColumnNames);
  PD_CUSTOMERCODE := addToSelectedColumns('PD', '', 'CUSTOMERCODE', firstSentenceColumnNames, productionColumnNames);
  PD_ORIGDLVSALORDLINESALORDCNTCOD := addToSelectedColumns('PD', '', 'ORIGDLVSALORDLINESALORDCNTCOD', firstSentenceColumnNames, productionColumnNames);
  PD_ORIGDLVSALORDLINESALORDERCODE := addToSelectedColumns('PD', '', 'ORIGDLVSALORDLINESALORDERCODE', firstSentenceColumnNames, productionColumnNames);
  PD_ORIGDLVSALORDERLINEORDERLINE := addToSelectedColumns('PD', '', 'ORIGDLVSALORDERLINEORDERLINE', firstSentenceColumnNames, productionColumnNames);
  PD_ORIGDLVSALORDLINEORDERSUBLINE := addToSelectedColumns('PD', '', 'ORIGDLVSALORDLINEORDERSUBLINE', firstSentenceColumnNames, productionColumnNames);
  PD_ORIGDLVSALORDLINECMPORDERLINE := addToSelectedColumns('PD', '', 'ORIGDLVSALORDLINECMPORDERLINE', firstSentenceColumnNames, productionColumnNames);
  PD_ORIGDELIVERYDELIVERYLINE := addToSelectedColumns('PD', '', 'ORIGDELIVERYDELIVERYLINE', firstSentenceColumnNames, productionColumnNames);
  if CheckColumnExistsInTable(ArcQry, 'PRODUCTIONDEMAND', 'INITIALPLANNEDSCHEDULEDDATE') then
    PD_INITIALPLANNEDSCHEDULEDDATE := addToSelectedColumns('PD', '', 'INITIALPLANNEDSCHEDULEDDATE', firstSentenceColumnNames, productionColumnNames);
  if CheckColumnExistsInTable(ArcQry, 'PRODUCTIONDEMAND', 'FINALPLANNEDSCHEDULEDDATE') then
    PD_FINALPLANNEDSCHEDULEDDATE := addToSelectedColumns('PD', '', 'FINALPLANNEDSCHEDULEDDATE', firstSentenceColumnNames, productionColumnNames);
  if CheckColumnExistsInTable(ArcQry, 'PRODUCTIONDEMAND', 'MQMSPLITREFERENCE') then
    PD_MQMSPLITREFERENCE := addToSelectedColumns('PD', '', 'MQMSPLITREFERENCE', firstSentenceColumnNames, productionColumnNames);
  PD_SUBCODE01 := addToSelectedColumns('PD', '', 'SUBCODE01', firstSentenceColumnNames, productionColumnNames);
  PD_SUBCODE02 := addToSelectedColumns('PD', '', 'SUBCODE02', firstSentenceColumnNames, productionColumnNames);
  PD_SUBCODE03 := addToSelectedColumns('PD', '', 'SUBCODE03', firstSentenceColumnNames, productionColumnNames);
  PD_SUBCODE04 := addToSelectedColumns('PD', '', 'SUBCODE04', firstSentenceColumnNames, productionColumnNames);
  PD_SUBCODE05 := addToSelectedColumns('PD', '', 'SUBCODE05', firstSentenceColumnNames, productionColumnNames);
  PD_SUBCODE06 := addToSelectedColumns('PD', '', 'SUBCODE06', firstSentenceColumnNames, productionColumnNames);
  PD_SUBCODE07 := addToSelectedColumns('PD', '', 'SUBCODE07', firstSentenceColumnNames, productionColumnNames);
  PD_SUBCODE08 := addToSelectedColumns('PD', '', 'SUBCODE08', firstSentenceColumnNames, productionColumnNames);
  PD_SUBCODE09 := addToSelectedColumns('PD', '', 'SUBCODE09', firstSentenceColumnNames, productionColumnNames);
  PD_SUBCODE10 := addToSelectedColumns('PD', '', 'SUBCODE10', firstSentenceColumnNames, productionColumnNames);
  PDS_WORKCENTERCODE := addToSelectedColumns('PDS', '', 'WORKCENTERCODE', firstSentenceColumnNames, productionColumnNames);
  PDS_PRODUCTIONORDERCODE := addToSelectedColumns('PDS', '', 'PRODUCTIONORDERCODE', firstSentenceColumnNames, productionColumnNames);
  PDS_GROUPSTEPNUMBER := addToSelectedColumns('PDS', '', 'GROUPSTEPNUMBER', firstSentenceColumnNames, productionColumnNames);
  PDS_STEPNUMBER := addToSelectedColumns('PDS', '', 'STEPNUMBER', firstSentenceColumnNames, productionColumnNames);
  PDS_TIMETYPE1CODE := addToSelectedColumns('PDS', '', 'TIMETYPE1CODE', firstSentenceColumnNames, productionColumnNames);
  PDS_TIMETYPE2CODE := addToSelectedColumns('PDS', '', 'TIMETYPE2CODE', firstSentenceColumnNames, productionColumnNames);
  PDS_TIMETYPE3CODE := addToSelectedColumns('PDS', '', 'TIMETYPE3CODE', firstSentenceColumnNames, productionColumnNames);
  PDS_TIMETYPE4CODE := addToSelectedColumns('PDS', '', 'TIMETYPE4CODE', firstSentenceColumnNames, productionColumnNames);
  PDS_TIMETYPE5CODE := addToSelectedColumns('PDS', '', 'TIMETYPE5CODE', firstSentenceColumnNames, productionColumnNames);
  PDS_TIME1 := addToSelectedColumns('PDS', '', 'TIME1', firstSentenceColumnNames, productionColumnNames);
  PDS_TIME2 := addToSelectedColumns('PDS', '', 'TIME2', firstSentenceColumnNames, productionColumnNames);
  PDS_TIME3 := addToSelectedColumns('PDS', '', 'TIME3', firstSentenceColumnNames, productionColumnNames);
  PDS_TIME4 := addToSelectedColumns('PDS', '', 'TIME4', firstSentenceColumnNames, productionColumnNames);
  PDS_TIME5 := addToSelectedColumns('PDS', '', 'TIME5', firstSentenceColumnNames, productionColumnNames);
  if CheckColumnExistsInTable(ArcQry, 'PRODUCTIONDEMANDSTEP', 'INITIALPLANSCHEDDATETIME') then
    PDS_INITIALPLANSCHEDDATETIME := addToSelectedColumns('PDS', '', 'INITIALPLANSCHEDDATETIME', firstSentenceColumnNames, productionColumnNames);
  if CheckColumnExistsInTable(ArcQry, 'PRODUCTIONDEMANDSTEP', 'FINALPLANSCHEDDATETIME') then
    PDS_FINALPLANSCHEDDATETIME := addToSelectedColumns('PDS', '', 'FINALPLANSCHEDDATETIME', firstSentenceColumnNames, productionColumnNames);
  PDS_MINBEGINQUEUE := addToSelectedColumns('PDS', '', 'MINBEGINQUEUE', firstSentenceColumnNames, productionColumnNames);
  PDS_MINBEGINQUEUETIME := addToSelectedColumns('PDS', '', 'MINBEGINQUEUETIME', firstSentenceColumnNames, productionColumnNames);
  PDS_MAXENDSTEP := addToSelectedColumns('PDS', '', 'MAXENDSTEP', firstSentenceColumnNames, productionColumnNames);
  PDS_MAXENDSTEPTIME := addToSelectedColumns('PDS', '', 'MAXENDSTEPTIME', firstSentenceColumnNames, productionColumnNames);
  PDS_STDBEGINPRESETUP := addToSelectedColumns('PDS', '', 'STDBEGINPRESETUP', firstSentenceColumnNames, productionColumnNames);
  PDS_STDBEGINPRESETUPTIME := addToSelectedColumns('PDS', '', 'STDBEGINPRESETUPTIME', firstSentenceColumnNames, productionColumnNames);
  PDS_STDENDSTEP := addToSelectedColumns('PDS', '', 'STDENDSTEP', firstSentenceColumnNames, productionColumnNames);
  PDS_STDENDSTEPTIME := addToSelectedColumns('PDS', '', 'STDENDSTEPTIME', firstSentenceColumnNames, productionColumnNames);
  PDS_INITIALBASEPRIMARYQUANTITY := addToSelectedColumns('PDS', '', 'INITIALBASEPRIMARYQUANTITY', firstSentenceColumnNames, productionColumnNames);
  PDS_FINALBASEPRIMARYQUANTITY := addToSelectedColumns('PDS', '', 'FINALBASEPRIMARYQUANTITY', firstSentenceColumnNames, productionColumnNames);
  PDS_INITIALBASESECONDARYQUANTITY := addToSelectedColumns('PDS', '', 'INITIALBASESECONDARYQUANTITY', firstSentenceColumnNames, productionColumnNames);
  PDS_INITIALUSERPRIMARYQUANTITY := addToSelectedColumns('PDS', '', 'INITIALUSERPRIMARYQUANTITY', firstSentenceColumnNames, productionColumnNames);
  PDS_INITIALUSERSECONDARYQUANTITY := addToSelectedColumns('PDS', '', 'INITIALUSERSECONDARYQUANTITY', firstSentenceColumnNames, productionColumnNames);
  PDS_INITIALUSERPACKAGINGQUANTITY := addToSelectedColumns('PDS', '', 'INITIALUSERPACKAGINGQUANTITY', firstSentenceColumnNames, productionColumnNames);
  PDS_BASEPRIMARYUOMCODE := addToSelectedColumns('PDS', '', 'BASEPRIMARYUOMCODE', firstSentenceColumnNames, productionColumnNames);
  PDS_BASESECONDARYUOMCODE := addToSelectedColumns('PDS', '', 'BASESECONDARYUOMCODE', firstSentenceColumnNames, productionColumnNames);
  PDS_USERPACKAGINGUOMCODE := addToSelectedColumns('PDS', '', 'USERPACKAGINGUOMCODE', firstSentenceColumnNames, productionColumnNames);
  PDS_USERPRIMARYUOMCODE := addToSelectedColumns('PDS', '', 'USERPRIMARYUOMCODE', firstSentenceColumnNames, productionColumnNames);
  PDS_USERSECONDARYUOMCODE := addToSelectedColumns('PDS', '', 'USERSECONDARYUOMCODE', firstSentenceColumnNames, productionColumnNames);
  PDS_CALENDARCODE := addToSelectedColumns('PDS', '', 'CALENDARCODE', firstSentenceColumnNames, productionColumnNames);
  PDS_CALCULATEDTIME1 := addToSelectedColumns('PDS', '', 'CALCULATEDTIME1', firstSentenceColumnNames, productionColumnNames);
  PDS_CALCULATEDTIME2 := addToSelectedColumns('PDS', '', 'CALCULATEDTIME2', firstSentenceColumnNames, productionColumnNames);
  PDS_CALCULATEDTIME3 := addToSelectedColumns('PDS', '', 'CALCULATEDTIME3', firstSentenceColumnNames, productionColumnNames);
  PDS_CALCULATEDTIME4 := addToSelectedColumns('PDS', '', 'CALCULATEDTIME4', firstSentenceColumnNames, productionColumnNames);
  PDS_NROFMACHINE := addToSelectedColumns('PDS', '', 'NROFMACHINE', firstSentenceColumnNames, productionColumnNames);
  PDS_PROGRESSSTATUS := addToSelectedColumns('PDS', '', 'PROGRESSSTATUS', firstSentenceColumnNames, productionColumnNames);
  PDS_OPERATIONCODE := addToSelectedColumns('PDS', '', 'OPERATIONCODE', firstSentenceColumnNames, productionColumnNames);
  PDS_WORKCENTERANDOPERATTRIBUTESCOD := addToSelectedColumns('PDS', '', 'WORKCENTERANDOPERATTRIBUTESCOD', firstSentenceColumnNames, productionColumnNames);
  PDS_REPETITIONNUMBER := addToSelectedColumns('PDS', '', 'REPETITIONNUMBER', firstSentenceColumnNames, productionColumnNames);
  PDS_ITEMTYPEAFICODE := addToSelectedColumns('PDS', '', 'ITEMTYPEAFICODE', firstSentenceColumnNames, productionColumnNames);
  PDS_STEPEFFICIENCY := addToSelectedColumns('PDS', '', 'STEPEFFICIENCY', firstSentenceColumnNames, productionColumnNames);
  PDS_ABSUNIQUEID := addToSelectedColumns('PDS', '', 'ABSUNIQUEID', firstSentenceColumnNames, productionColumnNames);
  PDS_STANDARDSTEPQUANTITY := addToSelectedColumns('PDS', '', 'STANDARDSTEPQUANTITY', firstSentenceColumnNames, productionColumnNames);
  PDS_STANDARDSTEPQUANTITYUOMCODE := addToSelectedColumns('PDS', '', 'STANDARDSTEPQUANTITYUOMCODE', firstSentenceColumnNames, productionColumnNames);

  TableNameSql := 'PROPERTY_RTV_VALUE';
  if DndArchiveArcName <> TD_Interbase then
    TableNameSql  := 'SCDA_' + 'PROPERTY_RTV_VALUE';

  srvSqlStr := 'SELECT TABLE_NAME, COLUMN_NAME FROM ' + TableNameSql + WHERE_IDF_Condition('IDENTIFIER');
  ArcQry.SQL.Text := srvSqlStr;
  ArcQry.Active := true;
  fldTableNameF  := ArcQry.FieldByName('TABLE_NAME');
  fldColumnNameF := ArcQry.FieldByName('COLUMN_NAME');

  while ( not ArcQry.Eof ) do
  begin
    tableName := Trim(fldTableNameF.AsString);
    columnName := Trim(fldColumnNameF.AsString);

    tablePrefix := '';

    if ( tableName = 'PRODUCTIONDEMAND') then
      tablePrefix := 'PD'
    else if ( tableName = 'PRODUCTIONDEMANDSTEP') then
      tablePrefix := 'PDS';
   // else if ( tableName = 'FULLITEMKEYDECODER') then
   //   tablePrefix := 'FIKD'
   // else if ( tableName = 'PRODUCT') then
   //   tablePrefix := 'P';
    //else
    //begin
   //   ArcQry.Next;
   //   continue
   // end;

    if (tablePrefix <> '') then
    begin
      if ( productionColumnNames.IndexOf(Trim(copy(tablePrefix + '_' + columnName, 1, 30))) = -1) then
        addToSelectedColumns(tablePrefix, '', columnName, firstSentenceColumnNames, productionColumnNames);
    end;

    if ContainsText(tableName, 'UserGenericGroup') then
    begin
      //if columnName <> '' then   // make a big issue using it 26 10 2025
      //  if productionColumnNames.IndexOf(columnName) = -1 then
      //     productionColumnNames.add(columnName);
    end
    else
    if (tableName = 'Product AD') then
    begin
      if columnName <> '' then
        if AD_Product_FieldsList.IndexOf(columnName) = -1 then
           AD_Product_FieldsList.add(columnName);
    end
    else if (tableName = 'FullItemKeyDecoder AD') then
    begin
      if columnName <> '' then
        if AD_FullItemKeyDecoder_FieldsList.IndexOf(columnName) = -1 then
           AD_FullItemKeyDecoder_FieldsList.add(columnName);
    end
    else if tableName = 'ProductionDemandStep AD' then
    begin
      if columnName <> '' then
        if AD_ProductionDemandStep_FieldsList.IndexOf(columnName) = -1 then
           AD_ProductionDemandStep_FieldsList.add(columnName);
    end
    else if tableName = 'ProductionDemand AD' then
    begin
      if columnName <> '' then
        if AD_ProductionDemand_FieldsList.IndexOf(columnName) = -1 then
          AD_ProductionDemand_FieldsList.add(columnName);
    end;

    ArcQry.Next;
  end;
  ArcQry.Active := false;

  TableNameSql := 'PRODUCTION_TIMES_LEVEL';
  if DndArchiveArcName <> TD_Interbase then
    TableNameSql  := 'SCDA_' + 'PRODUCTION_TIMES_LEVEL';

  srvSqlStr := 'SELECT TABLENAME1, COLUMNNAME1, TABLENAME2, COLUMNNAME2, ' +
               'TABLENAME3, COLUMNNAME3, TABLENAME4, COLUMNNAME4, ' +
               'TABLENAME5, COLUMNNAME5, TABLENAME6, COLUMNNAME6, ' +
               'TABLENAME7, COLUMNNAME7, TABLENAME8, COLUMNNAME8, ' +
               'TABLENAME9, COLUMNNAME9, TABLENAME10, COLUMNNAME10 ' +
               'FROM ' + TableNameSql + WHERE_IDF_Condition('IDENTIFIER');
  ArcQry.SQL.Text := srvSqlStr;
  ArcQry.Active := true;

  while ( not ArcQry.Eof ) do
  begin
    for i := 1 to 10 do
    begin
      tableName := Trim(ArcQry.FieldByName('TABLENAME' + IntToStr(i)).AsString);
      columnName := Trim(ArcQry.FieldByName('COLUMNNAME' + IntToStr(i)).AsString);

      tablePrefix := '';

      if ( tableName = 'PRODUCTIONDEMAND') then
        tablePrefix := 'PD'
      else if ( tableName = 'PRODUCTIONDEMANDSTEP') then
        tablePrefix := 'PDS'
      else if ( tableName = 'FULLITEMKEYDECODER') then
      begin
        continue;
      end
      else if ( tableName = 'PRODUCT') then
      begin
        continue;
      end;

      if (tablePrefix <> '') then
      begin
        if ( productionColumnNames.IndexOf(trim(copy(tablePrefix + '_' + columnName, 1, 30))) = -1) then
          addToSelectedColumns(tablePrefix, '', columnName, firstSentenceColumnNames, productionColumnNames);
      end;

      if ContainsText(tableName, 'UserGenericGroup') then
      begin
        //if columnName <> '' then
        //  if AD_Product_FieldsList.IndexOf(columnName) = -1 then
         //    AD_Product_FieldsList.add(columnName);
      end
      else
      if (tableName = 'Product AD') then
      begin
        if columnName <> '' then
          if AD_Product_FieldsList.IndexOf(columnName) = -1 then
             AD_Product_FieldsList.add(columnName);
      end
      else if (tableName = 'FullItemKeyDecoder AD') then
      begin
        if columnName <> '' then
          if AD_FullItemKeyDecoder_FieldsList.IndexOf(columnName) = -1 then
             AD_FullItemKeyDecoder_FieldsList.add(columnName);
      end
      else if tableName = 'ProductionDemandStep AD' then
      begin
        if columnName <> '' then
          if AD_FullItemKeyDecoder_FieldsList.IndexOf(columnName) = -1 then
             AD_FullItemKeyDecoder_FieldsList.add(columnName);
      end
      else if tableName = 'ProductionDemand AD' then
      begin
        if columnName <> '' then
          if AD_ProductionDemand_FieldsList.IndexOf(columnName) = -1 then
            AD_ProductionDemand_FieldsList.add(columnName);
      end;

    {  else if tableName = 'FULLITEMKEYDECODER' then
      begin
        if columnName <> '' then
          if AD_ProductionDemand_FieldsList.IndexOf(columnName) = -1 then
            AD_ProductionDemand_FieldsList.add(columnName);
      end; }

    end;
    ArcQry.Next;
  end;
  ArcQry.Active := false;

  PRSV_ITEMTYPEAFICODE := addToSelectedColumns('PRSV', '', 'ITEMTYPEAFICODE', secondSentenceColumnNames, productionColumnNames);

  PRSV_RESERVATIONLINE := addToSelectedColumns('PRSV', '', 'RESERVATIONLINE', secondSentenceColumnNames, productionColumnNames);
  PRSV_BASEPRIMARYQUANTITY := addToSelectedColumns('PRSV', '', 'BASEPRIMARYQUANTITY', secondSentenceColumnNames, productionColumnNames);
  PRSV_USEDBASEPRIMARYQUANTITY := addToSelectedColumns('PRSV', '', 'USEDBASEPRIMARYQUANTITY', secondSentenceColumnNames, productionColumnNames);
  PRSV_PROGRESSSTATUS := addToSelectedColumns('PRSV', '', 'PROGRESSSTATUS', secondSentenceColumnNames, productionColumnNames);
  PRSV_WAREHOUSECODE := addToSelectedColumns('PRSV', '', 'WAREHOUSECODE', secondSentenceColumnNames, productionColumnNames);
  PRSV_REFERENCEITEM := addToSelectedColumns('PRSV', '', 'REFERENCEITEM', secondSentenceColumnNames, productionColumnNames);
  PRSV_ITEMNATURE := addToSelectedColumns('PRSV', '', 'ITEMNATURE', secondSentenceColumnNames, productionColumnNames);
  PRSV_ISSUEDATE := addToSelectedColumns('PRSV', '', 'ISSUEDATE', secondSentenceColumnNames, productionColumnNames);
  PRSV_PROJECTCODE := addToSelectedColumns('PRSV', '', 'PROJECTCODE', secondSentenceColumnNames, productionColumnNames);
//  PRSV_PROGRESSSTATUS := addToSelectedColumns('PRSV', '', 'PROGRESSSTATUS', secondSentenceColumnNames, productionColumnNames);


  secondSentenceColumnNames := secondSentenceColumnNames + ' , CASE WHEN PRSV.ITEMNATURE = ' + QuotedStr('1') + ' THEN FIKDRSR.ABSUNIQUEID ' +
                               ' WHEN PRSV.ITEMNATURE = ' + QuotedStr('4') + ' THEN T.ABSUNIQUEID ' +
                               ' WHEN PRSV.ITEMNATURE = ' + QuotedStr('9') + ' THEN R.ABSUNIQUEID ' +
                               ' WHEN PRSV.ITEMNATURE = ' + QuotedStr('A') + ' THEN D.ABSUNIQUEID ELSE 0 END RSV_FIKD_ABSUNIQUEID ';

  Pos := productionColumnNames.Count;
  productionColumnNames.AddObject('RSV_FIKD_ABSUNIQUEID', pointer(Pos));
  RSV_FIKD_ABSUNIQUEID := Pos;

  secondSentenceColumnNames := secondSentenceColumnNames + ' , CASE WHEN PRSV.ITEMNATURE = ' + QuotedStr('1') + ' THEN FIKDRSR.IDENTIFIER ' +
    ' ELSE 0 END IDENTIFIER ';
  Pos := productionColumnNames.Count;
  productionColumnNames.AddObject('RSV_FIKD_IDENTIFIER', pointer(Pos));
  RSV_FIKD_IDENTIFIER := Pos;

  productionColumnNames.sorted := true;


end;

//----------------------------------------------------------------------------//

function addToSelectedColumns(tablePrefix: String; columnPrefix: String;
                               columnName: String; var selectedColumnNames: String;
                               columnNamesStringList: TStringList) : integer;
var
  updatedColumnName: String;
  Pos : Integer;
begin
  updatedColumnName := copy(tablePrefix + '_' + columnPrefix + columnName, 1, 30);

//  columnNamesStringList.Add(updatedColumnName);
  Pos := columnNamesStringList.Count;
  columnNamesStringList.AddObject(updatedColumnName, pointer(Pos));

  if ( Trim(selectedColumnNames) <> '' ) then
    selectedColumnNames := selectedColumnNames + ', ';

  selectedColumnNames := selectedColumnNames + tablePrefix + '.' + columnName +
                           ' AS ' + updatedColumnName;
  Result := Pos;
end;

//----------------------------------------------------------------------------//

procedure AddAllDemandsToList(HostQry : TMqmQuery);
var
  MQMProductionColumnValues: PMQMProductionColumnValues;
  i: Integer;
  TempTIME: TTime;
  Str : string;
  ConvertDateFormat : Integer;
begin

  if IniAppGlobals.DownloadFrom = '0' then
    ConvertDateFormat := 1
  else if IniAppGlobals.DownloadFrom = '1' then
    ConvertDateFormat := 2
  else
    ConvertDateFormat := 1;

  New(MQMProductionColumnValues);

  MQMProductionColumnValues.columnValues := TStringList.Create;

  if ConvertDateFormat = 1 then
  begin
    for i := 1 to HostQry.FieldCount do
      MQMProductionColumnValues.columnValues.Add( HostQry.Fields.FieldByNumber(i).AsString );
  end

  else if ConvertDateFormat = 2 then
  begin
    var fldTM1_MINBEGINQUEUETIME    := HostQry.FieldByName('PDS_MINBEGINQUEUETIME');
    var fldTM1_MAXENDSTEPTIME       := HostQry.FieldByName('PDS_MAXENDSTEPTIME');
    var fldTM1_STDBEGINPRESETUPTIME := HostQry.FieldByName('PDS_STDBEGINPRESETUPTIME');
    var fldTM1_STDENDSTEPTIME       := HostQry.FieldByName('PDS_STDENDSTEPTIME');
    for i := 1 to HostQry.FieldCount do
    begin
      if HostQry.Fields[I - 1].fieldname = 'PDS_MINBEGINQUEUETIME' then
      begin
        Str := TimeToStr(Frac(fldTM1_MINBEGINQUEUETIME.AsDateTime));
        if (Str = '') or (str = '00:00:00') then
          TempTIME := 0
        else
          TempTIME := StrToTime(Str);
        str := TimeToStr(TempTIME);
        MQMProductionColumnValues.columnValues.Add(str);
      end
      else if HostQry.Fields[I - 1].fieldname = 'PDS_MAXENDSTEPTIME' then
      begin
        Str := TimeToStr(Frac(fldTM1_MAXENDSTEPTIME.AsDateTime));
        if (Str = '') or (str = '00:00:00') then
          TempTIME := 0
        else
          TempTIME := StrToTime(Str);
        str := TimeToStr(TempTIME);
        MQMProductionColumnValues.columnValues.Add(str);
      end
      else if HostQry.Fields[I - 1].fieldname = 'PDS_STDBEGINPRESETUPTIME' then
      begin
        Str := TimeToStr(Frac(fldTM1_STDBEGINPRESETUPTIME.AsDateTime));
        if (Str = '') or (str = '00:00:00') then
          TempTIME := 0
        else
          TempTIME := StrToTime(Str);
        str := TimeToStr(TempTIME);
        MQMProductionColumnValues.columnValues.Add(str);
      end
      else if HostQry.Fields[I - 1].fieldname = 'PDS_STDENDSTEPTIME' then
      begin
        Str := TimeToStr(Frac(fldTM1_STDENDSTEPTIME.AsDateTime));
        if (Str = '') or (str = '00:00:00') then
          TempTIME := 0
        else
          TempTIME := StrToTime(Str);
        str := TimeToStr(TempTIME);
        MQMProductionColumnValues.columnValues.Add(str);
      end
      else
        MQMProductionColumnValues.columnValues.Add( HostQry.Fields.FieldByNumber(i).AsString );
    end;
  end;

  m_ProdCont.m_Demand_list.Add(MQMProductionColumnValues);

end;

//----------------------------------------------------------------------------//

procedure insertTupleToMemoryList(HostQry : TMqmQuery);
var
  MQMProductionColumnValues: PMQMProductionColumnValues;
  i: Integer;
  TempTIME: TTime;
  Str : string;
  ConvertDateFormat : Integer;
begin

  if IniAppGlobals.DownloadFrom = '0' then
    ConvertDateFormat := 1
  else if IniAppGlobals.DownloadFrom = '1' then
    ConvertDateFormat := 2
  else
    ConvertDateFormat := 1;

  New(MQMProductionColumnValues);

  MQMProductionColumnValues.columnValues := TStringList.Create;

  if ConvertDateFormat = 1 then
  begin
    for i := 1 to HostQry.FieldCount do
      MQMProductionColumnValues.columnValues.Add( HostQry.Fields.FieldByNumber(i).AsString );
  end

  else if ConvertDateFormat = 2 then
  begin
    var fldTM2_MINBEGINQUEUETIME    := HostQry.FieldByName('PDS_MINBEGINQUEUETIME');
    var fldTM2_MAXENDSTEPTIME       := HostQry.FieldByName('PDS_MAXENDSTEPTIME');
    var fldTM2_STDBEGINPRESETUPTIME := HostQry.FieldByName('PDS_STDBEGINPRESETUPTIME');
    var fldTM2_STDENDSTEPTIME       := HostQry.FieldByName('PDS_STDENDSTEPTIME');
    for i := 1 to HostQry.FieldCount do
    begin
      if HostQry.Fields[I - 1].fieldname = 'PDS_MINBEGINQUEUETIME' then
      begin
        Str := TimeToStr(Frac(fldTM2_MINBEGINQUEUETIME.AsDateTime));
        if (Str = '') or (str = '00:00:00') then
          TempTIME := 0
        else
          TempTIME := StrToTime(Str);
        str := TimeToStr(TempTIME);
        MQMProductionColumnValues.columnValues.Add(str);
      end
      else if HostQry.Fields[I - 1].fieldname = 'PDS_MAXENDSTEPTIME' then
      begin
        Str := TimeToStr(Frac(fldTM2_MAXENDSTEPTIME.AsDateTime));
        if (Str = '') or (str = '00:00:00') then
          TempTIME := 0
        else
          TempTIME := StrToTime(Str);
        str := TimeToStr(TempTIME);
        MQMProductionColumnValues.columnValues.Add(str);
      end
      else if HostQry.Fields[I - 1].fieldname = 'PDS_STDBEGINPRESETUPTIME' then
      begin
        Str := TimeToStr(Frac(fldTM2_STDBEGINPRESETUPTIME.AsDateTime));
        if (Str = '') or (str = '00:00:00') then
          TempTIME := 0
        else
          TempTIME := StrToTime(Str);
        str := TimeToStr(TempTIME);
        MQMProductionColumnValues.columnValues.Add(str);
      end
      else if HostQry.Fields[I - 1].fieldname = 'PDS_STDENDSTEPTIME' then
      begin
        Str := TimeToStr(Frac(fldTM2_STDENDSTEPTIME.AsDateTime));
        if (Str = '') or (str = '00:00:00') then
          TempTIME := 0
        else
          TempTIME := StrToTime(Str);
        str := TimeToStr(TempTIME);
        MQMProductionColumnValues.columnValues.Add(str);
      end
      else
        MQMProductionColumnValues.columnValues.Add( HostQry.Fields.FieldByNumber(i).AsString );
    end;
  end;

  m_ProdCont.m_Req_Change_List.Add(MQMProductionColumnValues);
end;

//----------------------------------------------------------------------------//

procedure addProductionReservationToList(HostQry: TMqmQuery; productionReservationList: TList; ReservationLines : TList;
                                         productionReservationStringList: TStringList);
var
  MQMProductionReservation: PMQMProductionReservation;
  code: string;
  index: integer;
  ABSUNIQUEID, ORDERCOUNTERCODE, ORDERCODE : string;
  itemNature: string;
  basePrimaryQuantity: double;
  usedBasePrimaryQuantity: double;
  PRSV_SUBCODE01, PRSV_SUBCODE02, PRSV_SUBCODE03, PRSV_SUBCODE04, PRSV_SUBCODE05,
  PRSV_SUBCODE06, PRSV_SUBCODE07, PRSV_SUBCODE08, PRSV_SUBCODE09, PRSV_SUBCODE10 : string;
  ITEMTYPECODE_T, SEARCH_DESCRIPTION_T, SEARCH_DESCRIPTION_P  : string;
  I, RESERVATION_LINE : Integer;
  Quantity : double;
  MQMProductionReservationLine : PMQMProductionReservationLine;
  IsNewRecordReservation : boolean;
begin
  PRSV_SUBCODE01 := '';
  PRSV_SUBCODE02 := '';
  PRSV_SUBCODE03 := '';
  PRSV_SUBCODE04 := '';
  PRSV_SUBCODE05 := '';
  PRSV_SUBCODE06 := '';
  PRSV_SUBCODE07 := '';
  PRSV_SUBCODE08 := '';
  PRSV_SUBCODE09 := '';
  PRSV_SUBCODE10 := '';
  SEARCH_DESCRIPTION_P := '';
  ITEMTYPECODE_T := '';
  SEARCH_DESCRIPTION_T := '';

  var fldRSV_RSV_FIKD_ABSUNIQUEID    := HostQry.Fields.FieldByName('RSV_FIKD_ABSUNIQUEID');
  var fldRSV_PRSV_ITEMNATURE         := HostQry.Fields.FieldByName('PRSV_ITEMNATURE');
  var fldRSV_PRSV_ITEMTYPEAFICODE    := HostQry.Fields.FieldByName('PRSV_ITEMTYPEAFICODE');
  var fldRSV_PDS_STEPNUMBER          := HostQry.Fields.FieldByName('PDS_STEPNUMBER');
  var fldRSV_PD_COUNTERCODE          := HostQry.Fields.FieldByName('PD_COUNTERCODE');
  var fldRSV_PD_CODE                 := HostQry.Fields.FieldByName('PD_CODE');
  var fldRSV_PRSV_RESERVATIONLINE    := HostQry.Fields.FieldByName('PRSV_RESERVATIONLINE');
  var fldRSV_PRSV_BASEPRIMARYQTY     := HostQry.Fields.FieldByName('PRSV_BASEPRIMARYQUANTITY');
  var fldRSV_PRSV_USEDBASEPRIMARYQTY := HostQry.Fields.FieldByName('PRSV_USEDBASEPRIMARYQUANTITY');
  var fldRSV_PRSV_PROGRESSSTATUS     := HostQry.Fields.FieldByName('PRSV_PROGRESSSTATUS');
  var fldRSV_PRSV_WAREHOUSECODE      := HostQry.Fields.FieldByName('PRSV_WAREHOUSECODE');
  var fldRSV_PRSV_REFERENCEITEM      := HostQry.Fields.FieldByName('PRSV_REFERENCEITEM');
  var fldRSV_PRSV_PROJECTCODE        := HostQry.Fields.FieldByName('PRSV_PROJECTCODE');
  var fldRSV_IDENTIFIER              := HostQry.Fields.FieldByName('IDENTIFIER');

  if fldRSV_RSV_FIKD_ABSUNIQUEID.isnull then
     Exit;

  itemNature := Trim(fldRSV_PRSV_ITEMNATURE.AsString);
  ABSUNIQUEID := fldRSV_RSV_FIKD_ABSUNIQUEID.AsString;

  index := searchInList(List_Items, 44, ABSUNIQUEID, 0, List_Items.Count - 1);
  if index <> -1 then
  begin
    PRSV_SUBCODE01 := PTITEMS(List_Items[Index]).SUBCODE01;
    PRSV_SUBCODE02 := PTITEMS(List_Items[Index]).SUBCODE02;
    PRSV_SUBCODE03 := PTITEMS(List_Items[Index]).SUBCODE03;
    PRSV_SUBCODE04 := PTITEMS(List_Items[Index]).SUBCODE04;
    PRSV_SUBCODE05 := PTITEMS(List_Items[Index]).SUBCODE05;
    PRSV_SUBCODE06 := PTITEMS(List_Items[Index]).SUBCODE06;
    PRSV_SUBCODE07 := PTITEMS(List_Items[Index]).SUBCODE07;
    PRSV_SUBCODE08 := PTITEMS(List_Items[Index]).SUBCODE08;
    PRSV_SUBCODE09 := PTITEMS(List_Items[Index]).SUBCODE09;
    PRSV_SUBCODE10 := PTITEMS(List_Items[Index]).SUBCODE10;
    SEARCH_DESCRIPTION_P := PTITEMS(List_Items[Index]).SEARCHDESCRIPTION_P;
    SEARCH_DESCRIPTION_T := PTITEMS(List_Items[Index]).SEARCHDESCRIPTION_T;
    ITEMTYPECODE_T       := PTITEMS(List_Items[Index]).ITEMTYPECODE_T;
  end;

  code := fldRSV_PRSV_ITEMTYPEAFICODE.AsString +
          PRSV_SUBCODE01;//HostQry.Fields.FieldByName('PRSV_SUBCODE01').AsString;

  if (itemNature = '1') then
    {code := code + HostQry.Fields.FieldByName('PRSV_SUBCODE02').AsString +
            HostQry.Fields.FieldByName('PRSV_SUBCODE03').AsString +
            HostQry.Fields.FieldByName('PRSV_SUBCODE04').AsString +
            HostQry.Fields.FieldByName('PRSV_SUBCODE05').AsString +
            HostQry.Fields.FieldByName('PRSV_SUBCODE06').AsString +
            HostQry.Fields.FieldByName('PRSV_SUBCODE07').AsString +
            HostQry.Fields.FieldByName('PRSV_SUBCODE08').AsString +
            HostQry.Fields.FieldByName('PRSV_SUBCODE09').AsString +
            HostQry.Fields.FieldByName('PRSV_SUBCODE10').AsString; }

     code := code + //PRSV_SUBCODE01 +
            PRSV_SUBCODE02 +
            PRSV_SUBCODE03 +
            PRSV_SUBCODE04 +
            PRSV_SUBCODE05 +
            PRSV_SUBCODE06 +
            PRSV_SUBCODE07 +
            PRSV_SUBCODE08 +
            PRSV_SUBCODE09 +
            PRSV_SUBCODE10;

  if( Trim(code) <> '' ) then
  begin
    code := code  + fldRSV_PDS_STEPNUMBER.AsString;

//    index := -1;
   { if productionReservationStringList.sorted then
    begin
      if not productionReservationStringList.Find(code, index) then
         index := -1;
    end
    else
      index := productionReservationStringList.IndexOf(code); }
//   productionReservationList.Sort(SortProductionReservation); // ERAN need top sort after the add new.
    index := FindCodeInproductionReservationList(Code, productionReservationList);
  {  for I := 0 to productionReservationList.count - 1 do
    begin
      if PMQMProductionReservation(productionReservationList[I]).Code = code then
      begin
        Index := I;
        break;
      end;
    end; }

    ORDERCOUNTERCODE := Trim(copy(fldRSV_PD_COUNTERCODE.AsString, 1, 8));
    ORDERCODE        := Trim(fldRSV_PD_CODE.AsString);
    RESERVATION_LINE := fldRSV_PRSV_RESERVATIONLINE.AsInteger;
    MQMProductionReservationLine := FindAndAdd_ReservationLines(ReservationLines, true, ORDERCOUNTERCODE, ORDERCODE, RESERVATION_LINE, IsNewRecordReservation);

    if ( index = -1 ) then
    begin
      //productionReservationStringList.Add(code);

      New(MQMProductionReservation);
      MQMProductionReservation.Code := code;

      MQMProductionReservation.ITEM_NATURE := itemNature;

      if (itemNature = '1') then
      begin
        MQMProductionReservation.PRSV_ITEMTYPEAFICODE := fldRSV_PRSV_ITEMTYPEAFICODE.AsString;
        MQMProductionReservation.PRSV_SUBCODE01 := PRSV_SUBCODE01;//HostQry.Fields.FieldByName('PRSV_SUBCODE01').AsString;
        MQMProductionReservation.PRSV_SUBCODE02 := PRSV_SUBCODE02;//HostQry.Fields.FieldByName('PRSV_SUBCODE02').AsString;
        MQMProductionReservation.PRSV_SUBCODE03 := PRSV_SUBCODE03;//HostQry.Fields.FieldByName('PRSV_SUBCODE03').AsString;
        MQMProductionReservation.PRSV_SUBCODE04 := PRSV_SUBCODE04;//HostQry.Fields.FieldByName('PRSV_SUBCODE04').AsString;
        MQMProductionReservation.PRSV_SUBCODE05 := PRSV_SUBCODE05;//HostQry.Fields.FieldByName('PRSV_SUBCODE05').AsString;
        MQMProductionReservation.PRSV_SUBCODE06 := PRSV_SUBCODE06;//HostQry.Fields.FieldByName('PRSV_SUBCODE06').AsString;
        MQMProductionReservation.PRSV_SUBCODE07 := PRSV_SUBCODE07;//HostQry.Fields.FieldByName('PRSV_SUBCODE07').AsString;
        MQMProductionReservation.PRSV_SUBCODE08 := PRSV_SUBCODE08;//HostQry.Fields.FieldByName('PRSV_SUBCODE08').AsString;
        MQMProductionReservation.PRSV_SUBCODE09 := PRSV_SUBCODE09;//HostQry.Fields.FieldByName('PRSV_SUBCODE09').AsString;
        MQMProductionReservation.PRSV_SUBCODE10 := PRSV_SUBCODE10;//HostQry.Fields.FieldByName('PRSV_SUBCODE10').AsString;
        MQMProductionReservation.SEARCH_DESCRIPTION := SEARCH_DESCRIPTION_P;
       // MQMProductionReservation.SEARCH_DESCRIPTION := HostQry.Fields.FieldByName('P_2_SEARCHDESCRIPTION').AsString;
      end
      else
      begin
        MQMProductionReservation.PRSV_ITEMTYPEAFICODE := ITEMTYPECODE_T;//HostQry.Fields.FieldByName('T_ITEMTYPECODE').AsString;
        MQMProductionReservation.PRSV_SUBCODE01 := PRSV_SUBCODE01;//HostQry.Fields.FieldByName('T_SUBCODE01').AsString;
        MQMProductionReservation.PRSV_SUBCODE02 := '';
        MQMProductionReservation.PRSV_SUBCODE03 := '';
        MQMProductionReservation.PRSV_SUBCODE04 := '';
        MQMProductionReservation.PRSV_SUBCODE05 := '';
        MQMProductionReservation.PRSV_SUBCODE06 := '';
        MQMProductionReservation.PRSV_SUBCODE07 := '';
        MQMProductionReservation.PRSV_SUBCODE08 := '';
        MQMProductionReservation.PRSV_SUBCODE09 := '';
        MQMProductionReservation.PRSV_SUBCODE10 := '';
        MQMProductionReservation.SEARCH_DESCRIPTION := SEARCH_DESCRIPTION_T;//HostQry.Fields.FieldByName('T_SEARCHDESCRIPTION').AsString;
      end;

//      MQMProductionReservation.PRSV_BASEPRIMARYQUANTITY := HostQry.Fields.FieldByName('PRSV_BASEPRIMARYQUANTITY').AsString;
//      MQMProductionReservation.PRSV_USEDBASEPRIMARYQUANTITY := HostQry.Fields.FieldByName('PRSV_USEDBASEPRIMARYQUANTITY').AsString;

      quantity := RoundTo((fldRSV_PRSV_BASEPRIMARYQTY.AsFloat), -2);
      MQMProductionReservation.PRSV_BASEPRIMARYQUANTITY := FloatToStr(quantity);
      quantity := RoundTo((fldRSV_PRSV_USEDBASEPRIMARYQTY.AsFloat), -2);
      MQMProductionReservation.PRSV_USEDBASEPRIMARYQUANTITY := FloatToStr(quantity);

      MQMProductionReservation.PRSV_PROGRESSSTATUS := fldRSV_PRSV_PROGRESSSTATUS.AsString;
      MQMProductionReservation.PRSV_WAREHOUSECODE := fldRSV_PRSV_WAREHOUSECODE.AsString;
      MQMProductionReservation.STEP_NUMBER := fldRSV_PDS_STEPNUMBER.AsString;
      MQMProductionReservation.PRSV_REFERENCEITEM := fldRSV_PRSV_REFERENCEITEM.AsString;
      MQMProductionReservation.PRSV_ABSUNIQUEID   := fldRSV_RSV_FIKD_ABSUNIQUEID.AsString;

      MQMProductionReservation.PRSV_PROJECTCODE   := fldRSV_PRSV_PROJECTCODE.AsString;
      MQMProductionReservation.RSV_FIKD_IDENTIFIER := fldRSV_IDENTIFIER.AsString;

      ////////////////////////////////////////
      ////////////////////////////////////////

      if (MQMProductionReservationLine <> nil) then
        MQMProductionReservation.QUANTITY_ALLOC := MQMProductionReservationLine.AllocatedQuantity
      else
        MQMProductionReservation.QUANTITY_ALLOC := 0;
      productionReservationList.Add(MQMProductionReservation);
      productionReservationList.Sort(SortProductionReservation); // ERAN need top sort after the add new.
    end
    else
    begin
      MQMProductionReservation := productionReservationList.Items[index];

      if( Trim(MQMProductionReservation.PRSV_BASEPRIMARYQUANTITY) <> '' ) then
        basePrimaryQuantity := StrToFloat(Trim(MQMProductionReservation.PRSV_BASEPRIMARYQUANTITY))
      else
        basePrimaryQuantity := 0;

      if( Trim(MQMProductionReservation.PRSV_USEDBASEPRIMARYQUANTITY) <> '' ) then
        usedBasePrimaryQuantity := StrToFloat(Trim(MQMProductionReservation.PRSV_USEDBASEPRIMARYQUANTITY))
      else
        usedBasePrimaryQuantity := 0;


      if ( Trim(fldRSV_PRSV_BASEPRIMARYQTY.AsString) <> '' ) then
      begin
//        basePrimaryQuantity := basePrimaryQuantity +
//                               StrToFloat(Trim(HostQry.Fields.FieldByName('PRSV_BASEPRIMARYQUANTITY').AsString));
        quantity := RoundTo((fldRSV_PRSV_BASEPRIMARYQTY.AsFloat), -2);
        basePrimaryQuantity := basePrimaryQuantity + quantity;
      end;

      if ( Trim(fldRSV_PRSV_USEDBASEPRIMARYQTY.AsString) <> '' ) then
      begin
        usedBasePrimaryQuantity := usedBasePrimaryQuantity +
                                   StrToFloat(Trim(fldRSV_PRSV_USEDBASEPRIMARYQTY.AsString));
        quantity := RoundTo((fldRSV_PRSV_USEDBASEPRIMARYQTY.AsFloat), -2);
        usedBasePrimaryQuantity := usedBasePrimaryQuantity + quantity;
      end;

      if (MQMProductionReservationLine <> nil) then
         MQMProductionReservation.QUANTITY_ALLOC := MQMProductionReservationLine.AllocatedQuantity
      else
        MQMProductionReservation.QUANTITY_ALLOC := 0;

      MQMProductionReservation.PRSV_BASEPRIMARYQUANTITY := FloatToStr(basePrimaryQuantity);
      MQMProductionReservation.PRSV_USEDBASEPRIMARYQUANTITY := FloatToStr(usedBasePrimaryQuantity);
    end;
  end;
end;

//----------------------------------------------------------------------------//

function getUserGenericGroupTypeAttribute(Attribute : String; SUBCODE : string; MQMProductionColumnValues : PMQMProductionColumnValues;
         UserGenericGroupTypeList, UserGenericGroupAttributesList : TList) : String;

var
  PD_SUBCODE, itemType, UserGenericGroupType, SUBCODEVALUE, ABSUNIQUEID : string;
  SUBCODENR, index : integer;
  CUR_ADDITIONALDATA_HEADER: PADDITIONALDATA_HEADERS;
  UserGenericGroupTypeAttributes : PTUserGenericGroupAttributes;
begin
  PD_SUBCODE  := 'PD_SUBCODE' + SUBCODE;
  SUBCODENR := strtoint(SUBCODE);
  itemType := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_ITEMTYPEAFICODE', PDS_ITEMTYPEAFICODE));
  UserGenericGroupType := getUserGenericGroupType(ItemType, SUBCODENR, UserGenericGroupTypeList);
  case SUBCODENR of
    1: SUBCODEVALUE := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, PD_SUBCODE, PD_SUBCODE01));
    2 : SUBCODEVALUE := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, PD_SUBCODE, PD_SUBCODE02));
    3 : SUBCODEVALUE := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, PD_SUBCODE, PD_SUBCODE03));
    4 : SUBCODEVALUE := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, PD_SUBCODE, PD_SUBCODE04));
    5 : SUBCODEVALUE := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, PD_SUBCODE, PD_SUBCODE05));
    6 : SUBCODEVALUE := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, PD_SUBCODE, PD_SUBCODE06));
    7 : SUBCODEVALUE := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, PD_SUBCODE, PD_SUBCODE07));
    8 : SUBCODEVALUE := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, PD_SUBCODE, PD_SUBCODE08));
    9 : SUBCODEVALUE := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, PD_SUBCODE, PD_SUBCODE09));
    10 : SUBCODEVALUE := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, PD_SUBCODE, PD_SUBCODE10));
  end;
  UserGenericGroupTypeAttributes := getUserGenericGroupTypeAttributes(UserGenericGroupType, SUBCODEVALUE, UserGenericGroupAttributesList);
  Result := '';
  if assigned(UserGenericGroupTypeAttributes) then
  begin
    if Attribute = 'ABSUNIQUEID' then
      Result := UserGenericGroupTypeAttributes.ABSUNIQUEID
    else if Attribute = 'USERGENERICGROUPTYPECODE' then
      Result := UserGenericGroupTypeAttributes.USERGENERICGROUPTYPECODE
    else if Attribute = 'CODE' then
      Result := UserGenericGroupTypeAttributes.CODE
    else if Attribute = 'LONGDESCRIPTION' then
      Result := UserGenericGroupTypeAttributes.LONGDESCRIPTION
    else if Attribute = 'SHORTDESCRIPTION' then
      Result := UserGenericGroupTypeAttributes.SHORTDESCRIPTION
    else if Attribute = 'SEARCHDESCRIPTION' then
      Result := UserGenericGroupTypeAttributes.SEARCHDESCRIPTION;
  end;


end;

//----------------------------------------------------------------------------//

function GetIndexForUserGenericGroupTable(SUBCODE : string; MQMProductionColumnValues : PMQMProductionColumnValues;
         additionalDataList, UserGenericGroupTypeList, UserGenericGroupAttributesList : TList) : integer;

var
  ABSUNIQUEID : string;
  UserGenericGroupTypeAttributes : PTUserGenericGroupAttributes;
begin
  Result := -1;
  ABSUNIQUEID := getUserGenericGroupTypeAttribute('ABSUNIQUEID', SUBCODE, MQMProductionColumnValues, UserGenericGroupTypeList, UserGenericGroupAttributesList);
  if ABSUNIQUEID <> '' then
    Result := searchInList(additionalDataList, 8, ABSUNIQUEID, 0, additionalDataList.Count - 1);
end;

//----------------------------------------------------------------------------//

function GetIndexForColorTable(SUBCODE : string; MQMProductionColumnValues : PMQMProductionColumnValues; additionalDataList,
         ColorTypeList, ColorTypeUNIQUEIDList : TList) : Integer;
var
  PD_SUBCODE, itemType, ColorType, SUBCODEVALUE, ABSUNIQUEID : string;
  SUBCODENR, index : integer;
  CUR_ADDITIONALDATA_HEADER: PADDITIONALDATA_HEADERS;
begin
  Result := -1;
  PD_SUBCODE  := 'PD_SUBCODE' + SUBCODE;
  SUBCODENR := strtoint(SUBCODE);
  itemType := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_ITEMTYPEAFICODE', PDS_ITEMTYPEAFICODE));
  ColorType := getColorType(ItemType, SUBCODENR, ColorTypeList);
  case SUBCODENR of
    1: SUBCODEVALUE := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, PD_SUBCODE, PD_SUBCODE01));
    2 : SUBCODEVALUE := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, PD_SUBCODE, PD_SUBCODE02));
    3 : SUBCODEVALUE := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, PD_SUBCODE, PD_SUBCODE03));
    4 : SUBCODEVALUE := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, PD_SUBCODE, PD_SUBCODE04));
    5 : SUBCODEVALUE := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, PD_SUBCODE, PD_SUBCODE05));
    6 : SUBCODEVALUE := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, PD_SUBCODE, PD_SUBCODE06));
    7 : SUBCODEVALUE := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, PD_SUBCODE, PD_SUBCODE07));
    8 : SUBCODEVALUE := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, PD_SUBCODE, PD_SUBCODE08));
    9 : SUBCODEVALUE := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, PD_SUBCODE, PD_SUBCODE09));
    10 : SUBCODEVALUE := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, PD_SUBCODE, PD_SUBCODE10));
  end;
  ABSUNIQUEID := getColorTypeUNIQUEID(ColorType, SUBCODEVALUE, ColorTypeUNIQUEIDList);
  index := searchInList(additionalDataList, 8, ABSUNIQUEID, 0, additionalDataList.Count - 1);
  Result := Index;
end;

//----------------------------------------------------------------------------//

function getValueOfTheProductionColumnByFindPos(MQMProductionColumnValues: PMQMProductionColumnValues;
                                       colName: String): String;
var
  index: integer;
  Obj : TObject;
  TempDouble : DOUBLE;
begin
  Result := '';
  index := -1;

  if colName.IndexOf('_') = 0 then       // this part added by mihailo need to be super sure
    colName := copy(colName, 2, 30)      //
  else                                   //
    colName := copy(colName, 1, 30);     //  til here

  if productionColumnNames.sorted then
  begin
    if (colName = 'PDS_WORKCENTERCODE') then
    begin
      index := PDS_WORKCENTERCODE;
    end
    else
    begin
      if not productionColumnNames.Find(colName, index) then
         index := -1
      else
      begin
        Obj := TObject(productionColumnNames.Objects[Index]);
        Index := Integer(Obj);
      end;
    end;
  end
  else
    index := productionColumnNames.IndexOf( colName );
  if( index <> -1 ) then
    Result := MQMProductionColumnValues.columnValues.Strings[ index ]
  else
  begin
    ShowMessage('productionColumnNames doesnt have column ' + colName + char (13) + 'getValueOfTheProductionColumnByFindPos');
  end;
end;
function getValueOfTheProductionColumn(MQMProductionColumnValues: PMQMProductionColumnValues;
                                       colName: string; colNameInt: Integer): String;
var
  index: integer;
  Obj : TObject;
  TempDouble : DOUBLE;
begin
  Result := '';
  index := -1;

  if productionColumnNames.sorted then
  begin
    index := colNameInt;
  end;
 // else
  //  index := productionColumnNames.IndexOf( colName );

//  index := productionColumnNames.IndexOf( colName );
  if( index <> -1 ) then
    Result := MQMProductionColumnValues.columnValues.Strings[ index ]
  else
  begin
    //SqlPrint := TStringList.Create;
    //SqlPrint.add(colName);
    //SqlPrint.SaveToFile('c:\Column.txt');
    ShowMessage(colName);
  end;

end;

//----------------------------------------------------------------------------//

procedure insertTheTuplesToProductionTables(productionDemandTemplates: TList;
                                            handledWorkCentersList: TList;
                                            unhandledWorkCentersList: TList;
                                            srvQryFD: TMqmQuery;
                                            propertyList: TList;
                                            resList : TList;
                                            additionalDataList,
                                            UserGenericGroupTypeList, UserGenericGroupTypeAttributesList : TList;
                                            ColorTypeList, ColorTypeUNIQUEIDList : TList;
                                            productionReservationList: TList;
                                          //  productPrimaryUomConversionDataList: TList;
                                          //  secondaryUnitCategoryConversionList: TList;
                                         //   stdUnitCategoryConversionList: TList;
                                            routingStepTimeTypeList: TList;
                                            operationList: TList; articleTypeList: TList;
                                            productsList: TList;
                                            read_produced_article_list: TList;
                                            read_material_list: TList;
                                            currentProductsList: TList;
                                            logicalWarehouseList: TList;
                                            read_prod_req_list: TList;
                                            read_prod_reqhdr_list: TList;
                                            read_prod_step_list: TList;
                                            read_prod_step_time_list: TList;
                                            read_prop_prod_list: TList;
                                            read_prod_step_batch_size_list: TList;
                                            stepIdListForProgressList_PD: TList;
                                            stepIdListForProgressList_PO: TList;
                                            stepIdListForProgressList_PO_SL: TStringList;
                                            itemTypeTemplates: TList;
                                            productionDemandCounters: TList;
                                            alternativeWarehouseList: TList;
                                            read_prod_reqConn_list: TList;
                                            alreadyAddedPROD_REQCONN: TStringList;
                                            additionalDataWithRelationList: TList;
                                            itemTypeLogicalWarehouseList: TList;
                                            //Items : PTItems;
                                            Steps, Recipes, Designs : TStringList;
                                            standardWeightUnit: String);
var
  MQMProductionColumnValues: PMQMProductionColumnValues;
  CUR_PRODUCTIONDEMANDTEMPLATE: PPRODUCTIONDEMANDTEMPLATES;
  templateIndex: Integer;
  Time_insertTheTuplesToProductionTables : double;
begin
  Time_insertTheTuplesToProductionTables := NOW;
  MQMProductionColumnValues := m_ProdCont.m_Req_Change_List.Items[0];

  templateIndex := searchInList(productionDemandTemplates, 22,
                                Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_TEMPLATECODE', PD_TEMPLATECODE)),
                                0, productionDemandTemplates.Count - 1);

  if (templateIndex <> -1) then
  begin
    if ( checkWhetherAnyWorkCentersHandled(handledWorkCentersList) ) then
    begin
      CUR_PRODUCTIONDEMANDTEMPLATE := productionDemandTemplates.Items[templateIndex];

      if (CUR_PRODUCTIONDEMANDTEMPLATE.HANDLEDBYMQM = '1') then
      begin
        if ( checkWhetherAnyProductionOrderCodeIsNotBlank() ) then
        begin
          insertProductionDemandDataIntoTables(srvQryFD, handledWorkCentersList,
                                               unhandledWorkCentersList,
                                               propertyList, resList,
                                               additionalDataList,
                                               UserGenericGroupTypeList, UserGenericGroupTypeAttributesList,
                                               ColorTypeList, ColorTypeUNIQUEIDList,
                                               productionReservationList,
                                             //  productPrimaryUomConversionDataList,
                                            //   secondaryUnitCategoryConversionList,
                                            //   stdUnitCategoryConversionList,
                                               routingStepTimeTypeList,
                                               operationList, articleTypeList,
                                               productsList,
                                               read_produced_article_list,
                                               read_material_list,
                                               currentProductsList,
                                               logicalWarehouseList,
                                               CUR_PRODUCTIONDEMANDTEMPLATE,
                                               read_prod_req_list, read_prod_reqhdr_list,
                                               read_prod_step_list, read_prod_step_time_list,
                                               read_prop_prod_list, read_prod_step_batch_size_list,
                                               stepIdListForProgressList_PD,
                                               stepIdListForProgressList_PO,
                                               stepIdListForProgressList_PO_SL,
                                               itemTypeTemplates,
                                               productionDemandCounters,
                                               alternativeWarehouseList,
                                               read_prod_reqConn_list,
                                               alreadyAddedPROD_REQCONN,
                                               additionalDataWithRelationList,
                                               itemTypeLogicalWarehouseList,
                                               {Items,} Steps, Recipes, Designs,
                                               standardWeightUnit);
        end;
      end
      else
      begin
        insertProductionDemandDataIntoTables(srvQryFD, handledWorkCentersList,
                                             unhandledWorkCentersList,
                                             propertyList, resList,
                                             additionalDataList, UserGenericGroupTypeList, UserGenericGroupTypeAttributesList,
                                             ColorTypeList, ColorTypeUNIQUEIDList,
                                             productionReservationList,
                                          //   productPrimaryUomConversionDataList,
                                          //   secondaryUnitCategoryConversionList,
                                          //   stdUnitCategoryConversionList,
                                             routingStepTimeTypeList,
                                             operationList, articleTypeList,
                                             productsList,
                                             read_produced_article_list,
                                             read_material_list,
                                             currentProductsList,
                                             logicalWarehouseList,
                                             CUR_PRODUCTIONDEMANDTEMPLATE,
                                             read_prod_req_list, read_prod_reqhdr_list,
                                             read_prod_step_list, read_prod_step_time_list,
                                             read_prop_prod_list, read_prod_step_batch_size_list,
                                             stepIdListForProgressList_PD,
                                             stepIdListForProgressList_PO,
                                             stepIdListForProgressList_PO_SL,
                                             itemTypeTemplates,
                                             productionDemandCounters,
                                             alternativeWarehouseList,
                                             read_prod_reqConn_list,
                                             alreadyAddedPROD_REQCONN,
                                             additionalDataWithRelationList,
                                             itemTypeLogicalWarehouseList,
                                             {Items,} Steps, Recipes, Designs,
                                             standardWeightUnit);
      end;
    end;

    handledProductionDemands.Add(setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COUNTERCODE', PD_COUNTERCODE), 8) +
                                 getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_CODE', PD_CODE));

  end;
  IniAppGlobals.Time_insertTheTuplesToProductionTables := IniAppGlobals.Time_insertTheTuplesToProductionTables + (Now - Time_insertTheTuplesToProductionTables);
end;

//----------------------------------------------------------------------------//

function checkWhetherAnyWorkCentersHandled(handledWorkCentersList: TList): boolean;
var
  i: integer;
  MQMProductionColumnValues: PMQMProductionColumnValues;
  searchValue: String;
begin
  result := false;
  for i := 0 to m_ProdCont.m_Req_Change_List.Count - 1 do
  begin
    MQMProductionColumnValues := m_ProdCont.m_Req_Change_List.Items[i];

    searchValue := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_WORKCENTERCODE', PDS_WORKCENTERCODE);

    if ( searchInList(handledWorkCentersList, 1, searchValue,
                      0, handledWorkCentersList.Count - 1) <> - 1 ) then
    begin
      result := true;
      break;
    end;
  end;
end;

//----------------------------------------------------------------------------//

function checkWhetherAnyProductionOrderCodeIsNotBlank(): boolean;
var
  i: integer;
  MQMProductionColumnValues: PMQMProductionColumnValues;
begin
  result := false;
  for i := 0 to m_ProdCont.m_Req_Change_List.Count - 1 do
  begin
    MQMProductionColumnValues := m_ProdCont.m_Req_Change_List.Items[i];

    if ( Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_PRODUCTIONORDERCODE', PDS_PRODUCTIONORDERCODE)) <> '' ) then
    begin
      result := true;
      break;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure insertProductionDemandDataIntoTables(srvQryFD: TMqmQuery;
                                               handledWorkCentersList: TList;
                                               unhandledWorkCentersList: TList;
                                               propertyList: TList; resList : TList;
                                               additionalDataList,
                                               UserGenericGroupTypeList, UserGenericGroupTypeAttributesList : TList;
                                               ColorTypeList, ColorTypeUNIQUEIDList : TList;
                                               productionReservationList: TList;
                                            //   productPrimaryUomConversionDataList: TList;
                                            //   secondaryUnitCategoryConversionList: TList;
                                            //   stdUnitCategoryConversionList: TList;
                                               routingStepTimeTypeList: TList;
                                               operationList: TList; articleTypeList: TList;
                                               productsList: TList;
                                               read_produced_article_list: TList;
                                               read_material_list: TList;
                                               currentProductsList: TList;
                                               logicalWarehouseList: TList;
                                               CUR_PRODUCTIONDEMANDTEMPLATE: PPRODUCTIONDEMANDTEMPLATES;
                                               read_prod_req_list: TList;
                                               read_prod_reqhdr_list: TList;
                                               read_prod_step_list: TList;
                                               read_prod_step_time_list: TList;
                                               read_prop_prod_list: TList;
                                               read_prod_step_batch_size_list: TList;
                                               stepIdListForProgressList_PD: TList;
                                               stepIdListForProgressList_PO: TList;
                                               stepIdListForProgressList_PO_SL: TStringList;
                                               itemTypeTemplates: TList;
                                               productionDemandCounters: TList;
                                               alternativeWarehouseList: TList;
                                               read_prod_reqConn_list: TList;
                                               alreadyAddedPROD_REQCONN: TStringList;
                                               additionalDataWithRelationList: TList;
                                               itemTypeLogicalWarehouseList: TList;
                                               //Items : PTItems;
                                               Steps, Recipes, Designs : TStringList;
                                               standardWeightUnit: String
                                               );
var
  j, I, TempIndex : integer;
  MQMProductionColumnValues: PMQMProductionColumnValues;
  MQMProductionColumnValues_Test: PMQMProductionColumnValues;

  LastStepMQMProductionColumnValues: PMQMProductionColumnValues;

  isWorkCenterHandledByMqm : string;
  isWorkCenterHandledByMcm : string;
  isWorkCenterHandled: string;
  stepsHandledByMqm: TStringList;
  stepsHandledByMcm: TStringList;
  previousStepHandledByMqm: String;
  previousStepHandledByMcm: String;
  previousStepInDemand: String;
  nextStepHandledByMqm: String;
  nextStepHandledByMcm: String;
  nextStepInDemand: String;
  timeTypeCode: String;
  stepNumbersOfHandledWorkCenters: TStringList;
  stepNumbersOfHandledNameOfWorkCenters: TStringList;

  productionDemandCode: String;
  productionDemandStep: String;
  productionOrderCode: String;
  productionOrderStep: String;

  searchValue: String;
  CUR_WORKCENTER: PWORKCENTERS;

  mcmLeadQueueTimePrevStep: double;
  timeValue: double;
  sumValue: double;

  NEW_STEP_ID_PRODUCTIONDEMAND: PSTEP_ID_PRODUCTIONDEMANDSANDORDERS;

  uniqueWorkCenterProcesses: TStringList;
  nonUniqueWorkCenterProcesses: TStringList;

  tempVal, PRODUCT_CODE: String;
  HeaderPropList : TList;
  PrevNextToBeSchedListMqm : TStringList;
  PrevNextToBeSchedListMcm : TStringList;
  stepsHandledByMqmDict    : TDictionary<string, Boolean>;
  stepsHandledByMcmDict    : TDictionary<string, Boolean>;
  PrevNextMqmDict          : TDictionary<string, Boolean>;
  PrevNextMcmDict          : TDictionary<string, Boolean>;
  ProductionOrderStepStruct : PTProductionOrderStepStruct;
  ServedCode, PREQ_NO : string;
  FoundServedCode,MatchReservation, FoundCurveFamily_IdCode, CurveFamily_IdCode_BuildFromProp, FoundCurveFamily_IdCode_BuildFromProp : boolean;
  index : integer;
  StepWorkCenter : array of PWORKCENTERS;
  Items : PTItems;
  ItemNotfoundList : TStringList;
  ContainproductionOrderCode, UpdatePropertyLinker : boolean;
  GenericOrder, GenericLine, GenericDelivery, GenericProject, GenericBusinessPartner, GenericProjectSalesPointer : PRGeneric;
  PTNA_REC : PT_TNA;
  CounterCode, Code, Line, SubLine, ComponentLine, DeliveryLine, ProjectCode, CustomerCode, ServingCode, CurveFamily_IdCode, Found_CurveFamily_IdCode : String;
  DemandCounterCode, DemandCode : String;
  Value : Extended;
  CurrentTime_For_progress, CurrentTime_Hdr, CurrentTime_Prodreq, CurrentTime_article, CurrentTime_Material, CurrentTime_Reqconn, CurrentTime_StepTimes,
  CurrentTime_Time_For_steps, CurrentTime_Time_For_properties, CurrentTime_Time_For_BatchSize ,CurrentTime_Time_For_progress : double;
begin
  CurveFamily_IdCode := '';
  FoundServedCode := false;
  FoundCurveFamily_IdCode := false;
  FoundCurveFamily_IdCode_BuildFromProp := false;
  ContainproductionOrderCode := false;
  PrevNextToBeSchedListMqm := TStringlist.Create;
  PrevNextToBeSchedListMcm := TStringlist.Create;
  stepsHandledByMqm := TStringlist.Create;
  stepsHandledByMcm := TStringlist.Create;
  stepsHandledByMqmDict := TDictionary<string, Boolean>.Create;
  stepsHandledByMcmDict := TDictionary<string, Boolean>.Create;
  PrevNextMqmDict       := TDictionary<string, Boolean>.Create;
  PrevNextMcmDict       := TDictionary<string, Boolean>.Create;
  HeaderPropList    := TList.Create;
  stepNumbersOfHandledWorkCenters := TStringList.Create;
  stepNumbersOfHandledNameOfWorkCenters := TStringList.Create;

  PRODUCT_CODE := '';
  sumValue := 0;
  timeValue := 0;
  mcmLeadQueueTimePrevStep := 0;
  NEW_STEP_ID_PRODUCTIONDEMAND := NIL;
  LastStepMQMProductionColumnValues := nil;
  uniqueWorkCenterProcesses := TStringList.Create;
  nonUniqueWorkCenterProcesses := TStringList.Create;
  SetLength(StepWorkCenter, m_ProdCont.m_Req_Change_List.Count);

  // for progress
  CurrentTime_For_progress := now;
  for i := 0 to m_ProdCont.m_Req_Change_List.Count - 1 do
  begin
    MQMProductionColumnValues := m_ProdCont.m_Req_Change_List.Items[i];

    fillUnique_nonUniqueWorkCenterProcesses(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_WORKCENTERCODE', PDS_WORKCENTERCODE),
                                            getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_OPERATIONCODE', PDS_OPERATIONCODE),
                                            uniqueWorkCenterProcesses, nonUniqueWorkCenterProcesses);


    if (i = 0) then
    begin
      // Add by Erbil  on 08/08/2008
      New(NEW_STEP_ID_PRODUCTIONDEMAND);
      NEW_STEP_ID_PRODUCTIONDEMAND.Code := setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COUNTERCODE', PD_COUNTERCODE), 8) +
                                           Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_CODE', PD_CODE));
      NEW_STEP_ID_PRODUCTIONDEMAND.workCenterList := TList.Create;
      NEW_STEP_ID_PRODUCTIONDEMAND.operationList := TList.Create;
      NEW_STEP_ID_PRODUCTIONDEMAND.stepIdList := TList.Create;

      stepIdListForProgressList_PD.Add(NEW_STEP_ID_PRODUCTIONDEMAND);
    end;

    if (Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_PRODUCTIONORDERCODE', PDS_PRODUCTIONORDERCODE)) <> '') then
    begin
      ifNeededAddToStepIdListForProgressList_PO(Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_PRODUCTIONORDERCODE', PDS_PRODUCTIONORDERCODE)),
                                                Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_WORKCENTERCODE', PDS_WORKCENTERCODE)),
                                                Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_OPERATIONCODE', PDS_OPERATIONCODE)),
                                                getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_STEPNUMBER', PDS_STEPNUMBER),
                                                getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_INITIALBASEPRIMARYQUANTITY', PDS_INITIALBASEPRIMARYQUANTITY),
                                                getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_FINALBASEPRIMARYQUANTITY', PDS_FINALBASEPRIMARYQUANTITY),
                                                stepIdListForProgressList_PO,
                                                stepIdListForProgressList_PO_SL);
    end;

    searchValue := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_WORKCENTERCODE', PDS_WORKCENTERCODE);


    index := searchInList(handledWorkCentersList, 1, searchValue, 0, handledWorkCentersList.Count - 1);

//    if ( searchInList(handledWorkCentersList, 1, searchValue,
//                      0, handledWorkCentersList.Count - 1) <> - 1 ) then
    if index <> -1 then

    begin
      StepWorkCenter[i] := PWORKCENTERS(handledWorkCentersList[index]);
      ifNeededAddWorkCenterAndOperationToList(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_WORKCENTERCODE', PDS_WORKCENTERCODE),
                                              getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_OPERATIONCODE', PDS_OPERATIONCODE),
                                              getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_STEPNUMBER', PDS_STEPNUMBER),
                                              getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_INITIALBASEPRIMARYQUANTITY', PDS_INITIALBASEPRIMARYQUANTITY),
                                              getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_FINALBASEPRIMARYQUANTITY', PDS_FINALBASEPRIMARYQUANTITY),
                                              NEW_STEP_ID_PRODUCTIONDEMAND.workCenterList,
                                              NEW_STEP_ID_PRODUCTIONDEMAND.operationList,
                                              NEW_STEP_ID_PRODUCTIONDEMAND.stepIdList);

      if (StepWorkCenter[i].WC_HANDLEDBYMQM = '1') then
      begin
        stepsHandledByMqm.Add(IntToStr(i));
        stepsHandledByMqmDict.AddOrSetValue(IntToStr(i), true);
      end;

      if (StepWorkCenter[i].WC_HANDLEDBYMCM = '1') then
      begin
        stepsHandledByMcm.Add(IntToStr(i));
        stepsHandledByMcmDict.AddOrSetValue(IntToStr(i), true);
      end;

      stepNumbersOfHandledWorkCenters.Add( getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_STEPNUMBER', PDS_STEPNUMBER) );
      stepNumbersOfHandledNameOfWorkCenters.Add( getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_WORKCENTERCODE', PDS_WORKCENTERCODE));

      //Added by Erbil  on 26/08/2008
      productionDemandCode := setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COUNTERCODE', PD_COUNTERCODE), 8) +
                              getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_CODE', PD_CODE);
      productionDemandStep := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_STEPNUMBER', PDS_STEPNUMBER);
      productionOrderCode := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_PRODUCTIONORDERCODE', PDS_PRODUCTIONORDERCODE);
      productionOrderStep := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_GROUPSTEPNUMBER', PDS_GROUPSTEPNUMBER);

//      addToHandled_PD_PO(Trim(productionDemandCode), Trim(productionDemandStep),
//                         Trim(productionOrderCode), Trim(productionOrderStep));

    //  if ( CUR_PRODUCTIONDEMANDTEMPLATE.HANDLEDBYMCM = '1' ) then
   //     stepsHandledByMcm.Add(IntToStr(i));

      if Trim(productionOrderCode) <> '' then
      begin
        new(ProductionOrderStepStruct);
        ProductionOrderStepStruct.ProductionOrder := Trim(productionOrderCode);
        ProductionOrderStepStruct.GroupStepNumber := Trim(productionOrderStep);
        ProductionOrderStepStruct.StepNumber      := Trim(productionDemandStep);
        ProductionOrderStepStruct.DemandCode      := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_CODE', PD_CODE));
        ProductionOrderStepStruct.DemandCounterCode := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COUNTERCODE', PD_COUNTERCODE));
        ProductionOrderStepStruct.FinalBasePrimaryQuantity := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_FINALBASEPRIMARYQUANTITY', PDS_FINALBASEPRIMARYQUANTITY);
        ProductionOrderStepStruct.WorkCenter := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_WORKCENTERCODE', PDS_WORKCENTERCODE));
        ProductionOrderStepStruct.Operation  := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_OPERATIONCODE', PDS_OPERATIONCODE));
        ProductionOrderStepStruct.INITIALQUANTITY := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_INITIALBASEPRIMARYQUANTITY', PDS_INITIALBASEPRIMARYQUANTITY);
        ProductionOrderStepStruct.FINALQUANTITY   := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_FINALBASEPRIMARYQUANTITY', PDS_FINALBASEPRIMARYQUANTITY);
        tempVal := getNumericValueOf(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_CALCULATEDTIME2', PDS_CALCULATEDTIME2));
        ProductionOrderStepStruct.SetUp := FloatToStr(StrToFloat(tempVal) * 60);
        tempVal := getNumericValueOf(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_CALCULATEDTIME3', PDS_CALCULATEDTIME3));
        ProductionOrderStepStruct.Execution := FloatToStr(StrToFloat(tempVal) * 60);
        ProductionOrderStepStructList.add(ProductionOrderStepStruct);
      end;
    end;
  end;

  IniAppGlobals.Time_For_progress := IniAppGlobals.Time_For_progress + (Now - CurrentTime_For_progress);

  Items := nil;
  GenericOrder := nil;
  GenericLine := nil;
  GenericDelivery := nil;
  GenericProject := nil;
  GenericBusinessPartner := nil;
  UpdatePropertyLinker := true;
  CurveFamily_IdCode_BuildFromProp := false;

  for i := 0 to m_ProdCont.m_Req_Change_List.Count - 1 do
  begin
    MQMProductionColumnValues := m_ProdCont.m_Req_Change_List.Items[i];

    if i = 0 then
    begin

      index := searchInList(List_Items, 44, getValueOfTheProductionColumn(MQMProductionColumnValues, 'FIKD_ABSUNIQUEID', FIKD_ABSUNIQUEID), 0, List_Items.Count - 1);
      if Index <> -1  then
        Items := PTITEMS(List_Items[Index])
      else
      begin
        PREQ_NO := setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COMPANYCODE', PD_COMPANYCODE), 3) +
                             setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COUNTERCODE', PD_COUNTERCODE), 8) +
                             getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_CODE', PD_CODE);
        ItemNotfoundList := TStringList.create;
        ItemNotfoundList.Add('ItemWarehouseLink missing OR ..... ');
        ItemNotfoundList.Add('Request : ' + PREQ_NO);
        ItemNotfoundList.SaveToFile(LocAppGlobals.AppDir + '\ItemNotFound.txt');
        ItemNotfoundList.Free;
        break
      end;

      CounterCode := '';
      if trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ORIGDLVSALORDLINESALORDCNTCOD', PD_ORIGDLVSALORDLINESALORDCNTCOD)) <> '' then
      begin
        CounterCode := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ORIGDLVSALORDLINESALORDCNTCOD', PD_ORIGDLVSALORDLINESALORDCNTCOD);
        Code := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ORIGDLVSALORDLINESALORDERCODE', PD_ORIGDLVSALORDLINESALORDERCODE);
        Line := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ORIGDLVSALORDERLINEORDERLINE', PD_ORIGDLVSALORDERLINEORDERLINE);
        SubLine := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ORIGDLVSALORDLINEORDERSUBLINE', PD_ORIGDLVSALORDLINEORDERSUBLINE);
        ComponentLine := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ORIGDLVSALORDLINECMPORDERLINE', PD_ORIGDLVSALORDLINECMPORDERLINE);
        DeliveryLine := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ORIGDELIVERYDELIVERYLINE', PD_ORIGDELIVERYDELIVERYLINE);
      end
      else
      begin
        if trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_PROJECTCODE', PD_PROJECTCODE)) <> '' then
        begin
          DemandCounterCode := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COUNTERCODE', PD_COUNTERCODE);
          DemandCode := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_CODE', PD_CODE);
          GenericProjectSalesPointer := FindGenericBinarSearch(List_Generic, 'SalesOrderDeliveryByDemandProject', DemandCounterCode, DemandCode, 0, 0, 0, 0);
          if GenericProjectSalesPointer = nil then
          begin
            ProjectCode := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_PROJECTCODE', PD_PROJECTCODE);
            GenericProjectSalesPointer := FindGenericBinarSearch(List_Generic, 'SalesOrderDeliveryByProject', ProjectCode, 0, 0, 0, 0, 0);
          end;
          if GenericProjectSalesPointer <> nil then
          begin
            CounterCode := GenericProjectSalesPointer.ColumnValue.Strings[0];
            Code := GenericProjectSalesPointer.ColumnValue.Strings[1];
            Line := GenericProjectSalesPointer.ColumnValue.Strings[2];
            SubLine := GenericProjectSalesPointer.ColumnValue.Strings[3];
            ComponentLine := GenericProjectSalesPointer.ColumnValue.Strings[4];
            DeliveryLine := GenericProjectSalesPointer.ColumnValue.Strings[5];
          end;
        end;

      end;

      if trim(CounterCode) <> '' then
      begin
        GenericOrder := FindGenericBinarSearch(List_Generic, 'SalesOrder', CounterCode, Code, 0, 0, 0, 0);
        if not TryStrToFloat(Line, Value) then
          Line := '0';
        if not TryStrToFloat(SubLine, Value) then
          SubLine := '0';
        if not TryStrToFloat(ComponentLine, Value) then
          ComponentLine := '0';
        if not TryStrToFloat(DeliveryLine, Value) then
          DeliveryLine := '0';
        GenericLine  := FindGenericBinarSearch(List_Generic, 'SalesOrderLine', CounterCode, Code, StrToFloat(Line), StrToFloat(SubLine), StrToFloat(ComponentLine), 0);
        if (CUR_PRODUCTIONDEMANDTEMPLATE.TNAORIGIN = '1') and (GenericOrder <> nil) then
          PTNA_REC     := FindTNA_BinarSearch(List_TNA, GenericOrder.ABSUniqueId)
        else if (CUR_PRODUCTIONDEMANDTEMPLATE.TNAORIGIN = '2') and (GenericLine <> nil) then
          PTNA_REC     := FindTNA_BinarSearch(List_TNA, GenericLine.ABSUniqueId);
        GenericDelivery := FindGenericBinarSearch(List_Generic, 'SalesOrderDelivery', CounterCode, Code, StrToFloat(Line), StrToFloat(SubLine), StrToFloat(ComponentLine), StrToFloat(DeliveryLine));
      end;

      if trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_PROJECTCODE', PD_PROJECTCODE)) <> '' then
      begin
        ProjectCode := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_PROJECTCODE', PD_PROJECTCODE);
        GenericProject := FindGenericBinarSearch(List_Generic, 'Project', ProjectCode, 0, 0, 0, 0, 0);
      end;

      CustomerCode := trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_CUSTOMERCODE', PD_CUSTOMERCODE));
      if (trim(CustomerCode) = '') and assigned(GenericOrder) then
      begin
        Index := GenericOrder.ColumnNames.IndexOf('SO_ORDPRNCUSTOMERSUPPLIERCODE');
        if Index <> -1 then
          CustomerCode := GenericOrder.ColumnValue.Strings[Index];
      end;
      if trim(CustomerCode) <> '' then
        GenericBusinessPartner := FindGenericBinarSearch(List_Generic, 'BusinessPartner', CustomerCode, 0, 0, 0, 0, 0);

      CurrentTime_Prodreq := NOW;
      insertIntoPROD_REQ_List(MQMProductionColumnValues, CUR_PRODUCTIONDEMANDTEMPLATE,
                              read_prod_req_list, productionDemandCounters);
      IniAppGlobals.Time_For_Prodreq := IniAppGlobals.Time_For_Prodreq + (Now - CurrentTime_Prodreq);


      LastStepMQMProductionColumnValues := m_ProdCont.m_Req_Change_List.Items[ m_ProdCont.m_Req_Change_List.Count - 1 ];

      CurrentTime_Hdr := NOW;
      insertIntoPROD_REQHDR_List(additionalDataList, MQMProductionColumnValues,
                                 CUR_PRODUCTIONDEMANDTEMPLATE, read_prod_reqhdr_list,
                                 uniqueWorkCenterProcesses, itemTypeTemplates,
                                 productionDemandCounters, ContainProductionOrderCode, Items, LastStepMQMProductionColumnValues);
      IniAppGlobals.Time_For_Hgr := IniAppGlobals.Time_For_Hgr + (Now - CurrentTime_Hdr);

//      if m_ProdCont.m_Req_Change_List.Count = 1 then
//      begin
     { MatchReservation := true;
      if (getValueOfTheProductionColumn(MQMProductionColumnValues, 'PRSV_PROJECTCODE', PRSV_PROJECTCODE) = '') then
        MatchReservation := false;
      if FoundServedCode then
        MatchReservation := false;
      if trim(CUR_PRODUCTIONDEMANDTEMPLATE.ITEMTYPESERVED) = '' then
      begin
        if Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PRSV_REFERENCEITEM', PRSV_REFERENCEITEM)) <> '1' then
          MatchReservation := false;
      end
      else
      begin
        if trim(CUR_PRODUCTIONDEMANDTEMPLATE.ITEMTYPESERVED) <>
            trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PRSV_ITEMTYPEAFICODE', PRSV_ITEMTYPEAFICODE)) then
          MatchReservation := false;
      end;
      if MatchReservation then
      begin
        if CUR_PRODUCTIONDEMANDTEMPLATE.SERVEDCODEDEFNITION = '1' then
          ServedCode := getValueOfTheProductionColumn(MQMProductionColumnValues, 'RSV_FIKD_IDENTIFIER', RSV_FIKD_IDENTIFIER) +
                        GetNumberByProject(ProjectNumberList, trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PRSV_PROJECTCODE', PRSV_PROJECTCODE)));
        if CUR_PRODUCTIONDEMANDTEMPLATE.SERVEDCODEDEFNITION = '2' then
        begin
          ServedCode := trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PRSV_ITEMTYPEAFICODE', PRSV_ITEMTYPEAFICODE)  +
                        GetNumberByProject(ProjectNumberList, trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PRSV_PROJECTCODE', PRSV_PROJECTCODE))));
        end;
        FoundServedCode := true;
        PTMQMPH(read_prod_reqhdr_list[read_prod_reqhdr_list.Count -1]).PH_SERVED_CODE := ServedCode;
      end;  }
//      end;

      CurrentTime_article := Now;

      prepareValuesToInsertPRODUCED_ARTICLE(srvQryFD, MQMProductionColumnValues,
                                            articleTypeList, additionalDataList, UserGenericGroupTypeList, UserGenericGroupTypeAttributesList,
                                            productsList, read_produced_article_list,
                                            currentProductsList,
                                            logicalWarehouseList,
                                            CUR_PRODUCTIONDEMANDTEMPLATE,
                                            Items,
                                            productionDemandCounters,
                                            itemTypeLogicalWarehouseList);
      IniAppGlobals.Time_For_Article := IniAppGlobals.Time_For_Article + (Now - CurrentTime_article);


      CurrentTime_Material := Now;
      prepareValuesToInsertMATERIAL(srvQryFD, productionReservationList,
                                    stepNumbersOfHandledWorkCenters, stepNumbersOfHandledNameOfWorkCenters,
                                    MQMProductionColumnValues, articleTypeList,
                                    additionalDataList, UserGenericGroupTypeList, UserGenericGroupTypeAttributesList,
                                    productsList, read_material_list,
                                    currentProductsList,
                                    logicalWarehouseList,
                                    CUR_PRODUCTIONDEMANDTEMPLATE,
                                    alternativeWarehouseList,
                                    List_Items,
                                    productionDemandCounters,
                                    itemTypeLogicalWarehouseList,PRODUCT_CODE);
      IniAppGlobals.Time_For_Material := IniAppGlobals.Time_For_Material + (Now - CurrentTime_Material);

      if (PRODUCT_CODE <> '') then
         PTMQMPH(read_prod_reqhdr_list[read_prod_reqhdr_list.Count -1]).PH_MATERIAL_FAMILY := PRODUCT_CODE;

      CurrentTime_Reqconn := Now;
      insertIntoPROD_REQCONN_List_From_Demand(MQMProductionColumnValues, read_prod_reqConn_list,
                                              alreadyAddedPROD_REQCONN, additionalDataWithRelationList, Items,
                                              productionDemandCounters,
                                              additionalDataList);
      IniAppGlobals.Time_For_Reqconn := IniAppGlobals.Time_For_Reqconn + (Now - CurrentTime_Reqconn);

    end
    else
    begin
      ifNeededUpdatePROD_REQHDR_List(additionalDataList, MQMProductionColumnValues,
                                     CUR_PRODUCTIONDEMANDTEMPLATE, read_prod_reqhdr_list,
                                     uniqueWorkCenterProcesses, itemTypeTemplates,
                                     productionDemandCounters, LastStepMQMProductionColumnValues);

     { if CUR_PRODUCTIONDEMANDTEMPLATE.SERVEDCODEDEFNITION = '1' then
      begin
        if (trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PRSV_PROJECTCODE', PRSV_PROJECTCODE)) <> '') and
           (not FoundServedCode) and (trim(CUR_PRODUCTIONDEMANDTEMPLATE.ITEMTYPESERVED) = trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PRSV_ITEMTYPEAFICODE', PRSV_ITEMTYPEAFICODE))) then
        begin
          ServedCode := getValueOfTheProductionColumn(MQMProductionColumnValues, 'RSV_FIKD_ABSUNIQUEID', RSV_FIKD_ABSUNIQUEID) +
                        GetNumberByProject(ProjectNumberList, trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PRSV_PROJECTCODE', PRSV_PROJECTCODE)));
          FoundServedCode := true;
          PTMQMPH(read_prod_reqhdr_list[read_prod_reqhdr_list.Count -1]).PH_SERVED_CODE := ServedCode;
        end;
      end

      else if CUR_PRODUCTIONDEMANDTEMPLATE.SERVEDCODEDEFNITION = '2' then
      begin
        if (trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PRSV_PROJECTCODE', PRSV_PROJECTCODE)) <> '') and
           not FoundServedCode then
        begin
          ServedCode := CUR_PRODUCTIONDEMANDTEMPLATE.ITEMTYPESERVED  +
                        GetNumberByProject(ProjectNumberList, trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PRSV_PROJECTCODE', PRSV_PROJECTCODE)));
          FoundServedCode := true;
          PTMQMPH(read_prod_reqhdr_list[read_prod_reqhdr_list.Count -1]).PH_SERVED_CODE := ServedCode;
        end;
      end   }

    end;

    isWorkCenterHandled := '0';
    isWorkCenterHandledByMqm := '0';
    isWorkCenterHandledByMcm := '0';

    CUR_WORKCENTER := StepWorkCenter[i];
    if CUR_WORKCENTER <> nil then
    begin
      isWorkCenterHandledByMqm := CUR_WORKCENTER.WC_HANDLEDBYMQM;
      isWorkCenterHandledByMcm := CUR_WORKCENTER.WC_HANDLEDBYMCM;
      isWorkCenterHandled      := '1';
    end;

{    if ( searchInList(handledWorkCentersList, 1, searchValue,
                     0, handledWorkCentersList.Count - 1) <> - 1 ) then
      isWorkCenterHandled := '1'
    else
      isWorkCenterHandled := '0';   }

    previousStepHandledByMqm := '0';
    nextStepHandledByMqm := '0';

    if (stepsHandledByMqm.Count > 1) and stepsHandledByMqmDict.ContainsKey(IntToStr(I)) then

    for j := 0 to stepsHandledByMqm.Count - 1 do
    begin
      if PrevNextMqmDict.ContainsKey(stepsHandledByMqm.Strings[j]) then
          continue;

      if (J > 0) then
      begin
        MQMProductionColumnValues_Test := m_ProdCont.m_Req_Change_List.Items[StrToInt(stepsHandledByMqm.Strings[j-1])];
        previousStepHandledByMqm := getValueOfTheProductionColumn(MQMProductionColumnValues_Test, 'PDS_STEPNUMBER', PDS_STEPNUMBER);
      end;

      if (J + 1 < stepsHandledByMqm.Count) then
      begin
        MQMProductionColumnValues_Test := m_ProdCont.m_Req_Change_List.Items[StrToInt(stepsHandledByMqm.Strings[j +1])];
        nextStepHandledByMqm := getValueOfTheProductionColumn(MQMProductionColumnValues_Test, 'PDS_STEPNUMBER', PDS_STEPNUMBER);
      end;
      PrevNextToBeSchedListMqm.Add(stepsHandledByMqm.Strings[j]);
      PrevNextMqmDict.AddOrSetValue(stepsHandledByMqm.Strings[j], true);
      break;
    end;

    previousStepHandledByMcm := '0';
    nextStepHandledByMcm := '0';

    if (stepsHandledByMcm.Count > 1) and stepsHandledByMcmDict.ContainsKey(IntToStr(I)) then

    for j := 0 to stepsHandledByMcm.Count - 1 do
    begin
      if PrevNextMcmDict.ContainsKey(stepsHandledByMcm.Strings[j]) then
          continue;

      if (J > 0) then
      begin
        MQMProductionColumnValues_Test := m_ProdCont.m_Req_Change_List.Items[StrToInt(stepsHandledByMcm.Strings[j-1])];
        previousStepHandledByMcm := getValueOfTheProductionColumn(MQMProductionColumnValues_Test, 'PDS_STEPNUMBER', PDS_STEPNUMBER);
      end;

      if (J + 1 < stepsHandledByMcm.Count) then
      begin
        MQMProductionColumnValues_Test := m_ProdCont.m_Req_Change_List.Items[StrToInt(stepsHandledByMcm.Strings[j +1])];
        nextStepHandledByMcm := getValueOfTheProductionColumn(MQMProductionColumnValues_Test, 'PDS_STEPNUMBER', PDS_STEPNUMBER);
      end;
      PrevNextToBeSchedListMcm.Add(stepsHandledByMcm.Strings[j]);
      PrevNextMcmDict.AddOrSetValue(stepsHandledByMcm.Strings[j], true);
      break;
    end;

    previousStepInDemand := '0';
    nextStepInDemand := '0';
    if ( i <> 0) then
    begin
      MQMProductionColumnValues_Test := m_ProdCont.m_Req_Change_List.Items[i - 1];
      previousStepInDemand := getValueOfTheProductionColumn(MQMProductionColumnValues_Test, 'PDS_STEPNUMBER', PDS_STEPNUMBER);
    end;

    if ( i <> m_ProdCont.m_Req_Change_List.Count - 1) then
    begin
      MQMProductionColumnValues_Test := m_ProdCont.m_Req_Change_List.Items[i + 1];
      nextStepInDemand := getValueOfTheProductionColumn(MQMProductionColumnValues_Test, 'PDS_STEPNUMBER', PDS_STEPNUMBER);
    end;

    timeTypeCode := getTimeTypeCode(MQMProductionColumnValues, routingStepTimeTypeList, handledWorkCentersList);
    CurrentTime_StepTimes := NOW;
    timeValue := insertIntoPROD_STEP_TIMES_List(MQMProductionColumnValues,
                                                timeTypeCode,
                                                UserGenericGroupTypeList, UserGenericGroupTypeAttributesList,
                                                routingStepTimeTypeList,
                                                CUR_WORKCENTER,
                                                handledWorkCentersList,
                                                operationList,
                                                propertyList,
                                                ColorTypeList,
                                                ColorTypeUNIQUEIDList,
                                            //    productPrimaryUomConversionDataList,
                                            //    secondaryUnitCategoryConversionList,
                                            //    stdUnitCategoryConversionList,
                                                productionDemandCounters,
                                                additionalDataList,
                                                read_prod_step_time_list,
                                                Items,
                                                CUR_PRODUCTIONDEMANDTEMPLATE);
    IniAppGlobals.Time_For_StepTimes := IniAppGlobals.Time_For_StepTimes + (Now - CurrentTime_StepTimes);


    if stepsHandledByMcmDict.ContainsKey(IntToStr(i)) then
    begin
      mcmLeadQueueTimePrevStep := sumValue;
      sumValue := 0;
    end
    else
    begin
      mcmLeadQueueTimePrevStep := 0;
      sumValue := sumValue + timeValue;
    end;
    CurrentTime_Time_For_steps := NOW;
    insertIntoPROD_STEP_List(MQMProductionColumnValues, CUR_WORKCENTER,
                        previousStepHandledByMcm, nextStepHandledByMcm,
                        previousStepHandledByMqm, previousStepInDemand,
                        nextStepHandledByMqm, nextStepInDemand, timeTypeCode,
                        read_prod_step_list, handledWorkCentersList, unhandledWorkCentersList,
                        CUR_PRODUCTIONDEMANDTEMPLATE,
                        Items,
                        additionalDataList, standardWeightUnit, itemTypeTemplates, PTNA_REC, productionDemandCounters);
                      //  productPrimaryUomConversionDataList,
                      //  secondaryUnitCategoryConversionList,
                      //  stdUnitCategoryConversionList);
    IniAppGlobals.Time_For_steps := IniAppGlobals.Time_For_steps + (Now - CurrentTime_Time_For_steps);

    if isWorkCenterHandled = '1' then
    begin
      CurrentTime_Time_For_properties := NOW;
      ifNeededInsertIntoPROP_PROD_List(MQMProductionColumnValues, propertyList,
                                     resList, additionalDataList, UserGenericGroupTypeList, UserGenericGroupTypeAttributesList,
                                     ColorTypeList, ColorTypeUNIQUEIDList,
                                     handledWorkCentersList, read_prop_prod_list,
                                     CUR_PRODUCTIONDEMANDTEMPLATE, Items, Steps, Recipes, Designs,
                                     GenericOrder, GenericLine, GenericDelivery, GenericProject, GenericBusinessPartner,
                                     HeaderPropList, productionDemandCounters, ServingCode, CurveFamily_IdCode, CurveFamily_IdCode_BuildFromProp,
                                     isWorkCenterHandledByMqm, isWorkCenterHandledByMcm);

      IniAppGlobals.Time_For_properties := IniAppGlobals.Time_For_properties + (Now - CurrentTime_Time_For_properties);


      if not FoundCurveFamily_IdCode and (CurveFamily_IdCode <> '') then
      begin
        FoundCurveFamily_IdCode := true;
        Found_CurveFamily_IdCode := CurveFamily_IdCode;
      end;

      if not FoundCurveFamily_IdCode_BuildFromProp and CurveFamily_IdCode_BuildFromProp then
      begin
        CurveFamily_IdCode_BuildFromProp := false;
        FoundCurveFamily_IdCode_BuildFromProp := true;
      end;

      if (ServingCode <> '') and (CUR_PRODUCTIONDEMANDTEMPLATE.SERVINGCODEDEFNITION = '0') and UpdatePropertyLinker then
      begin
       // ServingCode := '';
        var T_UPLSG := NOW;
        UpdatePropertyLinkerToServingGroup(propertyList, read_prop_prod_list, read_prod_reqhdr_list, ServingCode);
        IniAppGlobals.Time_For_UpdatePropertyLinkerToServingGroup := IniAppGlobals.Time_For_UpdatePropertyLinkerToServingGroup + (NOW - T_UPLSG);
        UpdatePropertyLinker := false;
      end;
    end;

    CurrentTime_Time_For_BatchSize := NOW;
    insertIntoPROD_STEP_BATCH_SIZE_List(MQMProductionColumnValues,
                                        handledWorkCentersList,
                                        resList,
                                        getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_WORKCENTERCODE', PDS_WORKCENTERCODE),
                                        read_prod_step_batch_size_list,
                                        Items,
                                        productionDemandCounters,
                                        CUR_PRODUCTIONDEMANDTEMPLATE);
    IniAppGlobals.Time_For_Batch_Size := IniAppGlobals.Time_For_Batch_Size + (Now - CurrentTime_Time_For_BatchSize);

  end;


  if Found_CurveFamily_IdCode <> '' then
     PTMQMPH(read_prod_reqhdr_list[read_prod_reqhdr_list.Count -1]).PH_Curve_Family_Id_Code := Found_CurveFamily_IdCode
  else if FoundCurveFamily_IdCode_BuildFromProp then
  begin
    var T_UPCF := NOW;
    UpdatePropertyLinker_CurveFamily_IdCode_BuildFromProp(propertyList, read_prop_prod_list, read_prod_reqhdr_list);
    IniAppGlobals.Time_For_UpdatePropertyLinker_CurveFamily := IniAppGlobals.Time_For_UpdatePropertyLinker_CurveFamily + (NOW - T_UPCF);
  end;

  stepsHandledByMqm.Free;
  stepsHandledByMcm.Free;
  stepsHandledByMqmDict.Free;
  stepsHandledByMcmDict.Free;
  stepNumbersOfHandledWorkCenters.Free;
  stepNumbersOfHandledNameOfWorkCenters.Free;
  uniqueWorkCenterProcesses.Free;
  nonUniqueWorkCenterProcesses.Free;
  for TempIndex := 0 to HeaderPropList.Count - 1 do
    Dispose(PReqTempProp(HeaderPropList[TempIndex]));
  HeaderPropList.Free;
  PrevNextToBeSchedListMqm.Free;
  PrevNextToBeSchedListMcm.Free;
  PrevNextMqmDict.Free;
  PrevNextMcmDict.Free;
end;

//----------------------------------------------------------------------------//

function CheckMerge(Var ProdReqStr : string ; CounterCode : string; productionDemandCounters : TList) : boolean;
var
  endPosition : Integer;
begin
  Result := false;
  endPosition := getEndPosition(productionDemandCounters,
                                         CounterCode);
  if endPosition <> 0 then
  begin
    ProdReqStr := copy(trim(ProdReqStr), 1, endPosition);
    Result := true
  end;
end;

//----------------------------------------------------------------------------//

procedure insertIntoPROD_REQ_List(MQMProductionColumnValues: PMQMProductionColumnValues;
                                  CUR_PRODUCTIONDEMANDTEMPLATE: PPRODUCTIONDEMANDTEMPLATES;
                                  read_prod_req_list: TList; productionDemandCounters: TList);
var
  NEW_PROD_REQ: PTMQMPR;
  PREQ_NO : string;
begin
  New(NEW_PROD_REQ);
  NEW_PROD_REQ.PR_DIV_CODE := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_DIVISIONCODE', PD_DIVISIONCODE);
  NEW_PROD_REQ.PR_DSP_CODE := '';
  NEW_PROD_REQ.PR_BCH_CODE := '';
  NEW_PROD_REQ.PR_REPROC_NO := 0;
  NEW_PROD_REQ.PR_FAMILYCODE := '';
  NEW_PROD_REQ.PR_PREQ_NO := setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COMPANYCODE', PD_COMPANYCODE), 3) +
                             setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COUNTERCODE', PD_COUNTERCODE), 8) +
                             getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_CODE', PD_CODE);
  NEW_PROD_REQ.PR_HISTORICAL_REQ := '0';
  NEW_PROD_REQ.PR_USR_CG := 'USERNAME';
  NEW_PROD_REQ.PR_USR_TM_CG := Now;
  NEW_PROD_REQ.PR_ModulHandled := '';
//  NEW_PROD_REQ.PR_MQM_HISTORIC_DATE := 0;
//  NEW_PROD_REQ.PR_TEMPLATECODE := CUR_PRODUCTIONDEMANDTEMPLATE.CODE;

  //added by Erbil on 20/03/2009
//  NEW_PROD_REQ.ITEMTYPECODE := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ITEMTYPEAFICODE');
//  NEW_PROD_REQ.PRODUCTIONDEMANDCOUNTERCODE := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COUNTERCODE');

  PREQ_NO := NEW_PROD_REQ.PR_PREQ_NO;
  if CheckMerge(PREQ_NO, setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COUNTERCODE', PD_COUNTERCODE), 8), productionDemandCounters) then
  begin
    NEW_PROD_REQ.PR_FAMILYCODE := PREQ_NO;
    m_NeedToMakeMerge := true
  end;

  read_prod_req_list.Add(NEW_PROD_REQ);

end;

//----------------------------------------------------------------------------//

procedure insertIntoPROD_REQHDR_List(additionalDataList: TList;
                                MQMProductionColumnValues: PMQMProductionColumnValues;
                                CUR_PRODUCTIONDEMANDTEMPLATE: PPRODUCTIONDEMANDTEMPLATES;
                                read_prod_reqhdr_list: TList;
                                uniqueWorkCenterProcesses: TStringlist;
                                itemTypeTemplates: TList;
                                productionDemandCounters: TList;
                                ContainProductionOrderCode : boolean;
                                Items : PTItems;
                                LastStepMQMProductionColumnValues: PMQMProductionColumnValues);
var
  NEW_PROD_REQHDR: PTMQMPH;

  searchCapacityFlag: String;
  searchMaterialFlag: String;
  loadPriorityValue: String;
  newDemandUniqueId: string;

  requestDate: TDate;
  autoLoaderDays: String;
  moduleHandle: String;
  ServedCode, ServingCode, PREQ_NO : string;

  CUR_ITEMTYPEPRODUCTIONDEMANDTEMPLATE: PITEMTYPEPRODUCTIONDEMANDTEMPLATES;
  CUR_PRODUCTIONDEMANDCOUNTER: PPRODUCTIONDEMANDCOUNTERS;
  P_ABSUNIQUEID, FIKD_ABSUNIQUEIDStr : string;
  SUBCODE01, SUBCODE02, SUBCODE03, SUBCODE04, SUBCODE05,
  SUBCODE06, SUBCODE07, SUBCODE08, SUBCODE09, SUBCODE10 : string;
begin

  if assigned(Items) then
  begin
    FIKD_ABSUNIQUEIDStr := Items.ABSUNIQUEID;
    P_ABSUNIQUEID    := Items.ABSUNIQUEID_P;
    SUBCODE01 := Items.SUBCODE01;
    SUBCODE02 := Items.SUBCODE02;
    SUBCODE03 := Items.SUBCODE03;
    SUBCODE04 := Items.SUBCODE04;
    SUBCODE05 := Items.SUBCODE05;
    SUBCODE06 := Items.SUBCODE06;
    SUBCODE07 := Items.SUBCODE07;
    SUBCODE08 := Items.SUBCODE08;
    SUBCODE09 := Items.SUBCODE09;
    SUBCODE10 := Items.SUBCODE10;
  end;

 { if CheckColumnExistsInTable(ArcQry, 'PRODUCTIONDEMAND', 'INITIALPLANNEDSCHEDULEDDATE') then
    PD_INITIALPLANNEDSCHEDULEDDATE := addToSelectedColumns('PD', '', 'INITIALPLANNEDSCHEDULEDDATE', firstSentenceColumnNames, productionColumnNames);
  if CheckColumnExistsInTable(ArcQry, 'PRODUCTIONDEMAND', 'FINALPLANNEDSCHEDULEDDATE') then
    PD_FINALPLANNEDSCHEDULEDDATE := addToSelectedColumns('PD', '', 'FINALPLANNEDSCHEDULEDDATE', firstSentenceColumnNames, productionColumnNames);
            }

{  searchCapacityFlag := getAdditionalDataValue(CUR_PRODUCTIONDEMANDTEMPLATE.SEARCHCAPACITY,
                                               CUR_PRODUCTIONDEMANDTEMPLATE.CAPADDDATATABLENAME,
                                               CUR_PRODUCTIONDEMANDTEMPLATE.CAPADDDATACOLUMNNAME,
                                               additionalDataList,
                                               P_ABSUNIQUEID,
                                               FIKD_ABSUNIQUEID,
                                               //getValueOfTheProductionColumn(MQMProductionColumnValues, 'P_ABSUNIQUEID'),
                                               //getValueOfTheProductionColumn(MQMProductionColumnValues, 'FIKD_ABSUNIQUEID'),
                                               getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ABSUNIQUEID'),
                                               getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_ABSUNIQUEID'));  }

{  searchMaterialFlag := getAdditionalDataValue(CUR_PRODUCTIONDEMANDTEMPLATE.SEARCHMATERIAL,
                                               CUR_PRODUCTIONDEMANDTEMPLATE.MATADDDATATABLENAME,
                                               CUR_PRODUCTIONDEMANDTEMPLATE.MATADDDATACOLUMNNAME,
                                               additionalDataList,
                                               P_ABSUNIQUEID,
                                               FIKD_ABSUNIQUEID,
                                               //getValueOfTheProductionColumn(MQMProductionColumnValues, 'P_ABSUNIQUEID'),
                                               //getValueOfTheProductionColumn(MQMProductionColumnValues, 'FIKD_ABSUNIQUEID'),
                                               getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ABSUNIQUEID'),
                                               getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_ABSUNIQUEID'));   }

{  if CUR_PRODUCTIONDEMANDTEMPLATE.REQUESTDATETYPE = '1' then
    requestDate := StrToDate(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_FINALPLANNEDDATE'))
  else if CUR_PRODUCTIONDEMANDTEMPLATE.REQUESTDATETYPE = '2' then
    requestDate := StrToDate(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_INITIALPLANNEDDATE'))
  else
    requestDate := date;//Now();    }

//  CUR_PRODUCTIONDEMANDTEMPLATE.PRIADDDATATABLENAME := 'ProductionDemand AD';
//  CUR_PRODUCTIONDEMANDTEMPLATE.PRIADDDATACOLUMNNAME := 'PriorityMcm'; /// avi to be check

{  loadPriorityValue := getAdditionalDataValue(CUR_PRODUCTIONDEMANDTEMPLATE.LOADPRIORITY,
                                              CUR_PRODUCTIONDEMANDTEMPLATE.PRIADDDATATABLENAME,  // avi // ProductionDemand AD ,
                                              CUR_PRODUCTIONDEMANDTEMPLATE.PRIADDDATACOLUMNNAME,  // NewDemandUniqueId
                                              additionalDataList,
                                              P_ABSUNIQUEID,
                                              FIKD_ABSUNIQUEID,
                                              //getValueOfTheProductionColumn(MQMProductionColumnValues, 'P_ABSUNIQUEID'),
                                              //getValueOfTheProductionColumn(MQMProductionColumnValues, 'FIKD_ABSUNIQUEID'),
                                              getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ABSUNIQUEID'),
                                              getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_ABSUNIQUEID'));
  loadPriorityValue := getNumericValueOf(loadPriorityValue);     }


//  CUR_PRODUCTIONDEMANDTEMPLATE.PRIADDDATATABLENAME := 'ProductionDemand AD';
//  CUR_PRODUCTIONDEMANDTEMPLATE.PRIADDDATACOLUMNNAME := 'NewDemandUniqueId';

  if m_Exist_MQMSPLITREFERENCE then
    newDemandUniqueId := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_MQMSPLITREFERENCE', PD_MQMSPLITREFERENCE)
  else
    newDemandUniqueId := getAdditionalDataValue('',
                                              'ProductionDemand AD',  // avi // ProductionDemand AD ,
                                              'NewDemandUniqueId',  // NewDemandUniqueId
                                              additionalDataList,
                                              P_ABSUNIQUEID,
                                              FIKD_ABSUNIQUEIDStr,
                                              //getValueOfTheProductionColumn(MQMProductionColumnValues, 'P_ABSUNIQUEID'),
                                              //getValueOfTheProductionColumn(MQMProductionColumnValues, 'FIKD_ABSUNIQUEID'),
                                              getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ABSUNIQUEID', PD_ABSUNIQUEID),
                                              getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_ABSUNIQUEID', PDS_ABSUNIQUEID));

  ////////////////

  if CUR_PRODUCTIONDEMANDTEMPLATE.SERVINGCODEDEFNITION = '0' then
  begin
    if (CUR_PRODUCTIONDEMANDTEMPLATE.SERVINGCODETABLENAME <> '') and (CUR_PRODUCTIONDEMANDTEMPLATE.SERVINGCODECOLUMNAME <> '') then
    begin
      ServingCode := getAdditionalDataValue('',
                                               CUR_PRODUCTIONDEMANDTEMPLATE.SERVINGCODETABLENAME,
                                               CUR_PRODUCTIONDEMANDTEMPLATE.SERVINGCODECOLUMNAME,
                                               additionalDataList,
                                               P_ABSUNIQUEID,
                                               FIKD_ABSUNIQUEIDStr,
                     //                          getValueOfTheProductionColumn(MQMProductionColumnValues, 'P_ABSUNIQUEID'),
                     //                          getValueOfTheProductionColumn(MQMProductionColumnValues, 'FIKD_ABSUNIQUEID'),
                                               getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ABSUNIQUEID', PD_ABSUNIQUEID),
                                               getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_ABSUNIQUEID', PDS_ABSUNIQUEID));
    end;
  end
  else if CUR_PRODUCTIONDEMANDTEMPLATE.SERVINGCODEDEFNITION = '1' then
  begin
    if (trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_PROJECTCODE', PD_PROJECTCODE)) <> '') then
        ServingCode := getValueOfTheProductionColumn(MQMProductionColumnValues, 'FIKD_IDENTIFIER', FIKD_IDENTIFIER) +
                 GetNumberByProject(ProjectNumberList, trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_PROJECTCODE', PD_PROJECTCODE)));
  end
  else if CUR_PRODUCTIONDEMANDTEMPLATE.SERVINGCODEDEFNITION = '2' then
  begin
    if (trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_PROJECTCODE', PD_PROJECTCODE)) <> '') then
        ServingCode := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ITEMTYPEAFICODE', PD_ITEMTYPEAFICODE) +
                 GetNumberByProject(ProjectNumberList, trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_PROJECTCODE', PD_PROJECTCODE)));

  end;

  if (CUR_PRODUCTIONDEMANDTEMPLATE.SERVEDCODEDEFNITION = '0') then
  begin
    ServedCode := getAdditionalDataValue('',
                                               CUR_PRODUCTIONDEMANDTEMPLATE.SERVEDCODETABLENAME,
                                               CUR_PRODUCTIONDEMANDTEMPLATE.SERVEDCODECOLUMNAME,
                                               additionalDataList,
                                               P_ABSUNIQUEID,
                                               FIKD_ABSUNIQUEIDStr,
            //                                   getValueOfTheProductionColumn(MQMProductionColumnValues, 'P_ABSUNIQUEID'),
            //                                   getValueOfTheProductionColumn(MQMProductionColumnValues, 'FIKD_ABSUNIQUEID'),
                                               getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ABSUNIQUEID', PD_ABSUNIQUEID),
                                               getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_ABSUNIQUEID', PDS_ABSUNIQUEID));
  end;

//  autoLoaderDays := getNumericValueOf(CUR_PRODUCTIONDEMANDTEMPLATE.AUTOLOADERDAYS);


  moduleHandle := '';
  if ( (CUR_PRODUCTIONDEMANDTEMPLATE.HANDLEDBYMQM = '1') OR
       (CUR_PRODUCTIONDEMANDTEMPLATE.HANDLEDBYMQM = '2') ) then
  begin
    moduleHandle := '0';

    if (CUR_PRODUCTIONDEMANDTEMPLATE.HANDLEDBYMCM = '1') then
      moduleHandle := '2';
  end
  else
  begin
    if (CUR_PRODUCTIONDEMANDTEMPLATE.HANDLEDBYMCM = '1') then
      moduleHandle := '1';
  end;

  New(NEW_PROD_REQHDR);
  NEW_PROD_REQHDR.PH_PREQ_NO := setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COMPANYCODE', PD_COMPANYCODE), 3) +
                                setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COUNTERCODE', PD_COUNTERCODE), 8) +
                                getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_CODE', PD_CODE);

  NEW_PROD_REQHDR.PH_HISTORICAL_REQ := '0';
  NEW_PROD_REQHDR.PH_REQ_ORIGIN := '';
  NEW_PROD_REQHDR.PH_PROD_LINE := '';

//  Index := -1;
//  index := searchInList(List_ProductNeededFordemand, 44, getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ABSUNIQUEID'), 0, List_ProductNeededForDemand.Count - 1);
//  if index <> -1 then
//     PD_SUBCODE01 := PTProductNeededFordemand(List_ProductNeededFordemand[Index]).SUBCODE01;
      // need to search in the list ProductNeededFordemand


  NEW_PROD_REQHDR.PH_TYPE_PROD := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ITEMTYPEAFICODE', PD_ITEMTYPEAFICODE);

  NEW_PROD_REQHDR.PH_ModulHandled := '0';

 { if CUR_PRODUCTIONDEMANDTEMPLATE.HANDLEDBYMCM = '1' then
  begin
    if CUR_PRODUCTIONDEMANDTEMPLATE.HANDLEDBYMQM = '0' then
      NEW_PROD_REQHDR.PH_ModulHandled := '1';
    if CUR_PRODUCTIONDEMANDTEMPLATE.HANDLEDBYMQM = '1' then
      NEW_PROD_REQHDR.PH_ModulHandled := '2';
    if (CUR_PRODUCTIONDEMANDTEMPLATE.HANDLEDBYMQM = '2') and ContainProductionOrderCode then
     NEW_PROD_REQHDR.PH_ModulHandled := '2';
  end; }

  NEW_PROD_REQHDR.PH_PROD_FAMILY := getFullItemKeyCode(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ITEMTYPEAFICODE', PD_ITEMTYPEAFICODE),
                                    SUBCODE01, SUBCODE02, SUBCODE03, SUBCODE04, SUBCODE05,
                                    SUBCODE06, SUBCODE07, SUBCODE08, SUBCODE09, SUBCODE10
                                            //getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE01'),
                                            //getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE02'),
                                            //getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE03'),
                                            //getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE04'),
                                            //getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE05'),
                                            //getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE06'),
                                            //getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE07'),
                                            //getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE08'),
                                            //getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE09'),
                                            //getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE10')
                                            );
  NEW_PROD_REQHDR.PH_MATERIAL_FAMILY := '';
  NEW_PROD_REQHDR.PH_PROD_UM := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_BASEPRIMARYUOMCODE', PD_BASEPRIMARYUOMCODE);
  NEW_PROD_REQHDR.PH_PROD_LOW_TIME_STRT := StrToDateTime( getFormattedDateFromString(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_MINBEGINQUEUE', PDS_MINBEGINQUEUE)) );

  try
    if m_Exist_INITIALPLANNEDSCHEDULEDDATE then
    begin
     if getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_INITIALPLANNEDSCHEDULEDDATE', PD_INITIALPLANNEDSCHEDULEDDATE) > IntToStr(0) then
       NEW_PROD_REQHDR.PH_PROD_LOW_TIME_STRT := StrToDateTime(getFormattedDateFromString(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_INITIALPLANNEDSCHEDULEDDATE', PD_INITIALPLANNEDSCHEDULEDDATE)) );
    end;
  except
  end;

  // changed by Erbil 10/03/2009
  NEW_PROD_REQHDR.PH_PROD_DELIVY_DATE := StrToDate( getFormattedDateFromString(getValueOfTheProductionColumn(LastStepMQMProductionColumnValues, 'PDS_MAXENDSTEP', PDS_MAXENDSTEP)) );
  NEW_PROD_REQHDR.PH_PROD_DELIVY_DATE := NEW_PROD_REQHDR.PH_PROD_DELIVY_DATE + EncodeTime(23,59,59,0);
  try
    if m_Exist_FINALPLANNEDSCHEDULEDDATE then
      if getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_FINALPLANNEDSCHEDULEDDATE', PD_FINALPLANNEDSCHEDULEDDATE) > IntToStr(0) then
      begin
        NEW_PROD_REQHDR.PH_PROD_DELIVY_DATE := StrToDate(getFormattedDateFromString(getValueOfTheProductionColumn(LastStepMQMProductionColumnValues, 'PD_FINALPLANNEDSCHEDULEDDATE', PD_FINALPLANNEDSCHEDULEDDATE)) );
        NEW_PROD_REQHDR.PH_PROD_DELIVY_DATE := NEW_PROD_REQHDR.PH_PROD_DELIVY_DATE + EncodeTime(23,59,59,0);
      end;
  except
  end;

  NEW_PROD_REQHDR.PH_FRC_DEL_DATE := '0';
  NEW_PROD_REQHDR.PH_USR_CG := 'USERNAME';
  NEW_PROD_REQHDR.PH_USR_TM_CG := Now;
//  NEW_PROD_REQHDR.PH_MCM_REQUESTTYPE := CUR_PRODUCTIONDEMANDTEMPLATE.REQUESTDATETYPE;
//  NEW_PROD_REQHDR.PH_MCM_CAPACITYSEARCH := searchCapacityFlag;
//  NEW_PROD_REQHDR.PH_MCM_MATERIALSEARCH := searchMaterialFlag;
//  NEW_PROD_REQHDR.PH_MCM_REQUESTEDDATE := requestDate;
//  NEW_PROD_REQHDR.PH_MCM_REQUESTEDDATETYPE := CUR_PRODUCTIONDEMANDTEMPLATE.REQUESTDATETYPE;

//  NEW_PROD_REQHDR.PH_MCM_PRIORITY := StrToInt(loadPriorityValue);
//  NEW_PROD_REQHDR.PH_MCM_LOADERDAYS := StrToInt(autoLoaderDays);

  NEW_PROD_REQHDR.PH_MQM_SPLIT_ID := newDemandUniqueId;
  NEW_PROD_REQHDR.PH_SERVED_CODE := ServedCode;
  NEW_PROD_REQHDR.PH_SERVING_CODE := ServingCode;

//  NEW_PROD_REQHDR.PH_MODULEHANDLE := moduleHandle;

  NEW_PROD_REQHDR.PH_SPLITCONFLEVELS := '';
  NEW_PROD_REQHDR.PH_LEAD_STEP_SPLITED := 0;

  CUR_ITEMTYPEPRODUCTIONDEMANDTEMPLATE := nil;

  if (uniqueWorkCenterProcesses.IndexOf(Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_WORKCENTERCODE', PDS_WORKCENTERCODE)) + ' ' +
                                        Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_OPERATIONCODE', PDS_OPERATIONCODE))
                                       ) <> -1 ) then
  begin
    CUR_ITEMTYPEPRODUCTIONDEMANDTEMPLATE := setItemTypeTemplate(itemTypeTemplates,
                        getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ITEMTYPEAFICODE', PD_ITEMTYPEAFICODE),
                        CUR_PRODUCTIONDEMANDTEMPLATE.CODE,
                        Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_WORKCENTERCODE', PDS_WORKCENTERCODE)),
                        Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_OPERATIONCODE', PDS_OPERATIONCODE)));

    if (CUR_ITEMTYPEPRODUCTIONDEMANDTEMPLATE <> nil) then
    begin
      NEW_PROD_REQHDR.PH_SPLITCONFLEVELS := CUR_ITEMTYPEPRODUCTIONDEMANDTEMPLATE.HOSTSPLITCONFIRMLEVEL;
      NEW_PROD_REQHDR.PH_LEAD_STEP_SPLITED := StrToInt(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_STEPNUMBER', PDS_STEPNUMBER));
      CUR_PRODUCTIONDEMANDCOUNTER := nil;
      CUR_PRODUCTIONDEMANDCOUNTER := setProductionDemandCounter(productionDemandCounters,
                                 Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COUNTERCODE', PD_COUNTERCODE)));
    end;
    {
    else
    begin
      NEW_PROD_REQHDR.PH_SPLITCONFLEVELS := '';
      NEW_PROD_REQHDR.PH_LEAD_STEP_SPLITED := '0';
    end;
    }
  end;

  PREQ_NO := NEW_PROD_REQHDR.PH_PREQ_NO;
  if CheckMerge(PREQ_NO, setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COUNTERCODE', PD_COUNTERCODE), 8), productionDemandCounters) then
  begin
    NEW_PROD_REQHDR.PH_FAMILYCODE := PREQ_NO;
    m_NeedToMakeMerge := true
  end;

  read_prod_reqhdr_list.Add(NEW_PROD_REQHDR);

end;

//----------------------------------------------------------------------------//

procedure ifNeededUpdatePROD_REQHDR_List(additionalDataList: TList;
                                MQMProductionColumnValues: PMQMProductionColumnValues;
                                CUR_PRODUCTIONDEMANDTEMPLATE: PPRODUCTIONDEMANDTEMPLATES;
                                read_prod_reqhdr_list: TList;
                                uniqueWorkCenterProcesses: TStringlist;
                                itemTypeTemplates: TList;
                                productionDemandCounters: TList;
                                LastStepMQMProductionColumnValues: PMQMProductionColumnValues);
var
  CUR_PROD_REQHDR: PTMQMPH;

  CUR_ITEMTYPEPRODUCTIONDEMANDTEMPLATE: PITEMTYPEPRODUCTIONDEMANDTEMPLATES;
  CUR_PRODUCTIONDEMANDCOUNTER: PPRODUCTIONDEMANDCOUNTERS;
begin
  CUR_PROD_REQHDR := read_prod_reqhdr_list.Items[read_prod_reqhdr_list.Count - 1];

  if ((CUR_PROD_REQHDR.PH_SPLITCONFLEVELS = '') and
       (CUR_PROD_REQHDR.PH_LEAD_STEP_SPLITED = 0)) then
  begin
    CUR_ITEMTYPEPRODUCTIONDEMANDTEMPLATE := nil;
    if (uniqueWorkCenterProcesses.IndexOf(Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_WORKCENTERCODE', PDS_WORKCENTERCODE)) + ' ' +
                                          Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_OPERATIONCODE', PDS_OPERATIONCODE))
                                         ) <> -1 ) then
    begin
      CUR_ITEMTYPEPRODUCTIONDEMANDTEMPLATE := setItemTypeTemplate(itemTypeTemplates,
                          getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ITEMTYPEAFICODE', PD_ITEMTYPEAFICODE),
                          CUR_PRODUCTIONDEMANDTEMPLATE.CODE,
                          Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_WORKCENTERCODE', PDS_WORKCENTERCODE)),
                          Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_OPERATIONCODE', PDS_OPERATIONCODE)));

      if (CUR_ITEMTYPEPRODUCTIONDEMANDTEMPLATE <> nil) then
      begin
        CUR_PROD_REQHDR.PH_SPLITCONFLEVELS := CUR_ITEMTYPEPRODUCTIONDEMANDTEMPLATE.HOSTSPLITCONFIRMLEVEL;
        CUR_PROD_REQHDR.PH_LEAD_STEP_SPLITED := StrToInt(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_STEPNUMBER', PDS_STEPNUMBER));

        CUR_PRODUCTIONDEMANDCOUNTER := nil;
        CUR_PRODUCTIONDEMANDCOUNTER := setProductionDemandCounter(productionDemandCounters,
                                   Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COUNTERCODE', PD_COUNTERCODE)));
      end;
      {
      else
      begin
        CUR_PROD_REQHDR.PH_SPLITCONFLEVELS := '';
        CUR_PROD_REQHDR.PH_LEAD_STEP_SPLITED := '0';
      end;
      }
    end;
  end;
end;

//----------------------------------------------------------------------------//

function getAdditionalDataValue(defaultValue: String; additionalDataTableName: String;
                                additionalDataColumnName: String; additionalDataList: TList;
                                p_uniqueId: String; fikd_uniqueId: String;
                                pd_uniqueId: String; pds_uniqueId: String): String;
var
  value: String;

  CUR_ADDITIONALDATA_HEADER: PADDITIONALDATA_HEADERS;
  index: integer;
  DataType : Integer;
begin
  value := '';
  DataType := 0;

  if ( (Trim(additionalDataTableName) <> '') AND
       (Trim(additionalDataColumnName) <> '') ) then
  begin
    if (Trim(additionalDataTableName) = 'Product AD') then
    begin
      {
      index := searchInListForAD(additionalDataList, 8, Trim(p_uniqueId),
                                 0, additionalDataList.Count - 1);
      }

      index := searchInList(additionalDataList, 8, Trim(p_uniqueId),
                            0, additionalDataList.Count - 1);

      if ( index <> -1 ) then
      begin
        CUR_ADDITIONALDATA_HEADER := additionalDataList.Items[index];
        value := getAdditionalData(CUR_ADDITIONALDATA_HEADER.productADList,
                                               Trim(additionalDataColumnName), DataType);
      end;
    end
    else if (Trim(additionalDataTableName) = 'FullItemKeyDecoder AD') then
    begin
      index := searchInList(additionalDataList, 8, Trim(fikd_uniqueId),
                          0, additionalDataList.Count - 1);
      if ( index <> -1 ) then
      begin
        CUR_ADDITIONALDATA_HEADER := additionalDataList.Items[index];
        value := getAdditionalData(CUR_ADDITIONALDATA_HEADER.fullItemKeyDecoderADList,
                                               Trim(additionalDataColumnName), DataType);
      end;
    end
    else if (Trim(additionalDataTableName) = 'ProductionDemand AD') then
    begin
      {
      index := searchInListForAD(additionalDataList, 8, Trim(pd_uniqueId),
                                 0, additionalDataList.Count - 1);
      }

      index := searchInList(additionalDataList, 8, Trim(pd_uniqueId),
                          0, additionalDataList.Count - 1);

      if ( index <> -1 ) then
      begin
        CUR_ADDITIONALDATA_HEADER := additionalDataList.Items[index];
        value := getAdditionalData(CUR_ADDITIONALDATA_HEADER.productionDemandADList,
                                               Trim(additionalDataColumnName), DataType);
      end;
    end
    else if (Trim(additionalDataTableName) = 'ProductionDemandStep AD') then
    begin
      {
      index := searchInListForAD(additionalDataList, 8, Trim(pds_uniqueId),
                                 0, additionalDataList.Count - 1);
      }

      index := searchInList(additionalDataList, 8, Trim(pds_uniqueId),
                          0, additionalDataList.Count - 1);

      if ( index <> -1 ) then
      begin
        CUR_ADDITIONALDATA_HEADER := additionalDataList.Items[index];
        value := getAdditionalData(CUR_ADDITIONALDATA_HEADER.productionDemandStepADList,
                                               Trim(additionalDataColumnName), DataType);
      end;
    end;
  end;

  if ( Trim(value) <> '' ) then
    Result := value
  else
    Result := defaultValue;
end;

//----------------------------------------------------------------------------//

procedure insertIntoPRODUCED_ARTICLE_List(preqNo: String; sequence: String;
                                          productCode: String; netGroupCode: String;
                                          allocReq: String; prodBalance: String;
                                          rscCode: String; settled: String;
                                          reqQuantity: String; qtyProduced: String;
                                          qtyAlloc: String; demandTemplateCode: String;
                                          demandCounterCode: String; itemTypeCode: String;
                                          read_produced_article_list: TList;
                                          isFromOtherProducedArticle: boolean;
                                          logicalWarehouse: String;
                                          itemTypeLogicalWarehouseList: TList;
                                          MQMProductionColumnValues: PMQMProductionColumnValues;
                                          Items : PTItems;
                                          productionDemandCounters : TList;
                                          additionalDataList: TList);
var
  NEW_PRODUCED_ARTICLE: PTMQMPA;
  PREQ_NO : string;
begin
  New(NEW_PRODUCED_ARTICLE);

  NEW_PRODUCED_ARTICLE.PA_PROD_REQ_NR := preqNo;
  NEW_PRODUCED_ARTICLE.PA_SEQUENCE := sequence;
  NEW_PRODUCED_ARTICLE.PA_PROD_CODE := productCode;

  if isFromOtherProducedArticle then
    NEW_PRODUCED_ARTICLE.PA_NET_GROUP_CODE := netGroupCode
  else
    NEW_PRODUCED_ARTICLE.PA_NET_GROUP_CODE := getNetGroupCode(netGroupCode, true,
                                                              itemTypeCode,
                                                              logicalWarehouse,
                                                              itemTypeLogicalWarehouseList,
                                                              MQMProductionColumnValues,
                                                              Items,
                                                              additionalDataList);

  NEW_PRODUCED_ARTICLE.PA_ALL_REQ := allocReq;
  NEW_PRODUCED_ARTICLE.PA_PROD_BALANCE := prodBalance;
  NEW_PRODUCED_ARTICLE.PA_RESOURCE :=rscCode;
  NEW_PRODUCED_ARTICLE.PA_SETTLED := settled;
  NEW_PRODUCED_ARTICLE.PA_REQ_QUANTY := StrToFloat(reqQuantity);
//  NEW_PRODUCED_ARTICLE.PA_REQ_QUANTY := (RoundTo((NEW_PRODUCED_ARTICLE.PA_REQ_QUANTY), 2) * (-1));  // up
  NEW_PRODUCED_ARTICLE.PA_REQ_QUANTY := (RoundTo(NEW_PRODUCED_ARTICLE.PA_REQ_QUANTY, -2));  // up
  NEW_PRODUCED_ARTICLE.PA_QTY_PRODUCED := StrToFloat(qtyProduced);
//  NEW_PRODUCED_ARTICLE.PA_QTY_PRODUCED := (RoundTo((NEW_PRODUCED_ARTICLE.PA_QTY_PRODUCED), 2) * (-1));  // up
  NEW_PRODUCED_ARTICLE.PA_QTY_PRODUCED := (RoundTo(NEW_PRODUCED_ARTICLE.PA_QTY_PRODUCED, -1));  // up
  NEW_PRODUCED_ARTICLE.PA_QTY_ALL := StrToFloat(qtyAlloc);

  NEW_PRODUCED_ARTICLE.PRODUCTIONDEMANDTEMPLATECODE := demandTemplateCode;
  NEW_PRODUCED_ARTICLE.PRODUCTIONDEMANDCOUNTERCODE := demandCounterCode;
  NEW_PRODUCED_ARTICLE.ITEMTYPECODE := itemTypeCode;

  PREQ_NO := NEW_PRODUCED_ARTICLE.PA_PROD_REQ_NR;
  if CheckMerge(PREQ_NO, setStringLengthTo(demandCounterCode, 8), productionDemandCounters) then
  begin
    NEW_PRODUCED_ARTICLE.PA_FAMILYCODE := PREQ_NO;
    m_NeedToMakeMerge := true
  end;

  read_produced_article_list.Add(NEW_PRODUCED_ARTICLE);
end;

//----------------------------------------------------------------------------//

procedure prepareValuesToInsertPRODUCED_ARTICLE(srvQryFD: TMqmQuery;
                                                MQMProductionColumnValues: PMQMProductionColumnValues;
                                                articleTypeList : TList;
                                                additionalDataList, UserGenericGroupTypeList, UserGenericGroupTypeAttributesList: TList;
                                                productsList: TList;
                                                read_produced_article_list: TList;
                                                currentProductsList: TList;
                                                logicalWarehouseList: TList;
                                                CUR_PRODUCTIONDEMANDTEMPLATE: PPRODUCTIONDEMANDTEMPLATES;
                                                Items : PTItems;
                                                productionDemandCounters : TList;
                                                itemTypeLogicalWarehouseList: TList);
var
  balanceHandledByMqm: String;
  prodCode: String;
  artType: String;
  HoursToDownFromMachin : integer;
  settled: String;
  J : integer;
  nature: String;
  beginTime: String;
  endTime: String;
  P_ABSUNIQUEID, FIKD_ABSUNIQUEID, SEARCHDESCRIPTION_P, ITEMTYPEAFICODE : string;
  SUBCODE01, SUBCODE02, SUBCODE03, SUBCODE04, SUBCODE05,
  SUBCODE06, SUBCODE07, SUBCODE08, SUBCODE09, SUBCODE10 : string;
  NetGroupCode : string;
  ProjectDode : string;
  ListIndex : integer;
  InsertNew, FoundWhLink : boolean;
  MATERIAL_TOLLERANCE_CODE, stdPurCorProdTime : string;
  Curr_LOGICALWAREHOUSE: PLOGICALWAREHOUSES;
begin
  MATERIAL_TOLLERANCE_CODE := '';
  stdPurCorProdTime := '0';
  if assigned(Items) then
  begin
    FIKD_ABSUNIQUEID := Items.ABSUNIQUEID;
    P_ABSUNIQUEID    := Items.ABSUNIQUEID_P;
    SEARCHDESCRIPTION_P := Items.SEARCHDESCRIPTION_P;
    ITEMTYPEAFICODE  := Items.ITEMTYPEAFICODE;
    SUBCODE01 := Items.SUBCODE01;
    SUBCODE02 := Items.SUBCODE02;
    SUBCODE03 := Items.SUBCODE03;
    SUBCODE04 := Items.SUBCODE04;
    SUBCODE05 := Items.SUBCODE05;
    SUBCODE06 := Items.SUBCODE06;
    SUBCODE07 := Items.SUBCODE07;
    SUBCODE08 := Items.SUBCODE08;
    SUBCODE09 := Items.SUBCODE09;
    SUBCODE10 := Items.SUBCODE10;
    stdPurCorProdTime := IntToStr(Items.PURCHASELEADTIME);
  end;

  balanceHandledByMqm := isBalanceHandledByMqm(articleTypeList,
                             ITEMTYPEAFICODE,
                             // getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ITEMTYPEAFICODE'),
                              additionalDataList, UserGenericGroupTypeList, UserGenericGroupTypeAttributesList,
                             // getValueOfTheProductionColumn(MQMProductionColumnValues, 'P_ABSUNIQUEID'));
                              P_ABSUNIQUEID, MATERIAL_TOLLERANCE_CODE,
                              SUBCODE01,SUBCODE02,SUBCODE03,SUBCODE04,SUBCODE05,SUBCODE06,SUBCODE07,SUBCODE08,SUBCODE09,SUBCODE10);

  nature := '';
  beginTime := '';
  endTime := '';

  // commented by erbil on 24.09.2009
  //if (balanceHandledByMqm = '0') then
  //begin
    prodCode := getFullItemKeyCode(ITEMTYPEAFICODE,//getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ITEMTYPEAFICODE'),
                                 SUBCODE01,  //getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE01'),
                                 SUBCODE02,  //getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE02'),
                                 SUBCODE03,  //getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE03'),
                                 SUBCODE04,  //getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE04'),
                                 SUBCODE05,  //getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE05'),
                                 SUBCODE06,  //getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE06'),
                                 SUBCODE07,  //getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE07'),
                                 SUBCODE08,  //getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE08'),
                                 SUBCODE09,  //getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE09'),
                                 SUBCODE10);  //getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE10'));


    artType := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ITEMTYPEAFICODE', PD_ITEMTYPEAFICODE);

    InsertNew := false;

    if insertedProducts.sorted then
      InsertNew := not insertedProducts.Find(artType + trim(prodCode), ListIndex)
    else if insertedProducts.IndexOf(artType + trim(prodCode)) = -1 then
      InsertNew := true;
    if InsertNew then
    begin
    //if insertedProducts.IndexOf(artType + trim(prodCode)) = -1 then
   // begin
        getProductNatureAndReservationTimes(articleTypeList, artType, nature, beginTime, endTime, HoursToDownFromMachin, '1', '0', '0');
          // need to loop all product that are warp and to insert them at the end , if they dont exists
        if ( needToInsertPRODUCTS(srvQryFD, artType, prodCode, nature, beginTime, endTime,
                             SEARCHDESCRIPTION_P, //  getValueOfTheProductionColumn(MQMProductionColumnValues, 'P_SEARCHDESCRIPTION'),
                                stdPurCorProdTime, currentProductsList, MATERIAL_TOLLERANCE_CODE, HoursToDownFromMachin, Items)
           ) then
      //    try
          insertIntoPRODUCTS(srvQryFD, artType, prodCode, nature, beginTime, endTime,
                            SEARCHDESCRIPTION_P, // getValueOfTheProductionColumn(MQMProductionColumnValues, 'P_SEARCHDESCRIPTION'),
                             stdPurCorProdTime, MATERIAL_TOLLERANCE_CODE, HoursToDownFromMachin, Items.MAT_STANDARD_SPEED_Warp,Items.MAT_STANDARD_SETMIN_Warp, Items.MAT_SCHEDULE_Type_Warp);

        {  except
          on E: Exception do
            begin
            end;
          end; }
        insertedProducts.Add(artType + trim(prodCode));
   //   end;
    end;
  //end;

  if ( Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_PROGRESSSTATUS', PD_PROGRESSSTATUS)) <> '6' ) then //SETTLED
    settled := '0'
  else
    settled := '1';

  Curr_LOGICALWAREHOUSE := getLogicalWHStruct(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ENTRYWAREHOUSECODE', PD_ENTRYWAREHOUSECODE) , logicalWarehouseList);
  if Curr_LOGICALWAREHOUSE = nil then
    NetGroupCode := ''
  else
    NetGroupCode := ' ' + Curr_LOGICALWAREHOUSE.MQMGROUPCODE;
//  NetGroupCode := ' ' + getMqmGroupCode(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ENTRYWAREHOUSECODE', PD_ENTRYWAREHOUSECODE), logicalWarehouseList);
  if Assigned(Items) and Assigned(Items.ItemWarehouseLink) then
  begin
    FoundWhLink := false;
    for J := 0 to Items.ItemWarehouseLink.Count - 1 do
    begin
      if trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ENTRYWAREHOUSECODE', PD_ENTRYWAREHOUSECODE)) = trim(PItemWarehouseLinkRec(Items.ItemWarehouseLink[J]).LogicalWarehouseCode) then
      begin
        FoundWhLink := true;
        if PItemWarehouseLinkRec(Items.ItemWarehouseLink[J]).ProjectControlled then
        begin
          if trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_PROJECTCODE', PD_PROJECTCODE)) <> '' then
          begin
            ProjectDode := trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_PROJECTCODE', PD_PROJECTCODE));
            NetGroupCode := NetGroupCode + '_' + GetNumberByProject(ProjectNumberList, ProjectDode);
          end;
        end;
        break;
      end;
    end;

    if not FoundWhLink
       and Items.ProjectControlled
       and (trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_PROJECTCODE', PD_PROJECTCODE)) <> '') and (Curr_LOGICALWAREHOUSE <> nil)
       and Curr_LOGICALWAREHOUSE.ProjectControlled then
    begin
      ProjectDode := trim(trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_PROJECTCODE', PD_PROJECTCODE)));
      NetGroupCode := NetGroupCode + '_' + GetNumberByProject(ProjectNumberList, ProjectDode);
    end;

  end;

  insertIntoPRODUCED_ARTICLE_List(setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COMPANYCODE', PD_COMPANYCODE), 3) +
                                  setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COUNTERCODE', PD_COUNTERCODE), 8) +
                                  getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_CODE', PD_CODE),
                                  '001',
                                  getFullItemKeyCode(ITEMTYPEAFICODE,//getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ITEMTYPEAFICODE'),
                                                     SUBCODE01, //getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE01'),
                                                     SUBCODE02, //getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE02'),
                                                     SUBCODE03, //getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE03'),
                                                     SUBCODE04, //getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE04'),
                                                     SUBCODE05, //getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE05'),
                                                     SUBCODE06, //getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE06'),
                                                     SUBCODE07, //getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE07'),
                                                     SUBCODE08, //getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE08'),
                                                     SUBCODE09, //getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE09'),
                                                     SUBCODE10), //getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE10')),
                               //   ' ' + getMqmGroupCode(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ENTRYWAREHOUSECODE'),
                               //                         logicalWarehouseList), //LOGICALWAREHOUSE.MQMGroupCode
                                  NetGroupCode,

                                  '',
                                  balanceHandledByMqm, //PROD_BALANCE
                                  '',
                                  settled,
                                  getNumericValueOf(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_BASEPRIMARYQUANTITY', PD_BASEPRIMARYQUANTITY)),
                                  getNumericValueOf(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ENTEREDBASEPRIMARYQUANTITY', PD_ENTEREDBASEPRIMARYQUANTITY)),
                                  '0',
                                  CUR_PRODUCTIONDEMANDTEMPLATE.CODE,
                                  getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COUNTERCODE', PD_COUNTERCODE),
                                  getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ITEMTYPEAFICODE', PD_ITEMTYPEAFICODE),
                                  read_produced_article_list,
                                  false,
                                  getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ENTRYWAREHOUSECODE', PD_ENTRYWAREHOUSECODE),
                                  itemTypeLogicalWarehouseList,
                                  MQMProductionColumnValues,
                                  Items,
                                  productionDemandCounters,
                                  additionalDataList
                                 );
end;

//----------------------------------------------------------------------------//

function insertIntoMaterialList(preqNo: String; pstepId: String;
                                 orgStep: String; wkcnter: String;
                                 resCatCode: String; rscCode: String;
                                 machineSetupCode: String; alternativeCode: String;
                                 typeProd: String; productCode: String;
                                 netGroupCode: String; issueCode: String;
                                 seqIssued: String; matBalance: String;
                                 qtyAlloc: double; highDateAlloc: TDate;
                                 searchMatAlloc: String; settled: String;
                                 quantitiyIssue: String; reqQuantity: String;
                                 demandTemplateCode: String; demandCounterCode: String;
                                 read_material_list: TList;
                                 alternativeWarehouseList: TList;
                  //               flagForAlternatives: boolean;
                  //               isFromOtherMaterial: boolean;
                                 logicalWarehouse: String;
                                 itemTypeLogicalWarehouseList: TList;
                                 MQMProductionColumnValues: PMQMProductionColumnValues;
                                 Items : PTItems;
                                 productionDemandCounters : TList;
                                 ProjectCode : string;
                                 additionalDataList: TList) : Pointer;
var
  NEW_MATERIAL: PTMQMMT;
  CUR_MATERIAL: PTMQMMT;
  index, I : integer;
  PosLoc : integer;
  TempExt : Extended;
  S : string;
  TempStrQty : String;
  PREQ_NO    : string;
begin
  New(NEW_MATERIAL);

  NEW_MATERIAL.MT_PROD_REQ_Nr := preqNo;
  NEW_MATERIAL.MT_PSTEP_ID := StrToInt(pstepId);
  NEW_MATERIAL.MT_ORG_STEP := StrToInt(orgStep);
  NEW_MATERIAL.MT_WKCTR_CODE := wkcnter;
  NEW_MATERIAL.MT_RES_CAT_CODE := resCatCode;
  NEW_MATERIAL.MT_RES_CODE := rscCode;
  NEW_MATERIAL.MT_MACHIN_SETUP_CODE := machineSetupCode;
  NEW_MATERIAL.MT_ALTERNATIVE_CODE := alternativeCode;
  NEW_MATERIAL.MT_PROD_TYPE := typeProd;
  NEW_MATERIAL.MT_PROD_CODE := Trim(productCode);
//  NEW_MATERIAL.MT_NET_GROUP_CODE_WITHOUT_PROGECTCODE := productCode;

//  if isFromOtherMaterial then
//    NEW_MATERIAL.MT_NET_GROUP_CODE:= netGroupCode
//  else
  NEW_MATERIAL.MT_NET_GROUP_CODE := getNetGroupCode(netGroupCode, false,
                                                    typeProd,
                                                    logicalWarehouse,
                                                    itemTypeLogicalWarehouseList,
                                                    MQMProductionColumnValues,
                                                    Items,
                                                    additionalDataList);

  NEW_MATERIAL.MT_ISSUE_CODE := issueCode;
  NEW_MATERIAL.MT_SEQ_ISSUED := seqIssued;
  NEW_MATERIAL.MT_MAT_BALACE := matBalance;
  NEW_MATERIAL.MT_QUANTITY_ALLOC := qtyAlloc;

{  TempExt := Frac(StrToFloat(qtyAlloc));
  S := FloatToStr(TempExt);
  if Length(S) > 4 then
  begin
    S := Copy(s, 2, 3);
    TempStrQty := FloatToStr(trunc(StrToFloat(qtyAlloc)));
    TempStrQty := TempStrQty + s;
    NEW_MATERIAL.MT_QUANTITY_ALLOC := StrToFloat(TempStrQty);
  end; }

  NEW_MATERIAL.MT_HIGH_DATE_ALLOC := highDateAlloc;
  NEW_MATERIAL.MT_SEARCH_MAT_BY_ALLOC := searchMatAlloc;
  NEW_MATERIAL.MT_SETTLED := settled;
  NEW_MATERIAL.MT_QUANTITY_ISSUE := StrToFloat(quantitiyIssue);
//  NEW_MATERIAL.MT_QUANTITY_ISSUE := (RoundTo((NEW_MATERIAL.MT_QUANTITY_ISSUE), 2) * (-1));  // up
  NEW_MATERIAL.MT_REQ_QUANTITY := StrToFloat(reqQuantity);

//  NEW_MATERIAL.MT_REQ_QUANTITY := (RoundTo((NEW_MATERIAL.MT_REQ_QUANTITY), 2 * (-1)));  // up

  if m_NeedToMakeMerge and assigned(MQMProductionColumnValues) then
  begin
    PREQ_NO := NEW_MATERIAL.MT_PROD_REQ_Nr;

    if CheckMerge(PREQ_NO, setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COUNTERCODE', PD_COUNTERCODE), 8), productionDemandCounters) then
    begin
      NEW_MATERIAL.MT_FAMILYCODE := PREQ_NO;
      m_NeedToMakeMerge := true
    end;
  end;

  read_material_list.Add(NEW_MATERIAL);

//  if flagForAlternatives then
    addAlternativesOfMaterial(read_material_list, alternativeWarehouseList, ProjectCode);
  result := NEW_MATERIAL;
end;

//----------------------------------------------------------------------------//

procedure prepareValuesToInsertMATERIAL(srvQryFD: TMqmQuery;  productionReservationList: TList;
                                        stepNumbersOfHandledWorkCenters, stepNumbersOfHandledNameOfWorkCenters: TStringList;
                                        MQMProductionColumnValues: PMQMProductionColumnValues;
                                        articleTypeList: TList;
                                        additionalDataList, UserGenericGroupTypeList, UserGenericGroupTypeAttributesList: TList;
                                        productsList: TList;
                                        read_material_list: TList;
                                        currentProductsList: TList;
                                        logicalWarehouseList: TList;
                                        CUR_PRODUCTIONDEMANDTEMPLATE: PPRODUCTIONDEMANDTEMPLATES;
                                        alternativeWarehouseList: TList;
                                        List_Items : TList;
                                        productionDemandCounters: TList;
                                        itemTypeLogicalWarehouseList: TList; var PRODUCT_CODE : string);
var
  MQMProductionReservation: PMQMProductionReservation;
  i, i1, J: Integer;
  handledStepNumber: String;
  balanceHandledByMqm: String;
  prodCode: String;
  artType: String;
  settled: String;
  ListIndex : integer;
  nature: String;
  beginTime: String;
  endTime: String;
  HoursToDownFromMachin : integer;
  InsertNew : boolean;
  CUR_MATERIAL: PTMQMMT;
  FirstFound, FoundWhLink : boolean;
  materialSearchStartIndex : integer;
  NetGroupCode, ProjectCode, ProjecNumber : string;
  P_ABSUNIQUEID : string;
  Items : PTItems;
  Index : Integer;
  MATERIAL_TOLLERANCE_CODE, Work_center, ServedCode : string;
  PREQ_NO, PR_PREQ_NO, stdPurCorProdTime : string;
  Curr_LOGICALWAREHOUSE: PLOGICALWAREHOUSES;
  FoundServedCode, MatchReservation : boolean;
  fullItemKeyCode : String;
  preqNoStr : String;
  stepNumInt : Integer;
begin
  FirstFound := false;
  Items := nil;
  stdPurCorProdTime := '0';
  materialSearchStartIndex := read_material_list.Count;

  /// updating serving code

  FoundServedCode := false;
  for i := 0 to productionReservationList.Count - 1 do
  begin

    MQMProductionReservation := productionReservationList.Items[i];

    index := searchInList(List_Items, 44, MQMProductionReservation.PRSV_ABSUNIQUEID , 0, List_Items.Count - 1);
    MQMProductionReservation.IndexOfItem := index;
    if Index = -1 then continue;

    MatchReservation := true;
    if Trim(MQMProductionReservation.PRSV_PROJECTCODE) = '' then
      MatchReservation := false;
    if FoundServedCode then
      MatchReservation := false;
    if trim(CUR_PRODUCTIONDEMANDTEMPLATE.ITEMTYPESERVED) = '' then
    begin
      if Trim(MQMProductionReservation.PRSV_REFERENCEITEM) <> '1' then
        MatchReservation := false;
    end
    else
    begin
      if trim(CUR_PRODUCTIONDEMANDTEMPLATE.ITEMTYPESERVED) <>
          Trim(MQMProductionReservation.PRSV_ITEMTYPEAFICODE) then
        MatchReservation := false;
    end;
    if MatchReservation then
    begin
      if CUR_PRODUCTIONDEMANDTEMPLATE.SERVEDCODEDEFNITION = '1' then
        ServedCode := Trim(MQMProductionReservation.RSV_FIKD_IDENTIFIER) +
                      GetNumberByProject(ProjectNumberList, Trim(MQMProductionReservation.PRSV_PROJECTCODE));
      if CUR_PRODUCTIONDEMANDTEMPLATE.SERVEDCODEDEFNITION = '2' then
      begin
        ServedCode := Trim(MQMProductionReservation.PRSV_ITEMTYPEAFICODE) +
                      GetNumberByProject(ProjectNumberList, trim(MQMProductionReservation.PRSV_PROJECTCODE));
      end;
      FoundServedCode := true;
      PTMQMPH(read_prod_reqhdr_list[read_prod_reqhdr_list.Count -1]).PH_SERVED_CODE := ServedCode;
    end;

  end;

  preqNoStr := setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COMPANYCODE', PD_COMPANYCODE), 3) +
               setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COUNTERCODE', PD_COUNTERCODE), 8) +
               getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_CODE', PD_CODE);

  for i := 0 to productionReservationList.Count - 1 do
  begin

    nature := '';
    beginTime := '';
    endTime := '';

    MQMProductionReservation := productionReservationList.Items[i];

    fullItemKeyCode := getFullItemKeyCode(MQMProductionReservation.PRSV_ITEMTYPEAFICODE,
                                          MQMProductionReservation.PRSV_SUBCODE01,
                                          MQMProductionReservation.PRSV_SUBCODE02,
                                          MQMProductionReservation.PRSV_SUBCODE03,
                                          MQMProductionReservation.PRSV_SUBCODE04,
                                          MQMProductionReservation.PRSV_SUBCODE05,
                                          MQMProductionReservation.PRSV_SUBCODE06,
                                          MQMProductionReservation.PRSV_SUBCODE07,
                                          MQMProductionReservation.PRSV_SUBCODE08,
                                          MQMProductionReservation.PRSV_SUBCODE09,
                                          MQMProductionReservation.PRSV_SUBCODE10);

//    index := searchInList(List_Items, 44, MQMProductionReservation.PRSV_ABSUNIQUEID , 0, List_Items.Count - 1);
    Index := MQMProductionReservation.IndexOfItem;
    if Index <> -1  then
    begin
      Items := PTITEMS(List_Items[Index]);
      stdPurCorProdTime := IntToStr(Items.PURCHASELEADTIME);
    end;

//    if ( stepNumbersOfHandledWorkCenters.IndexOf(MQMProductionReservation.STEP_NUMBER) = -1 ) then
//      handledStepNumber := stepNumbersOfHandledWorkCenters.Strings[0]
//    else
//      handledStepNumber := MQMProductionReservation.STEP_NUMBER;

    // Avi-eran 12/11/2024
    //handledStepNumber := stepNumbersOfHandledWorkCenters.Strings[0];
    handledStepNumber := '';
    stepNumInt := StrToInt(MQMProductionReservation.STEP_NUMBER);
    for I1 := 0 to stepNumbersOfHandledWorkCenters.Count - 1 do
    begin
      if stepNumInt > StrToInt(stepNumbersOfHandledWorkCenters.Strings[I1]) then continue;
      handledStepNumber := stepNumbersOfHandledWorkCenters.Strings[I1];
      Work_center       := stepNumbersOfHandledNameOfWorkCenters.Strings[I1];
      break;
    end;
    if handledStepNumber = '' then continue;

    balanceHandledByMqm := isBalanceHandledByMqm(articleTypeList,
                                MQMProductionReservation.PRSV_ITEMTYPEAFICODE,
                                additionalDataList, UserGenericGroupTypeList, UserGenericGroupTypeAttributesList,
                                P_ABSUNIQUEID, MATERIAL_TOLLERANCE_CODE,//getValueOfTheProductionColumn(MQMProductionColumnValues, 'P_ABSUNIQUEID'));
                                MQMProductionReservation.PRSV_SUBCODE01,
                                MQMProductionReservation.PRSV_SUBCODE02,
                                MQMProductionReservation.PRSV_SUBCODE03,
                                MQMProductionReservation.PRSV_SUBCODE04,
                                MQMProductionReservation.PRSV_SUBCODE05,
                                MQMProductionReservation.PRSV_SUBCODE06,
                                MQMProductionReservation.PRSV_SUBCODE07,
                                MQMProductionReservation.PRSV_SUBCODE08,
                                MQMProductionReservation.PRSV_SUBCODE09,
                                MQMProductionReservation.PRSV_SUBCODE10);

    // commented by erbil on 24.09.2009
    //if (balanceHandledByMqm = '0') then
    //begin
      if (MQMProductionReservation.ITEM_NATURE = '1') then
        prodCode := fullItemKeyCode
      else
        prodCode := MQMProductionReservation.PRSV_SUBCODE01;

      artType := MQMProductionReservation.PRSV_ITEMTYPEAFICODE;

      if insertedProducts.sorted then
        InsertNew := not insertedProducts.Find(artType + trim(prodCode), ListIndex)
      else if insertedProducts.IndexOf(artType + trim(prodCode)) = -1 then
        InsertNew := true;

     // if insertedProducts.IndexOf(artType + trim(prodCode)) = -1 then
      if InsertNew then

      begin
        if (MQMProductionReservation.ITEM_NATURE = '1') then
        begin
          getProductNatureAndReservationTimes(articleTypeList, artType, nature, beginTime, endTime, HoursToDownFromMachin, '1', '0', '0');

          //if ( needToInsertPRODUCTS(srvQryFD, artType, prodCode, '1', '0', '0',
          if ( needToInsertPRODUCTS(srvQryFD, artType, prodCode, nature, beginTime, endTime,
                                    MQMProductionReservation.SEARCH_DESCRIPTION,
                                    stdPurCorProdTime, currentProductsList, MATERIAL_TOLLERANCE_CODE, HoursToDownFromMachin, Items)
             ) then
            try
            insertIntoPRODUCTS(srvQryFD, artType, prodCode, nature, beginTime, endTime,
                               MQMProductionReservation.SEARCH_DESCRIPTION,
                               stdPurCorProdTime, MATERIAL_TOLLERANCE_CODE, HoursToDownFromMachin, Items.MAT_STANDARD_SPEED_Warp,Items.MAT_STANDARD_SETMIN_Warp, Items.MAT_SCHEDULE_Type_Warp);
            except
            on E: Exception do
              begin
              end;
            end;
        end
        else
        begin
          getProductNatureAndReservationTimes(articleTypeList, artType, nature, beginTime, endTime, HoursToDownFromMachin, '1', '0', '0');

          //if ( needToInsertPRODUCTS(srvQryFD, artType, prodCode, '3', '1', '3',
          if ( needToInsertPRODUCTS(srvQryFD, artType, prodCode, nature, beginTime, endTime,
                                    MQMProductionReservation.SEARCH_DESCRIPTION,
                                    stdPurCorProdTime, currentProductsList, MATERIAL_TOLLERANCE_CODE, HoursToDownFromMachin, Items)
             ) then
            try
            insertIntoPRODUCTS(srvQryFD, artType, prodCode, nature, beginTime, endTime,
                               MQMProductionReservation.SEARCH_DESCRIPTION,
                               stdPurCorProdTime, MATERIAL_TOLLERANCE_CODE, HoursToDownFromMachin, Items.MAT_STANDARD_SPEED_Warp,Items.MAT_STANDARD_SETMIN_Warp, Items.MAT_SCHEDULE_Type_Warp);
            except
            on E: Exception do
              begin
              end;
            end;
        end;

        insertedProducts.Add(artType + trim(prodCode));
      end;
    //end;

    if ( MQMProductionReservation.PRSV_PROGRESSSTATUS <> '3' ) then
      settled := '0'
    else
      settled := '1';

    if (MQMProductionReservation.PRSV_ITEMTYPEAFICODE <> '') then
    begin
//      materialSearchStartIndex := 0;  Moved above to get the list count : ERAN
      CUR_MATERIAL := getRelevantMaterial(preqNoStr,
                                             strtoint(handledStepNumber),
                                          MQMProductionReservation.PRSV_ITEMTYPEAFICODE,
                                          fullItemKeyCode,
                                          read_material_list, materialSearchStartIndex);

      if (CUR_MATERIAL = nil) then
      begin

        if (Trim(MQMProductionReservation.PRSV_REFERENCEITEM) <> '0') and
           (Trim(MQMProductionReservation.PRSV_REFERENCEITEM) <> '') and (not FirstFound) then
        begin
          FirstFound := true;
          PRODUCT_CODE := fullItemKeyCode
        end;

       // Curr_LOGICALWAREHOUSE := getLogicalWHStruct(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PRSV_WAREHOUSECODE', PRSV_WAREHOUSECODE) , logicalWarehouseList);
        Curr_LOGICALWAREHOUSE := getLogicalWHStruct(MQMProductionReservation.PRSV_WAREHOUSECODE , logicalWarehouseList);
        if Curr_LOGICALWAREHOUSE = nil then
          NetGroupCode := ''
        else
          NetGroupCode := ' ' + Curr_LOGICALWAREHOUSE.MQMGROUPCODE;

        ProjectCode := '';
        if Assigned(Items) and Assigned(Items.ItemWarehouseLink) then
        begin
          try
            FoundWhLink := false;
            for J := 0 to Items.ItemWarehouseLink.Count - 1 do
            begin
              if not Assigned(Items.ItemWarehouseLink[J]) then Continue;
              if trim(MQMProductionReservation.PRSV_WAREHOUSECODE) = trim(PItemWarehouseLinkRec(Items.ItemWarehouseLink[J]).LogicalWarehouseCode) then
              begin
                FoundWhLink := true;
                if PItemWarehouseLinkRec(Items.ItemWarehouseLink[J]).ProjectControlled then
                begin
                  if trim(MQMProductionReservation.PRSV_PROJECTCODE) <> '' then
                 // if trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PRSV_PROJECTCODE', PRSV_PROJECTCODE)) <> '' then
                  begin
                    //ProjectCode := trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PRSV_PROJECTCODE', PRSV_PROJECTCODE));
                    ProjectCode := trim(MQMProductionReservation.PRSV_PROJECTCODE);
                    ProjecNumber := GetNumberByProject(ProjectNumberList, ProjectCode);
                    NetGroupCode := NetGroupCode + '_' + ProjecNumber;
                  end;
                end;
                break;
              end;
            end;

            if not FoundWhLink
               and Items.ProjectControlled
               and (trim(trim(MQMProductionReservation.PRSV_PROJECTCODE)) <> '') and (Curr_LOGICALWAREHOUSE <> nil)
               and Curr_LOGICALWAREHOUSE.ProjectControlled then
            begin
              ProjectCode := trim(trim(MQMProductionReservation.PRSV_PROJECTCODE));
              NetGroupCode := NetGroupCode + '_' + GetNumberByProject(ProjectNumberList, ProjectCode);
            end;
          except
          end;
        end;

        {if (alternativeWarehouseList.Count > 0) then
        begin
          index := searchInList(alternativeWarehouseList, 37, Trim(Work_center), 0, alternativeWarehouseList.Count - 1);
          if index = -1 then
             Work_center := '';
        end
        else
          Work_center := ''; } // no need to be set in materials. avi eran 24/04/2025
                               // mqm will handle it according ALTERNATIVEWAREHOUSE table.
        Work_center := '';

        insertIntoMaterialList(preqNoStr,
                               handledStepNumber, //stepnumber
                               handledStepNumber, //stepnumber
                               Work_center,
                               '',
                               '',
                               '',
                               '',
                               MQMProductionReservation.PRSV_ITEMTYPEAFICODE,
                               fullItemKeyCode,
                               NetGroupCode,
                            //   ' ' + getMqmGroupCode(MQMProductionReservation.PRSV_WAREHOUSECODE,
                           //                          logicalWarehouseList),
                               '',
                               '001',
                               balanceHandledByMqm,
                               MQMProductionReservation.QUANTITY_ALLOC,
                               0,
                               '0',
                               settled,
                               MQMProductionReservation.PRSV_USEDBASEPRIMARYQUANTITY,
                               MQMProductionReservation.PRSV_BASEPRIMARYQUANTITY,
                               CUR_PRODUCTIONDEMANDTEMPLATE.CODE,
                               getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COUNTERCODE', PD_COUNTERCODE),
                               read_material_list,
                               alternativeWarehouseList,
               //                true,
               //                false,
                               MQMProductionReservation.PRSV_WAREHOUSECODE,
                               //getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ENTRYWAREHOUSECODE', PD_ENTRYWAREHOUSECODE),
                               itemTypeLogicalWarehouseList,
                               MQMProductionColumnValues,
                               Items,
                               productionDemandCounters,
                               ProjecNumber,
                               additionalDataList
                               );
      end
      else
      begin
        CUR_MATERIAL.MT_QUANTITY_ISSUE := StrToFloat(addUpFields(FloatToStr(CUR_MATERIAL.MT_QUANTITY_ISSUE),
                                                      MQMProductionReservation.PRSV_USEDBASEPRIMARYQUANTITY,
                                                      false));

        CUR_MATERIAL.MT_REQ_QUANTITY := StrToFloat(addUpFields(FloatToStr(CUR_MATERIAL.MT_REQ_QUANTITY),
                                                    MQMProductionReservation.PRSV_BASEPRIMARYQUANTITY,
                                                    false));
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

function isBalanceHandledByMqm(articleTypeList: TList; itemTypeCode: String;
                               additionalDataList, UserGenericGroupTypeList, UserGenericGroupAttributesList : TList;
                                 uniqueId: String; var MATERIAL_TOLLERANCE_CODE : string;
                                 SUBCODE01,SUBCODE02,SUBCODE03,SUBCODE04,SUBCODE05,SUBCODE06,SUBCODE07,SUBCODE08,SUBCODE09,SUBCODE10 : string): String;
var
  defaultFlagBalanceHandledByMqm: String;
  additionalDataColumnName: String;
  balanceHandledByMqm, tablename, SUBCODE, ColumnName, SUBCODEVALUE, ABSUNIQUEID : String;

  CUR_ADDITIONALDATA_HEADER: PADDITIONALDATA_HEADERS;
  CUR_ARTICLE_TYPE: PARTICLE_TYPES;
  index: integer;
  DataType, SUBCODENR : Integer;
  UserGenericGroupType : String;
  UserGenericGroupTypeAttributes : PTUserGenericGroupAttributes;
begin
  defaultFlagBalanceHandledByMqm := '';
  additionalDataColumnName := '';
  balanceHandledByMqm := '';
  DataType := 0;

  index := searchInList(articleTypeList, 15, Trim(itemTypeCode), 0,
                        articleTypeList.Count - 1);

  if ( index <> -1 ) then
  begin
    CUR_ARTICLE_TYPE := articleTypeList.Items[index];
    defaultFlagBalanceHandledByMqm := CUR_ARTICLE_TYPE.AT_BALHANDLEDBYMQM;
    additionalDataColumnName := CUR_ARTICLE_TYPE.AT_ADDDATACOLUMNNAME;
    tablename := CUR_ARTICLE_TYPE.AT_TABLE_NAME;
    ColumnName := CUR_ARTICLE_TYPE.AT_ADDDATACOLUMNNAME;
    MATERIAL_TOLLERANCE_CODE := CUR_ARTICLE_TYPE.AT_MaterialTolleranceCode
  end
  else
    defaultFlagBalanceHandledByMqm := '0';

  if Trim(additionalDataColumnName) <> '' then
  begin

    if (tablename = 'Product AD') or (tablename = '') then
    begin
      index := searchInList(additionalDataList, 8, Trim(uniqueId),
                          0, additionalDataList.Count - 1);

      if ( index <> -1 ) then
      begin
        CUR_ADDITIONALDATA_HEADER := additionalDataList.Items[index];

        if (tablename = 'Product AD') or (tablename = '') then
          balanceHandledByMqm := getAdditionalData(CUR_ADDITIONALDATA_HEADER.productADList,
                                                 Trim(additionalDataColumnName), DataType)
      end
    end
    else
    begin

      if (copy(tablename, 1, 19) = 'UserGenericGroup AD') then
      begin
        SUBCODE := copy(tablename, 28, 2);
        SUBCODENR := strtoint(SUBCODE);
        UserGenericGroupType := getUserGenericGroupType(itemTypeCode, SUBCODENR, UserGenericGroupTypeList);
        case SUBCODENR of
          1: SUBCODEVALUE  := Trim(SUBCODE01);
          2 : SUBCODEVALUE := Trim(SUBCODE02);
          3 : SUBCODEVALUE := Trim(SUBCODE03);
          4 : SUBCODEVALUE := Trim(SUBCODE04);
          5 : SUBCODEVALUE := Trim(SUBCODE05);
          6 : SUBCODEVALUE := Trim(SUBCODE06);
          7 : SUBCODEVALUE := Trim(SUBCODE07);
          8 : SUBCODEVALUE := Trim(SUBCODE08);
          9 : SUBCODEVALUE := Trim(SUBCODE09);
          10 : SUBCODEVALUE := Trim(SUBCODE10);
        end;
        UserGenericGroupTypeAttributes := getUserGenericGroupTypeAttributes(UserGenericGroupType, SUBCODEVALUE, UserGenericGroupAttributesList);
        if assigned(UserGenericGroupTypeAttributes) then
          ABSUNIQUEID := UserGenericGroupTypeAttributes.ABSUNIQUEID
        else
          ABSUNIQUEID := '';
        index := searchInList(additionalDataList, 8, ABSUNIQUEID, 0, additionalDataList.Count - 1);

        if index <> -1 then
        begin
          CUR_ADDITIONALDATA_HEADER := additionalDataList.Items[index];
          balanceHandledByMqm := getAdditionalData(CUR_ADDITIONALDATA_HEADER.UserGenericGroupADList, ColumnName, DataType);
        end;
      end
    end;

    if Trim(balanceHandledByMqm) = '1' then
      Result := '0'
    else if Trim(balanceHandledByMqm) = '0' then
      Result := '9'
    else
    begin
      if ( defaultFlagBalanceHandledByMqm = '0' ) then
        Result := '9'
      else
        Result := '0';
    end;
  end
  else
  begin
    if ( defaultFlagBalanceHandledByMqm = '0' ) then
      Result := '9'
    else
      Result := '0';
  end;
end;

//----------------------------------------------------------------------------//

function getLogicalWHStruct(WarehouseCode: String; logicalWarehouseList: TList) : PLOGICALWAREHOUSES;
var
  CUR_LOGICALWAREHOUSE: PLOGICALWAREHOUSES;
  index: integer;
begin
  Result := nil;
  if ( Trim(WarehouseCode) <> '' ) then
  begin
    index := searchInList(logicalWarehouseList, 18, Trim(WarehouseCode), 0,
                          logicalWarehouseList.Count - 1);

    if ( index <> - 1 ) then
    begin
      CUR_LOGICALWAREHOUSE := logicalWarehouseList.Items[index];
      Result := CUR_LOGICALWAREHOUSE;
    end;
  end;
end;

//----------------------------------------------------------------------------//

function getTimeTypeCode(MQMProductionColumnValues: PMQMProductionColumnValues;
                         routingStepTimeTypeList: TList;
                         handledWorkCentersList: TList): String;
var
  index: integer;
  CUR_ROUTING_STEP_TIME_TYPE: PROUTING_STEP_TIME_TYPES;
  listToSearch: array[0..4] of string;
  i: Integer;

  CUR_WORKCENTER: PWORKCENTERS;
  CUR_PROCESS: PPROCESSES;
begin
  index := searchInList(handledWorkCentersList, 1, Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_WORKCENTERCODE', PDS_WORKCENTERCODE)),
                        0, handledWorkCentersList.Count - 1);

  if ( index <> -1 ) then
  begin
    CUR_WORKCENTER :=  handledWorkCentersList.Items[index];

    index := searchInList(CUR_WORKCENTER.Process_List, 2, Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_OPERATIONCODE', PDS_OPERATIONCODE)),
                          0, CUR_WORKCENTER.Process_List.Count - 1);

    if ( index <> -1 ) then
    begin
      CUR_PROCESS :=  CUR_WORKCENTER.Process_List.Items[index];

      if Trim(CUR_PROCESS.WP_TYPE) <> '' then
        result := CUR_PROCESS.WP_TYPE
      else
        result := 'C';

      if (result = 'B') and (CUR_PROCESS.WP_BATCHSTANDARDTIME = '2') then
        result := 'H'

    end;
  end;

  if result = '' then
  begin
    Result := 'B';

    listToSearch[0] := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_TIMETYPE1CODE', PDS_TIMETYPE1CODE));
    listToSearch[1] := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_TIMETYPE2CODE', PDS_TIMETYPE2CODE));
    listToSearch[2] := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_TIMETYPE3CODE', PDS_TIMETYPE3CODE));
    listToSearch[3] := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_TIMETYPE4CODE', PDS_TIMETYPE4CODE));
    listToSearch[4] := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_TIMETYPE5CODE', PDS_TIMETYPE5CODE));

    for i := 0 to 4 do
    begin
      index := searchInList(routingStepTimeTypeList, 11, listToSearch[i],
                            0, routingStepTimeTypeList.Count - 1);

      if ( index <> -1 ) then
      begin
        CUR_ROUTING_STEP_TIME_TYPE :=  routingStepTimeTypeList.Items[index];

        if ( (CUR_ROUTING_STEP_TIME_TYPE.RSTT_APPLYTYPECODE = 'UNIT') AND
             (CUR_ROUTING_STEP_TIME_TYPE.RSTT_TYPE = '2') ) then
        begin
          Result := 'C';
          break;
        end;
      end;
    end;

  end;
end;

//----------------------------------------------------------------------------//

procedure insertIntoPROD_STEP_List(MQMProductionColumnValues: PMQMProductionColumnValues;
                              CUR_WORKCENTER: PWORKCENTERS;
                              previousStepHandledByMcm : string;
                              nextStepHandledByMcm     : string;
                              previousStepHandledByMqm: String; previousStepInDemand: String;
                              nextStepHandledByMqm: String; nextStepInDemand: String;
                              timeTypeCode: String;
                              read_prod_step_list: TList; handledWorkCentersList, unhandledWorkCentersList: TList;
                              CUR_PRODUCTIONDEMANDTEMPLATE: PPRODUCTIONDEMANDTEMPLATES;
                              Items : PTItems;
                              additionalDataList: TList; standardWeightUnit: String;
                              itemTypeTemplates: TList;
                              PTNA_REC : PT_TNA;
                              productionDemandCounters: TList
                              );
var
  NEW_PROD_STEP: PTMQMPD;

  tempDate_STDBEGINPRESETUP: TDate;
  tempDate_MINBEGINQUEUE: TDate;
  tempDate_STDENDSTEP: TDate;
  tempDate_MAXENDSTEP: TDate;
  tempDateTime_INITIALPLANSCHEDDATETIME: TDateTime;
  tempDatetime_FINALPLANSCHEDDATETIME: TDateTime;

  tempVal, PREQ_NO: String;
  PrevRequest : String;

  CUR_PROCESS: PPROCESSES;
  index: Integer;
  P_ABSUNIQUEID ,FIKD_ABSUNIQUEID, ITEMTYPEAFICODE : string;
  SUBCODE01, SUBCODE02, SUBCODE03, SUBCODE04, SUBCODE05,
  SUBCODE06, SUBCODE07, SUBCODE08, SUBCODE09, SUBCODE10 : string;
  TempExt : Extended;
  TempDouble : double;
  S, TempStrQty : string;
  PRODUCTIONORDERCODE : string;
  GRPSTEP : string;
  PRODUCTIONORDERCODE_GRPSTEP : string;
  AD_OVERLAP_WITH_OTHER_STEPS : string;
  isWorkCenterHandled, isWorkCenterHandledByMqm, isWorkCenterHandledByMcm : string;
  IsGenericPlanHandaled : boolean;
begin

  if assigned(CUR_WORKCENTER) then
  begin
    isWorkCenterHandledByMqm := CUR_WORKCENTER.WC_HANDLEDBYMQM;
    isWorkCenterHandledByMcm := CUR_WORKCENTER.WC_HANDLEDBYMCM;
    isWorkCenterHandled      := '1';
    IsGenericPlanHandaled    := CUR_WORKCENTER.WC_HANDLEGERERICPLAN;
  end
  else
  begin
    isWorkCenterHandled := '0';
    isWorkCenterHandledByMqm := '0';
    isWorkCenterHandledByMcm := '0';
    IsGenericPlanHandaled := false;
  end;

  if assigned(Items) then
  begin
    FIKD_ABSUNIQUEID := Items.ABSUNIQUEID;
    P_ABSUNIQUEID    := Items.ABSUNIQUEID_P;
    ITEMTYPEAFICODE  := Items.ITEMTYPEAFICODE;
    SUBCODE01 := Items.SUBCODE01;
    SUBCODE02 := Items.SUBCODE02;
    SUBCODE03 := Items.SUBCODE03;
    SUBCODE04 := Items.SUBCODE04;
    SUBCODE05 := Items.SUBCODE05;
    SUBCODE06 := Items.SUBCODE06;
    SUBCODE07 := Items.SUBCODE07;
    SUBCODE08 := Items.SUBCODE08;
    SUBCODE09 := Items.SUBCODE09;
    SUBCODE10 := Items.SUBCODE10;
  end;

  tempDateTime_INITIALPLANSCHEDDATETIME := 0;
  if m_Exist_INITIALPLANSCHEDDATETIME and (getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_INITIALPLANSCHEDDATETIME', PDS_INITIALPLANSCHEDDATETIME) <> '') then
  begin
    try
      tempDateTime_INITIALPLANSCHEDDATETIME := StrToDateTime(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_INITIALPLANSCHEDDATETIME', PDS_INITIALPLANSCHEDDATETIME))
    except
    end;
  end;

  tempDateTime_FINALPLANSCHEDDATETIME := 0;
  if m_Exist_FINALPLANSCHEDDATETIME and (getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_FINALPLANSCHEDDATETIME', PDS_FINALPLANSCHEDDATETIME) <> '') then
  begin
    try
      tempDateTime_FINALPLANSCHEDDATETIME := StrToDateTime(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_FINALPLANSCHEDDATETIME', PDS_FINALPLANSCHEDDATETIME))
    except
    end;
  end;

  tempDate_STDBEGINPRESETUP := 0;
  if getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_STDBEGINPRESETUP', PDS_STDBEGINPRESETUP) <> '' then
  try
    tempDate_STDBEGINPRESETUP := StrToDateTime(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_STDBEGINPRESETUP', PDS_STDBEGINPRESETUP) + ' ' +
                                               getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_STDBEGINPRESETUPTIME', PDS_STDBEGINPRESETUPTIME));
  except
  end;

  tempDate_MINBEGINQUEUE := 0;
  if getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_MINBEGINQUEUE', PDS_MINBEGINQUEUE) <> '' then
  try
    tempDate_MINBEGINQUEUE := StrToDateTime(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_MINBEGINQUEUE', PDS_MINBEGINQUEUE) + ' ' +
                                            getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_MINBEGINQUEUETIME', PDS_MINBEGINQUEUETIME));
  except
  end;

  tempDate_STDENDSTEP := 0;
  if getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_STDENDSTEP', PDS_STDENDSTEP) <> '' then
  try
    tempDate_STDENDSTEP := StrToDateTime(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_STDENDSTEP', PDS_STDENDSTEP) + ' ' +
                                         getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_STDENDSTEPTIME', PDS_STDENDSTEPTIME));
  except
  end;

  tempDate_MAXENDSTEP := 0;
  if getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_MAXENDSTEP', PDS_MAXENDSTEP) <> '' then
  try
    tempDate_MAXENDSTEP := StrToDateTime(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_MAXENDSTEP', PDS_MAXENDSTEP) + ' ' +
                                         getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_MAXENDSTEPTIME', PDS_MAXENDSTEPTIME));
  except
  end;

  New(NEW_PROD_STEP);

  NEW_PROD_STEP.PD_SchedulByMcm              := '';
  NEW_PROD_STEP.PD_SchedulByMqm              := '';
  NEW_PROD_STEP.PD_SplitFamily               := '';
  NEW_PROD_STEP.PD_GRP_SEQUENCE              := '';
  NEW_PROD_STEP.PD_BatchSizePerStep          := '';
  NEW_PROD_STEP.PD_MinBatchSize              := 0;
  NEW_PROD_STEP.PD_OptimumBatchSize          := 0;
  NEW_PROD_STEP.PD_MaxBatchSize              := 0;
  NEW_PROD_STEP.PD_MaxStartDateAutoSeq       := 0;
  NEW_PROD_STEP.WP_QUEUE_TIME                := '';
  NEW_PROD_STEP.Wp_POST_PROCESS              := '';

  NEW_PROD_STEP.PD_ALTERNATIVEQTY            := 0;
  NEW_PROD_STEP.PD_ALTERNATIVEUM             := '';

  if IsGenericPlanHandaled then
    NEW_PROD_STEP.PD_STEP_PART_GEN_PLAN        := '1'
  else
    NEW_PROD_STEP.PD_STEP_PART_GEN_PLAN        := '0';

  NEW_PROD_STEP.PD_PREQ_NO := setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COMPANYCODE', PD_COMPANYCODE), 3) +
                              setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COUNTERCODE', PD_COUNTERCODE), 8) +
                              getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_CODE', PD_CODE);
  NEW_PROD_STEP.PD_PSTEP_ID := StrToInt(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_STEPNUMBER', PDS_STEPNUMBER));
  NEW_PROD_STEP.PD_TO_SCHED := isWorkCenterHandled;
  NEW_PROD_STEP.PD_PRV_STEP_SCHED_MQM := StrToInt(previousStepHandledByMqm);
  NEW_PROD_STEP.PD_PRV_STEP_TRUE := StrToInt(previousStepInDemand);
  NEW_PROD_STEP.PD_NEX_STEP_SCHED_MQM := StrToInt(nextStepHandledByMqm);
  NEW_PROD_STEP.PD_NEX_STEP_TRUE := StrToInt(nextStepInDemand);

  NEW_PROD_STEP.PD_PRV_STEP_SCHED_MCM := StrToInt(previousStepHandledByMcm);
  NEW_PROD_STEP.PD_NEX_STEP_SCHED_MCM := StrToInt(nextStepHandledByMcm);

  NEW_PROD_STEP.PD_STEP_TYP := timeTypeCode;
  if getValueOfTheProductionColumn(MQMProductionColumnValues, 'PRSV_ISSUEDATE', PRSV_ISSUEDATE) <> '' then
  begin
    try
      NEW_PROD_STEP.PD_MAT_ARRV_DATE := StrToDateTime(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PRSV_ISSUEDATE',PRSV_ISSUEDATE))
    except
      NEW_PROD_STEP.PD_MAT_ARRV_DATE := 0;
    end;
  end
  else
    NEW_PROD_STEP.PD_MAT_ARRV_DATE := 0;
  NEW_PROD_STEP.PD_FRC_MAT_DATE := '0';
  NEW_PROD_STEP.PD_PLAN_START := tempDate_STDBEGINPRESETUP;
  NEW_PROD_STEP.PD_LOW_LIMIT_TIME_STRT := tempDate_MINBEGINQUEUE;
  NEW_PROD_STEP.PD_FRC_LOW_DATE := '0';
  NEW_PROD_STEP.PD_PLAN_END := tempDate_STDENDSTEP;
  NEW_PROD_STEP.PD_HIGH_LIMIT_TIMEND := tempDate_MAXENDSTEP;
  NEW_PROD_STEP.PD_FRC_HIGH_DATE := '0';
  NEW_PROD_STEP.PD_INITIALPLANSCHEDDATETIME := tempDateTime_INITIALPLANSCHEDDATETIME;
  NEW_PROD_STEP.PD_FINALPLANSCHEDDATETIME   := tempDateTime_FINALPLANSCHEDDATETIME;

  NEW_PROD_STEP.PD_WKCNTER := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_WORKCENTERCODE', PDS_WORKCENTERCODE);
  NEW_PROD_STEP.PD_WKCT_PROC := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_OPERATIONCODE', PDS_OPERATIONCODE);

  if (ProcessListAlternativeUM_Primary.Count > 0) or (ProcessListAlternativeUM_secondary.Count > 0) or (PackagingAlternativeUoM.Count > 0) then
  begin
    if ProcessListAlternativeUM_Primary.IndexOf(NEW_PROD_STEP.PD_WKCT_PROC) <> -1 then
    begin
      NEW_PROD_STEP.PD_ALTERNATIVEQTY := StrToFloat(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_INITIALUSERPRIMARYQUANTITY', PDS_INITIALUSERPRIMARYQUANTITY));
      NEW_PROD_STEP.PD_ALTERNATIVEUM  := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_USERPRIMARYUOMCODE ', PDS_USERPRIMARYUOMCODE);;
    end
    else if ProcessListAlternativeUM_secondary.IndexOf(NEW_PROD_STEP.PD_WKCT_PROC) <> -1 then
    begin
      NEW_PROD_STEP.PD_ALTERNATIVEQTY := StrToFloat(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_INITIALUSERSECONDARYQUANTITY', PDS_INITIALUSERSECONDARYQUANTITY));
      NEW_PROD_STEP.PD_ALTERNATIVEUM  := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_USERSECONDARYUOMCODE ', PDS_USERSECONDARYUOMCODE);;
    end
    else if PackagingAlternativeUoM.IndexOf(NEW_PROD_STEP.PD_WKCT_PROC) <> -1 then
    begin
      NEW_PROD_STEP.PD_ALTERNATIVEQTY := StrToFloat(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_INITIALUSERPACKAGINGQUANTITY', PDS_INITIALUSERPACKAGINGQUANTITY));
      NEW_PROD_STEP.PD_ALTERNATIVEUM  := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_USERPACKAGINGUOMCODE ', PDS_USERPACKAGINGUOMCODE);;
    end

  end;

  NEW_PROD_STEP.PD_INIT_QUENT := StrToFloat(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_INITIALBASEPRIMARYQUANTITY', PDS_INITIALBASEPRIMARYQUANTITY));
  NEW_PROD_STEP.PD_FIN_QUENT := StrToFloat(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_FINALBASEPRIMARYQUANTITY', PDS_FINALBASEPRIMARYQUANTITY));

  TempExt := Frac(NEW_PROD_STEP.PD_INIT_QUENT);
  S := FloatToStr(TempExt);
  if Length(S) > 4 then
  begin
    S := Copy(s, 2, 3);
    TempStrQty := FloatToStr(trunc(NEW_PROD_STEP.PD_INIT_QUENT));
    TempStrQty := TempStrQty + s;
    NEW_PROD_STEP.PD_INIT_QUENT := StrToFloat(TempStrQty);
  end;

  TempExt := Frac(NEW_PROD_STEP.PD_FIN_QUENT);
  S := FloatToStr(TempExt);
  if Length(S) > 4 then
  begin
    S := Copy(s, 2, 3);
    TempStrQty := FloatToStr(trunc(NEW_PROD_STEP.PD_FIN_QUENT));
    TempStrQty := TempStrQty + s;
    NEW_PROD_STEP.PD_FIN_QUENT := StrToFloat(TempStrQty);
  end;

  TempExt := Frac(NEW_PROD_STEP.PD_ALTERNATIVEQTY);
  S := FloatToStr(TempExt);
  if Length(S) > 4 then
  begin
    S := Copy(s, 2, 3);
    TempStrQty := FloatToStr(trunc(NEW_PROD_STEP.PD_ALTERNATIVEQTY));
    TempStrQty := TempStrQty + s;
    NEW_PROD_STEP.PD_ALTERNATIVEQTY := StrToFloat(TempStrQty);
  end;

  if Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_BASEPRIMARYUOMCODE', PDS_BASEPRIMARYUOMCODE)) = Trim(standardWeightUnit) then
    NEW_PROD_STEP.PD_WEIGHT := round(StrToFloat(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_INITIALBASEPRIMARYQUANTITY', PDS_INITIALBASEPRIMARYQUANTITY)))
  else if Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_BASESECONDARYUOMCODE', PDS_BASESECONDARYUOMCODE)) = Trim(standardWeightUnit) then
    NEW_PROD_STEP.PD_WEIGHT := round(StrToFloat(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_INITIALBASESECONDARYQUANTITY', PDS_INITIALBASESECONDARYQUANTITY)))
  else
  begin

    NEW_PROD_STEP.PD_WEIGHT := round(ConvertUM(MQMProductionColumnValues, getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_BASEPRIMARYUOMCODE', PD_BASEPRIMARYUOMCODE),standardWeightUnit,
                                             StrToFloat(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_INITIALBASEPRIMARYQUANTITY', PDS_INITIALBASEPRIMARYQUANTITY)),
                                             ITEMTYPEAFICODE, //getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ITEMTYPEAFICODE'),
                                             SUBCODE01, SUBCODE02, SUBCODE03, SUBCODE04, SUBCODE05,
                                             SUBCODE06, SUBCODE07, SUBCODE08, SUBCODE09, SUBCODE10));
  end;


  NEW_PROD_STEP.PD_DESC_UM := trim(standardWeightUnit);

  NEW_PROD_STEP.PD_CAL := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_CALENDARCODE', PDS_CALENDARCODE);


  NEW_PROD_STEP.QUEUE_TIME := StrToFloat(getNumericValueOf(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_CALCULATEDTIME1', PDS_CALCULATEDTIME1))) * 60;
  NEW_PROD_STEP.POST_PROCESS := StrToFloat(getNumericValueOf(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_CALCULATEDTIME4', PDS_CALCULATEDTIME4))) * 60;

  tempVal := getNumericValueOf(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_CALCULATEDTIME2', PDS_CALCULATEDTIME2));
  NEW_PROD_STEP.PD_SETUP_TIME_STP:= (StrToFloat(tempVal) * 60);

  TempExt := Frac(NEW_PROD_STEP.PD_SETUP_TIME_STP);
  S := FloatToStr(TempExt);
  if Length(S) > 4 then
  begin
    S := Copy(s, 2, 3);
    TempStrQty := FloatToStr(trunc(NEW_PROD_STEP.PD_SETUP_TIME_STP));
    TempStrQty := TempStrQty + s;
    NEW_PROD_STEP.PD_SETUP_TIME_STP := StrToFloat(TempStrQty);
  end;

  tempVal := getNumericValueOf(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_CALCULATEDTIME3', PDS_CALCULATEDTIME3));
  NEW_PROD_STEP.PD_EXC_TIME_STP := (StrToFloat(tempVal) * 60);

  TempExt := Frac(NEW_PROD_STEP.PD_EXC_TIME_STP);
  S := FloatToStr(TempExt);
  if Length(S) > 4 then
  begin
    S := Copy(s, 2, 3);
    TempStrQty := FloatToStr(trunc(NEW_PROD_STEP.PD_EXC_TIME_STP));
    TempStrQty := TempStrQty + s;
    NEW_PROD_STEP.PD_EXC_TIME_STP := StrToFloat(TempStrQty);
//    NEW_PROD_STEP.PD_EXC_TIME_STP := FloatToStr(trunc(StrToFloat(NEW_PROD_STEP.PD_EXC_TIME_STP)));
//    NEW_PROD_STEP.PD_EXC_TIME_STP := NEW_PROD_STEP.PD_EXC_TIME_STP + s;
  end;

  NEW_PROD_STEP.PD_RES_NUM_PLN := StrToFloat(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_NROFMACHINE', PDS_NROFMACHINE));

  NEW_PROD_STEP.PD_STEP_HANDLE_REPROCES := '0';

  // added by Erbil on 04/03/2009
  // NEW_PROD_STEP.PD_FORCED_GRP_NO := 'null';

  // added by Erbil on 27/05/2009
  NEW_PROD_STEP.PD_LearningCurveType := '0';
  NEW_PROD_STEP.PD_LearningCurveCode := '';
  NEW_PROD_STEP.PD_ApprovalDate := 0;
  NEW_PROD_STEP.PD_NumResComponents := 0;

  PRODUCTIONORDERCODE := '';
  NEW_PROD_STEP.PD_FORCED_GRP_NO := 0;

  if assigned(CUR_WORKCENTER) then
  begin

    index := searchInList(CUR_WORKCENTER.Process_List, 2, Trim(NEW_PROD_STEP.PD_WKCT_PROC),
                          0, CUR_WORKCENTER.Process_List.Count - 1);

    if ( index <> -1 ) then
    begin
      CUR_PROCESS :=  CUR_WORKCENTER.Process_List.Items[index];

      NEW_PROD_STEP.PD_ALLOW_SPLIT := getAllowSplitValueFromWkc_Proc(CUR_WORKCENTER, CUR_PROCESS,
                                                                    additionalDataList, Items,
                                                                    MQMProductionColumnValues, itemTypeTemplates); //'1'

      NEW_PROD_STEP.PD_SplitFamily := getSplitFamilyValueFromWkc_Proc(CUR_WORKCENTER, CUR_PROCESS,
                                                                         additionalDataList, Items,
                                                                         MQMProductionColumnValues);

      if CUR_PROCESS.CONSIDER_QUEUE_TIME_AS_LEADTIME_To_PREVIOUS_STEP = '1' then
         NEW_PROD_STEP.WP_QUEUE_TIME := '1';

      if CUR_PROCESS.CONSIDER_POST_PROCESS_TIME_LEADTIME_NEXT_STEP = '1' then
         NEW_PROD_STEP.Wp_POST_PROCESS := '1';

      if (CUR_PROCESS.WP_ISNOWPRDORD_MQMGROUP = '0') then
      begin
        if (CUR_PROCESS.WP_CANBEGROUPEDINMQM = '0') then
          NEW_PROD_STEP.PD_STEP_CAN_GROUP := '0'
        else if CUR_PROCESS.WP_CANBEGROUPEDINMQM = '1' then
          NEW_PROD_STEP.PD_STEP_CAN_GROUP := '1'
        else if CUR_PROCESS.WP_CANBEGROUPEDINMQM = '2' then
          NEW_PROD_STEP.PD_STEP_CAN_GROUP := '3';
      end
      else
      begin

        PRODUCTIONORDERCODE := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_PRODUCTIONORDERCODE', PDS_PRODUCTIONORDERCODE);

        GRPSTEP   := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_GROUPSTEPNUMBER', PDS_GROUPSTEPNUMBER);
        PRODUCTIONORDERCODE_GRPSTEP := PRODUCTIONORDERCODE + GRPSTEP;
       // NEW_PROD_STEP.PD_Production_GRP_NO_STR := NEW_PROD_STEP.PD_FORCED_GRP_NO_STR + NEW_PROD_STEP.PD_GROUPSTEPNUMBER;

        if Trim(PRODUCTIONORDERCODE) <> '' then
          NEW_PROD_STEP.PD_FORCED_GRP_NO := getForcedGroupNo(Production_Order_Grp_No_list,
                            Trim(PRODUCTIONORDERCODE), GRPSTEP);

        if (Trim(PRODUCTIONORDERCODE) <> '') then
          NEW_PROD_STEP.PD_STEP_CAN_GROUP := '2'
        else
          NEW_PROD_STEP.PD_STEP_CAN_GROUP := '0';


      end;

      if assigned(Items) then
        P_ABSUNIQUEID    := Items.ABSUNIQUEID_P;

//      NEW_PROD_STEP.PD_LearningCurveCode := getAdditionalDataValue('', 'ProductionDemandStep AD',//getAdditionalDataValue('', 'Product AD',
//                                                                     CUR_WORKCENTER.WC_AD_LEARNINGCURVE_CODE,
//                                                                     additionalDataList,P_ABSUNIQUEID, '', '',
//                                                                     getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_ABSUNIQUEID', PDS_ABSUNIQUEID));

      NEW_PROD_STEP.PD_LearningCurveType := CUR_WORKCENTER.WC_HANDLE_LEARNINGCURVE;

      if (PTNA_REC <> nil) and CUR_WORKCENTER.WC_APPROVALDATE_BY_TNA then
         NEW_PROD_STEP.PD_ApprovalDate := PTNA_REC.ApprovalDate;

      // There is no sense. in the archive put in the AD 0 or 1 - STUPID ! Correct the archive then activate it. Put in all customers blank.
{      AD_OVERLAP_WITH_OTHER_STEPS := getAdditionalDataValue('', 'ProductionDemandStep AD',
                                                                     CUR_WORKCENTER.WC_AD_OVERLAP_WITH_OTHER_STEPS,
                                                                     additionalDataList,P_ABSUNIQUEID, '', '', '');

      if (AD_OVERLAP_WITH_OTHER_STEPS <> '0') and (AD_OVERLAP_WITH_OTHER_STEPS <> '1') then   }
        NEW_PROD_STEP.PD_OVERLAP_WITH_OTHER_STEPS := CUR_WORKCENTER.WC_OVERLAP_WITH_OTHER_STEPS;

    end;
  end;

  NEW_PROD_STEP.PD_CONN_TYPE_PREV_STEP_SPLIT := '2';
  NEW_PROD_STEP.PD_FRC_OVERLAPP := '0';

  if trim(NEW_PROD_STEP.PD_STEP_CAN_GROUP) = '' then
     NEW_PROD_STEP.PD_STEP_CAN_GROUP := '0';

  if trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_PROGRESSSTATUS', PDS_PROGRESSSTATUS)) = '3' then
    NEW_PROD_STEP.PD_STEP_CLOSED := '1'
  else
    NEW_PROD_STEP.PD_STEP_CLOSED := '0';

  NEW_PROD_STEP.PD_USR_CG := 'USERNAME';
  NEW_PROD_STEP.PD_USR_TM_CG := Now;

  NEW_PROD_STEP.PD_SchedulByMqm := isWorkCenterHandledByMqm;
  NEW_PROD_STEP.PD_SchedulByMcm := isWorkCenterHandledByMcm;

  if (isWorkCenterHandledByMqm <> '1') and (isWorkCenterHandledByMcm <> '1') then
  begin
    index := searchInList(unhandledWorkCentersList, 1, Trim(NEW_PROD_STEP.PD_WKCNTER),
                        0, unhandledWorkCentersList.Count - 1);
    if (index <> -1 ) then
    begin
      CUR_WORKCENTER :=  unhandledWorkCentersList.Items[index];
      if CUR_WORKCENTER.WC_RES_NUM_PLN > 0 then
      begin
        NEW_PROD_STEP.PD_SETUP_TIME_STP := 0;
        NEW_PROD_STEP.PD_EXC_TIME_STP := 0
      end;
    end;
  end;

  //added by Erbil on 23/03/2009

  PREQ_NO := NEW_PROD_STEP.PD_PREQ_NO;
  if CheckMerge(PREQ_NO, setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COUNTERCODE', PD_COUNTERCODE), 8), productionDemandCounters) then
  begin
    NEW_PROD_STEP.PD_FAMILYCODE := PREQ_NO;
    m_NeedToMakeMerge := true
  end;

  read_prod_step_list.Add(NEW_PROD_STEP);

end;

//----------------------------------------------------------------------------//

function insertIntoPROD_STEP_TIMES_List(MQMProductionColumnValues: PMQMProductionColumnValues;
                             timeTypeCode: String;
                             UserGenericGroupTypeList, UserGenericGroupTypeAttributesList : TList;
                             routingStepTimeTypeList: TList;
                             CUR_WORKCENTER: PWORKCENTERS;
                             handledWorkCentersList: TList;
                             operationList: TList;
                             propertyList : TList;
                             ColorTypeList: TList;
                             ColorTypeUNIQUEIDList: Tlist;
                             productionDemandCounters: TList;
                             additionalDataList: TList;
                             read_prod_step_time_list: TList;
                             Items : PTItems;
                             CUR_PRODUCTIONDEMANDTEMPLATE: PPRODUCTIONDEMANDTEMPLATES
                             ): double;
var
  i, J: Integer;

  anyMQMProduction_Times_LevelFound: boolean;
  anyMQMWorkCenterAndOperAttributeFound: boolean;
  needToCreateDefaultLine: boolean;

  stepInitialQty: double;
  stepStdQty: double;

  setupTime: double;
  executionTime: double;
  executeTimeAlt: double;
  quantity, indexConcatinated: integer;

  stepEfficiency: double;

  workCenterCode: String;
  operationCode: String;
  WcAttributeCode, OverridenTimeOrQty1, OverridenTimeOrQty2, OverridenTimeOrQty3, OverridenTimeOrQty4, OverridenTimeOrQty5, StepRepetition : string;
  itemType: String;
  WP_BATCHSTANDARDTIME : string;
  index: integer;
  AttributeFound, Eficiency100Percent : boolean;
  CUR_PROCESS: PPROCESSES;
  CUR_OPERATTRIBUTE: POPERATTRIBUTES;
  CUR_PRODUCTIONTIMESLEVEL: PPRODUCTIONTIMESLEVELS;
  CUR_PRODUCTIONTIME: PPRODUCTIONTIMES;
  BATCHSTANDARDTIME : boolean;
  ST_PREQ_NO, ConcatinatedValue : string;
  P_ABSUNIQUEID ,FIKD_ABSUNIQUEID, ITEMTYPEAFICODE : string;
  SUBCODE01, SUBCODE02, SUBCODE03, SUBCODE04, SUBCODE05,
  SUBCODE06, SUBCODE07, SUBCODE08, SUBCODE09, SUBCODE10 : string;
begin
  Result := 0;
  executionTime := 0;
  executeTimeAlt := 0;
  quantity := 1;
  stepStdQty := 0;
  if assigned(Items) then
  begin
    FIKD_ABSUNIQUEID := Items.ABSUNIQUEID;
    P_ABSUNIQUEID    := Items.ABSUNIQUEID_P;
    ITEMTYPEAFICODE  := Items.ITEMTYPEAFICODE;
    SUBCODE01 := Items.SUBCODE01;
    SUBCODE02 := Items.SUBCODE02;
    SUBCODE03 := Items.SUBCODE03;
    SUBCODE04 := Items.SUBCODE04;
    SUBCODE05 := Items.SUBCODE05;
    SUBCODE06 := Items.SUBCODE06;
    SUBCODE07 := Items.SUBCODE07;
    SUBCODE08 := Items.SUBCODE08;
    SUBCODE09 := Items.SUBCODE09;
    SUBCODE10 := Items.SUBCODE10;
  end;
  anyMQMProduction_Times_LevelFound := false;
  anyMQMWorkCenterAndOperAttributeFound := false;
  needToCreateDefaultLine := true;
  BATCHSTANDARDTIME := false;

  ST_PREQ_NO := setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COMPANYCODE', PD_COMPANYCODE), 3) +
                                   setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COUNTERCODE', PD_COUNTERCODE), 8) +
                                   getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_CODE', PD_CODE);

//  if ST_PREQ_NO = '100SEW     SEW240000002906' then
//      ST_PREQ_NO := ST_PREQ_NO;

  CUR_OPERATTRIBUTE := nil;
  CUR_PRODUCTIONTIMESLEVEL := nil;

  if CUR_WORKCENTER = nil then exit;
  workCenterCode := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_WORKCENTERCODE', PDS_WORKCENTERCODE));

  operationCode := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_OPERATIONCODE', PDS_OPERATIONCODE));
  index := searchInList(CUR_WORKCENTER.Process_List, 2, Trim(operationCode),
                        0, CUR_WORKCENTER.Process_List.Count - 1);

  if ( index <> -1 ) then
  begin
    CUR_PROCESS :=  CUR_WORKCENTER.Process_List.Items[index];

    if CUR_PROCESS.OperAttributes_List.Count > 0 then
      CUR_OPERATTRIBUTE := CUR_PROCESS.OperAttributes_List.Items[0]
    else
      CUR_OPERATTRIBUTE := nil;

    if CUR_PROCESS.WP_BATCHSTANDARDTIME = '1' then
      BATCHSTANDARDTIME := false
    else
	    BATCHSTANDARDTIME := true;

    itemType := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_ITEMTYPEAFICODE', PDS_ITEMTYPEAFICODE));

    index := searchInList(CUR_PROCESS.ProductionTimesLevel_List, 6, itemType,
                    0, CUR_PROCESS.ProductionTimesLevel_List.Count - 1);

    if ( index <> -1 ) then
    begin
      CUR_PRODUCTIONTIMESLEVEL := CUR_PROCESS.ProductionTimesLevel_List.Items[index];
      anyMQMProduction_Times_LevelFound := true;
    end;
  end;

  if (CUR_OPERATTRIBUTE <> nil) then
    anyMQMWorkCenterAndOperAttributeFound := true;

  if anyMQMProduction_Times_LevelFound then
  begin
    if anyMQMWorkCenterAndOperAttributeFound  and (CUR_PRODUCTIONTIMESLEVEL.HANDLE_TIMES_BY = '1') then //Input time
    begin
      if getValues(CUR_PRODUCTIONTIMESLEVEL,
                         MQMProductionColumnValues,
                         Items,
                         UserGenericGroupTypeList, UserGenericGroupTypeAttributesList,
                         propertyList,
                         ColorTypeList, ColorTypeUNIQUEIDList,
                         additionalDataList, ConcatinatedValue) then

      begin
        indexConcatinated := GetTimeStartingIndex(CUR_PRODUCTIONTIMESLEVEL, ConcatinatedValue);

        for i := indexConcatinated to CUR_PRODUCTIONTIMESLEVEL.ProductionTimes_List.Count - 1 do
        begin
          if indexConcatinated = -1 then break;

          CUR_PRODUCTIONTIME := CUR_PRODUCTIONTIMESLEVEL.ProductionTimes_List.Items[i];

          if CUR_PRODUCTIONTIME.StrConcatination <> ConcatinatedValue then break;

          if ( (Trim(CUR_PRODUCTIONTIME.RESOURCE_CATEGORY) = '') AND
             (Trim(CUR_PRODUCTIONTIME.RESOURCE) = '')) then
            needToCreateDefaultLine := false;

          if trim(CUR_PRODUCTIONTIME.SETUP_TIME) = '' then
             CUR_PRODUCTIONTIME.SETUP_TIME := '1';
          setupTime := getDoubleFromStr(CUR_PRODUCTIONTIME.SETUP_TIME);

          {if ( getValues(CUR_PRODUCTIONTIMESLEVEL,
                         MQMProductionColumnValues,
                         Items,
                         propertyList,
                         ColorTypeList, ColorTypeUNIQUEIDList,
                         additionalDataList, RetrnString)
           ) then
        begin     }
          if ( timeTypeCode = 'B' ) then
            executionTime := getDoubleFromStr(CUR_PRODUCTIONTIME.BATCH_TIME)
          else
          begin
            stepInitialQty := getDoubleFromStr( getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_INITIALBASEPRIMARYQUANTITY', PDS_INITIALBASEPRIMARYQUANTITY) );



            executionTime := ConvertUM(MQMProductionColumnValues, getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_BASEPRIMARYUOMCODE', PD_BASEPRIMARYUOMCODE), CUR_PRODUCTIONTIME.CONTINUOUS_OPERATION_UM,
                                             //StrToFloat(CUR_PRODUCTIONTIME.CONTINUOUS_TIME),
                                             1,
                                          //   stepInitialQty,
                                             ITEMTYPEAFICODE,//getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ITEMTYPEAFICODE'),
                                           {  getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE01') ,
                                             getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE02') ,
                                             getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE03') ,
                                             getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE04') ,
                                             getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE05') ,
                                             getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE06') ,
                                             getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE07') ,
                                             getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE08') ,
                                             getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE09') ,
                                             getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE10')); }
                                             SUBCODE01, SUBCODE02, SUBCODE03, SUBCODE04, SUBCODE05,
                                             SUBCODE06, SUBCODE07, SUBCODE08, SUBCODE09, SUBCODE10);



          {  executionTime := getDoubleFromStr(
                                    convertUnitOfMeasure(MQMProductionColumnValues,
                                                         getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_BASEPRIMARYUOMCODE'),
                                                         CUR_PRODUCTIONTIME.CONTINUOUS_OPERATION_UM,
                                                         CUR_PRODUCTIONTIME.CONTINUOUS_TIME,
                                                         productPrimaryUomConversionDataList,
                                                         secondaryUnitCategoryConversionList,
                                                         stdUnitCategoryConversionList,
                                                         false)
                                              );        }

            //executionTime := executionTime * stepInitialQty;
            if executionTime = 0 then executionTime := 1; // temp

        //    executionTime :=  stepInitialQty/executionTime;
            if (Trim(CUR_PRODUCTIONTIME.CONTINUOUS_TIME) = '') or (StrToFloat(CUR_PRODUCTIONTIME.CONTINUOUS_TIME) = 0) then
              CUR_PRODUCTIONTIME.CONTINUOUS_TIME := '1';

            executionTime :=  (stepInitialQty * executionTime / StrToFloat(CUR_PRODUCTIONTIME.CONTINUOUS_TIME));
            executeTimeAlt := executionTime;//stepInitialQty;
          end;

          if ( Trim(CUR_PRODUCTIONTIME.CONSIDER_STEP_EFFICIENCY) = '1' ) then
          begin
            stepEfficiency := (StrToFloat(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_STEPEFFICIENCY', PDS_STEPEFFICIENCY)));
            executionTime := executionTime / (stepEfficiency / 100);
          end;

        insertProdStepTime_List(CUR_WORKCENTER, MQMProductionColumnValues, workCenterCode,
                                operationCode, CUR_PRODUCTIONTIME.RESOURCE_CATEGORY,
                                CUR_PRODUCTIONTIME.RESOURCE, CUR_PRODUCTIONTIME.OPERATION_TIME_MULTIPLIER, CUR_PRODUCTIONTIME.SETUP_TIME_MULTIPLIER, CUR_PRODUCTIONTIMESLEVEL, FloatToStr(setupTime),
                                FloatToStr(executionTime), FloatToStr(executeTimeAlt), read_prod_step_time_list,
                                handledWorkCentersList,
                                productionDemandCounters,
                                additionalDataList, timeTypeCode, //productPrimaryUomConversionDataList,
                               // secondaryUnitCategoryConversionList, stdUnitCategoryConversionList,
                                propertyList,
                                ColorTypeList, ColorTypeUNIQUEIDList,
                                BATCHSTANDARDTIME, CUR_PROCESS.WP_BATCHSTANDARDTIME,
                                stepStdQty,
                                routingStepTimeTypeList, operationList,
                                Items,
                                UserGenericGroupTypeList, UserGenericGroupTypeAttributesList,
                                CUR_PRODUCTIONDEMANDTEMPLATE
                                );
        end;
      end;
    end
    else if anyMQMWorkCenterAndOperAttributeFound and (CUR_PRODUCTIONTIMESLEVEL.HANDLE_TIMES_BY = '3') then //Multiplier
    begin
      for i := 0 to CUR_PRODUCTIONTIMESLEVEL.ProductionTimes_List.Count - 1 do
      begin
        if indexConcatinated = -1 then break;

        CUR_PRODUCTIONTIME := CUR_PRODUCTIONTIMESLEVEL.ProductionTimes_List.Items[i];

        if CUR_PRODUCTIONTIME.StrConcatination <> ConcatinatedValue then break;

        if ( (Trim(CUR_PRODUCTIONTIME.RESOURCE_CATEGORY) = '') AND
             (Trim(CUR_PRODUCTIONTIME.RESOURCE) = '')
           ) then
          needToCreateDefaultLine := false;

        if ( getValues(CUR_PRODUCTIONTIMESLEVEL,
                         MQMProductionColumnValues,
                         Items,
                         UserGenericGroupTypeList, UserGenericGroupTypeAttributesList,
                         propertyList,
                         ColorTypeList, ColorTypeUNIQUEIDList,
                         additionalDataList, ConcatinatedValue)
           ) then
        begin
          if ( timeTypeCode = 'B' ) then
          begin
            stepInitialQty := getDoubleFromStr( getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_INITIALBASEPRIMARYQUANTITY', PDS_INITIALBASEPRIMARYQUANTITY) );
            stepStdQty := ConvertUM(MQMProductionColumnValues, CUR_OPERATTRIBUTE.STANDARDSTEPQTYUOMCODE ,getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_BASEPRIMARYUOMCODE', PD_BASEPRIMARYUOMCODE),
                                             StrToFloat(CUR_OPERATTRIBUTE.STANDARDSTEPQUANTITY),
                                             getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ITEMTYPEAFICODE', PD_ITEMTYPEAFICODE),
                                             SUBCODE01, SUBCODE02, SUBCODE03, SUBCODE04, SUBCODE05,
                                             SUBCODE06, SUBCODE07, SUBCODE08, SUBCODE09, SUBCODE10);
            if ( stepStdQty = 0 ) then
            begin

              stepStdQty := ConvertUM(MQMProductionColumnValues, getValueOfTheProductionColumn(MQMProductionColumnValues,  'PDS_STANDARDSTEPQUANTITYUOMCODE', PDS_STANDARDSTEPQUANTITYUOMCODE),
                                             getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_BASEPRIMARYUOMCODE', PD_BASEPRIMARYUOMCODE),
                                             StrToFloat(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_STDPRODUCTIONBATCH', PD_STDPRODUCTIONBATCH)),
                                             ITEMTYPEAFICODE,//getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ITEMTYPEAFICODE'),
                                             SUBCODE01, SUBCODE02, SUBCODE03, SUBCODE04, SUBCODE05,
                                             SUBCODE06, SUBCODE07, SUBCODE08, SUBCODE09, SUBCODE10);
            end;

            if ( stepStdQty = 0 ) then
              stepStdQty := 1;

            quantity := Ceil(stepInitialQty / stepStdQty);
            if BATCHSTANDARDTIME then quantity := 1; // flash
          end
          else
            quantity := 1;

          setupTime := getDoubleFromStr(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_CALCULATEDTIME2', PDS_CALCULATEDTIME2));
          executionTime := getDoubleFromStr(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_CALCULATEDTIME3', PDS_CALCULATEDTIME3));

          setupTime := (setupTime / quantity) * 60 * getDoubleFromStr(CUR_PRODUCTIONTIME.SETUP_TIME_MULTIPLIER);
          executionTime := (executionTime / quantity) * 60 * getDoubleFromStr(CUR_PRODUCTIONTIME.OPERATION_TIME_MULTIPLIER);
          executeTimeAlt := executionTime;

          insertProdStepTime_List(CUR_WORKCENTER, MQMProductionColumnValues, workCenterCode,
                                  operationCode, CUR_PRODUCTIONTIME.RESOURCE_CATEGORY,
                                  CUR_PRODUCTIONTIME.RESOURCE, CUR_PRODUCTIONTIME.OPERATION_TIME_MULTIPLIER, CUR_PRODUCTIONTIME.SETUP_TIME_MULTIPLIER, CUR_PRODUCTIONTIMESLEVEL, FloatToStr(setupTime),
                                  FloatToStr(executionTime), FloatToStr(executeTimeAlt), read_prod_step_time_list,
                                  handledWorkCentersList,
                                  productionDemandCounters,
                                  additionalDataList, timeTypeCode,
                                  propertyList,
                                  ColorTypeList,ColorTypeUNIQUEIDList,
                                  BATCHSTANDARDTIME, CUR_PROCESS.WP_BATCHSTANDARDTIME,
                                  stepStdQty,
                                  routingStepTimeTypeList, operationList,
                                  Items,
                                  UserGenericGroupTypeList, UserGenericGroupTypeAttributesList,
                                  CUR_PRODUCTIONDEMANDTEMPLATE);
        end;
      end;
    end
    else if anyMQMWorkCenterAndOperAttributeFound and (CUR_PRODUCTIONTIMESLEVEL.HANDLE_TIMES_BY = '2') then //Work center operation attribute and multiplier
    begin
      if getValues(CUR_PRODUCTIONTIMESLEVEL,
                         MQMProductionColumnValues,
                         Items,
                         UserGenericGroupTypeList, UserGenericGroupTypeAttributesList,
                         propertyList,
                         ColorTypeList, ColorTypeUNIQUEIDList,
                         additionalDataList, ConcatinatedValue) then

      begin
        indexConcatinated := GetTimeStartingIndex(CUR_PRODUCTIONTIMESLEVEL, ConcatinatedValue);

        if indexConcatinated = -1 then exit;

        for i := indexConcatinated to CUR_PRODUCTIONTIMESLEVEL.ProductionTimes_List.Count - 1 do
        begin
          CUR_PRODUCTIONTIME := CUR_PRODUCTIONTIMESLEVEL.ProductionTimes_List.Items[i];

          if CUR_PRODUCTIONTIME.StrConcatination <> ConcatinatedValue then break;


          AttributeFound := false;
          if CUR_PRODUCTIONTIME.CODE <> '' then
          begin
            for J := 0 to CUR_PROCESS.OperAttributes_List.Count - 1 do
            begin
              CUR_OPERATTRIBUTE := CUR_PROCESS.OperAttributes_List.Items[J];
              if CUR_OPERATTRIBUTE.CODE = CUR_PRODUCTIONTIME.CODE then
              begin
                AttributeFound := true;
                break;
              end;
            end;
            if not AttributeFound then
              CUR_OPERATTRIBUTE := CUR_PROCESS.OperAttributes_List.Items[0];
          end;

          if ( (Trim(CUR_PRODUCTIONTIME.RESOURCE_CATEGORY) = '') AND
               (Trim(CUR_PRODUCTIONTIME.RESOURCE) = '')) then
            needToCreateDefaultLine := false;

         { if ( getValues(CUR_PRODUCTIONTIMESLEVEL,
                           MQMProductionColumnValues,
                           Items,
                           propertyList,
                           ColorTypeList, ColorTypeUNIQUEIDList,
                           additionalDataList, ConcatinatedValue)
             ) then
          begin  }
          setupTime := 0;
          executionTime := 0;
          executeTimeAlt := 0;

          getTimeValue(setupTime, executionTime, 1, CUR_OPERATTRIBUTE,
                       routingStepTimeTypeList, MQMProductionColumnValues, operationList, operationCode, Items, '', '', false);
          getTimeValue(setupTime, executionTime, 2, CUR_OPERATTRIBUTE,
                       routingStepTimeTypeList, MQMProductionColumnValues, operationList, operationCode, Items, '', '', false);
          getTimeValue(setupTime, executionTime, 3, CUR_OPERATTRIBUTE,
                       routingStepTimeTypeList, MQMProductionColumnValues, operationList, operationCode, Items, '', '', false);
          getTimeValue(setupTime, executionTime, 4, CUR_OPERATTRIBUTE,
                       routingStepTimeTypeList, MQMProductionColumnValues, operationList, operationCode, Items, '', '', false);
          getTimeValue(setupTime, executionTime, 5, CUR_OPERATTRIBUTE,
                       routingStepTimeTypeList, MQMProductionColumnValues, operationList, operationCode, Items, '', '', false);

          insertProdStepTime_List(CUR_WORKCENTER, MQMProductionColumnValues, workCenterCode,
                                  operationCode, CUR_PRODUCTIONTIME.RESOURCE_CATEGORY,
                                  CUR_PRODUCTIONTIME.RESOURCE, CUR_PRODUCTIONTIME.OPERATION_TIME_MULTIPLIER, CUR_PRODUCTIONTIME.SETUP_TIME_MULTIPLIER, CUR_PRODUCTIONTIMESLEVEL, FloatToStr(setupTime),
                                  FloatToStr(executionTime), FloatToStr(executeTimeAlt), read_prod_step_time_list,
                                  handledWorkCentersList,
                                  productionDemandCounters,
                                  additionalDataList, timeTypeCode,
                                  propertyList,
                                  ColorTypeList, ColorTypeUNIQUEIDList,
                                  BATCHSTANDARDTIME, CUR_PROCESS.WP_BATCHSTANDARDTIME,
                                  stepStdQty,
                                  routingStepTimeTypeList, operationList,
                                  Items,
                                  UserGenericGroupTypeList, UserGenericGroupTypeAttributesList,
                                  CUR_PRODUCTIONDEMANDTEMPLATE);

        end;
      end;
    end
                      //Eficiency100Percent
    else if  (CUR_PRODUCTIONTIMESLEVEL.HANDLE_TIMES_BY = '4') or
        (CUR_PRODUCTIONTIMESLEVEL.HANDLE_TIMES_BY = '5') then //Take attribue code fromcolumns
    begin
      if (CUR_PRODUCTIONTIMESLEVEL.HANDLE_TIMES_BY = '5') then
        Eficiency100Percent := true
      else
        Eficiency100Percent := false;

      setupTime := 0;
      executionTime := 0;
      executeTimeAlt := 0;

      AttributeFound  := false;
      WcAttributeCode := '';
      if (CUR_PRODUCTIONTIMESLEVEL.TABLENAME1 <> '') or (CUR_PRODUCTIONTIMESLEVEL.COLUMNNAME1 <> '') then
        WcAttributeCode := Trim(GetAColumnValue(CUR_PRODUCTIONTIMESLEVEL, MQMProductionColumnValues, Items, additionalDataList, 1))
      else
        WcAttributeCode := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_WORKCENTERANDOPERATTRIBUTESCOD', PDS_WORKCENTERANDOPERATTRIBUTESCOD));

      if WcAttributeCode <> '' then
      begin
        OverridenTimeOrQty1 := Trim(GetAColumnValue(CUR_PRODUCTIONTIMESLEVEL, MQMProductionColumnValues, Items, additionalDataList, 2));
        OverridenTimeOrQty2 := Trim(GetAColumnValue(CUR_PRODUCTIONTIMESLEVEL, MQMProductionColumnValues, Items, additionalDataList, 3));
        OverridenTimeOrQty3 := Trim(GetAColumnValue(CUR_PRODUCTIONTIMESLEVEL, MQMProductionColumnValues, Items, additionalDataList, 4));
        OverridenTimeOrQty4 := Trim(GetAColumnValue(CUR_PRODUCTIONTIMESLEVEL, MQMProductionColumnValues, Items, additionalDataList, 5));
        OverridenTimeOrQty5 := Trim(GetAColumnValue(CUR_PRODUCTIONTIMESLEVEL, MQMProductionColumnValues, Items, additionalDataList, 6));
        StepRepetition      := Trim(GetAColumnValue(CUR_PRODUCTIONTIMESLEVEL, MQMProductionColumnValues, Items, additionalDataList, 7));

        for J := 0 to CUR_PROCESS.OperAttributes_List.Count - 1 do
        begin
          CUR_OPERATTRIBUTE := CUR_PROCESS.OperAttributes_List.Items[J];
          if CUR_OPERATTRIBUTE.CODE = WcAttributeCode then
          begin
            AttributeFound := true;
            break;
          end;
        end;

        if AttributeFound then
        begin
          getTimeValue(setupTime, executionTime, 1, CUR_OPERATTRIBUTE,
                       routingStepTimeTypeList, MQMProductionColumnValues, operationList, operationCode, Items, OverridenTimeOrQty1, StepRepetition, Eficiency100Percent);
          getTimeValue(setupTime, executionTime, 2, CUR_OPERATTRIBUTE,
                       routingStepTimeTypeList, MQMProductionColumnValues, operationList, operationCode, Items, OverridenTimeOrQty2, StepRepetition, Eficiency100Percent);
          getTimeValue(setupTime, executionTime, 3, CUR_OPERATTRIBUTE,
                       routingStepTimeTypeList, MQMProductionColumnValues, operationList, operationCode, Items, OverridenTimeOrQty3, StepRepetition, Eficiency100Percent);
          getTimeValue(setupTime, executionTime, 4, CUR_OPERATTRIBUTE,
                       routingStepTimeTypeList, MQMProductionColumnValues, operationList, operationCode, Items, OverridenTimeOrQty4, StepRepetition, Eficiency100Percent);
          getTimeValue(setupTime, executionTime, 5, CUR_OPERATTRIBUTE,
                       routingStepTimeTypeList, MQMProductionColumnValues, operationList, operationCode, Items, OverridenTimeOrQty5, StepRepetition, Eficiency100Percent);

          insertProdStepTime_List(CUR_WORKCENTER, MQMProductionColumnValues, workCenterCode,
                                  operationCode, '', '', '1', '1', CUR_PRODUCTIONTIMESLEVEL, FloatToStr(setupTime),
                                  FloatToStr(executionTime), FloatToStr(executeTimeAlt), read_prod_step_time_list,
                                  handledWorkCentersList,
                                  productionDemandCounters,
                                  additionalDataList, timeTypeCode,
                                  propertyList,
                                  ColorTypeList, ColorTypeUNIQUEIDList,
                                  BATCHSTANDARDTIME, CUR_PROCESS.WP_BATCHSTANDARDTIME,
                                  stepStdQty,
                                  routingStepTimeTypeList, operationList,
                                  Items,
                                  UserGenericGroupTypeList, UserGenericGroupTypeAttributesList,
                                  CUR_PRODUCTIONDEMANDTEMPLATE);
          needToCreateDefaultLine := false;
        end;
      end;
    end
  end;

  Result := executionTime;

  if needToCreateDefaultLine then
  begin
    if ( timeTypeCode = 'B' ) then
    begin
      if BATCHSTANDARDTIME then
      begin
        quantity := 1;
      end
      else
      begin
        stepInitialQty := getDoubleFromStr( getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_INITIALBASEPRIMARYQUANTITY', PDS_INITIALBASEPRIMARYQUANTITY) );

        stepStdQty := ConvertUM(MQMProductionColumnValues, getValueOfTheProductionColumn(MQMProductionColumnValues,  'PDS_STANDARDSTEPQUANTITYUOMCODE', PDS_STANDARDSTEPQUANTITYUOMCODE),
                                getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_BASEPRIMARYUOMCODE', PD_BASEPRIMARYUOMCODE),
                                StrToFloat(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_STANDARDSTEPQUANTITY', PDS_STANDARDSTEPQUANTITY)),
                                ITEMTYPEAFICODE,
                                SUBCODE01, SUBCODE02, SUBCODE03, SUBCODE04, SUBCODE05,
                                SUBCODE06, SUBCODE07, SUBCODE08, SUBCODE09, SUBCODE10);
        if ( stepStdQty = 0 ) then
          stepStdQty := 1;
        quantity := Ceil(stepInitialQty / stepStdQty);

        if (quantity = 0) then
          quantity := 1;

      end;

    end
    else
    begin
      quantity := 1;
    end;

    setupTime := getDoubleFromStr(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_CALCULATEDTIME2', PDS_CALCULATEDTIME2));
    executionTime := getDoubleFromStr(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_CALCULATEDTIME3', PDS_CALCULATEDTIME3));

    setupTime := (setupTime / quantity) * 60;
    executionTime := (executionTime / quantity) * 60;
    executeTimeAlt := executionTime;

    WP_BATCHSTANDARDTIME := '';
    if assigned(CUR_PROCESS) then
    begin
      try
        WP_BATCHSTANDARDTIME := CUR_PROCESS.WP_BATCHSTANDARDTIME
      except
      end;
    end;

    insertProdStepTime_List(CUR_WORKCENTER, MQMProductionColumnValues,
                            getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_WORKCENTERCODE', PDS_WORKCENTERCODE),
                            getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_OPERATIONCODE', PDS_OPERATIONCODE),
                            '', '', '', '',nil, FloatToStr(setupTime), FloatToStr(executionTime), FloatToStr(executeTimeAlt),
                            read_prod_step_time_list, handledWorkCentersList,
                            productionDemandCounters,
                            additionalDataList, timeTypeCode,
                            propertyList,
                            ColorTypeList, ColorTypeUNIQUEIDList,
                            BATCHSTANDARDTIME, WP_BATCHSTANDARDTIME,
                            stepStdQty,
                            routingStepTimeTypeList, operationList,
                            Items,
                            UserGenericGroupTypeList, UserGenericGroupTypeAttributesList,
                            CUR_PRODUCTIONDEMANDTEMPLATE);
  end;
end;

//----------------------------------------------------------------------------//

function GetAColumnValue(CUR_PRODUCTIONTIMESLEVEL: PPRODUCTIONTIMESLEVELS;
                     MQMProductionColumnValues: PMQMProductionColumnValues;
                     Items : PTItems;
                     additionalDataList: TList; ColumnNumber : integer
                     ): String;
var
  valueOf: String;
  CUR_ADDITIONALDATA_HEADER: PADDITIONALDATA_HEADERS;
  searchValue, TableName, ColumnName : String;
  index, IndexTemp : integer;

  P_ABSUNIQUEID, FIKD_ABSUNIQUEID : string;
  SUBCODE01, SUBCODE02, SUBCODE03, SUBCODE04, SUBCODE05,
  SUBCODE06, SUBCODE07, SUBCODE08, SUBCODE09, SUBCODE10 : string;
  GenericProject : PRGeneric;
  pds_uniqueId, pd_uniqueId, ProjectCode : string;
begin
  TableName := '';
  ColumnName := '';
  Result := '';
  case ColumnNumber of
    1: begin
         TableName := Trim(CUR_PRODUCTIONTIMESLEVEL.TABLENAME1);
         ColumnName := Trim(CUR_PRODUCTIONTIMESLEVEL.COLUMNNAME1);
       end;
    2: begin
         TableName := Trim(CUR_PRODUCTIONTIMESLEVEL.TABLENAME2);
         ColumnName := Trim(CUR_PRODUCTIONTIMESLEVEL.COLUMNNAME2);
       end;
    3: begin
         TableName := Trim(CUR_PRODUCTIONTIMESLEVEL.TABLENAME3);
         ColumnName := Trim(CUR_PRODUCTIONTIMESLEVEL.COLUMNNAME3);
       end;
    4: begin
         TableName := Trim(CUR_PRODUCTIONTIMESLEVEL.TABLENAME4);
         ColumnName := Trim(CUR_PRODUCTIONTIMESLEVEL.COLUMNNAME4);
       end;
    5: begin
         TableName := Trim(CUR_PRODUCTIONTIMESLEVEL.TABLENAME5);
         ColumnName := Trim(CUR_PRODUCTIONTIMESLEVEL.COLUMNNAME5);
       end;
    6: begin
         TableName := Trim(CUR_PRODUCTIONTIMESLEVEL.TABLENAME6);
         ColumnName := Trim(CUR_PRODUCTIONTIMESLEVEL.COLUMNNAME6);
       end;
    7: begin
         TableName := Trim(CUR_PRODUCTIONTIMESLEVEL.TABLENAME7);
         ColumnName := Trim(CUR_PRODUCTIONTIMESLEVEL.COLUMNNAME7);
       end;

  end;
  if TableName = '' then exit;

  if assigned(Items) then
  begin
    FIKD_ABSUNIQUEID := Items.ABSUNIQUEID;
    P_ABSUNIQUEID    := Items.ABSUNIQUEID_P;
    SUBCODE01 := Items.SUBCODE01;
    SUBCODE02 := Items.SUBCODE02;
    SUBCODE03 := Items.SUBCODE03;
    SUBCODE04 := Items.SUBCODE04;
    SUBCODE05 := Items.SUBCODE05;
    SUBCODE06 := Items.SUBCODE06;
    SUBCODE07 := Items.SUBCODE07;
    SUBCODE08 := Items.SUBCODE08;
    SUBCODE09 := Items.SUBCODE09;
    SUBCODE10 := Items.SUBCODE10;
  end;

  if (TableName = 'Product AD') then
  begin
    searchValue := P_ABSUNIQUEID;
    index := searchInList(additionalDataList, 8, searchValue,
                        0, additionalDataList.Count - 1);
    if (index <> -1) then
    begin
      CUR_ADDITIONALDATA_HEADER := additionalDataList.Items[index];
      IndexTemp := searchInList(CUR_ADDITIONALDATA_HEADER.productADList, 9, ColumnName, 0,
                          CUR_ADDITIONALDATA_HEADER.productADList.Count - 1);
      if (IndexTemp <> -1) then
        Result := PADDITIONALDATA_DETAILS(CUR_ADDITIONALDATA_HEADER.productADList.Items[IndexTemp]).VALUE;
    end;
    exit;
  end;

  if (TableName = 'Project AD') then
  begin
    if trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_PROJECTCODE', PD_PROJECTCODE)) <> '' then
    begin
      ProjectCode := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_PROJECTCODE', PD_PROJECTCODE);
      GenericProject := FindGenericBinarSearch(List_Generic, 'Project', ProjectCode, 0, 0, 0, 0, 0);
      if Assigned(GenericProject) then
        index := searchInList(additionalDataList, 8, GenericProject.ABSUniqueId, 0, additionalDataList.Count - 1);
    end;

    if index <> -1 then
    begin
      CUR_ADDITIONALDATA_HEADER := additionalDataList.Items[index];
      IndexTemp := searchInList(CUR_ADDITIONALDATA_HEADER.ProjectADList, 9, ColumnName, 0, CUR_ADDITIONALDATA_HEADER.projectADList.Count - 1);
      if (IndexTemp <> -1) then
        Result := PADDITIONALDATA_DETAILS(CUR_ADDITIONALDATA_HEADER.ProjectADList.Items[IndexTemp]).VALUE;
    end;
    exit;
  end;

  if (TableName = 'FullItemKeyDecoder AD') then
  begin
    searchValue := FIKD_ABSUNIQUEID;
    index := searchInList(additionalDataList, 8, searchValue,
                        0, additionalDataList.Count - 1);
    if (index <> -1) then
    begin
      CUR_ADDITIONALDATA_HEADER := additionalDataList.Items[index];
      IndexTemp := searchInList(CUR_ADDITIONALDATA_HEADER.fullItemKeyDecoderADList, 9, ColumnName, 0,
                          CUR_ADDITIONALDATA_HEADER.fullItemKeyDecoderADList.Count - 1);
      if (IndexTemp <> -1) then
        Result := PADDITIONALDATA_DETAILS(CUR_ADDITIONALDATA_HEADER.fullItemKeyDecoderADList.Items[IndexTemp]).VALUE;
    end;
    exit;
  end;

  if (TableName = 'ProductionDemand AD') then
  begin
    pd_uniqueId := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ABSUNIQUEID', PD_ABSUNIQUEID);
    searchValue := pd_uniqueId;
    index := searchInList(additionalDataList, 8, searchValue,
                        0, additionalDataList.Count - 1);
    if (index <> -1) then
    begin
      CUR_ADDITIONALDATA_HEADER := additionalDataList.Items[index];
      IndexTemp := searchInList(CUR_ADDITIONALDATA_HEADER.productionDemandADList, 9, ColumnName, 0,
                          CUR_ADDITIONALDATA_HEADER.productionDemandADList.Count - 1);
      if (IndexTemp <> -1) then
        Result := PADDITIONALDATA_DETAILS(CUR_ADDITIONALDATA_HEADER.productionDemandADList.Items[IndexTemp]).VALUE;
    end;
    exit;
  end;

  if (TableName = 'ProductionDemandStep AD') then
  begin
    pds_uniqueId := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_ABSUNIQUEID', PDS_ABSUNIQUEID);

    searchValue := pds_uniqueId;
    index := searchInList(additionalDataList, 8, searchValue,
                        0, additionalDataList.Count - 1);
    if (index <> -1) then
    begin
      CUR_ADDITIONALDATA_HEADER := additionalDataList.Items[index];
      IndexTemp := searchInList(CUR_ADDITIONALDATA_HEADER.productionDemandStepADList, 9, ColumnName, 0,
                          CUR_ADDITIONALDATA_HEADER.productionDemandStepADList.Count - 1);
      if (IndexTemp <> -1) then
        Result := PADDITIONALDATA_DETAILS(CUR_ADDITIONALDATA_HEADER.productionDemandStepADList.Items[IndexTemp]).VALUE;
    end;
    exit;
  end;

  if (TableName = 'PRODUCTIONDEMANDSTEP') then
  begin
    Result := getValueOfTheProductionColumnByFindPos(MQMProductionColumnValues, 'PDS_' + Trim(columnName));
    exit;
  end;

  if (TableName = 'PRODUCT') then
  begin
    valueOf := copy('P_' + ColumnName, 1, 30);
    IndexTemp := Items.productColumnNames.IndexOf(valueOf);
    if (IndexTemp <> -1) then
      result := trim(Items.ProductColumnValue.Strings[IndexTemp]);
    exit;
  end;

  if (TableName = 'PRODUCTSPECIALIZEDGREIGE') then
  begin
    valueOf := copy('PSG_' + ColumnName, 1, 30);
    if Items.ProductSpecializedGreigeColumn_created then
      IndexTemp := Items.productSpecializedGreigeColumnNames.IndexOf(valueOf)
    else
      IndexTemp := -1;
    if (IndexTemp <> -1) then
      result := trim(Items.ProductSpecializedGreigeColumnValue.Strings[IndexTemp]);
    exit;
  end;
  if (TableName = 'PRODUCTSPECIALIZEDSIZE') then
  begin
    valueOf := copy('PSS_' + ColumnName, 1, 30);
    if Items.ProductSpecializedSizeColumn_created then
      IndexTemp := Items.productSpecializedSizeColumnNames.IndexOf(valueOf)
    else
      IndexTemp := -1;
    if (IndexTemp <> -1) then
      result := trim(Items.ProductSpecializedSizeColumnValue.Strings[IndexTemp]);
    exit;
  end;
  if (TableName = 'PRODUCTSPECIALIZEDYARN') then
  begin
    valueOf := copy('PSY_' + ColumnName, 1, 30);
    if Items.ProductSpecializedYarnColumn_created then
      IndexTemp := Items.productSpecializedYarnColumnNames.IndexOf(valueOf)
    else
      IndexTemp := -1;
    if (IndexTemp <> -1) then
      result := trim(Items.ProductSpecializedYarnColumnValue.Strings[IndexTemp]);
    exit;
  end;
  if (TableName = 'FULLITEMKEYDECODER') then
  begin
   // if (index <> -1) then
   // begin
    valueOf := copy('FIKD_' + ColumnName, 1, 30);
    IndexTemp := Items.FullItemKeyDecoderColumnNames.IndexOf(valueOf);
    if (IndexTemp <> -1) then
      result := trim(Items.FullItemKeyDecoderColumnValue.Strings[IndexTemp]);
   // end;
    exit;
  end;
  valueOf := getTablePrefix(TableName) + '_' + ColumnName;
  result := Trim(getValueOfTheProductionColumnByFindPos(MQMProductionColumnValues, valueOf));
end;

//------------------------------------------------------------------------------------------------------------------------------

function getValues(CUR_PRODUCTIONTIMESLEVEL: PPRODUCTIONTIMESLEVELS;
                     MQMProductionColumnValues: PMQMProductionColumnValues;
                     Items : PTItems;
                     UserGenericGroupTypeList, UserGenericGroupTypeAttributesList : TList;
                     propertyList : TList;
                     ColorTypeList: TList;
                     ColorTypeUNIQUEIDList : TList;
                     additionalDataList: TList;
                     var ConcatinatedStr : String): boolean;
var
  PD_SUBCODE, itemType, GenericGroupCodeType, ABSUniqueId, SUBCODEVALUE : string;
  SUBCODENR : integer;
  valueOf, SUBCODE: String;
  tableNames: array[0..9] of string;
  columnNames: array[0..9] of string;
  i: Integer;
  CUR_ADDITIONALDATA_HEADER: PADDITIONALDATA_HEADERS;
  searchValue: String;
  index, IndexTemp, IndexProduct, IndexFullItemKD  : integer;

  P_ABSUNIQUEID, FIKD_ABSUNIQUEID, ValueAD : string;
  SUBCODE01, SUBCODE02, SUBCODE03, SUBCODE04, SUBCODE05,
  SUBCODE06, SUBCODE07, SUBCODE08, SUBCODE09, SUBCODE10 : string;
  CUR_ADDITIONALDATA_DETAIL: PADDITIONALDATA_DETAILS;
begin

  if assigned(Items) then
  begin
    FIKD_ABSUNIQUEID := Items.ABSUNIQUEID;
    P_ABSUNIQUEID    := Items.ABSUNIQUEID_P;
    SUBCODE01 := Items.SUBCODE01;
    SUBCODE02 := Items.SUBCODE02;
    SUBCODE03 := Items.SUBCODE03;
    SUBCODE04 := Items.SUBCODE04;
    SUBCODE05 := Items.SUBCODE05;
    SUBCODE06 := Items.SUBCODE06;
    SUBCODE07 := Items.SUBCODE07;
    SUBCODE08 := Items.SUBCODE08;
    SUBCODE09 := Items.SUBCODE09;
    SUBCODE10 := Items.SUBCODE10;
  end;

  tableNames[0] := Trim(CUR_PRODUCTIONTIMESLEVEL.TABLENAME1);
  tableNames[1] := Trim(CUR_PRODUCTIONTIMESLEVEL.TABLENAME2);
  tableNames[2] := Trim(CUR_PRODUCTIONTIMESLEVEL.TABLENAME3);
  tableNames[3] := Trim(CUR_PRODUCTIONTIMESLEVEL.TABLENAME4);
  tableNames[4] := Trim(CUR_PRODUCTIONTIMESLEVEL.TABLENAME5);
  tableNames[5] := Trim(CUR_PRODUCTIONTIMESLEVEL.TABLENAME6);
  tableNames[6] := Trim(CUR_PRODUCTIONTIMESLEVEL.TABLENAME7);
  tableNames[7] := Trim(CUR_PRODUCTIONTIMESLEVEL.TABLENAME8);
  tableNames[8] := Trim(CUR_PRODUCTIONTIMESLEVEL.TABLENAME9);
  tableNames[9] := Trim(CUR_PRODUCTIONTIMESLEVEL.TABLENAME10);

  columnNames[0] := Trim(CUR_PRODUCTIONTIMESLEVEL.COLUMNNAME1);
  columnNames[1] := Trim(CUR_PRODUCTIONTIMESLEVEL.COLUMNNAME2);
  columnNames[2] := Trim(CUR_PRODUCTIONTIMESLEVEL.COLUMNNAME3);
  columnNames[3] := Trim(CUR_PRODUCTIONTIMESLEVEL.COLUMNNAME4);
  columnNames[4] := Trim(CUR_PRODUCTIONTIMESLEVEL.COLUMNNAME5);
  columnNames[5] := Trim(CUR_PRODUCTIONTIMESLEVEL.COLUMNNAME6);
  columnNames[6] := Trim(CUR_PRODUCTIONTIMESLEVEL.COLUMNNAME7);
  columnNames[7] := Trim(CUR_PRODUCTIONTIMESLEVEL.COLUMNNAME8);
  columnNames[8] := Trim(CUR_PRODUCTIONTIMESLEVEL.COLUMNNAME9);
  columnNames[9] := Trim(CUR_PRODUCTIONTIMESLEVEL.COLUMNNAME10);

  ConcatinatedStr := '';
  result := true;

  searchValue := P_ABSUNIQUEID;//getValueOfTheProductionColumn(MQMProductionColumnValues, 'P_ABSUNIQUEID');

  index := searchInList(additionalDataList, 8, searchValue,
                        0, additionalDataList.Count - 1);

  for i := 0 to 9 do
  begin
    if ((tableNames[i] <> '') and
        (columnNames[i] <> '')) then
    begin

      if ( tableNames[i] = 'Product AD') then
      begin

        if (index = -1) then
        begin
          result := false;
          exit;
        end;

        CUR_ADDITIONALDATA_HEADER := additionalDataList.Items[index];
        if (not GetValueOfAdditionalData(CUR_ADDITIONALDATA_HEADER.productADList,
                                              columnNames[i], ValueAD)) then
        begin
          result := false;
          exit;
        end;

        if ConcatinatedStr <> '' then
          ConcatinatedStr := ConcatinatedStr + '||';
        ConcatinatedStr := ConcatinatedStr + ValueAD;

      end

      else if ( tableNames[i] = 'FullItemKeyDecoder AD') then
      begin
        if (index = -1) then
        begin
          result := false;
          exit;
        end;
        CUR_ADDITIONALDATA_HEADER := additionalDataList.Items[index];
        if ( not GetValueOfAdditionalData(CUR_ADDITIONALDATA_HEADER.fullItemKeyDecoderADList,
                                            columnNames[i], ValueAD)) then
        begin
          result := false;
          exit;
        end;

        if ConcatinatedStr <> '' then
          ConcatinatedStr := ConcatinatedStr + '||';
        ConcatinatedStr := ConcatinatedStr + ValueAD;

      end
      else if ( tableNames[i] = 'ProductionDemand AD') then
      begin
        if (index = -1) then
        begin
          result := false;
          exit;
        end;

        CUR_ADDITIONALDATA_HEADER := additionalDataList.Items[index];
        if ( not GetValueOfAdditionalData(CUR_ADDITIONALDATA_HEADER.productionDemandADList,
                                              columnNames[i], ValueAD)) then
        begin
          result := false;
          exit;
        end;

        if ConcatinatedStr <> '' then
          ConcatinatedStr := ConcatinatedStr + '||';
        ConcatinatedStr := ConcatinatedStr + ValueAD;

      end
      else if ( tableNames[i] = 'ProductionDemandStep AD') then
      begin
        if (index = -1) then
        begin
          result := false;
          exit;
        end;

        CUR_ADDITIONALDATA_HEADER := additionalDataList.Items[index];
        if ( not GetValueOfAdditionalData(CUR_ADDITIONALDATA_HEADER.productionDemandStepADList,
                                              columnNames[i], ValueAD)) then
        begin
          result := false;
          break;
        end;

        if ConcatinatedStr <> '' then
          ConcatinatedStr := ConcatinatedStr + '||';
        ConcatinatedStr := ConcatinatedStr + ValueAD;

      end
      else if ( tableNames[i] = 'PRODUCT') then
      begin
        valueOf := copy('P_' + columnNames[i], 1, 30);
        IndexProduct := Items.productColumnNames.IndexOf(valueOf);
        if IndexProduct = -1 then
        begin
          Result := false;
          exit
        end;

        if ConcatinatedStr <> '' then
          ConcatinatedStr := ConcatinatedStr + '||';
        ConcatinatedStr := ConcatinatedStr + trim(Items.ProductColumnValue.Strings[IndexProduct]);

      end
      else if ( tableNames[i] = 'PRODUCTSPECIALIZEDGREIGE') then
      begin
        valueOf := copy('PSG_' + columnNames[i], 1, 30);
        if Items.ProductSpecializedGreigeColumn_created then
          IndexProduct := Items.productSpecializedGreigeColumnNames.IndexOf(valueOf)
        else
          IndexProduct := -1;

        if IndexProduct = -1 then
        begin
          Result := false;
          exit
        end;

        if ConcatinatedStr <> '' then
          ConcatinatedStr := ConcatinatedStr + '||';
        ConcatinatedStr := ConcatinatedStr + trim(Items.ProductSpecializedGreigeColumnValue.Strings[IndexProduct]);
      end
      else if ( tableNames[i] = 'PRODUCTSPECIALIZEDSIZE') then
      begin
        valueOf := copy('PSS_' + columnNames[i], 1, 30);
        if Items.ProductSpecializedSizeColumn_created then
          IndexProduct := Items.productSpecializedSizeColumnNames.IndexOf(valueOf)
        else
          IndexProduct := -1;

        if IndexProduct = -1 then
        begin
          Result := false;
          exit
        end;

        if ConcatinatedStr <> '' then
          ConcatinatedStr := ConcatinatedStr + '||';
        ConcatinatedStr := ConcatinatedStr + trim(Items.ProductSpecializedSizeColumnValue.Strings[IndexProduct])

      end
      else if ( tableNames[i] = 'PRODUCTSPECIALIZEDYARN') then
      begin
        valueOf := copy('PSY_' + columnNames[i], 1, 30);
        if Items.ProductSpecializedYarnColumn_created then
          IndexProduct := Items.productSpecializedYarnColumnNames.IndexOf(valueOf)
        else
          IndexProduct := -1;

        if IndexProduct = -1 then
        begin
          Result := false;
          exit
        end;

        if ConcatinatedStr <> '' then
          ConcatinatedStr := ConcatinatedStr + '||';
        ConcatinatedStr := ConcatinatedStr + trim(Items.ProductSpecializedYarnColumnValue.Strings[IndexProduct])

      end
      else if ( tableNames[i] = 'FULLITEMKEYDECODER') then
      begin
        valueOf := copy('FIKD_' + columnNames[i], 1, 30);
        IndexFullItemKD := Items.FullItemKeyDecoderColumnNames.IndexOf(valueOf);

        if IndexFullItemKD = -1 then
        begin
          Result := false;
          exit
        end;

        if ConcatinatedStr <> '' then
          ConcatinatedStr := ConcatinatedStr + '||';
        ConcatinatedStr := ConcatinatedStr + trim(Items.FullItemKeyDecoderColumnValue.Strings[IndexFullItemKD])
      end

      else if (copy(tableNames[i], 1, 8) = 'Color AD') then
      begin

        SUBCODE := copy(tableNames[i], 17, 2);
        index := GetIndexForColorTable(SUBCODE, MQMProductionColumnValues, additionalDataList, ColorTypeList, ColorTypeUNIQUEIDList);

        if (index = -1) then
        begin
          result := false;
          exit;
        end;

        CUR_ADDITIONALDATA_HEADER := additionalDataList.Items[index];
        if ( not GetValueOfAdditionalData(CUR_ADDITIONALDATA_HEADER.ColorADList,
                                            columnNames[i], ValueAD)) then
        begin
          result := false;
          break;
        end;

        if ConcatinatedStr <> '' then
          ConcatinatedStr := ConcatinatedStr + '||';
        ConcatinatedStr := ConcatinatedStr + ValueAD;

      end

      else if (copy(tableNames[i], 1, 19) = 'UserGenericGroup AD') then
      begin

        SUBCODE := copy(tableNames[i], 28, 2);
        index := GetIndexForUserGenericGroupTable(SUBCODE, MQMProductionColumnValues, additionalDataList, UserGenericGroupTypeList, UserGenericGroupTypeAttributesList);

        if (index = -1) then
        begin
          result := false;
          exit;
        end;

        CUR_ADDITIONALDATA_HEADER := additionalDataList.Items[index];
        if ( not GetValueOfAdditionalData(CUR_ADDITIONALDATA_HEADER.UserGenericGroupADList,
                                            columnNames[i], ValueAD)) then
        begin
          result := false;
          break;
        end;

        if ConcatinatedStr <> '' then
          ConcatinatedStr := ConcatinatedStr + '||';
        ConcatinatedStr := ConcatinatedStr + ValueAD;

      end

      else
      begin
        valueOf := getTablePrefix(tableNames[i]) + '_' + columnNames[i];

        if ConcatinatedStr <> '' then
          ConcatinatedStr := ConcatinatedStr + '||';
        ConcatinatedStr := ConcatinatedStr + Trim(getValueOfTheProductionColumnByFindPos(MQMProductionColumnValues, valueOf));

      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

function GetTimeStartingIndex(CUR_PRODUCTIONTIMESLEVEL: PPRODUCTIONTIMESLEVELS; str : string) : integer;
var
  i: integer;
  Multiplier, NumberOfEntries, NumberOfKeys : integer;
  List : Tlist;
begin
  Result := -1;
  NumberOfEntries := CUR_PRODUCTIONTIMESLEVEL.ProductionTimes_List.Count;
  if NumberOfEntries = 0 then exit;
  List := CUR_PRODUCTIONTIMESLEVEL.ProductionTimes_List;

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

    if (PPRODUCTIONTIMES(List[i]).StrConcatination < str) then
    begin
      i := i + Multiplier;
      continue;
    end;
    if (PPRODUCTIONTIMES(List[i]).StrConcatination > str) then
    begin
      i := i - Multiplier;
      continue;
    end;

    Result := i;
    break;

  end;

  while (result > 0) do
  begin
    if PPRODUCTIONTIMES(List[result - 1]).StrConcatination = str then
      dec(result)
    else
      break;
  end;

end;

//----------------------------------------------------------------------------//

function GetValueOfAdditionalData(listOfAdditionalData: TList;
                                    columnName: String; var value : string): boolean;
var
  CUR_ADDITIONALDATA_DETAIL: PADDITIONALDATA_DETAILS;
  index: integer;
begin
  Result := false;

  index := searchInList(listOfAdditionalData, 9, columnName, 0,
                        listOfAdditionalData.Count - 1);
  if (index <> -1) then
  begin
    CUR_ADDITIONALDATA_DETAIL := listOfAdditionalData.Items[index];

    value := trim(CUR_ADDITIONALDATA_DETAIL.VALUE);

    Result := true;
  end;
end;

//----------------------------------------------------------------------------//

function getTablePrefix(tableName: String): String;
begin
  if ( tableName = 'PRODUCTIONDEMAND') then
    Result := 'PD'
  else if ( tableName = 'PRODUCTIONDEMANDSTEP') then
    Result := 'PDS'
  else if ( tableName = 'FULLITEMKEYDECODER') then
    Result := 'FIKD'
  else if ( tableName = 'PRODUCT') then
    Result := 'P';
end;

//----------------------------------------------------------------------------//

procedure insertProdStepTime_List(WORKCENTER: PWORKCENTERS;  MQMProductionColumnValues: PMQMProductionColumnValues;
                                  workCenterCode: String; operation: String;
                                  resourceCategory: String; resource: String;
                                  OPERATION_TIME_MULTIPLIER : string;
                                  SETUP_TIME_MULTIPLIER : string;
                                  CUR_PRODUCTIONTIMESLEVEL: PPRODUCTIONTIMESLEVELS;
                                  setupTime: String; executeTime: String; executeTimeAlt : String;
                                  read_prod_step_time_list: TList;
                                  handledWorkCentersList: TList;
                                  productionDemandCounters : TList;
                                  additionalDataList: TList;
                    							timeTypeCode: String;
                                  propertyList  : TList;
                                  ColorTypeList : TList;
                                  ColorTypeUNIQUEIDList : TList;
                     							//productPrimaryUomConversionDataList: TList;
                                  //secondaryUnitCategoryConversionList: TList;
                                  //stdUnitCategoryConversionList: TList;
                                  BATCHSTANDARDTIME : boolean; WC_BATCHSTANDARDTIME : string;
                                  stepStdQtyValue : double;
                                  routingStepTimeTypeList: TList;
                                 	operationList: TList;
                                  Items : PTItems;
                                  UserGenericGroupTypeList, UserGenericGroupTypeAttributesList : TList;
                                  CUR_PRODUCTIONDEMANDTEMPLATE: PPRODUCTIONDEMANDTEMPLATES
                                 );
var
  NEW_PROD_STEP_TIME: PTMQMST;
  PREQ_NO : string;
  i: Integer;
  index: Integer;
  CUR_PROCESS: PPROCESSES;
  quantity: integer;
  stepInitialQty: double;
  stepStdQty: double;
  SetupTimeStep, executionTimeStep : double;
  P_ABSUNIQUEID, FIKD_ABSUNIQUEID, ITEMTYPEAFICODE : string;
  SUBCODE01, SUBCODE02, SUBCODE03, SUBCODE04, SUBCODE05,
  SUBCODE06, SUBCODE07, SUBCODE08, SUBCODE09, SUBCODE10 : string;
  TempExt : Extended;
  S : string;
  AlternativeWorkCenterCode : String;
begin
  if assigned(Items) then
  begin
    FIKD_ABSUNIQUEID := Items.ABSUNIQUEID;
    P_ABSUNIQUEID    := Items.ABSUNIQUEID_P;
    ITEMTYPEAFICODE  := Items.ITEMTYPEAFICODE;
    SUBCODE01 := Items.SUBCODE01;
    SUBCODE02 := Items.SUBCODE02;
    SUBCODE03 := Items.SUBCODE03;
    SUBCODE04 := Items.SUBCODE04;
    SUBCODE05 := Items.SUBCODE05;
    SUBCODE06 := Items.SUBCODE06;
    SUBCODE07 := Items.SUBCODE07;
    SUBCODE08 := Items.SUBCODE08;
    SUBCODE09 := Items.SUBCODE09;
    SUBCODE10 := Items.SUBCODE10;
  end;

  if ( Trim(setupTime) = '' ) then
    setupTime := '0';

  if ( Trim(executeTime) = '' ) then
    executeTime := '0';

  New(NEW_PROD_STEP_TIME);
  NEW_PROD_STEP_TIME.ST_PREQ_NO := setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COMPANYCODE', PD_COMPANYCODE), 3) +
                                   setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COUNTERCODE', PD_COUNTERCODE), 8) +
                                   getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_CODE', PD_CODE);
  NEW_PROD_STEP_TIME.ST_PSTEP_ID := StrToInt(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_STEPNUMBER', PDS_STEPNUMBER));
  NEW_PROD_STEP_TIME.ST_WKCNTER := trim(workCenterCode);
  NEW_PROD_STEP_TIME.ST_WKCT_PROC := Trim(operation);
  NEW_PROD_STEP_TIME.ST_RES_CATEGORY := Trim(resourceCategory);
  NEW_PROD_STEP_TIME.ST_RSC_CODE := Trim(resource);
  NEW_PROD_STEP_TIME.ST_SETUP_TIME_Mechin_Code := '';
  NEW_PROD_STEP_TIME.ST_timeTypeCode := timeTypeCode;
  NEW_PROD_STEP_TIME.ST_TimeArriveFromNowStep := false;

  if (NEW_PROD_STEP_TIME.ST_timeTypeCode = 'B') OR (NEW_PROD_STEP_TIME.ST_timeTypeCode = 'P') then
  begin
    NEW_PROD_STEP_TIME.ST_ProductionOrderCode := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_PRODUCTIONORDERCODE', PDS_PRODUCTIONORDERCODE);
    NEW_PROD_STEP_TIME.ST_BatchTimeType := WC_BATCHSTANDARDTIME;
    NEW_PROD_STEP_TIME.ST_GroupStepNumber := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_GROUPSTEPNUMBER', PDS_GROUPSTEPNUMBER);
    NEW_PROD_STEP_TIME.ST_CalcTime2 := StrToFloat(getNumericValueOf(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_CALCULATEDTIME2', PDS_CALCULATEDTIME2)));
    NEW_PROD_STEP_TIME.ST_CalcTime3 := StrToFloat(getNumericValueOf(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_CALCULATEDTIME3', PDS_CALCULATEDTIME3)));
    NEW_PROD_STEP_TIME.ST_INITIALBASEPRIMARYQUANTITY := StrToFloat(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_INITIALBASEPRIMARYQUANTITY', PDS_INITIALBASEPRIMARYQUANTITY));
    NEW_PROD_STEP_TIME.ST_STANDARDSTEPQUANTITY       := stepStdQtyValue;
    if CUR_PRODUCTIONTIMESLEVEL = nil then
    begin
      NEW_PROD_STEP_TIME.ST_multiplierExecution := 1;
      NEW_PROD_STEP_TIME.ST_multiplierSetUp := 1;
      NEW_PROD_STEP_TIME.ST_TimeArriveFromNowStep := true;
    end
    else if CUR_PRODUCTIONTIMESLEVEL.HANDLE_TIMES_BY <> '3' then
    begin
      NEW_PROD_STEP_TIME.ST_multiplierExecution := 0;
      NEW_PROD_STEP_TIME.ST_multiplierSetUp := 0;
    end
    else
    begin
      NEW_PROD_STEP_TIME.ST_multiplierExecution := getDoubleFromStr(OPERATION_TIME_MULTIPLIER);
      NEW_PROD_STEP_TIME.ST_multiplierSetUp := getDoubleFromStr(SETUP_TIME_MULTIPLIER);
      NEW_PROD_STEP_TIME.ST_TimeArriveFromNowStep := true;
    end;
  end;

  TempExt := Frac(StrToFloat(setupTime));
  S := FloatToStr(TempExt);
  if Length(S) > 5 then
  begin
    S := Copy(s, 2, 4);
    setupTime := FloatToStr(trunc(StrToFloat(setupTime)));
    setupTime := setupTime + s;
  end;

  TempExt := Frac(StrToFloat(executeTime));
  S := FloatToStr(TempExt);
  if Length(S) > 5 then
  begin
    S := Copy(s, 2, 4);
    executeTime := FloatToStr(trunc(StrToFloat(executeTime)));
    executeTime := executeTime + s;
  end;

  if Assigned(CUR_PRODUCTIONTIMESLEVEL) and (CUR_PRODUCTIONTIMESLEVEL.HANDLE_TIMES_BY = '2') and (OPERATION_TIME_MULTIPLIER <> '') then // avi
    NEW_PROD_STEP_TIME.ST_EXC_TIME_INIT_QTY := StrToFloat(executeTime) * getDoubleFromStr(OPERATION_TIME_MULTIPLIER)
  else
    NEW_PROD_STEP_TIME.ST_EXC_TIME_INIT_QTY := StrToFloat(executeTime);

  if Assigned(CUR_PRODUCTIONTIMESLEVEL) and (CUR_PRODUCTIONTIMESLEVEL.HANDLE_TIMES_BY = '2') and (SETUP_TIME_MULTIPLIER <> '') then // avi
    NEW_PROD_STEP_TIME.ST_SETUP_TIME_JOB := StrToFloat(setupTime) * getDoubleFromStr(SETUP_TIME_MULTIPLIER)
  else
    NEW_PROD_STEP_TIME.ST_SETUP_TIME_JOB := StrToFloat(setupTime);

{  if Assigned(CUR_PRODUCTIONTIMESLEVEL) and (CUR_PRODUCTIONTIMESLEVEL.HANDLE_TIMES_BY = '2') and ((OPERATION_TIME_MULTIPLIER <> '') or (SETUP_TIME_MULTIPLIER <> '')) then // avi
  begin
    if OPERATION_TIME_MULTIPLIER <> '' then
      NEW_PROD_STEP_TIME.ST_EXC_TIME_INIT_QTY := StrToFloat(executeTime) * getDoubleFromStr(OPERATION_TIME_MULTIPLIER);
    if SETUP_TIME_MULTIPLIER <> '' then
      NEW_PROD_STEP_TIME.ST_SETUP_TIME_JOB := StrToFloat(setupTime) * getDoubleFromStr(SETUP_TIME_MULTIPLIER);
  end
  else
  begin
    NEW_PROD_STEP_TIME.ST_EXC_TIME_INIT_QTY := StrToFloat(executeTime);
    NEW_PROD_STEP_TIME.ST_SETUP_TIME_JOB := StrToFloat(setupTime);
  end; }

  if (NEW_PROD_STEP_TIME.ST_EXC_TIME_INIT_QTY > 0) and (NEW_PROD_STEP_TIME.ST_EXC_TIME_INIT_QTY < 1/60) then
     NEW_PROD_STEP_TIME.ST_EXC_TIME_INIT_QTY := 0.017;

  //added by Erbil on 23/03/2009
//  NEW_PROD_STEP_TIME.PRODUCTIONDEMANDTEMPLATECODE := CUR_PRODUCTIONDEMANDTEMPLATE.CODE;
//  NEW_PROD_STEP_TIME.PRODUCTIONDEMANDCOUNTERCODE := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COUNTERCODE');
//  NEW_PROD_STEP_TIME.ITEMTYPECODE := ITEMTYPEAFICODE; // getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ITEMTYPEAFICODE');
//  NEW_PROD_STEP_TIME.TIMETYPECODE := timeTypeCode;

  PREQ_NO := NEW_PROD_STEP_TIME.ST_PREQ_NO;
  if CheckMerge(PREQ_NO, setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COUNTERCODE', PD_COUNTERCODE), 8), productionDemandCounters) then
  begin
    NEW_PROD_STEP_TIME.ST_FAMILYCODE := PREQ_NO;
    m_NeedToMakeMerge := true
  end;

  read_prod_step_time_list.Add(NEW_PROD_STEP_TIME);

  if (WORKCENTER <> nil) and (Trim(resource) = '') and (Trim(resourceCategory) = '') then
  begin
    index := searchInList(WORKCENTER.Process_List, 2, Trim(operation),
                          0, WORKCENTER.Process_List.Count - 1);

    if (index <> - 1) then
    begin
      CUR_PROCESS := WORKCENTER.Process_List[index];

      for i := 0 to CUR_PROCESS.Alternatives_List.Count - 1 do
      begin
        AlternativeWorkCenterCode := CUR_PROCESS.Alternatives_List[i];

        if ( not insertAlternativesToProdStepTime_List(Trim(AlternativeWorkCenterCode),
                                                       Trim(operation),
                                                       Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_ITEMTYPEAFICODE', PDS_ITEMTYPEAFICODE)),
                                                       UserGenericGroupTypeList, UserGenericGroupTypeAttributesList,
                                                       handledWorkCentersList,
                                                       MQMProductionColumnValues,
                                                       productionDemandCounters,
                                                       additionalDataList,
                                                       timeTypeCode,
                                                       //productPrimaryUomConversionDataList,
                                                       //secondaryUnitCategoryConversionList,
                                                       //stdUnitCategoryConversionList,
                                                       propertyList,
                                                       ColorTypeList, ColorTypeUNIQUEIDList,
                                                       resourceCategory,
                                                       resource,
                                                       read_prod_step_time_list,
                                                       routingStepTimeTypeList,
                                                       Items,
                                                       operationList)
           ) then
        begin
          New(NEW_PROD_STEP_TIME);
          NEW_PROD_STEP_TIME.ST_PREQ_NO := setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COMPANYCODE', PD_COMPANYCODE), 3) +
                                           setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COUNTERCODE', PD_COUNTERCODE), 8) +
                                           getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_CODE', PD_CODE);
          NEW_PROD_STEP_TIME.ST_PSTEP_ID := StrToInt(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_STEPNUMBER', PDS_STEPNUMBER));
          NEW_PROD_STEP_TIME.ST_WKCNTER := Trim(AlternativeWorkCenterCode);
          NEW_PROD_STEP_TIME.ST_WKCT_PROC := Trim(operation);
          NEW_PROD_STEP_TIME.ST_RES_CATEGORY := trim(resourceCategory);
          NEW_PROD_STEP_TIME.ST_RSC_CODE := trim(resource);
          NEW_PROD_STEP_TIME.ST_SETUP_TIME_Mechin_Code := '';
          NEW_PROD_STEP_TIME.ST_timeTypeCode := timeTypeCode;

          if ( timeTypeCode = 'B' ) then
          begin
            if BATCHSTANDARDTIME then
            begin
              quantity := 1;
            end
            else
            begin
              stepInitialQty := getDoubleFromStr( getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_INITIALBASEPRIMARYQUANTITY', PDS_INITIALBASEPRIMARYQUANTITY) );

              stepStdQty := ConvertUM(MQMProductionColumnValues, getValueOfTheProductionColumn(MQMProductionColumnValues,  'PDS_STANDARDSTEPQUANTITYUOMCODE', PDS_STANDARDSTEPQUANTITYUOMCODE),
                                getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_BASEPRIMARYUOMCODE', PD_BASEPRIMARYUOMCODE),
                                StrToFloat(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_STANDARDSTEPQUANTITY', PDS_STANDARDSTEPQUANTITY)),
                                ITEMTYPEAFICODE, //getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ITEMTYPEAFICODE'),
                              {  getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE01') ,
                                getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE02') ,
                                getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE03') ,
                                getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE04') ,
                                getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE05') ,
                                getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE06') ,
                                getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE07') ,
                                getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE08') ,
                                getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE09') ,
                                getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE10')); }

                                             SUBCODE01, SUBCODE02, SUBCODE03, SUBCODE04, SUBCODE05,
                                             SUBCODE06, SUBCODE07, SUBCODE08, SUBCODE09, SUBCODE10);


              if ( stepStdQty = 0 ) then
              stepStdQty := 1;

              quantity := Ceil(stepInitialQty / stepStdQty);

              if (quantity = 0) then
                quantity := 1;

            end;

            NEW_PROD_STEP_TIME.ST_TimeArriveFromNowStep := false;
            if (NEW_PROD_STEP_TIME.ST_timeTypeCode = 'B') OR (NEW_PROD_STEP_TIME.ST_timeTypeCode = 'P') then
            begin
              NEW_PROD_STEP_TIME.ST_ProductionOrderCode := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_PRODUCTIONORDERCODE', PDS_PRODUCTIONORDERCODE);
              NEW_PROD_STEP_TIME.ST_BatchTimeType := WC_BATCHSTANDARDTIME;
              NEW_PROD_STEP_TIME.ST_GroupStepNumber := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_GROUPSTEPNUMBER', PDS_GROUPSTEPNUMBER);
              NEW_PROD_STEP_TIME.ST_CalcTime2 := StrToFloat(getNumericValueOf(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_CALCULATEDTIME2', PDS_CALCULATEDTIME2)));
              NEW_PROD_STEP_TIME.ST_CalcTime3 := StrToFloat(getNumericValueOf(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_CALCULATEDTIME3', PDS_CALCULATEDTIME3)));
              NEW_PROD_STEP_TIME.ST_INITIALBASEPRIMARYQUANTITY := StrToFloat(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_INITIALBASEPRIMARYQUANTITY', PDS_INITIALBASEPRIMARYQUANTITY));
              NEW_PROD_STEP_TIME.ST_STANDARDSTEPQUANTITY       := stepStdQty;
              if CUR_PRODUCTIONTIMESLEVEL = nil then
              begin
                NEW_PROD_STEP_TIME.ST_multiplierExecution := 1;
                NEW_PROD_STEP_TIME.ST_multiplierSetUp := 1;
                NEW_PROD_STEP_TIME.ST_TimeArriveFromNowStep := true;
              end
              else if CUR_PRODUCTIONTIMESLEVEL.HANDLE_TIMES_BY <> '3' then
              begin
                NEW_PROD_STEP_TIME.ST_multiplierExecution := 0;
                NEW_PROD_STEP_TIME.ST_multiplierSetUp := 0;
              end
              else
              begin
                NEW_PROD_STEP_TIME.ST_multiplierExecution := getDoubleFromStr(OPERATION_TIME_MULTIPLIER);
                NEW_PROD_STEP_TIME.ST_multiplierSetUp := getDoubleFromStr(SETUP_TIME_MULTIPLIER);
                NEW_PROD_STEP_TIME.ST_TimeArriveFromNowStep := true;
              end;
            end;

          end
          else
          begin
            quantity := 1;
          end;

          SetupTimeStep := getDoubleFromStr(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_CALCULATEDTIME2', PDS_CALCULATEDTIME2));
          executionTimeStep := getDoubleFromStr(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_CALCULATEDTIME3', PDS_CALCULATEDTIME3));

          SetupTimeStep := (SetupTimeStep / quantity) * 60;
          executionTimeStep := (executionTimeStep / quantity) * 60;

          setupTime := FloatToStr(SetupTimeStep);
          TempExt := Frac(StrToFloat(setupTime));
          S := FloatToStr(TempExt);
          if Length(S) > 5 then
          begin
            S := Copy(s, 2, 4);
            setupTime := FloatToStr(trunc(StrToFloat(setupTime)));
            setupTime := setupTime + s;
            SetupTimeStep := StrToFloat(setupTime);
          end;

          executeTime := FloatToStr(executionTimeStep);
          TempExt := Frac(StrToFloat(executeTime));
          S := FloatToStr(TempExt);
          if Length(S) > 5 then
          begin
            S := Copy(s, 2, 4);
            executeTime := FloatToStr(trunc(StrToFloat(executeTime)));
            executeTime := executeTime + s;
            executionTimeStep := StrToFloat(executeTime);
          end;

          NEW_PROD_STEP_TIME.ST_SETUP_TIME_JOB := SetupTimeStep; //Trim(setupTime);
          NEW_PROD_STEP_TIME.ST_EXC_TIME_INIT_QTY := executionTimeStep;   //Trim(executeTimeAlt); //Trim(executeTime);

          if (NEW_PROD_STEP_TIME.ST_EXC_TIME_INIT_QTY > 0) and (NEW_PROD_STEP_TIME.ST_EXC_TIME_INIT_QTY < 1/60) then
             NEW_PROD_STEP_TIME.ST_EXC_TIME_INIT_QTY := 0.017;

          PREQ_NO := NEW_PROD_STEP_TIME.ST_PREQ_NO;
          if CheckMerge(PREQ_NO, setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COUNTERCODE', PD_COUNTERCODE), 8), productionDemandCounters) then
          begin
            NEW_PROD_STEP_TIME.ST_FAMILYCODE := PREQ_NO;
            m_NeedToMakeMerge := true
          end;

          read_prod_step_time_list.Add(NEW_PROD_STEP_TIME);
        end;
      end;
    end;
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

//----------------------------------------------------------------------------//

function needToInsertPRODUCTS(LocalQry: TMqmQuery; prodType: String; prodCode: String;
                                prodNature: String; startPoint: String; endPoint: String;
                                infoArea: String; stdPurCorProdTime: String;
                                currentProductsList: TList; MATERIAL_TOLLERANCE_CODE : string; HoursToDownFromMachin : integer; Items : PTItems): boolean;
var
  srvSqlStr, TableName: string;
  CUR_PRODUCT: PPRODUCTS;
  setClause: TStringList;
  index: integer;
  j: integer;
//  LocalHostName : TDndArchiveName;
  DndArchiveArcName : TDndArchiveName;
  SafeStr: string;
begin
  Result := true;

  DndArchiveArcName := GetDndArchiveLocalName;

  if DndArchiveArcName = TD_Interbase then
    TableName  := 'PRODUCTS'
  else
    TableName  := 'SCDM_' + 'PRODUCTS';

  if (trim(prodType) = '') or (trim(prodCode) = '') then
  begin
    Result := false;
    Exit;
  end;

  index := searchInList(currentProductsList, 13,
                        setStringLengthTo(prodType, 3, true, ' ') + Trim(prodCode),
                        0, currentProductsList.Count - 1);

  if (index <> -1) then
  begin
    CUR_PRODUCT := currentProductsList.Items[index];

    Result := false;

    if Length(infoArea) > 85 then
      infoArea := Copy(infoArea, 1,85);

    setClause := TStringList.Create;

    if (CUR_PRODUCT.PAR_PRODUT_NATURE <> prodNature) then
      setClause.Add('PAR_PRODUT_NATURE = ' + QuotedStr(prodNature));

    if (CUR_PRODUCT.PAR_STR_CONS_POINT <> startPoint) then
      setClause.Add('PAR_STR_CONS_POINT = ' + QuotedStr(startPoint));

    if (CUR_PRODUCT.PAR_END_CONS_POINT <> endPoint) then
      setClause.Add('PAR_END_CONS_POINT = ' + QuotedStr(endPoint));

    if (CUR_PRODUCT.PAR_INFO_AREA <> infoArea) then
      setClause.Add('PAR_INFO_AREA = ' + QuotedStr(infoArea));

    if (CUR_PRODUCT.PAR_MATERIAL_TOLLERANCE_CODE <> MATERIAL_TOLLERANCE_CODE) then
      setClause.Add('PAR_MATERIAL_TOLLERANCE_CODE = ' + QuotedStr(MATERIAL_TOLLERANCE_CODE));

    if (CUR_PRODUCT.PAR_STDPURCORPRODTIME <> stdPurCorProdTime) then
    begin
      if (Trim(stdPurCorProdTime) = '') then
        setClause.Add('PAR_STDPURCORPRODTIME = 0')
      else
        setClause.Add('PAR_STDPURCORPRODTIME = ' + stdPurCorProdTime);
    end;

    if (CUR_PRODUCT.PAR_HOURSTODOWNFROMMACHINE <> HoursToDownFromMachin) then
      setClause.Add('PAR_HOURSTODOWNFROMMACHINE = ' + IntToStr(HoursToDownFromMachin));


    if Assigned(Items) then
    begin

      if (CUR_PRODUCT.PAR_SCHEDULE_Warp <> Items.MAT_SCHEDULE_Type_Warp) then
      begin
        SetMaterialSchedule_Warp_Send_Client(true);
        //setClause.Add('PAR_MAT_SCHEDULE_TYPE = ' + QuotedStr(Items.MAT_SCHEDULE_Type_Warp));
        SafeStr := String(Items.MAT_SCHEDULE_Type_Warp); // forces a clean copy
        setClause.Add('PAR_MAT_SCHEDULE_TYPE = ' + QuotedStr(SafeStr));
      end;

      if (CUR_PRODUCT.PAR_STANDARD_SPEED_Warp <> Items.MAT_STANDARD_SPEED_Warp) then
      begin
        SetMaterialSchedule_Warp_Send_Client(true);
        setClause.Add('PAR_MAT_STANDARD_SPEED = ' + FloatToStr(Items.MAT_STANDARD_SPEED_Warp));
      end;

      if (CUR_PRODUCT.PAR_STANDARD_SETMIN_Warp <> Items.MAT_STANDARD_SETMIN_Warp) then
      begin
        SetMaterialSchedule_Warp_Send_Client(true);
        setClause.Add('PAR_MAT_STANDARD_SETMIN = ' + FloatToStr(Items.MAT_STANDARD_SETMIN_Warp));
      end;
    end;

    if (setClause.Count > 0) then
    begin
      srvSqlStr := 'UPDATE ' + TableName + ' SET ';

      for j := 0 to setClause.Count - 1 do
      begin
        if (j <> 0) then
          srvSqlStr := srvSqlStr + DecSep;

        srvSqlStr := srvSqlStr + setClause.Strings[j];
      end;

      srvSqlStr := SetDecSeparator(srvSqlStr);
      srvSqlStr := srvSqlStr + ' WHERE ' +
                   'PAR_TYPE_PROD = ' + QuotedStr(prodType) + ' AND ' +
                   'PAR_PRODUCT_CODE = ' + QuotedStr(Trim(prodCode)) +
                   AND_IDF_Condition('PAR_IDENTIFIER');

      LocalQry.SQL.Text := srvSqlStr;
      LocalQry.ExecSQL;
    end;

    setClause.Free;
  end;
end;

//----------------------------------------------------------------------------//

procedure insertIntoPRODUCTS(LocalQry: TMqmQuery; prodType: String; prodCode: String;
                             prodNature: String; startPoint: String; endPoint: String;
                             infoArea: String; stdPurCorProdTime: String; MATERIAL_TOLLERANCE_CODE : string; HoursToDownFromMachin : integer;
                             MAT_STANDARD_SPEED_Warp : double; MAT_STANDARD_SETMIN_Warp : double; MAT_SCHEDULE_Type_Warp : string);
var
  srvSqlStr, TableName: string;
//  LocalHostName : TDndArchiveName;
  tbInfo:         ^TTblInfo;
  DndArchiveArcName : TDndArchiveName;
begin
  DndArchiveArcName := GetDndArchiveLocalName;
  tbInfo := @tblInfo[tbl_products];
  if DndArchiveArcName = TD_Interbase then
    TableName  := 'PRODUCTS'
  else
    TableName  := 'SCDM_' + 'PRODUCTS';

  if Length(infoArea) > 70 then
     infoArea := Copy(infoArea, 1,70);

    srvSqlStr := 'insert into ' + TableName + '(' +
                  CreateFld(tbInfo.pfx, fli_IDENTIFIER) + ',' +
                  CreateFld(tbInfo.pfx, fli_ProdType) + ',' +
                  CreateFld(tbInfo.pfx, fli_ProdCode) + ',' +
                  CreateFld(tbInfo.pfx, fli_ProductNature) + ',' +
                  CreateFld(tbInfo.pfx, fli_StartConsumPoint) + ',' +
                  CreateFld(tbInfo.pfx, fli_EndConsumPoint)+ ',' +
                  CreateFld(tbInfo.pfx, fli_InfoArea) + ',' +
                  CreateFld(tbInfo.pfx, fli_StdPurcOrProdTime)+ ',' +
                  CreateFld(tbInfo.pfx, fli_IgnorMaterialCheck)+ ',' +
                  CreateFld(tbInfo.pfx, fli_Material_Tollerance_Types_Code)+ ',' +
                  CreateFld(tbInfo.pfx, fli_HoursToDownFromMachine)+ ',' +
                  CreateFld(tbInfo.pfx, fli_MaterialStandardSpeed)+ ',' +
                  CreateFld(tbInfo.pfx, fli_MaterialStandardSetupMinutes) + ',' +
                  CreateFld(tbInfo.pfx, fli_MaterialSchedule) +
                  ') values (' +
                  ':' + CreateFld(tbInfo.pfx, fli_IDENTIFIER) + ',' +
                  ':' + CreateFld(tbInfo.pfx, fli_ProdType) + ',' +
                  ':' + CreateFld(tbInfo.pfx, fli_ProdCode) + ',' +
                  ':' + CreateFld(tbInfo.pfx, fli_ProductNature) + ',' +
                  ':' + CreateFld(tbInfo.pfx, fli_StartConsumPoint) + ',' +
                  ':' + CreateFld(tbInfo.pfx, fli_EndConsumPoint) + ',' +
                  ':' + CreateFld(tbInfo.pfx, fli_InfoArea) + ',' +
                  ':' + CreateFld(tbInfo.pfx, fli_StdPurcOrProdTime) + ',' +
                  ':' + CreateFld(tbInfo.pfx, fli_IgnorMaterialCheck) + ',' +
                  ':' + CreateFld(tbInfo.pfx, fli_Material_Tollerance_Types_Code) + ',' +
                  ':' + CreateFld(tbInfo.pfx, fli_HoursToDownFromMachine) + ',' +
                  ':' + CreateFld(tbInfo.pfx, fli_MaterialStandardSpeed) + ',' +
                  ':' + CreateFld(tbInfo.pfx, fli_MaterialStandardSetupMinutes) + ',' +
                  ':' + CreateFld(tbInfo.pfx, fli_MaterialSchedule) +
                  ')';

  LocalQry.SQL.Text := srvSqlStr;
  LocalQry.Params.ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).Value := StrToInt(IniAppGlobals.Identifier);
  LocalQry.Params.ParamByName(CreateFld(tbInfo.pfx, fli_ProdType)).Value := prodType;
  LocalQry.Params.ParamByName(CreateFld(tbInfo.pfx, fli_ProdCode)).Value := trim(prodCode);
  LocalQry.Params.ParamByName(CreateFld(tbInfo.pfx, fli_ProductNature)).Value := prodNature;
  LocalQry.Params.ParamByName(CreateFld(tbInfo.pfx, fli_StartConsumPoint)).Value := startPoint;
  LocalQry.Params.ParamByName(CreateFld(tbInfo.pfx, fli_EndConsumPoint)).Value := endPoint;
  LocalQry.Params.ParamByName(CreateFld(tbInfo.pfx, fli_InfoArea)).Value := infoArea;
  LocalQry.Params.ParamByName(CreateFld(tbInfo.pfx, fli_StdPurcOrProdTime)).Value := stdPurCorProdTime;
  LocalQry.Params.ParamByName(CreateFld(tbInfo.pfx, fli_IgnorMaterialCheck)).Value := '0';
  LocalQry.Params.ParamByName(CreateFld(tbInfo.pfx, fli_Material_Tollerance_Types_Code)).Value := MATERIAL_TOLLERANCE_CODE;

  LocalQry.Params.ParamByName(CreateFld(tbInfo.pfx, fli_HoursToDownFromMachine)).Value := HoursToDownFromMachin;

  LocalQry.Params.ParamByName(CreateFld(tbInfo.pfx, fli_MaterialStandardSpeed)).Value        := MAT_STANDARD_SPEED_Warp;
  LocalQry.Params.ParamByName(CreateFld(tbInfo.pfx, fli_MaterialStandardSetupMinutes)).Value := MAT_STANDARD_SETMIN_Warp;
  LocalQry.Params.ParamByName(CreateFld(tbInfo.pfx, fli_MaterialSchedule)).Value             := MAT_SCHEDULE_Type_Warp;

  try
    LocalQry.ExecSQL;
  except
    on E: Exception do
    begin
      if (Pos('UNIQUE KEY', E.Message) > 0) or (Pos('PRIMARY ', E.Message) > 0) or
          (Pos('primary key ', E.Message) > 0) or (Pos('duplicate values', E.Message) > 0) then
      begin

      end
      else
        raise
    end;

  end;

end;

//----------------------------------------------------------------------------//

procedure getTimeValue(var setupTime: double; var executeTime: double; index: integer;
                       CUR_OPERATTRIBUTE: POPERATTRIBUTES;
                       routingStepTimeTypeList: TList;
                       MQMProductionColumnValues: PMQMProductionColumnValues;
                       operationList: TList;
                       operationCode: String; Items : PTItems ; OverridenTimeOrQty, StepRepetition : String; Eficiency100Percent : boolean);
var
  code: string;

  CUR_ROUTING_STEP_TIME_TYPE: PROUTING_STEP_TIME_TYPES;
  CUR_OPERATION: POPERATIONS;

  calculatedValue: double;

  indexRSTT: integer;
  indexOperation: integer;
begin
  case index of
    1: code := CUR_OPERATTRIBUTE.TIMETYPE1CODE;
    2: code := CUR_OPERATTRIBUTE.TIMETYPE2CODE;
    3: code := CUR_OPERATTRIBUTE.TIMETYPE3CODE;
    4: code := CUR_OPERATTRIBUTE.TIMETYPE4CODE;
    5: code := CUR_OPERATTRIBUTE.TIMETYPE5CODE;
  end;

  if ( Trim(code) <> '' ) then
  begin
    indexRSTT := searchInList(routingStepTimeTypeList, 11, Trim(code),
                      0, routingStepTimeTypeList.Count - 1);

    if ( indexRSTT <> -1 ) then
    begin
      CUR_ROUTING_STEP_TIME_TYPE :=  routingStepTimeTypeList.Items[indexRSTT];

      CUR_OPERATION := nil;
      indexOperation := searchInList(operationList, 14, Trim(operationCode),
                          0, operationList.Count - 1);
      if ( indexOperation <> -1 ) then
        CUR_OPERATION := operationList.Items[indexOperation];

      calculatedValue := getCalculatedTimeValue(CUR_ROUTING_STEP_TIME_TYPE.RSTT_APPLYTYPECODE, CUR_ROUTING_STEP_TIME_TYPE.RSTT_EFFICIENCYSTEPUSED,
                                                index,
                                                CUR_OPERATTRIBUTE,
                                                MQMProductionColumnValues,
                                                CUR_OPERATION, Items, OverridenTimeOrQty, StepRepetition, Eficiency100Percent);

      if ( Trim(CUR_ROUTING_STEP_TIME_TYPE.RSTT_TYPE) = '1' ) then
        setupTime := setupTime + calculatedValue
      else if ( Trim(CUR_ROUTING_STEP_TIME_TYPE.RSTT_TYPE) = '2' ) then
        executeTime := executeTime + calculatedValue;
    end;
  end;
end;

//----------------------------------------------------------------------------//

function getCalculatedTimeValue(applyTypeCode: String; EfficiencyStepUsed : string; index: integer;
                        CUR_OPERATTRIBUTE: POPERATTRIBUTES;
                        MQMProductionColumnValues: PMQMProductionColumnValues;
                        CUR_OPERATION: POPERATIONS; Items : PTItems; OverridenTimeOrQty, StepRepetition : String; Eficiency100Percent : boolean): double;
var
  quantity: double;
  batchQuantity: double;
  stdQuantity: double;
  percentage: double;
  linkedTime: double;
  refQuantity: double;
  secondaryQuantity: double;
  time: double;
  POExists : boolean;
  linkedTimeIndex: String;
  quantityUom: string;
  batchUom: string;
  stdQuantityUom: string;
  secondaryQuantityUom: string;
  timeUom: string;
  TIMEREFUOMCODE : String;
  ITEMTYPEAFICODE, SUBCODE01, SUBCODE02, SUBCODE03, SUBCODE04, SUBCODE05,
  SUBCODE06, SUBCODE07, SUBCODE08, SUBCODE09, SUBCODE10 : string;
begin
  if assigned(Items) then
  begin
    ITEMTYPEAFICODE  := Items.ITEMTYPEAFICODE;
    SUBCODE01 := Items.SUBCODE01;
    SUBCODE02 := Items.SUBCODE02;
    SUBCODE03 := Items.SUBCODE03;
    SUBCODE04 := Items.SUBCODE04;
    SUBCODE05 := Items.SUBCODE05;
    SUBCODE06 := Items.SUBCODE06;
    SUBCODE07 := Items.SUBCODE07;
    SUBCODE08 := Items.SUBCODE08;
    SUBCODE09 := Items.SUBCODE09;
    SUBCODE10 := Items.SUBCODE10;
  end;

  quantity := getDoubleFromStr(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_INITIALBASEPRIMARYQUANTITY', PDS_INITIALBASEPRIMARYQUANTITY));
  quantityUom := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_BASEPRIMARYUOMCODE', PDS_BASEPRIMARYUOMCODE);

  batchQuantity := getDoubleFromStr(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_STDPRODUCTIONBATCH', PD_STDPRODUCTIONBATCH));
  batchUom := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_STDPRODUCTIONBATCHUOMCODE', PD_STDPRODUCTIONBATCHUOMCODE);

  stdQuantity := getDoubleFromStr(CUR_OPERATTRIBUTE.STANDARDSTEPQUANTITY);
  stdQuantityUom := CUR_OPERATTRIBUTE.STANDARDSTEPQTYUOMCODE;

  percentage := 0;
  time := 0;

  case index of
    1:
    begin
      percentage := getDoubleFromStr(CUR_OPERATTRIBUTE.TIMEREFQTY1);
      time := getDoubleFromStr(CUR_OPERATTRIBUTE.TIME1);
      timeUom := CUR_OPERATTRIBUTE.TIMEUNIT1;
      linkedTimeIndex := Trim(CUR_OPERATION.LINKEDTIME1);
      TIMEREFUOMCODE :=  CUR_OPERATTRIBUTE.TIMEREFUOM1CODE;
    end;
    2:
    begin
      percentage := getDoubleFromStr(CUR_OPERATTRIBUTE.TIMEREFQTY2);
      time := getDoubleFromStr(CUR_OPERATTRIBUTE.TIME2);
      timeUom := CUR_OPERATTRIBUTE.TIMEUNIT2;
      linkedTimeIndex := Trim(CUR_OPERATION.LINKEDTIME2);
      TIMEREFUOMCODE :=  CUR_OPERATTRIBUTE.TIMEREFUOM2CODE;
    end;
    3:
    begin
      percentage := getDoubleFromStr(CUR_OPERATTRIBUTE.TIMEREFQTY3);
      time := getDoubleFromStr(CUR_OPERATTRIBUTE.TIME3);
      timeUom := CUR_OPERATTRIBUTE.TIMEUNIT3;
      linkedTimeIndex := Trim(CUR_OPERATION.LINKEDTIME3);
      TIMEREFUOMCODE :=  CUR_OPERATTRIBUTE.TIMEREFUOM3CODE;
    end;
    4:
    begin
      percentage := getDoubleFromStr(CUR_OPERATTRIBUTE.TIMEREFQTY4);
      time := getDoubleFromStr(CUR_OPERATTRIBUTE.TIME4);
      timeUom := CUR_OPERATTRIBUTE.TIMEUNIT4;
      linkedTimeIndex := Trim(CUR_OPERATION.LINKEDTIME4);
      TIMEREFUOMCODE := CUR_OPERATTRIBUTE.TIMEREFUOM4CODE;
    end;
    5:
    begin
      percentage := getDoubleFromStr(CUR_OPERATTRIBUTE.TIMEREFQTY5);
      time := getDoubleFromStr(CUR_OPERATTRIBUTE.TIME5);
      timeUom := CUR_OPERATTRIBUTE.TIMEUNIT5;
      linkedTimeIndex := Trim(CUR_OPERATION.LINKEDTIME5);
      TIMEREFUOMCODE := CUR_OPERATTRIBUTE.TIMEREFUOM5CODE;
    end;
  end;

  if linkedTimeIndex = '1' then
    linkedTime := getDoubleFromStr(CUR_OPERATTRIBUTE.TIME1)
  else if linkedTimeIndex = '2' then
    linkedTime := getDoubleFromStr(CUR_OPERATTRIBUTE.TIME2)
  else if linkedTimeIndex = '3' then
    linkedTime := getDoubleFromStr(CUR_OPERATTRIBUTE.TIME3)
  else if linkedTimeIndex = '4' then
    linkedTime := getDoubleFromStr(CUR_OPERATTRIBUTE.TIME4)
  else if linkedTimeIndex = '5' then
    linkedTime := getDoubleFromStr(CUR_OPERATTRIBUTE.TIME5)
  else
    linkedTime := 0;

  POExists := false;
  if Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_PRODUCTIONORDERCODE', PDS_PRODUCTIONORDERCODE)) <> '' then
    POExists := true;

  secondaryQuantity := getDoubleFromStr(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_INITIALBASESECONDARYQUANTITY', PDS_INITIALBASESECONDARYQUANTITY));
  secondaryQuantityUom := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_BASESECONDARYUOMCODE', PDS_BASESECONDARYUOMCODE);

  refQuantity := percentage;

  Result := 0;

  if ( Trim(applyTypeCode) = 'PRIMARY' ) or  ( Trim(applyTypeCode) = 'UNIT' ) then
  begin
    quantity := ConvertUM(MQMProductionColumnValues, quantityUom, TIMEREFUOMCODE, quantity, ITEMTYPEAFICODE,
                                             SUBCODE01, SUBCODE02, SUBCODE03, SUBCODE04, SUBCODE05,
                                             SUBCODE06, SUBCODE07, SUBCODE08, SUBCODE09, SUBCODE10);
  end;

  if ( Trim(applyTypeCode) = 'SECONDARY' ) then
  begin
    secondaryQuantity := ConvertUM(MQMProductionColumnValues, secondaryQuantityUom, TIMEREFUOMCODE, secondaryQuantity, ITEMTYPEAFICODE,
                                             SUBCODE01, SUBCODE02, SUBCODE03, SUBCODE04, SUBCODE05,
                                             SUBCODE06, SUBCODE07, SUBCODE08, SUBCODE09, SUBCODE10);
  end;


  if ( quantity <> 0 ) then
  begin
    if Trim(applyTypeCode) = 'BATCH' then
    begin
      if OverridenTimeOrQty <> '' then
        time := StrToFloat(OverridenTimeOrQty);
      Result := calculateTimeForBatch(POExists, quantity, batchQuantity, time, timeUom);
    end;
    if Trim(applyTypeCode) = 'CONTINUOUS' then
    Begin
      if OverridenTimeOrQty <> '' then
        time := StrToFloat(OverridenTimeOrQty);
      Result := calculateTimeForContinuos(POExists, quantity, stdQuantity, time, timeUom);
    end;
    if Trim(applyTypeCode) = 'FIX' then
    Begin
      if OverridenTimeOrQty <> '' then
        time := StrToFloat(OverridenTimeOrQty);
      Result := calculateTimeForFix(time, timeUom);
    end;
    if Trim(applyTypeCode) = 'PERCENTAGE' then
    begin
      if OverridenTimeOrQty <> '' then
        percentage := StrToFloat(OverridenTimeOrQty);
      Result := calculateTimeForPercentage(percentage, linkedTime, timeUom);
    end;
    if Trim(applyTypeCode) = 'PRIMARY' then
    begin
      if OverridenTimeOrQty <> '' then
        refQuantity := StrToFloat(OverridenTimeOrQty);
      Result := calculateTimeForPrimary(quantity, refQuantity, timeUom);
    end;
    if Trim(applyTypeCode) = 'SECONDARY' then
    begin
      if OverridenTimeOrQty <> '' then
        refQuantity := StrToFloat(OverridenTimeOrQty);
      Result := calculateTimeForSecondary(secondaryQuantity, refQuantity, timeUom);
    end;
    if Trim(applyTypeCode) = 'UNIT' then
    Begin
      if OverridenTimeOrQty <> '' then
        time := StrToFloat(OverridenTimeOrQty);
      Result := calculateTimeForUnit(quantity, time, timeUom);
    end;

    if not Eficiency100Percent then
      if (CUR_OPERATTRIBUTE.STEPEFFICIENCYAPPLY = '1') and (EfficiencyStepUsed <> '1') and (StrToFloat(CUR_OPERATTRIBUTE.STEPEFFICIENCY) > 0) then
        Result :=  Result * 100 / StrToFloat(CUR_OPERATTRIBUTE.STEPEFFICIENCY);

    if (StepRepetition <> '') and (StrToFloat(StepRepetition) > 0) then
      Result := Result * StrToFloat(StepRepetition)
    else
      Result := Result * CUR_OPERATTRIBUTE.REPETITIONNUMBER;

  end;

end;

//----------------------------------------------------------------------------//

function getDoubleFromStr(str: String): double;
begin
  if ( Trim(str) = '' ) then
    Result := 0
  else
    Result := StrToFloat(str);
end;

//----------------------------------------------------------------------------//

function calculateTimeForBatch(POExists : boolean; quantity: double; batchQuantity: double; time: double; uomCode: string): double;
begin
  if POExists then
    quantity := Ceil(quantity / batchQuantity)
  else
    quantity := quantity / batchQuantity;
  time := time * quantity;

  Result := convertTimeToMin(time, uomCode);
end;

//----------------------------------------------------------------------------//

function calculateTimeForContinuos(POExists : boolean; quantity: double; stdQuantity: double; time: double; uomCode: string): double;
begin
  if POExists then
    quantity := Ceil(quantity / stdQuantity)
  else
     quantity := quantity / stdQuantity;
  time := time * quantity;

  Result := convertTimeToMin(time, uomCode);
end;

//----------------------------------------------------------------------------//

function calculateTimeForFix(time: double; uomCode: string): double;
begin
  Result := convertTimeToMin(time, uomCode);
end;

//----------------------------------------------------------------------------//

function calculateTimeForPercentage(percentage: double; linkedTime: double;
                                    uomCode: string): double;
var
  time: double;
begin
  percentage := percentage / 100;
  time := linkedTime * percentage;

  Result := convertTimeToMin(time, uomCode);
end;

//----------------------------------------------------------------------------//

function calculateTimeForPrimary(quantity: double; refQuantity: double; uomCode: string): double;
var
  time : double;
begin
  if refQuantity = 0 then
     refQuantity := 1;
  quantity := quantity / refQuantity;
  time := quantity;

  Result := convertTimeToMin(time, uomCode);
end;

//----------------------------------------------------------------------------//

function calculateTimeForSecondary(secondaryQuantity: double; refQuantity: double; uomCode: string): double;
var
  time: double;
begin
  if (refQuantity = 0) or (secondaryQuantity = 0) then
  begin
    Result := 0;
    Exit;
  end;
  secondaryQuantity := secondaryQuantity / refQuantity;
  time := secondaryQuantity;

  Result := convertTimeToMin(time, uomCode);
end;

//----------------------------------------------------------------------------//

function calculateTimeForUnit(quantity: double; time: double; uomCode: string): double;
begin
  time := time * quantity;

  Result := convertTimeToMin(time, uomCode);
end;

//----------------------------------------------------------------------------//

function convertTimeToMin(time: double; uomCode: String): double;
var
  multiplier: double;
begin
  multiplier := 1;

  if (Trim(uomCode) = '1') then
    multiplier := 60
  else if (Trim(uomCode) = '3') then
    multiplier := (1/60);

  Result := Ceil(time * multiplier);
end;

//------------------------------------------------------

function searchAndAddProp(listToSearch: TList; valueToSearch: String; var IndexInTable : integer) : boolean;
var
  minIndex, maxIndex, searchIndex : integer;
  valueToCheck: String;
begin
  Result := false;
  IndexInTable := listToSearch.Count;
  minIndex := 0;
  maxIndex := listToSearch.Count - 1;

  while true do
  begin

    if ( maxIndex < minIndex ) then break;

    searchIndex := (minIndex + maxIndex) div 2;

    ValueToCheck :=PReqTempProp(listToSearch[searchIndex]).PropCode;

    if (valueToCheck > valueToSearch) then
    begin
      if searchIndex < IndexInTable then IndexInTable := searchIndex;
      maxIndex := searchIndex - 1;
      continue;
    end;

    if valueToCheck < valueToSearch then
    begin
      minIndex := searchIndex + 1;
      continue;
    end;

    Result := true;
    IndexInTable := searchIndex;
    break;

  end;

end;


//----------------------------------------------------------------------------//

procedure ifNeededInsertIntoPROP_PROD_List(MQMProductionColumnValues: PMQMProductionColumnValues;
                                           propertyList: TList; resList : TList;
                                           additionalDataList,
                                           UserGenericGroupTypeList, UserGenericGroupTypeAttributesList : TList;
                                           ColorTypeList, ColorTypeUNIQUEIDList : TList;
                                           handledWorkCentersList: TList;
                                           read_prop_prod_list: TList;
                                           CUR_PRODUCTIONDEMANDTEMPLATE: PPRODUCTIONDEMANDTEMPLATES;
                                           Items : PTItems;
                                           Steps, Recipes, Designs : TStringList;
                                           GenericOrder, GenericLine, GenericDelivery, GenericProject, GenericBusinessPartner : PRGeneric;
                                           var HeaderPropList : TList; productionDemandCounters: TList; var ServingCode : string; var CurveFamily_IdCode : string; var CurveFamily_IdCode_BuildFromProp : boolean;
                                           isWorkCenterHandledByMqm : String; isWorkCenterHandledByMcm : String);
var
  NEW_PROP_PROD: PTMQMPP;
  i: integer;
  j, K, A: integer;

  CUR_PROP: PPROPS;
  CUR_PROP_RTV_VALUE: PPROP_RTV_VALUES;
  CUR_ADDITIONALDATA_HEADER: PADDITIONALDATA_HEADERS;

  flag: boolean;

  index, IndexProduct, N: integer;
  ProductValue, VALUE_tmpStr : string;
  VALUE_tmp_Double : double;
  propertyValue, StandardDateFormat: String;
  RTV_VALUE : string;
  ValueFromTable : string;
  CompleteMqmFormat, Found, RtvFromIsFound : boolean;
  Generic : PRGeneric;
  workCenterCode, operationCode, itemType, GenericGroupCodeType, ColorType, SUBCODE01 : string;
  ABSUNIQUEID, PD_SUBCODE, SUBCODE, SUBCODEVALUE, PREQ_NO : String;
  SUBCODENR : integer;
  ValueDateTime : TDateTime;
  DataType : Integer;
  myYear, myMonth, myDay : Word;
  ReqTempProp : PReqTempProp;
  HeaderProperty, ProperyFoundInHeader : boolean;
  IndexProperty : integer;
  ProductADIndex, FullItemKeyDecoderADIndex, SalesOrderADIndex, SalesOrderLineADIndex, SalesOrderDeliveryADIndex : integer;
  ProjectADIndex, RecipeADIndex, DesignADIndex, WorkCenterIndex : Integer;
  OperationAndWorkCenterCode : String;
  IsPropertyRelevantForWorkCenter : boolean;
  CurStepNumber : string;
  NowTime : TDateTime;
  CounterCode8 : String;
  mergeNeeded : Boolean;
begin
  CUR_PROP_RTV_VALUE := nil;

  PREQ_NO := setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COMPANYCODE', PD_COMPANYCODE), 3) +
                              setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COUNTERCODE', PD_COUNTERCODE), 8) +
                              getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_CODE', PD_CODE);

  PREQ_NO := trim(PREQ_NO);
  CounterCode8 := setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COUNTERCODE', PD_COUNTERCODE), 8);
  mergeNeeded := CheckMerge(PREQ_NO, CounterCode8, productionDemandCounters);
//  if PREQ_NO = '10 PDSTI   STI0000002' then
//     PREQ_NO := PREQ_NO + PREQ_NO;

  workCenterCode := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_WORKCENTERCODE', PDS_WORKCENTERCODE));
  operationCode := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_OPERATIONCODE', PDS_OPERATIONCODE));
  ProductADIndex := -99;
  FullItemKeyDecoderADIndex := -99;
  SalesOrderADIndex := -99;
  SalesOrderLineADIndex := -99;
  SalesOrderDeliveryADIndex := -99;
  ProjectADIndex := -99;
  RecipeADIndex := -99;
  DesignADIndex := -99;

  CurStepNumber := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_STEPNUMBER', PDS_STEPNUMBER);
  NowTime := Now;

  for i := 0 to propertyList.Count - 1 do
  begin
    CUR_PROP := propertyList.Items[i];

    IsPropertyRelevantForWorkCenter := false;
    if (isWorkCenterHandledByMqm = '1') and CUR_PROP.PY_MQM_Prop_Rtv_Value then
      IsPropertyRelevantForWorkCenter := true;
    if (isWorkCenterHandledByMcm = '1') and CUR_PROP.PY_MCM_Prop_Rtv_Value then
      IsPropertyRelevantForWorkCenter := true;
    if not IsPropertyRelevantForWorkCenter then continue;

    if (CUR_PROP.PY_IS_PROP_BUILD_FROM_PROP) and (CUR_PROP.PY_DESIGNATEDPROPERTY = '6') then
      CurveFamily_IdCode_BuildFromProp := true;

    if CUR_PROP.PY_IS_PROP_BUILD_FROM_PROP then continue;

    if CUR_PROP.PY_Planner_Prop then continue;

    flag := false;

    if not CUR_PROP.HasAtLeastOneConnectionToResource then continue;

    if ( CUR_PROP.PY_RP_CONN_LEV_MAIN = '1' ) then // all resources
      flag := true;

    if (CUR_PROP.PY_RP_CONN_LEV_MAIN = '2')
    or (CUR_PROP.PY_RP_CONN_LEV_MAIN = '3')
    or (CUR_PROP.PY_RP_CONN_LEV_MAIN = '4')
    or (CUR_PROP.PY_RP_CONN_LEV_MAIN = '5') then
    begin
      if CUR_PROP.PropWorkCentersCode.IndexOf(workCenterCode) <> -1 then
        flag := true
      else
      begin
        OperationAndWorkCenterCode := operationCode + '||' + workCenterCode;
        if CUR_PROP.PropWorkCentersCodePerOperation.IndexOf(OperationAndWorkCenterCode) <> -1 then
          flag := true;
      end;
    end;

    if flag then
    begin
      propertyValue := '';
      RtvFromIsFound := false;
      HeaderProperty := false;
      ProperyFoundInHeader := false;
      DataType := 0;

      if (Trim(CUR_PROP.PY_DESIGNATEDPROPERTY) = '1') then
        index := searchInList(CUR_PROP.propRtvValueList, 43,
                              '', 0, CUR_PROP.propRtvValueList.Count - 1)
      else
        index := searchInList(CUR_PROP.propRtvValueList, 43,
                              Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ITEMTYPEAFICODE', PD_ITEMTYPEAFICODE)),
                              0, CUR_PROP.propRtvValueList.Count - 1);

      if ( index <> -1 ) then
      begin
        RtvFromIsFound := true;
        CUR_PROP_RTV_VALUE := CUR_PROP.propRtvValueList.Items[index];
      end;

      if not RtvFromIsFound or
         (CUR_PROP_RTV_VALUE.TABLE_NAME = 'PRODUCT') or
         (CUR_PROP_RTV_VALUE.TABLE_NAME = 'PRODUCTIONDEMAND') or
         (CUR_PROP_RTV_VALUE.TABLE_NAME = 'FULLITEMKEYDECODER') or
         (CUR_PROP_RTV_VALUE.TABLE_NAME = 'SALESORDER') or
		 (CUR_PROP_RTV_VALUE.TABLE_NAME = 'BUSINESSPARTNER') or
         (CUR_PROP_RTV_VALUE.TABLE_NAME = 'SALESORDERLINE') or
         (CUR_PROP_RTV_VALUE.TABLE_NAME = 'SALESORDERDELIVERY') or
         (CUR_PROP_RTV_VALUE.TABLE_NAME = 'PROJECT') or
         (CUR_PROP_RTV_VALUE.TABLE_NAME = 'PRODUCTSPECIALIZEDGREIGE') or
         (CUR_PROP_RTV_VALUE.TABLE_NAME = 'PRODUCTSPECIALIZEDSIZE') or
         (CUR_PROP_RTV_VALUE.TABLE_NAME = 'PRODUCTSPECIALIZEDYARN') or
         (CUR_PROP_RTV_VALUE.TABLE_NAME = 'Product AD') or
         (CUR_PROP_RTV_VALUE.TABLE_NAME = 'ProductionDemand AD') or
         (CUR_PROP_RTV_VALUE.TABLE_NAME = 'FullItemKeyDecoder AD') or
         (CUR_PROP_RTV_VALUE.TABLE_NAME = 'SalesOrder AD') or
         (CUR_PROP_RTV_VALUE.TABLE_NAME = 'SalesOrderLine AD') or
         (CUR_PROP_RTV_VALUE.TABLE_NAME = 'SalesOrderDelivery AD') or
         (copy(CUR_PROP_RTV_VALUE.TABLE_NAME, 1, 19) = 'UserGenericGroup AD') or
		 (copy(CUR_PROP_RTV_VALUE.TABLE_NAME, 1, 24) = 'UserGenericGroup Subcode') or
         (CUR_PROP_RTV_VALUE.TABLE_NAME = 'Project AD') then
      begin
        HeaderProperty := true;
        ProperyFoundInHeader := searchAndAddProp(HeaderPropList, CUR_PROP.PY_PROPERTY, IndexProperty);
        if ProperyFoundInHeader then
          propertyValue := PReqTempProp(HeaderPropList[IndexProperty]).PropVal;
      end;

      if ( index <> -1 ) and (not ProperyFoundInHeader) then
      begin
        CompleteMqmFormat := true;
       { if (CUR_PROP.PY_TYPE = '2') and ((CUR_PROP_RTV_VALUE.From_Position > 0) and (CUR_PROP_RTV_VALUE.From_Position < 90))
           and ((CUR_PROP_RTV_VALUE.Length_From_Pos > 0) and (CUR_PROP_RTV_VALUE.Length_From_Pos < 90)) then
        begin
          CompleteMqmFormat := false;
        end; }
        if (CUR_PROP.PY_TYPE = '1') and (CUR_PROP.PY_DESIGNATEDPROPERTY = '2') then
          CompleteMqmFormat := false;

        if (CUR_PROP_RTV_VALUE.TABLE_NAME = 'PRODUCT') then
        begin
          RTV_VALUE := copy('P_' + CUR_PROP_RTV_VALUE.COLUMN_NAME, 1, 30);
          if assigned(Items) then
          begin
            IndexProduct := Items.productColumnNames.IndexOf(RTV_VALUE);
            if IndexProduct <> -1 then
            begin
              ProductValue := Items.ProductColumnValue.Strings[IndexProduct];
              propertyValue := formatPropertyValueDirect(CUR_PROP, ProductValue, CompleteMqmFormat, CUR_PROP_RTV_VALUE);
            end;
          end;
        end

        else if (CUR_PROP_RTV_VALUE.TABLE_NAME = 'PRODUCTSPECIALIZEDGREIGE') then
        begin
          RTV_VALUE := copy('PSG_' + CUR_PROP_RTV_VALUE.COLUMN_NAME, 1, 30);
          if assigned(Items) and Items.ProductSpecializedGreigeColumn_created then
          begin
            IndexProduct := Items.productSpecializedGreigeColumnNames.IndexOf(RTV_VALUE);
            if IndexProduct <> -1 then
            begin
              ProductValue := Items.ProductSpecializedGreigeColumnValue.Strings[IndexProduct];
              propertyValue := formatPropertyValueDirect(CUR_PROP, ProductValue, CompleteMqmFormat, CUR_PROP_RTV_VALUE);
            end;
          end;
        end

        else if (CUR_PROP_RTV_VALUE.TABLE_NAME = 'PRODUCTSPECIALIZEDSIZE') then
        begin
          RTV_VALUE := copy('PSS_' + CUR_PROP_RTV_VALUE.COLUMN_NAME, 1, 30);
          if assigned(Items) and Items.ProductSpecializedSizeColumn_created then
          begin
            IndexProduct := Items.productSpecializedSizeColumnNames.IndexOf(RTV_VALUE);
            if IndexProduct <> -1 then
            begin
              ProductValue := Items.ProductSpecializedSizeColumnValue.Strings[IndexProduct];
              propertyValue := formatPropertyValueDirect(CUR_PROP, ProductValue, CompleteMqmFormat, CUR_PROP_RTV_VALUE);
            end;
          end;
        end

        else if (CUR_PROP_RTV_VALUE.TABLE_NAME = 'PRODUCTSPECIALIZEDYARN') then
        begin
          RTV_VALUE := copy('PSY_' + CUR_PROP_RTV_VALUE.COLUMN_NAME, 1, 30);
          if assigned(Items) and Items.ProductSpecializedYarnColumn_created then
          begin
            IndexProduct := Items.productSpecializedYarnColumnNames.IndexOf(RTV_VALUE);
            if IndexProduct <> -1 then
            begin
              ProductValue := Items.ProductSpecializedYarnColumnValue.Strings[IndexProduct];
              propertyValue := formatPropertyValueDirect(CUR_PROP, ProductValue, CompleteMqmFormat, CUR_PROP_RTV_VALUE);
            end;
          end;
        end

        else if (CUR_PROP_RTV_VALUE.TABLE_NAME = 'FULLITEMKEYDECODER') then
        begin

          RTV_VALUE := copy('FIKD_' + CUR_PROP_RTV_VALUE.COLUMN_NAME, 1, 30);

          if assigned(Items) then
          begin
	          IndexProduct := Items.FullItemKeyDecoderColumnNames.IndexOf(RTV_VALUE);
	          if IndexProduct <> -1 then
	          begin
	            ProductValue := Items.FullItemKeyDecoderColumnValue.Strings[IndexProduct];
	            propertyValue := formatPropertyValueDirect(CUR_PROP, ProductValue, CompleteMqmFormat, CUR_PROP_RTV_VALUE);
	          end;
          end;

        end

        else if (CUR_PROP_RTV_VALUE.TABLE_NAME = 'Product AD') then
        begin
          ValueFromTable := '';
          if Assigned(Items) then
          begin
            if ProductADIndex = -99 then
              ProductADIndex := searchInList(additionalDataList, 8, Items.ABSUNIQUEID_P, 0, additionalDataList.Count - 1);
          end
          else
            ProductADIndex := -1;
          CUR_ADDITIONALDATA_HEADER := nil;
          if ( ProductADIndex <> -1 ) then
          begin
            CUR_ADDITIONALDATA_HEADER := additionalDataList.Items[ProductADIndex];
            ValueFromTable := getAdditionalData(CUR_ADDITIONALDATA_HEADER.productADList, CUR_PROP_RTV_VALUE.COLUMN_NAME, DataType);
          end;

          propertyValue := formatPropertyValueDirect(CUR_PROP,ValueFromTable, CompleteMqmFormat, CUR_PROP_RTV_VALUE);

        end

        else if (CUR_PROP_RTV_VALUE.TABLE_NAME = 'FullItemKeyDecoder AD') then
        begin
          ValueFromTable := '';
          if Assigned(Items) then
          begin
            if FullItemKeyDecoderADIndex = -99 then
              FullItemKeyDecoderADIndex := searchInList(additionalDataList, 8, Items.ABSUNIQUEID, 0, additionalDataList.Count - 1);
          end
          else
            FullItemKeyDecoderADIndex := -1;
          CUR_ADDITIONALDATA_HEADER := nil;
          if ( FullItemKeyDecoderADIndex <> -1 ) then
          begin
            CUR_ADDITIONALDATA_HEADER := additionalDataList.Items[FullItemKeyDecoderADIndex];
            ValueFromTable := getAdditionalData(CUR_ADDITIONALDATA_HEADER.fullItemKeyDecoderADList, CUR_PROP_RTV_VALUE.COLUMN_NAME,DataType);
          end;

          try
          propertyValue := formatPropertyValueDirect(CUR_PROP,ValueFromTable, CompleteMqmFormat, CUR_PROP_RTV_VALUE);
          except
            propertyValue := '';
          end;
        end

        else if (CUR_PROP_RTV_VALUE.TABLE_NAME = 'SALESORDER')  then
        begin
          ValueFromTable := '';
          if assigned(GenericOrder) then
          begin
            RTV_VALUE := copy('SO_' + CUR_PROP_RTV_VALUE.COLUMN_NAME, 1, 30);
            Index := GenericOrder.ColumnNames.IndexOf(RTV_VALUE);
            if Index <> -1 then
              ValueFromTable := GenericOrder.ColumnValue.Strings[Index];
          end;
          propertyValue := formatPropertyValueDirect(CUR_PROP, ValueFromTable, CompleteMqmFormat, CUR_PROP_RTV_VALUE);
        end
		
        else if (CUR_PROP_RTV_VALUE.TABLE_NAME = 'BUSINESSPARTNER')  then
        begin
          ValueFromTable := '';
          if assigned(GenericBusinessPartner) then
          begin
            RTV_VALUE := copy(CUR_PROP_RTV_VALUE.COLUMN_NAME, 1, 30);
            Index := GenericBusinessPartner.ColumnNames.IndexOf(RTV_VALUE);
            if Index <> -1 then
              ValueFromTable := GenericBusinessPartner.ColumnValue.Strings[Index];
          end;
          propertyValue := formatPropertyValue(propertyList, CUR_PROP.PY_PROPERTY, ValueFromTable, CompleteMqmFormat, CUR_PROP_RTV_VALUE);
        end	

        else if (CUR_PROP_RTV_VALUE.TABLE_NAME = 'SalesOrder AD') then
        begin
          ValueFromTable := '';
          if assigned(GenericOrder) then
          begin
            if SalesOrderADIndex = -99 then
              SalesOrderADIndex := searchInList(additionalDataList, 8, GenericOrder.ABSUniqueId, 0, additionalDataList.Count - 1);
            if SalesOrderADIndex <> -1 then
            begin
              CUR_ADDITIONALDATA_HEADER := additionalDataList.Items[SalesOrderADIndex];
              ValueFromTable := getAdditionalData(CUR_ADDITIONALDATA_HEADER.SalesOrderADList, CUR_PROP_RTV_VALUE.COLUMN_NAME,DataType);
            end;
          end;
          propertyValue := formatPropertyValueDirect(CUR_PROP,ValueFromTable, CompleteMqmFormat, CUR_PROP_RTV_VALUE);
        end

        else if (CUR_PROP_RTV_VALUE.TABLE_NAME = 'SALESORDERLINE')  then
        begin
          ValueFromTable := '';
          if assigned(GenericLine) then
          begin
            RTV_VALUE := copy('SOL_' + CUR_PROP_RTV_VALUE.COLUMN_NAME, 1, 30);
            Index := GenericLine.ColumnNames.IndexOf(RTV_VALUE);
            if Index <> -1 then
              ValueFromTable := GenericLine.ColumnValue.Strings[Index];
          end;
          propertyValue := formatPropertyValueDirect(CUR_PROP, ValueFromTable, CompleteMqmFormat, CUR_PROP_RTV_VALUE);
        end

        else if (CUR_PROP_RTV_VALUE.TABLE_NAME = 'SalesOrderLine AD') then
        begin
          ValueFromTable := '';
          if assigned(GenericLine) then
          begin
            if SalesOrderLineADIndex = -99 then
              SalesOrderLineADIndex := searchInList(additionalDataList, 8, GenericLine.ABSUniqueId, 0, additionalDataList.Count - 1);
            if SalesOrderLineADIndex <> -1 then
            begin
              CUR_ADDITIONALDATA_HEADER := additionalDataList.Items[SalesOrderLineADIndex];
              ValueFromTable := getAdditionalData(CUR_ADDITIONALDATA_HEADER.SalesOrderLineADList, CUR_PROP_RTV_VALUE.COLUMN_NAME,DataType);
            end;
          end;
          propertyValue := formatPropertyValueDirect(CUR_PROP,ValueFromTable, CompleteMqmFormat, CUR_PROP_RTV_VALUE);
        end

        else if (CUR_PROP_RTV_VALUE.TABLE_NAME = 'SALESORDERDELIVERY')  then
        begin
          ValueFromTable := '';
          if assigned(GenericDelivery) then
          begin
            RTV_VALUE := copy('SOD_' + CUR_PROP_RTV_VALUE.COLUMN_NAME, 1, 30);
            Index := GenericDelivery.ColumnNames.IndexOf(RTV_VALUE);
            if Index <> -1 then
              ValueFromTable := GenericDelivery.ColumnValue.Strings[Index];
          end;
          propertyValue := formatPropertyValueDirect(CUR_PROP, ValueFromTable, CompleteMqmFormat, CUR_PROP_RTV_VALUE);
        end

        else if (CUR_PROP_RTV_VALUE.TABLE_NAME = 'SalesOrderDelivery AD') then
        begin
          ValueFromTable := '';
          if assigned(GenericDelivery) then
          begin
            if SalesOrderDeliveryADIndex = -99 then
              SalesOrderDeliveryADIndex := searchInList(additionalDataList, 8, GenericDelivery.ABSUniqueId, 0, additionalDataList.Count - 1);
            if SalesOrderDeliveryADIndex <> -1 then
            begin
              CUR_ADDITIONALDATA_HEADER := additionalDataList.Items[SalesOrderDeliveryADIndex];
              ValueFromTable := getAdditionalData(CUR_ADDITIONALDATA_HEADER.SalesOrderDeliveryADList, CUR_PROP_RTV_VALUE.COLUMN_NAME,DataType);
            end;
          end;
          propertyValue := formatPropertyValueDirect(CUR_PROP,ValueFromTable, CompleteMqmFormat, CUR_PROP_RTV_VALUE);
        end

        else if (CUR_PROP_RTV_VALUE.TABLE_NAME = 'PROJECT')  then
        begin
          ValueFromTable := '';
          if assigned(GenericProject) then
          begin
            RTV_VALUE := copy('P_' + CUR_PROP_RTV_VALUE.COLUMN_NAME, 1, 30);
            Index := GenericProject.ColumnNames.IndexOf(RTV_VALUE);
            if Index <> -1 then
              ValueFromTable := GenericProject.ColumnValue.Strings[Index];
          end;
          propertyValue := formatPropertyValueDirect(CUR_PROP, ValueFromTable, CompleteMqmFormat, CUR_PROP_RTV_VALUE);
        end

        else if (CUR_PROP_RTV_VALUE.TABLE_NAME = 'Project AD') then
        begin
          ValueFromTable := '';
          if assigned(GenericProject) then
          begin
            if ProjectADIndex = -99 then
              ProjectADIndex := searchInList(additionalDataList, 8, GenericProject.ABSUniqueId, 0, additionalDataList.Count - 1);
            if ProjectADIndex <> -1 then
            begin
              CUR_ADDITIONALDATA_HEADER := additionalDataList.Items[ProjectADIndex];
              ValueFromTable := getAdditionalData(CUR_ADDITIONALDATA_HEADER.ProjectADList, CUR_PROP_RTV_VALUE.COLUMN_NAME, DataType);
            end;
          end;
          propertyValue := formatPropertyValueDirect(CUR_PROP,ValueFromTable, CompleteMqmFormat, CUR_PROP_RTV_VALUE);
        end

        else if (CUR_PROP_RTV_VALUE.TABLE_NAME = 'RECIPE')  then
        begin
          ValueFromTable := '';
          for K := 0 to Steps.Count - 1 do
          begin
            if Steps.Strings[k] <> CurStepNumber then continue;
            if Recipes.Strings[k] = '' then break;
            Generic := FindGenericBinarSearch(List_Generic, 'Recipe', strtofloat(Recipes.Strings[k]), 0, 0, 0, 0, 0);
            if not assigned(Generic) then break;
            RTV_VALUE := copy('R_' + CUR_PROP_RTV_VALUE.COLUMN_NAME, 1, 30);
            Index := Generic.ColumnNames.IndexOf(RTV_VALUE);
            if Index <> -1 then
              ValueFromTable := Generic.ColumnValue.Strings[Index];
            break;
          end;
          propertyValue := formatPropertyValueDirect(CUR_PROP, ValueFromTable, CompleteMqmFormat, CUR_PROP_RTV_VALUE);
        end

        else if (CUR_PROP_RTV_VALUE.TABLE_NAME = 'DESIGN')  then
        begin
          ValueFromTable := '';
          for K := 0 to Steps.Count - 1 do
          begin
            if Steps.Strings[k] <> CurStepNumber then continue;
            if Designs.Strings[k] = '' then break;
            Generic := FindGenericBinarSearch(List_Generic, 'Design', strtofloat(Designs.Strings[k]), 0, 0, 0, 0, 0);
            RTV_VALUE := copy('D_' + CUR_PROP_RTV_VALUE.COLUMN_NAME, 1, 30);
            Index := Generic.ColumnNames.IndexOf(RTV_VALUE);
            if Index <> -1 then
              ValueFromTable := Generic.ColumnValue.Strings[Index];
            break;
          end;
          propertyValue := formatPropertyValueDirect(CUR_PROP, ValueFromTable, CompleteMqmFormat, CUR_PROP_RTV_VALUE);
        end

        else if (CUR_PROP_RTV_VALUE.TABLE_NAME = 'Recipe AD') then
        begin
          ValueFromTable := '';
          for K := 0 to Steps.Count - 1 do
          begin
            if Steps.Strings[k] <> CurStepNumber then continue;
            if Recipes.Strings[k] = '' then break;
            if RecipeADIndex = -99 then
              RecipeADIndex := searchInList(additionalDataList, 8, Recipes.Strings[k], 0, additionalDataList.Count - 1);
            if RecipeADIndex = -1 then break;
            CUR_ADDITIONALDATA_HEADER := additionalDataList.Items[RecipeADIndex];
            ValueFromTable := getAdditionalData(CUR_ADDITIONALDATA_HEADER.RecipeADList, CUR_PROP_RTV_VALUE.COLUMN_NAME, DataType);
            break;
          end;
          propertyValue := formatPropertyValueDirect(CUR_PROP,ValueFromTable, CompleteMqmFormat, CUR_PROP_RTV_VALUE);
        end

        else if (CUR_PROP_RTV_VALUE.TABLE_NAME = 'Design AD') then
        begin
          ValueFromTable := '';
          for K := 0 to Steps.Count - 1 do
          begin
            if Steps.Strings[k] <> CurStepNumber then continue;
            if Designs.Strings[k] = '' then break;
            if DesignADIndex = -99 then
              DesignADIndex := searchInList(additionalDataList, 8, Designs.Strings[k], 0, additionalDataList.Count - 1);
            if DesignADIndex = -1 then break;
            CUR_ADDITIONALDATA_HEADER := additionalDataList.Items[DesignADIndex];
            ValueFromTable := getAdditionalData(CUR_ADDITIONALDATA_HEADER.DesignADList, CUR_PROP_RTV_VALUE.COLUMN_NAME, DataType);
            break;
          end;
          propertyValue := formatPropertyValueDirect(CUR_PROP,ValueFromTable, CompleteMqmFormat, CUR_PROP_RTV_VALUE);
        end

//        else if (CUR_PROP_RTV_VALUE.TABLE_NAME = 'UserGenericGroup AD Subcode01') then
        else if (copy(CUR_PROP_RTV_VALUE.TABLE_NAME, 1, 19) = 'UserGenericGroup AD') then
        begin
          SUBCODE := copy(CUR_PROP_RTV_VALUE.TABLE_NAME, 28, 2);
          ValueFromTable := '';
          Index := GetIndexForUserGenericGroupTable(SUBCODE, MQMProductionColumnValues, additionalDataList, UserGenericGroupTypeList, UserGenericGroupTypeAttributesList);
          if index <> -1 then
          begin
            CUR_ADDITIONALDATA_HEADER := additionalDataList.Items[index];
            ValueFromTable := getAdditionalData(CUR_ADDITIONALDATA_HEADER.UserGenericGroupADList, CUR_PROP_RTV_VALUE.COLUMN_NAME, DataType);
          end;
          propertyValue := formatPropertyValueDirect(CUR_PROP,ValueFromTable, CompleteMqmFormat, CUR_PROP_RTV_VALUE);
        end

        else if (copy(CUR_PROP_RTV_VALUE.TABLE_NAME, 1, 24) = 'UserGenericGroup Subcode') then
        begin
          SUBCODE := copy(CUR_PROP_RTV_VALUE.TABLE_NAME, 25, 2);
          ValueFromTable := getUserGenericGroupTypeAttribute(CUR_PROP_RTV_VALUE.COLUMN_NAME, SUBCODE, MQMProductionColumnValues,
                                                             UserGenericGroupTypeList, UserGenericGroupTypeAttributesList);
          propertyValue := formatPropertyValue(propertyList, CUR_PROP.PY_PROPERTY,ValueFromTable, CompleteMqmFormat, CUR_PROP_RTV_VALUE);
        end

        else if (copy(CUR_PROP_RTV_VALUE.TABLE_NAME, 1, 8) = 'Color AD') then
        begin
          ValueFromTable := '';
          SUBCODE := copy(CUR_PROP_RTV_VALUE.TABLE_NAME, 17, 2);
          Index := GetIndexForColorTable(SUBCODE, MQMProductionColumnValues, additionalDataList, ColorTypeList, ColorTypeUNIQUEIDList);
          if index <> -1 then
          begin
            CUR_ADDITIONALDATA_HEADER := additionalDataList.Items[index];
            ValueFromTable := getAdditionalData(CUR_ADDITIONALDATA_HEADER.ColorADList, CUR_PROP_RTV_VALUE.COLUMN_NAME, DataType);
          end;
          propertyValue := formatPropertyValueDirect(CUR_PROP,ValueFromTable, CompleteMqmFormat, CUR_PROP_RTV_VALUE);
        end
        else
        begin
          ValueFromTable := getValueFromTable(MQMProductionColumnValues, CUR_PROP_RTV_VALUE.TABLE_NAME,
                                                               CUR_PROP_RTV_VALUE.COLUMN_NAME, Items, additionalDataList,DataType);
          propertyValue := formatPropertyValueDirect(CUR_PROP, ValueFromTable, CompleteMqmFormat, CUR_PROP_RTV_VALUE);
        end;

        {if ((CUR_PROP_RTV_VALUE.From_Position > 0) and (CUR_PROP_RTV_VALUE.From_Position < 90))
           and ((CUR_PROP_RTV_VALUE.Length_From_Pos > 0) and (CUR_PROP_RTV_VALUE.Length_From_Pos < 90)) then

        begin
          if (CUR_PROP.PY_TYPE = '1') then
            propertyValue := copy(propertyValue, CUR_PROP_RTV_VALUE.From_Position, CUR_PROP_RTV_VALUE.Length_From_Pos)
          else
          begin
            try
              propertyValue := copy(propertyValue, CUR_PROP_RTV_VALUE.From_Position, CUR_PROP_RTV_VALUE.Length_From_Pos);
            except
              propertyValue := '0';
            end;
          end;
        end; }

      end;

      if HeaderProperty and not ProperyFoundInHeader then
      begin
        New(ReqTempProp);
        ReqTempProp.PropCode := CUR_PROP.PY_PROPERTY;
        ReqTempProp.PropVal := propertyValue;
        HeaderPropList.insert(IndexProperty, ReqTempProp);
      end;

{      if (DataType = 3) and (CUR_PROP.PY_TYPE = '1') and (CUR_PROP.PY_DESIGNATEDPROPERTY <> '2') then
      begin
        ValueDateTime := StrToDateTime(propertyValue);
        DecodeDate(ValueDateTime, myYear, myMonth, myDay);
        if CUR_PROP_RTV_VALUE.DATEFORMAT = '2' then
          propertyValue := formatdatetime('DD/MM/YYYY', ValueDateTime)
        else
          if CUR_PROP_RTV_VALUE.DATEFORMAT = '3' then
            propertyValue := formatdatetime('MM/DD/YYYY', ValueDateTime)
          else
            propertyValue := formatdatetime('YYYYMMDD', ValueDateTime); }
 //  {$ifdef MARCHI}
  //      propertyValue := formatdatetime('DD/MM/YYYY', ValueDateTime);
//{$endif}
  //    end;

      if CUR_PROP.PY_DESIGNATEDPROPERTY = '2' then
      begin
       { PTMQMPD(read_prod_step_list[read_prod_step_list.Count - 1]).PD_ApprovalDate := 0;
        if TryStrToDateTime(propertyValue, ValueDateTime) then
           PTMQMPD(read_prod_step_list[read_prod_step_list.Count - 1]).PD_ApprovalDate := StrToDateTime(propertyValue); }
{        try
          PTMQMPD(read_prod_step_list[read_prod_step_list.Count - 1]).PD_ApprovalDate := StrToDateTime(propertyValue);
        except
          PTMQMPD(read_prod_step_list[read_prod_step_list.Count - 1]).PD_ApprovalDate := 0;
        end;       }

        StandardDateFormat := FormatSettings.ShortDateFormat;
        FormatSettings.ShortDateFormat := 'yyyymmdd';
        PTMQMPD(read_prod_step_list[read_prod_step_list.Count - 1]).PD_ApprovalDate := 0;
        if TryStrToDateTime(propertyValue, ValueDateTime) then
           PTMQMPD(read_prod_step_list[read_prod_step_list.Count - 1]).PD_ApprovalDate := StrToDateTime(propertyValue);
        FormatSettings.ShortDateFormat := StandardDateFormat;
        continue;
      end;

      if (CUR_PROP.PY_DESIGNATEDPROPERTY = '3') then
      begin
        ServingCode := propertyValue;
        continue
      end;

      if (CUR_PROP.PY_DESIGNATEDPROPERTY = '4') then
      begin
        try
          PTMQMPD(read_prod_step_list[read_prod_step_list.Count - 1]).PD_LearningCurveCode := Trim(propertyValue);
        except
          PTMQMPD(read_prod_step_list[read_prod_step_list.Count - 1]).PD_LearningCurveCode := '';
        end;
        continue
      end;

      if (CUR_PROP.PY_DESIGNATEDPROPERTY = '5') then
      begin
        try
          N := StrToIntDef(propertyValue , 0);
          if N = 0 then
            propertyValue := '0';
          PTMQMPD(read_prod_step_list[read_prod_step_list.Count - 1]).PD_NumResComponents := StrToInt(Trim(propertyValue));
        except
          PTMQMPD(read_prod_step_list[read_prod_step_list.Count - 1]).PD_NumResComponents := 0;
        end;
        continue
      end;

      if (CUR_PROP.PY_DESIGNATEDPROPERTY = '6') then
      begin
        CurveFamily_IdCode := propertyValue;
        continue
      end;

      if HeaderProperty then
      begin

        if ProperyFoundInHeader then continue;

        New(NEW_PROP_PROD);
        NEW_PROP_PROD.PP_PREQ_NO := PREQ_NO;
        NEW_PROP_PROD.PP_PSTEP_ID := 0;
        NEW_PROP_PROD.PP_PROPERTY := CUR_PROP.PY_PROPERTY;
        NEW_PROP_PROD.PP_VALUE := propertyValue;

        VALUE_tmp_Double := 0;
        if CUR_PROP.PY_TYPE <> '1' then
        begin
          try
            VALUE_tmpStr := Trim(NEW_PROP_PROD.PP_VALUE);
            if VALUE_tmpStr <> '' then
               VALUE_tmp_Double := StrToFloat(VALUE_tmpStr);
          except
          end;

        end;

        NEW_PROP_PROD.PP_NUMERIC_VALUE := VALUE_tmp_Double;
        NEW_PROP_PROD.PP_USR_CG := 'USERNAME';
        NEW_PROP_PROD.PP_USR_TM_CG := NowTime;

        if mergeNeeded then
        begin
          NEW_PROP_PROD.PP_FAMILYCODE := PREQ_NO;
          m_NeedToMakeMerge := true
        end;

        read_prop_prod_list.Add(NEW_PROP_PROD);
        continue;
      end;

      New(NEW_PROP_PROD);
      NEW_PROP_PROD.PP_PREQ_NO := PREQ_NO;
      NEW_PROP_PROD.PP_PSTEP_ID := StrToIntDef(CurStepNumber, 0);
      NEW_PROP_PROD.PP_PROPERTY := CUR_PROP.PY_PROPERTY;
      //NEW_PROP_PROD.PP_RSC_CODE := CUR_PROP_RES.RP_RSC_CODE;
      NEW_PROP_PROD.PP_VALUE := propertyValue;

      VALUE_tmp_Double := 0;
      if CUR_PROP.PY_TYPE <> '1' then
      begin
        try
          VALUE_tmpStr := Trim(NEW_PROP_PROD.PP_VALUE);
          if VALUE_tmpStr <> '' then
            VALUE_tmp_Double := StrToFloat(VALUE_tmpStr);
        except
        end;
      end;
      NEW_PROP_PROD.PP_NUMERIC_VALUE := VALUE_tmp_Double;
      NEW_PROP_PROD.PP_USR_CG := 'USERNAME';
      NEW_PROP_PROD.PP_USR_TM_CG := NowTime;

      if mergeNeeded then
      begin
        NEW_PROP_PROD.PP_FAMILYCODE := PREQ_NO;
        m_NeedToMakeMerge := true
      end;

      read_prop_prod_list.Add(NEW_PROP_PROD);

    end;
  end;

end;

//----------------------------------------------------------------------------//

procedure insertIntoPROD_STEP_BATCH_SIZE_List(MQMProductionColumnValues: PMQMProductionColumnValues;
                                              handledWorkCentersList: TList;
                                              resList: TList;
                                              workCenterCode: String;
                                              //productPrimaryUomConversionDataList: TList;
                                              //secondaryUnitCategoryConversionList: TList;
                                              //stdUnitCategoryConversionList: TList;
                                              read_prod_step_batch_size_list: TList;
                                              Items : PTItems;
                                              productionDemandCounters : TList;
                                              CUR_PRODUCTIONDEMANDTEMPLATE: PPRODUCTIONDEMANDTEMPLATES);
var
  NEW_PROD_STEP_BATCH_SIZE: PTMQMSB;
  i: Integer;
  index: integer;
  CUR_WORKCENTER: PWORKCENTERS;
  P_ABSUNIQUEID, FIKD_ABSUNIQUEID, ITEMTYPEAFICODE : string;
  SUBCODE01, SUBCODE02, SUBCODE03, SUBCODE04, SUBCODE05,
  SUBCODE06, SUBCODE07, SUBCODE08, SUBCODE09, SUBCODE10 : string;
  ADDalternativeWork : boolean;
  ListIndex : Integer;
  PREQ_NO : string;
begin

  if assigned(Items) then
  begin
    FIKD_ABSUNIQUEID := Items.ABSUNIQUEID;
    P_ABSUNIQUEID    := Items.ABSUNIQUEID_P;
    ITEMTYPEAFICODE  := Items.ITEMTYPEAFICODE;
    SUBCODE01 := Items.SUBCODE01;
    SUBCODE02 := Items.SUBCODE02;
    SUBCODE03 := Items.SUBCODE03;
    SUBCODE04 := Items.SUBCODE04;
    SUBCODE05 := Items.SUBCODE05;
    SUBCODE06 := Items.SUBCODE06;
    SUBCODE07 := Items.SUBCODE07;
    SUBCODE08 := Items.SUBCODE08;
    SUBCODE09 := Items.SUBCODE09;
    SUBCODE10 := Items.SUBCODE10;
  end;

  index := searchInList(handledWorkCentersList, 1, Trim(workCenterCode),
                      0, handledWorkCentersList.Count - 1);

  if (index = -1) then exit;

  CUR_WORKCENTER :=  handledWorkCentersList.Items[index];

  for i := 0 to CUR_WORKCENTER.WC_Batch_UoM.Count - 1 do
  begin
    New(NEW_PROD_STEP_BATCH_SIZE);
    NEW_PROD_STEP_BATCH_SIZE.SB_PREQ_NO := setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COMPANYCODE', PD_COMPANYCODE), 3) +
                                           setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COUNTERCODE', PD_COUNTERCODE), 8) +
                                           getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_CODE', PD_CODE);
    NEW_PROD_STEP_BATCH_SIZE.SB_PSTEP_ID := StrToInt(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_STEPNUMBER', PDS_STEPNUMBER));
    NEW_PROD_STEP_BATCH_SIZE.SB_BCH_UM := CUR_WORKCENTER.WC_Batch_UoM[i];
    if Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_BASEPRIMARYUOMCODE', PD_BASEPRIMARYUOMCODE)) = Trim(CUR_WORKCENTER.WC_Batch_UoM[i]) then
      NEW_PROD_STEP_BATCH_SIZE.SB_MULTIPILR_TO_BATCH_UM := 1
    else
    begin
      NEW_PROD_STEP_BATCH_SIZE.SB_MULTIPILR_TO_BATCH_UM := ConvertUM(MQMProductionColumnValues, getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_BASEPRIMARYUOMCODE', PD_BASEPRIMARYUOMCODE),
                                                                     CUR_WORKCENTER.WC_Batch_UoM[i],
                                                                     1,
                                                                                      ITEMTYPEAFICODE, // getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ITEMTYPEAFICODE'),
                                                                                    {  getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE01') ,
                                                                                      getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE02') ,
                                                                                      getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE03') ,
                                                                                      getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE04') ,
                                                                                      getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE05') ,
                                                                                      getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE06') ,
                                                                                      getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE07') ,
                                                                                      getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE08') ,
                                                                                      getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE09') ,
                                                                                      getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_SUBCODE10')));  }
                                                                                      SUBCODE01, SUBCODE02, SUBCODE03, SUBCODE04, SUBCODE05,
                                                                                      SUBCODE06, SUBCODE07, SUBCODE08, SUBCODE09, SUBCODE10);

            {NEW_PROD_STEP_BATCH_SIZE.SB_MULTIPILR_TO_BATCH_UM := convertUnitOfMeasure(MQMProductionColumnValues,
                                                                    getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_BASEPRIMARYUOMCODE'),
                                                                    MQMRes.RS_BCH_UM, '1',
                                                                    productPrimaryUomConversionDataList,
                                                                    secondaryUnitCategoryConversionList,
                                                                    stdUnitCategoryConversionList,
                                                                    true); }

    end;

    if m_NeedToMakeMerge then
    begin
       PREQ_NO := NEW_PROD_STEP_BATCH_SIZE.SB_PREQ_NO;
       if CheckMerge(PREQ_NO, setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COUNTERCODE', PD_BASEPRIMARYUOMCODE), 8), productionDemandCounters) then
       begin
         NEW_PROD_STEP_BATCH_SIZE.SB_FAMILYCODE := PREQ_NO;
         m_NeedToMakeMerge := true
       end;
    end;

    read_prod_step_batch_size_list.Add(NEW_PROD_STEP_BATCH_SIZE);
  end;
end;

//----------------------------------------------------------------------------//

function getValueFromTable(MQMProductionColumnValues: PMQMProductionColumnValues;
                           tableName: String; columnName: String;
                           Items : PTItems;
                           additionalDataList: TList;
                           var DataType : Integer): String;
var
  CUR_ADDITIONALDATA_HEADER: PADDITIONALDATA_HEADERS;
  searchValue: String;
  index: integer;
begin
  Result := '';
  DataType := 0;

  if Assigned(Items) and (((Trim(tableName) = 'FULLITEMKEYDECODER') OR (Trim(tableName) = 'FullItemKeyDecoder AD'))) then
    searchValue := Items.ABSUNIQUEID   //getValueOfTheProductionColumn(MQMProductionColumnValues, 'FIKD_ABSUNIQUEID')
  else if ((Trim(tableName) = 'PRODUCTIONDEMANDSTEP') OR (Trim(tableName) = 'ProductionDemandStep AD')) then
    searchValue := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_ABSUNIQUEID', PDS_ABSUNIQUEID)
  else if ((Trim(tableName) = 'PRODUCTIONDEMAND') OR (Trim(tableName) = 'ProductionDemand AD')) then
    searchValue := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ABSUNIQUEID', PD_ABSUNIQUEID)
  else if Assigned(Items) and (((Trim(tableName) = 'PRODUCT') OR (Trim(tableName) = 'Product AD'))) then
    searchValue := Items.ABSUNIQUEID_P;  //getValueOfTheProductionColumn(MQMProductionColumnValues, 'P_ABSUNIQUEID');

  index := searchInList(additionalDataList, 8, searchValue,
                        0, additionalDataList.Count - 1);

  CUR_ADDITIONALDATA_HEADER := nil;
  if ( index <> -1 ) then
    CUR_ADDITIONALDATA_HEADER := additionalDataList.Items[index];

  if ( (Trim(tableName) <> '') AND (Trim(columnName) <> '') ) then
  begin
    if (Trim(tableName) = 'FULLITEMKEYDECODER') and Assigned(Items) then
      Result := Items.ABSUNIQUEID   //getValueOfTheProductionColumn(MQMProductionColumnValues, 'FIKD_' + Trim(columnName))
    else if (Trim(tableName) = 'PRODUCTIONDEMANDSTEP') then
      Result := getValueOfTheProductionColumnByFindPos(MQMProductionColumnValues, 'PDS_' + Trim(columnName))
    else if (Trim(tableName) = 'PRODUCTIONDEMAND')  then
      Result := getValueOfTheProductionColumnByFindPos(MQMProductionColumnValues, 'PD_' + Trim(columnName))
    else if (Trim(tableName) = 'PRODUCT') and Assigned(Items) then
      Result := Items.ABSUNIQUEID_P  //getValueOfTheProductionColumn(MQMProductionColumnValues, 'P_' + Trim(columnName))
    else if (Trim(tableName) = 'Product AD')  then
    begin
      if ( index <> -1 ) then
        Result := getAdditionalData(CUR_ADDITIONALDATA_HEADER.productADList,
                                    columnName,DataType);
    end
    else if (Trim(tableName) = 'FullItemKeyDecoder AD')  then
    begin
      if ( index <> -1 ) then
        Result := getAdditionalData(CUR_ADDITIONALDATA_HEADER.fullItemKeyDecoderADList,
                                    columnName, DataType);
    end
    else if (Trim(tableName) = 'ProductionDemand AD')  then
    begin
      if ( index <> -1 ) then
        Result := getAdditionalData(CUR_ADDITIONALDATA_HEADER.productionDemandADList,
                                    columnName, DataType);
    end
    else if (Trim(tableName) = 'ProductionDemandStep AD')  then
    begin
      if ( index <> -1 ) then
        Result := getAdditionalData(CUR_ADDITIONALDATA_HEADER.productionDemandStepADList,
                                    columnName, DataType);
    end;
  end;
end;

//----------------------------------------------------------------------------//

function getAdditionalData(listOfAdditionalData: TList; columnName: String; var DataType : Integer): String;
var
  CUR_ADDITIONALDATA_DETAIL: PADDITIONALDATA_DETAILS;
  indexOfData, I : integer;
begin
  Result := '';

//  No binaric searh - the list is not sorted sine there are no much values inside
//  indexOfData := searchInList(listOfAdditionalData, 9, columnName, 0,
//                              listOfAdditionalData.Count - 1);
  indexOfData := -1;

  for I := 0 to listOfAdditionalData.Count - 1 do
  begin
    CUR_ADDITIONALDATA_DETAIL := PADDITIONALDATA_DETAILS(listOfAdditionalData[I]);
    if CUR_ADDITIONALDATA_DETAIL.FIELDNAME = columnName then
    begin
      indexOfData := I;
      break
    end;
  end;

  if ( indexOfData <> -1 ) then
  begin
    CUR_ADDITIONALDATA_DETAIL := listOfAdditionalData.Items[indexOfData];
    Result := CUR_ADDITIONALDATA_DETAIL.VALUE;
    DataType := CUR_ADDITIONALDATA_DETAIL.DataType;
  end;
end;

//----------------------------------------------------------------------------//

procedure fillAlternativeWorkCentersAndProcesses(handledWorkCentersList: TList;
                                       alternativeWorkCenters: TStringList;
                                       alternativeWorkCenterProcesses: TStringList;
                                       workCenterCode: String; operationCode: String);
var
  i: Integer;

  CUR_WORKCENTER: PWORKCENTERS;
  CUR_PROCESS: PPROCESSES;

  index: integer;
begin
  alternativeWorkCenters.Clear;
  alternativeWorkCenters.Add( Trim(workCenterCode) );

  alternativeWorkCenterProcesses.Clear;
  alternativeWorkCenterProcesses.Add( Trim(operationCode) );

  index := searchInList(handledWorkCentersList, 1, Trim(workCenterCode),
                      0, handledWorkCentersList.Count - 1);

  if ( index <> -1 ) then
  begin
    CUR_WORKCENTER :=  handledWorkCentersList.Items[index];

    index := searchInList(CUR_WORKCENTER.Process_List, 2, Trim(operationCode),
                          0, CUR_WORKCENTER.Process_List.Count - 1);

    if ( index <> -1 ) then
    begin
      CUR_PROCESS :=  CUR_WORKCENTER.Process_List.Items[index];

      for i := 0 to CUR_PROCESS.Alternatives_List.Count - 1 do
      begin
        alternativeWorkCenters.Add( Trim(CUR_PROCESS.Alternatives_List[i]) );
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure fillResTableToList(ArcQry: TMqmQuery; resList: TList);
var
  srvSqlStr, tblArcName: String;
  MQMRes: PMQMRes;
  DndArchiveArcName : TDndArchiveName;
  fldRscCode, fldWkcnter: TField;
  fldStdBchSize, fldMinBchSize, fldMaxBchSize, fldBchUM: TField;
begin
  DndArchiveArcName := GetDndArchiveLocalName;
  if DndArchiveArcName = TD_Interbase then
    tblArcName  := 'RES'
  else
    tblArcName  := 'SCDA_' + 'RES';

  srvSqlStr := 'SELECT RS_RSC_CODE, RS_WKCNTER, ' +
               'RS_STANDRD_BCH_SIZE, RS_MIN_BCH_SIZE, ' +
               'RS_MAX_BCH_SIZE, RS_BCH_UM ' +
               'FROM ' + tblArcName + WHERE_IDF_Condition('RS_IDENTIFIER') + ' ORDER BY RS_RSC_CODE';
  ArcQry.SQL.Text := srvSqlStr;
  ArcQry.Active := true;
  fldRscCode    := ArcQry.FieldByName('RS_RSC_CODE');
  fldWkcnter    := ArcQry.FieldByName('RS_WKCNTER');
  fldStdBchSize := ArcQry.FieldByName('RS_STANDRD_BCH_SIZE');
  fldMinBchSize := ArcQry.FieldByName('RS_MIN_BCH_SIZE');
  fldMaxBchSize := ArcQry.FieldByName('RS_MAX_BCH_SIZE');
  fldBchUM      := ArcQry.FieldByName('RS_BCH_UM');

  while ( not ArcQry.Eof ) do
  begin
    New(MQMRes);
    MQMRes.RS_RSC_CODE         := fldRscCode.AsString;
    MQMRes.RS_WKCNTER          := fldWkcnter.AsString;

    if ( Trim(fldStdBchSize.AsString) <> '' ) then
      MQMRes.RS_STANDRD_BCH_SIZE := fldStdBchSize.AsString
    else
      MQMRes.RS_STANDRD_BCH_SIZE := '0';

    if ( Trim(fldMinBchSize.AsString) <> '' ) then
      MQMRes.RS_MIN_BCH_SIZE := fldMinBchSize.AsString
    else
      MQMRes.RS_MIN_BCH_SIZE := '0';

    if ( Trim(fldMaxBchSize.AsString) <> '' ) then
      MQMRes.RS_MAX_BCH_SIZE := fldMaxBchSize.AsString
    else
      MQMRes.RS_MAX_BCH_SIZE := '0';

    MQMRes.RS_BCH_UM := fldBchUM.AsString;

    resList.Add(MQMRes);
    ArcQry.Next;
  end;
  ArcQry.Active := false;
end;

//----------------------------------------------------------------------------//

procedure fillProductsToList(LocalQry: TMqmQuery; currentProductsList: TList);
var
  srvSqlStr, TableName: String;
  NEWPRODUCT: PPRODUCTS;
  DndArchiveArcName : TDndArchiveName;
begin
  DndArchiveArcName := GetDndArchiveLocalName;

  TableName := 'PRODUCTS';
  if DndArchiveArcName <> TD_Interbase then
    TableName  := 'SCDM_' + 'PRODUCTS';

  srvSqlStr := 'SELECT * FROM ' + TableName + WHERE_IDF_Condition('PAR_IDENTIFIER') + ' ORDER BY PAR_TYPE_PROD, PAR_PRODUCT_CODE';
  LocalQry.SQL.Text := srvSqlStr;
  LocalQry.Active := true;

  Var PAR_TYPE_PROD_FIELD := LocalQry.FieldByName('PAR_TYPE_PROD');
  var PAR_PRODUCT_CODE_FIELD := LocalQry.FieldByName('PAR_PRODUCT_CODE');
  var PAR_PRODUT_NATURE_FIELD := LocalQry.FieldByName('PAR_PRODUT_NATURE');
  var PAR_STR_CONS_POINT_FIELD := LocalQry.FieldByName('PAR_STR_CONS_POINT');
  var PAR_END_CONS_POINT_FIELD := LocalQry.FieldByName('PAR_END_CONS_POINT');
  var PAR_INFO_AREA_FIELD := LocalQry.FieldByName('PAR_INFO_AREA');
  var PAR_STDPURCORPRODTIME_FIELD := LocalQry.FieldByName('PAR_STDPURCORPRODTIME');
  var PAR_MATERIAL_TOLLERANCE_CODE_FIELD := LocalQry.FieldByName('PAR_MATERIAL_TOLLERANCE_CODE');
  var PAR_STANDARD_SPEED_Warp  := LocalQry.FieldByName('PAR_MAT_STANDARD_SPEED');
  var PAR_STANDARD_SETMIN_Warp := LocalQry.FieldByName('PAR_MAT_STANDARD_SETMIN');
  var PAR_SCHEDULE_Warp        := LocalQry.FieldByName('PAR_MAT_SCHEDULE_TYPE');
  var PAR_HOURSTODOWNFROMMACHINE := LocalQry.FieldByName('PAR_HOURSTODOWNFROMMACHINE');

  while ( not LocalQry.Eof ) do
  begin
    New(NEWPRODUCT);
    NEWPRODUCT.PRODUCT_KEY           := setStringLengthTo(PAR_TYPE_PROD_FIELD.AsString, 3, true, ' ') +
                                        Trim(PAR_PRODUCT_CODE_FIELD.AsString);
    NEWPRODUCT.PAR_TYPE_PROD         := Trim(PAR_TYPE_PROD_FIELD.AsString);
    NEWPRODUCT.PAR_PRODUCT_CODE      := Trim(PAR_PRODUCT_CODE_FIELD.AsString);
    NEWPRODUCT.PAR_PRODUT_NATURE     := Trim(PAR_PRODUT_NATURE_FIELD.AsString);
    NEWPRODUCT.PAR_STR_CONS_POINT    := Trim(PAR_STR_CONS_POINT_FIELD.AsString);
    NEWPRODUCT.PAR_END_CONS_POINT    := Trim(PAR_END_CONS_POINT_FIELD.AsString);
    NEWPRODUCT.PAR_INFO_AREA         := Trim(PAR_INFO_AREA_FIELD.AsString);
    NEWPRODUCT.PAR_STDPURCORPRODTIME := Trim(PAR_STDPURCORPRODTIME_FIELD.AsString);
    NEWPRODUCT.PAR_MATERIAL_TOLLERANCE_CODE := Trim(PAR_MATERIAL_TOLLERANCE_CODE_FIELD.AsString);
    NEWPRODUCT.PAR_HOURSTODOWNFROMMACHINE   := PAR_HOURSTODOWNFROMMACHINE.AsInteger;
    NEWPRODUCT.PAR_SCHEDULE_Warp            := Trim(PAR_SCHEDULE_Warp.AsString);
    NEWPRODUCT.PAR_STANDARD_SPEED_Warp      := PAR_STANDARD_SPEED_Warp.AsFloat;
    NEWPRODUCT.PAR_STANDARD_SETMIN_Warp     := PAR_STANDARD_SETMIN_Warp.AsFloat;

    currentProductsList.Add(NEWPRODUCT);
    LocalQry.Next;
  end;
  currentProductsList.Sort(Sort_PRODUCTS);

  LocalQry.Active := false;
end;

//----------------------------------------------------------------------------//

function FindItemProductInProductList(ItemType : string; ProductCode : string; var Index : integer; currentProductsList : TList) : PPRODUCTS;
var
  i: integer;
  Multiplier, NumberOfEntries, NumberOfEntriesMinusOne : integer;
begin
  Result := nil;
  NumberOfEntries := currentProductsList.Count;
  Index := NumberOfEntries;

  if NumberOfEntries = 0 then exit;
  NumberOfEntriesMinusOne := NumberOfEntries - 1;

  Multiplier := 1;
  while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    i := Multiplier - 1;

  while (Multiplier > 0) do
  begin
    Multiplier := trunc(Multiplier / 2);

    if (i > NumberOfEntriesMinusOne) then
    begin
      i := i - Multiplier;
      Continue;
    end;

    if (PPRODUCTS(currentProductsList[i]).PAR_TYPE_PROD > ItemType) then
    begin
      if I < Index then Index := I;
      i := i - Multiplier;
      Continue;
    end;

    if  (PPRODUCTS(currentProductsList[i]).PAR_TYPE_PROD < ItemType) then
    begin
      i := i + Multiplier;
      Continue;
    end;

    if  (PPRODUCTS(currentProductsList[i]).PAR_PRODUCT_CODE > ProductCode) then
    begin
      if I < Index then Index := I;
      i := i - Multiplier;
      Continue;
    end;

    if  (PPRODUCTS(currentProductsList[i]).PAR_PRODUCT_CODE < ProductCode) then
    begin
      i := i + Multiplier;
      Continue;
    end;

    Result := PPRODUCTS(currentProductsList[i]);
    Index := i;
    Break;

  end;

end;

//----------------------------------------------------------------------------//

procedure checkIfNeedToInsertNewWarpProductionToDatabase(LocalQry : TMqmQuery; currentProductsList : TList; List_Items : TList);
var
  I, J : Integer;
  Items : PTITEMS;
  Index : integer;
  REC_PRODUCT : PPRODUCTS;
  prodCode : string;
begin
  for I := 0 to List_Items.Count - 1 do
  begin
    Items := PTITEMS(List_Items[I]);
    if (Items.MAT_SCHEDULE_Type_Warp <> '1') and (Items.MAT_SCHEDULE_Type_Warp <> '2') then continue;

    prodCode := getFullItemKeyCode(Items.ITEMTYPEAFICODE,
                                     Items.SUBCODE01,
                                     Items.SUBCODE02,
                                     Items.SUBCODE03,
                                     Items.SUBCODE04,
                                     Items.SUBCODE05,
                                     Items.SUBCODE06,
                                     Items.SUBCODE07,
                                     Items.SUBCODE08,
                                     Items.SUBCODE09,
                                     Items.SUBCODE10);
    REC_PRODUCT := FindItemProductInProductList(Items.ITEMTYPEAFICODE, prodCode, Index, currentProductsList);
    if assigned(REC_PRODUCT) then continue;

      insertIntoPRODUCTS(LocalQry, Items.ITEMTYPEAFICODE, prodCode, '1', '0', '0',
                            Items.SEARCHDESCRIPTION_P,
                             '0', '', 0, Items.MAT_STANDARD_SPEED_Warp, Items.MAT_STANDARD_SETMIN_Warp, Items.MAT_SCHEDULE_Type_Warp);

  end;
end;

//----------------------------------------------------------------------------//

procedure fillProductionDemandTemplateStruct(LocalQry : TMqmQuery; ArcQry : TMqmQuery; productionDemandTemplates: TList;
       var AD_Recipe_FieldsList : TStringList; var AD_Design_FieldsList : TStringList;
       var AD_Product_FieldsList : TStringList; var AD_FullItemKeyDecoder_FieldsList : TStringList;
       var AD_ProductionDemandStep_FieldsList : TStringList;  var AD_ProductionDemand_FieldsList : TStringList;
       var TNA_List1 : TStringList; var TNA_List2 : TStringList);
var
  srvSqlStr: String;
  NEWPRODUCTIONDEMANDTEMPLATE: PPRODUCTIONDEMANDTEMPLATES;
  TableName : string;
  DndArchiveArcName : TDndArchiveName;
  CODE_FIELD, HANDLEDBYMQM_FIELD, HANDLEDBYMCM_FIELD, SERVEDCODETABLENAME_FIELD, SERVEDCODECOLUMNAME_FIELD,
  SERVINGCODETABLENAME_FIELD, SERVINGCODECOLUMNAME_FIELD,SERVINGCODEDEFNITION_FIELD,
  SERVEDCODEDEFNITION_FIELD, ITEMTYPESERVED_FIELD, TNA_FIELD : TField;
begin
  DndArchiveArcName := GetDndArchiveLocalName;
  TableName := 'PRODUCTIONDEMANDTEMPLATE';
  if DndArchiveArcName <> TD_Interbase then
    TableName  := 'SCDA_' + 'PRODUCTIONDEMANDTEMPLATE';

  srvSqlStr := 'SELECT * ' +
               'FROM ' + TableName +
               ' WHERE (HANDLEDBYMCM = ' + QuotedStr('1') + ' OR ' +  'HANDLEDBYMQM = ' + QuotedStr('2') + ' OR ' +
               'HANDLEDBYMQM = ' + QuotedStr('1') + ' )' + AND_IDF_Condition('IDENTIFIER') + 'ORDER BY CODE';
  ArcQry.SQL.Text := srvSqlStr;
  ArcQry.Active := true;

  CODE_FIELD := ArcQry.FieldByName('CODE');
  HANDLEDBYMQM_FIELD :=  ArcQry.FieldByName('HANDLEDBYMQM');
  HANDLEDBYMCM_FIELD :=  ArcQry.FieldByName('HANDLEDBYMCM');
  SERVEDCODETABLENAME_FIELD := ArcQry.FieldByName('SERVEDCODETABLENAME');
  SERVEDCODECOLUMNAME_FIELD := ArcQry.FieldByName('SERVEDCODECOLUMNAME');
  SERVINGCODETABLENAME_FIELD := ArcQry.FieldByName('SERVINGCODETABLENAME');
  SERVINGCODECOLUMNAME_FIELD := ArcQry.FieldByName('SERVINGCODECOLUMNAME');
  SERVINGCODEDEFNITION_FIELD := ArcQry.FieldByName('SERVINGCODEDEFNITION');
  SERVEDCODEDEFNITION_FIELD := ArcQry.FieldByName('SERVEDCODEDEFNITION');
  ITEMTYPESERVED_FIELD := ArcQry.FieldByName('ITEMTYPESERVED');
  TNA_FIELD :=  ArcQry.FieldByName('TNAORIGIN');

  while ( not ArcQry.Eof ) do
  begin
    New(NEWPRODUCTIONDEMANDTEMPLATE);

    NEWPRODUCTIONDEMANDTEMPLATE.CODE := TRIM(CODE_FIELD.AsString);
    NEWPRODUCTIONDEMANDTEMPLATE.HANDLEDBYMQM := TRIM(HANDLEDBYMQM_FIELD.AsString);
    NEWPRODUCTIONDEMANDTEMPLATE.HANDLEDBYMCM := TRIM(HANDLEDBYMCM_FIELD.AsString);
 //   NEWPRODUCTIONDEMANDTEMPLATE.DAYSTOKEEPHISTORY := srvQryFD.FieldByName('DAYSTOKEEPHISTORY').AsString;
    NEWPRODUCTIONDEMANDTEMPLATE.SERVEDCODETABLENAME  := Trim(SERVEDCODETABLENAME_FIELD.AsString);
    NEWPRODUCTIONDEMANDTEMPLATE.SERVEDCODECOLUMNAME  := Trim(SERVEDCODECOLUMNAME_FIELD.AsString);
    NEWPRODUCTIONDEMANDTEMPLATE.SERVINGCODETABLENAME := Trim(SERVINGCODETABLENAME_FIELD.AsString);
    NEWPRODUCTIONDEMANDTEMPLATE.SERVINGCODECOLUMNAME := Trim(SERVINGCODECOLUMNAME_FIELD.AsString);
    NEWPRODUCTIONDEMANDTEMPLATE.SERVINGCODEDEFNITION  := Trim(SERVINGCODEDEFNITION_FIELD.AsString);
    NEWPRODUCTIONDEMANDTEMPLATE.SERVEDCODEDEFNITION  := Trim(SERVEDCODEDEFNITION_FIELD.AsString);
    NEWPRODUCTIONDEMANDTEMPLATE.ITEMTYPESERVED := Trim(ITEMTYPESERVED_FIELD.AsString);
    NEWPRODUCTIONDEMANDTEMPLATE.TNAORIGIN := TNA_FIELD.asString;

    productionDemandTemplates.Add(NEWPRODUCTIONDEMANDTEMPLATE);

    //TNA
    if NEWPRODUCTIONDEMANDTEMPLATE.TNAORIGIN = '1' then
      if TNA_List1.IndexOf(NEWPRODUCTIONDEMANDTEMPLATE.CODE) = -1 then
        TNA_List1.Add(NEWPRODUCTIONDEMANDTEMPLATE.CODE);

    if NEWPRODUCTIONDEMANDTEMPLATE.TNAORIGIN = '2' then
      if TNA_List2.IndexOf(NEWPRODUCTIONDEMANDTEMPLATE.CODE) = -1 then
        TNA_List2.Add(NEWPRODUCTIONDEMANDTEMPLATE.CODE);

    if NEWPRODUCTIONDEMANDTEMPLATE.SERVEDCODETABLENAME = 'Product AD' then
    begin
      if NEWPRODUCTIONDEMANDTEMPLATE.SERVEDCODECOLUMNAME <> '' then
        if AD_Product_FieldsList.IndexOf(NEWPRODUCTIONDEMANDTEMPLATE.SERVEDCODECOLUMNAME) = -1 then
          AD_Product_FieldsList.add(NEWPRODUCTIONDEMANDTEMPLATE.SERVEDCODECOLUMNAME);
    end
    else if NEWPRODUCTIONDEMANDTEMPLATE.SERVEDCODETABLENAME = 'FullItemKeyDecoder AD' then
    begin
      if NEWPRODUCTIONDEMANDTEMPLATE.SERVEDCODECOLUMNAME <> '' then
       if AD_FullItemKeyDecoder_FieldsList.IndexOf(NEWPRODUCTIONDEMANDTEMPLATE.SERVEDCODECOLUMNAME) = -1 then
          AD_FullItemKeyDecoder_FieldsList.add(NEWPRODUCTIONDEMANDTEMPLATE.SERVEDCODECOLUMNAME);
    end
    else if NEWPRODUCTIONDEMANDTEMPLATE.SERVEDCODETABLENAME = 'ProductionDemandStep AD' then
    begin
      if NEWPRODUCTIONDEMANDTEMPLATE.SERVEDCODECOLUMNAME <> '' then
        if AD_ProductionDemandStep_FieldsList.IndexOf(NEWPRODUCTIONDEMANDTEMPLATE.SERVEDCODECOLUMNAME) = -1 then
           AD_ProductionDemandStep_FieldsList.add(NEWPRODUCTIONDEMANDTEMPLATE.SERVEDCODECOLUMNAME);
    end
    else if NEWPRODUCTIONDEMANDTEMPLATE.SERVEDCODETABLENAME = 'ProductionDemand AD' then
    begin
      if NEWPRODUCTIONDEMANDTEMPLATE.SERVEDCODECOLUMNAME <> '' then
        if AD_ProductionDemand_FieldsList.IndexOf(NEWPRODUCTIONDEMANDTEMPLATE.SERVEDCODECOLUMNAME) = -1 then
          AD_ProductionDemand_FieldsList.add(NEWPRODUCTIONDEMANDTEMPLATE.SERVEDCODECOLUMNAME);
    end;

    if NEWPRODUCTIONDEMANDTEMPLATE.SERVINGCODETABLENAME = 'Product AD' then
    begin
      if NEWPRODUCTIONDEMANDTEMPLATE.SERVINGCODECOLUMNAME <> '' then
        if AD_Product_FieldsList.IndexOf(NEWPRODUCTIONDEMANDTEMPLATE.SERVINGCODECOLUMNAME) = -1 then
          AD_Product_FieldsList.add(NEWPRODUCTIONDEMANDTEMPLATE.SERVINGCODECOLUMNAME);
    end
    else if NEWPRODUCTIONDEMANDTEMPLATE.SERVINGCODETABLENAME = 'FullItemKeyDecoder AD' then
    begin
      if NEWPRODUCTIONDEMANDTEMPLATE.SERVINGCODECOLUMNAME <> '' then
       if AD_FullItemKeyDecoder_FieldsList.IndexOf(NEWPRODUCTIONDEMANDTEMPLATE.SERVINGCODECOLUMNAME) = -1 then
          AD_FullItemKeyDecoder_FieldsList.add(NEWPRODUCTIONDEMANDTEMPLATE.SERVINGCODECOLUMNAME);
    end
    else if NEWPRODUCTIONDEMANDTEMPLATE.SERVINGCODETABLENAME = 'ProductionDemandStep AD' then
    begin
      if NEWPRODUCTIONDEMANDTEMPLATE.SERVINGCODECOLUMNAME <> '' then
        if AD_ProductionDemandStep_FieldsList.IndexOf(NEWPRODUCTIONDEMANDTEMPLATE.SERVINGCODECOLUMNAME) = -1 then
           AD_ProductionDemandStep_FieldsList.add(NEWPRODUCTIONDEMANDTEMPLATE.SERVINGCODECOLUMNAME);
    end
    else if NEWPRODUCTIONDEMANDTEMPLATE.SERVINGCODETABLENAME = 'ProductionDemand AD' then
    begin
      if NEWPRODUCTIONDEMANDTEMPLATE.SERVINGCODECOLUMNAME <> '' then
        if AD_ProductionDemand_FieldsList.IndexOf(NEWPRODUCTIONDEMANDTEMPLATE.SERVINGCODECOLUMNAME) = -1 then
          AD_ProductionDemand_FieldsList.add(NEWPRODUCTIONDEMANDTEMPLATE.SERVINGCODECOLUMNAME);
    end;

    ArcQry.Next;
  end;
  productionDemandTemplates.Sort(Sort_PRODUCTIONDEMANDTEMPLATES);
  ArcQry.Active := false;
end;

//----------------------------------------------------------------------------//

function getStandardUnitCategoryForWeight(HostQry: TMqmQuery): String;
var
  hostSqlStr: String;
begin
  hostSqlStr := 'SELECT BASEUNITOFMEASURECODE FROM STANDARDUNITCATEGORY ' +
                'WHERE TYPE = ' + QuotedStr('1');

  HostQry.SQL.Text := hostSqlStr;
  hostQry.Open;

  if not HostQry.Eof then
  begin
    //result := Trim(HostQry.FieldByName('BASEUNITOFMEASURECODE').AsString);
    result := HostQry.FieldByName('BASEUNITOFMEASURECODE').AsString;
  end;
  HostQry.Close;
end;

//----------------------------------------------------------------------------//

procedure fillOperationsToList(HostQry: TMqmQuery; companyCode: String;
                               operationList: TList);
var
  hostSqlStr: String;
  NEWOPERATION: POPERATIONS;
  CompanyInUsed : string;
begin

  if not GetCompanyLevelHandlingByEntityName('OPERATION',  CompanyInUsed) then
     CompanyInUsed := IniAppGlobals.CompanyCode;

  hostSqlStr := 'SELECT CODE, LINKEDTIME1, LINKEDTIME2, LINKEDTIME3, ' +
                'LINKEDTIME4, LINKEDTIME5 FROM OPERATION WHERE ' +
                'COMPANYCODE = ' + QuotedStr(CompanyInUsed) + ' ORDER BY CODE';

  HostQry.SQL.Text := hostSqlStr;
  hostQry.Open;

  var CODE_FIELD := HostQry.FieldByName('CODE');
  var LINKEDTIME1_FIELD := HostQry.FieldByName('LINKEDTIME1');
  var LINKEDTIME2_FIELD := HostQry.FieldByName('LINKEDTIME2');
  var LINKEDTIME3_FIELD := HostQry.FieldByName('LINKEDTIME3');
  var LINKEDTIME4_FIELD := HostQry.FieldByName('LINKEDTIME4');
  var LINKEDTIME5_FIELD := HostQry.FieldByName('LINKEDTIME5');

  while ( not HostQry.Eof ) do
  begin
    New(NEWOPERATION);

    NEWOPERATION.CODE        := Trim(CODE_FIELD.AsString);
    NEWOPERATION.LINKEDTIME1 := Trim(LINKEDTIME1_FIELD.AsString);
    NEWOPERATION.LINKEDTIME2 := Trim(LINKEDTIME2_FIELD.AsString);
    NEWOPERATION.LINKEDTIME3 := Trim(LINKEDTIME3_FIELD.AsString);
    NEWOPERATION.LINKEDTIME4 := Trim(LINKEDTIME4_FIELD.AsString);
    NEWOPERATION.LINKEDTIME5 := Trim(LINKEDTIME5_FIELD.AsString);

    operationList.Add(NEWOPERATION);

    HostQry.Next;
  end;
  operationList.sort(Sort_OPERATIONS);
  HostQry.Close;
end;

//----------------------------------------------------------------------------//

procedure fillLogicalWarehousesToList(ArcQry: TMqmQuery; HostQry : TMqmQuery; logicalWarehouseList: TList);
var
  srvSqlStr, TableName,  hostSqlStr, CompanyInUsed : String;
  NEWLOGICALWAREHOUSE, CUR_LOGICALWAREHOUSE : PLOGICALWAREHOUSES;
  DndArchiveArcName : TDndArchiveName;
  index : integer;
begin
  DndArchiveArcName := GetDndArchiveLocalName;

  TableName := 'LOGICALWAREHOUSE';
  if DndArchiveArcName <> TD_Interbase then
    TableName  := 'SCDA_' + 'LOGICALWAREHOUSE';

  srvSqlStr := 'SELECT CODE, MQMGROUPCODE FROM ' + TableName + WHERE_IDF_Condition('IDENTIFIER') + ' ORDER BY CODE';
  ArcQry.SQL.Text := srvSqlStr;
  ArcQry.Active := true;

  var CODE_FIELD := ArcQry.FieldByName('CODE');
  var MQMGROUPCODE_FIELD := ArcQry.FieldByName('MQMGROUPCODE');

  while ( not ArcQry.Eof ) do
  begin
    New(NEWLOGICALWAREHOUSE);

    NEWLOGICALWAREHOUSE.CODE         := Trim(CODE_FIELD.AsString);
    NEWLOGICALWAREHOUSE.MQMGROUPCODE := Trim(MQMGROUPCODE_FIELD.AsString);
    NEWLOGICALWAREHOUSE.ProjectControlled := false;
    NEWLOGICALWAREHOUSE.StatisticalGroupControlled := false;
    NEWLOGICALWAREHOUSE.CustomerControlled := false;
    NEWLOGICALWAREHOUSE.SupplierControlled := false;

    logicalWarehouseList.Add(NEWLOGICALWAREHOUSE);
    ArcQry.Next;
  end;
  logicalWarehouseList.Sort(Sort_LOGICALWAREHOUSES);
  ArcQry.Active := false;

  if not GetCompanyLevelHandlingByEntityName('LOGICALWAREHOUSE',  CompanyInUsed) then
     CompanyInUsed := IniAppGlobals.CompanyCode;

  hostSqlStr := 'SELECT CODE, PROJECTCONTROLLED, STATISTICALGROUPCONTROLLED, CUSTOMERCONTROLLED, SUPPLIERCONTROLLED ' +
                'FROM LOGICALWAREHOUSE WHERE ( COMPANYCODE =  '+ QuotedStr('') +
                ' OR COMPANYCODE = ' + QuotedStr(CompanyInUsed) + ' ) ' +
                ' AND (PROJECTCONTROLLED = 1 or STATISTICALGROUPCONTROLLED = 1 or CUSTOMERCONTROLLED = 1 or SUPPLIERCONTROLLED = 1) ';

  HostQry.SQL.Text := hostSqlStr;
  hostQry.Open;

  var CODE_FIELD1 := HostQry.FieldByName('CODE');
  var PROJECTCONTROLLED_FIELD := HostQry.FieldByName('PROJECTCONTROLLED');
  var STATISTICALGROUPCONTROLLED_FIELD := HostQry.FieldByName('STATISTICALGROUPCONTROLLED');
  var CUSTOMERCONTROLLED_FIELD := HostQry.FieldByName('CUSTOMERCONTROLLED');
  var SUPPLIERCONTROLLED_FIELD := HostQry.FieldByName('SUPPLIERCONTROLLED');

  while ( not hostQry.Eof ) do
  begin
    index := searchInList(logicalWarehouseList, 18, Trim(CODE_FIELD1.AsString), 0,
                          logicalWarehouseList.Count - 1);
    if index <> -1 then
    begin
      CUR_LOGICALWAREHOUSE := logicalWarehouseList.Items[index];
      if PROJECTCONTROLLED_FIELD.AsInteger = 1 then
        CUR_LOGICALWAREHOUSE.ProjectControlled := true;
      if STATISTICALGROUPCONTROLLED_FIELD.AsInteger = 1 then
        CUR_LOGICALWAREHOUSE.StatisticalGroupControlled := true;
      if CUSTOMERCONTROLLED_FIELD.AsInteger = 1 then
        CUR_LOGICALWAREHOUSE.CustomerControlled := true;
      if SUPPLIERCONTROLLED_FIELD.AsInteger = 1 then
        CUR_LOGICALWAREHOUSE.SupplierControlled := true;
      HostQry.Next;
    end
    else
      HostQry.Next;
  end;

  hostQry.Close;

end;

//----------------------------------------------------------------------------//

procedure fillItemTypeTemplatesToList(ArcQry: TMqmQuery; itemTypeTemplatesList: TList);
var
  srvSqlStr, TableName: String;
  NEWITEMTYPETEMPLATE: PITEMTYPETEMPLATES;
  NEWITEMTYPEPRODUCTIONDEMANDTEMPLATE: PITEMTYPEPRODUCTIONDEMANDTEMPLATES;
  lastItemType: String;
  DndArchiveArcName : TDndArchiveName;
  fldItemTypeCode, fldPDTemplateCode: TField;
  fldHostSplitConfirmLevel, fldWkcForSplit, fldOperForSplit: TField;
begin
  DndArchiveArcName := GetDndArchiveLocalName;

  TableName := 'ITEMTYPETEMPLATE';
  if DndArchiveArcName <> TD_Interbase then
    TableName  := 'SCDA_' + 'ITEMTYPETEMPLATE';

  srvSqlStr := 'SELECT * FROM ' + TableName + WHERE_IDF_Condition('IDENTIFIER') + ' ORDER BY ITEMTYPECODE, PRODUCTIONDEMANDTEMPLATECODE';
  ArcQry.SQL.Text := srvSqlStr;
  ArcQry.Active := true;
  fldItemTypeCode          := ArcQry.FieldByName('ITEMTYPECODE');
  fldPDTemplateCode        := ArcQry.FieldByName('PRODUCTIONDEMANDTEMPLATECODE');
  fldHostSplitConfirmLevel := ArcQry.FieldByName('HOSTSPLITCONFIRMLEVEL');
  fldWkcForSplit           := ArcQry.FieldByName('WORKCENTERFORSPLIT');
  fldOperForSplit          := ArcQry.FieldByName('OPERATIONFORSPLIT');

  NEWITEMTYPETEMPLATE := nil;
  lastItemType := '';

  while ( not ArcQry.Eof ) do
  begin
    if ( lastItemType <> Trim(fldItemTypeCode.AsString) ) then
    begin
      lastItemType := Trim(fldItemTypeCode.AsString);

      New(NEWITEMTYPETEMPLATE);

      NEWITEMTYPETEMPLATE.ITEMTYPECODE := lastItemType;
      NEWITEMTYPETEMPLATE.productionDemandTemplateList := TList.Create;

      itemTypeTemplatesList.Add(NEWITEMTYPETEMPLATE);
    end;

    New(NEWITEMTYPEPRODUCTIONDEMANDTEMPLATE);
    NEWITEMTYPEPRODUCTIONDEMANDTEMPLATE.PRODUCTIONDEMANDTEMPLATECODE := Trim(fldPDTemplateCode.AsString);
    NEWITEMTYPEPRODUCTIONDEMANDTEMPLATE.HOSTSPLITCONFIRMLEVEL := Trim(fldHostSplitConfirmLevel.AsString);
    NEWITEMTYPEPRODUCTIONDEMANDTEMPLATE.WORKCENTERFORSPLIT := Trim(fldWkcForSplit.AsString);
    NEWITEMTYPEPRODUCTIONDEMANDTEMPLATE.OPERATIONFORSPLIT := Trim(fldOperForSplit.AsString);
    NEWITEMTYPETEMPLATE.productionDemandTemplateList.Add(NEWITEMTYPEPRODUCTIONDEMANDTEMPLATE);

    ArcQry.Next;
  end;
  itemTypeTemplatesList.Sort(Sort_ITEMTYPETEMPLATES);
  ArcQry.Active := false;
end;

//----------------------------------------------------------------------------//

function fillProductionDemandCountersToList(ArcQry: TMqmQuery; productionDemandCountersList: TList): boolean;
var
  srvSqlStr, TableName: String;
  NEWPRODUCTIONDEMANDCOUNTER: PPRODUCTIONDEMANDCOUNTERS;
  DndArchiveArcName : TDndArchiveName;
  fldCode, fldFamilyCodeEndPos: TField;
begin
  DndArchiveArcName := GetDndArchiveLocalName;

  TableName := 'PRODUCTIONDEMANDCOUNTER';
  if DndArchiveArcName <> TD_Interbase then
    TableName  := 'SCDA_' + 'PRODUCTIONDEMANDCOUNTER';

  srvSqlStr := 'SELECT CODE, FAMILYCODEENDPOSITION ' +
               'FROM ' + TableName + WHERE_IDF_Condition('IDENTIFIER') + ' ORDER BY CODE';
  ArcQry.SQL.Text := srvSqlStr;
  ArcQry.Active := true;
  fldCode             := ArcQry.FieldByName('CODE');
  fldFamilyCodeEndPos := ArcQry.FieldByName('FAMILYCODEENDPOSITION');

  result := false;
  while ( not ArcQry.Eof ) do
  begin
    if (Trim(fldFamilyCodeEndPos.AsString) <> '') and
      (Trim(fldFamilyCodeEndPos.AsString) <> '0') then
    begin
      New(NEWPRODUCTIONDEMANDCOUNTER);
      NEWPRODUCTIONDEMANDCOUNTER.CODE := Trim(fldCode.AsString);
      NEWPRODUCTIONDEMANDCOUNTER.FAMILYCODEENDPOSITION := Trim(fldFamilyCodeEndPos.AsString);

      if (Trim(NEWPRODUCTIONDEMANDCOUNTER.FAMILYCODEENDPOSITION) <> '') and
         (Trim(NEWPRODUCTIONDEMANDCOUNTER.FAMILYCODEENDPOSITION) <> '0') then
        result := true;

      productionDemandCountersList.Add(NEWPRODUCTIONDEMANDCOUNTER);
    end;
    ArcQry.Next;
  end;
  productionDemandCountersList.Sort(Sort_PPRODUCTIONDEMANDCOUNTERS);
  ArcQry.Active := false;
end;

//----------------------------------------------------------------------------//

procedure fillSalesOrderToList(HostQry: TMqmQuery; companyCode: String;
                               salesOrderList: TList);
var
  hostSqlStr: String;
  NEWSALESORDER: PSALESORDERS;
//  CompanyInUsed : string;
begin

//  if not GetCompanyLevelHandlingByEntityName('SALESORDER',  CompanyInUsed) then
//     CompanyInUsed := IniAppGlobals.CompanyCode;

//  hostSqlStr := 'SELECT COUNTERCODE, CODE, ORDERDATE, DESCRIPTION ' +
//                'FROM SALESORDER WHERE COMPANYCODE = ' + QuotedStr(CompanyInUsed) + ' ' +
//                'ORDER BY COUNTERCODE, CODE';

  hostSqlStr := ' ' +
    'SELECT COUNTERCODE, CODE, ORDERDATE, DESCRIPTION ' +
    'FROM ( ' +
      'SELECT DISTINCT PD.ORIGDLVSALORDLINESALORDCNTCOD, PD.ORIGDLVSALORDLINESALORDERCODE ' +
      'FROM ( ' +
        'SELECT * FROM SchedulesDownloadDemands WHERE ' +
          'COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' and ' +
          'EnvironmentCode = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' ) SDD ' +
      'JOIN PRODUCTIONDEMAND PD ' +
      'ON  PD.CompanyCode = SDD.CompanyCode AND PD.CounterCode = SDD.CounterCode AND PD.Code = SDD.Code) PD ' +
    'JOIN SALESORDER SO ' +
    'ON  SO.COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ' +
    'AND SO.COUNTERCODE = PD.ORIGDLVSALORDLINESALORDCNTCOD ' +
    'AND SO.CODE = PD.ORIGDLVSALORDLINESALORDERCODE ' +
    'ORDER BY COUNTERCODE, CODE';

  HostQry.SQL.Text := hostSqlStr;
  HostQry.Open;

  var COUNTERCODE_FIELD := HostQry.FieldByName('COUNTERCODE');
  var CODE_FIELD := HostQry.FieldByName('CODE');
  var ORDERDATE_FIELD := HostQry.FieldByName('ORDERDATE');
  var DESCRIPTION_FIELD := HostQry.FieldByName('DESCRIPTION');

  while ( not HostQry.Eof ) do
  begin
    New(NEWSALESORDER);

    NEWSALESORDER.CODE        := setStringLengthTo(companyCode, 3) +
                                 setStringLengthTo(COUNTERCODE_FIELD.AsString, 8) +
                                 CODE_FIELD.asString;
    NEWSALESORDER.ORDERDATE   := ORDERDATE_FIELD.AsString;
    NEWSALESORDER.DESCRIPTION := Trim(DESCRIPTION_FIELD.AsString);

    salesOrderList.Add(NEWSALESORDER);

    HostQry.Next;
  end;
  salesOrderList.Sort(Sort_SALESORDERS);
  HostQry.Close;
end;

//----------------------------------------------------------------------------//

procedure fillPurchaseOrderToList(HostQry: TMqmQuery; companyCode: String;
                               purchaseOrderList: TList);
var
  hostSqlStr: String;
  NEWPURCHASEORDER: PPURCHASEORDERS;
  CompanyInUsed : string;
begin

// ERAN !! as far as it looks, a purchase order cannot be ever connected to a demand, so, no need to load anything
// If it will be required, the SQL shoudl chnage to take only relevant purchase orders

  {
  if not GetCompanyLevelHandlingByEntityName('PURCHASEORDER',  CompanyInUsed) then
     CompanyInUsed := IniAppGlobals.CompanyCode;

  hostSqlStr := 'SELECT COUNTERCODE, CODE, ORDERDATE, DESCRIPTION ' +
                'FROM PURCHASEORDER WHERE COMPANYCODE = ' + QuotedStr(CompanyInUsed) + ' ' +
                'ORDER BY COUNTERCODE, CODE';
  HostQry.SQL.Text := hostSqlStr;
  HostQry.Open;


  while ( not HostQry.Eof ) do
  begin
    New(NEWPURCHASEORDER);

    NEWPURCHASEORDER.CODE :=        setStringLengthTo(companyCode, 3) +
                                    setStringLengthTo(HostQry.FieldByName('COUNTERCODE').AsString, 8) +
                                    HostQry.FieldByName('CODE').AsString;
    try
      NEWPURCHASEORDER.ORDERDATE := HostQry.FieldByName('ORDERDATE').AsString;
    except
      NEWPURCHASEORDER.ORDERDATE := '30/12/1899';
    end;

    NEWPURCHASEORDER.DESCRIPTION := HostQry.FieldByName('DESCRIPTION').AsString;

    purchaseOrderList.Add(NEWPURCHASEORDER);

    HostQry.Next;
  end;
  HostQry.Close;    }
end;

//----------------------------------------------------------------------------//

procedure fillArticleTypeToList(ArcQry: TMqmQuery; articleTypeList: TList);
var
  srvSqlStr, TableName : String;
  NEWARTICLE_TYPE: PARTICLE_TYPES;
  DndArchiveArcName : TDndArchiveName;
  fldArtType, fldBalHandledByMqm, fldAddDataColName: TField;
  fldProductTypeNature, fldResTimeBeginning, fldResTimeEnding: TField;
  fldMaterialTolleranceCode, fldHoursToDown, fldTableName, fldRelatedColumnName, fldIsWarpType: TField;
begin
  DndArchiveArcName := GetDndArchiveLocalName;

  TableName := 'ARTICLE_TYPE';
  if DndArchiveArcName <> TD_Interbase then
    TableName  := 'SCDA_' + 'ARTICLE_TYPE';

  srvSqlStr := 'SELECT AT_ART_TYPE, AT_BALHANDLEDBYMQM, AT_ADDDATACOLUMNNAME, AT_TABLE_NAME, AT_RELATED_COLUMN_NAME, ' +
               'AT_PRODUCTTYPENATURE, AT_RESTIMEBEGINNING, AT_RESTIMEENDING, AT_MATERIAL_TOLLERANCE_CODE, AT_ISWARPTYPE, AT_HOURSTODOWNFROMMACHINE ' +
               'FROM ' + TableName + WHERE_IDF_Condition('AT_IDENTIFIER') + ' ORDER BY AT_ART_TYPE';
  ArcQry.SQL.Text := srvSqlStr;
  ArcQry.Active := true;
  fldArtType               := ArcQry.FieldByName('AT_ART_TYPE');
  fldBalHandledByMqm       := ArcQry.FieldByName('AT_BALHANDLEDBYMQM');
  fldAddDataColName        := ArcQry.FieldByName('AT_ADDDATACOLUMNNAME');
  fldProductTypeNature     := ArcQry.FieldByName('AT_PRODUCTTYPENATURE');
  fldResTimeBeginning      := ArcQry.FieldByName('AT_RESTIMEBEGINNING');
  fldResTimeEnding         := ArcQry.FieldByName('AT_RESTIMEENDING');
  fldMaterialTolleranceCode := ArcQry.FieldByName('AT_MATERIAL_TOLLERANCE_CODE');
  fldHoursToDown           := ArcQry.FieldByName('AT_HOURSTODOWNFROMMACHINE');
  fldTableName             := ArcQry.FieldByName('AT_TABLE_NAME');
  fldRelatedColumnName     := ArcQry.FieldByName('AT_RELATED_COLUMN_NAME');  
  fldIsWarpType            := ArcQry.FieldByName('AT_ISWARPTYPE');

  while ( not ArcQry.Eof ) do
  begin
    New(NEWARTICLE_TYPE);
    NEWARTICLE_TYPE.AT_ART_TYPE          := Trim(fldArtType.AsString);
    NEWARTICLE_TYPE.AT_BALHANDLEDBYMQM   := Trim(fldBalHandledByMqm.AsString);
    NEWARTICLE_TYPE.AT_ADDDATACOLUMNNAME := Trim(fldAddDataColName.AsString);
    NEWARTICLE_TYPE.AT_PRODUCTTYPENATURE := Trim(fldProductTypeNature.AsString);
    NEWARTICLE_TYPE.AT_RESTIMEBEGINNING  := Trim(fldResTimeBeginning.AsString);
    NEWARTICLE_TYPE.AT_RESTIMEENDING     := Trim(fldResTimeEnding.AsString);
    NEWARTICLE_TYPE.AT_MaterialTolleranceCode := Trim(fldMaterialTolleranceCode.AsString);
    NEWARTICLE_TYPE.AT_HoursToDownloadFromMachine := fldHoursToDown.AsInteger;
    NEWARTICLE_TYPE.AT_TABLE_NAME := Trim(fldTableName.AsString);
    NEWARTICLE_TYPE.AT_RELATED_COLUMN_NAME := Trim(fldRelatedColumnName.AsString);
    NEWARTICLE_TYPE.AT_IS_WARP_TYPE := false;
    if Trim(fldIsWarpType.AsString) = '6' then
      NEWARTICLE_TYPE.AT_IS_WARP_TYPE := true;
    articleTypeList.Add(NEWARTICLE_TYPE);

    ArcQry.Next;
  end;
  articleTypeList.Sort(Sort_ARTICLE_TYPES);

  ArcQry.Active := false;
end;

//----------------------------------------------------------------------------//

function getFullItemKeyCode(itemType: String; code01: String; code02: String;
                            code03: String; code04: String; code05: String;
                            code06: String; code07: String; code08: String;
                            code09: String; code10: String): String;
var
  CUR_ITEMTYPE: PITEMTYPES;
  index: integer;
  numberOfSubCodes: integer;
  itemSubCodes: TStringList;
  itemCode: String;
  i: integer;
begin

  index := searchInList(itemTypesList, 10, itemType, 0, itemTypesList.Count - 1);

  itemSubCodes := TStringList.Create;

  if ( index <> -1 ) then
  begin
    CUR_ITEMTYPE := itemTypesList.Items[index];
    numberOfSubCodes := StrToInt(CUR_ITEMTYPE.LASTSUBCODENR);
    itemSubCodes.Add(setStringLengthTo(code01, StrToInt(CUR_ITEMTYPE.SUBCODELENGTHS.Strings[0]), true, ' '));
    itemSubCodes.Add(setStringLengthTo(code02, StrToInt(CUR_ITEMTYPE.SUBCODELENGTHS.Strings[1]), true, ' '));
    itemSubCodes.Add(setStringLengthTo(code03, StrToInt(CUR_ITEMTYPE.SUBCODELENGTHS.Strings[2]), true, ' '));
    itemSubCodes.Add(setStringLengthTo(code04, StrToInt(CUR_ITEMTYPE.SUBCODELENGTHS.Strings[3]), true, ' '));
    itemSubCodes.Add(setStringLengthTo(code05, StrToInt(CUR_ITEMTYPE.SUBCODELENGTHS.Strings[4]), true, ' '));
    itemSubCodes.Add(setStringLengthTo(code06, StrToInt(CUR_ITEMTYPE.SUBCODELENGTHS.Strings[5]), true, ' '));
    itemSubCodes.Add(setStringLengthTo(code07, StrToInt(CUR_ITEMTYPE.SUBCODELENGTHS.Strings[6]), true, ' '));
    itemSubCodes.Add(setStringLengthTo(code08, StrToInt(CUR_ITEMTYPE.SUBCODELENGTHS.Strings[7]), true, ' '));
    itemSubCodes.Add(setStringLengthTo(code09, StrToInt(CUR_ITEMTYPE.SUBCODELENGTHS.Strings[8]), true, ' '));
    itemSubCodes.Add(setStringLengthTo(code10, StrToInt(CUR_ITEMTYPE.SUBCODELENGTHS.Strings[9]), true, ' '));
  end
  else
  begin
    numberOfSubCodes := 10;
    itemSubCodes.Add(code01);
    itemSubCodes.Add(code02);
    itemSubCodes.Add(code03);
    itemSubCodes.Add(code04);
    itemSubCodes.Add(code05);
    itemSubCodes.Add(code06);
    itemSubCodes.Add(code07);
    itemSubCodes.Add(code08);
    itemSubCodes.Add(code09);
    itemSubCodes.Add(code10);
  end;

  itemCode := '';
  for i := 0 to numberOfSubCodes - 1 do
  begin
    if i <> 0 then
      itemCode := itemCode + '-';

    itemCode := itemCode + itemSubCodes.Strings[i];
  end;

  Result := itemCode;
  itemSubCodes.Free;
end;

//----------------------------------------------------------------------------//

constructor TProdCont.Create;
begin
  inherited Create;
  m_Req_Change_List := TList.Create;
  m_Demand_list     := TList.Create;
end;

//----------------------------------------------------------------------------//

procedure TProdCont.FreeListProd;
begin
  m_Req_Change_List.free;
  m_Demand_list.free;
end;

//----------------------------------------------------------------------------//

procedure TProdCont.ClearStructMemoryList;
var
  I : Integer;
  MQMProductionColumnValues : PMQMProductionColumnValues;
begin
  for I := m_Req_Change_List.Count -1 downto 0 do
    Dispose(PReqChange(m_Req_Change_List[I]));
  m_Req_Change_List.Clear;

  for I := 0 to m_ProdCont.m_Demand_list.Count - 1 do
  begin
    MQMProductionColumnValues := PMQMProductionColumnValues(m_ProdCont.m_Demand_list[I]);
    MQMProductionColumnValues.columnValues.Free;
    Dispose(MQMProductionColumnValues);
  end;
  m_ProdCont.m_Demand_list.Clear;

end;

//----------------------------------------------------------------------------//

destructor TProdCont.Destroy;
begin
  FreeListProd;
  inherited Destroy;
end;

//----------------------------------------------------------------------------//

function compareValuesOfListsToSort(firstList: TStringList; secondList: TStringList): Integer;
var
  index : integer;
begin
  Result := 0;
  for index := 0 to firstList.Count - 1 do
  begin
    if firstList[Index] = secondList[Index] then
      continue
    else
    begin
      if firstList[Index] > secondList[Index] then
        Result := 1
      else
        Result := -1;
      break;
    end;
  end;
end;

//----------------------------------------------------------------------------//

function SortProductionOrderStepStruct(Item1: Pointer; Item2: Pointer): Integer;
var
  firstProductionOrderStepStruct : PTProductionOrderStepStruct;
  secondProductionOrderStepStruct : PTProductionOrderStepStruct;
  firstList: TStringList;
  secondList: TStringList;
begin
  firstProductionOrderStepStruct := Item1;
  secondProductionOrderStepStruct := Item2;

  firstList := TStringList.Create;
  firstList.Add(firstProductionOrderStepStruct.ProductionOrder);
  firstList.Add(firstProductionOrderStepStruct.GroupStepNumber);
  firstList.Add(firstProductionOrderStepStruct.DemandCounterCode);
  firstList.Add(firstProductionOrderStepStruct.DemandCode);
  firstList.Add(firstProductionOrderStepStruct.StepNumber);

  secondList := TStringList.Create;
  secondList.Add(secondProductionOrderStepStruct.ProductionOrder);
  secondList.Add(secondProductionOrderStepStruct.GroupStepNumber);
  secondList.Add(firstProductionOrderStepStruct.DemandCounterCode);
  secondList.Add(firstProductionOrderStepStruct.DemandCode);
  secondList.Add(firstProductionOrderStepStruct.StepNumber);

  Result := compareValuesOfListsToSort(firstList, secondList);

  firstList.Free;
  secondList.Free;
end;

//----------------------------------------------------------------------------//

procedure fillProductionProgressTemplateStruct(ArcQry: TMqmQuery;
                                               productionProgressTemplates: TList);
var
  srvSqlStr, TableName: String;
  NEWPRODUCTIONPROGRESSTEMPLATE: PPRODUCTIONPROGRESSTEMPLATES;
  DndArchiveArcName : TDndArchiveName;
  fldCode, fldHandledByMqm, fldQuantityType: TField;
begin
  DndArchiveArcName := GetDndArchiveLocalName;

  TableName := 'PRODUCTIONPROGRESSTEMPLATE';
  if DndArchiveArcName <> TD_Interbase then
    TableName  := 'SCDA_' + 'PRODUCTIONPRGRESTEMPLATE';

  srvSqlStr := 'SELECT CODE, HANDLEDBYMQM, QUANTITYTYPE ' +
               'FROM ' + TableName +
               ' WHERE HANDLEDBYMQM = ' + QuotedStr('1') + AND_IDF_Condition('IDENTIFIER') + ' ORDER BY CODE';
  ArcQry.SQL.Text := srvSqlStr;
  ArcQry.Active := true;
  fldCode          := ArcQry.FieldByName('CODE');
  fldHandledByMqm  := ArcQry.FieldByName('HANDLEDBYMQM');
  fldQuantityType  := ArcQry.FieldByName('QUANTITYTYPE');

  while ( not ArcQry.Eof ) do
  begin
    New(NEWPRODUCTIONPROGRESSTEMPLATE);

    NEWPRODUCTIONPROGRESSTEMPLATE.CODE := Trim(fldCode.AsString);
    NEWPRODUCTIONPROGRESSTEMPLATE.HANDLEDBYMQM_OR_MCM := Trim(fldHandledByMqm.AsString);
    NEWPRODUCTIONPROGRESSTEMPLATE.QUANTITYTYPE := Trim(fldQuantityType.AsString);

    productionProgressTemplates.Add(NEWPRODUCTIONPROGRESSTEMPLATE);

    ArcQry.Next;
  end;
  productionProgressTemplates.Sort(Sort_PRODUCTIONPROGRESSTEMPLATES);
  ArcQry.Active := false;
end;

//----------------------------------------------------------------------------//

procedure fillWorkCentersBatchSizes(handledWorkCentersList, resList : TList);
var
  MQMRes: PMQMRes;
  i: Integer;
  j: Integer;
  alternativeWorkCenterList: TStringList;
  index: integer;
  CUR_WORKCENTER: PWORKCENTERS;
  CUR_PROCESS: PPROCESSES;
  ADDalternativeWork : boolean;
  ListIndex : Integer;
begin
  for index := 0 to handledWorkCentersList.Count - 1 do
  begin
    CUR_WORKCENTER :=  handledWorkCentersList.Items[index];
    alternativeWorkCenterList := TStringList.Create;
    alternativeWorkCenterList.Sorted := true;
    alternativeWorkCenterList.Add(trim(CUR_WORKCENTER.WC_WKCNTER));
    for i := 0 to CUR_WORKCENTER.Process_List.Count - 1 do
    begin
      CUR_PROCESS := CUR_WORKCENTER.Process_List.Items[i];
      for j := 0 to CUR_PROCESS.Alternatives_List.Count - 1 do
      begin
        ADDalternativeWork := false;
        if alternativeWorkCenterList.Sorted then
          ADDalternativeWork := not alternativeWorkCenterList.Find(Trim(CUR_PROCESS.Alternatives_List[j]), ListIndex)
        else
          ADDalternativeWork := ( alternativeWorkCenterList.IndexOf(Trim(CUR_PROCESS.Alternatives_List[j])) = -1 );
        if ADDalternativeWork then
          alternativeWorkCenterList.Add(Trim(CUR_PROCESS.Alternatives_List[j]));
      end;
    end;
    for i := 0 to resList.Count - 1 do
    begin
      MQMRes := resList.Items[i];
      if alternativeWorkCenterList.Find(trim(MQMRes.RS_WKCNTER), ListIndex) then
      begin
        if ( (StrToFloat(MQMRes.RS_STANDRD_BCH_SIZE) <> 0) OR
           (StrToFloat(MQMRes.RS_MIN_BCH_SIZE) <> 0) OR
           (StrToFloat(MQMRes.RS_MAX_BCH_SIZE) <> 0) ) then
        begin
          if  ((Trim(MQMRes.RS_BCH_UM) <> '')
          and (CUR_WORKCENTER.WC_Batch_UoM.IndexOf(Trim(MQMRes.RS_BCH_UM)) = -1) ) then
            CUR_WORKCENTER.WC_Batch_UoM.Add(Trim(MQMRes.RS_BCH_UM));
        end;
      end;
    end;
    alternativeWorkCenterList.Free;
  end;
end;

//----------------------------------------------------------------------------//

procedure fillADWithRelationToList(ArcQry: TMqmQuery;
                                   additionalDataWithRelationList: TList);
var
  srvSqlStr, TableName: String;
  NEWADDITIONALDATA_WITH_RELATION: PADDITIONALDATA_WITH_RELATIONS;
  lastRelatedClassEntityName: String;
  DndArchiveArcName : TDndArchiveName;
  fldRelatedClassEntityName, fldColumnName: TField;
begin
  DndArchiveArcName := GetDndArchiveLocalName;

  TableName := 'NOW_TABLES_COLUMNS';
  if DndArchiveArcName <> TD_Interbase then
    TableName  := 'SCDA_' + 'NOW_TABLES_COLUMNS';

  NEWADDITIONALDATA_WITH_RELATION := nil;
  srvSqlStr := 'SELECT COLUMN_NAME, RELATEDCLASSENTITYNAME FROM ' + TableName + ' WHERE ' +
               'TABLE_NAME = ' + QuotedStr('ProductionDemand AD') + ' AND ' +
               'RELATEDCLASSENTITYNAME IN (' +
                  QuotedStr('ProductionReservation') + ', ' +
                  QuotedStr('ProductionDemand') +
               ')';

  ArcQry.SQL.Text := srvSqlStr;
  ArcQry.Active := true;
  fldRelatedClassEntityName := ArcQry.FieldByName('RELATEDCLASSENTITYNAME');
  fldColumnName             := ArcQry.FieldByName('COLUMN_NAME');

  lastRelatedClassEntityName := '';
  while ( not ArcQry.Eof ) do
  begin
    if (lastRelatedClassEntityName <> Trim(fldRelatedClassEntityName.AsString)) then
    begin
      if (lastRelatedClassEntityName <> '') then
        additionalDataWithRelationList.Add(NEWADDITIONALDATA_WITH_RELATION);

      lastRelatedClassEntityName := Trim(fldRelatedClassEntityName.AsString);

      New(NEWADDITIONALDATA_WITH_RELATION);
      NEWADDITIONALDATA_WITH_RELATION.RELATEDCLASSENTITYNAME := lastRelatedClassEntityName;
      NEWADDITIONALDATA_WITH_RELATION.columnNameStringList := TStringList.Create;
    end;

    NEWADDITIONALDATA_WITH_RELATION.columnNameStringList.Add(Trim(fldColumnName.AsString));

    ArcQry.Next;
  end;
  ArcQry.Active := false;
end;

//----------------------------------------------------------------------------//

procedure setLowestAndHigestDates(var lowestDate: TDateTime; var highestDate: TDateTime;
                                  CUR_PROGRESS_ITEM: PPROGRESS_ITEMS; var IsEndExist : boolean);
begin
  if ( CUR_PROGRESS_ITEM.PROGRESSSTARTPREPROCESSDATE <> 0 ) then
  begin
    if ( (lowestDate > CUR_PROGRESS_ITEM.PROGRESSSTARTPREPROCESSDATE + Frac(CUR_PROGRESS_ITEM.PROGRESSSTARTPREPROCESSTIME)) OR
         (lowestDate = 0) ) then
      lowestDate := CUR_PROGRESS_ITEM.PROGRESSSTARTPREPROCESSDATE + Frac(CUR_PROGRESS_ITEM.PROGRESSSTARTPREPROCESSTIME);

    if ( highestDate < CUR_PROGRESS_ITEM.PROGRESSSTARTPREPROCESSDATE + Frac(CUR_PROGRESS_ITEM.PROGRESSSTARTPREPROCESSTIME)) then
      highestDate := CUR_PROGRESS_ITEM.PROGRESSSTARTPREPROCESSDATE + Frac(CUR_PROGRESS_ITEM.PROGRESSSTARTPREPROCESSTIME);
  end;

  if ( CUR_PROGRESS_ITEM.PROGRESSSTARTPROCESSDATE <> 0 ) then
  begin
    if ( (lowestDate > CUR_PROGRESS_ITEM.PROGRESSSTARTPROCESSDATE + Frac(CUR_PROGRESS_ITEM.PROGRESSSTARTPROCESSTIME)) OR
         (lowestDate = 0) ) then
      lowestDate := CUR_PROGRESS_ITEM.PROGRESSSTARTPROCESSDATE + Frac(CUR_PROGRESS_ITEM.PROGRESSSTARTPROCESSTIME);

    if ( highestDate < CUR_PROGRESS_ITEM.PROGRESSSTARTPROCESSDATE + Frac(CUR_PROGRESS_ITEM.PROGRESSSTARTPROCESSTIME)) then
      highestDate := CUR_PROGRESS_ITEM.PROGRESSSTARTPROCESSDATE + Frac(CUR_PROGRESS_ITEM.PROGRESSSTARTPROCESSTIME);
  end;

  if ( CUR_PROGRESS_ITEM.PROGRESSSTARTPOSTPROCESSDATE <> 0 ) then
  begin
    if ( (lowestDate > CUR_PROGRESS_ITEM.PROGRESSSTARTPOSTPROCESSDATE + Frac(CUR_PROGRESS_ITEM.PROGRESSSTARTPOSTPROCESSTIME)) OR
         (lowestDate = 0) ) then
      lowestDate := CUR_PROGRESS_ITEM.PROGRESSSTARTPOSTPROCESSDATE + Frac(CUR_PROGRESS_ITEM.PROGRESSSTARTPOSTPROCESSTIME);

    if ( highestDate < CUR_PROGRESS_ITEM.PROGRESSSTARTPOSTPROCESSDATE + Frac(CUR_PROGRESS_ITEM.PROGRESSSTARTPOSTPROCESSTIME)) then
      highestDate := CUR_PROGRESS_ITEM.PROGRESSSTARTPOSTPROCESSDATE + Frac(CUR_PROGRESS_ITEM.PROGRESSSTARTPOSTPROCESSTIME);
  end;

  if ( CUR_PROGRESS_ITEM.PROGRESSPARTIALENDDATE <> 0 ) then
  begin
    if ( (lowestDate > CUR_PROGRESS_ITEM.PROGRESSPARTIALENDDATE + Frac(CUR_PROGRESS_ITEM.PROGRESSPARTIALENDTIME)) OR
         (lowestDate = 0) ) then
      lowestDate := CUR_PROGRESS_ITEM.PROGRESSPARTIALENDDATE + Frac(CUR_PROGRESS_ITEM.PROGRESSPARTIALENDTIME);

    if ( highestDate < CUR_PROGRESS_ITEM.PROGRESSPARTIALENDDATE + Frac(CUR_PROGRESS_ITEM.PROGRESSPARTIALENDTIME)) then
      highestDate := CUR_PROGRESS_ITEM.PROGRESSPARTIALENDDATE + Frac(CUR_PROGRESS_ITEM.PROGRESSPARTIALENDTIME);
  end;

  if ( CUR_PROGRESS_ITEM.PROGRESSENDDATE <> 0 ) then
  begin
    if ( (lowestDate > CUR_PROGRESS_ITEM.PROGRESSENDDATE + Frac(CUR_PROGRESS_ITEM.PROGRESSENDTIME)) OR
         (lowestDate = 0) ) then
      lowestDate := CUR_PROGRESS_ITEM.PROGRESSENDDATE + Frac(CUR_PROGRESS_ITEM.PROGRESSENDTIME);

    if ( highestDate < CUR_PROGRESS_ITEM.PROGRESSENDDATE + Frac(CUR_PROGRESS_ITEM.PROGRESSENDTIME)) then
    begin
      highestDate := CUR_PROGRESS_ITEM.PROGRESSENDDATE + Frac(CUR_PROGRESS_ITEM.PROGRESSENDTIME);
      IsEndExist := true;
    end;
  end;
end;

//----------------------------------------------------------------------------//

function getEndPosition(productionDemandCounters: TList; code: String): Integer;
var
  index: Integer;
begin
  index := searchInList(productionDemandCounters, 36, Trim(code),
                        0, productionDemandCounters.Count - 1);

  if (index <> -1) then
  begin
    try
      result := 11 + StrToInt(Trim(PPRODUCTIONDEMANDCOUNTERS(productionDemandCounters.Items[index]).FAMILYCODEENDPOSITION));
    except
      on E: Exception do
        result := 0;
    end;
  end
  else
    result := 0;
end;

//----------------------------------------------------------------------------//

function getPSTEP_IDForProgress(stepNumber: String; code: String;
                                workCenterCode: String; operationCode: String;
                                stepIdListForProgressList_PD: TList;
                                stepIdListForProgressList_PO: TList;
                                var stepInitialQuantity: double;
                                var stepFinalQuantity: double): String;
var
  index: Integer;
  CUR_STEP_ID_PRODUCTIONDEMAND: PSTEP_ID_PRODUCTIONDEMANDSANDORDERS;
  CUR_STEP_ID_WORKCENTER: PSTEP_ID_WORKCENTERS;
  CUR_STEP_ID_WORKCENTERDATA: PSTEP_ID_WORKCENTERDATAS;

  CUR_STEP_ID_OPERATION: PSTEP_ID_OPERATIONS;
  CUR_STEP_ID_OPERATIONDATA: PSTEP_ID_OPERATIONDATAS;
begin
  if ( Trim(stepNumber) <> '0' ) then
    Result := stepNumber
  else
  begin
    index := searchInList(stepIdListForProgressList_PD, 24, code, 0,
                          stepIdListForProgressList_PD.Count - 1);

    if (index <> -1) then
    begin
      CUR_STEP_ID_PRODUCTIONDEMAND := stepIdListForProgressList_PD.Items[index];

      if Trim(workCenterCode) <> '' then
      begin
        index := searchInListLinear(CUR_STEP_ID_PRODUCTIONDEMAND.workCenterList, 1,
                                    workCenterCode);

        if (index <> -1) then
        begin
          CUR_STEP_ID_WORKCENTER := CUR_STEP_ID_PRODUCTIONDEMAND.workCenterList.Items[index];

          index := -1;
          if Trim(operationCode) <> '' then
            index := searchInListLinear(CUR_STEP_ID_WORKCENTER.operationList, 2,
                                        operationCode)
          else
          begin
            if CUR_STEP_ID_WORKCENTER.operationList.Count > 0 then
              index := 0;
          end;

          if (index <> -1) then
          begin
            CUR_STEP_ID_WORKCENTERDATA := CUR_STEP_ID_WORKCENTER.operationList.Items[index];
            stepInitialQuantity := StrToFloat(CUR_STEP_ID_WORKCENTERDATA.initialBasePrimaryQuantity);
            stepFinalQuantity := StrToFloat(CUR_STEP_ID_WORKCENTERDATA.finalBasePrimaryQuantity);
            Result := CUR_STEP_ID_WORKCENTERDATA.stepNumber;
          end
          else
            Result := '-3';
        end
        else
          Result := '-2';
      end
      else
      begin
        if Trim(operationCode) <> '' then
        begin
          index := searchInListLinear(CUR_STEP_ID_PRODUCTIONDEMAND.operationList, 3,
                                      operationCode);

          if (index <> -1) then
          begin
            CUR_STEP_ID_OPERATION := CUR_STEP_ID_PRODUCTIONDEMAND.operationList.Items[index];

            index := -1;
            if Trim(workCenterCode) <> '' then
              index := searchInListLinear(CUR_STEP_ID_OPERATION.workCenterList, 4,
                                          workCenterCode)
            else
            begin
              if CUR_STEP_ID_OPERATION.workCenterList.Count > 0 then
                index := 0;
            end;

            if (index <> -1) then
            begin
              CUR_STEP_ID_OPERATIONDATA := CUR_STEP_ID_OPERATION.workCenterList.Items[index];
              stepInitialQuantity := StrToFloat(CUR_STEP_ID_OPERATIONDATA.initialBasePrimaryQuantity);
              stepFinalQuantity := StrToFloat(CUR_STEP_ID_OPERATIONDATA.finalBasePrimaryQuantity);
              Result := CUR_STEP_ID_OPERATIONDATA.stepNumber;
            end
            else
              Result := '-3';
          end
          else
            Result := '-2';
        end
        else
          Result := '-4';
      end;
    end
    else
      Result := '-1';
  end;
end;

//----------------------------------------------------------------------------//

procedure ifNeededAddWorkCenterAndOperationToList(workCenterCode: String;
                                                  operationCode: String;
                                                  stepNumber: String;
                                                  initialBasePrimaryQuantity: String;
                                                  finalBasePrimaryQuantity: String;
                                                  workCenterList: TList;
                                                  operationList: TList;
                                                  stepIdList: TList);
var
  index: integer;
  CUR_STEP_ID_WORKCENTER: PSTEP_ID_WORKCENTERS;
  NEW_STEP_ID_WORKCENTER: PSTEP_ID_WORKCENTERS;
  NEW_STEP_ID_WORKCENTERDATA: PSTEP_ID_WORKCENTERDATAS;

  CUR_STEP_ID_OPERATION: PSTEP_ID_OPERATIONS;
  NEW_STEP_ID_OPERATION: PSTEP_ID_OPERATIONS;
  NEW_STEP_ID_OPERATIONDATA: PSTEP_ID_OPERATIONDATAS;

  NEW_STEP_ID_STEP: PSTEP_ID_STEPS;
begin
  New(NEW_STEP_ID_STEP);
  NEW_STEP_ID_STEP.stepNumber := stepNumber;
  NEW_STEP_ID_STEP.initialBasePrimaryQuantity := initialBasePrimaryQuantity;
  NEW_STEP_ID_STEP.finalBasePrimaryQuantity   := finalBasePrimaryQuantity;
  stepIdList.Add(NEW_STEP_ID_STEP);

  index := searchInListLinear(workCenterList, 1, workCenterCode);
  if ( index <> -1 ) then
  begin
    CUR_STEP_ID_WORKCENTER := workCenterList.Items[index];

    index := searchInListLinear(CUR_STEP_ID_WORKCENTER.operationList, 2, operationCode);

    if ( index = -1 ) then
    begin
      New(NEW_STEP_ID_WORKCENTERDATA);
      NEW_STEP_ID_WORKCENTERDATA.operationCode := operationCode;
      NEW_STEP_ID_WORKCENTERDATA.stepNumber := stepNumber;
      NEW_STEP_ID_WORKCENTERDATA.initialBasePrimaryQuantity := initialBasePrimaryQuantity;
      NEW_STEP_ID_WORKCENTERDATA.finalBasePrimaryQuantity   := finalBasePrimaryQuantity;

      CUR_STEP_ID_WORKCENTER.operationList.Add(NEW_STEP_ID_WORKCENTERDATA);
    end;
  end
  else
  begin
    New(NEW_STEP_ID_WORKCENTER);
    NEW_STEP_ID_WORKCENTER.workCenterCode := workCenterCode;
    NEW_STEP_ID_WORKCENTER.operationList := TList.Create;

    New(NEW_STEP_ID_WORKCENTERDATA);
    NEW_STEP_ID_WORKCENTERDATA.operationCode := operationCode;
    NEW_STEP_ID_WORKCENTERDATA.stepNumber := stepNumber;
    NEW_STEP_ID_WORKCENTERDATA.initialBasePrimaryQuantity := initialBasePrimaryQuantity;
    NEW_STEP_ID_WORKCENTERDATA.finalBasePrimaryQuantity   := finalBasePrimaryQuantity;

    NEW_STEP_ID_WORKCENTER.operationList.Add(NEW_STEP_ID_WORKCENTERDATA);

    workCenterList.Add(NEW_STEP_ID_WORKCENTER);
  end;


  index := searchInListLinear(operationList, 3, operationCode);
  if ( index <> -1 ) then
  begin
    CUR_STEP_ID_OPERATION := operationList.Items[index];

    index := searchInListLinear(CUR_STEP_ID_OPERATION.workCenterList, 4, workCenterCode);

    if ( index = -1 ) then
    begin
      New(NEW_STEP_ID_OPERATIONDATA);
      NEW_STEP_ID_OPERATIONDATA.workCenterCode := workCenterCode;
      NEW_STEP_ID_OPERATIONDATA.stepNumber := stepNumber;
      NEW_STEP_ID_OPERATIONDATA.initialBasePrimaryQuantity := initialBasePrimaryQuantity;
      NEW_STEP_ID_OPERATIONDATA.finalBasePrimaryQuantity   := finalBasePrimaryQuantity;

      CUR_STEP_ID_OPERATION.workcenterList.Add(NEW_STEP_ID_OPERATIONDATA);
    end;
  end
  else
  begin
    New(NEW_STEP_ID_OPERATION);
    NEW_STEP_ID_OPERATION.operationCode := operationCode;//workCenterCode; avierbilo
    NEW_STEP_ID_OPERATION.workCenterList := TList.Create;

    New(NEW_STEP_ID_OPERATIONDATA);
    NEW_STEP_ID_OPERATIONDATA.workCenterCode := workCenterCode;
    NEW_STEP_ID_OPERATIONDATA.stepNumber := stepNumber;
    NEW_STEP_ID_OPERATIONDATA.initialBasePrimaryQuantity := initialBasePrimaryQuantity;
    NEW_STEP_ID_OPERATIONDATA.finalBasePrimaryQuantity   := finalBasePrimaryQuantity;

    NEW_STEP_ID_OPERATION.workCenterList.Add(NEW_STEP_ID_OPERATIONDATA);

    operationList.Add(NEW_STEP_ID_OPERATION);
  end;
end;

//----------------------------------------------------------------------------//

procedure addToHandled_PD_PO(productionDemandCode: String; productionDemandStep: String;
                             productionOrderCode: String; productionOrderStep: String);
var
  NEW_HANDLED_PRODUCTION_DEMAND: PHANDLED_PRODUCTION_DEMANDS;
  CUR_HANDLED_PRODUCTION_DEMAND: PHANDLED_PRODUCTION_DEMANDS;

  NEW_HANDLED_PRODUCTION_ORDER: PHANDLED_PRODUCTION_ORDERS;
  CUR_HANDLED_PRODUCTION_ORDER: PHANDLED_PRODUCTION_ORDERS;

  index: integer;
begin

  index := searchInList(handledProductionDemandList, 27, productionDemandCode, 0, handledProductionDemandList.Count - 1);

  if ( index <> -1 ) then
  begin
    CUR_HANDLED_PRODUCTION_DEMAND := handledProductionDemandList.Items[index];

    if (CUR_HANDLED_PRODUCTION_DEMAND.stepList.IndexOf(productionDemandStep) = -1) then
      CUR_HANDLED_PRODUCTION_DEMAND.stepList.Add(productionDemandStep);
  end
  else
  begin
    New(NEW_HANDLED_PRODUCTION_DEMAND);
    NEW_HANDLED_PRODUCTION_DEMAND.Code := productionDemandCode;
    NEW_HANDLED_PRODUCTION_DEMAND.stepList := TStringList.Create;
    NEW_HANDLED_PRODUCTION_DEMAND.stepList.Add(productionDemandStep);

    handledProductionDemandList.Add(NEW_HANDLED_PRODUCTION_DEMAND);
  end;


  if ( Trim(productionOrderCode) <> '' ) then
  begin
    index := searchInList(handledProductionOrderList, 28, productionOrderCode, 0, handledProductionOrderList.Count - 1);

    if ( index <> -1 ) then
    begin
      CUR_HANDLED_PRODUCTION_ORDER := handledProductionOrderList.Items[index];

      if (CUR_HANDLED_PRODUCTION_ORDER.stepList.IndexOf(productionOrderStep) = -1) then
        CUR_HANDLED_PRODUCTION_ORDER.stepList.Add(productionOrderStep);

      if (CUR_HANDLED_PRODUCTION_ORDER.DemandCodeList.IndexOf(productionDemandCode) = -1) then
        CUR_HANDLED_PRODUCTION_ORDER.DemandCodeList.Add(productionDemandCode);
    end
    else
    begin
      New(NEW_HANDLED_PRODUCTION_ORDER);
      NEW_HANDLED_PRODUCTION_ORDER.Code := productionOrderCode;

      NEW_HANDLED_PRODUCTION_ORDER.stepList := TStringList.Create;
      NEW_HANDLED_PRODUCTION_ORDER.stepList.Add(productionOrderStep);

      NEW_HANDLED_PRODUCTION_ORDER.DemandCodeList := TStringList.Create;
      NEW_HANDLED_PRODUCTION_ORDER.DemandCodeList.Add(productionDemandCode);

      handledProductionOrderList.Add(NEW_HANDLED_PRODUCTION_ORDER);

      handledProductionOrderList.Sort(sortHandledProductionOrder);
    end;
  end;
end;

//----------------------------------------------------------------------------//

function isStepHandled(stepList: TStringList; stepIdListForProgressList_PD: TList;
                       stepIdListForProgressList_PO: TList; HostQry: TMqmQuery;
                       var StepId: String; var StepInitialQuantity: String;
                       var StepFinalQuantity: String; ProductionStruct : TProductionOrderStepStruct): boolean;
var
  isStepIdFound: boolean;
begin
  if ( Trim(StepId) <> '0' ) then
  begin
    //if ( Trim(HostQry.FieldByName('DEMANDCODE').AsString) <> '' ) then
    if ProductionStruct.DemandCode <> '' then
      setStepInitialFinalQuantities(stepIdListForProgressList_PD,
                                  //  setStringLengthTo(HostQry.FieldByName('DEMANDCOUNTERCODE').AsString, 8) + Trim(HostQry.FieldByName('DEMANDCODE').AsString),
                                    ProductionStruct.DemandCounterCode + ProductionStruct.DemandCode,
                                    StepId, StepInitialQuantity, StepFinalQuantity)
    else
      setStepInitialFinalQuantities(stepIdListForProgressList_PO,
                                  //  Trim(HostQry.FieldByName('PRODUCTIONORDERCODE').AsString),
                                    ProductionStruct.ProductionOrder,
                                    StepId, StepInitialQuantity, StepFinalQuantity);

    Result := (stepList.IndexOf(StepId) <> -1);
  end
  else
  begin
    //isStepIdFound := false;

   // if ( Trim(HostQry.FieldByName('DEMANDCODE').AsString) <> '' ) then
    if ProductionStruct.DemandCode <> '' then
      isStepIdFound := setStepId(stepIdListForProgressList_PD,
                                // setStringLengthTo(HostQry.FieldByName('DEMANDCOUNTERCODE').AsString, 8) + Trim(HostQry.FieldByName('DEMANDCODE').AsString),
                                // Trim(HostQry.FieldByName('WORKCENTERCODE').AsString),
                                // Trim(HostQry.FieldByName('OPERATIONCODE').AsString),
                                 ProductionStruct.DemandCounterCode + ProductionStruct.DemandCode,
                                 ProductionStruct.WorkCenter, ProductionStruct.Operation,
                                 StepId, StepInitialQuantity, StepFinalQuantity)
    else
      isStepIdFound := setStepId(stepIdListForProgressList_PO,
                                // Trim(HostQry.FieldByName('PRODUCTIONORDERCODE').AsString),
                                // Trim(HostQry.FieldByName('WORKCENTERCODE').AsString),
                                // Trim(HostQry.FieldByName('OPERATIONCODE').AsString),
                                 ProductionStruct.ProductionOrder, ProductionStruct.WorkCenter, ProductionStruct.Operation,
                                 StepId, StepInitialQuantity, StepFinalQuantity
                                );

      if isStepIdFound then
      begin
        Result := (stepList.IndexOf(StepId) <> -1)
      end
      else
        Result := false;
  end;
end;

//----------------------------------------------------------------------------//

function setStepId(stepIdListForProgressList: TList; code: String; workCenterCode: String;
                   operationCode: String; var StepId: String; var StepInitialQuantity: String;
                   var StepFinalQuantity: String): boolean;
var
  index: Integer;
  CUR_STEP_ID_PRODUCTIONDEMANDANDORDER: PSTEP_ID_PRODUCTIONDEMANDSANDORDERS;
  CUR_STEP_ID_WORKCENTER: PSTEP_ID_WORKCENTERS;
  CUR_STEP_ID_WORKCENTERDATA: PSTEP_ID_WORKCENTERDATAS;

  CUR_STEP_ID_OPERATION: PSTEP_ID_OPERATIONS;
  CUR_STEP_ID_OPERATIONDATA: PSTEP_ID_OPERATIONDATAS;
begin
  Result := true;

  index := searchInList(stepIdListForProgressList, 24, code, 0,
                          stepIdListForProgressList.Count - 1);

  if (index <> -1) then
  begin
    CUR_STEP_ID_PRODUCTIONDEMANDANDORDER := stepIdListForProgressList.Items[index];

    if Trim(workCenterCode) <> '' then
    begin
      index := searchInListLinear(CUR_STEP_ID_PRODUCTIONDEMANDANDORDER.workCenterList, 1,
                                  workCenterCode);

      if (index <> -1) then
      begin
        CUR_STEP_ID_WORKCENTER := CUR_STEP_ID_PRODUCTIONDEMANDANDORDER.workCenterList.Items[index];

        index := -1;
        if Trim(operationCode) <> '' then
          index := searchInListLinear(CUR_STEP_ID_WORKCENTER.operationList, 2,
                                      operationCode)
        else
        begin
          if CUR_STEP_ID_WORKCENTER.operationList.Count > 0 then
            index := 0;
        end;

        if (index <> -1) then
        begin
          CUR_STEP_ID_WORKCENTERDATA := CUR_STEP_ID_WORKCENTER.operationList.Items[index];
          StepId := CUR_STEP_ID_WORKCENTERDATA.stepNumber;
          StepInitialQuantity := CUR_STEP_ID_WORKCENTERDATA.initialBasePrimaryQuantity;
          StepFinalQuantity := CUR_STEP_ID_WORKCENTERDATA.finalBasePrimaryQuantity;
          Result := true;
        end
        else
        begin
          StepId := '-3';
          Result := true;
        end;
      end
      else
      begin
        //Result := false;
        StepId := '-1';
        Result := true;
      end;
    end
    else
    begin

      index := searchInListLinear(CUR_STEP_ID_PRODUCTIONDEMANDANDORDER.operationList, 3,
                                  operationCode);

      if (index <> -1) then
      begin
        CUR_STEP_ID_OPERATION := CUR_STEP_ID_PRODUCTIONDEMANDANDORDER.operationList.Items[index];

        index := -1;
        if Trim(workCenterCode) <> '' then
          index := searchInListLinear(CUR_STEP_ID_OPERATION.workCenterList, 4,
                                      workCenterCode)
        else
        begin
          if CUR_STEP_ID_OPERATION.workCenterList.Count > 0 then
            index := 0;
        end;

        if (index <> -1) then
        begin
          CUR_STEP_ID_OPERATIONDATA := CUR_STEP_ID_OPERATION.workCenterList.Items[index];
          StepId := CUR_STEP_ID_OPERATIONDATA.stepNumber;
          StepInitialQuantity := CUR_STEP_ID_OPERATIONDATA.initialBasePrimaryQuantity;
          StepFinalQuantity := CUR_STEP_ID_OPERATIONDATA.finalBasePrimaryQuantity;
          Result := true;
        end
        else
        begin
          StepId := '-3';
          Result := true;
        end;
      end
      else
      begin
        //Result := false;
        StepId := '-1';
        Result := true;
      end;
    end;
  end
  else
  begin
    //Result := false;
    StepId := '-2';
    Result := true;
  end;
end;

//----------------------------------------------------------------------------//

procedure setStepInitialFinalQuantities(stepIdListForProgressList: TList; code: String;
                                        StepId: String; var StepInitialQuantity: String;
                                        var StepFinalQuantity: String);
var
  index: Integer;
  CUR_STEP_ID_PRODUCTIONDEMANDANDORDER: PSTEP_ID_PRODUCTIONDEMANDSANDORDERS;
  CUR_STEP_ID_STEP: PSTEP_ID_STEPS;
begin
  index := searchInList(stepIdListForProgressList, 24, code, 0,
                          stepIdListForProgressList.Count - 1);

  if (index <> -1) then
  begin
    CUR_STEP_ID_PRODUCTIONDEMANDANDORDER := stepIdListForProgressList.Items[index];

    index := searchInList(CUR_STEP_ID_PRODUCTIONDEMANDANDORDER.stepIdList, 29,
                          StepId, 0, CUR_STEP_ID_PRODUCTIONDEMANDANDORDER.stepIdList.Count - 1);

    if (index <> -1) then
    begin
      CUR_STEP_ID_STEP := CUR_STEP_ID_PRODUCTIONDEMANDANDORDER.stepIdList.Items[index];
      StepInitialQuantity := CUR_STEP_ID_STEP.initialBasePrimaryQuantity;
      StepFinalQuantity := CUR_STEP_ID_STEP.finalBasePrimaryQuantity;
    end
    else
    begin
      StepInitialQuantity := '0';
      StepFinalQuantity := '0';
    end
  end
  else
  begin
    StepInitialQuantity := '0';
    StepFinalQuantity := '0';
  end;
end;

//----------------------------------------------------------------------------//

procedure ifNeededAddToStepIdListForProgressList_PO(orderCode: String;
                                                    workCenterCode: String;
                                                    operationCode: String;
                                                    stepNumber: String;
                                                    initialBasePrimaryQuantity: String;
                                                    finalBasePrimaryQuantity: String;
                                                    stepIdListForProgressList_PO: TList;
                                                    stepIdListForProgressList_PO_SL: TStringList);
var
  NEW_STEP_ID_PRODUCTIONORDER: PSTEP_ID_PRODUCTIONDEMANDSANDORDERS;
  CUR_STEP_ID_PRODUCTIONORDER: PSTEP_ID_PRODUCTIONDEMANDSANDORDERS;

  NEW_STEP_ID_STEP: PSTEP_ID_STEPS;

  CUR_STEP_ID_WORKCENTER: PSTEP_ID_WORKCENTERS;
  NEW_STEP_ID_WORKCENTER: PSTEP_ID_WORKCENTERS;
  NEW_STEP_ID_WORKCENTERDATA: PSTEP_ID_WORKCENTERDATAS;

  CUR_STEP_ID_OPERATION: PSTEP_ID_OPERATIONS;
  NEW_STEP_ID_OPERATION: PSTEP_ID_OPERATIONS;
  NEW_STEP_ID_OPERATIONDATA: PSTEP_ID_OPERATIONDATAS;

  index: Integer;
  slIdx: Integer;
begin
  //index := searchInList(stepIdListForProgressList_PO, 24, orderCode, 0,
  //                      stepIdListForProgressList_PO.Count - 1);
  if stepIdListForProgressList_PO_SL.Find(orderCode, slIdx) then
  begin
    CUR_STEP_ID_PRODUCTIONORDER := PSTEP_ID_PRODUCTIONDEMANDSANDORDERS(stepIdListForProgressList_PO_SL.Objects[slIdx]);

    New(NEW_STEP_ID_STEP);
    NEW_STEP_ID_STEP.stepNumber := stepNumber;
    NEW_STEP_ID_STEP.initialBasePrimaryQuantity := initialBasePrimaryQuantity;
    NEW_STEP_ID_STEP.finalBasePrimaryQuantity   := finalBasePrimaryQuantity;
    CUR_STEP_ID_PRODUCTIONORDER.stepIdList.Add(NEW_STEP_ID_STEP);

    index := searchInListLinear(CUR_STEP_ID_PRODUCTIONORDER.workCenterList, 1, workCenterCode);
    if (index <> -1) then
    begin
      CUR_STEP_ID_WORKCENTER := CUR_STEP_ID_PRODUCTIONORDER.workCenterList.Items[index];

      index := searchInListLinear(CUR_STEP_ID_WORKCENTER.operationList, 2, operationCode);

      if (index = -1) then
      begin
        New(NEW_STEP_ID_WORKCENTERDATA);
        NEW_STEP_ID_WORKCENTERDATA.operationCode := operationCode;
        NEW_STEP_ID_WORKCENTERDATA.stepNumber := stepNumber;
        NEW_STEP_ID_WORKCENTERDATA.initialBasePrimaryQuantity := initialBasePrimaryQuantity;
        NEW_STEP_ID_WORKCENTERDATA.finalBasePrimaryQuantity   := finalBasePrimaryQuantity;

        CUR_STEP_ID_WORKCENTER.operationList.Add(NEW_STEP_ID_WORKCENTERDATA);
      end;
    end
    else
    begin
      New(NEW_STEP_ID_WORKCENTER);
      NEW_STEP_ID_WORKCENTER.workCenterCode := workCenterCode;
      NEW_STEP_ID_WORKCENTER.operationList := TList.Create;

      New(NEW_STEP_ID_WORKCENTERDATA);
      NEW_STEP_ID_WORKCENTERDATA.operationCode := operationCode;
      NEW_STEP_ID_WORKCENTERDATA.stepNumber := stepNumber;
      NEW_STEP_ID_WORKCENTERDATA.initialBasePrimaryQuantity := initialBasePrimaryQuantity;
      NEW_STEP_ID_WORKCENTERDATA.finalBasePrimaryQuantity   := finalBasePrimaryQuantity;

      NEW_STEP_ID_WORKCENTER.operationList.Add(NEW_STEP_ID_WORKCENTERDATA);
      CUR_STEP_ID_PRODUCTIONORDER.workCenterList.Add(NEW_STEP_ID_WORKCENTER);
    end;

    index := searchInListLinear(CUR_STEP_ID_PRODUCTIONORDER.operationList, 3, operationCode);
    if ( index <> -1 ) then
    begin
      CUR_STEP_ID_OPERATION := CUR_STEP_ID_PRODUCTIONORDER.operationList.Items[index];

      index := searchInListLinear(CUR_STEP_ID_OPERATION.workCenterList, 4, workCenterCode);

      if ( index = -1 ) then
      begin
        New(NEW_STEP_ID_OPERATIONDATA);
        NEW_STEP_ID_OPERATIONDATA.workCenterCode := workCenterCode;
        NEW_STEP_ID_OPERATIONDATA.stepNumber := stepNumber;
        NEW_STEP_ID_OPERATIONDATA.initialBasePrimaryQuantity := initialBasePrimaryQuantity;
        NEW_STEP_ID_OPERATIONDATA.finalBasePrimaryQuantity   := finalBasePrimaryQuantity;

        CUR_STEP_ID_OPERATION.workcenterList.Add(NEW_STEP_ID_OPERATIONDATA);
      end;
    end
    else
    begin
      New(NEW_STEP_ID_OPERATION);
      NEW_STEP_ID_OPERATION.operationCode := operationCode;
      NEW_STEP_ID_OPERATION.workCenterList := TList.Create;

      New(NEW_STEP_ID_OPERATIONDATA);
      NEW_STEP_ID_OPERATIONDATA.workCenterCode := workCenterCode;
      NEW_STEP_ID_OPERATIONDATA.stepNumber := stepNumber;
      NEW_STEP_ID_OPERATIONDATA.initialBasePrimaryQuantity := initialBasePrimaryQuantity;
      NEW_STEP_ID_OPERATIONDATA.finalBasePrimaryQuantity   := finalBasePrimaryQuantity;

      NEW_STEP_ID_OPERATION.workCenterList.Add(NEW_STEP_ID_OPERATIONDATA);
      CUR_STEP_ID_PRODUCTIONORDER.operationList.Add(NEW_STEP_ID_OPERATION);
    end;
  end
  else
  begin
    New(NEW_STEP_ID_PRODUCTIONORDER);
    NEW_STEP_ID_PRODUCTIONORDER.Code := orderCode;
    NEW_STEP_ID_PRODUCTIONORDER.workCenterList := TList.Create;
    NEW_STEP_ID_PRODUCTIONORDER.operationList := TList.Create;
    NEW_STEP_ID_PRODUCTIONORDER.stepIdList := TList.Create;

    New(NEW_STEP_ID_STEP);
    NEW_STEP_ID_STEP.stepNumber := stepNumber;
    NEW_STEP_ID_STEP.initialBasePrimaryQuantity := initialBasePrimaryQuantity;
    NEW_STEP_ID_STEP.finalBasePrimaryQuantity   := finalBasePrimaryQuantity;

    New(NEW_STEP_ID_WORKCENTER);
    NEW_STEP_ID_WORKCENTER.workCenterCode := workCenterCode;
    NEW_STEP_ID_WORKCENTER.operationList := TList.Create;

    New(NEW_STEP_ID_WORKCENTERDATA);
    NEW_STEP_ID_WORKCENTERDATA.operationCode := operationCode;
    NEW_STEP_ID_WORKCENTERDATA.stepNumber := stepNumber;
    NEW_STEP_ID_WORKCENTERDATA.initialBasePrimaryQuantity := initialBasePrimaryQuantity;
    NEW_STEP_ID_WORKCENTERDATA.finalBasePrimaryQuantity   := finalBasePrimaryQuantity;


    New(NEW_STEP_ID_OPERATION);
    NEW_STEP_ID_OPERATION.operationCode := operationCode;
    NEW_STEP_ID_OPERATION.workCenterList := TList.Create;

    New(NEW_STEP_ID_OPERATIONDATA);
    NEW_STEP_ID_OPERATIONDATA.workCenterCode := workCenterCode;
    NEW_STEP_ID_OPERATIONDATA.stepNumber := stepNumber;
    NEW_STEP_ID_OPERATIONDATA.initialBasePrimaryQuantity := initialBasePrimaryQuantity;
    NEW_STEP_ID_OPERATIONDATA.finalBasePrimaryQuantity   := finalBasePrimaryQuantity;


    NEW_STEP_ID_WORKCENTER.operationList.Add(NEW_STEP_ID_WORKCENTERDATA);
    NEW_STEP_ID_PRODUCTIONORDER.workCenterList.Add(NEW_STEP_ID_WORKCENTER);

    NEW_STEP_ID_OPERATION.workCenterList.Add(NEW_STEP_ID_OPERATIONDATA);
    NEW_STEP_ID_PRODUCTIONORDER.operationList.Add(NEW_STEP_ID_OPERATION);

    NEW_STEP_ID_PRODUCTIONORDER.stepIdList.Add(NEW_STEP_ID_STEP);

    stepIdListForProgressList_PO.Add(NEW_STEP_ID_PRODUCTIONORDER);
    stepIdListForProgressList_PO_SL.AddObject(orderCode, TObject(NEW_STEP_ID_PRODUCTIONORDER));
  end;

end;

//----------------------------------------------------------------------------//

procedure convertListToStruct(progressList: TList; progressStruct: TList; needToHandleMergeOperation : boolean ;productionDemandCounters : TList);
var
  progressIndex: Integer;
  i,J: Integer;
  lastMachineCode: String;

  index: Integer;

  NEW_PROG_MACHINE: PPROG_MACHINES;
  NEW_PROG_DEMANDANDORDER: PPROG_DEMANDANDORDERS;
  NEW_PROGRESS_ITEM: PPROGRESS_ITEMS;
  StrProdReq : string;
begin

  NEW_PROG_MACHINE := NIL;
  lastMachineCode := '';
  progressIndex := 0;

  for i := 0 to progressList.Count - 1 do
  begin
    if needToHandleMergeOperation then
    begin
      StrProdReq := PPROGRESSES(progressList.Items[i]).KEY_CODE;
      CheckMerge(StrProdReq, PPROGRESSES(progressList.Items[i]).DEMANDCOUNTERCODE, productionDemandCounters);
      PPROGRESSES(progressList.Items[i]).KEY_CODE := StrProdReq;
    end;
  end;

  for i := 0 to progressList.Count - 1 do
  begin
    if ((PPROGRESSES(progressList.Items[i]).MACHINECODE) <> lastMachineCode) then
    begin
      New(NEW_PROG_MACHINE);

      NEW_PROG_MACHINE.MachineCode := PPROGRESSES(progressList.Items[i]).MACHINECODE;
      NEW_PROG_MACHINE.demandAndOrderList := TList.Create;

      lastMachineCode := NEW_PROG_MACHINE.MachineCode;
      progressIndex := 1;

      New(NEW_PROG_DEMANDANDORDER);
      addDemandAndOrderToProg_Machine(NEW_PROG_MACHINE, NEW_PROG_DEMANDANDORDER,
                                      PPROGRESSES(progressList.Items[i]));

      New(NEW_PROGRESS_ITEM);
      addProgressItemToProg_DemandAndOrder(NEW_PROG_DEMANDANDORDER, NEW_PROGRESS_ITEM,
                                           PPROGRESSES(progressList.Items[i]),
                                           progressIndex);

      progressStruct.Add(NEW_PROG_MACHINE);
    end
    else
    begin
      progressIndex := progressIndex + 1;

     // index := searchInList(NEW_PROG_MACHINE.demandAndOrderList, 31,
     //                       PPROGRESSES(progressList.Items[i]).KEY_CODE, 0,
     //                       NEW_PROG_MACHINE.demandAndOrderList.Count - 1);
      index := -1;
      for J := 0 to NEW_PROG_MACHINE.demandAndOrderList.Count - 1 do
      begin
        if PPROG_DEMANDANDORDERS(NEW_PROG_MACHINE.demandAndOrderList[J]).demandAndOrderCode = PPROGRESSES(progressList.Items[i]).KEY_CODE then
        begin
          Index := J;
          break
        end;
      end;

      if (index = -1) then
      begin
        New(NEW_PROG_DEMANDANDORDER);
        addDemandAndOrderToProg_Machine(NEW_PROG_MACHINE, NEW_PROG_DEMANDANDORDER,
                                      PPROGRESSES(progressList.Items[i]));

        New(NEW_PROGRESS_ITEM);
        addProgressItemToProg_DemandAndOrder(NEW_PROG_DEMANDANDORDER, NEW_PROGRESS_ITEM,
                                             PPROGRESSES(progressList.Items[i]),
                                             progressIndex);
      end
      else
      begin
        NEW_PROG_DEMANDANDORDER := PPROG_DEMANDANDORDERS(NEW_PROG_MACHINE.demandAndOrderList.Items[index]);

        New(NEW_PROGRESS_ITEM);
        addProgressItemToProg_DemandAndOrder(NEW_PROG_DEMANDANDORDER, NEW_PROGRESS_ITEM,
                                             PPROGRESSES(progressList.Items[i]),
                                             progressIndex);
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure addDemandAndOrderToProg_Machine(CUR_PROG_MACHINE: PPROG_MACHINES;
                                          NEW_PROG_DEMANDANDORDER: PPROG_DEMANDANDORDERS;
                                          CUR_PROGRESS: PPROGRESSES);
begin
  NEW_PROG_DEMANDANDORDER.demandAndOrderCode := CUR_PROGRESS.KEY_CODE;
  NEW_PROG_DEMANDANDORDER.progList := TList.Create;

  CUR_PROG_MACHINE.demandAndOrderList.Add(NEW_PROG_DEMANDANDORDER);
end;

//----------------------------------------------------------------------------//

procedure addProgressItemToProg_DemandAndOrder(CUR_PROG_DEMANDANDORDER: PPROG_DEMANDANDORDERS;
                                               NEW_PROGRESS_ITEM: PPROGRESS_ITEMS;
                                               CUR_PROGRESS: PPROGRESSES;
                                               progressIndex: Integer);
begin
  NEW_PROGRESS_ITEM.PROGRESSNUMBER := CUR_PROGRESS.PROGRESSNUMBER;
  NEW_PROGRESS_ITEM.PROGRESSSTATUS := CUR_PROGRESS.PROGRESSSTATUS;
  NEW_PROGRESS_ITEM.PRODUCTIONORDERCODE := CUR_PROGRESS.PRODUCTIONORDERCODE;
  NEW_PROGRESS_ITEM.DEMANDCOUNTERCODE := CUR_PROGRESS.DEMANDCOUNTERCODE;
  NEW_PROGRESS_ITEM.DEMANDCODE := CUR_PROGRESS.DEMANDCODE;
  NEW_PROGRESS_ITEM.STEPNUMBER := CUR_PROGRESS.STEPNUMBER;
  NEW_PROGRESS_ITEM.PROGRESSTYPE := CUR_PROGRESS.PROGRESSTYPE;

  NEW_PROGRESS_ITEM.PROGRESSSTARTQUEUEDATE := CUR_PROGRESS.PROGRESSSTARTQUEUEDATE;
  NEW_PROGRESS_ITEM.PROGRESSSTARTPREPROCESSDATE := CUR_PROGRESS.PROGRESSSTARTPREPROCESSDATE;
  NEW_PROGRESS_ITEM.PROGRESSSTARTPROCESSDATE := CUR_PROGRESS.PROGRESSSTARTPROCESSDATE;
  NEW_PROGRESS_ITEM.PROGRESSSTARTPOSTPROCESSDATE := CUR_PROGRESS.PROGRESSSTARTPOSTPROCESSDATE;
  NEW_PROGRESS_ITEM.PROGRESSPARTIALENDDATE := CUR_PROGRESS.PROGRESSPARTIALENDDATE;
  NEW_PROGRESS_ITEM.PROGRESSENDDATE := CUR_PROGRESS.PROGRESSENDDATE;

  NEW_PROGRESS_ITEM.PROGRESSSTARTQUEUETIME := CUR_PROGRESS.PROGRESSSTARTQUEUETIME;
  NEW_PROGRESS_ITEM.PROGRESSSTARTPREPROCESSTIME := CUR_PROGRESS.PROGRESSSTARTPREPROCESSTIME;
  NEW_PROGRESS_ITEM.PROGRESSSTARTPROCESSTIME := CUR_PROGRESS.PROGRESSSTARTPROCESSTIME;
  NEW_PROGRESS_ITEM.PROGRESSSTARTPOSTPROCESSTIME := CUR_PROGRESS.PROGRESSSTARTPOSTPROCESSTIME;
  NEW_PROGRESS_ITEM.PROGRESSPARTIALENDTIME := CUR_PROGRESS.PROGRESSPARTIALENDTIME;
  NEW_PROGRESS_ITEM.PROGRESSENDTIME := CUR_PROGRESS.PROGRESSENDTIME;

  NEW_PROGRESS_ITEM.PRIMARYQTY := CUR_PROGRESS.PRIMARYQTY;
  NEW_PROGRESS_ITEM.PRIMARYUOMCODE := CUR_PROGRESS.PRIMARYUOMCODE;
  NEW_PROGRESS_ITEM.MACHINECODE := CUR_PROGRESS.MACHINECODE;
  NEW_PROGRESS_ITEM.WORKCENTERCODE := CUR_PROGRESS.WORKCENTERCODE;
  NEW_PROGRESS_ITEM.OPERATIONCODE := CUR_PROGRESS.OPERATIONCODE;
  NEW_PROGRESS_ITEM.KEY_CODE := CUR_PROGRESS.KEY_CODE;
  NEW_PROGRESS_ITEM.KEY_DATETIME := CUR_PROGRESS.KEY_DATETIME;
  NEW_PROGRESS_ITEM.TEMPLATE_QUANTITYTYPE := CUR_PROGRESS.TEMPLATE_QUANTITYTYPE;
  NEW_PROGRESS_ITEM.STEPINITIALQUANTITY := CUR_PROGRESS.STEPINITIALQUANTITY;
  NEW_PROGRESS_ITEM.STEPFINALQUANTITY := CUR_PROGRESS.STEPFINALQUANTITY;
  NEW_PROGRESS_ITEM.progressIndex := progressIndex;

  NEW_PROGRESS_ITEM.PRODUCTIONORDERFLAG := CUR_PROGRESS.PRODUCTIONORDERFLAG;

  CUR_PROG_DEMANDANDORDER.progList.Add(NEW_PROGRESS_ITEM);
end;

//----------------------------------------------------------------------------//

function getBalanceHeaderInfoArea(typeStr: String; code: String): String;
var
  info: String;
begin
  if (typeStr = '0') then
    info := 'Allocation origin'
  else if (typeStr = '1') then
    info := 'Allocation destination'
  else if (typeStr = '3') then
    info := 'Sales order'
  else if (typeStr = '4') then
    info := 'Sales document'
  else if (typeStr = '5') then
    info := 'Sales realease'
  else if (typeStr = '6') then
    info := 'Purchase order'
  else if (typeStr = '6R') then
    info := 'Purchase return'
  else if (typeStr = '7') then
    info := 'Internal order'
  else if (typeStr = '8') then
    info := 'Internal document'
  else if (typeStr = '8D') then
    info := 'Internal document(Dest. Wh)'
  else if (typeStr = 'PO') then
    info := 'Production order'
  else if (typeStr = 'P') then
    info := 'Production reservation'
  else if (typeStr = 'PS') then
    info := 'Production reservation sub contractor'
  else if (typeStr = 'PP') then
    info := 'Production reservation per sub contractor'
  else if (typeStr = '9') then
    info := 'Stock'
  else if (typeStr = '9A') then
    info := 'Item warehouse link'
  else if (typeStr = '9B') then
    info := 'Full item warehouse link'
  else
    info := '';

  if (Trim(code) <> '') then
    info := info + ': ' + code;

  Result := copy(info, 1, 70);


end;

//----------------------------------------------------------------------------//

procedure addNewPROD_SCHED_PROGRESSWithPercentage(PREQ_NO: String;
                                    PROD_SCHED_PROGRESS: PPROD_SCHED_PROGRESSES;
                                    percentageStr: String; read_prod_sched_progress_list: TList);
var
  NEW_PROD_SCHED_PROGRESS: PPROD_SCHED_PROGRESSES;
begin
  New(NEW_PROD_SCHED_PROGRESS);
  NEW_PROD_SCHED_PROGRESS.SP_PREQ_NO := PREQ_NO;
  NEW_PROD_SCHED_PROGRESS.SP_PSTEP_ID := PROD_SCHED_PROGRESS.SP_PSTEP_ID;
  NEW_PROD_SCHED_PROGRESS.SP_PSUBST_ID := PROD_SCHED_PROGRESS.SP_PSUBST_ID;
  NEW_PROD_SCHED_PROGRESS.SP_REPROC_NO := PROD_SCHED_PROGRESS.SP_REPROC_NO;
  NEW_PROD_SCHED_PROGRESS.SP_LAST_PROG_TYPE := PROD_SCHED_PROGRESS.SP_LAST_PROG_TYPE;
  NEW_PROD_SCHED_PROGRESS.SP_RSC_CODE := PROD_SCHED_PROGRESS.SP_RSC_CODE;
  NEW_PROD_SCHED_PROGRESS.SP_PROGRESED_GROUP := PROD_SCHED_PROGRESS.SP_PROGRESED_GROUP;
  NEW_PROD_SCHED_PROGRESS.SP_PROGRSTART := PROD_SCHED_PROGRESS.SP_PROGRSTART;
  NEW_PROD_SCHED_PROGRESS.SP_CURR_PRG_DATE := PROD_SCHED_PROGRESS.SP_CURR_PRG_DATE;
  NEW_PROD_SCHED_PROGRESS.SP_PROGREND := PROD_SCHED_PROGRESS.SP_PROGREND;

  //NEW_PROD_SCHED_PROGRESS.SP_QTY := FloatToStr(StrToFloat(PROD_SCHED_PROGRESS.SP_QTY) * StrToFloat(percentageStr));
  //NEW_PROD_SCHED_PROGRESS.SP_QTY := FloatToStrF(StrToFloat(PROD_SCHED_PROGRESS.SP_QTY) * StrToFloat(percentageStr), ffNumber, 11, 2);
  NEW_PROD_SCHED_PROGRESS.SP_QTY := FloatToStrF(StrToFloat(PROD_SCHED_PROGRESS.SP_QTY) * StrToFloat(percentageStr), ffGeneral, 11, 2);

  NEW_PROD_SCHED_PROGRESS.SP_REMAIN_TIME := PROD_SCHED_PROGRESS.SP_REMAIN_TIME;

  NEW_PROD_SCHED_PROGRESS.DEMANDCOUNTERCODE := PROD_SCHED_PROGRESS.DEMANDCOUNTERCODE;
  read_prod_sched_progress_list.Add(NEW_PROD_SCHED_PROGRESS);
end;

//----------------------------------------------------------------------------//

function addNewPROD_SCHED_PROGRESSWithQty(PREQ_NO: String; PROD_SCHED_PROGRESS: PPROD_SCHED_PROGRESSES;
                                    Qty: String; read_prod_sched_progress_list: TList): boolean;
var
  NEW_PROD_SCHED_PROGRESS: PPROD_SCHED_PROGRESSES;
begin
  New(NEW_PROD_SCHED_PROGRESS);
  NEW_PROD_SCHED_PROGRESS.SP_PREQ_NO := PREQ_NO;
  NEW_PROD_SCHED_PROGRESS.SP_PSTEP_ID := PROD_SCHED_PROGRESS.SP_PSTEP_ID;
  NEW_PROD_SCHED_PROGRESS.SP_PSUBST_ID := PROD_SCHED_PROGRESS.SP_PSUBST_ID;
  NEW_PROD_SCHED_PROGRESS.SP_REPROC_NO := PROD_SCHED_PROGRESS.SP_REPROC_NO;
  NEW_PROD_SCHED_PROGRESS.SP_LAST_PROG_TYPE := PROD_SCHED_PROGRESS.SP_LAST_PROG_TYPE;
  NEW_PROD_SCHED_PROGRESS.SP_RSC_CODE := PROD_SCHED_PROGRESS.SP_RSC_CODE;
  NEW_PROD_SCHED_PROGRESS.SP_PROGRESED_GROUP := PROD_SCHED_PROGRESS.SP_PROGRESED_GROUP;
  NEW_PROD_SCHED_PROGRESS.SP_PROGRSTART := PROD_SCHED_PROGRESS.SP_PROGRSTART;
  NEW_PROD_SCHED_PROGRESS.SP_CURR_PRG_DATE := PROD_SCHED_PROGRESS.SP_CURR_PRG_DATE;
  NEW_PROD_SCHED_PROGRESS.SP_PROGREND := PROD_SCHED_PROGRESS.SP_PROGREND;

  if ( (StrToFloat(PROD_SCHED_PROGRESS.SP_QTY) - StrToFloat(Qty)) >= 0) then
  begin
    NEW_PROD_SCHED_PROGRESS.SP_QTY := FloatToStrF(StrToFloat(PROD_SCHED_PROGRESS.SP_QTY), ffGeneral, 11, 2);

    NEW_PROD_SCHED_PROGRESS.SP_LAST_PROG_TYPE := '3';
    PROD_SCHED_PROGRESS.SP_QTY := FloatToStr(StrToFloat(PROD_SCHED_PROGRESS.SP_QTY) - StrToFloat(Qty));

    Result := true;
  end
  else
  begin
    //changed by Erbil at 06.10.2009
    //NEW_PROD_SCHED_PROGRESS.SP_QTY := FloatToStrF(StrToFloat(Qty) - StrToFloat(PROD_SCHED_PROGRESS.SP_QTY), ffGeneral, 11, 2);
    NEW_PROD_SCHED_PROGRESS.SP_QTY := PROD_SCHED_PROGRESS.SP_QTY;

   // NEW_PROD_SCHED_PROGRESS.SP_LAST_PROG_TYPE := '1';  // avi 12/10/09
    PROD_SCHED_PROGRESS.SP_QTY := '0';
    Result := false;
  end;

  NEW_PROD_SCHED_PROGRESS.SP_REMAIN_TIME := PROD_SCHED_PROGRESS.SP_REMAIN_TIME;
  NEW_PROD_SCHED_PROGRESS.DEMANDCOUNTERCODE := PROD_SCHED_PROGRESS.DEMANDCOUNTERCODE;
  read_prod_sched_progress_list.Add(NEW_PROD_SCHED_PROGRESS);
end;

//----------------------------------------------------------------------------//

procedure fillUnique_nonUniqueWorkCenterProcesses(workCenterCode: String; processCode: String;
                                                  uniqueWorkCenterProcesses: TStringlist;
                                                  nonUniqueWorkCenterProcesses: TStringList);
var
  searchFor: String;
begin
  searchFor := Trim(workCenterCode) + ' ' + Trim(processCode);

  if nonUniqueWorkCenterProcesses.IndexOf(searchFor) = -1 then
  begin
    if uniqueWorkCenterProcesses.IndexOf(searchFor) = -1 then
      uniqueWorkCenterProcesses.Add(searchFor)
    else
    begin
      uniqueWorkCenterProcesses.Delete(uniqueWorkCenterProcesses.IndexOf(searchFor));
      nonUniqueWorkCenterProcesses.Add(searchFor);
    end;
  end;
end;

//----------------------------------------------------------------------------//

function setItemTypeTemplate(itemTypeTemplates: TList; itemTypeCode: String;
                              productionDemandTemplateCode: String;
                              workCenterCode: String; ProcessCode: String): PITEMTYPEPRODUCTIONDEMANDTEMPLATES;
                              //ITPDTEMPLATE: PITEMTYPEPRODUCTIONDEMANDTEMPLATES): PITEMTYPEPRODUCTIONDEMANDTEMPLATES;
var
  templateIndex: integer;
  CUR_ITEMTYPETEMPLATE: PITEMTYPETEMPLATES;
  CUR_ITEMTYPEPRODUCTIONDEMANDTEMPLATE: PITEMTYPEPRODUCTIONDEMANDTEMPLATES;
  I : Integer;
begin
  Result := nil;
  templateIndex := searchInList(itemTypeTemplates, 34,
                                Trim(itemTypeCode),
                                0, itemTypeTemplates.Count - 1);

  if (templateIndex <> -1) then
  begin
    CUR_ITEMTYPETEMPLATE := itemTypeTemplates.Items[templateIndex];

   { templateIndex := searchInList(CUR_ITEMTYPETEMPLATE.productionDemandTemplateList, 35,
                                  Trim(productionDemandTemplateCode),
                                  0, CUR_ITEMTYPETEMPLATE.productionDemandTemplateList.Count - 1);

    if (templateIndex <> -1) then
    begin
      CUR_ITEMTYPEPRODUCTIONDEMANDTEMPLATE := CUR_ITEMTYPETEMPLATE.productionDemandTemplateList.Items[templateIndex];

      if ( (Trim(CUR_ITEMTYPEPRODUCTIONDEMANDTEMPLATE.WORKCENTERFORSPLIT) = Trim(workCenterCode)) AND
           (Trim(CUR_ITEMTYPEPRODUCTIONDEMANDTEMPLATE.OPERATIONFORSPLIT) = Trim(processCode))
         ) then
        result := CUR_ITEMTYPEPRODUCTIONDEMANDTEMPLATE
      else
        result := nil;
    end
    else
      result := nil;
  end
  else
    result := nil;   }


    for I := 0 to CUR_ITEMTYPETEMPLATE.productionDemandTemplateList.Count - 1 do
    begin
      CUR_ITEMTYPEPRODUCTIONDEMANDTEMPLATE := CUR_ITEMTYPETEMPLATE.productionDemandTemplateList.Items[I];
      if ( (Trim(CUR_ITEMTYPEPRODUCTIONDEMANDTEMPLATE.WORKCENTERFORSPLIT) = Trim(workCenterCode)) AND
           (Trim(CUR_ITEMTYPEPRODUCTIONDEMANDTEMPLATE.OPERATIONFORSPLIT) = Trim(processCode)) ) then
      begin
        if productionDemandTemplateCode = (Trim(CUR_ITEMTYPEPRODUCTIONDEMANDTEMPLATE.PRODUCTIONDEMANDTEMPLATECODE)) then
        begin
          result := CUR_ITEMTYPEPRODUCTIONDEMANDTEMPLATE;
          exit
        end;
      end;
    end;

  end;



end;

//----------------------------------------------------------------------------//

function setProductionDemandCounter(productionDemandCounters: TList;
                                    counterCode: String): PPRODUCTIONDEMANDCOUNTERS;
                                    // PDCOUNTER: PPRODUCTIONDEMANDCOUNTERS);
var
  templateIndex: integer;
begin
  templateIndex := searchInList(productionDemandCounters, 36,
                                Trim(counterCode),
                                0, productionDemandCounters.Count - 1);

  if (templateIndex <> -1) then
    result := productionDemandCounters.Items[templateIndex]
  else
    result := nil;
end;

//----------------------------------------------------------------------------//

function insertAlternativesToProdStepTime_List(workCenterCode: String;
                                               operationCode: String;
                                               itemType: String;
                                               UserGenericGroupTypeList, UserGenericGroupTypeAttributesList : TList;
                                               handledWorkCentersList: TList;
                                               MQMProductionColumnValues: PMQMProductionColumnValues;
                                               productionDemandCounters : TList;
                                               additionalDataList: TList;
                                               timeTypeCode: String;
                                               propertyList  : TList;
                                               ColorTypeList : TList;
                                               ColorTypeUNIQUEIDList : TList;
                                              // productPrimaryUomConversionDataList: TList;
                                              // secondaryUnitCategoryConversionList: TList;
                                              // stdUnitCategoryConversionList: TList;
                                               resourceCategory: String; resource: String;
                                               read_prod_step_time_list: TList;
                                               routingStepTimeTypeList: TList;
                                               Items : PTItems;
                                               operationList: TList
                                              ): boolean;
var
  index, indexConcatinated: integer;
  CUR_WORKCENTER: PWORKCENTERS;
  CUR_PROCESS: PPROCESSES;
  CUR_OPERATTRIBUTE: POPERATTRIBUTES;
  CUR_PRODUCTIONTIMESLEVEL: PPRODUCTIONTIMESLEVELS;
  CUR_PRODUCTIONTIME: PPRODUCTIONTIMES;

  anyMQMProduction_Times_LevelFound, Eficiency100Percent: boolean;
  anyMQMWorkCenterAndOperAttributeFound: boolean;
  needToCreateDefaultLine, AttributeFound: boolean;
  i, J: integer;
  PREQ_NO, WcAttributeCode, ConcatinatedValue : string;
  setupTime: double;
  executionTime: double;

  stepInitialQty: double;
  stepStdQty: double;
  quantity: integer;

  stepEfficiency: double;

  NEW_PROD_STEP_TIME: PTMQMST;
  P_ABSUNIQUEID, FIKD_ABSUNIQUEID, ITEMTYPEAFICODE : string;
  SUBCODE01, SUBCODE02, SUBCODE03, SUBCODE04, SUBCODE05,
  SUBCODE06, SUBCODE07, SUBCODE08, SUBCODE09, SUBCODE10 : string;
  OverridenTimeOrQty1, OverridenTimeOrQty2, OverridenTimeOrQty3, OverridenTimeOrQty4, OverridenTimeOrQty5, StepRepetition : String;
begin

  if assigned(Items) then
  begin
    FIKD_ABSUNIQUEID := Items.ABSUNIQUEID;
    P_ABSUNIQUEID    := Items.ABSUNIQUEID_P;
    ITEMTYPEAFICODE  := Items.ITEMTYPEAFICODE;
    SUBCODE01 := Items.SUBCODE01;
    SUBCODE02 := Items.SUBCODE02;
    SUBCODE03 := Items.SUBCODE03;
    SUBCODE04 := Items.SUBCODE04;
    SUBCODE05 := Items.SUBCODE05;
    SUBCODE06 := Items.SUBCODE06;
    SUBCODE07 := Items.SUBCODE07;
    SUBCODE08 := Items.SUBCODE08;
    SUBCODE09 := Items.SUBCODE09;
    SUBCODE10 := Items.SUBCODE10;
  end;

  anyMQMProduction_Times_LevelFound := false;
  anyMQMWorkCenterAndOperAttributeFound := false;
  needToCreateDefaultLine := true;
  Result := false;
  CUR_OPERATTRIBUTE := nil;
  CUR_PRODUCTIONTIMESLEVEL := nil;

  index := searchInList(handledWorkCentersList, 1, workCenterCode,
                        0, handledWorkCentersList.Count - 1);

  if ( index <> -1 ) then
  begin
    CUR_WORKCENTER :=  handledWorkCentersList.Items[index];

    index := searchInList(CUR_WORKCENTER.Process_List, 2, Trim(operationCode),
                          0, CUR_WORKCENTER.Process_List.Count - 1);

    if ( index <> -1 ) then
    begin
      CUR_PROCESS :=  CUR_WORKCENTER.Process_List.Items[index];

      if CUR_PROCESS.OperAttributes_List.Count > 0 then
        CUR_OPERATTRIBUTE := CUR_PROCESS.OperAttributes_List.Items[0]
      else
        CUR_OPERATTRIBUTE := nil;

      index := searchInList(CUR_PROCESS.ProductionTimesLevel_List, 6, itemType,
                      0, CUR_PROCESS.ProductionTimesLevel_List.Count - 1);

      if ( index <> -1 ) then
      begin
        CUR_PRODUCTIONTIMESLEVEL := CUR_PROCESS.ProductionTimesLevel_List.Items[index];
        anyMQMProduction_Times_LevelFound := true;
      end;
    end;
  end;

  if (CUR_OPERATTRIBUTE <> nil) then
    anyMQMWorkCenterAndOperAttributeFound := true;

  if anyMQMProduction_Times_LevelFound then
  begin
    if anyMQMWorkCenterAndOperAttributeFound and (CUR_PRODUCTIONTIMESLEVEL.HANDLE_TIMES_BY = '1') then
    begin

      if getValues(CUR_PRODUCTIONTIMESLEVEL,
                         MQMProductionColumnValues,
                         Items,
                         UserGenericGroupTypeList, UserGenericGroupTypeAttributesList,
                         propertyList,
                         ColorTypeList, ColorTypeUNIQUEIDList,
                         additionalDataList, ConcatinatedValue) then

      begin
        indexConcatinated := GetTimeStartingIndex(CUR_PRODUCTIONTIMESLEVEL, ConcatinatedValue);

        if indexConcatinated = -1 then exit;

        for i := indexConcatinated to CUR_PRODUCTIONTIMESLEVEL.ProductionTimes_List.Count - 1 do
        begin
          CUR_PRODUCTIONTIME := CUR_PRODUCTIONTIMESLEVEL.ProductionTimes_List.Items[i];

          if CUR_PRODUCTIONTIME.StrConcatination <> ConcatinatedValue then break;

          if ( (Trim(CUR_PRODUCTIONTIME.RESOURCE_CATEGORY) = '') AND
               (Trim(CUR_PRODUCTIONTIME.RESOURCE) = '')
             ) then
            needToCreateDefaultLine := false;

          setupTime := getDoubleFromStr(CUR_PRODUCTIONTIME.SETUP_TIME);

         { if ( checkValues(CUR_PRODUCTIONTIMESLEVEL,
                           MQMProductionColumnValues,
                           Items,
                           propertyList,
                           ColorTypeList, ColorTypeUNIQUEIDList,
                           additionalDataList, RetrnString)
             ) then
          begin  }
          if ( timeTypeCode = 'B' ) then
             executionTime := getDoubleFromStr(CUR_PRODUCTIONTIME.BATCH_TIME)
          else
          begin
            stepInitialQty := getDoubleFromStr( getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_INITIALBASEPRIMARYQUANTITY', PDS_INITIALBASEPRIMARYQUANTITY) );

            executionTime := ConvertUM(MQMProductionColumnValues, getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_BASEPRIMARYUOMCODE', PD_BASEPRIMARYUOMCODE),CUR_PRODUCTIONTIME.CONTINUOUS_OPERATION_UM,
                                       1,
                                       ITEMTYPEAFICODE,
                                       SUBCODE01, SUBCODE02, SUBCODE03, SUBCODE04, SUBCODE05,
                                       SUBCODE06, SUBCODE07, SUBCODE08, SUBCODE09, SUBCODE10);
            if executionTime = 0 then executionTime := 1; // temp

            if trim(CUR_PRODUCTIONTIME.CONTINUOUS_TIME) <> '' then
              executionTime :=  (stepInitialQty * executionTime / StrToFloat(CUR_PRODUCTIONTIME.CONTINUOUS_TIME));
          end;

          if ( Trim(CUR_PRODUCTIONTIME.CONSIDER_STEP_EFFICIENCY) = '1' ) then
          begin
            stepEfficiency := (StrToFloat(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_STEPEFFICIENCY', PDS_STEPEFFICIENCY)));
            executionTime := executionTime / (stepEfficiency / 100);
          end;
       // end;

          New(NEW_PROD_STEP_TIME);
          NEW_PROD_STEP_TIME.ST_PREQ_NO := setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COMPANYCODE', PD_COMPANYCODE), 3) +
                                           setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COUNTERCODE', PD_COUNTERCODE), 8) +
                                           getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_CODE', PD_CODE);
          NEW_PROD_STEP_TIME.ST_PSTEP_ID := StrToInt(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_STEPNUMBER', PDS_STEPNUMBER));
          NEW_PROD_STEP_TIME.ST_WKCNTER := workCenterCode;
          NEW_PROD_STEP_TIME.ST_WKCT_PROC := operationCode;
//          NEW_PROD_STEP_TIME.ST_RES_CATEGORY := resourceCategory;
//          NEW_PROD_STEP_TIME.ST_RSC_CODE := resource;

          NEW_PROD_STEP_TIME.ST_RES_CATEGORY := CUR_PRODUCTIONTIME.RESOURCE_CATEGORY;//resourceCategory; avi
          NEW_PROD_STEP_TIME.ST_RSC_CODE := CUR_PRODUCTIONTIME.RESOURCE;//resource; avi
          NEW_PROD_STEP_TIME.ST_SETUP_TIME_Mechin_Code := '';
          NEW_PROD_STEP_TIME.ST_SETUP_TIME_JOB := setupTime;
          NEW_PROD_STEP_TIME.ST_EXC_TIME_INIT_QTY := executionTime;
          if (NEW_PROD_STEP_TIME.ST_EXC_TIME_INIT_QTY > 0) and (NEW_PROD_STEP_TIME.ST_EXC_TIME_INIT_QTY < 1/60) then
             NEW_PROD_STEP_TIME.ST_EXC_TIME_INIT_QTY := 0.017;

          NEW_PROD_STEP_TIME.ST_timeTypeCode := timeTypeCode;

          PREQ_NO := NEW_PROD_STEP_TIME.ST_PREQ_NO;
          if CheckMerge(PREQ_NO, setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COUNTERCODE', PD_COUNTERCODE), 8), productionDemandCounters) then
          begin
            NEW_PROD_STEP_TIME.ST_FAMILYCODE := PREQ_NO;
            m_NeedToMakeMerge := true
          end;

          NEW_PROD_STEP_TIME.ST_TimeArriveFromNowStep := false;
          if (NEW_PROD_STEP_TIME.ST_timeTypeCode = 'B') OR (NEW_PROD_STEP_TIME.ST_timeTypeCode = 'P') then
          begin
            NEW_PROD_STEP_TIME.ST_BatchTimeType := CUR_PROCESS.WP_BATCHSTANDARDTIME;
            NEW_PROD_STEP_TIME.ST_ProductionOrderCode := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_PRODUCTIONORDERCODE', PDS_PRODUCTIONORDERCODE);
            NEW_PROD_STEP_TIME.ST_GroupStepNumber := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_GROUPSTEPNUMBER', PDS_GROUPSTEPNUMBER);
            NEW_PROD_STEP_TIME.ST_CalcTime2 := StrToFloat(getNumericValueOf(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_CALCULATEDTIME2', PDS_CALCULATEDTIME2)));
            NEW_PROD_STEP_TIME.ST_CalcTime3 := StrToFloat(getNumericValueOf(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_CALCULATEDTIME3', PDS_CALCULATEDTIME3)));
            NEW_PROD_STEP_TIME.ST_INITIALBASEPRIMARYQUANTITY := StrToFloat(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_INITIALBASEPRIMARYQUANTITY', PDS_INITIALBASEPRIMARYQUANTITY));
            if CUR_PRODUCTIONTIMESLEVEL <> nil then
              NEW_PROD_STEP_TIME.ST_BatchTimeType := CUR_PRODUCTIONTIMESLEVEL.HANDLE_TIMES_BY;
            NEW_PROD_STEP_TIME.ST_multiplierExecution := 0;
            NEW_PROD_STEP_TIME.ST_multiplierSetUp := 0;
          end;
          read_prod_step_time_list.Add(NEW_PROD_STEP_TIME);

        end;

      end;
    end
    else if anyMQMWorkCenterAndOperAttributeFound and (CUR_PRODUCTIONTIMESLEVEL.HANDLE_TIMES_BY = '3') then //Multiplier
    begin

      if getValues(CUR_PRODUCTIONTIMESLEVEL,
                         MQMProductionColumnValues,
                         Items,
                         UserGenericGroupTypeList, UserGenericGroupTypeAttributesList,
                         propertyList,
                         ColorTypeList, ColorTypeUNIQUEIDList,
                         additionalDataList, ConcatinatedValue) then

      begin
        indexConcatinated := GetTimeStartingIndex(CUR_PRODUCTIONTIMESLEVEL, ConcatinatedValue);

        if indexConcatinated = -1 then exit;

        for i := indexConcatinated to CUR_PRODUCTIONTIMESLEVEL.ProductionTimes_List.Count - 1 do
        begin

          CUR_PRODUCTIONTIME := CUR_PRODUCTIONTIMESLEVEL.ProductionTimes_List.Items[i];

          if CUR_PRODUCTIONTIME.StrConcatination <> ConcatinatedValue then break;

          if ( (Trim(CUR_PRODUCTIONTIME.RESOURCE_CATEGORY) = '') AND
              (Trim(CUR_PRODUCTIONTIME.RESOURCE) = '')) then
            needToCreateDefaultLine := false;

        {if ( getValues(CUR_PRODUCTIONTIMESLEVEL,
                         MQMProductionColumnValues,
                         Items,
                         propertyList,
                         ColorTypeList, ColorTypeUNIQUEIDList,
                         additionalDataList, ConcatinatedValue)
           ) then
        begin }
          if ( timeTypeCode = 'B' ) then
          begin
            stepInitialQty := getDoubleFromStr( getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_INITIALBASEPRIMARYQUANTITY', PDS_INITIALBASEPRIMARYQUANTITY) );

            stepStdQty := ConvertUM(MQMProductionColumnValues, //CUR_OPERATTRIBUTE.STANDARDSTEPQTYUOMCODE,
                                    getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_STANDARDSTEPQUANTITYUOMCODE', PDS_STANDARDSTEPQUANTITYUOMCODE),
                                    getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_BASEPRIMARYUOMCODE', PD_BASEPRIMARYUOMCODE),
                                    StrToFloat(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_STANDARDSTEPQUANTITY', PDS_STANDARDSTEPQUANTITY)),
                                    ITEMTYPEAFICODE,
                                    SUBCODE01, SUBCODE02, SUBCODE03, SUBCODE04, SUBCODE05,
                                    SUBCODE06, SUBCODE07, SUBCODE08, SUBCODE09, SUBCODE10);
            if ( stepStdQty = 0 ) then
            begin

              stepStdQty := ConvertUM(MQMProductionColumnValues, getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_STANDARDSTEPQUANTITYUOMCODE', PDS_STANDARDSTEPQUANTITYUOMCODE),
                                    getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_BASEPRIMARYUOMCODE', PD_BASEPRIMARYUOMCODE),
                                    StrToFloat(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_STDPRODUCTIONBATCH', PD_STDPRODUCTIONBATCH)),
                                    ITEMTYPEAFICODE,
                                    SUBCODE01, SUBCODE02, SUBCODE03, SUBCODE04, SUBCODE05,
                                    SUBCODE06, SUBCODE07, SUBCODE08, SUBCODE09, SUBCODE10);
            end;

            if ( stepStdQty = 0 ) then
              stepStdQty := 1;

            quantity := Ceil(stepInitialQty / stepStdQty);
          end
          else
            quantity := 1;

          setupTime := getDoubleFromStr(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_CALCULATEDTIME2', PDS_CALCULATEDTIME2));
          executionTime := getDoubleFromStr(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_CALCULATEDTIME3', PDS_CALCULATEDTIME3));

          setupTime := (setupTime / quantity) * 60 * getDoubleFromStr(CUR_PRODUCTIONTIME.SETUP_TIME_MULTIPLIER);
          executionTime := (executionTime / quantity) * 60 * getDoubleFromStr(CUR_PRODUCTIONTIME.OPERATION_TIME_MULTIPLIER);

          New(NEW_PROD_STEP_TIME);
          NEW_PROD_STEP_TIME.ST_PREQ_NO := setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COMPANYCODE', PD_COMPANYCODE), 3) +
                                           setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COUNTERCODE', PD_COUNTERCODE), 8) +
                                           getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_CODE', PD_CODE);
          NEW_PROD_STEP_TIME.ST_PSTEP_ID := StrToInt(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_STEPNUMBER', PDS_STEPNUMBER));
          NEW_PROD_STEP_TIME.ST_WKCNTER := workCenterCode;
          NEW_PROD_STEP_TIME.ST_WKCT_PROC := operationCode;
//          NEW_PROD_STEP_TIME.ST_RES_CATEGORY := resourceCategory;
//          NEW_PROD_STEP_TIME.ST_RSC_CODE := resource;

          NEW_PROD_STEP_TIME.ST_RES_CATEGORY := CUR_PRODUCTIONTIME.RESOURCE_CATEGORY;//resourceCategory; avi
          NEW_PROD_STEP_TIME.ST_RSC_CODE := CUR_PRODUCTIONTIME.RESOURCE;//resource; avi
          NEW_PROD_STEP_TIME.ST_SETUP_TIME_Mechin_Code := '';
          NEW_PROD_STEP_TIME.ST_SETUP_TIME_JOB := setupTime;
          NEW_PROD_STEP_TIME.ST_EXC_TIME_INIT_QTY := executionTime;
          if (NEW_PROD_STEP_TIME.ST_EXC_TIME_INIT_QTY > 0) and (NEW_PROD_STEP_TIME.ST_EXC_TIME_INIT_QTY < 1/60) then
             NEW_PROD_STEP_TIME.ST_EXC_TIME_INIT_QTY := 0.017;

          NEW_PROD_STEP_TIME.ST_timeTypeCode := timeTypeCode;

          PREQ_NO := NEW_PROD_STEP_TIME.ST_PREQ_NO;
          if CheckMerge(PREQ_NO, setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COUNTERCODE', PD_COUNTERCODE), 8), productionDemandCounters) then
          begin
            NEW_PROD_STEP_TIME.ST_FAMILYCODE := PREQ_NO;
            m_NeedToMakeMerge := true
          end;

          NEW_PROD_STEP_TIME.ST_TimeArriveFromNowStep := true;
          if (NEW_PROD_STEP_TIME.ST_timeTypeCode = 'B') OR (NEW_PROD_STEP_TIME.ST_timeTypeCode = 'P') then
          begin
            NEW_PROD_STEP_TIME.ST_BatchTimeType := CUR_PROCESS.WP_BATCHSTANDARDTIME;
            NEW_PROD_STEP_TIME.ST_multiplierExecution := getDoubleFromStr(CUR_PRODUCTIONTIME.OPERATION_TIME_MULTIPLIER);
            NEW_PROD_STEP_TIME.ST_multiplierSetUp := getDoubleFromStr(CUR_PRODUCTIONTIME.SETUP_TIME_MULTIPLIER);
            NEW_PROD_STEP_TIME.ST_ProductionOrderCode := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_PRODUCTIONORDERCODE', PDS_PRODUCTIONORDERCODE);
            NEW_PROD_STEP_TIME.ST_GroupStepNumber := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_GROUPSTEPNUMBER', PDS_GROUPSTEPNUMBER);
            NEW_PROD_STEP_TIME.ST_CalcTime2 := StrToFloat(getNumericValueOf(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_CALCULATEDTIME2', PDS_CALCULATEDTIME2)));
            NEW_PROD_STEP_TIME.ST_CalcTime3 := StrToFloat(getNumericValueOf(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_CALCULATEDTIME3', PDS_CALCULATEDTIME3)));
            NEW_PROD_STEP_TIME.ST_INITIALBASEPRIMARYQUANTITY := StrToFloat(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_INITIALBASEPRIMARYQUANTITY', PDS_INITIALBASEPRIMARYQUANTITY));
            NEW_PROD_STEP_TIME.ST_STANDARDSTEPQUANTITY       := stepStdQty;
          end;
          read_prod_step_time_list.Add(NEW_PROD_STEP_TIME);
        end;
      end;
    end
    else if anyMQMWorkCenterAndOperAttributeFound and (CUR_PRODUCTIONTIMESLEVEL.HANDLE_TIMES_BY = '2') then //Work center operation attribute and multiplier
    begin

      if getValues(CUR_PRODUCTIONTIMESLEVEL,
                         MQMProductionColumnValues,
                         Items,
                         UserGenericGroupTypeList, UserGenericGroupTypeAttributesList,
                         propertyList,
                         ColorTypeList, ColorTypeUNIQUEIDList,
                         additionalDataList, ConcatinatedValue) then

      begin
        indexConcatinated := GetTimeStartingIndex(CUR_PRODUCTIONTIMESLEVEL, ConcatinatedValue);

        if indexConcatinated = -1 then exit;

        for i := indexConcatinated to CUR_PRODUCTIONTIMESLEVEL.ProductionTimes_List.Count - 1 do
        begin
          CUR_PRODUCTIONTIME := CUR_PRODUCTIONTIMESLEVEL.ProductionTimes_List.Items[i];

          if CUR_PRODUCTIONTIME.StrConcatination <> ConcatinatedValue then break;

          if ( (Trim(CUR_PRODUCTIONTIME.RESOURCE_CATEGORY) = '') AND
             (Trim(CUR_PRODUCTIONTIME.RESOURCE) = '')) then
            needToCreateDefaultLine := false;

{          if ( getValues(CUR_PRODUCTIONTIMESLEVEL,
                         MQMProductionColumnValues,
                         Items,
                         propertyList,
                         ColorTypeList, ColorTypeUNIQUEIDList,
                         additionalDataList, ConcatinatedValue)
           ) then
        begin }
          setupTime := 0;
          executionTime := 0;

          index := searchInList(CUR_PROCESS.OperAttributes_List, 5, CUR_PRODUCTIONTIME.CODE,
                        0, CUR_PROCESS.OperAttributes_List.Count - 1);
          if index <> -1 then
             CUR_OPERATTRIBUTE := CUR_PROCESS.OperAttributes_List.Items[Index];
          getTimeValue(setupTime, executionTime, 1, CUR_OPERATTRIBUTE,
                       routingStepTimeTypeList, MQMProductionColumnValues, operationList, operationCode, Items, '', '', false);
          getTimeValue(setupTime, executionTime, 2, CUR_OPERATTRIBUTE,
                       routingStepTimeTypeList, MQMProductionColumnValues, operationList, operationCode, Items, '', '', false);
          getTimeValue(setupTime, executionTime, 3, CUR_OPERATTRIBUTE,
                       routingStepTimeTypeList, MQMProductionColumnValues, operationList, operationCode, Items, '', '', false);
          getTimeValue(setupTime, executionTime, 4, CUR_OPERATTRIBUTE,
                       routingStepTimeTypeList, MQMProductionColumnValues, operationList, operationCode, Items, '', '', false);
          getTimeValue(setupTime, executionTime, 5, CUR_OPERATTRIBUTE,
                       routingStepTimeTypeList, MQMProductionColumnValues, operationList, operationCode, Items, '', '', false);

          New(NEW_PROD_STEP_TIME);
          NEW_PROD_STEP_TIME.ST_PREQ_NO := setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COMPANYCODE', PD_COMPANYCODE), 3) +
                                           setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COUNTERCODE', PD_COUNTERCODE), 8) +
                                           getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_CODE', PD_CODE);
          NEW_PROD_STEP_TIME.ST_PSTEP_ID := StrToInt(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_STEPNUMBER', PDS_STEPNUMBER));
          NEW_PROD_STEP_TIME.ST_WKCNTER := workCenterCode;
          NEW_PROD_STEP_TIME.ST_WKCT_PROC := operationCode;
          NEW_PROD_STEP_TIME.ST_RES_CATEGORY := CUR_PRODUCTIONTIME.RESOURCE_CATEGORY;//resourceCategory; avi
          NEW_PROD_STEP_TIME.ST_RSC_CODE := CUR_PRODUCTIONTIME.RESOURCE;//resource; avi
          NEW_PROD_STEP_TIME.ST_SETUP_TIME_Mechin_Code := '';
          if CUR_PRODUCTIONTIME.SETUP_TIME_MULTIPLIER <> '' then  // avi
            setupTime := setupTime * getDoubleFromStr(CUR_PRODUCTIONTIME.SETUP_TIME_MULTIPLIER);
          NEW_PROD_STEP_TIME.ST_SETUP_TIME_JOB := setupTime;
          if CUR_PRODUCTIONTIME.OPERATION_TIME_MULTIPLIER <> '' then  // avi
            executionTime := executionTime * getDoubleFromStr(CUR_PRODUCTIONTIME.OPERATION_TIME_MULTIPLIER);
          NEW_PROD_STEP_TIME.ST_EXC_TIME_INIT_QTY := executionTime;
          if (NEW_PROD_STEP_TIME.ST_EXC_TIME_INIT_QTY > 0) and (NEW_PROD_STEP_TIME.ST_EXC_TIME_INIT_QTY < 1/60) then
             NEW_PROD_STEP_TIME.ST_EXC_TIME_INIT_QTY := 0.017;

          NEW_PROD_STEP_TIME.ST_timeTypeCode := timeTypeCode;

          PREQ_NO := NEW_PROD_STEP_TIME.ST_PREQ_NO;
          if CheckMerge(PREQ_NO, setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COUNTERCODE', PD_COUNTERCODE), 8), productionDemandCounters) then
          begin
            NEW_PROD_STEP_TIME.ST_FAMILYCODE := PREQ_NO;
            m_NeedToMakeMerge := true
          end;
          NEW_PROD_STEP_TIME.ST_TimeArriveFromNowStep := false;
          if (NEW_PROD_STEP_TIME.ST_timeTypeCode = 'B') OR (NEW_PROD_STEP_TIME.ST_timeTypeCode = 'P') then
          begin
            NEW_PROD_STEP_TIME.ST_BatchTimeType := CUR_PROCESS.WP_BATCHSTANDARDTIME;
            NEW_PROD_STEP_TIME.ST_ProductionOrderCode := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_PRODUCTIONORDERCODE', PDS_PRODUCTIONORDERCODE);
            NEW_PROD_STEP_TIME.ST_GroupStepNumber := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_GROUPSTEPNUMBER', PDS_GROUPSTEPNUMBER);
            NEW_PROD_STEP_TIME.ST_CalcTime2 := StrToFloat(getNumericValueOf(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_CALCULATEDTIME2', PDS_CALCULATEDTIME2)));
            NEW_PROD_STEP_TIME.ST_CalcTime3 := StrToFloat(getNumericValueOf(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_CALCULATEDTIME3', PDS_CALCULATEDTIME3)));
            NEW_PROD_STEP_TIME.ST_INITIALBASEPRIMARYQUANTITY := StrToFloat(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_INITIALBASEPRIMARYQUANTITY', PDS_INITIALBASEPRIMARYQUANTITY));
            if CUR_PRODUCTIONTIMESLEVEL <> nil then
              NEW_PROD_STEP_TIME.ST_BatchTimeType := CUR_PRODUCTIONTIMESLEVEL.HANDLE_TIMES_BY;
            NEW_PROD_STEP_TIME.ST_multiplierExecution := 0;
            NEW_PROD_STEP_TIME.ST_multiplierSetUp := 0;
          end;

          read_prod_step_time_list.Add(NEW_PROD_STEP_TIME);

        end;
      end;
    end

    else if (CUR_PRODUCTIONTIMESLEVEL.HANDLE_TIMES_BY = '4') or
      (CUR_PRODUCTIONTIMESLEVEL.HANDLE_TIMES_BY = '5') then //Take attribue code fromcolumns
    begin

      if (CUR_PRODUCTIONTIMESLEVEL.HANDLE_TIMES_BY = '5') then
        Eficiency100Percent := true
      else
        Eficiency100Percent := false;

      setupTime := 0;
      executionTime := 0;

      AttributeFound  := false;
      WcAttributeCode := '';
      if (CUR_PRODUCTIONTIMESLEVEL.TABLENAME1 <> '') or (CUR_PRODUCTIONTIMESLEVEL.COLUMNNAME1 <> '') then
        WcAttributeCode := Trim(GetAColumnValue(CUR_PRODUCTIONTIMESLEVEL, MQMProductionColumnValues, Items, additionalDataList, 1))
      else
        WcAttributeCode := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_WORKCENTERANDOPERATTRIBUTESCOD', PDS_WORKCENTERANDOPERATTRIBUTESCOD));

      if WcAttributeCode <> '' then
      begin
        OverridenTimeOrQty1 := Trim(GetAColumnValue(CUR_PRODUCTIONTIMESLEVEL, MQMProductionColumnValues, Items, additionalDataList, 2));
        OverridenTimeOrQty2 := Trim(GetAColumnValue(CUR_PRODUCTIONTIMESLEVEL, MQMProductionColumnValues, Items, additionalDataList, 3));
        OverridenTimeOrQty3 := Trim(GetAColumnValue(CUR_PRODUCTIONTIMESLEVEL, MQMProductionColumnValues, Items, additionalDataList, 4));
        OverridenTimeOrQty4 := Trim(GetAColumnValue(CUR_PRODUCTIONTIMESLEVEL, MQMProductionColumnValues, Items, additionalDataList, 5));
        OverridenTimeOrQty5 := Trim(GetAColumnValue(CUR_PRODUCTIONTIMESLEVEL, MQMProductionColumnValues, Items, additionalDataList, 6));
        StepRepetition      := Trim(GetAColumnValue(CUR_PRODUCTIONTIMESLEVEL, MQMProductionColumnValues, Items, additionalDataList, 7));

        for J := 0 to CUR_PROCESS.OperAttributes_List.Count - 1 do
        begin
          CUR_OPERATTRIBUTE := CUR_PROCESS.OperAttributes_List.Items[J];
          if CUR_OPERATTRIBUTE.CODE = WcAttributeCode then
          begin
            AttributeFound := true;
            break;
          end;
        end;

        if AttributeFound then
        begin
          getTimeValue(setupTime, executionTime, 1, CUR_OPERATTRIBUTE,
                       routingStepTimeTypeList, MQMProductionColumnValues, operationList, operationCode, Items, OverridenTimeOrQty1, '', Eficiency100Percent);
          getTimeValue(setupTime, executionTime, 2, CUR_OPERATTRIBUTE,
                       routingStepTimeTypeList, MQMProductionColumnValues, operationList, operationCode, Items, OverridenTimeOrQty2, '', Eficiency100Percent);
          getTimeValue(setupTime, executionTime, 3, CUR_OPERATTRIBUTE,
                       routingStepTimeTypeList, MQMProductionColumnValues, operationList, operationCode, Items, OverridenTimeOrQty3, '', Eficiency100Percent);
          getTimeValue(setupTime, executionTime, 4, CUR_OPERATTRIBUTE,
                       routingStepTimeTypeList, MQMProductionColumnValues, operationList, operationCode, Items, OverridenTimeOrQty4, '', Eficiency100Percent);
          getTimeValue(setupTime, executionTime, 5, CUR_OPERATTRIBUTE,
                       routingStepTimeTypeList, MQMProductionColumnValues, operationList, operationCode, Items, OverridenTimeOrQty5, '', Eficiency100Percent);

          New(NEW_PROD_STEP_TIME);
          NEW_PROD_STEP_TIME.ST_PREQ_NO := setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COMPANYCODE', PD_COMPANYCODE), 3) +
                                           setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COUNTERCODE', PD_COUNTERCODE), 8) +
                                           getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_CODE', PD_CODE);
          NEW_PROD_STEP_TIME.ST_PSTEP_ID := StrToInt(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_STEPNUMBER', PDS_STEPNUMBER));
          NEW_PROD_STEP_TIME.ST_WKCNTER := workCenterCode;
          NEW_PROD_STEP_TIME.ST_WKCT_PROC := operationCode;
//          NEW_PROD_STEP_TIME.ST_RES_CATEGORY := resourceCategory;
//          NEW_PROD_STEP_TIME.ST_RSC_CODE := resource;

          NEW_PROD_STEP_TIME.ST_RES_CATEGORY := CUR_PRODUCTIONTIME.RESOURCE_CATEGORY;//resourceCategory; avi
          NEW_PROD_STEP_TIME.ST_RSC_CODE := CUR_PRODUCTIONTIME.RESOURCE;//resource; avi

          NEW_PROD_STEP_TIME.ST_SETUP_TIME_Mechin_Code := '';
          NEW_PROD_STEP_TIME.ST_SETUP_TIME_JOB := setupTime;
          NEW_PROD_STEP_TIME.ST_EXC_TIME_INIT_QTY := executionTime;
          if (NEW_PROD_STEP_TIME.ST_EXC_TIME_INIT_QTY > 0) and (NEW_PROD_STEP_TIME.ST_EXC_TIME_INIT_QTY < 1/60) then
             NEW_PROD_STEP_TIME.ST_EXC_TIME_INIT_QTY := 0.017;

          NEW_PROD_STEP_TIME.ST_timeTypeCode := timeTypeCode;

          PREQ_NO := NEW_PROD_STEP_TIME.ST_PREQ_NO;
          if CheckMerge(PREQ_NO, setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COUNTERCODE', PD_COUNTERCODE), 8), productionDemandCounters) then
          begin
            NEW_PROD_STEP_TIME.ST_FAMILYCODE := PREQ_NO;
            m_NeedToMakeMerge := true
          end;
          NEW_PROD_STEP_TIME.ST_TimeArriveFromNowStep := false;
          if (NEW_PROD_STEP_TIME.ST_timeTypeCode = 'B') OR (NEW_PROD_STEP_TIME.ST_timeTypeCode = 'P') then
          begin
            NEW_PROD_STEP_TIME.ST_BatchTimeType := CUR_PROCESS.WP_BATCHSTANDARDTIME;
            NEW_PROD_STEP_TIME.ST_ProductionOrderCode := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_PRODUCTIONORDERCODE', PDS_PRODUCTIONORDERCODE);
            NEW_PROD_STEP_TIME.ST_GroupStepNumber := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_GROUPSTEPNUMBER', PDS_GROUPSTEPNUMBER);
            NEW_PROD_STEP_TIME.ST_CalcTime2 := StrToFloat(getNumericValueOf(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_CALCULATEDTIME2', PDS_CALCULATEDTIME2)));
            NEW_PROD_STEP_TIME.ST_CalcTime3 := StrToFloat(getNumericValueOf(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_CALCULATEDTIME3', PDS_CALCULATEDTIME3)));
            NEW_PROD_STEP_TIME.ST_INITIALBASEPRIMARYQUANTITY := StrToFloat(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_INITIALBASEPRIMARYQUANTITY', PDS_INITIALBASEPRIMARYQUANTITY));
            if CUR_PRODUCTIONTIMESLEVEL <> nil then
              NEW_PROD_STEP_TIME.ST_BatchTimeType := CUR_PRODUCTIONTIMESLEVEL.HANDLE_TIMES_BY;
            NEW_PROD_STEP_TIME.ST_multiplierExecution := 0;
            NEW_PROD_STEP_TIME.ST_multiplierSetUp := 0;
          end;

          read_prod_step_time_list.Add(NEW_PROD_STEP_TIME);
          needToCreateDefaultLine := false;
        end;
      end;

    end;

  end;

  result := true;

  if needToCreateDefaultLine then
    result := false;

  //result := false;
end;


function UpdateBatchStepTime(PREQ_NO : string; STEP_ID : string; var SETUP_TIME : string; var EXC_TIME_QTY : string) : boolean;
var
  J : Integer;
  PRODREQ_NO : string;
  OrderStepStruct : PTProductionOrderStepStruct;
begin
  Result := false;

  for J := 0 to ProductionOrderStepStructList.Count - 1 do
  begin
    OrderStepStruct := PTProductionOrderStepStruct(ProductionOrderStepStructList[J]);

    PRODREQ_NO := setStringLengthTo(IniAppGlobals.CompanyCode , 3) +
               setStringLengthTo(OrderStepStruct.DemandCounterCode, 8) + OrderStepStruct.DemandCode;

    if (PRODREQ_NO = PREQ_NO) and
       (OrderStepStruct.StepNumber = STEP_ID) then
    begin
      SETUP_TIME := FloatToStr(OrderStepStruct.TotalSetUp);
      EXC_TIME_QTY := FloatToStr(OrderStepStruct.TotalExecution);
      Result := true;
      break
    end;
  end;

end;

//----------------------------------------------------------------------------//

function checkWhetherNeedToMerge(base: TStringList; current: TStringList;
                                 endPosition: Integer): boolean;
var
  flag: Boolean;
  i: Integer;
begin
  if endPosition > 0 then
  begin
    flag := true;
    i := 0;
    while ((i < base.Count - 1) and flag) do
    begin
      if i = 0 then
      begin
        if ( copy(base.Strings[0], 1, endPosition) <> copy(current.Strings[0], 1, endPosition) ) then
          flag := false;
      end
      else
        if ( base.Strings[i] <> current.Strings[i] ) then
          flag := false;

      inc(i);
    end;

    result := flag;
  end
  else
    result := false;
end;

//----------------------------------------------------------------------------//

procedure addAlternativesOfMaterial(read_material_list: TList; alternativeWarehouseList: TList; ProjectDode : string);
var
  CUR_MATERIAL: PTMQMMT;
  NEW_MATERIAL: PTMQMMT;

  CUR_ALT_WAREHOUSE_WKC: PALT_WAREHOUSE_WKCS;
  CUR_ALT_WAREHOUSE_WKC_GROUP: PALT_WAREHOUSE_WKC_GROUPS;
  CUR_ALT_WAREHOUSE_WKC_GROUP_ITEM_TYPE: PALT_WAREHOUSE_WKC_GROUP_ITEM_TYPES;
  CUR_ALT_WAREHOUSE: PALT_WAREHOUSES;

  index: integer;
begin
  CUR_MATERIAL := PTMQMMT(read_material_list.Items[read_material_list.Count - 1]);

  if (alternativeWarehouseList.Count > 0) then
  begin

    index := searchInList(alternativeWarehouseList, 37, Trim(CUR_MATERIAL.MT_WKCTR_CODE), 0, alternativeWarehouseList.Count - 1);

    if index <> -1 then
    begin
      CUR_ALT_WAREHOUSE_WKC :=  alternativeWarehouseList.Items[index];

      index := searchInList(CUR_ALT_WAREHOUSE_WKC.groupCodeList, 38, Trim(CUR_MATERIAL.MT_NET_GROUP_CODE), 0,
                            CUR_ALT_WAREHOUSE_WKC.groupCodeList.Count - 1);

      if index <> -1 then
      begin
        CUR_ALT_WAREHOUSE_WKC_GROUP :=  CUR_ALT_WAREHOUSE_WKC.groupCodeList.Items[index];

        index := searchInList(CUR_ALT_WAREHOUSE_WKC_GROUP.itemTypeList, 39, Trim(CUR_MATERIAL.MT_PROD_TYPE), 0,
                              CUR_ALT_WAREHOUSE_WKC_GROUP.itemTypeList.Count - 1);

        if index <> -1 then
        begin
          CUR_ALT_WAREHOUSE_WKC_GROUP_ITEM_TYPE :=  CUR_ALT_WAREHOUSE_WKC_GROUP.itemTypeList.Items[index];

          for index := 0 to CUR_ALT_WAREHOUSE_WKC_GROUP_ITEM_TYPE.alternativeList.Count - 1 do
          begin
            CUR_ALT_WAREHOUSE := CUR_ALT_WAREHOUSE_WKC_GROUP_ITEM_TYPE.alternativeList.Items[index];

            if CUR_ALT_WAREHOUSE.ALT_NET_GROUP <> '' then
            begin
              New(NEW_MATERIAL);
              NEW_MATERIAL.MT_PROD_REQ_Nr := CUR_MATERIAL.MT_PROD_REQ_Nr;
              NEW_MATERIAL.MT_PSTEP_ID := CUR_MATERIAL.MT_PSTEP_ID;
              NEW_MATERIAL.MT_ORG_STEP := CUR_MATERIAL.MT_ORG_STEP;
              NEW_MATERIAL.MT_WKCTR_CODE := CUR_ALT_WAREHOUSE.ALT_WORKCENTER;
              NEW_MATERIAL.MT_RES_CAT_CODE := CUR_MATERIAL.MT_RES_CAT_CODE;
              NEW_MATERIAL.MT_RES_CODE := CUR_MATERIAL.MT_RES_CODE;
              NEW_MATERIAL.MT_MACHIN_SETUP_CODE := CUR_MATERIAL.MT_MACHIN_SETUP_CODE;
              NEW_MATERIAL.MT_ALTERNATIVE_CODE := CUR_MATERIAL.MT_ALTERNATIVE_CODE;
              NEW_MATERIAL.MT_PROD_TYPE := CUR_MATERIAL.MT_PROD_TYPE;
              NEW_MATERIAL.MT_PROD_CODE := CUR_MATERIAL.MT_PROD_CODE;
              NEW_MATERIAL.MT_NET_GROUP_CODE := ' ' + CUR_ALT_WAREHOUSE.ALT_NET_GROUP + ProjectDode;
              NEW_MATERIAL.MT_ISSUE_CODE := CUR_MATERIAL.MT_ISSUE_CODE;
              NEW_MATERIAL.MT_SEQ_ISSUED := CUR_MATERIAL.MT_SEQ_ISSUED;
              NEW_MATERIAL.MT_MAT_BALACE := CUR_MATERIAL.MT_MAT_BALACE;
              NEW_MATERIAL.MT_QUANTITY_ALLOC := CUR_MATERIAL.MT_QUANTITY_ALLOC;
              NEW_MATERIAL.MT_HIGH_DATE_ALLOC := CUR_MATERIAL.MT_HIGH_DATE_ALLOC;
              NEW_MATERIAL.MT_SEARCH_MAT_BY_ALLOC := CUR_MATERIAL.MT_SEARCH_MAT_BY_ALLOC;
              NEW_MATERIAL.MT_SETTLED := CUR_MATERIAL.MT_SETTLED;
              NEW_MATERIAL.MT_QUANTITY_ISSUE := CUR_MATERIAL.MT_QUANTITY_ISSUE;
              NEW_MATERIAL.MT_REQ_QUANTITY := CUR_MATERIAL.MT_REQ_QUANTITY;

          //    NEW_MATERIAL.PRODUCTIONDEMANDTEMPLATECODE := CUR_MATERIAL.PRODUCTIONDEMANDTEMPLATECODE;
          //    NEW_MATERIAL.PRODUCTIONDEMANDCOUNTERCODE := CUR_MATERIAL.PRODUCTIONDEMANDCOUNTERCODE;

              read_material_list.Add(NEW_MATERIAL);
            end;
          end;
        end;
      end;
    end;
  end;
end;
//----------------------------------------------------------------------------//

function getAllowSplitValueFromWkc_Proc(CUR_WORKCENTER: PWORKCENTERS; CUR_PROCESS: PPROCESSES;
                                        additionalDataList: TList;
                                        Items : PTItems;
                                        MQMProductionColumnValues: PMQMProductionColumnValues; itemTypeTemplates: TList): String;
var
  resultStr: String;
  P_ABSUNIQUEID, FIKD_ABSUNIQUEID : string;
  PRODUCTIONORDERCODE, itemType, ProductionDemandTemplate : string;
  CUR_ITEMTYPEPRODUCTIONDEMANDTEMPLATE: PITEMTYPEPRODUCTIONDEMANDTEMPLATES;
begin
  resultStr := '';

  if Trim(CUR_PROCESS.WP_ADFORALLOWEDSPLIT) <> '' then
  begin
    if assigned(Items) then
    begin
      P_ABSUNIQUEID    := Items.ABSUNIQUEID_P;
      FIKD_ABSUNIQUEID := Items.ABSUNIQUEID;
    end;

    resultStr := getAdditionalDataValue('',
                                     'ProductionDemand AD',
                                     Trim(CUR_PROCESS.WP_ADFORALLOWEDSPLIT),
                                     additionalDataList,
                                     P_ABSUNIQUEID,
                                     FIKD_ABSUNIQUEID,
                                   //  getValueOfTheProductionColumn(MQMProductionColumnValues, 'P_ABSUNIQUEID'),
                                   //  getValueOfTheProductionColumn(MQMProductionColumnValues, 'FIKD_ABSUNIQUEID'),
                                     getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ABSUNIQUEID', PD_ABSUNIQUEID),
                                     getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_ABSUNIQUEID', PDS_ABSUNIQUEID));

  end
  else
    resultStr := Trim(CUR_PROCESS.WP_DEFAULTFORALLOWEDSPLIT);

  if (Length(Trim(resultStr)) > 1) then
     resultStr := '0';

  if (Trim(resultStr) <> '') then
    result := Trim(resultStr)
  else
    result := '1';

  if result <> '0' then
  begin
    PRODUCTIONORDERCODE := getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_PRODUCTIONORDERCODE', PDS_PRODUCTIONORDERCODE);
    if trim(PRODUCTIONORDERCODE) <> '' then
    begin
      itemType := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_ITEMTYPEAFICODE', PDS_ITEMTYPEAFICODE));
      ProductionDemandTemplate := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_TEMPLATECODE', PD_TEMPLATECODE));

      CUR_ITEMTYPEPRODUCTIONDEMANDTEMPLATE := setItemTypeTemplate(itemTypeTemplates,
                        getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ITEMTYPEAFICODE', PD_ITEMTYPEAFICODE),
                        ProductionDemandTemplate,
                        Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_WORKCENTERCODE', PDS_WORKCENTERCODE)),
                        Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_OPERATIONCODE', PDS_OPERATIONCODE)));

      if (CUR_ITEMTYPEPRODUCTIONDEMANDTEMPLATE <> nil) and (CUR_ITEMTYPEPRODUCTIONDEMANDTEMPLATE.WORKCENTERFORSPLIT <> '') and
         (CUR_ITEMTYPEPRODUCTIONDEMANDTEMPLATE.OPERATIONFORSPLIT <> '') and (CUR_ITEMTYPEPRODUCTIONDEMANDTEMPLATE.HOSTSPLITCONFIRMLEVEL <> '') then
      begin
        result := '0';
      end;
    end;

  end;


end;
//----------------------------------------------------------------------------//

function getSplitFamilyValueFromWkc_Proc(CUR_WORKCENTER: PWORKCENTERS; CUR_PROCESS: PPROCESSES;
                                         additionalDataList: TList;
                                         Items : PTItems;
                                         MQMProductionColumnValues: PMQMProductionColumnValues): String;
var
  resultStr: String;
  P_ABSUNIQUEID , FIKD_ABSUNIQUEID : string;
begin
  resultStr := '';

  if Trim(CUR_PROCESS.WP_ADFORSPLITFAMILYCODE) <> '' then
  begin

    if assigned(Items) then
    begin
      P_ABSUNIQUEID    := Items.ABSUNIQUEID_P;
      FIKD_ABSUNIQUEID := Items.ABSUNIQUEID;
    end;

    resultStr := getAdditionalDataValue('',
                                     'ProductionDemand AD',
                                     Trim(CUR_PROCESS.WP_ADFORSPLITFAMILYCODE),
                                     additionalDataList,
                                     P_ABSUNIQUEID,
                                     FIKD_ABSUNIQUEID,
                                    // getValueOfTheProductionColumn(MQMProductionColumnValues, 'P_ABSUNIQUEID'),
                                    // getValueOfTheProductionColumn(MQMProductionColumnValues, 'FIKD_ABSUNIQUEID'),
                                     getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ABSUNIQUEID', PD_ABSUNIQUEID),
                                     getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_ABSUNIQUEID', PDS_ABSUNIQUEID));
  end;

  if (Trim(resultStr) <> '') then
    result := Trim(resultStr)
  else
    result := '1';
end;
//----------------------------------------------------------------------------//

procedure insertIntoPROD_REQCONN_List_From_Demand(MQMProductionColumnValues: PMQMProductionColumnValues;
                                                  read_prod_reqConn_list: TList;
                                                  alreadyAddedPROD_REQCONN: TStringList;
                                                  additionalDataWithRelationList: TList;
                                                  Items : PTItems;
                                                  productionDemandCounters : TList;
                                                  additionalDataList: TList);
var
  fromProdReq: String;
  toProdReq: String;
begin
  fromProdReq := setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_RESERVATIONORDERCOUNTERCODE', PD_RESERVATIONORDERCOUNTERCODE), 8) +
                 getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_RESERVATIONORDERCODE', PD_RESERVATIONORDERCODE);

  if (trim(fromProdReq) <> '') then
  begin
    fromProdReq := setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COMPANYCODE', PD_COMPANYCODE), 3) +
                   fromProdReq;

    toProdReq := setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COMPANYCODE', PD_COMPANYCODE), 3) +
                 setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COUNTERCODE', PD_COUNTERCODE), 8) +
                 getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_CODE', PD_CODE);

    if ( alreadyAddedPROD_REQCONN.IndexOf( fromProdReq + toProdReq ) = -1 ) then
    begin
      insertIntoPROD_REQCONN_List(fromProdReq,
                                  toProdReq,
                                  getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ITEMTYPEAFICODE', PD_ITEMTYPEAFICODE),
                                  getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COUNTERCODE', PD_COUNTERCODE),
                                  getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_TEMPLATECODE', PD_TEMPLATECODE),
                                  productionDemandCounters,
                                  read_prod_reqConn_list);

      alreadyAddedPROD_REQCONN.Add(fromProdReq + toProdReq);
    end;
  end;

  insertIntoPROD_REQCONN_List_From_Demand_AD(MQMProductionColumnValues,
                                             read_prod_reqConn_list,
                                             alreadyAddedPROD_REQCONN,
                                             additionalDataWithRelationList,
                                             Items,
                                             productionDemandCounters,
                                             additionalDataList);

end;
//----------------------------------------------------------------------------//

procedure insertIntoPROD_REQCONN_List_From_Demand_AD(MQMProductionColumnValues: PMQMProductionColumnValues;
                                                     read_prod_reqConn_list: TList;
                                                     alreadyAddedPROD_REQCONN: TStringList;
                                                     additionalDataWithRelationList: TList;
                                                     Items : PTItems;
                                                     productionDemandCounters : TList;
                                                     additionalDataList: TList
                                                    );
var
  fromProdReq: String;
  toProdReq: String;
  i: Integer;
  j: Integer;
  CUR_ADDITIONALDATA_WITH_RELATION: PADDITIONALDATA_WITH_RELATIONS;

  counterCodeColumnName: String;
  codeColumnName: String;
  FIKD_ABSUNIQUEID : string;
  P_ABSUNIQUEID    : string;
begin

  if assigned(Items) then
  begin
    FIKD_ABSUNIQUEID := items.ABSUNIQUEID;
    P_ABSUNIQUEID    := items.ABSUNIQUEID_P;
  end;

  for i := 0 to additionalDataWithRelationList.Count - 1 do
  begin
    CUR_ADDITIONALDATA_WITH_RELATION := additionalDataWithRelationList.Items[i];

    if (CUR_ADDITIONALDATA_WITH_RELATION.RELATEDCLASSENTITYNAME = 'ProductionReservation') then
    begin
      counterCodeColumnName := 'OrderCounterCode';
      codeColumnName := 'OrderCode';
    end
    else
    begin
      counterCodeColumnName := 'DemandCounterCode';
      codeColumnName := 'DemandCode';
    end;

    for j := 0 to CUR_ADDITIONALDATA_WITH_RELATION.columnNameStringList.Count - 1 do
    begin
      fromProdReq := setStringLengthTo(getAdditionalDataValue('',
                                                              'ProductionDemand AD',
                                                              CUR_ADDITIONALDATA_WITH_RELATION.columnNameStringList.Strings[j] +
                                                              counterCodeColumnName,
                                                              additionalDataList,
                                                              P_ABSUNIQUEID,
                                                              FIKD_ABSUNIQUEID,
                                                            //  getValueOfTheProductionColumn(MQMProductionColumnValues, 'P_ABSUNIQUEID'),
                                                            //  getValueOfTheProductionColumn(MQMProductionColumnValues, 'FIKD_ABSUNIQUEID'),
                                                              getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ABSUNIQUEID', PD_ABSUNIQUEID),
                                                              getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_ABSUNIQUEID', PDS_ABSUNIQUEID)), 8);

      if (fromProdReq <> '') then
      begin
        fromProdReq := fromProdReq + getAdditionalDataValue('',
                                              'ProductionDemand AD',
                                              CUR_ADDITIONALDATA_WITH_RELATION.columnNameStringList.Strings[j] +
                                              codeColumnName,
                                              additionalDataList,
                                              P_ABSUNIQUEID,
                                              FIKD_ABSUNIQUEID,
                                            //  getValueOfTheProductionColumn(MQMProductionColumnValues, 'P_ABSUNIQUEID'),
                                            //  getValueOfTheProductionColumn(MQMProductionColumnValues, 'FIKD_ABSUNIQUEID'),
                                              getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ABSUNIQUEID', PD_ABSUNIQUEID),
                                              getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_ABSUNIQUEID', PDS_ABSUNIQUEID));

        fromProdReq := setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COMPANYCODE', PD_COMPANYCODE), 3) +
                       fromProdReq;

        toProdReq := setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COMPANYCODE', PD_COMPANYCODE), 3) +
                     setStringLengthTo(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COUNTERCODE', PD_COUNTERCODE), 8) +
                     getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_CODE', PD_CODE);

        if ( alreadyAddedPROD_REQCONN.IndexOf( fromProdReq + toProdReq ) <> -1 ) then
        begin
          insertIntoPROD_REQCONN_List(fromProdReq,
                                      toProdReq,
                                      getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_ITEMTYPEAFICODE', PD_ITEMTYPEAFICODE),
                                      getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_COUNTERCODE', PD_COUNTERCODE),
                                      getValueOfTheProductionColumn(MQMProductionColumnValues, 'PD_TEMPLATECODE', PD_TEMPLATECODE),
                                      productionDemandCounters,
                                      read_prod_reqConn_list);

           alreadyAddedPROD_REQCONN.Add(fromProdReq + toProdReq);
        end;
      end;
    end;
  end;
end;
//----------------------------------------------------------------------------//

function getNetGroupCode(defaultValue: String; isForProducedArticle: boolean;
                         itemType: String; logicalWarehouse: String;
                         itemTypeLogicalWarehouseList: TList;
                         MQMProductionColumnValues: PMQMProductionColumnValues;
                         Items : PTItems;
                         additionalDataList: TList): String;
var
  index: integer;
  CUR_ITEMTYPELOGICALWAREHOUSE_ITEMTYPE: PITEMTYPELOGICALWAREHOUSE_ITEMTYPES;
  CUR_ITEMTYPELOGICALWAREHOUSE: PITEMTYPELOGICALWAREHOUSES;
  value, DEMANDCOLUMNNAME, RESERVATIONCOLUMNNAME: String;
  DataType : Integer;
begin
  result := defaultValue;
  DataType := 0;

  index := searchInList(itemTypeLogicalWarehouseList, 40, Trim(itemType),
                        0, itemTypeLogicalWarehouseList.Count - 1);

  if (index <> -1) then
  begin
    CUR_ITEMTYPELOGICALWAREHOUSE_ITEMTYPE := itemTypeLogicalWarehouseList.Items[index];

    index := searchInList(CUR_ITEMTYPELOGICALWAREHOUSE_ITEMTYPE.logicalWarehouseList, 41,
                          Trim(logicalWarehouse), 0,
                          CUR_ITEMTYPELOGICALWAREHOUSE_ITEMTYPE.logicalWarehouseList.Count - 1);

    if (index <> -1) then
    begin
      CUR_ITEMTYPELOGICALWAREHOUSE := CUR_ITEMTYPELOGICALWAREHOUSE_ITEMTYPE.logicalWarehouseList.Items[index];
      DEMANDCOLUMNNAME := '';
      RESERVATIONCOLUMNNAME := '';
      if (isForProducedArticle)  then
      begin
        DEMANDCOLUMNNAME := CUR_ITEMTYPELOGICALWAREHOUSE.DEMANDCOLUMNNAME;
        if CUR_ITEMTYPELOGICALWAREHOUSE.Demand_RELATED_COLUMN <> '' then
           DEMANDCOLUMNNAME := CUR_ITEMTYPELOGICALWAREHOUSE.DEMANDCOLUMNNAME +
                                                            CUR_ITEMTYPELOGICALWAREHOUSE.Demand_RELATED_COLUMN;
        value := getValueFromTable(MQMProductionColumnValues,
                                   CUR_ITEMTYPELOGICALWAREHOUSE.DEMANDTABLENAME,
                                   DEMANDCOLUMNNAME,
                                   Items,
                                   additionalDataList,DataType);
        if Trim(value) <> '' then
          result := copy(value, 1, 16);
      end
      else
      begin
        RESERVATIONCOLUMNNAME := CUR_ITEMTYPELOGICALWAREHOUSE.RESERVATIONCOLUMNNAME;
        if CUR_ITEMTYPELOGICALWAREHOUSE.Reservation_RELATED_COLUMN <> '' then
           RESERVATIONCOLUMNNAME := CUR_ITEMTYPELOGICALWAREHOUSE.RESERVATIONCOLUMNNAME +
                                                                 CUR_ITEMTYPELOGICALWAREHOUSE.Reservation_RELATED_COLUMN;

        value := getValueFromTable(MQMProductionColumnValues,
                                   CUR_ITEMTYPELOGICALWAREHOUSE.RESERVATIONTABLENAME,
                                   RESERVATIONCOLUMNNAME,
                                   Items,
                                   additionalDataList,DataType);

        if Trim(value) <> '' then
          result := copy(value, 1, 16);
      end;

      if Trim(value) <> '' then
      begin
        if trim(CUR_ITEMTYPELOGICALWAREHOUSE.NET_GRP_LOT) = '2' then
        begin
          Result := defaultValue + '_' + Result;
          result := copy(Result, 1, 16);
        end;
      end;
    end
  end
end;
//----------------------------------------------------------------------------//

function formatPropertyValueDirect(CUR_PROP: PPROPS; propertyValue: String; CompleteMqmFormat: Boolean; CUR_PROP_RTV_VALUE: PPROP_RTV_VALUES): String;
var
  ValueDateTime : TDateTime;
begin
  Result := '';
  if CUR_PROP = nil then
  begin
    result := copy(propertyValue, 1, 90);
    exit;
  end;

  if (CUR_PROP.PY_TYPE = '1') and ((CUR_PROP_RTV_VALUE.From_Position > 0) and (CUR_PROP_RTV_VALUE.From_Position < 180))
     and (CUR_PROP_RTV_VALUE.Length_From_Pos > 0) then
  begin
    result := copy(propertyValue, CUR_PROP_RTV_VALUE.From_Position, CUR_PROP_RTV_VALUE.Length_From_Pos);
    exit;
  end;

  if (CUR_PROP.PY_TYPE = '1') and CUR_PROP.PY_IS_Date_Prop then
  begin
    if TryStrToDateTime(propertyValue, ValueDateTime) then
    begin
      ValueDateTime := StrToDateTime(propertyValue);
      Result := formatdatetime('YYYYMMDD', ValueDateTime);
    end;
  end
  else if ((CUR_PROP.PY_TYPE = '2') or (CUR_PROP.PY_TYPE = '3')) and CompleteMqmFormat then
    result := toMQMFormat(CUR_PROP.PY_PROP_LEN, CUR_PROP.PY_NUM_OF_DEC, propertyValue)
  else
    result := copy(propertyValue, 1, 90);
end;

//----------------------------------------------------------------------------//

function formatPropertyValue(propertyList: TList; propertyCode: String; propertyValue: String; CompleteMqmFormat : boolean; CUR_PROP_RTV_VALUE: PPROP_RTV_VALUES): String;
var
  index: Integer;
begin
  index := searchInList(propertyList, 42, propertyCode, 0, propertyList.Count - 1);
  if index <> -1 then
    result := formatPropertyValueDirect(PPROPS(propertyList.Items[index]), propertyValue, CompleteMqmFormat, CUR_PROP_RTV_VALUE)
  else
    result := copy(propertyValue, 1, 90);
end;
//----------------------------------------------------------------------------//

function toMQMFormat(PropLen: Integer; PropDecNum: Integer; Value: String): String;
var
  d         : Double;
  Ok        : Boolean;
  i: Integer;
  valStr: String;
begin
  d:= TxtToFloat(Value, Ok); //convert text to double

  for i := 0 to PropDecNum - 1 do
    d := d * 10;

  d := trunc(d);
  valStr := FloatToStr(d);

  while Length(valstr) < 90 do    //while Length(valstr) < 20 do
    valStr := '0' + valStr;

  result := valStr;
end;
//----------------------------------------------------------------------------//

function TxtToFloat ( s: AnsiString; var ok: Boolean ): Double;
var
  f : Integer;
begin
  Result :=0;
  CheckTxt(s,ok);

  if ok then begin
    try
      System.Val(S, Result, f);
      ok := f=0;
    except
      ok := false;
    end;
  end;

  if not ok then Result:=0;
end;
{------------------------------------------------------------------------------}

procedure CheckTxt(var s: AnsiString; var ok: Boolean);
var
  i     : Integer;
  Ziffer: Boolean;
begin
  s:= Trim(s);
  if (s<>'') and (s[1]='.') then s:='0'+s;
  Ziffer := false;
  for i:=1 to Length(s) do begin
    Ziffer := Ziffer or (s[i] in ['0'..'9']);
    if s[i] = ',' then s[i]:='.';

    ok := (not Ziffer and (s[i] in ['+','-',' '])) or
          (Ziffer and (s[i] in ['0'..'9','.']));

    if not ok then Break;

    if (s[1]<>'-') and (s[i]='-') then begin
      s[1]:= '-';
      s[i]:= ' ';
    end;

    if (s[i] = ' ') then s[i]:= '0';
  end;
end;
{------------------------------------------------------------------------------}

procedure getProductNatureAndReservationTimes(articleTypeList: TList; itemTypeCode: String;
                                              var nature: String; var beginTime: String;
                                              var endTime: String; var HoursToDownFromMachin : integer; defaultNature: String;
                                              defaultBeginTime: String; defaultEndTime: String);
var
  index: Integer;
  CUR_ARTICLE_TYPE: PARTICLE_TYPES;
begin
  index := searchInList(articleTypeList, 15, Trim(itemTypeCode), 0,
                        articleTypeList.Count - 1);

  if ( index <> -1 ) then
  begin
    CUR_ARTICLE_TYPE := articleTypeList.Items[index];

    nature := CUR_ARTICLE_TYPE.AT_PRODUCTTYPENATURE;

    if Trim(CUR_ARTICLE_TYPE.AT_RESTIMEBEGINNING) <> '' then
      beginTime := CUR_ARTICLE_TYPE.AT_RESTIMEBEGINNING
    else
      beginTime := defaultBeginTime;

    if Trim(CUR_ARTICLE_TYPE.AT_RESTIMEENDING) <> '' then
      endTime := CUR_ARTICLE_TYPE.AT_RESTIMEENDING
    else
      endTime := defaultEndTime;
    HoursToDownFromMachin := CUR_ARTICLE_TYPE.AT_HoursToDownloadFromMachine;
  end
  else
  begin
    nature := defaultNature;
    beginTime := defaultBeginTime;
    endTime :=  defaultEndTime;
    HoursToDownFromMachin := -1
  end;

end;
{------------------------------------------------------------------------------}

function getBalanceHandledItemTypes(articleTypeList: TList; Include_ADDDATACOLUMNNAME : boolean): String;
var
  CUR_ARTICLE_TYPE: PARTICLE_TYPES;
  i: integer;
  str: String;
begin
  str := '';
  for i := 0 to articleTypeList.Count - 1 do
  begin
    CUR_ARTICLE_TYPE := articleTypeList.Items[i];

    if CUR_ARTICLE_TYPE.AT_BALHANDLEDBYMQM = '1' then
    begin
      if trim(str) <> '' then
        str := str + ', ';

      str := str + QuotedStr(CUR_ARTICLE_TYPE.AT_ART_TYPE);
    end;

    if Include_ADDDATACOLUMNNAME and (Trim(CUR_ARTICLE_TYPE.AT_ADDDATACOLUMNNAME) <> '') then
    begin
      if trim(str) <> '' then
        str := str + ', ';

      str := str + QuotedStr(CUR_ARTICLE_TYPE.AT_ART_TYPE);
    end;

  end;

  result := str;
end;

{------------------------------------------------------------------------------}

function sortHandledProductionOrder(Item1: Pointer; Item2: Pointer): Integer;
var
  firstHANDLED_PRODUCTION_ORDER: PHANDLED_PRODUCTION_ORDERS;
  secondHANDLED_PRODUCTION_ORDER: PHANDLED_PRODUCTION_ORDERS;
  firstList: TStringList;
  secondList: TStringList;
begin
  firstHANDLED_PRODUCTION_ORDER := Item1;
  secondHANDLED_PRODUCTION_ORDER := Item2;

  firstList := TStringList.Create;
  firstList.Add(firstHANDLED_PRODUCTION_ORDER.Code);

  secondList := TStringList.Create;
  secondList.Add(secondHANDLED_PRODUCTION_ORDER.Code);

  Result := compareValuesOfListsToSort(firstList, secondList);

  firstList.Free;
  secondList.Free;
end;

//----------------------------------------------------------------------------//

initialization
  m_ProdCont := nil;

finalization
  if Assigned(m_ProdCont) then
    m_ProdCont.free;

end.
