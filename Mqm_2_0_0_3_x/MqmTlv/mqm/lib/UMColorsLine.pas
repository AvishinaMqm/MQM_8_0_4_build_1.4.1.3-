unit UMColorsLine;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, UMGlobal, stdctrls, extctrls;


type
  TColorsLine = class(TBevel)
  private
    { Private declarations }
    procedure ColorChange(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  public
    { Public declarations }
    Selected : TCheckBox;
    Color : TShape;
    Text : TEdit;
    constructor Create(Sender:Tobject; x,y:integer);
    function GetSelected : boolean;
    function GetColor : TColor;
    function GetText : string;
  end;

implementation

constructor TColorsLine.Create(Sender:Tobject; x,y:integer);
begin
  inherited create(twincontrol(sender));
  parent := twincontrol(sender);
  left := x;
  top := y;
  Style := bsLowered;
  width := 387;
  height := 33;
  visible := true;
  Selected := TCheckBox.Create(twincontrol(sender));
  Selected.Parent := twincontrol(sender);
  Selected.Left := left + 8;
  Selected.Top := top + 8;
  Selected.Height := 17;
  Selected.width := 17;
  Selected.Visible := true;
  Color := TShape.Create(twincontrol(sender));
  Color.Parent := twincontrol(sender);
  Color.Left := left + 32;
  Color.Top := top + 8;
  Color.Height := 17;
  Color.width := 41;
  Color.Visible := true;
  Color.OnMouseDown := ColorChange;
  Text := TEdit.Create(twincontrol(sender));
  Text.Parent := twincontrol(sender);
  Text.Left := left + 80;
  Text.Top := top + 8;
  Text.Height := 17;
  Text.width := 299;
  Text.Visible := true;
  Text.MaxLength := 40;
end;

procedure TColorsLine.ColorChange(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Colors : TColorDialog;
begin
  Colors := TColorDialog.Create(self);
  if Colors.Execute then
    Color.Brush.Color := colors.Color;
end;



function TColorsLine.GetSelected : boolean;
begin
  result := Selected.Checked;
end;



function TColorsLine.GetColor : TColor;
begin
  result := Color.Brush.Color;
end;



function TColorsLine.GetText : string;
begin
  result := Text.Text;
end;

end.
