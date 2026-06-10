unit UMSchedView;

interface

uses
  controls,classes,Grids,Windows,Graphics,
  UMSchedList, SysUtils , UReshape,
  UMSchedContFunc,  ComCtrls,
  UGDrawGrid,
  gnugettext;

type

  TMSchedListView = class(TMQMDrawGrid)
  private
    m_schedList: TMSchedList;
  public
    constructor CreateListView(AOwner: TComponent ; SchedList : TMSchedList);
    destructor  Destroy; override;
    procedure   SetSchedList(schedList: TMSchedList);
    procedure   RefreshList;
    function    GetSelected: TSchedId;
    function    GetSelectedList: TList;
    procedure   DetailSelected;
    function    GetListIds : TList;
  private
    procedure   DrawSchedCell(Sender: TObject; ACol, ARow: Longint; Rect: TRect; State: TGridDrawState);
    procedure   DrawSchedDLClick(Sender: TObject);
  end;

implementation

uses UMObjCont,FMMainPlan,UMSchedCont,
     FMStepDetails, UMGlobal;
//These strings are not really used in the program and are here only
//for the translation extraction purpose
var
  notused1: string = 'Prod. Req.';
  notused2: string = 'Prod. step';
  notused3: string = 'Prod. substep';
  notused4: string = 'Reproc. No.';
  notused5: string = 'Quantity';
  notused6: string = 'UM';
  notused7: string = 'Setup time';
  notused8: string = 'Actual Execution time';
  notused9: string = 'Actual. start';
  notused10: string = 'Actual. end';
  notused11: string = 'Work Center';
  notused12: string = 'Wkc. process';
  notused13: string = 'Split Family';
  notused14: string = 'Sequence';
  notused15: string = 'Material code';
  notused16: string = 'Material description';
const

  ColumnSet : array [0..16] of CBinColId  =  (
    CSC_ProdReq,
    CSC_ProdStep,
    CSC_ProdSubStep,
    CSC_ReprocNo,
    CSC_QtyToSched,
    CSC_ProdUM,
    CSC_QtyToSched,
    CSC_SupTimeSched,
    CSC_ActualTime,//CSC_ExeTimeSched,
    CSC_ProgStart,
    CSC_ProgEnd,
    CSC_WkctCode,
    CSC_WkctProc,
    CSC_SplitFamily,
    CSC_Sequence,
    CSC_ProdFamily,
    CSC_ProductDescription
    );

  ColumnSetTitle : array [0..16] of string  = (
//If any of the strings are changed the above notused corresponding
//string should also be changed
   'Prod. req. ',
   'Step',
   'Substep',
   'Reprocess',
   'Quantity',
   'UM',
   'Alt.Qty',
   'Setup time',
   'Actual execution time',
   'Actual Start',
   'Actual End',
   'Work center',
   'Work center process',
   'Split Family',
   'Sequence',
   'Product family',
   'Product description');

  ColumnWidths : array [0..16] of integer  = (
   215,
   70,
   70,
   70,
   70,
   70,
   70,
   70,
   100,
   100,
   100,
   100,
   100,
   100,
   70,
   500,
   300);

{ TMSchedList }

//------------------------------------------------------------------------------

constructor TMSchedListView.CreateListView(AOwner: TComponent; schedList: TMSchedList);
var
  i: integer;
begin
  inherited Create(Owner);
  Parent           := AOwner as TWinControl;
  Align            := alClient;
  FixedRows        := 1;
  FixedCols        := 0;
  DefaultRowHeight := 15;
  MultiSelect      := true;
  DefaultColWidth  := 100;

  if DBAppSettings.FixColJobMsgVis then
  begin
    ColCount         := Length(ColumnSet)+1;
    for i := Low(ColumnWidths) to High(ColumnWidths) do
      ColWidths[i+1] := ColumnWidths[i];

  end else
  begin
    ColCount         := High(ColumnSet) - Low(ColumnSet) +1;
    for i := Low(ColumnWidths) to High(ColumnWidths) do
      ColWidths[i] := ColumnWidths[i];
  end;

  Options          := Options + [goRowSelect,goColSizing];

  m_SchedList      := SchedList;
  if Assigned(schedList) then
    RowCount := m_SchedList.GetLinkCount + 1
  else
    RowCount := 2;

  OnDrawCell := DrawSchedCell;

  OnDblClick := DrawSchedDLClick
end;

//------------------------------------------------------------------------------

destructor TMSchedListView.Destroy;
begin
  m_SchedList := nil;
  inherited Destroy
end;

//------------------------------------------------------------------------------

procedure DrawDataCell(grid: TDrawGrid; var rect: TRect; ARow, ACol: integer; RowIsSelected: boolean);
var
  dwGrid: TMSchedListView;
  str, S, TempStrQty :    string;
  id:     TSchedID;
  planInfo : TSQplanInfo;
  jobqty, stepqty : Variant;
  SplitInfo : TSQSplitInfo;
  dataType  : CBinColValType;
  AltQty    : double;
  QtyInt   : Integer;
begin
  dwGrid := TMSchedListView(grid);

  FontResize2(dwGrid.canvas.font,0);

  dwGrid.canvas.font.Name := 'Montserrat';

  if not Assigned(dwGrid.m_SchedList)
  or (dwGrid.m_SchedList.GetLinkCount <= 0) then
    str := '----'
  else
  begin
    id  := dwGrid.m_SchedList.GetLink(ARow);
    str := p_sc.GetFldDescr(id, ColumnSet[ACol], false);
   { if (ColumnSet[ACol] = CSC_ExeTimeSched) then
    begin
      p_sc.GetPlanInfo(id, planInfo);
      if planInfo.IgnorExeTimeWhenGrp then
        str := '----';
    end;  }

    if ACol = 6 then
    begin
      p_sc.GetFldValue(Id, CSC_QtyToSched, jobqty, dataType);  //Job qty
      p_sc.GetFldValue(Id, CSC_IniQty , stepqty, dataType);    //Step qty
      p_sc.GetSplitInfo(Id, SplitInfo);
      if SplitInfo.AlternativeQty > 0 then //Alt qty
      begin
        AltQty := jobqty / StepQty * SplitInfo.AlternativeQty;
        QtyInt := trunc(AltQty * 100);
        AltQty := QtyInt/100;
        str := floatToStr(AltQty);
        //str := FormatFloat('0.0000', jobqty / StepQty * SplitInfo.AlternativeQty)
      end
      else
        str := '';
    end;
  end;
  dwGrid.Canvas.TextRect(rect, rect.left+2, rect.top, str);

  if RowIsSelected then
    grid.Canvas.Font.Color := clWhite
  else
    grid.Canvas.Font.Color := clBlack
end;

//------------------------------------------------------------------------------

procedure TMSchedListView.SetSchedList(schedList: TMSchedList);
begin
  m_schedList := schedList;
  if not Assigned(schedList) or (m_SchedList.GetLinkCount <= 0) then
    RowCount := 2
  else
    RowCount := m_SchedList.GetLinkCount + 1;
end;

//------------------------------------------------------------------------------

procedure TMSchedListView.DrawSchedCell(Sender: TObject; ACol, ARow: Longint; Rect: TRect; State: TGridDrawState);
var
  StrDes:        string;
  RowIsSelected: boolean;
  Img: graphics.TBitmap;
  IsGroup : boolean;
  GetMsg,SentMsg : boolean;
begin
  //TDrawGrid(sender).Canvas.Font.Size := 7;
  Rect.Height := Rect.Height;

  if (FixedCols > 0) then
  begin
    if ACol = 0 then
    begin
      if (ARow = 0) then
      begin
        Img := graphics.TBitmap.Create;
        try
          FMQMPlan.ImageList1.GetBitmap(54, Img);
          TDrawGrid(sender).Canvas.Draw(rect.Left+1,rect.top,Img);
        except
        end;
      end
      else
      begin
        if p_sc.GetStatuseMsgForJob(m_SchedList.GetLink(ARow - 1),IsGroup,GetMsg,SentMsg) then
        begin
          Img := graphics.TBitmap.Create;

     //     if True then

       //   FMQMPlan.ImageList1.GetBitmap(54, Img);
          try
            if GetMsg and not SentMsg then
              FMQMPlan.ImageList1.GetBitmap(54, Img)
            else if SentMsg and not GetMsg then
              FMQMPlan.ImageList1.GetBitmap(55, Img)
            else if GetMsg and SentMsg then
              FMQMPlan.ImageList1.GetBitmap(56, Img);

            TDrawGrid(sender).Canvas.Draw(rect.Left+1,rect.top,Img);
          except
          end;
        end;
      end;
    end
    else
    begin
      if ARow = 0 then
      begin
        StrDes := _(ColumnSetTitle[Acol-FixedCols]);
        FontResize2(TDrawGrid(sender).canvas.font,0 );
        TDrawGrid(sender).canvas.font.Name := 'Montserrat';

        TDrawGrid(sender).Canvas.TextRect(Rect, Rect.left+2, Rect.top, StrDes);
      end else
      begin
        if ARow = TDrawGrid(sender).Row then
          RowIsSelected := true
        else
          RowIsSelected := false;

        DrawDataCell(TDrawGrid(sender), Rect, arow-1, acol- FixedCols , RowIsSelected)
      end
    end;
  end
  else
  begin
    if ARow = 0 then
    begin
      StrDes := _(ColumnSetTitle[Acol]);
      TDrawGrid(sender).Canvas.TextRect(Rect, Rect.left+2, Rect.top+2, StrDes);
    end else
    begin
      if ARow = TDrawGrid(sender).Row then
        RowIsSelected := true
      else
        RowIsSelected := false;
      DrawDataCell(TDrawGrid(sender), Rect, arow-1, acol, RowIsSelected)
    end
  end;

end;

//------------------------------------------------------------------------------

procedure TMSchedListView.DrawSchedDLClick(Sender: TObject);
begin
  DetailSelected;
end;

//------------------------------------------------------------------------------

procedure TMSchedListView.RefreshList;
begin
  if Assigned(m_SchedList) then
    RowCount := m_SchedList.GetLinkCount + 1
end;

//------------------------------------------------------------------------------

function TMSchedListView.GetSelected: TSchedId;
var
  i: integer;
begin
  Result := CSchedIDnull;
  for i := 0 to RowCount-1 do
    if Selected[i] and (m_SchedList.GetLinkCount >0 )then
    begin
      Result := m_SchedList.GetLink(i);
      break;
    end else
      Result := CSchedIDnull;
end;

//------------------------------------------------------------------------------

function TMSchedListView.GetSelectedList: TList;
var
  i: integer;
begin
  Result := TList.Create;
  for i := 0 to RowCount-1 do
    if Selected[i] then
    begin
      if m_SchedList.GetLink(i) <> CSchedIDnull then  // avi
        Result.add(Pointer(m_SchedList.GetLink(i)));
    end;
end;

//------------------------------------------------------------------------------

function TMSchedListView.GetListIds : TList;
var
  I : Integer;
begin
  Result := TList.Create;
  for i := 0 to RowCount-1 do
  begin
    if m_SchedList.GetLink(i) <> CSchedIDnull then  // avi
      Result.add(Pointer(m_SchedList.GetLink(i)));
  end;
end;

//------------------------------------------------------------------------------

procedure TMSchedListView.DetailSelected;
var
  StepDetails : TFStepDetails;
  id:       TSchedID;
begin
  id := GetSelected;
  if id = CSchedIDnull then exit;
  StepDetails := TFStepDetails.CreateStepDetails(Self, TSchedId(id));
  StepDetails.Showmodal;
  StepDetails.Free
end;

//------------------------------------------------------------------------------
end.

