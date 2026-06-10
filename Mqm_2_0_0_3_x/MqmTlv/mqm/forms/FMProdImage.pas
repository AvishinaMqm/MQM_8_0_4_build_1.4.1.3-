unit FMProdImage;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, UReShape;

type
  TProdImage = class(TForm)
  private
    procedure SetImage;
  public
   constructor CreateImage(AOwner : TComponent);

    { Public declarations }
  end;

//var
//  ProdImage: TProdImage;

implementation

{$R *.DFM}

{ TForm1 }

uses extctrls, UMGlobal;

constructor TProdImage.CreateImage(AOwner: TComponent);
begin
  Inherited Create(AOwner);
  SetImage ;
  ReShape(Self);
end;

procedure TProdImage.SetImage;
var
  img : TImage;
begin
  img := TImage.Create(Self);
  img.Picture := TPicture.Create;
  img.Parent := self;
  img.Align := alClient;

  img.Picture.LoadFromFile(LocAppGlobals.AppDir + LocAppGlobals.ImgDir + '\Opninb.Jpg');
  img.Stretch := true;
  img.Visible := true;
end;

end.
