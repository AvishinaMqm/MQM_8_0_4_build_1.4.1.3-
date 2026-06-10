unit UMColors;

interface

uses
  Graphics,
  UMSchedCont;

//  procedure GetResNormalColors(schedType: CScSchedType; isMulti, readOnly: boolean;
//                               brush: TBrush; pen: TPen; font: TFont);

implementation

//----------------------------------------------------------------------------//

procedure GetResNormalColors(schedType: CScSchedType; isMulti, readOnly: boolean;
                             brush: TBrush; pen: TPen; font: TFont);
begin
  if readOnly then
    brush.Style := bsDiagCross
  else
    brush.Style := bsSolid;

  case schedType of

  CST_continuous:
      begin
        if isMulti then
        begin
          brush.Color := $00DD7777;
          pen.Color   := clBlack;
          font.Color  := clBlack;
        end
        else
        begin
          brush.Color := $00FF9999;
          pen.Color   := clBlack;
          font.Color  := clBlack;
        end
      end;

  CST_batch:
      begin
        if isMulti then
        begin
          brush.Color := $0077DD77;
          pen.Color   := clBlack;
          font.Color  := clBlack
        end
        else
        begin
          brush.Color := $0099FF99;
          pen.Color   := clBlack;
          font.Color  := clBlack
        end
      end;

  else
      // CST_printing
      begin
        if isMulti then
        begin
          brush.Color := $007777DD;
          pen.Color   := clBlack;
          font.Color  := clBlack
        end
        else
        begin
          brush.Color := $009999FF;
          pen.Color   := clBlack;
          font.Color  := clBlack
        end
      end
  end
end;

//----------------------------------------------------------------------------//
end.
