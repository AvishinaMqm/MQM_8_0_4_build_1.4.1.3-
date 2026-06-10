unit FuncImpl;

interface

  // mqm
  function GetLockCodeMqm(): integer; cdecl; export;
  function GetUDFcodeMqm(var code: integer): integer; cdecl; export;

  // Mcm
  function GetLockCodeMcm(): integer; cdecl; export;
  function GetUDFcodeMcm(var code: integer): integer; cdecl; export;

implementation

uses
  Windows;

//----------------------------------------------------------------------------//

function GetLockCodeMqm(): integer;
var
  aDirectory: array[0..1023] of Char;
  sDrive: Char;
begin
  GetWindowsDirectory(aDirectory, SizeOf(aDirectory));
  sDrive := aDirectory[0];
  if GetVolumeInformation(PChar(sDrive + ':\'), nil, 0, @Result,
           DWORD(nil^), DWORD(nil^), nil, 0) then
    Result := Result xor $0FCD231A
  else
    Result := 0
end;

//----------------------------------------------------------------------------//

function GetUDFcodeMqm(var code: integer): integer;
begin
  Result := (code * 5 + 45) div 3 - 2
end;

//----------------------------------------------------------------------------//

function GetLockCodeMcm(): integer;
var
  aDirectory: array[0..1023] of Char;
  sDrive: Char;
begin
  GetWindowsDirectory(aDirectory, SizeOf(aDirectory));
  sDrive := aDirectory[0];
  if GetVolumeInformation(PChar(sDrive + ':\'), nil, 0, @Result,
           DWORD(nil^), DWORD(nil^), nil, 0) then
    Result := Result xor $0FCD231A
  else
    Result := 0
end;

//----------------------------------------------------------------------------//

function GetUDFcodeMcm(var code: integer): integer;
begin
  Result := (code * 5 + 45) div 3 - 2
end;

end.










