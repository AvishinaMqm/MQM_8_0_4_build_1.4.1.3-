unit UGshiftCal;

interface

uses Classes, UGBaseCal, dialogs, Controls;

const
  // Max Number of days in calendar
  PGCALElemMax = 366 * 4;      // about 4 years

type
  // since a calendar element is designed as a day .therefore I decided
  // to continue with this design and therefore not to treat each
  // shift as a new element but instead that each element(day) will have
  // 8 additional fields (4 shifts X 2)
  // Calendar element

  TShiftData = record
    start: double;  // start time in minutes
    dur:   double;  // duration in minutes
    Date:  TDate;
    ShiftNumber : Integer;
  end;
  PTShiftData = ^TShiftData;

  TPGCALElem = record
    JNUMWH: double;   // number of working hours - the sum of all shifts
    JPRGWH: double;   // progr. of working hours (includes JNUMWH-all shifts)
    DateModified: boolean; // It mean if this element is modified in local
    DateNew : boolean; // It mean if this element is new in local

    // shift data
    shift: array [1..4] of TShiftData;
  end;
  PTPGCALElem = ^TPGCALElem;

  TShiftEffic = record
    StartDate    : TDate;
    EndDate      : TDate;
    StartMinute1 : Integer;
    EndMinute1   : Integer;
    Effic1       : Double;
    StartMinute2 : Integer;
    EndMinute2   : Integer;
    Effic2       : double;
    StartMinute3 : Integer;
    EndMinute3   : Integer;
    Effic3       : double;
    StartMinute4 : Integer;
    EndMinute4   : Integer;
    Effic4       : double;
  end;
  PTShiftEffic = ^TShiftEffic;

  // Start with Sunday in according of Delphi feature
  TDayOfWeekEnum = (dSunday, dMonday, dTuesday, dWednesday, dThursday, dFriday, dSaturday);

  TPGCALInfoForUpdate = record
    dtStart       : TDate;
    dtEnd         : TDate;
    DayDoNotMod   : set of TDayOfWeekEnum;
    UseNotWorkDay : boolean;  // It mean if the modification of Calendar using Not working day or not
    TpOfShift     : integer;  // 0=Totally not working day     1=Totally Working day     2=Partially working day (Use Shift info)
    InfoShift     : array [1..4] of TShiftData;
    ModResCal     : Integer;
  end;

  // The Calendar Object
  // From Now get AppGlobals.MonthBefore Days before
  // (if they exists else what exists) and Store PGCALElemMx elems

  TPGCALshift = class(TPGCALObj)
  public
    m_refDate:  integer;      // Reference date (a TDateTime integer part)
    m_refDtIx:  integer;      // Reference date Ix In Array

    m_shiftIndex: integer;    // Reference shift index
    m_JCDCAL :    string;     // Calendar code
    m_lastIx:     integer;    // last valid index
    m_lastIxCalEffic: integer;
    m_startDate:  integer;    // starting date num for the calendar
    m_oldRt:      TDateTime;  // used only by the iterator
    m_calendar:  array [0..PGCALElemMax-1] of TPGCALElem; // calendar elems
    m_ShiftEffic: array [0..PGCALElemMax-1] of TShiftEffic;
    m_ListShiftEffic : TList;
    function GetRefDate:  TDateTime; override;
    function GetLastDate: TDateTime; override;

    function    DayByProgWrkHours(StartIdx: integer; ReqPRGWH: double): PTPGCALElem;
    function    OfsByWH(OfsWH: double; isStart: boolean; var startDate: TDateTime;
                        var NewDate: TDateTime; DownTimeList: TList): boolean; override;
    function    OfsByWHDwTime(OfsWH: double; isStart: boolean; var startDate: TDateTime;
                        var NewDate: TDateTime): boolean; override;

    procedure   NormalizeDate(var date: TDateTime; norm: TNormalize); override;
    function    DiffWH(Date1, Date2: TDateTime; DownTimeList: TList): double; override;
    function    DiffWHNotRounded(Date1, Date2: TDateTime; DownTimeList: TList): double; override;

    function    FromShiftToNet(date: TDateTime): TDateTime;
    function    SecondsToAddForEfficiency(StartSchedDate : TDateTime; EndSchedDate : TDateTime;
                StartSchedSecond, EndSchedSecond : Integer; DownTimeList : TList) : Integer;

    procedure   StartIterator(lt, rt: TDateTime); override;
    function    GetNext(var lt, rt: TDateTime): boolean; override;
    function    GetNextEffic(var lt, rt, NextShift : TDateTime;
                             var SH1_start, SH1_End: TDateTime; var Effic1: double; var SH2_start,
                             SH2_End: TDateTime; var Effic2: double; var SH3_start, SH3_End: TDateTime;
                             var Effic3: double; var SH4_start, SH4_End: TDateTime; var Effic4: double
                                          ): boolean; override;

    function    GetShiftCalDay(dt : TDateTime) : PTPGCALElem;
    procedure   UpdateShiftCalDay(dt: TDateTime);
    procedure   UpdateShiftEffic(List : TList);
    function    AddDaysToDateNoCalendar(DateTime : TDateTime; Days : Double) : TDateTime; override;
    procedure   Ini_lastIxCalEffic; override;
    procedure   UpdateShiftCalPeriod(InfoUpd: TPGCALInfoForUpdate);
    destructor  Destroy; override;

  private
    m_ixElem:  integer;
    m_calElem: PTPGCALElem;

    function    GetElem(I: Integer): PTPGCALElem;
    function    GetDate(date: TDateTime; var I: integer): PTPGCALElem;
    function    GetNextWork(var date: TDateTime; var I: integer): PTPGCALElem;
    function    GetPrevWork(var date: TDateTime; var I: integer): PTPGCALElem;
    function    OfsByWHMain(OfsWH: double; isStart: boolean; var startDate: TDateTime;
                        var NewDate: TDateTime; DownTimeList: TList): boolean;
 end;

{$ifdef DEVELOP}
  procedure CalShiftTestDiffWH(str: TStringList; calClass: TPGCalObjClass);
  procedure CalShiftTestNormalize(str: TStringList; calClass: TPGCalObjClass);
  procedure CalShiftTestOfsByWH(str: TStringList; calClass: TPGCalObjClass);
{$endif}

implementation

uses
  UMCommon, SysUtils;

const
  OutOfMax = -2;
  OutOfMin = -1;

//----------------------------------------------------------------------------//

function GetFirstShift(elem: PTPGCALElem): integer;
begin
  for Result := 1 to 4 do
    if elem.shift[Result].dur > 0 then exit;
  Result := -1
end;

//----------------------------------------------------------------------------//

function GetLastShift(elem: PTPGCALElem): integer;
begin
  for Result := 4 downto 1 do
    if elem.shift[Result].dur > 0 then exit;
  Result := -1
end;

//----------------------------------------------------------------------------//

// return a record with shift of day request of calendar - fp
function TPGCALshift.GetShiftCalDay(dt : TDateTime) : PTPGCALElem;
var
  calIndex : integer;
begin
  Result := GetDate(dt, calIndex);
end;

//----------------------------------------------------------------------------//

// Modify day shift of calendar - fp
procedure TPGCALshift.UpdateShiftCalDay(dt: TDateTime);
var
  Idx : integer;
  i : integer;
  CurrElem, PrevElem : PTPGCALElem;
begin
  GetDate(dt, Idx);
  PrevElem := GetElem(Idx-1);

  for i := Idx to m_lastIx do
  begin
    CurrElem := GetElem(i);
//SavAROCal    CurrElem.JNUMWH := Trunc((CurrElem.shift[1].dur + CurrElem.shift[2].dur +
//SavAROCal         CurrElem.shift[3].dur + CurrElem.shift[4].dur)/60);
    CurrElem.JNUMWH := (CurrElem.shift[1].dur + CurrElem.shift[2].dur +
         CurrElem.shift[3].dur + CurrElem.shift[4].dur)/60;
    if Assigned(PrevElem) then
      CurrElem.JPRGWH := PrevElem.JPRGWH + CurrElem.JNUMWH
    else
      CurrElem.JPRGWH := PrevElem.JPRGWH;

//    CurrElem.DateModified := true;

    PrevElem := CurrElem;
  end;

end;

//----------------------------------------------------------------------------//

procedure TPGCALshift.UpdateShiftEffic(List : TList);
var
  I : Integer;
  ShiftEffic : PTShiftEffic;
begin
  m_lastIxCalEffic := -1;

  for I := 0 to List.Count - 1 do
  begin
    Inc(m_lastIxCalEffic);
    if m_lastIxCalEffic >= (PGCALElemMax-1) then break;

    with m_ShiftEffic[m_lastIxCalEffic] do
    begin
      StartDate := PTShiftEffic(List[I]).StartDate;
      EndDate   := PTShiftEffic(List[I]).EndDate;
      StartMinute1 := PTShiftEffic(List[I]).StartMinute1;
      EndMinute1   := PTShiftEffic(List[I]).EndMinute1;
      Effic1       := PTShiftEffic(List[I]).Effic1;
      StartMinute2 := PTShiftEffic(List[I]).StartMinute2;
      EndMinute2   := PTShiftEffic(List[I]).EndMinute2;
      Effic2       := PTShiftEffic(List[I]).Effic2;
      StartMinute3 := PTShiftEffic(List[I]).StartMinute3;
      EndMinute3   := PTShiftEffic(List[I]).EndMinute3;
      Effic3       := PTShiftEffic(List[I]).Effic3;
      StartMinute4 := PTShiftEffic(List[I]).StartMinute4;
      EndMinute4   := PTShiftEffic(List[I]).EndMinute4;
      Effic4       := PTShiftEffic(List[I]).Effic4;
    end;

  end;

  for I := m_ListShiftEffic.Count - 1 downto 0 do
    dispose(PTShiftEffic(m_ListShiftEffic[I]));
  m_ListShiftEffic.Clear;

  for I := 0 to List.Count - 1 do
  begin
    new(ShiftEffic);
    ShiftEffic.StartDate    := PTShiftEffic(List[I]).StartDate;
    ShiftEffic.EndDate      := PTShiftEffic(List[I]).EndDate;
    ShiftEffic.StartMinute1 := PTShiftEffic(List[I]).StartMinute1;
    ShiftEffic.EndMinute1   := PTShiftEffic(List[I]).EndMinute1;
    ShiftEffic.Effic1       := PTShiftEffic(List[I]).Effic1;
    ShiftEffic.StartMinute2 := PTShiftEffic(List[I]).StartMinute2;
    ShiftEffic.EndMinute2   := PTShiftEffic(List[I]).EndMinute2;
    ShiftEffic.Effic2       := PTShiftEffic(List[I]).Effic2;
    ShiftEffic.StartMinute3 := PTShiftEffic(List[I]).StartMinute3;
    ShiftEffic.EndMinute3   := PTShiftEffic(List[I]).EndMinute3;
    ShiftEffic.Effic3       := PTShiftEffic(List[I]).Effic3;
    ShiftEffic.StartMinute4 := PTShiftEffic(List[I]).StartMinute4;
    ShiftEffic.EndMinute4   := PTShiftEffic(List[I]).EndMinute4;
    ShiftEffic.Effic4       := PTShiftEffic(List[I]).Effic4;
    m_ListShiftEffic.Add(ShiftEffic);
  end;

end;

//----------------------------------------------------------------------------//

function TPGCALshift.AddDaysToDateNoCalendar(DateTime : TDateTime; Days : Double) : TDateTime;
var
  SecondsToAdd, TotalSecondsToAdd : integer;
  StartSchedDate, EndSchedDate : TDate;
  StartSchedSecond, EndSchedSecond : Integer;
  First, SecondsReduced : boolean;
begin
  First := true;
  SecondsReduced := false;
  TotalSecondsToAdd := 0;
  StartSchedDate := 0;
  StartSchedSecond := 0;
  EndSchedDate := 0;
  EndSchedSecond := 0;
  repeat
    Result :=  DateTime + Days + (TotalSecondsToAdd / 60 / 60 / 24);
    RoundDateTime(Result);
    if m_ListShiftEffic.Count = 0 then exit;
    if Days = 0 then exit;
    if SecondsReduced then exit;

    if first then
    begin
      StartSchedDate := TruncToDayNum(DateTime);
      StartSchedSecond := Trunc((DateTime - StartSchedDate) * 24 * 60 * 60);
      First := false;
    end else
    begin
      StartSchedDate := EndSchedDate;
      StartSchedSecond := EndSchedSecond;
    end;
    EndSchedDate := TruncToDayNum(Result);
    EndSchedSecond := Trunc((Result - EndSchedDate) * 24 * 60 * 60);

    if StartSchedDate <= 0 then exit;

    SecondsToAdd := SecondsToAddForEfficiency(StartSchedDate,EndSchedDate,StartSchedSecond,EndSchedSecond,nil);
    if (SecondsToAdd < 0) then SecondsReduced := true;

    TotalSecondsToAdd := TotalSecondsToAdd + SecondsToAdd;
  until SecondsToAdd = 0;

end;

//----------------------------------------------------------------------------//

procedure TPGCALshift.Ini_lastIxCalEffic;
begin
  m_lastIxCalEffic := -1;
end;

//----------------------------------------------------------------------------//

procedure TPGCALshift.UpdateShiftCalPeriod(InfoUpd: TPGCALInfoForUpdate);

  function IsDayToModify(Elem: PTPGCALElem; Count: integer;
                         Info: TPGCALInfoForUpdate): boolean;
  begin
    Result := true;
    // 1. Check if the day is not totally working day  // avi
   // if (Elem.JNUMWH = 0) and (not Info.UseNotWorkDay) then
   // begin
   //   Result := false;
   //   exit
   // end;

    // 2.Check if the day must not be modified
    if not (TDayOfWeekEnum((DayOfWeek(Info.dtStart + Count))-1) in Info.DayDoNotMod) then
      Result := false;
  end;

var
  IdxStart, IdxEnd : integer;
  i, z, CountDay : integer;
  CurrElem, PrevElem : PTPGCALElem;
begin

  GetDate(InfoUpd.dtStart, IdxStart);
  GetDate(InfoUpd.dtEnd, IdxEnd);

  PrevElem := GetElem(IdxStart-1);
  CountDay := 0;

  for i := IdxStart to IdxEnd do
  begin

    CurrElem := GetElem(i);

    if CurrElem = nil then continue;

    if IsDayToModify(CurrElem, CountDay, InfoUpd) then
    begin
{SavAROCal
      CurrElem.JNUMWH := Trunc((InfoUpd.InfoShift[1].dur +
         InfoUpd.InfoShift[2].dur + InfoUpd.InfoShift[3].dur+
         InfoUpd.InfoShift[4].dur) / 60);
}
      CurrElem.JNUMWH := (InfoUpd.InfoShift[1].dur +
         InfoUpd.InfoShift[2].dur + InfoUpd.InfoShift[3].dur+
         InfoUpd.InfoShift[4].dur) / 60;

      for z := Low(CurrElem.shift) to High(CurrElem.shift) do
      begin
        CurrElem.shift[z].start := InfoUpd.InfoShift[z].start;
        CurrElem.shift[z].dur := InfoUpd.InfoShift[z].dur;
      end;
    end;

    if Assigned(PrevElem) then
      CurrElem.JPRGWH := PrevElem.JPRGWH + CurrElem.JNUMWH;
   // else
    //  CurrElem.JPRGWH := PrevElem.JPRGWH;

    CurrElem.DateModified := true;

    PrevElem := CurrElem;

    Inc(CountDay);
  end;

  if IdxEnd < m_lastIx then
    UpdateShiftCalDay(InfoUpd.dtStart + CountDay);

end;

//----------------------------------------------------------------------------//

destructor TPGCALshift.Destroy;
var
  I : Integer;
begin
  if Assigned(m_ListShiftEffic) then
  begin
    for I := m_ListShiftEffic.Count - 1 downto 0 do
      dispose(PTShiftEffic(m_ListShiftEffic[I]));
    m_ListShiftEffic.Free;
  end;
  inherited destroy;
end;

//----------------------------------------------------------------------------//

function TPGCALshift.GetRefDate: TDateTime;
begin
  Result := m_startDate
end;

//----------------------------------------------------------------------------//

function TPGCALshift.GetLastDate: TDateTime;
begin
  Result := m_startDate + m_lastIx
end;

//----------------------------------------------------------------------------//

// get element by index (nil if not available)
function TPGCALshift.GetElem(i: integer): PTPGCALElem;
begin
  if (i > m_lastIx) or (i < Low(m_calendar)) then
    Result := nil
  else
    Result := @m_calendar[i]
end;

//----------------------------------------------------------------------------//

// get calendar element and index by date
function TPGCALshift.GetDate(date: TDateTime; var I: integer): PTPGCALElem;
var
  J: integer;
begin
  I := -1;
  Result := nil;

  if m_lastIx > 0 then
  begin
    J := TruncToDayNum(date) - m_startDate;
    if J > m_lastIx then
    begin
      I := OutOfMax;
      exit
    end
    else if J < Low(m_calendar) then
    begin
      I := OutOfMin;
      exit
    end;
    I := J;
    Result := @m_calendar[I]
  end
end;

//----------------------------------------------------------------------------//

// Get the calendar element for the next working day (this means
// that working hours are <> 0), his index, and the date.

function TPGCALshift.GetNextWork(var date: TDateTime; var i: integer): PTPGCALElem;
begin
  date := trunc(date + 1);
  Result := GetDate(date, i);
  while Assigned(Result) and (Result.JNUMWH = 0) do
  begin
    Result := GetElem(i + 1);
    if Assigned(Result) then
    begin
      i := i + 1;
      date := date + 1
    end
  end;

  if not Assigned(Result) then
    date := trunc(date)
end;

//----------------------------------------------------------------------------//

// Get the calendar element for the previous working day (this means
// that working hours are <> 0), his index, and the date.

function TPGCALshift.GetPrevWork(var date: TDateTime; var i: integer): PTPGCALElem;
begin
  date := trunc(date - 1);
  Result := GetDate(date, i);
  while Assigned(Result) and (Result.JNUMWH = 0) do
  begin
    Result := GetElem(i - 1);
    if Assigned(Result) then
    begin
      i := i - 1;
      date := date - 1
    end
  end;

  if not Assigned(Result) then
    date := trunc(date) + 24 - 1/24/60
end;

//----------------------------------------------------------------------------//

procedure TPGCALshift.NormalizeDate(var date: TDateTime; norm: TNormalize);
var
  calIndex, i: integer;
  wkDate:      TDateTime;
  dayMin, OrigDayMin:      double;
  elem:        PTPGCALElem;

  function GetWkPrdFwd(i: integer): boolean;
  var
    shift: PTShiftData;
  begin
    Result := false;
    shift := @elem.shift[i];
    if (shift.dur > 0) and (dayMin < (shift.start + shift.dur)) then
    begin
      if dayMin < shift.start then
        dayMin := shift.start;
      Result := true
    end
  end;

  function GetWkPrdBkw(i: integer): boolean;
  var
    shift: PTShiftData;
  begin
    Result := false;
    shift := @elem.shift[i];
    if (shift.dur > 0) and (dayMin > shift.start) then
    begin
      if dayMin > (shift.start + shift.dur) then
        dayMin := shift.start + shift.dur;
      Result := true;
    end
  end;

begin

  wkDate := date;

  elem := GetDate(wkDate, calIndex);
  // fp - I have add follow line with fp mark
  if not Assigned(elem) then
  begin
    SetCalError(calErr_outOfBound);   // fp
    exit
  end;

  // hours and minutes of the day only (in minutes)
  dayMin := MinutesFromDate(wkDate);
  OrigDayMin := dayMin;
  wkDate := TruncToDayDate(wkDate);

  // align the required position inside the work hours of the day
  if norm = ntNormalizeForward then
  begin
    if not (GetWkPrdFwd(1) or GetWkPrdFwd(2) or
            GetWkPrdFwd(3) or GetWkPrdFwd(4)) then
    begin
      elem := GetNextWork(wkDate, calIndex);
      if not Assigned(elem) then exit;
      i := GetFirstShift(elem);
      if i = -1 then exit;
      dayMin := elem.shift[i].start;
      date := wkDate + (dayMin / 24 / 60)  //sav
    end
  end else
  begin
    // norm = ntNormalizeBackward
    if not (GetWkPrdBkw(4) or GetWkPrdBkw(3) or
            GetWkPrdBkw(2) or GetWkPrdBkw(1)) then
    begin
      elem := GetPrevWork(wkDate, calIndex);
      if not Assigned(elem) then exit;
      i := GetLastShift(elem);
      if i = -1 then exit;
      dayMin := elem.shift[i].start + elem.shift[i].dur;
      date := wkDate + (dayMin / 24 / 60) //sav
    end
  end;

  if (OrigDayMin <> dayMin)
  or (TruncToDayDate(date) <> wkDate) then
    date := wkDate + (dayMin / 24 / 60)
end;

//----------------------------------------------------------------------------//

function TPGCALshift.DayByProgWrkHours(StartIdx: integer; ReqPRGWH: double): PTPGCALElem;
var
  i: integer;
  L, H: integer;
  Found: boolean;
  Elem, PrevElem: PTPGCALElem;
begin
  Result := nil;

//  Binary search we have to sort the list before using it

  L := StartIdx;
  H := m_lastIx;
  Found := false;

  while (L <= H) and not Found do
  begin

    i := (H-L) div 2;
    if i < L then i := L+i;
    if i > H then i := H-i;

    elem := GetElem(i);
    if (i > 0) then
      PrevElem := GetElem(i-1)
    else
      PrevElem := nil;

    if (Elem.JPRGWH < ReqPRGWH) then
      L := i + 1
    else
      if not Assigned(PrevElem)
      or ((Elem.JPRGWH >= ReqPRGWH) and (PrevElem.JPRGWH < ReqPRGWH)) then
      begin
        Result := Elem;
        Found := true
      end else
        H := i - 1;
  end;

end;

//----------------------------------------------------------------------------//

function TPGCALshift.OfsByWHMain(OfsWH: double; isStart: boolean;
                             var startDate: TDateTime;
                             var newDate: TDateTime;
                             DownTimeList: TList): boolean;

  //returns the number of work hours(of shifts) that have passed already
  function GetNumWH(elem: PTPGCALElem; date: double): double;

    // returns the sum of minutes of the shift that have already passed
    // at this time of day

    function GetShiftWH(dayMinutesOver, Shift_Start, Shift_Minutes: double): double;
    begin
      if dayMinutesOver < Shift_Start then
        Result := 0
      else
      begin
        if dayMinutesOver < (Shift_Start + Shift_Minutes) then
          Result := dayMinutesOver - Shift_Start
        else
          Result := Shift_Minutes
      end
    end;

  var
    dayMinutesOver: Double;
    workMinutesOver: Double;
    Hour, Min, Sec, MSec : Word;
  begin
    workMinutesOver := 0;
    DecodeTime(date ,Hour, Min, Sec, MSec);
    dayMinutesOver  := (Hour * 3600 + Min * 60 + sec)/60;
//    dayMinutesOver  := TruncToDayNum(frac(date) * 24 * 60);
    workMinutesOver := workMinutesOver + GetShiftWH(dayMinutesOver,elem.shift[1].start,elem.shift[1].dur);
    workMinutesOver := workMinutesOver + GetShiftWH(dayMinutesOver,elem.shift[2].start,elem.shift[2].dur);
    workMinutesOver := workMinutesOver + GetShiftWH(dayMinutesOver,elem.shift[3].start,elem.shift[3].dur);
    workMinutesOver := workMinutesOver + GetShiftWH(dayMinutesOver,elem.shift[4].start,elem.shift[4].dur);
    Result := workMinutesOver/60 //return in hours
  end;

  // returns the number of work hours(of shifts) that have passed already
  function GetDateFromOfs(elem: PTPGCALElem; ofsMin: double): TDateTime;
  begin
    Result := 0;
    if ofsMin <= elem.shift[1].dur then
      Result := elem.shift[1].start + ofsMin
    else
    begin
      ofsMin := ofsMin - elem.shift[1].dur;

      if ofsMin <= elem.shift[2].dur then
        Result := elem.shift[2].start + ofsMin
      else
      begin
        ofsMin := ofsMin - elem.shift[2].dur;

        if ofsMin <= elem.shift[3].dur then
          Result := elem.shift[3].start + ofsMin
        else
        begin
          ofsMin := ofsMin - elem.shift[3].dur;

          if ofsMin <= elem.shift[4].dur then
            Result := elem.shift[4].start + ofsMin
//          else
//            ofsMin := ofsMin - elem.shift[4].dur;
//            Assert(false)
        end
      end
    end;

    Result := Result / 60 / 24
  end;

  procedure RoundDate(var DateToRound: TDateTime);
  var
    TmpDate: String;
  begin
    RoundDateTime(DateToRound);
//try	
//    TmpDate := DateTimeToStr(DateToRound);
//    DateToRound := StrToDateTime(TmpDate)
//    except
//    end;
  end;
var
  ReqPRGWH: double;
  WrkPRGWH: double;
  calIndex: integer;
  elem:     PTPGCALElem;
  genOfs:   double;
  dayDate:  TDateTime;
  date:     TDateTime;
  StartDateTemp:     TDateTime;
  i:        integer;
  RecDown:  PTRecCalDownTime;


//  oldData: double;
begin
//  inc(m_TestCount);
  Result := false;

  if isStart then
    NormalizeDate(startDate, ntNormalizeForward)
  else
    NormalizeDate(startDate, ntNormalizeBackward);

  date := startDate;
  dayDate := TruncToDayNum(date);

  //Search for the element of the calendar
  elem := GetDate(date, calIndex);
  if not Assigned(elem) then
    if calIndex = OutOfMax then
    begin
      if OfsWH >= 0.0 then
      begin
        newDate := date + OfsWH / 24;
        RoundDate(newDate);
        Result := true;
        exit
      end;
      OfsWH := OfsWH - (dayDate-(m_startDate+m_lastIx)) * 24;
      date := m_startDate + m_lastIx;
      elem := @m_calendar[m_lastIx]
    end else
    begin
      Assert(calIndex = OutOfMin);
      if OfsWH < 0.0 then
      begin
        newDate := date + OfsWH / 24;
        RoundDate(newDate);
        Result := true;
        exit
      end;
      genOfs := (m_startDate-date) * 24;
      if OfsWH > Round(genOfs) then    // avi  31 08 2009 old (if OfsWH > genOfs)
      begin
        //OfsWH := OfsWH - (genOfs)  //   5/10/2009

//        olddata := OfsWH;            //   5/10/2009  ERAN no need 24/10/2013
        OfsWH := OfsWH - (genOfs);   //   5/10/2009

//        if oldData > OfsWH then      //   5/10/2009         ERAN no need 24/10/2013
//        begin                                               ERAN no need 24/10/2013
//          m_startDate := m_startDate + 1;  //   5/10/2009   ERAN no need 24/10/2013
//        end

      end
      else
      begin
        newDate := date + OfsWH / 24;
        RoundDate(newDate);
        Result := true;
        exit
      end;
      date := m_startDate;
      elem := @m_calendar[0]
    end;

  newDate := dayDate;

  //WrkPRGWH includes WH already passed in previous shifts (GetNumWH...)
  WrkPRGWH := elem.JPRGWH - elem.JNUMWH + GetNumWH(elem,date);
 // ReqPRGWH := WrkPRGWH + OfsWH;

  ReqPRGWH := (WrkPRGWH*60 + OfsWH*60)/60;

  // find the day
  if OfsWH >= 0 then
  begin
{
    if (elem.JPRGWH < ReqPRGWH) then
      elem := DayByProgWrkHours(calIndex, ReqPRGWH);
    if not Assigned(elem) then
    begin
      // fp - I have add this line for redim entity over the end of calendar
      SetCalError(calErr_outOfBound);
      exit;
    end;
}
    //if in the end of the day we still don't have enough WH then move to next day
    while elem.JPRGWH < ReqPRGWH do
    begin
      newDate := NewDate + 1;
      calIndex := calIndex + 1;
      elem := GetElem(calIndex);
      if not Assigned(elem) then
      begin
        // fp - I have add this line for redim entity over the end of calendar
        SetCalError(calErr_outOfBound);
        exit;
      end;
    end
  end else  // if  OfsWH < 0
    while (elem.JPRGWH - elem.JNUMWH) > ReqPRGWH do
    begin
      newDate := NewDate - 1;
      calIndex := calIndex - 1;
      elem := GetElem(calIndex);
      if not Assigned(elem) then exit
    end;

  Assert(Assigned(elem));
  newDate := newDate + GetDateFromOfs(elem, (ReqPRGWH - (elem.JPRGWH-elem.JNUMWH))*60);
{SavAroCal
  if isStart then
    NormalizeDate(newDate, ntNormalizeBackward)
  else
    NormalizeDate(newDate, ntNormalizeForward);
}

  RoundDate(newDate);

  Result := true;

  if Assigned(DownTimeList) then
  begin
    StartDateTemp := StartDate;
    for i := 0 to DownTimeList.Count -1 do
    begin
      RecDown := DownTimeList[i];
      if (RecDown.DowntimeStart <= startDate) and (RecDown.DowntimeEnd > startDate)
      or (RecDown.DowntimeStart < newDate)    and (RecDown.DowntimeEnd >= newDate)
      or (RecDown.DowntimeStart >= startDate) and (RecDown.DowntimeEnd <= newDate) then
      begin
        if (RecDown.DowntimeStart < startDate) and (RecDown.DowntimeEnd > startDate) then
        begin
          if isStart then
            StartDateTemp := RecDown.DowntimeEnd
          else
            StartDateTemp := RecDown.DowntimeStart;
        end else
        begin
          if isStart then
            OfsWH := OfsWH + RecDown.DurationHours
          else
            OfsWH := OfsWH - RecDown.DurationHours;
        end;
      //  Result := OfsByWH(OfsWH, isStart, startDate, newDate, nil); // old
        Result := OfsByWHMain(OfsWH, isStart, startDateTemp, newDate, nil);
      end
    end;
  end;
end;

//----------------------------------------------------------------------------//

function TPGCALshift.OfsByWH(OfsWH: double; isStart: boolean;
                             var startDate: TDateTime;
                             var newDate: TDateTime;
                             DownTimeList: TList): boolean;
var
  startDateSave, newDateSave : TDateTime;
  SecondsToAdd, TotalSecondsToAdd : integer;
  StartSchedDate, EndSchedDate : TDate;
  StartSchedSecond, EndSchedSecond : Integer;
  OfsWHTemp : Double;
  First, SecondsReduced : boolean;
  begin
  startDateSave := startDate;
  newDateSave := newDate;
  First := true;
  TotalSecondsToAdd := 0;
  StartSchedDate := 0;
  StartSchedSecond := 0;
  EndSchedDate := 0;
  EndSchedSecond := 0;
  SecondsReduced := false;
  repeat
    startDate := startDateSave;
    newDate := newDateSave;
    if OfsWH > 0 then
      OfsWHTemp := OfsWH + (TotalSecondsToAdd / 60 / 60)
    else
      OfsWHTemp := OfsWH - (TotalSecondsToAdd / 60 / 60);
    Result := OfsByWHMain(OfsWHTemp, isStart, startDate, newDate, DownTimeList);
    if m_ListShiftEffic.Count = 0 then exit;
    if not result then exit;
    if OfsWH = 0 then exit;
    if SecondsReduced then exit;

    if startDate <= newDate then
    begin
      if first then
      begin
        StartSchedDate := TruncToDayNum(startDate);
        StartSchedSecond := Trunc((startDate - StartSchedDate) * 24 * 60 * 60);
        First := false;
      end else
      begin
        StartSchedDate := EndSchedDate;
        StartSchedSecond := EndSchedSecond;
      end;
      EndSchedDate := TruncToDayNum(newDate);
      EndSchedSecond := Trunc((newDate - EndSchedDate) * 24 * 60 * 60);
    end else
    begin
      if first then
      begin
        EndSchedDate := TruncToDayNum(startDate);
        EndSchedSecond := Trunc((startDate - EndSchedDate) * 24 * 60 * 60);
        First := false;
      end else
      begin
        EndSchedDate := StartSchedDate;
        EndSchedSecond := StartSchedSecond;
      end;
      StartSchedDate := TruncToDayNum(newDate);
      StartSchedSecond := Trunc((newDate - StartSchedDate) * 24 * 60 * 60);
    end;
    if StartSchedDate <= 0 then exit;

    SecondsToAdd := SecondsToAddForEfficiency(StartSchedDate,EndSchedDate,StartSchedSecond,EndSchedSecond,DownTimeList);
    if (SecondsToAdd < 0) then SecondsReduced := true;

    TotalSecondsToAdd := TotalSecondsToAdd + SecondsToAdd;
  until SecondsToAdd = 0;

end;

//----------------------------------------------------------------------------//

function TPGCALshift.OfsByWHDwTime(OfsWH: double; isStart: boolean; var startDate: TDateTime;
                        var NewDate: TDateTime): boolean;
  //returns the number of work hours(of shifts) that have passed already
  function GetNumWH(elem: PTPGCALElem; date: double): double;

    // returns the sum of minutes of the shift that have already passed
    // at this time of day

    function GetShiftWH(dayMinutesOver, Shift_Start, Shift_Minutes: double): double;
    begin
      if dayMinutesOver < Shift_Start then
        Result := 0
      else
      begin
        if dayMinutesOver < (Shift_Start + Shift_Minutes) then
          Result := dayMinutesOver - Shift_Start
        else
          Result := Shift_Minutes
      end
    end;

  var
    dayMinutesOver: Double;
    workMinutesOver: Double;
    Hour, Min, Sec, MSec : Word;
  begin
    workMinutesOver := 0;
    DecodeTime(date ,Hour, Min, Sec, MSec);
    dayMinutesOver  := (Hour * 3600 + Min * 60 + sec)/60;
//    dayMinutesOver  := TruncToDayNum(frac(date) * 24 * 60);
    workMinutesOver := workMinutesOver + GetShiftWH(dayMinutesOver,elem.shift[1].start,elem.shift[1].dur);
    workMinutesOver := workMinutesOver + GetShiftWH(dayMinutesOver,elem.shift[2].start,elem.shift[2].dur);
    workMinutesOver := workMinutesOver + GetShiftWH(dayMinutesOver,elem.shift[3].start,elem.shift[3].dur);
    workMinutesOver := workMinutesOver + GetShiftWH(dayMinutesOver,elem.shift[4].start,elem.shift[4].dur);
    Result := workMinutesOver/60 //return in hours
  end;

  // returns the number of work hours(of shifts) that have passed already
  function GetDateFromOfs(elem: PTPGCALElem; ofsMin: double): TDateTime;
  begin
    Result := 0;
    if ofsMin <= elem.shift[1].dur then
      Result := elem.shift[1].start + ofsMin
    else
    begin
      ofsMin := ofsMin - elem.shift[1].dur;

      if ofsMin <= elem.shift[2].dur then
        Result := elem.shift[2].start + ofsMin
      else
      begin
        ofsMin := ofsMin - elem.shift[2].dur;

        if ofsMin <= elem.shift[3].dur then
          Result := elem.shift[3].start + ofsMin
        else
        begin
          ofsMin := ofsMin - elem.shift[3].dur;

          if ofsMin <= elem.shift[4].dur then
            Result := elem.shift[4].start + ofsMin
//          else
//            ofsMin := ofsMin - elem.shift[4].dur;
//            Assert(false)
        end
      end
    end;

    Result := Result / 60 / 24
  end;

  procedure RoundDate(var DateToRound: TDateTime);
  var
    TmpDate: String;
  begin
    TmpDate := DateTimeToStr(DateToRound);
    DateToRound := StrToDateTime(TmpDate)
  end;
var
  ReqPRGWH: double;
  WrkPRGWH: double;
  calIndex: integer;
  elem:     PTPGCALElem;
  genOfs:   double;
  dayDate:  TDateTime;
  date:     TDateTime;
begin
//  inc(m_TestCount);
  Result := false;

  if isStart then
    NormalizeDate(startDate, ntNormalizeForward)
  else
    NormalizeDate(startDate, ntNormalizeBackward);

  date := startDate;
  dayDate := TruncToDayNum(date);

  //Search for the element of the calendar
  elem := GetDate(date, calIndex);
  if not Assigned(elem) then
    if calIndex = OutOfMax then
    begin
      if OfsWH >= 0.0 then
      begin
        newDate := date + OfsWH / 24;
        RoundDate(newDate);
        Result := true;
        exit
      end;
      OfsWH := OfsWH - (dayDate-(m_startDate+m_lastIx)) * 24;
      date := m_startDate + m_lastIx;
      elem := @m_calendar[m_lastIx]
    end else
    begin
      Assert(calIndex = OutOfMin);
      if OfsWH < 0.0 then
      begin
        newDate := date + OfsWH / 24;
        RoundDate(newDate);
        Result := true;
        exit
      end;
      genOfs := (m_startDate-date) * 24;
      if OfsWH > genOfs then
        OfsWH := OfsWH - genOfs
      else
      begin
        newDate := date + OfsWH / 24;
        RoundDate(newDate);
        Result := true;
        exit
      end;
      date := m_startDate;
      elem := @m_calendar[0]
    end;

  newDate := dayDate;

  //WrkPRGWH includes WH already passed in previous shifts (GetNumWH...)
  WrkPRGWH := elem.JPRGWH - elem.JNUMWH + GetNumWH(elem,date);
 // ReqPRGWH := WrkPRGWH + OfsWH;

  ReqPRGWH := (WrkPRGWH*60 + OfsWH*60)/60;

  // find the day
  if OfsWH >= 0 then
  begin
{
    if (elem.JPRGWH < ReqPRGWH) then
      elem := DayByProgWrkHours(calIndex, ReqPRGWH);
    if not Assigned(elem) then
    begin
      // fp - I have add this line for redim entity over the end of calendar
      SetCalError(calErr_outOfBound);
      exit;
    end;
}
    //if in the end of the day we still don't have enough WH then move to next day
    while elem.JPRGWH < ReqPRGWH do
    begin
      newDate := NewDate + 1;
      calIndex := calIndex + 1;
      elem := GetElem(calIndex);
      if not Assigned(elem) then
      begin
        // fp - I have add this line for redim entity over the end of calendar
        SetCalError(calErr_outOfBound);
        exit;
      end;
    end
  end else  // if  OfsWH < 0
    while (elem.JPRGWH - elem.JNUMWH) > ReqPRGWH do
    begin
      newDate := NewDate - 1;
      calIndex := calIndex - 1;
      elem := GetElem(calIndex);
      if not Assigned(elem) then exit
    end;

  Assert(Assigned(elem));
  newDate := newDate + GetDateFromOfs(elem, (ReqPRGWH - (elem.JPRGWH-elem.JNUMWH))*60);

  RoundDate(newDate);

  Result := true;

end;

//----------------------------------------------------------------------------//

//returns the number of work hours(of shifts) that have passed already
function GetWorkHoursTillATimeInADate(elem: PTPGCALElem; Date: TDateTime): double;
var
  hours, minutes, seconds, milliSeconds : word;
  min : double;
  Sec : integer;
begin

  DecodeTime(frac(date), hours, minutes, seconds, milliSeconds);

  Sec := hours * 3600 + minutes * 60 + seconds;
  min := sec / 60;

  if min <= elem.shift[1].start then
    Result := 0
  else
    if (min > elem.shift[1].start) and (min <= elem.shift[1].start + elem.shift[1].dur) then
      Result := min - elem.shift[1].start
    else
      if min <= elem.shift[2].start then
        Result := elem.shift[1].dur
      else
        if (min > elem.shift[2].start) and (min <= elem.shift[2].start + elem.shift[2].dur) then
          Result := min - elem.shift[2].start + elem.shift[1].dur
        else
          if min <= elem.shift[3].start then
            Result := elem.shift[1].dur + elem.shift[2].dur
          else
            if (min > elem.shift[3].start) and (min <= elem.shift[3].start + elem.shift[3].dur) then
              Result := min - elem.shift[3].start + elem.shift[1].dur + elem.shift[2].dur
            else
              if min <= elem.shift[4].start then
                Result := elem.shift[1].dur + elem.shift[2].dur + elem.shift[3].dur
              else
                if (min > elem.shift[4].start) and (min <= elem.shift[4].start + elem.shift[4].dur) then
                  Result := min - elem.shift[4].start + elem.shift[1].dur + elem.shift[2].dur + elem.shift[3].dur
                else
                  Result := elem.shift[1].dur + elem.shift[2].dur + elem.shift[3].dur + elem.shift[4].dur;

  Result := Result / 60;

end;

//----------------------------------------------------------------------------//

//returns the number of work hours(of shifts) that have passed already
function GetWHfromMin(elem: PTPGCALElem; min: double): double;
begin
  Result := 0;

  if min < elem.shift[1].start then
    min := elem.shift[1].start
  else if (min > elem.shift[1].start + elem.shift[1].dur) and ((min < elem.shift[2].start) or (elem.shift[2].start = 0)) then
    min := elem.shift[1].start + elem.shift[1].dur
  else if (elem.shift[2].start <> 0) and (min > elem.shift[2].start + elem.shift[2].dur) and ((min < elem.shift[3].start) or (elem.shift[3].start = 0)) then
    min := elem.shift[2].start + elem.shift[2].dur
  else if (elem.shift[3].start <> 0) and (min > elem.shift[3].start + elem.shift[3].dur) and ((min < elem.shift[4].start) or (elem.shift[4].start = 0)) then
    min := elem.shift[3].start + elem.shift[3].dur
  else if (elem.shift[4].start <> 0) and (min > elem.shift[4].start + elem.shift[4].dur) then
    min := elem.shift[4].start;

  if ((min - elem.shift[1].start) > -HALFMINAPPROX) and
     (((elem.shift[1].start + elem.shift[1].dur)-min) > -HALFMINAPPROX) then
    Result := Result + min - elem.shift[1].start
  else
  begin
    Result := Result + elem.shift[1].dur;

    if ((min - elem.shift[2].start) > -HALFMINAPPROX) and
       (((elem.shift[2].start + elem.shift[2].dur)-min) > -HALFMINAPPROX) then
      Result := Result + min - elem.shift[2].start
    else
    begin
      Result := Result + elem.shift[2].dur;

      if ((min - elem.shift[3].start) > -HALFMINAPPROX) and
         (((elem.shift[3].start + elem.shift[3].dur)-min) > -HALFMINAPPROX) then
        Result := Result + min - elem.shift[3].start
      else
      begin
        Result := Result + elem.shift[3].dur;

        if ((min - elem.shift[4].start) > -HALFMINAPPROX) and
           (((elem.shift[4].start + elem.shift[4].dur)-min) > -HALFMINAPPROX) then
          Result := Result + min - elem.shift[4].start
        else
          Result := Result + elem.shift[4].dur
      end
    end
  end;

//  Result := Trunc(Result) / 60
//- fp I'm not sure if it is good
  Result := Round(Result) / 60
end;

//----------------------------------------------------------------------------//

// Get Number of Work hours between 2 dates; the result is
// It is supposed that the required times are work time in date

function TPGCALshift.DiffWH(date1, date2: TDateTime; DownTimeList: TList): double;

  // Given a time in day to check (timeToCheck) and shift details it returns
  // the number of WH availiable in that current time and shift.

begin
  Result := DiffWHNotRounded(date1, date2, DownTimeList);
//  Result := (Round(Result*100))/100;
end;

//----------------------------------------------------------------------------//

// Get Number of Work hours between 2 dates; the result is
// It is supposed that the required times are work time in date

function TPGCALshift.DiffWHNotRounded(date1, date2: TDateTime; DownTimeList: TList): double;

  // Given a time in day to check (timeToCheck) and shift details it returns
  // the number of WH availiable in that current time and shift.

var
  i:          integer;
  minE, maxE: PTPGCALElem;
  tmpDate:    TDateTime;
  WorkingHoursInsideDate1, WorkingHoursInsideDate2 :  Double;
  RecDown:  PTRecCalDownTime;
  SecondsToAdd, Seconds : Integer;
  StartSchedSecond,EndSchedSecond : Integer;
  StartSchedDate , EndSchedDate : TDate;
  DownTimeStart, DownTimeEnd : TDateTime;
  DownTimeWorkingHours : double;
begin
  if date2 < date1 then
  begin
    tmpDate := date1;
    date1   := date2;
    date2   := tmpDate
  end;

  if m_lastIx < Low(m_calendar) then
  begin
    Result := (date2 - date1) * 24;
    Result := (Round(Result*100))/100;
    exit
  end;

  tmpDate := 0.0;

  minE := GetDate(date1, i);
  if minE = nil then
    if i = OutOfMin then
    begin
      // looking before the calendar start
      minE := @m_calendar[0];
      tmpDate := (m_startDate - date1) * 24;
      date1 := m_startDate
    end else
    begin
      // looking after the calendar end
      minE := @m_calendar[m_lastIx];
      tmpDate := (date1 - m_startDate-m_lastIx)* 24 - (24 - minE.JNUMWH);
      date1 := m_startDate + m_lastIx
    end;

  maxE := GetDate(date2, i);

  if maxE = nil then
    if i = OutOfMin then
    begin
      // looking before the calendar start
      maxE := @m_calendar[0];
      tmpDate := tmpDate + (date2 - m_startDate) * 24;
      date2 := m_startDate
    end else
    begin
      // looking after the calendar end
      maxE := @m_calendar[m_lastIx];
      tmpDate := (date2 - m_startDate-m_lastIx)* 24 - (24 - maxE.JNUMWH) - tmpDate;
      date2 := m_startDate + m_lastIx
    end;

  WorkingHoursInsideDate1 := GetWorkHoursTillATimeInADate(minE, date1);
  WorkingHoursInsideDate2 := GetWorkHoursTillATimeInADate(maxE, date2);

  Result := tmpDate +
            ((maxE.JPRGWH - maxE.JNUMWH) + WorkingHoursInsideDate2) -
            ((minE.JPRGWH - minE.JNUMWH) + WorkingHoursInsideDate1);

///////////////// fp
  if Assigned(DownTimeList) then
    for i := 0 to DownTimeList.Count -1 do
    begin
      RecDown := DownTimeList[i];

      if (Date1 >= RecDown.DowntimeEnd) or (Date2 <= RecDown.DowntimeStart) then
        continue;

      if (Date1 >= RecDown.DowntimeStart) and (Date2 <= RecDown.DowntimeEnd) then
      begin
        Result := 0.0;
        exit;
      end;

      if (Date1 <= RecDown.DowntimeStart) and (Date2 >= RecDown.DowntimeEnd) then
      begin
        DownTimeStart := RecDown.DowntimeStart;
        DownTimeEnd := RecDown.DowntimeEnd;
      end
      else
        if (Date1 >= RecDown.DowntimeStart) then
        begin
          DownTimeStart := Date1;
          DownTimeEnd := RecDown.DowntimeEnd;
        end
        else
        begin
          DownTimeStart := RecDown.DowntimeStart;
          DownTimeEnd := Date2;
        end;

      DownTimeWorkingHours := DiffWHNotRounded(DownTimeStart, DownTimeEnd, nil);
      Result := Result - DownTimeWorkingHours;

    end;

  StartSchedDate := TruncToDayNum(date1);
  StartSchedSecond := Trunc((date1 - StartSchedDate) * 24 * 60 * 60);

  EndSchedDate := TruncToDayNum(date2);
  EndSchedSecond := Trunc((date2 - EndSchedDate) * 24 * 60 * 60);

  SecondsToAdd := SecondsToAddForEfficiency(StartSchedDate, EndSchedDate,StartSchedSecond,EndSchedSecond,DownTimeList);

  Result := Result - SecondsToAdd/60/60;

//  Result := (Round(Result*100))/100

end;

//----------------------------------------------------------------------------//

function TPGCALshift.FromShiftToNet(date: TDateTime): TDateTime;
var
  elem: PTPGCALElem;
  i:    integer;
  min:  double;
begin
  elem := GetDate(date, i);
  if not Assigned(elem) then
    Result := date
  else
  begin
    Result := TruncToDayDate(date);
    min := GetWHfromMin(elem, (date - Result) * 24 * 60);
    Result := Result + min / 24
  end
end;

//----------------------------------------------------------------------------//

function TPGCALshift.SecondsToAddForEfficiency(StartSchedDate : TDateTime; EndSchedDate : TDateTime;
                StartSchedSecond, EndSchedSecond : Integer; DownTimeList : TList) : Integer;
var
  iEfficRow,iEfficRowDateTime,iCalendarShift, iDownTime : integer;
  ShiftEffic : PTShiftEffic;
  ShiftEfficStartSecond, ShiftEfficEndSecond : Integer;
  ShiftEfficEffic : double;
  SecondsInRange : double;
  CurrentDate, EndLoopDate : TDate;
  calIndex: integer;
  elem:     PTPGCALElem;
  StartEfficInfluenceSecond, EndEfficInfluenceSecond : Integer;
  DownTimeStartDate, DownTimeEndDate : TDate;
  DownTimeStartSecond, DownTimeEndSecond, DownTimeAffectStartSecond, DownTimeAffectEndSecond : Integer;
  CalShiftStartSecond, CalShiftEndSecond, CalShiftDurSeconds : integer;
  RecDown:  PTRecCalDownTime;
begin
  Result := 0;
  ShiftEfficStartSecond := 0;
  ShiftEfficEndSecond := 0;
  ShiftEfficEffic := 0;

  for IEfficRow := 0 to m_ListShiftEffic.Count - 1 do
  begin
    ShiftEffic := PTShiftEffic(m_ListShiftEffic[IEfficRow]);
    if ShiftEffic.StartDate > EndSchedDate then continue;
    if ShiftEffic.EndDate < StartSchedDate then continue;
    for iEfficRowDateTime := 1 to 4 do
    begin
      case iEfficRowDateTime of
      1: begin
           ShiftEfficStartSecond := ShiftEffic.StartMinute1 * 60;
           ShiftEfficEndSecond := ShiftEffic.EndMinute1 * 60;
           ShiftEfficEffic := ShiftEffic.Effic1 / 100;
         end;
      2: begin
           ShiftEfficStartSecond := ShiftEffic.StartMinute2 * 60;
           ShiftEfficEndSecond := ShiftEffic.EndMinute2 * 60;
           ShiftEfficEffic := ShiftEffic.Effic2 / 100;
         end;
      3: begin
           ShiftEfficStartSecond := ShiftEffic.StartMinute3 * 60;
           ShiftEfficEndSecond := ShiftEffic.EndMinute3 * 60;
           ShiftEfficEffic := ShiftEffic.Effic3 / 100;
         end;
      4: begin
           ShiftEfficStartSecond := ShiftEffic.StartMinute4 * 60;
           ShiftEfficEndSecond := ShiftEffic.EndMinute4 * 60;
           ShiftEfficEffic := ShiftEffic.Effic4 / 100;
         end;
      end;
      if ShiftEfficEffic = 0 then continue;
      if ShiftEfficStartSecond >= ShiftEfficEndSecond then continue;
      SecondsInRange := 0;
      CurrentDate := StartSchedDate - 1;
      if EndSchedDate < ShiftEffic.EndDate then
        EndLoopDate := EndSchedDate
      else
        EndLoopDate := ShiftEffic.EndDate;
      while CurrentDate < EndLoopDate do
      begin
        CurrentDate := CurrentDate + 1;
        if CurrentDate < ShiftEffic.StartDate then continue;
        if (CurrentDate = StartSchedDate) and (StartSchedSecond >= ShiftEfficEndSecond) then continue;
        if (CurrentDate = EndSchedDate) and (EndSchedSecond < ShiftEfficStartSecond) then continue;
        elem := GetDate(CurrentDate, calIndex);
        if not Assigned(elem) then continue;
        if (CurrentDate = StartSchedDate) and (StartSchedSecond >= ShiftEfficStartSecond) then
           StartEfficInfluenceSecond := StartSchedSecond
        else
          StartEfficInfluenceSecond := ShiftEfficStartSecond;
        if (CurrentDate = EndSchedDate) and (EndSchedSecond < ShiftEfficEndSecond) then
           EndEfficInfluenceSecond := EndSchedSecond
        else
          EndEfficInfluenceSecond := ShiftEfficEndSecond;
        for iCalendarShift := 1 to 4 do
        begin
          if elem.shift[iCalendarShift].dur = 0 then continue;
          CalShiftStartSecond := trunc(elem.shift[iCalendarShift].start * 60);
          CalShiftDurSeconds := trunc(elem.shift[iCalendarShift].Dur * 60);
          CalShiftEndSecond := CalShiftStartSecond + CalShiftDurSeconds;
          if StartEfficInfluenceSecond >= CalShiftEndSecond then continue;

         // if EndEfficInfluenceSecond <= CalShiftStartSecond then continue;
          if (EndEfficInfluenceSecond <> 0) and (EndEfficInfluenceSecond <= CalShiftStartSecond) then continue;

          SecondsInRange := SecondsInRange + CalShiftDurSeconds;
          if StartEfficInfluenceSecond > CalShiftStartSecond then
             SecondsInRange := SecondsInRange - StartEfficInfluenceSecond + CalShiftStartSecond;
          if EndEfficInfluenceSecond < CalShiftEndSecond then
             SecondsInRange := SecondsInRange - CalShiftEndSecond + EndEfficInfluenceSecond;
          if Assigned(DownTimeList) then
          begin
            iDownTime := 0;
            while iDownTime <= DownTimeList.Count -1 do
            begin
              RecDown := DownTimeList[iDownTime];
              DownTimeStartDate := TruncToDayNum(RecDown.DowntimeStart);
              DownTimeStartSecond := Trunc((RecDown.DowntimeStart - DownTimeStartDate) * 24 * 60 * 60);
              DownTimeEndDate := TruncToDayNum(RecDown.DowntimeEnd);
              DownTimeEndSecond := Trunc((RecDown.DowntimeEnd - DownTimeEndDate) * 24 * 60 * 60);
              if (DownTimeStartDate > CurrentDate) then break;
              if (DownTimeStartDate = CurrentDate) then
              begin
                if (DownTimeStartSecond > CalShiftEndSecond)
                or (DownTimeStartSecond > EndEfficInfluenceSecond) then
                  break;
              end;
              if (DownTimeEndDate < CurrentDate) then
              begin
                 iDownTime := iDownTime + 1;
                 continue;
              end;
              if (DownTimeEndDate = CurrentDate) then
              begin
                 if (DownTimeEndSecond < CalShiftStartSecond)
                 or (DownTimeEndSecond < StartEfficInfluenceSecond) then
                 begin
                   iDownTime := iDownTime + 1;
                   continue;
                 end;
              end;
              if DownTimeStartDate = CurrentDate then
                 DownTimeAffectStartSecond := DownTimeStartSecond
              else
                 DownTimeAffectStartSecond := 0;
              if StartEfficInfluenceSecond > DownTimeAffectStartSecond then
                 DownTimeAffectStartSecond := StartEfficInfluenceSecond;
              if CalShiftStartSecond > DownTimeAffectStartSecond then
                 DownTimeAffectStartSecond := CalShiftStartSecond;
              if DownTimeEndDate = CurrentDate then
                 DownTimeAffectEndSecond := DownTimeEndSecond
              else
                 DownTimeAffectEndSecond := 999999;
              if EndEfficInfluenceSecond < DownTimeAffectEndSecond then
                 DownTimeAffectEndSecond := EndEfficInfluenceSecond;
              if CalShiftEndSecond < DownTimeAffectEndSecond then
                 DownTimeAffectEndSecond := CalShiftEndSecond;
              if DownTimeAffectEndSecond > DownTimeAffectStartSecond then
                 SecondsInRange := SecondsInRange - DownTimeAffectEndSecond + DownTimeAffectStartSecond;
              if  (DownTimeEndDate = CurrentDate)
              and (DownTimeEndSecond <= CalShiftEndSecond)
              and (DownTimeEndSecond <= EndEfficInfluenceSecond) then
              begin
                 iDownTime := iDownTime + 1;
                 continue;
              end;
              break;
            end;
          end;
        end;
      end;
      if (ShiftEfficEffic <= 1) then
        Result := Result + Trunc(SecondsInRange - (SecondsInRange * ShiftEfficEffic))
      else
        Result := Result - Trunc(SecondsInRange - (SecondsInRange / ShiftEfficEffic));
    end;
  end;

end;

//----------------------------------------------------------------------------//

procedure TPGCALshift.StartIterator(lt, rt: TDateTime);
begin
  inherited StartIterator(lt, rt);

  m_ixElem := -1;
  m_calElem := GetDate(m_lt, m_ixElem);
  lt := m_lt;
  while Assigned(m_calElem) do
  begin
    Dec(m_ixElem);
    if (m_ixElem = OutOfMax) or (m_ixElem = OutOfMin) then break;
    m_calElem := GetElem(m_ixElem);
    Assert(Assigned(m_calElem));
    if m_calElem.JNUMWH > 0 then break
  end;

  if (m_ixElem = OutOfMin) and (GetRefDate < rt) then
  begin
    m_ixElem  := 0;
    m_calElem := GetElem(m_ixElem)
  end;

  m_shiftIndex := 0;
  m_oldRt := 0;
  GetNext(lt, rt)
end;

//----------------------------------------------------------------------------//

function TPGCALshift.GetNext(var lt, rt: TDateTime): boolean;
label
  Restart;
var
  swp: TDateTime;
begin
  Result := false;
  if not Assigned(m_calElem) then exit;

ReStart:

  // find where the shape starts
  repeat
    if m_shiftIndex = 4 then
      m_shiftIndex := 0
    else
    begin
      Inc(m_shiftIndex);
      if m_calElem.shift[m_shiftIndex].dur = 0 then continue
    end;

    if m_shiftIndex = 0 then
    begin
      // step to the next day
      Inc(m_ixElem);
      m_calElem := GetElem(m_ixElem);
      if not Assigned(m_calElem) then exit
    end
  until (m_shiftIndex > 0) and (m_calElem.shift[m_shiftIndex].dur > 0);

  if m_oldRt > m_rt then
  begin
    Result := false;
    exit
  end;

  lt := RoundDate(m_startDate + m_ixElem + m_calElem.shift[m_shiftIndex].start / 60 / 24);
  rt := RoundDate(lt + m_calElem.shift[m_shiftIndex].dur / 60 / 24);

  // if the two shifts are connected
  if m_oldRt = lt then
  begin
    m_oldRt := rt;
    goto ReStart
  end;

  swp     := lt;
  lt      := m_oldRt;
  m_oldRt := rt;
  rt      := swp;

  Result := true
end;

// ----------------------------------------------------------------------------

function TPGCALshift.GetNextEffic(var lt, rt, NextShift : TDateTime;
                             var SH1_start, SH1_End: TDateTime; var Effic1: double; var SH2_start,
                             SH2_End: TDateTime; var Effic2: double; var SH3_start, SH3_End: TDateTime;
                             var Effic3: double; var SH4_start, SH4_End: TDateTime; var Effic4: double
                                          ): boolean;
var
  I : Integer;
  Hour, Min, Sec, MSec: Word;
  EfficFoundInTheDay, EfficFoundInTheScreen : Boolean;
begin
  Result := false;
  Effic1 := 0;
  Effic2 := 0;
  Effic3 := 0;
  Effic4 := 0;

  SH1_start := 0;
  SH1_End   := 0;
  SH2_start := 0;
  SH2_End   := 0;
  SH3_start := 0;
  SH3_End   := 0;
  SH4_start := 0;
  SH4_End   := 0;

  if Nextshift > m_Rt then exit;

  EfficFoundInTheDay := false;
  EfficFoundInTheScreen := false;

  for I := 0 to m_ListShiftEffic.Count - 1 do
  begin
    if  (Nextshift >= PTShiftEffic(m_ListShiftEffic[I]).StartDate)
    and (Nextshift <= PTShiftEffic(m_ListShiftEffic[I]).EndDate) then
    begin
      EfficFoundInTheDay := true;
      EfficFoundInTheScreen := true;
      break;
    end;
    if  (PTShiftEffic(m_ListShiftEffic[I]).EndDate < m_lt) then continue;
    if  (PTShiftEffic(m_ListShiftEffic[I]).StartDate > m_Rt) then continue;
    EfficFoundInTheScreen := true;
  end;

  if not EfficFoundInTheScreen then exit;

  if EfficFoundInTheDay then
  begin
    DecodeTime(PTShiftEffic(m_ListShiftEffic[I]).StartMinute1/24/60, Hour, Min, Sec, MSec);
    SH1_start := Nextshift + EncodeTime(Hour, Min, Sec, MSec);
    DecodeTime(PTShiftEffic(m_ListShiftEffic[I]).EndMinute1/24/60, Hour, Min, Sec, MSec);
    SH1_End   := Nextshift + EncodeTime(Hour, Min, Sec, MSec);
    Effic1    := PTShiftEffic(m_ListShiftEffic[I]).Effic1;

    DecodeTime(PTShiftEffic(m_ListShiftEffic[I]).StartMinute2/24/60, Hour, Min, Sec, MSec);
    SH2_start := Nextshift + EncodeTime(Hour, Min, Sec, MSec);
    DecodeTime(PTShiftEffic(m_ListShiftEffic[I]).EndMinute2/24/60, Hour, Min, Sec, MSec);
    SH2_End   := Nextshift + EncodeTime(Hour, Min, Sec, MSec);
    Effic2    := PTShiftEffic(m_ListShiftEffic[I]).Effic2;

    DecodeTime(PTShiftEffic(m_ListShiftEffic[I]).StartMinute3/24/60, Hour, Min, Sec, MSec);
    SH3_start := Nextshift + EncodeTime(Hour, Min, Sec, MSec);
    DecodeTime(PTShiftEffic(m_ListShiftEffic[I]).EndMinute3/24/60, Hour, Min, Sec, MSec);
    SH3_End   := Nextshift + EncodeTime(Hour, Min, Sec, MSec);
    Effic3    := PTShiftEffic(m_ListShiftEffic[I]).Effic3;

    DecodeTime(PTShiftEffic(m_ListShiftEffic[I]).StartMinute4/24/60, Hour, Min, Sec, MSec);
    SH4_start := Nextshift + EncodeTime(Hour, Min, Sec, MSec);
    DecodeTime(PTShiftEffic(m_ListShiftEffic[I]).EndMinute4/24/60, Hour, Min, Sec, MSec);
    SH4_End   := Nextshift + EncodeTime(Hour, Min, Sec, MSec);
    Effic4    := PTShiftEffic(m_ListShiftEffic[I]).Effic4;
  end;

  result := true;
  Nextshift := Nextshift + 1;

end;

// ----------------------------------------------------------------------------

{$ifdef DEVELOP}
procedure CalShiftTestDiffWH(str: TStringList; calClass: TPGCalObjClass);
var
  i:        integer;
  dt1, dt2: TDateTime;
  pgcal:    TPGCALshift;
  diff:     double;
begin
  pgcal := TPGCALshift(ObjPGCAL_ByKey('GEN', calClass));
  str.Add('calendar start date : ' + DateTimeToStr(pgcal.GetRefDate) );
  str.Add('calendar end date   : ' + DateTimeToStr(pgcal.GetLastDate) );

  dt1 := StrToDateTime('16/09/2002');

  dt2 := dt1;
  dt1 := dt1 + 12/24;
  str.Add('comparison starting date : ' + DateTimeToStr(dt1) );
  for i := 0 to 100 do
  begin
    dt2 := dt2 + 1 / 24;
    diff := pgcal.DiffWH(dt1, dt2, nil);
    str.Add(DateTimeToStr(dt2) + ' # ' + FloatToStr(diff))
  end
end;

// ----------------------------------------------------------------------------

procedure CalShiftTestNormalize(str: TStringList; calClass: TPGCalObjClass);
var
  i:        integer;
  dt1, dt2: TDateTime;
  pgcal:    TPGCALshift;
begin
  pgcal := TPGCALshift(ObjPGCAL_ByKey('GEN', calClass));
  str.Add('calendar start date : ' + DateTimeToStr(pgcal.GetRefDate) );
  str.Add('calendar end date   : ' + DateTimeToStr(pgcal.GetLastDate) );

  dt1 := StrToDateTime('23/09/2002') - 2 / 24;
  str.Add('comparison starting date : ' + DateTimeToStr(dt1) );
  str.Add('forward normalization');

  for i := 0 to 200 do
  begin
    dt1 := dt1 + 1 / 24;
    dt2 := dt1;
    pgcal.NormalizeDate(dt2, ntNormalizeForward);
    str.Add(DateTimeToStr(dt1) + ' # ' + DateTimeToStr(dt2))
  end
end;

// ----------------------------------------------------------------------------

procedure CalShiftTestOfsByWH(str: TStringList; calClass: TPGCalObjClass);
var
  i:        integer;
  dt1, dt2: TDateTime;
  pgcal:    TPGCALshift;
  hrs:      double;
begin
  pgcal := TPGCALshift(ObjPGCAL_ByKey('GEN', calClass));
  str.Add('calendar start date : ' + DateTimeToStr(pgcal.GetRefDate) );
  str.Add('calendar end date   : ' + DateTimeToStr(pgcal.GetLastDate) );

  dt1 := StrToDateTime('20/09/2002') - 10 / 24;

  str.Add('comparison starting date : ' + DateTimeToStr(dt1) );
  str.Add('diff WH');

  hrs := 0.0;
  for i := 0 to 100 do
  begin
    hrs := hrs + 3.0;
    if pgcal.OfsByWH(hrs, false, dt1, dt2, nil) then
      str.Add('+ hours ' + FloatToStr(hrs) + ' # ' + DateTimeToStr(dt2))
    else
      str.Add(' errore ')
  end
end;
{$endif}

//----------------------------------------------------------------------------//

end.
