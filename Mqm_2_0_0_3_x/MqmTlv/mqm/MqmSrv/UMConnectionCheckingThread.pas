unit UMConnectionCheckingThread;

interface

uses Classes, Messages, DMsrvPc, Graphics, Forms, SysUtils, StdCtrls, WIndows
     ,Controls, Dialogs, UOPThread, ShellAPI, FireDAC.Stan.Intf, FireDAC.Comp.Client;
type
  TConnectionCheckingThread = class(TThread)
    constructor CreateConnectionChecking;
    procedure Execute; override;
  Public
   // Connected : Boolean;
  end;

implementation

uses UMSrvLoad, UMGlobal;

{ TOperativeThread }

constructor TConnectionCheckingThread.CreateConnectionChecking;
begin
  inherited Create(true);
  FreeOnTerminate := true;
end;

procedure TConnectionCheckingThread.Execute;
begin

  FSrvLoad.TimerConnectionCheck.Enabled := True;

  Synchronize(
  procedure
  begin
    if assigned(DMib) then
    begin
      try
      //  if not DMib.m_DBHost.Connected then
        if not DMib.m_DBHost.ping then
        begin
          IniAppGlobals.ConnectionEstablished := false;
          FSrvLoad.TimerConnectionCheck.Enabled := false;
        end;

      except
        FSrvLoad.Timer1Timer(self);
        FSrvLoad.TimerConnectionCheck.Enabled := false;
        IniAppGlobals.ConnectionEstablished   := false;
      end;
    end;
  end);

  Terminate;

end;

end.
