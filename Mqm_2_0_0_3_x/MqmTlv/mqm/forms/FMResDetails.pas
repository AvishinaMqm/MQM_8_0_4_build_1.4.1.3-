unit FMResDetails;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls, UReShape,
  UMres;

type
  TFResDetails = class(TForm)
    PanBtn: TPanel;
    PGCres: TPageControl;
    TBgen: TTabSheet;
    TBprop: TTabSheet;
    TBrulesRtoO: TTabSheet;
    BtnOk: TBitBtn;
    TBrulesOtoO: TTabSheet;
    Panel1: TPanel;
    StCode: TStaticText;
    STLDescr: TStaticText;
    LblResCode: TLabel;
    LblResDescr: TLabel;
    STWcCod: TStaticText;
    STResCatCod: TStaticText;
    STWcLDesc: TStaticText;
    LblWcCode: TLabel;
    LblWcSDescCode: TLabel;
    LblWcLDescCode: TLabel;
    STSDesc: TStaticText;
    LblWcLDesc: TLabel;
    LblCatDesc: TLabel;
    LblCalCod: TLabel;
    STCalCod: TStaticText;
    STStndBachSize: TStaticText;
    LblStndBachSize: TLabel;
    Label1: TLabel;
    STMinBatchSize: TStaticText;
    LblMaxBatchSize: TLabel;
    STMaxBatchSize: TStaticText;
    LblBatchSizeUm: TLabel;
    STBatchUm: TStaticText;
    STBachUmDesc: TStaticText;
    LblNumResCompo: TLabel;
    STNumResCompo: TStaticText;
    STResCatCodDesc: TStaticText;
    LblBatchGroupCode: TLabel;
    StTxBatchGroupCode: TStaticText;
    LblSingleMaxBatch: TLabel;
    StTxSingleMaxBatch: TStaticText;
    LBLPropOptimumMaxMultiplier: TLabel;
    StaticPropOptimumMaxMultiplier: TStaticText;
    BtnCanc: TcxButton;
    StaticPropMinMultiplier: TStaticText;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure BtnCancClick(Sender: TObject);
    procedure PGCresDrawTab(Control: TCustomTabControl; TabIndex: Integer;
      const Rect: TRect; Active: Boolean);
  public
    constructor CreateResDet(AOwner: TComponent; Subres: TMqmVisibleRes);
  private
    m_res: TMqmRes;
    m_subres : TMqmVisibleRes;
    procedure InitValues;
  end;

implementation

{$R *.DFM}

uses
  gnugettext,
  UMUsrPropComp,
  UMWkCtr,
  UGGlobal;

//----------------------------------------------------------------------------//

procedure TFResDetails.BtnCancClick(Sender: TObject);
begin
  Close
end;

constructor TFResDetails.CreateResDet(AOwner: TComponent; Subres: TMqmVisibleRes);
begin
  inherited Create(AOwner);

 // Height := 400;
 // Width := 550;

  m_subres := Subres;
  m_res := TMqmRes(Subres.p_father);
end;

//----------------------------------------------------------------------------//

procedure TFResDetails.FormCreate(Sender: TObject);
var
  lst: TList;
begin
  ScaleFormSize(Self, Screen.PixelsPerInch);
  TranslateComponent (self);
  InitValues;
  lst := TList.Create;
  m_res.GetPropMtxs(lst, true);
  m_res.m_resCat.GetPropMtxs(lst);

  TMUsrPropComp.CreatePropComp(TBprop,      m_res.m_ResCat.p_ResCatCode, lst,     false, false);
//  TMUsrPropComp.CreatePropComp(TBrulesRtoO, m_res.GetRulesRtoOMtxs, true,  false);
//  TMUsrPropComp.CreatePropComp(TBrulesOtoO, m_res.GetRulesOtoOMtxs, true,  true)

  ReShape(self);
 // ReShape(btnCanc);
end;

//----------------------------------------------------------------------------//

procedure TFResDetails.InitValues;
begin
  // initialize valued fields
  StCode.Caption   := m_res.p_ResCode;
  StLDescr.Caption := m_res.p_ResLDesc;
  STSDesc.Caption  :=  m_res.p_ResSDesc;

  STWcCod.Caption        := TMqmWrkCtr(m_res.p_Father).p_WrkCtrCode;
  STWcLDesc.Caption      := TMqmWrkCtr(m_res.p_Father).p_WrkCtrLDesc;
  STResCatCod.Caption    := m_res.m_ResCat.p_ResCatCode;
  STCalCod.Caption       := m_subres.p_CalCod;
  STStndBachSize.Caption := FloatToStr(m_res.p_Sndt_bch_Size);
  STMinBatchSize.Caption := FloatToStr(m_res.p_Min_bch_size);
  STMaxBatchSize.Caption := FloatToStr(m_res.p_Max_bch_size);
  STBatchUm.Caption      := m_res.p_BchUM;

  if TMqmRes(m_res).p_ONE_BATCH_MACHINE_By_GROUP_CODE then
  begin
    LblMaxBatchSize.Caption := _('Dual machine max batch size');
    Width := Width  + 70;
    STMaxBatchSize.left := 589
  end
  else
  begin
    LblSingleMaxBatch.Visible  := false;
    StTxSingleMaxBatch.Visible := false;
    LblBatchGroupCode.Visible  := false;
    StTxBatchGroupCode.Visible := false;
  end;

  StTxBatchGroupCode.Caption := TMqmRes(m_res).GET_GROUP_CODE_FOR_ONE_BATCH_MACHINE;
  StTxSingleMaxBatch.Caption := FloatToStr(TMqmRes(m_res).p_Single_Max_bch_size);
  StaticPropMinMultiplier.Caption := TMqmRes(m_res).P_PropCodeMinMultiplier;
  StaticPropOptimumMaxMultiplier.Caption := TMqmRes(m_res).P_PropCodeOptimumMaxMultiplier;

  STNumResCompo.Caption  := IntToStr(m_res.p_ResComp)
end;

procedure TFResDetails.PGCresDrawTab(Control: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
begin
  //Mihailo 09.06.2020.
  with Control.Canvas do begin
    Brush.Color := clWhite;
    FillRect(Rect);
    TextOut(Rect.Left + Font.Size -5, Rect.Top + 2, (Control as TPageControl).Pages[TabIndex].Caption) ;
  end;
end;

//----------------------------------------------------------------------------//
end.
