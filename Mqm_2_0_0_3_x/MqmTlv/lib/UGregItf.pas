unit UGregItf;

interface
uses
  Classes;

  function ReadStrFromRegistry(const sez, tag: string; var str: string): boolean;
  function WriteStrToRegistry(const sez, tag: string; str: string): boolean;
  function ReadIntFromRegistry(const sez, tag: string; var int: integer): boolean;
  function WriteIntToRegistry(const sez, tag: string; int: integer): boolean;
  function ReadDtTimeFromRegistry(const sez, tag: string; var DtTime: TDateTime): boolean;
  function WriteDtTimeToRegistry(const sez, tag: string; DtTime: TDateTime): boolean;
  function ReadBoolFromRegistry(const sez, tag: string; var value: boolean): boolean;
  function WriteBoolToRegistry(const sez, tag: string; value: boolean): boolean;

  function ReadODBCFromRegistry(const Alias : string;
                                var Libraries, System : string): boolean;
  function WriteODBCToRegistry(const Alias, Libraries, System : string): boolean;
  function ReadAsNamesFromRegistry(var AsNames : TStringList): boolean;

  procedure ReadStrFromIniNowFile(const sez, tag: string; var str: string; path : string);
  procedure ReadStrFromIniFile(const sez, tag: string; var str: string);
  procedure FillListFromIniFileDB;
  procedure ReadStrFromIniFileDB(const sez, tag: string; var str: string; Station : string);
  procedure WriteStrToIniFile(const sez, tag: string; str: string; Station : string; ByIni : boolean);
  procedure ReadIntFromIniFile(const sez, tag: string; var int: integer);
  procedure WriteIntToIniFile(const sez, tag: string; int: integer);
  procedure ReadDtTimeFromIniFile(const sez, tag: string; var DtTime: TDateTime);
  procedure WriteDtTimeToIniFile(const sez, tag: string; DtTime: TDateTime);
  procedure ReadBoolFromIniFile(const sez, tag: string; var value: boolean);
  procedure WriteBoolToIniFile(const sez, tag: string; value: boolean);

implementation

uses
  Windows,
  forms,
  Sysutils,
  Registry,
  DMsrvPc,
  UMTblDesc,
  UMGlobal,
  UMCommon,
  inifiles;

type
  TFromIniFileDB = record
    FieldName  : string;
    Value : string;
  end;
  PFromIniFileDB = ^TFromIniFileDB;

const
  RegSoft    = '\SOFTWARE';          // software key
  RegDataTex = RegSoft + '\Datatex'; // datatex key
  IniMqmName = 'MQM.Ini';
  IniNowName = 'NOWMQM.Ini';
var
  s_DirPrg:   string;
  s_rootSez:  string;
  s_progName: string;
  s_envName:  string;
  s_ListIniFileDB : TList;

//----------------------------------------------------------------------------//

function ReadStrFromRegistry(const sez, tag: string; var str: string): boolean;
var
  Reg:    TRegistry;
  tmpStr: string;
begin
  Result := false;

  Reg := TRegistry.Create;
  try
    try
//      Reg.RootKey := HKEY_LOCAL_MACHINE;
      Reg.RootKey := HKEY_CURRENT_USER;
      if Reg.OpenKey(s_rootSez + sez, false) then
      begin
        tmpStr := Reg.ReadString(tag);
        if tmpStr <> '' then
        begin
          str := tmpStr;
          Result := True;
        end;
      end
    finally
      Reg.Free
    end
  except
    on ERegistryException do Result := false;
  end
end;

//----------------------------------------------------------------------------//

function WriteStrToRegistry(const sez, tag: string; str: string): boolean;
var
  Reg: TRegistry;
begin
  Result := false;
  Reg := TRegistry.Create;
  try
    try
      Reg.RootKey := HKEY_CURRENT_USER;
      Reg.OpenKey(s_rootSez + sez, true);
      Reg.WriteString(tag, str);
      Result := true
    finally
      Reg.Free
    end
  except
    on ERegistryException do;
  end
end;

//----------------------------------------------------------------------------//

function ReadIntFromRegistry(const sez, tag: string; var int: integer): boolean;
var
  Reg: TRegistry;
begin
  Result := false;

  Reg := TRegistry.Create;
  try
    try
//      Reg.RootKey := HKEY_LOCAL_MACHINE;
      Reg.RootKey := HKEY_CURRENT_USER;
      if Reg.OpenKey(s_rootSez + sez, false) then
      begin
        int := Reg.ReadInteger(tag);
        Result := true
      end
    finally
      Reg.Free
    end
  except
    on ERegistryException do;
  end
end;

//----------------------------------------------------------------------------//

function WriteIntToRegistry(const sez, tag: string; int: integer): boolean;
var
  Reg: TRegistry;
begin
  Result := false;
  Reg := TRegistry.Create;
  try
    try
//      Reg.RootKey := HKEY_LOCAL_MACHINE;
      Reg.RootKey := HKEY_CURRENT_USER;
      Reg.OpenKey(s_rootSez + sez, true);
      Reg.WriteInteger(tag, int);
      Result := true
    finally
      Reg.Free
    end
  except
    on ERegistryException do;
  end
end;

//----------------------------------------------------------------------------//

function ReadDtTimeFromRegistry(const sez, tag: string; var DtTime: TDateTime): boolean;
var
  Reg: TRegistry;
begin
  Result := false;

  Reg := TRegistry.Create;
  try
    try
//      Reg.RootKey := HKEY_LOCAL_MACHINE;
      Reg.RootKey := HKEY_CURRENT_USER;
      if Reg.OpenKey(s_rootSez + sez, false) then
      begin
        DtTime := Reg.ReadDateTime(tag);
        Result := true
      end
    finally
      Reg.Free
    end
  except
    on ERegistryException do;
  end
end;

//----------------------------------------------------------------------------//

function WriteDtTimeToRegistry(const sez, tag: string; DtTime: TDateTime): boolean;
var
  Reg: TRegistry;
begin
  Result := false;
  Reg := TRegistry.Create;
  try
    try
//      Reg.RootKey := HKEY_LOCAL_MACHINE;
      Reg.RootKey := HKEY_CURRENT_USER;
      Reg.OpenKey(s_rootSez + sez, true);
      Reg.WriteDateTime(tag, DtTime);
      Result := true
    finally
      Reg.Free
    end
  except
    on ERegistryException do;
  end
end;

//----------------------------------------------------------------------------//

function ReadBoolFromRegistry(const sez, tag: string; var value: boolean): boolean;
var
  Reg: TRegistry;
begin
  Result := false;

  Reg := TRegistry.Create;
  try
    try
//      Reg.RootKey := HKEY_LOCAL_MACHINE;
      Reg.RootKey := HKEY_CURRENT_USER;
      if Reg.OpenKey(s_rootSez + sez, false) then
      begin
        value := Reg.ReadBool(tag);
        Result := true
      end
    finally
      Reg.Free
    end
  except
    on ERegistryException do;
  end
end;

//----------------------------------------------------------------------------//

function WriteBoolToRegistry(const sez, tag: string; value: boolean): boolean;
var
  Reg: TRegistry;
begin
  Result := false;
  Reg := TRegistry.Create;
  try
    try
//      Reg.RootKey := HKEY_LOCAL_MACHINE;
      Reg.RootKey := HKEY_CURRENT_USER;
      Reg.OpenKey(s_rootSez + sez, true);
      Reg.WriteBool(tag, value);
      Result := true
    finally
      Reg.Free
    end
  except
    on ERegistryException do;
  end
end;

//----------------------------------------------------------------------------//

function ReadODBCFromRegistry(const Alias : string;
                              var Libraries, System : string): boolean;
var
  Reg: TRegistry;
begin
  Result := false;
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey('\SOFTWARE\ODBC\ODBC.INI\' + Alias, false) then
    begin
      Libraries := Reg.ReadString('DefaultLibraries');
      System   := Reg.ReadString('System');
      Result := true
    end
  finally
    Reg.Free
  end
end;

//----------------------------------------------------------------------------//

function WriteODBCToRegistry(const Alias, Libraries, System : string): boolean;
var
  Reg: TRegistry;
  DriverRoot: string;
begin
  Result := false;
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey('\SOFTWARE\ODBC\ODBCINST.INI\Client Access ODBC Driver (32-bit)', false) then
       DriverRoot := Reg.ReadString('Driver')
    else
      exit;

    if Reg.OpenKey('\SOFTWARE\ODBC\ODBC.INI\' + Alias, true) then
    begin
      Reg.WriteString('AllowDataCompression', '0');
      Reg.WriteString('AllowUnsupportedChar', '0');
      Reg.WriteString('AlwaysScrollable', '0');
      Reg.WriteString('BlockSizeKB', '0');
      Reg.WriteString('CCSID', '');
      Reg.WriteString('CommitMode', '0');
      Reg.WriteString('ConnectionType', '0');
      Reg.WriteString('DateFormat', '5');
      Reg.WriteString('DateSeparator', '0');
      Reg.WriteString('Decimal', '0');
      Reg.WriteString('DefaultLibraries', Libraries);
      Reg.WriteString('DefaultPkgLibrary', 'QGPL');
      Reg.WriteString('Description', ' ODBC data connection for VIP');
      Reg.WriteString('Driver', DriverRoot);
      Reg.WriteString('ExtendedDynamic', '0');
      Reg.WriteString('ForceTranslation', '0');
      Reg.WriteString('LanguageID', 'ENU');
      Reg.WriteString('LazyClose', '0');
      Reg.WriteString('LibraryView', '0');
      Reg.WriteString('ManagedDataSource', '0');
      Reg.WriteString('MaxFieldLength', '32');
      Reg.WriteString('Naming', '1');
      Reg.WriteString('ODBCRemarks', '0');
      Reg.WriteString('PreFetch', '0');
      Reg.WriteString('RecordBlocking', '2');
      Reg.WriteString('SearchPattern', '0');
      Reg.WriteString('SortSequence', '0');
      Reg.WriteString('SortTable', '');
      Reg.WriteString('SortWeight', '0');
      Reg.WriteString('System', System);
      Reg.WriteString('TimeFormat', '0');

      Reg.WriteString('TimeSeparator', '0');
      Reg.WriteString('TranslationDLL', '');
      Reg.WriteString('TranslationOption', '');
    end;
    if Reg.OpenKey('\Software\ODBC\ODBC.INI\ODBC Data Sources', false) then
      Reg.WriteString(Alias, 'Client Access ODBC Driver (32-bit)');
  finally
    Reg.Free
  end;
  Result := true
end;

//----------------------------------------------------------------------------//

function ReadAsNamesFromRegistry(var AsNames : TStringList): boolean;
var
  Reg: TRegistry;
begin
  Result := false;
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey('\SOFTWARE\IBM\Client Access\CurrentVersion\Global System Information',false) then
    begin
      Reg.GetKeyNames(AsNames);
      Result := true
    end
  finally
    Reg.Free
  end
end;

//----------------------------------------------------------------------------//

procedure ReadStrFromIniNowFile(const sez, tag: string; var str: string; path : string);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(path + IniNowName);
  str := Ini.ReadString(sez,tag,str);
  Ini.Free;
end;

//----------------------------------------------------------------------------//

procedure ReadStrFromIniFile(const sez, tag: string; var str: string);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(s_DirPrg + IniMqmName);
  str := Ini.ReadString(sez,tag,str);
  Ini.Free;
end;

//----------------------------------------------------------------------------//

procedure FillListFromIniFileDB;
var
  qry: TMqmQuery;
  tbInfo: ^TTblInfo;
  FromIniFileDB : PFromIniFileDB;
begin
  qry := CreateQuery(Cfg_DB);
  tbInfo := @tblInfo[tbl_cfg_appIni];
  qry.SQL.Clear;
  qry.SQL.add('select * from ' + tbInfo.GetTableName + ' where ');
  qry.SQL.add(CreateFld(tbInfo.pfx, fli_wkstCode) + '=''' + IniAppGlobals.WkstCode + '''');
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.open;
  with qry do
  begin
    while not qry.eof do
    begin
      new(FromIniFileDB);
      FromIniFileDB.FieldName := qry.FieldByName(CreateFld(tbInfo.pfx, fli_FieldName)).AsString;
      FromIniFileDB.Value := qry.FieldByName(CreateFld(tbInfo.pfx, fli_value)).AsString;
      s_ListIniFileDB.Add(FromIniFileDB);
      next;
    end;
  end;

  qry.Close;

end;

//----------------------------------------------------------------------------//

procedure ReadStrFromIniFileDB(const sez, tag: string; var str: string; Station : string);
var
  I : Integer;
//  qry: TMqmQuery;
//  tbInfo: ^TTblInfo;
begin
  for I := 0 to s_ListIniFileDB.Count - 1 do
  begin
    if PFromIniFileDB(s_ListIniFileDB[I]).FieldName = tag then
    begin
      str := PFromIniFileDB(s_ListIniFileDB[I]).Value;
      break;
    end;
  end;

//  qry := CreateQuery(Cfg_DB);
//  tbInfo := @tblInfo[tbl_cfg_appIni];
//  qry.SQL.Clear;
//  qry.SQL.add('select ' + CreateFld(tbInfo.pfx, fli_value) + ' from ' + tbInfo.GetTableName + ' where ');
//  qry.SQL.add(CreateFld(tbInfo.pfx, fli_wkstCode) + '=''' + Station + '''');
//  qry.SQL.add(' and ' + CreateFld(tbInfo.pfx, fli_FieldName) + '=''' + tag + '''');
//  qry.open;
//  if not qry.Eof then
//  begin
//    str := qry.FieldByName(CreateFld(tbInfo.pfx, fli_value)).AsString;
//  end;
//  qry.free;

{var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(s_DirPrg + IniName);
  str := Ini.ReadString(sez,tag,str);
  Ini.Free;  }

end;

//----------------------------------------------------------------------------//

procedure WriteStrToIniFile(const sez, tag: string; str: string; Station : string; ByIni : boolean);
var
  Ini: TIniFile;
  qry: TMqmQuery;
  tbInfo: ^TTblInfo;
begin
  if ByIni then
  begin
    Ini := TIniFile.Create(s_DirPrg + IniMqmName);
    Ini.WriteString(sez,tag,str);
    Ini.Free
  end
  else
  begin
    if ExtractFileName(Application.ExeName) = 'MqmConfig.exe' then
      exit;
    qry := CreateQuery(Cfg_DB);
    qry.Transaction := CreateTransaction(Cfg_DB);
    qry.Transaction.StartTransaction;

    tbInfo := @tblInfo[tbl_cfg_appIni];
    qry.SQL.Clear;
    qry.SQL.add('select * from ' + tbInfo.GetTableName + ' where ');
    qry.SQL.add(CreateFld(tbInfo.pfx, fli_wkstCode) + '=''' + Station + '''');
    qry.SQL.add(' and ' + CreateFld(tbInfo.pfx, fli_FieldName) + '=''' + tag + '''');
    qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
    qry.open;
    if qry.Eof then
    begin
      qry.SQL.Clear;
      qry.SQL.add('Insert into ' + tbInfo.GetTableName +  ' (' + CreateFld(tbInfo.pfx, fli_wkstCode) + ',' + CreateFld(tbInfo.pfx, fli_FieldName)
          + ',' + CreateFld(tbInfo.pfx, fli_value) + ',' + CreateFld(tbInfo.pfx, fli_IDENTIFIER) +  ' ) values (' + QuotedStr(Station) + ',' + QuotedStr(tag) + ',' + QuotedStr(str) + ',' + IniAppGlobals.Identifier + ')');
      qry.ExecSQL;
    end
    else
    begin
      qry.SQL.Clear;
      qry.SQL.add('update ' + tbInfo.GetTableName + ' set ' + CreateFld(tbInfo.pfx, fli_value) + ' = ' + QuotedStr(str));
      qry.SQL.add(' where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + ' = ' + QuotedStr(Station) + ' AND ' + CreateFld(tbInfo.pfx, fli_FieldName) + ' = ' + QuotedStr(tag));
      qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
      qry.ExecSQL;
    end;
    Qry.Transaction.Commit;
    qry.free;
  end;

end;

//----------------------------------------------------------------------------//

procedure ReadIntFromIniFile(const sez, tag: string; var int: integer);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(s_DirPrg + IniMqmName);
  int := Ini.ReadInteger(s_rootSez +sez, tag, int);
  Ini.Free
end;

//----------------------------------------------------------------------------//

procedure WriteIntToIniFile(const sez, tag: string; int: integer);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(s_DirPrg + IniMqmName);
  Ini.WriteInteger(s_rootSez + sez,tag,int);
  Ini.Free
end;

//----------------------------------------------------------------------------//

procedure ReadDtTimeFromIniFile(const sez, tag: string; var DtTime: TDateTime);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(s_DirPrg + IniMqmName);
  DtTime := Ini.ReadDateTime(s_rootSez + sez, tag, DtTime);
  Ini.Free
end;

//----------------------------------------------------------------------------//

procedure WriteDtTimeToIniFile(const sez, tag: string; DtTime: TDateTime);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(s_DirPrg + IniMqmName);
  Ini.WriteDateTime(s_rootSez + sez, tag, DtTime);
  Ini.Free
end;

//----------------------------------------------------------------------------//

procedure ReadBoolFromIniFile(const sez, tag: string; var value: boolean);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(s_DirPrg + IniMqmName);
  value :=Ini.ReadBool(s_rootSez + sez, tag, value);
  Ini.Free
end;

//----------------------------------------------------------------------------//

procedure WriteBoolToIniFile(const sez, tag: string; value: boolean);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(s_DirPrg + IniMqmName);
  Ini.WriteBool(s_rootSez + sez, tag, value);
  Ini.Free
end;

//----------------------------------------------------------------------------//

initialization

  s_progName := '';
  s_envName  := '';
  s_ListIniFileDB := TList.Create;
  s_DirPrg := ExtractFilePath(Application.ExeName);

//----------------------------------------------------------------------------//
end.









