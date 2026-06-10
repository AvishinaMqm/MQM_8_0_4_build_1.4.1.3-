unit UMOverlap;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, UMArticles, UGCustomList;

type
  TOvlpRule = record
    CanDeliverPartial: Boolean;
    MinQtyFromPrvStp: Double;
    MinQtyPassNxtStp: Double;
    UpdBalEveryHour: Integer;
    UpdBalEveryQty: Double;
    WaitAtLeastMin: Integer;
    WaitAtMostMin: Integer;
    WaitEntirePrvQty: Boolean;
    UpdIssFromPrvStpHour: Integer;
  end;
  PTOvlpRule = ^TOvlpRule;

  TOvlpRuleDet = record
    MatArticleType: string;
    IssueTransType: string;
    MinMatQty: Double;
    WaitEntireMatQty: Boolean;
    SearchBalance: Boolean;
    UpdEveryHours: Integer;
  end;
  PTOvlpRuleDet = ^TOvlpRuleDet;

  TMQMOvlpRule = class
    constructor CreateOvlpRule(ArtType, WrkCtrProc: string; RuleRec: TOvlpRule);
    destructor  Destroy; override;
  private
    m_DetList: TList;
    m_ArtType: string;
    m_WrkCtrProc: string;
    function FindDet(MatArticleType, IssueTransType: string): PTOvlpRuleDet;
  public
    m_CanDeliverPartial: Boolean;
    m_MinQtyFromPrvStp: Double;
    m_MinQtyPassNxtStp: Double;
    m_UpdBalEveryHour: Integer;
    m_UpdBalEveryQty: Double;
    m_WaitAtLeastMin: Integer;
    m_WaitAtMostMin: Integer;
    m_WaitEntirePrvQty: Boolean;
    m_UpdIssFromPrvStpHour: Integer;
    function AddDet(DetailRec: TOvlpRuleDet): boolean;
    function GetDet(MatArticleType, IssueTransType: string): PTOvlpRuleDet;

    property p_ArtType:    string   read m_ArtType;
    property p_WrkCtrProc: string   read m_WrkCtrProc;
  end;

  TMQMOvlpRulesList = class(TMQMCustomList)
  private
    function FindRule(ArtType, WrkCtrProc: string; out isDefault: boolean): TMQMOvlpRule;
  public
    function AddOvplRule(ArtType, WrkCtrProc: string; RuleRec: TOvlpRule; DetailRec: TOvlpRuleDet): boolean;
    function GetRule(ArtType, WrkCtrProc: string; out isDefault: boolean): TMQMOvlpRule;
    destructor  Destroy; override;
  end;

implementation

{
****************************** TMQMOvlpRulesList *******************************
}

function TMQMOvlpRulesList.AddOvplRule(ArtType, WrkCtrProc: string; RuleRec: TOvlpRule; DetailRec: TOvlpRuleDet): boolean;
var
  OvlpRule: TMQMOvlpRule;
  isDefaultRule: boolean;
begin
  Result := false;

  OvlpRule := FindRule(ArtType, WrkCtrProc, isDefaultRule);
  
  if not Assigned(OvlpRule) 
  or isDefaultRule then
  begin
    OvlpRule := TMQMOvlpRule.CreateOvlpRule(ArtType, WrkCtrProc, RuleRec);
    AddItem(OvlpRule);
    Result := true;
  end;

  if DetailRec.MatArticleType <> '' then
    Result := OvlpRule.AddDet(DetailRec);

end;

//----------------------------------------------------------------------------//

destructor TMQMOvlpRulesList.Destroy;
Var
  I : integer;
begin
  for i := 0 to p_count -1 do
  begin
    TMQMOvlpRule(p_Item[I]).free;
  end;

  inherited Destroy;
end;

//----------------------------------------------------------------------------//

function TMQMOvlpRulesList.FindRule(ArtType, WrkCtrProc: string; out isDefault: boolean): TMQMOvlpRule;
var
  i: integer;
  StrIndex, EndIndex: integer;
begin
  Result := nil;
  StrIndex := -1;
  EndIndex := -1;
  isDefault := false;

  //Search for ArtType and WCProc
  for i := 0 to p_count -1 do
  begin
    if ArtType = TMQMOvlpRule(p_Item[i]).p_ArtType then
    begin
      if StrIndex < 0 then
        StrIndex := i;

      if WrkCtrProc = TMQMOvlpRule(p_Item[i]).p_WrkCtrProc then
      begin
        Result := TMQMOvlpRule(p_Item[i]);
        exit
      end;
    end else
    begin
      if StrIndex >= 0 then
        EndIndex := i;
    end;
  end;


  if StrIndex >= 0 then
  begin
    if EndIndex < StrIndex then
      EndIndex := StrIndex;
      
    //Search for ArtType and WCProc = blank
    for i := StrIndex to EndIndex do
    begin
      if (TMQMOvlpRule(p_Item[i]).p_ArtType = ArtType)
      and (TMQMOvlpRule(p_Item[i]).p_WrkCtrProc = '') then
      begin
        Result := TMQMOvlpRule(p_Item[i]);
        exit
      end;
    end;
  end;

  if not Assigned(Result)
  and (p_Count > 0) then
  begin
    Result := TMQMOvlpRule(p_Item[0]);  //Set the result with the default rule
    isDefault := true;
  end;

end;

//----------------------------------------------------------------------------//

function TMQMOvlpRulesList.GetRule(ArtType, WrkCtrProc: string; out isDefault: boolean): TMQMOvlpRule;
begin
  Result := FindRule(ArtType, WrkCtrProc, isDefault);

  if not Assigned(Result)
  and (p_Count > 0) then
    Result := TMQMOvlpRule(p_Item[0]);

end;

{
****************************** TMQMOvlpRulesList *******************************
}
constructor TMQMOvlpRule.CreateOvlpRule(ArtType, WrkCtrProc: string; RuleRec: TOvlpRule);
var
  RuleDetRec: PTOvlpRuleDet;
begin
  inherited Create;
  m_DetList := TList.Create;
  New(RuleDetRec);
  RuleDetRec.MatArticleType   := 'EMPTY';
  RuleDetRec.IssueTransType := 'EMPTY';
  RuleDetRec.MinMatQty := 0;
  RuleDetRec.WaitEntireMatQty := True;
  RuleDetRec.SearchBalance := True;
  RuleDetRec.UpdEveryHours := 0;
  m_DetList.Add(RuleDetRec);

  m_ArtType    := ArtType;
  m_WrkCtrProc := WrkCtrProc;

  m_CanDeliverPartial    := RuleRec.CanDeliverPartial;
  m_MinQtyFromPrvStp     := RuleRec.MinQtyFromPrvStp;
  m_MinQtyPassNxtStp     := RuleRec.MinQtyPassNxtStp;
  m_UpdBalEveryHour      := RuleRec.UpdBalEveryHour;
  m_UpdBalEveryQty       := RuleRec.UpdBalEveryQty;
  m_WaitAtLeastMin       := RuleRec.WaitAtLeastMin;
  m_WaitAtMostMin        := RuleRec.WaitAtMostMin;
  m_WaitEntirePrvQty     := RuleRec.WaitEntirePrvQty;
  m_UpdIssFromPrvStpHour := RuleRec.UpdIssFromPrvStpHour;

end;

//----------------------------------------------------------------------------//

destructor TMQMOvlpRule.Destroy;
//var
//  i: integer;
begin
//  for i := m_DetList.Count-1 to 0 do
//    Dispose(PTOvlpRuleDet(m_DetList[i]));

  m_DetList.Free;

  inherited Destroy;
end;

//----------------------------------------------------------------------------//

function TMQMOvlpRule.AddDet(DetailRec: TOvlpRuleDet): boolean;
var
  RuleDetRec: PTOvlpRuleDet;
begin
  Result := false;
  RuleDetRec := FindDet(DetailRec.MatArticleType, DetailRec.IssueTransType);

  if not assigned(RuleDetRec) then
  begin
    New(RuleDetRec);
    RuleDetRec.MatArticleType   := DetailRec.MatArticleType;
    RuleDetRec.IssueTransType   := DetailRec.IssueTransType;
    RuleDetRec.MinMatQty        := DetailRec.MinMatQty;
    RuleDetRec.WaitEntireMatQty := DetailRec.WaitEntireMatQty;
    RuleDetRec.SearchBalance    := DetailRec.SearchBalance;
    RuleDetRec.UpdEveryHours    := DetailRec.UpdEveryHours;

    m_DetList.Add(RuleDetRec);
    Result := true;
  end;
end;

//----------------------------------------------------------------------------//

function TMQMOvlpRule.FindDet(MatArticleType, IssueTransType: string): PTOvlpRuleDet;
var
  i: integer;
begin
  Result := nil;

  for i := 0 to m_DetList.Count -1 do
  begin
    if (PTOvlpRuleDet(m_DetList[i]).MatArticleType = MatArticleType)
    and (PTOvlpRuleDet(m_DetList[i]).IssueTransType = IssueTransType) then
      Result := PTOvlpRuleDet(m_DetList[i])
  end;
end;

//----------------------------------------------------------------------------//

function TMQMOvlpRule.GetDet(MatArticleType, IssueTransType: string): PTOvlpRuleDet;
begin
  Result := FindDet(MatArticleType, IssueTransType);

  if not Assigned(Result)
  and (m_DetList.Count > 0) then
    Result := PTOvlpRuleDet(m_DetList[0]);
end;
//----------------------------------------------------------------------------//

end.
