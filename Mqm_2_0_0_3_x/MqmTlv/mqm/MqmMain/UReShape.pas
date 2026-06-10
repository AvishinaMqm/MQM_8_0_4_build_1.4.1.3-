unit UReShape;  //Mihailo 5.8.2019.

interface
uses
  controls,Windows, cxButtons, UMGlobal, Forms,Classes,stdctrls,sysutils,graphics, gnugettext,
  Vcl.ComCtrls,Vcl.Samples.Spin,Dialogs,Vcl.ExtCtrls, Vcl.CheckLst, ExSpinEdit,

  dxUIAClasses, cxControls, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  Vcl.Menus, cxGeometry, dxGDIPlusClasses,  Winapi.GDIPAPI,
  Winapi.GDIPOBJ, Math, dxCoreGraphics,
  Winapi.GDIPUTIL,
  Grids;

  type Gost = class
  public
    procedure cxButtonCustomDraw(Sender: TObject; ACanvas: TcxCanvas;AViewInfo: TcxButtonViewInfo; var AHandled: Boolean);
    procedure Assign(obj :TObject);
  end;


  Procedure ReShape(Component : TControl);
  Procedure ReShapeSingle(Component : TControl);
  //Procedure FontResize(FFont : TFont);
  Procedure FontResize2(FFont : TFont; StepSize : Integer);

  var ZoomRate, ActiveZoom : Integer;
  var GDrawHelper: Gost;

implementation

procedure Gost.Assign(obj :TObject);
begin

  if TcxButton(Obj).ClassType = TcxButton then
    TcxButton(Obj).OnCustomDraw := cxButtonCustomDraw;

end;

function CreateRoundRectPath(const R: TRect; Radius: Integer): TGPGraphicsPath;
var
  D: Integer;
begin
  Result := TGPGraphicsPath.Create;
  D := Radius * 2+2;

  Result.AddArc(R.Left, R.Top, D, D, 180, 90);
  Result.AddArc(R.Right - D, R.Top, D, D, 270, 90);
  Result.AddArc(R.Right - D, R.Bottom - D, D, D, 0, 90);
  Result.AddArc(R.Left, R.Bottom - D, D, D, 90, 90);
  Result.CloseFigure;
end;

procedure Gost.cxButtonCustomDraw(Sender: TObject; ACanvas: TcxCanvas;
  AViewInfo: TcxButtonViewInfo; var AHandled: Boolean);
var
  G: TGPGraphics;
  Path: TGPGraphicsPath;
  Brush: TGPLinearGradientBrush;
  HighlightBrush: TGPSolidBrush;
  R: TRect;
  Radius: Integer;
  Btn: TcxButton;
  S: string;
  ImgX, ImgY: Integer;
  Color1, Color2: TGPColor;
begin
  Btn := Sender as TcxButton;
  S := Btn.Caption;
  R := AViewInfo.Bounds;
  InflateRect(R, -1, -1);
  // ?? pill shape
  Radius := (R.Bottom - R.Top) div 2;
  // ?? Colors (Datatex-style blue)

  if s = 'Abort' then
  begin
    if AViewInfo.State = cxbsDisabled then
    begin
      Color1 := MakeColor(255, 200, 210, 220);
      Color2 := MakeColor(255, 170, 180, 190);
    end
    else if AViewInfo.State = cxbsPressed then
    begin
      // darker pressed
      Color1 := MakeColor(255, 40, 40, 40);
      Color2 := MakeColor(255, 20, 20, 20);
    end
    else if AViewInfo.State = cxbsHot then
    begin
      // lighter hover
      Color1 := MakeColor(255, 80, 80, 80);
      Color2 := MakeColor(255, 60, 60, 60);
    end
    else
    begin
      // normal black gradient
      Color1 := MakeColor(255, 110, 110, 110);  // LEFT (lighter)
      Color2 := MakeColor(255, 30, 30, 30);  // RIGHT (darker)
    end;
  end else
  begin
    if AViewInfo.State = cxbsDisabled then
    begin
      Color1 := MakeColor(255, 200, 210, 220);
      Color2 := MakeColor(255, 170, 180, 190);
    end
    else
    if AViewInfo.State = cxbsPressed then
    begin
      Color1 := MakeColor(255, 44, 111, 184);  // darker
      Color2 := MakeColor(255, 36, 95, 163);
    end
    else if AViewInfo.State = cxbsHot then
    begin
      Color1 := MakeColor(255, 71, 155, 234);  // lighter
      Color2 := MakeColor(255, 58, 141, 222);
    end
    else
    begin
      Color1 := MakeColor(255, 110, 200, 255);
      Color2 := MakeColor(255, 60, 150, 220);
    end;
  end;
  // GDI+ drawing
  G := TGPGraphics.Create(ACanvas.Handle);
  try
    G.SetSmoothingMode(SmoothingModeAntiAlias);
    Path := CreateRoundRectPath(R, Radius);
    try
      // ?? Diagonal gradient (top-left ? bottom-right)
      Brush := TGPLinearGradientBrush.Create(
        MakePoint(R.Left, R.Top),
        MakePoint(R.Right, R.Bottom),
        Color1,
        Color2
      );
      try
        G.FillPath(Brush, Path);
      finally
        Brush.Free;
      end;

    finally
      Path.Free;
    end;
  finally
    G.Free;
  end;
  // ?? Text
  ACanvas.Brush.Style := bsClear;
  ACanvas.Font.Assign(Btn.Font);
  ACanvas.Font.Color := clWhite;
  DrawText(
    ACanvas.Handle,
    PChar(S),
    Length(S),
    R,
    DT_CENTER or DT_VCENTER or DT_SINGLELINE
  );

  if (Btn.OptionsImage.Images <> nil) and
     (Btn.OptionsImage.ImageIndex >= 0) then
  begin
    ImgX := R.Left + (R.Width - Btn.OptionsImage.Images.Width + 2) div 2;
    ImgY := R.Top +  (R.Height -Btn.OptionsImage.Images.Height+ 2) div 2;
    Btn.OptionsImage.Images.Draw(
      ACanvas.Canvas,
      ImgX,
      ImgY,
      Btn.OptionsImage.ImageIndex,
      True
    );
  end;
  AHandled := True;
end;

Procedure FontResize2(FFont : TFont; StepSize : Integer);
begin

  if (ZoomRate = ActiveZoom) and (ZoomRate = 0) then
  begin
   if Screen.PixelsPerInch = 96 then // 100%
      FFont.Size := 9 + StepSize
    else if Screen.PixelsPerInch = 120 then  // 125%
      FFont.Size := 8 + StepSize
    else if Screen.PixelsPerInch = 144 then  // 150%
      FFont.Size := 6 + StepSize;
  end;

   { if ZoomRate < ActiveZoom then
    begin
       //FFont.Size := FFont.Size - ZoomRate * -1;
       FFont.Size := FFont.Size - 1;
    end else  if ZoomRate > ActiveZoom then
    begin
      FFont.Size := FFont.Size + 1;
       //FFont.Size := FFont.Size + ZoomRate ;

    end;       }

end;

{Procedure FontResize(FFont : TFont);
begin
   Exit;
  if (ZoomRate = ActiveZoom) and (ZoomRate = 0) then
  begin
   if Screen.PixelsPerInch = 96 then // 100%
      FFont.Size := 9
    else if Screen.PixelsPerInch = 120 then  // 125%
      FFont.Size := 8
    else if Screen.PixelsPerInch = 144 then  // 150%
      FFont.Size := 7;
  end;


   { if ZoomRate < ActiveZoom then
    begin
       //FFont.Size := FFont.Size - ZoomRate * -1;
       FFont.Size := FFont.Size - 1;
    end else  if ZoomRate > ActiveZoom then
    begin
      FFont.Size := FFont.Size + 1;
       //FFont.Size := FFont.Size + ZoomRate ;

    end;      }

//end;     }

Procedure ReShapeSingle(Component : TControl);
var Rgn: HRgn;
var CornerSize,i : Integer;
begin
   Rgn := CreateRoundRectRgn(0, 0, Component.Width, Component.Height, 20, 20);
  SetWindowRgn(TWinControl(Component).handle, Rgn, True);
end;

Procedure ReShape(Component : TControl);
var Rgn: HRgn;
var CornerSize,i, a : Integer;
var ShapedControl : TControl;
var ComponentFont : String;
Var ComponentColor : TColor;


begin
  ComponentFont := 'Montserrat';
  ComponentColor := $00FBFAF9;

 // if Component.ClassType = TForm then
 // begin
     if TForm(Component).Caption = 'Notes' then exit;

    if iniAppGlobals.FontSize = 0 then //small
      TForm(Component).Font.Size := 7
    else if iniAppGlobals.FontSize = 1 then //big
      TForm(Component).Font.Size := 8;

    if Screen.PixelsPerInch = 96 then // 100%
      TForm(Component).Font.Size := TForm(Component).Font.Size + 1
    else if Screen.PixelsPerInch = 120 then  // 125%
      TForm(Component).Font.Size := TForm(Component).Font.Size
    else if Screen.PixelsPerInch = 144 then  // 150%
      TForm(Component).Font.Size := TForm(Component).Font.Size - 1;


   {  if ZoomRate < ActiveZoom then
    begin
       //FFont.Size := FFont.Size - ZoomRate * -1;
       TForm(Component).Font.Size := TForm(Component).Font.Size - 1;
    end else  if ZoomRate > ActiveZoom then
    begin
      TForm(Component).Font.Size := TForm(Component).Font.Size + 1;
       //FFont.Size := FFont.Size + ZoomRate ;

    end;     }

    //TForm(Component).Font.Size := 10 + ActiveZoom;
    //TForm(Component).Font.Size := TForm(Component).Font.Size + ActiveZoom;

    if (TForm(Component).Caption <> '') and (Component.ClassType <> TPanel) then
      if TForm(Component).BorderStyle <> bsNone then
      begin
         TForm(Component).bordericons := [biSystemMenu];
        //TForm(Component).Scaled := False;

        TForm(Component).Font.Name := ComponentFont;
        //TForm(Component).Font.Size := 9;
       // TForm(Component).ParentFont := False;

      end;


 // end;

  //if TForm(Component).caption  = _('Local workstation selection') then  //Disable only for TPlanWCControl
  //    TForm(Component).Font.Size := 10;

  for i := 0 to Component.ComponentCount-1 do
  begin
    if (Component.Components[i] is TComponent) then
    begin

      if Component.Components[i].ClassType = TPanel then
        ReShape(TControl(Component.Components[i]));


      if Component.Components[i].ClassType = TcxButton then  //TcxButton
        begin
          TcxButton(Component.Components[i]).Font.Style := [fsBold];
          TcxButton(Component.Components[i]).OnCustomDraw := GDrawHelper.cxButtonCustomDraw;
        end;

        if Component.Components[i].ClassType = TGroupBox then  //TGroupBox
        begin
          //CornerSize := 5;
          TGroupBox(Component.Components[i]).StyleName := 'Windows';
          TGroupBox(Component.Components[i]).ParentFont := True;
          TGroupBox(Component.Components[i]).Font.Name := ComponentFont;
         // TGroupBox(Component.Components[i]).Font.Size := 8;
          TGroupBox(Component.Components[i]).Font.Style := [];
        end else
        if Component.Components[i].ClassType = TcxButton then
        begin
          TcxButton(Component.Components[i]).Font.Name := ComponentFont;

          if (TcxButton(Component.Components[i]).Caption = 'Abort') or (TcxButton(Component.Components[i]).Caption = 'Cancel') then
            TcxButton(Component.Components[i]).StyleName := 'DarkBlueButton';
          //else
          //  TcxButton(Component.Components[i]).StyleName := 'datatex1';

          TcxButton(Component.Components[i]).Font.Style := [fsBold];
        end else
        if Component.Components[i].ClassType = TComboBox then
        begin
          CornerSize := 0;
          TComboBox(Component.Components[i]).Font.Name := ComponentFont;
         // TComboBox(Component.Components[i]).Font.Size := 8;
          TComboBox(Component.Components[i]).Font.Style := [];
          TComboBox(Component.Components[i]).Color := ComponentColor;
          TComboBox(Component.Components[i]).BevelKind := bkFlat;
          TComboBox(Component.Components[i]).ParentFont := True;
          TComboBox(Component.Components[i]).StyleName := 'datatex1';
        end else if Component.Components[i].ClassType = TLabeledEdit then
        begin
          CornerSize := 0;
          TLabeledEdit(Component.Components[i]).Font.Name := ComponentFont;
         // TComboBox(Component.Components[i]).Font.Size := 8;
          TLabeledEdit(Component.Components[i]).Font.Style := [];
          TLabeledEdit(Component.Components[i]).Color := ComponentColor;
          TLabeledEdit(Component.Components[i]).ParentFont := True;

        end else if Component.Components[i].ClassType = TDateTimePicker  then
        begin
          TDateTimePicker(Component.Components[i]).Font.Name := 'Arial'; /// avi/mihailo changed from having correct numbers
          TDateTimePicker(Component.Components[i]).Font.Size := 8;
          TDateTimePicker(Component.Components[i]).Font.Style := [];
          TDateTimePicker(Component.Components[i]).Color := ComponentColor;
        //  TDateTimePicker(Component.Components[i]).BevelKind := bkFlat;
          TDateTimePicker(Component.Components[i]).ParentFont := True;
          TDateTimePicker(Component.Components[i]).StyleName := 'datatex1';
        end else if Component.Components[i].ClassType = TRadioGroup  then
        begin
          TRadioGroup(Component.Components[i]).StyleElements := [];
          TRadioGroup(Component.Components[i]).Color := clWhite;

         // TRadioGroup(Component.Components[i]).Font.Size := 8;
        end else if Component.Components[i].ClassType = TexSpinEdit  then
        begin
          CornerSize := 5;
        //  TexSpinEdit(Component.Components[i]).Font.Name := ComponentFont;
        //  TexSpinEdit(Component.Components[i]).Font.Size := 8;
        //  TexSpinEdit(Component.Components[i]).Font.Style := [];
         // TexSpinEdit(Component.Components[i]).Color := ComponentColor;
            TexSpinEdit(Component.Components[i]).ParentFont := True;
            TexSpinEdit(Component.Components[i]).StyleName := 'datatex1';
        end else if Component.Components[i].ClassType = TEdit  then
        begin
          CornerSize := 0;
          TEdit(Component.Components[i]).Font.Name := ComponentFont;
         // TEdit(Component.Components[i]).Font.Size := 8;
          TEdit(Component.Components[i]).Font.Style := [];
          TEdit(Component.Components[i]).Color := ComponentColor;
         // TEdit(Component.Components[i]).BevelKind := bkFlat;
          TEdit(Component.Components[i]).ParentFont := True;
        end else if Component.Components[i].ClassType = TCheckListBox  then
        begin
          CornerSize := 5;
          TCheckListBox(Component.Components[i]).Font.Name := ComponentFont;
         // TCheckListBox(Component.Components[i]).Font.Size := 8;
          TCheckListBox(Component.Components[i]).Font.Style := [];
          TCheckListBox(Component.Components[i]).Color := ComponentColor;
         // TCheckListBox(Component.Components[i]).BevelKind := bkFlat;
          TCheckListBox(Component.Components[i]).ParentFont := True;
        end else if Component.Components[i].ClassType = TStaticText  then
        begin
          CornerSize := 5;
          TStaticText(Component.Components[i]).Font.Name := ComponentFont;
         // TStaticText(Component.Components[i]).Font.Size := 8;
          TStaticText(Component.Components[i]).Font.Style := [];
          TStaticText(Component.Components[i]).Color := ComponentColor;
          TStaticText(Component.Components[i]).ParentFont := True;
        end else if Component.Components[i].ClassType = TPageControl  then
        begin
          TPageControl(Component.Components[i]).Font.Name := ComponentFont;
          //TPageControl(Component.Components[i]).Font.Size := 9;
          TPageControl(Component.Components[i]).Font.Style := [];
         // TStaticText(Component.Components[i]).Color := ComponentColor;
         TPageControl(Component.Components[i]).ParentFont := True;

          for a := 0 to TPageControl(Component.Components[i]).PageCount -1 do
            TPageControl(Component.Components[i]).Pages[a].ParentFont := true;

        end
        else if Component.Components[i].ClassType = TStringGrid  then
        begin
          TStringGrid(Component.Components[i]).Font.Name := ComponentFont;
         // TPageControl(Component.Components[i]).Font.Size := 8;
          TStringGrid(Component.Components[i]).Font.Style := [];
          TStringGrid(Component.Components[i]).ParentFont := True;
        end
        else if  Component.Components[i].ClassType = TLabeledEdit then
        begin
          TLabeledEdit(Component.Components[i]).EditLabel.Font.Color := ComponentColor;//$00644531;//$009B9B9B;
          TLabeledEdit(Component.Components[i]).StyleElements := [];
          TLabeledEdit(Component.Components[i]).Font.Name := ComponentFont;
          TLabeledEdit(Component.Components[i]).ParentFont := True;
        end;

       //Label Color
       if (TForm(Component).Caption <> '') or (TForm(Component).Caption = 'About') then
       begin

        if  Component.Components[i].ClassType = TLabel then
        begin
          if TForm(Component).Caption <> 'About' then
          begin
            TLabel(Component.Components[i]).AutoSize := False;
            TLabel(Component.Components[i]).ParentFont := true;
           // TLabel(Component.Components[i]).Font.size := 6;

          end;

          TLabel(Component.Components[i]).Font.Color := clBlack;//$00644531;//$009B9B9B;
          //TLabel(Component.Components[i]).StyleElements := [];
          TLabel(Component.Components[i]).Font.Name := ComponentFont;
        end;

       end;

         // Abort and Cancel Color
      { if Component.Components[i].ClassType = TPanel then
        if (TPanel(Component.Components[i]).Caption = 'Abort') or (TPanel(Component.Components[i]).Caption = 'Cancel') then
          TPanel(Component.Components[i]).Color := $00644531;   }

       {if  TForm(Component).Caption = '' then
       begin

        if  Component.Components[i].ClassType = TPanel then
          TPanel(Component.Components[i]).Color := $00858585
        else
        if  Component.Components[i].ClassType = TLabel then
          TLabel(Component.Components[i]).Font.Color := clBlack;
       end;  }

    end;
  end;

   //Shape for FORM
   if TForm(Component).BorderStyle  = bsNone then  //Disable only for TPlanWCControl
   begin
      Rgn := CreateRoundRectRgn(0, 0, Component.Width, Component.Height, 20, 20);
      SetWindowRgn(TWinControl(Component).handle, Rgn, True);
      //TForm(Component).Font.Size := 28;
   end;




   //TForm(Component).Position := poScreenCenter;
end;

initialization
  GDrawHelper := Gost.Create;
finalization
  GDrawHelper.Free;

end.

