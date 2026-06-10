unit fMConnection;

interface

uses
  UReShape, cxButtons, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Buttons, ExtCtrls, UMGlobal, gnugettext, cxGraphics,
  dxUIAClasses, cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus;

const
  NO_ALLIAS_EXIST = 'Please select alias for ODBC connection';

type
  TFConnection = class(TForm)
    PanBtn: TPanel;
    BtnOk: TBitBtn;
    BtnCanc: TBitBtn;
    Panel1: TPanel;
    Panel4: TPanel;
    RadioGroupHostDatabase: TRadioGroup;
    RadioGroupLocalConnection: TRadioGroup;
    BtnCheckConnection: TcxButton;
    BtnCheckConnectionLocal: TcxButton;
    ServrIBname: TEdit;
    StaticTextIBServerIp: TStaticText;
    EditPathIP2: TEdit;
    EditPathIP1: TEdit;
    Panel5: TPanel;
    GBDb2ConnectionHost: TGroupBox;
    StaticText11: TStaticText;
    StaticText12: TStaticText;
    EditNOWDB2DataSourceHost: TEdit;
    EditNOWDB2SrvIPHost: TEdit;
    StaticText9: TStaticText;
    StaticText10: TStaticText;
    EditNOWDB2UserName: TEdit;
    EditNOWDB2PasswordHost: TEdit;
    EditPortHost: TEdit;
    StaticTextPort: TStaticText;
    EditNOWDB2UserNameHost: TEdit;
    Panel2: TPanel;
    GBOracleConnectionHost: TGroupBox;
    EditNOWOracleUserNameHost: TEdit;
    EditNOWOraclePasswordHost: TEdit;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText7: TStaticText;
    EditNOWOracleTNSNameHost: TEdit;
    StaticTextIpOra: TStaticText;
    EditOracleIPHost: TEdit;
    ODBCConnectionHost: TPanel;
    GBOdbc: TGroupBox;
    ConnectionComboBox: TComboBox;
    CBOdbcDriver: TComboBox;
    EditNOWODBCUserName: TEdit;
    EditNOWODBCPassword: TEdit;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    Panel6: TPanel;
    GroupBox1: TGroupBox;
    StaticText5: TStaticText;
    StaticText6: TStaticText;
    EditNOWDB2DataSourceLocal: TEdit;
    EditNOWDB2SrvIPLocal: TEdit;
    StaticText8: TStaticText;
    StaticText13: TStaticText;
    EditNOWDB2UserNameLocal: TEdit;
    EditNOWDB2PasswordLocal: TEdit;
    EditPortLocal: TEdit;
    StaticText14: TStaticText;
    Panel7: TPanel;
    GroupBox3: TGroupBox;
    EditNOWOracleUserNameLocal: TEdit;
    EditNOWOraclePasswordLocal: TEdit;
    StaticText15: TStaticText;
    StaticText16: TStaticText;
    StaticText17: TStaticText;
    EditNOWOracleTNSNameLocal: TEdit;
    StaticText18: TStaticText;
    EditOracleIPLocal: TEdit;

    procedure FormCreate(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure BtnCheckConnectionHostClick(Sender: TObject);
    procedure BtnCancClick(Sender: TObject);
//    procedure EditNOWDB2UserNameLocalChange(Sender: TObject);
    procedure BtnCheckConnectionLocalClick(Sender: TObject);
    procedure RadioGroupLocalConnectionClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
//    procedure RadioGroupHostDatabaseClick(Sender: TObject);
  private
    SavedIni : TIniAppGlobals;
    LocalIP: String;
    procedure UpdateFromDefault;
  public
    { Public declarations }
  end;

var
  HostSettings : TFConnection;

implementation

{$R *.DFM}

uses
 //  UMASStoredProc,
  DMsrvPc,
//  UMSrvConfig,
  uODBC;

//----------------------------------------------------------------------------//

procedure TFConnection.BtnCheckConnectionHostClick(Sender: TObject);
begin
  if RadioGroupHostDatabase.ItemIndex = 0 then
    IniAppGlobals.downloadFrom := '0'
  else if RadioGroupHostDatabase.ItemIndex = 1 then
    IniAppGlobals.downloadFrom := '1'
  else
  begin
    IniAppGlobals.downloadFrom := '2';
    if CBOdbcDriver.ItemIndex <= 0 then
    begin
      ShowMessage('Please selct driver name for ODBC connection');
      exit;
    end;
  end;

  with IniAppGlobals do
  begin

    NOWDB2UserName := EditNOWDB2UserNameHost.Text;
    NOWDB2Password := EditNOWDB2PasswordHost.Text;
    NOWDB2DataSource := EditNOWDB2DataSourceHost.Text;
    NOWDB2SrvIP := EditNOWDB2SrvIPHost.Text;
    NOWDB2PORT := EditPortHost.Text;

{    NOWDB2UserNameLocal := EditNOWDB2UserNameLocal.Text;
    NOWDB2PasswordLocal := EditNOWDB2PasswordLocal.Text;
    NOWDB2DataSourceLocal := EditNOWDB2DataSourceLocal.Text;
    NOWDB2SrvIPLocal := EditNOWDB2SrvIPLocal.Text;
    NOWDB2PORTLocal := EditPortLocal.Text;   }

    NOWOracleIp       := EditOracleIPHost.Text;
    NOWOracleTNSName  := EditNOWOracleTNSNameHost.Text;
    NOWOracleUserName := EditNOWOracleUserNameHost.Text;
    NOWOraclePassword := EditNOWOraclePasswordHost.Text;

    ODBCUserName := EditNOWODBCUserName.Text;
    ODBCPassword := EditNOWODBCPassword.Text;
    AliasOdbc        := ConnectionComboBox.Items[ConnectionComboBox.ItemIndex];
    if CBOdbcDriver.ItemIndex > -1 then
    begin
      if CBOdbcDriver.ItemIndex = 1 then
        ODBCDriverName := '1'
      else if CBOdbcDriver.ItemIndex = 2 then
        ODBCDriverName := '2'
      else if CBOdbcDriver.ItemIndex = 3 then
        ODBCDriverName := '3'
      else if CBOdbcDriver.ItemIndex = 4 then
        ODBCDriverName := '4'
    end;
  end;

  if assigned(DMib) then
  begin
    try
      HostDbConnect;
      ShowMessage('Host Connection successful !');
    except
      raise;
      UpdateFromDefault
    end;
  end;

end;

//----------------------------------------------------------------------------//

procedure TFConnection.BtnCheckConnectionLocalClick(Sender: TObject);
begin
  if RadioGroupLocalConnection.ItemIndex = 0 then
    IniAppGlobals.downloadTo := '0'
  else if RadioGroupLocalConnection.ItemIndex = 1 then
    IniAppGlobals.downloadTo := '1'
  else
  begin
    IniAppGlobals.downloadTo := '2';
  {  if CBOdbcDriver.ItemIndex <= 0 then
    begin
      ShowMessage('Please selct driver name for ODBC connection');
      exit;
    end; }
  end;

  with IniAppGlobals do
  begin
    if ServrIBname.Text <> '' then
      Server := EditPathIP1.Text + ServrIBname.Text + EditPathIP2.Text
    else
      Server := '';

    NOWDB2UserNameLocal := EditNOWDB2UserNameLocal.Text;
    NOWDB2PasswordLocal := EditNOWDB2PasswordLocal.Text;
    NOWDB2DataSourceLocal := EditNOWDB2DataSourceLocal.Text;
    NOWDB2SrvIPLocal := EditNOWDB2SrvIPLocal.Text;
    NOWDB2PORTLocal := EditPortLocal.Text;

    NOWOracleIpLocal       := EditOracleIPLocal.Text;
    NOWOracleTNSNameLocal  := EditNOWOracleTNSNameLocal.Text;
    NOWOracleUserNameLocal := EditNOWOracleUserNameLocal.Text;
    NOWOraclePasswordLocal := EditNOWOraclePasswordLocal.Text;

{    ODBCUserName := EditNOWODBCUserName.Text;
    ODBCPassword := EditNOWODBCPassword.Text;
    AliasOdbc        := ConnectionComboBox.Items[ConnectionComboBox.ItemIndex];
    if CBOdbcDriver.ItemIndex > -1 then
    begin
      if CBOdbcDriver.ItemIndex = 1 then
        ODBCDriverName := '1'
      else if CBOdbcDriver.ItemIndex = 2 then
        ODBCDriverName := '2'
      else if CBOdbcDriver.ItemIndex = 3 then
        ODBCDriverName := '3'
    end;  }
  end;

  if assigned(DMib) then
  begin
    try
      LocalDbConnectTest;
      ShowMessage('Local Connection successful !');
    except
      raise;
      UpdateFromDefault
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFConnection.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if LocalIp <> Editpathip1.text + ServrIBname.Text + editpathIp2.text then
    IniAppGlobals.Server := LocalIp;

end;

//----------------------------------------------------------------------------//

procedure TFConnection.FormCreate(Sender: TObject);
var
  I     : Integer;
  ODBCDriversList: TStrings;
begin
  TranslateComponent (self);
  SavedIni := IniAppGlobals;
  UpdateFromDefault;
  LocalIp := IniAppGlobals.Server;

  ODBCDriversList := GetDSNList([dtUSER,dtSYSTEM],'');
  ConnectionComboBox.Items.Add('');
  for I := 0 to ODBCDriversList.Count - 1 do
    ConnectionComboBox.Items.Add(ODBCDriversList.Strings[i]);

  for I := 0 to ConnectionComboBox.Items.count -1 do
  begin
    if (IniAppGlobals.AliasOdbc = ConnectionComboBox.Items[I]) then
    begin
      ConnectionComboBox.ItemIndex := I;
      break;
    end;
  end;


  ReShape(Self);
end;

procedure TFConnection.RadioGroupLocalConnectionClick(Sender: TObject);
begin
  if RadioGroupLocalConnection.ItemIndex <> 2 then
  begin
    StaticTextIBServerIp.Enabled := false;
    EditPathIP1.Enabled := false;
    ServrIBname.Enabled := false;
    EditPathIP2.Enabled := false
  end
  else
  begin
    StaticTextIBServerIp.Enabled := true;
    EditPathIP1.Enabled := true;
    ServrIBname.Enabled := true;
    EditPathIP2.Enabled := true
  end;
end;

//----------------------------------------------------------------------------//

procedure TFConnection.UpdateFromDefault;
var
  I : integer;
  TempIp : string;
begin

  case StrToInt(IniAppGlobals.downloadFrom) of
    0 : RadioGroupHostDatabase.ItemIndex := 0;
    1 : RadioGroupHostDatabase.ItemIndex := 1;
    2 : RadioGroupHostDatabase.ItemIndex := 2;
  end;

  case StrToInt(IniAppGlobals.downloadTo) of
    0 : RadioGroupLocalConnection.ItemIndex := 0;
    1 : RadioGroupLocalConnection.ItemIndex := 1;
    2 : RadioGroupLocalConnection.ItemIndex := 2;
  end;

  if RadioGroupLocalConnection.ItemIndex <> 2 then
  begin
    StaticTextIBServerIp.Enabled := false;
    EditPathIP1.Enabled := false;
    ServrIBname.Enabled := false;
    EditPathIP2.Enabled := false
  end
  else
  begin
    StaticTextIBServerIp.Enabled := true;
    EditPathIP1.Enabled := true;
    ServrIBname.Enabled := true;
    EditPathIP2.Enabled := true
  end;

  EditNOWDB2UserNameHost.Text := IniAppGlobals.NOWDB2UserName;
  EditNOWDB2PasswordHost.Text := IniAppGlobals.NOWDB2Password;
  EditNOWDB2DataSourceHost.Text := IniAppGlobals.NOWDB2DataSource;
  EditNOWDB2SrvIPHost.Text := IniAppGlobals.NOWDB2SrvIP;
  EditPortHost.Text := IniAppGlobals.NOWDB2PORT;

  EditNOWDB2UserNameLocal.Text := IniAppGlobals.NOWDB2UserNameLocal;
  EditNOWDB2PasswordLocal.Text := IniAppGlobals.NOWDB2PasswordLocal;
  EditNOWDB2DataSourceLocal.Text := IniAppGlobals.NOWDB2DataSourceLocal;
  EditNOWDB2SrvIPLocal.Text := IniAppGlobals.NOWDB2SrvIPLocal;
  EditPortLocal.Text := IniAppGlobals.NOWDB2PORTLocal;

  EditOracleIPHost.Text := IniAppGlobals.NOWOracleIp;
  EditNOWOracleTNSNameHost.Text := IniAppGlobals.NOWOracleTNSName;
  EditNOWOracleUserNameHost.Text := IniAppGlobals.NOWOracleUserName;
  EditNOWOraclePasswordHost.Text := IniAppGlobals.NOWOraclePassword;

  EditOracleIPLocal.Text := IniAppGlobals.NOWOracleIpLocal;
  EditNOWOracleTNSNameLocal.Text := IniAppGlobals.NOWOracleTNSNameLocal;
  EditNOWOracleUserNameLocal.Text := IniAppGlobals.NOWOracleUserNameLocal;
  EditNOWOraclePasswordLocal.Text := IniAppGlobals.NOWOraclePasswordLocal;

  EditNOWODBCUserName.Text := IniAppGlobals.ODBCUserName;
  EditNOWODBCPassword.Text := IniAppGlobals.ODBCPassword;

  if IniAppGlobals.ODBCDriverName = '1' then
    CBOdbcDriver.ItemIndex := 1
  else if IniAppGlobals.ODBCDriverName = '2' then
    CBOdbcDriver.ItemIndex := 2
  else if IniAppGlobals.ODBCDriverName = '3' then
    CBOdbcDriver.ItemIndex := 3
  else if IniAppGlobals.ODBCDriverName = '4' then
    CBOdbcDriver.ItemIndex := 4;

  TempIp := '';
  if IniAppGlobals.Server <> '' then
  begin
    for I := 1 to Length(IniAppGlobals.Server) do
    begin
      if (I = 1) or (I = 2) or (I = Length(IniAppGlobals.Server)) then
         continue;
      TempIp := TempIp + IniAppGlobals.Server[I];

    end;
  end;

  ServrIBname.Text := TempIp;

end;

//----------------------------------------------------------------------------//

procedure TFConnection.BtnCancClick(Sender: TObject);
begin
  IniAppGlobals := SavedIni;
end;

procedure TFConnection.BtnOkClick(Sender: TObject);
begin
  ModalResult := mrOk;

  with IniAppGlobals do
  begin

   if RadioGroupHostDatabase.ItemIndex = 0 then
      DownloadFrom := '0'
   else if RadioGroupHostDatabase.ItemIndex = 1 then
      DownloadFrom := '1'
   else
     DownloadFrom := '2';


   if RadioGroupLocalConnection.ItemIndex = 0 then
      DownloadTo := '0'
   else if RadioGroupLocalConnection.ItemIndex = 1 then
      DownloadTo := '1'
   else
     DownloadTo := '2';

    AliasOdbc := ConnectionComboBox.Items[ConnectionComboBox.ItemIndex];
    NOWDB2UserName := EditNOWDB2UserNameHost.Text;
    NOWDB2Password := EditNOWDB2PasswordHost.Text;
    NOWDB2DataSource := EditNOWDB2DataSourceHost.Text;
    NOWDB2SrvIP := EditNOWDB2SrvIPHost.Text;
    NOWDB2PORT := EditPortHost.Text;

    NOWDB2UserNameLocal := EditNOWDB2UserNameLocal.Text;
    NOWDB2PasswordLocal := EditNOWDB2PasswordLocal.Text;
    NOWDB2DataSourceLocal := EditNOWDB2DataSourceLocal.Text;
    NOWDB2SrvIPLocal := EditNOWDB2SrvIPLocal.Text;
    NOWDB2PORTLocal := EditPortLocal.Text;

    NOWOracleIp := EditOracleIPHost.Text;
    NOWOracleTNSName := EditNOWOracleTNSNameHost.Text;
    NOWOracleUserName := EditNOWOracleUserNameHost.Text;
    NOWOraclePassword := EditNOWOraclePasswordHost.Text;
    ODBCUserName := EditNOWODBCUserName.Text;
    ODBCPassword := EditNOWODBCPassword.Text;

    NOWOracleIpLocal := EditOracleIPLocal.Text;
    NOWOracleTNSNameLocal := EditNOWOracleTNSNameLocal.Text;
    NOWOracleUserNameLocal := EditNOWOracleUserNameLocal.Text;
    NOWOraclePasswordLocal := EditNOWOraclePasswordLocal.Text;

//    ODBCUserName := EditNOWODBCUserName.Text;
 //   ODBCPassword := EditNOWODBCPassword.Text;

    if CBOdbcDriver.ItemIndex = 1 then
      ODBCDriverName := '1'
    else if CBOdbcDriver.ItemIndex = 2 then
      ODBCDriverName := '2'
    else if CBOdbcDriver.ItemIndex = 3 then
      ODBCDriverName := '3';

    Server := '';
    if ServrIBname.Text <> '' then
      Server     := '\\' + ServrIBname.Text + '\';

//    SetDownloadFrom(StrToInt(DownloadFrom));
//    SetDownloadTo(StrToInt(DownloadTo));


  end;
  GlobSaveIniValues;
  GlobLoadIniValues
end;

//----------------------------------------------------------------------------//

end.
