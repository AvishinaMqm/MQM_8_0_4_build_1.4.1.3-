unit FMChangeWkstPass;

interface

uses
  cxButtons, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFChgWkstPass = class(TForm)
    Button1: TcxButton;
    eOld: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    eNew: TEdit;
    Label3: TLabel;
    eNew2: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FChgWkstPass: TFChgWkstPass;

implementation

uses DmSrvPc, UMGlobal, gnugettext, UReshape;

{$R *.dfm}

procedure TFChgWkstPass.Button1Click(Sender: TObject);
var qry, qryA : TMqmQuery;
  tbl : String;
begin

    qry := CreateQuery(Main_DB);

    if IniAppglobals.DownloadTo = '2' then
      tbl := 'WKST'
    else
      tbl := 'SCDM_WKST';

    if eOld.Text <> qry.Connection.ExecSqlScalar('select WK_WKPASSWD from ' + tbl + ' where WK_WKST_CODE = ' +QuotedStr(IniAppGlobals.WkstCode)
      + ' and WK_IDENTIFIER = ' + IniAppGlobals.Identifier) then
    begin
      MessageDlg(_('Wrong current password!'), mtError, [mbOk], 0);
      exit;
    end;

    if eNew.Text <> eNew2.Text then
    begin
      MessageDlg(_('New password doesn''t match with repeated password!'), mtError, [mbOk], 0);
      exit;
    end;

    if eNew.Text = '' then
    begin
      MessageDlg(_('New password cannot be blank!'), mtError, [mbOk], 0);
      exit;
    end;

    qry.sql.Text := 'Update '+ tbl + ' set WK_WKPASSWD = ' + QuotedStr(eNew.Text) + ' where WK_WKST_CODE = ' +QuotedStr(IniAppGlobals.WkstCode)
      + ' and WK_IDENTIFIER = ' + IniAppGlobals.Identifier;

    qry.ExecSql;

    if (IniAppglobals.External_Database_Update = '0') and (IniAppGlobals.ChangePassStation = '1') then
    begin

      DMib.ConnectDB_Arc;
      qryA := CreateQueryArc;

      if IniAppglobals.DownloadTo = '2' then
        tbl := 'WKST'
      else
        tbl := 'SCDA_WKST';

      qryA.sql.Text := 'Update '+ tbl + ' set WK_WKPASSWD = ' + QuotedStr(eNew.Text) + ' where WK_WKST_CODE = ' +QuotedStr(IniAppGlobals.WkstCode)
      + ' and WK_IDENTIFIER = ' + IniAppGlobals.Identifier;

      qryA.ExecSql;

      qrya.Close;
      QryA.Free;
    end;

    qry.Close;
    Qry.Free;

    Showmessage('Done!');
    close;
end;

procedure TFChgWkstPass.FormCreate(Sender: TObject);
begin
  ReShape(self);
end;

end.
