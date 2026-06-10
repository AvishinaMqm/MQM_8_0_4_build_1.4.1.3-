unit UMMainService;

interface

uses
  Winapi.Windows, Winapi.Messages, System.IniFiles, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.SvcMgr, Vcl.Dialogs, Vcl.Forms,
  Vcl.ExtCtrls;

type
  TMqmSrvLoad_Service = class(TService)
    procedure ServiceExecute(Sender: TService);
  private
    { Private declarations }
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  MqmSrvLoad_Service: TMqmSrvLoad_Service;
  s_DirPrg : string;

implementation

uses ShellApi;

{$R *.DFM}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  MqmSrvLoad_Service.Controller(CtrlCode);
end;

procedure ReadStrFromIniFile(const sez, tag: string; var str: string);
var
  Ini: TIniFile;
begin
 // Ini := TIniFile.Create(s_DirPrg + IniMqmName);
  str := Ini.ReadString(sez,tag,str);
  Ini.Free;
end;

procedure callExternalApplication(applicationFullPath: String; parameter: String);
var
  procInfo: TProcessInformation;
  startupInfo: TStartupInfo;
begin
  // add null char and a blank char between application and its parameter
  parameter := '\0' + ' ' + parameter;

  // set zero (null) value for the ProcessInformation and StartupInfo
  FillChar(procInfo, sizeof(TProcessInformation), 0);
  FillChar(startupInfo, sizeof(TStartupInfo), 0);
  startupInfo.cb := sizeof(TStartupInfo);

  // try to create the application
  // if created then wait till it closes.
  if ( CreateProcess(pChar(applicationFullPath), pChar(parameter), nil,
                     nil, false, NORMAL_PRIORITY_CLASS, nil, nil,
                     startupInfo, procInfo) <> False ) then
  begin
    try
      // wait till it closes
      WaitForSingleObject(procInfo.hProcess, INFINITE);

      // remove handle
      CloseHandle(procInfo.hProcess);
    except
    on E : EAccessViolation do
      begin
        showmessage('Access violation found');
      end;
    end;

  end
  else
    // error on creating the process
    ShowMessage('Could not create the process of calling to MqmSrvLoad program');
end;

function TMqmSrvLoad_Service.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;


procedure TMqmSrvLoad_Service.ServiceExecute(Sender: TService);
begin
//  Showmessage(s_DirPrg + 'MqmSrvLoad.exe');
  callExternalApplication(s_DirPrg + 'MqmSrvLoad.exe', 'Service');
end;

initialization
  s_DirPrg := ExtractFilePath(Application.ExeName);

end.
