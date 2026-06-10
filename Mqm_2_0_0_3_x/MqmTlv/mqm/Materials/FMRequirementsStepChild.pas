unit FMRequirementsStepChild;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FMRequirements, Grids, gnugettext, StdCtrls, UMSchedContFunc, UReShape;

type
  TFPrevNextStepDetails = class(TForm)
    SGRowDetails: TStringGrid;
    LblReq: TLabel;
    STProd: TStaticText;
    LblStep: TLabel;
    Ststep: TStaticText;
    LblSubStep: TLabel;
    StSubStep: TStaticText;
    LblRePrc: TLabel;
    StReProcess: TStaticText;
  constructor CreatePrevNextChildForm(AOwner: TComponent; RowList: Tlist; Id: Integer; isPrev: boolean);
  //CreateMatReqChildForm(AOwner: TComponent; RowList: Tlist);
  Procedure   CreatePrevStepForm(RowList: Tlist);
  private
    m_id: Integer;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FPrevNextStepDetails: TFPrevNextStepDetails;

implementation

{$R *.dfm}
uses
  UMSchedCont,
  UMBalance,
  UMObjCont;


//----------------------------------------------------------------------------//

constructor TFPrevNextStepDetails.CreatePrevNextChildForm(AOwner: TComponent; RowList: Tlist; Id: Integer; isPrev: boolean);
begin
  inherited create(Aowner);
  if isprev then
    Caption := _('Balance details to previous step')
  else
    Caption := _('Balance details to next step');
    
  m_id := id;
  CreatePrevStepForm(RowList);
  ReShape(Self);
end;

//----------------------------------------------------------------------------//

Procedure TFPrevNextStepDetails.CreatePrevStepForm(RowList: Tlist);
var
  i: integer;
//  TotalBalance: double;
//  recArtBalance : PTArtBalance;
//  ArtBalList: TMQMArtBalanceList;
//  NotUsed: boolean;
  RowData: PTDetailRows;
//  HeaderRow:  PTHeaderRow;
begin
  STProd.Caption      := p_sc.GetFldDescr(m_id,CSC_ProdReq, false);
  Ststep.Caption      := p_sc.GetFldDescr(m_id,CSC_ProdStep, false);
  StSubStep.Caption   := p_sc.GetFldDescr(m_id,CSC_ProdSubStep, false);
  StReProcess.Caption := p_sc.GetFldDescr(m_id,CSC_ReprocNo, false);
  TranslateComponent(self);
  try
  with SGRowDetails do
  begin

    RowCount := RowList.Count + 1;

    Cells[0, 0] := _('Date');
    Cells[1, 0] := _('Quantity');
    Cells[2, 0] := _('Balance');
    Cells[3, 0] := _('Details');

    for i:= 0 to RowList.Count -1 do
    begin
      RowData := RowList.Items[i];

      Cells[0, i+1] := RowData.Date;
      Cells[1, i+1] := FloatToStr(RowData.Quantity);
      Cells[2, i+1] := FloatToStr(RowData.TotalBal);  //FloatToStr(TotalBalance);
      Cells[3, i+1] := RowData.description;
    //  Cells[3, i+1] := FloatToStr(recArtbalance.TotalBal);
    //  Cells[4, i+1] := IntToStr(recArtbalance.JobID);
    end; //for
   end;//with
   except
    on e:Exception do MessageDlg('FMRequirementsChild - CreateMatReqChildForm'+#13'Message: '+e.Message,mtError, [mbOK],0);
  end;
 end;


end.
 