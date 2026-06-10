unit DM_Pc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADOdb;

type

  TPCQuery       = TADOQuery;
  TPCDatabase    = TADOConnection;

  TDMPc = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);

  private
    function  CreatedDb: boolean;
    function  CreateDatabase(alias: string): boolean;
    function  ConnectToPcDatabase: boolean;
    function  DisconnectFromDatabase: boolean;
    function  IsConnected: boolean;
  public
    m_PCDB : TPCDatabase;

  end;

  function CreatePCQuery : TPCQuery;
  function CreatedPCdb : boolean;
  function CreatePcDatabase(alias : string): boolean;
  function ConnectToPcDatabase: boolean;
  function DisconnectPcDatabase: boolean;
  function IsPcConnected: boolean;

var
  DMPc : TDMPc;

implementation

{$R *.DFM}

{ TDMPc }

//----------------------------------------------------------------------------//

function TDMPc.ConnectToPcDatabase: boolean;
begin
  Assert(Assigned(m_PCDB));
  m_PCDB.Connected := true;
  Result := true
end;

//----------------------------------------------------------------------------//

function TDMPc.CreateDatabase(alias: string): boolean;
begin
  if Assigned(m_PCDB) then
  begin
    m_PCDB.Connected := false;
    m_PCDB.Free
  end;

  m_PCDB := TPCDatabase.Create(self);
  m_PCDB.ConnectionString := 'Provider=MSDASQL.1;Persist Security Info=False;User ID=;Data Source=' + alias + ';Extended Properties=""';
  m_PCDB.Name := 'MQM_DBAS';
  m_PCDB.LoginPrompt  := false;
  m_PCDB.KeepConnection := true;
  Result := true
end;

//----------------------------------------------------------------------------//

function TDMPc.CreatedDb: boolean;
begin
  Result := Assigned(m_PCDB)
end;

//----------------------------------------------------------------------------//

procedure TDMPc.DataModuleCreate(Sender: TObject);
begin
  m_PCDB := nil
end;

//----------------------------------------------------------------------------//

procedure TDMPc.DataModuleDestroy(Sender: TObject);
begin
  if Assigned(m_PCDB) then
  begin
    m_PCDB.Connected := false;
    m_PCDB.Free
  end
end;

//----------------------------------------------------------------------------//

function TDMPc.DisconnectFromDatabase: boolean;
begin
  Assert(Assigned(m_PCDB));
  m_PCDB.Connected := false;
  Result := true
end;

//----------------------------------------------------------------------------//

function TDMPc.IsConnected: boolean;
begin
  Assert(Assigned(m_PCDB));
  Result := m_PCDB.Connected
end;

//----------------------------------------------------------------------------//

function ConnectToPcDatabase: boolean;
begin
  Assert(Assigned(DMPc));
  Result := DMPc.ConnectToPcDatabase;
end;

//----------------------------------------------------------------------------//

function CreatedPCdb: boolean;
begin
  Assert(Assigned(DMPc));
  Result := DMPc.CreatedDb
end;

//----------------------------------------------------------------------------//

function CreatePcDatabase(alias: string): boolean;
begin
  Assert(Assigned(DMPc));
  Result := DMPc.CreateDatabase(alias)
end;

//----------------------------------------------------------------------------//

function CreatePCQuery: TPCQuery;
begin
  Result := TPCQuery.Create(nil);
  Result.Connection := DMPc.m_PCDB;
  Result.CacheSize  := 100;
  Result.CursorType := ctOpenForwardOnly;
  Result.CursorLocation := clUseServer;
end;

//----------------------------------------------------------------------------//

function DisconnectPcDatabase: boolean;
begin
  Assert(Assigned(DMPc));
  Result := DMPc.DisconnectFromDatabase
end;

//----------------------------------------------------------------------------//

function IsPcConnected: boolean;
begin
  Assert(Assigned(DMPc));
  Result := DMPc.IsConnected
end;

end.
