unit FMInstall;

interface

uses
  UReShape, cxButtons, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,shellapi;

type
  TFInstall = class(TForm)
    rbInstall: TRadioButton;
    rbUninstall: TRadioButton;
    Button1: TcxButton;
    procedure FormCreate(Sender: TObject);
    procedure MakeInstallBat;
    procedure MakeUnInstallBat;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FInstall: TFInstall;

implementation

{$R *.dfm}

procedure TFInstall.MakeInstallBat;
var
  MyText: TStringlist;
begin
  MyText:= TStringlist.create;
  try
    MyText.Add('@echo off');
    MyText.Add(ExtractFilePath(Application.ExeName) +'MqmSrvLoadService.exe /Install');
    MyText.Add('net start MqmSrvLoad_Service');
    MyText.SaveToFile(ExtractFilePath(Application.ExeName) + '\Install Service.bat');
  finally
    MyText.Free
  end;
end;

procedure TFInstall.MakeUnInstallBat;
var
  MyText: TStringlist;
begin
  MyText:= TStringlist.create;
  try
    MyText.Add('@echo off');
    MyText.Add('taskkill /F /IM MqmSrvLoadService.exe');
    MyText.Add('taskkill /F /IM MqmSrvLoad.exe');
    MyText.Add(ExtractFilePath(Application.ExeName) +'MqmSrvLoadService.exe /Uninstall');
    MyText.SaveToFile(ExtractFilePath(Application.ExeName) + '\Uninstall Service.bat');
  finally
    MyText.Free
  end;
end;


procedure TFInstall.Button1Click(Sender: TObject);
begin
  if rbInstall.Checked then
  begin
    if Messagedlg('Do you want to Install Mqm Service?', mtConfirmation, [mbYes,mbNo],0) = mrYes then
    begin
      Shellexecute(Handle, 'runas',PWIDECHAR(ExtractFilePath(Application.ExeName)+'\Install Service.bat'), nil, nil, SW_SHOWNORMAL);
    end;
  end;

  if rbUnInstall.Checked then
  begin
    if Messagedlg('Do you want to Uninstall Mqm Service?', mtConfirmation, [mbYes,mbNo],0) = mrYes then
    begin
      Shellexecute(Handle, 'runas',PWIDECHAR(ExtractFilePath(Application.ExeName)+'\Uninstall Service.bat'), nil, nil, SW_SHOWNORMAL);

    end;
  end;
end;

procedure TFInstall.FormCreate(Sender: TObject);
begin
   MakeInstallBat;
 MakeUnInstallBat;
  ReShape(Self);
end;

end.
