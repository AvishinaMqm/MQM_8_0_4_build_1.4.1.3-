unit DMFireDacConnection;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, IBDatabase, IBQuery, IBStoredProc, IBEvents, UMCommon,
  ADODB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Comp.Client, FireDAC.Comp.DataSet,
  FireDAC.Phys.IBBase, FireDAC.VCLUI.Wait, FireDAC.Comp.UI, FireDAC.Phys.IB,
  FireDAC.Phys.FB, FireDAC.Phys;

type
  TMqmDBType = (Cfg_DB, Main_DB, Temp_DB);

//  TMqmIBQuery       = TIBQuery;
//  TMqmIBTransaction = TIBTransaction;
//  TMqmIBDatabase    = TIBDatabase;
  //TMqmStoredProc  = TIBStoredProc;
  //TMqmDBEvents    = TIBEvents;

//  TMqmTransaction = TFDTransaction;
  TMqmQuery       = TFDQuery;
  TMqmDatabase    = TFDConnection;
  TMqmStoredProc  = TADOStoredProc;
  TMqmCommand     = TADOCommand;

  TDMib = class(TDataModule)
    OpenDialogDB: TOpenDialog;
    FDQuery1: TFDQuery;
    FDConnection1: TFDConnection;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDTransaction1: TFDTransaction;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    FDPhysIBDriverLink1: TFDPhysIBDriverLink;
    procedure ConnectMainDB;
//    procedure ConnectMainDB_IB;
    //procedure ConnectTMPDB;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure DbEventAlertClient(Sender: TObject; EventName: String;
            EventCount: Integer; var CancelAlerts: Boolean);
    procedure DbEventAlertServer(Sender: TObject; EventName: String;
            EventCount: Integer; var CancelAlerts: Boolean);
  private
//    m_CfgDB: TMqmDatabase;
    m_CfgDbExist: Boolean;
    m_CfgSrvOn: Boolean;
    //m_DBEvents: TMqmDBEvents;
    m_MainDbExist: Boolean;
    m_MainSrvOn: Boolean;
//    m_TempDB: TMqmDatabase;
    m_TempDbExist: Boolean;
    m_TempSrvOn: Boolean;
  public
    m_MainDB: TMqmDatabase;

  //  m_TempDB: TMqmDatabase;

//    m_MainDB_IB : TMqmIBDatabase;
  end;

  function CreateQuery(DBType: TMqmDBType): TMqmQuery;
  function CreateLocalQueryFromConnection(DB : TMqmDatabase): TMqmQuery;
//  function CreateNewQuery(DBType: TMqmDBType): TMqmQuery;
  //function CreateStoredProc(trans: TMqmTransaction; DBType: TMqmDBType): TMqmStoredProc;
//  function CreateIBQuery(trans: TMqmIBTransaction; DBType: TMqmDBType): TMqmIBQuery;
//  function CreateIBTransaction(DBType: TMqmDBType; isReadOnly: boolean): TMqmIBTransaction;
//  function CreateTransaction(DBType: TMqmDBType; isReadOnly: boolean): TMqmTransaction;
  //function CreateDbEvents(DBType: TMqmDBType): TMqmDbEvents;
  function SrvIsOn(DBType: TMqmDBType)     : boolean;
  function SrvFoundDb(DBType: TMqmDBType)  : boolean;
  function GetMqmDb(DBType: TMqmDBType)    : TMqmDatabase;
  function GetMqmDbName(DBType: TMqmDBType): string;
  function CheckServerConnection: boolean;
  function ReCheckServerConnection: boolean;
  function ReconnectToDatabase : boolean;
//  function ReconnectMsg : boolean;

var
  DMib: TDMib;

implementation

{$R *.DFM}

uses
  IB,
  UMglobal,
  UMDbFunc,
  UMTblDesc,
  gnugettext;

//----------------------------------------------------------------------------//

{
************************************ TDMib *************************************
}
procedure TDMib.ConnectMainDB;
begin

{  if (IniAppGlobals.downloadTo = '0') then
    m_MainDB.ConnectionString := 'Provider=MSDASQL.1;Persist Security Info=False;' +
                                 'User ID='+ IniAppGlobals.IBUserName +';' +
                                 'password='+ IniAppGlobals.IBPassword +';' +
                                 'Data Source=' + IniAppGlobals.IBDataSource + ';Extended Properties=""'
  else
    m_MainDB.ConnectionString := 'Provider=IBMDADB2.' + IniAppGlobals.DB2InstanceName + ';' +
                                 //'Provider=IBMDADB2.DB2COPY1;' +
                                 'Password=' + IniAppGlobals.DB2Password + ';' +
                                 'Persist Security Info=True;' +
                                 'User ID=' + IniAppGlobals.DB2UserName + ';' +
                                 'Data Source=' + IniAppGlobals.DB2DataSource + ';' +
                                 'Location=' + IniAppGlobals.DB2SrvIP + ';' +
                                 'Extended Properties=""';    }

  m_MainDB.LoginPrompt := false;
  m_MainDB.DriverName := 'IB';
  if ( ExtractFileName(Application.ExeName) = 'MqmArc.exe' ) then
     m_MainDB.Params.Add('Database=LocalHost:' + IniAppGlobals.MainDBPath + 'MQM_MAIN.gdb')
  else
    m_MainDB.Params.Add('Database=LocalHost:' + IniAppGlobals.MainDBPath + 'NOW_MQM_MAIN.gdb');
  m_MainDB.Params.Add('User_Name='+ IniAppGlobals.IBUserName);
  m_MainDB.Params.Add('Password='+ IniAppGlobals.IBPassword);

  if (ExtractFileName(Application.ExeName) = 'NowMqmSrvLoad.exe') then
  begin
    m_MainDB.Params.Add('Pooled=True');
    FDManager.AddConnectionDef('Interbase_Pooled', 'IB', m_MainDB.Params);
    m_MainDB.ConnectionDefName := 'Interbase_Pooled';
  end;

   m_MainDB.Connected := true;
   m_MainSrvOn   := true;
   m_MainDbExist := true;

 //  FDManager.Active := True;
end;

{procedure TDMib.ConnectMainDB_IB;
begin
  if IniAppGlobals.Server = '' then
   m_MainDB_IB.DatabaseName := IniAppGlobals.MainDBPath + IniAppGlobals.MainDBName
  else
     m_MainDB_IB.DatabaseName := IniAppGlobals.Server + ':' + IniAppGlobals.MainDBPath + IniAppGlobals.MainDBName;

    m_MainDB_IB.Name         := 'NowMqmMainDb';
    m_MainDB_IB.LoginPrompt  := false;
    m_MainDB_IB.Params.Add('user_name=SYSDBA');
    m_MainDB_IB.Params.Add('password=masterkey');
    m_MainDB_IB.SQLDialect := 3;

    try
      m_MainDB_IB.Connected := true;
      m_MainSrvOn   := true;
      m_MainDbExist := true
    except
      on E:EIBInterbaseError do
        if      E.IBErrorCode = 335544375 then
          // server down
          m_MainSrvOn   := false
        else if E.IBErrorCode = 335544344 then
        begin
          // not found database
          m_MainSrvOn   := true;
          m_MainDbExist := false
        end
        else
          Raise
  //  end
  end;

end; }

procedure TDMib.DataModuleCreate(Sender: TObject);
begin
  m_MainSrvOn   := false;
  m_MainDbExist := false;

  m_MainDB := TMqmDatabase.Create(self);
  ConnectMainDB();

{  if UpperCase(IniAppGlobals.MainDBName) = 'NOW_MQM_MAIN.GDB' then
  begin
    m_MainDB_IB := TMqmIBDatabase.Create(self);
    ConnectMainDB_IB();
  end; }

  m_CfgSrvOn   := false;
  m_CfgDbExist := false;

  // Temp DB
  m_TempSrvOn   := false;
  m_TempDbExist := false;

//  m_TempDB := TMqmDatabase.Create(self);
end;

procedure TDMib.DataModuleDestroy(Sender: TObject);
begin
  if Assigned(m_MainDB) then
    m_MainDB.Connected := false;
  m_MainDB.Free;

  // Temp DB
//  if Assigned(m_TempDB) then
//    m_TempDB.Connected := false;
//  m_TempDB.Free;
end;

procedure TDMib.DbEventAlertClient(Sender: TObject; EventName: String;
        EventCount: Integer; var CancelAlerts: Boolean);
begin
  if EventName = EVT_POLL then
    StillOn
  else if EventName = EVT_UPDATE then
    DBUpdated
  else if EventName = EVT_NEWSTATUS then
    NewStatus
  else if EventName = EVT_CNGDATA then
    DataBaseChange
end;

//----------------------------------------------------------------------------//

procedure TDMib.DbEventAlertServer(Sender: TObject; EventName: String;
        EventCount: Integer; var CancelAlerts: Boolean);
begin
  if EventName = EVT_UPDATE then
    DBUpdatedServer
  else if EventName = EVT_POLL then
    StillOn
  else if EventName = EVT_DOWNLOADREQ then
    DownloadRequest;
end;

//----------------------------------------------------------------------------//

function GetMqmDb(DBType: TMqmDBType): TMqmDatabase;
begin
  case DBType of
    Main_DB : Result := DMib.m_MainDB;
//    Temp_DB : Result := DMib.m_TempDB;
  else
    Result := nil
  end;
end;

//----------------------------------------------------------------------------//

function CreateQuery(DBType: TMqmDBType): TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := DMib.m_MainDB;
end;

//----------------------------------------------------------------------------//

function CreateLocalQueryFromConnection(DB : TMqmDatabase): TMqmQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := DB;
end;

//function CreateNewQuery(DBType: TMqmDBType): TMqmQuery;
//begin
{  Result := TADOQuery.Create(nil);
  Result.CacheSize  := 100;
  Result.CursorType := ctOpenForwardOnly;
  Result.CursorLocation := clUseServer;
  Result.CommandTimeout := 0;
  Result.Connection := DMib.m_MainDB;  }
//end;

//----------------------------------------------------------------------------//

{function CreateIBQuery(trans: TMqmIBTransaction; DBType: TMqmDBType): TMqmIBQuery;
begin
  Result := TMqmIBQuery.Create(nil);
  case DBType of
    Main_DB : Result.Database := DMib.m_MainDB_IB;
  end;
  Result.Transaction := trans;
  Result.UniDirectional := true;
end;  }

//----------------------------------------------------------------------------//

//function CreateTransaction(DBType: TMqmDBType; isReadOnly: boolean): TMqmTransaction;
//begin
//  Result := TMqmTransaction.Create(nil);

//  Result.Connection := DMib.m_MainDB;
{//  Result.defa

//  if isReadOnly then
//    Result.  Params.Add('read');

 // case DBType of
 //   Result.Connection := DMib.m_MainDB;
 // end;  }
//end;

//----------------------------------------------------------------------------//

{function CreateIBTransaction(DBType: TMqmDBType; isReadOnly: boolean): TMqmIBTransaction;
begin
  Result := TMqmIBTransaction.Create(nil);

  if isReadOnly then
    Result.Params.Add('read');

  case DBType of
    Main_DB : Result.DefaultDatabase := DMib.m_MainDB_IB;
  end;
end; }

//----------------------------------------------------------------------------//

function SrvIsOn(DBType: TMqmDBType): boolean;
begin
  case DBType of
    Cfg_DB  : Result := DMib.m_CfgSrvOn;
    Main_DB : Result := DMib.m_MainSrvOn;
    Temp_DB : Result := DMib.m_TempSrvOn;
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
    Temp_DB : Result := DMib.m_TempDbExist;
  else
    Result := false
  end;
end;

//----------------------------------------------------------------------------//

function GetMqmDbName(DBType: TMqmDBType): string;
begin
  case DBType of
    //Main_DB : Result := DMib.m_MainDB.DatabaseName;
    //Temp_DB : Result := DMib.m_TempDB.DatabaseName;

    Main_DB : Result := 'MY DATABASE';
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

        Dmib.ConnectMainDB;
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
  result := false;
  try
    if not DMib.m_MainDB.Connected then exit;
  except
     exit;
  end;
  result := true;
end;

//-----------------------------------------------------------------------

function ReconnectToDatabase : boolean;
begin
  Result := true;
  try
    DMib.m_MainDB.Close;
    DMib.m_MainDB.Connected := true;
  except
    Result := false;
  end;
end;

//-----------------------------------------------------------------------

end.


