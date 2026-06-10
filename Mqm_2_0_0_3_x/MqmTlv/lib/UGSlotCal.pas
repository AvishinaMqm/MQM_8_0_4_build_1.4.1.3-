unit UGSlotCal;

(*
  DEFINITIONS:
  - calendar  : it represents a continuous finite interval of time; it is an
                ordered set of contiguous intervals (slots).
  - slot      : it is the element of the calendar. Each slot is made of one
                or more days. Each slot contains an amount of hours. Each slot
                is identified by a slot id, an integer.
  - slotstamp : it is the mean to identify the time locked by an external
                interval, it can be either initial or final; it is composed of
                a slot id and a number of hours.

 RULES:
  - slot id : inside a calendar the slot ids must be a coninuous set starting
              from zero; except for the 0 slot and the last slot for any slot
              id must exist "slot id + 1" and "slot id - 1"
  - initial slotstamp : the number of hours can be zero but not equal to the
                        the number of hours of the slot
  - final slotstamp   : the number of hours cannot be zero but can be equal to
                        the number of hours of the slot
*)

interface

uses Classes;

type

  SslotId = integer;

  TSlotCal = class(TObject)
  public
    function GetCode: string;
    function GetDescr: string;
    function GetClass: string; virtual; abstract;
    function GetType: string; virtual; abstract;

    function GetSlotNum(): integer; virtual; abstract;

    function  GetStartDay(): TDateTime; virtual; abstract;
    function  GetEndDay(): TDateTime; virtual; abstract;
    function  GetSlotDurDays(prd: integer): integer; virtual; abstract;
    procedure GetSlotDataLimits(prd: integer; out dtFrom, dtTo: TDateTime; out lngDsc, midDsc, shtDsc: string); virtual; abstract;
    function  CalcSlotFromDate(date: TDateTime): integer; virtual; abstract;
    function  GetSlotCrossingBegin(date: TDateTime): integer; virtual; abstract;
    function  GetSlotCrossingEnd(date: TDateTime): integer; virtual; abstract;

  protected
    m_code:  string;
    m_descr: string;

    constructor CrtSlotCal;
  end;

  TSCbaseList = class(TSlotCal)
  public
    constructor CrtSCbaseList;
    destructor Destroy; override;

    function GetClass: string; override;
    function GetType: string; override;
    function GetSlotNum(): integer; override;

    function  GetStartDay(): TDateTime; override;
    function  GetEndDay(): TDateTime; override;
    function  GetSlotDurDays(prd: integer): integer; override;
    procedure GetSlotDataLimits(prd: integer; out dtFrom, dtTo: TDateTime; out lngDsc, midDsc, shtDsc: string); override;
    function  CalcSlotFromDate(date: TDateTime): integer; override;

    function   GetSlotCrossingBegin(date: TDateTime): integer; override;
    function   GetSlotCrossingEnd(date: TDateTime): integer; override;

    function   LocalLoad(code: string; endDtIn: integer): boolean;
  private
    m_seedDate: TDateTime;
    m_prdList:  TList;

    procedure Organize;
    procedure ClearList;
    function  AddPeriod(dur: integer; lngDsc, midDsc, shtDsc: string): integer;
  end;

  function GetCalList(sl: TStrings): boolean;
  function GetSlotLimitDate(SlotScale : string; StartDate : TDateTime; var SlotStart : TDateTime; var SlotEnd : TDateTime) : boolean;

implementation

uses SysUtils, DateUtils, gnugettext, Winapi.Windows;

var
  m_ListCalSlot : TList;

type

  TPrdRecBase = record
    dur:     integer;
    totDur:  integer;
    lngDsc:  string;
    midDsc:  string;
    shtDsc:  string;
  end;
  PTPrdRecBase = ^TPrdRecBase;

{ TSlotCal }

constructor TSlotCal.CrtSlotCal;
begin
  m_code := '';
end;

{ --------------------------------------------------------------------- }

function TSlotCal.GetCode: string;
begin
  Result := m_code;
end;

{ --------------------------------------------------------------------- }

function TSlotCal.GetDescr: string;
begin
  Result := m_descr;
end;

{ TSCbaseList }

function TSCbaseList.AddPeriod(dur: integer; lngDsc, midDsc, shtDsc: string): integer;
var
  prd: PTPrdRecBase;
begin
  New( prd );
  prd^.dur   := dur;
  prd^.lngDsc := lngDsc;
  prd^.midDsc := midDsc;
  prd^.shtDsc := shtDsc;
  Result := m_prdList.Add( prd );
end;

{ --------------------------------------------------------------------- }

constructor TSCbaseList.CrtSCbaseList;
begin
  inherited CrtSlotCal;
  m_prdList := TList.Create;
end;

{ --------------------------------------------------------------------- }

destructor TSCbaseList.Destroy;
begin
  ClearList;
  m_prdList.Free;
  inherited Destroy;
end;

{ --------------------------------------------------------------------- }

procedure TSCbaseList.ClearList;
var
  i:   integer;
  prd: PTPrdRecBase;
begin
  for i := 0 to m_prdList.Count - 1 do
  begin
    prd := PTPrdRecBase(m_prdList.Items[i]);
    Dispose( prd );
  end;
  m_prdList.Clear
end;

{ --------------------------------------------------------------------- }

function TSCbaseList.GetEndDay: TDateTime;
begin
  Result := m_seedDate + PTPrdRecBase(m_prdList.Items[m_prdList.Count-1]).totDur;
end;

{ --------------------------------------------------------------------- }

function TSCbaseList.CalcSlotFromDate(date: TDateTime): integer;
var
  i, days: integer;
  prd: PTPrdRecBase;
begin
  if date < m_seedDate then
  begin
    Result := -1;
    exit;
  end;

  days := Trunc(date-m_seedDate);

  for i := 0 to m_prdList.Count - 1 do
  begin
    prd := PTPrdRecBase(m_prdList.Items[i]);
    if prd^.totDur > days then
    begin
      Result := i - 1;
      exit;
    end
  end;
  Result := -1;
end;

{ --------------------------------------------------------------------- }

function TSCbaseList.GetSlotCrossingBegin(date: TDateTime): integer;
begin
  Result := CalcSlotFromDate(date);
  if (Result = -1) and (GetStartDay >= date) then
    Result := 0;
end;

{ --------------------------------------------------------------------- }

function TSCbaseList.GetSlotCrossingEnd(date: TDateTime): integer;
begin
  Result := CalcSlotFromDate(date);
  if (Result = -1) and (GetEndDay <= date) then
    Result := GetSlotNum-1;
end;

{ --------------------------------------------------------------------- }

procedure TSCbaseList.GetSlotDataLimits(prd: integer; out dtFrom, dtTo: TDateTime; out lngDsc, midDsc, shtDsc: string);
var
  pPrd: PTPrdRecBase;
begin
  if prd < 0 then prd := 0
  else if (prd > m_prdList.Count -1) then prd := m_prdList.Count -1;

  pPrd := PTPrdRecBase(m_prdList.Items[prd]);
  dtFrom := m_seedDate + pPrd.totDur;
  dtTo   := dtFrom + pPrd.dur; //- 1;// (1/24/60/60);// - 1;
//  dtTo   := dtTo + (23 * 60 + 59)/(60*24);
//  dtTo   := dtTo + (23 * 60 + 60)/(60*24);  // avi

  lngDsc := pPrd.lngDsc;
  midDsc := pPrd.midDsc;
  shtDsc := pPrd.shtDsc;
end;

{ --------------------------------------------------------------------- }

function TSCbaseList.GetSlotDurDays(prd: integer): integer;
begin
  Result := PTPrdRecBase(m_prdList.Items[prd]).dur;
end;

{ --------------------------------------------------------------------- }

function TSCbaseList.GetSlotNum: integer;
begin
  Result := m_prdList.Count;
end;

{ --------------------------------------------------------------------- }

function TSCbaseList.GetStartDay: TDateTime;
begin
  Result := m_seedDate;
end;

{ --------------------------------------------------------------------- }

function TSCbaseList.GetType: string;
begin
  Result := 'Slot list';
end;

{ --------------------------------------------------------------------- }

function TSCbaseList.GetClass: string;
begin
  Result := 'Base cal';
end;

{ --------------------------------------------------------------------- }

procedure TSCbaseList.organize;
var
  i, totDur: integer;
  prd:       PTPrdRecBase;
begin
  totDur := 0;
  for i := 0 to m_prdList.Count - 1 do
  begin
    prd := PTPrdRecBase(m_prdList.Items[i]);
    prd.totDur := totDur;
    totDur := totDur + prd.dur;
  end;
end;

{ --------------------------------------------------------------------- }

function GetFirstDayOfWeekLocaleInformation: String;
var pcLCA: Array[0..20] of Char;
begin
  GetLocaleInfo(LOCALE_SYSTEM_DEFAULT,LOCALE_IFIRSTDAYOFWEEK,pcLCA,19);
  Result := pcLCA;
end;

function GetSystemFirstDayOfWeekIndex: Integer;
var
  Buf: array[0..7] of Char;
begin
  if GetLocaleInfo(LOCALE_USER_DEFAULT, LOCALE_IFIRSTDAYOFWEEK, Buf, SizeOf(Buf)) > 0 then
    Result := StrToIntDef(Buf, -1)
  else
    Result := -1;
end;

function TSCbaseList.LocalLoad(code: string; endDtIn: integer): boolean;
type
  TCalEnum = (cl_daily, cl_weekly, cl_monthly, cl_varble, cl_vvarble);

const
  arrNames : array[0..4] of string = (
    'daily', 'weekly', 'monthly', 'variable', 'very variable'
  );

var
  dtStart, dtEnd: TDateTime;
  currDt: integer;
  lngDsc, midDsc, shtDsc, str : string;
  cal : TCalEnum;
  dur : integer;
  DayNumber : integer;
begin

  if      code = 'CL_DAILY'    then cal := cl_daily
  else if code = 'CL_WEEKLY'   then cal := cl_weekly
  else if code = 'CL_MONTHLY'  then cal := cl_monthly
  else if code = 'CL_VARBLE'   then cal := cl_varble
  else (*code = 'CL_VVARBLE'*)      cal := cl_vvarble;

  dtStart := Trunc(now - DaysInYear(YearOf(Now))); //StrToDateTime('01/01/2009'); //
  dtEnd := EndOfAYear(YearOf(Today)+2);

  if cal = cl_weekly then
    m_seedDate := StartOfTheWeek(dtStart)
  else if cal = cl_monthly then
    m_seedDate := StartOfTheMonth(dtStart)
  else
  m_seedDate := dtStart;

  DayNumber := GetSystemFirstDayOfWeekIndex;

  if DayNumber = 6 then  //sunday first day of week
  begin
    if cal = cl_weekly then
      m_seedDate := m_seedDate-1;
  end
  else if DayNumber = 5 then  //saturday first day of week
  begin
    if cal = cl_weekly then
      m_seedDate := m_seedDate-2;
  end;


  //  GetSystemFirstDayOfWeek


 // if GetFirstDayOfWeek

 { if GetFirstDayOfWeekLocaleInformation = '0' then  //monday first day of week
  begin

  end
  else   //sunday first day of week
  begin
     if cal = cl_weekly then
      m_seedDate := m_seedDate-1;
  end;        }


  m_code := code;
  m_descr := _(arrNames[Ord(TCalEnum(cal))]);

  if cal = cl_weekly then dur := 7
  else dur := 1;

  currDt := Trunc(dtStart);
  repeat
    lngDsc := FormatDateTime('ddd dd/mm/yyyy', currDt);
    midDsc := FormatDateTime('dd/mm', currDt);
    shtDsc := FormatDateTime('dd', currDt);

    case cal of
      cl_weekly  :
      begin
        if WeekOfTheYear(currDt) <> 1 then begin
          lngDsc := _('Week') + ' ' + IntToStr(WeekOf(currDt));
          str := '/' + FormatDateTime('yyyy', currDt);
        end
        else begin
          lngDsc := _('Week') + ' ' + IntToStr(WeekOf(currDt));
          str := '/' + FormatDateTime('yyyy', currDt+20);
        end;
        lngDsc := lngDsc + str;
        midDsc := _('Week') + ' ' + IntToStr(WeekOf(currDt));
        shtDsc := IntToStr(WeekOf(currDt));
      end;
      cl_monthly :
        begin
          dur := DaysInAMonth(YearOf(currDt), MonthOf(currDt));
          lngDsc := FormatDateTime('mmmm yyyy', currDt);
          midDsc := FormatDateTime('mmm yy', currDt);
          shtDsc := FormatDateTime('mm/yy', currDt);
        end;
      cl_varble  :
        begin
          if MonthOf(CurrDt) = (MonthOf(Today) + 2) then
          begin
            dur := DaysInAMonth(YearOf(currDt), MonthOf(currDt));
            lngDsc := FormatDateTime('mmm', currDt);
          end else
          if MonthOf(CurrDt) = (MonthOf(Today) + 1) then
          begin
            dur := 7;
            lngDsc := _('Week') + ' ' + IntToStr(WeekOf(currDt));
          end else
          if (MonthOf(CurrDt) = MonthOf(Today)) and
             (WeekOf(currDt) = WeekOf(Today) + 2) then
          begin
            dur := 7;
            lngDsc := _('Week') + ' ' + IntToStr(WeekOf(currDt));
          end else
            dur := 1;
        end;
    end;

    AddPeriod(dur, lngDsc, midDsc, shtDsc);
    Inc(currDt, dur);

  until (currDt > dtEnd);

  Organize;
  Result := true;
end;

{ --------------------------------------------------------------------- }

procedure IniCalSlotList;
var
  calBase : TSCbaseList;
begin
  calBase := TSCbaseList.CrtSCbaseList;
  calBase.LocalLoad('CL_DAILY', 0);
  m_ListCalSlot.Add(calBase);

  calBase := TSCbaseList.CrtSCbaseList;
  calBase.LocalLoad('CL_WEEKLY', 0);
  m_ListCalSlot.Add(calBase);

  calBase := TSCbaseList.CrtSCbaseList;
  calBase.LocalLoad('CL_MONTHLY', 0);
  m_ListCalSlot.Add(calBase);
end;

{ --------------------------------------------------------------------- }

function GetCalList(sl: TStrings): boolean;
var
  i, itm: integer;
  cal: TSlotCal;
begin
  for i := 0 to m_ListCalSlot.Count - 1 do
  begin
      cal := TSlotCal(m_ListCalSlot.Items[i]);
      itm := sl.Add(_(cal.GetDescr));
      sl.Objects[itm] := cal;
  end;
  Result := true;
end;

{ --------------------------------------------------------------------- }

function GetSlotLimitDate(SlotScale : string; StartDate : TDateTime; var SlotStart : TDateTime; var SlotEnd : TDateTime) : boolean;
var
  cal: TSlotCal;
  Scale : integer;
  DamyDesc : string;
begin
  if SlotScale = 'CL_DAILY' then
    cal := TSlotCal(m_ListCalSlot.Items[0])
  else if SlotScale = 'CL_WEEKLY' then
    cal := TSlotCal(m_ListCalSlot.Items[1])
  else if SlotScale = 'CL_MONTHLY' then
    cal := TSlotCal(m_ListCalSlot.Items[2]);
  Scale := cal.GetSlotCrossingBegin(StartDate);
  cal.GetSlotDataLimits(Scale, SlotStart, SlotEnd,DamyDesc, DamyDesc, DamyDesc);
end;

{ --------------------------------------------------------------------- }

procedure FreeCalSlotList;
var
  I : Integer;
begin
  for I := m_ListCalSlot.Count -1 downto 0 do
     TSlotCal(m_ListCalSlot[I]).Free;
  m_ListCalSlot.Free;
end;

{ --------------------------------------------------------------------- }

Initialization
  m_ListCalSlot := TList.create;
  IniCalSlotList;

finalization

  FreeCalSlotList;

end.
