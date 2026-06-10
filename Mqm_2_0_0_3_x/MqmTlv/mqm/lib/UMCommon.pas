unit UMCommon;

Interface

uses
  Comctrls, Classes, Vcl.Themes, StrUtils, IOUtils, System.UITypes;

type

  TDndArchiveName = (TD_AS_400, TD_Db2, TD_Oracle, TD_Interbase, TD_Db2OnAs400);

  TMqmProgBar = class(TTrackBar)
    constructor Create (AOwner : TComponent);
    procedure SetPosition(Pos: integer);
    procedure SetMax(NewMax: integer);
  end;
{
  function MQMformatDateTime(dt: TDateTime): string;
  function MQMdecodeDate(dts: string): TDateTime;
  function MQMdecodeDateTime(dts: string): TDateTime;
}
  function SafeFloat(const V: Double): Double;
  function GetSqlDate(DateTime : TDateTime) : string;
  function WHERE_IDF_Condition(Field_ID : string) : string;
  function AND_IDF_Condition(Field_ID : string) : string;
  function getNumericValueOf(data: String): String;
  function getFormattedDateFromString(dateToConvert: String): String;
  function MQMformatDate(dt: TDateTime): string;
  function FormatDuration(totMin: double; OnlyHM: boolean): string;
  function FormatQuantity(Qty: double; Decimals: integer): string;
  function FormatQtyWithoutZeros(Qty: double; Decimals: integer): string;
  function RoundDblToDbl(val: Double; decimals: Word): Double;

  function CheckRoundUp(Value: Double) : Double;
  Function RoundingUserDefineDecaimalPart(FloatNum: Double; NoOfDecPart: integer): Double;
  function SqlDeleteLog(table, field: String): String;
  function AddDaysToDate(DateTime : TDateTime; Days : Double) : TDateTime;
  procedure RoundDateTime(var DateTime : TDateTime);
  function GetMonthDayFormat(Value : Word) : string;
  function GetDateTimeFormatForStr(YYYYMMDDHHMM : string) : TDateTime;
  function GetDateFormatForStr(YYYYMMDD : string) : TDateTime;
  function GetDateFormatForTDateTime(DateTime : TDateTime) : TDateTime;
  function getLimitedDecimalsForDouble(Number : double; NumOfDec : Integer) : double;
  function ConvertDateFormatFrom(dateToConvert: TDateTime; DateFrom : TDndArchiveName): String;
  function ConvertDateFormatTo(dateToConvert: TDateTime; DateTo : TDndArchiveName): String;
  function ConvertDateFormatDb2Oracle(dateToConvert: TDateTime; Include_To_Date : boolean; DownLoadTo : boolean): String;
  function ConvertDateFormatMQM(dateToConvert: TDateTime): String;
  function StringListSortByLowDate(List: TStringList; Index1, Index2: Integer): Integer;
  function FormatDateMMDDYYYYWithSlash(DateTime : TDateTime) : String;
  function ConvertDateFormatToYYYYMMDD(dateToConvert: TDate; GetDownloadTo: Integer): String;
  function setStringLengthTo(str: String; maxLength: integer; leftToRight: boolean = true; defChar: String = ' '): String;
  function addUpFields(firstField: String; secondField: String; isInteger: boolean): String;
  function getMinimumDate(firstDate: TDateTime; secondDate: TDateTime): TDateTime;
  function getMaximumDate(firstDate: TDateTime; secondDate: TDateTime): TDateTime;
  function FDOM(Date: TDateTime): TDateTime;
  function LDOM(Date: TDateTime): TDateTime;
  function FirstDayOfWeekOf(d: TDateTime; foreword : boolean): TDateTime;
  function DayOfWeekName(D : TDateTime) : string;
  procedure DeleteFilesOlderThan;
  procedure WriteLogConnectionRepair(LogStr : TStringList; IsClient : boolean; During_Save_Or_During_Refresh : string);
  function BGRtoRGB(const C: TColor): TColor;
  function NumberOfDecimalRounding(NumOfDecimal : integer) : integer;
  function GetLocalIP: string;
  function UTCNow: TDateTime;

implementation

uses
  gnugettext,
  DateUtils,
  SysUtils,
  UMGlobal,
  UMSrvConfig,
  Winsock,
  Math;

const
  FDOW = 2;     { index of first day of week: Monday. IS-8601 }

// -------------------------------------------------------------------------- //

function SafeFloat(const V: Double): Double;
begin
  if IsNan(V) or IsInfinite(V) then
    Result := 0                 // or any fallback you want
  else if (V > 1e12) then       // prevent overly large values
    Result := 1e12
  else if (V < -1e12) then
    Result := -1e12
  else
    Result := V;
end;

//----------------------------------------------------------------------------//

function GetSqlDate(DateTime : TDateTime) : string;
var
  year: Word;
  month: Word;
  day: Word;
  monthStr,dayStr, DateStr : string;
begin
  DecodeDate(DateTime, year, month, day);
  monthStr := IntToStr(month);
  dayStr   := IntToStr(Day);

  if Length(monthStr) = 1 then
    monthStr := '0' + monthStr;

  if Length(DayStr) = 1 then
    DayStr := '0' + DayStr;

  DateStr := QuotedStr(IntToStr(year) + '-' + monthStr + '-' + DayStr);
  Result := '{d' + DateStr + '}';
end;

// -------------------------------------------------------------------------- //

function WHERE_IDF_Condition(Field_ID : string) : string;
begin
  Result := ' WHERE ' + Field_ID + ' = ' + IniAppGlobals.Identifier + ' ';
  //Result := ' WHERE ' + Field_ID + ' = ' + QuotedStr(IniAppGlobals.Identifier) + ' ';
end;

// -------------------------------------------------------------------------- //

function AND_IDF_Condition(Field_ID : string) : string;
begin
  Result := ' AND ' + Field_ID + ' = ' + IniAppGlobals.Identifier + ' ';
  //Result := ' AND ' + Field_ID + ' = ' + QuotedStr(IniAppGlobals.Identifier) + ' ';
end;

// -------------------------------------------------------------------------- //

function StringListSortByLowDate(List: TStringList; Index1, Index2: Integer): Integer;
var
  First: string;
  Second: string;
  DateTime1, DateTime2 : TDateTime;
begin
  First := List[Index1];
  Second := List[Index2];
  DateTime1 := StrToDateTime(First);
  DateTime2 := StrToDateTime(Second);
  if DateTime1 < DateTime2 then
    Result := -1
  else if DateTime1 > DateTime2 then
    Result := 1
  else Result := 0;
end;

//----------------------------------------------------------------------------//

function FormatDuration(totMin: double; OnlyHM: boolean): string;
var
  dd, hh, mm: integer;
  AbsTotMin: integer;
begin
  if totMin = 0 then
  begin
    Result := '0';
    exit
  end;
  AbsTotMin := Ceil(Abs(totMin));

  if onlyHM then
  begin
    hh := Trunc(AbsTotMin / 60);
    mm := Trunc(AbsTotMin - hh * 60);
    if hh > 0 then
      Result := Format('%d ' + _('h') + ' %d ' + _('m'), [hh,mm]) + ' '
    else
      if mm > 0 then
        Result := Format('%d ' + _('m'), [mm]) + ' ';
  end else
  begin
    dd := Trunc(AbsTotMin / 24 / 60);
    hh := Trunc((AbsTotMin - dd*24*60) / 60);
    mm := Trunc(AbsTotMin - dd*24*60 - hh * 60);
    if dd > 0 then
      Result := Format('%d '+ _('d') + ' %d ' + _('h') + ' %d ' + _('m'), [dd,hh,mm]) + ' '
    else
      if hh > 0 then
        Result := Format('%d ' + _('h') + ' %d ' + _('m'), [hh,mm]) + ' '
      else
        if mm > 0 then
          Result := Format('%d ' + _('m'), [mm]) + ' ';
  end;

  if totMin < 0 then
    Result := '- ' + Result;
end;

//----------------------------------------------------------------------------//

function getNumericValueOf(data: String): String;
begin
  if ( Trim(data) <> '' ) then
    Result := Trim(data)
  else
    Result := '0';
end;

//----------------------------------------------------------------------------//

function getFormattedDateFromString(dateToConvert: String): String;
begin
  if (Trim(dateToConvert) = '') then
    Result := '01/01/1900'
  else
  begin
    //DecodeDate(StrToDate(dateToConvert), year, month, day);
    //Result := IntToStr(month) + '/' + IntToStr(Day) + '/' + IntToStr(Year);
    Result := dateToConvert;
  end;
end;

//----------------------------------------------------------------------------//

function MQMformatDate(dt: TDateTime): string;
begin
  Result := FormatDateTime('mm/dd/yyyy', dt)
end;

//----------------------------------------------------------------------------//

function FormatQuantity(Qty: double; Decimals: integer): string;
begin
  if Qty = 0 then
  begin
    Result := '0';
    exit
  end;
  Result := Trim(Format('%20.' + IntToStr(Decimals) + 'n', [Qty]));
end;

//----------------------------------------------------------------------------//
// Truncates tailing zeros and delimiter if possible
function FormatQtyWithoutZeros(Qty: double; Decimals: integer): string;
var p, l, i: integer;
  value: string;
begin
  value := FormatQuantity(Qty, Decimals);
  l := Length(value);
  p := Pos('.', value); // Try delimiter .
  if (l > 4) and (p <> l - Decimals) then begin
    p := Pos(',', value); // Try delimiter ,
    if p <> l - Decimals then p := -1;
  end;
  if (l < 5) or (p = -1) then begin
    Result := value;
    exit;
  end;
  for i := l downto l - Decimals do
    if value[l] = '0' then l := l - 1;
  if (value[l] = '.') or (value[l] = ',') then l := l - 1;
  Result := Copy(value, 1, l);
end;

//----------------------------------------------------------------------------//
// Rounds a double to given positive decimals and returns as double
//----------------------------------------------------------------------------//
function RoundDblToDbl(val: Double; decimals: Word): Double;
begin
  Result := Round(val * Power(10, decimals)) / Power(10, decimals);
end;

//----------------------------------------------------------------------------//

function CheckRoundUp(Value: Double) : Double;
var
  S : string;
  FracTmp, TmpStr : String;
  PosFranc : Integer;
begin
  Result := Value;
  try
    S := FloatToStr(Value);
  except
    exit;
  end;

  PosFranc := Pos('.', S);

  TmpStr := copy(S, PosFranc + 1 , 3);

  if Length(TmpStr) = 3 then
  begin
    TmpStr := copy(TmpStr, 3 , 1);
    if TmpStr = '5' then
       Result := Result + 0.005;
  end;
end;

//----------------------------------------------------------------------------//

Function RoundingUserDefineDecaimalPart(FloatNum: Double; NoOfDecPart: integer): Double;
Var
     ls_FloatNumber: String;
Begin
   ls_FloatNumber := FloatToStr(FloatNum);
   IF Pos('.', ls_FloatNumber) > 0 Then
        Result := StrToFloat
          (copy(ls_FloatNumber, 1, Pos('.', ls_FloatNumber) - 1) + '.' + copy
               (ls_FloatNumber, Pos('.', ls_FloatNumber) + 1, NoOfDecPart))
   Else
        Result := FloatNum;
End;

//----------------------------------------------------------------------------//

procedure TMqmProgBar.SetPosition(Pos: integer);
var
  NewPos: integer;
begin

  if TStyleManager.ActiveStyle.Name = 'Windows' then
  begin
    SliderVisible := false;
  end
  else
    SliderVisible := true;

  if Pos = 0 then
  begin
    Position := 0;
    SelStart := 0;
    SelEnd   := 0;
    exit
  end;

  if Max = 0 then
  begin
    Position := 0;
    SelStart := 0;
    SelEnd   := 0;
    exit
  end;

  NewPos := Pos mod Max;

  if (NewPos < Position) or ((NewPos - Position) > trunc(Max/100)) then
  begin
    Position := NewPos;
    SelStart := Position - trunc(Max/10);
    SelEnd   := Position + trunc(Max/10);
  end;
end;

//----------------------------------------------------------------------------//

constructor TMqmProgBar.Create(AOwner : TComponent);
begin
  Inherited Create(Aowner);
  if TStyleManager.ActiveStyle.Name = 'Windows' then
  begin
    SliderVisible := false;
  end
  else
    SliderVisible := true;
end;

//----------------------------------------------------------------------------//

procedure TMqmProgBar.SetMax(NewMax: integer);
begin
  Max := NewMax
end;

//----------------------------------------------------------------------------//

function SqlDeleteLog(table, field: String): String;
begin
  if IniAppGlobals.DownloadTo = '2' then
  begin
    Result := 'delete from ' + table + ' where (' + field + ' < ''YESTERDAY'') or (('
      + field + ' = ''YESTERDAY'') and ((Extract(hour from ' + field
      + ') < Extract(hour from CURRENT_TIMESTAMP)) or ((Extract(hour from ' + field
      + ') = Extract(hour from CURRENT_TIMESTAMP)) and (Extract(minute from '
      + field + ') < Extract(minute from CURRENT_TIMESTAMP)))))' + AND_IDF_Condition('SLO_IDENTIFIER');
    Result:= result;
  end
  else if IniAppGlobals.DownloadTo = '0' then
  begin
    Result := 'delete from ' + table + ' where ' + field + ' < ' + ConvertDateFormatFrom(Now - 1, TD_Db2) + AND_IDF_Condition('SLO_IDENTIFIER');
    Result:= result;
  end
  else if IniAppGlobals.DownloadTo = '1' then
  begin
    Result := 'delete from ' + table + ' where ' + field + ' < ' + ConvertDateFormatDb2Oracle(Now - 1, true, true) + AND_IDF_Condition('SLO_IDENTIFIER');;
    Result:= result;
  end;

end;

//----------------------------------------------------------------------------//

function AddDaysToDate(DateTime : TDateTime; Days : Double) : TDateTime;
begin
  try
    Result := DateTime + Days;
    RoundDateTime(Result);
  except
  end;
end;
//----------------------------------------------------------------------------//

procedure RoundDateTime(var DateTime : TDateTime);
var
  Seconds : int64;
begin
  try
    if (DateTime > 0) and (DateTime < 200000) then
    begin
//    dateTime := StrToDateTime(DateTimeToStr(DateTime));
      Seconds := round(DateTime * 24 * 60 * 60);
      dateTime := Seconds / 60 / 60 / 24;
    end;
  except
  end;
end;

//----------------------------------------------------------------------------//

function GetMonthDayFormat(Value : Word) : string;
begin
  case Value of
    0 : Result := '00';
    1 : Result := '01';
    2 : Result := '02';
    3 : Result := '03';
    4 : Result := '04';
    5 : Result := '05';
    6 : Result := '06';
    7 : Result := '07';
    8 : Result := '08';
    9 : Result := '09';
  else
    Result := IntToStr(Value)
  end
end;

//----------------------------------------------------------------------------//

function GetDateTimeFormatForStr(YYYYMMDDHHMM : string) : TDateTime;
var
  Year, Month, Day, Hour, Minute : Word;
begin
  try
    Year := StrToInt(copy(YYYYMMDDHHMM, 1, 4));
    Month := StrToInt(copy(YYYYMMDDHHMM, 5, 2));
    Day := StrToInt(copy(YYYYMMDDHHMM, 7, 2));
//    Hour := StrToInt(copy(YYYYMMDDHHMM, 9, 2));
//    Minute := StrToInt(copy(YYYYMMDDHHMM, 11, 2));
    Result := EncodeDateTime(Year, Month, Day, Hour, Minute, 0, 0);
  Except
    Result := 0;
  end;
end;

//----------------------------------------------------------------------------//

function GetDateFormatForStr(YYYYMMDD : string) : TDateTime;
var
  Year, Month, Day, Hour, Minute : Word;
begin
  try
    Year := StrToInt(copy(YYYYMMDD, 1, 4));
    Month := StrToInt(copy(YYYYMMDD, 5, 2));
    Day := StrToInt(copy(YYYYMMDD, 7, 2));
    Result := EncodeDateTime(Year, Month, Day, 0, 0, 0, 0);
  Except
    Result := 0;
  end;
end;

//----------------------------------------------------------------------------//

function GetDateFormatForTDateTime(DateTime : TDateTime) : TDateTime;
var
  Year,Month,Day,Hour,Minute,Second,MilliSecond : Word;
begin
  try
    DecodeDateTime(DateTime,Year,Month,Day,Hour,Minute,Second,MilliSecond);
    Result := EncodeDateTime(Year, Month, Day, 0, 0, 0, 0);
  Except
    Result := 0;
  end;
end;

//----------------------------------------------------------------------------//

function getLimitedDecimalsForDouble(Number : double; NumOfDec : Integer) : double;
var
  Multiplier, BeforDec, ResultLong : LongInt;
begin
  BeforDec := trunc(Number);
  Number := Number - BeforDec;
  Multiplier := 1;
  while (NumOfDec > 0) do
  begin
    Multiplier := Multiplier * 10;
    dec(NumOfDec);
  end;
  ResultLong := Trunc(Number * Multiplier);
  Result := ResultLong/Multiplier + BeforDec;
end;
{  S : string;
  TempExt : Extended;
  TempExtMinus : boolean;
begin
  TempExtMinus := (Frac(Number) < 0);
  TempExt := ABS(Frac(Number));
  Result := Trunc(Number);

  S := FloatToStr(TempExt);

  if NumOfDec = 1 then
  begin
    if Length(S) > 2 then
      S := Copy(s, 1, 3);
    if (Result < 0) or TempExtMinus then
      Result := Result - StrToFloat(S)
    else
      Result := Result + StrToFloat(S);
  end;

  if NumOfDec = 2 then
  begin
    if Length(S) > 3 then
      S := Copy(s, 1, 4);
    if (Result < 0) or TempExtMinus then
      Result := Result - StrToFloat(S)
    else
      Result := Result + StrToFloat(S);
  end;

  if NumOfDec = 8 then
  begin
    if Length(S) > 9 then
      S := Copy(s, 1, 10);
    if (Result < 0) or TempExtMinus then
      Result := Result - StrToFloat(S)
    else
      Result := Result + StrToFloat(S);
  end

end;  }

//----------------------------------------------------------------------------//

function formatForTwoDigits(value: String): String;
begin
  if Length(value) = 1 then
    Result := '0' + value
  else
    Result := value;
end;

//----------------------------------------------------------------------------//

function ConvertDateFormatFrom(dateToConvert: TDateTime; DateFrom : TDndArchiveName): String;
var
  year: Word;
  month: Word;
  day: Word;
  hour: Word;
  minute: Word;
  second: Word;
  milisecond: Word;
begin
  DecodeDate(dateToConvert, year, month, day);
  DecodeTime(dateToConvert, hour, minute, second, milisecond);

{  if (GetDownloadTo = 0) then      // IB
    Result := QuotedStr( IntToStr(month) + '/' + IntToStr(Day) + '/' + IntToStr(Year) + ' ' +
                        formatForTwoDigits(IntToStr(hour)) + ':' + formatForTwoDigits(IntToStr(minute)) + ':' +
                        formatForTwoDigits(IntToStr(second)))// + '.' + IntToStr(milisecond))  }
  if (DateFrom = TD_Db2) then // DB2
    Result := QuotedStr(IntToStr(Year) + '-' + formatForTwoDigits(IntToStr(Month)) + '-' + formatForTwoDigits(IntToStr(Day)) + ' ' +
                        formatForTwoDigits(IntToStr(hour)) + ':' + formatForTwoDigits(IntToStr(minute)) + ':' +
                        formatForTwoDigits(IntToStr(second)))// + '.' + IntToStr(milisecond)) //' 00:00:00.0'
  else if (DateFrom = TD_Oracle) then  // Oracle
    Result := 'to_date(' + QuotedStr(IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(Day) + ' ' +
                           formatForTwoDigits(IntToStr(hour)) + ':' + formatForTwoDigits(IntToStr(minute)) + ':' +
                           formatForTwoDigits(IntToStr(second))) + ', ' + QuotedStr('YYYY-MM-DD HH24:MI:SS') + ')'
  else if (DateFrom = TD_Db2OnAs400) then // DB2 on As400
    Result := QuotedStr(IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(Day)); //+ ' ' +

end;

//----------------------------------------------------------------------------//

function ConvertDateFormatTo(dateToConvert: TDateTime; DateTo : TDndArchiveName): String;
var
  year: Word;
  month: Word;
  day: Word;
  hour: Word;
  minute: Word;
  second: Word;
  milisecond: Word;
begin
  try
    DecodeDate(dateToConvert, year, month, day);
  except
    DecodeDate(Now - 1, year, month, day);
  end;

  try
    DecodeTime(dateToConvert, hour, minute, second, milisecond);
  except
    DecodeTime(Now - 1 , hour, minute, second, milisecond);
  end;

  if (DateTo = TD_Interbase) then      // IB
    Result := QuotedStr((IntToStr(month) + '/' + IntToStr(Day) + '/' + IntToStr(Year) + ' ' +
                        formatForTwoDigits(IntToStr(hour)) + ':' + formatForTwoDigits(IntToStr(minute)) + ':' +
                        formatForTwoDigits(IntToStr(second))))// + '.' + IntToStr(milisecond))
  else if (DateTo = TD_Db2) then // DB2
    Result := QuotedStr((IntToStr(Year) + '-' + formatForTwoDigits(IntToStr(Month)) + '-' + formatForTwoDigits(IntToStr(Day)) + ' ' +
                        formatForTwoDigits(IntToStr(hour)) + ':' + formatForTwoDigits(IntToStr(minute)) + ':' +
                        formatForTwoDigits(IntToStr(second))))// + '.' + IntToStr(milisecond)) //' 00:00:00.0'
  else if (DateTo = TD_Oracle) then  // Oracle
    Result := 'to_date(' + QuotedStr(IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(Day) + ' ' +
                           formatForTwoDigits(IntToStr(hour)) + ':' + formatForTwoDigits(IntToStr(minute)) + ':' +
                           formatForTwoDigits(IntToStr(second))) + ', ' + QuotedStr('YYYY-MM-DD HH24:MI:SS') + ')'
  else if (DateTo = TD_Db2OnAs400) then // DB2 on As400
    Result := QuotedStr(IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(Day)); //+ ' ' +
end;

//----------------------------------------------------------------------------//

function ConvertDateFormatDb2Oracle(dateToConvert: TDateTime; Include_To_Date : boolean; DownLoadTo : boolean): String;
var
  year: Word;
  month: Word;
  day: Word;
  hour: Word;
  minute: Word;
  second: Word;
  milisecond: Word;
  DateConvert : TDndArchiveName;
  DndArchiveArcName : TDndArchiveName;
begin
  DecodeDate(dateToConvert, year, month, day);
  DecodeTime(dateToConvert, hour, minute, second, milisecond);
  DndArchiveArcName := GetDndArchiveLocalName;

  if DownLoadTo then
  begin
    if IniAppGlobals.DownloadTo = '0' then
       DateConvert := TD_Db2
    else if IniAppGlobals.DownloadTo = '1' then
       DateConvert := TD_Oracle
    else if IniAppGlobals.DownloadTo = '2' then
       DateConvert := TD_Interbase;
  end
  else
  begin
    if DndArchiveArcName = TD_Db2 then
      DateConvert := TD_Db2
    else if DndArchiveArcName = TD_Oracle then
      DateConvert := TD_Oracle
    else
      DateConvert := TD_Db2
  end;

  if DateConvert = TD_Db2 then
    Result := QuotedStr(IntToStr(Year) + '-' + formatForTwoDigits(IntToStr(Month)) + '-' + formatForTwoDigits(IntToStr(Day)))
  else if DateConvert = TD_Oracle then
  begin
    if Include_To_Date then
      Result := 'to_date(' + QuotedStr(formatForTwoDigits(IntToStr(Month) + '-' + formatForTwoDigits(IntToStr(Day)) + '-' + IntToStr(Year))) + ', ' + QuotedStr('MM-DD-YYYY') + ')'
    else
      Result := QuotedStr(IntToStr(Year) + '-' + formatForTwoDigits(IntToStr(Month)) + '-' + formatForTwoDigits(IntToStr(Day)))
  end
  else
    Result := QuotedStr(IntToStr(month) + '/' + IntToStr(day) + '/' + IntToStr(year));
end;

//----------------------------------------------------------------------------//

function ConvertDateFormatMQM(dateToConvert: TDateTime): String;
var
  year: Word;
  month: Word;
  day: Word;
  hour: Word;
  minute: Word;
  second: Word;
  milisecond: Word;
  DateTo : TDndArchiveName;
begin
  DecodeDate(dateToConvert, year, month, day);
  DecodeTime(dateToConvert, hour, minute, second, milisecond);

  if IniAppGlobals.DownloadTo = '0' then
     DateTo := TD_Db2
  else if IniAppGlobals.DownloadTo = '1' then
     DateTo := TD_Oracle
  else if IniAppGlobals.DownloadTo = '2' then
     DateTo := TD_Interbase;

  if (DateTo = TD_Interbase) then      // IB
    Result := QuotedStr((IntToStr(month) + '/' + IntToStr(Day) + '/' + IntToStr(Year) + ' ' +
                        formatForTwoDigits(IntToStr(hour)) + ':' + formatForTwoDigits(IntToStr(minute)) + ':' +
                        formatForTwoDigits(IntToStr(second))))// + '.' + IntToStr(milisecond))
  else if (DateTo = TD_Db2) then // DB2
    Result := QuotedStr((IntToStr(Year) + '-' + formatForTwoDigits(IntToStr(Month)) + '-' + formatForTwoDigits(IntToStr(Day)) + ' ' +
                        formatForTwoDigits(IntToStr(hour)) + ':' + formatForTwoDigits(IntToStr(minute)) + ':' +
                        formatForTwoDigits(IntToStr(second))))// + '.' + IntToStr(milisecond)) //' 00:00:00.0'
  else if (DateTo = TD_Oracle) then  // Oracle
    Result := 'to_date(' + QuotedStr(IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(Day) + ' ' +
                           formatForTwoDigits(IntToStr(hour)) + ':' + formatForTwoDigits(IntToStr(minute)) + ':' +
                           formatForTwoDigits(IntToStr(second))) + ', ' + QuotedStr('YYYY-MM-DD HH24:MI:SS') + ')'
  else if (DateTo = TD_Db2OnAs400) then // DB2 on As400
    Result := QuotedStr(IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(Day)); //+ ' ' +
end;

//----------------------------------------------------------------------------//

function FormatDateMMDDYYYYWithSlash(DateTime : TDateTime) : String;
var
  year: Word;
  month: Word;
  day: Word;
begin
  DecodeDate(DateTime, year, month, day);
  Result :=  IntToStr(month) + '/' + IntToStr(day) + '/' + IntToStr(year);
end;

//----------------------------------------------------------------------------//

function ConvertDateFormatToYYYYMMDD(dateToConvert: TDate; GetDownloadTo: Integer): String;
begin
  Result := QuotedStr(FormatDateTime('yyyymmdd', dateToConvert));
end;

//----------------------------------------------------------------------------//

function setStringLengthTo(str: String; maxLength: integer; leftToRight: boolean; defChar: String): String;
begin
  if maxLength > 0 then
  begin
    if (Length(str) > maxLength) then
      str := Copy(str, 1, maxLength)
    else
    begin
      while Length(str) < maxLength do
      begin
        if(leftToRight) then
          str := str + defChar
        else
          str := defChar + str;
      end;
    end;
  end
  else
    str := '';

  result := str;
end;

//----------------------------------------------------------------------------//

function addUpFields(firstField: String; secondField: String; isInteger: boolean): String;
begin
  if Trim(secondField) = '' then
    Result := firstField
  else if Trim(firstField) = '' then
    Result := secondField
  else
  begin
    if isInteger then
      result := IntToStr(StrToInt(firstField) + StrToInt(secondField))
    else
      result := FloatToStr(StrToFloat(firstField) + StrToFloat(secondField));
  end;
end;

//----------------------------------------------------------------------------//

function getMinimumDate(firstDate: TDateTime; secondDate: TDateTime): TDateTime;
begin
  if (firstDate > secondDate) then
    Result := secondDate
  else
    Result := firstDate;
end;

//----------------------------------------------------------------------------//

function getMaximumDate(firstDate: TDateTime; secondDate: TDateTime): TDateTime;
begin
  if (firstDate < secondDate) then
    Result := secondDate
  else
    Result := firstDate;
end;

//----------------------------------------------------------------------------//

function FDOM(Date: TDateTime): TDateTime;
var
  Year, Month, Day: Word;
begin
  DecodeDate(Date, Year, Month, Day);
  Result := StartOfAMonth(Year, Month)
//  Result := EncodeDate(Year, Month, 1);
end;

//----------------------------------------------------------------------------//

function LDOM(Date: TDateTime): TDateTime;
var
  Year, Month, Day: Word;
begin
  DecodeDate(Date, Year, Month, Day);
  result := EndOfAMonth(Year, Month);
end;

//----------------------------------------------------------------------------//

function IsFirstDayOfWeek(d: TDateTime): Boolean;
begin
  Result := DayOfWeek(d) = FDOW;
end;

//----------------------------------------------------------------------------//

function FirstDayOfWeekOf(d: TDateTime; foreword : boolean): TDateTime;
begin
  d := Trunc(d);
  while not IsFirstDayOfWeek(d) do
  begin
    if foreword then
      d := d + 1.0
    else
      d := d - 1.0;
  end;

  Result := d;
end;

//----------------------------------------------------------------------------//

function DayOfWeekName(D : TDateTime) : string;
begin
  case DayOfWeek(D) of
    1 : result := 'Sunday';
    2 : result := 'Monday';
    3 : result := 'Tuesday';
    4 : result := 'Wednesday';
    5 : result := 'Thursday';
    6 : result := 'Friday';
    7 : result := 'Saturday';
  end;
end;

//----------------------------------------------------------------------------//

procedure DeleteFilesOlderThan;
var
  FileName: string;
  OlderThan: TDateTime;
begin
  OlderThan := 180;
  try
    for FileName in TDirectory.GetFiles(LocAppGlobals.AppDir, 'ConnectionRepaireetails' + '.txt') do
      if ContainsStr(FileName, 'ConnectionRepairedetails') then
        if (now - TFile.GetCreationTime(FileName)) > OlderThan then
        begin
          TFile.Delete(FileName);
          break
        end;
  except
  end;
end;

//----------------------------------------------------------------------------//

procedure WriteLogConnectionRepair(LogStr : TStringList; IsClient : boolean; During_Save_Or_During_Refresh : string);
begin
var
  DateForName := dateTimetostr(Now);
  DeleteFilesOlderThan;
  LogStr.clear;
  try
    LogStr.LoadFromFile(LocAppGlobals.AppDir + '\' + 'ConnectionRepairedetails' +'.txt');
  except
  end;
  if IsClient then
  begin
    if During_Save_Or_During_Refresh = '1' then
      LogStr.add('Client repaired connection during save operation : ' + DateForName)
    else if During_Save_Or_During_Refresh = '2' then
      LogStr.add('Client repaired connection during refresh operation : ' + DateForName)
    else
      LogStr.add('Client repaired connection : ' + DateForName);
  end
  else
    LogStr.add('Server repaired : ' +DateForName);

  try
    LogStr.SaveToFile(LocAppGlobals.AppDir + '\' + 'ConnectionRepairedetails' +'.txt');
  except
  end;
  LogStr.Clear;
end;

//----------------------------------------------------------------------------//

function BGRtoRGB(const C: TColor): TColor;
begin
  Result := C;
  TColorRec(Result).R := TColorRec(C).B;
  TColorRec(Result).B := TColorRec(C).R;
end;

//----------------------------------------------------------------------------//

function NumberOfDecimalRounding(NumOfDecimal : integer) : integer;
begin
  case NumOfDecimal of
    0 : Result := 1;
    1 : Result := 10;
    2 : Result := 100;
    3 : Result := 1000;
    4 : Result := 10000;
   else
     Result := 100;
  end;
end;

//----------------------------------------------------------------------------//

function GetLocalIP: string;
type
  TaPInAddr = array [0..10] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
  phe: PHostEnt;
  pptr: PaPInAddr;
  Buffer: array [0..63] of Ansichar;
  i: Integer;
  GInitData: TWSADATA;
begin
  WSAStartup($101, GInitData);
  Result := '';
  GetHostName(Buffer, SizeOf(Buffer));
  phe := GetHostByName(Buffer);
  if phe = nil then
    Exit;
  pptr := PaPInAddr(phe^.h_addr_list);
  i := 0;
  while pptr^[i] <> nil do
  begin
    Result := StrPas(inet_ntoa(pptr^[i]^));
    Inc(i);
  end;
  WSACleanup;
end;

//----------------------------------------------------------------------------//

function UTCNow: TDateTime;
var
   UTCnowDateTime: TDateTime;
begin
   UTCnowDateTime := TTimezone.Local.ToUniversalTime(Now, True);
   Result := UTCnowDateTime;
end;

end.
