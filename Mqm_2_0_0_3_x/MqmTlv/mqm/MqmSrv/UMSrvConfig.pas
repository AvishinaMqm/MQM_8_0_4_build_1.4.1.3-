unit UMSrvConfig;

interface

uses
  UMCommon;

type
  TDOloadMode = (TDOL_none, TDOL_manual, TDOL_auto, TDOL_onReq);
  TDOsaveMode = (TDOS_none, TDOS_manual, TDOS_auto, TDOS_onReq);
  TDTypeMode  = (TD_AllFiles  , TD_ProdAndUpload , TD_OnlyArchivs, TD_OnlyProd , TD_OnlyProg, TD_OnlyUpload,
                 TD_UploadWarp, TD_DownloadUploadToNow, TD_DownLoadAfterUpload);
  TDateTimeFormat = (Frm_As400, Frm_TDateTimeExceptControl, Frm_TDateTime, Frm_DB2);
  TDRequestedType = (TD_Manual , TD_Client , TD_Scheduled);

  procedure SetTypeMode(TypeMode : TDTypeMode);
  function  GetTypeMode : TDTypeMode;
  procedure SetOldType(TypeMode : TDTypeMode);
  function  GetOldType : TDTypeMode;
  function  GetLoopMqmCG : boolean;
  procedure SetLoopMqmCG(IncludeCG : boolean);
  function  GetOldLoopMqmCG : boolean;
  procedure SetOldLoopMqmCG(IncludeCG : boolean);
  function  GetAutoPassword : boolean;
  procedure SetAutoPassword(Auto : boolean);
  function  GetDateTimeFormat : TDateTimeFormat;
  procedure SetDateTimeFormat(DateTimeFormat  : TDateTimeFormat);
  procedure SetSchedChgReqFlag(FlagType : boolean);
  function  GetSchedChgReqFlag : boolean;
  procedure SetTypeChgFlag(FlagType : boolean);
  function  GetTypeChgFlag : boolean;
  procedure SetTypeChg(TypeCng : TDTypeMode);
  function  GetTypeChg : TDTypeMode;
  procedure SetTypeRequest(TypeRequest : TDRequestedType);
  function  GetTypeRequest : TDRequestedType;
  procedure SetDndArchiveHostName(DndArchiveName : TDndArchiveName);
  function  GetDndArchiveHostName : TDndArchiveName;
  procedure SetDndArchiveLocalName(DndArchiveName : TDndArchiveName);
  function  GetDndArchiveLocalName : TDndArchiveName;
  procedure SetMaterialSchedule_Warp_Send_Client(OperateEvent : boolean);
  function  GetMaterialSchedule_Warp_Send_Client : boolean;
  procedure SetBalanceHeader_Changed_Send_Client(OperateEvent : boolean);
  function  GetBalanceHeader_Changed_Send_Client : boolean;

implementation

var
  s_TypMode  : TDTypeMode;
  S_OldType  : TDTypeMode;
  S_LoopMqmCG : boolean;
  S_OldLoopMqmCG : boolean;
  S_AutoPassword : boolean;
  S_Format_DateTime : TDateTimeFormat;
  S_SchedChgReq : boolean;
  S_ChgTypeModeFlag : boolean;
  S_ChgTypeMode : TDTypeMode;
  S_RequestedType : TDRequestedType;
  S_DndArchiveHostName : TDndArchiveName;
  S_DndArchiveLocalName : TDndArchiveName;
  S_MaterialSchedule_Warp_Send_Client : boolean;
  S_BalanceHeader_Changed_Send_Client : boolean;

//----------------------------------------------------------------------------//

procedure SetSchedChgReqFlag(FlagType : boolean);
begin
  S_SchedChgReq := FlagType
end;

//----------------------------------------------------------------------------//

function GetSchedChgReqFlag : boolean;
begin
  Result := S_SchedChgReq;
end;

//----------------------------------------------------------------------------//

procedure SetTypeChgFlag(FlagType : boolean);
begin
  S_ChgTypeModeFlag := FlagType;
end;

//----------------------------------------------------------------------------//

function GetTypeChgFlag : boolean;
begin
  Result := S_ChgTypeModeFlag;
end;

//----------------------------------------------------------------------------//

procedure SetTypeChg(TypeCng : TDTypeMode);
begin
  S_ChgTypeMode := TypeCng;
end;

//----------------------------------------------------------------------------//

function GetTypeChg : TDTypeMode;
begin
  Result := S_ChgTypeMode;
end;

//----------------------------------------------------------------------------//

procedure SetTypeMode(TypeMode : TDTypeMode);
begin
  s_TypMode := TypeMode;
end;

//----------------------------------------------------------------------------//

function GetTypeMode : TDTypeMode;
begin
  Result := s_TypMode
end;

//----------------------------------------------------------------------------//

procedure SetOldType(TypeMode : TDTypeMode);
begin
  S_OldType := TypeMode;
end;

//----------------------------------------------------------------------------//

function GetOldType : TDTypeMode;
begin
  Result := S_OldType;
end;

//----------------------------------------------------------------------------//

function GetLoopMqmCG : boolean;
begin
  Result := S_LoopMqmCG
end;

//----------------------------------------------------------------------------//

procedure SetLoopMqmCG(IncludeCG : boolean);
begin
  S_LoopMqmCG := IncludeCG;
end;

//----------------------------------------------------------------------------//

function GetOldLoopMqmCG : boolean;
begin
  Result := S_OldLoopMqmCG
end;

//----------------------------------------------------------------------------//

procedure SetOldLoopMqmCG(IncludeCG : boolean);
begin
  S_OldLoopMqmCG := IncludeCG;
end;

//----------------------------------------------------------------------------//

function GetAutoPassword : boolean;
begin
  Result := S_AutoPassword
end;

//----------------------------------------------------------------------------//

procedure SetAutoPassword(Auto : boolean);
begin
  S_AutoPassword := Auto;
end;

//----------------------------------------------------------------------------//

function GetDateTimeFormat : TDateTimeFormat;
begin
  Result := S_Format_DateTime
end;

//----------------------------------------------------------------------------//

procedure SetDateTimeFormat(DateTimeFormat  : TDateTimeFormat);
begin
  S_Format_DateTime := DateTimeFormat;
end;

//----------------------------------------------------------------------------//

procedure SetTypeRequest(TypeRequest : TDRequestedType);
begin
  S_RequestedType := TypeRequest
end;

//----------------------------------------------------------------------------//

function GetTypeRequest : TDRequestedType;
begin
  Result := S_RequestedType
end;

//----------------------------------------------------------------------------//

procedure SetDndArchiveHostName(DndArchiveName : TDndArchiveName);
begin
  S_DndArchiveHostName := DndArchiveName
end;

//----------------------------------------------------------------------------//

function GetDndArchiveHostName : TDndArchiveName;
begin
  Result := S_DndArchiveHostName
end;

//----------------------------------------------------------------------------//

procedure SetDndArchiveLocalName(DndArchiveName : TDndArchiveName);
begin
  S_DndArchiveLocalName := DndArchiveName
end;

//----------------------------------------------------------------------------//

function GetDndArchivelocalName : TDndArchiveName;
begin
  Result := S_DndArchiveLocalName
end;

//----------------------------------------------------------------------------//

procedure SetMaterialSchedule_Warp_Send_Client(OperateEvent : boolean);
begin
  S_MaterialSchedule_Warp_Send_Client := OperateEvent;
end;

//----------------------------------------------------------------------------//

function GetMaterialSchedule_Warp_Send_Client : boolean;
begin
  Result := S_MaterialSchedule_Warp_Send_Client
end;

//----------------------------------------------------------------------------//

procedure SetBalanceHeader_Changed_Send_Client(OperateEvent : boolean);
begin
  S_BalanceHeader_Changed_Send_Client := OperateEvent;
end;

//----------------------------------------------------------------------------//

function GetBalanceHeader_Changed_Send_Client : boolean;
begin
  Result := S_BalanceHeader_Changed_Send_Client
end;

//----------------------------------------------------------------------------//

end.





