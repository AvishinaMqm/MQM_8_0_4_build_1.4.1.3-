unit UOpThread;

interface

uses
  Windows, Dialogs,
  Messages, ActiveX, UMSrvConfig,forms,Umglobal,
  gnugettext, DMsrvPc,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Comp.Client, FireDAC.Comp.DataSet,
  FireDAC.Phys.IBBase, FireDAC.VCLUI.Wait, FireDAC.Comp.UI, FireDAC.Phys.IB,
  FireDAC.Phys.FB, FireDAC.Phys, FireDAC.Phys.ODBCBase, FireDAC.Phys.ODBC,
  FireDAC.Phys.FBDef, FireDAC.Phys.IBDef, FireDAC.Phys.ODBCDef,
  FireDAC.Phys.DB2Def, FireDAC.Phys.DB2, FireDAC.Phys.OracleDef,FireDAC.Stan.Option,
  FireDAC.Phys.Oracle;

const
  TCloadDelay   = 1 / 24 / 60 * 2;       // after 2 minute

  procedure StartLoadingManual(itfHdl: THandle);
  procedure StartLoadingPS(itfHdl: THandle);
  procedure StartOperating(itfHdl: THandle);
  procedure StartExchDataSeq(itfHdl: THandle);
  procedure StopOperating;
  procedure EndOperation(EndWell : boolean);
  procedure DestroyThread;
  function  ThreadDestroied: boolean;
  function  IsOperating: boolean;
  procedure ClearLastSave;
  function  ThreadCreateQuery(DBType: TMqmDBType): TFDQuery;
  function  ThreadCreateQueryHost : TMqmQuery;
  function  ThreadCreateQueryArc  : TMqmQuery;
  function  ThreadCreateTransaction(DBType: TMqmDBType) : TMqmTransaction;
  function  ThreadCreateStoredProc(DBType: TMqmDBType): TMqmStoredProc;
  function  ThreadCloneMainConnection: TMqmDatabase;
  function  ThreadCloneHostConnection: TMqmDatabase;
  function  ThreadCloneArcConnection: TMqmDatabase;

implementation

uses
  Classes,
  SysUtils,
  UMASStoredProc,
  UMStoredProc,
  UMSrvLoad,
  UMCommon,
  UMTblDesc,
  UGconvert,
  UGLicensing,
  UMTransfer;

const
  TRY_NUMBER = 100;

type
  TOperativeThread = class(TThread)
    constructor CreateOperative(itfHdl: THandle);
    destructor Destroy; override;
    function  DownloadFromHost(var DataChange : boolean ; Handl : THandle; var GotAccessToInsertData : boolean):boolean;
    function  OperateDownload(var DataChange : boolean; var EndWell : boolean; Handl : THandle): boolean;
//    procedure OperateSynchronizeForDownLoad;
    procedure DownloadPsFromAS;
    procedure DownloadFromPc;
    procedure SendScheduledToHOST;
    function  SendScheduledTo_NOW_HOST(var Is_SCHEDULESUPLOAD_emptyMQM : boolean; var Is_SCHEDULESUPLOAD_emptyMCM : boolean; var MQM_OR_MCM_ENVIRONMENT : string) : boolean;
    function  SendWarpSchedTo_NOW_HOST : boolean;
    procedure SendArcToHOST;
    procedure SendToPc;
    procedure TerminatedProgram;
    procedure ThreadDone(Sender: TObject);
    function  ThreadCreateQuery(DBType: TMqmDBType): TMqmQuery;
    function  ThreadCreateQueryHost : TMqmQuery;
    function  ThreadCreateQueryArc : TMqmQuery;
    function  ThreadCreateTransaction(DBType: TMqmDBType) : TMqmTransaction;
    function  ThreadCreateStoredProc(DBType: TMqmDBType): TMqmStoredProc;
    function  ThreadCloneMainConnection: TMqmDatabase;
    function  ThreadCloneHostConnection: TMqmDatabase;
    function  ThreadCloneArcConnection: TMqmDatabase;
    function  openThreadConnection : boolean;
    procedure ConnectDB_main;
    procedure ConnectDB_Cfg;
    procedure ConnectDB_Host;
    procedure ConnectDB_Arc;
    procedure SetThreadRunStatus(status : string);
    function  ConnectToDatabase(Wrkst: string) : boolean;
    function  DisConnectToDatabase(Wrkst: string) : boolean;
    procedure DISCONNECT(Wrkst: string);
    procedure THREAD_ASK_POLL;
    procedure THREAD_CHECK_POLL;
    procedure CloseThreadConnection;
    procedure UpdateClient;

    procedure UpdateClient_Include_Warp;
    procedure UpdateClient_Only_Warp;

    procedure UpdateLastDwnDateTimeAS400;
    procedure CT_CLEAR_CONTROL_AFTER_DWNLD_AS400;
    function  CT_GET_ACCESS_HOST_AS400 : boolean;
    function  CT_END_UPLOAD : boolean;
    function  CT_CLEAR_PROCCESS_HOST : boolean;
    procedure CT_END_ACCESS(Wrkst: string);
    procedure Execute; override;
  private
   // m_DataChange, m_EndWell : boolean;

    m_MainDB: TMqmDatabase;
    m_CFGDB:  TMqmDatabase;
    m_DBHost: TMqmDatabase;
    m_DBArc: TMqmDatabase;

    m_itfHdl:   THandle;
    m_op:       integer;
    m_loadMode: TDOloadMode;
    m_saveMode: TDOsaveMode;
    m_SignServer : boolean;
    m_LoadPSMode:  TDOloadMode;

    m_lastLoad:      TDateTime;
    m_lastSave:      TDateTime;

    procedure ClearStatuseOp;
    function CheckEndingTimeLoop : boolean;
    function CheckServerDoubleInstance : boolean;
  public
    m_running:  boolean;
    e_Exception : Exception;
  end;

var
  s_OpThread: TOperativeThread;

//----------------------------------------------------------------------------//

procedure StartLoadingManual(itfHdl: THandle);
begin
  if not Assigned(s_OpThread) then
    s_OpThread := TOperativeThread.CreateOperative(itfHdl);
  Assert(s_OpThread.m_running = false);
  s_OpThread.m_loadMode := TDOL_manual;
  s_OpThread.m_saveMode := TDOS_none;
  s_OpThread.m_loadPSMode := TDOL_none;
  s_OpThread.m_running := true;
  s_OpThread.Start
end;

//----------------------------------------------------------------------------//

procedure StartLoadingPS(itfHdl: THandle);
begin
  if not Assigned(s_OpThread) then
    s_OpThread := TOperativeThread.CreateOperative(itfHdl);
  Assert(s_OpThread.m_running = false);
  s_OpThread.m_loadMode := TDOL_none;
  s_OpThread.m_saveMode := TDOS_none;
  s_OpThread.m_loadPSMode := TDOL_manual;
  s_OpThread.m_running := true;
  s_OpThread.Start
end;

//----------------------------------------------------------------------------//

procedure StartExchDataSeq(itfHdl: THandle);
begin
  if not Assigned(s_OpThread) then
    s_OpThread := TOperativeThread.CreateOperative(itfHdl);
  Assert(s_OpThread.m_running = false);

  if (IniAppGlobals.OperateTimeLoopDnldUpload = '1') and FSrvLoad.IsDnwUploadOperated then
    s_OpThread.m_loadMode := TDOL_auto
  else
    s_OpThread.m_loadMode := TDOL_manual;
  s_OpThread.m_saveMode := TDOS_manual;
  s_OpThread.m_loadPSMode := TDOL_none;
  s_OpThread.m_running := true;
  s_OpThread.Start
end;

//----------------------------------------------------------------------------//

procedure StartOperating(itfHdl: THandle);
begin
  if not Assigned(s_OpThread) then
    s_OpThread := TOperativeThread.CreateOperative(itfHdl);
  Assert(s_OpThread.m_running = false);
  s_OpThread.m_loadMode := TDOL_manual;
  s_OpThread.m_saveMode := TDOS_auto;
  s_OpThread.m_loadPSMode := TDOL_none;
  s_OpThread.m_running := true;
  s_OpThread.Start
end;

//----------------------------------------------------------------------------//

procedure StopOperating;
begin
  Assert(s_OpThread.m_running = true);
  s_OpThread.m_running := false;
  s_OpThread.ClearStatuseOp;
  s_OpThread.m_lastLoad := 0;
  s_OpThread.SetThreadRunStatus('0');
  s_OpThread.DISCONNECT('SERVER');
  if not s_OpThread.m_SignServer then
  begin
    s_OpThread.m_SignServer := true;
  end;
  s_OpThread.Terminate;
  s_OpThread := nil;
  while not ThreadDestroied do;
end;

//----------------------------------------------------------------------------//

procedure EndOperation(EndWell : boolean);
begin
  Assert(s_OpThread.m_running = true);
  s_OpThread.m_running := false;
  FSrvLoad.DeleteOldRequest;
  UpdateStatuseBtn(true, true);
  if EndWell then
  begin
    UpdateOperation(_('Download completed'));
    if (GetTypeRequest = TD_Client) or (GetTypeRequest = TD_Scheduled) then
      WriteToLog(_('Ended') , '', false);
    SetTypeRequest(TD_Manual);
    FSrvLoad.LabelDownOp.Caption := '';
  end
  else
  begin
    if (GetTypeMode = TD_DownLoadAfterUpload) or (GetTypeMode = TD_OnlyUpload) then
       WriteToLog(_('Incomplete') , 'NOW system did not process the previous upload yet - Upload can not be performed', false);
    UpdateOperation(_('Download not completed'));
  end;
  s_OpThread.m_lastLoad := 0;
  if not s_OpThread.m_SignServer then
  begin
    s_OpThread.SetThreadRunStatus('0');
   // s_OpThread.DisConnectToDatabase('SERVER');
    UPDATE_ACCESS_OPERATION('SERVER', AT_Blank, Now);
    s_OpThread.m_SignServer := true;
  end;
  s_OpThread.Terminate;
end;

//----------------------------------------------------------------------------//

procedure DestroyThread;
begin
  if Assigned(s_OpThread) then
  begin
    s_OpThread.Free;
    s_OpThread := nil
  end
end;

//----------------------------------------------------------------------------//

function ThreadDestroied: boolean;
begin
  Result :=  not Assigned(s_OpThread);
end;

//----------------------------------------------------------------------------//

function IsOperating: boolean;
begin
  Result := false;
  if not Assigned(s_OpThread) then exit;
  Result := s_OpThread.m_running
end;

//----------------------------------------------------------------------------//

procedure ClearLastSave;
begin
  if not Assigned(s_OpThread) then exit;
    s_OpThread.m_lastSave := 0
end;

//----------------------------------------------------------------------------//

function ThreadCreateQuery(DBType: TMqmDBType): TFDQuery;
begin
  Result := s_OpThread.ThreadCreateQuery(DBType);
end;

//----------------------------------------------------------------------------//

function TOperativeThread.ThreadCloneMainConnection: TMqmDatabase;
begin
  Result := TFDConnection.Create(nil);
  Result.Params.Assign(m_MainDB.Params);
  Result.LoginPrompt := False;
  Result.Open;
end;

function ThreadCloneMainConnection: TMqmDatabase;
begin
  Result := s_OpThread.ThreadCloneMainConnection;
end;

function TOperativeThread.ThreadCloneHostConnection: TMqmDatabase;
begin
  Result := TFDConnection.Create(nil);
  Result.Params.Assign(m_DBHost.Params);
  Result.LoginPrompt := False;
  Result.Open;
end;

function ThreadCloneHostConnection: TMqmDatabase;
begin
  Result := s_OpThread.ThreadCloneHostConnection;
end;

function TOperativeThread.ThreadCloneArcConnection: TMqmDatabase;
begin
  Result := TFDConnection.Create(nil);
  Result.Params.Assign(m_DBArc.Params);
  Result.LoginPrompt := False;
  Result.Open;
end;

function ThreadCloneArcConnection: TMqmDatabase;
begin
  Result := s_OpThread.ThreadCloneArcConnection;
end;

//----------------------------------------------------------------------------//

function ThreadCreateQueryHost : TMqmQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := s_OpThread.m_DBHost;
  Result.ResourceOptions.MacroCreate := False;
  Result.ResourceOptions.MacroExpand := False;
  Result.FetchOptions.Unidirectional := true;
  Result.FetchOptions.RowsetSize := 5000;
  Result.FetchOptions.Mode := fmAll;
  Result.FetchOptions.AutoFetchAll := afAll;
end;

//----------------------------------------------------------------------------//

function ThreadCreateQueryArc : TMqmQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.ResourceOptions.MacroCreate := False;
  Result.ResourceOptions.MacroExpand := False;
  Result.Connection := s_OpThread.m_DBArc;
  Result.FetchOptions.Unidirectional := true;
  Result.FetchOptions.RowsetSize := 5000;
  Result.FetchOptions.Mode := fmAll;
  Result.FetchOptions.AutoFetchAll := afAll;
end;

//----------------------------------------------------------------------------//

function ThreadCreateTransaction(DBType: TMqmDBType) : TMqmTransaction;
begin
  Result := s_OpThread.ThreadCreateTransaction(DBType)
end;

//----------------------------------------------------------------------------//

function ThreadCreateStoredProc(DBType: TMqmDBType): TMqmStoredProc;
begin
  Result := s_OpThread.ThreadCreateStoredProc(DBType)
end;

//----------------------------------------------------------------------------//

procedure TOperativeThread.ThreadDone(Sender: TObject);
begin
  s_OpThread := nil;
  if assigned(e_Exception) then
    raise e_Exception;
end;

//----------------------------------------------------------------------------//

function TOperativeThread.ThreadCreateQuery(DBType: TMqmDBType): TMqmQuery;
begin
  Result := TFDQuery.Create(nil);

  Result.CachedUpdates  := true;
  Result.FetchOptions.Unidirectional := true;

  Result.ResourceOptions.DirectExecute := true;
  Result.FetchOptions.RowsetSize := 1000;

  Result.FetchOptions.Mode := fmAll;
  Result.FetchOptions.Items :=[fiBlobs, fiDetails, fiMeta]; // = TFDFetchItems() << fiBlobs << fiDetails;
  Result.FetchOptions.AutoFetchAll := afAll;

  Result.UpdateOptions.ReadOnly := false;
  Result.UpdateOptions.RequestLive := false;

  Result.UpdateOptions.RequestLive := false;
  Result.ResourceOptions.MacroCreate := False;
  Result.ResourceOptions.MacroExpand := False;

  case DBType of
    Main_DB : Result.Connection := m_MainDB;
    Cfg_DB : Result.Connection := m_CFGDB;
  end;
end;

//----------------------------------------------------------------------------//

function TOperativeThread.ThreadCreateQueryHost : TMqmQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := m_DBHost;
  Result.ResourceOptions.MacroCreate := False;
  Result.ResourceOptions.MacroExpand := False;
  Result.FetchOptions.Unidirectional := true;
  Result.FetchOptions.RowsetSize := 5000;
  Result.FetchOptions.Mode := fmAll;
  Result.FetchOptions.AutoFetchAll := afAll;
end;

//----------------------------------------------------------------------------//

function TOperativeThread.ThreadCreateQueryArc : TMqmQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := m_DBArc;
  Result.ResourceOptions.MacroCreate := False;
  Result.ResourceOptions.MacroExpand := False;
  Result.FetchOptions.Unidirectional := true;
  Result.FetchOptions.RowsetSize := 5000;
  Result.FetchOptions.Mode := fmAll;
  Result.FetchOptions.AutoFetchAll := afAll;
end;

//----------------------------------------------------------------------------//

function TOperativeThread.ThreadCreateTransaction(DBType: TMqmDBType) : TMqmTransaction;
begin
  Result := TFDTransaction.Create(nil);
  if DBType = Main_DB then
    Result.Connection := m_MainDB
  else if DBType = Cfg_DB then
    Result.Connection := m_CFGDB
  else if DBType = Arc_DB then
    Result.Connection := m_DBArc
  else
    Result.Connection := m_DBHost;

  Result.Connection.UpdateOptions.LockWait := False;
  Result.Options.ReadOnly := False;
end;

//----------------------------------------------------------------------------//

function TOperativeThread.ThreadCreateStoredProc(DBType: TMqmDBType): TMqmStoredProc;
begin
  Result := TMqmStoredProc.Create(nil);
  case DBType of
    Cfg_DB  : Result.Connection := DMib.m_CfgDB;
    Main_DB : Result.Connection := DMib.m_MainDB;
  end;
end;

//----------------------------------------------------------------------------//

function TOperativeThread.openThreadConnection : boolean;
begin
  result := true;
  FSrvLoad.Timer1.Interval := StrToInt(IniAppglobals.CheckTimer) * 60000;//minute
  try
    ConnectDB_Cfg;
    ConnectDB_main;
    ConnectDB_Host;
    ConnectDB_Arc;
  except
    FSrvLoad.Timer1.Interval := StrToInt(IniAppglobals.CheckTimer) * 100; // call immidiatly when no connection
    Result := false;
  end;
end;

//----------------------------------------------------------------------------//

procedure TOperativeThread.ConnectDB_main;
begin
  m_MainDB.Connected := false;
  m_MainDB.Params.Clear;
  if IniAppGlobals.DownloadTo = '0' then
  begin
    with m_MainDB.params do
    begin
      Clear;
      Add('DriverID=DB2');
      Add('Server=' + IniAppGlobals.NOWDB2SrvIPLocal);
      Add('Database=' + IniAppGlobals.NOWDB2DataSourceLocal);
      Add('Port=' + IniAppGlobals.NOWDB2PORTLocal);
      Add('Protocol=TCPIP');
      Add('User_Name=' + IniAppGlobals.NOWDB2UserNameLocal);
      Add('Password=' + IniAppGlobals.NOWDB2PasswordLocal);
    end;
  end

  else if IniAppGlobals.DownloadTo = '1' then
  begin
    m_MainDB.DriverName := 'Ora';
    with m_MainDB.params do
    begin
      Clear;
      Add('DriverID=Ora');
      Add('Database=' + IniAppGlobals.NOWOracleTNSNameLocal);
      Add('User_Name=' + IniAppGlobals.NOWOracleUserNameLocal);
      Add('Password=' + IniAppGlobals.NOWOraclePasswordLocal);
    end;
  end

  else if IniAppGlobals.DownloadTo = '2' then
  begin
    m_MainDB.LoginPrompt := false;
    m_MainDB.DriverName := 'IB';
    if IniAppGlobals.Server <> '' then
      m_MainDB.Params.Add('Database=' + IniAppGlobals.Server + IniAppGlobals.MainDBPath + 'MQM_MAIN.gdb')
    else
      m_MainDB.Params.Add('Database=LocalHost:' + IniAppGlobals.MainDBPath + 'MQM_MAIN.gdb');

    m_MainDB.Params.Add('User_Name='+ IniAppGlobals.IBUserName);
    m_MainDB.Params.Add('Password='+ IniAppGlobals.IBPassword);

  end;

  m_MainDB.Connected := true;
end;

//----------------------------------------------------------------------------//

procedure TOperativeThread.ConnectDB_Cfg;
begin
  m_CFGDB.Connected := false;
  m_CFGDB.Params.Clear;
  if IniAppGlobals.DownloadTo = '0' then
  begin
    with m_CFGDB.params do
    begin
      Clear;
      Add('DriverID=DB2');
      Add('Server=' + IniAppGlobals.NOWDB2SrvIPLocal);
      Add('Database=' + IniAppGlobals.NOWDB2DataSourceLocal);
      Add('Port=' + IniAppGlobals.NOWDB2PORTLocal);
      Add('Protocol=TCPIP');
      Add('User_Name=' + IniAppGlobals.NOWDB2UserNameLocal);
      Add('Password=' + IniAppGlobals.NOWDB2PasswordLocal);
    end;
  end

  else if IniAppGlobals.DownloadTo = '1' then
  begin
    if IniAppGlobals.DownloadFrom = '2' then
    begin
      with m_CFGDB.params do
      begin
        Clear;
        Add('DriverID=ODBC');
        Add('Datasource=' + IniAppGlobals.AliasOdbc);
        Add('User_Name=' + IniAppGlobals.ODBCUserName);
        Add('Password='+IniAppGlobals.ODBCPassword);
      end;
    end
    else
    begin
      m_CFGDB.DriverName := 'Ora';
      with m_CFGDB.params do
      begin
        Clear;
        Add('DriverID=Ora');
        Add('Database=' + IniAppGlobals.NOWOracleTNSNameLocal);
        Add('User_Name=' + IniAppGlobals.NOWOracleUserNameLocal);
        Add('Password=' + IniAppGlobals.NOWOraclePasswordLocal);
      end;
    end
  end

  else if IniAppGlobals.DownloadTo = '2' then
  begin
    m_CFGDB.LoginPrompt := false;
    m_CFGDB.DriverName := 'IB';
    if IniAppGlobals.Server <> '' then
      m_CFGDB.Params.Add('Database=' + IniAppGlobals.Server + IniAppGlobals.CfgDBPath + 'MQM_CFG.gdb')
    else
      m_CFGDB.Params.Add('Database=LocalHost:' + IniAppGlobals.CfgDBPath + 'MQM_CFG.gdb');
    m_CFGDB.Params.Add('User_Name='+ IniAppGlobals.IBUserName);
    m_CFGDB.Params.Add('Password='+ IniAppGlobals.IBPassword);
  end;

  m_CFGDB.Connected := true;
end;

//----------------------------------------------------------------------------//

procedure TOperativeThread.ConnectDB_Host;
begin
  if IniAppGlobals.DownloadFrom = '0' then
  begin
    m_DBHost.DriverName := 'DB2';
    with m_DBHost.params do
    begin
      Clear;
      Add('DriverID=DB2');
      Add('Server=' + IniAppGlobals.NOWDB2SrvIP);
      Add('Database=' + IniAppGlobals.NOWDB2DataSource);
      Add('Port=' + IniAppGlobals.NOWDB2PORT);
      Add('Protocol=TCPIP');
      Add('User_Name=' + IniAppGlobals.NOWDB2UserName);
      Add('Password=' + IniAppGlobals.NOWDB2Password);
    end;
  end

  else if IniAppGlobals.DownloadFrom = '1' then
  begin
    m_DBHost.DriverName := 'Ora';
    with m_DBHost.params do
    begin
      Clear;
      Add('DriverID=Ora');
      Add('Database=' + IniAppGlobals.NOWOracleTNSName);
      Add('User_Name=' + IniAppGlobals.NOWOracleUserName);
      Add('Password=' + IniAppGlobals.NOWOraclePassword);
    end;
  end

  else if IniAppGlobals.DownloadFrom = '2' then
  begin
   //  ODBC Connection
    With m_DBHost.Params do
    begin
      Clear;
      Add('DriverID=ODBC');
      Add('Datasource=' + IniAppGlobals.AliasOdbc);
      Add('User_Name=' + IniAppGlobals.ODBCUserName);
      Add('Password='+IniAppGlobals.ODBCPassword);
   end;

  end;

  m_DBHost.Connected := true;

end;

//----------------------------------------------------------------------------//

procedure TOperativeThread.ConnectDB_Arc;
begin
  if trim(IniAppGlobals.PreparationExeName) = '' then exit;

  if IniAppGlobals.downloadTo = '2' then
  begin
    m_DBArc.DriverName := 'IB';
    m_DBArc.Params.Add('Database=LocalHost:' + IniAppGlobals.ArcDBPath + 'NOW_MQM_MAIN.gdb');
    m_DBArc.Params.Add('User_Name='+ IniAppGlobals.IBUserName);
    m_DBArc.Params.Add('Password='+ IniAppGlobals.IBPassword);
  end
  else if IniAppGlobals.downloadTo = '0' then
  begin
    m_DBArc.DriverName := 'DB2';
    with m_DBArc.params do
    begin
      Clear;
      Add('DriverID=DB2');
      Add('Server=' + IniAppGlobals.NOWDB2SrvIPLocal);
      Add('Database=' + IniAppGlobals.NOWDB2DataSourceLocal);
      Add('Port=' + IniAppGlobals.NOWDB2PORTLocal);
      Add('Protocol=TCPIP');
      Add('User_Name=' + IniAppGlobals.NOWDB2UserNameLocal);
      Add('Password=' + IniAppGlobals.NOWDB2PasswordLocal);
    end;
  end
  else if IniAppGlobals.downloadTo = '1' then
  begin
    m_DBArc.DriverName := 'Ora';
    with m_DBArc.params do
    begin
      Clear;
      Add('DriverID=Ora');
      Add('Database=' + IniAppGlobals.NOWOracleTNSName);
      Add('User_Name=' + IniAppGlobals.NOWOracleUserName);
      Add('Password=' + IniAppGlobals.NOWOraclePassword);
    end;
  end;
  m_DBArc.Connected := true;
end;

//----------------------------------------------------------------------------//

procedure TOperativeThread.SetThreadRunStatus(status : string);
var
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
  StoredProc: TMqmStoredProc;
  StoredProcName : string;
  SL : TStringList;
begin
  {$ifdef DEVMQMCM}
     Exit;
  {$endif}
  qry := ThreadCreateQuery(Cfg_DB);
  Qry.Transaction := ThreadCreateTransaction(Cfg_DB);
  Qry.Transaction.StartTransaction;

  tbInfo := @tblInfo[tbl_cfg_exchg_glob];
  qry.Close;
  qry.SQL.Clear;

  try
  qry.SQL.Add('select * from ' + tbInfo.GetTableName + WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
  qry.Open;
  if qry.Eof then
  begin
    qry.SQL.Clear;
    qry.SQL.Add(' INSERT INTO ' + tbInfo.GetTableName + '(CEG_IDENTIFIER, CEG_LAST_UPD,CEG_SL_OP,CEG_SL_ON) values (' + IniAppGlobals.Identifier + ', ' + '0' + ', ' + '0' + ' ,' + '0' + ')');
    qry.ExecSQL;
  end;

  qry.SQL.Clear;
  qry.SQL.Add('update ' + tbInfo.GetTableName);
  qry.SQL.Add(' set '    + CreateFld(tbInfo.pfx, fli_SL_ON)     + ' = ''' + status + '''');
  qry.SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));

  qry.ExecSQL;
  qry.transaction.Commit;
  qry.Free;

  except
  on E: Exception do
    begin
      sl := TStringList.Create;
      sl.Add(E.Message);
      UpdateError(sl);
      sl.Free;
      Raise;
    end
  end;

  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CCLientStatusUpdate
  else
    StoredProcName := 'SCDC_' + CCLientStatusUpdate;
  StoredProc := ThreadCreateStoredProc(Cfg_DB);
  StoredProc.StoredProcName := StoredProcName;
  StoredProc.Connection.StartTransaction;
  with StoredProc do
  begin
    Prepare;
    ExecProc;
    unprepare;
  end;

  StoredProc.Connection.Commit;
  StoredProc.Free;
end;

//----------------------------------------------------------------------------//

function TOperativeThread.ConnectToDatabase(Wrkst: string) : boolean;
var
  qry:        TMqmQuery;
  tbInfo: ^TTblInfo;
  sl : TStringList;
begin
  Result := true;
  tbInfo := @tblInfo[tbl_cfg_exchg_wkst];
  qry := ThreadCreateQuery(Cfg_DB);
  qry.Transaction := ThreadCreateTransaction(Cfg_DB);
  qry.Transaction.StartTransaction;

  with qry do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from ' + tbInfo.GetTableName);
    SQL.Add(' where '  + CreateFld(tbInfo.pfx, fli_wkstCode) + ' = ''' + Wrkst + '''');
    SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
    if IniAppGlobals.DownloadTo = '0' then
      SQL.Add('with rs use and keep update locks')
    else if IniAppGlobals.DownloadTo = '1' then
      SQL.Add('for update');
    Open;

    if qry.Eof then
    begin
      qry.SQL.Clear;
      qry.SQL.Add('insert into ' + tbInfo.GetTableName  + ' (');
      qry.SQL.Add(CreateFld(tbInfo.pfx, fli_IDENTIFIER) + ', ');
      qry.SQL.Add(CreateFld(tbInfo.pfx, fli_wkstCode) + ', ');
      qry.SQL.Add(CreateFld(tbInfo.pfx, fli_CONNECT)  + ', ');
      qry.SQL.Add(CreateFld(tbInfo.pfx, fli_LAST_UPD) + ', ');
      qry.SQL.Add(CreateFld(tbInfo.pfx, fli_OP)   + ', ');
      qry.SQL.Add(CreateFld(tbInfo.pfx, fli_POLL) + ', ');
      qry.SQL.Add(CreateFld(tbInfo.pfx, fli_MachineNumber));
      qry.SQL.Add(') values (');
      qry.SQL.Add(IniAppGlobals.Identifier + ', ');
      qry.SQL.Add('''' + Wrkst + ''', ');

      if (IniAppGlobals.DownloadTo = '2') or (IniAppGlobals.DownloadTo = '1') then
        qry.SQL.Add('CURRENT_TIMESTAMP, ')
      else
        qry.SQL.Add('CURRENT TIMESTAMP, ');

      qry.SQL.Add('0, ');
      qry.SQL.Add(''' '', ');
      qry.SQL.Add('''1'' , ');
      qry.SQL.Add(IntToStr(GetLockCode));
      qry.SQL.Add(')');

      try
      qry.ExecSQL;
      except
      on E: Exception do
        begin
       {   sl := TStringList.Create;
          sl.Add(E.Message);
          UpdateError(sl);
          sl.Free;
          Result := false;
          Raise; }
        end
      end;
    end;
  end;
  qry.Transaction.commit;
  qry.Free;
end;

//----------------------------------------------------------------------------//

function TOperativeThread.DisConnectToDatabase(Wrkst: string) : boolean;
var
  StoredProc: TMqmStoredProc;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CCfgDisconnect
  else
    StoredProcName := 'SCDC_' + CCfgDisconnect;
  StoredProc := ThreadCreateStoredProc(Cfg_DB);
  StoredProc.StoredProcName := StoredProcName;
  StoredProc.Connection.StartTransaction;
  with StoredProc do
  begin
    Prepare;
    ParamByName('WKSTCODE').AsString := Wrkst;
    ParamByName('IDENTIFIER').Value := IniAppGlobals.Identifier;
    ExecProc;
    unprepare
  end;

  StoredProc.Connection.Commit;
  StoredProc.Free;

end;

//----------------------------------------------------------------------------//

procedure TOperativeThread.DISCONNECT(Wrkst: string);
var
  StoredProc: TMqmStoredProc;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CCfgDisconnect
  else
    StoredProcName := 'SCDC_' + CCfgDisconnect;
  StoredProc := ThreadCreateStoredProc(Cfg_DB);
  StoredProc.StoredProcName := StoredProcName;
  StoredProc.Connection.StartTransaction;
  with StoredProc do
  begin
    Prepare;
    ParamByName('WKSTCODE').AsString := Wrkst;
    ExecProc;
    unprepare
  end;

  StoredProc.Connection.Commit;
  StoredProc.Free;
end;

//----------------------------------------------------------------------------//

procedure TOperativeThread.THREAD_ASK_POLL;
var
  StoredProc: TMqmStoredProc;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CCfgAskPoll
  else
    StoredProcName := 'SCDC_' + CCfgAskPoll;
  StoredProc := ThreadCreateStoredProc(Cfg_DB);
  StoredProc.StoredProcName := StoredProcName;
  StoredProc.Connection.StartTransaction;
  with StoredProc do
  begin
    Prepare;
    ExecProc;
    unprepare;
  end;

  StoredProc.Connection.Commit;

  StoredProc.Free;
end;

//----------------------------------------------------------------------------//

procedure TOperativeThread.THREAD_CHECK_POLL;
var
  StoredProc: TMqmStoredProc;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CCfgChkPoll
  else
    StoredProcName := 'SCDC_' + CCfgChkPoll;
  StoredProc := ThreadCreateStoredProc(Cfg_DB);
  StoredProc.StoredProcName := StoredProcName;
  StoredProc.Connection.StartTransaction;
  with StoredProc do
  begin
    Prepare;
    ExecProc;
    unprepare;
  end;

  StoredProc.Connection.Commit;

  StoredProc.Free;
end;

//----------------------------------------------------------------------------//

procedure TOperativeThread.CloseThreadConnection;
begin
  if Assigned(m_MainDB) then
    m_MainDB.Connected := false;
  m_MainDB.Free;
  if Assigned(m_CFGDB) then
    m_CFGDB.Connected := false;
  m_CFGDB.Free;
  if Assigned(m_DBHost) then
    m_DBHost.Connected := false;
  m_DBHost.Free;
  if Assigned(m_DBArc) then
    m_DBArc.Connected := false;
  m_DBArc.Free;
end;

//----------------------------------------------------------------------------//

procedure TOperativeThread.UpdateClient;
var
  StoredProc: TMqmStoredProc;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CSevCngDataBase
  else
    StoredProcName := 'SCDC_' + CSevCngDataBase;

  StoredProc := ThreadCreateStoredProc(Cfg_DB);
  StoredProc.StoredProcName := StoredProcName;
  StoredProc.Connection.StartTransaction;

  with StoredProc do
  begin
    Prepare;
    ExecProc;
    unprepare
  end;

  StoredProc.Connection.Commit;
  StoredProc.Free;

end;

//----------------------------------------------------------------------------//

procedure TOperativeThread.UpdateClient_Include_Warp;
var
  StoredProc: TMqmStoredProc;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CSevCngDataBaseAndWarp
  else
    StoredProcName := 'SCDC_' + CSevCngDataBaseAndWarp;

  StoredProc := ThreadCreateStoredProc(Cfg_DB);
  StoredProc.StoredProcName := StoredProcName;
  StoredProc.Connection.StartTransaction;

  with StoredProc do
  begin
    Prepare;
    ExecProc;
    unprepare
  end;

  StoredProc.Connection.Commit;
  StoredProc.Free;
end;

//----------------------------------------------------------------------------//

procedure TOperativeThread.UpdateClient_Only_Warp;
var
  StoredProc: TMqmStoredProc;
  StoredProcName : string;
begin
  if IniAppGlobals.DownloadTo = '2' then
    StoredProcName := CSevCngDataBaseWarpOnly
  else
    StoredProcName := 'SCDC_' + CSevCngDataBaseWarpOnly;

  StoredProc := ThreadCreateStoredProc(Cfg_DB);
  StoredProc.StoredProcName := StoredProcName;
  StoredProc.Connection.StartTransaction;

  with StoredProc do
  begin
    Prepare;
    ExecProc;
    unprepare
  end;

  StoredProc.Connection.Commit;
  StoredProc.Free;
end;

//----------------------------------------------------------------------------//

procedure TOperativeThread.UpdateLastDwnDateTimeAS400;
var
  tbInfo:         ^TTblInfo;
  tblName:        string;
  SrvQry : TMqmQuery;
  HostQry : TMqmQuery;
  DndArchiveName : TDndArchiveName;
begin
  tbInfo := @tblInfo[tbl_download_time];
  SrvQry := ThreadCreateQuery(Main_DB);

  DndArchiveName := GetDndArchiveHostName;
  if (DndArchiveName = TD_AS_400) then
    HostQry := ThreadCreateQueryHost
  else
    HostQry := ThreadCreateQueryArc;

  tbInfo.ASname := 'MQMCN00f';
  tblName  := 'MQMCN00f';

  with HostQry do
  begin
    UpdateOperation(_('Reading Time from host . . .'));
    SQL.Clear;
    SQL.Add('select * from ' + tblName);
    Open;
  end;

  with SrvQry do
  begin
    UpdateOperation(_('Clearing') + ' ' + tbInfo.GetTableName);
    SQL.Clear;
    SQL.Add('delete from ' + tbInfo.GetTableName);
    ExecSQL;
    Close;

    UpdateOperation(_('Loading') + ' ' + tbInfo.GetTableName);
    SQL.Clear;
    SQL.Add('insert into ' + tbInfo.GetTableName + '(');
    SQL.Add(CreateFld(tbInfo.pfx, fli_downloadTime));
    SQL.Add(') values (');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_downloadTime));
    SQL.Add(')');
   // Prepare;

    if not HostQry.EOF then
    begin
      if (GetDateTimeFormat = Frm_As400) then
        ParamByName(CreateFld(tbInfo.pfx, fli_downloadTime)).AsDateTime := TimDateTimeToDateTime(HostQry.FieldByName('KSRSTR').AsFloat)
      else if (GetDateTimeFormat = Frm_TDateTimeExceptControl) or (GetDateTimeFormat = Frm_TDateTime)
               or (GetDateTimeFormat = Frm_DB2) then
        ParamByName(CreateFld(tbInfo.pfx, fli_downloadTime)).AsDateTime := Now;//HostQry.FieldByName('KSREND').AsDateTime;

      SrvQry.ExecSQL;
      SrvQry.Connection.Commit;

    end;
    Srvqry.Close;
    Srvqry.free;
//    srvTrs.Free;
    HostQry.free
  end;

end;

// ----------------------------------------------------------------------------

procedure TOperativeThread.CT_CLEAR_CONTROL_AFTER_DWNLD_AS400;
var
  Q : TMqmQuery;
  T : TDateTime;
  DateTimeFormat : TDateTimeFormat;
  GeneralSQL : String;
  year, month, day, hour, min, sec, msec: Word;
  TempDate, M, S : string;
  DndArchiveHostName : TDndArchiveName;
begin
  DndArchiveHostName := GetDndArchiveHostName;
  if (DndArchiveHostName = TD_AS_400) then
    Q := ThreadCreateQueryHost
  else
    Exit;

  DateTimeFormat := GetDateTimeFormat;

  with Q.sql do
  begin
    Clear;
    if (DateTimeFormat = Frm_As400) then
    begin
      T := DateTimeToTimDateTime(now);
      GeneralSQL := '';
      GeneralSQL := ' UPDATE MQMCN00F';
      GeneralSQL := GeneralSQL + ' SET KCLOPR ' + '=''' + '1' + '''';
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KCLSTT ' + '=''' + '0' + '''';
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KCLEND = ' + FloatToStr(T);
      Add(GeneralSQL);
    end
    else if (DateTimeFormat = Frm_TDateTimeExceptControl) then
    begin
      T := now;
      GeneralSQL := '';
      GeneralSQL := ' UPDATE MQMCN00F';
      GeneralSQL := GeneralSQL + ' SET KCLOPR ' + '=''' + '1' + '''';
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KCLSTT ' + '=''' + '0' + '''';
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KCLEND = ' + FloatToStr(T);
      Add(GeneralSQL);
    end
    else if (DateTimeFormat = Frm_TDateTime) then
    begin
      T := now;
      TempDate := DateTimeToStr(T);
      DecodeDate(T, year, month, day);
      DecodeTime(T, hour, min, sec, msec);
      TempDate := '';
      TempDate := IntToStr(month) + '/' + IntToStr(Day) + '/' + IntToStr(Year) + ' ' +
                      IntToStr(hour) + ':' + IntToStr(min) + ':' + IntToStr(Sec);
      GeneralSQL := '';
      GeneralSQL := ' UPDATE MQMCN00F';
      GeneralSQL := GeneralSQL + ' SET KCLOPR ' + '=''' + '1' + '''';
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KCLSTT ' + '=''' + '0' + '''';
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KCLEND = ' + QuotedStr(TempDate);
      Add(GeneralSQL);
    end

    else if (DateTimeFormat = Frm_DB2) then
    begin
      T := now;
      TempDate := DateTimeToStr(T);
      DecodeDate(T, year, month, day);
      DecodeTime(T, hour, min, sec, msec);
      if min < 10 then
        M := '0' + IntToStr(min)
      else
        M := IntToStr(min);

      if Sec < 10 then
        S := '0' + IntToStr(Sec)
      else
        S := IntToStr(Sec);

      TempDate := '';
      TempDate := IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(day) + ' ' +
                  IntToStr(hour) + ':' + M + ':' + S;
      GeneralSQL := '';

      GeneralSQL := '';
      GeneralSQL := ' UPDATE MQMCN00F';
      GeneralSQL := GeneralSQL + ' SET KCLOPR ' + '=''' + '1' + '''';
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KCLSTT ' + '=''' + '0' + '''';
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KCLEND = ' + QuotedStr(TempDate);
      Add(GeneralSQL);
    end;

    Q.ExecSQL;
    Q.Close;
    Q.Connection.commit;

    if (DateTimeFormat = Frm_TDateTime) then
      UpdateLastDwnDateTimeAS400;

  end;
  Q.free;
end;

//----------------------------------------------------------------------------//

function TOperativeThread.CT_GET_ACCESS_HOST_AS400 : boolean;
var
  Q : TMqmQuery;
  T : TDateTime;
  DateTimeFormat : TDateTimeFormat;
  GeneralSQL : String;
  year, month, day, hour, min, sec, msec: Word;
  TempDate : string;
  M,S, TableName : string;
  DndArchiveHostName : TDndArchiveName;
begin
  Result := true;
  DndArchiveHostName := GetDndArchiveHostName;

//  if IniAppGlobals.DownloadTo = '2' then
  TableName := 'MQMCN00F';
//  else
//    TableName := 'SCDA_MQMCN00F';

  if (DndArchiveHostName = TD_AS_400) then
    Q := ThreadCreateQueryHost
  else
    Q := ThreadCreateQueryArc;
  DateTimeFormat := GetDateTimeFormat;
  try
    while true do
    begin
      with Q.sql do
      begin
        Clear;
        if (DateTimeFormat = Frm_As400) then
        begin
          T := DateTimeToTimDateTime(now);
          GeneralSQL := '';
          GeneralSQL := ' UPDATE ' + TableName;
          GeneralSQL := GeneralSQL + ' SET KCLSTT ' + '=''' + '1' + '''';
          GeneralSQL := GeneralSQL + ', ';
          GeneralSQL := GeneralSQL + 'KCLSTR = ' + FloatToStr(T);
          GeneralSQL := GeneralSQL + ', ';
          GeneralSQL := GeneralSQL + 'KCLEND = 0';
          GeneralSQL := GeneralSQL + ', ';
          GeneralSQL := GeneralSQL + 'KCLOPR ' + '=''' + '0' + '''';
          GeneralSQL := GeneralSQL + ', ';
          GeneralSQL := GeneralSQL + 'KSRUPD ' + '=''' + '0' + '''';
          GeneralSQL := GeneralSQL + ' where KSRSTT ' + '<>''' + '1' + '''';
          Q.sql.Add(GeneralSQL);
        end

        else if (IniAppGlobals.DownloadTo = '0') then
        begin
          T := now;
          TempDate := DateTimeToStr(T);
          DecodeDate(T, year, month, day);
          DecodeTime(T, hour, min, sec, msec);
          if min < 10 then
            M := '0' + IntToStr(min)
          else
            M := IntToStr(min);

          if Sec < 10 then
            S := '0' + IntToStr(Sec)
          else
            S := IntToStr(Sec);

          TempDate := '';
          TempDate := IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(day) + ' ' +
                      IntToStr(hour) + ':' + M + ':' + S;
          GeneralSQL := '';
          GeneralSQL := ' UPDATE ' + TableName;
          GeneralSQL := GeneralSQL + ' SET KCLSTT ' + '=''' + '1' + '''';
          GeneralSQL := GeneralSQL + ', ';
          GeneralSQL := GeneralSQL + 'KCLSTR = ' + QuotedStr(TempDate);
          GeneralSQL := GeneralSQL + ', ';
          GeneralSQL := GeneralSQL + 'KCLEND = ' + QuotedStr('1899-12-12 00:00:00');
          GeneralSQL := GeneralSQL + ', ';
          GeneralSQL := GeneralSQL + 'KCLOPR ' + '=''' + '0' + '''';
          GeneralSQL := GeneralSQL + ', ';
          GeneralSQL := GeneralSQL + 'KSRUPD ' + '=''' + '0' + '''';
          GeneralSQL := GeneralSQL + ' where KSRSTT ' + '<>''' + '1' + '''';
          Q.sql.Add(GeneralSQL);
        end



        else if (DateTimeFormat = Frm_TDateTimeExceptControl) then
        begin
          T := now;
          GeneralSQL := '';
          GeneralSQL := ' UPDATE ' + TableName;
          GeneralSQL := GeneralSQL + ' SET KCLSTT ' + '=''' + '1' + '''';
          GeneralSQL := GeneralSQL + ', ';
          GeneralSQL := GeneralSQL + 'KCLSTR = ' + FloatToStr(T);
          GeneralSQL := GeneralSQL + ', ';
          GeneralSQL := GeneralSQL + 'KCLEND = 0';
          GeneralSQL := GeneralSQL + ', ';
          GeneralSQL := GeneralSQL + 'KCLOPR ' + '=''' + '0' + '''';
          GeneralSQL := GeneralSQL + ', ';
          GeneralSQL := GeneralSQL + 'KSRUPD ' + '=''' + '0' + '''';
          GeneralSQL := GeneralSQL + ' where KSRSTT ' + '<>''' + '1' + '''';
          Q.sql.Add(GeneralSQL);
        end
        else if (DateTimeFormat = Frm_TDateTime) then
        begin
          T := now;
          TempDate := DateTimeToStr(T);
          DecodeDate(T, year, month, day);
          DecodeTime(T, hour, min, sec, msec);
          TempDate := '';
          TempDate := IntToStr(month) + '/' + IntToStr(Day) + '/' + IntToStr(Year) + ' ' +
                      IntToStr(hour) + ':' + IntToStr(min) + ':' + IntToStr(Sec);
          GeneralSQL := '';
          GeneralSQL := ' UPDATE ' + TableName;
          GeneralSQL := GeneralSQL + ' SET KCLSTT ' + '=''' + '1' + '''';
          GeneralSQL := GeneralSQL + ', ';
          GeneralSQL := GeneralSQL + 'KCLSTR = ' + QuotedStr(TempDate);
          GeneralSQL := GeneralSQL + ', ';
          GeneralSQL := GeneralSQL + 'KCLEND = ' + QuotedStr('12/12/1899');
          GeneralSQL := GeneralSQL + ', ';
          GeneralSQL := GeneralSQL + 'KCLOPR ' + '=''' + '0' + '''';
          GeneralSQL := GeneralSQL + ', ';
          GeneralSQL := GeneralSQL + 'KSRUPD ' + '=''' + '0' + '''';
          GeneralSQL := GeneralSQL + ' where KSRSTT ' + '<>''' + '1' + '''';
          Q.sql.Add(GeneralSQL);
        end

        else if (DateTimeFormat = Frm_DB2) then
        begin
          T := now;
          TempDate := DateTimeToStr(T);
          DecodeDate(T, year, month, day);
          DecodeTime(T, hour, min, sec, msec);
          if min < 10 then
            M := '0' + IntToStr(min)
          else
            M := IntToStr(min);

          if Sec < 10 then
            S := '0' + IntToStr(Sec)
          else
            S := IntToStr(Sec);

          TempDate := '';
          TempDate := IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(day) + ' ' +
                      IntToStr(hour) + ':' + M + ':' + S;
          GeneralSQL := '';
          GeneralSQL := ' UPDATE ' + TableName;
          GeneralSQL := GeneralSQL + ' SET KCLSTT ' + '=''' + '1' + '''';
          GeneralSQL := GeneralSQL + ', ';
          GeneralSQL := GeneralSQL + 'KCLSTR = ' + QuotedStr(TempDate);
          GeneralSQL := GeneralSQL + ', ';
          GeneralSQL := GeneralSQL + 'KCLEND = ' + QuotedStr('1899-12-12 00:00:00');
          GeneralSQL := GeneralSQL + ', ';
          GeneralSQL := GeneralSQL + 'KCLOPR ' + '=''' + '0' + '''';
          GeneralSQL := GeneralSQL + ', ';
          GeneralSQL := GeneralSQL + 'KSRUPD ' + '=''' + '0' + '''';
          GeneralSQL := GeneralSQL + ' where KSRSTT ' + '<>''' + '1' + '''';
          Q.sql.Add(GeneralSQL);
        end;

        Q.ExecSQL;
        Q.Connection.commit;
        Q.Close;

        Clear;
        Add(' Select * from ' + TableName + ' Where KCLSTT ' + '=''' + '1' + '''');
   //     Add(' Where KCLSTT ' + '=''' + '1' + '''');
        Q.Open;
        if Q.EOF then
        begin
          UpdateOperation(_(' Waiting for host . . .'));
          FSrvLoad.IExit.Enabled := true;
          Sleep(10000);
        end
        else
        begin
          Clear;
          FSrvLoad.IExit.Enabled := false;
          Break;
        end;
      end;
    end;

    except
      on E: EFDDBEngineException do
      begin
         Q.connection.Rollback;
         FSrvLoad.MmErrors.Lines.Add(' ExecSQL xxx CT_CLEAR_PROCCESS_HOST xxx ' + TableName + ' xxx ');
         FSrvLoad.MmErrors.Lines.Add(Q.sql.Text);
         FSrvLoad.IExit.Enabled  := true;
         FSrvLoad.PGCmain.TabIndex := 1;
         raise EFDDBEngineException.CreateFmt('ExecSQL xxx ' + TableName + ' xxx CT_CLEAR_PROCCESS_HOST' , [E.Message]);
      end;
    end;

//  end;

  Q.Free;
end;

//----------------------------------------------------------------------------//

function TOperativeThread.CT_END_UPLOAD : boolean;
var
  Q : TMqmQuery;
  T : TDateTime;
  DateTimeFormat : TDateTimeFormat;
  GeneralSQL : String;
  year, month, day, hour, min, sec, msec: Word;
  TempDate, M, S : string;
  TableName : string;
  DndArchiveName : TDndArchiveName;
begin
  Result := true;
  DateTimeFormat := GetDateTimeFormat;

  DndArchiveName := GetDndArchiveHostName;
  if (DndArchiveName = TD_AS_400) then
    Q := ThreadCreateQueryHost
  else
    Q := ThreadCreateQueryArc;

  if IniAppGlobals.DownloadTo = '2' then
    TableName := 'MQMCN00F'
  else
    TableName := 'SCDA_MQMCN00F';

  with Q.sql do
  begin
    Clear;
    if (DateTimeFormat = Frm_As400) then
    begin
      T := DateTimeToTimDateTime(now);
      GeneralSQL := '';
      GeneralSQL := ' UPDATE MQMCN00F';
      GeneralSQL := GeneralSQL + ' SET KCLOPR ' + '=''' + '2' + '''';
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KCLSTT ' + '=''' + '0' + '''';
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KCLEND = ' + FloatToStr(T);
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KSRUPD ' + '=''' + '1' + '''';
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KCLUPL ' + '=''' + '1' + '''';
      Add(GeneralSQL);
    end
    else if (DateTimeFormat = Frm_TDateTimeExceptControl) then
    begin
      T := now;
      GeneralSQL := '';
      GeneralSQL := ' UPDATE MQMCN00F';
      GeneralSQL := GeneralSQL + ' SET KCLOPR ' + '=''' + '2' + '''';
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KCLSTT ' + '=''' + '0' + '''';
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KCLEND = ' + FloatToStr(T);
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KSRUPD ' + '=''' + '1' + '''';
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KCLUPL ' + '=''' + '1' + '''';
      Add(GeneralSQL);
    end
    else if (DateTimeFormat = Frm_TDateTime) then
    begin
      T := now;
      TempDate := DateTimeToStr(T);
      DecodeDate(T, year, month, day);
      DecodeTime(T, hour, min, sec, msec);
      TempDate := ConvertDateFormatDb2Oracle(T, true, true);
      GeneralSQL := '';
      GeneralSQL := ' UPDATE ' + TableName;
      GeneralSQL := GeneralSQL + ' SET KCLOPR ' + '=''' + '2' + '''';
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KCLSTT ' + '=''' + '0' + '''';
      GeneralSQL := GeneralSQL + ', ';

      if IniAppGlobals.DownloadTo = '0' then
        GeneralSQL := GeneralSQL + 'KCLEND = ' + TempDate
      else if IniAppGlobals.DownloadTo = '1' then
        GeneralSQL := GeneralSQL + 'KCLEND = ' + QuotedStr(TempDate)
      else if IniAppGlobals.DownloadTo = '2' then
      begin
        GeneralSQL := GeneralSQL + 'KCLEND = ' + QuotedStr(TempDate);
      end;

      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KSRUPD ' + '=''' + '1' + '''';
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KCLUPL ' + '=''' + '1' + '''';
      Add(GeneralSQL);
    end

    else if (DateTimeFormat = Frm_DB2) then
    begin
      T := now;
      DecodeDate(T, year, month, day);
      DecodeTime(T, hour, min, sec, msec);
      if min < 10 then
        M := '0' + IntToStr(min)
      else
        M := IntToStr(min);

      if Sec < 10 then
        S := '0' + IntToStr(Sec)
      else
        S := IntToStr(Sec);

      TempDate := '';
      TempDate := IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(day) + ' ' +
                  IntToStr(hour) + ':' + M + ':' + S;
      GeneralSQL := '';
      GeneralSQL := ' UPDATE SCDA_MQMCN00F';
      GeneralSQL := GeneralSQL + ' SET KCLOPR ' + '=''' + '2' + '''';
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KCLSTT ' + '=''' + '0' + '''';
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KCLEND = ' + TempDate;
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KSRUPD ' + '=''' + '1' + '''';
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KCLUPL ' + '=''' + '1' + '''';
      Add(GeneralSQL);
    end;

    Q.ExecSQL;
    Q.Connection.commit;
    Q.Close;
  end;
  Q.free;

end;

// ----------------------------------------------------------------------------

function TOperativeThread.CT_CLEAR_PROCCESS_HOST : boolean;
var
  Q : TMqmQuery;
  GeneralSQL : string;
  DndArchiveHostName : TDndArchiveName;
  TableName : string;
begin
  Result := true;
//  if IniAppGlobals.DownloadTo = '2' then
  TableName := 'MQMCN00F';
//  else
//  TableName := 'SCDA_MQMCN00F';
  DndArchiveHostName := GetDndArchiveHostName;
  if (DndArchiveHostName = TD_AS_400) then
    Q := ThreadCreateQueryHost
  else
    Q := ThreadCreateQueryArc;

  with Q.sql do
  begin
    Clear;
    GeneralSQL := ' UPDATE ' + TableName;
    GeneralSQL := GeneralSQL + ' SET KCLSTT ' + '=''' + '0' + '''';
    GeneralSQL := GeneralSQL + ', ';
    GeneralSQL := GeneralSQL + 'KSRSTT ' + '=''' + '0' + '''';
    Add(GeneralSQL);
    try
      Q.ExecSQL;
      Q.Connection.commit;
    except
      on E: EFDDBEngineException do
      begin
         Q.connection.Rollback;
         FSrvLoad.MmErrors.Lines.Add(' ExecSQL xxx CT_CLEAR_PROCCESS_HOST xxx ' + TableName + ' xxx ');
         FSrvLoad.MmErrors.Lines.Add(Q.sql.Text);
         FSrvLoad.IExit.Enabled  := true;
         FSrvLoad.PGCmain.TabIndex := 1;
         raise
        // raise EFDDBEngineException.CreateFmt('ExecSQL xxx ' + TableName + ' xxx CT_CLEAR_PROCCESS_HOST' , [E.Message]);
      end;
    end;

  end;
  Q.Close;
  Q.free;
end;

//----------------------------------------------------------------------------

procedure TOperativeThread.CT_END_ACCESS(Wrkst: string);
var
  StoredProc: TMqmStoredProc;
begin
  StoredProc := ThreadCreateStoredProc(Cfg_DB);
  StoredProc.StoredProcName := CCfgEndAccess;
  StoredProc.Connection.StartTransaction;

  Application.ProcessMessages;

  try
    with StoredProc do
    begin
      Prepare;
      ParamByName('WKSTCODE').AsString := Wrkst;
      ExecProc;
      unprepare
    end
  except
  end;

  Application.ProcessMessages;

  StoredProc.Connection.Commit;

  StoredProc.Free;
end;

//----------------------------------------------------------------------------

constructor TOperativeThread.CreateOperative(itfHdl: THandle);
begin
  inherited Create(true);
  FreeOnTerminate := true;
  m_itfHdl   := itfHdl;
  m_running  := false;
  m_loadMode :=  TDOL_auto;
  m_saveMode :=  TDOS_auto;

  m_lastLoad      := 0;
  m_lastSave      := Now;

  m_MainDB := TMqmDatabase.Create(nil);
  m_CFGDB  := TMqmDatabase.Create(nil);
  m_DBHost := TMqmDatabase.Create(nil);
  m_DBArc  := TMqmDatabase.Create(nil);
end;

//----------------------------------------------------------------------------//

destructor TOperativeThread.destroy;
begin
  if not m_SignServer then
  begin
    SetRunStatus('0');
    DISCONNECT('SERVER');
    m_SignServer := true;
  end;
  CloseThreadConnection;
  inherited Destroy;
  s_OpThread := nil;
end;

//----------------------------------------------------------------------------//

function TOperativeThread.DownloadFromHost(var DataChange : boolean ; Handl : THandle; var GotAccessToInsertData : boolean):boolean;
begin
  m_op := OPI_FromHost;
  PostMessage(m_itfHdl, CM_UPDATE, m_op, StrToInt(IniAppGlobals.Identifier));
  Result := LoadFromHost(DataChange, Handl, GotAccessToInsertData);
end;

//----------------------------------------------------------------------------//

function TOperativeThread.OperateDownload(var DataChange : boolean; var EndWell : boolean; Handl : THandle): boolean;
var
  GotAccessInsertData : boolean;
begin
//  Result := true;
//  try
    DownloadFromHost(DataChange, m_itfHdl, GotAccessInsertData);
{    except
    on E: Exception do
      begin
       // UpdateOperation(_('Download not Completed'));
        e_Exception := E;
        TerminatedProgram;
        Result := false;
        EndWell := false;
        CT_CLEAR_CONTROL_AFTER_DWNLD;

        raise;
      end;
  end; }
end;

//----------------------------------------------------------------------------//

procedure TOperativeThread.DownloadPsFromAS;
begin
  m_op := OPI_FromHost;
  PostMessage(m_itfHdl, CM_UPDATE, m_op, StrToInt(IniAppGlobals.Identifier));
//  LoadPsFromHost
end;

//----------------------------------------------------------------------------//

procedure TOperativeThread.DownloadFromPc;
begin
  m_op := OPI_FromHost;
  PostMessage(m_itfHdl, CM_UPDATE, m_op, StrToInt(IniAppGlobals.Identifier));
  UpdateOperation(_('Download progressed'));
//  LoadFilesFromPc;
  m_op       := OPI_idle;
  PostMessage(m_itfHdl, CM_UPDATE, m_op, StrToInt(IniAppGlobals.Identifier));
  UpdateOperation('');
end;

//----------------------------------------------------------------------------//

procedure TOperativeThread.SendScheduledToHOST;
begin
  m_op := OPI_ToHost;
  PostMessage(m_itfHdl, CM_UPDATE, m_op, StrToInt(IniAppGlobals.Identifier));
  SendSchedToHOST;
end;

//----------------------------------------------------------------------------//

function TOperativeThread.SendWarpSchedTo_NOW_HOST: boolean;
begin
  m_op := OPI_ToHost;
  PostMessage(m_itfHdl, CM_UPDATE, m_op, StrToInt(IniAppGlobals.Identifier));
  Result := SendWarpSchedToNOW;
end;

//----------------------------------------------------------------------------//

function TOperativeThread.SendScheduledTo_NOW_HOST(var Is_SCHEDULESUPLOAD_emptyMQM : boolean; var Is_SCHEDULESUPLOAD_emptyMCM : boolean; var MQM_OR_MCM_ENVIRONMENT : string) : boolean;
begin
  m_op := OPI_ToHost;
  PostMessage(m_itfHdl, CM_UPDATE, m_op, StrToInt(IniAppGlobals.Identifier));
  Result := SendSchedToNOW(Is_SCHEDULESUPLOAD_emptyMQM,Is_SCHEDULESUPLOAD_emptyMCM,MQM_OR_MCM_ENVIRONMENT);
end;

//----------------------------------------------------------------------------//

procedure TOperativeThread.SendArcToHOST;
begin
  m_op := OPI_ToHost;
  PostMessage(m_itfHdl, CM_UPDATE, m_op, StrToInt(IniAppGlobals.Identifier));
  SendArchiveToHOST;
  m_op := OPI_idle;
  PostMessage(m_itfHdl, CM_UPDATE, m_op, StrToInt(IniAppGlobals.Identifier));
end;

//----------------------------------------------------------------------------//

procedure TOperativeThread.SendToPc;
begin
  m_op := OPI_ToHost;
  PostMessage(m_itfHdl, CM_UPDATE, m_op, StrToInt(IniAppGlobals.Identifier));
//  SendFilesToPc;
end;

//----------------------------------------------------------------------------//

procedure TOperativeThread.TerminatedProgram;
begin
  Assert(s_OpThread.m_running = true);
  s_OpThread.m_running := false;

  UpdateOperation(_('Download not Completed'));
  s_OpThread.m_lastLoad := 0;
  if not s_OpThread.m_SignServer then
  begin
    SetRunStatus('0');
    DISCONNECT('SERVER');
    s_OpThread.m_SignServer := true;
  end;
  ProgramTerminated;
  s_OpThread.Terminate;
end;

//----------------------------------------------------------------------------//

procedure Delay(dwMilliseconds: Longint);
var
  iStart, iStop: DWORD;
begin
  iStart := GetTickCount;
  repeat
   iStop := GetTickCount;
   Application.ProcessMessages;
   Sleep(1);
  until (iStop - iStart) >= dwMilliseconds;
end;

//----------------------------------------------------------------------------//

function TOperativeThread.CheckServerDoubleInstance: boolean;
begin
  result := UMStoredProc.CheckServerDoubleInstance
end;

//----------------------------------------------------------------------------//
procedure TOperativeThread.ClearStatuseOp;
begin
  UpdateOperation('');
  m_op := OPI_STOP;
  PostMessage(m_itfHdl, CM_UPDATE, m_op, StrToInt(IniAppGlobals.Identifier));
end;

//----------------------------------------------------------------------------//

function TOperativeThread.CheckEndingTimeLoop : boolean;
var
  TimeEndLoop : TTime;
begin
  TimeEndLoop := StrToTime(IniAppGlobals.TimePickerEndLoop);
  if frac(Now) > TimeEndLoop then
    Result := true
  else
    Result := false;
end;

//----------------------------------------------------------------------------//

procedure TOperativeThread.Execute;
var
  I,J : Integer;
  FirstLoop, DataChange, EndWell : boolean;
  ErrorStr: string;
  sl : TStringList;
  OperateDwnload : boolean;
  TypMode : TDTypeMode;
  Temp : TDateTime;
  DataPreparationExist : boolean;
  Is_SCHEDULESUPLOAD_emptyMQM, Is_SCHEDULESUPLOAD_emptyMCM : boolean;
  MQM_OR_MCM_ENVIRONMENT : string;
  UploadTimeTry : TDateTime;
  DndArchiveHostName : TDndArchiveName;
  ThreadConnectionIsGood : boolean;
begin

{  if not FSrvLoad.fConnected then
  begin
    Terminate;
    Exit;
  end;   }

  FSrvLoad.Timer1.Enabled := False;
  FSrvLoad.m_OperationStarted := true;

  e_Exception := nil;
  DndArchiveHostName := GetDndArchiveHostName;
  OnTerminate := ThreadDone;
  OperateDwnload := true;
  FirstLoop := true;
  DataPreparationExist := false;
  Is_SCHEDULESUPLOAD_emptyMQM := false;
  Is_SCHEDULESUPLOAD_emptyMCM := false;
  try
  EndWell    := true;
  DataChange := false;
  m_lastLoad := 0;
  m_SignServer := true;
//  TypMode := TD_AllFiles;

  for I := 1 to ParamCount do
  begin
    if (ParamStr(I) = 'LoadChgReq') or (ParamStr(I) = 'MQM_Download_Production_By_Changed_LisT') or (ParamStr(I) = 'MQM_Download_Production_By_Changed_List_And_Upload') then
    begin
      SetLoopMqmCG(true);
      SetTypeMode(TD_OnlyProd);
      Break;
    end

    else if (ParamStr(I) = 'LoadAllReq') or (ParamStr(I) = 'MQM_Download_Production') then
    begin
      SetLoopMqmCG(false);
      SetTypeMode(TD_OnlyProd);
      Break;
    end

    else if (ParamStr(I) = 'MQM_Download_All_And_Upload') then
    begin
      SetLoopMqmCG(false);
      SetTypeMode(TD_AllFiles);
      Break;
    end

    else if (ParamStr(I) = 'MQM_Download_All_By_Changed_List_And_Upload') then
    begin
      SetLoopMqmCG(true);
      SetTypeMode(TD_AllFiles);
      Break;
    end
    else if (ParamStr(I) = 'LoadOnlyArc') or (ParamStr(I) = 'LoadArcOnly') or (ParamStr(I) = 'MQM_Download_Archives') then
    begin
      SetTypeMode(TD_OnlyArchivs);
      Break;
    end;
  end;

  // while running srvload from windows schedule with option 'CNGREQ' (only changed Request)
  if (ParamCount = 0) and GetSchedChgReqFlag and (m_loadMode <> TDOL_auto) and (GetTypeMode <> TD_OnlyArchivs) then
  begin
    SetLoopMqmCG(true);
    SetTypeMode(GetTypeChg);
  end;
{  else
  if (ParamCount = 0) and GetTypeChgFlag and (m_loadMode <> TDOL_auto) and (GetTypeMode <> TD_OnlyArchivs) then
  begin
    SetLoopMqmCG(false);
    SetTypeMode(GetTypeChg);
  end; }

//  if GetLoopMqmCG and (not GetSchedChgReqFlag) and (m_loadMode <> TDOL_auto) then
//    FirstCycle := false;

  CoInitialize(nil);

  while true do
  begin
{$ifndef Demo}
    if Terminated then break;

    if m_SignServer then
    begin
      ThreadConnectionIsGood := openThreadConnection;
      if not ThreadConnectionIsGood then break;
      SetThreadRunStatus('1');
      Sleep(1000);
      if (GetTypeMode = TD_DownLoadAfterUpload) or (GetTypeMode = TD_OnlyUpload) then
         WriteToLog(_('Uploading') , '', false)
      else if (GetTypeMode = TD_DownloadUploadToNow) or (GetTypeMode = TD_OnlyProd) then
         WriteToLog(_('Downloading') , '', false)
      else
         WriteToLog(_('Downloading') , '', false);

//      CHECK_STATION_EXIST_AND_INSERT('SERVER');
      UPDATE_ACCESS_OPERATION('SERVER', AT_Blank, Now);
      //if GET_SRVLOAD_COUNTER_NUMBER <> IniAppGlobals.MyPollingNumber then
      if CheckServerDoubleInstance then
      begin
        ShowMessage('MqmSrvLoad is running on another Folder/Machine with same Identifier = ' + IniAppGlobals.Identifier +
                    #13#10  + ' Application will be terminated');
        FSrvLoad.m_ByParm := true;
        s_OpThread.Terminate;
        s_OpThread := nil;
        FSrvLoad.IExit.Enabled := true;
        m_op := OPI_Exit;
        PostMessage(m_itfHdl, CM_UPDATE, m_op, StrToInt(IniAppGlobals.Identifier));
        Exit;
      end;
      //ConnectToDatabase('SERVER');
      m_SignServer := false;
    end;

    if Terminated then break;

{    //---------------- Manual PS load ---------------------//
    if m_LoadPSMode = TDOL_manual then
    begin
      UpdateOperation(_('Connecting to host ...'));
      if (DndArchiveHostName = TD_AS_400) and (not CT_START_DNLOAD_SCHEDULED(ErrorStr)) then
      begin
        sl := TStringList.Create;
        sl.Add('* ' + ErrorStr);
        UpdateError(sl);
        sl.Free;
        EndOperation(false);
      end;

      if Terminated then break;

      if not GET_ACCESS('SERVER', AT_write, Temp) then
        EndOperation(false);

      if Terminated then break;

      DownloadPsFromAS;

      if (DndArchiveHostName = TD_AS_400) and CT_END_DNLOAD_SCHEDULED then
         UpdateOperation(_('Scheduled jobs download completed'));

      m_op       := OPI_idle;
      PostMessage(m_itfHdl, CM_UPDATE, 0, m_op);
      END_ACCESS('SERVER',Temp);
    end;    }

    if Terminated then break;

    //---------------- Wait for the LoopTime ---------------------//
    if (m_loadMode = TDOL_auto) and (m_lastLoad <> 0) then
    begin
      if ((Now - m_lastLoad) > (GetLoopTime)) then
      begin
        if CheckEndingTimeLoop then
           EndOperation(true);
      end;

      if not ((Now - m_lastLoad) > (GetLoopTime)) then
      begin
        if FirstLoop then
        begin
          UpdateStatuseBtn(false, true);
          Sleep(1000);
          FirstLoop := false;
        end;
        UpdateWaitingTime((GetLoopTime) - (Now - m_lastLoad));
        Sleep(1000);
        continue;
      end
      else
      begin
        FirstLoop := true;
        UpdateStatuseBtn(false, true);
      end;
    end
    else if (m_loadMode = TDOL_auto) and (m_lastLoad = 0) then
      FirstLoop := true;

    if Terminated then break;

    FSrvLoad.MmErrors.Lines.Clear;

 //   {$ifdef DEVMQMCM}

 //   {$else}
 //     THREAD_ASK_POLL;
 //   {$endif}

 //   Sleep(5000);
 //   THREAD_CHECK_POLL;

    //---------------- Load data ---------------------//
    if m_LoadPSMode <> TDOL_manual then
    begin
      UpdateOperation(_('Connecting to host ...'));
      TypMode := GetTypeMode;
      if (ParamStr(I) = 'UPLOAD') or (ParamStr(I) = 'MQM_Upload') or (TypMode = TD_OnlyUpload) then
      begin
        OperateDwnload := false;
      end
      else if (TypMode = TD_OnlyArchivs) then
      begin
    //    if not IsArcDbConnected then
        if (DndArchiveHostName = TD_AS_400) then
          CT_CLEAR_PROCCESS_HOST
        else
          DataPreparationExist := CheckDataPreparationExist;
      end;

      if (DndArchiveHostName = TD_AS_400) and not CT_GET_ACCESS_HOST_AS400 then
      begin
        {sl := TStringList.Create;
        sl.Add('+' + ErrorStr);
        UpdateError(sl);
        sl.Free; }
        EndOperation(false);
      end;

      if Terminated then break;

      if TypMode = TD_DownLoadAfterUpload then
         OperateDwnload := false;

      if OperateDwnload then
      begin
        OperateDownload(DataChange, EndWell, m_itfHdl);
      end;
      if Terminated then break;

      m_op       := OPI_idle;
      PostMessage(m_itfHdl, CM_UPDATE, m_op, StrToInt(IniAppGlobals.Identifier));
      if (DndArchiveHostName = TD_AS_400) and (m_saveMode = TDOS_none) then
        CT_CLEAR_CONTROL_AFTER_DWNLD_AS400;

    end;

    if Terminated then break;

    //---------------- Send PS ---------------------//
    if m_saveMode <> TDOS_none then
    begin

      if (DndArchiveHostName = TD_AS_400) and CheckArcToSend then
        SendArcToHOST;

      if CheckPsInPc or Check_MCM_SCHED or CheckWarpIn_HOST then
      begin

        if GetTypeMode = TD_DownloadUploadToNow then
           WriteToLog(_('Uploading') , '', false);

        CT_START_UPLOAD;

        if IniAppGlobals.PreparationExeName <> '' then
        begin
       //   try

          MQM_OR_MCM_ENVIRONMENT := '';
          if SendScheduledTo_NOW_HOST(Is_SCHEDULESUPLOAD_emptyMQM, Is_SCHEDULESUPLOAD_emptyMCM, MQM_OR_MCM_ENVIRONMENT) then
          begin
            UploadTimeTry := now;

            if Is_SCHEDULESUPLOAD_emptyMQM or Is_SCHEDULESUPLOAD_emptyMCM then
            begin
              UpdateOperation(_('Waiting for now to process the previous data') + ' : ' + MQM_OR_MCM_ENVIRONMENT);
              while True do
              begin
                if ((Now - UploadTimeTry) > (1 / 24 / 60 * 2.5)) then
                   break;
                Sleep(1000);
              end;

              if SendScheduledTo_NOW_HOST(Is_SCHEDULESUPLOAD_emptyMQM, Is_SCHEDULESUPLOAD_emptyMCM, MQM_OR_MCM_ENVIRONMENT) then
              begin
                if Is_SCHEDULESUPLOAD_emptyMQM or Is_SCHEDULESUPLOAD_emptyMCM then
                begin
                //  m_HostMsg := true;
                  FSrvLoad.MmErrors.Lines.Add(MQM_OR_MCM_ENVIRONMENT + ' : ' + 'NOW system did not process the previous upload yet - Upload can not be performed');
                  FSrvLoad.PGCmain.TabIndex := 1;
                  //EndOperationSend(false);
                  EndOperation(false);
                end;
              end;
            end;
          end;

          if CheckWarpIn_HOST then
            SendWarpSchedTo_NOW_HOST;

       //   else
       //   begin

           // EndOperation(true);
            //EndOperationSend(false);
       //   end;

          if Terminated then break;
          if (ParamStr(I) = 'UPLOAD') or (ParamStr(I) = 'MQM_Upload') or (TypMode = TD_OnlyUpload) then
          begin
            EndOperation(true);
            UpdateOperation(_('Upload completed'));
          end;

       {   except
           on E : Exception do
           begin
              EndOperation(false);
              raise; //EFDDBEngineException.CreateFmt('' , [E.Message]);

           end;

         end;   }

        end
        else
          SendScheduledToHOST;

        if DataPreparationExist then
        begin
          TypMode := TD_OnlyUpload;
          SetTypeMode(TD_OnlyUpload);
        end;

        if (ParamStr(I) = 'UPLOAD') or (ParamStr(I) = 'MQM_Upload') or (ParamStr(I) = 'MQM_Download_Production_And_Upload') or (TypMode = TD_OnlyUpload) or (TypMode = TD_DownLoadAfterUpload) or (TypMode = TD_DownloadUploadToNow) then
        begin
          if (DndArchiveHostName = TD_AS_400) then
          begin
            CT_END_UPLOAD;
            CT_CLEAR_PROCCESS_HOST;
          end;
        //  CheckDataPreparationExist;
        end;

        if (DndArchiveHostName = TD_AS_400) then
          CT_END_UPLOAD;

        UpdateOperation(_('Upload completed'));
        sleep(1000);
      //  UpdateOperation('')

        m_op       := OPI_idle;
        PostMessage(m_itfHdl, CM_UPDATE, m_op, StrToInt(IniAppGlobals.Identifier));
      end
      else
      begin
        if (DndArchiveHostName = TD_AS_400) then
          CT_END_UPLOAD;
        CT_END_ACCESS('SERVER');
      end;

      m_lastLoad := Now;

    end;

    if Terminated then break;

    if (TypMode = TD_DownLoadAfterUpload) then
    begin

      if GetTypeMode = TD_DownLoadAfterUpload then
         WriteToLog(_('Downloading') , '', false);

      if (IniAppGlobals.PreparationExeName <> '') and (IniAppGlobals.OperateWaitingTimeUploadDnld = '1') then
      begin
        if FirstLoop then
        begin
          UpdateStatuseBtn(false, true);
          FirstLoop := false
        end;
        m_lastLoad := now;
        while True do
        begin
          UpdateWaitingTime(Now - m_lastLoad);
          Sleep(1000);
          if CheckProcessAfterUploadToNow then break;
        end;
      end;
      if (IniAppGlobals.PreparationExeName <> '') then
      begin
        TypMode := TD_OnlyProd;
        SetTypeMode(TD_OnlyProd);
        OperateDownload(DataChange, EndWell, m_itfHdl);
       // CheckDataPreparationExist;
      end
      else
      begin
        //SetTypeMode(GetOldType);
        OperateDownload(DataChange, EndWell, m_itfHdl);
      end;
      m_op       := OPI_idle;
      PostMessage(m_itfHdl, CM_UPDATE, m_op, StrToInt(IniAppGlobals.Identifier));
    end;

    if (TypMode = TD_OnlyUpload) and not DataPreparationExist then
      SetTypeMode(GetOldType);

    if GetSchedChgReqFlag or GetTypeChgFlag then
    begin
       SetLoopMqmCG(GetOldLoopMqmCG);
       SetTypeMode(GetOldType);
    end;
    SetSchedChgReqFlag(false);
    SetTypeChgFlag(false);

    //---------------- Close the connections ---------------------//

    if m_loadMode <> TDOL_auto then
    begin
      if EndWell and DataChange then
      begin
        if GetMaterialSchedule_Warp_Send_Client then
          UpdateClient_Include_Warp
        else
          UpdateClient
      end

      else if GetBalanceHeader_Changed_Send_Client and EXIST_ACTIVE_STATIONS then
        UpdateClient // No other change - only balance ! we send same event

      else if GetMaterialSchedule_Warp_Send_Client and EXIST_ACTIVE_STATIONS then
        UpdateClient_Only_Warp;

      EndOperation(true);
      if (TypMode = TD_OnlyUpload) then
        UpdateOperation(_('Send completed'));

      if ParamCount > 0 then
      for J := 1 to ParamCount do
      begin
        if (ParamStr(J) = 'LoadChgReq') or (ParamStr(J) = 'LoadAllReq') or (ParamStr(J) = 'LoadOnlyArc')
             or (ParamStr(J) = 'LoadArcOnly') or (ParamStr(J) = 'UPLOAD')
             or (ParamStr(J) = 'MQM_Download_All_And_Upload') or (ParamStr(J) = 'MQM_Download_All_By_Changed_List_And_Upload')
             or (ParamStr(J) = 'MQM_Download_Production_And_Upload') or (ParamStr(J) = 'MQM_Download_Production_By_Changed_List_And_Upload')
             or (ParamStr(J) = 'MQM_Download_Production') or (ParamStr(J) = 'MQM_Download_Production_By_Changed_LisT')
             or (ParamStr(J) = 'MQM_Download_Archives') or (ParamStr(J) = 'MQM_Upload') then
        begin
          try
            m_op := OPI_Exit;
            PostMessage(m_itfHdl, CM_UPDATE, m_op, StrToInt(IniAppGlobals.Identifier));
          except
          end;
        end;
      end;
    end;

    if Terminated then break;

    //---------------- Update the clients ---------------------//
    if EndWell and DataChange then
      UpdateClient;

   {$else}

    ///////////////////////////////////////////////////////////////////////
    //    verion demo , transfer from P.C
    ///////////////////////////////////////////////////////////////////////

    if Terminated then break;

    if (m_loadMode = TDOL_auto) and (m_lastLoad <> 0) then
    begin
      if not ((Now - m_lastLoad) > (GetLoopTime)) then
      begin
        if FirstLoop then
        begin
          UpdateStatuseBtn(true, true);
          Sleep(1000);
          FirstLoop := false;
        end;
        UpdateWaitingTime(GetLoopTime - (Now - m_lastLoad));
        Sleep(1000);
        continue;
      end
      else
      begin
        FirstLoop := true;
        UpdateStatuseBtn(false, true);
      end;
    end
    else if (m_loadMode = TDOL_auto) and (m_lastLoad = 0) then
      FirstLoop := true;

    ClearStatuseOp;
    sleep(1000);
    SendToPc;
    sleep(5000);
    DownloadFromPc;

    m_lastLoad := Now;

    if (m_loadMode <> TDOL_auto) then
      EndOperation(true);

{$endif}

  end; //while

  CoUninitialize;

  except
    on E: Exception do
    begin
      UpdateOperation(_('Operation not completed'));
      UpdateStatuseBtn(true, true);
      raise EFDDBEngineException.CreateFmt('' , [E.Message]);
    end;
  end;

  if ThreadConnectionIsGood then
    FSrvLoad.m_OperationStarted := false;

  FSrvLoad.Timer1.Enabled := True;
end;

//----------------------------------------------------------------------------//

initialization

  s_OpThread := nil;

//----------------------------------------------------------------------------//
end.
