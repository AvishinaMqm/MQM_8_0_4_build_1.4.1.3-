unit UMbinGridMaterial;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Grids, StdCtrls, Vcl.Forms,
  UMBinFunc,   UMGlobal, UMBinMatDefault, UMBinDefault,
  UGDrawGrid, Messages, UMSchedList,
  UMSchedCont,UMSchedContFunc;

type

  TBinDrawGridMat = class(TMQMDrawGridBin) // old was TDrawGrid
  public
    BinMatColumnSet: array [0..High(BinMatColDefault)] of TBinColCurrent;
    constructor CreateBinGridMat(AOwner: TComponent; sc: TMSchedCont; isNewTab: boolean ; DftCnfic : boolean);
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

    procedure DrawMatCell(Sender: TObject; ACol, ARow: Longint; Rect: TRect; State: TGridDrawState);
    procedure OnSelectionCell(Sender: TObject; ACol, ARow: Longint; var CanSelect: Boolean);
    procedure GridDblClick(Sender: TObject);
    procedure MseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GrdKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GrdMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure SetDefautCnfig;
    procedure OnSelectionLine(Arow : integer);
    procedure OnSelectAllLine;
    function  GetFixedColumns : integer;
//    procedure DoMouseDown(var Msg : TWMMOUSE);  message WM_LBUTTONDOWN;

  public

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
    function  FindOrderPos(pos: integer): integer;
    procedure GetEdtText(Sender: TObject; ACol, ARow: Integer; var Value: string);
    procedure SetEdtText(Sender: TObject; ACol, ARow: Integer; const Value: string);
    procedure InvalidateCell(Index : integer); override;
    function  GetSelectedList : TMSchedList;
    procedure SetAllSelected;
    function  GetAllAsSelectedForAutoRun : TMSchedList;

  published
    property Color;
  end;


  function CompColValue(lParam1, lParam2: Pointer): integer;
  function GetColValue(id : TSchedId; Position : integer) : variant;
  procedure GetColNature(Position : integer; var Descending, IsDate : boolean);

  procedure DrawMatCell(Sender: TObject; ACol, ARow: Longint; Rect: TRect; State: TGridDrawState);
  procedure DrawMatDataCell(grid: TDrawGrid; var rect: TRect; ARow, ACol: integer; RowIsSelected: boolean; State: TGridDrawState);
  //  procedure CBoxSelEnter(Sender: TObject);


implementation

uses
  gnugettext,
  //UMSchedContFunc,
  FMBin,
  UMplan,
  FMMainPlan,
//  UMGlobal,
  UMCompat,
  UGObjListSrv,
  UGconvert,
  UMBinTbs,
  UMObjCont,
  UMBinPanel,
  UMAutoSchedCfg,
  FMShowColorsBar,UMWarp, UMActarea,
  UMCompatClr;

const
  M_FixedColumns = 9;

var
  app: array [0..High(BinMatColDefault)] of CBinColId;
  appDesending: array [0..High(BinMatColDefault)] of boolean;

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

function IsColumnADate(I : integer) : boolean;
begin
  Result := false;
{  if (app[i] = CSC_LowStartTimeLimit) or (app[i] = CSC_ProdDlvDate) or (app[i] = CSC_MatArrivalDate) or
     (app[i] = CSC_PlanStartDate) or (app[i] = CSC_LowStartDate) or (app[i] = CSC_PlanEndDate) or
     (app[i] = CSC_SchedStart) or (app[i] = CSC_SchedEnd) or (app[i] = CSC_PrvHighestDate) or
     (app[i] = CSC_PrvActualEnd) or (app[i] = CSC_NxtActualStart) or  (app[i] = CSC_SavedScheduleDate) or
     (app[i] = CSC_NxtLowestDate) or (app[i] = CSC_ServingGroupLowestDate) or (app[i] = CSC_HighEndLimit) then
    Result := true; }
end;

//----------------------------------------------------------------------------//

procedure GetColNature(Position : integer; var Descending, IsDate : boolean);
begin
  Descending := false;
  IsDate := false;
  if Position > High(BinMatColDefault) then Exit;
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
    Result := 0;//p_sc.GetVisbleInBin(id);
    Exit;
  end;

  if Position > High(BinMatColDefault) then
  begin
    Result := '';
    Exit;
  end;

  i := Position;
  Result := GetCellForSortValue(id, app[i]);
//  if IsColumnADate(i) then

end;

//----------------------------------------------------------------------------//

function CompColValue(lParam1, lParam2: Pointer): integer;
begin
  result := 0;
end;

//----------------------------------------------------------------------------//

function HexToInt(HexNum: string): LongInt;
begin
   Result:=StrToInt('$' + HexNum) ;
end;

procedure DrawMatDataCell(grid: TDrawGrid; var rect: TRect; ARow, ACol: integer; RowIsSelected: boolean; State: TGridDrawState);
var
  binGrid:  TBinDrawGridMat;
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
begin
  binGrid := TBinDrawGridMat(grid);
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
    0:  begin   //status

          grid.Canvas.Brush.Color := clwhite;
          if (p_sc.GetExtLinkPtr_Material(id) <> nil) then
          begin
            Img := graphics.TBitmap.Create;
            try
              FMQMPlan.ImageList1.GetBitmap(20, Img)
            except
            end;

          end
        end;
    1:  begin //Earliest Start forced
          grid.Canvas.Brush.Color := clwhite;//clGradientInactiveCaption;
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
          grid.Canvas.Brush.Color := clwhite;//clGradientInactiveCaption;


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
          grid.Canvas.Brush.Color := clwhite;//clGradientInactiveCaption;
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
          grid.Canvas.Brush.Color := clwhite;//clGradientInactiveCaption;
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
          grid.Canvas.Brush.Color := clwhite;//clGradientInactiveCaption;
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
          grid.Canvas.Brush.Color := clwhite;//clGradientInactiveCaption;
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
          grid.Canvas.Brush.Color := clwhite;//clGradientInactiveCaption;
          if (Grid.ColWidths[7] > 0) then
          begin
            if p_sc.GetFldValue(id, CSC_Closed, FieldVal, dataType) and FieldVal then
            begin
              Img := graphics.TBitmap.Create;
              try
                FMQMPlan.ImageList1.GetBitmap(33, Img)
              except
              end;
            end else
            begin
              if Assigned(ExtLinkPrt) then
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
                      if str = '' then
                        FMQMPlan.ImageList1.GetBitmap(21, Img)
                      else
                        FMQMPlan.ImageList1.GetBitmap(51, Img);
                    except
                    end;
                  end;
                end;
              end else
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
            grid.Canvas.Brush.Color := clwhite;//clGradientInactiveCaption;
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

            end;
          end;
        end
    else
    begin
      CfgCol := binGrid.BinMatColumnSet[ACol - grid.FixedCols - M_FixedColumns].RealPos;
      str := binGrid.m_sc.GetFldDescr(TSchedID(TBinPanel(binGrid.Parent).m_ObjList.GetLink(ARow)), binGrid.BinMatColumnSet[CfgCol].Field, true);
      CfgColPass := true;
      if (binGrid.BinMatColumnSet[CfgCol].Field = CSC_MatArrivalDate) then
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
      grid.Canvas.Brush.Color := clGradientInactiveCaption;
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
      grid.Canvas.Brush.Color := clGreen;
      grid.Canvas.Font.Color := clblack;
    end else
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
    //  grid.Canvas.Brush.Color := clGradientInactiveCaption;

      if (RowIsSelected) then
      begin
        if not binGrid.pSelectedMarked then
        begin
          TDrawGrid(grid).Canvas.Brush.color := clGradientInactiveCaption;
         // TDrawGrid(grid).Canvas.FillRect(rect);
        //  TDrawGrid(grid).Canvas.DrawFocusRect(Rect);
        end
        else if not binGrid.GetSelected(ARow) then // ctrl when unselected
        begin
          TDrawGrid(grid).Canvas.pen.color := clBlack;
          TDrawGrid(grid).Canvas.Brush.color := clGradientInactiveCaption;//clGrayText;
       //   TDrawGrid(grid).Canvas.FillRect(rect);
       //   TDrawGrid(grid).Canvas.DrawFocusRect(Rect);
        end;
      end;

      if binGrid.GetSelected(ARow) then
      begin
        //Rect  := binGrid.CellRect(binGrid.m_Col, ARow + 1);
        TDrawGrid(grid).Canvas.Brush.color := clGradientInactiveCaption;
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
        TDrawGrid(grid).Canvas.Brush.color := clGradientInactiveCaption;
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
      TDrawGrid(grid).Canvas.Brush.color := clGradientInactiveCaption;
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
    case binGrid.BinMatColumnSet[CfgCol].Field of
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
    if ACol <> 0 then
      grid.Canvas.TextRect(rect, rect.left+2, rect.top+2, str);

end;

//----------------------------------------------------------------------------//

procedure DrawMatHeadCell(Sender: TObject; var rect: TRect; ACol: integer; var Width: integer; var Desc: string);
var
  binGrid: TBinDrawGridMat;
  num :    Integer;
  pId:     TPropId;
  Img: graphics.TBitmap;
begin
  binGrid := TBinDrawGridMat(Sender);
  Assert(Assigned(binGrid));
  Img := nil;
  binGrid.Canvas.Font.Name := 'Montserrat';
  case ACol of
    0:  if (binGrid.ColWidths[0] > 0) then
        begin
            Img := graphics.TBitmap.Create;
            try
              FMQMPlan.ImageList1.GetBitmap(32, Img);
              binGrid.Canvas.Draw(rect.Left+1,rect.top,Img);
            except
            end;

        end;
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
      Acol := binGrid.BinMatColumnSet[Acol - binGrid.FixedCols - M_FixedColumns].RealPos;
      num := -1;
      case binGrid.BinMatColumnSet[Acol].Field of
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
        if (binGrid.BinMatColumnSet[Acol].Title <> ' ') and (binGrid.BinMatColumnSet[Acol].Title <> '') then
          Desc := binGrid.BinMatColumnSet[Acol].Title;

      end else
        Desc := binGrid.BinMatColumnSet[Acol].Title
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
    binGrid.Canvas.brush.Color := CLWhite; //$00ECE9E5;
    binGrid.Canvas.font.Color := $00412D23;//black;

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

procedure DrawMatCell(Sender: TObject; ACol, ARow: Longint; Rect: TRect; State: TGridDrawState);
var
  Wdh : integer;
  RowIsSelected: boolean;
  StrDes : string;
begin
  if ARow = 0 then
  begin
    DrawMatHeadCell(TDrawGrid(sender), rect, acol, Wdh, StrDes);
//savB    TMQMDrawGrid(sender).Canvas.TextRect(rect, rect.left+2, rect.top+2, StrDes)
  end
  else
  begin


    //exit; // for time being

    if ARow = TDrawGrid(sender).Row then
//savB    if TMQMDrawGrid(sender).Selected[ARow-1] then
      RowIsSelected := true
    else
      RowIsSelected := false;
    DrawMatDataCell(TDrawGrid(sender), rect, arow-1, acol, RowIsSelected, State)
//savB    DrawDataCell(TMQMDrawGrid(sender), rect, arow-1, acol, RowIsSelected)
  end
end;

// -------------------------------------------------------------------------- //
// TBinDrawGrid                                                               //
// -------------------------------------------------------------------------- //

constructor TBinDrawGridMat.CreateBinGridMat(AOwner: TComponent; sc: TMSchedCont;
                                       isNewTab: boolean ; DftCnfic : boolean);
begin
  inherited Create(Aowner);
  m_sc := sc;
  // now attach me to a Parent in order to correctly create child
  Parent := AOwner as TWinControl;
  Align := alClient;
  DoubleBuffered := True;

  if DftCnfic then
    SetDefautCnfig
  else
    GetBinCfg(TBinPanel(Parent).m_BinType, BinMatColumnSet);

  if sc.GetSchedObjNum = 0 then
    RowCount := 2
  else
    RowCount := sc.GetSchedObjNum + 1;
  FixedRows := 1;
  ColCount  := 10;//9;
  FixedCols := 0;//9;
  ColCount := High(BinMatColDefault)+ FixedCols + M_FixedColumns;
  DefaultRowHeight := 17;
  if DBAppSettings.ShowRowInBin then
    Options := [goColSizing, goFixedVertLine, goFixedHorzLine, goVertLine,
              goHorzLine, goThumbTracking,  goRowSelect,  goDrawFocusSelected]   // goRowSelect,
  else
    Options := [goColSizing, goFixedVertLine, goFixedHorzLine, goVertLine,
              goHorzLine, goThumbTracking,  goDrawFocusSelected];   // goRowSelect,

  Align := alClient;
  OnDrawCell := DrawMatCell;
  OnDblClick := GridDblClick;
  OnSelectCell := OnSelectionCell;
  OnMouseDown := MseDown;
  OnKeyDown := GrdKeyDown;
  OnMouseWheel := GrdMouseWheel;
  OnGetEditText := GetEdtText;
  OnSetEditText := SetEdtText;
  m_commentText := 'Mqm_Ini';
  OnTopLeftChanged := GrdTopLeftChanged;
  PopupMenu := FBin.MatPopUp;

  m_Col := Col;
  m_Row := Row;

  FocusCol      := -1;
  FocusRow      := -1;
  SelAnchor     := -1;

  if IsNewTab then
    SortRowBin

end;

//----------------------------------------------------------------------------//

destructor TBinDrawGridMat.Destroy;
begin
  inherited Destroy
end;

//----------------------------------------------------------------------------//

procedure TBinDrawGridMat.SortRowBin;
var
  i: integer;
begin
  UpdateArray;
  // Prepare the Array with the order number of BinColumnSet
  for i := low(BinMatColumnSet) to high(BinMatColumnSet) do
  begin
    if I > high(BinMatColumnSet) then continue;
    if BinMatColumnSet[I].Pos > 200 then continue;

    app[BinMatColumnSet[i].Order] := BinMatColumnSet[I].Field;
    appDesending[BinMatColumnSet[i].Order] := BinMatColumnSet[I].DescendingSort;
  end;
  SetColWidth;
end;

//----------------------------------------------------------------------------//

procedure TBinDrawGridMat.UpdateOrderColumns;
var
  i: integer;
begin
  for i := low(BinMatColumnSet) to high(BinMatColumnSet) do
  begin
    app[BinMatColumnSet[i].Order] := BinMatColumnSet[I].Field;
    appDesending[BinMatColumnSet[i].Order] := BinMatColumnSet[I].DescendingSort;
  end;
end;

//----------------------------------------------------------------------------//

function TBinDrawGridMat.FindPos(pos: integer): integer;
var
  k: integer;
begin
  Result := -1;
  for k := low(BinMatColumnSet) to high(BinMatColumnSet) do
    if BinMatColumnSet[k].Pos = pos then
    begin
      Result := k;
      exit
    end;
  if Result = -1 then
    result := -1;
end;

//----------------------------------------------------------------------------//

function TBinDrawGridMat.FindOrderPos(pos: integer): integer;
var
  k: integer;
begin
  Result := -1;
  for k := Low(BinMatColumnSet) to High(BinMatColumnSet) do
    if BinMatColumnSet[k].Order = pos then
    begin
      Result := k;
      exit
    end;
  if Result = -1 then
    result := -1;
end;

//----------------------------------------------------------------------------//

{procedure TBinDrawGridMat.DoMouseDown
               (var Msg : TWMMOUSE);

begin
  inherited MouseDown(ButtonState(msg), ShiftState(msg), msg.Xpos, msg.Ypos); //sav
end; }

//----------------------------------------------------------------------------//

procedure TBinDrawGridMat.SetDefautCnfig;
var
  J : Integer;
begin
  for J := low(BinMatColumnSet) to high(BinMatColumnSet) do
  begin
    BinMatColumnSet[J].Field := BinMatDefaultTabColumnSet[J].Field;
    BinMatColumnSet[J].Title := BinMatDefaultTabColumnSet[J].Title;
    BinMatColumnSet[J].Pos   := BinMatDefaultTabColumnSet[J].Pos;
    BinMatColumnSet[J].Width := BinMatDefaultTabColumnSet[J].Width;
    BinMatColumnSet[J].Visible := BinMatDefaultTabColumnSet[J].Visible;
    BinMatColumnSet[J].Order := BinMatDefaultTabColumnSet[J].Order;
    BinMatColumnSet[J].PropCode := BinMatDefaultTabColumnSet[J].PropCode;
    BinMatColumnSet[J].RealPos := BinMatDefaultTabColumnSet[J].RealPos;
    BinMatColumnSet[J].NumColSorted := BinMatDefaultTabColumnSet[J].NumColSorted;
  end;
end;

//----------------------------------------------------------------------------//

procedure TBinDrawGridMat.UpdateArray;
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
       if BinMatColumnSet[corrCol].Visible then break;
       Inc(corrPos);
       if corrPos > High(BinMatColumnSet) then goto OUTLABEL;
     end;
     BinMatColumnSet[col].RealPos := corrCol;
     Inc(col);
     Inc(corrPos)
   end;

   Dec(col);

OUTLABEL:
   ColCount := col + FixedCols + M_FixedColumns
end;

//----------------------------------------------------------------------------//

procedure TBinDrawGridMat.DrawMatCell(Sender: TObject; ACol, ARow: Longint; Rect: TRect; State: TGridDrawState);
begin
  try
    TBinPanel(Parent).m_BinCfg.m_OnDrawCell(Sender, ACol, ARow, Rect, State);
  except
  end;
end;

//----------------------------------------------------------------------------//

procedure TBinDrawGridMat.GetEdtText(Sender: TObject; ACol, ARow: Integer; var Value: string);
var
  CfgCol: integer;
begin
  CfgCol := BinMatColumnSet[ACol - FixedCols- M_FixedColumns].RealPos;
  if (CfgCol > 0) and (BinMatColumnSet[CfgCol].Field = CSC_SharedComment) then
    Value := m_sc.GetFldDescr(FBin.GetSchedObjByRow(ARow),CSC_SharedComment, false);
end;

//----------------------------------------------------------------------------//

procedure TBinDrawGridMat.SetEdtText(Sender: TObject; ACol, ARow: Integer; const Value: string);
begin
  m_commentText := value;
  m_SharedComment_Id := FBin.GetSchedObjByRow(ARow);
end;

//----------------------------------------------------------------------------//

procedure TBinDrawGridMat.InvalidateCell(Index : integer); //override;
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

     DrawMatDataCell(TDrawGrid(self), rect, Index, m_Col, true, State)

//   end;

end;

//----------------------------------------------------------------------------//

function TBinDrawGridMat.GetSelectedList : TMSchedList;
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

procedure TBinDrawGridMat.SetAllSelected;
var
  I : Integer;
begin
  for I := 0 to RowCount do
    selected[I] := true
end;

//----------------------------------------------------------------------------//

procedure TBinDrawGridMat.GrdTopLeftChanged(Sender: TObject);
begin
// p_sc.DisableAllBinCheckBox(false);
end;

//----------------------------------------------------------------------------//

function TBinDrawGridMat.GetAllAsSelectedForAutoRun : TMSchedList;
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
procedure TBinDrawGridMat.SetColWidth;
var
  i, k : integer;
  AppArray : array[0..High(BinMatColDefault)] of integer;
begin
  for i := low(BinMatColumnSet) to high(BinMatColumnSet) do
    AppArray[i] := FindPos(i);

  ColWidths[0] := -1;   // status
  ColWidths[1] := -1;
  ColWidths[2] := -1;
  ColWidths[3] := -1;
  ColWidths[4] := -1;
  ColWidths[5] := -1;
  ColWidths[6] := -1;
  ColWidths[7] := -1;
  ColWidths[8] := -1;

//  if DBAppSettings.FixColCompVis then
//    ColWidths[0] := 54
//  else
//    ColWidths[0] := -1;

//  if DBAppSettings.FixColLowDVis then
//    ColWidths[1] := 18
//  else
//    ColWidths[1] := -1;

//  if DBAppSettings.FixColHigDVis then
//    ColWidths[2] := 18
//  else
//    ColWidths[2] := -1;

//  if DBAppSettings.FixColOvlpVis then
//    ColWidths[3] := 18
//  else
//    ColWidths[3] := -1;

//  if DBAppSettings.FixColMatDVis then
//    ColWidths[4] := 18
//  else
//    ColWidths[4] := -1;

//  if DBAppSettings.FixColDelDVis then
///    ColWidths[5] := 18
//  else
//    ColWidths[5] := -1;

//  if DBAppSettings.FixColDatesVis then
//    ColWidths[6] := 18
///  else
//    ColWidths[6] := -1;

  if DBAppSettings.FixColStatVis then
    ColWidths[0] := 18
  else
    ColWidths[0] := -1;

//  if DBAppSettings.FixColJobMsgVis then
//    ColWidths[8] := 18
//  else
//    ColWidths[8] := -1;


  k := FixedCols + M_FixedColumns;

  for i := low(BinMatColumnSet) to high(BinMatColumnSet) do
  begin
    if (AppArray[i] <> -1) and (BinMatColumnSet[AppArray[i]].Visible) then  // mario
    begin
      ColWidths[k] := BinMatColumnSet[AppArray[i]].Width;
      Inc(k)
    end;
  end;

end;

//----------------------------------------------------------------------------//

function TBinDrawGridMat.GetButtonMouse(var CfgCol : integer) : TMouseButton;
begin
  CfgCol := m_CfgCol;
  Result := m_Button
end;

//----------------------------------------------------------------------------//

procedure TBinDrawGridMat.SetRealCfgCol(var CfgCol : integer);
begin
  CfgCol := m_CfgCol;
end;

//----------------------------------------------------------------------------//

procedure TBinDrawGridMat.SetButtonMouse(Mouse : TMouseButton);
begin
  m_Button := Mouse;
end;

//----------------------------------------------------------------------------//

procedure TBinDrawGridMat.ResetCfgCol;
begin
  m_CfgCol := -1;
end;

//----------------------------------------------------------------------------//

procedure TBinDrawGridMat.MemBinColWidth;
var
  i, k:     integer;
  AppArray: array[0..High(BinMatColDefault)] of integer;
begin
  for i := low(BinMatColumnSet) to high(BinMatColumnSet) do
    AppArray[i] := FindPos(i);
  k := FixedCols + M_FixedColumns;
  for i := low(BinMatColumnSet) to high(BinMatColumnSet) do
    if (AppArray[i] <> - 1) and (BinMatColumnSet[AppArray[i]].Visible) then  //mario
    begin
      BinMatColumnSet[AppArray[i]].Width := ColWidths[k];
      Inc(k)
    end
end;

//----------------------------------------------------------------------------//

procedure TBinDrawGridMat.GridDblClick(Sender: TObject);
begin
  TBinPanel(Parent).m_BinCfg.m_OnDblClick(Sender);
end;

//----------------------------------------------------------------------------//

procedure TBinDrawGridMat.MseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  GCol, GRow: Longint;
  CfgCol : integer;
begin

  m_Button := Button;

  if not (goRowSelect in Options) then
  begin
    MouseToCell(X, Y, GCol, GRow);
    CfgCol := BinMatColumnSet[GCol - FixedCols - M_FixedColumns].RealPos;
    m_CfgCol := CfgCol;

    if (CfgCol >= 0) and (BinMatColumnSet[CfgCol].Field = CSC_SharedComment) then
    begin

      Options := [goColSizing, goEditing, goFixedVertLine, goFixedHorzLine, goVertLine,
               goHorzLine, goThumbTracking,  goDrawFocusSelected];

      if m_commentCell and (m_commentText <> 'Mqm_Ini') then
      begin
        if m_SharedComment_Id <> CSchedIDnull then
          m_sc.SetSharedComment(m_SharedComment_Id, m_commentText);
      end
      else
        m_commentCell := true;
      Refresh;

    end
    else
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
      m_commentText := 'Mqm_Ini';
      Options := [goColSizing, goFixedVertLine, goFixedHorzLine, goVertLine,
               goHorzLine, goThumbTracking,  goDrawFocusSelected];
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

procedure TBinDrawGridMat.OnSelectionLine(Arow : integer);
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

procedure TBinDrawGridMat.OnSelectAllLine;
begin

end;

//----------------------------------------------------------------------------//

function TBinDrawGridMat.GetFixedColumns : integer;
begin
  Result := m_fixedColumns
end;

//----------------------------------------------------------------------------//

procedure TBinDrawGridMat.OnSelectionCell(Sender: TObject; ACol,
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
   binGrid : TBinDrawGridMat;
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

  binGrid := TBinDrawGridMat(TDrawGrid(sender));
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

  if Assigned(p_sc.GetExtLinkPtr_Material(id)) then
    Fbin.MiShowOnPlanMat.Enabled := true
  else
    Fbin.MiShowOnPlanMat.Enabled := false;

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

      end
      else
      begin

        if pSelectedMarked then
          for j := 0 to RowCount - 1 do
            if Selected[j] then
            begin
              //if ((m_Button = mbRight) or (m_Button = mbMiddle))  then continue;
              dorefresh := true;
              ForceUnselected(j);
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

  if dorefresh then
    refresh;

end;

//----------------------------------------------------------------------------//
//IS - ITEM-01
procedure TBinDrawGridMat.GrdKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  CfgCol, J : integer;
  binGrid: TBinDrawGridMat;
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

    CfgCol := BinMatColumnSet[m_Col - FixedCols - M_FixedColumns].RealPos;

    if (CfgCol >= 0) and (BinMatColumnSet[CfgCol].Field = CSC_SharedComment) then
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
  end;

  if CfgCol = -1 then exit;

  if (CfgCol >= 0) and not (BinMatColumnSet[CfgCol].Field = CSC_SharedComment) and not (goRowSelect in Options) then
  begin
    if ((Key = 40) and (Row = m_row) and (Row + 2 <= Row + VisibleRowCount) and
      (Row < RowCount - 1)) then
      begin
      //  operatePopup := true;
        m_Row := Row + 1;
      end;

    if ((Key = 38) and (Row = m_row) and (m_row >1) and (Row + 2 <= Row + VisibleRowCount) and
      (Row < RowCount - 1)) then
      begin
      //  operatePopup := true;
        m_Row := Row - 1;
      end;

    if operatePopup then
      FBin.PopUpBinPopup(application);

  end;

//  if  (goRowSelect in Options) then
    Refresh;
end;

//----------------------------------------------------------------------------//

procedure TBinDrawGridMat.GrdMouseWheel(Sender: TObject; Shift: TShiftState;
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

