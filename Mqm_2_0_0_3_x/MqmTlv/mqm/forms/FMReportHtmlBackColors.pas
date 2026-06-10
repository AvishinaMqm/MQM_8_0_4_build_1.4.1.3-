unit FMReportHtmlBackColors;

{ This unit is used by FMViewHtml to change background colors for HTML reports. }

interface

uses
  cxButtons, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, gnugettext, UReShape;

type
  THtmlBackColors = class(TForm)
    ColorDialog1: TColorDialog;
    LabBack: TLabel;
    LabTitle: TLabel;
    LabEven: TLabel;
    LabOdd: TLabel;
    Panel1: TPanel;
    BtnOk: TcxButton;
    BtnCancel: TcxButton;
    constructor CreateColorMenu(AOwner: TComponent);
    procedure BtnOkClick(Sender: TObject);
    procedure LabBackClick(Sender: TObject);
    procedure LabTitleClick(Sender: TObject);
    procedure LabEvenClick(Sender: TObject);
    procedure LabOddClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure UpdateColors;
    procedure InitStatus;
    function ColorChanged: boolean;
    procedure FormShow(Sender: TObject);
  private
    procedure SaveColors;
    procedure CheckLabelColors(var lab: TLabel);
  public
  end;

var HtmlBackColors: THtmlBackColors;

implementation

{$R *.dfm}
uses UMGlobal;

var ColChanged: boolean;

//----------------------------------------------------------------------------//
{ Constructor for the form }
//----------------------------------------------------------------------------//

constructor THtmlBackColors.CreateColorMenu(AOwner: TComponent);
begin
  try
    inherited create(AOwner);
  except
    on e:Exception do MessageDlg('FMReportHtmlBackColors - CreateColorMenu'+#13'Message: '+e.Message,mtError, [mbOK],0);
  end;
  Caption                := _('HTML Background Colors');
  BtnOk.Caption          := '&' + _('OK');
  BtnCancel.Caption      := '&' + _('Cancel');
  LabBack.Caption        := _('Formular Background');
  LabTitle.Caption       := _('Table Title Row');
  LabEven.Caption        := _('Even Table Rows');
  LabOdd.Caption         := _('Odd Table Rows');
  UpdateColors;
  ColChanged := false;
end;

procedure THtmlBackColors.FormShow(Sender: TObject);
begin
  ReShape(Self);
//  ReShape(BtnCancel);
//  ReShape(BtnOk);
end;

//----------------------------------------------------------------------------//
{ Updates the form by displaying the chosen HTML report background colors }
//----------------------------------------------------------------------------//

procedure THtmlBackColors.UpdateColors;
begin
  try
    LabBack.Color := StrToInt(iniAppGlobals.HtmlColorBack);
  except LabBack.Color := clWhite;
  end;
  CheckLabelColors(LabBack);
  try
    LabTitle.Color := StrToInt(iniAppGlobals.HtmlColorTabTitle);
  except LabTitle.Color := clMedGray;
  end;
  CheckLabelColors(LabTitle);
  try
    LabEven.Color := StrToInt(iniAppGlobals.HtmlColorTabEven);
  except LabEven.Color := clWhite;
  end;
  CheckLabelColors(LabEven);
  try
    LabOdd.Color := StrToInt(iniAppGlobals.HtmlColorTabOdd);
  except LabOdd.Color := clLtGray;
  end;
  CheckLabelColors(LabOdd);
end;

//----------------------------------------------------------------------------//
{ Changes label font color contrasting its background color }
//----------------------------------------------------------------------------//

procedure THtmlBackColors.CheckLabelColors(var lab: TLabel);
begin
  if (lab.Color < 50000) or (lab.Color = clBlack) or (lab.Color = clGray)
    or (lab.Color = clBlue) then lab.Font.Color := clWhite
  else lab.Font.Color := clBlack;
end;

//----------------------------------------------------------------------------//
{ Save colors in the global MQM variables }
//----------------------------------------------------------------------------//

procedure THtmlBackColors.SaveColors;
begin
  iniAppGlobals.HtmlColorBack     := IntToStr(LabBack.Color);
  iniAppGlobals.HtmlColorTabTitle := IntToStr(LabTitle.Color);
  iniAppGlobals.HtmlColorTabEven  := IntToStr(LabEven.Color);
  iniAppGlobals.HtmlColorTabOdd   := IntToStr(LabOdd.Color);
end;

//----------------------------------------------------------------------------//
{ Pressing OK means saving colors and closing form }
//----------------------------------------------------------------------------//

procedure THtmlBackColors.BtnOkClick(Sender: TObject);
begin
  SaveColors;
  Close;
end;

//----------------------------------------------------------------------------//
{ Start Color Dialog for changing HTML Report background color of page }
//----------------------------------------------------------------------------//

procedure THtmlBackColors.LabBackClick(Sender: TObject);
begin
  ColorDialog1.Color := LabBack.Color;
  if ColorDialog1.Execute then
  begin
    LabBack.Color := ColorDialog1.Color;
    CheckLabelColors(LabBack);
    ColChanged := true;
  end;
end;

//----------------------------------------------------------------------------//
{ Start Color Dialog for changing HTML Report background color of column titles }
//----------------------------------------------------------------------------//

procedure THtmlBackColors.LabTitleClick(Sender: TObject);
begin
  ColorDialog1.Color := LabTitle.Color;
  if ColorDialog1.Execute then
  begin
    LabTitle.Color := ColorDialog1.Color;
    CheckLabelColors(LabTitle);
    ColChanged := true;
  end;
end;

//----------------------------------------------------------------------------//
{ Start Color Dialog for changing HTML Report background color of even rows }
//----------------------------------------------------------------------------//

procedure THtmlBackColors.LabEvenClick(Sender: TObject);
begin
  ColorDialog1.Color := LabEven.Color;
  if ColorDialog1.Execute then
  begin
    LabEven.Color := ColorDialog1.Color;
    CheckLabelColors(LabEven);
    ColChanged := true;
  end;
end;

//----------------------------------------------------------------------------//
{ Start Color Dialog for changing HTML Report background color of odd rows }
//----------------------------------------------------------------------------//

procedure THtmlBackColors.LabOddClick(Sender: TObject);
begin
  ColorDialog1.Color := LabOdd.Color;
  if ColorDialog1.Execute then
  begin
    LabOdd.Color := ColorDialog1.Color;
    CheckLabelColors(LabOdd);
    ColChanged := true;
  end;
end;

//----------------------------------------------------------------------------//
{ Cancel changes and close form }
//----------------------------------------------------------------------------//

procedure THtmlBackColors.BtnCancelClick(Sender: TObject);
begin
  Close;
end;

//----------------------------------------------------------------------------//
{ Sets up form }
//----------------------------------------------------------------------------//

procedure THtmlBackColors.InitStatus;
begin
  ColChanged := false;
end;

//----------------------------------------------------------------------------//
{ Returns whether a color has been changed }
//----------------------------------------------------------------------------//

function THtmlBackColors.ColorChanged: boolean;
begin
  Result := ColChanged;
end;

end.

