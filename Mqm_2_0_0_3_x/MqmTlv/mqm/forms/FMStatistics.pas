unit FMStatistics;

interface

uses
  cxButtons, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, UMPlanTbs, UMViewPage, UMStatisticCalculation,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, UReShape, cxGraphics, dxUIAClasses,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit,
  cxTextEdit;

type

  TButtonShowDetails = class(TBitBtn)
   constructor CreateTButtonDetails(AOwner: TComponent);
   public
     m_PercentOfjobsCaseForEachResCase : TPercentArrayCompact;
     m_PercentOfjobsCaseForEachJobToJobCase : TPercentArrayCompact;
     m_ListUmQtyDetails : TList;
     m_NumberOfJobs : integer;
     // delay-band breakdown context; the per-schedule data is resolved at click time
     m_DelayPeriodIndex : Integer; // J (1 = Total, else week/month index + 1)
     m_DelayIsWeekly    : Boolean;
     m_DelayIsEarly     : Boolean; // true = early-delivery bands (m_EarlyBands); false = delay bands (m_DelayBands)
     m_DelayGanttName   : string;
     m_DelayTitle       : string;
  end;

  TabSheetPeriod = class(TTabSheet)
    constructor CreateTabShiitStatisticsPeriod(AOwner: TComponent; startDate, enddate : TDateTime);
    procedure  OnClickCompactCasesRes(Sender: TObject);
    procedure  OnClickCompactCasesJobToJob(Sender: TObject);
    procedure  OnClickTotalUomProduced(Sender: TObject);
    procedure  OnClickDelayBands(Sender: TObject);
  private
    m_startDate : TDateTime;
    m_EndDate   : TDateTime;
    PanelTitle, PanelData : TPanel;

    ScrollBox   : TScrollBox;

    staticText1 : TcxTextEdit;
    staticText2, staticText3, staticText4 : TcxTextEdit;


    NumRelevantJobs_Lbl : TLabel;
    MinDaysDelay_Lbl : TLabel;
    MaxDaysDelay_Lbl : TLabel;
    TotDaysDelay_Lbl : TLabel;
    PercentOfJobsIndelay_Lbl : TLabel;
    MinDaysTooEarly_Lbl : TLabel;
    MaxDaysTooEarly_Lbl : TLabel;
    TotDaysTooEarly_Lbl : TLabel;
    PercentOfJobsTooEarly_Lbl : TLabel;
    TotalSetupHours_Lbl : TLabel;
    PercentOfSetupHours_Lbl : TLabel;
    TotalHoursExecution_Lbl : TLabel;
    TotalHoursOfOccPerGanttOcc_Lbl : TLabel;
    MinCaseForResource_Lbl : TLabel;
    PercentOfjobsCaseForEachResCase_Lbl : TLabel;
    MaxCaseForResource_Lbl : TLabel;
    MinCaseJobToJob_Lbl : TLabel;
    PercentOfjobsCaseForEachJobToJobCase_Lbl : TLabel;
    MaxCaseJobToJob_Lbl : TLabel;
  //  PercentOfjobsCaseForEachJobToJobCase_Max_Lbl : TLabel;
    NumberOfjobsWithoutMaterial_Lbl : TLabel;
//    NumberOfjobsWithoutTools_Lbl : TLabel;
    NumberOfjobsWithoutManPawer_Lbl : TLabel;
    NumberOfjobsWithoutAnyAddRes_Lbl : TLabel;
    TotalUomProduced_Lbl : TLabel;

    ST_NumRelevantJobs_1 : TcxTextEdit; // "Number of relevant jobs" = m_NumberOfJobs_Total_ForDelayCalc
    ST_MinDaysDelay_1 : TcxTextEdit; // reused as the "Number of jobs in delay" value box
    ST_MaxDaysDelay_1 : TcxTextEdit;
    ST_TotDaysDelay_1 : TcxTextEdit;
    ST_PercentOfJobsIndelay_1 : TcxTextEdit;
    ST_DelayBandsShow : TButtonShowDetails; // "Show breakdown" button (single, combined across schedules)
    ST_EarlyBandsShow : TButtonShowDetails; // "Show early breakdown" button (single, combined across schedules)
    ST_MinDaysTooEarly_1 : TcxTextEdit;
    ST_MaxDaysTooEarly_1 : TcxTextEdit;
    ST_TotDaysTooEarly_1 : TcxTextEdit;
    ST_PercentOfJobsTooEarly_1 : TcxTextEdit;
    ST_TotalSetupHours_1 : TcxTextEdit;
    ST_PercentOfSetupHours_1 : TcxTextEdit;
    ST_TotalHoursExecution_1 : TcxTextEdit;
    ST_TotalHoursOfOccPerGanttOcc_1 : TcxTextEdit;
    ST_MinCaseForResource_1 : TcxTextEdit;
    ST_PercentOfjobsCaseForEachResCase_1 : TButtonShowDetails;
    ST_MaxCaseForResource_1 : TcxTextEdit;
    ST_MinCaseJobToJob_1 : TcxTextEdit;
    ST_PercentOfjobsCaseForEachJobToJobCase_1 : TButtonShowDetails;
    ST_MaxCaseJobToJob_1 : TcxTextEdit;
    ST_NumberOfjobsWithoutMaterial_1 : TcxTextEdit;
//    ST_NumberOfjobsWithoutTools_1 : TcxTextEdit;
    ST_NumberOfjobsWithoutManPawer_1 : TcxTextEdit;
    ST_NumberOfjobsWithoutAnyAddRes_1 : TcxTextEdit;
    ST_TotalUomProduced_1 : TButtonShowDetails;

    ST_NumRelevantJobs_2 : TcxTextEdit;
    ST_MinDaysDelay_2 : TcxTextEdit;
    ST_MaxDaysDelay_2 : TcxTextEdit;
    ST_TotDaysDelay_2 : TcxTextEdit;
    ST_PercentOfJobsIndelay_2 : TcxTextEdit;
    ST_MinDaysTooEarly_2 : TcxTextEdit;
    ST_MaxDaysTooEarly_2 : TcxTextEdit;
    ST_TotDaysTooEarly_2 : TcxTextEdit;
    ST_PercentOfJobsTooEarly_2 : TcxTextEdit;
    ST_TotalSetupHours_2 : TcxTextEdit;
    ST_PercentOfSetupHours_2 : TcxTextEdit;
    ST_TotalHoursExecution_2 : TcxTextEdit;
    ST_TotalHoursOfOccPerGanttOcc_2 : TcxTextEdit;
    ST_MinCaseForResource_2 : TcxTextEdit;
    ST_PercentOfjobsCaseForEachResCase_2 : TButtonShowDetails;
    ST_MaxCaseForResource_2 : TcxTextEdit;
    ST_MinCaseJobToJob_2 : TcxTextEdit;
    ST_PercentOfjobsCaseForEachJobToJobCase_2 : TButtonShowDetails;
    ST_MaxCaseJobToJob_2 : TcxTextEdit;
    ST_NumberOfjobsWithoutMaterial_2 : TcxTextEdit;
//    ST_NumberOfjobsWithoutTools_2 : TcxTextEdit;
    ST_NumberOfjobsWithoutManPawer_2 : TcxTextEdit;
    ST_NumberOfjobsWithoutAnyAddRes_2 : TcxTextEdit;
    ST_TotalUomProduced_2 : TButtonShowDetails;

    ST_NumRelevantJobs_3 : TcxTextEdit;
    ST_MinDaysDelay_3 : TcxTextEdit;
    ST_MaxDaysDelay_3 : TcxTextEdit;
    ST_TotDaysDelay_3 : TcxTextEdit;
    ST_PercentOfJobsIndelay_3 : TcxTextEdit;
    ST_MinDaysTooEarly_3 : TcxTextEdit;
    ST_MaxDaysTooEarly_3 : TcxTextEdit;
    ST_TotDaysTooEarly_3 : TcxTextEdit;
    ST_PercentOfJobsTooEarly_3 : TcxTextEdit;
    ST_TotalSetupHours_3 : TcxTextEdit;
    ST_PercentOfSetupHours_3 : TcxTextEdit;
    ST_TotalHoursExecution_3 : TcxTextEdit;
    ST_TotalHoursOfOccPerGanttOcc_3 : TcxTextEdit;
    ST_MinCaseForResource_3 : TcxTextEdit;
    ST_PercentOfjobsCaseForEachResCase_3 : TButtonShowDetails;
    ST_MaxCaseForResource_3 : TcxTextEdit;
    ST_MinCaseJobToJob_3 : TcxTextEdit;
    ST_PercentOfjobsCaseForEachJobToJobCase_3 : TButtonShowDetails;
    ST_MaxCaseJobToJob_3 : TcxTextEdit;
    ST_NumberOfjobsWithoutMaterial_3 : TcxTextEdit;
//    ST_NumberOfjobsWithoutTools_3 : TcxTextEdit;
    ST_NumberOfjobsWithoutManPawer_3 : TcxTextEdit;
    ST_NumberOfjobsWithoutAnyAddRes_3 : TcxTextEdit;
    ST_TotalUomProduced_3 : TButtonShowDetails;

    ST_NumRelevantJobs_4 : TcxTextEdit;
    ST_MinDaysDelay_4 : TcxTextEdit;
    ST_MaxDaysDelay_4 : TcxTextEdit;
    ST_TotDaysDelay_4 : TcxTextEdit;
    ST_PercentOfJobsIndelay_4 : TcxTextEdit;
    ST_MinDaysTooEarly_4 : TcxTextEdit;
    ST_MaxDaysTooEarly_4 : TcxTextEdit;
    ST_TotDaysTooEarly_4 : TcxTextEdit;
    ST_PercentOfJobsTooEarly_4 : TcxTextEdit;
    ST_TotalSetupHours_4 : TcxTextEdit;
    ST_PercentOfSetupHours_4 : TcxTextEdit;
    ST_TotalHoursExecution_4 : TcxTextEdit;
    ST_TotalHoursOfOccPerGanttOcc_4 : TcxTextEdit;
    ST_MinCaseForResource_4 : TcxTextEdit;
    ST_PercentOfjobsCaseForEachResCase_4 : TButtonShowDetails;
    ST_MaxCaseForResource_4 : TcxTextEdit;
    ST_MinCaseJobToJob_4 : TcxTextEdit;
    ST_PercentOfjobsCaseForEachJobToJobCase_4 : TButtonShowDetails;
    ST_MaxCaseJobToJob_4 : TcxTextEdit;
    ST_NumberOfjobsWithoutMaterial_4 : TcxTextEdit;
//    ST_NumberOfjobsWithoutTools_4 : TcxTextEdit;
    ST_NumberOfjobsWithoutManPawer_4 : TcxTextEdit;
    ST_NumberOfjobsWithoutAnyAddRes_4 : TcxTextEdit;
    ST_TotalUomProduced_4 : TButtonShowDetails;

  end;

  TabSheetStatistics = class(TTabSheet)
    constructor CreateTabShiitStatistics(AOwner: TComponent);
  end;

  TFStatistics = class(TForm)
    Panel1: TPanel;
    EditStatisticName: TEdit;
    LableName: TLabel;
    BtnOk: TcxButton;
    BtnAbo: TcxButton;
    procedure BtnAboClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOkClick(Sender: TObject);
    procedure EditStatisticNameChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    m_ShowOnly : boolean;
    m_PgcStatistics_Tab : TMViewPage;
    procedure CreateStatisticsTabsComponents(IsWeekly : boolean; var ListStatisticOfGantTab : TList);
  public
    constructor CreateStatistics(AOwner: TComponent; ListStatisticOfGantTab : TList; ShowOnly : boolean; IsWeekly : boolean);
    { Public declarations }
  end;

var
  FStatistics: TFStatistics;

implementation

uses
  UGglobal, gnugettext, UMCommon, dateutils, FMStatisticsDetails, FMMainPlan, UGcal;

{$R *.dfm}

{ TFormStatistics }

procedure TFStatistics.BtnAboClick(Sender: TObject);
begin
  //DeleteLastScheduleStatistics;
  ModalResult := mrAbort;
    Close;
end;

//----------------------------------------------------------------------------//

procedure TFStatistics.BtnOkClick(Sender: TObject);
begin
  ModalResult := mrOk;
//  Close;
end;

//----------------------------------------------------------------------------//

constructor TFStatistics.CreateStatistics(AOwner: TComponent; ListStatisticOfGantTab : TList; ShowOnly: boolean; IsWeekly : boolean);
begin
  inherited Create(AOwner);
  m_ShowOnly := ShowOnly;
  ModalResult := mrCancel;
  if IsWeekly then
    caption := _('Statistics results') + ' / ' + _('Weekly')
  else
    caption := _('Statistics results') + ' / ' + _('Monthly');
  CreateStatisticsTabsComponents(IsWeekly, ListStatisticOfGantTab);
end;

//----------------------------------------------------------------------------//

procedure TFStatistics.CreateStatisticsTabsComponents(IsWeekly : boolean; var ListStatisticOfGantTab : TList);
var
  I, J, Period : Integer;
  Percent, TotSetupHours, TotExecutionHours, PercentHoursPerOccMachine : double;
  S, PercentStr, TotSetupHoursStr, TotExecutionHoursStr, TotExecutionHoursPerOccMachineStr : string;
  TempExt : Extended;
  StartPeriod, EndPeriod : TDateTime;
  TabSheet : TabSheetStatistics;
  TabPeriod : TabSheetPeriod;
  PgcStatistics_Period : TMViewPage;
  ResOfGanttTab : TResOfGanttTab;
  TabSectionTitle : string;
  ScheduleStatistics_2, ScheduleStatistics_3, ScheduleStatistics_4 : TResOfGanttTab;
  TiTleColor : TColor;

  MinDaysDelay_Color : TColor;
  MaxDaysDelay_Color : TColor;
  TotDaysDelay_Color : TColor;
  PercentOfJobsIndelay_Color : TColor;
  MinDaysTooEarly_Color : TColor;
  MaxDaysTooEarly_Color : TColor;
  TotDaysTooEarly_Color : TColor;
  PercentOfJobsTooEarly_Color : TColor;
  TotalSetupHours_Color : TColor;
  PercentOfSetupHours_Color : TColor;
  TotalHoursExecution_Color : TColor;
  TotalHoursOfOccPerGanttOcc_Color : TColor;
  MinCaseForResource_Color : TColor;
  PercentOfjobsCaseForEachResCase_Color : TColor;
  MaxCaseForResource_Color : TColor;
  MinCaseJobToJob_Color : TColor;
  PercentOfjobsCaseForEachJobToJobCase_Color : TColor;

  MaxCaseJobToJob_Color : TColor;
//  PercentOfjobsCaseForEachJobToJobCase_Max_Color : TColor;
  NumberOfjobsWithoutMaterial_Color : TColor;
  NumberOfjobsWithoutManPawer_Color : TColor;
  NumberOfjobsWithoutAnyAddRes_Color : TColor;
  TotalUomProduced_Color : TColor;
begin
//  BackGroundcolor1 := DescrBkgr;
//  BackGroundcolor2 := 12189648;

  MinDaysDelay_Color := 13421721;
  MaxDaysDelay_Color := DescrBkgr;
  TotDaysDelay_Color := 14145535;
  PercentOfJobsIndelay_Color := 13434842;
  MinDaysTooEarly_Color := 11261654;
  MaxDaysTooEarly_Color := 11918079;
  TotDaysTooEarly_Color := 12582911;
  PercentOfJobsTooEarly_Color := 14079702;
  TotalSetupHours_Color := 15138764;
  PercentOfSetupHours_Color := 15125759;
  TotalHoursExecution_Color := 13421721;
  TotalHoursOfOccPerGanttOcc_Color := DescrBkgr;
  MinCaseForResource_Color := 14145535;
  PercentOfjobsCaseForEachResCase_Color := Clred;
  MaxCaseForResource_Color := 13434842;
  MinCaseJobToJob_Color := 11261654;
  PercentOfjobsCaseForEachJobToJobCase_Color := Clred;
  MaxCaseJobToJob_Color := 11918079;

  NumberOfjobsWithoutMaterial_Color := DescrBkgr;
  NumberOfjobsWithoutManPawer_Color := 14145535;
  NumberOfjobsWithoutAnyAddRes_Color := 13434842;
  TotalUomProduced_Color := Clred;

  TiTleColor       := ClWhite;
  m_PgcStatistics_Tab := TMViewPage.Create(self, vt_statistics);
  m_PgcStatistics_Tab.Align := alClient;
  if IsWeekly then
    Period := 13
  else
    Period := 5;

  for I := 0 to ListStatisticOfGantTab.Count - 1 do
  begin
    ResOfGanttTab := TResOfGanttTab(ListStatisticOfGantTab[I]);

    ResOfGanttTab := TResOfGanttTab(GetStatisticOfGantTabByIndex(1, ResOfGanttTab.m_ganttTabName)); // solved bug on show

    TabSheet := TabSheetStatistics.CreateTabShiitStatistics(m_PgcStatistics_Tab);

    if ResOfGanttTab.m_ActiveTab then
       m_PgcStatistics_Tab.ActivePageIndex := i;

    TabSheet.Caption := ResOfGanttTab.m_ganttTabName;

    PgcStatistics_Period := TMViewPage.Create(TabSheet, vt_statisticsWeekly);
    PgcStatistics_period.Align := alClient;

    StartPeriod := date;

    for J := 1 to Period do
    begin

      if J = 1 then
      begin
        StartPeriod := ResOfGanttTab.m_SumTotalPeriod.m_StartOfPeriod_Total;
        EndPeriod := ResOfGanttTab.m_SumTotalPeriod.m_EndOfPeriod_Total;
        if ResOfGanttTab.m_ScheduleStatistics.getHieghestEndDateJob <= EndPeriod then
           EndPeriod := ResOfGanttTab.m_ScheduleStatistics.getHieghestEndDateJob;
        TabSectionTitle := _('Total');
      end
      else
      begin
        if IsWeekly then
        begin
          StartPeriod := ResOfGanttTab.m_SumArrayforWeeks[J - 1].m_StartOfPeriod_Week;
          EndPeriod   := ResOfGanttTab.m_SumArrayforWeeks[J - 1].m_EndOfPeriod_Week;
          if (EndPeriod - 7) > (ResOfGanttTab.m_ScheduleStatistics.getHieghestEndDateJob) then
             break;

          // Use the Gantt's week numbering (UGcal.WeekNumber) on the locale week-start so the
          // statistics week headers match the Gantt grid exactly (e.g. 19/06/2026 -> week 24).
          TabSectionTitle := IntToStr(WeekNumber(LocaleWeekStart(StartPeriod)))
        end
        else
        begin
          StartPeriod := ResOfGanttTab.m_SumArrayforMonths[J - 1].m_StartOfPeriod_Month;
          EndPeriod := ResOfGanttTab.m_SumArrayforMonths[J - 1].m_EndOfPeriod_Month;
          if (EndPeriod - 31) > (ResOfGanttTab.m_ScheduleStatistics.getHieghestEndDateJob) then
             break;

          TabSectionTitle := IntToStr(MonthOfTheYear(StartPeriod))
        end;

      end;

      TabPeriod := TabSheetPeriod.CreateTabShiitStatisticsPeriod(PgcStatistics_Period, StartPeriod, EndPeriod);
    //  TabPeriod.Caption := DateToStr(StartPeriod) + '-' + DateToStr(EndPeriod);
      TabPeriod.Caption := TabSectionTitle;

      with TabPeriod do
      begin
        panelTitle := TPanel.Create(TabPeriod);
        panelTitle.parent := TabPeriod;
        panelTitle.Height := 60;
        panelTitle.Align := alTop;
        panelTitle.Name  := 'PanelTitle';
        panelTitle.caption := '';

        PanelData := TPanel.Create(TabPeriod);
        PanelData.parent := TabPeriod;
        PanelData.Align := alClient;

        ScrollBox := TScrollBox.Create(PanelData);
        ScrollBox.parent := TabPeriod;
        ScrollBox.Align := alClient;

        staticText1 := TcxTextEdit.Create(panelTitle);
        staticText1.Name := 'staticText1';
        staticText1.parent := panelTitle;
        SetComponent(staticText1, comp_Descr, false);
    //    staticText1.color := TiTleColor;
        if J = 1 then
          staticText1.Style.Color := TiTleColor//clWhite//clGradientInactiveCaption
        else
          staticText1.Style.Color := 14540253;//14540287;

        staticText1.top := 14;
        staticText1.width := 160;
        staticText1.Left := 200;
        staticText1.height := 25;
        if m_ShowOnly then
          staticText1.Text := GetSetScheduleStatisticName(0)
        else
          staticText1.Text := '';// ' ' + '(1) - ' + TimeToStr(Frac(ResOfGanttTab.m_DatetimeCreate));
        staticText1.Style.Font.Size := 10;


        // data definitions

        // --- "Number of relevant jobs" = scheduled jobs counted by end date (the delay denominator). ---
        NumRelevantJobs_Lbl := TLabel.Create(ScrollBox);
        NumRelevantJobs_Lbl.Parent := ScrollBox;
        NumRelevantJobs_Lbl.top    := staticText1.top;
        NumRelevantJobs_Lbl.Left   := 20;
        NumRelevantJobs_Lbl.Caption := 'Number of jobs ending in the period';

        ST_NumRelevantJobs_1 := TcxTextEdit.Create(ScrollBox);
        ST_NumRelevantJobs_1.Parent := ScrollBox;
        ST_NumRelevantJobs_1.top    := staticText1.top;
        ST_NumRelevantJobs_1.ParentColor := False;
        SetComponent(ST_NumRelevantJobs_1, comp_Descr, false);
        ST_NumRelevantJobs_1.Style.Color := MaxDaysDelay_Color;
        ST_NumRelevantJobs_1.Left   := NumRelevantJobs_Lbl.Left + 200;
        ST_NumRelevantJobs_1.Width  := 90;
        ST_NumRelevantJobs_1.Height := 25;
        ST_NumRelevantJobs_1.Style.Font.Size := 10;

        if J = 1 then
          ST_NumRelevantJobs_1.Text := IntToStr(ResOfGanttTab.m_SumTotalPeriod.m_NumberOfJobs_Total_ForDelayCalc)
        else if IsWeekly then
          ST_NumRelevantJobs_1.Text := IntToStr(ResOfGanttTab.m_SumArrayforWeeks[J - 1].m_NumberOfJobs_Total_ForDelayCalc)
        else
          ST_NumRelevantJobs_1.Text := IntToStr(ResOfGanttTab.m_SumArrayforMonths[J - 1].m_NumberOfJobs_Total_ForDelayCalc);

        // --- "Number of jobs in delay" (replaces the old Min/Max/Total days-in-delay rows).
        //     Field names ST_MinDaysDelay_* / MinDaysDelay_Lbl are reused for this count row. ---
        MinDaysDelay_Lbl := TLabel.Create(ScrollBox);
        MinDaysDelay_Lbl.Parent := ScrollBox;
        MinDaysDelay_Lbl.top    := staticText1.top + 40;
        MinDaysDelay_Lbl.Left   := 20;
        MinDaysDelay_Lbl.Caption := 'Jobs delivering late';

        ST_MinDaysDelay_1 := TcxTextEdit.Create(ScrollBox);
        ST_MinDaysDelay_1.Parent := ScrollBox;
        ST_MinDaysDelay_1.top    := staticText1.top + 40;
        ST_MinDaysDelay_1.ParentColor := False;
        SetComponent(ST_MinDaysDelay_1, comp_Descr, false);
        ST_MinDaysDelay_1.Style.Color := MinDaysDelay_Color;//BackGroundcolor1;
        ST_MinDaysDelay_1.Left   := MinDaysDelay_Lbl.Left + 200;
        ST_MinDaysDelay_1.Width  := 90;
        ST_MinDaysDelay_1.Height := 25;
        ST_MinDaysDelay_1.Style.Font.Size := 10;
        ST_MinDaysDelay_1.ShowHint := true;
        ST_MinDaysDelay_1.Hint    := 'Jobs ending after planned date. Job is counted only at the ending date.';


        if J = 1 then
          ST_MinDaysDelay_1.Text := IntToStr(ResOfGanttTab.m_SumTotalPeriod.m_NumberOfJobsDelay)
        else
        begin
          if IsWeekly then
            ST_MinDaysDelay_1.Text := IntToStr(ResOfGanttTab.m_SumArrayforWeeks[J - 1].m_NumberOfJobsDelay)
          else
            ST_MinDaysDelay_1.Text := IntToStr(ResOfGanttTab.m_SumArrayforMonths[J - 1].m_NumberOfJobsDelay);
        end;

        // "Show breakdown" button - one combined grid (bands x schedules). The per-schedule data is
        // resolved at click time from the period context stored below, so comparison works automatically.
        // own row below the "% of jobs in delay" row, so it never collides with comparison columns
        ST_DelayBandsShow := TButtonShowDetails.Create(ScrollBox);
        ST_DelayBandsShow.Parent := ScrollBox;
        ST_DelayBandsShow.top    := MinDaysDelay_Lbl.top + 70; // just below the "% of jobs in delay" row
        ST_DelayBandsShow.Left   := MinDaysDelay_Lbl.Left;     // aligned under the % text
        ST_DelayBandsShow.Width  := 100;
        ST_DelayBandsShow.Height := 28;
        ST_DelayBandsShow.Font.Size := 10;
        ST_DelayBandsShow.Caption := 'Breakdown';
        ST_DelayBandsShow.OnClick := OnClickDelayBands;
        ST_DelayBandsShow.ShowHint := true;
        ST_DelayBandsShow.Hint    := 'Breakdown of late jobs by days';
        ST_DelayBandsShow.m_DelayPeriodIndex := J;
        ST_DelayBandsShow.m_DelayIsWeekly    := IsWeekly;
        ST_DelayBandsShow.m_DelayGanttName   := ResOfGanttTab.m_ganttTabName;
        if J = 1 then
          ST_DelayBandsShow.m_DelayTitle := TabSectionTitle
        else if IsWeekly then
          ST_DelayBandsShow.m_DelayTitle := 'Week ' + TabSectionTitle
        else
          ST_DelayBandsShow.m_DelayTitle := 'Month ' + TabSectionTitle;

        PercentOfJobsIndelay_Lbl := TLabel.Create(ScrollBox);
        PercentOfJobsIndelay_Lbl.Parent := ScrollBox;
        PercentOfJobsIndelay_Lbl.top    := MinDaysDelay_Lbl.top + 40;
        PercentOfJobsIndelay_Lbl.Left   := 20;
        PercentOfJobsIndelay_Lbl.Caption := '% of jobs in delay';

        ST_PercentOfJobsIndelay_1 := TcxTextEdit.Create(ScrollBox);
        ST_PercentOfJobsIndelay_1.Parent := ScrollBox;
        ST_PercentOfJobsIndelay_1.top    := MinDaysDelay_Lbl.top + 38;
        SetComponent(ST_PercentOfJobsIndelay_1, comp_Descr, false);
        ST_PercentOfJobsIndelay_1.Style.Color := PercentOfJobsIndelay_Color;
        ST_PercentOfJobsIndelay_1.Left   := PercentOfJobsIndelay_Lbl.Left + 200;
        ST_PercentOfJobsIndelay_1.Width  := 90;
        ST_PercentOfJobsIndelay_1.Height := 25;
        ST_PercentOfJobsIndelay_1.Style.Font.Size := 10;

        if J = 1 then
        begin
          if ResOfGanttTab.m_SumTotalPeriod.PercentOfJobsIndelay > 0 then
            ST_PercentOfJobsIndelay_1.Text := FloatToStr(ResOfGanttTab.m_SumTotalPeriod.PercentOfJobsIndelay) + '%'
        end
        else
        begin
          if IsWeekly then
          begin
            if ResOfGanttTab.m_SumArrayforWeeks[J - 1].PercentOfJobsIndelay > 0 then
              ST_PercentOfJobsIndelay_1.Text := FloatToStr(ResOfGanttTab.m_SumArrayforWeeks[J - 1].PercentOfJobsIndelay) + '%'
          end
          else
          begin
            if ResOfGanttTab.m_SumArrayforMonths[J - 1].PercentOfJobsIndelay > 0 then
              ST_PercentOfJobsIndelay_1.Text := FloatToStr(ResOfGanttTab.m_SumArrayforMonths[J - 1].PercentOfJobsIndelay) + '%';
          end;
        end;

        // --- "Jobs delivering early" (replaces the old Min/Max/Total days-too-early rows).
        //     Field names ST_MinDaysTooEarly_* / MinDaysTooEarly_Lbl are reused for this count row. ---
        MinDaysTooEarly_Lbl := TLabel.Create(ScrollBox);
        MinDaysTooEarly_Lbl.Parent := ScrollBox;
        MinDaysTooEarly_Lbl.top    := PercentOfJobsIndelay_Lbl.top + 80; // leave a row for the delay Show-breakdown button
        MinDaysTooEarly_Lbl.Left   := 20;
        MinDaysTooEarly_Lbl.Caption := 'Jobs delivering early';

        ST_MinDaysTooEarly_1 := TcxTextEdit.Create(ScrollBox);
        ST_MinDaysTooEarly_1.Parent := ScrollBox;
        ST_MinDaysTooEarly_1.top    := PercentOfJobsIndelay_Lbl.top + 78;
        ST_MinDaysTooEarly_1.ParentColor := False;
        SetComponent(ST_MinDaysTooEarly_1, comp_Descr, false);
        ST_MinDaysTooEarly_1.Style.Color := MinDaysTooEarly_Color;
        ST_MinDaysTooEarly_1.Left   := MinDaysTooEarly_Lbl.Left + 200;
        ST_MinDaysTooEarly_1.Width  := 90;
        ST_MinDaysTooEarly_1.Height := 25;
        ST_MinDaysTooEarly_1.Style.Font.Size := 10;
        ST_MinDaysTooEarly_1.ShowHint := true;
        ST_MinDaysTooEarly_1.Hint    := 'Jobs ending before planned date. Job is counted only at the ending date. Less then a day is not considered.';

        if J = 1 then
          ST_MinDaysTooEarly_1.Text := IntToStr(ResOfGanttTab.m_SumTotalPeriod.m_NumberOfJobsEarly)
        else
        begin
          if IsWeekly then
            ST_MinDaysTooEarly_1.Text := IntToStr(ResOfGanttTab.m_SumArrayforWeeks[J - 1].m_NumberOfJobsEarly)
          else
            ST_MinDaysTooEarly_1.Text := IntToStr(ResOfGanttTab.m_SumArrayforMonths[J - 1].m_NumberOfJobsEarly);
        end;

        // "Show early breakdown" button - one combined grid (bands x schedules), resolved at click time.
        // own row below the "% of jobs early" row, so it never collides with comparison columns
        ST_EarlyBandsShow := TButtonShowDetails.Create(ScrollBox);
        ST_EarlyBandsShow.Parent := ScrollBox;
        ST_EarlyBandsShow.top    := MinDaysTooEarly_Lbl.top + 70; // just below the "% of jobs early" row
        ST_EarlyBandsShow.Left   := MinDaysTooEarly_Lbl.Left;     // aligned under the % text
        ST_EarlyBandsShow.Width  := 100;
        ST_EarlyBandsShow.Height := 28;
        ST_EarlyBandsShow.Font.Size := 10;
        ST_EarlyBandsShow.Caption := 'Breakdown';
        ST_EarlyBandsShow.OnClick := OnClickDelayBands;
        ST_EarlyBandsShow.ShowHint := true;
        ST_EarlyBandsShow.Hint    := 'Breakdown of earlier jobs by days';
        ST_EarlyBandsShow.m_DelayPeriodIndex := J;
        ST_EarlyBandsShow.m_DelayIsWeekly    := IsWeekly;
        ST_EarlyBandsShow.m_DelayIsEarly     := true;
        ST_EarlyBandsShow.m_DelayGanttName   := ResOfGanttTab.m_ganttTabName;
        if J = 1 then
          ST_EarlyBandsShow.m_DelayTitle := TabSectionTitle
        else if IsWeekly then
          ST_EarlyBandsShow.m_DelayTitle := 'Week ' + TabSectionTitle
        else
          ST_EarlyBandsShow.m_DelayTitle := 'Month ' + TabSectionTitle;

        PercentOfJobsTooEarly_Lbl := TLabel.Create(ScrollBox);
        PercentOfJobsTooEarly_Lbl.Parent := ScrollBox;
        PercentOfJobsTooEarly_Lbl.top    := MinDaysTooEarly_Lbl.top + 40;
        PercentOfJobsTooEarly_Lbl.Left   := 20;
        PercentOfJobsTooEarly_Lbl.Caption := '% of jobs early';

        ST_PercentOfJobsTooEarly_1 := TcxTextEdit.Create(ScrollBox);
        ST_PercentOfJobsTooEarly_1.Parent := ScrollBox;
        ST_PercentOfJobsTooEarly_1.top    := MinDaysTooEarly_Lbl.top + 38;
        SetComponent(ST_PercentOfJobsTooEarly_1, comp_Descr, false);
        ST_PercentOfJobsTooEarly_1.Style.Color := PercentOfJobsTooEarly_Color;
        ST_PercentOfJobsTooEarly_1.Left   := PercentOfJobsTooEarly_Lbl.Left + 200;
        ST_PercentOfJobsTooEarly_1.Width  := 90;
        ST_PercentOfJobsTooEarly_1.Height := 25;
        ST_PercentOfJobsTooEarly_1.Style.Font.Size := 10;

        // % early = early jobs / scheduled-jobs-in-period * 100 (same denominator as % in delay)
        if J = 1 then
        begin
          if (ResOfGanttTab.m_SumTotalPeriod.m_NumberOfJobs_Total_ForDelayCalc > 0) and
             (ResOfGanttTab.m_SumTotalPeriod.m_NumberOfJobsEarly > 0) then
            ST_PercentOfJobsTooEarly_1.Text := FormatFloat('0.0', ResOfGanttTab.m_SumTotalPeriod.m_NumberOfJobsEarly /
                                                          ResOfGanttTab.m_SumTotalPeriod.m_NumberOfJobs_Total_ForDelayCalc * 100) + '%'
        end
        else
        begin
          if IsWeekly then
          begin
            if (ResOfGanttTab.m_SumArrayforWeeks[J - 1].m_NumberOfJobs_Total_ForDelayCalc > 0) and
               (ResOfGanttTab.m_SumArrayforWeeks[J - 1].m_NumberOfJobsEarly > 0) then
              ST_PercentOfJobsTooEarly_1.Text := FormatFloat('0.0', ResOfGanttTab.m_SumArrayforWeeks[J - 1].m_NumberOfJobsEarly /
                                                            ResOfGanttTab.m_SumArrayforWeeks[J - 1].m_NumberOfJobs_Total_ForDelayCalc * 100) + '%'
          end
          else
          begin
            if (ResOfGanttTab.m_SumArrayforMonths[J - 1].m_NumberOfJobs_Total_ForDelayCalc > 0) and
               (ResOfGanttTab.m_SumArrayforMonths[J - 1].m_NumberOfJobsEarly > 0) then
              ST_PercentOfJobsTooEarly_1.Text := FormatFloat('0.0', ResOfGanttTab.m_SumArrayforMonths[J - 1].m_NumberOfJobsEarly /
                                                            ResOfGanttTab.m_SumArrayforMonths[J - 1].m_NumberOfJobs_Total_ForDelayCalc * 100) + '%';
          end;
        end;

        TotalSetupHours_Lbl := TLabel.Create(ScrollBox);
        TotalSetupHours_Lbl.Parent := ScrollBox;
        TotalSetupHours_Lbl.top    := PercentOfJobsTooEarly_Lbl.top + 280; // after total execution
        TotalSetupHours_Lbl.Left   := 20;
        TotalSetupHours_Lbl.Caption := 'Total setup hours';

        ST_TotalSetupHours_1 := TcxTextEdit.Create(ScrollBox);
        ST_TotalSetupHours_1.Parent := ScrollBox;
        ST_TotalSetupHours_1.top    := PercentOfJobsTooEarly_Lbl.top + 278;
        SetComponent(St_TotalSetupHours_1, comp_Descr, false);
        St_TotalSetupHours_1.Style.color := TotalSetupHours_Color;
        ST_TotalSetupHours_1.Left   := TotalSetupHours_Lbl.Left + 200;
        ST_TotalSetupHours_1.Width  := 90;
        ST_TotalSetupHours_1.Height := 25;
        ST_TotalSetupHours_1.Style.Font.Size := 10;

        if J = 1 then
          TotSetupHours := ResOfGanttTab.m_SumTotalPeriod.TotalSetupHours
        else
        begin
          if IsWeekly then
            TotSetupHours := ResOfGanttTab.m_SumArrayforWeeks[J - 1].TotalSetupHours
          else
            TotSetupHours := ResOfGanttTab.m_SumArrayforMonths[J - 1].TotalSetupHours;
        end;

        TempExt := Frac(TotSetupHours);
        S := FloatToStr(TempExt);
        if Length(S) > 3 then
        begin
          S := Copy(s, 2, 3);
          TotSetupHoursStr := FloatToStr(trunc(TotSetupHours));
          TotSetupHoursStr := TotSetupHoursStr + S;
        end
        else
          TotSetupHoursStr := FloatToStr(TotSetupHours);

        ST_TotalSetupHours_1.Text := TotSetupHoursStr;

        PercentOfSetupHours_Lbl := TLabel.Create(ScrollBox);
        PercentOfSetupHours_Lbl.Parent := ScrollBox;
        PercentOfSetupHours_Lbl.top    := TotalSetupHours_Lbl.top + 40;
        PercentOfSetupHours_Lbl.Left   := 20;
        PercentOfSetupHours_Lbl.Caption := '% setup out of total hours'; // setup / (setup + execution) * 100

        ST_PercentOfSetupHours_1 := TcxTextEdit.Create(ScrollBox);
        ST_PercentOfSetupHours_1.Parent := ScrollBox;
        ST_PercentOfSetupHours_1.top    := TotalSetupHours_Lbl.top + 38;
        SetComponent(St_PercentOfSetupHours_1, comp_Descr, false);
        St_PercentOfSetupHours_1.Style.color := PercentOfSetupHours_Color;
        ST_PercentOfSetupHours_1.Left   := PercentOfSetupHours_Lbl.Left + 200;
        ST_PercentOfSetupHours_1.Width  := 90;
        ST_PercentOfSetupHours_1.Height := 25;
        ST_PercentOfSetupHours_1.Style.Font.Size := 10;

        if J = 1 then
          Percent := ResOfGanttTab.m_SumTotalPeriod.PercentOfSetupHours
        else
        begin
          if IsWeekly then
            Percent := ResOfGanttTab.m_SumArrayforWeeks[J - 1].PercentOfSetupHours
          else
            Percent := ResOfGanttTab.m_SumArrayforMonths[J - 1].PercentOfSetupHours;
        end;

        TempExt := Frac(Percent);
        S := FloatToStr(TempExt);
        if Length(S) > 3 then
        begin
          S := Copy(s, 2, 3);
          PercentStr := FloatToStr(trunc(Percent));
          PercentStr := PercentStr + S;
        end
        else
          PercentStr := FloatToStr(Percent);

        ST_PercentOfSetupHours_1.Text := PercentStr + '%';

        TotalHoursExecution_Lbl := TLabel.Create(ScrollBox);
        TotalHoursExecution_Lbl.Parent := ScrollBox;
        TotalHoursExecution_Lbl.top    := PercentOfJobsTooEarly_Lbl.top + 240; // after the worst-compat block
        TotalHoursExecution_Lbl.Left   := 20;
        TotalHoursExecution_Lbl.Caption := 'Total execution hours';

        ST_TotalHoursExecution_1 := TcxTextEdit.Create(ScrollBox);
        ST_TotalHoursExecution_1.Parent := ScrollBox;
        ST_TotalHoursExecution_1.top    := PercentOfJobsTooEarly_Lbl.top + 238;
        SetComponent(St_TotalHoursExecution_1, comp_Descr, false);
        St_TotalHoursExecution_1.Style.Color := TotalHoursExecution_Color;
        ST_TotalHoursExecution_1.Left   := TotalHoursExecution_Lbl.Left + 200;
        ST_TotalHoursExecution_1.Width  := 90;
        ST_TotalHoursExecution_1.Height := 25;
        ST_TotalHoursExecution_1.Style.Font.Size := 10;

        if J = 1 then
          TotExecutionHours := ResOfGanttTab.m_SumTotalPeriod.TotalHoursExecution
        else
        begin
          if IsWeekly then
            TotExecutionHours := ResOfGanttTab.m_SumArrayforWeeks[J - 1].TotalHoursExecution
          else
            TotExecutionHours := ResOfGanttTab.m_SumArrayforMonths[J - 1].TotalHoursExecution;
        end;

        TempExt := Frac(TotExecutionHours);
        S := FloatToStr(TempExt);
        if Length(S) > 3 then
        begin
          S := Copy(s, 2, 3);
          TotExecutionHoursStr := FloatToStr(trunc(TotExecutionHours));
          TotExecutionHoursStr := TotExecutionHoursStr + S;
        end
        else
          TotExecutionHoursStr := FloatToStr(TotExecutionHours);

        ST_TotalHoursExecution_1.Text := TotExecutionHoursStr;

        TotalHoursOfOccPerGanttOcc_Lbl := TLabel.Create(ScrollBox);
        TotalHoursOfOccPerGanttOcc_Lbl.Parent := ScrollBox;
        TotalHoursOfOccPerGanttOcc_Lbl.top    := PercentOfSetupHours_Lbl.top + 40; // remaining section starts after % setup
        TotalHoursOfOccPerGanttOcc_Lbl.Left   := 20;
        TotalHoursOfOccPerGanttOcc_Lbl.Caption := 'Percent of occupation';

        ST_TotalHoursOfOccPerGanttOcc_1 := TcxTextEdit.Create(ScrollBox);
        ST_TotalHoursOfOccPerGanttOcc_1.Parent := ScrollBox;
        ST_TotalHoursOfOccPerGanttOcc_1.top    := PercentOfSetupHours_Lbl.top + 38;
        SetComponent(St_TotalHoursOfOccPerGanttOcc_1, comp_Descr, false);
        St_TotalHoursOfOccPerGanttOcc_1.Style.Color := TotalHoursOfOccPerGanttOcc_Color;
        ST_TotalHoursOfOccPerGanttOcc_1.Left   := TotalHoursOfOccPerGanttOcc_Lbl.Left + 200;
        ST_TotalHoursOfOccPerGanttOcc_1.Width  := 90;
        ST_TotalHoursOfOccPerGanttOcc_1.Height := 25;
        ST_TotalHoursOfOccPerGanttOcc_1.Style.Font.Size := 10;

        if J = 1 then
          PercentHoursPerOccMachine := ResOfGanttTab.m_SumTotalPeriod.PercentHoursOfOccPerGanttOcc
        else
        begin
          if IsWeekly then
            PercentHoursPerOccMachine := ResOfGanttTab.m_SumArrayforWeeks[J - 1].PercentHoursOfOccPerGanttOcc
          else
            PercentHoursPerOccMachine := ResOfGanttTab.m_SumArrayforMonths[J - 1].PercentHoursOfOccPerGanttOcc;
        end;

      {  TempExt := Frac(TotExecutionHoursPerOccMachine);
        S := FloatToStr(TempExt);
        if Length(S) > 3 then
        begin
          S := Copy(s, 2, 3);
          TotExecutionHoursPerOccMachineStr := FloatToStr(trunc(TotExecutionHoursPerOccMachine));
          TotExecutionHoursPerOccMachineStr := TotExecutionHoursPerOccMachineStr + S;
        end
        else
          TotExecutionHoursPerOccMachineStr := FloatToStr(TotExecutionHoursPerOccMachine);     }

        if PercentHoursPerOccMachine > 100 then
           PercentHoursPerOccMachine := 100;
        ST_TotalHoursOfOccPerGanttOcc_1.Text := FloatToStr(PercentHoursPerOccMachine) + '%';

      {  if J = 1 then
          ST_TotalHoursOfOccPerGanttOcc_1.Caption := FloatToStr(ResOfGanttTab.m_SumTotalPeriod.TotalHoursOfOccPerGanttOcc)
        else
        begin
          if IsWeekly then
            ST_TotalHoursOfOccPerGanttOcc_1.Caption := FloatToStr(ResOfGanttTab.m_SumArrayforWeeks[J - 1].TotalHoursOfOccPerGanttOcc)
          else
            ST_TotalHoursOfOccPerGanttOcc_1.Caption := FloatToStr(ResOfGanttTab.m_SumArrayforMonths[J - 1].TotalHoursOfOccPerGanttOcc);
        end; }

        // "Worst job to resource compatability" = highest (worst) compatibility case among jobs ending in the period.
        MaxCaseForResource_Lbl := TLabel.Create(ScrollBox);
        MaxCaseForResource_Lbl.Parent := ScrollBox;
        MaxCaseForResource_Lbl.top    := PercentOfJobsTooEarly_Lbl.top + 80; // worst-compat block moved up, right after the early breakdown button
        MaxCaseForResource_Lbl.Left   := 20;
        MaxCaseForResource_Lbl.Caption := 'Worst job to resource compatability';

        ST_MaxCaseForResource_1 := TcxTextEdit.Create(ScrollBox);
        ST_MaxCaseForResource_1.Parent := ScrollBox;
        ST_MaxCaseForResource_1.top    := PercentOfJobsTooEarly_Lbl.top + 78;
        SetComponent(St_MaxCaseForResource_1, comp_Descr, false);
        St_MaxCaseForResource_1.Style.Color := MaxCaseForResource_Color;
        ST_MaxCaseForResource_1.Left   := MaxCaseForResource_Lbl.Left + 200;
        ST_MaxCaseForResource_1.Width  := 90;
        ST_MaxCaseForResource_1.Height := 25;
        ST_MaxCaseForResource_1.Style.Font.Size := 10;

        if J = 1 then
          ST_MaxCaseForResource_1.Text := FloatToStr(ResOfGanttTab.m_SumTotalPeriod.MaxCaseForResource)
        else
        begin
          if IsWeekly then
            ST_MaxCaseForResource_1.Text := FloatToStr(ResOfGanttTab.m_SumArrayforWeeks[J - 1].MaxCaseForResource)
          else
            ST_MaxCaseForResource_1.Text := FloatToStr(ResOfGanttTab.m_SumArrayforMonths[J - 1].MaxCaseForResource);
        end;

        PercentOfjobsCaseForEachResCase_Lbl := TLabel.Create(ScrollBox);
        PercentOfjobsCaseForEachResCase_Lbl.Parent := ScrollBox;
        PercentOfjobsCaseForEachResCase_Lbl.top    := MaxCaseForResource_Lbl.top + 40;
        PercentOfjobsCaseForEachResCase_Lbl.Left   := 20;
        PercentOfjobsCaseForEachResCase_Lbl.Caption := ''; // label text removed; the Breakdown button takes this spot

        ST_PercentOfjobsCaseForEachResCase_1 := TButtonShowDetails.Create(ScrollBox);
        ST_PercentOfjobsCaseForEachResCase_1.Parent := ScrollBox;
        ST_PercentOfjobsCaseForEachResCase_1.top    := MaxCaseForResource_Lbl.top + 38;
        ST_PercentOfjobsCaseForEachResCase_1.Left   := PercentOfjobsCaseForEachResCase_Lbl.Left;
        ST_PercentOfjobsCaseForEachResCase_1.Width  := 100;
        ST_PercentOfjobsCaseForEachResCase_1.Height := 28;
        ST_PercentOfjobsCaseForEachResCase_1.Font.Size := 10;
        ST_PercentOfjobsCaseForEachResCase_1.Caption := 'Breakdown';
        ST_PercentOfjobsCaseForEachResCase_1.OnClick := OnClickCompactCasesRes;
        ST_PercentOfjobsCaseForEachResCase_1.ShowHint := true;
        ST_PercentOfjobsCaseForEachResCase_1.Hint    := 'breakdown by case of compatibility';
        ST_PercentOfjobsCaseForEachResCase_1.Font.Assign(ST_DelayBandsShow.Font); // match the delay/early breakdown buttons exactly

        if J = 1 then
        begin
          St_PercentOfjobsCaseForEachResCase_1.m_PercentOfjobsCaseForEachResCase := ResOfGanttTab.m_SumTotalPeriod.PercentOfjobsCaseForEachResCase;
          St_PercentOfjobsCaseForEachResCase_1.m_NumberOfJobs := ResOfGanttTab.m_SumTotalPeriod.m_NumberOfJobs_Total_ForResCase;
        end
        else
        begin
          if IsWeekly then
          begin
            St_PercentOfjobsCaseForEachResCase_1.m_PercentOfjobsCaseForEachResCase := ResOfGanttTab.m_SumArrayforWeeks[J - 1].PercentOfjobsCaseForEachResCase;
            St_PercentOfjobsCaseForEachResCase_1.m_NumberOfJobs := ResOfGanttTab.m_SumArrayforWeeks[J - 1].m_NumberOfJobs_Total_ForResCase
          end
          else
          begin
            St_PercentOfjobsCaseForEachResCase_1.m_PercentOfjobsCaseForEachResCase := ResOfGanttTab.m_SumArrayforMonths[J - 1].PercentOfjobsCaseForEachResCase;
            St_PercentOfjobsCaseForEachResCase_1.m_NumberOfJobs := ResOfGanttTab.m_SumArrayforMonths[J - 1].m_NumberOfJobs_Total_ForResCase;
          end;
        end;

        // "Worst job to job compatability" = highest (worst) job-to-job compatibility case among jobs ending in the period.
        MaxCaseJobToJob_Lbl := TLabel.Create(ScrollBox);
        MaxCaseJobToJob_Lbl.Parent := ScrollBox;
        MaxCaseJobToJob_Lbl.top    := PercentOfjobsCaseForEachResCase_Lbl.top + 40;
        MaxCaseJobToJob_Lbl.Left   := 20;
        MaxCaseJobToJob_Lbl.Caption := 'Worst job to job compatability';

        ST_MaxCaseJobToJob_1 := TcxTextEdit.Create(ScrollBox);
        ST_MaxCaseJobToJob_1.Parent := ScrollBox;
        ST_MaxCaseJobToJob_1.top    := PercentOfjobsCaseForEachResCase_Lbl.top + 38;
        SetComponent(ST_MaxCaseJobToJob_1, comp_Descr, false);
        ST_MaxCaseJobToJob_1.Style.Color := MaxCaseJobToJob_Color;
        ST_MaxCaseJobToJob_1.Left   := MaxCaseJobToJob_Lbl.Left + 200;
        ST_MaxCaseJobToJob_1.Width  := 90;
        ST_MaxCaseJobToJob_1.Height := 25;
        ST_MaxCaseJobToJob_1.Style.Font.Size := 10;

        if J = 1 then
          ST_MaxCaseJobToJob_1.Text := IntToStr(ResOfGanttTab.m_SumTotalPeriod.MaxCaseJobToJob)
        else
        begin
          if IsWeekly then
            ST_MaxCaseJobToJob_1.Text := IntToStr(ResOfGanttTab.m_SumArrayforWeeks[J - 1].MaxCaseJobToJob)
          else
            ST_MaxCaseJobToJob_1.Text := IntToStr(ResOfGanttTab.m_SumArrayforMonths[J - 1].MaxCaseJobToJob);
        end;

        PercentOfjobsCaseForEachJobToJobCase_Lbl := TLabel.Create(ScrollBox);
        PercentOfjobsCaseForEachJobToJobCase_Lbl.Parent := ScrollBox;
        PercentOfjobsCaseForEachJobToJobCase_Lbl.top    := MaxCaseJobToJob_Lbl.top + 40;
        PercentOfjobsCaseForEachJobToJobCase_Lbl.Left   := 20;
        PercentOfjobsCaseForEachJobToJobCase_Lbl.Caption := ''; // label text removed; the Breakdown button takes this spot

        ST_PercentOfjobsCaseForEachJobToJobCase_1 := TButtonShowDetails.Create(ScrollBox);
        ST_PercentOfjobsCaseForEachJobToJobCase_1.Parent := ScrollBox;
        ST_PercentOfjobsCaseForEachJobToJobCase_1.top    := MaxCaseJobToJob_Lbl.top + 38;
      //  SetComponent(ST_PercentOfjobsCaseForEachJobToJobCase_1, comp_Descr, false);
        ST_PercentOfjobsCaseForEachJobToJobCase_1.Left   := PercentOfjobsCaseForEachJobToJobCase_Lbl.Left;
        ST_PercentOfjobsCaseForEachJobToJobCase_1.Width  := 100;
        ST_PercentOfjobsCaseForEachJobToJobCase_1.Height := 28;
        ST_PercentOfjobsCaseForEachJobToJobCase_1.Font.Size := 10;
        ST_PercentOfjobsCaseForEachJobToJobCase_1.Caption := 'Breakdown';
        ST_PercentOfjobsCaseForEachJobToJobCase_1.OnClick := OnClickCompactCasesJobToJob;
        ST_PercentOfjobsCaseForEachJobToJobCase_1.ShowHint := true;
        ST_PercentOfjobsCaseForEachJobToJobCase_1.Hint    := 'breakdown by case of compatibility';
        ST_PercentOfjobsCaseForEachJobToJobCase_1.Font.Assign(ST_DelayBandsShow.Font); // match the delay/early breakdown buttons exactly

        if J = 1 then
        begin
          ST_PercentOfjobsCaseForEachJobToJobCase_1.m_PercentOfjobsCaseForEachJobToJobCase := ResOfGanttTab.m_SumTotalPeriod.PercentOfjobsCaseForEachJobToJobCase;
          ST_PercentOfjobsCaseForEachJobToJobCase_1.m_NumberOfJobs := ResOfGanttTab.m_SumTotalPeriod.m_NumberOfJobs_Total_ForJobToJobCase
        end
        else
        begin
          if IsWeekly then
          begin
            ST_PercentOfjobsCaseForEachJobToJobCase_1.m_PercentOfjobsCaseForEachJobToJobCase := ResOfGanttTab.m_SumArrayforWeeks[J - 1].PercentOfjobsCaseForEachJobToJobCase;
            ST_PercentOfjobsCaseForEachJobToJobCase_1.m_NumberOfJobs := ResOfGanttTab.m_SumArrayforWeeks[J - 1].m_NumberOfJobs_Total_ForJobToJobCase
          end
          else
          begin
            ST_PercentOfjobsCaseForEachJobToJobCase_1.m_PercentOfjobsCaseForEachJobToJobCase := ResOfGanttTab.m_SumArrayforMonths[J - 1].PercentOfjobsCaseForEachJobToJobCase;
            ST_PercentOfjobsCaseForEachJobToJobCase_1.m_NumberOfJobs := ResOfGanttTab.m_SumArrayforMonths[J - 1].m_NumberOfJobs_Total_ForJobToJobCase;
          end;
        end;

        NumberOfjobsWithoutMaterial_Lbl := TLabel.Create(ScrollBox);
        NumberOfjobsWithoutMaterial_Lbl.Parent := ScrollBox;
        NumberOfjobsWithoutMaterial_Lbl.top    := TotalHoursOfOccPerGanttOcc_Lbl.top + 40;
        NumberOfjobsWithoutMaterial_Lbl.Left   := 20;
        NumberOfjobsWithoutMaterial_Lbl.Caption := 'jobs without material ';

        ST_NumberOfjobsWithoutMaterial_1 := TcxTextEdit.Create(ScrollBox);
        ST_NumberOfjobsWithoutMaterial_1.Parent := ScrollBox;
        ST_NumberOfjobsWithoutMaterial_1.top    := TotalHoursOfOccPerGanttOcc_Lbl.top + 38;
        SetComponent(ST_NumberOfjobsWithoutMaterial_1, comp_Descr, false);
        ST_NumberOfjobsWithoutMaterial_1.Style.Color := NumberOfjobsWithoutMaterial_Color;
        ST_NumberOfjobsWithoutMaterial_1.Left   := PercentOfjobsCaseForEachJobToJobCase_Lbl.Left + 200;
        ST_NumberOfjobsWithoutMaterial_1.Width  := 90;
        ST_NumberOfjobsWithoutMaterial_1.Height := 25;
        ST_NumberOfjobsWithoutMaterial_1.Style.Font.Size := 10;

        if J = 1 then
          ST_NumberOfjobsWithoutMaterial_1.Text := IntToStr(ResOfGanttTab.m_SumTotalPeriod.NumberOfjobsWithoutMaterial)
        else
        begin
          if IsWeekly then
            ST_NumberOfjobsWithoutMaterial_1.Text := IntToStr(ResOfGanttTab.m_SumArrayforWeeks[J - 1].NumberOfjobsWithoutMaterial)
          else
            ST_NumberOfjobsWithoutMaterial_1.Text := IntToStr(ResOfGanttTab.m_SumArrayforMonths[J - 1].NumberOfjobsWithoutMaterial);
        end;

     {   NumberOfjobsWithoutTools_Lbl := TLabel.Create(ScrollBox);
        NumberOfjobsWithoutTools_Lbl.Parent := ScrollBox;
        NumberOfjobsWithoutTools_Lbl.top    := NumberOfjobsWithoutMaterial_Lbl.top + 40;
        NumberOfjobsWithoutTools_Lbl.Left   := 20;
        NumberOfjobsWithoutTools_Lbl.Caption := 'jobs without Tools ';

        ST_NumberOfjobsWithoutTools_1 := TcxTextEdit.Create(ScrollBox);
        ST_NumberOfjobsWithoutTools_1.Parent := ScrollBox;
        ST_NumberOfjobsWithoutTools_1.top    := NumberOfjobsWithoutMaterial_Lbl.top + 38;
        SetComponent(ST_NumberOfjobsWithoutTools_1, comp_Descr, false);
        ST_NumberOfjobsWithoutTools_1.Left   := NumberOfjobsWithoutMaterial_Lbl.Left + 200;
        ST_NumberOfjobsWithoutTools_1.Width  := 90;
        ST_NumberOfjobsWithoutTools_1.Height := 25;
        ST_NumberOfjobsWithoutTools_1.Font.Size := 10;

        if J = 1 then
          ST_NumberOfjobsWithoutTools_1.Caption := IntToStr(ResOfGanttTab.m_SumTotalPeriod.NumberOfjobsWithoutTools)
        else
        begin
          if IsWeekly then
            ST_NumberOfjobsWithoutTools_1.Caption := IntToStr(ResOfGanttTab.m_SumArrayforWeeks[J - 1].NumberOfjobsWithoutTools)
          else
            ST_NumberOfjobsWithoutTools_1.Caption := IntToStr(ResOfGanttTab.m_SumArrayforMonths[J - 1].NumberOfjobsWithoutTools);
        end;  }

        NumberOfjobsWithoutManPawer_Lbl := TLabel.Create(ScrollBox);
        NumberOfjobsWithoutManPawer_Lbl.Parent := ScrollBox;
        NumberOfjobsWithoutManPawer_Lbl.top    := NumberOfjobsWithoutMaterial_Lbl.top + 40;
        NumberOfjobsWithoutManPawer_Lbl.Left   := 20;
        NumberOfjobsWithoutManPawer_Lbl.Caption := 'jobs without Man Power ';

        ST_NumberOfjobsWithoutManPawer_1 := TcxTextEdit.Create(ScrollBox);
        ST_NumberOfjobsWithoutManPawer_1.Parent := ScrollBox;
        ST_NumberOfjobsWithoutManPawer_1.top    := NumberOfjobsWithoutMaterial_Lbl.top + 38;
        SetComponent(ST_NumberOfjobsWithoutManPawer_1, comp_Descr, false);
        ST_NumberOfjobsWithoutManPawer_1.Style.Color := NumberOfjobsWithoutManPawer_Color;
        ST_NumberOfjobsWithoutManPawer_1.Left   := NumberOfjobsWithoutManPawer_Lbl.Left + 200;
        ST_NumberOfjobsWithoutManPawer_1.Width  := 90;
        ST_NumberOfjobsWithoutManPawer_1.Height := 25;
        ST_NumberOfjobsWithoutManPawer_1.Style.Font.Size := 10;

        if J = 1 then
          ST_NumberOfjobsWithoutManPawer_1.Text := IntToStr(ResOfGanttTab.m_SumTotalPeriod.NumberOfjobsWithoutManPawer)
        else
        begin
          if IsWeekly then
            ST_NumberOfjobsWithoutManPawer_1.Text := IntToStr(ResOfGanttTab.m_SumArrayforWeeks[J - 1].NumberOfjobsWithoutManPawer)
          else
            ST_NumberOfjobsWithoutManPawer_1.Text := IntToStr(ResOfGanttTab.m_SumArrayforMonths[J - 1].NumberOfjobsWithoutManPawer);
        end;

        NumberOfjobsWithoutAnyAddRes_Lbl := TLabel.Create(ScrollBox);
        NumberOfjobsWithoutAnyAddRes_Lbl.Parent := ScrollBox;
        NumberOfjobsWithoutAnyAddRes_Lbl.top    := NumberOfjobsWithoutManPawer_Lbl.top + 40;
        NumberOfjobsWithoutAnyAddRes_Lbl.Left   := 20;
        NumberOfjobsWithoutAnyAddRes_Lbl.Caption := 'jobs without Additional resource ';

        ST_NumberOfjobsWithoutAnyAddRes_1 := TcxTextEdit.Create(ScrollBox);
        ST_NumberOfjobsWithoutAnyAddRes_1.Parent := ScrollBox;
        ST_NumberOfjobsWithoutAnyAddRes_1.top    := NumberOfjobsWithoutManPawer_Lbl.top + 38;
        SetComponent(ST_NumberOfjobsWithoutAnyAddRes_1, comp_Descr, false);
        ST_NumberOfjobsWithoutAnyAddRes_1.Style.Color := NumberOfjobsWithoutAnyAddRes_Color;
        ST_NumberOfjobsWithoutAnyAddRes_1.Left   := NumberOfjobsWithoutAnyAddRes_Lbl.Left + 200;
        ST_NumberOfjobsWithoutAnyAddRes_1.Width  := 90;
        ST_NumberOfjobsWithoutAnyAddRes_1.Height := 25;
        ST_NumberOfjobsWithoutAnyAddRes_1.Style.Font.Size := 10;

        if J = 1 then
          ST_NumberOfjobsWithoutAnyAddRes_1.Text := IntToStr(ResOfGanttTab.m_SumTotalPeriod.NumberOfjobsWithoutAnyAddRes)
        else
        begin
          if IsWeekly then
            ST_NumberOfjobsWithoutAnyAddRes_1.Text := IntToStr(ResOfGanttTab.m_SumArrayforWeeks[J - 1].NumberOfjobsWithoutAnyAddRes)
          else
            ST_NumberOfjobsWithoutAnyAddRes_1.Text := IntToStr(ResOfGanttTab.m_SumArrayforMonths[J - 1].NumberOfjobsWithoutAnyAddRes);
        end;

        TotalUomProduced_Lbl := TLabel.Create(ScrollBox);
        TotalUomProduced_Lbl.Parent := ScrollBox;
        TotalUomProduced_Lbl.top    := NumberOfjobsWithoutAnyAddRes_Lbl.top + 40;
        TotalUomProduced_Lbl.Left   := 20;
        TotalUomProduced_Lbl.Caption := 'Quantity produced by unit of measure';

        ST_TotalUomProduced_1 := TButtonShowDetails.Create(ScrollBox);
        ST_TotalUomProduced_1.Parent := ScrollBox;
        ST_TotalUomProduced_1.top    := TotalUomProduced_Lbl.top;// + 38;
      //  SetComponent(ST_TotalUomProduced_1, comp_Descr, false);
        ST_TotalUomProduced_1.font.Color := TotalUomProduced_Color;
        ST_TotalUomProduced_1.Left   := TotalUomProduced_Lbl.Left + 200;
        ST_TotalUomProduced_1.Width  := 90;
        ST_TotalUomProduced_1.Height := 25;
        ST_TotalUomProduced_1.Font.Size := 10;
        ST_TotalUomProduced_1.Caption := 'Show';
        ST_TotalUomProduced_1.OnClick := OnClickTotalUomProduced;
        ST_TotalUomProduced_1.ShowHint := true;
        ST_TotalUomProduced_1.Hint    := 'Show details';
        ST_TotalUomProduced_1.CustomHint := FMQMPlan.BalloonHint1;

        if J = 1 then
          ST_TotalUomProduced_1.m_ListUmQtyDetails := ResOfGanttTab.m_SumTotalPeriod.TotalUomProduced
        else
        begin
          if IsWeekly then
            ST_TotalUomProduced_1.m_ListUmQtyDetails := ResOfGanttTab.m_SumArrayforWeeks[J - 1].TotalUomProduced
          else
            ST_TotalUomProduced_1.m_ListUmQtyDetails := ResOfGanttTab.m_SumArrayforMonths[J - 1].TotalUomProduced;
        end;

        ScheduleStatistics_2 := TResOfGanttTab(GetStatisticOfGantTabByIndex(2, ResOfGanttTab.m_ganttTabName));
        if ScheduleStatistics_2 <> nil then
        begin
          staticText2 := TcxTextEdit.Create(panelTitle);
          staticText2.parent := panelTitle;
          SetComponent(staticText2, comp_Descr, false);
          if J = 1 then
            staticText2.Style.Color := TiTleColor//clGradientInactiveCaption
          else
            staticText2.Style.Color := 14540253;//14540287;
          staticText2.top := 14;
          staticText2.width := 160;
          staticText2.Left := staticText1.Left + 180;
          staticText2.height := 25;
        //  staticText2.Caption := ' ' + '(2) - ' + TimeToStr(Frac(ScheduleStatistics_2.m_DatetimeCreate));
          staticText2.Text := GetSetScheduleStatisticName(1);
        //  staticText2.Enabled := false;
          staticText2.Style.Font.Size := 10;

          // "Number of relevant jobs" for compared schedule 2
          ST_NumRelevantJobs_2 := TcxTextEdit.Create(ScrollBox);
          ST_NumRelevantJobs_2.Parent := ScrollBox;
          ST_NumRelevantJobs_2.top    := ST_NumRelevantJobs_1.Top;
          SetComponent(ST_NumRelevantJobs_2, comp_Descr, false);
          ST_NumRelevantJobs_2.Style.Color := MaxDaysDelay_Color;
          ST_NumRelevantJobs_2.Left   := ST_NumRelevantJobs_1.Left + 180;
          ST_NumRelevantJobs_2.Width  := 90;
          ST_NumRelevantJobs_2.Height := 25;
          ST_NumRelevantJobs_2.Style.Font.Size := 10;

          if J = 1 then
            ST_NumRelevantJobs_2.Text := IntToStr(ScheduleStatistics_2.m_SumTotalPeriod.m_NumberOfJobs_Total_ForDelayCalc)
          else if IsWeekly then
            ST_NumRelevantJobs_2.Text := IntToStr(ScheduleStatistics_2.m_SumArrayforWeeks[J-1].m_NumberOfJobs_Total_ForDelayCalc)
          else
            ST_NumRelevantJobs_2.Text := IntToStr(ScheduleStatistics_2.m_SumArrayforMonths[J-1].m_NumberOfJobs_Total_ForDelayCalc);

          // "Number of jobs in delay" for compared schedule 2 (reuses ST_MinDaysDelay_2)
          ST_MinDaysDelay_2 := TcxTextEdit.Create(ScrollBox);
          ST_MinDaysDelay_2.Parent := ScrollBox;
          ST_MinDaysDelay_2.top    := ST_MinDaysDelay_1.Top; ;
          SetComponent(ST_MinDaysDelay_2, comp_Descr, false);
          ST_MinDaysDelay_2.Style.Color := MinDaysDelay_Color;//BackGroundcolor1;
          ST_MinDaysDelay_2.Left   := ST_MinDaysDelay_1.Left + 180;
          ST_MinDaysDelay_2.Width  := 90;
          ST_MinDaysDelay_2.Height := 25;
          ST_MinDaysDelay_2.Style.Font.Size := 10;

          if J = 1 then
            ST_MinDaysDelay_2.Text := IntToStr(ScheduleStatistics_2.m_SumTotalPeriod.m_NumberOfJobsDelay)
          else if IsWeekly then
            ST_MinDaysDelay_2.Text := IntToStr(ScheduleStatistics_2.m_SumArrayforWeeks[J-1].m_NumberOfJobsDelay)
          else
            ST_MinDaysDelay_2.Text := IntToStr(ScheduleStatistics_2.m_SumArrayforMonths[J-1].m_NumberOfJobsDelay);

          ST_PercentOfJobsIndelay_2 := TcxTextEdit.Create(ScrollBox);
          ST_PercentOfJobsIndelay_2.Parent := ScrollBox;
          ST_PercentOfJobsIndelay_2.top    := ST_PercentOfJobsIndelay_1.Top;
          SetComponent(ST_PercentOfJobsIndelay_2, comp_Descr, false);
          ST_PercentOfJobsIndelay_2.Style.Color := PercentOfJobsIndelay_Color;
          ST_PercentOfJobsIndelay_2.Left   := ST_PercentOfJobsIndelay_1.Left + 180;
          ST_PercentOfJobsIndelay_2.Width  := 90;
          ST_PercentOfJobsIndelay_2.Height := 25;
          ST_PercentOfJobsIndelay_2.Style.Font.Size := 10;

          if J = 1 then
          begin
            if ScheduleStatistics_2.m_SumTotalPeriod.PercentOfJobsIndelay > 0 then
              ST_PercentOfJobsIndelay_2.Text := FloatToStr(ScheduleStatistics_2.m_SumTotalPeriod.PercentOfJobsIndelay) + '%';
          end
          else if IsWeekly then
          begin
            if ScheduleStatistics_2.m_SumArrayforWeeks[J-1].PercentOfJobsIndelay > 0 then
              ST_PercentOfJobsIndelay_2.Text := FloatToStr(ScheduleStatistics_2.m_SumArrayforWeeks[J-1].PercentOfJobsIndelay) + '%';
          end
          else
          begin
            if ScheduleStatistics_2.m_SumArrayforMonths[J-1].PercentOfJobsIndelay > 0 then
              ST_PercentOfJobsIndelay_2.Text := FloatToStr(ScheduleStatistics_2.m_SumArrayforMonths[J-1].PercentOfJobsIndelay) +  '%';
          end;

          ST_MinDaysTooEarly_2 := TcxTextEdit.Create(ScrollBox);
          ST_MinDaysTooEarly_2.Parent := ScrollBox;
          ST_MinDaysTooEarly_2.top    := ST_MinDaysTooEarly_1.Top;
          SetComponent(ST_MinDaysTooEarly_2, comp_Descr, false);
          ST_MinDaysTooEarly_2.Style.Color := MinDaysTooEarly_Color;
          ST_MinDaysTooEarly_2.Left   := ST_MinDaysTooEarly_1.Left + 180;
          ST_MinDaysTooEarly_2.Width  := 90;
          ST_MinDaysTooEarly_2.Height := 25;
          ST_MinDaysTooEarly_2.Style.Font.Size := 10;

          if J = 1 then
            ST_MinDaysTooEarly_2.Text := IntToStr(ScheduleStatistics_2.m_SumTotalPeriod.m_NumberOfJobsEarly)
          else if IsWeekly then
            ST_MinDaysTooEarly_2.Text := IntToStr(ScheduleStatistics_2.m_SumArrayforWeeks[J-1].m_NumberOfJobsEarly)
          else
            ST_MinDaysTooEarly_2.Text := IntToStr(ScheduleStatistics_2.m_SumArrayforMonths[J-1].m_NumberOfJobsEarly);

          ST_PercentOfJobsTooEarly_2 := TcxTextEdit.Create(ScrollBox);
          ST_PercentOfJobsTooEarly_2.Parent := ScrollBox;
          ST_PercentOfJobsTooEarly_2.top    := ST_PercentOfJobsTooEarly_1.top;// + 38;
          SetComponent(ST_PercentOfJobsTooEarly_2, comp_Descr, false);
          ST_PercentOfJobsTooEarly_2.Style.Color := PercentOfJobsTooEarly_Color;
          ST_PercentOfJobsTooEarly_2.Left   := ST_PercentOfJobsTooEarly_1.Left + + 180;
          ST_PercentOfJobsTooEarly_2.Width  := 90;
          ST_PercentOfJobsTooEarly_2.Height := 25;
          ST_PercentOfJobsTooEarly_2.Style.Font.Size := 10;

          if J = 1 then
          begin
            if (ScheduleStatistics_2.m_SumTotalPeriod.m_NumberOfJobs_Total_ForDelayCalc > 0) and
               (ScheduleStatistics_2.m_SumTotalPeriod.m_NumberOfJobsEarly > 0) then
              ST_PercentOfJobsTooEarly_2.Text := FormatFloat('0.0', ScheduleStatistics_2.m_SumTotalPeriod.m_NumberOfJobsEarly /
                                                            ScheduleStatistics_2.m_SumTotalPeriod.m_NumberOfJobs_Total_ForDelayCalc * 100) + '%'
          end
          else if IsWeekly then
          begin
            if (ScheduleStatistics_2.m_SumArrayforWeeks[J-1].m_NumberOfJobs_Total_ForDelayCalc > 0) and
               (ScheduleStatistics_2.m_SumArrayforWeeks[J-1].m_NumberOfJobsEarly > 0) then
              ST_PercentOfJobsTooEarly_2.Text := FormatFloat('0.0', ScheduleStatistics_2.m_SumArrayforWeeks[J-1].m_NumberOfJobsEarly /
                                                            ScheduleStatistics_2.m_SumArrayforWeeks[J-1].m_NumberOfJobs_Total_ForDelayCalc * 100) + '%'
          end
          else
          begin
            if (ScheduleStatistics_2.m_SumArrayforMonths[J-1].m_NumberOfJobs_Total_ForDelayCalc > 0) and
               (ScheduleStatistics_2.m_SumArrayforMonths[J-1].m_NumberOfJobsEarly > 0) then
            ST_PercentOfJobsTooEarly_2.Text := FormatFloat('0.0', ScheduleStatistics_2.m_SumArrayforMonths[J-1].m_NumberOfJobsEarly /
                                                          ScheduleStatistics_2.m_SumArrayforMonths[J-1].m_NumberOfJobs_Total_ForDelayCalc * 100) + '%';
          end;

          ST_TotalSetupHours_2 := TcxTextEdit.Create(ScrollBox);
          ST_TotalSetupHours_2.Parent := ScrollBox;
          ST_TotalSetupHours_2.top    := ST_TotalSetupHours_1.top;// + 38;
          SetComponent(ST_TotalSetupHours_2, comp_Descr, false);
          St_TotalSetupHours_2.Style.color := TotalSetupHours_Color;
          ST_TotalSetupHours_2.Left   := ST_TotalSetupHours_1.Left + 180;
          ST_TotalSetupHours_2.Width  := 90;
          ST_TotalSetupHours_2.Height := 25;
          ST_TotalSetupHours_2.Style.Font.Size := 10;

          if J = 1 then
            TotSetupHours := ScheduleStatistics_2.m_SumTotalPeriod.TotalSetupHours
          else
          begin
            if IsWeekly then
              TotSetupHours := ScheduleStatistics_2.m_SumArrayforWeeks[J - 1].TotalSetupHours
            else
              TotSetupHours := ScheduleStatistics_2.m_SumArrayforMonths[J - 1].TotalSetupHours;
          end;

          TempExt := Frac(TotSetupHours);
          S := FloatToStr(TempExt);
          if Length(S) > 3 then
          begin
            S := Copy(s, 2, 3);
            TotSetupHoursStr := FloatToStr(trunc(TotSetupHours));
            TotSetupHoursStr := TotSetupHoursStr + S;
          end
          else
            TotSetupHoursStr := FloatToStr(TotSetupHours);

          ST_TotalSetupHours_2.Text := TotSetupHoursStr;

{          if J = 1 then
            ST_TotalSetupHours_2.Caption := FloatToStr(ScheduleStatistics_2.m_SumTotalPeriod.TotalSetupHours)
          else if IsWeekly then
            ST_TotalSetupHours_2.Caption := FloatToStr(ScheduleStatistics_2.m_SumArrayforWeeks[J-1].TotalSetupHours)
          else
            ST_TotalSetupHours_2.Caption := FloatToStr(ScheduleStatistics_2.m_SumArrayforMonths[J-1].TotalSetupHours);
 }
          ST_PercentOfSetupHours_2 := TcxTextEdit.Create(ScrollBox);
          ST_PercentOfSetupHours_2.Parent := ScrollBox;
          ST_PercentOfSetupHours_2.top    := ST_PercentOfSetupHours_1.top; //+ 38;
          SetComponent(St_PercentOfSetupHours_2, comp_Descr, false);
          St_PercentOfSetupHours_2.Style.color := PercentOfSetupHours_Color;
          ST_PercentOfSetupHours_2.Left   := ST_PercentOfSetupHours_1.Left + 180;
          ST_PercentOfSetupHours_2.Width  := 90;
          ST_PercentOfSetupHours_2.Height := 25;
          ST_PercentOfSetupHours_2.Style.Font.Size := 10;

{          if J = 1 then
            ST_PercentOfSetupHours_2.Caption := FloatToStr(ScheduleStatistics_2.m_SumTotalPeriod.PercentOfSetupHours)
          else if IsWeekly then
            ST_PercentOfSetupHours_2.Caption := FloatToStr(ScheduleStatistics_2.m_SumArrayforWeeks[J-1].PercentOfSetupHours)
          else
            ST_PercentOfSetupHours_2.Caption := FloatToStr(ScheduleStatistics_2.m_SumArrayforMonths[J-1].PercentOfSetupHours);
 }
          if J = 1 then
            Percent := ScheduleStatistics_2.m_SumTotalPeriod.PercentOfSetupHours
          else
          begin
            if IsWeekly then
              Percent := ScheduleStatistics_2.m_SumArrayforWeeks[J - 1].PercentOfSetupHours
            else
              Percent := ScheduleStatistics_2.m_SumArrayforMonths[J - 1].PercentOfSetupHours;
          end;

          TempExt := Frac(Percent);
          S := FloatToStr(TempExt);
          if Length(S) > 3 then
          begin
            S := Copy(s, 2, 3);
            PercentStr := FloatToStr(trunc(Percent));
            PercentStr := PercentStr + S;
          end
          else
            PercentStr := FloatToStr(Percent);

          ST_PercentOfSetupHours_2.Text := PercentStr + '%';

          ST_TotalHoursExecution_2 := TcxTextEdit.Create(ScrollBox);
          ST_TotalHoursExecution_2.Parent := ScrollBox;
          ST_TotalHoursExecution_2.top    := ST_TotalHoursExecution_1.top;// + 38;
          SetComponent(St_TotalHoursExecution_2, comp_Descr, false);
          St_TotalHoursExecution_2.Style.Color := TotalHoursExecution_Color;
          ST_TotalHoursExecution_2.Left   := ST_TotalHoursExecution_1.Left + 180;
          ST_TotalHoursExecution_2.Width  := 90;
          ST_TotalHoursExecution_2.Height := 25;
          ST_TotalHoursExecution_2.Style.Font.Size := 10;

          if J = 1 then
            TotExecutionHours := ScheduleStatistics_2.m_SumTotalPeriod.TotalHoursExecution
          else
          begin
            if IsWeekly then
              TotExecutionHours := ScheduleStatistics_2.m_SumArrayforWeeks[J - 1].TotalHoursExecution
            else
              TotExecutionHours := ScheduleStatistics_2.m_SumArrayforMonths[J - 1].TotalHoursExecution;
          end;

          TempExt := Frac(TotExecutionHours);
          S := FloatToStr(TempExt);
          if Length(S) > 3 then
          begin
            S := Copy(s, 2, 3);
            TotExecutionHoursStr := FloatToStr(trunc(TotExecutionHours));
            TotExecutionHoursStr := TotExecutionHoursStr + S;
          end
          else
            TotExecutionHoursStr := FloatToStr(TotExecutionHours);

          ST_TotalHoursExecution_2.Text := TotExecutionHoursStr;

          ST_TotalHoursOfOccPerGanttOcc_2 := TcxTextEdit.Create(ScrollBox);
          ST_TotalHoursOfOccPerGanttOcc_2.Parent := ScrollBox;
          ST_TotalHoursOfOccPerGanttOcc_2.top    := ST_TotalHoursOfOccPerGanttOcc_1.top;// + 38;
          SetComponent(St_TotalHoursOfOccPerGanttOcc_2, comp_Descr, false);
          St_TotalHoursOfOccPerGanttOcc_2.Style.Color := TotalHoursOfOccPerGanttOcc_Color;
          ST_TotalHoursOfOccPerGanttOcc_2.Left   := ST_TotalHoursOfOccPerGanttOcc_1.Left + 180;
          ST_TotalHoursOfOccPerGanttOcc_2.Width  := 90;
          ST_TotalHoursOfOccPerGanttOcc_2.Height := 25;
          ST_TotalHoursOfOccPerGanttOcc_2.Style.Font.Size := 10;


         if J = 1 then
           PercentHoursPerOccMachine := ScheduleStatistics_2.m_SumTotalPeriod.PercentHoursOfOccPerGanttOcc
          else
          begin
            if IsWeekly then
              PercentHoursPerOccMachine := ScheduleStatistics_2.m_SumArrayforWeeks[J - 1].PercentHoursOfOccPerGanttOcc
            else
              PercentHoursPerOccMachine := ScheduleStatistics_2.m_SumArrayforMonths[J - 1].PercentHoursOfOccPerGanttOcc;
          end;


          if PercentHoursPerOccMachine > 100 then
             PercentHoursPerOccMachine := 100;
          ST_TotalHoursOfOccPerGanttOcc_2.Text := FloatToStr(PercentHoursPerOccMachine) + '%';

          ST_MaxCaseForResource_2 := TcxTextEdit.Create(ScrollBox);
          ST_MaxCaseForResource_2.Parent := ScrollBox;
          ST_MaxCaseForResource_2.top    := ST_MaxCaseForResource_1.top; //+ 38;
          SetComponent(St_MaxCaseForResource_2, comp_Descr, false);
          St_MaxCaseForResource_2.Style.Color := MaxCaseForResource_Color;
          ST_MaxCaseForResource_2.Left   := ST_MaxCaseForResource_1.Left + 180;
          ST_MaxCaseForResource_2.Width  := 90;
          ST_MaxCaseForResource_2.Height := 25;
          ST_MaxCaseForResource_2.Style.Font.Size := 10;

          if J = 1 then
            ST_MaxCaseForResource_2.Text := FloatToStr(ScheduleStatistics_2.m_SumTotalPeriod.MaxCaseForResource)
          else if IsWeekly then
            ST_MaxCaseForResource_2.Text := FloatToStr(ScheduleStatistics_2.m_SumArrayforWeeks[J-1].MaxCaseForResource)
          else
            ST_MaxCaseForResource_2.Text := FloatToStr(ScheduleStatistics_2.m_SumArrayforMonths[J-1].MaxCaseForResource);

          ST_PercentOfjobsCaseForEachResCase_2 := TButtonShowDetails.Create(ScrollBox);
          ST_PercentOfjobsCaseForEachResCase_2.Parent := ScrollBox;
          ST_PercentOfjobsCaseForEachResCase_2.top    := ST_PercentOfjobsCaseForEachResCase_1.top;// + 38;
  //        SetComponent(St_PercentOfjobsCaseForEachResCase_2, comp_Descr, false);
          ST_PercentOfjobsCaseForEachResCase_2.Left   := ST_PercentOfjobsCaseForEachResCase_1.Left + 180;
          ST_PercentOfjobsCaseForEachResCase_2.Width  := 100;
          ST_PercentOfjobsCaseForEachResCase_2.Height := 28;
          ST_PercentOfjobsCaseForEachResCase_2.Font.Size := 10;
          ST_PercentOfjobsCaseForEachResCase_2.Caption := 'Breakdown';
          ST_PercentOfjobsCaseForEachResCase_2.OnClick := OnClickCompactCasesRes;
          ST_PercentOfjobsCaseForEachResCase_2.ShowHint := true;
          ST_PercentOfjobsCaseForEachResCase_2.Hint    := 'breakdown by case of compatibility';
          ST_PercentOfjobsCaseForEachResCase_2.Font.Assign(ST_DelayBandsShow.Font); // match the delay/early breakdown buttons exactly

          if J = 1 then
          begin
            St_PercentOfjobsCaseForEachResCase_2.m_PercentOfjobsCaseForEachResCase := ScheduleStatistics_2.m_SumTotalPeriod.PercentOfjobsCaseForEachResCase;
            St_PercentOfjobsCaseForEachResCase_2.m_NumberOfJobs := ScheduleStatistics_2.m_SumTotalPeriod.m_NumberOfJobs_Total_ForResCase
          end
          else
          begin
            if IsWeekly then
            begin
              St_PercentOfjobsCaseForEachResCase_2.m_PercentOfjobsCaseForEachResCase := ScheduleStatistics_2.m_SumArrayforWeeks[J-1].PercentOfjobsCaseForEachResCase;
              St_PercentOfjobsCaseForEachResCase_2.m_NumberOfJobs := ScheduleStatistics_2.m_SumArrayforWeeks[J-1].m_NumberOfJobs_Total_ForResCase
            end
            else
            begin
              St_PercentOfjobsCaseForEachResCase_2.m_PercentOfjobsCaseForEachResCase := ScheduleStatistics_2.m_SumArrayforMonths[J-1].PercentOfjobsCaseForEachResCase;
              St_PercentOfjobsCaseForEachResCase_2.m_NumberOfJobs := ScheduleStatistics_2.m_SumArrayforMonths[J-1].m_NumberOfJobs_Total_ForResCase;
            end;
          end;

          ST_MaxCaseJobToJob_2 := TcxTextEdit.Create(ScrollBox);
          ST_MaxCaseJobToJob_2.Parent := ScrollBox;
          ST_MaxCaseJobToJob_2.top    := ST_MaxCaseJobToJob_1.top;// + 38;
          SetComponent(ST_MaxCaseJobToJob_2, comp_Descr, false);
          ST_MaxCaseJobToJob_2.Style.Color := MaxCaseJobToJob_Color;
          ST_MaxCaseJobToJob_2.Left   := ST_MaxCaseJobToJob_1.Left + 180;
          ST_MaxCaseJobToJob_2.Width  := 90;
          ST_MaxCaseJobToJob_2.Height := 25;
          ST_MaxCaseJobToJob_2.Style.Font.Size := 10;

          if J = 1 then
            ST_MaxCaseJobToJob_2.Text := IntToStr(ScheduleStatistics_2.m_SumTotalPeriod.MaxCaseJobToJob)
          else
          begin
            if IsWeekly then
              ST_MaxCaseJobToJob_2.Text := IntToStr(ScheduleStatistics_2.m_SumArrayforWeeks[J - 1].MaxCaseJobToJob)
            else
              ST_MaxCaseJobToJob_2.Text := IntToStr(ScheduleStatistics_2.m_SumArrayforMonths[J - 1].MaxCaseJobToJob);
          end;

          ST_PercentOfjobsCaseForEachJobToJobCase_2 := TButtonShowDetails.Create(ScrollBox);
          ST_PercentOfjobsCaseForEachJobToJobCase_2.Parent := ScrollBox;
          ST_PercentOfjobsCaseForEachJobToJobCase_2.top    := ST_PercentOfjobsCaseForEachJobToJobCase_1.top; //+ 38;
          SetComponent(ST_PercentOfjobsCaseForEachJobToJobCase_2, comp_Descr, false);
          ST_PercentOfjobsCaseForEachJobToJobCase_2.Left   := ST_PercentOfjobsCaseForEachJobToJobCase_1.Left + 180;
          ST_PercentOfjobsCaseForEachJobToJobCase_2.Width  := 100;
          ST_PercentOfjobsCaseForEachJobToJobCase_2.Height := 28;
          ST_PercentOfjobsCaseForEachJobToJobCase_2.Font.Size := 10;
          ST_PercentOfjobsCaseForEachJobToJobCase_2.Caption := 'Breakdown';
          ST_PercentOfjobsCaseForEachJobToJobCase_2.OnClick := OnClickCompactCasesJobToJob;
          ST_PercentOfjobsCaseForEachJobToJobCase_2.ShowHint := true;
          ST_PercentOfjobsCaseForEachJobToJobCase_2.Hint    := 'breakdown by case of compatibility';
          ST_PercentOfjobsCaseForEachJobToJobCase_2.Font.Assign(ST_DelayBandsShow.Font); // match the delay/early breakdown buttons exactly

          if J = 1 then
          begin
            ST_PercentOfjobsCaseForEachJobToJobCase_2.m_PercentOfjobsCaseForEachJobToJobCase := ScheduleStatistics_2.m_SumTotalPeriod.PercentOfjobsCaseForEachJobToJobCase;
            ST_PercentOfjobsCaseForEachJobToJobCase_2.m_NumberOfJobs := ScheduleStatistics_2.m_SumTotalPeriod.m_NumberOfJobs_Total_ForJobToJobCase
          end
          else
          begin
            if IsWeekly then
            begin
              ST_PercentOfjobsCaseForEachJobToJobCase_2.m_PercentOfjobsCaseForEachJobToJobCase := ScheduleStatistics_2.m_SumArrayforWeeks[J - 1].PercentOfjobsCaseForEachJobToJobCase;
              ST_PercentOfjobsCaseForEachJobToJobCase_2.m_NumberOfJobs := ScheduleStatistics_2.m_SumArrayforWeeks[J - 1].m_NumberOfJobs_Total_ForJobToJobCase
            end
            else
            begin
              ST_PercentOfjobsCaseForEachJobToJobCase_2.m_PercentOfjobsCaseForEachJobToJobCase := ScheduleStatistics_2.m_SumArrayforMonths[J - 1].PercentOfjobsCaseForEachJobToJobCase;
              ST_PercentOfjobsCaseForEachJobToJobCase_2.m_NumberOfJobs := ScheduleStatistics_2.m_SumArrayforMonths[J - 1].m_NumberOfJobs_Total_ForJobToJobCase;
            end;
          end;

          ST_NumberOfjobsWithoutMaterial_2 := TcxTextEdit.Create(ScrollBox);
          ST_NumberOfjobsWithoutMaterial_2.Parent := ScrollBox;
          ST_NumberOfjobsWithoutMaterial_2.top    := ST_NumberOfjobsWithoutMaterial_1.top;// + 38;
          SetComponent(ST_NumberOfjobsWithoutMaterial_2, comp_Descr, false);
          ST_NumberOfjobsWithoutMaterial_2.Style.Color := NumberOfjobsWithoutMaterial_Color;
          ST_NumberOfjobsWithoutMaterial_2.Left   := ST_NumberOfjobsWithoutMaterial_1.Left + 180;
          ST_NumberOfjobsWithoutMaterial_2.Width  := 90;
          ST_NumberOfjobsWithoutMaterial_2.Height := 25;
          ST_NumberOfjobsWithoutMaterial_2.Style.Font.Size := 10;

          if J = 1 then
            ST_NumberOfjobsWithoutMaterial_2.Text := IntToStr(ScheduleStatistics_2.m_SumTotalPeriod.NumberOfjobsWithoutMaterial)
          else
          begin
            if IsWeekly then
              ST_NumberOfjobsWithoutMaterial_2.Text := IntToStr(ScheduleStatistics_2.m_SumArrayforWeeks[J - 1].NumberOfjobsWithoutMaterial)
            else
              ST_NumberOfjobsWithoutMaterial_2.Text := IntToStr(ScheduleStatistics_2.m_SumArrayforMonths[J - 1].NumberOfjobsWithoutMaterial);
          end;

      {    ST_NumberOfjobsWithoutTools_2 := TcxTextEdit.Create(ScrollBox);
          ST_NumberOfjobsWithoutTools_2.Parent := ScrollBox;
          ST_NumberOfjobsWithoutTools_2.top    := ST_NumberOfjobsWithoutTools_1.top;// + 38;
          SetComponent(ST_NumberOfjobsWithoutTools_2, comp_Descr, false);
          ST_NumberOfjobsWithoutTools_2.Left   := ST_NumberOfjobsWithoutTools_1.Left + 180;
          ST_NumberOfjobsWithoutTools_2.Width  := 90;
          ST_NumberOfjobsWithoutTools_2.Height := 25;
          ST_NumberOfjobsWithoutTools_2.Font.Size := 10;

          if J = 1 then
            ST_NumberOfjobsWithoutTools_2.Caption := IntToStr(ScheduleStatistics_2.m_SumTotalPeriod.NumberOfjobsWithoutTools)
          else
          begin
            if IsWeekly then
              ST_NumberOfjobsWithoutTools_2.Caption := IntToStr(ScheduleStatistics_2.m_SumArrayforWeeks[J - 1].NumberOfjobsWithoutTools)
            else
              ST_NumberOfjobsWithoutTools_2.Caption := IntToStr(ScheduleStatistics_2.m_SumArrayforMonths[J - 1].NumberOfjobsWithoutTools);
          end;       }

          ST_NumberOfjobsWithoutManPawer_2 := TcxTextEdit.Create(ScrollBox);
          ST_NumberOfjobsWithoutManPawer_2.Parent := ScrollBox;
          ST_NumberOfjobsWithoutManPawer_2.top    := ST_NumberOfjobsWithoutManPawer_1.top;// + 38;
          SetComponent(ST_NumberOfjobsWithoutManPawer_2, comp_Descr, false);
          ST_NumberOfjobsWithoutManPawer_2.Style.Color := NumberOfjobsWithoutManPawer_Color;
          ST_NumberOfjobsWithoutManPawer_2.Left   := ST_NumberOfjobsWithoutManPawer_1.Left + 180;
          ST_NumberOfjobsWithoutManPawer_2.Width  := 90;
          ST_NumberOfjobsWithoutManPawer_2.Height := 25;
          ST_NumberOfjobsWithoutManPawer_2.Style.Font.Size := 10;

          if J = 1 then
            ST_NumberOfjobsWithoutManPawer_2.Text := IntToStr(ScheduleStatistics_2.m_SumTotalPeriod.NumberOfjobsWithoutManPawer)
          else
          begin
            if IsWeekly then
              ST_NumberOfjobsWithoutManPawer_2.Text := IntToStr(ScheduleStatistics_2.m_SumArrayforWeeks[J - 1].NumberOfjobsWithoutManPawer)
            else
              ST_NumberOfjobsWithoutManPawer_2.Text := IntToStr(ScheduleStatistics_2.m_SumArrayforMonths[J - 1].NumberOfjobsWithoutManPawer);
          end;

          ST_NumberOfjobsWithoutAnyAddRes_2 := TcxTextEdit.Create(ScrollBox);
          ST_NumberOfjobsWithoutAnyAddRes_2.Parent := ScrollBox;
          ST_NumberOfjobsWithoutAnyAddRes_2.top    := ST_NumberOfjobsWithoutAnyAddRes_1.top;// + 38;
          SetComponent(ST_NumberOfjobsWithoutAnyAddRes_2, comp_Descr, false);
          ST_NumberOfjobsWithoutAnyAddRes_2.Style.Color := NumberOfjobsWithoutAnyAddRes_Color;
          ST_NumberOfjobsWithoutAnyAddRes_2.Left   := ST_NumberOfjobsWithoutAnyAddRes_1.Left + 180;
          ST_NumberOfjobsWithoutAnyAddRes_2.Width  := 90;
          ST_NumberOfjobsWithoutAnyAddRes_2.Height := 25;
          ST_NumberOfjobsWithoutAnyAddRes_2.Style.Font.Size := 10;

          if J = 1 then
            ST_NumberOfjobsWithoutAnyAddRes_2.Text := IntToStr(ScheduleStatistics_2.m_SumTotalPeriod.NumberOfjobsWithoutAnyAddRes)
          else
          begin
            if IsWeekly then
              ST_NumberOfjobsWithoutAnyAddRes_2.Text := IntToStr(ScheduleStatistics_2.m_SumArrayforWeeks[J - 1].NumberOfjobsWithoutAnyAddRes)
            else
              ST_NumberOfjobsWithoutAnyAddRes_2.Text := IntToStr(ScheduleStatistics_2.m_SumArrayforMonths[J - 1].NumberOfjobsWithoutAnyAddRes);
          end;

          ST_TotalUomProduced_2 := TButtonShowDetails.Create(ScrollBox);
          ST_TotalUomProduced_2.Parent := ScrollBox;
          ST_TotalUomProduced_2.top    := TotalUomProduced_Lbl.top;// + 38;
          SetComponent(ST_TotalUomProduced_2, comp_Descr, false);
          ST_TotalUomProduced_2.font.Color := TotalUomProduced_Color;
          ST_TotalUomProduced_2.Left   := ST_TotalUomProduced_1.Left + 180;
          ST_TotalUomProduced_2.Width  := 90;
          ST_TotalUomProduced_2.Height := 25;
          ST_TotalUomProduced_2.Font.Size := 10;
          ST_TotalUomProduced_2.Caption := 'Show';
          ST_TotalUomProduced_2.OnClick := OnClickTotalUomProduced;
          ST_TotalUomProduced_2.ShowHint := true;
          ST_TotalUomProduced_2.Hint    := 'Show details';
          ST_TotalUomProduced_2.CustomHint := FMQMPlan.BalloonHint1;

          if J = 1 then
            ST_TotalUomProduced_2.m_ListUmQtyDetails := ScheduleStatistics_2.m_SumTotalPeriod.TotalUomProduced
          else
          begin
            if IsWeekly then
              ST_TotalUomProduced_2.m_ListUmQtyDetails := ScheduleStatistics_2.m_SumArrayforWeeks[J - 1].TotalUomProduced
            else
              ST_TotalUomProduced_2.m_ListUmQtyDetails := ScheduleStatistics_2.m_SumArrayforMonths[J - 1].TotalUomProduced;
          end;

        end;

        ScheduleStatistics_3 := TResOfGanttTab(GetStatisticOfGantTabByIndex(3, ResOfGanttTab.m_ganttTabName));
        if ScheduleStatistics_3 <> nil then
        begin

          staticText3 := TcxTextEdit.Create(panelTitle);
          staticText3.parent := panelTitle;
          SetComponent(staticText3, comp_Descr, false);
          if J = 1 then
            staticText3.Style.Color := TiTleColor//clGradientInactiveCaption
          else
            staticText3.Style.Color := 14540253;//14540287;
          staticText3.top := 14;
          staticText3.width := 160;
          staticText3.Left := staticText2.Left + 180;
          staticText3.height := 25;
        //  staticText3.Caption := ' ' + '(3) - ' + TimeToStr(Frac(ScheduleStatistics_3.m_DatetimeCreate));
          staticText3.Text := GetSetScheduleStatisticName(2);
        //  staticText3.Enabled := false;
          staticText3.Style.Font.Size := 10;

          // "Number of relevant jobs" for compared schedule 3
          ST_NumRelevantJobs_3 := TcxTextEdit.Create(ScrollBox);
          ST_NumRelevantJobs_3.Parent := ScrollBox;
          ST_NumRelevantJobs_3.top    := ST_NumRelevantJobs_1.Top;
          SetComponent(ST_NumRelevantJobs_3, comp_Descr, false);
          ST_NumRelevantJobs_3.Style.Color := MaxDaysDelay_Color;
          ST_NumRelevantJobs_3.Left   := ST_NumRelevantJobs_2.Left + 180;
          ST_NumRelevantJobs_3.Width  := 90;
          ST_NumRelevantJobs_3.Height := 25;
          ST_NumRelevantJobs_3.Style.Font.Size := 10;

          if J = 1 then
            ST_NumRelevantJobs_3.Text := IntToStr(ScheduleStatistics_3.m_SumTotalPeriod.m_NumberOfJobs_Total_ForDelayCalc)
          else if IsWeekly then
            ST_NumRelevantJobs_3.Text := IntToStr(ScheduleStatistics_3.m_SumArrayforWeeks[J-1].m_NumberOfJobs_Total_ForDelayCalc)
          else
            ST_NumRelevantJobs_3.Text := IntToStr(ScheduleStatistics_3.m_SumArrayforMonths[J-1].m_NumberOfJobs_Total_ForDelayCalc);

          // "Number of jobs in delay" for compared schedule 3 (reuses ST_MinDaysDelay_3)
          ST_MinDaysDelay_3 := TcxTextEdit.Create(ScrollBox);
          ST_MinDaysDelay_3.Parent := ScrollBox;
          ST_MinDaysDelay_3.top    := ST_MinDaysDelay_1.Top; ;
          SetComponent(ST_MinDaysDelay_3, comp_Descr, false);
          ST_MinDaysDelay_3.Style.Color := MinDaysDelay_Color;//BackGroundcolor1;
          ST_MinDaysDelay_3.Left   := ST_MinDaysDelay_2.Left + 180;
          ST_MinDaysDelay_3.Width  := 90;
          ST_MinDaysDelay_3.Height := 25;
          ST_MinDaysDelay_3.Style.Font.Size := 10;

          if J = 1 then
            ST_MinDaysDelay_3.Text := IntToStr(ScheduleStatistics_3.m_SumTotalPeriod.m_NumberOfJobsDelay)
          else if IsWeekly then
            ST_MinDaysDelay_3.Text := IntToStr(ScheduleStatistics_3.m_SumArrayforWeeks[J-1].m_NumberOfJobsDelay)
          else
            ST_MinDaysDelay_3.Text := IntToStr(ScheduleStatistics_3.m_SumArrayforMonths[J-1].m_NumberOfJobsDelay);

          ST_PercentOfJobsIndelay_3 := TcxTextEdit.Create(ScrollBox);
          ST_PercentOfJobsIndelay_3.Parent := ScrollBox;
          ST_PercentOfJobsIndelay_3.top    := ST_PercentOfJobsIndelay_1.Top;
          SetComponent(ST_PercentOfJobsIndelay_3, comp_Descr, false);
          ST_PercentOfJobsIndelay_3.Style.Color := PercentOfJobsIndelay_Color;
          ST_PercentOfJobsIndelay_3.Left   := ST_PercentOfJobsIndelay_2.Left + 180;
          ST_PercentOfJobsIndelay_3.Width  := 90;
          ST_PercentOfJobsIndelay_3.Height := 25;
          ST_PercentOfJobsIndelay_3.Style.Font.Size := 10;

          if J = 1 then
          begin
            if ScheduleStatistics_3.m_SumTotalPeriod.PercentOfJobsIndelay > 0 then
              ST_PercentOfJobsIndelay_3.Text := FloatToStr(ScheduleStatistics_3.m_SumTotalPeriod.PercentOfJobsIndelay) + '%';
          end
          else if IsWeekly then
          begin
            if ScheduleStatistics_3.m_SumArrayforWeeks[J-1].PercentOfJobsIndelay > 0 then
              ST_PercentOfJobsIndelay_3.Text := FloatToStr(ScheduleStatistics_3.m_SumArrayforWeeks[J-1].PercentOfJobsIndelay) + '%';
          end
          else
          begin
            if ScheduleStatistics_3.m_SumArrayforMonths[J-1].PercentOfJobsIndelay > 0 then
              ST_PercentOfJobsIndelay_3.Text := FloatToStr(ScheduleStatistics_3.m_SumArrayforMonths[J-1].PercentOfJobsIndelay) +  '%';
          end;

          ST_MinDaysTooEarly_3 := TcxTextEdit.Create(ScrollBox);
          ST_MinDaysTooEarly_3.Parent := ScrollBox;
          ST_MinDaysTooEarly_3.top    := ST_MinDaysTooEarly_1.Top;
          SetComponent(ST_MinDaysTooEarly_3, comp_Descr, false);
          ST_MinDaysTooEarly_3.Style.Color := MinDaysTooEarly_Color;
          ST_MinDaysTooEarly_3.Left   := ST_MinDaysTooEarly_2.Left + 180;
          ST_MinDaysTooEarly_3.Width  := 90;
          ST_MinDaysTooEarly_3.Height := 25;
          ST_MinDaysTooEarly_3.Style.Font.Size := 10;

          if J = 1 then
            ST_MinDaysTooEarly_3.Text := IntToStr(ScheduleStatistics_3.m_SumTotalPeriod.m_NumberOfJobsEarly)
          else if IsWeekly then
            ST_MinDaysTooEarly_3.Text := IntToStr(ScheduleStatistics_3.m_SumArrayforWeeks[J-1].m_NumberOfJobsEarly)
          else
            ST_MinDaysTooEarly_3.Text := IntToStr(ScheduleStatistics_3.m_SumArrayforMonths[J-1].m_NumberOfJobsEarly);

          ST_PercentOfJobsTooEarly_3 := TcxTextEdit.Create(ScrollBox);
          ST_PercentOfJobsTooEarly_3.Parent := ScrollBox;
          ST_PercentOfJobsTooEarly_3.top    := ST_PercentOfJobsTooEarly_1.top;// + 38;
          SetComponent(ST_PercentOfJobsTooEarly_3, comp_Descr, false);
          ST_PercentOfJobsTooEarly_3.Style.Color := PercentOfJobsTooEarly_Color;
          ST_PercentOfJobsTooEarly_3.Left   := ST_PercentOfJobsTooEarly_2.Left + + 180;
          ST_PercentOfJobsTooEarly_3.Width  := 90;
          ST_PercentOfJobsTooEarly_3.Height := 25;
          ST_PercentOfJobsTooEarly_3.Style.Font.Size := 10;

          if J = 1 then
          begin
            if (ScheduleStatistics_3.m_SumTotalPeriod.m_NumberOfJobs_Total_ForDelayCalc > 0) and
               (ScheduleStatistics_3.m_SumTotalPeriod.m_NumberOfJobsEarly > 0) then
              ST_PercentOfJobsTooEarly_3.Text := FormatFloat('0.0', ScheduleStatistics_3.m_SumTotalPeriod.m_NumberOfJobsEarly /
                                                            ScheduleStatistics_3.m_SumTotalPeriod.m_NumberOfJobs_Total_ForDelayCalc * 100) + '%'
          end
          else if IsWeekly then
          begin
            if (ScheduleStatistics_3.m_SumArrayforWeeks[J-1].m_NumberOfJobs_Total_ForDelayCalc > 0) and
               (ScheduleStatistics_3.m_SumArrayforWeeks[J-1].m_NumberOfJobsEarly > 0) then
              ST_PercentOfJobsTooEarly_3.Text := FormatFloat('0.0', ScheduleStatistics_3.m_SumArrayforWeeks[J-1].m_NumberOfJobsEarly /
                                                            ScheduleStatistics_3.m_SumArrayforWeeks[J-1].m_NumberOfJobs_Total_ForDelayCalc * 100) + '%'
          end
          else
          begin
            if (ScheduleStatistics_3.m_SumArrayforMonths[J-1].m_NumberOfJobs_Total_ForDelayCalc > 0) and
               (ScheduleStatistics_3.m_SumArrayforMonths[J-1].m_NumberOfJobsEarly > 0) then
            ST_PercentOfJobsTooEarly_3.Text := FormatFloat('0.0', ScheduleStatistics_3.m_SumArrayforMonths[J-1].m_NumberOfJobsEarly /
                                                          ScheduleStatistics_3.m_SumArrayforMonths[J-1].m_NumberOfJobs_Total_ForDelayCalc * 100) + '%';
          end;

          ST_TotalSetupHours_3 := TcxTextEdit.Create(ScrollBox);
          ST_TotalSetupHours_3.Parent := ScrollBox;
          ST_TotalSetupHours_3.top    := ST_TotalSetupHours_1.top;// + 38;
          SetComponent(ST_TotalSetupHours_3, comp_Descr, false);
          St_TotalSetupHours_3.Style.color := TotalSetupHours_Color;
          ST_TotalSetupHours_3.Left   := ST_TotalSetupHours_2.Left + 180;
          ST_TotalSetupHours_3.Width  := 90;
          ST_TotalSetupHours_3.Height := 25;
          ST_TotalSetupHours_3.Style.Font.Size := 10;

          if J = 1 then
            TotSetupHours := ScheduleStatistics_3.m_SumTotalPeriod.TotalSetupHours
          else
          begin
            if IsWeekly then
              TotSetupHours := ScheduleStatistics_3.m_SumArrayforWeeks[J - 1].TotalSetupHours
            else
              TotSetupHours := ScheduleStatistics_3.m_SumArrayforMonths[J - 1].TotalSetupHours;
          end;

          TempExt := Frac(TotSetupHours);
          S := FloatToStr(TempExt);
          if Length(S) > 3 then
          begin
            S := Copy(s, 2, 3);
            TotSetupHoursStr := FloatToStr(trunc(TotSetupHours));
            TotSetupHoursStr := TotSetupHoursStr + S;
          end
          else
            TotSetupHoursStr := FloatToStr(TotSetupHours);

          ST_TotalSetupHours_3.Text := TotSetupHoursStr;

{          if J = 1 then
            ST_TotalSetupHours_3.Caption := FloatToStr(ScheduleStatistics_3.m_SumTotalPeriod.TotalSetupHours)
          else if IsWeekly then
            ST_TotalSetupHours_3.Caption := FloatToStr(ScheduleStatistics_3.m_SumArrayforWeeks[J-1].TotalSetupHours)
          else
            ST_TotalSetupHours_3.Caption := FloatToStr(ScheduleStatistics_3.m_SumArrayforMonths[J-1].TotalSetupHours);
 }
          ST_PercentOfSetupHours_3 := TcxTextEdit.Create(ScrollBox);
          ST_PercentOfSetupHours_3.Parent := ScrollBox;
          ST_PercentOfSetupHours_3.top    := ST_PercentOfSetupHours_1.top; //+ 38;
          SetComponent(St_PercentOfSetupHours_3, comp_Descr, false);
          St_PercentOfSetupHours_3.Style.color := PercentOfSetupHours_Color;
          ST_PercentOfSetupHours_3.Left   := ST_PercentOfSetupHours_2.Left + 180;
          ST_PercentOfSetupHours_3.Width  := 90;
          ST_PercentOfSetupHours_3.Height := 25;
          ST_PercentOfSetupHours_3.Style.Font.Size := 10;

          if J = 1 then
            Percent := ScheduleStatistics_3.m_SumTotalPeriod.PercentOfSetupHours
          else
          begin
            if IsWeekly then
              Percent := ScheduleStatistics_3.m_SumArrayforWeeks[J - 1].PercentOfSetupHours
            else
              Percent := ScheduleStatistics_3.m_SumArrayforMonths[J - 1].PercentOfSetupHours;
          end;

          TempExt := Frac(Percent);
          S := FloatToStr(TempExt);
          if Length(S) > 3 then
          begin
            S := Copy(s, 2, 3);
            PercentStr := FloatToStr(trunc(Percent));
            PercentStr := PercentStr + S;
          end
          else
            PercentStr := FloatToStr(Percent);

          ST_PercentOfSetupHours_3.Text := PercentStr + '%';

{          if J = 1 then
            ST_PercentOfSetupHours_3.Caption := FloatToStr(ScheduleStatistics_3.m_SumTotalPeriod.PercentOfSetupHours)
          else if IsWeekly then
            ST_PercentOfSetupHours_3.Caption := FloatToStr(ScheduleStatistics_3.m_SumArrayforWeeks[J-1].PercentOfSetupHours)
          else
            ST_PercentOfSetupHours_3.Caption := FloatToStr(ScheduleStatistics_3.m_SumArrayforMonths[J-1].PercentOfSetupHours);
 }
          ST_TotalHoursExecution_3 := TcxTextEdit.Create(ScrollBox);
          ST_TotalHoursExecution_3.Parent := ScrollBox;
          ST_TotalHoursExecution_3.top    := ST_TotalHoursExecution_1.top;// + 38;
          SetComponent(St_TotalHoursExecution_3, comp_Descr, false);
          St_TotalHoursExecution_3.Style.Color := TotalHoursExecution_Color;
          ST_TotalHoursExecution_3.Left   := ST_TotalHoursExecution_2.Left + 180;
          ST_TotalHoursExecution_3.Width  := 90;
          ST_TotalHoursExecution_3.Height := 25;
          ST_TotalHoursExecution_3.Style.Font.Size := 10;

          if J = 1 then
            TotExecutionHours := ScheduleStatistics_3.m_SumTotalPeriod.TotalHoursExecution
          else
          begin
            if IsWeekly then
              TotExecutionHours := ScheduleStatistics_3.m_SumArrayforWeeks[J - 1].TotalHoursExecution
            else
              TotExecutionHours := ScheduleStatistics_3.m_SumArrayforMonths[J - 1].TotalHoursExecution;
          end;

          TempExt := Frac(TotExecutionHours);
          S := FloatToStr(TempExt);
          if Length(S) > 3 then
          begin
            S := Copy(s, 2, 3);
            TotExecutionHoursStr := FloatToStr(trunc(TotExecutionHours));
            TotExecutionHoursStr := TotExecutionHoursStr + S;
          end
          else
            TotExecutionHoursStr := FloatToStr(TotExecutionHours);

          ST_TotalHoursExecution_3.Text := TotExecutionHoursStr;

        {  if J = 1 then
            ST_TotalHoursExecution_3.Caption := FloatToStr(ScheduleStatistics_3.m_SumTotalPeriod.TotalSetupHours)
          else if IsWeekly then
            ST_TotalHoursExecution_3.Caption := FloatToStr(ScheduleStatistics_3.m_SumArrayforWeeks[J-1].TotalSetupHours)
          else
            ST_TotalHoursExecution_3.Caption := FloatToStr(ScheduleStatistics_3.m_SumArrayforMonths[J-1].TotalSetupHours);
         }
          ST_TotalHoursOfOccPerGanttOcc_3 := TcxTextEdit.Create(ScrollBox);
          ST_TotalHoursOfOccPerGanttOcc_3.Parent := ScrollBox;
          ST_TotalHoursOfOccPerGanttOcc_3.top    := ST_TotalHoursOfOccPerGanttOcc_1.top;// + 38;
          SetComponent(St_TotalHoursOfOccPerGanttOcc_3, comp_Descr, false);
          St_TotalHoursOfOccPerGanttOcc_3.Style.Color := TotalHoursOfOccPerGanttOcc_Color;
          ST_TotalHoursOfOccPerGanttOcc_3.Left   := ST_TotalHoursOfOccPerGanttOcc_2.Left + 180;
          ST_TotalHoursOfOccPerGanttOcc_3.Width  := 90;
          ST_TotalHoursOfOccPerGanttOcc_3.Height := 25;
          ST_TotalHoursOfOccPerGanttOcc_3.Style.Font.Size := 10;

          if J = 1 then
            PercentHoursPerOccMachine := ScheduleStatistics_3.m_SumTotalPeriod.PercentHoursOfOccPerGanttOcc
          else
          begin
            if IsWeekly then
              PercentHoursPerOccMachine := ScheduleStatistics_3.m_SumArrayforWeeks[J - 1].PercentHoursOfOccPerGanttOcc
            else
              PercentHoursPerOccMachine := ScheduleStatistics_3.m_SumArrayforMonths[J - 1].PercentHoursOfOccPerGanttOcc;
          end;

        {  TempExt := Frac(TotExecutionHoursPerOccMachine);
          S := FloatToStr(TempExt);
          if Length(S) > 3 then
          begin
            S := Copy(s, 2, 3);
            TotExecutionHoursPerOccMachineStr := FloatToStr(trunc(TotExecutionHoursPerOccMachine));
            TotExecutionHoursPerOccMachineStr := TotExecutionHoursPerOccMachineStr + S;
          end
          else
            TotExecutionHoursPerOccMachineStr := FloatToStr(TotExecutionHoursPerOccMachine);  }

          if PercentHoursPerOccMachine > 100 then
             PercentHoursPerOccMachine := 100;
          ST_TotalHoursOfOccPerGanttOcc_3.Text := FloatToStr(PercentHoursPerOccMachine) + '%';


{          if J = 1 then
            ST_TotalHoursOfOccPerGanttOcc_3.Caption := FloatToStr(ScheduleStatistics_3.m_SumTotalPeriod.TotalHoursOfOccPerGanttOcc)
          else if IsWeekly then
            ST_TotalHoursOfOccPerGanttOcc_3.Caption := FloatToStr(ScheduleStatistics_3.m_SumArrayforWeeks[J-1].TotalHoursOfOccPerGanttOcc)
          else
            ST_TotalHoursOfOccPerGanttOcc_3.Caption := FloatToStr(ScheduleStatistics_3.m_SumArrayforMonths[J-1].TotalHoursOfOccPerGanttOcc);
 }
          ST_MaxCaseForResource_3 := TcxTextEdit.Create(ScrollBox);
          ST_MaxCaseForResource_3.Parent := ScrollBox;
          ST_MaxCaseForResource_3.top    := ST_MaxCaseForResource_1.top; //+ 38;
          SetComponent(St_MaxCaseForResource_3, comp_Descr, false);
          St_MaxCaseForResource_3.Style.Color := MaxCaseForResource_Color;
          ST_MaxCaseForResource_3.Left   := ST_MaxCaseForResource_2.Left + 180;
          ST_MaxCaseForResource_3.Width  := 90;
          ST_MaxCaseForResource_3.Height := 25;
          ST_MaxCaseForResource_3.Style.Font.Size := 10;

          if J = 1 then
            ST_MaxCaseForResource_3.Text := FloatToStr(ScheduleStatistics_3.m_SumTotalPeriod.MaxCaseForResource)
          else if IsWeekly then
            ST_MaxCaseForResource_3.Text := FloatToStr(ScheduleStatistics_3.m_SumArrayforWeeks[J-1].MaxCaseForResource)
          else
            ST_MaxCaseForResource_3.Text := FloatToStr(ScheduleStatistics_3.m_SumArrayforMonths[J-1].MaxCaseForResource);

          ST_PercentOfjobsCaseForEachResCase_3 := TButtonShowDetails.Create(ScrollBox);
          ST_PercentOfjobsCaseForEachResCase_3.Parent := ScrollBox;
          ST_PercentOfjobsCaseForEachResCase_3.top    := ST_PercentOfjobsCaseForEachResCase_1.top;// + 38;
  //        SetComponent(St_PercentOfjobsCaseForEachResCase_3, comp_Descr, false);
          ST_PercentOfjobsCaseForEachResCase_3.Left   := ST_PercentOfjobsCaseForEachResCase_2.Left + 180;
          ST_PercentOfjobsCaseForEachResCase_3.Width  := 100;
          ST_PercentOfjobsCaseForEachResCase_3.Height := 28;
          ST_PercentOfjobsCaseForEachResCase_3.Font.Size := 10;
          ST_PercentOfjobsCaseForEachResCase_3.Caption := 'Breakdown';
          ST_PercentOfjobsCaseForEachResCase_3.OnClick := OnClickCompactCasesRes;
          ST_PercentOfjobsCaseForEachResCase_3.ShowHint := true;
          ST_PercentOfjobsCaseForEachResCase_3.Hint    := 'breakdown by case of compatibility';
          ST_PercentOfjobsCaseForEachResCase_3.Font.Assign(ST_DelayBandsShow.Font); // match the delay/early breakdown buttons exactly

          if J = 1 then
          begin
            ST_PercentOfjobsCaseForEachResCase_3.m_PercentOfjobsCaseForEachResCase := ScheduleStatistics_3.m_SumTotalPeriod.PercentOfjobsCaseForEachResCase;
            ST_PercentOfjobsCaseForEachResCase_3.m_NumberOfJobs := ScheduleStatistics_3.m_SumTotalPeriod.m_NumberOfJobs_Total_ForResCase
          end
          else
          begin
            if IsWeekly then
            begin
              ST_PercentOfjobsCaseForEachResCase_3.m_PercentOfjobsCaseForEachResCase := ScheduleStatistics_3.m_SumArrayforWeeks[J-1].PercentOfjobsCaseForEachResCase;
              ST_PercentOfjobsCaseForEachResCase_3.m_NumberOfJobs := ScheduleStatistics_3.m_SumArrayforWeeks[J-1].m_NumberOfJobs_Total_ForResCase
            end
            else
            begin
              ST_PercentOfjobsCaseForEachResCase_3.m_PercentOfjobsCaseForEachResCase := ScheduleStatistics_3.m_SumArrayforMonths[J-1].PercentOfjobsCaseForEachResCase;
              ST_PercentOfjobsCaseForEachResCase_3.m_NumberOfJobs := ScheduleStatistics_3.m_SumArrayforMonths[J-1].m_NumberOfJobs_Total_ForResCase;
            end;
          end;

          ST_MaxCaseJobToJob_3 := TcxTextEdit.Create(ScrollBox);
          ST_MaxCaseJobToJob_3.Parent := ScrollBox;
          ST_MaxCaseJobToJob_3.top    := ST_MaxCaseJobToJob_1.top;// + 38;
          SetComponent(ST_MaxCaseJobToJob_3, comp_Descr, false);
          ST_MaxCaseJobToJob_3.Style.Color := MaxCaseJobToJob_Color;
          ST_MaxCaseJobToJob_3.Left   := ST_MaxCaseJobToJob_2.Left + 180;
          ST_MaxCaseJobToJob_3.Width  := 90;
          ST_MaxCaseJobToJob_3.Height := 25;
          ST_MaxCaseJobToJob_3.Style.Font.Size := 10;

          if J = 1 then
            ST_MaxCaseJobToJob_3.Text := IntToStr(ScheduleStatistics_3.m_SumTotalPeriod.MaxCaseJobToJob)
          else
          begin
            if IsWeekly then
              ST_MaxCaseJobToJob_3.Text := IntToStr(ScheduleStatistics_3.m_SumArrayforWeeks[J - 1].MaxCaseJobToJob)
            else
              ST_MaxCaseJobToJob_3.Text := IntToStr(ScheduleStatistics_3.m_SumArrayforMonths[J - 1].MaxCaseJobToJob);
          end;

          ST_PercentOfjobsCaseForEachJobToJobCase_3 := TButtonShowDetails.Create(ScrollBox);
          ST_PercentOfjobsCaseForEachJobToJobCase_3.Parent := ScrollBox;
          ST_PercentOfjobsCaseForEachJobToJobCase_3.top    := ST_PercentOfjobsCaseForEachJobToJobCase_1.top; //+ 38;
          SetComponent(ST_PercentOfjobsCaseForEachJobToJobCase_3, comp_Descr, false);
          ST_PercentOfjobsCaseForEachJobToJobCase_3.Left   := ST_PercentOfjobsCaseForEachJobToJobCase_2.Left + 180;
          ST_PercentOfjobsCaseForEachJobToJobCase_3.Width  := 100;
          ST_PercentOfjobsCaseForEachJobToJobCase_3.Height := 28;
          ST_PercentOfjobsCaseForEachJobToJobCase_3.Font.Size := 10;
          ST_PercentOfjobsCaseForEachJobToJobCase_3.Caption := 'Breakdown';
          ST_PercentOfjobsCaseForEachJobToJobCase_3.OnClick := OnClickCompactCasesJobToJob;
          ST_PercentOfjobsCaseForEachJobToJobCase_3.ShowHint := true;
          ST_PercentOfjobsCaseForEachJobToJobCase_3.Hint    := 'breakdown by case of compatibility';
          ST_PercentOfjobsCaseForEachJobToJobCase_3.Font.Assign(ST_DelayBandsShow.Font); // match the delay/early breakdown buttons exactly

          if J = 1 then
          begin
            ST_PercentOfjobsCaseForEachJobToJobCase_3.m_PercentOfjobsCaseForEachJobToJobCase := ScheduleStatistics_3.m_SumTotalPeriod.PercentOfjobsCaseForEachJobToJobCase;
            ST_PercentOfjobsCaseForEachJobToJobCase_3.m_NumberOfJobs := ScheduleStatistics_3.m_SumTotalPeriod.m_NumberOfJobs_Total_ForJobToJobCase
          end
          else
          begin
            if IsWeekly then
            begin
              ST_PercentOfjobsCaseForEachJobToJobCase_3.m_PercentOfjobsCaseForEachJobToJobCase := ScheduleStatistics_3.m_SumArrayforWeeks[J - 1].PercentOfjobsCaseForEachJobToJobCase;
              ST_PercentOfjobsCaseForEachJobToJobCase_3.m_NumberOfJobs := ScheduleStatistics_3.m_SumArrayforWeeks[J - 1].m_NumberOfJobs_Total_ForJobToJobCase
            end
            else
            begin
              ST_PercentOfjobsCaseForEachJobToJobCase_3.m_PercentOfjobsCaseForEachJobToJobCase := ScheduleStatistics_3.m_SumArrayforMonths[J - 1].PercentOfjobsCaseForEachJobToJobCase;
              ST_PercentOfjobsCaseForEachJobToJobCase_3.m_NumberOfJobs := ScheduleStatistics_3.m_SumArrayforMonths[J - 1].m_NumberOfJobs_Total_ForJobToJobCase;
            end;
          end;

          ST_NumberOfjobsWithoutMaterial_3 := TcxTextEdit.Create(ScrollBox);
          ST_NumberOfjobsWithoutMaterial_3.Parent := ScrollBox;
          ST_NumberOfjobsWithoutMaterial_3.top    := ST_NumberOfjobsWithoutMaterial_1.top;// + 38;
          SetComponent(ST_NumberOfjobsWithoutMaterial_3, comp_Descr, false);
          ST_NumberOfjobsWithoutMaterial_3.Style.Color := NumberOfjobsWithoutMaterial_Color;
          ST_NumberOfjobsWithoutMaterial_3.Left   := ST_NumberOfjobsWithoutMaterial_2.Left + 180;
          ST_NumberOfjobsWithoutMaterial_3.Width  := 90;
          ST_NumberOfjobsWithoutMaterial_3.Height := 25;
          ST_NumberOfjobsWithoutMaterial_3.Style.Font.Size := 10;

          if J = 1 then
            ST_NumberOfjobsWithoutMaterial_3.Text := IntToStr(ScheduleStatistics_3.m_SumTotalPeriod.NumberOfjobsWithoutMaterial)
          else
          begin
            if IsWeekly then
              ST_NumberOfjobsWithoutMaterial_3.Text := IntToStr(ScheduleStatistics_3.m_SumArrayforWeeks[J - 1].NumberOfjobsWithoutMaterial)
            else
              ST_NumberOfjobsWithoutMaterial_3.Text := IntToStr(ScheduleStatistics_3.m_SumArrayforMonths[J - 1].NumberOfjobsWithoutMaterial);
          end;

     {     ST_NumberOfjobsWithoutTools_3 := TcxTextEdit.Create(ScrollBox);
          ST_NumberOfjobsWithoutTools_3.Parent := ScrollBox;
          ST_NumberOfjobsWithoutTools_3.top    := ST_NumberOfjobsWithoutTools_1.top;// + 38;
          SetComponent(ST_NumberOfjobsWithoutTools_3, comp_Descr, false);
          ST_NumberOfjobsWithoutTools_3.Left   := ST_NumberOfjobsWithoutTools_2.Left + 180;
          ST_NumberOfjobsWithoutTools_3.Width  := 90;
          ST_NumberOfjobsWithoutTools_3.Height := 25;
          ST_NumberOfjobsWithoutTools_3.Font.Size := 10;

          if J = 1 then
            ST_NumberOfjobsWithoutTools_3.Caption := IntToStr(ScheduleStatistics_3.m_SumTotalPeriod.NumberOfjobsWithoutTools)
          else
          begin
            if IsWeekly then
              ST_NumberOfjobsWithoutTools_3.Caption := IntToStr(ScheduleStatistics_3.m_SumArrayforWeeks[J - 1].NumberOfjobsWithoutTools)
            else
              ST_NumberOfjobsWithoutTools_3.Caption := IntToStr(ScheduleStatistics_3.m_SumArrayforMonths[J - 1].NumberOfjobsWithoutTools);
          end;
      }
          ST_NumberOfjobsWithoutManPawer_3 := TcxTextEdit.Create(ScrollBox);
          ST_NumberOfjobsWithoutManPawer_3.Parent := ScrollBox;
          ST_NumberOfjobsWithoutManPawer_3.top    := ST_NumberOfjobsWithoutManPawer_1.top;// + 38;
          SetComponent(ST_NumberOfjobsWithoutManPawer_3, comp_Descr, false);
          ST_NumberOfjobsWithoutManPawer_3.Style.Color := NumberOfjobsWithoutManPawer_Color;
          ST_NumberOfjobsWithoutManPawer_3.Left   := ST_NumberOfjobsWithoutManPawer_2.Left + 180;
          ST_NumberOfjobsWithoutManPawer_3.Width  := 90;
          ST_NumberOfjobsWithoutManPawer_3.Height := 25;
          ST_NumberOfjobsWithoutManPawer_3.Style.Font.Size := 10;

          if J = 1 then
            ST_NumberOfjobsWithoutManPawer_3.Text := IntToStr(ScheduleStatistics_3.m_SumTotalPeriod.NumberOfjobsWithoutManPawer)
          else
          begin
            if IsWeekly then
              ST_NumberOfjobsWithoutManPawer_3.Text := IntToStr(ScheduleStatistics_3.m_SumArrayforWeeks[J - 1].NumberOfjobsWithoutManPawer)
            else
              ST_NumberOfjobsWithoutManPawer_3.Text := IntToStr(ScheduleStatistics_3.m_SumArrayforMonths[J - 1].NumberOfjobsWithoutManPawer);
          end;

          ST_NumberOfjobsWithoutAnyAddRes_3 := TcxTextEdit.Create(ScrollBox);
          ST_NumberOfjobsWithoutAnyAddRes_3.Parent := ScrollBox;
          ST_NumberOfjobsWithoutAnyAddRes_3.top    := ST_NumberOfjobsWithoutAnyAddRes_1.top;// + 38;
          SetComponent(ST_NumberOfjobsWithoutAnyAddRes_3, comp_Descr, false);
          ST_NumberOfjobsWithoutAnyAddRes_3.Style.Color := NumberOfjobsWithoutAnyAddRes_Color;
          ST_NumberOfjobsWithoutAnyAddRes_3.Left   := ST_NumberOfjobsWithoutAnyAddRes_2.Left + 180;
          ST_NumberOfjobsWithoutAnyAddRes_3.Width  := 90;
          ST_NumberOfjobsWithoutAnyAddRes_3.Height := 25;
          ST_NumberOfjobsWithoutAnyAddRes_3.Style.Font.Size := 10;

          if J = 1 then
            ST_NumberOfjobsWithoutAnyAddRes_3.Text := IntToStr(ScheduleStatistics_3.m_SumTotalPeriod.NumberOfjobsWithoutAnyAddRes)
          else
          begin
            if IsWeekly then
              ST_NumberOfjobsWithoutAnyAddRes_3.Text := IntToStr(ScheduleStatistics_3.m_SumArrayforWeeks[J - 1].NumberOfjobsWithoutAnyAddRes)
            else
              ST_NumberOfjobsWithoutAnyAddRes_3.Text := IntToStr(ScheduleStatistics_3.m_SumArrayforMonths[J - 1].NumberOfjobsWithoutAnyAddRes);
          end;

          ST_TotalUomProduced_3 := TButtonShowDetails.Create(ScrollBox);
          ST_TotalUomProduced_3.Parent := ScrollBox;
          ST_TotalUomProduced_3.top    := TotalUomProduced_Lbl.top;// + 38;
        //  SetComponent(ST_TotalUomProduced_3, comp_Descr, false);
          ST_TotalUomProduced_3.font.Color := TotalUomProduced_Color;
          ST_TotalUomProduced_3.Left   := ST_TotalUomProduced_2.Left + 180;
          ST_TotalUomProduced_3.Width  := 90;
          ST_TotalUomProduced_3.Height := 25;
          ST_TotalUomProduced_3.Font.Size := 10;
          ST_TotalUomProduced_3.Caption := 'Show';
          ST_TotalUomProduced_3.OnClick := OnClickTotalUomProduced;
          ST_TotalUomProduced_3.ShowHint := true;
          ST_TotalUomProduced_3.Hint    := 'Show details';
          ST_TotalUomProduced_3.CustomHint := FMQMPlan.BalloonHint1;

          if J = 1 then
            ST_TotalUomProduced_3.m_ListUmQtyDetails := ScheduleStatistics_3.m_SumTotalPeriod.TotalUomProduced
          else
          begin
            if IsWeekly then
              ST_TotalUomProduced_3.m_ListUmQtyDetails := ScheduleStatistics_3.m_SumArrayforWeeks[J - 1].TotalUomProduced
            else
              ST_TotalUomProduced_3.m_ListUmQtyDetails := ScheduleStatistics_3.m_SumArrayforMonths[J - 1].TotalUomProduced;
          end;

        end;

        ScheduleStatistics_4 := TResOfGanttTab(GetStatisticOfGantTabByIndex(4, ResOfGanttTab.m_ganttTabName));
        if ScheduleStatistics_4 <> nil then
        begin

          staticText4 := TcxTextEdit.Create(panelTitle);
          staticText4.parent := panelTitle;
          SetComponent(staticText4, comp_Descr, false);
          if J = 1 then
            staticText4.Style.Color := TiTleColor//clGradientInactiveCaption
          else
            staticText4.Style.Color := 14540253;//14540287;
          staticText4.top := 14;
          staticText4.width := 160;
          staticText4.Left := staticText3.Left + 180;
          staticText4.height := 25;
        //  staticText4.Caption := ' ' + '(4) - ' + TimeToStr(Frac(ScheduleStatistics_4.m_DatetimeCreate));
          staticText4.Text := GetSetScheduleStatisticName(3);
       //   staticText4.Enabled := false;
          staticText4.Style.Font.Size := 10;

          // "Number of relevant jobs" for compared schedule 4
          ST_NumRelevantJobs_4 := TcxTextEdit.Create(ScrollBox);
          ST_NumRelevantJobs_4.Parent := ScrollBox;
          ST_NumRelevantJobs_4.top    := ST_NumRelevantJobs_1.Top;
          SetComponent(ST_NumRelevantJobs_4, comp_Descr, false);
          ST_NumRelevantJobs_4.Style.Color := MaxDaysDelay_Color;
          ST_NumRelevantJobs_4.Left   := ST_NumRelevantJobs_3.Left + 180;
          ST_NumRelevantJobs_4.Width  := 90;
          ST_NumRelevantJobs_4.Height := 25;
          ST_NumRelevantJobs_4.Style.Font.Size := 10;

          if J = 1 then
            ST_NumRelevantJobs_4.Text := IntToStr(ScheduleStatistics_4.m_SumTotalPeriod.m_NumberOfJobs_Total_ForDelayCalc)
          else if IsWeekly then
            ST_NumRelevantJobs_4.Text := IntToStr(ScheduleStatistics_4.m_SumArrayforWeeks[J-1].m_NumberOfJobs_Total_ForDelayCalc)
          else
            ST_NumRelevantJobs_4.Text := IntToStr(ScheduleStatistics_4.m_SumArrayforMonths[J-1].m_NumberOfJobs_Total_ForDelayCalc);

          // "Number of jobs in delay" for compared schedule 4 (reuses ST_MinDaysDelay_4)
          ST_MinDaysDelay_4 := TcxTextEdit.Create(ScrollBox);
          ST_MinDaysDelay_4.Parent := ScrollBox;
          ST_MinDaysDelay_4.top    := ST_MinDaysDelay_1.Top; ;
          SetComponent(ST_MinDaysDelay_4, comp_Descr, false);
          ST_MinDaysDelay_4.Style.Color := MinDaysDelay_Color;//BackGroundcolor1;
          ST_MinDaysDelay_4.Left   := ST_MinDaysDelay_3.Left + 180;
          ST_MinDaysDelay_4.Width  := 90;
          ST_MinDaysDelay_4.Height := 25;
          ST_MinDaysDelay_4.Style.Font.Size := 10;

          if J = 1 then
            ST_MinDaysDelay_4.Text := IntToStr(ScheduleStatistics_4.m_SumTotalPeriod.m_NumberOfJobsDelay)
          else if IsWeekly then
            ST_MinDaysDelay_4.Text := IntToStr(ScheduleStatistics_4.m_SumArrayforWeeks[J-1].m_NumberOfJobsDelay)
          else
            ST_MinDaysDelay_4.Text := IntToStr(ScheduleStatistics_4.m_SumArrayforMonths[J-1].m_NumberOfJobsDelay);

          ST_PercentOfJobsIndelay_4 := TcxTextEdit.Create(ScrollBox);
          ST_PercentOfJobsIndelay_4.Parent := ScrollBox;
          ST_PercentOfJobsIndelay_4.top    := ST_PercentOfJobsIndelay_1.Top;
          SetComponent(ST_PercentOfJobsIndelay_4, comp_Descr, false);
          ST_PercentOfJobsIndelay_4.Style.Color := PercentOfJobsIndelay_Color;
          ST_PercentOfJobsIndelay_4.Left   := ST_PercentOfJobsIndelay_3.Left + 180;
          ST_PercentOfJobsIndelay_4.Width  := 90;
          ST_PercentOfJobsIndelay_4.Height := 25;
          ST_PercentOfJobsIndelay_4.Style.Font.Size := 10;

          if J = 1 then
          begin
            if ScheduleStatistics_4.m_SumTotalPeriod.PercentOfJobsIndelay > 0 then
              ST_PercentOfJobsIndelay_4.Text := FloatToStr(ScheduleStatistics_4.m_SumTotalPeriod.PercentOfJobsIndelay) + '%';
          end
          else if IsWeekly then
          begin
            if ScheduleStatistics_4.m_SumArrayforWeeks[J-1].PercentOfJobsIndelay > 0 then
              ST_PercentOfJobsIndelay_4.Text := FloatToStr(ScheduleStatistics_4.m_SumArrayforWeeks[J-1].PercentOfJobsIndelay) + '%';
          end
          else
          begin
            if ScheduleStatistics_4.m_SumArrayforMonths[J-1].PercentOfJobsIndelay > 0 then
              ST_PercentOfJobsIndelay_4.Text := FloatToStr(ScheduleStatistics_4.m_SumArrayforMonths[J-1].PercentOfJobsIndelay) +  '%';
          end;

          ST_MinDaysTooEarly_4 := TcxTextEdit.Create(ScrollBox);
          ST_MinDaysTooEarly_4.Parent := ScrollBox;
          ST_MinDaysTooEarly_4.top    := ST_MinDaysTooEarly_1.Top;
          SetComponent(ST_MinDaysTooEarly_4, comp_Descr, false);
          ST_MinDaysTooEarly_4.Style.Color := MinDaysTooEarly_Color;
          ST_MinDaysTooEarly_4.Left   := ST_MinDaysTooEarly_3.Left + 180;
          ST_MinDaysTooEarly_4.Width  := 90;
          ST_MinDaysTooEarly_4.Height := 25;
          ST_MinDaysTooEarly_4.Style.Font.Size := 10;

          if J = 1 then
            ST_MinDaysTooEarly_4.Text := IntToStr(ScheduleStatistics_4.m_SumTotalPeriod.m_NumberOfJobsEarly)
          else if IsWeekly then
            ST_MinDaysTooEarly_4.Text := IntToStr(ScheduleStatistics_4.m_SumArrayforWeeks[J-1].m_NumberOfJobsEarly)
          else
            ST_MinDaysTooEarly_4.Text := IntToStr(ScheduleStatistics_4.m_SumArrayforMonths[J-1].m_NumberOfJobsEarly);

          ST_PercentOfJobsTooEarly_4 := TcxTextEdit.Create(ScrollBox);
          ST_PercentOfJobsTooEarly_4.Parent := ScrollBox;
          ST_PercentOfJobsTooEarly_4.top    := ST_PercentOfJobsTooEarly_1.top;// + 38;
          SetComponent(ST_PercentOfJobsTooEarly_4, comp_Descr, false);
          ST_PercentOfJobsTooEarly_4.Style.Color := PercentOfJobsTooEarly_Color;
          ST_PercentOfJobsTooEarly_4.Left   := ST_PercentOfJobsTooEarly_3.Left + + 180;
          ST_PercentOfJobsTooEarly_4.Width  := 90;
          ST_PercentOfJobsTooEarly_4.Height := 25;
          ST_PercentOfJobsTooEarly_4.Style.Font.Size := 10;

          if J = 1 then
          begin
            if (ScheduleStatistics_4.m_SumTotalPeriod.m_NumberOfJobs_Total_ForDelayCalc > 0) and
               (ScheduleStatistics_4.m_SumTotalPeriod.m_NumberOfJobsEarly > 0) then
              ST_PercentOfJobsTooEarly_4.Text := FormatFloat('0.0', ScheduleStatistics_4.m_SumTotalPeriod.m_NumberOfJobsEarly /
                                                            ScheduleStatistics_4.m_SumTotalPeriod.m_NumberOfJobs_Total_ForDelayCalc * 100) + '%'
          end
          else if IsWeekly then
          begin
            if (ScheduleStatistics_4.m_SumArrayforWeeks[J-1].m_NumberOfJobs_Total_ForDelayCalc > 0) and
               (ScheduleStatistics_4.m_SumArrayforWeeks[J-1].m_NumberOfJobsEarly > 0) then
              ST_PercentOfJobsTooEarly_4.Text := FormatFloat('0.0', ScheduleStatistics_4.m_SumArrayforWeeks[J-1].m_NumberOfJobsEarly /
                                                            ScheduleStatistics_4.m_SumArrayforWeeks[J-1].m_NumberOfJobs_Total_ForDelayCalc * 100) + '%'
          end
          else
          begin
            if (ScheduleStatistics_4.m_SumArrayforMonths[J-1].m_NumberOfJobs_Total_ForDelayCalc > 0) and
               (ScheduleStatistics_4.m_SumArrayforMonths[J-1].m_NumberOfJobsEarly > 0) then
            ST_PercentOfJobsTooEarly_4.Text := FormatFloat('0.0', ScheduleStatistics_4.m_SumArrayforMonths[J-1].m_NumberOfJobsEarly /
                                                          ScheduleStatistics_4.m_SumArrayforMonths[J-1].m_NumberOfJobs_Total_ForDelayCalc * 100) + '%';
          end;

          ST_TotalSetupHours_4 := TcxTextEdit.Create(ScrollBox);
          ST_TotalSetupHours_4.Parent := ScrollBox;
          ST_TotalSetupHours_4.top    := ST_TotalSetupHours_1.top;// + 38;
          SetComponent(ST_TotalSetupHours_4, comp_Descr, false);
          St_TotalSetupHours_4.Style.color := TotalSetupHours_Color;
          ST_TotalSetupHours_4.Left   := ST_TotalSetupHours_3.Left + 180;
          ST_TotalSetupHours_4.Width  := 90;
          ST_TotalSetupHours_4.Height := 25;
          ST_TotalSetupHours_4.Style.Font.Size := 10;

          if J = 1 then
            TotSetupHours := ScheduleStatistics_4.m_SumTotalPeriod.TotalSetupHours
          else
          begin
            if IsWeekly then
              TotSetupHours := ScheduleStatistics_4.m_SumArrayforWeeks[J - 1].TotalSetupHours
            else
              TotSetupHours := ScheduleStatistics_4.m_SumArrayforMonths[J - 1].TotalSetupHours;
          end;

          TempExt := Frac(TotSetupHours);
          S := FloatToStr(TempExt);
          if Length(S) > 3 then
          begin
            S := Copy(s, 2, 3);
            TotSetupHoursStr := FloatToStr(trunc(TotSetupHours));
            TotSetupHoursStr := TotSetupHoursStr + S;
          end
          else
            TotSetupHoursStr := FloatToStr(TotSetupHours);
          ST_TotalSetupHours_4.Text := TotSetupHoursStr;

          ST_PercentOfSetupHours_4 := TcxTextEdit.Create(ScrollBox);
          ST_PercentOfSetupHours_4.Parent := ScrollBox;
          ST_PercentOfSetupHours_4.top    := ST_PercentOfSetupHours_1.top; //+ 38;
          SetComponent(St_PercentOfSetupHours_4, comp_Descr, false);
          St_PercentOfSetupHours_4.Style.color := PercentOfSetupHours_Color;
          ST_PercentOfSetupHours_4.Left   := ST_PercentOfSetupHours_3.Left + 180;
          ST_PercentOfSetupHours_4.Width  := 90;
          ST_PercentOfSetupHours_4.Height := 25;
          ST_PercentOfSetupHours_4.Style.Font.Size := 10;

          if J = 1 then
            Percent := ScheduleStatistics_4.m_SumTotalPeriod.PercentOfSetupHours
          else
          begin
            if IsWeekly then
              Percent := ScheduleStatistics_4.m_SumArrayforWeeks[J - 1].PercentOfSetupHours
            else
              Percent := ScheduleStatistics_4.m_SumArrayforMonths[J - 1].PercentOfSetupHours;
          end;

          TempExt := Frac(Percent);
          S := FloatToStr(TempExt);
          if Length(S) > 3 then
          begin
            S := Copy(s, 2, 3);
            PercentStr := FloatToStr(trunc(Percent));
            PercentStr := PercentStr + S;
          end
          else
            PercentStr := FloatToStr(Percent);

          ST_PercentOfSetupHours_4.Text := PercentStr + '%';

       {   if J = 1 then
            ST_PercentOfSetupHours_4.Caption := FloatToStr(ScheduleStatistics_4.m_SumTotalPeriod.PercentOfSetupHours)
          else if IsWeekly then
            ST_PercentOfSetupHours_4.Caption := FloatToStr(ScheduleStatistics_4.m_SumArrayforWeeks[J-1].PercentOfSetupHours)
          else
            ST_PercentOfSetupHours_4.Caption := FloatToStr(ScheduleStatistics_4.m_SumArrayforMonths[J-1].PercentOfSetupHours);
        }
          ST_TotalHoursExecution_4 := TcxTextEdit.Create(ScrollBox);
          ST_TotalHoursExecution_4.Parent := ScrollBox;
          ST_TotalHoursExecution_4.top    := ST_TotalHoursExecution_1.top;// + 38;
          SetComponent(St_TotalHoursExecution_4, comp_Descr, false);
          St_TotalHoursExecution_4.Style.Color := TotalHoursExecution_Color;
          ST_TotalHoursExecution_4.Left   := ST_TotalHoursExecution_3.Left + 180;
          ST_TotalHoursExecution_4.Width  := 90;
          ST_TotalHoursExecution_4.Height := 25;
          ST_TotalHoursExecution_4.Style.Font.Size := 10;

          if J = 1 then
            TotExecutionHours := ScheduleStatistics_4.m_SumTotalPeriod.TotalHoursExecution
          else
          begin
            if IsWeekly then
              TotExecutionHours := ScheduleStatistics_4.m_SumArrayforWeeks[J - 1].TotalHoursExecution
            else
              TotExecutionHours := ScheduleStatistics_4.m_SumArrayforMonths[J - 1].TotalHoursExecution;
          end;

          TempExt := Frac(TotExecutionHours);
          S := FloatToStr(TempExt);
          if Length(S) > 3 then
          begin
            S := Copy(s, 2, 3);
            TotExecutionHoursStr := FloatToStr(trunc(TotExecutionHours));
            TotExecutionHoursStr := TotExecutionHoursStr + S;
          end
          else
            TotExecutionHoursStr := FloatToStr(TotExecutionHours);

          ST_TotalHoursExecution_4.Text := TotExecutionHoursStr;

         { if J = 1 then
            ST_TotalHoursExecution_4.Caption := FloatToStr(ScheduleStatistics_4.m_SumTotalPeriod.TotalSetupHours)
          else if IsWeekly then
            ST_TotalHoursExecution_4.Caption := FloatToStr(ScheduleStatistics_4.m_SumArrayforWeeks[J-1].TotalSetupHours)
          else
            ST_TotalHoursExecution_4.Caption := FloatToStr(ScheduleStatistics_4.m_SumArrayforMonths[J-1].TotalSetupHours);
          }
          ST_TotalHoursOfOccPerGanttOcc_4 := TcxTextEdit.Create(ScrollBox);
          ST_TotalHoursOfOccPerGanttOcc_4.Parent := ScrollBox;
          ST_TotalHoursOfOccPerGanttOcc_4.top    := ST_TotalHoursOfOccPerGanttOcc_1.top;// + 38;
          SetComponent(St_TotalHoursOfOccPerGanttOcc_4, comp_Descr, false);
          St_TotalHoursOfOccPerGanttOcc_4.Style.Color := TotalHoursOfOccPerGanttOcc_Color;
          ST_TotalHoursOfOccPerGanttOcc_4.Left   := ST_TotalHoursOfOccPerGanttOcc_3.Left + 180;
          ST_TotalHoursOfOccPerGanttOcc_4.Width  := 90;
          ST_TotalHoursOfOccPerGanttOcc_4.Height := 25;
          ST_TotalHoursOfOccPerGanttOcc_4.Style.Font.Size := 10;

          if J = 1 then
            PercentHoursPerOccMachine := ScheduleStatistics_4.m_SumTotalPeriod.PercentHoursOfOccPerGanttOcc
          else
          begin
            if IsWeekly then
              PercentHoursPerOccMachine := ScheduleStatistics_4.m_SumArrayforWeeks[J - 1].PercentHoursOfOccPerGanttOcc
            else
              PercentHoursPerOccMachine := ScheduleStatistics_4.m_SumArrayforMonths[J - 1].PercentHoursOfOccPerGanttOcc;
          end;

        {  TempExt := Frac(PercentHoursPerOccMachine);
          S := FloatToStr(TempExt);
          if Length(S) > 3 then
          begin
            S := Copy(s, 2, 3);
            TotExecutionHoursPerOccMachineStr := FloatToStr(trunc(PercentHoursPerOccMachine));
            TotExecutionHoursPerOccMachineStr := TotExecutionHoursPerOccMachineStr + S;
          end
          else
            TotExecutionHoursPerOccMachineStr := FloatToStr(PercentHoursPerOccMachine); }

          if PercentHoursPerOccMachine > 100 then
             PercentHoursPerOccMachine := 100;
          ST_TotalHoursOfOccPerGanttOcc_4.Text := FloatToStr(PercentHoursPerOccMachine) + '%';

{          if J = 1 then
            ST_TotalHoursOfOccPerGanttOcc_4.Caption := FloatToStr(ScheduleStatistics_4.m_SumTotalPeriod.TotalHoursOfOccPerGanttOcc)
          else if IsWeekly then
            ST_TotalHoursOfOccPerGanttOcc_4.Caption := FloatToStr(ScheduleStatistics_4.m_SumArrayforWeeks[J-1].TotalHoursOfOccPerGanttOcc)
          else
            ST_TotalHoursOfOccPerGanttOcc_4.Caption := FloatToStr(ScheduleStatistics_4.m_SumArrayforMonths[J-1].TotalHoursOfOccPerGanttOcc);
 }
          ST_MaxCaseForResource_4 := TcxTextEdit.Create(ScrollBox);
          ST_MaxCaseForResource_4.Parent := ScrollBox;
          ST_MaxCaseForResource_4.top    := ST_MaxCaseForResource_1.top; //+ 38;
          SetComponent(St_MaxCaseForResource_4, comp_Descr, false);
          St_MaxCaseForResource_4.Style.Color := MaxCaseForResource_Color;
          ST_MaxCaseForResource_4.Left   := ST_MaxCaseForResource_3.Left + 180;
          ST_MaxCaseForResource_4.Width  := 90;
          ST_MaxCaseForResource_4.Height := 25;
          ST_MaxCaseForResource_4.Style.Font.Size := 10;

          if J = 1 then
            ST_MaxCaseForResource_4.Text := FloatToStr(ScheduleStatistics_4.m_SumTotalPeriod.MaxCaseForResource)
          else if IsWeekly then
            ST_MaxCaseForResource_4.Text := FloatToStr(ScheduleStatistics_4.m_SumArrayforWeeks[J-1].MaxCaseForResource)
          else
            ST_MaxCaseForResource_4.Text := FloatToStr(ScheduleStatistics_4.m_SumArrayforMonths[J-1].MaxCaseForResource);

          ST_PercentOfjobsCaseForEachResCase_4 := TButtonShowDetails.Create(ScrollBox);
          ST_PercentOfjobsCaseForEachResCase_4.Parent := ScrollBox;
          ST_PercentOfjobsCaseForEachResCase_4.top    := ST_PercentOfjobsCaseForEachResCase_1.top;// + 38;
//          SetComponent(St_PercentOfjobsCaseForEachResCase_4, comp_Descr, false);
          ST_PercentOfjobsCaseForEachResCase_4.Left   := ST_PercentOfjobsCaseForEachResCase_3.Left + 180;
          ST_PercentOfjobsCaseForEachResCase_4.Width  := 100;
          ST_PercentOfjobsCaseForEachResCase_4.Height := 28;
          ST_PercentOfjobsCaseForEachResCase_4.Font.Size := 10;
          ST_PercentOfjobsCaseForEachResCase_4.Caption := 'Breakdown';
          ST_PercentOfjobsCaseForEachResCase_4.OnClick := OnClickCompactCasesRes;
          ST_PercentOfjobsCaseForEachResCase_4.ShowHint := true;
          ST_PercentOfjobsCaseForEachResCase_4.Hint    := 'breakdown by case of compatibility';
          ST_PercentOfjobsCaseForEachResCase_4.Font.Assign(ST_DelayBandsShow.Font); // match the delay/early breakdown buttons exactly

          if J = 1 then
          begin
            ST_PercentOfjobsCaseForEachResCase_4.m_PercentOfjobsCaseForEachResCase := ScheduleStatistics_4.m_SumTotalPeriod.PercentOfjobsCaseForEachResCase;
            ST_PercentOfjobsCaseForEachResCase_4.m_NumberOfJobs := ScheduleStatistics_4.m_SumTotalPeriod.m_NumberOfJobs_Total_ForResCase;
          end
          else
          begin
            if IsWeekly then
            begin
              ST_PercentOfjobsCaseForEachResCase_4.m_PercentOfjobsCaseForEachResCase := ScheduleStatistics_4.m_SumArrayforWeeks[J-1].PercentOfjobsCaseForEachResCase;
              ST_PercentOfjobsCaseForEachResCase_4.m_NumberOfJobs := ScheduleStatistics_4.m_SumArrayforWeeks[J-1].m_NumberOfJobs_Total_ForResCase
            end
            else
            begin
              ST_PercentOfjobsCaseForEachResCase_4.m_PercentOfjobsCaseForEachResCase := ScheduleStatistics_4.m_SumArrayforMonths[J-1].PercentOfjobsCaseForEachResCase;
              ST_PercentOfjobsCaseForEachResCase_4.m_NumberOfJobs := ScheduleStatistics_4.m_SumArrayforMonths[J-1].m_NumberOfJobs_Total_ForResCase;
            end;
          end;

          ST_MaxCaseJobToJob_4 := TcxTextEdit.Create(ScrollBox);
          ST_MaxCaseJobToJob_4.Parent := ScrollBox;
          ST_MaxCaseJobToJob_4.top    := ST_MaxCaseJobToJob_1.top;// + 38;
          SetComponent(ST_MaxCaseJobToJob_4, comp_Descr, false);
          ST_MaxCaseJobToJob_4.Style.Color := MaxCaseJobToJob_Color;
          ST_MaxCaseJobToJob_4.Left   := ST_MaxCaseJobToJob_3.Left + 180;
          ST_MaxCaseJobToJob_4.Width  := 90;
          ST_MaxCaseJobToJob_4.Height := 25;
          ST_MaxCaseJobToJob_4.Style.Font.Size := 10;

          if J = 1 then
            ST_MaxCaseJobToJob_4.Text := IntToStr(ScheduleStatistics_4.m_SumTotalPeriod.MaxCaseJobToJob)
          else
          begin
            if IsWeekly then
              ST_MaxCaseJobToJob_4.Text := IntToStr(ScheduleStatistics_4.m_SumArrayforWeeks[J - 1].MaxCaseJobToJob)
            else
              ST_MaxCaseJobToJob_4.Text := IntToStr(ScheduleStatistics_4.m_SumArrayforMonths[J - 1].MaxCaseJobToJob);
          end;

          ST_PercentOfjobsCaseForEachJobToJobCase_4 := TButtonShowDetails.Create(ScrollBox);
          ST_PercentOfjobsCaseForEachJobToJobCase_4.Parent := ScrollBox;
          ST_PercentOfjobsCaseForEachJobToJobCase_4.top    := ST_PercentOfjobsCaseForEachJobToJobCase_1.top; //+ 38;
       //   SetComponent(ST_PercentOfjobsCaseForEachJobToJobCase_4, comp_Descr, false);
          ST_PercentOfjobsCaseForEachJobToJobCase_4.Left   := ST_PercentOfjobsCaseForEachJobToJobCase_3.Left + 180;
          ST_PercentOfjobsCaseForEachJobToJobCase_4.Width  := 100;
          ST_PercentOfjobsCaseForEachJobToJobCase_4.Height := 28;
          ST_PercentOfjobsCaseForEachJobToJobCase_4.Font.Size := 10;
          ST_PercentOfjobsCaseForEachJobToJobCase_4.Caption := _('Breakdown');
          ST_PercentOfjobsCaseForEachJobToJobCase_4.OnClick := OnClickCompactCasesJobToJob;
          ST_PercentOfjobsCaseForEachJobToJobCase_4.ShowHint := true;
          ST_PercentOfjobsCaseForEachJobToJobCase_4.Hint    := _('breakdown by case of compatibility');
          ST_PercentOfjobsCaseForEachJobToJobCase_4.Font.Assign(ST_DelayBandsShow.Font); // match the delay/early breakdown buttons exactly

          if J = 1 then
          begin
            ST_PercentOfjobsCaseForEachJobToJobCase_4.m_PercentOfjobsCaseForEachJobToJobCase := ScheduleStatistics_4.m_SumTotalPeriod.PercentOfjobsCaseForEachJobToJobCase;
            ST_PercentOfjobsCaseForEachJobToJobCase_4.m_NumberOfJobs := ScheduleStatistics_4.m_SumTotalPeriod.m_NumberOfJobs_Total_ForJobToJobCase
          end
          else
          begin
            if IsWeekly then
            begin
              ST_PercentOfjobsCaseForEachJobToJobCase_4.m_PercentOfjobsCaseForEachJobToJobCase := ScheduleStatistics_4.m_SumArrayforWeeks[J - 1].PercentOfjobsCaseForEachJobToJobCase;
              ST_PercentOfjobsCaseForEachJobToJobCase_4.m_NumberOfJobs := ScheduleStatistics_4.m_SumArrayforWeeks[J - 1].m_NumberOfJobs_Total_ForJobToJobCase
            end
            else
            begin
              ST_PercentOfjobsCaseForEachJobToJobCase_4.m_PercentOfjobsCaseForEachJobToJobCase := ScheduleStatistics_4.m_SumArrayforMonths[J - 1].PercentOfjobsCaseForEachJobToJobCase;
              ST_PercentOfjobsCaseForEachJobToJobCase_4.m_NumberOfJobs := ScheduleStatistics_4.m_SumArrayforMonths[J - 1].m_NumberOfJobs_Total_ForJobToJobCase;
            end;
          end;

          ST_NumberOfjobsWithoutMaterial_4 := TcxTextEdit.Create(ScrollBox);
          ST_NumberOfjobsWithoutMaterial_4.Parent := ScrollBox;
          ST_NumberOfjobsWithoutMaterial_4.top    := ST_NumberOfjobsWithoutMaterial_1.top;// + 38;
          SetComponent(ST_NumberOfjobsWithoutMaterial_4, comp_Descr, false);
          ST_NumberOfjobsWithoutMaterial_4.Style.Color := NumberOfjobsWithoutMaterial_Color;
          ST_NumberOfjobsWithoutMaterial_4.Left   := ST_NumberOfjobsWithoutMaterial_3.Left + 180;
          ST_NumberOfjobsWithoutMaterial_4.Width  := 90;
          ST_NumberOfjobsWithoutMaterial_4.Height := 25;
          ST_NumberOfjobsWithoutMaterial_4.Style.Font.Size := 10;

          if J = 1 then
            ST_NumberOfjobsWithoutMaterial_4.Text := IntToStr(ScheduleStatistics_4.m_SumTotalPeriod.NumberOfjobsWithoutMaterial)
          else
          begin
            if IsWeekly then
              ST_NumberOfjobsWithoutMaterial_4.Text := IntToStr(ScheduleStatistics_4.m_SumArrayforWeeks[J - 1].NumberOfjobsWithoutMaterial)
            else
              ST_NumberOfjobsWithoutMaterial_4.Text := IntToStr(ScheduleStatistics_4.m_SumArrayforMonths[J - 1].NumberOfjobsWithoutMaterial);
          end;

       {   ST_NumberOfjobsWithoutTools_4 := TcxTextEdit.Create(ScrollBox);
          ST_NumberOfjobsWithoutTools_4.Parent := ScrollBox;
          ST_NumberOfjobsWithoutTools_4.top    := ST_NumberOfjobsWithoutTools_1.top;// + 38;
          SetComponent(ST_NumberOfjobsWithoutTools_4, comp_Descr, false);
          ST_NumberOfjobsWithoutTools_4.Left   := ST_NumberOfjobsWithoutTools_3.Left + 180;
          ST_NumberOfjobsWithoutTools_4.Width  := 90;
          ST_NumberOfjobsWithoutTools_4.Height := 25;
          ST_NumberOfjobsWithoutTools_4.Font.Size := 10;

          if J = 1 then
            ST_NumberOfjobsWithoutTools_4.Caption := IntToStr(ScheduleStatistics_4.m_SumTotalPeriod.NumberOfjobsWithoutTools)
          else
          begin
            if IsWeekly then
              ST_NumberOfjobsWithoutTools_4.Caption := IntToStr(ScheduleStatistics_4.m_SumArrayforWeeks[J - 1].NumberOfjobsWithoutTools)
            else
              ST_NumberOfjobsWithoutTools_4.Caption := IntToStr(ScheduleStatistics_4.m_SumArrayforMonths[J - 1].NumberOfjobsWithoutTools);
          end;  }

          ST_NumberOfjobsWithoutManPawer_4 := TcxTextEdit.Create(ScrollBox);
          ST_NumberOfjobsWithoutManPawer_4.Parent := ScrollBox;
          ST_NumberOfjobsWithoutManPawer_4.top    := ST_NumberOfjobsWithoutManPawer_1.top;// + 38;
          SetComponent(ST_NumberOfjobsWithoutManPawer_4, comp_Descr, false);
          ST_NumberOfjobsWithoutManPawer_4.Style.Color := NumberOfjobsWithoutManPawer_Color;
          ST_NumberOfjobsWithoutManPawer_4.Left   := ST_NumberOfjobsWithoutManPawer_3.Left + 180;
          ST_NumberOfjobsWithoutManPawer_4.Width  := 90;
          ST_NumberOfjobsWithoutManPawer_4.Height := 25;
          ST_NumberOfjobsWithoutManPawer_4.Style.Font.Size := 10;

          if J = 1 then
            ST_NumberOfjobsWithoutManPawer_4.Text := IntToStr(ScheduleStatistics_4.m_SumTotalPeriod.NumberOfjobsWithoutManPawer)
          else
          begin
            if IsWeekly then
              ST_NumberOfjobsWithoutManPawer_4.Text := IntToStr(ScheduleStatistics_4.m_SumArrayforWeeks[J - 1].NumberOfjobsWithoutManPawer)
            else
              ST_NumberOfjobsWithoutManPawer_4.Text := IntToStr(ScheduleStatistics_4.m_SumArrayforMonths[J - 1].NumberOfjobsWithoutManPawer);
          end;

          ST_NumberOfjobsWithoutAnyAddRes_4 := TcxTextEdit.Create(ScrollBox);
          ST_NumberOfjobsWithoutAnyAddRes_4.Parent := ScrollBox;
          ST_NumberOfjobsWithoutAnyAddRes_4.top    := ST_NumberOfjobsWithoutAnyAddRes_1.top;// + 38;
          SetComponent(ST_NumberOfjobsWithoutAnyAddRes_4, comp_Descr, false);
          ST_NumberOfjobsWithoutAnyAddRes_4.Style.Color := NumberOfjobsWithoutAnyAddRes_Color;
          ST_NumberOfjobsWithoutAnyAddRes_4.Left   := ST_NumberOfjobsWithoutAnyAddRes_3.Left + 180;
          ST_NumberOfjobsWithoutAnyAddRes_4.Width  := 90;
          ST_NumberOfjobsWithoutAnyAddRes_4.Height := 25;
          ST_NumberOfjobsWithoutAnyAddRes_4.Style.Font.Size := 10;

           if J = 1 then
            ST_NumberOfjobsWithoutAnyAddRes_4.Text := IntToStr(ScheduleStatistics_4.m_SumTotalPeriod.NumberOfjobsWithoutAnyAddRes)
          else
          begin
            if IsWeekly then
              ST_NumberOfjobsWithoutAnyAddRes_4.Text := IntToStr(ScheduleStatistics_4.m_SumArrayforWeeks[J - 1].NumberOfjobsWithoutAnyAddRes)
            else
              ST_NumberOfjobsWithoutAnyAddRes_4.Text := IntToStr(ScheduleStatistics_4.m_SumArrayforMonths[J - 1].NumberOfjobsWithoutAnyAddRes);
          end;

          ST_TotalUomProduced_4 := TButtonShowDetails.Create(ScrollBox);
          ST_TotalUomProduced_4.Parent := ScrollBox;
          ST_TotalUomProduced_4.top    := TotalUomProduced_Lbl.top;// + 38;
          //SetComponent(ST_TotalUomProduced_4, comp_Descr, false);
          ST_TotalUomProduced_4.font.Color := TotalUomProduced_Color;
          ST_TotalUomProduced_4.Left   := ST_TotalUomProduced_3.Left + 180;
          ST_TotalUomProduced_4.Width  := 90;
          ST_TotalUomProduced_4.Height := 25;
          ST_TotalUomProduced_4.Font.Size := 10;

          ST_TotalUomProduced_4.Caption := 'Show';
          ST_TotalUomProduced_4.OnClick := OnClickTotalUomProduced;
          ST_TotalUomProduced_4.ShowHint := true;
          ST_TotalUomProduced_4.Hint    := 'Show details';
          ST_TotalUomProduced_4.CustomHint := FMQMPlan.BalloonHint1;

          if J = 1 then
            ST_TotalUomProduced_4.m_ListUmQtyDetails := ScheduleStatistics_4.m_SumTotalPeriod.TotalUomProduced
          else
          begin
            if IsWeekly then
              ST_TotalUomProduced_4.m_ListUmQtyDetails := ScheduleStatistics_4.m_SumArrayforWeeks[J - 1].TotalUomProduced
            else
              ST_TotalUomProduced_4.m_ListUmQtyDetails := ScheduleStatistics_4.m_SumArrayforMonths[J - 1].TotalUomProduced;
          end;

        end;


      end;
    end;

  end;

  ReShape(Self);

end;

//----------------------------------------------------------------------------//

procedure TFStatistics.EditStatisticNameChange(Sender: TObject);
var
  I, J, C, S, F, E : Integer;
  mainTabSheet, TabSheet, TmpTabSheet : TTabSheet;
  ViewPage : TMViewPage;
  Panel : TPanel;
  staticText : TcxTextEdit;
begin
  for i := 0 to m_PgcStatistics_Tab.ComponentCount - 1 do
  begin
    mainTabSheet := TTabSheet(m_PgcStatistics_Tab.Components[I]);
    for J := 0 to mainTabSheet.ComponentCount - 1 do
    begin
      ViewPage := TMViewPage(mainTabSheet.Components[J]);
      for C := 0 to ViewPage.ComponentCount - 1 do
      begin
        TabSheet := TTabSheet(ViewPage.Components[C]);
        for S := 0 to TabSheet.ComponentCount - 1 do
        begin
          if (TabSheet.Components[S] is TPanel) and (TabSheet.Components[S].name = 'PanelTitle') then
          begin
            Panel := TPanel(TabSheet.Components[S]);
            for E := 0 to Panel.ComponentCount - 1 do
            begin
              if Panel.Components[E].Name = 'staticText1' then
              begin
                staticText := TcxTextEdit(Panel.Components[E]);
                staticText.Text := EditStatisticName.text;
                staticText.Refresh;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFStatistics.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  if m_ShowOnly then exit;
  if ModalResult <> mrOk then
    DeleteLastScheduleStatistics
  else
  begin
    if not m_ShowOnly and (Trim(EditStatisticName.Text) = '') then
    begin
      ModalResult := mrCancel;
      showmessage(_('Please insert name for the statistic'));
      Abort;
    end
    else
      SetScheduleStatisticName(0, EditStatisticName.Text);
  end;
end;

//----------------------------------------------------------------------------//

procedure TFStatistics.FormShow(Sender: TObject);
begin
  EditStatisticName.SetFocus;
  if m_ShowOnly then
  begin
    LableName.Visible := false;
    EditStatisticName.Visible := false;
    BtnAbo.Visible := false;
  end;

end;

{ TabSheetStatistics }

constructor TabSheetStatistics.CreateTabShiitStatistics(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Assert(AOwner is TPageControl);
  PageControl := TPageControl(AOwner);
end;

//----------------------------------------------------------------------------//

{ TabSheetWeek }

constructor TabSheetPeriod.CreateTabShiitStatisticsPeriod(AOwner: TComponent; startDate, enddate : TDateTime);
begin
  inherited Create(AOwner);
  Assert(AOwner is TPageControl);
  PageControl := TPageControl(AOwner);
  m_startDate := startDate;
  m_enddate   := enddate;
end;

//----------------------------------------------------------------------------//

procedure TabSheetPeriod.OnClickCompactCasesJobToJob(Sender: TObject);
var
  CompCasePercent : TStatisticsDetails;
  I : Integer;
  found : boolean;
begin
  Found := false;
  for I := Low(TButtonShowDetails(Sender as TButtonShowDetails).m_PercentOfjobsCaseForEachJobToJobCase) to High(TButtonShowDetails(Sender as TButtonShowDetails).m_PercentOfjobsCaseForEachJobToJobCase) do
  begin
    if TButtonShowDetails(Sender as TButtonShowDetails).m_PercentOfjobsCaseForEachJobToJobCase[I] > 0 then
    begin
      found := true;
      break
    end;
  end;

  CompCasePercent := TStatisticsDetails.CreateTCompCasePercent(self, TButtonShowDetails(Sender as TButtonShowDetails).m_PercentOfjobsCaseForEachJobToJobCase, TButtonShowDetails(Sender as TButtonShowDetails).m_NumberOfJobs, false);

  CompCasePercent.ShowModal;
  CompCasePercent.Free
end;

//----------------------------------------------------------------------------//

procedure TabSheetPeriod.OnClickCompactCasesRes(Sender: TObject);
var
  CompCasePercent : TStatisticsDetails;
  I : Integer;
  Found : boolean;
begin
  Found := false;
  for I := Low(TButtonShowDetails(Sender as TButtonShowDetails).m_PercentOfjobsCaseForEachResCase) to High(TButtonShowDetails(Sender as TButtonShowDetails).m_PercentOfjobsCaseForEachResCase) do
  begin
    if TButtonShowDetails(Sender as TButtonShowDetails).m_PercentOfjobsCaseForEachResCase[I] > 0 then
    begin
      found := true;
      break
    end;
  end;
  if not found then exit;

  CompCasePercent := TStatisticsDetails.CreateTCompCasePercent(self, TButtonShowDetails(Sender as TButtonShowDetails).m_PercentOfjobsCaseForEachResCase, TButtonShowDetails(Sender as TButtonShowDetails).m_NumberOfJobs, true);
  CompCasePercent.ShowModal;
  CompCasePercent.Free
end;

//----------------------------------------------------------------------------//

procedure TabSheetPeriod.OnClickTotalUomProduced(Sender: TObject);
var
  StatisticsDetails : TStatisticsDetails;
begin
  StatisticsDetails := TStatisticsDetails.CreateTotalUomProduced(self, TButtonShowDetails(Sender as TButtonShowDetails).m_ListUmQtyDetails);
  StatisticsDetails.ShowModal;
  StatisticsDetails.Free
end;

//----------------------------------------------------------------------------//

procedure TabSheetPeriod.OnClickDelayBands(Sender: TObject);
var
  btn     : TButtonShowDetails;
  details : TStatisticsDetails;
  rg      : TResOfGanttTab;
  rec     : TStatisticRecordPeriod;
  idx, n, J : Integer;
  weekly  : Boolean;
  bands   : array[0..3] of TDelayBandCounts;
  denoms  : array[0..3] of Integer;
  names   : array[0..3] of string;
begin
  btn    := Sender as TButtonShowDetails;
  J      := btn.m_DelayPeriodIndex;
  weekly := btn.m_DelayIsWeekly;

  // Gather the delay (or early) bands for every saved schedule (1..4) for this same period, by end date.
  n := 0;
  for idx := 1 to 4 do
  begin
    rg := TResOfGanttTab(GetStatisticOfGantTabByIndex(idx, btn.m_DelayGanttName));
    if rg = nil then
      break;

    if J = 1 then
      rec := rg.m_SumTotalPeriod
    else if weekly then
      rec := rg.m_SumArrayforWeeks[J - 1]
    else
      rec := rg.m_SumArrayforMonths[J - 1];

    if btn.m_DelayIsEarly then
      bands[n] := rec.m_EarlyBands
    else
      bands[n] := rec.m_DelayBands;
    denoms[n] := rec.m_NumberOfJobs_Total_ForDelayCalc;
    names[n]  := GetSetScheduleStatisticName(idx - 1); // blank when the schedule has no saved name
    Inc(n);
  end;

  if n = 0 then
    exit;

  details := TStatisticsDetails.CreateDelayBands(self, Slice(bands, n), Slice(denoms, n), Slice(names, n), btn.m_DelayTitle, btn.m_DelayIsEarly);
  details.ShowModal;
  details.Free;
end;

//----------------------------------------------------------------------------//

constructor TButtonShowDetails.CreateTButtonDetails(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

end.
