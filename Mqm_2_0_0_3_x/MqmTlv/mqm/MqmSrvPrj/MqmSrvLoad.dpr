program MqmSrvLoad;

uses
  {$IFDEF EurekaLog}
  EMemLeaks,
  EResLeaks,
  EDebugExports,
  EDebugJCL,
  EFixSafeCallException,
  EMapWin32,
  EAppVCL,
  EDialogWinAPIMSClassic,
  EDialogWinAPIEurekaLogDetailed,
  EDialogWinAPIStepsToReproduce,
  ExceptionLog7,
  {$ENDIF EurekaLog}
  Vcl.Forms,
  Vcl.Dialogs,
  SysUtils,
  UGbaseCal in '..\..\lib\UGbaseCal.pas',
  UGconvert in '..\..\lib\UGconvert.pas',
  UGLicensing in '..\..\lib\UGLicensing.pas',
  UGprogCtrl in '..\..\lib\UGprogCtrl.pas',
  UGregItf in '..\..\lib\UGregItf.pas',
  FMsplash in '..\lib\FMsplash.pas' {SplashForm},
  UMCommon in '..\lib\UMCommon.pas',
  UMCompat in '..\lib\UMCompat.pas',
  UMCompatRules in '..\lib\UMCompatRules.pas',
  UMCompatSrv in '..\lib\UMCompatSrv.pas',
  UMglobal in '..\lib\UMglobal.pas',
  FMLoadCalendars in '..\MqmSrv\FMLoadCalendars.pas' {FDloadCalendars},
  FMSrvSettings in '..\MqmSrv\FMSrvSettings.pas' {FSrvSettings},
  UMload in '..\MqmSrv\UMload.pas',
  UMProdMemory in '..\MqmSrv\UMProdMemory.pas',
  UMProdSortList in '..\MqmSrv\UMProdSortList.pas',
  UMSaveLoad in '..\MqmSrv\UMSaveLoad.pas',
  UMSrvConfig in '..\MqmSrv\UMSrvConfig.pas',
  UMTransfer in '..\MqmSrv\UMTransfer.pas',
  UOpThread in '..\MqmSrv\UOpThread.pas',
  gnugettext in '..\Internationalization\gnugettext.pas',
  ukLibrary in '..\..\lib\ODBC\ukLibrary.pas',
  ukODBCConst in '..\..\lib\ODBC\ukODBCConst.pas',
  ukODBCTypes in '..\..\lib\ODBC\ukODBCTypes.pas',
  uODBC in '..\..\lib\ODBC\uODBC.pas',
  DMsrvPc in '..\db\DMsrvPc.pas' {DMib: TDataModule},
  UMDbFunc in '..\db\UMDbFunc.pas',
  UMStoredProc in '..\db\UMStoredProc.pas',
  UMTblDesc in '..\db\UMTblDesc.pas',
  UMProductionStruct in '..\MqmSrv\UMProductionStruct.pas',
  UMProductionStructService in '..\MqmSrv\UMProductionStructService.pas',
  Demand in '..\MqmSrv\Demand.pas',
  Progress in '..\MqmSrv\Progress.pas',
  UMConvert in '..\MqmSrv\UMConvert.pas',
  UMNotes in '..\MqmSrv\UMNotes.pas',
  UMTblDescNow in '..\db\UMTblDescNow.pas',
  UMASStoredProc in '..\MqmSrv\UMASStoredProc.pas',
  UMMainService in '..\MqmService\UMMainService.pas' {MqmSrvLoad_Service: TService},
  UMUploadToNOW in '..\MqmSrv\UMUploadToNOW.pas',
  FMDownloadInfoMsg in '..\MqmSrv\FMDownloadInfoMsg.pas' {DownloadInfoMsg},
  UMSave in '..\MqmSrv\UMSave.pas',
  UMSrvload in '..\MqmSrv\UMSrvload.pas' {Form1},
  UReShape in '..\MqmMain\UReShape.pas',
  UMConnectionThread in '..\MqmSrv\UMConnectionThread.pas',
  FireDAC.Phys.ODBCWrapper in '..\db\FireDAC.Phys.ODBCWrapper.pas',
  FireDAC.Phys.ODBCBase in '..\db\FireDAC.Phys.ODBCBase.pas',
  FireDAC.Phys.ODBCMeta in '..\db\FireDAC.Phys.ODBCMeta.pas',
  FMWaitCommunication in '..\forms\FMWaitCommunication.pas' {FWaitCommunication};

{$R *.res}

var
  errStr, errStrMQM, errStrMCM :     string;
  mainDbCodeMQM, mainDbCodeMCM : integer;
  cfgDbCodeMQM, cfgDbCodeMCM :  integer;
  lic:        TRecLicVers1;
  LicenseMQM, LicenseMCM : boolean;
  FilePath : string;
  I, CountInstant : Integer;
  AsService,Reset : boolean;
begin
  AsService := false;
  Reset := False;

 { for I := 1 to ParamCount do
  begin
    if (ParamStr(I) = 'reset') then
      Reset := True;
  end;   } // this refer to old ShellExecute (killing MqmSrvLoad when connection recover
  // ShellExecute(Handle,nil, PChar(Application.ExeName),PChar('reset'),nil,1);

  if not Reset then
  begin
    if RestoreIfRunning(Application.Handle, 1) then
      Exit;

    if CheckAllExistedRunningMqmSrvLoadWithSamePath then
    begin
      ShowMessage('MqmSrvLoad is already running !');
      Exit;
    end;
  end;

  if (ExtractFileName(Application.ExeName) <> 'MqmSrvLoad.exe') then
    Exit;

  for I := 1 to ParamCount do
  begin
    if (ParamStr(I) = 'Service') then
    begin
      AsService := true;
      if processExists('MqmSrvLoad.exe', CountInstant) then
      begin
        if CountInstant = 2 then
        begin
          ShowMessage('MqmSrvLoad is already running !');
          Exit;
        end;
      end;
      Break;
    end;

  end;

  if not AsService and ServiceRunning(nil,'MqmSrvLoad_Service') then
  begin
    FilePath := ExtractFilePath(Application.ExeName);
    if FilePath + 'MqmSrvLoadService.exe' = GetServiceExecutablePath('', 'MqmSrvLoad_Service') then
    begin
      ShowMessage('MqmSrvLoad is already running as service !');
      Exit;
    end;
  end;

  Application.Initialize;
  GlobLoadIniValues;
  UseLanguage(DBAppGlobals.Language);
  Application.Title := 'MQM Server Load';
  Application.CreateForm(TDMib, DMib);
  try
    HostDbConnect;
    LocalDbConnect(true);
    RegisterEvent(false);
    ArcDbConnect
  except
    ShowMessage('Connection is not defined ...');
  end;

  Application.CreateForm(TMqmSrvLoad_Service, MqmSrvLoad_Service);
  if IniAppGlobals.PreparationExeName <> '' then
    GlobLoadIniValuesNow;

  TSplashForm.Create(Application);
  SplashForm.Show;

  errStrMQM := '';
  errStrMCM := '';

  LicenseMQM := LoadLicenceMQMSrv(errStrMQM);
  LicenseMCM := LoadLicenceMCMSrv(errStrMCM);

  DBAppGlobals.License_MQM := LicenseMQM;
  DBAppGlobals.License_MCM := LicenseMCM;

  if not LicenseMQM and not LicenseMCM then
  begin
    ShowMessage('Licence is not installed ...');
    s_suicide := true
  end;

  if LicenseMQM and LicenseMCM then
    DBAppGlobals.License_BOTH_MQM_MCM := true
  else
    DBAppGlobals.License_BOTH_MQM_MCM := false;

  if not s_suicide then
  begin
    Application.CreateForm(TFSrvLoad, FSrvLoad);

  //  {$ifdef DEVMQMCM}

  //  {$else}
  //    SP_ASK_POLL;
  //  {$endif}

    Sleep(100);
  //  SP_CHECK_POLL;
  end;

  SplashForm.free;

  try
  Application.Run;
  except
  //  on E : EAccessViolation do

    raise
  end;

  try
    KillTask(ExtractFileName(Application.ExeName))
  except

  end;

end.





