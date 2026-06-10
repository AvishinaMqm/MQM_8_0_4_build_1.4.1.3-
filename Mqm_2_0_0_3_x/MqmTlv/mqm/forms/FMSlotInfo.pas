unit FMSlotInfo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, UMWkCtr, UGWorkCentersPlanDraw,
  UGWorkCentersPlanShot,
  Vcl.ExtCtrls, Vcl.Grids, cxGraphics, dxUIAClasses, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxGroupBox;

type
  TSlotInfo = class(TForm)
    LabeltotalQty: TLabel;
    EdtTotalQty: TEdit;
    EdtCustomizedQty: TEdit;
    LblTotalCustomizedQty: TLabel;
    pnPerc: TPanel;
    pnQty: TPanel;
    sgData: TStringGrid;
    cxGroupBox1: TcxGroupBox;
    LblAvailableHours: TLabel;
    EdtAvailableHours: TEdit;
    edtResComp: TEdit;
    Label1: TLabel;
    cxGroupBox2: TcxGroupBox;
    LabelTotalHoursCapacity: TLabel;
    EdtToTalHoursCapacity: TEdit;
    EdtSlotPercent: TEdit;
    LblSlotPercent: TLabel;
    Label2: TLabel;
    edtComp: TEdit;
    procedure sgDataSelectCell(Sender: TObject; ACol, ARow: Integer;    var CanSelect: Boolean);
    procedure FormShow(Sender: TObject);
  private
    m_workCenter : TMqmWrkCtr;
    m_start : TDateTime;
    m_end   : TDateTime;
    m_PlanWcView : TPlanWcView;
    SlotView : String;
    m_CapLists : TList;   // list of TList of PWkcDailyCapacity for USED hours + job grid (WC or entity lists)
    m_AvailLists : TList; // list of TList of PWkcDailyCapacity for AVAILABLE hours (always WC-level lists)
    m_WcList   : TList;   // list of TMqmWrkCtr contributing to this slot
  public
    constructor CreateSlotInfo(AOwner : Tcomponent; PlanWcView : TPlanWcView; Wcntr : pointer; SchedStart : TDateTime; SchedEnd : TDateTime);
    constructor CreateSlotInfoForWcList(AOwner : Tcomponent; PlanWcView : TPlanWcView; WcList : TList; EntityCode : string; SchedStart : TDateTime; SchedEnd : TDateTime);
    destructor  Destroy; override;
    procedure IniDataPercent;
    procedure IniDateTotalSchedQty;
    procedure SortGrid(ACol : Integer);
  end;

implementation

uses
  UMObjCont, UMSchedContFunc, UMGlobal, System.Math, UGglobal, UmPlan, UMRes, UGWorkCentersPlanControl;
{$R *.dfm}

{ TSlotInfo }

procedure TSlotInfo.SortGrid(ACol : Integer);
var
  CurRowA: Integer;
  CurRowB: Integer;
  smallest: string;
  SortCol: Integer;
  StartRow: Integer;
  Pos : Integer;
  temp: TStrings;
begin
  temp := TStringList.Create();
  try
    SortCol := ACol;
    StartRow := 1;

    for CurRowA := StartRow to sgData.RowCount-2 do
    begin
      Pos := -1;
      smallest := sgData.Cells[SortCol, CurRowA];

      for CurRowB := CurRowA+1 to sgData.RowCount-1 do
      begin
        if smallest > sgData.Cells[SortCol, CurRowB] then
        begin
          Pos := CurRowB;
          smallest := sgData.Cells[SortCol, CurRowB];
        end;
      end;

      if Pos > -1 then
      begin
        temp.Assign(sgData.Rows[CurRowA]);
        sgData.Rows[CurRowA] := sgData.Rows[Pos];
        sgData.Rows[Pos] := temp;
      end;
    end;
  finally
    temp.Free;
  end;
end;

//----------------------------------------------------------------------------//

procedure AutoSizeGridColumns(Grid: TStringGrid);
const
  MIN_COL_WIDTH = 15;
var
  Col : Integer;
  ColWidth, CellWidth: Integer;
  Row: Integer;
begin
  Grid.Canvas.Font.Assign(Grid.Font);
  for Col := 0 to Grid.ColCount -1 do
  begin
    ColWidth := Grid.Canvas.TextWidth(Grid.Cells[Col, 0]);
    for Row := 0 to Grid.RowCount - 1 do
    begin
      CellWidth := Grid.Canvas.TextWidth(Grid.Cells[Col, Row]);
      if CellWidth > ColWidth then
        Grid.ColWidths[Col] := CellWidth + MIN_COL_WIDTH
      else
        Grid.ColWidths[Col] := ColWidth + MIN_COL_WIDTH;
    end;
  end;
end;

//----------------------------------------------------------------------------//

constructor TSlotInfo.CreateSlotInfo(AOwner : Tcomponent; PlanWcView : TPlanWcView; Wcntr : pointer; SchedStart : TDateTime; SchedEnd : TDateTime);
begin
  inherited create(AOwner);
  m_workCenter := TMqmWrkCtr(Wcntr);
  m_start := SchedStart;
  m_end   := SchedEnd;
  m_PlanWcView := PlanWcView;
  SlotView := TPlanWcControl(PlanWcView.m_PlanControl).m_cbCal.Text;

  m_CapLists := TList.Create;
  m_AvailLists := TList.Create;
  m_WcList   := TList.Create;
  if assigned(m_workCenter) then
  begin
    m_CapLists.Add(m_workCenter.m_WkcDailyCapacityList);
    m_AvailLists.Add(m_workCenter.m_WkcDailyCapacityList);
    m_WcList.Add(m_workCenter);
  end;

  if DBAppGlobals.MCMSlotDisplay = 0 then
    IniDataPercent
  else
    IniDateTotalSchedQty

end;

//----------------------------------------------------------------------------//

// Generalized Slot Info for any slot level (WC, WC-Group, Plant, Division,
// Property, Category). The caller passes the explicit set of work centers that
// build the slot (one WC, or all WCs of a group/plant/division), plus an
// optional property/category EntityCode. USED hours + the job grid come from
// the WC capacity (EntityCode = '') or the entity capacity (EntityCode <> ''),
// while AVAILABLE hours always come from the WC capacity — the same denominator
// the slot is painted with.
constructor TSlotInfo.CreateSlotInfoForWcList(AOwner : Tcomponent; PlanWcView : TPlanWcView; WcList : TList; EntityCode : string; SchedStart : TDateTime; SchedEnd : TDateTime);
var
  w       : Integer;
  WC      : TMqmWrkCtr;
  EntList : TList;
begin
  inherited create(AOwner);
  m_start := SchedStart;
  m_end   := SchedEnd;
  m_PlanWcView := PlanWcView;
  SlotView := TPlanWcControl(PlanWcView.m_PlanControl).m_cbCal.Text;

  m_CapLists := TList.Create;
  m_AvailLists := TList.Create;
  m_WcList   := TList.Create;

  if assigned(WcList) then
    for w := 0 to WcList.Count - 1 do
    begin
      WC := TMqmWrkCtr(WcList[w]);
      if not assigned(WC) then continue;
      m_WcList.Add(WC);
      m_AvailLists.Add(WC.m_WkcDailyCapacityList);
      if EntityCode = '' then
        m_CapLists.Add(WC.m_WkcDailyCapacityList)
      else
      begin
        EntList := WC.GetEntityDailyCapacityList(EntityCode);
        if assigned(EntList) then m_CapLists.Add(EntList);
      end;
    end;

  if m_WcList.Count > 0 then
    m_workCenter := TMqmWrkCtr(m_WcList[0]);

  if DBAppGlobals.MCMSlotDisplay = 0 then
    IniDataPercent
  else
    IniDateTotalSchedQty
end;

//----------------------------------------------------------------------------//

destructor TSlotInfo.Destroy;
begin
  // m_CapLists / m_AvailLists / m_WcList only reference lists owned by the work
  // centers, so free the containers only, never their contents.
  m_CapLists.Free;
  m_AvailLists.Free;
  m_WcList.Free;
  inherited Destroy;
end;

//----------------------------------------------------------------------------//

procedure TSlotInfo.FormShow(Sender: TObject);
begin
  sgData.SetFocus;
end;

//----------------------------------------------------------------------------//

procedure TSlotInfo.IniDataPercent;

type Q = record
  Preq_no, step,substep : string;
  hoursused,neededcomp, jobhours : Double;
end;
  rQ = ^Q;
var
  pQ, pQt, pQW : rQ;
  tl, tl2 : TList;
  I, J, r, src : Integer;
  CapList : TList;
  DailyCapacity : PWkcDailyCapacity;
  JobCapacity   : PJobCapacity;
  Hours_used, Hours_Available, ResTotal, CompTotal  : double;
  FieldVal : variant;
  ProdReq ,Step, SubStep : string;
  dataType: CBinColValType;
  perc : double;
  res: TMqmRes;
begin
  Hours_Available := 0;
  ResTotal := 0;
  CompTotal := 0;
  Hours_used := 0;
  pnPerc.Visible := True;
  pnQty.Visible := False;
  tl := TList.Create;
  tl2 := TList.Create;

  if m_CapLists.Count = 0 then
    exit;

  r := 1;

  sgData.ColCount := 6;
  sgData.RowCount := 1;
  sgData.Cells[0,0] := 'Request';
  sgData.Cells[1,0] := 'Step';
  sgData.Cells[2,0] := 'Sub Step';
  sgData.Cells[3,0] := 'Calendar hours used';
  sgData.Cells[4,0] := 'Components used';
  sgData.Cells[5,0] := 'Job hours used';

  for src := 0 to m_CapLists.Count - 1 do
  begin
    CapList := TList(m_CapLists[src]);
    if not assigned(CapList) then continue;
    for I := 0 to CapList.count - 1 do
    begin
      if (PWkcDailyCapacity(CapList[I]).Date < m_start) then continue;
      if (PWkcDailyCapacity(CapList[I]).Date > m_end) then break;
      DailyCapacity := PWkcDailyCapacity(CapList[I]);
      Hours_used      := Hours_used + DailyCapacity.Hours_used;

      if (Hours_used > 0) and assigned(DailyCapacity.ListIds) then
      begin
        for J := 0 to DailyCapacity.ListIds.Count - 1 do
        begin
          JobCapacity := PJobCapacity(DailyCapacity.ListIds[J]);

          if JobCapacity.qty = 0 then continue;

          sgData.RowCount := sgData.RowCount + 1;

          p_sc.GetFldValue(JobCapacity.id, CSC_ProdReq, FieldVal, dataType);
          ProdReq := FieldVal;

          p_sc.GetFldValue(JobCapacity.id, CSC_ProdStep, FieldVal, dataType);
          Step := FieldVal;

          p_sc.GetFldValue(JobCapacity.id, CSC_ProdSubStep, FieldVal, dataType);
          SubStep := FieldVal;

          sgData.Cells[0, r] := ProdReq;
          sgData.Cells[1, r] := Step;
          sgData.Cells[2, r] := SubStep;
          sgData.Cells[3, r] := FloatToStr(RoundTo(JobCapacity.HoursUsedJobWithoutComponents,-2));
          sgData.Cells[4, r] := FloatToStr(RoundTo(JobCapacity.NeededComponents,-2));
          sgData.Cells[5, r] := FloatTostr(RoundTo(JobCapacity.JobHours,-2));
          inc(r);
        end;
      end;
    end;
  end;

  // Available hours come from the WC-level capacity (the denominator the slot is
  // painted with) — for property/category this differs from the entity list.
  for src := 0 to m_AvailLists.Count - 1 do
  begin
    CapList := TList(m_AvailLists[src]);
    if not assigned(CapList) then continue;
    for I := 0 to CapList.count - 1 do
    begin
      if (PWkcDailyCapacity(CapList[I]).Date < m_start) then continue;
      if (PWkcDailyCapacity(CapList[I]).Date > m_end) then break;
      Hours_Available := Hours_Available + PWkcDailyCapacity(CapList[I]).Hours_Available;
    end;
  end;

  SortGrid(0);
  if SlotView <> 'daily' then
  begin
    for i := 1 to sgData.RowCount-1 do
    begin
        New(pQ);
        pQ.Preq_no := sgData.Cells[0,i];
        pQ.step := sgData.Cells[1,i];
        pQ.substep := sgData.Cells[2,i];
        pQ.hoursused := StrToFloat(sgData.Cells[3,i]);
        pQ.neededcomp := StrToFloat(sgData.Cells[4,i]);
        pQ.jobhours := StrToFloat(sgData.Cells[5,i]);
        tl.Add(pQ);
    end;


    for i := 0 to tl.Count -1 do
    begin

      if i = 0 then
      begin
        tl2.Add(tl[0]);
      end
      else
      begin
        pQ := tl[i];
        pQt := tl[i-1];

        if (pQt.Preq_no = pQ.Preq_no)
         and (pQt.step = pQ.step)
         and (pQt.substep = pQ.substep)
         then
        begin
          pQW := tl2[tl2.Count-1];
          pQW.hoursused := pQt.hoursused + pQ.hoursused;
          pQW.jobhours := pQt.jobhours + pQ.jobhours;
          tl2.Remove(tl2[tl2.Count-1]);
          tl2.Add(pQW);
          pQW := nil;
        end else
        begin
           if (pQt.Preq_no <> pQ.Preq_no)
             or (pQt.step <> pQ.step)
             or (pQt.substep <> pQ.substep)
           then
              tl2.Add(pQ);
        end;
      end;

    end;

    pQ := nil;
    for I := 0 to sgData.ColCount - 1 do
      sgData.Cols[I].Clear;

    sgData.RowCount := 1;
    sgData.Cells[0,0] := 'Request';
    sgData.Cells[1,0] := 'Step';
    sgData.Cells[2,0] := 'SubStep';
    sgData.Cells[3,0] := 'Hours Used';
    sgData.Cells[4,0] := 'Needed Components';
    sgData.Cells[5,0] := 'Job Hours';

     for i := 0 to tl2.Count -1 do
     begin
        pQ := tl2[i];
        sgData.RowCount := sgData.RowCount + 1;
        sgData.Cells[0, i+1] := pQ.Preq_no;
        sgData.Cells[1, i+1] := pQ.step;
        sgData.Cells[2, i+1] := pQ.substep;
        sgData.Cells[3, i+1] := FloatToStr(RoundTo(pQ.hoursused,-2));
        sgData.Cells[4, i+1] := FloatToStr(RoundTo(pQ.neededcomp,-2));
        sgData.Cells[5, i+1] := FloatTostr(RoundTo(pQ.jobhours,-2));
     end;

     for i := 0 to tl.Count -1 do
      Dispose(rQ(tl[i]));

      i := 0;

//     for i := 0 to tl2.Count -1 do
  //    Dispose(rQ(tl2[i]));
  end;

   tl.Free;
   tl2.Free;

  for src := 0 to m_WcList.Count - 1 do
    for i := 0 to TMqmWrkCtr(m_WcList[src]).p_ResCount -1 do
    begin
      res := TMqmRes(TMqmWrkCtr(m_WcList[src]).p_Res[i]);
      ResTotal := ResTotal + res.p_ResComp;
    end;

  if ResTotal > 0 then
  begin
    edtResComp.Visible := True;
    Label1.Visible := True;
    edtResComp.Text := FloatToStr(ResTotal);
  end else
  begin
    edtResComp.Visible := False;
    Label1.Visible := False;
  end;

  SortGrid(0);
  AutoSizeGridColumns(sgData);

  var wid := sgData.ColWidths[4];

  sgData.ColWidths[4] := -1;

  for i := 1 to sgData.RowCount -1 do
    if sgData.Cells[4, i] <> '' then
      CompTotal := CompTotal + StrToFloat(sgData.Cells[4, i]);

  if CompTotal > 0  then
      sgData.ColWidths[4] := wid;

  if CompTotal > 0 then
  begin
    edtComp.Visible := True;
    Label2.Visible := True;
    edtComp.Text := FloatToStr(CompTotal);
  end else
  begin
    edtComp.Visible := False;
    Label2.Visible := False;
  end;

  EdtToTalHoursCapacity.Text := FormatFloat('#,##0.00', Hours_used);
  EdtAvailableHours.Text     := FormatFloat('#,##0.00', Hours_Available);

  //if perc > 1 then
  perc := Hours_used/Hours_Available;
  if Hours_Available = 0 then
     perc := 0;

  if (perc > 0) and (perc < 0.01) then
  begin
    perc := trunc(perc * 1000) / 10;
    if (perc = 0) then perc := 0.1;
    EdtSlotPercent.text := FloatToStr(perc) + ' %';
  end
  else
    EdtSlotPercent.text := FloatToStr(SimpleRoundTo(perc * 100.0, 0)) + ' %';

end;

//----------------------------------------------------------------------------//

procedure TSlotInfo.IniDateTotalSchedQty;

type Q = record
  Preq_no, step,substep : string;
  qty, custQty : Double;
end;
  rQ = ^Q;
var
  pQ, pQt, pQW : rQ;
  tl, tl2 : TList;
  I, J, r, src : Integer;
  CapList : TList;
  DailyCapacity : PWkcDailyCapacity;
  JobCapacity   : PJobCapacity;
  Hours_used, Hours_Available, TatalQty, TotalCustQty : double;
  FieldVal : variant;
  ProdReq ,Step, SubStep : string;
  dataType: CBinColValType;
begin
  Hours_Available := 0;
  Hours_used := 0;
  TatalQty := 0;
  TotalCustQty  := 0;

  tl := TList.Create;
  tl2 := TList.Create;

  pnPerc.Visible := False;
  pnQty.Visible := True;

  sgData.ColCount := 5;
  sgData.RowCount := 1;
  sgData.Cells[0,0] := 'Request';
  sgData.Cells[1,0] := 'Step';
  sgData.Cells[2,0] := 'SubStep';
  sgData.Cells[3,0] := 'Qty';
  sgData.Cells[4,0] := 'Customized Qty';

  if m_CapLists.Count = 0 then
    exit;

  r := 1;
//  ListIds := TStringList.Create;
  for src := 0 to m_CapLists.Count - 1 do
  begin
    CapList := TList(m_CapLists[src]);
    if not assigned(CapList) then continue;
    for I := 0 to CapList.count - 1 do
    begin
      if (PWkcDailyCapacity(CapList[I]).Date < m_start) then continue;
      if (PWkcDailyCapacity(CapList[I]).Date > m_end) then break;
      DailyCapacity := PWkcDailyCapacity(CapList[I]);
      Hours_used      := Hours_used + DailyCapacity.Hours_used;
      Hours_Available := Hours_Available + DailyCapacity.Hours_Available;

      if (Hours_used > 0) and assigned(DailyCapacity.ListIds) then
      begin
        for J := 0 to DailyCapacity.ListIds.Count - 1 do
        begin
          JobCapacity := PJobCapacity(DailyCapacity.ListIds[J]);

          if JobCapacity.qty = 0 then continue;

          sgData.RowCount := sgData.RowCount +1;

          p_sc.GetFldValue(JobCapacity.id, CSC_ProdReq, FieldVal, dataType);
          ProdReq := FieldVal;
          p_sc.GetFldValue(JobCapacity.id, CSC_ProdStep, FieldVal, dataType);
          Step := FieldVal;
          p_sc.GetFldValue(JobCapacity.id, CSC_ProdSubStep, FieldVal, dataType);
          SubStep := FieldVal;
          sgData.Cells[0, r] := ProdReq;
          sgData.Cells[1, r] := Step;
          sgData.Cells[2, r] := SubStep;

          TatalQty := TatalQty + JobCapacity.qty;
          TotalCustQty := TotalCustQty + JobCapacity.PropMultiQty;

          sgData.Cells[3, r] := FloatToStr(JobCapacity.qty);

          sgData.Cells[4, r] := FloatToStr(JobCapacity.PropMultiQty);
          Inc(r);
        end;
      end;
    end;
  end;

  SortGrid(0);
  if SlotView <> 'daily' then
  begin
    for i := 1 to sgData.RowCount-1 do
    begin
        New(pQ);
        pQ.Preq_no := sgData.Cells[0,i];
        pQ.step := sgData.Cells[1,i];
        pQ.substep := sgData.Cells[2,i];
        pQ.qty := StrToFloat(sgData.Cells[3,i]);
        pQ.custQty := StrToFloat(sgData.Cells[4,i]);
        tl.Add(pQ);
    end;


    for i := 0 to tl.Count -1 do
    begin

      if i = 0 then
      begin
        tl2.Add(tl[0]);
      end
      else
      begin
        pQ := tl[i];
        pQt := tl[i-1];

        if (pQt.Preq_no = pQ.Preq_no)
         and (pQt.step = pQ.step)
         and (pQt.substep = pQ.substep)
         then
        begin
          pQW := tl2[tl2.Count-1];
          pQW.qty := pQt.qty + pQ.qty;
          pQW.custqty := pQt.custqty + pQ.custqty;
          tl2.Remove(tl2[tl2.Count-1]);
          tl2.Add(pQW);
          pQW := nil;
        end else
        begin
           if (pQt.Preq_no <> pQ.Preq_no)
             or (pQt.step <> pQ.step)
             or (pQt.substep <> pQ.substep)
           then
              tl2.Add(pQ);
        end;
      end;

    end;

    pQ := nil;
    for I := 0 to sgData.ColCount - 1 do
      sgData.Cols[I].Clear;

    sgData.RowCount := 1;
    sgData.Cells[0,0] := 'Request';
    sgData.Cells[1,0] := 'Step';
    sgData.Cells[2,0] := 'SubStep';
    sgData.Cells[3,0] := 'Qty';
    sgData.Cells[4,0] := 'Customized Qty';

     for i := 0 to tl2.Count -1 do
     begin
        pQ := tl2[i];
        sgData.RowCount := sgData.RowCount + 1;
        sgData.Cells[0, i+1] := pQ.Preq_no;
        sgData.Cells[1, i+1] := pQ.step;
        sgData.Cells[2, i+1] := pQ.substep;
        sgData.Cells[3, i+1] := FloatToStr(RoundTo(pQ.qty,-2));
        sgData.Cells[4, i+1] := FloatToStr(RoundTo(pQ.custqty,-2));
     end;

     for i := 0 to tl.Count -1 do
      Dispose(rQ(tl[i]));

      i := 0;

//     for i := 0 to tl2.Count -1 do
  //    Dispose(rQ(tl2[i]));
  end;

   tl.Free;
   tl2.Free;

  EdtTotalQty.Text      := FormatFloat('#,##0.00', TatalQty);
  EdtCustomizedQty.Text := FormatFloat('#,##0.00', TotalCustQty);

  SortGrid(0);
  AutoSizeGridColumns(sgData);
end;

procedure TSlotInfo.sgDataSelectCell(Sender: TObject; ACol, ARow: Integer;  var CanSelect: Boolean);
begin
  if ARow = 0 then  SortGrid(ACol);
end;

end.
