unit FMsplash;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, jpeg, ComCtrls, Gauges,UMDbFunc,UMTblDesc, UMCommon, gnugettext, UReShape;

type
  TSplashForm = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Label2: TLabel;
    LblVersion: TLabel;
    Label4: TLabel;
    StDb: TStaticText;
    StSrv: TStaticText;
    OpenDialogDB: TOpenDialog;
    StStatus: TLabel;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
   // function CheckServerConnection : boolean;
  public
    ProgBar: TMqmProgBar;
  protected
    procedure UpdateRequested(var msg: TMessage); message MSG_UPDATE;
  end;

  procedure CloseSplash;

var
  SplashForm: TSplashForm;

implementation

{$R *.DFM}
uses
  UMglobal,DMsrvPc,UMStoredProc;

//----------------------------------------------------------------------------//

procedure TSplashForm.FormCreate(Sender: TObject);
begin
  TranslateComponent (self);
  SplashForm := self;
  s_MsgHandle := Handle;
 // Panel1.Color := 16758380;

{$ifdef MCM}
  label1.Caption := 'Machine Capacity Management';
  label1.Left := label1.Left - 20;
{$endif}

//{$ifdef customer}
//  LblDb.Visible  := false;
//  StDb.Visible   := false;
//  LblSrv.Visible := false;
//  StSrv.Visible  := false;
//{$endif}

//  lblRelease.Caption := AppGlobals.MqmVersion;
{
  if DBAppGlobals.Customer <> '' then
    Customer.Caption := DBAppGlobals.Customer
  else
  begin
    Customer.Visible := false;
    Licence.Visible := false
  end;
}
{$ifndef CUST_RELE}
//  LblType.Visible := true;
  {$ifdef DEV_RELE}
//    LblType.Caption := AppGlobals.MqMVersion;
  {$else}
//    LblType.Caption := 'MqMSched';
  {$endif}
  {$ifdef SHIFT_CAL}
//    LblType.Caption := LblType.Caption + ' (SHIFT CAL)';
  {$endif}
{$endif}

{$ifdef VELA}
  Image1.Picture.LoadFromFile((LocAppGlobals.AppDir + LocAppGlobals.ImgDir + '\Vela2.bmp'));
  Label2.Visible := false;
{$endif}


  Image1.Picture.LoadFromFile((LocAppGlobals.AppDir + LocAppGlobals.ImgDir + '\LogoDatatex3.bmp'));
  Label2.Visible := false;

  LblVersion.Caption := DBAppGlobals.MqmVersion;

  //Label1.Font.Color := $0004DA6FF;

 { if SrvIsOn(Main_DB) then
    StSrv.Caption := _('running')
  else
    StSrv.Caption := _('not found');  }

//  StDb.Caption := GetMqmDbName(Main_DB);
{  if SrvFoundDb(Main_DB) then
    StDb.Color := clInfoBk
  else
  begin
    StDb.Color := clRed; }
//    CreateDataBase;
//    if (not SrvIsOn) or (not SrvFoundDb) then
//      showmessage(_('Program will be terminated'));

//  end;

  ProgBar := TMqmProgBar.Create(self);
  with ProgBar do
  begin
    Parent := Self;
    Enabled := false;
    Top := StStatus.Top - 3;
    Left := StStatus.Left + StStatus.Width + 20;
    Width := 200;
    Height := 20;
    TickStyle := tsNone;
    Color := $00858585;
    StyleName := 'Datatex1';
    //Anchors := [AkRight, akBottom];
  //  SliderVisible := false;
  end;

end;

//----------------------------------------------------------------------------//

procedure TSplashForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;       // really close; don't just hide
end;

//----------------------------------------------------------------------------//

procedure TSplashForm.UpdateRequested(var msg: TMessage);
var
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
  Counter: integer;
  WSFound : boolean;
begin
  if msg.LParam <> StrToInt(IniAppGlobals.Identifier) then exit;
  if msg.WParam = 2 then
  begin
    if not IniAppGlobals.WkstCodeSelected then exit;

    qry := CreateQuery(Cfg_DB);
    tbInfo := @tblInfo[tbl_cfg_exchg_wkst];
    Qry.Transaction := CreateTransaction(Cfg_DB);
    Qry.Transaction.StartTransaction;

    // single UPDATE toggles counter, no SELECT lock needed
    qry.SQL.Add('update ' + tbInfo.GetTableName);
    qry.SQL.Add(' set ' + CreateFld(tbInfo.pfx, fli_COUNTER) + ' = CASE WHEN ' + CreateFld(tbInfo.pfx, fli_COUNTER) + ' = 0 THEN 1 WHEN ' + CreateFld(tbInfo.pfx, fli_COUNTER) + ' IS NULL THEN 1 ELSE 0 END');
    qry.SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + ' = ''' + IniAppGlobals.WkstCode + '''');
    qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
    qry.ExecSQL;
    WSFound := (qry.RowsAffected > 0);
    qry.Transaction.Commit;
    qry.Close;
    qry.Free;

    if not WSFound then
      CHECK_STATION_EXIST_AND_INSERT(IniAppGlobals.WkstCode);
  end;
end;

procedure CloseSplash;
begin
  if Assigned(SplashForm) then
    SplashForm.Free
end;

//----------------------------------------------------------------------------//

procedure TSplashForm.FormDestroy(Sender: TObject);
begin
  SplashForm := nil;

end;

procedure TSplashForm.FormShow(Sender: TObject);
begin
  Panel1.Color := $00858585;
  SplashForm.Color := $00858585;
  ReShape(Self);
end;

end.
