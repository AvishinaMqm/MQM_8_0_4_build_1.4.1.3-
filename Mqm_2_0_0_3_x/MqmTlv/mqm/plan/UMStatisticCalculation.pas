unit UMStatisticCalculation;

interface

uses System.Classes, UMSchedContFunc, UGbaseCal, UMRes, UMActArea;

const
  // Delay-band buckets for "jobs in delay" by lateness (days late = endDate - dueDate).
  // 6 bands: <1, 1-4, 4-7, 7-14, 14-28, >=28 days. See g_DelayBandUpper for the cut points.
  DELAY_BAND_COUNT = 6;

type

  TPercentArrayCompact = array[1..99] of Integer;

  TDelayBandCounts = array[1..DELAY_BAND_COUNT] of Integer; // one job count per lateness band

  TTotalUmProduced = record
    UM : string;
    totalQty : double;
  end;
  PTTotalUmProduced = ^TTotalUmProduced;

  TStatisticRecordPeriod = record // week , month , year

    m_StartOfPeriod_Week : TDateTime;
    m_EndOfPeriod_Week   : TDateTime;

    m_StartOfPeriod_Month : TDateTime;
    m_EndOfPeriod_Month   : TDateTime;

    m_StartOfPeriod_Total : TDateTime;
    m_EndOfPeriod_Total   : TDateTime;

    m_NumberOfJobs_Total_ForDelayCalc : integer;
    m_NumberOfJobsDelay : integer;
    m_NumberOfJobs_Total_ForTooEarlyCalc : integer;
    m_NumberOfJobsToEarly : integer;

    ////  statistic data

    MinDaysDelay : integer;
    MaxDaysDelay : integer;
    TotDaysDelay : integer;
    m_DelayBands : TDelayBandCounts; // count of delayed jobs per lateness band; index via DelayBandIndex
    m_NumberOfJobsEarly : integer;   // jobs finishing >= 1 day early (HighEndDate - endDate), by end date
    m_EarlyBands : TDelayBandCounts; // count of early jobs per earliness band; bands 2..6 only (drop '<1')

    PercentOfJobsIndelay : double;
    MinDaysTooEarly : integer;
    MaxDaysTooEarly : integer;
    TotDaysTooEarly : integer;
    PercentOfJobsTooEarly : double;
    TotalSetupHours : double;
    PercentOfSetupHours : double;
    TotalSetupAndExecution : double;
    TotalHoursExecution : double;
    TotalHoursOfOccPerGanttOcc : double;
    TotalHoursAvailableOnGantt : double;
    PercentHoursOfOccPerGanttOcc : double;
    MinCaseForResource : integer;
    MaxCaseForResource : integer;
    m_NumberOfJobs_Total_ForResCase : integer;
    PercentOfjobsCaseForEachResCase : TPercentArrayCompact;
    MinCaseJobToJob : integer;
    MaxCaseJobToJob : integer;
    m_NumberOfJobs_Total_ForJobToJobCase : integer;
    PercentOfjobsCaseForEachJobToJobCase : TPercentArrayCompact;

    NumberOfjobsWithoutMaterial : integer;
    NumberOfjobsWithoutTools : integer;
    NumberOfjobsWithoutManPawer : integer;
    NumberOfjobsWithoutAnyAddRes : integer;
    TotalUomProduced : TList;
  end;

  TScheduleStatistics = class;

  TResOfGanttTab = class
    constructor CreateResOfGanttTab(DateTimeCreate : TDateTime);
    destructor destroy; override;
    Procedure IniSumArrays;
  public
    ResList : TList;
    m_ganttTabName : string; // change the default tab name from 'plan tab' to 'view 1 2 3 ''''
    m_SumArrayforWeeks : Array [1..12] of TStatisticRecordPeriod;
    m_SumArrayforMonths : Array [1..4] of TStatisticRecordPeriod;
    m_SumTotalPeriod   : TStatisticRecordPeriod;
    m_ActiveTab        : boolean;
    m_DatetimeCreate  : TDateTime;
    m_ScheduleStatistics : TScheduleStatistics;
    // in this array , we calc the sum for all the resources statistic in the gantt ..
    // the data will be taken from the already calculated CreateScheduleStatistics for all the plan.
  end;

  TResOfMqm = class
    VisRes : TMqmVisibleRes;
    m_ArrayOfWeeks  : Array [1..12] of TStatisticRecordPeriod;
    m_ArrayOfMonths : Array [1..4] of TStatisticRecordPeriod;
    m_TotalPeriod   : TStatisticRecordPeriod;
    m_IsWeekly : boolean;
    m_ResCode : string;
    constructor CreateResOfMqm(IsWeekly : boolean);
    destructor destroy; override;
    Procedure IniArray;
  end;

  TScheduleStatistics = class
    constructor CreateScheduleStatistics(ListGanttTabs : TList; IsWeekly : boolean; StackMark : integer);
//    constructor ShowScheduleStatistics(ListGanttTabs : TList; IsWeekly : boolean; StackMark : integer);
    destructor Destroy; override;
    procedure BuildStatisticForGanttTabs(ListGanttTabs : TList);
//    procedure ShowStatisticForGanttTabs(ListGanttTabs : TList);
    function  GetListStatisticOfGantTab : TList;
    function  getHieghestEndDateJob : TDateTime;
    public
    m_StackMark : integer;
    m_STatisticName    : string;
    private

    m_IsWeekly : boolean;
    m_TimeCreate  : string;

    m_ListOfMqmResources : TList;
    m_ListStatisticOfGantTab : TList;
  //  m_HieghestEndDateJob : TDateTime;
    private
    procedure BuildResourcePeriodStructure(IsWeekly : boolean);
    procedure MergrStatisticForEechTab(var ResOfGanttTab : TResOfGanttTab; ListOfMqmResources : TList);
    procedure BuildDelaysDataWeeklyMonthely(var StatisticRecordWeekly,StatisticRecordMonthely : Array of TStatisticRecordPeriod; var TotalPeriod : TStatisticRecordPeriod; Id : TSChedId);
    procedure BuildTooEearlyDaysDataWeeklyMonthely(var StatisticRecordWeekly,StatisticRecordMonthely : Array of TStatisticRecordPeriod; var TotalPeriod : TStatisticRecordPeriod; Id : TSChedId);
    procedure BuildCaseToResourceDataWeeklyMonthely(var StatisticRecordWeekly,StatisticRecordMonthely : Array of TStatisticRecordPeriod; var TotalPeriod : TStatisticRecordPeriod; Id : TSChedId);
    procedure BuildCaseJobToJobDataWeeklyMonthely(var StatisticRecordWeekly,StatisticRecordMonthely : Array of TStatisticRecordPeriod; var TotalPeriod : TStatisticRecordPeriod; Id : TSChedId);
    procedure BuildTotalSetupWeeklyMonthely(var StatisticRecordWeekly,StatisticRecordMonthely : Array of TStatisticRecordPeriod; var TotalPeriod : TStatisticRecordPeriod; Id : TSChedId);
    procedure BuildTotalTotalExecutionWeeklyMonthely(var StatisticRecordWeekly,StatisticRecordMonthely : Array of TStatisticRecordPeriod; var TotalPeriod : TStatisticRecordPeriod; Id : TSChedId);
    procedure BuildNumberOfjobsWarning(var StatisticRecordWeekly,StatisticRecordMonthely : Array of TStatisticRecordPeriod; var TotalPeriod : TStatisticRecordPeriod; Id : TSChedId);
    procedure BuildTotalHoursOfOccPerGanttOcc(var StatisticRecordWeekly,StatisticRecordMonthely : Array of TStatisticRecordPeriod; var TotalPeriod : TStatisticRecordPeriod; Id : TSChedId);
    procedure BuildTotalHoursAvailableOnGantt(ActArea : TMqmActArea; var StatisticRecordWeekly,StatisticRecordMonthely : Array of TStatisticRecordPeriod; var TotalPeriod : TStatisticRecordPeriod);
    procedure TotalUomProduced(var StatisticRecordWeekly,StatisticRecordMonthely : Array of TStatisticRecordPeriod; var TotalPeriod : TStatisticRecordPeriod; Id : TSChedId);
    function  SetHieghestEndDateJob : TDateTime;
    end;

  function GetStatisticOfGantTabByIndex(Index : integer; GanttName : string) : TResOfGanttTab;
  function GetStatisticStackMarkByIndex(Index : integer) : Integer;
  function GetScheduleStatisticArrayCount : Integer;
  function GetScheduleStatisticArraySize : Integer;
  function GetScheduleStatisticGanttTabs(Index : Integer) : TList;
  function GetScheduleStatisticTimeCreate(Index : integer) : string;
  function GetSetScheduleStatisticName(Index : integer) : string;
  procedure SetScheduleStatisticName(Index : integer; StatisticName : string);
  procedure FreeScheduleStatistics;
  procedure DeleteLastScheduleStatistics;


  function ShowStatisticForGanttTabs(ListGanttTabs : TList) : TList;

  // Human-readable caption for delay band k (1..DELAY_BAND_COUNT), derived from g_DelayBandUpper
  // so it stays in sync with the thresholds. e.g. '<1d', '1-4d', ... , '>=28d'.
  function DelayBandCaption(k : Integer) : string;

  // Snap d back to the machine-locale's first day of week (same setting the Gantt week grid uses),
  // so statistics weeks align with the Gantt. Defaults to Sunday.
  function LocaleWeekStart(d : TDateTime) : TDateTime;

implementation

uses

  UMObjCont, UMSchedCont, UMCompat, UMCommon, System.SysUtils, UMPlanTbs, Winapi.Windows;

//----------------------------------------------------------------------------//

var
  m_ScheduleStatisticsArray : array of TScheduleStatistics;
  m_HieghestEndDateJob : TDateTime;

  // Upper cut points (in days late) between the delay bands. Band k holds jobs with
  // g_DelayBandUpper[k-1] <= daysLate < g_DelayBandUpper[k]; the last band is open-ended (>= last cut).
  // Defaults: <1, 1-4, 4-7, 7-14, 14-28, >=28. Made a var (not const) so a future UI can edit them.
  g_DelayBandUpper : array[1..DELAY_BAND_COUNT - 1] of Double = (1, 4, 7, 14, 28);

//----------------------------------------------------------------------------//

// Returns the 1-based delay band (1..DELAY_BAND_COUNT) for a given lateness in days.
function DelayBandIndex(daysLate : Double) : Integer;
var
  k : Integer;
begin
  for k := 1 to DELAY_BAND_COUNT - 1 do
    if daysLate < g_DelayBandUpper[k] then
    begin
      Result := k;
      Exit;
    end;
  Result := DELAY_BAND_COUNT;
end;

//----------------------------------------------------------------------------//

function DelayBandCaption(k : Integer) : string;
begin
  // No 'd' suffix - the grid's first column header already says "Days".
  if k <= 1 then
    Result := '<' + IntToStr(Trunc(g_DelayBandUpper[1]))
  else if k >= DELAY_BAND_COUNT then
    Result := '>=' + IntToStr(Trunc(g_DelayBandUpper[DELAY_BAND_COUNT - 1]))
  else
    Result := IntToStr(Trunc(g_DelayBandUpper[k - 1])) + '-' + IntToStr(Trunc(g_DelayBandUpper[k]));
end;

//----------------------------------------------------------------------------//

function LocaleWeekStart(d : TDateTime) : TDateTime;
// Mirrors the Gantt's GetFirstDayOfWeekLocaleInformation (LOCALE_IFIRSTDAYOFWEEK:
// '0'=Monday, '5'=Saturday, anything else = Sunday) so the statistics weeks line up with
// the Gantt week grid for this machine. Snaps d backwards to that first weekday.
var
  buf : array[0..7] of Char;
  loc : string;
  firstDOW : Integer; // Delphi DayOfWeek index: 1=Sunday .. 7=Saturday
begin
  loc := '';
  if GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, LOCALE_IFIRSTDAYOFWEEK, buf, Length(buf)) > 0 then
    loc := buf;

  if loc = '0' then
    firstDOW := 2          // Monday
  else if loc = '5' then
    firstDOW := 7          // Saturday
  else
    firstDOW := 1;         // Sunday (Jerusalem default)

  Result := Trunc(d);
  while DayOfWeek(Result) <> firstDOW do
    Result := Result - 1;
end;

//----------------------------------------------------------------------------//

{ TStatisticManager }

function GetScheduleStatisticTimeCreate(Index : integer) : string;
begin
  result := TScheduleStatistics(m_ScheduleStatisticsArray[Index]).m_TimeCreate
end;

//----------------------------------------------------------------------------//

function GetSetScheduleStatisticName(Index : integer) : string;
begin
  result := TScheduleStatistics(m_ScheduleStatisticsArray[Index]).m_STatisticName
end;

//----------------------------------------------------------------------------//

procedure SetScheduleStatisticName(Index : integer; StatisticName : string);
begin
  TScheduleStatistics(m_ScheduleStatisticsArray[Index]).m_STatisticName := StatisticName;
end;

//----------------------------------------------------------------------------//

function GetScheduleStatisticGanttTabs(Index : Integer) : TList;
begin
  result := TScheduleStatistics(m_ScheduleStatisticsArray[Index]).m_ListStatisticOfGantTab
end;

//----------------------------------------------------------------------------//

function GetScheduleStatisticArrayCount : Integer;
begin
  result := High(m_ScheduleStatisticsArray)
end;

//----------------------------------------------------------------------------//

function GetScheduleStatisticArraySize : integer;
begin
  result := length(m_ScheduleStatisticsArray)
end;

//----------------------------------------------------------------------------//

function GetStatisticStackMarkByIndex(Index : integer) : Integer;
begin
  result := m_ScheduleStatisticsArray[Index].m_StackMark;
end;

//----------------------------------------------------------------------------//

function GetStatisticOfGantTabByIndex(Index : integer; GanttName : string) : TResOfGanttTab;
var
  I : Integer;
  ScheduleStatistics : TScheduleStatistics;
begin
  Result := nil;
  Index := Index - 1;

  if Index = 0 then
  begin
    if (length(m_ScheduleStatisticsArray) > 0) and Assigned(TScheduleStatistics(m_ScheduleStatisticsArray[0])) then
    begin
      ScheduleStatistics := TScheduleStatistics(m_ScheduleStatisticsArray[0]);

      for I := 0 to ScheduleStatistics.m_ListStatisticOfGantTab.Count - 1 do
      begin
        if TResOfGanttTab(ScheduleStatistics.m_ListStatisticOfGantTab[I]).m_ganttTabName = GanttName then
          Result := ScheduleStatistics.m_ListStatisticOfGantTab[I];
      end;
    end;
  end


  else if Index = 1 then
  begin
    if (length(m_ScheduleStatisticsArray) > 1) and Assigned(TScheduleStatistics(m_ScheduleStatisticsArray[1])) then
    begin
      ScheduleStatistics := TScheduleStatistics(m_ScheduleStatisticsArray[1]);

      for I := 0 to ScheduleStatistics.m_ListStatisticOfGantTab.Count - 1 do
      begin
        if TResOfGanttTab(ScheduleStatistics.m_ListStatisticOfGantTab[I]).m_ganttTabName = GanttName then
          Result := ScheduleStatistics.m_ListStatisticOfGantTab[I];
      end;
    end;
  end
  else if Index = 2 then
  begin
    if (length(m_ScheduleStatisticsArray) > 2) and Assigned(TScheduleStatistics(m_ScheduleStatisticsArray[2])) then
    begin
      ScheduleStatistics := TScheduleStatistics(m_ScheduleStatisticsArray[2]);

      for I := 0 to ScheduleStatistics.m_ListStatisticOfGantTab.Count - 1 do
      begin
        if TResOfGanttTab(ScheduleStatistics.m_ListStatisticOfGantTab[I]).m_ganttTabName = GanttName then
          Result := ScheduleStatistics.m_ListStatisticOfGantTab[I];
      end;
    end;
  end
  else if Index = 3 then
  begin
    if (length(m_ScheduleStatisticsArray) > 3) and Assigned(TScheduleStatistics(m_ScheduleStatisticsArray[3])) then
    begin
      ScheduleStatistics := TScheduleStatistics(m_ScheduleStatisticsArray[3]);

      for I := 0 to ScheduleStatistics.m_ListStatisticOfGantTab.Count - 1 do
      begin
        if TResOfGanttTab(ScheduleStatistics.m_ListStatisticOfGantTab[I]).m_ganttTabName = GanttName then
          Result := ScheduleStatistics.m_ListStatisticOfGantTab[I];
      end;
    end;
  end;

end;

//----------------------------------------------------------------------------//

function SortByResCode(Item1, Item2: Pointer): integer;
var
  MQMPR1 : TMqmVisibleRes;
  MQMPR2 : TMqmVisibleRes;
begin
  MQMPR1 := TMqmVisibleRes(Item1);
  MQMPR2 := TMqmVisibleRes(Item2);
  if TMqmRes(MQMPR1.p_Father).p_ResCode < TMqmRes(MQMPR2.p_Father).p_ResCode then
    Result := -1
  else if (TMqmRes(MQMPR1.p_Father).p_ResCode > TMqmRes(MQMPR2.p_Father).p_ResCode) then
    Result := 1
  else
    Result := 0
end;

//----------------------------------------------------------------------------//

function FindResourceByCode(ResCode : string; AllResList : TList) : TResOfMqm;
var
  i: integer;
  Multiplier, NumberOfEntries : integer;
begin
  Result := nil;

  NumberOfEntries := AllResList.Count;
  if NumberOfEntries = 0 then
  begin
    Exit;
  end;

  Multiplier := 1;
  while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    i := Multiplier - 1;

  while (Multiplier > 0) do
  begin

    if  (i < NumberOfEntries)
      and (TResOfMqm(AllResList[i]).m_ResCode = ResCode) then break;

    Multiplier := trunc(Multiplier / 2);

    if  (i < NumberOfEntries) and (TResOfMqm(AllResList[i]).m_ResCode < ResCode) then
      i := i + Multiplier
    else
      i := i - Multiplier;
  end;

  if Multiplier > 0 then
    Result := TResOfMqm(AllResList[i]);
end;

//----------------------------------------------------------------------------//

function ShowStatisticForGanttTabs(ListGanttTabs : TList) : TList;
var
  I, J : Integer;
  ResOfGanttTab : TResOfGanttTab;
  DateTimeCreate : TDateTime;
  ScheduleStatistics : TScheduleStatistics;
begin
  DateTimeCreate := Now;
  for I := Low(m_ScheduleStatisticsArray) to High(m_ScheduleStatisticsArray) do
  begin
    ScheduleStatistics := TScheduleStatistics(m_ScheduleStatisticsArray[I]);

    for J := 0 to ScheduleStatistics.m_ListStatisticOfGantTab.Count - 1 do
      TResOfGanttTab(ScheduleStatistics.m_ListStatisticOfGantTab[J]).Free;
    ScheduleStatistics.m_ListStatisticOfGantTab.Clear;

    for J := 0 to ListGanttTabs.Count - 1 do
    begin
      ResOfGanttTab := TResOfGanttTab.CreateResOfGanttTab(DateTimeCreate);
      ResOfGanttTab.ResList := TMqmPlanTabSheet(ListGanttTabs[J]).p_ganttPanel.p_VisResList;
      ResOfGanttTab.ResList.Sort(SortByResCode);
      ResOfGanttTab.m_ganttTabName := TMqmPlanTabSheet(ListGanttTabs[J]).Caption;
      ResOfGanttTab.m_ActiveTab := TMqmPlanTabSheet(ListGanttTabs[J]).p_ActiveTabForStatistics;
      ScheduleStatistics.MergrStatisticForEechTab(ResOfGanttTab, ScheduleStatistics.m_ListOfMqmResources);
      ScheduleStatistics.m_ListStatisticOfGantTab.Add(ResOfGanttTab);
      ResOfGanttTab.m_ScheduleStatistics := ScheduleStatistics
    end;
  end;
  result := ScheduleStatistics.m_ListStatisticOfGantTab
end;

//----------------------------------------------------------------------------//

procedure TotalUmQty(List : TList; Um : string; Qty : double);
var
  M : Integer;
  TotalUmProduced : PTTotalUmProduced;
begin
  for M := 0 to List.Count - 1 do
  begin
    if PTTotalUmProduced(List[M]).UM = Um then
    begin
      PTTotalUmProduced(List[M]).totalQty := PTTotalUmProduced(List[M]).totalQty + Qty;
      Exit
    end;
  end;
  new(TotalUmProduced);
  TotalUmProduced.UM := UM;
  TotalUmProduced.totalQty := Qty;
  List.Add(TotalUmProduced)
end;

//----------------------------------------------------------------------------//

{ TScheduleStatistics }

procedure TScheduleStatistics.BuildDelaysDataWeeklyMonthely(var StatisticRecordWeekly,StatisticRecordMonthely : Array of TStatisticRecordPeriod; var TotalPeriod : TStatisticRecordPeriod; Id : TSChedId);
var
  DatesInfo: TSQDatesInfo;
  I : Integer;
begin
  p_sc.GetDatesInfo(Id, DatesInfo);

  // totals

//  if not ((TotalPeriod.m_StartOfPeriod_Total > DatesInfo.EndDate) and
//     (TotalPeriod.m_EndOfPeriod_Total < DatesInfo.StartDate)) then

  if ((TotalPeriod.m_StartOfPeriod_Total < DatesInfo.EndDate) and
     (TotalPeriod.m_EndOfPeriod_Total >= DatesInfo.EndDate)) then

  begin
    Inc(TotalPeriod.m_NumberOfJobs_Total_ForDelayCalc);
    if DatesInfo.endDate > DatesInfo.HighEndDate then
    begin
      Inc(TotalPeriod.m_NumberOfJobsDelay);
      Inc(TotalPeriod.m_DelayBands[DelayBandIndex(DatesInfo.endDate - DatesInfo.HighEndDate)]);
      TotalPeriod.TotDaysDelay := TotalPeriod.TotDaysDelay + trunc(DatesInfo.endDate - DatesInfo.HighEndDate);

      if TotalPeriod.MinDaysDelay = 0 then
        TotalPeriod.MinDaysDelay := trunc(DatesInfo.endDate - DatesInfo.HighEndDate)
      else if (DatesInfo.endDate - DatesInfo.HighEndDate) < TotalPeriod.MinDaysDelay then
        TotalPeriod.MinDaysDelay := Trunc(DatesInfo.endDate - DatesInfo.HighEndDate);

      if TotalPeriod.MaxDaysDelay = 0 then
        TotalPeriod.MaxDaysDelay := trunc(DatesInfo.endDate - DatesInfo.HighEndDate)
      else if (DatesInfo.endDate - DatesInfo.HighEndDate) > TotalPeriod.MaxDaysDelay then
        TotalPeriod.MaxDaysDelay := Trunc(DatesInfo.endDate - DatesInfo.HighEndDate);

    end;

    // jobs finishing early (>= 1 day before expected end), bucketed by earliness band
    if (DatesInfo.HighEndDate > DatesInfo.endDate) and
       (DelayBandIndex(DatesInfo.HighEndDate - DatesInfo.endDate) >= 2) then
    begin
      Inc(TotalPeriod.m_NumberOfJobsEarly);
      Inc(TotalPeriod.m_EarlyBands[DelayBandIndex(DatesInfo.HighEndDate - DatesInfo.endDate)]);
    end;

  end;


  // weeks

  for I := Low(StatisticRecordWeekly) to High(StatisticRecordWeekly) do
  begin

    // Count each job in the week its END DATE falls in (not every week it overlaps),
    // so a job is counted exactly once - in the week it finishes.
    if (TStatisticRecordPeriod(StatisticRecordWeekly[I]).m_StartOfPeriod_Week <= DatesInfo.EndDate) and
       (TStatisticRecordPeriod(StatisticRecordWeekly[I]).m_EndOfPeriod_Week >= DatesInfo.EndDate) then
    begin
      Inc(TStatisticRecordPeriod(StatisticRecordWeekly[I]).m_NumberOfJobs_Total_ForDelayCalc);
      if DatesInfo.endDate > DatesInfo.HighEndDate then
      begin
        Inc(TStatisticRecordPeriod(StatisticRecordWeekly[I]).m_NumberOfJobsDelay);
        Inc(TStatisticRecordPeriod(StatisticRecordWeekly[I]).m_DelayBands[DelayBandIndex(DatesInfo.endDate - DatesInfo.HighEndDate)]);

        TStatisticRecordPeriod(StatisticRecordWeekly[I]).TotDaysDelay := TStatisticRecordPeriod(StatisticRecordWeekly[I]).TotDaysDelay +
                                                                         trunc(DatesInfo.endDate - DatesInfo.HighEndDate);

        if TStatisticRecordPeriod(StatisticRecordWeekly[I]).MinDaysDelay = 0 then
          TStatisticRecordPeriod(StatisticRecordWeekly[I]).MinDaysDelay := trunc(DatesInfo.endDate - DatesInfo.HighEndDate)
        else if (DatesInfo.endDate - DatesInfo.HighEndDate) < TStatisticRecordPeriod(StatisticRecordWeekly[I]).MinDaysDelay then
          TStatisticRecordPeriod(StatisticRecordWeekly[I]).MinDaysDelay := Trunc(DatesInfo.endDate - DatesInfo.HighEndDate);

        if TStatisticRecordPeriod(StatisticRecordWeekly[I]).MaxDaysDelay = 0 then
          TStatisticRecordPeriod(StatisticRecordWeekly[I]).MaxDaysDelay := trunc(DatesInfo.endDate - DatesInfo.HighEndDate)
        else if (DatesInfo.endDate - DatesInfo.HighEndDate) > TStatisticRecordPeriod(StatisticRecordWeekly[I]).MaxDaysDelay then
          TStatisticRecordPeriod(StatisticRecordWeekly[I]).MaxDaysDelay := Trunc(DatesInfo.endDate - DatesInfo.HighEndDate);

      end;

      // jobs finishing early (>= 1 day before expected end), bucketed by earliness band
      if (DatesInfo.HighEndDate > DatesInfo.endDate) and
         (DelayBandIndex(DatesInfo.HighEndDate - DatesInfo.endDate) >= 2) then
      begin
        Inc(TStatisticRecordPeriod(StatisticRecordWeekly[I]).m_NumberOfJobsEarly);
        Inc(TStatisticRecordPeriod(StatisticRecordWeekly[I]).m_EarlyBands[DelayBandIndex(DatesInfo.HighEndDate - DatesInfo.endDate)]);
      end;

    end;
  end;

  // month
  for I := Low(StatisticRecordMonthely) to High(StatisticRecordMonthely) do
  begin

    // Count each job in the month its END DATE falls in (not every month it overlaps),
    // so a job is counted exactly once - in the month it finishes.
    if (TStatisticRecordPeriod(StatisticRecordMonthely[I]).m_StartOfPeriod_Month <= DatesInfo.EndDate) and
       (TStatisticRecordPeriod(StatisticRecordMonthely[I]).m_EndOfPeriod_Month >= DatesInfo.EndDate) then
    begin
      Inc(TStatisticRecordPeriod(StatisticRecordMonthely[I]).m_NumberOfJobs_Total_ForDelayCalc);
      if DatesInfo.endDate > DatesInfo.HighEndDate then
      begin
        Inc(TStatisticRecordPeriod(StatisticRecordMonthely[I]).m_NumberOfJobsDelay);
        Inc(TStatisticRecordPeriod(StatisticRecordMonthely[I]).m_DelayBands[DelayBandIndex(DatesInfo.endDate - DatesInfo.HighEndDate)]);

        TStatisticRecordPeriod(StatisticRecordMonthely[I]).TotDaysDelay := TStatisticRecordPeriod(StatisticRecordMonthely[I]).TotDaysDelay +
                                                                           trunc(DatesInfo.endDate - DatesInfo.HighEndDate);

        if TStatisticRecordPeriod(StatisticRecordMonthely[I]).MinDaysDelay = 0 then
          TStatisticRecordPeriod(StatisticRecordMonthely[I]).MinDaysDelay := trunc(DatesInfo.endDate - DatesInfo.HighEndDate)
        else if (DatesInfo.endDate - DatesInfo.HighEndDate) < TStatisticRecordPeriod(StatisticRecordMonthely[I]).MinDaysDelay then
          TStatisticRecordPeriod(StatisticRecordMonthely[I]).MinDaysDelay := Trunc(DatesInfo.endDate - DatesInfo.HighEndDate);

        if TStatisticRecordPeriod(StatisticRecordMonthely[I]).MaxDaysDelay = 0 then
          TStatisticRecordPeriod(StatisticRecordMonthely[I]).MaxDaysDelay := trunc(DatesInfo.endDate - DatesInfo.HighEndDate)
        else if (DatesInfo.endDate - DatesInfo.HighEndDate) > TStatisticRecordPeriod(StatisticRecordMonthely[I]).MaxDaysDelay then
          TStatisticRecordPeriod(StatisticRecordMonthely[I]).MaxDaysDelay := Trunc(DatesInfo.endDate - DatesInfo.HighEndDate);

      end;

      // jobs finishing early (>= 1 day before expected end), bucketed by earliness band
      if (DatesInfo.HighEndDate > DatesInfo.endDate) and
         (DelayBandIndex(DatesInfo.HighEndDate - DatesInfo.endDate) >= 2) then
      begin
        Inc(TStatisticRecordPeriod(StatisticRecordMonthely[I]).m_NumberOfJobsEarly);
        Inc(TStatisticRecordPeriod(StatisticRecordMonthely[I]).m_EarlyBands[DelayBandIndex(DatesInfo.HighEndDate - DatesInfo.endDate)]);
      end;

    end;
  end;


end;

//----------------------------------------------------------------------------//

procedure TScheduleStatistics.BuildTooEearlyDaysDataWeeklyMonthely(var StatisticRecordWeekly,StatisticRecordMonthely : Array of TStatisticRecordPeriod; var TotalPeriod : TStatisticRecordPeriod; Id : TSChedId);
var
  DatesInfo: TSQDatesInfo;
  I : Integer;
begin
  p_sc.GetDatesInfo(Id, DatesInfo);

  // totals

//  if not ((TotalPeriod.m_StartOfPeriod_Total > DatesInfo.EndDate) and
//     (TotalPeriod.m_EndOfPeriod_Total < DatesInfo.StartDate)) then

  if ((TotalPeriod.m_StartOfPeriod_Total <= DatesInfo.startDate) and
     (TotalPeriod.m_EndOfPeriod_Total > DatesInfo.startDate)) then

  begin
    Inc(TotalPeriod.m_NumberOfJobs_Total_ForTooEarlyCalc);

    if DatesInfo.LowStrDate > DatesInfo.StartDate then
    begin
      Inc(TotalPeriod.m_NumberOfJobsToEarly);
      TotalPeriod.TotDaysTooEarly := TotalPeriod.TotDaysTooEarly + trunc(DatesInfo.LowStrDate - DatesInfo.StartDate);

      if TotalPeriod.MinDaysTooEarly = 0 then
        TotalPeriod.MinDaysTooEarly := trunc(DatesInfo.LowStrDate - DatesInfo.StartDate)
      else if (DatesInfo.LowStrDate - DatesInfo.StartDate) < TotalPeriod.MinDaysTooEarly then
        TotalPeriod.MinDaysTooEarly := Trunc(DatesInfo.LowStrDate - DatesInfo.StartDate);

      if TotalPeriod.MaxDaysTooEarly = 0 then
        TotalPeriod.MaxDaysTooEarly := trunc(DatesInfo.LowStrDate - DatesInfo.StartDate)
      else if (DatesInfo.LowStrDate - DatesInfo.StartDate) > TotalPeriod.MaxDaysTooEarly then
        TotalPeriod.MaxDaysTooEarly := Trunc(DatesInfo.LowStrDate - DatesInfo.StartDate);
    end;

  end;


  // weeks

  for I := Low(StatisticRecordWeekly) to High(StatisticRecordWeekly) do
  begin

//    if (TStatisticRecordPeriod(StatisticRecordWeekly[I]).m_StartOfPeriod_Week <= DatesInfo.EndDate) and
//       (TStatisticRecordPeriod(StatisticRecordWeekly[I]).m_EndOfPeriod_Week >= DatesInfo.EndDate) then

    if not ((TStatisticRecordPeriod(StatisticRecordWeekly[I]).m_StartOfPeriod_Week > DatesInfo.EndDate) or
       (TStatisticRecordPeriod(StatisticRecordWeekly[I]).m_EndOfPeriod_Week < DatesInfo.StartDate)) then
    begin
      Inc(TStatisticRecordPeriod(StatisticRecordWeekly[I]).m_NumberOfJobs_Total_ForTooEarlyCalc);

      if DatesInfo.LowStrDate > DatesInfo.StartDate then
      begin
        Inc(TStatisticRecordPeriod(StatisticRecordWeekly[I]).m_NumberOfJobsToEarly);
        TStatisticRecordPeriod(StatisticRecordWeekly[I]).TotDaysTooEarly := TStatisticRecordPeriod(StatisticRecordWeekly[I]).TotDaysTooEarly + trunc(DatesInfo.LowStrDate - DatesInfo.StartDate);

        if TStatisticRecordPeriod(StatisticRecordWeekly[I]).MinDaysTooEarly = 0 then
          TStatisticRecordPeriod(StatisticRecordWeekly[I]).MinDaysTooEarly := trunc(DatesInfo.LowStrDate - DatesInfo.StartDate)
        else if (DatesInfo.LowStrDate - DatesInfo.StartDate) < TStatisticRecordPeriod(StatisticRecordWeekly[I]).MinDaysTooEarly then
          TStatisticRecordPeriod(StatisticRecordWeekly[I]).MinDaysTooEarly := Trunc(DatesInfo.LowStrDate - DatesInfo.StartDate);

        if TStatisticRecordPeriod(StatisticRecordWeekly[I]).MaxDaysTooEarly = 0 then
          TStatisticRecordPeriod(StatisticRecordWeekly[I]).MaxDaysTooEarly := trunc(DatesInfo.LowStrDate - DatesInfo.StartDate)
        else if (DatesInfo.LowStrDate - DatesInfo.StartDate) > TStatisticRecordPeriod(StatisticRecordWeekly[I]).MaxDaysTooEarly then
          TStatisticRecordPeriod(StatisticRecordWeekly[I]).MaxDaysTooEarly := Trunc(DatesInfo.LowStrDate - DatesInfo.StartDate);
      end;

    end;
  end;

  // month
  for I := Low(StatisticRecordMonthely) to High(StatisticRecordMonthely) do
  begin

//    if (TStatisticRecordPeriod(StatisticRecordMonthely[I]).m_StartOfPeriod_Month <= DatesInfo.EndDate) and
//       (TStatisticRecordPeriod(StatisticRecordMonthely[I]).m_EndOfPeriod_Month >= DatesInfo.EndDate) then

    if not ((TStatisticRecordPeriod(StatisticRecordMonthely[I]).m_StartOfPeriod_Month > DatesInfo.EndDate) or
       (TStatisticRecordPeriod(StatisticRecordMonthely[I]).m_EndOfPeriod_Month < DatesInfo.StartDate)) then
    begin
      Inc(TStatisticRecordPeriod(StatisticRecordMonthely[I]).m_NumberOfJobs_Total_ForTooEarlyCalc);

      if DatesInfo.LowStrDate > DatesInfo.StartDate then
      begin
        Inc(TStatisticRecordPeriod(StatisticRecordMonthely[I]).m_NumberOfJobsToEarly);
        TStatisticRecordPeriod(StatisticRecordMonthely[I]).TotDaysTooEarly := TStatisticRecordPeriod(StatisticRecordMonthely[I]).TotDaysTooEarly +
                                                                              trunc(DatesInfo.LowStrDate - DatesInfo.StartDate);
        if TStatisticRecordPeriod(StatisticRecordMonthely[I]).MinDaysTooEarly = 0 then
          TStatisticRecordPeriod(StatisticRecordMonthely[I]).MinDaysTooEarly := trunc(DatesInfo.LowStrDate - DatesInfo.StartDate)
        else if (DatesInfo.LowStrDate - DatesInfo.StartDate) < TStatisticRecordPeriod(StatisticRecordMonthely[I]).MinDaysTooEarly then
          TStatisticRecordPeriod(StatisticRecordMonthely[I]).MinDaysTooEarly := Trunc(DatesInfo.LowStrDate - DatesInfo.StartDate);

        if TStatisticRecordPeriod(StatisticRecordMonthely[I]).MaxDaysTooEarly = 0 then
          TStatisticRecordPeriod(StatisticRecordMonthely[I]).MaxDaysTooEarly := trunc(DatesInfo.LowStrDate - DatesInfo.StartDate)
        else if (DatesInfo.LowStrDate - DatesInfo.StartDate) > TStatisticRecordPeriod(StatisticRecordMonthely[I]).MaxDaysTooEarly then
          TStatisticRecordPeriod(StatisticRecordMonthely[I]).MaxDaysTooEarly := Trunc(DatesInfo.LowStrDate - DatesInfo.StartDate);
      end;

    end;
  end;
end;



procedure TScheduleStatistics.BuildCaseToResourceDataWeeklyMonthely(var StatisticRecordWeekly,StatisticRecordMonthely : Array of TStatisticRecordPeriod; var TotalPeriod : TStatisticRecordPeriod; Id : TSChedId);
var
  DatesInfo: TSQDatesInfo;
  I, J : Integer;
  compRes, compPrev : TCompatVal;
begin
  p_sc.GetDatesInfo(Id, DatesInfo);
  p_sc.CheckCompatWithRes(id, compRes);

  // totals - count each job once, in the period its END DATE falls in (consistent with delay/early)
  if ((TotalPeriod.m_StartOfPeriod_Total < DatesInfo.EndDate) and
     (TotalPeriod.m_EndOfPeriod_Total >= DatesInfo.EndDate)) then
  begin
    inc(TotalPeriod.m_NumberOfJobs_Total_ForResCase);
    if TotalPeriod.MinCaseForResource = 0 then
      TotalPeriod.MinCaseForResource := compRes
    else if (compRes > 0) and (compRes < TotalPeriod.MinCaseForResource) then
      TotalPeriod.MinCaseForResource := compRes;

    if TotalPeriod.MaxCaseForResource = 0 then
      TotalPeriod.MaxCaseForResource := compRes
    else if (compRes > 0) and (compRes > TotalPeriod.MaxCaseForResource) then
      TotalPeriod.MaxCaseForResource := compRes;
    Inc(TStatisticRecordPeriod(TotalPeriod).PercentOfjobsCaseForEachResCase[compRes]);
  end;

  // weeks

  for I := Low(StatisticRecordWeekly) to High(StatisticRecordWeekly) do
  begin
    if ((TStatisticRecordPeriod(StatisticRecordWeekly[I]).m_StartOfPeriod_Week <= DatesInfo.EndDate) and
       (TStatisticRecordPeriod(StatisticRecordWeekly[I]).m_EndOfPeriod_Week >= DatesInfo.EndDate)) then
    begin
      inc(StatisticRecordWeekly[I].m_NumberOfJobs_Total_ForResCase);
      if StatisticRecordWeekly[I].MinCaseForResource = 0 then
        StatisticRecordWeekly[I].MinCaseForResource := compRes
      else if (compRes > 0) and (compRes < StatisticRecordWeekly[I].MinCaseForResource) then
        StatisticRecordWeekly[I].MinCaseForResource := compRes;

      if StatisticRecordWeekly[I].MaxCaseForResource = 0 then
        StatisticRecordWeekly[I].MaxCaseForResource := compRes
      else if (compRes > 0) and (compRes > StatisticRecordWeekly[I].MaxCaseForResource) then
        StatisticRecordWeekly[I].MaxCaseForResource := compRes;
      Inc(TStatisticRecordPeriod(StatisticRecordWeekly[I]).PercentOfjobsCaseForEachResCase[compRes]);
    end;
  end;

  // month
  for I := Low(StatisticRecordMonthely) to High(StatisticRecordMonthely) do
  begin
    if ((TStatisticRecordPeriod(StatisticRecordMonthely[I]).m_StartOfPeriod_Month <= DatesInfo.EndDate) and
       (TStatisticRecordPeriod(StatisticRecordMonthely[I]).m_EndOfPeriod_Month >= DatesInfo.EndDate)) then
    begin
      inc(StatisticRecordMonthely[I].m_NumberOfJobs_Total_ForResCase);
      if StatisticRecordMonthely[I].MinCaseForResource = 0 then
        StatisticRecordMonthely[I].MinCaseForResource := compRes
      else if (compRes > 0) and (compRes < StatisticRecordMonthely[I].MinCaseForResource) then
        StatisticRecordMonthely[I].MinCaseForResource := compRes;

      if StatisticRecordMonthely[I].MaxCaseForResource = 0 then
        StatisticRecordMonthely[I].MaxCaseForResource := compRes
      else if (compRes > 0) and (compRes > StatisticRecordMonthely[I].MaxCaseForResource) then
        StatisticRecordMonthely[I].MaxCaseForResource := compRes;
      Inc(TStatisticRecordPeriod(StatisticRecordMonthely[I]).PercentOfjobsCaseForEachResCase[compRes]);
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TScheduleStatistics.BuildCaseJobToJobDataWeeklyMonthely(var StatisticRecordWeekly,StatisticRecordMonthely : Array of TStatisticRecordPeriod; var TotalPeriod : TStatisticRecordPeriod; Id : TSChedId);
var
  DatesInfo: TSQDatesInfo;
  I, J : Integer;
  compPrev : TCompatVal;
  extPtr : TMqmActArea;
begin
  p_sc.GetDatesInfo(Id, DatesInfo);

  extPtr := p_sc.GetExtLinkPtr(id);
  if (extPtr <> nil) then
  begin
    compPrev := CSchedIDnull;
    p_sc.GetCompatIdWithPrevOcc(id, extPtr, compPrev);
    if (compPrev = CSchedIDnull) then exit;
  end;

  // totals - count each job once, in the period its END DATE falls in (consistent with delay/early)
  if ((TotalPeriod.m_StartOfPeriod_Total < DatesInfo.EndDate) and
     (TotalPeriod.m_EndOfPeriod_Total >= DatesInfo.EndDate)) then
  begin
    inc(TotalPeriod.m_NumberOfJobs_Total_ForJobToJobCase);
    if TotalPeriod.MinCaseJobToJob = 0 then
       TotalPeriod.MinCaseJobToJob := compPrev
    else if (compPrev > 0) and (compPrev < TotalPeriod.MinCaseJobToJob) then
      TotalPeriod.MinCaseJobToJob := compPrev;

    if TotalPeriod.MaxCaseJobToJob = 0 then
      TotalPeriod.MaxCaseJobToJob := compPrev
    else if (compPrev > 0) and (compPrev > TotalPeriod.MaxCaseJobToJob) then
      TotalPeriod.MaxCaseJobToJob := compPrev;
    Inc(TStatisticRecordPeriod(TotalPeriod).PercentOfjobsCaseForEachJobToJobCase[compPrev]);
  end;

  // weeks

  for I := Low(StatisticRecordWeekly) to High(StatisticRecordWeekly) do
  begin
    if ((TStatisticRecordPeriod(StatisticRecordWeekly[I]).m_StartOfPeriod_Week <= DatesInfo.EndDate) and
       (TStatisticRecordPeriod(StatisticRecordWeekly[I]).m_EndOfPeriod_Week >= DatesInfo.EndDate)) then
    begin
      inc(StatisticRecordWeekly[I].m_NumberOfJobs_Total_ForJobToJobCase);
      if StatisticRecordWeekly[I].MinCaseJobToJob = 0 then
        StatisticRecordWeekly[I].MinCaseJobToJob := compPrev
      else if (compPrev > 0) and (compPrev < StatisticRecordWeekly[I].MinCaseJobToJob) then
        StatisticRecordWeekly[I].MinCaseJobToJob := compPrev;

      if StatisticRecordWeekly[I].MaxCaseJobToJob = 0 then
        StatisticRecordWeekly[I].MaxCaseJobToJob := compPrev
      else if (compPrev > 0) and (compPrev > StatisticRecordWeekly[I].MaxCaseJobToJob) then
        StatisticRecordWeekly[I].MaxCaseJobToJob := compPrev;
      Inc(TStatisticRecordPeriod(StatisticRecordWeekly[I]).PercentOfjobsCaseForEachJobToJobCase[compPrev]);
    end;
  end;

  // month
  for I := Low(StatisticRecordMonthely) to High(StatisticRecordMonthely) do
  begin
    if ((TStatisticRecordPeriod(StatisticRecordMonthely[I]).m_StartOfPeriod_Month <= DatesInfo.EndDate) and
       (TStatisticRecordPeriod(StatisticRecordMonthely[I]).m_EndOfPeriod_Month >= DatesInfo.EndDate)) then
    begin
      inc(StatisticRecordMonthely[I].m_NumberOfJobs_Total_ForJobToJobCase);
      if StatisticRecordMonthely[I].MinCaseJobToJob = 0 then
        StatisticRecordMonthely[I].MinCaseJobToJob := compPrev
      else if (compPrev > 0) and (compPrev < StatisticRecordMonthely[I].MinCaseJobToJob) then
        StatisticRecordMonthely[I].MinCaseJobToJob := compPrev;

      if StatisticRecordMonthely[I].MaxCaseJobToJob = 0 then
        StatisticRecordMonthely[I].MaxCaseJobToJob := compPrev
      else if (compPrev > 0) and (compPrev > StatisticRecordMonthely[I].MaxCaseJobToJob) then
        StatisticRecordMonthely[I].MaxCaseJobToJob := compPrev;
      Inc(TStatisticRecordPeriod(StatisticRecordMonthely[I]).PercentOfjobsCaseForEachJobToJobCase[compPrev]);
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TScheduleStatistics.BuildTotalSetupWeeklyMonthely(var StatisticRecordWeekly,StatisticRecordMonthely : Array of TStatisticRecordPeriod; var TotalPeriod : TStatisticRecordPeriod; Id : TSChedId);
var
  I : Integer;
  planInfo: TSQplanInfo;
  extPtr : TMqmActArea;
  Cal: TPGCALObj;
  //-----------------------
  function BuildTotalTotalSetup(StartPeriod, EndPeriod : TDateTime) : double;
  var
    EndSetup, StartTimeToCalculate, EndTimeToCalculate : TDateTime;
  begin
    Result := 0;
    if planInfo.supMinReal = 0 then exit;
    if planInfo.EndDate <= StartPeriod then exit;
    if planInfo.StartDate > EndPeriod then exit;
    cal.OfsByWH((planInfo.supMinReal)/60, true, planInfo.StartDate , EndSetup, extPtr.m_CrossDownTmList);
    if EndSetup <= StartPeriod then exit;
    if planInfo.StartDate >= StartPeriod then
      StartTimeToCalculate := planInfo.StartDate
    else
      StartTimeToCalculate := StartPeriod;
    if EndSetup <= EndPeriod then
      EndTimeToCalculate := EndSetup
    else
      EndTimeToCalculate := EndPeriod;
    Result := cal.DiffWH(StartTimeToCalculate, EndTimeToCalculate , extPtr.m_CrossDownTmList);
  end;

begin
  p_sc.GetPlanInfo(id, planInfo);

  extPtr := TMqmActArea(p_sc.GetExtLinkPtr(id));
  Cal := TMqmActArea(extPtr).GetCalendar;

  TotalPeriod.TotalSetupHours := TotalPeriod.TotalSetupHours + BuildTotalTotalSetup(TotalPeriod.m_StartOfPeriod_Total, TotalPeriod.m_EndOfPeriod_Total + 999);

  for I := Low(StatisticRecordWeekly) to High(StatisticRecordWeekly) do
  begin
    TStatisticRecordPeriod(StatisticRecordWeekly[I]).TotalSetupHours :=
      TStatisticRecordPeriod(StatisticRecordWeekly[I]).TotalSetupHours +
        BuildTotalTotalSetup(TStatisticRecordPeriod(StatisticRecordWeekly[I]).m_StartOfPeriod_Week, TStatisticRecordPeriod(StatisticRecordWeekly[I]).m_EndOfPeriod_Week);
  end;

  for I := Low(StatisticRecordMonthely) to High(StatisticRecordMonthely) do
  begin
    TStatisticRecordPeriod(StatisticRecordMonthely[I]).TotalSetupHours :=
      TStatisticRecordPeriod(StatisticRecordMonthely[I]).TotalSetupHours +
        BuildTotalTotalSetup(TStatisticRecordPeriod(StatisticRecordMonthely[I]).m_StartOfPeriod_Month, TStatisticRecordPeriod(StatisticRecordMonthely[I]).m_EndOfPeriod_Month);
  end;

end;

//----------------------------------------------------------------------------//

procedure TScheduleStatistics.BuildTotalTotalExecutionWeeklyMonthely(var StatisticRecordWeekly,StatisticRecordMonthely : Array of TStatisticRecordPeriod; var TotalPeriod : TStatisticRecordPeriod; Id : TSChedId);
var
  I : Integer;
  planInfo: TSQplanInfo;
  extPtr : TMqmActArea;
  Cal: TPGCALObj;
  //-----------------------
  function BuildTotalTotalExecution(StartPeriod, EndPeriod : TDateTime) : double;
  var
    StartExecution, StartTimeToCalculate, EndTimeToCalculate : TDateTime;
  begin
    Result := 0;
    if planInfo.exeMin = 0 then exit;
    if planInfo.EndDate <= StartPeriod then exit;
    if planInfo.StartDate > EndPeriod then exit;
    cal.OfsByWH(-(planInfo.exeMin)/60, false, planInfo.EndDate , StartExecution, extPtr.m_CrossDownTmList);
    if StartExecution > EndPeriod then exit;
    if StartExecution >= StartPeriod then
      StartTimeToCalculate := StartExecution
    else
      StartTimeToCalculate := StartPeriod;
    if planInfo.EndDate <= EndPeriod then
      EndTimeToCalculate := planInfo.EndDate
    else
      EndTimeToCalculate := EndPeriod;
    Result := cal.DiffWH(StartTimeToCalculate, EndTimeToCalculate , extPtr.m_CrossDownTmList);
  end;
  //-----------------------
begin

  p_sc.GetPlanInfo(id, planInfo);
  extPtr := TMqmActArea(p_sc.GetExtLinkPtr(id));
  Cal := TMqmActArea(extPtr).GetCalendar;

  TotalPeriod.TotalHoursExecution := TotalPeriod.TotalHoursExecution + BuildTotalTotalExecution(TotalPeriod.m_StartOfPeriod_Total, TotalPeriod.m_EndOfPeriod_Total + 999);

  for I := Low(StatisticRecordWeekly) to High(StatisticRecordWeekly) do
  begin
    TStatisticRecordPeriod(StatisticRecordWeekly[I]).TotalHoursExecution :=
      TStatisticRecordPeriod(StatisticRecordWeekly[I]).TotalHoursExecution +
        BuildTotalTotalExecution(TStatisticRecordPeriod(StatisticRecordWeekly[I]).m_StartOfPeriod_Week, TStatisticRecordPeriod(StatisticRecordWeekly[I]).m_EndOfPeriod_Week);
  end;

  for I := Low(StatisticRecordMonthely) to High(StatisticRecordMonthely) do
  begin
    TStatisticRecordPeriod(StatisticRecordMonthely[I]).TotalHoursExecution :=
      TStatisticRecordPeriod(StatisticRecordMonthely[I]).TotalHoursExecution +
        BuildTotalTotalExecution(TStatisticRecordPeriod(StatisticRecordMonthely[I]).m_StartOfPeriod_Month, TStatisticRecordPeriod(StatisticRecordMonthely[I]).m_EndOfPeriod_Month);
  end;

end;

//----------------------------------------------------------------------------//

procedure TScheduleStatistics.BuildNumberOfjobsWarning(var StatisticRecordWeekly,StatisticRecordMonthely : Array of TStatisticRecordPeriod; var TotalPeriod : TStatisticRecordPeriod; Id : TSChedId);
var
  DatesInfo: TSQDatesInfo;
  I, J : Integer;
  errSet: SetOfErrors;
begin
  errSet := [];
  p_sc.CheckWarningStatistic(id, errSet);

  // totals
  if not ((TotalPeriod.m_StartOfPeriod_Total > DatesInfo.EndDate) or
     (TotalPeriod.m_EndOfPeriod_Total < DatesInfo.StartDate)) then
  begin
    if (CSE_Materials in errSet) then
      Inc(TStatisticRecordPeriod(TotalPeriod).NumberOfjobsWithoutMaterial);
    if (CSE_AddRes in errSet) then
      Inc(TStatisticRecordPeriod(TotalPeriod).NumberOfjobsWithoutAnyAddRes);
    if (CSE_AddRes_ManPower in errSet) then
      Inc(TStatisticRecordPeriod(TotalPeriod).NumberOfjobsWithoutManPawer);
  end;

  // weeks

  for I := Low(StatisticRecordWeekly) to High(StatisticRecordWeekly) do
  begin
    if not ((TStatisticRecordPeriod(StatisticRecordWeekly[I]).m_StartOfPeriod_Week > DatesInfo.EndDate) or
       (TStatisticRecordPeriod(StatisticRecordWeekly[I]).m_EndOfPeriod_Week < DatesInfo.StartDate)) then
    begin
      if (CSE_Materials in errSet) then
        Inc(TStatisticRecordPeriod(StatisticRecordWeekly[I]).NumberOfjobsWithoutMaterial);
      if (CSE_AddRes in errSet) then
        Inc(TStatisticRecordPeriod(StatisticRecordWeekly[I]).NumberOfjobsWithoutAnyAddRes);
      if (CSE_AddRes_ManPower in errSet) then
        Inc(TStatisticRecordPeriod(StatisticRecordWeekly[I]).NumberOfjobsWithoutManPawer);
    end;
  end;

  // month
  for I := Low(StatisticRecordMonthely) to High(StatisticRecordMonthely) do
  begin
    if not ((TStatisticRecordPeriod(StatisticRecordMonthely[I]).m_StartOfPeriod_Month > DatesInfo.EndDate) or
       (TStatisticRecordPeriod(StatisticRecordMonthely[I]).m_EndOfPeriod_Month < DatesInfo.StartDate)) then
    begin
      if (CSE_Materials in errSet) then
        Inc(TStatisticRecordPeriod(StatisticRecordMonthely[I]).NumberOfjobsWithoutMaterial);
      if (CSE_AddRes in errSet) then
        Inc(TStatisticRecordPeriod(StatisticRecordMonthely[I]).NumberOfjobsWithoutAnyAddRes);
      if (CSE_AddRes_ManPower in errSet) then
        Inc(TStatisticRecordPeriod(StatisticRecordMonthely[I]).NumberOfjobsWithoutManPawer);
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TScheduleStatistics.BuildTotalHoursOfOccPerGanttOcc(var StatisticRecordWeekly,StatisticRecordMonthely : Array of TStatisticRecordPeriod; var TotalPeriod : TStatisticRecordPeriod; Id : TSChedId);
var
  I, J : Integer;
  planInfo: TSQplanInfo;
  extPtr : TMqmActArea;
  Cal: TPGCALObj;
  Tempend : TDateTime;
begin

  // totals
  p_sc.GetPlanInfo(id, planInfo);
  extPtr := TMqmActArea(p_sc.GetExtLinkPtr(id));
  Cal := TMqmActArea(extPtr).GetCalendar;

  if not ((TotalPeriod.m_StartOfPeriod_Total > planInfo.EndDate) or
     (TotalPeriod.m_EndOfPeriod_Total < planInfo.StartDate)) then
  begin
    TotalPeriod.TotalHoursOfOccPerGanttOcc := TotalPeriod.TotalHoursOfOccPerGanttOcc +
    cal.DiffWH(planInfo.StartDate, planInfo.EndDate , extPtr.m_CrossDownTmList);
  end;

  // weeks

  for I := Low(StatisticRecordWeekly) to High(StatisticRecordWeekly) do
  begin

    if not ((TStatisticRecordPeriod(StatisticRecordWeekly[I]).m_StartOfPeriod_Week > planInfo.EndDate) or
       (TStatisticRecordPeriod(StatisticRecordWeekly[I]).m_EndOfPeriod_Week < planInfo.StartDate)) then
    begin

      if ((planInfo.StartDate < TStatisticRecordPeriod(StatisticRecordWeekly[I]).m_StartOfPeriod_Week) and
         (planInfo.EndDate > TStatisticRecordPeriod(StatisticRecordWeekly[I]).m_EndOfPeriod_Week)) then
      begin
        TStatisticRecordPeriod(StatisticRecordWeekly[I]).TotalHoursOfOccPerGanttOcc := TStatisticRecordPeriod(StatisticRecordWeekly[I]).TotalHoursOfOccPerGanttOcc +
           cal.DiffWH(TStatisticRecordPeriod(StatisticRecordWeekly[I]).m_StartOfPeriod_Week, TStatisticRecordPeriod(StatisticRecordWeekly[I]).m_EndOfPeriod_Week , extPtr.m_CrossDownTmList);
      end
      else if ((planInfo.StartDate < TStatisticRecordPeriod(StatisticRecordWeekly[I]).m_StartOfPeriod_Week) and
         (planInfo.EndDate > TStatisticRecordPeriod(StatisticRecordWeekly[I]).m_StartOfPeriod_Week)) then
      begin
        cal.OfsByWH((planInfo.supMinReal + planInfo.exeMin)/60, true, planInfo.startDate , TempEnd, extPtr.m_CrossDownTmList);
        if TempEnd > TStatisticRecordPeriod(StatisticRecordWeekly[I]).m_StartOfPeriod_Week then
        begin
          TStatisticRecordPeriod(StatisticRecordWeekly[I]).TotalHoursOfOccPerGanttOcc := TStatisticRecordPeriod(StatisticRecordWeekly[I]).TotalHoursOfOccPerGanttOcc +
                           cal.DiffWH(TStatisticRecordPeriod(StatisticRecordWeekly[I]).m_StartOfPeriod_Week , TempEnd, extPtr.m_CrossDownTmList);
        end;
      end
      else if  ((planInfo.EndDate > TStatisticRecordPeriod(StatisticRecordWeekly[I]).m_EndOfPeriod_Week ) and
         (planInfo.StartDate < TStatisticRecordPeriod(StatisticRecordWeekly[I]).m_EndOfPeriod_Week)) then
      begin
        cal.OfsByWH(planInfo.supMinReal + planInfo.exeMin/60, true, planInfo.startDate , TempEnd, extPtr.m_CrossDownTmList);
        if TempEnd > TStatisticRecordPeriod(StatisticRecordWeekly[I]).m_EndOfPeriod_Week then
        begin
          TStatisticRecordPeriod(StatisticRecordWeekly[I]).TotalHoursOfOccPerGanttOcc := TStatisticRecordPeriod(StatisticRecordWeekly[I]).TotalHoursOfOccPerGanttOcc +
                           cal.DiffWH(planInfo.startDate, TStatisticRecordPeriod(StatisticRecordWeekly[I]).m_EndOfPeriod_Week , extPtr.m_CrossDownTmList);
        end;
      end
      else
        TStatisticRecordPeriod(StatisticRecordWeekly[I]).TotalHoursOfOccPerGanttOcc := TStatisticRecordPeriod(StatisticRecordWeekly[I]).TotalHoursOfOccPerGanttOcc +
          (planInfo.supMinReal + planInfo.exeMin)/60;
    end;

  end;

  // month
  for I := Low(StatisticRecordMonthely) to High(StatisticRecordMonthely) do
  begin
    if not ((TStatisticRecordPeriod(StatisticRecordMonthely[I]).m_StartOfPeriod_Month > planInfo.EndDate) or
       (TStatisticRecordPeriod(StatisticRecordMonthely[I]).m_EndOfPeriod_Month < planInfo.StartDate)) then
    begin

      if ((planInfo.StartDate < TStatisticRecordPeriod(StatisticRecordMonthely[I]).m_StartOfPeriod_Month) and
         (planInfo.EndDate > TStatisticRecordPeriod(StatisticRecordMonthely[I]).m_EndOfPeriod_Month)) then
      begin
        TStatisticRecordPeriod(StatisticRecordMonthely[I]).TotalHoursOfOccPerGanttOcc := TStatisticRecordPeriod(StatisticRecordMonthely[I]).TotalHoursOfOccPerGanttOcc +
           cal.DiffWH(TStatisticRecordPeriod(StatisticRecordMonthely[I]).m_StartOfPeriod_Month, TStatisticRecordPeriod(StatisticRecordMonthely[I]).m_EndOfPeriod_Month , extPtr.m_CrossDownTmList);
      end
      else if ((planInfo.StartDate < TStatisticRecordPeriod(StatisticRecordMonthely[I]).m_StartOfPeriod_Month) and
         (planInfo.EndDate > TStatisticRecordPeriod(StatisticRecordMonthely[I]).m_StartOfPeriod_Month)) then
      begin
        cal.OfsByWH((planInfo.supMinReal + planInfo.exeMin)/60, true, planInfo.startDate , TempEnd, extPtr.m_CrossDownTmList);
        if TempEnd > TStatisticRecordPeriod(StatisticRecordMonthely[I]).m_StartOfPeriod_Month then
        begin
          TStatisticRecordPeriod(StatisticRecordMonthely[I]).TotalHoursOfOccPerGanttOcc := TStatisticRecordPeriod(StatisticRecordMonthely[I]).TotalHoursOfOccPerGanttOcc +
                           cal.DiffWH(TStatisticRecordPeriod(StatisticRecordMonthely[I]).m_StartOfPeriod_Month , TempEnd, extPtr.m_CrossDownTmList);
        end;
      end
      else if  ((planInfo.EndDate > TStatisticRecordPeriod(StatisticRecordMonthely[I]).m_EndOfPeriod_Month ) and
         (planInfo.StartDate < TStatisticRecordPeriod(StatisticRecordMonthely[I]).m_EndOfPeriod_Month)) then
      begin
        cal.OfsByWH(planInfo.supMinReal + planInfo.exeMin/60, true, planInfo.startDate , TempEnd, extPtr.m_CrossDownTmList);
        if TempEnd > TStatisticRecordPeriod(StatisticRecordMonthely[I]).m_EndOfPeriod_Month then
        begin
          TStatisticRecordPeriod(StatisticRecordMonthely[I]).TotalHoursOfOccPerGanttOcc := TStatisticRecordPeriod(StatisticRecordMonthely[I]).TotalHoursOfOccPerGanttOcc +
                           cal.DiffWH(planInfo.startDate, TStatisticRecordPeriod(StatisticRecordMonthely[I]).m_EndOfPeriod_Month , extPtr.m_CrossDownTmList);
        end;
      end
      else
        TStatisticRecordPeriod(StatisticRecordMonthely[I]).TotalHoursOfOccPerGanttOcc := TStatisticRecordPeriod(StatisticRecordMonthely[I]).TotalHoursOfOccPerGanttOcc +
          (planInfo.supMinReal + planInfo.exeMin)/60;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TScheduleStatistics.BuildTotalHoursAvailableOnGantt(ActArea : TMqmActArea; var StatisticRecordWeekly,StatisticRecordMonthely : Array of TStatisticRecordPeriod; var TotalPeriod : TStatisticRecordPeriod);
var
  I, J : Integer;
  planInfo: TSQplanInfo;
//  extPtr : TMqmActArea;
  Cal: TPGCALObj;
//  Tempend : TDateTime;
begin

  // totals

  Cal := TMqmActArea(ActArea).GetCalendar;
  TotalPeriod.TotalHoursAvailableOnGantt := TotalPeriod.TotalHoursAvailableOnGantt +
  cal.DiffWH(TotalPeriod.m_StartOfPeriod_Total , TotalPeriod.m_EndOfPeriod_Total , ActArea.m_CrossDownTmList);

  // weeks

  for I := Low(StatisticRecordWeekly) to High(StatisticRecordWeekly) do
  begin
    TStatisticRecordPeriod(StatisticRecordWeekly[I]).TotalHoursAvailableOnGantt := TStatisticRecordPeriod(StatisticRecordWeekly[I]).TotalHoursAvailableOnGantt +
                           cal.DiffWH(TStatisticRecordPeriod(StatisticRecordWeekly[I]).m_StartOfPeriod_Week , TStatisticRecordPeriod(StatisticRecordWeekly[I]).m_EndOfPeriod_Week, ActArea.m_CrossDownTmList);
  end;

  // month
  for I := Low(StatisticRecordMonthely) to High(StatisticRecordMonthely) do
  begin
    TStatisticRecordPeriod(StatisticRecordMonthely[I]).TotalHoursAvailableOnGantt := TStatisticRecordPeriod(StatisticRecordMonthely[I]).TotalHoursAvailableOnGantt +
                           cal.DiffWH(TStatisticRecordPeriod(StatisticRecordMonthely[I]).m_StartOfPeriod_Month , TStatisticRecordPeriod(StatisticRecordMonthely[I]).m_EndOfPeriod_Month, ActArea.m_CrossDownTmList);
  end;
end;

//----------------------------------------------------------------------------//

procedure TScheduleStatistics.TotalUomProduced(var StatisticRecordWeekly,StatisticRecordMonthely : Array of TStatisticRecordPeriod; var TotalPeriod : TStatisticRecordPeriod; Id : TSChedId);
var
  planInfo: TSQplanInfo;
  I : Integer;
begin

  // totals

  p_sc.GetPlanInfo(id, planInfo);

  if not ((TotalPeriod.m_StartOfPeriod_Total > planInfo.EndDate) and
     (TotalPeriod.m_EndOfPeriod_Total < planInfo.StartDate)) then
  begin
    TotalUmQty(TotalPeriod.TotalUomProduced, planInfo.ProdUM, planInfo.quant);
  end;

  // weeks

  for I := Low(StatisticRecordWeekly) to High(StatisticRecordWeekly) do
  begin
    if not ((TStatisticRecordPeriod(StatisticRecordWeekly[I]).m_StartOfPeriod_Week > planInfo.EndDate) or
       (TStatisticRecordPeriod(StatisticRecordWeekly[I]).m_EndOfPeriod_Week < planInfo.StartDate)) then
    begin
      TotalUmQty(TStatisticRecordPeriod(StatisticRecordWeekly[I]).TotalUomProduced, planInfo.ProdUM, planInfo.quant)
    end;
  end;

  // month
  for I := Low(StatisticRecordMonthely) to High(StatisticRecordMonthely) do
  begin
    if not ((TStatisticRecordPeriod(StatisticRecordMonthely[I]).m_StartOfPeriod_Month > planInfo.EndDate) or
       (TStatisticRecordPeriod(StatisticRecordMonthely[I]).m_EndOfPeriod_Month < planInfo.StartDate)) then
    begin
      TotalUmQty(TStatisticRecordPeriod(StatisticRecordMonthely[I]).TotalUomProduced, planInfo.ProdUM, planInfo.quant)
    end;
  end;
end;

//----------------------------------------------------------------------------//

function TScheduleStatistics.SetHieghestEndDateJob : TDateTime;
var
  iRes, Iweek, iVisRes, iApa, I : Integer;
  Id : TSchedId;
  res : TMqmRes;
  VisRes : TMqmVisibleRes;
  ActArea : TMqmActArea;
  DatesInfo: TSQDatesInfo;
begin
 // m_HieghestEndDateJob := date + 30;

  if length(m_ScheduleStatisticsArray) = 0 then
     m_HieghestEndDateJob := 0;

  for iRes := 0 to p_pl.p_ResList.Count -1 do
  begin
    res := TMqmRes(p_pl.p_ResList[iRes]);
    VisRes := TMqmVisibleRes(res.p_VisRes[0]);
    for iApa := 0 to VisRes.p_ActAreasCount -1 do
    begin
      ActArea := TMqmActArea(VisRes.p_ActArea[iApa]);
      id := ActArea.GetSchedObj(0);
      if Id = CSchedIDnull then continue;
      Id := ActArea.GetSchedObj(ActArea.p_ObjCount - 1);
      if Id = CSchedIDnull then continue;
      p_sc.GetDatesInfo(Id, DatesInfo);
      if DatesInfo.endDate > m_HieghestEndDateJob then
        m_HieghestEndDateJob := DatesInfo.endDate;
    end;
  end;
end;

//----------------------------------------------------------------------------//

function TScheduleStatistics.GetHieghestEndDateJob : TDateTime;
begin
  Result := m_HieghestEndDateJob
end;

//----------------------------------------------------------------------------//

constructor TScheduleStatistics.CreateScheduleStatistics(ListGanttTabs : TList; IsWeekly : boolean; StackMark : integer);
var
  I : Integer;
begin
  Inherited create;
  m_StackMark := StackMark;
  m_IsWeekly := IsWeekly;
  m_ListOfMqmResources := TList.Create;
  m_ListStatisticOfGantTab := TList.Create;
  SetHieghestEndDateJob;
  BuildResourcePeriodStructure(IsWeekly);

  if length(m_ScheduleStatisticsArray) = 0 then
  begin
    SetLength(m_ScheduleStatisticsArray, length(m_ScheduleStatisticsArray) + 1);
    m_ScheduleStatisticsArray[0] := self;
  end
  else if length(m_ScheduleStatisticsArray) = 1 then
  begin
    SetLength(m_ScheduleStatisticsArray, length(m_ScheduleStatisticsArray) + 1);
    TScheduleStatistics(m_ScheduleStatisticsArray[1]) := TScheduleStatistics(m_ScheduleStatisticsArray[0]);
    TScheduleStatistics(m_ScheduleStatisticsArray[0]) := self;
  end
  else if length(m_ScheduleStatisticsArray) = 2 then
  begin
    SetLength(m_ScheduleStatisticsArray, length(m_ScheduleStatisticsArray) + 1);
    TScheduleStatistics(m_ScheduleStatisticsArray[2]) := TScheduleStatistics(m_ScheduleStatisticsArray[1]);
    TScheduleStatistics(m_ScheduleStatisticsArray[1]) := TScheduleStatistics(m_ScheduleStatisticsArray[0]);
    TScheduleStatistics(m_ScheduleStatisticsArray[0]) := self;
  end
  else if length(m_ScheduleStatisticsArray) = 3 then
  begin
    SetLength(m_ScheduleStatisticsArray, length(m_ScheduleStatisticsArray) + 1);
    TScheduleStatistics(m_ScheduleStatisticsArray[3]) := TScheduleStatistics(m_ScheduleStatisticsArray[2]);
    TScheduleStatistics(m_ScheduleStatisticsArray[2]) := TScheduleStatistics(m_ScheduleStatisticsArray[1]);
    TScheduleStatistics(m_ScheduleStatisticsArray[1]) := TScheduleStatistics(m_ScheduleStatisticsArray[0]);
    TScheduleStatistics(m_ScheduleStatisticsArray[0]) := self;
  end

  else if length(m_ScheduleStatisticsArray) = 4 then
  begin
    TScheduleStatistics(m_ScheduleStatisticsArray[3]).free;
    TScheduleStatistics(m_ScheduleStatisticsArray[3]) := TScheduleStatistics(m_ScheduleStatisticsArray[2]);
    TScheduleStatistics(m_ScheduleStatisticsArray[2]) := TScheduleStatistics(m_ScheduleStatisticsArray[1]);
    TScheduleStatistics(m_ScheduleStatisticsArray[1]) := TScheduleStatistics(m_ScheduleStatisticsArray[0]);
    TScheduleStatistics(m_ScheduleStatisticsArray[0]) := self;
  end;

  BuildStatisticForGanttTabs(ListGanttTabs);

end;

//----------------------------------------------------------------------------//

{constructor TScheduleStatistics.ShowScheduleStatistics(ListGanttTabs : TList; IsWeekly : boolean; StackMark : integer);
var
  I : Integer;
begin
  Inherited create;
  m_StackMark := StackMark;
  m_IsWeekly := IsWeekly;
  m_ListOfMqmResources := TList.Create;
  m_ListStatisticOfGantTab      := TList.Create;
  m_HieghestEndDateJob := Now;
  m_HieghestEndDateJob := SetHieghestEndDateJob;
//  BuildResourcePeriodStructure(IsWeekly);

  ShowStatisticForGanttTabs(ListGanttTabs);
end; }

//----------------------------------------------------------------------------//

procedure TScheduleStatistics.BuildStatisticForGanttTabs(ListGanttTabs : TList);
var
  I : Integer;
  ResOfGanttTab : TResOfGanttTab;
  DateTimeCreate : TDateTime;
begin
  DateTimeCreate := Now;
  m_TimeCreate := TimeToStr(Frac(DateTimeCreate));
  for I := 0 to ListGanttTabs.Count - 1 do
  begin
    ResOfGanttTab := TResOfGanttTab.CreateResOfGanttTab(DateTimeCreate);
    ResOfGanttTab.ResList := TMqmPlanTabSheet(ListGanttTabs[I]).p_ganttPanel.p_VisResList;
    ResOfGanttTab.ResList.Sort(SortByResCode);
    ResOfGanttTab.m_ganttTabName := TMqmPlanTabSheet(ListGanttTabs[I]).Caption;
    ResOfGanttTab.m_ActiveTab := TMqmPlanTabSheet(ListGanttTabs[I]).p_ActiveTabForStatistics;
    MergrStatisticForEechTab(ResOfGanttTab, m_ListOfMqmResources);
    m_ListStatisticOfGantTab.Add(ResOfGanttTab);
    ResOfGanttTab.m_ScheduleStatistics := self
  end;
end;

//----------------------------------------------------------------------------//

{procedure TScheduleStatistics.ShowStatisticForGanttTabs(ListGanttTabs : TList);
var
  I : Integer;
  ResOfGanttTab : TResOfGanttTab;
  DateTimeCreate : TDateTime;
begin
  DateTimeCreate := Now;
  m_TimeCreate := TimeToStr(Frac(DateTimeCreate));
  for I := 0 to ListGanttTabs.Count - 1 do
  begin
    ResOfGanttTab := TResOfGanttTab.CreateResOfGanttTab(DateTimeCreate);
    ResOfGanttTab.ResList := TMqmPlanTabSheet(ListGanttTabs[I]).p_ganttPanel.p_VisResList;
    ResOfGanttTab.ResList.Sort(SortByResCode);
    ResOfGanttTab.m_ganttTabName := TMqmPlanTabSheet(ListGanttTabs[I]).Caption;
    ResOfGanttTab.m_ActiveTab := TMqmPlanTabSheet(ListGanttTabs[I]).p_ActiveTabForStatistics;
 //   MergrStatisticForEechTab(ResOfGanttTab);
    m_ListStatisticOfGantTab.Add(ResOfGanttTab);
  end;
end; }

//----------------------------------------------------------------------------//

function TScheduleStatistics.GetListStatisticOfGantTab : TList;
begin
  Result := m_ListStatisticOfGantTab
end;

//----------------------------------------------------------------------------//

destructor TScheduleStatistics.Destroy;
var
  I : Integer;
begin
  for I := 0 to m_ListOfMqmResources.Count - 1 do
    TResOfMqm(m_ListOfMqmResources[I]).Free;
  m_ListOfMqmResources.free;
  for I := 0 to m_ListStatisticOfGantTab.Count - 1 do
    TResOfGanttTab(m_ListStatisticOfGantTab[I]).Free;
  m_ListStatisticOfGantTab.free;
  inherited;
end;

//----------------------------------------------------------------------------//

procedure TScheduleStatistics.MergrStatisticForEechTab(var ResOfGanttTab : TResOfGanttTab; ListOfMqmResources : TList);
var
  I, W, M, C : Integer;
  kBand : Integer;
  S, TempStrQty : string;
  VisRes : TMqmVisibleRes;
  ResOfMqm : TResOfMqm;
  TempExt : Extended;
begin
  for I := 0 to ResOfGanttTab.ResList.Count - 1 do
  begin
    VisRes := TMqmVisibleRes(ResOfGanttTab.ResList[I]);
    if TMqmRes(TMQMVisibleRes(VisRes).p_Father).p_isMultiRes then
      ResOfMqm := FindResourceByCode((TMqmRes(VisRes.p_Father).p_ResCode + IntToStr(TMQMVisibleRes(VisRes).p_SubCode)) , ListOfMqmResources)
    else
      ResOfMqm := FindResourceByCode(TMqmRes(VisRes.p_Father).p_ResCode, ListOfMqmResources);
    if ResOfMqm <> nil then
    begin
     // if m_IsWeekly then
     // begin

      for W := Low(ResOfGanttTab.m_SumArrayforWeeks) to High(ResOfGanttTab.m_SumArrayforWeeks) do
      begin


        ResOfGanttTab.m_SumArrayforWeeks[W].m_StartOfPeriod_Week := ResOfMqm.m_ArrayOfWeeks[W].m_StartOfPeriod_Week;
        ResOfGanttTab.m_SumArrayforWeeks[W].m_EndOfPeriod_Week   := ResOfMqm.m_ArrayOfWeeks[W].m_EndOfPeriod_Week;


        ResOfGanttTab.m_SumArrayforWeeks[W].m_NumberOfJobs_Total_ForDelayCalc := ResOfGanttTab.m_SumArrayforWeeks[W].m_NumberOfJobs_Total_ForDelayCalc +
                                                              ResOfMqm.m_ArrayOfWeeks[W].m_NumberOfJobs_Total_ForDelayCalc;

        if ResOfGanttTab.m_SumArrayforWeeks[W].MinDaysDelay = 0 then
           ResOfGanttTab.m_SumArrayforWeeks[W].MinDaysDelay := ResOfMqm.m_ArrayOfWeeks[W].MinDaysDelay

        else if (ResOfMqm.m_ArrayOfWeeks[W].MinDaysDelay > 0) and (ResOfGanttTab.m_SumArrayforWeeks[W].MinDaysDelay > ResOfMqm.m_ArrayOfWeeks[W].MinDaysDelay) then
          ResOfGanttTab.m_SumArrayforWeeks[W].MinDaysDelay := ResOfMqm.m_ArrayOfWeeks[W].MinDaysDelay;

        if ResOfGanttTab.m_SumArrayforWeeks[W].MaxDaysDelay = 0 then
           ResOfGanttTab.m_SumArrayforWeeks[W].MaxDaysDelay := ResOfMqm.m_ArrayOfWeeks[W].MaxDaysDelay

        else if ResOfGanttTab.m_SumArrayforWeeks[W].MaxDaysDelay < ResOfMqm.m_ArrayOfWeeks[W].MaxDaysDelay then
          ResOfGanttTab.m_SumArrayforWeeks[W].MaxDaysDelay := ResOfMqm.m_ArrayOfWeeks[W].MaxDaysDelay;

        ResOfGanttTab.m_SumArrayforWeeks[W].TotDaysDelay := ResOfGanttTab.m_SumArrayforWeeks[W].TotDaysDelay +
                                                              ResOfMqm.m_ArrayOfWeeks[W].TotDaysDelay;

        for kBand := 1 to DELAY_BAND_COUNT do
          ResOfGanttTab.m_SumArrayforWeeks[W].m_DelayBands[kBand] := ResOfGanttTab.m_SumArrayforWeeks[W].m_DelayBands[kBand] +
                                                                     ResOfMqm.m_ArrayOfWeeks[W].m_DelayBands[kBand];

        for kBand := 1 to DELAY_BAND_COUNT do
          ResOfGanttTab.m_SumArrayforWeeks[W].m_EarlyBands[kBand] := ResOfGanttTab.m_SumArrayforWeeks[W].m_EarlyBands[kBand] +
                                                                     ResOfMqm.m_ArrayOfWeeks[W].m_EarlyBands[kBand];

        ResOfGanttTab.m_SumArrayforWeeks[W].m_NumberOfJobsEarly := ResOfGanttTab.m_SumArrayforWeeks[W].m_NumberOfJobsEarly +
                                                                   ResOfMqm.m_ArrayOfWeeks[W].m_NumberOfJobsEarly;

        ResOfGanttTab.m_SumArrayforWeeks[W].m_NumberOfJobsDelay := ResOfGanttTab.m_SumArrayforWeeks[W].m_NumberOfJobsDelay +
                                                                   ResOfMqm.m_ArrayOfWeeks[W].m_NumberOfJobsDelay;

        if ResOfGanttTab.m_SumArrayforWeeks[W].m_NumberOfJobs_Total_ForDelayCalc > 0 then
           ResOfGanttTab.m_SumArrayforWeeks[W].PercentOfJobsIndelay := (ResOfGanttTab.m_SumArrayforWeeks[W].m_NumberOfJobsDelay/ResOfGanttTab.m_SumArrayforWeeks[W].m_NumberOfJobs_Total_ForDelayCalc)*100;

        TempExt := Frac(ResOfGanttTab.m_SumArrayforWeeks[W].PercentOfJobsIndelay);
        S := FloatToStr(TempExt);
        if Length(S) > 3 then
        begin
          S := Copy(s, 2, 3);
          TempStrQty := FloatToStr(trunc(ResOfGanttTab.m_SumArrayforWeeks[W].PercentOfJobsIndelay));
          TempStrQty := TempStrQty + S;
          ResOfGanttTab.m_SumArrayforWeeks[W].PercentOfJobsIndelay := StrToFloat(TempStrQty);
        end;

        if ResOfGanttTab.m_SumArrayforWeeks[W].MinDaysTooEarly = 0 then
           ResOfGanttTab.m_SumArrayforWeeks[W].MinDaysTooEarly := ResOfMqm.m_ArrayOfWeeks[W].MinDaysTooEarly

        else if (ResOfMqm.m_ArrayOfWeeks[W].MinDaysTooEarly > 0) and (ResOfGanttTab.m_SumArrayforWeeks[W].MinDaysTooEarly > ResOfMqm.m_ArrayOfWeeks[W].MinDaysTooEarly) then
          ResOfGanttTab.m_SumArrayforWeeks[W].MinDaysTooEarly := ResOfMqm.m_ArrayOfWeeks[W].MinDaysTooEarly;

        if ResOfGanttTab.m_SumArrayforWeeks[W].MaxDaysTooEarly = 0 then
           ResOfGanttTab.m_SumArrayforWeeks[W].MaxDaysTooEarly := ResOfMqm.m_ArrayOfWeeks[W].MaxDaysTooEarly

        else if ResOfGanttTab.m_SumArrayforWeeks[W].MaxDaysTooEarly < ResOfMqm.m_ArrayOfWeeks[W].MaxDaysTooEarly then
          ResOfGanttTab.m_SumArrayforWeeks[W].MaxDaysTooEarly := ResOfMqm.m_ArrayOfWeeks[W].MaxDaysTooEarly;

        ResOfGanttTab.m_SumArrayforWeeks[W].TotDaysTooEarly := ResOfGanttTab.m_SumArrayforWeeks[W].TotDaysTooEarly +
                                                              ResOfMqm.m_ArrayOfWeeks[W].TotDaysTooEarly;

        ResOfGanttTab.m_SumArrayforWeeks[W].m_NumberOfJobsToEarly := ResOfGanttTab.m_SumArrayforWeeks[W].m_NumberOfJobsToEarly +
                                                                   ResOfMqm.m_ArrayOfWeeks[W].m_NumberOfJobsToEarly;

        ResOfGanttTab.m_SumArrayforWeeks[W].m_NumberOfJobs_Total_ForTooEarlyCalc := ResOfGanttTab.m_SumArrayforWeeks[W].m_NumberOfJobs_Total_ForTooEarlyCalc +
                                                              ResOfMqm.m_ArrayOfWeeks[W].m_NumberOfJobs_Total_ForTooEarlyCalc;

        if ResOfGanttTab.m_SumArrayforWeeks[W].m_NumberOfJobs_Total_ForTooEarlyCalc > 0 then
          ResOfGanttTab.m_SumArrayforWeeks[W].PercentOfJobsTooEarly := (ResOfGanttTab.m_SumArrayforWeeks[W].m_NumberOfJobsToEarly/ResOfGanttTab.m_SumArrayforWeeks[W].m_NumberOfJobs_Total_ForTooEarlyCalc) * 100;

        TempExt := Frac(ResOfGanttTab.m_SumArrayforWeeks[W].PercentOfJobsTooEarly);
        S := FloatToStr(TempExt);
        if Length(S) > 3 then
        begin
          S := Copy(s, 2, 3);
          TempStrQty := FloatToStr(trunc(ResOfGanttTab.m_SumArrayforWeeks[W].PercentOfJobsTooEarly));
          TempStrQty := TempStrQty + S;
          ResOfGanttTab.m_SumArrayforWeeks[W].PercentOfJobsTooEarly := StrToFloat(TempStrQty);
        end;

        if ResOfGanttTab.m_SumArrayforWeeks[W].MinCaseForResource = 0 then
           ResOfGanttTab.m_SumArrayforWeeks[W].MinCaseForResource := ResOfMqm.m_ArrayOfWeeks[W].MinCaseForResource

        else if (ResOfMqm.m_ArrayOfWeeks[W].MinCaseForResource > 0) and (ResOfGanttTab.m_SumArrayforWeeks[W].MinCaseForResource > ResOfMqm.m_ArrayOfWeeks[W].MinCaseForResource) then
          ResOfGanttTab.m_SumArrayforWeeks[W].MinCaseForResource := ResOfMqm.m_ArrayOfWeeks[W].MinCaseForResource;

        if ResOfGanttTab.m_SumArrayforWeeks[W].MaxCaseForResource = 0 then
           ResOfGanttTab.m_SumArrayforWeeks[W].MaxCaseForResource := ResOfMqm.m_ArrayOfWeeks[W].MaxCaseForResource

        else if ResOfGanttTab.m_SumArrayforWeeks[W].MaxCaseForResource < ResOfMqm.m_ArrayOfWeeks[W].MaxCaseForResource then
            ResOfGanttTab.m_SumArrayforWeeks[W].MaxCaseForResource := ResOfMqm.m_ArrayOfWeeks[W].MaxCaseForResource;


        ResOfGanttTab.m_SumArrayforWeeks[W].m_NumberOfJobs_Total_ForResCase := ResOfGanttTab.m_SumArrayforWeeks[W].m_NumberOfJobs_Total_ForResCase +
                                                              ResOfMqm.m_ArrayOfWeeks[W].m_NumberOfJobs_Total_ForResCase;

        for C := Low(ResOfGanttTab.m_SumArrayforWeeks[W].PercentOfjobsCaseForEachResCase) to High(ResOfGanttTab.m_SumArrayforWeeks[W].PercentOfjobsCaseForEachResCase) do
        begin
          if (ResOfMqm.m_ArrayOfWeeks[W].PercentOfjobsCaseForEachResCase[C] > 0) then
             ResOfGanttTab.m_SumArrayforWeeks[W].PercentOfjobsCaseForEachResCase[C] := ResOfGanttTab.m_SumArrayforWeeks[W].PercentOfjobsCaseForEachResCase[C] +
                                                                                  ResOfMqm.m_ArrayOfWeeks[W].PercentOfjobsCaseForEachResCase[C];
        end;

        if ResOfGanttTab.m_SumArrayforWeeks[W].MinCaseJobToJob = 0 then
           ResOfGanttTab.m_SumArrayforWeeks[W].MinCaseJobToJob := ResOfMqm.m_ArrayOfWeeks[W].MinCaseJobToJob

        else if (ResOfMqm.m_ArrayOfWeeks[W].MinCaseJobToJob > 0) and (ResOfGanttTab.m_SumArrayforWeeks[W].MinCaseJobToJob > ResOfMqm.m_ArrayOfWeeks[W].MinCaseJobToJob) then
          ResOfGanttTab.m_SumArrayforWeeks[W].MinCaseJobToJob := ResOfMqm.m_ArrayOfWeeks[W].MinCaseJobToJob;

        if ResOfGanttTab.m_SumArrayforWeeks[W].MaxCaseJobToJob = 0 then
           ResOfGanttTab.m_SumArrayforWeeks[W].MaxCaseJobToJob := ResOfMqm.m_ArrayOfWeeks[W].MaxCaseJobToJob

        else if ResOfGanttTab.m_SumArrayforWeeks[W].MaxCaseJobToJob < ResOfMqm.m_ArrayOfWeeks[W].MaxCaseJobToJob then
            ResOfGanttTab.m_SumArrayforWeeks[W].MaxCaseJobToJob := ResOfMqm.m_ArrayOfWeeks[W].MaxCaseJobToJob;

        ResOfGanttTab.m_SumArrayforWeeks[W].m_NumberOfJobs_Total_ForJobToJobCase := ResOfGanttTab.m_SumArrayforWeeks[W].m_NumberOfJobs_Total_ForJobToJobCase +
                                                              ResOfMqm.m_ArrayOfWeeks[W].m_NumberOfJobs_Total_ForJobToJobCase;

        for C := Low(ResOfGanttTab.m_SumArrayforWeeks[W].PercentOfjobsCaseForEachJobToJobCase) to High(ResOfGanttTab.m_SumArrayforWeeks[W].PercentOfjobsCaseForEachJobToJobCase) do
        begin
          if (ResOfMqm.m_ArrayOfWeeks[W].PercentOfjobsCaseForEachJobToJobCase[C] > 0) then
             ResOfGanttTab.m_SumArrayforWeeks[W].PercentOfjobsCaseForEachJobToJobCase[C] := ResOfGanttTab.m_SumArrayforWeeks[W].PercentOfjobsCaseForEachJobToJobCase[C] +
                                                                                  ResOfMqm.m_ArrayOfWeeks[W].PercentOfjobsCaseForEachJobToJobCase[C];
        end;

        ResOfGanttTab.m_SumArrayforWeeks[W].NumberOfjobsWithoutMaterial := ResOfGanttTab.m_SumArrayforWeeks[W].NumberOfjobsWithoutMaterial +
                                                              ResOfMqm.m_ArrayOfWeeks[W].NumberOfjobsWithoutMaterial;

        ResOfGanttTab.m_SumArrayforWeeks[W].NumberOfjobsWithoutAnyAddRes := ResOfGanttTab.m_SumArrayforWeeks[W].NumberOfjobsWithoutAnyAddRes +
                                                              ResOfMqm.m_ArrayOfWeeks[W].NumberOfjobsWithoutAnyAddRes;

        ResOfGanttTab.m_SumArrayforWeeks[W].NumberOfjobsWithoutManPawer := ResOfGanttTab.m_SumArrayforWeeks[W].NumberOfjobsWithoutManPawer +
                                                              ResOfMqm.m_ArrayOfWeeks[W].NumberOfjobsWithoutManPawer;

        ResOfGanttTab.m_SumArrayforWeeks[W].TotalSetupHours := ResOfGanttTab.m_SumArrayforWeeks[W].TotalSetupHours +
                                                              ResOfMqm.m_ArrayOfWeeks[W].TotalSetupHours;

        ResOfGanttTab.m_SumArrayforWeeks[W].TotalHoursExecution := ResOfGanttTab.m_SumArrayforWeeks[W].TotalHoursExecution +
                                                              ResOfMqm.m_ArrayOfWeeks[W].TotalHoursExecution;

        ResOfGanttTab.m_SumArrayforWeeks[W].TotalSetupAndExecution := ResOfGanttTab.m_SumArrayforWeeks[W].TotalSetupHours +
                                                              ResOfGanttTab.m_SumArrayforWeeks[W].TotalHoursExecution;

        if ResOfGanttTab.m_SumArrayforWeeks[W].TotalSetupHours > 0 then
          ResOfGanttTab.m_SumArrayforWeeks[W].PercentOfSetupHours := ResOfGanttTab.m_SumArrayforWeeks[W].TotalSetupHours/ResOfGanttTab.m_SumArrayforWeeks[W].TotalSetupAndExecution * 100;

        for C := 0 to ResOfMqm.m_ArrayOfWeeks[W].TotalUomProduced.Count - 1 do
          TotalUmQty((ResOfGanttTab.m_SumArrayforWeeks[W]).TotalUomProduced  , PTTotalUmProduced(ResOfMqm.m_ArrayOfWeeks[W].TotalUomProduced[C]).UM , PTTotalUmProduced(ResOfMqm.m_ArrayOfWeeks[W].TotalUomProduced[C]).totalQty);

        ResOfGanttTab.m_SumArrayforWeeks[W].TotalHoursOfOccPerGanttOcc := ResOfGanttTab.m_SumArrayforWeeks[W].TotalHoursOfOccPerGanttOcc +
                                                                     ResOfMqm.m_ArrayOfWeeks[W].TotalHoursOfOccPerGanttOcc;

        ResOfGanttTab.m_SumArrayforWeeks[W].TotalHoursAvailableOnGantt := ResOfGanttTab.m_SumArrayforWeeks[W].TotalHoursAvailableOnGantt +
                                                                     ResOfMqm.m_ArrayOfWeeks[W].TotalHoursAvailableOnGantt;

        if ResOfGanttTab.m_SumArrayforWeeks[W].TotalHoursAvailableOnGantt > 0 then
             ResOfGanttTab.m_SumArrayforWeeks[W].PercentHoursOfOccPerGanttOcc := (ResOfGanttTab.m_SumArrayforWeeks[W].TotalHoursOfOccPerGanttOcc/ResOfGanttTab.m_SumArrayforWeeks[W].TotalHoursAvailableOnGantt)*100;

        TempExt := Frac(ResOfGanttTab.m_SumArrayforWeeks[W].PercentHoursOfOccPerGanttOcc);
        S := FloatToStr(TempExt);
        if Length(S) > 3 then
        begin
          S := Copy(s, 2, 3);
          TempStrQty := FloatToStr(trunc(ResOfGanttTab.m_SumArrayforWeeks[W].PercentHoursOfOccPerGanttOcc));
          TempStrQty := TempStrQty + S;
          ResOfGanttTab.m_SumArrayforWeeks[W].PercentHoursOfOccPerGanttOcc := StrToFloat(TempStrQty);
        end;


      end;

      for M := Low(ResOfGanttTab.m_SumArrayforMonths) to High(ResOfGanttTab.m_SumArrayforMonths) do
      begin

        ResOfGanttTab.m_SumArrayforMonths[M].m_StartOfPeriod_Month := ResOfMqm.m_ArrayOfMonths[M].m_StartOfPeriod_Month;
        ResOfGanttTab.m_SumArrayforMonths[M].m_EndOfPeriod_Month := ResOfMqm.m_ArrayOfMonths[M].m_EndOfPeriod_Month;

        ResOfGanttTab.m_SumArrayforMonths[M].m_NumberOfJobs_Total_ForDelayCalc := ResOfGanttTab.m_SumArrayforMonths[M].m_NumberOfJobs_Total_ForDelayCalc +
                                                              ResOfMqm.m_ArrayOfMonths[M].m_NumberOfJobs_Total_ForDelayCalc;

        if ResOfGanttTab.m_SumArrayforMonths[M].MinDaysDelay = 0 then
           ResOfGanttTab.m_SumArrayforMonths[M].MinDaysDelay := ResOfMqm.m_ArrayOfMonths[M].MinDaysDelay

        else if (ResOfMqm.m_ArrayOfMonths[M].MinDaysDelay > 0) and (ResOfGanttTab.m_SumArrayforMonths[M].MinDaysDelay > ResOfMqm.m_ArrayOfMonths[M].MinDaysDelay) then
          ResOfGanttTab.m_SumArrayforMonths[M].MinDaysDelay := ResOfMqm.m_ArrayOfMonths[M].MinDaysDelay;

        if ResOfGanttTab.m_SumArrayforMonths[M].MaxDaysDelay = 0 then
           ResOfGanttTab.m_SumArrayforMonths[M].MaxDaysDelay := ResOfMqm.m_ArrayOfMonths[M].MaxDaysDelay

        else if ResOfGanttTab.m_SumArrayforMonths[M].MaxDaysDelay < ResOfMqm.m_ArrayOfMonths[M].MaxDaysDelay then
          ResOfGanttTab.m_SumArrayforMonths[M].MaxDaysDelay := ResOfMqm.m_ArrayOfMonths[M].MaxDaysDelay;

        ResOfGanttTab.m_SumArrayforMonths[M].TotDaysDelay := ResOfGanttTab.m_SumArrayforMonths[M].TotDaysDelay +
                                                              ResOfMqm.m_ArrayOfMonths[M].TotDaysDelay;

        for kBand := 1 to DELAY_BAND_COUNT do
          ResOfGanttTab.m_SumArrayforMonths[M].m_DelayBands[kBand] := ResOfGanttTab.m_SumArrayforMonths[M].m_DelayBands[kBand] +
                                                                      ResOfMqm.m_ArrayOfMonths[M].m_DelayBands[kBand];

        for kBand := 1 to DELAY_BAND_COUNT do
          ResOfGanttTab.m_SumArrayforMonths[M].m_EarlyBands[kBand] := ResOfGanttTab.m_SumArrayforMonths[M].m_EarlyBands[kBand] +
                                                                      ResOfMqm.m_ArrayOfMonths[M].m_EarlyBands[kBand];

        ResOfGanttTab.m_SumArrayforMonths[M].m_NumberOfJobsEarly := ResOfGanttTab.m_SumArrayforMonths[M].m_NumberOfJobsEarly +
                                                                   ResOfMqm.m_ArrayOfMonths[M].m_NumberOfJobsEarly;

        ResOfGanttTab.m_SumArrayforMonths[M].m_NumberOfJobsDelay := ResOfGanttTab.m_SumArrayforMonths[M].m_NumberOfJobsDelay +
                                                                   ResOfMqm.m_ArrayOfMonths[M].m_NumberOfJobsDelay;

        if ResOfGanttTab.m_SumArrayforMonths[M].m_NumberOfJobs_Total_ForDelayCalc > 0 then
           ResOfGanttTab.m_SumArrayforMonths[M].PercentOfJobsIndelay := (ResOfGanttTab.m_SumArrayforMonths[M].m_NumberOfJobsDelay/ResOfGanttTab.m_SumArrayforMonths[M].m_NumberOfJobs_Total_ForDelayCalc)*100;

        TempExt := Frac(ResOfGanttTab.m_SumArrayforMonths[M].PercentOfJobsIndelay);
        S := FloatToStr(TempExt);
        if Length(S) > 3 then
        begin
          S := Copy(s, 2, 3);
          TempStrQty := FloatToStr(trunc(ResOfGanttTab.m_SumArrayforMonths[M].PercentOfJobsIndelay));
          TempStrQty := TempStrQty + S;
          ResOfGanttTab.m_SumArrayforMonths[M].PercentOfJobsIndelay := StrToFloat(TempStrQty);
        end;

        if ResOfGanttTab.m_SumArrayforMonths[M].MinDaysTooEarly = 0 then
           ResOfGanttTab.m_SumArrayforMonths[M].MinDaysTooEarly := ResOfMqm.m_ArrayOfMonths[M].MinDaysTooEarly

        else if (ResOfMqm.m_ArrayOfMonths[M].MinDaysTooEarly > 0) and (ResOfGanttTab.m_SumArrayforMonths[M].MinDaysTooEarly > ResOfMqm.m_ArrayOfMonths[M].MinDaysTooEarly) then
          ResOfGanttTab.m_SumArrayforMonths[M].MinDaysTooEarly := ResOfMqm.m_ArrayOfMonths[M].MinDaysTooEarly;

        if ResOfGanttTab.m_SumArrayforMonths[M].MaxDaysTooEarly = 0 then
           ResOfGanttTab.m_SumArrayforMonths[M].MaxDaysTooEarly := ResOfMqm.m_ArrayOfMonths[M].MaxDaysTooEarly

        else if ResOfGanttTab.m_SumArrayforMonths[M].MaxDaysTooEarly < ResOfMqm.m_ArrayOfMonths[M].MaxDaysTooEarly then
          ResOfGanttTab.m_SumArrayforMonths[M].MaxDaysTooEarly := ResOfMqm.m_ArrayOfMonths[M].MaxDaysTooEarly;

        ResOfGanttTab.m_SumArrayforMonths[M].TotDaysTooEarly := ResOfGanttTab.m_SumArrayforMonths[M].TotDaysTooEarly +
                                                              ResOfMqm.m_ArrayOfMonths[M].TotDaysTooEarly;

        ResOfGanttTab.m_SumArrayforMonths[M].m_NumberOfJobsToEarly := ResOfGanttTab.m_SumArrayforMonths[M].m_NumberOfJobsToEarly +
                                                                   ResOfMqm.m_ArrayOfMonths[M].m_NumberOfJobsToEarly;

        ResOfGanttTab.m_SumArrayforMonths[M].m_NumberOfJobs_Total_ForTooEarlyCalc := ResOfGanttTab.m_SumArrayforMonths[M].m_NumberOfJobs_Total_ForTooEarlyCalc +
                                                                   ResOfMqm.m_ArrayOfMonths[M].m_NumberOfJobs_Total_ForTooEarlyCalc;

        if ResOfGanttTab.m_SumArrayforMonths[M].m_NumberOfJobs_Total_ForTooEarlyCalc > 0 then
           ResOfGanttTab.m_SumArrayforMonths[M].PercentOfJobsTooEarly := (ResOfGanttTab.m_SumArrayforMonths[M].m_NumberOfJobsToEarly/ResOfGanttTab.m_SumArrayforMonths[M].m_NumberOfJobs_Total_ForTooEarlyCalc)*100;

        TempExt := Frac(ResOfGanttTab.m_SumArrayforMonths[M].PercentOfJobsTooEarly);
        S := FloatToStr(TempExt);
        if Length(S) > 3 then
        begin
          S := Copy(s, 2, 3);
          TempStrQty := FloatToStr(trunc(ResOfGanttTab.m_SumArrayforMonths[M].PercentOfJobsTooEarly));
          TempStrQty := TempStrQty + S;
          ResOfGanttTab.m_SumArrayforMonths[M].PercentOfJobsTooEarly := StrToFloat(TempStrQty);
        end;

        if ResOfGanttTab.m_SumArrayforMonths[M].MinCaseForResource = 0 then
           ResOfGanttTab.m_SumArrayforMonths[M].MinCaseForResource := ResOfMqm.m_ArrayOfMonths[M].MinCaseForResource

        else if (ResOfMqm.m_ArrayOfMonths[M].MinCaseForResource > 0) and (ResOfGanttTab.m_SumArrayforMonths[M].MinCaseForResource > ResOfMqm.m_ArrayOfMonths[M].MinCaseForResource) then
          ResOfGanttTab.m_SumArrayforMonths[M].MinCaseForResource := ResOfMqm.m_ArrayOfMonths[M].MinCaseForResource;

        if ResOfGanttTab.m_SumArrayforMonths[M].MaxCaseForResource = 0 then
           ResOfGanttTab.m_SumArrayforMonths[M].MaxCaseForResource := ResOfMqm.m_ArrayOfMonths[M].MaxCaseForResource

        else if ResOfGanttTab.m_SumArrayforMonths[M].MaxCaseForResource < ResOfMqm.m_ArrayOfMonths[M].MaxCaseForResource then
            ResOfGanttTab.m_SumArrayforMonths[M].MaxCaseForResource := ResOfMqm.m_ArrayOfMonths[M].MaxCaseForResource;

         ResOfGanttTab.m_SumArrayforMonths[M].m_NumberOfJobs_Total_ForResCase := ResOfGanttTab.m_SumArrayforMonths[M].m_NumberOfJobs_Total_ForResCase +
                                                              ResOfMqm.m_ArrayOfMonths[M].m_NumberOfJobs_Total_ForResCase;

        for C := Low(ResOfGanttTab.m_SumArrayforMonths[M].PercentOfjobsCaseForEachResCase) to High(ResOfGanttTab.m_SumArrayforMonths[M].PercentOfjobsCaseForEachResCase) do
        begin
          if (ResOfMqm.m_ArrayOfMonths[M].PercentOfjobsCaseForEachResCase[C] > 0) then
             ResOfGanttTab.m_SumArrayforMonths[M].PercentOfjobsCaseForEachResCase[C] := ResOfGanttTab.m_SumArrayforMonths[M].PercentOfjobsCaseForEachResCase[C] +
                                                                                  ResOfMqm.m_ArrayOfMonths[M].PercentOfjobsCaseForEachResCase[C];
        end;

        if ResOfGanttTab.m_SumArrayforMonths[M].MinCaseJobToJob = 0 then
           ResOfGanttTab.m_SumArrayforMonths[M].MinCaseJobToJob := ResOfMqm.m_ArrayOfMonths[M].MinCaseJobToJob

        else if (ResOfMqm.m_ArrayOfMonths[M].MinCaseJobToJob > 0) and (ResOfGanttTab.m_SumArrayforMonths[M].MinCaseJobToJob > ResOfMqm.m_ArrayOfMonths[M].MinCaseJobToJob) then
          ResOfGanttTab.m_SumArrayforMonths[M].MinCaseJobToJob := ResOfMqm.m_ArrayOfMonths[M].MinCaseJobToJob;

        if ResOfGanttTab.m_SumArrayforMonths[M].MaxCaseJobToJob = 0 then
           ResOfGanttTab.m_SumArrayforMonths[M].MaxCaseJobToJob := ResOfMqm.m_ArrayOfMonths[M].MaxCaseJobToJob

        else if ResOfGanttTab.m_SumArrayforMonths[M].MaxCaseJobToJob < ResOfMqm.m_ArrayOfMonths[M].MaxCaseJobToJob then
            ResOfGanttTab.m_SumArrayforMonths[M].MaxCaseJobToJob := ResOfMqm.m_ArrayOfMonths[M].MaxCaseJobToJob;

        ResOfGanttTab.m_SumArrayforMonths[M].m_NumberOfJobs_Total_ForJobToJobCase := ResOfGanttTab.m_SumArrayforMonths[M].m_NumberOfJobs_Total_ForJobToJobCase +
                                                              ResOfMqm.m_ArrayOfMonths[M].m_NumberOfJobs_Total_ForJobToJobCase;

        for C := Low(ResOfGanttTab.m_SumArrayforMonths[M].PercentOfjobsCaseForEachJobToJobCase) to High(ResOfGanttTab.m_SumArrayforMonths[M].PercentOfjobsCaseForEachJobToJobCase) do
        begin
          if (ResOfMqm.m_ArrayOfMonths[M].PercentOfjobsCaseForEachJobToJobCase[C] > 0) then
             ResOfGanttTab.m_SumArrayforMonths[M].PercentOfjobsCaseForEachJobToJobCase[C] := ResOfGanttTab.m_SumArrayforMonths[M].PercentOfjobsCaseForEachJobToJobCase[C] +
                                                                                  ResOfMqm.m_ArrayOfMonths[M].PercentOfjobsCaseForEachJobToJobCase[C];
        end;


        ResOfGanttTab.m_SumArrayforMonths[M].NumberOfjobsWithoutMaterial := ResOfGanttTab.m_SumArrayforMonths[M].NumberOfjobsWithoutMaterial +
                                                              ResOfMqm.m_ArrayOfMonths[M].NumberOfjobsWithoutMaterial;

        ResOfGanttTab.m_SumArrayforMonths[M].NumberOfjobsWithoutAnyAddRes := ResOfGanttTab.m_SumArrayforMonths[M].NumberOfjobsWithoutAnyAddRes +
                                                              ResOfMqm.m_ArrayOfMonths[M].NumberOfjobsWithoutAnyAddRes;

        ResOfGanttTab.m_SumArrayforMonths[M].NumberOfjobsWithoutManPawer := ResOfGanttTab.m_SumArrayforMonths[M].NumberOfjobsWithoutManPawer +
                                                              ResOfMqm.m_ArrayOfMonths[M].NumberOfjobsWithoutManPawer;

        ResOfGanttTab.m_SumArrayforMonths[M].TotalSetupHours := ResOfGanttTab.m_SumArrayforMonths[M].TotalSetupHours +
                                                              ResOfMqm.m_ArrayOfMonths[M].TotalSetupHours;

        ResOfGanttTab.m_SumArrayforMonths[M].TotalHoursExecution := ResOfGanttTab.m_SumArrayforMonths[M].TotalHoursExecution +
                                                              ResOfMqm.m_ArrayOfMonths[M].TotalHoursExecution;


        ResOfGanttTab.m_SumArrayforMonths[M].TotalSetupAndExecution := ResOfGanttTab.m_SumArrayforMonths[M].TotalSetupHours +
                                                              ResOfGanttTab.m_SumArrayforMonths[M].TotalHoursExecution;

        if ResOfGanttTab.m_SumArrayforMonths[M].TotalSetupHours > 0 then
          ResOfGanttTab.m_SumArrayforMonths[M].PercentOfSetupHours := ResOfGanttTab.m_SumArrayforMonths[M].TotalSetupHours/ResOfGanttTab.m_SumArrayforMonths[M].TotalSetupAndExecution * 100;

        for C := 0 to ResOfMqm.m_ArrayOfMonths[M].TotalUomProduced.Count - 1 do
           TotalUmQty(ResOfGanttTab.m_SumArrayforMonths[M].TotalUomProduced, PTTotalUmProduced(ResOfMqm.m_ArrayOfMonths[M].TotalUomProduced[C]).UM , PTTotalUmProduced(ResOfMqm.m_ArrayOfMonths[M].TotalUomProduced[C]).totalQty);


        ResOfGanttTab.m_SumArrayforMonths[M].TotalHoursOfOccPerGanttOcc := ResOfGanttTab.m_SumArrayforMonths[M].TotalHoursOfOccPerGanttOcc +
                                                                     ResOfMqm.m_ArrayOfMonths[M].TotalHoursOfOccPerGanttOcc;

        ResOfGanttTab.m_SumArrayforMonths[M].TotalHoursAvailableOnGantt := ResOfGanttTab.m_SumArrayforMonths[M].TotalHoursAvailableOnGantt +
                                                                     ResOfMqm.m_ArrayOfMonths[M].TotalHoursAvailableOnGantt;

        if ResOfGanttTab.m_SumArrayforMonths[M].TotalHoursAvailableOnGantt > 0 then
             ResOfGanttTab.m_SumArrayforMonths[M].PercentHoursOfOccPerGanttOcc := (ResOfGanttTab.m_SumArrayforMonths[M].TotalHoursOfOccPerGanttOcc/ResOfGanttTab.m_SumArrayforMonths[M].TotalHoursAvailableOnGantt)*100;

        TempExt := Frac(ResOfGanttTab.m_SumArrayforMonths[M].PercentHoursOfOccPerGanttOcc);
        S := FloatToStr(TempExt);
        if Length(S) > 3 then
        begin
          S := Copy(s, 2, 3);
          TempStrQty := FloatToStr(trunc(ResOfGanttTab.m_SumArrayforMonths[M].PercentHoursOfOccPerGanttOcc));
          TempStrQty := TempStrQty + S;
          ResOfGanttTab.m_SumArrayforMonths[M].PercentHoursOfOccPerGanttOcc := StrToFloat(TempStrQty);
        end;


      end;

      ResOfGanttTab.m_SumTotalPeriod.m_StartOfPeriod_Total := ResOfMqm.m_TotalPeriod.m_StartOfPeriod_Total;
      ResOfGanttTab.m_SumTotalPeriod.m_EndOfPeriod_Total := ResOfMqm.m_TotalPeriod.m_EndOfPeriod_Total;

      ResOfGanttTab.m_SumTotalPeriod.m_NumberOfJobs_Total_ForDelayCalc := ResOfGanttTab.m_SumTotalPeriod.m_NumberOfJobs_Total_ForDelayCalc +
                                                              ResOfMqm.m_TotalPeriod.m_NumberOfJobs_Total_ForDelayCalc;

      if ResOfGanttTab.m_SumTotalPeriod.MinDaysDelay = 0 then
         ResOfGanttTab.m_SumTotalPeriod.MinDaysDelay := ResOfMqm.m_TotalPeriod.MinDaysDelay

      else if (ResOfMqm.m_TotalPeriod.MinDaysDelay > 0) and (ResOfGanttTab.m_SumTotalPeriod.MinDaysDelay > ResOfMqm.m_TotalPeriod.MinDaysDelay) then
        ResOfGanttTab.m_SumTotalPeriod.MinDaysDelay := ResOfMqm.m_TotalPeriod.MinDaysDelay;

      if ResOfGanttTab.m_SumTotalPeriod.MaxDaysDelay = 0 then
         ResOfGanttTab.m_SumTotalPeriod.MaxDaysDelay := ResOfMqm.m_TotalPeriod.MaxDaysDelay

      else if ResOfGanttTab.m_SumTotalPeriod.MaxDaysDelay < ResOfMqm.m_TotalPeriod.MaxDaysDelay then
        ResOfGanttTab.m_SumTotalPeriod.MaxDaysDelay := ResOfMqm.m_TotalPeriod.MaxDaysDelay;

      ResOfGanttTab.m_SumTotalPeriod.TotDaysDelay := ResOfGanttTab.m_SumTotalPeriod.TotDaysDelay +
                                                            ResOfMqm.m_TotalPeriod.TotDaysDelay;

      for kBand := 1 to DELAY_BAND_COUNT do
        ResOfGanttTab.m_SumTotalPeriod.m_DelayBands[kBand] := ResOfGanttTab.m_SumTotalPeriod.m_DelayBands[kBand] +
                                                              ResOfMqm.m_TotalPeriod.m_DelayBands[kBand];

      for kBand := 1 to DELAY_BAND_COUNT do
        ResOfGanttTab.m_SumTotalPeriod.m_EarlyBands[kBand] := ResOfGanttTab.m_SumTotalPeriod.m_EarlyBands[kBand] +
                                                              ResOfMqm.m_TotalPeriod.m_EarlyBands[kBand];

      ResOfGanttTab.m_SumTotalPeriod.m_NumberOfJobsEarly := ResOfGanttTab.m_SumTotalPeriod.m_NumberOfJobsEarly +
                                                                   ResOfMqm.m_TotalPeriod.m_NumberOfJobsEarly;

      ResOfGanttTab.m_SumTotalPeriod.m_NumberOfJobsDelay := ResOfGanttTab.m_SumTotalPeriod.m_NumberOfJobsDelay +
                                                                   ResOfMqm.m_TotalPeriod.m_NumberOfJobsDelay;

      if ResOfGanttTab.m_SumTotalPeriod.m_NumberOfJobs_Total_ForDelayCalc > 0 then
           ResOfGanttTab.m_SumTotalPeriod.PercentOfJobsIndelay := (ResOfGanttTab.m_SumTotalPeriod.m_NumberOfJobsDelay/ResOfGanttTab.m_SumTotalPeriod.m_NumberOfJobs_Total_ForDelayCalc)*100;

      TempExt := Frac(ResOfGanttTab.m_SumTotalPeriod.PercentOfJobsIndelay);
      S := FloatToStr(TempExt);
      if Length(S) > 3 then
      begin
        S := Copy(s, 2, 3);
        TempStrQty := FloatToStr(trunc(ResOfGanttTab.m_SumTotalPeriod.PercentOfJobsIndelay));
        TempStrQty := TempStrQty + S;
        ResOfGanttTab.m_SumTotalPeriod.PercentOfJobsIndelay := StrToFloat(TempStrQty);
      end;

      if ResOfGanttTab.m_SumTotalPeriod.MinDaysTooEarly = 0 then
         ResOfGanttTab.m_SumTotalPeriod.MinDaysTooEarly := ResOfMqm.m_TotalPeriod.MinDaysTooEarly

      else if (ResOfMqm.m_TotalPeriod.MinDaysTooEarly > 0) and (ResOfGanttTab.m_SumTotalPeriod.MinDaysTooEarly > ResOfMqm.m_TotalPeriod.MinDaysTooEarly) then
        ResOfGanttTab.m_SumTotalPeriod.MinDaysTooEarly := ResOfMqm.m_TotalPeriod.MinDaysTooEarly;

      if ResOfGanttTab.m_SumTotalPeriod.MaxDaysTooEarly = 0 then
         ResOfGanttTab.m_SumTotalPeriod.MaxDaysTooEarly := ResOfMqm.m_TotalPeriod.MaxDaysTooEarly

      else if ResOfGanttTab.m_SumTotalPeriod.MaxDaysTooEarly < ResOfMqm.m_TotalPeriod.MaxDaysTooEarly then
        ResOfGanttTab.m_SumTotalPeriod.MaxDaysTooEarly := ResOfMqm.m_TotalPeriod.MaxDaysTooEarly;

      ResOfGanttTab.m_SumTotalPeriod.TotDaysTooEarly := ResOfGanttTab.m_SumTotalPeriod.TotDaysTooEarly +
                                                            ResOfMqm.m_TotalPeriod.TotDaysTooEarly;

      ResOfGanttTab.m_SumTotalPeriod.m_NumberOfJobsToEarly := ResOfGanttTab.m_SumTotalPeriod.m_NumberOfJobsToEarly +
                                                                   ResOfMqm.m_TotalPeriod.m_NumberOfJobsToEarly;

      ResOfGanttTab.m_SumTotalPeriod.m_NumberOfJobs_Total_ForTooEarlyCalc := ResOfGanttTab.m_SumTotalPeriod.m_NumberOfJobs_Total_ForTooEarlyCalc +
                                                                   ResOfMqm.m_TotalPeriod.m_NumberOfJobs_Total_ForTooEarlyCalc;

      if ResOfGanttTab.m_SumTotalPeriod.m_NumberOfJobs_Total_ForTooEarlyCalc > 0 then
           ResOfGanttTab.m_SumTotalPeriod.PercentOfJobsTooEarly := (ResOfGanttTab.m_SumTotalPeriod.m_NumberOfJobsToEarly/ResOfGanttTab.m_SumTotalPeriod.m_NumberOfJobs_Total_ForTooEarlyCalc)*100;

      TempExt := Frac(ResOfGanttTab.m_SumTotalPeriod.PercentOfJobsTooEarly);
      S := FloatToStr(TempExt);
      if Length(S) > 3 then
      begin
        S := Copy(s, 2, 3);
        TempStrQty := FloatToStr(trunc(ResOfGanttTab.m_SumTotalPeriod.PercentOfJobsTooEarly));
        TempStrQty := TempStrQty + S;
        ResOfGanttTab.m_SumTotalPeriod.PercentOfJobsTooEarly := StrToFloat(TempStrQty);
      end;

      if ResOfGanttTab.m_SumTotalPeriod.MinCaseForResource = 0 then
         ResOfGanttTab.m_SumTotalPeriod.MinCaseForResource := ResOfMqm.m_TotalPeriod.MinCaseForResource

      else if (ResOfMqm.m_TotalPeriod.MinCaseForResource > 0) and (ResOfGanttTab.m_SumTotalPeriod.MinCaseForResource > ResOfMqm.m_TotalPeriod.MinCaseForResource) then
        ResOfGanttTab.m_SumTotalPeriod.MinCaseForResource := ResOfMqm.m_TotalPeriod.MinCaseForResource;

      if ResOfGanttTab.m_SumTotalPeriod.MaxCaseForResource = 0 then
         ResOfGanttTab.m_SumTotalPeriod.MaxCaseForResource := ResOfMqm.m_TotalPeriod.MaxCaseForResource

      else if ResOfGanttTab.m_SumTotalPeriod.MaxCaseForResource < ResOfMqm.m_TotalPeriod.MaxCaseForResource then
          ResOfGanttTab.m_SumTotalPeriod.MaxCaseForResource := ResOfMqm.m_TotalPeriod.MaxCaseForResource;

      ResOfGanttTab.m_SumTotalPeriod.m_NumberOfJobs_Total_ForResCase := ResOfGanttTab.m_SumTotalPeriod.m_NumberOfJobs_Total_ForResCase +
                                                              ResOfMqm.m_TotalPeriod.m_NumberOfJobs_Total_ForResCase;

      for C := Low(ResOfGanttTab.m_SumTotalPeriod.PercentOfjobsCaseForEachResCase) to High(ResOfGanttTab.m_SumTotalPeriod.PercentOfjobsCaseForEachResCase) do
      begin
        if (ResOfMqm.m_TotalPeriod.PercentOfjobsCaseForEachResCase[C] > 0) then
           ResOfGanttTab.m_SumTotalPeriod.PercentOfjobsCaseForEachResCase[C] := ResOfGanttTab.m_SumTotalPeriod.PercentOfjobsCaseForEachResCase[C] +
                                                                                ResOfMqm.m_TotalPeriod.PercentOfjobsCaseForEachResCase[C];
      end;

      if ResOfGanttTab.m_SumTotalPeriod.MinCaseJobToJob = 0 then
         ResOfGanttTab.m_SumTotalPeriod.MinCaseJobToJob := ResOfMqm.m_TotalPeriod.MinCaseJobToJob

      else if (ResOfMqm.m_TotalPeriod.MinCaseJobToJob > 0) and (ResOfGanttTab.m_SumTotalPeriod.MinCaseJobToJob > ResOfMqm.m_TotalPeriod.MinCaseJobToJob) then
        ResOfGanttTab.m_SumTotalPeriod.MinCaseJobToJob := ResOfMqm.m_TotalPeriod.MinCaseJobToJob;

      if ResOfGanttTab.m_SumTotalPeriod.MaxCaseJobToJob = 0 then
         ResOfGanttTab.m_SumTotalPeriod.MaxCaseJobToJob := ResOfMqm.m_TotalPeriod.MaxCaseJobToJob

      else if ResOfGanttTab.m_SumTotalPeriod.MaxCaseJobToJob < ResOfMqm.m_TotalPeriod.MaxCaseJobToJob then
          ResOfGanttTab.m_SumTotalPeriod.MaxCaseJobToJob := ResOfMqm.m_TotalPeriod.MaxCaseJobToJob;

      ResOfGanttTab.m_SumTotalPeriod.m_NumberOfJobs_Total_ForJobToJobCase := ResOfGanttTab.m_SumTotalPeriod.m_NumberOfJobs_Total_ForJobToJobCase +
                                                              ResOfMqm.m_TotalPeriod.m_NumberOfJobs_Total_ForJobToJobCase;

      for C := Low(ResOfGanttTab.m_SumTotalPeriod.PercentOfjobsCaseForEachJobToJobCase) to High(ResOfGanttTab.m_SumTotalPeriod.PercentOfjobsCaseForEachJobToJobCase) do
      begin
        if (ResOfMqm.m_TotalPeriod.PercentOfjobsCaseForEachJobToJobCase[C] > 0) then
           ResOfGanttTab.m_SumTotalPeriod.PercentOfjobsCaseForEachJobToJobCase[C] := ResOfGanttTab.m_SumTotalPeriod.PercentOfjobsCaseForEachJobToJobCase[C] +
                                                                                ResOfMqm.m_TotalPeriod.PercentOfjobsCaseForEachJobToJobCase[C];
      end;

      ResOfGanttTab.m_SumTotalPeriod.NumberOfjobsWithoutMaterial := ResOfGanttTab.m_SumTotalPeriod.NumberOfjobsWithoutMaterial +
                                                              ResOfMqm.m_TotalPeriod.NumberOfjobsWithoutMaterial;

      ResOfGanttTab.m_SumTotalPeriod.NumberOfjobsWithoutAnyAddRes := ResOfGanttTab.m_SumTotalPeriod.NumberOfjobsWithoutAnyAddRes +
                                                              ResOfMqm.m_TotalPeriod.NumberOfjobsWithoutAnyAddRes;

      ResOfGanttTab.m_SumTotalPeriod.NumberOfjobsWithoutManPawer := ResOfGanttTab.m_SumTotalPeriod.NumberOfjobsWithoutManPawer +
                                                              ResOfMqm.m_TotalPeriod.NumberOfjobsWithoutManPawer;

      ResOfGanttTab.m_SumTotalPeriod.TotalSetupHours := ResOfGanttTab.m_SumTotalPeriod.TotalSetupHours + ResOfMqm.m_TotalPeriod.TotalSetupHours;

      ResOfGanttTab.m_SumTotalPeriod.TotalHoursExecution := ResOfGanttTab.m_SumTotalPeriod.TotalHoursExecution + ResOfMqm.m_TotalPeriod.TotalHoursExecution;

      ResOfGanttTab.m_SumTotalPeriod.TotalSetupAndExecution := ResOfGanttTab.m_SumTotalPeriod.TotalSetupHours + ResOfGanttTab.m_SumTotalPeriod.TotalHoursExecution;

      if ResOfGanttTab.m_SumTotalPeriod.TotalSetupAndExecution > 0 then
        ResOfGanttTab.m_SumTotalPeriod.PercentOfSetupHours := ResOfGanttTab.m_SumTotalPeriod.TotalSetupHours/ResOfGanttTab.m_SumTotalPeriod.TotalSetupAndExecution * 100;

      for C := 0 to ResOfMqm.m_TotalPeriod.TotalUomProduced.Count - 1 do
        TotalUmQty(ResOfGanttTab.m_SumTotalPeriod.TotalUomProduced , PTTotalUmProduced(ResOfMqm.m_TotalPeriod.TotalUomProduced[C]).UM , PTTotalUmProduced(ResOfMqm.m_TotalPeriod.TotalUomProduced[C]).totalQty);


      ResOfGanttTab.m_SumTotalPeriod.TotalHoursOfOccPerGanttOcc := ResOfGanttTab.m_SumTotalPeriod.TotalHoursOfOccPerGanttOcc +
                                                                   ResOfMqm.m_TotalPeriod.TotalHoursOfOccPerGanttOcc;

      ResOfGanttTab.m_SumTotalPeriod.TotalHoursAvailableOnGantt := ResOfGanttTab.m_SumTotalPeriod.TotalHoursAvailableOnGantt +
                                                                   ResOfMqm.m_TotalPeriod.TotalHoursAvailableOnGantt;

      if ResOfGanttTab.m_SumTotalPeriod.TotalHoursAvailableOnGantt > 0 then
           ResOfGanttTab.m_SumTotalPeriod.PercentHoursOfOccPerGanttOcc := (ResOfGanttTab.m_SumTotalPeriod.TotalHoursOfOccPerGanttOcc/ResOfGanttTab.m_SumTotalPeriod.TotalHoursAvailableOnGantt)*100;

      TempExt := Frac(ResOfGanttTab.m_SumTotalPeriod.PercentHoursOfOccPerGanttOcc);
      S := FloatToStr(TempExt);
      if Length(S) > 3 then
      begin
        S := Copy(s, 2, 3);
        TempStrQty := FloatToStr(trunc(ResOfGanttTab.m_SumTotalPeriod.PercentHoursOfOccPerGanttOcc));
        TempStrQty := TempStrQty + S;
        ResOfGanttTab.m_SumTotalPeriod.PercentHoursOfOccPerGanttOcc := StrToFloat(TempStrQty);
      end;

    end;
  end;

end;

//----------------------------------------------------------------------------//

procedure TScheduleStatistics.BuildResourcePeriodStructure(IsWeekly : boolean);
var
  iRes, Iweek, iVisRes, iApa, I : Integer;
  Id : TSchedId;
  res : TMqmRes;
  VisRes : TMqmVisibleRes;
  ActArea : TMqmActArea;
  ResOfMqm : TResOfMqm;
  DatesInfo: TSQDatesInfo;
begin
  for iRes := 0 to p_pl.p_ResList.Count -1 do
  begin
    res := TMqmRes(p_pl.p_ResList[iRes]);

    if res.p_isMultiRes then
    begin

      for iVisRes := 0 to TMqmRes(res).p_VisResCount - 1 do
      begin
        ResOfMqm := TResOfMqm.CreateResOfMqm(IsWeekly);

        Visres := TMqmRes(res).p_VisRes[iVisRes];

        //  VisRes := TMqmVisibleRes(res.p_VisRes[0]);
        ResOfMqm.VisRes := VisRes;
        ResOfMqm.m_ResCode := res.p_ResCode + IntToStr(TMQMVisibleRes(VisRes).p_SubCode);

        for iApa := 0 to VisRes.p_ActAreasCount -1 do
        begin
          ActArea := TMqmActArea(VisRes.p_ActArea[iApa]);

          BuildTotalHoursAvailableOnGantt(ActArea, ResOfMqm.m_ArrayOfWeeks, ResOfMqm.m_ArrayOfMonths, ResOfMqm.m_TotalPeriod);

          id := ActArea.GetSchedObj(0);

          if Id = CSchedIDnull then continue;

          for I := 0 to ActArea.p_ObjCount -1 do
          begin
            Id := ActArea.GetSchedObj(I);
            if Id = CSchedIDnull then continue;
            begin
              p_sc.GetDatesInfo(Id, DatesInfo);
              if DatesInfo.endDate < date then continue;
              BuildDelaysDataWeeklyMonthely(ResOfMqm.m_ArrayOfWeeks, ResOfMqm.m_ArrayOfMonths, ResOfMqm.m_TotalPeriod, Id);
              BuildTooEearlyDaysDataWeeklyMonthely(ResOfMqm.m_ArrayOfWeeks, ResOfMqm.m_ArrayOfMonths, ResOfMqm.m_TotalPeriod, Id);
              BuildCaseToResourceDataWeeklyMonthely(ResOfMqm.m_ArrayOfWeeks, ResOfMqm.m_ArrayOfMonths, ResOfMqm.m_TotalPeriod, Id);
              BuildCaseJobToJobDataWeeklyMonthely(ResOfMqm.m_ArrayOfWeeks, ResOfMqm.m_ArrayOfMonths, ResOfMqm.m_TotalPeriod, Id);
              BuildNumberOfjobsWarning(ResOfMqm.m_ArrayOfWeeks, ResOfMqm.m_ArrayOfMonths, ResOfMqm.m_TotalPeriod, Id);
              BuildTotalSetupWeeklyMonthely(ResOfMqm.m_ArrayOfWeeks, ResOfMqm.m_ArrayOfMonths, ResOfMqm.m_TotalPeriod, Id);
              BuildTotalTotalExecutionWeeklyMonthely(ResOfMqm.m_ArrayOfWeeks, ResOfMqm.m_ArrayOfMonths, ResOfMqm.m_TotalPeriod, Id);
              BuildTotalHoursOfOccPerGanttOcc(ResOfMqm.m_ArrayOfWeeks, ResOfMqm.m_ArrayOfMonths, ResOfMqm.m_TotalPeriod, Id);
              TotalUomProduced(ResOfMqm.m_ArrayOfWeeks, ResOfMqm.m_ArrayOfMonths, ResOfMqm.m_TotalPeriod, Id);
            end;
          end;
        end;

        m_ListOfMqmResources.Add(ResOfMqm);

      end;
    end
    else
    begin

      VisRes := TMqmVisibleRes(res.p_VisRes[0]);
      ResOfMqm := TResOfMqm.CreateResOfMqm(IsWeekly);
      ResOfMqm.VisRes := VisRes;
      ResOfMqm.m_ResCode := res.p_ResCode;

      for iApa := 0 to VisRes.p_ActAreasCount -1 do
      begin
        ActArea := TMqmActArea(VisRes.p_ActArea[iApa]);

        BuildTotalHoursAvailableOnGantt(ActArea, ResOfMqm.m_ArrayOfWeeks, ResOfMqm.m_ArrayOfMonths, ResOfMqm.m_TotalPeriod);

        id := ActArea.GetSchedObj(0);

        if Id = CSchedIDnull then continue;

        for I := 0 to ActArea.p_ObjCount -1 do
        begin
          Id := ActArea.GetSchedObj(I);
          if Id = CSchedIDnull then continue;
          begin
            p_sc.GetDatesInfo(Id, DatesInfo);
            if DatesInfo.endDate < date then continue;
            BuildDelaysDataWeeklyMonthely(ResOfMqm.m_ArrayOfWeeks, ResOfMqm.m_ArrayOfMonths, ResOfMqm.m_TotalPeriod, Id);
            BuildTooEearlyDaysDataWeeklyMonthely(ResOfMqm.m_ArrayOfWeeks, ResOfMqm.m_ArrayOfMonths, ResOfMqm.m_TotalPeriod, Id);
            BuildCaseToResourceDataWeeklyMonthely(ResOfMqm.m_ArrayOfWeeks, ResOfMqm.m_ArrayOfMonths, ResOfMqm.m_TotalPeriod, Id);
            BuildCaseJobToJobDataWeeklyMonthely(ResOfMqm.m_ArrayOfWeeks, ResOfMqm.m_ArrayOfMonths, ResOfMqm.m_TotalPeriod, Id);
            BuildNumberOfjobsWarning(ResOfMqm.m_ArrayOfWeeks, ResOfMqm.m_ArrayOfMonths, ResOfMqm.m_TotalPeriod, Id);
            BuildTotalSetupWeeklyMonthely(ResOfMqm.m_ArrayOfWeeks, ResOfMqm.m_ArrayOfMonths, ResOfMqm.m_TotalPeriod, Id);
            BuildTotalTotalExecutionWeeklyMonthely(ResOfMqm.m_ArrayOfWeeks, ResOfMqm.m_ArrayOfMonths, ResOfMqm.m_TotalPeriod, Id);
            BuildTotalHoursOfOccPerGanttOcc(ResOfMqm.m_ArrayOfWeeks, ResOfMqm.m_ArrayOfMonths, ResOfMqm.m_TotalPeriod, Id);
            TotalUomProduced(ResOfMqm.m_ArrayOfWeeks, ResOfMqm.m_ArrayOfMonths, ResOfMqm.m_TotalPeriod, Id);
          end;
        end;
      end;

      m_ListOfMqmResources.Add(ResOfMqm);

    end;

   // m_ListOfMqmResources.Add(ResOfMqm);

  end;

end;

{ TResOfMqm }

//----------------------------------------------------------------------------//

constructor TResOfMqm.CreateResOfMqm(IsWeekly : boolean);
begin
  inherited create;
  m_IsWeekly := IsWeekly;
  IniArray;
end;

//----------------------------------------------------------------------------//

destructor TResOfMqm.destroy;
var
  I, J : Integer;
  StatisticRecordPeriod : TStatisticRecordPeriod;
begin
  for I := m_TotalPeriod.TotalUomProduced.Count - 1 downto 0 do
     dispose(PTTotalUmProduced(m_TotalPeriod.TotalUomProduced[I]));
  m_TotalPeriod.TotalUomProduced.Free;

  for I := Low(m_ArrayOfWeeks) to High(m_ArrayOfWeeks) do
  begin
    StatisticRecordPeriod := m_ArrayOfWeeks[I];
    for j := StatisticRecordPeriod.TotalUomProduced.Count - 1 downto 0 do
    begin
      dispose(PTTotalUmProduced(StatisticRecordPeriod.TotalUomProduced[J]));
    end;
    StatisticRecordPeriod.TotalUomProduced.Free;
  end;

  for I := Low(m_ArrayOfMonths) to High(m_ArrayOfMonths) do
  begin
    StatisticRecordPeriod := m_ArrayOfMonths[I];
    for j := StatisticRecordPeriod.TotalUomProduced.Count - 1 downto 0 do
    begin
      dispose(PTTotalUmProduced(StatisticRecordPeriod.TotalUomProduced[J]));
    end;
    StatisticRecordPeriod.TotalUomProduced.Free;
  end;

  inherited;
end;

//----------------------------------------------------------------------------//

procedure TResOfMqm.IniArray;
var
  I, Iweek, IMonth, compt : Integer;
  StartW, EndW , StartM, EndM: TDateTime;
begin
  m_TotalPeriod.m_StartOfPeriod_Total := date;
//  m_TotalPeriod.m_EndOfPeriod_Total   := date + 365;
  m_TotalPeriod.m_EndOfPeriod_Total := m_HieghestEndDateJob;

  m_TotalPeriod.m_NumberOfJobs_Total_ForDelayCalc := 0;
  m_TotalPeriod.m_NumberOfJobsDelay := 0;
  m_TotalPeriod.m_NumberOfJobs_Total_ForTooEarlyCalc := 0;
  m_TotalPeriod.m_NumberOfJobsToEarly := 0;

  m_TotalPeriod.MinDaysDelay := 0;
  m_TotalPeriod.MaxDaysDelay := 0;
  m_TotalPeriod.TotDaysDelay := 0;
  for compt := 1 to DELAY_BAND_COUNT do
    m_TotalPeriod.m_DelayBands[compt] := 0;
  m_TotalPeriod.m_NumberOfJobsEarly := 0;
  for compt := 1 to DELAY_BAND_COUNT do
    m_TotalPeriod.m_EarlyBands[compt] := 0;
  m_TotalPeriod.PercentOfJobsIndelay := 0;
  m_TotalPeriod.MinDaysTooEarly := 0;
  m_TotalPeriod.MaxDaysTooEarly := 0;
  m_TotalPeriod.TotDaysTooEarly := 0;
  m_TotalPeriod.PercentOfJobsTooEarly := 0;
  m_TotalPeriod.TotalSetupHours := 0;
  m_TotalPeriod.TotalSetupAndExecution := 0;
  m_TotalPeriod.PercentOfSetupHours := 0;
  m_TotalPeriod.TotalHoursExecution := 0;
  m_TotalPeriod.TotalHoursOfOccPerGanttOcc := 0;
  m_TotalPeriod.TotalHoursAvailableOnGantt := 0;
  m_TotalPeriod.PercentHoursOfOccPerGanttOcc := 0;
  m_TotalPeriod.MinCaseForResource := 0;
  m_TotalPeriod.MaxCaseForResource := 0;
  m_TotalPeriod.MinCaseJobToJob := 0;
  m_TotalPeriod.MaxCaseJobToJob := 0;
  m_TotalPeriod.m_NumberOfJobs_Total_ForResCase := 0;
  m_TotalPeriod.m_NumberOfJobs_Total_ForJobToJobCase := 0;
  m_TotalPeriod.NumberOfjobsWithoutMaterial := 0;
  m_TotalPeriod.NumberOfjobsWithoutTools := 0;
  m_TotalPeriod.NumberOfjobsWithoutManPawer := 0;
  m_TotalPeriod.NumberOfjobsWithoutAnyAddRes := 0;
  m_TotalPeriod.TotalUomProduced := TList.Create;

  for compt := Low(m_TotalPeriod.PercentOfjobsCaseForEachResCase) to High(m_TotalPeriod.PercentOfjobsCaseForEachResCase) do
    m_TotalPeriod.PercentOfjobsCaseForEachResCase[compt] := 0;

  for compt := Low(m_TotalPeriod.PercentOfjobsCaseForEachJobToJobCase) to High(m_TotalPeriod.PercentOfjobsCaseForEachJobToJobCase) do
    m_TotalPeriod.PercentOfjobsCaseForEachJobToJobCase[compt] := 0;

//  if m_IsWeekly then
//  begin
    StartW := date;
    for Iweek := 1 to 12 do
    begin
      if Iweek = 1 then
      begin
        StartW := date;
        EndW := StartW + 6;
        EndW := LocaleWeekStart(EndW); // align to the locale first day of week, like the Gantt (was Monday-only)
        if StartW <> EndW then
        begin
          m_ArrayOfWeeks[Iweek].m_StartOfPeriod_Week := StartW;
          EndW := EndW - 1;
          m_ArrayOfWeeks[Iweek].m_EndOfPeriod_Week   := EndW + (1 - 1/24/60/60);
        end
        else
        begin
          StartW := date;
          EndW := StartW + 6;
          m_ArrayOfWeeks[Iweek].m_StartOfPeriod_Week := StartW;
          m_ArrayOfWeeks[Iweek].m_EndOfPeriod_Week   := EndW + (1 - 1/24/60/60);
        end;

      end
      else
      begin
        StartW := EndW + 1;
        EndW := StartW + 6;
        m_ArrayOfWeeks[Iweek].m_StartOfPeriod_Week := StartW;
        m_ArrayOfWeeks[Iweek].m_EndOfPeriod_Week   := EndW + (1 - 1/24/60/60);
      end;
    end;

    for I := Low(m_ArrayOfWeeks) to High(m_ArrayOfWeeks) do
    begin

      //m_ArrayOfWeeks[I].TotaljobsonGantt := 0;

      m_ArrayOfWeeks[I].m_NumberOfJobs_Total_ForDelayCalc := 0;
      m_ArrayOfWeeks[I].m_NumberOfJobsDelay := 0;
      m_ArrayOfWeeks[I].m_NumberOfJobs_Total_ForTooEarlyCalc := 0;
      m_ArrayOfWeeks[I].m_NumberOfJobsToEarly := 0;

      m_ArrayOfWeeks[I].MinDaysDelay := 0;
      m_ArrayOfWeeks[I].MaxDaysDelay := 0;
      m_ArrayOfWeeks[I].TotDaysDelay := 0;
      for compt := 1 to DELAY_BAND_COUNT do
        m_ArrayOfWeeks[I].m_DelayBands[compt] := 0;
      m_ArrayOfWeeks[I].m_NumberOfJobsEarly := 0;
      for compt := 1 to DELAY_BAND_COUNT do
        m_ArrayOfWeeks[I].m_EarlyBands[compt] := 0;
      m_ArrayOfWeeks[I].PercentOfJobsIndelay := 0;
      m_ArrayOfWeeks[I].MinDaysTooEarly := 0;
      m_ArrayOfWeeks[I].MaxDaysTooEarly := 0;
      m_ArrayOfWeeks[I].TotDaysTooEarly := 0;
      m_ArrayOfWeeks[I].PercentOfJobsTooEarly := 0;
      m_ArrayOfWeeks[I].TotalSetupHours := 0;
      m_ArrayOfWeeks[I].TotalSetupAndExecution := 0;
      m_ArrayOfWeeks[I].PercentOfSetupHours := 0;
      m_ArrayOfWeeks[I].TotalHoursExecution := 0;
      m_ArrayOfWeeks[I].TotalHoursOfOccPerGanttOcc := 0;
      m_ArrayOfWeeks[I].TotalHoursAvailableOnGantt := 0;
      m_ArrayOfWeeks[I].PercentHoursOfOccPerGanttOcc := 0;
      m_ArrayOfWeeks[I].MinCaseForResource := 0;
      m_ArrayOfWeeks[I].MaxCaseForResource := 0;
      m_ArrayOfWeeks[I].MinCaseJobToJob := 0;
      m_ArrayOfWeeks[I].MaxCaseJobToJob := 0;
      m_ArrayOfWeeks[I].m_NumberOfJobs_Total_ForResCase := 0;
      m_ArrayOfWeeks[I].m_NumberOfJobs_Total_ForJobToJobCase := 0;
      m_ArrayOfWeeks[I].NumberOfjobsWithoutMaterial := 0;
      m_ArrayOfWeeks[I].NumberOfjobsWithoutTools := 0;
      m_ArrayOfWeeks[I].NumberOfjobsWithoutManPawer := 0;
      m_ArrayOfWeeks[I].NumberOfjobsWithoutAnyAddRes := 0;
      m_ArrayOfWeeks[I].TotalUomProduced := TList.Create;

      for compt := Low(m_ArrayOfWeeks[I].PercentOfjobsCaseForEachResCase) to High(m_ArrayOfWeeks[I].PercentOfjobsCaseForEachResCase) do
         m_ArrayOfWeeks[I].PercentOfjobsCaseForEachResCase[compt] := 0;

      for compt := Low(m_TotalPeriod.PercentOfjobsCaseForEachJobToJobCase) to High(m_TotalPeriod.PercentOfjobsCaseForEachJobToJobCase) do
        m_TotalPeriod.PercentOfjobsCaseForEachJobToJobCase[compt] := 0;

    end;
  //end
  //else
 // begin

    StartM := date;
    for IMonth := 1 to 4 do
    begin
      if IMonth = 1 then
      begin
        StartM := date;
        EndM := LDOM(StartM);
        m_ArrayOfMonths[IMonth].m_StartOfPeriod_Month := StartM;
        m_ArrayOfMonths[IMonth].m_EndOfPeriod_Month   := EndM;
        EndM := Trunc(EndM) + 1;
      end
      else
      begin
        StartM := EndM;
        EndM := LDOM(EndM);
        m_ArrayOfMonths[IMonth].m_StartOfPeriod_Month := StartM;
        m_ArrayOfMonths[IMonth].m_EndOfPeriod_Month   := EndM;
        EndM := Trunc(EndM) + 1;
      end;
    end;

    for I := Low(m_ArrayOfMonths) to High(m_ArrayOfMonths) do
    begin
      m_ArrayOfMonths[I].m_NumberOfJobs_Total_ForDelayCalc := 0;
      m_ArrayOfMonths[I].m_NumberOfJobsDelay := 0;
      m_ArrayOfMonths[I].m_NumberOfJobs_Total_ForTooEarlyCalc := 0;
      m_ArrayOfMonths[I].m_NumberOfJobsToEarly := 0;
      m_ArrayOfMonths[I].MinDaysDelay := 0;
      for compt := 1 to DELAY_BAND_COUNT do
        m_ArrayOfMonths[I].m_DelayBands[compt] := 0;
      m_ArrayOfMonths[I].m_NumberOfJobsEarly := 0;
      for compt := 1 to DELAY_BAND_COUNT do
        m_ArrayOfMonths[I].m_EarlyBands[compt] := 0;
      m_ArrayOfMonths[I].MaxDaysDelay := 0;
      m_ArrayOfMonths[I].TotDaysDelay := 0;
      m_ArrayOfMonths[I].PercentOfJobsIndelay := 0;
      m_ArrayOfMonths[I].MinDaysTooEarly := 0;
      m_ArrayOfMonths[I].MaxDaysTooEarly := 0;
      m_ArrayOfMonths[I].TotDaysTooEarly := 0;
      m_ArrayOfMonths[I].PercentOfJobsTooEarly := 0;
      m_ArrayOfMonths[I].TotalSetupHours := 0;
      m_ArrayOfMonths[I].TotalSetupAndExecution := 0;
      m_ArrayOfMonths[I].PercentOfSetupHours := 0;
      m_ArrayOfMonths[I].TotalHoursExecution := 0;
      m_ArrayOfMonths[I].TotalHoursOfOccPerGanttOcc := 0;
      m_ArrayOfMonths[I].TotalHoursAvailableOnGantt := 0;
      m_ArrayOfMonths[I].PercentHoursOfOccPerGanttOcc := 0;
      m_ArrayOfMonths[I].MinCaseForResource := 0;
      m_ArrayOfMonths[I].MaxCaseForResource := 0;
      m_ArrayOfMonths[I].MinCaseJobToJob := 0;
      m_ArrayOfMonths[I].MaxCaseJobToJob := 0;
      m_ArrayOfMonths[I].m_NumberOfJobs_Total_ForResCase := 0;
      m_ArrayOfMonths[I].m_NumberOfJobs_Total_ForJobToJobCase := 0;
      m_ArrayOfMonths[I].NumberOfjobsWithoutMaterial := 0;
      m_ArrayOfMonths[I].NumberOfjobsWithoutTools := 0;
      m_ArrayOfMonths[I].NumberOfjobsWithoutManPawer := 0;
      m_ArrayOfMonths[I].NumberOfjobsWithoutAnyAddRes := 0;
      m_ArrayOfMonths[I].TotalUomProduced := TList.Create;

      for compt := Low(m_ArrayOfMonths[I].PercentOfjobsCaseForEachResCase) to High(m_ArrayOfMonths[I].PercentOfjobsCaseForEachResCase) do
         m_ArrayOfMonths[I].PercentOfjobsCaseForEachResCase[compt] := 0;
      for compt := Low(m_TotalPeriod.PercentOfjobsCaseForEachJobToJobCase) to High(m_TotalPeriod.PercentOfjobsCaseForEachJobToJobCase) do
        m_TotalPeriod.PercentOfjobsCaseForEachJobToJobCase[compt] := 0;

    end;

 // end;

end;

//----------------------------------------------------------------------------//

procedure FreeScheduleStatistics;
var
  I : integer;
begin
  for I := low(m_ScheduleStatisticsArray) to High(m_ScheduleStatisticsArray) do
    TScheduleStatistics(m_ScheduleStatisticsArray[I]).Free;
  SetLength(m_ScheduleStatisticsArray,0);
  m_HieghestEndDateJob := 0;
end;

//----------------------------------------------------------------------------//

procedure DeleteLastScheduleStatistics;
var
  I : Integer;
begin
  if length(m_ScheduleStatisticsArray) = 1 then
  begin
    TScheduleStatistics(m_ScheduleStatisticsArray[0]).Free;
    SetLength(m_ScheduleStatisticsArray, 0);
  end
  else if length(m_ScheduleStatisticsArray) = 2 then
  begin
    TScheduleStatistics(m_ScheduleStatisticsArray[0]).Free;
    TScheduleStatistics(m_ScheduleStatisticsArray[0]) := TScheduleStatistics(m_ScheduleStatisticsArray[1]);
    SetLength(m_ScheduleStatisticsArray, 1);
  end
  else if length(m_ScheduleStatisticsArray) = 3 then
  begin
    TScheduleStatistics(m_ScheduleStatisticsArray[0]).Free;
    TScheduleStatistics(m_ScheduleStatisticsArray[0]) := TScheduleStatistics(m_ScheduleStatisticsArray[1]);
    TScheduleStatistics(m_ScheduleStatisticsArray[1]) := TScheduleStatistics(m_ScheduleStatisticsArray[2]);
    SetLength(m_ScheduleStatisticsArray, 2);
  end

  else if length(m_ScheduleStatisticsArray) = 4 then
  begin
    TScheduleStatistics(m_ScheduleStatisticsArray[0]).Free;
    TScheduleStatistics(m_ScheduleStatisticsArray[0]) := TScheduleStatistics(m_ScheduleStatisticsArray[1]);
    TScheduleStatistics(m_ScheduleStatisticsArray[1]) := TScheduleStatistics(m_ScheduleStatisticsArray[2]);
    TScheduleStatistics(m_ScheduleStatisticsArray[2]) := TScheduleStatistics(m_ScheduleStatisticsArray[3]);
    SetLength(m_ScheduleStatisticsArray, 3);
  end;

//  m_HieghestEndDateJob := 0;

end;

//----------------------------------------------------------------------------//

{ TResOfGanttTab }

constructor TResOfGanttTab.CreateResOfGanttTab(DateTimeCreate : TDateTime);
begin
  Inherited create;
  m_DatetimeCreate  := DateTimeCreate;
  IniSumArrays
end;

//----------------------------------------------------------------------------//

destructor TResOfGanttTab.destroy;
var
  I, J : Integer;
  StatisticRecordPeriod : TStatisticRecordPeriod;
begin
  for I := m_SumTotalPeriod.TotalUomProduced.Count - 1 downto 0 do
     dispose(PTTotalUmProduced(m_SumTotalPeriod.TotalUomProduced[I]));
  m_SumTotalPeriod.TotalUomProduced.Free;

  for I := Low(m_SumArrayforWeeks) to High(m_SumArrayforWeeks) do
  begin
    StatisticRecordPeriod := m_SumArrayforWeeks[I];
    for j := StatisticRecordPeriod.TotalUomProduced.Count - 1 downto 0 do
      dispose(PTTotalUmProduced(StatisticRecordPeriod.TotalUomProduced[J]));
    StatisticRecordPeriod.TotalUomProduced.Free;
  end;

  for I := Low(m_SumArrayforMonths) to High(m_SumArrayforMonths) do
  begin
    StatisticRecordPeriod := m_SumArrayforMonths[I];
    for j := StatisticRecordPeriod.TotalUomProduced.Count - 1 downto 0 do
      dispose(PTTotalUmProduced(StatisticRecordPeriod.TotalUomProduced[J]));
    StatisticRecordPeriod.TotalUomProduced.Free;
  end;
  inherited;
end;

//----------------------------------------------------------------------------//

procedure TResOfGanttTab.IniSumArrays;
var
  I, J : Integer;
begin
  m_SumTotalPeriod.m_NumberOfJobs_Total_ForDelayCalc := 0;
  m_SumTotalPeriod.m_NumberOfJobs_Total_ForTooEarlyCalc := 0;
  m_SumTotalPeriod.MinDaysDelay := 0;
  m_SumTotalPeriod.MaxDaysDelay := 0;
  m_SumTotalPeriod.TotDaysDelay := 0;
  for J := 1 to DELAY_BAND_COUNT do
    m_SumTotalPeriod.m_DelayBands[J] := 0;
  m_SumTotalPeriod.m_NumberOfJobsEarly := 0;
  for J := 1 to DELAY_BAND_COUNT do
    m_SumTotalPeriod.m_EarlyBands[J] := 0;
  m_SumTotalPeriod.PercentOfJobsIndelay := 0;
  m_SumTotalPeriod.MinDaysTooEarly := 0;
  m_SumTotalPeriod.MaxDaysTooEarly := 0;
  m_SumTotalPeriod.TotDaysTooEarly := 0;
  m_SumTotalPeriod.PercentOfJobsTooEarly := 0;
  m_SumTotalPeriod.TotalSetupHours := 0;
  m_SumTotalPeriod.TotalSetupAndExecution := 0;
  m_SumTotalPeriod.MinCaseForResource := 0;
  m_SumTotalPeriod.MaxCaseForResource := 0;
  m_SumTotalPeriod.m_NumberOfJobs_Total_ForResCase := 0;
  m_SumTotalPeriod.m_NumberOfJobs_Total_ForJobToJobCase := 0;
  m_SumTotalPeriod.NumberOfjobsWithoutMaterial := 0;
  m_SumTotalPeriod.NumberOfjobsWithoutTools := 0;
  m_SumTotalPeriod.NumberOfjobsWithoutManPawer := 0;
  m_SumTotalPeriod.NumberOfjobsWithoutAnyAddRes := 0;
  m_SumTotalPeriod.TotalUomProduced := TList.Create;

  for I := Low(m_SumTotalPeriod.PercentOfjobsCaseForEachResCase) to High(m_SumTotalPeriod.PercentOfjobsCaseForEachResCase) do
    m_SumTotalPeriod.PercentOfjobsCaseForEachResCase[I] := 0;

  for I := Low(m_SumTotalPeriod.PercentOfjobsCaseForEachJobToJobCase) to High(m_SumTotalPeriod.PercentOfjobsCaseForEachJobToJobCase) do
    m_SumTotalPeriod.PercentOfjobsCaseForEachJobToJobCase[I] := 0;


  for i := Low(m_SumArrayforWeeks) to High(m_SumArrayforWeeks) do
  begin
    m_SumArrayforWeeks[I].m_NumberOfJobs_Total_ForDelayCalc := 0;
    m_SumArrayforWeeks[I].m_NumberOfJobs_Total_ForTooEarlyCalc := 0;
    m_SumArrayforWeeks[I].MinDaysDelay := 0;
    m_SumArrayforWeeks[I].MaxDaysDelay := 0;
    m_SumArrayforWeeks[I].TotDaysDelay := 0;
    for J := 1 to DELAY_BAND_COUNT do
      m_SumArrayforWeeks[I].m_DelayBands[J] := 0;
    m_SumArrayforWeeks[I].m_NumberOfJobsEarly := 0;
    for J := 1 to DELAY_BAND_COUNT do
      m_SumArrayforWeeks[I].m_EarlyBands[J] := 0;
    m_SumArrayforWeeks[I].PercentOfJobsIndelay := 0;
    m_SumArrayforWeeks[I].MinDaysTooEarly := 0;
    m_SumArrayforWeeks[I].MaxDaysTooEarly := 0;
    m_SumArrayforWeeks[I].TotDaysTooEarly := 0;
    m_SumArrayforWeeks[I].PercentOfJobsTooEarly := 0;
    m_SumArrayforWeeks[I].TotalSetupHours := 0;
    m_SumArrayforWeeks[I].TotalSetupAndExecution := 0;
    m_SumArrayforWeeks[I].MinCaseForResource := 0;
    m_SumArrayforWeeks[I].MaxCaseForResource := 0;
    m_SumArrayforWeeks[I].m_NumberOfJobs_Total_ForResCase := 0;
    m_SumArrayforWeeks[I].m_NumberOfJobs_Total_ForJobToJobCase := 0;
    m_SumArrayforWeeks[I].NumberOfjobsWithoutMaterial := 0;
    m_SumArrayforWeeks[I].NumberOfjobsWithoutTools := 0;
    m_SumArrayforWeeks[I].NumberOfjobsWithoutManPawer := 0;
    m_SumArrayforWeeks[I].NumberOfjobsWithoutAnyAddRes := 0;
    m_SumArrayforWeeks[I].TotalUomProduced := TList.Create;

    for J := Low(m_SumArrayforWeeks[I].PercentOfjobsCaseForEachResCase) to High(m_SumArrayforWeeks[I].PercentOfjobsCaseForEachResCase) do
      m_SumArrayforWeeks[I].PercentOfjobsCaseForEachResCase[J] := 0;

    for J := Low(m_SumArrayforWeeks[I].PercentOfjobsCaseForEachJobToJobCase) to High(m_SumArrayforWeeks[I].PercentOfjobsCaseForEachJobToJobCase) do
      m_SumArrayforWeeks[I].PercentOfjobsCaseForEachJobToJobCase[J] := 0;

  end;

  for i := Low(m_SumArrayforMonths) to High(m_SumArrayforMonths) do
  begin
    m_SumArrayforMonths[I].m_NumberOfJobs_Total_ForDelayCalc := 0;
    m_SumArrayforMonths[I].MinDaysDelay := 0;
    m_SumArrayforMonths[I].MaxDaysDelay := 0;
    m_SumArrayforMonths[I].m_NumberOfJobs_Total_ForTooEarlyCalc := 0;
    m_SumArrayforMonths[I].TotDaysDelay := 0;
    for J := 1 to DELAY_BAND_COUNT do
      m_SumArrayforMonths[I].m_DelayBands[J] := 0;
    m_SumArrayforMonths[I].m_NumberOfJobsEarly := 0;
    for J := 1 to DELAY_BAND_COUNT do
      m_SumArrayforMonths[I].m_EarlyBands[J] := 0;
    m_SumArrayforMonths[I].PercentOfJobsIndelay := 0;
    m_SumArrayforMonths[I].MinDaysTooEarly := 0;
    m_SumArrayforMonths[I].MaxDaysTooEarly := 0;
    m_SumArrayforMonths[I].TotDaysTooEarly := 0;
    m_SumArrayforMonths[I].PercentOfJobsTooEarly := 0;
    m_SumArrayforMonths[I].TotalSetupHours := 0;
    m_SumArrayforMonths[I].TotalSetupAndExecution := 0;
    m_SumArrayforMonths[I].MinCaseForResource := 0;
    m_SumArrayforMonths[I].MaxCaseForResource := 0;
    m_SumArrayforMonths[I].m_NumberOfJobs_Total_ForResCase := 0;
    m_SumArrayforMonths[I].m_NumberOfJobs_Total_ForJobToJobCase := 0;
    m_SumArrayforMonths[I].NumberOfjobsWithoutMaterial := 0;
    m_SumArrayforMonths[I].NumberOfjobsWithoutTools := 0;
    m_SumArrayforMonths[I].NumberOfjobsWithoutManPawer := 0;
    m_SumArrayforMonths[I].NumberOfjobsWithoutAnyAddRes := 0;
    m_SumArrayforMonths[I].TotalUomProduced := TList.Create;

    for J := Low(m_SumArrayforMonths[I].PercentOfjobsCaseForEachResCase) to High(m_SumArrayforMonths[I].PercentOfjobsCaseForEachResCase) do
      m_SumArrayforMonths[I].PercentOfjobsCaseForEachResCase[J] := 0;

    for J := Low(m_SumArrayforMonths[I].PercentOfjobsCaseForEachJobToJobCase) to High(m_SumArrayforMonths[I].PercentOfjobsCaseForEachJobToJobCase) do
      m_SumArrayforMonths[I].PercentOfjobsCaseForEachJobToJobCase[J] := 0;

  end;


end;

//----------------------------------------------------------------------------//

Initialization
  m_HieghestEndDateJob := 0;

finalization
  FreeScheduleStatistics;

end.
