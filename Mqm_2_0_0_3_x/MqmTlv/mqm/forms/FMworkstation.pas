unit FMworkstation;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  cxButtons,
  StdCtrls, Buttons, gnugettext, ExtCtrls, UReShape, cxGraphics, dxUIAClasses,
  cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus;

type

  TMWkst = class(TForm)
    LblSelect: TLabel;
    LblPassword: TLabel;
    Bevel1: TBevel;
    Timer: TTimer;
    EdPswd: TEdit;
    cboxListWrkst: TComboBox;
    ElComboBoxIdentifier: TComboBox;
    LblIdentifier: TLabel;
    BtnApply: TCXButton;
    procedure FormCreate(Sender: TObject);
    procedure BtnApplyClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnAbortClick(Sender: TObject);
    procedure cboxListWrkstKeyPress(Sender: TObject; var Key: Char);
    procedure BtnAboClick(Sender: TObject);
    procedure PanelIdentifierClick(Sender: TObject);
    procedure ElComboBoxIdentifierChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    m_errCnt: integer;
    m_Paramether_Correct : boolean;
    function  AcceptPassword: integer;
    procedure LoadCaptions;
    Procedure LoadStations;
  end;

  function GetPassword: boolean;
  function WaitToConnect: boolean;

implementation

uses
  UMGlobal,
  UMCommon,
  DMsrvPc,
  UMTblDesc,
  UMStoredProc;

resourcestring
  STR_PSW_LOGERR = 'Wrong password';
  STR_PSW_CAPT   = 'Local workstation selection';
  STR_PSW_WKCODE = 'Workstation code';
  STR_PSW_PSW    = 'Password';
  STR_PSW_APPLY  = 'Apply';

const
  PSW_OK    = 0;
  PSW_RETRY = 1;
  PSW_ABORT = 2;

type

  TMWorkStation = class
    avail:  boolean;
    CODWRK: string;
    DESWRK: string;
    WPSWRD: string;
  end;

  TRecIdentifier = record
    Identifier  : Integer;
    Description : string;
  end;
  PTRecIdentifier = ^TRecIdentifier;

{$R *.DFM}

// -------------------------------------------------------------------------- //

function WaitToConnect: boolean;
var
  qry: TMqmQuery;
begin
  Result := true;
  qry := CreateQuery(Cfg_DB);

  // check to see if the database is ok
  qry.SQL.Add('select *  from ' + tblInfo[tbl_cfg_exchg_glob].GetTableName);
  qry.SQL.Add(WHERE_IDF_Condition(CreateFld(tblInfo[tbl_cfg_exchg_glob].pfx, fli_Identifier)));

  qry.Open;
  if qry.FieldByName('CEG_SL_OP').AsString = 'E' then
  begin
    ShowMessage(_('No database data available'));
    Result := false;
  end;

  if Result and (qry.FieldByName('CEG_SL_OP').AsString = 'W') then
  begin
    ShowMessage(_('Server load is writing , please try later'));
    Result := false
  end;

  qry.Close;

  qry.Free;
end;

// -------------------------------------------------------------------------- //

function GetPassword: boolean;
var
  Wrkst: TMWkst;
begin
  Wrkst := TMWkst.Create(Application);
  if ParamCount > 0 then
  begin
    if Wrkst.m_Paramether_Correct then
    begin
      Wrkst.close;
      Result := true;
      Exit
    end
    else
    begin
      Result := false;
      Exit
    end;
  end;

  if Wrkst.ShowModal = idOk then
    Result := true
  else
    Result := false
end;

// -------------------------------------------------------------------------- //

procedure TMWkst.FormCreate(Sender: TObject);
var
  qryMain: TMqmQuery;
  WorkStation:  TMWorkStation;
  tbInfo:      ^TTblInfo;
//  sl:           TStringList;
  pos, rowNum:  integer;
  CounterList   : TList;
  Station       : string;
//  RecCounterStation : PTRecCounterStation;
  RecIdentifier : PTRecIdentifier;

  I : Integer;
  Counter : Integer;
  ActiveWorkStation : boolean;
  WSCode, Passwd : string;
  FoundStation : boolean;
begin
  TranslateComponent (self);
  //qry := CreateQuery(Cfg_DB);
  qryMain := CreateQuery(Main_DB);
  qryMain.Transaction := CreateTransaction(Main_DB);
  qryMain.Transaction.StartTransaction;

  m_Paramether_Correct := false;
  CounterList := TList.Create;

  // check the identifier

  rowNum := 0;
  tbInfo := @tblInfo[tbl_Identifiers];
  qryMain.SQL.Clear;
  qryMain.SQL.Add('select * from ' + tbInfo.GetTableName);
  qryMain.Open;
  while not qryMain.EOF do
  begin
    new(RecIdentifier);
    RecIdentifier.Identifier := StrToInt(qryMain.FieldByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsString);
    RecIdentifier.Description := qryMain.FieldByName(CreateFld(tbInfo.pfx, fli_SDescr)).AsString;
    CounterList.add(RecIdentifier);
    Inc(rowNum);
    qryMain.Next
  end;
  qryMain.Transaction.Commit;
  qryMain.Close;
  qryMain.free;

  if rowNum <= 1 then
  begin
    ElComboBoxIdentifier.Visible := false;
    LblIdentifier.Visible := false
  end
  else
  begin
    for pos := 0 to CounterList.Count - 1 do
    begin
      ElComboBoxIdentifier.Items.Add(PTRecIdentifier(CounterList[pos]).Description);
      ElComboBoxIdentifier.Items.Objects[pos] := CounterList[pos];
    end;

    for pos := 0 to CounterList.Count-1 do
      if PTRecIdentifier(CounterList[pos]).Identifier = StrToInt(IniAppGlobals.Identifier) then
      begin
        ElComboBoxIdentifier.ItemIndex := pos;
        break
      end;

  end;

  CounterList.Clear;

  LoadCaptions;
  LoadStations;

  ReShape(Self);

end;

procedure TMWkst.FormShow(Sender: TObject);
begin
  cboxListWrkst.SelLength := 0;
  EdPswd.SetFocus;
end;

// -------------------------------------------------------------------------- //


procedure TMWkst.LoadCaptions;
begin
  Caption             := STR_PSW_CAPT;
  LblSelect.Caption   := STR_PSW_WKCODE;
  LblPassword.Caption := STR_PSW_PSW;
  BtnApply.Caption    := STR_PSW_APPLY
end;

// -------------------------------------------------------------------------- //

Procedure TMWkst.LoadStations;
type
  TRecCounterStation = record
    Counter : integer;
    Station : string;
  end;
  PTRecCounterStation = ^TRecCounterStation;
var
  qry:          TMqmQuery;

  WorkStation:  TMWorkStation;
  tbInfo:      ^TTblInfo;
  sl:           TStringList;
  pos:           integer;
  CounterList   : TList;
  Station       : string;
  RecCounterStation : PTRecCounterStation;
  I : Integer;
  Counter : Integer;
  ActiveWorkStation : boolean;
  WSCode, Passwd : string;
  FoundStation : boolean;
  SELECTED_ID, SqlStr : string;
  DisconnectedList : TStringList;
begin
  DisconnectedList := TStringList.Create;
  qry := CreateQuery(Cfg_DB);
  Qry.Transaction := CreateTransaction(Cfg_DB);
  Qry.Transaction.StartTransaction;

  CounterList := TList.Create;
  sl := TStringList.Create;
  cboxListWrkst.Items.Clear;
  tbInfo := @tblInfo[tbl_cfg_exchg_wkst];
  qry.SQL.Clear;
  qry.SQL.Add('select * from ' + tbInfo.GetTableName);
  qry.SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.Open;
  while not qry.EOF do
  begin
    new(RecCounterStation);
    RecCounterStation.Station := qry.FieldByName(CreateFld(tbInfo.pfx, fli_wkstCode)).AsString;
    if qry.FieldByName(CreateFld(tbInfo.pfx, fli_COUNTER)).IsNull then
      RecCounterStation.Counter := -1
    else
      RecCounterStation.Counter := qry.FieldByName(CreateFld(tbInfo.pfx, fli_COUNTER)).AsInteger;
    CounterList.Add(RecCounterStation);
    qry.Next;
  end;

  qry.Transaction.Commit;
  qry.Close;
  qry.Free;

  {$ifdef DEVMQMCM}
  {$else}
    SP_ASK_POLL;
  {$endif}

  Application.ProcessMessages;

  Sleep(2000);

  qry := CreateQuery(Cfg_DB);
  Qry.Transaction := CreateTransaction(Cfg_DB);
  Qry.Transaction.StartTransaction;
  qry.SQL.Clear;

  SELECTED_ID := IniAppGlobals.Identifier;
  if not ElComboBoxIdentifier.Visible then
    qry.SQL.Add('select * from ' + tbInfo.GetTableName + WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)))
  else
  begin
    SELECTED_ID := IntToStr(PTRecIdentifier(ElComboBoxIdentifier.Items.Objects[ElComboBoxIdentifier.ItemIndex]).Identifier);
    qry.SQL.Add('select * from ' + tbInfo.GetTableName + ' WHERE ' + CreateFld(tbInfo.pfx, fli_IDENTIFIER) + ' = ' + QuotedStr(SELECTED_ID) + ' ');
  end;

  qry.Open;
  while not qry.EOF do
  begin
    Station := qry.FieldByName(CreateFld(tbInfo.pfx, fli_wkstCode)).AsString;
    if qry.FieldByName(CreateFld(tbInfo.pfx, fli_COUNTER)).IsNull then
      Counter := 0
    else
      Counter := qry.FieldByName(CreateFld(tbInfo.pfx, fli_COUNTER)).AsInteger;
    ActiveWorkStation := true;
    for I := 0 to CounterList.Count - 1 do
    begin
      if (Station = PTRecCounterStation(CounterList[I]).Station) then
      begin
        if (PTRecCounterStation(CounterList[I]).Counter = Counter) then
           ActiveWorkStation := false;
        break;
      end;
    end;
    if ActiveWorkStation then
      sl.Add(Station)
    else //SP_DISCONNECT(Station);
    begin
      DisconnectedList.add(Station);
    end;
    qry.Next;
  end;

  Qry.Transaction.commit;

 // for I := 0 to DisconnectedList.Count - 1 do
 //    SP_DISCONNECT(DisconnectedList.Strings[I]);

//  DisconnectedList.Free;

  // load the workstations infos
{  try
    qry.SQL.Clear;
    qry.SQL.Add('select ' + CreatePfxFld(fli_wkstCode) + ' from ' + tbInfo.PCname);
    qry.Open;
    while not qry.EOF do
    begin
      sl.Add(qry.FieldByName(CreatePfxFld(fli_wkstCode)).AsString);
      qry.Next
    end;
  finally
    qry.Transaction.Commit;
    qry.Close;
    qry.Free;
    trs.Free
  end;     }

  m_errCnt := 1;


  tbInfo := @tblInfo[tbl_wkst];
  qry.Free;
  qry := CreateQuery(Main_DB);
  Qry.Transaction := CreateTransaction(Main_DB);
  Qry.Transaction.StartTransaction;
  qry.SQL.Clear;

  // load all workstation data
  try
    qry.SQL.Add('select * from ' + tbInfo.GetTableName);

    if DBAppGlobals.MCM_App then
      qry.SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_WorkStationType) + '=''' + '1' + '''')
    else
      qry.SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_WorkStationType) + '=''' + '0' + '''');

    qry.SQL.Add(' AND ' + CreateFld(tbInfo.pfx, fli_IDENTIFIER) + ' = ' + QuotedStr(SELECTED_ID) + ' ');

    qry.Open;
    while not qry.EOF do
    begin

    //  if qry.FieldByName(CreateFld(tbInfo.pfx, fli_WorkStationType)).AsString = '1' then
    //  begin
    //    qry.Next;
    //    continue
    //  end;

      WorkStation := TMWorkStation.Create;

      if sl.IndexOf(qry.FieldByName(CreateFld(tbInfo.pfx, fli_wkstCode)).AsString) = -1 then
        WorkStation.avail := true
      else
        WorkStation.avail := false;

      with WorkStation do
      begin
        CODWRK := qry.FieldByName(CreateFld(tbInfo.pfx, fli_wkstCode)).AsString;
        WPSWRD := qry.FieldByName(CreateFld(tbInfo.pfx, fli_wkPasswd)).AsString;
        DESWRK := qry.FieldByName(CreateFld(tbInfo.pfx, fli_wkDescr)).AsString;

        if WorkStation.avail then
          pos := cboxListWrkst.Items.Add(DESWRK)
        else
          pos := cboxListWrkst.Items.Add('x>' + DESWRK)
      end;
      cboxListWrkst.Items.Objects[pos] := WorkStation;
      qry.Next
    end;

    Qry.Transaction.commit;

    tbInfo := @tblInfo[tbl_cfg_exchg_wkst];
    qry := CreateQuery(Cfg_DB);
    Qry.Transaction := CreateTransaction(Cfg_DB);
    Qry.Transaction.StartTransaction;
    qry.SQL.Clear;

    for pos := 0 to cboxListWrkst.Items.Count - 1 do
    begin
      if not TMWorkStation(cboxListWrkst.Items.Objects[pos]).avail then continue;
      begin
        SqlStr := 'update ' + tbInfo.GetTableName +
                  ' set '    + CreateFld(tbInfo.pfx, fli_OP)     + ' = ' + QuotedStr('-') +
                  ' where '  + CreateFld(tbInfo.pfx, fli_wkstCode) + ' = ''' + TMWorkStation(cboxListWrkst.Items.Objects[pos]).CODWRK + '''' +
                  AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier));
        qry.sql.Clear;
        qry.sql.Add(SqlStr);
        qry.ExecSQL;
      end;
    end;
    Qry.Transaction.commit;
    DisconnectedList.Free;

    // find the position of the workstation
    cboxListWrkst.ItemIndex := 0;
    for pos := 0 to cboxListWrkst.Items.Count-1 do
      if TMWorkStation(cboxListWrkst.Items.Objects[pos]).CODWRK = IniAppGlobals.WkstCode then
      begin
        cboxListWrkst.ItemIndex := pos;
        break
      end;

    BtnApply.Enabled := true;

    if ParamCount > 0 then
    begin
      WSCode := ParamStr(1);
      Passwd := ParamStr(2);

      cboxListWrkst.ItemIndex := 0;
      FoundStation := false;
      for pos := 0 to cboxListWrkst.Items.Count-1 do
        if TMWorkStation(cboxListWrkst.Items.Objects[pos]).CODWRK = WSCode then
         begin
        cboxListWrkst.ItemIndex := pos;
        FoundStation := true;
        break
      end;

      if not FoundStation then exit;

      EdPswd.Text := Passwd;
      if EdPswd.Text = TMWorkStation(cboxListWrkst.Items.Objects[pos]).WPSWRD then
      begin
        m_Paramether_Correct := true;
        IniAppGlobals.wkstCode := TMWorkStation(cboxListWrkst.Items.Objects[cboxListWrkst.ItemIndex]).CODWRK;
        IniAppGlobals.wkstDesc := TMWorkStation(cboxListWrkst.Items.Objects[cboxListWrkst.ItemIndex]).DESWRK;
        if ElComboBoxIdentifier.Visible then
          IniAppGlobals.Identifier := IntToStr(PTRecIdentifier(ElComboBoxIdentifier.Items.Objects[ElComboBoxIdentifier.ItemIndex]).Identifier);
      end;

    end;


  finally
  //  qry.Transaction.Commit;
    sl.Free;
    qry.Close;
    qry.Free;
  end;

end;

// -------------------------------------------------------------------------- //

procedure TMWkst.PanelIdentifierClick(Sender: TObject);
begin

end;

// -------------------------------------------------------------------------- //

procedure TMWkst.BtnApplyClick(Sender: TObject);
var
  res: integer;
begin
  res := AcceptPassword;
  if res = PSW_OK then
    ModalResult := mrOk
  else if res = PSW_ABORT then
    ModalResult := mrAbort
end;

procedure TMWkst.cboxListWrkstKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    BtnApplyClick(self);
end;

procedure TMWkst.ElComboBoxIdentifierChange(Sender: TObject);
begin
  LoadStations;
end;

// -------------------------------------------------------------------------- //

function TMWkst.AcceptPassword: integer;
var
  Password,wkstCode, wkstDesc: string;
begin
  if cboxListWrkst.ItemIndex = -1 then
  begin
    ShowMessage(_('Stations were not defined'));
    Result := PSW_ABORT;
    exit;
  end;

  Password := TMWorkStation(cboxListWrkst.Items.Objects[cboxListWrkst.ItemIndex]).WPSWRD;
  wkstCode := TMWorkStation(cboxListWrkst.Items.Objects[cboxListWrkst.ItemIndex]).CODWRK;
  wkstDesc := TMWorkStation(cboxListWrkst.Items.Objects[cboxListWrkst.ItemIndex]).DESWRK;

{$ifndef DEVELOP}
//  if (not TMWorkStation(cboxListWrkst.Items.Objects[cboxListWrkst.ItemIndex]).avail) or
  if (EdPswd.Text <> trim(Password)) then
  begin
    ShowMessage(STR_PSW_LOGERR);
    if m_errCnt = 3 then
      Result := PSW_ABORT
    else
      Result := PSW_RETRY;
    Inc(m_errCnt);
    exit
  end;
{$endif}

  IniAppGlobals.WkstCode := wkstCode;
  IniAppGlobals.WkstDesc := wkstDesc;
  if ElComboBoxIdentifier.Visible then
    IniAppGlobals.Identifier := IntToStr(PTRecIdentifier(ElComboBoxIdentifier.Items.Objects[ElComboBoxIdentifier.ItemIndex]).Identifier);
  Result := PSW_OK
end;

// -------------------------------------------------------------------------- //

procedure TMWkst.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i:   integer;
  wks: TMWorkStation;
begin
  // remove all the objects connected to the combo
  for i := 0 to cboxListWrkst.Items.Count-1 do
  begin
    wks := TMWorkStation(cboxListWrkst.Items.Objects[i]);
    wks.Free
  end;
  Action := caFree
end;

// -------------------------------------------------------------------------- //

procedure TMWkst.BtnAboClick(Sender: TObject);
begin
  Close
end;

procedure TMWkst.BtnAbortClick(Sender: TObject);
begin
  ModalResult := mrOk;
 // Close
end;

end.
