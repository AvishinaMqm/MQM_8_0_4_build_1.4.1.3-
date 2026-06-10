unit UMConnectionClientThread;

interface

uses Classes, Messages, DMsrvPc, Graphics, Forms, SysUtils, StdCtrls, WIndows
  , Controls, Dialogs, ShellAPI, FireDAC.Stan.Intf, FireDAC.Comp.Client;

type
  TClientConnectionThread = class(TThread)
    constructor CreateChecking;
    procedure Execute; override;
  end;

implementation

uses FMMainPlan, UMStoredProc;

{ TOperativeThread }

constructor TClientConnectionThread.CreateChecking;
begin
  inherited Create(true);
  FreeOnTerminate := true;
end;

procedure TClientConnectionThread.Execute;
var
  MQMPlan : TFMQMPlan;
begin
  MQMPlan := GetPlanView;
  GetPlanView.TimerConnectionCheck.Enabled := false;

  if assigned(DMib) then
  begin
    try
      DMib.m_MainDB.ping;
    except

    end;
  end;

  MQMPlan.m_ClientConnected := DMib.m_MainDB.Connected;
  GetPlanView.TimerConnectionCheck.Enabled := True;

  Synchronize(
    procedure
    begin

    end);


  Terminate;
end;


end.
