unit FMWorkCenterCategoryCapacity;

interface

uses
  cxButtons, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.UI.Intf,
  FireDAC.VCLUI.Wait, FireDAC.Stan.Intf, FireDAC.Comp.UI, Vcl.ImgList, DMsrvPc,
  System.Actions, Vcl.ActnList, Vcl.Menus, Vcl.ExtCtrls, Data.DB, Vcl.Grids, UMTblDesc,
  Vcl.DBGrids, Vcl.Buttons, Vcl.StdCtrls, Vcl.Samples.Spin,
  UMWkCtr, UReShape, ExSpinEdit;

type

  TRecWcCatCapacity = record
    Wc : string;
    Category : string;
    FromDate : TDateTime;
    NumOfMachineAllowed : integer;
  end;
  PRecWcCatCapacity = ^TRecWcCatCapacity;

  TWorkCenterCategoryCapacity = class(TForm)
    PanelMain1: TPanel;
    Splitter2: TSplitter;
    PanelTop1: TPanel;
    ScrollBox2: TScrollBox;
    Panel4: TPanel;
    LbeDateBegin: TLabeledEdit;
    PanelBottom1: TPanel;
    cbxCategory: TComboBox;
    LblCategory: TLabel;
    LblWkCnter: TLabel;
    cbxWkCnter: TComboBox;
    SGRowDetails: TStringGrid;
    PopupMenu1: TPopupMenu;
    MIDelete: TMenuItem;
    PopupMenu2: TPopupMenu;
    MenuItemSave: TMenuItem;
    MenuItemSaveAsNew: TMenuItem;
    SEdtNumMachinSuspended: TexSpinEdit;
    Label1: TLabel;
    BitBtn1: TBitBtn;
    BitbtnCancel2: TcxButton;
    BitBtnDel1: TcxButton;
    BitBtn2: TcxButton;
//  private
    { Private declarations }
    procedure actDeleteRecordExecute(Sender: TObject);
    procedure actSaveAsNewExecute(Sender: TObject);
    procedure QryBeforeScroll(DataSet: TDataSet);
    procedure MiInsertClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    constructor CreateWcCategoryCapacity(AOwner: TComponent);
    procedure BitBtnSaveClick(Sender: TObject);
    procedure SGRowDetailsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure MIDeleteClick(Sender: TObject);
    procedure MenuItemSaveClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure PopupMenu2Popup(Sender: TObject);
    procedure SGRowDetailsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure MenuItemSaveAsNewClick(Sender: TObject);
    procedure InsertPosInList(RecWcCatCapacity : PRecWcCatCapacity);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitbtnCancel2Click(Sender: TObject);
    procedure MenuItemSaveDrawItem(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; Selected: Boolean);

  private

   // m_List : TList;
    m_RowSelected : integer;

    function  CheckRecord    : boolean; //override;
    procedure RefreshData;
    procedure RefreshDataComponents;
    procedure FillDataComponenets;
  end;

  procedure LoadFromDB;
  function  BuildDummyDownTimeForCapacity : boolean;
  procedure DeleteDummyDownTimeForCapacity(VisResList : TList; BiuldDefaultDummy : boolean);

implementation

{$R *.dfm}

uses

  UMObjCont, UMRes, UMCapRes, UMResCat, UMDurObj, dateSelectorForm, UMglobal, UMSchedContFunc, UMActArea,
  UGbaseCal, gnugettext, umcommon;

var
  m_ListWcCatCap : TList;

{------------------------------------------------------------------------------}

{ TWorkCenterCategoryCapacity }

procedure TWorkCenterCategoryCapacity.actDeleteRecordExecute(Sender: TObject);
begin

end;

{------------------------------------------------------------------------------}

procedure TWorkCenterCategoryCapacity.actSaveAsNewExecute(Sender: TObject);
begin

end;

{------------------------------------------------------------------------------}

procedure TWorkCenterCategoryCapacity.BitBtn1Click(Sender: TObject);
var
  pnt: TPoint;
begin
  if GetCursorPos(pnt) then
    PopupMenu2.Popup(pnt.X, pnt.Y);
end;

{------------------------------------------------------------------------------}

procedure TWorkCenterCategoryCapacity.BitBtn2Click(Sender: TObject);
var
  TempDate : TDate;
  year, month, day : word;
begin
  inherited;
  try
    DateSelectorFrm := TDateSelectorFrm.Create(self);
    DateSelectorFrm.setSelectedDate(LbeDateBegin.Text);

    if (DateSelectorFrm.ShowModal = mrOk) then
    begin
      LbeDateBegin.Text := DateToStr(DateSelectorFrm.getSelectedDate());
      TempDate := DateSelectorFrm.getSelectedDate();

      DecodeDate(TempDate, year, month, day);
    end;
  except
    on e:Exception do MessageDlg('DateSelectorFrm Err202'+#13'Message: '+e.Message,mtError, [mbOK],0);
  end;
end;

{------------------------------------------------------------------------------}

procedure TWorkCenterCategoryCapacity.BitbtnCancel2Click(Sender: TObject);
begin
  MOdalResult := mrCancel;
  Close;
end;

{------------------------------------------------------------------------------}

procedure TWorkCenterCategoryCapacity.BitBtnSaveClick(Sender: TObject);
begin

end;

{------------------------------------------------------------------------------}

function TWorkCenterCategoryCapacity.CheckRecord: boolean;
begin

end;

{------------------------------------------------------------------------------}

constructor TWorkCenterCategoryCapacity.CreateWcCategoryCapacity(AOwner: TComponent);
begin
  inherited Create(AOwner);
  m_RowSelected := -1;
  if not assigned(m_ListWcCatCap) then
  begin
    m_ListWcCatCap := TList.Create;
    LoadFromDB;
  end;

  ReShape(Self);
end;

{------------------------------------------------------------------------------}

procedure TWorkCenterCategoryCapacity.FillDataComponenets;
var
  WC : TMqmWrkCtr;
  resCat : TMqmResCat;
  I : Integer;
begin
  for i := 0 to p_pl.p_WrkCtrsCount - 1 do
  begin
    WC := TMqmWrkCtr(p_pl.p_WrkCtr[i]);
    if (WC.p_ReadOnly) then
       Continue;
    cbxWkCnter.Items.Add(WC.p_WrkCtrCode)
  end;

  for i := 0 to p_pl.p_ResCatCount - 1 do
  begin
    resCat := TMqmResCat(p_pl.p_resCat[i]);
    cbxCategory.Items.Add(resCat.p_ResCatCode);
  end;
end;

{------------------------------------------------------------------------------}

procedure TWorkCenterCategoryCapacity.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  I : Integer;
begin
  Action := caFree;
end;

{------------------------------------------------------------------------------}

procedure TWorkCenterCategoryCapacity.FormShow(Sender: TObject);
var
  CanSelect : boolean;
begin
  FillDataComponenets;
  LbeDateBegin.Text := DateToStr(date);

  if m_ListWcCatCap.Count > 0 then
  begin
    RefreshData;
    SGRowDetails.Row:=1;
    SGRowDetails.Col:=0;
    CanSelect := true;
    SGRowDetails.OnSelectCell(self,0,1,CanSelect);
    SGRowDetails.SetFocus;
    RefreshDataComponents;
  end;


end;

{------------------------------------------------------------------------------}

procedure TWorkCenterCategoryCapacity.InsertPosInList(RecWcCatCapacity : PRecWcCatCapacity);
var
  I: integer;
  Multiplier, NumberOfEntries, LowestHighestValue : integer;
begin
  NumberOfEntries := m_ListWcCatCap.Count;
  LowestHighestValue := NumberOfEntries;

  if NumberOfEntries > 0 then
  begin

    Multiplier := 1;
    while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    I := Multiplier - 1;

    while (Multiplier > 0) do
    begin
      Multiplier := trunc(Multiplier / 2);
      if (i >= NumberOfEntries) then
      begin
        i := i - Multiplier;
        Continue;
      end;

      if PRecWcCatCapacity(m_ListWcCatCap[I]).Wc = RecWcCatCapacity.Wc then
      begin
        if PRecWcCatCapacity(m_ListWcCatCap[I]).Category = RecWcCatCapacity.Category then
        begin
          if PRecWcCatCapacity(m_ListWcCatCap[I]).FromDate < RecWcCatCapacity.FromDate then
          begin
            i := i + Multiplier;
            Continue;
          end;
        end;

        if PRecWcCatCapacity(m_ListWcCatCap[I]).Category < RecWcCatCapacity.Category then
        begin
          i := i + Multiplier;
          Continue;
        end;
      end;

      if PRecWcCatCapacity(m_ListWcCatCap[I]).Wc < RecWcCatCapacity.Wc then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if I < LowestHighestValue then LowestHighestValue := I;
      i := i - Multiplier;
    end;
  end;
  m_ListWcCatCap.insert(LowestHighestValue, RecWcCatCapacity);

end;

{------------------------------------------------------------------------------}

procedure TWorkCenterCategoryCapacity.MenuItemSaveAsNewClick(Sender: TObject);
var
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
  SqlInsert, SelectionDate : string;
  TempDate : TDate;
  year, month, day : word;
  RecWcCatCapacity : PRecWcCatCapacity;
  CanSelect : boolean;
  I : integer;
begin
  tbInfo := @tblInfo[tbl_wkc_cat_capacity];

  qry := CreateQuery(Main_DB);
  Qry.Transaction := CreateTransaction(Main_DB);
  Qry.Transaction.StartTransaction;

  SelectionDate := ConvertDateFormatDb2Oracle(StrToDateTime(LbeDateBegin.Text), true, true);

  SqlInsert := ' insert into ' + tbInfo.GetTableName + ' (';
  SqlInsert := SqlInsert + '"' + CreateFld(tbInfo.pfx,fli_IDENTIFIER) + '"' + ',';
  SqlInsert := SqlInsert + '"' + CreateFld(tbInfo.pfx,fli_wkstCode) + '"' + ',';
  SqlInsert := SqlInsert + '"' + CreateFld(tbInfo.pfx,fli_wkCtrCode) + '"' + ',';
  SqlInsert := SqlInsert + '"' + CreateFld(tbInfo.pfx,fli_Category) + '"' + ',';
  SqlInsert := SqlInsert + '"' + CreateFld(tbInfo.pfx,fli_DateBegin) + '"' + ',';
  SqlInsert := SqlInsert + '"' + CreateFld(tbInfo.pfx,fli_NumMachinesTosuspend) + '"';
  SqlInsert := SqlInsert + ') values (';
  SqlInsert := SqlInsert + IniAppGlobals.Identifier + ', ' + QuotedStr(IniAppGlobals.WkstCode) + ', ' +
  QuotedStr(cbxWkCnter.Items.Strings[cbxWkCnter.ItemIndex])  + ', ' +
  QuotedStr(cbxCategory.Items.Strings[cbxCategory.ItemIndex])  + ', ' +
  SelectionDate + ', ' +
  IntToStr(SEdtNumMachinSuspended.Value) + ')';
  qry.sql.Text  := SqlInsert;


{  SqlInsert := SqlInsert + 'insert into ' + tbInfo.GetTableName + '(';
  SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_wkstCode) + ',';
  SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_wkCtrCode) + ',';
  SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_Category) + ',';
  SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_DateBegin) + ',';
  SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_NumMachinesTosuspend);
  SqlInsert := SqlInsert + ') values (';
  SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_wkstCode) + ',';
  SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_wkCtrCode) + ',';
  SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_Category) + ',';
  SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_DateBegin) + ',';
  SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_NumMachinesTosuspend);
  SqlInsert := SqlInsert + ')';
  qry.sql.Text  := SqlInsert;

  qry.ParamByName(CreateFld(tbInfo.pfx,fli_wkstCode)).AsString          := IniAppGlobals.WkstCode;
  qry.ParamByName(CreateFld(tbInfo.pfx,fli_wkCtrCode)).AsString         := cbxWkCnter.Items.Strings[cbxWkCnter.ItemIndex];
  qry.ParamByName(CreateFld(tbInfo.pfx,fli_Category)).AsString          := cbxCategory.Items.Strings[cbxCategory.ItemIndex];
  qry.ParamByName(CreateFld(tbInfo.pfx,fli_DateBegin)).AsString         := ConvertDateFormatDb2Oracle(StrToDateTime(LbeDateBegin.Text), true, true);
  qry.ParamByName(CreateFld(tbInfo.pfx,fli_NumMachinesTosuspend)).AsInteger  := SEdtNumMachinSuspended.Value;    }

  qry.ExecSQL;
  qry.Transaction.Commit;

  new(RecWcCatCapacity);
  RecWcCatCapacity.Wc := cbxWkCnter.Items.Strings[cbxWkCnter.ItemIndex];
  RecWcCatCapacity.Category := cbxCategory.Items.Strings[cbxCategory.ItemIndex];
  RecWcCatCapacity.NumOfMachineAllowed := SEdtNumMachinSuspended.Value;
  RecWcCatCapacity.FromDate := StrToDate(LbeDateBegin.Text);

  InsertPosInList(RecWcCatCapacity);
  RefreshData;
  m_RowSelected := m_ListWcCatCap.count;
  CanSelect := true;
  SGRowDetails.OnSelectCell(self,0,m_RowSelected,CanSelect);
  SGRowDetails.SetFocus;

  qry.Free;

end;

{------------------------------------------------------------------------------}

procedure TWorkCenterCategoryCapacity.MenuItemSaveClick(Sender: TObject);
var
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
  SqlUpdate, SelectionDate : string;
  CanSelect : boolean;
  TempDate : TDate;
  year, month, day : word;
begin
  if ((m_RowSelected - 1) >= 0) and (m_ListWcCatCap.Count > 0) then
  begin
    TempDate := StrToDate(LbeDateBegin.Text);
    DecodeDate(TempDate, year, month, day);
    SelectionDate := ConvertDateFormatDb2Oracle(StrToDateTime(LbeDateBegin.Text), true, true);
  //  if IniAppGlobals.DownloadTo = '2' then
  //    SelectionDate := QuotedStr(SelectionDate);

    qry := CreateQuery(Main_DB);
    Qry.Transaction := CreateTransaction(Main_DB);
    Qry.Transaction.StartTransaction;

    tbInfo := @tblInfo[tbl_wkc_cat_capacity];
    qry.SQL.Clear;
    SqlUpdate := 'update ' + tbInfo.GetTableName;
    SqlUpdate := SqlUpdate + ' set ' + CreateFld(tbInfo.pfx, fli_NumMachinesTosuspend) + '=' + IntToStr(SEdtNumMachinSuspended.Value);
    SqlUpdate := SqlUpdate + ' where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + '=''' + IniAppGlobals.WkstCode + '''';
    SqlUpdate := SqlUpdate + ' And ' + CreateFld(tbInfo.pfx, fli_wkCtrCode) + '=''' + PRecWcCatCapacity(m_ListWcCatCap.Items[m_RowSelected - 1]).Wc + '''';
    SqlUpdate := SqlUpdate + ' And ' + CreateFld(tbInfo.pfx, fli_Category) + '=''' + PRecWcCatCapacity(m_ListWcCatCap.Items[m_RowSelected - 1]).Category + '''';
    SqlUpdate := SqlUpdate + ' And "' + CreateFld(tbInfo.pfx, fli_DateBegin) + '"' + '= ' + SelectionDate;
    SqlUpdate := SqlUpdate + AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier));
    PRecWcCatCapacity(m_ListWcCatCap[m_RowSelected - 1]).NumOfMachineAllowed := SEdtNumMachinSuspended.Value;
    PRecWcCatCapacity(m_ListWcCatCap[m_RowSelected - 1]).FromDate := TempDate;
    qry.sql.Text := SqlUpdate;
    Qry.ExecSQL;
    Qry.Transaction.Commit;
    RefreshData;
    SGRowDetails.OnSelectCell(self,0,m_RowSelected,CanSelect);
    qry.Free;
  end;
end;

procedure TWorkCenterCategoryCapacity.MenuItemSaveDrawItem(Sender: TObject;
  ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
begin
  ACanvas.Brush.Color := clWhite;
end;

{------------------------------------------------------------------------------}

procedure TWorkCenterCategoryCapacity.MIDeleteClick(Sender: TObject);
var
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
  SqlDelete, SelectionDate : string;
  CanSelect : boolean;
  TempDate : TDate;
  year, month, day : word;
begin
  if ((m_RowSelected - 1) >= 0) and (m_ListWcCatCap.Count > 0) then
  begin
    TempDate := StrToDate(LbeDateBegin.Text);
    DecodeDate(TempDate, year, month, day);
    SelectionDate := ConvertDateFormatDb2Oracle(StrToDateTime(LbeDateBegin.Text), true, true);

    qry := CreateQuery(Main_DB);
    Qry.Transaction := CreateTransaction(Main_DB);
    Qry.Transaction.StartTransaction;
    tbInfo := @tblInfo[tbl_wkc_cat_capacity];
    qry.SQL.Clear;
    SqlDelete := 'delete from ' + tbInfo.GetTableName;
    SqlDelete := SqlDelete + ' where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + '=''' + IniAppGlobals.WkstCode + '''';
    SqlDelete := SqlDelete + ' And ' + CreateFld(tbInfo.pfx, fli_wkCtrCode) + '=''' + PRecWcCatCapacity(m_ListWcCatCap.Items[m_RowSelected - 1]).Wc + '''';
    SqlDelete := SqlDelete + ' And ' + CreateFld(tbInfo.pfx, fli_Category) + '=''' + PRecWcCatCapacity(m_ListWcCatCap.Items[m_RowSelected - 1]).Category + '''';
  //  if (IniAppGlobals.DownloadTo = '2') then
  //     SelectionDate := QuotedStr(SelectionDate);
    SqlDelete := SqlDelete + ' And "' + CreateFld(tbInfo.pfx, fli_DateBegin) + '"' + '= ' + SelectionDate;
    SqlDelete := SqlDelete + AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier));

    dispose(PRecWcCatCapacity(m_ListWcCatCap[m_RowSelected - 1]));
    m_ListWcCatCap.Delete(m_RowSelected - 1);
    qry.sql.Text := SqlDelete;
    Qry.ExecSQL;
    Qry.Transaction.Commit;
    RefreshData;
    SGRowDetails.OnSelectCell(self,0,m_RowSelected,CanSelect);
    qry.Free;
  end;
end;

{------------------------------------------------------------------------------}

procedure TWorkCenterCategoryCapacity.MiInsertClick(Sender: TObject);
begin

end;

{------------------------------------------------------------------------------}

procedure TWorkCenterCategoryCapacity.PopupMenu1Popup(Sender: TObject);
begin

end;

{------------------------------------------------------------------------------}

procedure TWorkCenterCategoryCapacity.PopupMenu2Popup(Sender: TObject);
var
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
  SqlStr, SelectionDate : string;
  TempDate : TDate;
  year, month, day : word;
begin
  exit;
  MenuItemSaveAsNew.Enabled := true;
  if m_RowSelected > 0 then
  begin
    qry := CreateQuery(Main_DB);
    tbInfo := @tblInfo[tbl_wkc_cat_capacity];
    qry.SQL.Clear;

    TempDate := StrToDate(LbeDateBegin.Text);
    DecodeDate(TempDate, year, month, day);
    SelectionDate := ConvertDateFormatDb2Oracle(StrToDateTime(LbeDateBegin.Text), false, true);

    SqlStr := 'select * from ' + tbInfo.GetTableName;
    SqlStr := SqlStr + ' Where ' + CreateFld(tbInfo.pfx, fli_wkCtrCode) + '=''' + cbxWkCnter.Items.Strings[cbxWkCnter.ItemIndex] + '''';
    SqlStr := SqlStr + ' And ' + CreateFld(tbInfo.pfx, fli_Category) + '=''' + cbxCategory.Items.Strings[cbxCategory.ItemIndex] + '''';
    SqlStr := SqlStr + ' And "' + CreateFld(tbInfo.pfx, fli_DateBegin) + '"' + '= ' + QuotedStr(SelectionDate);
    SqlStr := SqlStr + ' And ' + CreateFld(tbInfo.pfx, fli_wkstCode) + '=''' + IniAppGlobals.WkstCode + '''';
    SqlStr := SqlStr + AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier));
    qry.SQL.Text := SqlStr;
    qry.Open;
    if not qry.eof then
      MenuItemSaveAsNew.Enabled := false;
    qry.close;
    qry.Free;
  end;
end;

{------------------------------------------------------------------------------}

procedure TWorkCenterCategoryCapacity.QryBeforeScroll(DataSet: TDataSet);
begin

end;

{------------------------------------------------------------------------------}

procedure TWorkCenterCategoryCapacity.RefreshData;
var
  I : integer;
  RowData : PRecWcCatCapacity;
begin
  with SGRowDetails do
  begin

    RowCount := m_ListWcCatCap.Count + 1;
    if RowCount > 1 then FixedRows := 1;

    Cells[0, 0] := _('Work Center');
    Cells[1, 0] := _('Category');
    Cells[2, 0] := _('From date');
    Cells[3, 0] := _('Number of suspended machine');

    for i:= 0 to m_ListWcCatCap.Count - 1 do
    begin
      RowData := m_ListWcCatCap.Items[i];
      Cells[0, i+1] := RowData.Wc;
      Cells[1, i+1] := RowData.Category;
      Cells[2, i+1] := DateTimeToStr(RowData.FromDate);
      Cells[3, i+1] := IntToStr(RowData.NumOfMachineAllowed);
    end;
  end;
end;

{------------------------------------------------------------------------------}

procedure TWorkCenterCategoryCapacity.RefreshDataComponents;
var
  Index : integer;
begin
  Index := cbxWkCnter.Items.IndexOf( SGRowDetails.Cells[0, m_RowSelected]);
  cbxWkCnter.ItemIndex := index;
  Index := cbxCategory.Items.IndexOf( SGRowDetails.Cells[1, m_RowSelected]);
  cbxCategory.ItemIndex := index;
  SEdtNumMachinSuspended.Value := StrToInt(SGRowDetails.Cells[3, m_RowSelected]);
  LbeDateBegin.Text := SGRowDetails.Cells[2, m_RowSelected];
end;

{------------------------------------------------------------------------------}

procedure TWorkCenterCategoryCapacity.SGRowDetailsDrawCell(Sender: TObject;
  ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  AGrid : TStringGrid;
begin
{   AGrid:=TStringGrid(Sender);

   if gdFixed in State then //if is fixed use the clBtnFace color
      AGrid.Canvas.Brush.Color := clBtnFace
   else
   if gdSelected in State then //if is selected use the clAqua color
   begin
      AGrid.Canvas.Brush.Color := clAqua;
      AGrid.Canvas.Pen.Color   := clblack
   end
   else
      AGrid.Canvas.Brush.Color := clWindow;

   AGrid.Canvas.FillRect(Rect);
   AGrid.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, AGrid.Cells[ACol, ARow]);
   }

end;

{------------------------------------------------------------------------------}

procedure TWorkCenterCategoryCapacity.SGRowDetailsSelectCell(Sender: TObject;
  ACol, ARow: Integer; var CanSelect: Boolean);
begin
  m_RowSelected := Arow;
  RefreshDataComponents;
end;

{------------------------------------------------------------------------------}

procedure LoadFromDB;
var
  sqlStr : string;
  qry    : TMqmQuery;
  tbInfo: ^TTblInfo;
  RecWcCatCapacity : PRecWcCatCapacity;
begin
  tbInfo := @tblInfo[tbl_wkc_cat_capacity];
  sqlStr := 'Select * from ' + tbInfo.GetTableName + ' where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + '=''' + IniAppGlobals.WkstCode + '''';
  sqlStr := sqlStr + AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier));
  sqlStr := sqlStr + ' Order by ' + CreateFld(tbInfo.pfx, fli_wkCtrCode) + ',' + CreateFld(tbInfo.pfx, fli_Category);
  sqlStr := sqlStr + ' ,' + CreateFld(tbInfo.pfx, fli_DateBegin);
  qry := CreateQuery(Main_DB);

  qry.SQL.Clear;
  qry.SQL.Text := sqlStr;
  qry.open;

  while not Qry.Eof do
  begin
    new(RecWcCatCapacity);
    RecWcCatCapacity.Wc := qry.FieldByName(CreateFld(tbInfo.pfx, fli_wkCtrCode)).AsString;
    RecWcCatCapacity.Category := qry.FieldByName(CreateFld(tbInfo.pfx, fli_Category)).AsString;
    RecWcCatCapacity.FromDate := qry.FieldByName(CreateFld(tbInfo.pfx, fli_DateBegin)).AsDateTime;
    RecWcCatCapacity.NumOfMachineAllowed := qry.FieldByName(CreateFld(tbInfo.pfx, fli_NumMachinesTosuspend)).AsInteger;
    m_ListWcCatCap.add(RecWcCatCapacity);
    qry.Next;
  end;
  qry.Free
end;

{------------------------------------------------------------------------------}

function SortBtWcCategorydate(Item1, Item2: Pointer) : integer;
var
  MQMWC1 : PRecWcCatCapacity;
  MQMWC2 : PRecWcCatCapacity;
begin
  MQMWC1 := PRecWcCatCapacity(Item1);
  MQMWC2 := PRecWcCatCapacity(Item2);
  if MQMWC1.Wc < MQMWC2.Wc then
    Result := -1
  else if (MQMWC1.Wc = MQMWC2.Wc) then
  begin
    if (MQMWC1.Category < MQMWC2.Category) then
      Result := -1
    else if (MQMWC1.Category = MQMWC2.Category) then
    begin
      if (MQMWC1.FromDate < MQMWC2.FromDate) then
        Result := 1
      else if (MQMWC1.FromDate = MQMWC2.FromDate) then
        Result := 0
      else
        Result := -1;
    end
    else
      Result := 1
  end
  else
    Result := 1;
end;

{------------------------------------------------------------------------------}

function BuildDummyDownTimeForCapacity : boolean;
var
  Idx, IdxJ, C : Integer;
  RecWcCatCapacity : PRecWcCatCapacity;
  TempListWcCatCap : TList;
  McmWrkCtr : TMqmWrkCtr;
  Rsc : TMqmRes;
  ActArea : TMqmActArea;
  VisRes : TMqmVisibleRes;
  CapRes : TMqmCapRes;
  NewStart, NewEnd : TDateTime;
  PrevWc, PrevCat : String;
  UpToDate : TDate;
  CountOfTotalRealRsc, CountOfRealRsc, CountOfOverCapRsc : integer;
  FirstTimeCapRes : boolean;
  Cal: TPGCALObj;
  ResCode : string;
begin
  Result := false;
  if m_ListWcCatCap = nil then
  begin
    m_ListWcCatCap := TList.Create;
    LoadFromDB;
  end;
//  if m_ListWcCatCap.Count = 0 then exit;

  TempListWcCatCap := TList.create;
  for Idx := 0 to m_ListWcCatCap.Count - 1 do
  begin
    RecWcCatCapacity := @PRecWcCatCapacity(m_ListWcCatCap[Idx])^;
    TempListWcCatCap.Add(RecWcCatCapacity)
  end;
  TempListWcCatCap.Sort(SortBtWcCategorydate);

  PrevWc := '';
  PrevCat := '';
  for Idx := 0 to TempListWcCatCap.Count - 1 do
  begin
    result := true;
    RecWcCatCapacity := PRecWcCatCapacity(TempListWcCatCap[Idx]);
    if PrevWc <> RecWcCatCapacity.Wc then
      McmWrkCtr := TMqmWrkCtr(p_pl.FindWrkCtrByCode(RecWcCatCapacity.Wc));
    if McmWrkCtr.p_ReadOnly then continue;

    if (PrevWc <> RecWcCatCapacity.Wc) or (PrevCat <> RecWcCatCapacity.Category) then
    begin
      PrevWc := RecWcCatCapacity.Wc;
      PrevCat := RecWcCatCapacity.Category;
      UpToDate := 0;
      CountOfTotalRealRsc := 0;
      for IdxJ := 0 to McmWrkCtr.p_ResCount - 1 do
      begin
        Rsc := TMqmRes(McmWrkCtr.p_Res[IdxJ]);
        if Rsc.m_ResCat.p_ResCatCode <> RecWcCatCapacity.Category then continue;
        if Rsc.p_PlanType = RPT_Real then inc(CountOfTotalRealRsc);
      end;
    end;

    CountOfRealRsc := 0;
    CountOfOverCapRsc := 0;

    for IdxJ := 0 to McmWrkCtr.p_ResCount - 1 do
    begin
      Rsc := TMqmRes(McmWrkCtr.p_Res[IdxJ]);
      ResCode := rsc.p_ResCode;  // For debug purposes
      if Rsc.m_ResCat.p_ResCatCode <> RecWcCatCapacity.Category then continue;
      if Rsc.p_PlanType = RPT_InfiniteCapacity then continue;

      VisRes := Rsc.p_VisRes[0];
      actArea := TMqmActArea(VisRes.p_ActArea[0]);
      Cal := ActArea.GetCalendar;

      if Rsc.p_PlanType = RPT_Real then
      begin
        inc(CountOfRealRsc);
        if (RecWcCatCapacity.NumOfMachineAllowed < 0)
        and (CountOfRealRsc > (CountOfTotalRealRsc + RecWcCatCapacity.NumOfMachineAllowed)) then
        begin
          FirstTimeCapRes := false;
          for C := 0 to actArea.p_CapResCount - 1 do
          begin
            CapRes := TMqmCapRes(ActArea.p_CapRes[C]);
            if CapRes.m_Type <> Cr_DummyDtm then continue;
            FirstTimeCapRes := true;
            break
          end;
          CapRes := TMqmCapRes.CreateCapRes(0);
          CapRes.m_Type := Cr_DummyDtm;
          CapRes.p_start := RecWcCatCapacity.FromDate;
          if FirstTimeCapRes then
            CapRes.p_dur := 9999999
          else
          begin
            CapRes.p_dur := trunc(cal.DiffWH(CapRes.p_start , UpToDate, nil) * 60);
          end;
          actArea.AddCapRes(Capres as TMqmDurObj);
        end;
      end;

      if Rsc.p_PlanType = RPT_OverCapacity then
      begin
        inc(CountOfOverCapRsc);
        CapRes := TMqmCapRes(ActArea.p_CapRes[0]);
        CapRes.p_dur := trunc(cal.DiffWH(CapRes.p_start , RecWcCatCapacity.FromDate, nil) * 60);
        CapRes := TMqmCapRes.CreateCapRes(0);
        if (CountOfOverCapRsc <= RecWcCatCapacity.NumOfMachineAllowed) then
          CapRes.m_Type := Cr_DummyUpTime
        else
          CapRes.m_Type := Cr_DummyDtm;
        CapRes.p_start := RecWcCatCapacity.FromDate;
        if UpToDate = 0 then
          CapRes.p_dur := 9999999
        else
          CapRes.p_dur := trunc(cal.DiffWH(RecWcCatCapacity.FromDate, UpToDate, nil) * 60);
        actArea.AddCapRes(Capres as TMqmDurObj);
      end;
    end;
    UpToDate := RecWcCatCapacity.FromDate;
  end;

  for Idx := 0 to TempListWcCatCap.Count - 1 do
  begin
    RecWcCatCapacity := PRecWcCatCapacity(TempListWcCatCap[Idx]);
    McmWrkCtr := TMqmWrkCtr(p_pl.FindWrkCtrByCode(RecWcCatCapacity.Wc));
    for IdxJ := 0 to McmWrkCtr.p_ResCount - 1 do
    begin
      Rsc := TMqmRes(McmWrkCtr.p_Res[IdxJ]);
      VisRes := Rsc.p_VisRes[0];
      actArea := TMqmActArea(VisRes.p_ActArea[0]);
      actArea.RemoveAllCapResDummyUpTime;
    end;
  end;

  TempListWcCatCap.Free;

end;

{------------------------------------------------------------------------------}

procedure DeleteDummyDownTimeForCapacity(VisResList : TList; BiuldDefaultDummy : boolean);
var
  I, J : Integer;
  McmWrkCtr : TMqmWrkCtr;
  Rsc : TMqmRes;
  ActArea : TMqmActArea;
  VisRes : TMqmVisibleRes;
  CapRes : TMqmCapRes;
  WC     : TMqmWrkCtr;
begin
  if m_ListWcCatCap = nil then
  begin
    m_ListWcCatCap := TList.Create;
    LoadFromDB;
  end;

  for i := 0 to p_pl.p_WrkCtrsCount - 1 do
  begin
    WC := TMqmWrkCtr(p_pl.p_WrkCtr[i]);
    if (WC.p_ReadOnly) and (not WC.p_Visible) then
      Continue;

    for J := 0 to WC.p_ResCount - 1 do
    begin
      Rsc := TMqmRes(WC.p_Res[J]);
      VisRes := Rsc.p_VisRes[0];
      actArea := TMqmActArea(VisRes.p_ActArea[0]);
      actArea.RemoveAllCapResDummy;
      rsc := TMqmRes(VisRes.p_Father);

      if BiuldDefaultDummy and (Rsc.p_PlanType = RPT_OverCapacity) then
      begin
        CapRes := TMqmCapRes.CreateCapRes(0);
        CapRes.m_Type := Cr_DummyDtm;
        CapRes.p_start := now - 2;
        CapRes.p_dur   := 9999999;
        actArea.AddCapRes(Capres as TMqmDurObj);
      end;

    end
  end;


 { for I := 0 to VisResList.Count - 1 do
  begin
    VisRes := TMqmVisibleRes(VisResList[i]);
    actArea := TMqmActArea(VisRes.p_ActArea[0]);
    actArea.RemoveAllCapResDummy;
    rsc := TMqmRes(VisRes.p_Father);

    if BiuldDefaultDummy and (Rsc.p_PlanType = RPT_OverCapacity) then
    begin
      CapRes := TMqmCapRes.CreateCapRes(0);
      CapRes.m_Type := Cr_DummyDtm;
      CapRes.p_start := now - 2;
      CapRes.p_dur   := 9999999;
      actArea.AddCapRes(Capres as TMqmDurObj);
    end;
  end;  }

end;

{------------------------------------------------------------------------------}

Procedure CleanList;
var
  I : Integer;
begin
  if m_ListWcCatCap = nil then exit;
  for I := m_ListWcCatCap.Count - 1 downto 0 do
    dispose(PRecWcCatCapacity(m_ListWcCatCap[I]));
  m_ListWcCatCap.Free;
end;

{------------------------------------------------------------------------------}

initialization

finalization
  CleanList;

end.
