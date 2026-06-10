unit FMcfgBin;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls,
 // TeeProcs, TeEngine, Chart,
  ComCtrls, StdCtrls, Grids , UMglobal, UMBinDefault,  // UMBinMatDefault,
  Buttons, Menus, CheckLst, UMbinFunc, gnugettext, Vcl.Samples.Spin, UReShape, ExSpinEdit;

type

  RestoredType = (RS_Pos,RS_Width,RS_Ord,RS_Vis,RS_Title);
  TConfigTabType = (Tb_default, Tb_BinTab, Tb_FilterSlot, Tb_Search, Tb_AutoSeqResults, Tb_defaultWarp, Tb_WarpCompatible, Tb_SchedJobSequence);

  TFConfigBin = class(TForm)
    grbColLabel: TGroupBox;
    grbVisibleCol: TGroupBox;
    grbColPos: TGroupBox;
    lboxColLabel: TListBox;
    EdtColLabel: TEdit;
    lblIntMaxChar: TLabel;
    grdColPos: TStringGrid;
    btnRestoreColPos: TcxButton;
    mnuReload: TMainMenu;
    MiRestore: TMenuItem;
    MIDefaultConfig: TMenuItem;
    Bevel1: TBevel;
    cboxColVis: TCheckListBox;
    btnRestoreVColWidth: TcxButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    grbColOrder: TGroupBox;
    grdOrdCol: TStringGrid;
    ChkBoxSortType: TCheckListBox;
    Panel1: TPanel;
    SpinEdtNumberofcolumnSorted: TexSpinEdit;
    Label1: TLabel;
    bbtnOk: TcxButton;
    bbtnAbort: TcxButton;
    btnRestoreColVis: TcxButton;
    btnRestoreColLabel: TcxButton;
    btnRefColLabel: TcxButton;
    Panel2: TPanel;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Panel3: TPanel;
    procedure lboxColLabelClick(Sender: TObject);
    procedure btnRefColLabelClick(Sender: TObject);
    procedure btnRestoreColLabelClick(Sender: TObject);
    procedure btnRestoreColPosClick(Sender: TObject);
    procedure bbtnAbortClick(Sender: TObject);
    procedure bbtnOkClick(Sender: TObject);
    procedure cboxColVisClickCheck(Sender: TObject);
    procedure btnRestoreColVisClick(Sender: TObject);
    procedure grdOrdColRowMoved(Sender: TObject; FromIndex,
      ToIndex: Integer);
//    procedure btnRestoreOrdColClick(Sender: TObject);
    procedure grdColPosMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure grdColPosMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure grdOrdColMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure grdOrdColMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure grdColPosColumnMoved(Sender: TObject; FromIndex,
      ToIndex: Integer);
    procedure btnRestoreVColWidthClick(Sender: TObject);
    procedure MIDefaultConfigClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure ChkBoxSortTypeClick(Sender: TObject);
    procedure SpinEdtNumberofcolumnSortedChange(Sender: TObject);
    procedure PageControl1DrawTab(Control: TCustomTabControl; TabIndex: Integer;
      const Rect: TRect; Active: Boolean);

  private
    LocArray : array [0..High(BinColDefault)] of TBinColCurrent;
    m_ConfigTabType : TConfigTabType;
    m_FieldsCount : integer;
    LabelModified : boolean;
    PosModified : boolean;
    VisModified : boolean;
    OrderModified : boolean;
    NumberColumnSortedModified : boolean;
    procedure PrepStartData;
    procedure Restrod(Restored : RestoredType);
    procedure SaveNewSet;
    function CheckValues : boolean;
    procedure ResetColWidth;
    procedure LoadCaptions;
    procedure RefreshComponents;
    procedure refreshSortType;
  public
    constructor CreateCfgBin(AOwner : Tcomponent ; ConfigTabType : TConfigTabType);
    destructor Destroy ; override;
  end;

var
  FConfigBin: TFConfigBin;

implementation

uses
  UMBinTbs,
  UMbinGrid,
  UMbinGridMaterial,
  UMSchedContFunc,
  UMCompat,
  UMBinMatDefault,
//  UMglobal
  UGglobal,
  FMbin;

 {$R *.DFM}

//----------------------------------------------------------------------------//
//   TFConfigBin                                                              //
//----------------------------------------------------------------------------//

constructor TFConfigBin.CreateCfgBin(AOwner: Tcomponent ; ConfigTabType : TConfigTabType);
var
  I : Integer;
begin
  inherited create(AOwner);
  ScaleFormSize(Self, Screen.PixelsPerInch);
  TranslateComponent(self);
  m_ConfigTabType := ConfigTabType;

  if m_ConfigTabType in [Tb_default, Tb_FilterSlot, Tb_Search, Tb_AutoSeqResults, Tb_WarpCompatible, Tb_SchedJobSequence] then
  begin
    m_FieldsCount := GetNumberFields;
  end
  else
  begin
    if (m_ConfigTabType = Tb_defaultWarp) or (fbin.GetActiveView.m_BinPanel.GetFiltParms.P_MaterialSchedFilter) then
      m_FieldsCount := GetNumberFieldsMat
    else
      m_FieldsCount := GetNumberFields;
  end;

  LabelModified := False;
  PosModified := False;
  VisModified := False;
  OrderModified := False;
  NumberColumnSortedModified := false;
  // Be sure the StringGrid Width is ok for visualization
  grdColPos.RowCount := 2;
  grdColPos.ColCount := m_FieldsCount;
  grdOrdCol.RowCount := m_FieldsCount;
//  ChkBoxSortType.Count := m_FieldsCount;
  for I := Low(DBAppGlobals.ShowBinPropArry) to high(DBAppGlobals.ShowBinPropArry) do
  begin
    if (DBAppGlobals.ShowBinPropArry[I] <> nil) then
      grdOrdCol.RowCount := grdOrdCol.RowCount + 1
    else
      break;
  end;
//  ChkBoxSortType.Count := grdOrdCol.RowCount;
  grdColPos.ColCount := grdOrdCol.RowCount;
  grdOrdCol.Width := 183;
  grdOrdCol.ColWidths[0] := 178;

  LoadCaptions;
  PrepStartData;
  lboxColLabel.ItemIndex := 0;
  lboxColLabelClick(self);
  FConfigBin := self;
//  m_ChangeTitle := false;

  ReShape(Self);
end;

//----------------------------------------------------------------------------//

destructor TFConfigBin.Destroy;
begin
  inherited Destroy;
end;

//----------------------------------------------------------------------------//

procedure TFConfigBin.bbtnAbortClick(Sender: TObject);
begin
  FConfigBin.Close;
end;

//----------------------------------------------------------------------------//

procedure TFConfigBin.PageControl1DrawTab(Control: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
begin
  //Mihailo 09.06.2020.
  with Control.Canvas do begin
    Brush.Color := clWhite;
    FillRect(Rect);
    TextOut(Rect.Left + Font.Size -5, Rect.Top + 2, (Control as TPageControl).Pages[TabIndex].Caption) ;
  end;
end;

procedure TFConfigBin.PrepStartData;
var
  i:    integer;
  binGrid: TBinDrawGrid;
  BinMatGrid : TBinDrawGridMat;
begin

  if m_ConfigTabType = Tb_BinTab then
  begin
    if TBinTabSheet(fbin.GetActiveView).m_BinPanel.GetFiltParms.P_MaterialSchedFilter then
    begin
      BinMatGrid := FBin.GetActiveView.GetMatGrid;

      // Prepare the Starting Data of Bin settings
      for i := low(BinMatGrid.BinMatColumnSet) to high(BinMatGrid.BinMatColumnSet) do
        with LocArray[i] do
        begin
          Field   := BinMatGrid.BinMatColumnSet[i].Field;
          Title   := BinMatGrid.BinMatColumnSet[i].Title;
          Pos     := BinMatGrid.BinMatColumnSet[i].Pos;
          Width   := BinMatGrid.BinMatColumnSet[i].Width;
          Visible := BinMatGrid.BinMatColumnSet[i].Visible;
          Order   := BinMatGrid.BinMatColumnSet[i].Order;
          DescendingSort := BinMatGrid.BinMatColumnSet[i].DescendingSort;
          NumColSorted   := BinMatGrid.BinMatColumnSet[i].NumColSorted
        end;

    end else
    begin
      binGrid := FBin.GetActiveView.GetBinGrid;

      // Prepare the Starting Data of Bin settings
      for i := low(binGrid.BinColumnSet) to high(binGrid.BinColumnSet) do
        with LocArray[i] do
        begin
          Field   := binGrid.BinColumnSet[i].Field;
          Title   := binGrid.BinColumnSet[i].Title;
          Pos     := binGrid.BinColumnSet[i].Pos;
          Width   := binGrid.BinColumnSet[i].Width;
          Visible := binGrid.BinColumnSet[i].Visible;
          Order   := binGrid.BinColumnSet[i].Order;
          DescendingSort := binGrid.BinColumnSet[i].DescendingSort;
          NumColSorted   := binGrid.BinColumnSet[i].NumColSorted
        end;
    end;



  end

  else if m_ConfigTabType = Tb_default then

  begin
    if not (DBAppGlobals.Language = 'en') and not BinDefaultFromDB then
       UMBinDefault.ConfBinLoadDefaultValues(BinDefaultTabColumnSet);
    for i := low(BinDefaultTabColumnSet) to high(BinDefaultTabColumnSet) do
      with LocArray[i] do
      begin
        Field   := BinDefaultTabColumnSet[i].Field;
        Title   := BinDefaultTabColumnSet[i].Title;
        Pos     := BinDefaultTabColumnSet[i].Pos;
        Width   := BinDefaultTabColumnSet[i].Width;
        Visible := BinDefaultTabColumnSet[i].Visible;
        Order   := BinDefaultTabColumnSet[i].Order;
        DescendingSort := BinDefaultTabColumnSet[i].DescendingSort;
        NumColSorted   := BinDefaultTabColumnSet[i].NumColSorted
      end;

  end

  else if m_ConfigTabType = Tb_FilterSlot then
  begin
    if not (DBAppGlobals.Language = 'en') and not BinDefaultFromDB_Slot then
       UMBinDefault.ConfBinLoadDefaultValues(BinDefaultTabSlotFilter);
    for i := low(BinDefaultTabSlotFilter) to high(BinDefaultTabSlotFilter) do
      with LocArray[i] do
      begin
        Field   := BinDefaultTabSlotFilter[i].Field;
        Title   := BinDefaultTabSlotFilter[i].Title;
        Pos     := BinDefaultTabSlotFilter[i].Pos;
        Width   := BinDefaultTabSlotFilter[i].Width;
        Visible := BinDefaultTabSlotFilter[i].Visible;
        Order   := BinDefaultTabSlotFilter[i].Order;
        DescendingSort := BinDefaultTabSlotFilter[i].DescendingSort;
        NumColSorted   := BinDefaultTabSlotFilter[i].NumColSorted
      end;

  end

  else if m_ConfigTabType = Tb_Search then
  begin
    if not (DBAppGlobals.Language = 'en') and not BinDefaultFromDB_Search then
       UMBinDefault.ConfBinLoadDefaultValues(BinDefaultTabSearch);
    for i := low(BinDefaultTabSearch) to high(BinDefaultTabSearch) do
      with LocArray[i] do
      begin
        Field   := BinDefaultTabSearch[i].Field;
        Title   := BinDefaultTabSearch[i].Title;
        Pos     := BinDefaultTabSearch[i].Pos;
        Width   := BinDefaultTabSearch[i].Width;
        Visible := BinDefaultTabSearch[i].Visible;
        Order   := BinDefaultTabSearch[i].Order;
        DescendingSort := BinDefaultTabSearch[i].DescendingSort;
        NumColSorted   := BinDefaultTabSearch[i].NumColSorted
      end;

  end

  else if m_ConfigTabType = Tb_AutoSeqResults then
  begin
    if not (DBAppGlobals.Language = 'en') and not BinDefaultFromDB_AutoSeqResults then
       UMBinDefault.ConfBinLoadDefaultValues(BinDefaultTabAutoSeqResults);
    for i := low(BinDefaultTabAutoSeqResults) to high(BinDefaultTabAutoSeqResults) do
      with LocArray[i] do
      begin
        Field   := BinDefaultTabAutoSeqResults[i].Field;
        Title   := BinDefaultTabAutoSeqResults[i].Title;
        Pos     := BinDefaultTabAutoSeqResults[i].Pos;
        Width   := BinDefaultTabAutoSeqResults[i].Width;
        Visible := BinDefaultTabAutoSeqResults[i].Visible;
        Order   := BinDefaultTabAutoSeqResults[i].Order;
        DescendingSort := BinDefaultTabAutoSeqResults[i].DescendingSort;
        NumColSorted   := BinDefaultTabAutoSeqResults[i].NumColSorted
      end;

  end
  else if m_ConfigTabType = Tb_defaultWarp then
  begin
    if not (DBAppGlobals.Language = 'en') and not BinDefaultFromDB_Mat then
       UMBinMatDefault.ConfBinLoadDefaultValues(BinMatDefaultTabColumnSet);

    for i := low(BinMatDefaultTabColumnSet) to high(BinMatDefaultTabColumnSet) do
      with LocArray[i] do
      begin
        Field   := BinMatDefaultTabColumnSet[i].Field;
        Title   := BinMatDefaultTabColumnSet[i].Title;
        Pos     := BinMatDefaultTabColumnSet[i].Pos;
        Width   := BinMatDefaultTabColumnSet[i].Width;
        Visible := BinMatDefaultTabColumnSet[i].Visible;
        Order   := BinMatDefaultTabColumnSet[i].Order;
        DescendingSort := BinMatDefaultTabColumnSet[i].DescendingSort;
        NumColSorted   := BinMatDefaultTabColumnSet[i].NumColSorted
      end;

  end
  else if m_ConfigTabType = Tb_WarpCompatible then
  begin
    if not (DBAppGlobals.Language = 'en') and not BinDefaultFromDB_Material_Compatible then
       UMBinDefault.ConfBinLoadDefaultValues(BinDefaultTabCompColumnSet);

    for i := low(BinDefaultTabCompColumnSet) to high(BinDefaultTabCompColumnSet) do
      with LocArray[i] do
      begin
        Field   := BinDefaultTabCompColumnSet[i].Field;
        Title   := BinDefaultTabCompColumnSet[i].Title;
        Pos     := BinDefaultTabCompColumnSet[i].Pos;
        Width   := BinDefaultTabCompColumnSet[i].Width;
        Visible := BinDefaultTabCompColumnSet[i].Visible;
        Order   := BinDefaultTabCompColumnSet[i].Order;
        DescendingSort := BinDefaultTabCompColumnSet[i].DescendingSort;
        NumColSorted   := BinDefaultTabCompColumnSet[i].NumColSorted
      end;

  end
  else if m_ConfigTabType = Tb_SchedJobSequence then
  begin
    if not (DBAppGlobals.Language = 'en') and not BinDefaultFromDB_SchedJobSequence then
       UMBinDefault.ConfBinLoadDefaultValuesSchedJobSeq(BinDefaultTabSchedJobSequence);

    for i := low(BinDefaultTabSchedJobSequence) to high(BinDefaultTabSchedJobSequence) do
      with LocArray[i] do
      begin
        Field   := BinDefaultTabSchedJobSequence[i].Field;
        Title   := BinDefaultTabSchedJobSequence[i].Title;
        Pos     := BinDefaultTabSchedJobSequence[i].Pos;
        Width   := BinDefaultTabSchedJobSequence[i].Width;
        Visible := BinDefaultTabSchedJobSequence[i].Visible;
        Order   := BinDefaultTabSchedJobSequence[i].Order;
        DescendingSort := BinDefaultTabSchedJobSequence[i].DescendingSort;
        NumColSorted   := BinDefaultTabSchedJobSequence[i].NumColSorted
      end;
  end;

  if LocArray[0].NumColSorted = 0 then
    SpinEdtNumberofcolumnSorted.Value := 3
  else
    SpinEdtNumberofcolumnSorted.Value := LocArray[0].NumColSorted;

  RefreshComponents
end;

//----------------------------------------------------------------------------//

procedure TFConfigBin.RefreshComponents;
var
  i,k, num: integer;
  PId : TPropID;
  PropPosition, Index: Integer;
  Prop : string;
begin
  lboxColLabel.Items.Clear;
  cboxColVis.Items.Clear;

  for I := low(LocArray) to (m_FieldsCount - 1) do
  begin
    // Load ListBox Vis, Col
    if Trim(LocArray[I].Title) = '' then
      continue;

    lboxColLabel.Items.Add(LocArray[I].Title);
    cboxColVis.Items.Add(LocArray[I].Title);
    cboxColVis.Checked[cboxColVis.Items.Count - 1] := LocArray[I].Visible;
  end;

  Index := 0;

  for I := 0 to high(DBAppGlobals.ShowBinPropArry) do
  begin
    if not (DBAppGlobals.ShowBinPropArry[I] = nil) then
      Index := Index + 1
    else
      break;
  end;

  PropPosition := m_FieldsCount + Index;
  num := -1;

  for I := m_FieldsCount to (PropPosition - 1) do
  begin

    case (LocArray[I].Field) of
      CSC_property1:   num := 0;
      CSC_property2:   num := 1;
      CSC_property3:   num := 2;
      CSC_property4:   num := 3;
      CSC_property5:   num := 4;
      CSC_property6:   num := 5;
      CSC_property7:   num := 6;
      CSC_property8:   num := 7;
      CSC_property9:   num := 8;
      CSC_property10:  num := 9;
      CSC_property11:  num := 10;
      CSC_property12:  num := 11;
      CSC_property13:  num := 12;
      CSC_property14:  num := 13;
      CSC_property15:  num := 14;
      CSC_property16:  num := 15;
      CSC_property17:  num := 16;
      CSC_property18:  num := 17;
      CSC_property19:  num := 18;
      CSC_property20:  num := 19;
      CSC_property21:  num := 20;
      CSC_property22:  num := 21;
      CSC_property23:  num := 22;
      CSC_property24:  num := 23;
      CSC_property25:  num := 24;
      CSC_property26:  num := 25;
      CSC_property27:  num := 26;
      CSC_property28:  num := 27;
      CSC_property29:  num := 28;
      CSC_property30:  num := 29;
      CSC_property31:  num := 30;
      CSC_property32:  num := 31;
      CSC_property33:  num := 32;
      CSC_property34:  num := 33;
      CSC_property35:  num := 34;
      CSC_property36:  num := 35;
      CSC_property37:  num := 36;
      CSC_property38:  num := 37;
      CSC_property39:  num := 38;
      CSC_property40:  num := 39;
      CSC_property41:  num := 40;
      CSC_property42:  num := 41;
      CSC_property43:  num := 42;
      CSC_property44:  num := 43;
      CSC_property45:  num := 44;
      CSC_property46:  num := 45;
      CSC_property47:  num := 46;
      CSC_property48:  num := 47;
      CSC_property49:  num := 48;
      CSC_property50:  num := 49;
      CSC_property51:  num := 50;
      CSC_property52:  num := 51;
      CSC_property53:  num := 52;
      CSC_property54:  num := 53;
      CSC_property55:  num := 54;
      CSC_property56:  num := 55;
      CSC_property57:  num := 56;
      CSC_property58:  num := 57;
      CSC_property59:  num := 58;
      CSC_property60:  num := 59
    end;

    if (num <> -1) then
    begin
      pId := DBAppGlobals.ShowBinPropArry[num];
      if pId <> nil then
      begin
        cboxColVis.Items.Add(GetPropDescr(pId));
        cboxColVis.Checked[cboxColVis.Items.Count - 1] := LocArray[I].Visible;
        Prop := GetPropDescr(pId);
        if trim(LocArray[I].Title) <> '' then
        begin
          cboxColVis.Items.strings[cboxColVis.Items.count -1] := LocArray[I].Title;
          lboxColLabel.Items.Add(LocArray[I].Title)
        end
        else
          lboxColLabel.Items.Add(Prop);
      end;
    end;
  end;

  K := 0;
  for I := low(LocArray) to high(LocArray) do
  begin
    num := -1;

    case (LocArray[I].Field) of
      CSC_property1:   num := 0;
      CSC_property2:   num := 1;
      CSC_property3:   num := 2;
      CSC_property4:   num := 3;
      CSC_property5:   num := 4;
      CSC_property6:   num := 5;
      CSC_property7:   num := 6;
      CSC_property8:   num := 7;
      CSC_property9:   num := 8;
      CSC_property10:  num := 9;
      CSC_property11:  num := 10;
      CSC_property12:  num := 11;
      CSC_property13:  num := 12;
      CSC_property14:  num := 13;
      CSC_property15:  num := 14;
      CSC_property16:  num := 15;
      CSC_property17:  num := 16;
      CSC_property18:  num := 17;
      CSC_property19:  num := 18;
      CSC_property20:  num := 19;
      CSC_property21:  num := 20;
      CSC_property22:  num := 21;
      CSC_property23:  num := 22;
      CSC_property24:  num := 23;
      CSC_property25:  num := 24;
      CSC_property26:  num := 25;
      CSC_property27:  num := 26;
      CSC_property28:  num := 27;
      CSC_property29:  num := 28;
      CSC_property30:  num := 29;
      CSC_property31:  num := 30;
      CSC_property32:  num := 31;
      CSC_property33:  num := 32;
      CSC_property34:  num := 33;
      CSC_property35:  num := 34;
      CSC_property36:  num := 35;
      CSC_property37:  num := 36;
      CSC_property38:  num := 37;
      CSC_property39:  num := 38;
      CSC_property40:  num := 39;
      CSC_property41:  num := 40;
      CSC_property42:  num := 41;
      CSC_property43:  num := 42;
      CSC_property44:  num := 43;
      CSC_property45:  num := 44;
      CSC_property46:  num := 45;
      CSC_property47:  num := 46;
      CSC_property48:  num := 47;
      CSC_property49:  num := 48;
      CSC_property50:  num := 49;
      CSC_property51:  num := 50;
      CSC_property52:  num := 51;
      CSC_property53:  num := 52;
      CSC_property54:  num := 53;
      CSC_property55:  num := 54;
      CSC_property56:  num := 55;
      CSC_property57:  num := 56;
      CSC_property58:  num := 57;
      CSC_property59:  num := 58;
      CSC_property60:  num := 59
    end;

    if (num <> -1) then
    begin
      pId := DBAppGlobals.ShowBinPropArry[num];
      if pId <> nil then
      begin
        if (LocArray[K].Title <> ' ') and (LocArray[K].Title <> '') then
          grdOrdCol.Cells[0, LocArray[K].Order] := LocArray[K].Title
        else
        begin
          grdOrdCol.Cells[0, LocArray[K].Order] := GetPropDescr(pId);
          LocArray[K].Title := grdOrdCol.Cells[0, LocArray[K].Order];
        end;

        if (LocArray[K].Title <> ' ') and (LocArray[K].Title <> '') then
          grdColPos.Cells[LocArray[K].Pos, 0] := LocArray[K].Title
        else
          grdColPos.Cells[LocArray[K].Pos, 0] := GetPropDescr(pId);

        if not LocArray[K].Visible then
          grdColPos.ColWidths[LocArray[K].Pos]  := -1
        else
          grdColPos.ColWidths[LocArray[K].Pos]  := LocArray[K].Width;
    //    LocArray[I].Title := grdOrdCol.Cells[0, LocArray[K].Order];

        LocArray[I].Title := lboxColLabel.Items.Strings[K];

        K := K + 1

      end;
    end else
    begin
      if Trim(LocArray[K].Title) = '' then
        continue;

      grdOrdCol.Cells[0, LocArray[K].Order] := LocArray[K].Title;
      grdColPos.Cells[LocArray[K].Pos, 0] := LocArray[K].Title;

      if not LocArray[K].Visible then
        grdColPos.ColWidths[LocArray[K].Pos]  := -1
      else
        grdColPos.ColWidths[LocArray[K].Pos] := LocArray[K].Width;

      K := K + 1
    end;

  end;

  if (lboxColLabel.ItemIndex < 0) then
    lboxColLabel.ItemIndex := 0;

  EdtColLabel.Text := lboxColLabel.Items.Strings[lboxColLabel.ItemIndex];
  refreshSortType;
end;

procedure TFConfigBin.refreshSortType;
var
  I,J : Integer;
begin
  ChkBoxSortType.Items.Clear;
  for I := 0 to grdOrdCol.RowCount - 1 do
  begin
    ChkBoxSortType.Items.Add(grdOrdCol.Cells[0, I]);
    ChkBoxSortType.Font.Name := 'Montserrat';
    for J := 0 to High(LocArray) do
    begin
      if (grdOrdCol.Cells[0, I] = LocArray[J].Title) then
      begin
        if LocArray[J].DescendingSort then
          ChkBoxSortType.Checked[I] := true;
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFConfigBin.Restrod(Restored : RestoredType);
var
  binGrid : TBinDrawGrid;
  BinGridMat : TBinDrawGridMat;
  K,I,Num : Integer;
  PId : TPropID;
  IsExistProp : boolean;
  PropPosition : integer;
begin
  PropPosition := GetNumberFields;
  if m_ConfigTabType = Tb_BinTab then
  begin

    if FBin.GetActiveView.m_BinPanel.GetFiltParms.P_MaterialSchedFilter then
    begin
      BinGridMat := FBin.GetActiveView.GetMatGrid;

      // Prepare the Starting Data of Bin settings
      for I := low(BinGridMat.BinMatColumnSet) to high(BinGridMat.BinMatColumnSet) do
        with LocArray[I] do
        begin
          Field   := BinGridMat.BinMatColumnSet[i].Field;
          case Restored of
            RS_Ord : Order := BinGridMat.BinMatColumnSet[i].Order;
            RS_Pos : Pos := BinGridMat.BinMatColumnSet[i].Pos;
            RS_Title : Title := UMBinMatDefault.GiveTempTitle(BinColDefault[i].Title, IsExistProp, PropPosition);//binGrid.BinColumnSet[i].Title;
            RS_Width : Width := BinGridMat.BinMatColumnSet[i].Width;
            RS_Vis   : Visible := BinGridMat.BinMatColumnSet[i].Visible;
          end;
        end;
    end else
    begin
      binGrid := FBin.GetActiveView.GetBinGrid;

      // Prepare the Starting Data of Bin settings
      for I := low(binGrid.BinColumnSet) to high(binGrid.BinColumnSet) do
        with LocArray[I] do
        begin
          Field   := binGrid.BinColumnSet[i].Field;
          case Restored of
            RS_Ord : Order := binGrid.BinColumnSet[i].Order;
            RS_Pos : Pos := binGrid.BinColumnSet[i].Pos;
            RS_Title : Title := UMBinDefault.GiveTempTitle(BinColDefault[i].Title, IsExistProp, PropPosition);//binGrid.BinColumnSet[i].Title;
            RS_Width : Width := binGrid.BinColumnSet[i].Width;
            RS_Vis   : Visible := binGrid.BinColumnSet[i].Visible;
          end;
        end;
    end;


  end
  else if m_ConfigTabType = Tb_default then
  begin
    for I := low(BinDefaultTabColumnSet) to high(BinDefaultTabColumnSet) do
      with LocArray[I] do
      begin
        Field   := BinDefaultTabColumnSet[i].Field;
        case Restored of
          RS_Ord : Order := BinDefaultTabColumnSet[i].Order;
          RS_Pos : Pos := BinDefaultTabColumnSet[i].Pos;
          RS_Title : begin
                       Title := UMBinDefault.GiveTempTitle(BinColDefault[i].Title, IsExistProp, PropPosition);
                     end;
          RS_Width : Width := BinDefaultTabColumnSet[i].Width;
          RS_Vis   : Visible := BinDefaultTabColumnSet[i].Visible;
        end;
      end;
  end

  else if m_ConfigTabType = Tb_FilterSlot then
  begin
    for I := low(BinDefaultTabSlotFilter) to high(BinDefaultTabSlotFilter) do
      with LocArray[I] do
      begin
        Field   := BinDefaultTabSlotFilter[i].Field;
        case Restored of
          RS_Ord : Order := BinDefaultTabSlotFilter[i].Order;
          RS_Pos : Pos := BinDefaultTabSlotFilter[i].Pos;
          RS_Title : begin
                       Title := GiveTempTitle(BinColDefault[i].Title, IsExistProp, PropPosition);
                     end;
          RS_Width : Width := BinDefaultTabSlotFilter[i].Width;
          RS_Vis   : Visible := BinDefaultTabSlotFilter[i].Visible;
        end;
      end;
  end

  else if m_ConfigTabType = Tb_Search then
  begin
    for I := low(BinDefaultTabSearch) to high(BinDefaultTabSearch) do
      with LocArray[I] do
      begin
        Field   := BinDefaultTabSearch[i].Field;
        case Restored of
          RS_Ord : Order := BinDefaultTabSearch[i].Order;
          RS_Pos : Pos := BinDefaultTabSearch[i].Pos;
          RS_Title : begin
                       Title := GiveTempTitle(BinColDefault[i].Title, IsExistProp, PropPosition);
                     end;
          RS_Width : Width := BinDefaultTabSearch[i].Width;
          RS_Vis   : Visible := BinDefaultTabSearch[i].Visible;
        end;
      end;
  end

  else if m_ConfigTabType = Tb_AutoSeqResults then
  begin
    for I := low(BinDefaultTabAutoSeqResults) to high(BinDefaultTabAutoSeqResults) do
      with LocArray[I] do
      begin
        Field   := BinDefaultTabAutoSeqResults[i].Field;
        case Restored of
          RS_Ord : Order := BinDefaultTabAutoSeqResults[i].Order;
          RS_Pos : Pos := BinDefaultTabAutoSeqResults[i].Pos;
          RS_Title : begin
                       Title := GiveTempTitle(BinColDefault[i].Title, IsExistProp, PropPosition);
                     end;
          RS_Width : Width := BinDefaultTabAutoSeqResults[i].Width;
          RS_Vis   : Visible := BinDefaultTabAutoSeqResults[i].Visible;
        end;
      end;
  end
  else if m_ConfigTabType = Tb_SchedJobSequence then
  begin
    for I := low(BinDefaultTabSchedJobSequence) to high(BinDefaultTabSchedJobSequence) do
      with LocArray[I] do
      begin
        Field   := BinDefaultTabSchedJobSequence[i].Field;
        case Restored of
          RS_Ord : Order := BinDefaultTabSchedJobSequence[i].Order;
          RS_Pos : Pos := BinDefaultTabSchedJobSequence[i].Pos;
          RS_Title : begin
                       Title := GiveTempTitle(BinColDefault[i].Title, IsExistProp, PropPosition);
                     end;
          RS_Width : Width := BinDefaultTabSchedJobSequence[i].Width;
          RS_Vis   : Visible := BinDefaultTabSchedJobSequence[i].Visible;
        end;
      end;
  end;

  case Restored of
    RS_Ord,RS_Pos,RS_Width :
    begin
      K := 0;
      for I := low(LocArray) to high(LocArray) do
      begin
        num := -1;
        case (LocArray[I].Field) of
          CSC_property1:   num := 0;
          CSC_property2:   num := 1;
          CSC_property3:   num := 2;
          CSC_property4:   num := 3;
          CSC_property5:   num := 4;
          CSC_property6:   num := 5;
          CSC_property7:   num := 6;
          CSC_property8:   num := 7;
          CSC_property9:   num := 8;
          CSC_property10:  num := 9;
          CSC_property11:  num := 10;
          CSC_property12:  num := 11;
          CSC_property13:  num := 12;
          CSC_property14:  num := 13;
          CSC_property15:  num := 14;
          CSC_property16:  num := 15;
          CSC_property17:  num := 16;
          CSC_property18:  num := 17;
          CSC_property19:  num := 18;
          CSC_property20:  num := 19;
          CSC_property21:  num := 20;
          CSC_property22:  num := 21;
          CSC_property23:  num := 22;
          CSC_property24:  num := 23;
          CSC_property25:  num := 24;
          CSC_property26:  num := 25;
          CSC_property27:  num := 26;
          CSC_property28:  num := 27;
          CSC_property29:  num := 28;
          CSC_property30:  num := 29;
          CSC_property31:  num := 30;
          CSC_property32:  num := 31;
          CSC_property33:  num := 32;
          CSC_property34:  num := 33;
          CSC_property35:  num := 34;
          CSC_property36:  num := 35;
          CSC_property37:  num := 36;
          CSC_property38:  num := 37;
          CSC_property39:  num := 38;
          CSC_property40:  num := 39;
          CSC_property41:  num := 40;
          CSC_property42:  num := 41;
          CSC_property43:  num := 42;
          CSC_property44:  num := 43;
          CSC_property45:  num := 44;
          CSC_property46:  num := 45;
          CSC_property47:  num := 46;
          CSC_property48:  num := 47;
          CSC_property49:  num := 48;
          CSC_property50:  num := 49;
          CSC_property51:  num := 50;
          CSC_property52:  num := 51;
          CSC_property53:  num := 52;
          CSC_property54:  num := 53;
          CSC_property55:  num := 54;
          CSC_property56:  num := 55;
          CSC_property57:  num := 56;
          CSC_property58:  num := 57;
          CSC_property59:  num := 58;
          CSC_property60:  num := 59

        end;

        if (num <> -1) then
        begin
          pId := DBAppGlobals.ShowBinPropArry[num];
          if pId <> nil then
          begin
            case Restored of
              RS_Ord : grdOrdCol.Cells[0, LocArray[K].Order] := GetPropCodeFromID(pId);
              RS_Pos : grdColPos.Cells[LocArray[K].Pos, 0] := GetPropCodeFromID(pId);
              RS_Width  : grdColPos.ColWidths[LocArray[K].Pos] := LocArray[K].Width;
            end;
            K := K + 1
          end;
        end
        else
        begin
          case Restored of
            RS_Ord : grdOrdCol.Cells[0, LocArray[K].Order] := LocArray[K].Title;
            RS_Pos : grdColPos.Cells[LocArray[K].Pos, 0] := LocArray[K].Title;
            RS_Width : grdColPos.ColWidths[k] := LocArray[K].Width;
          end;
          K := K + 1
        end;
      end;
    end;

    RS_Vis :
    begin
      cboxColVis.Items.Clear;
      for I := low(LocArray) to (m_FieldsCount - 1) do
      begin
        cboxColVis.Items.Add(LocArray[I].Title);
        cboxColVis.Checked[cboxColVis.Items.Count - 1] := LocArray[I].Visible;
      end;
    end;
    RS_Title :
    begin
      for I := low(LocArray) to (m_FieldsCount - 1) do
        lboxColLabel.Items.Strings[I] := LocArray[I].Title;
      lboxColLabelClick(self);
    end;
  end;

end;

//----------------------------------------------------------------------------//

procedure TFConfigBin.lboxColLabelClick(Sender: TObject);
begin
  EdtColLabel.Text := lboxColLabel.Items.Strings[lboxColLabel.ItemIndex];
  btnRefColLabel.Enabled := true;
  EdtColLabel.Enabled := true
end;

//----------------------------------------------------------------------------//

procedure TFConfigBin.btnRefColLabelClick(Sender: TObject);
var
  i : integer;
begin
  if Trim(EdtColLabel.Text) = '' then
    begin
      // column must have almost a char
      MessageDlg(_('At least one char must be enter'), mtWarning, [mbOk], 0);
      EdtColLabel.Text := lboxColLabel.Items.Strings[lboxColLabel.ItemIndex];
      Exit;
    end;
  if Trim(EdtColLabel.Text) <>
       lboxColLabel.Items.Strings[lboxColLabel.ItemIndex] then
    begin
      // Check if already exist the string
      for i := low(LocArray) to high(LocArray) do
        if (Trim(EdtColLabel.Text) = LocArray[i].Title) then
        begin
          // Label already exist
          MessageDlg(_('Label already exist'), mtWarning, [mbOk], 0);
          Exit;
        end;
      for i := low(LocArray) to high(LocArray) do
        if lboxColLabel.Items.Strings[lboxColLabel.ItemIndex] = LocArray[i].Title then
        begin
          LocArray[i].Title := EdtColLabel.Text;
     //     m_ChangeTitle := true;
          lboxColLabel.Items.Strings[i] := LocArray[i].Title;
        end;
      LabelModified := True;
    end;
  RefreshComponents
end;

//----------------------------------------------------------------------------//

procedure TFConfigBin.btnRestoreColLabelClick(Sender: TObject);
begin
  Restrod(RS_Title);
  LabelModified := true;
end;

//----------------------------------------------------------------------------//

procedure TFConfigBin.grdColPosColumnMoved(Sender: TObject; FromIndex,
                                           ToIndex: Integer);
var
  i : integer;
  ItmToMod : integer;
begin

  if FromIndex = ToIndex then Exit;
  ItmToMod := -1;

  for i := low(LocArray) to high(LocArray) do
    if LocArray[i].Pos = FromIndex then
    begin
      ItmToMod := i;
      break;
    end;

  if FromIndex < ToIndex then
  begin
    for i := low(LocArray) to high(LocArray) do
      if (LocArray[i].Pos > FromIndex) and (LocArray[i].Pos <= ToIndex) and
         (ItmToMod <> i) then
        LocArray[i].Pos := LocArray[i].Pos - 1;
  end else
  begin
    for i := low(LocArray) to high(LocArray) do
      if (LocArray[i].Pos < FromIndex) and (LocArray[i].Pos >= ToIndex) and
         (ItmToMod <> i) then
        LocArray[i].Pos := LocArray[i].Pos + 1;
  end;

  LocArray[ItmToMod].Pos := ToIndex;
  PosModified := true

end;

//----------------------------------------------------------------------------//

procedure TFConfigBin.btnRestoreColPosClick(Sender: TObject);
begin
  Restrod(RS_Pos);
  PosModified := false
end;

//----------------------------------------------------------------------------//

procedure TFConfigBin.bbtnOkClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  if not CheckValues then ModalResult := mrNone;
  if (ModalResult <> mrNone) and ((LabelModified) or (PosModified) or
                                  (VisModified) or (OrderModified)) then
  begin
    SaveNewSet;
    ModalResult := mrOk;
  end;

end;

//----------------------------------------------------------------------------//

procedure TFConfigBin.SaveNewSet;
var
  i, k :    integer;
  binGrid: TBinDrawGrid;
  binGridMat: TBinDrawGridMat;
  tbs:     TBinTabSheet;
begin

  if m_ConfigTabType = Tb_BinTab then
  begin

    tbs     := FBin.GetActiveView;

    if tbs.m_BinPanel.GetFiltParms.P_MaterialSchedFilter then
    begin
       binGridMat := tbs.GetMatGrid;

      // Save New Set in Local Array
      for i := low(binGridMat.BinMatColumnSet) to high(binGridMat.BinMatColumnSet) do
        for k := low(LocArray) to high(LocArray) do
          if binGridMat.BinMatColumnSet[i].Field = LocArray[k].Field then
          begin
         //   if m_ChangeTitle then
            binGridMat.BinMatColumnSet[i].Title   := LocArray[k].Title;
            binGridMat.BinMatColumnSet[i].Pos     := LocArray[k].Pos;
            binGridMat.BinMatColumnSet[i].Visible := LocArray[k].Visible;
            binGridMat.BinMatColumnSet[i].Width   := LocArray[k].Width;
            binGridMat.BinMatColumnSet[i].DescendingSort := LocArray[k].DescendingSort;
            binGridMat.BinMatColumnSet[i].Order   := LocArray[k].Order;
            binGridMat.BinMatColumnSet[i].NumColSorted := SpinEdtNumberofcolumnSorted.Value;
          end;
    end else
    begin

      binGrid := tbs.GetBinGrid;

      // Save New Set in Local Array
      for i := low(binGrid.BinColumnSet) to high(binGrid.BinColumnSet) do
        for k := low(LocArray) to high(LocArray) do
          if binGrid.BinColumnSet[i].Field = LocArray[k].Field then
          begin
         //   if m_ChangeTitle then
            binGrid.BinColumnSet[i].Title   := LocArray[k].Title;
            binGrid.BinColumnSet[i].Pos     := LocArray[k].Pos;
            binGrid.BinColumnSet[i].Visible := LocArray[k].Visible;
            binGrid.BinColumnSet[i].Width   := LocArray[k].Width;
            binGrid.BinColumnSet[i].DescendingSort := LocArray[k].DescendingSort;
            binGrid.BinColumnSet[i].Order   := LocArray[k].Order;
            binGrid.BinColumnSet[i].NumColSorted := SpinEdtNumberofcolumnSorted.Value;
          end;
    end;

     FBin.SetSortIndex(tbs.m_BinPanel, 0);
  end

  else if m_ConfigTabType = Tb_default then
  begin
    for i := low(BinDefaultTabColumnSet) to high(BinDefaultTabColumnSet) do
      for k := low(LocArray) to high(LocArray) do
        if BinDefaultTabColumnSet[i].Field = LocArray[k].Field then
        begin
      //    if m_ChangeTitle then
          BinDefaultTabColumnSet[i].Title   := LocArray[k].Title;
          BinDefaultTabColumnSet[i].Pos     := LocArray[k].Pos;
          BinDefaultTabColumnSet[i].Visible := LocArray[k].Visible;
          BinDefaultTabColumnSet[i].Width   := LocArray[k].Width;
          BinDefaultTabColumnSet[i].DescendingSort := LocArray[k].DescendingSort;
          BinDefaultTabColumnSet[i].Order   := LocArray[k].Order;
          BinDefaultTabColumnSet[i].NumColSorted   := SpinEdtNumberofcolumnSorted.Value;
        end;

  end

  else if m_ConfigTabType = Tb_FilterSlot then
  begin
    for i := low(BinDefaultTabSlotFilter) to high(BinDefaultTabSlotFilter) do
      for k := low(LocArray) to high(LocArray) do
        if BinDefaultTabSlotFilter[i].Field = LocArray[k].Field then
        begin
      //    if m_ChangeTitle then
          BinDefaultTabSlotFilter[i].Title   := LocArray[k].Title;
          BinDefaultTabSlotFilter[i].Pos     := LocArray[k].Pos;
          BinDefaultTabSlotFilter[i].Visible := LocArray[k].Visible;
          BinDefaultTabSlotFilter[i].Width   := LocArray[k].Width;
          BinDefaultTabSlotFilter[i].DescendingSort := LocArray[k].DescendingSort;
          BinDefaultTabSlotFilter[i].Order   := LocArray[k].Order;
          BinDefaultTabSlotFilter[i].NumColSorted   := SpinEdtNumberofcolumnSorted.Value;
        end;
  end

  else if m_ConfigTabType = Tb_Search then
  begin
    for i := low(BinDefaultTabSearch) to high(BinDefaultTabSearch) do
      for k := low(LocArray) to high(LocArray) do
        if BinDefaultTabSearch[i].Field = LocArray[k].Field then
        begin
      //    if m_ChangeTitle then
          BinDefaultTabSearch[i].Title   := LocArray[k].Title;
          BinDefaultTabSearch[i].Pos     := LocArray[k].Pos;
          BinDefaultTabSearch[i].Visible := LocArray[k].Visible;
          BinDefaultTabSearch[i].Width   := LocArray[k].Width;
          BinDefaultTabSearch[i].DescendingSort := LocArray[k].DescendingSort;
          BinDefaultTabSearch[i].Order   := LocArray[k].Order;
          BinDefaultTabSearch[i].NumColSorted   := SpinEdtNumberofcolumnSorted.Value;
        end;
  end

  else if m_ConfigTabType = Tb_AutoSeqResults then
  begin
    for i := low(BinDefaultTabAutoSeqResults) to high(BinDefaultTabAutoSeqResults) do
      for k := low(LocArray) to high(LocArray) do
        if BinDefaultTabAutoSeqResults[i].Field = LocArray[k].Field then
        begin
      //    if m_ChangeTitle then
          BinDefaultTabAutoSeqResults[i].Title   := LocArray[k].Title;
          BinDefaultTabAutoSeqResults[i].Pos     := LocArray[k].Pos;
          BinDefaultTabAutoSeqResults[i].Visible := LocArray[k].Visible;
          BinDefaultTabAutoSeqResults[i].Width   := LocArray[k].Width;
          BinDefaultTabAutoSeqResults[i].DescendingSort := LocArray[k].DescendingSort;
          BinDefaultTabAutoSeqResults[i].Order   := LocArray[k].Order;
          BinDefaultTabAutoSeqResults[i].NumColSorted   := SpinEdtNumberofcolumnSorted.Value;
        end;
  end
  else if m_ConfigTabType = Tb_defaultWarp then
  begin
    for i := low(BinMatDefaultTabColumnSet) to high(BinMatDefaultTabColumnSet) do
      for k := low(LocArray) to high(LocArray) do
        if BinMatDefaultTabColumnSet[i].Field = LocArray[k].Field then
        begin
      //    if m_ChangeTitle then
          BinMatDefaultTabColumnSet[i].Title   := LocArray[k].Title;
          BinMatDefaultTabColumnSet[i].Pos     := LocArray[k].Pos;
          BinMatDefaultTabColumnSet[i].Visible := LocArray[k].Visible;
          BinMatDefaultTabColumnSet[i].Width   := LocArray[k].Width;
          BinMatDefaultTabColumnSet[i].DescendingSort := LocArray[k].DescendingSort;
          BinMatDefaultTabColumnSet[i].Order   := LocArray[k].Order;
          BinMatDefaultTabColumnSet[i].NumColSorted   := SpinEdtNumberofcolumnSorted.Value;
        end;
  end
  else if m_ConfigTabType = Tb_WarpCompatible then
  begin
    for i := low(BinDefaultTabCompColumnSet) to high(BinDefaultTabCompColumnSet) do
      for k := low(LocArray) to high(LocArray) do
        if BinDefaultTabCompColumnSet[i].Field = LocArray[k].Field then
        begin
      //    if m_ChangeTitle then
          BinDefaultTabCompColumnSet[i].Title   := LocArray[k].Title;
          BinDefaultTabCompColumnSet[i].Pos     := LocArray[k].Pos;
          BinDefaultTabCompColumnSet[i].Visible := LocArray[k].Visible;
          BinDefaultTabCompColumnSet[i].Width   := LocArray[k].Width;
          BinDefaultTabCompColumnSet[i].DescendingSort := LocArray[k].DescendingSort;
          BinDefaultTabCompColumnSet[i].Order   := LocArray[k].Order;
          BinDefaultTabCompColumnSet[i].NumColSorted   := SpinEdtNumberofcolumnSorted.Value;
        end;
  end
  else if m_ConfigTabType = Tb_SchedJobSequence then
  begin
    for i := low(BinDefaultTabSchedJobSequence) to high(BinDefaultTabSchedJobSequence) do
      for k := low(LocArray) to high(LocArray) do
        if BinDefaultTabSchedJobSequence[i].Field = LocArray[k].Field then
        begin
      //    if m_ChangeTitle then
          BinDefaultTabSchedJobSequence[i].Title   := LocArray[k].Title;
          BinDefaultTabSchedJobSequence[i].Pos     := LocArray[k].Pos;
          BinDefaultTabSchedJobSequence[i].Visible := LocArray[k].Visible;
          BinDefaultTabSchedJobSequence[i].Width   := LocArray[k].Width;
          BinDefaultTabSchedJobSequence[i].DescendingSort := LocArray[k].DescendingSort;
          BinDefaultTabSchedJobSequence[i].Order   := LocArray[k].Order;
          BinDefaultTabSchedJobSequence[i].NumColSorted   := SpinEdtNumberofcolumnSorted.Value;
        end;
  end;

  LabelModified := False;
  PosModified := False;
  VisModified := False;
  OrderModified := False;
  NumberColumnSortedModified := false;

end;

//----------------------------------------------------------------------------//

procedure TFConfigBin.SpinEdtNumberofcolumnSortedChange(Sender: TObject);
begin
  NumberColumnSortedModified := true;
  OrderModified := true;
  if SpinEdtNumberofcolumnSorted.Value > 12 then
     SpinEdtNumberofcolumnSorted.Value := 12;
end;

//----------------------------------------------------------------------------//

procedure TFConfigBin.TabControl1Change(Sender: TObject);
begin

end;

//----------------------------------------------------------------------------//

procedure TFConfigBin.cboxColVisClickCheck(Sender: TObject);
var
  i, K, num: integer;
  PId : TPropID;
begin
  for I := 0 to cboxColVis.Items.Count - 1 do
    LocArray[i].Visible := cboxColVis.Checked[I];
  VisModified := True;

  K := 0;
  for I := low(LocArray) to high(LocArray) do
  begin
    num := -1;

    case (LocArray[I].Field) of
      CSC_property1:   num := 0;
      CSC_property2:   num := 1;
      CSC_property3:   num := 2;
      CSC_property4:   num := 3;
      CSC_property5:   num := 4;
      CSC_property6:   num := 5;
      CSC_property7:   num := 6;
      CSC_property8:   num := 7;
      CSC_property9:   num := 8;
      CSC_property10:  num := 9;
      CSC_property11:  num := 10;
      CSC_property12:  num := 11;
      CSC_property13:  num := 12;
      CSC_property14:  num := 13;
      CSC_property15:  num := 14;
      CSC_property16:  num := 15;
      CSC_property17:  num := 16;
      CSC_property18:  num := 17;
      CSC_property19:  num := 18;
      CSC_property20:  num := 19;
      CSC_property21:  num := 20;
      CSC_property22:  num := 21;
      CSC_property23:  num := 22;
      CSC_property24:  num := 23;
      CSC_property25:  num := 24;
      CSC_property26:  num := 25;
      CSC_property27:  num := 26;
      CSC_property28:  num := 27;
      CSC_property29:  num := 28;
      CSC_property30:  num := 29;
      CSC_property31:  num := 30;
      CSC_property32:  num := 31;
      CSC_property33:  num := 32;
      CSC_property34:  num := 33;
      CSC_property35:  num := 34;
      CSC_property36:  num := 35;
      CSC_property37:  num := 36;
      CSC_property38:  num := 37;
      CSC_property39:  num := 38;
      CSC_property40:  num := 39;
      CSC_property41:  num := 40;
      CSC_property42:  num := 41;
      CSC_property43:  num := 42;
      CSC_property44:  num := 43;
      CSC_property45:  num := 44;
      CSC_property46:  num := 45;
      CSC_property47:  num := 46;
      CSC_property48:  num := 47;
      CSC_property49:  num := 48;
      CSC_property50:  num := 49;
      CSC_property51:  num := 50;
      CSC_property52:  num := 51;
      CSC_property53:  num := 52;
      CSC_property54:  num := 53;
      CSC_property55:  num := 54;
      CSC_property56:  num := 55;
      CSC_property57:  num := 56;
      CSC_property58:  num := 57;
      CSC_property59:  num := 58;
      CSC_property60:  num := 59

    end;

    if (num <> -1) then
    begin
      pId := DBAppGlobals.ShowBinPropArry[num];
      if pId = nil then
        continue
    end;

    if not (LocArray[K].Visible) and (Trim(LocArray[K].Title) <> '') then
      grdColPos.ColWidths[LocArray[K].Pos]  := -1
    else
    begin
      if (LocArray[K].Width = -1) then
         LocArray[K].Width := 80;

      if Trim(LocArray[K].Title) <> '' then
        if LocArray[K].Width > 0 then
          grdColPos.ColWidths[LocArray[K].Pos]  := LocArray[K].Width;
    end;
    Inc(K)
  end;
end;

//----------------------------------------------------------------------------//

procedure TFConfigBin.btnRestoreColVisClick(Sender: TObject);
begin
  Restrod(RS_Vis);
  VisModified := False
end;

//----------------------------------------------------------------------------//

function TFConfigBin.CheckValues : boolean;
var
  i : integer;
begin
  Result := False;
  // Check if all columns not visible
  for i := 0 to cboxColVis.Items.Count -1 do
    if cboxColVis.Checked[i] then
      Result := True;
  if not Result then
    begin
      // almost a column must be visible
      MessageDlg(_('At Least one column must be visible'), mtWarning, [mbOk], 0);
      Exit;
    end;
  // Check if the Edit component is not the same with ther label column
  if Trim(EdtColLabel.Text) <>
       Trim(lboxColLabel.Items.Strings[lboxColLabel.ItemIndex]) then
    begin
      // you must apply the title modified before exit
      MessageDlg(_('you must apply the title modified before exit'), mtWarning, [mbOk], 0);
      Result := False;
    end
  else Result := True
end;

//----------------------------------------------------------------------------//

procedure TFConfigBin.ChkBoxSortTypeClick(Sender: TObject);
var
  I,J : Integer;
begin
  ChkBoxSortType := TCheckListBox(Sender);
  if ChkBoxSortType.Checked[ChkBoxSortType.ItemIndex] then
    ChkBoxSortType.Checked[ChkBoxSortType.ItemIndex] := true
  else
    ChkBoxSortType.Checked[ChkBoxSortType.ItemIndex] := false;

  for I := 0 to ChkBoxSortType.Count - 1 do
  begin
    for J := 0 to High(LocArray) do
    begin
      if (ChkBoxSortType.Items[I] = LocArray[J].Title) then
      begin
        if ChkBoxSortType.Checked[I] then
          LocArray[J].DescendingSort := true
        else
          LocArray[J].DescendingSort := false;
      end;
    end;
  end;
  OrderModified := True;
end;

//----------------------------------------------------------------------------//

procedure TFConfigBin.grdOrdColRowMoved(Sender: TObject; FromIndex,
  ToIndex: Integer);
var
  i : integer;
  ItmToMod : integer;
begin
  if FromIndex = ToIndex then Exit;
  ItmToMod := -1;

  for i := low(LocArray) to high(LocArray) do
    if LocArray[i].Order = FromIndex then
    begin
      ItmToMod := i;
      break;
    end;

  if FromIndex < ToIndex then
  begin
    for i := low(LocArray) to high(LocArray) do
      if (LocArray[i].Order > FromIndex) and (LocArray[i].Order <= ToIndex) and
         (ItmToMod <> i) then
        LocArray[i].Order := LocArray[i].Order - 1;
  end else
  begin
    for i := low(LocArray) to high(LocArray) do
      if (LocArray[i].Order < FromIndex) and (LocArray[i].Order >= ToIndex) and
         (ItmToMod <> i) then
        LocArray[i].Order := LocArray[i].Order + 1;
  end;

  LocArray[ItmToMod].Order := ToIndex;
  OrderModified := True;
  refreshSortType;
end;

//----------------------------------------------------------------------------//

//procedure TFConfigBin.btnRestoreOrdColClick(Sender: TObject);
//begin
//  Restrod(RS_Ord);
//  OrderModified := False
//end;

//----------------------------------------------------------------------------//

procedure TFConfigBin.grdColPosMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Screen.Cursor := crDrag;
end;

//----------------------------------------------------------------------------//

procedure TFConfigBin.grdColPosMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Screen.Cursor := crDefault;
  ResetColWidth;
end;

//----------------------------------------------------------------------------//

procedure TFConfigBin.grdOrdColMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Screen.Cursor := crDrag;
end;

//----------------------------------------------------------------------------//

procedure TFConfigBin.grdOrdColMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Screen.Cursor := crDefault;
end;

//----------------------------------------------------------------------------//

procedure TFConfigBin.FormCreate(Sender: TObject);
begin
  grdOrdCol.ColWidths[0] := 300;
end;

//----------------------------------------------------------------------------//

procedure TFConfigBin.btnRestoreVColWidthClick(Sender: TObject);
begin
  Restrod(RS_Width);
  PosModified := false
end;

//----------------------------------------------------------------------------//

procedure TFConfigBin.ResetColWidth;
var
  i, k : integer;
begin
  for i := low(LocArray) to high(LocArray) do
    for k := low(LocArray) to high(LocArray) do
      if (LocArray[i].Title = grdColPos.Cells[k, 0]) and
         (LocArray[i].Width <> grdColPos.ColWidths[k]) then
        begin
          LocArray[i].Width := grdColPos.ColWidths[k];
          PosModified := True;
        end;
end;

//----------------------------------------------------------------------------//

procedure TFConfigBin.LoadCaptions;
begin
  Caption := _('Bin configuration');
  grbColLabel.Caption            := _('Column title');
  lblIntMaxChar.Caption          := _('Caption title');
  btnRefColLabel.Caption         := _('Apply');
  btnRestoreColLabel.Caption     := _('Restore');
  grbVisibleCol.Caption          := _('Visible column');
  btnRestoreColVis.Caption       := _('Restore');
  grbColPos.Caption              := _('Pos/Width columns');
  btnRestoreColPos.Caption       := _('Restore pos.');
  btnRestoreVColWidth.Caption    := _('Restore width');
  grbColOrder.Caption            := _('Sort by');
//  btnRestoreOrdCol.Caption       := _('Restore');
  bbtnOk.Caption                 := _('OK');
  bbtnAbort.Caption              := _('Abort');
  MiRestore.Caption              := _('Restore');
  MIDefaultConfig.Caption        := _('Default configuration');
end;

//----------------------------------------------------------------------------//

procedure TFConfigBin.MIDefaultConfigClick(Sender: TObject);
begin
  if TBinTabSheet(fbin.GetActiveView).m_BinPanel.GetFiltParms.P_MaterialSchedFilter then
    UMBinMatDefault.ConfBinLoadDefaultValues(LocArray)
  else
    UMBinDefault.ConfBinLoadDefaultValues(LocArray);
  LabelModified := true;
  PosModified := true;
  VisModified := true;
  OrderModified := true;
  RefreshComponents;

end;

end.
