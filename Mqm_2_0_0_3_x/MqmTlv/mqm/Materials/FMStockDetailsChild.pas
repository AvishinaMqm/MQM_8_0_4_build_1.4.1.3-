unit FMStockDetailsChild;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Grids, UMSchedContFunc, UReShape;

type

  THeaderRow = record
    Identifier:   longInt;
    ArticleCode:  string;
    netGroup:     String;
    Qty:          Double;
    description:  String;
    ArtType   :   string;
    Details   :   string;
    MainIndex :   Integer;
    Jobid     :   TSchedID;
    modified  :   boolean;
  end;
  PTHeaderRow =  ^THeaderRow;

  TStockDetailsChild = class(TForm)
    SGRequirements: TStringGrid;
    Bevel2: TBevel;
    Panel2: TPanel;
    LblReq: TLabel;
    LblStep: TLabel;
    LblSubStep: TLabel;
    LblRePrc: TLabel;
    STProd: TStaticText;
    Ststep: TStaticText;
    StSubStep: TStaticText;
    StReProcess: TStaticText;
    GBxRequestedMaterials: TGroupBox;
    LblMatType: TLabel;
    LblMaterialCode: TLabel;
    LblNetGroup: TLabel;
    StMatType: TStaticText;
    StMatCode: TStaticText;
    StNetGroup: TStaticText;
    BtnOk: TcxButton;
    BtnAbo: TcxButton;
    procedure SGRequirementsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure SGRequirementsDblClick(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure BtnAboClick(Sender: TObject);
  private
    m_GridDataList : TList;
    m_SelectedRow  : Integer;
    { Private declarations }
  public
    constructor CreateStockChild(AOwner: TComponent; List : TList; Id : TSchedId;
               TYPE_PROD : string; PRODUCT_CODE : string; NET_GROUP_CODE : string);
    procedure PrintSelectedItems;
    function  GetSelectedRow : Integer;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses gnugettext,UMObjCont;

{ TStockDetailsChild }

//----------------------------------------------------------------------------//

procedure TStockDetailsChild.BtnOkClick(Sender: TObject);
begin
  ModalResult := mrOk;
//  Close;
end;

//----------------------------------------------------------------------------//

constructor TStockDetailsChild.CreateStockChild(AOwner: TComponent; List: TList; Id : TSchedId;
                                               TYPE_PROD : string; PRODUCT_CODE : string; NET_GROUP_CODE : string);
begin
  inherited create(Aowner);
  m_GridDataList := List;
  StMatType.Caption := TYPE_PROD;
  StMatCode.Caption := PRODUCT_CODE;
  StNetGroup.Caption := NET_GROUP_CODE;
  STProd.Caption      := p_sc.GetFldDescr(id,CSC_ProdReq, false);
  Ststep.Caption      := p_sc.GetFldDescr(id,CSC_ProdStep, false);
  StSubStep.Caption   := p_sc.GetFldDescr(id,CSC_ProdSubStep, false);
  StReProcess.Caption := p_sc.GetFldDescr(id,CSC_ReprocNo, false);
  PrintSelectedItems;

  ReShape(self);
//  ReShape(BtnOk);
//  ReShape(BtnAbo);
end;

//----------------------------------------------------------------------------//

function TStockDetailsChild.GetSelectedRow: Integer;
begin
  Result := m_SelectedRow
end;

//----------------------------------------------------------------------------//

procedure TStockDetailsChild.BtnAboClick(Sender: TObject);
begin
  ModalResult := mrAbort;
  Close;
end;

procedure TStockDetailsChild.PrintSelectedItems;
var
  i: integer;
  HeaderRow:  PTHeaderRow;
begin
  with SGRequirements do
  begin
    RowCount := m_GridDataList.Count + 1;
    Cells[0, 0] := _('');
    for i:= 0 to m_GridDataList.Count -1 do
    begin
      HeaderRow := m_GridDataList.Items[i];
      Cells[0, i+1] := HeaderRow.Details;
//      Cells[1, i+1] := HeaderRow.ArticleCode;
//      Cells[2, i+1] := HeaderRow.netGroup;
//      Cells[3, i+1] := HeaderRow.Details;
    end;

  end;

end;

//----------------------------------------------------------------------------//

procedure TStockDetailsChild.SGRequirementsDblClick(Sender: TObject);
begin
  BtnOkClick(self);
end;

//----------------------------------------------------------------------------//

procedure TStockDetailsChild.SGRequirementsSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  m_SelectedRow := ARow;
end;

end.
