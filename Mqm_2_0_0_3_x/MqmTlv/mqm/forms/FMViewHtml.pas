unit FMViewHtml;

{ FMViewHtml prepares HTML exports for Dynamic/Fixed Schedule Reports and Bin
  Extractions. The report creation itself happens in UMReportExport. The form
  especially allows defining splitting criteria(new HTML page per resource,
  maximum rows per page), printing, saving, setting up fonts and background
  colors, viewing the resulting HTML pages and specify whether to include
  Downtimes in statistics or Unscheduled Jobs. This unit also uses the unit
  FMReportHtmlBackColors. }

interface

uses
  cxButtons, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw, ExtCtrls, StdCtrls, Printers, gnugettext, CheckLst;

type
  TFViewHtml = class(TForm)
    Panel2: TPanel;
    BtnPrintPreview: TcxButton;
    BtnPrint: TcxButton;
    BtnPageSetup: TcxButton;
    BtnPrintAll: TcxButton;
    BtnSave: TcxButton;
    GroupBox1: TGroupBox;
    BtnPrevPage: TcxButton;
    BtnNextPage: TcxButton;
    BtnFirstPage: TcxButton;
    Label1: TLabel;
    EditRowsPerPage: TEdit;
    STCurrentPage: TStaticText;
    LblCurrentPage: TLabel;
    WebBrowser1: TWebBrowser;
    Panel1: TPanel;
    GroupBox2: TGroupBox;
    CBBinCaption: TCheckBox;
    CBSelection: TCheckBox;
    EditComment: TEdit;
    BtnRefresh: TcxButton;
    CBDowntime: TCheckBox;
    CBNewPagePerRes: TCheckBox;
    LabComment: TLabel;
    FontDialog1: TFontDialog;
    BtnFontBin: TcxButton;
    BtnFontCriteria: TcxButton;
    BtnFontComment: TcxButton;
    BtnFontColumns: TcxButton;
    BtnFontData: TcxButton;
    BtnLastPage: TcxButton;
    BtnBgColors: TcxButton;
    BtnClose: TcxButton;
    BtnPrColors: TcxButton;
    LabRedField: TLabel;
    CBUnschedJobs: TCheckBox;
    CBResources: TCheckBox;
    ComBoxSortCrits: TComboBox;
    LabGroupFields: TLabel;
    CBShowCrits: TCheckBox;
    LabJumpFields: TLabel;
    ComBoxJumps: TComboBox;

    constructor CreateHtmlViewer(AOwner: TComponent; ChkLstBoxRscT: TCheckListBox;
                                 DateFromT, DateToT: Double; IsReportForm : boolean; Desc : string);
    constructor CreateHtmlExtractViewer(AOwner: TComponent; FormCaption: string; IsReportForm : boolean; StartDate : TDateTime;
                                        EndDate : TDateTime; DateFilter : Integer);
    procedure LoadPage(URL: string);
    procedure BtnPageSetupClick(Sender: TObject);
    procedure BtnPrintClick(Sender: TObject);
    procedure BtnPrintPreviewClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure BtnPrevPageClick(Sender: TObject);
    procedure BtnNextPageClick(Sender: TObject);
    procedure EditRowsPerPageExit(Sender: TObject);
    procedure BtnPrintAllClick(Sender: TObject);
    procedure BtnFirstPageClick(Sender: TObject);
    procedure SetButtonStatus;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CBSelectionClick(Sender: TObject);
    procedure CBBinCaptionClick(Sender: TObject);
    procedure EditCommentExit(Sender: TObject);
    procedure BtnRefreshClick(Sender: TObject);
    procedure BtnFontBinClick(Sender: TObject);
    procedure BtnFontCriteriaClick(Sender: TObject);
    procedure BtnFontCommentClick(Sender: TObject);
    procedure BtnFontColumnsClick(Sender: TObject);
    procedure BtnFontDataClick(Sender: TObject);
    procedure CBNewPagePerResClick(Sender: TObject);
    procedure CBDowntimeClick(Sender: TObject);
    procedure BtnLastPageClick(Sender: TObject);
    procedure BtnBgColorsClick(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
    procedure BtnPrColorsClick(Sender: TObject);
    procedure CBUnschedJobsClick(Sender: TObject);
    procedure CBResourcesClick(Sender: TObject);
    procedure EditCommentChange(Sender: TObject);
    procedure ComBoxSortCritsChange(Sender: TObject);
    procedure CBShowCritsClick(Sender: TObject);
    procedure ComBoxJumpsChange(Sender: TObject);

  private
    procedure SetCaptions(FormCaption: string);
    procedure DeleteTempFiles;
  end;

var
  FViewHtml: TFViewHtml;

implementation

{$R *.dfm}
uses
  UMGlobal, Math, FMReportHtmlBackColors, UMReportExport, UMObjCont, UMWkctr, UMRes;
var
  ChkLstBoxRsc   : TCheckListBox;
  DateFrom,DateTo: Double;
  currentPage    : Integer;
  ViewSplit      : boolean;
  DoPrint        : boolean;
  CloseForm      : boolean;
  ColorMenu      : THtmlBackColors;

//----------------------------------------------------------------------------//
{ Constructor for a HTML Dynamic Schedule Report preview
  @param ChkLstBoxRscT     A list with all resources to analyse. This list was
                           created and passed by the unit FMResourceReport
  @param DateFromT         Start date of analysed period
  @param DateToT           End date of analysed period }
//----------------------------------------------------------------------------//

constructor TFViewHtml.CreateHtmlViewer(AOwner: TComponent; ChkLstBoxRscT: TCheckListBox;
                                        DateFromT, DateToT: Double; IsReportForm : boolean; Desc : string);
begin
  try
    inherited Create(Aowner);
    ChkLstBoxRsc  := ChkLstBoxRscT;
    DateFrom      := DateFromT;
    DateTo        := DateToT;
    currentPage   := 1;
    DoPrint       := false;
    if not IsReportForm then
    begin
      Panel1.Visible := false;
      Panel2.Visible := false;
      Desc := _('Scheduled jobs for resource') + ' : '  + '  ' + desc;
      SetCaptions(Desc);
    end
    else
      SetCaptions(_('HTML Dynamic Schedule Report Preview'));
    EditRowsPerPage.Text    := iniAppGlobals.HtmlRowNum;
    CBBinCaption.Checked    := iniAppGlobals.ShowBinCaption = '1';
    CBSelection.Checked     := iniAppGlobals.ShowCriteria = '1';
    CBResources.Checked     := iniAppGlobals.ShowResources = '1';
    CBNewPagePerRes.Checked := iniAppGlobals.PagePerResource = '1';
    CBDowntime.Checked      := iniAppGlobals.IncDowntime = '1';
    EditComment.Text        := iniAppGlobals.ReportComment1;
    ComBoxSortCrits.Visible := false;
    CBShowCrits.Visible     := false;
    ComBoxJumps.Visible     := false;
    ComBoxSortCrits.Text    := iniAppGlobals.GroupingFields;
    ComBoxJumps.Text        := iniAppGlobals.JumpingFields;
    CBShowCrits.Checked     := iniAppGlobals.ShowGroups = '1';
    LabGroupFields.Visible  := false;
    LabJumpFields.Visible   := false;
  //  Label1.Top              := 16;
  //  EditRowsPerPage.Top     := 40;
    LoadPage(GetCurrentDir + SetBackslash + HTML_REPORT_FULL);
    ViewSplit := (iniAppGlobals.HtmlRowNum <> '') or (iniAppGlobals.HtmlRowNum <> '0') or CBNewPagePerRes.Checked;
  except
    on e:Exception do MessageDlg('FMViewHtml - CreateHtmlViewer'+#13'Message: ' + e.Message, mtError, [mbOK], 0);
  end;
  LabRedField.Visible := false;
 // LabRedField.Width := 83;
 // LabRedField.Height := 32;
  SetButtonStatus;
  ColorMenu := nil;

  //ReShape(Self);
end;

//----------------------------------------------------------------------------//
{ Constructor for a HTML Bin Extraction Report preview
  @param FormCaption      Value for changing the caption of the form }
//----------------------------------------------------------------------------//

constructor TFViewHtml.CreateHtmlExtractViewer(AOwner: TComponent; FormCaption: string; IsReportForm : boolean;
                                               StartDate : TDateTime; EndDate : TDateTime; DateFilter : Integer);
var
  ReportSettings : TSettings;
begin
  try
    inherited Create(Aowner);
    ReportSettings.NativeExcel      := nil;

    if not IsReportForm then
    begin
      Panel1.Visible := false;
      Panel2.Visible := false;
    end;

    ReportSettings.SaveFileLocation := GetCurrentDir + SetBackslash + HTML_REPORT_FULL;
    ReportSettings.ReportType       := 'Html';
    ReportSettings.IsBinReport      := true;
    try
      ReportSettings.MaxRows        := StrToInt(iniAppGlobals.HtmlRowNum);
    except ReportSettings.MaxRows   := -1;
    end;
    if ReportSettings.MaxRows < 1 then ReportSettings.MaxRows := -1;
    ReportSettings.MaxCols          := -1;
    ReportSettings.ShowBinCaption   := iniAppGlobals.ShowBinCaption = '1';
    ReportSettings.ShowCriteria     := iniAppGlobals.ShowCriteria = '1';
    ReportSettings.ShowResources    := false;
    ReportSettings.NewPagePerRes    := false;
    ReportSettings.IncDowntime      := iniAppGlobals.IncDowntime = '1';
    ReportSettings.ShowUnschedJobs  := true;
    ReportSettings.ShowGroups       := iniAppGlobals.ShowGroups = '1';
    ReportSettings.Comment          := iniAppGlobals.ReportComment1;
    ReportSettings.IsExportReport   := false;
    try
      ReportSettings.GroupingFields := StrToInt(iniAppGlobals.GroupingFields);
    except ReportSettings.GroupingFields := 0;
    end;
    if (ReportSettings.GroupingFields < 0) or (ReportSettings.GroupingFields > 4)
    then ReportSettings.GroupingFields := 0;
    try
      ReportSettings.JumpingFields := StrToInt(iniAppGlobals.JumpingFields);
    except ReportSettings.JumpingFields := 0;
    end;
    if (ReportSettings.JumpingFields < 0) or (ReportSettings.JumpingFields > 4)
    then ReportSettings.JumpingFields := 0;
    if (ReportSettings.JumpingFields > ReportSettings.GroupingFields) then
      ReportSettings.JumpingFields := ReportSettings.GroupingFields;
    SetReportFonts(ReportSettings);
    // Create temporary Bin Extraction Report for showing in the Web Browser

    if IsReportForm then
      CloseForm := not BinExtractionReport(ReportSettings)
    else
      CloseForm := not ShowBinExtractionByDate(ReportSettings, StartDate, EndDate, DateFilter);

    SetCaptions(FormCaption);
    currentPage   := 1;
    DoPrint       := false;
  {  Label1.Top              := 16;
    EditRowsPerPage.Top     := 40;
    LabGroupFields.Left     := 125;
    ComBoxSortCrits.Left    := 265;
    LabGroupFields.Top      := 37;
    ComBoxSortCrits.Top     := 35;
    LabJumpFields.Top       := 59;
    ComBoxJumps.Top         := 57;  }
    EditRowsPerPage.Text    := IntToStr(ReportSettings.MaxRows);
    CBBinCaption.Checked    := ReportSettings.ShowBinCaption;
    CBSelection.Visible     := false;
    CBSelection.Checked     := false;
    CBResources.Visible     := false;
    CBResources.Checked     := ReportSettings.ShowResources;
    CBNewPagePerRes.Visible := false;
    CBNewPagePerRes.Checked := ReportSettings.NewPagePerRes;
    CBShowCrits.Checked     := ReportSettings.ShowGroups;
    CBDowntime.Checked      := false;
    CBDowntime.Visible      := false;
    EditComment.Text        := ReportSettings.Comment;
    ComBoxSortCrits.Text    := IntToStr(ReportSettings.GroupingFields);
    ComBoxJumps.Text        := IntToStr(ReportSettings.JumpingFields);
  //  CBShowCrits.Top := 16;
    ViewSplit := (ReportSettings.MaxRows <> -1) or ReportSettings.NewPagePerRes;
    CBUnschedJobs.Checked := ReportSettings.ShowUnschedJobs;
    ColorMenu := nil;
    if not CloseForm then
    begin
      LabRedField.Visible := false;
   //   LabRedField.Width := 83;
     // LabRedField.Height := 32;
      SetButtonStatus;
      LoadPage(ReportSettings.SaveFileLocation);
    end;
  except
    on e:Exception do MessageDlg('FMViewHtml - CreateHtmlExtractViewer'+#13'Message: ' + e.Message, mtError, [mbOK], 0);
  end;
  if CloseForm then begin
    LabRedField.Visible := true;
  //  LabRedField.Width := 83;
  //  LabRedField.Height := 32;
  //  LabRedField.Top := 44;
    CBBinCaption.Enabled := false;
    CBResources.Enabled := false;
    EditComment.Enabled := false;
    BtnFontBin.Enabled := false;
    BtnFontCriteria.Enabled := false;
    BtnFontComment.Enabled := false;
    BtnFontColumns.Enabled := false;
    BtnFontData.Enabled := false;
    BtnBgColors.Enabled := false;
    BtnPrColors.Enabled := false;
    BtnRefresh.Enabled := false;
    BtnNextPage.Enabled := false;
    BtnPrevPage.Enabled := false;
    BtnFirstPage.Enabled := false;
    BtnLastPage.Enabled := false;
    STCurrentPage.Caption := '';
    CBNewPagePerRes.Enabled := false;
    CBUnschedJobs.Enabled := false;
    EditRowsPerPage.Enabled := false;
    BtnPrint.Enabled := false;
    BtnPrintAll.Enabled := false;
    BtnPrintPreview.Enabled := false;
    BtnSave.Enabled := false;
    BtnPageSetup.Enabled := false;
    ComBoxSortCrits.Enabled := false;
    ComBoxJumps.Enabled := false;
    CBShowCrits.Enabled := false;
  end;

  //ReSHape(Self);
end;

//----------------------------------------------------------------------------//
{ Sets translated formular captions
  @param FormCaption       Formular caption given by constructors }
//----------------------------------------------------------------------------//

procedure TFViewHtml.SetCaptions(FormCaption: string);
begin
  Caption := FormCaption;
  BtnPrintPreview.Caption := _('Print preview');
  BtnPrintPreview.StyleName := 'LargeButton4.285x';
  BtnPrint.Caption := _('Print page');
  BtnPrint.StyleName := 'LargeButton4.285x';
  BtnPageSetup.Caption := _('Page setup');
  BtnPageSetup.StyleName := 'LargeButton4.285x';
  BtnPrintAll.Caption := _('Print all pages');
  BtnPrintAll.StyleName := 'LargeButton4.285x';
  BtnSave.Caption := _('Export as one page');
  BtnSave.StyleName := 'VLargeButton320x30';
  BtnPrevPage.Caption := _('Previous page');
  BtnPrevPage.StyleName := 'LargeButton4.285x';
  BtnNextPage.Caption := _('Next page');
  BtnNextPage.StyleName := 'LargeButton4.285x';
  BtnFirstPage.Caption := _('First page');
  BtnFirstPage.StyleName := 'VLargeButton320x30';
  BtnLastPage.Caption := _('Last page');
  BtnLastPage.StyleName := 'VLargeButton320x30';
  BtnFontBin.Caption := _('Font');
  BtnFontBin.StyleName := 'LargeButton4.285x';
  BtnFontCriteria.Caption := _('Font');
  BtnFontCriteria.StyleName := 'LargeButton4.285x';
  BtnFontComment.Caption := _('Font');
  BtnFontComment.StyleName := 'LargeButton4.285x';
  BtnFontColumns.Caption := _('Font Column Titles');
  BtnFontColumns.StyleName := 'VLargeButton320x30';
  BtnFontData.Caption := _('Font Data Lines');
  BtnFontData.StyleName := 'VLargeButton320x30';
  BtnBgColors.Caption := _('Background Colors');
  BtnBgColors.StyleName := 'VLargeButton320x30';
  BtnPrColors.Caption := _('Set Printer-friendly Colors');
  BtnPrColors.StyleName := 'VLargeButton320x30';
  BtnRefresh.Caption := _('Refresh');
  BtnRefresh.StyleName := 'VLargeButton320x30';
  BtnClose.Caption := _('Close');
  BtnClose.StyleName := 'LargeButton4.285x';
  Label1.Caption := _('Rows per split page');
  LabComment.Caption := _('Comment');
  GroupBox2.Caption := _('Font Settings');
  LabComment.Caption := _('Comment');
  LblCurrentPage.Caption := _('Current page');
  CBNewPagePerRes.Caption := _('New page for new resource');
  CBDowntime.Caption := _('Include Downtime in statistics');
  CBUnschedJobs.Caption := _('Include Unscheduled Jobs');
  CBBinCaption.Caption := _('Bin caption');
  CBResources.Caption := _('Resource in heading');
  CBSelection.Caption := _('Selection criteria');
  LabGroupFields.Caption := _('Sort fields to cause a break');
  LabJumpFields.Caption := _('Sort fields to change a page');
  CBShowCrits.Caption := _('Show sort field data');
end;

//----------------------------------------------------------------------------//
{ Loads the HTML file into the TWebBrowser on the form
  @param URL       The URL of the file to load }
//----------------------------------------------------------------------------//

procedure TFViewHtml.LoadPage(URL: string);
begin
  try
    WebBrowser1.Navigate(URL);
    SetButtonStatus;
  except
    on e:Exception do MessageDlg('FMViewHtml - LoadPage'+#13'Message: ' + e.Message, mtError, [mbOK], 0);
  end;
end;

//----------------------------------------------------------------------------//
{ Print directly without printer dialog
  @param WB      TWebBrowser object }
//----------------------------------------------------------------------------//

procedure WBPrintNoDialog(WB: TWebBrowser);
var
  vIn, vOut: OleVariant;
begin
  WB.ControlInterface.ExecWB(OLECMDID_PRINT, OLECMDEXECOPT_DONTPROMPTUSER, vIn, vOut) ;
end;

//----------------------------------------------------------------------------//
{ Click to print without a dialog }
//----------------------------------------------------------------------------//

procedure TFViewHtml.BtnPrintClick(Sender: TObject);
begin
  WBPrintNoDialog(WebBrowser1);
end;

//----------------------------------------------------------------------------//
{ Click to print preview }
//----------------------------------------------------------------------------//

procedure TFViewHtml.BtnPrintPreviewClick(Sender: TObject);
var
  vIn, vOut: OleVariant;
begin
  WebBrowser1.ControlInterface.ExecWB(OLECMDID_PRINTPREVIEW, OLECMDEXECOPT_DONTPROMPTUSER, vIn, vOut) ;
end;

//----------------------------------------------------------------------------//
{ Call page setup dialog }
//----------------------------------------------------------------------------//

procedure TFViewHtml.BtnPageSetupClick(Sender: TObject);
var
  vIn, vOut: OleVariant;
begin
  WebBrowser1.ControlInterface.ExecWB(OLECMDID_PAGESETUP, OLECMDEXECOPT_PROMPTUSER, vIn, vOut) ;
end;

//----------------------------------------------------------------------------//
{ Exports the unsplit report as one HTML file including the use of File Dialog }
//----------------------------------------------------------------------------//

procedure TFViewHtml.BtnSaveClick(Sender: TObject);
var
  saveDialog : TSaveDialog;
  ReportSettings: TSettings;
begin
  try
    saveDialog             := TSaveDialog.Create(self);
    if CBDowntime.Visible then saveDialog.Title := _('Save resource report as') + ':'
    else saveDialog.Title := _('Save bin report as') + ':';
    saveDialog.InitialDir  := GetCurrentDir;
    saveDialog.FileName    := '';
    saveDialog.Filter      := 'Html file|*.html';
    saveDialog.DefaultExt  := 'html';
    saveDialog.FilterIndex := 1;
    DeleteTempFiles;
    if saveDialog.Execute then
    begin
      ReportSettings.NativeExcel      := nil;
      ReportSettings.DateFrom         := DateFrom;
      ReportSettings.DateTo           := DateTo;
      ReportSettings.SaveFileLocation := saveDialog.FileName;
      ReportSettings.ChkLstBoxRsc     := ChkLstBoxRsc;
      ReportSettings.ReportType       := 'Html';
      ReportSettings.IsBinReport      := not CBDowntime.Visible;
      ReportSettings.MaxRows          := -1;
      ReportSettings.MaxCols          := -1;
      ReportSettings.ShowBinCaption   := CBBinCaption.Checked;
      ReportSettings.ShowCriteria     := CBSelection.Checked;
      ReportSettings.ShowResources    := CBResources.Checked;
      ReportSettings.NewPagePerRes    := false;
      ReportSettings.IncDowntime      := CBDowntime.Checked;
      ReportSettings.ShowUnschedJobs  := CBUnschedJobs.Checked;
      ReportSettings.Comment          := EditComment.Text;
      ReportSettings.IsExportReport   := true;
      try
        ReportSettings.GroupingFields := StrToInt(iniAppGlobals.GroupingFields);
      except ReportSettings.GroupingFields := 0;
      end;
      if (ReportSettings.GroupingFields < 0) or (ReportSettings.GroupingFields > 4)
      then ReportSettings.GroupingFields := 0;
      try
        ReportSettings.JumpingFields := StrToInt(iniAppGlobals.JumpingFields);
      except ReportSettings.JumpingFields := 0;
      end;
      if (ReportSettings.JumpingFields < 0) or (ReportSettings.JumpingFields > 4)
      then ReportSettings.JumpingFields := 0;
      if (ReportSettings.JumpingFields > ReportSettings.GroupingFields) then
        ReportSettings.JumpingFields := ReportSettings.GroupingFields;
      ReportSettings.ShowGroups := CBShowCrits.Checked;
      SetReportFonts(ReportSettings);
      if (CBDowntime.Visible and DynamicScheduleExport(ReportSettings, true)) or
        ((not CBDowntime.Visible) and BinExtractionReport(ReportSettings)) then
      ShowMessage(_('Report successfully saved'));
    end
    else ShowMessage(_('Saving was cancelled'));
    saveDialog.Free;
  except
    on e:Exception do MessageDlg('FMViewHtml - BtnSaveClick'+#13'Message: ' + e.Message, mtError, [mbOK], 0);
  end;
  BtnRefreshClick(nil);
end;

//----------------------------------------------------------------------------//
{ Shows the previous split page }
//----------------------------------------------------------------------------//

procedure TFViewHtml.BtnPrevPageClick(Sender: TObject);
begin
  try
    if (noOfHtmlPages > 1) and (currentPage > 1) then
    begin
      currentPage := currentPage - 1;
      STCurrentPage.Caption := IntToStr(currentPage) + ' ' + _('of') + ' ' + IntToStr(noOfHtmlPages);
      LoadPage( GetCurrentDir + SetBackslash + HTML_REPORT_NAME + IntToStr(currentPage) + '.html');
      SetButtonStatus;
    end;
  except
    on e:Exception do MessageDlg('FMViewHtml - BtnPrevPageClick'+#13'Message: ' + e.Message, mtError, [mbOK], 0);
  end;
end;

//----------------------------------------------------------------------------//
{ Shows the next split page }
//----------------------------------------------------------------------------//

procedure TFViewHtml.BtnNextPageClick(Sender: TObject);
begin
  try
    if noOfHtmlPages > currentPage  then
    begin
      currentPage := currentPage + 1;
      STCurrentPage.Caption := IntToStr(currentPage) + ' ' + _('of') + ' ' + IntToStr(noOfHtmlPages);
      LoadPage( GetCurrentDir + SetBackslash + HTML_REPORT_NAME + IntToStr(currentPage) + '.html');
      SetButtonStatus;
    end;
  except
    on e:Exception do MessageDlg('FMViewHtml - BtnNextPageClick'+#13'Message: ' + e.Message, mtError, [mbOK], 0);
  end;
end;

//----------------------------------------------------------------------------//
{ Checks if the input in the edit field is a positive integer as value for
  Rows-Per-Page. Otherwise, the field is set blank, which means no split. }
//----------------------------------------------------------------------------//

procedure TFViewHtml.EditRowsPerPageExit(Sender: TObject);
begin
  try
    if StrToInt(EditRowsPerPage.Text) < 1 then EditRowsPerPage.Text := '';
  except EditRowsPerPage.Text := '';
  end;
  LabRedField.Visible := true;
end;

//----------------------------------------------------------------------------//
{ Prints all split pages without a dialog }
//----------------------------------------------------------------------------//

procedure TFViewHtml.BtnPrintAllClick(Sender: TObject);
var
  i: Integer;
  URL: String;
begin
  if noOfHtmlPages = 1 then WBPrintNoDialog(WebBrowser1)
  else
  begin
    try
      if noOfHtmlPages > 1 then
        for i:= 1 to noOfHtmlPages do
        begin
          URL := GetCurrentDir + SetBackslash + HTML_REPORT_NAME + IntToStr(i) + '.html';
          DoPrint := true;
          WebBrowser1.Navigate(URL);
          while WebBrowser1.ReadyState <> READYSTATE_COMPLETE do
          begin
            Application.ProcessMessages;
            Sleep(0);
          end;
        end;
    except
      on e:Exception do MessageDlg('FMViewHtml - BtnPrintAllClick'+#13'Message: ' + e.Message, mtError, [mbOK], 0);
    end;
  end;
end;

//----------------------------------------------------------------------------//
{ Shows the first split page }
//----------------------------------------------------------------------------//

procedure TFViewHtml.BtnFirstPageClick(Sender: TObject);
begin
  try
    currentPage := 1;
    LoadPage(GetCurrentDir + SetBackslash + HTML_REPORT_FULL);
  except
    on e:Exception do MessageDlg('FMViewHtml - BtnFirstPageClick'+#13'Message: ' + e.Message, mtError, [mbOK], 0);
  end;
  SetButtonStatus;
end;

//----------------------------------------------------------------------------//
{ Shows the last split page }
//----------------------------------------------------------------------------//

procedure TFViewHtml.BtnLastPageClick(Sender: TObject);
begin
  try
    currentPage := noOfHtmlPages;
    STCurrentPage.Caption := IntToStr(currentPage);
    LoadPage(GetCurrentDir + SetBackslash + HTML_REPORT_NAME + intToStr(currentPage) + '.html');
    SetButtonStatus;
  except
    on e:Exception do MessageDlg('FMViewHtml - BtnLastPageClick'+#13'Message: ' + e.Message, mtError, [mbOK], 0);
  end;
end;

//----------------------------------------------------------------------------//
{ Enables/Disables navigation buttons if necessary }
//----------------------------------------------------------------------------//

procedure TFViewHtml.SetButtonStatus;
begin
  try
    BtnNextPage.Enabled := ViewSplit and (noOfHtmlPages > currentPage);
    BtnPrevPage.Enabled := ViewSplit and (currentPage > 1);
    BtnFirstPage.Enabled := ViewSplit and (noOfHtmlPages > 1);
    BtnLastPage.Enabled := ViewSplit and (noOfHtmlPages > 1);
    if ViewSplit and (noOfHtmlPages > 1) then
      STCurrentPage.Caption := IntToStr(currentPage) + ' ' + _('of') + ' ' + IntToStr(noOfHtmlPages)
    else STCurrentPage.Caption := '';
  except
    on e:Exception do MessageDlg('FMViewHtml - SetButtonStatus'+#13'Message: ' + e.Message, mtError, [mbOK], 0);
  end;
end;

//----------------------------------------------------------------------------//
{ Deletes temporary files that the viewer created }
//----------------------------------------------------------------------------//

procedure TFViewHtml.DeleteTempFiles;
var
  i: Integer;
begin
  try
    DeleteFile(GetCurrentDir + SetBackslash + HTML_REPORT_FULL);
    for i:= 1 to noOfHtmlPages do
      DeleteFile(GetCurrentDir + SetBackslash + HTML_REPORT_NAME + intToStr(i) + '.html');
  except
    on e:Exception do MessageDlg('FMViewHtml - DeleteTempFiles'+#13'Message: ' + e.Message, mtError, [mbOK], 0);
  end;
end;

//----------------------------------------------------------------------------//
{ Close the form }
//----------------------------------------------------------------------------//

procedure TFViewHtml.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DeleteTempFiles;
  ColorMenu.Free;
end;

//----------------------------------------------------------------------------//
{ Choice whether to show the Selection Criteria }
//----------------------------------------------------------------------------//

procedure TFViewHtml.CBSelectionClick(Sender: TObject);
begin
  if not CBSelection.Visible then exit;
  if CBSelection.Checked then iniAppGlobals.ShowCriteria := '1'
  else iniAppGlobals.ShowCriteria := '0';
  GlobSaveIniValues;
  LabRedField.Visible := true;
end;

//----------------------------------------------------------------------------//
{ Choice whether to show the Bin Caption }
//----------------------------------------------------------------------------//

procedure TFViewHtml.CBBinCaptionClick(Sender: TObject);
begin
  if CBBinCaption.Checked then iniAppGlobals.ShowBinCaption := '1'
  else iniAppGlobals.ShowBinCaption := '0';
  GlobSaveIniValues;
  LabRedField.Visible := true;
end;

//----------------------------------------------------------------------------//
{ Enter an optional comment that is shown on the HTML pages }
//----------------------------------------------------------------------------//

procedure TFViewHtml.EditCommentChange(Sender: TObject);
begin
  LabRedField.Visible := true;
end;

//----------------------------------------------------------------------------//
{ Saves edited optional comment }
//----------------------------------------------------------------------------//

procedure TFViewHtml.EditCommentExit(Sender: TObject);
begin
  iniAppGlobals.ReportComment1 := EditComment.Text;
  GlobSaveIniValues;
end;

//----------------------------------------------------------------------------//
{ Creates new updated temporary HTML file(s) and shows first page }
//----------------------------------------------------------------------------//

procedure TFViewHtml.BtnRefreshClick(Sender: TObject);
var
  ReportSettings: TSettings;
begin
  if not LabRedField.Visible then exit;
  LabRedField.Visible := false;
  DeleteTempFiles;
  if CloseForm then exit;
  try
    ReportSettings.NativeExcel      := nil;
    ReportSettings.DateFrom         := DateFrom ;
    ReportSettings.DateTo           := DateTo ;
    ReportSettings.ChkLstBoxRsc     := ChkLstBoxRsc;
    ReportSettings.ReportType       := 'Html';
    ReportSettings.IsBinReport      := not CBDowntime.Visible;
    try
      ReportSettings.MaxRows        := StrToInt(EditRowsPerPage.Text);
    except
      begin
        ReportSettings.MaxRows   := -1;
        EditRowsPerPage.Text := '';
      end;
    end;
    if ReportSettings.MaxRows < 1 then
    begin
      ReportSettings.MaxRows := -1;
      EditRowsPerPage.Text := '';
    end;
    if ReportSettings.MaxRows > 0 then
      iniAppGlobals.HtmlRowNum := IntToStr(ReportSettings.MaxRows)
    else iniAppGlobals.HtmlRowNum := '0';
    try
      ReportSettings.GroupingFields := StrToInt(ComBoxSortCrits.Text);
    except ReportSettings.GroupingFields := 0;
    end;
    if (ReportSettings.GroupingFields < 0) or (ReportSettings.GroupingFields > 4)
    then ReportSettings.GroupingFields := 0;
    try
      ReportSettings.JumpingFields := StrToInt(ComBoxJumps.Text);
    except ReportSettings.JumpingFields := 0;
    end;
    if (ReportSettings.JumpingFields < 0) or (ReportSettings.JumpingFields > 4)
    then ReportSettings.JumpingFields := 0;
    if (ReportSettings.JumpingFields > ReportSettings.GroupingFields) then
      ReportSettings.JumpingFields := ReportSettings.GroupingFields;
    ReportSettings.ShowGroups       := CBShowCrits.Checked;
    GlobSaveIniValues;
    ReportSettings.MaxCols          := -1;
    ReportSettings.ShowBinCaption   := CBBinCaption.Checked;
    ReportSettings.ShowCriteria     := CBSelection.Checked;
    ReportSettings.ShowResources    := CBResources.Checked;
    ReportSettings.NewPagePerRes    := CBNewPagePerRes.Checked;
    ReportSettings.IncDowntime      := CBDowntime.Checked;
    ReportSettings.ShowUnschedJobs  := CBUnschedJobs.Checked;
    ReportSettings.Comment          := EditComment.Text;
    ReportSettings.IsExportReport   := false;
    ReportSettings.SaveFileLocation := GetCurrentDir + SetBackslash + HTML_REPORT_FULL;
    SetReportFonts(ReportSettings);
    if (CBDowntime.Visible and DynamicScheduleExport(ReportSettings, true)) or
      ((not CBDowntime.Visible) and BinExtractionReport(ReportSettings)) then
    begin
      ViewSplit           := ReportSettings.NewPagePerRes or (ReportSettings.MaxRows > 0);
      currentPage         := 1;
      LoadPage(ReportSettings.SaveFileLocation);
      SetButtonStatus;
    end
    else ShowMessage(_('HTML Report not created'));
  except
    on e:Exception do MessageDlg('FMViewHtml - BtnRefreshClick'+#13'Message: ' + e.Message, mtError, [mbOK], 0);
  end;
end;

//----------------------------------------------------------------------------//
{ Change font attributes for Bin Caption using a Font Dialog }
//----------------------------------------------------------------------------//

procedure TFViewHtml.BtnFontBinClick(Sender: TObject);
begin
  if iniAppGlobals.FontBinCaption <> '' then
    FontDialog1.Font.Name := iniAppGlobals.FontBinCaption;
    FontDialog1.Font.Style := StringToFontStyles(iniAppGlobals.FontBinCapStyle);
  try
    FontDialog1.Font.Color := StrToInt(iniAppGlobals.FontBinCapColor);
  except FontDialog1.Font.Color := clBlack;
  end;
  try
    FontDialog1.Font.Charset := StrToInt(iniAppGlobals.FontBinCapChar);
  except FontDialog1.Font.Charset := 0;
  end;
  try
    FontDialog1.Font.Size := StrToInt(iniAppGlobals.FontBinCapSize);
  except FontDialog1.Font.Size := 12;
  end;
  if FontDialog1.Execute then
  begin
    iniAppGlobals.FontBinCapColor := IntToStr(FontDialog1.Font.Color);
    iniAppGlobals.FontBinCapChar  := IntToStr(FontDialog1.Font.Charset);
    iniAppGlobals.FontBinCaption  := FontDialog1.Font.Name;
    iniAppGlobals.FontBinCapSize  := IntToStr(FontDialog1.Font.Size);
    iniAppGlobals.FontBinCapStyle := FontStylesToString(FontDialog1.Font.Style);
    GlobSaveIniValues;
    LabRedField.Visible := true;
  end;
end;

//----------------------------------------------------------------------------//
{ Change font attributes for Selection Criteria using a Font Dialog }
//----------------------------------------------------------------------------//

procedure TFViewHtml.BtnFontCriteriaClick(Sender: TObject);
begin
  if iniAppGlobals.FontCriteria <> '' then
    FontDialog1.Font.Name := iniAppGlobals.FontCriteria;
    FontDialog1.Font.Style := StringToFontStyles(iniAppGlobals.FontCriteriaStyle);
  try
    FontDialog1.Font.Color := StrToInt(iniAppGlobals.FontCriteriaColor);
  except FontDialog1.Font.Color := clBlack;
  end;
  try
    FontDialog1.Font.Charset := StrToInt(iniAppGlobals.FontCriteriaChar);
  except FontDialog1.Font.Charset := 0;
  end;
  try
    FontDialog1.Font.Size := StrToInt(iniAppGlobals.FontCriteriaSize);
  except FontDialog1.Font.Size := 12;
  end;
  if FontDialog1.Execute then
  begin
    iniAppGlobals.FontCriteriaColor := IntToStr(FontDialog1.Font.Color);
    iniAppGlobals.FontCriteriaChar  := IntToStr(FontDialog1.Font.Charset);
    iniAppGlobals.FontCriteria      := FontDialog1.Font.Name;
    iniAppGlobals.FontCriteriaSize  := IntToStr(FontDialog1.Font.Size);
    iniAppGlobals.FontCriteriaStyle := FontStylesToString(FontDialog1.Font.Style);
    GlobSaveIniValues;
    LabRedField.Visible := true;
  end;
end;

//----------------------------------------------------------------------------//
{ Change font attributes for the optional comment using a Font Dialog }
//----------------------------------------------------------------------------//

procedure TFViewHtml.BtnFontCommentClick(Sender: TObject);
begin
  if iniAppGlobals.FontComment <> '' then
    FontDialog1.Font.Name := iniAppGlobals.FontComment;
    FontDialog1.Font.Style := StringToFontStyles(iniAppGlobals.FontCommentStyle);
  try
    FontDialog1.Font.Color := StrToInt(iniAppGlobals.FontCommentColor);
  except FontDialog1.Font.Color := clBlack;
  end;
  try
    FontDialog1.Font.Charset := StrToInt(iniAppGlobals.FontCommentChar);
  except FontDialog1.Font.Charset := 0;
  end;
  try
    FontDialog1.Font.Size := StrToInt(iniAppGlobals.FontCommentSize);
  except FontDialog1.Font.Size := 12;
  end;
  if FontDialog1.Execute then
  begin
    iniAppGlobals.FontCommentColor := IntToStr(FontDialog1.Font.Color);
    iniAppGlobals.FontCommentChar  := IntToStr(FontDialog1.Font.Charset);
    iniAppGlobals.FontComment      := FontDialog1.Font.Name;
    iniAppGlobals.FontCommentSize  := IntToStr(FontDialog1.Font.Size);
    iniAppGlobals.FontCommentStyle := FontStylesToString(FontDialog1.Font.Style);
    GlobSaveIniValues;
    LabRedField.Visible := true;
  end;
end;

//----------------------------------------------------------------------------//
{ Change font attributes for Column Titles using a Font Dialog }
//----------------------------------------------------------------------------//

procedure TFViewHtml.BtnFontColumnsClick(Sender: TObject);
begin
  if iniAppGlobals.FontColTitles <> '' then
    FontDialog1.Font.Name := iniAppGlobals.FontColTitles;
    FontDialog1.Font.Style := StringToFontStyles(iniAppGlobals.FontColTitleStyle);
  try
    FontDialog1.Font.Color := StrToInt(iniAppGlobals.FontColTitleColor);
  except FontDialog1.Font.Color := clBlack;
  end;
  try
    FontDialog1.Font.Charset := StrToInt(iniAppGlobals.FontColTitleChar);
  except FontDialog1.Font.Charset := 0;
  end;
  try
    FontDialog1.Font.Size := StrToInt(iniAppGlobals.FontColTitleSize);
  except FontDialog1.Font.Size := 12;
  end;
  if FontDialog1.Execute then
  begin
    iniAppGlobals.FontColTitleColor := IntToStr(FontDialog1.Font.Color);
    iniAppGlobals.FontColTitleChar  := IntToStr(FontDialog1.Font.Charset);
    iniAppGlobals.FontColTitles := FontDialog1.Font.Name;
    iniAppGlobals.FontColTitleSize := IntToStr(FontDialog1.Font.Size);
    iniAppGlobals.FontColTitleStyle := FontStylesToString(FontDialog1.Font.Style);
    GlobSaveIniValues;
    LabRedField.Visible := true;
  end;
end;

//----------------------------------------------------------------------------//
{ Change font attributes for Column Lines using a Font Dialog }
//----------------------------------------------------------------------------//

procedure TFViewHtml.BtnFontDataClick(Sender: TObject);
begin
  if iniAppGlobals.FontDataLine <> '' then
    FontDialog1.Font.Name := iniAppGlobals.FontDataLine;
    FontDialog1.Font.Style := StringToFontStyles(iniAppGlobals.FontDataLineStyle);
  try
    FontDialog1.Font.Color := StrToInt(iniAppGlobals.FontDataLineColor);
  except FontDialog1.Font.Color := clBlack;
  end;
  try
    FontDialog1.Font.Charset := StrToInt(iniAppGlobals.FontDataLineChar);
  except FontDialog1.Font.Charset := 0;
  end;
  try
    FontDialog1.Font.Size := StrToInt(iniAppGlobals.FontDataLineSize);
  except FontDialog1.Font.Size := 12;
  end;
  if FontDialog1.Execute then
  begin
    iniAppGlobals.FontDataLineColor := IntToStr(FontDialog1.Font.Color);
    iniAppGlobals.FontDataLineChar  := IntToStr(FontDialog1.Font.Charset);
    iniAppGlobals.FontDataLine      := FontDialog1.Font.Name;
    iniAppGlobals.FontDataLineSize  := IntToStr(FontDialog1.Font.Size);
    iniAppGlobals.FontDataLineStyle := FontStylesToString(FontDialog1.Font.Style);
    GlobSaveIniValues;
    LabRedField.Visible := true;
  end;
end;

//----------------------------------------------------------------------------//
{ Choice whether creating a new HTML page per new resource }
//----------------------------------------------------------------------------//

procedure TFViewHtml.CBNewPagePerResClick(Sender: TObject);
begin
  if not CBNewPagePerRes.Visible then exit;
  if CBNewPagePerRes.Checked then iniAppGlobals.PagePerResource := '1'
  else iniAppGlobals.PagePerResource := '0';
  GlobSaveIniValues;
  LabRedField.Visible := true;
end;

//----------------------------------------------------------------------------//
{ Choice whether to include Downtimes in statistics of Dynamic Schedule Report }
//----------------------------------------------------------------------------//

procedure TFViewHtml.CBDowntimeClick(Sender: TObject);
begin
  if CBDowntime.Checked then iniAppGlobals.IncDowntime := '1'
  else iniAppGlobals.IncDowntime := '0';
  GlobSaveIniValues;
  LabRedField.Visible := true;
end;

//----------------------------------------------------------------------------//
{ Call form in FMReportHtmlBackColors to change background colors for the form }
//----------------------------------------------------------------------------//

procedure TFViewHtml.BtnBgColorsClick(Sender: TObject);
begin
  if ColorMenu = nil then ColorMenu := THtmlBackColors.CreateColorMenu(self)
  else
  begin
    ColorMenu.UpdateColors;
    ColorMenu.InitStatus;
  end;
  ColorMenu.Show;
  LabRedField.Visible := true;
end;

//----------------------------------------------------------------------------//
{ Close this form }
//----------------------------------------------------------------------------//

procedure TFViewHtml.BtnCloseClick(Sender: TObject);
begin
  DeleteTempFiles;
  ComBoxSortCrits.Clear;
  ComBoxJumps.Clear;
  Close;
end;

//----------------------------------------------------------------------------//
{ Sets printer-friendly grey-scale colors for fonts and background }
//----------------------------------------------------------------------------//

procedure TFViewHtml.BtnPrColorsClick(Sender: TObject);
var yesNo: TForm;
begin
  yesNo := CreateMessageDialog(_('Do you really want to override all font and background colors?'),
           mtConfirmation, [mbYes, mbNo]);
  yesNo.ShowModal;
  if yesNo.ModalResult = mrYes then
  begin
    iniAppGlobals.HtmlColorBack     := IntToStr(clWhite);
    iniAppGlobals.HtmlColorTabTitle := IntToStr(clMedGray);
    iniAppGlobals.HtmlColorTabEven  := IntToStr(clWhite);
    iniAppGlobals.HtmlColorTabOdd   := IntToStr(clLtGray);
    iniAppGlobals.FontBinCapColor   := IntToStr(clBlack);
    iniAppGlobals.FontCriteriaColor := IntToStr(clBlack);
    iniAppGlobals.FontCommentColor  := IntToStr(clBlack);
    iniAppGlobals.FontColTitleColor := IntToStr(clBlack);
    iniAppGlobals.FontDataLineColor := IntToStr(clBlack);
    LabRedField.Visible := true;
  end;
  yesNo.Free;
  BtnRefreshClick(nil);
end;

//----------------------------------------------------------------------------//
{ Choice whether to show Unscheduled Jobs in Bin Extraction }
//----------------------------------------------------------------------------//

procedure TFViewHtml.CBUnschedJobsClick(Sender: TObject);
begin
  if CBUnschedJobs.Checked then iniAppGlobals.ShowUnschedJobs := '1'
  else iniAppGlobals.ShowUnschedJobs := '0';
  GlobSaveIniValues;
  LabRedField.Visible := true;
end;

//----------------------------------------------------------------------------//
{ Choice whether to show Group Attributes in Bin Extraction }
//----------------------------------------------------------------------------//

procedure TFViewHtml.CBShowCritsClick(Sender: TObject);
begin
  if CBShowCrits.Checked then iniAppGlobals.ShowGroups := '1'
  else iniAppGlobals.ShowGroups := '0';
  GlobSaveIniValues;
  LabRedField.Visible := true;
end;

//----------------------------------------------------------------------------//
{ Checks whether entered value for number of jumping fields is between 0 and 4
  and smaller than sort criteria }
//----------------------------------------------------------------------------//

procedure TFViewHtml.ComBoxJumpsChange(Sender: TObject);
var jumps, groups: Integer;
begin
  try
    groups := StrToInt(ComBoxSortCrits.Text);
    jumps := StrToInt(ComBoxJumps.Text);
  except
    begin
      groups := 0;
      jumps := 0;
    end;
  end;
  if (groups < 0) or (groups > 4) or (jumps < 0) or (jumps > 4) then
  begin
    groups := 0;
    jumps := 0;
  end;
  if jumps > groups then jumps := groups;
  iniAppGlobals.GroupingFields := IntToStr(groups);
  iniAppGlobals.JumpingFields := IntToStr(jumps);
  GlobSaveIniValues;
  ComBoxSortCrits.Text := iniAppGlobals.GroupingFields;
  ComBoxJumps.ItemIndex := jumps; //iniAppGlobals.JumpingFields;
  LabRedField.Visible := true;
end;

//----------------------------------------------------------------------------//
{ Checks whether entered value for number of sort criteria is between 0 and 4 }
//----------------------------------------------------------------------------//

procedure TFViewHtml.ComBoxSortCritsChange(Sender: TObject);
var i: Integer;
begin
  try
    i := StrToInt(ComBoxSortCrits.Text);
  except
    begin
      i := 0;
    end;
  end;
  if (i < 0) or (i > 4) then i := 0;
  iniAppGlobals.GroupingFields := IntToStr(i);
  if i < StrToInt(ComBoxJumps.Text) then
  begin
    iniAppGlobals.JumpingFields := iniAppGlobals.GroupingFields;
    ComBoxJumps.Text := ComBoxSortCrits.Text;
  end
  else ComBoxSortCrits.Text := IntToStr(i);
  GlobSaveIniValues;
  LabRedField.Visible := true;
end;

//----------------------------------------------------------------------------//
{ Choice whether to show resource descriptions }
//----------------------------------------------------------------------------//

procedure TFViewHtml.CBResourcesClick(Sender: TObject);
begin
  if not CBResources.Visible then exit;
  if CBResources.Checked then iniAppGlobals.ShowResources := '1'
  else iniAppGlobals.ShowResources := '0';
  GlobSaveIniValues;
  LabRedField.Visible := true;
end;

end.

