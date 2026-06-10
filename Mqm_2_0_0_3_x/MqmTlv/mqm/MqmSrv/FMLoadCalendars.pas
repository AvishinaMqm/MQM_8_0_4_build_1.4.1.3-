unit FMLoadCalendars;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, CheckLst, UMGlobal;

type
  TFDloadCalendars = class(TForm)
    CkLstBoxCal: TCheckListBox;
    DtPFromDate: TDateTimePicker;
    Panel1: TPanel;
    BtnOk: TBitBtn;
    BtnAbo: TBitBtn;
    LblSelCal: TLabel;
    LblFromDate: TLabel;
    CBCalSelection: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure CBCalSelectionClick(Sender: TObject);
  private
    { Private declarations }
    function  LoadCalendar(CalCod: string; FromDate: TDate) : boolean;
    function  LoadCalendarOnResourceLevel(CalCod: string; FromDate: TDate) : boolean;
    procedure UpdateEfficiencyOnResLevel(CalCod: string);
    function  CheckCalendarOnResourceLevel(Cal : String)  : boolean;
    procedure UpdateCalendarProgress(CalCod: string);
    procedure UpdateCalendarOnResLevelProgress(CalCod: string);
  public
    { Public declarations }
  end;

  type RCal = Record
    Identifier : Integer;
    CalCode : String;
    CalDate : TDate;
    Prog_Wrk_Hr : Double;
    SH1_start : Integer;
    SH1_end : Integer;
    SH2_start : Integer;
    SH2_end : Integer;
    SH3_start  : Integer;
    SH3_end : Integer;
    SH4_start : Integer;
    SH4_end  : Integer;
  end;
  tCal = ^RCal;

var
  FDloadCalendars: TFDloadCalendars;

implementation

uses
  DMsrvPc,
  UMTblDesc,
  UMLoad,
  UMsrvLoad,
  UMSaveLoad,
  UGBaseCal,
  UGconvert,
  UMCommon,
  UMSrvConfig,
  gnugettext, DB;

{$R *.DFM}


function InsertTable(tbl: table; linkArr: array of TQryLinkRec; srvQry: TMqmQuery) : boolean;
var
  tbInfo:         ^TTblInfo;
  I : Integer;
  sl : TStringList;
  GenSql : string;
  DndArchiveLocalName : TDndArchiveName;
begin
  Result := true;
  tbInfo := @tblInfo[tbl];
  DndArchiveLocalName := GetDndArchiveLocalName;

  with srvQry do
  begin
    GenSql := '';
    GenSql := GenSql + ' insert into ' + tbInfo.GetTableName + ' (';
    for i := 0 to High(linkArr)-1 do
      GenSql := GenSql + '"' + CreateFld(tbInfo.pfx, linkArr[i].fldPC) + '"' + ',';
    GenSql := GenSql + '"' + CreateFld(tbInfo.pfx, linkArr[High(linkArr)].fldPC) + '"';
    GenSql := GenSql + ') values (';
    SQL.Clear;
    Sql.Add(GenSql);
    Application.ProcessMessages;
  end;

end;

//----------------------------------------------------------------------------//

procedure TFDloadCalendars.CBCalSelectionClick(Sender: TObject);
var
  I : Integer;
  Selection : boolean;
begin
  Selection := CBCalSelection.Checked;
  for i := 0 to CkLstBoxCal.Items.Count -1 do
    CkLstBoxCal.Checked[i] := Selection
end;

//----------------------------------------------------------------------------//

procedure TFDloadCalendars.FormCreate(Sender: TObject);
var
  HostQry:  TMqmQuery;
  TempStr: string;
  DndArchiveLocalName, DndArchiveHostName : TDndArchiveName;
  ArcQry :  TMqmQuery;
  TableName : string;
begin
  TranslateComponent(self);
  DndArchiveLocalName := GetDndArchivelocalName;

  TableName := 'CAL';

  if DndArchiveLocalName <> TD_Interbase then
    TableName  := 'SCDA_CAL';

  DndArchiveHostName := GetDndArchiveHostName;

  if DndArchiveHostName = TD_AS_400 then
  begin
    HostQry  := CreateQueryHost;
     HostQry.SQL.Clear;
    HostQry.SQL.Add('SELECT * FROM TABLE01L ');
    HostQry.SQL.Add('WHERE TABLE = ''CALD''');
    HostQry.SQL.Add('AND KEY LIKE ''    %''');
    HostQry.Open;
    while not HostQry.EOF do
    begin
      TempStr := copy(HostQry.FieldByName('KEY').AsString, 5, 3) + ' ';
      TempStr := TempStr + copy(HostQry.FieldByName('DATA').AsString, 0, 30);
      CkLstBoxCal.Items.Add(TempStr);
      HostQry.Next
    end;
    HostQry.Free
  end
  else
  begin
    if not IsArcDbConnected then
       ArcDbConnect;
    ArcQry := CreateQueryArc;
    ArcQry.SQL.Add('SELECT * FROM ' + TableName);
    ArcQry.SQL.Add(WHERE_IDF_Condition('CL_IDENTIFIER'));
    ArcQry.Open;
    while not ArcQry.EOF do
    begin
      TempStr := ArcQry.FieldByName('CL_CAL').AsString + ' ';
      TempStr := TempStr + ArcQry.FieldByName('CL_S_DESCR').AsString;
      CkLstBoxCal.Items.Add(TempStr);
      ArcQry.Next
    end;
    ArcQry.free;
  end;

  DtPFromDate.Date := now;
end;

//----------------------------------------------------------------------------//

procedure TFDloadCalendars.BtnOkClick(Sender: TObject);
var
  OneSelected: boolean;
  i: integer;
  DndArchiveHostName : TDndArchiveName;
  Save_Cursor : TCursor;
begin
  OneSelected := false;
  Save_Cursor   := Screen.Cursor;
  Screen.Cursor  := crAppStart; //SQLWait;
  DndArchiveHostName := GetDndArchiveHostName;
  // Check at lest one calendar selected
  for i := 0 to CkLstBoxCal.Items.Count -1 do
    if CkLstBoxCal.Checked[i] then
    begin
      OneSelected := True;
      break
    end;

  if not OneSelected then
  begin
    ShowMessage(_('Select at least one calendar'));
    ModalResult := mrNone;
  end else
  begin
    ModalResult := mrOk;
  end;

  for i := 0 to CkLstBoxCal.Items.Count -1 do
    if CkLstBoxCal.Checked[i] then
      begin
        if LoadCalendar(Copy(CkLstBoxCal.Items[i], 0, 3), DtPFromDate.Date) then
        begin
          if (DndArchiveHostName <> TD_AS_400) then
          begin
            UpdateEfficiencyOnResLevel(Copy(CkLstBoxCal.Items[i], 0, 3));

            if CheckCalendarOnResourceLevel(Copy(CkLstBoxCal.Items[i], 0, 3)) then
               LoadCalendarOnResourceLevel(Copy(CkLstBoxCal.Items[i], 0, 3), DtPFromDate.Date);
          end;
        end;
      end;

  Screen.Cursor := Save_Cursor;
end;

//----------------------------------------------------------------------------//

function TFDloadCalendars.LoadCalendar(CalCod: string; FromDate: TDate) : boolean;
var
  srvQry: TMqmQuery;
  srvTrs: TMqmTransaction;
  HostQry:  TMqmQuery;
  tbInfo: ^TTblInfo;
  fldF:   double;
  fldI:   integer;
  DndArchiveHostName, DndArchiveLocalName : TDndArchiveName;
  ArcQry :  TMqmQuery;
  TableNameLocal, TableNameArc : string;
  LocQry : TMqmQuery;
  Cal : tCal;
  CalList : TList;
begin
  Result := false;
  CalList := Tlist.Create;

  DndArchiveHostName := GetDndArchiveHostName;
  DndArchiveLocalName := GetDndArchiveLocalName;
  if not IsLocalDbConnected then
    LocalDbConnect(true);
  LocQry := CreateQuery(Main_DB);
  LocQry.Transaction := CreateTransaction(Main_DB);
  LocQry.Transaction.StartTransaction;

  TableNameArc := 'CALENDAR';
  TableNameLocal := 'CALENDAR';
  ArcQry := CreateQueryArc;
  ArcQry.Transaction := CreateTransaction(Arc_DB);
 // ArcQry.Transaction.StartTransaction;

//  if DndArchiveHostName <> TD_AS_400 then
//  begin
//    TableNameArc  := 'SCDA_CALENDAR';
//  end;

  if (DndArchiveLocalName = TD_Db2) or (DndArchiveLocalName = TD_Oracle) then
  begin
    TableNameLocal  := 'SCDM_CALENDAR';
    TableNameArc    := 'SCDA_CALENDAR';
  end;

  tbInfo := @tblInfo[tbl_calendar];
 // SetFldPfx(tbInfo.pfx);

  if DndArchiveHostName = TD_AS_400 then
  begin
    HostQry  := CreateQueryHost;
    HostQry.SQL.Clear;
    HostQry.SQL.Add('Select * from ' + tbInfo.ASname );
    HostQry.SQL.Add(' Where ');
    HostQry.SQL.Add('KCDCAL = ''' + CalCod + '''');
    HostQry.SQL.Add(' And ');
    HostQry.SQL.Add('KCALDT >= ' + FloatToStr(DateTimeToTimDate(FromDate)));
    HostQry.SQL.Add(' And ');
    HostQry.SQL.Add('KANNUL <> ''A''');
    HostQry.Open;
  end
  else
  begin
     Application.ProcessMessages;
    ArcQry.SQL.Add('Select * from ' + TableNameArc);
    ArcQry.SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_CalCod) + '=');
    ArcQry.SQL.Add('''' + CalCod + '''');
    ArcQry.SQL.Add(' And ');
    if DndArchiveLocalName = TD_Interbase then
      ArcQry.SQL.Add(CreateFld(tbInfo.pfx, fli_CalDate) + '>=' + ''''+ MQMformatDate(FromDate) + '''')
    else                                                                                              //  ConvertDateFormatDb2Oracle(DBAppGlobals.StDateForPlan, true, true));
      ArcQry.SQL.Add(CreateFld(tbInfo.pfx, fli_CalDate) + '>= ' + ConvertDateFormatDb2Oracle(Trunc(FromDate), true, true ));
    //  ArcQry.SQL.Add(' TO_CHAR(' + CreatePfxFld(fli_CalDate) + ', ' + QuotedStr('YYYYMMDD') + ') >= ' + ConvertDateFormatToYYYYMMDD(Trunc(FromDate), StrToInt(IniAppGlobals.DownloadTo)));
    ArcQry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier)));
    ArcQry.Open;
  end;

  var CalCode_Field :=  ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_CalCod));
  var CalDate_Field := ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_CalDate));
  var Prog_Wrk_Hr_Field := ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_Prog_Wrk_Hr));
  var SH1_start_Field := ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_SH1_start));
  var SH1_End_Field := ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_SH1_End));
  var SH2_start_Field := ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_SH2_start));
  var SH2_End_Field := ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_SH2_End));
  var SH3_start_Field := ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_SH3_start));
  var SH3_End_Field := ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_SH3_End));
  var SH4_start_Field := ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_SH4_start));
  var SH4_End_Field := ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_SH4_End));
  // Old Part
 { if ArcQry.RecordCount = 0 then
  begin
    LocQry.SQL.Clear;
    LocQry.SQL.Text := 'Delete from ' + TableNameLocal
      + ' where ' + CreateFld(tbInfo.pfx, fli_identifier)+' = '+IniAppGlobals.Identifier;
  end }
  LocQry.SQL.Clear;
  LocQry.SQL.Add('Delete from ' + TableNameLocal);
  LocQry.SQL.Add(' Where ');
  LocQry.SQL.Add(CreateFld(tbInfo.pfx, fli_CalCod) + ' = ''' + CalCod + '''');
  LocQry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier)));
  LocQry.SQL.Add(' And ');
  if DndArchiveLocalName = TD_Oracle then
    LocQry.SQL.Add(' TO_CHAR(' + CreateFld(tbInfo.pfx, fli_CalDate) + ', ' + QuotedStr('YYYYMMDD') + ') >= ' + ConvertDateFormatToYYYYMMDD(Trunc(FromDate), StrToInt(IniAppGlobals.DownloadTo)))
  else if DndArchiveLocalName =  TD_Interbase then
    LocQry.SQL.Add(CreateFld(tbInfo.pfx, fli_CalDate) + ' >= ' + ConvertDateFormatTo(Trunc(FromDate), TD_Interbase))
  else
    LocQry.SQL.Add(' varchar_format(' + CreateFld(tbInfo.pfx, fli_CalDate) + ', ' + QuotedStr('YYYYMMDD') + ') >= ' + ConvertDateFormatToYYYYMMDD(Trunc(FromDate), StrToInt(IniAppGlobals.DownloadTo)));

  try
    LocQry.ExecSQL;
    LocQry.Transaction.Commit;
  except
    LocQry.Connection.Rollback;
    raise;
  end;

  Application.ProcessMessages;
  LocQry.SQL.Clear;
  LocQry.Transaction.StartTransaction;
  LocQry.SQL.Add('Insert into ' + TableNameLocal + ' (');
  LocQry.SQL.Add(CreateFld(tbInfo.pfx, fli_IDENTIFIER)   + ', ');
  LocQry.SQL.Add(CreateFld(tbInfo.pfx, fli_CalCod)       + ', ');
  LocQry.SQL.Add(CreateFld(tbInfo.pfx, fli_CalDate)      + ', ');
  LocQry.SQL.Add(CreateFld(tbInfo.pfx, fli_Prog_Wrk_Hr)  + ', '); //KPRGHW
  LocQry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH1_start)    + ', '); //KINZT1
  LocQry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH1_end)      + ', '); //KFINT1
  LocQry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH2_start)    + ', '); //KINZT2
  LocQry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH2_end)      + ', '); //KFINT2
  LocQry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH3_start)    + ', '); //KINZT3
  LocQry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH3_end)      + ', '); //KFINT3
  LocQry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH4_start)    + ', '); //KINZT4
  LocQry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH4_end)); //KFINT4
  LocQry.SQL.Add(') values (');
  LocQry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_IDENTIFIER)  + ', ');
  LocQry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_CalCod)      + ', ');
  LocQry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_CalDate)     + ', ');
  LocQry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Prog_Wrk_Hr) + ', '); //KPRGHW
  LocQry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_SH1_start)   + ', '); //KINZT1
  LocQry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_SH1_end)     + ', '); //KFINT1
  LocQry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_SH2_start)   + ', '); //KINZT2
  LocQry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_SH2_end)     + ', '); //KFINT2
  LocQry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_SH3_start)   + ', '); //KINZT3
  LocQry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_SH3_end)     + ', '); //KFINT3
  LocQry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_SH4_start)   + ', '); //KINZT4
  LocQry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_SH4_end)); //KFINT4
  LocQry.SQL.Add(')');


  if DndArchiveHostName = TD_AS_400 then
  begin

    while not HostQry.EOF do
    begin
      Result := true;
      if (DndArchiveHostName = TD_AS_400) then
      begin
        LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsString  := IniAppGlobals.Identifier;
        LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_CalCod)).AsString := trim(HostQry.FieldByName('KCDCAL').AsString);
        LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_CalDate)).AsDate := TruncToDayDate(TimDateToDateTime(HostQry.FieldByName('KCALDT').AsFloat));
        LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_Prog_Wrk_Hr)).AsFloat := HostQry.FieldByName('KPRGWH').AsFloat;
        fldF := HostQry.FieldByName('KINZT1').AsFloat;
        fldI := Trunc(HostQry.FieldByName('KINZT1').AsFloat/100);
        LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_SH1_start)).AsInteger := fldI*60 + Trunc(fldF-fldI*100);
        fldF := HostQry.FieldByName('KFINT1').AsFloat;
        fldI := Trunc(HostQry.FieldByName('KFINT1').AsFloat/100);
        LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_SH1_end)).AsInteger := fldI*60 + Trunc(fldF-fldI*100);
        fldF := HostQry.FieldByName('KINZT2').AsFloat;
        fldI := Trunc(HostQry.FieldByName('KINZT2').AsFloat/100);
        LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_SH2_start)).AsInteger := fldI*60 + Trunc(fldF-fldI*100);
        fldF := HostQry.FieldByName('KFINT2').AsFloat;
        fldI := Trunc(HostQry.FieldByName('KFINT2').AsFloat/100);
        LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_SH2_end)).AsInteger := fldI*60 + Trunc(fldF-fldI*100);
        fldF := HostQry.FieldByName('KINZT3').AsFloat;
        fldI := Trunc(HostQry.FieldByName('KINZT3').AsFloat/100);
        LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_SH3_start)).AsInteger := fldI*60 + Trunc(fldF-fldI*100);
        fldF := HostQry.FieldByName('KFINT3').AsFloat;
        fldI := Trunc(HostQry.FieldByName('KFINT3').AsFloat/100);
        LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_SH3_end)).AsInteger := fldI*60 + Trunc(fldF-fldI*100);
        fldF := HostQry.FieldByName('KINZT4').AsFloat;
        fldI := Trunc(HostQry.FieldByName('KINZT4').AsFloat/100);
        LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_SH4_start)).AsInteger := fldI*60 + Trunc(fldF-fldI*100);
        fldF := HostQry.FieldByName('KFINT4').AsFloat;
        fldI := Trunc(HostQry.FieldByName('KFINT4').AsFloat/100);
        LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_SH4_end)).AsInteger := fldI*60 + Trunc(fldF-fldI*100);
      end;
      LocQry.ExecSql;
      HostQry.Next

    end

  end
  else
  begin
    while not ArcQry.EOF do
    begin
      Result := true;
      New(Cal);
      Cal.Identifier := StrToInt(IniAppGlobals.Identifier);
      Cal.CalCode := CalCode_Field.asString;
      Cal.CalDate := CalDate_Field.AsDateTime;
      Cal.Prog_Wrk_Hr := Prog_Wrk_Hr_Field.AsFloat;
      Cal.SH1_start := SH1_start_Field.AsInteger;
      Cal.SH1_End := SH1_End_Field.AsInteger;
      Cal.SH2_start := SH2_start_Field.AsInteger;
      Cal.SH2_End := SH2_End_Field.AsInteger;
      Cal.SH3_start := SH3_start_Field.AsInteger;
      Cal.SH3_End := SH3_End_Field.AsInteger;
      Cal.SH4_start := SH4_start_Field.AsInteger;
      Cal.SH4_End := SH4_End_Field.AsInteger;
      Application.ProcessMessages;
      CalList.Add(Cal);

      {LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsString  := ;
      LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_CalCod)).AsString := trim(ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_CalCod)).AsString);
      LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_CalDate)).AsDate :=  ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_CalDate)).AsDateTime;
      LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_Prog_Wrk_Hr)).AsFloat := ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_Prog_Wrk_Hr)).AsFloat;
      LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_SH1_start)).AsInteger := ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_SH1_start)).AsInteger;
      LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_SH1_end)).AsInteger := ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_SH1_end)).AsInteger;
      LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_SH2_start)).AsInteger := ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_SH2_start)).AsInteger;
      LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_SH2_end)).AsInteger := ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_SH2_end)).AsInteger;
      LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_SH3_start)).AsInteger := ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_SH3_start)).AsInteger;
      LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_SH3_end)).AsInteger := ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_SH3_end)).AsInteger;
      LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_SH4_start)).AsInteger := ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_SH4_start)).AsInteger;
      LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_SH4_end)).AsInteger := ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_SH4_end)).AsInteger;
      LocQry.ExecSql;   }
      ArcQry.Next
    end;
  end;

  var i := 0;

  try

  for i  := 0 to CalList.Count -1	 do
  begin
    Application.ProcessMessages;
    LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).asInteger  := TCal(CalList[i]).Identifier;
    LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_CalCod)).AsString := trim(TCal(CalList[i]).CalCode);
    LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_CalDate)).AsDate :=  TCal(CalList[i]).CalDate;
    LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_Prog_Wrk_Hr)).AsFloat := TCal(CalList[i]).Prog_Wrk_Hr;
    LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_SH1_start)).AsInteger :=  TCal(CalList[i]).SH1_start;
    LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_SH1_end)).AsInteger := TCal(CalList[i]).SH1_end;
    LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_SH2_start)).AsInteger := TCal(CalList[i]).SH2_start;
    LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_SH2_end)).AsInteger := TCal(CalList[i]).SH2_end;;
    LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_SH3_start)).AsInteger := TCal(CalList[i]).SH3_start;
    LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_SH3_end)).AsInteger := TCal(CalList[i]).SH3_end;;
    LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_SH4_start)).AsInteger := TCal(CalList[i]).SH4_start;
    LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_SH4_end)).AsInteger := TCal(CalList[i]).SH4_end;;
    LocQry.ExecSql;
  end;

  LocQry.Transaction.Commit;
  LocQry.Connection.FetchOptions.AutoFetchAll;
  except
    LocQry.Connection.Rollback;
    raise;
  end;

  LocQry.Close;
  LocQry.Free;

 // ArcQry.Transaction.commit;
 // ArcQry.Connection.FetchOptions.AutoFetchAll;
  ArcQry.Close;
  ArcQry.free;


  for I := CalList.Count - 1 downto 0 do
    dispose(tCal(CalList[I]));

  CalList.Free;
  //  HostQry.Free;
//  end;


  UpdateCalendarProgress(CalCod);

end;

//----------------------------------------------------------------------------//

function TFDloadCalendars.LoadCalendarOnResourceLevel(CalCod: string; FromDate: TDate) : boolean;
var
  srvQry: TMqmQuery;
  srvTrs: TMqmTransaction;
  HostQry:  TMqmQuery;
  tbInfo: ^TTblInfo;
  fldF:   double;
  fldI:   integer;
  DndArchiveHostName, DndArchiveLocalName : TDndArchiveName;
  ArcQry :  TMqmQuery;
  TableNameLocal, TableNameArc : string;
  LocQry : TMqmQuery;
begin
  Result := false;
  DndArchiveHostName := GetDndArchiveHostName;
  DndArchiveLocalName := GetDndArchiveLocalName;
  if not IsLocalDbConnected then
    LocalDbConnect(true);
  LocQry := CreateQuery(Main_DB);
  LocQry.Transaction := CreateTransaction(Main_DB);
  LocQry.Transaction.StartTransaction;

  TableNameArc := 'RESCAL';
  TableNameLocal := 'RESCAL';
  ArcQry := CreateQueryArc;
  ArcQry.Transaction := CreateTransaction(Arc_DB);
 // ArcQry.Transaction.StartTransaction;

  if (DndArchiveLocalName = TD_Db2) or (DndArchiveLocalName = TD_Oracle) then
  begin
    TableNameLocal  := 'SCDM_RESCAL';
    TableNameArc    := 'SCDA_RESCAL';
  end;

  tbInfo := @tblInfo[tbl_rescal];
 // SetFldPfx(tbInfo.pfx);

  ArcQry.SQL.Add('Select * from ' + TableNameArc);
  ArcQry.SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_CalCod) + '=');
  ArcQry.SQL.Add('''' + CalCod + '''');
  ArcQry.SQL.Add(' And ');
  if DndArchiveLocalName = TD_Interbase then
    ArcQry.SQL.Add(CreateFld(tbInfo.pfx, fli_CalDate) + '>=' + ''''+ MQMformatDate(FromDate) + '''')
  else                                                                                              //  ConvertDateFormatDb2Oracle(DBAppGlobals.StDateForPlan, true, true));
    ArcQry.SQL.Add(CreateFld(tbInfo.pfx, fli_CalDate) + '>= ' + ConvertDateFormatDb2Oracle(Trunc(FromDate), true, true ));
  //  ArcQry.SQL.Add(' TO_CHAR(' + CreatePfxFld(fli_CalDate) + ', ' + QuotedStr('YYYYMMDD') + ') >= ' + ConvertDateFormatToYYYYMMDD(Trunc(FromDate), StrToInt(IniAppGlobals.DownloadTo)));
  ArcQry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier)));
  ArcQry.Open;

  LocQry.SQL.Clear;
  LocQry.SQL.Add('Delete from ' + TableNameLocal);
  LocQry.SQL.Add(' Where ');
  LocQry.SQL.Add(CreateFld(tbInfo.pfx, fli_CalCod) + ' = ''' + CalCod + '''');
  LocQry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier)));
  LocQry.SQL.Add(' And ');
  if DndArchiveLocalName = TD_Oracle then
    LocQry.SQL.Add(' TO_CHAR(' + CreateFld(tbInfo.pfx, fli_CalDate) + ', ' + QuotedStr('YYYYMMDD') + ') >= ' + ConvertDateFormatToYYYYMMDD(Trunc(FromDate), StrToInt(IniAppGlobals.DownloadTo)))
  else if DndArchiveLocalName =  TD_Interbase then
    LocQry.SQL.Add(CreateFld(tbInfo.pfx, fli_CalDate) + ' >= ' + ConvertDateFormatTo(Trunc(FromDate), TD_Interbase))
  else
    LocQry.SQL.Add(' varchar_format(' + CreateFld(tbInfo.pfx, fli_CalDate) + ', ' + QuotedStr('YYYYMMDD') + ') >= ' + ConvertDateFormatToYYYYMMDD(Trunc(FromDate), StrToInt(IniAppGlobals.DownloadTo)));

  try
    LocQry.ExecSQL;
    LocQry.Transaction.Commit;
    LocQry.Connection.FetchOptions.AutoFetchAll;
  except
    LocQry.Connection.Rollback;
    raise;
  end;

  LocQry.SQL.Clear;
  LocQry.Transaction.StartTransaction;
  LocQry.SQL.Add('Insert into ' + TableNameLocal + ' (');
  LocQry.SQL.Add(CreateFld(tbInfo.pfx, fli_IDENTIFIER)   + ', ');
  LocQry.SQL.Add(CreateFld(tbInfo.pfx, fli_CalCod)       + ', ');
  LocQry.SQL.Add(CreateFld(tbInfo.pfx, fli_CalDate)      + ', ');
  LocQry.SQL.Add(CreateFld(tbInfo.pfx, fli_rsc)          + ', ');
  LocQry.SQL.Add(CreateFld(tbInfo.pfx, fli_Prog_Wrk_Hr)  + ', ');
  LocQry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH1_start)    + ', ');
  LocQry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH1_end)      + ', ');
  LocQry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH2_start)    + ', ');
  LocQry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH2_end)      + ', ');
  LocQry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH3_start)    + ', ');
  LocQry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH3_end)      + ', ');
  LocQry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH4_start)    + ', ');
  LocQry.SQL.Add(CreateFld(tbInfo.pfx, fli_SH4_end));
  LocQry.SQL.Add(') values (');
  LocQry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_IDENTIFIER)  + ', ');
  LocQry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_CalCod)      + ', ');
  LocQry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_CalDate)     + ', ');
  LocQry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_rsc)         + ', ');
  LocQry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Prog_Wrk_Hr) + ', ');
  LocQry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_SH1_start)   + ', ');
  LocQry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_SH1_end)     + ', ');
  LocQry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_SH2_start)   + ', ');
  LocQry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_SH2_end)     + ', ');
  LocQry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_SH3_start)   + ', ');
  LocQry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_SH3_end)     + ', ');
  LocQry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_SH4_start)   + ', ');
  LocQry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_SH4_end));
  LocQry.SQL.Add(')');

  try

  while not ArcQry.EOF do
  begin
      Result := true;
      LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsString  := IniAppGlobals.Identifier;
      LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_CalCod)).AsString := trim(ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_CalCod)).AsString);
      LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_CalDate)).AsDate :=  ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_CalDate)).AsDateTime;
      LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_rsc)).asString :=  ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_rsc)).asString;
      LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_Prog_Wrk_Hr)).AsFloat := ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_Prog_Wrk_Hr)).AsFloat;
      LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_SH1_start)).AsInteger := ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_SH1_start)).AsInteger;
      LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_SH1_end)).AsInteger := ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_SH1_end)).AsInteger;
      LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_SH2_start)).AsInteger := ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_SH2_start)).AsInteger;
      LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_SH2_end)).AsInteger := ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_SH2_end)).AsInteger;
      LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_SH3_start)).AsInteger := ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_SH3_start)).AsInteger;
      LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_SH3_end)).AsInteger := ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_SH3_end)).AsInteger;
      LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_SH4_start)).AsInteger := ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_SH4_start)).AsInteger;
      LocQry.ParamByName(CreateFld(tbInfo.pfx, fli_SH4_end)).AsInteger := ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_SH4_end)).AsInteger;
      LocQry.ExecSql;
      ArcQry.Next
  end;

//  ArcQry.Transaction.Commit;
  LocQry.Transaction.Commit;
  LocQry.Connection.FetchOptions.AutoFetchAll;
  except
    LocQry.Connection.Rollback;
//    ArcQry.Connection.Rollback;
    raise;
  end;

  LocQry.Close;

  ArcQry.Free;
  LocQry.Free;

 // UpdateCalendarOnResLevelProgress(CalCod); //ask Avi

end;

//----------------------------------------------------------------------------//

procedure TFDloadCalendars.UpdateCalendarOnResLevelProgress(CalCod: string);
var
  srvQry: TMqmQuery;
  srvQryUpdate : TMqmQuery;
  CalDate:             TDateTime;
  CalDateDB:           string;
  firstShiftStart:     integer;
  firstShiftEnd:       integer;
  secondShiftStart:    integer;
  secondShiftEnd:      integer;
  thirdShiftStart:     integer;
  thirdShiftEnd:       integer;
  fourthShiftStart:    integer;
  fourthShiftEnd:      integer;
  tbInfo: ^TTblInfo;
  ProgWrkHr, ProgWrkHrDB : double;
  srvUpdate : string;
  DndArchiveLocalName : TDndArchiveName;
begin
  ProgWrkHr := 0;
  srvQry := CreateQuery(Main_DB);
  srvQryUpdate := CreateQuery(Main_DB);
  srvQryUpdate.Transaction := CreateTransaction(Main_DB);
  srvQryUpdate.Transaction.StartTransaction;

  tbInfo := @tblInfo[tbl_resCal];
  DndArchiveLocalName := GetDndArchiveLocalName;

  srvQry.SQL.Clear;
  srvQry.SQL.Add('select * from ' + tbInfo.GetTableName);
  srvQry.SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_CalCod) + '=' + '''' + CalCod + '''');
  srvQry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier)));
 // srvQry.SQL.Add(' group by ' + CreateFld(tbInfo.pfx, fli_rsc));
  srvQry.SQL.Add(' order by ' + CreateFld(tbInfo.pfx, fli_CalDate));
  srvQry.Open;

  try

  while not srvQry.eof do
  begin

    CalDate          := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_CalDate)).AsDateTime;
    firstShiftStart  := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_SH1_start)).AsInteger;
    firstShiftEnd    := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_SH1_end)).AsInteger;
    secondShiftStart := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_SH2_start)).AsInteger;
    secondShiftEnd   := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_SH2_end)).AsInteger;
    thirdShiftStart  := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_SH3_start)).AsInteger;
    thirdShiftEnd    := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_SH3_end)).AsInteger;
    fourthShiftStart := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_SH4_start)).AsInteger;
    fourthShiftEnd   := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_SH4_end)).AsInteger;
    ProgWrkHrDB :=  srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_Prog_Wrk_Hr)).AsFloat;
    CalDateDB := ConvertDateFormatTo(Trunc(CalDate), DndArchiveLocalName);

    ProgWrkHr := ProgWrkHr + ((firstShiftEnd - firstShiftStart) +
                  (secondShiftEnd - secondShiftStart) +
                  (thirdShiftEnd - thirdShiftStart) +
                  (fourthShiftEnd - fourthShiftStart)) / 60;
    ProgWrkHr := trunc(ProgWrkHr * 100);
    ProgWrkHr := ProgWrkHr / 100;

    if ProgWrkHr <> ProgWrkHrDB  then
    begin
      srvUpdate := 'update ' + tbinfo.GetTableName + ' set ' +
                           CreateFld(tbInfo.pfx, fli_Prog_Wrk_Hr) + '=' + FloatToStr(ProgWrkHr) +
                           ' where ' + CreateFld(tbInfo.pfx, fli_CalCod) + '=' + '''' + CalCod + '''' +
                           ' and ' + CreateFld(tbInfo.pfx, fli_CalDate) + '=' + CalDateDB +
                           ' and ' + CreateFld(tbInfo.pfx, fli_rsc) + '=' + QuotedStr(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_rsc)).asString)+
                            AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier));

      srvQryUpdate.SQL.Text := srvUpdate;
      srvQryUpdate.ExecSQL;
    end;
    srvQry.Next;
  end;

  srvQryUpdate.Transaction.Commit;
  srvQryUpdate.Connection.FetchOptions.AutoFetchAll;

  except
    srvQryUpdate.Connection.Rollback;
    raise;
  end;
  
  srvQryUpdate.Free;
  srvQry.Free;
end;

procedure TFDloadCalendars.UpdateCalendarProgress(CalCod: string);
var
  srvQry: TMqmQuery;
  srvQryUpdate : TMqmQuery;
  CalDate:             TDateTime;
  CalDateDB:           string;
  firstShiftStart:     integer;
  firstShiftEnd:       integer;
  secondShiftStart:    integer;
  secondShiftEnd:      integer;
  thirdShiftStart:     integer;
  thirdShiftEnd:       integer;
  fourthShiftStart:    integer;
  fourthShiftEnd:      integer;
  tbInfo: ^TTblInfo;
  ProgWrkHr, ProgWrkHrDB : double;
  srvUpdate : string;
  DndArchiveLocalName : TDndArchiveName;
begin
  ProgWrkHr := 0;
  srvQry := CreateQuery(Main_DB);
  srvQryUpdate := CreateQuery(Main_DB);
  srvQryUpdate.Transaction := CreateTransaction(Main_DB);
  srvQryUpdate.Transaction.StartTransaction;

  tbInfo := @tblInfo[tbl_calendar];
  DndArchiveLocalName := GetDndArchiveLocalName;

  srvQry.SQL.Clear;
  srvQry.SQL.Add('select * from ' + tbInfo.GetTableName);
  srvQry.SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_CalCod) + '=' + '''' + CalCod + '''');
  srvQry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier)));
  srvQry.SQL.Add(' order by ' + CreateFld(tbInfo.pfx, fli_CalDate));
  srvQry.Open;

  try
  
  while not srvQry.eof do
  begin

    CalDate          := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_CalDate)).AsDateTime;
    firstShiftStart  := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_SH1_start)).AsInteger;
    firstShiftEnd    := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_SH1_end)).AsInteger;
    secondShiftStart := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_SH2_start)).AsInteger;
    secondShiftEnd   := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_SH2_end)).AsInteger;
    thirdShiftStart  := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_SH3_start)).AsInteger;
    thirdShiftEnd    := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_SH3_end)).AsInteger;
    fourthShiftStart := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_SH4_start)).AsInteger;
    fourthShiftEnd   := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_SH4_end)).AsInteger;
    ProgWrkHrDB :=  srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_Prog_Wrk_Hr)).AsFloat;
    CalDateDB := ConvertDateFormatTo(Trunc(CalDate), DndArchiveLocalName);

    ProgWrkHr := ProgWrkHr + ((firstShiftEnd - firstShiftStart) +
                  (secondShiftEnd - secondShiftStart) +
                  (thirdShiftEnd - thirdShiftStart) +
                  (fourthShiftEnd - fourthShiftStart)) / 60;
    ProgWrkHr := trunc(ProgWrkHr * 100);
    ProgWrkHr := ProgWrkHr / 100;

    if ProgWrkHr <> ProgWrkHrDB  then
    begin
      var ProgWrkHrNew := StringReplace(FloatToStr(ProgWrkHr), ',','.' ,[rfReplaceAll, rfIgnoreCase]);

      srvUpdate := 'update ' + tbinfo.GetTableName + ' set ' +
                           CreateFld(tbInfo.pfx, fli_Prog_Wrk_Hr) + '=' + ProgWrkHrNew +
                           ' where ' + CreateFld(tbInfo.pfx, fli_CalCod) + '=' + '''' + CalCod + '''' +
                           ' and ' + CreateFld(tbInfo.pfx, fli_CalDate) + '=' + CalDateDB +
                            AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier));

      srvQryUpdate.SQL.Text := srvUpdate;
      srvQryUpdate.ExecSQL;
    end;
    srvQry.Next;
  end;

  srvQryUpdate.Transaction.Commit;
  srvQryUpdate.Connection.FetchOptions.AutoFetchAll;

  except
    srvQryUpdate.Connection.Rollback;
    raise;
  end;
  
  srvQryUpdate.Close;
  srvQryUpdate.Free;

  srvQry.Close;
  srvQry.Free;
end;

//----------------------------------------------------------------------------//

Function SetDecSeparator(S : String) : String;
begin

  if FormatSettings.DecimalSeparator = ',' then
  begin
      s := StringReplace(s,',','.', [rfReplaceAll, rfIgnoreCase]);
      s := StringReplace(s,'|',',', [rfReplaceAll, rfIgnoreCase]);
  end;

  Result := S;

end;

procedure TFDloadCalendars.UpdateEfficiencyOnResLevel(CalCod: string);
var
  srvQry, UpdateQry: TMqmQuery;
  ArcQry :  TMQMQuery;
  tbInfo: ^TTblInfo;
  DndArchiveLocalName : TDndArchiveName;
  QryInsertSql, TableName : string;
const
  fldList: array [0..3] of TQryLinkRec = (
    (fldPC: fli_IDENTIFIER;  fldAS: ''; fldType: TLD_Integer),
    (fldPC: fli_CalCod;      fldAS: ''; fldType: TLD_string),
    (fldPC: fli_SDescr;      fldAS: ''; fldType: TLD_string),
    (fldPC: fli_EfficiencyOnWcOrResLevel;   fldAS: ''; fldType: TLD_string)
  );

begin
  srvQry := CreateQuery(Main_DB);
  srvQry.Transaction := CreateTransaction(Main_DB);
//  srvQry.Transaction.StartTransaction;

  DndArchiveLocalName := GetDndArchiveLocalName;
  TableName := 'CAL';

  if DndArchiveLocalName <> TD_Interbase then
    TableName  := 'SCDA_CAL';

  ArcQry   := CreateQueryArc;
  ArcQry.Transaction := CreateTransaction(Arc_DB);
  ArcQry.Transaction.StartTransaction;

  tbInfo := @tblInfo[tbl_cal];
  ArcQry.SQL.Clear;

  ArcQry.SQL.Add('Select * from ' + TableName);
  ArcQry.SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_CalCod) + '=');
  ArcQry.SQL.Add('''' + CalCod + '''');
  ArcQry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier)));

  ArcQry.Open;

  if not ArcQry.eof then
  begin

    srvQry.SQL.Clear;
    srvQry.SQL.Add('select * from ' + tbInfo.GetTableName);
    srvQry.SQL.Add(' Where ');
    srvQry.SQL.Add(CreateFld(tbInfo.pfx, fli_CalCod) + ' = ''' + CalCod + '''');
    srvQry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier)));
    srvQry.Open;

    if srvQry.eof then
    begin
      srvQry.Close;
      InsertTable(tbl_Cal,fldList,srvQry);
      QryInsertSql :=
      IniAppGlobals.Identifier + DecSep +
      QuotedStr(CalCod) + DecSep +
      QuotedStr(trim(ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_SDescr)).AsString)) + DecSep +
      QuotedStr(ArcQry.FieldByName(CreateFld(tbInfo.pfx, fli_EfficiencyOnWcOrResLevel)).AsString) + ')';

      QryInsertSql := SetDecSeparator(QryInsertSql);

      srvQry.SQL.Add(QryInsertSql);
      srvQry.Transaction.StartTransaction;
      try
        srvQry.ExecSql;
        srvQry.Transaction.Commit;
      except
        srvQry.Connection.Rollback;
      end;

      srvQry.Close;
    end
    else
    begin
      UpdateQry := CreateQuery(Main_DB);
      UpdateQry.Transaction := CreateTransaction(Main_DB);
      UpdateQry.Transaction.StartTransaction;
      UpdateQry.SQL.Clear;
      UpdateQry.SQL.Add('update ' + tbinfo.GetTableName + ' set ' +
                        '"CL_EFFICIENCYON_WC_OR_RES_LVL" = ' + QuotedStr(ArcQry.FieldByName(CreateFld(tbInfo.pfx,fli_EfficiencyOnWcOrResLevel)).AsString) +
                        ' where ' + CreateFld(tbInfo.pfx, fli_CalCod) + '=' + '''' + CalCod + '''');
      UpdateQry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier)));
      try
        UpdateQry.ExecSql;
        UpdateQry.Transaction.Commit;
      except
        UpdateQry.Connection.Rollback;
      end;
      UpdateQry.Close;
      UpdateQry.Free;
    end;


  end;

  //srvQry.Transaction.Commit;
  srvQry.Close;
  ArcQry.Transaction.Commit;
  ArcQry.Close;

  srvQry.Free;
  ArcQry.Free;

end;

//----------------------------------------------------------------------------//

function TFDloadCalendars.CheckCalendarOnResourceLevel(Cal : String) : boolean;
var
  qry : TMqmQuery;
begin
  Result := false;
  qry := CreateQueryArc;

  if IniAppGlobals.downloadTo = '2' then
  begin
    if qry.Connection.ExecSQLScalar('select CL_EFFICIENCYON_WC_OR_RES_LVL from CAL'
      + WHERE_IDF_Condition('CL_IDENTIFIER') + ' and CL_CAL = ' + QuotedStr(Cal)) = '3' then
      Result := True;
  end
  else
  begin
    if qry.Connection.ExecSQLScalar('select CL_EFFICIENCYON_WC_OR_RES_LVL from SCDM_CAL'
      + WHERE_IDF_Condition('CL_IDENTIFIER') + ' and CL_CAL = ' + QuotedStr(Cal)) = '3' then
      Result := True;
  end;

end;

end.
