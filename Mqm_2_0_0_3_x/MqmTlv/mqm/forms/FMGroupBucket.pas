unit FMGroupBucket;

interface

uses
  UReShape, cxButtons, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.CheckLst, DateUtils ,
  UMBinDefault, FMBin, UMBinGridMaterial, UMBinGrid, UMBinTbs, FMCfgBin, UMBinMatDefault, UMGLobal, DMsrvPC,
  Vcl.ComCtrls, UMReportExport, UMTblDesc, StrUtils, gnugettext, cxGraphics,
  dxUIAClasses, cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus;

type
  TFGroupBucket = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    BitBtn1: TcxButton;
    BtnCreate: TcxButton;
    Label3: TLabel;
    Label4: TLabel;
    EditBucketNumber: TEdit;
    CBBucketType: TComboBox;
    cboxColVis: TCheckListBox;
    cbStartingDate: TComboBox;
    Label1: TLabel;
    LblFromDate: TLabel;
    lbStart: TLabel;
    Label2: TLabel;
    lbEnd: TLabel;
    CBRound: TComboBox;
    Label6: TLabel;
    GroupBox1: TGroupBox;
    cbQty: TCheckBox;
    cbNumofMac: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure cboxColVisClickCheck(Sender: TObject);
    procedure BtnCreateClick(Sender: TObject);
    procedure CBBucketTypeChange(Sender: TObject);
    Procedure CalcStartandEndDate;
    procedure cbStartingDateChange(Sender: TObject);
    procedure EditBucketNumberChange(Sender: TObject);
    Constructor CreateFormAndReport(AOwner : TComponent);
  private
    LocArray : array [0..High(BinColDefault)] of TBinColCurrent;
    m_FieldsCount : integer;
    Procedure GetPrepData;

  public
    { Public declarations }
  end;

  function ExcelInstalled: boolean;

  const Col_UM = 'Production um';  //Always checked column for grouping

var
  FGroupBucket: TFGroupBucket;

  ReportType,
  SheetName,
  FileName     : String;
  ShowExcel    : Boolean;
  BucketSize,
  SumBucketsQty: Double;
  BucketNumber,
  RoundLevel   : Integer;

var StartDT : TDateTime;
    GroupBucReport: TSettings;
implementation

  uses mxNativeExcel, ComObj;

{$R *.dfm}

Procedure TFGroupBucket.GetPrepData;
var
  i:    integer;
  binGrid: TBinDrawGrid;
  BinMatGrid : TBinDrawGridMat;
begin
  StartDT := Now;
  if TBinTabSheet(fbin.GetActiveView).m_BinPanel.GetFiltParms.P_MaterialSchedFilter then
  begin
    BinMatGrid := FBin.GetActiveView.GetMatGrid;
    m_FieldsCount := GetNumberFieldsMat;

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
    m_FieldsCount := GetNumberFields;

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

  for I := low(LocArray) to (m_FieldsCount - 1) do
  begin
    cboxColVis.Items.Add(LocArray[I].Title);
    if LocArray[I].Title = Col_UM then
      cboxColVis.Checked[i] := true;

    if GroupBucReport.GroupList.IndexOf(LocArray[I].Title) > -1 then
      cboxColVis.Checked[i] := true;

  end;


  CBBucketType.ItemIndex := trunc(GroupBucReport.BucketSize);
  EditBucketNumber.Text := IntToStr(GroupBucReport.BucketNumber) ;
  cbStartingDate.ItemIndex := GroupBucReport.StartingDate;
  cbRound.Text := IntToStr(GroupBucReport.RoundLevel * -1) ;

  if GroupBucReport.BucketContent = 0 then //Qty
  begin
    cbQty.Checked := True;
    cbNumofMac.Checked := False;
  end else if GroupBucReport.BucketContent = 1 then //num of machines
  begin
    cbQty.Checked := False;
    cbNumofMac.Checked := True;
  end else if GroupBucReport.BucketContent = 2 then  //both
  begin
    cbQty.Checked := True;
    cbNumofMac.Checked := True;
  end;


  if GroupBucReport.DateFrom > 0 then
  begin
    lbStart.Caption := DateToStr(GroupBucReport.DateFrom);
    lbEnd.Caption := DateToStr(GroupBucReport.DateTo);
  end else
  begin
    lbStart.Caption := DateToStr(StartOfTheWeek(now));// First day of the week
    lbEnd.Caption := DateToStr(IncDay(StartOfTheWeek(now), StrToInt(EditBucketNumber.Text)));  //Last day of the week
  end;

end;

procedure TFGroupBucket.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

procedure TFGroupBucket.BtnCreateClick(Sender: TObject);
var i, num_CheckedItems : Integer;
var saveDialog : TSaveDialog;
var qry:       TMqmQuery;
    tbInfo: ^TTblInfo;
begin

  if (not cbQty.Checked) and not (cbNumofMac.Checked) then  //Production um always selected
  begin
    MessageDlg('You must select at least one Bucket content!', mtError, [mbOk], 0);
    Exit;
  end;

  qry := CreateQuery(Cfg_DB);
  tbInfo := @tblInfo[tbl_cfg_appIni];

  num_CheckedItems := 0;

  for i := 0 to cboxColVis.Items.Count -1 do
  begin
    if cboxColVis.Checked[i] = True then
      Inc(num_CheckedItems);
  end;

  if num_CheckedItems = 1 then  //Production um always selected
  begin
    MessageDlg('You must select at least one column for grouping!', mtError, [mbOk], 0);
    Exit;
  end;

  if not assigned(GroupBucReport.GroupList) then
    GroupBucReport.GroupList := TStringList.Create;

  GroupBucReport.GroupList.Delimiter := ',';
  GroupBucReport.GroupList.Clear;

  for i := 0 to cboxColVis.Items.Count -1 do
  begin
    if cboxColVis.Checked[i] = True then
      GroupBucReport.GroupList.Add(cboxColVis.Items[i]);
  end;

  //GrpBucReport.BucketType := CBBucketType.ItemIndex;
  GroupBucReport.bucketNumber := StrToInt(EditBucketNumber.text);
  case CBBucketType.ItemIndex of
       -1:  GroupBucReport.BucketSize := 30 ;
        0:  GroupBucReport.BucketSize := 30 ;
        1:  GroupBucReport.BucketSize := 7 ;
        2:  GroupBucReport.BucketSize := 1;
  end;


  GroupBucReport.StartingDate := cbStartingDate.ItemIndex;

  if ExcelInstalled then GroupBucReport.ReportType := 'Excel_Group_Bucket'
    else GroupBucReport.ReportType := 'Excel_Group_Bucket_for_non_excel';

  GroupBucReport.RoundLevel := (-1) * CBRound.ItemIndex;
  if GroupBucReport.RoundLevel > 0 then
    GroupBucReport.RoundLevel := 0;

  GroupBucReport.DateFrom := StartDT;
  GroupBucReport.Report_Date_From := StartDT;
  GroupBucReport.DateTo := StrToDate(lbEnd.Caption);

  if (cbQty.Checked) and not (cbNumofMac.Checked) then //Qty
    GroupBucReport.BucketContent := 0
  else if not (cbQty.Checked) and (cbNumofMac.Checked) then //num of machines
    GroupBucReport.BucketContent := 1
  else if (cbQty.Checked) and (cbNumofMac.Checked) then  //both
    GroupBucReport.BucketContent := 2;

  saveDialog := TSaveDialog.Create(self);
  saveDialog.Title := _('Save resource report as') + ':';
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

  saveDialog.FilterIndex := 1;

  if not saveDialog.Execute then
  begin
    ShowMessage(_('Saving file was cancelled'));
    exit;
  end;

  SheetName := 'MQM Group Bucket Report';

  GroupBucReport.NativeExcel      := TmxNativeExcel.Create(self);
  FileName  := saveDialog.FileName;
  GroupBucReport.SaveFileLocation := saveDialog.FileName;
  //new preview form
  {var info := GrpBucketReport(GroupBucReport);
  if info <> '' then
      showmessage(info);}
  ShowMessage(GrpBucketReport(GroupBucReport));
  GroupBucReport.NativeExcel.Free;
  //saveDialog.Free;

  qry.ExecSQL('Delete from ' + tbInfo.GetTableName +' where AI_WKST_CODE = ' + QuotedStr(IniAppGlobals.WkstCode)
    + ' and AI_IDENTIFIER = ' + IniAppGlobals.Identifier
    + ' and AI_FIELDNAME like (' + QuotedStr('GrpBucket_%') + ')');

  //buckettype
  qry.ExecSQL('Insert into ' + tbInfo.GetTableName + ' (AI_IDENTIFIER,AI_WKST_CODE,AI_FIELDNAME,AI_VALUE)'
    +' Values(' +IniAppGlobals.Identifier + ', '
    + QuotedStr(IniAppGlobals.WkstCode) + ', '
    + QuotedStr('GrpBucket_buckettype') + ', '
    + QuotedStr(intToStr(CBBucketType.ItemIndex)) + ')');

  //num buckets
  qry.ExecSQL('Insert into ' + tbInfo.GetTableName + ' (AI_IDENTIFIER,AI_WKST_CODE,AI_FIELDNAME,AI_VALUE)'
    +' Values(' +IniAppGlobals.Identifier + ', '
    + QuotedStr(IniAppGlobals.WkstCode) + ', '
    + QuotedStr('GrpBucket_numbuckets') + ', '
    + QuotedStr(IntToStr(GroupBucReport.BucketNumber)) + ')');

  //StartingDay
  qry.ExecSQL('Insert into ' + tbInfo.GetTableName + ' (AI_IDENTIFIER,AI_WKST_CODE,AI_FIELDNAME,AI_VALUE)'
    +' Values(' +IniAppGlobals.Identifier + ', '
    + QuotedStr(IniAppGlobals.WkstCode) + ', '
    + QuotedStr('GrpBucket_startingdate') + ', '
    + QuotedStr(IntToStr(GroupBucReport.StartingDate)) + ')');

  //roundlevel
  qry.ExecSQL('Insert into ' + tbInfo.GetTableName + ' (AI_IDENTIFIER,AI_WKST_CODE,AI_FIELDNAME,AI_VALUE)'
    +' Values(' +IniAppGlobals.Identifier + ', '
    + QuotedStr(IniAppGlobals.WkstCode) + ', '
    + QuotedStr('GrpBucket_roundlevel') + ', '
    + QuotedStr(IntToStr(GroupBucReport.RoundLevel)) + ')');

  //start
  qry.ExecSQL('Insert into ' + tbInfo.GetTableName + ' (AI_IDENTIFIER,AI_WKST_CODE,AI_FIELDNAME,AI_VALUE)'
    +' Values(' +IniAppGlobals.Identifier + ', '
    + QuotedStr(IniAppGlobals.WkstCode) + ', '
    + QuotedStr('GrpBucket_start') + ', '
    + QuotedStr(DateToStr(GroupBucReport.DateFrom)) + ')');

  //End
  qry.ExecSQL('Insert into ' + tbInfo.GetTableName + ' (AI_IDENTIFIER,AI_WKST_CODE,AI_FIELDNAME,AI_VALUE)'
    +' Values(' +IniAppGlobals.Identifier + ', '
    + QuotedStr(IniAppGlobals.WkstCode) + ', '
    + QuotedStr('GrpBucket_end') + ', '
    + QuotedStr(DateToStr(GroupBucReport.DateTo)) + ')');


  //Bucket content
  qry.ExecSQL('Insert into ' + tbInfo.GetTableName + ' (AI_IDENTIFIER,AI_WKST_CODE,AI_FIELDNAME,AI_VALUE)'
    +' Values(' +IniAppGlobals.Identifier + ', '
    + QuotedStr(IniAppGlobals.WkstCode) + ', '
    + QuotedStr('GrpBucket_buccontent') + ', '
    + QuotedStr(IntToStr(GroupBucReport.BucketContent)) + ')');

  //columns
  for I := 0 to GroupBucReport.GroupList.Count - 1 do
  begin
    qry.ExecSQL('Insert into ' + tbInfo.GetTableName + ' (AI_IDENTIFIER,AI_WKST_CODE,AI_FIELDNAME,AI_VALUE)'
      +' Values(' +IniAppGlobals.Identifier + ', '
      + QuotedStr(IniAppGlobals.WkstCode) + ', '
      + QuotedStr('GrpBucket_column' +IntToStr(i+1)) + ', '
      + QuotedStr(GroupBucReport.GroupList[i]) + ')');
  end;

  qry.Close;
  qry.Free;

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

Procedure TFGroupBucket.CalcStartandEndDate;
begin
  StartDT := Now;

  case cbBucketType.ItemIndex of
    0:begin //Monthly

      if cbStartingDate.ItemIndex = 2 then //Next period
        StartDT := StartOfTheMonth(IncMonth(StartDT, 1))
      else if cbStartingDate.ItemIndex = 1  then//Current date
        StartDT := Now
      else
        StartDT := StartOfTheMonth(StartDT);
    end;
    1:begin //Weekly
      if cbStartingDate.ItemIndex = 2 then //Next period
        StartDT := StartOfTheWeek(IncWeek(StartDT, 1))
      else if cbStartingDate.ItemIndex = 1  then//Current date
        StartDT := Now
      else
        StartDT := StartOfTheWeek(StartDT);

    end;
    2:begin //Daily

      if cbStartingDate.ItemIndex = 2 then //Next period
        StartDT := IncDay(StartDT, 1)

    end;
  end;

  lbStart.Caption := DateToStr(StartDT);

  if cbBucketType.ItemIndex = 2 then
    lbEnd.Caption := DateToStr(IncDay(StartDT, StrToInt(EditBucketNumber.Text)))
  else if cbBucketType.ItemIndex = 1 then
    lbEnd.Caption := DateToStr(IncWeek(StartDT, StrToInt(EditBucketNumber.Text)))
  else if cbBucketType.ItemIndex = 0 then
    lbEnd.Caption := DateToStr(IncMonth(StartDT, StrToInt(EditBucketNumber.Text)));

end;

procedure TFGroupBucket.CBBucketTypeChange(Sender: TObject);
begin

 CalcStartandEndDate;

end;

procedure TFGroupBucket.cboxColVisClickCheck(Sender: TObject);
begin
  if TCheckListBox(Sender).Items[TCheckListBox(Sender).ItemIndex] = col_UM then
    TCheckListBox(Sender).Checked[TCheckListBox(Sender).ItemIndex] := True;
end;

procedure TFGroupBucket.cbStartingDateChange(Sender: TObject);
begin
  CalcStartandEndDate;
end;

constructor TFGroupBucket.CreateFormAndReport(AOwner: TComponent);
var qry:       TMqmQuery;
    tbInfo: ^TTblInfo;
begin
  Inherited create(AOwner);

  qry := CreateQuery(Cfg_DB);
  tbInfo := @tblInfo[tbl_cfg_appIni];

  qry.Sql.Text := 'Select * from ' + tbInfo.GetTableName + ' where AI_IDENTIFIER = ' + INiAppGlobals.Identifier
    + ' and AI_WKST_CODE = ' + QuotedStr(Iniappglobals.WkstCode)
    + ' and AI_FIELDNAME like (' + QuotedStr('GrpBucket_%') + ')';

  Qry.open;

  if not assigned(GroupBucReport.GroupList) then
    GroupBucReport.GroupList := TStringList.Create;

  GroupBucReport.GroupList.Clear;
  GroupBucReport.GroupList.Delimiter := ',';


  if qry.RecordCount = 0 then
  begin
    GroupBucReport.BucketSize := 1;
    GroupBucReport.BucketNumber := 10;
    GroupBucReport.RoundLevel := -2;
    GroupBucReport.BucketContent := 0;
  end;

  while not qry.eof do
  begin

    if ContainsStr(qry.FieldByName('AI_FIELDNAME').asString, 'buckettype') then
      GroupBucReport.BucketSize := StrToInt(qry.FieldByName('AI_VALUE').asString)
    else if ContainsStr(qry.FieldByName('AI_FIELDNAME').asString, 'numbuckets') then
      GroupBucReport.BucketNumber := StrToInt(qry.FieldByName('AI_VALUE').asString)
   else if ContainsStr(qry.FieldByName('AI_FIELDNAME').asString, 'roundlevel') then
      GroupBucReport.RoundLevel := StrToInt(qry.FieldByName('AI_VALUE').asString)
    else if ContainsStr(qry.FieldByName('AI_FIELDNAME').asString, 'startingdate') then
      GroupBucReport.StartingDate := StrToInt(qry.FieldByName('AI_VALUE').asString)
    else if ContainsStr(qry.FieldByName('AI_FIELDNAME').asString, 'start') then
      GroupBucReport.DateFrom := StrToDate(qry.FieldByName('AI_VALUE').asString)
    else if ContainsStr(qry.FieldByName('AI_FIELDNAME').asString, 'end') then
      GroupBucReport.DateTo := StrToDate(qry.FieldByName('AI_VALUE').asString)
    else if ContainsStr(qry.FieldByName('AI_FIELDNAME').asString, 'column') then
      GroupBucReport.GroupList.Add(qry.FieldByName('AI_VALUE').AsString)
    else if ContainsStr(qry.FieldByName('AI_FIELDNAME').asString, 'buccontent') then
      GroupBucReport.BucketContent := StrToInt(qry.FieldByName('AI_VALUE').AsString);

    Qry.Next;
  end;

  qry.Close;
  qry.Free;

end;

procedure TFGroupBucket.EditBucketNumberChange(Sender: TObject);
begin
  CalcStartandEndDate;
end;

procedure TFGroupBucket.FormShow(Sender: TObject);
begin
  GetPrepData;
  CalcStartandEndDate;
end;

procedure TFGroupBucket.FormCreate(Sender: TObject);
begin
  ReShape(Self);
end;

end.
