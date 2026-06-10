unit UMSchedList;

interface

uses
  classes,
  UMSchedContFunc;

type

  TMSchedList = class
    constructor Create(owner: TObject);
    destructor  Destroy; override;

    procedure AddLink(id: TSchedID);
    procedure AddLinkAtPosition(Position : Integer; id: TSchedID);
    function  GetLinkCount: integer;
    function  GetLink(i: integer): TSchedID;
    function  IndexOf(id: TSchedID): integer;
    function  FindSchedBeforeDate(Date : TDateTime) : TSchedId;
    function  FindSchedAfterDate(Date : TDateTime) : TSchedId;
    function  FindSchedInSpot(date : TDateTime) : TSchedId;
    procedure FindSchedInSpots(startTm, endTm: TDateTime; ObjList: TMSchedList);
    function  FindCoverSchedInSpot(ActiveDate: TDateTime; var id: TSchedID): boolean;
    function  IsIn(id: TSchedID): boolean;
    function  OneOnPlan: boolean;
    function Remove(id: TSchedID) : Boolean;
    procedure DeleteByIndex(Index : Integer);
    procedure SortList(SortFunc: TListSortCompare);
    procedure SortListGerericPlan(SortFunc: TListSortCompare);
    procedure BuildResList(ResList : TList);
    function  BuildWcList(ResList : TList) : TList;
    procedure ClearList;
    function  GetStartDate(i: integer) : TDateTime;
    function  GetEndDate(i: integer) : TDateTime;
    function  GetLowestStartConnectedReq : TDateTime;
    function  GetHighestEndConnectedReq: TDateTime;
    function  GetDateToCompleteQty(MinQty, QtyToStart: double; Res: TObject; AvoidObj: TSchedID): TDateTime;
    function  FindStartCover(ActiveDate: TDateTime; var StDate: TDateTime): boolean;
    procedure Insert(I : Integer;id: TSchedID);
    function  FindIdInList(id: TSchedID) : Integer;

  private
    m_owner: TObject;
    m_list:  TList;
    m_Sorted: boolean;
    m_SortedGeericPlan : boolean;
  end;

  function SortByReqStepSubStep(Item1, Item2: Pointer): Integer;

implementation

uses
  UMObjCont,
  UMWkCtr,
  SysUtils,
  UMSchedCont,
  UMActArea,
  UMRes;

var
  d_MinQty: double;

//----------------------------------------------------------------------------//

function SortOnMinQtyToProdDate(Item1, Item2: Pointer): Integer;
var
  ObjID1, ObjID2: TSchedID;
  Date1, Date2: TDateTime;
begin
  ObjID1 := TSchedID(Item1);
  ObjID2 := TSchedID(Item2);

  Date1 := p_sc.GetDateToCompleteQty(ObjID1, nil, d_MinQty);
  Date2 := p_sc.GetDateToCompleteQty(ObjID2, nil, d_MinQty);

  if Date1 > Date2 then
    Result := 1
  else
    if Date1 < Date2 then
      Result := -1
    else
      Result := 0;
end;

//----------------------------------------------------------------------------//

constructor TMSchedList.Create(owner: TObject);
begin
  m_owner := owner;
  m_list := TList.Create
end;

//----------------------------------------------------------------------------//

destructor TMSchedList.Destroy;
begin
  m_list.Free;
  Inherited Destroy;
end;

//----------------------------------------------------------------------------//

procedure TMSchedList.AddLink(id: TSchedID);
begin
  m_list.Add(Pointer(id));
  m_SortedGeericPlan := false;
end;

//----------------------------------------------------------------------------//

procedure TMSchedList.AddLinkAtPosition(Position : Integer; id: TSchedID);
begin
  m_list.Insert(Position, Pointer(id));
  m_SortedGeericPlan := false;
end;

//----------------------------------------------------------------------------//

function TMSchedList.GetLinkCount: integer;
begin
  Result := m_list.Count
end;

//----------------------------------------------------------------------------//

function TMSchedList.GetLink(i: integer): TSchedID;
begin
  Assert(i>=0);
  if i > (m_list.Count-1) then
    Result := CSchedIdNull
  else
    Result := TSchedId(m_list[i]);
end;

//----------------------------------------------------------------------------//

function TMSchedList.IndexOf(id: TSchedID): integer;
begin
  Result := m_list.IndexOf(Pointer(id))
end;

//----------------------------------------------------------------------------//

function TMSchedList.IsIn(id: TSchedID): boolean;
var
  i:   integer;
  ObjID: TSchedID;
begin
  Result := true;
  for i := 0 to m_list.Count-1 do
  begin
    ObjID := TSchedID(m_list[i]);
    if (ObjID = id) then exit
  end;
  Result := false
end;

//----------------------------------------------------------------------------//

function TMSchedList.OneOnPlan: boolean;
var
  i:   integer;
  ObjID: TSchedID;
  PlanInfo: TSQplanInfo;
begin
  Result := false;
  for i := 0 to m_list.Count-1 do
  begin
    ObjID := TSchedID(m_list[i]);
    p_sc.GetPlanInfo(ObjID, PlanInfo);
    if PlanInfo.isOnPlan then
    begin
      Result := true;
      break
    end;
  end;
end;

//----------------------------------------------------------------------------//

function TMSchedList.FindSchedBeforeDate(Date : TDateTime) : TSchedId;
var
  ObjID: TSchedID;
  i:  integer;
  TempDate : TDateTime;
begin
  Result := CSchedIDnull;
  for i := m_list.Count -1 downto 0 do
  begin
    ObjID := TSchedID(m_list[i]);
    TempDate := p_sc.GetSchedStart(ObjID);
    if TempDate >= Date then continue;
    Result := ObjID;
    break
  end
end;

//----------------------------------------------------------------------------//

function TMSchedList.FindSchedAfterDate(Date : TDateTime) : TSchedId;
var
  ObjID: TSchedID;
  i:  integer;
  TempDate : TDateTime;
begin
  Result := CSchedIDnull;
  for i := 0 to m_list.Count -1 do
  begin
    ObjID := TSchedID(m_list[i]);
    TempDate := p_sc.GetSchedEnd(ObjID);
    if TempDate <= Date then continue;
    Result := ObjID;
    break
  end
end;

//----------------------------------------------------------------------------//

function TMSchedList.FindSchedInSpot(date : TDateTime) : TSchedId;
var
  ObjID: TSchedID;
  i:  integer;
  DatesInfo: TSQDatesInfo;
begin
  Result := CSchedIDnull;
  for i := 0 to m_list.Count -1 do
  begin
    ObjID := TSchedID(m_list[i]);
    p_sc.GetDatesInfo(ObjID, DatesInfo);
    if (DatesInfo.endDate > date) and (DatesInfo.startDate < date) then
    begin
      Result := ObjID;
      break
    end;
  end
end;

//----------------------------------------------------------------------------//

procedure TMSchedList.FindSchedInSpots(startTm, endTm: TDateTime; ObjList: TMSchedList);
var
  ObjID: TSchedID;
  i:  integer;
  DatesInfo: TSQDatesInfo;
begin
//  SortList(OrderGrowing);
  for i := 0 to m_list.Count -1 do
  begin
    ObjID := TSchedID(m_list[i]);
    p_sc.GetDatesInfo(ObjID, DatesInfo);
    if (DatesInfo.endDate > startTm) and (DatesInfo.startDate < endTm) then
      ObjList.AddLink(ObjID);
  end
end;

//----------------------------------------------------------------------------//

function TMSchedList.FindCoverSchedInSpot(ActiveDate: TDateTime; var id: TSchedID): boolean;
var
  ObjID: TSchedID;
  i:  integer;
  DatesInfo: TSQDatesInfo;
begin
  Result := false;
  for i := 0 to m_list.Count -1 do
  begin
    ObjID := TSchedID(m_list[i]);
    p_sc.GetDatesInfo(ObjID, DatesInfo);
    if (DatesInfo.startDate < ActiveDate) and (DatesInfo.endDate > ActiveDate) then
    begin
      Result := true;
      Id := ObjID
    end;
  end
end;

//----------------------------------------------------------------------------//

function TMSchedList.Remove(id: TSchedID) : boolean;
var
  i:   integer;
  ObjID: TSchedID;
begin
  result := false;
  for i := 0 to m_list.Count-1 do
  begin
    ObjID := TSchedID(m_list[i]);
    if (ObjID = id) then
    begin
      m_list.Delete(i);
      Result := true;
      exit
    end
  end
end;

//----------------------------------------------------------------------------//

procedure TMSchedList.DeleteByIndex(Index : Integer);
begin
  m_list.Delete(Index);
end;

//----------------------------------------------------------------------------//

procedure TMSchedList.SortList(SortFunc: TListSortCompare);
begin
  m_list.Sort(SortFunc);
  m_sorted := true
end;

//----------------------------------------------------------------------------//

procedure TMSchedList.SortListGerericPlan(SortFunc: TListSortCompare);
begin
  if not m_SortedGeericPlan then
    m_list.Sort(SortFunc);
  m_SortedGeericPlan := true
end;

//----------------------------------------------------------------------------//

procedure TMSchedList.BuildResList(ResList : TList);
var
  ObjID: TSchedID;
  I : integer;

  function CheckInResList(ResList : TList; Res :TMqmRes) : boolean;
  var
    J: Integer;
  begin
    Result := false;
    for J := 0 to ResList.Count - 1 do
      if Res.p_ResCode = TMqmRes(ResList[J]).p_ResCode then
      begin
        Result := true;
        Exit
      end
  end;

begin
  p_sc.SetAllFlags([CSF_FilterJobsInDynamicGantt],[]);

  for I := 0 to m_list.Count-1 do
  begin
    ObjID := TSchedID(m_list[I]);
    if p_sc.GetExtLinkPtr(ObjID) <> nil then
      p_sc.SetFlags(ObjID,[],[CSF_FilterJobsInDynamicGantt])
    else
      continue;

    if not CheckInResList(ResList, TMqmRes(TMqmActArea(p_sc.GetExtLinkPtr(ObjID)).p_Res)) then
      ResList.add(TMqmRes(TMqmActArea(p_sc.GetExtLinkPtr(ObjID)).p_Res));
  end;

end;

//----------------------------------------------------------------------------//

function TMSchedList.BuildWcList(ResList : TList) : TList;
var
  I : Integer;
  ListWcStr : TStringList;
begin

  ListWcStr := TStringList.Create;
  if not assigned(ResList) then exit;
  Result := TList.create;

  for I := 0 to ResList.Count - 1 do
  begin
    if ListWcStr.IndexOf(TMqmWrkCtr((TMqmRes(ResList[I])).p_WrkCtr).p_WrkCtrCode) = -1 then
    begin
      ListWcStr.add(TMqmWrkCtr((TMqmRes(ResList[I])).p_WrkCtr).p_WrkCtrCode);
      Result.add(TMqmRes(ResList[I]).p_WrkCtr)
    end;
  end;
  ListWcStr.Free;
end;

//----------------------------------------------------------------------------//

procedure TMSchedList.ClearList;
begin
  m_list.Clear
end;

//----------------------------------------------------------------------------//

function TMSchedList.GetStartDate(i: integer) : TDateTime;
var
  ObjID: TSchedID;
  planInfo: TSQplanInfo;
begin
  Result := 0;
  ObjID := TSchedID(m_list[i]);
  p_sc.GetPlanInfo(ObjID, planInfo);
  if not PlanInfo.isOnPlan then
    Exit;
  Result := PlanInfo.StartDate
end;

//----------------------------------------------------------------------------//

function TMSchedList.GetEndDate(i: integer) : TDateTime;
var
  ObjID: TSchedID;
  planInfo: TSQplanInfo;
begin
  Result := 0;
  ObjID := TSchedID(m_list[i]);
  p_sc.GetPlanInfo(ObjID, planInfo);
  if not PlanInfo.isOnPlan then
    Exit;
  Result := PlanInfo.endDate
end;

//----------------------------------------------------------------------------//

function TMSchedList.GetLowestStartConnectedReq : TDateTime;
var
  i:   integer;
  ObjID: TSchedID;
  planInfo: TSQplanInfo;
begin
  Result := 0;
  for i := 0 to m_list.Count-1 do
  begin
    ObjID := TSchedID(m_list[i]);
    p_sc.GetPlanInfo(ObjID, planInfo);

    if not PlanInfo.isOnPlan then
      continue;

    if (planInfo.startDate < Result)
      or (Result = 0) then
        Result := planInfo.startDate
  end;
end;

//----------------------------------------------------------------------------//

function TMSchedList.GetHighestEndConnectedReq : TDateTime;
var
  i:   integer;
  ObjID: TSchedID;
  planInfo: TSQplanInfo;
begin
  Result := 0;
  for i := 0 to m_list.Count-1 do
  begin
    ObjID := TSchedID(m_list[i]);
    p_sc.GetPlanInfo(ObjID, planInfo);

    if not PlanInfo.isOnPlan then
      continue;

    if PlanInfo.endDate > Result then
      Result := PlanInfo.endDate
  end;
end;

//----------------------------------------------------------------------------//

function TMSchedList.GetDateToCompleteQty(MinQty, QtyToStart: double; Res: TObject; AvoidObj: TSchedID): TDateTime;
var
  i:   integer;
  ObjID, NextObjID: TSchedID;
  PlanInfo, NextPlanInfo: TSQplanInfo;
  TmpDate: TDateTime;
  TotQty, Qty: double;
begin
  Result := 0;
  d_MinQty := MinQty;
  m_list.Sort(SortOnMinQtyToProdDate);

  for i := 0 to m_list.Count-1 do
  begin
    ObjID := TSchedID(m_list[i]);
    p_sc.GetPlanInfo(ObjID, PlanInfo);
    if not PlanInfo.isOnPlan
    or (ObjID = AvoidObj) then
      continue;

    if QtyToStart < MinQty then
      Qty := MinQty
    else
      Qty := QtyToStart;

    //Get total qty at mimimum qty date
    Result := p_sc.GetDateToCompleteQty(ObjID, Res, Qty);
{
    TotQty :=  p_sc.GetStepQtyAtDate(ObjID, Result);
    if TotQty >= QtyToStart then
    begin
      Result := TmpDate;
      break
    end;
}
    if (i >= m_list.Count-1) then continue;

    NextObjID := TSchedID(m_list[i+1]);
    p_sc.GetPlanInfo(NextObjID, NextPlanInfo);
    if not NextPlanInfo.isOnPlan then
      continue;

    if (NextPlanInfo.startDate >= PlanInfo.startDate) then
    begin
      //Get total qty at next obj starting date
      TmpDate := p_sc.GetDateToCompleteQty(NextObjID, Res, MinQty);
      TotQty  := p_sc.GetJobQtyAtDate(ObjID, Res, TmpDate);
      if (TotQty >= QtyToStart) then
      begin
        Result := NextPlanInfo.startDate;
        break
      end;
    end else
    begin
      //get this obj qty at minimum qty date of next obj
      TotQty := p_sc.GetStepQtyAtDate(NextObjID, NextPlanInfo.startDate);
      if (TotQty >= QtyToStart) then
      begin
        Result := PlanInfo.startDate;
        break
      end;
    end;

  end;
end;

//----------------------------------------------------------------------------//

function TMSchedList.FindStartCover(ActiveDate: TDateTime; var StDate: TDateTime): boolean;
var
  i:  integer;
  ObjID: TSchedID;
  info: TSQPlanInfo;
begin
  Result := false;
  SortList(OrderGrowing);

  for i := GetLinkCount-1 downto 0 do
  begin
    ObjID := GetLink(i);
    p_sc.GetPlanInfo(ObjID, info);
    if (info.endDate <= ActiveDate) then
    begin
      Result := true;
      StDate := info.endDate;
      exit;
    end
  end;
end;

//----------------------------------------------------------------------------//

procedure TMSchedList.Insert(I : Integer;id: TSchedID);
begin
  m_list.Insert(I,Pointer(id));
end;

//----------------------------------------------------------------------------//

function TMSchedList.FindIdInList(id: TSchedID) : Integer;
var
  i: integer;
  Multiplier, NumberOfEntries : integer;
begin
  Result := -1;

  NumberOfEntries := m_list.Count;
  if NumberOfEntries = 0 then Exit;

  Multiplier := 1;
  while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    i := Multiplier - 1;

  while (Multiplier > 0) do
  begin

    if  (i < NumberOfEntries)
      and (TSchedID(m_list[i]) = id) then break;

    Multiplier := trunc(Multiplier / 2);

    if  (i < NumberOfEntries) and (TSchedID(m_list[i]) < id) then
      i := i + Multiplier
    else
      i := i - Multiplier;
  end;

  if Multiplier > 0 then
    Result := i;
end;

//----------------------------------------------------------------------------//

function SortByReqStepSubStep(Item1, Item2: Pointer): Integer;
var
  ObjID1, ObjID2: TSchedID;
  Req1, Req2 : string;
  Step1, step2 : Integer;
  SubStep1 , SubStep2 : Integer;
begin
  ObjID1 := TSchedID(Item1);
  ObjID2 := TSchedID(Item2);

  Req1 := p_sc.GetFldDescr(ObjID1, CSC_ProdReq, false);
  Req2 := p_sc.GetFldDescr(ObjID2, CSC_ProdReq, false);

  Step1 := StrToInt(p_sc.GetFldDescr(ObjID1, CSC_ProdStep, false));
  step2 := StrToInt(p_sc.GetFldDescr(ObjID2, CSC_ProdStep, false));

  SubStep1 := StrToInt(p_sc.GetFldDescr(ObjID1, CSC_ProdSubStep, false));
  SubStep2 := StrToInt(p_sc.GetFldDescr(ObjID2, CSC_ProdSubStep, false));

  if Req1 < Req2 then
    Result := -1
  else if Req1 > Req2 then
    Result := 1
  else
  begin
    if Step1 < Step2 then
        Result := -1
    else if Step1 > Step2 then
        Result := 1
    else
    begin
      if SubStep1 < SubStep2 then
         Result := -1
      else if SubStep1 > SubStep2 then
         Result := 1
      else
        Result := 0;
    end;
  end;
end;


end.

