unit FMDispoDet;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UMSchedContFunc,
  Grids, ComCtrls, StdCtrls, ExtCtrls, Buttons;

type
  TDispoDet = class(TForm)
    Panel1: TPanel;
    STProdReq: TStaticText;
    LblProdreq: TLabel;
    LblWcSDispoCode: TLabel;
    STDiv: TStaticText;
    STDisCod: TStaticText;
    LblDispoCode: TLabel;
    STBachCod: TStaticText;
    STBatchRePro: TStaticText;
    LblBatchCode: TLabel;
    LblBatchRePro: TLabel;
    BitBtn1: TBitBtn;
    procedure FormCreate(Sender: TObject);
  private
    m_Id : TSchedId;
    procedure DisplayDispo;
  public
    constructor CreateDispoDet(AOwner : TComponent ; Id : TSchedId);
  end;

implementation

{$R *.DFM}

uses
  gnugettext,
  UMSchedCont,
  UMTblDesc,
  UMObjCont,
  DMsrvPc,
  UGGlobal;

// -------------------------------------------------------------------------- //

constructor TDispoDet.CreateDispoDet(AOwner: TComponent; Id: TSchedId);
begin
  inherited Create(AOwner);
   ScaleFormSize(Self, Screen.PixelsPerInch);
  TranslateComponent (self);
  m_Id := Id;
end;

// -------------------------------------------------------------------------- //

procedure TDispoDet.DisplayDispo;
var
  qry: TMqmQuery;
  trs: TMqmTransaction;
  tbInfo: ^TTblInfo;
  ProdNo : string;
  Save_Cursor : TCursor;
begin
  Save_Cursor := Screen.Cursor;
  Screen.Cursor  := crAppStart;

  ProdNo := p_sc.GetFldDescr(m_id, CSC_ProdReq, false);

  tbInfo := @tblInfo[tbl_prod_req];
  SetFldPfx(tbInfo.pfx);

  trs := CreateTransaction(Main_DB, true);
  qry := CreateQuery(trs, Main_DB);

  qry.Transaction.Active := true;
  qry.SQL.Clear;
  qry.SQL.Add('select * from ' + tbInfo.PCname + ' where ' + CreatePfxFld(fli_preqNo) + '=''' + ProdNo + '''');
  qry.open;

  STProdReq.Caption := ProdNo;
  STDisCod.Caption := qry.FieldByName(CreatePfxFld(fli_dispoCode)).AsString;
  STDiv.Caption := qry.FieldByName(CreatePfxFld(fli_divCode)).AsString;
  STBachCod.Caption := qry.FieldByName(CreatePfxFld(fli_bch)).AsString;
  STBatchRePro.Caption := IntToStr(qry.FieldByName(CreatePfxFld(fli_reprocNo)).AsInteger);

  Screen.Cursor := Save_Cursor;

  qry.Close;
  trs.Commit;

  trs.free;
  qry.Free;

end;

// -------------------------------------------------------------------------- //

procedure TDispoDet.FormCreate(Sender: TObject);
begin
  TranslateComponent (self);
  DisplayDispo
end;

// -------------------------------------------------------------------------- //
end.
