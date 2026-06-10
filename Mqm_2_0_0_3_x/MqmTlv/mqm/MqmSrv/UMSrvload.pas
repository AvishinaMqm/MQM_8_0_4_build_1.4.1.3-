unit UMsrvLoad;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, Db, ExtCtrls, StdCtrls,  FireDAC.Stan.Error, Shellapi, UGprogCtrl, 
  UOpThread, ComCtrls, gnugettext, DMsrvPc, UMCommon;

const
  CcfgDbCode  = 1;
  CmainDbCode = 1;
  CprogRele   = '1.0.0';

  CM_UPDATE = WM_APP + 1;
  OPI_idle      = 10;
  OPI_FromHost  = 11;
  OPI_LocalSrv  = 12;
  OPI_ToHost    = 13;
  OPI_UpdStr    = 14;
  OPI_UpdErr    = 15;
  OPI_Beep      = 16;
  OPI_TIME_WAIT = 17;
  OPI_STOP      = 18;
  OPI_Exit      = 19;

type

  TFSrvLoad = class(TForm)
    MainMenu: TMainMenu;
    IConfig: TMenuItem;
    IService: TMenuItem;
    IExit: TMenuItem;
    PGCmain: TPageControl;
    TBSctrl: TTabSheet;
    TBSerrRepo: TTabSheet;
    PanLoad: TPanel;
    ShFromHost: TShape;
    STfromHost: TStaticText;
    PanSend: TPanel;
    ShToHost: TShape;
    StToHost: TStaticText;
    PanBtn: TPanel;
    LblTable: TLabel;
    MmErrors: TMemo;
    PanLocal: TPanel;
    ShLocal: TShape;
    StLocal: TStaticText;
    N1: TMenuItem;
    LabelDownOp: TLabel;
    MenualTransfer: TMenuItem;
    MiDonwUpload: TMenuItem;
    ILoadManual: TMenuItem;
    MiDloadPS: TMenuItem;
    ArchivesDownload: TMenuItem;
    MiArchive: TMenuItem;
    MICalendars: TMenuItem;
    MiUpload: TMenuItem;
    MiUploadDonw: TMenuItem;
    N2: TMenuItem;
    info1: TMenuItem;
    Timer1: TTimer;
    StatusBar1: TStatusBar;
    procedure BtnStartStopClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SetConfigDwnMode;
    procedure FormDestroy(Sender: TObject);
    procedure IExitClick(Sender: TObject);
    procedure IConfigClick(Sender: TObject);
    procedure MiDonwUploadClick(Sender: TObject);
    procedure ILoadManualClick(Sender: TObject);
    procedure MiDloadPSClick(Sender: TObject);
    procedure MICalendarsClick(Sender: TObject);
    procedure MiArchiveClick(Sender: TObject);
    procedure IServiceClick(Sender: TObject);
    procedure MiUploadClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MiUploadDonwClick(Sender: TObject);
    procedure info1Click(Sender: TObject);
    procedure info1DrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect;
      Selected: Boolean);
    procedure Timer1Timer(Sender: TObject);
//    function CheckServerDoubleInstance : boolean;

  protected
    procedure CMUpdate(var msg: TMessage); message CM_UPDATE;
  private
    m_DnwUploadOperated : boolean;
  m_ConnectionRepairedetails : TStringList;
    m_currOp:    integer;

    m_opLock:    boolean;
    m_errList:   TStringList;
    m_operation: string;
    m_LoopTime : double;
    m_RestHour, m_RestSec, m_RestMin : integer;
    procedure EnabledBtns(Status : boolean);
    function GetStrTimeRest : string;
    function SetLoopTime : double;
//    procedure DeleteOldRequest;
    procedure CHECK_PARAMS;
    procedure SetRunStatus(Stat : string);
  public
    m_OperationStarted : boolean;
    fConnected : Boolean;
    m_ByParm:    boolean;
    procedure DeleteOldRequest;
    procedure DownloadRequestHandle;
    function  IsDnwUploadOperated : boolean;
  end;

  function  IsCompatibleWithDb(mainCode, cfgCode: integer; var errStr: string): boolean;
  procedure UpdateOperation(str: string);
  procedure StopCycle;
  procedure UpdateWaitingTime(RestTime : TDatetime);
  procedure UpdateStatuseBtn(Status : boolean ; ExitBtn : boolean);
  procedure UpdateError(sl: TStringList);
  function  WriteToLog(op: String; s: String; deleteOld: boolean): boolean;
  function  ConnectToHost: boolean;
  function  ConnectToNowHost: boolean;
  function  GetLoopTime : double;
  procedure ProgramTerminated;
  procedure SetRunStatus(Stat : string);

var
  FSrvLoad: TFSrvLoad;
  MinutesChecked : Integer;
  UploadTimeTry : TDateTime;
  var DecSep : String;
implementation

{$R *.DFM}

uses
  UMLoad,
  FMDownloadInfoMsg,
  UMTblDesc,
  UMDbFunc,
  UMSrvConfig,
  UMSaveLoad,
  FMSrvSettings,
  UMASStoredProc,
  UMStoredProc,
  UMGlobal,
  UMTransfer,
  Math,
  UMConnectionThread,
  FMLoadCalendars,
  UGLicensing;


//----------------------------------------------------------------------------//

procedure TFSrvLoad.DeleteOldRequest;
var
  qry: TMqmQuery;
  tbInfo: ^TTblInfo;
  OperateDelete : boolean;
begin
  qry := CreateQuery(Cfg_DB);
  tbInfo := @tblInfo[tbl_cfg_exchg_SrvLoad];
  Qry.Transaction := CreateTransaction(Cfg_DB);
  Qry.Transaction.StartTransaction;
  with Qry do
  begin
    Sql.Clear;
    Sql.add('Delete from ' + tbInfo.GetTableName);
    Sql.add(WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier)));
    ExecSQL;
  end;
  Qry.Transaction.Commit;
  Qry.Close;
  Qry.free;
end;

//----------------------------------------------------------------------------//

procedure TFSrvLoad.MICalendarsClick(Sender: TObject);
begin
  m_DnwUploadOperated := false;
  FDloadCalendars := TFDloadCalendars.Create(self);
  FDloadCalendars.ShowModal;
  FDloadCalendars.Free
end;

//----------------------------------------------------------------------------//

procedure TFSrvLoad.SetRunStatus(Stat : string);
var
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
begin
  {$ifdef DEVMQMCM}
     Exit;
  {$endif}
  qry := CreateQuery(Cfg_DB);
  Qry.Transaction := CreateTransaction(Cfg_DB);
  Qry.Transaction.StartTransaction;

  tbInfo := @tblInfo[tbl_cfg_exchg_glob];
  qry.Close;
  qry.SQL.Clear;

  qry.SQL.Add('update ' + tbInfo.GetTableName);
  qry.SQL.Add(' set '    + CreateFld(tbInfo.pfx, fli_SL_ON)     + ' = ''' + Stat + '''');
  qry.SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));

  qry.ExecSQL;
//  qry.Close;
  qry.transaction.Commit;
  qry.Free;

  Sp_Client_Status_Update;
end;



//----------------------------------------------------------------------------//

procedure TFSrvLoad.MiDonwUploadClick(Sender: TObject);
begin
  if (IniAppGlobals.PreparationExeName <> '') then
  begin
    SetTypeMode(TD_DownloadUploadToNow);
  end
  else
    SetTypeMode(TD_ProdAndUpload);

  m_DnwUploadOperated := true;
  EnabledBtns(false);
  StartExchDataSeq(Handle);
end;

//----------------------------------------------------------------------------//

procedure TFSrvLoad.MiUploadClick(Sender: TObject);
begin
  m_DnwUploadOperated := false;

  SetOldType(GetTypeMode);
  SetTypeMode(TD_OnlyUpload);

//  if ConnectToHost then
//  begin
  EnabledBtns(false);
  StartExchDataSeq(Handle);
//  end;
end;

//----------------------------------------------------------------------------//

procedure TFSrvLoad.info1Click(Sender: TObject);
var
  InfoForm: TDownloadInfoMsg;
begin
  InfoForm := TDownloadInfoMsg.Create(self);
  InfoForm.ShowModal;
  InfoForm.Free;
end;

//----------------------------------------------------------------------------//

procedure TFSrvLoad.info1DrawItem(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; Selected: Boolean);
var
  LeftPos: Integer;
  TopPos: Integer;
  TextLength: Integer;
  Text: string;
begin
  if DownloadInfoMsgProductStr.Count = 0 then
  begin
    FSrvLoad.MainMenu.OwnerDraw := false;
    Exit;
  end;

  Text := (Sender as TMenuItem).Caption;
  Text := 'Info';
  ACanvas.Brush.Color := clred;
  ACanvas.FillRect(ARect);
  ACanvas.Font.Color := clWhite;
//  ACanvas.Font.Style := [fsBold];
  // Draw right in the middle of the menu
  TopPos := ARect.Top +
    (ARect.Bottom - ARect.Top - ACanvas.TextHeight('W')) div 2;
  TextLength := Length(Text) - 2;
  if TextLength > (ARect.Right - ARect.Left) then
    LeftPos := ARect.Left + 3
  else
    LeftPos := ARect.Left + (ARect.Right - ARect.Left -
      ACanvas.TextWidth(Text)) div 2;
  ACanvas.TextOut(LeftPos - 5, TopPos, Text);
end;

//----------------------------------------------------------------------------//

function IsCompatibleWithDb(mainCode, cfgCode: integer; var errStr: string): boolean;
begin
  Result := true;
  errStr := '';

  if mainCode <> CmainDbCode then
  begin
    errStr := _('main database version not supported');
    Result := false
  end;

  if (cfgCode <> CcfgDbCode) then
  begin
    if errStr <> '' then errStr := errStr + #10#13;
    errStr := errStr + _('configuration database version not supported');
    Result := false
  end
end;

//----------------------------------------------------------------------------//

function ConnectToHost: boolean;
begin
//  HostDbConnect;
//  ArcDbConnect;
//  LocalDbConnect;
{  if (not CreatedHostdb) and (not CreateHostDatabase(IniAppGlobals.Alias)) then
    Result := false
  else if (not IsHostConnected) and (not ConnectToHostDatabase) then
    Result := false
  else
    Result := true   }
end;

//----------------------------------------------------------------------------//

function ConnectToNowHost: boolean;
begin
 { if (not CreatedNowHostdb) and (not CreateNowHostDatabase(NowGlobalSettings.Alias)) then
    Result := false
  else if (not IsNowHostConnected) and (not ConnectToNowHostDatabase) then
    Result := false
  else
    Result := true         }
end;

//----------------------------------------------------------------------------//

{function ConnectedToPc(OtherConnection : boolean) : boolean;
var
  Allias : string;
begin
  Allias := IniAppGlobals.PCAlias;

  if (not CreatedPcdb) and (not CreatePcDatabase(Allias)) then
    Result := false
  else if (not IsPcConnected) and (not ConnectToPcDatabase) then
    Result := false
  else
    Result := true
end;  }

//----------------------------------------------------------------------------//

function GetLoopTime : double;
begin
  Result := FSrvLoad.m_LoopTime;
end;

//----------------------------------------------------------------------------//

Procedure ProgramTerminated;
begin
  with FSrvLoad do
  begin
    IConfig.Enabled := false;
    IService.Enabled := false;
//    BtnStartStop.Enabled := false;
    PGCmain.TabIndex := 1;
    IExit.Enabled := true;
  end;
end;

//----------------------------------------------------------------------------//

//procedure CleanConnectionHost;
//begin
  // this function call to create again the connection in order to Relock the file on the host.
  // Avi/Eran october 08 2006 (preparing version 2_0_0_3_15);
//  CreateHostDatabase(IniAppGlobals.Alias);
//end;

//----------------------------------------------------------------------------//

procedure SetRunStatus(Stat : string);
begin
  FSrvLoad.SetRunStatus(Stat);
end;

//----------------------------------------------------------------------------//

procedure UpdateOperation(str: string);
begin
  with FSrvLoad do
  begin
    while m_opLock do;
    m_opLock := true;
    m_operation := str;
    m_opLock := false;
    PostMessage(FSrvLoad.Handle, CM_UPDATE, OPI_UpdStr, StrToInt(IniAppGlobals.Identifier))
  end
end;

//----------------------------------------------------------------------------//

procedure StopCycle;
begin
//  FSrvLoad.BtnStartStop.Caption := _('Start transfer cycle');
end;

//----------------------------------------------------------------------------//

procedure UpdateWaitingTime(RestTime : TDatetime);
var
  Hour, Min, Sec, MSec : Word;
begin
  with FSrvLoad do
  begin
    DecodeTime(RestTime ,Hour, Min, Sec, MSec);
    m_RestHour := Hour;
    m_RestMin := Min;
    m_RestSec := Sec;
    PostMessage(FSrvLoad.Handle, CM_UPDATE, OPI_TIME_WAIT, StrToInt(IniAppGlobals.Identifier));
    if IniAppGlobals.OperateWaitingTimeUploadDnld = '1' then
       UpdateOperation(_('waiting for NOW to complete the upload process'));
  end;
end;

//----------------------------------------------------------------------------//

procedure UpdateStatuseBtn(Status : boolean; ExitBtn : boolean);
begin
//  if AutoBtn then
//    FSrvLoad.BtnStartStop.Enabled := Status
//  else
  FSrvLoad.EnabledBtns(Status);
  FSrvLoad.IExit.Enabled := ExitBtn;
end;

//----------------------------------------------------------------------------//

procedure UpdateError(sl: TStringList);
var i : integer;
  s   : string;
begin
  with FSrvLoad do
  begin
    while m_opLock do;
    m_opLock  := true;
    if not Assigned(m_errList) then
      m_errList := TStringList.Create
    else
      m_errList.Clear;
    m_errList.AddStrings(sl);
    s := '';
    for i := 0 to sl.Count - 1 do
    begin
      s := s + sl.Strings[i];
      if i < sl.Count - 1 then s := s + ', ';
    end;
    WriteToLog('Error', s, true);
    m_opLock  := false;
    PostMessage(FSrvLoad.Handle, CM_UPDATE, OPI_UpdErr, StrToInt(IniAppGlobals.Identifier));
  end
end;

//----------------------------------------------------------------------------//

function WriteToLog(op: String; s: String; deleteOld: boolean): boolean;
var
  tbInfo : ^TTblInfo;
  qry    : TMqmQuery;
begin
  Result := true;
  qry := nil;
  try
    if IsOperating then
    begin
      qry := ThreadCreateQuery(Cfg_DB);
      Qry.Transaction := ThreadCreateTransaction(Cfg_DB);
    end
    else
    begin
      qry := CreateQuery(Cfg_DB);
      Qry.Transaction := CreateTransaction(Cfg_DB);
    end;

    Qry.Transaction.StartTransaction;

    tbInfo := @tblInfo[tbl_cfg_SrvLoad_Log];

    // Delete log records older than 24 hours
    if deleteOld then
    begin
      qry.SQL.Clear;
      qry.SQL.Add(SqlDeleteLog(tbInfo.GetTableName, CreateFld(tbInfo.pfx, fli_CurrDtTime)));
      qry.ExecSQL;
    end;
    // Write log record
    qry.SQL.Clear;
    qry.SQL.Add('insert into ' + tbInfo.GetTableName + '(');
    qry.SQL.Add(CreateFld(tbInfo.pfx, fli_CurrDtTime)+ ', ');
    qry.SQL.Add(CreateFld(tbInfo.pfx, fli_Operation) + ', ');
    qry.SQL.Add(CreateFld(tbInfo.pfx, fli_Text) + ', ');
    qry.SQL.Add(CreateFld(tbInfo.pfx, fli_IDENTIFIER));
    qry.SQL.Add(') values (');
    qry.SQL.Add('CURRENT_TIMESTAMP, ');
    qry.SQL.Add(QuotedStr(op) + ', ');
    qry.SQL.Add(QuotedStr(s) + ',');
    qry.SQL.Add(IniAppGlobals.Identifier);
    qry.SQL.Add(')');
    qry.ExecSQL;
    qry.Transaction.commit;
    qry.Free;
  except
    on E: Exception do
    begin
      Result := false;
      if Assigned(qry) then
        qry.Free;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFSrvLoad.Timer1Timer(Sender: TObject);
var
  ThCheck : TChekingThread;
begin

  if (Iniappglobals.StartCheck = '') or (Iniappglobals.EndCheck = '') then
  begin
    Iniappglobals.StartCheck := '7';
    Iniappglobals.EndCheck := '19';
  end;

  if ((Time > (1 / 24 / 60) * 60 * StrToInt(Iniappglobals.StartCheck))
  and (Time < (1 / 24 / 60) * 60 * StrToInt(Iniappglobals.EndCheck))) or m_OperationStarted then
  begin

    if not fConnected then
    begin
      Timer1.Enabled := False;
      UploadTimeTry := now;

      while True do
      begin
        if ((Now - UploadTimeTry) > (1 / 24 / 60 / 2)) then  //check every minute/2 for connection
        begin
          try
            if DMib.m_dbHost.Ping then break;
          except
            UploadTimeTry := Now;
            Continue;
          end;

          Inc(MinutesChecked);
          UploadTimeTry := Now;
          if MinutesChecked = 1 then
            StatusBar1.Panels[1].Text := 'Trying to reconnect : ' + IntToStr(MinutesChecked) +' minute'
          else
            StatusBar1.Panels[1].Text := 'Trying to reconnect : ' + IntToStr(MinutesChecked) +' minutes';
        end;
        Application.ProcessMessages;
        sleep(1000);
      end;

      if DMib.m_MainDB.Connected then
      begin
        WriteLogConnectionRepair(m_ConnectionRepairedetails, false, '0');
        try
          StatusBar1.Panels[1].Text := '';
          DMib.ConnectDB_Cfg(true);
          RegisterEvent(false);
          DMib.ConnectDB_main;
          DMib.ConnectDB_Arc;
          DMib.ConnectDB_Host;

          if m_OperationStarted then
          begin
            case GetTypeMode of
              TD_DownloadUploadToNow, TD_ProdAndUpload : MiDonwUploadClick(self);
              TD_OnlyProd : ILoadManualClick(self);
              TD_OnlyUpload : MiUploadClick(self);
              TD_DownLoadAfterUpload : MiUploadDonwClick(self);
            end;
          end;
        except

        end;
        //ShellExecute(Handle,nil, PChar(Application.ExeName),PChar('reset'),nil,1);
      end;
    end;

    ThCheck := TChekingThread.CreateChecking;
    ThCheck.Start;

  end;

end;

//----------------------------------------------------------------------------//

{function TFSrvLoad.CheckServerDoubleInstance : boolean;
var
  qry : Tmqmquery;
  tbInfo: ^TTblInfo;
begin
  Result := false;
  qry := CreateQuery(Cfg_DB);
  tbInfo := @tblInfo[tbl_cfg_exchg_wkst];

  qry.SQL.Text := 'Select CEW_OP, CEW_MACNUMBER from '+ tbInfo.GetTableName+' where CEW_IDENTIFIER = ' + IniAppGlobals.Identifier
    + ' and CEW_WKST_CODE = ' + QuotedStr('SERVER');
  qry.Open;

  if qry.FieldByName('CEW_MACNUMBER').AsString = '' then
    qry.Connection.ExecSQL('update '+ tbInfo.GetTableName+' set CEW_MACNUMBER = ' + QuotedStr(inttostr(GetLockCode) + GetLocalIP)
      + ' where CEW_IDENTIFIER = ' + IniAppGlobals.Identifier
      + ' and CEW_WKST_CODE = ' + QuotedStr('SERVER'))
  else
  begin

    if (qry.FieldByName('CEW_MACNUMBER').AsString <> (IntToStr(GetLockCode) + GetLocalIP)  ) then //diff lic and status -
    begin
      MessageDlg(_('MqmSrvLoad is running on another machine ! ') + #13#10 +
       _('The machine id it was running on is : ' + qry.FieldByName('CEW_MACNUMBER').AsString + ' The current machine id is ' + inttostr(GetLockCode) + GetLocalIP + ' ') + #13#10 +
       _('It is not allowed to run the same server load with the same identifier on more then one machine.') + #13#10 +
       _('application will be terminated') + ' ! ' , mtError, [mbOk] ,0);

      result := true;
      Application.Terminate;
    end;
  end;

  qry.Close;
  qry.Free;
end;   }

//----------------------------------------------------------------------------//

procedure TFSrvLoad.FormCreate(Sender: TObject);
var
  SRVLOAD_STARTING_NUMBER, SRVLOAD_Counter_number : Integer;
begin
  TranslateComponent (self);
  m_OperationStarted := false;
  IniAppGlobals.MySrvEvent := false;
  IniAppGlobals.MyPollingNumber := -1;
  SetConfigDwnMode;
  Caption := DBAppGlobals.MqmVersion + ' ' + IniAppGlobals.SrvNameUserDefine;
  Caption := Caption + ' ' + Application.ExeName;
//  if IniAppGlobals.DaysKeepHistory = '0' then
//     IniAppGlobals.DaysKeepHistory := '21';
  m_currOp  := OPI_idle;
  m_opLock  := false;
  m_DnwUploadOperated := false;
  m_LoopTime := SetLoopTime;
  m_errList := nil;
//  s_MsgHandle := Handle;
  s_MsgHandle := AllocateHWnd(WndProc);

  fConnected := DMib.m_dbHost.Connected;
  MinutesChecked := 0;

  if not CheckingActiveServers then
     Application.Terminate;

  if not fConnected then
  begin
    StatusBar1.Panels[0].Text := 'Database status : Disconnected';
    IService.Enabled := False;
  end
  else
  begin
    StatusBar1.Panels[0].Text := 'Database status : Connected';
    IService.Enabled := True;
  end;

  Timer1.Interval := StrToInt(IniAppglobals.CheckTimer) * 60000;//minute
  Timer1.Enabled := True;


  try
    DeleteOldRequest;
  except
  end;

  {$ifdef DEVMQMCM}
    //
  {$else}
    SP_SRVLOAD_OPEN;
  {$endif}

  SetRunStatus('0');
  try
    CHECK_PARAMS;
  except
  end;

  DecSep := ', ';

  if FormatSettings.DecimalSeparator = ',' then
      DecSep := '| ';
  m_ConnectionRepairedetails := TstringList.Create;
  if Iniappglobals.Upload_Download_disable = '1' then
  begin
    MiUploadDonw.Visible := False;
    MiDonwUpload.Visible := False;
  end;

end;

//----------------------------------------------------------------------------//

procedure TFSrvLoad.MiArchiveClick(Sender: TObject);
var
  SaveOldType : TDTypeMode;
begin
  m_DnwUploadOperated := false;
//  if (IniAppGlobals.Alias = '') then
//  begin
//    Showmessage(_(NO_ALLIAS_EXIST));
//    exit;
//  end;

  SaveOldType := GetTypeMode;
  SetOldType(SaveOldType);
  SetTypeMode(TD_OnlyArchivs);

//  if ConnectToHost then
//  begin
    EnabledBtns(false);
    StartLoadingManual(Handle);
//  end;
end;

//----------------------------------------------------------------------------//

procedure TFSrvLoad.SetConfigDwnMode;
begin
{  if IniAppGlobals.DwnTypeMode = '' then
     IniAppGlobals.DwnTypeMode := '0';
  case StrToInt(IniAppGlobals.DwnTypeMode) of
    0 : SetTypeMode(TD_AllFiles);
    1 : SetTypeMode(TD_OnlyProd);
    2 : SetTypeMode(TD_OnlyProg);
  end;

  if IniAppGlobals.DwnLoopWithMqmCg = '' then
     IniAppGlobals.DwnLoopWithMqmCg := '1';
  case StrToInt(IniAppGlobals.DwnLoopWithMqmCg) of
    0 : SetLoopMqmCG(true);
    1 : SetLoopMqmCG(false);
  end;   }

{  if IniAppGlobals.HostDateFormat = '' then
     IniAppGlobals.HostDateFormat := '0';
  case StrToInt(IniAppGlobals.HostDateFormat) of
    0 : SetDateTimeFormat(Frm_As400);
    1 : SetDateTimeFormat(Frm_TDateTimeExceptControl);
    2 : SetDateTimeFormat(Frm_TDateTime);
    3 : SetDateTimeFormat(Frm_DB2);
  end; }

{  if IniAppGlobals.LoginAuto = '' then
     IniAppGlobals.LoginAuto := '0';
  case StrToInt(IniAppGlobals.LoginAuto) of
    0 : SetAutoPassword(false);
    1 : SetAutoPassword(true);
  end; }

  SetDateTimeFormat(Frm_TDateTime);
  if (IniAppGlobals.downloadFrom = '2') then
  begin
    if (IniAppGlobals.ODBCDriverName = '3') then
    begin
      SetDateTimeFormat(Frm_As400);
      SetDndArchiveHostName(TD_AS_400)
    end
    else if (IniAppGlobals.ODBCDriverName = '1') then
      SetDndArchiveHostName(TD_Db2)
    else if (IniAppGlobals.ODBCDriverName = '2') then
      SetDndArchiveHostName(TD_Oracle)
    else if (IniAppGlobals.ODBCDriverName = '4') then
      SetDndArchiveHostName(TD_Db2OnAs400)
  end
  else if (IniAppGlobals.downloadFrom = '0') then
     SetDndArchiveHostName(TD_Db2)
  else if (IniAppGlobals.downloadFrom = '1') then
     SetDndArchiveHostName(TD_Oracle);

  if (IniAppGlobals.downloadFrom = '0') or (IniAppGlobals.downloadFrom = '1') then
     IniAppGlobals.PreparationExeName := LocAppGlobals.AppDir + 'NowMqmArc.exe';

  if (IniAppGlobals.downloadTo = '2') then
     SetDndArchiveLocalName(TD_Interbase)
  else if (IniAppGlobals.downloadTo = '0') then
     SetDndArchiveLocalName(TD_Db2)
  else if (IniAppGlobals.downloadTo = '1') then
     SetDndArchiveLocalName(TD_Oracle)

{  if IniAppGlobals.DndArchiveName = '' then
     IniAppGlobals.DndArchiveName := '0';
  case StrToInt(IniAppGlobals.DndArchiveName) of
    0 : SetDndArchiveName(TD_AS_400);
  //  1 : SetDndArchiveName(TD_PC_MqmDfn);
  end;    }

end;

//----------------------------------------------------------------------------//

procedure TFSrvLoad.FormDestroy(Sender: TObject);
begin
  try
    DestroyThread;
  if Assigned(m_errList) then
    m_errList.Free;
  except
  end;
end;

//----------------------------------------------------------------------------//

procedure TFSrvLoad.CMUpdate(var msg: TMessage);
begin
  if msg.LParam <> StrToInt(IniAppGlobals.Identifier) then exit;

  if msg.WParam = 2 then
  begin
    if IniAppGlobals.MySrvEvent then Exit;
       SET_SRVLOAD_POLLING_NUMBER(0);
  end;

  if msg.WParam = 5 then
  begin
    // download Request
    if not ThreadDestroied then
       Exit;
    DownloadRequestHandle;
  end;

//  if msg.LParam = 0 then
  if (msg.WParam = 2) or (msg.WParam = 5) then
  begin
    while m_opLock do;
    m_opLock := true;
    ClearLastSave;
    m_opLock := false;
    Invalidate
  end
  else if msg.WParam = OPI_UpdStr then
  begin
    while m_opLock do;
    m_opLock := true;
    LblTable.Caption := m_operation;
    m_opLock := false;
    Invalidate
  end
  else if msg.WParam = OPI_TIME_WAIT then
  begin
    while m_opLock do;
    m_opLock := true;
    LabelDownOp.Caption := GetStrTimeRest;
    m_opLock := false;
    Invalidate
  end
  else if msg.WParam = OPI_STOP then
  begin
    while m_opLock do;
    m_opLock := true;
    LabelDownOp.Caption := '';
    m_opLock := false;
    Invalidate
  end
  else if msg.WParam = OPI_Exit then
  begin
    while m_opLock do;
    m_opLock := true;

    //while not ThreadDestroied do;
    IExitClick(self);

    m_opLock := false;
  end
  else if msg.WParam = OPI_UpdErr then
  begin
    while m_opLock do;
    m_opLock := true;
    MmErrors.Lines.Clear;
    MmErrors.Lines := m_errList;
    if m_errList.Count > 0 then
      PGCmain.ActivePage := TBSerrRepo;
    m_errList.Clear;
    m_opLock := false;
    Invalidate
  end
  else if msg.WParam = OPI_Beep then
  begin
    while m_opLock do;
    m_opLock := true;
    m_opLock := false;
    Invalidate
  end
  else
  begin
    case m_currOp of
      OPI_FromHost: ShFromHost.Brush.Color := clRed;
      OPI_LocalSrv: ShLocal.Brush.Color     := clRed;
      OPI_ToHost:   ShToHost.Brush.Color   := clRed;
    end;

    m_currOp := msg.WParam;

    case m_currOp of
      OPI_FromHost: ShFromHost.Brush.Color := clLime;
      OPI_LocalSrv: ShLocal.Brush.Color     := clLime;
      OPI_ToHost:   ShToHost.Brush.Color   := clLime;
    end
  end
end;

//----------------------------------------------------------------------------//

procedure TFSrvLoad.BtnStartStopClick(Sender: TObject);
begin
{$ifndef demo}

  if IsOperating then
  begin
    StopOperating;
//    BtnStartStop.Caption := _('Start transfer cycle');
    EnabledBtns(true);
  end
  else if ConnectToHost then
  begin
    StartOperating(Handle);
//    BtnStartStop.Caption := _('Stop cycle');
    EnabledBtns(false);
    IExit.Enabled  := false;
  end
  else
    ShowMessage(_('No connection available'));

{$else}

  if IsOperating then
  begin
    StopOperating;
    ShFromHost.Brush.Color    := clRed;
    BtnStartStop.Caption := _('Start transfer cycle');
    EnabledBtns(true);
  end
  else if ConnectedToPc(false) then
  begin
    StartOperating(Handle);
    ShFromHost.Brush.Color    := clLime;
    BtnStartStop.Caption := _('Stop cycle');
    EnabledBtns(false);
    IExit.Enabled  := false;
  end
  else
    ShowMessage(_('No connection available'));

{$endif}

end;

//----------------------------------------------------------------------------//

procedure TFSrvLoad.IExitClick(Sender: TObject);
begin
  if IsOperating then
  begin
    StopOperating;
//sav    sleep(2000)
    while not ThreadDestroied do;
  end;

  if not IsOperating then
  begin
    if (not m_ByParm) and (IsCalendarLoaded = false) then
      begin
        if MessageDlg(_('No calendars have been loaded. Are you sure you want to close?'), mtWarning, [mbYes,mbNo], 0) in [mrNo] then
          exit;
       end;
    Close
  end;
end;

//----------------------------------------------------------------------------//

procedure TFSrvLoad.IConfigClick(Sender: TObject);
var
  FSrvSettings: TFSrvSettings;
begin
  FSrvSettings := TFSrvSettings.Create(Self);
  if FSrvSettings.ShowModal = mrOk then
  begin
    m_LoopTime := SetLoopTime;
    Caption := 'Mqm Server ' + DBAppGlobals.MqmVersion + '   ' + IniAppGlobals.SrvNameUserDefine;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFSrvLoad.EnabledBtns(Status : boolean);
begin
  IConfig.Enabled      := Status;
  IService.Enabled     := Status;
  MICalendars.Enabled  := Status;
  info1.Enabled        := Status;
//  BtnStartStop.Enabled := Status;
  IExit.Enabled        := Status;
end;

//----------------------------------------------------------------------------//

function TFSrvLoad.GetStrTimeRest : string;
var
  Hour, Min , Sec : string;
begin
  case m_RestHour of
    0 : Hour := '00';
    1 : Hour := '01';
    2 : Hour := '02';
    3 : Hour := '03';
    4 : Hour := '04';
    5 : Hour := '05';
    6 : Hour := '06';
    7 : Hour := '07';
    8 : Hour := '08';
    9 : Hour := '09';
  else
    Hour := IntToStr(m_RestHour);
  end;

  case m_RestMin of
    0 : Min := '00';
    1 : Min := '01';
    2 : Min := '02';
    3 : Min := '03';
    4 : Min := '04';
    5 : Min := '05';
    6 : Min := '06';
    7 : Min := '07';
    8 : Min := '08';
    9 : Min := '09';
  else
    Min := IntToStr(m_RestMin);
  end;

  case m_RestSec of
    0 : Sec := '00';
    1 : Sec := '01';
    2 : Sec := '02';
    3 : Sec := '03';
    4 : Sec := '04';
    5 : Sec := '05';
    6 : Sec := '06';
    7 : Sec := '07';
    8 : Sec := '08';
    9 : Sec := '09';
  else
    Sec := IntToStr(m_RestSec);
  end;

  if Min = '00' then
     Result := ' ' +  _('Delayed time') + ' ' + Min + ':' + Sec + ' ' + _('Seconds')
  else
    Result := ' ' +  _('Delayed time') + ' ' + Min + ':' + Sec + ' ' + _('Minutes');
 // Result := ' ' +  _('Next run in') + ' ' + Hour + ':' + Min + ':' + Sec + ' ' + _('hours');
end;

//----------------------------------------------------------------------------//

function TFSrvLoad.SetLoopTime : double;
begin
  Result := 0;
  if IniAppGlobals.TimeLoop = '' then
     IniAppGlobals.TimeLoop := '2';
  case StrToInt(IniAppGlobals.TimeLoop) of
    1 : Result := 1 / 24 / 60 * 0.5;     //  0.5 min
    2 : Result := 1 / 24 / 60 * 1;   // 1 min
    3 : Result := 1 / 24 / 60 * 2;   // 2 min
    4 : Result := 1 / 24 / 60 * 3;   // 3 min
    5 : Result := 1 / 24 / 60 * 4;    // 4 hour
    6 : Result := 1 / 24 / 60 * 5;    // 5 hour

{    1 : Result := 1 / 24 / 60 * 5;     //  5 min
    2 : Result := 1 / 24 / 60 * 15;   // 15 min
    3 : Result := 1 / 24 / 60 * 30;   // 30 min
    4 : Result := 1 / 24 / 60 * 45;   // 45 min
    5 : Result := 1 / 24 / 60 * 60;    // 1 hour
    6 : Result := 1 / 24 / 60 * 120;    // 2 hour
    7 : Result := 1 / 24 / 60 * 240;    // 4 hour    }
  end;
end;

//----------------------------------------------------------------------------//

procedure TFSrvLoad.DownloadRequestHandle;
var
  qry: TMqmQuery;
//  trs: TMqmTransaction;
  tbInfo: ^TTblInfo;
  DownLloadReq : string;
begin
  DownLloadReq := '';
//  trs := CreateTransaction(Cfg_DB, false);
  qry := CreateQuery(Cfg_DB);
  tbInfo := @tblInfo[tbl_cfg_exchg_SrvLoad];
//  qry.Transaction.StartTransaction;

  Qry.Transaction := CreateTransaction(Cfg_DB);
  Qry.Transaction.StartTransaction;

  with qry do
  begin
    Sql.Clear;
    Sql.add('Select * from ' + tbInfo.GetTableName);
    SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier)));
    Open;
    if not Eof then
      DownLloadReq := Trim(FieldByName(CreateFld(tbInfo.pfx, fli_downloadType)).AsString);
    Qry.Transaction.Commit;
    close;
  end;
//  Qry.Close;
  Qry.free;

  Sleep(5000);

  // only from client with default setting

  if DownLloadReq = 'DNLUPL' then       // Download/Upload
  begin
    SetTypeRequest(TD_Client);
    WriteToLog(_('Requested') ,  _('Download & Upload, requested by client.'), true);
    MiDonwUploadClick(self)
  end
  else if DownLloadReq = 'UPLDNL' then  // Upload/Download
  begin
    SetTypeRequest(TD_Client);
    WriteToLog(_('Requested') , _('Upload & Download, requested by client.'), true);
    MiUploadDonwClick(Self)
  end
  else if DownLloadReq = 'DOWNLD' then  // Download
  begin
    SetTypeRequest(TD_Client);
    WriteToLog(_('Requested') , _('Download, requested by client.'), true);
    ILoadManualClick(Self)
  end
  else if DownLloadReq = 'UPLOAD' then  // Upload (MQM_Upload)
  begin
    SetTypeRequest(TD_Client);
    WriteToLog(_('Requested') , _('Upload, requested by client.'), true);
    MiUploadClick(Self)
  end

  // running from Bach file/paramethers

  else if DownLloadReq = 'CLOSED' then // (Close server program)
    IExitClick(self)

  else if DownLloadReq = 'DUPALL' then // (MQM_Download_All_And_Upload)
  begin
    SetTypeRequest(TD_Scheduled);
    SetOldType(GetTypeMode);
    SetTypeChgFlag(true);
    setTypeChg(TD_AllFiles);
    WriteToLog(_('Requested') , _('Download All & Upload, requested by schedule.') , true);
    MiDonwUploadClick(self)
  end

  else if DownLloadReq = 'DUALCG' then // (MQM_Download_All_By_Changed_List_And_Upload)
  begin
    SetTypeRequest(TD_Scheduled);
    SetOldType(GetTypeMode);
    SetOldLoopMqmCG(GetLoopMqmCG);
    SetTypeChgFlag(true);
    setTypeChg(TD_AllFiles);
    SetSchedChgReqFlag(true);
    WriteToLog(_('Requested') , _('Download All By Changed List & Upload, requested by schedule.'), true);
    MiDonwUploadClick(self);
  end

  else if DownLloadReq = 'DNLUPS' then  // Download/Upload (MQM_Download_Production_And_Upload)
  begin
    SetTypeRequest(TD_Scheduled);
    SetOldLoopMqmCG(GetLoopMqmCG);
    SetOldType(GetTypeMode);
    SetTypeChgFlag(true);
    setTypeChg(TD_OnlyProd);
    WriteToLog(_('Requested') , _('Download Production & Upload, requested by schedule.') , true);
    MiDonwUploadClick(self)
  end

  else if DownLloadReq = 'CNGREQ' then  // Download/Upload Chenged Request (MQM_Download_Production_By_Changed_List_And_Upload)
  begin
    SetTypeRequest(TD_Scheduled);
    SetOldLoopMqmCG(GetLoopMqmCG);
    SetOldType(GetTypeMode);
    SetSchedChgReqFlag(true);
    WriteToLog(_('Requested') , _('Download Production By Changed List & Upload, requested by schedule.') , true);
    MiDonwUploadClick(self);
  end

  else if DownLloadReq = 'ONLYDN' then  // Download  (MQM_Download_Production)
  begin
    SetTypeRequest(TD_Scheduled);
    SetOldLoopMqmCG(GetLoopMqmCG);
    SetOldType(GetTypeMode);
    SetTypeChgFlag(true);
    setTypeChg(TD_OnlyProd);
    WriteToLog(_('Requested') , _('Download Production, requested by schedule.') , true);
    ILoadManualClick(self)
  end

  else if DownLloadReq = 'ONLYDC' then  // Download Chenged Request (MQM_Download_Production_By_Changed_LisT)
  begin
    SetTypeRequest(TD_Scheduled);
    SetOldLoopMqmCG(GetLoopMqmCG);
    SetOldType(GetTypeMode);
    SetSchedChgReqFlag(true);
    WriteToLog(_('Requested') , _('Download Production By Changed List, requested by schedule.') , true);
    ILoadManualClick(self);
  end

  else if DownLloadReq = 'ONLYAC' then  // Archive Only (MQM_Download_Archives)
  begin
    SetTypeRequest(TD_Scheduled);
    WriteToLog(_('Requested') , _('Download Archives, requested by schedule.') , true);
    MiArchiveClick(Self);
  end;

//  DeleteOldRequest;
//  trs.Free;
//  Qry.Close;
//  Qry.free;
end;

//----------------------------------------------------------------------------//

procedure TFSrvLoad.CHECK_PARAMS;
var
  I : Integer;
begin

{  for I := 1 to ParamCount do
  begin
    if (ParamStr(I) = 'LoadChgReq') or (ParamStr(I) = 'LoadAllReq') or (ParamStr(I) = 'UPLOAD') then
    begin
      m_ByParm := true;
      MiDonwUploadClick(Self);
      Exit;
    end
    else if (ParamStr(I) = 'LoadOnlyArc') or (ParamStr(I) = 'LoadArcOnly') then
    begin
      m_ByParm := true;
      MiArchiveClick(self);
      Exit;
    end
    else if (ParamStr(I) = 'Cycle') then
    begin
      BtnStartStopClick(Self);
      Exit;
    end
  end;  }

  for I := 1 to ParamCount do
  begin

    if (ParamStr(I) = 'LoadChgReq') or (ParamStr(I) = 'MQM_Download_Production_By_Changed_List_And_Upload') or //or (ParamStr(I) = 'LoadAllReq') then//or (ParamStr(I) = 'UPLOAD') then
       (ParamStr(I) = 'LoadAllReq') or (ParamStr(I) = 'MQM_Download_Production_And_Upload') or
       (ParamStr(I) = 'MQM_Download_All_And_Upload') or (ParamStr(I) = 'MQM_Download_All_By_Changed_List_And_Upload') then
    begin
      m_ByParm := true;
      MiDonwUploadClick(Self);
      Exit;
    end

    else if (ParamStr(I) = 'MQM_Download_Production_By_Changed_LisT') or (ParamStr(I) = 'MQM_Download_Production') then
    begin
      m_ByParm := true;
      ILoadManualClick(Self);
      Exit;
    end

    else if (ParamStr(I) = 'UPLOAD') or (ParamStr(I) = 'MQM_Upload') then
    begin
      m_ByParm := true;
      MiUploadClick(Self);
      Exit;
    end

    else if (ParamStr(I) = 'LoadOnlyArc') or (ParamStr(I) = 'LoadArcOnly') or (ParamStr(I) = 'MQM_Download_Archives') then
    begin
      m_ByParm := true;
      MiArchiveClick(self);
      Exit;
    end

    else if (ParamStr(I) = 'Cycle') then
    begin
      BtnStartStopClick(Self);
      Exit;
    end
  end;
end;

//----------------------------------------------------------------------------//

function TFSrvLoad.IsDnwUploadOperated : boolean;
begin
  Result := m_DnwUploadOperated;
end;

//----------------------------------------------------------------------------//

procedure TFSrvLoad.ILoadManualClick(Sender: TObject);
begin
  m_DnwUploadOperated := false;
{  if (IniAppGlobals.Alias = '') then
  begin
    Showmessage(_(NO_ALLIAS_EXIST));
    exit;
  end; }

//  if ConnectToHost then
//  begin
    if (IniAppGlobals.PreparationExeName <> '') then
       ConnectToNowHost;
    EnabledBtns(false);
    SetTypeMode(TD_OnlyProd);
    StartLoadingManual(Handle);
//  end;

end;

//----------------------------------------------------------------------------//

procedure TFSrvLoad.MiDloadPSClick(Sender: TObject);
begin
  m_DnwUploadOperated := false;

  if ConnectToHost then
  begin
    EnabledBtns(false);
    StartLoadingPS(Handle);
  end;
end;

//----------------------------------------------------------------------------//

procedure TFSrvLoad.IServiceClick(Sender: TObject);
begin
//  MiDloadPS.Visible   := true;
  ILoadManual.Visible := true;
  MiArchive.Visible   := true;
  info1.Enabled       := true;
  MICalendars.Visible := true
end;

//----------------------------------------------------------------------------//

procedure TFSrvLoad.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  UPDATE_ACCESS_OPERATION('SERVER', AT_Closed, Now);
  SP_SRVLOAD_CLOSE;
  SET_SRVLOAD_COUNTER_NUMBER(0);
end;

//----------------------------------------------------------------------------//

procedure TFSrvLoad.MiUploadDonwClick(Sender: TObject);
begin
  m_DnwUploadOperated := false;
  SetOldType(GetTypeMode);
  SetTypeMode(TD_DownLoadAfterUpload);
  EnabledBtns(false);
  StartExchDataSeq(Handle);
end;

end.

