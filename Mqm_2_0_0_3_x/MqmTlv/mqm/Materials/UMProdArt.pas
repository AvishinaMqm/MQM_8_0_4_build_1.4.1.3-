unit UMProdArt;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, UMArticles, UMBalance, UGCustomList;

type
  TProdArt = record
    // Key
    Sequence: string;
    Article: TMQMArticle;
    NetGroup: TMQMNetGroup;
    ToRequest: string;
    // Other
    ArtOnBalance: CArtOnBalance;
    Closed: boolean;
    RequiredQty: Double;
    ProducedQty: Double;
    AllocatedQty: Double;
    StartQty: Double;
    EndQty: Double;
  end;
  PTProdArt = ^TProdArt;

  TMQMProdArtList = class(TMQMCustomList)
  destructor  Destroy; override;
  public
    function AddProdArt(ProdArtRec: TProdArt): boolean;
    function FindProdArtBySeq(sSequence: string): PTProdArt;
  private
    function FindProdArt(ProdArtRec: TProdArt): PTProdArt;
  end;

implementation

{
******************************* TMQMProdArtList ********************************
}

destructor TMQMProdArtList.Destroy;
var
  I : Integer;
begin
  for I := p_count - 1 downto 0 do
     dispose(PTProdArt(p_item[i]));
  inherited destroy;
end;

//----------------------------------------------------------------------------//

function TMQMProdArtList.AddProdArt(ProdArtRec: TProdArt): boolean;
var
  ProdArt: PTProdArt;
begin
  Result := false;

  ProdArt := FindProdArt(ProdArtRec);
  if not Assigned(ProdArt) then
  begin
    New(ProdArt);

    ProdArt.Sequence     := ProdArtRec.Sequence;
    ProdArt.Article      := ProdArtRec.Article;
    ProdArt.NetGroup     := ProdArtRec.NetGroup;
    ProdArt.ToRequest    := ProdArtRec.ToRequest;
    ProdArt.ArtOnBalance := ProdArtRec.ArtOnBalance;
    ProdArt.Closed       := ProdArtRec.Closed;
    ProdArt.RequiredQty  := ProdArtRec.RequiredQty;
    ProdArt.ProducedQty  := ProdArtRec.ProducedQty;
    ProdArt.AllocatedQty := ProdArtRec.AllocatedQty;
    ProdArt.StartQty     := ProdArtRec.StartQty;
    ProdArt.EndQty       := ProdArtRec.EndQty;

    AddItem(ProdArt);
    Result := true;
  end;

end;

//----------------------------------------------------------------------------//

function TMQMProdArtList.FindProdArt(ProdArtRec: TProdArt): PTProdArt;
var
  i : integer;
begin

  for i := 0 to p_count -1 do
  begin
    Result := p_item[i];
    if (Result.Sequence = ProdArtRec.Sequence) and
       (Result.Article = ProdArtRec.Article) and
       (Result.NetGroup = ProdArtRec.NetGroup) and
       (Result.ToRequest = ProdArtRec.ToRequest) then
      exit;
  end;

  Result := nil;
end;

//----------------------------------------------------------------------------//

function TMQMProdArtList.FindProdArtBySeq(sSequence: string): PTProdArt;
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

end.
