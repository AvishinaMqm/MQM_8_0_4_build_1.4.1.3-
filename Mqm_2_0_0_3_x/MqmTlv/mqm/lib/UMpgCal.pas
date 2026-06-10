unit UMpgCal;

interface

uses
  Classes,
  UGshiftCal;

type

  // The Calendar Object
  // From Now get AppGlobals.MonthBefore Days before
  // (if they exists else what exists) and Store PGCALElemMx elems

  TPGCALObjMqm = class(TPGCALshift)

    //  EArPGCALNoCal: if Calendar key not found or not covering today
    constructor Create(const CalKey: string); override;
    constructor CreateByRes(const CalKey: string; const ResKey: string); override;
    constructor CreateCalByResLvel(const CalKey: string; const ResKey: string); override;

  end;

implementation

uses
  SysUtils,
  UMglobal,
  UMTblDesc,
  UMCommon,
  DMsrvPC;

// TPGCALObj ------------------------------------------------------------------

// Create a new calendar object loading records with given key from PGCAL00F.
// The data are loaded starting from 'now - AppGlobals.MonthBefore' up to the
// maximum capacity of the TPGCALObj.Calendar array.

constructor TPGCALObjMqm.Create(const CalKey: string);
var
  qry: TMqmQuery;
  tbInfo:  ^TTblInfo;
  I, HoursPerDay : integer;
  SavedJPRGWH : currency;
  CurrentDate : TDateTime;
  ShiftEffic : PTShiftEffic;
begin
  inherited Create(CalKey);
  tbInfo := @tblInfo[tbl_calendar];

  m_JCDCAL := CalKey;
  qry := CreateQuery(Main_DB);

  //WARNING THE FIELDS OF THIS QUERY ARE ACCESSED BY INDEX!
  qry.SQL.Add('select ');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_CalDate) + ','); //Kcaldt
//  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_Prog_Wrk_Hr) + ',');  //KPRGHW
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH1_start) + ','); //KINZT1
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH1_end) + ','); //KFINT1
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH2_start) + ','); //KINZT2
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH2_end) + ','); //KFINT2
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH3_start) + ','); //KINZT3
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH3_end) + ','); //KFINT3
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH4_start) + ','); //KINZT4
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH4_end)); //KFINT4
  qry.SQL.Add(' from ' + tbInfo.GetTableName);
  qry.SQL.Add(' where (' + CreateFld(tbInfo.pfx, fli_CalCod) + ' = ');
  qry.SQL.Add('''' + m_JCDCAL + '''');

  if IniAppGlobals.DownloadTo = '2' then
    qry.SQL.Add(') and (' + CreateFld(tbInfo.pfx, fli_CalDate) + ' >= ''' + FormatDateMMDDYYYYWithSlash(DBAppGlobals.StDateForPlan) + '''')
  else
    qry.SQL.Add(') and (' + CreateFld(tbInfo.pfx, fli_CalDate) + ' >= '+ ConvertDateFormatDb2Oracle(DBAppGlobals.StDateForPlan, true, true));
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.SQL.Add(') order by ' + CreateFld(tbInfo.pfx, fli_CalDate));
  qry.Open;

  SavedJPRGWH := 0;
  m_startDate := trunc(DBAppGlobals.StDateForPlan);
  CurrentDate := DBAppGlobals.StDateForPlan - 1;
  m_lastIx := -1;
  while CurrentDate < DBAppGlobals.EndDateForPlan do
  begin
    CurrentDate := CurrentDate + 1;
    Inc(m_lastIx);
    with m_calendar[m_lastIx] do
    begin
      if (not qry.EOF) and (FormatDateTime(FormatSettings.ShortDateFormat, CurrentDate) = qry.Fields[0].asString) then
      begin
        shift[1].start := qry.Fields[1].AsInteger;
        shift[1].dur   := qry.Fields[2].AsInteger - shift[1].start;
        shift[2].start := qry.Fields[3].AsInteger;
        shift[2].dur   := qry.Fields[4].AsInteger - shift[2].start;
        shift[3].start := qry.Fields[5].AsInteger;
        shift[3].dur   := qry.Fields[6].AsInteger - shift[3].start;
        shift[4].start := qry.Fields[7].AsInteger;
        shift[4].dur   := qry.Fields[8].AsInteger - shift[4].start;
        JNUMWH := (shift[1].dur+shift[2].dur+shift[3].dur+shift[4].dur)/60;
        HoursPerDay := trunc(100 * JNUMWH);
        SavedJPRGWH := SavedJPRGWH + (HoursPerDay / 100);
        JPRGWH := SavedJPRGWH;
        DateModified := false;
        DateNew := false;
        qry.Next;
      end
      else
      begin
        SavedJPRGWH := SavedJPRGWH + 24;
        JPRGWH := SavedJPRGWH;
        shift[1].start := 0;
        shift[1].dur   := 1440;
        shift[2].start := 0;
        shift[2].dur   := 0;
        shift[3].start := 0;
        shift[3].dur   := 0;
        shift[4].start := 0;
        shift[4].dur   := 0;
        JNUMWH := 24;
        DateModified := false;
        DateNew := true;
      end;
    end;
  end;

  tbInfo := @tblInfo[tbl_calShiftEffic];
  qry.SQL.Clear;
  qry.SQL.Add('select ');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_CalStartDate) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_CalEndDate) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH1_start) + ','); //KINZT1
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH1_end) + ','); //KFINT1
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH1_EFFIC) + ','); //KFINT1
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH2_start) + ','); //KINZT2
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH2_end) + ','); //KFINT2
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH2_EFFIC) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH3_start) + ','); //KINZT3
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH3_end) + ','); //KFINT3
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH3_EFFIC) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH4_start) + ','); //KINZT4
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH4_end)   + ','); //KFINT4
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH4_EFFIC));

  qry.SQL.Add(' from ' + tbInfo.GetTableName);
  qry.SQL.Add(' where (' + CreateFld(tbInfo.pfx, fli_CalCod) + ' = ');
  qry.SQL.Add('''' + m_JCDCAL + '''');

  if IniAppGlobals.DownloadTo = '2' then
    qry.SQL.Add(') and (' + CreateFld(tbInfo.pfx, fli_CalStartDate) + ' >= ''' + FormatDateMMDDYYYYWithSlash(DBAppGlobals.StDateForPlan) + '''')
  else
    qry.SQL.Add(') and (' + CreateFld(tbInfo.pfx, fli_CalStartDate) + ' >= ' + ConvertDateFormatDb2Oracle(DBAppGlobals.StDateForPlan, true, true));
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.SQL.Add(') order by ' + CreateFld(tbInfo.pfx, fli_CalStartDate));
  qry.Open;

//  if not qry.EOF then
  m_ListShiftEffic := TList.Create;

  m_lastIxCalEffic := -1;
  while not qry.EOF do
  begin
    if m_lastIxCalEffic >= (PGCALElemMax-1) then break;

    Inc(m_lastIxCalEffic);
    with m_ShiftEffic[m_lastIxCalEffic] do
    begin
      StartDate := Trunc(qry.Fields[0].AsDateTime);
      EndDate   := Trunc(qry.Fields[1].AsDateTime);
      StartMinute1 := qry.Fields[2].AsInteger;
      EndMinute1   := qry.Fields[3].AsInteger;
      Effic1       := qry.Fields[4].AsInteger;
      StartMinute2 := qry.Fields[5].AsInteger;
      EndMinute2   := qry.Fields[6].AsInteger;
      Effic2       := qry.Fields[7].AsInteger;
      StartMinute3 := qry.Fields[8].AsInteger;
      EndMinute3   := qry.Fields[9].AsInteger;
      Effic3       := qry.Fields[10].AsInteger;
      StartMinute4 := qry.Fields[11].AsInteger;
      EndMinute4   := qry.Fields[12].AsInteger;
      Effic4       := qry.Fields[13].AsInteger;
    end;

    new(ShiftEffic);
    ShiftEffic.StartDate    := m_ShiftEffic[m_lastIxCalEffic].StartDate;
    ShiftEffic.EndDate      := m_ShiftEffic[m_lastIxCalEffic].EndDate;
    ShiftEffic.StartMinute1 := m_ShiftEffic[m_lastIxCalEffic].StartMinute1;
    ShiftEffic.EndMinute1   := m_ShiftEffic[m_lastIxCalEffic].EndMinute1;
    ShiftEffic.Effic1       := m_ShiftEffic[m_lastIxCalEffic].Effic1;
    ShiftEffic.StartMinute2 := m_ShiftEffic[m_lastIxCalEffic].StartMinute2;
    ShiftEffic.EndMinute2   := m_ShiftEffic[m_lastIxCalEffic].EndMinute2;
    ShiftEffic.Effic2       := m_ShiftEffic[m_lastIxCalEffic].Effic2;
    ShiftEffic.StartMinute3 := m_ShiftEffic[m_lastIxCalEffic].StartMinute3;
    ShiftEffic.EndMinute3   := m_ShiftEffic[m_lastIxCalEffic].EndMinute3;
    ShiftEffic.Effic3       := m_ShiftEffic[m_lastIxCalEffic].Effic3;
    ShiftEffic.StartMinute4 := m_ShiftEffic[m_lastIxCalEffic].StartMinute4;
    ShiftEffic.EndMinute4   := m_ShiftEffic[m_lastIxCalEffic].EndMinute4;
    ShiftEffic.Effic4       := m_ShiftEffic[m_lastIxCalEffic].Effic4;
    m_ListShiftEffic.Add(ShiftEffic);


    qry.Next
  end;

  qry.Close;
  qry.Free;
end;

//----------------------------------------------------------------------------//

constructor TPGCALObjMqm.CreateByRes(const CalKey: string; const ResKey: string);
var
  qry: TMqmQuery;
  tbInfo:  ^TTblInfo;
  I, HoursPerDay : integer;
  SavedJPRGWH : currency;
  CurrentDate : TDateTime;
  ShiftEffic : PTShiftEffic;
begin
  inherited CreateByRes(CalKey, ResKey);
  tbInfo := @tblInfo[tbl_calendar];

  m_JCDCAL := ResKey;
  qry := CreateQuery(Main_DB);

  //WARNING THE FIELDS OF THIS QUERY ARE ACCESSED BY INDEX!
  qry.SQL.Add('select ');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_CalDate) + ','); //Kcaldt
//  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_Prog_Wrk_Hr) + ',');  //KPRGHW
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH1_start) + ','); //KINZT1
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH1_end) + ','); //KFINT1
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH2_start) + ','); //KINZT2
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH2_end) + ','); //KFINT2
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH3_start) + ','); //KINZT3
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH3_end) + ','); //KFINT3
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH4_start) + ','); //KINZT4
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH4_end)); //KFINT4
  qry.SQL.Add(' from ' + tbInfo.GetTableName);
  qry.SQL.Add(' where (' + CreateFld(tbInfo.pfx, fli_CalCod) + ' = ');
  qry.SQL.Add('''' + CalKey + '''');
  if IniAppGlobals.DownloadTo = '2' then
    qry.SQL.Add(') and (' + CreateFld(tbInfo.pfx, fli_CalDate) + ' >= ''' + FormatDateMMDDYYYYWithSlash(DBAppGlobals.StDateForPlan) + '''')
  else
    qry.SQL.Add(') and (' + CreateFld(tbInfo.pfx, fli_CalDate) +  ' >= ' + ConvertDateFormatDb2Oracle(DBAppGlobals.StDateForPlan, true, true));
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.SQL.Add(') order by ' + CreateFld(tbInfo.pfx, fli_CalDate));
  qry.Open;

  SavedJPRGWH := 0;
  m_startDate := trunc(DBAppGlobals.StDateForPlan);
  CurrentDate := DBAppGlobals.StDateForPlan - 1;
  m_lastIx := -1;
  while CurrentDate < DBAppGlobals.EndDateForPlan do
  begin
    CurrentDate := CurrentDate + 1;
    Inc(m_lastIx);
    with m_calendar[m_lastIx] do
    begin
      if (not qry.EOF) and (FormatDateTime(FormatSettings.ShortDateFormat, CurrentDate) = qry.Fields[0].asString) then
      begin
        shift[1].start := qry.Fields[1].AsInteger;
        shift[1].dur   := qry.Fields[2].AsInteger - shift[1].start;
        shift[2].start := qry.Fields[3].AsInteger;
        shift[2].dur   := qry.Fields[4].AsInteger - shift[2].start;
        shift[3].start := qry.Fields[5].AsInteger;
        shift[3].dur   := qry.Fields[6].AsInteger - shift[3].start;
        shift[4].start := qry.Fields[7].AsInteger;
        shift[4].dur   := qry.Fields[8].AsInteger - shift[4].start;
        JNUMWH := (shift[1].dur+shift[2].dur+shift[3].dur+shift[4].dur)/60;
        HoursPerDay := trunc(100 * JNUMWH);
        SavedJPRGWH := SavedJPRGWH + (HoursPerDay / 100);
        JPRGWH := SavedJPRGWH;
        DateModified := false;
        DateNew := false;
        qry.Next;
      end
      else
      begin
        SavedJPRGWH := SavedJPRGWH + 24;
        JPRGWH := SavedJPRGWH;
        shift[1].start := 0;
        shift[1].dur   := 1440;
        shift[2].start := 0;
        shift[2].dur   := 0;
        shift[3].start := 0;
        shift[3].dur   := 0;
        shift[4].start := 0;
        shift[4].dur   := 0;
        JNUMWH := 24;
        DateModified := false;
        DateNew := true;
      end;
    end;
  end;

  tbInfo := @tblInfo[tbl_calShiftEffic];
//  SetFldPfx(tbInfo.pfx);

  qry.SQL.Clear;
  qry.SQL.Add('select ');
//  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_rsc) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_CalStartDate) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_CalEndDate) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH1_start) + ','); //KINZT1
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH1_end) + ','); //KFINT1
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH1_EFFIC) + ','); //KFINT1
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH2_start) + ','); //KINZT2
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH2_end) + ','); //KFINT2
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH2_EFFIC) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH3_start) + ','); //KINZT3
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH3_end) + ','); //KFINT3
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH3_EFFIC) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH4_start) + ','); //KINZT4
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH4_end)   + ','); //KFINT4
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH4_EFFIC));

  qry.SQL.Add(' from ' + tbInfo.GetTableName);
  qry.SQL.Add(' where (' + CreateFld(tbInfo.pfx, fli_CalCod) + ' = ');
  qry.SQL.Add('''' + CalKey + '''');

  qry.SQL.Add(') AND (' + CreateFld(tbInfo.pfx, fli_rsc) + ' = ');
  qry.SQL.Add('''' + ResKey + '''');

{  if IniAppGlobals.DownloadTo = '2' then
    qry.SQL.Add(') and (' + CreateFld(tbInfo.pfx, fli_CalStartDate) + ' >= ''' + FormatDateMMDDYYYYWithSlash(DBAppGlobals.StDateForPlan) + '''')
  else
    qry.SQL.Add(') and (' + CreateFld(tbInfo.pfx, fli_CalStartDate) + ' >= ' + ConvertDateFormatDb2Oracle(DBAppGlobals.StDateForPlan, true, true));
}
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.SQL.Add(') order by ' + CreateFld(tbInfo.pfx, fli_CalStartDate));
  qry.Open;

//  if not qry.EOF then
  m_ListShiftEffic := TList.Create;

  m_lastIxCalEffic := -1;
  while not qry.EOF do
  begin
    if m_lastIxCalEffic >= (PGCALElemMax-1) then break;

    Inc(m_lastIxCalEffic);
    with m_ShiftEffic[m_lastIxCalEffic] do
    begin
      StartDate := Trunc(qry.Fields[0].AsDateTime);
      EndDate   := Trunc(qry.Fields[1].AsDateTime);
      StartMinute1 := qry.Fields[2].AsInteger;
      EndMinute1   := qry.Fields[3].AsInteger;
      Effic1       := qry.Fields[4].AsInteger;
      StartMinute2 := qry.Fields[5].AsInteger;
      EndMinute2   := qry.Fields[6].AsInteger;
      Effic2       := qry.Fields[7].AsInteger;
      StartMinute3 := qry.Fields[8].AsInteger;
      EndMinute3   := qry.Fields[9].AsInteger;
      Effic3       := qry.Fields[10].AsInteger;
      StartMinute4 := qry.Fields[11].AsInteger;
      EndMinute4   := qry.Fields[12].AsInteger;
      Effic4       := qry.Fields[13].AsInteger;
    end;

    new(ShiftEffic);
    ShiftEffic.StartDate    := m_ShiftEffic[m_lastIxCalEffic].StartDate;
    ShiftEffic.EndDate      := m_ShiftEffic[m_lastIxCalEffic].EndDate;
    ShiftEffic.StartMinute1 := m_ShiftEffic[m_lastIxCalEffic].StartMinute1;
    ShiftEffic.EndMinute1   := m_ShiftEffic[m_lastIxCalEffic].EndMinute1;
    ShiftEffic.Effic1       := m_ShiftEffic[m_lastIxCalEffic].Effic1;
    ShiftEffic.StartMinute2 := m_ShiftEffic[m_lastIxCalEffic].StartMinute2;
    ShiftEffic.EndMinute2   := m_ShiftEffic[m_lastIxCalEffic].EndMinute2;
    ShiftEffic.Effic2       := m_ShiftEffic[m_lastIxCalEffic].Effic2;
    ShiftEffic.StartMinute3 := m_ShiftEffic[m_lastIxCalEffic].StartMinute3;
    ShiftEffic.EndMinute3   := m_ShiftEffic[m_lastIxCalEffic].EndMinute3;
    ShiftEffic.Effic3       := m_ShiftEffic[m_lastIxCalEffic].Effic3;
    ShiftEffic.StartMinute4 := m_ShiftEffic[m_lastIxCalEffic].StartMinute4;
    ShiftEffic.EndMinute4   := m_ShiftEffic[m_lastIxCalEffic].EndMinute4;
    ShiftEffic.Effic4       := m_ShiftEffic[m_lastIxCalEffic].Effic4;
    m_ListShiftEffic.Add(ShiftEffic);


    qry.Next
  end;
  qry.Close;
  qry.Free;

end;

constructor TPGCALObjMqm.CreateCalByResLvel(const CalKey, ResKey: string);
var
  qry: TMqmQuery;
  tbInfo:  ^TTblInfo;
  I ,HoursPerDay : integer;
  CurrentDate : TDateTime;
  SavedJPRGWH : currency;
  ShiftEffic : PTShiftEffic;
  ResKeyTemp : string;
begin
  inherited CreateCalByResLvel(CalKey, ResKey);
  tbInfo := @tblInfo[tbl_ResCal];

  m_JCDCAL := ResKey;
  qry := CreateQuery(Main_DB);

  //WARNING THE FIELDS OF THIS QUERY ARE ACCESSED BY INDEX!
  qry.SQL.Add('select ');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_CalDate) + ','); //Kcaldt
//  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_Prog_Wrk_Hr) + ',');  //KPRGHW
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH1_start) + ','); //KINZT1
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH1_end) + ','); //KFINT1
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH2_start) + ','); //KINZT2
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH2_end) + ','); //KFINT2
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH3_start) + ','); //KINZT3
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH3_end) + ','); //KFINT3
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH4_start) + ','); //KINZT4
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH4_end)); //KFINT4
  qry.SQL.Add(' from ' + tbInfo.GetTableName);
  qry.SQL.Add(' where (' + CreateFld(tbInfo.pfx, fli_CalCod) + ' = ');
  qry.SQL.Add('''' + CalKey + '''');
  qry.SQL.Add(' and ' + CreateFld(tbInfo.pfx, fli_rsc) + ' = ''' + ResKey + '''');
  if IniAppGlobals.DownloadTo = '2' then
    qry.SQL.Add(') and (' + CreateFld(tbInfo.pfx, fli_CalDate) + ' >= ''' + FormatDateMMDDYYYYWithSlash(DBAppGlobals.StDateForPlan) + '''')
  else
    qry.SQL.Add(') and (' + CreateFld(tbInfo.pfx, fli_CalDate) +  ' >= ' + ConvertDateFormatDb2Oracle(DBAppGlobals.StDateForPlan, true, true));
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.SQL.Add(') order by ' + CreateFld(tbInfo.pfx, fli_CalDate));
  qry.Open;

  SavedJPRGWH := 0;
  m_startDate := trunc(DBAppGlobals.StDateForPlan);
  CurrentDate := DBAppGlobals.StDateForPlan - 1;
  m_lastIx := -1;
  while CurrentDate < DBAppGlobals.EndDateForPlan do
  begin
    CurrentDate := CurrentDate + 1;
    Inc(m_lastIx);
    with m_calendar[m_lastIx] do
    begin
      if (not qry.EOF) and (Formatdatetime(FormatSettings.ShortDateFormat,CurrentDate) = qry.Fields[0].asString) then
      begin
        shift[1].start := qry.Fields[1].AsInteger;
        shift[1].dur   := qry.Fields[2].AsInteger - shift[1].start;
        shift[2].start := qry.Fields[3].AsInteger;
        shift[2].dur   := qry.Fields[4].AsInteger - shift[2].start;
        shift[3].start := qry.Fields[5].AsInteger;
        shift[3].dur   := qry.Fields[6].AsInteger - shift[3].start;
        shift[4].start := qry.Fields[7].AsInteger;
        shift[4].dur   := qry.Fields[8].AsInteger - shift[4].start;
        JNUMWH := (shift[1].dur+shift[2].dur+shift[3].dur+shift[4].dur)/60;
        HoursPerDay := trunc(100 * JNUMWH);
        SavedJPRGWH := SavedJPRGWH + (HoursPerDay / 100);
        JPRGWH := SavedJPRGWH;
        DateModified := false;
        DateNew := false;
        qry.Next;
      end
      else
      begin
        SavedJPRGWH := SavedJPRGWH + 24;
        JPRGWH := SavedJPRGWH;
        shift[1].start := 0;
        shift[1].dur   := 1440;
        shift[2].start := 0;
        shift[2].dur   := 0;
        shift[3].start := 0;
        shift[3].dur   := 0;
        shift[4].start := 0;
        shift[4].dur   := 0;
        JNUMWH := 24;
        DateModified := false;
        DateNew := true;
      end;
    end;
  end;

  tbInfo := @tblInfo[tbl_calShiftEffic];
//  SetFldPfx(tbInfo.pfx);


  ResKeyTemp := copy(ResKey,1 ,8);
        qry.SQL.Clear;

  qry.SQL.Clear;
  qry.SQL.Add('select ');
//  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_rsc) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_CalStartDate) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_CalEndDate) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH1_start) + ','); //KINZT1
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH1_end) + ','); //KFINT1
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH1_EFFIC) + ','); //KFINT1
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH2_start) + ','); //KINZT2
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH2_end) + ','); //KFINT2
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH2_EFFIC) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH3_start) + ','); //KINZT3
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH3_end) + ','); //KFINT3
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH3_EFFIC) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH4_start) + ','); //KINZT4
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH4_end)   + ','); //KFINT4
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH4_EFFIC));

  qry.SQL.Add(' from ' + tbInfo.GetTableName);
  qry.SQL.Add(' where (' + CreateFld(tbInfo.pfx, fli_CalCod) + ' = ');
  qry.SQL.Add('''' + CalKey + '''');

  qry.SQL.Add(') AND (' + CreateFld(tbInfo.pfx, fli_rsc) + ' = ');
  qry.SQL.Add('''' + ResKeyTemp + '''');

{  if IniAppGlobals.DownloadTo = '2' then
    qry.SQL.Add(') and (' + CreateFld(tbInfo.pfx, fli_CalStartDate) + ' >= ''' + FormatDateMMDDYYYYWithSlash(DBAppGlobals.StDateForPlan) + '''')
  else
    qry.SQL.Add(') and (' + CreateFld(tbInfo.pfx, fli_CalStartDate) + ' >= ' + ConvertDateFormatDb2Oracle(DBAppGlobals.StDateForPlan, true, true));
}
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.SQL.Add(') order by ' + CreateFld(tbInfo.pfx, fli_CalStartDate));
  qry.Open;

//  if not qry.EOF then
  m_ListShiftEffic := TList.Create;

  m_lastIxCalEffic := -1;
  while not qry.EOF do
  begin
    if m_lastIxCalEffic >= (PGCALElemMax-1) then break;

    Inc(m_lastIxCalEffic);
    with m_ShiftEffic[m_lastIxCalEffic] do
    begin
      StartDate := Trunc(qry.Fields[0].AsDateTime);
      EndDate   := Trunc(qry.Fields[1].AsDateTime);
      StartMinute1 := qry.Fields[2].AsInteger;
      EndMinute1   := qry.Fields[3].AsInteger;
      Effic1       := qry.Fields[4].AsInteger;
      StartMinute2 := qry.Fields[5].AsInteger;
      EndMinute2   := qry.Fields[6].AsInteger;
      Effic2       := qry.Fields[7].AsInteger;
      StartMinute3 := qry.Fields[8].AsInteger;
      EndMinute3   := qry.Fields[9].AsInteger;
      Effic3       := qry.Fields[10].AsInteger;
      StartMinute4 := qry.Fields[11].AsInteger;
      EndMinute4   := qry.Fields[12].AsInteger;
      Effic4       := qry.Fields[13].AsInteger;
    end;

    new(ShiftEffic);
    ShiftEffic.StartDate    := m_ShiftEffic[m_lastIxCalEffic].StartDate;
    ShiftEffic.EndDate      := m_ShiftEffic[m_lastIxCalEffic].EndDate;
    ShiftEffic.StartMinute1 := m_ShiftEffic[m_lastIxCalEffic].StartMinute1;
    ShiftEffic.EndMinute1   := m_ShiftEffic[m_lastIxCalEffic].EndMinute1;
    ShiftEffic.Effic1       := m_ShiftEffic[m_lastIxCalEffic].Effic1;
    ShiftEffic.StartMinute2 := m_ShiftEffic[m_lastIxCalEffic].StartMinute2;
    ShiftEffic.EndMinute2   := m_ShiftEffic[m_lastIxCalEffic].EndMinute2;
    ShiftEffic.Effic2       := m_ShiftEffic[m_lastIxCalEffic].Effic2;
    ShiftEffic.StartMinute3 := m_ShiftEffic[m_lastIxCalEffic].StartMinute3;
    ShiftEffic.EndMinute3   := m_ShiftEffic[m_lastIxCalEffic].EndMinute3;
    ShiftEffic.Effic3       := m_ShiftEffic[m_lastIxCalEffic].Effic3;
    ShiftEffic.StartMinute4 := m_ShiftEffic[m_lastIxCalEffic].StartMinute4;
    ShiftEffic.EndMinute4   := m_ShiftEffic[m_lastIxCalEffic].EndMinute4;
    ShiftEffic.Effic4       := m_ShiftEffic[m_lastIxCalEffic].Effic4;
    m_ListShiftEffic.Add(ShiftEffic);


    qry.Next
  end;
  qry.Close;
  qry.Free;
end;

end.
