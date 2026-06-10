unit FMPassword;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TFMPassCfg = class(TForm)
    Bevel1: TBevel;
    BtnApply: TButton;
    EdPswd: TEdit;
    procedure BtnApplyClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function GetPassword: boolean;


//var
//  FMPassCfg: TFMPassCfg;

implementation

resourcestring
  STR_PSW_LOGERR = 'wrong password';
  STR_PSW_APPLY  = 'Apply';

{$R *.dfm}

// -------------------------------------------------------------------------- //

function GetPassword: boolean;
var
  PassCfg: TFMPassCfg;
begin
  PassCfg := TFMPassCfg.Create(Application);
  if PassCfg.ShowModal = idOk then
    Result := true
  else
    Result := false
end;

// -------------------------------------------------------------------------- //

procedure TFMPassCfg.BtnApplyClick(Sender: TObject);
begin
  if (EdPswd.Text <> trim('MQMCM_ADMIN')) then
  begin
    ModalResult := mrAbort
  end
  else
    ModalResult := mrOk
end;

// -------------------------------------------------------------------------- //

procedure TFMPassCfg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Action := caFree
end;

// -------------------------------------------------------------------------- //

procedure TFMPassCfg.FormCreate(Sender: TObject);
begin
  BtnApply.Caption := STR_PSW_APPLY;
  BtnApply.Enabled := true;
end;

end.
