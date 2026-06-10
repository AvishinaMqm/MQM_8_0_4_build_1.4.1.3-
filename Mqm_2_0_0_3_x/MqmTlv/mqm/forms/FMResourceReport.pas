unit FMResourceReport;

{ FMResourceReport prepares Excel and HTML exports for Dynamic/Fixed Schedule
  Reports. The report creation itself happens in UMReportExport. The user
  chooses a list of resources that is passed to UMReportExport(Fixed HTML
  Report), FMExcelReport(Dynamic Excel Report) or FMViewHtml(Dynamic HTML
  Report). }

interface

uses
  cxButtons, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CheckLst, ComCtrls, gnugettext, ExtCtrls, Buttons, UMReportExport, FMExcelReport, UReShape;

type
  TFResourceReport = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    ChkLstBoxRsc: TCheckListBox;
    ChkLstBoxWkc: TCheckListBox;
    DatePickerFromDate: TDateTimePicker;
    DatePickerToDate: TDateTimePicker;
    LbltoDate: TLabel;
    LblFromDate: TLabel;
    DateTimePicker_FromTime: TDateTimePicker;
    DateTimePicker_ToTime: TDateTimePicker;
    BtnCreate: TcxButton;
    BitClose: TcxButton;
    procedure ChkLstBoxWkcClickCheck(Sender: TObject);
    procedure BtnCreateClick(Sender: TObject);
    procedure ExcelSchedReport;
    procedure HtmlSchedReport;
    procedure HtmlReport;
    procedure ExcelFreeResReport;
    procedure BitCloseClick(Sender: TObject);
    procedure ViewReport(date_from, date_to: double);
    procedure FormShow(Sender: TObject);
//  private
  public
    constructor CreateResReport(AOwner : TComponent; Kind: String; ActWcList : TList);
    constructor CreateFreeResReport(AOwner : TComponent; Kind: String; ActResList : TList; Dami : integer);
  end;

var
  FResourceReport: TFResourceReport;

implementation
 uses
  UMWkctr,
  UMRes,
  UMPlan,
  UMObjCont,
  UMActArea,
  UMSchedContFunc,
  UMschedCont,
  UMCommon,
  UMCompatSrv,
  UMCompat,
  FMViewHTML,
  FMMainPlan,
  mxNativeExcel,
  UMGlobal;
{$R *.DFM}

var
  KindOfReport: String;

//----------------------------------------------------------------------------//
{ Constructor of the form
  @Param Kind        Specifies which of the three Schedule Reports is chosen }
//----------------------------------------------------------------------------//

constructor TFResourceReport.CreateResReport(AOwner: TComponent; Kind: String; ActWcList : TList);
var
  i, j, Index : Integer;
  MqmWrkCtr : TMqmWrkCtr;
begin
  inherited Create(AOwner);
  TranslateComponent(self);
  KindOfReport := Kind;
  if KindOfReport = 'html' then
  begin
    Caption := _('HTML Resource Report');
    BtnCreate.Caption := _('Save');
  end
  else if KindOfReport = 'excel_sched' then
    Caption := _('Excel Resource Report')
  else if KindOfReport = 'html_sched' then
    Caption := _('HTML Schedule Report');

  // Fill form with work centers and resources
  for i := 0 to p_pl.p_WrkCtrsCount - 1 do
  begin
    ChkLstBoxWkc.Items.Add(TMqmWrkCtr(p_pl.p_WrkCtr[i]).p_WrkCtrCode);
    for j := 0 to TMqmWrkCtr(p_pl.p_WrkCtr[i]).p_ResCount - 1 do
      ChkLstBoxRsc.Items.Add(TMqmRes(TMqmWrkCtr(p_pl.p_WrkCtr[i]).p_Res[j]).p_ResCode)
  end;

  if assigned(ActWcList) then
    for I := 0 to ActWcList.Count - 1 do
    begin
      MqmWrkCtr := TMqmWrkCtr(ActWcList[I]);
      for J := 0 to MqmWrkCtr.p_ResCount - 1 do
      begin
        Index := ChkLstBoxRsc.Items.IndexOf(TMqmRes(MqmWrkCtr.p_Res[J]).p_ResCode);
        if Index > -1 then
          ChkLstBoxRsc.Checked[Index] := true;
      end;
    end;

  DatePickerFromDate.Date := now;
  DatePickerToDate.Date := now + 365;
  ReShape(self);
end;

//----------------------------------------------------------------------------//
{ Check/Uncheck resources in list if corresponding work center is (un)checked }
//----------------------------------------------------------------------------//

constructor TFResourceReport.CreateFreeResReport(AOwner : TComponent; Kind: String; ActResList : TList; Dami : integer);
var
  i, j, Index : Integer;
//  MqmWrkCtr : TMqmWrkCtr;
begin
  inherited Create(AOwner);
  TranslateComponent(self);
  KindOfReport := Kind;
  if KindOfReport = 'Free_Resource_Excel' then
    Caption := _('Excel Free Resource Report');

  for i := 0 to p_pl.p_WrkCtrsCount - 1 do
  begin
    ChkLstBoxWkc.Items.Add(TMqmWrkCtr(p_pl.p_WrkCtr[i]).p_WrkCtrCode);
    for j := 0 to TMqmWrkCtr(p_pl.p_WrkCtr[i]).p_ResCount - 1 do
      ChkLstBoxRsc.Items.Add(TMqmRes(TMqmWrkCtr(p_pl.p_WrkCtr[i]).p_Res[j]).p_ResCode)
  end;

  for J := 0 to ActResList.Count - 1 do
  begin
    Index := ChkLstBoxRsc.Items.IndexOf(TMqmRes(ActResList[J]).p_ResCode);
    if Index > -1 then
      ChkLstBoxRsc.Checked[Index] := true;
  end;

  DatePickerFromDate.Date := now;
  DatePickerToDate.Date := now + 3 * 30;
  ReShape(self);
end;

//----------------------------------------------------------------------------//

procedure TFResourceReport.ChkLstBoxWkcClickCheck(Sender: TObject);
var
  i,j,k : Integer;
begin
  for i := 0 to ChkLstBoxWkc.Count - 1 do
    for j := 0 to TMqmWrkCtr(p_pl.p_WrkCtr[i]).p_ResCount - 1 do
      for k := 0 to ChkLstBoxRsc.Count - 1 do
        if TMqmRes(TMqmWrkCtr(p_pl.p_WrkCtr[i]).p_Res[j]).p_ResCode = ChkLstBoxRsc.Items.Strings[k] then
          ChkLstBoxRsc.Checked[k] := ChkLstBoxWkc.Checked[i]
end;

//----------------------------------------------------------------------------//
{ Start preparing the report by choosing correct procedure }
//----------------------------------------------------------------------------//

procedure TFResourceReport.BtnCreateClick(Sender: TObject);
begin
  if KindOfReport = 'html_sched' then HtmlSchedReport
  else if KindOfReport = 'excel_sched' then ExcelSchedReport
  else if KindOfReport = 'html' then HtmlReport
  else if KindOfReport = 'Free_Resource_Excel' then ExcelFreeResReport;

end;

//----------------------------------------------------------------------------//
{ Prepare Dynamic Excel Schedule Report and pass settings to FMExcelReport }
//----------------------------------------------------------------------------//

procedure TFResourceReport.ExcelSchedReport;
var
  date_from,
  date_to,
  time_from,
  time_to        : Double;
  ReportSettings : TSettings;
  ReportForm: TFExcelReport;
begin
  date_from := Int(DatePickerFromDate.Date);
  date_to   := Int(DatePickerToDate.Date) ;
  time_from := frac(DateTimePicker_FromTime.Time);
  time_to   := frac(DateTimePicker_ToTime.Time);
  date_from := date_from + time_from;
  date_to   := date_to + time_to;
  ReportSettings.NativeExcel       := TmxNativeExcel.Create(self);
  ReportSettings.DateFrom          := date_from ;
  ReportSettings.DateTo            := date_to ;
  ReportSettings.ChkLstBoxRsc      := ChkLstBoxRsc;
  ReportSettings.ReportType        := 'Excel';
  ReportSettings.ExcelTitle        := iniAppGlobals.ExcelTitle;
  ReportSettings.GroupingFields    := -1;
  ReportSettings.JumpingFields     := -1;
  ReportSettings.ShowGroups        := false;
  ReportSettings.ShowResources     := iniAppGlobals.ShowResources = '1';
  ReportSettings.IsBinReport       := false;
  if ReportSettings.IsBinReport then
    ReportSettings.ShowBinCaptionBinReport := iniAppGlobals.ShowBinCaptionBinReport = '1'
  else
    ReportSettings.ShowBinCaption    := iniAppGlobals.ShowBinCaption = '1';
  ReportSettings.ShowCriteria      := iniAppGlobals.ShowCriteria = '1';
  ReportSettings.IncDowntime       := iniAppGlobals.IncDowntime = '1';
  ReportSettings.ShowUnschedJobs   := false;
  ReportSettings.IsExportReport    := true;
  ReportSettings.NewPagePerRes     := iniAppGlobals.PagePerResource = '1';

  if iniAppGlobals.Concatenation = '1' then
    ReportSettings.Concatenation    := true
  else
    ReportSettings.Concatenation    := false;

  ReportSettings.Separator        := iniAppGlobals.Separator;

  if iniAppGlobals.ShowColumnCaptionsReport = '1' then
    ReportSettings.ShowColumnsCaptions := true
  else
    ReportSettings.ShowColumnsCaptions := false;

  if iniAppGlobals.ShowTotalReport = '1' then
    ReportSettings.ShowTotal := true
  else
    ReportSettings.ShowTotal := false;

  if iniAppGlobals.HeadingConcatination = '1' then
    ReportSettings.HeadingConcatenation    := true
  else
    ReportSettings.HeadingConcatenation    := false;

  ReportSettings.HeadingSeparator        := iniAppGlobals.HeadingSeparator;
  ReportSettings.IsPeriodMachineReport := false;

  ReportForm := TFExcelReport.CreateExcelScheduled(self, ReportSettings, true);
  ReportForm.ShowModal;
  ReportForm.Free;
  ReportSettings.NativeExcel.Free;
end;

procedure TFResourceReport.FormShow(Sender: TObject);
begin

//  ReShape(BtnCreate);
//  ReShape(BitClose);
end;

//----------------------------------------------------------------------------//
{ Prepare Fixed HTML Schedule Report and pass settings to UMReportExport }
//----------------------------------------------------------------------------//

procedure TFResourceReport.HtmlReport;
var
  saveDialog : TSaveDialog;
  ReportSettings: TSettings;
begin
  saveDialog             := TSaveDialog.Create(self);
  saveDialog.Title       := _('Save resource report as') + ':';
  saveDialog.InitialDir  := GetCurrentDir;
  saveDialog.Filter      := 'Html file|*.html';
  saveDialog.DefaultExt  := 'html';
  saveDialog.FilterIndex := 1;
  if saveDialog.Execute then
  begin
    ReportSettings.SaveFileLocation := saveDialog.FileName;
    ReportSettings.DateFrom := DatePickerFromDate.Date;
    ReportSettings.DateTo := DatePickerToDate.Date;
    ReportSettings.ChkLstBoxRsc := ChkLstBoxRsc;
    PrintFixedResourceReport(ReportSettings);
    ShowMessage(_('HTML Resource Report completed'));
  end
  else ShowMessage(_('HTML Resource Report cancelled'));
  saveDialog.Free;
end;

//----------------------------------------------------------------------------//

procedure TFResourceReport.ExcelFreeResReport;
var
  saveDialog : TSaveDialog;
  ReportSettings: TSettings;
begin
  saveDialog             := TSaveDialog.Create(self);
  saveDialog.Title       := _('Save Excel Report as') + ':';
  saveDialog.InitialDir  := GetCurrentDir;
  saveDialog.Filter      := 'Excel file|*.xls';
  saveDialog.DefaultExt  := 'xls';
  saveDialog.FilterIndex := 1;
  if saveDialog.Execute then
  begin
    ReportSettings.NativeExcel      := TmxNativeExcel.Create(self);
    ReportSettings.SaveFileLocation := saveDialog.FileName;
    ReportSettings.DateFrom := trunc(DatePickerFromDate.Date) + frac(DateTimePicker_FromTime.Time);
    ReportSettings.DateTo := trunc(DatePickerToDate.Date) + frac(DateTimePicker_ToTime.Time);
    ReportSettings.ChkLstBoxRsc := ChkLstBoxRsc;
    ReportSettings.ReportType       := 'Free_Resource_Excel';
    if ExcelFreeResScheduleExport(ReportSettings) then
    ShowMessage(_('Excel Free Resource Report completed'));
  end
  else ShowMessage(_('Excel Free Resource Report cancelled'));
  saveDialog.Free;
end;

//----------------------------------------------------------------------------//
{ Prepare Dynamic HTML Schedule Report, create the temporary HTML report files
  in UMReportExport and finally start FMViewHtml. }
//----------------------------------------------------------------------------//

procedure TFResourceReport.HtmlSchedReport;
var
  date_from,
  date_to,
  time_from,
  time_to        : double;
  ReportSettings : TSettings;
begin
  date_from := Int(DatePickerFromDate.Date);
  date_to   := Int(DatePickerToDate.Date);
  time_from := frac(DateTimePicker_FromTime.Time);
  time_to   := frac(DateTimePicker_ToTime.Time);
  date_from := date_from + time_from;
  date_to   := date_to + time_to;
  ReportSettings.NativeExcel      := nil;
  ReportSettings.DateFrom         := date_from ;
  ReportSettings.DateTo           := date_to ;
  ReportSettings.SaveFileLocation := GetCurrentDir + SetBackslash + HTML_REPORT_FULL;
  ReportSettings.ChkLstBoxRsc     := ChkLstBoxRsc;
  ReportSettings.ReportType       := 'Html';
  ReportSettings.IsBinReport      := false;
  try
    ReportSettings.MaxRows        := StrToInt(iniAppGlobals.HtmlRowNum);
  except ReportSettings.MaxRows   := -1;
  end;
  if ReportSettings.MaxRows < 1 then ReportSettings.MaxRows := -1;
  ReportSettings.MaxCols          := -1;
  if ReportSettings.IsBinReport then
    ReportSettings.ShowBinCaptionBinReport := iniAppGlobals.ShowBinCaptionBinReport = '1'
  else
    ReportSettings.ShowBinCaption   := iniAppGlobals.ShowBinCaption = '1';
  ReportSettings.ShowCriteria     := iniAppGlobals.ShowCriteria = '1';
  ReportSettings.ShowResources    := iniAppGlobals.ShowResources = '1';
  ReportSettings.NewPagePerRes    := iniAppGlobals.PagePerResource = '1';
  ReportSettings.IncDowntime      := iniAppGlobals.IncDowntime = '1';
  ReportSettings.ShowUnschedJobs  := false;
  ReportSettings.Comment          := iniAppGlobals.ReportComment1;
  ReportSettings.IsExportReport   := false;
  ReportSettings.GroupingFields   := -1;
  ReportSettings.JumpingFields    := -1;
  ReportSettings.ShowGroups       := false;
  SetReportFonts(ReportSettings);
  // Create temporary HTML file(s) for FMViewHtml
  if DynamicScheduleExport(ReportSettings,true) then ViewReport(date_from, date_to);
end;

//----------------------------------------------------------------------------//
{ Save MQM-INI file and close form }
//----------------------------------------------------------------------------//

procedure TFResourceReport.BitCloseClick(Sender: TObject);
begin
  GlobSaveIniValues;
  Close;
end;

//----------------------------------------------------------------------------//
{ Starts FMViewHtml after being called by HtmlSchedReport }
//----------------------------------------------------------------------------//

procedure TFResourceReport.ViewReport(date_from, date_to: double);
var
  ReportForm: TFViewHtml;
begin
  ReportForm := TFViewHtml.CreateHtmlViewer(self, ChkLstBoxRsc, date_from, date_to, true, '');
  ReportForm.ShowModal;
end;

end.

