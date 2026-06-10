unit UMReports;

{ UMReports is the only interface between the MQM main program and requests for
  exporting Dynamic/Fixed Schedule Reports, Bin Extractions or Bucket Reports as
  HTML or Excel files. The procedures basically only open the correct forms in
  the units FMResourceReport, FMViewHtml, FMExcelReport and FMBucketReport. }

interface
uses Classes;

procedure HtmlDynamicScheduleReport(AOwner: TComponent; ActWcList : TList);
procedure HtmlBinExtraction(AOwner: TComponent; IsReportForm : boolean; StartDate : TDateTime; EndDate : TDateTime; DateFilter : Integer);
procedure ExcelDynamicScheduleReport(AOwner: TComponent; ActWcList : TList);
procedure ExcelDynamicScheduleFreeResource(AOwner: TComponent; ActResList : TList);
procedure ExcelBinExtraction(AOwner: TComponent);
procedure ExcelBucketReport(AOwner: TComponent);
procedure FixedScheduleReport(AOwner: TComponent; ActWcList : TList);
function  PeriodMachineReport(AOwner: TComponent) : boolean;
function  ReportCreated : boolean;
procedure GroupBucketReport(AOwner: TComponent);

implementation

uses SysUtils, Dialogs, gnugettext, FMResourceReport, FMViewHtml, FMExcelReport,
  FMBucketReport, FmAutoRunSet, Vcl.Forms, FMGroupBucket;

var
  m_ReportCreated : boolean;

//----------------------------------------------------------------------------//

procedure HtmlDynamicScheduleReport(AOwner: TComponent; ActWcList : TList);
var
  ResourceReport : TFResourceReport;
begin
  ResourceReport := TFResourceReport.CreateResReport(AOwner, 'html_sched', ActWcList);
  ResourceReport.ShowModal;
  ResourceReport.Free;
end;

//----------------------------------------------------------------------------//

procedure HtmlBinExtraction(AOwner: TComponent; IsReportForm : boolean; StartDate : TDateTime; EndDate : TDateTime; DateFilter : Integer);
var
  ReportForm: TFViewHtml;
  FormCaption : string;
begin
  if IsReportForm then
    FormCaption := _('HTML Bin Extraction Preview')
  else
    FormCaption := _('HTML Bin Extraction scheduled jobs');
  ReportForm := TFViewHtml.CreateHtmlExtractViewer(AOwner, FormCaption, IsReportForm,StartDate,EndDate, DateFilter);
  ReportForm.ShowModal;
  ReportForm.Free;
end;

//----------------------------------------------------------------------------//

procedure ExcelDynamicScheduleReport(AOwner: TComponent; ActWcList : TList);
var
  ResourceReport : TFResourceReport;
begin
  ResourceReport := TFResourceReport.CreateResReport(AOwner, 'excel_sched', ActWcList);
  ResourceReport.ShowModal;
  ResourceReport.Free;
end;

//----------------------------------------------------------------------------//

procedure ExcelDynamicScheduleFreeResource(AOwner: TComponent; ActResList : TList);
var
  ResourceReport : TFResourceReport;
begin
  ResourceReport := TFResourceReport.CreateFreeResReport(AOwner, 'Free_Resource_Excel', ActResList, 0);
  ResourceReport.ShowModal;
  ResourceReport.Free;
end;

//----------------------------------------------------------------------------//

procedure ExcelBinExtraction(AOwner: TComponent);
var
  ReportForm: TFExcelReport;
begin
  ReportForm := TFExcelReport.CreateExcelBinExtraction(AOwner, 0);
  ReportForm.ShowModal;
  ReportForm.Free;
end;

//----------------------------------------------------------------------------//

Procedure GroupBucketReport(AOwner: TComponent);
var FGroupBucket : TFGroupBucket;
begin

  FGroupBucket := TFGroupBucket.CreateFormAndReport(AOwner);
  FGroupBucket.ShowModal;
  FGroupBucket.Free;

end;

procedure ExcelBucketReport(AOwner: TComponent);
var
  BucketReport : TFBucketReport;
begin
  BucketReport := TFBucketReport.CreateBucketReport(AOwner, 'excel');
  BucketReport.ShowModal;
  BucketReport.Free;
end;

//----------------------------------------------------------------------------//

procedure FixedScheduleReport(AOwner: TComponent; ActWcList : TList);
var
  ResourceReport : TFResourceReport;
begin
  ResourceReport := TFResourceReport.CreateResReport(AOwner, 'excel_sched', nil);
  ResourceReport.ShowModal;
  ResourceReport.Free;
end;

//----------------------------------------------------------------------------//

function PeriodMachineReport(AOwner: TComponent) : boolean;
var
  ReportForm: TFExcelReport;
begin
  ReportForm := TFExcelReport.CreatePeriodMachineReport(AOwner);
  if not IsAutoRunMode then
    ReportForm.ShowModal
  else
  begin
    ReportForm.BtnSaveClick(Application);
    m_ReportCreated := ReportForm.m_ReportCreated;
  end;
  ReportForm.Free;
end;

//----------------------------------------------------------------------------//

function ReportCreated : boolean;
begin
  Result := m_ReportCreated
end;

end.
