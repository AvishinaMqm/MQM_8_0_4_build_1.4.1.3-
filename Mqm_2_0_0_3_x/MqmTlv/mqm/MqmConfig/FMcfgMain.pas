unit FMcfgMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, Menus, StdCtrls, IBX.IBDatabase, gnugettext, ExtCtrls, Strutils, FMIni;

const
{  CcfgDbCodeMqm  = 1;
  CmainDbCodeMqm = 1;
  CcfgDbCodeMcm  = 2;
  CmainDbCodeMcm = 2;  }

  CprogRele   = '4.0.0';

type
  TMainForm = class(TForm)
    MainMenu: TMainMenu;
    IFile: TMenuItem;
    IExit: TMenuItem;
    IConfig: TMenuItem;
    ICreate: TMenuItem;
    IDatabase: TMenuItem;
    LblMainDb: TLabel;
    StLicenseMqm: TStaticText;
    LblLicenseMqm: TLabel;
    MICrtStored: TMenuItem;
    IResExchg: TMenuItem;
    ILicence: TMenuItem;
    ICreateLock: TMenuItem;
    SDlock: TSaveDialog;
    IViewLic: TMenuItem;
    Languages1: TMenuItem;
    MIEnglish: TMenuItem;
    MIItalian: TMenuItem;
    MiChinese: TMenuItem;
    MiTurkish: TMenuItem;
    MISpanish: TMenuItem;
    IDataBase1: TMenuItem;
    IBackupRestore: TMenuItem;
    ITools: TMenuItem;
    IVMqm: TMenuItem;
    IVMCM: TMenuItem;
    ICreateLockMCM: TMenuItem;
    IViewLicMCM: TMenuItem;
    Panel1: TPanel;
    MiConnections: TMenuItem;
    StDatabase: TStaticText;
    LblLicenseMcm: TLabel;
    StLicenseMcm: TStaticText;
    CiCreateView: TMenuItem;
    EnDecrypt1: TMenuItem;
    ReadIni1: TMenuItem;
    MiClearMqmSrvLoadRecord: TMenuItem;
    MiForceMqmScheduleDetailsToMCM: TMenuItem;
    SQL1: TMenuItem;
    procedure IDatabaseClick(Sender: TObject);
    procedure UpdateInterbasedates1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MICrtStoredClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure IDbCfgClick(Sender: TObject);
    procedure MISettingsClick(Sender: TObject);
    procedure ICreateLockClick(Sender: TObject);
    procedure IViewMQMLicClick(Sender: TObject);
    procedure IViewMCMLicClick(Sender: TObject);
    procedure MIEnglishClick(Sender: TObject);
    procedure MIItalianClick(Sender: TObject);
    procedure MiTurkishClick(Sender: TObject);
    procedure MiChineseClick(Sender: TObject);
    procedure MISpanishClick(Sender: TObject);
    procedure IBackupRestoreClick(Sender: TObject);
    procedure IExitClick(Sender: TObject);
    procedure MiConnectionsClick(Sender: TObject);
    function  IsCompatibleWithDbs(var errStr : string) : boolean;
    procedure CiCreateViewClick(Sender: TObject);
    procedure EnDecrypt1Click(Sender: TObject);
    procedure ReadIni1Click(Sender: TObject);
    procedure MiClearMqmSrvLoadRecordClick(Sender: TObject);
    procedure MiForceMqmScheduleDetailsToMCMClick(Sender: TObject);
    procedure SQL1Click(Sender: TObject);
  private
    m_errStr : string;
    procedure UpdateSrvStatus;
//    function  IsCompatibleWithMQMCMDb(isMqm : boolean; mainCode, cfgCode: integer; var errStr: string): boolean;
  end;


var
  MainForm: TMainForm;

implementation

{$R *.DFM}

uses
  DMSrvPc,
  UMTblDesc,
  FMdbConf,
  FMSettings,
  FMcreateTables,
  FMViewLic,
  UGLicensing,
  UMStoredProc,
  UMglobal,
  FMBackUpRestore,
  fMConnection,
  FMPassword,
  FMMiForceMqmScheduleDetailsToMCM,
  FMSelectResetStation,
  FMSQL;

//----------------------------------------------------------------------------//

procedure TMainForm.IDatabaseClick(Sender: TObject);
var
  CreateTables : TCreateTables;
begin
  CreateTables := TCreateTables.Create(self);
  if CreateTables.ShowModal = idok then
  begin
    if CreateTables.m_DatabaseCreate then
    begin
      StLicenseMqm.Caption := 'License is not ' + 'Installed ';
      StLicenseMcm.Caption := 'License is not ' + 'Installed ';
    end;
  end;

  CreateTables.Free;
//  CreateTables.Show();
//  UpdateSrvStatus
end;

//----------------------------------------------------------------------------//

procedure TMainForm.FormCreate(Sender: TObject);
begin
  TranslateComponent (self);
  m_errStr := '';
  UpdateSrvStatus;

 {$ifdef MCM}

  Caption := _('MCM configuration')

 {$else}

  Caption := _('MQM configuration')

  {$endif};


  Caption := Caption + '  ' + DBAppGlobals.MqmVersion;

//  {$ifdef PasswordEnDeCrypt}
    ITools.visible := true;
//  {$else}
//     ITools.visible := false;

//  {$endif}

  if IniAppGlobals.External_Database_Update = '1' then
     MiForceMqmScheduleDetailsToMCM.Visible := true;

end;

//----------------------------------------------------------------------------//

procedure TMainForm.UpdateInterbasedates1Click(Sender: TObject);
var dbTable,dbCol : TMqmQuery;
  sCol, sTab, sSQl,  sArray : String;
  nDays : Variant;
  a : integer;
begin

  if not GetPassword then
  begin
    ModalResult := idAbort;
    Exit;
  end;

  if IniAppGlobals.downloadTo <> '2' then
  begin
    MessageDlg('Local database must be Interbase!', mtError, [mbOk], 0);
    exit;
  end;

  nDays := InputBox('Number of days to increase/decrease', 'Days:', '');

  if nDays = '' then
  begin
    //MessageDlg('Days must have value!', mtError, [mbOk], 0);
    exit;
  end;

  if nDays = '0' then
  begin
    MessageDlg('Days must be <> 0!', mtError, [mbOk], 0);
    exit;
  end;

  if not TryStrToInt(nDays,a) then
  begin
     MessageDlg('Days must be numberic!', mtError, [mbOk], 0);
    exit;
  end;

  dbTable := CreateQuery(Main_DB);
  dbCol := CreateQuery(Main_DB);


 { dbTable.SQL.Text := 'select f.rdb$field_name as "cColumn", r.rdb$relation_name as cName,f.rdb$field_position as pos'
      + '  from rdb$relation_fields f '
      +' join rdb$relations r on f.rdb$relation_name = r.rdb$relation_name and r.rdb$view_blr is null'
      +' and (r.rdb$system_flag is null or r.rdb$system_flag = 0)'
      +' where r.rdb$relation_name <> ' + QuotedStr('CALENDAR')
      +' order by r.rdb$relation_name, f.rdb$field_position;';     }
  dbTable.SQL.Text := 'SELECT rel_field.rdb$field_name as "cColumn",rel.rdb$relation_name as "cName",rel_field.rdb$field_position as pos'
    + ' FROM rdb$relations rel '
    + ' JOIN rdb$relation_fields rel_field ON rel_field.rdb$relation_name = rel.rdb$relation_name'
    + ' JOIN rdb$fields field ON rel_field.rdb$field_source = field.rdb$field_name'
    + ' WHERE rel.rdb$relation_name <> '''+'CALENDAR'+''' and rdb$field_type = 35 '
    + ' and (rel.rdb$system_flag is null or rel.rdb$system_flag = 0)'
    + 'ORDER BY rel.rdb$relation_name,rel_field.rdb$field_position, rel_field.rdb$field_name';
  dbTable.Open;



  DMib.m_MainDB.StartTransaction;

    while not dbTable.Eof  do
    begin

      if (sTab <> dbTable.FieldByName('cName').AsString) and (sTab <> '') then
      begin


         if sArray = '' then
         begin
            sTab := '';
            dbTable.Next;
            continue;
         end;

         var cIndCol := DMib.m_MainDB.ExecSQLScalar('Select RDB$FIELD_NAME from RDB$RELATION_FIELDS where RDB$RELATION_NAME = '
            + QuotedStr(TRIM(sTab))+ ' and RDB$FIELD_NAME like '+ QuotedStr('%IDENTIFIER%') );

         sSQL := 'Update ' + sTab
          + ' Set ' + sArray
          + ' where ' + cIndCol + ' = ' + QuotedStr(IniAppGlobals.Identifier);

        DMib.m_MainDB.ExecSQL(sSQL);
        sArray := '';

        dbCol.Close;
        dbCol.SQL.Text := 'Select * from ' + dbTable.FieldByName('cName').AsString + ' ROWS 1';
        dbCol.Open;
      end;

      sTab := dbTable.FieldByName('cName').AsString;

      if not ContainsStr(dbCol.SQL.text, sTab) then
      begin
        dbCol.Close;
        dbCol.SQL.Text := 'Select * from ' + dbTable.FieldByName('cName').AsString + ' ROWS 1';
        dbCol.Open;
      end;


      if dbCol.RecordCount = 0 then
      begin
        sTab := '';
        dbTable.Next;
        continue;
      end;

        sCol := dbTable.FieldByName('cColumn').AsString;

       // if (dbCol.FieldDefs[dbTable.FieldByName('pos').asInteger].DataType = ftTimeStamp) then
       // begin

          if sArray = '' then
          begin
            if nDays < 0 then
              sArray := sCol + ' = ' + sCol + nDays
            else
              sArray := sCol + ' = ' + sCol + ' + ' + nDays;
          end else
          begin
            if nDays < 0 then
              sArray := sArray + ', ' + sCol + ' = ' + sCol + nDays
            else
              sArray := sArray + ', ' + sCol + ' = ' + sCol + ' + ' + nDays;
          end;

          dbTable.Next;
          continue;

        {end else
        begin
          dbTable.Next;
          continue;
        end;  }

      dbTable.Next;
    end;

    ///Calendar

    dbTable.Close;
    dbTable.SQL.Text := 'select distinct Ca_cal from Calendar where CA_IDENTIFIER = ' + QuotedStr(IniAppGlobals.Identifier);
    dbTable.Open;

    if dbTable.RecordCount > 0 then
    begin

      var MaxYear := '';

      while not dbTable.eof do
      begin
         MaxYear := dbTable.Connection.ExecSQLScalar('select extract(year from max(ca_cal_date)) from Calendar where ca_cal = '+QuotedStr(dbTable.FieldByName('CA_CAL').AsString)
          + ' and CA_Identifier = ' + QuotedStr(IniAppGlobals.Identifier));

        if MaxYear = '' then
        begin
          continue;
          dbTable.Next;
        end;

        var year := '';
        if IsLeapYear(StrToInt(MaxYear)) then
          year := '366'
        else
          year := '365';

        var cSQL := 'Insert into Calendar (ca_Identifier, ca_cal, ca_cal_date, CA_PROG_WRK_HR,CA_SH1_START , CA_SH1_END  ,CA_SH2_START,CA_SH2_END,CA_SH3_START,CA_SH3_END,CA_SH4_START,CA_SH4_END)'
          + ' select ca_Identifier, ca_cal, ca_cal_date +' + year
          + ', CA_PROG_WRK_HR,CA_SH1_START ,'
          + ' CA_SH1_END  ,CA_SH2_START	,CA_SH2_END	,CA_SH3_START	,CA_SH3_END	,CA_SH4_START	,CA_SH4_END'
          + ' from CALENDAR'
          + ' where ca_cal = ' +QuotedStr(dbTable.FieldByName('CA_CAL').AsString)
          + ' and CA_Identifier = ' + QuotedStr(IniAppGlobals.Identifier)
          + ' and extract(year from ca_cal_date) = ' + MaxYear;

        dbTable.Connection.ExecSQL(cSQL);

        dbTable.Next;
      end;
    end;

    DMib.m_MainDB.Commit;
    Showmessage('Done');
end;

procedure TMainForm.UpdateSrvStatus;
var
  DefinedConnection : boolean;
  errStrMqm, errStrMcm: string;
begin
  DefinedConnection := true;
  if IsLocalDbConnected then
    StDatabase.Caption :=  ' ' + 'Connected '
  else
  begin
    StDatabase.Caption :=  ' ' + 'Connection is not defined ... ';
    DefinedConnection := false;
  end;

  if not DefinedConnection then
  begin
    StLicenseMqm.Caption := 'License is not ' + 'Installed ';
    StLicenseMcm.Caption := 'License is not ' + 'Installed ';
    exit
  end;

 // try
  LoadLicenceCfg(true, errStrMqm, errStrMcm);

  if errStrMqm <> '' then
    StLicenseMqm.Caption := ' ' + errStrMqm
  else
    StLicenseMqm.Caption := ' ' + 'Installed ';

  if errStrMcm <> '' then
    StLicenseMcm.Caption := ' ' + errStrMcm
  else
    StLicenseMcm.Caption := ' ' + 'Installed ';

end;

//----------------------------------------------------------------------------//

procedure TMainForm.MICrtStoredClick(Sender: TObject);
begin
  CreateStoredForMain;
  CreateStoredForCfg;
  Showmessage(_('Stored procedures creation completed'));
end;

//----------------------------------------------------------------------------//

procedure TMainForm.CiCreateViewClick(Sender: TObject);
var
  CreateTables : TCreateTables;
  qry: TMqmQuery;
begin
  CreateTables := TCreateTables.Create(self);
  qry := CreateQuery(Main_DB);
  CreateTables.DropView(qry, nil);
  CreateTables.CreateView(qry, nil)
end;

//----------------------------------------------------------------------------//

procedure TMainForm.EnDecrypt1Click(Sender: TObject);
begin

  InputBox('Decrypt', 'Decrypted value:',
  Decrypt(
  InputBox('Encrypt', 'Encrypted value:','')));
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  try
    GetMqmDb(Main_DB).Connected := false;
  Except

  end;
  //sleep(1000);
 // while GetMqmDb(Main_DB).Connected do
 // begin

 // end;

  try
    GetMqmDb(Cfg_DB).Connected := false;
  Except

  end;
end;

//----------------------------------------------------------------------------//

procedure TMainForm.IDbCfgClick(Sender: TObject);
var
  FDbConf: TFDbConf;
begin
  FDbConf := TFDbConf.Create(self);
  FDbConf.ShowModal;
  FDbConf.Free;
  UpdateSrvStatus
end;

procedure TMainForm.IExitClick(Sender: TObject);
begin
  close;
end;

//----------------------------------------------------------------------------//

procedure TMainForm.MISettingsClick(Sender: TObject);
begin
  ShowSettings(self)
end;

//----------------------------------------------------------------------------//

function TMainForm.IsCompatibleWithDbs(var errStr : string) : boolean;
begin
  errStr := m_errStr
end;

//----------------------------------------------------------------------------//

procedure TMainForm.ICreateLockClick(Sender: TObject);
var
  hdCode: integer;
  lic:    TRecLicVers1;
  arr:    TLicMemory;
  errStr: string;
begin

  if TMenuItem(Sender).Name = 'ICreateLockMCM' then
  begin

    with SDlock do
    begin
      DefaultExt := 'lck';
      FileName   := 'mcmLock';
      Filter     := 'lock file|*.lck';
    end;

    if SDlock.Execute then
    begin
      hdCode          := GetLockCode;
      lic.licType     := 0; // lock licence
      lic.customer    := 'MCM';
      lic.releaseDate := now;
      lic.lockNum     := hdCode;

      if not EncodeLicVers1(lic, arr, errStr) then
        ShowMessage(errStr)
      else
        SaveLicToFile(SDlock.FileName, arr)
    end
  end

  else  // MQM
  begin

    with SDlock do
    begin
      DefaultExt := 'lck';
      FileName   := 'mqmLock';
      Filter     := 'lock file|*.lck';
    end;

    if SDlock.Execute then
    begin
      hdCode          := GetLockCode;
      lic.licType    := 0; // lock licence
      lic.customer    := 'Mqm';
      lic.releaseDate := now;
      lic.lockNum     := hdCode;

      if not EncodeLicVers1(lic, arr, errStr) then
        ShowMessage(errStr)
      else
        SaveLicToFile(SDlock.FileName, arr)
    end

  end;

end;

//----------------------------------------------------------------------------//

procedure TMainForm.IViewMQMLicClick(Sender: TObject);
begin
  ShowLicence(self, 2);
  UpdateSrvStatus
end;

//----------------------------------------------------------------------------//

procedure TMainForm.IViewMCMLicClick(Sender: TObject);
begin
  ShowLicence(self, 3);
  UpdateSrvStatus
end;

//----------------------------------------------------------------------------//

procedure TMainForm.MIEnglishClick(Sender: TObject);
begin
  UseLanguage ('en');
  //FormCreate(sender);
  ReTranslateComponent (self);
  DBAppGlobals.Language := 'en';
  SaveLanguage;
end;

procedure TMainForm.MiForceMqmScheduleDetailsToMCMClick(Sender: TObject);
var
  MqmScheduleDetailsToMCM: TForceMqmScheduleDetailsToMCM;
begin
  MqmScheduleDetailsToMCM := TForceMqmScheduleDetailsToMCM.Create(Self);
  if MqmScheduleDetailsToMCM.ShowModal = mrOk then
  begin
    //m_LoopTime := SetLoopTime;
    //Caption := 'Mqm Server ' + DBAppGlobals.MqmVersion + '   ' + IniAppGlobals.SrvNameUserDefine;
  end;
end;

//----------------------------------------------------------------------------//

procedure TMainForm.MIItalianClick(Sender: TObject);
begin
  UseLanguage ('it');
  ReTranslateComponent (self);
  DBAppGlobals.Language := 'it';
  SaveLanguage;
end;

procedure TMainForm.MiTurkishClick(Sender: TObject);
begin
  UseLanguage ('tr');
  ReTranslateComponent (self);
  DBAppGlobals.Language := 'tr';
  SaveLanguage;
end;

procedure TMainForm.ReadIni1Click(Sender: TObject);
var
  fIni : TFIni;
begin
  fIni := TFini.Create(self);
  fini.Showmodal;
  fIni.Free;
end;

procedure TMainForm.SQL1Click(Sender: TObject);
var sql : TFSQL;
begin

  if IniAppGlobals.downloadTo = '2' then
  begin
    MessageDlg('SQL-Studio does not support Interbase!', mtError, [mbOk], 0);
    exit;
  end;

  sql := TFsql.Create(self);
  Sql.ShowModal;
  sql.Free;

end;

procedure TMainForm.MiChineseClick(Sender: TObject);
begin
  UseLanguage ('zh');
  ReTranslateComponent (self);
  DBAppGlobals.Language := 'zh';
  SaveLanguage;
end;

procedure TMainForm.MiClearMqmSrvLoadRecordClick(Sender: TObject);
var qry: TMqmQuery;
  tbInfo : PTblInfo;
begin
  if not GetPassword then
  begin
    ModalResult := idAbort;
    Exit;
  end;

   qry := CreateQuery(Cfg_DB);
   tbInfo := @tblInfo[tbl_cfg_exchg_wkst];

   qry.Connection.StartTransaction;
   qry.ExecSQL('delete from ' + tbInfo.GetTableName +
    ' where CEW_WKST_CODE = ' + QuotedStr('SERVER') + ' and CEW_IDENTIFIER = ' + IniAppGlobals.Identifier);

   Showmessage(_('Cleared'));
   qry.Connection.Commit;
   qry.Close;
   qry.Free;
end;

procedure TMainForm.MiConnectionsClick(Sender: TObject);
var
  Connection : TFConnection;
begin
  Connection := TFConnection.Create(Self);
  Connection.ShowModal;
  Connection.Free;
  UpdateSrvStatus;
end;

procedure TMainForm.MISpanishClick(Sender: TObject);
begin
  UseLanguage ('es');
  ReTranslateComponent (self);
  DBAppGlobals.Language := 'es';
  SaveLanguage;
end;

procedure TMainForm.IBackupRestoreClick(Sender: TObject);
begin
  if not Assigned(BackupRestore) then
    BackupRestore := TBackupRestore.Create(Self);

  BackUpRestore.ShowModal;
end;

end.
