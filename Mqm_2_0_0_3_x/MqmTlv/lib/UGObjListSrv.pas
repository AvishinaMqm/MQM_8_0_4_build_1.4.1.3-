unit UGObjListSrv;

interface

uses
  classes,
  UMSchedCont,
  UMSchedList,
  UMSchedContFunc, UMbinGrid, UMbinGridMaterial ,Sysutils, Variants;

type

  TObjLstChg = (TOL_chg, TOL_added, TOL_removed, TOL_deleSrv, TOL_Sorted,
                TOL_chgFiltr, TOL_Refresh, TOL_UpdateWcPlan, TOL_ClearGroupedByFieldList, TOL_SortListGroupedByFieldId,
                TOL_SavedShowGroupLinesInBin, TOL_UpdatedSavedShowGroupLinesInBin, TOL_SavedSelectedIdsInListAndClearSelected, TOL_UpdateSelectedIdsFromList);

  TFncNotyChg = procedure (ServObj: TObject; chg: TObjLstChg);
  TFncFilter  = function  (id: TSchedID; ServObj: TObject; WcProcAllowedList : TList): boolean;

  TSortParam = record
    sortFnc: TListSortCompare;
    sortPtr: pointer;
  end;

  TObjListSrv = class(TObject)
  public
    constructor Create;
    destructor  Destroy; override;
    function    ClientRegister(ServObj: TObject; fnc: TFncNotyChg; filt: TFncFilter): TMSchedList;
    procedure   ClientUnregister(ServObj: TObject);
    procedure   MainRemoved(id: TSchedID);
//    procedure   MainAdded(id: TSchedID);
    procedure   MainRemovedAll(PlanObj: TObject);
//    procedure   MainAddedAll(lst: TMSchedList);
    procedure   MainOneAddedAll(ServObj: TObject; sc : TMSchedCont; ToSort : Boolean);
    procedure   MainOneAddedAllChangeTab(ServObj: TObject; sc: TMSchedCont);
    procedure   MainUpdateFilterAndSortTab(ServObj: TObject; sc: TMSchedCont);
    procedure   SetSortIndex(ServObj: TObject; NewIndex: integer);
    procedure   SetAllSortIndex(NewIndex: integer);
    procedure   Sort(ServObj: TObject);
    procedure   AddSortFnc(ServObj: TObject; Index: integer;
                           fnc: TListSortCompare; Ptr: pointer);
  private
    m_lst: TList;

    function ClientPos(ServObj: TObject): integer;
  end;

  function GetSortPtr: pointer;

const
  SORT_NR = 1;

implementation

uses UMglobal, FMbin, UMWkCtr, UMBinPanel;
type

  TListRec = record
    ServObj:   TObject;
    ObjLst:    TMSchedList;
    cnt:       integer;
    noty:      TFncNotyChg;
    filt:      TFncFilter;
    SortIndex: integer;
    SortArr: Array [0..SORT_NR] of TSortParam;
  end;
  PTListRec = ^TListRec;

var
  s_sortPtr: pointer;

//----------------------------------------------------------------------------//

constructor TObjListSrv.Create;
begin
  m_lst := TList.Create
end;

//----------------------------------------------------------------------------//

destructor TObjListSrv.Destroy;
var
  i:    integer;
  pLst: PTListRec;
begin
  for i := 0 to m_lst.Count-1 do
  begin
    pLst := PTListRec(m_lst[i]);
    pLst.noty(pLst.ServObj, TOL_deleSrv);
    Dispose(pLst)
  end;
  m_lst.Free
end;

//----------------------------------------------------------------------------//

function GetSortPtr: pointer;
begin
  Result := s_sortPtr
end;

//----------------------------------------------------------------------------//

function TObjListSrv.ClientPos(ServObj: TObject): integer;
var
  i:    integer;
  pLst: PTListRec;
begin
  Result := -1;
  for i := 0 to m_lst.Count-1 do
  begin
    pLst := PTListRec(m_lst[i]);
    if pLst.ServObj = ServObj then
    begin
     Result := i;
     exit
    end
  end
end;

//----------------------------------------------------------------------------//

function TObjListSrv.ClientRegister(ServObj: TObject; fnc: TFncNotyChg; filt: TFncFilter): TMSchedList;
var
  pLst: PTListRec;
  i:    integer;
begin
  Assert(ClientPos(ServObj) = -1);

  New(pLst);
  pLst.ServObj := ServObj;
  pLst.ObjLst  := TMSchedList.Create(self);
  pLst.cnt  := 0;
  pLst.noty := fnc;
  pLst.filt := filt;
  pLst.SortIndex := 0;

  for i := 0 to SORT_NR do
  begin
    pLst.SortArr[i].sortFnc := nil;
    pLst.SortArr[i].sortPtr := nil
  end;
  m_lst.Add(pLst);

  Result := pLst.ObjLst
end;

//----------------------------------------------------------------------------//

procedure TObjListSrv.ClientUnregister(ServObj: TObject);
var
  pos: integer;
begin
  pos := ClientPos(ServObj);
  Assert(pos <> -1 );
  Dispose(PTListRec(m_lst[pos]));
  m_lst.Delete(pos)
end;

//----------------------------------------------------------------------------//

procedure TObjListSrv.AddSortFnc(ServObj: TObject; Index: integer;
                                 fnc: TListSortCompare; Ptr: pointer);
var
  i: integer;
  pLst: PTListRec;
begin
  i := ClientPos(ServObj);
  pLst := PTListRec(m_lst[i]);

  pLst.SortArr[Index].sortPtr := Ptr;
  pLst.SortArr[Index].sortFnc := fnc;
end;

//----------------------------------------------------------------------------//

procedure TObjListSrv.Sort(ServObj: TObject);
var
  pLst: PTListRec;
begin
  pLst := PTListRec(m_lst[ClientPos(ServObj)]);

  s_sortPtr := pLst.SortArr[pLst.SortIndex].sortPtr;
  if Assigned(pLst.SortArr[pLst.SortIndex].sortFnc) then
    pLst.ObjLst.SortList(pLst.SortArr[pLst.SortIndex].sortFnc);
end;

//----------------------------------------------------------------------------//

procedure TObjListSrv.SetSortIndex(ServObj: TObject; NewIndex: integer);
var
  i: integer;
  pLst: PTListRec;
begin
  i := ClientPos(ServObj);
  pLst := PTListRec(m_lst[i]);
  pLst.SortIndex := NewIndex;

  pLst.noty(pLst.ServObj, TOL_chg);
  sort(pLst.ServObj);
  pLst.noty(pLst.ServObj, TOL_Refresh)
end;

//----------------------------------------------------------------------------//

procedure TObjListSrv.SetAllSortIndex(NewIndex: integer);
var
  i: integer;
  pLst: PTListRec;
begin
  for i := 0 to m_lst.Count-1 do
  begin
    pLst := PTListRec(m_lst[i]);
    pLst.SortIndex := NewIndex;
    pLst.noty(pLst.ServObj, TOL_Sorted);
    sort(pLst.ServObj);
    pLst.noty(pLst.ServObj, TOL_Sorted)
  end
end;

//----------------------------------------------------------------------------//

procedure TObjListSrv.MainRemoved(id: TSchedID);
var
  i:    integer;
  pLst: PTListRec;
begin
  for i := 0 to m_lst.Count-1 do
  begin
    pLst := PTListRec(m_lst[i]);
    pLst.ObjLst.Remove(id);
{sav
    for k := 0 to pLst.ObjLst.GetLinkCount-1 do
      if TObject(pLst.ObjLst[k]) = PlanObj then
      begin
        pLst.ObjLst.Delete(k);
        pLst.noty(pLst.ServObj, TOL_removed);
        break
      end
}
  end
end;

//----------------------------------------------------------------------------//

{procedure TObjListSrv.MainAdded(id: TSchedID);
var
  i:    integer;
  pLst: PTListRec;
  WcProcAllowedList : TList;
  BuildFirstTime : boolean;
begin
  for i := 0 to m_lst.Count-1 do
  begin
    pLst := PTListRec(m_lst[i]);
    if (not Assigned(pLst.filt)) or pLst.filt(id, pLst.ServObj, WcProcAllowedList, BuildFirstTime) then
    begin
      pLst.ObjLst.AddLink(id);
      sort(pLst.ServObj);
      pLst.noty(pLst.ServObj, TOL_added)
    end
  end
end;         }

//----------------------------------------------------------------------------//

procedure TObjListSrv.MainRemovedAll(PlanObj: TObject);
var
  i:    integer;
  pLst: PTListRec;
begin
  for i := 0 to m_lst.Count - 1 do
  begin
    pLst := PTListRec(m_lst[i]);
    pLst.ObjLst.ClearList;
    pLst.noty(pLst.ServObj, TOL_deleSrv)
  end
end;

//----------------------------------------------------------------------------//

{procedure TObjListSrv.MainAddedAll(lst: TMSchedList);
var
  i,k:  integer;
  pLst: PTListRec;
  id: TSchedID;
  WcProcAllowedList : TList;
  BuildFirstTime : boolean;
begin
  for i := 0 to m_lst.Count-1 do
  begin
    pLst := PTListRec(m_lst[i]);
    pLst.ObjLst.ClearList;

    for k := 0 to lst.GetLinkCount-1 do
    begin
      id := lst.GetLink(k);
      if (not Assigned(pLst.filt)) or pLst.filt(id, pLst.ServObj, WcProcAllowedList, BuildFirstTime) then
        pLst.ObjLst.AddLink(id);
    end;
    sort(pLst.ServObj);
    pLst.noty(pLst.ServObj, TOL_added)
  end
end; }

//----------------------------------------------------------------------------//

function sortBINMat(Item1, Item2: Pointer): integer;
type
 TColNature = record
   Desc   : Boolean;
   IsDate : Boolean;
 end;
 PTColNature = ^TColNature;
 TBINIds = record
   id    : TSchedId;
   Visible : CScBinView;
   ColValuesList : TList;
   ColumnSortedCount : Integer;
   ColNatureList : TList;
 end;
 PTBINIds = ^TBINIds;
 TColValues = record
   ColValue : Variant;
 end;
 PTColValues = ^TColValues;
var
  I : integer;
  BIN1 : PTBINIds;
  BIN2 : PTBINIds;
  Descending, IsDate : boolean;
  Date01, Date02: TDateTime;
  Var01, Var02: variant;
begin
  BIN1 := PTBINIds(Item1);
  BIN2 := PTBINIds(Item2);
  Result := -1;

  if BIN1.Visible <> BIN2.Visible then
  begin
    if BIN1.Visible > BIN2.Visible then Result := 1;
    exit;
  end;

  for I := 0 to BIN1.ColumnSortedCount - 1 do
  begin
    Descending := PTColNature(BIN1.ColNatureList[I]).Desc;
    IsDate := PTColNature(BIN1.ColNatureList[I]).IsDate;
    if IsDate then
    begin
      Date01 := PTColValues(BIN1.ColValuesList[I]).ColValue;
      Date02 := PTColValues(BIN2.ColValuesList[I]).ColValue;
      if Date01 <> Date02 then
      begin
        if Date01 > Date02 then Result := 1;
        if Descending then Result := Result * -1;
        exit;
      end;
    end
    else
    begin
      Var01 := PTColValues(BIN1.ColValuesList[I]).ColValue;
      Var02 := PTColValues(BIN2.ColValuesList[I]).ColValue;
      if Var01 <> Var02 then
      begin
        if Var01 > Var02 then Result := 1;
        if Descending then  Result := Result * -1;
        exit;
      end;
    end;
  end;

  Result := 0;

end;

//----------------------------------------------------------------------------//

function sortBIN(Item1, Item2: Pointer): integer;
type
 TColNature = record
   Desc   : Boolean;
   IsDate : Boolean;
 end;
 PTColNature = ^TColNature;
 TBINIds = record
   id    : TSchedId;
   Visible : CScBinView;
   ColValuesList : TList;
   ColumnSortedCount : Integer;
   ColNatureList : TList;
 end;
 PTBINIds = ^TBINIds;
 TColValues = record
   ColValue : Variant;
 end;
 PTColValues = ^TColValues;
var
  I : integer;
  BIN1 : PTBINIds;
  BIN2 : PTBINIds;
  Descending, IsDate,d1,d2 : boolean;
  Date01, Date02, dd1,dd2: TDateTime;
  Var01, Var02: variant;
  MainFormat : String;
begin
  BIN1 := PTBINIds(Item1);
  BIN2 := PTBINIds(Item2);
  d1 := false;
  d2 := False;
  Result := -1;

  if BIN1.Visible <> BIN2.Visible then
  begin
    if BIN1.Visible > BIN2.Visible then Result := 1;
    exit;
  end;

  for I := 0 to BIN1.ColumnSortedCount - 1 do
  begin
    Descending := PTColNature(BIN1.ColNatureList[I]).Desc;
    IsDate := PTColNature(BIN1.ColNatureList[I]).IsDate;

    Var01 := PTColValues(BIN1.ColValuesList[I]).ColValue;
    Var02 := PTColValues(BIN2.ColValuesList[I]).ColValue;

    if not IsDate then
    begin
     // MainFormat := FormatSettings.ShortDateFormat;

     // FormatSettings.ShortDateFormat := 'dd/mm/yyyy';
      d1 := TryStrToDate(Var01, dd1);
      if d1 then
        d2 := TryStrToDate(Var02, dd2);

      if d1 and d2 then
      begin
        Var01 := dd1;
        Var02 := dd2;
      end;

     // FormatSettings.ShortDateFormat := MainFormat;

      if VarType(Var01) = VarType(Var02) then
        if Var01 <> Var02 then
        begin
          if Var01 > Var02 then
            Result := 1;

          if Descending then
            Result := Result * -1;
          exit;
        end;
    end
    else
    if IsDate then
    begin
      Date01 := VartoDateTime(PTColValues(BIN1.ColValuesList[I]).ColValue);
      Date02 := VartoDateTime(PTColValues(BIN2.ColValuesList[I]).ColValue);
      if Date01 <> Date02 then
      begin
        if Date01 > Date02 then
          Result := 1;

        if Descending then
          Result := Result * -1;
        exit;
      end;
    end
   { else
    begin
     { if VarType(Var01) = VarType(Var02) then
      if Var01 <> Var02 then
      begin
        if Var01 > Var02 then
          Result := 1;

        if Descending then
          Result := Result * -1;
        exit;
      end;
    end;     }
  end;

  Result := 0;

end;

//----------------------------------------------------------------------------//

Procedure sortTheBIN(pLst: PTListRec);
type
 TColNature = record
   Desc   : Boolean;
   IsDate : Boolean;
 end;
 PTColNature = ^TColNature;
 TBINIds = record
   id      : TSchedId;
   Visible : CScBinView;
   ColValuesList : TList;
   ColumnSortedCount : Integer;
   ColNatureList : TList;
 end;
 PTBINIds = ^TBINIds;
 TColValues = record
   ColValue : Variant;
 end;
 PTColValues = ^TColValues;
var
  i, j :  integer;
  id: TSchedID;
  BINIdsList : TList;
  PBINIds : PTBINIds;
  ListCount : integer;
  TempVar : variant;
  PColValues : PTColValues;
  ColumnSortedCount : Integer;
  SharedColNatureList : TList;
  PColNature : PTColNature;
begin

  BINIdsList := TList.Create;
  BINIdsList.Capacity := pLst.ObjLst.GetLinkCount;

  if TBinPanel(pLst.ServObj).GetFiltParms.P_MaterialSchedFilter then
  begin

    ColumnSortedCount := TBinPanel(pLst.ServObj).p_GetNumberOfColumsSorted;
    ListCount := pLst.ObjLst.GetLinkCount - 1;

    SharedColNatureList := TList.Create;
    SharedColNatureList.Capacity := ColumnSortedCount;
    for J := 0 to ColumnSortedCount - 1 do
    begin
      New(PColNature);
      UMbinGridMaterial.GetColNature(J, PColNature.Desc, PColNature.IsDate);
      SharedColNatureList.Add(PColNature);
    end;

    for I := 0 to ListCount do
    begin
      id := pLst.ObjLst.GetLink(I);
      new(PBINIds);
      PBINIds.id := id;
      TempVar := UMbinGridMaterial.GetColValue(id, -1);
      PBINIds.Visible := TempVar;
      PBINIds.ColumnSortedCount := ColumnSortedCount;
      PBINIds.ColNatureList := SharedColNatureList;
      PBINIds.ColValuesList := TList.Create;
      for J := 0 to ColumnSortedCount - 1 do
      begin
        new(PColValues);
        PColValues.ColValue := UMbinGridMaterial.GetColValue(id, J);
        PBINIds.ColValuesList.add(PColValues);
      end;
      BINIdsList.add(PBINIds);
    end;

    BINIdsList.sort(sortBINMat);

    pLst.ObjLst.ClearList;
    for I := 0 to BINIdsList.Count - 1 do
    begin
      PBINIds := PTBINIds(BINIdsList[I]);
      pLst.ObjLst.AddLink(PBINIds.id);
      for J := 0 to PBINIds.ColValuesList.Count - 1 do
        dispose(PTBINIds(PBINIds.ColValuesList[J]));
      PBINIds.ColValuesList.Free;
      Dispose(PTBINIds(BINIdsList[I]));
    end;

    for J := 0 to SharedColNatureList.Count - 1 do
      Dispose(PTColNature(SharedColNatureList[J]));
    SharedColNatureList.Free;

  end

  else
  begin

    ColumnSortedCount := TBinPanel(pLst.ServObj).p_GetNumberOfColumsSorted;
    ListCount := pLst.ObjLst.GetLinkCount - 1;

    SharedColNatureList := TList.Create;
    SharedColNatureList.Capacity := ColumnSortedCount;
    for J := 0 to ColumnSortedCount - 1 do
    begin
      New(PColNature);
      UMbinGrid.GetColNature(J, PColNature.Desc, PColNature.IsDate);
      SharedColNatureList.Add(PColNature);
    end;

    for I := 0 to ListCount do
    begin
      id := pLst.ObjLst.GetLink(I);
      new(PBINIds);
      PBINIds.id := id;
      TempVar := UMbinGrid.GetColValue(id, -1);
      PBINIds.Visible := TempVar;
      PBINIds.ColumnSortedCount := ColumnSortedCount;
      PBINIds.ColNatureList := SharedColNatureList;
      PBINIds.ColValuesList := TList.Create;
      for J := 0 to ColumnSortedCount - 1 do
      begin
        new(PColValues);
        PColValues.ColValue := UMbinGrid.GetColValue(id, J);
        PBINIds.ColValuesList.add(PColValues);
      end;
      BINIdsList.add(PBINIds);
    end;

    BINIdsList.sort(sortBIN);

    pLst.ObjLst.ClearList;
    for I := 0 to BINIdsList.Count - 1 do
    begin
      PBINIds := PTBINIds(BINIdsList[I]);
      pLst.ObjLst.AddLink(PBINIds.id);
      for J := 0 to PBINIds.ColValuesList.Count - 1 do
        dispose(PTBINIds(PBINIds.ColValuesList[J]));
      PBINIds.ColValuesList.Free;
      Dispose(PTBINIds(BINIdsList[I]));
    end;

    for J := 0 to SharedColNatureList.Count - 1 do
      Dispose(PTColNature(SharedColNatureList[J]));
    SharedColNatureList.Free;

  end;

  BINIdsList.Free;

end;

//----------------------------------------------------------------------------//

procedure TObjListSrv.MainOneAddedAll(ServObj: TObject; sc: TMSchedCont; ToSort: Boolean);
var
  i, Idx:  integer;
  pLst: PTListRec;
  id: TSchedID;
  Iter: TMSchedContIterator;
  WcProcAllowedList : TList;
begin
  i := ClientPos(ServObj);

  pLst := PTListRec(m_lst[i]);
  pLst.ObjLst.ClearList;

  pLst.noty(pLst.ServObj, TOL_UpdateWcPlan);

  Iter := TMSchedContIterator.CreateScIter(sc);
  Iter.Start;
  id := Iter.GetNext;

  WcProcAllowedList := TList.Create;

  if not Assigned(pLst.filt) then
  begin
    while id <> CSchedIDnull do
    begin
      pLst.ObjLst.AddLink(id);
      id := Iter.GetNext;
    end;
  end
  else
  begin
    while id <> CSchedIDnull do
    begin
      if pLst.filt(id, pLst.ServObj, WcProcAllowedList) then
        pLst.ObjLst.AddLink(id);
      id := Iter.GetNext;
    end;
  end;

  for Idx := 0 to WcProcAllowedList.Count - 1 do
    Dispose(PTWorkCnterProcessAllowed(WcProcAllowedList[Idx]));
  WcProcAllowedList.Free;

  pLst.noty(pLst.ServObj, TOL_chg);

  if (pLst.ObjLst.GetLinkCount <> 0) and ToSort then
  begin
    SortTheBin(pLst);
//    sort(pLst.ServObj);
    pLst.noty(pLst.ServObj, TOL_Refresh);
  end;

end;

//----------------------------------------------------------------------------//

procedure TObjListSrv.MainOneAddedAllChangeTab(ServObj: TObject; sc: TMSchedCont);
var
  i:  integer;
  pLst: PTListRec;
  id: TSchedID;
  Iter: TMSchedContIterator;
  WcProcAllowedList : TList;
begin

  i := ClientPos(ServObj);

  pLst := PTListRec(m_lst[i]);

  pLst.noty(pLst.ServObj, TOL_SavedSelectedIdsInListAndClearSelected);
  pLst.ObjLst.ClearList;
  pLst.noty(pLst.ServObj, TOL_ClearGroupedByFieldList);
  pLst.noty(pLst.ServObj, TOL_SavedShowGroupLinesInBin);

  pLst.noty(pLst.ServObj, TOL_UpdateWcPlan);

//  sc.DisableAllBinCheckBox(false);
  Iter := TMSchedContIterator.CreateScIter(sc);
  Iter.Start;
  id := Iter.GetNext;
  WcProcAllowedList := TList.Create;

  if not Assigned(pLst.filt) then
  begin
    while id <> CSchedIDnull do
    begin
      pLst.ObjLst.AddLink(id);
      id := Iter.GetNext;
    end;
  end
  else
  begin
    while id <> CSchedIDnull do
    begin
      if pLst.filt(id, pLst.ServObj, WcProcAllowedList) then
        pLst.ObjLst.AddLink(id);
      id := Iter.GetNext;
    end;
  end;

  for I := 0 to WcProcAllowedList.Count - 1 do
    Dispose(PTWorkCnterProcessAllowed(WcProcAllowedList[I]));
  WcProcAllowedList.Free;

  pLst.noty(pLst.ServObj, TOL_UpdatedSavedShowGroupLinesInBin);
  pLst.noty(pLst.ServObj, TOL_SortListGroupedByFieldId);
  pLst.noty(pLst.ServObj, TOL_chgFiltr);
  if pLst.ObjLst.GetLinkCount > 0 then
    SortTheBin(pLst);
//  sort(pLst.ServObj);
  pLst.noty(pLst.ServObj, TOL_UpdateSelectedIdsFromList);
  pLst.noty(pLst.ServObj, TOL_Refresh);

  // check Alternative option (eran):

{
 ALTERNATIVE TO THE SORT - 33% faster
 THE comment to sort(pLst.ServObj) is not enough !!!
 if you have 2 tabs only that are the same but the first is descending,
 after open plan, you see the first one correctly, going to teh second one,
 it is not correct as you see the same sort of the first one.

procedure TObjListSrv.MainOneAddedAllChangeTab(ServObj: TObject; sc: TMSchedCont);
var
  i, j, CompareResult, Multiplier, TempMultiplier, NumberOfEntries :  integer;
  pLst: PTListRec;
  id, TempId: TSchedID;
  Iter: TMSchedContIterator;
begin
  i := ClientPos(ServObj);
  NumberOfEntries := 0;
  Multiplier := 1;

  pLst := PTListRec(m_lst[i]);
  pLst.ObjLst.ClearList;

  pLst.noty(pLst.ServObj, TOL_UpdateWcPlan);

//  sc.DisableAllBinCheckBox(false);
  Iter := TMSchedContIterator.CreateScIter(sc);
  Iter.Start;
  id := Iter.GetNext;

  while id <> CSchedIDnull do
  begin
    if (not Assigned(pLst.filt)) or pLst.filt(id, pLst.ServObj) then
//      pLst.ObjLst.AddLink(id);
    begin

      if NumberOfEntries = 0 then
        pLst.ObjLst.AddLink(id)
      else
      begin
        if Multiplier < NumberOfEntries then Multiplier := Multiplier * 2;
        TempMultiplier := Multiplier;
        j := TempMultiplier - 1;
        while (TempMultiplier > 0) do
        begin
          TempMultiplier := trunc(TempMultiplier / 2);
          CompareResult := -1;
          if j < NumberOfEntries then
          begin
            TempId := pLst.ObjLst.GetLink(j);
            CompareResult := CompColValue(pointer(ID), Pointer(TempId));
          end;
          if CompareResult = 0 then break;
          if CompareResult = -1 then
             j := j - TempMultiplier
          else
             j := j + TempMultiplier;
        end;
        if CompareResult = 1 then j := j + 1;
        pLst.ObjLst.Insert(j, Id);
      end;
      inc(NumberOfEntries);

    end;
    id := Iter.GetNext
  end;

  pLst.noty(pLst.ServObj, TOL_chgFiltr);
  //sort(pLst.ServObj);
  pLst.noty(pLst.ServObj, TOL_Refresh);

end;

}

end;

//----------------------------------------------------------------------------//

procedure TObjListSrv.MainUpdateFilterAndSortTab(ServObj: TObject; sc: TMSchedCont);
var
  i, Idx:  integer;
  pLst: PTListRec;
  id: TSchedID;
  Iter: TMSchedContIterator;
  WcProcAllowedList : TList;
begin

  i := ClientPos(ServObj);

  pLst := PTListRec(m_lst[i]);
  pLst.ObjLst.ClearList;

  pLst.noty(pLst.ServObj, TOL_UpdateWcPlan);

//  sc.DisableAllBinCheckBox(false);
  Iter := TMSchedContIterator.CreateScIter(sc);
  Iter.Start;
  id := Iter.GetNext;

  WcProcAllowedList := TList.Create;

  if not Assigned(pLst.filt) then
  begin
    while id <> CSchedIDnull do
    begin
      pLst.ObjLst.AddLink(id);
      id := Iter.GetNext;
    end;
  end
  else
  begin
    while id <> CSchedIDnull do
    begin
      if pLst.filt(id, pLst.ServObj, WcProcAllowedList) then
        pLst.ObjLst.AddLink(id);
      id := Iter.GetNext;
    end;
  end;

  for Idx := 0 to WcProcAllowedList.Count - 1 do
    Dispose(PTWorkCnterProcessAllowed(WcProcAllowedList[Idx]));
  WcProcAllowedList.Free;

  pLst.noty(pLst.ServObj, TOL_chgFiltr);
  if pLst.ObjLst.GetLinkCount > 0 then
    SortTheBin(pLst);
//  sort(pLst.ServObj);
  pLst.noty(pLst.ServObj, TOL_Refresh);

end;

end.
