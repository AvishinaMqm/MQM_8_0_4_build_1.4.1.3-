unit CustCompFunc;

interface

uses
  SysUtils,
  UMCompat,
  UMCompatRules,
  System.Classes,
  UMCompatSrv;

  function CustomOOCompat1(PropId: TPropID; JobProp, PrevJobProp: TProperties; setupRec: PTSetupRec; DepValue : Variant): boolean; export;
  function CustomOOCompat2(PropId: TPropID; JobProp, PrevJobProp: TProperties; setupRec: PTSetupRec; DepValue : Variant): boolean; export;

implementation

function CULP_CustomOOCompat2(PropId: TPropID; JobProp, PrevJobProp: TProperties; DepValue : Variant): boolean;
var
  PropVal, PrevPropVal: variant;
  JobPropStrList , PrevJobPropStrList : TStringList;
  PropCountVal, PrevPropCountVal, I : integer;
  setPropVal, SetPrevPropVal, Str, PairVal, Code : string;
  Idx1, ercentOk, FoundCount, PercentOk : Integer;
begin
  Result := true;

  if not JobProp.GetValforProp(PropId, PropVal) then exit;
  if not PrevJobProp.GetValforProp(PropId, PrevPropVal) then exit;

  Code := GetPropCodeFromID(PropId);

  if PropVal <> '' then
  begin

    JobPropStrList := TStringList.create;
    PrevJobPropStrList := TStringList.create;

    PropCountVal := Length(PropVal);
    PrevPropCountVal := Length(PrevPropVal);

    setPropVal     := Trim(PropVal);
    SetPrevPropVal := Trim(PrevPropVal);

    I := 0;
    while True do
    begin
      Str := '';
      I := I + 1;
      if I > length(setPropVal) then break;
      Str := char(setPropVal[I]);
      I := I + 1;
      if I > length(setPropVal) then break;
      Str := Str + char(setPropVal[I]);
      JobPropStrList.Add(trim(str));
    end;

    I := 0;
    while True do
    begin
      Str := '';
      I := I + 1;
      if I > length(SetPrevPropVal) then break;
      Str := char(SetPrevPropVal[I]);
      I := I + 1;
      if I > length(SetPrevPropVal) then break;
      Str := Str + char(SetPrevPropVal[I]);
      PrevJobPropStrList.Add(trim(str));
    end;

    FoundCount := 0;
    for Idx1 := 0 to JobPropStrList.Count - 1 do
    begin
      PairVal := JobPropStrList.Strings[Idx1];
      if PrevJobPropStrList.IndexOf(PairVal) = -1 then continue;
      inc(FoundCount);
    end;

    PercentOk := Trunc(FoundCount*100/JobPropStrList.Count);

    if PercentOk > DepValue then Result := false;

    JobPropStrList.Free;
    PrevJobPropStrList.Free;

  end;

end;


function Isko_CustomOOCompat(PropId: TPropID; JobProp, PrevJobProp: TProperties; var setupRec: PTSetupRec): boolean;
var
  PropVal, PrevPropVal: variant;
  Code : string;
  YarnCountCurrent , YarnCountPrevious : Integer;
  Add : double;
  AddInt : Integer;
begin
  Result := true;

  if not JobProp.GetValforProp(PropId, PropVal) then exit;
  if not PrevJobProp.GetValforProp(PropId, PrevPropVal) then exit;

  Code := GetPropCodeFromID(PropId);
  if Code <> 'IPLUC' then exit;

  setupRec.supTime := 0;
  setupRec.supOverlap := 0;
  setupRec.supAdjType := CSA_copy;

  if PropVal <> '' then
  begin
    if PropVal = PrevPropVal then exit;

    add := 0;

    try
      YarnCountCurrent := StrToInt(copy(PropVal,16,5));
      YarnCountPrevious := StrToInt(copy(PrevPropVal,16,5));

      if (YarnCountCurrent - YarnCountPrevious > 0) then
        Add := add + (YarnCountCurrent - YarnCountPrevious) * 0.5;

      if (copy(PropVal,1,14) <> copy(PrevPropVal,1,14)) then
        Add := add + (YarnCountCurrent * 0.153/2);
    except
      Result := false;
      exit;
    end;

    if add > 0 then
    begin
      AddInt := round(Add);
      setupRec.supTime := AddInt;
      setupRec.supOverlap := AddInt;
      setupRec.supAdjType := CSA_AddTot;
    end;
  end;
end;

//----------------------------------------------------------------------------//

function CULP_CustomOOCompat(PropId: TPropID; JobProp, PrevJobProp: TProperties; DepValue : Variant): boolean;
var
  PropVal, PrevPropVal: variant;
  JobPropStrList , PrevJobPropStrList : TStringList;
  Code : string;
  YarnCountCurrent , YarnCountPrevious : Integer;
  Add : double;
  AddInt : Integer;
  PropCountVal, PrevPropCountVal, I, SmallestString, BiggestString, NumberOfDifferences : integer;
  setPropVal, SetPrevPropVal, Str : string;
  Idx, PercentOk : integer;
begin
  Result := true;

  if not JobProp.GetValforProp(PropId, PropVal) then exit;
  if not PrevJobProp.GetValforProp(PropId, PrevPropVal) then exit;

  if length(PropVal) < 6 then exit;
  if length(PrevPropVal) < 6 then exit;

  Code := GetPropCodeFromID(PropId);

  if PropVal <> '' then
  begin
    if (PropVal = PrevPropVal) and (DepValue >= 100) then exit;

    JobPropStrList := TStringList.create;
    PrevJobPropStrList := TStringList.create;

    PropCountVal := StrToInt(Trim(copy(PropVal, 1, 3)));
    PrevPropCountVal := StrToInt(Trim(copy(PrevPropVal, 1, 3)));

    setPropVal     := Trim(copy(PropVal, 5, length(PropVal)));
    SetPrevPropVal := Trim(copy(PrevPropVal, 5, length(PrevPropVal)));

    for Idx := 0 to PropCountVal - 1 do
    begin
      I := 0;
      while True do
      begin
        Str := '';
        I := I + 1;
        if I > length(setPropVal) then break;
        Str := char(setPropVal[I]);
        I := I + 1;
        if I > length(setPropVal) then break;
        Str := Str + char(setPropVal[I]);
        JobPropStrList.Add(trim(str));
      end;
    end;

    for Idx := 0 to PrevPropCountVal - 1 do
    begin
      I := 0;
      while True do
      begin
        Str := '';
        I := I + 1;
        if I > length(SetPrevPropVal) then break;
        Str := char(SetPrevPropVal[I]);
        I := I + 1;
        if I > length(SetPrevPropVal) then break;
        Str := Str + char(SetPrevPropVal[I]);
        PrevJobPropStrList.Add(trim(str));
      end;
    end;

    if PrevJobPropStrList.Count < JobPropStrList.Count then
    begin
      SmallestString := PrevJobPropStrList.Count;
      BiggestString := JobPropStrList.Count;
    end
    else
    begin
      SmallestString := JobPropStrList.Count;
      BiggestString  := PrevJobPropStrList.Count;
    end;

    NumberOfDifferences := BiggestString - SmallestString;
    for Idx := 0 to SmallestString - 1 do
    begin
      if JobPropStrList.Strings[idx] <> PrevJobPropStrList.Strings[idx] then
        inc(NumberOfDifferences);
    end;

    PercentOk := 100 - trunc(NumberOfDifferences/BiggestString*100);

    if PercentOk > DepValue then
      Result := false;

    JobPropStrList.Free;
    PrevJobPropStrList.Free

  end;
end;

//----------------------------------------------------------------------------//

{function CULP_CustomOOCompat2(PropId: TPropID; JobProp, PrevJobProp: TProperties; DepValue : Variant): boolean;
var
  PropVal, PrevPropVal: variant;
  JobPropStrList , PrevJobPropStrList : TStringList;
  Code : string;
  YarnCountCurrent , YarnCountPrevious : Integer;
  Add : double;
  AddInt : Integer;
  PropCountVal, PrevPropCountVal, I, SmallestString, BiggestString, NumberOfDifferences : integer;
  setPropVal, SetPrevPropVal, Str : string;
  Idx, PercentOk : integer;
begin
  Result := true;

  if not JobProp.GetValforProp(PropId, PropVal) then exit;
  if not PrevJobProp.GetValforProp(PropId, PrevPropVal) then exit;

  if (length(PropVal)) < 4 then exit;
  if (length(PropVal)) > 8 then exit;

  if (length(PrevPropVal)) < 4 then exit;
  if (length(PrevPropVal)) > 8 then exit;

  Code := GetPropCodeFromID(PropId);

//  if Code <> 'WP075' then exit;

  if PropVal <> '' then
  begin
    if (PropVal = PrevPropVal) and (DepValue >= 100) then exit;

    JobPropStrList := TStringList.create;
    PrevJobPropStrList := TStringList.create;

    PropCountVal := Length(PropVal);
    PrevPropCountVal := Length(PrevPropVal);

    setPropVal     := Trim(PropVal);
    SetPrevPropVal := Trim(PrevPropVal);

    for Idx := 0 to PropCountVal - 1 do
    begin
      I := 0;
      while True do
      begin
        Str := '';
        I := I + 1;
        if I > length(setPropVal) then break;
        Str := char(setPropVal[I]);
        I := I + 1;
        if I > length(setPropVal) then break;
        Str := Str + char(setPropVal[I]);
        JobPropStrList.Add(trim(str));
      end;
    end;

    for Idx := 0 to PrevPropCountVal - 1 do
    begin
      I := 0;
      while True do
      begin
        Str := '';
        I := I + 1;
        if I > length(SetPrevPropVal) then break;
        Str := char(SetPrevPropVal[I]);
        I := I + 1;
        if I > length(SetPrevPropVal) then break;
        Str := Str + char(SetPrevPropVal[I]);
        PrevJobPropStrList.Add(trim(str));
      end;
    end;

    if PrevJobPropStrList.Count < JobPropStrList.Count then
    begin
      SmallestString := PrevJobPropStrList.Count;
      BiggestString := JobPropStrList.Count;
    end
    else
    begin
      SmallestString := JobPropStrList.Count;
      BiggestString  := PrevJobPropStrList.Count;
    end;

    NumberOfDifferences := BiggestString - SmallestString;
    for Idx := 0 to SmallestString - 1 do
    begin
      if JobPropStrList.Strings[idx] <> PrevJobPropStrList.Strings[idx] then
        inc(NumberOfDifferences);
    end;

    PercentOk := 100 - trunc(NumberOfDifferences/BiggestString*100);

    if PercentOk > DepValue then
      Result := false;

  end;

end;
 }
//----------------------------------------------------------------------------//

function CustomOOCompat1(PropId: TPropID; JobProp, PrevJobProp: TProperties; setupRec: PTSetupRec; DepValue : Variant): boolean; export;
var
  PropVal, PrevPropVal: variant;
begin
  Result := true;

  {$ifdef ISKO}
  Result := Isko_CustomOOCompat(PropId, JobProp, PrevJobProp, setupRec);
  {$endif}

  {$ifdef CULP}
  Result := CULP_CustomOOCompat(PropId, JobProp, PrevJobProp, DepValue);
  {$endif}

end;

function CustomOOCompat2(PropId: TPropID; JobProp, PrevJobProp: TProperties; setupRec: PTSetupRec; DepValue : Variant): boolean; export;
var
  PropVal, PrevPropVal: variant;
begin
  Result := true;

  {$ifdef CULP}
  Result := CULP_CustomOOCompat2(PropId, JobProp, PrevJobProp, DepValue);
  {$endif}

end;

end.
