unit DMsrvPc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, IBX.IBDatabase, IBX.IBQuery, IBX.IBStoredProc, IBX.IBEvents, UMCommon,
  ADODB, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Comp.DataSet,
  FireDAC.Phys.IBBase, FireDAC.VCLUI.Wait, FireDAC.Comp.UI, FireDAC.Phys.IB,
  FireDAC.Phys.FB, FireDAC.Phys, FireDAC.Phys.ODBCBase, FireDAC.Phys.ODBC,
  FireDAC.Phys.FBDef, FireDAC.Phys.IBDef, FireDAC.Phys.ODBCDef,
  FireDAC.Phys.DB2Def, FireDAC.Phys.DB2, FireDAC.Phys.OracleDef,
  FireDAC.Phys.Oracle, FireDAC.Stan.Intf, FireDAC.Stan.Error,
  FireDAC.Comp.Client;

type

  TNetworkRecovery = class
  private
    class function IsInternetAvailable: Boolean;
    class procedure RefreshNetwork;
    class function CanConnectToDB2: Boolean;
  public
    class function WaitForDB2Recovery(
      const MaxRetries: Integer = 3; // 30 × 2s = 1 minute
      const CooldownMs: Integer = 3000
    ): Boolean;
  end;

  TMqmDBType = (Cfg_DB, Main_DB, Host_DB, Arc_DB);

  TMqmQuery       = TFDQuery;
  TMqmDatabase    = TFDConnection;
  TMqmStoredProc  = TFDStoredProc;
  TMqmCommand     = TADOCommand;
  TMqmEvent       = TFDEventAlerter;
  TMqmTransaction = TFDTransaction;

  TDMib = class(TDataModule)
    OpenDialogDB: TOpenDialog;
    FDQuery1: TFDQuery;
    FDConnection1: TFDConnection;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDTransaction1: TFDTransaction;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    FDPhysIBDriverLink1: TFDPhysIBDriverLink;
    FDPhysDB2DriverLink1: TFDPhysDB2DriverLink;
    FDPhysODBCDriverLink1: TFDPhysODBCDriverLink;
    FDPhysOracleDriverLink1: TFDPhysOracleDriverLink;
    FDStoredProc1: TFDStoredProc;
    FDEventAlerter1: TFDEventAlerter;
    function  ConnectDB_main : boolean;
    procedure ConnectDB_Cfg(CreateEventCfg : boolean);
    procedure ConnectDB_Host;
    procedure ConnectDB_Arc;
    procedure CreateEvent;

    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure DoAlertClient(ASender: TFDCustomEventAlerter;
      const AEventName: String; const AArgument: Variant);
    procedure DoAlertServer(ASender: TFDCustomEventAlerter;
      const AEventName: String; const AArgument: Variant);
    procedure DoAlertTest(ASender: TFDCustomEventAlerter;
      const AEventName: String; const AArgument: Variant);
    procedure CommunicationException(ASender, AInitiator: TObject;
    var AException: Exception);

  private
    m_CfgDbExist: Boolean;
    m_CfgSrvOn: Boolean;
    m_MainDbExist: Boolean;
    m_MainSrvOn: Boolean;
  public
    m_MainDB: TMqmDatabase;
    m_CFGDB:  TMqmDatabase;
    m_DBHost: TMqmDatabase;
    m_DBArc: TMqmDatabase;
    m_Event : TMqmEvent;

  end;

  function CreateQuery(DBType: TMqmDBType): TMqmQuery;
  function CreateQueryHost : TMqmQuery;
  function CreateQueryArc : TMqmQuery;
  function CreateTransaction(DBType: TMqmDBType) : TMqmTransaction;
  function GetCfgConnection : TMqmDatabase;
  procedure RegisterEvents(forServer: boolean);
  function CreateStoredProc(DBType: TMqmDBType): TMqmStoredProc;
  function SrvIsOn(DBType: TMqmDBType)     : boolean;
  function SrvFoundDb(DBType: TMqmDBType)  : boolean;
  function GetMqmDb(DBType: TMqmDBType)    : TMqmDatabase;
  function GetMqmDbName(DBType: TMqmDBType): string;
  function CheckServerConnection: boolean;
  function ReCheckServerConnection: boolean;

  function  IsHostDbConnected : boolean;
  function  IsLocalDbConnected : boolean;
  function  IsArcDbConnected : boolean;
  procedure HostDbConnect;
  procedure LocalDbConnect(CreateEvent : boolean);
  procedure LocalDbConnectTest;
  procedure ArcDbConnect;
  procedure RegisterEvent(IsClient : boolean);



var
  DMib: TDMib;

implementation

{$R *.DFM}

uses
//  IBX.IB,
  UMglobal,
  UMDbFunc,
  UMTblDesc,
  FMWaitCommunication,
  Winapi.WinInet, Winapi.Winsock,
  gnugettext;

var
   m_ExceptionHandled : boolean;

//----------------------------------------------------------------------------//

// Manual declaration for FlushIpNetTable (not in Delphi by default)
function FlushIpNetTable(dwFamily: ULONG): DWORD; stdcall;
  external 'iphlpapi.dll';

//----------------------------------------------------------------------------//

{ Check if Windows detects Internet connection }
class function TNetworkRecovery.IsInternetAvailable: Boolean;
var
  dwFlags: DWORD;
begin
  Result := InternetGetConnectedState(@dwFlags, 0);
end;

//----------------------------------------------------------------------------//

{ Clear DNS + ARP cache }
class procedure TNetworkRecovery.RefreshNetwork;
begin
  try
    // Clear ARP table (needs admin rights)
    FlushIpNetTable(AF_INET);
  except
    // ignore errors if no admin rights
  end;
  // Flush DNS cache
  WinExec('ipconfig /flushdns', SW_HIDE);
end;

{ Try a real DB2 connection }
class function TNetworkRecovery.CanConnectToDB2: Boolean;
//var
//  Conn: TDB2Connection;
begin
{  Result := False;
  Conn := TDB2Connection.Create(nil);
  try
    Conn.Params.Values['Database'] := 'MyDB';         // <-- change
    Conn.Params.Values['User_Name'] := 'myuser';      // <-- change
    Conn.Params.Values['Password'] := 'mypassword';   // <-- change
    Conn.Params.Values['HostName'] := 'mydbserver';   // <-- change
    Conn.Params.Values['Port'] := '50000';            // <-- change

    try
      Conn.Connected := True;
      Result := Conn.Connected;
    except
      Result := False;
    end;

  finally
    Conn.Free;
  end; }
end;

//----------------------------------------------------------------------------//

{ Main wait loop for DB2 recovery }
class function TNetworkRecovery.WaitForDB2Recovery(
  const MaxRetries: Integer;
  const CooldownMs: Integer
): Boolean;
var
  Retry: Integer;
begin
  Result := False;
  Retry := 0;

  while Retry < MaxRetries do
  begin
    Application.ProcessMessages; // keep UI alive

    if IsInternetAvailable then
    begin
      RefreshNetwork;
      Sleep(CooldownMs); // let network stabilize

      if DMib.ConnectDB_main then
      begin
        Result := True;
        Exit;
      end;
    end;

    Inc(Retry);
    Sleep(2000); // wait before retry
  end;
end;

//----------------------------------------------------------------------------//

procedure TDMib.DataModuleCreate(Sender: TObject);
type
  TFCommunicationEvent = procedure (ASender, AInitiator: TObject;
                         var AException: Exception) of object;
var
  CommunicationException : TFCommunicationEvent;
begin
  m_MainSrvOn   := false;
  m_MainDbExist := false;

  m_MainDB := TMqmDatabase.Create(self);
  m_CFGDB  := TMqmDatabase.Create(self);
  if (ExtractFileName(Application.ExeName) = 'MQM.exe') or (ExtractFileName(Application.ExeName) = 'MCM.exe') then
  begin
    CommunicationException := DMib.CommunicationException;
    m_MainDB.OnError := CommunicationException;
  end;

  m_DBHost := TMqmDatabase.Create(self);
  m_DBArc  := TMqmDatabase.Create(self);
//  CreateEvent;
{  m_Event  := TMqmEvent.Create(self);
  m_Event.Connection := m_CFGDB;

  m_Event.Names.Clear;
  m_Event.Names.Add('TEST');

  m_Event.Names.Add('db_updated');
  m_Event.Names.Add('db_poll');
  m_Event.Names.Add('db_newStatus');
  m_Event.Names.Add('db_cngdata');
  m_Event.Names.Add('db_DownLoadReq');
  m_Event.Names.Add('db_JobMsg');
  m_Event.Names.Add('db_Shared_data');

  if IniAppGlobals.DownloadTo = '2' then
     m_Event.Options.Kind := 'Events'
  else
    m_Event.Options.Kind := 'DBMS_ALERT';

  m_Event.Options.Synchronize := false;
  m_Event.Options.Timeout := 10000;
  m_Event.OnAlert := DoAlert; }
  // m_Event.OnTimeout := DoTimeout;
  // m_Event.Active := True;

end;

//----------------------------------------------------------------------------//

function TDMib.ConnectDB_Main : boolean;
begin
//  m_MainDB.ResourceOptions.CmdExecTimeout := 5000;
  result := true;
  m_MainDB.Connected := false;
  m_MainDB.Params.Clear;
  if IniAppGlobals.DownloadTo = '0' then
  begin
    {if IniAppGlobals.DownloadFrom = '2' then
    begin
      with m_MainDB.params do
      begin
        Clear;
        Add('DriverID=ODBC');
        Add('Datasource=' + IniAppGlobals.AliasOdbc);
        Add('User_Name=' + IniAppGlobals.ODBCUserName);
        Add('Password='+IniAppGlobals.ODBCPassword);
      end;
    end
    else
    begin }
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
   // end;
  end

  else if IniAppGlobals.DownloadTo = '1' then
  begin
   { if IniAppGlobals.DownloadFrom = '2' then
    begin
      with m_MainDB.params do
      begin
        Clear;
        Add('DriverID=ODBC');
        Add('Datasource=' + IniAppGlobals.AliasOdbc);
        Add('User_Name=' + IniAppGlobals.ODBCUserName);
        Add('Password='+IniAppGlobals.ODBCPassword);
      end;
    end
    else
    begin  }
    m_MainDB.DriverName := 'Ora';
    with m_MainDB.params do
    begin
      Clear;
      Add('DriverID=Ora');
   //   Add('Database=(DESCRIPTION = (ADDRESS_LIST = (ADDRESS = (PROTOCOL = TCP)(HOST = ' + IniAppGlobals.NOWOracleIp + ')(PORT = 1521))) (CONNECT_DATA = (SERVER = DEDICATED)(SERVICE_NAME = ' + IniAppGlobals.NOWOracleTNSName + ' )))');
      Add('Database=' + IniAppGlobals.NOWOracleTNSNameLocal);
      Add('User_Name=' + IniAppGlobals.NOWOracleUserNameLocal);
      Add('Password=' + IniAppGlobals.NOWOraclePasswordLocal);
    end;
  //  end
  end

  else if IniAppGlobals.DownloadTo = '2' then
  begin
    m_MainDB.LoginPrompt := false;
    m_MainDB.DriverName := 'IB';
    if IniAppGlobals.Server <> '' then
    begin
      m_MainDB.Params.Add('Server=' + IniAppGlobals.Server);
      m_MainDB.Params.Add('Database=' + IniAppGlobals.MainDBPath + 'MQM_MAIN.gdb')
    end
    else                             // Interbase 2020 // 3054
      m_MainDB.Params.Add('Database=LocalHost/3050:' + IniAppGlobals.MainDBPath + 'MQM_MAIN.gdb');

    m_MainDB.Params.Add('User_Name='+ IniAppGlobals.IBUserName);
    m_MainDB.Params.Add('Password='+ IniAppGlobals.IBPassword);

  end;

  m_MainDB.ResourceOptions.MacroCreate := False;
  m_MainDB.ResourceOptions.MacroExpand := False;

  if ExtractFileName(Application.ExeName) = 'MqmConfig.exe' then
    m_MainDB.Connected := true
  else
  begin
    try
      m_MainDB.Connected := true;
    except
      result := false;
    end;
  end;

end;

//----------------------------------------------------------------------------//

procedure TDMib.ConnectDB_Cfg(CreateEventCfg : boolean);
begin
//  m_CFGDB.ResourceOptions.CmdExecTimeout := 5000;
  m_CFGDB.Connected := false;
  m_CFGDB.Params.Clear;
  if IniAppGlobals.DownloadTo = '0' then
  begin
    {if IniAppGlobals.DownloadFrom = '2' then
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
    begin }
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
    //end;
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
      //  Add('Database=(DESCRIPTION = (ADDRESS_LIST = (ADDRESS = (PROTOCOL = TCP)(HOST = ' + IniAppGlobals.NOWOracleIp + ')(PORT = 1521))) (CONNECT_DATA = (SERVER = DEDICATED)(SERVICE_NAME = ' + IniAppGlobals.NOWOracleTNSName + ' )))');
        Add('Database=' + IniAppGlobals.NOWOracleTNSName);
        Add('User_Name=' + IniAppGlobals.NOWOracleUserName);
        Add('Password=' + IniAppGlobals.NOWOraclePassword);
      end;
    end
  end

  else if IniAppGlobals.DownloadTo = '2' then
  begin
    m_CFGDB.LoginPrompt := false;
    m_CFGDB.DriverName := 'IB';
//    if ExtractFileName(Application.ExeName) = 'Mqm.exe' then
//    begin
    if IniAppGlobals.Server <> '' then
    begin
      m_CFGDB.Params.Add('Server=' + IniAppGlobals.Server);
      m_CFGDB.Params.Add('Database=' + IniAppGlobals.MainDBPath + 'MQM_CFG.gdb')
     // m_CFGDB.Params.Add('Database=' + IniAppGlobals.Server + IniAppGlobals.CfgDBPath + 'MQM_CFG.gdb')
    end
    else                  // Interbase 2020 // 3054
      m_CFGDB.Params.Add('Database=LocalHost/3050:' + IniAppGlobals.CfgDBPath + 'MQM_CFG.gdb');

//    end;
//    else
//      m_MainDB.Params.Add('Database=LocalHost:' + IniAppGlobals.MainDBArcPath + 'NOW_MQM_MAIN.GDB');
     //  m_MainDB.Params.Add('Database=' + IniAppGlobals.MainDBPath + 'NOW_MQM_MAIN.gdb'); // kck
    m_CFGDB.Params.Add('User_Name='+ IniAppGlobals.IBUserName);
    m_CFGDB.Params.Add('Password='+ IniAppGlobals.IBPassword);
  end;

  m_CFGDB.ResourceOptions.MacroCreate := False;
  m_CFGDB.ResourceOptions.MacroExpand := False;

  if ExtractFileName(Application.ExeName) = 'MqmConfig.exe' then
    m_CFGDB.Connected := true
  else
  begin
    try
      m_CFGDB.Connected := true;
    except
    end;
  end;

  if CreateEventCfg then
  begin
    CreateEvent;
    m_Event.Active := True;
  end;
end;

procedure TDMib.ConnectDB_Host;
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
      // in office was able to connect to
   // Add('Database=(DESCRIPTION = (ADDRESS_LIST = (ADDRESS = (PROTOCOL = TCP)(HOST = ' + IniAppGlobals.NOWOracleIp + ')(PORT = 1521))) (CONNECT_DATA = (SERVER = DEDICATED)(SERVICE_NAME = ' + IniAppGlobals.NOWOracleTNSName + ' )))');
      Add('Database=' + IniAppGlobals.NOWOracleTNSName);
      // connecting to taf  used this paramethers :
    //  Add('Database=(DESCRIPTION = (ADDRESS_LIST = (ADDRESS = (PROTOCOL = TCP)(HOST = ' + IniAppGlobals.NOWOracleIp + ')(PORT = 1521))) (CONNECT_DATA = (SERVER = DEDICATED)(SERVICE_NAME = ' + 'pdbnowprod.abgplanet.abg.com' + ' )))');
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

  m_DBHost.ResourceOptions.MacroCreate := False;
  m_DBHost.ResourceOptions.MacroExpand := False;
  m_DBHost.Connected := true;

end;

procedure TDMib.ConnectDB_Arc;
begin
  if trim(IniAppGlobals.PreparationExeName) = '' then exit;

  if IniAppGlobals.downloadTo = '2' then
  begin
    m_DBArc.DriverName := 'IB';           //// Interbase 2020 // 3054
    m_DBArc.Params.Add('Database=LocalHost/3050:' + IniAppGlobals.ArcDBPath + 'NOW_MQM_MAIN.gdb');
    m_DBArc.Params.Add('User_Name='+ IniAppGlobals.IBUserName);
    m_DBArc.Params.Add('Password='+ IniAppGlobals.IBPassword)
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

  m_DBArc.ResourceOptions.MacroCreate := False;
  m_DBArc.ResourceOptions.MacroExpand := False;

  m_DBArc.Connected := true;
end;

procedure TDMib.CreateEvent;
begin
  if Assigned(m_Event) then
  begin

  end;

  m_Event  := TMqmEvent.Create(self);
  m_Event.Connection := m_CFGDB;

  m_Event.Names.Clear;
  m_Event.Names.Add('TEST');

  m_Event.Names.Add('db_updated');
  m_Event.Names.Add('db_poll');
  m_Event.Names.Add('db_pollSRV');
  m_Event.Names.Add('db_newStatus');
  m_Event.Names.Add('db_cngdata');
  m_Event.Names.Add('db_DownLoadReq');
  m_Event.Names.Add('db_JobMsg');
  m_Event.Names.Add('db_Shared_data');
  m_Event.Names.Add('db_cngdataAndWarp');
  m_Event.Names.Add('db_cngdataWarpOnly');


  if IniAppGlobals.DownloadTo = '2' then
     m_Event.Options.Kind := 'Events'
  else
    m_Event.Options.Kind := 'DBMS_ALERT';

  m_Event.Options.Synchronize := false;
  m_Event.Options.Timeout := 10000;
//  m_Event.OnAlert := DoAlertTest;
end;


procedure TDMib.DataModuleDestroy(Sender: TObject);
begin
  if Assigned(m_MainDB) then
    m_MainDB.Connected := false;
  m_MainDB.Free;
//  sleep(400);
  if Assigned(m_Event) then
  begin
    m_Event.Active := false;
    m_Event.free;
  end;
//  sleep(400);
  if Assigned(m_CFGDB) then
    m_CFGDB.Connected := false;
  m_CFGDB.Free;
//  sleep(400);
  if Assigned(m_DBHost) then
    m_DBHost.Connected := false;
  m_DBHost.Free;
//  sleep(400);
  if Assigned(m_DBArc) then
    m_DBArc.Connected := false;
  m_DBArc.Free;

end;

//----------------------------------------------------------------------------//

procedure TDMib.DoAlertClient(ASender: TFDCustomEventAlerter;
      const AEventName: String; const AArgument: Variant);
begin
  if CompareText(AEventName, EVT_POLL) = 0 then
    StillOn
  else if CompareText(AEventName, EVT_UPDATE) = 0 then
    DBUpdated
  else if CompareText(AEventName, EVT_NEWSTATUS) = 0 then
    NewStatus
  else if CompareText(AEventName, EVT_JOB_MSG) = 0 then
    JobMsgUpdate
  else if CompareText(AEventName, EVT_SHARED_DATA) = 0 then
    SharedDataUpdate
  else if CompareText(AEventName, EVT_CNGDATA) = 0 then
    DataBaseChange
  else if CompareText(AEventName, EVT_CNGDATA_AND_WARP) = 0 then
    DataBaseChangeWarp
  else if CompareText(AEventName, EVT_CNGDATA_WARP_ONLY) = 0 then
    DataBaseChangeWarpOnly
end;

//----------------------------------------------------------------------------//

procedure TDMib.DoAlertServer(ASender: TFDCustomEventAlerter;
      const AEventName: String; const AArgument: Variant);
begin
  if CompareText(AEventName, EVT_UPDATE) = 0 then
    DBUpdatedServer
  else if CompareText(AEventName, EVT_POLL_SRV) = 0 then
    ServerPollingCheckingDoubleInstance
  else if CompareText(AEventName, EVT_DOWNLOADREQ) = 0 then
    DownloadRequest
end;

//----------------------------------------------------------------------------//

procedure TDMib.DoAlertTest(ASender: TFDCustomEventAlerter;
  const AEventName: String; const AArgument: Variant);
begin
  if CompareText(AEventName, 'TEST') = 0 then
    Showmessage('great')
end;

//----------------------------------------------------------------------------//

procedure TDMib.CommunicationException(ASender, AInitiator: TObject;
    var AException: Exception);
var
  m_SaveStarted, m_refreshStarted : boolean;
  qry : TMqmQuery;
  tbInfo:       PTblInfo;
  list : TStringList;
  PingDone, FirstCheck : boolean;
  sl : TStringlist;
  FWaitCommunication : TFWaitCommunication;
begin
  Application.ProcessMessages;
  FirstCheck := true;
  if AException is EFDDBEngineException then
  begin
    if EFDDBEngineException(AException).Kind = ekServerGone then
    begin
      if not IniAppGlobals.MainFormCreated then exit;

      if not m_ExceptionHandled then
        m_ExceptionHandled := true
      else
      begin
        AException.Free;
        AException := EAbort.Create('');
        exit;
      end;

      if DBAppGlobals.m_SaveProcessStartedAndNotCompleted then
        DBAppGlobals.m_Network_Stoped_Dur_Save := true;

      TThread.Synchronize(nil,
      procedure
      begin

        if MessageDlg('Network was disconnected, try to re-connect?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        begin
          Application.ProcessMessages;
          Screen.Cursor  := crSQLWait;

          FWaitCommunication := TFWaitCommunication.CreateWaitForm(Application, W_CommunicationRepair);

          try
            FWaitCommunication.Show;
            FWaitCommunication.update;
            sleep(1);

            DataModuleCreate(Application);
            DBAppGlobals.m_ClientConnectionCriticalRepaired   := true; // this is to avoid access violation at the program closed

            while true do
            begin
              Application.ProcessMessages;
              PingDone := false;
              //try
                if TNetworkRecovery.WaitForDB2Recovery then
                begin
                  sleep(1);
                  DMib.ConnectDB_Cfg(true);
                  //DMib.ConnectDB_Arc;
                  //DMib.ConnectDB_Host;
                  RegisterEvent(true);
                  PingDone := true;
                  Application.ProcessMessages;
                end;

                if not PingDone then
                begin
                  Application.ProcessMessages;
                  sleep(1);
                  if not FirstCheck then Showmessage('Sorry but there are still connection problems. System will try to connect again ...');

                 // DataModuleCreate(Application);  // added by avi 28/07 - recreating all db for avoid end looping when ping doesnt work correctly

                  Application.ProcessMessages;
                  Screen.Cursor  := crSQLWait;

                  FirstCheck := false;

                  Application.ProcessMessages;

                  //if not PingDone then continue;
                  continue;

                end;

                Showmessage(_('Database connection is ok now.' +#13#10 + 'You might get a following error, in this case, please uncheck and press ok  '));
                Application.ProcessMessages;
                sl := TStringlist.Create;
                if DBAppGlobals.m_SaveProcessStartedAndNotCompleted then
                  WriteLogConnectionRepair(sl, true, '1')
                else if DBAppGlobals.m_RefreshProcessStarted then
                  WriteLogConnectionRepair(sl, true, '2')
                else
                  WriteLogConnectionRepair(sl, true, '0');
                sl.Free;
                break;
            end;

          finally
            FWaitCommunication.Free;
            DBAppGlobals.m_SaveProcessStartedAndNotCompleted  := false;
            DBAppGlobals.m_RefreshProcessStarted              := false;
            Screen.Cursor := crDefault;
          end;

          Application.ProcessMessages;
          Application.ProcessMessages;
          m_ExceptionHandled := false;
        end
        else
          m_ExceptionHandled := false;

      end);

      try
         list.IndexOf('XXX');
      Except
      end;
      AException.Free;
      AException := EAbort.Create('');

    end;
  end;
end;

//----------------------------------------------------------------------------//

function GetMqmDb(DBType: TMqmDBType): TMqmDatabase;
begin
  case DBType of
    Main_DB : Result := DMib.m_MainDB;
    Cfg_DB : Result := DMib.m_CFGDB;
  else
    Result := nil
  end;
end;

//----------------------------------------------------------------------------//

function CreateQuery(DBType: TMqmDBType): TFDQuery;
type
  TFCommunicationEvent = procedure (Sender, Initiator: TObject; Exception: EFDException) of object;
var
  TestComminication : TFCommunicationEvent;
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

//  TestComminication := DMib.OnTest;

//  Result.OnExecuteError := TestComminication;



  ////////
//  Result.FetchOptions.CursorKind := ckForwardOnly;
//  Result.FetchOptions.LiveWindowFastFirst := true;
  ////////
  case DBType of
    Main_DB : Result.Connection := DMib.m_MainDB;
    Cfg_DB : Result.Connection := DMib.m_CFGDB;
  end;

  Result.Connection.UpdateOptions.Lockmode  := lmNone;
//lmPessimistic;

  Result.Connection.UpdateOptions.LockPoint := lpDeferred;

  Result.Connection.UpdateOptions.LockWait  := False;

  Result.ResourceOptions.MacroCreate := False;
  Result.ResourceOptions.MacroExpand := False;

end;

//----------------------------------------------------------------------------//

function CreatestoredProc(DBType: TMqmDBType): TMqmStoredProc;
begin
  Result := TMqmStoredProc.Create(nil);
  case DBType of
    Cfg_DB  : Result.Connection := DMib.m_CfgDB;
    Main_DB : Result.Connection := DMib.m_MainDB;
  end;
end;

//----------------------------------------------------------------------------//

function CreateQueryHost : TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := DMib.m_DBHost;
  Result.ResourceOptions.MacroCreate := False;
  Result.ResourceOptions.MacroExpand := False;
end;

//----------------------------------------------------------------------------//

function CreateQueryArc : TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := DMib.m_DBArc;
end;

//----------------------------------------------------------------------------//

function CreateTransaction(DBType: TMqmDBType) : TMqmTransaction;
begin
  Result := TFDTransaction.Create(nil);
  if DBType = Main_DB then
    Result.Connection := DMib.m_MainDB
  else if DBType = Cfg_DB then
    Result.Connection := DMib.m_CFGDB
  else if DBType = Arc_DB then
    Result.Connection := DMib.m_DBArc
  else
    Result.Connection := DMib.m_DBHost;

  Result.Connection.UpdateOptions.LockWait := False;
  Result.Options.ReadOnly := False;

//  if Result.Connection.InTransaction then
//     Result.Connection.Rollback;

end;

//----------------------------------------------------------------------------//

function GetCfgConnection : TMqmDatabase;
begin
  Result := DMib.m_CFGDB
end;

//----------------------------------------------------------------------------//

procedure RegisterEvents(forServer: boolean);
begin
  if forServer then

end;

//----------------------------------------------------------------------------//

function SrvIsOn(DBType: TMqmDBType): boolean;
begin
  case DBType of
    Cfg_DB  : Result := DMib.m_CfgSrvOn;
    Main_DB : Result := DMib.m_MainSrvOn;
  else
    Result := false
  end;
end;

//----------------------------------------------------------------------------//

function SrvFoundDb(DBType: TMqmDBType): boolean;
begin
  case DBType of
    Cfg_DB  : Result := DMib.m_CfgDbExist;
    Main_DB : Result := DMib.m_MainDbExist;
  else
    Result := false
  end;
end;

//----------------------------------------------------------------------------//

function GetMqmDbName(DBType: TMqmDBType): string;
begin
  case DBType of
    Main_DB : Result := DMib.m_MainDB.Params[1];
    Cfg_DB : Result := DMib.m_CFGDB.Params[1];

  //  Main_DB : Result := 'MY DATABASE';
  else
    Result := _('unknown')
  end;
end;

{
  This function checks the connection to the Interbase server.
  @return True if there is aconnection or False otherwise
}
function CheckServerConnection: boolean;
begin
  result := true;

  if (not SrvIsOn(Main_DB)) then
  begin
    showmessage(_('Connection failed. Database server is down please restart it, program will be terminated'));
    Result := false;
    exit;
  end;

  if not SrvFoundDb(Main_DB) then
  begin
    if MessageDlg(_('Connection failed.     Main MQM Database not found,    Please browse for the DB '),
                    mtConfirmation, [mbOK,mbCancel], 0 )in [mrCancel] then
    begin
        result := false;
        showmessage(_('Connection failed. Main MQM Database not found,program will be terminated'));
    end else
    begin
      if DMib.OpenDialogDB.Execute then
      begin
        IniAppGlobals.MainDBName := ExtractFileName(DMib.OpenDialogDB.FileName);
        IniAppGlobals.MainDBPath := ExtractFilePath(DMib.OpenDialogDB.FileName);

      //  Dmib.ConnectDB;
        if SrvFoundDb(Main_DB) then
        begin
          GlobSaveIniValues;
        end;
      end;//if execute
    end;//else
  end; //if not found DB
end;

//-----------------------------------------------------------------------

function ReCheckServerConnection: boolean;
begin
  Result := true;

  DMib.m_MainDB.Ping;

  Application.ProcessMessages;
  {Exit;


  try
    if not DMib.m_MainDB.Ping then
       result := false;
  except
    Result := false;
  end;

  if not Result or not DMib.m_MainDB.Connected then
  begin
    Application.ProcessMessages;
    IniAppGlobals.ClientConnectionCheck := '2';

    raise EFDDBEngineException.Create('Network problem is detected');
    Application.ProcessMessages;
  end;
           }
end;

//-----------------------------------------------------------------------

function IsHostDbConnected : boolean;
begin
  Result := DMib.m_DBHost.Connected
end;

//-----------------------------------------------------------------------

function IsLocalDbConnected : boolean;
begin
  Result := (DMib.m_CFGDB.Connected) and (DMib.m_MainDB.Connected)
end;

//-----------------------------------------------------------------------

function IsArcDbConnected : boolean;
begin
  Result := (DMib.m_DBArc.Connected)
end;

//-----------------------------------------------------------------------

procedure HostDbConnect;
begin
  DMib.ConnectDB_Host;
end;

//-----------------------------------------------------------------------

procedure LocalDbConnect(CreateEvent : boolean);
begin
  DMib.ConnectDB_main;
  DMib.ConnectDB_Cfg(CreateEvent)
end;

//-----------------------------------------------------------------------

procedure LocalDbConnectTest;
begin
  DMib.ConnectDB_main;
end;

//-----------------------------------------------------------------------

procedure ArcDbConnect;
begin
  DMib.ConnectDB_Arc;
end;

//-----------------------------------------------------------------------

procedure RegisterEvent(IsClient : boolean);
begin
  if IsClient then
    DMib.m_Event.OnAlert := DMib.DoAlertClient
  else
    DMib.m_Event.OnAlert := DMib.DoAlertServer
end;

Initialization

  m_ExceptionHandled := false;

end.


