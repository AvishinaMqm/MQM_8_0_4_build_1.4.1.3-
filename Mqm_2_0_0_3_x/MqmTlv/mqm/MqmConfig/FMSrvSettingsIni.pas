unit FMSrvSettingsIni;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Buttons, ExtCtrls, gnugettext;

const
  NO_ALLIAS_EXIST = 'Please select alias for ODBC connection';

type
  TFSrvSettingsIni = class(TForm)
    PanBtn: TPanel;
    BtnOk: TBitBtn;
    BtnCanc: TBitBtn;
    RadioGroupConnectionType: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure BtnOkClickDefault;

  public
    { Public declarations }
  end;

var
  SrvSettingsForm : TFSrvSettingsIni;

implementation

{$R *.DFM}

uses
  UMGlobal,
  DMsrvPc;
//  UMSrvConfig,
//  UODBC;

//----------------------------------------------------------------------------//

procedure TFSrvSettingsIni.FormCreate(Sender: TObject);
var
//  ODBCDriversList: TStrings;
  i: integer;
begin
  TranslateComponent (self);
//  GetMqmDb(Main_DB).Connected := false;
  ModalResult := mrCancel;

//  ODBCDriversList := GetDSNList([dtUSER,dtSYSTEM],'');
//  for I := 0 to ODBCDriversList.Count - 1 do
//    ComboBoxIBDataSource.Items.Add(ODBCDriversList.Strings[i]);

  with IniAppGlobals do
  begin
    if DownloadTo = '' then
       RadioGroupConnectionType.ItemIndex := 0
    else
      RadioGroupConnectionType.ItemIndex := StrToInt(DownloadTo);
  //  InterbaseRadioButton.Checked := (StrToInt(DownloadTo) = 0);
  //  DB2RadioButton.Checked := (StrToInt(DownloadTo) = 1);
    if RadioGroupConnectionType.ItemIndex = 0 then
    begin
      IBUserName := 'SYSDBA';
      IBPassword := 'masterkey';
    end;

//    EditIBUserName.Text := IBUserName;
//    EditIBPassword.Text := IBPassword;

{    for  i := 0 to ComboBoxIBDataSource.Items.count -1 do
    begin
      if (IBDataSource = ComboBoxIBDataSource.Items[I]) then
      begin
        ComboBoxIBDataSource.ItemIndex := I;
        break;
      end;
    end;  }

 {   EditDB2Instancename.Text := DB2InstanceName;
    EditDB2UserName.Text := DB2UserName;
    EditDB2Password.Text := DB2Password;
    EditDB2DataSource.Text := DB2DataSource;
    EditDB2SrvIP.Text := DB2SrvIP;     }
  end;
end;

//----------------------------------------------------------------------------//

procedure TFSrvSettingsIni.BtnOkClick(Sender: TObject);
begin
  with IniAppGlobals do
  begin
    DownloadTo := IntToStr(RadioGroupConnectionType.ItemIndex);

    if RadioGroupConnectionType.ItemIndex = 0 then
    begin
      IBUserName := 'SYSDBA';
      IBPassword := 'masterkey';
    end;
    if RadioGroupConnectionType.ItemIndex = 2 then
      IniAppGlobals.DownloadFrom := '1'

 {   IBUserName := EditIBUserName.Text;
    IBPassword := EditIBPassword.Text;
    IBDataSource := ComboBoxIBDataSource.Text;

    DB2InstanceName := EditDB2InstanceName.Text;
    DB2UserName := EditDB2UserName.Text;
    DB2Password := EditDB2Password.Text;
    DB2DataSource := EditDB2DataSource.Text;
    DB2SrvIP := EditDB2SrvIP.Text;    }
  end;
  ModalResult := mrOk;
  GlobSaveIniValues
end;

//----------------------------------------------------------------------------//

procedure TFSrvSettingsIni.BtnOkClickDefault;
begin
  BtnOkClick(self);
end;

//----------------------------------------------------------------------------//

end.
