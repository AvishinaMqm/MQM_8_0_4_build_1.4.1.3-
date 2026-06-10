unit UGprogCtrl;

interface

uses
  Windows,SysUtils, WinSvc, TlHelp32,PsAPI, System.Classes;

  function IsProgRunning(evtName: string): boolean;
  function IsProgRunningWake(evtName, mainWdwName: string): boolean;
  function IsAdmin: boolean;
  function RestoreIfRunning(const AppHandle : THandle; MaxInstances : integer = 1) : boolean;
  function ServiceRunning(sMachine, sService: PChar): Boolean;
  function GetServiceExecutablePath(strMachine: string; strServiceName: string): String;
  function processExists(exeFileName: string; var Count : integer): Boolean;
  Function CheckAllExistedRunningMqmSrvLoadWithSamePath : boolean;

implementation
uses
  UMglobal;

type
  PInstanceInfo = ^TInstanceInfo;
  TInstanceInfo = packed record
    PreviousHandle : THandle;
    RunCounter : integer;
  end;

var
  MappingHandle: THandle;
  InstanceInfo: PInstanceInfo;
  MappingName : string;
  RemoveMe : boolean = True;

// -------------------------------------------------------------------------- //

function GetPathFromPID( const PID : cardinal ) : string;
var
  hProcess : THandle;
  path :     array [0 .. MAX_PATH - 1] of char;
begin
  hProcess := OpenProcess( PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, false, PID );
  if hProcess <> 0
  then
    try
      if GetModuleFileNameEx( hProcess, 0, path, MAX_PATH ) = 0
      then
        RaiseLastOSError;
      Result := path;
    finally
      CloseHandle( hProcess )
    end
  else
    RaiseLastOSError;
end;

// -------------------------------------------------------------------------- //

Function CheckAllExistedRunningMqmSrvLoadWithSamePath : boolean;
var
  GotProcess: Boolean;
  tempHandle: tHandle;
  procE: tProcessEntry32;
  Path : string;
  processName, MqmSrvloadCurrentAppDir : string;
  ProcessId : Integer;
  Stringlist : TStringList;
begin
  MqmSrvloadCurrentAppDir := LocAppGlobals.AppDir + 'MqmSrvLoad.exe';
  Result := false;
  Stringlist := TStringList.Create;
  processName := 'MqmSrvLoad.exe';
  tempHandle:=CreateToolHelp32SnapShot(TH32CS_SNAPALL, 0);
  procE.dwSize:=SizeOf(procE);
  GotProcess:=Process32First(tempHandle, procE);

  if GotProcess and (procE.szExeFile <> processName) then
  begin
    repeat GotProcess := Process32Next(tempHandle, procE);

    if (procE.szExeFile = processName) then
    begin
      if not GotProcess then break;
      if GotProcess then
        ProcessId := procE.th32ProcessID;
      Path := GetPathFromPID(ProcessId);
      if Path = MqmSrvloadCurrentAppDir then
         Stringlist.Add(Path);
    end;
    until (not GotProcess);
  end;

  if Stringlist.Count > 1 then
     Result := true;

end;

// -------------------------------------------------------------------------- //

function processExists(exeFileName: string; var Count : integer): Boolean;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
  Path : string;
begin
  Count := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  Result := False;
  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) =
      UpperCase(ExeFileName))) then
    begin
      Result := True;
      Inc(Count)
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

// -------------------------------------------------------------------------- //

function IsProgRunning(evtName: string): boolean;
var
  hEvt: THandle;
  res:  DWORD;
begin
  hEvt := CreateEvent(nil, TRUE, TRUE, PChar(evtName));

  Result := true;
  res := WaitForSingleObject(hEvt, 0);

  if res = WAIT_OBJECT_0 then
  begin
    DeleteObject(hEvt);
    Result := false
  end
end;

// -------------------------------------------------------------------------- //

function IsProgRunningWake(evtName, mainWdwName: string): boolean;
var
  Win,
  ChildWin: hwnd;
  hEvt:     THandle;
  res:      integer;
begin
  hEvt := CreateEvent(nil, TRUE, TRUE, PChar(evtName));

  Result := false;
  res := WaitForSingleObject( hEvt, 0 );

  if res = WAIT_OBJECT_0 then
    ResetEvent(hEvt)
  else
  begin
    Result := true;
    Win := FindWindow(PChar(mainWdwName), nil);
    if IsIconic(Win) then ShowWindow(win, SW_SHOWMAXIMIZED);
    SetForegroundWindow(Win);
    ChildWin := GetLastActivePopup(Win);
    if Win <> ChildWin then
      BringWindowToTop(ChildWin) // A pop-up is active so bring it to the top too.
  end
end;

// -------------------------------------------------------------------------- //

function IsAdmin: boolean;
type
  pTokenGroups = ^TOKEN_GROUPS;
const
  SECURITY_BUILTIN_DOMAIN_RID: longint = $00000020;
  DOMAIN_ALIAS_RID_ADMINS:     longint = $00000220;
var
  hProcess,
  hAccessToken:       THandle;
  siaNtAuthority:     SID_IDENTIFIER_AUTHORITY;
  x:                  integer;
  InfoBuffer:         array [0..1024] of char;
  ptgGroups:          pTokenGroups;
  psidAdministrators: PSID;
  ReturnLength:       DWORD;
begin
  result := true;
  exit;      // mario

  hProcess := GetCurrentProcess();

  Result := false;
  if not OpenProcessToken(hProcess, TOKEN_READ, hAccessToken) then exit;

  if not GetTokenInformation(hAccessToken, TokenGroups, @InfoBuffer,
                             1024, ReturnLength) then exit;

  siaNtAuthority.value[0] := 0;
  siaNtAuthority.value[1] := 0;
  siaNtAuthority.value[2] := 0;
  siaNtAuthority.value[3] := 0;
  siaNtAuthority.value[4] := 0;
  siaNtAuthority.value[5] := 5;

  AllocateAndInitializeSid( siaNtAuthority, 2,
         SECURITY_BUILTIN_DOMAIN_RID,
         DOMAIN_ALIAS_RID_ADMINS,
         0, 0, 0, 0, 0, 0,
         psidAdministrators);

  ptgGroups := pTokenGroups(@InfoBuffer);
  for x := 0 to ptgGroups.GroupCount-1 do
    if EqualSid(psidAdministrators, ptgGroups.Groups[x].Sid) then
    begin
//      FreeSid(psidAdministrators);
      Result := true;
      exit
    end;

//  FreeSid(psidAdministrators)
end;

// -------------------------------------------------------------------------- //

function RestoreIfRunning(const AppHandle : THandle; MaxInstances : integer = 1) : boolean;
begin
  Result := True;
  RemoveMe := true;

  MappingName := StringReplace(
                   ParamStr(0),
                   '\',
                   '',
                   [rfReplaceAll, rfIgnoreCase]);

  {$ifdef 32Users}

  MappingHandle := CreateFileMapping($FFFFFFFF,
                                     nil,
                                     PAGE_READWRITE,
                                     0,
                                     SizeOf(TInstanceInfo),
                                     PChar(MappingName));

  {$endif}

  {$ifdef 64Users}

  MappingHandle := CreateFileMapping($FFFFFFFFFFFFFFFF,
                                     nil,
                                     PAGE_READWRITE,
                                     0,
                                     SizeOf(TInstanceInfo),
                                     PChar(MappingName));

  {$endif}

  if MappingHandle = 0 then
    RaiseLastOSError
  else
  begin
  if GetLastError <> ERROR_ALREADY_EXISTS then
    begin
      InstanceInfo := MapViewOfFile(MappingHandle,
                                    FILE_MAP_ALL_ACCESS,
                                    0,
                                    0,
                                    SizeOf(TInstanceInfo));

      InstanceInfo^.PreviousHandle := AppHandle;
      InstanceInfo^.RunCounter := 1;

      Result := False;
    end
   else //already runing
    begin
      MappingHandle := OpenFileMapping(
                                FILE_MAP_ALL_ACCESS,
                                False,
                                PChar(MappingName));
      if MappingHandle <> 0 then
      begin
        InstanceInfo := MapViewOfFile(MappingHandle,
                                      FILE_MAP_ALL_ACCESS,
                                      0,
                                      0,
                                      SizeOf(TInstanceInfo));

        if InstanceInfo^.RunCounter >= MaxInstances then
        begin
          RemoveMe := False;

          if IsIconic(InstanceInfo^.PreviousHandle) then
            ShowWindow(InstanceInfo^.PreviousHandle, SW_RESTORE);
          SetForegroundWindow(InstanceInfo^.PreviousHandle);
        end
        else
        begin
          InstanceInfo^.PreviousHandle := AppHandle;
          InstanceInfo^.RunCounter := 1 + InstanceInfo^.RunCounter;

          Result := False;
        end
      end;
    end;
  end;
end; (*RestoreIfRunning*)


function ServiceGetStatus(sMachine, sService: PChar): DWORD;
  {******************************************}
  {*** Parameters: ***}
  {*** sService: specifies the name of the service to open
  {*** sMachine: specifies the name of the target computer
  {*** ***}
  {*** Return Values: ***}
  {*** -1 = Error opening service ***}
  {*** 1 = SERVICE_STOPPED ***}
  {*** 2 = SERVICE_START_PENDING ***}
  {*** 3 = SERVICE_STOP_PENDING ***}
  {*** 4 = SERVICE_RUNNING ***}
  {*** 5 = SERVICE_CONTINUE_PENDING ***}
  {*** 6 = SERVICE_PAUSE_PENDING ***}
  {*** 7 = SERVICE_PAUSED ***}
  {******************************************}
var
  SCManHandle, SvcHandle: SC_Handle;
  SS: TServiceStatus;
  dwStat: DWORD;
begin
  dwStat := 0;
  // Open service manager handle.
  SCManHandle := OpenSCManager(sMachine, nil, SC_MANAGER_CONNECT);
  if (SCManHandle > 0) then
  begin
    SvcHandle := OpenService(SCManHandle, sService, SERVICE_QUERY_STATUS);
    // if Service installed
    if (SvcHandle > 0) then
    begin
      // SS structure holds the service status (TServiceStatus);
      if (QueryServiceStatus(SvcHandle, SS)) then
        dwStat := ss.dwCurrentState;
      CloseServiceHandle(SvcHandle);
    end;
    CloseServiceHandle(SCManHandle);
  end;
  Result := dwStat;
end;

function ServiceRunning(sMachine, sService: PChar): Boolean;
begin
  Result := SERVICE_RUNNING = ServiceGetStatus(sMachine, sService);
end;

function GetServiceExecutablePath(strMachine: string; strServiceName: string): String;
var
  hSCManager,hSCService: SC_Handle;
  lpServiceConfig: LPQUERY_SERVICE_CONFIG;
  nSize, nBytesNeeded: DWord;
begin
  Result := '';
  hSCManager := OpenSCManager(PChar(strMachine), nil, SC_MANAGER_CONNECT);
  if (hSCManager > 0) then
  begin
    hSCService := OpenService(hSCManager, PChar(strServiceName), SERVICE_QUERY_CONFIG);
    if (hSCService > 0) then
    begin
      QueryServiceConfig(hSCService, nil, 0, nSize);
      lpServiceConfig := AllocMem(nSize);
      try
        if not QueryServiceConfig(
          hSCService, lpServiceConfig, nSize, nBytesNeeded) Then Exit;
          Result := lpServiceConfig^.lpBinaryPathName;
      finally
        Dispose(lpServiceConfig);
      end;
      CloseServiceHandle(hSCService);
    end;
  end;
end;


initialization


finalization
  //remove this instance
  if RemoveMe then
  begin
    MappingHandle := OpenFileMapping(
                        FILE_MAP_ALL_ACCESS,
                        False,
                        PChar(MappingName));
    if MappingHandle <> 0 then
    begin
      InstanceInfo := MapViewOfFile(MappingHandle,
                                  FILE_MAP_ALL_ACCESS,
                                  0,
                                  0,
                                  SizeOf(TInstanceInfo));

      InstanceInfo^.RunCounter := -1 + InstanceInfo^.RunCounter;
    end
   // else
   //   RaiseLastOSError;
  end;

  if Assigned(InstanceInfo) then UnmapViewOfFile(InstanceInfo);
  if MappingHandle <> 0 then CloseHandle(MappingHandle);

end.












