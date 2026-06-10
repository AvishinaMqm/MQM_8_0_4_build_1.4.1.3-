unit UMbinGrid;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Grids, StdCtrls, Vcl.Forms,
  UMBinFunc,   UMGlobal, UMBinDefault,
  UGDrawGrid, Messages, UMSchedList, Variants,
  UMSchedCont,UMSchedContFunc;

type

  TSchedJobSeqList = record
    Id       : TSchedId;
    Sequence : Integer;
  end;
  PTSchedJobSeqList = ^TSchedJobSeqList;

  TBinDrawGrid = class(TMQMDrawGridBin) // old was TDrawGrid
  public
    BinColumnSet: array [0..High(BinColDefault)] of TBinColCurrent;
    constructor CreateBinGrid(AOwner: TComponent; sc: TMSchedCont; isNewTab: boolean ; DftCnfic : boolean);
    destructor  Destroy; override;
    procedure SortRowBin;
    procedure UpdateArray;
    procedure UpdateOrderColumns;
    procedure MemBinColWidth;
  private
    m_selectedCell : boolean;
    m_Button : TMouseButton;
    m_CfgCol   : integer;
    SearchOrdToDspMode: boolean;
    m_sc: TMSchedCont;
    m_Col : Integer;
    m_Row : integer;
    m_commentCell : boolean;
    m_commentText : string;
    m_SharedComment_Id : TSchedId;
    m_SchedCell : boolean;
    m_Sched_Seq_List : TList;

    procedure DrawBinCell(Sender: TObject; ACol, ARow: Longint; Rect: TRect; State: TGridDrawState);
    procedure OnSelectionCell(Sender: TObject; ACol, ARow: Longint; var CanSelect: Boolean);
    procedure GridDblClick(Sender: TObject);
    procedure MseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GrdKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GrdKeyPress(Sender: TObject; var Key: Char);
    procedure GrdMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure SetDefautCnfig;
    procedure OnSelectionLine(Arow : integer);
    procedure OnSelectAllLine;
    function  GetFixedColumns : integer;
    Procedure GetSeqValue(id: TSchedID; fld: CBinColId; out value: variant);
  public
    Procedure Clear_Job_Sequence_List;
    function  Get_Job_Sequence_List_Count : integer;
    function  Fill_Job_Sequence_List : TMSchedList;
    procedure GrdTopLeftChanged(Sender: TObject);
    procedure SetColWidth;
    procedure ResetCfgCol;
    function  GetButtonMouse(var CfgCol : integer) : TMouseButton;
    procedure SetRealCfgCol(var CfgCol : integer);
    procedure SetButtonMouse(Mouse : TMouseButton);
    property OrdToDspMode : boolean Read SearchOrdToDspMode Write SearchOrdToDspMode;
    property Align;
    property  p_GetCol : Integer read m_Col;
    property  p_GetRow : Integer read m_Row;
    property  p_GetFixedColumns : integer read GetFixedColumns;
    property  p_commentText : string write m_commentText;
    function  FindPos(pos: integer): integer;
    function  FindPosViaName(Title: String): integer;
    function  FindOrderPos(pos: integer): integer;
    procedure GetEdtText(Sender: TObject; ACol, ARow: Integer; var Value: string);
    procedure SetEdtText(Sender: TObject; ACol, ARow: Integer; const Value: string);
    procedure InvalidateCell(Index : integer); override;
    function  GetSelectedList : TMSchedList;
    procedure SetAllSelected;
    function  GetAllAsSelectedForAutoRun : TMSchedList;
    Function  GetLatestSequence: Integer;
    procedure WriteNewValue(i : Integer; fld: CBinColId; Value: Variant; ManualSeq : Boolean);
    Function  HaveSameSequence: Boolean;
  published
    property Color;
  end;

  Function SortSequence(Item1, Item2: Pointer): integer;
  function CompColValue(lParam1, lParam2: Pointer): integer;
  function GetColValue(id : TSchedId; Position : integer) : variant;
  procedure GetColNature(Position : integer; var Descending, IsDate : boolean);
  function SortAutoSeqCustomField(lParam1, lParam2: Pointer): integer;

  procedure BinDrawCell(Sender: TObject; ACol, ARow: Longint; Rect: TRect; State: TGridDrawState);
  procedure DrawDataCell(grid: TDrawGrid; var rect: TRect; ARow, ACol: integer; RowIsSelected: boolean; State: TGridDrawState);
  //  procedure CBoxSelEnter(Sender: TObject);


implementation

uses
  gnugettext,
  Dialogs,
  FMOccMov,
  //UMSchedContFunc,
  FMBin,
  UMplan,
  FMMainPlan,
  FMGroupDetail,
  UMCompat,
  UGObjListSrv,
  UGconvert,
  UMBinTbs,
  UMObjCont,
  UMBinPanel,
  UMAutoSchedCfg,
  FMShowColorsBar,
  UMCompatClr;

const
  M_FixedColumns = 9;

var
  app: array [0..High(BinColDefault)] of CBinColId;
  appDesending: array [0..High(BinColDefault)] of boolean;
  bMultiSelect : Boolean = False;

//----------------------------------------------------------------------------//

Function TBinDrawGrid.HaveSameSequence: Boolean;
var i, y : Integer;
begin
  Result := False;
  for i := 0 to m_Sched_Seq_List.Count - 1 do
    for y := i + 1 to m_Sched_Seq_List.Count - 1 do
      if PTSchedJobSeqList(m_Sched_Seq_List[i]).Sequence = PTSchedJobSeqList(m_Sched_Seq_List[y]).Sequence then
      begin
        Result := True;
        Break
      end;
end;

//----------------------------------------------------------------------------//

procedure TBinDrawGrid.WriteNewValue(i : Integer; fld: CBinColId; Value: Variant; ManualSeq : Boolean);
var
  Seq : PTSchedJobSeqList;
  x : Integer;
begin
  if not TryStrToInt(Value, x) then exit;

  Seq := nil;
  for x := 0 to m_Sched_Seq_List.Count - 1 do
    if PTSchedJobSeqList(m_Sched_Seq_List[x]).Id = i then
    begin
      Seq := PTSchedJobSeqList(m_Sched_Seq_List[x]);
      Break
    end;

  case fld of
    CSC_SchedSeq:
    begin

      if Seq = nil then
      begin
        New(Seq);
        Seq.Id := i;
        if ManualSeq then
          Seq.Sequence :=  Value
        else
          Seq.Sequence :=  Value + 1;

        m_Sched_Seq_List.add(Seq);
      end else
        Seq.Sequence :=  Value;
    end;
    CSC_SeqCB:
    begin
      if Seq <> nil then
      begin
        dispose(PTSchedJobSeqList(m_Sched_Seq_List[X]));
        m_Sched_Seq_List.Delete(x);
      end;
    end;
  end;

  if m_Sched_Seq_List.Count > 0 then
    m_Sched_Seq_List.Sort(SortSequence);
end;

//----------------------------------------------------------------------------//

Function SortSequence(Item1, Item2: Pointer): integer;
var Seq1 : PTSchedJobSeqList;
var Seq2 : PTSchedJobSeqList;
begin
  Seq1 := PTSchedJobSeqList(Item1);
  Seq2 := PTSchedJobSeqList(Item2);
  if Seq1.Sequence = Seq2.Sequence then
    Result := 0
  else if Seq1.Sequence > Seq2.Sequence then
    Result := 1
  else
    Result := -1;
end;

//----------------------------------------------------------------------------//

Function TBinDrawGrid.GetLatestSequence: Integer;
var
  y : integer;
  Seq : PTSchedJobSeqList;
begin
  Result := 0;
  for y := 0 to m_Sched_Seq_List.count -1 do
  begin
   Seq := PTSchedJobSeqList(m_Sched_Seq_List[y]);
   if Seq.Sequence > result then
     result := Seq.Sequence;
  end;
end;

//----------------------------------------------------------------------------//

function OutDate(dt: TDateTime): string;
begin
  Result := FormatDateTime('dd/mm/yy hh nn', dt)
end;

//----------------------------------------------------------------------------//

function GetCellForSortValue(id: TSchedID; ColId: CBinColId): variant;
var
  res:      boolean;
  dataType: CBinColValType;
begin
  res := p_sc.GetFldValue(id, ColId, Result, dataType);
  if not res then
  begin
    case dataType of
    CBT_date:     Result := 0;
    CBT_integer:  Result := -2147483647;
    CBT_float:    Result := -3.4 * 10e38;
 //   CBT_string:   Result := 'aaaaaaaaaaaaaaaa';
    CBT_string:   Result := ' ';
    CBT_bool:     Result := 'yes';
    else
      Result := varUnknown;
    end;
  end;
end;

//----------------------------------------------------------------------------//

function SortAutoSeqCustomField(lParam1, lParam2: Pointer): integer;
var
  i:          integer;
  LinkRec1:   TSchedID;
  LinkRec2:   TSchedID;
  dt1, dt2:   variant;
  dt21, dt22: TDateTime;
begin
  LinkRec1 := TSchedID(lParam1);
  LinkRec2 := TSchedID(lParam2);

{  BinView1 := p_sc.GetVisbleInBin(LinkRec1);
  BinView2 := p_sc.GetVisbleInBin(LinkRec2);
  if (BinView1 > BinView2) then
  begin
    Result := 1;
    Exit
  end
  else if BinView1 < BinView2 then
  begin
    Result := -1;
    Exit
  end;    }

  // just to avoid a warning
  dt21 := 0;
  dt22 := 0;

  for I := low(AutoSchedCfg.m_FieldArrayForSort) to High(AutoSchedCfg.m_FieldArrayForSort) do///? what is this -> 44
  begin
    if AutoSchedCfg.m_FieldArrayForSort[I].Field = CSC_NotSorted then
    begin
      Result := 0;
      Exit;
    end;

    if (AutoSchedCfg.m_FieldArrayForSort[I].Field = CSC_LowStartTimeLimit) or
       (AutoSchedCfg.m_FieldArrayForSort[I].Field = CSC_ProdDlvDate) or
       (AutoSchedCfg.m_FieldArrayForSort[I].Field = CSC_MatArrivalDate) or
       (AutoSchedCfg.m_FieldArrayForSort[I].Field = CSC_PlanStartDate) or
       (AutoSchedCfg.m_FieldArrayForSort[I].Field = CSC_LowStartDate) or
       (AutoSchedCfg.m_FieldArrayForSort[I].Field = CSC_PlanEndDate) or
       (AutoSchedCfg.m_FieldArrayForSort[I].Field = CSC_SchedStart) or
       (AutoSchedCfg.m_FieldArrayForSort[I].Field = CSC_SchedEnd) or
       (AutoSchedCfg.m_FieldArrayForSort[I].Field = CSC_Overlapping) or
       (AutoSchedCfg.m_FieldArrayForSort[I].Field = CSC_HighEndLimit) then  //  Date Format column values
      begin
        dt1 := GetCellForSortValue(LinkRec1, AutoSchedCfg.m_FieldArrayForSort[I].Field);
        dt2 := GetCellForSortValue(LinkRec2, AutoSchedCfg.m_FieldArrayForSort[I].Field);
        dt21 := dt1;
        dt22 := dt2;
      end
    else
    begin
      dt1 := GetCellForSortValue(LinkRec1, AutoSchedCfg.m_FieldArrayForSort[I].Field);
      dt2 := GetCellForSortValue(LinkRec2, AutoSchedCfg.m_FieldArrayForSort[I].Field);
    end;
    if (AutoSchedCfg.m_FieldArrayForSort[I].Field = CSC_LowStartTimeLimit) or
       (AutoSchedCfg.m_FieldArrayForSort[I].Field = CSC_ProdDlvDate) or
       (AutoSchedCfg.m_FieldArrayForSort[I].Field = CSC_MatArrivalDate) or
       (AutoSchedCfg.m_FieldArrayForSort[I].Field = CSC_PlanStartDate) or
       (AutoSchedCfg.m_FieldArrayForSort[I].Field = CSC_LowStartDate) or
       (AutoSchedCfg.m_FieldArrayForSort[I].Field = CSC_PlanEndDate) or
       (AutoSchedCfg.m_FieldArrayForSort[I].Field = CSC_SchedStart) or
       (AutoSchedCfg.m_FieldArrayForSort[I].Field = CSC_SchedEnd) or
       (AutoSchedCfg.m_FieldArrayForSort[I].Field = CSC_Overlapping) or
       (AutoSchedCfg.m_FieldArrayForSort[I].Field = CSC_HighEndLimit) then  //  Date Format column values
    begin
      if dt21 < dt22 then
      begin
        Result := -1;
        exit
      end else if dt21 > dt22 then
      begin
        Result := 1;
        exit
      end;

    end else
    begin
      if dt1 < dt2 then
      begin
        Result := -1;
        exit
      end else if dt1 > dt2 then
      begin
        Result := 1;
        exit
      end
    end;
  end;

  Result := 0;
end;


//----------------------------------------------------------------------------//

function IsColumnADate(I : integer) : boolean;
begin
  Result := false;
  if (app[i] = CSC_LowStartTimeLimit) or (app[i] = CSC_ProdDlvDate) or (app[i] = CSC_MatArrivalDate) or
     (app[i] = CSC_PlanStartDate) or (app[i] = CSC_LowStartDate) or (app[i] = CSC_PlanEndDate) or
     (app[i] = CSC_SchedStart) or (app[i] = CSC_SchedEnd) or (app[i] = CSC_PrvHighestDate) or
     (app[i] = CSC_PrvActualEnd) or (app[i] = CSC_NxtActualStart) or  (app[i] = CSC_SavedScheduleDate) or
     (app[i] = CSC_NxtLowestDate) or (app[i] = CSC_ServingGroupLowestDate) or (app[i] = CSC_HighEndLimit) then
    Result := true;
end;

//----------------------------------------------------------------------------//

procedure GetColNature(Position : integer; var Descending, IsDate : boolean);
begin
  Descending := false;
  IsDate := false;
  if Position > High(BinColDefault) then Exit;
  Descending := appDesending[Position];
  IsDate := IsColumnADate(Position);
end;

//----------------------------------------------------------------------------//

function GetColValue(id : TSchedId; Position : integer) : variant;
const
  HistoricalDate = 29221; // 01/01/1980
  FarFutureDate = 73051;  // 01/01/2100
var
  i:          integer;
begin
  if Position = -1 then
  begin
    Result := p_sc.GetVisbleInBin(id);
    Exit;
  end;

  if Position > High(BinColDefault) then
  begin
    Result := '';
    Exit;
  end;

  i := Position;
  Result := GetCellForSortValue(id, app[i]);
  if IsColumnADate(i) then
  begin
    if ((app[i] = CSC_PrvHighestDate) or (app[i] = CSC_PrvActualEnd)) and (Result = 0) and (not appDesending[i]) then // for isko 19/09/2012
    begin
//      if p_sc.GetPrevStepToSched(id) = nil then // TMG
      if not p_sc.HasPrevStepOrConnRequest(id)  then // TMG
        Result := HistoricalDate //StrToDateTime('08/08/1971')
      else
        Result := FarFutureDate; // StrToDateTime('08/08/2100');
    end;
    if ((app[i] = CSC_NxtLowestDate) or (app[i] = CSC_NxtActualStart)) and (Result = 0) and (not appDesending[i]) then // for isko 19/09/2012
    begin
      Result := FarFutureDate // StrToDateTime('08/08/2100');
    end;
    if (app[i] = CSC_ServingGroupLowestDate) and (Result = 0) and (not appDesending[i]) then // for isko 19/09/2012
    begin
      Result := FarFutureDate //StrToDateTime('08/08/2100');
    end;
  end
  else
  begin
    if (app[i] = CSC_ServingGroupCode) then
    begin
      if trim(Result) = '' then
         Result := '999999999999999';
      if trim(Result) = '' then
         Result := '999999999999999';
    end;
  end;

end;

//----------------------------------------------------------------------------//

function CompColValue(lParam1, lParam2: Pointer): integer;
var
  i:          integer;
  LinkRec1:   TSchedID;
  LinkRec2:   TSchedID;
  dt1, dt2:   variant;
  dt21, dt22: TDateTime;
  BinView1,BinView2 :    CScBinView;
{$ifdef ARO}
  planInfo1, planInfo2: TSQplanInfo;
{$endif}
begin
  LinkRec1 := TSchedID(lParam1);
  LinkRec2 := TSchedID(lParam2);

  if LinkRec1 = LinkRec2 then
  begin
    Result := 0;
    Exit
  end;

  BinView1 := p_sc.GetVisbleInBin(LinkRec1);
  BinView2 := p_sc.GetVisbleInBin(LinkRec2);
  if (BinView1 > BinView2) then
  begin
    Result := 1;
    Exit
  end
  else if BinView1 < BinView2 then
  begin
    Result := -1;
    Exit
  end;

  for i := 0 to High(BinColDefault) do
  begin
    dt1 := GetColValue(LinkRec1, i);
    dt2 := GetColValue(LinkRec2, i);
    if IsColumnADate(I) then
    begin
      dt21 := dt1;
      dt22 := dt2;
      if not appDesending[i] then
      begin
        if dt21 < dt22 then
        begin
          Result := -1;
          exit
        end else if dt21 > dt22 then
        begin
          Result := 1;
          exit
        end;
      end
      else
      begin
        if dt21 < dt22 then
        begin
          Result := 1;
          exit
        end else if dt21 > dt22 then
        begin
          Result := -1;
          exit
        end;
      end;
    end
    else
    begin
      try
      if not appDesending[i] then
      begin
        if dt1 < dt2 then
        begin
          Result := -1;
          exit
        end else if dt1 > dt2 then
        begin
          Result := 1;
          exit
        end
      end
      else
      begin
        if dt1 < dt2 then
        begin
          Result := 1;
          exit
        end else if dt1 > dt2 then
        begin
          Result := -1;
          exit
        end
      end;

      except
      end;
    end;
  end;

  Result := 0;

end;

//----------------------------------------------------------------------------//

function HexToInt(HexNum: string): LongInt;
begin
   Result:=StrToInt('$' + HexNum) ;
end;

procedure DrawDataCell(grid: TDrawGrid; var rect: TRect; ARow, ACol: integer; RowIsSelected: boolean; State: TGridDrawState);
const IsChecked : array[Boolean] of Integer =
 (DFCS_BUTTONCHECK, DFCS_BUTTONCHECK or DFCS_CHECKED);

var
  binGrid:  TBinDrawGrid;
  str:      string;
  FieldVal : variant;
  dataType: CBinColValType;
  id:       TSchedId;
  compRes,
  compFore,
  compBack: TCompatVal;
  BinView : CScBinView;
  Img: graphics.TBitmap;
  ForcesInfo: TSQForcesInfo;
  PlanInfo: TSQPlanInfo;
  errSet: SetOfErrors;
  CfgCol: integer;
  CfgColPass : boolean;
  RectWidth: integer;
  TmpBrushCol, TmpPenCol, TmpFontCol: TColor;
  ExtLinkPrt: pointer;
  IsGroup : boolean;
  GetMsg, SentMsg : boolean;
  num : Integer;
  pId : TPropId;
  r,g,b : Byte;
  PropColor : TColor;
  DummyList : TList;
  CheckBox : TCheckBox;
  DrawState : Integer;
  DrawRect : TRect;
  gr : TStringGrid;

begin
  binGrid := TBinDrawGrid(grid);
  gr := TStringGrid(grid);
 // if binGrid.GetSelected(ARow) then exit;
  binGrid.Canvas.Font.Name := 'Montserrat';
  Assert(Assigned(binGrid));
  Img := nil;
  CfgColPass := false;
  CfgCol := 0;
  DummyList := nil;

  if ARow >= TBinPanel(binGrid.Parent).m_ObjList.GetLinkCount then
  begin
    grid.Canvas.TextRect(rect, rect.left+2, rect.top+2, '------');
    exit
  end;

  id := TSchedId(TBinPanel(binGrid.Parent).m_ObjList.GetLink(ARow));
  ExtLinkPrt := p_sc.GetExtLinkPtr(TSchedID(TBinPanel(binGrid.Parent).m_ObjList.GetLink(ARow)));

  grid.Canvas.brush.Style := bsSolid;

  // Alternating row colors for better readability
  if (ARow mod 2 = 1) then
    grid.Canvas.Brush.Color := RGB(245, 248, 252)   // very light blue-gray for odd rows
  else
    grid.Canvas.Brush.Color := clWhite;              // white for even rows

{  if not RowIsSelected
  and (ACol > 1) then
    if p_sc.HasFlags(id, [CSF_selected, CSF_compInBin]) then
      grid.Canvas.Brush.Color := clGreen
    else
    begin
//      if p_sc.GetSchedObjStatus(id) = CSS_del then
//         grid.Canvas.Brush.Color := clRed
      if ((p_sc.GetSchedObjStatus(id) = CSS_From_PG) or (p_sc.CheckSchedSumQty(Id))) then
         grid.Canvas.Brush.Color := clRed
      else if (p_sc.GetSchedMsgFromHost(id) <> CSH_No_Chg) then
        grid.Canvas.Brush.Color := clLime
        //      else if p_sc.CheckSchedSumQty(Id) then
//         grid.Canvas.Brush.Color := clOlive
      else
        grid.Canvas.Brush.Color := clWhite;
    end;   }


  case Acol of
    0:  begin   //Compatibility
          grid.Canvas.Brush.Color := clwhite;
          if (Grid.ColWidths[0] > 0) then
          begin
            TmpBrushCol := grid.Canvas.Brush.Color;
            TmpPenCol   := grid.Canvas.Pen.Color;
            TmpFontCol  := grid.Canvas.Font.Color;
            if not p_sc.HasFlags(id, [CSF_compInBin]) then
              str := ''
            else
            begin
              compRes := p_sc.GetCompatWithRes(id);
              if compRes = CompValNotCached then
                str := ''// '(nc)'   message is not clear avi 20.06.23
              else if compRes = CompValNotValid then
                str := ''// '(nv)'
              else if compRes = CompValNotDef then
                str := '' //'(nd)'
              else
                str := IntToStr(compRes);

              if (p_pl.GetCompatModeInBinVisRes <> nil) then
              begin
                if TBinPanel(binGrid.Parent).GetFiltParms.P_SeqFilter then
                   GetResCompatColor(compRes, grid.Canvas.Brush, grid.Canvas.Pen, grid.Canvas.Font);
                if not TBinPanel(binGrid.Parent).GetFiltParms.P_SeqFilter then
                begin
                  if DBAppSettings.ShowCompatibleInExistingBINS = ShowC_No then
                    str := ''
                  else
                    GetResCompatColor(compRes, grid.Canvas.Brush, grid.Canvas.Pen, grid.Canvas.Font)
                end;
              end
              else
                GetResCompatColor(compRes, grid.Canvas.Brush, grid.Canvas.Pen, grid.Canvas.Font)
            end;

            RectWidth := trunc((rect.Right - rect.Left)/3);
            Rect.Right := Rect.Left + RectWidth;
            grid.Canvas.TextRect(rect, rect.left+2, rect.top+2, str);
            Rect.Left := Rect.Right;
            str := '';
            grid.Canvas.Brush.Color := TmpBrushCol;
            grid.Canvas.Pen.Color   := TmpPenCol;
            grid.Canvas.Font.Color  := TmpFontCol;
      //      grid.Canvas.MoveTo(rect.Left-1, rect.Top);
      //      grid.Canvas.LineTo(rect.Left-1, rect.Bottom);

            if (p_pl.GetCompatModeInPlanId = CSchedIDnull) then
            begin
              if Assigned(ExtLinkPrt) then
              begin
                p_sc.GetPlanInfo(id, PlanInfo);
                if (PlanInfo.supMinOvlp > 0) and (PlanInfo.supMinReal > 0) and (PlanInfo.supMinBase > 0) then
                  str := '+ ' + FloatToStr(PlanInfo.supMinOvlp + PlanInfo.supMinReal + PlanInfo.supMinBase)
                else if (PlanInfo.supMinOvlp > 0) and (PlanInfo.supMinReal > 0) then
                  str := '+ ' + FloatToStr(PlanInfo.supMinOvlp + PlanInfo.supMinReal)
                else if (PlanInfo.supMinOvlp > 0) then
                  str := '+ ' + FloatToStr(PlanInfo.supMinOvlp)
              end;
              Rect.Right := Rect.Left + RectWidth*2;
              grid.Canvas.TextRect(rect, rect.left+2, rect.top+2, str);
            end
            else
            begin
              if Assigned(ExtLinkPrt) then
              begin
                try   //  avi to avoid access violation while Group form open (while remove job from group). 10/12/07
                p_sc.GetCompatWithOcc(id, compFore, compBack);
                except
                end;
                if compFore > 0 then
                begin
                  str := intToStr(compFore);
                  GetOccCompatColor(compFore, false, grid.Canvas.Brush, grid.Canvas.Pen, grid.Canvas.Font)
                end else
                  str := ' --';

                Rect.Right := Rect.Left + RectWidth;
                grid.Canvas.TextRect(rect, rect.left+2, rect.top+2, str);
                Rect.Left := Rect.Right;
             //   grid.Canvas.MoveTo(rect.Left-1, rect.Top);
             //   grid.Canvas.LineTo(rect.Left-1, rect.Bottom);

                if compBack > 0 then
                begin
                  str := intToStr(compBack);
                  GetOccCompatColor(compBack, false, grid.Canvas.Brush, grid.Canvas.Pen, grid.Canvas.Font)
                end else
                  str := ' --';

                Rect.Right := Rect.Left + RectWidth;
                grid.Canvas.TextRect(rect, rect.left+2, rect.top+2, str);
              end
              else
              begin
                Rect.Right := Rect.Left + RectWidth*2;
                grid.Canvas.TextRect(rect, rect.left+2, rect.top+2, str);
              end;
            end;
            grid.Canvas.Brush.Color := TmpBrushCol;
            grid.Canvas.Pen.Color   := TmpPenCol;
            grid.Canvas.Font.Color  := TmpFontCol;
          end
        end;
    1:  begin //Earliest Start forced
          grid.Canvas.Brush.Color := clwhite;//RGB(200, 220, 245);
          if (Grid.ColWidths[1] > 0) then
          begin
            p_sc.GetForcesInfo(id, ForcesInfo);
            if ForcesInfo.FrcLowestDate > CSF_No then
            begin
              Img := graphics.TBitmap.Create;
              try
                FMQMPlan.ImageList1.GetBitmap(23, Img);
              except
              end;
            end;
          end;
        end;
    2:  begin //Latest End  forced
          grid.Canvas.Brush.Color := clwhite;//RGB(200, 220, 245);


          if (Grid.ColWidths[2] > 0) then
          begin
            p_sc.GetForcesInfo(id, ForcesInfo);
            if ForcesInfo.FrcHighestDate > CSF_No then
            begin
              Img := graphics.TBitmap.Create;
              try
                FMQMPlan.ImageList1.GetBitmap(23, Img);
              except
              end;
            end;
          end;
        end;
    3:  begin  //Materials
          grid.Canvas.Brush.Color := clwhite;//RGB(200, 220, 245);
          if (Grid.ColWidths[3] > 0) then
          begin
            errSet := [];
            p_sc.CheckErrors(id, CSEG_All, errSet, DummyList);

            if (CSE_Materials in errSet) then
            begin
              Img := graphics.TBitmap.Create;
              try
                FMQMPlan.ImageList1.GetBitmap(36, Img);
              except
              end;
            end else
              if (CSE_AddRes in errSet) then
              begin
                Img := graphics.TBitmap.Create;
                try
                  FMQMPlan.ImageList1.GetBitmap(49, Img);
                except
                end;
              end else
                if (CSE_BothOvlp in errSet) then
                begin
                  Img := graphics.TBitmap.Create;
                  try
                    FMQMPlan.ImageList1.GetBitmap(40, Img);
                  except
                  end;
                end else
                begin
                  if (CSE_LeftOvlp in errSet) then
                  begin
                    Img := graphics.TBitmap.Create;
                    try
                      FMQMPlan.ImageList1.GetBitmap(38, Img);
                    except
                    end;
                  end else
                    if (CSE_RightOvlp in errSet) then
                    begin
                      Img := graphics.TBitmap.Create;
                      try
                        FMQMPlan.ImageList1.GetBitmap(39, Img);
                      except
                      end;
                    end else
                    begin
                     // p_sc.GetForcesInfo(id, ForcesInfo);
                     // if ForcesInfo.FrcOverlap > CSF_No then
                      {if DBAppSettings.ForceOverlap > FOL_No then
                      begin
                        Img := graphics.TBitmap.Create;
                        FMQMPlan.ImageList1.GetBitmap(23, Img);
                      end; }
                    end
            end;
          end;
        end;
    4:  begin  //Material Arrival forced
          grid.Canvas.Brush.Color := clwhite;//RGB(200, 220, 245);
          if (Grid.ColWidths[4] > 0) then
          begin
            p_sc.GetForcesInfo(id, ForcesInfo);
            if ForcesInfo.FrcMatDate > CSF_No then
            begin
              Img := graphics.TBitmap.Create;
              try
                FMQMPlan.ImageList1.GetBitmap(23, Img);
              except
              end;
            end;
          end;
        end;
    5:  begin //Delivery date forced
          grid.Canvas.Brush.Color := clwhite;//RGB(200, 220, 245);
          if (Grid.ColWidths[5] > 0) then
          begin
            p_sc.GetForcesInfo(id, ForcesInfo);
            case ForcesInfo.FrcDelDate of
              CSF_Yes,
              CSF_Forceable:  begin
                                Img := graphics.TBitmap.Create;
                                try
                                  FMQMPlan.ImageList1.GetBitmap(23, Img);
                                except
                                end;
                              end;
              CSF_Yes2,
              CSF_Forceable2: begin
                                Img := graphics.TBitmap.Create;
                                try
                                  FMQMPlan.ImageList1.GetBitmap(50, Img);
                                except
                                end;
                               end;
            end;
          end;
        end;
    6:  begin //Dates warnings
          grid.Canvas.Brush.Color := clwhite;//RGB(200, 220, 245);
          if (Grid.ColWidths[6] > 0)
          and Assigned(ExtLinkPrt) then
          begin
            errSet := [];
            p_sc.CheckErrors(id, CSEG_All, errSet, DummyList);

            if (CSE_DelDate in errSet) then
            begin
              Img := graphics.TBitmap.Create;
              try
                FMQMPlan.ImageList1.GetBitmap(37, Img);
              except
              end;
            end else
              if (CSE_HighEndDate in errSet) then
              begin
                Img := graphics.TBitmap.Create;
                try
                  FMQMPlan.ImageList1.GetBitmap(35, Img);
                except
                end;
              end else
                if (CSE_LowStrDate in errSet) then
                begin
                  Img := graphics.TBitmap.Create;
                  try
                    FMQMPlan.ImageList1.GetBitmap(34, Img);
                  except
                  end;
                end;
          end;
        end;
    7:  begin  //Status
          grid.Canvas.Brush.Color := clwhite;//RGB(200, 220, 245);
          if (Grid.ColWidths[7] > 0) then
          begin
            if p_sc.GetFldValue(id, CSC_Closed, FieldVal, dataType) and FieldVal then
            begin
              Img := graphics.TBitmap.Create;
              try
                FMQMPlan.ImageList1.GetBitmap(33, Img)
              except
              end;
            end
            else
            begin
              if (p_sc.IsProgressed(id) <> prg_none) or Assigned(ExtLinkPrt) then
              begin
                Img := graphics.TBitmap.Create;
                case p_sc.IsProgressed(id) of
                  prg_Starting: begin
                                   try
                                     FMQMPlan.ImageList1.GetBitmap(29, Img);
                                   except
                                   end;
                                end;
                  prg_General:  begin
                                   try
                                     FMQMPlan.ImageList1.GetBitmap(30, Img);
                                   except
                                   end;
                                end;
                  prg_Final, prg_FinalSplit : begin
                                                try
                                                  FMQMPlan.ImageList1.GetBitmap(31, Img);
                                                except
                                                end;
                                              end;
                //  prg_FinalSplit: FMQMPlan.ImageList1.GetBitmap(31, Img);
                else
                  if (p_sc.GetSchedType(id) = '2') then
                  begin
                    try
                      FMQMPlan.ImageList1.GetBitmap(20, Img)
                    except
                    end;
                  end
                  else
                  begin
                    if (p_sc.GetSchedType(id) = '3') then
                      str := '1'
                    else if (p_sc.GetSchedType(id) = '4') then
                      str := '2'
                    else if (p_sc.GetSchedType(id) = '5') then
                      str := '3'
                    else if (p_sc.GetSchedType(id) = '6') then
                      str := '4'
                    else if (p_sc.GetSchedType(id) = '7') then
                      str := '5';

                    try
                      if p_sc.GetSchedType(id) = '1' then
                        FMQMPlan.ImageList1.GetBitmap(21, Img)
                      else if (GetOccMoveForm <> nil) and (p_sc.GetSchedType(id) = '0') then
                      begin
                        if DBAppGlobals.DefSchedType = 1 then
                          FMQMPlan.ImageList1.GetBitmap(20, Img)
                        else if DBAppGlobals.DefSchedType = 2 then
                          FMQMPlan.ImageList1.GetBitmap(21, Img)
                        else
                          FMQMPlan.ImageList1.GetBitmap(51, Img);
                      end
                      else
                        FMQMPlan.ImageList1.GetBitmap(51, Img);
                    except
                    end;
                  end;
                end;
              end
              else
              begin
                if (p_sc.GetSchedType(id) = '3') then
                  str := '1'
                else if (p_sc.GetSchedType(id) = '4') then
                  str := '2'
                else if (p_sc.GetSchedType(id) = '5') then
                  str := '3'
                else if (p_sc.GetSchedType(id) = '6') then
                  str := '4'
                else if (p_sc.GetSchedType(id) = '7') then
                  str := '5';
                if str <> '' then
                begin
                  Img := graphics.TBitmap.Create;
                  try
                    FMQMPlan.ImageList1.GetBitmap(52, Img)
                  except
                  end;
                end
              end;
            end;
          end;
        end;
    8:  begin  // JobMessges
          if (Grid.ColWidths[8] > 0) then
          begin
            grid.Canvas.Brush.Color := clwhite;//RGB(200, 220, 245);
            p_sc.GetStatuseMsgForJob(id, IsGroup, GetMsg, SentMsg);
            begin
              if GetMsg and not SentMsg then
              begin
                Img := graphics.TBitmap.Create;
                try
                  FMQMPlan.ImageList1.GetBitmap(54, Img)
                except
                end;
              end
              else if SentMsg and not GetMsg then
              begin
                Img := graphics.TBitmap.Create;
                try
                  FMQMPlan.ImageList1.GetBitmap(55, Img)
                except
                end;
              end
              else if GetMsg and SentMsg then
              begin
                Img := graphics.TBitmap.Create;
                try
                  FMQMPlan.ImageList1.GetBitmap(56, Img)
                except
                end;
              end

              {if IsGroup and not OnlyGrpJobFather then
              begin
                Img := graphics.TBitmap.Create;
                FMQMPlan.ImageList1.GetBitmap(55, Img)
              end
              else
              begin}
              //  Img := graphics.TBitmap.Create;
              //  FMQMPlan.ImageList1.GetBitmap(54, Img)
              //end;
            end;
          end;
        end
    else
    begin
      CfgCol := binGrid.BinColumnSet[ACol - grid.FixedCols - M_FixedColumns].RealPos;
      str := binGrid.m_sc.GetFldDescr(TSchedID(TBinPanel(binGrid.Parent).m_ObjList.GetLink(ARow)), binGrid.BinColumnSet[CfgCol].Field, true);
      CfgColPass := true;

      if binGrid.BinColumnSet[CfgCol].Field = CSC_SchedSeq then
      begin
        Bingrid.GetSeqValue(TSchedID(TBinPanel(binGrid.Parent).m_ObjList.GetLink(ARow)), binGrid.BinColumnSet[CfgCol].Field, FieldVal);
        str := FieldVal;
      end;

      if (binGrid.BinColumnSet[CfgCol].Field = CSC_MatArrivalDate) then
      begin
        binGrid.m_sc.GetFldValue(id, CSC_MatArrivalDate, FieldVal, dataType);
        if FieldVal = 0 then
          str := ' ';
      end;
    end;
  end;

  BinView := p_sc.GetVisbleInBin(TSchedID(TBinPanel(binGrid.Parent).m_ObjList.GetLink(ARow)));

  if goRowSelect in grid.Options then
  begin
    if (BinView = CSB_ReadOnly) and not RowIsSelected and (ACol > 8) then
      grid.Canvas.Brush.Color := 14079702//clGrayText
    else if RowIsSelected then
    begin
      grid.Canvas.Brush.Color := RGB(200, 220, 245);
      if (ACol < 9) then
        grid.Canvas.Brush.Color := clwhite;
    end;

    if RowIsSelected and (ACol > 8) then
      grid.Canvas.Font.Color := clBlack//clWhite
    else
      grid.Canvas.Font.Color := clBlack;
  end
  else
  begin
    if (BinView = CSB_ReadOnly) and not RowIsSelected and (ACol > 8) then
       grid.Canvas.Brush.Color := 14079702;//clGrayText;

    if (BinView = CSB_ReadOnly) and RowIsSelected and (ACol > 8) and (grid.Col <> ACol) then
       grid.Canvas.Brush.Color := 14079702;//clGrayText;

    if RowIsSelected and (ACol > 8) and (grid.Col = ACol) then
      grid.Canvas.Font.Color := clBlack
    else
      grid.Canvas.Font.Color := clBlack;
  end;
// **************************************
// Modifictions by itzik
//Itzik - if not goRowSelect option then we need all the row in black - not white.
//        This disables the src in line 562  - delete this if we want all row select

  grid.Canvas.Font.Color := clGrayText;

  if not RowIsSelected and (ACol > 1) then
  begin
    if p_sc.HasFlags(id, [CSF_selected, CSF_compInBin]) then
    begin
      if IsGroupFormOut then
      begin
        grid.Canvas.Brush.Color := clGreen;
        grid.Canvas.Font.Color := clblack
      end
      else if TBinPanel(binGrid.Parent).GetFiltParms.P_SeqFilter then
      begin
        if (DBAppSettings.CreateNewBinTabForCompatibles = NewB_Yes_MarkCompatibleAndToSchedJobs) or
          (DBAppSettings.CreateNewBinTabForCompatibles = NewB_Yes_ShowOnlyCompatibles) then
        begin
          grid.Canvas.Brush.Color := clGreen;
          grid.Canvas.Font.Color := clblack
        end;
      end
      else
      begin
        if DBAppSettings.ShowCompatibleInExistingBINS = ShowC_Yes_MarkTheCompatibles then
        begin
          grid.Canvas.Brush.Color := clGreen;
          grid.Canvas.Font.Color := clblack
        end;
      end;

    end
    else
    begin
      if ((p_sc.GetSchedObjStatus(id) = CSS_From_PG) or (p_sc.CheckSchedSumQty(Id))) then
      begin
        grid.Canvas.Brush.Color := clRed;
        grid.Canvas.Font.Color := clblack;
      end
      else if (p_sc.GetSchedMsgFromHost(id) <> CSH_No_Chg) then
      begin
        grid.Canvas.Brush.Color := clLime;
        grid.Canvas.Font.Color := clblack;
      end
      else if BinView <> CSB_ReadOnly then  // avi change 13082020
      begin
        grid.Canvas.Brush.Color := clWhite;
      end;
    end;

  end;

  if (DBAppSettings.ShowRowInBin) and (ACol > 8) then  //RowIsSelected and (ACol > 8) then
  begin
    //  grid.Canvas.Brush.Color := RGB(200, 220, 245);

      if (RowIsSelected) then
      begin
        if not binGrid.pSelectedMarked then
        begin
          TDrawGrid(grid).Canvas.Brush.color := RGB(200, 220, 245);
         // TDrawGrid(grid).Canvas.FillRect(rect);
        //  TDrawGrid(grid).Canvas.DrawFocusRect(Rect);
        end
        else if not binGrid.GetSelected(ARow) then // ctrl when unselected
        begin
          TDrawGrid(grid).Canvas.pen.color := clBlack;
          TDrawGrid(grid).Canvas.Brush.color := RGB(200, 220, 245);//clGrayText;
       //   TDrawGrid(grid).Canvas.FillRect(rect);
       //   TDrawGrid(grid).Canvas.DrawFocusRect(Rect);
        end;
      end;

      if binGrid.GetSelected(ARow) then
      begin
        //Rect  := binGrid.CellRect(binGrid.m_Col, ARow + 1);
        TDrawGrid(grid).Canvas.Brush.color := RGB(200, 220, 245);
      //  TDrawGrid(grid).Canvas.FillRect(rect);
       // TDrawGrid(grid).Canvas.DrawFocusRect(Rect);
      // grid.Canvas.TextRect(rect, rect.left+2, rect.top+2, '----------');
      end;
  end
 // else if not (DBAppSettings.ShowRowInBin) and RowIsSelected and (ACol > 8) then
  else if not (DBAppSettings.ShowRowInBin) and (ACol > 8) then
  begin
    if (gdFocused in state) or (gdSelected in state) then  //and not binGrid.pSelectedMarked then//binGrid.GetSelected(ARow) then
    begin
      if not binGrid.pSelectedMarked then
      begin
        TDrawGrid(grid).Canvas.Brush.color := RGB(200, 220, 245);
        TDrawGrid(grid).Canvas.FillRect(rect);
        TDrawGrid(grid).Canvas.DrawFocusRect(Rect);
      end
      else
      if not binGrid.GetSelected(ARow) then // ctrl when unselected
      begin
        TDrawGrid(grid).Canvas.pen.color := clBlack;
        TDrawGrid(grid).Canvas.Brush.color := clwhite;
        TDrawGrid(grid).Canvas.FillRect(rect);
        TDrawGrid(grid).Canvas.DrawFocusRect(Rect);
      end;
    end;

    if binGrid.GetSelected(ARow) and (binGrid.m_Col = Acol) then
    begin
      Rect  := binGrid.CellRect(binGrid.m_Col, ARow + 1);
      TDrawGrid(grid).Canvas.Brush.color := RGB(200, 220, 245);
      TDrawGrid(grid).Canvas.FillRect(rect);
      TDrawGrid(grid).Canvas.DrawFocusRect(Rect);
    end;
  end;

 // else
 //   grid.Canvas.Brush.Color := clwhite;// grid.Canvas.Font.Color := clBlack;

 { if RowIsSelected and (grid.Col = Acol )and (ACol > 7) then
    grid.Canvas.Font.Color := clGrayText;//clBlack; }

    //Mihailo - For Selected cell color
   if RowISSelected and (grid.Col = Acol ) then
    grid.Canvas.Font.Color := clBlack;

//Itzik - so that when scrolling to the left or right we get the correct color
  {if RowIsSelected and (grid.Col > Acol )and (ACol > 7) then
    grid.Canvas.Font.Color := clGrayText;//clBlack; }

//****************************************

  if CfgColPass and DBAppSettings.ShowBinPropColors then
  begin
    num := -1;
    case binGrid.BinColumnSet[CfgCol].Field of
      CSC_property1:   num := 0;
      CSC_property2:   num := 1;
      CSC_property3:   num := 2;
      CSC_property4:   num := 3;
      CSC_property5:   num := 4;
      CSC_property6:   num := 5;
      CSC_property7:   num := 6;
      CSC_property8:   num := 7;
      CSC_property9:   num := 8;
      CSC_property10:  num := 9;
      CSC_property11:  num := 10;
      CSC_property12:  num := 11;
      CSC_property13:  num := 12;
      CSC_property14:  num := 13;
      CSC_property15:  num := 14;
      CSC_property16:  num := 15;
      CSC_property17:  num := 16;
      CSC_property18:  num := 17;
      CSC_property19:  num := 18;
      CSC_property20:  num := 19;
      CSC_property21:  num := 20;
      CSC_property22:  num := 21;
      CSC_property23:  num := 22;
      CSC_property24:  num := 23;
      CSC_property25:  num := 24;
      CSC_property26:  num := 25;
      CSC_property27:  num := 26;
      CSC_property28:  num := 27;
      CSC_property29:  num := 28;
      CSC_property30:  num := 29;
      CSC_property31:  num := 30;
      CSC_property32:  num := 31;
      CSC_property33:  num := 32;
      CSC_property34:  num := 33;
      CSC_property35:  num := 34;
      CSC_property36:  num := 35;
      CSC_property37:  num := 36;
      CSC_property38:  num := 37;
      CSC_property39:  num := 38;
      CSC_property40:  num := 39;
      CSC_property41:  num := 40;
      CSC_property42:  num := 41;
      CSC_property43:  num := 42;
      CSC_property44:  num := 43;
      CSC_property45:  num := 44;
      CSC_property46:  num := 45;
      CSC_property47:  num := 46;
      CSC_property48:  num := 47;
      CSC_property49:  num := 48;
      CSC_property50:  num := 49;
      CSC_property51:  num := 50;
      CSC_property52:  num := 51;
      CSC_property53:  num := 52;
      CSC_property54:  num := 53;
      CSC_property55:  num := 54;
      CSC_property56:  num := 55;
      CSC_property57:  num := 56;
      CSC_property58:  num := 57;
      CSC_property59:  num := 58;
      CSC_property60:  num := 59

    end;
    if (num <> -1) then
    begin
      pId := DBAppGlobals.ShowBinPropArry[num];

      if IsPropAsRGB(pId) and (Str <> '----') then
      begin
        try
          r := HexToInt(Copy(Str, 1, 2));
          g := HexToInt(Copy(Str, 3, 2));
          B := HexToInt(Copy(Str, 5, 2));
          grid.Canvas.Brush.Color := RGB(R, G, B);
        except
          grid.Canvas.Brush.Color := ClWhite;
        end;
        Str := '';
      end
      else
      begin
        if GetColorPropFromPropID(pId,Str,PropColor) then
           grid.Canvas.Brush.Color := PropColor;
      end;
    end;
  end;


// **************************************8

{
  if (p_sc.GetSchedType(id) = '2') then
    grid.Canvas.Font.Style := [fsBold]
  else
    grid.Canvas.Font.Style := [];

  if p_sc.CheckErrors(id, errVal) and (ACol > 6) then
//  and (errVal = 1) then
  begin
    TmpBrush := TBrush.Create;
    TmpPen   := TPen.Create;
    TmpFont  := TFont.Create;
    p_sc.GetColors(id, false, CompValNotValid, PNormal, TmpBrush, TmpPen, TmpFont);
    grid.Canvas.Font.Color := TmpBrush.Color;
    TmpBrush.Free;
    TmpPen.Free;
    TmpFont.Free;
  end;
}
  if ACol = 8 then
  begin
   // grid.Canvas.Brush.Color := clWhite;
   // if (Grid.ColWidths[8] > 0) then
     // p_sc.ViewBinCheckBox(id, binGrid, rect)
  end;

  //FontResize2(grid.Canvas.Font);

  if grid.Canvas.Font.Size > 6 then
    grid.Canvas.Font.Size := grid.Canvas.Font.Size -1;

  if Assigned(Img) then
  begin
    try
      grid.Canvas.Draw(rect.Left,rect.top,Img);
    except
    end;
    if str <> '' then
    begin
      grid.Canvas.Font.Style := [fsBold];
      grid.Canvas.Font.Name := 'Courier New';
      //grid.Canvas.Font.Size := 7;
      grid.Canvas.Font.Color := clBlack;
      rect.Top := rect.Top + 3;
      rect.Left := rect.Left + 3;
      rect.Bottom := rect.Top + 6;
      rect.Right  := rect.Left + 6;
      grid.Canvas.Brush.Style := bsClear;
      grid.Canvas.TextRect(rect, rect.left+1, rect.top-3, str);
      grid.Canvas.Font.Style := [];
    end;
    Img.free
  end
  else
    if (ACol <> 0) and not ((binGrid.BinColumnSet[CfgCol].Field = CSC_SeqCB)) then
    begin
      if IsGroupFormOut and RowIsSelected and (p_sc.HasFlags(id, [CSF_selected, CSF_compInBin])) then  //Draw selected row when grouping
      begin
        grid.Canvas.Brush.Color := clGreen;

        if grid.Col = Acol then
          grid.Canvas.Font.Color := clHighlightText
        else
          grid.Canvas.Font.Color := clBlack;
      end;

      grid.Canvas.TextRect(rect, rect.left+2, rect.top+2, str);
    end;


  //seq checkbox
  if (binGrid.BinColumnSet[CfgCol].Field = CSC_SeqCB) then
  begin
    Bingrid.GetSeqValue(TSchedID(TBinPanel(binGrid.Parent).m_ObjList.GetLink(ARow)), binGrid.BinColumnSet[CfgCol].Field, FieldVal);
    //str := FieldVal;
    var  ch := FieldVal = '1';
    DrawRect.Left := Rect.Left + (Rect.Right - Rect.Left - 13) div 2;
   DrawRect.Top := Rect.Top + (Rect.Bottom - Rect.Top - 13) div 2;
   DrawRect.Right := DrawRect.Left + 13;
   DrawRect.Bottom := DrawRect.Top + 13;
   var OldPenColor := grid.Canvas.Pen.Color;
   grid.Canvas.Pen.Color := clBtnShadow;
   grid.Canvas.Rectangle(DrawRect);
   grid.Canvas.Pen.Color := OldPenColor;
   DrawFrameControl(grid.Canvas.Handle, DrawRect,
                    DFC_BUTTON, IsChecked[ch]);

  end;
end;

//----------------------------------------------------------------------------//

procedure DrawHeadCell(Sender: TObject; var rect: TRect; ACol: integer; var Width: integer; var Desc: string);
var
  binGrid: TBinDrawGrid;
  num :    Integer;
  pId:     TPropId;
  Img: graphics.TBitmap;
begin
  binGrid := TBinDrawGrid(Sender);
  Assert(Assigned(binGrid));
  Img := nil;
  binGrid.Canvas.Font.Name := 'Montserrat';
  case ACol of
    0:  if (binGrid.ColWidths[0] > 0) then
          Desc := _('Comp');
    1:  begin  //Lowest Start
          if (binGrid.ColWidths[1] > 0) then
          begin
            Img := graphics.TBitmap.Create;
            try
              FMQMPlan.ImageList1.GetBitmap(26, Img);
              binGrid.Canvas.Draw(rect.Left+1,rect.top,Img);
            except
            end;
          end;
        end;
    2:  begin  //Highest end
          if (binGrid.ColWidths[2] > 0) then
          begin
            Img := graphics.TBitmap.Create;
            try
              FMQMPlan.ImageList1.GetBitmap(27, Img);
              binGrid.Canvas.Draw(rect.Left+1,rect.top,Img);
            except
            end;
          end;
        end;
    3:  begin //Materials
          if (binGrid.ColWidths[3] > 0) then
          begin
            Img := graphics.TBitmap.Create;
            try
              FMQMPlan.ImageList1.GetBitmap(24, Img);
              binGrid.Canvas.Draw(rect.Left,rect.top,Img);
            except
            end;
          end;
        end;
    4:  begin  //Material Arrival
          if (binGrid.ColWidths[4] > 0) then
          begin
            Img := graphics.TBitmap.Create;
            try
              FMQMPlan.ImageList1.GetBitmap(24, Img);
              binGrid.Canvas.Draw(rect.Left+1,rect.top,Img);
            except
            end;
          end;
        end;
    5:  begin  //Dalivery date
          if (binGrid.ColWidths[5] > 0) then
          begin
            Img := graphics.TBitmap.Create;
            try
              FMQMPlan.ImageList1.GetBitmap(25, Img);
              binGrid.Canvas.Draw(rect.Left+1,rect.top,Img);
            except
            end;
          end;
        end;
    6:  begin  //Dates Warning
          if (binGrid.ColWidths[6] > 0) then
          begin
            Img := graphics.TBitmap.Create;
            try
              FMQMPlan.ImageList1.GetBitmap(16, Img);
              binGrid.Canvas.Draw(rect.Left+1,rect.top,Img);
            except
            end;
          end;
        end;
    7:  begin  //Status
          if (binGrid.ColWidths[7] > 0) then
          begin
            Img := graphics.TBitmap.Create;
            try
              FMQMPlan.ImageList1.GetBitmap(32, Img);
              binGrid.Canvas.Draw(rect.Left+1,rect.top,Img);
            except
            end;
          end;
        end;
    8:  begin  //JobMsg
          if (binGrid.ColWidths[8] > 0) then
          begin
            Img := graphics.TBitmap.Create;
            try
              FMQMPlan.ImageList1.GetBitmap(54, Img);
              binGrid.Canvas.Draw(rect.Left+1,rect.top,Img);
            except
            end;
          end;
        end;
    else
    begin
      Acol := binGrid.BinColumnSet[Acol - binGrid.FixedCols - M_FixedColumns].RealPos;
      num := -1;
      case binGrid.BinColumnSet[Acol].Field of
        CSC_property1:   num := 0;
        CSC_property2:   num := 1;
        CSC_property3:   num := 2;
        CSC_property4:   num := 3;
        CSC_property5:   num := 4;
        CSC_property6:   num := 5;
        CSC_property7:   num := 6;
        CSC_property8:   num := 7;
        CSC_property9:   num := 8;
        CSC_property10:  num := 9;
        CSC_property11:  num := 10;
        CSC_property12:  num := 11;
        CSC_property13:  num := 12;
        CSC_property14:  num := 13;
        CSC_property15:  num := 14;
        CSC_property16:  num := 15;
        CSC_property17:  num := 16;
        CSC_property18:  num := 17;
        CSC_property19:  num := 18;
        CSC_property20:  num := 19;
        CSC_property21:  num := 20;
        CSC_property22:  num := 21;
        CSC_property23:  num := 22;
        CSC_property24:  num := 23;
        CSC_property25:  num := 24;
        CSC_property26:  num := 25;
        CSC_property27:  num := 26;
        CSC_property28:  num := 27;
        CSC_property29:  num := 28;
        CSC_property30:  num := 29;
        CSC_property31:  num := 30;
        CSC_property32:  num := 31;
        CSC_property33:  num := 32;
        CSC_property34:  num := 33;
        CSC_property35:  num := 34;
        CSC_property36:  num := 35;
        CSC_property37:  num := 36;
        CSC_property38:  num := 37;
        CSC_property39:  num := 38;
        CSC_property40:  num := 39;
        CSC_property41:  num := 40;
        CSC_property42:  num := 41;
        CSC_property43:  num := 42;
        CSC_property44:  num := 43;
        CSC_property45:  num := 44;
        CSC_property46:  num := 45;
        CSC_property47:  num := 46;
        CSC_property48:  num := 47;
        CSC_property49:  num := 48;
        CSC_property50:  num := 49;
        CSC_property51:  num := 50;
        CSC_property52:  num := 51;
        CSC_property53:  num := 52;
        CSC_property54:  num := 53;
        CSC_property55:  num := 54;
        CSC_property56:  num := 55;
        CSC_property57:  num := 56;
        CSC_property58:  num := 57;
        CSC_property59:  num := 58;
        CSC_property60:  num := 59

      end;
      if (num <> -1) then
      begin
        pId := DBAppGlobals.ShowBinPropArry[num];
        if not assigned(pId) then
        begin
          Exit;
        end;

        Desc := GetPropDescr(pId);

        // avi uncommented the 2 bellow lines , were commented 07082019
        if (binGrid.BinColumnSet[Acol].Title <> ' ') and (binGrid.BinColumnSet[Acol].Title <> '') then
          Desc := binGrid.BinColumnSet[Acol].Title;

      end else
        Desc := binGrid.BinColumnSet[Acol].Title
    end;
  end;

  if Assigned(Img) then
  begin
//    Img.Transparent := true;
    try
      binGrid.Canvas.Draw(rect.Left,rect.top,Img);
    except
    end;
    Img.free
  end
  else
  begin
    binGrid.Canvas.brush.Color := RGB(235, 240, 248);  // soft blue-gray header
    binGrid.Canvas.font.Color := RGB(40, 55, 75);     // dark blue-gray text

   { if ACol > 0 then
    begin
      binGrid.Canvas.LineTo(rect.Right ,rect.top);
      binGrid.Canvas.LineTo(rect.Right  ,rect.Bottom);
    end;}

    binGrid.Canvas.TextRect(rect, rect.left+2, rect.top+2, _(Desc));
  end;
  binGrid.MemBinColWidth
end;

//----------------------------------------------------------------------------//

procedure BinDrawCell(Sender: TObject; ACol, ARow: Longint; Rect: TRect; State: TGridDrawState);
var
  Wdh : integer;
  RowIsSelected: boolean;
  StrDes : string;
begin
  if ARow = 0 then
  begin
    DrawHeadCell(TDrawGrid(sender), rect, acol, Wdh, StrDes);
//savB    TMQMDrawGrid(sender).Canvas.TextRect(rect, rect.left+2, rect.top+2, StrDes)
  end else
  begin
    if ARow = TDrawGrid(sender).Row then
//savB    if TMQMDrawGrid(sender).Selected[ARow-1] then
      RowIsSelected := true
    else
      RowIsSelected := false;
    DrawDataCell(TDrawGrid(sender), rect, arow-1, acol, RowIsSelected, State)
//savB    DrawDataCell(TMQMDrawGrid(sender), rect, arow-1, acol, RowIsSelected)
  end
end;

// -------------------------------------------------------------------------- //
// TBinDrawGrid                                                               //
// -------------------------------------------------------------------------- //

constructor TBinDrawGrid.CreateBinGrid(AOwner: TComponent; sc: TMSchedCont;
                                       isNewTab: boolean ; DftCnfic : boolean);
begin
  inherited Create(Aowner);
  m_sc := sc;
  // now attach me to a Parent in order to correctly create child
  Parent := AOwner as TWinControl;
  Align := alClient;

  if DftCnfic then
    SetDefautCnfig
  else
    GetBinCfg(TBinPanel(Parent).m_BinType, BinColumnSet);

  if sc.GetSchedObjNum = 0 then
    RowCount := 2
  else
    RowCount := sc.GetSchedObjNum + 1;
  FixedRows := 1;
  ColCount  := 10;//9;
  FixedCols := 0;//9;
  ColCount := High(BinColDefault)+ FixedCols + M_FixedColumns;
  DefaultRowHeight := 17;
  if DBAppSettings.ShowRowInBin then
    Options := [goColSizing, goFixedVertLine, goFixedHorzLine, goVertLine,
              goHorzLine, goThumbTracking,  goRowSelect,  goDrawFocusSelected]   // goRowSelect,
  else
    Options := [goColSizing, goFixedVertLine, goFixedHorzLine, goVertLine,
              goHorzLine, goThumbTracking,  goDrawFocusSelected];   // goRowSelect,

  Align := alClient;
  OnDrawCell := DrawBinCell;
  OnDblClick := GridDblClick;
  OnSelectCell := OnSelectionCell;
  OnMouseDown := MseDown;
  OnKeyDown := GrdKeyDown;
  OnMouseWheel := GrdMouseWheel;
  OnGetEditText := GetEdtText;
  OnSetEditText := SetEdtText;
  m_commentText := 'Mqm_Ini';
  OnTopLeftChanged := GrdTopLeftChanged;
  OnKeyPress := GrdKeyPress;

  m_Col := Col;
  m_Row := Row;

  FocusCol      := -1;
  FocusRow      := -1;
  SelAnchor     := -1;
  m_Sched_Seq_List := TList.Create;

  if IsNewTab then
    SortRowBin

end;

//----------------------------------------------------------------------------//

destructor TBinDrawGrid.Destroy;
var
  I : integer;
begin
  Clear_Job_Sequence_List;
  m_Sched_Seq_List.Free;
  inherited Destroy
end;

//----------------------------------------------------------------------------//

procedure TBinDrawGrid.SortRowBin;
var
  i: integer;
begin
  UpdateArray;
  // Prepare the Array with the order number of BinColumnSet
  for i := low(BinColumnSet) to high(BinColumnSet) do
  begin
    app[BinColumnSet[i].Order] := BinColumnSet[I].Field;
    appDesending[BinColumnSet[i].Order] := BinColumnSet[I].DescendingSort;
  end;
  SetColWidth;
end;

//----------------------------------------------------------------------------//

procedure TBinDrawGrid.UpdateOrderColumns;
var
  i: integer;
begin
  for i := low(BinColumnSet) to high(BinColumnSet) do
  begin
    app[BinColumnSet[i].Order] := BinColumnSet[I].Field;
    appDesending[BinColumnSet[i].Order] := BinColumnSet[I].DescendingSort;
  end;
end;

//----------------------------------------------------------------------------//

function TBinDrawGrid.FindPosViaName(Title: String): integer;
var
  k: integer;
begin
  Result := -1;
  for k := low(BinColumnSet) to high(BinColumnSet) do
    if BinColumnSet[k].Title = Title then
    begin
      Result := k;
      exit
    end;
  if Result = -1 then
    result := -1;
end;

function TBinDrawGrid.FindPos(pos: integer): integer;
var
  k: integer;
begin
  Result := -1;
  for k := low(BinColumnSet) to high(BinColumnSet) do
    if BinColumnSet[k].Pos = pos then
    begin
      Result := k;
      exit
    end;
  if Result = -1 then
    result := -1;
end;

//----------------------------------------------------------------------------//

function TBinDrawGrid.FindOrderPos(pos: integer): integer;
var
  k: integer;
begin
  Result := -1;
  for k := Low(BinColumnSet) to High(BinColumnSet) do
    if BinColumnSet[k].Order = pos then
    begin
      Result := k;
      exit
    end;
  if Result = -1 then
    result := -1;
end;

//----------------------------------------------------------------------------//

{procedure TBinDrawGrid.DoMouseDown
               (var Msg : TWMMOUSE);

begin
  inherited MouseDown(ButtonState(msg), ShiftState(msg), msg.Xpos, msg.Ypos); //sav
end; }

//----------------------------------------------------------------------------//

procedure TBinDrawGrid.SetDefautCnfig;
var
  J : Integer;
begin
  for J := low(BinColumnSet) to high(BinColumnSet) do
  begin
    BinColumnSet[J].Field := BinDefaultTabColumnSet[J].Field;
    BinColumnSet[J].Title := BinDefaultTabColumnSet[J].Title;
    BinColumnSet[J].Pos   := BinDefaultTabColumnSet[J].Pos;
    BinColumnSet[J].Width := BinDefaultTabColumnSet[J].Width;
    BinColumnSet[J].Visible := BinDefaultTabColumnSet[J].Visible;
    BinColumnSet[J].Order := BinDefaultTabColumnSet[J].Order;
    BinColumnSet[J].PropCode := BinDefaultTabColumnSet[J].PropCode;
    BinColumnSet[J].RealPos := BinDefaultTabColumnSet[J].RealPos;
    BinColumnSet[J].NumColSorted := BinDefaultTabColumnSet[J].NumColSorted;
  end;
end;

//----------------------------------------------------------------------------//

procedure TBinDrawGrid.UpdateArray;
label
  OUTLABEL;
var
  col, corrPos, corrCol: integer;
begin
   corrPos := 0;
   col := 0;
   while true do
   begin
     while true do
     begin
       corrCol := FindPos(corrPos);
       if corrCol = -1 then goto OUTLABEL;
       if BinColumnSet[corrCol].Visible then break;
       Inc(corrPos);
       if corrPos > High(BinColumnSet) then goto OUTLABEL;
     end;
     BinColumnSet[col].RealPos := corrCol;
     Inc(col);
     Inc(corrPos)
   end;

   Dec(col);

OUTLABEL:
   ColCount := col + FixedCols + M_FixedColumns
end;

//----------------------------------------------------------------------------//

procedure TBinDrawGrid.DrawBinCell(Sender: TObject; ACol, ARow: Longint; Rect: TRect; State: TGridDrawState);
begin
  try
    TBinPanel(Parent).m_BinCfg.m_OnDrawCell(Sender, ACol, ARow, Rect, State);
  except
  end;
end;

//----------------------------------------------------------------------------//

procedure TBinDrawGrid.GetEdtText(Sender: TObject; ACol, ARow: Integer; var Value: string);
var
  CfgCol: integer;
begin
  CfgCol := BinColumnSet[ACol - FixedCols- M_FixedColumns].RealPos;
  if (CfgCol > 0) and (BinColumnSet[CfgCol].Field = CSC_SharedComment) then
    Value := m_sc.GetFldDescr(FBin.GetSchedObjByRow(ARow),CSC_SharedComment, false);
end;

//----------------------------------------------------------------------------//

procedure TBinDrawGrid.SetEdtText(Sender: TObject; ACol, ARow: Integer; const Value: string);
var
  CfgCol: integer;
begin
  CfgCol := BinColumnSet[ACol - FixedCols- M_FixedColumns].RealPos;
  m_SharedComment_Id := FBin.GetSchedObjByRow(ARow);
  //Comment
  if (CfgCol > 0) and (BinColumnSet[CfgCol].Field = CSC_SharedComment) then
    m_commentText := value;
  //Seq
  if (CfgCol > 0) and (BinColumnSet[CfgCol].Field = CSC_SchedSeq) then
    WriteNewValue(m_SharedComment_Id, CSC_SchedSeq, Value, True);
end;

//----------------------------------------------------------------------------//

procedure TBinDrawGrid.InvalidateCell(Index : integer); //override;
var
   ARow, ACol : longint;
   State      : TGridDrawState;
   Rect       : TRect;
begin
   if not UpdateDeferred then exit;
   exit;
   IndexToCell(Index,ACol,ARow);
//   if ARow < 0 then
//    exit;

//   for Acol := 0 to ColCount-1 do
//   begin
    // Rect  := CellRect(ACol, ARow);
     Rect  := CellRect(m_Col, Index + 1);
     if (Rect.Top = Rect.Bottom) and (Rect.Left = Rect.Right)
//sav        then exit;
        then exit;

     if Selected[index]
        then State := [gdSelected]
        else State := [];
     if (ARow < FixedRows) or (ACol < (FixedCols + M_FixedColumns))
        then State := State + [gdFixed];
     if (ARow = FocusRow) and (ACol = FocusCol)
        then State := State + [gdFocused];

     State := State + [gdFocused];
  //   DrawDataCell(TDrawGrid(self), rect, arow-1, acol, true, State)

     DrawDataCell(TDrawGrid(self), rect, Index, m_Col, true, State)

//   end;

end;

//----------------------------------------------------------------------------//

function TBinDrawGrid.GetSelectedList : TMSchedList;
var
  I : Integer;
  Id : TSchedId;
begin
  Result := TMSchedList.Create(self);
  for I := 0 to RowCount - 1 do
  begin
    if selected[I] then
    begin
      id := TSchedId(TBinPanel(Parent).m_ObjList.GetLink(I));
      if id = CSchedIDnull then continue;
      Result.AddLink(id);
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TBinDrawGrid.SetAllSelected;
var
  I : Integer;
begin
  for I := 0 to RowCount do
    selected[I] := true
end;

//----------------------------------------------------------------------------//

procedure TBinDrawGrid.GrdTopLeftChanged(Sender: TObject);
begin
// p_sc.DisableAllBinCheckBox(false);
end;

//----------------------------------------------------------------------------//

function TBinDrawGrid.GetAllAsSelectedForAutoRun : TMSchedList;
var
  I : Integer;
  Id : TSchedId;
begin
  Result := TMSchedList.Create(self);
  for I := 0 to RowCount - 1 do
  begin
    id := TSchedId(TBinPanel(Parent).m_ObjList.GetLink(I));
    if id = CSchedIDnull then continue;
    Result.AddLink(id);
  end;
end;

//----------------------------------------------------------------------------//
procedure TBinDrawGrid.SetColWidth;
var
  i, k : integer;
  AppArray : array[0..High(BinColDefault)] of integer;
begin
  for i := low(BinColumnSet) to high(BinColumnSet) do
    AppArray[i] := FindPos(i);

  if Assigned(TBinPanel(Parent)) and (TBinPanel(Parent).GetFiltParms <> nil) and
    (TBinPanel(Parent).GetFiltParms.P_GroupedByCode <> '') then

  begin
    ColWidths[0] := -1;
    ColWidths[1] := -1;
    ColWidths[2] := -1;
    ColWidths[3] := -1;
    ColWidths[4] := -1;
    ColWidths[5] := -1;
    ColWidths[6] := -1;
    ColWidths[7] := -1;
    ColWidths[8] := -1;
  end
  else
  begin
    if DBAppSettings.FixColCompVis then
      ColWidths[0] := 54
    else
      ColWidths[0] := -1;

    if DBAppSettings.FixColLowDVis then
      ColWidths[1] := 18
    else
      ColWidths[1] := -1;

    if DBAppSettings.FixColHigDVis then
      ColWidths[2] := 18
    else
      ColWidths[2] := -1;

    if DBAppSettings.FixColOvlpVis then
      ColWidths[3] := 18
    else
      ColWidths[3] := -1;

    if DBAppSettings.FixColMatDVis then
      ColWidths[4] := 18
    else
      ColWidths[4] := -1;

    if DBAppSettings.FixColDelDVis then
      ColWidths[5] := 18
    else
      ColWidths[5] := -1;

    if DBAppSettings.FixColDatesVis then
      ColWidths[6] := 18
    else
      ColWidths[6] := -1;

    if DBAppSettings.FixColStatVis then
      ColWidths[7] := 18
    else
      ColWidths[7] := -1;

    if DBAppSettings.FixColJobMsgVis then
      ColWidths[8] := 18
    else
      ColWidths[8] := -1;
  end;

  k := FixedCols + M_FixedColumns;

  for i := low(BinColumnSet) to high(BinColumnSet) do
  begin
    if (AppArray[i] <> -1) and (BinColumnSet[AppArray[i]].Visible) then  // mario
    begin
      ColWidths[k] := BinColumnSet[AppArray[i]].Width;
      Inc(k)
    end;
  end;

end;

//----------------------------------------------------------------------------//

function TBinDrawGrid.GetButtonMouse(var CfgCol : integer) : TMouseButton;
begin
  CfgCol := m_CfgCol;
  Result := m_Button
end;

//----------------------------------------------------------------------------//

procedure TBinDrawGrid.SetRealCfgCol(var CfgCol : integer);
begin
  CfgCol := m_CfgCol;
end;

//----------------------------------------------------------------------------//

procedure TBinDrawGrid.SetButtonMouse(Mouse : TMouseButton);
begin
  m_Button := Mouse;
end;

//----------------------------------------------------------------------------//

procedure TBinDrawGrid.ResetCfgCol;
begin
  m_CfgCol := -1;
end;

//----------------------------------------------------------------------------//

procedure TBinDrawGrid.MemBinColWidth;
var
  i, k:     integer;
  AppArray: array[0..High(BinColDefault)] of integer;
begin
  for i := low(BinColumnSet) to high(BinColumnSet) do
    AppArray[i] := FindPos(i);
  k := FixedCols + M_FixedColumns;
  for i := low(BinColumnSet) to high(BinColumnSet) do
    if (AppArray[i] <> - 1) and (BinColumnSet[AppArray[i]].Visible) then  //mario
    begin
      BinColumnSet[AppArray[i]].Width := ColWidths[k];
      Inc(k)
    end
end;

//----------------------------------------------------------------------------//

procedure TBinDrawGrid.GridDblClick(Sender: TObject);
begin
  TBinPanel(Parent).m_BinCfg.m_OnDblClick(Sender);
end;

//----------------------------------------------------------------------------//

Procedure TBinDrawGrid.GetSeqValue(id: TSchedID; fld: CBinColId; out value: variant);
var s, i : Integer;
begin
  s := 0;
  case fld of
    CSC_SchedSeq:
    begin
      for I := 0 to m_Sched_Seq_List.Count -1 do
      begin
        if PTSchedJobSeqList(m_Sched_Seq_List[i]).Id = id then
        begin
          s := PTSchedJobSeqList(m_Sched_Seq_List[i]).Sequence;
          break;
        end;
      end;
      value := s;
    end;

    CSC_SeqCB:
    begin
      for I := 0 to m_Sched_Seq_List.Count -1 do
      begin
        if PTSchedJobSeqList(m_Sched_Seq_List[i]).Id = id then
        begin
          s := 1;
          break;
        end;
      end;
      Value := s;
    end;
  end;
end;

//----------------------------------------------------------------------------//

Procedure TBinDrawGrid.Clear_Job_Sequence_List;
var
  I : integer;
begin
  for I := 0 to m_Sched_Seq_List.Count - 1 do
    dispose(PTSchedJobSeqList(m_Sched_Seq_List[I]));
  m_Sched_Seq_List.Clear;
end;

//----------------------------------------------------------------------------//

function TBinDrawGrid.Get_Job_Sequence_List_Count : integer;
begin
  result := m_Sched_Seq_List.Count
end;

//----------------------------------------------------------------------------//

function TBinDrawGrid.Fill_Job_Sequence_List : TMSchedList;
var
  I : Integer;
begin
  Result := TMSchedList.Create(self);
  for I := 0 to m_Sched_Seq_List.Count - 1 do
    Result.AddLink(PTSchedJobSeqList(m_Sched_Seq_List[I]).Id);
end;

//----------------------------------------------------------------------------//

procedure TBinDrawGrid.MseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  GCol, GRow: Longint;
  CfgCol, newSeq : integer;
  seq : Variant;
  id,IdGroup: TSchedID;
  planInfo: TSQplanInfo;
  isGroup : Boolean;
  cb : String;
  val : Variant;
begin

  m_Button := Button;

  if not (goRowSelect in Options) then
  begin
    MouseToCell(X, Y, GCol, GRow);
    CfgCol := BinColumnSet[GCol - FixedCols - M_FixedColumns].RealPos;
    m_CfgCol := CfgCol;

    Options := [goColSizing, goFixedVertLine, goFixedHorzLine, goVertLine,
               goHorzLine, goThumbTracking,  goDrawFocusSelected];

    if (CfgCol >= 0) and (BinColumnSet[CfgCol].Field = CSC_SharedComment) then
    begin

      Options := Options +  [goEditing];

      if m_commentCell and (m_commentText <> 'Mqm_Ini') then
      begin
        if m_SharedComment_Id <> CSchedIDnull then
          m_sc.SetSharedComment(m_SharedComment_Id, m_commentText);
      end
      else
        m_commentCell := true;
      Refresh;

    end
    else if (CfgCol >= 0) and (BinColumnSet[CfgCol].Field = CSC_SchedSeq) then
    begin
      Options := Options +  [goEditing];

      if m_SchedCell //and (m_SchedText <> 'Mqm_Ini')
      then
      begin
        if m_SharedComment_Id <> CSchedIDnull then
         // m_sc.SetSched(m_SharedComment_Id, m_SchedText);
      end
      else
        m_SchedCell := true;

      Refresh;
    end
    else if (CfgCol >= 0) and (BinColumnSet[CfgCol].Field = CSC_SeqCB) then
    begin
      id := FBin.GetSchedObjByRow(GRow);
      IdGroup := p_sc.LinesBelongToGroup(id, isGroup);
      if isGroup then
        Id := IdGroup;

      GetSeqValue(id, CSC_SeqCB, Val);
      cb := Val;
      seq := GetLatestSequence;

      if cb = '0' then //going to be checked
      begin
         WriteNewValue(id, CSC_SeqCB, 1, false);
         WriteNewValue(id, CSC_SchedSeq, seq, false);
      end else
        WriteNewValue(id, CSC_SeqCB, 0, false);

      Options := Options -  [goEditing];

      refresh;

    end else
    begin
      if m_commentCell then
      begin
        if (m_SharedComment_Id <> CSchedIDnull) and (m_commentText <> 'Mqm_Ini')then
        begin
          m_sc.SetSharedComment(m_SharedComment_Id, m_commentText);
          m_SharedComment_Id := CSchedIDnull
        end;
      end;
      m_commentCell := false;
      m_SchedCell := false;
      m_commentText := 'Mqm_Ini';

      Options := Options -  [goEditing];
      refresh;
    end;
  end;

//  index := CellToIndex(GCol,GRow);

  if (DBAppSettings.ShowRowInBin) then
  begin
    MouseToCell(X, Y, GCol, GRow);
    OnSelectionLine(Grow);
  end;

 //  Selected[index] := true;
 // SelectCell(GCol, GRow);
  TBinPanel(Parent).m_BinCfg.m_OnMouseDown(Sender, Button, Shift, X, Y)
end;

//----------------------------------------------------------------------------//

procedure TBinDrawGrid.OnSelectionLine(Arow : integer);
var
   index         : integer;
   j             : integer;
   i             : integer;
   istart,istop  : integer;
   State         : TKeyboardState;
   Shift         : boolean;
   Ctrl          : boolean;
   SelRect       : TGridRect;
   dorefresh     : boolean;
   prevRow       : integer;
   SelectedMarked : boolean;
begin
  UpdateDeferred := false;
  dorefresh      := false;
  prevRow := m_Row;
  m_Row := ARow;

  GetKeyboardState(State);
  Shift := ((State[vk_Shift]     and 128) <> 0);
  Ctrl  := ((State[vk_Control]   and 128) <> 0);

  index := ARow - 1;
   // CanSelect will be True if the Index is within Items. Otherwise,
   // set CanSelect to False and bail.
   // Indicate which cell now has the focus, for use in InvalidateCell.
  FocusRow := ARow;

   SelRect.Top    := ARow;
   SelRect.Bottom := ARow;
   SelRect.Left   := 0;
   SelRect.Right  := ColCount-1;

   Selection := SelRect;

   if (not Shift) or (SelAnchor < 0) then
   begin
             if Ctrl then
             begin
                          SelectedMarked := pSelectedMarked;
                          Selected[index] := not Selected[index];
                          if Selected[index]
                             then SelAnchor := index
                             else SelAnchor := -1;
                          InvalidateCell(index);

                          if(prevRow <> ARow)then
                          begin
                            if not SelectedMarked then
                            begin
                              index := prevRow - 1;
                              Selected[index] := true
                            end;
                          end;

             end
             else
             begin

                          if pSelectedMarked then
                          for j := 0 to RowCount - 1 do
                              if Selected[j] then
                              begin
                                if ((m_Button = mbRight) or (m_Button = mbMiddle)) then exit;
                                dorefresh := true;
                                ForceUnselected(j);
                              end;
                 //         ForceSelected(index);
                          SelAnchor  := index;
                          m_selectedCell := false;
             end;
   end

      // If the Shift key is depressed, and SelAnchor was other than -1,
      // determine whether the selected cell precedes or follows SelAnchor,
      // select all cells between the two, and deselect all others.
      else
      begin
                istart := min(index,SelAnchor);
                istop  := max(index,SelAnchor);

                i := 0;
                while i < istart do begin
                   ForceUnselected(i);
                   inc(i);
                end;
                while i <= istop do
                begin
                   UpdateDeferred := true;
                   ForceSelected(i);
                   inc(i);
                end;
                while i < RowCount-1 do begin
                   ForceUnselected(i);
                   inc(i);
                end;
                dorefresh := True

      end;
    if dorefresh then refresh;
end;

//----------------------------------------------------------------------------//

procedure TBinDrawGrid.OnSelectAllLine;
begin

end;

//----------------------------------------------------------------------------//

function TBinDrawGrid.GetFixedColumns : integer;
begin
  Result := m_fixedColumns
end;

//----------------------------------------------------------------------------//

procedure TBinDrawGrid.OnSelectionCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
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
   dorefresh     : boolean;
   prevRow       : integer;
   prevcol       : integer;
   SelectedMarked : boolean;
   binGrid : TBinDrawGrid;
   id : TSchedId;
begin
  FMQMPlan.m_MainX := -1;

  if (DBAppSettings.ShowRowInBin) then exit;

  UpdateDeferred := false;
  dorefresh      := false;
  prevRow := m_Row;
  prevcol := m_Col;
  m_Col := ACol;
  m_Row := ARow;

  binGrid := TBinDrawGrid(TDrawGrid(sender));
  if not assigned(binGrid) then
     Exit;

     //Mihailo
  if not BinGrid.Focused then
  begin
    CanSelect := False;
  end else
  begin
    CanSelect := True;
    FMQMPlan.Changing := False;
  end;

  id := TSchedId(TBinPanel(binGrid.Parent).m_ObjList.GetLink(m_Row - 1));
  if id = CSchedIDnull then exit;

  if Assigned(p_sc.GetExtLinkPtr(id)) then
    Fbin.TBShowOnPlan.Enabled := true
  else
    Fbin.TBShowOnPlan.Enabled := false;

 GetKeyboardState(State);
 Shift := ((State[vk_Shift]     and 128) <> 0);
 Ctrl  := ((State[vk_Control]   and 128) <> 0);

 index := CellToIndex(ACol,ARow);

 CanSelect := (index < RowCount-1) and (index >= 0);
 if not CanSelect
    then exit;

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

    if (not Shift) or (SelAnchor < 0) then
    begin
      if Ctrl then
      begin
        SelectedMarked := pSelectedMarked;
        Selected[index] := not Selected[index];
        if Selected[index] then
            SelAnchor := index
        else SelAnchor := -1;

        InvalidateCell(index);

        if not (DBAppSettings.ShowRowInBin) then
        begin
          if (prevcol = ACol) and (prevRow <> ARow)then
          begin
            if not SelectedMarked then
            begin
              index := CellToIndex(prevcol,prevRow);
              Selected[index] := true
            end;

            if (m_Button = mbRight) then
            begin
              index := CellToIndex(ACol,ARow);
              Selected[index] := true
            end;
          end;
        end;

        bMultiSelect := True;
      end
      else
      begin

          if m_Button = mbRight then
          begin
            index := CellToIndex(ACol,ARow);
            InvalidateCell(index);
            dorefresh := false;
            Selected[index] := true;

            if not bMultiSelect then
              for j := 0 to RowCount - 1 do
              if Selected[j] then
              begin
                Selected[j] := false;
                bMultiSelect := False;
              end;

          end else
          begin
            bMultiSelect := False;

          for j := 0 to RowCount - 1 do
            if Selected[j] then
            begin
              //if ((m_Button = mbRight) or (m_Button = mbMiddle))  then continue;
              dorefresh := true;
              ForceUnselected(j);
            end;
          end;

        {if (m_Button = mbRight) then
        begin
          index := CellToIndex(ACol,ARow);
          InvalidateCell(index);
          dorefresh := False;
          Selected[index] := true
        end;  }

        // ForceSelected(index);
            SelAnchor  := index;
            m_selectedCell := false;
      end;
    end

    // If the Shift key is depressed, and SelAnchor was other than -1,
    // determine whether the selected cell precedes or follows SelAnchor,
    // select all cells between the two, and deselect all others.
    else
    begin
      istart := min(index,SelAnchor);
      istop  := max(index,SelAnchor);
      dorefresh := true;
      bMultiSelect := True;

      i := 0;
      while i < istart do begin
         ForceUnselected(i);
         inc(i);
      end;
      while i <= istop do
      begin
         UpdateDeferred := true;
         ForceSelected(i);
         inc(i);
      end;
      while i < RowCount-1 do begin
         ForceUnselected(i);
         inc(i);
      end;
    end;


  if dorefresh then refresh;
  m_Button := mbLeft;
end;

//----------------------------------------------------------------------------//

procedure TBinDrawGrid.GrdKeyPress(Sender: TObject; var Key: Char);
begin
  if m_SchedCell then
    if not ((CharInSet(Key, ['0'..'9'])) or (key = chr(vk_Back)) or (key = chr(VK_DELETE)) or (Key = chr(24)) or (Key = ',') or (Key = '%')) then
      abort;
end;

//----------------------------------------------------------------------------//
//IS - ITEM-01
procedure TBinDrawGrid.GrdKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  CfgCol, J : integer;
  binGrid: TBinDrawGrid;
  CurrentComment_Id : TSchedId;
  operatePopup : boolean;
begin
  CfgCol := -1;
// if ((Key = 39) or (Key = 37)) and (Row = TopRow) and (Row > 1) then
//      TopRow := Row - 1;
  operatePopup := false;
  if ((Key = 40) or (Key = 39)) and (Row + 2 >= TopRow + VisibleRowCount) and
     (Row < RowCount - 1) then
        TopRow := (Row - VisibleRowCount) + 2;

  if ((Key = 38) or (Key = 37)) and (Row = TopRow) and (Row > 1) then
      TopRow := Row - 1;

  //if ((m_Col - FixedCols - M_FixedColumns) <= 0) then exit;

  if not (goRowSelect in Options) then
  begin

    if ((m_Col - FixedCols - M_FixedColumns) <= 0) then exit;

    CfgCol := BinColumnSet[m_Col - FixedCols - M_FixedColumns].RealPos;

    if (CfgCol >= 0) and (BinColumnSet[CfgCol].Field = CSC_SharedComment) then
    begin

      if ((Key = 40) and (Row = m_row) and (Row + 2 <= Row + VisibleRowCount) and
        (Row < RowCount - 1)) then
          m_Row := Row + 1;

      if ((Key = 38) and (Row = m_row) and (m_row >1) and (Row + 2 <= Row + VisibleRowCount) and
        (Row < RowCount - 1)) then
          m_Row := Row - 1;


      Options := [goColSizing, goEditing, goFixedVertLine, goFixedHorzLine, goVertLine,
               goHorzLine, goThumbTracking,  goDrawFocusSelected];

      CurrentComment_Id := FBin.GetSchedObjByRow(m_Row);

      if m_commentCell  then
      begin
        if (m_SharedComment_Id <> CSchedIDnull) and (CurrentComment_Id <> m_SharedComment_Id) and (m_commentText <> 'Mqm_Ini') then
          m_sc.SetSharedComment(m_SharedComment_Id, m_commentText);
      end
      else
        m_commentCell := true;

    end
    else if (CfgCol >= 0) and (BinColumnSet[CfgCol].Field = CSC_SchedSeq) then
    begin
      if ((Key = 40) and (Row = m_row) and (Row + 2 <= Row + VisibleRowCount) and
        (Row < RowCount - 1)) then
          m_Row := Row + 1;

      if ((Key = 38) and (Row = m_row) and (m_row >1) and (Row + 2 <= Row + VisibleRowCount) and
        (Row < RowCount - 1)) then
          m_Row := Row - 1;

      Options := [goColSizing, goEditing, goFixedVertLine, goFixedHorzLine, goVertLine,
               goHorzLine, goThumbTracking,  goDrawFocusSelected];

      CurrentComment_Id := FBin.GetSchedObjByRow(m_Row);

      if m_SchedCell  then
      begin
        if (m_SharedComment_Id <> CSchedIDnull) and (CurrentComment_Id <> m_SharedComment_Id)
        //and (m_commentText <> 'Mqm_Ini')
        then
         // m_sc.SetSched(m_SharedComment_Id, m_SchedText);
      end
      else
        m_SchedCell := true;
    end
    else
    begin
      if m_commentCell then
      begin

        CurrentComment_Id := FBin.GetSchedObjByRow(m_Row);

        if (m_SharedComment_Id <> CSchedIDnull) and (CurrentComment_Id <> m_SharedComment_Id) and (m_commentText <> 'Mqm_Ini') then
        begin
          m_sc.SetSharedComment(m_SharedComment_Id, m_commentText);
          m_SharedComment_Id := CSchedIDnull
        end;
      end;
      m_commentCell := false;
      m_SchedCell := False;
      m_commentText := 'Mqm_Ini';
      Options := [goColSizing, goFixedVertLine, goFixedHorzLine, goVertLine,
               goHorzLine, goThumbTracking,  goDrawFocusSelected];

    end;
  end;

  if (Key = Ord('A')) and (ssCtrl in Shift) then
  begin
    Key := 0;
    for j := 0 to RowCount - 1 do
      Selected[j] := true;
    bMultiSelect := True;
  end;

  if (CfgCol = -1) and not bMultiSelect then exit;


  if (CfgCol >= 0) and not (BinColumnSet[CfgCol].Field = CSC_SharedComment) and not (goRowSelect in Options) then
  begin
    if ((Key = 40) and (Row = m_row) and (Row + 2 <= Row + VisibleRowCount) and
      (Row < RowCount - 1)) then
      begin
        operatePopup := true;
        m_Row := Row + 1;
      end;

    if ((Key = 38) and (Row = m_row) and (m_row >1) and (Row + 2 <= Row + VisibleRowCount) and
      (Row < RowCount - 1)) then
      begin
        operatePopup := true;
        m_Row := Row - 1;
      end;

    if operatePopup then
      FBin.PopUpBinPopup(application);

  end;

  Refresh;
end;

//----------------------------------------------------------------------------//

procedure TBinDrawGrid.GrdMouseWheel(Sender: TObject; Shift: TShiftState;
                        WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var
  vNumRow: Integer;
begin
  vNumRow := WheelDelta div 40;

  if (Row + (vNumRow * -1) - 1 >= TopRow + VisibleRowCount) and (Row < RowCount - 1) then
        TopRow := (Row - VisibleRowCount) + (vNumRow * -1) - 1;

  if (Row = TopRow) and (Row > 1) then
      TopRow := Row - 1;

  m_Button := mbMiddle
end;

//----------------------------------------------------------------------------//

end.


