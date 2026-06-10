unit DMAs400;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADOdb, Db, DBLogDlg;

type
  THOSTQuery       = TADOQuery;
  THOSTDatabase    = TADOConnection;
  THOSTStoredProc  = TADOStoredProc;

  TDM_HOST = class(TDataModule)
    function ConnectToDatabase: Boolean;
    function CreateDatabase(alias: string): Boolean;
    function CreatedDb: Boolean;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    function DisconnectFromDatabase: Boolean;
    function IsConnected: Boolean;
  public
    m_HOST_DB: THOSTDatabase;
  end;

  function CreateHostQuery: TADOQuery;
  function CreateHostThreadQuery: TADOQuery;
  function CreateHostStoredProc: TADOStoredProc;
  function CreatedHostdb: boolean;
  function CreateHostDatabase(alias: string): boolean;
  function ConnectToHostDatabase: boolean;
  function DisconnectFromHostDatabase: boolean;
  function IsHostConnected: boolean;

var
  DM_HOST: TDM_HOST;

implementation

{$R *.DFM}

uses
  UMglobal;

//----------------------------------------------------------------------------//

{
************************************ TDM_HOST *************************************
}
function TDM_HOST.ConnectToDatabase: Boolean;
begin
  Assert(Assigned(m_HOST_DB));
  //  m_AS400DB.Connected := true;
  m_HOST_DB.Open;
  Result := true
end;

function TDM_HOST.CreateDatabase(alias: string): Boolean;
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

  m_HOST_DB := THOSTDatabase.Create(self);
  //sav  m_AS400DB.AliasName    := alias;

  //  m_AS400DB.ConnectionString := 'Provider=IBMDA400.DataSource.1;Persist Security Info=False;User ID=MQMUSER;Data Source=146.80.4.4;Protection Level=None;Extended Properties="";Initial Catalog=;'
  //                                +'Transport Product=Client Access;SSL=DEFAULT;Force Translate=65535;Default Collection=MQMUSER;Convert Date Time To Char=TRUE;Catalog Library List=tesmqm tesmqmd;Cursor Sensitivity=3;';
  //  m_AS400DB.ConnectionString := 'Provider=MSDASQL.1;Persist Security Info=False;Extended Properties="DSN=MQM_AS400_DB_DEMO;SYSTEM=146.80.4.4;UID=PANGALLO;DBQ=,TESMQMD TESMQM;DFTPKGLIB=QGPL;LANGUAGEID=ENU;PKG=QGPL/DEFAULT(IBM),2,0,1,0,512;NAM=1;XDYNAMIC=0;"';



  m_HOST_DB.Name := 'SRV_MQM';
  m_HOST_DB.KeepConnection := true;

  for I := 1 to ParamCount do
  begin
    if (ParamStr(I) = 'LoadChgReq') or (ParamStr(I) = 'LoadAllReq') then
    begin
      m_HOST_DB.ConnectionString := 'Provider=MSDASQL.1;Persist Security Info=False;User ID='+ IniAppGlobals.User +' ;password='+ IniAppGlobals.Password +' ;Data Source=' + alias + ';Extended Properties=""';
      m_HOST_DB.LoginPrompt := false;
      ParamsMode := true;
      Break;
    end;
  end;

  if not ParamsMode then
  begin
    if IniAppGlobals.LoginAuto = '1' then
    begin
      m_HOST_DB.ConnectionString := 'Provider=MSDASQL.1;Persist Security Info=False;User ID='+ IniAppGlobals.User +' ;password='+ IniAppGlobals.Password +' ;Data Source=' + alias + ';Extended Properties=""';
      m_HOST_DB.LoginPrompt := false;
    end
    else
    begin
      m_HOST_DB.ConnectionString := 'Provider=MSDASQL.1;Persist Security Info=False;Data Source=' + alias + ';Extended Properties=""';
      m_HOST_DB.LoginPrompt := true;
    end;
  end;
  Result := true
end;

function TDM_HOST.CreatedDb: Boolean;
begin
  Result := Assigned(m_HOST_DB)
end;

procedure TDM_HOST.DataModuleCreate(Sender: TObject);
begin
  m_HOST_DB := nil
end;

procedure TDM_HOST.DataModuleDestroy(Sender: TObject);
begin
  if Assigned(m_HOST_DB) then
  begin
    if m_HOST_DB.Connected then
      m_HOST_DB.Close;
    m_HOST_DB.Free
  end
end;

function TDM_HOST.DisconnectFromDatabase: Boolean;
begin
  Assert(Assigned(m_HOST_DB));
  m_HOST_DB.Connected := false;
  Result := true
end;

function TDM_HOST.IsConnected: Boolean;
begin
  Assert(Assigned(m_HOST_DB));
  Result := m_HOST_DB.Connected
end;

//----------------------------------------------------------------------------//

function CreateHostStoredProc: TADOStoredProc;
begin
  Result := TADOStoredProc.Create(nil);
  Result.Connection := DM_HOST.m_HOST_DB;
end;

//----------------------------------------------------------------------------//

function CreateHostQuery: TADOQuery;
begin
  Result := TADOQuery.Create(nil);
  Result.Connection := DM_HOST.m_HOST_DB;
  Result.CacheSize  := 1000;
  Result.CursorType := ctOpenForwardOnly;
  Result.CursorLocation := clUseServer;
end;

//----------------------------------------------------------------------------//

function CreateHostThreadQuery: TADOQuery;
var
  ParamsMode : boolean;
  I : Integer;
  HOSTDatabase : THOSTDatabase;
begin
  HOSTDatabase := nil;
  Result := TADOQuery.Create(nil);

  ParamsMode := false;
  if Assigned(HOSTDatabase) then
  begin
    HOSTDatabase.Close;
    HOSTDatabase.Free
  end;

  HOSTDatabase := THOSTDatabase.Create(Result);

  HOSTDatabase.Name := 'Thread_MQM_Connection';
  HOSTDatabase.KeepConnection := true;

  for I := 1 to ParamCount do
  begin
    if (ParamStr(I) = 'LoadChgReq') or (ParamStr(I) = 'LoadAllReq') then
    begin
      HOSTDatabase.ConnectionString := 'Provider=MSDASQL.1;Persist Security Info=False;User ID='+ IniAppGlobals.User +' ;password='+ IniAppGlobals.Password +' ;Data Source=' + IniAppGlobals.Alias + ';Extended Properties=""';
      HOSTDatabase.LoginPrompt := false;
      ParamsMode := true;
      Break;
    end;
  end;

  if not ParamsMode then
  begin
    if IniAppGlobals.LoginAuto = '1' then
    begin
      HOSTDatabase.ConnectionString := 'Provider=MSDASQL.1;Persist Security Info=False;User ID='+ IniAppGlobals.User +' ;password='+ IniAppGlobals.Password +' ;Data Source=' + IniAppGlobals.Alias + ';Extended Properties=""';
      HOSTDatabase.LoginPrompt := false;
    end
    else
    begin
      HOSTDatabase.ConnectionString := 'Provider=MSDASQL.1;Persist Security Info=False;Data Source=' + IniAppGlobals.Alias + ';Extended Properties=""';
      HOSTDatabase.LoginPrompt := true;
    end;
  end;

  Result.Connection := HOSTDatabase;
  Result.Connection.Open;

//  Result.Connection := DM_HOST.m_HOST_DB;
  Result.CacheSize  := 100;
  Result.CursorType := ctOpenForwardOnly;
  Result.CursorLocation := clUseServer;
end;

//----------------------------------------------------------------------------//

function CreatedHostdb: boolean;
begin
  Assert(Assigned(DM_HOST));
  Result := DM_HOST.CreatedDb
end;

//----------------------------------------------------------------------------//

function CreateHostDatabase(alias: string): boolean;
begin
  Assert(Assigned(DM_HOST));
  Result := DM_HOST.CreateDatabase(alias)
end;

//----------------------------------------------------------------------------//

function ConnectToHostDatabase: boolean;
begin
  Assert(Assigned(DM_HOST));
  Result := DM_HOST.ConnectToDatabase
end;

//----------------------------------------------------------------------------//

function DisconnectFromHostDatabase: boolean;
begin
  Assert(Assigned(DM_HOST));
  Result := DM_HOST.DisconnectFromDatabase
end;

//----------------------------------------------------------------------------//

function IsHostConnected: boolean;
begin
  Assert(Assigned(DM_HOST));
  Result := DM_HOST.IsConnected
end;

//----------------------------------------------------------------------------//
end.
