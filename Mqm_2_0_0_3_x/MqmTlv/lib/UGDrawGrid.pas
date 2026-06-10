unit UGDrawGrid;

interface

uses
  Windows, Messages, Graphics, Classes, SysUtils, Controls, Forms, Dialogs,
  StdCtrls, Grids, UMGlobal;

type
//  TOrientation  = (oColumnMajor,oRowMajor);

  TMQMDrawGrid = class(TDrawGrid)
  private
    { Private declarations }
    fMultiSelect  : boolean;
    fSelected : array of boolean;
    FocusCol      : integer;
    FocusRow      : integer;
    fOnDrawCell   : TDrawCellEvent;
    fOnSelectCell : TSelectCellEvent;
//    fOrientation  : TOrientation;
    fOnClick      : TNotifyEvent;
    fOnMouseUp    : TMouseEvent;
    fOnMouseDown  : TMouseEvent;
    fOnMouseMove  : TMouseEvent;
    MouseDowned   : boolean;
    SelAnchor : integer;
    function  CellToIndex(ACol, ARow : integer) : integer;
    function  ButtonState(msg : TWMMOUSE) : TMouseButton;
    function  ShiftState(msg : TWMMOUSE) : TShiftState;
//    procedure ForceSelected(Index : integer);
//    procedure ForceUnSelected(Index : integer);
    procedure DoDrawCell(Sender: TObject; ACol, ARow: Longint;
                 Rect: TRect; State: TGridDrawState);
    procedure DoSelectCell(Sender: TObject; ACol, ARow: Longint;
                    var CanSelect: Boolean);
    function  Min(a,b : integer) : integer;
    function  Max(a,b : integer) : integer;
    procedure CalculateColsAndRows;
  protected
    { Protected declarations }
    procedure DoMouseUp(var Msg : TWMMOUSE);
                   message WM_LBUTTONUP;
    procedure DoMouseDown(var Msg : TWMMOUSE);
                   message WM_LBUTTONDOWN;
    procedure DoMouseMove(var Msg : TWMMOUSE);
                   message WM_MOUSEMOVE;
    function  GetSelected(index : integer) : boolean;
    procedure SetSelected(index : integer; value : boolean);
    procedure DoResize(var Msg : TMessage);
                   message WM_SIZE;
    procedure RowHeightsChanged; override;
    procedure ColWidthsChanged;  override;
  public
    UpdateDeferred : boolean;
    constructor Create(AOwner : TComponent); override;
        procedure ForceSelected(Index : integer);
    procedure ForceUnSelected(Index : integer);

    procedure   InvalidateCell(Index : integer);
    procedure   IndexToCell(Index : integer; var ACol, ARow : integer);
    property    Selected[index :integer] : boolean
                     read GetSelected write SetSelected;
  published
    property MultiSelect  : boolean
                        read fMultiSelect write fMultiSelect;
    property OnSelectCell : TSelectCellEvent
                                            read fOnSelectCell write fOnSelectCell;
    property OnDrawCell : TDrawCellEvent    read fOnDrawCell write fOnDrawCell;
    property OnClick    : TNotifyEvent      read fOnClick    write fOnClick;
    property OnMouseUp  : TMouseEvent       read fOnMouseUp  write fOnMouseUp;
    property OnMouseDown: TMouseEvent       read fOnMouseDown write fOnMouseDown;
    property OnMouseMove: TMouseEvent       read fOnMouseMove write fOnMouseMove;
  end;

  TMQMDrawGridBin = class(TDrawGrid)
  private
    { Private declarations }
    fSelected : array of boolean;
  protected
    function  SelectedMarked : boolean;
    function  GetSelected(index : integer) : boolean;
    procedure SetSelected(index : integer; value : boolean);
    procedure DoResize(var Msg : TMessage);
                   message WM_SIZE;
    procedure RowHeightsChanged; override;
    procedure ColWidthsChanged;  override;
  public

    FocusCol      : integer;
    FocusRow      : integer;
    SelAnchor : integer;
    UpdateDeferred : boolean;

    function  Min(a,b : integer) : integer;
    function  Max(a,b : integer) : integer;

    function  CellToIndex(ACol, ARow : integer) : integer;
    procedure ForceSelected(Index : integer);
    procedure ForceUnSelected(Index : integer);
    procedure SetSelectedLenght;
    procedure ResSetSelectedLenght;

    procedure   InvalidateCell(Index : integer); virtual;
    procedure   IndexToCell(Index : integer; var ACol, ARow : integer);
    property    Selected[index :integer] : boolean
                     read GetSelected write SetSelected;
    property   pSelectedMarked : boolean read SelectedMarked;

  end;

implementation

//----------------------------------------------------------------------------//

constructor TMQMDrawGrid.Create(AOwner : TComponent);
begin
   inherited Create(AOwner);

//   SetLength(fSelected,300);

   fOnDrawCell   := nil;
   fOnSelectCell := nil;
   fOnClick      := nil;
//   fOrientation  := oRowMajor;
   fMultiSelect  := true;

   MouseDowned   := false;

   if not (csDesigning in ComponentState) then begin
      inherited OnSelectCell := DoSelectCell;
      inherited OnDrawCell   := DoDrawCell;

      FocusCol      := -1;
      FocusRow      := -1;
     SelAnchor      := -1;
   end;
end;

//----------------------------------------------------------------------------//

function TMQMDrawGrid.GetSelected(index : integer) : boolean;
begin
   if Length(fSelected) < RowCount then
    SetLength(fSelected,RowCount);
   result := fSelected[index];
end;

//----------------------------------------------------------------------------//

procedure TMQMDrawGrid.SetSelected(index : integer; value : boolean);
begin;
   fSelected[index] := value;
   InvalidateCell(Index);
end;

//----------------------------------------------------------------------------//

procedure TMQMDrawGrid.InvalidateCell(Index : integer);
var
   ARow, ACol : longint;
   State      : TGridDrawState;
   Rect       : TRect;
begin
   if UpdateDeferred then exit;

   IndexToCell(Index,ACol,ARow);
   if ARow < 0 then
    exit;

   for Acol := 0 to ColCount-1 do
   begin
     Rect  := CellRect(ACol, ARow);
     if (Rect.Top = Rect.Bottom) and (Rect.Left = Rect.Right)
//sav        then exit;
        then continue;

     if Selected[index]
        then State := [gdSelected]
        else State := [];
     if (ARow < FixedRows) or (ACol < FixedCols)
        then State := State + [gdFixed];
     if (ARow = FocusRow) and (ACol = FocusCol)
        then State := State + [gdFocused];

     DoDrawCell(Self, ACol, ARow, Rect, State);
   end;
end;

//----------------------------------------------------------------------------//

// CellToIndex returns the column and row corresponding to a given index.
procedure TMQMDrawGrid.IndexToCell(Index : integer; var ACol, ARow : integer);
begin
   if (Index < 0) or (Index >= RowCount-1)
      then begin
            ACol  := -1;
            ARow  := -1;
            exit;
   end;
{sav
   if fOrientation = oRowMajor
      then begin
            ARow  := Index div ColCount;
            ACol  := Index mod ColCount;
      end
      else begin
            ACol  := Index div RowCount;
            ARow  := Index mod RowCount;
      end;
}
   ARow  := Index +1;
//sav   ACol  := LeftCol;
   ACol  := LeftCol;
end;

//----------------------------------------------------------------------------//

procedure TMQMDrawGrid.DoDrawCell(Sender: TObject; ACol, ARow: Longint;
                    Rect: TRect; State: TGridDrawState);
var
   index    : integer;
   PassRect : TRect;
begin
   index := CellToIndex(ACol,ARow);
   Canvas.Brush.Style := bsSolid;

   // Fill the rectangle with the control's color. If the index isn't
   // pointing at an occupied cell, exit.
   Canvas.Brush.Color := TColor(GetSysColor(COLOR_BTNFACE));
   Canvas.FillRect(Rect);
   if index >= 0 then
   begin
     if Selected[index]
        then begin
               Canvas.Brush.Color := TColor(GetSysColor(COLOR_HIGHLIGHT));
               Canvas.Font.Color  := TColor(GetSysColor(COLOR_HIGHLIGHTTEXT));
        end
        else begin
               Canvas.Brush.Color := color;
               Canvas.Font.Color  := TColor(GetSysColor(COLOR_BTNTEXT));
        end;
   end;

   if Assigned(OnDrawCell) then begin
      with Rect do
         PassRect := Classes.Rect(Left,
                                  Top,
                                  Left + ColWidths[ACol],
                                  Top  + RowHeights[ARow]);
      OnDrawCell(Sender, ACol, ARow, PassRect, State);
   end;
end;

//----------------------------------------------------------------------------//

// CellToIndex returns the index value corresponding to a given cell.
function TMQMDrawGrid.CellToIndex(ACol,ARow : integer) : integer;
begin
{sav
      if (ARow < 0)
           or (ARow >= RowCount)
           or (ACol <  0)
           or (ACol >= ColCount)
        then result := -1
        else begin
                if fOrientation = oRowMajor
                     then result := ARow * ColCount + ACol
                     else result := ACol * RowCount + ARow;
                if (result < 0) or (result >= RowCount-1)
                    then result := -1;
        end;
}
  result := ARow-1
end;

// Respond to left-clicks.
procedure TMQMDrawGrid.DoMouseDown
               (var Msg : TWMMOUSE);
var
   ARow, ACol   : integer;
//   index        : integer;
   MousePos     : TPoint;
   ClientPos    : TPoint;
begin
   inherited MouseDown(ButtonState(msg), ShiftState(msg), msg.Xpos, msg.Ypos); //sav

   MouseDowned  := true;

   // Perform a SelectCell operation.
   MouseToCell(msg.Xpos,msg.Ypos,ACol,ARow);
   SelectCell(ACol, ARow);

//   index := CellToIndex(ACol,ARow);
{
   // If the selected cell is occupied and selected and the left mouse
   // button is used and fDragCells is true, start a drag.
   if index >= 0
      then begin
              if (msg.Keys = MK_LBUTTON) and (fDragCells)
                  then begin
                        IsDragging := dsMouseDown;
                        xDragOrigin := msg.Xpos;
                        yDragOrigin := msg.Ypos;
              end;
   end;
}
   if Assigned(fOnMouseDown)
       then begin
              MousePos.x := msg.XPos;
              MousePos.y := msg.YPos;
              ClientPos := ScreenToClient(MousePos);
              fOnMouseDown(Self, ButtonState(msg), ShiftState(msg),
                            ClientPos.x, ClientPos.y);
   end;
end;

procedure TMQMDrawGrid.DoMouseMove
               (var Msg : TWMMOUSE);
{
const
   RingCell     : integer = -1;
}
var
   MousePos     : TPoint;
   ClientPos    : TPoint;
{
   ACol,ARow    : integer;
   CurrCell     : integer;
   RingRect     : TRect;
}
begin
  inherited MouseMove(ShiftState(msg), msg.Xpos, msg.Ypos); //sav
{
//sav   KillTheTimer;
   GetCursorPos(MousePos);
   ClientPos := ScreenToClient(MousePos);

   // If the user has released the mouse button, cancel a drag
   // and exit.
   if HiWord(GetKeyState(VK_LBUTTON)) = 0
      then begin
             IsDragging := dsNotDragging;
             Cursor     := crDefault;
             exit;
   end;

   // If the mouse has moved enough to establish a drag, change
   // the cursor and set IsDragging. IsDragging won't be set to
   // dsMouseDown unless fDragCells is true.
   case IsDragging of
      dsMouseDown : if (abs(msg.XPos - xDragOrigin) >= xDragDelta)
                            or (abs(msg.YPos - yDragOrigin) >= yDragDelta)
                       then begin
                          IsDragging := dsDragging;
                          if SelCount > 1
                                then Self.Cursor := crMultiDrag
                                else Self.Cursor := crDrag;
                          SetCapture(Self.Handle);
                          RingCell := -1;
                       end;

      // If dragging, and the mouse has left the control, set the cursor
      // back to the default, and set the timer.
      // If the mouse has returned to the control, set the cursor back
      // to the drag cursor and disable the timer.
      dsDragging  : begin
                        MouseToCell(ClientPos.X,ClientPos.Y,ACol,ARow);
                        CurrCell := CellToIndex(ACol,ARow);

                        // If the mouse has moved to a new cell, redraw the
                        // last cell.
                        if CurrCell <> RingCell
                           then begin
                                  if RingCell >= 0 then begin
                                     InvalidateCell(RingCell);
                                     IndexToCell(RingCell,ACol,ARow);
                                     RingRect := CellRect(ACol,ARow);
                                     if (RingRect.Left <> RingRect.Right)
                                               or (RingRect.Top <> RingRect.Bottom)
                                         then InvalidateCell(RingCell);
                                  end;
                                  RingCell := -1;

                                  // If the cell over which the mouse sits is not
                                  // selected, draw a frame around it.
                                  if not Selected[CurrCell]
                                      then begin
                                         IndexToCell(CurrCell,ACol,ARow);
                                         RingRect := CellRect(ACol,ARow);
                                         if (RingRect.Left <> RingRect.Right)
                                               or (RingRect.Top <> RingRect.Bottom)
                                            then begin
                                                    with RingRect do begin
                                                       Left    := Left    + 1;
                                                       Right   := Right   - 2;
                                                       Top     := Top     + 1;
                                                       Bottom  := Bottom  - 2;
                                                    end;
                                                    with Canvas do begin
                                                       Brush.Color := -Self.Color;
                                                       Pen.Color   := Self.Color;
                                                       Brush.Style := bsBDiagonal;
                                                       Canvas.FrameRect(RingRect);
                                                    end;
                                            end;
                                         RingCell := CurrCell;
                                  end;
                        end;
                        with ClientPos do
                            if (x >= 0) and (x <  Width)
                                        and (y >= 0)
                                        and (y <  Height)
                               then begin
                                      KillTheTimer;
                                      if SelCount > 1
                                          then Self.Cursor := crMultiDrag
                                          else Self.Cursor := crDrag;
                               end
                               else begin
                                      MouseTimer := SetTimer
                                                  (Self.Handle,1,100,nil);
                                      Self.Cursor        := crDefault;
                               end;
                    end;
      else IsDragging := dsNotDragging;
   end;
}
   if Assigned(fOnMouseMove)
       then begin
              MousePos.x := msg.XPos;
              MousePos.y := msg.YPos;
              ClientPos := ScreenToClient(MousePos);
              fOnMouseMove(Self, ButtonState(msg), ShiftState(msg),
                            ClientPos.x, ClientPos.y);
   end;
end;

procedure TMQMDrawGrid.DoMouseUp
                (var Msg : TWMMOUSE);
var
    MousePos   : TPoint;
    ClientPos  : TPoint;
//    ACol, ARow : integer;
    Ctrl       : boolean;
    State      : TKeyboardState;
begin
  inherited MouseUp(ButtonState(msg), ShiftState(msg), msg.Xpos, msg.Ypos); //sav

  // If the mouse button never went down, exit.
  if not MouseDowned
     then exit;

  MouseDowned := false;

  GetKeyboardState(State);
  Ctrl  := ((State[vk_Control]   and 128) <> 0);
  if Ctrl
     then exit;

  Cursor  := crDefault;
  ReleaseCapture;
{sav
  if IsDragging = dsDragging
     then DoDragDrop(Self,Self,msg.XPos,msg.YPos)
     else begin
            // Perform a SelectCell operation, possibly to free
            // selections of other cells.
            MouseToCell(msg.Xpos,msg.Ypos,ACol,ARow);
            SelectCell(ACol, ARow);
     end;
  IsDragging := dsNotDragging;
}
  if Assigned(fOnMouseUp)
     then begin
            MousePos.x := msg.XPos;
            MousePos.y := msg.YPos;
            ClientPos := ScreenToClient(MousePos);
            fOnMouseUp(Self, ButtonState(msg), ShiftState(msg),
                          ClientPos.x, ClientPos.y);
  end;

  if Assigned(fOnMouseUp)
      then fOnMouseMove(Self, ButtonState(msg), ShiftState(msg),
                          ClientPos.x, ClientPos.y);
  if Assigned(fOnClick)
      then fOnClick(Self);
end;

function  TMQMDrawGrid.ButtonState(msg : TWMMOUSE) : TMouseButton;
begin
   if (msg.Keys and MK_LBUTTON) <> 0
      then result := mbLeft
      else
          if (msg.Keys and MK_RBUTTON) <> 0
              then result := mbRight
              else result := mbMiddle;
end;

function  TMQMDrawGrid.ShiftState(msg : TWMMOUSE) : TShiftState;
begin
//   result := [];
   if (msg.Keys and MK_CONTROL) <> 0
      then result := result + [ssCtrl];
   if (msg.Keys and MK_SHIFT) <> 0
      then result := result + [ssShift];
end;

procedure TMQMDrawGrid.DoSelectCell(Sender: TObject; ACol, ARow: Longint;
                    var CanSelect: Boolean);
var
   index         : integer;
   j             : integer;
   i             : integer;
   istart,istop  : integer;
   State         : TKeyboardState;
   Shift         : boolean;
   Ctrl          : boolean;
//   LButton       : boolean;
   SelRect       : TGridRect;
begin
   GetKeyboardState(State);
   Shift := ((State[vk_Shift]     and 128) <> 0);
   Ctrl  := ((State[vk_Control]   and 128) <> 0);
//   LButton := ((State[VK_LBUTTON] and 128) <> 0);

   // If MultiSelect is false, set Shift and Ctrl to false as well, to
   // nullify any multiselect attempt.
   if not fMultiSelect then begin
     Shift  := false;
     Ctrl   := false;
   end;

   index := CellToIndex(ACol,ARow);
   // CanSelect will be True if the Index is within Items. Otherwise,
   // set CanSelect to False and bail.
   CanSelect := (index < RowCount-1) and (index >= 0);
   if not CanSelect
      then exit;
{
   // If Shift is the left mouse button alone and the selected cell is
   // already selected, exit now--a drag may be starting.
   if (Selected[index]) and (not Shift) and (not Ctrl) and (LButton)
       then begin
              Application.ProcessMessages;
              exit;
   end;
}
   // Indicate which cell now has the focus, for use in InvalidateCell.
   FocusRow := ARow;
   FocusCol := ACol;

   SelRect.Top    := ARow;
   SelRect.Bottom := ARow;
   SelRect.Left   := 0;
   SelRect.Right  := ColCount-1;

   Selection := SelRect;

   // If the Shift key is not depressed, or there is no SelAnchor,
   // the user is selecting a single cell; if the cell is being
   // de-selected, cancel the SelAnchor setting. If Ctrl is not pressed,
   // clear all Selected first. Then select the cell being selected, and
   // ensure that SelAnchor points to it.
//sav   with Items do begin
      if (not Shift) or (SelAnchor < 0)
          then begin
                 if Ctrl
                     then begin
                              Selected[index] := not Selected[index];
                              if Selected[index]
                                 then SelAnchor := index
                                 else SelAnchor := -1;
                              InvalidateCell(index);
                     end
                     else begin
                              for j := 0 to RowCount - 1 do
                                  if Selected[j] then
                                     ForceUnselected(j);
                              ForceSelected(index);
                              SelAnchor  := index;
                           end;
                 end

      // If the Shift key is depressed, and SelAnchor was other than -1,
      // determine whether the selected cell precedes or follows SelAnchor,
      // select all cells between the two, and deselect all others.
      else begin
                istart := min(index,SelAnchor);
                istop  := max(index,SelAnchor);

                i := 0;
                while i < istart do begin
                   ForceUnselected(i);
                   inc(i);
                end;
                while i <= istop do begin
                   ForceSelected(i);
                   inc(i);
                end;
                while i < RowCount-1 do begin
                   ForceUnselected(i);
                   inc(i);
                end;
      end;
//sav   end;

   if Assigned(fOnSelectCell)
      then fOnSelectCell(Self, ACol, ARow, CanSelect);

   Application.ProcessMessages;
end;

// ForceSelected and ForceUnselected ensure that the cell at position
// [index] is Selected or UnSelected, and invalidates the cell if the
// status has changed.
procedure TMQMDrawGrid.ForceSelected(Index : integer);
begin
   if not Selected[index] then begin
      Selected[index] := true;
      InvalidateCell(Index);
   end;
end;

procedure TMQMDrawGrid.ForceUnSelected(Index : integer);
begin
   if Selected[index] then
   begin
      Selected[index] := false;
      InvalidateCell(Index);
   end;
end;

// Min and Max functions, so we don't have to include the Math unit.
function TMQMDrawGrid.Min(a,b : integer) : integer;
begin
   if a < b
      then result := a
      else result := b;
end;

function TMQMDrawGrid.Max(a,b : integer) : integer;
begin
   if a > b
      then result := a
      else result := b;
end;

procedure TMQMDrawGrid.DoResize(var msg: TMessage);
begin
  if msg.LParam <> StrToInt(IniAppGlobals.Identifier) then exit;
  CalculateColsAndRows;
end;

procedure TMQMDrawGrid.CalculateColsAndRows;
//var
//     glw, bw : integer;
begin
     if (csDesigning in ComponentState)
        then exit;
{
     glw := Max(GridLineWidth,1);
     bw  := Max(BorderWidth,1);

     if (DefaultColWidth > 0)
        then begin
               ColCount := (Width - GetSystemMetrics(SM_CXVSCROLL)
                                  - glw - (2 * bw))
                                  div (DefaultColWidth + glw);
               RowCount := (Height - GetSystemMetrics(SM_CYHSCROLL)
                                   - glw - (2 * bw))
                                  div (DefaultRowHeight + glw);
     end;
}
     Invalidate;
end;

procedure TMQMDrawGrid.RowHeightsChanged;
begin
  inherited RowHeightsChanged;
  PostMessage(Self.Handle,WM_SIZE,0,StrToInt(IniAppGlobals.Identifier));
end;

procedure TMQMDrawGrid.ColWidthsChanged;
begin
  inherited ColWidthsChanged;
  PostMessage(Self.Handle,WM_SIZE,0,StrToInt(IniAppGlobals.Identifier));
end;

{ TMQMDrawGridBin }

function TMQMDrawGridBin.CellToIndex(ACol, ARow: integer): integer;
begin
  result := ARow-1
end;

procedure TMQMDrawGridBin.ColWidthsChanged;
begin
  inherited;

end;

procedure TMQMDrawGridBin.DoResize(var Msg: TMessage);
begin

end;

procedure TMQMDrawGridBin.ForceSelected(Index: integer);
begin
  if not Selected[index] then
  begin
    Selected[index] := true;
    InvalidateCell(Index);
  end;
end;

procedure TMQMDrawGridBin.ForceUnSelected(Index: integer);
begin
  if Selected[index] then
  begin
    Selected[index] := false;
    InvalidateCell(Index);
  end;
end;

procedure TMQMDrawGridBin.SetSelectedLenght;
var
  I : Integer;
  Stam : string;
begin
  try
    if Assigned(fSelected) then
      Finalize(fSelected);
  except
    fSelected := nil;
  end;
  fSelected := nil;
  SetLength(fSelected,RowCount);
end;

procedure TMQMDrawGridBin.ResSetSelectedLenght;
begin
  if Assigned(fSelected) then
    Finalize(fSelected, 0);
end;

procedure TMQMDrawGridBin.IndexToCell(Index: integer; var ACol, ARow: integer);
begin
  if (Index < 0) or (Index >= RowCount-1) then
  begin
            ACol  := -1;
            ARow  := -1;
            exit;
  end;
  ARow  := Index +1;
  ACol  := LeftCol;
end;

procedure TMQMDrawGridBin.InvalidateCell(Index: integer);
begin
  InvalidateCell(Index);
end;

function TMQMDrawGridBin.Max(a, b: integer): integer;
begin
   if a > b
      then result := a
      else result := b;
end;

function TMQMDrawGridBin.Min(a, b: integer): integer;
begin
   if a < b
      then result := a
      else result := b;
end;

procedure TMQMDrawGridBin.RowHeightsChanged;
begin
  inherited;

end;

function TMQMDrawGridBin.GetSelected(index: integer): boolean;
begin
  if Length(fSelected) < RowCount then
   SetLength(fSelected,RowCount);
  result := fSelected[index];
end;

function TMQMDrawGridBin.SelectedMarked: boolean;
var
  I : integer;
begin
  result := false;
  for I := Low(fSelected) to High(fSelected) do
  begin
    if fSelected[i] then
    begin
      Result := true;
      exit
    end;
  end;
end;

procedure TMQMDrawGridBin.SetSelected(index: integer; value: boolean);
begin
  fSelected[index] := value;
  InvalidateCell(Index);
end;


end.
