unit UMGenericSchedulePrevStep;

interface

uses Classes, UMSchedContFunc, UMSchedList, UGshiftCal,UMSchedCont;

type

  TSchedListId = array of TMSchedList;

  TMqmWrkCtrGen = class
    constructor CreateWrkCtrGen(Code: string; CalCode : string; NumberOfMachine : integer);
    destructor  Destroy; override;
    private
      m_WcCode  : string;
      m_NumberOfMachine : Integer;
      m_ResArray : TSchedListId;
      m_Cal : TPGCALshift;
  end;


  procedure UnScheduleGenericPlanByWc(ID : TSchedId; Wc : string);
  procedure UnScheduleGenericPlan(ID : TSchedId);
  function  ScheduleOnBestPosition(Id : TSchedId; var PlanInfo : TSQplanInfo; IDStartDate : TDateTime; wkc : string; Duration,leadTime : double; UnscheduleFirst : boolean) : boolean;
  function  FindBestPositionGenericPlan(Id : TSchedId; IDStartDate : TDateTime; wkc : string; Duration,leadTime : double;
                             out  OutStartDate, OutEndDate : TDateTime; Out OutMachineNumber : Integer; out IndexWc : Integer) : boolean;
  function  SortByStartDate(Item1, Item2: Pointer): integer;
  procedure ScheduleOnSpecificPosition(Id : TSchedId; PlanInfo : TSQplanInfo);
  procedure OrganizeGenericPlanScheduled;
  procedure ReBuildGenericPlanScheduled;
  procedure PrintGenericPlanScheduled(FileName : String);

implementation

{ TMqmWrkCtrGen }

uses UMObjCont, UMAutoSchedCfg, FMAutoSched, UMCommon, DMsrvPc, UMTblDesc, SysUtils, UGbaseCal, UMpgCal, UMglobal;

type
  TGenericPlanSchedInfo = record
    Id                  : TSchedId;
    Start               : TDateTime;
    GenericPlanWc       : string;
    GenericPlanDur      : double;
    GenericPlanleadTime : double;
  end;
  PTGenericPlanSchedInfo = ^TGenericPlanSchedInfo;

var
  m_ListOfWrkCtrGen : TList;

//----------------------------------------------------------------------------//

function SortByStart(Item1, Item2: Pointer): integer;
var
  MQMPR1 : PTGenericPlanSchedInfo;
  MQMPR2 : PTGenericPlanSchedInfo;
begin
  MQMPR1 := PTGenericPlanSchedInfo(Item1);
  MQMPR2 := PTGenericPlanSchedInfo(Item2);
  if MQMPR1.Start = MQMPR2.Start then
  begin
    if MQMPR1.Id < MQMPR2.Id then
      Result := -1
    else if (MQMPR1.Id > MQMPR2.Id) then
      Result := 1
    else
      Result := 0;
  end
  else
  begin
    if  MQMPR1.Start < MQMPR2.Start then
      Result := -1
    else
      Result := 1;
  end;
end;

//----------------------------------------------------------------------------//

procedure OrganizeGenericPlanScheduled;
var
  I, J : Integer;
  ResListId : TMSchedList;
  WrkCtrGen : TMqmWrkCtrGen;
begin
  for I := 0 to m_ListOfWrkCtrGen.Count - 1 do
  begin
    WrkCtrGen := TMqmWrkCtrGen(m_ListOfWrkCtrGen[I]);
    for J := Low(WrkCtrGen.m_ResArray) to High(WrkCtrGen.m_ResArray) do
    begin
      ResListId := WrkCtrGen.m_ResArray[J];
      ResListId.SortListGerericPlan(SortByStartDate);
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure RebuildGenericPlanScheduled;
var
  I, J, G : Integer;
  ResListId : TMSchedList;
  PGenericPlanSchedInfo : PTGenericPlanSchedInfo;
  GenericPlanList : TList;
  PlanInfo : TSQplanInfo;
  WrkCtrGen : TMqmWrkCtrGen;
  Id : TSchedId;
begin
  GenericPlanList := TList.Create;
  for I := 0 to m_ListOfWrkCtrGen.Count - 1 do
  begin
    WrkCtrGen := TMqmWrkCtrGen(m_ListOfWrkCtrGen[I]);
    for J := Low(WrkCtrGen.m_ResArray) to High(WrkCtrGen.m_ResArray) do
    begin
      ResListId := WrkCtrGen.m_ResArray[J];
      for G := ResListId.GetLinkCount - 1 downto 0 do
      begin
        Id := ResListId.GetLink(G);
        p_sc.GetPlanInfo(Id ,PlanInfo);
        new(PGenericPlanSchedInfo);
        PGenericPlanSchedInfo.Id := Id;
        PGenericPlanSchedInfo.Start := PlanInfo.startDate;
        PGenericPlanSchedInfo.GenericPlanWc := PlanInfo.GenericPlanWC;
        PGenericPlanSchedInfo.GenericPlanDur  := PlanInfo.GenericPlanDur;
        PGenericPlanSchedInfo.GenericPlanleadTime := PlanInfo.GenericPlanLeadTime;
        GenericPlanList.Add(PGenericPlanSchedInfo);
        ResListId.DeleteByIndex(G);
      end;
    end;
    GenericPlanList.Sort(SortByStart);
    for G := 0 to GenericPlanList.Count - 1 do
    begin
      PGenericPlanSchedInfo := PTGenericPlanSchedInfo(GenericPlanList[G]);
      if ScheduleOnBestPosition(PGenericPlanSchedInfo.Id, PlanInfo , PGenericPlanSchedInfo.Start, trim(PGenericPlanSchedInfo.GenericPlanWc), PGenericPlanSchedInfo.GenericPlanDur , PGenericPlanSchedInfo.GenericPlanLeadTime, false) then
        p_sc.SetGenericInfo(PGenericPlanSchedInfo.Id, PlanInfo);
    end;
    for G := GenericPlanList.Count - 1 downto 0 do
      dispose(PTGenericPlanSchedInfo(GenericPlanList[G]));
    GenericPlanList.Clear;
  end;

  GenericPlanList.free;

end;



//----------------------------------------------------------------------------//

procedure PrintGenericPlanScheduled(FileName : String);
var
  I, J, G : Integer;
  ResListId : TMSchedList;
  PlanInfo : TSQplanInfo;
  WrkCtrGen : TMqmWrkCtrGen;
  Id : TSchedId;
  LogStringList : TStringList;
  Infoline : String;
begin
  LogStringList := TStringList.create;
  for I := 0 to m_ListOfWrkCtrGen.Count - 1 do
  begin
    WrkCtrGen := TMqmWrkCtrGen(m_ListOfWrkCtrGen[I]);
    for J := Low(WrkCtrGen.m_ResArray) to High(WrkCtrGen.m_ResArray) do
    begin
      ResListId := WrkCtrGen.m_ResArray[J];
      ResListId.SortListGerericPlan(SortByStartDate);
      for G := 0 to ResListId.GetLinkCount - 1 do
      begin
       Id := ResListId.GetLink(G);
       p_sc.GetPlanInfo(Id ,PlanInfo);
       Infoline := '';
       Infoline := Infoline + ' Id:' + intToStr(Id);
       Infoline := Infoline + ' Start:' + DateTimeToStr(PlanInfo.GenericPlanStartDate);
       Infoline := Infoline + ' End:' + DateTimeToStr(PlanInfo.GenericPlanEndDate);
       Infoline := Infoline + ' PlanWC' + PlanInfo.GenericPlanWC;
       Infoline := Infoline + ' Dur:' + FloatToStr(PlanInfo.GenericPlanDur);
       Infoline := Infoline + ' Lead:' + FloatToStr(PlanInfo.GenericPlanLeadTime);
       Infoline := Infoline + ' Mac:' + IntToStr(PlanInfo.GenericPlanMachineNum);
       Infoline := Infoline + ' JobStart:' + DateTimeToStr(PlanInfo.startDate);
       LogStringList.Add(Infoline);
      end;
    end;
  end;

  if LogStringList.Count > 0 then
  begin
    CreateDir(LocAppGlobals.AppDir + '\' + 'AutoSeqLog');
    LogStringList.SaveToFile(LocAppGlobals.AppDir + '\AutoSeqLog\' + FileName + '.txt' );
  end;

  LogStringList.Clear;
  LogStringList.Free;

end;


//----------------------------------------------------------------------------//

function SortByStartDate(Item1, Item2: Pointer): integer;
var
  ObjID1, ObjID2: TSchedID;
  DatesGenInfo1, DatesGenInfo2 : TSQplanInfo;
begin
  ObjID1 := TSchedID(Item1);
  ObjID2 := TSchedID(Item2);
  p_sc.GetJobInfo(ObjID1, DatesGenInfo1);
  p_sc.GetJobInfo(ObjID2, DatesGenInfo2);
  if DatesGenInfo1.GenericPlanStartDate > DatesGenInfo2.GenericPlanStartDate then
    Result := 1
  else if DatesGenInfo1.GenericPlanStartDate < DatesGenInfo2.GenericPlanStartDate then
    Result := -1
  else
    result := 0;
end;

//----------------------------------------------------------------------------//

function AddWorkCenter(WkcCode : string) : Integer;
var
  I : Integer;
  WrkCtrGen : TMqmWrkCtrGen;
  tbInfoWkc : ^TTblInfo;
  qry : TMqmQuery;
  SqlStr : string;
  CalCode : string;
  NumberOfMachine : Integer;
begin
  Result := -1;
  CalCode := '';
  NumberOfMachine := 0;
  tbInfoWkc := @tblInfo[tbl_wkc];
  for I := 0 to m_ListOfWrkCtrGen.Count - 1 do
  begin
    WrkCtrGen := TMqmWrkCtrGen(m_ListOfWrkCtrGen[I]);
    if WkcCode = WrkCtrGen.m_WcCode then
    begin
      if Assigned(WrkCtrGen.m_Cal) and (WrkCtrGen.m_NumberOfMachine > 0) then
        Result := I;
      Exit;
    end;
  end;

  qry := CreateQuery(Main_DB);

  with qry do
  begin
    SQL.Clear;
    SqlStr := 'select * ';
    SqlStr := SqlStr + ' from ' + tbInfoWkc.GetTableName;
    SqlStr := SqlStr + ' Where ' + CreateFld(tbInfoWkc.pfx, fli_wkCtrCode) + '=''' + WkcCode + '''';
    SqlStr := SqlStr + AND_IDF_Condition(CreateFld(tbInfoWkc.pfx, fli_identifier));
    SQL.Text := SqlStr;
    open;
    if not Eof then
    begin
      CalCode := FieldByName(CreateFld(tbInfoWkc.pfx, fli_CalCod)).AsString;
      NumberOfMachine := FieldByName(CreateFld(tbInfoWkc.pfx, fli_NumResPlan)).AsInteger;
    end;
    WrkCtrGen := TMqmWrkCtrGen.CreateWrkCtrGen(WkcCode, CalCode, NumberOfMachine);
    if Assigned(WrkCtrGen.m_Cal) and (WrkCtrGen.m_NumberOfMachine > 0) then
      Result := m_ListOfWrkCtrGen.Add(WrkCtrGen)
    else
      m_ListOfWrkCtrGen.Add(WrkCtrGen);
  end;
  qry.Free;
end;

//----------------------------------------------------------------------------//

procedure UnScheduleGenericPlanByWc(ID : TSchedId; Wc : string);
var
  I, J : Integer;
  WrkCtrGen : TMqmWrkCtrGen;
  ResListId : TMSchedList;
begin

  for I := 0 to m_ListOfWrkCtrGen.Count - 1 do
  begin
    WrkCtrGen := TMqmWrkCtrGen(m_ListOfWrkCtrGen[I]);
    for J := Low(WrkCtrGen.m_ResArray) to High(WrkCtrGen.m_ResArray) do
    begin
      ResListId := WrkCtrGen.m_ResArray[J];
      if ResListId.IsIn(Id) then
      begin
        ResListId.Remove(Id);
        Exit
      end;
    end;
  end;

end;

//----------------------------------------------------------------------------//

procedure UnScheduleGenericPlan(ID : TSchedId);
var
  Index : Integer;
//  I, J : Integer;
  I : integer;
  IdRemoved : boolean;
  WrkCtrGen : TMqmWrkCtrGen;
  ResList : TMSchedList;
  PlanInfo : TSQplanInfo;
begin
  p_sc.GetPlanInfo(Id, PlanInfo);
  if not PlanInfo.GenericPlan then exit;

  Index := AddWorkCenter(PlanInfo.GenericPlanWC);
  if Index = -1 then
   Exit;

  WrkCtrGen := TMqmWrkCtrGen(m_ListOfWrkCtrGen[Index]);
  if not Assigned(WrkCtrGen) then
    Exit;

  ResList := WrkCtrGen.m_ResArray[PlanInfo.GenericPlanMachineNum];
  IdRemoved := false;
  if Assigned(ResList) and (ResList.GetLinkCount > 0) then
  begin
    if ResList.Remove(Id) then
      IdRemoved := true;
  end;

  if not IdRemoved then
  begin
    for I := Low(WrkCtrGen.m_ResArray) to High(WrkCtrGen.m_ResArray) do
    begin
      if I = PlanInfo.GenericPlanMachineNum then continue;
      ResList := WrkCtrGen.m_ResArray[I];
      if Assigned(ResList) and (ResList.GetLinkCount > 0) then
        ResList.Remove(Id);
    end;
  end;

end;

//----------------------------------------------------------------------------//

function SearchIdInWcList(Id : TSchedId) : boolean;
var
  I, J : Integer;
  WrkCtrGen : TMqmWrkCtrGen;
  ResListId : TMSchedList;
begin
  Result := false;
  for I := 0 to m_ListOfWrkCtrGen.Count - 1 do
  begin
    WrkCtrGen := TMqmWrkCtrGen(m_ListOfWrkCtrGen[I]);
    for J := Low(WrkCtrGen.m_ResArray) to High(WrkCtrGen.m_ResArray) do
    begin
      ResListId := WrkCtrGen.m_ResArray[J];
      if ResListId.IsIn(Id) then
      begin
        Result := true;
        Exit
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

function ScheduleOnBestPosition(Id : TSchedId; var PlanInfo : TSQplanInfo; IDStartDate : TDateTime; wkc : string; Duration,leadTime : double; UnscheduleFirst : boolean) : boolean;
var
  StartDate, EndDate : TDateTime;
  MachineNumber , IndexWc : Integer;
  WrkCtrGen : TMqmWrkCtrGen;
  ListId : TMSchedList;
begin
  Result := false;
  if UnscheduleFirst then
    UnScheduleGenericPlan(Id)
  else if SearchIdInWcList(Id) then exit;

  Result := FindBestPositionGenericPlan(Id, IDStartDate,wkc,Duration,leadTime,StartDate,EndDate,MachineNumber,IndexWc);
  if not result then
  begin
    if wkc = '' then
    begin
      PlanInfo.GenericPlanWC := '';
      PlanInfo.GenericPlanDur := 0;
      PlanInfo.GenericPlanLeadTime := 0;
      PlanInfo.GenericPlanMachineNum := 0;
      PlanInfo.GenericPlanStartDate  := 0;
      PlanInfo.GenericPlanEndDate    := 0;
    end;
    exit;
  end;

  WrkCtrGen := TMqmWrkCtrGen(m_ListOfWrkCtrGen[IndexWc]);

  ListId := WrkCtrGen.m_ResArray[MachineNumber];
  ListId.AddLink(Id);
//  ListId.SortList(SortByStartDate);

  PlanInfo.GenericPlanWC := wkc;
  PlanInfo.GenericPlanDur := Duration;
  PlanInfo.GenericPlanLeadTime := leadTime;
  PlanInfo.GenericPlanMachineNum := MachineNumber;
  PlanInfo.GenericPlanStartDate  := StartDate;
  PlanInfo.GenericPlanEndDate    := EndDate;

end;

//----------------------------------------------------------------------------//

procedure ScheduleOnSpecificPosition(Id : TSchedId; PlanInfo : TSQplanInfo);
var
  IndexWc   : Integer;
  WrkCtrGen : TMqmWrkCtrGen;
  ListId    : TMSchedList;
begin
  IndexWc := AddWorkCenter(PlanInfo.GenericPlanWC);
  if IndexWc = -1 then exit;

  WrkCtrGen := TMqmWrkCtrGen(m_ListOfWrkCtrGen[IndexWc]);
  if not Assigned(WrkCtrGen) then Exit;
  if not Assigned(WrkCtrGen.m_Cal) then Exit;

  WrkCtrGen := TMqmWrkCtrGen(m_ListOfWrkCtrGen[IndexWc]);

  ListId := WrkCtrGen.m_ResArray[PlanInfo.GenericPlanMachineNum];
  ListId.AddLink(Id);
 // ListId.SortList(SortByStartDate);
end;

//----------------------------------------------------------------------------//

function FindBestPositionGenericPlan(Id : TSchedId; IDStartDate : TDateTime; wkc : string; Duration,leadTime : double;
                             out  OutStartDate, OutEndDate : TDateTime; Out OutMachineNumber : Integer; out IndexWc : Integer) : boolean;
var
  I , J, BestMachine : Integer;
  LowLimitDate, RequestedEndDate, RequestedStartDate : TDateTime;
  FieldVal : variant;
  dataType: CBinColValType;
  WrkCtrGen : TMqmWrkCtrGen;
  ResListId : TMSchedList;
  TempId : TSchedId;
  PlanInfoTemp : TSQplanInfo;
  BestEndDate, BestStartDate, CurrentEndDate, CurrentStartDate : TDateTime;
  RelevantJobExist : boolean;
  NowDateTime : TDateTime;
begin
  Result := false;
  if wkc = '' then exit;
  if Duration <=0 then exit;

  BestEndDate := 0;
  BestMachine := -1;
  BestStartDate := 0;
  IndexWc := AddWorkCenter(wkc);
  if IndexWc = -1 then exit;

  WrkCtrGen := TMqmWrkCtrGen(m_ListOfWrkCtrGen[IndexWc]);
  if not Assigned(WrkCtrGen) then Exit;

  if not Assigned(WrkCtrGen.m_Cal) then Exit;

  p_sc.GetFldValue(Id, CSC_PrvHighestDate, FieldVal, dataType);
  LowLimitDate := FieldVal;

  if Assigned(FAutoSched) then
    NowDateTime := AutoSchedCfg.m_NowDateTime
  else
    NowDateTime := now;

  if (LowLimitDate < NowDateTime) then
    LowLimitDate := NowDateTime;

  RequestedEndDate := IDStartDate - (leadTime / 60 / 24);

  if RequestedEndDate <= 0 then
    RequestedStartDate := 0
  else
    WrkCtrGen.m_Cal.OfsByWH(-(Duration)/60, false, RequestedEndDate, RequestedStartDate, nil);

  if RequestedStartDate >= LowLimitDate then
  begin
    for I := Low(WrkCtrGen.m_ResArray) to High(WrkCtrGen.m_ResArray) do
    begin
      ResListId := WrkCtrGen.m_ResArray[I];
      ResListId.SortListGerericPlan(SortByStartDate);
      if ResListId.GetLinkCount = 0 then
      begin
        if BestEndDate < RequestedEndDate then
        begin
          BestEndDate := RequestedEndDate;
          BestStartDate := RequestedStartDate;
          BestMachine := I;
        end;
        Continue;
      end;

      CurrentEndDate := RequestedEndDate;
      CurrentStartDate := RequestedStartDate;
      for J := ResListId.GetLinkCount - 1 Downto 0 do
      begin
        TempId := ResListId.GetLink(J);
        p_sc.GetPlanInfo(TempId, PlanInfoTemp);
        if (PlanInfoTemp.GenericPlanEndDate <= CurrentStartDate)
        and (CurrentEndDate <= RequestedEndDate) then
        begin
          if BestEndDate < CurrentEndDate then
          begin
            BestEndDate := CurrentEndDate;
            BestStartDate := CurrentStartDate;
            BestMachine := I;
          end;
          Break;
        end;
        CurrentEndDate := PlanInfoTemp.GenericPlanStartDate;
        WrkCtrGen.m_Cal.OfsByWH(-(Duration)/60, false, CurrentEndDate, CurrentStartDate, nil);
        if (CurrentStartDate < LowLimitDate) then break;
        if (J = 0) and (BestEndDate < CurrentEndDate) and
           (CurrentEndDate <= RequestedEndDate) then // Last job we searched
        begin
            BestEndDate := CurrentEndDate;
            BestStartDate := CurrentStartDate;
            BestMachine := I;
        end;
      end;

    end;
  end;

  if BestMachine > -1 then
  begin
    OutStartDate := BestStartDate;
    OutEndDate := BestEndDate;
    OutMachineNumber := BestMachine;
    result := true;
    exit;
  end;

  RequestedStartDate := LowLimitDate;
  WrkCtrGen.m_Cal.OfsByWH((Duration)/60, true, RequestedStartDate, RequestedEndDate, nil);

  for I := Low(WrkCtrGen.m_ResArray) to High(WrkCtrGen.m_ResArray) do
  begin
    ResListId := WrkCtrGen.m_ResArray[I];
    ResListId.SortListGerericPlan(SortByStartDate);
    if (ResListId.GetLinkCount = 0) then
    begin
      if (BestMachine = -1) or (BestEndDate > RequestedEndDate) then
      begin
        BestEndDate   := RequestedEndDate;
        BestStartDate := RequestedStartDate;
        BestMachine   := I;
      end;
      break;
    end;

    CurrentStartDate := RequestedStartDate;
    CurrentEndDate := RequestedEndDate;
    RelevantJobExist := false;
    for J := 0 to ResListId.GetLinkCount - 1 do
    begin
      TempId := ResListId.GetLink(J);
      p_sc.GetPlanInfo(TempId, PlanInfoTemp);

      if PlanInfoTemp.GenericPlanEndDate <= RequestedStartDate then continue;
      RelevantJobExist := true;

      if PlanInfoTemp.GenericPlanStartDate >= CurrentEndDate then
      begin
        if (BestMachine = -1) or (BestEndDate > CurrentEndDate) then
        begin
          BestEndDate   := CurrentEndDate;
          BestStartDate := CurrentStartDate;
          BestMachine   := I;
        end;
        break;
      end;
      CurrentStartDate := PlanInfoTemp.GenericPlanEndDate;
      WrkCtrGen.m_Cal.OfsByWH((Duration)/60, false, CurrentStartDate, CurrentEndDate, nil);
      if  (J = (ResListId.GetLinkCount - 1))
      and ((BestMachine = -1) or (BestEndDate > CurrentEndDate)) then // Last job we search
      begin
        BestEndDate   := CurrentEndDate;
        BestStartDate := CurrentStartDate;
        BestMachine   := I;
      end;
    end;

    if not RelevantJobExist and ((BestMachine = -1) or (BestEndDate > CurrentEndDate)) then
    begin
       BestEndDate   := CurrentEndDate;
       BestStartDate := CurrentStartDate;
       BestMachine   := I;
    end;

  end;

  OutStartDate := BestStartDate;
  OutEndDate := BestEndDate;
  OutMachineNumber := BestMachine;
  Result := true
end;

//----------------------------------------------------------------------------//

constructor TMqmWrkCtrGen.CreateWrkCtrGen(Code: string; CalCode : string; NumberOfMachine : Integer);
var
  I : Integer;
begin
  inherited Create;
  m_WcCode := Code;
  if (trim(CalCode) <> '') then
    m_Cal := TPGCALshift(ObjPGCAL_ByKey(CalCode, TPGCALObjMqm));
  m_NumberOfMachine := NumberOfMachine;
  SetLength(m_ResArray, m_NumberOfMachine);
  for I := Low(m_ResArray) to High(m_ResArray) do
     m_ResArray[I] := TMSchedList.Create(self);
end;

//----------------------------------------------------------------------------//

destructor TMqmWrkCtrGen.Destroy;
var
  I : Integer;
begin
  for I := Low(m_ResArray) to High(m_ResArray) do
    m_ResArray[I].Free;
  inherited Destroy;
end;

//----------------------------------------------------------------------------//

procedure FreeWrkCtrGenList;
var
  I : Integer;
begin
  for I := m_ListOfWrkCtrGen.Count - 1 downto 0 do
     TMqmWrkCtrGen(m_ListOfWrkCtrGen[I]).Free;
  m_ListOfWrkCtrGen.Free;
end;

//----------------------------------------------------------------------------//

initialization
  m_ListOfWrkCtrGen := TList.Create;

finalization
  FreeWrkCtrGenList;

end.

