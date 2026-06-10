program MqmLic;

uses
 // ExceptionLog,
  Forms,
  FMLicMain in 'FMLicMain.pas' {FLicHdl},
  FMlock in 'FMlock.pas' {FLock},
  FMCreateLic in 'FMCreateLic.pas' {FCreateLic},
  UGLicensing in '..\..\lib\UGLicensing.pas',
  gnugettext in '..\Internationalization\gnugettext.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFLicHdl, FLicHdl);
  Application.Run;
end.
