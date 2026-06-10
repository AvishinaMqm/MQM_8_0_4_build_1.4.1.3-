unit FMSQL;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, StrUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UMGlobal, DMSrvPc, Vcl.ExtCtrls,
  Vcl.Menus, Vcl.ComCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, TimeSpan,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Vcl.WinXCtrls, UReShape, cxGrid, cxGraphics, dxUIAClasses, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, dxDateRanges, dxSkinTheBezier,
  dxScrollbarAnnotations, cxDBData, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomPopupMenu, cxGridPopupMenu, System.ImageList, Vcl.ImgList,
  cxImageList, dxFilterPopupWindow;

   type
    SQLTab = class(TTabSheet)
    public
      qry : TMqmQuery;
      ds : TDataSource;
      mMemo : TMemo;
      dbGrid : TcxGrid;
      dbGridView : TcxGridDBTableView;
      dbGridLevel: TcxGridLevel;
      sp : TSplitter;
      sb : TStatusBar;
      ExeTime : TTime;
      IsLocal : Boolean;
      cxGridPopupMenu: TcxGridPopupMenu;
      Constructor CreateTab(AOwner : TPageControl);
      destructor  Close;
      //procedure grHostTitleClick(Column: TColumn);
      procedure AfterQryOpen(DataSet : TDataSet);
      procedure BeforeQryOpen(DataSet : TDataSet);
      procedure GridPopupMenuPopup(ASenderMenu: TComponent;AHitTest: TcxCustomGridHitTest; X, Y: Integer; var AllowPopup: Boolean);
      procedure CustomizeMenu(Sender: TObject);
      procedure miColumnfilterClick(Sender: TObject);
      procedure miFiltersClick(Sender: TObject);
      //Procedure ColumnResize(Sender: TObject;const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    end;

type
  TFSql = class(TForm)
    MainMenu1: TMainMenu;
    pnLeft: TPanel;
    Splitter2: TSplitter;
    Exit1: TMenuItem;
    tvMain: TTreeView;
    PageControl1: TPageControl;
    abs1: TMenuItem;
    New1: TMenuItem;
    New2: TMenuItem;
    Local1: TMenuItem;
    Host1: TMenuItem;
    pmSQL: TPopupMenu;
    miExecute: TMenuItem;
    miClear: TMenuItem;
    pmTable: TPopupMenu;
    ExecuteinnewTab1: TMenuItem;
    Exit2: TMenuItem;
    N1: TMenuItem;
    sbSearch: TSearchBox;
    Refresh1: TMenuItem;
    cxStyleRepository1: TcxStyleRepository;
    cxStyle1: TcxStyle;
    cxImageList1: TcxImageList;
    procedure Exit1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tvMainDblClick(Sender: TObject);
    procedure Local1Click(Sender: TObject);
    procedure Host1Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure miClearClick(Sender: TObject);
    procedure miExecuteClick(Sender: TObject);
    procedure New2Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure ExecuteinnewTab1Click(Sender: TObject);
    procedure pmTablePopup(Sender: TObject);
    procedure Exit2Click(Sender: TObject);
    procedure sbSearchChange(Sender: TObject);
    procedure Refresh1Click(Sender: TObject);
    procedure PageControl1DrawTab(Control: TCustomTabControl; TabIndex: Integer;
      const Rect: TRect; Active: Boolean);
  private
    Procedure LoadTablesToView;
  public
    st : SQLTab;
  end;

var
  FSql: TFSql;

implementation

  uses cxGridStdPopupMenu, Math, dxGdiPlusClasses, cxGeometry;

{$R *.dfm}

procedure SQLTab.miColumnfilterClick(Sender: TObject);
begin
  DbGridView.FilterRow.Visible := not DbGridView.FilterRow.Visible;
end;

procedure SQLTab.miFiltersClick(Sender: TObject);
begin
  if DbGridView.FilterBox.Visible in [fvNever, fvNonEmpty] then
    DbGridView.FilterBox.Visible := fvAlways
  else
    DbGridView.FilterBox.Visible := fvNever
end;

procedure SQLTab.CustomizeMenu(Sender: TObject);

  function GetItemIndexByCaption(AMenu: TcxGridSTDHeaderMenu; ACaption: string): Integer;
  var
    I: Integer;
  begin
    Result := -1;
    with AMenu.Items do
      for I := 0 to Count - 1 do
        if StripHotkey(Items[I].Caption) = ACaption then
        begin
          Result := I;
          System.Break;
        end;
  end;

var
  AIndex: Integer;
  mi:TMenuItem;
begin
  with TcxGridStdHeaderMenu(Sender).Items do
  begin
    AIndex := GetItemIndexByCaption(TcxGridStdHeaderMenu(Sender), 'Filter');
    if not (AIndex = -1) then
      Remove(Items[AIndex]);
    AIndex := GetItemIndexByCaption(TcxGridStdHeaderMenu(Sender), 'Column filter');
    if not (AIndex = -1) then
      Remove(Items[AIndex]);
    AIndex := GetItemIndexByCaption(TcxGridStdHeaderMenu(Sender), 'Range filter(This column)');
    if not (AIndex = -1) then
      Remove(Items[AIndex]);
  end;

  mi := TMenuItem.Create(nil);
  mi.Caption := 'Filter';
  if DbGridView.FilterBox.Visible in [fvNever, fvNonEmpty] then
    mi.ImageIndex := 4
  else
     mi.ImageIndex := 44;
  mi.ImageIndex := TcxGridStdHeaderMenu(Sender).Images.AddImage(FSql.cxImageList1, mi.ImageIndex) - 1;
  mi.OnClick := mifiltersClick;
  TcxGridStdHeaderMenu(Sender).Items.Add(mi);

  mi := TMenuItem.Create(nil);
  mi.Caption := 'Column filter';
  if DbGridView.FilterRow.Visible then
    mi.ImageIndex := 45
  else
     mi.ImageIndex := 6;
  mi.ImageIndex := TcxGridStdHeaderMenu(Sender).Images.AddImage(FSql.cxImageList1, mi.ImageIndex) - 1;
  mi.OnClick := miColumnfilterClick;
  TcxGridStdHeaderMenu(Sender).Items.Add(mi);
end;

procedure SQLTab.GridPopupMenuPopup(ASenderMenu: TComponent;
  AHitTest: TcxCustomGridHitTest; X, Y: Integer; var AllowPopup: Boolean);
begin
  if ASenderMenu is TcxGridStdHeaderMenu then
    TcxGridStdHeaderMenu(ASenderMenu).OnPopup := CustomizeMenu;
end;

procedure TFSql.ExecuteinnewTab1Click(Sender: TObject);
begin
  if not tvMain.Selected.HasChildren then
    exit;
    
  st := SQLTab.CreateTab(PageControl1);

  if (tvMain.Selected.Text <> 'Main') and (tvMain.Selected.Text <> 'Config') and (tvMain.Selected.Text <> 'Archive')  then
  begin
    st.qry.IndexFieldNames := '';
    st.mMemo.lines.Clear;
    st.mMemo.lines.Add('Select * from '+ tvMain.Selected.Text);
    st.qry.SQL.Clear;
    st.qry.SQL.Text :=  'Select * from '+ tvMain.Selected.Text;
    st.qry.Open;
  end;
end;

procedure TFSql.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TFSql.Exit2Click(Sender: TObject);
begin
  Close;
end;

procedure TFSql.FormCreate(Sender: TObject);
begin

  if not DMSrvPc.IsLocalDbConnected then
  begin
    MessageDlg('No local connection!', mtError, [mbOk], 0);
    exit;
  end;
  LoadTablesToView;
  FSql := Self;
  st := SQLTab.CreateTab(PageControl1);

end;

procedure TFSql.Host1Click(Sender: TObject);
var i : Integer;
begin
  if Host1.Checked then exit;

  if MessageDlg('Do you want to switch connection to Host?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    exit;
  
  local1.Checked := False;
  Host1.Checked := True;

  HostDbConnect;

  if not DMSrvPc.IsHostDbConnected then
  begin
    MessageDlg('No host connection!', mtError, [mbOk], 0);
    exit;
  end;

  for i := 0 to PageControl1.PageCount -1 do
    if  not sqltab(PageControl1.Pages[i]).isLocal then
      sqltab(PageControl1.Pages[i]).qry.Connection := DMib.m_DBHost;

  LoadTablesToView;
end;

procedure TFSql.LoadTablesToView;
var  qC, qM, qA : TMqmQuery;
  TblNode : TTreeNode;
  c: String;

  Function GetColName(qry : TMqmQuery) : String;
  begin
    result := '';
    with qry do
    begin
      if IniAppGlobals.downloadTo = '0' then
      begin
        if FieldByName('Typename').AsString = 'DECIMAL' then
          result := FieldByName('cColumn').asString+'('+FieldByName('Typename').AsString+ ' '+FieldByName('Length').asString+','+FieldByName('Scale').asString+')'
        else
          result := FieldByName('cColumn').asString+'('+FieldByName('Typename').asString+' '+FieldByName('Length').asString+')';
      end else
      if IniAppGlobals.downloadTo = '1' then
      begin
        if FieldByName('Typename').AsString = 'NUMBER' then
        begin
          if FieldByName('Prec').AsString =  '' then
            result := FieldByName('cColumn').asString+'('+StringReplace(FieldByName('Typename').AsString,' 22','',[rfReplaceAll,rfIgnoreCase])+')'
          else
            result := FieldByName('cColumn').asString+'('+StringReplace(FieldByName('Typename').AsString,'22','',[rfReplaceAll,rfIgnoreCase])+' '+FieldByName('Prec').asString+','+FieldByName('Scale').asString+')'
        end else
          result := FieldByName('cColumn').asString+'('+FieldByName('Typename').asString+' '+FieldByName('Length').asString+')';
      end;
    end;
  end;
begin
  tvMain.Items[0].DeleteChildren;
  tvMain.Items[1].DeleteChildren;
  tvMain.Items[2].DeleteChildren;

  qM := CreateQuery(Main_DB);

  if IniAppGlobals.downloadTo = '0' then //db2
  begin
    qM.SQL.Text := 'select  t.tabname as cTable, colname as cColumn, Typename, LENGTH as "Length", scale  '
      + ' from syscat.tables t '
      + ' inner join syscat.columns c on t.tabname = c.tabname  '
      + ' where type = '+QuotedStr('T') +' AND t.tabname LIKE '+QuotedStr('SCD%')
      + ' ORDER BY t.tabname';

  end else if IniAppGlobals.downloadTo = '1' then //ora
  begin
    qM.SQL.Text := 'Select Object_ID as ID, OBJECT_name as cTable, column_name as cColumn, DATA_TYPE as Typename, Data_length as Length, data_precision as Prec, data_scale as Scale'
       +' from SYS.ALL_OBJECTS a  '
       +' inner join SYS.USER_TAB_COLUMNS c on a.object_name  = c.table_name  '
       +' where object_Name like '+QuotedStr('SCD%')+' and object_type = '+QuotedStr('TABLE')
       +' order by OBJECT_name';

  end else if IniAppGlobals.downloadTo = '2' then  //ib
  begin

    {qC := CreateQuery(Cfg_DB);
    qA := CreateQueryArc;
    DMSrvPc.ArcDbConnect; }

    qM.SQL.Text := 'SELECT RDB$RELATION_NAME as cTable FROM RDB$RELATIONS WHERE '
        +' (RDB$SYSTEM_FLAG = 0) AND (RDB$VIEW_SOURCE IS NULL) '
        +' order by RDB$RELATION_NAME';

   { qC.SQL.Text := qM.SQL.Text;
    qA.SQL.Text := qM.SQL.Text; }

  end;

  qM.Open;
  TblNode := nil;

  with qM do
  begin
    while not Eof do
    begin
      if TblNode <> nil then
        if tblNode.Text <> FieldByName('cTable').asString then
        TblNode := nil;
          
      if ContainsText(FieldByName('cTable').asString, 'SCDM') then
      begin
    
        if TblNode = nil then      
        begin
          TblNode := tvMain.Items.AddChild(tvMain.Items[0], FieldByName('cTable').asString);
          Next;
          Continue;
        end else
        begin
          c := GetColName(qm);  
          tvMain.Items.AddChild(TblNode, c);
          Next;
          Continue;
        end;
    
      end else if ContainsText(FieldByName('cTable').asString, 'SCDC') then
      begin
        if TblNode = nil then      
        begin
          TblNode := tvMain.Items.AddChild(tvMain.Items[1], FieldByName('cTable').asString);
          Next;
          Continue;
        end else
        begin
          c := GetColName(qm);  
          tvMain.Items.AddChild(TblNode, c);
          Next;
          Continue;
        end;
      end else if  ContainsText(FieldByName('cTable').asString, 'SCDA') then
      begin
        if TblNode = nil then      
        begin
          TblNode := tvMain.Items.AddChild(tvMain.Items[2], FieldByName('cTable').asString);
          Next;
          Continue;
        end else
        begin
          c := GetColName(qm);  
          tvMain.Items.AddChild(TblNode, c);
          Next;
          Continue;
        end;
      end;

      Next;
    end;
  end;

  qM.Close;
  qM.Free;

  {if qA.ConnectionName <> '' then
  begin
    qA.Close;
    qA.Free;
  end;

  if qC.ConnectionName <> '' then
  begin
    qC.Close;
    qC.Free;
  end;   }
  tvMain.FullCollapse;
  tvMain.Items[0].Selected := True;
  tvMain.Items[0].MakeVisible;
  
end;

procedure TFSql.Local1Click(Sender: TObject);
var i : integer;
begin
  if local1.Checked then exit;

  if MessageDlg('Do you want to switch connection to Local?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    exit;
  
  local1.Checked := True;
  Host1.Checked := False;

  LocalDbConnect(false);

  if not DMSrvPc.IsLocalDbConnected then
  begin
    MessageDlg('No Local connection!', mtError, [mbOk], 0);
    exit;
  end;

  for i := 0 to PageControl1.PageCount -1 do
    if sqltab(PageControl1.Pages[i]).isLocal then
      sqltab(PageControl1.Pages[i]).qry.Connection := DMib.m_MainDB;

  LoadTablesToView;
end;

procedure TFSql.miClearClick(Sender: TObject);
begin
  st.mMemo.Text := '';
end;

procedure TFSql.miExecuteClick(Sender: TObject);
var sql : String;
begin
  if not st.qry.Connection.Connected then
  begin
    MessageDlg('No connection to database!', mtError, [mbOk], 0);
    exit;
  end;

  if st.mMemo.Text = '' then
  begin
    MessageDlg('No SQL syntax!', mtError, [mbOk], 0);
    exit;
  end;

  if st.mMemo.SelLength > 0 then
    sql := st.mMemo.SelText
  else
    sql :=  st.mMemo.Text;

  st.qry.SQL.Text := sql;

  st.qry.IndexFieldNames := '';

  try
    if ContainsText(sql, 'select') then
    begin
      st.dbGridView.ClearItems;
      st.qry.Open;
      st.dbGridView.DataController.CreateAllItems;
      st.dbGridView.ApplyBestFit;
    end else
      st.qry.Connection.ExecSQL(sql);
  Except
    on e : Exception do
    begin
      MessageDlg('Error on syntax' + char(13) + e.Message, mtError, [mbOk], 0);
    end;

  end;
end;

procedure TFSql.New1Click(Sender: TObject);
begin
  st := SQLTab.CreateTab(PageControl1);
end;

procedure TFSql.New2Click(Sender: TObject);
begin
  if PageControl1.PageCount = 0 then
    exit;

  if MessageDlg('Do you want to close tab ' + st.Caption, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    st.Close;
end;

procedure TFSql.PageControl1Change(Sender: TObject);
begin
  st := SQLTab(PageControl1.ActivePage);
end;

procedure TFSql.PageControl1DrawTab(Control: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
var
  TmpRect, TmpRect2:   TRect;
  c: TCanvas;
  cl : TColor;
begin
  c := (Control as TPageControl).Canvas;
  with c do
  begin
    if Active then
      Font.Color := clRed
    else
      Font.Color := clBlack;

    cl := Brush.Color;
    Brush.Color := ClYEllow;

    if SQLTab(PageControl1.Pages[TabIndex]).IsLocal then
      Rectangle(Rect.Left + 3, rect.top + 18, rect.Left + rect.Width-3, rect.top + 16);
    Brush.Color := cl;

    TmpRect   :=   Rect;
    TmpRect.Top := TmpRect.Top+2;
    DrawText(Handle, PChar(trim(PageControl1.Pages[TabIndex].Caption)),   -1, TmpRect, DT_CENTER or DT_VCENTER);
  end;


end;

procedure TFSql.pmTablePopup(Sender: TObject);
var aNode: TTreeNode;
  p: TPoint;
begin
  p := tvMain.ScreenToClient(pmTable.PopupPoint);
  aNode := tvMain.GetNodeAt(p.X, p.Y);
  tvMain.Select(aNode);
end;

procedure TFSql.Refresh1Click(Sender: TObject);
begin
  LoadTablesToView;
end;

procedure TFSql.sbSearchChange(Sender: TObject);
var i : Integer;
var aNode: TTreeNode;
begin
  if sbSearch.Text <> '' then
  begin
    for i := 0 to tvMain.Items.Count -1 do
    begin
      if (tvMain.Items[i].Text <> 'Main') and (tvMain.Items[i].Text <> 'Config') and (tvMain.Items[i].Text <> 'Archive')  then
      begin

        if tvMain.Selected.AbsoluteIndex >= i then
          continue;

        if ContainsText(tvMain.Items[i].Text, sbSearch.Text) then
        begin
          aNode := tvMain.Items[i];
          aNode.Selected := True;
          break;
        end;
      end;
    end;
  end else
  begin
    aNode := tvMain.Items[0];
    aNode.Selected := True;
  end;
end;

procedure TFSql.tvMainDblClick(Sender: TObject);
begin    
  if st = nil then
    st := SQLTab.CreateTab(PageControl1);

  if not tvMain.Selected.HasChildren then
  begin
    st.mMemo.Lines.Add(copy(tvMain.Selected.Text, 0, tvMain.Selected.text.IndexOf('(')) + ', ');
    exit;
  end;

  if (tvMain.Selected.Text <> 'Main') and (tvMain.Selected.Text <> 'Config') and (tvMain.Selected.Text <> 'Archive')  then
  begin
    st.qry.IndexFieldNames := '';
    st.mMemo.lines.Clear;
    st.mMemo.lines.Add('Select * from '+ tvMain.Selected.Text);
    st.qry.SQL.Clear;
    st.qry.SQL.Text :=  'Select * from '+ tvMain.Selected.Text;
    miExecute.Click;
  end;
end;

{ SQLTab }

{procedure SQLTab.grHostTitleClick(Column: TColumn);
var dss : TFDQuery;
begin
  dss := (column.Grid.DataSource.DataSet as TFDQuery);

   if  dss.IndexFieldNames = column.FieldName then
    dss.IndexFieldNames := column.FieldName + ':D'
  else
     dss.IndexFieldNames := column.FieldName;

end;  }

destructor SQLTab.Close;
var Pgc: TPageControl;
begin
  Pgc := PageControl;
  inherited destroy;

  with Pgc do
  begin
    if PageCount > 0 then
    begin
      ActivePage := pages[PageCount-1];
      FSql.st := SQLTab(ActivePage);
    end else
      FSql.st := nil;
  end;

end;

procedure FitGrid(Grid: TDBGrid);
const
  C_Add = 3;
var
  ds: TDataSet;
  bm: TBookmark;
  i: Integer;
  w: Integer;
  a: array of Integer;
begin
  ds := Grid.DataSource.DataSet;

  if not Assigned(ds) then
    exit;

  if Grid.Columns.Count = 0 then
    exit;

  ds.DisableControls;
  bm := ds.GetBookmark;
  try
    ds.First;
    SetLength(a, Grid.Columns.Count);
    for i := 0 to Grid.Columns.Count - 1 do
      if Assigned(Grid.Columns[i].Field) then
        a[i] := Grid.Canvas.TextWidth(Grid.Columns[i].FieldName);

    while not ds.Eof do
    begin

      for i := 0 to Grid.Columns.Count - 1 do
      begin
        if not Assigned(Grid.Columns[i].Field) then
          continue;

        w := Grid.Canvas.TextWidth(ds.FieldByName(Grid.Columns[i].Field.FieldName).DisplayText);

        if a[i] < w then
          a[i] := w;
      end;
      ds.Next;
    end;

    w := 0;
    for i := 0 to Grid.Columns.Count - 1 do
    begin
      Grid.Columns[i].Width := a[i] + C_Add;
      inc(w, a[i] + C_Add);
    end;

    w := (Grid.ClientWidth - w - 20) div (Grid.Columns.Count);

    if w > 0 then
      for i := 0 to Grid.Columns.Count - 1 do
        Grid.Columns[i].Width := Grid.Columns[i].Width + w;


    ds.GotoBookmark(bm);
  finally
    ds.FreeBookmark(bm);
    ds.EnableControls;
  end;
end;

{Procedure SQLTab.ColumnResize(Sender: TObject;const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
Var row : Integer;
  grid : TDBGrid;
begin
  grid := sender as TDBGrid;

  ///////////////////// Color every second Row
  row := grid.DataSource.DataSet.RecNo;

  if Odd(row) then
    grid.Canvas.Brush.Color := clWhite
  else
    grid.Canvas.Brush.Color :=  TColor(RGB(253,240,150));    //Yellow

  grid.DefaultDrawColumnCell(Rect, DataCol, Column, State) ;

end; }

Constructor SQLTab.CreateTab(AOwner:TPageControl);
begin
  inherited Create(AOwner);
  Assert(AOwner is TPageControl);
  PageControl := TPageControl(AOwner);

  Caption := 'SQL Tab ' + IntToStr(PageControl.PageCount);
  PageControl.ActivePage := self;

  mMemo := TMemo.Create(self);
  mMemo.Parent := self;
  mMemo.Align := alTop;
  mMemo.Height := 200;
  mMemo.PopupMenu := FSql.pmSQL;
  mMemo.Font.Size := 10;
  mMemo.StyleName := 'datatex1';

  dbGrid := TcxGrid.Create(self);
  dbGrid.Parent := self;
  dbGrid.Align := alClient;
  dbGrid.LookAndFeel.NativeStyle := False;
  dbGrid.LookAndFeel.SkinName := 'TheBezier';
  dbGridLevel := dbGrid.Levels.Add;
  dbGridView := dbGrid.CreateView(TcxGridDBTableView) as TcxGridDBTableView;
  dbGridLevel.GridView := dbGridView;

  dbGridView.FilterRow.OperatorCustomization := True;
  dbGridView.Filtering.ColumnPopupMode := fpmExcel;

  cxGridPopupMenu := TcxGridPopupMenu.Create(nil);
  cxGridPopupMenu.Grid := dbGrid;
  cxGridPopupMenu.OnPopup := GridPopupMenuPopup;

  sp := TSplitter.Create(self);
  sp.Parent := self;
  
  sp.Align :=  alTop;
  sp.Height := 3;   
  sp.Top := mMemo.Height+2;

  qry :=  CreateQuery(Main_DB);
  qry.FetchOptions.Unidirectional := False;

  ds := TDataSource.Create(self);
  ds.DataSet := qry;
  dbGridView.DataController.DataSource := ds;

  sb := TStatusBar.Create(self);
  sb.parent := self;
  var sbp1 := sb.Panels.Add;
  sbp1.Width := 200;
  var sbp2 := sb.Panels.Add;
  qry.AfterOpen := AfterQryOpen;
  qry.BeforeOpen := BeforeQryOpen;

  IsLocal := FSQL.Local1.Checked;
  self.Parent.Repaint;
end;

procedure SQLTab.BeforeQryOpen(DataSet : TDataSet);
begin
  ExeTime := Time;
end;

procedure SQLTab.AfterQryOpen(DataSet : TDataSet);
begin
  var Span := TTimeSpan.Subtract(Time, ExeTime);
  sb.Panels[0].Text	 := 'Row count: ' + Format('%.0n', [TMqmQuery(DataSet).RowsAffected + 0.0]);
  sb.Panels[1].Text	 := 'Time: ' + Format('%.2d:%.2d:%.2d', [Span.Minutes, Span.Seconds,Span.Milliseconds]) + ' ms';
  //FitGrid(dbGrid);
end;
end.
