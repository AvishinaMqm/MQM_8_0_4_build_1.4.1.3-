unit FMdbConf;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, gnugettext;

type
  TFDbConf = class(TForm)
    GPBserver: TGroupBox;
    GPBmain: TGroupBox;
    GPBconfig: TGroupBox;
    PanBtn: TPanel;
    BtnOk: TBitBtn;
    BtnCanc: TBitBtn;
    StName: TStaticText;
    EdSrvName: TEdit;
    LblMainPath: TLabel;
    EdMainPath: TEdit;
    LblCfgPath: TLabel;
    EdCfgPath: TEdit;
    OpnDlg: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure BtnBwsMainClick(Sender: TObject);
    procedure BtnBwsCfgClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

uses
  UMGlobal,
  DMsrvPc;

//----------------------------------------------------------------------------//

procedure TFDbConf.FormCreate(Sender: TObject);
begin
  TranslateComponent (self);
  GetMqmDb(Main_DB).Connected := false;
  GetMqmDb(Cfg_DB).Connected := false;

  with IniAppGlobals do
  begin
    EdSrvName.Text   := Server;
    EdMainPath.Text  := MainDBPath + MainDBName;
    EdCfgPath.Text   := CfgDBPath  + CfgDBName;
{    if (IniAppGlobals.MudulesServed = '') then
       IniAppGlobals.MudulesServed := '0';
    case StrToInt(IniAppGlobals.MudulesServed) of
       0 : RGModuleServed.ItemIndex := 0;
       1 : RGModuleServed.ItemIndex := 1;
       2 : RGModuleServed.ItemIndex := 2;   }
   // end;

  end
end;

//----------------------------------------------------------------------------//

procedure TFDbConf.BtnOkClick(Sender: TObject);
begin
  with IniAppGlobals do
  begin
    Server     := EdSrvName.Text;
    MainDBPath := ExtractFilePath(EdMainPath.Text);
    MainDBName := ExtractFileName(EdMainPath.Text);
    CfgDBPath  := ExtractFilePath(EdCfgPath.Text);
    CfgDBName  := ExtractFileName(EdCfgPath.Text);
//    MudulesServed := IntToStr(RGModuleServed.ItemIndex);
  end;
  GlobSaveIniValues
end;

//----------------------------------------------------------------------------//

procedure TFDbConf.BtnBwsMainClick(Sender: TObject);
begin
  if OpnDlg.Execute then
  begin
    EdMainPath.Text := OpnDlg.FileName
  end;
end;

//----------------------------------------------------------------------------//

procedure TFDbConf.BtnBwsCfgClick(Sender: TObject);
begin
  if OpnDlg.Execute then
  begin
    EdCfgPath.Text := OpnDlg.FileName
  end;
end;


end.
