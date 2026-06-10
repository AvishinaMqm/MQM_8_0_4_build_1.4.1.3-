unit FMBackUpRestore;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, DB, IBX.IBCustomDataSet, ShellApi;

type
  TBackUpRestore = class(TForm)
    Panel1: TPanel;
    cbDatabase: TRadioGroup;
    btExecute: TBitBtn;
    btClose: TBitBtn;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    GBWokingDir: TGroupBox;
    SBOpen: TSpeedButton;
    SBSave: TSpeedButton;
    LEOpenFile: TLabeledEdit;
    LESaveFile: TLabeledEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure cbDatabaseClick(Sender: TObject);
    procedure SBOpenClick(Sender: TObject);
    procedure SBSaveClick(Sender: TObject);
    procedure btExecuteClick(Sender: TObject);
    procedure LESaveFileChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function CheckDb: boolean;
  function BackupRestoreDB(sFileOpen, sFileSave: string; iOperation: integer): integer;

var
  BackUpRestore: TBackUpRestore;

implementation

{$R *.dfm}

uses
  UMTblDesc,
  DMSrvPc,
  gnugettext, FMcfgMain, IBX.IBDatabase;


function CheckDb: boolean;
var
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
begin
  qry := CreateQuery(Cfg_DB);

  tbInfo := @tblInfo[tbl_cfg_exchg_wkst];
  SetFldPfx(tbInfo.pfx);

  with qry do
  begin
    SQL.Add('select * from  ' + tbInfo.PCname);
    qry.Transaction.StartTransaction;
    Open;

    result := True;
    if RecordCount > 0 then
      result := False;

    Close;
  end;

  qry.Transaction.Commit;
  qry.Free;
end;

function BackupRestoreDB(sFileOpen, sFileSave: string; iOperation: integer): integer;
var
  sExecute: string;
begin
  sExecute := '';
  case iOperation of
    0: sExecute := sExecute +' -b';
    1: sExecute := sExecute +' -r';
  end;

  sExecute := sExecute + ' -v -y bckrst.log -user SYSDBA -password masterkey '+ sFileOpen + ' '+ sFileSave;

  result :=  ShellExecute(MainForm.Handle,'open',PChar('gbak.exe'),PChar(sExecute),nil, SW_SHOWNORMAL);

end;

procedure TBackUpRestore.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TBackUpRestore.FormDestroy(Sender: TObject);
begin
  BackUpRestore := nil;
end;

procedure TBackUpRestore.cbDatabaseClick(Sender: TObject);
begin
  if cbDatabase.ItemIndex = -1 then Exit;

  LEOpenFile.Enabled := True;
  LESaveFile.Enabled := True;
  SBOpen.Enabled     := True;
  SBSave.Enabled     := True;

  LEOpenFile.Text    := '';
  LESaveFile.Text    := '';

  btExecute.Enabled  := False;
end;

procedure TBackUpRestore.SBOpenClick(Sender: TObject);
begin
{  case cbDatabase.ItemIndex of
    0: begin
         OpenDialog1.InitialDir := DMib.m_MainDB.DatabaseName;
         OpenDialog1.DefaultExt := 'GDB';
         OpenDialog1.FileName   := '';
         OpenDialog1.Filter     := 'Interbase|*.GDB';
       end;
    1: begin
         OpenDialog1.InitialDir := DMib.m_MainDB.DatabaseName;
         OpenDialog1.DefaultExt := 'GDK';
         OpenDialog1.FileName   := '';
         OpenDialog1.Filter     := 'Interbase Backup|*.GDK';
       end;
  end;

  if OpenDialog1.Execute then
    LEOpenFile.Text := OpenDialog1.FileName;         }
end;

procedure TBackUpRestore.SBSaveClick(Sender: TObject);
var
  oldDTFormat,
  oldTMFormat,
  sFileName:    string;
  ShortDateFormat : string;
  LongTimeFormat : string;
begin
{  oldDTFormat     := ShortDateFormat;
  oldTMFormat     := LongTimeFormat;

  ShortDateFormat := 'YYYYMMDD';
  LongTimeFormat  := 'HHmm';


  case cbDatabase.ItemIndex of
    0: begin
         sFileName       := ExtractFileName(LEOpenFile.Text);
         sFileName       := Copy(sFileName,1,length(sFileName)-4);

         SaveDialog1.InitialDir := DMib.m_MainDB.DatabaseName;
         SaveDialog1.DefaultExt := 'GDK';
         SaveDialog1.FileName   := DateToStr(Now)+'_' + sFileName;
         SaveDialog1.Filter     := 'Interbase Backup|*.GDK';
       end;
    1: begin
         sFileName       := ExtractFileName(LEOpenFile.Text);
         sFileName       := Copy(sFileName,8,length(sFileName)-4);

         SaveDialog1.InitialDir := DMib.m_MainDB.DatabaseName;
         SaveDialog1.DefaultExt := 'GDB';
         SaveDialog1.FileName   := '';
         SaveDialog1.Filter     := 'Interbase|*.GDB';
       end;
  end;

  if SaveDialog1.Execute then
    LESaveFile.Text := SaveDialog1.FileName;

  ShortDateFormat  := oldDTFormat;
  LongTimeFormat   := oldTMFormat;     }
end;

procedure TBackUpRestore.btExecuteClick(Sender: TObject);
var
  sMsg: string;
  f: Textfile;
begin
  if not CheckDB then
  begin
    MessageDlg(_('Database still open! Close before continuing...'), mtError, [mbOk], 0);
    Exit;
  end;
  if not (FileExists(LEOpenFile.Text)) or not ( Trim(LESaveFile.Text) <> '') then
  begin
    MessageDlg(_('File to open not exist or file to save not insert...'), mtError,[mbOk], 0);
    Exit;
  end;

  if Assigned(DMib.m_MainDB) then
    DMib.m_MainDB.Connected := false;
  if Assigned(DMib.m_CfgDB) then
    DMib.m_CfgDB.Connected := false;

  if FileExists(LESaveFile.Text) then
  begin
    case cbDatabase.ItemIndex of
      0: sMsg := _('File already exists. Overwrite?');
      1: sMsg := _('The restore operation overwrite the GDB file. Continue?');
    end;

    if MessageDlg(sMsg, mtConfirmation, [mbYes,mbNo], 0) = mrYes then
      if not DeleteFile(LESaveFile.Text) then
      begin
        MessageDlg(_('File cannot be deleted. Impossible to continue..'), mtError, [mbOk], 0);
        Exit
      end;
  end;

  Screen.Cursor := crHourGlass;

  if BackupRestoreDB(LEOpenFile.Text, LESaveFile.Text, cbDatabase.ItemIndex) < 32 then
    MessageDlg(_('Operation aborted'), mtError, [mbOk], 0)
  else
  begin
    while true do
    begin
      {$I-}
      AssignFile(f, 'bckrst.log');
      Reset(F);
       {$I+}
      if IOResult = 0 then
        Break
    end;

    CloseFile(F);
    DeleteFile('bckrst.log');

  //  DMib.ConnectMainDB();
  //  DMib.ConnectCFGDB();

    Screen.Cursor := crDefault;

    MessageDlg(_('Operation finished'), mtInformation, [mbOk], 0);
    Close;
  end;
end;

procedure TBackUpRestore.LESaveFileChange(Sender: TObject);
begin
   btExecute.Enabled   := False;

  if (Trim(LEOpenFile.Text) <> '') and (Trim(LESaveFile.Text) <> '') then
    btExecute.Enabled   := True;

end;

end.
