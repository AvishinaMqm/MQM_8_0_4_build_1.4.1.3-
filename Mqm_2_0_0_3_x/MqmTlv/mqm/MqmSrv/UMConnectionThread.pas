unit UMConnectionThread;

interface

uses Classes, Messages, DMsrvPc, Graphics, Forms, SysUtils, StdCtrls, WIndows
  , Controls, Dialogs, UOPThread, ShellAPI, FireDAC.Stan.Intf, FireDAC.Comp.Client;

type
  TChekingThread = class(TThread)
    constructor CreateChecking;
    procedure Execute; override;
  Public
   // Connected : Boolean;
  end;

implementation

uses UMSrvLoad, UMStoredProc;

{ TOperativeThread }

constructor TChekingThread.CreateChecking;
begin
  inherited Create(true);
  FreeOnTerminate := true;
end;

procedure TChekingThread.Execute;
begin

  FSrvLoad.fConnected := true;
  FSrvLoad.Timer1.Enabled := False;

  if assigned(DMib) then
  begin
    try
      DMib.m_DBHost.ping;
    except

    end;
  end;

  FSrvLoad.fConnected := DMib.m_DBHost.Connected;

  FSrvLoad.Timer1.Enabled := True;

  Synchronize(
    procedure
    begin
        if not FSrvLoad.fConnected then
        begin
          FSrvLoad.StatusBar1.Panels[0].Text := 'Database status : Disconnected';
          FSrvLoad.IService.Enabled := False;
          FSrvLoad.Timer1.Interval := 10000; // 1 minute/6 to start check connection
        end else
        begin
          FSrvLoad.StatusBar1.Panels[0].Text := 'Database status : Connected';
          FSrvLoad.IService.Enabled := True;
          FSrvLoad.IConfig.Enabled := True;
          FSrvLoad.info1.Enabled := True;
          FSrvLoad.IExit.Enabled := True
        end;
    end);


  Terminate;
end;


end.
