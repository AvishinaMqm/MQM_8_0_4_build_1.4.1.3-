unit DMHostConnection;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADOdb, Db, DBLogDlg, UMCommon;

type
  THOSTMqmQuery       = TADOQuery;
  THOSTMqmDatabase    = TADOConnection;
  THOSTStoredProc  = TADOStoredProc;
  THOSTCommand     = TADOCommand;

  TDM_NOW_HOST_Connection = class(TDataModule)
    function ConnectToDatabase: Boolean;
    function CreateDatabase(alias: string): Boolean;
    function CreatedDb: Boolean;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    function DisconnectFromDatabase: Boolean;
    function IsConnected: Boolean;
  public
    m_HOST_DB: THOSTMqmDatabase;
    m_ConnectionString : string;
  end;

//  procedure ReadIniConnection;
  function CreateNowHostQuery: TADOQuery;
  function CreateNowHostQueryForConnection(HOSTDatabase : THOSTMqmDatabase) : TADOQuery;
  function CreateNowHostStoredProc: TADOStoredProc;
  function CreatedNowHostdb: boolean;
  function CreateNowHostDatabase(alias: string): boolean;
  function ConnectToNowHostDatabase: boolean;
  function DisconnectFromNowHostDatabase: boolean;
  function IsNowHostConnected: boolean;
  function CreateNowHostCommand: TADOCommand;

var
  DM_NOW_HOSTConnection : TDM_NOW_HOST_Connection;

implementation

{$R *.DFM}

uses
  UMGlobal, System.IniFiles;

//----------------------------------------------------------------------------//

{
************************************ TDM_HOST *************************************
}
function TDM_NOW_HOST_Connection.ConnectToDatabase: Boolean;
begin
  Assert(Assigned(m_HOST_DB));
  //  m_AS400DB.Connected := true;
  m_HOST_DB.Open;
  Result := true
end;

function TDM_NOW_HOST_Connection.CreateDatabase(alias: string): Boolean;
var
  ParamsMode : boolean;
  I : Integer;
begin
  ParamsMode := false;
  if Assigned(m_HOST_DB) then
  begin
    m_HOST_DB.Close;
    m_HOST_DB.Free
  end;

  m_HOST_DB := THOSTMqmDatabase.Create(self);
  m_HOST_DB.IsolationLevel := ilReadUncommitted; // fix DB2 deadlock: UR isolation = no share locks on cursor rows
  //sav  m_AS400DB.AliasName    := alias;

  //  m_AS400DB.ConnectionString := 'Provider=IBMDA400.DataSource.1;Persist Security Info=False;User ID=MQMUSER;Data Source=146.80.4.4;Protection Level=None;Extended Properties="";Initial Catalog=;'
  //                                +'Transport Product=Client Access;SSL=DEFAULT;Force Translate=65535;Default Collection=MQMUSER;Convert Date Time To Char=TRUE;Catalog Library List=tesmqm tesmqmd;Cursor Sensitivity=3;';
  //  m_AS400DB.ConnectionString := 'Provider=MSDASQL.1;Persist Security Info=False;Extended Properties="DSN=MQM_AS400_DB_DEMO;SYSTEM=146.80.4.4;UID=PANGALLO;DBQ=,TESMQMD TESMQM;DFTPKGLIB=QGPL;LANGUAGEID=ENU;PKG=QGPL/DEFAULT(IBM),2,0,1,0,512;NAM=1;XDYNAMIC=0;"';



  m_HOST_DB.Name := 'SRV_MQM';
  m_HOST_DB.KeepConnection := true;

  //added by Erbil on 21.07.2009
  m_HOST_DB.CommandTimeout := 0;

  for I := 1 to ParamCount do
  begin
    if (ParamStr(I) = 'LoadChgReq') or (ParamStr(I) = 'LoadAllReq') then
    begin
      if NowGlobalSettings.downloadFrom = '0' then
        m_HOST_DB.ConnectionString := 'Provider=IBMDADB2.' + NowGlobalSettings.NOWDB2InstanceName + ';' +
                                      'Password=' + NowGlobalSettings.NOWDB2Password + ';' +
                                      'Persist Security Info=True;' +
                                      'User ID=' + NowGlobalSettings.NOWDB2UserName + ';' +
                                      'Data Source=' + NowGlobalSettings.NOWDB2DataSource + ';' +
                                      'Location=' + NowGlobalSettings.NOWDB2SrvIP + ';' +
                                      'Extended Properties=""'
      else
        m_HOST_DB.ConnectionString := //'Provider=msdaora;' +
                                      'Provider=OraOLEDB.Oracle;' +
                                      //'Provider=OracleOLEDB.Oracle;' +
                                      'Data Source=' + NowGlobalSettings.NOWOracleTNSName + ';' +
                                      'User Id=' + NowGlobalSettings.NOWOracleUserName + ';' +
                                      'Password=' + NowGlobalSettings.NOWOraclePassword + ';';

      m_HOST_DB.LoginPrompt := false;
      m_ConnectionString := m_HOST_DB.ConnectionString;
      ParamsMode := true;
      Break;
    end;
  end;

  if not ParamsMode then
  begin
    if NowGlobalSettings.downloadFrom = '0' then
    begin

      if NowGlobalSettings.Alias <> '' then
      begin
        m_HOST_DB.ConnectionString := 'Provider=MSDASQL.1;' +
                                    'Password=' + NowGlobalSettings.NOWDB2Password + ';' +
                                    'Persist Security Info=false;' +
                                    'User ID=' + NowGlobalSettings.NOWDB2UserName + ';' +
                                    'Data Source=' + NowGlobalSettings.Alias + ';' +
                                    'Extended Properties=""'
      end
      else
        m_HOST_DB.ConnectionString := 'Provider=IBMDADB2.' + NowGlobalSettings.NOWDB2InstanceName + ';' +
                                    'Password=' + NowGlobalSettings.NOWDB2Password + ';' +
                                    'Persist Security Info=True;' +
                                    'User ID=' + NowGlobalSettings.NOWDB2UserName + ';' +
                                    'Data Source=' + NowGlobalSettings.NOWDB2DataSource + ';' +
                                    'Location=' + NowGlobalSettings.NOWDB2SrvIP + ';' +
                                    'Extended Properties=""'
    end
    else
    begin
      if NowGlobalSettings.Alias <> '' then
      begin
        m_HOST_DB.ConnectionString := 'Provider=MSDASQL.1;' +
                                    'Password=' + NowGlobalSettings.NOWDB2Password + ';' +
                                    'Persist Security Info=false;' +
                                    'User ID=' + NowGlobalSettings.NOWDB2UserName + ';' +
                                    'Data Source=' + NowGlobalSettings.Alias + ';' +
                                    'Extended Properties=""'
      end
      else
        m_HOST_DB.ConnectionString := //'Provider=msdaora;' +
                                    'Provider=OraOLEDB.Oracle;' +
                                    //'Provider=OracleOLEDB.Oracle;' +
                                    'Data Source=' + NowGlobalSettings.NOWOracleTNSName + ';' +
                                    'User Id=' + NowGlobalSettings.NOWOracleUserName + ';' +
                                    'Password=' + NowGlobalSettings.NOWOraclePassword + ';';

    end;
    m_ConnectionString := m_HOST_DB.ConnectionString;
    m_HOST_DB.LoginPrompt := false;
  end;

  Result := true
end;

function TDM_NOW_HOST_Connection.CreatedDb: Boolean;
begin
  Result := Assigned(m_HOST_DB)
end;

procedure TDM_NOW_HOST_Connection.DataModuleCreate(Sender: TObject);
begin
  m_HOST_DB := nil
end;

procedure TDM_NOW_HOST_Connection.DataModuleDestroy(Sender: TObject);
begin
  if Assigned(m_HOST_DB) then
  begin
    if m_HOST_DB.Connected then
      m_HOST_DB.Close;
    m_HOST_DB.Free
  end;
end;

function TDM_NOW_HOST_Connection.DisconnectFromDatabase: Boolean;
begin
  Assert(Assigned(m_HOST_DB));
  m_HOST_DB.Connected := false;
  Result := true
end;

function TDM_NOW_HOST_Connection.IsConnected: Boolean;
begin
  Assert(Assigned(m_HOST_DB));
  Result := m_HOST_DB.Connected
end;

//----------------------------------------------------------------------------//

function CreateNowHostStoredProc: TADOStoredProc;
begin
  Result := TADOStoredProc.Create(nil);
  Result.Connection := DM_NOW_HOSTConnection.m_HOST_DB;
end;

//----------------------------------------------------------------------------//

function CreateNowHostQuery: TADOQuery;
begin
  Result := TADOQuery.Create(nil);
  Result.Connection := DM_NOW_HOSTConnection.m_HOST_DB;
  Result.CacheSize  := 100;
  Result.CursorType := ctOpenForwardOnly;
  Result.CursorLocation := clUseServer;
  Result.CommandTimeout := 0;
end;

//----------------------------------------------------------------------------//

function CreateNowHostQueryForConnection(HOSTDatabase : THOSTMqmDatabase) : TADOQuery;
begin
  Result := TADOQuery.Create(nil);
  Result.Connection := HOSTDatabase;
  Result.CacheSize  := 100;
  Result.CursorType := ctOpenForwardOnly;
  Result.CursorLocation := clUseServer;
  Result.CommandTimeout := 0;
end;

//----------------------------------------------------------------------------//

function CreatedNowHostdb: boolean;
begin
  Assert(Assigned(DM_NOW_HOSTconnection));
  Result := DM_NOW_HOSTConnection.CreatedDb
end;

//----------------------------------------------------------------------------//

function CreateNowHostDatabase(alias: string): boolean;
begin
  Assert(Assigned(DM_NOW_HOSTConnection));
  Result := DM_NOW_HOSTConnection.CreateDatabase(alias)
end;

//----------------------------------------------------------------------------//

function ConnectToNowHostDatabase: boolean;
begin
  Assert(Assigned(DM_NOW_HOSTConnection));
  Result := DM_NOW_HOSTConnection.ConnectToDatabase
end;

//----------------------------------------------------------------------------//

function DisconnectFromNowHostDatabase: boolean;
begin
  Assert(Assigned(DM_NOW_HOSTConnection));
  Result := DM_NOW_HOSTConnection.DisconnectFromDatabase
end;

//----------------------------------------------------------------------------//

function IsNowHostConnected: boolean;
begin
  Assert(Assigned(DM_NOW_HOSTConnection));
  Result := DM_NOW_HOSTConnection.IsConnected
end;

//----------------------------------------------------------------------------//

function CreateNowHostCommand: TADOCommand;
begin
  Result := TADOCommand.Create(nil);
  Result.Connection := DM_NOW_HOSTConnection.m_HOST_DB;
end;

//----------------------------------------------------------------------------//

end.
