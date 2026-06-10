unit UMBinMatDefault;

interface

uses
  Windows, DMsrvPc, UMSchedContFunc, UMBinDefault;

{type
  TBinColCurrent = Record
    Field     : CBinColId;
    Title     : string;
    Pos       : integer;
    Width     : integer;
    Visible   : boolean;
    Order     : integer;
    RealPos   : integer;
    PropCode  : string;
    DescendingSort : boolean;
    Index     : integer;
    NumColSorted : Integer;
  end;

  TBinColDefault = Record
    Field     : CBinColId;
    FieldName : string;
    Title     : Integer;
    Pos       : integer;
    Width     : integer;
    Visible   : boolean;
    Order     : integer;
    Index     : integer;
    PropCode  : string;
    NumColSorted : Integer;
  end;      }

  procedure LoadDefaultMatBinTabsSet;
  procedure SaveDefaultTabBinMatSet;

  function  CheckErrorInArrayWidth : boolean;
  function  GetNumberFieldsMat : integer;

  procedure ConfBinLoadDefaultValues(var ColArray : array of TBinColCurrent);
  procedure FixOldArrayBinColMat(var BinColArray : array of TBinColCurrent; LastEntry: Integer);
  function  GiveTempTitle(I : Integer ; var IsExistProp : boolean ; PropPosition : Integer) : string;
  function  CheckIfBinColIdIsProp(ColId : CBinColId) : boolean;
  procedure OrganizeBinMatDefaultTabs;
  procedure OrganizeBinMatDefaultTabColumnSetForNewPropSet;

var

  BinMatDefaultTabColumnSet: array [0..71] of TBinColCurrent;
  BinDefaultFromDB_Mat : boolean;

const
 // BinColNum = 71;  //the number of Bin Columns - used at Bar text config
  //The Index field is a STATIC number - do not change it even when adding new fields to the bin
  //It is needed for the Bar Text config.

   TitleMatTemp : array [0..71] of string =

  ('Prod type',
   'Product Code',
   'Request number',
   'Sub Detail',
   'Detail Code',
   'Quantity',
   'Net Group Code',
   'Resource code',
   'Execution Time',
   'Schedule Start',
   'Schedule End',
   'Warp level',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' ',
   ' '
   );

  BinMatColDefault: array [0..71] of TBinColDefault = (
    (Field: CSC_Mat_Item_Type;               FieldName : 'CSC_Mat_Prod_type';             Title: 0;  Pos:  0;  Width: 80; Visible: true;  Order: 0; Index:0;   NumColSorted:3),    // PRODUCTION. REQ.
    (Field: CSC_Mat_PRODUCT_CODE;            FieldName : 'CSC_Mat_Product_Code';          Title: 1;  Pos:  1;  Width: 300; Visible: true; Order: 1; Index:1;   NumColSorted:3),    // PRODUCTION. REQ.
    (Field: CSC_Mat_Request_number;          FieldName : 'CSC_Mat_Request_number';        Title: 2;  Pos:  2;  Width: 220; Visible: true; Order: 2; Index:2;   NumColSorted:3),    // STEP
    (Field: CSC_Mat_MATERIAL_CODE_SUB_DET;   FieldName : 'CSC_Mat_MATERIAL_CODE_SUB_DET'; Title: 3;  Pos:  3;  Width: 150; Visible: true; Order: 3; Index:3;   NumColSorted:3),    // SUB STEP
    (Field: CSC_Mat_Detail_Code;             FieldName : 'CSC_Mat_Detail_Code';           Title: 4;  Pos:  4;  Width: 240; Visible: true; Order: 4; Index:4;   NumColSorted:3),    // RE - PROCESS
    (Field: CSC_Mat_Quantity;                FieldName : 'CSC_Mat_Quantity';              Title: 5;  Pos:  5;  Width: 150; Visible: true; Order: 5; Index:5;   NumColSorted:3),    // RE - PROCESS
    (Field: CSC_Mat_NET_GROUP_CODE;          FieldName : 'CSC_Mat_Net_Group_Code';        Title: 6;  Pos:  6;  Width: 150; Visible: true; Order: 6; Index:6;   NumColSorted:3),    // RE - PROCESS
    (Field: CSC_Mat_Resource_code;           FieldName : 'CSC_Mat_Resource_code';         Title: 7;  Pos:  7;  Width: 150; Visible: true; Order: 7; Index:7;   NumColSorted:3),    // RE - PROCESS
    (Field: CSC_Mat_Execution_Time;          FieldName : 'CSC_Mat_Execution_Time';        Title: 8;  Pos:  8;  Width: 150; Visible: true; Order: 8; Index:8;   NumColSorted:3),    // RE - PROCESS
    (Field: CSC_Mat_Schedule_Start;          FieldName : 'CSC_Mat_Schedule_Start';        Title: 9;  Pos:  9;  Width: 150; Visible: true; Order: 9; Index:9;   NumColSorted:3),    // RE - PROCESS
    (Field: CSC_Mat_Schedule_End;            FieldName : 'CSC_Mat_Schedule_End';          Title: 10; Pos:  10; Width: 150; Visible: true; Order: 10; Index:10; NumColSorted:3),    // RE - PROCESS
    (Field: CSC_Warp_level;                  FieldName : 'CSC_Warp_level';                Title: 11; Pos:  11; Width: 80;  Visible: true; Order: 11; Index:11; NumColSorted:3),    // Warp level
    (Field: CSC_property1;                   FieldName : 'CSC_property1';                 Title: 12; pos:  12; Width: 80; Visible: false; Order: 12; Index:12; NumColSorted:3), // Property1
    (Field: CSC_property2;                   FieldName : 'CSC_property2';                 Title: 13; Pos:  13; Width: 80; Visible: false; Order: 13; Index:13; NumColSorted:3), // Property2
    (Field: CSC_property3;                   FieldName : 'CSC_property3';                 Title: 14; Pos:  14; Width: 80; Visible: false; Order: 14; Index:14; NumColSorted:3), // Property3
    (Field: CSC_property4;                   FieldName : 'CSC_property4';                 Title: 15; Pos:  15; Width: 80; Visible: false; Order: 15; Index:15; NumColSorted:3), // Property4
    (Field: CSC_property5;                   FieldName : 'CSC_property5';                 Title: 16; Pos:  16; Width: 80; Visible: false; Order: 16; Index:16; NumColSorted:3), // Property5
    (Field: CSC_property6;                   FieldName : 'CSC_property6';                 Title: 17; Pos:  17; Width: 80; Visible: false; Order: 17; Index:17; NumColSorted:3), // Property6
    (Field: CSC_property7;                   FieldName : 'CSC_property7';                 Title: 18; Pos:  18; Width: 80; Visible: false; Order: 18; Index:18; NumColSorted:3), // Property7
    (Field: CSC_property8;                   FieldName : 'CSC_property8';                 Title: 19; Pos:  19; Width: 80; Visible: false; Order: 19; Index:19; NumColSorted:3), // Property8
    (Field: CSC_property9;                   FieldName : 'CSC_property9';                 Title: 20; Pos:  20; Width: 80; Visible: false; Order: 20; Index:20; NumColSorted:3), // Property9
    (Field: CSC_property10;                  FieldName : 'CSC_property10';                Title: 21; Pos:  21; Width: 80; Visible: false; Order: 21; Index:21; NumColSorted:3), // Property10
    (Field: CSC_property11;                  FieldName : 'CSC_property11';                Title: 22; Pos:  22; Width: 80; Visible: false; Order: 22; Index:22; NumColSorted:3), // Property11
    (Field: CSC_property12;                  FieldName : 'CSC_property12';                Title: 23; Pos:  23; Width: 80; Visible: false; Order: 23; Index:23; NumColSorted:3), // Property12
    (Field: CSC_property13;                  FieldName : 'CSC_property13';                Title: 24; Pos:  24; Width: 80; Visible: false; Order: 24; Index:24; NumColSorted:3), // Property13
    (Field: CSC_property14;                  FieldName : 'CSC_property14';                Title: 25; Pos:  25; Width: 80; Visible: false; Order: 25; Index:25; NumColSorted:3), // Property14
    (Field: CSC_property15;                  FieldName : 'CSC_property15';                Title: 26; Pos:  26; Width: 80; Visible: false; Order: 26; Index:26; NumColSorted:3), // Property15
    (Field: CSC_property16;                  FieldName : 'CSC_property16';                Title: 27; Pos:  27; Width: 80; Visible: false; Order: 27; Index:27; NumColSorted:3), // Property16
    (Field: CSC_property17;                  FieldName : 'CSC_property17';                Title: 28; Pos:  28; Width: 80; Visible: false; Order: 28; Index:28; NumColSorted:3), // Property17
    (Field: CSC_property18;                  FieldName : 'CSC_property18';                Title: 29; Pos:  29; Width: 80; Visible: false; Order: 29; Index:29; NumColSorted:3), // Property18
    (Field: CSC_property19;                  FieldName : 'CSC_property19';                Title: 30; Pos:  30; Width: 80; Visible: false; Order: 30; Index:30; NumColSorted:3), // Property19
    (Field: CSC_property20;                  FieldName : 'CSC_property20';                Title: 32; Pos:  31; Width: 80; Visible: false; Order: 31; Index:31; NumColSorted:3), // Property20
    (Field: CSC_property21;                  FieldName : 'CSC_property21';                Title: 32; Pos:  32; Width: 80; Visible: false; Order: 32; Index:32; NumColSorted:3), // Property21
    (Field: CSC_property22;                  FieldName : 'CSC_property22';                Title: 33; Pos:  33; Width: 80; Visible: false; Order: 33; Index:33; NumColSorted:3), // Property22
    (Field: CSC_property23;                  FieldName : 'CSC_property23';                Title: 34; Pos:  34; Width: 80; Visible: false; Order: 34; Index:34; NumColSorted:3), // Property23
    (Field: CSC_property24;                  FieldName : 'CSC_property24';                Title: 35; Pos:  35; Width: 80; Visible: false; Order: 35; Index:35; NumColSorted:3), // Property24
    (Field: CSC_property25;                  FieldName : 'CSC_property25';                Title: 36; Pos:  36; Width: 80; Visible: false; Order: 36; Index:36; NumColSorted:3), // Property25
    (Field: CSC_property26;                  FieldName : 'CSC_property26';                Title: 37; Pos:  37; Width: 80; Visible: false; Order: 37; Index:37; NumColSorted:3), // Property26
    (Field: CSC_property27;                  FieldName : 'CSC_property27';                Title: 38; Pos:  38; Width: 80; Visible: false; Order: 38; Index:38; NumColSorted:3), // Property27
    (Field: CSC_property28;                  FieldName : 'CSC_property28';                Title: 39; Pos:  39; Width: 80; Visible: false; Order: 39; Index:39; NumColSorted:3), // Property28
    (Field: CSC_property29;                  FieldName : 'CSC_property29';                Title: 40; Pos:  40; Width: 80; Visible: false; Order: 40; Index:40; NumColSorted:3), // Property29
    (Field: CSC_property30;                  FieldName : 'CSC_property30';                Title: 41; Pos:  41; Width: 80; Visible: false; Order: 41; Index:41; NumColSorted:3),  // Property30
    (Field: CSC_property31;                  FieldName : 'CSC_property31';                Title: 42; pos:  42; Width: 80; Visible: false; Order: 42; Index:42; NumColSorted:3), // Property31
    (Field: CSC_property32;                  FieldName : 'CSC_property32';                Title: 43; Pos:  43; Width: 80; Visible: false; Order: 43; Index:43; NumColSorted:3), // Property32
    (Field: CSC_property33;                  FieldName : 'CSC_property33';                Title: 44; Pos:  44; Width: 80; Visible: false; Order: 44; Index:44; NumColSorted:3), // Property34
    (Field: CSC_property34;                  FieldName : 'CSC_property34';                Title: 45; Pos:  45; Width: 80; Visible: false; Order: 45; Index:45; NumColSorted:3), // Property34
    (Field: CSC_property35;                  FieldName : 'CSC_property35';                Title: 46; Pos:  46; Width: 80; Visible: false; Order: 46; Index:46; NumColSorted:3), // Property35
    (Field: CSC_property36;                  FieldName : 'CSC_property36';                Title: 47; Pos:  47; Width: 80; Visible: false; Order: 47; Index:47; NumColSorted:3), // Property36
    (Field: CSC_property37;                  FieldName : 'CSC_property37';                Title: 48; Pos:  48; Width: 80; Visible: false; Order: 48; Index:48; NumColSorted:3), // Property37
    (Field: CSC_property38;                  FieldName : 'CSC_property38';                Title: 49; Pos:  49; Width: 80; Visible: false; Order: 49; Index:49; NumColSorted:3), // Property38
    (Field: CSC_property39;                  FieldName : 'CSC_property39';                Title: 50; Pos:  50; Width: 80; Visible: false; Order: 50; Index:50; NumColSorted:3), // Property39
    (Field: CSC_property40;                  FieldName : 'CSC_property40';                Title: 51; Pos:  51; Width: 80; Visible: false; Order: 51; Index:51; NumColSorted:3), // Property40
    (Field: CSC_property41;                  FieldName : 'CSC_property41';                Title: 52; Pos:  52; Width: 80; Visible: false; Order: 52; Index:52; NumColSorted:3), // Property41
    (Field: CSC_property42;                  FieldName : 'CSC_property42';                Title: 53; Pos:  53; Width: 80; Visible: false; Order: 53; Index:53; NumColSorted:3), // Property42
    (Field: CSC_property43;                  FieldName : 'CSC_property43';                Title: 54; Pos:  54; Width: 80; Visible: false; Order: 54; Index:54; NumColSorted:3), // Property43
    (Field: CSC_property44;                  FieldName : 'CSC_property44';                Title: 55; Pos:  55; Width: 80; Visible: false; Order: 55; Index:55; NumColSorted:3), // Property44
    (Field: CSC_property45;                  FieldName : 'CSC_property45';                Title: 56; Pos:  56; Width: 80; Visible: false; Order: 56; Index:56; NumColSorted:3), // Property45
    (Field: CSC_property46;                  FieldName : 'CSC_property46';                Title: 57; Pos:  57; Width: 80; Visible: false; Order: 57; Index:57; NumColSorted:3), // Property46
    (Field: CSC_property47;                  FieldName : 'CSC_property47';                Title: 58; Pos:  58; Width: 80; Visible: false; Order: 58; Index:58; NumColSorted:3), // Property47
    (Field: CSC_property48;                  FieldName : 'CSC_property48';                Title: 59; Pos:  59; Width: 80; Visible: false; Order: 59; Index:59; NumColSorted:3), // Property48
    (Field: CSC_property49;                  FieldName : 'CSC_property49';                Title: 60; Pos:  60; Width: 80; Visible: false; Order: 60; Index:60; NumColSorted:3), // Property49
    (Field: CSC_property50;                  FieldName : 'CSC_property50';                Title: 61; Pos:  61; Width: 80; Visible: false; Order: 61; Index:61; NumColSorted:3), // Property50
    (Field: CSC_property51;                  FieldName : 'CSC_property51';                Title: 62; Pos:  62; Width: 80; Visible: false; Order: 62; Index:62; NumColSorted:3), // Property51
    (Field: CSC_property52;                  FieldName : 'CSC_property52';                Title: 63; Pos:  63; Width: 80; Visible: false; Order: 63; Index:63; NumColSorted:3), // Property52
    (Field: CSC_property53;                  FieldName : 'CSC_property53';                Title: 64; Pos:  64; Width: 80; Visible: false; Order: 64; Index:64; NumColSorted:3), // Property53
    (Field: CSC_property54;                  FieldName : 'CSC_property54';                Title: 65; Pos:  65; Width: 80; Visible: false; Order: 65; Index:65; NumColSorted:3), // Property54
    (Field: CSC_property55;                  FieldName : 'CSC_property55';                Title: 66; Pos:  66; Width: 80; Visible: false; Order: 66; Index:66; NumColSorted:3), // Property55
    (Field: CSC_property56;                  FieldName : 'CSC_property56';                Title: 67; Pos:  67; Width: 80; Visible: false; Order: 67; Index:67; NumColSorted:3), // Property56
    (Field: CSC_property57;                  FieldName : 'CSC_property57';                Title: 68; Pos:  68; Width: 80; Visible: false; Order: 68; Index:68; NumColSorted:3), // Property57
    (Field: CSC_property58;                  FieldName : 'CSC_property58';                Title: 69; Pos:  69; Width: 89; Visible: false; Order: 69; Index:69; NumColSorted:3), // Property58
    (Field: CSC_property59;                  FieldName : 'CSC_property59';                Title: 70; Pos:  70; Width: 80; Visible: false; Order: 70; Index:70; NumColSorted:3), // Property59
    (Field: CSC_property60;                  FieldName : 'CSC_property60';                Title: 71; Pos:  71; Width: 80; Visible: false; Order: 71; Index:71; NumColSorted:3)  // Property60

  );


implementation

uses
  UMCompat,
  UMGlobal,
  UMcommon,
  UMTblDesc,
  System.Classes,
  gnugettext;

//----------------------------------------------------------------------------//

function GiveTempTitle(I : Integer ; var IsExistProp : boolean ; PropPosition : Integer) : string;
begin
  IsExistProp := false;
  Result := '';

  if (i < 0) or (i > High(TitleMatTemp)) then
    exit;


  if i <= PropPosition - 1  then
    Result := _(TitleMatTemp[I])
  else if Assigned(DBAppGlobals.ShowBinPropArry[I-PropPosition]) then
  begin
    Result := GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[i-PropPosition]);
    IsExistProp := true;
  end
  else
    Result := _(TitleMatTemp[I]);
end;

//----------------------------------------------------------------------------//

function CheckIfBinColIdIsProp(ColId : CBinColId) : boolean;
begin
  result := false;
  case ColId of
    CSC_property1,
    CSC_property2,
    CSC_property3,
    CSC_property4,
    CSC_property5,
    CSC_property6,
    CSC_property7,
    CSC_property8,
    CSC_property9,
    CSC_property10,
    CSC_property11,
    CSC_property12,
    CSC_property13,
    CSC_property14,
    CSC_property15,
    CSC_property16,
    CSC_property17,
    CSC_property18,
    CSC_property19,
    CSC_property20,
    CSC_property21,
    CSC_property22,
    CSC_property23,
    CSC_property24,
    CSC_property25,
    CSC_property26,
    CSC_property27,
    CSC_property28,
    CSC_property29,
    CSC_property30,
    CSC_property31,
    CSC_property32,
    CSC_property33,
    CSC_property34,
    CSC_property35,
    CSC_property36,
    CSC_property37,
    CSC_property38,
    CSC_property39,
    CSC_property40,
    CSC_property41,
    CSC_property42,
    CSC_property43,
    CSC_property44,
    CSC_property45,
    CSC_property46,
    CSC_property47,
    CSC_property48,
    CSC_property49,
    CSC_property50,
    CSC_property51,
    CSC_property52,
    CSC_property53,
    CSC_property54,
    CSC_property55,
    CSC_property56,
    CSC_property57,
    CSC_property58,
    CSC_property59,
    CSC_property60 : result := true;
  end;

end;

//----------------------------------------------------------------------------//

procedure OrganizeBinMatDefaultTabs;
begin
  OrganizeBinMatDefaultTabColumnSetForNewPropSet;
end;

//----------------------------------------------------------------------------//

procedure OrganizeBinMatDefaultTabColumnSetForNewPropSet;
var
  I,J,K,PropPosition, Index : Integer;
  Low, Last, current, HighBinProp : Integer;
  Found : boolean;
  Temparray: array [0..high(DBAppGlobals.ShowBinPropArry)] of TBinColCurrent;
  PropListString : TStringList;
begin
  PropListString := TStringList.create;
  Current := 0;
  Index := 0;
  PropPosition := GetNumberFieldsMat;
  Last := -1;

  // Find how many propertyes defined for the planner and keep each defined property in temporary //
  //**********************************************************************************************//
  K := 0;
  for I := 0 to high(DBAppGlobals.ShowBinPropArry) do
  begin
    //if (DBAppGlobals.ShowBinPropArry[I] = nil) then break;

    if I = 0 then
    begin
      if (DBAppGlobals.ShowBinPropArry[I] = nil) then
      begin
        for J := PropPosition to High(BinMatDefaultTabColumnSet) do
        begin
          BinMatDefaultTabColumnSet[J].PropCode := '';
        end;
        break;
      end
      else
        PropListString.Add(GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]));
    end
    else if (DBAppGlobals.ShowBinPropArry[I] = nil) then
    begin
      for J := PropPosition to High(BinMatDefaultTabColumnSet) do
      begin
        if PropListString.IndexOf(BinMatDefaultTabColumnSet[J].PropCode) = -1 then
           BinMatDefaultTabColumnSet[J].PropCode := '';
      end;
      break;
    end;
    //////////////////

    Index := Index + 1;
    for J := PropPosition to High(BinMatDefaultTabColumnSet) do
    begin
      if BinMatDefaultTabColumnSet[J].PropCode <>
          GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]) then continue;
      Temparray[K].Title    := BinMatDefaultTabColumnSet[J].Title;
      Temparray[K].Pos      := BinMatDefaultTabColumnSet[J].Pos;
      Temparray[K].Width    := BinMatDefaultTabColumnSet[J].Width;
      Temparray[K].Visible  := BinMatDefaultTabColumnSet[J].Visible;
      Temparray[K].Order    := BinMatDefaultTabColumnSet[J].Order;
      Temparray[K].PropCode := BinMatDefaultTabColumnSet[J].PropCode;
      K := K + 1;
      break;
    end;
  end;

  // Loop on all defined properties, and, enter them to bin. If defined before, restore values //
  //*******************************************************************************************//
  PropPosition := GetNumberFieldsMat;
  for I := 0 to high(DBAppGlobals.ShowBinPropArry) do
  begin
    if (DBAppGlobals.ShowBinPropArry[I] = nil) then break;

    K := I + PropPosition;
    Found := False;

    // Search if the property was kept before //
    for J := 0 to high(DBAppGlobals.ShowBinPropArry) do
    begin
      if Temparray[J].PropCode <> GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]) then continue;
      Found := True;
      break;
    end;

    BinMatDefaultTabColumnSet[K].PropCode := GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]);

    if found then
    begin
      BinMatDefaultTabColumnSet[K].Title    := Temparray[J].Title;
      BinMatDefaultTabColumnSet[K].Pos      := Temparray[J].Pos;
      BinMatDefaultTabColumnSet[K].Width    := Temparray[J].Width;
      BinMatDefaultTabColumnSet[K].Visible  := Temparray[J].Visible;
      BinMatDefaultTabColumnSet[K].Order    := Temparray[J].Order;
    end
    else
    begin
      BinMatDefaultTabColumnSet[K].Title    := '';
      BinMatDefaultTabColumnSet[K].Pos      := 998;
      BinMatDefaultTabColumnSet[K].Width    := 80;
      BinMatDefaultTabColumnSet[K].Visible  := true;
      BinMatDefaultTabColumnSet[K].Order    := 998;
    end;
  end;

  HighBinProp := Index;
  PropPosition := PropPosition + HighBinProp;

  // Compress the order values from 0 to ...///
  for I := 0 to PropPosition - 1 do
  begin
    Low := 999;
    for J := 0 to PropPosition - 1 do
    begin
      if (BinMatDefaultTabColumnSet[J].order > last) and (BinMatDefaultTabColumnSet[J].order < Low) then
      begin
        Current := J;
        Low := BinMatDefaultTabColumnSet[J].order;
       end;
    end;
    Last := BinMatDefaultTabColumnSet[Current].order;
    if last = 998 then last := 997;
    BinMatDefaultTabColumnSet[Current].order := I;
  end;

  // Complete the order for the remaining no-handled properties //
  for I := PropPosition to High(BinMatDefaultTabColumnSet) do
  begin
    BinMatDefaultTabColumnSet[I].order := I;
  end;

  Last := -1;
  Current := 0;

 // Compress the position values from 0 to ...///
  for I := 0 to PropPosition - 1 do
  begin
    Low := 999;
    for J := 0 to PropPosition - 1 do
    begin
      if (BinMatDefaultTabColumnSet[J].Pos > last) and (BinMatDefaultTabColumnSet[J].Pos < Low) then
      begin
        Current := J;
        Low := BinMatDefaultTabColumnSet[J].Pos;
      end;
    end;
    Last := BinMatDefaultTabColumnSet[Current].Pos;
    if last = 998 then last := 997;
    BinMatDefaultTabColumnSet[Current].Pos := I;
  end;

 // Complete the position for the remaining no-handled properties //
  for I := PropPosition to High(BinMatDefaultTabColumnSet) do
  begin
    BinMatDefaultTabColumnSet[I].Pos := I;
  end;

  // just be sure that all rest of properties are signed as false

  PropPosition := GetNumberFieldsMat;

  for I := PropPosition to high(BinMatDefaultTabColumnSet) do
  begin
    if not Assigned(DBAppGlobals.ShowBinPropArry[I-PropPosition]) then
    begin
      BinMatDefaultTabColumnSet[I].Visible := false;
      BinMatDefaultTabColumnSet[I].Title := TitleMatTemp[I];
    end;
  end;

  PropListString.Free;
end;

//----------------------------------------------------------------------------//

procedure ConfBinLoadDefaultValues(var ColArray : array of TBinColCurrent);
var
  i : integer;
  IsExistProp : boolean;
  PropPosition : Integer;
  TempTitle : string;
begin
  PropPosition := GetNumberFieldsMat;

  // Load default configuration
  for i := low(ColArray) to high(ColArray) do
  begin
    ColArray[i].Field := BinMatColDefault[i].Field;
//    ColArray[i].Title := GiveTempTitle(BinMatColDefault[i].Title, IsExistProp, PropPosition);
    TempTitle := GiveTempTitle(BinMatColDefault[i].Title, IsExistProp, PropPosition);
    if IsExistProp then
      ColArray[i].PropCode := TempTitle
    else
      ColArray[i].Title := TempTitle;
    ColArray[i].Pos     := BinMatColDefault[i].Pos;
    ColArray[i].Width   := BinMatColDefault[i].Width;
  //  if IsExistProp then
  //    ColArray[i].Visible := true
  //  else
      ColArray[i].Visible := BinMatColDefault[i].Visible;
    ColArray[i].Order   := BinMatColDefault[i].Order;
    ColArray[i].NumColSorted := BinMatColDefault[i].NumColSorted;
  end;

end;

//----------------------------------------------------------------------------//

procedure FixOldArrayBinColMat(var BinColArray : array of TBinColCurrent; LastEntry: Integer);
var
  I,J, AttributesAdded, TmpIndex : Integer;
begin
//  if LastEntry > 87 then exit;
  AttributesAdded := High(BinMatColDefault) + 1 - LastEntry;
  if AttributesAdded = 0 then exit;

  for I := High(BinMatColDefault) downto GetNumberFieldsMat  do
  begin
    J := I - AttributesAdded;
    BinColArray[I].Field := BinColArray[J].Field;
    BinColArray[I].Title := BinColArray[J].Title;
    BinColArray[I].Pos := BinColArray[J].Pos;
    BinColArray[I].Width := BinColArray[J].Width;
    BinColArray[I].Visible := BinColArray[J].Visible;
    BinColArray[I].Order := BinColArray[J].Order;
    BinColArray[I].RealPos := BinColArray[J].RealPos;
    BinColArray[I].PropCode := BinColArray[J].PropCode;
    BinColArray[I].Index := BinColArray[J].Index;
  end;

  TmpIndex := High(BinMatColDefault) + 1 - AttributesAdded;
  for I := (GetNumberFieldsMat - AttributesAdded) to GetNumberFieldsMat - 1  do
  begin
    BinColArray[I].Title := TitleMatTemp[I];
    BinColArray[I].Pos := TmpIndex;
    BinColArray[I].Order := TmpIndex;
    BinColArray[I].Width := 80;
    BinColArray[I].Visible := false;
    BinColArray[I].PropCode := '';
    BinColArray[I].RealPos := 0;
    BinColArray[I].Index := 0;
    TmpIndex := TmpIndex + 1;
  end;

{  if LastEntry = 86 then
  begin
    BinColArray[56].Title := TitleMatTemp[56];
    BinColArray[56].Pos := 86;
    BinColArray[56].Order := 86;
    BinColArray[56].Width := 80;
    BinColArray[56].Visible := false;
    BinColArray[56].PropCode := '';
    BinColArray[56].RealPos := 0;
    BinColArray[56].Index := 0;
  end;

  if (LastEntry = 86) or (LastEntry = 87) then
  begin

    BinColArray[57].Title := TitleMatTemp[57];
    BinColArray[57].Pos := 87;
    BinColArray[57].Order := 87;
    BinColArray[57].Width := 80;
    BinColArray[57].Visible := false;
    BinColArray[57].PropCode := '';
    BinColArray[57].RealPos := 0;
    BinColArray[57].Index := 0;

  end;    }

  for I := Low(BinMatColDefault) to High(BinMatColDefault) do
    BinColArray[I].Field := BinMatColDefault[I].Field;
end;

//----------------------------------------------------------------------------//

procedure LoadDefaultMatBinTabSet;
var
  I   : Integer;
  qry : TMqmQuery;
  tbInfo:   ^TTblInfo;
begin
  tbInfo := @tblInfo[tbl_cfg_binTab_col];
  qry := CreateQuery(Cfg_DB);
  qry.SQL.Clear;
  qry.SQL.Add('Select * from ' + tbInfo.GetTableName + ' Where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + ' = ''' +  IniAppGlobals.WkstCode + '''');
  qry.SQL.Add(' And ' + CreateFld(tbInfo.pfx, fli_TabsCode) + ' = ''' + '-5''');
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.SQL.Add(' Order by ' + CreateFld(tbInfo.pfx, fli_BinColField));
  qry.SQL.Add(' , ' + CreateFld(tbInfo.pfx, fli_BinColField));
  qry.Open;
  qry.First;

  if qry.Eof then
    ConfBinLoadDefaultValues(BinMatDefaultTabColumnSet)
  else
  begin
    BinDefaultFromDB_Mat := true;
    I := 0;
    while (not qry.EOF) do
    begin
    //  try
      BinMatDefaultTabColumnSet[I].Field := BinMatColDefault[qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColField)).AsInteger].Field;
      BinMatDefaultTabColumnSet[I].Title   := qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColTitle)).AsString;
      BinMatDefaultTabColumnSet[I].Pos     := qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColPos)).AsInteger;
      BinMatDefaultTabColumnSet[I].Width   := qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColWidth)).AsInteger;
      if qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColVisibl)).AsInteger = 1 then
        BinMatDefaultTabColumnSet[I].Visible := true
      else
        BinMatDefaultTabColumnSet[I].Visible := false;
      BinMatDefaultTabColumnSet[I].PropCode  := qry.FieldByName(CreateFld(tbInfo.pfx, fli_FiltPropCode)).AsString;
      BinMatDefaultTabColumnSet[I].Order   := qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColOrder)).AsInteger;
      BinMatDefaultTabColumnSet[I].NumColSorted   := qry.FieldByName(CreateFld(tbInfo.pfx, fli_BinColNumColSorted)).AsInteger;
      Inc(I);
      qry.Next;
    //  except
    //     BinMatDefaultTabColumnSet[I].Visible := false;
    //  end;
    end;

    FixOldArrayBinColMat(BinMatDefaultTabColumnSet,  I);

  end;
  qry.Close;
  qry.Free;
end;

//----------------------------------------------------------------------------//

procedure LoadDefaultMatBinTabsSet;
begin
  LoadDefaultMatBinTabSet;
 // LoadDefaultMatCompBinTabSet;
end;

//----------------------------------------------------------------------------//

procedure SaveDefaultTabBinMatSet;
var
  qry: TMqmQuery;
  tbInfo: ^TTblInfo;
  I : Integer;
begin
  if CheckErrorInArrayWidth then
     Exit;
  BinDefaultFromDB := true;
  tbInfo := @tblInfo[tbl_cfg_binTab_col];

  qry := CreateQuery(Cfg_DB);
  qry.Transaction := CreateTransaction(Cfg_DB);
  qry.Transaction.StartTransaction;

//  try
  qry.SQL.Clear;
  qry.SQL.Add('delete from ' + tbInfo.GetTableName + ' Where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + ' = ''' +  IniAppGlobals.WkstCode + '''');
  qry.SQL.Add(' And ' + CreateFld(tbInfo.pfx, fli_TabsCode) + ' = ''' + '-5''');
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.ExecSQL;
  qry.Close;

  qry.SQL.Clear;
  qry.SQL.Add('insert into ' + tbInfo.GetTableName   + '(');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_Identifier)  + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_wkstCode)    + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_TabsCode)    + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColField) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColTitle) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColPos)   + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColWidth) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColVisibl) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_FiltPropCode) + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColOrder)  + ',');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_BinColNumColSorted) + ')');
  qry.SQL.Add(' values (');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Identifier) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wkstCode) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_TabsCode) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColField) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColTitle) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColPos) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColWidth) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColVisibl) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_FiltPropCode) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColOrder) + ',');
  qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_BinColNumColSorted));
  qry.SQL.Add(')');

  for I := Low(BinMatDefaultTabColumnSet) to High(BinMatDefaultTabColumnSet) do
  begin
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_Identifier)).AsString      := IniAppGlobals.Identifier;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_wkstCode)).AsString      := IniAppGlobals.WkstCode;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_TabsCode)).AsInteger     := -5;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColField)).AsInteger  := I;

    qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColTitle)).AsString   := BinMatDefaultTabColumnSet[I].Title;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColPos)).AsInteger    := BinMatDefaultTabColumnSet[I].Pos;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColWidth)).AsInteger  := BinMatDefaultTabColumnSet[I].Width;
    if BinMatDefaultTabColumnSet[I].Visible  then
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColVisibl)).AsInteger := 1
    else
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColVisibl)).AsInteger := 0;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColOrder)).AsInteger  := BinMatDefaultTabColumnSet[I].Order;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_FiltPropCode)).AsString  := BinMatDefaultTabColumnSet[I].PropCode;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_BinColNumColSorted)).AsInteger  := BinMatDefaultTabColumnSet[I].NumColSorted;

    qry.ExecSQL;
  end;
{  except
    qry.Close;
    qry.Free;
    Exit;
  end;   }
  qry.Transaction.Commit;
  qry.Close;
  qry.Free;

end;

//----------------------------------------------------------------------------//

function CheckErrorInArrayWidth : boolean;
var
  I : Integer;
begin
  Result := false;
  for I := Low(BinMatDefaultTabColumnSet) to High(BinMatDefaultTabColumnSet) do
  begin
    if (BinMatDefaultTabColumnSet[I].Width = 0) then
    begin
      Result := true;
      Exit
    end;
  end;
end;

//----------------------------------------------------------------------------//

function GetNumberFieldsMat : integer;
begin
  Result := 0;
  while BinMatColDefault[Result].Field <> CSC_property1 do
    Result := Result + 1;
end;

//----------------------------------------------------------------------------//

initialization
  BinDefaultFromDB_Mat := false;

end.
