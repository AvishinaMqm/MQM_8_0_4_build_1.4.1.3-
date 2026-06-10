unit UGgraph;

interface

uses
  Windows,
  graphics,
  UMSchedContFunc,
  UMSchedCont;

//  UVColors;

  procedure DrawArrowOnRect(canvas: TCanvas; rect: TRect; moved: CMoved;
                            redim: double);
  procedure DrawProgressed(canvas: TCanvas; rect: TRect; ProgType: CProgress);
  procedure DrawLink(canvas: TCanvas; Xul, Yul, Xbr, Ybr: integer);

implementation

const
  ARROW_WIDTH = 2;       // arrow width

//----------------------------------------------------------------------------//

procedure DrawArrowOnRect(canvas: TCanvas; rect: TRect; moved: CMoved;
                          redim: double);
var
  width,   height,
  hfWidth, hfHeight: integer;
  arrow:             array[0..2] of TPoint;
  oldPenWidth: integer;
begin
  with canvas do
  begin
    oldPenWidth := Pen.Width;
    Pen.Color := clYellow;
    Pen.Width := ARROW_WIDTH;

    width    := rect.Right - rect.Left;
    height   := rect.Bottom - rect.Top;
    hfWidth  := width  div 2;
    hfHeight := height div 2;

    case moved of
    mov_right: if redim > 0 then
               begin // +>
                 arrow[0].x := rect.Left + hfWidth;
                 arrow[0].y := rect.Top + 1;
                 arrow[1].x := rect.Left + hfWidth + hfHeight;
                 arrow[1].y := rect.Top + hfHeight;
                 arrow[2].x := arrow[0].x;
                 arrow[2].y := rect.Top + height - 1;

                 PolyLine( arrow );

                 MoveTo(rect.Left + hfWidth - 1 ,       rect.Top + hfHeight);
                 LineTo(rect.Left + hfWidth - height ,  rect.Top + hfHeight);
                 MoveTo(rect.Left + hfWidth - hfHeight, rect.Top + 1);
                 LineTo(rect.Left + hfWidth - hfHeight, rect.Top + height - 1)

               end else if redim < 0 then // ->
               begin
                 arrow[0].x := rect.Left + hfWidth;
                 arrow[0].y := rect.Top + 1;
                 arrow[1].x := rect.Left + hfWidth + hfHeight;
                 arrow[1].y := rect.Top + hfHeight;
                 arrow[2].x := arrow[0].x;
                 arrow[2].y := rect.Top + height - 1;

                 PolyLine( arrow );

                 MoveTo(rect.Left + hfWidth - 1 ,      rect.Top + hfHeight);
                 LineTo(rect.Left + hfWidth - height , rect.Top + hfHeight);

               end else  // >
               begin
                 arrow[0].x := rect.Left + hfWidth - height div 4;
                 arrow[0].y := rect.Top + 1;
                 arrow[1].x := rect.Left + hfWidth + height div 4;
                 arrow[1].y := rect.Top + hfHeight;
                 arrow[2].x := arrow[0].x;
                 arrow[2].y := rect.Top + height - 1;

                 PolyLine( arrow )
               end;

    mov_left:  if redim > 0 then
               begin // +<
                 arrow[0].x := rect.Left + hfWidth + hfHeight;
                 arrow[0].y := rect.Top + 1;
                 arrow[1].x := rect.Left + hfWidth;
                 arrow[1].y := rect.Top + hfHeight;
                 arrow[2].x := arrow[0].x;
                 arrow[2].y := rect.Top + height - 1;

                 PolyLine( arrow );

                 MoveTo(rect.Left + hfWidth - 1 , rect.Top + hfHeight);
                 LineTo(rect.Left + hfWidth - height , rect.Top + hfHeight);
                 MoveTo(rect.Left + hfWidth - hfHeight, rect.Top + 1);
                 LineTo(rect.Left + hfWidth - hfHeight, rect.Top + height - 1);

               end else if redim < 0 then // -<
               begin
                 arrow[0].x := rect.Left + hfWidth + hfHeight;
                 arrow[0].y := rect.Top + 1;
                 arrow[1].x := rect.Left + hfWidth;
                 arrow[1].y := rect.Top + hfHeight;
                 arrow[2].x := arrow[0].x;
                 arrow[2].y := rect.Top + height - 1;

                 PolyLine( arrow );

                 MoveTo(rect.Left + hfWidth  - 1 , rect.Top + hfHeight);
                 LineTo(rect.Left + hfWidth  - height , rect.Top + hfHeight);
               end else
               begin // <
                 arrow[0].x := rect.Left + hfWidth + height div 4;
                 arrow[0].y := rect.Top + 1;
                 arrow[1].x := rect.Left + hfWidth - height div 4;
                 arrow[1].y := rect.Top + hfHeight;
                 arrow[2].x := arrow[0].x;
                 arrow[2].y := rect.Top + height - 1;

                 PolyLine( arrow )
               end;

    mov_none:  if Redim > 0 then
               begin // +
                 MoveTo(rect.Left + hfWidth + hfHeight, rect.Top + hfHeight);
                 LineTo(rect.Left + hfWidth - hfHeight, rect.Top + hfHeight);
                 MoveTo(rect.Left + hfWidth, rect.Top + 1);
                 LineTo(rect.Left + hfWidth, rect.Top + height - 1);
               end else if Redim < 0 then
               begin // -
                 MoveTo(rect.Left + hfWidth + hfHeight, rect.Top + hfHeight);
                 LineTo(rect.Left + hfWidth - hfHeight, rect.Top + hfHeight)
               end
    end;
    Pen.Width := oldPenWidth
  end
end;

//----------------------------------------------------------------------------//

procedure DrawProgressed(canvas: TCanvas; rect: TRect; ProgType: CProgress);
var
  OrigBrushColor,
  OrigPenColor:   TColor;
  p1, p2, p3:     TPoint;
begin
  if (ProgType = prg_none)
  or ((rect.Right - rect.Left) < 15) then exit;

  with canvas do
  begin
    OrigBrushColor := Brush.Color;
    OrigPenColor   := Pen.Color;

//    Brush.Color := clBlack;
//    Pen.Color := clBlack;

    Brush.Color := clWhite;
    Pen.Color := clWhite;

    if (ProgType = prg_Starting) or (ProgType = prg_General) then
    begin
      p1.x := rect.Left + 1;
      p1.y := rect.Top+1;
      p2.x := rect.Left + 1;
      p2.y := rect.Bottom - 2;
      p3.x := rect.Left + 7;

      p3.y := rect.Top + (rect.Bottom - rect.Top) div 2;
      Polygon([p1,p2,p3]);

      if (ProgType = prg_General) then
      begin
        p1.x := rect.Right  - 2;
        p1.y := rect.Top    + 1;
        p2.x := rect.Right  - 2;
        p2.y := rect.Bottom - 2;
        p3.x := rect.Right  - 6 -2;

        p3.y := rect.Top + (rect.Bottom - rect.Top) div 2;
        Polygon([p1,p2,p3])
      end;

    end else
    begin
      Rectangle(rect.Left+1, rect.Top+1, rect.Left + 7, rect.Bottom-1);
      Rectangle(rect.Right-1, rect.Top+1, rect.Right-7, rect.Bottom-1);
      if (ProgType = prg_FinalSplit) then
      begin
//        Pen.Color := clWhite;
        Pen.Color := clBlack;
        MoveTo(rect.Right-1, rect.Top+1);
        LineTo(rect.Right-7, rect.Bottom-1);
        MoveTo(rect.Right-7, rect.Top+1);
        LineTo(rect.Right-1, rect.Bottom-1)
      end
    end;

    Brush.Color := OrigBrushColor;
    Pen.Color   := OrigPenColor
  end;

end;

//----------------------------------------------------------------------------//

procedure DrawLink(canvas: TCanvas; Xul, Yul, Xbr, Ybr: integer);
begin
  with canvas do
  begin
    MoveTo(Xul, Yul);
//    LineTo(Xul + 5, Yul);
//    LineTo(Xbr - 5, Ybr);
    LineTo(Xbr, Ybr);
  end;
end;

//----------------------------------------------------------------------------//

end.
