unit uODBC;

interface
Uses Windows, Classes, SysUtils, Registry;

Type
  TDSN_Type       = (dtUSER, dtSYSTEM);
  TDSN_Types      = Set of TDSN_Type;


function GetODBCDriversList: TStrings;
function GetDSNList (aDSN_TYPES: TDSN_Types; aDriverFilter: String): TStrings;

implementation

function GetODBCDriversList: TStrings;

  // This function returns a list of currently installed ODBC drivers
  // Example: combobox1.Assign(GetODBCDriversList); // ;)

var
  aStringlist   : TStringlist;
  aRegistry   : TRegistry;
Begin
  aStringlist:= Tstringlist.Create;
  aRegistry:= TRegistry.Create;
  Result:= Tstringlist.Create;

  with aRegistry do
  Begin
    rootkey:= HKEY_LOCAL_MACHINE;
    OpenKey('Software\ODBC\ODBCINST.INI\ODBC Drivers',False);
    GetValueNames(aStringlist);
  End;
  aRegistry.Free;
  aStringlist.Sort;
  result.AddStrings(aStringlist);
  aStringlist.Free;
End;

function GetDSNList (aDSN_TYPES: TDSN_Types; aDriverFilter: String): TStrings;

  // This function returns a list of dsn( user's dsn (dtUser),
  // system's dsn (dtSystem), or both), where driver contains aDriverFilter,
  // it can be complete driver name or part of it;
  //       (Example: 'Microsoft Access Driver (*.mdb)' or 'Access').
  //
  // Example: listbox1.Items.Assign(GetDSNList([dtUser,dtSystem],'Access');
  // It will return a list with all existing DSN both from User and System with
  // string 'Access' in driver's name.

var
  aStringList : TStringlist;

  aStrings1   : TStrings;
  aStrings2   : Tstrings;
  aString     : String;

  aRegistry   : TRegistry;
  aInt        : Integer;
Begin
  aStringlist:=TStringlist.Create;
  aStrings1:=TStringlist.Create;
  aStrings2:=TStringlist.Create;

  If dtUSER in aDSN_TYPES then
  Begin
    aRegistry:= Tregistry.Create;
    With aRegistry do
    Begin
      RootKey:=HKEY_CURRENT_USER;
      OpenKey('Software\ODBC\ODBC.INI\ODBC Data Sources',False);
      GetValueNames(aStrings1);
      for aInt:=aStrings1.Count-1 downto 0 do
      Begin
        aString:= ReadString(aStrings1.Strings[aInt]);
        if ((Pos( aDriverFilter, aString ) = 0) and (aDriverFilter<>''))  then
          aStrings1.Delete(aInt);
      End;
    End;
    aRegistry.Free;
  end;

  If dtSYSTEM in aDSN_TYPES then
  Begin
    aRegistry:= Tregistry.Create;
    With aRegistry do
    Begin
      RootKey:=HKEY_LOCAL_MACHINE;
      OpenKey('Software\ODBC\ODBC.INI\ODBC Data Sources',False);
      GetValueNames(aStrings2);
      for aInt:=aStrings2.Count-1 downto 0 do
      Begin
        aString:= ReadString(aStrings2.Strings[aInt]);
        if ((Pos( aDriverFilter, aString) = 0) and (aDriverFilter<>''))  then
          aStrings2.Delete(aInt);
      End;
    End;
    aRegistry.Free;
  end;

  aStringlist.AddStrings(aStrings1);
  aStrings1.Free;
  aStringlist.AddStrings(aStrings2);
  aStrings2.Free;
  aStringlist.Sort;
  result:= Tstringlist.Create;
  result.Assign(aStringlist);
End;

end.




