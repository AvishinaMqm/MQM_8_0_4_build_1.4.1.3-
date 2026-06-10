unit FMAvailablityReport;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxSkinsCore, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle,
   dxSkinTheBezier,cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxEdit, cxNavigator, dxDateRanges, dxScrollbarAnnotations, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxClasses, cxGridLevel, cxGrid,
  UMIssuedArt, UMArticles, UMBalance, UMSchedContFunc, FMBin, UMBinPanel,
  System.ImageList, Vcl.ImgList, cxImageList, Vcl.Menus, cxGridExportLink,
  cxCalc, cxTimeEdit, dxUIAClasses;

type
  TAvaRep = record
    MatType : String;
    MatCode : String;
    NetCode : String;
    MatDesc : String;
    Date : TDateTime;
    Quantity : Double;
    Balance : String;
    Details : String;
  end;
  RAvaRep = ^TAvaRep;

  TFAvailablityReport = class(TForm)
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    cxGrid1TableView1: TcxGridTableView;
    colType: TcxGridColumn;
    colDesc: TcxGridColumn;
    colDate: TcxGridColumn;
    colQty: TcxGridColumn;
    colRunTotal: TcxGridColumn;
    colDetails: TcxGridColumn;
    pmNewBin: TPopupMenu;
    miFilters: TMenuItem;
    miGroupinheader: TMenuItem;
    miColumnfilter: TMenuItem;
    miSearchbox: TMenuItem;
    ExporttoExcel1: TMenuItem;
    cxStyleRepository1: TcxStyleRepository;
    cxStyle1: TcxStyle;
    colCode: TcxGridColumn;
    colNetGrp: TcxGridColumn;
    ExpandAll1: TMenuItem;
    N1: TMenuItem;
    CollapsAll1: TMenuItem;
    N2: TMenuItem;
    emplate1: TMenuItem;
    miSave: TMenuItem;
    miLoad: TMenuItem;
    colMonth: TcxGridColumn;
    colWeek: TcxGridColumn;
    colTime: TcxGridColumn;
    cxImageList1: TcxImageList;
    procedure FormCreate(Sender: TObject);
    procedure AddArticleToForm(Article: TMQMArticle ; NetCode : TMQMNetGroup; IssuedArt: PTIssuedArt);
    procedure ListArticles(LstArticles: TMQMIssuedArtList);
    procedure GetDataForGrid(NetGroup : TMQMNetGroup; var RowList: Tlist;ArticleCode : string);
    procedure FormShow(Sender: TObject);
    procedure miFiltersClick(Sender: TObject);
    procedure miGroupinheaderClick(Sender: TObject);
    procedure miColumnfilterClick(Sender: TObject);
    procedure miSearchboxClick(Sender: TObject);
    procedure ExporttoExcel1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cxGrid1TableView1DataControllerSummaryAfterSummary(
      ASender: TcxDataSummary);
    procedure cxGrid1TableView1CustomDrawGroupSummaryCell(Sender: TObject;
      ACanvas: TcxCanvas; ARow: TcxGridGroupRow; AColumn: TcxGridColumn;
      ASummaryItem: TcxDataSummaryItem;
      AViewInfo: TcxCustomGridViewCellViewInfo; var ADone: Boolean);
    procedure colTypeGetDisplayText(
      Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
      var AText: string);
    procedure cxGrid1TableView1GroupRowExpanded(Sender: TcxGridTableView;
      AGroup: TcxGridGroupRow);
    procedure ExpandAll1Click(Sender: TObject);
    procedure CollapsAll1Click(Sender: TObject);
    procedure miSaveClick(Sender: TObject);
    procedure miLoadClick(Sender: TObject);
    procedure cxGrid1TableView1CustomDrawGroupCell(
      Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridTableCellViewInfo; var ADone: Boolean);
    procedure colCodeCustomDrawGroupSummaryCell(
      Sender: TObject; ACanvas: TcxCanvas; ARow: TcxGridGroupRow;
      AColumn: TcxGridColumn; ASummaryItem: TcxDataSummaryItem;
      AViewInfo: TcxCustomGridViewCellViewInfo; var ADone: Boolean);
    procedure colCodeGetDataText(Sender: TcxCustomGridTableItem;
      ARecordIndex: Integer; var AText: string);
    procedure colDescGetDisplayText(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; var AText: string);
    procedure colDescCustomDrawGroupSummaryCell(Sender: TObject;
      ACanvas: TcxCanvas; ARow: TcxGridGroupRow; AColumn: TcxGridColumn;
      ASummaryItem: TcxDataSummaryItem;
      AViewInfo: TcxCustomGridViewCellViewInfo; var ADone: Boolean);
    procedure colCodeGetDisplayText(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; var AText: string);
    procedure cxGrid1TableView1GroupRowCollapsed(Sender: TcxGridTableView;
      AGroup: TcxGridGroupRow);
  private
     ProdSL : TStringList;
     m_AvaRep : TList;
     FInitialized : Boolean;
     Save_Cursor : TCursor;
     Function ResizeForm: Integer;
  public

  end;

var
  FAvailablityReport: TFAvailablityReport;

implementation

   uses Math, gnugettext, dxSpreadSheet, cxFindPanel, ComObj, StrUtils, DateUtils, UMSchedCont, UMObjCont, UMSchedOnPlan;
{$R *.dfm}

{ TFAvailablityReport }

procedure TFAvailablityReport.GetDataForGrid(NetGroup : TMQMNetGroup; var RowList: Tlist;ArticleCode : string);
var
  i: integer;
  recArtBalance : PTArtBalance;
  ArtBalList: TMQMArtBalanceList;
  NotUsed: boolean;
  RowData: PTDetailRows;
begin
  recArtBalance := nil;
  try
    ArtBalList := NetGroup.m_BalanceList;
    // fp - may, 08 2006
    ArtBalList.SortBalanceList;
    NetGroup.UpdateBalanceTotals('', CSchedIDnull);

    if Assigned(ArtBalList) and (ArtBalList.p_count > 0) then
    begin
      for i := 0 to ArtBalList.p_count -1 do
      begin
        new(RowData);
        Rowdata.FromHeader := false;
        recArtBalance := PTArtBalance(ArtBalList.p_Item[i]);
        RowData.DateTime        := recArtbalance.DueDate;
        RowData.Quantity    := RoundTo(recArtbalance.RealQty,-2);
   //    RowData.Quantity    := RoundTo(recArtbalance.Quantity,-2);

        if (recArtbalance.BalanceType <> bt_Entry) and
           (recArtbalance.BalanceType <> bt_EntryExp) then
          RowData.Quantity  := (-1) * RowData.Quantity;

        RowData.TotalBal    := RoundTo(recArtbalance.TotalBal, -2);

        if recArtbalance.JobID <> CSchedIDnull then
          Rowdata.description := p_sc.GetObjInfo(recArtbalance.JobID, NotUsed)
        else
        begin
          Rowdata.description := recArtbalance.Description;
          Rowdata.FromHeader  := true;
         // Rowdata.Artbalance  := recArtbalance;
          Rowdata.ProductCode := ArticleCode;
        end;
        if recArtbalance.BalanceType = bt_Expiration then
          Rowdata.description := _('Expire of:') + ' ' + Rowdata.description;

        Rowdata.NetGroupPtr    := NetGroup;
        Rowdata.Artbalance  := recArtbalance;
        RowList.Add(RowData);
      end;//for

    end;//if
  except
    on e:Exception do MessageDlg('FMRequirements  GetDataForGrid'+#13'Message: '+e.Message,mtError, [mbOK],0);
  end;
end;

//----------------------------------------------------------------------------//

procedure TFAvailablityReport.AddArticleToForm(Article: TMQMArticle ; NetCode : TMQMNetGroup; IssuedArt: PTIssuedArt);
var
  NetGroup : TMQMNetGroup;
  i, y: Integer;
  ArtDesc: String;
  RowList: Tlist;
  TotalBal,
  Shortage, TolleranceQuantity: double;
  quantSched, IniQty : variant;
  //DataType: CBinColValType;
  RAR : RAvaRep;
  RowData: PTDetailRows;
begin
  try
    for i := 0 to Article.p_NetGroupList.p_count -1 do
    begin
      //new (HeaderRow);
      RowList := Tlist.Create();
      NetGroup := TMQMNetGroup(Article.p_NetGroupList.p_Item[i]);
      if (assigned(NetCode)) and (NetCode.m_Code <> NetGroup.m_Code) then
         Continue;
        GetDataForGrid(NetGroup, RowList, Article.p_ArtCode);

        for y := 0 to RowList.Count-1 do
        begin
          RowData := RowList.Items[y];

          New(RAR);
          RAR.MatType := Article.p_ArtType.p_ArtTypeCode;
          RAR.MatCode := Article.p_ArtCode;
          RAR.NetCode := NetGroup.p_Code;
          RAR.MatDesc := Article.p_Description;
          RAR.Date := RowData.DateTime;
          RAR.Quantity := RowData.Quantity;
          RAR.Balance := FloatToStr(RowData.TotalBal);
          RAR.Details := RowData.description;

          m_AvaRep.Add(RAR);
        end;

        ProdSL.Add(Article.p_ArtType.p_ArtTypeCode);
    end;
    except
      on e:Exception do MessageDlg('FMRequirements  AddArticleToForm'+#13'Message: '+e.Message,mtError, [mbOK],0);
   end;
end;

//----------------------------------------------------------------------------//

procedure TFAvailablityReport.ListArticles(LstArticles: TMQMIssuedArtList);
var
  i,j: Integer;
  ArtType : TMQMArticleType;
  Article : TMQMArticle;
  IssuedArt: PTIssuedArt;
begin
  try
   if Assigned(LstArticles) then
    begin
      for i := 0 to LstArticles.p_Count -1 do
      begin
        IssuedArt := LstArticles.p_Item[i];
        Article := IssuedArt.Article;

        if ProdSL.IndexOf(Article.p_ArtType.p_ArtTypeCode) = -1 then
          AddArticleToForm( Article, IssuedArt.NetGroup, IssuedArt);
      end;
    end else
    begin
      for i := 0 to p_ArtTypeList.p_count -1 do
      begin
        ArtType := TMQMArticleType(p_ArtTypeList.p_Item[i]);
        if ArtType.p_ArtTypeCode = '' then
        begin
          for j:= 1 to ArtType.p_ArticleList.Count -1 do
          begin
            Article := TMQMArticle(ArtType.p_ArticleList.Items[i]);
            if ProdSL.IndexOf(Article.p_ArtType.p_ArtTypeCode) = -1 then
              AddArticleToForm( Article, nil, nil);
          end;//for j
        end;//if
      end;//for
    end;//else

    except
      on e:Exception do MessageDlg('FMRequirements  ListArticles'+#13'Message: '+e.Message,mtError, [mbOK],0);
   end;
end;

//----------------------------------------------------------------------------//

procedure TFAvailablityReport.miColumnfilterClick(Sender: TObject);
begin
    if miColumnfilter.Checked then
    begin
      cxGrid1TableView1.FilterRow.Visible := False;
      miColumnfilter.Checked := False;
    end else
    begin
      cxGrid1TableView1.FilterRow.Visible := True;
      miColumnfilter.Checked := True;
    end;
end;

//----------------------------------------------------------------------------//

procedure TFAvailablityReport.miFiltersClick(Sender: TObject);
begin
    if miFilters.Checked then
    begin
      cxGrid1TableView1.FilterBox.Visible := fvNever;
      miFilters.Checked := False;
    end else
    begin
      cxGrid1TableView1.FilterBox.Visible := fvAlways;
      miFilters.Checked := True;
    end;
end;

//----------------------------------------------------------------------------//

procedure TFAvailablityReport.miGroupinheaderClick(Sender: TObject);
var i : Integer;
begin
    if miGroupinheader.Checked then
    begin
      cxGrid1TableView1.OptionsView.GroupByBox := False;
      miGroupinheader.Checked := False;
      for i:= 0 to cxGrid1TableView1.ColumnCount - 1 do
      begin
        cxGrid1TableView1.Columns[i].GroupIndex := -1;
        cxGrid1TableView1.Columns[i].IsChildInMergedGroup := False;
        cxGrid1TableView1.Columns[i].Visible := True;
      end;
    end else
    begin
      cxGrid1TableView1.OptionsView.GroupByBox := True;
      miGroupinheader.Checked := True;
    end;
end;

//----------------------------------------------------------------------------//

procedure TFAvailablityReport.miLoadClick(Sender: TObject);
var OpenDialog : TOpenDialog;
begin
  OpenDialog := TOpenDialog.Create(self);
  OpenDialog.Title := _('Load Template') + ':';
  OpenDialog.InitialDir := GetCurrentDir;

  OpenDialog.Filter := 'Configuration settings|*.ini';
  OpenDialog.DefaultExt := 'ini';


  if OpenDialog.Execute then
  begin
    cxGrid1TableView1.RestoreFromIniFile(OpenDialog.FileName,True, True, [gsoUseFilter, gsoUseSummary]);
    miGroupinheader.Checked := cxGrid1TableView1.OptionsView.GroupByBox;
    Showmessage('Done');
  end;

  OpenDialog.Free;

end;

//----------------------------------------------------------------------------//

procedure TFAvailablityReport.miSaveClick(Sender: TObject);
var saveDialog : TSaveDialog;
begin
  saveDialog := TSaveDialog.Create(self);
  saveDialog.Title := _('Save Template as') + ':';
  saveDialog.InitialDir := GetCurrentDir;

  saveDialog.Filter := 'Configuration settings|*.ini';
  saveDialog.DefaultExt := 'ini';

  if saveDialog.Execute then
  begin
    cxGrid1TableView1.StoreToIniFile(saveDialog.FileName,True, [gsoUseFilter, gsoUseSummary]);
    Showmessage('Done');
  end;

  saveDialog.Free;

end;

//----------------------------------------------------------------------------//

procedure TFAvailablityReport.miSearchboxClick(Sender: TObject);
begin
    if miSearchbox.Checked then
    begin
      cxGrid1TableView1.FindPanel.DisplayMode := fpdmNever;
      miSearchbox.Checked := False;
    end else
    begin
      cxGrid1TableView1.FindPanel.DisplayMode := fpdmAlways;
      miSearchbox.Checked := True;
    end;
end;

//----------------------------------------------------------------------------//

procedure TFAvailablityReport.CollapsAll1Click(Sender: TObject);
begin
  cxGrid1TableView1.ViewData.Collapse(True);
end;

procedure TFAvailablityReport.colTypeGetDisplayText(
  Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AText: string);
begin
  //if ARecord is TcxGridGroupRow then
  //  if _(AText) = 'Material code:' then
      //TcxGridGroupRow(ARecord). := '';
    //AText := 'Quantity='+AText;
end;

//----------------------------------------------------------------------------//

procedure TFAvailablityReport.colCodeCustomDrawGroupSummaryCell(
  Sender: TObject; ACanvas: TcxCanvas; ARow: TcxGridGroupRow;
  AColumn: TcxGridColumn; ASummaryItem: TcxDataSummaryItem;
  AViewInfo: TcxCustomGridViewCellViewInfo; var ADone: Boolean);
begin
  //asd
end;

procedure TFAvailablityReport.colCodeGetDataText(Sender: TcxCustomGridTableItem;
  ARecordIndex: Integer; var AText: string);
var str : String;
begin
   if colCode.GroupIndex > -1 then
   begin
      if cxGrid1TableView1.DataController.Values[ARecordIndex, colDesc.Index] <> null then
      begin
      {  if not colDesc.IsChildInMergedGroup then
        begin
          colDesc.IsChildInMergedGroup := True;
          colDesc.GroupIndex := colCode.GroupIndex+1;
        end;  }
       // str := AText + '"'+cxGrid1TableView1.DataController.Values[ARecordIndex, colDesc.Index]+'"';
       // AText := str;
      end;
   end else
   begin
   // colDesc.IsChildInMergedGroup := False;
   // colDesc.GroupIndex := -1;
   end;
end;

procedure TFAvailablityReport.colCodeGetDisplayText(
  Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AText: string);
var
  AGroupIndex: Integer;
  AList: TList;
begin
  exit;
  if ARecord is TcxGridGroupRow then
  begin
    AList := TList.Create;
    AGroupIndex := cxGrid1TableView1.DataController.Groups.DataGroupIndexByRowIndex[ARecord.Index];
    cxGrid1TableView1.DataController.Groups.LoadRecordIndexes(AList, AGroupIndex);
    AText := AText + ' ' +
      cxGrid1TableView1.DataController.DisplayTexts[Integer(AList.Items[0]), colDesc.Index] ;
      //  ', ' + cxGrid1TableView1.DataController.DisplayTexts[Integer(AList.Items[0]), XDBTV_PersFld_Birth.Index];
    AList.Free
  end
 { else
    AText := AText +
      ', ' + ARecord.DisplayTexts[colDesc.Index] ;      }
      //  ', ' + ARecord.DisplayTexts[XDBTV_PersFld_Birth.Index];
end;

procedure TFAvailablityReport.colDescCustomDrawGroupSummaryCell(Sender: TObject;
  ACanvas: TcxCanvas; ARow: TcxGridGroupRow; AColumn: TcxGridColumn;
  ASummaryItem: TcxDataSummaryItem; AViewInfo: TcxCustomGridViewCellViewInfo;
  var ADone: Boolean);
begin
  // AViewInfo.Text :=  AViewInfo.Text
end;

procedure TFAvailablityReport.colDescGetDisplayText(
  Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AText: string);
begin
 { if ARecord is TcxGridGroupRow then
    AText :=  ReplaceStr(AText,'Description :', '')  }
   //if _(AText) = 'Material code:' then
      //TcxGridGroupRow(ARecord). := '';
    //AText := '';  }
end;

//----------------------------------------------------------------------------//

procedure TFAvailablityReport.cxGrid1TableView1CustomDrawGroupCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableCellViewInfo; var ADone: Boolean);
begin
//  AViewInfo.Text := AViewInfo.Text;
  {AViewInfo.Text := StringReplace(AViewInfo.Text, '"', ' "', [rfReplaceAll, rfIgnoreCase]);
  AViewInfo.Text := StringReplace(AViewInfo.Text, '(', ' (', [rfReplaceAll,rfIgnoreCase]);     }
end;

//----------------------------------------------------------------------------//

procedure TFAvailablityReport.cxGrid1TableView1CustomDrawGroupSummaryCell(
  Sender: TObject; ACanvas: TcxCanvas; ARow: TcxGridGroupRow;
  AColumn: TcxGridColumn; ASummaryItem: TcxDataSummaryItem;
  AViewInfo: TcxCustomGridViewCellViewInfo; var ADone: Boolean);
begin
  exit;
  if (colCode.GroupIndex = -1) or (colType.GroupIndex = -1)
  or (//(colDesc.GroupIndex > -1) or
   (colDate.GroupIndex > -1)
    or (colQty.GroupIndex > -1)
     or (colRunTotal.GroupIndex > -1)
      or (colDetails.GroupIndex > -1)
       or (colNetGrp.GroupIndex > -1))
  then
  begin
    AViewInfo.Text :=  '';
    cxGrid1TableView1.DataController.Summary.DefaultGroupSummaryItems.BeginText := '';
    cxGrid1TableView1.DataController.Summary.DefaultGroupSummaryItems.EndText := '';
  end else
  begin
    // if colDesc.GroupIndex > -1 then
    //  AViewInfo.Text :=  '';
    cxGrid1TableView1.DataController.Summary.DefaultGroupSummaryItems.BeginText := ' (Future availability=';
    cxGrid1TableView1.DataController.Summary.DefaultGroupSummaryItems.EndText := ')';
  end;

end;

//----------------------------------------------------------------------------//

procedure TFAvailablityReport.cxGrid1TableView1DataControllerSummaryAfterSummary(ASender: TcxDataSummary);
  var AFirstGroupValue : Variant;
begin
   if cxGrid1TableView1.DataController.RecordCount = 0 then Exit;
   //if ASender.SummaryGroups.Count = 0 then exit;
   //AFirstGroupValue := ASender.GroupSummaryValues[0,1];
   if (colCode.GroupIndex > -1) then
   // if cxGrid1TableView1.DataController.Values[ARecordIndex, colDesc.Index] <> null then
    begin
      if not colDesc.IsChildInMergedGroup then
      begin
        colDesc.GroupIndex := colCode.GroupIndex+1;
        colDesc.IsChildInMergedGroup := True;
        colDesc.Visible := False;
      end;
     // str := AText + '"'+cxGrid1TableView1.DataController.Values[ARecordIndex, colDesc.Index]+'"';
     // AText := str;
    end else
    begin
     // colDesc.IsChildInMergedGroup := False;
      colDesc.GroupIndex := -1;
      colDesc.Visible := True;
    //  colDesc.Index := colCode.Index;
    end;

  exit;

  if FInitialized then
  begin
    AFirstGroupValue := ASender.GroupSummaryValues[0,1];
    ASender.GroupSummaryValues[1,1] := (AFirstGroupValue - ASender.GroupSummaryValues[1,1]);
    FInitialized := False;
  end;
end;

Function TFAvailablityReport.ResizeForm: Integer;
var i :Integer;
begin
   result := 0;
   for i := 0 to cxGrid1TableView1.ColumnCount -1 do
    if cxGrid1TableView1.Columns[i].GroupIndex = -1 then
      result := result + cxGrid1TableView1.Columns[i].Width;

   if result + 100 < 1200 then
     result := 1200
   else
     result := result + 100
end;


//----------------------------------------------------------------------------//

procedure TFAvailablityReport.cxGrid1TableView1GroupRowCollapsed(
  Sender: TcxGridTableView; AGroup: TcxGridGroupRow);
begin
 // TcxGridTableView(Sender).ApplyBestFit;
 // self.Width := ResizeForm;
end;

procedure TFAvailablityReport.cxGrid1TableView1GroupRowExpanded(Sender: TcxGridTableView; AGroup: TcxGridGroupRow);
var i,w :Integer;
begin
  TcxGridTableView(Sender).ApplyBestFit(colDetails);
  //self.Width := ResizeForm;
end;

//----------------------------------------------------------------------------//

procedure TFAvailablityReport.ExpandAll1Click(Sender: TObject);
begin
  cxGrid1TableView1.ViewData.Expand(True);
end;

//----------------------------------------------------------------------------//

procedure TFAvailablityReport.ExporttoExcel1Click(Sender: TObject);
var saveDialog : TSaveDialog;
var ASheet1: TdxSpreadSheet;

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

begin
  saveDialog := TSaveDialog.Create(self);
  saveDialog.Title := _('Save Availablity report as') + ':';
  saveDialog.InitialDir := GetCurrentDir;

  if ExcelInstalled then
  begin
    saveDialog.Filter := 'Microsoft Excel Worksheet|*.xlsx|Microsoft Excel 97-2003 Worksheet|*.xls';
    saveDialog.DefaultExt := 'xlsx';
  end else
  begin
    saveDialog.Filter := 'Microsoft Excel 97-2003 Worksheet|*.xls';
    saveDialog.DefaultExt := 'xls';
  end;

  if saveDialog.Execute then
  begin
    ExportGridToXLSX(saveDialog.FileName, cxGrid1);
    {ASheet1 := TdxSpreadSheet.Create(Self);
    ASheet1.LoadFromFile(saveDialog.FileName);
    ASheet1.ActiveSheetAsTable.DeleteColumns(0,3);
    ASheet1.SaveToFile(saveDialog.FileName);
    ASheet1.Free;   }
    Showmessage('Done');
  end;

  saveDialog.Free;

end;

//----------------------------------------------------------------------------//

procedure TFAvailablityReport.FormCreate(Sender: TObject);
var
  i, J : Integer;
//  id : TSchedID;
  planInfo: TSQplanInfo;
  TimingInfo: TSQtimingInfo;
  MachSetupCodeList :TMQMMacSetupList;
  MacSetupRec: TMacSetup;
  TmpMacSetup: TMQMMachineSetup;
  prodReqList : TList;
  ProdReqHdr  : TSCProdReqHdr;
  tDet : TSCProdReqDet;
  Job : TSCProdSched;
begin
  FInitialized := False;
  Save_Cursor   := Screen.Cursor;
  Screen.Cursor := crHourGlass;
 // SetSystemCursor(Screen.Cursors[crHourGlass], OCR_NORMAL);
  Application.ProcessMessages;
  ProdSL := TStringList.Create;
  m_AvaRep := TList.Create;

  prodReqList := p_sc.P_GetprodReqList;

  for I := 0 to prodReqList.Count - 1 do
  begin
    ProdReqHdr := TSCProdReqHdr(prodReqList[i]);

    for j := 0 to ProdReqHdr.m_list.Count - 1 do
    begin
      tDet := TSCProdReqDet(ProdReqHdr.m_list[j]);

      Job := TSCProdSched(tDet.m_list[0]);

      p_sc.GetPlanInfo(Job.m_id, planInfo);
      p_sc.GetTimingInfo(Job.m_id, TimingInfo);

      MacSetupRec.WrkCtrCode := TimingInfo.wkctCode;
      MacSetupRec.MachineSetupCode := TimingInfo.MachSetupCode;

      MachSetupCodeList := p_sc.GetStepIssMaterials(Job.m_id);

      if assigned(MachSetupCodeList) then
      begin
        if MachSetupCodeList.p_count > 0 then
        begin
          TmpMacSetup := MachSetupCodeList.p_Item[0];

          MacSetupRec.ResCat := TmpMacSetup.p_ResCatCode;
          MacSetupRec.ResCode := TmpMacSetup.p_ResCode;
          MacSetupRec.WrkCtrCode := TmpMacSetup.p_WrkCtrCode;

          ListArticles(TmpMacSetup.m_IssuedArtList);
        end else
        begin

        end;
      end
      else
        ListArticles(nil);
    end;
  end;

  ProdSL.Free;

end;

//----------------------------------------------------------------------------//

procedure TFAvailablityReport.FormDestroy(Sender: TObject);
var i: Integer;
begin
  for I := m_AvaRep.Count - 1 downto 0 do
    Dispose(RAvaRep(m_AvaRep[I]));
  m_AvaRep.Free;
end;

//----------------------------------------------------------------------------//

procedure TFAvailablityReport.FormShow(Sender: TObject);
var i : INteger;
  RAR: RAvaRep;
begin

  with cxGrid1 do
  begin
   LookAndFeel.Kind := lfStandard ;
   LookAndFeel.NativeStyle := False;
   LookAndFeel.SkinName := 'TheBezier';
   Font.Name := 'Montserrat';
   Font.Size := 8;
   ShowHint := False;
  end;

  for i := 0 to cxGrid1TableView1.ColumnCount -1 do
    cxGrid1TableView1.Columns[i].Caption := _(cxGrid1TableView1.Columns[i].Caption);

  cxGrid1TableView1.DataController.RecordCount := m_AvaRep.Count;

  for i := 0 to m_AvaRep.Count-1 do
  begin
     RAR := m_AvaRep[i];
     cxGrid1TableView1.DataController.Values[i,colType.Index] := RAR.MatType;
     cxGrid1TableView1.DataController.Values[i,colCode.Index] := StringReplace(RAR.MatCode, ' ', '', [rfReplaceAll]);
     cxGrid1TableView1.DataController.Values[i,colNetGrp.Index] := RAR.NetCode;
     cxGrid1TableView1.DataController.Values[i,colDesc.Index] := RAR.MatDesc;
     cxGrid1TableView1.DataController.Values[i,colDate.Index] := RAR.Date.GetDate;
     cxGrid1TableView1.DataController.Values[i,colQty.Index] := RAR.Quantity;
     cxGrid1TableView1.DataController.Values[i,colRunTotal.Index] := RAR.Balance;
     cxGrid1TableView1.DataController.Values[i,colDetails.Index] := RAR.Details;
     cxGrid1TableView1.DataController.Values[i,colWeek.Index] := WeekOfTheYear(RAR.Date);
     cxGrid1TableView1.DataController.Values[i,colMonth.Index] := MonthOf(RAR.Date);
     cxGrid1TableView1.DataController.Values[i,colTime.Index] := RAR.Date.GetTime;
  end;

  FInitialized := True;
  cxGrid1TableView1.DataController.Summary.Recalculate;

  cxGrid1TableView1.BeginUpdate;
  //cxGrid1TableView1.ApplyBestFit;
  cxGrid1TableView1.EndUpdate;

  Screen.Cursor := Save_Cursor;
 // SetSystemCursor(Screen.Cursors[crDefault], OCR_NORMAL);
  Application.ProcessMessages;
end;

end.
