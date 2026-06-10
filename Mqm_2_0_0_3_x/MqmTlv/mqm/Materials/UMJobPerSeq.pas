unit UMJobPerSeq;


interface
uses
  Classes, UMArticles, UGCustomList, UMProdArt;
type
 // TProdArt
  TJobPerSeq = record
    // Key
    RequestNo: string;
    Substep: string;
    Reprocess: string;
    id: Integer;
    Sequence: string;
    // Other
    SeqStartQty: double;
    SeqEndQty: double;
  //  SumTotalReqQty: Double;
    SeqPercent: Double;
    SumPerSeqQty: Double;
 //   RequestQty: Double; // qty of the job sequence
    SubStepQty:  Double;
  //  ProducedQty: Double;
  //  AllocatedQty: Double;
  //  Closed:      boolean;
    ProdArticle: PTProdArt;//PTMQMProdArtList; //PTProdArt;
 end;
  PTJobPerSeq = ^TJobPerSeq;

  TMQMJobPerSeqList = class(TMQMCustomList)
  public
    function  AddJobPerSeq(JobPerSeqRec: PTJobPerSeq): boolean;
    function  FindJobPerSeqBySeq(sSequence: string): PTJobPerSeq;
//    procedure CalcSumTotalReqQty(RecJobList: Tlist);
//    function  GetQtyForSeq(RecJobList: Tlist; Sequence: string): double;

  private

  end;

implementation

function TMQMJobPerSeqList.AddJobPerSeq(JobPerSeqRec: PTJobPerSeq): boolean;
var
  JobPerSeq: PTJobPerSeq;
begin
//  Result := false;

    New(JobPerSeq);

    JobPerSeq.RequestNo      := JobPerSeqRec.RequestNo;
    JobPerSeq.Substep        := JobPerSeqRec.Substep;
    JobPerSeq.Reprocess      := JobPerSeqRec.Reprocess;
    JobPerSeq.Sequence       := JobPerSeqRec.Sequence;
    // Other
    JobPerSeq.SeqStartQty    := JobPerSeqRec.SeqStartQty;
    JobPerSeq.SeqEndQty      := JobPerSeqRec.SeqEndQty;
//    JobPerSeq.SumTotalReqQty := JobPerSeqRec.SumTotalReqQty;
    JobPerSeq.SumPerSeqQty   := JobPerSeqRec.SumPerSeqQty;
    JobPerSeq.SeqPercent     := JobPerSeqRec.SeqPercent;
    JobPerSeq.ID             := JobPerSeqRec.id;
//    JobPerSeq.Closed         := JobPerSeqRec.Closed;
    JobPerSeq.ProdArticle    := JobPerSeqRec.ProdArticle;
//    JobPerSeq.RequestQty     := JobPerSeqRec.RequestQty; // qty of the sequence
    JobPerSeq.SubStepQty   :=  JobPerSeqRec.SubStepQty;

    AddItem(JobPerSeq);
    Result := true;
 // end;

end;

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

function TMQMJobPerSeqList.FindJobPerSeqBySeq(sSequence: string): PTJobPerSeq;
var
  ii : integer;
begin

  for ii := 0 to p_count - 1 do
  begin
    Result := p_item[ii];
    if Result.Sequence = sSequence then exit;
  end;

  Result := nil;
end;

//----------------------------------------------------------------------------//

{
// The list here is a small list that holds only the jobs of the same request number
procedure TMQMJobPerSeqList.CalcSumTotalReqQty(RecJobList: Tlist);
var
  j, i : integer;
  JobPerSeqRec: PTJobPerSeq;
  CurSeq: string;
  TotalReqQty,PerSeqQty: double;
  SeqIndex : Integer;
  ProdArticle: PTProdArt;

  procedure StoreSum( CalcTotalQty: boolean);
  var
    j, i, CurSeqCounter: Integer;
    LastSeqQty,  SeqRatio: Double;
  begin
    CurSeqCounter := 0;
    LastSeqQty := 0;

   // loop over all substeps and input into each the total req qty we found
    if CalcTotalQty then
    for j := 0 to RecJobList.Count -1 do
    begin
      JobPerSeqRec := RecJobList.Items[j];
      JobPerSeqRec.SumTotalReqQty := TotalReqQty;
    end; //for

   // loop over all substeps and input into each the total req qty we found
   if (not CalcTotalQty) then //and (CurSeq <>'') then
    for j := 0 to RecJobList.Count -1 do
    begin
      JobPerSeqRec := RecJobList.Items[j];
      for i := 0 to JobPerSeqRec.ProdArticle.p_count -1 do
      begin
        ProdArticle := JobPerSeqRec.ProdArticle.p_Item[i];
        if  (CurSeq = ProdArticle.Sequence) then
        begin
 //       ProdArticle.SumPerSeqQty := PerSeqQty ;
        SeqRatio :=  JobPerSeqRec.SumPerSeqQty / JobPerSeqRec.SumTotalReqQty;

          JobPerSeqRec.SeqStartQty := LastSeqQty;
          if CurSeqCounter = SeqIndex then // This is the last seq
            JobPerSeqRec.SeqEndQty   := JobPerSeqRec.SubStepQty;
          if CurSeqCounter < SeqIndex then // Not the last seq
            JobPerSeqRec.SeqEndQty   := LastSeqQty + SeqRatio * JobPerSeqRec.SubStepQty;
          LastSeqQty := JobPerSeqRec.SeqEndQty;// LastSeqQty + SeqRatio * JobPerSeqRec.SubStepQty;
          CurSeqCounter := CurSeqCounter + 1;
          if CurSeqCounter > SeqIndex then
          begin
            CurSeqCounter := 0;
            LastSeqQty    := 0;
          end;
     //   end;// if > 0
       end// if (CurSeq = JobPerSeqRec.Sequence)
end;// j loop
end;
  end;//procedure

begin
  TotalReqQty := 0;
  PerSeqQty   := 0;
  SeqIndex    := 0;

  // Loop over all Substeps
  for i := 0 to RecJobList.Count -1 do
  begin
    JobPerSeqRec := RecJobList.Items[i];
     // loop over all sequences (produced article)
     for j := 0 to  JobPerSeqRec.ProdArticle.p_count -1 do
      begin
        ProdArticle := JobPerSeqRec.ProdArticle.p_Item[j];
        // get the total required qty
        TotalReqQty := ProdArticle.RequiredQty;

    // get the total required qty
 //   TotalReqQty := JobPerSeqRec.RequiredQty;

    // we should make the sum for the current seq only
   if (SeqIndex = 0) then
      CurSeq  := ProdArticle.Sequence;

   if (CurSeq <> ProdArticle.Sequence) then
    begin
      StoreSum( false );// save the last seq
      CurSeq  := ProdArticle.Sequence;
      PerSeqQty := 0;
      SeqIndex := 0;
    end;//if
      // get the sum per seq qty
      PerSeqQty := PerSeqQty + JobPerSeqRec.SumPerSeqQty;
      SeqIndex := SeqIndex + 1;
  end; //for
  StoreSum( true );
 end;
end;

 }
//----------------------------------------------------------------------------//
{
/Calculates the total qty per sequence. Since we may have 3 entries in mqmqpa
//with the same seq then we must add them all to one qty.
//just in case of a different seq per entry - then we should have a differnet
// qty per seq and substep
//If we have 2 substeps and 3 DIFFERENT sequences then we will have 6 records
//in our class .
//If we have 2 substeps and 3 identical sequences then we will have only 2 records.

function TMQMJobPerSeqList.GetQtyForSeq(RecJobList: Tlist; Sequence: string): double;
var
  i : integer;
  JobPerSeqRec: PTJobPerSeq;
  CurSeq: string;
//  PrevSeq: String;
  TotalReqQty,totalSeqQty: double;
//  SeqIndex : Integer;
//   NoOfSeq   :Integer;// number of different sequences.
begin
  CurSeq   := '';
 // PrevSeq  := '';
//  SeqIndex := 0;
  TotalSeqQty := 0;

  for i:= 0 to RecJobList.Count -1 do
  begin
    JobPerSeqRec := RecJobList.Items[i];
 //   CurSeq       := JobPerSeqRec.Sequence;
    if  (CurSeq = Sequence) then
//      TotalSeqQty := TotalSeqQty + JobPerSeqRec.RequestQty;
  end;
  result := TotalSeqQty;
end;

 }

end.
 