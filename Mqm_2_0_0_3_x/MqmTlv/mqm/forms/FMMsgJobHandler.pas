unit FMMsgJobHandler;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, CheckLst, UMCommon, UMSchedContFunc, UReShape,
  Vcl.ExtCtrls;

type

  TWSMsgTabSheet = class(TTabSheet)
  private
    m_ProdReq , m_Step , m_SubStep, m_ReProcess : string;
    m_Id : TschedId;
    Memo : TMemo;
    BtnAbort : TBitBtn;
    BtnChangeMsgStatus : TBitBtn;
  public
    constructor CreateViewTab(AOwner: TComponent; Id : TschedId; TabName : string;
                ProdReq : string; Step : string; SubStep : string;  ReProcess : string);
    procedure   ChangeStatusClick(Sender: TObject);
  end;

  TMsgJobHandling = class(TForm)
    PageCntrlMsg: TPageControl;
    TbMain: TTabSheet;
    Memo1: TMemo;
    CheckListBoxWS: TCheckListBox;
    BitBtnSndClose: TcxButton;
    BitBtnAbort: TcxButton;
    procedure BitBtnSndCloseClick(Sender: TObject);
    procedure PageCntrlMsgChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtnAbortClick(Sender: TObject);
  private
    m_WsList,m_WsListDesc, m_WSViewMsgList : TStringList;
    m_ProdReq , m_Step , m_SubStep, m_ReProcess : string;
    m_Id : TschedId;
    procedure IniWSCheckList;
    procedure BuildWSTabs;
    procedure UpdateJobMsgTabs(ActiveWS : string);
    { Private declarations }
  public
    constructor CreateMsgJobForm(AOwner : Tcomponent; id : TSchedId; ProdReq : string; Step : string; SubStep: string; ReProcess : string;
    WSList : TStringList; WSListDesc : TStringList; WSViewMsgList : TStringList);
    { Public declarations }
  end;

//var
//  MsgJobHandling: TMsgJobHandling;

  function UpdateJobMsgFromDB(ProgBar: TMqmProgBar; Status: TStaticText; OnStart : boolean) : boolean;
  procedure CreateMsgJobForm(Id : TschedId);

implementation

USES DMsrvPc,UMTblDesc,FMMainPlan,UMGlobal,FMbin, gnugettext, UMSchedCont,
     UMObjCont;

{$R *.dfm}

{ TMsgJobHandling }

//----------------------------------------------------------------------------//

procedure TMsgJobHandling.BitBtnAbortClick(Sender: TObject);
begin
  ModalResult := mrAbort;
  Close;
end;

procedure TMsgJobHandling.BitBtnSndCloseClick(Sender: TObject);
var
  qry: TMqmQuery;
  tbInfo: ^TTblInfo;
  str : string;
  I : integer;
  Lng : integer;
  LngOfLng : integer;
  Mult : integer;
  LastIndex : Integer;
  WorkStation : string;
  EmptyBox    : boolean;
  Save_Cursor : TCursor;
begin
  str := '';
  ModalResult := mrOk;
  for I := 0 to Memo1.Lines.Count - 1 do
  begin
    Lng := length(Memo1.Lines[I]);
    LngOfLng := 0;
    mult := 1;
    While (Lng >= mult) and (LngOfLng < 9) do
    begin
      LngOfLng := LngOfLng + 1;
      mult := mult * 10;
    end;
      if LngOfLng = 0 then
        str := str + '0' + Memo1.Lines[I]
      else
        str := str + intTostr(LngOfLng) + IntTostr(Lng) + Memo1.Lines[I];
  end;

  if str = '' then
  begin
    ShowMessage(_('Please fill in the messgase text'));
    ModalResult := mrNone;
    exit;
  end;

  EmptyBox := false;
  for I := 0 to CheckListBoxWS.Count - 1 do
  begin
    if CheckListBoxWS.Checked[I] then
    begin
      EmptyBox := true;
      break;
    end;
  end;

  if not EmptyBox then
  begin
     ShowMessage(_('Please select one or more work stations to send the message to'));
     ModalResult := mrNone;
     exit;
  end;

  Save_Cursor := Screen.Cursor;
  Screen.Cursor  := crAppStart;

  tbInfo := @tblInfo[tbl_Job_Massages];
  qry := CreateQuery(Main_DB);
  qry.Transaction := CreateTransaction(Main_DB);
  qry.Transaction.StartTransaction;

  for I := 0 to CheckListBoxWS.Count - 1 do
  begin
    if not CheckListBoxWS.Checked[I] then
      Continue;

    WorkStation := m_WsList.strings[I];

    with qry do
    begin

      SQL.Clear;
      SQL.add( 'select * from ' + tbInfo.GetTableName);
      SQL.add( 'where ');
      SQL.add(CreateFld(tbInfo.pfx, fli_preqNo) + ' = ' + QuotedStr(m_ProdReq) + ' AND ');
      SQL.add(CreateFld(tbInfo.pfx, fli_pstepId) + ' = ' + m_Step + ' AND ');
      SQL.add(CreateFld(tbInfo.pfx, fli_psubstId) + ' = ' + m_SubStep + ' AND ');
      SQL.add(CreateFld(tbInfo.pfx, fli_reprocNo) + ' = ' + m_ReProcess + ' AND (');
      SQL.add(CreateFld(tbInfo.pfx, fli_To_WorkStation) + ' = ' + QuotedStr(WorkStation) + ' And ' );
      SQL.add(CreateFld(tbInfo.pfx, fli_From_WorkStation) + ' = ' + QuotedStr(IniAppGlobals.WkstCode) + ')');
      SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier)));
      SQL.add( ' Order by ' + CreateFld(tbInfo.pfx, fli_index));
      if (IniAppGlobals.downloadTo = '0') or (IniAppGlobals.DownloadTo = '1') then
        sql.add(' desc' )
      else
        sql.add(' descending' );
      open;
      if not EOF then
      begin
       // last;
        LastIndex := fieldByName(CreateFld(tbInfo.pfx, fli_index)).AsInteger + 1;
      end
      else
        LastIndex := 0;

      SQL.Clear;
      SQL.add( 'Insert Into ' + tbInfo.GetTableName + '(');
      SQL.Add(CreateFld(tbInfo.pfx, fli_identifier) + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_preqNo) + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_pstepId) + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_psubstId) + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_reprocNo) + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_Index) + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_To_WorkStation) + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_From_WorkStation) + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_DateTime) + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_Status) + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_Messages) + ',');
      SQL.Add(CreateFld(tbInfo.pfx, fli_JobMsgEvent));
      SQL.Add(') values (');
      SQL.Add(IniAppGlobals.Identifier + ',');
      SQL.Add(QuotedStr(m_ProdReq) +  ',');
      SQL.Add(m_Step + ',');
      SQL.Add(m_SubStep + ',');
      SQL.Add(m_ReProcess + ',');
      SQL.Add(IntToStr(LastIndex) + ',');
      SQL.Add(QuotedStr(WorkStation) + ',');
      SQL.Add(QuotedStr(IniAppGlobals.WkstCode) + ',');
      SQL.Add('CURRENT_TIMESTAMP' + ' ,');
      SQL.Add(QuotedStr('1') + ',');
      SQL.Add(QuotedStr(str) + ',');
      SQL.Add(QuotedStr('1'));
      SQL.Add(')');
      ExecSQL;
    //  try
        Qry.Transaction.Commit;
    //  except

    //  end;
      GetPlanView.SendJobMsg;
      close;
    end;
  end;
  p_sc.MarkMsgForJobSent(m_id, true);

  if Assigned(FBin) then
  begin
    FBin.RefreshGrid;
    FBin.ChangeTabBinforChangeTabPlan;
  end;
  Qry.free;
  Screen.Cursor := Save_Cursor;
end;

//----------------------------------------------------------------------------//

constructor TMsgJobHandling.CreateMsgJobForm(AOwner : Tcomponent; id : TSchedId; ProdReq : string; Step : string; SubStep: string; ReProcess : string;
    WSList : TStringList; WSListDesc : TStringList; WSViewMsgList : TStringList);
var
  Save_Cursor : TCursor;
begin
  inherited create(AOwner);
  Save_Cursor := Screen.Cursor;
  Screen.Cursor  := crAppStart;
  m_id := id;
  m_WsList    := WsList;
  m_WsListDesc := WSListDesc;
  m_ProdReq   := ProdReq;
  m_Step      := Step;
  m_SubStep   := SubStep;
  m_ReProcess := ReProcess;

  caption := _('Handling message for ') + _('Request') + ' : ' + ProdReq + '   ' +
             _('Step') + ' : ' + Step + '   ' + _('Sub step') + ' : ' + SubStep + '   ' +
             _('Re process') + ' : ' + Reprocess;

  IniWSCheckList;

  if Assigned(WSViewMsgList) then
  begin
     m_WSViewMsgList := WSViewMsgList;
     BuildWSTabs;
  end;
  Screen.Cursor := Save_Cursor;

  ReShape(self);
end;

//----------------------------------------------------------------------------//

procedure TMsgJobHandling.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

//----------------------------------------------------------------------------//

procedure TMsgJobHandling.IniWSCheckList;
var
  I : Integer;
  WKcntr, WS : string;
  qry: TMqmQuery;
  tbInfo: ^TTblInfo;
begin
  WS := '';
  if (p_sc.GetVisbleInBin(m_id) = CSB_ReadOnly) then
  begin
    WKcntr := p_sc.GetFldDescr(M_Id, CSC_WkctCode, false);
    qry := CreateQuery(Main_DB);
    tbInfo := @tblInfo[tbl_wkst_wkc];
    with qry do
    begin
      SQL.Clear;
      SQL.add( 'select * from ' + tbInfo.GetTableName);
      SQL.add( ' where ');
      SQL.add(CreateFld(tbInfo.pfx, fli_wkCtrCode) + ' = ' + QuotedStr(WKcntr) + ' AND ');
      SQL.add(CreateFld(tbInfo.pfx, fli_TypeOfUse) + ' = ' + QuotedStr('1'));
      SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier)));
      open;
      if not eof then
         Ws := FieldByName(CreateFld(tbInfo.pfx, fli_wkstCode)).AsString;
      close;
      qry.free;
    end;
  end;

  for I := 0 to m_WsList.Count - 1 do
  begin
    CheckListBoxWS.Items.Add(m_WsList.Strings[I] + ' ' + m_WsListDesc.Strings[I]);
    if (m_WsList.Strings[I]) = WS then
       CheckListBoxWS.Checked[I] := true;
  end;

end;

//----------------------------------------------------------------------------//

procedure TMsgJobHandling.PageCntrlMsgChange(Sender: TObject);
begin
  if (TWSMsgTabSheet(PageCntrlMsg.ActivePage).Name <> 'TbMain') then
     UpdateJobMsgTabs(TWSMsgTabSheet(PageCntrlMsg.ActivePage).Caption);
end;

//----------------------------------------------------------------------------//

procedure TMsgJobHandling.UpdateJobMsgTabs(ActiveWS : string);
var
  qry: TMqmQuery;
  tbInfo: ^TTblInfo;
  str : string;
  MsgTabSheet : TWSMsgTabSheet;
  TotalLength, CurrentPosition, LngOfLength, Lng : Integer;
  LineText : string;
  FirstMsg : boolean;
  Save_Cursor : TCursor;
begin
  FirstMsg := true;
  Save_Cursor := Screen.Cursor;
  Screen.Cursor  := crAppStart;
  qry := CreateQuery(Main_DB);
  str := '';

  tbInfo := @tblInfo[tbl_Job_Massages];
  MsgTabSheet := TWSMsgTabSheet(PageCntrlMsg.ActivePage);
  MsgTabSheet.Memo.Lines.Clear;
  with qry do
  begin

    SQL.Clear;
    SQL.add( 'select * from ' + tbInfo.GetTableName);
    SQL.add( ' where ');
    SQL.add(CreateFld(tbInfo.pfx, fli_preqNo) + ' = ' + QuotedStr(m_ProdReq) + ' AND ');
    SQL.add(CreateFld(tbInfo.pfx, fli_pstepId) + ' = ' + m_Step + ' AND ');
    SQL.add(CreateFld(tbInfo.pfx, fli_psubstId) + ' = ' + m_SubStep + ' AND ');
    SQL.add(CreateFld(tbInfo.pfx, fli_reprocNo) + ' = ' + m_ReProcess + ' AND ');
    SQL.add(CreateFld(tbInfo.pfx, fli_To_WorkStation) + ' = ' + QuotedStr(IniAppGlobals.WkstCode));
    SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier)));
    open;
    if not EOF then
    begin
      while not eof do
      begin
        MsgTabSheet.BtnChangeMsgStatus.Caption := _('Mark as UnRead');
        MsgTabSheet.Highlighted := false;
        if fieldByName(CreateFld(tbInfo.pfx, fli_Status)).AsString = '1' then
        begin
          MsgTabSheet.BtnChangeMsgStatus.Caption := _('Mark as Read');
          MsgTabSheet.Highlighted := true;
          Break;
        end;
        Next;
      end;
      if not MsgTabSheet.BtnChangeMsgStatus.Visible then
         MsgTabSheet.BtnChangeMsgStatus.Visible := true;
    end;
    SQL.Clear;
    SQL.add( 'select * from ' + tbInfo.GetTableName);
    SQL.add( ' where ');
    SQL.add(CreateFld(tbInfo.pfx, fli_preqNo) + ' = ' + QuotedStr(m_ProdReq) + ' AND ');
    SQL.add(CreateFld(tbInfo.pfx, fli_pstepId) + ' = ' + m_Step + ' AND ');
    SQL.add(CreateFld(tbInfo.pfx, fli_psubstId) + ' = ' + m_SubStep + ' AND ');
    SQL.add(CreateFld(tbInfo.pfx, fli_reprocNo) + ' = ' + m_ReProcess + ' AND (');
    SQL.add(CreateFld(tbInfo.pfx, fli_To_WorkStation) + ' = ' + QuotedStr(ActiveWS) + ' OR ' );
    SQL.add(CreateFld(tbInfo.pfx, fli_From_WorkStation) + ' = ' + QuotedStr(ActiveWS) + ')');
    SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier)));
    SQL.add(' order by ' + CreateFld(tbInfo.pfx, fli_DateTime) + ' desc');
    open;

    if not EOF then
    begin
      while not Eof do
      begin

       if FirstMsg then
         FirstMsg := false
       else
       begin
         MsgTabSheet.Memo.Lines.add('');
       end;

        LineText := DateTimeToStr(fieldByName(CreateFld(tbInfo.pfx, fli_DateTime)).AsdateTime);
        MsgTabSheet.Memo.Lines.add(LineText);
//        MsgTabSheet.Memo.Lines.add('--------------------------');

        str := fieldByName(CreateFld(tbInfo.pfx, fli_Messages)).AsString;

        TotalLength := Length(str);
        CurrentPosition := 1;

        while CurrentPosition <= TotalLength do
        begin
          LngOfLength := StrToInt(copy(str,CurrentPosition, 1));
          CurrentPosition := CurrentPosition + 1;
          if LngOfLength = 0 then
          begin
            LineText := '';
            MsgTabSheet.Memo.Lines.add(LineText);
          end else
          begin
            Lng := StrToInt(copy(str,CurrentPosition, LngOfLength));
            CurrentPosition := CurrentPosition + LngOfLength;
            LineText := ('     ') + copy(str, CurrentPosition, Lng);
            CurrentPosition := CurrentPosition + Lng;
            MsgTabSheet.Memo.Lines.add(LineText);
          end;
        end;
        Next
      end;
    end;
  end;

  MsgTabSheet.Memo.SelStart := Perform(EM_LINEINDEX, 1, 0);
  MsgTabSheet.Memo.Perform(EM_SCROLLCARET, 1, 0);
  Screen.Cursor := Save_Cursor;

  Qry.Free;
end;

//----------------------------------------------------------------------------//

procedure TMsgJobHandling.BuildWSTabs;
var
  I : Integer;
begin
  for I := 0 to m_WSViewMsgList.Count - 1 do
  begin
    TWSMsgTabSheet.CreateViewTab(PageCntrlMsg, m_id, m_WSViewMsgList.Strings[I],m_ProdReq,m_Step,m_SubStep,m_ReProcess);
    m_WSViewMsgList.Strings[I] := Copy(m_WSViewMsgList.Strings[I], 2 , length(m_WSViewMsgList.Strings[I]))
  end;
end;

//----------------------------------------------------------------------------//

{ TWSMsgTabSheet }

procedure TWSMsgTabSheet.ChangeStatusClick(Sender: TObject);
var
  qry: TMqmQuery;
  tbInfo: ^TTblInfo;
  hdrCode, OldhdrCode : string;
  detCode, jobCode, ReprocNo, OldDetCode, OldJobCode, OldReprocNo : Integer;
  Id : TSchedId;
  IsHeaderDetFound, FoundOneJobMsg : boolean;
  Save_Cursor : TCursor;
begin
  Save_Cursor := Screen.Cursor;
  Screen.Cursor  := crAppStart;
  FoundOneJobMsg := false;
  qry := CreateQuery(Main_DB);
  qry.Transaction := CreateTransaction(Main_DB);
  qry.Transaction.StartTransaction;
  tbInfo := @tblInfo[tbl_Job_Massages];
  with qry do
  begin
    SQL.Clear;
    SQL.Add('update ' + tbInfo.GetTableName + ' set');
    SQL.Add(CreateFld(tbInfo.pfx, fli_status)                   + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_status)             + ', ');
    SQL.Add(CreateFld(tbInfo.pfx, fli_JobMsgEvent)              + '=');
    SQL.Add(':' + CreateFld(tbInfo.pfx, fli_JobMsgEvent)        + ' ');

    SQL.Add('where');
    SQL.add(CreateFld(tbInfo.pfx, fli_preqNo) + ' = ' + QuotedStr(m_ProdReq) + ' AND ');
    SQL.add(CreateFld(tbInfo.pfx, fli_pstepId) + ' = ' + m_Step + ' AND ');
    SQL.add(CreateFld(tbInfo.pfx, fli_psubstId) + ' = ' + m_SubStep + ' AND ');
    SQL.add(CreateFld(tbInfo.pfx, fli_reprocNo) + ' = ' + m_ReProcess + ' AND ');
    SQL.add(CreateFld(tbInfo.pfx, fli_To_WorkStation) + ' = ' + QuotedStr(IniAppGlobals.WkstCode) + ' And ' );
    SQL.add(CreateFld(tbInfo.pfx, fli_From_WorkStation) + ' = ' + QuotedStr(Caption));
    SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier)));

    if Highlighted then
    begin
//     p_sc.MarkMsgForJobGet(m_id, false);
      Highlighted := false;
      ParamByName(CreateFld(tbInfo.pfx, fli_status)).AsString := '0';
      BtnChangeMsgStatus.Caption := _('Mark as UnRead')
    end
    else
    begin
 //     p_sc.MarkMsgForJobGet(m_id, true);
      ParamByName(CreateFld(tbInfo.pfx, fli_status)).AsString := '1';
      Highlighted := true;
      BtnChangeMsgStatus.Caption := _('Mark as Read')
    end;
    ParamByName(CreateFld(tbInfo.pfx, fli_JobMsgEvent)).AsString := '1';
    ExecSQL;
    Transaction.Commit;
    GetPlanView.SendJobMsg;
    close;

    SQL.Clear;
    SQL.add( 'select * from ' + tbInfo.GetTableName);
    SQL.add( ' where ');
    SQL.add(CreateFld(tbInfo.pfx, fli_To_WorkStation) + ' = ' + QuotedStr(IniAppGlobals.WkstCode) + ' AND ');
    SQL.add(CreateFld(tbInfo.pfx, fli_Status) + ' = ' + QuotedStr('1') + ' AND ');
    SQL.add(CreateFld(tbInfo.pfx, fli_preqNo) + ' = ' + QuotedStr(m_ProdReq) + ' AND ');
    SQL.add(CreateFld(tbInfo.pfx, fli_pstepId) + ' = ' + m_Step + ' AND ');
    SQL.add(CreateFld(tbInfo.pfx, fli_psubstId) + ' = ' + m_SubStep + ' AND ');
    SQL.add(CreateFld(tbInfo.pfx, fli_reprocNo) + ' = ' + m_ReProcess);
    SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier)));
    open;
    if eof then
      p_sc.MarkMsgForJobGet(m_id, false)
    else
      p_sc.MarkMsgForJobGet(m_id, true);

    SQL.Clear;
    SQL.add( 'select * from ' + tbInfo.GetTableName);
    SQL.add( ' where ');
    SQL.add(CreateFld(tbInfo.pfx, fli_From_WorkStation) + ' = ' + QuotedStr(IniAppGlobals.WkstCode) + ' AND ');
    SQL.add(CreateFld(tbInfo.pfx, fli_Status) + ' = ' + QuotedStr('1') + ' AND ');
    SQL.add(CreateFld(tbInfo.pfx, fli_preqNo) + ' = ' + QuotedStr(m_ProdReq) + ' AND ');
    SQL.add(CreateFld(tbInfo.pfx, fli_pstepId) + ' = ' + m_Step + ' AND ');
    SQL.add(CreateFld(tbInfo.pfx, fli_psubstId) + ' = ' + m_SubStep + ' AND ');
    SQL.add(CreateFld(tbInfo.pfx, fli_reprocNo) + ' = ' + m_ReProcess);
    SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier)));
    open;
    if eof then
      p_sc.MarkMsgForJobSent(m_id, false)
    else
      p_sc.MarkMsgForJobSent(m_id, true);

    OldhdrCode  := '';
    OldDetCode  := -1;
    OldJobCode  := -1;
    OldReprocNo := -1;

    with qry do
    begin
      SQL.Clear;
      SQL.add( 'select * from ' + tbInfo.GetTableName);
      SQL.add( ' where ');
      SQL.add(CreateFld(tbInfo.pfx, fli_To_WorkStation) + ' = ' + QuotedStr(IniAppGlobals.WkstCode) + ' And ');
      SQL.add(CreateFld(tbInfo.pfx, fli_Status) + ' = ' + QuotedStr('1'));
      SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier)));
      open;
      while not EOF do
      begin
        hdrCode := Trim(FieldByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString);
        detCode := FieldByName(CreateFld(tbInfo.pfx, fli_pstepId)).AsInteger;
        jobCode := FieldByName(CreateFld(tbInfo.pfx, fli_psubstId)).AsInteger;
        ReprocNo := FieldByName(CreateFld(tbInfo.pfx, fli_reprocNo)).AsInteger;
        if (hdrCode = OldhdrCode) and (detCode = OlddetCode) and (jobCode = OldjobCode) and (ReprocNo = OldReprocNo) then
        begin
          Next;
          Continue;
        end;
        id := p_sc.FindProdSched(hdrCode, detCode, jobCode, ReprocNo, IsHeaderDetFound);
        if (id <> CSchedIDnull) and IsHeaderDetFound then
        begin
          FoundOneJobMsg := true;
          break;
        end;
        Next;
      end;
      close;
    end;
  end;
  if FoundOneJobMsg then
  begin
    if Assigned(FBin) then
       FBin.ActivateJobMsgButton;
  end
  else
    if Assigned(FBin) then
       FBin.DeActivateJobMsgButton;

  if Assigned(FBin) then
  begin
    FBin.RefreshGrid;
    FBin.ChangeTabBinforChangeTabPlan;
  end;

  Screen.Cursor := Save_Cursor;
  qry.Free;
end;

//----------------------------------------------------------------------------//

constructor TWSMsgTabSheet.CreateViewTab(AOwner: TComponent; Id : TschedId; TabName : string; ProdReq : string; Step : string; SubStep : string;  ReProcess : string);
var
  qry: TMqmQuery;
  tbInfo: ^TTblInfo;
begin
  inherited Create(AOwner);
  Assert(AOwner is TPageControl);
  PageControl := TPageControl(AOwner);
  m_id := Id;
  m_ProdReq   := ProdReq;
  m_Step      := Step;
  m_SubStep   := SubStep;
  m_ReProcess := ReProcess;
  Memo := TMemo.Create(self);
  Memo.Parent := self;
  Memo.left := 14;
  Memo.top  := 20;
  Memo.Width   := 400;
  Memo.Height  := 276;
  Memo.ScrollBars := ssboth;
  Memo.ReadOnly   := true;
  if Copy(TabName, 1 , 1) = '1' then
     Highlighted := true;

  Caption         := Copy(TabName, 2 , length(TabName));
  Memo.Color      := clYellow;

  BtnAbort := TBitBtn.Create(AOwner);
  BtnAbort.Parent := self;
  BtnAbort.left := 491;
  BtnAbort.top  := 321;
  BtnAbort.Width   := 80;
  BtnAbort.Height  := 25;
  BtnAbort.ModalResult := mrAbort;
  BtnAbort.Kind := bkAbort;

  BtnChangeMsgStatus := TBitBtn.Create(AOwner);
  BtnChangeMsgStatus.Parent := self;
  BtnChangeMsgStatus.left := 14;
  BtnChangeMsgStatus.top  := 321;
  BtnChangeMsgStatus.Width   := 120;
  BtnChangeMsgStatus.Height  := 25;
  BtnChangeMsgStatus.OnClick := ChangeStatusClick;
  BtnChangeMsgStatus.Caption := _('Mark as Read');

  qry := CreateQuery(Main_DB);
  tbInfo := @tblInfo[tbl_Job_Massages];

  with qry do
  begin
    SQL.Clear;
    SQL.add( 'select * from ' + tbInfo.GetTableName);
    SQL.add( 'where ');
    SQL.add(CreateFld(tbInfo.pfx, fli_preqNo) + ' = ' + QuotedStr(m_ProdReq) + ' AND ');
    SQL.add(CreateFld(tbInfo.pfx, fli_pstepId) + ' = ' + m_Step + ' AND ');
    SQL.add(CreateFld(tbInfo.pfx, fli_psubstId) + ' = ' + m_SubStep + ' AND ');
    SQL.add(CreateFld(tbInfo.pfx, fli_reprocNo) + ' = ' + m_ReProcess + ' AND ');
    SQL.add(CreateFld(tbInfo.pfx, fli_To_WorkStation) + ' = ' + QuotedStr(IniAppGlobals.WkstCode));
    SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier)));
//    SQL.add(CreateFld(tbInfo.pfx, fli_Status) + ' = ' + QuotedStr('1'));
    open;
    if EOF then
      BtnChangeMsgStatus.Visible := false;
    close;
  end;
  qry.Free;

end;

//----------------------------------------------------------------------------//

function UpdateJobMsgFromDB(ProgBar: TMqmProgBar; Status: TStaticText; OnStart : boolean) : boolean;
var
  qry: TMqmQuery;
  trs: TMqmTransaction;
  tbInfo: ^TTblInfo;
  hdrCode, OldhdrCode : string;
  detCode, jobCode, ReprocNo, OldDetCode, OldJobCode, OldReprocNo : Integer;
  id : TSchedId;
  IsHeaderDetFound : boolean;
  FoundReq : boolean;
begin
  Result := false;
  FoundReq  := false;
  qry := CreateQuery(Main_DB);

  tbInfo := @tblInfo[tbl_Job_Massages];

  if Assigned(ProgBar) then
    ProgBar.SetPosition(0);

  if Assigned(Status) then
    Status.Caption := _('Reading jobs messages ...');

  if Assigned(ProgBar) then
    ProgBar.SetMax(1500);

  with qry do
  begin
    OldhdrCode  := '';
    OldDetCode  := -1;
    OldJobCode  := -1;
    OldReprocNo := -1;

    SQL.Clear;
    SQL.add( 'select * from ' + tbInfo.GetTableName);
    SQL.add( ' where ');
    SQL.add(CreateFld(tbInfo.pfx, fli_To_WorkStation) + ' = ' + QuotedStr(IniAppGlobals.WkstCode) + ' And ');
    SQL.add(CreateFld(tbInfo.pfx, fli_Status) + ' = ' + QuotedStr('1'));

    if not OnStart then
    begin
      SQL.add( ' And ');
      SQL.add(CreateFld(tbInfo.pfx, fli_JobMsgEvent) + ' = ' + QuotedStr('1'));
    end;
    SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier)));
    open;
    while not EOF do
    begin
      hdrCode := Trim(FieldByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString);
      detCode := FieldByName(CreateFld(tbInfo.pfx, fli_pstepId)).AsInteger;
      jobCode := FieldByName(CreateFld(tbInfo.pfx, fli_psubstId)).AsInteger;
      ReprocNo := FieldByName(CreateFld(tbInfo.pfx, fli_reprocNo)).AsInteger;
      if (hdrCode = OldhdrCode) and (detCode = OlddetCode) and (jobCode = OldjobCode) and (ReprocNo = OldReprocNo) then
      begin
        Next;
        Continue;
      end;
      id := p_sc.FindProdSched(hdrCode, detCode, jobCode, ReprocNo, IsHeaderDetFound);
      if (id <> CSchedIDnull) and IsHeaderDetFound then
      begin
        result := true;
        FoundReq  := true;
        p_sc.MarkMsgForJobGet(id, true);
      end;

      OldhdrCode := hdrCode;
      OldDetCode  := DetCode;
      OldJobCode  := JobCode;
      OldReprocNo := ReprocNo;
      if Assigned(ProgBar) then
        ProgBar.SetPosition(RecNo);
      Application.ProcessMessages;
      Next;
    end;
    close;

    OldhdrCode  := '';
    OldDetCode  := -1;
    OldJobCode  := -1;
    OldReprocNo := -1;

    SQL.Clear;
    SQL.add( 'select * from ' + tbInfo.GetTableName);
    SQL.add( ' where ');
    SQL.add(CreateFld(tbInfo.pfx, fli_From_WorkStation) + ' = ' + QuotedStr(IniAppGlobals.WkstCode) + ' And ');
    SQL.add(CreateFld(tbInfo.pfx, fli_Status) + ' = ' + QuotedStr('1'));
    if not OnStart then
    begin
      SQL.add( ' And ');
      SQL.add(CreateFld(tbInfo.pfx, fli_JobMsgEvent) + ' = ' + QuotedStr('1'));
    end;
    SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier)));
    open;
    while not EOF do
    begin
      hdrCode := Trim(FieldByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString);
      detCode := FieldByName(CreateFld(tbInfo.pfx, fli_pstepId)).AsInteger;
      jobCode := FieldByName(CreateFld(tbInfo.pfx, fli_psubstId)).AsInteger;
      ReprocNo := FieldByName(CreateFld(tbInfo.pfx, fli_reprocNo)).AsInteger;
      if (hdrCode = OldhdrCode) and (detCode = OlddetCode) and (jobCode = OldjobCode) and (ReprocNo = OldReprocNo) then
      begin
        Next;
        Continue;
      end;
      id := p_sc.FindProdSched(hdrCode, detCode, jobCode, ReprocNo, IsHeaderDetFound);
      if (id <> CSchedIDnull) and IsHeaderDetFound then
      begin
        FoundReq  := true;
        p_sc.MarkMsgForJobSent(id, true);
      end;

      OldhdrCode := hdrCode;
      OldDetCode := DetCode;
      OldJobCode  := JobCode;
      OldReprocNo := ReprocNo;
      if Assigned(ProgBar) then
        ProgBar.SetPosition(RecNo);
      Application.ProcessMessages;
      Next;
    end;
    close;

    if FoundReq then
    begin
      Transaction := CreateTransaction(Main_DB);
      Transaction.StartTransaction;
      SQL.Clear;
      SQL.Add('update ' + tbInfo.GetTableName + ' set');
      SQL.Add(CreateFld(tbInfo.pfx, fli_JobMsgEvent)                   + '=');
      SQL.Add(':' + CreateFld(tbInfo.pfx, fli_JobMsgEvent)             + ' ');
      SQL.Add('where');
      SQL.add(CreateFld(tbInfo.pfx, fli_To_WorkStation) + ' = ' + QuotedStr(IniAppGlobals.WkstCode));
      SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier)));
      ParamByName(CreateFld(tbInfo.pfx, fli_JobMsgEvent)).AsString := '0';
      ExecSQL;
      Transaction.Commit;
    end;
    qry.Free;
  end;

end;

//----------------------------------------------------------------------------//

procedure CreateMsgJobForm(Id : TschedId);
var
  qry: TMqmQuery;
  tbInfo: ^TTblInfo;
  str : string;
  I : integer;
  FieldVal : variant;
  dataType: CBinColValType;
  ProdReq , Step , SubStep, ReProcess : string;
  MsgJobHandling: TMsgJobHandling;
  WSList,WSListDesc,WSWithMsg, WSWithMsgUnread, WSViewMsgList : TstringList;
  Status : string;
  WS : string;
  Save_Cursor : TCursor;
begin
//  if id = CSchedIDnull then exit;
  Save_Cursor := Screen.Cursor;
  Screen.Cursor  := crAppStart;
  p_sc.GetFldValue(Id, CSC_ProdReq, FieldVal, dataType);
  ProdReq := FieldVal;
  p_sc.GetFldValue(Id, CSC_ProdStep, FieldVal, dataType);
  Step := FieldVal;
  p_sc.GetFldValue(Id, CSC_ProdSubStep, FieldVal, dataType);
  SubStep := FieldVal;
  p_sc.GetFldValue(Id, CSC_ReprocNo, FieldVal, dataType);
  ReProcess := FieldVal;

  tbInfo := @tblInfo[tbl_Job_Massages];

  qry := CreateQuery(Main_DB);
  WSWithMsgUnread  := TStringList.Create;
  WSWithMsg        := TStringList.Create;
  WSViewMsgList    := TStringList.Create;

  str := '';

  with qry do
  begin
    SQL.Clear;
    SQL.add( 'select * from ' + tbInfo.GetTableName);
    SQL.add( ' where ');
    SQL.add(CreateFld(tbInfo.pfx, fli_preqNo) + ' = ' + QuotedStr(ProdReq) + ' AND ');
    SQL.add(CreateFld(tbInfo.pfx, fli_pstepId) + ' = ' + Step + ' AND ');
    SQL.add(CreateFld(tbInfo.pfx, fli_psubstId) + ' = ' + SubStep + ' AND ');
    SQL.add(CreateFld(tbInfo.pfx, fli_reprocNo) + ' = ' + ReProcess + ' AND (');
    SQL.add(CreateFld(tbInfo.pfx, fli_To_WorkStation) + ' = ' + QuotedStr(IniAppGlobals.WkstCode) + ' OR ' );
    SQL.add(CreateFld(tbInfo.pfx, fli_From_WorkStation) + ' = ' + QuotedStr(IniAppGlobals.WkstCode) + ')');
    SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier)));
    open;
  //  str := fieldByName('JM_MESSAGES').AsString;

    if not Eof then
    begin
      while not Eof do
      begin
        if trim(qry.fieldByName(CreateFld(tbInfo.pfx, fli_From_WorkStation)).AsString) = IniAppGlobals.WkstCode then
          WS := trim(qry.fieldByName(CreateFld(tbInfo.pfx, fli_To_WorkStation)).AsString)
        else
          WS := trim(qry.fieldByName(CreateFld(tbInfo.pfx, fli_From_WorkStation)).AsString);

        if trim(qry.fieldByName(CreateFld(tbInfo.pfx, fli_From_WorkStation)).AsString) = IniAppGlobals.WkstCode then
           status := '0'
        else
           status := trim(qry.fieldByName(CreateFld(tbInfo.pfx, fli_status)).AsString);

        if WSWithMsg.IndexOf(WS) = -1 then WSWithMsg.add(WS);

        if status = '1' then
        begin
          if WSWithMsgUnread.IndexOf(WS) = -1 then WSWithMsgUnread.add(WS);
        end;

        Next;
      end;
      close;
    end;

    for I := 0 to WSWithMsg.Count - 1 do
    begin
      WS := WSWithMsg.Strings[I];
      if WSWithMsgUnread.IndexOf(WS) = -1 then
         status := '0'
      else
         status := '1';
      WSViewMsgList.add(status + WS);
    end;

    tbInfo := @tblInfo[tbl_wkst];
    SQL.Clear;
    SQL.add( 'select * from ' + tbInfo.GetTableName);
    SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier)));
    open;

    WSList     := TStringList.Create;
    WSListDesc := TStringList.Create;

    while not Eof do
    begin
      if trim(qry.fieldByName(CreateFld(tbInfo.pfx, fli_wkstCode)).AsString) <> IniAppGlobals.WkstCode then
      begin
        WSList.Add(trim(qry.fieldByName(CreateFld(tbInfo.pfx, fli_wkstCode)).AsString));
        WSListDesc.Add(trim(qry.fieldByName(CreateFld(tbInfo.pfx, fli_wkDescr)).AsString));
      end;
      next;
    end;

    Screen.Cursor := Save_Cursor;
    MsgJobHandling := TMsgJobHandling.CreateMsgJobForm(application,Id,ProdReq,Step,SubStep,ReProcess,WSList,WSListDesc,WSViewMsgList);
    if MsgJobHandling.ShowModal = mrOk then
       WSViewMsgList.Free;

    qry.free;
    WSWithMsgUnread.Free;
    WSWithMsg.Free
  end;
end;

//----------------------------------------------------------------------------//

end.
