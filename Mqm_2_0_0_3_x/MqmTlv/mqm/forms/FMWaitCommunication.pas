unit FMWaitCommunication;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

type
  WOperation = (W_CommunicationRepair);

  TFWaitCommunication = class(TForm)
    Panel1: TPanel;
    constructor CreateWaitForm(AOwner: TComponent; Op: WOperation);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure CloseForm(Sender: TObject);
    private
    { Private declarations }
    m_Op: WOperation;
    public
  end;

implementation

{$R *.dfm}

constructor TFWaitCommunication.CreateWaitForm(AOwner: TComponent; Op: WOperation);
begin
  inherited Create(AOwner);
  m_Op := Op;
end;

//----------------------------------------------------------------------------//

procedure TFWaitCommunication.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

//----------------------------------------------------------------------------//

procedure TFWaitCommunication.FormActivate(Sender: TObject);
begin
  Repaint;

  case m_op of
    W_CommunicationRepair : begin
                              Panel1.Caption := 'Connection repairing ...';
                            end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFWaitCommunication.CloseForm;
begin
  close
end;

end.
