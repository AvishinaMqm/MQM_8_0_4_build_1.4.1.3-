unit UMStoredProc;
interface

uses

UGLicensing, Windows, Forms,gnugettext,DMSrvPc,Classes, Tlhelp32;

type

//  TAccessType = (AT_write, AT_ptRead, AT_readAll, AT_update);
  TAccessType = (AT_Lock , AT_Read, AT_Write, AT_save, AT_Blank, AT_Closed);

  TMQMSTInParms = record
    REQ_NO   : string;
    STEP_ID  : smallint;
    WRK_CTR  : string;
    WC_PROC  : string;
    RESOURCE : string;
    RES_CAT  : string;
  end;
  PTMQMSTInParms = ^TMQMSTInParms;

  TMQMSTOutParms = record
    SETUP_TIME : double;
    EXEC_TIME : double;
  end;
  PTMQMSTOutParms = ^TMQMSTOutParms;

  procedure CreateViewForMain;
  procedure CreateStoredForMain;
  procedure CreateStoredForCfg;

  // for Mqm/mcm

  function LoadLicenceMCM(var errStr: string): boolean;
  function LoadLicenceMQM(var errStr: string): boolean;
  function CheckLicenceForMain(var errStr: string): boolean;


  // for MqmSrvLoad
  function LoadLicenceMCMSrv(var errStr: string): boolean;
  function LoadLicenceMQMSrv(var errStr: string): boolean;

  // for mqmconfig
  function LoadLicenceCfg(enterIndemo: boolean; var errStrMqm , errStrMcm : string): boolean;
  function SaveLicenceMcm(var arr: TLicMemory; var errStr: string): boolean;
  function SaveLicenceMqm(var arr: TLicMemory; var errStr: string): boolean;

  function SetLockToChainStrStructure(LockCode : Integer) : string;
  function GetLockFromChainStrStructure(ChainStr : string) : integer;

  // for mqm
  function LoadLicence(var errStr: string): boolean;
  function CheckLicence(var errStr: string): boolean;

  procedure SetCapResGenerator(NewValue: integer);
  procedure SetGrpNumGenerator(NewValue: integer);
  procedure SetUpdNumGenerator(NewValue: integer);

  procedure DropAllMainStoredProc;
  procedure DropAllCfgStoredProc;

  function  SP_GET_CAP_RES_NUM(Out CapResNum: Integer; GENCODENAME : string): boolean;
  function  CheckingActiveServers : boolean;
  function  CheckServerDoubleInstance : boolean;

  procedure SET_SRVLOAD_COUNTER_NUMBER(Number : Integer);
  function  SET_SRVLOAD_POLLING_NUMBER(PollNumber : Integer) : boolean;
  function  GET_SRVLOAD_POLLING_NUMBER : integer;


  function  GET_GRP_STARTING_NUMBER(NumberOfGrps: Integer; GENCODENAME : string): Integer;

  //  function  GET_GRP_MAX_NUM(Out GrpNum: Integer; GENCODENAME : string): boolean;
  //function  SET_GRP_MAX_NUM(GrpNum: Integer; GENCODENAME : string): boolean;

  function  SP_GET_GRP_NUM(Out GrpNum: Integer; GENCODENAME : string): boolean;
  function  GET_NEW_REQ_STARTING_NUMBER(NumberOfNewReq: Integer): Integer;
  function  SP_GET_NEW_REQ_NO(Out NewReqNum: Integer; GENCODENAME : string): boolean;
  function  SP_GET_SPLIT_FAMILY_CODE(Out NewSplitFamily : integer; GENCODENAME : string): boolean;

  function  SP_GET_ACCESS(Wrkst: string; at: TAccessType): boolean;
  procedure SP_END_ACCESS(Wrkst: string ; OperateEvent : boolean);
  procedure SP_CHANGE_ACCESS(Wrkst: string);
  procedure SP_SEND_UPDATE_CLIENT;
  procedure SP_SEND_JOB_MSG;
  procedure SP_SEND_TEST;
  procedure SP_SEND_SHARED_DATA;
  function  SP_CONNECT(Wrkst: string; var CurrDate : TDateTime): boolean;
  procedure SP_DISCONNECT(Wrkst: string);
  function  SP_IS_CLIENT_EXIST : boolean;
  function  SP_GET_STATUS(Wrkst: string; var srvLoadOn, canRead, canWrite: boolean): boolean;
  function  SP_ASK_POLL: boolean;
  function  SP_ASK_POLL_SERVER : boolean;
  function  SP_CHECK_POLL: boolean;
  function  SP_CHECK_POLL_DLT_OLD_STATIONS : boolean;
  function  SP_ASW_POLL(Wrkst: string): boolean;
  function  SP_CLIENT_UPDATE_DATA : boolean;
  function  SP_ACTIVE_WRKST(Wrkst: string): boolean;
  procedure SP_SRVLOAD_RUNNING;
  procedure SP_SRVLOAD_OFF;
  procedure SP_SRVLOAD_OPEN;
  procedure SP_SRVLOAD_CLOSE;
  procedure SP_SRVLOAD_END_ACCESS;
  function  SP_SRVLOAD_GET_STATUS_OPENED_OR_CLOSED : boolean;
  procedure Sp_Client_Request;
  procedure Sp_Client_Status_Update;

  procedure OPERATE_DOWNLOAD_REQUEST(STATION : string ; DOWNLOAD_TYPE : string);
  function  GET_ACCESS(Wrkst: string; at: TAccessType): boolean;

  function  IS_ACCESS_ALLOWED(Wrkst: string; at: TAccessType): boolean;
  function  IS_STATION_CLOSED(Wrkst: string): boolean;
  procedure UPDATE_ACCESS_OPERATION(Wrkst: string; at: TAccessType; Curr_DateTime : TDateTime);
  procedure CHECK_STATION_EXIST_AND_INSERT(Wrkst: string);
  function  EXIST_ACTIVE_STATIONS : boolean;

  procedure END_ACCESS(Wrkst: string);
  procedure CLOSE_STATION(Wrkst: string);
  function  IS_STATION_RESPONDING(station : string) : boolean;
  procedure RESET_STATION_RECORD(station : string);
  procedure REMOVE_UNACTIVATED_STATIONS;
  procedure SP_Reset_NEW_REQ_NO_Generator;
  procedure SP_Reset_SPLIT_FAMILY_CODE_Generator;
  procedure KillProcess(hWindowHandle: HWND);
  function KillTask(ExeFileName: string): Integer;
  procedure Killprocess2(Name:String);

//----------------------------------------------------------------------------//


const
  CcfgDbCodeMqm  = 1;
  CmainDbCodeMqm = 1;
  CcfgDbCodeMcm  = 2;
  CmainDbCodeMcm = 2;

  //Stored procedures Names

  CMainGetCapResNum = 'GET_CAP_RES_GEN_NUM';
  CMainGetGrpNum    = 'GET_GRP_GEN_NUM';
  CMainGetNewReqNo   = 'GET_NEW_REQ_GEN_NUM';
  CMainGetSplitFamily  = 'GET_SPLIT_FAMILY_GEN_NUM';
  CCfgGetAccess  = 'GET_ACCESS';
  CCfgEndAccess  = 'END_ACCESS';
  CCfgChangeAccess  = 'CHANGE_ACCESS';
  CCfgGetStatus  = 'GET_STATUS';
  CCfgIsExistClient = 'IS_EXIST_CLIENT';
  CCfgUpdateClient = 'UPDATE_CLIENTS';
  CCJobMsg         = 'JOB_MSG';
  CCSharedData   = 'SHARED_DATA';
  CCfgStillOn    = 'STILL_ON';
  CCfgConnect    = 'CONNECT';
  CCfgActWrcst   = 'ACTIVE_WRKST';
  CCfgDisconnect = 'DISCONNECT';
  CCfgAskPoll    = 'ASKPOLL';
  CCfgAskPollSRV = 'ASKPOLLSRV';
  CCfgChkPoll    = 'CHKPOLL';
  CCfgChkPollDelOldStation = 'CHKPOLLDELOLD';
  CSrvLoadTriger = 'SRVLOADTRIGER';
  CSrvLoadTrigerUpdateStatus = 'SRV_TRIGER_UPDATE_STATUS';
  CSrvLoadStatus = 'SRVLOADSETSTATUS';
  CSrvLoadSetStatusOpenedOrClosed = 'SRV_SET_OPENED_OR_CLOSED';
  CSrvLoadGetStatusOpenedOrClosed = 'SRV_GET_OPENED_OR_CLOSED';
  CSrvLoadGetAcc = 'SRVLOADGETACC';
  CSrvLoadEndAcc = 'SRVLOADENDACC';
  CSevCngDataBase = 'SRVCNGDATABASE';
  CSevCngDataBaseAndWarp = 'SRVCNGDATABASE_WARP';
  CSevCngDataBaseWarpOnly = 'SRVCNGDATABASE_WARP_ONLY';
  CCTEST         = 'TEST';
  CCLientRequest = 'ClientRequest';
  CCLientStatusUpdate = 'ClientStatusUpdate';

implementation

uses
  UMGlobal,
  UMCommon,
  Dialogs,
  SysUtils,
  UMDbFunc,
  UMTblDesc;

//----------------------------------------------------------------------------//

procedure DropAllStoredProc_Interbase(dbType: TMqmDBType);
var
  qry:    TMqmQuery;
  qryDel: TMqmQuery;
//  trs:    TMqmTransaction;
//  trsDel: TMqmTransaction;
begin
//  trs := CreateTransaction(dbType, false);
//  trsDel := CreateTransaction(dbType);
  qry := CreateQuery(dbType);
//  qry.ParamCheck := false;
//  qry.Transaction.StartTransaction;

  try
    qry.SQL.Clear;
    qry.SQL.Add('Drop Table Temp');
    qry.ExecSQL;
  except
  end;
//  qry.Transaction.Commit;

  qry.SQL.Clear;
  qry.SQL.ADD('CREATE TABLE "TEMP"("PROCEDURE_NAME" VARCHAR(100))');
  qry.ExecSQL;
//  qry.Transaction.Commit;

  qry.SQL.Clear;
  qry.SQL.Add('insert into temp select rdb$procedure_name from rdb$procedures');
  qry.ExecSQL;

//  qry.SQL.Add('select RDB$PROCEDURE_NAME from RDB$PROCEDURES');
  qry.SQL.Clear;
  qry.SQL.Add('select PROCEDURE_NAME from TEMP');
  qry.Open;

//  trsDel.StartTransaction;
  qryDel := CreateQuery(dbType);

  while not qry.EOF do
  begin
    qryDel.SQL.Clear;
    qryDel.SQL.Add('DROP PROCEDURE ' + qry.Fields[0].AsString);
    qryDel.ExecSQL;
    qry.Next
  end;

  try
    qry.SQL.Clear;
    qry.SQL.Add('Drop Table Temp');
    qry.ExecSQL;
  except
  end;

  qryDel.Close;   //Vinc
  qry.Close;      //Vinc

//  trs.Commit;
  qry.Connection.Commit;
  qryDel.Connection.Commit;
  qryDel.Free;
  qry.Free;
end;

//----------------------------------------------------------------------------//

procedure DropAllMainStoredProc;
begin
  if IniAppGlobals.DownloadTo = '2' then
    DropAllStoredProc_Interbase(Main_DB)
end;

//----------------------------------------------------------------------------//

procedure DropAllCfgStoredProc;
begin
  if IniAppGlobals.DownloadTo = '2' then
    DropAllStoredProc_Interbase(Cfg_DB)
end;

//----------------------------------------------------------------------------//

procedure CrtProcGetCapResNum;
var
  qry: TMqmQuery;
  StoredProcName : string;
  tbInfo, tbInfoCapRes: ^TTblInfo;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CMainGetCapResNum
  else
    StoredProcName := 'SCDM_' + CMainGetCapResNum;
  qry := CreateQuery(Main_DB);

  tbInfo := @tblInfo[tbl_GeneratorNumber];
  tbInfoCapRes := @tblInfo[tbl_capRes];
  SetFldPfx(tbInfo.pfx);

  qry.SQL.Add('DROP PROCEDURE ' + StoredProcName);
  try
    qry.ExecSql;
  except
  end;

  qry.connection.Commit;


  with qry do
  begin
  //  ParamCheck := false;
    Close;
    SQL.Clear;

    if IniAppGlobals.DownloadTo = '2' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add(' (GENCODENAME VARCHAR(12), IDENTIFIER INTEGER)');
      SQL.Add(' RETURNS (');
      SQL.Add(' CapResNum INTEGER');
      SQL.Add(')');
      SQL.Add(' AS ');
      SQL.Add('BEGIN ');
      SQL.Add(' CapResNum = 0;');
      SQL.Add(' SELECT count(*) FROM ' + tbInfo.GetTableName);
      SQL.Add(' WHERE ' + CreatePfxFld(fli_GeneratorCode) + ' = :GENCODENAME');
      SQL.Add(' and '+CreatePfxFld(fli_IDENTIFIER)+' = :IDENTIFIER into :CapResNum;');
      SQL.Add(' if (CapResNum = 0) then');
      SQL.Add(' begin');
      SQL.Add('   SELECT count(*) FROM ' + tbInfoCapRes.GetTableName + ' where CR_IDENTIFIER = :IDENTIFIER into :CapResNum;');
      SQL.Add('   if (CapResNum > 0) then');
      SQL.Add('     SELECT max(CR_CAPACTY_RESRV) FROM ' + tbInfoCapRes.GetTableName + ' where CR_IDENTIFIER = :IDENTIFIER into :CapResNum;');
      SQL.Add('   CapResNum = CapResNum + 1;');
      SQL.Add('   insert into ' + tbInfo.GetTableName + ' (GN_GENCODE , GN_GENNUMBER, GN_IDENTIFIER)');
      SQL.Add('   values (:GENCODENAME,:CapResNum,:IDENTIFIER);');
      SQL.Add(' end');
      SQL.Add(' else');
      SQL.Add(' begin');
      SQL.Add('   SELECT GN_GENNUMBER FROM ' + tbInfo.GetTableName);
      SQL.Add('   WHERE ' + CreatePfxFld(fli_GeneratorCode) + ' = :GENCODENAME');
      SQL.Add('   and '+CreatePfxFld(fli_IDENTIFIER)+' = :IDENTIFIER into :CapResNum;');
      SQL.Add('   CapResNum = CapResNum + 1;');
      SQL.Add('   update ' + tbInfo.GetTableName + ' set GN_GENNUMBER = :CapResNum WHERE ' + CreatePfxFld(fli_GeneratorCode) + ' = :GENCODENAME and '+CreatePfxFld(fli_IDENTIFIER)+' = :IDENTIFIER;');
      SQL.Add(' end');
      SQL.Add('END');
    end
    else if IniAppGlobals.DownloadTo = '0' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add(' (IN GENCODENAME VARCHAR(12) ,IN IDENTIFIER INTEGER, ');
      SQL.Add(' OUT ');
      SQL.Add(' CapResNum INTEGER');
      SQL.Add(')');
      SQL.Add(' LANGUAGE SQL ');
      SQL.Add(' BEGIN ');
      SQL.Add(' Set CapResNum = 0;');
      SQL.Add(' SELECT count(1) into CapResNum FROM ' + tbInfo.GetTableName);
      SQL.Add(' WHERE ' + CreatePfxFld(fli_GeneratorCode) + ' = GENCODENAME');
      SQL.Add(' and '+CreatePfxFld(fli_IDENTIFIER)+' = IDENTIFIER;');
      SQL.Add(' if (CapResNum = 0) then');
      SQL.Add(' begin');
      SQL.Add('   SELECT count(1) into CapResNum FROM ' + tbInfoCapRes.GetTableName +' where CR_IDENTIFIER = IDENTIFIER;');
      SQL.Add('   if (CapResNum > 0) then');
      SQL.Add('      SELECT max(CR_CAPACTY_RESRV) into CapResNum FROM ' + tbInfoCapRes.GetTableName + ' where CR_IDENTIFIER = IDENTIFIER;');
      SQL.Add('   end if;');
      SQL.Add('   SET CapResNum = CapResNum + 1;');
      SQL.Add('   insert into ' + tbInfo.GetTableName + ' (GN_GENCODE , GN_GENNUMBER, GN_IDENTIFIER)');
      SQL.Add('   values (GENCODENAME,CapResNum, IDENTIFIER);');
      SQL.Add(' end;');
      SQL.Add(' else');
      SQL.Add(' begin');
      SQL.Add('   SELECT GN_GENNUMBER into CapResNum FROM ' + tbInfo.GetTableName);
      SQL.Add('   WHERE ' + CreatePfxFld(fli_GeneratorCode) + ' = GENCODENAME');
      SQL.Add(' and '+CreatePfxFld(fli_IDENTIFIER)+' = IDENTIFIER;');
      SQL.Add('   Set CapResNum = CapResNum + 1;');
      SQL.Add('   update ' + tbInfo.GetTableName + ' set GN_GENNUMBER = CapResNum WHERE ' + CreatePfxFld(fli_GeneratorCode) + ' = GENCODENAME and '+CreatePfxFld(fli_IDENTIFIER)+' = IDENTIFIER;');
      SQL.Add(' end;');
      SQL.Add(' end if;');
      SQL.Add('END');
    end
    else if IniAppGlobals.DownloadTo = '1' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
    //  SQL.Add(' (GENCODENAME IN VARCHAR(12) ,');
      SQL.Add(' (GENCODENAME IN VARCHAR , IDENTIFIER IN INTEGER,');
      SQL.Add(' CapResNum OUT INTEGER');
      SQL.Add(')');
      SQL.Add(' AS ');
      SQL.Add(' BEGIN ');
      SQL.Add(' CapResNum := 0;');
      SQL.Add(' SELECT count(1) into CapResNum FROM ' + tbInfo.GetTableName);
      SQL.Add(' WHERE ' + CreatePfxFld(fli_GeneratorCode) + ' = GENCODENAME');
      SQL.Add(' and '+CreatePfxFld(fli_IDENTIFIER)+' = IDENTIFIER;');
      SQL.Add(' if (CapResNum = 0) then');
      SQL.Add(' begin');
      SQL.Add('   SELECT count(1) into CapResNum FROM ' + tbInfoCapRes.GetTableName +' where CR_IDENTIFIER = IDENTIFIER;');
      SQL.Add('   if (CapResNum > 0) then');
      SQL.Add('      SELECT max(CR_CAPACTY_RESRV) into CapResNum FROM ' + tbInfoCapRes.GetTableName + ' where CR_IDENTIFIER = IDENTIFIER;');
      SQL.Add('   end if;');
      SQL.Add('   CapResNum := CapResNum + 1;');
      SQL.Add('   insert into ' + tbInfo.GetTableName + ' (GN_GENCODE , GN_GENNUMBER, GN_IDENTIFIER)');
      SQL.Add('   values (GENCODENAME,CapResNum,IDENTIFIER);');
      SQL.Add(' end;');
      SQL.Add(' else');
      SQL.Add(' begin');
      SQL.Add('   SELECT GN_GENNUMBER into CapResNum FROM ' + tbInfo.GetTableName);
      SQL.Add('   WHERE ' + CreatePfxFld(fli_GeneratorCode) + ' = GENCODENAME');
      SQL.Add(' and '+CreatePfxFld(fli_IDENTIFIER)+' = IDENTIFIER;');
      SQL.Add('   CapResNum := CapResNum + 1;');
      SQL.Add('   update ' + tbInfo.GetTableName + ' set GN_GENNUMBER = CapResNum WHERE ' + CreatePfxFld(fli_GeneratorCode) + ' = GENCODENAME and '+CreatePfxFld(fli_IDENTIFIER)+' = IDENTIFIER;');
      SQL.Add(' end;');
      SQL.Add(' end if;');
      SQL.Add('END;');
    end;

    prepare;
    ExecSql;
    Close;
    SQL.Clear;

  end;

  qry.connection.Commit;
  qry.Free;

end;

//----------------------------------------------------------------------------//

function SP_GET_CAP_RES_NUM(Out CapResNum: Integer; GENCODENAME : string): boolean;
var
  StoredProc: TMqmStoredProc;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CMainGetCapResNum
  else
    StoredProcName := 'SCDM_' + CMainGetCapResNum;

  Result := true;
  StoredProc := CreateStoredProc(Main_DB);
  StoredProc.StoredProcName := StoredProcName;

  try
    with StoredProc do
    begin
      Prepare;
      ParamByName('GENCODENAME').AsString := GENCODENAME;
      ParamByName('IDENTIFIER').Value := IniAppGlobals.Identifier;
      ExecProc;
      CapResNum := ParamByName('CapResNum').AsInteger;
      unprepare;
    end;
  except
    Result := false;
  end;

  StoredProc.Free;
end;

//----------------------------------------------------------------------------//

procedure SetCapResGenerator(NewValue: integer);
var
  qry:     TMqmQuery;
//  trs:        TMqmTransaction;
begin
//  trs := CreateTransaction(Main_DB, false);
  qry := CreateQuery(Main_DB);

  qry.Transaction.StartTransaction;


  with qry do
  begin
    Close;
    SQL.Clear;

    SQL.Add('SET GENERATOR CAP_RES_GEN TO ' + IntToStr(NewValue));

    prepare;
    ExecSql;
    Close;
    SQL.Clear;

  end;
//  trs.Commit;
  qry.Free;       //Vinc
//  trs.Free;

end;

//----------------------------------------------------------------------------//

procedure CrtProcGetGrpNum;
var
  qry: TMqmQuery;
  StoredProcName : string;
  tbInfo, tbInfoProdSched: ^TTblInfo;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CMainGetGrpNum
  else
    StoredProcName := 'SCDM_' + CMainGetGrpNum;
  qry := CreateQuery(Main_DB);

  tbInfo := @tblInfo[tbl_GeneratorNumber];
  tbInfoProdSched := @tblInfo[tbl_prod_sched];
  SetFldPfx(tbInfo.pfx);

  qry.SQL.Add('DROP PROCEDURE ' + StoredProcName);
  try
    qry.ExecSql;
  except
  end;

  qry.connection.Commit;


  with qry do
  begin
  //  ParamCheck := false;
    Close;
    SQL.Clear;
    if IniAppGlobals.DownloadTo = '2' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add(' (GENCODENAME VARCHAR(12), IDENTIFIER INTEGER)');
      SQL.Add(' RETURNS (');
      SQL.Add(' GrpNum INTEGER');
      SQL.Add(')');
      SQL.Add(' AS ');
      SQL.Add('BEGIN ');
      SQL.Add(' GrpNum = 0;');
      SQL.Add(' SELECT count(*) FROM ' + tbInfo.GetTableName);
      SQL.Add(' WHERE ' + CreatePfxFld(fli_GeneratorCode) + ' = :GENCODENAME');
      SQL.Add(' and ' + CreatePfxFld(fli_IDENTIFIER) + ' = :IDENTIFIER into :GrpNum;');
      SQL.Add(' if (GrpNum = 0) then');
      SQL.Add(' begin');
      SQL.Add('   SELECT count(*) FROM ' + tbInfoProdSched.GetTableName + ' where PS_IDENTIFIER = :IDENTIFIER into :GrpNum;');
      SQL.Add('   if (GrpNum > 0) then');
      SQL.Add('     SELECT max(PS_ST_GROUP) FROM ' + tbInfoProdSched.GetTableName + ' where PS_IDENTIFIER = :IDENTIFIER into :GrpNum;');
      SQL.Add('   GrpNum = GrpNum + 1;');
      SQL.Add('   insert into ' + tbInfo.GetTableName + ' (GN_GENCODE , GN_GENNUMBER, GN_IDENTIFIER)');
      SQL.Add('   values (:GENCODENAME,:GrpNum,:IDENTIFIER);');
      SQL.Add(' end');
      SQL.Add(' else');
      SQL.Add(' begin');
      SQL.Add('   SELECT GN_GENNUMBER FROM ' + tbInfo.GetTableName);
      SQL.Add('   WHERE ' + CreatePfxFld(fli_GeneratorCode) + ' = :GENCODENAME');
      SQL.Add(' and ' + CreatePfxFld(fli_IDENTIFIER) + ' = :IDENTIFIER into :GrpNum;');
      SQL.Add('   GrpNum = GrpNum + 1;');
      SQL.Add('   update ' + tbInfo.GetTableName + ' set GN_GENNUMBER = :GrpNum WHERE ' + CreatePfxFld(fli_GeneratorCode) + ' = :GENCODENAME and ' + CreatePfxFld(fli_IDENTIFIER) + ' = :IDENTIFIER;');
      SQL.Add(' end');
      SQL.Add('END');
    end
    else if IniAppGlobals.DownloadTo = '0' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add(' (IN GENCODENAME VARCHAR(12) , IN IDENTIFIER INTEGER,');
      SQL.Add(' OUT ');
      SQL.Add(' GrpNum INTEGER');
      SQL.Add(')');
      SQL.Add(' LANGUAGE SQL ');
      SQL.Add(' BEGIN ');
      SQL.Add(' Set GrpNum = 0;');
      SQL.Add(' SELECT count(1) into GrpNum FROM ' + tbInfo.GetTableName);
      SQL.Add(' WHERE ' + CreatePfxFld(fli_GeneratorCode) + ' = GENCODENAME');
      SQL.Add(' and ' + CreatePfxFld(fli_IDENTIFIER) + ' = IDENTIFIER;');
      SQL.Add(' if (GrpNum = 0) then');
      SQL.Add(' begin');
      SQL.Add('   SELECT count(1) into GrpNum FROM ' + tbInfoProdSched.GetTableName +' where PS_IDENTIFIER = IDENTIFIER;');
      SQL.Add('   if (GrpNum > 0) then');
      SQL.Add('     SELECT max(PS_ST_GROUP) into GrpNum FROM ' + tbInfoProdSched.GetTableName + ' where PS_IDENTIFIER = IDENTIFIER;');
      SQL.Add('   end if;');
      SQL.Add('   SET GrpNum = GrpNum + 1;');
      SQL.Add('   insert into ' + tbInfo.GetTableName + ' (GN_GENCODE , GN_GENNUMBER, GN_IDENTIFIER)');
      SQL.Add('   values (GENCODENAME,GrpNum,IDENTIFIER);');
      SQL.Add(' end;');
      SQL.Add(' else');
      SQL.Add(' begin');
      SQL.Add('   SELECT GN_GENNUMBER into GrpNum FROM ' + tbInfo.GetTableName);
      SQL.Add('   WHERE ' + CreatePfxFld(fli_GeneratorCode) + ' = GENCODENAME');
      SQL.Add(' and ' + CreatePfxFld(fli_IDENTIFIER) + ' = IDENTIFIER;');
      SQL.Add('   Set GrpNum = GrpNum + 1;');
      SQL.Add('   update ' + tbInfo.GetTableName + ' set GN_GENNUMBER = GrpNum WHERE ' + CreatePfxFld(fli_GeneratorCode) + ' = GENCODENAME and ' + CreatePfxFld(fli_IDENTIFIER) + ' = IDENTIFIER;');
      SQL.Add(' end;');
      SQL.Add(' end if;');
      SQL.Add('END');
    end
    else if IniAppGlobals.DownloadTo = '1' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
    //  SQL.Add(' (GENCODENAME IN VARCHAR(12) ,');
      SQL.Add(' (GENCODENAME IN VARCHAR, IDENTIFIER IN INTEGER,');
      SQL.Add(' GrpNum OUT INTEGER');
      SQL.Add(')');
      SQL.Add(' AS ');
      SQL.Add(' BEGIN ');
      SQL.Add(' GrpNum := 0;');
      SQL.Add(' SELECT count(1) into GrpNum FROM ' + tbInfo.GetTableName);
      SQL.Add(' WHERE ' + CreatePfxFld(fli_GeneratorCode) + ' = GENCODENAME');
      SQL.Add(' and ' + CreatePfxFld(fli_IDENTIFIER) + ' = IDENTIFIER;');
      SQL.Add(' if (GrpNum = 0) then');
      SQL.Add(' begin');
      SQL.Add('   SELECT count(1) into GrpNum FROM ' + tbInfoProdSched.GetTableName +' where PS_IDENTIFIER = IDENTIFIER;');
      SQL.Add('   if (GrpNum > 0) then');
      SQL.Add('     SELECT max(PS_ST_GROUP) into GrpNum FROM ' + tbInfoProdSched.GetTableName + ' where PS_IDENTIFIER = IDENTIFIER;');
      SQL.Add('   end if;');
      SQL.Add('   GrpNum := GrpNum + 1;');
      SQL.Add('   insert into ' + tbInfo.GetTableName + ' (GN_GENCODE , GN_GENNUMBER, GN_IDENTIFIER)');
      SQL.Add('   values (GENCODENAME,GrpNum, IDENTIFIER);');
      SQL.Add(' end;');
      SQL.Add(' else');
      SQL.Add(' begin');
      SQL.Add('   SELECT GN_GENNUMBER into GrpNum FROM ' + tbInfo.GetTableName);
      SQL.Add('   WHERE ' + CreatePfxFld(fli_GeneratorCode) + ' = GENCODENAME');
      SQL.Add(' and ' + CreatePfxFld(fli_IDENTIFIER) + ' = IDENTIFIER;');
    //  SQL.Add('   Set GrpNum := GrpNum + 1;');
      SQL.Add('   GrpNum := GrpNum + 1;');
      SQL.Add('   update ' + tbInfo.GetTableName + ' set GN_GENNUMBER = GrpNum WHERE ' + CreatePfxFld(fli_GeneratorCode) + ' = GENCODENAME and ' + CreatePfxFld(fli_IDENTIFIER) + ' = IDENTIFIER;');
      SQL.Add(' end;');
      SQL.Add(' end if;');
      SQL.Add('END;');
    end;


    prepare;
    ExecSql;
    Close;
    SQL.Clear;

  end;

  qry.connection.Commit;
  qry.Free;

end;

//----------------------------------------------------------------------------//

procedure CrtProcGetNewReqNomber;
var
  qry: TMqmQuery;
  StoredProcName : string;
  tbInfo, tbInfoProdSched: ^TTblInfo;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CMainGetNewReqNo
  else
    StoredProcName := 'SCDM_' + CMainGetNewReqNo;
  qry := CreateQuery(Main_DB);

  tbInfo := @tblInfo[tbl_GeneratorNumber];
  tbInfoProdSched := @tblInfo[tbl_prod_sched];
  SetFldPfx(tbInfo.pfx);

  qry.SQL.Add('DROP PROCEDURE ' + StoredProcName);
  try
    qry.ExecSql;
  except
  end;

  qry.connection.Commit;


  with qry do
  begin
  //  ParamCheck := false;
    Close;
    SQL.Clear;

    if IniAppGlobals.DownloadTo = '2' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add(' (GENCODENAME VARCHAR(12), IDENTIFIER INTEGER)');
      SQL.Add(' RETURNS (');
      SQL.Add(' NewReqNum INTEGER');
      SQL.Add(')');
      SQL.Add(' AS ');
      SQL.Add(' DECLARE VARIABLE NewReqStr VARCHAR (1);');

      SQL.Add(' BEGIN ');
      SQL.Add(' NewReqNum = 0;');
      SQL.Add(' SELECT count(*) FROM ' + tbInfo.GetTableName);
      SQL.Add(' WHERE ' + CreatePfxFld(fli_GeneratorCode) + ' = :GENCODENAME');
      SQL.Add(' and ' + CreatePfxFld(fli_IDENTIFIER) + ' = :IDENTIFIER into :NewReqNum;');
      SQL.Add(' if (NewReqNum = 0) then');
      SQL.Add(' begin');
      SQL.Add('   SELECT max(PS_NEW_PREQ_UNIQ_ID) FROM ' + tbInfoProdSched.GetTableName + ' where PS_IDENTIFIER = :IDENTIFIER into :NewReqStr;');
      SQL.Add('   if (NewReqStr = ' + QuotedStr('') + ') then ');
      SQL.Add('     NewReqNum = 0;');
      SQL.Add('   else');
      SQL.Add('     NewReqNum = cast(NewReqStr as Integer);');
      SQL.Add('   NewReqNum = NewReqNum + 1;');
      SQL.Add('   insert into ' + tbInfo.GetTableName + ' (GN_GENCODE , GN_GENNUMBER, GN_IDENTIFIER)');
      SQL.Add('   values (:GENCODENAME,:NewReqNum,:IDENTIFIER);');
      SQL.Add(' end');
      SQL.Add(' else');
      SQL.Add(' begin');
      SQL.Add('   SELECT GN_GENNUMBER FROM ' + tbInfo.GetTableName);
      SQL.Add('   WHERE ' + CreatePfxFld(fli_GeneratorCode) + ' = :GENCODENAME');
      SQL.Add(' and ' + CreatePfxFld(fli_IDENTIFIER) + ' = :IDENTIFIER into :NewReqNum;');
      SQL.Add('   NewReqNum = NewReqNum + 1;');
      SQL.Add('   update ' + tbInfo.GetTableName + ' set GN_GENNUMBER = :NewReqNum WHERE ' + CreatePfxFld(fli_GeneratorCode) + ' = :GENCODENAME and ' + CreatePfxFld(fli_IDENTIFIER) + ' = :IDENTIFIER;');
      SQL.Add(' end ');
      SQL.Add(' END');
    end
    else if IniAppGlobals.DownloadTo = '0' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add(' (IN GENCODENAME VARCHAR(12) , IN IDENTIFIER INTEGER,');
      SQL.Add(' OUT ');
      SQL.Add(' NewReqNum INTEGER');
      SQL.Add(')');
      SQL.Add(' LANGUAGE SQL ');
      SQL.Add(' BEGIN ');
      SQL.Add(' Set NewReqNum = 0;');
      SQL.Add(' SELECT count(1) into NewReqNum FROM ' + tbInfo.GetTableName);
      SQL.Add(' WHERE ' + CreatePfxFld(fli_GeneratorCode) + ' = GENCODENAME');
      SQL.Add(' and ' + CreatePfxFld(fli_IDENTIFIER) + ' = IDENTIFIER;');
      SQL.Add(' if (NewReqNum = 0) then');
      SQL.Add(' begin');
      SQL.Add('   SELECT count(1) into NewReqNum FROM ' + tbInfoProdSched.GetTableName +' where PS_IDENTIFIER = IDENTIFIER;');
      SQL.Add('   if (NewReqNum > 0) then');
    //  SQL.Add('      SELECT nvl(max(PS_NEW_PREQ_UNIQ_ID),0) into NewReqNum FROM ' + tbInfoProdSched.GetTableName + ' where PS_IDENTIFIER = IDENTIFIER;');
      SQL.Add('     select CASE WHEN PS_NEW_PREQ_UNIQ_ID = '+QuotedStr('')+' THEN 0 ELSE max(PS_NEW_PREQ_UNIQ_ID) end into NewReqNum FROM ' + tbInfoProdSched.GetTableName + ' where PS_IDENTIFIER = IDENTIFIER GROUP BY PS_NEW_PREQ_UNIQ_ID;');
      SQL.Add('   end if;');
      SQL.Add('   SET NewReqNum = NewReqNum + 1;');
      SQL.Add('   insert into ' + tbInfo.GetTableName + ' (GN_GENCODE , GN_GENNUMBER, GN_IDENTIFIER)');
      SQL.Add('   values (GENCODENAME,NewReqNum,IDENTIFIER);');
      SQL.Add(' end; ');
      SQL.Add(' else ');
      SQL.Add(' begin ');
      SQL.Add('   SELECT GN_GENNUMBER into NewReqNum FROM ' + tbInfo.GetTableName);
      SQL.Add('   WHERE ' + CreatePfxFld(fli_GeneratorCode) + ' = GENCODENAME');
      SQL.Add(' and ' + CreatePfxFld(fli_IDENTIFIER) + ' = IDENTIFIER;');
      SQL.Add('   Set NewReqNum = NewReqNum + 1;');
      SQL.Add('   update ' + tbInfo.GetTableName + ' set GN_GENNUMBER = NewReqNum WHERE ' + CreatePfxFld(fli_GeneratorCode) + ' = GENCODENAME and ' + CreatePfxFld(fli_IDENTIFIER) + ' = IDENTIFIER;');
      SQL.Add(' end;');
      SQL.Add(' end if ;');
      SQL.Add(' END');
    end
    else if IniAppGlobals.DownloadTo = '1' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
    //  SQL.Add(' (GENCODENAME IN VARCHAR(12) ,');
      SQL.Add(' (GENCODENAME IN VARCHAR , IDENTIFIER IN INTEGER');
      SQL.Add(' ,NewReqNum OUT INTEGER');
      SQL.Add(')');
      SQL.Add(' AS ');
      SQL.Add(' BEGIN ');
      SQL.Add(' NewReqNum := 0;');
      SQL.Add(' SELECT count(1) into NewReqNum FROM ' + tbInfo.GetTableName);
      SQL.Add(' WHERE ' + CreatePfxFld(fli_GeneratorCode) + ' = GENCODENAME');
      SQL.Add(' and ' + CreatePfxFld(fli_IDENTIFIER) + ' = IDENTIFIER;');
      SQL.Add(' if (NewReqNum = 0) then');
      SQL.Add(' begin');
      SQL.Add('   SELECT count(1) into NewReqNum FROM ' + tbInfoProdSched.GetTableName +' where PS_IDENTIFIER = IDENTIFIER;');
      SQL.Add('   if (NewReqNum > 0) then');
      SQL.Add('     SELECT decode(max(RTRIM(PS_NEW_PREQ_UNIQ_ID)), '+QuotedStr('')+ ',0,NULL,0,max(PS_NEW_PREQ_UNIQ_ID)) into NewReqNum FROM ' + tbInfoProdSched.GetTableName + ' where PS_IDENTIFIER = IDENTIFIER;');
     // SQL.Add('      SELECT nvl(max(PS_NEW_PREQ_UNIQ_ID),0) into NewReqNum FROM ' + tbInfoProdSched.GetTableName + ' where PS_IDENTIFIER = IDENTIFIER;');
      SQL.Add('   end if;');
      SQL.Add('   NewReqNum := NewReqNum + 1;');
      SQL.Add('   insert into ' + tbInfo.GetTableName + ' (GN_GENCODE , GN_GENNUMBER, GN_IDENTIFIER)');
      SQL.Add('   values (GENCODENAME, nvl(NewReqNum,0), IDENTIFIER);');
      SQL.Add(' end;');
      SQL.Add(' else');
      SQL.Add(' begin');
      SQL.Add('   SELECT GN_GENNUMBER into NewReqNum FROM ' + tbInfo.GetTableName);
      SQL.Add('   WHERE ' + CreatePfxFld(fli_GeneratorCode) + ' = GENCODENAME');
      SQL.Add(' and ' + CreatePfxFld(fli_IDENTIFIER) + ' = IDENTIFIER;');
   //   SQL.Add('   Set NewReqNum = NewReqNum + 1;');
      SQL.Add('   NewReqNum := NewReqNum + 1;');
      SQL.Add('   update ' + tbInfo.GetTableName + ' set GN_GENNUMBER = NewReqNum WHERE ' + CreatePfxFld(fli_GeneratorCode) + ' = GENCODENAME and ' + CreatePfxFld(fli_IDENTIFIER) + ' = IDENTIFIER;');
      SQL.Add(' end;');
      SQL.Add(' end if ;');
      SQL.Add(' END;');
    end;


    prepare;
    ExecSql;
    Close;
    SQL.Clear;

  end;

  qry.connection.Commit;
  qry.Free;

end;

{procedure CrtProcGetNewReqNomber;
var
  qry: TMqmQuery;
begin
  qry := CreateQuery(Main_DB);

  qry.SQL.Add('DROP PROCEDURE ' + CMainGetNewReqNo);
  try
    qry.ExecSql;
  except
  end;

  qry.connection.Commit;

  with qry do
  begin
   // ParamCheck := false;
    Close;
    SQL.Clear;

    SQL.Add('CREATE PROCEDURE ' + CMainGetNewReqNo);
    SQL.Add(' RETURNS (');
  //Out Parameters
    SQL.Add('NewReqNum FLOAT');

    SQL.Add(')');
    SQL.Add('AS');
    SQL.Add('BEGIN');

    SQL.Add('NewReqNum = GEN_ID (NEW_REQ_NO, 1);');

    SQL.Add('END');

    prepare;
    ExecSql;
    Close;
    SQL.Clear;

  end;
  qry.connection.Commit;
  qry.Free;

end;  }

//----------------------------------------------------------------------------//

procedure CrtProcGetSplitFamilyCode;
var
  qry: TMqmQuery;
  StoredProcName : string;
  tbInfo : ^TTblInfo;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CMainGetSplitFamily
  else
    StoredProcName := 'SCDM_' + CMainGetSplitFamily;
  qry := CreateQuery(Main_DB);

  tbInfo := @tblInfo[tbl_GeneratorNumber];

  SetFldPfx(tbInfo.pfx);

  qry.SQL.Add('DROP PROCEDURE ' + StoredProcName);
  try
    qry.ExecSql;
  except
  end;

  qry.connection.Commit;


  with qry do
  begin

    Close;
    SQL.Clear;

    if IniAppGlobals.DownloadTo = '2' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add(' (GENCODENAME VARCHAR(12), IDENTIFIER INTEGER)');
      SQL.Add(' RETURNS (');
      SQL.Add(' SplitNum INTEGER');
      SQL.Add(')');
      SQL.Add(' AS ');
      SQL.Add('BEGIN ');
      SQL.Add(' SplitNum = 0;');
      SQL.Add(' SELECT count(*) FROM ' + tbInfo.GetTableName);
      SQL.Add(' WHERE ' + CreatePfxFld(fli_GeneratorCode) + ' = :GENCODENAME');
      SQL.Add(' and ' + CreatePfxFld(fli_IDENTIFIER) + ' = :IDENTIFIER into :SplitNum;');
      SQL.Add(' if (SplitNum = 0) then');
      SQL.Add(' begin');
      SQL.Add('   SplitNum = SplitNum + 1;');
      SQL.Add('   insert into ' + tbInfo.GetTableName + ' (GN_GENCODE , GN_GENNUMBER, GN_IDENTIFIER)');
      SQL.Add('   values (:GENCODENAME,:SplitNum, :IDENTIFIER);');
      SQL.Add(' end');
      SQL.Add(' else');
      SQL.Add(' begin');
      SQL.Add('   SELECT GN_GENNUMBER FROM ' + tbInfo.GetTableName + ' where ' + CreatePfxFld(fli_IDENTIFIER) + ' = :IDENTIFIER');
      SQL.Add('   and ' + CreatePfxFld(fli_GeneratorCode) + ' = :GENCODENAME into :SplitNum;');
      SQL.Add('   SplitNum = SplitNum + 1;');
      SQL.Add('   update ' + tbInfo.GetTableName + ' set GN_GENNUMBER = :SplitNum WHERE ' + CreatePfxFld(fli_GeneratorCode) + ' = :GENCODENAME and ' + CreatePfxFld(fli_IDENTIFIER) + ' = :IDENTIFIER;');
      SQL.Add(' end');
      SQL.Add('END');
    end
    else if IniAppGlobals.DownloadTo = '0' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add(' (IN GENCODENAME VARCHAR(12) , IN IDENTIFIER INTEGER,');
      SQL.Add(' OUT ');
      SQL.Add(' SplitNum INTEGER');
      SQL.Add(')');
      SQL.Add(' LANGUAGE SQL ');
      SQL.Add(' BEGIN ');
      SQL.Add(' Set SplitNum = 0;');
      SQL.Add(' SELECT count(1) into SplitNum FROM ' + tbInfo.GetTableName);
      SQL.Add(' WHERE ' + CreatePfxFld(fli_GeneratorCode) + ' = GENCODENAME');
      SQL.Add(' and ' + CreatePfxFld(fli_IDENTIFIER) + ' = IDENTIFIER;');
      SQL.Add(' if (SplitNum = 0) then');
      SQL.Add(' begin');
      SQL.Add('   SET SplitNum = SplitNum + 1;');
      SQL.Add('   insert into ' + tbInfo.GetTableName + ' (GN_GENCODE , GN_GENNUMBER, GN_IDENTIFIER)');
      SQL.Add('   values (GENCODENAME,SplitNum, IDENTIFIER);');
      SQL.Add(' end;');
      SQL.Add(' else');
      SQL.Add(' begin');
      SQL.Add('   SELECT GN_GENNUMBER into SplitNum FROM ' + tbInfo.GetTableName + ' where ' + CreatePfxFld(fli_IDENTIFIER) + ' = IDENTIFIER');
      SQL.Add('   and ' + CreatePfxFld(fli_GeneratorCode) + ' = GENCODENAME;');
      SQL.Add('   Set SplitNum = SplitNum + 1;');
      SQL.Add('   update ' + tbInfo.GetTableName + ' set GN_GENNUMBER = SplitNum WHERE ' + CreatePfxFld(fli_GeneratorCode) + ' = GENCODENAME and ' + CreatePfxFld(fli_IDENTIFIER) + ' = IDENTIFIER;');
      SQL.Add(' end;');
      SQL.Add(' end if;');
      SQL.Add('END');
    end
    else if IniAppGlobals.DownloadTo = '1' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
   //   SQL.Add(' (GENCODENAME IN VARCHAR(12) ,');
      SQL.Add(' (GENCODENAME IN VARCHAR , IDENTIFIER IN INTEGER,');
      SQL.Add(' SplitNum OUT INTEGER');
      SQL.Add(')');
      SQL.Add(' AS ');
      SQL.Add(' BEGIN ');
      SQL.Add(' SplitNum := 0;');
      SQL.Add(' SELECT count(1) into SplitNum FROM ' + tbInfo.GetTableName);
      SQL.Add(' WHERE ' + CreatePfxFld(fli_GeneratorCode) + ' = GENCODENAME');
      SQL.Add(' and ' + CreatePfxFld(fli_IDENTIFIER) + ' = IDENTIFIER;');
      SQL.Add(' if (SplitNum = 0) then');
      SQL.Add(' begin');
      SQL.Add('   SplitNum := SplitNum + 1;');
      SQL.Add('   insert into ' + tbInfo.GetTableName + ' (GN_GENCODE , GN_GENNUMBER, GN_IDENTIFIER)');
      SQL.Add('   values (GENCODENAME,SplitNum,IDENTIFIER);');
      SQL.Add(' end;');
      SQL.Add(' else');
      SQL.Add(' begin');
      SQL.Add('   SELECT GN_GENNUMBER into SplitNum FROM ' + tbInfo.GetTableName + ' where ' + CreatePfxFld(fli_IDENTIFIER) + ' = IDENTIFIER');
      SQL.Add('   and ' + CreatePfxFld(fli_GeneratorCode) + ' = GENCODENAME;');
      SQL.Add('   SplitNum := SplitNum + 1;');
      SQL.Add('   update ' + tbInfo.GetTableName + ' set GN_GENNUMBER = SplitNum WHERE ' + CreatePfxFld(fli_GeneratorCode) + ' = GENCODENAME and ' + CreatePfxFld(fli_IDENTIFIER) + ' = IDENTIFIER;');
      SQL.Add(' end;');
      SQL.Add(' end if;');
      SQL.Add('END;');
    end;

    prepare;
    ExecSql;
    Close;
    SQL.Clear;

  end;

  qry.connection.Commit;
  qry.Free;

end;

{procedure CrtProcGetSplitFamilyCode;
var
  qry: TMqmQuery;
//  trs: TMqmTransaction;
begin
//  trs := CreateTransaction(Main_DB, false);
  qry := CreateQuery(Main_DB);

  //qry.Transaction.StartTransaction;

  qry.SQL.Add('DROP PROCEDURE ' + CMainGetSplitFamily);
  try
    qry.ExecSql;
  except
  end;

  qry.connection.Commit;

//  trs.StartTransaction;

  with qry do
  begin
  //  ParamCheck := false;
    Close;
    SQL.Clear;

    SQL.Add('CREATE PROCEDURE ' + CMainGetSplitFamily);
    SQL.Add(' RETURNS (');
  //Out Parameters
    SQL.Add('NewSplitFamily FLOAT');

    SQL.Add(')');
    SQL.Add('AS');
    SQL.Add('BEGIN');

    SQL.Add('NewSplitFamily = GEN_ID (NEW_REQ_NO, 1);');

    SQL.Add('END');

    prepare;
    ExecSql;
    Close;
    SQL.Clear;

  end;
  qry.connection.Commit;
  qry.Free;
//  trs.Free;
end;             }


function CheckingActiveServers : boolean;
var
  qry, qryCfg:       TMqmQuery;
  tbGN, tbExchg_wkst      : ^TTblInfo;
  RunningNumber , SchedGrpNum, MyCounterNum : integer;
begin
  Result := true;

  tbGN := @tblInfo[tbl_GeneratorNumber];

  qry := CreateQuery(Main_DB);
  qry.Transaction := CreateTransaction(Main_DB);
  qry.Transaction.StartTransaction;

  with qry do
  begin
    SQL.Clear;
    sql.add(' SELECT GN_GENNUMBER SrvNum from ' + tbGN.GetTableName);
    SQL.Add(' where ' + CreateFld(tbGN.pfx,fli_GeneratorCode) + '=''' + 'SERVER' + '''');
    SQL.Add(AND_IDF_Condition(CreateFld(tbGN.pfx, fli_Identifier)));
    open;

    if qry.EOF then
    begin

      qry.SQL.Clear;
      qry.SQL.Add('insert into ' + tbGN.GetTableName + ' (');
      qry.SQL.Add(CreateFld(tbGN.pfx, fli_IDENTIFIER) + ', ');
      qry.SQL.Add(CreateFld(tbGN.pfx, fli_GeneratorCode) + ', ');
      qry.SQL.Add(CreateFld(tbGN.pfx, fli_GeneratorNum));
      qry.SQL.Add(') values (');
      qry.SQL.Add(IniAppGlobals.Identifier + ', ');
      qry.SQL.Add('''' + 'SERVER' + ''', ');
      qry.SQL.Add(IntToStr(0));
      qry.SQL.Add(')');

      try
      qry.ExecSQL;
      Application.ProcessMessages;
      except
      on E: Exception do
        begin
          qry.transaction.Rollback;
          Application.ProcessMessages;
          result := false;
          exit;
        end
      end;
    end;
    qry.Transaction.commit;
    Application.ProcessMessages;
    Close;
  end;

  tbExchg_wkst := @tblInfo[tbl_cfg_exchg_wkst];
  qryCfg := CreateQuery(Cfg_DB);
  qryCfg.Transaction := CreateTransaction(Cfg_DB);
  qryCfg.Transaction.StartTransaction;
  Application.ProcessMessages;

  with qryCfg do
  begin
    SQL.Clear;
    SQL.Add('select count(*) Cnt from ' + tbExchg_wkst.GetTableName);
    SQL.Add(WHERE_IDF_Condition(CreateFld(tbExchg_wkst.pfx, fli_IDENTIFIER)) + ' AND ' + CreateFld(tbExchg_wkst.pfx, fli_wkstCode) + ' = ''' + 'SERVER' + '''');
    Open;
    if (FieldByName('Cnt').asInteger = 0) then
    begin
      qryCfg.SQL.Clear;
      qryCfg.SQL.Add('Insert into ' + tbExchg_wkst.GetTableName);
      qryCfg.SQL.Add('(' + CreateFld(tbExchg_wkst.pfx, fli_IDENTIFIER) + ',');
      qryCfg.SQL.Add(CreateFld(tbExchg_wkst.pfx, fli_wkstCode) + ',');
      qryCfg.SQL.Add('CEW_CONNECT ,');
      qryCfg.SQL.Add('CEW_LAST_UPD ,');
      qryCfg.SQL.Add('CEW_OP ,');
      qryCfg.SQL.Add('CEW_POLL ,');
      qryCfg.SQL.Add('CEW_COUNTER )');
      qryCfg.SQL.Add(' values (');
      qryCfg.SQL.Add(':' + CreateFld(tbExchg_wkst.pfx, fli_IDENTIFIER) + ',');
      qryCfg.SQL.Add(':' + CreateFld(tbExchg_wkst.pfx, fli_wkstCode) + ',');
      qryCfg.SQL.Add(':' + 'CEW_CONNECT' + ',');
      qryCfg.SQL.Add(':' + 'CEW_LAST_UPD' + ',');
      qryCfg.SQL.Add(':' + 'CEW_OP' + ',');
      qryCfg.SQL.Add(':' + 'CEW_POLL' + ',');
      qryCfg.SQL.Add(':' + 'CEW_COUNTER )');
      qryCfg.ParamByName(CreateFld(tbExchg_wkst.pfx, fli_IDENTIFIER)).Value := IniAppGlobals.Identifier;
      qryCfg.ParamByName(CreateFld(tbExchg_wkst.pfx, fli_wkstCode)).Value := 'SERVER';
      qryCfg.ParamByName('CEW_CONNECT').Value := now;
      qryCfg.ParamByName('CEW_LAST_UPD').Value := 0;
      qryCfg.ParamByName('CEW_OP').Value := ' ';
      qryCfg.ParamByName('CEW_POLL').Value := '0';
      qryCfg.ParamByName('CEW_COUNTER').Value := 0;
      try
        qryCfg.ExecSQL;
        Application.ProcessMessages;
      except
      on E: Exception do
        begin
          qryCfg.transaction.Rollback;
          result := false;
          exit;
        end
      end;
    end;
  end;

  qryCfg.Transaction.Commit;
//////////

  qry.Transaction.StartTransaction;

  with qry do
  begin

    SQL.Clear;
    sql.add(' SELECT GN_GENNUMBER Num from ' + tbGN.GetTableName);
    SQL.Add(' where ' + CreateFld(tbGN.pfx, fli_GeneratorCode) + '=''' + 'SERVER' + '''');
    SQL.Add(AND_IDF_Condition(CreateFld(tbGN.pfx, fli_Identifier)));
    if IniAppGlobals.DownloadTo = '0' then
      SQL.Add(' for update with rs use and keep update locks')
    else if IniAppGlobals.DownloadTo = '1' then
      SQL.Add(' for update'); // lock one record - oracle
    open;

  end;

  qryCfg.Transaction.StartTransaction;
  with qryCfg do
  begin
    SQL.Clear;
    SQL.Text := 'Select CEW_COUNTER CounterNum from '+ tbExchg_wkst.GetTableName  +' where CEW_IDENTIFIER = ' + IniAppGlobals.Identifier
              + ' and CEW_WKST_CODE = ' + QuotedStr('SERVER');
    Open;
    Application.ProcessMessages;
    if qryCfg.Eof then
    begin
      qryCfg.Transaction.commit;
      qry.Transaction.commit;
      Application.ProcessMessages;
      result := false;
      exit;
    end;
    MyCounterNum := qryCfg.FieldByName('CounterNum').AsInteger;
    qryCfg.Transaction.commit;
  end;

  Application.ProcessMessages;

  IniAppGlobals.MyPollingNumber := Qry.FieldByName('Num').AsInteger;

  if IniAppGlobals.MyPollingNumber = 99999 then
    IniAppGlobals.MyPollingNumber := 1
  else
    IniAppGlobals.MyPollingNumber := IniAppGlobals.MyPollingNumber + 1;

  if IniAppGlobals.MyPollingNumber = MyCounterNum then
     IniAppGlobals.MyPollingNumber := MyCounterNum + 1;

  if IniAppGlobals.MyPollingNumber = 99999 then
    IniAppGlobals.MyPollingNumber := 1;

  if MyCounterNum = 0 then
  begin

    with qry do
    begin
      Application.ProcessMessages;
      qryCfg.Transaction.StartTransaction;
      qryCfg.SQL.Clear;
      qryCfg.SQL.Add('update ' + tbExchg_wkst.GetTableName);
      qryCfg.SQL.Add(' set '+ CreateFld(tbExchg_wkst.pfx, fli_COUNTER) + ' = ' + IntTostr(IniAppGlobals.MyPollingNumber));
      qryCfg.SQL.Add(' ' + WHERE_IDF_Condition(CreateFld(tbExchg_wkst.pfx, fli_Identifier)));
      qryCfg.SQL.Add(' and ' + CreateFld(tbExchg_wkst.pfx, fli_wkstCode) + ' = ' + QuotedStr('SERVER'));
      qryCfg.ExecSQL;
      qryCfg.transaction.Commit;
      Application.ProcessMessages;

      Qry.sql.Clear;
      Qry.sql.add(' update ' + tbGN.GetTableName);
      Qry.SQL.Add(' SET GN_GENNUMBER = ' + IntToStr(IniAppGlobals.MyPollingNumber) + ' where ' + CreateFld(tbGN.pfx, fli_GeneratorCode) + '=''' + 'SERVER' + '''');
      Qry.SQL.Add(AND_IDF_Condition(CreateFld(tbGN.pfx, fli_Identifier)));
      qry.ExecSQL;
      qry.Transaction.commit;
      Application.ProcessMessages;

    end;

    Exit;

  end;

  //(MyCounterNum <> 0)
  Qry.sql.Clear;
  Qry.sql.add(' update ' + tbGN.GetTableName);
  Qry.SQL.Add(' SET GN_GENNUMBER = ' + IntToStr(IniAppGlobals.MyPollingNumber) + ' where ' + CreateFld(tbGN.pfx, fli_GeneratorCode) + '=''' + 'SERVER' + '''');
  Qry.SQL.Add(AND_IDF_Condition(CreateFld(tbGN.pfx, fli_Identifier)));
  qry.ExecSQL;

  qry.Transaction.commit;
  Application.ProcessMessages;

  IniAppGlobals.MySrvEvent := true;
  SET_SRVLOAD_POLLING_NUMBER(1);

  SP_ASK_POLL_SERVER;
  Application.ProcessMessages;
  Sleep(2000);
  Application.ProcessMessages;
  IniAppGlobals.MySrvEvent := false;

  if GET_SRVLOAD_POLLING_NUMBER <> 1 then
  begin
    Result := false;
    Exit
  end;

  qryCfg.Transaction.StartTransaction;
  qryCfg.SQL.Clear;
  qryCfg.SQL.Add('update ' + tbExchg_wkst.GetTableName);
  qryCfg.SQL.Add(' set '+ CreateFld(tbExchg_wkst.pfx, fli_COUNTER) + ' = ' + IntTostr(IniAppGlobals.MyPollingNumber));
  qryCfg.SQL.Add(' ' + WHERE_IDF_Condition(CreateFld(tbExchg_wkst.pfx, fli_Identifier)));
  qryCfg.SQL.Add(' and ' + CreateFld(tbExchg_wkst.pfx, fli_wkstCode) + ' = ' + QuotedStr('SERVER'));
  qryCfg.SQL.Add(' and ' + CreateFld(tbExchg_wkst.pfx, fli_COUNTER) + ' = ' + IntTostr(MyCounterNum));
  qryCfg.ExecSQL;
  qryCfg.transaction.Commit;
  Application.ProcessMessages;

  with qryCfg do
  begin
    qryCfg.Transaction.StartTransaction;
    SQL.Clear;
    Application.ProcessMessages;
    // AVI - Get also the counter
    SQL.Text := 'Select CEW_COUNTER CountNum from '+ tbExchg_wkst.GetTableName  +' where CEW_IDENTIFIER = ' + IniAppGlobals.Identifier
              + ' and CEW_WKST_CODE = ' + QuotedStr('SERVER');
    Open;
    Application.ProcessMessages;
    if qryCfg.Eof then
    begin
      qryCfg.Transaction.commit;
      result := false;
      exit;
    end;

    Application.ProcessMessages;

  end;

  if IniAppGlobals.MyPollingNumber <> qryCfg.FieldByName('CountNum').AsInteger then
  begin
    qryCfg.Transaction.commit;
    result := false;
    Exit
  end;
  qryCfg.Transaction.commit;
  Application.ProcessMessages;

end;

//----------------------------------------------------------------------------//

function CheckServerDoubleInstance : boolean;
var
  qryCfg : TMqmQuery;
  tbExchg_wkst : ^TTblInfo;
begin
  result := false;

  tbExchg_wkst := @tblInfo[tbl_cfg_exchg_wkst];
  qryCfg := CreateQuery(Cfg_DB);
  qryCfg.Transaction := CreateTransaction(Cfg_DB);
  qryCfg.Transaction.StartTransaction;

  qryCfg.sql.Clear;
  Application.ProcessMessages;
  qryCfg.Sql.Text := 'Select CEW_COUNTER CountNum from '+ tbExchg_wkst.GetTableName  +' where CEW_IDENTIFIER = ' + IniAppGlobals.Identifier
            + ' and CEW_WKST_CODE = ' + QuotedStr('SERVER');

  qryCfg.Open;
  qryCfg.Transaction.Commit;
  if qryCfg.EOF then
  begin
    result := true;
    exit
  end;

  if (IniAppGlobals.MyPollingNumber <> qryCfg.FieldByName('CountNum').AsInteger) then
  begin
    result := true;
    exit
  end;

{  IniAppGlobals.MySrvEvent := true;
  SET_SRVLOAD_POLLING_NUMBER(1);
  SP_ASK_POLL_SERVER;
  Application.ProcessMessages;
  //Sleep(2000);
  Delay(2000);
  Application.ProcessMessages;
  IniAppGlobals.MySrvEvent := false;
  if GET_SRVLOAD_POLLING_NUMBER <> 1 then
    result := true;   }

end;

//----------------------------------------------------------------------------//

procedure SET_SRVLOAD_COUNTER_NUMBER(Number : Integer);
var
  qry : Tmqmquery;
  tbInfo: ^TTblInfo;
begin
  tbInfo := @tblInfo[tbl_cfg_exchg_wkst];
  qry := CreateQuery(Cfg_DB);
  Qry.Transaction := CreateTransaction(Cfg_DB);
  Qry.Transaction.StartTransaction;
  qry.SQL.Clear;
  qry.SQL.Add('update ' + tbInfo.GetTableName);
  qry.SQL.Add(' set '+ CreateFld(tbInfo.pfx, fli_COUNTER) + ' = ' + IntTostr(Number));
  qry.SQL.Add(' ' + WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.SQL.Add(' and ' + CreateFld(tbInfo.pfx, fli_wkstCode) + ' = ' + QuotedStr('SERVER'));
  qry.ExecSQL;
  qry.transaction.Commit;
  qry.Free;
end;

//----------------------------------------------------------------------------//

function SET_SRVLOAD_POLLING_NUMBER(PollNumber : Integer) : boolean;
var
  qry : Tmqmquery;
  tbInfo: ^TTblInfo;
begin
  tbInfo := @tblInfo[tbl_cfg_exchg_wkst];
  qry := CreateQuery(Cfg_DB);
  Qry.Transaction := CreateTransaction(Cfg_DB);
  Qry.Transaction.StartTransaction;
  qry.SQL.Clear;
  qry.SQL.Add('update ' + tbInfo.GetTableName);
  qry.SQL.Add(' set '+ CreateFld(tbInfo.pfx, fli_POLL) + ' = ' + IntTostr(PollNumber));
  qry.SQL.Add(' ' + WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.SQL.Add(' and ' + CreateFld(tbInfo.pfx, fli_wkstCode) + ' = ' + QuotedStr('SERVER'));
  qry.ExecSQL;
  qry.transaction.Commit;
  qry.Free;
end;

//----------------------------------------------------------------------------//

function GET_SRVLOAD_POLLING_NUMBER : integer;
var
  qry : Tmqmquery;
  tbInfo: ^TTblInfo;
begin
  // AVI - Transactio and commit are needed
  Result := -1;
  qry := CreateQuery(Cfg_DB);
  Qry.Transaction := CreateTransaction(Cfg_DB);
  Qry.Transaction.StartTransaction;
  tbInfo := @tblInfo[tbl_cfg_exchg_wkst];

  qry.SQL.Text := 'Select CEW_POLL from '+ tbInfo.GetTableName+' where CEW_IDENTIFIER = ' + IniAppGlobals.Identifier
    + ' and CEW_WKST_CODE = ' + QuotedStr('SERVER');
  qry.Open;

  if not qry.Eof then
    Result := qry.FieldByName(CreateFld(tbInfo.pfx, fli_POLL)).AsInteger;
  qry.transaction.Commit;
  qry.Free;
end;

//----------------------------------------------------------------------------//

function GET_GRP_STARTING_NUMBER(NumberOfGrps: Integer; GENCODENAME : string): Integer;
var
  qry:       TMqmQuery;
  tbGrp, tbGrpPS, tbGrpMS : ^TTblInfo;
  UpToNumber, SchedGrpNum : integer;
begin
  Result := 1;
  SchedGrpNum := 0;
  tbGrp := @tblInfo[tbl_GeneratorNumber];
  tbGrpPS := @tblInfo[tbl_prod_sched];
  tbGrpMS := @tblInfo[tbl_prod_sched_mcm];

  qry := CreateQuery(Main_DB);
  qry.Transaction := CreateTransaction(Main_DB);
  qry.Transaction.StartTransaction;

  // PHASE 1: Run the slow MAX query BEFORE acquiring the exclusive lock
  // This avoids holding the lock on GENERATE_NUM while scanning PROD_SCHED
  with qry do
  begin
    SQL.Clear;
    if not DBAppGlobals.MCM_App then
    begin
      sql.add(' SELECT max(PS_ST_GROUP) SchedGrpNum from ' + tbGrpPS.GetTableName);
      SQL.Add(WHERE_IDF_Condition(CreateFld(tbGrpPS.pfx, fli_Identifier)));
    end
    else
    begin
      sql.add(' SELECT max(MS_ST_GROUP) SchedGrpNum from ' + tbGrpMS.GetTableName);
      SQL.Add(WHERE_IDF_Condition(CreateFld(tbGrpMS.pfx, fli_Identifier)));
    end;
    open;
    if not qry.EOF then
      SchedGrpNum := FieldByName('SchedGrpNum').AsInteger;
    Close;
  end;

  // PHASE 2: Now lock the GENERATE_NUM row briefly — only read + update, no slow queries
  with qry do
  begin
    SQL.Clear;
    sql.add(' SELECT GN_GENNUMBER GrpNum from ' + tbGrp.GetTableName);
    SQL.Add(' where ' + CreateFld(tbGrp.pfx,fli_GeneratorCode) + '=''' + GENCODENAME + '''');
    SQL.Add(AND_IDF_Condition(CreateFld(tbGrp.pfx, fli_Identifier)));

    if IniAppGlobals.DownloadTo = '0' then
      SQL.Add(' WITH RS USE AND KEEP EXCLUSIVE LOCKS')
    else if IniAppGlobals.DownloadTo = '1' then
      SQL.Add(' for update');

    open;

    if qry.EOF then
    begin
      Close;
      qry.SQL.Clear;
      qry.SQL.Add('insert into ' + tbGrp.GetTableName + ' (');
      qry.SQL.Add(CreateFld(tbGrp.pfx, fli_IDENTIFIER) + ', ');
      qry.SQL.Add(CreateFld(tbGrp.pfx, fli_GeneratorCode) + ', ');
      qry.SQL.Add(CreateFld(tbGrp.pfx, fli_GeneratorNum));
      qry.SQL.Add(') values (');
      qry.SQL.Add(IniAppGlobals.Identifier + ', ');
      qry.SQL.Add('''' + GENCODENAME + ''', ');
      qry.SQL.Add(IntToStr(0));
      qry.SQL.Add(')');

      try
        qry.ExecSQL;
      except
        on E: Exception do
        begin
          qry.transaction.Rollback;
          qry.Transaction.StartTransaction;
        end
      end;

      Close;
      SQL.Clear;
      sql.add(' SELECT GN_GENNUMBER GrpNum from ' + tbGrp.GetTableName);
      SQL.Add(' where ' + CreateFld(tbGrp.pfx,fli_GeneratorCode) + '=''' + GENCODENAME + '''');
      SQL.Add(AND_IDF_Condition(CreateFld(tbGrp.pfx, fli_Identifier)));
      if IniAppGlobals.DownloadTo = '0' then
        SQL.Add(' WITH RS USE AND KEEP EXCLUSIVE LOCKS')
      else if IniAppGlobals.DownloadTo = '1' then
        SQL.Add(' for update');
      open;
    end;

    if qry.EOF then
      Result := 1
    else
      result := FieldByName('GrpNum').AsInteger + 1;

    // Use the higher of GENERATE_NUM value or MAX from PROD_SCHED
    if SchedGrpNum >= Result then
       result := SchedGrpNum + 1;

    UpToNumber := NumberOfGrps + result - 1;

    SQL.Clear;
    sql.add(' update ' + tbGrp.GetTableName);
    SQL.Add(' SET GN_GENNUMBER = ' + IntToStr(UpToNumber) + ' where ' + CreateFld(tbGrp.pfx,fli_GeneratorCode) + '=''' + GENCODENAME + '''');
    SQL.Add(AND_IDF_Condition(CreateFld(tbGrp.pfx, fli_Identifier)));
    qry.ExecSQL;
    qry.Transaction.commit;
    Close;

  end;
  qry.free;

end;

//----------------------------------------------------------------------------//

{function SET_GRP_MAX_NUM(GrpNum: Integer; GENCODENAME : string): boolean;
var
  qry:       TMqmQuery;
  tbGrp : ^TTblInfo;
begin
  Result := true;
  tbGrp := @tblInfo[tbl_GeneratorNumber];

  qry := CreateQuery(Main_DB);
  qry.Transaction := CreateTransaction(Main_DB);
  qry.Transaction.StartTransaction;

  with qry do
  begin
    SQL.Clear;
    sql.add(' update ' + tbGrp.GetTableName);
    SQL.Add(' SET GN_GENNUMBER = ' + IntToStr(GrpNum) + ' where ' + CreateFld(tbGrp.pfx,tbl_GeneratorCode) + '=''' + GENCODENAME + '''');
    SQL.Add(AND_IDF_Condition(CreateFld(tbGrp.pfx, fli_Identifier)));
    qry.ExecSQL;
    qry.Transaction.commit;
    Close;
  end;
  qry.free;
end; }

//----------------------------------------------------------------------------//

function SP_GET_GRP_NUM(Out GrpNum: Integer; GENCODENAME : string): boolean;
var
  StoredProc: TMqmStoredProc;
  tbInfo, tbInfoProdStep: ^TTblInfo;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CMainGetGrpNum
  else
    StoredProcName := 'SCDM_' + CMainGetGrpNum;
  Result := true;

  StoredProc := CreateStoredProc(Main_DB);
  StoredProc.StoredProcName := StoredProcName;

  try
    with StoredProc do
    begin
      Prepare;
      ParamByName('GENCODENAME').AsString := GENCODENAME;
      ParamByName('IDENTIFIER').Value := IniAppGlobals.Identifier;
      ExecProc;
      GrpNum := ParamByName('GrpNum').AsInteger;
      unprepare
    end
  except
    on E: Exception do
    begin
      ApplicationShowException(E);
    end;
  end;

  StoredProc.Free;
end;

//----------------------------------------------------------------------------//

function GET_NEW_REQ_STARTING_NUMBER(NumberOfNewReq: Integer): Integer;
var
  qry:       TMqmQuery;
  tbNewReqNum, tbReqNumPS : ^TTblInfo;
  UpToNumber, ReqNumPS : integer;
  GENCODENAME : string;
begin
  Result := 1;
  GENCODENAME := 'REQNUMBER';
  tbNewReqNum := @tblInfo[tbl_GeneratorNumber];

  qry := CreateQuery(Main_DB);
  qry.Transaction := CreateTransaction(Main_DB);
  qry.Transaction.StartTransaction;

  with qry do
  begin
    SQL.Clear;
    sql.add(' SELECT GN_GENNUMBER NewReqNum from ' + tbNewReqNum.GetTableName);
    SQL.Add(' where ' + CreateFld(tbNewReqNum.pfx,fli_GeneratorCode) + '=''' + GENCODENAME + '''');
    SQL.Add(AND_IDF_Condition(CreateFld(tbNewReqNum.pfx, fli_Identifier)));
//    SQL.Add(' For update');

    if IniAppGlobals.DownloadTo = '0' then
      SQL.Add(' WITH RS USE AND KEEP EXCLUSIVE LOCKS')
    else if IniAppGlobals.DownloadTo = '1' then
      SQL.Add(' for update'); // lock one record - oracle

    open;

    if qry.EOF then
      Result := 1
    else
      result := FieldByName('NewReqNum').AsInteger + 1;

    tbReqNumPS := @tblInfo[tbl_prod_sched];

    SQL.Clear;
    sql.add(' SELECT max(PS_NEW_PREQ_UNIQ_ID) ReqNumPS from ' + tbReqNumPS.GetTableName);
    SQL.Add(WHERE_IDF_Condition(CreateFld(tbReqNumPS.pfx, fli_Identifier)));
    open;

    if qry.EOF or (Trim(FieldByName('ReqNumPS').AsString) = '') then
      ReqNumPS := 0
    else
      ReqNumPS := FieldByName('ReqNumPS').AsInteger;

    if ReqNumPS > Result then
       result := ReqNumPS;

    UpToNumber := NumberOfNewReq + result - 1;

    SQL.Clear;
    sql.add(' update ' + tbNewReqNum.GetTableName);
    SQL.Add(' SET GN_GENNUMBER = ' + IntToStr(UpToNumber) + ' where ' + CreateFld(tbNewReqNum.pfx,fli_GeneratorCode) + '=''' + GENCODENAME + '''');
    SQL.Add(AND_IDF_Condition(CreateFld(tbNewReqNum.pfx, fli_Identifier)));
    qry.ExecSQL;
    qry.Transaction.commit;
    Close;

  end;
  qry.free;

end;

//----------------------------------------------------------------------------//

function SP_GET_NEW_REQ_NO(Out NewReqNum: Integer; GENCODENAME : string): boolean;
var
  StoredProc: TMqmStoredProc;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CMainGetNewReqNo
  else
    StoredProcName := 'SCDM_' + CMainGetNewReqNo;

  Result := true;
  StoredProc := CreateStoredProc(Main_DB);
  StoredProc.StoredProcName := StoredProcName;

 // try
    with StoredProc do
    begin
      Prepare;
      ParamByName('GENCODENAME').AsString := GENCODENAME;
      ParamByName('IDENTIFIER').Value := IniAppGlobals.Identifier;
      ExecProc;
      NewReqNum := ParamByName('NewReqNum').AsInteger;
      unprepare
    end;
 // except
  //  Result := false
 // end;

  StoredProc.Free;
end;

//----------------------------------------------------------------------------//

function SP_GET_SPLIT_FAMILY_CODE(Out NewSplitFamily : integer; GENCODENAME : string): boolean;
var
  StoredProc: TMqmStoredProc;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CMainGetSplitFamily
  else
    StoredProcName := 'SCDM_' + CMainGetSplitFamily;
  Result := true;

  StoredProc := CreateStoredProc(Main_DB);
  StoredProc.StoredProcName := StoredProcName;

  try
    with StoredProc do
    begin
      Prepare;
      ParamByName('GENCODENAME').AsString := GENCODENAME;
      ParamByName('IDENTIFIER').Value := IniAppGlobals.Identifier;
      ExecProc;
      NewSplitFamily := ParamByName('SplitNum').AsInteger;
      unprepare
    end
  except
    Result := false
  end;

  StoredProc.Free;
end;

//----------------------------------------------------------------------------//

procedure SetGrpNumGenerator(NewValue: integer);
var
  qry: TMqmQuery;
//  trs: TMqmTransaction;
begin
//  trs := CreateTransaction(Main_DB, false);
  qry := CreateQuery(Main_DB);

  qry.Transaction.StartTransaction;

  with qry do
  begin
    Close;
    SQL.Clear;

    SQL.Add('SET GENERATOR GRP_GEN TO ' + IntToStr(NewValue));

    prepare;
    ExecSql;
    Close;
    SQL.Clear

  end;
  qry.Transaction.Commit;
  qry.Free;
end;

//----------------------------------------------------------------------------//

procedure SetUpdNumGenerator(NewValue: integer);
var
  qry: TMqmQuery;
begin
  qry := CreateQuery(Main_DB);

  qry.Transaction.StartTransaction;

  with qry do
  begin
    Close;
    SQL.Clear;

    SQL.Add('SET GENERATOR UPD_GEN TO ' + IntToStr(NewValue));

    prepare;
    ExecSql;
    Close;
    SQL.Clear

  end;
  qry.Transaction.Commit;
  qry.Free;
end;

//----------------------------------------------------------------------------//

procedure CrtProcConnect;
var
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CCfgConnect
  else
    StoredProcName := 'SCDC_' + CCfgConnect;
  qry := CreateQuery(Cfg_DB);

  tbInfo := @tblInfo[tbl_cfg_exchg_wkst];
  SetFldPfx(tbInfo.pfx);

  qry.SQL.Add('DROP PROCEDURE ' + StoredProcName);
  try
    qry.ExecSql;
  except
  end;

  qry.connection.Commit;

  with qry do
  begin
   // ParamCheck := false;
    Close;
    SQL.Clear;

    if IniAppGlobals.DownloadTo = '2' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName + '(');
    //In parameters
      SQL.Add('WKSTCODE VARCHAR(10), IDENTIFIER INTEGER');
      SQL.Add(') RETURNS (');
    //Out Parameters
      SQL.Add('isOk CHAR(1),CURR_DATE TIMESTAMP');
      SQL.Add(')');
      SQL.Add('AS');
      SQL.Add('DECLARE VARIABLE myWkstCode integer;');
      SQL.Add('begin');
      SQL.Add('  isOk = ''1'';');
      SQL.Add('  SELECT count(*) FROM ' + tbInfo.GetTableName);
      SQL.Add('  WHERE ' + CreatePfxFld(fli_wkstCode) + ' = :WKSTCODE');
      SQL.Add('  and ' + CreatePfxFld(fli_IDENTIFIER) + ' = :IDENTIFIER into :myWkstCode;');
      SQL.Add('  if (myWkstCode = 0) then');
      SQL.Add('begin');
      SQL.Add('  CURR_DATE = CURRENT_TIMESTAMP;');
      SQL.Add('  insert into ' + tbInfo.GetTableName + ' (' + CreatePfxFld(fli_wkstCode) +
              ',CEW_CONNECT,CEW_LAST_UPD,CEW_OP,CEW_POLL,CEW_COUNTER,CEW_IDENTIFIER) values (:WKSTCODE,:CURR_DATE,0,'' '',''1'',0,:IDENTIFIER);');
      SQL.Add('end');
      SQL.Add('  else');
      SQL.Add('    isOk = ''0'';');
      SQL.Add('end');
    end
    else if IniAppGlobals.DownloadTo = '0' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName + ' (');
    //In parameters
      SQL.Add(' IN WKSTCODE VARCHAR(10), IN IDENTIFIER INTEGER');
      SQL.Add(' , OUT ');
    //Out Parameters
      SQL.Add(' isOk CHAR(1),CURR_DATE TIMESTAMP');
      SQL.Add(')');
      SQL.Add('LANGUAGE SQL ');
      SQL.Add('BEGIN ');
      SQL.Add('DECLARE myWkstCode integer; ');
      SQL.Add('SET isOk = ''1'';');
      SQL.Add('select count(1) into myWkstCode from ' + tbInfo.GetTableName +  ' where ' + CreatePfxFld(fli_wkstCode) + ' = WKSTCODE');
      SQL.Add('  and ' + CreatePfxFld(fli_IDENTIFIER) + ' = IDENTIFIER;');
      SQL.Add('if (myWkstCode = 0) then ');
      SQL.Add('begin');
      SQL.Add('  SET CURR_DATE = CURRENT TIMESTAMP;');
      SQL.Add('  insert into ' + tbInfo.GetTableName + ' (' + CreatePfxFld(fli_wkstCode) +
              '           ,CEW_CONNECT,CEW_LAST_UPD,CEW_OP,CEW_POLL,CEW_COUNTER,CEW_IDENTIFIER) values (WKSTCODE,CURRENT TIMESTAMP,0,'' '',''1'',0,IDENTIFIER);');
      SQL.Add('end; ');
      SQL.Add('else');
      SQL.Add('  SET isOk = ''0'';');
      SQL.Add('End if; ');
      SQL.Add('end');
    end
    else if IniAppGlobals.DownloadTo = '1' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName + ' (');
    //In parameters
      SQL.Add(' WKSTCODE IN VARCHAR, IDENTIFIER IN INTEGER, ');
   //   SQL.Add(' , OUT ');
    //Out Parameters
      SQL.Add(' isOk OUT CHAR,CURR_DATE OUT TIMESTAMP');
      SQL.Add(')');
      SQL.Add('AS ');
      SQL.Add('BEGIN ');
      SQL.Add('DECLARE myWkstCode integer; ');
      SQL.Add('BEGIN ');
      SQL.Add('isOk := ''1'';');
      SQL.Add('select count(1) into myWkstCode from ' + tbInfo.GetTableName +  ' where ' + CreatePfxFld(fli_wkstCode) + ' = WKSTCODE');
      SQL.Add('  and ' + CreatePfxFld(fli_IDENTIFIER) + ' = IDENTIFIER;');
      SQL.Add('if (myWkstCode = 0) then ');
      SQL.Add('begin');
      SQL.Add('  CURR_DATE := CURRENT_TIMESTAMP;');
      SQL.Add('  insert into ' + tbInfo.GetTableName + ' (' + CreatePfxFld(fli_wkstCode) +
              '           ,CEW_CONNECT,CEW_LAST_UPD,CEW_OP,CEW_POLL,CEW_COUNTER,CEW_IDENTIFIER) values (WKSTCODE,CURRENT_TIMESTAMP,0,'' '',''1'',0,IDENTIFIER);');
      SQL.Add('end; ');
      SQL.Add('else');
      SQL.Add('  isOk := ''0'';');
      SQL.Add('End if; ');
      SQL.Add('end;');
      SQL.Add('end;');
    end;

    prepare;
    ExecSql;
    Close;
    qry.connection.Commit;
  end;
  qry.Free;
end;

//----------------------------------------------------------------------------//

function SP_CONNECT(Wrkst: string; var CurrDate : TDateTime): boolean;
var
  StoredProc: TMqmStoredProc;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CCfgConnect
  else
    StoredProcName := 'SCDC_' + CCfgConnect;

  Result := true;
  StoredProc := CreateStoredProc(Cfg_DB);
  StoredProc.StoredProcName := StoredProcName;

  StoredProc.Transaction := CreateTransaction(Cfg_DB);
  StoredProc.Transaction.StartTransaction;

//  try
  with StoredProc do
  begin
    Prepare;
    ParamByName('WKSTCODE').AsString := Wrkst;
    ParamByName('IDENTIFIER').Value := IniAppGlobals.Identifier;
    ExecProc;
    if ParamByName('isOk').AsString <> '1' then
      Result := false;
    CurrDate := ParamByName('CURR_DATE').AsDateTime;
    unprepare
  end;
//  except
//    Result := false
//  end;

  StoredProc.Transaction.Commit;
  StoredProc.Free;
end;

//----------------------------------------------------------------------------//

procedure CrtProcDisconnect;
var
  qry:     TMqmQuery;
  tbInfo: ^TTblInfo;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CCfgDisconnect
  else
    StoredProcName := 'SCDC_' + CCfgDisconnect;
  qry := CreateQuery(Cfg_DB);

  tbInfo := @tblInfo[tbl_cfg_exchg_wkst];
  SetFldPfx(tbInfo.pfx);

  qry.SQL.Add('DROP PROCEDURE ' + StoredProcName);
  try
    qry.ExecSql;
  except
  end;

  qry.connection.Commit;

  with qry do
  begin
   // ParamCheck := false;
    Close;
    SQL.Clear;

    if IniAppGlobals.DownloadTo = '2' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName + '(');
    //In parameters
      SQL.Add('WKSTCODE VARCHAR(10), IDENTIFIER INTEGER');
      SQL.Add(')');
      SQL.Add(' AS');
      SQL.Add(' DECLARE VARIABLE myWkstCode integer;');
      SQL.Add(' begin ');
      SQL.Add(' delete from ' + tbInfo.GetTableName);
      SQL.Add(' where ');
      SQL.Add(CreatePfxFld(fli_wkstCode) + ' = :WKSTCODE');
      SQL.Add(' and ' + CreatePfxFld(fli_IDENTIFIER) + ' = :IDENTIFIER;');
      SQL.Add(' end');
    end
    else if IniAppGlobals.DownloadTo = '0' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName + '(');
    //In parameters
      SQL.Add(' IN WKSTCODE VARCHAR(10),IN IDENTIFIER INTEGER');
      SQL.Add(') ');
      SQL.Add('LANGUAGE SQL ');
      SQL.Add('BEGIN ');
      SQL.Add('DECLARE myWkstCode integer;');
      SQL.Add('delete from ' + tbInfo.GetTableName);
      SQL.Add(' where ');
      SQL.Add(CreatePfxFld(fli_wkstCode) + ' = WKSTCODE');
      SQL.Add(' and ' + CreatePfxFld(fli_IDENTIFIER) + ' = IDENTIFIER;');
      SQL.Add(' end');
    end
    else if IniAppGlobals.DownloadTo = '1' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName + '(');
    //In parameters
      SQL.Add(' WKSTCODE IN VARCHAR, IDENTIFIER IN INTEGER');
      SQL.Add(')');
      SQL.Add('AS ');
      SQL.Add('BEGIN ');
      SQL.Add('DECLARE myWkstCode integer;');
      SQL.Add('BEGIN ');
      SQL.Add('delete from ' + tbInfo.GetTableName);
      SQL.Add(' where ');
      SQL.Add(CreatePfxFld(fli_wkstCode) + ' = WKSTCODE');
      SQL.Add(' and ' + CreatePfxFld(fli_IDENTIFIER) + ' = IDENTIFIER;');
      SQL.Add(' end;');
      SQL.Add(' end;');
    end;

    prepare;
    ExecSql;
    Close;
    qry.connection.Commit;
  end;
  qry.Free
//  trs.Free
end;

//----------------------------------------------------------------------------//

procedure SP_DISCONNECT(Wrkst: string);
var
  StoredProc: TMqmStoredProc;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CCfgDisconnect
  else
    StoredProcName := 'SCDC_' + CCfgDisconnect;
  StoredProc := CreateStoredProc(Cfg_DB);
  StoredProc.StoredProcName := StoredProcName;
  StoredProc.Connection.StartTransaction;
//  StoredProc.ResourceOptions.

//  try
    with StoredProc do
    begin
      Prepare;
      ParamByName('WKSTCODE').AsString := Wrkst;
      ParamByName('IDENTIFIER').Value := IniAppGlobals.Identifier;
      ExecProc;
      unprepare
    end;
//  except
//  end;

  StoredProc.Connection.Commit;
  StoredProc.Free;
end;

//----------------------------------------------------------------------------//

function SP_IS_CLIENT_EXIST : boolean;
var
  StoredProc: TMqmStoredProc;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CCfgIsExistClient
  else
    StoredProcName := 'SCDC_' + CCfgIsExistClient;

  StoredProc := CreateStoredProc(Cfg_DB);
  StoredProc.StoredProcName := StoredProcName;
  StoredProc.Connection.StartTransaction;

  try
    with StoredProc do
    begin
      Prepare;
      ParamByName('IDENTIFIER').Value := IniAppGlobals.Identifier;
      ExecProc;
      if ParamByName('isOk').AsString = '1' then
        Result := true
      else
        Result := false;
      unprepare
    end
  except
    Result := false
  end;

  StoredProc.Connection.Commit;

  StoredProc.Free;
end;

//----------------------------------------------------------------------------//

procedure CrtProcActiveWrkst;
var
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
  StoredProcName : string;
begin
  qry := CreateQuery(Cfg_DB);
  tbInfo := @tblInfo[tbl_cfg_exchg_wkst];

  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CCfgActWrcst
  else
    StoredProcName := 'SCDC_' + CCfgActWrcst;

  qry.SQL.Add('DROP PROCEDURE ' + StoredProcName);
  try
    qry.ExecSql;
  except
  end;

  qry.connection.Commit;

  with qry do
  begin
  //  ParamCheck := false;
    Close;
    SQL.Clear;
    if IniAppGlobals.DownloadTo = '2' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName + '(');
    //In parameters
      SQL.Add('WKSTCODE VARCHAR(10), IDENTIFIER INTEGER');
      SQL.Add(') RETURNS (');
    //Out Parameters
      SQL.Add('Exist CHAR(1)');
      SQL.Add(')');
      SQL.Add('AS');
      SQL.Add('DECLARE VARIABLE myWkstCode integer;');
      SQL.Add('begin');
      SQL.Add('  Exist = ''1'';');
      SQL.Add('  SELECT count(*) FROM ' + tbInfo.GetTableName);
      SQL.Add('  WHERE ' + CreateFld(tbInfo.pfx, fli_wkstCode) + ' = :WKSTCODE');
      SQL.Add('  and ' + CreateFld(tbInfo.pfx, fli_IDENTIFIER) + ' = :IDENTIFIER into :myWkstCode;');
      SQL.Add('  if (myWkstCode = 0) then');
      SQL.Add('    Exist = ''0'';');
      SQL.Add('end');
    end
    else if IniAppGlobals.DownloadTo = '0' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName + '(');
      SQL.Add(' IN WKSTCODE VARCHAR(10), IN IDENTIFIER INTEGER');
      SQL.Add(' , ' + 'OUT Exist CHAR(1)) ');
      SQL.Add('LANGUAGE SQL ');
      SQL.Add('BEGIN ');
      SQL.Add('DECLARE myWkstCode integer;');
      SQL.Add(' SET Exist = ''1'';');
      SQL.Add(' select count(1) into myWkstCode from ' + tbInfo.GetTableName + ' where CEW_WKST_CODE = WKSTCODE');
      SQL.Add('  and ' + CreateFld(tbInfo.pfx, fli_IDENTIFIER) + ' = IDENTIFIER;');
      SQL.Add(' if (myWkstCode = 0) THEN');
      SQL.Add('   SET Exist = ''0'';');
      SQL.Add(' END IF; ');
      SQL.Add('END');
    end
    else if IniAppGlobals.DownloadTo = '1' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName + '(');
      SQL.Add(' WKSTCODE IN VARCHAR, IDENTIFIER IN INTEGER');
      SQL.Add(' , ' + 'Exist OUT CHAR) ');
      SQL.Add('AS ');
      SQL.Add('BEGIN ');
      SQL.Add('DECLARE myWkstCode integer;');
      SQL.Add('BEGIN ');
      SQL.Add(' Exist := ''1'';');
      SQL.Add(' select count(1) into myWkstCode from ' + tbInfo.GetTableName + ' where CEW_WKST_CODE = WKSTCODE');
      SQL.Add('  and ' + CreateFld(tbInfo.pfx, fli_IDENTIFIER) + ' = IDENTIFIER;');
      SQL.Add(' if (myWkstCode = 0) THEN');
      SQL.Add('   Exist := ''0'';');
      SQL.Add(' END IF; ');
      SQL.Add('END;');
      SQL.Add('END;');
    end;

    ExecSql;
    Close;
    connection.Commit;
  end;

  qry.Free
end;

//----------------------------------------------------------------------------//

procedure CrtProcUpdatedDatabaseChange;
var
  qry:    TMqmQuery;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CSevCngDataBase
  else
    StoredProcName := 'SCDC_' + CSevCngDataBase;
  qry := CreateQuery(Cfg_DB);

  qry.SQL.Add('DROP PROCEDURE ' + StoredProcName);
  try
    qry.ExecSql;
  except
  end;

  qry.connection.Commit;

  with qry do
  begin
   // ParamCheck := false;
    Close;
    SQL.Clear;
    if IniAppGlobals.DownloadTo = '2' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add('AS');
      SQL.Add('BEGIN');
      SQL.Add('  post_event ''' + EVT_CNGDATA + ''';');
      SQL.Add('END');
    end
    else if IniAppGlobals.DownloadTo = '0' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add('BEGIN');
      SQL.Add('CALL DBMS_ALERT.SIGNAL(''' + EVT_CNGDATA  + ''' , ''123'');');
      SQL.Add('END');
    end
    else if IniAppGlobals.DownloadTo = '1' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add('IS');
      SQL.Add('BEGIN');
      SQL.Add(' DBMS_ALERT.SIGNAL(''' + EVT_CNGDATA  + ''' , ''123'');');
      SQL.Add('END;');
    end;

    prepare;
    ExecSql;
    Close;
    SQL.Clear;

  end;
  qry.connection.Commit;
  qry.Free;    //Vinc

end;

//----------------------------------------------------------------------------//

procedure CrtProcUpdatedDatabaseIncludeChangeWarp;
var
  qry:    TMqmQuery;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CSevCngDataBaseAndWarp
  else
    StoredProcName := 'SCDC_' + CSevCngDataBaseAndWarp;
  qry := CreateQuery(Cfg_DB);

  qry.SQL.Add('DROP PROCEDURE ' + StoredProcName);
  try
    qry.ExecSql;
  except
  end;

  qry.connection.Commit;

  with qry do
  begin
   // ParamCheck := false;
    Close;
    SQL.Clear;
    if IniAppGlobals.DownloadTo = '2' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add('AS');
      SQL.Add('BEGIN');
      SQL.Add('  post_event ''' + EVT_CNGDATA_AND_WARP + ''';');
      SQL.Add('END');
    end
    else if IniAppGlobals.DownloadTo = '0' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add('BEGIN');
      SQL.Add('CALL DBMS_ALERT.SIGNAL(''' + EVT_CNGDATA_AND_WARP  + ''' , ''123'');');
      SQL.Add('END');
    end
    else if IniAppGlobals.DownloadTo = '1' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add('IS');
      SQL.Add('BEGIN');
      SQL.Add(' DBMS_ALERT.SIGNAL(''' + EVT_CNGDATA_AND_WARP  + ''' , ''123'');');
      SQL.Add('END;');
    end;

    prepare;
    ExecSql;
    Close;
    SQL.Clear;

  end;
  qry.connection.Commit;
  qry.Free;    //Vinc

end;

//----------------------------------------------------------------------------//

procedure CrtProcUpdatedDatabaseWarpOnly;
var
  qry:    TMqmQuery;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CSevCngDataBaseWarpOnly
  else
    StoredProcName := 'SCDC_' + CSevCngDataBaseWarpOnly;
  qry := CreateQuery(Cfg_DB);

  qry.SQL.Add('DROP PROCEDURE ' + StoredProcName);
  try
    qry.ExecSql;
  except
  end;

  qry.connection.Commit;

  with qry do
  begin
   // ParamCheck := false;
    Close;
    SQL.Clear;
    if IniAppGlobals.DownloadTo = '2' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add('AS');
      SQL.Add('BEGIN');
      SQL.Add('  post_event ''' + EVT_CNGDATA_WARP_ONLY + ''';');
      SQL.Add('END');
    end
    else if IniAppGlobals.DownloadTo = '0' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add('BEGIN');
      SQL.Add('CALL DBMS_ALERT.SIGNAL(''' + EVT_CNGDATA_WARP_ONLY  + ''' , ''123'');');
      SQL.Add('END');
    end
    else if IniAppGlobals.DownloadTo = '1' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add('IS');
      SQL.Add('BEGIN');
      SQL.Add(' DBMS_ALERT.SIGNAL(''' + EVT_CNGDATA_WARP_ONLY  + ''' , ''123'');');
      SQL.Add('END;');
    end;

    prepare;
    ExecSql;
    Close;
    SQL.Clear;

  end;
  qry.connection.Commit;
  qry.Free;    //Vinc

end;

//----------------------------------------------------------------------------//

function CrtDownloadTriger : boolean;
var
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
  TrigerName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    TrigerName := CSrvLoadTriger
  else
    TrigerName := 'SCDC_' + CSrvLoadTriger;
  Result := true;
  qry := CreateQuery(Cfg_DB);
  tbInfo := @tblInfo[tbl_cfg_exchg_SrvLoad];
  SetFldPfx(tbInfo.pfx);

  qry.SQL.Clear;              // drop trigger "C##NOW45"."SCDC_SRVLOADTRIGER"
//  qry.SQL.Add('DROP TRIGGER "C##NOW45".' + QuotedStr(TrigerName));
  qry.SQL.Add('DROP TRIGGER ' + TrigerName);
  try
    qry.ExecSql;
  except
    Result := false;
  end;

  qry.connection.Commit;

  with qry do
  begin
  //  ParamCheck := false;
    Close;
    SQL.Clear;

    if IniAppGlobals.DownloadTo = '2' then
    begin
      SQL.Add('CREATE TRIGGER ' + TrigerName + ' FOR ' + tbInfo.GetTableName);
      SQL.Add(' AFTER INSERT AS');
      SQL.Add(' BEGIN');
      SQL.Add('    post_event ''' + EVT_DOWNLOADREQ + ''';');
      SQL.Add(' END');
    end
    else if IniAppGlobals.DownloadTo = '0' then
    begin
      SQL.Add('CREATE TRIGGER ' + TrigerName);
      SQL.Add(' AFTER INSERT ON ' + tbInfo.GetTableName);
      SQL.Add(' FOR EACH ROW MODE DB2SQL ');
      SQL.Add(' BEGIN');
      SQL.Add(' CALL DBMS_ALERT.SIGNAL(''' + EVT_DOWNLOADREQ  + ''' , ''123'');');
      SQL.Add(' END');
    end
    else if IniAppGlobals.DownloadTo = '1' then
    begin
      SQL.Add('CREATE TRIGGER ' + TrigerName);
      SQL.Add(' AFTER INSERT ON ' + tbInfo.GetTableName);
      SQL.Add(' FOR EACH ROW ');
      SQL.Add(' BEGIN');
      SQL.Add('   DBMS_ALERT.SIGNAL(''' + EVT_DOWNLOADREQ  + ''' , ''123'');');
      SQL.Add(' END;');
    end;

    prepare;
    ExecSql;
    Close
  end;
  qry.connection.Commit;
  qry.Free;
//  trs.Free;
end;

//----------------------------------------------------------------------------//

function CrtSrvLoadTrigerUpdateStatus : boolean;
var
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
  TrigerName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    TrigerName := CSrvLoadTrigerUpdateStatus
  else
    TrigerName := 'SCDC_' + CSrvLoadTrigerUpdateStatus;
  Result := true;
  qry := CreateQuery(Cfg_DB);
  tbInfo := @tblInfo[tbl_cfg_exchg_glob];
  SetFldPfx(tbInfo.pfx);

  qry.SQL.Add('DROP TRIGGER ' + TrigerName);
  try
    qry.ExecSql
  except
    Result := false;
  end;

  qry.connection.Commit;

  with qry do
  begin
   // ParamCheck := false;
    Close;
    SQL.Clear;
    if IniAppGlobals.DownloadTo = '2' then
    begin
      SQL.Add('CREATE TRIGGER ' + TrigerName + ' FOR ' + tbInfo.GetTableName);
      SQL.Add(' AFTER UPDATE AS');
      SQL.Add(' BEGIN');
      SQL.Add('    post_event ''' + EVT_NEWSTATUS + ''';');
      SQL.Add(' END');
    end
    else if IniAppGlobals.DownloadTo = '0' then
    begin
      SQL.Add('CREATE TRIGGER ' + TrigerName);
      SQL.Add(' AFTER UPDATE ON ' + tbInfo.GetTableName);
      SQL.Add(' FOR EACH ROW MODE DB2SQL ');
      SQL.Add(' BEGIN');
      SQL.Add(' CALL DBMS_ALERT.SIGNAL(''' + EVT_NEWSTATUS  + ''' , ''123'');');
      SQL.Add(' END');
    end
    else if IniAppGlobals.DownloadTo = '1' then
    begin
      SQL.Add('CREATE TRIGGER ' + TrigerName);
      SQL.Add(' AFTER UPDATE ON ' + tbInfo.GetTableName);
      SQL.Add(' FOR EACH ROW ');
      SQL.Add(' BEGIN');
      SQL.Add('   DBMS_ALERT.SIGNAL(''' + EVT_NEWSTATUS  + ''' , ''123'');');
      SQL.Add(' END;');
    end;

    prepare;
    ExecSql;
    Close
  end;
  qry.connection.Commit;
  qry.Free;
//  trs.Free;
end;

//----------------------------------------------------------------------------//

function CrtProcSrvLoadSetStatusOpenedOrClose : boolean;
var
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CSrvLoadSetStatusOpenedOrClosed
  else
    StoredProcName := 'SCDC_' + CSrvLoadSetStatusOpenedOrClosed;
  Result := true;
  tbInfo := @tblInfo[tbl_cfg_exchg_glob];
  SetFldPfx(tbInfo.pfx);
  qry := CreateQuery(Cfg_DB);

  qry.SQL.Add('DROP PROCEDURE ' + StoredProcName);
  try
    qry.ExecSql;
  except
    Result := false;
  end;

  qry.connection.Commit;

  with qry do
  begin
    Close;
    SQL.Clear;
    if IniAppGlobals.DownloadTo = '2' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName + '(');
    //In parameters
      SQL.Add('stat CHAR(1), IDENTIFIER INTEGER');
      SQL.Add(')');
      SQL.Add('AS');
      SQL.Add('BEGIN');
      SQL.Add('  UPDATE ' + tbInfo.GetTableName + ' SET CEG_SL_OP = :stat where CEG_IDENTIFIER = :IDENTIFIER;');
      SQL.Add('END');
    end
    else if IniAppGlobals.DownloadTo = '0' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName + '(');
    //In parameters
      SQL.Add(' IN stat CHAR(1), IN IDENTIFIER INTEGER');
      SQL.Add(')');
      SQL.Add('LANGUAGE SQL ');
      SQL.Add('BEGIN');
      SQL.Add('  UPDATE ' + tbInfo.GetTableName + ' SET CEG_SL_OP = stat where CEG_IDENTIFIER = IDENTIFIER;');
      SQL.Add('END');
    end
    else if IniAppGlobals.DownloadTo = '1' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName + '(');
    //In parameters
      SQL.Add(' stat IN CHAR, IDENTIFIER IN INTEGER');
      SQL.Add(')');
      SQL.Add('AS ');
      SQL.Add('BEGIN');
      SQL.Add('  UPDATE ' + tbInfo.GetTableName + ' SET CEG_SL_OP = stat where CEG_IDENTIFIER = IDENTIFIER;');
      SQL.Add('END;');
    end;

    prepare;
    ExecSql;
    Close;
    SQL.Clear;

  end;
  qry.connection.Commit;
  qry.Free;       //Vinc

end;

//----------------------------------------------------------------------------//

function CrtProcSrvLoadGetStatusOpenedOrClose : boolean;
var
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CSrvLoadGetStatusOpenedOrClosed
  else
    StoredProcName := 'SCDC_' + CSrvLoadGetStatusOpenedOrClosed;
  Result := true;
  tbInfo := @tblInfo[tbl_cfg_exchg_glob];
  SetFldPfx(tbInfo.pfx);
  qry := CreateQuery(Cfg_DB);

  qry.SQL.Add('DROP PROCEDURE ' + StoredProcName);
  try
    qry.ExecSql;
  except
    Result := false;
  end;

  qry.connection.Commit;

  with qry do
  begin
  //  ParamCheck := false;
    Close;
    SQL.Clear;
    if IniAppGlobals.DownloadTo = '2' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add(' ( IDENTIFIER INTEGER )');
      SQL.Add(' RETURNS (');
      SQL.Add('ISOPEN CHAR(1)');
      SQL.Add(')');
      SQL.Add(' AS ');
      SQL.Add(' DECLARE VARIABLE SrvOn integer;');
      SQL.Add(' begin');
      SQL.Add('  ISOPEN = ''1'';');
      SQL.Add('  SELECT count(*) FROM ' + tbInfo.GetTableName);
      SQL.Add('  WHERE CEG_SL_OP = ''1'' and CEG_IDENTIFIER = :IDENTIFIER into :SrvOn;');
      SQL.Add('  if (SrvOn = 0) then');
      SQL.Add('    ISOPEN = ''0'';');
      SQL.Add(' end;');
    end
    else if IniAppGlobals.DownloadTo = '0' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add(' (IN IDENTIFIER INTEGER ,');
      SQL.Add(' OUT ISOPEN CHAR(1)');
      SQL.Add(')');
      SQL.Add(' LANGUAGE SQL ');
      SQL.Add(' BEGIN ');
      SQL.Add(' DECLARE SrvOn integer;');
      SQL.Add(' SET ISOPEN = ''1'';');
      SQL.Add(' select count(1) into SrvOn from ' + tbInfo.GetTableName);
      SQL.Add('  WHERE CEG_SL_OP = ''1'' and CEG_IDENTIFIER = IDENTIFIER;');
      SQL.Add('  if (SrvOn = 0) then');
      SQL.Add('    SET ISOPEN = ''0'';');
      SQL.Add('  end if;');
      SQL.Add(' end');
    end
    else if IniAppGlobals.DownloadTo = '1' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add(' ( IDENTIFIER IN INTEGER ,');
      SQL.Add(' ISOPEN OUT CHAR');
      SQL.Add(')');
      SQL.Add(' AS ');
      SQL.Add(' BEGIN ');
      SQL.Add(' DECLARE SrvOn integer;');
      SQL.Add(' BEGIN ');
      SQL.Add('  ISOPEN := ''1'';');
      SQL.Add('  select count(1) into SrvOn from ' + tbInfo.GetTableName);
      SQL.Add('  WHERE CEG_SL_OP = ''1'' and CEG_IDENTIFIER = IDENTIFIER;');
      SQL.Add('  if (SrvOn = 0) then');
      SQL.Add('    ISOPEN := ''0'';');
      SQL.Add('  end if;');
      SQL.Add(' END; ');
      SQL.Add(' end;');
    end;

    prepare;
    ExecSql;
    Close;
    SQL.Clear;

  end;
  qry.connection.Commit;
  qry.Free;       //Vinc
//  trs.Free;

end;


function SP_CLIENT_UPDATE_DATA : boolean;
var
  StoredProc: TMqmStoredProc;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CSevCngDataBase
  else
    StoredProcName := 'SCDC_' + CSevCngDataBase;
  Result := true;

  StoredProc := CreateStoredProc(Cfg_DB);
  StoredProc.StoredProcName := StoredProcName;
  StoredProc.Connection.StartTransaction;

//  try
    with StoredProc do
    begin
      Prepare;
      ExecProc;
      unprepare
    end;
//  except
//  end;

  StoredProc.Connection.Commit;
  StoredProc.Free;
end;

//----------------------------------------------------------------------------//

function SP_ACTIVE_WRKST(Wrkst: string): boolean;
var
  StoredProc: TMqmStoredProc;
  StoredProcName : string;
begin
  Result := false;

  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CCfgActWrcst
  else
    StoredProcName := 'SCDC_' + CCfgActWrcst;

  StoredProc := CreateStoredProc(Cfg_DB);
  StoredProc.StoredProcName := StoredProcName;
  StoredProc.Connection.StartTransaction;
  try
    with StoredProc do
    begin
      Prepare;
      ParamByName('WKSTCODE').AsString := Wrkst;
      ParamByName('IDENTIFIER').Value := IniAppGlobals.Identifier;
      ExecProc;
      if ParamByName('Exist').AsString = '1' then
        Result := true;
      unprepare;
    end
  except
    Result := false;
  end;

  StoredProc.Connection.Commit;
  StoredProc.Free;
end;

//----------------------------------------------------------------------------//

procedure CrtProcAskPoll;
var
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CCfgAskPoll
  else
    StoredProcName := 'SCDC_' + CCfgAskPoll;
  qry := CreateQuery(Cfg_DB);
  tbInfo := @tblInfo[tbl_cfg_exchg_wkst];
  SetFldPfx(tbInfo.pfx);

  qry.SQL.Add('DROP PROCEDURE ' + StoredProcName);
  try
    qry.ExecSql
  except
  end;

  qry.connection.Commit;

  with qry do
  begin

    Close;
    SQL.Clear;
    if IniAppGlobals.DownloadTo = '2' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add('AS');
      SQL.Add('BEGIN');
      SQL.Add('  post_event ''' + EVT_POLL + ''';');
      SQL.Add('END');
    end
    else if IniAppGlobals.DownloadTo = '0' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add('BEGIN');
      SQL.Add('CALL DBMS_ALERT.SIGNAL(''' + EVT_POLL  + ''' , ''123'');');
      SQL.Add('COMMIT;');
      SQL.Add('END');
    end
    else if IniAppGlobals.DownloadTo = '1' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add('IS');
      SQL.Add('BEGIN');
      SQL.Add('  SYS.DBMS_ALERT.SIGNAL(''' + EVT_POLL  + ''' , ''123'');');
      SQL.Add('END;');
    end;

   // need to run sql command line
   // write: connect
   // Enter user name: sys as sysdba (whicj is the hieher level user)
   // Enter password : (empty)
   // you should get connected

   //  The reall systex to be used
   // GRANT EXECUTE ON sys.dbms_alert TO public;
{
drop public synonym dbms_system;

 CREATE PUBLIC SYNONYM dbms_system FOR dbms_alert;
 GRANT EXECUTE ON dbms_system TO APPS;
 }
    prepare;
    ExecSql;
    Close
  end;
  qry.connection.Commit;
  qry.Free;

end;

//----------------------------------------------------------------------------//

procedure CrtProcAskPollSrv;
var
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CCfgAskPollSRV
  else
    StoredProcName := 'SCDC_' + CCfgAskPollSRV;
  qry := CreateQuery(Cfg_DB);
  tbInfo := @tblInfo[tbl_cfg_exchg_wkst];
  SetFldPfx(tbInfo.pfx);

  qry.SQL.Add('DROP PROCEDURE ' + StoredProcName);
  try
    qry.ExecSql
  except
  end;

  qry.connection.Commit;

  with qry do
  begin

    Close;
    SQL.Clear;
    if IniAppGlobals.DownloadTo = '2' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add('AS');
      SQL.Add('BEGIN');
      SQL.Add('  post_event ''' + EVT_POLL_SRV + ''';');
      SQL.Add('END');
    end
    else if IniAppGlobals.DownloadTo = '0' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add('BEGIN');
      SQL.Add('CALL DBMS_ALERT.SIGNAL(''' + EVT_POLL_SRV  + ''' , ''123'');');
      SQL.Add('END');
    end
    else if IniAppGlobals.DownloadTo = '1' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add('IS');
      SQL.Add('BEGIN');
      SQL.Add('  SYS.DBMS_ALERT.SIGNAL(''' + EVT_POLL_SRV  + ''' , ''123'');');
      SQL.Add('END;');
    end;

   // need to run sql command line
   // write: connect
   // Enter user name: sys as sysdba (whicj is the hieher level user)
   // Enter password : (empty)
   // you should get connected

   //  The reall systex to be used
   // GRANT EXECUTE ON sys.dbms_alert TO public;
{
drop public synonym dbms_system;

 CREATE PUBLIC SYNONYM dbms_system FOR dbms_alert;
 GRANT EXECUTE ON dbms_system TO APPS;
 }
    prepare;
    ExecSql;
    Close
  end;
  qry.connection.Commit;
  qry.Free;
end;

//----------------------------------------------------------------------------//

function SP_ASK_POLL: boolean;
var
  StoredProc: TMqmStoredProc;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CCfgAskPoll
  else
    StoredProcName := 'SCDC_' + CCfgAskPoll;
  StoredProc := CreateStoredProc(Cfg_DB);
  StoredProc.StoredProcName := StoredProcName;
  // for db2 :
  // no need transaction since it was handled in AskPoll stored procedure creation for db2
  // follow by "COMMIT;"
  if IniAppGlobals.DownloadTo = '0' then
  begin
  //  StoredProc.Connection.StartTransaction;
    try
      with StoredProc do
      begin
        // Prepare;       might causing to lock table 19.11.2025
        ExecProc;
        // unprepare;     might causing to lock table 19.11.2025
      end;
    except
      StoredProcName := 'test';
    end;

  //StoredProc.Connection.Commit;


  end
  else
  begin
    StoredProc.Connection.StartTransaction;
    try
      with StoredProc do
      begin
        Prepare;
        ExecProc;
        unprepare;
      end;
    except
      StoredProcName := 'test';
    end;

    StoredProc.Connection.Commit;

  end;


  StoredProc.Free;

end;

//----------------------------------------------------------------------------//

function SP_ASK_POLL_SERVER : boolean;
var
  StoredProc: TMqmStoredProc;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CCfgAskPollSRV
  else
    StoredProcName := 'SCDC_' + CCfgAskPollSRV;
  StoredProc := CreateStoredProc(Cfg_DB);
  StoredProc.StoredProcName := StoredProcName;
  StoredProc.Connection.StartTransaction;
//  try
    with StoredProc do
    begin
      Prepare;
      ExecProc;
      unprepare;
    end;
//  except
//    StoredProcName := 'test';
//  end;

  StoredProc.Connection.Commit;

  StoredProc.Free;
end;

//----------------------------------------------------------------------------//

procedure CrtProcCheckPoll;
var
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CCfgChkPoll
  else
    StoredProcName := 'SCDC_' + CCfgChkPoll;
  qry := CreateQuery(Cfg_DB);
  tbInfo := @tblInfo[tbl_cfg_exchg_wkst];
  SetFldPfx(tbInfo.pfx);

  qry.SQL.Add('DROP PROCEDURE ' + StoredProcName);
  try
    qry.ExecSql
  except
  end;

  qry.connection.Commit;

  with qry do
  begin
  //  ParamCheck := false;
    Close;
    SQL.Clear;

    if IniAppGlobals.DownloadTo = '2' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add(' ( IDENTIFIER INTEGER) ');
      // In parameters
      SQL.Add('AS');
      SQL.Add('BEGIN');
      SQL.Add('  DELETE FROM ' + tbInfo.GetTableName);
    //    SQL.Add(' WHERE CEW_POLL = ''0'' AND (CEW_OP = ''R'' OR CEW_OP = ''W'');');
      SQL.Add(' WHERE CEW_POLL = ''0'' AND (CEW_OP <> '' '') AND CEW_IDENTIFIER = :IDENTIFIER;');
    //    SQL.Add(' WHERE CEW_POLL = ''0'' AND (CEW_OP = ''>'');');
      SQL.Add('END');
    end
    else if IniAppGlobals.DownloadTo = '0' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add(' (IN IDENTIFIER INTEGER) ');
      SQL.Add('LANGUAGE SQL ');
      SQL.Add('BEGIN');
      SQL.Add('  DELETE FROM ' + tbInfo.GetTableName);
      SQL.Add(' WHERE CEW_POLL = ''0'' AND (CEW_OP <> '' '') AND CEW_IDENTIFIER = IDENTIFIER;');
      SQL.Add('END');
    end
    else if IniAppGlobals.DownloadTo = '1' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add(' ( IDENTIFIER IN INTEGER) ');
      SQL.Add('AS ');
      SQL.Add('BEGIN');
      SQL.Add('  DELETE FROM ' + tbInfo.GetTableName);
      SQL.Add(' WHERE CEW_POLL = ''0'' AND (CEW_OP <> '' '') AND CEW_IDENTIFIER = IDENTIFIER;');
      SQL.Add('END;');
    end;

    prepare;
    ExecSql;
    Close
  end;
  qry.connection.Commit;
  qry.Free;

end;

//----------------------------------------------------------------------------//

procedure CrtProcCheckPollDellOldStation;
var
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CCfgChkPollDelOldStation
  else
    StoredProcName := 'SCDC_' + CCfgChkPollDelOldStation;
  qry := CreateQuery(Cfg_DB);
  tbInfo := @tblInfo[tbl_cfg_exchg_wkst];
  SetFldPfx(tbInfo.pfx);

  qry.SQL.Add('DROP PROCEDURE ' + StoredProcName);
  try
    qry.ExecSql
  except
  end;

  qry.connection.Commit;

  with qry do
  begin
  //  ParamCheck := false;
    Close;
    SQL.Clear;
    if IniAppGlobals.DownloadTo = '2' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add(' ( IDENTIFIER INTEGER) ');
      // In parameters
      SQL.Add('AS');
      SQL.Add('BEGIN');
      SQL.Add('  DELETE FROM ' + tbInfo.GetTableName);
  //    SQL.Add(' WHERE CEW_POLL = ''0'' AND (CEW_OP = ''R'' OR CEW_OP = ''W'');');
      SQL.Add(' WHERE CEW_POLL = ''0'' AND (CEW_OP = '' '') AND CEW_IDENTIFIER = :IDENTIFIER;');
  //    SQL.Add(' WHERE CEW_POLL = ''0'' AND (CEW_OP = ''>'');');
      SQL.Add('END');
    end
    else if IniAppGlobals.DownloadTo = '0' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add(' (IN IDENTIFIER INTEGER) ');
      SQL.Add('LANGUAGE SQL ');
      SQL.Add('BEGIN');
      SQL.Add('  DELETE FROM ' + tbInfo.GetTableName);
      SQL.Add(' WHERE CEW_POLL = ''0'' AND (CEW_OP = '' '') AND CEW_IDENTIFIER = IDENTIFIER;');
      SQL.Add('END');
    end
    else if IniAppGlobals.DownloadTo = '1' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add(' ( IDENTIFIER IN INTEGER) ');
      SQL.Add('AS ');
      SQL.Add('BEGIN');
      SQL.Add('  DELETE FROM ' + tbInfo.GetTableName);
      SQL.Add(' WHERE CEW_POLL = ''0'' AND (CEW_OP = '' '') AND CEW_IDENTIFIER = IDENTIFIER;');
      SQL.Add('END;');
    end;

    prepare;
    ExecSql;
    Close
  end;
  qry.connection.Commit;
  qry.Free;

end;

//----------------------------------------------------------------------------//

function SP_CHECK_POLL: boolean;
var
  StoredProc: TMqmStoredProc;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CCfgChkPoll
  else
    StoredProcName := 'SCDC_' + CCfgChkPoll;
  StoredProc := CreateStoredProc(Cfg_DB);
  StoredProc.StoredProcName := StoredProcName;
  StoredProc.Connection.StartTransaction;
  with StoredProc do
  begin
    Prepare;
    ParamByName('IDENTIFIER').Value := IniAppGlobals.Identifier;
    ExecProc;
    unprepare;
  end;

  StoredProc.Connection.Commit;

  StoredProc.Free;
end;

//----------------------------------------------------------------------------//

function SP_CHECK_POLL_DLT_OLD_STATIONS : boolean;
var
  StoredProc: TMqmStoredProc;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CCfgChkPollDelOldStation
  else
    StoredProcName := 'SCDC_' + CCfgChkPollDelOldStation;
  Result := true;

  StoredProc := CreateStoredProc(Cfg_DB);
  StoredProc.StoredProcName := StoredProcName;
  StoredProc.Connection.StartTransaction;

  try
    with StoredProc do
    begin
      Prepare;
      ParamByName('IDENTIFIER').Value := IniAppGlobals.Identifier;
      ExecProc;
      unprepare
    end
  except
    Result := false
  end;

  StoredProc.Connection.Commit;

  StoredProc.Free;
end;

//----------------------------------------------------------------------------//

procedure CrtProcAswPoll;
begin
end;

//----------------------------------------------------------------------------//

function SP_ASW_POLL(Wrkst: string): boolean;
begin
  Result := true
end;

//----------------------------------------------------------------------------//

procedure CrtProcSrvLoadStatus;
var
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CSrvLoadStatus
  else
    StoredProcName := 'SCDC_' + CSrvLoadStatus;
  tbInfo := @tblInfo[tbl_cfg_exchg_glob];
  SetFldPfx(tbInfo.pfx);
  qry := CreateQuery(Cfg_DB);

  qry.SQL.Add('DROP PROCEDURE ' + StoredProcName);
  try
    qry.ExecSql;
  except
  end;

  qry.connection.Commit;

  with qry do
  begin
  //  ParamCheck := false;
    Close;
    SQL.Clear;

    if IniAppGlobals.DownloadTo = '2' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName + '(');
    //In parameters
      SQL.Add('stat CHAR(1), IDENTIFIER INTEGER');
      SQL.Add(')');
      SQL.Add(' AS ');
      SQL.Add(' BEGIN ');
      SQL.Add('  UPDATE ' + tbInfo.GetTableName + ' SET CEG_SL_ON = :stat where CEG_IDENTIFIER = :IDENTIFIER;');
      SQL.Add('  post_event ''' + EVT_NEWSTATUS + ''';');
      SQL.Add(' END');
    end
    else if IniAppGlobals.DownloadTo = '0' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName + '(');
    //In parameters
      SQL.Add(' IN stat CHAR(1),IN IDENTIFIER INTEGER');
      SQL.Add(')');
      SQL.Add('LANGUAGE SQL ');
      SQL.Add(' BEGIN ');
      SQL.Add('  UPDATE ' + tbInfo.GetTableName + ' SET CEG_SL_ON = stat where CEG_IDENTIFIER = IDENTIFIER;');
      SQL.Add('  CALL DBMS_ALERT.SIGNAL(''' + EVT_NEWSTATUS  + ''' , ''123'');');
      SQL.Add('END');
    end
    else if IniAppGlobals.DownloadTo = '1' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName + '(');
    //In parameters
      SQL.Add(' stat IN CHAR, IDENTIFIER IN INTEGER');
      SQL.Add(')');
      SQL.Add(' AS ');
      SQL.Add(' BEGIN ');
      SQL.Add('  UPDATE ' + tbInfo.GetTableName + ' SET CEG_SL_ON = stat where CEG_IDENTIFIER = IDENTIFIER;');
      SQL.Add('  DBMS_ALERT.SIGNAL(''' + EVT_NEWSTATUS  + ''' , ''123'');');
      SQL.Add('END;');
    end;

    prepare;
    ExecSql;
    Close;
    SQL.Clear;

  end;
  qry.connection.Commit;
  qry.Free;


end;

//----------------------------------------------------------------------------//

procedure SRVLOAD_SETSTAT_OPENED_OR_CLOSED(st: string);
var
  StoredProc: TMqmStoredProc;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CSrvLoadSetStatusOpenedOrClosed
  else
    StoredProcName := 'SCDC_' + CSrvLoadSetStatusOpenedOrClosed;
  StoredProc := CreateStoredProc(Cfg_DB);
  StoredProc.StoredProcName := StoredProcName;
  StoredProc.Connection.StartTransaction;

//  try
    with StoredProc do
    begin
      Prepare;
      ParamByName('stat').AsString := st;
      ParamByName('IDENTIFIER').Value := IniAppGlobals.Identifier;
      ExecProc;
      unprepare
    end;
//  except
//  end;

  StoredProc.Connection.Commit;

  StoredProc.Free;
end;

//----------------------------------------------------------------------------//

procedure SRVLOAD_SETSTAT(st: string);
var
  StoredProc: TMqmStoredProc;
begin
  StoredProc := CreateStoredProc(Cfg_DB);
  StoredProc.StoredProcName := CSrvLoadStatus;
  StoredProc.Connection.StartTransaction;

//  try
    with StoredProc do
    begin
      Prepare;
      ParamByName('stat').AsString := st;
      ParamByName('IDENTIFIER').Value := IniAppGlobals.Identifier;
      ExecProc;
      unprepare
    end;
//  except
//  end;

  StoredProc.Connection.Commit;

  StoredProc.Free;
end;

//----------------------------------------------------------------------------//

procedure SP_SRVLOAD_RUNNING;
begin
  SRVLOAD_SETSTAT('1');
end;

//----------------------------------------------------------------------------//

procedure SP_SRVLOAD_OFF;
begin
  SRVLOAD_SETSTAT('0');
end;

//----------------------------------------------------------------------------//

procedure SP_SRVLOAD_OPEN;
begin
  SRVLOAD_SETSTAT_OPENED_OR_CLOSED('1');
end;

//----------------------------------------------------------------------------//

procedure SP_SRVLOAD_CLOSE;
begin
  SRVLOAD_SETSTAT_OPENED_OR_CLOSED('0');
end;

//----------------------------------------------------------------------------//

procedure CrtProcGetStatus;
var
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
  StoredProcName : string;
begin
  qry := CreateQuery(Cfg_DB);
  tbInfo := @tblInfo[tbl_cfg_exchg_wkst];
  SetFldPfx(tbInfo.pfx);

  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CCfgGetStatus
  else
    StoredProcName := 'SCDC_' + CCfgGetStatus;

  qry.SQL.Add('DROP PROCEDURE ' + StoredProcName);
  try
    qry.ExecSql
  except
  end;

  qry.connection.Commit;

  with qry do
  begin
//    ParamCheck := false;
    Close;
    SQL.Clear;

    if IniAppGlobals.DownloadTo = '2' then
    begin

      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add(' ( IDENTIFIER INTEGER) ');
      SQL.Add(' RETURNS (');

    //Out Parameters
      SQL.Add('SRVLOAD_ON CHAR(1),CAN_READ CHAR(1),CAN_WRITE CHAR(1)');
      SQL.Add(')');
      SQL.Add('AS');
      SQL.Add('DECLARE VARIABLE num integer; ');
      SQL.Add('BEGIN');
      SQL.Add('  select CEG_SL_ON from EXCG_GLOB WHERE CEG_IDENTIFIER = :IDENTIFIER into :SRVLOAD_ON;');
      SQL.Add('');
      SQL.Add('  select count(*) from EXCG_WKST where CEW_OP <> '' '' and CEW_IDENTIFIER = :IDENTIFIER into :num;');
      SQL.Add('  if (num > 0) then');
      SQL.Add('    CAN_WRITE = ''0'';');
      SQL.Add('  else');
      SQL.Add('    CAN_WRITE = ''1'';');
      SQL.Add('');
      SQL.Add('  select count(*) from EXCG_WKST where CEW_OP = ''W'' and CEW_IDENTIFIER = :IDENTIFIER into :num;');
      SQL.Add('  if (num > 0) then');
      SQL.Add('    CAN_READ = ''0'';');
      SQL.Add('   else');
      SQL.Add('    CAN_READ = ''1'';');
      SQL.Add('END');

    end
    else if IniAppGlobals.DownloadTo = '0' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName + ' (IN IDENTIFIER INTEGER, ');
    //Out Parameters
      SQL.Add(' OUT SRVLOAD_ON CHAR(1),CAN_READ CHAR(1),CAN_WRITE CHAR(1)');
      SQL.Add(') ');
      SQL.Add('LANGUAGE SQL ');
      SQL.Add('BEGIN');
      SQL.Add('DECLARE num integer;');
      SQL.Add(' select count(1) into SRVLOAD_ON from SCDC_EXCG_GLOB where CEG_SL_ON = ''1'' and CEG_IDENTIFIER = IDENTIFIER;');
      SQL.Add(' select count(1) into num from ' + tbInfo.GetTableName + ' where CEW_OP <> '' '' and CEW_IDENTIFIER = IDENTIFIER;');
      SQL.Add(' if (num > 0) then');
      SQL.Add('   SET CAN_WRITE = ''0'';');
      SQL.Add(' else');
      SQL.Add('   SET CAN_WRITE = ''1'';');
      SQL.Add(' end if; ');
      SQL.Add(' select count(1) into num from ' + tbInfo.GetTableName + ' where CEW_OP = ''W'' and CEW_IDENTIFIER = IDENTIFIER;');
      SQL.Add(' if (num > 0) then');
      SQL.Add('   SET CAN_READ = ''0'';');
      SQL.Add(' else');
      SQL.Add('   SET CAN_READ = ''1'';');
      SQL.Add(' end if; ');
      SQL.Add('END');
    end
    else if IniAppGlobals.DownloadTo = '1' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName + ' (');
    //Out Parameters
      SQL.Add(' IDENTIFIER IN INTEGER, SRVLOAD_ON OUT CHAR,CAN_READ OUT CHAR,CAN_WRITE OUT CHAR');
      SQL.Add(') ');
      SQL.Add('AS ');
      SQL.Add('BEGIN');
      SQL.Add('DECLARE num integer;');
      SQL.Add(' BEGIN');
      SQL.Add(' select count(1) into SRVLOAD_ON from SCDC_EXCG_GLOB where CEG_SL_ON = ''1'' and CEG_IDENTIFIER = IDENTIFIER;');
      SQL.Add(' select count(1) into num from ' + tbInfo.GetTableName + ' where CEW_OP <> '' '' and CEW_IDENTIFIER = IDENTIFIER;');
      SQL.Add(' if (num > 0) then');
      SQL.Add('   CAN_WRITE := ''0'';');
      SQL.Add(' else');
      SQL.Add('   CAN_WRITE := ''1'';');
      SQL.Add(' end if; ');
      SQL.Add(' select count(1) into num from ' + tbInfo.GetTableName + ' where CEW_OP = ''W'' and CEW_IDENTIFIER = IDENTIFIER;');
      SQL.Add(' if (num > 0) then');
      SQL.Add('   CAN_READ := ''0'';');
      SQL.Add(' else');
      SQL.Add('   CAN_READ := ''1'';');
      SQL.Add(' end if; ');
      SQL.Add('END;');
      SQL.Add('END;');
    end;

    prepare;
    ExecSql;
    Close
  end;
  qry.connection.Commit;
  qry.Free;       //Vinc

end;

//----------------------------------------------------------------------------//

procedure CrtProcIsExistClient;
var
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
  StoredProcName : string;
begin
  qry := CreateQuery(Cfg_DB);
  tbInfo := @tblInfo[tbl_cfg_exchg_wkst];
  SetFldPfx(tbInfo.pfx);

  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CCfgIsExistClient
  else
    StoredProcName := 'SCDC_' + CCfgIsExistClient;

  qry.SQL.Add('DROP PROCEDURE ' + StoredProcName);
  try
    qry.ExecSql;
  except
  end;

  qry.connection.Commit;

  with qry do
  begin
  //  ParamCheck := false;
    Close;
    SQL.Clear;

    if IniAppGlobals.DownloadTo = '2' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName + ' ( IDENTIFIER INTEGER ) RETURNS (');
    //Out Parameters
      SQL.Add('isOk CHAR(1)');
      SQL.Add(')');
      SQL.Add('AS');
      SQL.Add('DECLARE VARIABLE num integer;');
      SQL.Add('BEGIN');
      SQL.Add('  select count(*) from ' + tbInfo.GetTableName + ' where CEW_WKST_CODE <> ''SERVER'' and CEW_POLL = ''1'' and CEW_IDENTIFIER = :IDENTIFIER into :num;');
      SQL.Add('  if (num > 0) then');
      SQL.Add('    isOk = ''1'';');
      SQL.Add('  else');
      SQL.Add('    isOk = ''0'';');
      SQL.Add('END');
    end
    else if IniAppGlobals.DownloadTo = '0' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName + '(IN IDENTIFIER INTEGER, ');
    //Out Parameters
      SQL.Add('OUT isOk CHAR(1)');
      SQL.Add(')');
      SQL.Add('LANGUAGE SQL ');
      SQL.Add('BEGIN');
      SQL.Add('DECLARE num integer; ');
      SQL.Add('select count(1) into num from ' + tbInfo.GetTableName + ' where CEW_WKST_CODE <> ''SERVER'' and CEW_POLL = ''1'' and CEW_IDENTIFIER = IDENTIFIER;');
      SQL.Add('if (num > 0) then');
      SQL.Add('  SET isOk = ''1'';');
      SQL.Add('else');
      SQL.Add('  SET isOk = ''0'';');
      SQL.Add('End if;');
      SQL.Add('END');
    end
    else if IniAppGlobals.DownloadTo = '1' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName + '( IDENTIFIER IN INTEGER, ');
    //Out Parameters
      SQL.Add('isOk OUT CHAR');
      SQL.Add(')');
      SQL.Add('AS ');
      SQL.Add('BEGIN');
      SQL.Add('DECLARE num integer; ');
      SQL.Add('  BEGIN');
      SQL.Add('select count(1) into num from ' + tbInfo.GetTableName + ' where CEW_WKST_CODE <> ''SERVER'' and CEW_POLL = ''1'' and CEW_IDENTIFIER = IDENTIFIER;');
      SQL.Add('if (num > 0) then');
      SQL.Add('  isOk := ''1'';');
      SQL.Add('else');
      SQL.Add('  isOk := ''0'';');
      SQL.Add('End if;');
      SQL.Add('END;');
      SQL.Add('END;');
    end;

    prepare;
    ExecSql;
    Close
  end;

  qry.connection.Commit;
  qry.Free;       //Vinc

end;

//----------------------------------------------------------------------------//

procedure CrtUpdateClient;
var
  qry:    TMqmQuery;
  StoredProcName : string;
begin

  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CCfgUpdateClient
  else
    StoredProcName := 'SCDC_' + CCfgUpdateClient;

  qry := CreateQuery(Cfg_DB);
  qry.SQL.Add('DROP PROCEDURE ' + StoredProcName);
  try
    qry.ExecSql;
  except
  end;
  qry.connection.Commit;

  with qry do
  begin
//    ParamCheck := false;
    Close;
    SQL.Clear;

    if IniAppGlobals.DownloadTo = '2' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add('AS');
      SQL.Add('BEGIN');
      SQL.Add('  post_event ''' + EVT_UPDATE + ''';');
      SQL.Add('END');
    end
    else if IniAppGlobals.DownloadTo = '0' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add('BEGIN');
      SQL.Add('CALL DBMS_ALERT.SIGNAL(''' + EVT_UPDATE  + ''' , ''123'');');
      SQL.Add('END');
    end
    else if IniAppGlobals.DownloadTo = '1' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add('IS');
      SQL.Add('BEGIN');
      SQL.Add('  DBMS_ALERT.SIGNAL(''' + EVT_UPDATE  + ''' , ''123'');');
      SQL.Add('END;');
    end;

    prepare;
    ExecSql;
    Close;
    SQL.Clear;

  end;
  qry.connection.Commit;
  qry.Free;    //Vinc
end;

//----------------------------------------------------------------------------//

procedure CrtJobMsgEvent;
var
  qry:    TMqmQuery;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CCJobMsg
  else
    StoredProcName := 'SCDC_' + CCJobMsg;
  qry := CreateQuery(Cfg_DB);
  qry.SQL.Add('DROP PROCEDURE ' + StoredProcName);
  try
    qry.ExecSql;
  except
  end;

  qry.connection.Commit;

  with qry do
  begin
   // ParamCheck := false;
    Close;
    SQL.Clear;
    if IniAppGlobals.DownloadTo = '2' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add('AS');
      SQL.Add('BEGIN');
      SQL.Add('  post_event ''' + EVT_JOB_MSG + ''';');
      SQL.Add('END');
    end
    else if IniAppGlobals.DownloadTo = '0' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add('BEGIN');
      SQL.Add('CALL DBMS_ALERT.SIGNAL(''' + EVT_JOB_MSG  + ''' , ''123'');');
      SQL.Add('END');
    end
    else if IniAppGlobals.DownloadTo = '1' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add('IS');
      SQL.Add('BEGIN');
      SQL.Add(' DBMS_ALERT.SIGNAL(''' + EVT_JOB_MSG  + ''' , ''123'');');
      SQL.Add('END;');
    end;

    prepare;
    ExecSql;
    Close;
    SQL.Clear;

  end;
  qry.connection.Commit;
  qry.Free;    //Vinc

end;

//----------------------------------------------------------------------------//

procedure CrtSharedDataEvent;
var
  qry:    TMqmQuery;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CCSharedData
  else
    StoredProcName := 'SCDC_' + CCSharedData;

  qry := CreateQuery(Cfg_DB);

  qry.SQL.Add('DROP PROCEDURE ' + StoredProcName);
  try
    qry.ExecSql;
  except
  end;

  qry.connection.Commit;

  with qry do
  begin
   // ParamCheck := false;
    Close;
    SQL.Clear;
    if IniAppGlobals.DownloadTo = '2' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add('AS');
      SQL.Add('BEGIN');
      SQL.Add('  post_event ''' + EVT_SHARED_DATA + ''';');
      SQL.Add('END');
    end
    else if IniAppGlobals.DownloadTo = '0' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add('BEGIN');
      SQL.Add('CALL DBMS_ALERT.SIGNAL(''' + EVT_SHARED_DATA  + ''' , ''123'');');
      SQL.Add('END');
    end
    else if IniAppGlobals.DownloadTo = '1' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add('IS');
      SQL.Add('BEGIN');
      SQL.Add(' DBMS_ALERT.SIGNAL(''' + EVT_SHARED_DATA  + ''' , ''123'');');
      SQL.Add('END;');
    end;

    prepare;
    ExecSql;
    Close;
    SQL.Clear;

  end;
  qry.connection.Commit;
  qry.Free;

end;

//----------------------------------------------------------------------------//

function SP_GET_STATUS(Wrkst: string; var srvLoadOn, canRead, canWrite: boolean): boolean;
var
  StoredProc: TMqmStoredProc;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CCfgGetStatus
  else
    StoredProcName := 'SCDC_' + CCfgGetStatus;

  StoredProc := CreateStoredProc(Cfg_DB);
  StoredProc.StoredProcName := StoredProcName;
  StoredProc.Connection.StartTransaction;

//  try
    with StoredProc do
    begin
      Prepare;
      ParamByName('IDENTIFIER').Value := IniAppGlobals.Identifier;
      ExecProc;

      if ParamByName('SRVLOAD_ON').AsString = '1' then
        srvLoadOn := true
      else
        srvLoadOn := false;

      if ParamByName('CAN_READ').AsString = '1' then
        canRead := true
      else
        canRead := false;

      if ParamByName('CAN_WRITE').AsString = '1' then
        canWrite := true
      else
        canWrite := false;

      unprepare
    end;

    Result := true;
//  except
//    Result := false
//  end;

  StoredProc.Connection.Commit;

  StoredProc.Free;
end;

//---------------------------------$-------------------------------------------//

procedure CrtProcGetAccess;
var
  qry:    TMqmQuery;
  tbInfo : ^TTblInfo;
  StoredProcName : string;
begin
  qry := CreateQuery(Cfg_DB);
  tbInfo := @tblInfo[tbl_cfg_exchg_wkst];
  SetFldPfx(tbInfo.pfx);

  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CCfgGetAccess
  else
    StoredProcName := 'SCDC_' + CCfgGetAccess;

  qry.SQL.Add('DROP PROCEDURE ' + StoredProcName);
  try
    qry.ExecSql
  except
  end;

  qry.connection.Commit;

//  qry.Transaction.StartTransaction;

  with qry do
  begin
  //  ParamCheck := false;
    Close;
    SQL.Clear;
    if IniAppGlobals.DownloadTo = '2' then
    begin

      SQL.Add('CREATE PROCEDURE ' + StoredProcName + ' (');
    //In parameters
      SQL.Add('WKSTCODE VARCHAR(10), OP CHAR(1), IDENTIFIER Integer');
      SQL.Add(') RETURNS (');

    //Out Parameters
      SQL.Add('isOk CHAR(1)');
      SQL.Add(')');
      SQL.Add('AS');
      SQL.Add('DECLARE VARIABLE num integer;');
      SQL.Add('BEGIN');
  //  add new record if the record client was deleted
  ///////////////////////////////////////////////////////////////////
      SQL.Add('  select count(*) from ' + tbInfo.GetTableName +  ' where CEW_WKST_CODE = :WKSTCODE and CEW_IDENTIFIER = :IDENTIFIER into :num;');
      SQL.Add('  if (num = 0) then');
      SQL.Add('    insert into ' + tbInfo.GetTableName + ' (' + CreatePfxFld(fli_wkstCode) +
                   ',CEW_CONNECT,CEW_LAST_UPD,CEW_OP,CEW_POLL,CEW_IDENTIFIER) values (:WKSTCODE,CURRENT_TIMESTAMP,0,'' '',''1'',:IDENTIFIER);');
  ///////////////////////////////////////////////////////////////////
      SQL.Add('  isOk = ''0'';');
      SQL.Add('  if (OP = ''W'') then');
      SQL.Add('  begin');
      SQL.Add('    isOk = ''1'';');
      SQL.Add('    select count(*) from ' + tbInfo.GetTableName + ' where CEW_OP <> '' and CEW_IDENTIFIER = :IDENTIFIER ''');
      SQL.Add('      and CEW_WKST_CODE <> :WKSTCODE into :num;');
      SQL.Add('    if (num > 0) then isOk = ''0'';');
      SQL.Add('    else');
      SQL.Add('    begin');
      SQL.Add('      update ' + tbInfo.GetTableName + ' set CEW_OP = ''W'' where CEW_WKST_CODE = :WKSTCODE and CEW_IDENTIFIER = :IDENTIFIER;');
      SQL.Add('      select count(*) from ' + tbInfo.GetTableName + ' where CEW_OP <> '' ''');
      SQL.Add('          and CEW_WKST_CODE <> :WKSTCODE into :num;');
      SQL.Add('      if (num > 0) then');
      SQL.Add('      begin');
      SQL.Add('         update ' + tbInfo.GetTableName + ' set CEW_OP = '' '' where CEW_WKST_CODE = :WKSTCODE and CEW_IDENTIFIER = :IDENTIFIER;');
      SQL.Add('         isOk = ''0'';');
      SQL.Add('      end');
      SQL.Add('    end');
      SQL.Add('  end');

      SQL.Add('  if (OP = ''S'') then');
      SQL.Add('  begin');
      SQL.Add('    isOk = ''1'';');
      SQL.Add('    select count(*) from ' + tbInfo.GetTableName + ' where CEW_OP <> '' and CEW_IDENTIFIER = :IDENTIFIER ''');
      SQL.Add('       and CEW_POLL <> ''R'' and CEW_WKST_CODE <> :WKSTCODE into :num;');
      SQL.Add('    if (num > 0) then isOk = ''0'';');
      SQL.Add('    else');
      SQL.Add('    begin');
      SQL.Add('      update ' + tbInfo.GetTableName + ' set CEW_OP = ''S'' where CEW_WKST_CODE = :WKSTCODE and CEW_IDENTIFIER = :IDENTIFIER;');
      SQL.Add('      select count(*) from ' + tbInfo.GetTableName + ' where CEW_OP <> '' ''');
      SQL.Add('        and CEW_POLL <> ''R'' and CEW_WKST_CODE <> :WKSTCODE and CEW_IDENTIFIER = :IDENTIFIER into :num;');
      SQL.Add('      if (num > 0) then');
      SQL.Add('      begin');
      SQL.Add('         update ' + tbInfo.GetTableName + ' set CEW_OP = '' '' where CEW_WKST_CODE = :WKSTCODE and CEW_IDENTIFIER = :IDENTIFIER;');
      SQL.Add('         isOk = ''0'';');
      SQL.Add('      end');
      SQL.Add('    end');
      SQL.Add('  end');

      SQL.Add('  if (OP = ''L'') then');
      SQL.Add('  begin');
      SQL.Add('    isOk = ''1'';');
      SQL.Add('    select count(*) from ' + tbInfo.GetTableName + ' where CEW_OP <> '' and CEW_IDENTIFIER = :IDENTIFIER ''');
      SQL.Add('       and CEW_POLL <> ''R'' and CEW_POLL <> ''L'' and CEW_WKST_CODE <> :WKSTCODE into :num;');
      SQL.Add('    if (num > 0) then isOk = ''0'';');
      SQL.Add('    else');
      SQL.Add('    begin');
      SQL.Add('      update ' + tbInfo.GetTableName + ' set CEW_OP = ''L'' where CEW_WKST_CODE = :WKSTCODE and CEW_IDENTIFIER = :IDENTIFIER;');
      SQL.Add('      select count(*) from ' + tbInfo.GetTableName + ' where CEW_OP <> '' and CEW_IDENTIFIER = :IDENTIFIER ''');
      SQL.Add('       and CEW_POLL <> ''R'' and CEW_POLL <> ''L'' and CEW_WKST_CODE <> :WKSTCODE into :num;');
      SQL.Add('      if (num > 0) then');
      SQL.Add('      begin');
      SQL.Add('         update ' + tbInfo.GetTableName + ' set CEW_OP = '' '' where CEW_WKST_CODE = :WKSTCODE and CEW_IDENTIFIER = :IDENTIFIER;');
      SQL.Add('         isOk = ''0'';');
      SQL.Add('      end');
      SQL.Add('    end');
      SQL.Add('  end');

      SQL.Add('  if (OP = ''R'') then');
      SQL.Add('  begin');
      SQL.Add('    isOk = ''1'';');
      SQL.Add('    select count(*) from ' + tbInfo.GetTableName + ' where CEW_OP <> '' and CEW_IDENTIFIER = :IDENTIFIER ''');
      SQL.Add('       and CEW_POLL <> ''R'' and CEW_POLL <> ''S'' and CEW_POLL <> ''L'' and CEW_WKST_CODE <> :WKSTCODE into :num;');
      SQL.Add('    if (num > 0) then isOk = ''0'';');
      SQL.Add('    else');
      SQL.Add('    begin');
      SQL.Add('      update ' + tbInfo.GetTableName + ' set CEW_OP = ''R'' where CEW_WKST_CODE = :WKSTCODE and CEW_IDENTIFIER = :IDENTIFIER;');
      SQL.Add('      select count(*) from ' + tbInfo.GetTableName + ' where CEW_OP <> '' ''');
      SQL.Add('       and CEW_POLL <> ''R'' and CEW_POLL <> ''S'' and CEW_POLL <> ''L'' and CEW_IDENTIFIER = :IDENTIFIER and CEW_WKST_CODE <> :WKSTCODE into :num;');
      SQL.Add('      if (num > 0) then');
      SQL.Add('      begin');
      SQL.Add('         update ' + tbInfo.GetTableName + ' set CEW_OP = '' '' where CEW_WKST_CODE = :WKSTCODE and CEW_IDENTIFIER = :IDENTIFIER;');
      SQL.Add('         isOk = ''0'';');
      SQL.Add('      end');
      SQL.Add('    end');
      SQL.Add('  end');

      SQL.Add('END');

    end
    else if IniAppGlobals.DownloadTo = '0' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName + ' (');
      SQL.Add('IN WKSTCODE VARCHAR(10), OP CHAR(1), IDENTIFIER Integer, Out isOk CHAR(1)) ');
      SQL.Add('LANGUAGE SQL ');
      SQL.Add('BEGIN ');
      SQL.Add('DECLARE num integer; ');
      SQL.Add('select count(1) into num from ' + tbInfo.GetTableName +  ' where CEW_WKST_CODE = WKSTCODE and CEW_IDENTIFIER = IDENTIFIER;');
      SQL.Add('if (num = 0) then ');
      SQL.Add('insert into ' + tbInfo.GetTableName + ' (' + CreatePfxFld(fli_wkstCode) +
                   ',CEW_CONNECT,CEW_LAST_UPD,CEW_OP,CEW_POLL,CEW_IDENTIFIER) values (WKSTCODE,CURRENT TIMESTAMP,0,'' '',''1'',IDENTIFIER);');
      SQL.Add('End if;');
      SQL.Add('set isOk = ''0'';');
      SQL.Add('if (OP = ''W'') then ');
      SQL.Add('begin');
      SQL.Add('  set isOk = ''1'';');
      SQL.Add('  select count(1) into num from ' + tbInfo.GetTableName + ' SCDC_EXCG_WKST where CEW_OP <> '' '' and CEW_IDENTIFIER = IDENTIFIER and CEW_WKST_CODE <> WKSTCODE;');
      SQL.Add('  if (num > 0) then ');
      SQL.Add('    set isOk = ''0''; ');
      SQL.Add('  else ');
      SQL.Add('  begin ');
      SQL.Add('    update ' + tbInfo.GetTableName + ' set CEW_OP = ''W'' where CEW_WKST_CODE = WKSTCODE and CEW_IDENTIFIER = IDENTIFIER; ');
      SQL.Add('    select count(1) into num from ' + tbInfo.GetTableName + ' where CEW_OP <> '' '' and CEW_IDENTIFIER = IDENTIFIER and CEW_WKST_CODE <> WKSTCODE; ');
      SQL.Add('    if (num > 0) then ');
      SQL.Add('    begin ');
      SQL.Add('      update ' + tbInfo.GetTableName + ' set CEW_OP = '' '' where CEW_WKST_CODE = WKSTCODE and CEW_IDENTIFIER = IDENTIFIER; ');
      SQL.Add('      set isOk = ''0''; ');
      SQL.Add('    end; ');
      SQL.Add('    end if; ');
      SQL.Add('  end; ');
      SQL.Add('  end if; ');
      SQL.Add('end; ');
      SQL.Add('end if; ');

      SQL.Add('if (OP = ''S'') then');
      SQL.Add('begin');
      SQL.Add('  set isOk = ''1'';');
      SQL.Add('  select count(1) into num from ' + tbInfo.GetTableName + ' SCDC_EXCG_WKST where CEW_OP <> '' '' and CEW_IDENTIFIER = IDENTIFIER and CEW_POLL <> ''R'' and CEW_WKST_CODE <> WKSTCODE;');
      SQL.Add('  if (num > 0) then ');
      SQL.Add('    set isOk = ''0''; ');
      SQL.Add('  else ');
      SQL.Add('  begin ');
      SQL.Add('    update ' + tbInfo.GetTableName + ' set CEW_OP = ''S'' where CEW_WKST_CODE = WKSTCODE and CEW_IDENTIFIER = IDENTIFIER; ');
      SQL.Add('    select count(1) into num from ' + tbInfo.GetTableName + ' where CEW_OP <> '' '' and CEW_IDENTIFIER = IDENTIFIER and CEW_POLL <> ''R'' and CEW_WKST_CODE <> WKSTCODE; ');
      SQL.Add('    if (num > 0) then ');
      SQL.Add('    begin ');
      SQL.Add('      update ' + tbInfo.GetTableName + ' set CEW_OP = '' '' where CEW_WKST_CODE = WKSTCODE and CEW_IDENTIFIER = IDENTIFIER; ');
      SQL.Add('      set isOk = ''0''; ');
      SQL.Add('    end; ');
      SQL.Add('    end if; ');
      SQL.Add('  end; ');
      SQL.Add('  end if; ');
      SQL.Add('end; ');
      SQL.Add('end if; ');

      SQL.Add('if (OP = ''L'') then');
      SQL.Add('begin');
      SQL.Add('  set isOk = ''1'';');
      SQL.Add('  select count(1) into num from ' + tbInfo.GetTableName + ' SCDC_EXCG_WKST where CEW_OP <> '' '' and CEW_IDENTIFIER = IDENTIFIER and CEW_POLL <> ''R'' and CEW_POLL <> ''L'' and CEW_WKST_CODE <> WKSTCODE;');
      SQL.Add('  if (num > 0) then ');
      SQL.Add('    set isOk = ''0''; ');
      SQL.Add('  else ');
      SQL.Add('  begin ');
      SQL.Add('    update ' + tbInfo.GetTableName + ' set CEW_OP = ''L'' where CEW_WKST_CODE = WKSTCODE and CEW_IDENTIFIER = IDENTIFIER; ');
      SQL.Add('    select count(1) into num from ' + tbInfo.GetTableName + ' where CEW_OP <> '' '' and CEW_IDENTIFIER = IDENTIFIER and CEW_POLL <> ''R'' and CEW_POLL <> ''L'' and CEW_WKST_CODE <> WKSTCODE; ');
      SQL.Add('    if (num > 0) then ');
      SQL.Add('    begin ');
      SQL.Add('      update ' + tbInfo.GetTableName + ' set CEW_OP = '' '' where CEW_WKST_CODE = WKSTCODE and CEW_IDENTIFIER = IDENTIFIER; ');
      SQL.Add('      set isOk = ''0''; ');
      SQL.Add('    end; ');
      SQL.Add('    end if; ');
      SQL.Add('  end; ');
      SQL.Add('  end if; ');
      SQL.Add('end; ');
      SQL.Add('end if; ');

      SQL.Add('if (OP = ''R'') then');
      SQL.Add('begin');
      SQL.Add('  set isOk = ''1'';');
      SQL.Add('  select count(1) into num from ' + tbInfo.GetTableName + ' SCDC_EXCG_WKST where CEW_OP <> '' '' and CEW_IDENTIFIER = IDENTIFIER and CEW_POLL <> ''R'' and CEW_POLL <> ''L'' and CEW_POLL <> ''S'' and CEW_WKST_CODE <> WKSTCODE;');
      SQL.Add('  if (num > 0) then ');
      SQL.Add('    set isOk = ''0''; ');
      SQL.Add('  else ');
      SQL.Add('  begin ');
      SQL.Add('    update ' + tbInfo.GetTableName + ' set CEW_OP = ''L'' where CEW_WKST_CODE = WKSTCODE and CEW_IDENTIFIER = IDENTIFIER; ');
      SQL.Add('    select count(1) into num from ' + tbInfo.GetTableName + ' where CEW_OP <> '' '' and CEW_IDENTIFIER = IDENTIFIER and CEW_POLL <> ''R'' and CEW_POLL <> ''L'' and CEW_POLL <> ''S'' and CEW_WKST_CODE <> WKSTCODE; ');
      SQL.Add('    if (num > 0) then ');
      SQL.Add('    begin ');
      SQL.Add('      update ' + tbInfo.GetTableName + ' set CEW_OP = '' '' where CEW_WKST_CODE = WKSTCODE and CEW_IDENTIFIER = IDENTIFIER; ');
      SQL.Add('      set isOk = ''0''; ');
      SQL.Add('    end; ');
      SQL.Add('    end if; ');
      SQL.Add('  end; ');
      SQL.Add('  end if; ');
      SQL.Add('end; ');
      SQL.Add('end if; ');

      SQL.Add('END');

    end

    else if IniAppGlobals.DownloadTo = '1' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName + ' (');
      SQL.Add('WKSTCODE IN VARCHAR, OP IN CHAR,IDENTIFIER in integer, isOk Out CHAR) ');
      SQL.Add(' AS ');
      SQL.Add('BEGIN ');
      SQL.Add('DECLARE num integer; ');
      SQL.Add('BEGIN ');
      SQL.Add('select count(1) into num from ' + tbInfo.GetTableName +  ' where CEW_WKST_CODE = WKSTCODE and CEW_IDENTIFIER = IDENTIFIER;');
      SQL.Add('if (num = 0) then ');
      SQL.Add('insert into ' + tbInfo.GetTableName + ' (' + CreatePfxFld(fli_wkstCode) +
                   ',CEW_CONNECT,CEW_LAST_UPD,CEW_OP,CEW_POLL,CEW_IDENTIFIER) values (WKSTCODE,CURRENT_TIMESTAMP,0,'' '',''1'',IDENTIFIER);');
      SQL.Add('End if;');
      SQL.Add('isOk := ''0'';');
      SQL.Add('if (OP = ''W'') then ');
      SQL.Add('begin');
      SQL.Add('  isOk := ''1'';');
      SQL.Add('  select count(1) into num from ' + tbInfo.GetTableName + ' SCDC_EXCG_WKST where CEW_OP <> '' '' and CEW_IDENTIFIER = IDENTIFIER and CEW_WKST_CODE <> WKSTCODE;');
      SQL.Add('  if (num > 0) then ');
      SQL.Add('    isOk := ''0''; ');
      SQL.Add('  else ');
      SQL.Add('  begin ');
      SQL.Add('    update ' + tbInfo.GetTableName + ' set CEW_OP = ''W'' where CEW_WKST_CODE = WKSTCODE and CEW_IDENTIFIER = IDENTIFIER; ');
      SQL.Add('    select count(1) into num from ' + tbInfo.GetTableName + ' where CEW_OP <> '' '' and CEW_IDENTIFIER = IDENTIFIER and CEW_WKST_CODE <> WKSTCODE; ');
      SQL.Add('    if (num > 0) then ');
      SQL.Add('    begin ');
      SQL.Add('      update ' + tbInfo.GetTableName + ' set CEW_OP = '' '' where CEW_WKST_CODE = WKSTCODE and CEW_IDENTIFIER = IDENTIFIER; ');
      SQL.Add('      isOk := ''0''; ');
      SQL.Add('    end; ');
      SQL.Add('    end if; ');
      SQL.Add('  end; ');
      SQL.Add('  end if; ');
      SQL.Add('end; ');
      SQL.Add('end if; ');

      SQL.Add('if (OP = ''S'') then');
      SQL.Add('begin');
      SQL.Add('  isOk := ''1'';');
      SQL.Add('  select count(1) into num from ' + tbInfo.GetTableName + ' SCDC_EXCG_WKST where CEW_OP <> '' '' and CEW_IDENTIFIER = IDENTIFIER and CEW_POLL <> ''R'' and CEW_WKST_CODE <> WKSTCODE;');
      SQL.Add('  if (num > 0) then ');
      SQL.Add('    isOk := ''0''; ');
      SQL.Add('  else ');
      SQL.Add('  begin ');
      SQL.Add('    update ' + tbInfo.GetTableName + ' set CEW_OP = ''S'' where CEW_WKST_CODE = WKSTCODE and CEW_IDENTIFIER = IDENTIFIER; ');
      SQL.Add('    select count(1) into num from ' + tbInfo.GetTableName + ' where CEW_OP <> '' '' and CEW_IDENTIFIER = IDENTIFIER and CEW_POLL <> ''R'' and CEW_WKST_CODE <> WKSTCODE; ');
      SQL.Add('    if (num > 0) then ');
      SQL.Add('    begin ');
      SQL.Add('      update ' + tbInfo.GetTableName + ' set CEW_OP = '' '' where CEW_WKST_CODE = WKSTCODE and CEW_IDENTIFIER = IDENTIFIER; ');
      SQL.Add('      isOk := ''0''; ');
      SQL.Add('    end; ');
      SQL.Add('    end if; ');
      SQL.Add('  end; ');
      SQL.Add('  end if; ');
      SQL.Add('end; ');
      SQL.Add('end if; ');

      SQL.Add('if (OP = ''L'') then');
      SQL.Add('begin');
      SQL.Add('  isOk := ''1'';');
      SQL.Add('  select count(1) into num from ' + tbInfo.GetTableName + ' SCDC_EXCG_WKST where CEW_OP <> '' '' and CEW_IDENTIFIER = IDENTIFIER and CEW_POLL <> ''R'' and CEW_POLL <> ''L'' and CEW_WKST_CODE <> WKSTCODE;');
      SQL.Add('  if (num > 0) then ');
      SQL.Add('    isOk := ''0''; ');
      SQL.Add('  else ');
      SQL.Add('  begin ');
      SQL.Add('    update ' + tbInfo.GetTableName + ' set CEW_OP = ''L'' where CEW_WKST_CODE = WKSTCODE and CEW_IDENTIFIER = IDENTIFIER; ');
      SQL.Add('    select count(1) into num from ' + tbInfo.GetTableName + ' where CEW_OP <> '' '' and CEW_IDENTIFIER = IDENTIFIER and CEW_POLL <> ''R'' and CEW_POLL <> ''L'' and CEW_WKST_CODE <> WKSTCODE; ');
      SQL.Add('    if (num > 0) then ');
      SQL.Add('    begin ');
      SQL.Add('      update ' + tbInfo.GetTableName + ' set CEW_OP = '' '' where CEW_WKST_CODE = WKSTCODE and CEW_IDENTIFIER = IDENTIFIER; ');
      SQL.Add('      isOk := ''0''; ');
      SQL.Add('    end; ');
      SQL.Add('    end if; ');
      SQL.Add('  end; ');
      SQL.Add('  end if; ');
      SQL.Add('end; ');
      SQL.Add('end if; ');

      SQL.Add('if (OP = ''R'') then');
      SQL.Add('begin');
      SQL.Add('  isOk := ''1'';');
      SQL.Add('  select count(1) into num from ' + tbInfo.GetTableName + ' SCDC_EXCG_WKST where CEW_OP <> '' '' and CEW_IDENTIFIER = IDENTIFIER and CEW_POLL <> ''R'' and CEW_POLL <> ''L'' and CEW_POLL <> ''S'' and CEW_WKST_CODE <> WKSTCODE;');
      SQL.Add('  if (num > 0) then ');
      SQL.Add('    isOk := ''0''; ');
      SQL.Add('  else ');
      SQL.Add('  begin ');
      SQL.Add('    update ' + tbInfo.GetTableName + ' set CEW_OP = ''L'' where CEW_WKST_CODE = WKSTCODE and CEW_IDENTIFIER = IDENTIFIER; ');
      SQL.Add('    select count(1) into num from ' + tbInfo.GetTableName + ' where CEW_OP <> '' '' and CEW_IDENTIFIER = IDENTIFIER and CEW_POLL <> ''R'' and CEW_POLL <> ''L'' and CEW_POLL <> ''S'' and CEW_WKST_CODE <> WKSTCODE; ');
      SQL.Add('    if (num > 0) then ');
      SQL.Add('    begin ');
      SQL.Add('      update ' + tbInfo.GetTableName + ' set CEW_OP = '' '' where CEW_WKST_CODE = WKSTCODE and CEW_IDENTIFIER = IDENTIFIER; ');
      SQL.Add('      isOk := ''0''; ');
      SQL.Add('    end; ');
      SQL.Add('    end if; ');
      SQL.Add('  end; ');
      SQL.Add('  end if; ');
      SQL.Add('end; ');
      SQL.Add('end if; ');

      SQL.Add('END;');
      SQL.Add('END;');

    end;


   // prepare;
    ExecSql;
    Close
  end;
  qry.connection.Commit;
  qry.Free;

end;

//----------------------------------------------------------------------------//

function SP_GET_ACCESS(Wrkst: string; at: TAccessType): boolean;
var
  StoredProc: TMqmStoredProc;
  str:        string;
  StoredProcName : string;
begin

  case at of
  AT_write:   str := 'W';
  AT_Read:    str := 'R';
  AT_Lock:    str := 'L';
  AT_Save:    str := 'S'
  end;

  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CCfgGetAccess
  else
    StoredProcName := 'SCDC_' + CCfgGetAccess;

  StoredProc := CreateStoredProc(Cfg_DB);
  StoredProc.StoredProcName := StoredProcName;
  StoredProc.Connection.StartTransaction;

  try
    with StoredProc do
    begin
      Prepare;
      ParamByName('WKSTCODE').AsString := Wrkst;
      ParamByName('OP').AsString       := str;
      ParamByName('IDENTIFIER').Value := IniAppGlobals.Identifier;
      ExecProc;
      str    := ParamByName('isOk').AsString;
      unprepare
    end;

    if str = '1' then
      Result := true
    else
      Result := false
  except
    Result := false
  end;

  StoredProc.Connection.Commit;

  StoredProc.Free;
end;

//----------------------------------------------------------------------------//

procedure TestEvent;
var
  qry:    TMqmQuery;
begin
  qry := CreateQuery(Cfg_DB);
  qry.SQL.Add('DROP PROCEDURE ' + CCTEST);
  try
    qry.ExecSql;
  except
  end;

  qry.connection.Commit;

  with qry do
  begin

    Close;
    SQL.Clear;

    if IniAppGlobals.DownloadTo = '2' then
    begin
      SQL.Add('CREATE PROCEDURE ' + CCTEST);
      SQL.Add('AS');
      SQL.Add('BEGIN');
      SQL.Add('  post_event ''' + EVT_TEST + ''';');
      SQL.Add('END');
    end
    else
    begin
      SQL.Add('CREATE PROCEDURE ' + CCTEST);
      if IniAppGlobals.DownloadTo = '1' then
        SQL.Add('IS');
      SQL.Add('BEGIN');
      if IniAppGlobals.DownloadTo = '0' then
      begin
        SQL.Add(' CALL DBMS_ALERT.SIGNAL(''' + EVT_TEST  + ''' , ''123'');');
        SQL.Add('END');
      end
      else
      begin
        SQL.Add(' DBMS_ALERT.SIGNAL(''' + EVT_TEST  + ''' , ''123'');');
        SQL.Add('END;');
      end;

    end;

    prepare;
    ExecSql;
    Close;
    SQL.Clear;
  end;
  qry.connection.Commit;
  qry.Free;
end;

//----------------------------------------------------------------------------//

procedure CrtClientRequest;
var
  qry:    TMqmQuery;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CClientRequest
  else
    StoredProcName := 'SCDC_' + CClientRequest;

  qry := CreateQuery(Cfg_DB);
  qry.SQL.Add('DROP PROCEDURE ' + StoredProcName);
  try
    qry.ExecSql;
  except
  end;

  qry.connection.Commit;

  with qry do
  begin

    Close;
    SQL.Clear;

    if IniAppGlobals.DownloadTo = '2' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add('AS');
      SQL.Add('BEGIN');
      SQL.Add('  post_event ''' + EVT_DOWNLOADREQ + ''';');
      SQL.Add('END');
    end
    else
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      if IniAppGlobals.DownloadTo = '1' then
        SQL.Add('IS');
      SQL.Add('BEGIN');
      if IniAppGlobals.DownloadTo = '0' then
      begin
        SQL.Add(' CALL DBMS_ALERT.SIGNAL(''' + EVT_DOWNLOADREQ  + ''' , ''123'');');
        SQL.Add('END');
      end
      else
      begin
        SQL.Add(' DBMS_ALERT.SIGNAL(''' + EVT_DOWNLOADREQ  + ''' , ''123'');');
        SQL.Add('END;');
      end;

    end;

    prepare;
    ExecSql;
    Close;
    SQL.Clear;
  end;
  qry.connection.Commit;
  qry.Free;
end;

//----------------------------------------------------------------------------//

procedure CrtClientStatusUpdate;
var
  qry:    TMqmQuery;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CCLientStatusUpdate
  else
    StoredProcName := 'SCDC_' + CCLientStatusUpdate;

  qry := CreateQuery(Cfg_DB);
  qry.SQL.Add('DROP PROCEDURE ' + StoredProcName);
  try
    qry.ExecSql;
  except
  end;

  qry.connection.Commit;

  with qry do
  begin

    Close;
    SQL.Clear;

    if IniAppGlobals.DownloadTo = '2' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      SQL.Add('AS');
      SQL.Add('BEGIN');
      SQL.Add('  post_event ''' + EVT_NEWSTATUS + ''';');
      SQL.Add('END');
    end
    else
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName);
      if IniAppGlobals.DownloadTo = '1' then
        SQL.Add('IS');
      SQL.Add('BEGIN');
      if IniAppGlobals.DownloadTo = '0' then
      begin
        SQL.Add(' CALL DBMS_ALERT.SIGNAL(''' + EVT_NEWSTATUS  + ''' , ''123'');');
        SQL.Add('END');
      end
      else
      begin
        SQL.Add(' DBMS_ALERT.SIGNAL(''' + EVT_NEWSTATUS  + ''' , ''123'');');
        SQL.Add('END;');
      end;

    end;

    prepare;
    ExecSql;
    Close;
    SQL.Clear;
  end;
  qry.connection.Commit;
  qry.Free;
end;

//----------------------------------------------------------------------------//

procedure CrtProcEndAccess;
var
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
  StoredProcName : string;
begin
  qry := CreateQuery(Cfg_DB);
  tbInfo := @tblInfo[tbl_cfg_exchg_wkst];
  SetFldPfx(tbInfo.pfx);

  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CCfgEndAccess
  else
    StoredProcName := 'SCDC_' + CCfgEndAccess;

  qry.SQL.Add('DROP PROCEDURE ' + StoredProcName);
  try
    qry.ExecSql
  except
  end;

  qry.connection.Commit;

  with qry do
  begin
  //  ParamCheck := false;
    Close;
    SQL.Clear;

    if IniAppGlobals.DownloadTo = '2' then
    begin

      SQL.Add('CREATE PROCEDURE ' + StoredProcName + ' (');
      // In parameters
      SQL.Add('WKSTCODE VARCHAR(10) ,SEND_EVENT CHAR(1), IDENTIFIER INTEGER');
      SQL.Add(')');
      SQL.Add('AS');
      SQL.Add('BEGIN');
      SQL.Add('  begin');
      SQL.Add('    update ' + tbInfo.GetTableName + ' set CEW_OP = '' '' where CEW_WKST_CODE = :WKSTCODE and CEW_IDENTIFIER = :IDENTIFIER;');
      SQL.Add('      if (SEND_EVENT = ''1'') then');
      SQL.Add('        post_event ''' + EVT_UPDATE + ''';');
      SQL.Add('  end');
      SQL.Add('END');
    end
    else if IniAppGlobals.DownloadTo = '0' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName + ' (');
      SQL.Add(' IN WKSTCODE VARCHAR(10) ,SEND_EVENT CHAR(1), IDENTIFIER INTEGER');
      SQL.Add(')');
      SQL.Add('LANGUAGE SQL ');
      SQL.Add('BEGIN ');
      SQL.Add('  update ' + tbInfo.GetTableName + ' set CEW_OP = '' '' where CEW_WKST_CODE = WKSTCODE and CEW_IDENTIFIER = IDENTIFIER;');
      SQL.Add('  if (SEND_EVENT = ''1'') then');
      SQL.Add('    CALL DBMS_ALERT.SIGNAL(''' + EVT_UPDATE  + ''' , ''123'');');
      SQL.Add('  END IF; ');
      SQL.Add('END');
    end
    else if IniAppGlobals.DownloadTo = '1' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName + ' (');
      SQL.Add(' WKSTCODE IN VARCHAR ,SEND_EVENT IN CHAR,IDENTIFIER IN INTEGER');
      SQL.Add(')');
      SQL.Add('AS');
      SQL.Add('BEGIN ');
      SQL.Add('  update ' + tbInfo.GetTableName + ' set CEW_OP = '' '' where CEW_WKST_CODE = WKSTCODE and CEW_IDENTIFIER = IDENTIFIER;');
      SQL.Add('  if (SEND_EVENT = ''1'') then');
      SQL.Add('    DBMS_ALERT.SIGNAL(''' + EVT_UPDATE  + ''' , ''123'');');
      SQL.Add('  END IF; ');
      SQL.Add('END;');
    end;

    prepare;
    ExecSql;
    Close
  end;
  qry.connection.Commit;
  qry.Free;

end;

//----------------------------------------------------------------------------//

procedure CrtChangeAccess;
var
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
  StoredProcName : string;
begin
  qry := CreateQuery(Cfg_DB);
  tbInfo := @tblInfo[tbl_cfg_exchg_wkst];
  SetFldPfx(tbInfo.pfx);

  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CCfgChangeAccess
  else
    StoredProcName := 'SCDC_' + CCfgChangeAccess;

  qry.SQL.Add('DROP PROCEDURE ' + StoredProcName);
  try
    qry.ExecSql
  except
  end;

  qry.connection.Commit;

  with qry do
  begin
   // ParamCheck := false;
    Close;
    SQL.Clear;

    if IniAppGlobals.DownloadTo = '2' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName + ' (');
      // In parameters
      SQL.Add('WKSTCODE VARCHAR(10), IDENTIFIER INTEGER');
      SQL.Add(')');

      SQL.Add('AS');
      SQL.Add('BEGIN');
      SQL.Add('  begin');
      SQL.Add('    update ' + tbInfo.GetTableName + ' set CEW_OP = ''R'' where CEW_WKST_CODE = :WKSTCODE and CEW_IDENTIFIER = :IDENTIFIER;');
      SQL.Add('  end');
      SQL.Add('END');
    end
    else if IniAppGlobals.DownloadTo = '0' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName + ' (');
      // In parameters
      SQL.Add(' IN WKSTCODE VARCHAR(10),IN IDENTIFIER INTEGER');
      SQL.Add(')');
      SQL.Add('LANGUAGE SQL ');
      SQL.Add('BEGIN');
      SQL.Add('  update ' + tbInfo.GetTableName + ' set CEW_OP = ''R'' where CEW_WKST_CODE = WKSTCODE and CEW_IDENTIFIER = IDENTIFIER;');
      SQL.Add('END');
    end
    else if IniAppGlobals.DownloadTo = '1' then
    begin
      SQL.Add('CREATE PROCEDURE ' + StoredProcName + ' (');
      // In parameters
      SQL.Add(' WKSTCODE IN VARCHAR, IDENTIFIER IN INTEGER');
      SQL.Add(')');
      SQL.Add('AS ');
      SQL.Add('BEGIN');
      SQL.Add('  update ' + tbInfo.GetTableName + ' set CEW_OP = ''R'' where CEW_WKST_CODE = WKSTCODE and CEW_IDENTIFIER = IDENTIFIER;');
      SQL.Add('END;');
    end;

    prepare;
    ExecSql;
    Close
  end;
  qry.connection.Commit;
  qry.Free;  //Vinc

end;

//----------------------------------------------------------------------------//

procedure SP_END_ACCESS(Wrkst: string ;OperateEvent : boolean);
var
  StoredProc: TMqmStoredProc;
begin
  StoredProc := CreateStoredProc(Cfg_DB);
  StoredProc.StoredProcName := CCfgEndAccess;
  StoredProc.Connection.StartTransaction;

  Application.ProcessMessages;

  try
    with StoredProc do
    begin
      Prepare;
      ParamByName('WKSTCODE').AsString := Wrkst;
      if OperateEvent then
        ParamByName('SEND_EVENT').AsString := '1'
      else
        ParamByName('SEND_EVENT').AsString := '0';

      ParamByName('IDENTIFIER').Value := IniAppGlobals.Identifier;
      ExecProc;
      unprepare
    end
  except
  end;

  Application.ProcessMessages;

  StoredProc.Connection.Commit;

  StoredProc.Free;
end;

//----------------------------------------------------------------------------//

procedure SP_CHANGE_ACCESS(Wrkst: string);
var
  StoredProc: TMqmStoredProc;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CCfgChangeAccess
  else
    StoredProcName := 'SCDC_' + CCfgChangeAccess;

  StoredProc := CreateStoredProc(Cfg_DB);
  StoredProc.StoredProcName := StoredProcName;
  StoredProc.Connection.StartTransaction;

  Application.ProcessMessages;

  try
    with StoredProc do
    begin
      Prepare;
      ParamByName('WKSTCODE').AsString := Wrkst;
      ParamByName('IDENTIFIER').Value := IniAppGlobals.Identifier;
      ExecProc;
      unprepare
    end
  except
  end;

  Application.ProcessMessages;

  StoredProc.Connection.Commit;

  StoredProc.Free;
end;

//----------------------------------------------------------------------------//

procedure SP_SEND_UPDATE_CLIENT;
var
  StoredProc: TMqmStoredProc;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CCfgUpdateClient
  else
    StoredProcName := 'SCDC_' + CCfgUpdateClient;
  StoredProc := CreateStoredProc(Cfg_DB);
  StoredProc.StoredProcName := StoredProcName;
  StoredProc.Connection.StartTransaction;

  Application.ProcessMessages;

  try
    with StoredProc do
    begin
      Prepare;
      ExecProc;
      unprepare
    end
  except
  end;

  Application.ProcessMessages;

  StoredProc.Connection.Commit;

  StoredProc.Free;
end;

//----------------------------------------------------------------------------//

procedure SP_SEND_JOB_MSG;
var
  StoredProc: TMqmStoredProc;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CCJobMsg
  else
    StoredProcName := 'SCDC_' + CCJobMsg;
  StoredProc := CreateStoredProc(Cfg_DB);
  StoredProc.StoredProcName := StoredProcName;
  StoredProc.Connection.StartTransaction;

  Application.ProcessMessages;

  try
    with StoredProc do
    begin
      Prepare;
      ExecProc;
      unprepare
    end
  except
  end;

  Application.ProcessMessages;
  StoredProc.Connection.Commit;
  StoredProc.Free;
end;

//----------------------------------------------------------------------------//

procedure SP_SEND_TEST;
var
  StoredProc: TMqmStoredProc;
begin
  StoredProc := CreateStoredProc(Cfg_DB);
  StoredProc.StoredProcName := CCTEST;
  StoredProc.Connection.StartTransaction;

  Application.ProcessMessages;

  // the try except shouold be block the license error for db2 local
  // db2 demo server function is working
//  try
    with StoredProc do
    begin
      Prepare;
      ExecProc;
      unprepare
    end;
//  except
//  end;

  Application.ProcessMessages;
  StoredProc.Connection.Commit;
  StoredProc.Free;

end;

//----------------------------------------------------------------------------//

procedure SP_SEND_SHARED_DATA;
var
  StoredProc: TMqmStoredProc;
begin
  StoredProc := CreateStoredProc(Cfg_DB);
  StoredProc.StoredProcName := CCSharedData;
  StoredProc.Connection.StartTransaction;

  Application.ProcessMessages;

  try
    with StoredProc do
    begin
      Prepare;
      ExecProc;
      unprepare
    end
  except
  end;

  Application.ProcessMessages;

  StoredProc.Connection.Commit;

  StoredProc.Free;
end;

//----------------------------------------------------------------------------//

procedure CrtProcSrvLoadEndAccess;
var
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
begin
  qry := CreateQuery(Cfg_DB);
  tbInfo := @tblInfo[tbl_cfg_exchg_glob];
  SetFldPfx(tbInfo.pfx);

  qry.SQL.Add('DROP PROCEDURE ' + CSrvLoadEndAcc);
  try
    qry.ExecSql
  except
  end;

  qry.connection.Commit;

  with qry do
  begin
  //  ParamCheck := false;
    Close;
    SQL.Clear;

    SQL.Add('CREATE PROCEDURE ' + CSrvLoadEndAcc);
    // In parameters
    SQL.Add('AS');
    SQL.Add('BEGIN');
    SQL.Add('  begin');
//    SQL.Add('    update ' + tbInfo.PCname + ' set CEG_SL_OP = '' '';');
//    SQL.Add('    post_event ''' + EVT_UPDATE + ''';');
//    SQL.Add('    post_event ''' + EVT_NEWSTATUS + ''';');
    SQL.Add('  end');
    SQL.Add('END');

    prepare;
    ExecSql;
    Close
  end;
  qry.connection.Commit;
  qry.Free;
       //Vinc
end;

//----------------------------------------------------------------------------//

procedure SP_SRVLOAD_END_ACCESS;
var
  StoredProc: TMqmStoredProc;
begin
  StoredProc := CreateStoredProc(Cfg_DB);
  StoredProc.StoredProcName := CSrvLoadEndAcc;
  StoredProc.Connection.StartTransaction;

  try
    with StoredProc do
    begin
      Prepare;
      ExecProc;
      unprepare
    end
    except
  end;
  StoredProc.Connection.Commit;
  StoredProc.Free;
end;

//----------------------------------------------------------------------------//

function SP_SRVLOAD_GET_STATUS_OPENED_OR_CLOSED : boolean;
var
  StoredProc: TMqmStoredProc;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CSrvLoadGetStatusOpenedOrClosed
  else
    StoredProcName := 'SCDC_' + CSrvLoadGetStatusOpenedOrClosed;
  Result := false;
  StoredProc := CreateStoredProc(Cfg_DB);
  StoredProc.StoredProcName := StoredProcName;
  StoredProc.Connection.StartTransaction;
  try
    with StoredProc do
    begin
      Prepare;
      ParamByName('IDENTIFIER').Value := IniAppGlobals.Identifier;
      ExecProc;
      if ParamByName('ISOPEN').AsString = '1' then
        Result := true;
      unprepare;
    end
  except
    Result := false;
  end;

  StoredProc.Connection.Commit;

  StoredProc.Free;
end;

//----------------------------------------------------------------------------//

procedure Sp_Client_Request;
var
  StoredProc: TMqmStoredProc;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CClientRequest
  else
    StoredProcName := 'SCDC_' + CClientRequest;
  StoredProc := CreateStoredProc(Cfg_DB);
  StoredProc.StoredProcName := StoredProcName;
  StoredProc.Connection.StartTransaction;
//  try
    with StoredProc do
    begin
      Prepare;
      ExecProc;
      unprepare;
    end;
//  except
//    StoredProcName := 'test';
//  end;

  StoredProc.Connection.Commit;

  StoredProc.Free;

end;

//----------------------------------------------------------------------------//

procedure Sp_Client_Status_Update;
var
  StoredProc: TMqmStoredProc;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CCLientStatusUpdate
  else
    StoredProcName := 'SCDC_' + CCLientStatusUpdate;
  StoredProc := CreateStoredProc(Cfg_DB);
  StoredProc.StoredProcName := StoredProcName;
  StoredProc.Connection.StartTransaction;
//  try
    with StoredProc do
    begin
      Prepare;
      ExecProc;
      unprepare;
    end;
//  except
//    StoredProcName := 'test';
//  end;

  StoredProc.Connection.Commit;

  StoredProc.Free;
end;

//----------------------------------------------------------------------------//

procedure SP_CheckPolling;
var
  StoredProc: TMqmStoredProc;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CCfgChkPoll
  else
    StoredProcName := 'SCDC_' + CCfgChkPoll;
  StoredProc := CreateStoredProc(Cfg_DB);
  StoredProc.StoredProcName := StoredProcName;
  StoredProc.Connection.StartTransaction;
//  try
    with StoredProc do
    begin
      Prepare;
      ExecProc;
      unprepare;
    end;
//  except
//    StoredProcName := 'test';
//  end;

//  StoredProc.Connection.Commit;

  StoredProc.Free;

end;

procedure OPERATE_DOWNLOAD_REQUEST(STATION : string ; DOWNLOAD_TYPE : string);
var
  qry: TMqmQuery;
  tbInfo: ^TTblInfo;
begin
  qry := CreateQuery(Cfg_DB);
  tbInfo := @tblInfo[tbl_cfg_exchg_SrvLoad];
  SetFldPfx(tblInfo[tbl_cfg_exchg_SrvLoad].pfx);
  Qry.Transaction := CreateTransaction(Cfg_DB);
  Qry.Transaction.StartTransaction;

  qry.Close;
  qry.SQL.Clear;
  qry.SQL.Add('insert into ' + tbInfo.GetTableName + ' (');
  qry.SQL.Add(CreatePfxFld(fli_IDENTIFIER) + ', ');
  qry.SQL.Add(CreatePfxFld(fli_wkstCode) + ', ');
  qry.SQL.Add(CreatePfxFld(fli_downloadType));
  qry.SQL.Add(') values (');
  qry.SQL.Add('''' + IniAppGlobals.Identifier + ''', ');
  qry.SQL.Add('''' + STATION + ''', ');
  qry.SQL.Add('''' + DOWNLOAD_TYPE + '''');
  qry.SQL.Add(')');
  qry.ExecSQL;

  qry.Transaction.Commit;

  qry.Close;
  qry.free;
  Sp_Client_Request;
end;

//----------------------------------------------------------------------------//

function GET_ACCESS(Wrkst: string; at: TAccessType): boolean;
var

  qry:        TMqmQuery;
  str:        string;
  tbInfo: ^TTblInfo;
begin

  CHECK_STATION_EXIST_AND_INSERT(Wrkst);
  UPDATE_ACCESS_OPERATION(Wrkst, AT_Blank, IniAppGlobals.Curr_Date_Signed);

  Result := false;

  if IS_ACCESS_ALLOWED(Wrkst, at) then
  begin
    UPDATE_ACCESS_OPERATION(Wrkst, at, IniAppGlobals.Curr_Date_Signed);
    if IS_ACCESS_ALLOWED(Wrkst, at) then
      Result := true;
  end;

end;

//----------------------------------------------------------------------------//

function IS_ACCESS_ALLOWED(Wrkst: string; at: TAccessType): boolean;
var
  qry:        TMqmQuery;
  str, Str_In:        string;
  tbInfo: ^TTblInfo;
begin
  Result := true;
  Exit; // Evan/ avi - we allow to make any operation together.

  case at of
    AT_write:   str := 'W';
    AT_Read:    str := 'R';
    AT_Lock:    str := 'L';
    AT_Save:    str := 'S'
  end;

  if at = AT_Lock then
    Str_In := QuotedStr('W') + ',' + QuotedStr('S')
  else if at = AT_Read then
    Str_In := QuotedStr('W')
  else if at = AT_write then
    Str_In := QuotedStr('W') + ',' + QuotedStr('S')  + ',' + QuotedStr('R') + ',' + QuotedStr('L')
  else if at = AT_Save then
    Str_In := QuotedStr('W') + ',' + QuotedStr('S') + ',' + QuotedStr('L');

  tbInfo := @tblInfo[tbl_cfg_exchg_wkst];

  qry := CreateQuery(Cfg_DB);
  qry.Transaction := CreateTransaction(Cfg_DB);
  qry.Transaction.StartTransaction;

  with qry do
  begin
    SQL.Add(' Select count(*) Cnt from ' + tbInfo.GetTableName + ' where '); //CEW_OP <> '' ''');
    SQL.Add(' CEW_OP IN ' + '(' + Str_In + ')');
    SQL.Add(' And '  + CreateFld(tbInfo.pfx, fli_wkstCode) + ' <> ''' + Wrkst + '''');
    SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
    Open;
    if (FieldByName('Cnt').asInteger > 0) then
      Result := false;
  end;

  qry.Transaction.Commit;
  qry.Free;
end;

//----------------------------------------------------------------------------//

function IS_STATION_CLOSED(Wrkst: string): boolean;
var
  Closed_Station : string;
  qry:        TMqmQuery;
  tbInfo: ^TTblInfo;
begin
  Result := true;

  Closed_Station := QuotedStr('-');

  tbInfo := @tblInfo[tbl_cfg_exchg_wkst];

  qry := CreateQuery(Cfg_DB);
  qry.Transaction := CreateTransaction(Cfg_DB);
  qry.Transaction.StartTransaction;

  with qry do
  begin
    SQL.Add(' Select count(*) Cnt from ' + tbInfo.GetTableName + ' where ');
    SQL.Add(' CEW_OP <> ' + Closed_Station);
    SQL.Add(' And '  + CreateFld(tbInfo.pfx, fli_wkstCode) + ' = ''' + Wrkst + '''');
    SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
    Open;
    if (FieldByName('Cnt').asInteger > 0) then
      Result := false;
  end;

  qry.Transaction.Commit;
  qry.Free;
end;

//----------------------------------------------------------------------------//

procedure UPDATE_ACCESS_OPERATION(Wrkst: string; at: TAccessType; Curr_DateTime : TDateTime);
var
  qry:        TMqmQuery;
  str, SqlStr:        string;
  tbInfo: ^TTblInfo;
begin

  case at of
    AT_write:   str := 'W';
    AT_Read:    str := 'R';
    AT_Lock:    str := 'L';
    AT_Save:    str := 'S';
    AT_Blank:   str := ' ';
    AT_Closed:  str := '-';
  end;

  tbInfo := @tblInfo[tbl_cfg_exchg_wkst];

  qry := CreateQuery(Cfg_DB);
  qry.Transaction := CreateTransaction(Cfg_DB);
  qry.Transaction.StartTransaction;

  with qry do
  begin
    SQL.Clear;

    SqlStr := 'Update ' + tbInfo.GetTableName + ' set ' +
              CreateFld(tbInfo.pfx, fli_OP)    + '='   +
              ':' + CreateFld(tbInfo.pfx, fli_OP) + ',' +
              CreateFld(tbInfo.pfx, fli_CONNECT)  + '=' +
              ':' + CreateFld(tbInfo.pfx, fli_CONNECT) +
              ' where ' +
              CreateFld(tbInfo.pfx, fli_wkstCode)   + '=' +
              ':' + CreateFld(tbInfo.pfx, fli_wkstCode) + ' and ' +
              CreateFld(tbInfo.pfx, fli_IDENTIFIER)  + '=' +
              ':' + CreateFld(tbInfo.pfx, fli_IDENTIFIER);
    sql.Text  := SqlStr;

    ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsString   := IniAppGlobals.Identifier;
    ParamByName(CreateFld(tbInfo.pfx, fli_wkstCode)).AsString     := Wrkst;
    ParamByName(CreateFld(tbInfo.pfx, fli_OP)).AsString           := Str;
    ParamByName(CreateFld(tbInfo.pfx, fli_CONNECT)).AsDateTime     := Curr_DateTime;
    ExecSQL;

  end;
  qry.Transaction.Commit;
  qry.free;

end;

//----------------------------------------------------------------------------//

procedure CHECK_STATION_EXIST_AND_INSERT(Wrkst: string);
var
  qry:        TMqmQuery;
  str:        string;
  tbInfo: ^TTblInfo;
begin
  tbInfo := @tblInfo[tbl_cfg_exchg_wkst];
  qry := CreateQuery(Cfg_DB);
  qry.Transaction := CreateTransaction(Cfg_DB);
  qry.Transaction.StartTransaction;

  with qry do
  begin
    SQL.Clear;
    SQL.Add('select count(*) Cnt from ' + tbInfo.GetTableName );
    SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)) + 'AND ' + CreateFld(tbInfo.pfx, fli_wkstCode) + ' = ''' + Wrkst + '''');
    Open;
    if (FieldByName('Cnt').asInteger = 0) then
    begin
      SQL.Clear;
      qry.SQL.Add('Insert into ' + tbInfo.GetTableName);
      qry.SQL.Add('(' + CreateFld(tbInfo.pfx, fli_IDENTIFIER) + ',');
      qry.SQL.Add(CreateFld(tbInfo.pfx, fli_wkstCode) + ',');
      qry.SQL.Add('CEW_CONNECT ,');
      qry.SQL.Add('CEW_LAST_UPD ,');
      qry.SQL.Add('CEW_OP ,');
      qry.SQL.Add('CEW_POLL ,');
      qry.SQL.Add('CEW_COUNTER )');
      qry.SQL.Add(' values (');
      qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_IDENTIFIER) + ',');
      qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wkstCode) + ',');
      qry.SQL.Add(':' + 'CEW_CONNECT' + ',');
      qry.SQL.Add(':' + 'CEW_LAST_UPD' + ',');
      qry.SQL.Add(':' + 'CEW_OP' + ',');
      qry.SQL.Add(':' + 'CEW_POLL' + ',');
      qry.SQL.Add(':' + 'CEW_COUNTER )');
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).Value := IniAppGlobals.Identifier;
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_wkstCode)).Value := Wrkst;
      qry.ParamByName('CEW_CONNECT').Value := now;
      qry.ParamByName('CEW_LAST_UPD').Value := 0;
      qry.ParamByName('CEW_OP').Value := ' ';
      qry.ParamByName('CEW_POLL').Value := '1';
      qry.ParamByName('CEW_COUNTER').Value := 0;
      qry.ExecSQL;
    end;
  end;
  qry.Transaction.Commit;
  qry.free;

end;

//----------------------------------------------------------------------------//

function EXIST_ACTIVE_STATIONS : boolean;
var
  qry:        TMqmQuery;
  ClosedStation, Wrkst : string;
  tbInfo: ^TTblInfo;
  StartTime : string;
begin
  Result := false;
  ClosedStation := QuotedStr('-');
  Wrkst := QuotedStr('SERVER');

  StartTime := GetSqlDate(Now - 21);

  tbInfo := @tblInfo[tbl_cfg_exchg_wkst];

  qry := CreateQuery(Cfg_DB);
  qry.Transaction := CreateTransaction(Cfg_DB);
  qry.Transaction.StartTransaction;

  with qry do
  begin
    SQL.Add(' Select count(*) Cnt from ' + tbInfo.GetTableName + ' where ');
    SQL.Add(' CEW_OP <> ' + ClosedStation);
    SQL.Add(' And '  + CreateFld(tbInfo.pfx, fli_wkstCode) + ' <> ' + Wrkst);
    SQL.Add(' And '  + CreateFld(tbInfo.pfx, fli_CONNECT) + ' > ' + StartTime);
    SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
    Open;
    if (FieldByName('Cnt').asInteger > 0) then
      Result := true;
  end;

  qry.Transaction.Commit;
  qry.Free;
end;

//----------------------------------------------------------------------------//

procedure END_ACCESS(Wrkst: string);
begin
  UPDATE_ACCESS_OPERATION(Wrkst, AT_Blank, IniAppGlobals.Curr_Date_Signed);
end;

//----------------------------------------------------------------------------//

procedure CLOSE_STATION(Wrkst: string);
begin
  UPDATE_ACCESS_OPERATION(Wrkst, AT_Closed, IniAppGlobals.Curr_Date_Signed);
end;


//----------------------------------------------------------------------------//

function IS_STATION_RESPONDING(station : string) : boolean;
var
  qry:          TMqmQuery;
  tbInfo:      ^TTblInfo;
  Counter:      Integer;
begin
  Result := true;
  qry := CreateQuery(Cfg_DB);
  qry.Transaction := CreateTransaction(Cfg_DB);
  qry.Transaction.StartTransaction;
  tbInfo := @tblInfo[tbl_cfg_exchg_wkst];

  qry.SQL.Clear;
  qry.SQL.Add('select * from ' + tbInfo.GetTableName);
  qry.SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + '=''' + Station + '''');
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
  qry.Open;

  if qry.EOF then
    Exit
  else
  begin
    if qry.FieldByName(CreateFld(tbInfo.pfx, fli_COUNTER)).IsNull then
      Counter := 0
    else
      Counter := qry.FieldByName(CreateFld(tbInfo.pfx, fli_COUNTER)).AsInteger;
  end;

  qry.Transaction.Commit;
  qry.Close;
  qry.Free;

  SP_ASK_POLL;

  Application.ProcessMessages;

  Sleep(5000);

  qry := CreateQuery(Cfg_DB);
  qry.Transaction := CreateTransaction(Cfg_DB);
  qry.Transaction.StartTransaction;

  qry.SQL.Clear;
  qry.SQL.Add('select * from ' + tbInfo.GetTableName);
  qry.SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + '=''' + Station + '''');
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
  qry.Open;

  if not qry.EOF then
  begin
    if qry.FieldByName(CreateFld(tbInfo.pfx, fli_COUNTER)).IsNull or
        (Counter = qry.FieldByName(CreateFld(tbInfo.pfx, fli_COUNTER)).AsInteger) then
      Result := false;
  end;
  qry.Transaction.Commit;
  qry.Close;
  qry.Free;

end;

//----------------------------------------------------------------------------//

procedure RESET_STATION_RECORD(station : string);
var
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
begin
  tbInfo := @tblInfo[tbl_cfg_exchg_wkst];

  // Step 1: Set CEW_COUNTER = 99 to signal the running station to close
  qry := CreateQuery(Cfg_DB);
  qry.Transaction := CreateTransaction(Cfg_DB);
  qry.Transaction.StartTransaction;

  qry.SQL.Add('update ' + tbInfo.GetTableName);
  qry.SQL.Add(' set ' + CreateFld(tbInfo.pfx, fli_COUNTER) + ' = 99');
  qry.SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + ' = ' + QuotedStr(Station));
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
  qry.ExecSQL;

  qry.Transaction.Commit;
  qry.Close;
  qry.Free;

  // Step 2: Fire poll event so the running station picks up counter=99
  SP_ASK_POLL;

  // Step 3: Wait for the station to process the event and terminate
  Sleep(5000);

  // Step 4: Delete the record (cleanup â€” ensures counter=99 never stays in DB)
  qry := CreateQuery(Cfg_DB);
  qry.Transaction := CreateTransaction(Cfg_DB);
  qry.Transaction.StartTransaction;

  qry.SQL.Add('delete from ' + tbInfo.GetTableName);
  qry.SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + ' = ' + QuotedStr(Station));
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
  qry.ExecSQL;

  qry.Transaction.Commit;
  qry.Close;
  qry.Free;
end;

//----------------------------------------------------------------------------//

procedure REMOVE_UNACTIVATED_STATIONS;
type
  TCounterStation = record
    Counter : integer;
    Station : string;
    delete  : boolean;
  end;
  PTCounterStation = ^TCounterStation;
var
  J :           Integer;
  qry:          TMqmQuery;
//  trs:          TMqmTransaction;
  tbInfo:      ^TTblInfo;
  Counter:      Integer;
  Station :     string;
  StationList : TList;
  RecCounterStation : PTCounterStation;
  procedure UpdateStatusStationList(StationList : TList; Station : string; Counter : integer);
  var
    I : Integer;
  begin
    for I := 0 to StationList.Count - 1 do
    begin
      if (Station <> PTCounterStation(StationList[I]).Station) then continue;
      if (Counter <> PTCounterStation(StationList[I]).Counter) then continue;
      PTCounterStation(StationList[I]).delete := true;
      break;
    end;
  end;

begin

  StationList := TList.Create;

  qry := CreateQuery(Cfg_DB);

  tbInfo := @tblInfo[tbl_cfg_exchg_wkst];
  qry.Transaction := CreateTransaction(Cfg_DB);
  qry.Transaction.StartTransaction;

  qry.SQL.Clear;
  qry.SQL.Add('select * from ' + tbInfo.GetTableName);
  qry.SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + '<>''' + 'SERVER' + '''');
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
  qry.Open;

  if qry.EOF then
  begin
    StationList.Free;
    qry.Transaction.Commit;
    qry.Free;
    Exit
  end;

  while not qry.EOF do
  begin
    if qry.FieldByName(CreateFld(tbInfo.pfx, fli_COUNTER)).IsNull then
      Counter := -1
    else
      Counter := qry.FieldByName(CreateFld(tbInfo.pfx, fli_COUNTER)).AsInteger;
    Station := qry.FieldByName(CreateFld(tbInfo.pfx, fli_wkstCode)).AsString;
    new(RecCounterStation);
    RecCounterStation.Counter := Counter;
    RecCounterStation.Station := Station;
    RecCounterStation.delete  := false;
    StationList.add(RecCounterStation);
    qry.Next;
  end;

  SP_ASK_POLL;
  Application.ProcessMessages;
  Sleep(5000);

  qry.Close;
//  qry.Free;

//  qry := CreateQuery(Cfg_DB);

  qry.SQL.Clear;
  qry.SQL.Add('select * from ' + tbInfo.GetTableName);
  qry.SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + '<>''' + 'SERVER' + '''');
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
  qry.Open;

  while not qry.EOF do
  begin
    Station := qry.FieldByName(CreateFld(tbInfo.pfx, fli_wkstCode)).AsString;
    if qry.FieldByName(CreateFld(tbInfo.pfx, fli_COUNTER)).IsNull then
      Counter := -1
    else
      Counter := qry.FieldByName(CreateFld(tbInfo.pfx, fli_COUNTER)).AsInteger;
    UpdateStatusStationList(StationList, Station, Counter);
    qry.Next;
  end;


//  qry := CreateQuery(Cfg_DB);
  qry.SQL.Clear;
  Qry.Transaction := CreateTransaction(Cfg_DB);
  Qry.Transaction.StartTransaction;

  for J := 0 to StationList.Count - 1 do
  begin
    if not PTCounterStation(StationList[J]).delete then continue;
    qry.SQL.Clear;
    qry.SQL.Add(' DELETE FROM ' + tbInfo.GetTableName);
    qry.SQL.Add(' where '  + CreateFld(tbInfo.pfx, fli_wkstCode) + ' = ''' + PTCounterStation(StationList[J]).Station + '''');
    qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
    qry.ExecSQL;
    qry.Transaction.Commit;
  end;

  for J := StationList.Count - 1 downto 0 do
    dispose(PTCounterStation(StationList[J]));

  StationList.free;

  qry.Close;

  qry.Free;

end;

//----------------------------------------------------------------------------//

procedure SP_Reset_NEW_REQ_NO_Generator;
var
  srvQry: TMqmQuery;
begin
  srvQry := CreateQuery(Main_DB);
  srvQry.Transaction.StartTransaction;
  srvQry.SQL.Clear;
  srvQry.SQL.Add('set generator NEW_REQ_NO TO 0;');
  srvQry.ExecSQL;
  srvQry.Close;
  srvqry.Transaction.Commit;
  srvQry.Free;
end;

//----------------------------------------------------------------------------//

procedure SP_Reset_SPLIT_FAMILY_CODE_Generator;
var
  srvQry: TMqmQuery;
begin
  srvQry := CreateQuery(Main_DB);
  srvQry.Transaction.StartTransaction;
  srvQry.SQL.Clear;
  srvQry.SQL.Add('set generator SPLIT_FAMILY_CODE TO 0;');
  srvQry.ExecSQL;
  srvQry.Close;
  srvqry.Transaction.Commit;
  srvQry.Free;
end;

//----------------------------------------------------------------------------//

procedure CrtExtFunctions;
var
  qry: TMqmQuery;
begin
  qry := CreateQuery(Cfg_DB);
  qry.SQL.Clear;

  if IniAppGlobals.DownloadTo = '2' then
  begin
    // MCM

    qry.SQL.Add('drop external function GetCodeMcm');
    try
      qry.ExecSql
    except
    end;

    qry.Close;
    qry.Connection.Commit;

    qry.SQL.Clear;
    qry.SQL.Add('drop external function GetLockMcm');
    try
      qry.ExecSql
    except
    end;

    qry.Connection.Commit;

    with qry do
    begin
      Close;
      SQL.Clear;

      SQL.Add('declare external function GetLockMcm');
      SQL.Add('  returns');
      SQL.Add('  integer by value');
      SQL.Add('  entry_point ''GetLockCodeMcm'' module_name ''McmAppUDF'';');

      prepare;
      ExecSql;
      Close
    end;

    qry.Connection.Commit;

    qry.SQL.Clear;
    qry.SQL.Add('drop external function GetCodeMcm');
    try
      qry.ExecSql
    except
    end;

    qry.Close;
    qry.Connection.Commit;

    with qry do
    begin
      SQL.Clear;

      SQL.Add('declare external function GetCodeMcm integer');
      SQL.Add('  returns');
      SQL.Add('  integer by value');
      SQL.Add('  entry_point ''GetUDFcodeMcm'' module_name ''McmAppUDF'';');

      prepare;
      ExecSql;
      Close
    end;
    qry.Connection.Commit;

    qry.SQL.Clear;
    qry.SQL.Add('drop external function GetLock');
    try
      qry.ExecSql
    except
    end;
    qry.Connection.Commit;

    qry.SQL.Clear;
    qry.SQL.Add('drop external function GetLockMqm');
    try
      qry.ExecSql
    except
    end;
    qry.Connection.Commit;

    qry.SQL.Clear;
    qry.SQL.Add('drop external function GetCode');
    try
      qry.ExecSql
    except
    end;
    qry.Connection.Commit;

    qry.SQL.Clear;
    qry.SQL.Add('drop external function GetCodeMqm');
    try
      qry.ExecSql
    except
    end;
    qry.Connection.Commit;

    with qry do
    begin
      Close;
      SQL.Clear;

      SQL.Add('declare external function GetLockMqm');
      SQL.Add('  returns');
      SQL.Add('  integer by value');
      SQL.Add('  entry_point ''GetLockCodeMqm'' module_name ''MqmAppUDF'';');

      prepare;
      ExecSql;
      Close
    end;

    qry.Connection.Commit;

    with qry do
    begin
      SQL.Clear;

      SQL.Add('declare external function GetCodeMqm integer');
      SQL.Add('  returns');
      SQL.Add('  integer by value');
      SQL.Add('  entry_point ''GetUDFcodeMqm'' module_name ''MqmAppUDF'';');

      prepare;
      ExecSql;
      Close
    end;

  end
  else if IniAppGlobals.DownloadTo = '0' then
  begin

    qry.SQL.clear;
    qry.SQL.Add('drop function GetLockCodeMqm');
    try
      qry.ExecSQL;
      except
      on E: Exception do
      begin
        if (Pos('UNIQUE KEY', E.Message) > 0) or (Pos('is an undefined name', E.Message) > 0) then
        begin

        end
        else
          raise
      end;
    end;

    qry.SQL.clear;
    qry.SQL.Add('drop function GetUDFcodeMqm');
    try
      qry.ExecSQL;
      except
      on E: Exception do
      begin
        if (Pos('UNIQUE KEY', E.Message) > 0) or (Pos('is an undefined name', E.Message) > 0) then
        begin

        end
        else
          raise
      end;
    end;

    qry.SQL.clear;
    qry.SQL.Add('drop function GetLockCodeMcm');
    try
      qry.ExecSQL;
      except
      on E: Exception do
      begin
        if (Pos('UNIQUE KEY', E.Message) > 0) or (Pos('is an undefined name', E.Message) > 0) then
        begin

        end
        else
          raise
      end;
    end;

    qry.SQL.clear;
    qry.SQL.Add('drop function GetUDFcodeMcm');
    try
      qry.ExecSQL;
      except
      on E: Exception do
      begin
        if (Pos('UNIQUE KEY', E.Message) > 0) or (Pos('is an undefined name', E.Message) > 0) then
        begin

        end
        else
          raise
      end;
    end;

    qry.Close;
    qry.Connection.Commit;

    qry.SQL.clear;
    qry.SQL.Add('CALL SQLJ.REMOVE_JAR ' + '(' + QuotedStr('LockCode') + ')');
    try
      qry.ExecSQL;
      except
      on E: Exception do
      begin
        if (Pos('UNIQUE KEY', E.Message) > 0) or (Pos('jar name is invalid', E.Message) > 0) then
        begin

        end
        else
          raise
      end;
    end;

    qry.Close;
    qry.Connection.Commit;


    qry.SQL.clear;
    qry.SQL.Add('CALL SQLJ.INSTALL_JAR ' + '(' + QuotedStr('file:' + LocAppGlobals.AppDir + 'LockCode.jar') + ',' + QuotedStr('LockCode') + ')');
   // try
    qry.ExecSQL;
   //   except
   //   on E: Exception do
   //   begin
   //     if (Pos('UNIQUE KEY', E.Message) > 0) or (Pos('jar name is invalid', E.Message) > 0) then
   //     begin

   //     end
   //     else
   //       raise
   //   end;
   // end;

    qry.Close;
    qry.Connection.Commit;


    with qry do
    begin
      Close;
      SQL.Clear;
      SQL.Add(' CREATE FUNCTION GetLockCodeMqm() RETURNS VARCHAR(255)');
      SQL.Add(' FENCED ');
      SQL.Add(' EXTERNAL NAME ' + QuotedStr('LOCKCODE:LockCode.GetLockCodeMqm'));
      SQL.Add(' NOT VARIANT NO SQL PARAMETER STYLE java LANGUAGE java');
      SQL.Add(' NO SQL');
      SQL.Add(' ALLOW PARALLEL');
      ExecSql;
      Close
    end;

    qry.Close;
    qry.Connection.Commit;

    with qry do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select GetLockCodeMqm() from sysibm.sysdummy1');
      prepare;
      open;
      showmessage(Fields[0].asstring);
      Close
    end;

    with qry do
    begin
      Close;
      SQL.Clear;

      SQL.Add(' Create FUNCTION GetUDFcodeMqm(INTEGER) RETURNS VARCHAR(10)');
      SQL.Add(' FENCED ');
      SQL.Add(' EXTERNAL NAME ' + QuotedStr('LOCKCODE:LockCode.GetUDFcodeMqm'));
      SQL.Add(' NOT VARIANT NO SQL PARAMETER STYLE java LANGUAGE java');
   //   SQL.Add(' PARAMETER STYLE java LANGUAGE java');
      SQL.Add(' NO EXTERNAL ACTION');
      SQL.Add(' CALLED ON NULL INPUT');


      SQL.Add(' DETERMINISTIC');

      SQL.Add(' NO SQL');
      SQL.Add(' ALLOW PARALLEL');

      ExecSql;
      Close
    end;

    qry.Close;
    qry.Connection.Commit;

    with qry do
    begin
      Close;
      SQL.Clear;

      SQL.Add(' CREATE FUNCTION GetLockCodeMcm() RETURNS VARCHAR(255)');
      SQL.Add(' FENCED ');
      SQL.Add(' EXTERNAL NAME ' + QuotedStr('LOCKCODE:LockCode.GetLockCodeMcm'));
      SQL.Add(' NOT VARIANT NO SQL PARAMETER STYLE java LANGUAGE java');
      SQL.Add(' NO SQL');
      SQL.Add(' ALLOW PARALLEL');
      ExecSql;
      Close
    end;

    qry.Close;
    qry.Connection.Commit;

    with qry do
    begin
      Close;
      SQL.Clear;
      SQL.Add(' CREATE FUNCTION GetUDFcodeMcm() RETURNS VARCHAR(255)');
      SQL.Add(' FENCED ');
      SQL.Add(' EXTERNAL NAME ' + QuotedStr('LOCKCODE:LockCode.GetUDFcodeMcm'));
      SQL.Add(' NOT VARIANT NO SQL PARAMETER STYLE java LANGUAGE java');
      SQL.Add(' NO SQL');
      SQL.Add(' ALLOW PARALLEL');
      ExecSql;
      Close
    end;

    qry.Close;
    qry.Connection.Commit;

  end

  else if IniAppGlobals.DownloadTo = '1' then
  begin
    qry.SQL.Add('drop external function LockCode');
    try
      qry.ExecSql
    except
    end;

    qry.Close;
    qry.Connection.Commit;

    with qry do
    begin
      Close;
      SQL.Clear;
      SQL.Add('create or replace FUNCTION LockCode');
      SQL.Add(' RETURN VARCHAR2');
      SQL.Add(' AS LANGUAGE JAVA');
      SQL.Add(' NAME ' + QuotedStr('LockCode.getDiskCode() return java.lang.String') + ';');
      prepare;
      ExecSql;
      Close
    end;

  end;


  qry.Connection.Commit;
  qry.Free;

end;

//----------------------------------------------------------------------------//

function KillTask(ExeFileName: string): Integer;
const
   PROCESS_TERMINATE = $0001;
var
   ContinueLoop: BOOL;
   FSnapshotHandle: THandle;
   FProcessEntry32: TProcessEntry32;
   Count : integer;
begin
   Result := 0;
   FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
   FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
   ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);

   Count := 0;
   while Integer(ContinueLoop) <> 0 do
   begin
     if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
       UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) =
       UpperCase(ExeFileName))) then
          Inc(Count);
      ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
   end;
   if Count > 1 then exit;

   ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
   while Integer(ContinueLoop) <> 0 do
   begin
     if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
       UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) =
       UpperCase(ExeFileName))) then
       Result := Integer(TerminateProcess(
                         OpenProcess(PROCESS_TERMINATE,
                                     BOOL(0),
                                     FProcessEntry32.th32ProcessID),
                                     0));
      ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
   end;
   CloseHandle(FSnapshotHandle);
end;

{ For Windows NT/2000/XP }

procedure Killprocess2(Name:String);

var

  PEHandle,hproc: cardinal;

  PE: ProcessEntry32;

begin

  //NTSetPrivilege(SE_DEBUG_NAME,True);

  PEHandle := CreateTOOLHelp32Snapshot(TH32cs_Snapprocess,0);

  if PEHandle <> Invalid_Handle_Value then

  begin

    PE.dwSize := Sizeof(ProcessEntry32);

    Process32first(PEHandle,PE);



    repeat

      if Lowercase(PE.szExeFile) = Lowercase(Pchar(Name)) then

      begin

        hproc := openprocess(Process_Terminate,false,pe.th32ProcessID);

        TerminateProcess(hproc,0);

        closehandle(hproc);

      end;

    until Process32next(PEHandle,PE)=false;

  end;

  closehandle(PEHandle);

end;

//----------------------------------------------------------------------------//

procedure KillProcess(hWindowHandle: HWND);
var
   hprocessID: INTEGER;
   processHandle: THandle;
   DWResult: DWORD;
begin
   SendMessageTimeout(hWindowHandle, WM_DDE_EXECUTE, 0, 0,
     SMTO_ABORTIFHUNG or SMTO_NORMAL, 5000, @DWResult);

   if isWindow(hWindowHandle) then
   begin
     // PostMessage(hWindowHandle, WM_QUIT, 0, StrToInt(IniAppGlobals.Identifier));

     { Get the process identifier for the window}
     GetWindowThreadProcessID(hWindowHandle, @hprocessID);
     if hprocessID <> 0 then
     begin
       { Get the process handle }
       processHandle := OpenProcess(PROCESS_TERMINATE or PROCESS_QUERY_INFORMATION,
         False, hprocessID);
       if processHandle <> 0 then
       begin
         { Terminate the process }
         TerminateProcess(processHandle, 0);
         CloseHandle(ProcessHandle);
       end;
     end;
   end;
end;

//----------------------------------------------------------------------------//

function LoadLicence(var errStr: string): boolean;
var
  arrLic:   TLicMemory;
  qry:      TMqmQuery;
  strCfg:   string;
//  strMain:  string;
  lic:      TRecLicVers1;
  lockCode: integer;
  tbInfoMqm, tbInfoMcm : ^TTblInfo;
begin
  tbInfoMqm := @tblInfo[table(tbl_Licence)];
  tbInfoMcm := @tblInfo[table(tbl_Licence2)];

  Result   := true;
  qry := CreateQuery(Cfg_DB);

  result := true;
  exit;


{$ifdef MCM}

  lockCode := 0;
  if Result then
  try
    lockCode := GetLockCode;  // change this with eran , needs to read the field LIC_LIC_STR_UPD
  except
    errStr := _('Invalid lock configuration');
    Result := false;
  end;

  if Result then
  try
    qry.SQL.Clear;
    qry.SQL.Add('select LIC_LIC_STR, LIC_VER_NUM from ' + tbInfoMcm.GetTableName);

    qry.Open;

    if qry.EOF then
    begin
      errStr := _('No licence for the configuration');
      Result := false;
      Abort
    end;

    strCfg    := qry.FieldByName('LIC_LIC_STR').AsString;

    qry.Close;
    qry.Free;

  except
    qry.Close;
    qry.Free;
  end;

  if Result then
  begin
    StringToLic(strCfg, arrLic);
    if not DecodeLicVers1(lic, arrLic, errStr) then
      Result := false
    else if 3 <> lic.MQMORMCM then
    begin
      errStr := _('Invalid License') + #13#10 + _('entered in demo mode');
      SetDemoLicMcm(lockCode);
      Result := false
    end
    else if lockCode = lic.lockNum then
      SetLicMcm(arrLic)
    else
    begin
      errStr := _('Invalid License') + #13#10 + _('entered in demo mode'); //_('Invalid lock code');
      SetDemoLicMcm(lockCode);
      Result := false
    end
  end;

  if not Result then
  begin
    errStr := errStr + #13#10 + _('entered in demo mode');
    SetDemoLicMcm(lockCode);
  end

{$else}

  lockCode := 0;
  if Result then
  try
    lockCode := GetLockCode;
  except
    errStr := _('Invalid lock configuration');
    Result := false;
  end;

  if Result then
  try
    qry.SQL.Clear;
    qry.SQL.Add('select LIC_LIC_STR, LIC_VER_NUM from ' + tbInfoMqm.GetTableName);

    qry.Open;

    if qry.EOF then
    begin
      errStr := _('No licence for the configuration');
      Result := false;
      Abort
    end;

    strCfg    := qry.FieldByName('LIC_LIC_STR').AsString;

    qry.Close;
    qry.Free;

  except
    qry.Close;
    qry.Free;
  end;

  if Result then
  begin
    StringToLic(strCfg, arrLic);
    if not DecodeLicVers1(lic, arrLic, errStr) then
      Result := false
    else if 2 <> lic.MQMORMCM then  // mqm
    begin
      errStr := _('Invalid License') + #13#10 + _('entered in demo mode');
      SetDemoLic(lockCode);
      Result := false
    end
    else if lockCode = lic.lockNum then
      SetLic(arrLic)
    else
    begin
      errStr := _('Invalid License') + #13#10 + _('entered in demo mode');
      SetDemoLic(lockCode);
      Result := false
    end
  end;

  if not Result then
  begin
    errStr := errStr + #13#10 + _('entered in demo mode');
    SetDemoLic(lockCode);
  end

{$endif}

end;

//----------------------------------------------------------------------------//

function LoadLicenceMCM(var errStr: string): boolean;
var
  arrLic:   TLicMemory;
  qryCfg,   qryMain : TMqmQuery;
  strCfg:   string;
  strMain:  string;
  lic:      TRecLicVers1;
  tbInfo: ^TTblInfo;
  mainDbCodeMcm : integer;
begin
  Result   := true;

  tbInfo := @tblInfo[tbl_Licence2];
  qryCfg := CreateQuery(Cfg_DB);
  qryMain := CreateQuery(Main_DB);

   try
     qryMain.SQL.Clear;
     qryMain.SQL.Add('select LIC_LIC_STR, LIC_VER_NUM from ' + tbInfo.GetTableName);
     qryMain.Open;

     if qryMain.EOF then
     begin
       Result := false;
     end;

     strMain    := qryMain.FieldByName('LIC_LIC_STR').AsString;
     mainDbCodeMcm := qryMain.FieldByName('LIC_VER_NUM').AsInteger;
     qryMain.Close;

   except
     Result := false;
     qryMain.Close;
   end;

   StringToLic(strMain, arrLic);
   if not DecodeLicVers1(lic, arrLic, errStr) then
     Result := false;

   if Result then
   begin
     try
       tbInfo := @tblInfo[tbl_cfg_AppGlobSettings];
       qryCfg.SQL.Clear;
       qryCfg.SQL.Add('select GS_GLOBALSETTINGS from ' + tbInfo.GetTableName);
       qryCfg.Open;

       if qryCfg.EOF then
       begin
         Result := false;
       end
       else
         strCfg    := qryCfg.FieldByName('GS_GLOBALSETTINGS').AsString;

       if strCfg = '' then
          strCfg := '0';

       if lic.lockNum <> GetLockFromChainStrStructure(strCfg) then
       begin
         errStr := _('Lock code are not compatible ...');
         Result := false;
       end;
       qryCfg.Close;

    except
      Result := false;
    end;

  end;

  if Result then
  begin
    if 3 <> lic.MQMORMCM then // mcm license
    begin
      SetDemoLicMcm(0);
    end
    else
      SetLicMcm(arrLic)
  end
  else
    SetDemoLicMcm(0);

  if not Result then
    errStr := _('Invalid License') + #13#10 + _('entered in demo mode');

end;

//----------------------------------------------------------------------------//

function LoadLicenceMQM(var errStr: string): boolean;
var
  arrLic:   TLicMemory;
  qryCfg,   qryMain : TMqmQuery;
  strCfg:   string;
  strMain:  string;
  lic:      TRecLicVers1;
  tbInfo: ^TTblInfo;
  mainDbCodeMqm : integer;
begin
  Result   := true;

  tbInfo := @tblInfo[tbl_Licence];
  qryCfg := CreateQuery(Cfg_DB);
  qryMain := CreateQuery(Main_DB);

  try
    qryMain.SQL.Clear;
    qryMain.SQL.Add('select LIC_LIC_STR, LIC_VER_NUM from ' + tbInfo.GetTableName);
    qryMain.Open;

    if qryMain.EOF then
    begin
      Result := false;
    end;

    strMain    := qryMain.FieldByName('LIC_LIC_STR').AsString;
    mainDbCodeMqm := qryMain.FieldByName('LIC_VER_NUM').AsInteger;
    qryMain.Close;

   except
     Result := false;
     qryMain.Close;
   end;

   StringToLic(strMain, arrLic);
   if not DecodeLicVers1(lic, arrLic, errStr) then
     Result := false;

   if Result then
   begin
     try
       tbInfo := @tblInfo[tbl_cfg_AppGlobSettings];
       qryCfg.SQL.Clear;
       qryCfg.SQL.Add('select GS_GLOBALSETTINGS from ' + tbInfo.GetTableName);
       qryCfg.Open;

       if qryCfg.EOF then
       begin
         Result := false;
       end
       else
         strCfg    := qryCfg.FieldByName('GS_GLOBALSETTINGS').AsString;

       if strCfg = '' then
          strCfg := '0';

       if lic.lockNum <> GetLockFromChainStrStructure(strCfg) then
       begin
         Result := false;
       end;
       qryCfg.Close;

      except
        Result := false;
      end;
  end;

  if Result then
  begin
    if 2 <> lic.MQMORMCM then // mqm license
    begin
      SetDemoLic(0);
    end
    else
      SetLic(arrLic)
  end
  else
    SetDemoLic(0);

  if not result then
    errStr := _('Invalid License') + #13#10 + _('entered in demo mode');

end;

//----------------------------------------------------------------------------//

function CheckLicenceForMain(var errStr: string): boolean;
var
  lic:    TRecLicVers1;
  strErr, Ws_Mqmcm_Type, MQMCM : string;
  qry:    TMqmQuery;
  currPlannerWk, currViewerWk : integer;
  WC_Used, WC_NotUsed :     TStringList;
  tbInfo_wkst, tbInfo_wkst_wkc, tbInfo_exchg_wkst : ^TTblInfo;
begin
  Result := false;
  currPlannerWk := 0;
  currViewerWk := 0;
  tbInfo_wkst       := @tblInfo[tbl_wkst];
  tbInfo_wkst_wkc   := @tblInfo[tbl_wkst_wkc];
  tbInfo_exchg_wkst := @tblInfo[tbl_cfg_exchg_wkst];

  if DBAppGlobals.MCM_App then
  begin
    MQMCM := 'MCM';
    Ws_Mqmcm_Type := '1';
    if not DecodeLicVers1(lic, s_licBytesMcm, strErr) then exit
  end
  else
  begin
    MQMCM := 'MQM';
    Ws_Mqmcm_Type := '0';
    if not DecodeLicVers1(lic, s_licBytes, strErr) then exit;
  end;

  if (lic.expiryDate < now ) and (lic.expiryDate <> 0 )then
  begin
    Result := false;
    errStr := _(MQMCM + ' License was valid till') + ' ' + DateTimeToStr(lic.expiryDate) +
                ' ' + _('and has expired. ' + MQMCM + ' will abort');
    exit;
  end;

  if lic.instType <> INST_CUSTOMER then
    Result := true
  else
  begin

    WC_Used := TStringList.Create;
    WC_NotUsed := TStringList.Create;

    // read the number of workstations available
    qry := CreateQuery(Main_DB);
    qry.SQL.Clear;
    qry.SQL.Add('select distinct WK_wkst_code from ' + tbInfo_wkst.GetTableName + ',' + tbInfo_wkst_wkc.GetTableName +
                ' where WK_WKST_CODE = WW_WKST_CODE and WK_IDENTIFIER = WW_IDENTIFIER' +
                ' and ww_typeused = ''1''' + ' and WK_WORKSTATIONTYPE = ' + QuotedStr(Ws_Mqmcm_Type) + ' Order by WK_wkst_code');
    qry.Open;

    while not qry.Eof do
    begin
      WC_Used.Add(qry.FieldByName('WK_wkst_code').AsString);
      qry.Next
    end;
    qry.Close;

    qry.SQL.Clear;
    qry.SQL.Add('select distinct WK_wkst_code from ' + tbInfo_wkst.GetTableName + ',' + tbInfo_wkst_wkc.GetTableName +
                ' where WK_WKST_CODE = WW_WKST_CODE and WK_IDENTIFIER = WW_IDENTIFIER' +
                ' and ww_typeused = ''2''' + ' and WK_WORKSTATIONTYPE = ' + QuotedStr(Ws_Mqmcm_Type) + ' Order by WK_wkst_code');
    qry.Open;

    while not qry.Eof do
    begin
      WC_NotUsed.Add(qry.FieldByName('WK_wkst_code').AsString);
      qry.Next
    end;

    qry.Close;
    qry.Free;

    if WC_Used.IndexOf(IniAppGlobals.WkstCode) > -1 then
      inc(currPlannerWk)
    else
    begin
      if WC_NotUsed.IndexOf(IniAppGlobals.WkstCode) > -1 then
        inc(currViewerWk);
    end;

    // read the number of workstations currently working
    qry := CreateQuery(Cfg_DB);
    qry.SQL.Add('select * from ' + tblInfo[tbl_cfg_exchg_wkst].GetTableName);
   // qry.SQL.Add(' where '  +  CreateFld(tblInfo[tbl_cfg_exchg_wkst].pfx, fli_POLL) + ' = ''1''');
    qry.SQL.Add(' where '  +  CreateFld(tblInfo[tbl_cfg_exchg_wkst].pfx, fli_OP) + ' <> ''-''');
    qry.Open;

    while not qry.Eof do
    begin
      if WC_Used.IndexOf(qry.FieldByName(CreateFld(tbInfo_exchg_wkst.pfx, fli_wkstCode)).AsString) > -1 then
        inc(currPlannerWk)
      else
      begin
        if WC_NotUsed.IndexOf(qry.FieldByName(CreateFld(tbInfo_exchg_wkst.pfx, fli_wkstCode)).AsString) > -1 then
          inc(currViewerWk);
      end;
      qry.Next
    end;

    qry.Close;
    qry.Free;
    WC_Used.Free;
    WC_NotUsed.Free;

    if (lic.maxCont > 0) and (currPlannerWk > lic.maxCont) then
    begin
      if lic.maxCont = 0 then
        errStr := _('Planners supported maximum are currently 0')
      else
        errStr := IntToStr(lic.maxCont) + ' ' +_('Planners are already working.' + ' ' + MQMCM + ' will be aborted');
      exit
    end;

    if (lic.maxSupp > 0) and (currViewerWk > lic.maxSupp) then
    begin
      if lic.maxSupp = 0 then
        errStr := _('Viewers maximum are currently 0')
      else
        errStr := IntToStr(lic.maxSupp) + ' ' +_('Viewers are already working.' + ' ' + MQMCM + ' will be aborted');
      exit
    end;

    Result := true
  end
end;

//----------------------------------------------------------------------------//

function LoadLicenceMCMSrv(var errStr: string): boolean;
var
  arrLic:   TLicMemory;
  qryCfg,   qryMain : TMqmQuery;
  strCfg:   string;
  strMain:  string;
  lic:      TRecLicVers1;
  lockCode: integer;
  tbInfo: ^TTblInfo;
  mainDbCodeMcm : integer;
begin
  Result   := true;

  tbInfo := @tblInfo[tbl_Licence2];
  qryCfg := CreateQuery(Cfg_DB);
  qryMain := CreateQuery(Main_DB);

  lockCode := GetLockCode;

   try
     qryMain.SQL.Clear;
     qryMain.SQL.Add('select LIC_LIC_STR, LIC_VER_NUM from ' + tbInfo.GetTableName);
     qryMain.Open;

     if qryMain.EOF then
     begin
       lockCode := 0;
       Result := false;
     end;

     strMain    := qryMain.FieldByName('LIC_LIC_STR').AsString;
     mainDbCodeMcm := qryMain.FieldByName('LIC_VER_NUM').AsInteger;
     qryMain.Close;

    except
      Result := false;
      lockCode := 0;
      qryMain.Close;
    end;

   if Result then
   begin
     try
       tbInfo := @tblInfo[tbl_cfg_AppGlobSettings];
       qryCfg.SQL.Clear;
       qryCfg.SQL.Add('select GS_GLOBALSETTINGS from ' + tbInfo.GetTableName);
       qryCfg.Open;

       if qryCfg.EOF then
       begin
         lockCode := 0;
         Result := false;
       end
       else
         strCfg    := qryCfg.FieldByName('GS_GLOBALSETTINGS').AsString;

       if strCfg = '' then
          strCfg := '0';

       if lockCode <> GetLockFromChainStrStructure(strCfg) then
       begin
         errStr := _('Lock code are not compatible ...');
         lockCode := 0;
         Result := false;
       end;
       qryCfg.Close;

      except
        Result := false;
      end;

  end;

  if Result then
  begin
    if mainDbCodeMcm <> CmainDbCodeMcm then
    begin
      Result := false;
    end;
  end;

  if Result then
  begin
    StringToLic(strMain, arrLic);
    if not DecodeLicVers1(lic, arrLic, errStr) then
      Result := false
    else if 3 <> lic.MQMORMCM then // mqm license
    begin
      SetDemoLicMcm(lockCode);
      Result := false
    end
    else if lockCode = lic.lockNum then
      SetLic(arrLic)
    else
    begin
      SetDemoLicMcm(lockCode);
      Result := false
    end
  end;

  if not Result then
    errStr := _('Invalid License') + #13#10 + _('entered in demo mode');

end;

//----------------------------------------------------------------------------//

function LoadLicenceMQMSrv(var errStr: string): boolean;
var
  arrLic:   TLicMemory;
  qryCfg,   qryMain : TMqmQuery;
  strCfg:   string;
  strMain:  string;
  lic:      TRecLicVers1;
  lockCode: integer;
  tbInfo: ^TTblInfo;
  mainDbCodeMqm : integer;
begin
  Result   := true;

  tbInfo := @tblInfo[tbl_Licence];
  qryCfg := CreateQuery(Cfg_DB);
  qryMain := CreateQuery(Main_DB);

  lockCode := GetLockCode;

   try
     qryMain.SQL.Clear;
     qryMain.SQL.Add('select LIC_LIC_STR, LIC_VER_NUM from ' + tbInfo.GetTableName);
     qryMain.Open;

     if qryMain.EOF then
     begin
       lockCode := 0;
       Result := false;
     end;

     strMain    := qryMain.FieldByName('LIC_LIC_STR').AsString;
     mainDbCodeMqm := qryMain.FieldByName('LIC_VER_NUM').AsInteger;
     qryMain.Close;

    except
      Result := false;
      lockCode := 0;
      qryMain.Close;
    end;

   if Result then
   begin
     try
       tbInfo := @tblInfo[tbl_cfg_AppGlobSettings];
       qryCfg.SQL.Clear;
       qryCfg.SQL.Add('select GS_GLOBALSETTINGS from ' + tbInfo.GetTableName);
       qryCfg.Open;

       if qryCfg.EOF then
       begin
         lockCode := 0;
         Result := false;
       end
       else
         strCfg    := qryCfg.FieldByName('GS_GLOBALSETTINGS').AsString;

       if strCfg = '' then
          strCfg := '0';

       if lockCode <> GetLockFromChainStrStructure(strCfg) then
       begin
         lockCode := 0;
         Result := false;
       end;
       qryCfg.Close;

      except
        Result := false;
      end;

  end;

  if Result then
  begin
    if mainDbCodeMqm <> CmainDbCodeMqm then
    begin
      Result := false;
    end;
  end;

  if Result then
  begin
    StringToLic(strMain, arrLic);
    if not DecodeLicVers1(lic, arrLic, errStr) then
      Result := false
    else if 2 <> lic.MQMORMCM then // mqm license
    begin
      errStr := _('Invalid License') + ' ' + _('entered in demo mode');
      SetDemoLic(lockCode);
      Result := false
    end
    else if lockCode = lic.lockNum then
      SetLic(arrLic)
    else
    begin
      Result := false
    end
  end;

  if not result then
    errStr := _('Invalid License') + #13#10 + _('entered in demo mode');

end;

//----------------------------------------------------------------------------//

function LoadLicenceCfg(enterIndemo: boolean; var errStrMqm , errStrMcm : string): boolean;
var
  arrLic:   TLicMemory;
  qryCfg,   qryMain :      TMqmQuery;
  strCfg, TMPSTR:   string;
  strMain:  string;
  lic:      TRecLicVers1;
  lockCode: integer;
  tbInfo: ^TTblInfo;
  MqmLic, McmLic : boolean;
  mainDbCodeMqm, mainDbCodeMcm : integer;
begin
  Result   := true;
  MqmLic   := true;
  errStrMqm := '';
  errStrMcm := '';

  tbInfo := @tblInfo[tbl_Licence];
  qryCfg := CreateQuery(Cfg_DB);
  qryMain := CreateQuery(Main_DB);

  lockCode := GetLockCode;

   try
     qryMain.SQL.Clear;
     qryMain.SQL.Add('select LIC_LIC_STR, LIC_VER_NUM from ' + tbInfo.GetTableName);
     qryMain.Open;

     if qryMain.EOF then
     begin
       errStrMqm := _('Licence is not installed ...');
       lockCode := 0;
       MqmLic := false;
     end;

     strMain    := qryMain.FieldByName('LIC_LIC_STR').AsString;
     mainDbCodeMqm := qryMain.FieldByName('LIC_VER_NUM').AsInteger;
     qryMain.Close;

    except
      MqmLic := false;
      lockCode := 0;
      errStrMqm := _('Invalid license key');
      qryMain.Close;
    end;


  if MqmLic then
  begin
    if mainDbCodeMqm <> CmainDbCodeMqm then
    begin
      errStrMqm := _('main database code version is not supported');
      MqmLic := false;
    end;
  end;

  if MqmLic then
  begin
    StringToLic(strMain, arrLic);
    if not DecodeLicVers1(lic, arrLic, errStrMqm) then
      MqmLic := false;

     if MqmLic then
     begin
       try
         tbInfo := @tblInfo[tbl_cfg_AppGlobSettings];
         qryCfg.SQL.Clear;
         qryCfg.SQL.Add('select GS_GLOBALSETTINGS from ' + tbInfo.GetTableName);
         qryCfg.Open;

         if qryCfg.EOF then
         begin
           errStrMqm := _('Licence is not installed ...');
           lockCode := 0;
           MqmLic := false;
         end
         else
           strCfg    := qryCfg.FieldByName('GS_GLOBALSETTINGS').AsString;

         if strCfg = '' then
            strCfg := '0';

         if lockCode <> GetLockFromChainStrStructure(strCfg) then
         begin
           errStrMqm := _('Lock code are not compatible ...');
         //  lockCode := 0;
           MqmLic := false;
         end;
         qryCfg.Close;

        except
          MqmLic := false;
          errStrMqm := _('Invalid license key');
        end;

    end;

    if MqmLic then
    begin
      if 2 <> lic.MQMORMCM then // mqm license
      begin
        errStrMqm := _('Invalid License') + ' ' + _('entered in demo mode');
        SetDemoLic(lockCode);
        MqmLic := false
      end
      else if lockCode = lic.lockNum then
        SetLic(arrLic)
      else
      begin
        errStrMqm := _('Invalid License') + ' ' + _('entered in demo mode'); //_('Invalid lock code');
        SetDemoLic(lockCode);
        MqmLic := false
      end
    end;
  end;

  if errStrMqm <> '' then
  begin
    SetDemoLic(lockCode);
  end;
  errStrMcm := '';

  // mcm licence

  tbInfo := @tblInfo[tbl_Licence2];
  lockCode := GetLockCode;
  McmLic   := true;

  try
    qryMain.SQL.Clear;
    qryMain.SQL.Add('select LIC_LIC_STR, LIC_VER_NUM from ' + tbInfo.GetTableName);

    qryMain.Open;

    if qryMain.EOF then
    begin
      errStrMcm := _('Licence is not installed ...');
      lockCode := 0;
      McmLic := false;
    end;

    strMain    := qryMain.FieldByName('LIC_LIC_STR').AsString;
    mainDbCodeMcm := qryMain.FieldByName('LIC_VER_NUM').AsInteger;
    qryMain.Close;

  except
    McmLic := false;
    lockCode := 0;
    errStrMcm := _('Invalid license key');
    qryMain.Close;
  end;

  if McmLic then
  begin
    if mainDbCodeMcm <> CmainDbCodeMcm then
    begin
      errStrMcm := _('main database code version is not supported');
      McmLic := false;
    end;
  end;

  if McmLic then
  begin
    StringToLic(strMain, arrLic);
    if not DecodeLicVers1(lic, arrLic, errStrMcm) then
      McmLic := false;

   if McmLic then
   begin
     try
       tbInfo := @tblInfo[tbl_cfg_AppGlobSettings];
       qryCfg.SQL.Clear;
       qryCfg.SQL.Add('select GS_GLOBALSETTINGS from ' + tbInfo.GetTableName);

       qryCfg.Open;

       if qryCfg.EOF then
       begin
         errStrMcm := _('Licence is not installed ...');
         lockCode := 0;
         McmLic := false;
       end
       else
         strCfg    := qryCfg.FieldByName('GS_GLOBALSETTINGS').AsString;

       if strCfg = '' then
          strCfg := '0';

       if lockCode <> GetLockFromChainStrStructure(strCfg) then
       begin
         errStrMcm := _('Lock code are not compatible ...');
         lockCode := 0;
         McmLic := false;
       end;
       qryCfg.Close;

      except
        McmLic := false;
        errStrMcm := _('Invalid license key');
      end;

    end;

    if McmLic then
    begin
      if 3 <> lic.MQMORMCM then // mqm license
      begin
        errStrMcm := _('Invalid License') + ' ' + _('entered in demo mode');
        SetDemoLicMcm(lockCode);
        McmLic := false
      end
      else if lockCode = lic.lockNum then
        SetLicMcm(arrLic)
      else
      begin
        errStrMcm := _('Invalid License') + ' ' + _('entered in demo mode'); //_('Invalid lock code');
        SetDemoLicMcm(lockCode);
        McmLic := false
      end
    end;

  end;

  qryMain.Free;
  qryCfg.Free;

  if not MqmLic and not McmLic then
    Result := false;

end;

//----------------------------------------------------------------------------//

function GetUDFcodeMqm(var code: integer): integer;
begin
  Result := (code * 2) div 6 - 2
end;

//----------------------------------------------------------------------------//

function GetUDFcodeMcm(var code: integer): integer;
begin
  Result := (code * 2) div 6 - 2
end;

//----------------------------------------------------------------------------//

function SaveLicenceMcm(var arr: TLicMemory; var errStr: string): boolean;
var
  qry, QryCfg : TMqmQuery;
  str: string;
  tbInfoMcm : ^TTblInfo;
  lic:        TRecLicVers1;
  LockStr : string;
begin

  tbInfoMcm := @tblInfo[table(tbl_Licence2)];

  errStr := '';

  qryCfg := CreateQuery(Cfg_DB);
  qry := CreateQuery(Main_DB);

  DecodeLicVers1(lic, arr, errStr);
  LockStr := SetLockToChainStrStructure(lic.lockNum);

  errStr := '';

  qry := CreateQuery(Main_DB);
  QryCfg := CreateQuery(Cfg_DB);

  with qry do
  begin
    str := LicToString(arr);

    SQL.Clear;
    SQL.Add('select * from ' + tbInfoMcm.GetLicTableName(false));
    Open;

    if EOF then
    begin
      Close;
      SQL.Clear;
      SQL.Add('insert into ' + tbInfoMcm.GetLicTableName(false) + ' (LIC_LIC_STR) values (''' + str + ''')');
      ExecSQL
    end
    else
    begin
      SQL.Clear;
      SQL.Add('update ' + tbInfoMcm.GetLicTableName(false) + ' set LIC_LIC_STR =''' + str +'''');
      ExecSQL
    end;
    Close
  end;

  qry.Free;

  with QryCfg do
  begin

    tbInfoMcm := @tblInfo[tbl_cfg_AppGlobSettings];

    SQL.Clear;
    SQL.Add('select * from ' + tbInfoMcm.GetLicTableName(true));
    Open;

    if EOF then
    begin
      Close;
      SQL.Clear;
      SQL.Add('insert into ' + tbInfoMcm.GetLicTableName(true) + ' (GS_GLOBALSETTINGS) values (''' + LockStr + ''')');
      ExecSQL
    end
    else
    begin
      SQL.Clear;
      SQL.Add('update ' + tbInfoMcm.GetLicTableName(true) + ' set GS_GLOBALSETTINGS =''' + LockStr +'''');
      ExecSQL
    end;
    Close
  end;


  Result := true
end;

//----------------------------------------------------------------------------//

function SaveLicenceMqm(var arr: TLicMemory; var errStr: string): boolean;
var
  qry, QryCfg : TMqmQuery;
  str: string;
  tbInfoMqm : ^TTblInfo;
  lic:        TRecLicVers1;
  LockStr : string;
begin
  tbInfoMqm := @tblInfo[table(tbl_Licence)];

  DecodeLicVers1(lic, arr, errStr);
  LockStr := SetLockToChainStrStructure(lic.lockNum);

  errStr := '';

  qry := CreateQuery(Main_DB);
  QryCfg := CreateQuery(Cfg_DB);

  with qry do
  begin
    str := LicToString(arr);

    SQL.Clear;
    SQL.Add('select * from ' + tbInfoMqm.GetLicTableName(false));
    Open;

    if EOF then
    begin
      Close;
      SQL.Clear;
      SQL.Add('insert into ' + tbInfoMqm.GetLicTableName(false) + ' (LIC_LIC_STR) values (''' + str + ''')');
      ExecSQL
    end
    else
    begin
      SQL.Clear;
      SQL.Add('update ' + tbInfoMqm.GetLicTableName(false) + ' set LIC_LIC_STR =''' + str +'''');
      ExecSQL
    end;
    Close
  end;

  qry.Free;

  with QryCfg do
  begin

    tbInfoMqm := @tblInfo[tbl_cfg_AppGlobSettings];

    SQL.Clear;
    SQL.Add('select * from ' + tbInfoMqm.GetLicTableName(true));
    Open;

    if EOF then
    begin
      Close;
      SQL.Clear;
      SQL.Add('insert into ' + tbInfoMqm.GetLicTableName(true) + ' (GS_GLOBALSETTINGS) values (''' + LockStr + ''')');
      ExecSQL
    end
    else
    begin
      SQL.Clear;
      SQL.Add('update ' + tbInfoMqm.GetLicTableName(true) + ' set GS_GLOBALSETTINGS =''' + LockStr +'''');
      ExecSQL
    end;
    Close
  end;


  Result := true
end;

//----------------------------------------------------------------------------//

procedure CreateViewForMain;
begin

end;

//----------------------------------------------------------------------------//

procedure CreateStoredForMain;
begin
  CrtProcGetCapResNum;
  CrtProcGetGrpNum;
  CrtProcGetNewReqNomber;
  CrtProcGetSplitFamilyCode
end;

//----------------------------------------------------------------------------//

procedure CreateStoredForCfg;
begin
  CrtProcGetAccess;
  CrtProcEndAccess;
  CrtProcActiveWrkst;
  CrtChangeAccess;
  CrtProcGetStatus;
  CrtProcIsExistClient;
  CrtUpdateClient;
  CrtJobMsgEvent;
  CrtSharedDataEvent;
  CrtProcSrvLoadStatus;
  CrtProcConnect;
 // CrtProcDisconnect;
  CrtProcAskPoll;
  CrtProcAskPollSrv;
  CrtProcCheckPoll;
  CrtProcCheckPollDellOldStation;
  CrtProcUpdatedDatabaseChange;
  CrtProcUpdatedDatabaseIncludeChangeWarp;

  CrtProcUpdatedDatabaseWarpOnly;

  CrtProcSrvLoadSetStatusOpenedOrClose;
  CrtProcSrvLoadGetStatusOpenedOrClose;
  CrtDownloadTriger;
  CrtSrvLoadTrigerUpdateStatus;
  TestEvent;
  CrtClientRequest;
  CrtClientStatusUpdate;

//  CrtExtFunctions
{CREATE OR REPLACE FUNCTION GETCODEMQM()
RETURNS INTEGER
SPECIFIC GETCODEMQM
external name 'McmAppUDF/GetUDFcodeMcm'
LANGUAGE C
NO SQL
PARAMETER STYLE DB2SQL   }

{

    select * from SYSCAT.ROUTINES where SPECIFICNAME= 'GETCODEMQM'
    -- drop function GETCODEMQM
}


 ///////////////////////////////////////////////////////
   // need to run sql command line
   // write: connect
   // Enter user name: sys as sysdba (whicj is the hieher level user)
   // Enter password : (empty)
   // you should get connected

   //  The reall systex to be used
   // GRANT EXECUTE ON sys.dbms_alert TO public;
{
drop public synonym dbms_system;

 CREATE PUBLIC SYNONYM dbms_system FOR dbms_alert;
 GRANT EXECUTE ON dbms_system TO APPS;
 }


end;

//----------------------------------------------------------------------------//

function CheckLicence(var errStr: string): boolean;
var
  lic:    TRecLicVers1;
  strErr: string;

  qry :    TMqmQuery;
  currPlannerWk, currViewerWk : integer;
//  numWk:  integer;
  sl:     TStringList;
  tbInfo_wkst, tbInfo_exchg_wkst, tbInfo_wkst_wkc : ^TTblInfo;
begin
  /// avi new test pc
  result := true;
              exit;


  Result := false;
  currPlannerWk := 0;
  currViewerWk := 0;
  tbInfo_wkst       := @tblInfo[tbl_wkst];
  tbInfo_exchg_wkst := @tblInfo[tbl_cfg_exchg_wkst];
  tbInfo_wkst_wkc   := @tblInfo[tbl_wkst_wkc];

  if not DecodeLicVers1(lic, s_licBytes, strErr) then exit;

  if (lic.expiryDate < now ) and (lic.expiryDate <> 0 )then
  begin
    Result := false;
    errStr := _('MQM License was valid till') + ' ' + DateTimeToStr(lic.expiryDate) +
                ' ' + _('and has expired. MQM will abort');
    exit;
  end;

  if lic.instType <> INST_CUSTOMER then
    Result := true
  else
  begin
    sl := TStringList.Create;
    // read the number of workstations available
    qry := CreateQuery(Main_DB);

    qry.SQL.Add('select distinct WK_wkst_code from ' + tbInfo_wkst.GetTableName + ',' + tbInfo_wkst_wkc.GetTableName +
                ' where WK_WKST_CODE = WW_WKST_CODE and ww_typeused = ''1''' + ' Order by WK_wkst_code');
    qry.Open;

    while not qry.Eof do
    begin
      sl.Add(qry.FieldByName('WK_wkst_code').AsString);
      qry.Next
    end;

//    numWk := sl.Count;
    qry.Close;
   // trs.Commit;

    qry.Free;
  //  trs.Free;

    if sl.IndexOf(IniAppGlobals.WkstCode) > -1 then
      inc(currPlannerWk)
    else
      inc(currViewerWk);

    // read the number of workstations currently working
    qry := CreateQuery(Cfg_DB);

    qry.SQL.Add('select * from ' + tblInfo[tbl_cfg_exchg_wkst].GetTableName);
//    qry.SQL.Add(' where '  +  CreateFld(tblInfo[tbl_cfg_exchg_wkst].pfx, fli_POLL) + ' = ''1''');
    qry.SQL.Add(' where '  +  CreateFld(tblInfo[tbl_cfg_exchg_wkst].pfx, fli_OP) + ' <> ''-''');
    qry.Open;

    while not qry.Eof do
    begin
      if sl.IndexOf(qry.FieldByName(CreateFld(tbInfo_exchg_wkst.pfx, fli_wkstCode)).AsString) > -1 then
        inc(currPlannerWk)
      else
        inc(currViewerWk);
      qry.Next
    end;

    qry.Close;
    qry.Free;

    sl.Free;

    if (currPlannerWk > lic.maxCont) then
    begin
      errStr := IntToStr(lic.maxCont) + ' ' +_('Planners are already working');
      exit
    end;

    if (currViewerWk > lic.maxSupp) then
    begin
      errStr := IntToStr(lic.maxSupp) + ' ' +_('Viewers are already working');
      exit
    end;

    Result := true
  end

end;

//----------------------------------------------------------------------------//

function SetLockToChainStrStructure(LockCode : Integer) : string;
const
  ArrayStr : array [0..36] of string = ('T', 'B', '*', 'C',
                                        '$', '%', 'Q', ')',
                                        'V', ']', '?', 'A',
                                        'H', '/', 'U', 'J',
                                        'I', 'N', 'Z', '[',
                                        'L', 'M', 'G', 'O',
                                        '(', 'P','\',  'R',
                                        'S', 'W', '}', 'X', 'E',
                                        'Y', 'D', 'K', '{'
                                        );
var
  I : Integer;
  Lockcount : integer;
  LockCodeStr : string;
  Num : integer;
begin
  Result := '';

  LockCodeStr := IntToStr(LockCode);
  Lockcount := Length(LockCodeStr);

  for I := 1 to Lockcount do
  begin

    if LockCodeStr[I] = '-' then
    begin
      Result := '-';
      continue;
    end;

    Num := StrToInt(LockCodeStr[I]);
    if I mod 2 = 0 then
    begin
      if Num >= 4 then
        Num := Num * 4;
    end
    else
    begin
      if Num >= 3 then
        Num := Num * 3
    end;

    Result := Result + ArrayStr[Num];
  end;

end;

//----------------------------------------------------------------------------//

function GetLockFromChainStrStructure(ChainStr : string) : integer;
const
  ArrayStr : array [0..36] of string = ('T', 'B', '*', 'C',
                                        '$', '%', 'Q', ')',
                                        'V', ']', '?', 'A',
                                        'H', '/', 'U', 'J',
                                        'I', 'N', 'Z', '[',
                                        'L', 'M', 'G', 'O',
                                        '(', 'P', '\', 'R',
                                        'S', 'W', '}', 'X', 'E',
                                        'Y', 'D', 'K', '{'
                                        );
var
  I, J : Integer;
  Chaincount : integer;
  LockCodeStr : string;
  Num : double;
  Char : string;
begin
  LockCodeStr := '';
  Chaincount := Length(ChainStr);

  for I := 1 to Chaincount do
  begin
    Char := ChainStr[I];

    if (ChainStr[I] = '-') then
    begin
      LockCodeStr := '-';
      continue
    end;

    for J := Low(ArrayStr) to High(ArrayStr) do
    begin
      if Char = ArrayStr[J] then
      begin
        Num := J;
        break
      end;
    end;

    if I mod 2 = 0 then
    begin
      if Num >= 4 then
        Num := Num / 4;
    end
    else
    begin
      if Num >= 3 then
        Num := Num / 3
    end;

    LockCodeStr := LockCodeStr + FloatToStr(Num);

    Result := StrToInt(LockCodeStr);
  end;
end;

//----------------------------------------------------------------------------//

end.
