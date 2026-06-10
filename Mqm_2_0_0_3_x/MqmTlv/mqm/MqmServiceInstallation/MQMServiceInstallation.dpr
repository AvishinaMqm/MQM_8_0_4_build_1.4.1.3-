program MQMServiceInstallation;

uses
  Vcl.Forms,
  FMInstall in 'FMInstall.pas' {FInstall};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFInstall, FInstall);
  Application.Run;
end.
