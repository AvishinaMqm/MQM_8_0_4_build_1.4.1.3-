unit FMBalanceHeaders;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, Buttons, ExtCtrls, Menus, UReShape;

type
  TMBalanceHeadersForm = class(TForm)
    SGRowDetailsBalanceHdr: TStringGrid;
    Panel1: TPanel;
    CBSort2: TComboBox;
    CBSort2Type: TComboBox;
    Bevel1: TBevel;
    CBSort1: TComboBox;
    CBSort1Type: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Bevel2: TBevel;
    CBFilt1: TComboBox;
    EditFilt1: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    CBFilt2: TComboBox;
    EditFilt2: TEdit;
    PopupMenu1: TPopupMenu;
    MIBalanceChange: TMenuItem;
    SpdBtnsSort: TcxButton;
    SpdBtnFilter: TcxButton;
    SpdBnFiltShowAll: TcxButton;
    procedure SpdBtnsSortClick(Sender: TObject);
    procedure CBSort1TypeChange(Sender: TObject);
    procedure CBSort2TypeChange(Sender: TObject);
    procedure CBSort1Change(Sender: TObject);
    procedure CBSort2Change(Sender: TObject);
    procedure SpdBtnFilterClick(Sender: TObject);
    procedure SpdBnFiltShowAllClick(Sender: TObject);
    procedure SGRowDetailsBalanceHdrDblClick(Sender: TObject);
    procedure SGRowDetailsBalanceHdrSelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure MIBalanceChangeClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    m_RowList: Tlist;
    m_OrigRowList : TList;
    m_SelectedRow : Integer;
    m_LastCBSort1Index : Integer;
    m_LastCBSort1TypeIndex : Integer;
    m_LastCBSort2Index : Integer;
    m_LastCBSort2TypeIndex : Integer;

    { Private declarations }
  public
    constructor CreateBalanceHeadersForm(AOwner: TComponent; RowList: Tlist);
    procedure   IniComboBoxes;
    procedure   RefreshGridForList;
    procedure   FilterContainsStr;
  public
   // constructor CreatePrevNextChildForm(AOwner: TComponent; RowList: Tlist);
  end;

//var
//  MBalanceHeadersForm: TMBalanceHeadersForm;

implementation

uses
  gnugettext,StrUtils, UMBalance,UMObjCont,UMSchedCont, UMSchedContFunc,FMBalanceChange;

{$R *.dfm}

{ TMBalanceHeadersForm }

var
  CB_Sort1Type : Integer;
  CB_Sort2Type : Integer;

  CB_Sort1Index : Integer;
  CB_Sort2Index : Integer;

//----------------------------------------------------------------------------//

procedure TMBalanceHeadersForm.CBSort1Change(Sender: TObject);
begin
  CB_Sort1Index := CBSort1.ItemIndex;
end;

//----------------------------------------------------------------------------//

procedure TMBalanceHeadersForm.CBSort2Change(Sender: TObject);
begin
  CB_Sort2Index := CBSort2.ItemIndex;
end;

//----------------------------------------------------------------------------//

procedure TMBalanceHeadersForm.CBSort1TypeChange(Sender: TObject);
begin
  if CBSort1Type.ItemIndex = 0 then
    CB_Sort1Type := 1
  else
    CB_Sort1Type := 0
end;

//----------------------------------------------------------------------------//

procedure TMBalanceHeadersForm.CBSort2TypeChange(Sender: TObject);
begin
  if CBSort2Type.ItemIndex = 0 then
    CB_Sort2Type := 1
  else
    CB_Sort2Type := 0
end;

//----------------------------------------------------------------------------//

procedure TMBalanceHeadersForm.IniComboBoxes;
begin
  CBSort1.Items.Add(_('Type'));
  CBSort1.Items.Add(_('Product Code'));
  CBSort1.Items.Add(_('Net Group'));
  CBSort1.Items.Add(_('Due Date'));
  CBSort1.Items.Add(_('Quantity'));
  CBSort1.Items.Add(_('Details'));
  CBSort1.ItemIndex := 0;
  CB_Sort1Index := 0;

  CBSort1Type.Items.Add(_('Ascending'));
  CBSort1Type.Items.Add(_('Descending'));
  CBSort1Type.ItemIndex := 0;
  CB_Sort1Type := 0;

  CBSort2.Items.Add(_('Type'));
  CBSort2.Items.Add(_('Product Code'));
  CBSort2.Items.Add(_('Net Group'));
  CBSort2.Items.Add(_('Due Date'));
  CBSort2.Items.Add(_('Quantity'));
  CBSort2.Items.Add(_('Details'));
  CBSort2.ItemIndex := 1;
  CB_Sort2Index     := 1;

  CBSort2Type.Items.Add(_('Ascending'));
  CBSort2Type.Items.Add(_('Descending'));
  CBSort2Type.ItemIndex := 0;
  CB_Sort2Type := 0;

  CBFilt1.Items.Add(_('Type'));
  CBFilt1.Items.Add(_('Product Code'));
  CBFilt1.Items.Add(_('Net Group'));
  CBFilt1.Items.Add(_('Due Date'));
  CBFilt1.Items.Add(_('Quantity'));
  CBFilt1.Items.Add(_('Details'));
  CBFilt1.ItemIndex := 0;

  CBFilt2.Items.Add(_('Type'));
  CBFilt2.Items.Add(_('Product Code'));
  CBFilt2.Items.Add(_('Net Group'));
  CBFilt2.Items.Add(_('Due Date'));
  CBFilt2.Items.Add(_('Quantity'));
  CBFilt2.Items.Add(_('Details'));
  CBFilt2.ItemIndex := 1;
end;

//----------------------------------------------------------------------------//

procedure TMBalanceHeadersForm.MIBalanceChangeClick(Sender: TObject);
begin
  SGRowDetailsBalanceHdrDblClick(self)
end;

//----------------------------------------------------------------------------//

procedure TMBalanceHeadersForm.RefreshGridForList;
var
  I : integer;
  RowData : PTDetailRows;
begin
  with SGRowDetailsBalanceHdr do
  begin
    if m_RowList.Count = 0 then
    begin
      RowCount := 2;
      FixedRows := 1;
      Cells[0, 1] := '';
      Cells[1, 1] := '';
      Cells[2, 1] := '';
      Cells[3, 1] := '';
      Cells[4, 1] := '';
      Cells[5, 1] := '';
    end;

    Cells[0, 0] := _('Type');
    Cells[1, 0] := _('Product Code');
    Cells[2, 0] := _('Net Group');
    Cells[3, 0] := _('Due Date');
    Cells[4, 0] := _('Quantity');
    Cells[5, 0] := _('Details');

    if m_RowList.count > 0 then
    begin
      RowCount := m_RowList.Count + 1;
      for i:= 0 to m_RowList.Count -1 do
      begin
        RowData := m_RowList.Items[i];
        Cells[0, i+1] := RowData.ArtType;
        Cells[1, i+1] := RowData.ProductCode;
        Cells[2, i+1] := RowData.NetGroupPtr.m_Code;
        Cells[3, i+1] := RowData.Date;
        Cells[4, i+1] := FloatToStr(RowData.Quantity);
        Cells[5, i+1] := RowData.description;
      end;
    end;
  end;

end;

//----------------------------------------------------------------------------//

function SortBalanceColumns(Item1, Item2: Pointer): integer;
var
  RowData1, RowData2 : PTDetailRows;
  var1, var2 : variant;
  var3, var4 : variant;
begin
  RowData1 := PTDetailRows(Item1);
  RowData2 := PTDetailRows(Item2);

  case CB_Sort1Index of
    0 : begin
          var1 := RowData1.ArtType;
          var2 := RowData2.ArtType;
        end;
    1 : begin
          var1 := RowData1.ProductCode;
          var2 := RowData2.ProductCode;
        end;
    2 : begin
          var1 := RowData1.NetGroupPtr.m_Code;
          var2 := RowData2.NetGroupPtr.m_Code;
        end;
    3 : begin
          var1 := RowData1.DateTime;
          var2 := RowData2.DateTime;
        end;
    4 : begin
          var1 := RowData1.Quantity;
          var2 := RowData2.Quantity;
        end;
    5 : begin
          var1 := RowData1.description;
          var2 := RowData2.description;
        end
    else
    begin
      var1 := RowData1.ArtType;
      var2 := RowData2.ArtType;
    end;
  end;

  case CB_Sort2Index of
    0 : begin
          var3 := RowData1.ArtType;
          var4 := RowData2.ArtType;
        end;
    1 : begin
          var3 := RowData1.ProductCode;
          var4 := RowData2.ProductCode;
        end;
    2 : begin
          var3 := RowData1.NetGroupPtr.m_Code;
          var4 := RowData2.NetGroupPtr.m_Code;
        end;
    3 : begin
          var3 := RowData1.DateTime;
          var4 := RowData2.DateTime;
        end;
    4 : begin
          var3 := RowData1.Quantity;
          var4 := RowData2.Quantity;
        end;
    5 : begin
          var3 := RowData1.description;
          var4 := RowData2.description;
        end
    else
    begin
      var3 := RowData1.ProductCode;
      var4 := RowData2.ProductCode
    end;
  end;

  if CB_Sort1Type = 1 then
  begin
    if var1 < var2 then
      Result := -1
    else if var1 = var2 then
    begin
      if CB_Sort2Type = 1 then
      begin
        if var3 < var4 then
           Result := -1
        else if var3 > var4 then
           Result := 1
        else
           Result := 0
      end
      else
      begin
        if var3 < var4 then
           Result := 1
        else if var3 > var4 then
           Result := -1
        else
           Result := 0
      end;
    end
    else
      Result := 1;
  end
  else
  begin
    if var1 < var2 then
      Result := 1
    else if var1 = var2 then
    begin
      if CB_Sort2Type = 1 then
      begin
        if var3 < var4 then
           Result := -1
        else if var3 > var4 then
           Result := 1
        else
           Result := 0
      end
      else
      begin
        if var3 < var4 then
           Result := 1
        else if var3 > var4 then
           Result := -1
        else
           Result := 0
      end;
    end
    else
      Result := -1;
  end;
end;

//----------------------------------------------------------------------------//

procedure TMBalanceHeadersForm.FilterContainsStr;
var
  I : Integer;
  TempList : TList;
begin
  m_RowList.clear;
  for I  := 0 to m_OrigRowList.Count - 1 do
  begin
    case CBFilt1.ItemIndex of
      0 : begin
            if AnsiContainsStr(PTDetailRows(m_OrigRowList[I]).ArtType , EditFilt1.Text) then
               m_RowList.Add(m_OrigRowList[I]);
          end;
      1 : begin
            if AnsiContainsStr(PTDetailRows(m_OrigRowList[I]).ProductCode , EditFilt1.Text) then
               m_RowList.Add(m_OrigRowList[I]);
          end;
      2 : begin
            if AnsiContainsStr(PTDetailRows(m_OrigRowList[I]).NetGroupPtr.m_Code , EditFilt1.Text) then
               m_RowList.Add(m_OrigRowList[I]);
          end;
      3 : begin
            if AnsiContainsStr(PTDetailRows(m_OrigRowList[I]).Date , EditFilt1.Text) then
               m_RowList.Add(m_OrigRowList[I]);
          end;
      4 : begin
            if AnsiContainsStr(FloatToStr(PTDetailRows(m_OrigRowList[I]).Quantity) , EditFilt1.Text) then
               m_RowList.Add(m_OrigRowList[I]);
          end;

      5 : begin
            if AnsiContainsStr(PTDetailRows(m_OrigRowList[I]).description , EditFilt1.Text) then
               m_RowList.Add(m_OrigRowList[I]);
          end;

    end;
  end;

  if EditFilt2.Text <> '' then
  begin
    TempList := TList.Create;
    for I  := 0 to m_RowList.Count - 1 do
      TempList.Add(m_RowList[I]);
    m_RowList.clear;

    for I := 0 to TempList.Count - 1 do
    begin
      case CBFilt2.ItemIndex of
        0 : begin
              if AnsiContainsStr(PTDetailRows(TempList[I]).ArtType , EditFilt2.Text) then
                 m_RowList.Add(TempList[I]);
            end;
        1 : begin
              if AnsiContainsStr(PTDetailRows(TempList[I]).ProductCode , EditFilt2.Text) then
                 m_RowList.Add(TempList[I]);
            end;
        2 : begin
              if AnsiContainsStr(PTDetailRows(TempList[I]).NetGroupPtr.m_Code , EditFilt2.Text) then
                 m_RowList.Add(TempList[I]);
            end;
        3 : begin
              if AnsiContainsStr(PTDetailRows(TempList[I]).Date , EditFilt2.Text) then
                 m_RowList.Add(TempList[I]);
            end;
        4 : begin
              if AnsiContainsStr(FloatToStr(PTDetailRows(TempList[I]).Quantity) , EditFilt2.Text) then
                 m_RowList.Add(TempList[I]);
            end;

        5 : begin
              if AnsiContainsStr(PTDetailRows(TempList[I]).description , EditFilt2.Text) then
                 m_RowList.Add(TempList[I]);
            end;
      end;
    end;
    TempList.Clear;
    TempList.Free;
  end;
  m_RowList.Sort(SortBalanceColumns);
  RefreshGridForList;
end;

procedure TMBalanceHeadersForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree
end;

procedure TMBalanceHeadersForm.FormDestroy(Sender: TObject);
begin

end;

//----------------------------------------------------------------------------//

constructor TMBalanceHeadersForm.CreateBalanceHeadersForm(AOwner: TComponent;
  RowList: Tlist);
var
  I : integer;
begin
  inherited create(Aowner);
  m_RowList := TList.Create;
  m_OrigRowList := TList.Create;
  m_OrigRowList := RowList;
  for I := 0 to m_OrigRowList.Count - 1 do
    m_RowList.Add(m_OrigRowList[I]);
  IniComboBoxes;
  CBSort1TypeChange(self);
  CBSort2TypeChange(self);
  m_LastCBSort1Index := -1;
  m_LastCBSort1TypeIndex := -1;
  m_LastCBSort2Index := -1;
  m_LastCBSort2TypeIndex := -1;
  RefreshGridForList ;

  ReShape(Self);
{  ReShape(SpdBnFiltShowAll);
  ReShape(SpdBtnsSort);
  ReShape(SpdBtnFilter); }
end;

//----------------------------------------------------------------------------//

procedure TMBalanceHeadersForm.SGRowDetailsBalanceHdrDblClick(Sender: TObject);
var
  FBalanceChange: TFBalanceChange;
  FoundId : TSchedId;
begin
  try
    if (m_SelectedRow = 0) or (m_RowList.Count = 0) then
       Exit;
    FBalanceChange := TFBalanceChange.CreateBalanceChangeForm(self, PTDetailRows(m_RowList.Items[m_SelectedRow - 1]));
    FBalanceChange.ShowModal;
    FBalanceChange.Free;
    PTDetailRows(m_RowList.Items[m_SelectedRow - 1]).NetGroupPtr.m_lastBalanceUpdatedTime := now;

    FoundId := p_sc.GetIdForRefreshAllBalanceJobs(PTDetailRows(m_RowList.Items[m_SelectedRow - 1]).ArtType,
                    PTDetailRows(m_RowList.Items[m_SelectedRow - 1]).ProductCode,
                    PTDetailRows(m_RowList.Items[m_SelectedRow - 1]).NetGroupPtr.m_Code);
    if FoundId <> CSchedIDnull then
      p_sc.UpdateBalance( FoundId );
    if (CBSort1.ItemIndex = 3) or (CBSort2.ItemIndex = 3) then
      m_RowList.Sort(SortBalanceColumns);

    RefreshGridForList;
    SGRowDetailsBalanceHdr.Refresh;

  except
    on e:Exception do MessageDlg('FMBalanceChange - TMBalanceHeadersForm'+#13'Message: '+e.Message,mtError, [mbOK],0);
  end;
end;

//----------------------------------------------------------------------------//

procedure TMBalanceHeadersForm.SGRowDetailsBalanceHdrSelectCell(Sender: TObject;
  ACol, ARow: Integer; var CanSelect: Boolean);
begin
  m_SelectedRow := ARow;
end;

//----------------------------------------------------------------------------//

procedure TMBalanceHeadersForm.SpdBnFiltShowAllClick(Sender: TObject);
var
  I : Integer;
  Save_Cursor : TCursor;
begin
  Save_Cursor   := Screen.Cursor;
  Screen.Cursor  := crSQLWait;
  m_RowList.clear;
  for I  := 0 to m_OrigRowList.Count - 1 do
    m_RowList.Add(m_OrigRowList[I]);
  m_RowList.Sort(SortBalanceColumns);
  RefreshGridForList;
  Screen.Cursor := Save_Cursor;
end;

//----------------------------------------------------------------------------//

procedure TMBalanceHeadersForm.SpdBtnFilterClick(Sender: TObject);
var
  Save_Cursor : TCursor;
begin
  Save_Cursor   := Screen.Cursor;
  Screen.Cursor := crSQLWait;
  FilterContainsStr;
  Screen.Cursor := Save_Cursor;
end;

//----------------------------------------------------------------------------//

procedure TMBalanceHeadersForm.SpdBtnsSortClick(Sender: TObject);
var
  Save_Cursor : TCursor;
begin
  if (CBSort1.ItemIndex = CBSort2.ItemIndex) then
  begin
    showmessage('Please choose diferent sort criteria');
    Exit
  end;

  if (m_LastCBSort1Index = CBSort1.ItemIndex) and
     (m_LastCBSort1TypeIndex = CBSort1Type.ItemIndex) and
     (m_LastCBSort2Index = CBSort2.ItemIndex) and
     (m_LastCBSort2TypeIndex = CBSort2Type.ItemIndex) then
     Exit;

  Save_Cursor   := Screen.Cursor;
  Screen.Cursor  := crSQLWait;
  m_RowList.Sort(SortBalanceColumns);
  RefreshGridForList;
  Screen.Cursor := Save_Cursor;

  m_LastCBSort1Index := CBSort1.ItemIndex;
  m_LastCBSort1TypeIndex := CBSort1Type.ItemIndex;
  m_LastCBSort2Index := CBSort2.ItemIndex;
  m_LastCBSort2TypeIndex := CBSort2Type.ItemIndex;

end;

end.
