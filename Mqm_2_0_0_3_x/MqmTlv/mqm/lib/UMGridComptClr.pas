{*------------------------------------------------------------------------------
  Creates the Color component
  Made out of 2 classes :
  1. TGridCmpt - the Grid component
  2. TColorCompt - the panel that holds (and creates ) the Grid + buttons

  *}
unit UMGridComptClr;

interface

uses cxButtons, grids,classes,Controls,Windows,Sysutils,Graphics,menus,dialogs,
     extctrls,stdctrls,buttons,UMglobal,Forms, gnugettext, UReShape;

type

  TColorType = (Ct_int, Ct_bdr ,Ct_txt,Ct_description);
  TCompType = (Ct_JobToJob, Ct_JobToCap, Ct_JobCapToRes, Ct_Error, Ct_ResColor, Ct_CapResColor);
  //TGetDescr  = function (ClrIndex: integer): string;

  TGridCmpt = class(TDrawGrid)
    constructor CreateGridCmpt(AOwner: TComponent; ColorArray: TColorArray; DfltColArray: array of TDetCmpClr; CompType : TCompType);
    destructor  Destroy; override;
    private
      m_changeClr : boolean;
      m_ColorArray : TColorArray;
      m_TmpColorArray : TColorArray;
      m_DfltColorArray : array of TDetCmpClr;
      m_CompType : TCompType;
      procedure LoadColorInTemp;
      procedure ClrDrawCell(Sender: TObject; ACol, ARow: Longint; Rect: TRect; State: TGridDrawState);
      procedure ClrSelectCell(Sender: TObject; ACol, ARow: Longint; var CanSelect: Boolean);
    public
      procedure SaveColorFromTemp;
      procedure SetDefaultColors;
      function  GetColorforDlgClr(Num: Integer; ColorType: TColorType) : TColor;
      procedure ChangeTempColor(Num: Integer; Color: TColor; ColorType: TColorType);
      procedure ChangeTempDesc(Num: Integer; Description: string);
      property  P_ChangClr : boolean read m_changeClr write m_changeClr;

  end;



  TColorCompt = class(TPanel)
    Pan : TPanel;
    LblInt : TLabel;
    LblBdr : TLabel;
    LblTxt : TLabel;
    LblDescription : TLabel;
    intShape : TShape;
    bdrShape : TShape;
    txtShape : TShape;
    DescriptionShape : TShape;
    BitBtn1 : TcxButton;
    procedure BtnDefaultClick(Sender: TObject);
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure SetCompColorFromTemp;
    function  CheckChanges : boolean;

    constructor CreateColorCompt(AOwner: TComponent; ColorArray: TColorArray; DfltColArray: array of TDetCmpClr; CompType : TCompType);
    destructor  Destroy; override;
  private
    m_GridCmpt : TGridCmpt;

    procedure intShapeMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure bdrShapeMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure txtShapeMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure descriptionShapeMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    function ChangeColor(ColorType : TColorType): TColor;
  public
    procedure ChangeDescription(description : String);


  end;
   // This form is for description entry
 {  TFormCapResDesc = class(TForm)
    LblDescription: TLabel;
    EditDescription: TEdit;
    BitBtn: TBitBtn;
    ColorComponent : TColorCompt;
    constructor CreateDescriptionEntry(AOwner: TComponent; ColorComp: TColorCompt);
    destructor  Destroy; override;

    procedure BtnDefaultClick(Sender: TObject);
  end;      }

  function GetScreenDPI(): Integer;

implementation

  uses FMCapResDescription;

//{ TGridCmpt }

//----------------------------------------------------------------------------//
{ When a color is selected and changed this function paints all
   the buttons accordingly .
  @param ACol   The Column of the changed color
  @param Arow   The Row of the changed color
  @param CanSelect   should be deleted
  }
procedure TGridCmpt.ClrSelectCell(Sender: TObject; ACol, ARow: Longint; var CanSelect: Boolean);
var
  Color : TColor;
begin
  Color := GetColorforDlgClr(ARow-1, ct_Int);
  TColorCompt(Parent).intShape.Brush.Color := Color;
  TColorCompt(Parent).bdrShape.Brush.Color := Color;
  TColorCompt(Parent).txtShape.Brush.Color := Color;
  TColorCompt(Parent).LblTxt.Color := Color;
  TColorCompt(Parent).LblInt.Color := Color;
  TColorCompt(Parent).LblBdr.Color := Color;

  Color := GetColorforDlgClr(ARow-1, Ct_bdr);
  TColorCompt(Parent).intShape.Pen.Color := Color;
  TColorCompt(Parent).bdrShape.Pen.Color := Color;
  TColorCompt(Parent).txtShape.Pen.Color := Color;

  Color := GetColorforDlgClr(ARow-1, ct_txt);
  TColorCompt(Parent).LblTxt.Font.Color := Color;
  TColorCompt(Parent).LblInt.Font.Color := Color;
  TColorCompt(Parent).LblBdr.Font.Color := Color;

end;

//----------------------------------------------------------------------------//
{ Paints the Grid with all the colors and descriptions

  @param ACol   The Column of the color to paint
  @param Arow   The Row of the color to paint
  @param Rect   Rectangle to draw
  @param State  State of DrawGrid
  }
procedure TGridCmpt.ClrDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  if ARow = 0 then
  begin
    case ACol of
      0: Canvas.TextRect(Rect, Rect.Left+3, Rect.Top+3, ' ' + _('Case'));
      1: Canvas.TextRect(Rect, Rect.Left+3, Rect.Top+3, ' ' + _('Internal'));
      2: Canvas.TextRect(Rect, Rect.Left+3, Rect.Top+3, ' ' + _(' Border'));
      3: Canvas.TextRect(Rect, Rect.Left+3, Rect.Top+3, ' ' + _('  Text'));
      4: Canvas.TextRect(Rect, Rect.Left+3, Rect.Top+3, ' ' + _('Description'));
    end;
  end else
  begin
    case ACol of
      0: Canvas.TextRect(Rect, Rect.Left+3, Rect.Top+3, ' ' + IntToStr(ARow - 1));
      1: begin
           Canvas.Pen.Color   := m_TmpColorArray[ARow - 1].brd;
           Canvas.Brush.Color := m_TmpColorArray[ARow - 1].int;

           if m_CompType = Ct_ResColor then
           begin
             case (ARow - 1) of
               0,2,4,6,8,10 : Canvas.Brush.Style := bsSolid;
               1,3,5,7,9,11 : Canvas.Brush.Style := bsDiagCross;
             end;
           end;
//           if m_CompType = Ct_Error then
//           begin
//             case (ARow - 1) of
              // 2,4 : Canvas.Brush.Style := bsDiagCross;
//               9,3 : Canvas.Brush.Style := bsFDiagonal;
//                10 : Canvas.Brush.Style := bsBDiagonal;
//                11 : Canvas.Brush.Style := bsDiagCross;
//             end;
//           end;

           Canvas.RoundRect(Rect.Left + 2, Rect.Top + 2, Rect.Right - 2, Rect.Bottom - 2, 3, 3);
           Canvas.Brush.Style := bsSolid;
         end;
      2: begin
           Canvas.Brush.Color := m_TmpColorArray[ARow - 1].brd;
           Canvas.RoundRect(Rect.Left + 2, Rect.Top + 2, Rect.Right - 2, Rect.Bottom - 2, 3, 3);
         end;
      3: begin
           Canvas.Brush.Color := m_TmpColorArray[ARow - 1].txt;
           Canvas.RoundRect(Rect.Left + 2, Rect.Top + 2, Rect.Right - 2, Rect.Bottom - 2, 3, 3);
         end;
      4: begin
           if ( m_CompType = Ct_Error ) or ( m_CompType = Ct_ResColor )
                     or ( m_CompType = Ct_CapResColor ) then
             begin
               Canvas.Brush.Style := bsClear;
               Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, _(m_TmpColorArray[ARow - 1].dsc));
               Canvas.Brush.Style := bsSolid;
             end;
         end;
    end;
  end

end;

//----------------------------------------------------------------------------//
{ Creates a DrawGrid for each (errors,job to job , resource etc.)
   with all the colors and description

  @param ColorArray   The colors for the component that were loaded from the DB (DBAppGlobals.*)
  @param DfltColArray The default colors for the component defined in DBAppGlobals in UMGlobal
  @param CompType     Component type (Ct_JobToJob, Ct_JobToCap, Ct_JobCapToRes, Ct_Error, Ct_ResColor, Ct_CapResColor);

  }
constructor TGridCmpt.CreateGridCmpt(AOwner: TComponent; ColorArray: TColorArray; DfltColArray: array of TDetCmpClr;  CompType : TCompType);
var
  i: integer;
begin
  inherited Create(AOwner);
  m_ColorArray := ColorArray;
  m_CompType := CompType;

  SetLength(m_DfltColorArray, Length(DfltColArray));
  for I := Low(DfltColArray) to High(DfltColArray) do
    m_DfltColorArray[I]:= DfltColArray[i];

  m_changeClr := false;
  SetDefaultColors;
  LoadColorInTemp;
  DefaultColWidth := 50;
  if ( m_CompType = Ct_JobToJob ) or ( m_CompType = Ct_JobToCap )
      or ( m_CompType = Ct_JobCapToRes ) then
  begin
    colCount := 4;
    ColWidths[0] := 40;
    FixedCols := 1;
    if GetScreenDPI = 96 then
      Font.Size := 8
    else if GetScreenDPI = 120 then
      Font.Size := 7
    else if GetScreenDPI = 144 then
      Font.Size := 6;
  end
  else
  begin
    FixedCols := 0;
    colCount := 5;
    ColWidths[0] := 0;
    ColWidths[4] := 350;
    if GetScreenDPI = 96 then
      Font.Size := 8
    else if GetScreenDPI = 120 then
      Font.Size := 7
    else if GetScreenDPI = 144 then
      Font.Size := 6;
  end;

  Options := [goVertLine, goHorzLine, goFixedVertLine, goFixedHorzLine,
              goDrawFocusSelected, goRangeSelect,  goRowSelect]; //goEditing,
  RowCount := Length(m_ColorArray)+1;
  OnDrawCell := ClrDrawCell;
  OnSelectCell := ClrSelectCell;
end;

//----------------------------------------------------------------------------//

destructor TGridCmpt.Destroy;
begin
  inherited destroy;
end;

//----------------------------------------------------------------------------//
{ Saves the changed colors from the temp array to the final array
   and from there to the DB
   }
procedure TGridCmpt.SaveColorFromTemp;
var
  I : Integer;
begin
  for I := Low(m_TmpColorArray) to High(m_TmpColorArray) do
    m_ColorArray[i] := m_TmpColorArray[I];
end;

//----------------------------------------------------------------------------//
{ Loads the colors from the final array (the DB )to the temp array

   }
procedure TGridCmpt.LoadColorInTemp;
var
  I : Integer;
begin
  SetLength(m_TmpColorArray, Length(m_ColorArray));
  for I := Low(m_ColorArray) to High(m_ColorArray) do
  begin
    if (m_ColorArray[i].int = 0) and (m_ColorArray[i].Dsc = '') then
      continue;

    m_TmpColorArray[I]:= m_ColorArray[i];
  end;
end;

//----------------------------------------------------------------------------//
 { Change the color in the Temp array}
procedure TGridCmpt.ChangeTempColor(Num: Integer; Color: TColor; ColorType: TColorType);
begin
  case ColorType of
    Ct_int:  m_TmpColorArray[Num].int := color;
    Ct_bdr:  m_TmpColorArray[Num].brd := color;
    Ct_txt:  m_TmpColorArray[Num].txt := color;
  end
end;

//----------------------------------------------------------------------------//
{ Load the Default array colors to the Temp array }
procedure TGridCmpt.SetDefaultColors;
var
  I : Integer;
begin
  SetLength(m_TmpColorArray, Length(m_DfltColorArray));
  RowCount := Length(m_TmpColorArray)+1;
  for I := Low(m_DfltColorArray) to High(m_DfltColorArray) do
  begin
    m_TmpColorArray[I] := m_DfltColorArray[I];
    m_TmpColorArray[I].Dsc := _(m_DfltColorArray[I].Dsc);
  end;
end;

//----------------------------------------------------------------------------//

function TGridCmpt.GetColorforDlgClr(Num: Integer; ColorType: TColorType) : TColor;
begin
  case ColorType of
    Ct_int:  Result := m_TmpColorArray[Num].int;
    Ct_bdr:  Result := m_TmpColorArray[Num].brd;
    Ct_txt:  Result := m_TmpColorArray[Num].txt;
  else
    Result := clWhite;
  end
end;

//----------------------------------------------------------------------------//

{ TColorCompt }

//----------------------------------------------------------------------------//
{*----------------------------------------------------------------------------
  Creates the color component which has 4 tabs
  inherits from Draw grid , and creates 4 shapes (buttons ) to enable
  the user to modify the colors and description , then calls CreateGridCmpt
  to create the actual DrawGrid
  @param ColorArray   The colors for the component that were loaded from the DB (DBAppGlobals.*)
  @param DfltColArray The default colors for the component defined in DBAppGlobals in UMGlobal
  @param CompType     What component is it ?
                     (JobToJob, JobToCap, JobCapToRes, Error, ResColor, CapResColor )
------------------------------------------------------------------------------*}
constructor TColorCompt.CreateColorCompt(AOwner: TComponent; ColorArray: TColorArray;
                        DfltColArray: array of TDetCmpClr; CompType : TCompType);
var
  CompWidth,CompHeight: Integer;
begin
  inherited Create(AOwner);
  Pan := TPanel.Create(self);
  Pan.Parent := Self as TWinControl;
  Pan.Align := alBottom;
  Pan.Height := 60;
  Pan.BevelOuter := bvLowered;

  if GetScreenDPI = 120 then
    CompWidth := 60
   else
    CompWidth := 60;   //45

   CompHeight := 25;

  intShape := TShape.Create(self);
  with intShape do
  begin
    Parent := Pan as TWinControl;
    OnMouseUp := intShapeMouseUp;
    Shape := stRoundRect;
    Top := 5;
    Width := CompWidth;
    left := 5;
    Height := CompHeight;
    Pen.Width := 3;
  end;

  bdrShape := TShape.Create(self);
  with bdrShape do
  begin
    Parent := Pan as TWinControl;
    OnMouseUp := bdrShapeMouseUp;
    Shape := stRoundRect;
    Top := 5;
    Width := CompWidth; //45;
    left := intShape.Left + intShape.Width + 10;  //80;
    Height := CompHeight;
    Pen.Width := 3;
  end;

  txtShape := TShape.Create(self);
  with txtShape do
  begin
    Parent := Pan as TWinControl;
    OnMouseUp := txtShapeMouseUp;
    Shape := stRoundRect;
    Top := 5;
    Width := CompWidth; //45;
    left := bdrShape.Left + bdrShape.Width + 10; //145;
    Height := CompHeight;
    Pen.Width := 3;
  end;

  descriptionShape := TShape.Create(self);
  with descriptionShape do
  begin
    Parent := Pan as TWinControl;
    OnMouseUp := descriptionShapeMouseUp;
    Shape := stRoundRect;
    Top := 5;
    Width := 80;
    left := txtShape.Left + txtShape.Width + 10 ;//230;
    Height := CompHeight;
    Pen.Width := 3;
  end;

  LblInt := TLabel.Create(self);
  with LblInt do
  begin
    Parent := Pan as TWinControl;
    OnMouseUp := intShapeMouseUp;
    Left := intShape.Left + 7;
    Width := intShape.Width -10;
    Top := intShape.Top + 5;
    Color := intShape.Brush.Color;
    Caption := _('Internal');
    FontResize2(Font,0);//.Size := 7;
  end;

  LblBdr := TLabel.Create(self);
  with LblBdr do
  begin
    Parent := Pan as TWinControl;
    OnMouseUp := bdrShapeMouseUp;
    Left := bdrShape.Left +7;
    Width := bdrShape.Width -10;
    Top := bdrShape.Top +5;
    Color := bdrShape.Brush.Color;
    Caption := _('Border');
    FontResize2(Font,0);//Font.Size := 7;
  end;

  LblTxt := TLabel.Create(self);
  with LblTxt do
  begin
    Parent := Pan as TWinControl;
    OnMouseUp := txtShapeMouseUp;
    Left := txtShape.Left +10;
    Width := txtShape.Width -10;
    Top := txtShape.Top +5;
    Color := txtShape.Brush.Color;
    Caption := _('Text');
    FontResize2(Font,0);//Font.Size := 7;
  end;

  LblDescription := TLabel.Create(self);
  with LblDescription do
  begin
    Parent := Pan as TWinControl;
    OnMouseUp := DescriptionShapeMouseUp;
    Left := DescriptionShape.Left +3;
    Width := DescriptionShape.Width;// -10;
    Top := DescriptionShape.Top +5;
    Color := DescriptionShape.Brush.Color;
    Caption := ' ' + _('Description');
    FontResize2(Font,0);//Font.Size := 7;
  end;


  BitBtn1 := TcxButton.Create(AOwner);
  with BitBtn1 do
  begin
    Parent := Pan as TWinControl;
    OnClick := BtnDefaultClick;
    Height := 25;
    Left := 60;
    Top := 32;
    Width := 170;//91
    Caption := _('Restore defaults');
    Anchors := [akBottom, akLeft];
    Color := $00F3B758;
    Font.Color := clWhite;
    StyleName := 'VLargeButton320x30';
    FontResize2(Font,0);//
  end;

 // ReShapeSingle(BitBtn1);

  m_GridCmpt := TGridCmpt.CreateGridCmpt(AOwner, ColorArray, DfltColArray,  CompType);
  m_GridCmpt.Parent := Self as TWinControl;
  m_GridCmpt.Align := alClient;


end;

//----------------------------------------------------------------------------//

destructor TColorCompt.Destroy;
begin
  inherited Destroy;
end;

//----------------------------------------------------------------------------//

procedure TColorCompt.EditKeyPress(Sender: TObject; var Key: Char);
begin
  if not ((CharInSet(Key, ['0'..'9'])) or (key = chr(vk_Back)) or (Key = chr(24))) then
    abort;
end;

//----------------------------------------------------------------------------//
{ Restore default colors }
procedure TColorCompt.BtnDefaultClick(Sender: TObject);
var
  CanSelect : boolean;
begin
  if MessageDlg(_('Are you sure you want to restore the default colors ?'),
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
     m_GridCmpt.SetDefaultColors;
     m_GridCmpt.P_ChangClr := true;
     m_GridCmpt.Refresh;
     m_GridCmpt.ClrSelectCell(self,m_GridCmpt.col, m_GridCmpt.row, CanSelect);
  end;
end;

//----------------------------------------------------------------------------//
 { Change the color selected by user
   @param  ColorType
  }
function TColorCompt.ChangeColor(ColorType : TColorType): TColor;
var
  ColorDialog : TColorDialog;
  I : Integer;
begin
  ColorDialog := TColorDialog.create(self);
  ColorDialog.color := m_GridCmpt.GetColorforDlgClr(m_GridCmpt.Selection.Top-1, ColorType);
  Result := ColorDialog.Color;
  if ColorDialog.Execute then
  begin
    Result := ColorDialog.Color;
    m_GridCmpt.P_ChangClr := true;
      for I := m_GridCmpt.Selection.Top-1 to m_GridCmpt.Selection.Bottom-1 do
        m_GridCmpt.ChangeTempColor(I , ColorDialog.Color, ColorType);
     m_GridCmpt.Refresh;
  end;
  ColorDialog.free;
end;

//----------------------------------------------------------------------------//

procedure TColorCompt.intShapeMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  intShape.Brush.Color := ChangeColor(Ct_int);
  bdrShape.Brush.Color := intShape.Brush.Color;
  txtShape.Brush.Color := intShape.Brush.Color;
  LblTxt.Color := intShape.Brush.Color;
  LblInt.Color := intShape.Brush.Color;
  LblBdr.Color := intShape.Brush.Color;
end;

//----------------------------------------------------------------------------//

procedure TColorCompt.bdrShapeMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  bdrShape.Pen.Color := ChangeColor(Ct_bdr);
  intShape.Pen.Color := bdrShape.Pen.Color;
  txtShape.Pen.Color := bdrShape.Pen.Color;
end;

//----------------------------------------------------------------------------//

procedure TColorCompt.txtShapeMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  LblTxt.Font.Color := ChangeColor(Ct_txt);
  LblInt.Font.Color := LblTxt.Font.Color;
  LblBdr.Font.Color := LblTxt.Font.Color;
end;

//----------------------------------------------------------------------------//

procedure TColorCompt.descriptionShapeMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  FormCapResDesc : TFormCapResDesc;
begin
  if m_GridCmpt.m_CompType = Ct_CapResColor then
  begin
    FormCapResDesc := TFormCapResDesc.CreateDescForm(Application, self);
    FormCapResDesc.Showmodal;
    FormCapResDesc.BringToFront;
  end
  else
    MessageDlg(_('Description change is possible only for capacity reservation'), mtInformation, [mbOK], 0);
end;

//----------------------------------------------------------------------------//

procedure TColorCompt.SetCompColorFromTemp;
begin
  m_GridCmpt.SaveColorFromTemp;
end;

//----------------------------------------------------------------------------//
 { checks if there were any changes so that we shall save them in the DB }
function TColorCompt.CheckChanges : boolean;
begin
  Result := m_GridCmpt.P_ChangClr;
end;

//----------------------------------------------------------------------------//
{ Creates the form for the user to enter the description }
{constructor TFormCapResDesc.CreateDescriptionEntry(AOwner: TComponent; ColorComp: TColorCompt);
begin
 inherited Create(AOwner);
 ColorComponent := ColorComp;

 {
 TFormCapResDesc.Left = 233;
 TFormCapResDesc.Top = 216;
 TFormCapResDesc.Width = 281;
 TFormCapResDesc.Height = 144;
 TFormCapResDesc.Caption = 'Description entry';
 TFormCapResDesc.Color = clBtnFace;
 TFormCapResDesc.Font.Charset = DEFAULT_CHARSET;
 TFormCapResDesc.Font.Color = clWindowText;
 TFormCapResDesc.Font.Height = -11;
 TFormCapResDescFont.Name = 'MS Sans Serif';
 TFormCapResDesc.Font.Style = [];
 TFormCapResDesc.OldCreateOrder = False;
 TFormCapResDesc.PixelsPerInch = 96;
 TFormCapResDesc.TextHeight = 13;
       }
       {
 LblDescription := TLabel.create(Self);
 LblDescription.Parent := self as TWinControl;
 LblDescription.Left := 8;
 LblDescription.Top := 8;
 LblDescription.Width := 100;
 LblDescription.Height := 13;
 LblDescription.Caption := _('Enter the description:');


 EditDescription:= TEdit.create(Self);
 EditDescription.Parent := self as TWinControl;
 EditDescription.Left := 8;
 EditDescription.Top := 32;
 EditDescription.Width := 249;
 EditDescription.Height := 21;
 EditDescription.TabOrder := 0;

 BitBtn := TBitBtn.create(Self);
 BitBtn.Parent := self as TWinControl;
 BitBtn.OnClick := BtnDefaultClick;
 BitBtn.Left:= 96;
 BitBtn.Top:= 72;
 BitBtn.Width:= 75;
 BitBtn.Height := 25;
 BitBtn.Caption := _('OK');
 BitBtn.TabOrder := 1;

end;      }

//----------------------------------------------------------------------------//

{destructor TFormCapResDesc.Destroy;
begin
  inherited destroy;
end;}

//----------------------------------------------------------------------------//

{procedure TFormCapResDesc.BtnDefaultClick(Sender: TObject);
var
  description: String;
begin

  description := EditDescription.Text;
  ColorComponent.ChangeDescription(description);
  close;
end;  }

//----------------------------------------------------------------------------//
{ change the description
  @param  description  the new description }
procedure TColorCompt.ChangeDescription(description : String);
var
  i : Integer;
begin
  //this flag shows there is a change
  // in the colors\description and there is a need to reload from temp
  m_GridCmpt.P_ChangClr := true;
  for I := m_GridCmpt.Selection.Top-1 to m_GridCmpt.Selection.Bottom-1 do
    m_GridCmpt.ChangeTempDesc(I , description);

  m_GridCmpt.Refresh;

end;

//----------------------------------------------------------------------------//
 { Change the Temp array description
   @param  Num the index in the array to change
   @param  description the new description }
procedure TGridCmpt.ChangeTempDesc(Num: Integer; Description: String);
begin
  m_TmpColorArray[Num].Dsc := description;
end;

//----------------------------------------------------------------------------//

function GetScreenDPI(): Integer;
var
  hdcScreen : HDC;
  iDPI: Integer;
begin
  hdcScreen := GetDC(0);//GetDesktopWindow);
  iDPI := -1; // assume failure
  if iDPI = -1 then
  begin
    iDPI := GetDeviceCaps(hdcScreen, LOGPIXELSX);
    ReleaseDC(0, hdcScreen);
  end;
  result := iDPI;
end;

end.

