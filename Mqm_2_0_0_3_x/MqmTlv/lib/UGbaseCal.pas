unit UGbaseCal;

interface

uses
  Dialogs,
  Classes;

const
//  MINAPPROX     = 0.0007; // fp - 311
  MINAPPROX     = 0.0006999999; // fp - 311
  HALFMINAPPROX = 0.0003;
type

  TRecCalShiftDay = record
    Sh1Start: string;
    Sh1End  : string;
    Sh2Start: string;
    Sh2End  : string;
    Sh3Start: string;
    Sh3End  : string;
    Sh4Start: string;
    Sh4End  : string;
  end;

  TRecCalDownTime = record
    DowntimeStart: TDateTime;
    DurationHours: double;
    DowntimeEnd: TDateTime;
  end;
  PTRecCalDownTime = ^TRecCalDownTime;

  TCalError  = (calErr_none, calErr_outOfBound);

  TNormalize = (ntNormalizeForward, ntNormalizeBackward);

  TPGCalObjClass = class of TPGCALObj;

  TPGCALObj = class(TObject)
  public
//    m_TestCount : integer;
    constructor Create(const CalKey: string); virtual;
    constructor CreateByRes(const CalKey: string; const ResKey: string); virtual;
    constructor CreateCalByResLvel(const CalKey: string; const CalResKey: string); virtual;
    function    GetKey: string;
    function    GetResKey: string;
    function    GetCalName_ResEffBothLvl : string;
    function    IsResCal : boolean;
    function    OfsByWH(OfsWH: double; isStart: boolean; var startDate: TDateTime;
                        var NewDate: TDateTime; DownTimeList: TList): boolean; virtual;

    function    OfsByWHDwTime(OfsWH: double; isStart: boolean; var startDate: TDateTime;
                        var NewDate: TDateTime): boolean; virtual;

    procedure   NormalizeDate(var date: TDateTime; norm: TNormalize); virtual;
    function    DiffWH(Date1, Date2: TDateTime; DownTimeList: TList): double; virtual;
    function    DiffWHNotRounded(Date1, Date2: TDateTime; DownTimeList: TList): double; virtual;

    procedure   StartIterator(lt, rt: TDateTime); virtual;
    function    GetNext(var lt, rt: TDateTime): boolean; virtual;
    function    GetNextEffic(var lt, rt, NextShift : TDateTime;
                             var SH1_start, SH1_End: TDateTime; var Effic1: double; var SH2_start,
                             SH2_End: TDateTime; var Effic2: double; var SH3_start, SH3_End: TDateTime;
                             var Effic3: double; var SH4_start, SH4_End: TDateTime; var Effic4: double
                                          ): boolean; virtual;
    function AddDaysToDateNoCalendar(DateTime : TDateTime; Days : Double) : TDateTime; virtual;

    function GetRefDate:  TDateTime; virtual;
    function GetLastDate: TDateTime; virtual;
    procedure Ini_lastIxCalEffic; virtual;

  private
    m_calKey: string;
    m_CalName_ResEffBothLvl : string;
    m_ResKey: string;
  //  m_IsResCal : boolean;

  public
    m_IsResCal : boolean;
    m_IsEfficiencyAndCalBothOnResLvl : boolean;
  protected
    // iterator data
    m_lt, m_rt: TDateTime;
  end;

  function  RoundDate(date: TDateTime): TDateTime;
  function  TruncToDayNum(date: TDateTime): integer;
  function  TruncToDayDate(date: TDateTime): TDateTime;
  function  MinutesFromDate(date: TDateTime): double;
  function  ObjPGCAL_ByKey(const CalKey: string; const CalClass: TPGCalObjClass): TPGCALObj;
  function  ObjPGCAL_ByResKey(const CalKey: string; const ResKey : string; const CalClass: TPGCalObjClass): TPGCALObj;
  function  ObjPGCAL_ByCalAndResKey(const CalKey: string; const CalResKey : string; const CalClass: TPGCalObjClass): TPGCALObj;

  function  ObjPGCAL_Count : integer;
  function  ObjPGCAL_ByNum(Idx : integer): TPGCALObj;
  procedure ClearPGCALPool(WithVOID : boolean);

  procedure SetCalError(err: TCalError);
  function  IsCalError: boolean;
  procedure ClearCalError;
  function  CheckCalenderForEfficiencyOnResourceLevel(CalCode : string) : boolean;
  function  CheckCalenderForEfficiencyOnWorkCenterLevel(CalCode : string) : boolean;
  function  CheckCalenderAndEfficiencyOnResourceLevelBoth(CalCode : string) : boolean;

  procedure LoadCalendarCodeForEfficiencyOnResourceLevel;
  procedure LoadCalendarCodeForEfficiencyOnWorkCenterLevel;
  procedure LoadCalendarCodeForEfficiencyBothOnResourceLevel;

implementation

uses
  SysUtils,
  DMsrvPc,
  UMTblDesc,
  UMCOmmon,
  gnugettext;

const
  C_POLARIZE = 1 / 24 / 60 / 60;

var
  PGCALPool: TList;
  s_calErr:  TCalError;
  s_Cal_EfficiencyOnResourceLevel, s_Cal_EfficiencyOnWorkCenterLevel, s_Cal_And_Efficiency_Both_On_Res_Level : TStringList;

//----------------------------------------------------------------------------//

procedure SetCalError(err: TCalError);
begin
  s_calErr := err
end;

//----------------------------------------------------------------------------//

function IsCalError: boolean;
begin
  Result := false;
  if s_calErr <> calErr_none then
    Result := true
end;

//----------------------------------------------------------------------------//

procedure ClearCalError;
begin
  s_calErr := calErr_none
end;

//----------------------------------------------------------------------------//

function CheckCalenderForEfficiencyOnResourceLevel(CalCode : string) : boolean;
var
  I : Integer;
begin
  Result := false;
  for I := 0 to s_Cal_EfficiencyOnResourceLevel.Count - 1 do
  begin
    if (s_Cal_EfficiencyOnResourceLevel.Strings[I] = CalCode) then
    begin
      Result := true;
      Exit
    end;
  end;
end;

//----------------------------------------------------------------------------//

function CheckCalenderForEfficiencyOnWorkCenterLevel(CalCode : string) : boolean;
var
  I : Integer;
begin
  Result := false;
  for I := 0 to s_Cal_EfficiencyOnWorkCenterLevel.Count - 1 do
  begin
    if (s_Cal_EfficiencyOnWorkCenterLevel.Strings[I] = CalCode) then
    begin
      Result := true;
      Exit
    end;
  end;
end;

//----------------------------------------------------------------------------//

function CheckCalenderAndEfficiencyOnResourceLevelBoth(CalCode : string) : boolean;
var
  I : Integer;
begin
  Result := false;
  for I := 0 to s_Cal_And_Efficiency_Both_On_Res_Level.Count - 1 do
  begin
    if (s_Cal_And_Efficiency_Both_On_Res_Level.Strings[I] = CalCode) then
    begin
      Result := true;
      Exit
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure LoadCalendarCodeForEfficiencyOnResourceLevel;
var
  qry: TMqmQuery;
  tbInfo : ^TTblInfo;
begin
  qry := CreateQuery(Main_DB);
  tbInfo := @tblInfo[tbl_Cal];
  qry.SQL.Text := 'select * from ' + tbInfo.GetTableName + ' where ' + CreateFld(tbInfo.pfx, fli_EfficiencyOnWcOrResLevel) + '=''' + IntToStr(1) + '''';
  qry.SQL.Add(AND_IDF_Condition(CreateFld(TbInfo.pfx, fli_Identifier)));
  qry.open;
  while not qry.Eof do
  begin
    s_Cal_EfficiencyOnResourceLevel.add(qry.FieldByName(CreateFld(tbInfo.pfx, fli_CalCod)).AsString);
    qry.next
  end;
  qry.Free;
end;

//----------------------------------------------------------------------------//

procedure LoadCalendarCodeForEfficiencyOnWorkCenterLevel;
var
  qry: TMqmQuery;
  tbInfo : ^TTblInfo;
begin
  qry := CreateQuery(Main_DB);
  tbInfo := @tblInfo[tbl_Cal];
  qry.SQL.Text := 'select * from ' + tbInfo.GetTableName + ' where ' + CreateFld(tbInfo.pfx, fli_EfficiencyOnWcOrResLevel) + '=''' + IntToStr(2) + '''';
  qry.SQL.Add(AND_IDF_Condition(CreateFld(TbInfo.pfx, fli_Identifier)));
  qry.open;
  while not qry.Eof do
  begin
    s_Cal_EfficiencyOnWorkCenterLevel.add(qry.FieldByName(CreateFld(tbInfo.pfx, fli_CalCod)).AsString);
    qry.next
  end;
  qry.Free;
end;

//----------------------------------------------------------------------------//

procedure LoadCalendarCodeForEfficiencyBothOnResourceLevel;
var
  qry: TMqmQuery;
  tbInfo : ^TTblInfo;
begin
  qry := CreateQuery(Main_DB);
  tbInfo := @tblInfo[tbl_Cal];
  qry.SQL.Text := 'select * from ' + tbInfo.GetTableName + ' where ' + CreateFld(tbInfo.pfx, fli_EfficiencyOnWcOrResLevel) + '=''' + IntToStr(3) + '''';
  qry.SQL.Add(AND_IDF_Condition(CreateFld(TbInfo.pfx, fli_Identifier)));
  qry.open;
  while not qry.Eof do
  begin
    s_Cal_And_Efficiency_Both_On_Res_Level.add(qry.FieldByName(CreateFld(tbInfo.pfx, fli_CalCod)).AsString);
    qry.next
  end;
  qry.Free;

end;

//----------------------------------------------------------------------------//

// get rid of spurious decimal digits: we have minutes resolution
function RoundDate(date: TDateTime): TDateTime;
var
  hour, min, sec, msec: word;
begin
  DecodeTime(frac(date), hour, min, sec, msec);
  if sec > 30 then
  begin
    Inc(min);
    if min = 60 then
    begin
      min := 0;
      Inc(hour);
      if hour = 24 then
      begin
        hour := 0;
        date := date + 1
      end
    end
  end;

// Disable C_POLARIZE - Eran+Avi
Result := trunc(date) + EncodeTime(hour, min, 0, 0);
  // needs polarization for trunc
//{$ifdef DEVELOP}
//  Result := 0;
//  try
//    Result := trunc(date+C_POLARIZE) + EncodeTime(hour, min, 0, 0)
//  except
//    ShowMessage(_('Exception on the EncodeTime of UGbaseCal.RoundDate'));
//  end;
//{$else}
//  Result := trunc(date+C_POLARIZE) + EncodeTime(hour, min, 0, 0)
//{$endif}

end;

//----------------------------------------------------------------------------//

function TruncToDayNum(date: TDateTime): integer;
begin
// Disable C_POLARIZE - Eran+Avi
//  Result := trunc(date+C_POLARIZE)
   Result := trunc(date)
end;

//----------------------------------------------------------------------------//

function TruncToDayDate(date: TDateTime): TDateTime;
var
  DateStr : string;
begin
// Disable C_POLARIZE - Eran+Avi
//  Result := trunc(date+C_POLARIZE)
   DateStr := datetimetostr(Date);
   Date := strtodatetime(DateStr);
   Result := trunc(date);
end;

//----------------------------------------------------------------------------//

function MinutesFromDate(date: TDateTime): double;
var
  hour, min, sec, msec: word;
begin
// Disable C_POLARIZE - Eran+Avi
//  Result := Round(frac(date)*24*60+C_POLARIZE)
//   Result := Round(frac(date)*24*60)
//   Result := trunc(frac(date)*24*60)  // Eran changed to trunc 4/6/2017 with round 23:59:41 turned a day - 1440
  DecodeTime(frac(date), hour, min, sec, msec); // Eran 28/09/2022 Time 10:00 was resulting in 599 instead of 600
  Result := hour * 60 + min;
end;

//----------------------------------------------------------------------------//

// Get a TPGCAL object by key (calendar code).  If the object
// is not available in PGCALPool try to load it from the local
// database.
function ObjPGCAL_ByKey(const CalKey: string; const CalClass: TPGCalObjClass): TPGCALObj;
var
  i: integer;
begin

  Result := nil;
  for i := 0 to PGCALPool.Count-1 do
    if TPGCALObj(PGCALPool[I]).GetKey = CalKey then
    begin
      Result := PGCALPool[i];
      break
    end;

  if not Assigned(Result) then
  begin
    try
      Result := CalClass.Create(CalKey);
      Assert(Assigned(Result));
    except
      raise
    end;
    PGCALPool.Add(Result)
  end
end;

//----------------------------------------------------------------------------//

function ObjPGCAL_ByResKey(const CalKey: string; const ResKey : string; const CalClass: TPGCalObjClass): TPGCALObj;
var
  i: integer;
begin

  Result := nil;
  for i := 0 to PGCALPool.Count-1 do
    if TPGCALObj(PGCALPool[I]).GetKey = ResKey then
    begin
      Result := PGCALPool[i];
      break
    end;

  if not Assigned(Result) then
  begin
    try
      Result := CalClass.CreateByRes(CalKey, ResKey);
      Assert(Assigned(Result));
    except
      raise
    end;
    PGCALPool.Add(Result)
  end
end;

//----------------------------------------------------------------------------//

function ObjPGCAL_ByCalAndResKey(const CalKey: string; const CalResKey : string; const CalClass: TPGCalObjClass): TPGCALObj;
var
  i: integer;
begin

  Result := nil;                                     // for handling sub resources calendar
  for i := 0 to PGCALPool.Count-1 do                 // should have same calendar code as the first sub step
    if (TPGCALObj(PGCALPool[I]).GetKey = CalResKey) or (TPGCALObj(PGCALPool[I]).GetKey = (CalKey + CalResKey)) then
    begin
      Result := PGCALPool[i];
      break
    end;

  if not Assigned(Result) then
  begin
    try
      Result := CalClass.CreateCalByResLvel(CalKey, CalResKey);
      Assert(Assigned(Result));
    except
      raise
    end;
    PGCALPool.Add(Result)
  end
end;

//----------------------------------------------------------------------------//

procedure ClearPGCALPool(WithVOID : boolean);
var
  i: integer;
begin
  Assert(Assigned(PGCALPool));

  for i := PGCALPool.Count - 1 downto 0 do
    if WithVOID or
       ((not WithVOID) and (TPGCALObj(PGCALPool[i]).m_calKey <> 'VOID')) then
    begin
      TPGCALObj(PGCALPool[i]).Free;
      PGCALPool.Delete(i)
    end;

  if WithVOID then
    PGCALPool.Clear
end;


{
procedure ClearPGCALPool;
var
  i: integer;
begin
  Assert(Assigned(PGCALPool));
  for i := 0 to PGCALPool.Count - 1 do
    TPGCALObj(PGCALPool[i]).Free;
  PGCALPool.Clear
end;
}

//----------------------------------------------------------------------------//

constructor TPGCALObj.Create(const CalKey: string);
begin
  inherited Create;
  m_IsResCal := false;
  m_IsEfficiencyAndCalBothOnResLvl := false;
  m_calKey := CalKey
end;

//----------------------------------------------------------------------------//

constructor TPGCALObj.CreateByRes(const CalKey: string; const ResKey: string);
begin
  inherited Create;
  m_IsResCal := true;
  m_IsEfficiencyAndCalBothOnResLvl := false;
  m_calKey := ResKey;
end;

//----------------------------------------------------------------------------//

constructor TPGCALObj.CreateCalByResLvel(const CalKey: string; const CalResKey: string);
begin
  inherited Create;
  m_IsResCal := false;
  m_IsEfficiencyAndCalBothOnResLvl := true;
  m_CalName_ResEffBothLvl := CalKey;
  m_calKey := CalKey + CalResKey;
  m_ResKey := CalResKey;
end;

//----------------------------------------------------------------------------//

function TPGCALObj.GetKey: string;
begin
  Result := m_calKey;
end;

//----------------------------------------------------------------------------//

function TPGCALObj.GetResKey: string;
begin
  Result := m_ResKey
end;

//----------------------------------------------------------------------------//

function TPGCALObj.GetCalName_ResEffBothLvl : string;
begin
  Result := m_CalName_ResEffBothLvl;
end;

//----------------------------------------------------------------------------//

function TPGCALObj.IsResCal : boolean;
begin
  Result := m_IsResCal
end;

//----------------------------------------------------------------------------//

function TPGCALObj.OfsByWH(OfsWH: double; isStart: boolean; var startDate: TDateTime;
                           var NewDate: TDateTime; DownTimeList: TList): boolean;
begin
  newDate := startDate + ofsWH / 24;
  Result := true
end;

//----------------------------------------------------------------------------//

function TPGCALObj.OfsByWHDwTime(OfsWH: double; isStart: boolean; var startDate: TDateTime;
                        var NewDate: TDateTime): boolean;
begin
  Result := true
end;

//----------------------------------------------------------------------------//

procedure TPGCALObj.NormalizeDate(var date: TDateTime; norm: TNormalize);
begin
end;

//----------------------------------------------------------------------------//

function TPGCALObj.DiffWH(Date1, Date2: TDateTime; DownTimeList: TList): double;
begin
  if Date1 > Date2 then
    Result := (Date1-Date2) * 24
  else
    Result := (Date2-Date1) * 24
end;

//----------------------------------------------------------------------------//

function TPGCALObj.DiffWHNotRounded(Date1, Date2: TDateTime; DownTimeList: TList): double;
begin
  if Date1 > Date2 then
    Result := (Date1-Date2) * 24
  else
    Result := (Date2-Date1) * 24
end;

//----------------------------------------------------------------------------//

procedure TPGCALObj.StartIterator(lt, rt: TDateTime);
begin
  m_lt := TruncToDayDate(lt);
  m_rt := TruncToDayDate(rt+1)
end;

//----------------------------------------------------------------------------//

function TPGCALObj.GetNext(var lt, rt: TDateTime): boolean;
begin
  Result := false
end;

//----------------------------------------------------------------------------//

function TPGCALObj.GetNextEffic(var lt, rt, NextShift : TDateTime;
                             var SH1_start, SH1_End: TDateTime; var Effic1: double; var SH2_start,
                             SH2_End: TDateTime; var Effic2: double; var SH3_start, SH3_End: TDateTime;
                             var Effic3: double; var SH4_start, SH4_End: TDateTime; var Effic4: double
                                          ): boolean;
begin
  Result := false
end;

//----------------------------------------------------------------------------//

function TPGCALObj.GetRefDate: TDateTime;
begin
  Result := 0
end;

//----------------------------------------------------------------------------//

function TPGCALObj.GetLastDate: TDateTime;
begin
  Result := 0
end;

//----------------------------------------------------------------------------//

function TPGCALObj.AddDaysToDateNoCalendar(DateTime : TDateTime; Days : Double) : TDateTime;
begin
  Result := 0
end;

//----------------------------------------------------------------------------//

procedure TPGCALObj.Ini_lastIxCalEffic;
begin

end;

//----------------------------------------------------------------------------//

function ObjPGCAL_Count : integer;
begin
  Result := PGCALPool.Count;
end;

//----------------------------------------------------------------------------//

function  ObjPGCAL_ByNum(Idx : integer): TPGCALObj;
begin
  Result := TPGCALObj(PGCALPool[Idx])
end;

//----------------------------------------------------------------------------//

initialization
  s_calErr := calErr_none;
  PGCALPool := TList.Create;
  s_Cal_EfficiencyOnResourceLevel := TStringList.Create;
  s_Cal_EfficiencyOnWorkCenterLevel := TStringList.Create;
  s_Cal_And_Efficiency_Both_On_Res_Level := TStringList.Create;
  // create and add to the list the void calendar
  PGCALPool.Add(TPGCALObj.Create('VOID'))

finalization
  Assert(Assigned(PGCALPool));
  ClearPGCALPool(true);
  s_Cal_EfficiencyOnResourceLevel.Free;
  s_Cal_EfficiencyOnWorkCenterLevel.Free;
  s_Cal_And_Efficiency_Both_On_Res_Level.Free;
  PGCALPool.Free

//----------------------------------------------------------------------------//
end.


