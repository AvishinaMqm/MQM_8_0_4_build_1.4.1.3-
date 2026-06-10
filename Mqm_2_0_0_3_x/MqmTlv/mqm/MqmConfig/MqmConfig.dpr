program MqmConfig;

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
  Vcl.Controls,
  SysUtils,
  gnugettext in '..\Internationalization\gnugettext.pas',
  Forms,
  Dialogs,
  FMcfgMain in 'FMcfgMain.pas' {MainForm},
  FMcreateTables in 'FMcreateTables.pas' {CreateTables},
  DMsrvPc in '..\db\DMsrvPc.pas' {DMib: TDataModule},
  UMTblDesc in '..\db\UMTblDesc.pas',
  UMglobal in '..\lib\UMglobal.pas',
  UGprogCtrl in '..\..\lib\UGprogCtrl.pas',
  UGregItf in '..\..\lib\UGregItf.pas',
  UMCompat in '..\lib\UMCompat.pas',
  UMCompatSrv in '..\lib\UMCompatSrv.pas',
  UMCompatRules in '..\lib\UMCompatRules.pas',
  UMStoredProc in '..\db\UMStoredProc.pas',
  UMDbFunc in '..\db\UMDbFunc.pas',
  FMViewLic in 'FMViewLic.pas' {FViewLic},
  UGLicensing in '..\..\lib\UGLicensing.pas',
  FMsplash in '..\lib\FMsplash.pas' {SplashForm},
  UMCommon in '..\lib\UMCommon.pas',
  FMBackUpRestore in 'FMBackUpRestore.pas' {BackUpRestore},
  FMSelectResetStation in 'FMSelectResetStation.pas' {SelectResetstation},
  fMConnection in '..\db\fMConnection.pas' {FConnection},
  uODBC in '..\db\uODBC.pas',
  UMSrvConfig in '..\MqmSrv\UMSrvConfig.pas',
  FMPassword in 'FMPassword.pas' {FMPassCfg},
  UReShape in '..\MqmMain\UReShape.pas',
  FMIni in 'FMIni.pas' {FIni},
  FMMiForceMqmScheduleDetailsToMCM in 'FMMiForceMqmScheduleDetailsToMCM.pas' {ForceMqmScheduleDetailsToMCM},
  FMWaitCommunication in '..\forms\FMWaitCommunication.pas' {FWaitCommunication},
  FMSQL in 'FMSQL.pas' {FSql};

{$R *.RES}

var
  errStr:            string;
  cfgCode, mainCode: integer;
  DefinedConnection : boolean;
begin
  s_suicide := false;
  Application.Initialize;
  GlobLoadIniValues;
  UseLanguage(DBAppGlobals.Language);
  Application.Title := 'MQM Config';

  Application.CreateForm(TDMib, DMib);
  try
    LocalDbConnect(false);
  except
    on E: Exception do
    begin
      ShowMessage('Connection is not defined ...' + E.Message);
      Application.CreateForm(TMainForm, MainForm);
      Application.Run;
      Exit;
    end;
  end;

  Application.CreateForm(TMainForm, MainForm);

  Application.Run;

  if s_suicide then
  begin
    SplashForm.free;
   // if errStr <> '' then ShowMessage(errStr)
  end

end.




