unit UMTransfer;

interface

uses
  Db,
  Classes,
  UMglobal,
  stdctrls,
  DMsrvPC,
  UMTblDesc,
  gnugettext;

  function LoadFromHost(var DataChange : boolean ; Handl : THandle; var GotAccessToInsertData : boolean) : boolean;
  function SendSchedToHOST : boolean;
  function SendSchedToNOW(var Is_SCHEDULESUPLOAD_emptyMQM : boolean; var Is_SCHEDULESUPLOAD_emptyMCM : boolean; var MQM_OR_MCM_ENVIRONMENT : string): boolean;
  function SendWarpSchedToNOW : boolean;

  function SendArchiveToHOST : boolean;
  function CheckPsInPc : boolean;
  function CheckWarpIn_SCHED : boolean;
  function CheckWarpIn_HOST : boolean;
  function Check_MCM_SCHED : boolean;
  function CheckArcToSend : boolean;
  function CheckProcessAfterUploadToNow : boolean;

implementation

uses
  SysUtils,
  Dialogs,
  UMLoad,
  UOpThread,
  UMSrvLoad,
  UMStoredProc,
  UMSrvConfig,
  UMProdMemory,
  UMASStoredProc,
  Windows,
  UMSave,
  ADODB,
  UMProductionStruct,
  UMUploadToNOW,
  FireDAC.Stan.Error,
  UMProductionStructService,
  UMCommon,
  forms;

type

  TFromHostToSrv = function(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  TUpdateHost    = function(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  TUpLoadNowHost    = function(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery; var Is_SCHEDULESUPLOAD_empty : boolean; var MQM_OR_MCM_ENVIRONMENT : string): boolean;
  TUpLoadTableToNowHost  = function(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  TUpdatePC       = function(tbl: table; srvQry: TMqmQuery; PcQry: TMqmQuery): boolean;
  TUpArchive     = function(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
  TAddProdFilesToMemory = function(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery ; IsHostQry : boolean ; IsInsert : boolean): boolean;

  TOpRecord = record
    act:         boolean;
    IsArchive:   boolean;
    AStoSrvArchiv : TFromHostToSrv;
    UpdAS:       TUpdateHost;
    UpdPC:       TUpdatePC;
    UpArchive:   TUpArchive;
    UpdFromPc:   TUpdatePC;
    AddProdFiles : TAddProdFilesToMemory;
    TableName    : string;
    ActLikeProduction : TFromHostToSrv;
    UpdToNOW: TUpLoadNowHost;
    UpdTableToNOW : TUpLoadTableToNowHost;
  end;

const

  TCOpList: array [table] of TOpRecord = (


     // tbl_cfg_McmTabConfig
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil;
    ),

    //tbl_RESCAL
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil;
    ),
    //tbl_FILTERS
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil;
    ),

    // tbl_FILTERS_COL
    (
     act:          false;
     IsArchive:    false;
     AStoSrvArchiv:  nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

    //tbl_Identifiers
    (
     act:         true;
     IsArchive:   true;
     AStoSrvArchiv: LoadIdentifiers;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil;
    ),

    // tbl_Archive_To_Host
    (
     act:          false;
     IsArchive:    false;
     AStoSrvArchiv:  nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

    // tbl_GeneratorNumber
    (
     act:          false;
     IsArchive:    false;
     AStoSrvArchiv:  nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_AddResource
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv:  nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_AltrntiveWC
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv: LoadAlternativeWC;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // alt_warehouse
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv: LoadaltWarehouse;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_cfg_AppGlobSettings
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv:  nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_cfg_appGlob
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv:  nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

    // tbl_cfg_appIni

    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv:  nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_cfg_appSettings
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv:  nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_cfg_AutoSched
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv:  nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

    // tbl_cfg_AutoSchedWorkCenter
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv:  nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

    // AutoRunDefinition
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv:  nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_arty
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv:  LoadArticleType;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // Material_Tollerance_Types
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv:  Load_Material_Tollerance_Types;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_cfg_bin_showProp
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv:  nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_prop_capRes
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv: nil; // LoadCapacityProp;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_capRes
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv: nil; //LoadCapacityReserv;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   SendCapRes;
     UpdFromPc:   nil;
     AddProdFiles : AddCapRes;
     TableName:   'CapRes';
     ActLikeProduction : nil
    ),

     // tbl_capRes_Host
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

    //tbl_capRes_DynamicPerRes
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_capRes_DynamicPerDate
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

    // tbl_capRes_DynamicPerResDateProp
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_cfg_colorCapToJob
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv:  nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_resCat
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv:  LoadCategory;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_calendar
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv:  LoadCalendar;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

    // tbl_calShiftEffic,
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv:  nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_cfg_planTab_det
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv:  nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_cfg_planTab_master
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv:  nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_cfg_exchg_glob
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv:  nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_cfg_exchg_wkst
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv:  nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

    // tbl_cfg_exchg_SrvLoad

    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv:  nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

    // tbl_cfg_SrvLoad_Log

    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv:  nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_ext_info
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     TableName    : 'Ext_Info';
     ActLikeProduction : LoadExt_Info
    ),

     // tbl_ext_infoHdr
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv: nil; //LoadExt_InfoHeadr;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     TableName    : 'Ext_InfoHeadr';
     ActLikeProduction : LoadExt_InfoHeadr
    ),

     // tbl_ext_connection
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv: nil; // LoadExter_Connection;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : AddProdExternalConn;
     TableName:   'ProdExternalConn';
     ActLikeProduction : nil
    ),

     // tbl_cfg_binFilter
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv:  nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_prod_sched'Force
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv: nil;   //  LoadForcedSched;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_res_sub
    (
     act:         true;
     IsArchive:   true;
     AStoSrvArchiv:  LoadHeadRscSplit;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   SendSubRes;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_cfg_colorStatus
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv:  nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_cfg_colorDateWarn
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv:  nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_cfg_colorMatWarn
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv:  nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_cfg_colorJobToRes
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv:  nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_cfg_colorJobToJob
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv:  nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_prod_reqConnection
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv: nil; //LoadInterConnection;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : AddProdInternalConn;
     TableName:   'ProdInternalConn';
     ActLikeProduction : nil
    ),

     // tbl_ruleOccToOcc
    (
     act:         true;
     IsArchive    :  false;
     AStoSrvArchiv:  LoadOccOccCompatRule;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_GroupByPropertyRules
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv:  LoadGroupByPropertyRule;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_prod_info
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv: nil; //LoadprodInfo;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : AddProdImfo;
     TableName:   'AddProdImfo';
     ActLikeProduction : nil
    ),

     // tbl_wkc_prodLine
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_prop_prod
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv: nil;// LoadProdProp;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : AddProdProperty;
     TableName:   'ProdProperty';
     ActLikeProduction : nil
    ),

     // tbl_prod_req
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv: nil; //LoadprodReq;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : AddProdRq;
     TableName:   'ProdRq';
     ActLikeProduction : nil
    ),

     // tbl_prod_step
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv: nil; //LoadProdReqDetail;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : AddProdRqDetails;
     TableName:   'ProdRqDetails';
     ActLikeProduction : nil
    ),

     // tbl_prod_reqHdr
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv: nil; //LoadProdReqHeadr;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : AddProdRqHeader;
     TableName:   'ProdRqHeader';
     ActLikeProduction : nil
    ),

     // tbl_prod_sched
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv:  nil;
     UpdAS:       SaveProdSched;
     UpdPC:       nil;//SendProdSchedPc;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil;
     UpdToNOW: SendProdSched_MQM_TO_NOW
    ),

     // tbl_prod_sched_mcm
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv:  nil;
     UpdAS:       SaveProdSchedmcm;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil;
     UpdToNOW: SendProdSched_MCM_TO_NOW
    ),

     // tbl_prod_sched_shared_data
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     TableName    : 'DeleteSharedDataRecords';
     ActLikeProduction : DeleteSharedDataRecords;
    ),

     // tbl_prop
    (
     act:         true;
     IsArchive:   false;
     {$ifdef Chaina}
     AStoSrvArchiv:  LoadProperty;
     {$else}
     AStoSrvArchiv:  LoadPropertyOld;
    {$endif}
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

    // tbl_PROP_PROD_PLANNER
    (
     act:         true;
     IsArchive:   true;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   SendPlannerProperties;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

   //  tbl_cfg_Prop_Show_Color
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_cfg_clrRes
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv:  nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

      // tbl_cfg_clrCapRes
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv:  nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_res
    (
     act:         true;
     IsArchive:   true;
     AStoSrvArchiv:  LoadResources;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   SendRes;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_res_apa
    (
     act:         true;
     IsArchive:   false;
//     AStoSrvArchiv:  LoadRscDivision;   //Eran said that this table is not needed
     AStoSrvArchiv:  nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     ActLikeProduction : nil
    ),

     // tbl_Req_Change
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     ActLikeProduction : nil
    ),

     // tbl_CapRsc_Change
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     ActLikeProduction : nil
    ),

     // tbl_ruleResToOcc
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv:  LoadRscOccCompatRul;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_prop_res
    (
     act:         true;
     IsArchive:   true;
     AStoSrvArchiv:  LoadRscProperty;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   SendProp_Res;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_step_batchSize
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv: nil; // LoadStepBatchSize;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : AddProdBatch;
     TableName:   'ProdBatch';
     ActLikeProduction : nil
    ),

     // tbl_step_times
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv: nil;// LoadStepTimes;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : AddProdStepTimes;
     TableName:   'ProdStepTimes';
     ActLikeProduction : nil
    ),

     // tbl_sched_progress
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv: nil; //LoadStpProgress;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;//LoadProgressFromPc;
     AddProdFiles : AddProdProgress;
     TableName:   'ProdProgress';
     ActLikeProduction : nil
    ),

     // tbl_sched_progress_override
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_cfg_binTab_col
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv:  nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

    // btl_customizedDateColumn
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv:  nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

    // btl_customizedDateGap
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv:  nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_unit
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv:  LoadUnit;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil;
    ),

     //  tbl_wkc_group
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv:  LoadwkctrGroup;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_wkc
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv:  Loadwkctr;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_wkc_proc
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv:  LoadWCProc;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_wkst
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv:  Loadwkst;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_wkst_wkc
    (
     act:         true;
     IsArchive:   true;
     AStoSrvArchiv: Loadwkst_wkctrs;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   SendWkst_Wkc;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_wkc_priority
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv:  LoadWorkCntrPrior;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

    // tbl_wkc_cat_capacity
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv:  nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

   //  tbl_cfg_text_display_set_fields
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_cfg_text_display_set_wkc
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

    //  struct_tbl_cfg_Mail_set_List,
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

    (
     act:         false;
     IsArchive:   true;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_wkc_Change
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_rsc_Change
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_Proc
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv: LoadProc;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_Cal
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_Licence
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_Licence2
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_machine_setup_code
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv: LoadMachineSetupCode;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil;
    ),

     // tbl_wkc_dependency
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv: LoadWkcDependency;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

    // tbl_Material
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : AddMaterial;
     TableName    : 'Material';
     ActLikeProduction : nil
    ),

     // tbl_material_sup_detail
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv: LoadMaterialSupDetail;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_material_sup_header
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv: LoadMaterialSupHeader;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil
    ),

     // tbl_produced_article
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv: nil;//LoadProducedArticle;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : AddProducedArticle;
     TableName    : 'ProducedArticle';
     ActLikeProduction : nil
    ),

      // tbl_products
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     TableName    : 'LoadProducts';
     ActLikeProduction : LoadProducts;
    ),

      // tbl_balance_header
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv: nil; //LoadBalanceHeader;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil; //AddBalance_Header;
     TableName    : 'BalanceHeader';
     ActLikeProduction : LoadBalanceHeader;
    ),

   // tbl_balance_detail
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv: nil;//LoadBalanceDetail;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;//AddBalance_Detail;
     TableName    : 'BalanceDetail';
     ActLikeProduction : LoadBalanceDetail;
    ),

       // tbl_download_time
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     TableName : 'LoadDownloadTime';
     ActLikeProduction : LoadDownloadTime;
    ),

    //tbl_Job_Massages
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil;
    ),

    // tbl_LearningCurve

    (
     act:         true;
     IsArchive:   true;
     AStoSrvArchiv: Load_Learning_Curve;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil;
    ),


    // tbl_ItemsStock

    (
     act:         true;
     IsArchive:   true;
     AStoSrvArchiv: LoadItemsStock;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil;
    ),

    // struct_tbl_ItemsStockChanges

    (
     act:         true;
     IsArchive:   true;
     AStoSrvArchiv: LoadItemsStockChanges;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil;
    ),

    // tbl_ItemsStockExceptions

    (
     act:         true;
     IsArchive:   true;
     AStoSrvArchiv: LoadItemsStockExceptions;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil;
    ),

    // tbl_GroupResDefinition
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil;
    ),

    // StockDetails
    (
     act:         true;
     IsArchive:   true;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;  // SendStockDetails;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     TableName    : 'StockDetails';
     ActLikeProduction : LoadStockDetail;
    ),

    // tbl_AutoSeq_ScoreAddition,
    (
     act:         false;
     IsArchive:   true;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil;
    ),

    // tbl_AutoSeqJobToJobDefinitions

    (
     act:         false;
     IsArchive:   true;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil;
    ),

    // tbl_PropAsDate

    (
     act:         false;
     IsArchive:   true;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil;
    ),

    // tbl_PropAsRGB
    (
     act:         false;
     IsArchive:   true;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil;
    ),

    // tbl_aSSIGNEDProp
    (
     act:         false;
     IsArchive:   true;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil;
    ),

    // tbl_Log

    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     TableName    : 'DeleteOldLogRecords';
     ActLikeProduction : DeleteOldLogRecords;
    ),

    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : DeleteOldLogRecords;
    ),

    //tbl_cfg_binMaterialFilter
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil;
    ),

    //tbl_ProductProperties
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     TableName    : 'ProductProperties';
     ActLikeProduction : LoadProductProperties;
    ),

      // tbl_MaterialDetailSchedule
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     TableName    : 'LoadMaterialSchedule';
     ActLikeProduction : LoadMaterialSchedule;
     UpdTableToNOW: SendMaterialSchedule_TO_NOW
    ),

      // tbl_MaterialDetailSchedule_Link
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     TableName    : 'MaterialScheduleLink';
     ActLikeProduction : LoadMaterialScheduleLink;
     UpdTableToNOW: nil
    ),

      // tbl_SCHEDULESDOWNLOADWARPRSV
    (
     act:         true;
     IsArchive:   false;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil;
     UpdTableToNOW: nil
    ),

       // tbl_TotalsView
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil;
    ),

       // tbl_TotalsViewWorkCenters
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil;
    ),

       // tbl_TotalsViewGroupByColumns
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil;
    ),

      // tbl_TotalsViewContent
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil;
    ),

     // tbl_CustomMenu
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil;
    ),

     // tbl_SavedPlanCopyHeader,
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil;
    ),

     // tbl_SavedPlanCopy
    (
     act:         false;
     IsArchive:   false;
     AStoSrvArchiv: nil;
     UpdAS:       nil;
     UpdPC:       nil;
     UpArchive:   nil;
     UpdFromPc:   nil;
     AddProdFiles : nil;
     ActLikeProduction : nil;
    )

  );
//----------------------------------------------------------------------------//

function CheckTblNotToDwnload(tbl : table) : boolean;
begin
  result := false;
  case tbl of
    tbl_wkc_alt : Result := IniAppGlobals.tbl_wkc_alt_NOT_Dwld = '1';
    tbl_arty    : Result := IniAppGlobals.tbl_arty_NOT_Dwld = '1';
    tbl_resCat  : Result := IniAppGlobals.tbl_resCat_NOT_Dwld = '1';
    tbl_res_sub  : Result := IniAppGlobals.tbl_res_sub_NOT_Dwld = '1';
    tbl_ruleOccToOcc  : Result := IniAppGlobals.tbl_ruleOccToOcc_NOT_Dwld = '1';
    tbl_prop  : Result := IniAppGlobals.tbl_prop_NOT_Dwld = '1';
    tbl_res   : Result := IniAppGlobals.tbl_res_NOT_Dwld = '1';
    tbl_ruleResToOcc   : Result := IniAppGlobals.tbl_ruleResToOcc_NOT_Dwld = '1';
    tbl_prop_res   : Result := IniAppGlobals.tbl_prop_res_NOT_Dwld = '1';
    tbl_unit       : Result := IniAppGlobals.tbl_unit_NOT_Dwld = '1';
    tbl_wkc        : Result := IniAppGlobals.tbl_wkc_NOT_Dwld = '1';
    tbl_wkc_proc        : Result := IniAppGlobals.tbl_wkc_proc_NOT_Dwld = '1';
    tbl_wkst        : Result := IniAppGlobals.tbl_wkst_NOT_Dwld = '1';
    tbl_wkst_wkc        : Result := IniAppGlobals.tbl_wkst_wkc_NOT_Dwld = '1';
    tbl_wkc_priority        : Result := IniAppGlobals.tbl_wkc_priority_NOT_Dwld = '1';
    tbl_machine_setup_code        : Result := IniAppGlobals.tbl_machine_setup_code_NOT_Dwld = '1';
    tbl_wkc_dependency        : Result := IniAppGlobals.tbl_wkc_dependency_NOT_Dwld = '1';
    tbl_material_sup_detail        : Result := IniAppGlobals.tbl_material_sup_detail_NOT_Dwld = '1';
    tbl_material_sup_header    : Result := IniAppGlobals.tbl_material_sup_header_NOT_Dwld = '1';
    tbl_wkc_group              : Result := IniAppGlobals.tbl_wkc_group_NOT_Dwld = '1';

 //   tbl_wkc_Category    : Result := IniAppGlobals.tbl_wkc_Category_NOT_Dwld = '1';
//    tbl_CategoryDatesInfo    : Result := IniAppGlobals.tbl_CategoryDatesInfo_NOT_Dwld = '1';
//    tbl_wkc_Penalties    : Result := IniAppGlobals.tbl_wkc_Penalties_NOT_Dwld = '1';
    tbl_LearningCurve    : Result := IniAppGlobals.tbl_LearningCurve_NOT_Dwld = '1';
  end;

end;

//----------------------------------------------------------------------------//
// Timing record used by PrintTimingReport
type
  TTimingRow = record
    Lbl: string;
    S:   double;
    N:   integer;
  end;
  TTimingRows = array of TTimingRow;

//----------------------------------------------------------------------------//

procedure PrintTimingReport(
  FillProdTime, CheckChangeReqTime, TotalDBOpTime: TDateTime);
{ Replaces the old flat LogTimes.Add list.
  Produces 6 grouped+sorted sections with seconds, % of total, ASCII bar. }
const
  SPERDAY = 86400.0;
  LBL_COL = 42;   // label column width (including indent)
  BAR_MAX  = 28;  // max bar length in chars
var
  TotalSecs: double;
  Rows: TTimingRows;
  i: integer;

  function ToS(DT: TDateTime): double;
  begin
    Result := DT * SPERDAY;
  end;

  function MR(const Lbl: string; DT: TDateTime): TTimingRow;
  begin
    Result.Lbl := Lbl;
    Result.S   := ToS(DT);
    Result.N   := 0;
  end;

  function MRC(const Lbl: string; DT: TDateTime; N: integer): TTimingRow;
  begin
    Result.Lbl := Lbl;
    Result.S   := ToS(DT);
    Result.N   := N;
  end;

  procedure SortDescRows(var A: TTimingRows);
  var j, k: integer; T: TTimingRow;
  begin
    for j := 0 to High(A) - 1 do
      for k := 0 to High(A) - j - 1 do
        if A[k].S < A[k + 1].S then
        begin
          T := A[k]; A[k] := A[k + 1]; A[k + 1] := T;
        end;
  end;

  function Bar(S: double): string;
  var N: integer;
  begin
    if TotalSecs <= 0 then begin Result := ''; Exit; end;
    N := Round(S / TotalSecs * BAR_MAX);
    if N > BAR_MAX then N := BAR_MAX;
    if N < 0 then N := 0;
    Result := StringOfChar('|', N);
  end;

  procedure AddLine(const Lbl: string; S: double; Indent: integer; N: integer = 0);
  var
    Pct: double;
    PadLen: integer;
    CountStr: string;
  begin
    if TotalSecs > 0 then Pct := S / TotalSecs * 100 else Pct := 0;
    PadLen := LBL_COL - Indent - Length(Lbl);
    if PadLen < 1 then PadLen := 1;
    if N > 0 then CountStr := '   n=' + IntToStr(N) else CountStr := '';
    IniAppGlobals.LogTimes.Add(
      StringOfChar(' ', Indent) + Lbl + StringOfChar(' ', PadLen) +
      Format('%9.2f s  %5.1f%%  %s', [S, Pct, Bar(S)]) + CountStr);
  end;

  procedure AddLineNoPct(const Lbl: string; S: double; Indent: integer; N: integer = 0);
  var
    PadLen: integer;
    CountStr: string;
  begin
    PadLen := LBL_COL - Indent - Length(Lbl);
    if PadLen < 1 then PadLen := 1;
    if N > 0 then CountStr := '   n=' + IntToStr(N) else CountStr := '';
    IniAppGlobals.LogTimes.Add(
      StringOfChar(' ', Indent) + Lbl + StringOfChar(' ', PadLen) +
      Format('%9.2f s', [S]) + CountStr);
  end;

  procedure AddSep;
  begin
    IniAppGlobals.LogTimes.Add('  ' + StringOfChar('-', 72));
  end;

  procedure AddTitle(const T: string);
  begin
    IniAppGlobals.LogTimes.Add('');
    IniAppGlobals.LogTimes.Add(T);
  end;

  procedure AddGroup(const Title: string; var GRows: TTimingRows);
  var j: integer; Tot: double;
  begin
    AddTitle(Title);
    SortDescRows(GRows);
    Tot := 0;
    for j := 0 to High(GRows) do
    begin
      AddLine(GRows[j].Lbl, GRows[j].S, 2, GRows[j].N);
      Tot := Tot + GRows[j].S;
    end;
    AddSep;
    AddLine('SECTION TOTAL', Tot, 2);
  end;

begin
  TotalSecs := ToS(IniAppGlobals.Time_For_ToTal_Download_Time);

  // Header
  IniAppGlobals.LogTimes.Add(StringOfChar('=', 80));
  IniAppGlobals.LogTimes.Add(
    '  DOWNLOAD TIMING REPORT   ' +
    FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) +
    Format('   Total: %.2f s', [TotalSecs]));
  IniAppGlobals.LogTimes.Add(StringOfChar('=', 80));

  // [1] Top-level phases
  SetLength(Rows, 4);
  Rows[0] := MR('FillProdListsStructure',     FillProdTime);
  Rows[1] := MR('CheckChangeReq',             CheckChangeReqTime);
  Rows[2] := MR('Total_DB_Operations',        TotalDBOpTime);
  Rows[3] := MR('DownloadCompanyHandling',    IniAppGlobals.Time_For_DownloadCompanyHandling);
  AddGroup('[1] TOP-LEVEL PHASES', Rows);

  // [1b] SetQryTblCompar per-table breakdown (Open+Load and Sort for each of 12 local tables)
  AddTitle('[1b] SetQryTblCompar per-table  (inside CheckChangeReq)');
  AddLineNoPct('PR  open/load', ToS(IniAppGlobals.Time_Compar_PR),              4);
  AddLineNoPct('PR  sort',      ToS(IniAppGlobals.Time_ComparSort_PR),          6);
  AddLineNoPct('PR  rows',      0,                                              4, IniAppGlobals.Count_Compar_PR);
  AddLineNoPct('PH  open/load', ToS(IniAppGlobals.Time_Compar_PH),              4);
  AddLineNoPct('PH  sort',      ToS(IniAppGlobals.Time_ComparSort_PH),          6);
  AddLineNoPct('PH  rows',      0,                                              4, IniAppGlobals.Count_Compar_PH);
  AddLineNoPct('PD  open/load', ToS(IniAppGlobals.Time_Compar_PD),              4);
  AddLineNoPct('PD  sort',      ToS(IniAppGlobals.Time_ComparSort_PD),          6);
  AddLineNoPct('PD  rows',      0,                                              4, IniAppGlobals.Count_Compar_PD);
  AddLineNoPct('PP  open/load', ToS(IniAppGlobals.Time_Compar_PP),              4);
  AddLineNoPct('PP  sort',      ToS(IniAppGlobals.Time_ComparSort_PP),          6);
  AddLineNoPct('PP  rows',      0,                                              4, IniAppGlobals.Count_Compar_PP);
  AddLineNoPct('PI  open/load', ToS(IniAppGlobals.Time_Compar_PI),              4);
  AddLineNoPct('PI  sort',      ToS(IniAppGlobals.Time_ComparSort_PI),          6);
  AddLineNoPct('PI  rows',      0,                                              4, IniAppGlobals.Count_Compar_PI);
  AddLineNoPct('EC  open/load', ToS(IniAppGlobals.Time_Compar_EC),              4);
  AddLineNoPct('EC  sort',      ToS(IniAppGlobals.Time_ComparSort_EC),          6);
  AddLineNoPct('EC  rows',      0,                                              4, IniAppGlobals.Count_Compar_EC);
  AddLineNoPct('IC  open/load', ToS(IniAppGlobals.Time_Compar_IC),              4);
  AddLineNoPct('IC  sort',      ToS(IniAppGlobals.Time_ComparSort_IC),          6);
  AddLineNoPct('IC  rows',      0,                                              4, IniAppGlobals.Count_Compar_IC);
  AddLineNoPct('SB  open/load', ToS(IniAppGlobals.Time_Compar_SB),              4);
  AddLineNoPct('SB  sort',      ToS(IniAppGlobals.Time_ComparSort_SB),          6);
  AddLineNoPct('SB  rows',      0,                                              4, IniAppGlobals.Count_Compar_SB);
  AddLineNoPct('SP  open/load', ToS(IniAppGlobals.Time_Compar_SP),              4);
  AddLineNoPct('SP  sort',      ToS(IniAppGlobals.Time_ComparSort_SP),          6);
  AddLineNoPct('SP  rows',      0,                                              4, IniAppGlobals.Count_Compar_SP);
  AddLineNoPct('ST  open/load', ToS(IniAppGlobals.Time_Compar_ST),              4);
  AddLineNoPct('ST  sort',      ToS(IniAppGlobals.Time_ComparSort_ST),          6);
  AddLineNoPct('ST  rows',      0,                                              4, IniAppGlobals.Count_Compar_ST);
  AddLineNoPct('MT  open/load', ToS(IniAppGlobals.Time_Compar_MT),              4);
  AddLineNoPct('MT  sort',      ToS(IniAppGlobals.Time_ComparSort_MT),          6);
  AddLineNoPct('MT  rows',      0,                                              4, IniAppGlobals.Count_Compar_MT);
  AddLineNoPct('PA  open/load', ToS(IniAppGlobals.Time_Compar_PA),              4);
  AddLineNoPct('PA  sort',      ToS(IniAppGlobals.Time_ComparSort_PA),          6);
  AddLineNoPct('PA  rows',      0,                                              4, IniAppGlobals.Count_Compar_PA);

  // [2] SQL blocks (inside FillProdListsStructure)
  SetLength(Rows, 4);
  Rows[0] := MR('BigSQL hostQry.Open (all blocks)', IniAppGlobals.Time_ToTal_Blockes);
  Rows[1] := MR('FULLITEMKEYDECODER_TOOL',  IniAppGlobals.Time_FULLITEMKEYDECODER_TOOL);
  Rows[2] := MR('Fill_PRODUCT_SqlStart',    IniAppGlobals.Time_Fill_PRODUCT_SqlStart);
  Rows[3] := MR('Fill_Tool_SqlStart',       IniAppGlobals.Time_Fill_Tool_SqlStart);
  AddGroup('[2] SQL BLOCKS  (inside FillProdListsStructure)', Rows);

  // [3] Per-job loop � show total then breakdown sorted by time
  AddTitle('[3] PER-JOB LOOP  (inside insertTheTuplesToProductionTables)');
  AddLine('insertTheTuplesToProductionTables',
    ToS(IniAppGlobals.Time_insertTheTuplesToProductionTables), 2);
  IniAppGlobals.LogTimes.Add('    -- sub-totals sorted by time --');
  SetLength(Rows, 12);
  Rows[0]  := MR('> Time_For_properties',                IniAppGlobals.Time_For_properties);
  Rows[1]  := MR('> Time_For_Material',                  IniAppGlobals.Time_For_Material);
  Rows[2]  := MR('> Time_For_StepTimes',                 IniAppGlobals.Time_For_StepTimes);
  Rows[3]  := MR('> Time_For_Article',                   IniAppGlobals.Time_For_Article);
  Rows[4]  := MR('> Time_For_ReqConn',                   IniAppGlobals.Time_For_Reqconn);
  Rows[5]  := MR('> Time_For_Hdr',                       IniAppGlobals.Time_For_Hgr);
  Rows[6]  := MR('> Time_For_progress',                  IniAppGlobals.Time_For_progress);
  Rows[7]  := MR('> Time_For_ProdReq',                   IniAppGlobals.Time_For_Prodreq);
  Rows[8]  := MR('> Time_For_Batch_Size',                IniAppGlobals.Time_For_Batch_Size);
  Rows[9]  := MR('> Time_For_steps',                     IniAppGlobals.Time_For_steps);
  Rows[10] := MR('> UpdatePropertyLinkerToServingGroup', IniAppGlobals.Time_For_UpdatePropertyLinkerToServingGroup);
  Rows[11] := MR('> UpdatePropertyLinker_CurveFamily',   IniAppGlobals.Time_For_UpdatePropertyLinker_CurveFamily);
  SortDescRows(Rows);
  for i := 0 to High(Rows) do
    AddLine(Rows[i].Lbl, Rows[i].S, 4);

  // [4] Post-processing (inside FillProdListsStructure)
  SetLength(Rows, 15);
  Rows[0]  := MR('BuildProductionDemandFile',          IniAppGlobals.Time_For_BuildProductionDemandFile);
  Rows[1]  := MR('operationAfter_BigSQL (total)',       IniAppGlobals.Time_for_operationAfter_Big_SQL);
  Rows[2]  := MR('BuildProdSchedProgress',             IniAppGlobals.Time_For_BuildProdSchedProgress);
  Rows[3]  := MR('FillGeneric',                         IniAppGlobals.Time_FillGeneric);
  Rows[4]  := MR('insertIntoBALANCE_HEADER_List',       IniAppGlobals.Time_For_insertIntoBALANCE_HEADER_List);
  Rows[5]  := MR('Additional_Data',                     IniAppGlobals.Time_For_Additional_Data);
  Rows[6]  := MR('PrepareHandledWorkcenterTemplate',    IniAppGlobals.Time_For_PrepareHandledWorkcenterTemplate);
  Rows[7]  := MR('BuildSCHEDULESDOWNLOAD_WARP',        IniAppGlobals.Time_For_BuildSCHEDULESDOWNLOAD_WARP);
  Rows[8]  := MR('Fill_MATERIAL_DETAIL_SCHEDULE',       IniAppGlobals.Time_For_Fill_MATERIAL_DETAIL_SCHEDULE);
  Rows[9]  := MR('BuildAvailabilityStruct',             IniAppGlobals.Time_For_BuildAvailabilityStruct);
  Rows[10] := MR('searchInListLinear',                  IniAppGlobals.Time_searchInListLinear);
  Rows[11] := MR('fillADWithRelationToList',            IniAppGlobals.Time_fillADWithRelationToList);
  Rows[12] := MR('fillUserGenericGroupTypeUNIQUEID',    IniAppGlobals.Time_For_fillUserGenericGroupTypeUNIQUEID);
  Rows[13] := MR('fillColorTypeUNIQUEID',               IniAppGlobals.Time_For_fillColorTypeUNIQUEID);
  Rows[14] := MR('PrepareTNA_code_list (�2)',           0);  // negligible � no timer
  AddGroup('[4] POST-PROCESSING  (inside FillProdListsStructure)', Rows);

  // [4b] operationAfter_BigSQL sub-breakdown
  AddTitle('[4b] operationAfter_BigSQL  -- sub-breakdown (sorted by time)');
  AddLine('operationAfter_BigSQL (total)',
    ToS(IniAppGlobals.Time_for_operationAfter_Big_SQL), 2);
  IniAppGlobals.LogTimes.Add('    -- breakdown sorted by time --');
  SetLength(Rows, 9);
  Rows[0] := MR('> RecalcBatchProductionOrder',     IniAppGlobals.Time_For_RecalcBatchProductionOrder);
  Rows[1] := MR('> TryToGroupStepTimesRows',        IniAppGlobals.Time_For_TryToGroupStepTimesRows);
  Rows[2] := MR('> LoadIntoStockDetails',           IniAppGlobals.Time_For_LoadIntoStockDetails);
  Rows[3] := MR('> fillProductsToList (2nd call)',  IniAppGlobals.Time_For_fillProductsToList_2nd);
  Rows[4] := MR('> checkIfNeedInsertNewWarpProd',   IniAppGlobals.Time_For_checkIfNeedInsertNewWarpProd);
  Rows[5] := MR('> PrepareProductionOrderStepQtyPct', IniAppGlobals.Time_For_PrepareProductionOrderStepQtyPct);
  Rows[6] := MR('> DeleteOldProdOrderGrp',          IniAppGlobals.Time_For_DeleteOldProdOrderGrp);
  Rows[7] := MR('> ClearStructMemoryList',          IniAppGlobals.Time_For_ClearStructMemoryList);
  // remainder = memory cleanup dispose loops
  Rows[8].Lbl := '> Memory cleanup (dispose loops)';
  Rows[8].S   := ToS(IniAppGlobals.Time_for_operationAfter_Big_SQL)
               - ToS(IniAppGlobals.Time_For_RecalcBatchProductionOrder)
               - ToS(IniAppGlobals.Time_For_TryToGroupStepTimesRows)
               - ToS(IniAppGlobals.Time_For_LoadIntoStockDetails)
               - ToS(IniAppGlobals.Time_For_fillProductsToList_2nd)
               - ToS(IniAppGlobals.Time_For_checkIfNeedInsertNewWarpProd)
               - ToS(IniAppGlobals.Time_For_PrepareProductionOrderStepQtyPct)
               - ToS(IniAppGlobals.Time_For_DeleteOldProdOrderGrp)
               - ToS(IniAppGlobals.Time_For_ClearStructMemoryList);
  if Rows[8].S < 0 then Rows[8].S := 0;
  SortDescRows(Rows);
  for i := 0 to High(Rows) do
    AddLine(Rows[i].Lbl, Rows[i].S, 4);

  // [4c] PrepareHandledWorkcenterTemplate sub-breakdown
  AddTitle('[4c] PrepareHandledWorkcenterTemplate  -- sub-breakdown (sorted by time)');
  AddLine('PrepareHandledWorkcenterTemplate (total)',
    ToS(IniAppGlobals.Time_For_PrepareHandledWorkcenterTemplate), 2);
  IniAppGlobals.LogTimes.Add('    -- breakdown sorted by time --');
  SetLength(Rows, 4);
  Rows[0] := MR('> PrepareHandledAttributeWorkCenter',   IniAppGlobals.Time_For_PrepareHandledAttributeWorkCenter);
  Rows[1] := MR('> LoadIntoWORKCENTERANDOPERATTRIBUTES', IniAppGlobals.Time_For_LoadIntoWORKCENTERANDOPERATTRIBUTES);
  Rows[2] := MR('> fillStructs',                         IniAppGlobals.Time_For_fillStructs);
  // remainder = PrepareHandledWorkcenterTemplate call itself (builds SQL string)
  Rows[3].Lbl := '> PrepareHandledWorkcenterTemplate (build SQL)';
  Rows[3].S   := ToS(IniAppGlobals.Time_For_PrepareHandledWorkcenterTemplate)
               - ToS(IniAppGlobals.Time_For_PrepareHandledAttributeWorkCenter)
               - ToS(IniAppGlobals.Time_For_LoadIntoWORKCENTERANDOPERATTRIBUTES)
               - ToS(IniAppGlobals.Time_For_fillStructs);
  if Rows[3].S < 0 then Rows[3].S := 0;
  SortDescRows(Rows);
  for i := 0 to High(Rows) do
    AddLine(Rows[i].Lbl, Rows[i].S, 4);

  // [4d] BuildProductionDemandFile sub-breakdown
  AddTitle('[4d] BuildProductionDemandFile  -- sub-breakdown (sorted by time)');
  AddLine('BuildProductionDemandFile (total)',
    ToS(IniAppGlobals.Time_For_BuildProductionDemandFile), 2);
  IniAppGlobals.LogTimes.Add('    -- breakdown sorted by time --');
  SetLength(Rows, 7);
  Rows[0] := MR('> PrepareProdSchedProgress',              IniAppGlobals.Time_For_PrepareProdSchedProgress);
  Rows[1] := MR('> DiscoverDemandsNotRelevantAndDelete',   IniAppGlobals.Time_For_DiscoverDemandsNotRelevantAndDeleteThem);
  Rows[2] := MR('> AddNewDemandsToDownloadDemands',        IniAppGlobals.Time_For_AddNewDemandsToDownloadDemands);
  Rows[3] := MR('> AddNewDemandsToDownloadDemands2',       IniAppGlobals.Time_For_AddNewDemandsToDownloadDemands2);
  Rows[4] := MR('> DeleteAllNotRelevantDemands',           IniAppGlobals.Time_For_DeleteAllNotRelevantDemands);
  Rows[5] := MR('> BuildHandledProductionDemandTemplates', IniAppGlobals.Time_For_BuildHandledProductionDemandTemplatesStr);
  Rows[6] := MR('> BuildHandledWcStr',                     IniAppGlobals.Time_For_BuildHandledWcStr);
  SortDescRows(Rows);
  for i := 0 to High(Rows) do
    AddLine(Rows[i].Lbl, Rows[i].S, 4);

  // [4e] BuildProdSchedProgress sub-breakdown (PrepareProdSchedProgress sub-calls)
  AddTitle('[4e] BuildProdSchedProgress  -- PrepareProdSchedProgress sub-breakdown (sorted by time)');
  AddLine('BuildProdSchedProgress (total)',
    ToS(IniAppGlobals.Time_For_BuildProdSchedProgress), 2);
  IniAppGlobals.LogTimes.Add('    -- breakdown sorted by time --');
  SetLength(Rows, 3);
  Rows[0] := MR('> AddToSchedulesDownloadProgress',        IniAppGlobals.Time_For_AddToSchedulesDownloadProgress);
  Rows[1] := MR('> DeleteAllNotRelevantProgresses',        IniAppGlobals.Time_For_DeleteAllNotRelevantProgresses);
  Rows[2] := MR('> BuildHandledProgressTemplatesList',     IniAppGlobals.Time_For_BuildHandledProgressTemplatesList);
  SortDescRows(Rows);
  for i := 0 to High(Rows) do
    AddLine(Rows[i].Lbl, Rows[i].S, 4);

  // [THREAD WAITS] Idle time at each .Wait call — 0 = thread finished before wait; >0 = move thread start earlier
  AddTitle('[THREAD WAITS]  Idle time waiting for background tasks  (target: 0 for all)');
  AddLineNoPct('Wait - DeleteAllNotRelevantProgresses', ToS(IniAppGlobals.Time_For_Wait_DeleteProgress),         2);
  AddLineNoPct('Wait - SetQryTblCompar  (3 tasks)',     ToS(IniAppGlobals.Time_For_Wait_SetQryTblCompar),        2);
  AddLineNoPct('Wait - ComparPreload',                  ToS(IniAppGlobals.Time_For_Wait_ComparPreload),          2);
  AddLineNoPct('Wait - BuildProdSchedProgress',         ToS(IniAppGlobals.Time_For_Wait_BuildProdSchedProgress), 2);

  // [5] Setup & lookup tables (inside FillProdListsStructure)
  SetLength(Rows, 30);
  Rows[0]  := MR('fillProductsToList',                   IniAppGlobals.Time_for_fillProductsToList);
  Rows[1]  := MR('fill_ProdOrder_GrpNo_list',            IniAppGlobals.Time_for_fill_Production_Order_Grp_No_list);
  Rows[2]  := MR('fillSalesOrderToList',                 IniAppGlobals.Time_for_fillSalesOrderToList);
  Rows[3]  := MR('LoadProjectNumbers',                   IniAppGlobals.Time_For_LoadProjectNumbers);
  Rows[4]  := MR('PrepareHandled_ProdDemandTemplate',    IniAppGlobals.Time_for_PrepareHandledProductionDemandTemplate);
  Rows[5]  := MR('fillProductionDemandTemplateStruct',   IniAppGlobals.Time_for_fillProductionDemandTemplateStruct);
  Rows[6]  := MR('fillArticleTypeToList',                IniAppGlobals.Time_For_fillArticleTypeToList);
  Rows[7]  := MR('fillPropertyStruct',                   IniAppGlobals.Time_For_fillPropertyStruct);
  Rows[8]  := MR('makeRelevantOperationsForColumns',     IniAppGlobals.Time_for_makeRelevantOperationsForColumns);
  Rows[9]  := MR('fillItemTypeLogicalWarehouseStruct',   IniAppGlobals.Time_for_fillItemTypeLogicalWarehouseStruct);
  Rows[10] := MR('Build_AD_SelectedColums',              IniAppGlobals.Time_For_Build_AD_SelectedColums);
  Rows[11] := MR('fillUserGenericGroupType',             IniAppGlobals.Time_For_fillUserGenericGroupType);
  Rows[12] := MR('fillColorType',                        IniAppGlobals.Time_For_fillColorType);
  Rows[13] := MR('fillItemTypesList',                    IniAppGlobals.Time_For_fillItemTypesList);
  Rows[14] := MR('fillLogicalWarehousesToList',          IniAppGlobals.Time_for_fillLogicalWarehousesToList);
  Rows[15] := MR('fillAlternativeUM',                    IniAppGlobals.Time_For_fillAlternativeUM);
  Rows[16] := MR('fillAlternativeWarehouseStruct',       IniAppGlobals.Time_for_fillAlternativeWarehouseStruct);
  Rows[17] := MR('fillResTableToList',                   IniAppGlobals.Time_For_fillResTableToList);
  Rows[18] := MR('fillRoutingStepTimeTypeToList',        IniAppGlobals.Time_for_fillRoutingStepTimeTypeToList);
  Rows[19] := MR('fillOperationsToList',                 IniAppGlobals.Time_For_fillOperationsToList);
  Rows[20] := MR('fillPurchaseOrderToList',              IniAppGlobals.Time_For_fillPurchaseOrderToList);
  Rows[21] := MR('Fill_Products_properties',             IniAppGlobals.Time_For_Fill_Products_properties);
  Rows[22] := MR('fillItemTypeTemplatesToList',          IniAppGlobals.Time_for_fillItemTypeTemplatesToList);
  Rows[23] := MR('fillProductionDemandCountersToList',   IniAppGlobals.Time_for_fillProductionDemandCountersToList);
  Rows[24] := MR('fillProductionProgressTemplateStruct', IniAppGlobals.Time_For_fillProductionProgressTemplateStruct);
  Rows[25] := MR('CheckTableColumns',                    IniAppGlobals.Time_for_CheckTableColumns);
  Rows[26] := MR('fillUnique_nonUniqueWCProcesses',      IniAppGlobals.Time_For_fillUnique_nonUniqueWorkCenterProcesses);
  Rows[27] := MR('ifNeededAdd_StepIdListForProgress_PO', IniAppGlobals.Time_For_ifNeededAddToStepIdListForProgressList_PO);
  Rows[28] := MR('ifNeededAdd_WCAndOperationToList',     IniAppGlobals.Time_For_ifNeededAddWorkCenterAndOperationToList);
  Rows[29] := MR('getTimeTypeCode',                      IniAppGlobals.Time_For_getTimeTypeCode);
  AddGroup('[5] SETUP & LOOKUP TABLES  (inside FillProdListsStructure)', Rows);

  // [6] DB writes + setup (InsertReqListToDataBase / UpdateStatusRequests)
  IniAppGlobals.LogTimes.Add('');
  IniAppGlobals.LogTimes.Add(Format('  Requests_in_change_list: %d', [IniAppGlobals.Count_ReqChanged]));
  SetLength(Rows, 49);
  Rows[0]  := MR ('WriteLogLineToDB',  IniAppGlobals.Time_WriteLogLineToDBFromServer);
  Rows[1]  := MRC('Del_PR',    IniAppGlobals.Time_DelPR,    IniAppGlobals.Count_DelPR);
  Rows[2]  := MRC('Update_PR', IniAppGlobals.Time_UpdatePR, IniAppGlobals.Count_UpdatePR);
  Rows[3]  := MRC('Insert_PR', IniAppGlobals.Time_InsertPR, IniAppGlobals.Count_InsertPR);
  Rows[4]  := MRC('Del_PH',    IniAppGlobals.Time_DelPH,    IniAppGlobals.Count_DelPH);
  Rows[5]  := MRC('Update_PH', IniAppGlobals.Time_UpdatePH, IniAppGlobals.Count_UpdatePH);
  Rows[6]  := MRC('Insert_PH', IniAppGlobals.Time_InsertPH, IniAppGlobals.Count_InsertPH);
  Rows[7]  := MRC('Del_PD',    IniAppGlobals.Time_DelPD,    IniAppGlobals.Count_DelPD);
  Rows[8]  := MRC('Update_PD', IniAppGlobals.Time_UpdatePD, IniAppGlobals.Count_UpdatePD);
  Rows[9]  := MRC('Insert_PD', IniAppGlobals.Time_InsertPD, IniAppGlobals.Count_InsertPD);
  Rows[10] := MRC('Del_PS',    IniAppGlobals.Time_DelPS,    IniAppGlobals.Count_DelPS);
  Rows[11] := MRC('Update_PS', IniAppGlobals.Time_UpdatePS, IniAppGlobals.Count_UpdatePS);
  Rows[12] := MR ('Del_MS',    IniAppGlobals.Time_DelMS);
  Rows[13] := MR ('Update_MS', IniAppGlobals.Time_UpdateMS);
  Rows[14] := MRC('Del_PP',    IniAppGlobals.Time_DelPP,    IniAppGlobals.Count_DelPP);
  Rows[15] := MRC('Update_PP', IniAppGlobals.Time_UpdatePP, IniAppGlobals.Count_UpdatePP);
  Rows[16] := MRC('Insert_PP', IniAppGlobals.Time_InsertPP, IniAppGlobals.Count_InsertPP);
  Rows[17] := MRC('Del_PI',    IniAppGlobals.Time_DelPI,    IniAppGlobals.Count_DelPI);
  Rows[18] := MRC('Update_PI', IniAppGlobals.Time_UpdatePI, IniAppGlobals.Count_UpdatePI);
  Rows[19] := MRC('Insert_PI', IniAppGlobals.Time_InsertPI, IniAppGlobals.Count_InsertPI);
  Rows[20] := MRC('Del_EC',    IniAppGlobals.Time_DelEC,    IniAppGlobals.Count_DelEC);
  Rows[21] := MRC('Update_EC', IniAppGlobals.Time_UpdateEC, IniAppGlobals.Count_UpdateEC);
  Rows[22] := MRC('Insert_EC', IniAppGlobals.Time_InsertEC, IniAppGlobals.Count_InsertEC);
  Rows[23] := MRC('Del_IC',    IniAppGlobals.Time_DelIC,    IniAppGlobals.Count_DelIC);
  Rows[24] := MRC('Update_IC', IniAppGlobals.Time_UpdateIC, IniAppGlobals.Count_UpdateIC);
  Rows[25] := MRC('Insert_IC', IniAppGlobals.Time_InsertIC, IniAppGlobals.Count_InsertIC);
  Rows[26] := MRC('Del_SB',    IniAppGlobals.Time_DelSB,    IniAppGlobals.Count_DelSB);
  Rows[27] := MRC('Update_SB', IniAppGlobals.Time_UpdateSB, IniAppGlobals.Count_UpdateSB);
  Rows[28] := MRC('Insert_SB', IniAppGlobals.Time_InsertSB, IniAppGlobals.Count_InsertSB);
  Rows[29] := MRC('Del_SP',    IniAppGlobals.Time_DelSP,    IniAppGlobals.Count_DelSP);
  Rows[30] := MRC('Update_SP', IniAppGlobals.Time_UpdateSP, IniAppGlobals.Count_UpdateSP);
  Rows[31] := MRC('Insert_SP', IniAppGlobals.Time_InsertSP, IniAppGlobals.Count_InsertSP);
  Rows[32] := MRC('Del_ST',    IniAppGlobals.Time_DelST,    IniAppGlobals.Count_DelST);
  Rows[33] := MRC('Update_ST', IniAppGlobals.Time_UpdateST, IniAppGlobals.Count_UpdateST);
  Rows[34] := MRC('Insert_ST', IniAppGlobals.Time_InsertST, IniAppGlobals.Count_InsertST);
  Rows[35] := MRC('Del_MT',    IniAppGlobals.Time_DelMT,    IniAppGlobals.Count_DelMT);
  Rows[36] := MRC('Update_MT', IniAppGlobals.Time_UpdateMT, IniAppGlobals.Count_UpdateMT);
  Rows[37] := MRC('Insert_MT', IniAppGlobals.Time_InsertMT, IniAppGlobals.Count_InsertMT);
  Rows[38] := MRC('Del_PA',    IniAppGlobals.Time_DelPA,    IniAppGlobals.Count_DelPA);
  Rows[39] := MRC('Update_PA', IniAppGlobals.Time_UpdatePA, IniAppGlobals.Count_UpdatePA);
  Rows[40] := MRC('Insert_PA',               IniAppGlobals.Time_InsertPA,                 IniAppGlobals.Count_InsertPA);
  Rows[41] := MR ('ClearChangeReqWcTables',  IniAppGlobals.Time_ClearChangeReqWcTables);
  Rows[42] := MR ('UpdCode_Reset (all=0)',   IniAppGlobals.Time_UpdCodeReset);
  Rows[43] := MR ('UpdCode_Set (changed=1)', IniAppGlobals.Time_UpdCodeSet);
  Rows[44] := MR ('Delete_PS_Orphans',       IniAppGlobals.Time_DeletePS_Orphans);
  Rows[45] := MR ('Delete_PSMCM_Orphans',    IniAppGlobals.Time_DeletePSMCM_Orphans);
  Rows[46] := MR ('SrvQryPS_Open',           IniAppGlobals.Time_SrvQryPS_Open);
  Rows[47] := MR ('SrvQryPSMCM_Open',        IniAppGlobals.Time_SrvQryPSMCM_Open);
  Rows[48] := MR ('InsertChangeReqToTable',  IniAppGlobals.Time_InsertChangeReqToTable);
  AddGroup('[6] DB WRITES  (InsertReqListToDataBase)', Rows);

  // Footer
  IniAppGlobals.LogTimes.Add('');
  IniAppGlobals.LogTimes.Add(StringOfChar('=', 80));
  IniAppGlobals.LogTimes.Add(
    Format('  TOTAL DOWNLOAD TIME   %.2f s', [TotalSecs]));
  IniAppGlobals.LogTimes.Add(StringOfChar('=', 80));
end;

//----------------------------------------------------------------------------//

function LoadFromHost(var DataChange : boolean ; Handl : THandle; var GotAccessToInsertData : boolean): boolean;
var
  tbl:    table;
  LocQry : TMqmQuery;
  HostQry :  TMqmQuery;
  ArcQry :  TMqmQuery;
  tbInfo: ^TTblInfo;
  TypMode : TDTypeMode;
  DndArchiveHostName, DndArchiveLocalName : TDndArchiveName;
  Msg : string;
  showTableName : boolean;
  HostDB, LocalDB : string;
  MqmTrs : TMqmTransaction;
  Time_FillProdListsStructure, Time_CheckChangeReq, Time_Total_DataBase_Operation : double;
begin
  Result := true;
  showTableName := false;
  IniAppGlobals.Time_For_ToTal_Download_Time := NOW;
  DndArchiveHostName := GetDndArchiveHostName;
  DndArchiveLocalName := GetDndArchiveLocalName;
  SetMaterialSchedule_Warp_Send_Client(false);
  SetBalanceHeader_Changed_Send_Client(false);
  if DndArchiveHostName = TD_AS_400 then
    HostDb := ' As-400 '
  else if DndArchiveHostName = TD_Db2 then
    HostDb := ' Db2 '
  else if DndArchiveHostName = TD_Oracle then
    HostDb := ' Oracle ';

  if DndArchiveLocalName = TD_AS_400 then
    LocalDb := ' As-400 '
  else if DndArchiveLocalName = TD_Db2 then
    LocalDb := ' Db2 '
  else if DndArchiveLocalName = TD_Oracle then
    LocalDb := ' Oracle ';


  TypMode := GetTypeMode;
  tbInfo := nil;

  if not IsHostDbConnected then
    HostDbConnect;
  if not IsLocalDbConnected then
    LocalDbConnect(true);

  if DndArchiveHostName <> TD_AS_400 then
  begin
    if not IsArcDbConnected then
      ArcDbConnect;
  end;

  LocQry := ThreadCreateQuery(Main_DB);

  HostQry  := ThreadCreateQueryHost;
  ArcQry := ThreadCreateQueryArc;

  case TypMode of
    TD_OnlyProg : FSrvLoad.LabelDownOp.Caption := _('Downloading progress file...');
    TD_AllFiles : FSrvLoad.LabelDownOp.Caption := _('Downloading all files...');
    TD_OnlyProd, TD_DownloadUploadToNow : FSrvLoad.LabelDownOp.Caption := _('Downloading production files...');
    TD_OnlyArchivs : FSrvLoad.LabelDownOp.Caption := _('Downloading archive files...');
  end;

  try

    if (TypMode = TD_OnlyArchivs) then
    begin
      showTableName := true;
      LocQry.Transaction := ThreadCreateTransaction(Main_DB);
      LocQry.Transaction.StartTransaction;

      for tbl := Low(table) to High(table) do
      begin
        tbInfo := @tblInfo[tbl];
        if TCOpList[tbl].act and Assigned(TCOpList[tbl].AStoSrvArchiv) then
        begin
          if CheckTblNotToDwnload(tbl) then continue;
          if (DndArchiveHostName <> TD_AS_400) and (tbl = tbl_wkc_group) then continue;
          if DndArchiveHostName = TD_AS_400 then
          begin
            if (tbl = tbl_Identifiers) then continue;
            TCOpList[tbl].AStoSrvArchiv(tbl, LocQry, HostQry)  // as400
         end
          else
            TCOpList[tbl].AStoSrvArchiv(tbl, LocQry, ArcQry); //then  // only for interbase
        end;
        Application.ProcessMessages;
      end;
      LocQry.Transaction.Commit;
      showTableName := false;
      UpdateWorkCenterVisible(LocQry);
      UpdateLocalPropertyTable(LocQry);
      if DndArchiveHostName = TD_AS_400 then
        UpdateLocalPlantForWorkCenter(LocQry);
    end;

    except
    on E: Exception do
    begin
       FSrvLoad.LabelDownOp.Caption := '';
       DndArchiveHostName := GetDndArchiveHostName;
       if Length(E.Message) > 200 then
         msg := copy(E.Message ,1 , 200)
       else
         msg := E.Message;
       if (DndArchiveHostName = TD_AS_400) then
       begin
         E.Message := E.Message + 'Exception Mqm';
         FSrvLoad.MmErrors.Lines.Add(tbInfo.Asname + ' ' + E.Message);
         WriteToLog('LoadFromHost', ' ' + tbInfo.Asname + ' ' + msg , true);
       end
       else
       begin
         FSrvLoad.MmErrors.Lines.Add(tbInfo.GetTableName + ' ' + E.Message);
         WriteToLog('LoadFromHost', ' ' + tbInfo.GetTableName + ' ' + msg , true);
       end;

       UpdateOperation('');
       //Result := false;
       FSrvLoad.IExit.Enabled  := true;
       FSrvLoad.PGCmain.TabIndex := 1;
       if showTableName then
       begin
        //  raise EFDDBEngineException.CreateFmt(E.Message + ' ' + ' Host DB : ' + HostDB + ' / Local DB : ' + LocalDb + ' ' +
        //       ' Archive download table : ' + tbInfo.GetTableName + '  UMTransfer.LoadFromHost' , [E.Message]);
            ApplicationShowException(E);
       end
       else
        //  raise EFDDBEngineException.CreateFmt(E.Message + ' ' + ' Host DB : ' + HostDB + ' / Local DB : ' + LocalDb + ' ' +
         //      ' Archive download table : ' + ' UMTransfer.LoadFromHost' , [E.Message]);
           ApplicationShowException(E);
      end;
    end;

    //end;

    if (TypMode = TD_OnlyProd) or (TypMode = TD_DownloadUploadToNow) or (TypMode = TD_ProdAndUpload) or (TypMode = TD_DownLoadAfterUpload) then
    begin
      try

       // files that are downloaded as production files
      if IniAppGlobals.PreparationExeName <> '' then
      begin
       // IniAppGlobals.LogTimes.Add('Time before FillProdListsStructure : ' + datetimetostr(NOW));
        CreateProdCont;
        IniAppGlobals.Time_For_DownloadCompanyHandling := NOW;
        DownloadCompanyHandling(LocQry, HostQry);
        IniAppGlobals.Time_For_DownloadCompanyHandling := NOW - IniAppGlobals.Time_For_DownloadCompanyHandling;
        if IniAppGlobals.DownloadTo <> '2' then
          StartComparPreload;
        Time_FillProdListsStructure := NOW;
        FillProdListsStructure(LocQry, HostQry, ArcQry);

        // Timing will be reported at end of LoadFromHost via PrintTimingReport
        try
          IniAppGlobals.LogTimes.LoadFromFile(LocAppGlobals.AppDir + '\' + 'LogDownloadTimes' +'.txt');
        except
        end;
        Time_FillProdListsStructure := NOW - Time_FillProdListsStructure;
      end;

     //  ArcQry.Transaction.Commit;
      showTableName := true;
      for tbl := Low(table) to High(table) do
      begin
        tbInfo := @tblInfo[tbl];
        if TCOpList[tbl].act and Assigned(TCOpList[tbl].ActLikeProduction) then
        begin
         // srvTrs.Active := true;
          UpdateOperation(_(''));
          UpdateOperation(TCOpList[tbl].TableName);
          if not TCOpList[tbl].ActLikeProduction(tbl, LocQry, ArcQry) then
          begin
           // srvTrs.Rollback;
            Result := false;
            break
          end;
        end;

        Application.ProcessMessages;
      end;
    //  LocQry.Transaction.Commit;

  //    LocQry.Transaction := CreateTransaction(Main_DB);
  //    LocQry.Transaction.StartTransaction;
   //   LocQry.CachedUpdates := false;

      // Download the production files
      UpdateOperation(_(''));
      UpdateOperation(_('CreateProdContMemory'));
      CreateProdContMemory;

      if IniAppGlobals.PreparationExeName <> '' then
      begin
        UpdateOperation(_('UpdateBuildedPropertyFromOtherProperty'));
        UpdateBuildedPropertyFromOtherProperty;
        UpdateOperation(_('BuildFamilyStructure'));
        BuildFamilyStructure
      end;

      for tbl := Low(table) to High(table) do
      begin
        tbInfo := @tblInfo[tbl];
        if TCOpList[tbl].act and Assigned(TCOpList[tbl].AddProdFiles) then
        begin
         // continue;
          UpdateOperation(TCOpList[tbl].TableName);
          if not TCOpList[tbl].AddProdFiles(tbl, LocQry, HostQry, true, false) then
          begin
            Result := false;
            break
          end;
        end;
        Application.ProcessMessages;
      end;

   //   LocQry.CachedUpdates := true;
    //  LocQry.Transaction.Commit;

    //end;

      if Result then
      begin
        showTableName := false;
        FSrvLoad.LblTable.Caption := _('Prepare changed request list . . .');

        PostMessage(Handl, CM_UPDATE, OPI_LocalSrv, StrToInt(IniAppGlobals.Identifier));

        if IniAppGlobals.DownloadTo <> '2' then
          WaitAndAssignComparPreload;
        Time_CheckChangeReq := NOW;
        CheckChangeReq(HostQry);
        Time_CheckChangeReq := NOW - Time_CheckChangeReq;
        UpdateOperation('');

        if CheckServerDoubleInstance then
        begin
          ShowMessage('MqmSrvLoad is running on another Folder/Machine with same Identifier = ' + IniAppGlobals.Identifier +
                    #13#10  + ' Application will be terminated');
          ClearMemoryList;
          Application.Terminate;
        end;

        Time_Total_DataBase_Operation := NOW;
        if GetReqListCount > 0 then
        begin
          DataChange := InsertReqListToDataBase(GotAccessToInsertData);
          if not GotAccessToInsertData then
             Result := false;
        end;
        Time_Total_DataBase_Operation := NOW - Time_Total_DataBase_Operation;

        if GetCapResListCount > 0 then
        begin
          DataChange := InsertCapResListToDataBase;
        end;

        ClearMemoryList;

        FSrvLoad.LabelDownOp.Caption := '';
      end
      else
      begin
        //DestroyPDSupportThread;
        result := false;
      end;
   // end;

    except
    on E: Exception do
    begin
       FSrvLoad.LabelDownOp.Caption := '';
       DndArchiveHostName := GetDndArchiveHostName;
       if Length(E.Message) > 200 then
         msg := copy(E.Message ,1 , 200)
       else
         msg := E.Message;
       if (DndArchiveHostName = TD_AS_400) then
       begin
         msg := msg + ' Exception Mqm';
         FSrvLoad.MmErrors.Lines.Add(tbInfo.Asname + ' ' + msg);
         WriteToLog('LoadFromHost', ' ' + tbInfo.Asname + ' ' + msg , true);
       end
       else
       begin
         if showTableName then
         begin
           FSrvLoad.MmErrors.Lines.Add(tbInfo.GetTableName + ' ' + msg);
           WriteToLog('LoadFromHost', ' ' + tbInfo.GetTableName + ' ' + msg , true);
         end
         else
         begin
           FSrvLoad.MmErrors.Lines.Add(msg);
           FSrvLoad.MmErrors.Lines.Add(' Host DB : ' + HostDB + ' / Local DB : ' + LocalDb + ' ' +
             ' Download production files : ' + ' UMTransfer.LoadFromHost');
         end;
       end;

       UpdateOperation('');
       //Result := false;
       FSrvLoad.IExit.Enabled  := true;
       FSrvLoad.PGCmain.TabIndex := 1;

       if showTableName then
       begin
          ApplicationShowException(E);
      {   if (DndArchiveHostName = TD_AS_400) then
           raise
         else
           raise EFDDBEngineException.CreateFmt(msg + ' ' + ' Host DB : ' + HostDB + ' / Local DB : ' + LocalDb + ' ' +
             ' Download production files : ' + tbInfo.GetTableName + '  UMTransfer.LoadFromHost' , [msg]);   }
       end
       else
         ApplicationShowException(E);

       end;


     end;
  end;
    
  if (GetTypeMode = TD_OnlyArchivs) then
     SetTypeMode(GetOldType);

  HostQry.Free;
  LocQry.Free;
  ArcQry.Free;

  IniAppGlobals.Time_For_ToTal_Download_Time := NOW - IniAppGlobals.Time_For_ToTal_Download_Time;
  PrintTimingReport(Time_FillProdListsStructure, Time_CheckChangeReq, Time_Total_DataBase_Operation);

  IniAppGlobals.LogTimes.SaveToFile(LocAppGlobals.AppDir + '\LogDownloadTimes.txt');
  IniAppGlobals.LogTimes.Clear;

  if Result then
    UpdateOperation('')
  else
  begin
    UpdateOperation(_('load failed'));
    FSrvLoad.IExit.Enabled := true;
  end;


end;

//----------------------------------------------------------------------------//

function SendSchedToHOST: boolean;
var
  tbl:    table;
  srvQry: TMqmQuery;
  HostQry:  TMqmQuery;
begin
  Result := true;

  try

  srvQry := ThreadCreateQuery(Main_DB);
  srvQry.Transaction := ThreadCreateTransaction(Main_DB);
  srvQry.Transaction.StartTransaction;

  HostQry  := ThreadCreateQueryHost;

  // send the data to the server
  for tbl := Low(table) to High(table) do
    if TCOpList[tbl].act and Assigned(TCOpList[tbl].UpdAS) then
    begin

      if not TCOpList[tbl].UpdAS(tbl, srvQry, HostQry) then
      begin
      //  srvTrs.Rollback;
        Result := false;
        break
      end;
    //  srvQry.connection.Commit
    end;
  HostQry.Close;
  srvQry.Close;

  HostQry.Free;
  srvQry.Free;

  except
    on E: Exception do
    begin

      EndOperation(false);
      raise EFDDBEngineException.CreateFmt('' , [E.Message]);

    end;
  end;

//  UpdateOperation('');
end;

//----------------------------------------------------------------------------//

function SendWarpSchedToNOW : boolean;
var
  tbl:    table;
  srvQry:   TMqmQuery;
//  trs:    TMqmTransaction;
  HostNOWMqmQry : TMqmQuery;
  MQMUploaded : boolean;
begin
  try
    Result := true;
    srvQry := ThreadCreateQuery(Main_DB);
    srvQry.Transaction := ThreadCreateTransaction(Main_DB);
    srvQry.Transaction.StartTransaction;

  //  ConnectToNowHost;
    HostNOWMqmQry := ThreadCreateQueryHost;

    tbl    := tbl_MaterialDetailSchedule;
   // MQMUploaded := true;

    if not TCOpList[tbl].UpdTableToNOW(tbl, srvQry, HostNOWMqmQry) then
      result := false;


   { if ((MQM_OR_MCM_ENVIRONMENT = 'MQM') or (MQM_OR_MCM_ENVIRONMENT = '')) then
    begin
      Application.ProcessMessages;
      Is_SCHEDULESUPLOAD_emptyMQM := false;
      if not TCOpList[tbl].UpdToNOW(tbl, srvQry, HostNOWMqmQry ,Is_SCHEDULESUPLOAD_emptyMQM, MQM_OR_MCM_ENVIRONMENT) then
      begin
        MQMUploaded := false;
      end
    end;

    if not MQMUploaded then
     MQM_OR_MCM_ENVIRONMENT := 'MQM';    }

    HostNOWMqmQry.Close;
    srvQry.Close;

    HostNOWMqmQry.Free;
    srvQry.Free;

  except
    on E: Exception do
    begin

//      EndOperation(false);
      raise;
   //   raise EFDDBEngineException.CreateFmt(E.Message + ' ' + ' / Loca'  +
   //         ' Archive download table : ' + ' UMTransfer.LoadFromHost' , [E.Message]);

    //  raise EFDDBEngineException.CreateFmt('' , [E.Message]);

    end;
  end;
  UpdateOperation('');
end;

//----------------------------------------------------------------------------//

function SendSchedToNOW(var Is_SCHEDULESUPLOAD_emptyMQM : boolean; var Is_SCHEDULESUPLOAD_emptyMCM : boolean; var MQM_OR_MCM_ENVIRONMENT : string): boolean;
var
  tbl:    table;
  srvQry:   TMqmQuery;
//  trs:    TMqmTransaction;
  HostNOWMqmQry : TMqmQuery;
  MQMUploaded : boolean;
begin
  try
  Result := true;
  srvQry := ThreadCreateQuery(Main_DB);
  srvQry.Transaction := ThreadCreateTransaction(Main_DB);
  srvQry.Transaction.StartTransaction;

//  ConnectToNowHost;
  HostNOWMqmQry := ThreadCreateQueryHost;

  tbl    := tbl_prod_sched;
  MQMUploaded := true;
  if ((MQM_OR_MCM_ENVIRONMENT = 'MQM') or (MQM_OR_MCM_ENVIRONMENT = '')) then
  begin
    Application.ProcessMessages;
    Is_SCHEDULESUPLOAD_emptyMQM := false;
    if not TCOpList[tbl].UpdToNOW(tbl, srvQry, HostNOWMqmQry ,Is_SCHEDULESUPLOAD_emptyMQM, MQM_OR_MCM_ENVIRONMENT) then
    begin
      MQMUploaded := false;
    end
  end;

  if Check_MCM_SCHED then
  begin
    tbl := tbl_prod_sched_mcm;
    srvQry.Transaction.StartTransaction;
    if (MQM_OR_MCM_ENVIRONMENT = 'MCM') or (MQM_OR_MCM_ENVIRONMENT = '') then
    begin
      Application.ProcessMessages;
      Is_SCHEDULESUPLOAD_emptyMCM := false;
      if not TCOpList[tbl].UpdToNOW(tbl, srvQry, HostNOWMqmQry ,Is_SCHEDULESUPLOAD_emptyMCM, MQM_OR_MCM_ENVIRONMENT) then
      begin
        MQM_OR_MCM_ENVIRONMENT := 'MCM';
      end
    end;
  end;

  if not MQMUploaded then
     MQM_OR_MCM_ENVIRONMENT := 'MQM';

  HostNOWMqmQry.Close;
  srvQry.Close;

  HostNOWMqmQry.Free;
  srvQry.Free;

  except
    on E: Exception do
    begin

//      EndOperation(false);
      raise;
   //   raise EFDDBEngineException.CreateFmt(E.Message + ' ' + ' / Loca'  +
   //         ' Archive download table : ' + ' UMTransfer.LoadFromHost' , [E.Message]);

    //  raise EFDDBEngineException.CreateFmt('' , [E.Message]);

    end;
  end;
  UpdateOperation('');
end;

//----------------------------------------------------------------------------//

function SendArchiveToHOST : boolean;
var
  tbl:    table;
  srvQry: TMqmQuery;
//  srvTrs: TMqmTransaction;
  HostQry:  TMqmQuery;
begin
  Result := true;

//  srvTrs := CreateTransaction(Main_DB);
  srvQry := ThreadCreateQuery(Main_DB);
  HostQry  := ThreadCreateQueryHost;

  // send Archive to the host
  for tbl := Low(table) to High(table) do
    //if TCOpList[tbl].IsArchive and Assigned(TCOpList[tbl].UpArchive) then
    if Assigned(TCOpList[tbl].UpArchive) then
    begin
     // srvTrs.Active := true;
      if not TCOpList[tbl].UpArchive(tbl, srvQry, HostQry) then
      begin
        srvQry.transaction.Rollback;
        Result := false;
        break
      end;
      srvQry.Connection.Commit
    end;
  HostQry.Close;
  srvQry.Close;

  HostQry.Free;
  srvQry.Free;

  UpdateOperation('');
end;

//----------------------------------------------------------------------------//

function CheckWarpIn_SCHED: boolean;
var
  srvQry: TMqmQuery;
  tbInfo: ^TTblInfo;
begin
  tbInfo := @tblInfo[tbl_MaterialDetailSchedule];
  srvQry := ThreadCreateQuery(Main_DB);
  Result := false;
  with srvQry do
  begin
    sql.Clear;
    sql.Add('select * from ' + tbInfo.GetTableName);
    sql.Add(WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
//    SQL.Add(' AND MDS_RSC_CODE <> ' + QuotedStr(''));
//    SQL.Add(' AND MDS_RSC_CODE <> ' + QuotedStr(' '));
//    try
//      open;
//    except
//      srvQry.free;
//      exit
//    end;
    open;
    if Eof then
      Result := false
    else
      Result := true
  end;
  srvQry.free;
end;

//----------------------------------------------------------------------------//

function CheckWarpIn_HOST : boolean;
var
  HostQry :  TMqmQuery;
  SqlStr : string;
begin
  Result := true;
  HostQry  := ThreadCreateQueryHost;
  with HostQry do
  begin
    SqlStr := ' Select * FROM MATERIALDETAILSCHEDULE ';
    SQL.Text := SqlStr;
    try
      HostQry.Open;
    except
      Result := false;
      HostQry.Free;
      Exit
    end;
  end;

  HostQry.Free;
end;

//----------------------------------------------------------------------------//

function CheckPsInPc: boolean;
var
  srvQry: TMqmQuery;
//  srvTrs: TMqmTransaction;
  tbInfo: ^TTblInfo;
begin
//  Result := false;
  tbInfo := @tblInfo[tbl_prod_sched];
//  srvTrs := CreateTransaction(Main_DB, false);
  srvQry := ThreadCreateQuery(Main_DB);

  with srvQry do
  begin
    sql.Clear;
    sql.Add('select * from ' + tbInfo.GetTableName);
    sql.Add(WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
    open;
    if Eof then
      Result := false
    else
      Result := true
  end;
  srvQry.free;
//  srvTrs.free;
end;

//----------------------------------------------------------------------------//

function Check_MCM_SCHED : boolean;
var
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
begin
  result := false;
  tbInfo := @tblInfo[tbl_prod_sched_mcm];
  qry := ThreadCreateQuery(Main_DB);
  qry.SQL.Text := ' select * from ' + tbInfo.GetTableName + WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER));
  qry.Open;
  if not qry.Eof then
     Result := true;
  qry.Free;
end;

//----------------------------------------------------------------------------//

function CheckArcToSend : boolean;
var
  srvQry: TMqmQuery;
//  srvTrs: TMqmTransaction;
  tbInfo: ^TTblInfo;
begin
  tbInfo := @tblInfo[tbl_Archive_To_Host];
  SetFldPfx(tbInfo.pfx);

//  srvTrs := CreateTransaction(Cfg_DB, false);
  srvQry := ThreadCreateQuery(Cfg_DB);

  with srvQry do
  begin
    sql.Clear;
    sql.Add('select * from ' + tbInfo.GetTableName);
    open;
    if Eof then
      Result := false
    else
      Result := true
  end;
  srvQry.free;
end;

//----------------------------------------------------------------------------//

function CheckProcessAfterUploadToNow : boolean;
var
  HostMqmQry :  TMqmQuery;
  hostSqlStr : string;
begin
  Result := true;
  HostMqmQry := ThreadCreateQueryHost;

  with HostMqmQry do
  begin
     SQL.Clear;

     hostSqlStr :=
       'Select distinct 1 DummyNumber from SCHEDULESUPLOAD ' +
       'WHERE COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ' +
       'AND   ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' ' +
       'union all ' +
       'Select distinct 1 DummyNumber from SCHEDULESOFSTEPS ' +
       'WHERE COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ' +
       'AND   ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' ' +
       'AND   UPDATED = 1 ';

     HostMqmQry.sql.text := hostSqlStr;
     open;
     if not HostMqmQry.EOF then
       Result := false;
  end;

  HostMqmQry.Close;
  HostMqmQry.Free;
end;

//----------------------------------------------------------------------------//

{function CheckTempDate(var LastDateTime : TDateTime ; var Tempstation : string) : boolean;
var
  qry :       TMqmQuery;
  trs :       TMqmTransaction;
  tbInfo:     ^TTblInfo;
begin
  Result := false;

  trs := CreateTransaction(Cfg_DB, true);
  qry := ThreadCreateQuery(trs, Cfg_DB);
  tbInfo := @tblInfo[tbl_cfg_exchg_wkst];
  SetFldPfx(tbInfo.pfx);

  Qry.SQL.Clear;
  Qry.Transaction.StartTransaction;
  Qry.SQL.Add('select * from ' + tbInfo.PCname);
  Qry.SQL.Add('where CEW_POLL = ''T''');
  Qry.Open;
  if not Qry.Eof then
  begin
    Result := true;
    LastDateTime := Qry.FieldByName('CEW_CONNECT').AsDateTime;
    Tempstation := Qry.FieldByName('CEW_WKST_CODE').AsString;
  end;
  trs.Free;
  qry.Free;

end;

//----------------------------------------------------------------------------//

function CheckForTempStationOpen : boolean;
var
  DateTime, LastDateTime  :  TDateTime;
  qry :     TMqmQuery;
  trs :        TMqmTransaction;
  tbInfo:     ^TTblInfo;
  Tempstation : string;
begin
  Result := false;

  trs := CreateTransaction(Cfg_DB, true);
  qry := ThreadCreateQuery(trs, Cfg_DB);

  tbInfo := @tblInfo[tbl_cfg_exchg_wkst];
  SetFldPfx(tbInfo.pfx);

  qry.Transaction.StartTransaction;

  qry.SQL.Clear;
  qry.SQL.Add('select * from ' + tbInfo.PCname);
  qry.SQL.Add('where CEW_POLL = ''T''');
  qry.Open;
  if qry.EOF then Exit;
  while not qry.EOF do
  begin
    DateTime := qry.FieldByName('CEW_CONNECT').AsDateTime;
    sleep(6000);
    if CheckTempDate(LastDateTime,Tempstation) then
    begin
      if (DateTime = LastDateTime) then
      begin
     //   DeleteTempStation(Tempstation);
        qry.next;
        Result := false
      end
      else
      begin
        Result := true;
        break;
      end;
    end;
  end;
  qry.close;
  trs.Free;
  qry.Free;
end;
      }
end.



