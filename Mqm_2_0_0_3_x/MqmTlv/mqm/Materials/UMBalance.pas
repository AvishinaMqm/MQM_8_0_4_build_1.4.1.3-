unit UMBalance;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, UGCustomList, UMSchedContFunc;

type
  ArProdNature = (Ar_NotBalance, Ar_Material, Ar_MatWithDet, Ar_AddRes, Ar_AddRes_ManPower,Ar_AddRes_Capacity);

  CBalRecType = (brt_NoDet,    // Without Details
                 brt_WithDet);    // step

  CBalanceType = (bt_Entry, bt_EntryExp, bt_Issue, bt_IssueByAlloc, bt_Expiration);

  CCheckBalanceMethod = (Cbm_JobEntriesOnly, Cbm_FromFirstJobEntry, Cbm_FromFirstEntry);

  CArtOnBalance = (aob_Normal, aob_ReqNumber, aob_DisplayOnly);

  TRecBalanceInfo = record
    JobID          : TSchedId;
    dtStartBalance : TDateTime;
    dtEndBalance   : TDateTime;
    QtyToSched     : double;
    QtyBobbinRest  : double;
  end;
  PTrecBalanceInfo = ^TRecBalanceInfo;

  TRecBobbin = record
    Code: string;
    Desc: string;
    DueDate: TDateTime;
    Qty: double;
  end;
  PTRecBobbin = ^TRecBobbin;

  TArtBalance = record
    BalanceType: CBalanceType;     //bt_Entry
    DueDate: TDateTime;
    JobID: TSchedId;
    BobinCode: string;          //occupy
    Description: string;
    Quantity: Double;
    RecType: CBalRecType;       //if find on BD = withDet also NoDet
    ToRequest: string;          //''
    TotalBal: double;           //0
    TotExpBal: double;          //0
    TotExpUsed: double;          //0
    RealQty: double;          //0
  end;
  PTArtBalance = ^TArtBalance;

  TReqBalance = record
    BalanceType: CBalanceType;     //bt_Entry
    DueDate: TDateTime;
    JobID: TSchedId;
    Step: Integer;              //-1
    Quantity: Double;
    TotalBal: double;           //0
    TotExpBal: double;          //0
    TotExpUsed: double;          //0
    RealQty: double;          //0
  end;
  PTReqBalance = ^TReqBalance;

  TBalancePoints = record
    BPJobID: TSchedId;
    BPType: CBalanceType;
    BPDate: TDateTime;
    BPQuantity: Double;

  end;
  PTBalancePoints = ^TBalancePoints;

  TMQMArtBalanceList = class(TMQMCustomList)
  private
    m_TotUpdForReq: string;
    m_TotUpdForJob: TSchedId;
    m_TotalsUpdated: boolean;
    m_TotalsUpdatedForJob : TSchedId;
    procedure ClearBalanceForJob(ID: TSchedId);
    procedure ClearList;
//    procedure SortBalanceList;
    function  EnoughMatOnDate(StrDate: TDateTime; ReqQty: currency): boolean;
    function  EnoughMatForJob(ForRequest: string; ForJob: TSchedId; TolleranceQuantity : double): boolean;
    procedure UpdateBalanceTotals(ForRequest: string; ForJob: TSchedId);
  public
    destructor Destroy; override;
    procedure AddBalance(recBalance: TArtBalance);
    procedure SortBalanceList;
  end;

  TMQMRequestBalList = class(TMQMCustomList)
  private
    m_TotUpdForStep: integer;
    m_TotalsUpdated: boolean;
  public
    destructor Destroy; override;
    procedure UpdateBalanceTotals(ForStep: integer; ExcludeID: TSchedId);
    procedure SortBalanceList;
    procedure AddBalance(JobID: TSchedID; Step: integer; BalanceType: CBalanceType;
                                        dtBalance: TDateTime; dQty: double);
    procedure ClearBalanceForJob(ID: TSchedId);
  end;

  TMQMBobbinList = class(TMQMCustomList)
  private
    m_Code: string;
    m_Desc: string;
    procedure ClearBalanceForJob(ID: TSchedId);
    procedure ClearList;
  public
    destructor Destroy; override;
    procedure AddBobbin(recBobbin: PTRecBobbin);
    procedure RecalcBalance(BalanceInfo: PTRecBalanceInfo; Lst: TMQMArtBalanceList);
  end;

  TMQMNetGroup = class
    constructor Create(sNetGroupCode: string);// recArticle: TRecArticle);
    destructor  Destroy; override;
  public
    m_Code: string;
    m_ArtNature: ArProdNature;
    m_BalanceList: TMQMArtBalanceList;
    m_BobbinsList: TMQMBobbinList;
    m_lastBalanceUpdatedTime : TDateTime;
    procedure AddBalance(JobID: TSchedID; BalanceType: CBalanceType;
                         dtStBalance, dtEndBalance, dQty: double);
    procedure ClearBalanceForJob(ID: TSchedId);
    procedure GetListNotAvailPos(const GrpLstIds : TList; ID: TSchedId; var LstPos: TList; LocRec: Pointer; ReqQty: currency; StdPurcOrProdTime : integer);
    procedure UpdateBalanceTotals(ForRequest: string; ForJob: TSchedId);
    procedure ClearBalanceLists;
    function EnoughMatOnDate(ForRequest: string; ForJob: TSchedId;
                         StrDate: TDateTime; ReqQty: currency): boolean;
    function EnoughMatForJobOrFamily(ForRequest: string; ForJob: TSchedId; ProductNatureMaterial : boolean; TolleranceQuantity : double): boolean;
    property p_Code: string read m_Code;
  end;

  TMQMNetGroupList = class(TMQMCustomList)
    destructor Destroy; override;
  public
    m_ArtNature: ArProdNature;
    function AddNetGroup(sNetGroupCode: string; recBalance: TArtBalance;
                         recBobbin: PTRecBobbin): TMQMNetGroup;
    function FindNetGroup(sNetGroupCode: string; var Index : Integer): TMQMNetGroup;
  end;

  // Handle balance points

  procedure AddToBalancePoints(BPJobID: TSchedID; BPType: CBalanceType; BPDate: TDateTime; BPQuantity: double);
  procedure ClearBalancePoints;
 // function  GetBalancePointsCount : integer;
  procedure FindNegativeBalance(ForJob : TSchedID; CheckBalanceMethod : CCheckBalanceMethod; var NegativeQuantity: double; IgnoreExpire : boolean);
  Procedure SortBalancePoints;
  procedure GetBalancePoint(Index : integer;
                            var BPJobID: TSchedID;
                            var BPType: CBalanceType;
                            var BPDate : TDateTime;
                            var BPQuantity : double);
  type
  TDetailRows = record
    Date:         String;
    Quantity:     Double;
    TotalBal:     Double;
    description:  String;
    FromHeader:   boolean;
    Artbalance:   pointer;
    NetGroupPtr : TMQMNetGroup;
    ProductCode : string;
    ArtType     : string;
    DateTime    : TDateTime;
  end;
  PTDetailRows = ^TDetailRows;

implementation

uses
  UMObjCont,
  UMBobbins,
  UMCommon,
  UMSchedOnPlan,
  UMSchedCont;

type

  TMQMBalancePoints = class
    destructor Destroy; override;
    constructor Create;
    procedure CleareBalancePoints;
  private
    m_BalancePoints : TList;
    function  GetListCount : Integer;
//    function  GetBalanceStatus : Boolean;
    procedure AddToBalancePoints(BPJobID: TSchedID; BPType: CBalanceType; BPDate: TDateTime; BPQuantity: double);
    procedure GetBalancePoint(Index : integer;
                            var BPJobID: TSchedID;
                            var BPType: CBalanceType;
                            var BPDate : TDateTime;
                            var BPQuantity : double);
    //    procedure GetBalancePoint(Index : integer; var BalncePointDate : TDateTime; var BalncePointQty : double);
  end;

var
  MQMBalancePoints : TMQMBalancePoints;

//----------------------------------------------------------------------------//

function SortArtBalance(Item1, Item2: Pointer): integer;
var
  pd1, pd2: PTArtBalance;
begin
  pd1 := PTArtBalance(Item1);
  pd2 := PTArtBalance(Item2);

  if pd1.DueDate = pd2.DueDate then
    if pd1.BalanceType = pd2.BalanceType then
      Result :=  0
    else
      if pd1.BalanceType > pd2.BalanceType then
        Result := 1
      else
        Result := -1
  else
    if pd1.DueDate < pd2.DueDate then
      Result := -1
    else
      Result :=  1
end;

//----------------------------------------------------------------------------//

function SortReqBalance(Item1, Item2: Pointer): integer;
var
  pd1, pd2: PTReqBalance;
begin
  pd1 := PTReqBalance(Item1);
  pd2 := PTReqBalance(Item2);

  if pd1.DueDate = pd2.DueDate then
  begin
    if pd1.BalanceType = pd2.BalanceType then
      Result := 0
    else
      if pd1.BalanceType < pd2.BalanceType then
        Result := -1
      else
        Result :=  1
  end else
    if pd1.DueDate < pd2.DueDate then
      Result := -1
    else
      Result :=  1
end;

//----------------------------------------------------------------------------//

function SortBalPoints(Item1, Item2: Pointer): integer;
var
  pd1, pd2: PTBalancePoints;
begin
  pd1 := PTBalancePoints(Item1);
  pd2 := PTBalancePoints(Item2);

  if pd1.BPDate = pd2.BPDate then
  begin
    if pd1.BPType = pd2.BPType then
      Result := 0
    else
      if pd1.BPType < pd2.BPType then
        Result := -1
      else
        Result :=  1
  end else
    if pd1.BPDate < pd2.BPDate then
      Result := -1
    else
      Result :=  1
end;

{
******************************* TMQMBalanceList ********************************
}

{
******************************* TMQMArtBalanceList ********************************
}

procedure TMQMArtBalanceList.AddBalance(recBalance: TArtBalance);
var
  BalanceRec : PTArtBalance;
begin
  if recBalance.DueDate <=  0 then Exit;

  m_TotalsUpdated := false;

  New(BalanceRec);
  BalanceRec.BalanceType := recBalance.BalanceType;
  BalanceRec.DueDate     := recBalance.DueDate;
  RoundDateTime(BalanceRec.DueDate);
  BalanceRec.JobID       := recBalance.JobID;
  BalanceRec.BobinCode   := recBalance.BobinCode;
  BalanceRec.Description := recBalance.Description;
  BalanceRec.Quantity    := recBalance.Quantity;
  BalanceRec.RecType     := recBalance.RecType;
  BalanceRec.ToRequest   := recBalance.ToRequest;
  BalanceRec.TotalBal    := recBalance.TotalBal;
  BalanceRec.TotExpBal   := recBalance.TotExpBal;
  BalanceRec.TotExpUsed  := recBalance.TotExpUsed;
  BalanceRec.RealQty     := recBalance.RealQty;

  AddItem(BalanceRec);
end;

//----------------------------------------------------------------------------//

procedure TMQMArtBalanceList.ClearBalanceForJob(ID: TSchedId);
var
  i: integer;
  BalanceRec: PTArtBalance;
begin
  m_TotalsUpdated := false;
  for i := p_count-1 downto 0 do
  begin
    BalanceRec := (p_Item[i]);
    if BalanceRec.JobID = ID then
    begin
      RemoveItem(BalanceRec);

      try
        BalanceRec.Description := 'dispose';
      finally
      if Assigned(BalanceRec) then
      begin
        Dispose(BalanceRec);   // Deallocation
        BalanceRec := nil;     // Prevent double-dispose
      end;
      end;

    //  Dispose(BalanceRec)
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TMQMArtBalanceList.ClearList;
var
  i: integer;
  BalanceRec: PTArtBalance;
begin
  m_TotalsUpdated := false;
  for i := p_count-1 downto 0 do
  begin
    BalanceRec := (p_Item[i]);
    RemoveItem(BalanceRec);
    Dispose(BalanceRec)
  end;
end;

//----------------------------------------------------------------------------//

destructor TMQMArtBalanceList.Destroy;
begin
  inherited destroy;
end;

//----------------------------------------------------------------------------//

procedure TMQMArtBalanceList.UpdateBalanceTotals(ForRequest: string; ForJob: TSchedId);
var
  i: integer;
  BalanceRec: PTArtBalance;
  TotalBal, TotalExpire,
  ExpireUsed, TransQty: currency;
  AllBalance_ToRequest_Blank : boolean;
begin
  if m_TotalsUpdated and (m_TotalsUpdatedForJob = ForJob) then exit;

  SortBalanceList;

  TotalBal := 0;
  TotalExpire := 0;
  ExpireUsed := 0;
  TransQty := 0;

  m_TotUpdForReq := ForRequest;
  m_TotUpdForJob := ForJob;
  AllBalance_ToRequest_Blank := true;

  for i := 0 to p_count-1 do
  begin
    BalanceRec := (p_Item[i]);
    if (BalanceRec.ToRequest <> '') then AllBalance_ToRequest_Blank := false;
    if (BalanceRec.ToRequest = ForRequest)
    or ((BalanceRec.ToRequest <> ForRequest) and (BalanceRec.ToRequest = '')) then
    begin
      if (ForJob = CSchedIDnull) or (BalanceRec.JobID <> ForJob) then
      begin
        TransQty := BalanceRec.Quantity;
        case BalanceRec.BalanceType of
          bt_Entry        : begin
                              TotalBal := TotalBal + TransQty;
                            end;
          bt_EntryExp     : begin
                              TotalExpire := TotalExpire + TransQty;
                              TotalBal := TotalBal + TransQty;
                            end;
          bt_Issue,
          bt_IssueByAlloc : begin
                              TotalBal := TotalBal - TransQty;
                              if TransQty < TotalExpire then
                              begin
                                ExpireUsed  := ExpireUsed + TransQty;
                                TotalExpire := TotalExpire - TransQty;
                              end else
                              begin
                                ExpireUsed  := ExpireUsed + TotalExpire;
                                TotalExpire := 0;
                              end;
                            end;
          bt_Expiration   : begin
                              if TransQty >= ExpireUsed then
                              begin
                                TransQty := TransQty - ExpireUsed;
                                ExpireUsed := 0;
                              end else
                              begin
                                ExpireUsed := ExpireUsed - TransQty;
                                TransQty := 0;
                              end;
                              TotalBal := TotalBal - TransQty;
                              TotalExpire := TotalExpire - TransQty;
                            end;
        end;
      end;
    end;

//    if TotalBal < 0 then
//      BalanceRec.TotalBal := 0
//    else
      BalanceRec.TotalBal := TotalBal;

    BalanceRec.TotExpBal  := TotalExpire;
    BalanceRec.TotExpUsed := ExpireUsed;
    BalanceRec.RealQty    := TransQty
  end;

  if AllBalance_ToRequest_Blank then
  begin
    m_TotalsUpdatedForJob := ForJob;
    m_TotalsUpdated := true;
  end;
end;

//----------------------------------------------------------------------------//

function TMQMArtBalanceList.EnoughMatOnDate(StrDate: TDateTime; ReqQty: currency): boolean;
var
  i: integer;
  BalanceRec: PTArtBalance;
  Quantity: double;
begin
  Quantity := 0;

  for i := 0 to p_count-1 do
  begin
    BalanceRec := (p_Item[i]);
    if BalanceRec.DueDate <= StrDate then
      Quantity := BalanceRec.TotalBal
    else
      break;
  end;

  Result := Quantity >= ReqQty;
end;

//----------------------------------------------------------------------------//

function TMQMArtBalanceList.EnoughMatForJob(ForRequest: string; ForJob: TSchedId; TolleranceQuantity : double): boolean;
var
  i: integer;
  BalanceRec: PTArtBalance;
  LastDateTime : TDateTime;
  CurrentJobInLastDateTime, NoBalanceInLastDateTime : boolean;
begin
  Result := True;
  LastDateTime := 0;
  CurrentJobInLastDateTime := false;
  NoBalanceInLastDateTime := false;

  for i := 0 to p_count-1 do
  begin
    BalanceRec := (p_Item[i]);

    if (BalanceRec.DueDate <> LastDateTime) then
    begin
      LastDateTime := BalanceRec.DueDate;
      CurrentJobInLastDateTime := false;
      NoBalanceInLastDateTime := false;
    end;

    if  (BalanceRec.JobID = ForJob)
    and ((BalanceRec.BalanceType = bt_Issue) or
         (BalanceRec.BalanceType = bt_IssueByAlloc)) then
         CurrentJobInLastDateTime := true;

    if NoBalanceInLastDateTime and CurrentJobInLastDateTime then
    begin
      Result := false;
      break;
    end;

//    if BalanceRec.TotalBal >= 0 then continue;
    if BalanceRec.TotalBal >= (0 - TolleranceQuantity) then continue;
    if (BalanceRec.BalanceType <> bt_Issue)
    and (BalanceRec.BalanceType <> bt_IssueByAlloc) then continue;

    NoBalanceInLastDateTime := true;

    if (not CurrentJobInLastDateTime) then continue;

    Result := false;
    break;
  end;

end;

//----------------------------------------------------------------------------//

procedure TMQMArtBalanceList.SortBalanceList;
begin
  SortList(SortArtBalance);
end;

{
******************************* TMQMRequestBalList ********************************
}

procedure TMQMRequestBalList.AddBalance(JobID: TSchedID; Step: integer; BalanceType: CBalanceType;
                                        dtBalance: TDateTime; dQty: double);
var
  BalanceRec : PTReqBalance;
begin
//Gives problemis when calculating overlaps
//  if dtBalance <=  0 then Exit;

  m_TotalsUpdated := false;

  New(BalanceRec);
  BalanceRec.BalanceType := BalanceType;
  BalanceRec.DueDate     := dtBalance;
  RoundDateTime(BalanceRec.DueDate);
  BalanceRec.JobID       := JobID;
  BalanceRec.Step        := Step;
  BalanceRec.Quantity    := dQty;
  BalanceRec.TotalBal    := 0;
  BalanceRec.TotExpBal   := 0;
  BalanceRec.TotExpUsed  := 0;
  BalanceRec.RealQty     := 0;

  AddItem(BalanceRec);

end;

//----------------------------------------------------------------------------//

procedure TMQMRequestBalList.ClearBalanceForJob(ID: TSchedId);
var
  i: integer;
  BalanceRec: PTReqBalance;
begin
  for i := p_count-1 downto 0 do
  begin
    BalanceRec := (p_Item[i]);
    if BalanceRec.JobID = ID then
    begin
      RemoveItem(BalanceRec);
      Dispose(BalanceRec)
    end;
  end;
end;

destructor TMQMRequestBalList.Destroy;
var
  I : integer;
begin
  for i := p_count-1 downto 0 do
    dispose(PTReqBalance(p_Item[i]));
  CleanList;
  inherited Destroy;
end;

//----------------------------------------------------------------------------//

procedure TMQMRequestBalList.UpdateBalanceTotals(ForStep: integer; ExcludeID: TSchedId);
var
  i: integer;
  BalanceRec: PTReqBalance;
  TotalBal, TotalExpire,
  ExpireUsed, TransQty: double;
begin
  TotalBal := 0;
  TotalExpire := 0;
  ExpireUsed := 0;

  m_TotUpdForStep := ForStep;

  for i := 0 to p_count-1 do
  begin
    BalanceRec := (p_Item[i]);
    TransQty := 0;
    if (BalanceRec.Step = ForStep)
    and (BalanceRec.JobID <> ExcludeID) then
    begin
      TransQty := BalanceRec.Quantity;
      case BalanceRec.BalanceType of
        bt_Entry        : begin
                            TotalBal := TotalBal + TransQty;
                          end;
        bt_EntryExp     : begin
                            TotalExpire := TotalExpire + TransQty;
                            TotalBal := TotalBal + TransQty;
                          end;
        bt_Issue,
        bt_IssueByAlloc : begin
                            TotalBal := TotalBal - TransQty;
                            if TransQty < TotalExpire then
                            begin
                              ExpireUsed  := ExpireUsed + TransQty;
                              TotalExpire := TotalExpire - TransQty;
                            end else
                            begin
                              ExpireUsed  := ExpireUsed + TotalExpire;
                              TotalExpire := 0;
                            end;
                          end;
        bt_Expiration   : begin
                            if TransQty >= ExpireUsed then
                            begin
                              TransQty := TransQty - ExpireUsed;
                              ExpireUsed := 0;
                            end else
                            begin
                              ExpireUsed := ExpireUsed - TransQty;
                              TransQty := 0;
                            end;
                            TotalBal := TotalBal - TransQty;
                            TotalExpire := TotalExpire - TransQty;
                          end;
      end;
    end;

//    if TotalBal < 0 then
//      BalanceRec.TotalBal := 0
//    else
      BalanceRec.TotalBal := TotalBal;

    BalanceRec.TotExpBal := TotalExpire;
    BalanceRec.TotExpUsed := ExpireUsed;
    BalanceRec.RealQty    := TransQty
  end;

  m_TotalsUpdated := true;
end;

//----------------------------------------------------------------------------//

procedure TMQMRequestBalList.SortBalanceList;
begin
  SortList(SortReqBalance);
end;

//----------------------------------------------------------------------------//
{
******************************* TMQMBobbinList *******************************
}

procedure TMQMBobbinList.AddBobbin(recBobbin: PTRecBobbin);
var
  Bobbin : TBobbinObj;
begin
  m_Code := recBobbin.Code;
  m_Desc := recBobbin.Desc;
  Bobbin := TBobbinObj.CreateBobbin(recBobbin.DueDate, recBobbin.Qty);
  AddItem(Bobbin);
end;

//----------------------------------------------------------------------------//

procedure TMQMBobbinList.ClearBalanceForJob(ID: TSchedId);
var
  i : integer;
  Bobbin : TBobbinObj;
begin
  for i := 0 to p_count-1 do
  begin
    Bobbin := p_Item[i];
    Bobbin.ClearBalanceForJob(ID);
  end;
end;

//----------------------------------------------------------------------------//

procedure TMQMBobbinList.ClearList;
var
  i : integer;
  Bobbin : TBobbinObj;
begin
  for i := p_count-1 downto 0 do
  begin
    Bobbin := p_Item[i];
    RemoveItem(Bobbin);
    Bobbin.Free;
  end;
end;

//----------------------------------------------------------------------------//

destructor TMQMBobbinList.Destroy;
begin
  inherited destroy;
end;

//----------------------------------------------------------------------------//

function SortStrList(List: TStringList; Index1, Index2: Integer): Integer;
var
  planInfo1, PlanInfo2: TSQplanInfo;
begin

{
Index1 and Index2 are indexes of the items in List to compare.

The callback returns

  a value less than 0 if the string identified by Index1 comes before the string identified by Index2
	0 if the two strings are equivalent
	a value greater than 0 if the string with Index1 comes after the string identified by Index2.
}

  Result := 0;

  if StrToInt(List.Strings[Index1]) = StrToInt(List.Strings[Index2]) then exit;

  p_sc.GetPlanInfo(StrToInt(List.Strings[Index1]), planInfo1);
  p_sc.GetPlanInfo(StrToInt(List.Strings[Index2]), planInfo2);

  if planinfo1.startDate < planinfo2.startDate then
    Result := -1
  else
    if planinfo1.startDate < planinfo2.startDate then
      Result := 1;

end;

//----------------------------------------------------------------------------//

procedure TMQMBobbinList.RecalcBalance(BalanceInfo: PTRecBalanceInfo; Lst: TMQMArtBalanceList);
var
  i : integer;
  BobbinObj: TBobbinObj;
  TmpQty: double;
  tmpLst : TStringList;
  OldJob: TSchedID;
begin

  TmpQty := BalanceInfo.QtyToSched;
  TmpLst := TStringList.Create;

  for i := 0 to p_count-1 do
  begin
    BobbinObj := TBobbinObj(p_Item[i]);
    BobbinObj.AddBalIfBobbinIsAvail(true, BalanceInfo.JobID, BalanceInfo.dtStartBalance,
                     BalanceInfo.dtEndBalance, TmpQty, BalanceInfo.QtyBobbinRest, TmpLst);
    if TmpQty <= 0 then Break
  end;

  if TmpQty <= 0 then
    for i := 0 to p_count-1 do
    begin
      BobbinObj := TBobbinObj(p_Item[i]);
      BobbinObj.AddBalIfBobbinIsAvail(false, BalanceInfo.JobID, BalanceInfo.dtStartBalance,
                    BalanceInfo.dtEndBalance, BalanceInfo.QtyToSched, BalanceInfo.QtyBobbinRest, TmpLst);
      if BalanceInfo.QtyToSched <= 0 then Break
    end;

  if TmpLst.Count > 0 then
  begin
    tmpLst.CustomSort(SortStrList);
    OldJob := CSchedIDnull;
    for i := 0 to TmpLst.Count -1 do
      if OldJob = StrToInt(TmpLst.Strings[i]) then
        continue
      else
      begin
        OldJob := StrToInt(TmpLst.Strings[i]);
        p_sc.UpdateBalance(OldJob);
      end;
  end;

  TmpLst.Free;
end;

{
******************************* TMQMNetGroupList *******************************
}

destructor TMQMNetGroupList.Destroy;
var
  i : integer;
  NetGroup: TMQMNetGroup;
begin
  for i := p_count -1 downto 0 do
  begin
    NetGroup := TMQMNetGroup(p_Item[i]);
    RemoveItem(NetGroup);
    NetGroup.Free;
  end;
  inherited destroy
end;

//----------------------------------------------------------------------------//

function TMQMNetGroupList.AddNetGroup(sNetGroupCode: string; recBalance: TArtBalance;
                                      recBobbin: PTRecBobbin): TMQMNetGroup;
var
  Index : integer;
begin
  result := TMQMNetGroup(FindNetGroup(sNetGroupCode, Index));

  if not Assigned(result) then
  begin
    result := TMQMNetGroup.Create(sNetGroupCode);
    result.m_ArtNature := m_ArtNature;
    Insert(Index, Result);
   // AddItem(result)
  end;

  if Assigned(recBobbin) and (recBobbin.Code <> '') then
    Result.m_BobbinsList.AddBobbin(recBobbin);

  result.m_BalanceList.AddBalance(recBalance);

end;

//----------------------------------------------------------------------------//

function TMQMNetGroupList.FindNetGroup(sNetGroupCode: string; var Index : Integer): TMQMNetGroup;
var
  i: integer;
  L, H: integer;
  Found: boolean;
begin
  Result := nil;

  Found := false;

  L := 0;
  H := p_count - 1;

  while (L <= H) and not Found do
  begin
    i := (H-L) div 2;
    if i < L then i := L+i;
    if i > H then i := H-i;

    if (sNetGroupCode < TMQMNetGroup(p_Item[i]).m_Code) then
      H := i - 1
    else
    begin
      if (sNetGroupCode > TMQMNetGroup(p_Item[i]).m_Code) then
        L := i + 1
      else
      begin
        Result := TMQMNetGroup(p_Item[i]);
        Found := true;
        Index := i;
        Assert(Result.m_Code = sNetGroupCode);
      end;
    end;
  end;

  Index := p_count;
  if not found then
  begin
    for H := 0 to p_count - 1 do
    begin
      if (sNetGroupCode < TMQMNetGroup(p_Item[H]).p_Code) then
      begin
        Index := H;
        break
      end;
    end;
  end;


end;

{
******************************* TMQMNetGroup **********************************
}

constructor TMQMNetGroup.Create(sNetGroupCode: string);// recBalance: TrecTBalance);
begin
  Inherited create;
  m_BalanceList := TMQMArtBalanceList.Create;
  m_BobbinsList := TMQMBobbinList.Create;
  m_Code := sNetGroupCode;
  m_ArtNature := Ar_NotBalance;
end;

//----------------------------------------------------------------------------//

destructor TMQMNetGroup.Destroy;
var
  i : integer;
  BobbinObj : TBobbinObj;
  recBalance: PTArtBalance;
begin
  for i := m_BalanceList.p_count - 1 downto 0 do
  begin
    recBalance := m_BalanceList.p_Item[i];
    m_BalanceList.RemoveItem(recBalance);
    Dispose(recBalance);
  end;

  m_BalanceList.Free;
  m_BalanceList := nil;

  for i := m_BobbinsList.p_count - 1 downto 0 do
  begin
    BobbinObj := TBobbinObj(m_BobbinsList.p_Item[i]);
    m_BobbinsList.RemoveItem(BobbinObj);
    BobbinObj.Free;
  end;
  m_BobbinsList.Free;
  m_BobbinsList := nil;

  inherited Destroy;
end;

//----------------------------------------------------------------------------//

procedure TMQMNetGroup.AddBalance(JobID: TSchedID; BalanceType: CBalanceType;
                                  dtStBalance, dtEndBalance, dQty: double);

  procedure WriteRec(JobID: integer; BalanceType: CBalanceType;
                     dtStBalance, dtEndBalance, dQty: double);
  var
    recArtBalance : PTArtBalance;
  begin
    New(recArtBalance);

    recArtBalance.JobID       := JobID;
    recArtBalance.BalanceType := BalanceType;
    recArtBalance.DueDate     := dtStBalance; //TDateTime;
    RoundDateTime(recArtBalance.DueDate);
    recArtBalance.BobinCode   := ''; //string;          //occupy
    recArtBalance.Description := ''; //string;
    recArtBalance.Quantity    := dQty; //Double;
    recArtBalance.RecType     := brt_NoDet; //CBalRecType;       //if find on BD = withDet also NoDet
    recArtBalance.ToRequest   := ''; //string;          //''
    recArtBalance.TotalBal    := 0; //double;           //0
    recArtBalance.TotExpBal   := 0; //double;          //0
    recArtBalance.TotExpUsed  := 0; //double;          //0
    recArtBalance.RealQty     := 0; //double;          //0

    m_BalanceList.AddItem(recArtBalance);
  end;
var
  BalanceInfo : PTRecBalanceInfo;
begin

  // fp - follow instruction is put for avoid writing balance of job
  //      with due date 0. This happen when abort a movement on Gantt
  if (JobID <> CSchedIDnull) and (dtStBalance = 0) then
    exit;

  m_lastBalanceUpdatedTime := now;
  New(BalanceInfo);

  if m_ArtNature = Ar_MatWithDet then
  begin
    BalanceInfo.JobID          := JobID;
    BalanceInfo.dtStartBalance := dtStBalance;
    RoundDateTime(BalanceInfo.dtStartBalance);
    BalanceInfo.dtEndBalance   := dtEndBalance;
    RoundDateTime(BalanceInfo.dtEndBalance);
    BalanceInfo.QtyToSched     := dQty;
    BalanceInfo.QtyBobbinRest  := 0;

    m_BobbinsList.RecalcBalance(BalanceInfo, m_BalanceList);

    if BalanceInfo.QtyBobbinRest > 0 then
    begin
      dQty := dQty + BalanceInfo.QtyBobbinRest;
      WriteRec(JobID, bt_Entry, dtEndBalance, dtEndBalance, BalanceInfo.QtyBobbinRest)
    end;
  end;

  WriteRec(JobID, BalanceType, dtStBalance, dtEndBalance, dQty);

  Dispose(BalanceInfo);
end;

//----------------------------------------------------------------------------//

procedure TMQMNetGroup.UpdateBalanceTotals(ForRequest: string; ForJob: TSchedId);
begin
  m_BalanceList.UpdateBalanceTotals(ForRequest, ForJob);
end;

//----------------------------------------------------------------------------//

procedure TMQMNetGroup.ClearBalanceLists;
begin
  m_lastBalanceUpdatedTime := now;
  m_BobbinsList.ClearList;
  m_BalanceList.ClearList;
end;

//----------------------------------------------------------------------------//

procedure TMQMNetGroup.ClearBalanceForJob(ID: TSchedId);
begin
  m_lastBalanceUpdatedTime := now;
  m_BalanceList.ClearBalanceForJob(ID);
  m_BobbinsList.ClearBalanceForJob(ID);
end;

//----------------------------------------------------------------------------//

function TMQMNetGroup.EnoughMatOnDate(ForRequest: string; ForJob: TSchedId;
                         StrDate: TDateTime; ReqQty: currency): boolean;
begin
  m_BalanceList.UpdateBalanceTotals(ForRequest, ForJob);
  Result := m_BalanceList.EnoughMatOnDate(StrDate, ReqQty)
end;

//----------------------------------------------------------------------------//

function TMQMNetGroup.EnoughMatForJobOrFamily(ForRequest: string; ForJob: TSchedId; ProductNatureMaterial : boolean; TolleranceQuantity : double): boolean;
begin
  m_BalanceList.UpdateBalanceTotals(ForRequest, -1);
  Result := m_BalanceList.EnoughMatForJob(ForRequest, ForJob, TolleranceQuantity);
end;

//----------------------------------------------------------------------------//

procedure TMQMNetGroup.GetListNotAvailPos(const GrpLstIds : TList;ID: TSchedId; var LstPos: TList;
                                          LocRec: Pointer; ReqQty: currency; StdPurcOrProdTime : integer);
var
  BalRec: PTArtBalance;
  i,G: integer;
  AvaliRec: PTAvailRec;
  OldDate: TDateTime;
  ProgQty: currency;
  JobSon : TSCProdSched;
  SameSonId : boolean;
begin
  SameSonId := false;
  m_BalanceList.SortBalanceList;

  OldDate := 0;
  ProgQty  := 0;

  for i := 0 to m_BalanceList.p_count-1 do
  begin
    BalRec := m_BalanceList.p_Item[i];

 //  if (BalRec.JobID = ID) and (BalRec.BalanceType = bt_Issue) then continue;
 // Itzik 070906

    if assigned(GrpLstIds) then
    begin
      SameSonId := false;
      for G := 0 to GrpLstIds.Count - 1 do
      begin
        JobSon := TSCProdSched(GrpLstIds[G]);
        if (JobSon.m_Id = BalRec.JobID) then
        begin
          SameSonId := true;
          break
        end;
      end;
    end;

    if Assigned(GrpLstIds) and SameSonId then
      continue
    else
      if (BalRec.JobID = ID) then continue;  //  Itzik 070906

    if BalRec.DueDate <> OldDate then
    begin
      new(AvaliRec);
      AvaliRec.LocRec      := LocRec;
      AvaliRec.Date        := OldDate;
      AvaliRec.Avail       := ProgQty >= ReqQty;
      AvaliRec.UpToDateQuantity := ProgQty;
      AvaliRec.StdPurcOrProdTime := StdPurcOrProdTime;
      LstPos.Add(AvaliRec);
      OldDate := BalRec.DueDate;
    end;

    case BalRec.BalanceType of
      bt_Entry, bt_EntryExp : ProgQty := ProgQty + BalRec.Quantity;
      bt_Issue, bt_Expiration : ProgQty := ProgQty - BalRec.Quantity;
//        bt_IssueByAlloc
    end;

  end;

  new(AvaliRec);
  AvaliRec.LocRec      := LocRec;
  AvaliRec.Date        := OldDate;
  AvaliRec.Avail       := ProgQty >= ReqQty;
  AvaliRec.UpToDateQuantity := ProgQty;
  AvaliRec.StdPurcOrProdTime := StdPurcOrProdTime;
  LstPos.Add(AvaliRec);
end;

//----------------------------------------------------------------------------//

procedure AddToBalancePoints(BPJobID: TSchedID; BPType: CBalanceType; BPDate: TDateTime; BPQuantity: double);
begin
  MQMBalancePoints.AddToBalancePoints(BPJobID,BPType,BPDate,BPQuantity);
end;

//----------------------------------------------------------------------------//

procedure ClearBalancePoints;
begin
  MQMBalancePoints.CleareBalancePoints;
end;

//----------------------------------------------------------------------------//

procedure SortBalancePoints;
begin
   MQMBalancePoints.m_BalancePoints.Sort(SortBalPoints);
end;

//----------------------------------------------------------------------------//

procedure GetBalancePoint(Index : integer;
                            var BPJobID: TSchedID;
                            var BPType: CBalanceType;
                            var BPDate : TDateTime;
                            var BPQuantity : double);
begin
  MQMBalancePoints.GetBalancePoint(Index, BPJobID, BPType, BPDate, BPQuantity);
end;

//----------------------------------------------------------------------------//

{ TMQMBalancePoints }

//----------------------------------------------------------------------------//

procedure TMQMBalancePoints.AddToBalancePoints(BPJobID: TSchedID; BPType: CBalanceType; BPDate: TDateTime; BPQuantity: double);
var
  BalancePoints : PTBalancePoints;
begin
  New(BalancePoints);
  BalancePoints.BPJobID    := BPJobID;
  BalancePoints.BPType     := BPType;
  BalancePoints.BPDate     := BPDate;
  RoundDateTime(BalancePoints.BPDate);
  BalancePoints.BPQuantity := BPQuantity;
  m_BalancePoints.Add(BalancePoints);
end;

//----------------------------------------------------------------------------//

procedure TMQMBalancePoints.CleareBalancePoints;
var
  I : Integer;
begin
  for I := 0 to m_BalancePoints.Count - 1 do
    dispose(PTBalancePoints(m_BalancePoints[I]));
  m_BalancePoints.Clear;
end;

//----------------------------------------------------------------------------//

constructor TMQMBalancePoints.Create;
begin
  m_BalancePoints := TList.Create;
end;

//----------------------------------------------------------------------------//

destructor TMQMBalancePoints.Destroy;
begin
  CleareBalancePoints;
  m_BalancePoints.free;
  inherited destroy;
end;

//----------------------------------------------------------------------------//

procedure TMQMBalancePoints.GetBalancePoint(Index : integer;
                            var BPJobID: TSchedID;
                            var BPType: CBalanceType;
                            var BPDate : TDateTime;
                            var BPQuantity : double);
begin
  BPJobID  := PTBalancePoints(m_BalancePoints[Index]).BPJobID;
  BPType  := PTBalancePoints(m_BalancePoints[Index]).BPType;
  BPDate  := PTBalancePoints(m_BalancePoints[Index]).BPDate;
  BPQuantity  := PTBalancePoints(m_BalancePoints[Index]).BPQuantity;
end;

//----------------------------------------------------------------------------//

function TMQMBalancePoints.GetListCount: Integer;
begin
  Result := m_BalancePoints.Count;
end;

//----------------------------------------------------------------------------//

procedure FindNegativeBalance (ForJob: TSchedId; CheckBalanceMethod : CCheckBalanceMethod; var NegativeQuantity : Double; IgnoreExpire : boolean);
var
  i: integer;
  TotalBal, TotalExpire,
  ExpireUsed, TransQty: Currency;
  BalancePointCount : Integer;
  BPJobID: TSchedID;
  BPType: CBalanceType;
  BPDate : TDateTime;
  BPQuantity : Currency;
  QtyTemp : Double;
  JobStarted : boolean;
begin
  TotalBal := 0;
  TotalExpire := 0;
  ExpireUsed := 0;
  BalancePointCount := MQMBalancePoints.GetListCount;
  NegativeQuantity := 0;
  JobStarted := false;

  for i := 0 to BalancePointCount - 1 do
  begin
    GetBalancePoint(i, BPJobID, BPType, BPDate, QtyTemp);
    if IgnoreExpire and (BPType = bt_Expiration) then continue;

    BPQuantity := QtyTemp;

    if (ForJob = BPJobId) then JobStarted := true;

    if (ForJob = BPJobId) and (TotalBal < NegativeQuantity) then
      NegativeQuantity := TotalBal;

    TransQty := BPQuantity;
    case BPType of
      bt_Entry        : begin
                          TotalBal := TotalBal + TransQty;
                        end;
      bt_EntryExp     : begin
                          TotalExpire := TotalExpire + TransQty;
                          TotalBal := TotalBal + TransQty;
                        end;
      bt_Issue,
      bt_IssueByAlloc : begin
                          TotalBal := TotalBal - TransQty;
                          if TransQty < TotalExpire then
                          begin
                            ExpireUsed  := ExpireUsed + TransQty;
                            TotalExpire := TotalExpire - TransQty;
                          end else
                          begin
                            ExpireUsed  := ExpireUsed + TotalExpire;
                            TotalExpire := 0;
                          end;
                        end;
      bt_Expiration   : begin
                          if TransQty >= ExpireUsed then
                          begin
                            TransQty := TransQty - ExpireUsed;
                            ExpireUsed := 0;
                          end else
                          begin
                            ExpireUsed := ExpireUsed - TransQty;
                            TransQty := 0;
                          end;
                          TotalBal := TotalBal - TransQty;
                          TotalExpire := TotalExpire - TransQty;
                        end;
    end;

    if (CheckBalanceMethod = Cbm_FromFirstJobEntry) and (not JobStarted) then continue;
    if (CheckBalanceMethod = Cbm_JobEntriesOnly) and (ForJob <> BPJobId) then continue;
    if (TotalBal >= NegativeQuantity) then continue;
    NegativeQuantity := TotalBal;

  end;
  NegativeQuantity := NegativeQuantity * (-1);
end;

//----------------------------------------------------------------------------//

initialization

  MQMBalancePoints := TMQMBalancePoints.Create;

finalization

  MQMBalancePoints.Free;

end.
