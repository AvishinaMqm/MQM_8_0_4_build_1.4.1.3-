unit UMDbFunc;

interface

uses
  Windows,
  Messages;

  procedure DBUpdated;
  procedure NewStatus;
  procedure StillOn;
  procedure DBUpdatedServer;
  procedure DataBaseChange;
  procedure DataBaseChangeWarp;
  procedure DataBaseChangeWarpOnly;
  procedure DownloadRequest;
  procedure JobMsgUpdate;
  procedure SharedDataUpdate;
  procedure ServerPollingCheckingDoubleInstance;

const
  EVT_UPDATE    = 'db_updated';
  EVT_POLL      = 'db_poll';
  EVT_POLL_SRV  = 'db_pollSRV';
  EVT_NEWSTATUS = 'db_newStatus';
  EVT_CNGDATA   = 'db_cngdata';
  EVT_CNGDATA_AND_WARP   = 'db_cngdataAndWarp';
  EVT_CNGDATA_WARP_ONLY  = 'db_cngdataWarpOnly';
  EVT_DOWNLOADREQ = 'db_DownLoadReq';
  EVT_JOB_MSG     = 'db_JobMsg';
  EVT_SHARED_DATA = 'db_Shared_data';
  EVT_TEST        = 'WarpUpdate';
  MSG_UPDATE = WM_APP + 1;

var
  s_MsgHandle: THandle;

implementation

uses
//  UMStatus,
  System.SysUtils,
  UMGlobal,
  UmCommon,
  DMSrvPC;

//----------------------------------------------------------------------------//

procedure StillOn;
begin
  PostMessage(s_MsgHandle, MSG_UPDATE, 2, StrToInt(IniAppGlobals.Identifier))
end;

//----------------------------------------------------------------------------//

procedure NewStatus;
begin
  PostMessage(s_MsgHandle, MSG_UPDATE, 1, StrToInt(IniAppGlobals.Identifier))
end;

//----------------------------------------------------------------------------//

procedure DBUpdated;
begin
  PostMessage(s_MsgHandle, MSG_UPDATE, 0, StrToInt(IniAppGlobals.Identifier))
end;

//----------------------------------------------------------------------------//

procedure DBUpdatedServer;
begin
  // only for the server
  PostMessage(s_MsgHandle, MSG_UPDATE, 0, StrToInt(IniAppGlobals.Identifier))
end;

//----------------------------------------------------------------------------//

procedure ServerPollingCheckingDoubleInstance;
begin
  PostMessage(s_MsgHandle, MSG_UPDATE, 2, StrToInt(IniAppGlobals.Identifier))
end;

//----------------------------------------------------------------------------//
procedure DownloadRequest;
begin
  PostMessage(s_MsgHandle, MSG_UPDATE, 5, StrToInt(IniAppGlobals.Identifier))
end;

//----------------------------------------------------------------------------//

procedure JobMsgUpdate;
begin
  PostMessage(s_MsgHandle, MSG_UPDATE, 6, StrToInt(IniAppGlobals.Identifier))
end;

//----------------------------------------------------------------------------//

procedure SharedDataUpdate;
begin
  PostMessage(s_MsgHandle, MSG_UPDATE, 7, StrToInt(IniAppGlobals.Identifier))
end;

//----------------------------------------------------------------------------//

procedure DataBaseChange;
begin
  PostMessage(s_MsgHandle, MSG_UPDATE, 3, StrToInt(IniAppGlobals.Identifier))
end;

//----------------------------------------------------------------------------//

procedure DataBaseChangeWarp;
begin
  PostMessage(s_MsgHandle, MSG_UPDATE, 4, StrToInt(IniAppGlobals.Identifier))
end;

//----------------------------------------------------------------------------//

procedure DataBaseChangeWarpOnly;
begin
  PostMessage(s_MsgHandle, MSG_UPDATE, 8, StrToInt(IniAppGlobals.Identifier))
end;

end.
