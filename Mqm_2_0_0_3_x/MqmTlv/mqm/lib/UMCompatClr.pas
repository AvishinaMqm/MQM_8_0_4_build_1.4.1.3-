unit UMCompatClr;

interface

uses
  graphics,
  UMglobal,
  UMSchedContFunc,
  UMCompat;

  procedure GetResCompatColor(cmp: TCompatVal; brush: TBrush; pen: TPen; font: TFont);
  procedure GetCapResCompatColor(cmp: TCompatVal; ForPlan: boolean; brush: TBrush; pen: TPen; font: TFont);
  procedure GetOccCompatColor(cmp: TCompatVal; ForPlan: boolean; brush: TBrush; pen: TPen; font: TFont);
//  procedure GetErrorColor(Err: CScErrors; ForPlan: boolean; brush: TBrush; pen: TPen; font: TFont);
  procedure GetStatusColor(Err: CScErrors; ForPlan: boolean; brush: TBrush; pen: TPen; font: TFont);
  procedure GetDateWarningColor(Err: SetOfErrors; ForPlan: boolean; brush: TBrush; pen: TPen; font: TFont);
  procedure GetMatWarningColor(Err: SetOfErrors; ForPlan: boolean; brush: TBrush; pen: TPen; font: TFont);
  procedure GetResNormalColors(schedType: CScSchedType; isMulti, readOnly: boolean;
                               brush: TBrush; pen: TPen; font: TFont);
//  function  GetCapResColors(ClrIndex: integer; var brush,pen,font: Tcolor): boolean;

  procedure GetClrFromArr(cmp: integer; arrDt: array of TDetCmpClr; var int, brd, txt: TColor);

implementation

//uses
//  UMGlobal;

{
type
  TDetCmpClr = record
    lim: integer;
    int: TColor;
    brd: TColor;
    txt: TColor;
  end;
}

//----------------------------------------------------------------------------//

procedure GetClrFromArr(cmp: integer; arrDt: array of TDetCmpClr; var int, brd, txt: TColor);
//var
//  i: integer;
begin

   {
   // Avi
  for i := 0 to High(arrDt) do
    if cmp <= arrDt[i].lim then
    begin
      int := arrDt[i].int;
      brd := arrDt[i].brd;
      txt := arrDt[i].txt;
      exit
    end;

  int := $00000000;
  brd := $00000000;
  txt := $00000000   }

  int := arrDt[cmp].int;
  brd := arrDt[cmp].brd;
  txt := arrDt[cmp].txt;
end;

//----------------------------------------------------------------------------//

procedure GetResCompatColor(cmp: TCompatVal; brush: TBrush; pen: TPen; font: TFont);
var
  int, brd, txt: TColor;
begin
  GetClrFromArr(cmp, DBAppGlobals.JobCapToRscCompColor, int, brd, txt);
  brush.Style := bsSolid;
  brush.Color := int;
  pen.Color   := brd;
  font.Color  := txt
end;

//----------------------------------------------------------------------------//

procedure GetCapResCompatColor(cmp: TCompatVal; ForPlan: boolean; brush: TBrush; pen: TPen; font: TFont);
var
  int, brd, txt: TColor;
begin
  GetClrFromArr(cmp, DBAppGlobals.JobToCapCompColor, int, brd, txt);
  brush.Style := bsSolid;
  brush.Color := int;
  pen.Style   := psSolid;
  pen.Color   := brd;
  font.Color  := txt
end;

//----------------------------------------------------------------------------//

procedure GetOccCompatColor(cmp: TCompatVal; ForPlan: boolean; brush: TBrush; pen: TPen; font: TFont);
var
  int, brd, txt: TColor;
begin
  GetClrFromArr(cmp, DBAppGlobals.JobToJobCompColor, int, brd, txt);
  brush.Style := bsSolid;
  brush.Color := int;
  pen.Color   := brd;
  font.Color  := txt
end;

//----------------------------------------------------------------------------//

procedure GetStatusColor(Err: CScErrors; ForPlan: boolean; brush: TBrush; pen: TPen; font: TFont);
var
  int, brd, txt: TColor;
begin
  case Err of
    CSE_Temp        : GetClrFromArr(0, DBAppGlobals.JobStatusColor, int, brd, txt);
    CSE_Level1      : GetClrFromArr(1, DBAppGlobals.JobStatusColor, int, brd, txt);
    CSE_Level2      : GetClrFromArr(2, DBAppGlobals.JobStatusColor, int, brd, txt);
    CSE_Level3      : GetClrFromArr(3, DBAppGlobals.JobStatusColor, int, brd, txt);
    CSE_Level4      : GetClrFromArr(4, DBAppGlobals.JobStatusColor, int, brd, txt);
    CSE_Level5      : GetClrFromArr(5, DBAppGlobals.JobStatusColor, int, brd, txt);
    CSE_Final       : GetClrFromArr(6, DBAppGlobals.JobStatusColor, int, brd, txt);
    CSE_NotFinProg  : GetClrFromArr(7, DBAppGlobals.JobStatusColor, int, brd, txt);
    CSE_FinProg     : GetClrFromArr(8, DBAppGlobals.JobStatusColor, int, brd, txt);
    CSE_Closed      : GetClrFromArr(9, DBAppGlobals.JobStatusColor, int, brd, txt);
    CSE_Ignored_Initial      : GetClrFromArr(10, DBAppGlobals.JobStatusColor, int, brd, txt);
    CSE_Ignored_Generic      : GetClrFromArr(11, DBAppGlobals.JobStatusColor, int, brd, txt);
    CSE_Ignored_Final      : GetClrFromArr(12, DBAppGlobals.JobStatusColor, int, brd, txt);
  else
    GetClrFromArr(0, DBAppGlobals.JobStatusColor, int, brd, txt);
  end;

  brush.Color := int;
  pen.Color   := brd;
  font.Color  := txt
end;

//----------------------------------------------------------------------------//

procedure GetDateWarningColor(Err: SetOfErrors; ForPlan: boolean; brush: TBrush; pen: TPen; font: TFont);
var
  int, brd, txt: TColor;
begin
  if CSE_DelDate in Err then
    GetClrFromArr(0, DBAppGlobals.JobDateWarningColor, int, brd, txt)
  else
    if CSE_HighEndDate in Err then
      GetClrFromArr(1, DBAppGlobals.JobDateWarningColor, int, brd, txt)
   else if CSE_ApprovalDate in Err then
        GetClrFromArr(3, DBAppGlobals.JobDateWarningColor, int, brd, txt)
   else if CSE_LowStrDate in Err then
        GetClrFromArr(2, DBAppGlobals.JobDateWarningColor, int, brd, txt);


  brush.Color := int;
  pen.Color   := brd;
  font.Color  := txt
end;

//----------------------------------------------------------------------------//

procedure GetMatWarningColor(Err: SetOfErrors; ForPlan: boolean; brush: TBrush; pen: TPen; font: TFont);
var
  int, brd, txt: TColor;
begin
  if  not (CSE_Materials in Err)
  and not (CSE_AddRes in Err)
  and ((CSE_LeftOvlp in Err) or (CSE_RightOvlp in Err) or (CSE_BothOvlp in Err)) then
    GetClrFromArr(0, DBAppGlobals.JobMatWarningColor, int, brd, txt);

  if  (CSE_Materials in Err)
  and (CSE_AddRes in Err) then
    GetClrFromArr(3, DBAppGlobals.JobMatWarningColor, int, brd, txt)
  else
    if (CSE_Materials in Err) then
      GetClrFromArr(1, DBAppGlobals.JobMatWarningColor, int, brd, txt)
    else
      if (CSE_AddRes in Err) then
        GetClrFromArr(2, DBAppGlobals.JobMatWarningColor, int, brd, txt);

  if (CSE_LeftOvlp in Err) then
    brush.Style := bsFDiagonal
  else
    if (CSE_RightOvlp in Err) then
      brush.Style := bsBDiagonal
    else
      if (CSE_BothOvlp in Err) then
        brush.Style := bsDiagCross
      else
        brush.Style := bsSolid;

  brush.Color := int;
  pen.Color   := brd;
  font.Color  := txt
end;

//----------------------------------------------------------------------------//
{
procedure GetErrorColor(Err: CScErrors; ForPlan: boolean; brush: TBrush; pen: TPen; font: TFont);
var
  int, brd, txt: TColor;
//  ErrIndex: integer;
begin
//  ErrIndex := integer(Err);
//  GetClrFromArr(ErrIndex, DBAppGlobals.JobStatusColor, int, brd, txt);
  case Err of
    CSE_Temp        : GetClrFromArr(0, DBAppGlobals.JobStatusColor, int, brd, txt);
    CSE_Level1      : GetClrFromArr(1, DBAppGlobals.JobStatusColor, int, brd, txt);
    CSE_Level2      : GetClrFromArr(2, DBAppGlobals.JobStatusColor, int, brd, txt);
    CSE_Level3      : GetClrFromArr(3, DBAppGlobals.JobStatusColor, int, brd, txt);
    CSE_Level4      : GetClrFromArr(4, DBAppGlobals.JobStatusColor, int, brd, txt);
    CSE_Level5      : GetClrFromArr(5, DBAppGlobals.JobStatusColor, int, brd, txt);
    CSE_Final       : GetClrFromArr(6, DBAppGlobals.JobStatusColor, int, brd, txt);
    CSE_NotFinProg  : GetClrFromArr(7, DBAppGlobals.JobStatusColor, int, brd, txt);
    CSE_FinProg     : GetClrFromArr(8, DBAppGlobals.JobStatusColor, int, brd, txt);
    CSE_Closed      : GetClrFromArr(9, DBAppGlobals.JobStatusColor, int, brd, txt);

    CSE_DelDate     : GetClrFromArr(0, DBAppGlobals.JobDateWarningColor, int, brd, txt);
    CSE_HighEndDate : GetClrFromArr(1, DBAppGlobals.JobDateWarningColor, int, brd, txt);
    CSE_LowStrDate  : GetClrFromArr(2, DBAppGlobals.JobDateWarningColor, int, brd, txt);

    CSE_LeftOvlp,
    CSE_RightOvlp,
    CSE_BothOvlp   : GetClrFromArr(0, DBAppGlobals.JobMatWarningColor, int, brd, txt);
    CSE_Materials,
    CSE_AddRes    : begin
                      GetClrFromArr(1, DBAppGlobals.JobMatWarningColor, int, brd, txt);
                    end;
  end;

  case Err of
    CSE_LeftOvlp  : brush.Style := bsFDiagonal;
    CSE_RightOvlp : brush.Style := bsBDiagonal;
    CSE_BothOvlp  : brush.Style := bsDiagCross;
  else
    brush.Style := bsSolid;
  end;

  brush.Color := int;
  pen.Color   := brd;
  font.Color  := txt
end;
}
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
        if not isMulti then
        begin
          if not readOnly then
          begin
            brush.Color := DBAppGlobals.ResColors[0].int;  // Continue simple
            pen.Color := DBAppGlobals.ResColors[0].brd;    // Continue simple
            font.Color := DBAppGlobals.ResColors[0].txt;   // Continue simple
          end
          else
          begin
            brush.Color := DBAppGlobals.ResColors[1].int;  // Continue simple Read only
            pen.Color := DBAppGlobals.ResColors[1].brd;    // Continue simple Read only
            font.Color := DBAppGlobals.ResColors[1].txt;   // Continue simple Read only
          end;
        end
        else
        begin
          if not readOnly then
          begin
            brush.Color := DBAppGlobals.ResColors[2].int;  // Continue Multi
            pen.Color := DBAppGlobals.ResColors[2].brd;    // Continue Multi
            font.Color := DBAppGlobals.ResColors[2].txt;   // Continue Multi
          end
          else
          begin
            brush.Color := DBAppGlobals.ResColors[3].int;  // Continue Multi Read only
            pen.Color := DBAppGlobals.ResColors[3].brd;    // Continue Multi Read only
            font.Color := DBAppGlobals.ResColors[3].txt;   // Continue Multi Read only
          end;
        end;
      end;
    CST_batch:
      begin
        if not isMulti then
        begin
          if not readOnly then
          begin
            brush.Color := DBAppGlobals.ResColors[4].int;  // Batch simple
            pen.Color := DBAppGlobals.ResColors[4].brd;    // Batch simple
            font.Color := DBAppGlobals.ResColors[4].txt;   // Batch simple
          end
          else
          begin
            brush.Color := DBAppGlobals.ResColors[5].int;  // Batch simple Read Only
            pen.Color := DBAppGlobals.ResColors[5].brd;    // Batch simple Read Only
            font.Color := DBAppGlobals.ResColors[5].txt;   // Batch simple Read Only
          end;
        end
        else
        begin
          if not readOnly then
          begin
            brush.Color := DBAppGlobals.ResColors[6].int;  // Batch Multi
            pen.Color := DBAppGlobals.ResColors[6].brd;    // Batch Multi
            font.Color := DBAppGlobals.ResColors[6].txt;   // Batch Multi
          end
          else
          begin
            brush.Color := DBAppGlobals.ResColors[7].int;  // Batch Multi Read Only
            pen.Color := DBAppGlobals.ResColors[7].brd;    // Batch Multi Read Only
            font.Color := DBAppGlobals.ResColors[7].txt;   // Batch Multi Read Only
          end;
        end;
      end
    else   // CST_printing
    begin
      if not isMulti then
      begin
        if not readOnly then
        begin
          brush.Color := DBAppGlobals.ResColors[8].int;  // Printing simple
          pen.Color := DBAppGlobals.ResColors[8].brd;    // Printing simple
          font.Color := DBAppGlobals.ResColors[8].txt;   // Printing simple
        end
        else
        begin
          brush.Color := DBAppGlobals.ResColors[9].int;  // Printing simple Read Only
          pen.Color := DBAppGlobals.ResColors[9].brd;    // Printing simple Read Only
          font.Color := DBAppGlobals.ResColors[9].txt;   // Printing simple Read Only
        end;
      end
      else
      begin
        if not readOnly then
        begin
          brush.Color := DBAppGlobals.ResColors[10].int;  // Printing Multi
          pen.Color := DBAppGlobals.ResColors[10].brd;    // Printing Multi
          font.Color := DBAppGlobals.ResColors[10].txt;   // Printing Multi
        end
        else
        begin
          brush.Color := DBAppGlobals.ResColors[11].int;  // Printing Multi Read Only
          pen.Color := DBAppGlobals.ResColors[11].brd;    // Printing Multi Read Only
          font.Color := DBAppGlobals.ResColors[11].txt;   // Printing Multi Read Only
        end;
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//
{
function getCapResColors(ClrIndex: integer; var brush,pen,font: Tcolor): boolean;
begin
  result := false;
  if (ClrIndex < low(DBAppGlobals.CapResColors))
  or (ClrIndex > high(DBAppGlobals.CapResColors)) then
    exit;

  brush := DBAppGlobals.CapResColors[ClrIndex].int;
  pen := DBAppGlobals.CapResColors[ClrIndex].brd;
  font := DBAppGlobals.CapResColors[ClrIndex].txt;
  result := true;
end;
}
//----------------------------------------------------------------------------//

end.
