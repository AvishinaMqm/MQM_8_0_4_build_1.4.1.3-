unit UGshapeMan;

interface

uses
  windows,
  classes,
  controls,
  graphics,
  stdCtrls,
  menus,
  UMRes,
  UMSchedContFunc,
  UGbaseCal,
  ExScrollBar;

type
  PTDateTime = ^TDateTime;

  TDurShape = class;
  TShapeManager = class;

  TCalcPos    = function  (date: TDateTime; calcObj: TObject): integer;
  TCalcDate   = function  (pos: integer; calcObj: TObject): TDateTime;
  TCalcWdw    = function  (isLeft: boolean; calcObj: TObject): TDateTime;
  TCalcCalZoom = function (calcObj: TObject): integer;
  TMouseUp    = procedure (parms: PTRowParms; date: TDateTime; mouObj: TObject; Button:TMouseButton; IsRes, isBK, SubResBtnClick: boolean );
  TMouseMove  = procedure (parms: PTRowParms; x,y: integer; mouObj: TObject);
  TDrawHeader = procedure (parms: PTRowParms; assObj: TObject; Canvas: TCanvas; x1,y1: integer);
  TFltrFunc   = function  (obj: TObject; RefObj: TObject): boolean;
  TApplyFunc  = procedure (parms: PTRowParms; ptr: pointer);
  TObjDraw    = procedure (ds: TDurShape; Canvas: TCanvas; shMan: TShapeManager);
  TDrawLink   = procedure (Link: PTLink; Canvas: TCanvas; assObj: TObject; shMan: TShapeManager);

  TDisplayRow   = class;

  TShConfig = class
    m_calcPos:    TCalcPos;
    m_calcDate:   TCalcDate;
    m_CalcCalZoom : TCalcCalZoom;
    m_calcWdw:    TCalcWdw;
    m_calcObj:    TObject;
    m_assObj:     TObject;
    m_mouUp:      TMouseUp;
    m_mouMove:    TMouseMove;
    m_mouObj:     TObject;
    m_drawHeader: TDrawHeader;
    m_LeftLimit:  TDateTime;
    m_RightLimit: TDateTime;
    m_today:      PTDateTime;
    m_todayAlgn:  PTDateTime;
    m_DrawLink:   TDrawLink;
    m_ApprovalDate : TDateTime;

    constructor Create;
  end;

  TDisplayRow = class(TObject)
  public
    m_shapeMan: TShapeManager;

    constructor Create(shapeMan: TShapeManager; obj: TObject; height: integer);
    destructor  Destroy; override;
    procedure   DeleteShapeList;
    procedure   AddShape(sh: TObject);
    procedure   SetVPos(top: integer); virtual;
    procedure   SelectByTime;
    function    GetParms: PTRowParms;

  private
    m_new: boolean;
    function  GetPlanParmsFromCoord(X, Y: integer): PTRowParms;
    procedure Paint(Canvas: TCanvas; isRow: boolean);
    procedure ApplyFunc(func: TApplyFunc; ptr: pointer);
    procedure NullParmsSupp;
  protected
    m_parms:  TRowParms;
    m_shList: TList;
    m_top:    integer;
    m_height: integer;
  end;

  TShPanel = class(TCustomControl)
    constructor CreateShow(AOwner: TComponent; isRow: boolean);
    procedure Paint; override;
  published
    property OnResize;
  private
    m_isRow: boolean;
    procedure MouMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure MouUp(Sender: TObject; Button:TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MouWeelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure MouWeelDwn(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
  public
    m_hintWdw: THintWindow;
  end;

  TShCalHndlr = class(TObject)
  public
    m_TimeList: TList;//lista di durate  rect
    m_TimeEfficList: TList;
    constructor CreateCalSh(lt, rt: TDateTime; cal: TPGCALObj);
    destructor Destroy; override;
  private
    m_cal: TPGCALObj;

    procedure Add(x1, x2: TDateTime);
    procedure AddEffic(x1, x2: TDateTime; Effic : double);
    procedure CheckAndAddEffic(StartDate : TDateTime; EndDate : TDateTime; Effic : double);
  end;

  TCalHndlr = class(TObject)
  public
    constructor CreateHd;
    destructor Destroy; override;
    procedure  Reset;
    procedure  InitializePeriod(lt, rt: TDateTime);
    procedure  HandleCal(cal: TPGCALObj);
    function   GetCalPos(cal: TPGCALObj): integer;
  private
    m_calList: TList;
    m_calShiftEfficList : TList;
    m_lt, m_rt: TDateTime;
  end;

  TCalShape = class(TObject)
  public
    // set data
    m_start: TDateTime;
    m_end:   TDateTime;
    m_effic: Double;
    constructor Create;
  end;

 // TShCalHndlr = class(TObject)

  TChgType = (chgTop, shUpd, chgNone);

  TShapeManager = class(TComponent)
    constructor CreateShapeMan(AOwner: TWinControl; rh, rw: integer;
                               var objList: TList; shConf: TShConfig; showCal: boolean);
    destructor  Destroy; override;

  protected
    m_dspList: TList;
    m_rw:      integer;

  private
    m_isActive:      boolean;
    m_today:         PTDateTime;
    m_todayAlgn:     PTDateTime;
    m_freezeScroll:  boolean;
    m_CalOffset:     integer;
    m_FilterFnc:     TFltrFunc;
    m_FilterObj:     TObject;
    m_topRow:        integer;
    m_bkgndColor:    TColor;
    m_calColor:      TColor;
    m_LinksList:     TList;


    function  CalcVisibleLn: integer;
    procedure ScrollChanged(Sender: TObject);
    procedure ShowHideScrollbar(visLn: integer);
    procedure PlanResized(Sender: TObject);
    function  GetPlanParmsFromCoord(X, Y: integer; var isBk: boolean): PTRowParms;
    function  GetRowParmsFromCoord(X, Y: integer): PTRowParms;

  public
    m_SetScrol:      boolean;  // avi
    m_rh:            integer;
    m_zoom:          boolean;
    m_CalHigh:       boolean;
    m_Backuped:      boolean;
    m_CalHndlr:      TCalHndlr;
    m_prntRes:       TShPanel;
    m_prntSh:        TShPanel;
    m_scroll:        TExScrollBar;//TScrollBar;
    m_applyFunc:     TApplyFunc;
    m_ptr:           pointer;

    m_calcPos:       TCalcPos;
    m_calcDate:      TCalcDate;
    m_CalcCalZoom:   TCalcCalZoom;
    m_calcWdw:       TCalcWdw;
    m_calcObj:       TObject;
    m_assObj:        TObject;
    m_mouUp:         TMouseUp;
    m_mouMove:       TMouseMove;
    m_mouObj:        TObject;
    m_drawHeader:    TDrawHeader;
    m_LeftLimit:     TDateTime;
    m_RightLimit:    TDateTime;
    m_ApprovalDate:  TDateTime;
    m_ResPopUpMenu:  TPopUpMenu;
    m_FreezeShapes:  boolean;
    m_objList:       ^TList;
    m_DrawLinkFunc:  TDrawLink;

    procedure TopRowChanged(newIxTop: integer);
    procedure NewRowsAdded(First: boolean);
    function  GetRowHeight: integer;
    procedure SetScrolbar(visLn: integer);    // avi
    procedure SetBkgndColor(colr: TColor);
    procedure SetCalHigh;
    procedure SetCalLow;
    procedure ShapesUpdate;
    procedure Update;
    procedure ClearCaches;
    procedure SetApplyFunc(func: TApplyFunc; ptr: pointer);

    function  GetRowYFromObj(ObjPtr: Pointer): integer;
    function  GetShapeForObj(Obj : Pointer):TDurShape;
    procedure Activate;
    procedure SetFilter(FltrFnc: TFltrFunc; RefObj: TObject);
    procedure RefreshHdr;
    procedure AddLink(StObj, EndObj: TObject; LinkType: TLinkType);
    procedure AddLinkList(LinkList: TList);
    procedure ClearLinks;

    property  p_TopRowIdx: integer     read m_TopRow;

  end;

  // base class for shapes that have a duration (i.e. start and end time)
  // on the Gantt

  TDurShape = class(TObject)
    m_row:      TDisplayRow;
    m_parms:    TRowParms;
    m_rect:     TRect;
    m_drwFnc:   TDurShDraw;
    m_ip:       integer;
    m_mp:       integer;

    constructor CreateDurShape(dspRow: TDisplayRow; parms: PTRowParms; fnc: TDurShDraw);
    destructor  Destroy; override;
    procedure   SetPos(calcPos: TCalcPos; calcObj: Tobject);
  end;

  function  GetLimitLeftDate : TDateTime;
  function  GetLimitRightDate : TDateTime;

implementation

uses
  extctrls,
  sysutils,
  forms,
  UMGlobal,
  UMCompatClr,
  dialogs;

const
  VO_PG = 3;            // vert. offset of calendar shapes from top of resource line
//  LIMIT_COL1 = $009B9CCE;
  LIMIT_COL1 = $0095FFFA;
  LIMIT_OUT  = $00EFEBE8;//$00D9D9FA;//14671839;

  LIMIT_COL3 = $0095CCFA;
  LIMIT_COL4 = $00009BFF;

  CL_MATERIAL_LIMIT = $0000F3FF;
  CL_SRAT_END_STDPURCORD = $0031A440;
  CL_ADDRES_LIMIT = $0070B0FF; //$000080FF (was saturated orange); soft peach-orange
  CL_OVLP_LIMIT   = $00A09080; //$00232D41 (was near-black); soft blue-gray


// -------------------------------------------------------------------------- //
// TShapeManager                                                              //
// -------------------------------------------------------------------------- //

var
  m_LimitStartDate : TDateTime;
  m_LimitEndDate : TDateTime;

constructor TShapeManager.CreateShapeMan(AOwner: TWinControl; rh, rw: integer;
                                         var objList: TList; shConf: TShConfig;
                                         showCal: boolean);
begin
  inherited Create(AOwner);
  AOwner.DoubleBuffered := true;
  m_rh := rh;
  m_rw := rw;

  m_isActive     := false;

  m_freezeScroll := true;
  m_FreezeShapes := true;
  m_CalOffset    := 0;
  m_zoom         := false;
  m_CalHigh      := false;
  m_Backuped     := false;
  m_objList      := @objList;
  m_dspList      := TList.Create;

  if showCal then
    m_CalHndlr := TCalHndlr.CreateHd
  else
    m_CalHndlr := nil;

  m_calcPos       := shConf.m_calcPos;
  m_calcDate      := shConf.m_CalcDate;
  m_CalcCalZoom   := shConf.m_CalcCalZoom;
  m_calcWdw       := shConf.m_calcWdw;
  m_calcObj       := shConf.m_calcObj;
  m_assObj        := shConf.m_assObj;
  m_mouUp         := shConf.m_MouUp;
  m_mouMove       := shConf.m_MouMove;
  m_mouObj        := shConf.m_mouObj;
  m_drawHeader    := shConf.m_drawHeader;
  m_LeftLimit     := shConf.m_LeftLimit;
  m_RightLimit    := shConf.m_RightLimit;
  m_today         := shConf.m_today;
  m_todayAlgn     := shConf.m_todayAlgn;
  m_DrawLinkFunc  := shConf.m_DrawLink;
  m_ApprovalDate  := shConf.m_ApprovalDate;

  m_FilterFnc  := nil;
  m_FilterObj  := nil;

  m_prntRes := TShPanel.CreateShow(self, true);
  with m_prntRes do
  begin
    Parent  := AOwner;
    Align   := alLeft;
    Width   := m_rw;
  end;

  m_prntSh  := TShPanel.CreateShow(self, false);
  with m_prntSh do
  begin
    Parent   := AOwner;
    Align    := alClient;
    OnResize := PlanResized;
  end;

  m_scroll := TExScrollBar.Create(self);
  with m_scroll do
  begin
    Parent      := m_prntSh;
    Kind        := sbVertical;
    Visible     := false;
    TabStop     := false;
    Align       := alRight;
    Min         := 0;
    Width       := 17;
    ColorArrows := Cl_STNDRD_LIGHT_BLUE;
    ColorThumbRect := Cl_STNDRD_LIGHT_BLUE;
  //  ColorBorder := clWhite;
    ColorBorderButton := clWhite;
    ThumbType := tsRoundRect;
    ShowCornerButtons := false;
   // color  := clred;
    Radius := 10;
    position := 0;
    thumbsize := 25;
    //SmallChange := 1;
    OnChange    := ScrollChanged
  end;

  m_applyFunc := nil;
  m_ptr       := nil;
end;

//----------------------------------------------------------------------------//

destructor TShapeManager.Destroy;
var
  i: integer;
begin
  for i := 0 to m_dspList.Count - 1 do
    TDisplayRow(m_dspList[i]).Free;

  m_dspList.Free;
  m_objList.Free;
  m_linksList.Free;

  inherited Destroy
end;

//----------------------------------------------------------------------------//

function TShapeManager.CalcVisibleLn: integer;
begin
  Result := m_prntSh.Height div m_rh;
  if (Result * m_rh) < m_prntSh.Height then
    Inc(Result);
end;

//----------------------------------------------------------------------------//

procedure TShapeManager.Update;
begin
  shapesUpdate
end;

//----------------------------------------------------------------------------//

procedure TShapeManager.ClearCaches;
begin
  m_CalHndlr.Reset
end;

//----------------------------------------------------------------------------//

procedure TShapeManager.SetApplyFunc(func: TApplyFunc; ptr: pointer);
var
  i, j:  integer;
  dr: TDisplayRow;
begin
  m_applyFunc := func;
  m_ptr := ptr;

  if Assigned(func) then
    for i := 0 to m_dspList.Count - 1 do
    begin
      dr := TDisplayRow(m_dspList[i]);
      func(@(dr.m_parms), m_ptr);
      if dr.m_parms.isReadOnly then
        continue;
      dr.ApplyFunc(func, m_ptr)
    end
  else
    for i := 0 to m_dspList.Count - 1 do
    begin
      dr := TDisplayRow(m_dspList[i]);
      dr.m_parms.OvlpLmtL := 0;
      dr.m_parms.OvlpLmtR := 0;
      if Assigned(dr.m_parms.NoMaterialList) then
      begin
        for j := 0 to dr.m_parms.NoMaterialList.Count - 1 do
          dispose(PTRecNoMatDate(dr.m_parms.NoMaterialList[j]));
        dr.m_parms.NoMaterialList.Free;
        dr.m_parms.NoMaterialList := nil
      end;
      if Assigned(dr.m_parms.NoAddResList) then
      begin
        for j := 0 to dr.m_parms.NoAddResList.Count - 1 do
          dispose(PTRecNoMatDate(dr.m_parms.NoAddResList[j]));
        dr.m_parms.NoAddResList.Free;
        dr.m_parms.NoAddResList := nil
      end;
      if Assigned(dr.m_parms.NoPrevStepList) then
      begin
        for j := 0 to dr.m_parms.NoPrevStepList.Count - 1 do
          dispose(dr.m_parms.NoPrevStepList[j]);
        dr.m_parms.NoPrevStepList.Free;
        dr.m_parms.NoPrevStepList := nil
      end;

      if dr.m_parms.isReadOnly then
        continue;
      dr.m_parms.suppVal1 := -1;
      dr.NullParmsSupp
    end;

  m_prntSh.Refresh;
  m_prntRes.Refresh
end;

//----------------------------------------------------------------------------//

procedure TShapeManager.TopRowChanged(newIxTop: integer);
// This is the procedure called when:
// o   the size of the Gantt panel changes
// o   the Gantt scrolls vertically (scrollbar) or horizontally (calendar)
var
  t1, b1: integer;    // current top and bottom
  t2, b2: integer;    // new top and bottom
  i: integer;
  visLn: integer;
  lt,rt:   TDateTime;
  ltC,rtC: TDateTime;
begin
  lt := m_calcWdw(true,  m_calcObj);
  rt := m_calcWdw(false, m_calcObj);

  if Assigned(m_CalHndlr) then
  begin
    ltC := lt;
//sav    if (m_LeftLimit > 0) and (lt < m_LeftLimit) then
//sav      ltC := m_leftLimit;

    rtC := rt;
//sav    if (m_RightLimit > 0) and (rt > m_rightLimit) then
//sav      rtC := m_rightLimit;

    m_CalHndlr.InitializePeriod(ltC, rtC)
  end;

  visLn := CalcVisibleLn;
//  ShowHideScrollBar(visLn);

  // clamp newIxTop to valid range to prevent empty display
  if m_objList.Count = 0 then
    newIxTop := 0
  else if newIxTop >= m_objList.Count then
    newIxTop := m_objList.Count - 1
  else if newIxTop < 0 then
    newIxTop := 0;

  t1 := m_topRow;
  b1 := t1 + m_dspList.Count - 1;
  t2 := newIxTop;
  b2 := t2 + visLn - 1;
  if b2 > m_objList.Count-1 then
    b2 := m_objList.Count-1;

  m_topRow := newIxTop;
  ShowHideScrollBar(visLn);

  if (b2 < t1) or (t2 > b1) then
  begin

    // no intersection between the current and the new set
    // remove all row objects and add new objects
    for i := 0 to m_dspList.Count - 1 do TObject(m_dspList[i]).Free;
    m_dspList.Clear;
    for i := t2 to b2 do m_dspList.Add(TDisplayRow.Create(self, (m_objList^)[i], m_rh));
  end else
  begin

    // first work on top position
    if t2 < t1 then
      // add new resources at the top
      for i := t1 - 1 downto t2 do
        m_dspList.Insert(0, TDisplayRow.Create(self, (m_objList^)[i], m_rh))
    else if t2 > t1 then
    begin
      // remove old resources at the top
      for i := t1 to t2 - 1 do
      begin
        TObject(m_dspList[0]).Free;
        m_dspList.Delete(0)
      end
    end;

    // now work on bottom position
    if b2 < b1 then
      // remove resources at the bottom
      for i := b2 + 1 to b1 do
      begin
        TObject(m_dspList[m_dspList.Count-1]).Free;
        m_dspList.Delete(m_dspList.Count - 1)
      end
    else if b2 > b1 then
      // add resources at the bottom
      for i := b1 + 1 to b2 do
        m_dspList.Add(TDisplayRow.Create(self, (m_objList^)[i], m_rh))
  end;

  for i := 0 to m_dspList.Count - 1 do
    with TDisplayRow(m_dspList[i]) do
    begin
      if Assigned(m_CalHndlr) then m_CalHndlr.HandleCal(m_parms.calendar);
      if m_new = true then SelectByTime; // empties the lists too
      SetVPos(i * m_rh)     // sets position of children too
    end;

  m_prntRes.Refresh;
  m_prntSh.Refresh;

end;

//----------------------------------------------------------------------------//

procedure TShapeManager.ShapesUpdate;
var
  i:       integer;
  lt,rt:   TDateTime;
  ltC,rtC: TDateTime;
begin

  if m_FreezeShapes then exit;

  lt := m_calcWdw(true,  m_calcObj);
  rt := m_calcWdw(false, m_calcObj);

  if Assigned(m_CalHndlr) then
  begin
    ltC := lt;
//sav    if (m_LeftLimit > 0) and (lt < m_LeftLimit) then
//sav      ltC := m_leftLimit;

    rtC := rt;
//sav    if (m_RightLimit > 0) and (rt > m_rightLimit) then
//sav      rtC := m_rightLimit;

    m_CalHndlr.InitializePeriod(ltC, rtC)
  end;

  for i := 0 to m_dspList.Count - 1 do
    with TDisplayRow(m_dspList[i]) do
    begin
      if Assigned(m_CalHndlr) then
        m_CalHndlr.HandleCal(m_parms.calendar);
      SelectByTime;         // empties the lists too
      SetVPos(i * m_rh)     // sets position of children too
    end;

  m_prntSh.Refresh;
  m_prntRes.Refresh

end;

//----------------------------------------------------------------------------//

procedure TShapeManager.NewRowsAdded(first: boolean);
var
  i:       integer;
  visLn:   integer;
begin
  visLn := CalcVisibleLn;
  for i := 0 to m_dspList.Count - 1 do TDisplayRow(m_dspList[i]).free;
  m_dspList.Clear;
  if m_objList.Count = 0 then
  begin
    m_topRow := 0;
    m_prntRes.Refresh;
    m_prntSh.Refresh;
    ShowHideScrollbar(visLn);
    exit
  end;

  if first then
  begin
    m_topRow := 0;
//sav    m_scroll.Position := 0
  end;

  ShowHideScrollbar(visLn);

  if (m_topRow + visLn) > m_objList.Count then
    visLn := m_objList.Count - m_topRow;

//  for i := 0 to m_dspList.Count - 1 do TDisplayRow(m_dspList[i]).free;   //avi
//    m_dspList.Clear;

  for i := 0 to visLn - 1 do
    m_dspList.Add(TDisplayRow.Create(self, (m_objList^)[m_topRow+i], m_rh));

  ShapesUpdate
end;

//----------------------------------------------------------------------------//

procedure TShapeManager.ScrollChanged(Sender: TObject);
begin
  if not m_freezeScroll then
    TopRowChanged(m_scroll.Position);
end;

//----------------------------------------------------------------------------//

procedure TShapeManager.PlanResized(Sender: TObject);
begin
  NewRowsAdded(false)
end;

//----------------------------------------------------------------------------//

procedure TShapeManager.ShowHideScrollbar(visLn: integer);
begin
{sav
  if (m_objList.Count = 0) then  // avi
  begin
    if m_scroll.Visible then
      m_scroll.Visible := false;
    exit;
  end;

  if (visLn >= m_objList.Count) and (m_topRow = 0) and not m_SetScrol then
  begin
    if m_scroll.Visible then m_scroll.Visible := false
  end else
}
  if (visLn >= m_objList.Count) and (m_topRow = 0) then
  begin
    if m_scroll.Visible then m_scroll.Visible := false  //sav
  end else
  begin
    m_freezeScroll := true;
    m_scroll.Max   := m_objList.Count-1;
    m_scroll.Position := m_topRow; //sav
    m_freezeScroll := false;
    if not m_scroll.Visible then m_scroll.Visible := true;
  end
end;

//----------------------------------------------------------------------------//

procedure TShapeManager.SetScrolbar(visLn: integer);  // Avi
begin
  if (not m_scroll.Visible) and (m_objList.count > 1) then
  begin
    m_scroll.Visible := true;
    m_SetScrol := true;
  end;
  m_scroll.Position := m_topRow;
end;

//----------------------------------------------------------------------------//

function TShapeManager.GetPlanParmsFromCoord(X, Y: integer; var isBk: boolean): PTRowParms;
var
  row: integer;
begin
  Result := nil;
  isBk   := true;

  row := Y div m_rh;
  if row >= m_dspList.Count then exit;

  Result := TDisplayRow(m_dspList[row]).GetPlanParmsFromCoord(X, Y);

  if Result = nil then exit;

  if assigned(Result) then
    isBk := false
  else
    Result := @(TDisplayRow(m_dspList[row]).m_parms)
end;

//----------------------------------------------------------------------------//

function TShapeManager.GetRowParmsFromCoord(X, Y: integer): PTRowParms;
var
  row: integer;
begin
  Result := nil;
  row := Y div m_rh;
  if row >= m_dspList.Count then exit;

  Result := @(TDisplayRow(m_dspList[row]).m_parms);
  Result.Row := row;
  Result.RH := m_rh;
end;

//----------------------------------------------------------------------------//

function TShapeManager.GetRowYFromObj(ObjPtr: Pointer): integer;
var
  i: integer;
begin
  Result := -1;

  for i := 0 to m_dspList.Count -1 do
  begin
    if TDisplayRow(m_dspList[i]).m_parms.objPtr = ObjPtr then
    begin
      Result := (m_topRow - i) * m_rh;
      break
    end;
  end;

end;

//----------------------------------------------------------------------------//

function GetHigherColor(color: TColor): TColor;
var
  maxUp:   integer;
  maxVal:  integer;
  r, g, b: integer;
begin
  r := (color and $000000FF);
  g := (color and $0000FF00) shr 8;
  b := (color and $00FF0000) shr 16;

  // if any color is too near to saturation move to a reasonable value
  if r > $000000D0 then r := $000000D0;
  if g > $000000D0 then g := $000000D0;
  if b > $000000D0 then b := $000000D0;

  // get the highest color value
  maxVal := r;
  if g > maxVal then maxVal := g;
  if b > maxVal then maxVal := b;

  // try to find a higher value or saturate
  if (maxVal + $00000020) > $000000FF then
    maxUp := $000000FF - maxVal
  else
    maxUp := $00000020;

  r := r + maxUp;
  g := g + maxUp;
  b := b + maxUp;

  Result := (b shl 16) + (g shl 8) + r
end;

//----------------------------------------------------------------------------//

function GetLowerColor(color: TColor): TColor;
var
  maxDn:   integer;
  minVal:  integer;
  r, g, b: integer;
begin
  r := (color and $000000FF);
  g := (color and $0000FF00) shr 8;
  b := (color and $00FF0000) shr 16;

  // if any color is too near to 0 move to a reasonable value
  if r < $00000020 then r := $00000020;
  if g < $00000020 then g := $00000020;
  if b < $00000020 then b := $00000020;

  // get the lowest color value
  minVal := r;
  if g < minVal then minVal := g;
  if b < minVal then minVal := b;

  // try to find a lower value or go to 0
  if (minVal - $00000020) < $00000000 then
    maxDn := minVal
  else
    maxDn := $00000020;

  r := r - maxDn;
  g := g - maxDn;
  b := b - maxDn;

  Result := (b shl 16) + (g shl 8) + r
end;

//----------------------------------------------------------------------------//

procedure TShapeManager.SetCalHigh;
begin
  m_calColor := GetHigherColor(m_bkgndColor);
  m_CalHigh := true
end;

//----------------------------------------------------------------------------//

procedure TShapeManager.SetCalLow;
begin
  m_calColor := GetLowerColor(m_bkgndColor);
  m_CalHigh := false
end;

//----------------------------------------------------------------------------//

procedure TShapeManager.SetBkgndColor(colr: TColor);
begin
  m_bkgndColor := colr;
  m_calColor   := GetLowerColor(colr);

  m_prntRes.Brush.Color := colr;
  m_prntSh.Brush.Color  := colr
end;

//----------------------------------------------------------------------------//

function TShapeManager.GetRowHeight: integer;
begin
  Result := m_rh
end;

//----------------------------------------------------------------------------//

procedure TShapeManager.Activate;
begin
  m_isActive := true;
  NewRowsAdded(true)
end;

//----------------------------------------------------------------------------//

procedure TShapeManager.SetFilter(FltrFnc: TFltrFunc; RefObj: TObject);
begin
  m_FilterFnc  := FltrFnc;
  m_FilterObj  := RefObj;
  ShapesUpdate
end;

//----------------------------------------------------------------------------//

procedure TShapeManager.RefreshHdr;
begin
  m_prntRes.Refresh
end;

//----------------------------------------------------------------------------//

procedure TShapeManager.AddLink(StObj, EndObj: TObject; LinkType: TLinkType);
var
  LinkObjs: PTLink;
begin
  if not Assigned(m_linksList) then
    m_LinksList := Tlist.Create;

  new(LinkObjs);
  LinkObjs.LK_StObj     := StObj;
  LinkObjs.LK_EndObj    := EndObj;
  LinkObjs.LK_Type      := LinkType;

  m_LinksList.Add(LinkObjs)
end;

//----------------------------------------------------------------------------//

procedure TShapeManager.AddLinkList(LinkList: TList);
var
  i: integer;
begin
  if not Assigned(m_linksList) then
    m_LinksList := Tlist.Create;

  for i := 0 to LinkList.Count-1 do
    m_LinksList.Add(LinkList[i])
end;

//----------------------------------------------------------------------------//

procedure TShapeManager.ClearLinks;
var
  i: integer;
begin
  if not Assigned(m_linksList) then
    exit;

  for i := 0 to m_LinksList.Count-1 do
    Dispose(m_LinksList[i]);

  m_LinksList.Clear
end;
// -------------------------------------------------------------------------- //
// TShPanel                                                                   //
// -------------------------------------------------------------------------- //

constructor TShPanel.CreateShow(AOwner: TComponent; isRow: boolean);
begin
  inherited Create(AOwner);
  m_isRow := isRow;
  m_hintWdw := nil;

//  if not m_isRow then
    OnMouseMove := MouMove;
  OnMouseUp := MouUp;

  OnMouseWheelDown := MouWeelDwn;
  OnMouseWheelUp   := MouWeelUp
end;

//----------------------------------------------------------------------------//

procedure TShPanel.Paint;
var
  shp:  TShapeManager;
  pos:  integer;
  maxY: integer;
  i:    integer;
  ds:   TDisplayRow;
begin
  inherited Paint;

  shp := TShapeManager(Owner);
  if shp.m_dspList.Count = 0 then exit;

  maxY := height;
  if maxY > (shp.m_dspList.Count * shp.m_rh) then
    maxY := (shp.m_dspList.Count * shp.m_rh);

  if not m_isRow then
  begin
    pos := shp.m_rh;
    Canvas.Pen.Width := 1;
    Canvas.Pen.Color := clLtGray;
    Canvas.Pen.Style := psSolid;
    while true do
    begin
      Canvas.MoveTo(0, pos);
      Canvas.LineTo(width, pos);
      pos := pos + shp.m_rh;
      if pos > maxY then break
    end
  end;

  for i := 0 to shp.m_dspList.Count-1 do
  begin
    ds := TDisplayRow(shp.m_dspList[i]);
    try
      ds.Paint(Canvas, m_isRow)
    except

    end;
  end;

  //Paint links
  if Assigned(shp.m_LinksList) and Assigned(shp.m_DrawLinkFunc) and not m_isRow then
    for i := 0 to shp.m_LinksList.Count-1 do
    begin
      shp.m_DrawLinkFunc(PTLink(shp.m_LinksList[i]), Canvas, shp.m_assObj, shp)
    end;

end;

//----------------------------------------------------------------------------//

procedure TShPanel.MouMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
var
  sh:    TShapeManager;
  parms: PTRowParms;
  isBk:  boolean;
begin
  if y < 1 then exit;
  sh := TShapeManager(Owner);
  if not Assigned(sh.m_mouMove) then exit;

  if Sender = nil then exit;

  if Sender = sh.m_prntSh then
  begin
    parms := sh.GetPlanParmsFromCoord(X, Y, isBk);
    Assert(Assigned(sh.m_calcDate));
    sh.m_mouMove(parms, x, y, sh.m_mouObj)
  end else
  begin
    if Sender = sh.m_prntRes then
    begin
      parms := sh.GetRowParmsFromCoord(X, Y);
      if Assigned(sh.m_mouObj) then
        sh.m_mouMove(parms, x, y, sh.m_mouObj)
    end
  end;
end;

//----------------------------------------------------------------------------//

procedure TShPanel.MouUp(Sender: TObject; Button:TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  sh:    TShapeManager;
  parms: PTRowParms;
  date:  TDateTime;
  isBk:  boolean;
  SubResBtnClick: boolean;
begin
  if y < 1 then exit;
  sh := TShapeManager(Owner);
  if Sender = sh.m_prntSh then
  begin
    if Assigned(sh.m_mouUp) then
    begin
      parms := sh.GetPlanParmsFromCoord(X, Y, isBk);
      Assert(Assigned(sh.m_calcDate));
      date := sh.m_calcDate(X, sh.m_calcObj);
//sav      if (date >= sh.m_LeftLimit) and (date <= sh.m_RightLimit)
//sav      or (sh.m_LeftLimit = 0) or (sh.m_RightLimit = 0) then
        sh.m_mouUp(parms, date, sh.m_mouObj, Button, false, isBk, false)
    end;
  end else
  begin
    if Sender = sh.m_prntRes then
    begin
      parms := sh.GetRowParmsFromCoord(X, Y);
      Assert(Assigned(sh.m_calcDate));
      date := sh.m_calcDate(X, sh.m_calcObj);

      // calc if button for collapse/expand sub resources is clicked
      SubResBtnClick := false;
      try
        //if (X > 86) and (X < 96) and
       // if //(X > 79) and (X < 89) and
       //    (Y > ((parms.Row+1)*parms.rh)-parms.RH+(40+(parms.RH-50))) and (Y < (parms.Row+1)*parms.rh) then
            SubResBtnClick := true;
        if Assigned(sh.m_mouObj) then
          sh.m_mouUp(parms, date, sh.m_mouObj, Button, true, isBk, SubResBtnClick)
      except
      end;
    end
  end
end;

// -------------------------------------------------------------------------- //

procedure TShPanel.MouWeelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
var
  sh: TShapeManager;
begin
  sh := TShapeManager(Owner);
  if Assigned(sh.m_scroll) and (sh.m_scroll.Visible = true) then
    sh.m_scroll.Position := sh.m_scroll.Position -1
end;

// -------------------------------------------------------------------------- //

procedure TShPanel.MouWeelDwn(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
var
  sh: TShapeManager;
begin
  sh := TShapeManager(Owner);
  if Assigned(sh.m_scroll) and (sh.m_scroll.Visible = true) then
    sh.m_scroll.Position := sh.m_scroll.Position +1
end;

// -------------------------------------------------------------------------- //
// TShConfig                                                                  //
// -------------------------------------------------------------------------- //

constructor TShConfig.Create;
begin
  m_calcPos    := nil;
  m_calcDate   := nil;
  m_calcWdw    := nil;
  m_calcObj    := nil;
  m_mouUp      := nil;
  m_mouObj     := nil;
  m_drawHeader := nil
end;

// -------------------------------------------------------------------------- //
// TDisplayRow                                                                //
// -------------------------------------------------------------------------- //

constructor TDisplayRow.Create(shapeMan: TShapeManager; obj: TObject; height: integer);
begin
  inherited Create;
  m_shapeMan       := shapeMan;
  m_height         := height;
  m_parms.suppVal1 := -1;
  m_parms.suppVal2 := -1;
  m_parms.objPtr   := obj;
  m_parms.calendar := TMqmVisibleRes(obj).p_Calendar;
  m_new            := true;
  m_shList         := nil;
  if Assigned(m_shapeMan.m_applyFunc) then
    m_shapeMan.m_applyFunc(@m_parms, m_shapeMan.m_ptr)
end;

//----------------------------------------------------------------------------//

destructor TDisplayRow.Destroy;
begin
  DeleteShapeList;
  inherited Destroy
end;

//----------------------------------------------------------------------------//

procedure TDisplayRow.DeleteShapeList;
var
  i: integer;
begin
  if Assigned(m_shList) then
  begin
    for i := 0 to m_shList.Count-1 do
      TShape(m_shList[i]).Free;
    m_shList.Free;
    m_shList := nil
  end
end;

//----------------------------------------------------------------------------//

procedure TDisplayRow.AddShape(sh: TObject);
begin
  if not Assigned(m_shList) then
    m_shList := TList.Create;

  m_shList.Add(sh)
end;

//----------------------------------------------------------------------------//

function TDisplayRow.GetParms: PTRowParms;
begin
  Result := @m_parms
end;

//----------------------------------------------------------------------------//

function TDisplayRow.GetPlanParmsFromCoord(X, Y: integer): PTRowParms;
var
  i:     integer;
  ObjDs,
  ds:    TDurShape;
begin
  Result := nil;

  if not Assigned(m_shList) then exit;
  ObjDs  := nil;

  for i := 0 to m_shList.Count-1 do
  begin
    ds := TDurShape(m_shList[i]);
    with ds.m_rect do
      if (X >= Left) and (X <= Right) and
         (Y >= Top)  and (Y <= Bottom) then
      begin
        if not Assigned(ObjDs) then
          ObjDs := ds
        else if ds.m_parms.lev < ObjDs.m_parms.lev then
          ObjDs := ds;
        if ObjDs.m_parms.lev = 0 then break
      end
  end;

  if Assigned(ObjDs) then Result := @ObjDs.m_parms
end;

//----------------------------------------------------------------------------//

procedure AngleTextOut(ACanvas: TCanvas; Angle, X, Y: Integer; Str: string);
var
  LogRec: TLogFont;
  OldFontHandle,
  NewFontHandle: hFont;
begin
  GetObject(ACanvas.Font.Handle, SizeOf(LogRec), Addr(LogRec));
  LogRec.lfEscapement := Angle*10;
  NewFontHandle := CreateFontIndirect(LogRec);
  OldFontHandle := SelectObject(ACanvas.Handle, NewFontHandle);
  ACanvas.TextOut(X, Y, Str);
  NewFontHandle := SelectObject(ACanvas.Handle, OldFontHandle);
  DeleteObject(NewFontHandle);
end;

//----------------------------------------------------------------------------//

procedure DrawObjDesc(var cvs: TCanvas; var rect: TRect; desc: string);
var
  txthOfs,
  txtvOfs: integer;
  oldStyle:  TBrushStyle;
  OldColor: TColor;
begin
  oldStyle := cvs.Brush.Style;
  OldColor := cvs.Font.Color;
  cvs.Brush.Style := bsClear;
  cvs.Font.Style := [fsBold];
  cvs.font.color := clWhite;

  with rect do
  begin
    if Left < 0 then Left := 0;

    if ((Bottom - Top) > cvs.TextHeight(desc)) and
       ((Right - Left) > cvs.TextWidth(desc)) then
    begin

      txthOfs := ((Right - Left) div 2) - (cvs.TextWidth(desc) div 4);
      txtvOfs := ((Bottom - Top) - 2   ) - (cvs.TextHeight(desc) div 2) -1;

     { txthOfs := ((Right - Left) div 2) - (cvs.TextWidth(desc) div 2);
      txtvOfs := ((Bottom - Top) div 2) - (cvs.TextHeight(desc) div 2)-1;  }
      if (Bottom - Top) > cvs.TextWidth(desc) + 10 then
        //cvs.TextOut(Left + txthOfs, Top + cvs.pen.Width + txtvOfs, desc)
        AngleTextOut(cvs,90, Left + txthOfs, Top + cvs.pen.Width + txtvOfs, desc);
    end
  end;
  cvs.Brush.Style := oldStyle;
  cvs.Font.Color := OldColor;
end;

//----------------------------------------------------------------------------//

procedure TDisplayRow.Paint(Canvas: TCanvas; isRow: boolean);
var
  CalPos,i,left,right: integer;
  LeftLimitPos, RightLimitPos, ApprovalDate: integer;
  LeftOvlpLmtPos, RightOvlpLmtPos: integer;
  CalRect: TRect;
  SavedFontSize, X : Integer;
  ds: TDurShape;
  oldBrushColor, oldPenColor: TColor;
  oldBrushStyle: TBrushStyle;
  oldPenStyle: TPenStyle;
  tmList:        TList;
  RecNoMatDate: PTRecNoMatDate;
  int, brd, txt: TColor;
  MaterialDatesList : TList;
begin
  Canvas.font.Name := 'Montserrat';
  if isRow then
    m_shapeMan.m_DrawHeader(@m_parms, m_shapeMan.m_assObj, Canvas, 0, m_top)
  else
  begin
    oldBrushColor := Canvas.Brush.Color;
    oldPenColor   := Canvas.Pen.Color;
    oldBrushStyle := Canvas.Brush.Style;
    oldPenStyle   := Canvas.Pen.Style;
    LeftLimitPos  := m_shapeMan.m_CalcPos(m_shapeMan.m_LeftLimit, m_shapeMan.m_calcObj);
    RightLimitPos := m_shapeMan.m_CalcPos(m_shapeMan.m_RightLimit, m_shapeMan.m_calcObj);
    ApprovalDate  := m_shapeMan.m_CalcPos(m_shapeMan.m_ApprovalDate, m_shapeMan.m_calcObj);
    LeftOvlpLmtPos  := m_shapeMan.m_CalcPos(m_parms.OvlpLmtL, m_shapeMan.m_calcObj);
    RightOvlpLmtPos := m_shapeMan.m_CalcPos(m_parms.OvlpLmtR, m_shapeMan.m_calcObj);
    Canvas.Pen.Style := psSolid;

    if Assigned(m_shapeMan.m_CalHndlr) then
    with m_shapeMan do
    begin
      CalPos := m_CalHndlr.GetCalPos(m_parms.calendar);
      Canvas.Brush.Color := m_calColor;

      //Paint calendar shapes

      if assigned(m_CalHndlr.m_calList) and (CalPos > -1) and (CalPos < m_CalHndlr.m_calList.Count) then
      begin
        tmList := TShCalHndlr(m_CalHndlr.m_calList[CalPos]).m_TimeList;

        for i := 0 to tmList.count-1 do
        begin
          Left  := m_CalcPos(TCalShape(tmList[i]).m_start, m_calcObj);
          Right := m_CalcPos(TCalShape(tmList[i]).m_end, m_calcObj);
{reverse calendar color out of suggested dates
        if ((m_LeftLimit > 0) and (Right < LeftLimitPos))
        or ((m_RightLimit > 0) and (Left > RightLimitPos)) then
        begin
          if m_calColor = GetHigherColor(m_bkgndColor) then
            Canvas.Brush.Color := GetLowerColor(m_bkgndColor)
          else
            Canvas.Brush.Color := GetHigherColor(m_bkgndColor);
        end else
          Canvas.Brush.Color := m_calColor;
}
          CalRect.Left := Left;
          CalRect.Right := Right;
          CalRect.Top := m_top + VO_PG;
          CalRect.Bottom := m_top + m_rh - VO_PG;
          Canvas.FillRect(CalRect)
        end;

        tmList := TShCalHndlr(m_CalHndlr.m_calList[CalPos]).m_TimeEfficList;

        oldBrushColor := Canvas.Brush.Color;
        for i := 0 to tmList.count-1 do
        begin

          Left  := m_CalcPos(TCalShape(tmList[i]).m_start, m_calcObj);
          Right := m_CalcPos(TCalShape(tmList[i]).m_end, m_calcObj);

          Canvas.Brush.Color := 9211202; //ClSilver;
          CalRect.Left := Left;
          CalRect.Right := Right;
          CalRect.Top := m_top + VO_PG;
          CalRect.Bottom := m_top + m_rh - VO_PG;

          SavedFontSize := 10; //Canvas.Font.Size; Mihailo
          Canvas.Font.Size := SavedFontSize - 2;
          Canvas.FillRect(CalRect);
          if TCalShape(tmList[i]).m_effic < 100 then
            DrawObjDesc(Canvas, CalRect, FloatToStr(TCalShape(tmList[i]).m_effic) + '%' )
          else
            DrawObjDesc(Canvas, CalRect, 'X' + FloatToStr(trunc(TCalShape(tmList[i]).m_effic)/ 100));
          Canvas.Font.Size := SavedFontSize;
        end;
        Canvas.Brush.Color := oldBrushColor;
      end;
    end;

    // Draw Limits
    if m_shapeMan.m_LeftLimit > 0 then
    begin
      CalRect.Left   := 0;
      CalRect.Right  := LeftLimitPos;
      CalRect.Top    := m_top + 1;
      CalRect.Bottom := m_top + m_shapeMan.m_rh - 1;

      Canvas.Brush.Color := LIMIT_OUT;//$0031A440;
      Canvas.Pen.Color   := LIMIT_OUT;//$0031A440;
      Canvas.Brush.Style := bsFDiagonal; //psSolid
      Canvas.Pen.Width   := 1;
      Canvas.Rectangle(CalRect);
    end;

    if (m_shapeMan.m_RightLimit > 0) then
    begin
      CalRect.Left := RightLimitPos;
      CalRect.Right  := m_shapeMan.m_prntSh.Left+ m_shapeMan.m_prntSh.Width;
      CalRect.Top    := m_top + 1;
      CalRect.Bottom := m_top + m_shapeMan.m_rh - 1;
      Canvas.Brush.Color := LIMIT_OUT;//clwhite;//$0031A440;
      Canvas.Pen.Color :=   LIMIT_OUT;//clwhite;//$0031A440;
      Canvas.Brush.Style := bsFDiagonal;  //psSolid
      Canvas.Pen.Width := 1;
      Canvas.Rectangle(CalRect);
    end;

    if (m_shapeMan.m_ApprovalDate > 0) then
    begin
      Canvas.Pen.Width := 3;
      GetClrFromArr(3, DBAppGlobals.JobDateWarningColor, int, brd, txt);
      Canvas.Pen.Color := int;
      Canvas.MoveTo(ApprovalDate, m_top);
      Canvas.LineTo(ApprovalDate, m_top + m_shapeMan.m_rh);
    end;


{Old overlap
    if m_parms.OvlpLmtL > 0 then
    begin
      CalRect.Left   := 0;
      CalRect.Right  := LeftOvlpLmtPos;
      CalRect.Top    := m_top + 1;
      CalRect.Bottom := m_top + m_shapeMan.m_rh - 1;

      Canvas.Brush.Color := Update is available;
      Canvas.Pen.Color   := LIMIT_COL1;
      Canvas.Brush.Style := bsDiagCross;
      Canvas.Pen.Width   := 1;
      Canvas.Rectangle(CalRect);
    end else
      if m_parms.OvlpLmtL < 0 then
      begin
        CalRect.Left   := 0;
        CalRect.Right  := m_shapeMan.m_prntSh.Left+ m_shapeMan.m_prntSh.Width;
        CalRect.Top    := m_top + 1;
        CalRect.Bottom := m_top + m_shapeMan.m_rh - 1;

        Canvas.Brush.Color := LIMIT_COL1;
        Canvas.Pen.Color   := LIMIT_COL1;
        Canvas.Brush.Style := bsDiagCross;
        Canvas.Pen.Width   := 1;
        Canvas.Rectangle(CalRect);
      end;

    if m_shapeMan.m_LeftLimit > 0 then
    begin
      if  (m_shapeMan.m_LeftLimit > m_parms.OvlpLmtL)
      and (m_parms.OvlpLmtL >= 0) then
      begin
        CalRect.Left   := LeftOvlpLmtPos;
        CalRect.Right  := LeftLimitPos;
        CalRect.Top    := m_top + 1;
        CalRect.Bottom := m_top + m_shapeMan.m_rh - 1;

        Canvas.Brush.Color := $0031A440;
        Canvas.Pen.Color   := $0031A440;
        Canvas.Brush.Style := bsFDiagonal;
        Canvas.Pen.Width   := 1;
        Canvas.Rectangle(CalRect);
      end;
    end;

    if (m_shapeMan.m_RightLimit > 0) then
    begin
//      if (m_shapeMan.m_RightLimit < m_parms.OvlpLmtR)
//      or (m_parms.OvlpLmtL >= 0) then
//      or (m_parms.OvlpLmtR = 0) then
      if (m_parms.OvlpLmtL >= 0) then
      begin
        if (RightLimitPos > LeftOvlpLmtPos) then
          CalRect.Left := RightLimitPos
        else
          CalRect.Left := LeftOvlpLmtPos;
//        if m_parms.OvlpLmtR = 0 then
          CalRect.Right  := m_shapeMan.m_prntSh.Left+ m_shapeMan.m_prntSh.Width;
//        else
//          CalRect.Right  := RightOvlpLmtPos;
        CalRect.Top    := m_top + 1;
        CalRect.Bottom := m_top + m_shapeMan.m_rh - 1;
        Canvas.Brush.Color := $0031A440;
        Canvas.Pen.Color := $0031A440;
        Canvas.Brush.Style := bsBDiagonal;
        Canvas.Pen.Width := 1;
        Canvas.Rectangle(CalRect);
      end;
    end;

    if (m_parms.OvlpLmtR > 0) then
    begin
//      CalRect.Left   := RightOvlpLmtPos;
      CalRect.Left   := 0;
      CalRect.Right  := RightOvlpLmtPos;
      CalRect.Top    := m_top + 1;
      CalRect.Bottom := m_top + m_shapeMan.m_rh - 1;
      Canvas.Brush.Color := LIMIT_COL2;
      Canvas.Pen.Color := LIMIT_COL2;
      Canvas.Brush.Style := bsDiagCross;
      Canvas.Pen.Width := 1;
      Canvas.Rectangle(CalRect);
    end else
      if (m_parms.OvlpLmtR < 0) then
      begin
        CalRect.Left   := 0;
        CalRect.Right  := m_shapeMan.m_prntSh.Left+ m_shapeMan.m_prntSh.Width;
        CalRect.Top    := m_top + 1;
        CalRect.Bottom := m_top + m_shapeMan.m_rh - 1;
        Canvas.Brush.Color := LIMIT_COL2;
        Canvas.Pen.Color := LIMIT_COL2;
        Canvas.Brush.Style := bsDiagCross;
        Canvas.Pen.Width := 1;
        Canvas.Rectangle(CalRect);
      end;

    //Draw limits Lines
    if m_parms.OvlpLmtL > 0 then
    begin
      Canvas.Pen.Width := 3;
      Canvas.Pen.Color := LIMIT_COL1;
      Canvas.MoveTo(LeftOvlpLmtPos, m_top);
      Canvas.LineTo(LeftOvlpLmtPos, m_top + m_shapeMan.m_rh);
    end;
}
    //Draw limits Lines
    if m_shapeMan.m_LeftLimit > 0 then
    begin
      Canvas.Pen.Width := 3;
      Canvas.Pen.Color := clLime;
      Canvas.MoveTo(LeftLimitPos, m_top);
      Canvas.LineTo(LeftLimitPos, m_top + m_shapeMan.m_rh);
    end;

    if (m_shapeMan.m_RightLimit > 0) then
    begin
      Canvas.Pen.Width := 3;
      Canvas.Pen.Color := clLime;
      Canvas.MoveTo(RightLimitPos, m_top);
      Canvas.LineTo(RightLimitPos, m_top + m_shapeMan.m_rh);
    end;

{Old overlap
    if (m_parms.OvlpLmtR > 0) then
    begin
      Canvas.Pen.Width := 3;
      Canvas.Pen.Color := LIMIT_COL2;
      Canvas.MoveTo(RightOvlpLmtPos, m_top);
      Canvas.LineTo(RightOvlpLmtPos, m_top + m_shapeMan.m_rh);
    end;
}
//////////////////// START - fp - tmp0408

////// MATERIALS

    if Assigned(m_parms.NoMaterialList) then
    begin
      for i := 0 to m_parms.NoMaterialList.Count -1 do
      begin
        RecNoMatDate := m_parms.NoMaterialList.Items[i];
        Left  := m_shapeMan.m_CalcPos(RecNoMatDate.m_start, m_shapeMan.m_calcObj);
        Right := m_shapeMan.m_CalcPos(RecNoMatDate.m_end, m_shapeMan.m_calcObj);

        CalRect.Left   := Left;
        CalRect.Right  := Right;
        CalRect.Top    := m_top + 1;
//        CalRect.Bottom := m_top + trunc(m_shapeMan.m_rh/5)+1;
        CalRect.Bottom := m_top + trunc(m_shapeMan.m_rh/4.05*2)+1;

        Canvas.Brush.Color := CL_MATERIAL_LIMIT;
        Canvas.Pen.Color   := CL_MATERIAL_LIMIT;
        Canvas.Pen.Style   := psSolid;
        Canvas.Brush.Style := bsDiagCross;
        Canvas.Pen.Width   := 1;
        Canvas.Rectangle(CalRect);

        Left  := m_shapeMan.m_CalcPos(RecNoMatDate.m_startStdPurcOrd, m_shapeMan.m_calcObj);
        Right := m_shapeMan.m_CalcPos(RecNoMatDate.m_endStdPurcOrd, m_shapeMan.m_calcObj);

        CalRect.Left   := Left;
        CalRect.Right  := Right;
        CalRect.Top    := m_top + 1;
        CalRect.Bottom := m_top + trunc(m_shapeMan.m_rh/4.05*2)+1;

        Canvas.Brush.Color := CL_SRAT_END_STDPURCORD;
        Canvas.Pen.Color   := CL_SRAT_END_STDPURCORD;
        Canvas.Pen.Style   := psSolid;
        Canvas.Brush.Style := bsDiagCross;
        Canvas.Pen.Width   := 1;
        Canvas.Rectangle(CalRect);
      end;
    end;

////// SPARE PARTS

    if Assigned(m_parms.NoAddResList) then
      for i := 0 to m_parms.NoAddResList.Count -1 do
      begin
        RecNoMatDate := m_parms.NoAddResList.Items[i];
        Left  := m_shapeMan.m_CalcPos(RecNoMatDate.m_start, m_shapeMan.m_calcObj);
        Right := m_shapeMan.m_CalcPos(RecNoMatDate.m_end, m_shapeMan.m_calcObj);

        CalRect.Left   := Left;
        CalRect.Right  := Right;
//        CalRect.Top    := m_top + trunc(m_shapeMan.m_rh/5)+1;
        CalRect.Top    := m_top + trunc(m_shapeMan.m_rh/4.05*2)+1;
        CalRect.Bottom := m_top + m_shapeMan.m_rh - 1;

        Canvas.Brush.Color := CL_ADDRES_LIMIT;
        Canvas.Pen.Color   := CL_ADDRES_LIMIT;
        Canvas.Brush.Style := bsDiagCross;
        Canvas.Pen.Style := psSolid;
        Canvas.Pen.Width   := 1;
        Canvas.Rectangle(CalRect);
      end;

//////////////////// END - fp - tmp0408

////// Previous Step

    if m_parms.OvlpLmtL > 0 then
    begin
      CalRect.Left   := 0;
      CalRect.Right  := LeftOvlpLmtPos;
      CalRect.Top    := m_top + trunc(m_shapeMan.m_rh/5)+1;
      CalRect.Bottom := m_top + trunc(m_shapeMan.m_rh/4.05*2)+1;

      Canvas.Brush.Color := CL_OVLP_LIMIT;
      Canvas.Pen.Color   := CL_OVLP_LIMIT;
      Canvas.Brush.Style := bsFDiagonal;
      Canvas.Pen.Style := psSolid;
      Canvas.Pen.Width   := 1;
      Canvas.Rectangle(CalRect);
    end;

////// Next Step

    if m_parms.OvlpLmtR > 0 then
    begin
      CalRect.Left   := RightOvlpLmtPos;
      CalRect.Right  := m_shapeMan.m_prntSh.Left+ m_shapeMan.m_prntSh.Width;
      CalRect.Top    := m_top + trunc(m_shapeMan.m_rh/5)+1;
      CalRect.Bottom := m_top + trunc(m_shapeMan.m_rh/4.05*2)+1;

      Canvas.Brush.Color := CL_OVLP_LIMIT;
      Canvas.Pen.Color   := CL_OVLP_LIMIT;
      Canvas.Brush.Style := bsBDiagonal;
      Canvas.Pen.Style := psSolid;
      Canvas.Pen.Width   := 1;
      Canvas.Rectangle(CalRect);
    end;

    // paint today line
    if Assigned(m_shapeMan.m_todayAlgn) then
    begin
      Canvas.Pen.Style := psSolid;
      Canvas.Pen.Color := clRed;
      Canvas.Pen.Width := 1;
      left := m_shapeMan.m_CalcPos(m_shapeMan.m_todayAlgn^, m_shapeMan.m_calcObj);
      Canvas.MoveTo(left, m_top);
      Canvas.LineTo(left, m_top + m_shapeMan.m_rh);
    end;

    // paint left align line
 //   if Assigned(m_shapeMan.m_today) and
 //      (m_shapeMan.m_todayAlgn^ <> m_shapeMan.m_today^) then
  //  begin
    Canvas.Pen.Style := psDot;
    Canvas.Pen.Color := clgreen;//clBlue;
    Canvas.Pen.Width := 1;
    //  left := m_shapeMan.m_CalcPos(m_shapeMan.m_today^, m_shapeMan.m_calcObj);
    left := m_shapeMan.m_CalcPos(now, m_shapeMan.m_calcObj);
    Canvas.MoveTo(left, m_top);
    Canvas.LineTo(left, m_top + m_shapeMan.m_rh);
 //   end;

    // Horizental lines
    x := 0;
    while x < m_shapeMan.m_prntSh.Width do
    begin
      Canvas.Pen.Style := psSolid;
      Canvas.Pen.Color := clLtGray;
      Canvas.Pen.Width := 1;

      Canvas.MoveTo(x-2, m_top);
      Canvas.LineTo(x-2, m_top + m_shapeMan.m_rh);
      inc(x, m_shapeMan.m_CalcCalZoom(m_shapeMan.m_calcObj));
    end;

    //Paint entity shapes
    if Assigned(m_shList) then
      for i := 0 to m_shList.Count-1 do
      begin
        ds := m_shList[i];
        if Assigned(ds.m_drwFnc) then
        begin
          if  (ds.m_rect.Right > m_shapeMan.m_prntSh.Width) then
         // and ((TMqmCapRes(ds.m_parms.objPtr).m_Type = Cr_CrossingDtm)
         // or (TMqmCapRes(ds.m_parms.objPtr).m_Type = cr_DownTime))
           //then
            ds.m_rect.Right := ds.m_rect.Right - (ds.m_rect.Right - m_shapeMan.m_prntSh.Width);

          ds.m_drwFnc(canvas, @ds.m_parms, ds.m_rect, ds.m_ip, ds.m_mp);
        end;
      end;

    Canvas.Brush.Color := oldBrushColor;
    Canvas.Pen.Color := oldPenColor;
    Canvas.Brush.Style := oldBrushStyle;
    Canvas.Pen.Style := oldPenStyle
  end
end;

//----------------------------------------------------------------------------//

procedure TDisplayRow.SelectByTime;
var
  lt, rt: TDateTime;
  parms:  TRowParms;
  fnc:    TDurShDraw;
  sh:     TDurShape;
  obj:    TMqmVisibleRes;
  ToAdd : boolean;
begin
  DeleteShapeList;
  m_new := false;

  lt := m_shapeMan.m_calcWdw(true,  m_shapeMan.m_calcObj);
  rt := m_shapeMan.m_calcWdw(false, m_shapeMan.m_calcObj);

  m_LimitStartDate := lt;
  m_LimitEndDate   := rt;

  Assert(Assigned(m_parms.objPtr));
  obj := TMqmVisibleRes(m_parms.objPtr);
  obj.StartGenerator(lt, rt);
  while obj.Next(@parms, fnc, ToAdd) do
// mario rivedere    if (not Assigned(m_shapeMan.m_filterFnc)) or
// mario rivedere       m_shapeMan.m_FilterFnc(parms.obj, m_shapeMan.m_FilterObj) then
    begin
      if not ToAdd then continue;
      sh := TDurShape.CreateDurShape(self, @parms, fnc);
      //if Assigned(m_shapeMan.m_applyFunc) then   // avi 8.01.2015
      //  m_shapeMan.m_applyFunc(@(sh.m_parms), m_shapeMan.m_ptr); // avi 8.01.2015
      AddShape(sh)
    end
end;

//----------------------------------------------------------------------------//

procedure TDisplayRow.SetVPos(top: integer);
var
  i: integer;
begin
  m_top := top;
  if not Assigned(m_shList) then exit;
  for i := 0 to m_shList.Count-1 do
    TDurShape(m_shList[i]).SetPos(m_shapeMan.m_calcPos, m_shapeMan.m_calcObj);
end;

//----------------------------------------------------------------------------//

procedure TDisplayRow.ApplyFunc(func: TApplyFunc; ptr: pointer);
//var
//  i: integer;
begin
  if not Assigned(func) then exit;
  if not Assigned(m_shList) then exit;
//  for i := 0 to m_shList.Count-1 do            // avi 8.01.2015
//    func(@(TDurShape(m_shList[i]).m_parms), ptr)  // avi 8.01.2015
end;

//----------------------------------------------------------------------------//

procedure TDisplayRow.NullParmsSupp;
var
  i: integer;
begin
  if not Assigned(m_shList) then exit;
  for i := 0 to m_shList.Count-1 do
  begin
    TDurShape(m_shList[i]).m_parms.suppVal1 := -1;
    TDurShape(m_shList[i]).m_parms.suppVal2 := -1;
  end;
end;

//----------------------------------------------------------------------------//

function TShapeManager.GetShapeForObj(Obj: Pointer): TDurShape;

var
  I, J: integer;
  ds : TDurShape;
  Dspl : TDisplayRow;

begin

  Result := nil;

// mario rivedere
  for i := 0 to m_dspList.Count - 1 do
  begin
    Dspl := TDisplayRow(m_dspList[I]);
    if not assigned(Dspl.m_shList) then
      continue;
    for J := 0 to Dspl.m_shList.Count - 1 do
    begin
      ds := TDurShape(Dspl.m_shList[J]);
      if ds.m_parms.objPtr = obj then
      begin
        Result := ds;
        exit
      end
    end
  end

end;

// -------------------------------------------------------------------------- //
// TDurShape                                                                  //
// -------------------------------------------------------------------------- //

constructor TDurShape.CreateDurShape(dspRow: TDisplayRow; parms: PTRowParms; fnc: TDurShDraw);
begin
  inherited Create;
  m_row    := dspRow;
  m_parms  := parms^;
  m_drwFnc := fnc
end;

//----------------------------------------------------------------------------//

destructor TDurShape.Destroy;
begin
  if m_parms.isTmp then TObject(m_parms.objPtr).Free;
  inherited Destroy
end;

//----------------------------------------------------------------------------//

procedure TDurShape.SetPos(calcPos: TCalcPos; calcObj: Tobject);
var
  x1, x2: integer;
begin
  Assert(Assigned(calcPos));
  x1 := calcPos(m_parms.st, calcObj);
  x2 := calcPos(m_parms.et, calcObj);
  m_ip := calcPos(m_parms.it, calcObj);
  m_mp := calcPos(m_parms.mt, calcObj);
  m_rect.Top    := m_row.m_top + Round(m_row.m_height * m_parms.top);
  m_rect.Left   := x1;
  m_rect.Right  := x2+1;
  m_rect.Bottom := m_rect.Top + Round(m_row.m_height * m_parms.hgt)
end;

// -------------------------------------------------------------------------- //
// TCalHdlr                                                                   //
// -------------------------------------------------------------------------- //

constructor TCalHndlr.CreateHd;
begin
  m_calList := TList.Create;
  m_calShiftEfficList := TList.Create;
end;

//----------------------------------------------------------------------------//

destructor TCalHndlr.Destroy;
begin
  Reset;
  m_calList.Free;
  m_calList := nil;

  m_calShiftEfficList.Free;
  m_calShiftEfficList := nil;

  inherited Destroy
end;

//----------------------------------------------------------------------------//

procedure TCalHndlr.Reset;
var
  i: integer;
begin
  for i := 0 to m_calList.Count - 1 do
    TList(m_calList[i]).Free;
  for i := 0 to m_calShiftEfficList.Count - 1 do
    TList(m_calShiftEfficList[i]).Free;
  m_calShiftEfficList.Clear;
  m_calList.Clear
end;

//----------------------------------------------------------------------------//

procedure TCalHndlr.InitializePeriod(lt, rt: TDateTime);
var
  i: integer;
begin
//  if (m_lt <> lt) or (m_rt <> rt) then
  begin
    m_lt := lt;
    m_rt := rt;
    for i := 0 to m_CalList.Count - 1 do
      TList(m_CalList[i]).Free;
    m_CalList.Clear;
    for i := 0 to m_calShiftEfficList.Count - 1 do
      TList(m_calShiftEfficList[i]).Free;
    m_calShiftEfficList.Clear
  end
end;

//----------------------------------------------------------------------------//

function TCalHndlr.GetCalPos(cal: TPGCALObj): integer;
var
  i: integer;
begin
  Result := -1;
  for i := 0 to m_CalList.Count - 1 do
    if TShCalHndlr(m_CalList[i]).m_cal = cal then
      Result := i
end;

//----------------------------------------------------------------------------//

procedure TCalHndlr.HandleCal(cal: TPGCALObj);
var
  CalShapes: TShCalHndlr;
begin
  if GetCalPos(cal) = -1 then
  begin
    CalShapes := TShCalHndlr.CreateCalSh(m_lt, m_rt, cal);
    m_CalList.Add(CalShapes)
  end
end;

// -------------------------------------------------------------------------- //
// TShCalHdlr                                                                 //
// -------------------------------------------------------------------------- //

constructor TShCalHndlr.CreateCalSh(lt, rt: TDateTime; cal: TPGCALObj);
var
  startRt, leftTime : TDateTime;
  Shift : TDateTime;
  SH1_start,SH1_End,SH2_start,SH2_End,SH3_start,SH3_End,SH4_start,SH4_End : TDateTime;
  Effic1, Effic2, Effic3, Effic4 : double;
begin
  m_TimeList := TList.Create;
  m_TimeEfficList := TList.Create;
  lt := Trunc(lt);      // get rid of hours, minutes, ...
  leftTime := lt;
  startRt := Trunc(rt);
  m_cal := cal;
  m_cal.StartIterator(lt, rt);
  while m_cal.GetNext(lt, rt) do
  begin
    Add(lt, rt);
    if lt >= startRt then break
  end;

  Shift := leftTime;
  m_cal.Ini_lastIxCalEffic;

  while true do
  begin
    if not m_cal.GetNextEffic(lt, rt, Shift, SH1_start, SH1_End, Effic1, SH2_start,
                             SH2_End,Effic2,SH3_start,SH3_End,
                             Effic3, SH4_start, SH4_End, Effic4) then break;

    if frac(SH1_End) = 0 then
      SH1_End := SH1_End  +  1   -   1/24/60/60;

    if frac(SH2_End) = 0 then
      SH2_End := SH2_End  +  1   -   1/24/60/60;

    if frac(SH3_End) = 0 then
      SH3_End := SH3_End  +  1   -   1/24/60/60;

    if frac(SH4_End) = 0 then
      SH4_End := SH4_End  +  1   -   1/24/60/60;

    if (Effic1 > 0) then CheckAndAddEffic(SH1_start, SH1_End, Effic1);
    if (Effic2 > 0) then CheckAndAddEffic(SH2_start, SH2_End, Effic2);
    if (Effic3 > 0) then CheckAndAddEffic(SH3_start, SH3_End, Effic3);
    if (Effic4 > 0) then CheckAndAddEffic(SH4_start, SH4_End, Effic4);

  end;
end;

//----------------------------------------------------------------------------//

destructor TShCalHndlr.Destroy;
var
  i: integer;
begin
  m_cal := nil;

  for i := 0 to m_TimeList.Count - 1 do
    TCalShape(m_TimeList[i]).Free;
  m_TimeList.Free;
  m_TimeList := nil;

  for i := 0 to m_TimeEfficList.Count - 1 do
    TCalShape(m_TimeEfficList[i]).Free;
  m_TimeEfficList.Free;
  m_TimeEfficList := nil;

  inherited Destroy
end;

//----------------------------------------------------------------------------//

procedure TShCalHndlr.Add(x1, x2: TDateTime);
var
  CalShape: TCalShape;
begin
  CalShape := TCalShape.Create;
  CalShape.m_start := x1;
  CalShape.m_end   := x2;
  m_TimeList.Add(CalShape)
end;

//----------------------------------------------------------------------------//

procedure TShCalHndlr.AddEffic(x1, x2: TDateTime; Effic : double);
var
  CalShape: TCalShape;
begin
  CalShape := TCalShape.Create;
  CalShape.m_start := x1;
  CalShape.m_end   := x2;
  CalShape.m_Effic   := Effic;
  m_TimeEfficList.Add(CalShape)
end;

//----------------------------------------------------------------------------//

procedure TShCalHndlr.CheckAndAddEffic(StartDate : TDateTime; EndDate : TDateTime; Effic : Double);
var
  I : Integer;
begin
//AddEffic(SH1_start, SH1_End, Effic1);

  for I := 0 to m_TimeList.Count - 1 do
  begin

    if  (StartDate >= TCalShape(m_TimeList[I]).m_start)
    and (EndDate <= TCalShape(m_TimeList[I]).m_end) then exit;

    if StartDate >= TCalShape(m_TimeList[I]).m_end then continue;
    if EndDate <= TCalShape(m_TimeList[I]).m_start then break;

    if (StartDate >= TCalShape(m_TimeList[I]).m_start) then
    begin
       StartDate := TCalShape(m_TimeList[I]).m_end;
       continue;
    end;

    if  (EndDate >= TCalShape(m_TimeList[I]).m_start)
    and (EndDate <= TCalShape(m_TimeList[I]).m_end) then
    begin
       EndDate := TCalShape(m_TimeList[I]).m_start;
       break;
    end;

    if (StartDate < TCalShape(m_TimeList[I]).m_start) then
      AddEffic(StartDate, TCalShape(m_TimeList[I]).m_start, Effic);

    StartDate := TCalShape(m_TimeList[I]).m_end;

  end;

  if (StartDate < EndDate) then AddEffic(StartDate, EndDate, Effic);

end;

//----------------------------------------------------------------------------//

constructor TCalShape.Create;
begin
  m_start := 0;
  m_end   := 0
end;

//----------------------------------------------------------------------------//

function GetLimitLeftDate : TDateTime;
begin
  Result := m_LimitStartDate;
end;

//----------------------------------------------------------------------------//

function GetLimitRightDate : TDateTime;
begin
  Result := m_LimitEndDate;
end;

//----------------------------------------------------------------------------//

end.
