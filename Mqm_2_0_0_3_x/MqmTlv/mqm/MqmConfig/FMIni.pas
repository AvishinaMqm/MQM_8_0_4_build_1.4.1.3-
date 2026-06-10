unit FMIni;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, umglobal;

type
  TFIni = class(TForm)
    Memo1: TMemo;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FIni: TFIni;

implementation

{$R *.dfm}

procedure TFIni.FormShow(Sender: TObject);
begin
  memo1.Clear;


  With IniAppGlobals do
  begin
    with memo1 do
    begin

        lines.add('Identifier = ' + Identifier);
        lines.add('AliasOdbc = ' + AliasOdbc);
        lines.add('downloadTo = ' + downloadTo) ;
        lines.add('downloadFrom = ' + downloadFrom);
        lines.add('=========================');
        lines.add('IBUserName = ' + IBUserName);
        lines.add('IBPassword = ' +IBPassword);
        lines.add('IBDataSource = ' +IBDataSource);
        lines.add('==========================');
        lines.add('NOWDB2InstanceName = ' + NOWDB2InstanceName);
        lines.add('NOWDB2UserName = ' + NOWDB2UserName);
//        lines.add('NOWDB2Password = ' + Decrypt(NOWDB2Password));
        lines.add('NOWDB2Password = ' + NOWDB2Password);
        lines.add('NOWDB2DataSource = ' + NOWDB2DataSource);
        lines.add('NOWDB2SrvIP = ' + NOWDB2SrvIP);
        lines.add('NOWDB2PORT = ' +  NOWDB2PORT);
        lines.add('===========================');
        lines.add('NOWDB2InstanceNameLocal = ' + NOWDB2InstanceNameLocal);
        lines.add('NOWDB2UserNameLocal = ' + NOWDB2UserNameLocal);
//        lines.add('NOWDB2PasswordLocal = ' + Decrypt(NOWDB2PasswordLocal));
        lines.add('NOWDB2PasswordLocal = ' + NOWDB2PasswordLocal);
        lines.add('NOWDB2DataSourceLocal = ' + NOWDB2DataSourceLocal);
        lines.add('NOWDB2SrvIPLocal = ' + NOWDB2SrvIPLocal);
        lines.add('NOWDB2PORTLocal = ' +  NOWDB2PORTLocal);
        lines.add('============================');
        lines.add('NOWOracleIp = ' +  NOWOracleIp);
        lines.add('NOWOracleTNSName = ' + NOWOracleTNSName);
        lines.add('NOWOracleUserName = ' + NOWOracleUserName);
//        lines.add('NOWOraclePassword = ' +Decrypt(NOWOraclePassword));
        lines.add('NOWOraclePassword = ' + NOWOraclePassword);
        lines.add('=============================');
        lines.add('NOWOracleIpLocal = ' + NOWOracleIpLocal);
        lines.add('NOWOracleTNSNameLocal = ' + NOWOracleTNSNameLocal );
        lines.add('NOWOracleUserNameLocal = ' + NOWOracleUserNameLocal);
        lines.add('NOWOraclePasswordLocal = ' + Decrypt(NOWOraclePasswordLocal));
    end;
  end;


end;

end.
