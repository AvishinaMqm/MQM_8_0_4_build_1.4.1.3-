unit UMProdSortList;

interface

uses UMProdMemory, UMProductionStruct, System.Classes;

  function SortPR(Item1, Item2: Pointer) : integer;
  function SortPH(Item1, Item2: Pointer) : integer;
  function SortPD(Item1, Item2: Pointer) : integer;
  function SortPP(Item1, Item2: Pointer) : integer;
  function SortPI(Item1, Item2: Pointer) : integer;
  function SortEC(Item1, Item2: Pointer) : integer;
  function SortIC(Item1, Item2: Pointer) : integer;
  function SortSB(Item1, Item2: Pointer) : integer;
  function SortSP(Item1, Item2: Pointer) : integer;
  function SortSPByReqStepDate(Item1, Item2: Pointer) : integer;
  function SortST(Item1, Item2: Pointer) : integer;
  function SortSTByProductioOrderGroupStepNumberAndStepTimesKeys(Item1, Item2: Pointer) : integer;
  function SortMT(Item1, Item2: Pointer) : integer;
  function SortPA(Item1, Item2: Pointer) : integer;
  procedure FindAndAdd_LocaleStep_times(LocalListST : TList; MQMST : PTMQMST; var LastMultiplier : Integer);
  function FindInDemandReservationLines(DemandReservationLines_List : TList; countercode, ordercode : string; reservationline : integer) : PRecDemandReservationLine;

                        {   sql countercode , ordercode , read_Material_Schedule_list key and step number

 MDSL_TYPE_PROD	VARCHAR(3) NOT NULL,
        MDSL_PRODUCT_CODE	VARCHAR(120) NOT NULL,
        MDSL_SUB_DETAIL	VARCHAR(40) NOT NULL,
        MDSL_DETAIL_CODE	VARCHAR(15) NOT NULL,
        MDSL_PREQ_NO	VARCHAR(30),
        MDSL_PSTEP_ID	INTEGER,    }
  function FindAndAdd_MaterialDetailScheduleLink(MaterialDetailScheduleLink : TList; Request : string; stepNumber : integer; TYPE_PROD : string; PRODUCT_CODE : string; SUB_DETAIL : string; DETAIL_CODE : string) : PRecMS;


  function FindAndAdd_Allocations(AllocationsList : TList; code : string; LINENUMBER : integer; COMPONENTLINENUMBER : integer; var IsNewRecord : boolean) : PMQMAllocations;
  function FindAndAdd_ReservationLines(ReservationLines : TList; OnlyFind : boolean; ORDERCOUNTERCODE : string; ORDERCODE : string; RESERVATION_LINE : integer; var IsNewRecord : boolean) : PMQMProductionReservationLine;
  function FindAndAdd_ProductionOrderLines(ProductionOrderLines : TList; OnlyFind : boolean; PRODUCTIONORDERCODE : string; groupline : integer; var IsNewRecord : boolean) : PMQMProductionOrderLines;

implementation

function FindInDemandReservationLines(DemandReservationLines_List : TList; countercode, ordercode : string; reservationline : integer) : PRecDemandReservationLine;
var
  i: integer;
  Multiplier, NumberOfEntries, NumberOfEntriesMinusOne : integer;
begin
  Result := nil;

  NumberOfEntries := DemandReservationLines_List.Count;
  if NumberOfEntries = 0 then exit;
  NumberOfEntriesMinusOne := NumberOfEntries - 1;

  Multiplier := 1;
  while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    i := Multiplier - 1;

  while (Multiplier > 0) do
  begin
    Multiplier := trunc(Multiplier / 2);

    if (i > NumberOfEntriesMinusOne)
    or ((PRecDemandReservationLine(DemandReservationLines_List[i]).ORDERCOUNTERCODE > countercode)) then
    begin
      i := i - Multiplier;
      Continue;
    end;

    if  (PRecDemandReservationLine(DemandReservationLines_List[i]).ORDERCOUNTERCODE < countercode) then
    begin
      i := i + Multiplier;
      Continue;
    end;

    if  (PRecDemandReservationLine(DemandReservationLines_List[i]).ordercode < ordercode) then
    begin
      i := i + Multiplier;
      Continue;
    end;

    if  (PRecDemandReservationLine(DemandReservationLines_List[i]).ordercode > ordercode) then
    begin
      i := i - Multiplier;
      Continue;
    end;

    if (PRecDemandReservationLine(DemandReservationLines_List[i]).reservationline < reservationline) then
    begin
      i := i + Multiplier;
      Continue;
    end;

    if  (PRecDemandReservationLine(DemandReservationLines_List[i]).reservationline > reservationline) then
    begin
      i := i - Multiplier;
      Continue;
    end;


    Result := PRecDemandReservationLine(DemandReservationLines_List[i]);
    Break;

  end;

end;

//----------------------------------------------------------------------------//

function FindAndAdd_MaterialDetailScheduleLink(MaterialDetailScheduleLink : TList; Request : string; stepNumber : integer; TYPE_PROD : string; PRODUCT_CODE : string; SUB_DETAIL : string; DETAIL_CODE : string) : PRecMS;
var
  i, Index : integer;
  Multiplier, NumberOfEntries, NumberOfEntriesMinusOne : integer;
  RecMaterialDetailScheduleLink : PRecMS; //
begin
  NumberOfEntries := MaterialDetailScheduleLink.Count;
  Result := nil;
  Index := NumberOfEntries;

  if NumberOfEntries > 0 then
  begin
    NumberOfEntriesMinusOne := NumberOfEntries - 1;
    Multiplier := 1;
    while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    i := Multiplier - 1;

    while (Multiplier > 0) do
    begin
      Multiplier := trunc(Multiplier / 2);

      if (i > NumberOfEntriesMinusOne) then
      begin
        i := i - Multiplier;
        Continue;
      end;

      if  (PRecMS(MaterialDetailScheduleLink[i]).MS_Preq_No > Request) then
      begin
        if I < Index then Index := I;
        i := i - Multiplier;
        Continue;
      end;

      if  (PRecMS(MaterialDetailScheduleLink[i]).MS_Preq_No < Request) then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if  (PRecMS(MaterialDetailScheduleLink[i]).MS_Step > stepNumber) then
      begin
        if I < Index then Index := I;
        i := i - Multiplier;
        Continue;
      end;

      if  (PRecMS(MaterialDetailScheduleLink[i]).MS_Step < stepNumber) then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if  (PRecMS(MaterialDetailScheduleLink[i]).MS_Type_Prod > TYPE_PROD) then
      begin
        if I < Index then Index := I;
        i := i - Multiplier;
        Continue;
      end;

      if  (PRecMS(MaterialDetailScheduleLink[i]).MS_Type_Prod < TYPE_PROD) then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if  (PRecMS(MaterialDetailScheduleLink[i]).MS_Product_Code > PRODUCT_CODE) then
      begin
        if I < Index then Index := I;
        i := i - Multiplier;
        Continue;
      end;

      if  (PRecMS(MaterialDetailScheduleLink[i]).MS_Product_Code < PRODUCT_CODE) then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if  (PRecMS(MaterialDetailScheduleLink[i]).MS_Sub_Detail > SUB_DETAIL) then
      begin
        if I < Index then Index := I;
        i := i - Multiplier;
        Continue;
      end;

      if  (PRecMS(MaterialDetailScheduleLink[i]).MS_Sub_Detail < SUB_DETAIL) then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if  (PRecMS(MaterialDetailScheduleLink[i]).MS_Detail_Code > DETAIL_CODE) then
      begin
        if I < Index then Index := I;
        i := i - Multiplier;
        Continue;
      end;

      if  (PRecMS(MaterialDetailScheduleLink[i]).MS_Detail_Code < DETAIL_CODE) then
      begin
        i := i + Multiplier;
        Continue;
      end;

      Result := PRecMS(MaterialDetailScheduleLink[i]);
      Index := i;
      Break;

    end;

  end;

  if (Result = nil) then
  begin
    new(RecMaterialDetailScheduleLink);
    RecMaterialDetailScheduleLink.MS_Preq_No := Request;
    RecMaterialDetailScheduleLink.MS_Step := stepNumber;
    RecMaterialDetailScheduleLink.MS_Type_Prod := TYPE_PROD;
    RecMaterialDetailScheduleLink.MS_Product_Code := PRODUCT_CODE;
    RecMaterialDetailScheduleLink.MS_Sub_Detail := SUB_DETAIL;
    RecMaterialDetailScheduleLink.MS_Detail_Code := DETAIL_CODE;
    MaterialDetailScheduleLink.insert(Index, RecMaterialDetailScheduleLink);
  end;

end;

//----------------------------------------------------------------------------//

function FindAndAdd_Allocations(AllocationsList : TList; code : string; LINENUMBER : integer; COMPONENTLINENUMBER : integer; var IsNewRecord : boolean) : PMQMAllocations;
var
  i, Index : integer;
  Multiplier, NumberOfEntries, NumberOfEntriesMinusOne : integer;
  MQMAllocations : PMQMAllocations;
begin
  NumberOfEntries := AllocationsList.Count;
  Result := nil;
  Index := NumberOfEntries;
  IsNewRecord := false;

  if NumberOfEntries > 0 then
  begin
    NumberOfEntriesMinusOne := NumberOfEntries - 1;
    Multiplier := 1;
    while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    i := Multiplier - 1;

    while (Multiplier > 0) do
    begin
      Multiplier := trunc(Multiplier / 2);

      if (i > NumberOfEntriesMinusOne) then
      begin
        i := i - Multiplier;
        Continue;
      end;

      if  (PMQMAllocations(AllocationsList[i]).CODE > CODE) then
      begin
        if I < Index then Index := I;
        i := i - Multiplier;
        Continue;
      end;

      if  (PMQMAllocations(AllocationsList[i]).CODE < CODE) then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if  (PMQMAllocations(AllocationsList[i]).LINENUMBER > LINENUMBER) then
      begin
        if I < Index then Index := I;
        i := i - Multiplier;
        Continue;
      end;

      if  (PMQMAllocations(AllocationsList[i]).LINENUMBER < LINENUMBER) then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if  (PMQMAllocations(AllocationsList[i]).COMPONENTLINENUMBER > COMPONENTLINENUMBER) then
      begin
        if I < Index then Index := I;
        i := i - Multiplier;
        Continue;
      end;

      if  (PMQMAllocations(AllocationsList[i]).COMPONENTLINENUMBER < COMPONENTLINENUMBER) then
      begin
        i := i + Multiplier;
        Continue;
      end;

      Result := PMQMAllocations(AllocationsList[i]);
      Index := i;
      Break;

    end;

  end;

  if (Result = nil) then
  begin
    IsNewRecord := true;
    new(MQMAllocations);
    MQMAllocations.CODE := CODE;
    MQMAllocations.LINENUMBER := LINENUMBER;
    MQMAllocations.COMPONENTLINENUMBER := COMPONENTLINENUMBER;

    AllocationsList.insert(Index, MQMAllocations);
    Result := MQMAllocations;
  end;

end;

//----------------------------------------------------------------------------//

function FindAndAdd_ReservationLines(ReservationLines : TList; OnlyFind : boolean; ORDERCOUNTERCODE : string; ORDERCODE : string; RESERVATION_LINE : integer; var IsNewRecord : boolean) : PMQMProductionReservationLine;
var
  i, Index : integer;
  Multiplier, NumberOfEntries, NumberOfEntriesMinusOne : integer;
  MQMProductionReservationLine : PMQMProductionReservationLine;
begin
  NumberOfEntries := ReservationLines.Count;
  Result := nil;
  Index := NumberOfEntries;
  IsNewRecord := false;

  if NumberOfEntries > 0 then
  begin
    NumberOfEntriesMinusOne := NumberOfEntries - 1;
    Multiplier := 1;
    while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    i := Multiplier - 1;

    while (Multiplier > 0) do
    begin
      Multiplier := trunc(Multiplier / 2);

      if (i > NumberOfEntriesMinusOne) then
      begin
        i := i - Multiplier;
        Continue;
      end;

      if  (PMQMProductionReservationLine(ReservationLines[i]).ORDERCOUNTERCODE > ORDERCOUNTERCODE) then
      begin
        if I < Index then Index := I;
        i := i - Multiplier;
        Continue;
      end;

      if  (PMQMProductionReservationLine(ReservationLines[i]).ORDERCOUNTERCODE < ORDERCOUNTERCODE) then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if  (PMQMProductionReservationLine(ReservationLines[i]).ORDERCODE > ORDERCODE) then
      begin
        if I < Index then Index := I;
        i := i - Multiplier;
        Continue;
      end;

      if  (PMQMProductionReservationLine(ReservationLines[i]).ORDERCODE < ORDERCODE) then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if  (PMQMProductionReservationLine(ReservationLines[i]).RESERVATION_LINE > RESERVATION_LINE) then
      begin
        if I < Index then Index := I;
        i := i - Multiplier;
        Continue;
      end;

      if  (PMQMProductionReservationLine(ReservationLines[i]).RESERVATION_LINE < RESERVATION_LINE) then
      begin
        i := i + Multiplier;
        Continue;
      end;

      Result := PMQMProductionReservationLine(ReservationLines[i]);
      Index := i;
      Break;

    end;

  end;

  if OnlyFind then exit;

  if (Result = nil) then
  begin
    IsNewRecord := true;
    new(MQMProductionReservationLine);
    MQMProductionReservationLine.ORDERCOUNTERCODE := ORDERCOUNTERCODE;
    MQMProductionReservationLine.ORDERCODE := ORDERCODE;
    MQMProductionReservationLine.RESERVATION_LINE := RESERVATION_LINE;
    MQMProductionReservationLine.AllocatedQuantity := 0;
    ReservationLines.insert(Index, MQMProductionReservationLine);
    Result := MQMProductionReservationLine;
  end;

end;

//----------------------------------------------------------------------------//

function FindAndAdd_ProductionOrderLines(ProductionOrderLines : TList; OnlyFind : boolean; PRODUCTIONORDERCODE : string; groupline : integer; var IsNewRecord : boolean) : PMQMProductionOrderLines;
var
  i, Index : integer;
  Multiplier, NumberOfEntries, NumberOfEntriesMinusOne : integer;
  MQMProductionOrderLines : PMQMProductionOrderLines;
begin
  NumberOfEntries := ProductionOrderLines.Count;
  Result := nil;
  Index := NumberOfEntries;
  IsNewRecord := false;

  if NumberOfEntries > 0 then
  begin
    NumberOfEntriesMinusOne := NumberOfEntries - 1;
    Multiplier := 1;
    while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    i := Multiplier - 1;

    while (Multiplier > 0) do
    begin
      Multiplier := trunc(Multiplier / 2);

      if (i > NumberOfEntriesMinusOne) then
      begin
        i := i - Multiplier;
        Continue;
      end;

      if  (PMQMProductionOrderLines(ProductionOrderLines[i]).PRODUCTIONORDERCODE > PRODUCTIONORDERCODE) then
      begin
        if I < Index then Index := I;
        i := i - Multiplier;
        Continue;
      end;

      if  (PMQMProductionOrderLines(ProductionOrderLines[i]).PRODUCTIONORDERCODE < PRODUCTIONORDERCODE) then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if  (PMQMProductionOrderLines(ProductionOrderLines[i]).groupline > groupline) then
      begin
        if I < Index then Index := I;
        i := i - Multiplier;
        Continue;
      end;

      if  (PMQMProductionOrderLines(ProductionOrderLines[i]).groupline < groupline) then
      begin
        i := i + Multiplier;
        Continue;
      end;

      Result := PMQMProductionOrderLines(ProductionOrderLines[i]);
      Index := i;
      Break;

    end;

  end;

  if OnlyFind then exit;

  if (Result = nil) then
  begin
    IsNewRecord := true;
    new(MQMProductionOrderLines);
    MQMProductionOrderLines.PRODUCTIONORDERCODE := PRODUCTIONORDERCODE;
    MQMProductionOrderLines.groupline := groupline;
    MQMProductionOrderLines.UserQuantity := 0;
    MQMProductionOrderLines.BaseQuantity := 0;
    ProductionOrderLines.insert(Index, MQMProductionOrderLines);
    Result := MQMProductionOrderLines;
  end;
end;

//----------------------------------------------------------------------------//

procedure FindAndAdd_LocaleStep_times(LocalListST : TList; MQMST : PTMQMST; var LastMultiplier : Integer);
var
  RecMQMST : PTMQMST;
  I: integer;
  Multiplier, NumberOfEntries, LowestHighestValue : integer;
begin
  NumberOfEntries := LocalListST.Count;
  LowestHighestValue := NumberOfEntries;

  if NumberOfEntries > 0 then
  begin

    Multiplier := LastMultiplier;
    while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    LastMultiplier := Multiplier;
    I := Multiplier - 1;

    while (Multiplier > 0) do
    begin
      Multiplier := trunc(Multiplier / 2);

      if (i >= NumberOfEntries) then
      begin
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMST(LocalListST[I]).ST_PREQ_NO < MQMST.ST_PREQ_NO then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMST(LocalListST[I]).ST_PREQ_NO > MQMST.ST_PREQ_NO) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMST(LocalListST[I]).ST_PSTEP_ID < MQMST.ST_PSTEP_ID then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMST(LocalListST[I]).ST_PSTEP_ID > MQMST.ST_PSTEP_ID) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMST(LocalListST[I]).ST_WKCNTER < MQMST.ST_WKCNTER then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMST(LocalListST[I]).ST_WKCNTER > MQMST.ST_WKCNTER) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMST(LocalListST[I]).ST_WKCT_PROC < MQMST.ST_WKCT_PROC then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMST(LocalListST[I]).ST_WKCT_PROC > MQMST.ST_WKCT_PROC) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMST(LocalListST[I]).ST_RES_CATEGORY < MQMST.ST_RES_CATEGORY then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMST(LocalListST[I]).ST_RES_CATEGORY > MQMST.ST_RES_CATEGORY) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMST(LocalListST[I]).ST_RSC_CODE < MQMST.ST_RSC_CODE then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMST(LocalListST[I]).ST_RSC_CODE > MQMST.ST_RSC_CODE) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      if PTMQMST(LocalListST[I]).ST_SETUP_TIME_Mechin_Code < MQMST.ST_SETUP_TIME_Mechin_Code then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if (PTMQMST(LocalListST[I]).ST_SETUP_TIME_Mechin_Code > MQMST.ST_SETUP_TIME_Mechin_Code) then
      begin
        if I < LowestHighestValue then LowestHighestValue := I;
        i := i - Multiplier;
        Continue;
      end;

      Exit;

    end;
  end;

  new(RecMQMST);
  RecMQMST^ := MQMST^;
  LocalListST.Insert(LowestHighestValue, RecMQMST);
end;

//----------------------------------------------------------------------------//

function SortPR(Item1, Item2: Pointer) : integer;
var
  MQMPR1 : PTMQMPR;
  MQMPR2 : PTMQMPR;
begin
  MQMPR1 := PTMQMPR(Item1);
  MQMPR2 := PTMQMPR(Item2);
  if MQMPR1.PR_PREQ_NO < MQMPR2.PR_PREQ_NO then
    Result := -1
  else if (MQMPR1.PR_PREQ_NO = MQMPR2.PR_PREQ_NO) then
    Result := 0
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function SortPH(Item1, Item2: Pointer) : integer;
var
  MQMPH1 : PTMQMPH;
  MQMPH2 : PTMQMPH;
begin
  MQMPH1 := PTMQMPH(Item1);
  MQMPH2 := PTMQMPH(Item2);
  if MQMPH1.PH_PREQ_NO < MQMPH2.PH_PREQ_NO then
    Result := -1
  else if (MQMPH1.PH_PREQ_NO = MQMPH2.PH_PREQ_NO) then
    Result := 0
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function SortPD(Item1, Item2: Pointer) : integer;
var
  MQMPD1 : PTMQMPD;
  MQMPD2 : PTMQMPD;
begin
  MQMPD1 := PTMQMPD(Item1);
  MQMPD2 := PTMQMPD(Item2);
  if (MQMPD1.PD_PREQ_NO < MQMPD2.PD_PREQ_NO) then
    Result := -1
  else if (MQMPD1.PD_PREQ_NO = MQMPD2.PD_PREQ_NO) then
  begin
    if (MQMPD1.PD_PSTEP_ID < MQMPD2.PD_PSTEP_ID) then
      Result := -1
    else if (MQMPD1.PD_PSTEP_ID = MQMPD2.PD_PSTEP_ID) then
      Result := 0
    else
      Result := 1;
  end
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function SortPP(Item1, Item2: Pointer) : integer;
var
  MQMPP1 : PTMQMPP;
  MQMPP2 : PTMQMPP;
begin
  MQMPP1 := PTMQMPP(Item1);
  MQMPP2 := PTMQMPP(Item2);

  if MQMPP1.PP_SortKey < MQMPP2.PP_SortKey then
    Result := -1
  else if MQMPP1.PP_SortKey > MQMPP2.PP_SortKey then
    Result := 1
  else
    Result := 0;
end;

//----------------------------------------------------------------------------//

function SortPI(Item1, Item2: Pointer) : integer;
var
  MQMPI1 : PTMQMPI;
  MQMPI2 : PTMQMPI;
begin
  MQMPI1 := PTMQMPI(Item1);
  MQMPI2 := PTMQMPI(Item2);
  if (MQMPI1.PI_PREQ_NO < MQMPI2.PI_PREQ_NO) then
    Result := -1
  else if (MQMPI1.PI_PREQ_NO = MQMPI2.PI_PREQ_NO) then
  begin
    if (MQMPI1.PI_PSTEP_ID < MQMPI2.PI_PSTEP_ID) then
      Result := -1
    else if (MQMPI1.PI_PSTEP_ID = MQMPI2.PI_PSTEP_ID) then
    begin
      if (MQMPI1.PI_INFO_TYPE < MQMPI2.PI_INFO_TYPE) then
         Result := -1
      else if (MQMPI1.PI_INFO_TYPE = MQMPI2.PI_INFO_TYPE) then
      begin
        if (MQMPI1.PI_INFO_LINE_NUM < MQMPI2.PI_INFO_LINE_NUM) then
          Result := -1
        else if (MQMPI1.PI_INFO_LINE_NUM = MQMPI2.PI_INFO_LINE_NUM) then
          Result := 0
        else
          Result := 1;
      end
      else
        Result := 1;
    end
    else
      Result := 1;
  end
  else
    Result := 1;
end;

//------------------------------------------------------------------------

function SortEC(Item1, Item2: Pointer) : integer;
var
  MQMEC1 : PTMQMEC;
  MQMEC2 : PTMQMEC;
begin
  MQMEC1 := PTMQMEC(Item1);
  MQMEC2 := PTMQMEC(Item2);
  if MQMEC1.EC_PREQ_NO < MQMEC2.EC_PREQ_NO then
    Result := -1
  else if (MQMEC1.EC_PREQ_NO = MQMEC2.EC_PREQ_NO) then
  begin
    if (MQMEC1.EC_CONNE_KEY < MQMEC2.EC_CONNE_KEY) then
      Result := -1
    else if (MQMEC1.EC_CONNE_KEY = MQMEC2.EC_CONNE_KEY) then
      Result := 0
    else
      Result := 1
  end
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function SortIC(Item1, Item2: Pointer) : integer;
var
  MQMIC1 : PTMQMIC;
  MQMIC2 : PTMQMIC;
begin
  MQMIC1 := PTMQMIC(Item1);
  MQMIC2 := PTMQMIC(Item2);
  if MQMIC1.IC_PREQ_NO < MQMIC2.IC_PREQ_NO then
    Result := -1
  else if (MQMIC1.IC_PREQ_NO = MQMIC2.IC_PREQ_NO) then
  begin
    if (MQMIC1.IC_PREV_PREQ_NO < MQMIC2.IC_PREV_PREQ_NO) then
      Result := -1
    else if (MQMIC1.IC_PREV_PREQ_NO = MQMIC2.IC_PREV_PREQ_NO) then
      Result := 0
    else
      Result := 1
  end
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function SortSB(Item1, Item2: Pointer) : integer;
var
  MQMSB1 : PTMQMSB;
  MQMSB2 : PTMQMSB;
begin
  MQMSB1 := PTMQMSB(Item1);
  MQMSB2 := PTMQMSB(Item2);
  if MQMSB1.SB_PREQ_NO < MQMSB2.SB_PREQ_NO then
    Result := -1
  else if (MQMSB1.SB_PREQ_NO = MQMSB2.SB_PREQ_NO) then
  begin
    if (MQMSB1.SB_PSTEP_ID < MQMSB2.SB_PSTEP_ID) then
      Result := -1
    else if (MQMSB1.SB_PSTEP_ID = MQMSB2.SB_PSTEP_ID) then
    begin
      if (MQMSB1.SB_BCH_UM < MQMSB2.SB_BCH_UM) then
        Result := -1
      else if (MQMSB1.SB_BCH_UM = MQMSB2.SB_BCH_UM) then
        Result := 0
      else
        Result := 1;
    end
    else
      Result := 1
  end
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function SortSP(Item1, Item2: Pointer) : integer;
var
  MQMSP1 : PTMQMSP;
  MQMSP2 : PTMQMSP;
begin
  MQMSP1 := PTMQMSP(Item1);
  MQMSP2 := PTMQMSP(Item2);

  if MQMSP1.SP_PREQ_NO < MQMSP2.SP_PREQ_NO then
     Result := -1
  else if (MQMSP1.SP_PREQ_NO = MQMSP2.SP_PREQ_NO) then
  begin
    if (MQMSP1.SP_PSTEP_ID < MQMSP2.SP_PSTEP_ID) then
       Result := -1
    else if (MQMSP1.SP_PSTEP_ID = MQMSP2.SP_PSTEP_ID) then
    begin
      if (MQMSP1.SP_PSUBST_ID < MQMSP2.SP_PSUBST_ID) then
        Result := -1
      else if (MQMSP1.SP_PSUBST_ID = MQMSP2.SP_PSUBST_ID) then
      begin
        if (MQMSP1.SP_REPROC_NO < MQMSP2.SP_REPROC_NO) then
          Result := -1
        else if (MQMSP1.SP_REPROC_NO > MQMSP2.SP_REPROC_NO) then
          Result := 1
        else
          Result := 0;
      end
      else
        Result := 1
    end
    else
      Result := 1;
  end
  else
    Result := 1;

end;

//----------------------------------------------------------------------------//

function SortSPByReqStepDate(Item1, Item2: Pointer) : integer;
var
  MQMSP1 : PTMQMSP;
  MQMSP2 : PTMQMSP;
begin
  MQMSP1 := PTMQMSP(Item1);
  MQMSP2 := PTMQMSP(Item2);

  if MQMSP1.SP_PREQ_NO < MQMSP2.SP_PREQ_NO then
     Result := -1
  else if (MQMSP1.SP_PREQ_NO = MQMSP2.SP_PREQ_NO) then
  begin
    if (MQMSP1.SP_PSTEP_ID < MQMSP2.SP_PSTEP_ID) then
       Result := -1
    else if (MQMSP1.SP_PSTEP_ID = MQMSP2.SP_PSTEP_ID) then
    begin
      if (MQMSP1.SP_PROGRSTART < MQMSP2.SP_PROGRSTART) then
        Result := -1
      else if (MQMSP1.SP_PROGRSTART = MQMSP2.SP_PROGRSTART) then
      begin
        if (MQMSP1.SP_RSC_CODE < MQMSP2.SP_RSC_CODE) then
          result := -1
        else if (MQMSP1.SP_RSC_CODE = MQMSP2.SP_RSC_CODE) then
          result := 0
        else
          Result := 1
      end
      else
        Result := 1
    end
    else
      Result := 1;
  end
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function SortST(Item1, Item2: Pointer) : integer;
var
  MQMST1 : PTMQMST;
  MQMST2 : PTMQMST;
begin
  MQMST1 := PTMQMST(Item1);
  MQMST2 := PTMQMST(Item2);

  if MQMST1.ST_PREQ_NO < MQMST2.ST_PREQ_NO then
     Result := -1
  else if (MQMST1.ST_PREQ_NO = MQMST2.ST_PREQ_NO) then
  begin
    if (MQMST1.ST_PSTEP_ID < MQMST2.ST_PSTEP_ID) then
       Result := -1
    else if (MQMST1.ST_PSTEP_ID = MQMST2.ST_PSTEP_ID) then
    begin
      if (MQMST1.ST_WKCNTER < MQMST2.ST_WKCNTER) then
        Result := -1
      else if (MQMST1.ST_WKCNTER = MQMST2.ST_WKCNTER) then
      begin
        if (MQMST1.ST_WKCT_PROC < MQMST2.ST_WKCT_PROC) then
          Result := -1
        else if (MQMST1.ST_WKCT_PROC = MQMST2.ST_WKCT_PROC) then
        begin
          if (MQMST1.ST_RES_CATEGORY < MQMST2.ST_RES_CATEGORY) then
            Result := -1
          else if (MQMST1.ST_RES_CATEGORY = MQMST2.ST_RES_CATEGORY) then
          begin
            if (MQMST1.ST_RSC_CODE < MQMST2.ST_RSC_CODE) then
              Result := -1
            else if (MQMST1.ST_RSC_CODE = MQMST2.ST_RSC_CODE) then
            begin
              if MQMST1.ST_SETUP_TIME_Mechin_Code < MQMST2.ST_SETUP_TIME_Mechin_Code then
                Result := -1
              else if (MQMST1.ST_SETUP_TIME_Mechin_Code = MQMST2.ST_SETUP_TIME_Mechin_Code) then
                Result := 0
              else
                Result := 1
            end
            else
              Result := 1;
          end
          else
            Result := 1;
        end
        else
          Result := 1;
      end
      else
        Result := 1
    end
    else
      Result := 1;
  end
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function SortSTByProductioOrderGroupStepNumberAndStepTimesKeys(Item1, Item2: Pointer) : integer;
var
  MQMST1 : PTMQMST;
  MQMST2 : PTMQMST;
begin
  MQMST1 := PTMQMST(Item1);
  MQMST2 := PTMQMST(Item2);

  if MQMST1.ST_ProductionOrderCode < MQMST2.ST_ProductionOrderCode then
    Result := -1
  else if (MQMST1.ST_ProductionOrderCode = MQMST2.ST_ProductionOrderCode) then
  begin
    if (MQMST1.ST_GroupStepNumber < MQMST2.ST_GroupStepNumber) then
      Result := -1
    else if (MQMST1.ST_GroupStepNumber = MQMST2.ST_GroupStepNumber) then
    begin
      if (MQMST1.ST_WKCNTER < MQMST2.ST_WKCNTER) then
        Result := -1
      else if (MQMST1.ST_WKCNTER = MQMST2.ST_WKCNTER) then
      begin
        if (MQMST1.ST_WKCT_PROC < MQMST2.ST_WKCT_PROC) then
          Result := -1
        else if (MQMST1.ST_WKCT_PROC = MQMST2.ST_WKCT_PROC) then
        begin
          if (MQMST1.ST_RES_CATEGORY < MQMST2.ST_RES_CATEGORY) then
            Result := -1
          else if (MQMST1.ST_RES_CATEGORY = MQMST2.ST_RES_CATEGORY) then
          begin
            if (MQMST1.ST_RSC_CODE < MQMST2.ST_RSC_CODE) then
              Result := -1
            else if (MQMST1.ST_RSC_CODE = MQMST2.ST_RSC_CODE) then
            begin
              if MQMST1.ST_SETUP_TIME_Mechin_Code < MQMST2.ST_SETUP_TIME_Mechin_Code then
                Result := -1
              else if (MQMST1.ST_SETUP_TIME_Mechin_Code = MQMST2.ST_SETUP_TIME_Mechin_Code) then
                Result := 0
              else
                Result := 1
            end
            else
              Result := 1;
          end
          else
            Result := 1;
        end
        else
          Result := 1;

      end;

    end
    else
      Result := 1
  end
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function SortMT(Item1, Item2: Pointer) : integer;
var
  MQMMT1 : PTMQMMT;
  MQMMT2 : PTMQMMT;
begin
  MQMMT1 := PTMQMMT(Item1);
  MQMMT2 := PTMQMMT(Item2);

  if MQMMT1.MT_PROD_REQ_Nr < MQMMT2.MT_PROD_REQ_Nr then
     Result := -1
  else if (MQMMT1.MT_PROD_REQ_Nr = MQMMT2.MT_PROD_REQ_Nr) then
  begin
    if (MQMMT1.MT_PSTEP_ID < MQMMT2.MT_PSTEP_ID) then
       Result := -1
    else if (MQMMT1.MT_PSTEP_ID = MQMMT2.MT_PSTEP_ID) then
    begin
//      if (MQMMT1.MT_ORG_STEP < MQMMT2.MT_ORG_STEP) then
//         Result := -1
//      else if (MQMMT1.MT_ORG_STEP = MQMMT2.MT_ORG_STEP) then
//      begin
        if (MQMMT1.MT_WKCTR_CODE < MQMMT2.MT_WKCTR_CODE) then
          Result := -1
        else if (MQMMT1.MT_WKCTR_CODE = MQMMT2.MT_WKCTR_CODE) then
        begin
          if (MQMMT1.MT_RES_CAT_CODE < MQMMT2.MT_RES_CAT_CODE) then
            Result := -1
          else if (MQMMT1.MT_RES_CAT_CODE = MQMMT2.MT_RES_CAT_CODE) then
          begin
            if (MQMMT1.MT_RES_CODE < MQMMT2.MT_RES_CODE) then
              Result := -1
            else if (MQMMT1.MT_RES_CODE = MQMMT2.MT_RES_CODE) then
            begin
              if (MQMMT1.MT_MACHIN_SETUP_CODE < MQMMT2.MT_MACHIN_SETUP_CODE) then
                Result := -1
              else if (MQMMT1.MT_MACHIN_SETUP_CODE = MQMMT2.MT_MACHIN_SETUP_CODE) then
              begin
                if (MQMMT1.MT_ALTERNATIVE_CODE < MQMMT2.MT_ALTERNATIVE_CODE) then
                  Result := -1
                else if (MQMMT1.MT_ALTERNATIVE_CODE = MQMMT2.MT_ALTERNATIVE_CODE) then
                begin
                  if (MQMMT1.MT_PROD_TYPE < MQMMT2.MT_PROD_TYPE) then
                    Result := -1
                  else if (MQMMT1.MT_PROD_TYPE = MQMMT2.MT_PROD_TYPE) then
                  begin
                    if (MQMMT1.MT_PROD_CODE < MQMMT2.MT_PROD_CODE) then
                      Result := -1
                    else if (MQMMT1.MT_PROD_CODE = MQMMT2.MT_PROD_CODE) then
                    begin
                      if (MQMMT1.MT_NET_GROUP_CODE < MQMMT2.MT_NET_GROUP_CODE) then
                        Result := -1
                      else if (MQMMT1.MT_NET_GROUP_CODE = MQMMT2.MT_NET_GROUP_CODE) then
                      begin
                        if (MQMMT1.MT_ISSUE_CODE < MQMMT2.MT_ISSUE_CODE) then
                           Result := -1
                        else if (MQMMT1.MT_ISSUE_CODE = MQMMT2.MT_ISSUE_CODE) then
                        begin
                          if (MQMMT1.MT_SEQ_ISSUED < MQMMT2.MT_SEQ_ISSUED) then
                             Result := -1
                          else if (MQMMT1.MT_SEQ_ISSUED = MQMMT2.MT_SEQ_ISSUED) then
                            Result := 0
                          else
                            Result := 1
                        end
                        else
                          Result := 1;
                      end
                      else
                        Result := 1;
                    end
                    else
                      Result := 1;
                  end
                  else
                    Result := 1;
                end
                else
                  Result := 1
              end
              else
                Result := 1;
            end
            else
              Result := 1;
          end
          else
            Result := 1;
        end
//        else
//          Result := 1;
 //     end
      else
        Result := 1;
    end
    else
      Result := 1;
  end
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function SortPA(Item1, Item2: Pointer) : integer;
var
  MQMPA1 : PTMQMPA;
  MQMPA2 : PTMQMPA;
begin
  MQMPA1 := PTMQMPA(Item1);
  MQMPA2 := PTMQMPA(Item2);
  Result := -1;

  if MQMPA1.PA_PROD_REQ_NR <> MQMPA2.PA_PROD_REQ_NR then
  begin
    if MQMPA1.PA_PROD_REQ_NR > MQMPA2.PA_PROD_REQ_NR then Result := 1;
    exit;
  end;

  if MQMPA1.PA_SEQUENCE <> MQMPA2.PA_SEQUENCE then
  begin
    if MQMPA1.PA_SEQUENCE > MQMPA2.PA_SEQUENCE then Result := 1;
    exit;
  end;

  if MQMPA1.PA_PROD_CODE <> MQMPA2.PA_PROD_CODE then
  begin
    if MQMPA1.PA_PROD_CODE > MQMPA2.PA_PROD_CODE then Result := 1;
    exit;
  end;

  if MQMPA1.PA_NET_GROUP_Code <> MQMPA2.PA_NET_GROUP_Code then
  begin
    if MQMPA1.PA_NET_GROUP_Code > MQMPA2.PA_NET_GROUP_Code then Result := 1;
    exit;
  end;

  if MQMPA1.PA_ALL_REQ <> MQMPA2.PA_ALL_REQ then
  begin
    if MQMPA1.PA_ALL_REQ > MQMPA2.PA_ALL_REQ then Result := 1;
    exit;
  end;

  Result := 0;

end;

//----------------------------------------------------------------------------//

end.

