unit UGLicensing;

interface

uses
  classes,
  gnugettext,
  Windows;

const

  CLicLen   = 512;
  CcrcLen   = 50;
  CavailLen = CLicLen - CcrcLen;
  CcharBase = 65;

  INST_DEMO      = 1;
  INST_CUST_DEMO = 2;
  INST_CUSTOMER  = 3;

type

  TRecLicVers1 = record
    licType:        BYTE;
    issuer:         string;
    customer:       string;
    releaseDate:    TDateTime;
    lockNum:        integer;
    instType:       BYTE;
    maxSupp:        BYTE;
    maxCont:        BYTE;

    expiryDate:     TDateTime;
    configEnabled:  BYTE;
    MQMORMCM  : BYTE;
  end;

  TLicMemory = array [0..CLicLen-1] of BYTE;

  function  SetLic(var lic: TLicMemory): string;
  function  SetLicMcm(var lic: TLicMemory): string;
  procedure SetDemoLic(lockCode: integer);
  procedure SetDemoLicMcm(lockCode: integer);
  function  GetLicVer(var arr: TLicMemory; out strErr: string): integer;
  function  EncodeLicVers1(var lic: TRecLicVers1; var arr: TLicMemory; out errStr: string): boolean;
  function  DecodeLicVers1(out lic: TRecLicVers1; var arr: TLicMemory; out strErr: string): boolean;
  function  SaveLicToFile(fName: string; var arr: TLicMemory): boolean;
  function  LoadLicFromFile(fName: string; var arr: TLicMemory): boolean;
  function  TextLic(str: TStrings; var arr: TLicMemory; MQM_MCM : integer) : boolean;
  function  LicToString(var arr: TLicMemory): string;
  procedure StringToLic(str: string; var arr: TLicMemory);
  function  GetLockCode(): integer;

var
  s_licBytes : TLicMemory;
  s_licBytesMcm : TLicMemory;

implementation

uses
  SysUtils;

const
  CLicDetect ='Datatex licence';

type
  TBPTR = ^BYTE;

//----------------------------------------------------------------------------//

procedure SetBackground(arr: TLicMemory);
var
  i: integer;
begin
  for i := 0 to (CLicLen-1) do
    arr[i] := $46
end;

//----------------------------------------------------------------------------//

procedure Rumorize(var arr: TLicMemory);
var
  i: integer;
  x: BYTE;
begin
  x := 0;
  for i := 0 to (CLicLen-1) do
  begin
    arr[i] := arr[i] xor x;
    if x > 254 then
      x := 0
    else
      Inc(x)
  end
end;

//----------------------------------------------------------------------------//

procedure Scramble(var arr: TLicMemory);
var
  i, pos: integer;
  swap:   BYTE;
begin
  pos := 0;
  for i := 0 to ((CLicLen-3) div 4) do
  begin
    swap := arr[pos];
    arr[pos] := arr[CLicLen-1-pos];
    arr[CLicLen-1-pos] := swap;
    Inc(pos);
    Inc(pos)
  end
end;

//----------------------------------------------------------------------------//

procedure SetCRC(var arr: TLicMemory);
var
  i: integer;
  k: integer;
begin
  for i := CavailLen to (CLicLen-1) do
    arr[i] := 0;

  k := CavailLen;
  for i := 0 to (CavailLen-1) do
  begin
    arr[k] := arr[k] xor arr[i];
    Inc(k);
    if k = CLicLen then
      k := CavailLen
  end
end;

//----------------------------------------------------------------------------//

function CheckCRC(var arr: TLicMemory): boolean;
var
  i:        integer;
  licBytes: TLicMemory;
begin

  for i := 0 to (CLicLen-1) do
    licBytes[i] := arr[i];

  SetCRC(licBytes);

  for i := CavailLen to (CLicLen-1) do
    if licBytes[i] <> arr[i] then
    begin
      Result := false;
      exit
    end;

  Result := true
end;

//----------------------------------------------------------------------------//

function SetLic(var lic: TLicMemory): string;
var
  i: integer;
begin
  for i := 0 to (CLicLen-1) do
    s_licBytes[i] := lic[i]
end;

//----------------------------------------------------------------------------//

function SetLicMcm(var lic: TLicMemory): string;
var
  i: integer;
begin
  for i := 0 to (CLicLen-1) do
    s_licBytesMcm[i] := lic[i]
end;

//----------------------------------------------------------------------------//

procedure SetDemoLic(lockCode: integer);
var
  lic:    TRecLicVers1;
  arr:    TLicMemory;
  errStr: string;
begin
  lic.licType     := 1;
  lic.issuer      := 'Datatex A.G.';
  lic.customer    := 'anyone';
  lic.releaseDate := Now;
  lic.lockNum     := lockCode;
  lic.instType    := INST_DEMO;
  lic.maxSupp     := 3;
  lic.maxCont     := 3;

  lic.expiryDate     := 0;
  lic.configEnabled  := 0;
  lic.MQMORMCM := 0;

  EncodeLicVers1(lic, arr, errStr);
  SetLic(arr)
end;

//----------------------------------------------------------------------------//

procedure SetDemoLicMcm(lockCode: integer);
var
  lic:    TRecLicVers1;
  arr:    TLicMemory;
  errStr: string;
begin
  lic.licType     := 1;
  lic.issuer      := 'Datatex A.G.';
  lic.customer    := 'anyone';
  lic.releaseDate := Now;
  lic.lockNum     := lockCode;
  lic.instType    := INST_DEMO;
  lic.maxSupp     := 3;
  lic.maxCont     := 3;

  lic.expiryDate     := 0;
  lic.configEnabled  := 0;
  lic.MQMORMCM := 0;

  EncodeLicVers1(lic, arr, errStr);
  SetLicMcm(arr)
end;

//----------------------------------------------------------------------------//

function EncodeEightBytes(var buf: TLicMemory; ptr: TBPTR; start: integer): integer;
begin
  buf[start+0] := ptr^;
  Inc(ptr);
  buf[start+1] := ptr^;
  Inc(ptr);
  buf[start+2] := ptr^;
  Inc(ptr);
  buf[start+3] := ptr^;
  Inc(ptr);
  buf[start+4] := ptr^;
  Inc(ptr);
  buf[start+5] := ptr^;
  Inc(ptr);
  buf[start+6] := ptr^;
  Inc(ptr);
  buf[start+7] := ptr^;

  Result := start + 8
end;

//----------------------------------------------------------------------------//

function DecodeFourBytes(buf: TLicMemory; ptr: TBPTR; start: integer): integer;
begin
  ptr^ := buf[start+0];
  Inc(ptr);
  ptr^ := buf[start+1];
  Inc(ptr);
  ptr^ := buf[start+2];
  Inc(ptr);
  ptr^ := buf[start+3];

  Result := start + 4
end;

//----------------------------------------------------------------------------//

function DecodeEightBytes(buf: TLicMemory; ptr: TBPTR; start: integer): integer;
begin
  ptr^ := buf[start+0];
  Inc(ptr);
  ptr^ := buf[start+1];
  Inc(ptr);
  ptr^ := buf[start+2];
  Inc(ptr);
  ptr^ := buf[start+3];
  Inc(ptr);
  ptr^ := buf[start+4];
  Inc(ptr);
  ptr^ := buf[start+5];
  Inc(ptr);
  ptr^ := buf[start+6];
  Inc(ptr);
  ptr^ := buf[start+7];

  Result := start + 8
end;

//----------------------------------------------------------------------------//

function CopyStrToNull(str: string; var arr: TLicMemory; start: integer): integer;
begin
  Result := start;
  for start := 1 to Length(str) do
  begin
    arr[Result] := BYTE(str[start]);
    Inc(Result)
  end;
  arr[Result] := 0;
  Inc(Result)
end;

//----------------------------------------------------------------------------//

function CopyNullToStr(arr: TLicMemory; var str: string; start: integer): integer;
begin
  str := '';
  Result := start;
  while arr[Result] <> 0 do
  begin
    str := str + Char(arr[Result]);
    Inc(Result)
  end;
  Inc(Result)
end;

//----------------------------------------------------------------------------//

function PreTreatment(var arr: TLicMemory; out strErr: string; out pos: integer): boolean;
var
  licId: string;
begin
  Rumorize(arr);
  Scramble(arr);

  if not CheckCRC(arr) then
  begin
    strErr := ('License is not Installed');
    Result := false;
    exit
  end;

  pos := 0;
  pos := CopyNullToStr(arr, licId, pos);

  if licId <> CLicDetect then
  begin
    strErr := _('Not a Datatex MQM license');
    Result := false;
    exit
  end;

  Result := true
end;

//----------------------------------------------------------------------------//

function GetLicVer(var arr: TLicMemory; out strErr: string): integer;
var
  pos:      integer;
  licBytes: TLicMemory;
begin
  for pos := 0 to (CLicLen-1) do
    licBytes[pos] := arr[pos];

  if PreTreatment(licBytes, strErr, pos) then
    Result := licBytes[pos]
  else
    Result := -1
end;

//----------------------------------------------------------------------------//

function EncodeFourBytes(var buf: TLicMemory; ptr: TBPTR; start: integer): integer;
begin
  buf[start+0] := ptr^;
  Inc(ptr);
  buf[start+1] := ptr^;
  Inc(ptr);
  buf[start+2] := ptr^;
  Inc(ptr);
  buf[start+3] := ptr^;

  Result := start + 4
end;

//----------------------------------------------------------------------------//

function EncodeLicVers1(var lic: TRecLicVers1; var arr: TLicMemory; out errStr: string): boolean;
var
  pos: integer;
begin
  Result := false;

  if (lic.licType <> 0) and (lic.licType <> 1) then
  begin
    errStr := _('Unknown license type');
    exit
  end;

  SetBackground(arr);

  pos := 0;
  pos := CopyStrToNull(CLicDetect,   arr, pos);
  arr[pos] := 1;
  Inc(pos);
  arr[pos] := lic.licType;
  Inc(pos);

  errStr := _('Too many characters');
  if lic.licType = 0 then
  begin
    if (pos+Length(lic.customer)+1) > CavailLen then exit;
    pos := CopyStrToNull(lic.customer, arr, pos);
    if (pos+8) > CavailLen then exit;
    pos := EncodeEightBytes(arr, @lic.releaseDate, pos);
    if (pos+4) > CavailLen then exit;
    EncodeFourBytes(arr, @lic.lockNum, pos);
    errStr := ''
  end
  else
  begin
    if (pos+Length(lic.issuer)+1) > CavailLen then exit;
    pos := CopyStrToNull(lic.issuer,   arr, pos);
    if (pos+Length(lic.customer)+1) > CavailLen then exit;
    pos := CopyStrToNull(lic.customer, arr, pos);
    if (pos+8) > CavailLen then exit;
    pos := EncodeEightBytes(arr, @lic.releaseDate, pos);
    if (pos+4) > CavailLen then exit;
    pos := EncodeFourBytes(arr, @lic.lockNum, pos);

    if (pos+3) > CavailLen then exit;
    arr[pos] := lic.instType;
    Inc(pos);
    arr[pos] := lic.maxSupp;
    Inc(pos);
    arr[pos] := lic.maxCont;
    Inc(pos);

    if (pos+8) > CavailLen then exit;
    pos := EncodeEightBytes(arr, @lic.expiryDate, pos);
    if (pos+2) > CavailLen then exit;
    arr[pos] := lic.configEnabled;
    Inc(pos);
    arr[pos] := lic.MQMORMCM
  end;

  SetCRC(arr);
  Scramble(arr);
  Rumorize(arr);
  Result := true
end;

//----------------------------------------------------------------------------//

function DecodeLicVers1(out lic: TRecLicVers1; var arr: TLicMemory; out strErr: string): boolean;
var
  pos:      integer;
  licBytes: TLicMemory;
begin
  {$ifdef Develop}
    lic.licType     := 1;
    lic.issuer      := 'For Development Only ';
    lic.customer    := 'Datatex';
    lic.releaseDate := now;
    lic.lockNum     := GetLockCode();
    lic.instType    := INST_CUSTOMER;
    lic.maxSupp     := 15;
    lic.maxCont     := 15;
    lic.expiryDate  := 0;
    lic.configEnabled := 10;
    lic.srvLoadEnabled := 1;

    Result := true;
    exit;
  {$endif}

  Result := false;

  strErr := '';

  for pos := 0 to (CLicLen-1) do
    licBytes[pos] := arr[pos];

  if not PreTreatment(licBytes, strErr, pos) then exit;

  if licBytes[pos] <> 1 then
  begin
    strErr := _('Not a "Version 1" Datatex MQM license');
    exit
  end;

  Inc(pos);

  if licBytes[pos] = 0 then
  begin
    // handle lock licence
    lic.licType := licBytes[pos];

    Inc(pos);

    pos := CopyNullToStr(licBytes, lic.customer, pos);
    pos := DecodeEightBytes(licBytes, @lic.releaseDate, pos);
    pos := DecodeFourBytes(licBytes, @lic.lockNum, pos);

    Result := true
  end
  else if licBytes[pos] = 1 then
  begin
    lic.licType := licBytes[pos];

    Inc(pos);

    pos := CopyNullToStr(licBytes, lic.issuer,   pos);
    pos := CopyNullToStr(licBytes, lic.customer, pos);
    pos := DecodeEightBytes(licBytes, @lic.releaseDate, pos);
    pos := DecodeFourBytes(licBytes, @lic.lockNum, pos);

    lic.instType := licBytes[pos];
    Inc(pos);
    lic.maxSupp := licBytes[pos];
    Inc(pos);
    lic.maxCont := licBytes[pos];
    Inc(pos);

    pos := DecodeEightBytes(licBytes, @lic.expiryDate, pos);
    lic.configEnabled := licBytes[pos];
    Inc(pos);
    lic.MQMORMCM := licBytes[pos];

    Result := true
  end
  else
    strErr := _('Unknown license type')
end;

//----------------------------------------------------------------------------//

function SaveLicToFile(fName: string; var arr: TLicMemory): boolean;
var
  sl:  TStringList;
  pos: integer;
  c:   integer;
  str: string;
begin
  sl := TStringList.Create;

  str := '';
  c   := 0;
  for pos := 0 to (CLicLen-1) do
  begin
    str := str + Char((arr[pos] and $0F) + CcharBase) + Char(((arr[pos] and $F0) shr 4) + CcharBase);
    Inc(c);
    if c = 32 then
    begin
      c := 0;
      sl.Add(str);
      str := ''
    end
  end;

  if str <> '' then sl.Add(str);

  sl.SaveToFile(fName);
  sl.Free;
  Result := true
end;

//----------------------------------------------------------------------------//

function LoadLicFromFile(fName: string; var arr: TLicMemory): boolean;
var
  sl:  TStringList;
  pos: integer;
  i:   integer;
  c:   integer;
  bc:  integer;
  bb:  array[1..2] of byte;
  str: string;
begin
  sl := TStringList.Create;
  sl.LoadFromFile(fName);

  Result := true;

  bc  := 1;
  pos := 0;

  for i := 0 to sl.Count-1 do
  begin
    str := sl[i];

    for c := 1 to Length(str) do
    begin
      bb[bc] := BYTE(str[c]);
      Inc(bc);
      if bc = 3 then
      begin
        arr[pos] := (bb[1] - CcharBase) or ((bb[2] - CcharBase) shL 4);
        Inc(pos);
        bc := 1
      end
    end
  end;

  sl.Free
end;

//----------------------------------------------------------------------------//

function TextLic(str: TStrings; var arr: TLicMemory; MQM_MCM : integer) : boolean;
var
  licVer: integer;
  strErr: string;
  rec:    TRecLicVers1;
begin
  str.Clear;
  result := true;
  licVer := GetLicVer(arr, strErr);
  if licVer <= 0 then
  begin
    str.Add(strErr);
    exit
  end;

  if licVer = 1 then
  begin
    str.Add(_('License version         : 1.00'));

    if not DecodeLicVers1(rec, arr, strErr) then
    begin
      str.Add(strErr);
      exit
    end;

    if rec.licType = 0 then
    begin
      str.Add(_('License type') + '            : ' + _('lock'));
      str.Add(_('Customer') + '                : ' + rec.customer);
      str.Add(_('Release date') + '            : ' + DateToStr(rec.releaseDate));
      str.Add(_('Lock number') + '             : ' + IntToStr(rec.lockNum));
    end

    else
    begin

      if MQM_MCM <> rec.MQMORMCM then
      begin
        rec.issuer      := 'Datatex A.G.';
        rec.customer    := 'anyone';
        rec.releaseDate := Now;
        rec.instType    := INST_DEMO;
        rec.maxSupp     := 3;
        rec.maxCont     := 3;
        rec.expiryDate     := 0;
        rec.configEnabled  := 0;
        rec.MQMORMCM := 0;
        result := false;
      end;

      str.Add(_('License type') + '            : ' + _('access'));
      str.Add(_('Issuer') + '                  : ' + rec.issuer);
      str.Add(_('Customer') + '                : ' + rec.customer);
      str.Add(_('Release date') + '            : ' + DateToStr(rec.releaseDate));
      str.Add(_('Lock number') + '             : ' + IntToStr(rec.lockNum));

      if      rec.instType = INST_DEMO then
        str.Add(_('Access type') + '             : ' + _('no save for new PS'))
      else if rec.instType = INST_CUST_DEMO then
        str.Add(_('Access type') + '             : ' + _('no save'))
      else if rec.instType = INST_CUSTOMER then
        str.Add(_('Access type') + '             : ' + _('everything allowed'));

      str.Add(_('Concurrent viewers  :') + ' ' + IntToStr(rec.maxSupp));
      str.Add(_('Concurrent planners :') + ' ' + IntToStr(rec.maxCont));

      if rec.expiryDate = 0 then
        str.Add(_('Expiry date') + '             : ' +_('none'))
      else
        str.Add(_('Expiry date') + '             : ' + DateToStr(rec.expiryDate));

      str.Add(_('Config enable level') + ' : ' + IntToStr(rec.configEnabled));

      if rec.MQMORMCM = 2 then
        str.Add(_('MQM license enabled : yes'))
      else if rec.MQMORMCM = 3 then
        str.Add(_('MCM license enabled : yes'))
      else
        str.Add(_('license enabled : No'))
    end
  end
  else
    str.Add(_('Unsupported version'))
end;

//----------------------------------------------------------------------------//

function LicToString(var arr: TLicMemory): string;
var
  pos: integer;
begin
  Result := '';

  for pos := 0 to (CLicLen-1) do
    Result := Result + Char((arr[pos] and $0F) + CcharBase) + Char(((arr[pos] and $F0) shr 4) + CcharBase)
end;

//----------------------------------------------------------------------------//

procedure StringToLic(str: string; var arr: TLicMemory);
var
  pos,bc,i: integer;
  bb:       array[1..2] of byte;
begin
  bc  := 1;
  pos := 0;

  for i := 1 to Length(str) do
  begin
    bb[bc] := BYTE(str[i]);
    Inc(bc);
    if bc = 3 then
    begin
      arr[pos] := (bb[1] - CcharBase) or ((bb[2] - CcharBase) shL 4);
      Inc(pos);
      bc := 1
    end
  end
end;

//----------------------------------------------------------------------------//

function GetLockCode(): integer;
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

end.

