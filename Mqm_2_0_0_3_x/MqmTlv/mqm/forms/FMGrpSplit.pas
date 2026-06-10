unit FMGrpSplit;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UMSchedContFunc, StdCtrls, ExtCtrls, ComCtrls, UMSchedView, UMSchedList,
  UMObjCont, UMOpStack, Buttons, UReShape, Math;

type

  TSplitLine = record
    Count : integer;   // number of new groups for this line
    Qty   : currency;  // quantity per group (in the chosen UM)
  end;
  TSplitLineArray = array of TSplitLine;
  TCurrencyArray  = array of currency;

  TSplitGroupData = record
    Id_Grp     : TSchedId;
    SplitPercent : double;
    NewGrpNr   : integer;
    // exact proportional allocation support (multi-line "By both" + main-UM "By number"/"By quantity")
    MultiLine          : boolean;         // true => carve via the exact proportional allocator using Lines below
    GroupQtyForPercent : currency;        // full group quantity in the chosen UM (for the remainder display)
    Lines              : TSplitLineArray; // (count, qty-per-group) lines, in the chosen UM (main or alternative)
    Conv               : currency;        // MAIN-UM quantity per 1 chosen-UM unit (1.0 for a main-UM split)
    NumDecimals        : integer;         // number of decimals of the MAIN UM (carving precision)
    AbsorbLastGroup    : boolean;         // true (full consumption) => carve all groups except the last;
                                          // the original sub-step-0 group becomes that last group (no 0-qty ghost)
    IsAlternative      : boolean;         // true => balance in the ALTERNATIVE UM using ChildRates below
    ChildRates         : TCurrencyArray;  // per group-son (GetGrpSon order): alternative-UM per 1 MAIN-UM unit
  end;
  PTSplitGroupData = ^TSplitGroupData;

  TGrpSplit = class(TForm)
    PgcGrp: TPageControl;
    PanOp: TPanel;
    BtnOk: TcxButton;
    BtnCanc: TcxButton;
    procedure FormCreate(Sender: TObject);
    procedure BtnCancClick(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
  private
    m_GrpId : TSchedId;
    m_msgError   : string;
//    m_GrpSchedList : TMSchedList;
    m_SplitGroupData : TSplitGroupData;
    m_markStack      : TStackMark;

    procedure CreateNewGroupAndSplit;
  public
    constructor CreateGrpSplit(AOwner : TComponent; SplitGroupData : TSplitGroupData);
    function GetmsgError : string;
    procedure UndoSplitMark;   // roll back the split this object performed (used when applied without the preview window)
  end;

  function SplitGroup(GroupId : TSchedId; SplitJobQty: currency; Use_opStack : boolean): TSchedId;

var
  GrpSplit: TGrpSplit;

implementation

{$R *.dfm}

uses UMPlanFunc, gnugettext;

{ TGrpSplit }

//----------------------------------------------------------------------------//

function SplitGroup(GroupId : TSchedId; SplitJobQty: currency; Use_opStack : boolean) : TSchedId;
var
  EachJobQty, RemainQty: currency;
  NewId, ChildId, m_Newgrp : TSchedID;
  List : TList;
  I,J : Integer;
  value: variant;
  dataType: CBinColValType;
  m_GrpSchedList : TMSchedList;
  DecMult, numSons, bal : integer;
  childId_ : array of TSchedID;
  childQty : TCurrencyArray;            // each son's qty (MAIN UM)
  eachQty  : TCurrencyArray;            // qty to carve from each son for THIS group
  targetMain, allocThis : currency;
  totalAvail, maxAvail, frac : double;
begin
  // Exact proportional split (MAIN UM only). Each son contributes its proportional share of
  // SplitJobQty (rounded to the main-UM precision); the son with the most quantity acts as the
  // balancer and absorbs the rounding remainder, so the new group totals EXACTLY SplitJobQty
  // (e.g. 600, never 599.99). Used by the auto-sequence split (UMAutoSched), the split-across-
  // resources (FMbin) and the occupation-move (FMOccMov). Alternative UM is not handled here -
  // these callers always split by main UM. Progressed qty is intentionally NOT subtracted, to
  // preserve the original behavior of this function.
  Result := CSchedIDnull;
  DecMult := Round(IntPower(10, p_sc.GetJobNumOfDecimals(GroupId)));
  if DecMult <= 0 then DecMult := 1;
  List := nil;
//  p_opStack.MarkStackForButtonUndo('Split Job');
  m_GrpSchedList := TMSchedList.Create(application);
  m_Newgrp := CSchedIDnull;

  numSons := p_sc.GetGrpNumSons(GroupId);
  SetLength(childId_, numSons);
  SetLength(childQty,  numSons);
  SetLength(eachQty,   numSons);

  // requested group quantity, rounded to the main-UM precision
  targetMain := trunc(SplitJobQty * DecMult + 0.5) / DecMult;

  // gather sons + pick the balancer (the son holding the most quantity)
  totalAvail := 0; bal := -1; maxAvail := -1;
  for I := 0 to numSons - 1 do
  begin
    childId_[I] := p_sc.GetGrpSon(GroupId, I);
    p_sc.GetFldValue(childId_[I], CSC_QtyToSched, value, dataType);
    childQty[I] := value;
    totalAvail  := totalAvail + childQty[I];
    if childQty[I] > maxAvail then begin maxAvail := childQty[I]; bal := I; end;
  end;
  if totalAvail <= 0 then totalAvail := 1;   // guard against divide-by-zero
  if bal < 0 then bal := 0;

  // non-balancer sons: proportional share (rounded to nearest), clamped to what the son has
  allocThis := 0;
  for I := 0 to numSons - 1 do
  begin
    if I = bal then continue;
    frac := childQty[I] / totalAvail;
    eachQty[I] := trunc(targetMain * frac * DecMult + 0.5) / DecMult;
    if eachQty[I] > childQty[I] then eachQty[I] := childQty[I];
    if eachQty[I] < 0 then eachQty[I] := 0;
    allocThis := allocThis + eachQty[I];
  end;
  // balancer absorbs the exact remainder so the group totals exactly targetMain
  if numSons > 0 then
  begin
    eachQty[bal] := trunc((targetMain - allocThis) * DecMult + 0.5) / DecMult;
    if eachQty[bal] > childQty[bal] then eachQty[bal] := childQty[bal];
    if eachQty[bal] < 0 then eachQty[bal] := 0;
  end;

  for I := 0 to numSons - 1 do
  begin
    ChildId := childId_[I];

    EachJobQty := eachQty[I];

    RemainQty := childQty[I] - EachJobQty;

    if Use_opStack then
    begin
      p_opStack.SplitJob(ChildId, RemainQty, EachJobQty, 1, NewId, List);

      if I = 0 then
      begin
        for J := 0 to List.Count - 1 do
        begin
          p_opStack.CreateGroup(TSchedId(List[J]), m_Newgrp);
          m_GrpSchedList.AddLink(TschedId(m_Newgrp));
        end
      end
      else
      begin
        for J := 0 to List.count - 1 do
          p_opStack.AddJobToGroup(TSchedId(List[J]), TSchedId(m_GrpSchedList.GetLink(J)));
      end;

    end
    else
    begin

      List := p_sc.SplitJob(ChildId, RemainQty, EachJobQty, 1, NewId);

      if I = 0 then
      begin
        for J := 0 to List.Count - 1 do
        begin
          m_Newgrp := p_sc.CreateGroup(TSchedId(List[J]));
          m_GrpSchedList.AddLink(TschedId(m_Newgrp));
        end
      end
      else
      begin
        for J := 0 to List.count - 1 do
           p_sc.AddJobToGroup(TSchedId(List[J]), m_Newgrp);
      end;

    end;

  end;

  Result := m_Newgrp;

end;

//----------------------------------------------------------------------------//

procedure TGrpSplit.BtnCancClick(Sender: TObject);
begin
  p_opStack.UndoByMark(m_markStack);
  ModalResult := mrCancel;
//  Close;
end;

//----------------------------------------------------------------------------//

procedure TGrpSplit.BtnOkClick(Sender: TObject);
begin
  ModalResult := mrOk;
//  Close;
end;

constructor TGrpSplit.CreateGrpSplit(AOwner : TComponent; SplitGroupData : TSplitGroupData);
begin
  inherited Create(AOwner);
//  m_GrpSchedList := TMSchedList.Create(self);
  m_SplitGroupData := SplitGroupData;
  m_GrpId          := SplitGroupData.Id_Grp;


//  if m_markStack <> -1 then
//    m_markStack := markStack
//  else
//  m_markStack := p_opStack.MarkStack;
  p_opStack.MarkStackForButtonUndo('Split group'); //aviadd

  CreateNewGroupAndSplit;
end;

//----------------------------------------------------------------------------//

procedure TGrpSplit.FormCreate(Sender: TObject);
begin
  ReShape(self);
//  ReShape(BtnOk);
//  ReShape(BtnCanc);
end;

//----------------------------------------------------------------------------//

function TGrpSplit.GetmsgError : string;
begin
  result := m_msgError
end;

//----------------------------------------------------------------------------//

procedure TGrpSplit.UndoSplitMark;
begin
  p_opStack.UndoByMark(m_markStack);
end;

//----------------------------------------------------------------------------//

procedure TGrpSplit.CreateNewGroupAndSplit;
var
  SplitQty, QtyPerJob, OrigJobQty, EachJobQty: currency;
  NewJobNr: integer;
  NewId, ChildId, m_Newgrp : TSchedID;
  Err: string;
  List : TList;
  I,J : Integer;
  value: variant;
  dataType: CBinColValType;
  JobQty : double;
  TabSheet : TTabSheet;
  m_GrpSchedList : TMSchedList;
  ArraySchedList : array of TMSchedList;
  schedListView  : TMSchedListView;
  LineIdx, c, numSons, DecMult, bal, gDone, maxGroups : integer;
  childId_  : array of TSchedID;
  childOrig : TCurrencyArray;   // qty still on the original son (MAIN UM), decremented as we carve
  childAlloc: TCurrencyArray;   // qty still available to carve from the son (MAIN UM)
  childFrac : array of Double;  // son's share of the total available (MAIN UM) - full precision ratio
  cumAlloc  : TCurrencyArray;   // qty carved from the son so far (MAIN UM)
  totalAvail, targetMain, cumTarget, allocThis, pieceNorm, maxAvail, qn, pq : currency;
  grpCreated : boolean;
  childRate, childFracKg : array of Double;   // alt: per-son rate (alt per main) + alt-qty share
  totalAvailAlt, targetAlt, allocAlt, pieceKg : currency;

  // carve `pieceM` (MAIN UM) out of son `idx` into the current new group (creates it on first piece)
  procedure DoCarve(idx: integer; pieceM: currency);
  var k: integer;
  begin
    childOrig[idx]  := childOrig[idx]  - pieceM;
    childAlloc[idx] := childAlloc[idx] - pieceM;
    p_opStack.SplitJob(childId_[idx], childOrig[idx], pieceM, 1, NewId, List);
    if (List <> nil) and (List.Count > 0) then
    begin
      if not grpCreated then
      begin
        p_opStack.CreateGroup(TSchedId(List[0]), m_Newgrp);
        m_GrpSchedList.AddLink(TSchedId(m_Newgrp));
        grpCreated := true;
      end
      else
        p_opStack.AddJobToGroup(TSchedId(List[0]), m_Newgrp);
      for k := 1 to List.Count - 1 do
        p_opStack.AddJobToGroup(TSchedId(List[k]), m_Newgrp);
    end;
  end;

begin
  List := nil;
  m_GrpSchedList := TMSchedList.Create(self);

  if m_SplitGroupData.MultiLine then
  begin
    // Exact proportional allocation. MAIN-UM split: each group is a proportional slice of every
    // demand and one demand absorbs the meter remainder, so the group is exact (4x600, never
    // 599.99). ALTERNATIVE-UM split: because each demand converts at its OWN rate and only meters
    // are stored, fixing the meter total does NOT fix the alt total - so we balance in the
    // ALTERNATIVE UM instead, using the smallest-rate demand as the balancer (finest control) and
    // rounding its meters UP, so every group's RECOMPUTED alt qty meets the requested target.
    DecMult := Round(IntPower(10, m_SplitGroupData.NumDecimals));
    if DecMult <= 0 then DecMult := 1;
    numSons := p_sc.GetGrpNumSons(m_SplitGroupData.Id_Grp);

    SetLength(childId_,  numSons);
    SetLength(childOrig, numSons);
    SetLength(childAlloc,numSons);
    totalAvail := 0;
    for I := 0 to numSons - 1 do
    begin
      childId_[I] := p_sc.GetGrpSon(m_SplitGroupData.Id_Grp, I);
      p_sc.GetFldValue(childId_[I], CSC_QtyToSched, value, dataType); qn := value;
      p_sc.GetFldValue(childId_[I], CSC_ProgQty,    value, dataType); pq := value;
      childOrig[I]  := qn;            // original job qty (progressed part stays on sub-step 0)
      childAlloc[I] := qn - pq;       // only the not-progressed part may be carved out
      if childAlloc[I] < 0 then childAlloc[I] := 0;
      totalAvail    := totalAvail + childAlloc[I];
    end;
    if totalAvail <= 0 then totalAvail := 1;   // guard against divide-by-zero

    // full consumption -> carve every group EXCEPT the last; the original sub-step-0 group keeps
    // that last group's worth (no 0-qty ghost job)
    maxGroups := m_SplitGroupData.NewGrpNr;
    if m_SplitGroupData.AbsorbLastGroup and (maxGroups > 0) then dec(maxGroups);
    gDone := 0;

    if m_SplitGroupData.IsAlternative then
    begin
      // ---- balance in the ALTERNATIVE UM ----
      SetLength(childRate,   numSons);
      SetLength(childFracKg, numSons);
      totalAvailAlt := 0;
      for I := 0 to numSons - 1 do
      begin
        if I <= High(m_SplitGroupData.ChildRates) then
          childRate[I] := m_SplitGroupData.ChildRates[I]
        else
          childRate[I] := 0;
        totalAvailAlt := totalAvailAlt + childAlloc[I] * childRate[I];   // available, in alt UM
      end;
      if totalAvailAlt <= 0 then totalAvailAlt := 1;
      for I := 0 to numSons - 1 do
        childFracKg[I] := (childAlloc[I] * childRate[I]) / totalAvailAlt;

      for LineIdx := 0 to High(m_SplitGroupData.Lines) do
      begin
        if (m_msgError <> '') or (gDone >= maxGroups) then break;
        for c := 1 to m_SplitGroupData.Lines[LineIdx].Count do
        begin
          if gDone >= maxGroups then break;
          targetAlt := m_SplitGroupData.Lines[LineIdx].Qty;   // alt-UM target for this group

          // balancer = available demand with the SMALLEST rate -> finest alt-qty control
          bal := -1;
          for I := 0 to numSons - 1 do
            if (childAlloc[I] > 0.0000001) and (childRate[I] > 0) then
              if (bal < 0) or (childRate[I] < childRate[bal]) then bal := I;
          if bal < 0 then
          begin
            m_msgError := _('Not enough quantity to satisfy the requested split lines');
            break;
          end;

          grpCreated := false;
          m_Newgrp   := CSchedIDnull;
          allocAlt   := 0;

          // non-balancer demands: proportional alt share, carved to MAIN UM (nearest)
          for I := 0 to numSons - 1 do
          begin
            if (I = bal) or (childAlloc[I] <= 0.0000001) or (childRate[I] <= 0) then continue;
            pieceKg   := targetAlt * childFracKg[I];
            pieceNorm := pieceKg / childRate[I];                       // alt -> main (meters)
            pieceNorm := trunc(pieceNorm * DecMult + 0.5) / DecMult;
            if pieceNorm > childAlloc[I] then pieceNorm := childAlloc[I];
            if pieceNorm <= 0 then continue;
            allocAlt := allocAlt + pieceNorm * childRate[I];
            DoCarve(I, pieceNorm);
          end;

          // balancer absorbs the alt remainder; round its meters UP so the recomputed alt qty is
          // always >= the requested target (correct whether the group check truncates or rounds)
          pieceKg := targetAlt - allocAlt;
          if pieceKg > 0 then
          begin
            pieceNorm := pieceKg / childRate[bal];
            pieceNorm := Ceil(pieceNorm * DecMult) / DecMult;
            if pieceNorm > childAlloc[bal] then pieceNorm := childAlloc[bal];
            if pieceNorm > 0 then DoCarve(bal, pieceNorm);
          end;

          inc(gDone);
          if m_msgError <> '' then break;
        end;
        if m_msgError <> '' then break;
      end;
    end
    else
    begin
      // ---- balance in the MAIN UM ----
      SetLength(childFrac, numSons);
      SetLength(cumAlloc,  numSons);
      for I := 0 to numSons - 1 do
      begin
        childFrac[I] := childAlloc[I] / totalAvail;
        cumAlloc[I]  := 0;
      end;

      cumTarget := 0;   // cumulative MAIN-UM target across all groups carved so far
      for LineIdx := 0 to High(m_SplitGroupData.Lines) do
      begin
        if (m_msgError <> '') or (gDone >= maxGroups) then break;
        for c := 1 to m_SplitGroupData.Lines[LineIdx].Count do
        begin
          if gDone >= maxGroups then break;
          targetMain := m_SplitGroupData.Lines[LineIdx].Qty * m_SplitGroupData.Conv;
          targetMain := trunc(targetMain * DecMult + 0.5) / DecMult;
          cumTarget  := cumTarget + targetMain;

          // balancer = the demand with the most quantity still available
          bal := -1; maxAvail := -1;
          for I := 0 to numSons - 1 do
            if (childAlloc[I] > 0.0000001) and (childAlloc[I] > maxAvail) then
            begin
              maxAvail := childAlloc[I];
              bal := I;
            end;
          if bal < 0 then
          begin
            m_msgError := _('Not enough quantity to satisfy the requested split lines');
            break;
          end;

          grpCreated := false;
          m_Newgrp   := CSchedIDnull;
          allocThis  := 0;

          // non-balancer demands: proportional share (cumulative target so it never drifts)
          for I := 0 to numSons - 1 do
          begin
            if (I = bal) or (childAlloc[I] <= 0.0000001) then continue;
            pieceNorm := trunc(cumTarget * childFrac[I] * DecMult + 0.5) / DecMult - cumAlloc[I];
            if pieceNorm > childAlloc[I] then pieceNorm := childAlloc[I];
            if pieceNorm <= 0 then continue;
            cumAlloc[I] := cumAlloc[I] + pieceNorm;
            allocThis   := allocThis   + pieceNorm;
            DoCarve(I, pieceNorm);
          end;

          // balancer absorbs the exact remainder so the group totals exactly targetMain
          pieceNorm := targetMain - allocThis;
          pieceNorm := trunc(pieceNorm * DecMult + 0.5) / DecMult;
          if pieceNorm > childAlloc[bal] then pieceNorm := childAlloc[bal];
          if pieceNorm > 0 then
          begin
            cumAlloc[bal] := cumAlloc[bal] + pieceNorm;
            DoCarve(bal, pieceNorm);
          end;

          inc(gDone);
          if m_msgError <> '' then break;
        end;
        if m_msgError <> '' then break;
      end;
    end;
  end
  else
  begin
    // ---- classic single-line split (By number / By quantity / single By both) ----
    for I := 0 to p_sc.GetGrpNumSons(m_SplitGroupData.Id_Grp) - 1 do
    begin
      ChildId := p_sc.GetGrpSon(m_SplitGroupData.Id_Grp, I);
      p_sc.GetFldValue(ChildId, CSC_QtyToSched, value, dataType);
      JobQty := value;
      SplitQty := JobQty*m_SplitGroupData.SplitPercent;
      m_msgError := '';
      if not CalcSplitQtyGrp(ChildId,0,SplitQty, m_SplitGroupData.NewGrpNr, QtyPerJob, OrigJobQty, EachJobQty, NewJobNr, Err) then
      begin
        m_msgError := Err;
        break;
      end;
      p_opStack.SplitJob(ChildId, OrigJobQty, EachJobQty, NewJobNr, NewId, List);
      if I = 0 then
      begin
        for J := 0 to List.Count - 1 do
        begin
          p_opStack.CreateGroup(TSchedId(List[J]), m_Newgrp);
          m_GrpSchedList.AddLink(TschedId(m_Newgrp));
        end
      end
      else
      begin
        for J := 0 to List.count - 1 do //m_GrpSchedList.GetLinkCount - 1 do
          p_opStack.AddJobToGroup(TSchedId(List[J]), TSchedId(m_GrpSchedList.GetLink(J)));
      end;
    end;
  end;

  SetLength(ArraySchedList, m_GrpSchedList.GetLinkCount);
  for I := 0 to m_GrpSchedList.GetLinkCount - 1 do
  begin
    m_Newgrp := TSchedId(m_GrpSchedList.GetLink(I));
    ArraySchedList[I] := TMSchedList.Create(self);
    for J := 0 to p_sc.GetGrpNumSons(m_Newgrp) - 1 do
    begin
      ChildId := p_sc.GetGrpSon(m_Newgrp, J);
      ArraySchedList[I].AddLink(ChildId);
    end;
     TabSheet := TTabSheet.Create(PgcGrp);
    TabSheet.PageControl := PgcGrp;
    p_sc.GetFldValue(m_Newgrp, CSC_GroupNo, Value, dataType);
    TabSheet.Caption := 'Group' + ' ' + Value;
    schedListView        := TMSchedListView.CreateListView(TabSheet, ArraySchedList[I]);
    schedListView.Parent := TabSheet;
    schedListView.Align  := alClient;
  end;

  p_pl.EnterCompatModeInPlan(m_SplitGroupData.Id_Grp);

end;

//----------------------------------------------------------------------------//

end.
