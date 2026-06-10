unit FMAbout;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, jpeg, UReShape;

type
  TFAbout = class(TForm)
    GroupBox1: TGroupBox;
    AboutIssuer: TLabel;
    LblAboutIssuer: TLabel;
    AboutReleaseDate: TLabel;
    LblAboutExpiryDate: TLabel;
    LbLAboutReleaseDate: TLabel;
    AboutExpiryDate: TLabel;
    AboutLockNumber: TLabel;
    LblAboutLockNum: TLabel;
    AboutMaxSupp: TLabel;
    LblAboutMaxSupp: TLabel;
    AboutMaxCount: TLabel;
    LblAboutMaxCount: TLabel;
    AboutLoad: TLabel;
    LblAboutLoad: TLabel;
    AboutInstType: TLabel;
    LblAboutInstType: TLabel;
    GroupBox2: TGroupBox;
    LbLAboutMqm: TLabel;
    LbLAboutRelease: TLabel;
    LbLAboutVersion: TLabel;
    LbLAboutCopyright: TLabel;
    LbLAboutWww: TLabel;
    LbLAboutEmail: TLabel;
    LbLAboutLicence: TLabel;
    LbLAboutCustomer: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    FMAboutImage: TImage;
    BtnOk: TcxButton;
    procedure FMAboutButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FAbout: TFAbout;

implementation

uses
  UMglobal,
  UGLicensing,
  DMsrvPC,
  gnugettext;

{$R *.dfm}

//----------------------------------------------------------------------------//

procedure TFAbout.FMAboutButtonClick(Sender: TObject);
begin
  Close;
end;

//----------------------------------------------------------------------------//

procedure TFAbout.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FAbout := nil;
end;

procedure TFAbout.FormCreate(Sender: TObject);
var
  lic: TRecLicVers1;
  errStr: string;
begin
  TranslateComponent (self);
  Fabout := Self;
  if DBAppGlobals.MCM_App then
    LbLAboutMqm.Caption := 'Machine Capacity Management'
  else
    LbLAboutMqm.Caption := 'Machine Queue Management';

{$ifdef VELA}
  FMAboutImage.Picture.LoadFromFile((LocAppGlobals.AppDir + LocAppGlobals.ImgDir + '\Vela3.bmp'));
  FMAboutImage.Height := 180;
  LbLAboutCopyright.Visible := false;
  LbLAboutWww.Visible := false;
  LbLAboutEmail.Visible := false;
{$endif}

  LbLAboutVersion.Caption := DBAppGlobals.MQMVersion;
  LbLAboutCustomer.Caption := DBAppGlobals.Customer;

  if DecodeLicVers1(lic, s_licBytes, errStr) then
  begin
    LblAboutIssuer.Caption := lic.issuer;
    if Lic.releaseDate > 0 then
      LblAboutReleaseDate.Caption := DateTimeToStr(lic.releaseDate)
    else
      LblAboutReleasedate.Caption := '-';
    LblAboutLockNum.Caption := IntToSTR(lic.lockNum);
    case lic.instType of
      INST_CUST_DEMO: LblAboutInstType.Caption := _('Jobs save disabled');
           INST_DEMO: LblAboutInstType.Caption := _('New jobs save disabled');
       INST_CUSTOMER: LblAboutInstType.Caption := _('No limits');
    end;
    LblAboutMaxSupp.Caption := IntToStr(lic.maxSupp);
    LblAboutMaxCount.Caption := IntToStr(lic.maxCont);
    if lic.expirydate > 0 then
      LblAboutExpiryDate.Caption := DateTimeToStr(lic.expiryDate)
    else
      LblAboutExpiryDate.Caption := '-';
 //   LblAboutConfig.Caption := IntToStr(lic.configEnabled);
 //   if lic.srvLoadEnabled > 0 then
 //     LblAboutLoad.Caption := _('Disabled')
 //   else
      LblAboutLoad.Caption := _('Enabled');
//  DataBase Informations
//    if SrvIsOn(Main_DB) then
//      LblAboutStSrv.Caption := _('running')
//    else
//      LblAboutStSrv.Caption := _('not found');

{    LblAboutStDb.Caption := GetMqmDbName(Main_DB);
    if SrvFoundDb(Main_DB) then
      LblAboutStDb.Color := clInfoBk
    else
    begin
      LblAboutStDb.Color := clRed;
    end; }

  end else
  begin
    LblAboutIssuer.Caption := _('Unknown');
    LblAboutReleaseDate.Caption := _('Unknown');
    LblAboutLockNum.Caption := _('Unknown');
    LblAboutInstType.Caption := _('Unknown');;
    LblAboutMaxSupp.Caption := _('Unknown');
    LblAboutMaxCount.Caption := _('Unknown');
    LblAboutExpiryDate.Caption := _('Unknown');
    LblAboutLoad.Caption := _('Unknown');
  end;

  ReShape(Self);
end;

//----------------------------------------------------------------------------//

procedure TFAbout.FormDestroy(Sender: TObject);
begin
  //FAbout.Free;
  FAbout := nil;
end;
//----------------------------------------------------------------------------//
end.

