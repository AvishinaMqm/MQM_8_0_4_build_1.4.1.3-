unit UMConvert;

interface

uses
  UMProductionStruct, Classes;

type
  TProducts = Record
    SubCode01 : string;
    SubCode02 : string;
    SubCode03 : string;
    SubCode04 : string;
    SubCode05 : string;
    SubCode06 : string;
    SubCode07 : string;
    SubCode08 : string;
    SubCode09 : string;
    SubCode10 : string;
    BasePrimaryUnitCode : string;
    Conversionslist : TList;
    BaseSecondaryUnitCode : string;
    SecondaryUnsteadyCVSFactor : double;
    ConversionFactorType : string;
    Multiplier           : double;
  end;
  PTProducts = ^TProducts;

function ConvertUM(MQMProductionColumnValues : PMQMProductionColumnValues; FromUoM : string; ToUoM : string; QuantityInput : double; ItemTypeCode : string; SubCode01 : string; SubCode02 : string; SubCode03 : string;
                    SubCode04 : string; SubCode05 : string; SubCode06 : string; SubCode07 : string; SubCode08 : string; SubCode09 : string; SubCode10 : string) : double;
function ConvertBySameType(FromUoM : string; ToUoM : string; QuantityInput : double; var QuantityOutput : double) : boolean;
function GetProductConversions(ItemTypeCode : string;
                               SubCode01 : string; SubCode02 : string;SubCode03 : string; SubCode04 : string; SubCode05 : string;
                               SubCode06 : string; SubCode07 : string; SubCode08 : string; SubCode09 : string; SubCode10 : string) : PTProducts;
function ConvertByProduct(FromUoM : string; ToUoM : string; QuantityInput : double; ProductsRec : PTProducts) : double;

implementation

uses DMsrvPc,umGlobal,SysUtils,UOpThread, UMProductionStructService;

type
  TUMMeasure = Record
    Code : string;
    TypeUM : string;
  end;
  PTUMMeasure = ^TUMMeasure;

  TCategoryConversionUM = record
    UnitOfMeasureCode    : string;
    ConversionFactor     : double;
    ConversionFactorType : string;
    Multiplier           : double;
  end;
  PTCategoryConversionUM = ^ TCategoryConversionUM;

  TUnitConversion = Record
    TypeUm : string;
    BaseUMCode : string;
    StdUnitCategoryConversionList : TList;
  end;
  PTUnitConversion = ^TUnitConversion;

  TItemTypes = Record
    Code : string;
    LastPrimaryNR : Integer;
    Productslist  : TList;
  end;
  PTItemTypes = ^TItemTypes;

var
  m_UnitOfMeasureList : TList;
  m_StdUnitCategoryConversion : TList;
  m_ItemTypeList : TList;

//------------------------------------------------------------------------------------------------//

function SortUnitOfMeasure(Item1, Item2: Pointer) : integer;
var
  MQMPR1 : PTUMMeasure;
  MQMPR2 : PTUMMeasure;
begin
  MQMPR1 := PTUMMeasure(Item1);
  MQMPR2 := PTUMMeasure(Item2);
  if MQMPR1.Code < MQMPR2.Code then
    Result := -1
  else if (MQMPR1.Code = MQMPR2.Code) then
    Result := 0
  else
    Result := 1;
end;

//------------------------------------------------------------------------------------------------//

function LoadIntoUnitOfMeasure : boolean;
var
  HostQry : TMqmQuery;
  hostSqlStr : string;
  PUMMeasure : PTUMMeasure;
begin
  Result := true;
  HostQry := ThreadCreateQueryHost;
  HostSqlStr := 'Select Code, Type From UnitOfMeasure order by Code ';
  HostQry.SQL.Text := hostSqlStr;
  HostQry.Open;

  if HostQry.Eof then
  begin
    Result := false;
    Exit;
  end;

  while not HostQry.Eof do
  begin
    new(PUMMeasure);
    PUMMeasure.Code   := trim(HostQry.FieldByName('CODE').AsString);
    PUMMeasure.TypeUM := trim(HostQry.FieldByName('TYPE').AsString);
    m_UnitOfMeasureList.add(PUMMeasure);
    HostQry.Next
  end;
  m_UnitOfMeasureList.Sort(SortUnitOfMeasure);

  HostQry.Close;
  HostQry.Free;

end;

//------------------------------------------------------------------------------------------------//

function LoadIntoUnitConversion : boolean;
var
  HostQry : TMqmQuery;
  hostSqlStr : string;
  PCategoryConversionUM : PTCategoryConversionUM;
  PUnitConversion : PTUnitConversion;
  PrevType , PrevBaseUmCode : string;
begin
  HostQry := ThreadCreateQueryHost;
  Result := true;
  HostSqlStr := ' Select Type, BaseUnitOfMeasureCode , UnitOfMeasureCode, ConversionFactor, ' +
                ' ConversionFactorType, Multiplier from StandardUnitCategory ' +
                ' Join StdUnitCategoryConversion on StandardUnitCategoryType = Type order by Type, UnitOfMeasureCode ';
  HostQry.SQL.Text := hostSqlStr;
  HostQry.Open;

  if HostQry.Eof then
  begin
    Result := false;
    Exit
  end;

  PrevType := '';
  PrevBaseUmCode := '';

  while not HostQry.Eof do
  begin
    PrevType       := HostQry.FieldByName('Type').AsString;
    PrevBaseUmCode := HostQry.FieldByName('BaseUnitOfMeasureCode').AsString;
    new(PUnitConversion);
    PUnitConversion.TypeUm       := HostQry.FieldByName('Type').AsString;
    PUnitConversion.BaseUMCode   := HostQry.FieldByName('BaseUnitOfMeasureCode').AsString;
    PUnitConversion.StdUnitCategoryConversionList := TList.Create;

    m_StdUnitCategoryConversion.Add(PUnitConversion);
    while not HostQry.Eof and (PrevType = HostQry.FieldByName('Type').AsString) and
              (PrevBaseUmCode = HostQry.FieldByName('BaseUnitOfMeasureCode').AsString) do
    begin
      new(PCategoryConversionUM);
      PCategoryConversionUM.UnitOfMeasureCode    := HostQry.FieldByName('UnitOfMeasureCode').AsString;
      PCategoryConversionUM.ConversionFactor     := HostQry.FieldByName('ConversionFactor').AsFloat;
      PCategoryConversionUM.ConversionFactorType := HostQry.FieldByName('ConversionFactorType').AsString;
      PCategoryConversionUM.Multiplier           := HostQry.FieldByName('Multiplier').AsFloat;
      PUnitConversion.StdUnitCategoryConversionList.Add(PCategoryConversionUM);
      HostQry.Next;
    end;
  end;

  HostQry.Close;
  HostQry.Free;

end;

//------------------------------------------------------------------------------------------------//

function FindTypeFromUMCode(UmCode : string) : string;
var
  i: integer;
  Multiplier, NumberOfEntries : integer;
begin
  Result := '';
  NumberOfEntries := m_UnitOfMeasureList.Count;
  if NumberOfEntries = 0 then exit;

  Multiplier := 1;
  while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    i := Multiplier - 1;

  while (Multiplier > 0) do
  begin

    if  (i < NumberOfEntries)
    and (PTUMMeasure(m_UnitOfMeasureList[i]).Code = UmCode) then break;

    Multiplier := trunc(Multiplier / 2);

    if (i < NumberOfEntries) and (PTUMMeasure(m_UnitOfMeasureList[i]).Code < UmCode) then
      i := i + Multiplier
    else
      i := i - Multiplier;
  end;

  if Multiplier > 0 then Result := PTUMMeasure(m_UnitOfMeasureList[i]).TypeUM;

end;

//------------------------------------------------------------------------------------------------//

function FindItemTypeCode(Code : string) : PTItemTypes;
var
  i: integer;
  Multiplier, NumberOfEntries : integer;
begin
  Result := nil;
  NumberOfEntries := m_ItemTypeList.Count;
  if NumberOfEntries = 0 then exit;

  Multiplier := 1;
  while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    i := Multiplier - 1;

  while (Multiplier > 0) do
  begin

    if  (i < NumberOfEntries)
    and (PTUMMeasure(m_ItemTypeList[i]).Code = Code) then break;

    Multiplier := trunc(Multiplier / 2);

    if (i < NumberOfEntries) and (PTItemTypes(m_ItemTypeList[i]).Code < Code) then
      i := i + Multiplier
    else
      i := i - Multiplier;
  end;

   if Multiplier > 0 then Result := PTItemTypes(m_ItemTypeList[i]);

end;

//------------------------------------------------------------------------------------------------//

function FindSubCodesInProduct(ItemTypes : PTItemTypes; SubCode01,SubCode02,SubCode03,SubCode04,SubCode05,
                               SubCode06,SubCode07,SubCode08,SubCode09,SubCode10 : string) : PTProducts;
var
  i: integer;
  Multiplier, NumberOfEntries : integer;
begin
  Result := nil;

  NumberOfEntries := ItemTypes.Productslist.Count;

  if NumberOfEntries = 0 then exit;

  Multiplier := 1;
  while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    i := Multiplier - 1;

  while (Multiplier > 0) do
  begin

    if  (i < NumberOfEntries) and
        (PTProducts(ItemTypes.Productslist[i]).SubCode01 = SubCode01) and
        (PTProducts(ItemTypes.Productslist[i]).SubCode02 = SubCode02) and
        (PTProducts(ItemTypes.Productslist[i]).SubCode03 = SubCode03) and
        (PTProducts(ItemTypes.Productslist[i]).SubCode04 = SubCode04) and
        (PTProducts(ItemTypes.Productslist[i]).SubCode05 = SubCode05) and
        (PTProducts(ItemTypes.Productslist[i]).SubCode06 = SubCode06) and
        (PTProducts(ItemTypes.Productslist[i]).SubCode07 = SubCode07) and
        (PTProducts(ItemTypes.Productslist[i]).SubCode08 = SubCode08) and
        (PTProducts(ItemTypes.Productslist[i]).SubCode09 = SubCode09) and
        (PTProducts(ItemTypes.Productslist[i]).SubCode10 = SubCode10) then break;

    Multiplier := trunc(Multiplier / 2);

    if (i >= NumberOfEntries) then
    begin
      i := i - Multiplier;
      continue;
    end;

    if (PTProducts(ItemTypes.Productslist[i]).SubCode01 > SubCode01) then
    begin
      i := i - Multiplier;
      continue;
    end;

    if (PTProducts(ItemTypes.Productslist[i]).SubCode01 < SubCode01) then
    begin
      i := i + Multiplier;
      continue;
    end;

    if (PTProducts(ItemTypes.Productslist[i]).SubCode02 > SubCode02) then
    begin
      i := i - Multiplier;
      continue;
    end;

    if (PTProducts(ItemTypes.Productslist[i]).SubCode02 < SubCode02) then
    begin
      i := i + Multiplier;
      continue;
    end;

    if (PTProducts(ItemTypes.Productslist[i]).SubCode03 > SubCode03) then
    begin
      i := i - Multiplier;
      continue;
    end;

    if (PTProducts(ItemTypes.Productslist[i]).SubCode03 < SubCode03) then
    begin
      i := i + Multiplier;
      continue;
    end;

    if (PTProducts(ItemTypes.Productslist[i]).SubCode04 > SubCode04) then
    begin
      i := i - Multiplier;
      continue;
    end;

    if (PTProducts(ItemTypes.Productslist[i]).SubCode04 < SubCode04) then
    begin
      i := i + Multiplier;
      continue;
    end;

    if (PTProducts(ItemTypes.Productslist[i]).SubCode05 > SubCode05) then
    begin
      i := i - Multiplier;
      continue;
    end;

    if (PTProducts(ItemTypes.Productslist[i]).SubCode05 < SubCode05) then
    begin
      i := i + Multiplier;
      continue;
    end;

    if (PTProducts(ItemTypes.Productslist[i]).SubCode06 > SubCode06) then
    begin
      i := i - Multiplier;
      continue;
    end;

    if (PTProducts(ItemTypes.Productslist[i]).SubCode06 < SubCode06) then
    begin
      i := i + Multiplier;
      continue;
    end;

    if (PTProducts(ItemTypes.Productslist[i]).SubCode07 > SubCode07) then
    begin
      i := i - Multiplier;
      continue;
    end;

    if (PTProducts(ItemTypes.Productslist[i]).SubCode07 < SubCode07) then
    begin
      i := i + Multiplier;
      continue;
    end;

    if (PTProducts(ItemTypes.Productslist[i]).SubCode08 > SubCode08) then
    begin
      i := i - Multiplier;
      continue;
    end;

    if (PTProducts(ItemTypes.Productslist[i]).SubCode08 < SubCode08) then
    begin
      i := i + Multiplier;
      continue;
    end;

    if (PTProducts(ItemTypes.Productslist[i]).SubCode09 > SubCode09) then
    begin
      i := i - Multiplier;
      continue;
    end;

    if (PTProducts(ItemTypes.Productslist[i]).SubCode09 < SubCode09) then
    begin
      i := i + Multiplier;
      continue;
    end;

    if (PTProducts(ItemTypes.Productslist[i]).SubCode10 > SubCode10) then
    begin
      i := i - Multiplier;
      continue;
    end;

    if (PTProducts(ItemTypes.Productslist[i]).SubCode10 < SubCode10) then
    begin
      i := i + Multiplier;
      continue;
    end;

  end;

  if Multiplier > 0 then Result := PTProducts(ItemTypes.Productslist[i]);

end;

//------------------------------------------------------------------------------------------------//
function GetProductConversions(ItemTypeCode : string;
                               SubCode01 : string; SubCode02 : string;SubCode03 : string; SubCode04 : string; SubCode05 : string;
                               SubCode06 : string; SubCode07 : string; SubCode08 : string; SubCode09 : string; SubCode10 : string) : PTProducts;
var
  HostQry : TMqmQuery;
  hostSqlStr : string;
  CompanyInUsed, SubCodeStr : string;
  ItemTypesRec : PTItemTypes;
  CategoryConversionUMRec : PTCategoryConversionUM;
  I : Integer;
  PrevSubCode01,PrevSubCode02,PrevSubCode03,PrevSubCode04,PrevSubCode05,PrevSubCode06,
  PrevSubCode07,PrevSubCode08,PrevSubCode09,PrevSubCode10,PrevBasePrimaryUnitCode : string;
  PrevBaseSecondaryUnitCode, PrevSecondaryConversionFactorType : string;
  PrevSecondaryUnsteadyCVSFactor, PrevSecondaryMultiplier : double;
  ConvertByProductText : TStringList;
begin
  Result := nil;
  if not GetCompanyLevelHandlingByEntityName('ITEMTYPE',  CompanyInUsed) then
      CompanyInUsed := IniAppGlobals.CompanyCode;

  ItemTypesRec := FindItemTypeCode(ItemTypeCode);

  if ItemTypesRec = nil then
  begin
    HostQry := ThreadCreateQueryHost;
	  HostSqlStr := ' select lastPrimaryNR from itemtype where ' +
                   'COMPANYCODE = ' + QuotedStr(CompanyInUsed) + ' AND ' +
                   'CODE = ' + QuotedStr(ItemTypeCode);
    HostQry.SQL.Text := hostSqlStr;
    HostQry.Open;

    new(ItemTypesRec);
    ItemTypesRec.Code := ItemTypeCode;
    ItemTypesRec.Productslist := TList.Create;
    if HostQry.Eof then
    begin
      ItemTypesRec.lastPrimaryNR := 0;
      Exit;
    end
    else
    begin
      ItemTypesRec.LastPrimaryNR := HostQry.FieldByName('lastPrimaryNR').AsInteger;
      if m_ItemTypeList.Count = 0 then
         m_ItemTypeList.Add(ItemTypesRec)
      else
      begin
        I := 0;
        while (I < m_ItemTypeList.Count) and (PTItemTypes(m_ItemTypeList[I]).Code < ItemTypeCode) do
          Inc(I);
        m_ItemTypeList.Insert(I, ItemTypesRec);
      end;

      SubCodeStr := '';
      for i := 0 to 8 do
      begin
        if ItemTypesRec.lastPrimaryNR > I then
          SubCodeStr := SubCodeStr + ' and P.SubCode0' + IntToStr(I + 1) + ' = PD.SubCode0' + IntToStr(I + 1)
      //  else
      //    SubCodeStr := SubCodeStr + ' and P.SubCode0' + IntToStr(I + 1) + ' = ' + QuotedStr('');
      end;

      if ItemTypesRec.lastPrimaryNR > 9 then
        SubCodeStr := SubCodeStr + ' and P.SubCode' + IntToStr(10) + ' = PD.SubCode' + IntToStr(10);
//      else
//        SubCodeStr := SubCodeStr + ' and P.SubCode' + IntToStr(10) + ' = ' + QuotedStr('');

      HostQry.SQL.Clear;
      HostSqlStr := ' Select P.SubCode01, P.SubCode02, P.SubCode03, P.SubCode04, P.SubCode05, ' +
                    ' P.SubCode06, P.SubCode07, P.SubCode08, P.SubCode09, P.SubCode10, P.BasePrimaryUnitCode, ' +
                    ////
                    ///
                    ///
                    ///
                     ' P.BaseSecondaryUnitCode, P.SecondaryUnsteadyCVSFactor, P.ConversionFactorType SecondaryConversionFactorType , P.Multiplier SecondaryMultiplier , ' +








		                ' PPUC.UnitOfMeasureCode, PPUC.ConversionFactor, PPUC.ConversionFactorType, PPUC.Multiplier ' +
                    '	From ( ' +
                    ' Select distinct P.CompanyCode, P.ItemTypeCode, P.SubCode01, P.SubCode02, P.SubCode03, P.SubCode04, P.SubCode05, ' +
                    ' P.SubCode06, P.SubCode07, P.SubCode08, P.SubCode09, P.SubCode10, P.BasePrimaryUnitCode, ' +
                    ' P.BaseSecondaryUnitCode, P.SecondaryUnsteadyCVSFactor, P.ConversionFactorType , P.Multiplier ' +
                    ' From (Select CompanyCode, CounterCode, Code ' +
	                  ' From SchedulesDownloadDemands' +
                    ' Where ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' AND ' +
                    ' COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ')' +
                    ' SDD Join ProductionDemand PD ' +
                    ' on PD.CompanyCode = SDD.CompanyCode and PD.CounterCode = SDD.CounterCode and ' +
                    ' PD.Code = SDD.Code and PD.ItemTypeAFICode = ' + QuotedStr(ItemTypeCode) +
                    ' Join Product P ' +
                    ' on P.CompanyCode = ' + QuotedStr(CompanyInUsed) + ' and P.ItemTypeCode = PD.ItemTypeAFICode ' + SubCodeStr +
                    ' ) P ' +
                    ' Left Join ProductPrimaryUoMConversion PPUC ' +
                    ' On PPUC.ProductCompanyCode = P.CompanyCode and ' +
                    ' PPUC.ProductItemTypeCode = P.ItemTypeCode and ' +
                    ' PPUC.ProductSubCode01 = P.SubCode01 and ' +
                    ' PPUC.ProductSubCode02 = P.SubCode02 and ' +
                    ' PPUC.ProductSubCode03 = P.SubCode03 and ' +
                    ' PPUC.ProductSubCode04 = P.SubCode04 and ' +
                    ' PPUC.ProductSubCode05 = P.SubCode05 and ' +
                    ' PPUC.ProductSubCode06 = P.SubCode06 and ' +
                    ' PPUC.ProductSubCode07 = P.SubCode07 and ' +
                    ' PPUC.ProductSubCode08 = P.SubCode08 and ' +
                    ' PPUC.ProductSubCode09 = P.SubCode09 and ' +
                    ' PPUC.ProductSubCode10 = P.SubCode10 ' +
                    ' Order By P.SubCode01, P.SubCode02, P.SubCode03, P.SubCode04, P.SubCode05, P.SubCode06, P.SubCode07, ' +
                    ' P.SubCode08, P.SubCode09, P.SubCode10, PPUC.UnitOfMeasureCode ';

      HostQry.SQL.Text := hostSqlStr;
      HostQry.Open;
      begin
        while not HostQry.Eof do
        begin
          PrevSubCode01 := trim(HostQry.FieldByName('SubCode01').AsString);
          PrevSubCode02 := trim(HostQry.FieldByName('SubCode02').AsString);
          PrevSubCode03 := trim(HostQry.FieldByName('SubCode03').AsString);
          PrevSubCode04 := trim(HostQry.FieldByName('SubCode04').AsString);
          PrevSubCode05 := trim(HostQry.FieldByName('SubCode05').AsString);
          PrevSubCode06 := trim(HostQry.FieldByName('SubCode06').AsString);
          PrevSubCode07 := trim(HostQry.FieldByName('SubCode07').AsString);
          PrevSubCode08 := trim(HostQry.FieldByName('SubCode08').AsString);
          PrevSubCode09 := trim(HostQry.FieldByName('SubCode09').AsString);
          PrevSubCode10 := trim(HostQry.FieldByName('SubCode10').AsString);
          PrevBasePrimaryUnitCode := trim(HostQry.FieldByName('BasePrimaryUnitCode').AsString);
          PrevBaseSecondaryUnitCode := trim(HostQry.FieldByName('BaseSecondaryUnitCode').AsString);
          PrevSecondaryUnsteadyCVSFactor    := HostQry.FieldByName('SecondaryUnsteadyCVSFactor').AsFloat;
          PrevSecondaryConversionFactorType := trim(HostQry.FieldByName('SecondaryConversionFactorType').AsString);
          PrevSecondaryMultiplier           := HostQry.FieldByName('SecondaryMultiplier').AsFloat;

          new(Result);
          ItemTypesRec.Productslist.Add(Result);
          Result.SubCode01 := PrevSubCode01;
          Result.SubCode02 := PrevSubCode02;
          Result.SubCode03 := PrevSubCode03;
          Result.SubCode04 := PrevSubCode04;
          Result.SubCode05 := PrevSubCode05;
          Result.SubCode06 := PrevSubCode06;
          Result.SubCode07 := PrevSubCode07;
          Result.SubCode08 := PrevSubCode08;
          Result.SubCode09 := PrevSubCode09;
          Result.SubCode10 := PrevSubCode10;
          Result.BasePrimaryUnitCode := PrevBasePrimaryUnitCode;
          Result.BaseSecondaryUnitCode := PrevBaseSecondaryUnitCode;
          Result.SecondaryUnsteadyCVSFactor := PrevSecondaryUnsteadyCVSFactor;
          Result.ConversionFactorType := PrevSecondaryConversionFactorType;
          Result.Multiplier := PrevSecondaryMultiplier;
          Result.Conversionslist := TList.Create;
          while not HostQry.Eof and
               (PrevSubCode01 = trim(HostQry.FieldByName('SubCode01').AsString)) and
               (PrevSubCode02 = trim(HostQry.FieldByName('SubCode02').AsString)) and
               (PrevSubCode03 = trim(HostQry.FieldByName('SubCode03').AsString)) and
               (PrevSubCode04 = trim(HostQry.FieldByName('SubCode04').AsString)) and
               (PrevSubCode05 = trim(HostQry.FieldByName('SubCode05').AsString)) and
               (PrevSubCode06 = trim(HostQry.FieldByName('SubCode06').AsString)) and
               (PrevSubCode07 = trim(HostQry.FieldByName('SubCode07').AsString)) and
               (PrevSubCode08 = trim(HostQry.FieldByName('SubCode08').AsString)) and
               (PrevSubCode09 = trim(HostQry.FieldByName('SubCode09').AsString)) and
               (PrevSubCode10 = trim(HostQry.FieldByName('SubCode10').AsString)) and
               (PrevBasePrimaryUnitCode = trim(HostQry.FieldByName('BasePrimaryUnitCode').AsString)) do
          begin
            new(CategoryConversionUMRec);
            CategoryConversionUMRec.UnitOfMeasureCode    := trim(HostQry.FieldByName('UnitOfMeasureCode').AsString);
            CategoryConversionUMRec.ConversionFactor     := HostQry.FieldByName('ConversionFactor').AsFloat;
            CategoryConversionUMRec.ConversionFactorType := trim(HostQry.FieldByName('ConversionFactorType').AsString);
            CategoryConversionUMRec.Multiplier           := HostQry.FieldByName('Multiplier').AsFloat;
            Result.Conversionslist.Add(CategoryConversionUMRec);
            HostQry.Next
          end;
        end;
      end;
    end;
    HostQry.Close;
    HostQry.free;
  end;

  if ItemTypesRec.LastPrimaryNR < 1 then exit;

  if ItemTypesRec.LastPrimaryNR < 2 then  SubCode02 := '';
  if ItemTypesRec.LastPrimaryNR < 3 then  SubCode03 := '';
  if ItemTypesRec.LastPrimaryNR < 4 then  SubCode04 := '';
  if ItemTypesRec.LastPrimaryNR < 5 then  SubCode05 := '';
  if ItemTypesRec.LastPrimaryNR < 6 then  SubCode06 := '';
  if ItemTypesRec.LastPrimaryNR < 7 then  SubCode07 := '';
  if ItemTypesRec.LastPrimaryNR < 8 then  SubCode08 := '';
  if ItemTypesRec.LastPrimaryNR < 9 then  SubCode09 := '';
  if ItemTypesRec.LastPrimaryNR < 10 then SubCode10 := '';

  Result := FindSubCodesInProduct(ItemTypesRec,SubCode01,SubCode02,SubCode03,SubCode04,SubCode05,
                                       SubCode06,SubCode07,SubCode08,SubCode09,SubCode10);
  if (Result = nil) then // should be remove ...
  begin
    HostQry := ThreadCreateQueryHost;
    HostQry.SQL.Clear;

    hostSqlStr := ' Select P.SubCode01, P.SubCode02, P.SubCode03, P.SubCode04, P.SubCode05, P.SubCode06, P.SubCode07, ' +
	                ' P.SubCode08, P.SubCode09, P.SubCode10, P.BasePrimaryUnitCode, ' +
		              ' PPUC.UnitOfMeasureCode, PPUC.ConversionFactor, PPUC.ConversionFactorType, PPUC.Multiplier ' +
	                ' From ' +
                  '(Select CompanyCode, ItemTypeCode, SubCode01, SubCode02, SubCode03, SubCode04, SubCode05, ' +
                  ' SubCode06, SubCode07, SubCode08, SubCode09, SubCode10, BasePrimaryUnitCode ' +
                  ' From product ' +
	                ' Where CompanyCode = ' + QuotedStr(CompanyInUsed) + ' and ItemTypeCode = ' + QuotedStr(ItemTypeCode) + ' and ' +
                  ' SubCode01 = ' + QuotedStr(SubCode01) + ' and SubCode02 = ' + QuotedStr(SubCode02) + ' and ' +
	                ' SubCode03 = ' + QuotedStr(SubCode03) + ' and SubCode04 = ' + QuotedStr(SubCode04) + ' and SubCode05 = ' + QuotedStr(SubCode05) + ' and' +
                  ' SubCode06 = ' + QuotedStr(SubCode06) + ' and ' + ' SubCode07 = ' + QuotedStr(SubCode07) + ' and ' +
                  ' SubCode08 = ' + QuotedStr(SubCode08) + ' and SubCode09 = ' + QuotedStr(SubCode09) + ' and SubCode10 = ' + QuotedStr(SubCode10) + ')' +
                  ' P Left Join ProductPrimaryUoMConversion PPUC ' +
                  ' On PPUC.ProductCompanyCode = P.CompanyCode and ' +
                  ' PPUC.ProductItemTypeCode = P.ItemTypeCode and ' +
                  ' PPUC.ProductSubCode01 = P.SubCode01 and ' +
                  ' PPUC.ProductSubCode02 = P.SubCode02 and ' +
                  ' PPUC.ProductSubCode03 = P.SubCode03 and ' +
                  ' PPUC.ProductSubCode04 = P.SubCode04 and ' +
                  ' PPUC.ProductSubCode05 = P.SubCode05 and ' +
                  ' PPUC.ProductSubCode06 = P.SubCode06 and ' +
                  ' PPUC.ProductSubCode07 = P.SubCode07 and ' +
                  ' PPUC.ProductSubCode08 = P.SubCode08 and ' +
                  ' PPUC.ProductSubCode09 = P.SubCode09 and ' +
                  ' PPUC.ProductSubCode10 = P.SubCode10 ' +
                  '	Order By PPUC.UnitOfMeasureCode ';
    HostQry.SQL.Text := hostSqlStr;

    try
      HostQry.Open;
    except
      ConvertByProductText := TStringList.Create;
      ConvertByProductText.add(HostQry.Text);
      ConvertByProductText.SaveToFile(LocAppGlobals.AppDir + '\ConvertByProduct.txt');
      ConvertByProductText.Free;
      raise
    end;

    if not HostQry.Eof then
    begin
      new(Result);
      ItemTypesRec.Productslist.Add(Result);
      Result.SubCode01 := trim(HostQry.FieldByName('SubCode01').AsString);
      Result.SubCode02 := trim(HostQry.FieldByName('SubCode02').AsString);
      Result.SubCode03 := trim(HostQry.FieldByName('SubCode03').AsString);
      Result.SubCode04 := trim(HostQry.FieldByName('SubCode04').AsString);
      Result.SubCode05 := trim(HostQry.FieldByName('SubCode05').AsString);
      Result.SubCode06 := trim(HostQry.FieldByName('SubCode06').AsString);
      Result.SubCode07 := trim(HostQry.FieldByName('SubCode07').AsString);
      Result.SubCode08 := trim(HostQry.FieldByName('SubCode08').AsString);
      Result.SubCode09 := trim(HostQry.FieldByName('SubCode09').AsString);
      Result.SubCode10 := trim(HostQry.FieldByName('SubCode10').AsString);
      Result.BasePrimaryUnitCode := trim(HostQry.FieldByName('BasePrimaryUnitCode').AsString);
      Result.Conversionslist := TList.Create;
      while not HostQry.Eof do
      begin
        new(CategoryConversionUMRec);
        CategoryConversionUMRec.UnitOfMeasureCode    := trim(HostQry.FieldByName('UnitOfMeasureCode').AsString);
        CategoryConversionUMRec.ConversionFactor     := HostQry.FieldByName('ConversionFactor').AsFloat;
        CategoryConversionUMRec.ConversionFactorType := trim(HostQry.FieldByName('ConversionFactorType').AsString);
        CategoryConversionUMRec.Multiplier           := HostQry.FieldByName('Multiplier').AsFloat;
        Result.Conversionslist.Add(CategoryConversionUMRec);
        HostQry.Next
      end;
    end;

    HostQry.Close;
    HostQry.Free;
  end;

end;


//------------------------------------------------------------------------------------------------//

function ConvertByProduct(FromUoM : string; ToUoM : string; QuantityInput : double; ProductsRec : PTProducts) : double;
var
  BasePrimaryUnitCode : string;
  CategoryConversionUMRec : PTCategoryConversionUM;
  I : Integer;
  found : boolean;
begin
  Result := -1;

  BasePrimaryUnitCode := ProductsRec.BasePrimaryUnitCode;

  if (FromUoM = BasePrimaryUnitCode) and assigned(ProductsRec) then
  begin
 // Find ToUoM in Conversions;
    for I := 0 to ProductsRec.Conversionslist.Count - 1 do
    begin
      if ToUoM <> PTCategoryConversionUM(ProductsRec.Conversionslist[I]).UnitOfMeasureCode then continue;
      if Trim(PTCategoryConversionUM(ProductsRec.Conversionslist[I]).ConversionFactorType) = '1' then
        Result := QuantityInput * (PTCategoryConversionUM(ProductsRec.Conversionslist[I]).ConversionFactor * PTCategoryConversionUM(ProductsRec.Conversionslist[I]).Multiplier)
      else if Trim(PTCategoryConversionUM(ProductsRec.Conversionslist[I]).ConversionFactorType) = '2' then
        Result := QuantityInput / (PTCategoryConversionUM(ProductsRec.Conversionslist[I]).ConversionFactor * PTCategoryConversionUM(ProductsRec.Conversionslist[I]).Multiplier);
      Exit;
    end;
  end;

  if (ToUoM = BasePrimaryUnitCode) and assigned(ProductsRec) then
  begin
    for I := 0 to ProductsRec.Conversionslist.Count - 1 do
    begin
      if FromUoM <> PTCategoryConversionUM(ProductsRec.Conversionslist[I]).UnitOfMeasureCode then continue;
      if Trim(PTCategoryConversionUM(ProductsRec.Conversionslist[I]).ConversionFactorType) = '1' then
        Result := QuantityInput / (PTCategoryConversionUM(ProductsRec.Conversionslist[I]).ConversionFactor * PTCategoryConversionUM(ProductsRec.Conversionslist[I]).Multiplier)
      else if Trim(PTCategoryConversionUM(ProductsRec.Conversionslist[I]).ConversionFactorType) = '2' then
        Result := QuantityInput * (PTCategoryConversionUM(ProductsRec.Conversionslist[I]).ConversionFactor * PTCategoryConversionUM(ProductsRec.Conversionslist[I]).Multiplier);
      Exit;
    end;
  end;

  if (FromUoM = BasePrimaryUnitCode) and assigned(ProductsRec) and (ToUoM = ProductsRec.BaseSecondaryUnitCode) then
  begin
    if ProductsRec.ConversionFactorType = '1' then
       Result := QuantityInput * ProductsRec.SecondaryUnsteadyCVSFactor * ProductsRec.Multiplier
    else
       Result := QuantityInput / ProductsRec.SecondaryUnsteadyCVSFactor * ProductsRec.Multiplier;
    exit;
  end;

  found := false;
  if assigned(ProductsRec) then
  begin
    for I := 0 to ProductsRec.Conversionslist.Count - 1 do
    begin
      if FromUoM <> PTCategoryConversionUM(ProductsRec.Conversionslist[I]).UnitOfMeasureCode then continue;
      found := true;
      if Trim(PTCategoryConversionUM(ProductsRec.Conversionslist[I]).ConversionFactorType) = '1' then
        Result := QuantityInput / (PTCategoryConversionUM(ProductsRec.Conversionslist[I]).ConversionFactor * PTCategoryConversionUM(ProductsRec.Conversionslist[I]).Multiplier)
      else if Trim(PTCategoryConversionUM(ProductsRec.Conversionslist[I]).ConversionFactorType) = '2' then
        Result := QuantityInput * (PTCategoryConversionUM(ProductsRec.Conversionslist[I]).ConversionFactor * PTCategoryConversionUM(ProductsRec.Conversionslist[I]).Multiplier);
      break;
    end;
  end;

  if not found then Exit;

  if assigned(ProductsRec) then
  begin
    for I := 0 to ProductsRec.Conversionslist.Count - 1 do
    begin
      if ToUoM <> PTCategoryConversionUM(ProductsRec.Conversionslist[I]).UnitOfMeasureCode then continue;
      if Trim(PTCategoryConversionUM(ProductsRec.Conversionslist[I]).ConversionFactorType) = '1' then
        Result := Result * (PTCategoryConversionUM(ProductsRec.Conversionslist[I]).ConversionFactor * PTCategoryConversionUM(ProductsRec.Conversionslist[I]).Multiplier)
      else if Trim(PTCategoryConversionUM(ProductsRec.Conversionslist[I]).ConversionFactorType) = '2' then
        Result := Result / (PTCategoryConversionUM(ProductsRec.Conversionslist[I]).ConversionFactor * PTCategoryConversionUM(ProductsRec.Conversionslist[I]).Multiplier);
      Exit;
    end;
  end;

end;

//------------------------------------------------------------------------------------------------//

function GetQuantityConverted(TypeUM : string; FromUoM : string; ToUoM : string; QuantityInput : double; var QuantityOutput : double) : boolean;
var
  I : Integer;
  List : TList;
  BaseUM : string;
begin
  BaseUM := '';
  Result := false;
  List := nil;
  for I := 0 to m_StdUnitCategoryConversion.Count - 1 do
  begin
    if TypeUM <> PTUnitConversion(m_StdUnitCategoryConversion[I]).TypeUm then continue;
    BaseUM := PTUnitConversion(m_StdUnitCategoryConversion[I]).BaseUMCode;
    List := PTUnitConversion(m_StdUnitCategoryConversion[I]).StdUnitCategoryConversionList;
    break
  end;

  if BaseUM = '' then Exit;

  if BaseUM = fromUom then
  begin
    for I := 0 to List.Count - 1 do
    begin
      if ToUoM <> PTCategoryConversionUM(List[I]).UnitOfMeasureCode then continue;
      Result := true;
      if Trim(PTCategoryConversionUM(List[I]).ConversionFactorType) = '1' then
        QuantityOutput := QuantityInput * (PTCategoryConversionUM(List[I]).ConversionFactor * PTCategoryConversionUM(List[I]).Multiplier)
      else if Trim(PTCategoryConversionUM(List[I]).ConversionFactorType) = '2' then
        QuantityOutput := QuantityInput * (PTCategoryConversionUM(List[I]).ConversionFactor / PTCategoryConversionUM(List[I]).Multiplier);
      Exit;
    end;
  end;

  if BaseUM = ToUom then
  begin
    for I := 0 to List.Count - 1 do
    begin
      if FromUoM <> PTCategoryConversionUM(List[I]).UnitOfMeasureCode then continue;
      Result := true;
      if Trim(PTCategoryConversionUM(List[I]).ConversionFactorType) = '1' then
        QuantityOutput := QuantityInput * (PTCategoryConversionUM(List[I]).ConversionFactor / PTCategoryConversionUM(List[I]).Multiplier)
      else if Trim(PTCategoryConversionUM(List[I]).ConversionFactorType) = '2' then
        QuantityOutput := QuantityInput * (PTCategoryConversionUM(List[I]).ConversionFactor * PTCategoryConversionUM(List[I]).Multiplier);
      Exit;
    end;
  end;

  for I := 0 to List.Count - 1 do
  begin
    if FromUoM <> PTCategoryConversionUM(List[I]).UnitOfMeasureCode then continue;
    Result := true;
    if Trim(PTCategoryConversionUM(List[I]).ConversionFactorType) = '1' then
      QuantityOutput := QuantityInput * (PTCategoryConversionUM(List[I]).ConversionFactor / PTCategoryConversionUM(List[I]).Multiplier)
    else if Trim(PTCategoryConversionUM(List[I]).ConversionFactorType) = '2' then
      QuantityOutput := QuantityInput * (PTCategoryConversionUM(List[I]).ConversionFactor * PTCategoryConversionUM(List[I]).Multiplier);
    break;
  end;

  for I := 0 to List.Count - 1 do
  begin
    if ToUoM <> PTCategoryConversionUM(List[I]).UnitOfMeasureCode then continue;
    Result := true;
    if Trim(PTCategoryConversionUM(List[I]).ConversionFactorType) = '1' then
      QuantityOutput := QuantityOutput * (PTCategoryConversionUM(List[I]).ConversionFactor * PTCategoryConversionUM(List[I]).Multiplier)
    else if Trim(PTCategoryConversionUM(List[I]).ConversionFactorType) = '2' then
      QuantityOutput := QuantityOutput / (PTCategoryConversionUM(List[I]).ConversionFactor * PTCategoryConversionUM(List[I]).Multiplier);
    Exit;
  end;

end;

//------------------------------------------------------------------------------------------------//

function ConvertBySameType(FromUoM : string; ToUoM : string; QuantityInput : double; var QuantityOutput : double) : boolean;
var
  Type1 ,Type2 : string;
begin
  QuantityOutput := 0;
  Result := true;

  if (m_UnitOfMeasureList.Count = 0) and not LoadIntoUnitOfMeasure then exit;

  if (m_StdUnitCategoryConversion.Count = 0) and not LoadIntoUnitConversion then exit;

  Type1 := FindTypeFromUMCode(trim(FromUoM));
  Type2 := FindTypeFromUMCode(trim(ToUoM));

  if (Type1 = '') or (Type2 = '') then exit;

  if Type1 <> Type2 then
  begin
    Result := false;
    exit;
  end;

  GetQuantityConverted(Type1,FromUoM,ToUoM,QuantityInput,QuantityOutput);

  if QuantityOutput = 0 then
    Result := false;

end;

//------------------------------------------------------------------------------------------------//

function ConvertUM(MQMProductionColumnValues : PMQMProductionColumnValues; FromUoM : string; ToUoM : string; QuantityInput : double; ItemTypeCode : string; SubCode01 : string; SubCode02 : string; SubCode03 : string;
                    SubCode04 : string; SubCode05 : string; SubCode06 : string; SubCode07 : string; SubCode08 : string; SubCode09 : string; SubCode10 : string) : double;
var
  BasePrimaryUoMCode, UserPrimaryUoMCode, BaseSecondaryUoMCode, UserSecondaryUoMCode, UserPackagingUoMCode : String;
  FromUoMType, ToUoMType, TransitionUoM, TransitionUoMType : String;
  BasePrimaryQty, UserPrimaryQty, BaseSecondaryQty, UserSecondaryQty, TransitionResult, UserPackagingQty : double;
  ProductsRec : PTProducts;
  I : Integer;
begin
  FromUoM := trim(FromUoM);
  ToUoM   := trim(ToUoM);
  if (FromUoM = ToUoM) or (QuantityInput = 0) then
  begin
    result := QuantityInput;
    exit;
  end;

  Result := 0;

  if (FromUoM = '') or (ToUoM = '') then
    exit;

  if MQMProductionColumnValues <> nil then
  begin
    BasePrimaryUoMCode := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_BASEPRIMARYUOMCODE', Get_PDS_BASEPRIMARYUOMCODE_Index));
    UserPrimaryUoMCode := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_USERPRIMARYUOMCODE', Get_PDS_USERPRIMARYUOMCODE_Index));
    BaseSecondaryUoMCode := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_BASESECONDARYUOMCODE' ,Get_PDS_BASESECONDARYUOMCODE_Index));
    UserSecondaryUoMCode := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_USERSECONDARYUOMCODE', Get_PDS_USERSECONDARYUOMCODE_Index));
    UserPackagingUoMCode := Trim(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_USERPACKAGINGUOMCODE', Get_PDS_USERPACKAGINGUOMCODE_Index));
    BasePrimaryQty := StrToFloat(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_INITIALBASEPRIMARYQUANTITY', Get_PDS_INITIALBASEPRIMARYQUANTITY_Index));
    UserPrimaryQty := StrToFloat(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_INITIALUSERPRIMARYQUANTITY', Get_PDS_INITIALUSERPRIMARYQUANTITY_index));
    BaseSecondaryQty := StrToFloat(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_INITIALBASESECONDARYQUANTITY', Get_PDS_INITIALBASESECONDARYQUANTITY_Index));
    UserSecondaryQty := StrToFloat(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_INITIALUSERSECONDARYQUANTITY', Get_PDS_INITIALUSERSECONDARYQUANTITY_Index));
    UserPackagingQty := StrToFloat(getValueOfTheProductionColumn(MQMProductionColumnValues, 'PDS_INITIALUSERPACKAGINGQUANTITY', Get_PDS_INITIALUSERPACKAGINGQUANTITY_Index));

    if FromUoM = BasePrimaryUoMCode then
    begin
      if (ToUoM = UserPrimaryUoMCode) and (UserPrimaryQty > 0) then
      begin
        result := QuantityInput * UserPrimaryQty / BasePrimaryQty;
        exit;
      end;
      if (ToUoM = BaseSecondaryUoMCode) and (BaseSecondaryQty > 0) then
      begin
        result := QuantityInput * BaseSecondaryQty / BasePrimaryQty;
        exit;
      end;
      if (ToUoM = UserSecondaryUoMCode) and (UserSecondaryQty > 0) then
      begin
        result := QuantityInput * UserSecondaryQty / BasePrimaryQty;
        exit;
      end;
      if (ToUoM = UserPackagingUoMCode) and (UserPackagingQty > 0) then
      begin
        result := QuantityInput * UserPackagingQty / BasePrimaryQty;
        exit;
      end;
    end;

    if FromUoM = UserPrimaryUoMCode then
    begin
      if (ToUoM = BasePrimaryUoMCode) and (BasePrimaryQty > 0) then
      begin
        result := QuantityInput * BasePrimaryQty / UserPrimaryQty;
        exit;
      end;
      if (ToUoM = BaseSecondaryUoMCode) and (BaseSecondaryQty > 0) then
      begin
        result := QuantityInput * BaseSecondaryQty / UserPrimaryQty;
        exit;
      end;
      if (ToUoM = UserSecondaryUoMCode) and (UserSecondaryQty > 0) then
      begin
        result := QuantityInput * UserSecondaryQty / UserPrimaryQty;
        exit;
      end;
      if (ToUoM = UserPackagingUoMCode) and (UserPackagingQty > 0) then
      begin
        result := QuantityInput * UserPackagingQty / UserPrimaryQty;
        exit;
      end;
    end;

    if FromUoM = BaseSecondaryUoMCode then
    begin
      if (ToUoM = BasePrimaryUoMCode) and (BasePrimaryQty > 0) then
      begin
        result := QuantityInput * BasePrimaryQty / BaseSecondaryQty;
        exit;
      end;
      if (ToUoM = UserPrimaryUoMCode) and (UserPrimaryQty > 0) then
      begin
        result := QuantityInput * UserPrimaryQty / BaseSecondaryQty;
        exit;
      end;
      if (ToUoM = UserSecondaryUoMCode) and (UserSecondaryQty > 0) then
      begin
        result := QuantityInput * UserSecondaryQty / BaseSecondaryQty;
        exit;
      end;
      if (ToUoM = UserPackagingUoMCode) and (UserPackagingQty > 0) then
      begin
        result := QuantityInput * UserPackagingQty / BaseSecondaryQty;
        exit;
      end;
    end;

    if FromUoM = UserSecondaryUoMCode then
    begin
      if (ToUoM = BasePrimaryUoMCode) and (BasePrimaryQty > 0) then
      begin
        result := QuantityInput * BasePrimaryQty / UserSecondaryQty;
        exit;
      end;
      if (ToUoM = UserPrimaryUoMCode) and (UserPrimaryQty > 0) then
      begin
        result := QuantityInput * UserPrimaryQty / UserSecondaryQty;
        exit;
      end;
      if (ToUoM = BaseSecondaryUoMCode) and (BaseSecondaryQty > 0) then
      begin
        result := QuantityInput * BaseSecondaryQty / UserSecondaryQty;
        exit;
      end;
      if (ToUoM = UserPackagingUoMCode) and (UserPackagingQty > 0) then
      begin
        result := QuantityInput * UserPackagingQty / UserSecondaryQty;
        exit;
      end;
    end;
  end;

  ProductsRec := GetProductConversions(ItemTypeCode ,Trim(SubCode01), Trim(SubCode02), Trim(SubCode03),
                    Trim(SubCode04), Trim(SubCode05), Trim(SubCode06), Trim(SubCode07), Trim(SubCode08), Trim(SubCode09), Trim(SubCode10));

  if ProductsRec = nil then
  begin
    ConvertBySameType(FromUoM, ToUoM, QuantityInput, Result);
    Exit;
  end;

  Result := ConvertByProduct(FromUoM, ToUoM, QuantityInput, ProductsRec);
  if Result <> -1 then
    Exit;

  Result := 0;

  if ConvertBySameType(FromUoM, ToUoM, QuantityInput, Result) then
    Exit;

  FromUoMType := FindTypeFromUMCode(trim(FromUoM));
  ToUoMType := FindTypeFromUMCode(trim(ToUoM));

  if (FromUoMType = '') or (ToUoMType = '') then
    Exit;

  for I := 0 to ProductsRec.Conversionslist.Count - 1 do
  begin
    TransitionUoM := PTCategoryConversionUM(ProductsRec.Conversionslist[I]).UnitOfMeasureCode;
    TransitionUoMType := FindTypeFromUMCode(trim(TransitionUoM));
    if (FromUoMType = TransitionUoMType) then
    begin
      if ConvertBySameType(FromUoM, TransitionUoM, QuantityInput, TransitionResult) then
      begin
        TransitionResult := ConvertByProduct(TransitionUoM, ToUoM, TransitionResult, ProductsRec);
        if (TransitionResult <> -1) then
        begin
          Result := TransitionResult;
          Exit;
        end;
      end;
    end;
    if ToUoMType = TransitionUoMType then
    begin
      TransitionResult := ConvertByProduct(FromUoM, TransitionUoM, QuantityInput, ProductsRec);
      if (TransitionResult <> -1) then
      begin
        if ConvertBySameType(TransitionUoM, ToUoM, TransitionResult, Result) then
          Exit;
      end;
    end;
  end;

  if (Result = -1) then
  begin
     Result := 0;
     if ConvertBySameType(FromUoM, ToUoM, QuantityInput, Result) then
        Exit;
  end;

end;

//------------------------------------------------------------------------------------------------//

procedure FreeUMList;
var
  I, J, K : Integer;
  PUnitConversion : PTUnitConversion;
  temTypes : PTItemTypes;
  Products : PTProducts;
begin
  for I := m_UnitOfMeasureList.Count - 1 downto 0 do
    dispose(PTUMMeasure(m_UnitOfMeasureList[I]));
  m_UnitOfMeasureList.Free;

  for I := m_StdUnitCategoryConversion.Count - 1 downto 0 do
  begin
    PUnitConversion := PTUnitConversion(m_StdUnitCategoryConversion[I]);
    for J := PUnitConversion.StdUnitCategoryConversionList.Count - 1 downto 0 do
      Dispose(PTCategoryConversionUM(PUnitConversion.StdUnitCategoryConversionList[J]));
    PUnitConversion.StdUnitCategoryConversionList.free;
    dispose(PTUnitConversion(m_StdUnitCategoryConversion[I]));
  end;
  m_StdUnitCategoryConversion.Free;

  for I := m_ItemTypeList.Count - 1 downto 0 do
  begin
    temTypes := PTItemTypes(m_ItemTypeList[I]);
    for J := temTypes.Productslist.Count - 1 downto 0 do
    begin
      Products := PTProducts(temTypes.Productslist[J]);
      for K := Products.Conversionslist.Count - 1 downto 0 do
        Dispose(PTCategoryConversionUM(Products.Conversionslist[K]));
      Products.Conversionslist.Free;
      Dispose(Products);
    end;
    temTypes.Productslist.Free;
    Dispose(temTypes);
  end;
  m_ItemTypeList.Free;

end;

//------------------------------------------------------------------------------------------------//

initialization

  m_UnitOfMeasureList         := TList.Create;
  m_StdUnitCategoryConversion := TList.Create;
  m_ItemTypeList              := TList.Create;

finalization

  FreeUMList;

end.
