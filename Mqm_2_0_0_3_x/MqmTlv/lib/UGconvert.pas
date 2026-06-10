unit UGconvert;

interface

uses
  SysUtils;

  function TimDateToDateTime(const TimDate: Double): TDateTime;
  function TimDateTimeToDateTime(const TimDateTime: Double): TDateTime;
  function DateTimeToTimDate(const DateTime: TDateTime): Double;
  function DateTimeToTimDateTime(const DateTime: TDateTime): Double;

  function CheckKey(Key: string): string;

implementation

//----------------------------------------------------------------------------//

function TimDateToDateTime(const TimDate: Double): TDateTime;
var
  MyTimdate,
  MyYear,
  MyMonth,
  MyDay:      Longint;
begin
  if TimDate = 0 then
    Result := 0
  else
  begin
    // TimDate is AAAAMMDD
    MyTimDate := trunc(TimDate);
    MyYear  := MyTimDate div 10000;
    MyMonth := MyTimDate - (MyYear * 10000);
    MyMonth := MyMonth div 100;
    MyDay   := MyTimDate - (MyYear * 10000) - (MyMonth * 100);
    Result  := EncodeDate(MyYear,MyMonth,MyDay)
  end
end;

//----------------------------------------------------------------------------//

function TimDateTimeToDateTime(const TimDateTime: Double): TDateTime;
var
  TimDateWk,
  TimTimeWk:  Double;    // max longint is
  TimDateWk1: longint;   //     2147483647
  MyTimTime:  longint;   //     AAAAMMDDHHMM   Minutes ?
  MyHour,
  MyMin:      longint;
  TimDate:    TDateTime;
  AddDay:     longint;
begin
  if TimDateTime = 0 then
    Result := 0
  else
  begin
    // TimDateTime is AAAAMMDDHHMM
    TimDateWk := TimDateTime / 10000; // cut HHMM  Rounding is acceptable because trunc
    TimDateWk1:= trunc(TimDateWk);
    TimDateWk := TimDateWk1;          // to have double aritmetich
    TimTimeWk := TimDateTime - (TimDateWk * 10000);
    MyTimTime := trunc(TimTimeWk);
    MyHour    := MyTimTime div 100;
    MyMin     := MyTimTime - (MyHour * 100);
    TimDate   := TimDateToDateTime(TimDateWk);

    // normalizing data for the encodetime
    while MyMin >= 60 do
    begin
      MyMin  := MyMin - 60;
      MyHour := MyHour + 1
    end;

    AddDay := 0;
    while MyHour >= 24 do
    begin
      MyHour := MyHour - 24;
      AddDay := AddDay + 1
    end;

    Result := TimDate + AddDay + EncodeTime(MyHour,MyMin,0,0)
  end
end;

//----------------------------------------------------------------------------//

function DateTimeToTimDate(const DateTime: TDateTime): Double;
var
  Year,
  Month,
  Day:      Word;
begin
  // TimDate is AAAAMMDD
  DecodeDate(DateTime,Year,Month,Day);  // All 0 if DateTime = 0
  Result := Year * 10000.0 + Month*100.0 + Day
end;

//----------------------------------------------------------------------------//

function DateTimeToTimDateTime(const DateTime: TDateTime): Double;
var
  Year,
  Month,
  Day,
  Hour,
  Min,
  Sec,
  MSec:      Word;
begin
  // TimDate is AAAAMMDDHHMM
  if DateTime = 0 then
    Result := 0
  else
  begin
    DecodeDate(DateTime,Year,Month,Day);  // All 0 if DateTime = 0
    DecodeTime(DateTime,Hour,Min,Sec,MSec);  // All 0 if DateTime = 0
    Result := Year * 100000000.0 + Month*1000000.0 + Day*10000.0 + Hour*100.0 + Min
  end
end;

//----------------------------------------------------------------------------//

function CheckKey(Key: string): string;
begin
  if length(Key) = 0 then
    Result := ' '
  else
    Result := Key;
end;

//----------------------------------------------------------------------------//
end.
