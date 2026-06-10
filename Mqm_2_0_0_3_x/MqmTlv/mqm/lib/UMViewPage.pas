unit UMViewPage;

interface

uses
  classes,
  comctrls,
  Windows,
  types,
  graphics,
  UMViewTbs,
  controls
  ,UReshape,SysUtils;

type

  TViewTabType = (Vt_Gantt, vt_bin, vt_statistics, vt_statisticsWeekly);

  tmpTabControl = class(TCustomTabControl);

  TMViewPage = class(TPageControl)
    public
    constructor Create(AOwner: TComponent; ViewTabType : TViewTabType); //override;
    destructor  Destroy; override;

    procedure   CloseActive;
    procedure   CloseAll;
    function    GetActiveView: TMViewTabSheet;
    procedure   DrawTabPlan(Control: TCustomTabControl; TabIndex: Integer; const Rect: TRect; Active: Boolean);
    procedure   DrawTabBin(Control: TCustomTabControl; TabIndex: Integer; const Rect: TRect; Active: Boolean);
    procedure   DrawTabStatistic(Control: TCustomTabControl; TabIndex: Integer; const Rect: TRect; Active: Boolean);
    procedure   DrawTabStatisticPeriod(Control: TCustomTabControl; TabIndex: Integer; const Rect: TRect; Active: Boolean);
    procedure   OnChangeControl(Sender: TObject);
    function    SetActiveViewPlan(viewCode: integer): boolean;
    function    SetActiveViewBin(viewCode: integer): boolean;
    procedure   onChangingTab(Sender: TObject; var AllowChange: Boolean);
    procedure   PGMouseActivate(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y, HitTest: Integer;var MouseActivate: TMouseActivate);
  end;

implementation

uses
  UMPlanTbs, UMBinTbs, UMSchedContFunc, UMglobal, FMMainPlan;

procedure TMViewPage.PGMouseActivate(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y, HitTest: Integer;
  var MouseActivate: TMouseActivate);
begin
   FMQMPlan.Changing := True;
end;

procedure TMViewPage.onChangingTab(Sender: TObject;
  var AllowChange: Boolean);
begin

  if FMQMPlan.Changing = False then
      AllowChange := False
  else
    AllowChange := True;
end;

//----------------------------------------------------------------------------//

constructor TMViewPage.Create(AOwner: TComponent; ViewTabType : TViewTabType);
begin
  inherited Create(AOwner);
  OwnerDraw := true;
  if ViewTabType = Vt_Gantt then
  begin
    OwnerDraw := true;
    OnDrawTab := DrawTabPlan;
  end
  else if ViewTabType = vt_bin then
    OnDrawTab := DrawTabBin
  else if ViewTabType = vt_statistics then
    OnDrawTab := DrawTabStatistic
  else if ViewTabType = vt_statisticsWeekly then
    OnDrawTab := DrawTabStatisticPeriod;

  MultiLine := false;
  OnChange  := OnChangeControl;
  Parent := TWinControl(AOwner);
  OnChanging := onChangingTab;
  OnMouseActivate := PGMouseActivate;

  if font.PixelsPerInch = 96 then
    font.PixelsPerInch := 120
  else
  if font.PixelsPerInch = 120 then
    font.PixelsPerInch := 144
  else
  if font.PixelsPerInch = 144 then
    font.PixelsPerInch := 160;

end;

//----------------------------------------------------------------------------//

destructor TMViewPage.Destroy;
begin
  try
    inherited Destroy
  except
  end;
end;

//----------------------------------------------------------------------------//

procedure TMViewPage.DrawTabPlan(Control: TCustomTabControl; TabIndex: Integer;
  const Rect: TRect; Active: Boolean);
var
  TmpRect, TmpRect2:   TRect;
begin
  with Canvas do
  begin
    brush.Color := clwhite;
    Canvas.Font.Name := 'Montserrat';
    if active = true then
    begin
      Canvas.Font.Style := [fsBold];
      font.Color   := Cl_STNDRD_LIGHT_BLUE;//15234048;//16758380;
     // brush.Color := clwhite;//16758380;//clGradientInactiveCaption;
    end;

   // if (TMqmPlanTabSheet(Pages[TabIndex + 1]).p_GetPlanType = PDynamic) then
   //    brush.Color := 13499135;

    FillRect(Rect);
    TmpRect   :=   Rect;
    TmpRect2  :=   Rect;

   { if TMqmPlanTabSheet(Pages[TabIndex + 1]).p_GetPlanType = PDynamic then
    begin
     //  brush.Color := 13499135;
      // Pages[TabIndex + 1].Caption := '';
       brush.Color := clwhite;
       SaveDC(Canvas.Handle);
       Images.Draw(Canvas, Rect.Left+4,
                   Rect.Top+2, 57,
                   Pages[TabIndex].Enabled);
       RestoreDC(Canvas.Handle, -1);
       TmpRect.Left := TmpRect.Left+Images.Width+4;
    end;  }

    OffsetRect(TmpRect,   0,   4);
    try
      // avi - for plan tab should be TabIndex + 1, for bin tab should be TabIndex - 1
      DrawText(Handle,   PChar(Pages[TabIndex + 1].Caption),   -1,   TmpRect,   DT_CENTER   or   DT_VCENTER);
    except

    end;

    if active = true then
    begin
      Canvas.Font.Style := [fsBold];
      brush.Color := Cl_STNDRD_LIGHT_BLUE;//16758380;
      TmpRect2.top := TmpRect.top + 17;
      FillRect( TmpRect2);
    //  ReShape(Self)
    {  FMQMPlan.StBarInfo.Parent := TWinControl(TMqmPlanTabSheet(Pages[TabIndex + 1]));
      FMQMPlan.StBarInfo.Top := 0;
      FMQMPlan.StBarInfo.Align := alTop;
      FMQMPlan.StBarInfo.Visible := true;  }
    end;

  end;

 // ReShape(Self)
end;

// -------------------------------------------------------------------------- //

procedure TMViewPage.DrawTabBin(Control: TCustomTabControl; TabIndex: Integer; const Rect: TRect; Active: Boolean);
var
  TmpRect, TmpRect2:   TRect;
  ImagNumber : integer;
  cl : TColor;
begin

  with Canvas do
  begin

    try

      if not Assigned(TBinTabSheet(Pages[TabIndex])) then exit;

      if not Assigned(TBinTabSheet(Pages[TabIndex]).m_BinPanel) then exit;

      if (TBinTabSheet(Pages[TabIndex]).m_BinPanel.GetFiltParms.P_MaterialSchedFilter) then
      begin
        Canvas.Font.Color := clBlack;  //brush.Color := $009547D9
       // Canvas.Font.Style := [fsBold];

        //LINE OPTION
      {  pen.Color :=  $009547D9;
        pen.width :=  3;

        MoveTo(rect.left+14, rect.bottom - 4);
        LineTo(rect.right-14, rect.bottom - 4); }

        //DOT OPTION
        cl := Brush.Color;
        Brush.Color := Cl_STNDRD_WARP_COLOR;//$009547D9;
      //  RoundRect(Rect.Left + 1, rect.top + 6, rect.Left + 7, rect.top + 20, 2,2);   //vertical
        RoundRect(Rect.Left + 1, rect.top + 6, rect.Left + 13, rect.top + 13, 2,2);    //horizontal

        Brush.Color := cl;
      end
      else
      begin
        Canvas.Font.Color := clBlack;   // brush.Color := clBlack;
        Canvas.Font.Style := [];
      end;

      //StyleName := 'Datatex2';
      Canvas.Font.Name := 'Montserrat';
      TmpRect   :=   Rect;
      // avi - for plan tab should be TabIndex + 1, for bin tab should be TabIndex - 1
      DrawText(Handle,   PChar(trim(Pages[TabIndex].Caption)),   -1,   TmpRect,   DT_CENTER   or   DT_VCENTER);
    except

    end;
  end;



   { if (active = true) then//or (TBinTabSheet(Pages[TabIndex]).p_AutoSequenceResultsTab) then
    begin
      Canvas.Font.Style := [fsBold];
      font.Color   := Cl_STNDRD_LIGHT_BLUE;//15234048;//16758380;

    end;

    FillRect(Rect);
    TmpRect   :=   Rect;
    TmpRect2  :=   Rect;

    ImagNumber := -1;

    OffsetRect(TmpRect,   0,   4);
    try
      // avi - for plan tab should be TabIndex + 1, for bin tab should be TabIndex - 1
      DrawText(Handle,   PChar(Pages[TabIndex].Caption),   -1,   TmpRect,   DT_CENTER   or   DT_VCENTER);
    except

    end;   }

   { if active = true then
    begin
      brush.Color := Cl_STNDRD_LIGHT_BLUE;
      TmpRect2.top := TmpRect.top + 15;
      FillRect( TmpRect2);
    end;

  end;  }

end;

// -------------------------------------------------------------------------- //

procedure TMViewPage.DrawTabStatistic(Control: TCustomTabControl; TabIndex: Integer; const Rect: TRect; Active: Boolean);
var
  TmpRect:   TRect;
begin
  with Canvas do
  begin
    if active = true then
      brush.Color := clGradientInactiveCaption;

    FillRect(Rect);
    TmpRect   :=   Rect;

    OffsetRect(TmpRect,   0,   4);
    try
      // avi - for plan tab should be TabIndex + 1, for bin tab should be TabIndex - 1
      DrawText(Handle,   PChar(Pages[TabIndex].Caption),   -1,   TmpRect,   DT_CENTER   or   DT_VCENTER);
    except

    end;
  end;
end;

// -------------------------------------------------------------------------- //

procedure TMViewPage.DrawTabStatisticPeriod(Control: TCustomTabControl; TabIndex: Integer; const Rect: TRect; Active: Boolean);
var
  TmpRect:   TRect;
begin
  with Canvas do
  begin
    if TabIndex = 0 then
      brush.Color := clWhite //clGradientInactiveCaption
    else if active = true then
      brush.Color := 14540253;//  14540287;//clWhite;

    FillRect(Rect);
    TmpRect   :=   Rect;

    OffsetRect(TmpRect,   0,   4);
    try
      // avi - for plan tab should be TabIndex + 1, for bin tab should be TabIndex - 1
      DrawText(Handle,   PChar(Pages[TabIndex].Caption),   -1,   TmpRect,   DT_CENTER   or   DT_VCENTER);
    except

    end;
  end;
end;

// -------------------------------------------------------------------------- //

procedure TMViewPage.OnChangeControl(Sender: TObject);
begin
  repaint;

end;

// -------------------------------------------------------------------------- //

procedure TMViewPage.CloseActive;
begin
  TMViewTabSheet(ActivePage).Close
end;

//----------------------------------------------------------------------------//

procedure TMViewPage.CloseAll;
var
  i: integer;
begin
  for i := PageCount - 1 downto 1 do
    TMViewTabSheet(Pages[i]).Close
end;

//----------------------------------------------------------------------------//// -------------------------------------------------------------------------- //

function TMViewPage.GetActiveView: TMViewTabSheet;
begin
  Result := TMViewTabSheet(ActivePage)
end;

//----------------------------------------------------------------------------//// -------------------------------------------------------------------------- //

function TMViewPage.SetActiveViewPlan(viewCode: integer): boolean;
var
  i:  integer;
  vt: TMViewTabSheet;
begin
  Result := true;
  for i := 1 to PageCount - 1 do
  begin
    vt := TMViewTabSheet(Pages[i]);
    if vt.GetCode = viewCode then
    begin
      ActivePageIndex := i;
      exit
    end
  end;
  Result := false
end;

//----------------------------------------------------------------------------//// -------------------------------------------------------------------------- //

function TMViewPage.SetActiveViewBin(viewCode: integer): boolean;
var
  i:  integer;
  vt: TMViewTabSheet;
begin
  Result := true;
  for i := 0 to PageCount - 1 do
  begin
    vt := TMViewTabSheet(Pages[i]);
    if vt.GetCode = viewCode then
    begin
      ActivePageIndex := i;
      exit
    end
  end;
  Result := false
end;

//----------------------------------------------------------------------------//// -------------------------------------------------------------------------- //

end.


