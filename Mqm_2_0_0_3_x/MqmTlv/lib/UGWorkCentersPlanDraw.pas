unit UGWorkCentersPlanDraw;

interface

uses

 ExtCtrls, Classes, Types, Dialogs, Controls, Windows, Graphics, SysUtils, UGSlotCal
 , UGWorkCentersDrawSlot, UGWorkCentersPlanShot, FMBin;

const
  CTimeHgt          = 40;
  CLnCalHdrWidth    = 0;
  CLnWcHdrWidth     = 100 - 2;
  CMinLineHeight    = 65;
  CGrpMinLineHeight = 25;
  CMaxLineHeight    = 250;
  CLineOffst        = 2;
  CMinLineHeightScondLvlCategory = 40;
  CMinLineHeightScondLvlProperty = 28;
  CBarMrg = 4;
  CSlotMrgSup    = 2;
  CSlotMrgInf    = 0;

//type

  procedure DrawABlendSlot(bmp: TBitmap; Canvas: TCanvas; rect: TRect; ds: TDrawSlot; qty, CustQty : Double; UM : String); overload;
  procedure PaintWcSlot(rect: TRect; Canvas: TCanvas; recPaint: TRecDataPaint; qty, CustQty : Double; UM : String);
  procedure PaintWcCategorySlot(rect: TRect; Canvas: TCanvas; recPaint: TRecDataPaint);
  procedure PaintWcPropertySlot(rect: TRect; Canvas: TCanvas; recPaint: TRecDataPaint);
  procedure PaintAlerts(rect: TRect; Canvas: TCanvas; recPaint: TRecDataPaint; ds: TDrawSlot);
  procedure PaintWcGroupSlot(rect: TRect; Canvas: TCanvas; recPaint: TRecDataPaint; qty, CustQty : Double; UM : String);

type

  TDrawType = (DT_OnlyWc, DT_SecondLvl);
  TSlotShowModeFunc = procedure(bmp: TBitmap; Canvas: TCanvas; rect: TRect; ds: TDrawSlot; qty, CustQty : Double; UM : String);

  TLineInfo = class(TObject)
    m_top:      integer;
    m_bottom:   integer;
    m_Left:     integer;
    m_Right:    integer;
    m_shotLine: TPlanLineAbst;
  end;

  TPlanWcView = class(TObject)
  private
    m_ViewModeDraw : TDrawType;
    m_cal:         TSlotCal;
    m_LogoPanel:   TCustomPanel;
    m_timeBox:     TPaintBox;

    m_bmpBkg:      Graphics.TBitMap;

    m_pShot:     TWcPlanShot;
    m_top:       integer;
    m_leftDate:  TDateTime;
    m_rightDate: TDateTime;
    m_lastSlotDate: TDateTime;

    m_lineList: TList;
    m_viewRect: TRect;

    m_lastLine: TPlanLineAbst;

   // m_ilProc:   TInfoLineProc;
   // m_ilObj:    TObject;
  //  m_prdProc:  TInfoPrdProc;
    //m_prdObj:   TObject;
    m_IsScrollBarVisible : boolean;
    m_startSlot, m_endSlot: integer;

  //  m_drawSlot:   TDrawSlot;
    m_selectSlot: TSelectSlot;
    m_isUsaFormat: boolean;


    m_WCbackgroundColor : TColor;
    m_WCbackgroundColor_ReadOnly : TColor;
    m_WorkCenterCategorybackgroundColor : TColor;
    m_WCSlotColor                    : TColor;
    m_TodaySlotColor                 : TColor;
    m_WcPropertyColor                : TColor;
    m_MaterialProductSlotColor       : TColor;
    m_WCGroup : TColor;

    //mihailo
    line: TPlanLineAbst;
    date: TDateTime;
    GoLeft, GoRight : Boolean;
    ScrollStep : Integer;

    function GetUpperLineFromOldLine: TPlanLineAbst;
    function GetLowerLineFromOldLine: TPlanLineAbst;

    procedure PaintTime(Sender: TObject);
    procedure PaintPlan(Sender: TObject);
    procedure ServeMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    function  PaintLine(isGrp: boolean; endl: Boolean; ofst: Integer; pLine: TPlanLineAbst): integer;
    function  PaintGroupLine(isGrp: boolean; endl: Boolean; ofst: integer; pLine: TPlanLineShow): integer;
    procedure ClearLineList;
    function  GetLineFromY(Y: integer): TPlanLineAbst;
    function  GetLineFromYMOuseOver(Y: integer): TPlanLineAbst;
    function  GetSlotFromXPosition(Y: integer; X : integer): TPlanLineAbst;
    function  GetSubLevel(y : integer) : boolean;
    procedure PaintColHdr(rect: TRect; titLong, titMiddle, titShort: string; isToday: Boolean);
    procedure GetSlotLimits(stDate, endDate: TDateTime; out leftLmt, rightLmt: integer);
    procedure DrawHdr(ofst: integer; rect: TRect; pLine: TPlanLineShow);
    procedure HandleDoubleClick(Sender: TObject);
    procedure CheckSelectionForShiftOperation(Line : TPlanLineShow; slot : integer; dtFrom : TDateTime; dtTo : TDateTime);
    procedure HandleMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer) ;
   public

    m_slotShowMode: TSlotShowModeFunc;
    m_PlanControl : pointer;
    m_planBox:     TPaintBox;

    SlotsInRow,LineI : Integer;
    constructor CreateWcPlanView(AOWner, ScrollControl: TWinControl; CalParent : TWinControl; PlanControl : pointer);
    destructor  Destroy; override;
    Procedure   SelectNew(Key : Word);
    function    GetQtyForPrdDailyCap(WkcList : TList; stDate, edDate: TDateTime; out CustQty : Double; out UM : String) : Double;
    procedure   SetTop(top: integer);
    procedure   SetLeftDate(date: TDateTime; prdNum, prdValue: integer);
    function    GetLeftDate: TDateTime;
    function    GetRightDate: TDateTime;
    function    MapDateToPix(date: TDateTime): double;
    function    MapPixToDate(pix: integer): TDateTime;
    procedure   AddLineInfo(viewRect: TRect; psLine: TPlanLineAbst);

    procedure   SetCalendar(cal: TSlotCal);
    procedure   RefreshTime;
    procedure   RefreshPlan(RefreshScrol : boolean);
    procedure   SetABValue(ABValue: integer);
    function    GetViewModeDraw : TDrawType;
    procedure   SetViewModeDraw(DrowType : TDrawType);
    procedure   SetColorWcView(CololWcView : TColorWcView);

    procedure   HandleNotify(chgData: TObject);

    property p_LeftDate: TDateTime    read  m_leftDate;
    property p_RightDate: TDateTime    read  m_rightDate;
    property p_pShot    : TWcPlanShot read m_pShot;
    property p_selectSlot : TSelectSlot read m_selectSlot;
    property p_cal:         TSlotCal read m_cal;
  end;

  const Corner_Radius = 5;



implementation

uses DateUtils, StrUtils, Variants, gnugettext,UGWorkCentersPlanControl, UMSchedContFunc, Math,
     UMGlobal,  DMSrvPC, FMMainPlan, UMWkCtr, UMPlanObj, Forms,
     dxGDIPlusClasses,cxGraphics, dxCoreGraphics;

{ TPlanWcView }

//----------------------------------------------------------------------------//

Procedure TPlanWcView.SelectNew(Key : Word);
var
  ftm : TFMQMPlan;
  Newline: TPlanLineAbst;
  TmpPlanLineShow : TPlanLineShow;
  PlanLineWc : TPlanLineWc;
  Newslot : integer;
  NewlngDsc, NewmidDsc, NewshtDsc : string;
  Newdate,NewdtFrom, NewdtTo: TDateTime;
  SlotType : TSlotType;
  PropCode, PropValue : string;
begin

  if Key = VK_UP then
    NewLine := GetUpperLineFromOldLine
  else if Key = VK_Down then
    NewLine := GetLowerLineFromOldLine
  else
   Newline := Line;

    if Assigned(Newline) and not (Newline = nil) then
    begin
      ftm := GetPlanView;
      if Newline is TPlanLineWc then
        SlotType := Slt_Wc
      else if Newline is TPlanLineSecondLevel then
      begin
        if TPlanLineSecondLevel(Newline).P_SecondLevelType = lvl_property then
          SlotType := Slt_property
        else if TPlanLineSecondLevel(Newline).P_SecondLevelType = Lvl_Wc_category then
          SlotType := slt_Wc_category;
      end;

      if Key = VK_Left then
      begin

        if TPlanWcControl(m_PlanControl).m_cbCal.Text = 'daily' then
          Newdate := IncDay(date,-1);

        if TPlanWcControl(m_PlanControl).m_cbCal.Text = 'weekly' then
          Newdate := IncWeek(date,-1);

        if TPlanWcControl(m_PlanControl).m_cbCal.Text = 'monthly' then
          Newdate := IncMonth(date,-1);

        if today - newDate > 60 then
          NewDate := date;




      end
      else if Key = VK_Right then
      begin
        if TPlanWcControl(m_PlanControl).m_cbCal.Text = 'daily' then
          Newdate := IncDay(date,1);

        if TPlanWcControl(m_PlanControl).m_cbCal.Text = 'weekly' then
          Newdate := IncWeek(date,1);

        if TPlanWcControl(m_PlanControl).m_cbCal.Text = 'monthly' then
          Newdate := IncMonth(date,1);



      end
      else
        Newdate := date;

      Newslot := m_cal.CalcSlotFromDate(Newdate);
      if Newslot >= 0 then
      begin
        m_selectSlot.ClearSelectedList;
        m_cal.GetSlotDataLimits(Newslot, NewdtFrom, NewdtTo, NewlngDsc, NewmidDsc, NewshtDsc);
      end;

      if (SlotType = Slt_Wc) and not m_selectSlot.IsSelectedWc(TPlanLineShow(Newline).P_WcGroup.P_WrkCtr, TPlanLineShow(Newline).m_lineHd, NewdtFrom, NewdtTo, SlotType) then
      begin
        m_selectSlot.AddToSelectedList(TPlanLineShow(Newline).P_WcGroup.P_WrkCtr, TPlanLineShow(Newline).m_lineHd, NewdtFrom, NewdtTo, '', '', SlotType, Newslot, TPlanLineShow(Newline).P_WcGroup.p_PlaceInPlanShotList);
        ftm.m_SelectedListWrkCtrPopUp := m_selectSlot.p_SelectedList;

      end else
      if SlotType = Slt_property then
      begin
        PropCode := TPlanLineShow(Newline).P_WcGroup.p_PropCode;
        PropValue := TPlanLineSecondLevel(TPlanLineShow(Newline)).m_lineHd;
          if not m_selectSlot.IsSelectedPropCodeVal(TPlanLineShow(Newline).P_WcGroup.P_WrkCtr, (TPlanLineShow(Newline).P_WcGroup).P_WrkCtr.p_WrkCtrCode, NewdtFrom, NewdtTo, PropCode, PropValue, SlotType) then
          begin
            m_selectSlot.AddToSelectedList(TPlanLineShow(Newline).P_WcGroup.P_WrkCtr, (TPlanLineShow(Newline).P_WcGroup).P_WrkCtr.p_WrkCtrCode  , NewdtFrom, NewdtTo, PropCode, PropValue, SlotType, Newslot, TPlanLineShow(Newline).P_WcGroup.p_PlaceInPlanShotList);
            ftm.m_SelectedListWrkCtrPopUp := m_selectSlot.p_SelectedList
          end;
      end else
      if SlotType = slt_Wc_category then
      begin
        PropCode := '';
        PropValue := TPlanLineSecondLevel(TPlanLineShow(Newline)).m_lineHd;
          if not m_selectSlot.IsSelectedPropCodeVal(TPlanLineShow(Newline).P_WcGroup.P_WrkCtr, (TPlanLineShow(Newline).P_WcGroup).P_WrkCtr.p_WrkCtrCode, NewdtFrom, NewdtTo, PropCode, PropValue, slt_Wc_category) then
          begin
            m_selectSlot.AddToSelectedList(TPlanLineShow(Newline).P_WcGroup.P_WrkCtr, (TPlanLineShow(Newline).P_WcGroup).P_WrkCtr.p_WrkCtrCode, NewdtFrom, NewdtTo, PropCode, PropValue, slt_Wc_category, Newslot, TPlanLineShow(Newline).P_WcGroup.p_PlaceInPlanShotList);
            ftm.m_SelectedListWrkCtrPopUp := m_selectSlot.p_SelectedList
          end;
      end;

     //   if  MapDateToPix(Newdate) + CLnWcHdrWidth   < CLnWcHdrWidth then
      if (MapDateToPix(Newdate) < CLnWcHdrWidth) then
          TPlanWcControl(m_PlanControl).DTPChange(TPlanWcControl(m_PlanControl).FRightLeftButtons[2]);

      if (MapDateToPix(Newdate) + m_viewRect.Left > ftm.Width - 10) then
          TPlanWcControl(m_PlanControl).DTPChange(TPlanWcControl(m_PlanControl).FRightLeftButtons[3]);

      Line := NewLine;
      date := NewDate;
      RefreshPlan(false);
    end;
end;

procedure TPlanWcView.ClearLineList;
var
  i: integer;
begin
  for i := 0 to m_lineList.Count - 1 do
    TLineInfo(m_lineList[i]).Free;
  m_lineList.Clear;
end;

//----------------------------------------------------------------------------//

function TPlanWcView.GetSubLevel(y : integer) : boolean;
var
  i: integer;
  lInfo: TLineInfo;
begin
  Result := false;
  for i := m_lineList.Count - 1 downto 0 do
  begin
    lInfo := TLineInfo(m_lineList[i]);
    if (Y > lInfo.m_top + 45) and ((Y <= lInfo.m_bottom)) then
    begin
      Result := true;
      Exit;
    end;
  end;
end;

//----------------------------------------------------------------------------//

function TPlanWcView.GetSlotFromXPosition(Y: integer; X : integer): TPlanLineAbst;
var
  i: integer;
  lInfo: TLineInfo;
begin
  Result := nil;
  for i := m_lineList.Count - 1 downto 0 do
  begin
    lInfo := TLineInfo(m_lineList[i]);
    if (Y > lInfo.m_top) and ((Y <= lInfo.m_bottom)) then
    begin
      if (X >= lInfo.m_Left) and (X <= lInfo.m_Right) then
      begin
        Result := lInfo.m_shotLine;
        Exit;
      end;
    end;
  end;

end;

//----------------------------------------------------------------------------//

function TPlanWcView.GetUpperLineFromOldLine: TPlanLineAbst;
var lInfo: TLineInfo;
begin
  Result := nil;

  SlotsInRow := SlotsInRow +1;

  if Linei - SlotsInRow > 0 then
  begin
    lInfo := TLineInfo(m_lineList[Linei - SlotsInRow]);
    LineI := LineI - SlotsInRow;
  end else
  begin
    lInfo := TLineInfo(m_lineList[Linei]);
   // TPlanWcControl(m_PlanControl).P_scroll.VertScrollBar.Position := 0;
  end;

  { if TPlanLineSecondLevel(lInfo.m_shotLine).P_SecondLevelType = lvl_property then
    ScrollStep := 20
   else
    ScrollStep := 35;

    TPlanWcControl(m_PlanControl).P_scroll.VertScrollBar.Position := TPlanWcControl(m_PlanControl).P_scroll.VertScrollBar.Position - ScrollStep;
    }
    Result := lInfo.m_shotLine;
end;

function TPlanWcView.GetLowerLineFromOldLine: TPlanLineAbst;
var lInfo: TLineInfo;
begin
  Result := nil;

  SlotsInRow := SlotsInRow +1;

  if m_lineList.Count > Linei + 1 then
  begin

    if Linei + SlotsInRow >= m_lineList.Count - 1 then
    begin
      lInfo := TLineInfo(m_lineList[m_lineList.Count - 1]);
      LineI := m_lineList.Count - 1;
    end
    else
    begin
      lInfo := TLineInfo(m_lineList[Linei + SlotsInRow]);
      LineI := LineI + SlotsInRow;

     { if TPlanLineSecondLevel(lInfo.m_shotLine).P_SecondLevelType = lvl_property then
        ScrollStep := 20
      else
        ScrollStep := 35;

      TPlanWcControl(m_PlanControl).P_scroll.VertScrollBar.Position := TPlanWcControl(m_PlanControl).P_scroll.VertScrollBar.Position + ScrollStep;
      }
    end;

    Result := lInfo.m_shotLine;
  end;
end;

function TPlanWcView.GetLineFromYMouseOver(Y: integer): TPlanLineAbst;
var
  i: integer;
  lInfo: TLineInfo;
begin
  Result := nil;
  for i := m_lineList.Count - 1 downto 0 do
  begin
    lInfo := TLineInfo(m_lineList[i]);
    if (Y > lInfo.m_top) and ((Y <= lInfo.m_bottom)) then
    begin
      Result := lInfo.m_shotLine;
      Exit;
    end;
  end;
end;

function TPlanWcView.GetLineFromY(Y: integer): TPlanLineAbst;
var
  i: integer;
  lInfo: TLineInfo;
begin
  Result := nil;
  for i := m_lineList.Count - 1 downto 0 do
  begin
    lInfo := TLineInfo(m_lineList[i]);
    if (Y > lInfo.m_top) and ((Y <= lInfo.m_bottom)) then
    begin
      LineI := i;
      Result := lInfo.m_shotLine;
      Exit;
    end;
  end;
end;

//----------------------------------------------------------------------------//

constructor TPlanWcView.CreateWcPlanView(AOWner, ScrollControl: TWinControl; CalParent : TWinControl; PlanControl : pointer);
begin
  m_lastSlotDate := 0;
  inherited Create;
  m_PlanControl := TPlanWcControl(PlanControl);
  m_cal := nil;
  m_IsScrollBarVisible := false;
//  m_drawSlot := TDrawSlot.CreateDrawSlot; // avi - should be fill with colors class (TColorScheme).

  m_selectSlot := TSelectSlot.CreateSelectSlot;
  m_slotShowMode := DrawABlendSlot;

  ScrollControl.DoubleBuffered := true;
  ScrollControl.ControlStyle := [csOpaque];
  CalParent.DoubleBuffered     := true;
  CalParent.ControlStyle := [csOpaque];

  m_planBox := TPaintBox.Create(AOWner);
  m_planBox.Parent := ScrollControl;
  m_planBox.Align  := alClient;
  m_planBox.OnPaint := PaintPlan;
  m_planBox.Color := clGradientInactiveCaption;
  m_planBox.ShowHint := true;
  //m_planBox.CustomHint := FMQMPlan.BalloonHint1;

  m_timeBox := TPaintBox.Create(AOWner);
  m_timeBox.Parent := CalParent;
  m_timeBox.Height := CTimeHgt;
  m_timeBox.Align  := alBottom;
  m_timeBox.OnPaint := PaintTime;
  m_timeBox.Color   := 13499135;

  m_bmpBkg := Graphics.TBitMap.Create;
  m_pShot := TWcPlanShot.Create;

//  if FileExists(s_imgsDir + '\' + s_bkgImgName) then
//    m_bmpBkg.LoadFromFile(s_imgsDir + '\' + s_bkgImgName);

  m_top   := 0;

  m_lineList := TList.Create;

  m_planBox.OnMouseMove := ServeMouseMove;
  m_planBox.OnMouseDown := HandleMouseDown;
  m_planBox.OnDblClick  := HandleDoubleClick;
 // m_planBox.OnKeyPress  := KBMoving;
end;

//----------------------------------------------------------------------------//

destructor TPlanWcView.Destroy;
begin
  m_selectSlot.Free;
  ClearLineList;
  m_lineList.Free;
  inherited;
end;

//----------------------------------------------------------------------------//

function TPlanWcView.GetLeftDate: TDateTime;
begin
  Result := Trunc(m_LeftDate);
end;

//----------------------------------------------------------------------------//

function TPlanWcView.GetRightDate: TDateTime;
begin
  Result := m_rightDate;
end;

//----------------------------------------------------------------------------//

procedure TPlanWcView.GetSlotLimits(stDate, endDate: TDateTime; out leftLmt,
  rightLmt: integer);
begin
  leftLmt  := m_viewRect.Left + Trunc(MapDateToPix(stDate)+1.0);
  rightLmt := m_viewRect.Left + Trunc(MapDateToPix(endDate)-1.0)
end;

//----------------------------------------------------------------------------//

procedure TPlanWcView.DrawHdr(ofst: integer; rect: TRect; pLine: TPlanLineShow);

  procedure DrawSmoothRoundRect(ACanvas: TcxCanvas; const ARect: TRect; AColor, ABkColor: TColor;
    ARadiusX, ARadiusY: Integer; APenWidth: Integer = 1; APenColorAlpha: Byte = 255; ABrushColorAlpha: Byte = 255);
  var
    AGpCanvas: TdxGPCanvas;
  begin
    AGpCanvas := TdxGPCanvas.Create(ACanvas.Handle);
    AGpCanvas.SmoothingMode := smAntiAlias;
    AGpCanvas.EnableAntialiasing(True);
    AGpCanvas.RoundRect(ARect, AColor, ABkColor, ARadiusX, ARadiusY, APenWidth, APenColorAlpha, ABrushColorAlpha);
    AGpCanvas.Free;
  end;

  procedure DrawGradientHdr(const ARect: TRect; ABaseColor: TColor);
  var
    AcxCvs:  TcxCanvas;
    AGpCvs:  TdxGPCanvas;
    AGPBrsh: TdxGPBrush;
    AGPPn:   TdxGPPen;
    clr:     COLORREF;
  begin
    clr     := ColorToRGB(ABaseColor);
    AcxCvs  := TcxCanvas.Create(m_planBox.Canvas);
    AGpCvs  := TdxGPCanvas.Create(AcxCvs.Handle);
    AGpCvs.SmoothingMode := smAntiAlias;
    AGpCvs.EnableAntialiasing(True);
    AGPPn   := TdxGPPen.Create(ABaseColor, 1);
    AGPBrsh := TdxGPBrush.Create;
    try
      AGPBrsh.Style        := gpbsGradient;
      AGPBrsh.GradientMode := gpbgmVertical;
      AGPBrsh.GradientPoints.Add(0.0, dxColorToAlphaColor(
        RGB(Min(255, Integer(GetRValue(clr)) + 20),
            Min(255, Integer(GetGValue(clr)) + 20),
            Min(255, Integer(GetBValue(clr)) + 20)), 255));
      AGPBrsh.GradientPoints.Add(1.0, dxColorToAlphaColor(ABaseColor, 255));
      AGpCvs.RoundRect(ARect, AGPPn, AGPBrsh, Corner_Radius, Corner_Radius);
    finally
      AGPPn.Free;
      AGPBrsh.Free;
      AGpCvs.Free;
      AcxCvs.Free;
    end;
  end;

var
  btmLimit:    integer;
  txtRect :     TRect;
  ts:          TSize;
  str, s, t, PropCode, AddSpace, PropDesc :   string;
  pos, newPos, Leng : integer;
  IsReadOnly : boolean;
  rectSaved : TRect;
  SavedFontSize : Integer;
  cxCanvas : TcxCanvas;
  hdr_Hours_Avail, hdr_Hours_Used : double;
  hdr_errSet : SetOfErrors;
  hdr_HasData : boolean;
  hdr_dtFrom, hdr_dtTo, hdr_startDate, hdr_endDate : TDateTime;
  hdr_lngDsc, hdr_midDsc, hdr_shtDsc : string;
begin

  rect.Top    := rect.Top + CLineOffst;
  rect.Bottom := rect.Bottom + CLineOffst-2;
  btmLimit := rect.Bottom;
  rect.Left   := ofst + 2;
  rect.Right  := CLnWcHdrWidth-1;
  IsReadOnly  := false;
  m_planBox.Canvas.Font.Name := 'Montserrat';

  cxCanvas := TcxCanvas.Create(m_planBox.Canvas);

  if p_pShot.p_SlotGroup = 0 then
    m_WCGroup := RGB(140, 150, 165)       // no grouping — muted gray-blue
  else if p_pShot.p_SlotGroup = 1 then    // WKC Group
    m_WCGroup := RGB(180, 100, 145)        // soft plum/pink
  else if p_pShot.p_SlotGroup = 2 then    // Plant Group
    m_WCGroup := RGB(55, 145, 155)        // teal
  else if p_pShot.p_SlotGroup = 3 then    // Division Group
    m_WCGroup := RGB(120, 80, 170);          // vibrant lavender purple
//  groupData := m_drawSlot.m_cs.FindGroupParms(pLine.p_mainCapGroup,(pLine is TPlanLineSummary));

  m_planBox.Canvas.Pen.Color := Clblack;

  if pLine is TPlanLineWc then    //  clGradientInactiveCaption
    m_planBox.Canvas.Brush.Color := m_WCbackgroundColor  // 9079551//13290186//clgray; // groupData.m_hdrBkColor;
  else if pLine is TPlanLineSecondLevel then
  begin
    if TPlanLineSecondLevel(pLine).P_SecondLevelType = Lvl_Wc_category then
      m_planBox.Canvas.Brush.Color := m_WorkCenterCategorybackgroundColor //  16754342//clGradientInactiveCaption;
    else if TPlanLineSecondLevel(pLine).P_SecondLevelType = lvl_property then
    begin
      m_planBox.Canvas.Brush.Color := m_WcPropertyColor;//  16754342//clGradientInactiveCaption;
      Rect.Left := Rect.Left + CBarMrg;
      Rect.Right := Rect.Right - CBarMrg;
    end;
  end;

  if pLine is TPlanLineWc then    //  clGradientInactiveCaption
  begin

    if (TPlanLineWc(pLine).P_WcGroup).P_WrkCtr.p_ReadOnly then
    begin
      IsReadOnly := true;
      m_planBox.Canvas.pen.color := m_WCbackgroundColor_ReadOnly;
      m_planBox.Canvas.Brush.Color  := m_WCbackgroundColor_ReadOnly;//16751001;
    end
    else
       m_planBox.Canvas.pen.color := m_WCbackgroundColor;

   { if (pLine is TPlanLineWc) and (TPlanLineShow(TPlanLineGroup(pLine)).P_WcGroup.p_numSons > 1) and
       (TPlanLineSecondLevel(TPlanLineShow(TPlanLineGroup(pLine)).P_WcGroup.p_son[1]).P_SecondLevelType = lvl_property) then
      m_planBox.Canvas.Rectangle(rect.Left,rect.Top,rect.Right,rect.Bottom)
    else     }

    DrawGradientHdr(rect, m_planBox.Canvas.Brush.Color);
    //m_planBox.Canvas.Rectangle(rect.Left,rect.Top,rect.Right,rect.Bottom);
    //m_planBox.Canvas.RoundRect(rect.Left,rect.Top,rect.Right,rect.Bottom,10,10);
  end
  else if pLine is TPlanLineWCGroup then
  begin
    m_planBox.Canvas.pen.color := m_WCbackgroundColor;
    m_planBox.Canvas.Brush.Color := m_WCGroup;

    DrawSmoothRoundRect(cxCanvas,
        Rect,  //Rectangle
        m_planBox.Canvas.Brush.Color, //pen color
        m_planBox.Canvas.Brush.Color, //brush color
        Corner_Radius, Corner_Radius, //corner radius
        1, //border width
        255,  //transparent of pen
        255); //transparent of brush

   // m_planBox.Canvas.Rectangle(rect.Left,rect.Top,rect.Right,rect.Bottom);
  end
  else
  begin
    m_planBox.Canvas.RoundRect(rect.Left,rect.Top,rect.Right,rect.Bottom,20,20);
  end;

  if not IsReadOnly then
    m_planBox.Canvas.font.Color := ClWhite;

  // Draw text transparently over the gradient (no solid background behind text)
  SetBkMode(m_planBox.Canvas.Handle, TRANSPARENT);
  m_planBox.Canvas.Brush.Style := bsClear;

 // m_planBox.Canvas.Font.Style := [fsBold];

  rect.Left   := rect.Left + 5;
  rect.Right  := rect.Right - 5;

  ts := m_planBox.Canvas.TextExtent('123');
  txtRect := rect;
  txtRect.Top    := rect.Top+4;
  txtRect.Bottom := txtRect.Top+ts.cy;

  t := '';
  pos := 1;
  repeat
    newPos := PosEx('#13', pLine.m_lineHd, pos);
    s := '';
    if (newPos = 0) then
    begin
      s := RightStr(pLine.m_lineHd, Length(pLine.m_lineHd)-pos+1);
      str := pLine.m_lineDescr;
      if str = '' then str := s;
      pos := newPos
    end
    else
    begin
      str := MidStr(pLine.m_lineHd, pos, newPos-pos);
      if t = '' then t := str;
      pos := newPos + 3
    end;
    if (newPos > 0) or (t <> str) then
    begin
      if IsReadOnly then
         m_planBox.Canvas.Brush.Color := m_WCbackgroundColor_ReadOnly;

      if TPlanLineSecondLevel(pLine).P_SecondLevelType = lvl_property then
      begin
        if Length(s) >= 11 then
          SavedFontSize := 7
        else
          SavedFontSize := m_planBox.Canvas.Font.Size;

        m_planBox.Canvas.Font.Size := SavedFontSize - 1;
      end;

      if pLine is TPlanLineWCGroup then
      begin
        var txtW1: Integer := m_planBox.Canvas.TextWidth(s);
        var boxW1: Integer := Rect.Right - Rect.Left;
        if txtW1 < boxW1 then
          m_planBox.Canvas.TextRect(Rect, Rect.Left + (boxW1 - txtW1) div 2, Rect.Top+10, s)
        else
          m_planBox.Canvas.TextRect(Rect, rect.Left, Rect.Top+10, s);
      end
      else
      begin
        var txtW2: Integer := m_planBox.Canvas.TextWidth(s);
        var boxW2: Integer := txtRect.Right - txtRect.Left;
        if txtW2 < boxW2 then
          m_planBox.Canvas.TextRect(txtRect, txtRect.Left + (boxW2 - txtW2) div 2, txtRect.Top, s)
        else
          m_planBox.Canvas.TextRect(txtRect, rect.Left, txtRect.Top, s);
      end;

      if TPlanLineSecondLevel(pLine).P_SecondLevelType = lvl_property then
        m_planBox.Canvas.Font.Size := SavedFontSize;

      m_planBox.Canvas.Brush.Color := m_WCbackgroundColor;
      txtRect.Top := txtRect.Bottom + 1;
      txtRect.Bottom := txtRect.Top+ts.cy;
    end;
    if (newPos = 0) and (s <> '') and not AnsiEndsStr(s, t) and (TPlanLineSecondLevel(pLine).P_SecondLevelType <> lvl_property) then
    begin
      if IsReadOnly then
         m_planBox.Canvas.Brush.Color := m_WCbackgroundColor_ReadOnly;

      if TPlanLineSecondLevel(pLine).P_SecondLevelType = Lvl_Wc_category then
        m_planBox.Canvas.Brush.Color := m_WorkCenterCategorybackgroundColor;

      if pLine is TPlanLineWCGroup then
        m_planBox.Canvas.Brush.Color := m_WCGroup
      else
      begin
        SavedFontSize := m_planBox.Canvas.Font.Size;
        m_planBox.Canvas.Font.Size := SavedFontSize - 1;

        var txtW3: Integer := m_planBox.Canvas.TextWidth(str);
        var boxW3: Integer := txtRect.Right - txtRect.Left;
        if txtW3 < boxW3 then
          m_planBox.Canvas.TextRect(txtRect, txtRect.Left + (boxW3 - txtW3) div 2, txtRect.Top, str)
        else
          m_planBox.Canvas.TextRect(txtRect, rect.Left, txtRect.Top, str);
        m_planBox.Canvas.Font.Size := SavedFontSize;
      end;

      m_planBox.Canvas.Brush.Color := m_WCbackgroundColor;
      txtRect.Top := txtRect.Bottom + 1;
      txtRect.Bottom := txtRect.Top+ts.cy;
    end;
  until pos = 0;

  // check if this individual WC has any used hours in visible slot range
  hdr_HasData := True;
  if (pLine is TPlanLineWc) and (TPlanLineShow(TPlanLineGroup(pLine)).P_WcGroup.p_numSons > 1)
     and Assigned(TPlanLineShow(TPlanLineGroup(pLine)).P_WcGroup.P_WrkCtr) then
  begin
    hdr_Hours_Used := 0;
    m_cal.GetSlotDataLimits(m_startSlot, hdr_startDate, hdr_dtTo, hdr_lngDsc, hdr_midDsc, hdr_shtDsc);
    m_cal.GetSlotDataLimits(m_endSlot, hdr_dtFrom, hdr_endDate, hdr_lngDsc, hdr_midDsc, hdr_shtDsc);
    TPlanLineShow(TPlanLineGroup(pLine)).P_WcGroup.P_WrkCtr.GetDataForPrdDailyCap(
      hdr_startDate, hdr_endDate, hdr_Hours_Avail, hdr_Hours_Used, hdr_errSet);
    if hdr_Hours_Used <= 0 then
      hdr_HasData := False;
  end;

  if (pLine is TPlanLineWc) and (TPlanLineShow(TPlanLineGroup(pLine)).P_WcGroup.p_numSons > 1) and hdr_HasData then
  begin

    if TPlanLineSecondLevel(TPlanLineShow(TPlanLineGroup(pLine)).P_WcGroup.p_son[1]).P_SecondLevelType = Lvl_Wc_category then
      m_planBox.Canvas.Brush.Color := m_WorkCenterCategorybackgroundColor;
    if TPlanLineSecondLevel(TPlanLineShow(TPlanLineGroup(pLine)).P_WcGroup.p_son[1]).P_SecondLevelType = lvl_property then
      m_planBox.Canvas.Brush.Color := m_WcPropertyColor;

      rectSaved := rect;
    //end
    //else
    if TPlanLineSecondLevel(TPlanLineShow(TPlanLineGroup(pLine)).P_WcGroup.p_son[1]).P_SecondLevelType = lvl_property then
    begin

    //  m_planBox.Canvas.Brush.Color := m_WcPropertyColor; //clwhite; //m_WorkCenterCategorybackgroundColor;
  {    m_planBox.Canvas.Rectangle(rect.Right - rect.left - 70 ,rect.Bottom, rect.Right - 5, rect.Top + 40);
      rect.Left := rect.left + 10;
      rect.Top  := rect.Top + 42;//46;
      rect.Right := rect.Right - 10;//+ 7;
      rect.Bottom := rect.Bottom - 1;
      m_planBox.Canvas.TextRect(rect, rect.Left , rect.Top, 'MYPROP' + '+'); }


{      m_planBox.Canvas.RoundRect(rect.Right - rect.left - 70,rect.Top + 40,rect.Right - 5,rect.Bottom,10,10);
      rect.Left := rect.left + 10;
      rect.Top  := rect.Top + 42;//46;
      rect.Right := rect.Right - 10;//+ 7;
      rect.Bottom := rect.Bottom - 1;
      m_planBox.Canvas.TextRect(rect, rect.Left , rect.Top, 'MYPROP' + '+');  }
      rect := rectSaved;
     // m_planBox.Canvas.RoundRect(rect.Right - rect.left - 80 + 2,rect.Top + 40,rect.Right + 2,rect.Bottom,20,20);
      rect.Left := rect.left - 5 ;//30;
      rect.Top  := rect.Top + 43;
      rect.Right := rect.Right + 2;
      rect.Bottom := rect.Bottom - 5 ;

      PropDesc := TPlanLineShow(TPlanLineGroup(pLine)).P_WcGroup.p_PropDesc;

    //  PropCode := PropCode + AddSpace;
      m_planBox.Canvas.Brush.Color := Cl_STNDRD_LIGHT_BLUE;
      m_planBox.Canvas.Font.Color := clblack;
     // m_planBox.Canvas.Font.size := 8;
      m_planBox.Canvas.Font.Name := 'Montserrat';
      if TPlanLineSecondLevel(TPlanLineShow(TPlanLineGroup(pLine)).P_WcGroup.p_son[1]).p_shownAsSubLevel then
        m_planBox.Canvas.TextRect(rect, rect.Left , rect.Top, PropDesc)
      else
        m_planBox.Canvas.TextRect(rect, rect.Left ,rect.Top, PropDesc);

      AddSpace := '';

      leng := StrToIntDef(PropCode ,0);

      if leng <> 0 then
      begin
        AddSpace := '';
        leng := rect.Right - rect.left - 50 - Length(PropCode);

        for Pos := leng downto 0 do
          AddSpace := AddSpace + ' ';

        PropCode := PropCode + AddSpace;

        if TPlanLineSecondLevel(TPlanLineShow(TPlanLineGroup(pLine)).P_WcGroup.p_son[1]).p_shownAsSubLevel then
        begin
          PropCode := PropCode +  ' --';
         // m_planBox.Canvas.TextRect(rect, rect.Left , rect.Top, PropCode);
        end
        else
        begin
          PropCode := PropCode +  ' +';
         // m_planBox.Canvas.TextRect(rect, rect.Right-rect.Left+1 , rect.Top, PropCode);
        end;
        m_planBox.Canvas.TextRect(rect, rect.Left , rect.Top, PropCode);

      end
      else
      begin

        leng := Length(PropCode);

        if leng < 5 then
        begin
          leng := 5 - leng;
          for pos := 0 to leng do
             AddSpace := AddSpace + '  ';
          PropCode := PropCode + AddSpace;
        end;

      //  if TPlanLineSecondLevel(TPlanLineShow(TPlanLineGroup(pLine)).P_WcGroup.p_son[1]).p_shownAsSubLevel then
      //    m_planBox.Canvas.TextRect(rect, rect.Left , rect.Top, PropCode + '  --')
      //  else
      //    m_planBox.Canvas.TextRect(rect, rect.Left , rect.Top, PropCode + '  +');

      end;

    end;

  end;

  cxCanvas.Free;

  if txtRect.Bottom > btmLimit then exit;

end;

//----------------------------------------------------------------------------//

procedure TPlanWcView.HandleDoubleClick(Sender: TObject);
begin
  if GetPlanView.IsDynamicPlanActiv then exit;
  DMib.m_MainDB.Ping;
  if m_selectSlot.p_SelectedList.Count > 0 then
  begin
    if (PTSelectedParam(m_selectSlot.p_SelectedList[0]).S_TypeSelected = Slt_Wc) and (m_selectSlot.p_SelectedList.Count = 1) then
    begin
      if Assigned(FBin) and DBAppGlobals.MCM_App then
        Fbin.MiSelectedJobOverridingParamsClick(Self);
    end else if PTSelectedParam(m_selectSlot.p_SelectedList[0]).S_TypeSelected = Slt_WcGroup then
    begin
      if Assigned(FBin) and DBAppGlobals.MCM_App then
        Fbin.MiSelectedJobOverridingParamsClick(Self);
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TPlanWcView.HandleMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ftm : TFMQMPlan;
  TmpPlanLineShow : TPlanLineShow;
  PlanLineWc : TPlanLineWc;
  OldSlot,slot,SelectedWcPos : integer;
  I, J, PosInGroupList : integer;
  lngDsc, midDsc, shtDsc : string;
  dtFrom,dtTo: TDateTime;
  SlotType : TSlotType;
  PropCode, PropValue : string;
begin
  DMib.m_MainDB.Ping;
  if ssLeft in Shift then
  begin
    GoLeft := True;
    GoRight := True;

    if Assigned(FBin) then
      FBin.SetFocus;
    FMQMPLan.m_MainX := 1;
    FMQMPLan.Changing := True;

    if (X < CLnWcHdrWidth + 5) then
    begin
      GoLeft := False;
      date := MapPixToDate(X);
      m_selectSlot.ClearSelectedList;

      line := GetLineFromY(Y);
      if TPlanLineShow(line) is TPlanLineWCGroup then
      begin
        // if group has property sub-rows, toggle their visibility
        if TPlanLineShow(line).P_WcGroup.p_numSons > 1 then
        begin
          for i := 1 to TPlanLineShow(line).P_WcGroup.p_numSons - 1 do
            TPlanLineSecondLevel(TPlanLineShow(line).P_WcGroup.p_son[i]).p_shownAsSubLevel :=
              not TPlanLineSecondLevel(TPlanLineShow(line).P_WcGroup.p_son[i]).p_shownAsSubLevel;
        end
        else
        begin
          // no property sub-rows — toggle expand/collapse of individual WCs
          for i := 0 to p_pShot.p_SlotGroup_Lists.Count -1 do
            if TTSlotGrp_WKC(p_pShot.p_SlotGroup_Lists[i]).m_Group = TPlanLineWCGroup(Line).m_Group_name then
              TTSlotGrp_WKC(p_pShot.p_SlotGroup_Lists[i]).m_IsExpanded := not TTSlotGrp_WKC(p_pShot.p_SlotGroup_Lists[i]).m_IsExpanded;
        end;

      end
      else if (TPlanLineShow(line) is TPlanLineWc) and (TPlanLineShow(line).P_WcGroup.p_numSons > 1) then
      begin
        for i := 1 to TPlanLineShow(line).P_WcGroup.p_numSons - 1 do
          TPlanLineSecondLevel(TPlanLineShow(line).P_WcGroup.p_son[I]).p_shownAsSubLevel :=
            not TPlanLineSecondLevel(TPlanLineShow(line).P_WcGroup.p_son[I]).p_shownAsSubLevel;
      end;

      RefreshPlan(false);
      exit;
    end;


    line := GetLineFromY(Y);
    if Assigned(line) then
    begin
      ftm := GetPlanView;
      if line is TPlanLineWc then
        SlotType := Slt_Wc
      else if line is TPlanLineSecondLevel then
      begin
        if TPlanLineSecondLevel(line).P_SecondLevelType = lvl_property then
          SlotType := Slt_property
        else if TPlanLineSecondLevel(line).P_SecondLevelType = Lvl_Wc_category then
          SlotType := slt_Wc_category;
      end else if line is TPlanLineWCGroup then
        SlotType := Slt_WcGroup;

      date := MapPixToDate(X);
      slot := m_cal.CalcSlotFromDate(date);
      if slot >= 0 then
      begin
        if not ((ssCtrl in Shift) or (ssShift in Shift)) then
          m_selectSlot.ClearSelectedList;

        m_cal.GetSlotDataLimits(slot, dtFrom, dtTo, lngDsc, midDsc, shtDsc);
        if (ssShift in Shift) then
        begin
          OldSlot := m_selectSlot.CheckSequenceOnWcForShiftOperation(TPlanLineShow(line).P_WcGroup.P_WrkCtr, TPlanLineShow(line).m_lineHd, SlotType, dtFrom, dtTo, slot);
          if (OldSlot > -1) then
          begin
            if OldSlot < Slot then
            begin
              for I := OldSlot to slot do
              begin
                m_cal.GetSlotDataLimits(I, dtFrom, dtTo, lngDsc, midDsc, shtDsc);
                if not m_selectSlot.IsSelectedWc(TPlanLineShow(line).P_WcGroup.P_WrkCtr, TPlanLineShow(line).m_lineHd, dtFrom, dtTo, SlotType) then
                   m_selectSlot.AddToSelectedList(TPlanLineShow(line).P_WcGroup.P_WrkCtr, TPlanLineShow(line).m_lineHd, dtFrom, dtTo, '', '', SlotType, slot, TPlanLineShow(line).P_WcGroup.p_PlaceInPlanShotList);
              end;
            end;

            if OldSlot > Slot then
            begin
              for I := Slot to Oldslot do
              begin
                m_cal.GetSlotDataLimits(I, dtFrom, dtTo, lngDsc, midDsc, shtDsc);
                if not m_selectSlot.IsSelectedWc(TPlanLineShow(line).P_WcGroup.P_WrkCtr, TPlanLineShow(line).m_lineHd, dtFrom, dtTo, SlotType) then
                   m_selectSlot.AddToSelectedList(TPlanLineShow(line).P_WcGroup.P_WrkCtr, TPlanLineShow(line).m_lineHd, dtFrom, dtTo, '', '', SlotType, slot, TPlanLineShow(line).P_WcGroup.p_PlaceInPlanShotList);
              end;
            end;
            RefreshPlan(false);
          end
          else
          begin
            if TPlanLineShow(line) is TPlanLineWc then
            begin
              {SelectedWcPos := m_selectSlot.CheckSequenceOnDatesForShiftOperation(TPlanLineShow(line).P_WcGroup.P_WrkCtr, SlotType, slot, PosInGroupList);
              if SelectedWcPos > - 1 then
              begin
                if SelectedWcPos < TPlanLineShow(line).P_WcGroup.p_PlaceInPlanShotList then
                begin
                  for i := SelectedWcPos to TPlanLineShow(line).P_WcGroup.p_PlaceInPlanShotList do
                  begin
                    TmpPlanLineShow := TPlanLineShow(TPlanLineGroup(TPlanLineAbst((m_pShot.GetPlanLine(i)))).p_son[0]);
                    m_cal.GetSlotDataLimits(slot, dtFrom, dtTo, lngDsc, midDsc, shtDsc);
                    if not m_selectSlot.IsSelectedWc(TmpPlanLineShow.P_WcGroup.P_WrkCtr, TmpPlanLineShow.m_lineHd, dtFrom, dtTo, SlotType) then
                       m_selectSlot.AddToSelectedList(TmpPlanLineShow.P_WcGroup.P_WrkCtr, TmpPlanLineShow.m_lineHd, dtFrom, dtTo, '', '',SlotType, slot, TmpPlanLineShow.P_WcGroup.p_PlaceInPlanShotList);
                  end;
                end
                else if SelectedWcPos > TPlanLineShow(line).P_WcGroup.p_PlaceInPlanShotList then
                begin
                  for i := TPlanLineShow(line).P_WcGroup.p_PlaceInPlanShotList to SelectedWcPos do
                  begin
                    TmpPlanLineShow := TPlanLineShow(TPlanLineGroup(TPlanLineAbst((m_pShot.GetPlanLine(i)))).p_son[0]);
                    m_cal.GetSlotDataLimits(slot, dtFrom, dtTo, lngDsc, midDsc, shtDsc);
                    if not m_selectSlot.IsSelectedWc(TmpPlanLineShow.P_WcGroup.P_WrkCtr, TmpPlanLineShow.m_lineHd, dtFrom, dtTo, SlotType) then
                       m_selectSlot.AddToSelectedList(TmpPlanLineShow.P_WcGroup.P_WrkCtr, TmpPlanLineShow.m_lineHd, dtFrom, dtTo, '', '', SlotType, slot, TmpPlanLineShow.P_WcGroup.p_PlaceInPlanShotList);
                  end;
                end;
                RefreshPlan(false);
              end; }
            end;
            {else if (line is TPlanLineMaterialProduct) then
            begin

              SelectedWcPos := m_selectSlot.CheckSequenceOnDatesForShiftOperation(TPlanLineShow(line).P_WcGroup.P_WrkCtr, SlotType, slot, PosInGroupList);
              if (SelectedWcPos > - 1) and (SelectedWcPos = TPlanLineShow(line).P_WcGroup.p_PlaceInPlanShotList) then
              begin
                  for i := 1 to TPlanLineShow(line).P_WcGroup.p_numSons - 1 do
                  begin
                    TmpPlanLineShow := TPlanLineShow(line).P_WcGroup.p_son[I];
                    if TPlanLineShow(line).p_PlaceInGroupList < TmpPlanLineShow.p_PlaceInGroupList then
                    begin
                      for I := TPlanLineShow(line).p_PlaceInGroupList to High do



                    end;

                    m_cal.GetSlotDataLimits(slot, dtFrom, dtTo, lngDsc, midDsc, shtDsc);
                    if not m_selectSlot.IsSelected(TmpPlanLineShow.P_WcGroup.P_WrkCtr, TmpPlanLineShow.m_lineHd, dtFrom, dtTo, SlotType) then
                       m_selectSlot.AddToSelectedList(TmpPlanLineShow.P_WcGroup.P_WrkCtr, TmpPlanLineShow.m_lineHd, dtFrom, dtTo, SlotType, slot, TmpPlanLineShow.P_WcGroup.p_PlaceInPlanShotList);
                  end;
              end
              else if SelectedWcPos > TPlanLineShow(line).P_WcGroup.p_PlaceInPlanShotList then
              begin
                for i := TPlanLineShow(line).P_WcGroup.p_PlaceInPlanShotList to SelectedWcPos do
                begin
                  TmpPlanLineShow := TPlanLineShow(TPlanLineGroup(TPlanLineAbst((m_pShot.GetPlanLine(i)))).p_son[0]);
                  m_cal.GetSlotDataLimits(slot, dtFrom, dtTo, lngDsc, midDsc, shtDsc);
                  if not m_selectSlot.IsSelected(TmpPlanLineShow.P_WcGroup.P_WrkCtr, TmpPlanLineShow.m_lineHd, dtFrom, dtTo, SlotType) then
                     m_selectSlot.AddToSelectedList(TmpPlanLineShow.P_WcGroup.P_WrkCtr, TmpPlanLineShow.m_lineHd, dtFrom, dtTo, SlotType, slot, TmpPlanLineShow.P_WcGroup.p_PlaceInPlanShotList);
                end;
              end;

              if SelectedWcPos > -1 then
                RefreshPlan;

            end;  }

          end;
        end
        else
        begin
          m_cal.GetSlotDataLimits(slot, dtFrom, dtTo, lngDsc, midDsc, shtDsc);
          if ssCtrl in Shift then
          begin
            if not m_selectSlot.DeferentWcSelected(TPlanLineShow(line).P_WcGroup.P_WrkCtr) then
            begin
              if (SlotType = Slt_Wc) then
              begin


                if m_selectSlot.IsSelectedWc(TPlanLineShow(line).P_WcGroup.P_WrkCtr, TPlanLineShow(line).m_lineHd, dtFrom, dtTo, SlotType) then
                  m_selectSlot.RemoveSelectedFromList(TPlanLineShow(line).P_WcGroup.P_WrkCtr, TPlanLineShow(line).m_lineHd, dtFrom, dtTo, SlotType)
                else
                begin
                  m_selectSlot.AddToSelectedList(TPlanLineShow(line).P_WcGroup.P_WrkCtr, TPlanLineShow(line).m_lineHd, dtFrom, dtTo, '', '', SlotType, slot, TPlanLineShow(line).P_WcGroup.p_PlaceInPlanShotList);
                  m_selectSlot.RemoveAllIfNotSameType(SlotType)
                end;
              end

              else if SlotType = Slt_property then
              begin
                PropCode := TPlanLineShow(line).P_WcGroup.p_PropCode;
                PropValue := TPlanLineSecondLevel(TPlanLineShow(line)).m_lineHd;
                if m_selectSlot.IsSelectedPropCodeVal(TPlanLineShow(line).P_WcGroup.P_WrkCtr, (TPlanLineShow(line).P_WcGroup).P_WrkCtr.p_WrkCtrCode, dtFrom, dtTo, PropCode, PropValue, SlotType) then
                  m_selectSlot.RemoveSelectedFromList(TPlanLineShow(line).P_WcGroup.P_WrkCtr, (TPlanLineShow(line).P_WcGroup).P_WrkCtr.p_WrkCtrCode  , dtFrom, dtTo, SlotType)
                else
                begin
                  m_selectSlot.AddToSelectedList(TPlanLineShow(line).P_WcGroup.P_WrkCtr, (TPlanLineShow(line).P_WcGroup).P_WrkCtr.p_WrkCtrCode  , dtFrom, dtTo, PropCode, PropValue, SlotType, slot, TPlanLineShow(line).P_WcGroup.p_PlaceInPlanShotList);
                  m_selectSlot.RemoveAllIfNotSameType(SlotType)
                end;
              end
              else if SlotType = slt_Wc_category then
              begin
                PropCode := '';
                PropValue := TPlanLineSecondLevel(TPlanLineShow(line)).m_lineHd;
                if m_selectSlot.IsSelectedPropCodeVal(TPlanLineShow(line).P_WcGroup.P_WrkCtr, (TPlanLineShow(line).P_WcGroup).P_WrkCtr.p_WrkCtrCode, dtFrom, dtTo, PropCode, PropValue, slt_Wc_category) then
                  m_selectSlot.RemoveSelectedFromList(TPlanLineShow(line).P_WcGroup.P_WrkCtr, (TPlanLineShow(line).P_WcGroup).P_WrkCtr.p_WrkCtrCode, dtFrom, dtTo, slt_Wc_category)
                else
                begin
                  m_selectSlot.AddToSelectedList(TPlanLineShow(line).P_WcGroup.P_WrkCtr, (TPlanLineShow(line).P_WcGroup).P_WrkCtr.p_WrkCtrCode, dtFrom, dtTo, PropCode, PropValue, slt_Wc_category, slot, TPlanLineShow(line).P_WcGroup.p_PlaceInPlanShotList);
                  m_selectSlot.RemoveAllIfNotSameType(slt_Wc_category)
                end;
              end;

            end;

          end
          else
          begin
            //if not m_selectSlot.IsSelectedWc(TPlanLineShow(line).P_WcGroup.P_WrkCtr, TPlanLineShow(line).m_lineHd, dtFrom, dtTo, SlotType) then
            //begin
              if (SlotType = Slt_Wc) and not m_selectSlot.IsSelectedWc(TPlanLineShow(line).P_WcGroup.P_WrkCtr, TPlanLineShow(line).m_lineHd, dtFrom, dtTo, SlotType) then
              begin
                m_selectSlot.AddToSelectedList(TPlanLineShow(line).P_WcGroup.P_WrkCtr, TPlanLineShow(line).m_lineHd, dtFrom, dtTo, '', '', SlotType, slot, TPlanLineShow(line).P_WcGroup.p_PlaceInPlanShotList);
                ftm.m_SelectedListWrkCtrPopUp := m_selectSlot.p_SelectedList;
              end
              else
              begin
                if SlotType = Slt_property then
                begin
                  PropCode := TPlanLineShow(line).P_WcGroup.p_PropCode;
                  PropValue := TPlanLineSecondLevel(TPlanLineShow(line)).m_lineHd;
                  if not m_selectSlot.IsSelectedPropCodeVal(TPlanLineShow(line).P_WcGroup.P_WrkCtr, (TPlanLineShow(line).P_WcGroup).P_WrkCtr.p_WrkCtrCode, dtFrom, dtTo, PropCode, PropValue, SlotType) then
                  begin
                    m_selectSlot.AddToSelectedList(TPlanLineShow(line).P_WcGroup.P_WrkCtr, (TPlanLineShow(line).P_WcGroup).P_WrkCtr.p_WrkCtrCode  , dtFrom, dtTo, PropCode, PropValue, SlotType, slot, TPlanLineShow(line).P_WcGroup.p_PlaceInPlanShotList);
                    ftm.m_SelectedListWrkCtrPopUp := m_selectSlot.p_SelectedList
                  end;
                end
                else
                if SlotType = slt_Wc_category then
                begin
                  PropCode := '';
                  PropValue := TPlanLineSecondLevel(TPlanLineShow(line)).m_lineHd;
                  if not m_selectSlot.IsSelectedPropCodeVal(TPlanLineShow(line).P_WcGroup.P_WrkCtr, (TPlanLineShow(line).P_WcGroup).P_WrkCtr.p_WrkCtrCode, dtFrom, dtTo, PropCode, PropValue, slt_Wc_category) then
                  begin
                    m_selectSlot.AddToSelectedList(TPlanLineShow(line).P_WcGroup.P_WrkCtr, (TPlanLineShow(line).P_WcGroup).P_WrkCtr.p_WrkCtrCode, dtFrom, dtTo, PropCode, PropValue, slt_Wc_category, slot, TPlanLineShow(line).P_WcGroup.p_PlaceInPlanShotList);
                    ftm.m_SelectedListWrkCtrPopUp := m_selectSlot.p_SelectedList
                  end;
                end else
                if SlotType = Slt_WcGroup then
                begin
                  for I := 0 to TPlanLineWCGroup(line).m_WC_List.Count - 1 do
                  begin
                    m_selectSlot.AddToSelectedList(TMqmWrkCtr(TPlanLineWCGroup(line).m_WC_List[i]), TPlanLineShow(line).m_lineHd, dtFrom, dtTo, '', '', SlotType, slot, TPlanLineShow(line).P_WcGroup.p_PlaceInPlanShotList);

                  end;

                  ftm.m_SelectedListWrkCtrPopUp := m_selectSlot.p_SelectedList;
                end
              //end;
            //  ftm.m_SelectedListWrkCtrPopUp := m_selectSlot.p_SelectedList;
            end;
            //ftm.m_SelectedListWrkCtrPopUp := m_selectSlot.p_SelectedList;
          end;

          RefreshPlan(false);
        end;
      end;
    end;
  end
  else if ssRight in Shift then
  begin
    line := GetLineFromY(Y);
    if Assigned(line) then
    begin
      if (X <= CLnWcHdrWidth) then  //MAIN WC SLOT(ON LEFT SIDE)
      begin
        if (line is TPlanLineWc) then
        begin
          FMQMPlan.N13.Visible := False;
          FMQMPlan.miExpandallGroup.Visible  := False;
          FMQMPlan.miCollapseallGroup.Visible := False;
          FMQMPlan.IwkcDetails.Visible := True;
          FMQMPlan.IViewAsWorkCnterCategory.Visible := True;
          FMQMPlan.IViewAllAsWorkCnterCategory.Visible := True;
          FMQMPlan.IViewAllWcSecondLvla.Caption := _('All Work center');

          ftm := GetPlanView;
          ftm.m_MqmWrkCtrPopUp := TPlanLineShow(line).P_WcGroup.P_WrkCtr;
          ftm.m_PlanLine := nil;
          ftm.PopupWcLevel.Popup(Mouse.CursorPos.x, Mouse.CursorPos.y);
        end
        else if (line is TPlanLineSecondLevel) and (TPlanLineSecondLevel(line).P_SecondLevelType = Lvl_Wc_category) then
        begin

        end else if line is TPlanLineWCGroup then
        begin
          if TPlanLineWCGroup(line).m_Group_name = 'Summary' then exit;

          FMQMPlan.IViewAsWorkCnterCategory.Visible := False;
          FMQMPlan.IViewAllAsWorkCnterCategory.Visible := False;
          FMQMPlan.N13.Visible := True;
          FMQMPlan.miExpandallGroup.Visible  := True;
          FMQMPlan.miCollapseallGroup.Visible := True;
          FMQMPlan.IwkcDetails.Visible := False;
          FMQMPlan.Iwkc.Caption := TPlanLineWCGroup(line).p_Group_name;
          FMQMPlan.IViewAllWcSecondLvla.Caption := _('All Groups');

          ftm := GetPlanView;
          ftm.m_MqmWrkCtrPopUp := nil;
          ftm.m_PlanLine := line as TPlanLineWCGroup;
          ftm.PopupWcLevel.Popup(Mouse.CursorPos.x, Mouse.CursorPos.y);
        end;


      end
      else  //MCM SLOTS
      begin
        ftm := GetPlanView;
        if line is TPlanLineWc then
          SlotType := Slt_Wc
        else if line is TPlanLineSecondLevel then
        begin
          if TPlanLineSecondLevel(line).P_SecondLevelType = lvl_property then
            SlotType := Slt_property
          else if TPlanLineSecondLevel(line).P_SecondLevelType = Lvl_Wc_category then
            SlotType := slt_Wc_category;
        end else if line is TPlanLineWCGroup then
          SlotType := Slt_WcGroup;

        date := MapPixToDate(X);
        slot := m_cal.CalcSlotFromDate(date);
        if slot >= 0 then
        begin
          m_cal.GetSlotDataLimits(slot, dtFrom, dtTo, lngDsc, midDsc, shtDsc);

          // remember the clicked slot line + date range so "Slot Info" works for
          // every level (WC / WC-Group / Plant / Division / Property / Category)
          ftm.m_MqmSlotInfoLine   := TPlanLineShow(line);
          ftm.m_SlotInfoSlotStart := dtFrom;
          ftm.m_SlotInfoSlotEnd   := dtTo;

          if SlotType = Slt_Wc then
          begin
            if not m_selectSlot.IsSelectedWc(TPlanLineShow(line).P_WcGroup.P_WrkCtr, TPlanLineShow(line).m_lineHd, dtFrom, dtTo, SlotType) then
            begin
               m_selectSlot.ClearSelectedList;
               m_selectSlot.AddToSelectedList(TPlanLineShow(line).P_WcGroup.P_WrkCtr, TPlanLineShow(line).m_lineHd, dtFrom, dtTo, '', '', SlotType, slot, TPlanLineShow(line).P_WcGroup.p_PlaceInPlanShotList);
               RefreshPlan(false);
            end;
            ftm.PopupWcSlot.Popup(Mouse.CursorPos.x, Mouse.CursorPos.y);
          end

          else if SlotType = Slt_property then
          begin

            PropCode := TPlanLineShow(line).P_WcGroup.p_PropCode;
            PropValue := TPlanLineSecondLevel(TPlanLineShow(line)).m_lineHd;
            if not m_selectSlot.IsSelectedPropCodeVal(TPlanLineShow(line).P_WcGroup.P_WrkCtr, (TPlanLineShow(line).P_WcGroup).P_WrkCtr.p_WrkCtrCode, dtFrom, dtTo, PropCode, PropValue, SlotType) then
            begin
              m_selectSlot.ClearSelectedList;
              m_selectSlot.AddToSelectedList(TPlanLineShow(line).P_WcGroup.P_WrkCtr, (TPlanLineShow(line).P_WcGroup).P_WrkCtr.p_WrkCtrCode  , dtFrom, dtTo, PropCode, PropValue, SlotType, slot, TPlanLineShow(line).P_WcGroup.p_PlaceInPlanShotList);
              RefreshPlan(false)
            end;
            ftm.PopupPropertySlot.Popup(Mouse.CursorPos.x, Mouse.CursorPos.y);
          end
          else if SlotType = slt_Wc_category then
          begin
            PropCode := '';
            PropValue := TPlanLineSecondLevel(TPlanLineShow(line)).m_lineHd;
            if not m_selectSlot.IsSelectedPropCodeVal(TPlanLineShow(line).P_WcGroup.P_WrkCtr, (TPlanLineShow(line).P_WcGroup).P_WrkCtr.p_WrkCtrCode, dtFrom, dtTo, PropCode, PropValue, slt_Wc_category) then
            begin
              m_selectSlot.ClearSelectedList;
              m_selectSlot.AddToSelectedList(TPlanLineShow(line).P_WcGroup.P_WrkCtr, (TPlanLineShow(line).P_WcGroup).P_WrkCtr.p_WrkCtrCode, dtFrom, dtTo, PropCode, PropValue, slt_Wc_category, slot, TPlanLineShow(line).P_WcGroup.p_PlaceInPlanShotList);
              RefreshPlan(false)
            end;
            ftm.m_SelectedListWrkCtrPopUp := m_selectSlot.p_SelectedList;
            if m_selectSlot.p_SelectedList.Count > 0 then
              PTSelectedParam(m_selectSlot.p_SelectedList[0]).S_lngDscSlot := lngDsc;
            ftm.PopupPropertySlot.Popup(Mouse.CursorPos.x, Mouse.CursorPos.y);
          end
          else if SlotType = Slt_WcGroup then
          begin
            if TPlanLineWCGroup(line).m_Group_name = 'Summary' then exit;

            ftm.m_SelectedListWrkCtrPopUp := m_selectSlot.p_SelectedList;
            if m_selectSlot.p_SelectedList.Count > 0 then
              PTSelectedParam(m_selectSlot.p_SelectedList[0]).S_lngDscSlot := lngDsc;

            ftm.PopupWcGrpSlot.Popup(Mouse.CursorPos.x, Mouse.CursorPos.y);
          end;

         //
        end;
      end;
    end;
  end
end;

//----------------------------------------------------------------------------//

procedure TPlanWcView.CheckSelectionForShiftOperation(Line : TPlanLineShow; slot : integer; dtFrom : TDateTime; dtTo : TDateTime);
begin

end;

//----------------------------------------------------------------------------//

procedure TPlanWcView.HandleNotify(chgData: TObject);
begin

end;

//----------------------------------------------------------------------------//

function TPlanWcView.MapDateToPix(date: TDateTime): double;
begin
  Result := (date - m_leftDate)/(m_rightDate-m_leftDate)*(m_viewRect.Right-m_viewRect.Left+1);
end;

//----------------------------------------------------------------------------//

function TPlanWcView.MapPixToDate(pix: integer): TDateTime;
begin
  Result := m_leftDate+(pix-m_viewRect.Left)/(m_viewRect.Right-m_viewRect.Left+1)*(m_rightDate-m_leftDate);
end;

//----------------------------------------------------------------------------//

procedure TPlanWcView.AddLineInfo(viewRect: TRect; psLine: TPlanLineAbst);
var
  lInfo: TLineInfo;
begin
  lInfo := TLineInfo.Create;
  lInfo.m_top      := viewRect.Top;
  lInfo.m_bottom   := viewRect.Bottom;
  lInfo.m_Left     := viewRect.Left;
  lInfo.m_Right    := viewRect.Right;
  lInfo.m_shotLine := psLine;
  m_lineList.Add(lInfo);

end;

//----------------------------------------------------------------------------//

procedure TPlanWcView.PaintColHdr(rect: TRect; titLong, titMiddle,
  titShort: string; isToday: Boolean);
var
  size:     tagSIZE;
  hdrWidth: integer;
  ptyRect:  TRect;
begin
  if not Assigned(m_cal) then exit;

  m_timeBox.Canvas.Pen.Color   := clwhite;//clGrayText;//ClWhite;//m_WCSlotColor;//ClWhite;

  if not isToday then
    m_timeBox.Canvas.Brush.Color := m_WCSlotColor//32896;  // DBAppGlobals.JobToJobCompColor[5].int
  else
    m_timeBox.Canvas.Brush.Color := m_TodaySlotColor; //DBAppGlobals.JobToJobCompColor[6].int;//clgreen;//clRed;  //

  m_timeBox.Canvas.Font.Color  := clBlack; //ClWhite;

  m_timeBox.Canvas.RoundRect( rect.Left, rect.Top, rect.Right, rect.Bottom, 3, 3 );

{  if rect.Left < m_viewRect.Left then
  begin
    ptyRect := rect;
    ptyRect.Left := 0;
    ptyRect.Right := m_viewRect.Left;
    m_timeBox.Canvas.Brush.Color := ClWhite; //m_drawSlot.m_cs.m_planBack;
    m_timeBox.Canvas.FillRect( ptyRect );
    m_timeBox.Canvas.Brush.Color := clGreen;//m_drawSlot.m_cs.m_calHdrBack;
  end; }

  hdrWidth := rect.Right - rect.Left - 1;
  size := m_timeBox.Canvas.TextExtent( titLong );
  rect.Top := rect.Top + Trunc((rect.Bottom-rect.Top-size.cy)/2);
  if size.cx < hdrWidth then
    m_timeBox.Canvas.TextOut(rect.Left+Trunc((hdrWidth - size.cx)/2), rect.Top, titLong)
  else
  begin
    size := m_timeBox.Canvas.TextExtent( titMiddle );
    if size.cx < hdrWidth then
      m_timeBox.Canvas.TextOut(rect.Left+Trunc((hdrWidth - size.cx)/2), rect.Top, titMiddle)
    else
    begin
      size := m_timeBox.Canvas.TextExtent( titShort );
      if size.cx < hdrWidth then
        m_timeBox.Canvas.TextOut(rect.Left+Trunc((hdrWidth - size.cx)/2), rect.Top, titShort)
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TPlanWcView.PaintPlan(Sender: TObject);
var
  step, i,y:  integer;
  leftLmt, rightLmt: integer;
  dtFrom,dtTo: TDateTime;
  lngDsc, midDsc, shtDsc: string;
  ImgXPos, ImgYPos: integer;
  startDate, endDate: TDateTime;
  DrawSlot : TDrawSlot;
  cd: TSlotData;
  qty, customqty : Double;
  UM : String;
  bmp : graphics.TBitmap;
  rect : TRect;
  PlanLineGroup : TPlanLineAbst;
  PlanLine : TPlanLineShow;
  sum_Hours_Available, sum_Hours_Used, sum_Hours_wc : Double;
  SlotGrpWC: TTSlotGrp_WKC;
  GroupHasProperty: Boolean;
begin
  if not Assigned(m_cal) then exit;
  try
    m_planBox.Canvas.TryLock;
  ClearLineList;

  m_lastLine := nil;

  SlotsInRow := 0;
  GroupHasProperty := False;

  m_planBox.Canvas.Brush.Color := clWhite;//m_drawSlot.m_cs.m_planBack;
  m_planBox.Canvas.FillRect(m_planBox.Canvas.ClipRect);

  if not Assigned(m_pShot) or (m_pShot.GetNumLines = 0) then exit;

  SlotGrpWC := nil;
  step := Round(m_planBox.Height / m_pShot.GetNumLines);
  if step < CMinLineHeight then step := CMinLineHeight;
  if step > CMaxLineHeight then step := CMaxLineHeight;

  m_viewRect.Top    := 0;
  m_viewRect.Left   := CLnWcHdrWidth;
  m_viewRect.Right  := m_planBox.Width - 3;
  m_viewRect.Bottom := m_viewRect.Top + step - 1;

  m_cal.GetSlotDataLimits(m_startSlot,startDate,dtTo, lngDsc, midDsc, shtDsc);
  m_cal.GetSlotDataLimits(m_endSlot,dtFrom,endDate, lngDsc, midDsc, shtDsc);


    for i := m_top to m_pShot.GetNumLines - 1 do  //number of rows
    begin
      if DBAppGlobals.MCM_App  then
      begin

        if (m_pShot.p_SlotGroup = 0) or (m_pShot.p_SlotGroup_Lists.Count = 0) then
        begin
           PaintLine(false, true, 0, m_pShot.GetPlanLine(i));
           // m_viewRect.Top  := m_viewRect.Top + PaintLine(false, true, 0, m_pShot.GetPlanLine(i));
            if m_viewRect.Top > m_planBox.Height then break;
            m_viewRect.Bottom := m_viewRect.Top + step - 1;
        end else
        begin

          for y := 0 to m_pShot.p_SlotGroup_Lists.Count -1 do
            if TPlanLineWCGroup(TPlanLineShow(TPlanLineGroup(m_pShot.GetPlanLine(i)).p_son[0])).p_Group_name = TTSlotGrp_WKC(m_pShot.p_SlotGroup_Lists[y]).m_Group then
            begin
              SlotGrpWC := TTSlotGrp_WKC(m_pShot.p_SlotGroup_Lists[y]);
              break;
            end;

          var IsGrp := TPlanLineShow(TPlanLineGroup(m_pShot.GetPlanLine(i)).p_son[0]).ClassName = 'TPlanLineWCGroup';

          // when group has property/category sub-rows, hide individual WC rows
          if IsGrp then
            GroupHasProperty := TPlanLineGroup(m_pShot.GetPlanLine(i)).p_SecondLevelType <> Lvl_non;

          if IsGrp or ((not GroupHasProperty) and Assigned(SlotGrpWC) and SlotGrpWC.m_IsExpanded) then
          begin
            PaintLine(false, true, 0, m_pShot.GetPlanLine(i));
           // m_viewRect.Top  := m_viewRect.Top + PaintLine(false, true, 0, m_pShot.GetPlanLine(i));
            if m_viewRect.Top > m_planBox.Height then break;
            m_viewRect.Bottom := m_viewRect.Top + step - 1;
          end;
        end;

      end else
      begin
        PaintLine(false, true, 0, m_pShot.GetPlanLine(i));
         // m_viewRect.Top  := m_viewRect.Top + PaintLine(false, true, 0, m_pShot.GetPlanLine(i));
        if m_viewRect.Top > m_planBox.Height then break;
        m_viewRect.Bottom := m_viewRect.Top + step - 1;
      end;

    end;

    m_planBox.Canvas.Pen.Style := psSolid; //psDash;
    m_planBox.Canvas.Pen.Color := $00EBE8E4;//clBlack;//m_drawSlot.m_cs.m_vertLine;
    m_planBox.Canvas.Brush.Color := ClBlack;//m_drawSlot.m_cs.m_planBack;

  for i := m_startSlot to m_endSlot do
  begin
    m_cal.GetSlotDataLimits(i,dtFrom,dtTo,lngDsc, midDsc, shtDsc);
    GetSlotLimits(dtFrom, dtTo, leftLmt, rightLmt);
    m_planBox.Canvas.MoveTo(rightLmt + 2,0);
    m_planBox.Canvas.LineTo(rightLmt + 2,m_planBox.Height);
  end;

    SlotsInRow := m_endSlot - m_startSlot;
    m_planBox.Canvas.Pen.Style := psSolid;

  finally
     m_planBox.Canvas.Unlock;
  end;

  if m_IsScrollBarVisible <> TPlanWcControl(m_PlanControl).P_scroll.VertScrollBar.IsScrollBarVisible then
    PaintTime(self);
  m_IsScrollBarVisible := TPlanWcControl(m_PlanControl).P_scroll.VertScrollBar.IsScrollBarVisible;

end;

//----------------------------------------------------------------------------//

procedure TPlanWcView.PaintTime(Sender: TObject);
var
  rect: TRect;
  i: integer;
  leftLmt, rightLmt: integer;
  dtFrom,dtTo: TDateTime;
  lngDsc, midDsc, shtDsc, str : string;
begin

  if not assigned(m_cal) then exit;

  m_timeBox.Canvas.Brush.Color := $00EBE8E4;//Clgray;
  m_timeBox.Canvas.FillRect(m_timeBox.ClientRect);

  rect.Top := 0; //3
  rect.Bottom := m_timeBox.ClientRect.Bottom;// - 4;

  m_viewRect.Top    := 0;
  m_viewRect.Left   := CLnCalHdrWidth;

  if TPlanWcControl(m_PlanControl).P_scroll.VertScrollBar.IsScrollBarVisible then
    m_viewRect.Right  := m_timeBox.Width - 20  // -20 for plan scrollbar width
  else
    m_viewRect.Right  := m_timeBox.Width;

  m_viewRect.Bottom := m_timeBox.ClientRect.Bottom - 4;

  for i := m_startSlot to m_endSlot do
  begin

    m_cal.GetSlotDataLimits(i,dtFrom,dtTo,lngDsc, midDsc, shtDsc);
    GetSlotLimits(dtFrom, dtTo, leftLmt, rightLmt);
    if leftLmt < CLnCalHdrWidth then
      rect.Left := CLnCalHdrWidth
    else
      rect.Left := leftLmt - 1;  //+ 3;
    rect.Right := rightLmt + 2; //- 3;

    str := lngDsc;

    if m_cal.GetCode = 'CL_WEEKLY' then begin
      lngDsc := _('Week') + ' ' + IntToStr(WeekOf(dtFrom)) + ' (';
      if m_isUsaFormat then                      // avi dtTo - 1
        //lngDsc := lngDsc + FormatDateTime('mm/dd/yyyy', dtTo - 1) + ')'
         lngDsc := lngDsc + DateTimeToStr(dtTo - 1)
      else lngDsc := lngDsc + FormatDateTime('dd.mm.yyyy', dtTo - 1) + ')'; // dtTo - 1
    end;

  {  if (Today >= Trunc(dtFrom)) and (Today <= Trunc(dtTo)) then
      PaintColHdr(rect, lngDsc, midDsc, shtDsc, true)
    else
      PaintColHdr(rect, lngDsc, midDsc, shtDsc, false);  }


    if (m_cal.GetCode = 'CL_DAILY') then
    begin
      if (Today = Trunc(dtFrom)) then
        PaintColHdr(rect, lngDsc, midDsc, shtDsc, true)
      else
        PaintColHdr(rect, lngDsc, midDsc, shtDsc, false)
    end

   { else if (m_cal.GetCode = 'CL_WEEKLY') or (m_cal.GetCode = 'CL_MONTHLY') then
    begin
      if (Today = Trunc(dtFrom)) then
        PaintColHdr(rect, lngDsc, midDsc, shtDsc, true)
      else
        PaintColHdr(rect, lngDsc, midDsc, shtDsc, false);
    end  }

    else if (m_cal.GetCode = 'CL_WEEKLY') or (m_cal.GetCode = 'CL_MONTHLY') then
    begin
      if (Today >= Trunc(dtFrom)) and (Today < Trunc(dtTo)) then
        PaintColHdr(rect, lngDsc, midDsc, shtDsc, true)
      else
        PaintColHdr(rect, lngDsc, midDsc, shtDsc, false);
    end;


    lngDsc := str;
  end;

end;

//----------------------------------------------------------------------------//

procedure TPlanWcView.SetCalendar(cal: TSlotCal);
begin
  m_cal := cal;
end;

//----------------------------------------------------------------------------//

procedure TPlanWcView.RefreshTime;
begin
  m_timeBox.Invalidate;
  m_timeBox.Refresh;
end;

//----------------------------------------------------------------------------//

procedure TPlanWcView.RefreshPlan(RefreshScrol : boolean);
begin
  if RefreshScrol then
    TPlanWcControl(m_PlanControl).SetScrolZise;
  m_planBox.Invalidate;
  m_planBox.Refresh;
end;

//----------------------------------------------------------------------------//

procedure TPlanWcView.ServeMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  line : TPlanLineAbst;
  date: TDateTime;
  slot, i : Integer;
  lngDsc, midDsc, shtDsc : string;
  dtFrom,dtTo: TDateTime;
  Qty,aRealPerc, sumaRealPerc, SumQty : double;
  StrHintWcSlot : string;
  NumJobsLateWc, MaxDaysInLateWc, NumJobsMaterialProblemWc, NumJobsAddresProblemWc ,
  SumNumJobsLateWc, SumMaxDaysInLateWc, SumNumJobsMaterialProblemWc, SumNumJobsAddresProblemWc: Integer;
  ErrSet: SetOfErrors;
begin
  m_planBox.ShowHint := False;

  if (X < CLnWcHdrWidth + 5) and (X > CLnWcHdrWidth - 10) and GetSubLevel(y) then
  begin
    line := GetLineFromYMOuseover(Y);
    if (TPlanLineShow(line) is TPlanLineWc) and (TPlanLineShow(line).P_WcGroup.p_numSons > 1) then
    begin
      m_planBox.ShowHint := true;
     // m_planBox.CustomHint := FMQMPlan.BalloonHint1;
      if TPlanLineSecondLevel(TPlanLineShow(line).P_WcGroup.p_son[1]).p_shownAsSubLevel then
        m_planBox.Hint := 'Close'
      else
        m_planBox.Hint := 'Show details';
    end;
    exit;
  end
  else if (X < CLnWcHdrWidth - 10) and (X > CLnWcHdrWidth - 70) and GetSubLevel(y) then
  begin
    line := GetLineFromYMOuseOver(Y);
    if (TPlanLineShow(line) is TPlanLineWc) and (TPlanLineShow(line).P_WcGroup.p_numSons > 1)
        and (TPlanLineSecondLevel(TPlanLineShow(line).P_WcGroup.p_son[1]).P_SecondLevelType = lvl_property) then
    begin
      m_planBox.ShowHint := true;
     // m_planBox.CustomHint := FMQMPlan.BalloonHint1;
      m_planBox.Hint := TPlanLineGroup(TPlanLineShow(line).P_WcGroup).p_PropDesc;
    end;
    exit;
  end else if (X < CLnWcHdrWidth + 5) then
  begin

    line := GetLineFromY(Y);


    if TPlanLineShow(line) is TPlanLineWCGroup then
    begin
      if TPlanLineWCGroup(line).m_Group_name = 'Summary' then exit;

      Screen.Cursor := crHandPoint;

      // show property description as hint on WCGroup header
      if Assigned(TPlanLineShow(line).P_WcGroup) and
         (TPlanLineShow(line).P_WcGroup.p_PropDesc <> '') then
      begin
        m_planBox.ShowHint := True;
        m_planBox.Hint := 'Property: ' + TPlanLineShow(line).P_WcGroup.p_PropDesc;
      end;
    end
    else if (TPlanLineShow(line) is TPlanLineWc) and (TPlanLineShow(line).P_WcGroup.p_numSons > 1) then
      Screen.Cursor := crHandPoint
    else
      Screen.Cursor := crDefault;

    exit;
  end;
  m_planBox.ShowHint := False;


  //////////////////////////////////////////////
  Screen.Cursor := crDefault;

  line := GetLineFromYMOuseOver(Y);
  if Assigned(line) then
  begin
    if GetSlotFromXPosition(Y, X) = nil then
    begin
      m_planBox.ShowHint := False;

      exit
    end;

    try
      if (X > CLnWcHdrWidth + 5) and (line is TPlanLineWc)then
      begin
        date := MapPixToDate(X);
        slot := m_cal.CalcSlotFromDate(date);
        if slot >= 0 then
        begin
          m_cal.GetSlotDataLimits(slot, dtFrom, dtTo, lngDsc, midDsc, shtDsc);
          TPlanLineShow(line).P_WcGroup.P_WrkCtr.GetHintDataForPrdDailyCap(dtFrom, dtTo - 1/24/3600, Qty, NumJobsLateWc, MaxDaysInLateWc, NumJobsMaterialProblemWc, NumJobsAddresProblemWc, aRealPerc);

          m_planBox.ShowHint := true;
         // m_planBox.CustomHint := FMQMPlan.BalloonHint1;
          StrHintWcSlot := 'Quantity : ' + FloatToStr(qty);
          if NumJobsLateWc > 0 then
            StrHintWcSlot := StrHintWcSlot + #13#10 + 'Number of jobs in late : ' + IntToStr(NumJobsLateWc);
     //     if MaxDaysInLateWc > 0 then
     //       StrHintWcSlot := StrHintWcSlot + #13#10 + 'Max Days in late ' + IntToStr(MaxDaysInLateWc) + #13#10 +
          if NumJobsMaterialProblemWc > 0 then
            StrHintWcSlot := StrHintWcSlot + #13#10 + 'Number of jobs in with material problem : ' + IntToStr(NumJobsMaterialProblemWc);
          if NumJobsMaterialProblemWc > 0 then
            StrHintWcSlot := StrHintWcSlot + #13#10 + 'Number of jobs in with additional resource problem : ' + IntToStr(NumJobsMaterialProblemWc);

          //Mihailo
          if aRealPerc > 100 then
            StrHintWcSlot := StrHintWcSlot + #13#10 + 'Over Capacity: ' +FloatToStr(SimpleRoundTo(aRealPerc) - 100)  + '%';

          m_planBox.Hint := StrHintWcSlot;

          if DBAppGlobals.MCM_App then
            Screen.Cursor := crHandPoint;

          exit;
        end;
      end else
      if (X > CLnWcHdrWidth + 5) and (line is TPlanLineSecondLevel)
         and (TPlanLineSecondLevel(line).P_SecondLevelType in [lvl_property, Lvl_Wc_category]) then
      begin
        date := MapPixToDate(X);
        slot := m_cal.CalcSlotFromDate(date);
        if slot >= 0 then
        begin
          m_cal.GetSlotDataLimits(slot, dtFrom, dtTo, lngDsc, midDsc, shtDsc);
          if Assigned(TPlanLineShow(line).P_WcGroup) and Assigned(TPlanLineShow(line).P_WcGroup.P_WrkCtr) then
          begin
            if TPlanLineSecondLevel(line).P_SecondLevelType = lvl_property then
              TPlanLineShow(line).P_WcGroup.P_WrkCtr.GetHintDataForPrdDailyPropertyCap(
                TPlanLineSecondLevel(line).m_lineHd,
                dtFrom, dtTo - 1/24/3600, Qty, NumJobsLateWc, MaxDaysInLateWc, NumJobsMaterialProblemWc, NumJobsAddresProblemWc, aRealPerc)
            else
              TPlanLineShow(line).P_WcGroup.P_WrkCtr.GetHintDataForPrdDailyCategoryCap(
                TPlanLineSecondLevel(line).m_lineHd,
                dtFrom, dtTo - 1/24/3600, Qty, NumJobsLateWc, MaxDaysInLateWc, NumJobsMaterialProblemWc, NumJobsAddresProblemWc, aRealPerc);

            m_planBox.ShowHint := True;
            StrHintWcSlot := 'Quantity : ' + FloatToStr(qty);
            if NumJobsLateWc > 0 then
              StrHintWcSlot := StrHintWcSlot + #13#10 + 'Number of jobs in late : ' + IntToStr(NumJobsLateWc);
            if NumJobsMaterialProblemWc > 0 then
              StrHintWcSlot := StrHintWcSlot + #13#10 + 'Number of jobs in with material problem : ' + IntToStr(NumJobsMaterialProblemWc);
            if NumJobsAddresProblemWc > 0 then
              StrHintWcSlot := StrHintWcSlot + #13#10 + 'Number of jobs in with additional resource problem : ' + IntToStr(NumJobsAddresProblemWc);
            if aRealPerc > 100 then
              StrHintWcSlot := StrHintWcSlot + #13#10 + 'Over Capacity: ' + FloatToStr(SimpleRoundTo(aRealPerc) - 100) + '%'
            else if aRealPerc > 0 then
              StrHintWcSlot := StrHintWcSlot + #13#10 + 'Capacity: ' + FloatToStr(SimpleRoundTo(aRealPerc)) + '%';
            m_planBox.Hint := StrHintWcSlot;
            exit;
          end;
        end;
      end else
      if (X > CLnWcHdrWidth + 5) and (line is TPlanLineWCGroup) then
      begin
        date := MapPixToDate(X);
        slot := m_cal.CalcSlotFromDate(date);
        if slot >= 0 then
        begin
          if TPlanLineWCGroup(line).m_lineHd = _('Summary') then exit;

          if DBAppGlobals.MCM_App then
            Screen.Cursor := crHandPoint;

          m_planBox.ShowHint := true;
          SumNumJobsLateWc := 0;
          SumNumJobsMaterialProblemWc := 0;
          SumQty := 0;

          for i := 0 to  TPlanLineWCGroup(line).m_WC_List.Count - 1 do
          begin
            m_cal.GetSlotDataLimits(slot, dtFrom, dtTo, lngDsc, midDsc, shtDsc);
            TMqmWrkCtr(TPlanLineWCGroup(line).m_WC_List[i]).GetHintDataForPrdDailyCap(dtFrom, dtTo - 1/24/3600, Qty, NumJobsLateWc, MaxDaysInLateWc, NumJobsMaterialProblemWc, NumJobsAddresProblemWc, aRealPerc);
            SumQty := SumQty + Qty;
            SumNumJobsLateWc := SumNumJobsLateWc + NumJobsLateWc;
            SumNumJobsMaterialProblemWc := SumNumJobsMaterialProblemWc + NumJobsMaterialProblemWc;
          end;

          StrHintWcSlot := 'Quantity : ' + FloatToStr(SumQty);

          if SumNumJobsLateWc > 0 then
            StrHintWcSlot := StrHintWcSlot + #13#10 + 'Number of jobs in late : ' + IntToStr(SumNumJobsLateWc);

          if SumNumJobsMaterialProblemWc > 0 then
            StrHintWcSlot := StrHintWcSlot + #13#10 + 'Number of jobs in with material problem : ' + IntToStr(SumNumJobsMaterialProblemWc);
          if SumNumJobsMaterialProblemWc > 0 then
            StrHintWcSlot := StrHintWcSlot + #13#10 + 'Number of jobs in with additional resource problem : ' + IntToStr(SumNumJobsMaterialProblemWc);

          //Mihailo
         { if aRealPerc > 100 then
            StrHintWcSlot := StrHintWcSlot + #13#10 + 'Over Capacity: ' +FloatToStr(SimpleRoundTo(aRealPerc) - 100)  + '%'; }


          m_planBox.Hint := StrHintWcSlot;

          exit;

        end;
      end;
    except
    end;
  end;
  m_planBox.ShowHint := False;

end;

//----------------------------------------------------------------------------//

function TPlanWcView.PaintLine(isGrp: boolean; endl: Boolean; ofst: Integer; pLine: TPlanLineAbst): integer;
var
  I : Integer;
  LineSecondLevel : TPlanLineSecondLevel;
   LineShow : TPlanLineShow;
  SkipSubRows : Boolean;
  SkipThisSubRow : Boolean;
  chk_Hours_Avail, chk_Hours_Used : double;
  chk_errSet : SetOfErrors;
  chk_startDate, chk_endDate, chk_dtFrom, chk_dtTo : TDateTime;
  chk_lngDsc, chk_midDsc, chk_shtDsc : string;
begin

  if pLine is TPlanLineGroup then
  begin
    // for individual WCs (not WCGroup headers), skip sub-rows if WC has no used hours in visible range
    SkipSubRows := False;
    if (TPlanLineGroup(pLine).p_numSons > 1) and
       (TPlanLineGroup(pLine).p_son[0] is TPlanLineWc) and
       Assigned(TPlanLineGroup(pLine).P_WrkCtr) then
    begin
      chk_Hours_Used := 0;
      m_cal.GetSlotDataLimits(m_startSlot, chk_startDate, chk_dtTo, chk_lngDsc, chk_midDsc, chk_shtDsc);
      m_cal.GetSlotDataLimits(m_endSlot, chk_dtFrom, chk_endDate, chk_lngDsc, chk_midDsc, chk_shtDsc);
      TPlanLineGroup(pLine).P_WrkCtr.GetDataForPrdDailyCap(
        chk_startDate, chk_endDate, chk_Hours_Avail, chk_Hours_Used, chk_errSet);
      if chk_Hours_Used <= 0 then
        SkipSubRows := True;
    end;

    for I := 0 to TPlanLineGroup(pLine).p_numSons - 1 do //number of parent + sub categories
    begin
      if (I > 0) and SkipSubRows then break;
      if (I > 0) and not TPlanLineSecondLevel(TPlanLineShow(TPlanLineGroup(pLine).p_son[I])).p_shownAsSubLevel then break;

      // skip individual property sub-rows that have 0% in all visible slots
      // only for individual WC groups (not Plant/WCGroup/Division where P_WrkCtr is just one WC)
      SkipThisSubRow := False;
      if (I > 0) and (TPlanLineGroup(pLine).p_son[0] is TPlanLineWc)
         and (TPlanLineGroup(pLine).p_son[I] is TPlanLineSecondLevel)
         and (TPlanLineSecondLevel(TPlanLineGroup(pLine).p_son[I]).P_SecondLevelType = lvl_property)
         and Assigned(TPlanLineGroup(pLine).P_WrkCtr) then
      begin
        chk_Hours_Used := 0;
        TPlanLineGroup(pLine).P_WrkCtr.GetDataForPrdDailyPropertyCap(
          TPlanLineSecondLevel(TPlanLineGroup(pLine).p_son[I]).m_lineHd,
          chk_startDate, chk_endDate, chk_Hours_Avail, chk_Hours_Used, chk_errSet);
        if chk_Hours_Used <= 0 then
          SkipThisSubRow := True;
      end;

      if not SkipThisSubRow then
      begin
        m_viewRect.Top  := m_viewRect.Top + PaintGroupLine(isGrp, endl, ofst, TPlanLineShow(TPlanLineGroup(pLine).p_son[I]));
        Inc(SlotsInRow);
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

function TPlanWcView.PaintGroupLine(isGrp: boolean; endl: Boolean; ofst: integer; pLine: TPlanLineShow): integer;
var
  i: integer;
  rect: TRect;
  myViewRect: TRect;
  leftLmt, rightLmt: integer;
  dtFrom,dtTo: TDateTime;
  lngDsc, midDsc, shtDsc: string;
  bmp: graphics.TBitmap;
  DrawSlot : TDrawSlot;
  PropCode, PropValue, UM : string;
//  ST : TSlotDisplayCustomizeRec;
  var CustomQty, qty : Double;
begin
  myViewRect := m_viewRect;

  if pLine is TPlanLineWc then
    myViewRect.Bottom := myViewRect.Top + CMinLineHeight
  else if pLine is TPlanLineSecondLevel and (TPlanLineSecondLevel(pLine).P_SecondLevelType = lvl_property) then
    myViewRect.Bottom := myViewRect.Top + CMinLineHeightScondLvlProperty
  else
    myViewRect.Bottom := myViewRect.Top + CMinLineHeightScondLvlCategory;

  DrawHdr( ofst, myViewRect, pLine );

  rect := myViewRect;
  rect.Top    := rect.Top + CLineOffst;
  rect.Bottom := rect.Bottom - CLineOffst;

  bmp := graphics.TBitmap.Create;
  bmp.Canvas.Brush.Style := bsClear;
  for i := m_startSlot to m_endSlot do
  begin
    m_cal.GetSlotDataLimits(i,dtFrom,dtTo,lngDsc, midDsc, shtDsc);
    GetSlotLimits(dtFrom, dtTo, leftLmt, rightLmt);
    if leftLmt < CLnWcHdrWidth then
      rect.Left := CLnWcHdrWidth
    else
      rect.Left := leftLmt + 2;
    rect.Right := rightLmt - 2;

    m_viewRect.Left  := myViewRect.Left;  // avi 1.2
    m_viewRect.Right := myViewRect.Right;

    if Assigned(m_slotShowMode) then
    begin
      if (pLine is TPlanLineWc) then
        drawSlot := TdrawSlot.CreateDrawSlot(Slt_Wc)
      else if (pLine is TPlanLineSecondLevel) and (TPlanLineSecondLevel(pLine).P_SecondLevelType = Lvl_Wc_category) then
        drawSlot := TdrawSlot.CreateDrawSlot(slt_Wc_category)
      else if (pLine is TPlanLineSecondLevel) and (TPlanLineSecondLevel(pLine).P_SecondLevelType = lvl_property) then
        drawSlot := TdrawSlot.CreateDrawSlot(Slt_property)
      else if (pLine is TPlanLineWCGroup) then
        DrawSlot := TDrawSlot.CreateDrawSlot(Slt_WcGroup);

      pLine.GetDataForPrd(dtFrom, dtTo, drawSlot);
     // m_drawSlot.m_isSelected := m_selectSlot.IsSelected(pLine.m_lineHd, dtFrom);
      if (pLine is TPlanLineWc) then
        drawSlot.m_isSelected := m_selectSlot.IsSelectedWc(pLine.P_WcGroup.P_WrkCtr, pLine.m_lineHd, dtFrom, dtTo, Slt_Wc)
      else if (pLine is TPlanLineSecondLevel) then
      begin
        if TPlanLineSecondLevel(Pline).P_SecondLevelType = lvl_property then
        begin
          PropCode := TPlanLineShow(pline).P_WcGroup.p_PropCode;
          PropValue := TPlanLineSecondLevel(TPlanLineShow(pline)).m_lineHd;
          drawSlot.m_isSelected := m_selectSlot.IsSelectedPropCodeVal(pLine.P_WcGroup.P_WrkCtr, (TPlanLineShow(pline).P_WcGroup).P_WrkCtr.p_WrkCtrCode , dtFrom, dtTo, PropCode, PropValue, Slt_property);
        end
        else if TPlanLineSecondLevel(Pline).P_SecondLevelType = Lvl_Wc_category then
        begin
          PropCode := '';
          PropValue := TPlanLineSecondLevel(TPlanLineShow(pline)).m_lineHd;
          drawSlot.m_isSelected := m_selectSlot.IsSelectedPropCodeVal(pLine.P_WcGroup.P_WrkCtr, (TPlanLineShow(pline).P_WcGroup).P_WrkCtr.p_WrkCtrCode , dtFrom, dtTo, PropCode, PropValue, slt_Wc_category);
        end;

      end else if (pLine is TPlanLineWCGroup) then
        drawSlot.m_isSelected := m_selectSlot.IsSelectedWcGroup(pLine.P_WcGroup.P_WrkCtr, pLine.m_lineHd, dtFrom, dtTo, Slt_WcGroup);

      drawSlot.m_ShowCategoryTypePrecent := TPlanWcControl(m_PlanControl).GetCategoryShowPercent;
      drawSlot.m_ShowPropertyTypePrecent := TPlanWcControl(m_PlanControl).GetPropShowPercent;

      if TPlanLineShow(pline).P_WcGroup.P_WrkCtr <> nil then
        qty := GetQtyForPrdDailyCap(TPlanLineShow(pline).P_WcGroup.P_WrkCtr.m_WkcDailyCapacityList, dtFrom, dtTo- 1/24/3600, CustomQty, UM)
      else
        qty := 0;//TODO

      m_slotShowMode(bmp, m_planBox.Canvas, rect, drawSlot, qty, CustomQty, UM);
      AddLineInfo(rect, pLine); // test
    end;

  end;
  bmp.Free;

  if endl then
  begin
    // thicker separator after Summary row (end of each group) for visual grouping
    if (pLine is TPlanLineWCGroup) and (TPlanLineWCGroup(pLine).m_Group_name = 'Summary') then
    begin
      m_planBox.Canvas.Pen.Color := RGB(160, 170, 185);
      m_planBox.Canvas.Pen.Width := 2;
      m_planBox.Canvas.MoveTo(0, myViewRect.Bottom);
      m_planBox.Canvas.LineTo(myViewRect.Right, myViewRect.Bottom);
      m_planBox.Canvas.Pen.Width := 1;
    end
    else
    begin
      m_planBox.Canvas.Pen.Color := $00EBE8E4;
      m_planBox.Canvas.MoveTo(0, myViewRect.Bottom);
      m_planBox.Canvas.LineTo(myViewRect.Right, myViewRect.Bottom);
    end;
  end;

  DrawSlot.Free;
  //AddLineInfo(myViewRect, pLine);
  Result := myViewRect.Bottom - myViewRect.Top + 1;
end;

//----------------------------------------------------------------------------//

procedure TPlanWcView.SetABValue(ABValue: integer);
begin

end;

//----------------------------------------------------------------------------//

procedure TPlanWcView.SetLeftDate(date: TDateTime; prdNum, prdValue: integer);
var
 notUsed: TDateTime;
 str: string;
 rightDt: TDateTime;
begin
  if Assigned(m_cal) then
  begin
    m_startSlot := m_cal.GetSlotCrossingBegin(date);
    m_cal.GetSlotDataLimits(m_startSlot, m_leftDate, notUsed, str, str, str);
    // prdValue = 0  -> days
    // prdValue = 1  -> weeks
    // prdValue = 2  -> months
    case prdValue of
      0: rightDt := IncDay(m_leftDate, prdNum) - 1;
      1: rightDt := IncWeek(m_leftDate, prdNum) - 1;
      2: rightDt := IncMonth(m_leftDate, prdNum) - 1;
    else
      rightDt := IncDay(date, 7);
    end;

    m_endSlot := m_cal.GetSlotCrossingEnd(rightDt);
    m_cal.GetSlotDataLimits(m_endSlot, notUsed, m_rightDate, str, str, str);
  end;
end;

//----------------------------------------------------------------------------//

procedure TPlanWcView.SetTop(top: integer);
begin
  m_top := top
end;

//----------------------------------------------------------------------------//

function TPlanWcView.GetViewModeDraw : TDrawType;
begin
  Result := m_ViewModeDraw
end;

//----------------------------------------------------------------------------//

procedure TPlanWcView.SetViewModeDraw(DrowType : TDrawType);
var
  I, J : Integer;
  PlanLineGroup : TPlanLineGroup;
begin
  m_ViewModeDraw := DrowType;
  for I := 0 to m_pShot.p_numSons - 1 do
  begin
    PlanLineGroup := TPlanLineGroup(m_pShot.p_son[I]);
    for J := 1 to PlanLineGroup.p_numSons - 1 do
    begin
      if m_ViewModeDraw = DT_OnlyWc then
        TPlanLineSecondLevel(PlanLineGroup.p_son[J]).p_shownAsSubLevel := false
      else
        TPlanLineSecondLevel(PlanLineGroup.p_son[J]).p_shownAsSubLevel := true;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TPlanWcView.SetColorWcView(CololWcView : TColorWcView);
begin
  m_WCbackgroundColor := CololWcView.WCbackgroundColor;
  m_WCbackgroundColor_ReadOnly := CololWcView.WCbackgroundColorReadOnly;
  m_WorkCenterCategorybackgroundColor := CololWcView.MaterialProductbackgroundColor;
  m_WcPropertyColor                   := CololWcView.WcPropertyColor;
  m_WCSlotColor := CololWcView.WCSlotColor;
  m_TodaySlotColor   := CololWcView.TodaySlotColor;
  m_MaterialProductSlotColor := CololWcView.MaterialProductSlotColor;
  m_WCGroup := CololWcView.WCGroup;
end;

//----------------------------------------------------------------------------//

procedure DrawABlendSlot(bmp: TBitmap; Canvas: TCanvas; rect: TRect; ds: TDrawSlot; qty, CustQty : Double; UM : String); overload;

var
  bf: TBlendFunction;
//  ud: TGroupData;
  cd: TSlotData;
  recPaint : TRecDataPaint;
  pntArr : array of TPoint;
  maxCap, Perc : double;
  ACanvas : TcxCanvas;
  Lastcd : TSlotData;

  procedure DrawSmoothRoundRect(ACanvas: TcxCanvas; const ARect: TRect; AColor: TColor);
  var
    AGpCanvas: TdxGPCanvas;
  begin
    ACanvas.Brush.Style := bsClear;
    AGpCanvas := TdxGPCanvas.Create(ACanvas.Handle);
    AGpCanvas.SmoothingMode := smAntiAlias;
    AGpCanvas.EnableAntialiasing(True);
    AGpCanvas.RoundRect(ARect, AColor, AColor, Corner_Radius, Corner_Radius, 5, 255, 0);
    AGpCanvas.Free;
  end;

begin
  cd := ds.p_SlotData;

  bf.BlendOp             := AC_SRC_OVER;
  bf.BlendFlags          := 0;
  bf.AlphaFormat         := AC_SRC_OVER;  // AC_SRC_ALPHA

  if rect.Right-rect.Left > (CBarMrg+CBarMrg+4) then
  begin
    rect.Left  := rect.Left  + CBarMrg;
    rect.Right := rect.Right - CBarMrg + 2;
  end;
  rect.Top    := rect.Top + CSlotMrgSup;
  rect.Bottom := rect.Bottom - 3;//CSlotMrgInf;

  recPaint.Hours_Available     := cd.p_Hours_Available;
  recPaint.Hours_used          := cd.p_Hours_used;
  recPaint.Hours_used_wc       := cd.p_Hours_used_wc;
  recPaint.errSet              := cd.p_errSet;

  recPaint.val     := 0;//cd.p_val;
  recPaint.log     := 0;//cd.p_log;
  recPaint.ovl     := 0;//cd.p_ovl;

  recPaint.m_ShowCategoryTypePrecent := ds.m_ShowCategoryTypePrecent;
  recPaint.m_ShowPropertyTypePrecent := ds.m_ShowPropertyTypePrecent;

  if ds.m_SlotType = Slt_Wc then // should be change to a property
    PaintWcSlot(Rect, Canvas, recPaint, qty, CustQty, UM)
  else if ds.m_SlotType = slt_Wc_category then
    PaintWcCategorySlot(Rect, Canvas, recPaint)
  else if ds.m_SlotType = Slt_property then
    PaintWcPropertySlot(Rect, Canvas, recPaint)
  else if ds.m_SlotType = Slt_WcGroup then
    PaintWcGroupSlot(Rect, Canvas, recPaint, qty, CustQty, UM);


  windows.AlphaBlend(Canvas.Handle, Rect.Left, Rect.Top, bmp.Width , bmp.Height,
           bmp.Canvas.Handle, 0, 0, bmp.Width, bmp.Height,
           bf);

  PaintAlerts(rect, canvas, recPaint, ds);

  if ds.m_isSelected then
  begin
    case ds.m_SlotType of
      Slt_Wc: Canvas.Pen.Color := clRed;
      slt_Wc_category, Slt_property : Canvas.Pen.Color := clRed;
    end;

    Canvas.Pen.Width := 5;
    SetLength(pntArr, 5);

    pntArr[0]   := rect.TopLeft;
    pntArr[1].X := rect.Right;
    pntArr[1].Y := rect.Top;
    pntArr[2]   := rect.BottomRight;
    pntArr[3].X := rect.Left;
    pntArr[3].Y := rect.Bottom;
    pntArr[4]   := rect.TopLeft;

    ACanvas := TcxCanvas.Create(Canvas);
    DrawSmoothRoundRect(ACanvas, rect, clRed) ;
    ACanvas.Free;
    //Canvas.Polyline(pntArr);
    Canvas.Pen.Width := 1;
  end

  else
  begin

    if not GetPlanView.IsDynamicPlanActiv then exit;

    case ds.m_SlotType of

       Slt_property : begin

                        if recPaint.m_ShowPropertyTypePrecent = pp_WorkCenterAvailhours then
                          maxCap := recPaint.Hours_Available
                        else
                          maxCap := recPaint.Hours_used_wc;

                        recPaint.val := recPaint.Hours_used;

                        if (maxCap = 0) or (recPaint.val = 0) then
                           perc := 0
                        else
                          perc := recPaint.val / maxCap;

                        if perc > 0 then
                        begin
                          Canvas.Pen.Color := Cl_STNDRD_LIGHT_BLUE;
                          Canvas.Pen.Width := 2;
                          SetLength(pntArr, 5);

                          pntArr[0]   := rect.TopLeft;
                          pntArr[1].X := rect.Right;
                          pntArr[1].Y := rect.Top;
                          pntArr[2]   := rect.BottomRight;
                          pntArr[3].X := rect.Left;
                          pntArr[3].Y := rect.Bottom;
                          pntArr[4]   := rect.TopLeft;

                          Canvas.Polyline(pntArr);;
                          Canvas.Pen.Width := 1;


                        end;
                      end;
    end;


  end;


  if FMQMPlan.m_MainX > 0 then
    FMQMPlan.Changing := False
  else
    FMQMPlan.Changing := True;

end;

//----------------------------------------------------------------------------//

function TPlanWcView.GetQtyForPrdDailyCap(WkcList : TList;stDate, edDate: TDateTime; out CustQty : Double; out UM : String) : Double;
var
  I, J, S : Integer;
  DailyCapacity : PWkcDailyCapacity;
  JobCapacity : PJobCapacity;
  Hours_used : double;
//  ListIds : TStringList;
  a : TMqmPlanObj;
begin
  Result := 0;
  CustQty := 0;
  UM := '';

  if WkcList.Count = 0 then
    exit;

//  ListIds := TStringList.Create;
  for I := 0 to WkcList.count - 1 do
  begin

    if (PWkcDailyCapacity(WkcList[I]).Date < stDate) then continue;
    if (PWkcDailyCapacity(WkcList[I]).Date > edDate) then exit;
    DailyCapacity := PWkcDailyCapacity(WkcList[I]);
    Hours_used      := Hours_used + DailyCapacity.Hours_used;

    if (Hours_used > 0) and assigned(PWkcDailyCapacity(WkcList[I]).ListIds) then
    begin
      for J := 0 to PWkcDailyCapacity(WkcList[I]).ListIds.Count - 1 do
      begin
        JobCapacity := PJobCapacity(PWkcDailyCapacity(WkcList[I]).ListIds[J]);
       // if ListIds.IndexOf(IntToStr(PJobCapacity(JobCapacity).id)) <> - 1 then continue;
       // ListIds.Add(IntToStr(JobCapacity.id));
        Result := Result + JobCapacity.qty;

        CustQty := CustQty + JobCapacity.PropMultiQty;

        if j = 0 then
          UM := JobCapacity.UM
        else
        begin
          if JobCapacity.UM <> UM then
            UM := '';
        end;


      end;
    end;
  end;

 // ListIds.Free;
end;

procedure PaintWcGroupSlot(rect: TRect; Canvas: TCanvas; recPaint: TRecDataPaint; qty, CustQty : Double; UM : String);
var
  vert : array[0..1] of TRIVERTEX;
  gRect   : GRADIENT_RECT;
  perc, tmpPerc, percAbove:    double;
  tmpRect, AboveRect: TRect;
  str, CustomQty: string;
  size:    tagSIZE;
  bStyle:  TBrushStyle;
  cWidth, slot: Integer;
  cHeight: Integer;
  topOrig: Integer;
  ovlLnY : integer;
  logLnY : integer;
  HeiAbove: Integer;
  SavedLeft, SavedRight :  integer;
  maxCap: double;
  ColorWcView : TColorWcView;
  SlotColor : TColor;
  a : TPlanWcView;
  lngDsc, midDsc, shtDsc : string;
  ACanvas : TcxCanvas;

  procedure RoundedGradient(cxCanvas : TcxCanvas; ARect: TRect; StartColor, EndColor : TColor);
  var
    ACanvas2: TdxGPCanvas;
    AGPBrush: TdxGPBrush;
    pen : TdxGPPen ;
  begin
    ACanvas2 := TdxGPCanvas.Create(cxCanvas.Handle);
    Pen := TdxGPPen.Create(clBlack,2);
    try
      AGPBrush := TdxGPBrush.Create;
      try
        AGPBrush.Style := gpbsGradient;
        AGPBrush.GradientMode := gpbgmVertical;
        AGPBrush.GradientPoints.Add(0.0, dxColorToAlphaColor(StartColor,255)); // from top to bottom
        AGPBrush.GradientPoints.Add(1.0, dxColorToAlphaColor(EndColor,50));
        Arect.Width := Arect.Width +1;
        ACanvas2.RoundRect(Arect, pen, AGPBrush,Corner_Radius,Corner_Radius);

      finally
        AGPBrush.Free;
        Pen.Free;
      end;
    finally
      ACanvas2.Free;
    end;
  end;

   procedure DrawSmoothRoundRect(cxCanvas: TcxCanvas; const ARect: TRect; AColor, ABkColor: TColor;
    ARadiusX, ARadiusY: Integer; APenWidth: Integer = 1; APenColorAlpha: Byte = 255; ABrushColorAlpha: Byte = 255);
  var
    AGpCanvas: TdxGPCanvas;
  begin
    AGpCanvas := TdxGPCanvas.Create(cxCanvas.Handle);
    AGpCanvas.SmoothingMode := smAntiAlias;
    AGpCanvas.EnableAntialiasing(True);
    AGpCanvas.RoundRect(ARect, AColor, ABkColor, ARadiusX, ARadiusY, APenWidth, APenColorAlpha, ABrushColorAlpha);
    AGpCanvas.Free;
  end;

begin
  perc := 0;
  ColorWcView := GetColorWcView;
  SlotColor := GetColoForPercent(recPaint);

  ACanvas := TcxCanvas.Create(Canvas);

  topOrig := rect.Top;
  cWidth  := rect.Right-rect.Left+1;
  cHeight := rect.Bottom-rect.Top+1;

//  tmpRect := rect;
  ovlLnY := rect.Top;
  logLnY := rect.Top;

  // Solid vs. dotted red line, solid=log<ovl, dotted=ovl<log
//  maxCap := Max(recPaint.ovl, recPaint.log);
//  maxCap := recPaint.ovl;

//  maxCap := 120;  //avi test
//  recPaint.val := 100;
  recPaint.ovl := 100;

  maxCap := recPaint.Hours_Available;
  recPaint.val := recPaint.Hours_used;

//  if (maxCap > 0) then
//  begin
  if maxCap <= 0 then
     perc := 0
  else
    perc := recPaint.val / maxCap;

  // Paint base: clLime only when there is usage, gray when 0%
  if Currency(perc) > 0 then
    RoundedGradient(ACanvas, rect, clLime, ClLime)
  else
    RoundedGradient(ACanvas, rect, ColorWcView.WCSlotColor, ColorWcView.WCSlotColor);

  if perc > 1 then
  begin
    rect.Bottom := rect.Top;
    perc := recPaint.val / maxCap;
  end;

  tmpRect.left := rect.left;
  tmpRect.right := rect.Right;
  tmpRect.Bottom := rect.Bottom;
  tmpRect.Top := rect.top;
  tmpRect.TopLeft := rect.TopLeft;
  tmpRect.BottomRight := Rect.BottomRight;

  tmpRect.Bottom := rect.Bottom - Trunc((rect.Bottom-rect.top) * perc);

  if Currency(perc) > 0 then
  begin
    Canvas.brush.Style := bsSolid;
    Canvas.brush.color := GetColoForPercent(recPaint);

    DrawSmoothRoundRect(ACanvas,
        tmpRect,  //Rectangle
        Canvas.Brush.Color, //pen color
        Canvas.Brush.Color, //brush color
        Corner_Radius, Corner_Radius, //corner radius
        1, //border width
        255,  //transparent of pen
        255); //transparent of brush
  end;

  //Mihailo added
  //Paint Red Rect above 100%
  {if (SimpleRoundTo(perc * 100.0) > 100) and (SimpleRoundTo(perc * 100.0) <= 200) then
  begin
    PercAbove :=  SimpleRoundTo(perc * 100.0) - 100;
    AboveRect.Top := tmpRect.Top;
    AboveRect.Left := tmpRect.Left;
    AboveRect.Width := tmpRect.Width;

    if perc * 100.0 < 105 then
      HeiAbove := 1
    else
      HeiAbove := Trunc((cHeight div 2) * (PercAbove / 100));

    AboveRect.Height := HeiAbove;

    Canvas.brush.Style := bsSolid;
    Canvas.brush.color := clRed;

     DrawSmoothRoundRect(ACanvas,
        AboveRect,  //Rectangle
        Canvas.Brush.Color, //pen color
        Canvas.Brush.Color, //brush color
        Corner_Radius, Corner_Radius, //corner radius
        1, //border width
        255,  //transparent of pen
        255); //transparent of brush
  end;

  if (SimpleRoundTo(perc * 100.0) > 200) then
  begin
    PercAbove :=  SimpleRoundTo(perc * 100.0) - 100;
    AboveRect.Top := tmpRect.Top;
    AboveRect.Left := tmpRect.Left;
    AboveRect.Width := tmpRect.Width;
    AboveRect.Height := cHeight div 2;

    Canvas.brush.Style := bsSolid;
    Canvas.brush.color := clRed;

    DrawSmoothRoundRect(ACanvas,
        AboveRect,  //Rectangle
        Canvas.Brush.Color, //pen color
        Canvas.Brush.Color, //brush color
        Corner_Radius, Corner_Radius, //corner radius
        1, //border width
        255,  //transparent of pen
        255); //transparent of brush
  end;  }

  Canvas.brush.Style := bsSolid;

  if DBAppGlobals.MCMSlotDisplay = 0 then //SHOW %
  begin
    if (maxCap >= 0) then
    begin
      //perc := perc * 100;

      if (perc > 0) and (perc < 0.01) then
      begin
        perc := trunc(perc * 1000) / 10;
        if (perc = 0) then
        perc := 0.1;
        Str := FloatToStr(perc) + ' %';
      end
      else
        str := FloatToStr(SimpleRoundTo(perc * 100.0, 0)) + ' %';

      size := Canvas.TextExtent(str);
    end;
  end else  //SHOW QTY
  begin
    Str := FormatFloat('#,##0',qty) + ' ' + UM;
  end;

   if DBAppGlobals.MCMCustomQty then
   begin
     CustomQty := FormatFloat('#,##0',CustQty);
     if CustomQty <> '0' then
       str := Str + '  ' + CustomQty + DBAppGlobals.MCMCustomPropSymbol;
   end;

   size := Canvas.TextExtent(str);

  if (size.cy < cHeight) and (size.cx < cWidth) then
  begin
    bStyle := Canvas.Brush.Style;
    Canvas.Brush.Style := bsClear;
    Canvas.Font.Color := clBlack;

    //Mihailo added

    if DBAppGlobals.MCMCustomQty then
       Canvas.TextOut(rect.Left + Trunc((cWidth-size.cx)/3), topOrig + Trunc((cHeight-size.cy)/2), str )
     else
      Canvas.TextOut(rect.Left + Trunc((cWidth-size.cx)/2), topOrig + Trunc((cHeight-size.cy)/2), str );
    Canvas.Brush.Style := bStyle;
  end;

  ACanvas.Free;

end;

procedure PaintWcSlot(rect: TRect; Canvas: TCanvas; recPaint: TRecDataPaint; qty, CustQty : Double; UM : String);
var
  vert : array[0..1] of TRIVERTEX;
  gRect   : GRADIENT_RECT;
  perc, tmpPerc, percAbove:    double;
  tmpRect, AboveRect: TRect;
  str, CustomQty: string;
  size:    tagSIZE;
  bStyle:  TBrushStyle;
  cWidth, slot: Integer;
  cHeight: Integer;
  topOrig: Integer;
  ovlLnY : integer;
  logLnY : integer;
  HeiAbove: Integer;
  SavedLeft, SavedRight :  integer;
  maxCap: double;
  ColorWcView : TColorWcView;
  SlotColor : TColor;
  a : TPlanWcView;
  lngDsc, midDsc, shtDsc : string;
  ACanvas : TcxCanvas;

  procedure RoundedGradient(Canvas : TcxCanvas; ARect: TRect; StartColor, EndColor : TColor);
  var
    ACanvas: TdxGPCanvas;
    AGPBrush: TdxGPBrush;
    pen : TdxGPPen ;
  begin
    ACanvas := TdxGPCanvas.Create(Canvas.Handle);
    Pen := TdxGPPen.Create(clBlack,2);
    try
      AGPBrush := TdxGPBrush.Create;
      try
        AGPBrush.Style := gpbsGradient;
        AGPBrush.GradientMode := gpbgmVertical;
        AGPBrush.GradientPoints.Add(0.0, dxColorToAlphaColor(StartColor,255)); // from top to bottom
        AGPBrush.GradientPoints.Add(1.0, dxColorToAlphaColor(EndColor,50));
        Arect.Width := Arect.Width +1;
        ACanvas.RoundRect(Arect, pen, AGPBrush,Corner_Radius,Corner_Radius);

      finally
        AGPBrush.Free;
        Pen.Free;
      end;
    finally
      ACanvas.Free;
    end;
  end;

   procedure DrawSmoothRoundRect(ACanvas: TcxCanvas; const ARect: TRect; AColor, ABkColor: TColor;
    ARadiusX, ARadiusY: Integer; APenWidth: Integer = 1; APenColorAlpha: Byte = 255; ABrushColorAlpha: Byte = 255);
  var
    AGpCanvas: TdxGPCanvas;
  begin
    AGpCanvas := TdxGPCanvas.Create(ACanvas.Handle);
    AGpCanvas.SmoothingMode := smAntiAlias;
    AGpCanvas.EnableAntialiasing(True);
    AGpCanvas.RoundRect(ARect, AColor, ABkColor, ARadiusX, ARadiusY, APenWidth, APenColorAlpha, ABrushColorAlpha);
    AGpCanvas.Free;
  end;

begin

  perc := 0;
  ColorWcView := GetColorWcView;

  SlotColor := GetColoForPercent(recPaint);

  vert[0].x      := rect.Right;
  vert[0].y      := Rect.Top;

  vert[0].Red    := (SlotColor and $000000FF) * 256;      // ColorWcView.WCSlotColor
  vert[0].Green  := (SlotColor and $0000FF00);
  vert[0].Blue   := (SlotColor and $00FF0000) div 256;

  vert[0].Alpha  := $0000;

  vert[1].x      := rect.Left;
  vert[1].y      := Rect.Bottom;

  vert[1].Red    := (SlotColor and $000000FF) * 256;   // 16754342
  vert[1].Green  := (SlotColor and $0000FF00);
  vert[1].Blue   := (SlotColor and $00FF0000) div 256;

  vert[1].Alpha  := $ffff;

  gRect.UpperLeft  := 0;
  gRect.LowerRight := 1;
  ACanvas := TcxCanvas.Create(Canvas);

  // Calculate perc before painting base color
  recPaint.ovl := 100;
  maxCap := recPaint.Hours_Available;
  recPaint.val := recPaint.Hours_used;

  if maxCap = 0 then
     perc := 0
  else
    perc := recPaint.val / maxCap;

  // Paint base: clLime only when there is usage, gray when 0%
  if Currency(perc) > 0 then
    RoundedGradient(ACanvas, rect, clLime, ClLime)
  else
    RoundedGradient(ACanvas, rect, ColorWcView.WCSlotColor, ColorWcView.WCSlotColor);

  topOrig := rect.Top;
  cWidth  := rect.Right-rect.Left+1;
  cHeight := rect.Bottom-rect.Top+1;

//  tmpRect := rect;
  ovlLnY := rect.Top;
  logLnY := rect.Top;

  if perc > 1 then
  begin
    rect.Bottom := rect.Top;
    perc := recPaint.val / maxCap;
  end;
    // calc line of logical capacity
   { if maxCap <= recPaint.log then
      logLnY := Trunc(tmpRect.Bottom - (tmpRect.Bottom-tmpRect.top)*perc)
    else
    begin
      tmpPerc := maxCap / recPaint.log;
      if tmpPerc > 1 then
        tmpPerc := recPaint.log / maxCap;
      logLnY := Trunc(tmpRect.Bottom - (tmpRect.Bottom-tmpRect.top)*tmpPerc)
    end;

    // calc line of overloaded capacity
    if maxCap <= recPaint.ovl then
      ovlLnY := Trunc(tmpRect.Bottom - (tmpRect.Bottom-tmpRect.top)*perc)
    else
    begin
      tmpPerc := maxCap / recPaint.ovl;
      if tmpPerc > 1 then
        tmpPerc := recPaint.ovl / maxCap;
      ovlLnY := Trunc(tmpRect.Bottom - (tmpRect.Bottom-tmpRect.top)*tmpPerc)
    end;
  end
  else
  begin     }
  //  SavedLeft := rect.left;
   // tmpRect := rect;
 //   SavedRight := rect.Right;
    tmpRect.left := rect.left;
    tmpRect.right := rect.Right;
    tmpRect.Bottom := rect.Bottom;
    tmpRect.Top := rect.top;
    tmpRect.TopLeft := rect.TopLeft;
    tmpRect.BottomRight := Rect.BottomRight;

  //  tmpRect.left := rect.left + (trunc(perc * (rect.Right - rect.left)));
    tmpRect.Bottom := rect.Bottom - Trunc((rect.Bottom-rect.top) * perc);  // OLD PREC ...
    {Canvas.Pen.Style := psSolid;     // add line in the border
    Canvas.Pen.Color := clRed;//   ud.m_slotLineColor;
    Canvas.MoveTo(tmpRect.Left , logLnY);
    Canvas.LineTo(rect.Right , logLnY); }



 // end;
//  end;

{  if perc >= 0 then
  begin
    Canvas.brush.color := clsilver;  //ud.m_slotEmptyColor;
    Canvas.FillRect(tmpRect);
  end; }

  //exit;

  if Currency(perc) > 0 then
  begin
    Canvas.brush.Style := bsSolid;
    Canvas.brush.color := GetColoForPercent(recPaint);
   // Canvas.FillRect(tmpRect);
    DrawSmoothRoundRect(ACanvas,
        tmpRect,  //Rectangle
        Canvas.Brush.Color, //pen color
        Canvas.Brush.Color, //brush color
        Corner_Radius, Corner_Radius, //corner radius
        1, //border width
        255,  //transparent of pen
        255); //transparent of brush
  end;

  //Mihailo added
  //Paint Red Rect above 100%
  if (SimpleRoundTo(perc * 100.0) > 100) and (SimpleRoundTo(perc * 100.0) <= 200) then
  begin
    PercAbove :=  SimpleRoundTo(perc * 100.0) - 100;
    AboveRect.Top := tmpRect.Top;
    AboveRect.Left := tmpRect.Left;
    AboveRect.Width := tmpRect.Width;

    if perc * 100.0 < 105 then
      HeiAbove := 1
    else
      HeiAbove := Trunc((cHeight div 2) * (PercAbove / 100));

    AboveRect.Height := HeiAbove;

    Canvas.brush.Style := bsSolid;
    Canvas.brush.color := clRed;
    //Canvas.FillRect(AboveRect);
     DrawSmoothRoundRect(ACanvas,
        AboveRect,  //Rectangle
        Canvas.Brush.Color, //pen color
        Canvas.Brush.Color, //brush color
        Corner_Radius, Corner_Radius, //corner radius
        1, //border width
        255,  //transparent of pen
        255); //transparent of brush
  end;

  if (SimpleRoundTo(perc * 100.0) > 200) then
  begin
    PercAbove :=  SimpleRoundTo(perc * 100.0) - 100;
    AboveRect.Top := tmpRect.Top;
    AboveRect.Left := tmpRect.Left;
    AboveRect.Width := tmpRect.Width;
    AboveRect.Height := cHeight div 2;

    Canvas.brush.Style := bsSolid;
    Canvas.brush.color := clRed;
    //Canvas.FillRect(AboveRect);
    DrawSmoothRoundRect(ACanvas,
        AboveRect,  //Rectangle
        Canvas.Brush.Color, //pen color
        Canvas.Brush.Color, //brush color
        Corner_Radius, Corner_Radius, //corner radius
        1, //border width
        255,  //transparent of pen
        255); //transparent of brush
  end;

  Canvas.brush.Style := bsSolid;

 // rect.left := SavedLeft;
 // rect.right := SavedRight;

 {
  if recPaint.log <> -1 then
  begin
    Canvas.Pen.Style := psSolid;
    Canvas.Pen.Color := clRed;//   ud.m_slotLineColor;
    Canvas.MoveTo(rect.Left - 2, logLnY);
    Canvas.LineTo(rect.Right + 2, logLnY);
  end;

  if (recPaint.ovl <> -1) and (recPaint.ovl <> recPaint.log) then
  begin
    Canvas.Pen.Style := psDot;
    Canvas.Pen.Color := clYellow;  //ud.m_slotLineColor;
    Canvas.MoveTo(rect.Left - 2, ovlLnY);
    Canvas.LineTo(rect.Right + 2, ovlLnY);
    Canvas.Pen.Style := psSolid;
  end; }


  if DBAppGlobals.MCMSlotDisplay = 0 then //SHOW %
  begin
    if (maxCap >= 0) then
    begin
      perc := perc * 100;

      if (perc > 0) and (perc < 1) then
      begin
        perc := trunc(perc * 10) / 10;
        if (perc = 0) then
          perc := 0.1;
        Str := FloatToStr(perc) + ' %';
      end
      else
        str := FloatToStr(SimpleRoundTo(perc, 0)) + ' %';

      size := Canvas.TextExtent(str);
    end;
  end else  //SHOW QTY
  begin
    Str := FormatFloat('#,##0',qty) + ' ' + UM;
  end;

   if DBAppGlobals.MCMCustomQty then
   begin
     CustomQty := FormatFloat('#,##0',CustQty);
     if CustomQty <> '0' then
       str := Str + '  ' + CustomQty + DBAppGlobals.MCMCustomPropSymbol;
       //str := Str + ' , ' + CustomQty + ' ' + UM ;
   end;

   size := Canvas.TextExtent(str);

  if (size.cy < cHeight) and (size.cx < cWidth) then
  begin
    bStyle := Canvas.Brush.Style;
    Canvas.Brush.Style := bsClear;
    Canvas.Font.Color := clBlack;

    //Mihailo added

    if DBAppGlobals.MCMCustomQty then
    begin
     //  CustomQty := FormatFloat('#,##0',CustQty);

     //  str := Str + ' , ' + CustomQty + ' ' + UM ;
       Canvas.TextOut(rect.Left + Trunc((cWidth-size.cx)/3), topOrig + Trunc((cHeight-size.cy)/2), str );
    end
     else
    begin
      Canvas.TextOut(rect.Left + Trunc((cWidth-size.cx)/2), topOrig + Trunc((cHeight-size.cy)/2), str );
    end;



   { end
    else
    begin

      if (SimpleRoundTo(perc * 100.0) > 140) and ((SimpleRoundTo(perc * 100.0) <= 200)) then
       Canvas.TextOut(rect.Left + Trunc((cWidth-size.cx)/2), topOrig + (HeiAbove div 2)-5, FloatToStr(SimpleRoundTo(PercAbove))+'%' );

      if (SimpleRoundTo(perc * 100.0) > 200) then
        Canvas.TextOut(rect.Left + Trunc((cWidth-size.cx)/2), topOrig + Trunc((cHeight-size.cy)/4), FloatToStr(SimpleRoundTo(PercAbove))+'%' );

      Canvas.TextOut(rect.Left + Trunc((cWidth-size.cx)/2), topOrig + Trunc((cHeight-size.cy)-5), '100%' );
    end;  }

   { if (SimpleRoundTo(perc * 100.0) <= 140) and ((SimpleRoundTo(perc * 100.0) > 100)) then
    begin
        Canvas.Font.Color := clWhite;
        Canvas.TextOut(rect.Left + Trunc((cWidth-size.cx)/2), topOrig + (HeiAbove div 2) , FloatToStr(SimpleRoundTo(PercAbove))+'%' );
    end;  }

    Canvas.Brush.Style := bStyle;
  end;

  ACanvas.Free;

end;

//----------------------------------------------------------------------------//

procedure PaintWcCategorySlot(rect: TRect; Canvas: TCanvas; recPaint: TRecDataPaint);

  procedure RoundedGradient(cxCanvas : TcxCanvas; ARect: TRect; StartColor, EndColor : TColor);
  var
    ACanvas2: TdxGPCanvas;
    AGPBrush: TdxGPBrush;
    pen : TdxGPPen ;
  begin
    ACanvas2 := TdxGPCanvas.Create(cxCanvas.Handle);
    Pen := TdxGPPen.Create(clBlack,2);
    try
      AGPBrush := TdxGPBrush.Create;
      try
        AGPBrush.Style := gpbsGradient;
        AGPBrush.GradientMode := gpbgmVertical;
        AGPBrush.GradientPoints.Add(0.0, dxColorToAlphaColor(StartColor,255)); // from top to bottom
        AGPBrush.GradientPoints.Add(1.0, dxColorToAlphaColor(EndColor,50));
        Arect.Width := Arect.Width +1;
        ACanvas2.RoundRect(Arect, pen, AGPBrush,Corner_Radius,Corner_Radius);

      finally
        AGPBrush.Free;
        Pen.Free;
      end;
    finally
      ACanvas2.Free;
    end;
  end;
var
  vert : array[0..1] of TRIVERTEX;
  gRect   : GRADIENT_RECT;
  perc, tmpPerc:    double;
  tmpRect: TRect;
  str : string;
  size:    tagSIZE;
  bStyle:  TBrushStyle;
  cWidth: Integer;
  cHeight: Integer;
  topOrig: Integer;
  ovlLnY : integer;
  logLnY : integer;
  SavedLeft, SavedRight :  integer;
  maxCap: double;
  ColorWcView : TColorWcView;
  ACanvas : TcxCanvas;
begin
  perc := 0;
  ColorWcView := GetColorWcView;
  vert[0].x      := rect.Right;
  vert[0].y      := Rect.Top;

  vert[0].Red    := (ColorWcView.WCSlotColor and $000000FF) * 256;      // 65280 mcm green
  vert[0].Green  := (ColorWcView.WCSlotColor and $0000FF00);
  vert[0].Blue   := (ColorWcView.WCSlotColor and $00FF0000) div 256;

  vert[0].Alpha  := $0000;

  vert[1].x      := rect.Left;
  vert[1].y      := Rect.Bottom;

  vert[1].Red    := (clWhite and $000000FF) * 256;   // 16754342
  vert[1].Green  := (clWhite and $0000FF00);
  vert[1].Blue   := (clWhite and $00FF0000) div 256;

  vert[1].Alpha  := $ffff;

  gRect.UpperLeft  := 0;
  gRect.LowerRight := 1;

  ACanvas := TcxCanvas.Create(Canvas);
 // GradientFill(Canvas.Handle, @vert,2,@gRect,1,GRADIENT_FILL_RECT_V);
 RoundedGradient(ACanvas, rect, clLime, clLime);

  topOrig := rect.Top;
  cWidth  := rect.Right-rect.Left+1;
  cHeight := rect.Bottom-rect.Top+1;

  ovlLnY := rect.Top;
  logLnY := rect.Top;

  recPaint.ovl := 100;

  if recPaint.m_ShowCategoryTypePrecent = Cp_WorkCenterAvailhours then
    maxCap := recPaint.Hours_Available
  else
    maxCap := recPaint.Hours_used_wc;

  recPaint.val := recPaint.Hours_used;

  if maxCap = 0 then
     perc := 0
  else
    perc := recPaint.val / maxCap;

  if perc > 1 then
  begin
    rect.Bottom := rect.Top;
    perc := MaxCap / recPaint.val;

    // calc line of logical capacity
    if maxCap <= recPaint.log then
      logLnY := Trunc(tmpRect.Bottom - (tmpRect.Bottom-tmpRect.top)*perc)
    else
    begin
      tmpPerc := maxCap / recPaint.log;
      if tmpPerc > 1 then
        tmpPerc := recPaint.log / maxCap;
      logLnY := Trunc(tmpRect.Bottom - (tmpRect.Bottom-tmpRect.top)*tmpPerc)
    end;

    // calc line of overloaded capacity
    if maxCap <= recPaint.ovl then
      ovlLnY := Trunc(tmpRect.Bottom - (tmpRect.Bottom-tmpRect.top)*perc)
    else
    begin
      tmpPerc := maxCap / recPaint.ovl;
      if tmpPerc > 1 then
        tmpPerc := recPaint.ovl / maxCap;
      ovlLnY := Trunc(tmpRect.Bottom - (tmpRect.Bottom-tmpRect.top)*tmpPerc)
    end;
  end
  else
  begin
    tmpRect.left := rect.left;
    tmpRect.right := rect.Right;
    tmpRect.Bottom := rect.Bottom;
    tmpRect.Top := rect.top;
    tmpRect.TopLeft := rect.TopLeft;
    tmpRect.BottomRight := Rect.BottomRight;
    tmpRect.Bottom := rect.Bottom - Trunc((rect.Bottom-rect.top) * perc);  // OLD PREC ...
  end;

  if (perc >= 0.005) then  // paint empty portion with green shades
  begin
    try
      Canvas.brush.Style := bsSolid;
      if (perc <= 0.10) then
        Canvas.brush.color := RGB(60, 175, 60)
      else if (perc <= 0.20) then
        Canvas.brush.color := RGB(75, 185, 75)
      else if (perc <= 0.35) then
        Canvas.brush.color := RGB(90, 195, 90)
      else if (perc <= 0.50) then
        Canvas.brush.color := RGB(110, 200, 110)
      else if (perc <= 0.65) then
        Canvas.brush.color := RGB(130, 210, 130)
      else if (perc <= 0.80) then
        Canvas.brush.color := RGB(155, 220, 155)
      else
        Canvas.brush.color := RGB(180, 230, 180);
      Canvas.FillRect(tmpRect);
    except
    end;
  end
  else  // 0% — light gray
  begin
    try
      Canvas.brush.Style := bsSolid;
      Canvas.brush.color := RGB(240, 240, 244);
      Canvas.FillRect(rect);
    except
    end;
  end;
  Canvas.brush.Style := bsSolid;

  if (maxCap >= 0) then
  begin
    if (perc > 0) and (perc < 0.01) then
    begin
      try
        perc := trunc(perc * 1000) / 10;
        perc := 0.1;
        Str := FloatToStr(perc) + ' %';
      except
        Str := FloatToStr(0) + ' %';
      end;
    end
    else
    begin
      if perc = 0 then
         str := FloatToStr(0) + ' %'
      else
      begin
        try
          str := FloatToStr(SimpleRoundTo(perc * 100.0, 0)) + ' %';
        except
          str := FloatToStr(0) + ' %';
        end;
      end;
    end;
    size := Canvas.TextExtent(str);
  end;

  if (size.cy < cHeight) and (size.cx < cWidth) then
  begin
    bStyle := Canvas.Brush.Style;
    Canvas.Brush.Style := bsClear;
    Canvas.Font.Color := clblack;  //ud.m_slotTxtColor;

    Canvas.TextOut(rect.Left + Trunc((cWidth-size.cx)/2), topOrig + Trunc((cHeight-size.cy)/2), str );

    Canvas.Brush.Style := bStyle;
  end;

  ACanvas.Free;
end;

//----------------------------------------------------------------------------//

procedure PaintWcPropertySlot(rect: TRect; Canvas: TCanvas; recPaint: TRecDataPaint);

  procedure RoundedGradient(Canvas : TcxCanvas; ARect: TRect; StartColor, EndColor : TColor);
  var
    ACanvas: TdxGPCanvas;
    AGPBrush: TdxGPBrush;
    pen : TdxGPPen ;
  begin
    ACanvas := TdxGPCanvas.Create(Canvas.Handle);
    Pen := TdxGPPen.Create(clBlack,2);
    try
      AGPBrush := TdxGPBrush.Create;
      try
        AGPBrush.Style := gpbsGradient;
        AGPBrush.GradientMode := gpbgmVertical;
        AGPBrush.GradientPoints.Add(0.0, dxColorToAlphaColor(StartColor,255)); // from top to bottom
        AGPBrush.GradientPoints.Add(1.0, dxColorToAlphaColor(EndColor,50));
        Arect.Width := Arect.Width +1;
        ACanvas.RoundRect(Arect, pen, AGPBrush,Corner_Radius,Corner_Radius);

      finally
        AGPBrush.Free;
        Pen.Free;
      end;
    finally
      ACanvas.Free;
    end;
  end;


var
  vert : array[0..1] of TRIVERTEX;
  gRect   : GRADIENT_RECT;
  perc, tmpPerc:    double;
  tmpRect: TRect;
  str : string;
  size:    tagSIZE;
  bStyle:  TBrushStyle;
  cWidth: Integer;
  cHeight: Integer;
  topOrig: Integer;
  ovlLnY : integer;
  logLnY : integer;
  SavedLeft, SavedRight :  integer;
  maxCap: double;
  ColorWcView : TColorWcView;
  ACanvas : TcxCanvas;
begin
  perc := 0;
  ColorWcView := GetColorWcView;
  vert[0].x      := rect.Right;
  vert[0].y      := Rect.Top;

  vert[0].Red    := (ColorWcView.WcPropertyColor and $000000FF) * 256;      // 65280 mcm green
  vert[0].Green  := (ColorWcView.WcPropertyColor and $0000FF00);
  vert[0].Blue   := (ColorWcView.WcPropertyColor and $00FF0000) div 256;

  vert[0].Alpha  := $0000;

  vert[1].x      := rect.Left;
  vert[1].y      := Rect.Bottom;

  vert[1].Red    := (clWhite and $000000FF) * 256;   // 16754342
  vert[1].Green  := (clWhite and $0000FF00);
  vert[1].Blue   := (clWhite and $00FF0000) div 256;

  vert[1].Alpha  := $ffff;

  gRect.UpperLeft  := 0;
  gRect.LowerRight := 1;
  //GradientFill(Canvas.Handle, @vert,2,@gRect,1,GRADIENT_FILL_RECT_V);
  ACanvas := TcxCanvas.Create(Canvas);
  RoundedGradient(ACanvas, rect, clLime, clLime); // green base — same as WC slots

  topOrig := rect.Top;
  cWidth  := rect.Right-rect.Left+1;
  cHeight := rect.Bottom-rect.Top+1;

  ovlLnY := rect.Top;
  logLnY := rect.Top;

  recPaint.ovl := 100;

  if recPaint.m_ShowPropertyTypePrecent = pp_WorkCenterAvailhours then
    maxCap := recPaint.Hours_Available
  else
    maxCap := recPaint.Hours_used_wc;

  recPaint.val := recPaint.Hours_used;

  if (maxCap = 0) or (recPaint.val = 0) then
     perc := 0
  else
    perc := recPaint.val / maxCap;

  if perc > 1 then
  begin
    rect.Bottom := rect.Top;
    perc := MaxCap / recPaint.val;

    // calc line of logical capacity
    if maxCap <= recPaint.log then
      logLnY := Trunc(tmpRect.Bottom - (tmpRect.Bottom-tmpRect.top)*perc)
    else
    begin
      tmpPerc := maxCap / recPaint.log;
      if tmpPerc > 1 then
        tmpPerc := recPaint.log / maxCap;
      logLnY := Trunc(tmpRect.Bottom - (tmpRect.Bottom-tmpRect.top)*tmpPerc)
    end;

    // calc line of overloaded capacity
    if maxCap <= recPaint.ovl then
      ovlLnY := Trunc(tmpRect.Bottom - (tmpRect.Bottom-tmpRect.top)*perc)
    else
    begin
      tmpPerc := maxCap / recPaint.ovl;
      if tmpPerc > 1 then
        tmpPerc := recPaint.ovl / maxCap;
      ovlLnY := Trunc(tmpRect.Bottom - (tmpRect.Bottom-tmpRect.top)*tmpPerc)
    end;
  end
  else
  begin
    tmpRect.left := rect.left;
    tmpRect.right := rect.Right;
    tmpRect.Bottom := rect.Bottom;
    tmpRect.Top := rect.top;
    tmpRect.TopLeft := rect.TopLeft;
    tmpRect.BottomRight := Rect.BottomRight;
    tmpRect.Bottom := rect.Bottom - Trunc((rect.Bottom-rect.top) * perc);
  end;

  if (perc >= 0.005) then  // paint empty portion with green — clLime base shows through at bottom
  begin
    try
      Canvas.brush.Style := bsSolid;
      // green shades — darker at low %, lighter toward 100% (where clLime base shows fully)
      if (perc <= 0.10) then
        Canvas.brush.color := RGB(60, 175, 60)        // deep green
      else if (perc <= 0.20) then
        Canvas.brush.color := RGB(75, 185, 75)        // rich green
      else if (perc <= 0.35) then
        Canvas.brush.color := RGB(90, 195, 90)        // deeper green
      else if (perc <= 0.50) then
        Canvas.brush.color := RGB(110, 200, 110)      // medium green
      else if (perc <= 0.65) then
        Canvas.brush.color := RGB(130, 210, 130)      // soft green
      else if (perc <= 0.80) then
        Canvas.brush.color := RGB(155, 220, 155)      // light green
      else
        Canvas.brush.color := RGB(180, 230, 180);     // very light green
      Canvas.FillRect(tmpRect);
    except
    end;
  end
  else  // 0% — cover entire clLime base with light gray
  begin
    try
      Canvas.brush.Style := bsSolid;
      Canvas.brush.color := RGB(240, 240, 244);
      Canvas.FillRect(rect);
    except
    end;
  end;
  Canvas.brush.Style := bsSolid;

  if (maxCap >= 0) then
  begin
    if (perc > 0) and (perc < 0.01) then
    begin
      try
        perc := trunc(perc * 1000) / 10;
        //if (perc = 0) then
          perc := 0.1;
        Str := FloatToStr(perc) + ' %';
      except
        Str := FloatToStr(0) + ' %';
      end;
    end
    else
    begin
      if perc = 0 then
         str := FloatToStr(0) + ' %'
      else
      begin
        try
          str := FloatToStr(SimpleRoundTo(perc * 100.0, 0)) + ' %';
        except
          str := FloatToStr(0) + ' %';
        end;
      end;
    end;
    size := Canvas.TextExtent(str);
  end;

  if (size.cy < cHeight) and (size.cx < cWidth) then
  begin
    bStyle := Canvas.Brush.Style;
    Canvas.Brush.Style := bsClear;
    Canvas.Font.Color := clblack;

    Canvas.TextOut(rect.Left + Trunc((cWidth-size.cx)/2), topOrig + Trunc((cHeight-size.cy)/2), str );

    Canvas.Brush.Style := bStyle;
  end;

  ACanvas.Free;
end;

//----------------------------------------------------------------------------//

procedure PaintAlerts(rect: TRect; Canvas: TCanvas; recPaint: TRecDataPaint; ds: TDrawSlot);
var
  bmpIcon: TBitmap;
  curLeft,i,mainLeft: integer;
  ftm : TFMQMPlan;


  procedure ShowIcon(Pos : integer);
  var FirstRow,SecondRow : Integer;
  begin
    ftm := GetPlanView;
    ftm.ImageList1.GetBitmap(pos, bmpIcon);

    FirstRow := rect.Bottom - bmpIcon.Height - 25;
    SecondRow := rect.Bottom - bmpIcon.Height - 5;


   if (ds.m_SlotType <> Slt_wc) then
    begin
      FirstRow := rect.Bottom - bmpIcon.Height +1;
      SecondRow := rect.Bottom - bmpIcon.Height +1;
    end;

    if (curLeft + 5) <= (rect.Right) then
    begin
      //Mihailo
        if i <= 3 then
        begin
          Canvas.Draw(curLeft, SecondRow , bmpIcon);
          curLeft := curLeft + bmpIcon.Width + 5;
        end else
        begin  // 4-Number of icons in first row

          Canvas.Draw(MainLeft,  FirstRow, bmpIcon);
          if (ds.m_SlotType <> Slt_wc) then
            MainLeft := MainLeft + bmpIcon.Width + 5
          else
            curLeft := curLeft + bmpIcon.Width + 5;
        end;
    end;

     inc(i);
  end;

const
  MAX_RND = 97;

begin
  i := 0;
  if CSE_NoError in recPaint.errSet then
     exit;

  bmpIcon := TBitmap.Create;
  bmpIcon.Transparent := true;

  curLeft := rect.Left + 5;
  MainLeft := curLeft;
  if CSE_Materials in recPaint.errSet then
     ShowIcon(36);
  if CSE_AddRes in recPaint.errSet then
     ShowIcon(49);
  if CSE_HighEndDate in recPaint.errSet then
     ShowIcon(37);
  if CSE_LowStrDate in recPaint.errSet then
     ShowIcon(34);
  if CSE_LeftOvlp in recPaint.errSet then
     ShowIcon(38);
  if CSE_RightOvlp in recPaint.errSet then
     ShowIcon(39);
  if CSE_BothOvlp in recPaint.errSet then
     ShowIcon(40);

  bmpIcon.Free;
end;


end.

