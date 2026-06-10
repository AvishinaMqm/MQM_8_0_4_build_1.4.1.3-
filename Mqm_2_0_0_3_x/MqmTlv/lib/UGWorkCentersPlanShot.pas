unit UGWorkCentersPlanShot;

interface

uses
  Classes, UMWkCtr, UGWorkCentersDrawSlot, UMSchedContFunc;

type

  TObjId = Integer;

  TGrpType = (TGT_NORMAL, TGT_DETAIL, TGT_SAME);

  TSecondLvlType = (Lvl_non, Lvl_Wc_category, lvl_property);

  TPlanLineGroup = class;

  TPlanLineAbst = class(TObject)
    constructor CreatePlanLineAbst;
    destructor  Destroy; override;
  public
    m_isSmall:   boolean;
    m_lineDescr: string;
    m_lineHd:    string;
    m_lineWCGroupDescr: string;
  end;

  TPlanLineShow = class(TPlanLineAbst)
    private
      m_Group : TPlanLineGroup;
      m_PlaceInGroupList : Integer;
    public
    constructor CreatePlanLineShow;
    function GetDataForPrd(stDate, edDate: TDateTime; Slot: TDrawSlot): boolean; virtual; abstract;
    property P_WcGroup : TPlanLineGroup read m_Group;
    property p_PlaceInGroupList : integer read m_PlaceInGroupList;
  end;

  TPlanLineWCGroup = class(TPlanLineShow)
    constructor CreatePlanLineWCGroup;
    destructor Destroy; override;
    function  GetDataForPrd(stDate, edDate: TDateTime; Slot: TDrawSlot): boolean; override;
  public
    m_Group_name    : String;
    m_WC_List       : TList;
    m_isGrpExpanded : Boolean;
    property p_Group_name : String read m_Group_name write m_Group_name;
    property p_WC_List : TList read m_WC_List write m_WC_List;
  end;

  TPlanLineWc = class(TPlanLineShow)
    constructor CreatePlanLineWc;
    destructor Destroy; override;
    function  GetDataForPrd(stDate, edDate: TDateTime; Slot: TDrawSlot): boolean; override;
  end;

  TPlanLineChild = class(TPlanLineShow)
    constructor CreatePlanLineChild;
    destructor Destroy; override;
    function  GetDataForPrd(stDate, edDate: TDateTime; Slot: TDrawSlot): boolean; override;
  end;

  TPlanLineSummary = class(TPlanLineShow)
    constructor CreatePlanLineSummary(descr: string; mainCapPos: integer);
    destructor  Destroy; override;
    function    GetDataForPrd(stDate, edDate: TDateTime; Slot: TDrawSlot): boolean; override;
  public
    m_transCode: string;
    m_transPrt: string;
  private
    m_capSetList: TList;

    function GetNumSons: integer;
  public
    property p_numSons: integer read GetNumSons;
  end;

  TPlanLineSecondLevel = class(TPlanLineShow)
  private
    m_SecondLevelType : TSecondLvlType;
    m_shownAsSubLevel : boolean;
    m_ChildLineList   : TList;
    m_GroupParent : TPlanLineWCGroup;
  public
    m_Prop_Code : String;
    constructor CreatePlanLineSecondLevel(SecondLevelType : TSecondLvlType; Prop_Code, Code : string; Desc : string);
    destructor  Destroy; override;
    function    GetDataForPrd(stDate, edDate: TDateTime; Slot: TDrawSlot): boolean; override;
   // property    p_ProductNetGroupCode : string read m_lineHd;
    property    p_shownAsSubLevel : boolean read m_shownAsSubLevel write m_shownAsSubLevel;
    property    P_SecondLevelType : TSecondLvlType read m_SecondLevelType;
    property    P_GroupParent : TPlanLineWCGroup read m_GroupParent;
  //  property    p_ChildLineList   :

  end;

  TWcPlanShot = class;

  TPlanLineGroup = class(TPlanLineAbst)
    constructor CreatePlanLineGroup(WrkCtr : TMqmWrkCtr);
    destructor  Destroy; override;
    procedure   CleanGroupLines(CleanAllGroupLinesData : boolean);
    procedure   Reset;
    function    AddWcLine(PlanLineAbst : TPlanLineAbst): TPlanLineShow;
    function    AddSecondLineLvl(SecondLevelType : TSecondLvlType; Prop_Code, Code : string; Desc : string): TPlanLineShow;
    function    AddSummaryLine(descr: string): TPlanLineSummary;
    procedure   SetStrType(strType: string);
    function    AddWcGroupLine(PlanLineAbst : TPlanLineAbst): TPlanLineShow;
  private
    m_WrkCtr : TMqmWrkCtr;
    m_lineList: TList;
    m_planShot: TWcPlanShot;
    m_grpType:  TGrpType;
    m_PlaceInPlanShotList : Integer;
    m_SecondLevelType : TSecondLvlType;
    m_PropCode : string;
    m_PropDesc : string;
    m_SearChedValue : string;

    function GetNumSons: integer;
    function GetSon(pos: integer): TPlanLineAbst;
  public

    property p_numSons: integer read GetNumSons;
    property p_son[pos:integer]: TPlanLineAbst read GetSon;
    property p_grpType: TGrpType read m_grpType;
    property P_WrkCtr: TMqmWrkCtr read m_WrkCtr;
    property p_PlaceInPlanShotList : Integer read m_PlaceInPlanShotList;
    property p_PropCode : string read m_PropCode write m_PropCode;
    property p_PropDesc : string read m_PropDesc write m_PropDesc;
    property p_SearChedValue : string read m_SearChedValue write m_SearChedValue;
    property p_SecondLevelType : TSecondLvlType read m_SecondLevelType write m_SecondLevelType;
    property p_lineList : TList read m_lineList write m_lineList;
  end;

  TSlotGrp_WKC = Record
      m_Group : String;
      m_Date : TDate;
      sum_Hours_Available  : Double;
      sum_Hours_Used : Double;
      m_IsExpanded : Boolean;
      m_errSet : SetOfErrors;
  End;
  TTSlotGrp_WKC = ^TSlotGrp_WKC;

  TWcPlanShot = class(TObject)
    constructor Create();

    destructor  Destroy; override;
    procedure   RemoveLine(code: string);

    function  GetPlanLine(pos: integer): TPlanLineAbst;
    function  GetNumLines: integer;
  //  function  GetVisibleLines: integer;
 //   function  AddWcLine(WrkCtr : TMqmWrkCtr): TPlanLineWc;
    function  AddSummaryLine(descr: string): TPlanLineSummary;
    function  AddGroupLine(WrkCtr : TMqmWrkCtr) : TPlanLineGroup;
    procedure SortByWC;
    procedure Reset;
  private

    m_list: TList;
    m_SlotGroup : Integer;
    m_SlotGroup_Lists : TList;
  public
    // save plan shot settings
   { m_settingsSpanIdx: integer;
    m_settingsSpanFrameIdx: integer;
    m_settingsSlotFrameIdx: integer;
    m_settingsDisplayIdx: integer;
    m_settingsDisplayBlend: integer;
    m_settingsAlerts: integer;   }
    property p_SlotGroup: integer read m_SlotGroup write m_SlotGroup;
    property p_numSons: integer read GetNumLines;
    property p_son[pos:integer]: TPlanLineAbst read GetPlanLine;
    property p_SlotGroup_Lists : TList read m_SlotGroup_Lists write m_SlotGroup_Lists;
  end;

implementation

uses
  SysUtils, DateUtils, Math, UMCommon;

//----------------------------------------------------------------------------//

function SortOnWc(Item1, Item2: Pointer): Integer;
var
  Wc1 , Wc2 : TPlanLineGroup;
begin
  Wc1 := TPlanLineGroup(TPlanLineAbst(Item1));
  Wc2 := TPlanLineGroup(TPlanLineAbst(Item2));

  result := 0;
  if TMqmWrkCtr(Wc1.m_WrkCtr).p_ReadOnly then
  begin
    if TMqmWrkCtr(Wc2.m_WrkCtr).p_ReadOnly then
      Result := 0
    else
      Result := 1;
    exit
  end;

  if TMqmWrkCtr(Wc2.m_WrkCtr).p_ReadOnly then
  begin
    Result := -1;
    exit
  end;

  if TMqmWrkCtr(Wc1.m_WrkCtr).p_WrkCtrCode < TMqmWrkCtr(Wc2.m_WrkCtr).p_WrkCtrCode then
    Result := -1  // WC1 < WC2
  else if TMqmWrkCtr(Wc1.m_WrkCtr).p_WrkCtrCode > TMqmWrkCtr(Wc2.m_WrkCtr).p_WrkCtrCode then
    Result := 1   // WC1 > WC2
  else
    Result := 0;

end;

//----------------------------------------------------------------------------//

{ TPlanShot }

function TWcPlanShot.AddGroupLine(WrkCtr : TMqmWrkCtr) : TPlanLineGroup;
begin
  Result := TPlanLineGroup.CreatePlanLineGroup(WrkCtr);
  Result.m_planShot := Self;
  Result.m_SecondLevelType := Lvl_non;
  Result.m_PlaceInPlanShotList := m_list.Add(Result);
end;

//----------------------------------------------------------------------------//

procedure TWcPlanShot.SortByWC;
begin
  m_list.Sort(SortOnWc);
end;

//----------------------------------------------------------------------------//


{function TWcPlanShot.AddWcLine(WrkCtr : TMqmWrkCtr): TPlanLineWc;
begin
  Result := TPlanLineWc.CreatePlanLineWc;
  m_list.Add(Result);
end;}

//----------------------------------------------------------------------------//

function TWcPlanShot.AddSummaryLine(descr: string): TPlanLineSummary;
begin
  Result := TPlanLineSummary.CreatePlanLineSummary(descr,0);
  m_list.Add(Result);
end;

//----------------------------------------------------------------------------//

constructor TWcPlanShot.Create;
begin
  inherited;
  m_list := TList.Create;
  p_SlotGroup_Lists := TList.Create;

end;

//----------------------------------------------------------------------------//

destructor TWcPlanShot.Destroy;
begin
  Reset;
  m_list.Free;
  p_SlotGroup_Lists.Free;
  inherited;
end;

//----------------------------------------------------------------------------//

function TWcPlanShot.GetPlanLine(pos: integer): TPlanLineAbst;
begin
  Result := TPlanLineAbst(m_list[pos]);
end;

{function TWcPlanShot.GetVisibleLines: integer;
var
  i:  integer;
  ln: TPlanLineAbst;
  grp: TPlanLineGroup;
begin
  Result := 0;
  for i := 0 to m_list.Count - 1 do
  begin
    ln := m_list[i];
    if ln is TPlanLineGroup then
    begin
      grp := TPlanLineGroup(ln);
      if grp.m_grouped then
        Inc(Result)
      else
        Result := Result + TPlanLineGroup(ln).p_numSons
    end
    else
      Inc(Result);
  end;
end; }

//----------------------------------------------------------------------------//

function TWcPlanShot.GetNumLines: integer;
begin
  Result := m_list.Count
end;

//----------------------------------------------------------------------------//

procedure TWcPlanShot.RemoveLine(code: string);
begin

end;

//----------------------------------------------------------------------------//

procedure TWcPlanShot.Reset;
var
  i: integer;
begin
  for i := 0 to m_list.Count - 1 do
    TPlanLineAbst(m_list[i]).Free;

  m_SlotGroup_Lists.Clear;

  m_list.Clear;
end;

{ TPlanLineAbst }

constructor TPlanLineAbst.CreatePlanLineAbst;
begin
  inherited;
end;

//----------------------------------------------------------------------------//

destructor TPlanLineAbst.Destroy;
begin
  inherited;
end;

{ TPlanLineSimple }

constructor TPlanLineWc.CreatePlanLineWc;
begin
  inherited CreatePlanLineShow;

end;

//----------------------------------------------------------------------------//

destructor TPlanLineWc.Destroy;
begin
  inherited;
end;

//----------------------------------------------------------------------------//

function TPlanLineWc.GetDataForPrd(stDate, edDate: TDateTime; Slot: TDrawSlot): boolean;
var
  Hours_Available, Hours_used : double;
  errSet : SetOfErrors;
begin
  result := true;
  m_group.P_WrkCtr.GetDataForPrdDailyCap(stDate, edDate - 1, Hours_Available, Hours_used, errSet);
  Slot.p_SlotData.p_Hours_Available := Hours_Available;
  Slot.p_SlotData.p_Hours_used := Hours_used;
  Slot.p_SlotData.p_errSet := errSet;
end;

{ TPlanLineSummary }

constructor TPlanLineSummary.CreatePlanLineSummary(descr: string; mainCapPos: integer);
begin
  inherited CreatePlanLineShow;
end;

//----------------------------------------------------------------------------//

destructor TPlanLineSummary.Destroy;
begin
  m_capSetList.Free;
  inherited;
end;

//----------------------------------------------------------------------------//

function TPlanLineSummary.GetDataForPrd(stDate, edDate: TDateTime; Slot: TDrawSlot): boolean;
begin
end;

//----------------------------------------------------------------------------//

function TPlanLineSummary.GetNumSons: integer;
begin
  Result := m_capSetList.Count;
end;

{ TPlanLineGroup }

function TPlanLineGroup.AddWcGroupLine(PlanLineAbst : TPlanLineAbst): TPlanLineShow;
begin
  Assert(Assigned(m_planShot));
  Result := TPlanLineWCGroup.CreatePlanLineWCGroup;
  Result.m_lineDescr := '';

  if m_WrkCtr = nil then
  begin
    Result.m_lineHd := 'Summary' ;
    TPlanLineWCGroup(Result).p_Group_name := 'Summary';
  end else
  begin
    if m_planShot.m_SlotGroup = 1 then
    begin
      Result.m_lineHd := m_WrkCtr.P_WcGrp;
      TPlanLineWCGroup(Result).p_Group_name := m_WrkCtr.P_WcGrp;
     // TPlanLineWCGroup(Result).p_WC_List.Add(m_WrkCtr);
    end else if m_planShot.m_SlotGroup = 2 then
    begin
      Result.m_lineHd := m_WrkCtr.p_PlantCode;
      TPlanLineWCGroup(Result).p_Group_name := m_WrkCtr.p_PlantCode;
      //TPlanLineWCGroup(Result).p_WC_List.Add(m_WrkCtr);
    end else if m_planShot.m_SlotGroup = 3 then
    begin
      Result.m_lineHd := m_WrkCtr.p_Division;
      TPlanLineWCGroup(Result).p_Group_name := m_WrkCtr.p_Division;
      //TPlanLineWCGroup(Result).p_WC_List.Add(m_WrkCtr);
    end else
    begin
      Result.m_lineHd    := m_WrkCtr.p_WrkCtrCode;
      Result.m_lineDescr := m_WrkCtr.p_WrkCtrSDesc;
    end;
  end;

  Result.m_group := self;
  Result.m_PlaceInGroupList := m_lineList.Add(Result);
end;

function TPlanLineGroup.AddWcLine(PlanLineAbst : TPlanLineAbst): TPlanLineShow;
begin
  Assert(Assigned(m_planShot));
  Result := TPlanLineWc.CreatePlanLineWc;
  Result.m_lineHd    := m_WrkCtr.p_WrkCtrCode;
  Result.m_lineDescr := m_WrkCtr.p_WrkCtrSDesc;
  Result.m_group := self;
  Result.m_PlaceInGroupList := m_lineList.Add(Result);
end;

//----------------------------------------------------------------------------//

function TPlanLineGroup.AddSecondLineLvl(SecondLevelType : TSecondLvlType; Prop_Code, Code : string; Desc : string): TPlanLineShow;
var
  PlanLineSecondLevel : TPlanLineSecondLevel;
begin
  Assert(Assigned(m_planShot));
  m_SecondLevelType   := SecondLevelType;
  PlanLineSecondLevel := TPlanLineSecondLevel.CreatePlanLineSecondLevel(SecondLevelType, Prop_Code, Code, Desc);
  PlanLineSecondLevel.m_group := self;
  PlanLineSecondLevel.m_SecondLevelType := SecondLevelType;
  if TPlanLineShow(self.p_son[0]).ClassName = 'TPlanLineWCGroup' then
    PlanLineSecondLevel.p_shownAsSubLevel := True
  else
    PlanLineSecondLevel.p_shownAsSubLevel := True;
  PlanLineSecondLevel.m_PlaceInGroupList := m_lineList.Add(PlanLineSecondLevel);
end;

//----------------------------------------------------------------------------//

function TPlanLineGroup.AddSummaryLine(descr: string): TPlanLineSummary;
begin
  Result := TPlanLineSummary.CreatePlanLineSummary(descr, 0);
  Result.m_group := self;
  m_lineList.Add(Result);
end;

//----------------------------------------------------------------------------//

constructor TPlanLineGroup.CreatePlanLineGroup(WrkCtr : TMqmWrkCtr);
begin
  inherited CreatePlanLineAbst;
  m_WrkCtr := WrkCtr;
  m_planShot := nil;
  m_grpType  := TGT_NORMAL;
  m_lineLIst := TList.Create;
end;

//----------------------------------------------------------------------------//

procedure TPlanLineGroup.CleanGroupLines(CleanAllGroupLinesData : boolean);
var
  i: integer;
begin
  for I := m_lineLIst.Count - 1 downto 1 do
    TPlanLineSecondLevel(m_lineLIst[i]).Free;
  m_lineLIst.Count := 1;
  if CleanAllGroupLinesData then
  begin
    m_SecondLevelType := Lvl_non;
    m_PropCode := '';
    m_PropDesc := '';
  end;
end;

//----------------------------------------------------------------------------//

procedure TPlanLineGroup.Reset;
var
  i: integer;
begin
  for I := m_lineLIst.Count - 1 downto 0 do
    TPlanLineShow(m_lineLIst[i]).Free;
end;

//----------------------------------------------------------------------------//

destructor TPlanLineGroup.Destroy;
begin
  Reset;
  m_lineList.Free;
  inherited;
end;

//----------------------------------------------------------------------------//

function TPlanLineGroup.GetNumSons: integer;
begin
  Result := m_lineList.Count;
end;

//----------------------------------------------------------------------------//

function TPlanLineGroup.GetSon(pos: integer): TPlanLineAbst;
begin
  Result := TPlanLineAbst(m_lineList[pos]);
end;

//----------------------------------------------------------------------------//

procedure TPlanLineGroup.SetStrType(strType: string);
begin
  if strType = 'detail' then
    m_grpType := TGT_DETAIL
  else if strType = 'same' then
    m_grpType := TGT_SAME
  else
    m_grpType := TGT_NORMAL
end;

//----------------------------------------------------------------------------//

{ TPlanLineShow }

constructor TPlanLineShow.CreatePlanLineShow;
begin
  inherited CreatePlanLineAbst;
end;

{ TPlanLineMaterialProduct }

constructor TPlanLineSecondLevel.CreatePlanLineSecondLevel(SecondLevelType : TSecondLvlType; Prop_Code, Code : string; Desc : string);
begin
  m_ChildLineList := TList.Create;
  m_lineHd := Code;
  m_lineDescr := Desc;
  m_Prop_Code := Prop_Code;
  m_GroupParent := nil;
end;

//----------------------------------------------------------------------------//

destructor TPlanLineSecondLevel.Destroy;
var
  I : Integer;
begin
  for I := m_ChildLineList.Count - 1 downto 0 do
    TPlanLineChild(m_ChildLineList[I]).free;
  m_ChildLineList.Free;
  inherited;
end;

//----------------------------------------------------------------------------//

function TPlanLineSecondLevel.GetDataForPrd(stDate, edDate: TDateTime;
  Slot: TDrawSlot): boolean;
var
  Hours_Available_wc, Hours_Used_wc, Hours_Available_slot, Hours_used_slot : double;
  tmp_Hours_Available_slot, tmp_Hours_used_slot, tmp_Hours_Available_wc, tmp_Hours_Used_wc : double;
  errSet, tmpErrSet : SetOfErrors;
  w : Integer;
  WC : TMqmWrkCtr;
  IsWCGroup : Boolean;
begin
  result := true;
  Hours_Available_wc := 0;
  Hours_Used_wc := 0;
  Hours_Available_slot := 0;
  Hours_used_slot := 0;
  errSet := [];

  IsWCGroup := (m_group.p_numSons > 0) and (m_group.p_son[0].ClassName = 'TPlanLineWCGroup');

  if m_SecondLevelType = Lvl_Wc_category then
  begin
    if IsWCGroup then
    begin
      for w := 0 to TPlanLineWCGroup(m_group.p_son[0]).m_WC_List.Count - 1 do
      begin
        WC := TMqmWrkCtr(TPlanLineWCGroup(m_group.p_son[0]).m_WC_List[w]);
        tmp_Hours_Available_slot := 0; tmp_Hours_used_slot := 0;
        tmp_Hours_Available_wc := 0; tmp_Hours_Used_wc := 0;
        WC.GetDataForPrdDailyCategoryCap(m_lineHd, stDate, edDate - 1, tmp_Hours_Available_slot, tmp_Hours_used_slot, tmpErrSet);
        Hours_Available_slot := Hours_Available_slot + tmp_Hours_Available_slot;
        Hours_used_slot := Hours_used_slot + tmp_Hours_used_slot;
        errSet := errSet + tmpErrSet;
        WC.GetDataForPrdDailyCap(stDate, edDate - 1, tmp_Hours_Available_wc, tmp_Hours_Used_wc, tmpErrSet);
        Hours_Available_wc := Hours_Available_wc + tmp_Hours_Available_wc;
        Hours_Used_wc := Hours_Used_wc + tmp_Hours_Used_wc;
      end;
    end
    else
    begin
      m_group.P_WrkCtr.GetDataForPrdDailyCategoryCap(m_lineHd, stDate, edDate - 1, Hours_Available_slot, Hours_used_slot, errSet);
      m_group.P_WrkCtr.GetDataForPrdDailyCap(stDate, edDate - 1, Hours_Available_wc, Hours_Used_wc, tmpErrSet);
    end;
    Slot.p_SlotData.p_errSet := errSet;
    Slot.p_SlotData.p_Hours_Available := Hours_Available_wc;
    Slot.p_SlotData.p_Hours_used := Hours_used_slot;
    Slot.p_SlotData.p_Hours_used_wc := Hours_Used_wc;
  end
  else if m_SecondLevelType = lvl_property then
  begin
    if IsWCGroup then
    begin
      for w := 0 to TPlanLineWCGroup(m_group.p_son[0]).m_WC_List.Count - 1 do
      begin
        WC := TMqmWrkCtr(TPlanLineWCGroup(m_group.p_son[0]).m_WC_List[w]);
        tmp_Hours_Available_slot := 0; tmp_Hours_used_slot := 0;
        tmp_Hours_Available_wc := 0; tmp_Hours_Used_wc := 0;
        WC.GetDataForPrdDailyPropertyCap(m_lineHd, stDate, edDate - 1, tmp_Hours_Available_slot, tmp_Hours_used_slot, tmpErrSet);
        Hours_Available_slot := Hours_Available_slot + tmp_Hours_Available_slot;
        Hours_used_slot := Hours_used_slot + tmp_Hours_used_slot;
        errSet := errSet + tmpErrSet;
        WC.GetDataForPrdDailyCap(stDate, edDate - 1, tmp_Hours_Available_wc, tmp_Hours_Used_wc, tmpErrSet);
        Hours_Available_wc := Hours_Available_wc + tmp_Hours_Available_wc;
        Hours_Used_wc := Hours_Used_wc + tmp_Hours_Used_wc;
      end;
    end
    else
    begin
      m_group.P_WrkCtr.GetDataForPrdDailyPropertyCap(m_lineHd, stDate, edDate - 1, Hours_Available_slot, Hours_used_slot, errSet);
      m_group.P_WrkCtr.GetDataForPrdDailyCap(stDate, edDate - 1, Hours_Available_wc, Hours_Used_wc, tmpErrSet);
    end;
    Slot.p_SlotData.p_errSet := errSet;
    Slot.p_SlotData.p_Hours_Available := Hours_Available_wc;
    Slot.p_SlotData.p_Hours_used := Hours_used_slot;
    Slot.p_SlotData.p_Hours_used_wc := Hours_Used_wc;
  end;

end;

{ TPlanLineChild }

Constructor TPlanLineWCGroup.CreatePlanLineWCGroup;
begin
  inherited CreatePlanLineShow;
  m_WC_List := TList.Create;
end;

constructor TPlanLineChild.CreatePlanLineChild;
begin

end;

destructor TPlanLineChild.Destroy;
begin
  inherited;
end;

function TPlanLineChild.GetDataForPrd(stDate, edDate: TDateTime;
  Slot: TDrawSlot): boolean;
begin

end;

destructor TPlanLineWCGroup.Destroy;
begin
  m_WC_List.Free;
  inherited;
end;

function TPlanLineWCGroup.GetDataForPrd(stDate, edDate: TDateTime; Slot: TDrawSlot): boolean;
var i, y, x : Integer;
  Hours_Available, Hours_used : Single;
  errSet : SetOfErrors;
    SlotGrpWC: TTSlotGrp_WKC;
begin
  result := true;
  Hours_Available := 0;
  Hours_used := 0;
  errSet := [];
  //m_group.P_WrkCtr.GetDataForPrdDailyCap(stDate, edDate - 1, Hours_Available, Hours_used, errSet);
  i := 0;
  y := 0;
  while I <  m_Group.m_planShot.m_SlotGroup_Lists.Count - 1 do
  begin

    if i > m_Group.m_planShot.m_SlotGroup_Lists.Count - 1 then break;
    SlotGrpWC := TTSlotGrp_WKC(m_Group.m_planShot.m_SlotGroup_Lists[i]);

    if SlotGrpWC.m_Date < stDate then
    begin
      inc(i);
      Continue;
    end;

    if SlotGrpWC.m_Date > edDate then break;

     while y + trunc(stDate) <= trunc(edDate) do
     begin
       if i > m_Group.m_planShot.m_SlotGroup_Lists.Count - 1 then break;

       if m_Group_name <> SlotGrpWC.m_Group then
        break;

       if (SlotGrpWC.m_Date < y + trunc(stDate)) or (SlotGrpWC.m_Date > y + trunc(edDate)) then
       begin
        inc(y);
        continue;
       end;

       if SlotGrpWC.m_Date >= y + trunc(edDate) then
       begin
        i := m_Group.m_planShot.m_SlotGroup_Lists.Count;
        break;
       end;

        Hours_Available := Hours_Available + SlotGrpWC.sum_Hours_Available;
        Hours_used := Hours_used + SlotGrpWC.sum_Hours_Used;
        errSet := errSet + SlotGrpWC.m_errSet;

        break;

     end;

     inc(i);
     y := 0;

  end;

  Hours_Available := SafeFloat(Hours_Available);
  Hours_used := SafeFloat(Hours_used);

  if (Hours_used < 0.001) and (Hours_used > 0) then
     Hours_used := 0;

  if Hours_Available > 99999 then
     Hours_Available := 99999;

  if Hours_used > 99999 then
     Hours_used := 99999;

  if Hours_Available < 0 then
     Hours_Available := 0;

  if Hours_used < 0 then
     Hours_used := 0;

  Slot.p_SlotData.p_Hours_Available := RoundTo(Hours_Available, -3);
  Slot.p_SlotData.p_Hours_used := RoundTo(Hours_used, -3);
  Slot.p_SlotData.p_errSet := errSet;
end;

end.
