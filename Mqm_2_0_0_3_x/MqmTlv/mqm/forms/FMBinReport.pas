unit FMBinReport;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,UMTabCfg, Vcl.Menus,
  cxGraphics, dxUIAClasses, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator,
  dxDateRanges, dxScrollbarAnnotations, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxClasses, cxGridLevel, cxGrid, System.ImageList,
  Vcl.ImgList, cxImageList, gnugettext, StrUtils, UMSchedContFunc, UMBinGrid, TypInfo, UMBinDefault,  UMSchedList, UMbinGridMaterial,
  cxGridCustomPopupMenu, cxGridPopupMenu, dxPSGlbl, dxPSUtl, dxPSEngn, dxPrnPg,
  dxBkgnd, dxWrap, dxPrnDev, dxPSCompsProvider, dxPSFillPatterns,
  dxPSEdgePatterns, dxPSPDFExportCore, dxPSPDFExport, cxDrawTextUtils,
  dxPSPrVwStd, dxPScxPageControlProducer, dxPScxGridLnk,
  dxPScxGridLayoutViewLnk, dxPScxEditorProducers, dxPScxExtEditorProducers,
  dxPSCore, dxPScxCommon, dxCalloutPopup, Vcl.StdCtrls, dxRangeControl, Generics.Collections,
  cxCheckBox, cxContainer, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCheckComboBox;

type
  TcxViewInfoAcess = class(TcxGridTableDataCellViewInfo);
  TcxPainterAccess = class(TcxGridTableDataCellPainter);

  TFBinRep = class(TForm)
    pmNewBin: TPopupMenu;
    miFilters: TMenuItem;
    miGroupinheader: TMenuItem;
    miColumnfilter: TMenuItem;
    miSearchbox: TMenuItem;
    miColumnhideshow: TMenuItem;
    Rename1: TMenuItem;
    ExporttoExcel1: TMenuItem;
    Applybestfit1: TMenuItem;
    DXGridLevel1: TcxGridLevel;
    DXGrid: TcxGrid;
    DXGridView: TcxGridTableView;
    cxImageList1: TcxImageList;
    cxStyleRepository1: TcxStyleRepository;
    cxStyle1: TcxStyle;
    cxGridPopupMenu1: TcxGridPopupMenu;
    Export1: TMenuItem;
    XLS1: TMenuItem;
    XLS2: TMenuItem;
    dxComponentPrinter1: TdxComponentPrinter;
    dxComponentPrinter1Link1: TdxGridReportLink;
    CSV1: TMenuItem;
    XML1: TMenuItem;
    HTML1: TMenuItem;
    Print1: TMenuItem;
    Full1: TMenuItem;
    Full2: TMenuItem;
    Full3: TMenuItem;
    Dataonly1: TMenuItem;
    dxRangeControl1: TdxRangeControl;
    GroupBox1: TGroupBox;
    dxCalloutPopup1: TdxCalloutPopup;
    cxCheckComboBox1: TcxCheckComboBox;
    procedure DXGridViewMouseDown(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
    procedure miFiltersClick(Sender: TObject);
    procedure miColumnfilterClick(Sender: TObject);
    procedure ExporttoExcel1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure GridViewStylesGetContentStyle(Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
    procedure XLS1Click(Sender: TObject);
    procedure XLS2Click(Sender: TObject);
    procedure CSV1Click(Sender: TObject);
    procedure XML1Click(Sender: TObject);
    procedure HTML1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Print1Click(Sender: TObject);
    procedure cxGridPopupMenu1Popup(ASenderMenu: TComponent; AHitTest: TcxCustomGridHitTest; X, Y: Integer; var AllowPopup: Boolean);
    procedure CustomizeMenu(Sender: TObject);
    procedure dxRangeControl1DrawContent(Sender: TdxCustomRangeControl;
      ACanvas: TcxCanvas; AViewInfo: TdxRangeControlCustomClientViewInfo;
      var AHandled: Boolean);
    procedure dxRangeControl1SelectedRangeChanged(Sender: TObject);
    procedure dxRangeControl1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cxCheckComboBox1PropertiesEditValueChanged(Sender: TObject);
    procedure cxCheckComboBox1FocusChanged(Sender: TObject);
    procedure DXGridViewCellDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure GetText(Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;var AText: string);
  private
    AppArray : TArray<integer>;
    m_TbCfg  : TBinTabCfg;
    m_DefColumnHeaderList : TStringList;
    m_TabCode : Integer;
    m_isMatbingrid : Boolean;
    m_ColumnHeaderList : TStringList;
    m_BinColumnSet: array of TBinColCurrent;
    m_StaticColCount : Integer;
    m_Caption : string;
    m_FilterColumn : TcxGridColumn;
    FDateTimeHeaderClientData1: TDictionary<TDateTime, Integer>;
    procedure CreateColumns;
    procedure CreateRows;
    procedure GridViewCustomDrawCellMat(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    procedure GridViewCustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    Function  GetSelectedSchedID(Row : Integer): TSchedID;
    function  StringToCBinColId(const value: string): CBinColId;
    function  CBinColIdToString(value: CBinColId): string;
    function  GetColumnTitleFromColID(BinColId : CBinColId) : String;
    Procedure RetakeColumnSet;
    procedure UpdateArray;
    procedure FillArrayBinColByCod(var BinColArray : array of TBinColCurrent);
    procedure OrganizePosOerForTabs;
    function  FindPos(pos: integer): integer;
    Function  GetGridData: TStringList;
    Function  GetColWidthMat(Col : Integer): Integer;
    Function  GetColWidth(Col : Integer): Integer;
    Procedure RepCreateColumns(Data: Variant);
    Procedure RepCreateRows(Data: Variant);
    Procedure CreateRangeData(Sender : TObject);
  public
    constructor CreateBinReport(AOWner : TComponent; cfg : TBinTabCfg);
    constructor CreateReport(AOWner : TComponent; Data: Variant);
  end;

var
  FBinRep: TFBinRep;
  m_selectedColumn, m_TSchedIDCol : TcxGridColumn;

  const m_fixed_col = 9;

implementation

{$R *.dfm}

uses FMBin, UmGlobal, UMBinTbs, UMCompat, UMBinPanel, UMObjCont, UMCompatClr, UMSchedCont, cxTextStorage
  , dxSkinTheBezier, cxGridStdPopupMenu, Math, dxGdiPlusClasses, cxGeometry
  ,UMBinFunc, UMTblDesc, UMBinMatDefault, FMShowColorsBar, FMGroupDetail, cxStorage, DateUtils
  ,cxGridExportLink,dxMessageDialog,  cxFindPanel, IniFiles,ComObj, dxSpreadSheet;

{ TFBinRep }

procedure TFBinRep.GetText(Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;var AText: string);
var dt : TDateTime;
begin
  if TryStrToDateTime(AText, dt) then
    if dt = 0 then
      AText := '';
end;

function ExcelInstalled: boolean;
  var
    XLApp: OLEVariant;
  begin
    Result := False;
    try
      XLApp := CreateOleObject('Excel.Application');
      if not VarIsEmpty(XLApp) then
      begin
        Result := True;
        XLApp.Quit;
        XLAPP := Unassigned;
      end;
    except
      Result := False;
    end;
  end;

procedure TFBinRep.GridViewStylesGetContentStyle(
 Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
 AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);

 function HexToInt(HexNum: string): LongInt;
  begin
     Result:=StrToInt('$' + HexNum);
  end;

 var pID : TPropID;
 val : Variant;
 r,g,b : Byte;
 PropColor : TColor;
 BinView : CScBinView;
 id : TSchedID;
begin
  //if m_binGridMat is TBinDrawGridMat then exit;

  if AItem = nil then exit;
  if ARecord.Index = -1 then exit;

 { if (copy(TcxGridColumn(AItem).HeaderHint,0,3) = 'fix')
  or (copy(TcxGridColumn(AItem).HeaderHint,0,3) = 'CSC')
    then exit;   }
  AStyle := TcxStyle.Create(nil);
  AStyle.Color := ClWhite;


  //PROPERTIES
  if (copy(TcxGridColumn(AItem).HeaderHint,0,3) <> 'fix') and (copy(TcxGridColumn(AItem).HeaderHint,0,3) <> 'CSC')
  and (TcxGridColumn(AItem).HeaderHint <> 'TSchedID') then
  begin
    if DBAppSettings.ShowBinPropColors then
    begin
      pID := GetIdFromCode(TcxGridColumn(AItem).HeaderHint);
      val := ARecord.Values[AItem.Index];
      if val = null  then val := '----';

      if not CheckPropExistByID(pId) then exit;

      if IsPropAsRGB(pId) and (Val <> '----') then
      begin
        try
          r := HexToInt(Copy(Val, 1, 2));
          g := HexToInt(Copy(Val, 3, 2));
          B := HexToInt(Copy(Val, 5, 2));
          AStyle.Color := RGB(R, G, B);
        except
          AStyle.Color := ClWhite;
        end;
        Val := '';
      end
      else
      begin
        if GetColorPropFromPropID(pId,Val,PropColor) then
           AStyle.Color := PropColor;
      end;
    end;
  end;// else


  //READ ONLY
  if (copy(TcxGridColumn(AItem).HeaderHint,0,3) <> 'fix') then
  begin
    id := GetSelectedSchedID(ARecord.Index);// TSchedId(TBinPanel(TBinTabSheet(DXGrid.Parent).m_BinPanel).m_ObjList.GetLink(ARecord.Index));
     if id < 0 then exit;
    BinView := p_sc.GetVisbleInBin(id);

    if BinView = CSB_ReadOnly then
    begin
      AStyle.Color := 14079702;//clGrayText;
      exit;
    end;
  end;// else  //static fields


  if (copy(TcxGridColumn(AItem).HeaderHint,0,4) <> 'fix0') and (copy(TcxGridColumn(AItem).HeaderHint,0,4) <> 'fix1')
  then
  begin
    id := GetSelectedSchedID(ARecord.Index);//TSchedId(TBinPanel(TBinTabSheet(DXGrid.Parent).m_BinPanel).m_ObjList.GetLink(ARecord.Index));

    if id < 0 then exit;

    if p_sc.HasFlags(id, [CSF_selected, CSF_compInBin]) then
    begin
      if IsGroupFormOut then
      begin
        AStyle.Color := clGreen;
        AStyle.Font.Color := clblack;
        exit;
      end
      else if TBinPanel(TBinTabSheet(DXGrid.Parent).m_BinPanel).GetFiltParms.P_SeqFilter then
      begin
        if (DBAppSettings.CreateNewBinTabForCompatibles = NewB_Yes_MarkCompatibleAndToSchedJobs) or
          (DBAppSettings.CreateNewBinTabForCompatibles = NewB_Yes_ShowOnlyCompatibles) then
        begin
          AStyle.Color := clGreen;
          AStyle.Font.Color := clblack;
          exit;
        end;
      end
      else
      begin
        if DBAppSettings.ShowCompatibleInExistingBINS = ShowC_Yes_MarkTheCompatibles then
        begin
          AStyle.Color := clGreen;
          AStyle.Font.Color := clblack;
          exit;
        end;
      end;

    end else
    begin
      if ((p_sc.GetSchedObjStatus(id) = CSS_From_PG) or (p_sc.CheckSchedSumQty(Id))) then
      begin
        AStyle.Color := clRed;
        AStyle.Font.Color := clblack;
        exit;
      end
      else if (p_sc.GetSchedMsgFromHost(id) <> CSH_No_Chg) then
      begin
        AStyle.Color := clLime;
        AStyle.Font.Color := clblack;
        exit;
      end
      else if BinView <> CSB_ReadOnly then  // avi change 13082020
      begin
        {if AStyle.Color = ClWhite then

        AStyle.Color := clWhite;
        exit;  }
      end;
    end;
  end;

end;

procedure TFBinRep.HTML1Click(Sender: TObject);
var saveDialog : TSaveDialog;
var ASheet1: TdxSpreadSheet;
begin
  saveDialog := TSaveDialog.Create(self);
  saveDialog.Title := _('Export as') + ':';
  saveDialog.InitialDir := GetCurrentDir;

  saveDialog.Filter := 'Hypertext Markup Language|*.html';
  saveDialog.DefaultExt := 'html';

  if saveDialog.Execute then
  begin
    ExportGridToHTML(saveDialog.FileName, DXGrid);
  {ASheet1 := TdxSpreadSheet.Create(Self);
  ASheet1.LoadFromFile(saveDialog.FileName);
  ASheet1.ActiveSheetAsTable.DeleteColumns(0,3);
  ASheet1.SaveToFile(saveDialog.FileName);
  ASheet1.Free;   }
    Showmessage('Done');
  end;

  saveDialog.Free;

end;

Function TFBinRep.GetColWidthMat(Col : Integer): Integer;
var i, k : integer;
begin
  result := -1;

  if Col = 0 then
  begin

    if DBAppSettings.FixColStatVis then
    begin
      result := 18;
      exit;
    end;

  end else
  begin

    k := m_fixed_col;

    for i := low(m_BinColumnSet) to high(m_BinColumnSet) do
    begin
      if (AppArray[i] <> -1) and (m_BinColumnSet[AppArray[i]].Visible) then
      begin
        if Col = k then
        begin
          result := m_BinColumnSet[AppArray[i]].Width;
          break;
        end;

        Inc(k)
      end;
    end;
  end;

end;

Function TFBinRep.GetColWidth(Col : Integer): Integer;
var i, k : integer;
begin
  result := -1;

  if (Col >= 0) and (Col <=8) then
  begin
    if Assigned(TBinPanel(TBinTabSheet(FBin.GetActiveView).m_BinPanel)) and (TBinPanel(TBinTabSheet(FBin.GetActiveView).m_BinPanel).GetFiltParms <> nil) and
      (TBinPanel(TBinTabSheet(FBin.GetActiveView).m_BinPanel).GetFiltParms.P_GroupedByCode <> '') then
    begin
      result := -1;
      exit;
    end
    else
    begin

      if (Col=0) and (DBAppSettings.FixColCompVis) then
      begin
        result := 54;
        exit;
      end;

      if (Col=1) and (DBAppSettings.FixColLowDVis) then
      begin
        result := 18;
        exit;
      end;

      if (Col=2) and (DBAppSettings.FixColHigDVis) then
      begin
        result := 18;
        exit;
      end;

      if (Col=3) and (DBAppSettings.FixColOvlpVis) then
      begin
        result := 18;
        exit;
      end;

      if (Col=4) and (DBAppSettings.FixColMatDVis) then
      begin
        result := 18;
        exit;
      end;

      if (Col=5) and (DBAppSettings.FixColDelDVis) then
      begin
        result := 18;
        exit;
      end;

      if (Col=6) and (DBAppSettings.FixColDatesVis) then
      begin
        result := 18;
        exit;
      end;

      if (Col=7) and (DBAppSettings.FixColStatVis) then
      begin
        result := 18;
        exit;
      end;

      if (Col=8) and (DBAppSettings.FixColJobMsgVis) then
      begin
        result := 18;
        exit;
      end;

    end;
  end else
  begin

    k := 9;

    for i := low(m_BinColumnSet) to high(m_BinColumnSet) do
    begin
      if (AppArray[i] <> -1) and (m_BinColumnSet[AppArray[i]].Visible) then
      begin
        if Col = k then
        begin
          result := m_BinColumnSet[AppArray[i]].Width;
          break;
        end;

        Inc(k)
      end;
    end;

  end;

end;

function TFBinRep.FindPos(pos: integer): integer;
var  k: integer;
begin
  Result := -1;
  for k := low(m_BinColumnSet) to high(m_BinColumnSet) do
    if m_BinColumnSet[k].Pos = pos then
    begin
      Result := k;
      exit
    end;
end;

procedure TFBinRep.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeandNil(FBinRep);
end;

procedure TFBinRep.FormDestroy(Sender: TObject);
begin
  m_TbCfg := nil;

  FreeAndNil(m_ColumnHeaderList);
end;

procedure TFBinRep.FormShow(Sender: TObject);
begin
  XLS1.Visible := not ExcelInstalled;
  ExporttoExcel1.Visible := ExcelInstalled;
end;

procedure TFBinRep.UpdateArray;
var
  col, corrPos, corrCol: integer;
begin
   corrPos := 0;
   col := 0;
   while true do
   begin
     while true do
     begin
       corrCol := FindPos(corrPos);
       if corrCol = -1 then exit;
       if m_BinColumnSet[corrCol].Visible then break;
       Inc(corrPos);
       if corrPos > High(m_BinColumnSet) then exit;
     end;
     m_BinColumnSet[col].RealPos := corrCol;
     Inc(col);
     Inc(corrPos)
   end;

   Dec(col);

end;

procedure TFBinRep.XLS1Click(Sender: TObject);
var saveDialog : TSaveDialog;
var ASheet1: TdxSpreadSheet;
begin
  saveDialog := TSaveDialog.Create(self);
  saveDialog.Title := _('Export as') + ':';
  saveDialog.InitialDir := GetCurrentDir;

  saveDialog.Filter := 'Microsoft Excel 97-2003 Worksheet|*.xls';
  saveDialog.DefaultExt := 'xls';

  if saveDialog.Execute then
  begin

   if TMenuItem(sender).Name = 'Full3' then
      ExportGridToXLSX(saveDialog.FileName, DXGrid)
    else
      ExportGridDataToXLSX(saveDialog.FileName, DXGrid);

    if m_TbCfg = nil then
    begin
      ASheet1 := TdxSpreadSheet.Create(Self);
      ASheet1.LoadFromFile(saveDialog.FileName);
      ASheet1.ActiveSheetAsTable.InsertRows(0,1);
      with ASheet1.ActiveSheetAsTable.CreateCell(0,0) do
      begin
        Style.WordWrap := false;
        Style.Font.Size := 12;
        Style.Font.Style := [fsBold];
        SetText(m_Caption);
      end;
      ASheet1.SaveToFile(saveDialog.FileName);
      ASheet1.Free;
    end;

    Showmessage('Done');
  end;

  saveDialog.Free;

end;

procedure TFBinRep.XLS2Click(Sender: TObject);
begin
  dxComponentPrinter1Link1.ExportToPDF;
  Showmessage('Done');
end;

procedure TFBinRep.XML1Click(Sender: TObject);
var saveDialog : TSaveDialog;
var ASheet1: TdxSpreadSheet;
begin
  saveDialog := TSaveDialog.Create(self);
  saveDialog.Title := _('Export as') + ':';
  saveDialog.InitialDir := GetCurrentDir;

  saveDialog.Filter := 'Extensible Markup Language|*.xml';
  saveDialog.DefaultExt := 'xml';

  if saveDialog.Execute then
  begin
    ExportGridToXML(saveDialog.FileName, DXGrid);
  {ASheet1 := TdxSpreadSheet.Create(Self);
  ASheet1.LoadFromFile(saveDialog.FileName);
  ASheet1.ActiveSheetAsTable.DeleteColumns(0,3);
  ASheet1.SaveToFile(saveDialog.FileName);
  ASheet1.Free;   }
    Showmessage('Done');
  end;

  saveDialog.Free;

end;

procedure TFBinRep.FillArrayBinColByCod(var BinColArray : array of TBinColCurrent);
var
  I, K, TabCode : Integer;

  function FindPos(s : CBinColId): integer;
  var
    J: Integer;
  begin
    Result := 0;
    for J := Low(m_TbCfg.BinArray) to High(m_TbCfg.BinArray) do
      if s = m_TbCfg.BinArray[J].Field then
      begin
        Result := J;
        Exit
      end
  end;

begin

  for I := Low(BinColArray) to High(BinColArray) do
  begin
    K := FindPos(m_TbCfg.BinArray[I].Field);
    BinColArray[K].Field := m_TbCfg.BinArray[I].Field;
    BinColArray[K].Title := m_TbCfg.BinArray[I].Title;
    BinColArray[K].Pos := m_TbCfg.BinArray[I].Pos;
    BinColArray[K].Width := m_TbCfg.BinArray[I].Width;
    BinColArray[K].Visible := m_TbCfg.BinArray[I].Visible;
    BinColArray[K].Order := m_TbCfg.BinArray[I].Order;
    BinColArray[K].PropCode := m_TbCfg.BinArray[I].PropCode;
    BinColArray[K].DescendingSort := m_TbCfg.BinArray[I].DescendingSort;
    BinColArray[K].NumColSorted := m_TbCfg.BinArray[I].NumColSorted;
  end;
end;

procedure TFBinRep.OrganizePosOerForTabs;
var
  I,J,K,PropPosition, Index : Integer;
  Low, Last, current, HighBinProp : Integer;
  Found : boolean;
  Temparray: array [0..high(DBAppGlobals.ShowBinPropArry)] of TBinColCurrent;
  PropListString : TStringList;
begin
  PropListString := TStringList.Create;
  Current := 0;
  Index := 0;

  PropPosition := GetNumberFields;
  Last := -1;

  // Find how many propertyes defined for the planner and keep each defined property in temporary //
  //**********************************************************************************************//
  K := 0;
  for I := 0 to high(DBAppGlobals.ShowBinPropArry) do
  begin
    //if (DBAppGlobals.ShowBinPropArry[I] = nil) then break;

    if I = 0 then
    begin
      if (DBAppGlobals.ShowBinPropArry[I] = nil) then
      begin
        for J := PropPosition to High(m_BinColumnSet) do
        begin
          m_BinColumnSet[J].PropCode := '';
        end;
        break;
      end
      else
        PropListString.Add(GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]));
    end
    else if (DBAppGlobals.ShowBinPropArry[I] = nil) then
    begin

      for J := PropPosition to High(m_BinColumnSet) do
      begin
        if PropListString.IndexOf(m_BinColumnSet[J].PropCode) = -1 then
           m_BinColumnSet[J].PropCode := '';
      end;
      break;

    end;
    ///////////////////////////

    Index := Index + 1;
    for J := PropPosition to High(m_BinColumnSet) do
    begin
      if m_BinColumnSet[J].PropCode <>
          GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]) then continue;
      Temparray[K].Title    := m_BinColumnSet[J].Title;
      Temparray[K].Pos      := m_BinColumnSet[J].Pos;
      Temparray[K].Width    := m_BinColumnSet[J].Width;
      Temparray[K].Visible  := m_BinColumnSet[J].Visible;
      Temparray[K].Order    := m_BinColumnSet[J].Order;
      Temparray[K].PropCode := m_BinColumnSet[J].PropCode;
      K := K + 1;
      break;
    end;
  end;

  // Loop on all defined properties, and, enter them to bin. If defined before, restore values //
  //*******************************************************************************************//
  PropPosition := GetNumberFields;
  for I := 0 to high(DBAppGlobals.ShowBinPropArry) do
  begin
    if (DBAppGlobals.ShowBinPropArry[I] = nil) then break;

    K := I + PropPosition;
    Found := False;

    // Search if the property was kept before //
    for J := 0 to high(DBAppGlobals.ShowBinPropArry) do
    begin
      if Temparray[J].PropCode <> GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]) then continue;
      Found := True;
      break;
    end;

    m_BinColumnSet[K].PropCode := GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]);

    if found then
    begin
      m_BinColumnSet[K].Title    := Temparray[J].Title;
      m_BinColumnSet[K].Pos      := Temparray[J].Pos;
      m_BinColumnSet[K].Width    := Temparray[J].Width;
      m_BinColumnSet[K].Visible  := Temparray[J].Visible;
      m_BinColumnSet[K].Order    := Temparray[J].Order;
    end
    else
    begin
      m_BinColumnSet[K].Title    := '';
      m_BinColumnSet[K].Pos      := 998;
      m_BinColumnSet[K].Width    := 80;
      m_BinColumnSet[K].Visible  := true;
      m_BinColumnSet[K].Order    := 998;
    end;
  end;

  HighBinProp := Index;
  PropPosition := PropPosition + HighBinProp;


  // Compress the order values from 0 to ...///
  for I := 0 to PropPosition - 1 do
  begin
    Low := 999;
    for J := 0 to PropPosition - 1 do
    begin
      if (m_BinColumnSet[J].order > last) and (m_BinColumnSet[J].order < Low) then
      begin
        Current := J;
        Low := m_BinColumnSet[J].order;
       end;
    end;
    Last := m_BinColumnSet[Current].order;
    if last = 998 then last := 997;
    m_BinColumnSet[Current].order := I;
  end;

  // Complete the order for the remaining no-handled properties //
  for I := PropPosition to High(m_BinColumnSet) do
  begin
    m_BinColumnSet[I].order := I;
  end;

  Last := -1;
  Current := 0;

 // Compress the position values from 0 to ...///
  for I := 0 to PropPosition - 1 do
  begin
    Low := 999;
    for J := 0 to PropPosition - 1 do
    begin
      if (m_BinColumnSet[J].Pos > last) and (m_BinColumnSet[J].Pos < Low) then
      begin
        Current := J;
        Low := m_BinColumnSet[J].Pos;
      end;
    end;
    Last := m_BinColumnSet[Current].Pos;
    if last = 998 then last := 997;
    m_BinColumnSet[Current].Pos := I;
  end;

 // Complete the position for the remaining no-handled properties //
  for I := PropPosition to High(m_BinColumnSet) do
  begin
    m_BinColumnSet[I].Pos := I;
  end;

  PropPosition := GetNumberFields;
  // just be sure that all rest of properties are signed as false
  for I := PropPosition to high(m_BinColumnSet) do
  begin
    if not Assigned(DBAppGlobals.ShowBinPropArry[I-PropPosition]) then
    begin
      m_BinColumnSet[I].Visible := false;
      if m_isMatbingrid then
        m_BinColumnSet[I].Title := TitleMatTemp[I]
      else
        m_BinColumnSet[I].Title := Titletemp[I];
    end;
  end;

 // tbs.GetBinGrid.SortRowBin;
//  FBin.SetSortIndex(tbs.m_BinPanel, 0);
  PropListString.Free;
end;

procedure TFBinRep.Print1Click(Sender: TObject);
begin
  dxComponentPrinter1Link1.Preview;
  //dxComponentPrinter1Link1.Print(true);
end;

function TFBinRep.GetColumnTitleFromColID(BinColId : CBinColId) : String;
var i : Integer;
begin
  result := '';

  for i := High(m_BinColumnSet) downto 0 do
  begin
    if m_BinColumnSet[i].Field = BinColId then
    begin
      result := m_BinColumnSet[i].Title;
      break
    end;
  end;
end;

function TFBinRep.CBinColIdToString(value: CBinColId): string;
begin
    result := GetEnumName(typeInfo(CBinColId ), Ord(value));
end;

function TFBinRep.StringToCBinColId(const value: string): CBinColId;
begin
  result := CBinColId(GetEnumValue(Typeinfo(CBinColId), value));
end;

Function TFBinRep.GetSelectedSchedID(Row : Integer): TSchedID;
begin
  result := -1;
  try
    result := DXGridView.DataController.Values[Row, 0]
  except
  end;
end;

procedure TFBinRep.GridViewCustomDrawCellMat(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
  APainter: TcxPainterAccess;
  AEditViewInfo: TcxCustomTextEditViewInfo;
  AImageRect: TRect;
  id : TSchedId;
  ARow : Integer;
  ForcesInfo: TSQForcesInfo;
  PlanInfo: TSQPlanInfo;
  errSet: SetOfErrors;
  DummyList : TList;
  ExtLinkPrt : Pointer;
  FieldVal : Variant;
  dataType : CBinColValType;
  str : String;
  IsGroup, GetMsg, SentMsg : boolean;
  TmpBrushCol, TmpPenCol, TmpFontCol: TColor;
  compRes,
  compFore,
  compBack: TCompatVal;
begin
   if copy(TcxGridColumn(AViewInfo.Item).HeaderHint,0,3) <> 'fix' then exit;
   if AViewInfo.GridRecord.Index = -1 then exit;

  DummyList := nil;

  //ARow := AViewInfo.GridRecord.Index;
  id := AViewInfo.GridRecord.Values[0];//GetSelectedSchedID(ARow);//TSchedId(TBinPanel(TBinTabSheet(DXGrid.Parent).m_BinPanel).m_ObjList.GetLink(ARow));
  ExtLinkPrt := p_sc.GetExtLinkPtr(ID);


  APainter := TcxPainterAccess(TcxViewInfoAcess(AViewInfo).GetPainterClass.Create(ACanvas, AViewInfo));
  try
    AEditViewInfo := TcxCustomTextEditViewInfo(AViewInfo.EditViewInfo);
    AEditViewInfo.TextRect.Left := AEditViewInfo.TextRect.Left + AViewInfo.ContentBounds.Height + 1;
    APainter.DrawContent;
    APainter.DrawBorders;

    AImageRect := AViewInfo.ContentBounds;
    AImageRect.Left := AImageRect.Left + 8;
    AImageRect.Width := AImageRect.Height;

    if TcxGridColumn(AViewInfo.Item).HeaderHint = 'fix0' then //status
    begin
      if (p_sc.GetExtLinkPtr_Material(id) <> nil) then
         cxImageList1.Draw(ACanvas.Canvas, AImageRect, 29);
    end;
  finally
    APainter.Free;
  end;
  ADone := True;

end;

procedure TFBinRep.miColumnfilterClick(Sender: TObject);
begin
  DXGridView.FilterRow.Visible := not DXGridView.FilterRow.Visible;
end;

procedure TFBinRep.miFiltersClick(Sender: TObject);
begin
  if DXGridView.FilterBox.Visible in [fvNever, fvNonEmpty] then
    DXGridView.FilterBox.Visible := fvAlways
  else
    DXGridView.FilterBox.Visible := fvNever
end;

procedure TFBinRep.GridViewCustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
  APainter: TcxPainterAccess;
  AEditViewInfo: TcxCustomTextEditViewInfo;
  AImageRect: TRect;
  id : TSchedId;
  ARow : Integer;
  ForcesInfo: TSQForcesInfo;
  PlanInfo: TSQPlanInfo;
  errSet: SetOfErrors;
  DummyList : TList;
  ExtLinkPrt : Pointer;
  FieldVal : Variant;
  dataType : CBinColValType;
  str : String;
  IsGroup, GetMsg, SentMsg : boolean;
  TmpBrushCol, TmpPenCol, TmpFontCol: TColor;
  compRes,
  compFore,
  compBack: TCompatVal;
begin
  {if (AViewInfo.Item <> cxGrid1DBTableView1Company) or
    not (AViewInfo.EditViewInfo is TcxCustomTextEditViewInfo) then
      Exit;       }

  if copy(TcxGridColumn(AViewInfo.Item).HeaderHint,0,3) <> 'fix' then exit;
  if AViewInfo.GridRecord.Index = -1 then exit;

  DummyList := nil;

  if AViewInfo.GridRecord is TcxGridGroupRow then exit;

  //ARow := AViewInfo.GridRecord.Index;
  id := AViewInfo.GridRecord.Values[0];//GetSelectedSchedID(ARow);//TSchedId(TBinPanel(TBinTabSheet(DXGrid.Parent).m_BinPanel).m_ObjList.GetLink(ARow));//GetSelectedSchedID(ARow);//
  try
    ExtLinkPrt := p_sc.GetExtLinkPtr(id);//TSchedId(TBinPanel(TBinTabSheet(DXGrid.Parent).m_BinPanel).m_ObjList.GetLink(ARow)));
  except
    exit;
  end;


  APainter := TcxPainterAccess(TcxViewInfoAcess(AViewInfo).GetPainterClass.Create(ACanvas, AViewInfo));
  try
    AEditViewInfo := TcxCustomTextEditViewInfo(AViewInfo.EditViewInfo);
    AEditViewInfo.TextRect.Left := AEditViewInfo.TextRect.Left + AViewInfo.ContentBounds.Height + 1;
    APainter.DrawContent;
    APainter.DrawBorders;

    AImageRect := AViewInfo.ContentBounds;
    AImageRect.Left := AImageRect.Left + 8;
    AImageRect.Width := AImageRect.Height;

    if TcxGridColumn(AViewInfo.Item).HeaderHint = 'fix0' then //Compatibility
    begin
      {TmpBrushCol := tmpGrid.Canvas.Brush.Color;
      TmpPenCol   := tmpGrid.Canvas.Pen.Color;
      TmpFontCol  := tmpGrid.Canvas.Font.Color;  }

      if not p_sc.HasFlags(id, [CSF_compInBin]) then
        str := ''
      else
      begin
        compRes := p_sc.GetCompatWithRes(id);
        if compRes = CompValNotCached then
          str := ''// '(nc)'   message is not clear avi 20.06.23
        else if compRes = CompValNotValid then
          str := ''// '(nv)'
        else if compRes = CompValNotDef then
          str := '' //'(nd)'
        else
          str := IntToStr(compRes);

        if (p_pl.GetCompatModeInBinVisRes <> nil) then
        begin
          if TBinPanel(TBinTabSheet(FBin.GetActiveView).m_BinPanel).GetFiltParms.P_SeqFilter then
             GetResCompatColor(compRes, ACanvas.Brush, ACanvas.Pen, ACanvas.Font);
          if not TBinPanel(TBinTabSheet(FBin.GetActiveView).m_BinPanel).GetFiltParms.P_SeqFilter then
          begin
            if DBAppSettings.ShowCompatibleInExistingBINS = ShowC_No then
              str := ''
            else
              GetResCompatColor(compRes, ACanvas.Brush, ACanvas.Pen, ACanvas.Font)
          end;
        end
        else
          GetResCompatColor(compRes, ACanvas.Brush, ACanvas.Pen, ACanvas.Font)
      end;

     // ACanvas.Brush := tmpGrid.Canvas.Brush;
    //  RectWidth := trunc((rect.Right - rect.Left)/3);
    //        Rect.Right := Rect.Left + RectWidth;
      ACanvas.DrawTexT(str, AViewInfo.ContentBounds, taLeftJustify, vaCenter, false, false);
      //ACanvas.Draw(AViewInfo.ContentBounds.Left, AViewInfo.ContentBounds.Top, AViewInfo.ContentBounds);

      if (p_pl.GetCompatModeInPlanId = CSchedIDnull) then
      begin
        if Assigned(ExtLinkPrt) then
        begin
          p_sc.GetPlanInfo(id, PlanInfo);
          if (PlanInfo.supMinOvlp > 0) and (PlanInfo.supMinReal > 0) and (PlanInfo.supMinBase > 0) then
            str := '+ ' + FloatToStr(PlanInfo.supMinOvlp + PlanInfo.supMinReal + PlanInfo.supMinBase)
          else if (PlanInfo.supMinOvlp > 0) and (PlanInfo.supMinReal > 0) then
            str := '+ ' + FloatToStr(PlanInfo.supMinOvlp + PlanInfo.supMinReal)
          else if (PlanInfo.supMinOvlp > 0) then
            str := '+ ' + FloatToStr(PlanInfo.supMinOvlp)
        end;

        ACanvas.DrawTexT(str, AViewInfo.ContentBounds, taLeftJustify, vaCenter, false, false);
        // DXGridView.DataController.Values[ARow, i] := str;
      end
      else
      begin
        if Assigned(ExtLinkPrt) then
        begin
          try   //  avi to avoid access violation while Group form open (while remove job from group). 10/12/07
          p_sc.GetCompatWithOcc(id, compFore, compBack);
          except
          end;
          if compFore > 0 then
          begin
            str := str + intToStr(compFore);
            GetOccCompatColor(compFore, false, ACanvas.Brush, ACanvas.Pen, ACanvas.Font)
          end else
            str := ' --';

          ACanvas.DrawTexT(str, AViewInfo.ContentBounds, taLeftJustify, vaCenter, false, false);
           //DXGridView.DataController.Values[ARow, i] := str;

          if compBack > 0 then
          begin
            str := intToStr(compBack);
            GetOccCompatColor(compBack, false, ACanvas.Brush, ACanvas.Pen, ACanvas.Font)
          end else
            str := ' --';
          ACanvas.DrawTexT(str, AViewInfo.ContentBounds, taLeftJustify, vaCenter, false, false);
          // DXGridView.DataController.Values[ARow, i] := str;
        end
        else
        begin
          ACanvas.DrawTexT(str, AViewInfo.ContentBounds, taLeftJustify, vaCenter, false, false);
          // DXGridView.DataController.Values[ARow, i] := str;
        end;
      end;
      {tmpGrid.Canvas.Brush.Color := TmpBrushCol;
      tmpGrid.Canvas.Pen.Color   := TmpPenCol;
      tmpGrid.Canvas.Font.Color  := TmpFontCol; }
    end else
    if TcxGridColumn(AViewInfo.Item).HeaderHint = 'fix1' then //Earliest Start forced
    begin
      p_sc.GetForcesInfo(id, ForcesInfo);
      if ForcesInfo.FrcLowestDate > CSF_No then
        cxImageList1.Draw(ACanvas.Canvas, AImageRect, 15);
    end else
    if TcxGridColumn(AViewInfo.Item).HeaderHint = 'fix2' then //Latest End  forced
    begin
      p_sc.GetForcesInfo(id, ForcesInfo);
      if ForcesInfo.FrcHighestDate > CSF_No then
        cxImageList1.Draw(ACanvas.Canvas, AImageRect, 15);
    end else
    if TcxGridColumn(AViewInfo.Item).HeaderHint = 'fix3' then //Materials
    begin
      errSet := [];
      p_sc.CheckErrors(id, CSEG_All, errSet, DummyList);

      if (CSE_Materials in errSet) then
      begin
          cxImageList1.Draw(ACanvas.Canvas, AImageRect, 16);
      end else
      if (CSE_AddRes in errSet) then
      begin
          cxImageList1.Draw(ACanvas.Canvas, AImageRect, 17);
      end else
      if (CSE_BothOvlp in errSet) then
      begin
          cxImageList1.Draw(ACanvas.Canvas, AImageRect, 18);
      end else
      begin
        if (CSE_LeftOvlp in errSet) then
        begin
            cxImageList1.Draw(ACanvas.Canvas, AImageRect, 19);
        end else
        if (CSE_RightOvlp in errSet) then
        begin
            cxImageList1.Draw(ACanvas.Canvas, AImageRect, 20);
        end else
        begin
           // p_sc.GetForcesInfo(id, ForcesInfo);
           // if ForcesInfo.FrcOverlap > CSF_No then
            {if DBAppSettings.ForceOverlap > FOL_No then
            begin
              Img := graphics.TBitmap.Create;
              FMQMPlan.ImageList1.GetBitmap(23, Img);
            end; }
        end
      end;
    end else
    if TcxGridColumn(AViewInfo.Item).HeaderHint = 'fix4' then //Material Arrival forced
    begin
      p_sc.GetForcesInfo(id, ForcesInfo);
      if ForcesInfo.FrcMatDate > CSF_No then
        cxImageList1.Draw(ACanvas.Canvas, AImageRect, 15);

    end else
    if TcxGridColumn(AViewInfo.Item).HeaderHint = 'fix5' then //Delivery date forced
    begin
      p_sc.GetForcesInfo(id, ForcesInfo);
      case ForcesInfo.FrcDelDate of
        CSF_Yes,
        CSF_Forceable: cxImageList1.Draw(ACanvas.Canvas, AImageRect, 15);

        CSF_Yes2,
        CSF_Forceable2: cxImageList1.Draw(ACanvas.Canvas, AImageRect, 21);
      end;
    end else
    if TcxGridColumn(AViewInfo.Item).HeaderHint = 'fix6' then //Dates warnings
    begin
      if Assigned(ExtLinkPrt) then
      begin
        errSet := [];
        p_sc.CheckErrors(id, CSEG_All, errSet, DummyList);

        if (CSE_DelDate in errSet) then
        begin
          cxImageList1.Draw(ACanvas.Canvas, AImageRect, 22);
        end else
        if (CSE_HighEndDate in errSet) then
        begin
          cxImageList1.Draw(ACanvas.Canvas, AImageRect, 23);
        end else
        if (CSE_LowStrDate in errSet) then
        begin
          cxImageList1.Draw(ACanvas.Canvas, AImageRect, 24);
        end;
      end;
    end else
    if TcxGridColumn(AViewInfo.Item).HeaderHint = 'fix7' then //Status
    begin
      if p_sc.GetFldValue(id, CSC_Closed, FieldVal, dataType) and FieldVal then
      begin
          cxImageList1.Draw(ACanvas.Canvas, AImageRect, 25)
      end else
      begin
        if Assigned(ExtLinkPrt) then
        begin
          case p_sc.IsProgressed(id) of
            prg_Starting: cxImageList1.Draw(ACanvas.Canvas, AImageRect, 26);
            prg_General:  cxImageList1.Draw(ACanvas.Canvas, AImageRect, 27);
            prg_Final, prg_FinalSplit : cxImageList1.Draw(ACanvas.Canvas, AImageRect, 28);
          else
            if (p_sc.GetSchedType(id) = '2') then
                cxImageList1.Draw(ACanvas.Canvas, AImageRect, 29)
            else
            begin
                if (p_sc.GetSchedType(id) = '3') then
                  str := '1'
                else if (p_sc.GetSchedType(id) = '4') then
                  str := '2'
                else if (p_sc.GetSchedType(id) = '5') then
                  str := '3'
                else if (p_sc.GetSchedType(id) = '6') then
                  str := '4'
                else if (p_sc.GetSchedType(id) = '7') then
                  str := '5';

                if str = '' then
                  cxImageList1.Draw(ACanvas.Canvas, AImageRect, 30) //ASK AVI
                else
                  cxImageList1.Draw(ACanvas.Canvas, AImageRect, 31);
            end;
          end;
        end else
        begin
          if (p_sc.GetSchedType(id) = '3') then
            str := '1'
          else if (p_sc.GetSchedType(id) = '4') then
            str := '2'
          else if (p_sc.GetSchedType(id) = '5') then
            str := '3'
          else if (p_sc.GetSchedType(id) = '6') then
            str := '4'
          else if (p_sc.GetSchedType(id) = '7') then
            str := '5';

          if str <> '' then
            cxImageList1.Draw(ACanvas.Canvas, AImageRect, 32);
        end;
      end;
    end else
    if TcxGridColumn(AViewInfo.Item).HeaderHint = 'fix8' then // JobMessges
    begin
     p_sc.GetStatuseMsgForJob(id, IsGroup, GetMsg, SentMsg);
      begin
        if GetMsg and not SentMsg then
        begin
          cxImageList1.Draw(ACanvas.Canvas, AImageRect, 14)
        end
        else if SentMsg and not GetMsg then
        begin
          cxImageList1.Draw(ACanvas.Canvas, AImageRect, 33)
        end
        else if GetMsg and SentMsg then
        begin
          cxImageList1.Draw(ACanvas.Canvas, AImageRect, 34)
        end
      end;
    end;

  finally
    APainter.Free;
  end;
  ADone := True;
end;

procedure TFBinRep.CreateRows;
var i,  ACol,CfgCol, ARow, LinkCount : Integer;
val : variant;
int : Integer;
Date : TDateTime;
float : Double;
begin

  DXGridView.DataController.BeginUpdate;
  DXGridView.DataController.RecordCount := 0;
  LinkCount := FBin.GetActiveView.m_BinPanel.m_ObjList.GetLinkCount;
  DXGridView.DataController.RecordCount := LinkCount;
  ACol := 0;

  for i := 0 to DXGridView.ColumnCount - 1 do
  begin
    //if DXGridView.Columns[i].HeaderHint = 'TSchedID' then

    if copy(DXGridView.Columns[i].HeaderHint, 0, 3) <> 'fix' then
    begin

     CfgCol  := m_BinColumnSet[ACol].RealPos;

      for ARow := 0 to LinkCount - 1 do
      begin
        //val := p_sc.GetFldDescr(GetSelectedSchedID(ARow), m_BinColumnSet[CfgCol].Field, false);
        val := p_sc.GetFldDescr(TSchedID(TBinPanel(TBinTabSheet(FBin.GetActiveView).m_BinPanel).m_ObjList.GetLink(ARow)), m_BinColumnSet[CfgCol].Field, false);


        if DXGridView.Columns[i].HeaderHint = 'CSC_SeqCB' then
          DXGridView.DataController.SetValue(ARow, i, False)
        else if DXGridView.Columns[i].HeaderHint = 'TSchedID' then
          DXGridView.DataController.Values[ARow, i] := TBinPanel(TBinTabSheet(FBin.GetActiveView).m_BinPanel).m_ObjList.GetLink(ARow)
        else
        begin
          if DXGridView.Columns[i].DataBinding.ValueTypeClass = TcxIntegerValueType then
          begin
            if TryStrToInt(val,int) then
              val := Int
            else
              val := 0;
          end;

          if DXGridView.Columns[i].DataBinding.ValueTypeClass = TcxDateTimeValueType then
          begin
            if TryStrToDateTime(val, date) then
              val := Date
            else
              val := 0;
          end;

           if DXGridView.Columns[i].DataBinding.ValueTypeClass = TcxFloatValueType then
          begin
            if TryStrToFloat(val, float) then
              val := float
            else
              val := 0;
          end;


          try
            DXGridView.DataController.Values[ARow, i] := val;
          except
            showmessage(DXGridView.Columns[i].HeaderHint + ' ' +inttostr(arow) + ' ' +val);
          end;

        end;
      end;
      if DXGridView.Columns[i].HeaderHint <> 'TSchedID' then
        Inc(ACol);
    end;
  end;
  DXGridView.DataController.EndUpdate;
end;

procedure TFBinRep.CSV1Click(Sender: TObject);
var saveDialog : TSaveDialog;
var ASheet1: TdxSpreadSheet;
begin
  saveDialog := TSaveDialog.Create(self);
  saveDialog.Title := _('Export as') + ':';
  saveDialog.InitialDir := GetCurrentDir;

  saveDialog.Filter := 'Comma-separated values|*.csv';
  saveDialog.DefaultExt := 'csv';

  if saveDialog.Execute then
  begin
    ExportGridToCSV(saveDialog.FileName, DXGrid);
  {ASheet1 := TdxSpreadSheet.Create(Self);
  ASheet1.LoadFromFile(saveDialog.FileName);
  ASheet1.ActiveSheetAsTable.DeleteColumns(0,3);
  ASheet1.SaveToFile(saveDialog.FileName);
  ASheet1.Free;   }
    Showmessage('Done');
  end;

  saveDialog.Free;

end;

procedure TFBinRep.CustomizeMenu(Sender: TObject);

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
  if DXGridView.FilterBox.Visible in [fvNever, fvNonEmpty] then
    mi.ImageIndex := 4
  else
     mi.ImageIndex := 44;
  mi.ImageIndex := TcxGridStdHeaderMenu(Sender).Images.AddImage(cxImageList1, mi.ImageIndex) - 1;
  mi.OnClick := mifiltersClick;
  TcxGridStdHeaderMenu(Sender).Items.Add(mi);

  mi := TMenuItem.Create(nil);
  mi.Caption := 'Column filter';
  if DXGridView.FilterRow.Visible then
    mi.ImageIndex := 45
  else
     mi.ImageIndex := 6;
  mi.ImageIndex := TcxGridStdHeaderMenu(Sender).Images.AddImage(cxImageList1, mi.ImageIndex) - 1;
  mi.OnClick := miColumnfilterClick;
  TcxGridStdHeaderMenu(Sender).Items.Add(mi);

  if DXGridView.Controller.FocusedColumn = nil then exit;


  if DXGridView.Controller.FocusedColumn.DataBinding.ValueTypeClass = TcxDateTimeValueType then
  begin
    if m_filterColumn <> nil then
     // cxImageList1.GetImage(-1, DXGridView.columns[m_filterColumn.Index].HeaderGlyph);
     DXGridView.columns[m_filterColumn.Index].HeaderImageIndex := -1;

    mi := TMenuItem.Create(nil);
    mi.Caption := 'Range filter(This column)';
    if DXGridView.FilterRow.Visible then
      mi.ImageIndex := 45
    else
       mi.ImageIndex := 6;
    //mi.ImageIndex := TcxGridStdHeaderMenu(Sender).Images.AddImage(cxImageList1, mi.ImageIndex) - 1;
    mi.OnClick := CreateRangeData;
    TcxGridStdHeaderMenu(Sender).Items.Add(mi);
  end
end;

procedure TFBinRep.cxCheckComboBox1FocusChanged(Sender: TObject);
begin
    if not cxCheckComboBox1.IsFocused then
    begin
      cxCheckComboBox1.SendToBack;
      cxCheckComboBox1.SendToBack;
      cxCheckComboBox1.SendToBack;
    end;
end;

procedure TFBinRep.cxCheckComboBox1PropertiesEditValueChanged(Sender: TObject);
var
  AProperties: TdxRangeControlDateTimeHeaderClientProperties;
  AScales: TdxRangeControlDateTimeScales;
  I: Integer;
begin
  AProperties := (dxRangeControl1.ClientProperties as TdxRangeControlDateTimeHeaderClientProperties);
  AScales := AProperties.Scales;
  for I := 0 to cxCheckComboBox1.Properties.Items.Count - 1 do
    AScales.GetScale(TdxRangeControlDateTimeScaleUnit(I + Ord(rcduDay))).Visible := cxCheckComboBox1.States[I] = cbsChecked;

end;

procedure TFBinRep.cxGridPopupMenu1Popup(ASenderMenu: TComponent;
  AHitTest: TcxCustomGridHitTest; X, Y: Integer; var AllowPopup: Boolean);
begin
  if ASenderMenu is TcxGridStdHeaderMenu then
    TcxGridStdHeaderMenu(ASenderMenu).OnPopup := CustomizeMenu;
end;

procedure TFBinRep.DXGridViewCellDblClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);
  var i  : Integer;
  tbs : TBinTabSheet;
  Id, selectedID : TschedId;
begin

  selectedID := GetSelectedSchedID(DXgridView.DataController.FocusedRecordIndex);

  tbs := TBinTabSheet(FBin.GetActiveView);
  if Assigned(tbs) then
  begin
    for i := 0 to tbs.m_BinPanel.m_objList.GetLinkCount - 1 do
    begin
      Id := tbs.m_BinPanel.m_objList.GetLink(i);

      if (id = selectedID) then
      begin
        Fbin.FocusBinOnJobID(id, False);
        break;
      end;
    end;
  end;
end;

procedure TFBinRep.DXGridViewMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ht: TcxCustomGridHitTest;
  AGridSite: TcxGridSite;
  AGridView: TcxGridTableView;
  id : TSchedID;
  ca :TcxGridGroupRow;
begin
  DXGrid.SetFocus;

  AGridSite := TcxGridSite(Sender);
  AGridView := TcxGridTableView(AGridSite.GridView);
  ht := AGridView.GetHitTest(X,Y);
  m_selectedColumn := nil;
 { if m_isMatbingrid then  //WARP
       DXGrid.PopupMenu := FBin.MatPopup
    else
      DXGrid.PopupMenu := FBin.PopUpBin; }

  if ht is TcxGridColumnHeaderHitTest then
   m_selectedColumn := TcxGridColumnHeaderHitTest(ht).column
  else if ht is TcxGridRecordCellHitTest then
    m_selectedColumn := TcxGridColumn(TcxGridRecordCellHitTest(ht).Item);

  DXGridView.Controller.FocusedColumn := m_selectedColumn;

  if Button = mbRight then
  begin

    if ht.HitTestCode in [htColumnHeader, htGroupbybox] then
    begin
      if m_selectedColumn <> nil then
      //  pmNewBin.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);

    end else
    begin
       DXGrid.PopupMenu := nil;
     { if AGridView.ViewData.Rows[0] is TcxGridGroupRow then
        if TcxGridGroupRow(AGridView.ViewData.Rows[0]).Level >= 0 then
          DXGrid.PopupMenu := nil;     }
       // ca := TcxGridRecordCellHitTest(ht).Item as TcxGridGroupRow;
        //if ht.HitTestCode = 106 then exit;
    end;
    //  ShowMessage(TcxGridColumnHeaderHitTest(ht).Column.Caption);
  end else
  if Button = mbLeft then
  begin
   { if (ht is TcxGridRecordCellHitTest) then
    begin
      AGridView.OptionsSelection.CellMultiSelect := False;
      AGridView.OptionsSelection.MultiSelect := True;
    end;}
   // else
   //   AView.OptionsSelection.CellMultiSelect := True;

  end;

end;

procedure TFBinRep.dxRangeControl1DrawContent(Sender: TdxCustomRangeControl;
  ACanvas: TcxCanvas; AViewInfo: TdxRangeControlCustomClientViewInfo;
  var AHandled: Boolean);
var
  AContentElements: TList<TdxRangeControlDateTimeHeaderClientContentElementViewInfo>;
  AElement: TdxRangeControlDateTimeHeaderClientContentElementViewInfo;
  I: Integer;
  AValue: Integer;
  ARect: TRect;
begin
  AContentElements := (AViewInfo.Content as TdxRangeControlDateTimeHeaderClientContentViewInfo).Elements;
  dxGPPaintCanvas.BeginPaint(ACanvas.Handle, AViewInfo.Bounds);
  dxGPPaintCanvas.SmoothingMode := smAntiAlias;
  try
    for I := 0 to AContentElements.Count - 1 do
    begin
      AElement := AContentElements[I];
      dxGPPaintCanvas.SaveClipRegion;
      try
        dxGPPaintCanvas.SetClipRect(AElement.Bounds, gmIntersect);
        if FDateTimeHeaderClientData1.TryGetValue(AElement.MinDate, AValue) then
        begin
          ARect := AElement.Bounds;
          ARect.Right := cxRectCenter(ARect).X - 2;
          ARect.Left := ARect.Right - 15;
          Inc(ARect.Bottom);
          ARect.Top := ARect.Bottom - AValue * ARect.Height div 100;
          dxGPPaintCanvas.Rectangle(ARect, $FF6AA4D9, $646AA4D9);
        end;

      finally
        dxGPPaintCanvas.RestoreClipRegion;
      end;
    end;
  finally
    dxGPPaintCanvas.EndPaint;
  end;

end;

procedure TFBinRep.dxRangeControl1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if button = TMouseButton.mbRight then
    dxCalloutPopup1.Popup(Groupbox1);

  cxCheckComboBox1.SendToBack;
end;

procedure TFBinRep.ExporttoExcel1Click(Sender: TObject);
var saveDialog : TSaveDialog;
var ASheet1: TdxSpreadSheet;
begin
  saveDialog := TSaveDialog.Create(self);
  saveDialog.Title := _('Export as') + ':';
  saveDialog.InitialDir := GetCurrentDir;

  saveDialog.Filter := 'Microsoft Excel Worksheet|*.xlsx|Microsoft Excel 97-2003 Worksheet|*.xls';
  saveDialog.DefaultExt := 'xlsx';

  if saveDialog.Execute then
  begin
    if TMenuItem(sender).Name = 'Full1' then
      ExportGridToXLSX(saveDialog.FileName, DXGrid)
    else
      ExportGridDataToXLSX(saveDialog.FileName, DXGrid);

    if m_TbCfg = nil  then
    begin
      ASheet1 := TdxSpreadSheet.Create(Self);
      ASheet1.LoadFromFile(saveDialog.FileName);
      ASheet1.ActiveSheetAsTable.InsertRows(0,1);
      with ASheet1.ActiveSheetAsTable.CreateCell(0,0) do
      begin
        Style.WordWrap := false;
        Style.Font.Size := 12;
        Style.Font.Style := [fsBold];
        SetText(m_Caption);
      end;
      ASheet1.SaveToFile(saveDialog.FileName);
      ASheet1.Free;
    end;

    Showmessage('Done');
  end;

  saveDialog.Free;

end;

Procedure TFBinRep.RepCreateRows(Data: Variant);
var Row, Col, SheetColCount,i : Integer;
ToDelete : boolean;
begin
  Row := VarArrayHighBound(Data, 1);
  DXGridView.DataController.RecordCount := Row;

  with DXGridView do
  begin
    BeginUpdate;
    try
      for col := 0 to ColumnCount -1 do
        for i := 3 to Row -1 do
        begin
           DataController.Values[i-3,col] := Data[i,Col+1];
        end;
    finally
    end;
    EndUpdate;
  end;

  //delete blank rows
  ToDelete := true;
  row := DXGridView.DataController.RecordCount -1;
  with DXGridView do
    for i := Row downto 0 do
    begin
      if i > DataController.RecordCount -1 then
        break;

      ToDelete := true;
      for col := 0 to ColumnCount -1 do
      begin
        if DataController.Values[i,col] <> '' then
          if not varisnull(DataController.Values[i,col]) then
            ToDelete := false;
      end;

      if ToDelete then
        DataController.DeleteRecord(i);
    end;

  DXGridView.ApplyBestFit;
end;

Procedure TFBinRep.RepCreateColumns(Data: Variant);
var Col, SheetColCount,i : Integer;
begin
  Col := VarArrayHighBound(Data, 2);

  with DXGridView do
  begin
    BeginUpdate;
    try
      for i := 1 to Col-1 do
      begin
        with CreateColumn do
        begin
          Name := 'GridView0Col'+inttoStr(i);
          Caption := Data[2,i];
        end;
      end;
    finally
    end;
    EndUpdate;
  end;

end;

procedure TFBinRep.CreateColumns;
var i : Integer;
  ColID : CBinColId;
  Title : String;
  pId : TPropID;
begin
  m_StaticColCount := 0;
  with DXGridView do
  begin
    BeginUpdate;
    try
      m_TSchedIDCol := CreateColumn;

      with m_TSchedIDCol do  //add hidded TSchedID column
       begin
         Name := 'GridView' + intToStr(m_TabCode)+'Colid';
         HeaderHint := 'TSchedID';
         Options.Filtering := False;
       end;

      for i := 0 to m_ColumnHeaderList.Count - 1  do
      begin
        if copy(m_ColumnHeaderList.Names[i], 0, 3) = 'fix' then
          continue;

         with CreateColumn do
         begin
          Name := 'GridView' + intToStr(m_TabCode)+'Col'+inttoStr(i);

            HeaderHint := m_ColumnHeaderList.Names[i];
            Width := StrToInt(m_ColumnHeaderList.ValueFromIndex[i]);

            {if copy(m_ColumnHeaderList.Names[i], 0, 3) = 'fix' then
            begin
              Inc(m_StaticColCount);
              var s := m_ColumnHeaderList.Names[i];
              Options.HorzSizing := False;
              Options.Filtering := False;

              if s = 'fix0' then
              begin
                if m_isMatbingrid then
                begin
                  cxImageList1.GetImage(0, HeaderGlyph);
                  AlternateCaption := _('Status');
                end
                else
                  Caption := _('Comp');
              end
              else if s = 'fix1' then
              begin
                  cxImageList1.GetImage(11, HeaderGlyph);
                  AlternateCaption := _('Earliest Start forced');
              end else if s = 'fix2' then
              begin
                  cxImageList1.GetImage(12, HeaderGlyph);
                  AlternateCaption := _('Latest End  forced');
              end else if s = 'fix3' then
              begin
                  cxImageList1.GetImage(2, HeaderGlyph);
                  AlternateCaption := _('Materials');
              end else if s = 'fix4' then
              begin
                  cxImageList1.GetImage(2, HeaderGlyph);
                  AlternateCaption := _('Material Arrival forced');
              end else if s = 'fix5' then
              begin
                  cxImageList1.GetImage(13, HeaderGlyph);
                  AlternateCaption := _('Delivery date forced');
              end else if s = 'fix6' then
              begin
                  cxImageList1.GetImage(1, HeaderGlyph);
                  AlternateCaption := _('Dates warnings');
              end else if s = 'fix7' then
              begin
                  cxImageList1.GetImage(0, HeaderGlyph);
                  AlternateCaption := _('Status');
              end else if s = 'fix8' then
              begin
                  cxImageList1.GetImage(14, HeaderGlyph);
                  AlternateCaption := _('Job Messges');
              end;

              if m_isMatbingrid then
                OnCustomDrawCell := GridViewCustomDrawCellMat
              else
                OnCustomDrawCell := GridViewCustomDrawCell;

              Options.Filtering := False;
              Options.Sorting := False;
              Options.Moving := False;
              Width := 27;

            end else }
            if copy(m_ColumnHeaderList.Names[i], 0, 3) = 'CSC' then  //normal columns
            begin
              ColID := StringToCBinColId(m_ColumnHeaderList.Names[i]);
              Title := GetColumnTitleFromColID(ColID);
              Caption := _(Title);

              if p_sc.GetFldDataType(ColID) in [CBT_string, CBT_dur] then
                DataBinding.ValueTypeClass := TcxStringValueType
              else if p_sc.GetFldDataType(ColID) = CBT_date then
                DataBinding.ValueTypeClass := TcxDateTimeValueType
              else if p_sc.GetFldDataType(ColID) = CBT_integer then
                DataBinding.ValueTypeClass := TcxIntegerValueType
              else if p_sc.GetFldDataType(ColID) = CBT_float then
                DataBinding.ValueTypeClass := TcxFloatValueType
              else if p_sc.GetFldDataType(ColID) = CBT_bool then
                DataBinding.ValueTypeClass := TcxBooleanValueType;

              if DataBinding.ValueTypeClass = TcxDateTimeValueType then
                OnGetDisplayText := GetText;


            end else //Properties
            begin
              //OnCustomDrawCell := GridViewCustomDrawCellProp;
              pID := GetIdFromCode(m_ColumnHeaderList.Names[i]);
              Title := GetPropDescr(pId);
              Caption := _(Title);

              if pId <> nil then
              begin
                if IsPropAlpha(pId) then
                  DataBinding.ValueTypeClass := TcxStringValueType
                else
                  DataBinding.ValueTypeClass := TcxFloatValueType;
              end;

            //  AlternateCaption := Title;
            end;

            if m_ColumnHeaderList.Names[i] = 'CSC_SeqCB' then
            begin
              PropertiesClassName := 'TcxCheckBoxProperties';
             // Options.Editing := True;
             // Properties.OnEditValueChanged := SchedSequencePropertiesChange;
            end else
            if m_ColumnHeaderList.Names[i] = 'CSC_SharedComment' then
            begin
              PropertiesClassName := 'TcxBlobEditProperties';
             // Options.Editing := True;
            //  Properties.OnValidate := CommentPropertiesChange;
            end else
              Options.Editing := False;

            //DataBinding.ValueTypeClass := TcxStringValueType;

         end
      end;

    finally
      EndUpdate;
    end;
  end;
end;

Procedure TFBinRep.RetakeColumnSet;
begin

  SetLength(m_BinColumnSet,High(m_TbCfg.BinArray)+1);

  FillArrayBinColByCod(m_BinColumnSet);
  UpdateArray;
end;

Function TFBinRep.GetGridData: TStringList;
var i, ACol, x, num : Integer;
  s : String;
  pId: TPropId;
begin
  m_ColumnHeaderList := TStringList.Create;
  result := TStringList.Create;
  x := m_fixed_col;

  SetLength(AppArray, High(m_BinColumnSet)+1);

  for i := low(m_BinColumnSet) to high(m_BinColumnSet) do
      AppArray[i] := FindPos(i);

  for i := 0 to High(m_BinColumnSet) + m_fixed_col do
  begin
    case i of
      0,1,2,3,4,5,6,7,8: s := 'fix'+ intToStr(i);
      else
      begin
        Acol := m_BinColumnSet[x - m_fixed_col].RealPos;
        num := -1;
        case m_BinColumnSet[Acol].Field of
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

          if not assigned(pId) then
          begin
            Exit;
          end;
          s := GetPropCodeFromID(pID);
        end else
          s := CBinColIdToString(m_BinColumnSet[Acol].Field);
        Inc(x);
      end;
    end;

    if m_isMatbingrid then
    begin
      var width := GetColWidthMat(i);
      if width > 0 then
        Result.AddPair(s, intToStr(width));
    end else
    begin
      var width := GetColWidth(i);
      if width > 0 then
        Result.AddPair(s, intToStr(width));
    end;
  end;
end;

Procedure TFBinRep.CreateRangeData(Sender: TObject);
var MinDate,MaxDate,ADateTime : TDateTime;
  i : Integer;
begin
  if FDateTimeHeaderClientData1 <> nil then
    FreeAndNil(FDateTimeHeaderClientData1);


  if m_filterColumn = DXGridView.Controller.FocusedColumn then
  begin
    dxRangeControl1.Visible := False;
    m_filterColumn := nil;
    Exit;
  end;

  m_FilterColumn := DXGridView.Controller.FocusedColumn;

  dxRangeControl1.Visible := True;

  FDateTimeHeaderClientData1 := TDictionary<TDateTime, Integer>.Create;

  minDate := 0;
  MaxDate := 0;

  for I := 0 to DXGridView.DataController.RecordCount-1 do
  begin
    if (MaxDate = 0) or (MaxDate < DXGridView.DataController.Values[i, m_FilterColumn.Index]) then
      MaxDate := DXGridView.DataController.Values[i, m_FilterColumn.Index];

    if (minDate = 0) or (minDate > DXGridView.DataController.Values[i, m_FilterColumn.Index]) then
      minDate := DXGridView.DataController.Values[i, m_FilterColumn.Index];
  end;

  dxRangeControl1.ClientProperties.MinValue := MinDate;
  dxRangeControl1.ClientProperties.MaxValue := MaxDate;

  ADateTime := dxRangeControl1.ClientProperties.MinValue;
  while ADateTime <= dxRangeControl1.ClientProperties.MaxValue do
  begin
    FDateTimeHeaderClientData1.Add(ADateTime, RandomRange(10, 90));
    ADateTime := IncDay(ADateTime);
  end;

  DXGridView.Controller.FocusedColumn.HeaderImageIndex := 4;

  dxRangeControl1.SelectedRangeMinValue := minDate;
  dxRangeControl1.SelectedRangeMaxValue := MaxDate;
end;

procedure TFBinRep.dxRangeControl1SelectedRangeChanged(Sender: TObject);
var
  ADataController: TcxGridDataController;
  AItemList: TcxFilterCriteriaItemList;
  a, b : TcxCustomDataField;
begin
  ADataController := DXGridView.DataController;
  ADataController.Filter.BeginUpdate;
  try
    //ADataController.Filter.Root.Clear;
    if DXGridView.DataController.Filter.FilterText.IndexOf(m_FilterColumn.Caption) > -1 then
      ADataController.Filter.RemoveItemByItemLink(m_FilterColumn);

    ADataController.Filter.Root.AddItem(m_FilterColumn, foGreaterEqual, dxRangeControl1.SelectedRangeMinValue, dxRangeControl1.SelectedRangeMinValue);
    ADataController.Filter.Root.AddItem(m_FilterColumn, foLessEqual, dxRangeControl1.SelectedRangeMaxValue, dxRangeControl1.SelectedRangeMaxValue);

    {AItemList := ADataController.Filter.Root.AddItemList(fboOr);
    AItemList.AddItem(cxDBTableView1Name, foLike, 'A%', 'A%');
    AItemList.AddItem(cxDBTableView1Name, foLike, 'Z%', 'Z%');   }
    ADataController.Filter.Active := True;
  finally
    ADataController.Filter.EndUpdate;
  end;
end;

constructor TFBinRep.CreateBinReport(AOWner: TComponent; cfg : TBinTabCfg);
begin
  inherited create(AOwner);

  m_TbCfg := cfg;
  m_TabCode := cfg.code;
  m_isMatbingrid := TBinTabSheet(FBin.GEtActiveView).m_BinPanel.GetFiltParms.P_MaterialSchedFilter;

  RetakeColumnSet;
  m_ColumnHeaderList := GetGridData;
  CreateColumns;
  CreateRows;

  DXGrid.ShowHint := False;
  DXGridView.Columns[0].Visible := False;
end;

constructor TFBinRep.CreateReport(AOWner: TComponent; Data: Variant);
begin
  inherited create(AOwner);

  m_Caption := Data[1,1];
  RepCreateColumns(data);
  RepCreateRows(data);
  caption := caption + m_caption;

end;

end.
