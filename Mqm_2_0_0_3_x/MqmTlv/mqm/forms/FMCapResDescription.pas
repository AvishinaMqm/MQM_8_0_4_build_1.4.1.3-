unit FMCapResDescription;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Vcl.ExtCtrls, UReShape,UMGridComptClr;

type
  TFormCapResDesc = class(TForm)
    LblDescription: TLabel;
    EditDescription: TEdit;
    BitBtn11: TBitBtn;
    BitBtn1: TcxButton;

    procedure BitBtn1Click(Sender: TObject);
    Constructor CreateDescForm(AOwner : TComponent;CC : TColorCompt);
    procedure FormCreate(Sender: TObject);
  private
    ColorComponent : TColorCompt;
  public
    { Public declarations }
  end;

var  FormCapResDesc: TFormCapResDesc;

implementation

{$R *.DFM}

Constructor TFormCapResDesc.CreateDescForm(AOwner : TComponent; CC : TColorCompt);
begin
  inherited Create(AOwner);
   ColorComponent := cc;

end;

procedure TFormCapResDesc.FormCreate(Sender: TObject);
begin
  ReShape(Self);
end;

procedure TFormCapResDesc.BitBtn1Click(Sender: TObject);
var
  description: String;
begin

  description := EditDescription.Text;
  ColorComponent.ChangeDescription(description);

  ModalResult := mrOk;
 // Close;
end;

end.
