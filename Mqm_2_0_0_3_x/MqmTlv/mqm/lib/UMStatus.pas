unit UMStatus;

interface

  function  GetStatus(var srvLoadOn, canRead, canWrite, isUpdating: boolean): boolean;
  procedure UpdateStatus;
  function  StartUpdating: boolean;
  procedure EndUpdating;

implementation

uses
  UMStoredProc,
  UMGlobal;

type

  TMqmStatus = class
    constructor CreateStatus;
  public
    m_srvLoadOn:  boolean;
    m_canRead:    boolean;
    m_canWrite:   boolean;
    m_isUpdating: boolean;
  end;

var
  MmqStatus: TMqmStatus;

//----------------------------------------------------------------------------//

function StartUpdating: boolean;
begin
  MmqStatus.m_isUpdating := true;
  Result := true
end;

//----------------------------------------------------------------------------//

procedure EndUpdating;
begin
  MmqStatus.m_isUpdating := false
end;

//----------------------------------------------------------------------------//

function GetStatus(var srvLoadOn, canRead, canWrite, isUpdating: boolean): boolean;
begin
  srvLoadOn  := MmqStatus.m_srvLoadOn;
  canRead    := MmqStatus.m_canRead;
  canWrite   := MmqStatus.m_canWrite;
  isUpdating := MmqStatus.m_isUpdating;
  Result := true
end;

//----------------------------------------------------------------------------//

procedure UpdateStatus;
begin
  with MmqStatus do
    SP_GET_STATUS(IniAppGlobals.WkstCode, m_srvLoadOn, m_canRead, m_canWrite)
end;

//----------------------------------------------------------------------------//

constructor TMqmStatus.CreateStatus;
begin
  m_srvLoadOn  := false;
  m_canRead    := false;
  m_canWrite   := false;
  m_isUpdating := false;
end;

//----------------------------------------------------------------------------//

initialization

  MmqStatus := TMqmStatus.CreateStatus

finalization

  MmqStatus.Free

//----------------------------------------------------------------------------//
end.

