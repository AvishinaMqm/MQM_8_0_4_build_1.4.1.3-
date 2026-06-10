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
//  TMqmDBType = (Cfg_DB, Main_DB, Temp_DB);

  TFDMqmQuery       = TFDQuery;
  TFDMqmDatabase    = TFDConnection;
  TMqmStoredProc  = TADOStoredProc;
  TMqmCommand     = TADOCommand;

  TDMFireDacConnection = class(TDataModule)
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

    m_CfgDbExist: Boolean;
    m_CfgSrvOn: Boolean;

    m_MainDbExist: Boolean;
    m_MainSrvOn: Boolean;

    m_TempDbExist: Boolean;
    m_TempSrvOn: Boolean;
  public
    m_MainDB: TFDMqmDatabase;
  end;

//  procedure ReadIniFDConnection;
  function CreateMqmQuery : TFDMqmQuery;
  function CreateLocalQueryFromConnection(DB : TFDMqmDatabase): TFDMqmQuery;
//  function SrvIsOn(DBType: TMqmDBType)     : boolean;
//  function SrvFoundDb(DBType: TMqmDBType)  : boolean;
  function GetMqmDb : TFDMqmDatabase;
//  function GetMqmDbName(DBType: TMqmDBType): string;
//  function CheckServerConnection: boolean;
//  function ReCheckServerConnection: boolean;
//  function ReconnectToDatabase : boolean;

var
  FDConnection : TDMFireDacConnection;

implementation

{$R *.DFM}

uses
  IB,
  System.IniFiles,
  UMglobal,
  UMDbFunc,
  UMTblDesc,
  gnugettext;

{const

  RgNowMqmCfg   = '\Config';
  IniName         = 'NowMqm.Ini';
  RgCfgMainDBPath = 'MainDBPath';
  RgCfgUserName   = 'UserName';
  RgCfgPassword   = 'Password';

type

  TIniConnection = record
    FileNowMqmPath : string;
    MainDBPath   : string;
    UserName     : string;
    Password     : string;
  end;

var
  IniConnection : TIniConnection;   }

//----------------------------------------------------------------------------//

{
************************************ TDMib *************************************
}
procedure TDMFireDacConnection.ConnectMainDB;
begin
  m_MainDB.LoginPrompt := false;
  m_MainDB.DriverName := 'IB';
  m_MainDB.Params.Add('Database=LocalHost:' + NowGlobalSettings.MainDBPath + 'NOW_MQM_MAIN.gdb');
  m_MainDB.Params.Add('User_Name='+ NowGlobalSettings.IBUserName);
  m_MainDB.Params.Add('Password='+ NowGlobalSettings.IBPassword);

{  if (ExtractFileName(Application.ExeName) = 'NowMqmSrvLoad.exe') then
  begin
    m_MainDB.Params.Add('Pooled=True');
    FDManager.AddConnectionDef('Interbase_Pooled', 'IB', m_MainDB.Params);
    m_MainDB.ConnectionDefName := 'Interbase_Pooled';
  end; }

  m_MainDB.Connected := true;
  m_MainSrvOn   := true;
  m_MainDbExist := true;

end;

//----------------------------------------------------------------------------//

procedure TDMFireDacConnection.DataModuleCreate(Sender: TObject);
begin
  m_MainSrvOn   := false;
  m_MainDbExist := false;

  m_MainDB := TFDMqmDatabase.Create(self);
  ConnectMainDB();

  m_CfgSrvOn   := false;
  m_CfgDbExist := false;

  // Temp DB
  m_TempSrvOn   := false;
  m_TempDbExist := false;

end;

procedure TDMFireDacConnection.DataModuleDestroy(Sender: TObject);
begin
  if Assigned(m_MainDB) then
    m_MainDB.Connected := false;
  m_MainDB.Free;
end;

procedure TDMFireDacConnection.DbEventAlertClient(Sender: TObject; EventName: String;
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

procedure TDMFireDacConnection.DbEventAlertServer(Sender: TObject; EventName: String;
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

function GetMqmDb: TFDMqmDatabase;
begin
  Result := FDConnection.m_MainDB;
end;

//----------------------------------------------------------------------------//

function CreateMqmQuery : TFDMqmQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := FDConnection.m_MainDB;
end;

//----------------------------------------------------------------------------//

{function PosEx_Sha_Pas_2(const SubStr, S: string; Offset: Integer = 1): Integer;
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

procedure ReadStrFromIniFile(const sez, tag: string; var str: string);
var
  Ini: TIniFile;
  PossitionStr : Integer;
  PathNowMqmsrvLoad : string;
  FilePath : string;
begin
  FilePath := IniConnection.FileNowMqmPath;
  Ini := TIniFile.Create(FilePath + IniName);
  str := Ini.ReadString(sez,tag,str);
  Ini.Free;
end;

//----------------------------------------------------------------------------//

procedure ReadIniFDConnection;
var
  PossitionStr : Integer;
begin
  with IniConnection do
  begin
    PossitionStr := PosEx_Sha_Pas_2('NowMqmSrvLoad.exe', IniAppGlobals.PreparationExeName);
    FileNowMqmPath := copy(IniAppGlobals.PreparationExeName, 0, PossitionStr - 1);
    ReadStrFromIniFile(RgNowMqmCfg, RgCfgMainDBPath,     MainDBPath);
    ReadStrFromIniFile(RgNowMqmCfg, RgCfgUserName, UserName);
    ReadStrFromIniFile(RgNowMqmCfg, RgCfgPassword, Password);
  end;
end;
                   }
//----------------------------------------------------------------------------//

function CreateLocalQueryFromConnection(DB : TFDMqmDatabase): TFDMqmQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := DB;
end;

//----------------------------------------------------------------------------//

{function SrvIsOn(DBType: TMqmDBType): boolean;
begin
  case DBType of
    Cfg_DB  : Result := FDConnection.m_CfgSrvOn;
    Main_DB : Result := FDConnection.m_MainSrvOn;
    Temp_DB : Result := FDConnection.m_TempSrvOn;
  else
    Result := false
  end;
end;  }

//----------------------------------------------------------------------------//

{function SrvFoundDb(DBType: TMqmDBType): boolean;
begin
  case DBType of
    Cfg_DB  : Result := FDConnection.m_CfgDbExist;
    Main_DB : Result := FDConnection.m_MainDbExist;
    Temp_DB : Result := FDConnection.m_TempDbExist;
  else
    Result := false
  end;
end;      }

//----------------------------------------------------------------------------//

{function GetMqmDbName(DBType: TMqmDBType): string;
begin
  case DBType of
    Main_DB : Result := 'MY DATABASE';
  else
    Result := _('unknown')
  end;
end;  }

//----------------------------------------------------------------------------//

function ReconnectToDatabase : boolean;
begin
  Result := true;
  try
    FDConnection.m_MainDB.Close;
    FDConnection.m_MainDB.Connected := true;
  except
    Result := false;
  end;
end;

//-----------------------------------------------------------------------

end.


