unit FMCreateLic;

interface

uses
  UReShape, cxButtons, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, gnugettext;

type
  TFCreateLic = class(TForm)
    BtnOk: TBitBtn;
    EdIssuer: TEdit;
    LblIssuer: TLabel;
    LblCust: TLabel;
    EdCustomer: TEdit;
    LblReleDate: TLabel;
    LblLock: TLabel;
    EdLock: TEdit;
    DTPrele: TDateTimePicker;
    LblInst: TLabel;
    CBinst: TComboBox;
    LblMax: TLabel;
    LblMaxCont: TLabel;
    EdMaxSupp: TEdit;
    EdMaxCont: TEdit;
    SaveLic: TSaveDialog;
    ODkey: TOpenDialog;
    BtnImpLock: TcxButton;
    LblExpDate: TLabel;
    LblConfig: TLabel;
    EdCfgLev: TEdit;
    LblMqmMcm: TLabel;
    DTPexpDate: TDateTimePicker;
    ChkExpDate: TCheckBox;
    CBMqmMcm: TComboBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOkClick(Sender: TObject);
    procedure BtnImpLockClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  procedure CreateLicence(AOwner: TComponent; Issuer : string);

implementation

{$R *.DFM}

uses
  UReShape, UGLicensing;

// -------------------------------------------------------------------------- //

procedure CreateLicence(AOwner: TComponent; Issuer : string);
var
  FCreateLic: TFCreateLic;
begin
  FCreateLic := TFCreateLic.Create(AOwner);
  FCreateLic.EdIssuer.Text := Issuer;
  FCreateLic.ShowModal;
  FCreateLic.Free
end;

// -------------------------------------------------------------------------- //

procedure TFCreateLic.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree
end;

// -------------------------------------------------------------------------- //

procedure TFCreateLic.BtnOkClick(Sender: TObject);
var
  lic:    TRecLicVers1;
  arr:    TLicMemory;
  errStr: string;
begin
  with lic do
  begin
    licType     := 1;
    issuer      := EdIssuer.Text;
    customer    := EdCustomer.Text;
    releaseDate := DTPrele.Date;
    lockNum     := StrToInt(EdLock.Text);

    case CBinst.ItemIndex of
    0: instType := INST_DEMO;
    1: instType := INST_CUST_DEMO;
    2: instType := INST_CUSTOMER;
    end;

    maxSupp := StrToInt(EdMaxSupp.Text);
    maxCont := StrToInt(EdMaxCont.Text);

    if ChkExpDate.Checked then
      expiryDate := DTPexpDate.Date
    else
      expiryDate := 0;

    configEnabled := StrToInt(EdCfgLev.Text);

    case CBMqmMcm.ItemIndex of
      0 : begin
            MQMORMCM := 2;  // mqm
            SaveLic.FileName := 'MQMlic';
          end;
      1 : begin
            MQMORMCM := 3;  // mcm
            SaveLic.FileName := 'MCMlic';
          end;
    end;

  end;

  if SaveLic.Execute then
  begin
    if not EncodeLicVers1(lic, arr, errStr) then
      ShowMessage(errStr)
    else
      SaveLicToFile(SaveLic.FileName, arr)
  end
end;

// -------------------------------------------------------------------------- //

procedure TFCreateLic.BtnImpLockClick(Sender: TObject);
var
  arr:    TLicMemory;
  lic:    TRecLicVers1;
  strErr: string;
begin
  if ODkey.Execute then
    if not LoadLicFromFile(ODkey.FileName, arr) then
      ShowMessage(_('Invalid file'))
    else if not DecodeLicVers1(lic, arr, strErr) then
      ShowMessage(strErr)
    else if lic.licType <> 0 then
      ShowMessage(_('Only lock files allowed'))
    else
    begin
      EdCustomer.Text := lic.customer;
      EdLock.Text     := IntToStr(lic.lockNum)
    end
end;

// -------------------------------------------------------------------------- //
procedure TFCreateLic.FormCreate(Sender: TObject);
begin
  DTPexpDate.Date := now;
  DTPrele.Date    := now;
  ReShape(Self);
end;

end.
