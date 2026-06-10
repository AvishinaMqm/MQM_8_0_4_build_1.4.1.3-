unit UMASStoredProc;

interface

  function CrtAs400StoredProc(Lib: string): boolean;
//  function SP_AS_Transfer(Operation: string; out ErrorStr: string): boolean;
//  function CT_GET_ACCESS_HOST(out ErrorStr: string): boolean;
  function CT_START_UPLOAD : boolean;
//  function CT_END_UPLOAD : boolean;
  function CT_CLEAR_MQMCG : boolean;
  function CT_START_DNLOAD_SCHEDULED(out ErrorStr: string) : boolean;
  function CT_END_DNLOAD_SCHEDULED : boolean;
  function CT_END_PROCCESS_HOST : boolean;
//  function CT_CLEAR_PROCCESS_HOST : boolean;

  function CheckDataPreparationExist : boolean;
  procedure callExternalApplication(applicationFullPath: String; parameter: String);


implementation

uses
  SysUtils,
  Dialogs,
  UMSaveLoad,
  UMSrvConfig,
  UMSrvLoad,
  ADODb,
  db,
  UMGlobal,
  UGconvert,
  UMTblDesc,
  DMsrvPc,
  FireDAC.Stan.Error,
  UMCommon,
  UOpThread,
  gnugettext, Windows;

function CrtAs400StoredProc(Lib: string): boolean;
var
  Q : TMqmQuery;
begin
  Result := false;

  if not ConnectToHost then
  exit;

  Q := CreateQueryHost;

// ----------------------------------------------------------------------------
  // Create Stored Procedure for download data
  Q.SQL.Clear;
  try
    Q.SQL.Text := 'DROP PROCEDURE ' + Lib + '/MQMYW3002';
    Q.ExecSQL;
  except
  end;

  Q.SQL.Clear;
  try
    Q.SQL.Text := 'CREATE PROCEDURE  ' + Lib + '/MQMYW3002' +
      ' (IN OPER CHAR (1)) ' +
      'LANGUAGE RPG ' +
      'EXTERNAL NAME YW3002 ' +
      'PARAMETER STYLE GENERAL';
    Q.ExecSQL;
  except
    ShowMessage(_('ERROR CREATING STORED PROCEDURES'));
    Q.Free;
    exit
  end;

  Result := true
end;

// ----------------------------------------------------------------------------

{function SP_AS_Transfer(Operation: string; out ErrorStr: string): boolean;
var
  StoredProc: TADOStoredProc;
begin
  Result := false;
  StoredProc := CreateHostStoredProc;
  StoredProc.ProcedureName := 'MQMYW3002';
  StoredProc.Connection := DM_HOST.m_HOST_DB;

  try
    with StoredProc do
    begin
      Prepared := true;
      Parameters.CreateParameter('OPER', ftString, pdInput, 1, Operation);
      ExecProc;
      Prepared := false;
      ErrorStr := '';
    end;
  except
    on E: Exception do
      begin
        ErrorStr := E.Message;
        exit
      end;
  end;
  Result := true;
end; }

// ----------------------------------------------------------------------------

{function CT_GET_ACCESS_HOST(out ErrorStr: string): boolean;
var
  Q : TMqmQuery;
  T : TDateTime;
  DateTimeFormat : TDateTimeFormat;
  GeneralSQL : String;
  year, month, day, hour, min, sec, msec: Word;
  TempDate : string;
  M,S, TableName : string;
  DndArchiveHostName : TDndArchiveName;
begin
  Result := true;
  DndArchiveHostName := GetDndArchiveHostName;

  if IniAppGlobals.DownloadTo = '2' then
    TableName := 'MQMCN00F'
  else
    TableName := 'SCDA_MQMCN00F';

  if (DndArchiveHostName = TD_AS_400) then
    Q := CreateQueryHost
  else
    Q := CreateQueryArc;
  DateTimeFormat := GetDateTimeFormat;
  try
    while true do
    begin
      with Q.sql do
      begin
        Clear;
        if (DateTimeFormat = Frm_As400) then
        begin
          T := DateTimeToTimDateTime(now);
          GeneralSQL := '';
          GeneralSQL := ' UPDATE ' + TableName;
          GeneralSQL := GeneralSQL + ' SET KCLSTT ' + '=''' + '1' + '''';
          GeneralSQL := GeneralSQL + ', ';
          GeneralSQL := GeneralSQL + 'KCLSTR = ' + FloatToStr(T);
          GeneralSQL := GeneralSQL + ', ';
          GeneralSQL := GeneralSQL + 'KCLEND = 0';
          GeneralSQL := GeneralSQL + ', ';
          GeneralSQL := GeneralSQL + 'KCLOPR ' + '=''' + '0' + '''';
          GeneralSQL := GeneralSQL + ', ';
          GeneralSQL := GeneralSQL + 'KSRUPD ' + '=''' + '0' + '''';
          GeneralSQL := GeneralSQL + ' where KSRSTT ' + '<>''' + '1' + '''';
          Q.sql.Add(GeneralSQL);
        end

        else if (IniAppGlobals.DownloadTo = '0') then
        begin
          T := now;
          TempDate := DateTimeToStr(T);
          DecodeDate(T, year, month, day);
          DecodeTime(T, hour, min, sec, msec);
          if min < 10 then
            M := '0' + IntToStr(min)
          else
            M := IntToStr(min);

          if Sec < 10 then
            S := '0' + IntToStr(Sec)
          else
            S := IntToStr(Sec);

          TempDate := '';
          TempDate := IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(day) + ' ' +
                      IntToStr(hour) + ':' + M + ':' + S;
          GeneralSQL := '';
          GeneralSQL := ' UPDATE ' + TableName;
          GeneralSQL := GeneralSQL + ' SET KCLSTT ' + '=''' + '1' + '''';
          GeneralSQL := GeneralSQL + ', ';
          GeneralSQL := GeneralSQL + 'KCLSTR = ' + QuotedStr(TempDate);
          GeneralSQL := GeneralSQL + ', ';
          GeneralSQL := GeneralSQL + 'KCLEND = ' + QuotedStr('1899-12-12 00:00:00');
          GeneralSQL := GeneralSQL + ', ';
          GeneralSQL := GeneralSQL + 'KCLOPR ' + '=''' + '0' + '''';
          GeneralSQL := GeneralSQL + ', ';
          GeneralSQL := GeneralSQL + 'KSRUPD ' + '=''' + '0' + '''';
          GeneralSQL := GeneralSQL + ' where KSRSTT ' + '<>''' + '1' + '''';
          Q.sql.Add(GeneralSQL);
        end



        else if (DateTimeFormat = Frm_TDateTimeExceptControl) then
        begin
          T := now;
          GeneralSQL := '';
          GeneralSQL := ' UPDATE ' + TableName;
          GeneralSQL := GeneralSQL + ' SET KCLSTT ' + '=''' + '1' + '''';
          GeneralSQL := GeneralSQL + ', ';
          GeneralSQL := GeneralSQL + 'KCLSTR = ' + FloatToStr(T);
          GeneralSQL := GeneralSQL + ', ';
          GeneralSQL := GeneralSQL + 'KCLEND = 0';
          GeneralSQL := GeneralSQL + ', ';
          GeneralSQL := GeneralSQL + 'KCLOPR ' + '=''' + '0' + '''';
          GeneralSQL := GeneralSQL + ', ';
          GeneralSQL := GeneralSQL + 'KSRUPD ' + '=''' + '0' + '''';
          GeneralSQL := GeneralSQL + ' where KSRSTT ' + '<>''' + '1' + '''';
          Q.sql.Add(GeneralSQL);
        end
        else if (DateTimeFormat = Frm_TDateTime) then
        begin
          T := now;
          TempDate := DateTimeToStr(T);
          DecodeDate(T, year, month, day);
          DecodeTime(T, hour, min, sec, msec);
          TempDate := '';
          TempDate := IntToStr(month) + '/' + IntToStr(Day) + '/' + IntToStr(Year) + ' ' +
                      IntToStr(hour) + ':' + IntToStr(min) + ':' + IntToStr(Sec);
          GeneralSQL := '';
          GeneralSQL := ' UPDATE ' + TableName;
          GeneralSQL := GeneralSQL + ' SET KCLSTT ' + '=''' + '1' + '''';
          GeneralSQL := GeneralSQL + ', ';
          GeneralSQL := GeneralSQL + 'KCLSTR = ' + QuotedStr(TempDate);
          GeneralSQL := GeneralSQL + ', ';
          GeneralSQL := GeneralSQL + 'KCLEND = ' + QuotedStr('12/12/1899');
          GeneralSQL := GeneralSQL + ', ';
          GeneralSQL := GeneralSQL + 'KCLOPR ' + '=''' + '0' + '''';
          GeneralSQL := GeneralSQL + ', ';
          GeneralSQL := GeneralSQL + 'KSRUPD ' + '=''' + '0' + '''';
          GeneralSQL := GeneralSQL + ' where KSRSTT ' + '<>''' + '1' + '''';
          Q.sql.Add(GeneralSQL);
        end

        else if (DateTimeFormat = Frm_DB2) then
        begin
          T := now;
          TempDate := DateTimeToStr(T);
          DecodeDate(T, year, month, day);
          DecodeTime(T, hour, min, sec, msec);
          if min < 10 then
            M := '0' + IntToStr(min)
          else
            M := IntToStr(min);

          if Sec < 10 then
            S := '0' + IntToStr(Sec)
          else
            S := IntToStr(Sec);

          TempDate := '';
          TempDate := IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(day) + ' ' +
                      IntToStr(hour) + ':' + M + ':' + S;
          GeneralSQL := '';
          GeneralSQL := ' UPDATE ' + TableName;
          GeneralSQL := GeneralSQL + ' SET KCLSTT ' + '=''' + '1' + '''';
          GeneralSQL := GeneralSQL + ', ';
          GeneralSQL := GeneralSQL + 'KCLSTR = ' + QuotedStr(TempDate);
          GeneralSQL := GeneralSQL + ', ';
          GeneralSQL := GeneralSQL + 'KCLEND = ' + QuotedStr('1899-12-12 00:00:00');
          GeneralSQL := GeneralSQL + ', ';
          GeneralSQL := GeneralSQL + 'KCLOPR ' + '=''' + '0' + '''';
          GeneralSQL := GeneralSQL + ', ';
          GeneralSQL := GeneralSQL + 'KSRUPD ' + '=''' + '0' + '''';
          GeneralSQL := GeneralSQL + ' where KSRSTT ' + '<>''' + '1' + '''';
          Q.sql.Add(GeneralSQL);
        end;

        Q.ExecSQL;
        Q.Connection.commit;
        Q.Close;

        Clear;
        Add(' Select * from ' + TableName + ' Where KCLSTT ' + '=''' + '1' + '''');
   //     Add(' Where KCLSTT ' + '=''' + '1' + '''');
        Q.Open;
        if Q.EOF then
        begin
          UpdateOperation(_(' Waiting for host . . .'));
          FSrvLoad.IExit.Enabled := true;
          Sleep(10000);
        end
        else
        begin
          Clear;
          FSrvLoad.IExit.Enabled := false;
          Break;
        end;
      end;
    end;

    except
      on E: EFDDBEngineException do
      begin
         Q.connection.Rollback;
         FSrvLoad.MmErrors.Lines.Add(' ExecSQL xxx CT_CLEAR_PROCCESS_HOST xxx ' + TableName + ' xxx ');
         FSrvLoad.MmErrors.Lines.Add(Q.sql.Text);
         FSrvLoad.IExit.Enabled  := true;
         FSrvLoad.PGCmain.TabIndex := 1;
         raise EFDDBEngineException.CreateFmt('ExecSQL xxx ' + TableName + ' xxx CT_CLEAR_PROCCESS_HOST' , [E.Message]);
      end;
    end;

//  end;

  Q.Free;
end;          }

// ----------------------------------------------------------------------------

function CT_START_UPLOAD : boolean;
var
  Q : TMqmQuery;
  GeneralSQL, LocalTableName : String;
  LocalHostName : TDndArchiveName;
  DndArchiveName : TDndArchiveName;
begin
  Result := true;
  DndArchiveName := GetDndArchiveHostName;

  if (DndArchiveName = TD_AS_400) then
    Q := ThreadCreateQueryHost
  else
    Q := ThreadCreateQueryArc;

  LocalHostName := GetDndArchiveLocalName;

  LocalTableName := 'MQMCN00F';
  if LocalHostName <> TD_Interbase then
    LocalTableName  := 'SCDA_' + 'MQMCN00F';

  with Q.sql do
  begin
    Clear;
    GeneralSQL := '';
    GeneralSQL := ' UPDATE ' + LocalTableName;
    GeneralSQL := GeneralSQL + ' SET KCLOPR ' + '=''' + '1' + '''';
    GeneralSQL := GeneralSQL + ', ';
    GeneralSQL := GeneralSQL + 'KCLUPL ' + '=''' + '0' + '''';
    Add(GeneralSQL);
    Q.ExecSQL;
    Q.Connection.commit;
    Q.Close;
  end;
  Q.free;
end;

// ----------------------------------------------------------------------------

{function CT_END_UPLOAD : boolean;
var
  Q : TMqmQuery;
  T : TDateTime;
  DateTimeFormat : TDateTimeFormat;
  GeneralSQL : String;
  year, month, day, hour, min, sec, msec: Word;
  TempDate, M, S : string;
  TableName : string;
begin
  Result := true;
  Q := CreateQueryArc;
  DateTimeFormat := GetDateTimeFormat;
  if IniAppGlobals.DownloadTo = '2' then
    TableName := 'MQMCN00F'
  else
    TableName := 'SCDA_MQMCN00F';

  with Q.sql do
  begin
    Clear;
    if (DateTimeFormat = Frm_As400) then
    begin
      T := DateTimeToTimDateTime(now);
      GeneralSQL := '';
      GeneralSQL := ' UPDATE MQMCN00F';
      GeneralSQL := GeneralSQL + ' SET KCLOPR ' + '=''' + '2' + '''';
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KCLSTT ' + '=''' + '0' + '''';
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KCLEND = ' + FloatToStr(T);
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KSRUPD ' + '=''' + '1' + '''';
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KCLUPL ' + '=''' + '1' + '''';
      Add(GeneralSQL);
    end
    else if (DateTimeFormat = Frm_TDateTimeExceptControl) then
    begin
      T := now;
      GeneralSQL := '';
      GeneralSQL := ' UPDATE MQMCN00F';
      GeneralSQL := GeneralSQL + ' SET KCLOPR ' + '=''' + '2' + '''';
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KCLSTT ' + '=''' + '0' + '''';
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KCLEND = ' + FloatToStr(T);
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KSRUPD ' + '=''' + '1' + '''';
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KCLUPL ' + '=''' + '1' + '''';
      Add(GeneralSQL);
    end
    else if (DateTimeFormat = Frm_TDateTime) then
    begin
      T := now;
      TempDate := DateTimeToStr(T);
      DecodeDate(T, year, month, day);
      DecodeTime(T, hour, min, sec, msec);
      TempDate := ConvertDateFormatDb2Oracle(T, true, true);
     // TempDate := '';
     // TempDate := IntToStr(month) + '/' + IntToStr(Day) + '/' + IntToStr(Year) + ' ' +
     //                 IntToStr(hour) + ':' + IntToStr(min) + ':' + IntToStr(Sec);
      GeneralSQL := '';
      GeneralSQL := ' UPDATE ' + TableName;
      GeneralSQL := GeneralSQL + ' SET KCLOPR ' + '=''' + '2' + '''';
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KCLSTT ' + '=''' + '0' + '''';
      GeneralSQL := GeneralSQL + ', ';

      if IniAppGlobals.DownloadTo = '0' then
        GeneralSQL := GeneralSQL + 'KCLEND = ' + TempDate
      else if IniAppGlobals.DownloadTo = '1' then
        GeneralSQL := GeneralSQL + 'KCLEND = ' + QuotedStr(TempDate)
      else if IniAppGlobals.DownloadTo = '2' then
      begin
       // TempDate := IntToStr(month) + '/' + IntToStr(Day) + '/' + IntToStr(Year) + ' ' +
       //               IntToStr(hour) + ':' + IntToStr(min) + ':' + IntToStr(Sec);
        GeneralSQL := GeneralSQL + 'KCLEND = ' + QuotedStr(TempDate);
      end;


      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KSRUPD ' + '=''' + '1' + '''';
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KCLUPL ' + '=''' + '1' + '''';
      Add(GeneralSQL);
    end

    else if (DateTimeFormat = Frm_DB2) then
    begin
      T := now;
      DecodeDate(T, year, month, day);
      DecodeTime(T, hour, min, sec, msec);
      if min < 10 then
        M := '0' + IntToStr(min)
      else
        M := IntToStr(min);

      if Sec < 10 then
        S := '0' + IntToStr(Sec)
      else
        S := IntToStr(Sec);

      TempDate := '';
      TempDate := IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(day) + ' ' +
                  IntToStr(hour) + ':' + M + ':' + S;
      GeneralSQL := '';
      GeneralSQL := ' UPDATE SCDA_MQMCN00F';
      GeneralSQL := GeneralSQL + ' SET KCLOPR ' + '=''' + '2' + '''';
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KCLSTT ' + '=''' + '0' + '''';
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KCLEND = ' + TempDate;
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KSRUPD ' + '=''' + '1' + '''';
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KCLUPL ' + '=''' + '1' + '''';
      Add(GeneralSQL);
    end;

    Q.ExecSQL;
    Q.Connection.commit;
    Q.Close;
  end;
  Q.free;
end;}

// ----------------------------------------------------------------------------

function CT_CLEAR_MQMCG : boolean;
var
  Q : TMqmQuery;
begin
  Result := true;
  Q := CreateQueryHost;
  with Q.sql do
  begin
    Clear;
    Add(' DELETE FROM MQMCG00F');
    Q.ExecSQL;
    Q.Close;
  end;
  Q.free;
end;

// ----------------------------------------------------------------------------

function CT_START_DNLOAD_SCHEDULED(out ErrorStr: string) : boolean;
var
  Q : TMqmQuery;
  T : TDateTime;
  DateTimeFormat : TDateTimeFormat;
  GeneralSQL : String;
  year, month, day, hour, min, sec, msec: Word;
  TempDate, M, S : string;
begin
  Result := true;
  Q := CreateQueryHost;
  DateTimeFormat := GetDateTimeFormat;

  try

    with Q.sql do
    begin
      Clear;
      Add(' SELECT * FROM MQMCN00F WHERE KCLUPL ' + '=''' + '1' + '''');
      Q.Open;
      if Q.Eof then
      begin
        Result := false;
        UpdateOperation(_('Problem occured with last download . . .'));
        Q.Close;
        Q.free;
        exit;
      end
      else
      begin
        while true do
        begin
          Clear;
          if (DateTimeFormat = Frm_As400) then
          begin
            T := DateTimeToTimDateTime(now);
            GeneralSQL := '';
            GeneralSQL := ' UPDATE MQMCN00F';
            GeneralSQL := GeneralSQL + ' SET KCLSTT ' + '=''' + '1' + '''';
            GeneralSQL := GeneralSQL + ', ';
            GeneralSQL := GeneralSQL + 'KCLSTR = ' + FloatToStr(T);
            GeneralSQL := GeneralSQL + ', ';
            GeneralSQL := GeneralSQL + 'KCLEND = 0';
            GeneralSQL := GeneralSQL + ', ';
            GeneralSQL := GeneralSQL + 'KCLOPR ' + '=''' + '0' + '''';
            GeneralSQL := GeneralSQL + ', ';
            GeneralSQL := GeneralSQL + 'KSRUPD ' + '=''' + '0' + '''';
            Add(GeneralSQL);
          end
          else if (DateTimeFormat = Frm_TDateTimeExceptControl) then
          begin
            T := now;
            GeneralSQL := '';
            GeneralSQL := ' UPDATE MQMCN00F';
            GeneralSQL := GeneralSQL + ' SET KCLSTT ' + '=''' + '1' + '''';
            GeneralSQL := GeneralSQL + ', ';
            GeneralSQL := GeneralSQL + 'KCLSTR = ' + FloatToStr(T);
            GeneralSQL := GeneralSQL + ', ';
            GeneralSQL := GeneralSQL + 'KCLEND = 0';
            GeneralSQL := GeneralSQL + ', ';
            GeneralSQL := GeneralSQL + 'KCLOPR ' + '=''' + '0' + '''';
            GeneralSQL := GeneralSQL + ', ';
            GeneralSQL := GeneralSQL + 'KSRUPD ' + '=''' + '0' + '''';
            Add(GeneralSQL);
          end
          else if (DateTimeFormat = Frm_TDateTime) then
          begin
            T := now;
            GeneralSQL := '';
            GeneralSQL := ' UPDATE MQMCN00F';
            GeneralSQL := GeneralSQL + ' SET KCLSTT ' + '=''' + '1' + '''';
            GeneralSQL := GeneralSQL + ', ';
            GeneralSQL := GeneralSQL + 'KCLSTR = ' + QuotedStr(DateTimeToStr(T));
            GeneralSQL := GeneralSQL + ', ';
            GeneralSQL := GeneralSQL + 'KCLEND = ' + QuotedStr(DateTimeToStr(30/12/1899));
            GeneralSQL := GeneralSQL + ', ';
            GeneralSQL := GeneralSQL + 'KCLOPR ' + '=''' + '0' + '''';
            GeneralSQL := GeneralSQL + ', ';
            GeneralSQL := GeneralSQL + 'KSRUPD ' + '=''' + '0' + '''';
          end

          else if (DateTimeFormat = Frm_DB2) then
          begin
            T := now;
            DecodeDate(T, year, month, day);
            DecodeTime(T, hour, min, sec, msec);
            if min < 10 then
              M := '0' + IntToStr(min)
            else
              M := IntToStr(min);

            if Sec < 10 then
              S := '0' + IntToStr(Sec)
            else
              S := IntToStr(Sec);

            TempDate := '';
            TempDate := IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(day) + ' ' +
                        IntToStr(hour) + ':' + M + ':' + S;
            GeneralSQL := '';
            GeneralSQL := ' UPDATE MQMCN00F';
            GeneralSQL := GeneralSQL + ' SET KCLSTT ' + '=''' + '1' + '''';
            GeneralSQL := GeneralSQL + ', ';
            GeneralSQL := GeneralSQL + 'KCLSTR = ' + QuotedStr(TempDate);
            GeneralSQL := GeneralSQL + ', ';
            GeneralSQL := GeneralSQL + 'KCLEND = ' + QuotedStr('1899-12-12 00:00:00');
            GeneralSQL := GeneralSQL + ', ';
            GeneralSQL := GeneralSQL + 'KCLOPR ' + '=''' + '0' + '''';
            GeneralSQL := GeneralSQL + ', ';
            GeneralSQL := GeneralSQL + 'KSRUPD ' + '=''' + '0' + '''';
          end;

          Q.ExecSQL;
          Q.Connection.commit;
          Clear;
          Add(' Select * from MQMCN00F Where KCLSTT ' + '=''' + '1' + '''');
          Q.Open;
          if Q.EOF then
          begin
            Result := false;
            UpdateOperation(_(' Please wait can not download now . . .'));
            FSrvLoad.IExit.Enabled := true;
            Sleep(10000);
          end
          else
          begin
            Clear;
            FSrvLoad.IExit.Enabled := false;
            Result := true;
            Break;
          end;
        end;
      end;
    end;
    except
    on E: Exception do
    begin
      Result := false;
      ErrorStr := E.Message;
      ErrorStr := ErrorStr + '   PLEASE CHECK ODBC CONNECTION  (ALIAS) ';
      Q.Free;
      exit
    end;
  end;
  Q.Close;
  Q.free;
end;

// ----------------------------------------------------------------------------

function CT_END_DNLOAD_SCHEDULED : boolean;
var
  Q : TMqmQuery;
  T : TDateTime;
  DateTimeFormat : TDateTimeFormat;
  GeneralSQL : String;
  year, month, day, hour, min, sec, msec: Word;
  TempDate, M, S : string;
begin
  Result := true;
  Q := CreateQueryHost;
  DateTimeFormat := GetDateTimeFormat;

  with Q.sql do
  begin
    Clear;
    if (DateTimeFormat = Frm_As400) then
    begin
      T := DateTimeToTimDateTime(now);
      GeneralSQL := '';
      GeneralSQL := ' UPDATE MQMCN00F';
      GeneralSQL := GeneralSQL + ' SET KCLOPR ' + '=''' + '3' + '''';
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KCLSTT ' + '=''' + '0' + '''';
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KCLEND = ' + FloatToStr(T);
      Add(GeneralSQL);
    end
    else if (DateTimeFormat = Frm_TDateTimeExceptControl) then
    begin
      T := now;
      GeneralSQL := '';
      GeneralSQL := ' UPDATE MQMCN00F';
      GeneralSQL := GeneralSQL + ' SET KCLOPR ' + '=''' + '3' + '''';
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KCLSTT ' + '=''' + '0' + '''';
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KCLEND = ' + '=''' + DateTimetoStr(T) + '''';
      Add(GeneralSQL);
    end
    else if (DateTimeFormat = Frm_TDateTime) then
    begin
      T := now;
      GeneralSQL := '';
      GeneralSQL := ' UPDATE MQMCN00F';
      GeneralSQL := GeneralSQL + ' SET KCLOPR ' + '=''' + '3' + '''';
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KCLSTT ' + '=''' + '0' + '''';
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KCLEND = ' + '=''' + DateTimetoStr(T) + '''';
      Add(GeneralSQL);
    end

    else if (DateTimeFormat = Frm_DB2) then
    begin
      T := now;
      DecodeDate(T, year, month, day);
      DecodeTime(T, hour, min, sec, msec);
      if min < 10 then
        M := '0' + IntToStr(min)
      else
        M := IntToStr(min);

      if Sec < 10 then
        S := '0' + IntToStr(Sec)
      else
        S := IntToStr(Sec);

      TempDate := '';
      TempDate := IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(day) + ' ' +
                  IntToStr(hour) + ':' + M + ':' + S;

      GeneralSQL := '';
      GeneralSQL := ' UPDATE MQMCN00F';
      GeneralSQL := GeneralSQL + ' SET KCLOPR ' + '=''' + '3' + '''';
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KCLSTT ' + '=''' + '0' + '''';
      GeneralSQL := GeneralSQL + ', ';
      GeneralSQL := GeneralSQL + 'KCLEND = ' + QuotedStr(TempDate);
      Add(GeneralSQL);
    end;

    Q.ExecSQL;
    Q.connection.commit;
    Q.Close;
  end;
  Q.free;
end;

// ----------------------------------------------------------------------------

function CT_END_PROCCESS_HOST : boolean;
var
  Q : TMqmQuery;
begin
  Q := CreateQueryHost;
  with Q.sql do
  begin
    Clear;
    Add(' Select * from MQMCN00F Where KSRUPD ' + '=''' + '3' + '''');
    Q.Open;
    if Q.EOF then
       Result := false
    else
       Result := true;
  end;
  Q.Close;
  Q.free;
end;

//----------------------------------------------------------------------------

function CheckDataPreparationExist : boolean;
var
  I : Integer;
  ParamToBeSend : string;
  TypeMode      : TDTypeMode;
begin
  Result := false;
  ParamToBeSend := '';
  TypeMode := GetTypeMode;
  if IniAppGlobals.PreparationExeName <> '' then
  begin

    case TypeMode of
      TD_AllFiles    : ParamToBeSend := 'AllFiles';
      TD_OnlyArchivs : ParamToBeSend := 'OnlyArchivs';
    //  TD_OnlyProd    : ParamToBeSend := 'OnlyProd';
      TD_OnlyUpload, TD_DownLoadAfterUpload, TD_DownloadUploadToNow  : ParamToBeSend := 'OnlyUpload';
    end;

    for I := 1 to ParamCount do
    begin
     // if (ParamStr(I) = 'LoadAllReq') or (ParamStr(I) = 'MQM_Download_Production') then
     //   ParamToBeSend := 'OnlyProd'
      if (ParamStr(I) = 'LoadOnlyArc') or (ParamStr(I) = 'LoadArcOnly') or (ParamStr(I) = 'MQM_Download_Archives') then
        ParamToBeSend := 'OnlyArchivs'
    //  else if (ParamStr(I) = 'MQM_Download_All_And_Upload') then
    //    ParamToBeSend := 'AllFiles'
      else if (ParamStr(I) = 'MQM_Upload') or (ParamStr(I) = 'OnlyUpload') then
        ParamToBeSend := 'OnlyUpload'
      else if (ParamStr(I) = 'UploadAndDownload')  then
        ParamToBeSend := 'OnlyUpload'
    end;
  end;

  if ParamToBeSend <> '' then
  begin
    Result := true;
    callExternalApplication(IniAppGlobals.PreparationExeName, ParamToBeSend);
  end;

end;

// ----------------------------------------------------------------------------

procedure callExternalApplication(applicationFullPath: String; parameter: String);
var
  procInfo: TProcessInformation;
  startupInfo: TStartupInfo;
begin
  // add null char and a blank char between application and its parameter
  parameter := '\0' + ' ' + parameter;

  // set zero (null) value for the ProcessInformation and StartupInfo
  FillChar(procInfo, sizeof(TProcessInformation), 0);
  FillChar(startupInfo, sizeof(TStartupInfo), 0);
  startupInfo.cb := sizeof(TStartupInfo);

  // try to create the application
  // if created then wait till it closes.
  if ( CreateProcess(pChar(applicationFullPath), pChar(parameter), nil,
                     nil, false, NORMAL_PRIORITY_CLASS, nil, nil,
                     startupInfo, procInfo) <> False ) then
  begin
    try
      // wait till it closes
      WaitForSingleObject(procInfo.hProcess, INFINITE);

      // remove handle
      CloseHandle(procInfo.hProcess);
    except
    on E : EAccessViolation do
      begin
        showmessage('Access violation found');
      end;
    end;

  end
  else
    // error on creating the process
    ShowMessage('Could not create the process of calling to NowMqmSrvLoad program');
end;


end.
