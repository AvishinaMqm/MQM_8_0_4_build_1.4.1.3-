unit UMIssuedArt;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, UMArticles, UMBalance, UGCustomList;

type

  TMacSetup = record
    WrkCtrCode: string;
    ResCat: string;
    ResCode: string;
    MachineSetupCode: string;
  end;

  TIssuedArt = record
    AternativeCode: string;
    Article: TMQMArticle;
    NetGroup: TMQMNetGroup;
    IssueTransType: string;
    SeqIssuedTo: string;
    ArtOnBalance: CArtOnBalance;
    RequiredQty: Double;
    IssuedQty: Double;
    AllocatedQty: Double;
    ClosedIssue: Boolean;
    HighAllocDate: TDateTime;
    StepId: Integer;
    SearchMatByAlloc: Boolean;
    lastTimeBalanceChecked : TDateTime;
    HaveEnoughBalance : boolean; //MaterialAlreadyChecked : boolean;
    IssuedArtPointer  : pointer;
  end;
  PTIssuedArt = ^TIssuedArt;

  TBchUM = record
    BchUM : string;
    MULTIPILR_TO_BATCH_UM : double;
  end;
  PTBchUM = ^TBchUM;

  TMQMIssuedArtList = class;

  TMQMMachineSetup = class
    constructor Create(MacSetupRec: TMacSetup);
    destructor  Destroy; override;
  private
    m_WrkCtrCode: string;
    m_ResCat: string;
    m_ResCode: string;
    m_MachineSetupCode: string;
  public
    m_IssuedArtList: TMQMIssuedArtList;
    procedure Clear;
    property p_ResCode: string    read m_ResCode;
    property p_ResCatCode: string     read m_ResCat;
    property p_WrkCtrCode: string    read m_WrkCtrCode;
  end;

  TMQMMacSetupList = class(TMQMCustomList)
  public
    destructor  Destroy; override;
    function AddIssuedArt(MacSetupRec: TMacSetup; IssuedArtRec: TIssuedArt): boolean;
    function FindMacSetup(MacSetupRec: TMacSetup): TMQMMachineSetup;
    procedure GetMacSetup(MacSetupRec: TMacSetup; MacSetupList: TList);
    procedure GetIssuedArtList(MacSetupRec: TMacSetup; var ArtList: TMQMIssuedArtList);
    function  FindArtToRefresh(ArtType : string; ArtCode : string; NetGroup : string) : boolean;
  end;

  TMQMIssuedArtList = class(TMQMCustomList)
  public
    m_CreanMemory : boolean;
    constructor Create(CleanMemory : boolean);
    destructor  Destroy; override;
    function AddArt(IssuedArtRec: PTIssuedArt): boolean;
    function FindIssuedArt(AternativeCode: string; Article: TMQMArticle; NetGroup: TMQMNetGroup;
                           IssueCode: string; SeqIssuedTo: string): PTIssuedArt;
  end;

  TMQMBchUMList = class(TMQMCustomList)
  public
    function   AddItem(UM : string; multiplier : double) : boolean;
    destructor Destroy; override;
    procedure  Clear;
    function   GetListUms : TStringList;
    function   GetMultiplierForUM(Um : string ; var Multiplier : double): boolean;
  end;


implementation

uses

 FMAutoSched;

{
******************************* TMQMMacSetupList *******************************
}

function TMQMMacSetupList.AddIssuedArt(MacSetupRec: TMacSetup; IssuedArtRec: TIssuedArt): boolean;
var
  MachineSetup: TMQMMachineSetup;
begin
  Result := false;

  MachineSetup := FindMacSetup(MacSetupRec);
  if not Assigned(MachineSetup) then
  begin
    MachineSetup := TMQMMachineSetup.Create(MacSetupRec);
    AddItem(MachineSetup);
    Result := true;
  end;

//  if IssuedArtRec.RequiredQty > 0 then
  if IssuedArtRec.RequiredQty <> 0 then
    Result := MachineSetup.m_IssuedArtList.AddArt(@IssuedArtRec);

end;

//----------------------------------------------------------------------------//

destructor TMQMMacSetupList.Destroy;
begin
//  for i := p_Count - 1 downto 0 do
//    TMQMMachineSetup(p_Item[i]).Free;

  inherited destroy;
end;

//----------------------------------------------------------------------------//

function TMQMMacSetupList.FindMacSetup(MacSetupRec: TMacSetup): TMQMMachineSetup;
//Find if a record like this is already existing
var
  i: integer;
  TmpMacSetup: TMQMMachineSetup;
begin
  Result := nil;

  for i := 0 to p_count -1 do
  begin
    TmpMacSetup := TMQMMachineSetup(p_Item[i]);
    if  (TmpMacSetup.m_WrkCtrCode       = MacSetupRec.WrkCtrCode)
    and (TmpMacSetup.m_ResCat           = MacSetupRec.ResCat)
    and (TmpMacSetup.m_ResCode          = MacSetupRec.ResCode)
    and (TmpMacSetup.m_MachineSetupCode = MacSetupRec.MachineSetupCode) then
    begin
      Result := TmpMacSetup;
        exit
    end;
  end;

end;

//----------------------------------------------------------------------------//

procedure TMQMMacSetupList.GetMacSetup(MacSetupRec: TMacSetup; MacSetupList: TList);
var
  i: integer;
  TmpMacSetup: TMQMMachineSetup;

  procedure AddSetup(MacSetup: TMQMMachineSetup);
  begin
    if MacSetupList.IndexOf(MacSetup) = -1 then
      MacSetupList.Add(MacSetup);
  end;
begin
  for i := 0 to p_count -1 do
  begin
    TmpMacSetup := TMQMMachineSetup(p_Item[i]);
    if  (TmpMacSetup.m_WrkCtrCode       = '')
    and (TmpMacSetup.m_ResCat           = '')
    and (TmpMacSetup.m_ResCode          = MacSetupRec.ResCode)
    and (TmpMacSetup.m_MachineSetupCode = MacSetupRec.MachineSetupCode) then
      AddSetup(TmpMacSetup);
  end;

  for i := 0 to p_count -1 do
  begin
    TmpMacSetup := TMQMMachineSetup(p_Item[i]);
    if  (TmpMacSetup.m_WrkCtrCode       = '')
    and (TmpMacSetup.m_ResCat           = '')
    and (TmpMacSetup.m_ResCode          = MacSetupRec.ResCode)
    and (TmpMacSetup.m_MachineSetupCode = '') then
      AddSetup(TmpMacSetup);
  end;

  for i := 0 to p_count -1 do
  begin
    TmpMacSetup := TMQMMachineSetup(p_Item[i]);
    if  (TmpMacSetup.m_WrkCtrCode       = MacSetupRec.WrkCtrCode)
    and (TmpMacSetup.m_ResCat           = MacSetupRec.ResCat)
    and (TmpMacSetup.m_ResCode          = '')
    and (TmpMacSetup.m_MachineSetupCode = '') then
      AddSetup(TmpMacSetup);
  end;

  for i := 0 to p_count -1 do
  begin
    TmpMacSetup := TMQMMachineSetup(p_Item[i]);
    if  (TmpMacSetup.m_WrkCtrCode       = '')
    and (TmpMacSetup.m_ResCat           = MacSetupRec.ResCat)
    and (TmpMacSetup.m_ResCode          = '')
    and (TmpMacSetup.m_MachineSetupCode = '') then
      AddSetup(TmpMacSetup);
  end;

  for i := 0 to p_count -1 do
  begin
    TmpMacSetup := TMQMMachineSetup(p_Item[i]);
    if  (TmpMacSetup.m_WrkCtrCode       = MacSetupRec.WrkCtrCode)
    and (TmpMacSetup.m_ResCat           = '')
    and (TmpMacSetup.m_ResCode          = '')
    and (TmpMacSetup.m_MachineSetupCode = '') then
      AddSetup(TmpMacSetup);
  end;

  for i := 0 to p_count -1 do
  begin
    TmpMacSetup := TMQMMachineSetup(p_Item[i]);
    if  (TmpMacSetup.m_WrkCtrCode       = '')
    and (TmpMacSetup.m_ResCat           = '')
    and (TmpMacSetup.m_ResCode          = '')
    and (TmpMacSetup.m_MachineSetupCode = '') then
      AddSetup(TmpMacSetup);
  end;

end;

//----------------------------------------------------------------------------//

procedure TMQMMacSetupList.GetIssuedArtList(MacSetupRec: TMacSetup; var ArtList: TMQMIssuedArtList);
var
  i: integer;
  TmpMacSetup: TMQMMachineSetup;
  TmpIssArt: PTIssuedArt;
  Found: boolean;
begin
  Found := false;
  TmpMacSetup := nil;
  if not assigned(p_GetList) then exit;

  for i := 0 to p_count -1 do
  begin
    TmpMacSetup := TMQMMachineSetup(p_Item[i]);
    if  (trim(TmpMacSetup.m_WrkCtrCode)       = '')
    and (trim(TmpMacSetup.m_ResCat)           = '')
    and (trim(TmpMacSetup.m_ResCode)          = trim(MacSetupRec.ResCode))
    and (trim(TmpMacSetup.m_MachineSetupCode) = trim(MacSetupRec.MachineSetupCode)) then
    begin
      Found := true;
      break
    end;
  end;

  if Found then
    for i := 0 to TmpMacSetup.m_IssuedArtList.p_count -1 do
    begin
      TmpIssArt := PTIssuedArt(TmpMacSetup.m_IssuedArtList.p_Item[i]);
      if Assigned(FAutoSched) then
      begin
        if not TmpIssArt.Article.p_IgnoreCheck then
          ArtList.AddArt(TmpIssArt)
      end
      else
        ArtList.AddArt(TmpIssArt)
    end;

  Found := false;
  for i := 0 to p_count -1 do
  begin
    TmpMacSetup := TMQMMachineSetup(p_Item[i]);
    if  (trim(TmpMacSetup.m_WrkCtrCode)       = '')
    and (trim(TmpMacSetup.m_ResCat)           = '')
    and (trim(TmpMacSetup.m_ResCode)          = trim(MacSetupRec.ResCode))
    and (trim(TmpMacSetup.m_MachineSetupCode) = '') then
    begin
      Found := true;
      break
    end;
  end;

  if Found then
    for i := 0 to TmpMacSetup.m_IssuedArtList.p_count -1 do
    begin
      TmpIssArt := PTIssuedArt(TmpMacSetup.m_IssuedArtList.p_Item[i]);
      if Assigned(FAutoSched) then
      begin
        if not TmpIssArt.Article.p_IgnoreCheck then
          ArtList.AddArt(TmpIssArt)
      end
      else
        ArtList.AddArt(TmpIssArt)
    end;

  Found := false;
  for i := 0 to p_count -1 do
  begin
    TmpMacSetup := TMQMMachineSetup(p_Item[i]);
    if  (trim(TmpMacSetup.m_WrkCtrCode)       = trim(MacSetupRec.WrkCtrCode))
    and (trim(TmpMacSetup.m_ResCat)           = trim(MacSetupRec.ResCat))
    and (trim(TmpMacSetup.m_ResCode)          = '')
    and (trim(TmpMacSetup.m_MachineSetupCode) = '') then
    begin
      Found := true;
      break
    end;
  end;

  if Found then
    for i := 0 to TmpMacSetup.m_IssuedArtList.p_count -1 do
    begin
      TmpIssArt := PTIssuedArt(TmpMacSetup.m_IssuedArtList.p_Item[i]);
      if Assigned(FAutoSched) then
      begin
        if not TmpIssArt.Article.p_IgnoreCheck then
          ArtList.AddArt(TmpIssArt)
      end
      else
        ArtList.AddArt(TmpIssArt)
    end;

  Found := false;
  for i := 0 to p_count -1 do
  begin
    TmpMacSetup := TMQMMachineSetup(p_Item[i]);
    if  (trim(TmpMacSetup.m_WrkCtrCode)       = '')
    and (trim(TmpMacSetup.m_ResCat)           = trim(MacSetupRec.ResCat))
    and (trim(TmpMacSetup.m_ResCode)          = '')
    and (trim(TmpMacSetup.m_MachineSetupCode) = '') then
    begin
      Found := true;
      break
    end;
  end;

  if Found then
    for i := 0 to TmpMacSetup.m_IssuedArtList.p_count -1 do
    begin
      TmpIssArt := PTIssuedArt(TmpMacSetup.m_IssuedArtList.p_Item[i]);
      if Assigned(FAutoSched) then
      begin
        if not TmpIssArt.Article.p_IgnoreCheck then
          ArtList.AddArt(TmpIssArt)
      end
      else
        ArtList.AddArt(TmpIssArt)
    end;

  Found := false;
  for i := 0 to p_count -1 do
  begin
    TmpMacSetup := TMQMMachineSetup(p_Item[i]);
    if  (trim(TmpMacSetup.m_WrkCtrCode)       = trim(MacSetupRec.WrkCtrCode))
    and (trim(TmpMacSetup.m_ResCat)           = '')
    and (trim(TmpMacSetup.m_ResCode)          = '')
    and (trim(TmpMacSetup.m_MachineSetupCode) = '') then
    begin
      Found := true;
      break
    end;
  end;

  if Found then
    for i := 0 to TmpMacSetup.m_IssuedArtList.p_count -1 do
    begin
      TmpIssArt := PTIssuedArt(TmpMacSetup.m_IssuedArtList.p_Item[i]);
      if Assigned(FAutoSched) then
      begin
        if not TmpIssArt.Article.p_IgnoreCheck then
          ArtList.AddArt(TmpIssArt)
      end
      else
        ArtList.AddArt(TmpIssArt)
    end;

  Found := false;
  for i := 0 to p_count -1 do
  begin
    TmpMacSetup := TMQMMachineSetup(p_Item[i]);
    if  (trim(TmpMacSetup.m_WrkCtrCode)       = '')
    and (trim(TmpMacSetup.m_ResCat)           = '')
    and (trim(TmpMacSetup.m_ResCode)          = '')
    and (trim(TmpMacSetup.m_MachineSetupCode) = '') then
    begin
      Found := true;
      break
    end;
  end;

  if Found then
    for i := 0 to TmpMacSetup.m_IssuedArtList.p_count -1 do
    begin
      TmpIssArt := PTIssuedArt(TmpMacSetup.m_IssuedArtList.p_Item[i]);
      if Assigned(FAutoSched) then
      begin
        if not TmpIssArt.Article.p_IgnoreCheck then
          ArtList.AddArt(TmpIssArt)
      end
      else
        ArtList.AddArt(TmpIssArt)
    end;

end;

function  TMQMMacSetupList.FindArtToRefresh(ArtType : string; ArtCode : string; NetGroup : string) : boolean;
var
  i, J: integer;
  TmpMacSetup: TMQMMachineSetup;
  TmpIssArt: PTIssuedArt;
begin
  Result := false;
  for i := 0 to p_count -1 do
  begin
    TmpMacSetup := TMQMMachineSetup(p_Item[i]);
    for J := 0 to TmpMacSetup.m_IssuedArtList.p_count -1 do
    begin
      TmpIssArt := PTIssuedArt(TmpMacSetup.m_IssuedArtList.p_Item[J]);
      if (TmpIssArt.Article.p_ArtType.p_ArtTypeCode = ArtType) and
         (TmpIssArt.Article.p_ArtCode = ArtCode) and
         (TmpIssArt.NetGroup.m_Code = NetGroup) then
      begin
        Result := true;
        Exit
      end;
    end;
  end;
end;


{
****************************** TMQMMachineSetup *******************************
}
constructor TMQMMachineSetup.Create(MacSetupRec: TMacSetup);
begin
  inherited Create;

  m_WrkCtrCode       := MacSetupRec.WrkCtrCode;
  m_ResCat           := MacSetupRec.ResCat;
  m_ResCode          := MacSetupRec.ResCode;
  m_MachineSetupCode := MacSetupRec.MachineSetupCode;
  m_IssuedArtList    := TMQMIssuedArtList.Create(true);
end;

//----------------------------------------------------------------------------//

procedure TMQMMachineSetup.Clear;
var
  i: integer;
begin
  for i := m_IssuedArtList.p_Count - 1 downto 0 do
    Dispose(PTIssuedArt(m_IssuedArtList.p_Item[i]));

  m_IssuedArtList.CleanList;
end;

//----------------------------------------------------------------------------//

destructor TMQMMachineSetup.Destroy;
var
  i: integer;
begin
  for i := m_IssuedArtList.p_Count - 1 downto 0 do
    Dispose(PTIssuedArt(m_IssuedArtList.p_Item[i]));

  m_IssuedArtList.CleanList;
  m_IssuedArtList.Free;

  inherited Destroy;
end;

{
****************************** TMQMIssuedArtList *******************************
}

function TMQMIssuedArtList.AddArt(IssuedArtRec: PTIssuedArt): boolean;
var
  IssuedArt: PTIssuedArt;
begin
  Result := false;
  IssuedArt := FindIssuedArt(IssuedArtRec.AternativeCode, IssuedArtRec.Article, IssuedArtRec.NetGroup,
                             IssuedArtRec.IssueTransType, IssuedArtRec.SeqIssuedTo);

  if not assigned(IssuedArt) then
  begin
    New(IssuedArt);
    IssuedArt.AternativeCode   := IssuedArtRec.AternativeCode;
    IssuedArt.Article          := IssuedArtRec.Article;
    IssuedArt.NetGroup         := IssuedArtRec.NetGroup;
    IssuedArt.IssueTransType   := IssuedArtRec.IssueTransType;
    IssuedArt.SeqIssuedTo      := IssuedArtRec.SeqIssuedTo;
    IssuedArt.ArtOnBalance     := IssuedArtRec.ArtOnBalance;
    IssuedArt.RequiredQty      := IssuedArtRec.RequiredQty;
    IssuedArt.IssuedQty        := IssuedArtRec.IssuedQty;
    IssuedArt.AllocatedQty     := IssuedArtRec.AllocatedQty;
    IssuedArt.ClosedIssue      := IssuedArtRec.ClosedIssue;
    IssuedArt.HighAllocDate    := IssuedArtRec.HighAllocDate;
    IssuedArt.StepId           := IssuedArtRec.StepId;
    IssuedArt.SearchMatByAlloc := IssuedArtRec.SearchMatByAlloc;
    IssuedArt.lastTimeBalanceChecked := IssuedArtRec.lastTimeBalanceChecked;
    IssuedArt.HaveEnoughBalance   := IssuedArtRec.HaveEnoughBalance;
//    IssuedArt.MaterialAlreadyChecked := IssuedArtRec.MaterialAlreadyChecked;
    IssuedArt.IssuedArtPointer := IssuedArtRec;
    AddItem(IssuedArt);

    if IssuedArt.HaveEnoughBalance then
       IssuedArt.IssuedQty := IssuedArt.IssuedQty;

    Result := true;
  end;
end;

//----------------------------------------------------------------------------//

constructor TMQMIssuedArtList.Create(CleanMemory: boolean);
begin
  inherited create;
  m_CreanMemory := CleanMemory;
end;

//----------------------------------------------------------------------------//

destructor TMQMIssuedArtList.Destroy;
var
  I : Integer;
begin
  if m_CreanMemory then
  begin
    for i := p_Count - 1 downto 0 do
      Dispose(PTIssuedArt(p_Item[i]));
  end;

  inherited destroy;
end;

//----------------------------------------------------------------------------//

function TMQMIssuedArtList.FindIssuedArt(AternativeCode: string; Article: TMQMArticle; NetGroup: TMQMNetGroup;
                                         IssueCode: string; SeqIssuedTo: string): PTIssuedArt;
var
  i: integer;
  TmpIssuedArt: PTIssuedArt;
begin
  Result := nil;

  for i := 0 to p_count-1 do
  begin
    TmpIssuedArt := p_Item[i];
    if  (TmpIssuedArt.AternativeCode = AternativeCode)
    and (TmpIssuedArt.Article = Article)
    and (TmpIssuedArt.NetGroup = NetGroup)
    and (TmpIssuedArt.IssueTransType = IssueCode)
    and (TmpIssuedArt.SeqIssuedTo = SeqIssuedTo) then
    begin
      Result := TmpIssuedArt;
      exit
    end
  end;

end;

//  ******************  Bch UM Class **************************************

destructor TMQMBchUMList.Destroy;
var
  I : Integer;
begin
  for i := p_Count - 1 downto 0 do
    Dispose(PTBchUM(p_Item[i]));
  inherited Destroy;
end;

//------------------------------------------------------------------------------

function TMQMBchUMList.AddItem(UM : string; multiplier : double) : boolean;
var
  BchUM : PTBchUM;
begin
  Result := true;
  New(BchUM);
  BchUM.BchUM := UM;
  BchUM.MULTIPILR_TO_BATCH_UM := multiplier;
  inherited AddItem(BchUM)
end;

//------------------------------------------------------------------------------

procedure TMQMBchUMList.Clear;
var
  I : Integer;
begin
  for i := p_Count - 1 downto 0 do
    Dispose(PTBchUM(p_Item[i]));
  CleanList;
end;

//------------------------------------------------------------------------------

function TMQMBchUMList.GetMultiplierForUM(Um : string ; var Multiplier : double): boolean;
var
  I : Integer;
begin
  Result := false;
  for I := 0 to p_Count - 1 do
  begin
    if UpperCase(PTBchUM(p_Item[i]).BchUM) = UpperCase(UM) then
    begin
      Multiplier := PTBchUM(p_Item[i]).MULTIPILR_TO_BATCH_UM;
      Result := true;
      Exit;
    end;
  end;
end;

//------------------------------------------------------------------------------

function TMQMBchUMList.GetListUms : TStringList;
var
  I : Integer;
begin
  Result := nil;
  for I := 0 to p_Count - 1 do
  begin
    if PTBchUM(p_Item[i]).BchUM <> '' then
    begin
      if not assigned(Result) then
        Result := TStringList.Create;
      Result.Add(PTBchUM(p_Item[i]).BchUM);
    end;
  end;
end;

//------------------------------------------------------------------------------

end.
