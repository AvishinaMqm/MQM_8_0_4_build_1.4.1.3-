// DIRK BEGIN
unit FMExcelReport;

{ FMExcelReport prepares Excel exports for Dynamic Schedule Reports and Bin
  Extractions. The report creation itself happens in UMReportExport. }

interface

uses
  cxButtons, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, UMReportExport, ComCtrls, UReShape;

type
  TFExcelReport = class(TForm)
    Panel1: TPanel;
    PageControl1: TPageControl;
    TabSheetSettings: TTabSheet;
    LabTitle: TLabel;
    LabelSortCrit: TLabel;
    LblColumn: TLabel;
    CBBinCaption: TCheckBox;
    EditTitle: TEdit;
    CBSelection: TCheckBox;
    CBUnschedJobs: TCheckBox;
    CBDowntime: TCheckBox;
    ComBoxSortCrits: TComboBox;
    CBResources: TCheckBox;
    CBNewPagePerRes: TCheckBox;
    CBGroups: TCheckBox;
    CckBxPrintComments: TCheckBox;
    CmbBxColumn: TComboBox;
    TabSheetFixedColumn: TTabSheet;
    CBBinColumn1: TComboBox;
    CBBinColumn2: TComboBox;
    CBBinColumn3: TComboBox;
    CBBinColumn4: TComboBox;
    CBBinColumn5: TComboBox;
    CBBinColumn6: TComboBox;
    CBBinColumn7: TComboBox;
    CBBinColumn8: TComboBox;
    CBBinColumn9: TComboBox;
    CBBinColumn10: TComboBox;
    CBShowColumnsCaptions: TCheckBox;
    CBShowTotal: TCheckBox;
    Tabattributes: TTabSheet;
    ComBoAttribute: TComboBox;
    GBHeadingConcatenation: TGroupBox;
    LblHeadingSeparator: TLabel;
    CBHeadingConcatenation: TCheckBox;
    EditHeadingSeparator: TEdit;
    GBConcatenation: TGroupBox;
    LblSeparator: TLabel;
    CBContcatenation: TCheckBox;
    EditSeparator: TEdit;
    TabSheetPeriodMachine: TTabSheet;
    Label1: TLabel;
    EditPeriodMachineTitle: TEdit;
    CBoxPeriod: TComboBox;
    LabelPeriod: TLabel;
    LabelFrom: TLabel;
    CBoxFrom: TComboBox;
    Label2: TLabel;
    EditNumberOfPeriods: TEdit;
    CBShowFromTo: TCheckBox;
    LblFileNameByAutoRun: TLabel;
    EditMachinePeriodFileName: TEdit;
    EditTodayMinusDays: TEdit;
    LBLTodayMinusDays: TLabel;
    BtnClose: TcxButton;
    BtnSave: TcxButton;
    BTnClearBinColumn1: TcxButton;
    BTnClearBinColumn2: TcxButton;
    BTnClearBinColumn3: TcxButton;
    BTnClearBinColumn4: TcxButton;
    BTnClearBinColumn5: TcxButton;
    BTnClearBinColumn6: TcxButton;
    BTnClearBinColumn7: TcxButton;
    BTnClearBinColumn8: TcxButton;
    BTnClearBinColumn9: TcxButton;
    BTnClearBinColumn10: TcxButton;
    BitOk: TcxButton;
    procedure BtnSaveClick(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
    procedure ComBoxSortCritsChange(Sender: TObject);
    procedure EditTitleChange(Sender: TObject);
    procedure CBSelectionClick(Sender: TObject);
    procedure CBBinCaptionClick(Sender: TObject);
    procedure CBDowntimeClick(Sender: TObject);
    procedure CBUnschedJobsClick(Sender: TObject);
    procedure CBResourcesClick(Sender: TObject);
    procedure CBNewPagePerResClick(Sender: TObject);
    procedure CBGroupsClick(Sender: TObject);
    procedure BTnClearBinColumn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CBContcatenationClick(Sender: TObject);
    procedure EditSeparatorClick(Sender: TObject);
    procedure EditSeparatorChange(Sender: TObject);
    procedure CBShowColumnsCaptionsClick(Sender: TObject);
    procedure CBShowTotalClick(Sender: TObject);
    procedure CBHeadingConcatenationClick(Sender: TObject);
    procedure EditHeadingSeparatorChange(Sender: TObject);
    procedure BitOkClick(Sender: TObject);
    procedure EditNumberOfPeriodsKeyPress(Sender: TObject; var Key: Char);
    procedure CBoxPeriodChange(Sender: TObject);
    procedure CBoxFromClick(Sender: TObject);

  public
    m_ReportCreated : boolean;

  private
    m_ReportSettings: TSettings;
    IsSettingForm : boolean;
    procedure m_InitForm;
    procedure m_IniDynamicExcel;
    procedure DisableComponent;
    function  SavedAsAutoRunMode : boolean;
//    procedure SaveDailyMachineReport;

  public
    constructor CreateExcelSettings(AOwner: TComponent);
    constructor CreateExcelScheduled(AOwner: TComponent; ReportSettings: TSettings; AdditionalColumns : boolean);
    constructor CreateExcelBinExtraction(AOwner: TComponent; dami : integer);
    constructor CreatePeriodMachineReport(AOwner: TComponent);
  end;

var
  FExcelReport: TFExcelReport;

implementation

{$R *.dfm}

uses UMGlobal, Vcl.CheckLst, mxNativeExcel, gnugettext, FMbin, UMbinGrid, UMCompat,
     UMBinDefault, UMRes, UMSchedContFunc, FMMainPlan, FmAutoRunSet, ComObj;

function CheckIfExcelInstalled: boolean;
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

//----------------------------------------------------------------------------//
{ Constructor for Excel Report Settings form for Dynamic Schedule Report
    @Param ReportSettings       Report settings given by FMResourceReport }
//----------------------------------------------------------------------------//

constructor TFExcelReport.CreateExcelSettings(AOwner: TComponent);
var
  ReportSet : TSettings;
begin
  inherited Create(Aowner);
  IsSettingForm := true;

  ReportSet.NativeExcel       := TmxNativeExcel.Create(self);
  ReportSet.IsPeriodMachineReport := false;
  ReportSet.ReportType        := 'Excel';
  ReportSet.ExcelTitle        := iniAppGlobals.ExcelTitle;
  ReportSet.GroupingFields    := -1;
  ReportSet.JumpingFields     := -1;
  ReportSet.ShowGroups        := false;
  ReportSet.ShowResources     := iniAppGlobals.ShowResources = '1';
  ReportSet.IsBinReport       := false;
  if ReportSet.IsBinReport then
  begin
    ReportSet.ShowBinCaptionBinReport := iniAppGlobals.ShowBinCaptionBinReport = '1';
    if iniAppGlobals.ShowColumnCaptionsBinReport = '1' then
      ReportSet.ShowColumnsCaptionsBinReport := true
    else
      ReportSet.ShowColumnsCaptionsBinReport := false;
  end
  else
  begin
    if iniAppGlobals.ShowColumnCaptionsReport = '1' then
      ReportSet.ShowColumnsCaptions := true
    else
      ReportSet.ShowColumnsCaptions := false;
    ReportSet.ShowBinCaption  := iniAppGlobals.ShowBinCaption = '1';
  end;
  ReportSet.ShowCriteria      := iniAppGlobals.ShowCriteria = '1';
  ReportSet.IncDowntime       := iniAppGlobals.IncDowntime = '1';
  ReportSet.ShowUnschedJobs   := false;
  ReportSet.IsExportReport    := true;
  ReportSet.NewPagePerRes     := iniAppGlobals.PagePerResource = '1';

  if iniAppGlobals.Concatenation = '1' then
    ReportSet.Concatenation    := true
  else
    ReportSet.Concatenation    := false;

  ReportSet.Separator        := iniAppGlobals.Separator;

  if iniAppGlobals.ShowTotalReport = '1' then
    ReportSet.ShowTotal := true
  else
    ReportSet.ShowTotal := false;

  if iniAppGlobals.HeadingConcatination = '1' then
    ReportSet.HeadingConcatenation := true
  else
    ReportSet.HeadingConcatenation := false;

  ReportSet.HeadingSeparator       := iniAppGlobals.HeadingSeparator;

  ComBoAttribute.Items.Add('');
  ComBoAttribute.Items.Add('Edit title');
  ComBoAttribute.Items.Add('Break for new resource');
  ComBoAttribute.Items.Add('Show Bin Caption');
  ComBoAttribute.Items.Add('Resource in heading');
  ComBoAttribute.Items.Add('Show Columns captions');
  ComBoAttribute.Items.Add('Show Selection Criteria');
  ComBoAttribute.Items.Add('Include Downtimes in statistics');
  ComBoAttribute.Items.Add('Show totals');
  ComBoAttribute.Items.Add('Include comments/instructions');
  ComBoAttribute.Items.Add('Column count');
  ComBoAttribute.Items.Add('Concatenation');
  ComBoAttribute.Items.Add('Separator');
  ComBoAttribute.Items.Add('Concatenation Heading');
  ComBoAttribute.Items.Add('Separator Heading');

  if iniAppGlobals.SelectedAtibute = 'EditTitle' then
    ComBoAttribute.ItemIndex := 1
  else if iniAppGlobals.SelectedAtibute = 'CBNewPagePerRes' then
    ComBoAttribute.ItemIndex := 2
  else if iniAppGlobals.SelectedAtibute = 'CBBinCaption' then
    ComBoAttribute.ItemIndex := 3
  else if iniAppGlobals.SelectedAtibute = 'CBResources' then
    ComBoAttribute.ItemIndex := 4
  else if iniAppGlobals.SelectedAtibute = 'CBShowColumnsCaptions' then
    ComBoAttribute.ItemIndex := 5
  else if iniAppGlobals.SelectedAtibute = 'CBSelection' then
    ComBoAttribute.ItemIndex := 6
  else if iniAppGlobals.SelectedAtibute = 'CBDowntime' then
    ComBoAttribute.ItemIndex := 7
  else if iniAppGlobals.SelectedAtibute = 'CBShowTotal' then
    ComBoAttribute.ItemIndex := 8
  else if iniAppGlobals.SelectedAtibute = 'CckBxPrintComments' then
    ComBoAttribute.ItemIndex := 9
  else if iniAppGlobals.SelectedAtibute = 'LblColumn' then
    ComBoAttribute.ItemIndex := 10
  else if iniAppGlobals.SelectedAtibute = 'GBConcatenation' then
    ComBoAttribute.ItemIndex := 11
  else if iniAppGlobals.SelectedAtibute = 'EditSeparator' then
    ComBoAttribute.ItemIndex := 12
  else if iniAppGlobals.SelectedAtibute = 'GBHeadingConcatenation' then
    ComBoAttribute.ItemIndex := 13
  else if iniAppGlobals.SelectedAtibute = 'EditHeadingSeparator' then
    ComBoAttribute.ItemIndex := 14;

  m_ReportSettings := ReportSet;
  m_InitForm;
end;

//----------------------------------------------------------------------------//

procedure TFExcelReport.DisableComponent;
begin
  LabTitle.Visible := false;
  EditTitle.Visible := false;
  CBNewPagePerRes.Visible := false;
  CBBinCaption.Visible := false;
  CBResources.Visible := false;
  CBShowColumnsCaptions.Visible := false;
  CBSelection.Visible := false;
  CBDowntime.Visible := false;
  CBShowTotal.Visible := false;
  CckBxPrintComments.Visible := false;
  LblColumn.Visible := false;
  CmbBxColumn.Visible := false;
  GBConcatenation.Visible := false;
  CBContcatenation.Visible := false;
  LblSeparator.Visible := false;
  EditSeparator.Visible := false;
  GBHeadingConcatenation.Visible := false;
  CBHeadingConcatenation.Visible := false;
  EditHeadingSeparator.Visible := false;
  LblHeadingSeparator.Visible := false;
  TabSheetFixedColumn.Tabvisible := false;
end;

//----------------------------------------------------------------------------//

{procedure TFExcelReport.SaveDailyMachineReport;
var
  saveDialog : TSaveDialog;
begin
  saveDialog := TSaveDialog.Create(self);
  saveDialog.Title := _('Save Excel Report as') + ':';
  saveDialog.InitialDir := GetCurrentDir;
  saveDialog.Filter := 'Excel file|*.xls';
  saveDialog.DefaultExt := 'xls';
  saveDialog.FilterIndex := 1;

  if (m_ReportSettings.BinFieldArrayReport[1].Field = CSC_NotSorted) or
     (m_ReportSettings.BinFieldArrayReport[2].Field = CSC_NotSorted) or
     (m_ReportSettings.BinFieldArrayReport[3].Field = CSC_NotSorted) or
     (m_ReportSettings.BinFieldArrayReport[4].Field = CSC_NotSorted) or
     (m_ReportSettings.BinFieldArrayReport[5].Field = CSC_NotSorted) or
     (m_ReportSettings.BinFieldArrayReport[6].Field = CSC_NotSorted) or
     (m_ReportSettings.BinFieldArrayReport[7].Field = CSC_NotSorted) or
     (m_ReportSettings.BinFieldArrayReport[8].Field = CSC_NotSorted) or
     (m_ReportSettings.BinFieldArrayReport[9].Field = CSC_NotSorted) or
     (m_ReportSettings.BinFieldArrayReport[10].Field = CSC_NotSorted) then
    m_ReportSettings.FixColumnsReport := true;

  if saveDialog.Execute then
  begin
    m_ReportSettings.SaveFileLocation := saveDialog.FileName;
    m_ReportSettings.NativeExcel      := TmxNativeExcel.Create(self);
    m_ReportSettings.ReportType       := 'ExcelDailyMachine';
  //  m_ReportSettings.IsBinReport      := not CBDowntime.Visible;

    m_ReportSettings.FixColumnsReport := true;
    m_ReportSettings.ShowColumnsCaptions := true;
    m_ReportSettings.ShowColumnsCaptionsBinReport := true;

//    m_ReportSettings.ShowTotal            := CBShowTotal.Checked;
//    m_ReportSettings.ShowCriteria     := CBSelection.Checked;
    m_ReportSettings.ShowResources    := true;
    m_ReportSettings.IncDowntime      := false;
    m_ReportSettings.ShowUnschedJobs  := false;
    m_ReportSettings.NewPagePerRes    := true;
    m_ReportSettings.IsExportReport   := true;

    m_ReportSettings.ExcelTitleBinReport := 'Sunday ' + DateTimeTostr(Date); //EditTitle.Text;
  {  if m_ReportSettings.IsBinReport then
    begin
      m_ReportSettings.ExcelTitleBinReport := 'Sunday ' + DateTimeTostr(Date); //EditTitle.Text;
      if CBShowColumnsCaptions.Checked then
        iniAppGlobals.ShowColumnCaptionsBinReport  := '1'
      else
        iniAppGlobals.ShowColumnCaptionsBinReport  := '0';
    end
    else
    begin
      m_ReportSettings.ExcelTitle := EditTitle.Text;
      if CBShowColumnsCaptions.Checked then
        iniAppGlobals.ShowColumnCaptionsReport  := '1'
      else
        iniAppGlobals.ShowColumnCaptionsReport  := '0';
    end;

    if CBContcatenation.Checked then
    begin
      iniAppGlobals.Concatenation       := '1';
      m_ReportSettings.Concatenation := true
    end
    else
    begin
      iniAppGlobals.Concatenation       := '0';
      m_ReportSettings.Concatenation := false
    end;

    if CBHeadingConcatenation.Checked then
    begin
      iniAppGlobals.HeadingConcatination       := '1';
      m_ReportSettings.HeadingConcatenation := true
    end
    else
    begin
      iniAppGlobals.HeadingConcatination       := '0';
      m_ReportSettings.HeadingConcatenation := false
    end;
           }
//    m_ReportSettings.Concatenation    := CBContcatenation.Checked;
//    iniAppGlobals.Separator           := EditSeparator.text;
//    m_ReportSettings.Separator        := EditSeparator.text;

//    iniAppGlobals.HeadingSeparator    := EditHeadingSeparator.text;
//    m_ReportSettings.HeadingSeparator := EditHeadingSeparator.text;


  {  if CBShowTotal.Checked then
      iniAppGlobals.ShowTotalReport  := '1'
    else
      iniAppGlobals.ShowTotalReport  := '0';

    if CBBinColumn1.ItemIndex = -1 then
    begin
      m_ReportSettings.BinFieldArrayReport[1].Field := CSC_NotSorted;
      iniAppGlobals.Field1BinColReportStatic := '';
    end
    else
    begin
      m_ReportSettings.BinFieldArrayReport[1].Field := BinColDefault[CBBinColumn1.ItemIndex].Field;
      m_ReportSettings.BinFieldArrayReport[1].pos := BinColDefault[CBBinColumn1.ItemIndex].pos;
     // m_ReportSettings.BinFieldArrayReport[1].pos := BinColDefault[CBBinColumn1.ItemIndex].pos;
      iniAppGlobals.Field1BinColReportStatic := IntToStr(BinColDefault[CBBinColumn1.ItemIndex].pos);
    end;

    if CBBinColumn2.ItemIndex = -1 then
    begin
      m_ReportSettings.BinFieldArrayReport[2].Field := CSC_NotSorted;
      iniAppGlobals.Field2BinColReportStatic := '';
    end
    else
    begin
      m_ReportSettings.BinFieldArrayReport[2].Field := BinColDefault[CBBinColumn2.ItemIndex].Field;
      m_ReportSettings.BinFieldArrayReport[2].pos := BinColDefault[CBBinColumn2.ItemIndex].pos;
      iniAppGlobals.Field2BinColReportStatic := IntToStr(BinColDefault[CBBinColumn2.ItemIndex].pos);
    end;

    if CBBinColumn3.ItemIndex = -1 then
    begin
      m_ReportSettings.BinFieldArrayReport[3].Field := CSC_NotSorted;
      iniAppGlobals.Field3BinColReportStatic := '';
    end
    else
    begin
      m_ReportSettings.BinFieldArrayReport[3].Field := BinColDefault[CBBinColumn3.ItemIndex].Field;
      m_ReportSettings.BinFieldArrayReport[3].pos := BinColDefault[CBBinColumn3.ItemIndex].pos;
      iniAppGlobals.Field3BinColReportStatic := IntToStr(BinColDefault[CBBinColumn3.ItemIndex].pos);
    end;

    if CBBinColumn4.ItemIndex = -1 then
    begin
      m_ReportSettings.BinFieldArrayReport[4].Field := CSC_NotSorted;
      iniAppGlobals.Field4BinColReportStatic := '';
    end
    else
    begin
      m_ReportSettings.BinFieldArrayReport[4].Field := BinColDefault[CBBinColumn4.ItemIndex].Field;
      m_ReportSettings.BinFieldArrayReport[4].pos := BinColDefault[CBBinColumn4.ItemIndex].pos;
      iniAppGlobals.Field4BinColReportStatic := IntToStr(BinColDefault[CBBinColumn4.ItemIndex].pos);
    end;

    if CBBinColumn5.ItemIndex = -1 then
    begin
      m_ReportSettings.BinFieldArrayReport[5].Field := CSC_NotSorted;
      iniAppGlobals.Field5BinColReportStatic := '';
    end
    else
    begin
      m_ReportSettings.BinFieldArrayReport[5].Field := BinColDefault[CBBinColumn5.ItemIndex].Field;
      m_ReportSettings.BinFieldArrayReport[5].pos := BinColDefault[CBBinColumn5.ItemIndex].pos;
      iniAppGlobals.Field5BinColReportStatic := IntToStr(BinColDefault[CBBinColumn5.ItemIndex].pos);
    end;

    if CBBinColumn6.ItemIndex = -1 then
    begin
      m_ReportSettings.BinFieldArrayReport[6].Field := CSC_NotSorted;
      iniAppGlobals.Field6BinColReportStatic := '';
    end
    else
    begin
      m_ReportSettings.BinFieldArrayReport[6].Field := BinColDefault[CBBinColumn6.ItemIndex].Field;
      m_ReportSettings.BinFieldArrayReport[6].pos := BinColDefault[CBBinColumn6.ItemIndex].pos;
      iniAppGlobals.Field6BinColReportStatic := IntToStr(BinColDefault[CBBinColumn6.ItemIndex].pos);
    end;

    if CBBinColumn7.ItemIndex = -1 then
    begin
      m_ReportSettings.BinFieldArrayReport[7].Field := CSC_NotSorted;
      iniAppGlobals.Field7BinColReportStatic := '';
    end
    else
    begin
      m_ReportSettings.BinFieldArrayReport[7].Field := BinColDefault[CBBinColumn7.ItemIndex].Field;
      m_ReportSettings.BinFieldArrayReport[7].pos := BinColDefault[CBBinColumn7.ItemIndex].pos;
      iniAppGlobals.Field7BinColReportStatic := IntToStr(BinColDefault[CBBinColumn7.ItemIndex].pos);
    end;

    if CBBinColumn8.ItemIndex = -1 then
    begin
      m_ReportSettings.BinFieldArrayReport[8].Field := CSC_NotSorted;
      iniAppGlobals.Field8BinColReportStatic := '';
    end
    else
    begin
      m_ReportSettings.BinFieldArrayReport[8].Field := BinColDefault[CBBinColumn8.ItemIndex].Field;
      m_ReportSettings.BinFieldArrayReport[8].pos := BinColDefault[CBBinColumn8.ItemIndex].pos;
      iniAppGlobals.Field8BinColReportStatic := IntToStr(BinColDefault[CBBinColumn8.ItemIndex].pos);
    end;

    if CBBinColumn9.ItemIndex = -1 then
    begin
      m_ReportSettings.BinFieldArrayReport[9].Field := CSC_NotSorted;
      iniAppGlobals.Field9BinColReportStatic := '';
    end
    else
    begin
      m_ReportSettings.BinFieldArrayReport[9].Field := BinColDefault[CBBinColumn9.ItemIndex].Field;
      m_ReportSettings.BinFieldArrayReport[9].pos := BinColDefault[CBBinColumn9.ItemIndex].pos;
      iniAppGlobals.Field9BinColReportStatic := IntToStr(BinColDefault[CBBinColumn9.ItemIndex].pos);
    end;

    if CBBinColumn10.ItemIndex = -1 then
    begin
      m_ReportSettings.BinFieldArrayReport[10].Field := CSC_NotSorted;
      iniAppGlobals.Field10BinColReportStatic := '';
    end
    else
    begin
      m_ReportSettings.BinFieldArrayReport[10].Field := BinColDefault[CBBinColumn10.ItemIndex].Field;
      m_ReportSettings.BinFieldArrayReport[10].pos := BinColDefault[CBBinColumn10.ItemIndex].pos;
      iniAppGlobals.Field10BinColReportStatic := IntToStr(BinColDefault[CBBinColumn10.ItemIndex].pos);
    end;

    m_ReportSettings.PrintComments    := CckBxPrintComments.Checked;
    try
      m_ReportSettings.ColumnComments := StrToInt(CmbBxColumn.Text);
    except m_ReportSettings.ColumnComments := 0;
    end;
    if (m_ReportSettings.ColumnComments < 1) or (m_ReportSettings.ColumnComments > 99)
      then m_ReportSettings.ColumnComments := 1;

    if m_ReportSettings.IsBinReport then
    begin
      try
        m_ReportSettings.GroupingFields := StrToInt(ComBoxSortCrits.Text);
      except m_ReportSettings.GroupingFields := 0;
      end;
      if (m_ReportSettings.GroupingFields < 0) or (m_ReportSettings.GroupingFields > 4)
        then m_ReportSettings.GroupingFields := 0;
    end
    else m_ReportSettings.GroupingFields := -1;
    m_ReportSettings.ShowGroups       := CBGroups.Checked;

    if BinExtractionReport(m_ReportSettings)
  //  if ((m_ReportSettings.IsBinReport) and (BinExtractionReport(m_ReportSettings)))
  //    or ((not m_ReportSettings.IsBinReport) and (DynamicScheduleExport(m_ReportSettings, true)))
    then ShowMessage(_('Excel Report saved'))
    else ShowMessage(_('Report saving aborted'));
    m_ReportSettings.NativeExcel.Free;
  end
  else ShowMessage(_('Saving file was cancelled'));
  saveDialog.Free;
end;        }

//----------------------------------------------------------------------------//

constructor TFExcelReport.CreateExcelScheduled(AOwner: TComponent; ReportSettings: TSettings; AdditionalColumns : boolean);
begin
  try
    inherited Create(Aowner);
    m_ReportSettings := ReportSettings;

    m_InitForm;
    TabSheetPeriodMachine.TabVisible := false;
    if AdditionalColumns then
      TabSheetFixedColumn.TabVisible := true
    else
      TabSheetFixedColumn.TabVisible := false;
    if iniAppGlobals.SelectedAtibute <> '' then
      m_IniDynamicExcel;
  except
    on e:Exception do MessageDlg('FMExcelReport - CreateExcelScheduled'+#13'Message: ' + e.Message, mtError, [mbOK], 0);
  end;
end;

//----------------------------------------------------------------------------//
{ Constructor for Excel Report Settings form for Bin Extraction }
//----------------------------------------------------------------------------//

constructor TFExcelReport.CreateExcelBinExtraction(AOwner: TComponent; dami : integer);
begin
  try
    inherited Create(Aowner);
    m_ReportSettings.NativeExcel      := TmxNativeExcel.Create(self);
    m_ReportSettings.IsPeriodMachineReport := false;
    m_ReportSettings.ReportType       := 'Excel';
    m_ReportSettings.IsBinReport      := true;
    m_ReportSettings.ShowBinCaptionBinReport := iniAppGlobals.ShowBinCaptionBinReport = '1';
    m_ReportSettings.ShowCriteria     := iniAppGlobals.ShowCriteria = '1';
    m_ReportSettings.ShowResources    := false;
    m_ReportSettings.IncDowntime      := iniAppGlobals.IncDowntime = '1';
    m_ReportSettings.ShowUnschedJobs  := true;
    m_ReportSettings.IsExportReport   := true;
    m_ReportSettings.ExcelTitleBinReport       := iniAppGlobals.ExcelTitleBinReport;
    m_ReportSettings.NewPagePerRes    := false;
    if iniAppGlobals.Concatenation = '1' then
      m_ReportSettings.Concatenation := true
    else
      m_ReportSettings.Concatenation := false;

    m_ReportSettings.Separator         := iniAppGlobals.Separator;
    m_ReportSettings.HeadingSeparator  := iniAppGlobals.HeadingSeparator;

    if iniAppGlobals.ShowColumnCaptionsBinReport = '1' then
      m_ReportSettings.ShowColumnsCaptionsBinReport := true
    else
      m_ReportSettings.ShowColumnsCaptionsBinReport := false;

    if iniAppGlobals.ShowTotalReport = '1' then
      m_ReportSettings.ShowTotal := true
    else
      m_ReportSettings.ShowTotal := false;

    if iniAppGlobals.HeadingConcatination = '1' then
      m_ReportSettings.HeadingConcatenation := true
    else
      m_ReportSettings.HeadingConcatenation := false;

    TabSheetFixedColumn.tabVisible := false;
    TabSheetPeriodMachine.TabVisible := false;

    GBHeadingConcatenation.Visible := false;
    CBHeadingConcatenation.Visible := false;
    LblHeadingSeparator.Visible := false;
    EditHeadingSeparator.Visible := false;
    GBConcatenation.Visible := false;
    CBContcatenation.Visible := false;
    LblSeparator.Visible := false;
    EditSeparator.Visible := false;
    CBShowTotal.Visible   := false;

    try
      m_ReportSettings.GroupingFields := StrToInt(iniAppGlobals.GroupingFields);
    except m_ReportSettings.GroupingFields := 0;
    end;
    if (m_ReportSettings.GroupingFields < 0) or (m_ReportSettings.GroupingFields > 4)
    then m_ReportSettings.GroupingFields := 0;
    m_ReportSettings.ShowGroups       := iniAppGlobals.ShowGroups = '1';
    m_InitForm;
  except
    on e:Exception do MessageDlg('FMExcelReport - CreateExcelBinExtraction'+#13'Message: ' + e.Message, mtError, [mbOK], 0);
  end;
end;

//----------------------------------------------------------------------------//

constructor TFExcelReport.CreatePeriodMachineReport(AOwner: TComponent);
var
  page : Integer;
begin
  m_ReportCreated := true;
  try
    inherited Create(Aowner);
    m_ReportSettings.NativeExcel      := TmxNativeExcel.Create(self);

    LblFileNameByAutoRun.Caption :=  ' *' + 'File name for automatic operation : ' + LocAppGlobals.AppDir + 'Reports\ : ';

    EditMachinePeriodFileName.Text := iniAppGlobals.MachineReportFileNameAutoOperation;

    for page := 0 to PageControl1.PageCount - 1 do
      PageControl1.Pages[page].TabVisible := false;

    PageControl1.Pages[3].TabVisible := true;

    CBShowFromTo.Checked := false;

    if (iniAppGlobals.MachineReportShowFromToHeader = '1') or (iniAppGlobals.MachineReportShowFromToHeader = '') then
      CBShowFromTo.Checked := true;

    m_ReportSettings.IsPeriodMachineReport := true;

    if iniAppGlobals.MachineReportPeriod = '1' then
       CBoxPeriod.ItemIndex := 0
    else if iniAppGlobals.MachineReportPeriod = '2' then
       CBoxPeriod.ItemIndex := 1
    else if iniAppGlobals.MachineReportPeriod = '3' then
       CBoxPeriod.ItemIndex := 2;

    if iniAppGlobals.MachineReportPeriodFrom = '1' then
       CBoxFrom.ItemIndex := 0
    else if iniAppGlobals.MachineReportPeriodFrom = '2' then
       CBoxFrom.ItemIndex := 1;

    if iniAppGlobals.MachineReportPeriodNum = '' then
      EditNumberOfPeriods.Text := '3'
    else
      EditNumberOfPeriods.Text := iniAppGlobals.MachineReportPeriodNum;

    if iniAppGlobals.MachineReportDaysMinusDoday = '' then
      EditTodayMinusDays.Text := '0'
    else
      EditTodayMinusDays.Text := iniAppGlobals.MachineReportDaysMinusDoday;

    if iniAppGlobals.MachineReportPeriodTitle = '' then
      EditPeriodMachineTitle.Text := 'Resource period report'
    else
      EditPeriodMachineTitle.Text := iniAppGlobals.MachineReportPeriodTitle;

  except
    on e:Exception do MessageDlg('FMExcelReport - CreateExcelBinExtraction'+#13'Message: ' + e.Message, mtError, [mbOK], 0);
  end;

end;

//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
{ Initializes form }
//----------------------------------------------------------------------------//

procedure TFExcelReport.m_IniDynamicExcel;
begin
  if iniAppGlobals.SelectedAtibute <> '' then
  begin
    DisableComponent;
    if iniAppGlobals.SelectedAtibute = 'EditTitle' then
    begin
      LabTitle.Visible := true;
      EditTitle.Visible := true;
    end
    else if iniAppGlobals.SelectedAtibute = 'CBNewPagePerRes' then
      CBNewPagePerRes.Visible := true
    else if iniAppGlobals.SelectedAtibute = 'CBBinCaption' then
      CBBinCaption.Visible := true
    else if iniAppGlobals.SelectedAtibute = 'CBResources' then
      CBResources.Visible := true
    else if iniAppGlobals.SelectedAtibute = 'CBShowColumnsCaptions' then
      CBShowColumnsCaptions.Visible := true
    else if iniAppGlobals.SelectedAtibute = 'CBSelection' then
      CBSelection.Visible := true
    else if iniAppGlobals.SelectedAtibute = 'CBDowntime' then
      CBDowntime.Visible := true
    else if iniAppGlobals.SelectedAtibute = 'CBShowTotal' then
      CBShowTotal.Visible := true
    else if iniAppGlobals.SelectedAtibute = 'CckBxPrintComments' then
      CckBxPrintComments.Visible := true
    else if iniAppGlobals.SelectedAtibute = 'LblColumn' then
    begin
      LblColumn.Visible := true;
      CmbBxColumn.Visible := true
    end
    else if iniAppGlobals.SelectedAtibute = 'GBConcatenation' then
    begin
      GBConcatenation.Visible := true;
      CBContcatenation.Visible := true;
      LblSeparator.Visible := false;
      EditSeparator.Visible := false
    end
    else if iniAppGlobals.SelectedAtibute = 'EditSeparator' then
    begin
      GBConcatenation.Visible := true;
      CBContcatenation.Visible := false;
      LblSeparator.Visible := true;
      EditSeparator.Visible := true
    end
    else if iniAppGlobals.SelectedAtibute = 'GBHeadingConcatenation' then
    begin
      GBHeadingConcatenation.Visible := true;
      CBHeadingConcatenation.Visible := true;
      LblHeadingSeparator.Visible := false;
      EditHeadingSeparator.Visible := false
    end
    else if iniAppGlobals.SelectedAtibute = 'EditHeadingSeparator' then
    begin
      GBHeadingConcatenation.Visible := true;
      CBHeadingConcatenation.Visible := false;
      LblHeadingSeparator.Visible := true;
      EditHeadingSeparator.Visible := true
    end
  end;
end;

//----------------------------------------------------------------------------//

procedure TFExcelReport.m_InitForm;
var
  i    : integer;
  binGrid     : TBinDrawGrid;
  FieldsCount : integer;
begin
  if m_ReportSettings.IsBinReport then
  begin
    // Preparing form for Bin Report
    CBBinCaption.Checked    := iniAppGlobals.ShowBinCaptionBinReport = '1';
    CBShowColumnsCaptions.Checked := m_ReportSettings.ShowColumnsCaptionsBinReport;
    CBUnschedJobs.Checked   := true;
    CBDowntime.Visible      := false;
    CBSelection.Visible     := false;
    CBNewPagePerRes.Visible := false;
    CBResources.Visible     := false;
    EditTitle.Text          := m_ReportSettings.ExcelTitleBinReport;
    CBGroups.Top            := 105;
  end
  else
  begin
    // Preparing form for Schedule Report
    CBUnschedJobs.Checked   := false;
    LabelSortCrit.Visible   := false;
    ComBoxSortCrits.Visible := false;
    CBGroups.Visible        := false;
    LabTitle.Top            := 30;
    EditTitle.Top           := 28;
    CBNewPagePerRes.Top     := 78;
    CBBinCaption.Top        := 104;
    CBResources.Top         := 104;
    CBDowntime.Top          := 130;
    CBSelection.Top         := 130;
    CBShowColumnsCaptions.Checked := m_ReportSettings.ShowColumnsCaptions;
    CBBinCaption.Checked    := iniAppGlobals.ShowBinCaption = '1';
    EditTitle.Text          := m_ReportSettings.ExcelTitle;
  end;

  ComBoxSortCrits.Text    := IntToStr(m_ReportSettings.GroupingFields);

  CBShowTotal.Checked := m_ReportSettings.ShowTotal;

  CBDowntime.Checked      := m_ReportSettings.IncDowntime;
  CBSelection.Checked     := m_ReportSettings.ShowCriteria;
  CBGroups.Checked        := m_ReportSettings.ShowGroups;
  CBResources.Checked     := m_ReportSettings.ShowResources;
  CBNewPagePerRes.Checked := m_ReportSettings.NewPagePerRes;
  Caption                 := _('Excel Report Settings');
  BtnSave.Caption         := '&' + _('Save');
  BtnClose.Caption        := '&' + _('Close');
  LabTitle.Caption        := _('Title');
  LabelSortCrit.Caption   := _('Number of grouping fields');
  CBBinCaption.Caption    := _('Show Bin Caption');
  CBResources.Caption     := _('Resource in heading');
  CBSelection.Caption     := _('Show Selection Criteria');
  CBDowntime.Caption      := _('Include Downtimes in statistics');
  CBUnschedJobs.Caption   := _('Include Unscheduled Jobs');
  CBNewPagePerRes.Caption := _('Break for new resource');
  CBGroups.Caption        := _('Show group attributes');

  CBContcatenation.Checked := m_ReportSettings.Concatenation;
  CBHeadingConcatenation.Checked := m_ReportSettings.HeadingConcatenation;
  EditSeparator.Text := m_ReportSettings.Separator;
  EditHeadingSeparator.Text := m_ReportSettings.HeadingSeparator;

  binGrid := FBin.GetActiveView.GetBinGrid;
  for i := low(binGrid.BinColumnSet) to high(binGrid.BinColumnSet) do
    with m_ReportSettings.BinFieldsArray[i] do
    begin
      Field   := binGrid.BinColumnSet[i].Field;
      Title   := binGrid.BinColumnSet[i].Title;
      Pos     := binGrid.BinColumnSet[i].Pos;
      Width   := binGrid.BinColumnSet[i].Width;
      Visible := binGrid.BinColumnSet[i].Visible;
      Order   := binGrid.BinColumnSet[i].Order;
    end;

  FieldsCount := GetNumberFields;

  for I := low(m_ReportSettings.BinFieldsArray) to FieldsCount - 1 do
  begin
    CBBinColumn1.Items.Add(m_ReportSettings.BinFieldsArray[i].Title);
    CBBinColumn2.Items.Add(m_ReportSettings.BinFieldsArray[i].Title);
    CBBinColumn3.Items.Add(m_ReportSettings.BinFieldsArray[i].Title);
    CBBinColumn4.Items.Add(m_ReportSettings.BinFieldsArray[i].Title);
    CBBinColumn5.Items.Add(m_ReportSettings.BinFieldsArray[i].Title);
    CBBinColumn6.Items.Add(m_ReportSettings.BinFieldsArray[i].Title);
    CBBinColumn7.Items.Add(m_ReportSettings.BinFieldsArray[i].Title);
    CBBinColumn8.Items.Add(m_ReportSettings.BinFieldsArray[i].Title);
    CBBinColumn9.Items.Add(m_ReportSettings.BinFieldsArray[i].Title);
    CBBinColumn10.Items.Add(m_ReportSettings.BinFieldsArray[i].Title);
  end;

{  Index := 0;
  for I := 0 to high(DBAppGlobals.ShowBinPropArry) do
  begin
    if not (DBAppGlobals.ShowBinPropArry[I] = nil) then
      Index := Index + 1
    else
      break;
  end;

  PropPosition := FieldsCount + Index;
  num := -1;

  for I := FieldsCount to (PropPosition - 1) do
  begin

    case (m_ReportSettings.BinFieldsArray[I].Field) of
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
      CSC_property30:  num := 29
    end;

    if (num <> -1) then
    begin
      pId := DBAppGlobals.ShowBinPropArry[num];
      if pId <> nil then
      begin
        m_ReportSettings.BinFieldsArray[i].Title := GetPropDescr(pId);
        CBBinColumn1.Items.Add(GetPropDescr(pId));
        CBBinColumn2.Items.Add(GetPropDescr(pId));
        CBBinColumn3.Items.Add(GetPropDescr(pId));
        CBBinColumn4.Items.Add(GetPropDescr(pId));
        CBBinColumn5.Items.Add(GetPropDescr(pId));
        CBBinColumn6.Items.Add(GetPropDescr(pId));
        CBBinColumn7.Items.Add(GetPropDescr(pId));
        CBBinColumn8.Items.Add(GetPropDescr(pId));
        CBBinColumn9.Items.Add(GetPropDescr(pId));
        CBBinColumn10.Items.Add(GetPropDescr(pId));
      end;
    end;
  end; }

  m_ReportSettings.BinFieldArrayReport[1].Field := CSC_NotSorted;
  if iniAppGlobals.Field1BinColReportStatic <> '' then
  begin
    CBBinColumn1.ItemIndex := StrToInt(iniAppGlobals.Field1BinColReportStatic);
    m_ReportSettings.BinFieldArrayReport[1].Field := BinColDefault[CBBinColumn1.ItemIndex].Field;
  end;

  m_ReportSettings.BinFieldArrayReport[2].Field := CSC_NotSorted;
  if iniAppGlobals.Field2BinColReportStatic <> '' then
  begin
    CBBinColumn2.ItemIndex := StrToInt(iniAppGlobals.Field2BinColReportStatic);
    m_ReportSettings.BinFieldArrayReport[2].Field := BinColDefault[CBBinColumn2.ItemIndex].Field;
  end;

  m_ReportSettings.BinFieldArrayReport[3].Field := CSC_NotSorted;
  if iniAppGlobals.Field3BinColReportStatic <> '' then
  begin
    CBBinColumn3.ItemIndex := StrToInt(iniAppGlobals.Field3BinColReportStatic);
    m_ReportSettings.BinFieldArrayReport[3].Field := BinColDefault[CBBinColumn3.ItemIndex].Field;
  end;

  m_ReportSettings.BinFieldArrayReport[4].Field := CSC_NotSorted;
  if iniAppGlobals.Field4BinColReportStatic <> '' then
  begin
    CBBinColumn4.ItemIndex := StrToInt(iniAppGlobals.Field4BinColReportStatic);
    m_ReportSettings.BinFieldArrayReport[4].Field := BinColDefault[CBBinColumn4.ItemIndex].Field;
  end;

  m_ReportSettings.BinFieldArrayReport[5].Field := CSC_NotSorted;
  if iniAppGlobals.Field5BinColReportStatic <> '' then
  begin
    CBBinColumn5.ItemIndex := StrToInt(iniAppGlobals.Field5BinColReportStatic);
    m_ReportSettings.BinFieldArrayReport[5].Field := BinColDefault[CBBinColumn5.ItemIndex].Field;
  end;

  m_ReportSettings.BinFieldArrayReport[6].Field := CSC_NotSorted;
  if iniAppGlobals.Field6BinColReportStatic <> '' then
  begin
    CBBinColumn6.ItemIndex := StrToInt(iniAppGlobals.Field6BinColReportStatic);
    m_ReportSettings.BinFieldArrayReport[6].Field := BinColDefault[CBBinColumn6.ItemIndex].Field;
  end;

  m_ReportSettings.BinFieldArrayReport[7].Field := CSC_NotSorted;
  if iniAppGlobals.Field7BinColReportStatic <> '' then
  begin
    CBBinColumn7.ItemIndex := StrToInt(iniAppGlobals.Field7BinColReportStatic);
    m_ReportSettings.BinFieldArrayReport[7].Field := BinColDefault[CBBinColumn7.ItemIndex].Field;
  end;

  m_ReportSettings.BinFieldArrayReport[8].Field := CSC_NotSorted;
  if iniAppGlobals.Field8BinColReportStatic <> '' then
  begin
    CBBinColumn8.ItemIndex := StrToInt(iniAppGlobals.Field8BinColReportStatic);
    m_ReportSettings.BinFieldArrayReport[8].Field := BinColDefault[CBBinColumn8.ItemIndex].Field;
  end;

  m_ReportSettings.BinFieldArrayReport[9].Field := CSC_NotSorted;
  if iniAppGlobals.Field9BinColReportStatic <> '' then
  begin
    CBBinColumn9.ItemIndex := StrToInt(iniAppGlobals.Field9BinColReportStatic);
    m_ReportSettings.BinFieldArrayReport[9].Field := BinColDefault[CBBinColumn9.ItemIndex].Field;
  end;

  m_ReportSettings.BinFieldArrayReport[10].Field := CSC_NotSorted;
  if iniAppGlobals.Field10BinColReportStatic <> '' then
  begin
    CBBinColumn10.ItemIndex := StrToInt(iniAppGlobals.Field10BinColReportStatic);
    m_ReportSettings.BinFieldArrayReport[10].Field := BinColDefault[CBBinColumn10.ItemIndex].Field;
  end;

end;

//----------------------------------------------------------------------------//
{ Uses File Dialog to determine export file for report created in UMReportExport }
//----------------------------------------------------------------------------//

function TFExcelReport.SavedAsAutoRunMode : boolean;
var
  I : Integer;
  VisRes : TMqmVisibleRes;
  FileName : string;
begin
  if iniAppGlobals.MachineReportFileNameAutoOperation = '' then
     iniAppGlobals.MachineReportFileNameAutoOperation := 'ResourcePeriod';

  FileName := iniAppGlobals.MachineReportFileNameAutoOperation;

  CreateDir(LocAppGlobals.AppDir + '\' + 'Reports');
  DeleteFile(LocAppGlobals.AppDir + 'Reports\' + FileName + '.Xls');

  m_ReportSettings.SaveFileLocation := LocAppGlobals.AppDir + 'Reports\' + FileName + '.Xls'; //    saveDialog.FileName;
  m_ReportSettings.NativeExcel      := TmxNativeExcel.Create(self);
  m_ReportSettings.ReportType       := 'Excel';
  m_ReportSettings.ShowColumnsCaptions  := CBShowColumnsCaptions.Checked;
  m_ReportSettings.ShowTotal            := CBShowTotal.Checked;
  m_ReportSettings.ShowCriteria     := CBSelection.Checked;
  m_ReportSettings.ShowResources    := CBResources.Checked;
  m_ReportSettings.IncDowntime      := CBDowntime.Checked;
  m_ReportSettings.ShowUnschedJobs  := CBUnschedJobs.Checked;
  m_ReportSettings.NewPagePerRes    := CBNewPagePerRes.Checked;
  m_ReportSettings.IsExportReport   := true;
  if m_ReportSettings.IsBinReport then
  begin
    m_ReportSettings.ExcelTitleBinReport := EditTitle.Text;
    if CBShowColumnsCaptions.Checked then
    begin
      iniAppGlobals.ShowColumnCaptionsBinReport  := '1';
      m_ReportSettings.ShowBinCaptionBinReport := true
    end
    else
    begin
      iniAppGlobals.ShowColumnCaptionsBinReport  := '0';
      m_ReportSettings.ShowBinCaptionBinReport := false
    end;
  end
  else
  begin
    m_ReportSettings.ExcelTitle := EditTitle.Text;
    if CBShowColumnsCaptions.Checked then
      iniAppGlobals.ShowColumnCaptionsReport  := '1'
    else
      iniAppGlobals.ShowColumnCaptionsReport  := '0';
  end;

  if CBContcatenation.Checked then
  begin
    iniAppGlobals.Concatenation       := '1';
    m_ReportSettings.Concatenation := true
  end
  else
  begin
    iniAppGlobals.Concatenation       := '0';
    m_ReportSettings.Concatenation := false
  end;

  if CBHeadingConcatenation.Checked then
  begin
    iniAppGlobals.HeadingConcatination       := '1';
    m_ReportSettings.HeadingConcatenation := true
  end
  else
  begin
    iniAppGlobals.HeadingConcatination       := '0';
    m_ReportSettings.HeadingConcatenation := false
  end;

//    m_ReportSettings.Concatenation    := CBContcatenation.Checked;
  iniAppGlobals.Separator           := EditSeparator.text;
  m_ReportSettings.Separator        := EditSeparator.text;

  iniAppGlobals.HeadingSeparator    := EditHeadingSeparator.text;
  m_ReportSettings.HeadingSeparator := EditHeadingSeparator.text;


  if CBShowTotal.Checked then
    iniAppGlobals.ShowTotalReport  := '1'
  else
    iniAppGlobals.ShowTotalReport  := '0';

  if CBBinColumn1.ItemIndex = -1 then
  begin
    m_ReportSettings.BinFieldArrayReport[1].Field := CSC_NotSorted;
    iniAppGlobals.Field1BinColReportStatic := '';
  end
  else
  begin
    m_ReportSettings.BinFieldArrayReport[1].Field := BinColDefault[CBBinColumn1.ItemIndex].Field;
    m_ReportSettings.BinFieldArrayReport[1].pos := BinColDefault[CBBinColumn1.ItemIndex].pos;
   // m_ReportSettings.BinFieldArrayReport[1].pos := BinColDefault[CBBinColumn1.ItemIndex].pos;
    iniAppGlobals.Field1BinColReportStatic := IntToStr(BinColDefault[CBBinColumn1.ItemIndex].pos);
  end;

  if CBBinColumn2.ItemIndex = -1 then
  begin
    m_ReportSettings.BinFieldArrayReport[2].Field := CSC_NotSorted;
    iniAppGlobals.Field2BinColReportStatic := '';
  end
  else
  begin
    m_ReportSettings.BinFieldArrayReport[2].Field := BinColDefault[CBBinColumn2.ItemIndex].Field;
    m_ReportSettings.BinFieldArrayReport[2].pos := BinColDefault[CBBinColumn2.ItemIndex].pos;
    iniAppGlobals.Field2BinColReportStatic := IntToStr(BinColDefault[CBBinColumn2.ItemIndex].pos);
  end;

  if CBBinColumn3.ItemIndex = -1 then
  begin
    m_ReportSettings.BinFieldArrayReport[3].Field := CSC_NotSorted;
    iniAppGlobals.Field3BinColReportStatic := '';
  end
  else
  begin
    m_ReportSettings.BinFieldArrayReport[3].Field := BinColDefault[CBBinColumn3.ItemIndex].Field;
    m_ReportSettings.BinFieldArrayReport[3].pos := BinColDefault[CBBinColumn3.ItemIndex].pos;
    iniAppGlobals.Field3BinColReportStatic := IntToStr(BinColDefault[CBBinColumn3.ItemIndex].pos);
  end;

  if CBBinColumn4.ItemIndex = -1 then
  begin
    m_ReportSettings.BinFieldArrayReport[4].Field := CSC_NotSorted;
    iniAppGlobals.Field4BinColReportStatic := '';
  end
  else
  begin
    m_ReportSettings.BinFieldArrayReport[4].Field := BinColDefault[CBBinColumn4.ItemIndex].Field;
    m_ReportSettings.BinFieldArrayReport[4].pos := BinColDefault[CBBinColumn4.ItemIndex].pos;
    iniAppGlobals.Field4BinColReportStatic := IntToStr(BinColDefault[CBBinColumn4.ItemIndex].pos);
  end;

  if CBBinColumn5.ItemIndex = -1 then
  begin
    m_ReportSettings.BinFieldArrayReport[5].Field := CSC_NotSorted;
    iniAppGlobals.Field5BinColReportStatic := '';
  end
  else
  begin
    m_ReportSettings.BinFieldArrayReport[5].Field := BinColDefault[CBBinColumn5.ItemIndex].Field;
    m_ReportSettings.BinFieldArrayReport[5].pos := BinColDefault[CBBinColumn5.ItemIndex].pos;
    iniAppGlobals.Field5BinColReportStatic := IntToStr(BinColDefault[CBBinColumn5.ItemIndex].pos);
  end;

  if CBBinColumn6.ItemIndex = -1 then
  begin
    m_ReportSettings.BinFieldArrayReport[6].Field := CSC_NotSorted;
    iniAppGlobals.Field6BinColReportStatic := '';
  end
  else
  begin
    m_ReportSettings.BinFieldArrayReport[6].Field := BinColDefault[CBBinColumn6.ItemIndex].Field;
    m_ReportSettings.BinFieldArrayReport[6].pos := BinColDefault[CBBinColumn6.ItemIndex].pos;
    iniAppGlobals.Field6BinColReportStatic := IntToStr(BinColDefault[CBBinColumn6.ItemIndex].pos);
  end;

  if CBBinColumn7.ItemIndex = -1 then
  begin
    m_ReportSettings.BinFieldArrayReport[7].Field := CSC_NotSorted;
    iniAppGlobals.Field7BinColReportStatic := '';
  end
  else
  begin
    m_ReportSettings.BinFieldArrayReport[7].Field := BinColDefault[CBBinColumn7.ItemIndex].Field;
    m_ReportSettings.BinFieldArrayReport[7].pos := BinColDefault[CBBinColumn7.ItemIndex].pos;
    iniAppGlobals.Field7BinColReportStatic := IntToStr(BinColDefault[CBBinColumn7.ItemIndex].pos);
  end;

  if CBBinColumn8.ItemIndex = -1 then
  begin
    m_ReportSettings.BinFieldArrayReport[8].Field := CSC_NotSorted;
    iniAppGlobals.Field8BinColReportStatic := '';
  end
  else
  begin
    m_ReportSettings.BinFieldArrayReport[8].Field := BinColDefault[CBBinColumn8.ItemIndex].Field;
    m_ReportSettings.BinFieldArrayReport[8].pos := BinColDefault[CBBinColumn8.ItemIndex].pos;
    iniAppGlobals.Field8BinColReportStatic := IntToStr(BinColDefault[CBBinColumn8.ItemIndex].pos);
  end;

  if CBBinColumn9.ItemIndex = -1 then
  begin
    m_ReportSettings.BinFieldArrayReport[9].Field := CSC_NotSorted;
    iniAppGlobals.Field9BinColReportStatic := '';
  end
  else
  begin
    m_ReportSettings.BinFieldArrayReport[9].Field := BinColDefault[CBBinColumn9.ItemIndex].Field;
    m_ReportSettings.BinFieldArrayReport[9].pos := BinColDefault[CBBinColumn9.ItemIndex].pos;
    iniAppGlobals.Field9BinColReportStatic := IntToStr(BinColDefault[CBBinColumn9.ItemIndex].pos);
  end;

  if CBBinColumn10.ItemIndex = -1 then
  begin
    m_ReportSettings.BinFieldArrayReport[10].Field := CSC_NotSorted;
    iniAppGlobals.Field10BinColReportStatic := '';
  end
  else
  begin
    m_ReportSettings.BinFieldArrayReport[10].Field := BinColDefault[CBBinColumn10.ItemIndex].Field;
    m_ReportSettings.BinFieldArrayReport[10].pos := BinColDefault[CBBinColumn10.ItemIndex].pos;
    iniAppGlobals.Field10BinColReportStatic := IntToStr(BinColDefault[CBBinColumn10.ItemIndex].pos);
  end;

  m_ReportSettings.PrintComments    := CckBxPrintComments.Checked;
  try
    m_ReportSettings.ColumnComments := StrToInt(CmbBxColumn.Text);
  except m_ReportSettings.ColumnComments := 0;
  end;
  if (m_ReportSettings.ColumnComments < 1) or (m_ReportSettings.ColumnComments > 99)
    then m_ReportSettings.ColumnComments := 1;

  if m_ReportSettings.IsBinReport then
  begin
    try
      m_ReportSettings.GroupingFields := StrToInt(ComBoxSortCrits.Text);
    except m_ReportSettings.GroupingFields := 0;
    end;
    if (m_ReportSettings.GroupingFields < 0) or (m_ReportSettings.GroupingFields > 4)
      then m_ReportSettings.GroupingFields := 0;
  end
  else m_ReportSettings.GroupingFields := -1;
  m_ReportSettings.ShowGroups       := CBGroups.Checked;


  if not m_ReportSettings.IsPeriodMachineReport then
  begin
    if ((m_ReportSettings.IsBinReport) and (BinExtractionReport(m_ReportSettings)))
      or ((not m_ReportSettings.IsBinReport) and (DynamicScheduleExport(m_ReportSettings, true)))
    then
      //ShowMessage(_('Excel Report saved'))
    else
      //ShowMessage(_('Report saving aborted'));
  end
  else
  begin

    m_ReportSettings.ReportType       := 'ExcelDailyMachine';

    // set default value ....
    m_ReportSettings.ShowBinCaption   := false;
    m_ReportSettings.ShowBinCaptionBinReport := false;
    m_ReportSettings.ShowCriteria     := false;
    m_ReportSettings.NewPagePerRes    := false;
    m_ReportSettings.IncDowntime      := false;
    m_ReportSettings.ShowUnschedJobs  := false;
    m_ReportSettings.IsExportReport   := false;
    m_ReportSettings.IsBinReport      := false;
    m_ReportSettings.PrintComments    := false;
    m_ReportSettings.ShowGroups       := false;
    m_ReportSettings.ShowResources    := false;

    m_ReportSettings.ShowExcel        := false;
    m_ReportSettings.BucketByShift    := false;
    m_ReportSettings.FixColumnsReport := false;
    m_ReportSettings.concatenation    := false;
    m_ReportSettings.HeadingConcatenation := false;
    m_ReportSettings.ShowColumnsCaptions    := false;
    m_ReportSettings.ShowColumnsCaptionsBinReport  := false;
    m_ReportSettings.ShowTotal       := false;


    // set relevant fileld for the report
    m_ReportSettings.IsBinReport := true;
    m_ReportSettings.FixColumnsReport := true;
    m_ReportSettings.ShowColumnsCaptions := true;
    m_ReportSettings.ShowColumnsCaptionsBinReport := true;
    m_ReportSettings.ShowResources    := true;
    m_ReportSettings.IncDowntime      := false;
    m_ReportSettings.ShowUnschedJobs  := false;
    m_ReportSettings.NewPagePerRes    := true;
    m_ReportSettings.IsExportReport   := true;

    m_ReportSettings.MachineReportPeriodTitle := EditPeriodMachineTitle.text;
    iniAppGlobals.MachineReportPeriodTitle := EditPeriodMachineTitle.text;
    m_ReportSettings.IsBinReport := true;

    if CBoxPeriod.ItemIndex = 0 then
    begin
      iniAppGlobals.MachineReportPeriod := '1';
      m_ReportSettings.MachineReportPeriod := '1'
    end
    else if CBoxPeriod.ItemIndex = 1 then
    begin
      iniAppGlobals.MachineReportPeriod := '2';
      m_ReportSettings.MachineReportPeriod := '2'
    end
    else if CBoxPeriod.ItemIndex = 2 then
    begin
      iniAppGlobals.MachineReportPeriod := '3';
      m_ReportSettings.MachineReportPeriod := '3'
    end;

    if CBoxFrom.ItemIndex = 0 then
    begin
      iniAppGlobals.MachineReportPeriodFrom := '1';
      m_ReportSettings.MachineReportPeriodFrom := '1';
    end
    else if CBoxFrom.ItemIndex = 1 then
    begin
      iniAppGlobals.MachineReportPeriodFrom := '2';
      m_ReportSettings.MachineReportPeriodFrom := '2';
    end;

    if Trim(EditNumberOfPeriods.Text) <> '' then
    begin
      iniAppGlobals.MachineReportPeriodNum := EditNumberOfPeriods.Text;
      m_ReportSettings.MachineReportNumPeriod := EditNumberOfPeriods.Text
    end;

    if Trim(EditTodayMinusDays.Text) <> '' then
    begin
      iniAppGlobals.MachineReportDaysMinusDoday := EditTodayMinusDays.Text;
      m_ReportSettings.MachineReportEditTodayMinusDays := EditTodayMinusDays.Text
    end;

    if CBShowFromTo.Checked then
    begin
      m_ReportSettings.MachineReportShowFromToHeader := true;
      iniAppGlobals.MachineReportShowFromToHeader := '1'
    end
    else
    begin
      m_ReportSettings.MachineReportShowFromToHeader := false;
      iniAppGlobals.MachineReportShowFromToHeader := '0'
    end;

 //   iniAppGlobals.MachineReportFileNameAutoOperation := EditMachinePeriodFileName.Text;
    m_ReportSettings.ChkLstBoxRsc := TCheckListBox.create(self);
    m_ReportSettings.ChkLstBoxRsc.Parent := self;
    m_ReportSettings.ChkLstBoxRsc.Visible := false;
    for I := 0 to FMQMPlan.GetActiveTab.p_ganttPanel.p_VisResList.Count - 1 do
    begin
      VisRes := TMqmVisibleRes(FMQMPlan.GetActiveTab.p_ganttPanel.p_VisResList[i]);
      m_ReportSettings.ChkLstBoxRsc.Items.Add(TMqmRes(VisRes.p_Father).p_ResCode);
      m_ReportSettings.ChkLstBoxRsc.Checked[I] := true;
    end;

    result := PeriodMachineReport(m_ReportSettings, true);
    begin
    end;

  end;

  m_ReportSettings.NativeExcel.Free;

end;

//----------------------------------------------------------------------------//

procedure TFExcelReport.BtnSaveClick(Sender: TObject);
var
  saveDialog : TSaveDialog;
  I : Integer;
  VisRes : TMqmVisibleRes;
  Save_Cursor : TCursor;
begin
  ModalResult := mrOk;

  m_ReportSettings.FixColumnsReport := false;
  if (m_ReportSettings.BinFieldArrayReport[1].Field = CSC_NotSorted) or
     (m_ReportSettings.BinFieldArrayReport[2].Field = CSC_NotSorted) or
     (m_ReportSettings.BinFieldArrayReport[3].Field = CSC_NotSorted) or
     (m_ReportSettings.BinFieldArrayReport[4].Field = CSC_NotSorted) or
     (m_ReportSettings.BinFieldArrayReport[5].Field = CSC_NotSorted) or
     (m_ReportSettings.BinFieldArrayReport[6].Field = CSC_NotSorted) or
     (m_ReportSettings.BinFieldArrayReport[7].Field = CSC_NotSorted) or
     (m_ReportSettings.BinFieldArrayReport[8].Field = CSC_NotSorted) or
     (m_ReportSettings.BinFieldArrayReport[9].Field = CSC_NotSorted) or
     (m_ReportSettings.BinFieldArrayReport[10].Field = CSC_NotSorted) then
    m_ReportSettings.FixColumnsReport := true;

  if IsAutoRunMode then
  begin
    Save_Cursor   := Screen.Cursor;
    Screen.Cursor  := crUpArrow;
    m_ReportCreated := SavedAsAutoRunMode;
    Screen.Cursor := Save_Cursor;
    Exit;
  end;

  saveDialog := TSaveDialog.Create(self);
  saveDialog.Title := _('Save Excel Report as') + ':';
  saveDialog.InitialDir := GetCurrentDir;

  if CheckIfExcelInstalled then
  begin
    saveDialog.Filter := 'Microsoft Excel Worksheet|*.xlsx|Microsoft Excel 97-2003 Worksheet|*.xls';
    saveDialog.DefaultExt := 'xlsx';
  end else
  begin
    saveDialog.Filter := 'Microsoft Excel 97-2003 Worksheet|*.xls';
    saveDialog.DefaultExt := 'xls';
  end;

  saveDialog.FilterIndex := 1;

  if saveDialog.Execute then
  begin
    Save_Cursor   := Screen.Cursor;
    Screen.Cursor  := crUpArrow;
    m_ReportSettings.SaveFileLocation := saveDialog.FileName;
    m_ReportSettings.NativeExcel      := TmxNativeExcel.Create(self);
    m_ReportSettings.ReportType       := 'Excel';
  //  m_ReportSettings.IsBinReport      := not CBDowntime.Visible;
    m_ReportSettings.ShowColumnsCaptions  := CBShowColumnsCaptions.Checked;
    m_ReportSettings.ShowTotal            := CBShowTotal.Checked;
    m_ReportSettings.ShowCriteria     := CBSelection.Checked;
    m_ReportSettings.ShowResources    := CBResources.Checked;
    m_ReportSettings.IncDowntime      := CBDowntime.Checked;
    m_ReportSettings.ShowUnschedJobs  := CBUnschedJobs.Checked;
    m_ReportSettings.NewPagePerRes    := CBNewPagePerRes.Checked;
    m_ReportSettings.IsExportReport   := true;
    if m_ReportSettings.IsBinReport then
    begin
      m_ReportSettings.ExcelTitleBinReport := EditTitle.Text;
      if CBShowColumnsCaptions.Checked then
      begin
        iniAppGlobals.ShowColumnCaptionsBinReport  := '1';
        m_ReportSettings.ShowBinCaptionBinReport := true
      end
      else
      begin
        iniAppGlobals.ShowColumnCaptionsBinReport  := '0';
        m_ReportSettings.ShowBinCaptionBinReport := false
      end;
    end
    else
    begin
      m_ReportSettings.ExcelTitle := EditTitle.Text;
      if CBShowColumnsCaptions.Checked then
        iniAppGlobals.ShowColumnCaptionsReport  := '1'
      else
        iniAppGlobals.ShowColumnCaptionsReport  := '0';
    end;

    if CBContcatenation.Checked then
    begin
      iniAppGlobals.Concatenation       := '1';
      m_ReportSettings.Concatenation := true
    end
    else
    begin
      iniAppGlobals.Concatenation       := '0';
      m_ReportSettings.Concatenation := false
    end;

    if CBHeadingConcatenation.Checked then
    begin
      iniAppGlobals.HeadingConcatination       := '1';
      m_ReportSettings.HeadingConcatenation := true
    end
    else
    begin
      iniAppGlobals.HeadingConcatination       := '0';
      m_ReportSettings.HeadingConcatenation := false
    end;

//    m_ReportSettings.Concatenation    := CBContcatenation.Checked;
    iniAppGlobals.Separator           := EditSeparator.text;
    m_ReportSettings.Separator        := EditSeparator.text;

    iniAppGlobals.HeadingSeparator    := EditHeadingSeparator.text;
    m_ReportSettings.HeadingSeparator := EditHeadingSeparator.text;


    if CBShowTotal.Checked then
      iniAppGlobals.ShowTotalReport  := '1'
    else
      iniAppGlobals.ShowTotalReport  := '0';

    if CBBinColumn1.ItemIndex = -1 then
    begin
      m_ReportSettings.BinFieldArrayReport[1].Field := CSC_NotSorted;
      iniAppGlobals.Field1BinColReportStatic := '';
    end
    else
    begin
      m_ReportSettings.BinFieldArrayReport[1].Field := BinColDefault[CBBinColumn1.ItemIndex].Field;
      m_ReportSettings.BinFieldArrayReport[1].pos := BinColDefault[CBBinColumn1.ItemIndex].pos;
     // m_ReportSettings.BinFieldArrayReport[1].pos := BinColDefault[CBBinColumn1.ItemIndex].pos;
      iniAppGlobals.Field1BinColReportStatic := IntToStr(BinColDefault[CBBinColumn1.ItemIndex].pos);
    end;

    if CBBinColumn2.ItemIndex = -1 then
    begin
      m_ReportSettings.BinFieldArrayReport[2].Field := CSC_NotSorted;
      iniAppGlobals.Field2BinColReportStatic := '';
    end
    else
    begin
      m_ReportSettings.BinFieldArrayReport[2].Field := BinColDefault[CBBinColumn2.ItemIndex].Field;
      m_ReportSettings.BinFieldArrayReport[2].pos := BinColDefault[CBBinColumn2.ItemIndex].pos;
      iniAppGlobals.Field2BinColReportStatic := IntToStr(BinColDefault[CBBinColumn2.ItemIndex].pos);
    end;

    if CBBinColumn3.ItemIndex = -1 then
    begin
      m_ReportSettings.BinFieldArrayReport[3].Field := CSC_NotSorted;
      iniAppGlobals.Field3BinColReportStatic := '';
    end
    else
    begin
      m_ReportSettings.BinFieldArrayReport[3].Field := BinColDefault[CBBinColumn3.ItemIndex].Field;
      m_ReportSettings.BinFieldArrayReport[3].pos := BinColDefault[CBBinColumn3.ItemIndex].pos;
      iniAppGlobals.Field3BinColReportStatic := IntToStr(BinColDefault[CBBinColumn3.ItemIndex].pos);
    end;

    if CBBinColumn4.ItemIndex = -1 then
    begin
      m_ReportSettings.BinFieldArrayReport[4].Field := CSC_NotSorted;
      iniAppGlobals.Field4BinColReportStatic := '';
    end
    else
    begin
      m_ReportSettings.BinFieldArrayReport[4].Field := BinColDefault[CBBinColumn4.ItemIndex].Field;
      m_ReportSettings.BinFieldArrayReport[4].pos := BinColDefault[CBBinColumn4.ItemIndex].pos;
      iniAppGlobals.Field4BinColReportStatic := IntToStr(BinColDefault[CBBinColumn4.ItemIndex].pos);
    end;

    if CBBinColumn5.ItemIndex = -1 then
    begin
      m_ReportSettings.BinFieldArrayReport[5].Field := CSC_NotSorted;
      iniAppGlobals.Field5BinColReportStatic := '';
    end
    else
    begin
      m_ReportSettings.BinFieldArrayReport[5].Field := BinColDefault[CBBinColumn5.ItemIndex].Field;
      m_ReportSettings.BinFieldArrayReport[5].pos := BinColDefault[CBBinColumn5.ItemIndex].pos;
      iniAppGlobals.Field5BinColReportStatic := IntToStr(BinColDefault[CBBinColumn5.ItemIndex].pos);
    end;

    if CBBinColumn6.ItemIndex = -1 then
    begin
      m_ReportSettings.BinFieldArrayReport[6].Field := CSC_NotSorted;
      iniAppGlobals.Field6BinColReportStatic := '';
    end
    else
    begin
      m_ReportSettings.BinFieldArrayReport[6].Field := BinColDefault[CBBinColumn6.ItemIndex].Field;
      m_ReportSettings.BinFieldArrayReport[6].pos := BinColDefault[CBBinColumn6.ItemIndex].pos;
      iniAppGlobals.Field6BinColReportStatic := IntToStr(BinColDefault[CBBinColumn6.ItemIndex].pos);
    end;

    if CBBinColumn7.ItemIndex = -1 then
    begin
      m_ReportSettings.BinFieldArrayReport[7].Field := CSC_NotSorted;
      iniAppGlobals.Field7BinColReportStatic := '';
    end
    else
    begin
      m_ReportSettings.BinFieldArrayReport[7].Field := BinColDefault[CBBinColumn7.ItemIndex].Field;
      m_ReportSettings.BinFieldArrayReport[7].pos := BinColDefault[CBBinColumn7.ItemIndex].pos;
      iniAppGlobals.Field7BinColReportStatic := IntToStr(BinColDefault[CBBinColumn7.ItemIndex].pos);
    end;

    if CBBinColumn8.ItemIndex = -1 then
    begin
      m_ReportSettings.BinFieldArrayReport[8].Field := CSC_NotSorted;
      iniAppGlobals.Field8BinColReportStatic := '';
    end
    else
    begin
      m_ReportSettings.BinFieldArrayReport[8].Field := BinColDefault[CBBinColumn8.ItemIndex].Field;
      m_ReportSettings.BinFieldArrayReport[8].pos := BinColDefault[CBBinColumn8.ItemIndex].pos;
      iniAppGlobals.Field8BinColReportStatic := IntToStr(BinColDefault[CBBinColumn8.ItemIndex].pos);
    end;

    if CBBinColumn9.ItemIndex = -1 then
    begin
      m_ReportSettings.BinFieldArrayReport[9].Field := CSC_NotSorted;
      iniAppGlobals.Field9BinColReportStatic := '';
    end
    else
    begin
      m_ReportSettings.BinFieldArrayReport[9].Field := BinColDefault[CBBinColumn9.ItemIndex].Field;
      m_ReportSettings.BinFieldArrayReport[9].pos := BinColDefault[CBBinColumn9.ItemIndex].pos;
      iniAppGlobals.Field9BinColReportStatic := IntToStr(BinColDefault[CBBinColumn9.ItemIndex].pos);
    end;

    if CBBinColumn10.ItemIndex = -1 then
    begin
      m_ReportSettings.BinFieldArrayReport[10].Field := CSC_NotSorted;
      iniAppGlobals.Field10BinColReportStatic := '';
    end
    else
    begin
      m_ReportSettings.BinFieldArrayReport[10].Field := BinColDefault[CBBinColumn10.ItemIndex].Field;
      m_ReportSettings.BinFieldArrayReport[10].pos := BinColDefault[CBBinColumn10.ItemIndex].pos;
      iniAppGlobals.Field10BinColReportStatic := IntToStr(BinColDefault[CBBinColumn10.ItemIndex].pos);
    end;

    m_ReportSettings.PrintComments    := CckBxPrintComments.Checked;
    try
      m_ReportSettings.ColumnComments := StrToInt(CmbBxColumn.Text);
    except m_ReportSettings.ColumnComments := 0;
    end;
    if (m_ReportSettings.ColumnComments < 1) or (m_ReportSettings.ColumnComments > 99)
      then m_ReportSettings.ColumnComments := 1;

    if m_ReportSettings.IsBinReport then
    begin
      try
        m_ReportSettings.GroupingFields := StrToInt(ComBoxSortCrits.Text);
      except m_ReportSettings.GroupingFields := 0;
      end;
      if (m_ReportSettings.GroupingFields < 0) or (m_ReportSettings.GroupingFields > 4)
        then m_ReportSettings.GroupingFields := 0;
    end
    else m_ReportSettings.GroupingFields := -1;
    m_ReportSettings.ShowGroups       := CBGroups.Checked;


    if not m_ReportSettings.IsPeriodMachineReport then
    begin
      if ((m_ReportSettings.IsBinReport) and (BinExtractionReport(m_ReportSettings)))
        or ((not m_ReportSettings.IsBinReport) and (DynamicScheduleExport(m_ReportSettings, true)))
      then
        ShowMessage(_('Excel Report saved'))
      else
        ShowMessage(_('Report saving aborted'));
    end
    else
    begin

      m_ReportSettings.ReportType       := 'ExcelDailyMachine';

      // set default value ....
      m_ReportSettings.ShowBinCaption   := false;
      m_ReportSettings.ShowBinCaptionBinReport := false;
      m_ReportSettings.ShowCriteria     := false;
      m_ReportSettings.NewPagePerRes    := false;
      m_ReportSettings.IncDowntime      := false;
      m_ReportSettings.ShowUnschedJobs  := false;
      m_ReportSettings.IsExportReport   := false;
      m_ReportSettings.IsBinReport      := false;
      m_ReportSettings.PrintComments    := false;
      m_ReportSettings.ShowGroups       := false;
      m_ReportSettings.ShowResources    := false;

      m_ReportSettings.ShowExcel        := false;
      m_ReportSettings.BucketByShift    := false;
      m_ReportSettings.FixColumnsReport := false;
      m_ReportSettings.concatenation    := false;
      m_ReportSettings.HeadingConcatenation := false;
      m_ReportSettings.ShowColumnsCaptions    := false;
      m_ReportSettings.ShowColumnsCaptionsBinReport  := false;
      m_ReportSettings.ShowTotal       := false;


      // set relevant fileld for the report
      m_ReportSettings.IsBinReport := true;
      m_ReportSettings.FixColumnsReport := true;
      m_ReportSettings.ShowColumnsCaptions := true;
      m_ReportSettings.ShowColumnsCaptionsBinReport := true;
      m_ReportSettings.ShowResources    := true;
      m_ReportSettings.IncDowntime      := false;
      m_ReportSettings.ShowUnschedJobs  := false;
      m_ReportSettings.NewPagePerRes    := true;
      m_ReportSettings.IsExportReport   := true;

      m_ReportSettings.MachineReportPeriodTitle := EditPeriodMachineTitle.text;
      iniAppGlobals.MachineReportPeriodTitle := EditPeriodMachineTitle.text;
      m_ReportSettings.IsBinReport := true;

      if CBoxPeriod.ItemIndex = 0 then
      begin
        iniAppGlobals.MachineReportPeriod := '1';
        m_ReportSettings.MachineReportPeriod := '1'
      end
      else if CBoxPeriod.ItemIndex = 1 then
      begin
        iniAppGlobals.MachineReportPeriod := '2';
        m_ReportSettings.MachineReportPeriod := '2'
      end
      else if CBoxPeriod.ItemIndex = 2 then
      begin
        iniAppGlobals.MachineReportPeriod := '3';
        m_ReportSettings.MachineReportPeriod := '3'
      end;

      if CBoxFrom.ItemIndex = 0 then
      begin
        iniAppGlobals.MachineReportPeriodFrom := '1';
        m_ReportSettings.MachineReportPeriodFrom := '1';
      end
      else if CBoxFrom.ItemIndex = 1 then
      begin
        iniAppGlobals.MachineReportPeriodFrom := '2';
        m_ReportSettings.MachineReportPeriodFrom := '2';
      end;

      if Trim(EditNumberOfPeriods.Text) <> '' then
      begin
        iniAppGlobals.MachineReportPeriodNum := EditNumberOfPeriods.Text;
        m_ReportSettings.MachineReportNumPeriod := EditNumberOfPeriods.Text
      end;

      if Trim(EditTodayMinusDays.Text) <> '' then
      begin
        iniAppGlobals.MachineReportDaysMinusDoday := EditTodayMinusDays.Text;
        m_ReportSettings.MachineReportEditTodayMinusDays := EditTodayMinusDays.Text
      end;

      if CBShowFromTo.Checked then
      begin
        m_ReportSettings.MachineReportShowFromToHeader := true;
        iniAppGlobals.MachineReportShowFromToHeader := '1'
      end
      else
      begin
        m_ReportSettings.MachineReportShowFromToHeader := false;
        iniAppGlobals.MachineReportShowFromToHeader := '0'
      end;

    //  iniAppGlobals.MachineReportFileNameAutoOperation := EditMachinePeriodFileName.Text;
      m_ReportSettings.ChkLstBoxRsc := TCheckListBox.create(self);
      m_ReportSettings.ChkLstBoxRsc.Parent := self;
      m_ReportSettings.ChkLstBoxRsc.Visible := false;
      for I := 0 to FMQMPlan.GetActiveTab.p_ganttPanel.p_VisResList.Count - 1 do
      begin
        VisRes := TMqmVisibleRes(FMQMPlan.GetActiveTab.p_ganttPanel.p_VisResList[i]);
        m_ReportSettings.ChkLstBoxRsc.Items.Add(TMqmRes(VisRes.p_Father).p_ResCode);
        m_ReportSettings.ChkLstBoxRsc.Checked[I] := true;
      end;

      if PeriodMachineReport(m_ReportSettings, true) then
      begin
        ShowMessage(_('Excel Report saved'))
      end;

    end;

    m_ReportSettings.NativeExcel.Free;
  end
  else
    ShowMessage(_('Saving file was cancelled'));
  saveDialog.Free;

  Screen.Cursor := Save_Cursor;
end;

//----------------------------------------------------------------------------//
{ Save MQM-INI file and close form }
//----------------------------------------------------------------------------//

procedure TFExcelReport.BitOkClick(Sender: TObject);
begin
  ModalResult := mrOk;

  if ComBoAttribute.ItemIndex < 1 then
    iniAppGlobals.SelectedAtibute := ''
  else
  begin
    case ComBoAttribute.ItemIndex of
      1 : iniAppGlobals.SelectedAtibute := 'EditTitle';
      2 : iniAppGlobals.SelectedAtibute := 'CBNewPagePerRes';
      3 : iniAppGlobals.SelectedAtibute := 'CBBinCaption';
      4 : iniAppGlobals.SelectedAtibute := 'CBResources';
      5 : iniAppGlobals.SelectedAtibute := 'CBShowColumnsCaptions';
      6 : iniAppGlobals.SelectedAtibute := 'CBSelection';
      7 : iniAppGlobals.SelectedAtibute := 'CBDowntime';
      8 : iniAppGlobals.SelectedAtibute := 'CBShowTotal';
      9 : iniAppGlobals.SelectedAtibute := 'CckBxPrintComments';
      10 : iniAppGlobals.SelectedAtibute := 'LblColumn';
      11 : iniAppGlobals.SelectedAtibute := 'GBConcatenation';
      12 : iniAppGlobals.SelectedAtibute := 'EditSeparator';
      13 : iniAppGlobals.SelectedAtibute := 'GBHeadingConcatenation';
      14 : iniAppGlobals.SelectedAtibute := 'EditHeadingSeparator';
    end;
  end;

  if CBBinColumn1.ItemIndex = -1 then
  begin
    m_ReportSettings.BinFieldArrayReport[1].Field := CSC_NotSorted;
    iniAppGlobals.Field1BinColReportStatic := '';
  end
  else
  begin
    m_ReportSettings.BinFieldArrayReport[1].Field := BinColDefault[CBBinColumn1.ItemIndex].Field;
    m_ReportSettings.BinFieldArrayReport[1].pos := BinColDefault[CBBinColumn1.ItemIndex].pos;
   // m_ReportSettings.BinFieldArrayReport[1].pos := BinColDefault[CBBinColumn1.ItemIndex].pos;
    iniAppGlobals.Field1BinColReportStatic := IntToStr(BinColDefault[CBBinColumn1.ItemIndex].pos);
  end;

  if CBBinColumn2.ItemIndex = -1 then
  begin
    m_ReportSettings.BinFieldArrayReport[2].Field := CSC_NotSorted;
    iniAppGlobals.Field2BinColReportStatic := '';
  end
  else
  begin
    m_ReportSettings.BinFieldArrayReport[2].Field := BinColDefault[CBBinColumn2.ItemIndex].Field;
    m_ReportSettings.BinFieldArrayReport[2].pos := BinColDefault[CBBinColumn2.ItemIndex].pos;
    iniAppGlobals.Field2BinColReportStatic := IntToStr(BinColDefault[CBBinColumn2.ItemIndex].pos);
  end;

  if CBBinColumn3.ItemIndex = -1 then
  begin
    m_ReportSettings.BinFieldArrayReport[3].Field := CSC_NotSorted;
    iniAppGlobals.Field3BinColReportStatic := '';
  end
  else
  begin
    m_ReportSettings.BinFieldArrayReport[3].Field := BinColDefault[CBBinColumn3.ItemIndex].Field;
    m_ReportSettings.BinFieldArrayReport[3].pos := BinColDefault[CBBinColumn3.ItemIndex].pos;
    iniAppGlobals.Field3BinColReportStatic := IntToStr(BinColDefault[CBBinColumn3.ItemIndex].pos);
  end;

  if CBBinColumn4.ItemIndex = -1 then
  begin
    m_ReportSettings.BinFieldArrayReport[4].Field := CSC_NotSorted;
    iniAppGlobals.Field4BinColReportStatic := '';
  end
  else
  begin
    m_ReportSettings.BinFieldArrayReport[4].Field := BinColDefault[CBBinColumn4.ItemIndex].Field;
    m_ReportSettings.BinFieldArrayReport[4].pos := BinColDefault[CBBinColumn4.ItemIndex].pos;
    iniAppGlobals.Field4BinColReportStatic := IntToStr(BinColDefault[CBBinColumn4.ItemIndex].pos);
  end;

  if CBBinColumn5.ItemIndex = -1 then
  begin
    m_ReportSettings.BinFieldArrayReport[5].Field := CSC_NotSorted;
    iniAppGlobals.Field5BinColReportStatic := '';
  end
  else
  begin
    m_ReportSettings.BinFieldArrayReport[5].Field := BinColDefault[CBBinColumn5.ItemIndex].Field;
    m_ReportSettings.BinFieldArrayReport[5].pos := BinColDefault[CBBinColumn5.ItemIndex].pos;
    iniAppGlobals.Field5BinColReportStatic := IntToStr(BinColDefault[CBBinColumn5.ItemIndex].pos);
  end;

  if CBBinColumn6.ItemIndex = -1 then
  begin
    m_ReportSettings.BinFieldArrayReport[6].Field := CSC_NotSorted;
    iniAppGlobals.Field6BinColReportStatic := '';
  end
  else
  begin
    m_ReportSettings.BinFieldArrayReport[6].Field := BinColDefault[CBBinColumn6.ItemIndex].Field;
    m_ReportSettings.BinFieldArrayReport[6].pos := BinColDefault[CBBinColumn6.ItemIndex].pos;
    iniAppGlobals.Field6BinColReportStatic := IntToStr(BinColDefault[CBBinColumn6.ItemIndex].pos);
  end;

  if CBBinColumn7.ItemIndex = -1 then
  begin
    m_ReportSettings.BinFieldArrayReport[7].Field := CSC_NotSorted;
    iniAppGlobals.Field7BinColReportStatic := '';
  end
  else
  begin
    m_ReportSettings.BinFieldArrayReport[7].Field := BinColDefault[CBBinColumn7.ItemIndex].Field;
    m_ReportSettings.BinFieldArrayReport[7].pos := BinColDefault[CBBinColumn7.ItemIndex].pos;
    iniAppGlobals.Field7BinColReportStatic := IntToStr(BinColDefault[CBBinColumn7.ItemIndex].pos);
  end;

  if CBBinColumn8.ItemIndex = -1 then
  begin
    m_ReportSettings.BinFieldArrayReport[8].Field := CSC_NotSorted;
    iniAppGlobals.Field8BinColReportStatic := '';
  end
  else
  begin
    m_ReportSettings.BinFieldArrayReport[8].Field := BinColDefault[CBBinColumn8.ItemIndex].Field;
    m_ReportSettings.BinFieldArrayReport[8].pos := BinColDefault[CBBinColumn8.ItemIndex].pos;
    iniAppGlobals.Field8BinColReportStatic := IntToStr(BinColDefault[CBBinColumn8.ItemIndex].pos);
  end;

  if CBBinColumn9.ItemIndex = -1 then
  begin
    m_ReportSettings.BinFieldArrayReport[9].Field := CSC_NotSorted;
    iniAppGlobals.Field9BinColReportStatic := '';
  end
  else
  begin
    m_ReportSettings.BinFieldArrayReport[9].Field := BinColDefault[CBBinColumn9.ItemIndex].Field;
    m_ReportSettings.BinFieldArrayReport[9].pos := BinColDefault[CBBinColumn9.ItemIndex].pos;
    iniAppGlobals.Field9BinColReportStatic := IntToStr(BinColDefault[CBBinColumn9.ItemIndex].pos);
  end;

  if CBBinColumn10.ItemIndex = -1 then
  begin
    m_ReportSettings.BinFieldArrayReport[10].Field := CSC_NotSorted;
    iniAppGlobals.Field10BinColReportStatic := '';
  end
  else
  begin
    m_ReportSettings.BinFieldArrayReport[10].Field := BinColDefault[CBBinColumn10.ItemIndex].Field;
    m_ReportSettings.BinFieldArrayReport[10].pos := BinColDefault[CBBinColumn10.ItemIndex].pos;
    iniAppGlobals.Field10BinColReportStatic := IntToStr(BinColDefault[CBBinColumn10.ItemIndex].pos);
  end;

end;

//----------------------------------------------------------------------------//

procedure TFExcelReport.BTnClearBinColumn1Click(Sender: TObject);
begin
  if (Sender as Tbutton).Name = 'BTnClearBinColumn1' then
  begin
    m_ReportSettings.BinFieldArrayReport[1].Field := CSC_NotSorted;
    iniAppGlobals.Field1BinColReportStatic := '';
    CBBinColumn1.ItemIndex := -1;
  end
  else if (Sender as Tbutton).Name = 'BTnClearBinColumn2' then
  begin
    m_ReportSettings.BinFieldArrayReport[2].Field := CSC_NotSorted;
    iniAppGlobals.Field2BinColReportStatic := '';
    CBBinColumn2.ItemIndex := -1;
  end
  else if (Sender as Tbutton).Name = 'BTnClearBinColumn3' then
  begin
    m_ReportSettings.BinFieldArrayReport[3].Field := CSC_NotSorted;
    iniAppGlobals.Field3BinColReportStatic := '';
    CBBinColumn3.ItemIndex := -1;
  end
  else if (Sender as Tbutton).Name = 'BTnClearBinColumn4' then
  begin
    m_ReportSettings.BinFieldArrayReport[4].Field := CSC_NotSorted;
    iniAppGlobals.Field4BinColReportStatic := '';
    CBBinColumn4.ItemIndex := -1;
  end
  else if (Sender as Tbutton).Name = 'BTnClearBinColumn5' then
  begin
    m_ReportSettings.BinFieldArrayReport[5].Field := CSC_NotSorted;
    iniAppGlobals.Field5BinColReportStatic := '';
    CBBinColumn5.ItemIndex := -1;
  end
  else if (Sender as Tbutton).Name = 'BTnClearBinColumn6' then
  begin
    m_ReportSettings.BinFieldArrayReport[6].Field := CSC_NotSorted;
    iniAppGlobals.Field6BinColReportStatic := '';
    CBBinColumn6.ItemIndex := -1;
  end
  else if (Sender as Tbutton).Name = 'BTnClearBinColumn7' then
  begin
    m_ReportSettings.BinFieldArrayReport[7].Field := CSC_NotSorted;
    iniAppGlobals.Field7BinColReportStatic := '';
    CBBinColumn7.ItemIndex := -1;
  end
  else if (Sender as Tbutton).Name = 'BTnClearBinColumn8' then
  begin
    m_ReportSettings.BinFieldArrayReport[8].Field := CSC_NotSorted;
    iniAppGlobals.Field8BinColReportStatic := '';
    CBBinColumn8.ItemIndex := -1;
  end
  else if (Sender as Tbutton).Name = 'BTnClearBinColumn9' then
  begin
    m_ReportSettings.BinFieldArrayReport[9].Field := CSC_NotSorted;
    iniAppGlobals.Field9BinColReportStatic := '';
    CBBinColumn9.ItemIndex := -1;
  end
  else if (Sender as Tbutton).Name = 'BTnClearBinColumn10' then
  begin
    m_ReportSettings.BinFieldArrayReport[10].Field := CSC_NotSorted;
    iniAppGlobals.Field10BinColReportStatic := '';
    CBBinColumn10.ItemIndex := -1;
  end

end;

//----------------------------------------------------------------------------//

procedure TFExcelReport.BtnCloseClick(Sender: TObject);
begin
//  GlobSaveIniValues;
  ComBoxSortCrits.Clear;
  Close;
end;

//----------------------------------------------------------------------------//
{ Checks whether entered value for number of sort criteria is between 0 and 4 }
//----------------------------------------------------------------------------//

procedure TFExcelReport.ComBoxSortCritsChange(Sender: TObject);
var i: Integer;
begin
  try
    i := StrToInt(ComBoxSortCrits.Text);
  except
    begin
      i := 0;
      ComBoxSortCrits.Text := IntToStr(i);
    end;
  end;
  if (i < 0) or (i > 4) then
  begin
    i := 0;
    ComBoxSortCrits.Text := IntToStr(i);
  end;
  iniAppGlobals.GroupingFields := IntToStr(i);
//  GlobSaveIniValues;
end;

//----------------------------------------------------------------------------//
{ Store changed Report Title }
//----------------------------------------------------------------------------//

procedure TFExcelReport.EditHeadingSeparatorChange(Sender: TObject);
begin
  iniAppGlobals.HeadingSeparator := EditHeadingSeparator.Text;
end;

//----------------------------------------------------------------------------//

procedure TFExcelReport.EditNumberOfPeriodsKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not ((CharInSet(Key, ['0'..'9'])) or (key = chr(vk_Back)) or (Key = chr(24))) then
    abort;
end;

//----------------------------------------------------------------------------//

procedure TFExcelReport.EditSeparatorChange(Sender: TObject);
begin
  iniAppGlobals.Separator := EditSeparator.Text;
end;

//----------------------------------------------------------------------------//

procedure TFExcelReport.EditSeparatorClick(Sender: TObject);
begin
//  iniAppGlobals.Separator := EditSeparator.Text;
end;

//----------------------------------------------------------------------------//

procedure TFExcelReport.EditTitleChange(Sender: TObject);
begin
  if m_ReportSettings.IsBinReport then
    iniAppGlobals.ExcelTitleBinReport := EditTitle.Text
  else
    iniAppGlobals.ExcelTitle := EditTitle.Text;
//  GlobSaveIniValues;
end;

//----------------------------------------------------------------------------//

procedure TFExcelReport.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  iniAppGlobals.MachineReportFileNameAutoOperation := EditMachinePeriodFileName.Text;
  GlobSaveIniReportValues;
end;

//----------------------------------------------------------------------------//

procedure TFExcelReport.FormCreate(Sender: TObject);
begin
  if IsSettingForm then
  begin
    Tabattributes.TabVisible := true;
    BtnSave.Visible := false;
    BitOk.Visible := true;
    BtnSave.Visible := false;
  end;

  ReShape(Self);
{  ReShape(btnSave);
  ReShape(btnClose);
  ReShape(BitOk);
  ReShape(BTnClearBinColumn1);
  ReShape(BTnClearBinColumn2);
  ReShape(BTnClearBinColumn3);
  ReShape(BTnClearBinColumn4);
  ReShape(BTnClearBinColumn5);
  ReShape(BTnClearBinColumn6);
  ReShape(BTnClearBinColumn7);
  ReShape(BTnClearBinColumn8);
  ReShape(BTnClearBinColumn9);
  ReShape(BTnClearBinColumn10); }

end;

//----------------------------------------------------------------------------//
{ Choice whether to show the Selection Criteria }
//----------------------------------------------------------------------------//

procedure TFExcelReport.CBSelectionClick(Sender: TObject);
begin
  if CBSelection.Checked then iniAppGlobals.ShowCriteria := '1'
  else iniAppGlobals.ShowCriteria := '0';
//  GlobSaveIniValues;
end;

//----------------------------------------------------------------------------//

procedure TFExcelReport.CBShowColumnsCaptionsClick(Sender: TObject);
begin
  if m_ReportSettings.IsBinReport then
  begin
    if CBShowColumnsCaptions.Checked then iniAppGlobals.ShowColumnCaptionsBinReport := '1'
      else iniAppGlobals.ShowColumnCaptionsBinReport := '0';
    m_ReportSettings.ShowColumnsCaptionsBinReport := iniAppGlobals.ShowColumnCaptionsBinReport = '1';
  end
  else
  begin
    if CBShowColumnsCaptions.Checked then iniAppGlobals.ShowColumnCaptionsReport := '1'
    else iniAppGlobals.ShowColumnCaptionsReport := '0';
    m_ReportSettings.ShowColumnsCaptions := iniAppGlobals.ShowColumnCaptionsReport = '1';
  end;
end;

//----------------------------------------------------------------------------//

procedure TFExcelReport.CBShowTotalClick(Sender: TObject);
begin
  if CBShowTotal.Checked then iniAppGlobals.ShowTotalReport := '1'
  else iniAppGlobals.ShowTotalReport := '0';
  m_ReportSettings.ShowTotal := iniAppGlobals.ShowTotalReport = '1';
end;

//----------------------------------------------------------------------------//
{ Choice whether to show the Bin Caption }
//----------------------------------------------------------------------------//

procedure TFExcelReport.CBBinCaptionClick(Sender: TObject);
begin
  if m_ReportSettings.IsBinReport then
  begin
   if CBBinCaption.Checked then iniAppGlobals.ShowBinCaptionBinReport := '1'
     else iniAppGlobals.ShowBinCaptionBinReport := '0';
  end
  else
  begin
   if CBBinCaption.Checked then iniAppGlobals.ShowBinCaption := '1'
     else iniAppGlobals.ShowBinCaption := '0';
  end;
//  GlobSaveIniValues;
end;

//----------------------------------------------------------------------------//

procedure TFExcelReport.CBContcatenationClick(Sender: TObject);
begin
  if CBContcatenation.Checked then iniAppGlobals.Concatenation := '1'
  else iniAppGlobals.Concatenation := '0';
  m_ReportSettings.concatenation := iniAppGlobals.Concatenation = '0';
end;

//----------------------------------------------------------------------------//
{ Choice whether to include Downtimes in Dynamic Schedule Report }
//----------------------------------------------------------------------------//

procedure TFExcelReport.CBDowntimeClick(Sender: TObject);
begin
  if CBDowntime.Checked then iniAppGlobals.IncDowntime := '1'
  else iniAppGlobals.IncDowntime := '0';
//  GlobSaveIniValues;
end;

//----------------------------------------------------------------------------//
{ Choice whether to insert a line break when another resource is adressed }
//----------------------------------------------------------------------------//

procedure TFExcelReport.CBGroupsClick(Sender: TObject);
begin
  if CBGroups.Checked then iniAppGlobals.ShowGroups := '1'
  else iniAppGlobals.ShowGroups := '0';
//  GlobSaveIniValues;
end;

//----------------------------------------------------------------------------//

procedure TFExcelReport.CBHeadingConcatenationClick(Sender: TObject);
begin
  if CBHeadingConcatenation.Checked then iniAppGlobals.HeadingConcatination := '1'
  else iniAppGlobals.HeadingConcatination := '0';
  m_ReportSettings.HeadingConcatenation := iniAppGlobals.HeadingConcatination = '1';
end;

//----------------------------------------------------------------------------//
{ Choice whether to insert a line break when another resource is adressed }
//----------------------------------------------------------------------------//

procedure TFExcelReport.CBNewPagePerResClick(Sender: TObject);
begin
  if m_ReportSettings.IsBinReport then exit;
  if CBNewPagePerRes.Checked then iniAppGlobals.PagePerResource := '1'
  else iniAppGlobals.PagePerResource := '0';


//  GlobSaveIniValues;
end;

procedure TFExcelReport.CBoxFromClick(Sender: TObject);
begin
  if CBoxPeriod.ItemIndex = 0 then
    CBoxFrom.ItemIndex := 0;

  if CBoxFrom.ItemIndex = 0 then
  begin
    LBLTodayMinusDays.Visible := true;
    EditTodayMinusDays.Visible := true;
  end
  else
  begin
    LBLTodayMinusDays.Visible := false;
    EditTodayMinusDays.Visible := false;
  end;
end;

procedure TFExcelReport.CBoxPeriodChange(Sender: TObject);
begin
  if CBoxPeriod.ItemIndex = 0 then
     CBoxFrom.ItemIndex := 0;
end;

//----------------------------------------------------------------------------//
{ Choice whether to include Unscheduled Jobs in Bin Extraction Report }
//----------------------------------------------------------------------------//

procedure TFExcelReport.CBUnschedJobsClick(Sender: TObject);
begin
  if CBUnschedJobs.Checked then iniAppGlobals.ShowUnschedJobs := '1'
  else iniAppGlobals.ShowUnschedJobs := '0';
//  GlobSaveIniValues;
end;

//----------------------------------------------------------------------------//
{ Choice whether to include resource descriptions }
//----------------------------------------------------------------------------//

procedure TFExcelReport.CBResourcesClick(Sender: TObject);
begin
  if m_ReportSettings.IsBinReport then exit;
  if CBResources.Checked then iniAppGlobals.ShowResources := '1'
  else iniAppGlobals.ShowResources := '0';
//  GlobSaveIniValues;
end;

end.
// DIRK END


