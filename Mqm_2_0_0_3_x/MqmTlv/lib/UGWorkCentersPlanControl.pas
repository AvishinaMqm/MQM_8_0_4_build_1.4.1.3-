unit UGWorkCentersPlanControl;

interface

uses
  ExtCtrls, Classes, Types, Controls, Graphics, SysUtils, forms, UMHdrMan, ComCtrls, Windows,
  StdCtrls, UGWorkCentersPlanDraw, UMSchedContFunc, Buttons, Winapi.Messages, Dialogs, FMBin, UReshape, cxButtons;

type

  TTimeScaleMcm = (csNumMaxPrd, csMaxPrd1, csMaxPrd2, csCatViewWcHoursPerc, csPropertyViewWcHoursPerc);

  TLogoImage  = procedure (AOwner: TWinControl);

  TPlanWcControl = class;

  TShapeCal = class(ExtCtrls.TShape) //interposer class
  private

  public
    m_PlanWcControl : TPlanWcControl;
    m_ResourceZoom_Val : Integer;
    m_HorizonTrcBarZoom_Val : Integer;
  private
    FOnpaint:TNotifyEvent;
  protected
      procedure Paint; override;
  end;

  TPlanControlBase = class(TPanel)
    procedure SetLeftDate(dt: TDateTime; prdNum, prdValue: integer); virtual; abstract;
    function  GetLeftDate: TDateTime; virtual; abstract;
    function  GetRightDate: TDateTime; virtual; abstract;
    procedure SetABValue(ABValue: integer); virtual; abstract;
    procedure SetViewMode(mode : integer); virtual; abstract;
    procedure RefreshComp; virtual; abstract;
    procedure ScrollToLine(line: integer); virtual; abstract;
  protected
  end;

  TMcmScrollBox = class(TScrollBox)
  //  procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
  //  private
  //    m_Scrol_planWcView : TPlanWcView;
  protected
    procedure WndProc(var Message: TMessage); override;
  end;

  TPlanWcControl = class(TPlanControlBase)
    private
      m_lastScrollPos   : Integer;
      m_mainPanel : TPanel;
      m_rw : integer;
      m_LogoImage: TLogoImage;
      m_LogoPanel: TPanel;
      m_CalPanel: TPanel;

      m_dtp:      TDateTimePicker;
      m_cbSpan:   TComboBox;
     // m_cbCal:    TElComboBox;
      m_Prec_option_Cat : TComboBox;
      m_Prec_option_Prop : TComboBox;
      m_cbSpanValue : TComboBox;
//      m_chkAlert: TCheckBox;
      m_BtnResources : TcxButton;
    //  m_DammyBtnShap : TShapeCal;
      m_BtnWcView    : TcxButton;
      m_BtnTest      : TcxButton;

      GlobalImage    : TImage;
     // FButtons: array [1..4] of TShapeCal;

      FButtonBmps: array [1..4] of Graphics.TBitmap;
      m_CategoryTypePrecent : CPropTypePrecent;
      m_PropTypePrecent : CCategoryTypePrecent;


      Procedure BinShow(Sender : TObject);
      Procedure BinHide(Sender : TObject);

    procedure UpdateInterval(Sender: TObject);
    procedure SetButtonHints;
    procedure OnResizePanel(Sender: TObject);

    // event handlers

    procedure CBChange(Sender: TObject);
    procedure CBCalChange(Sender: TObject);
    procedure TBChange(Sender: TObject);
    procedure RGChange(Sender: TObject);
    procedure CBKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CBPrecCatChange(Sender: TObject);
    procedure CBPrecPropChange(Sender: TObject);


    procedure ChangeTypeViewMode(Sender: TObject);
    procedure ChangeColorTest(Sender: TObject);
    procedure ChangeToResourcesScreen(Sender: TObject);
    procedure ShServerLoadMouseDown(Sender: TObject; Button: TMouseButton;
              Shift: TShiftState; X, Y: Integer);

   public
    m_cbCal:    TComboBox;
    FBinIconShape1 : TImage;
    FBinIconShape2 : TImage;
    FRightLeftButtons: array [1..4] of TcxButton;
    procedure   CreateCalControll(IsDynamic : boolean;
                MCMcNumMaxPrd, MCMcMaxPrd1 , MCMcMaxPrd2, MCMCatViewWcHoursPerc, MCMPropertyViewWcHoursPerc : integer);
    constructor CreateWcPlanComp(AOwner: TWinControl; hdrCfgWc : TMqmHdrCfgWc; IsDynamic : boolean;
                    MCMcNumMaxPrd, MCMcMaxPrd1 , MCMcMaxPrd2, MCMCatViewWcHoursPerc, MCMPropertyViewWcHoursPerc, SlotGroup : integer);

    destructor  Destroy; override;
    procedure DTPChange(Sender: TObject);
    procedure CreateLogoPanel;
    procedure SetLeftDate(dt: TDateTime; prdNum, prdValue: integer); override;
    function  GetLeftDate: TDateTime; override;
    function  GetRightDate: TDateTime; override;

    procedure SetABValue(ABValue: integer); override;
    procedure SetViewMode(mode : integer); override;
    procedure RefreshComp; override;

    procedure ScrollToLine(line: integer); override;
    procedure SetScrolZise;
    function  GetCategoryShowPercent : CCategoryTypePrecent;
    function  GetPropShowPercent : CPropTypePrecent;
    function GetScaleComboBoxs(TimeScaleMcm : Integer) : integer;

  private
    m_planWcView: TPlanWcView;
    m_scroll:  TMcmScrollBox;

  public
    property P_planWcView: TPlanWcView read m_planWcView;
    property P_scroll: TMcmScrollBox read m_scroll;

  end;

implementation

uses

  gnugettext, UMGlobal, FMMainPlan, UGSlotCal, UGWorkCentersPlanShot, DateUtils, UGWorkCentersDrawSlot, UGCal,
  UMTabcfg, UMPlanTbs;

const

  CMaxPrd    = 2;
  CMaxNumPrd = 8;
//  PrdWord: array[0..CMaxPrd] of String  = ('1 week', '10 days', '2 weeks', '20 days', '1 month', '2 months', '3 months');
  PrdWord: array[0..CMaxPrd] of String  = ('day/s', 'week/s', 'month/s');
//  PrdDays: array[0..CMaxPrd] of Integer = (7, 10, 15, 20, 30, 60, 90);
  PrdNum: array[0..CMaxNumPrd] of Integer = (1, 2, 3, 4, 5, 6, 7, 8, 9);

  ButtonBitmapNames: array [1..4] of string = ('BB', 'B', 'F', 'FF');

{ TPlanCompMan }

procedure TMcmScrollBox.WndProc(var Message: TMessage);
begin
  if Message.Msg = WM_ERASEBKGND then
  begin
    Message.Result := 1;
    Exit;
  end;
  inherited;
end;

Procedure TPlanWcControl.BinShow(Sender : TObject);
begin

  if FBin <> nil then
    if FBin.HostDockSite is TPanel then
    begin
      GetPlanView.ShowDockPanel(FBin.HostDockSite as TPanel, True, nil);
      BringWindowToTop(Fbin.Handle);
      FMQMPlan.ImageList2.GetBitmap(3, FBinIconShape1.Picture.Bitmap);
      FMQMPlan.ImageList2.GetBitmap(0, FBinIconShape2.Picture.Bitmap);
    end;
end;

Procedure TPlanWcControl.BinHide(Sender : TObject);
begin

  if FBin <> nil then
    if FBin.HostDockSite is TPanel then
    begin
      GetPlanView.ShowDockPanel(FBin.HostDockSite as TPanel, False, nil);
      FMQMPlan.ImageList2.GetBitmap(1, FBinIconShape1.Picture.Bitmap);
      FMQMPlan.ImageList2.GetBitmap(2, FBinIconShape2.Picture.Bitmap);

    end;
 // FBin.Visible := False;
  //FBin.FormClose(FBin,Action);

end;

procedure TPlanWcControl.CBCalChange(Sender: TObject);
var cal : TSlotCal;
  tc : TPlanTabCfg;
begin
  cal := TSlotCal(m_cbCal.Items.Objects[m_cbCal.ItemIndex]);
  m_planWcView.SetCalendar(cal);
  UpdateInterval(sender);

  if assigned(TMqmPlanTabSheet(FMQMPlan.m_pgcPlan.GetActiveView).p_PlanWcControl) then
  begin
    tc := TPlanTabCfg(FMQMPlan.m_planTbCfg.FindTab(FMQMPlan.m_pgcPlan.GetActiveView.GetCode));
    tc.MCMcMaxPrd2 := TMqmPlanTabSheet(FMQMPlan.m_pgcPlan.GetActiveView).p_PlanWcControl.GetScaleComboBoxs(2)
  end;
end;

//----------------------------------------------------------------------------//

procedure TPlanWcControl.CBPrecCatChange(Sender: TObject);
var   tc : TPlanTabCfg;
begin
  m_planWcView.RefreshPlan(true);

  tc := TPlanTabCfg(FMQMPlan.m_planTbCfg.FindTab(FMQMPlan.m_pgcPlan.GetActiveView.GetCode));
  tc.MCMCatViewWcHoursPerc := TMqmPlanTabSheet(FMQMPlan.m_pgcPlan.GetActiveView).p_PlanWcControl.GetScaleComboBoxs(3)
end;

//----------------------------------------------------------------------------//

procedure TPlanWcControl.CBPrecPropChange(Sender: TObject);
var   tc : TPlanTabCfg;
begin
  m_planWcView.RefreshPlan(true);

  tc := TPlanTabCfg(FMQMPlan.m_planTbCfg.FindTab(FMQMPlan.m_pgcPlan.GetActiveView.GetCode));
  tc.MCMPropertyViewWcHoursPerc := TMqmPlanTabSheet(FMQMPlan.m_pgcPlan.GetActiveView).p_PlanWcControl.GetScaleComboBoxs(4)
end;

//----------------------------------------------------------------------------//

procedure TPlanWcControl.CBChange(Sender: TObject);
var tc : TPlanTabCfg;
begin
  m_planWcView.SlotsInRow := 0;
  UpdateInterval(Sender);

  tc := TPlanTabCfg(FMQMPlan.m_planTbCfg.FindTab(FMQMPlan.m_pgcPlan.GetActiveView.GetCode));

  if sender = m_cbSpanValue then
    tc.MCMcNumMaxPrd := TMqmPlanTabSheet(FMQMPlan.m_pgcPlan.GetActiveView).p_PlanWcControl.GetScaleComboBoxs(0)
  else
    tc.MCMcMaxPrd1 := TMqmPlanTabSheet(FMQMPlan.m_pgcPlan.GetActiveView).p_PlanWcControl.GetScaleComboBoxs(1);

end;

//----------------------------------------------------------------------------//

procedure TPlanWcControl.CBKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

end;

//----------------------------------------------------------------------------//

procedure TPlanWcControl.ChangeToResourcesScreen(Sender: TObject);
begin
  TcxButton(Sender).Enabled := False;
  ChangeTabFromResourcesToWorkCenters(false);
  TcxButton(Sender).Enabled := True;
end;
//----------------------------------------------------------------------------//

procedure TPlanWcControl.ChangeTypeViewMode(Sender: TObject);
begin
  if P_planWcView.GetViewModeDraw = DT_OnlyWc then
    P_planWcView.SetViewModeDraw(DT_SecondLvl)
  else if P_planWcView.GetViewModeDraw = DT_SecondLvl then
    P_planWcView.SetViewModeDraw(DT_OnlyWc);
  SetScrolZise;
  m_planWcView.RefreshPlan(true)
end;

//----------------------------------------------------------------------------//

procedure TPlanWcControl.ChangeColorTest(Sender: TObject);
var
  ColorWcView : TColorWcView;
begin
  ColorWcView := GetColorWcView;
  m_planWcView.SetColorWcView(ColorWcView);
  m_CalPanel.Color := ColorWcView.CalbackgroundColor;
  m_planWcView.RefreshTime;
  m_planWcView.RefreshPlan(false);
end;

//----------------------------------------------------------------------------//

procedure TPlanWcControl.CreateCalControll(IsDynamic : boolean; MCMcNumMaxPrd, MCMcMaxPrd1 , MCMcMaxPrd2,
                         MCMCatViewWcHoursPerc, MCMPropertyViewWcHoursPerc : integer);
const
  BTN_WIDTH = 46;
  BTN_HEIGHT = 28;
  BTN_TOP = 13;
var
  i,iTop:   integer;
  curleft: Integer;
  s: string;
  Img: graphics.TBitmap;
begin
//  m_CalPanel.Color := 13499135;
  for i := Low(FButtonBmps) to High(FButtonBmps) do
  begin
    FButtonBmps[i] := graphics.TBitmap.Create;
    FButtonBmps[i].LoadFromResourceName(HInstance, ButtonBitmapNames[i]);
  end;

  curleft := 4;

{  if not IsDynamic then
  begin
    curleft := curleft + 2;
    m_BtnWcView := TImage.Create(Self);
    with m_BtnWcView do
    begin
      Parent := m_CalPanel;
      Hint := _('Change view mode');
      ShowHint := true;
      Top := Trunc((self.Height - self.Height) / 2) + 20;//m_dtp.Top;
      Left := curleft;
      Width :=  28;
      Height := 24;
      m_BtnWcView.Picture.LoadFromFile(LocAppGlobals.AppDir + LocAppGlobals.ImgDir + '\McmWcBtn.jpg');
      OnClick := ChangeTypeViewMode;
      visible := true;
    end;
    curleft := curleft + 34;
  end;   }

  GlobalImage := TImage.Create(self);
  wIth GlobalImage do
  begin
    parent := m_CalPanel;
    Align := alClient;
    Name := 'GlobalImage' + IntToStr(I);
    Stretch := true;
    FMQMPlan.ImageList1.GetBitmap(60, GlobalImage.Picture.Bitmap);
    BringToFront;
    showhint := true;
   // hint := '';
  end;



  if not IsDynamic then
  begin
    curleft := curleft + 2;
    m_BtnWcView := TcxButton.Create(Self);
    with m_BtnWcView do
    begin
      Parent := m_CalPanel;
      name := 'BtnWcView';
      Hint := _('Change view mode');
      CustomHint := FMQMPlan.BalloonHint1;
      ShowHint := true;
      Top := BTN_TOP;
      Left := curleft;
      Width :=  35 + 2;
      Height := BTN_HEIGHT;
      OnClick := ChangeTypeViewMode;
      visible := true;
      StyleName := 'SmallButton';
      Caption := _('+/-');
      Cursor := crHandPoint;
      OnCustomDraw := UReshape.GDrawHelper.cxButtonCustomDraw;
    //  Brush.color := Cl_STNDRD_LIGHT_BLUE;
    //  canvas.Brush.Color := Cl_STNDRD_LIGHT_BLUE;
    //  canvas.pen.Color := Cl_STNDRD_LIGHT_BLUE;
    //  canvas.RoundRect(0,5,35,35, 20, 20);
    end;
    curleft := curleft + 50;
  end;


  for i := Low(FRightLeftButtons) to High(FRightLeftButtons) do
  begin
    FRightLeftButtons[i] := TcxButton.Create(Self);
    with FRightLeftButtons[i] do
    begin
      Parent := m_CalPanel;
      name := 'RightLeftButton' + IntToStr(I);
      Top := BTN_TOP;
      Left := curleft;
      Width := BTN_WIDTH ;
      Height := BTN_HEIGHT;
      TabStop := False;
      OnClick := DTPChange;
      ShowHint := True;
      curleft := curleft + Width + 5;  // left position of next button
      CustomHint := FMQMPlan.BalloonHint1;
      StyleName := 'Smallbutton';
      Cursor := crHandPoint;
      OnCustomDraw := UReshape.GDrawHelper.cxButtonCustomDraw;
      if I = 1 then
         Caption := _('<<')
      else if I = 2 then
         Caption := _('<')
      else if I = 3 then
         Caption := _('>')
      else if I = 4 then
         Caption := _('>>');
    end;

  end;


 { for i := Low(FButtons) to High(FButtons) do
  begin
    FButtons[i] := TSpeedButton.Create(Self);
    with FButtons[i] do
    begin
      Parent := m_CalPanel;
      Top := BTN_TOP + 10;
      Left := curleft;
      Width := BTN_WIDTH;
      Height := BTN_HEIGHT;
      Caption := '';
      Flat := True;
      Glyph := FButtonBmps[i];
      TabStop := False;

      ShowHint := True;
      OnClick := DTPChange;
      curleft := curleft + Width;
    end;
  end; }

  curleft := curleft + 10;
  m_dtp := TDateTimePicker.Create(Self);
  with m_dtp do
  begin
    //Kind := dtkDate;
   // MinDateTime := FStartTime;
    Parent := m_CalPanel;
    Top := Trunc((self.Height - m_dtp.Height) / 2) + 10;
    Left := curleft;
    Width := 120;
    //DateSettings.Format := dfCustom;
    //DateSettings.FormatStr := 'd mmmm yyyy';
    //TimeSettings.Format := tfCustom;

    //CalendarFormOptions := [cfoShowOkCancelBtns,cfoCloseupOnDayClick];
    //CalendarHeader.Elements := [heMonthName,heYear,heMonthBtns,heTodayBtn];
   // ThemeMode := ttmNone;
   // ThemeGlobalMode := True;
    Ctl3D := False;
    //SpinBtnWidth := 0;
    Date := Now;

    OnChange := DTPChange;
    curleft := curleft + Width;
  end;

  curleft := curleft + 30;
  m_cbSpanValue := TComboBox.Create(Self);
  with m_cbSpanValue do
  begin
    Parent := m_CalPanel;
    Top  := m_dtp.Top;
    Left := curleft;
    Style := csDropDownList;
    MaxLength := 2;
    Width := 40;
    OnChange := CBChange;
    OnKeyDown := CBKeyDown;
  //  ButtonArrowColor := Cl_STNDRD_LIGHT_BLUE;
    curleft := curleft + Width;
  //  Flat := True;
    Ctl3D := False;
    FontResize2(Font,0);//Font.Size := 8;
  //  ThemeMode := ttmNone;
  //  ThemeGlobalMode := False;
    Color := $00FBFAF9;
  //  ButtonColor := $00FBFAF9;
  //  FocusedSelectColor := $00E1E1E1;
  //  FocusedSelectTextColor := clBlack;
  end;

  curleft := curleft + 5;
  m_cbSpan := TComboBox.Create(Self);
  with m_cbSpan do
  begin
    Top  := m_dtp.Top;
    Left := curleft;
    Style := csDropDownList;
    Width := 80;
    Parent := m_CalPanel;
    OnChange := CBChange;
  //  ButtonArrowColor := Cl_STNDRD_LIGHT_BLUE;
    curleft := curleft + Width;
   // Flat := True;
    Ctl3D := False;
    FontResize2(Font,0);//Font.Size := 8;
  //  ThemeMode := ttmNone;
  //  ThemeGlobalMode := False;
    Color := $00FBFAF9;
  //  ButtonColor := $00FBFAF9;
  //  FocusedSelectColor := $00E1E1E1;
  //  FocusedSelectTextColor := clBlack;
  end;

  curleft := curleft + 15; // 50
  m_cbCal := TComboBox.Create(Self);
  with m_cbCal do
  begin
    Top  := m_dtp.Top;
    Left := curleft;
    Style := csDropDownList;
    Width := 80;
    Parent := m_CalPanel;
    OnChange  := CBCalChange;
  //  ButtonArrowColor := Cl_STNDRD_LIGHT_BLUE;
    curleft := curleft + Width;
  //  Flat := True;
    Ctl3D := False;
    FontResize2(Font,0);//Font.Size := 8;
  //  ThemeMode := ttmNone;
 //   ThemeGlobalMode := False;
    Color := $00FBFAF9;
  //  ButtonColor := $00FBFAF9;
  //  FocusedSelectColor := $00E1E1E1;
  //  FocusedSelectTextColor := clBlack;
  end;

  GetCalList(m_cbCal.Items);
  if MCMcMaxPrd2 = -1 then
    MCMcMaxPrd2 := 1;

  m_cbCal.ItemIndex := MCMcMaxPrd2;

  curleft := curleft + 20;

  // Mention selection items for UPlanComp and UPlanCompBase (for translation)
  s := _('day/s');
  s := _('week/s');
  s := _('month/s');
  s := _('1 week');
  s := _('10 days');
  s := _('2 weeks');
  s := _('20 days');
  s := _('1 month');
  s := _('2 months');
  s := _('3 months');

  for i := 0 to CMaxPrd do
    m_cbSpan.Items.Add(_(PrdWord[i]));
  if MCMcMaxPrd1 = -1 then
    MCMcMaxPrd1 := 1;
   m_cbSpan.ItemIndex := MCMcMaxPrd1;

  for i := 0 to CMaxNumPrd do
    m_cbSpanValue.Items.Add(IntToStr(PrdNum[i]));

  if MCMcNumMaxPrd = -1 then
    MCMcNumMaxPrd := 3;

  m_cbSpanValue.ItemIndex := MCMcNumMaxPrd;

  curleft := curleft + 15; // 50

  m_Prec_option_Cat := TComboBox.Create(Self);
  with m_Prec_option_Cat do
  begin
    Top  := m_dtp.Top;
    Left := curleft-20;
    Style := csDropDownList;
    Width := 210 ;
    Parent := m_CalPanel;
    ShowHint := true;
    Hint     := 'Category slot % is calculated in relation to:';
    CustomHint := FMQMPlan.BalloonHint1;
    OnChange  := CBPrecCatChange;
   // ButtonArrowColor := Cl_STNDRD_LIGHT_BLUE;
    curleft := curleft + Width;
  //  Flat := True;
    Ctl3D := False;

    if Screen.PixelsPerInch = 96 then
      FontResize2(Font,0)
    else if Screen.PixelsPerInch = 120 then
      FontResize2(Font,-1)
    else if Screen.PixelsPerInch = 144 then
      FontResize2(Font,0);//Font.Size := 8;
  //  ThemeMode := ttmNone;
  //  ThemeGlobalMode := False;
    Color := $00FBFAF9;
  //  ButtonColor := $00FBFAF9;
  //  FocusedSelectColor := $00E1E1E1;
  //  FocusedSelectTextColor := clBlack;
  end;

  m_Prec_option_Cat.Items.Add('Work center availalable hours');
  m_Prec_option_Cat.Items.Add('Work center used hours');

  if MCMCatViewWcHoursPerc = -1  then
     MCMCatViewWcHoursPerc := 0;
  m_Prec_option_Cat.ItemIndex := MCMCatViewWcHoursPerc;

  curleft := curleft - 10;

  m_Prec_option_Prop := TComboBox.Create(Self);
  with m_Prec_option_Prop do
  begin
    Top  := m_dtp.Top;
    Left := curleft;
    Style := csDropDownList;
    Width := 210;
    Parent := m_CalPanel;
    ShowHint := true;
 //   ButtonArrowColor := Cl_STNDRD_LIGHT_BLUE;
    Hint     := 'Property slot % is calculated in relation to:';
    CustomHint := FMQMPlan.BalloonHint1;
    OnChange  := CBPrecPropChange;
    curleft := curleft + Width;
  //  Flat := True;
    Ctl3D := False;
    if Screen.PixelsPerInch = 96 then
      FontResize2(Font,0)
    else if Screen.PixelsPerInch = 120 then
      FontResize2(Font,-1)
    else if Screen.PixelsPerInch = 144 then
      FontResize2(Font,0);;//Font.Size := 8;
 //   ThemeMode := ttmNone;
 //   ThemeGlobalMode := False;
    Color := $00FBFAF9;
  //  ButtonColor := $00FBFAF9;
  //  FocusedSelectColor := $00E1E1E1;
  //  FocusedSelectTextColor := clBlack;
  end;


  m_Prec_option_Prop.Items.Add('Work center availalable hours');
  m_Prec_option_Prop.Items.Add('Work center used hours');

  if MCMPropertyViewWcHoursPerc = -1  then
     MCMPropertyViewWcHoursPerc := 0;

  m_Prec_option_Prop.ItemIndex := MCMPropertyViewWcHoursPerc;

 { m_DammyBtnShap := TShapeCal.create(self);
  with m_DammyBtnShap do
  begin
    Parent := m_CalPanel;
    m_PlanWcControl := self;

      name := 'DammyBtnShap';

      Top := BTN_TOP + 2;
      Left := curleft + 20;
      Width :=  35;
      Height := BTN_HEIGHT;

      visible := true;
      shape   := stRoundRect;
     // Brush.color := Cl_STNDRD_LIGHT_BLUE;
      Brush.Color := ClWhite;
      pen.Color := clred;
     // canvas.RoundRect(0,5,35,30, 20, 20);
  end;  }


  if not IsDynamic then
  begin
    curleft := curleft + 20;
    iTop := BTN_TOP;
    m_BtnResources := TcxButton.Create(Self);
    with m_BtnResources do
    begin
      Parent := m_CalPanel;
      Name := 'ResourcesMode';
    //  caption := _('Resources');
      Hint := _('Show resources');
      Caption := _('Resources');
      CustomHint := FMQMPlan.BalloonHint1;
      ShowHint := true;
      Top := BTN_TOP;//m_dtp.Top;
      Left := curleft + 35;
    //  shape := stCircle;
      Width :=  120;
      Height := BTN_HEIGHT+5;
    //  OnMouseDown := ShServerLoadMouseDown;
      OnClick := ChangeToResourcesScreen;
      Cursor := crHandPoint;
      OnCustomDraw := UReshape.GDrawHelper.cxButtonCustomDraw;
     { Brush.color := Cl_STNDRD_LIGHT_BLUE;
      canvas.Brush.Color := Cl_STNDRD_LIGHT_BLUE;
      canvas.pen.Color := Cl_STNDRD_LIGHT_BLUE;
      canvas.RoundRect(0,5,BTN_WIDTH + 70,36, 30, 30); }

      curleft := curleft + 20;
      iTop := 3;
      //Brush.color := Cl_STNDRD_LIGHT_BLUE;
    end;
  end;

    //BIN ICONS
    //HIDE BIN

  if Screen.Width > 1500 then
  begin
    FBinIconShape2 := TImage.Create(Self);
    with FBinIconShape2 do
    begin
      Parent := m_CalPanel;
      name := 'FBinIconShape2';
     // curleft := curleft + 150;
    //  Align := alRight;
      Left := curleft + 155;
      Width := 53;
      top := iTop;

      ShowHint := true;
      Hint := _('Show only Gantt');
      CustomHint := FMQMPlan.BalloonHint1;
      OnClick := BinHide;
      Cursor := crHandPoint;
    end;
    //SHOW BIN
    FBinIconShape1 := TImage.Create(Self);
    with FBinIconShape1 do
    begin
      Parent := m_CalPanel;
      name := 'FBinIconShape1';
      curleft := curleft + 86;

    //  Align := alRight;
      Left := curleft + 115;

      top := iTop;
      ShowHint := true;
      Hint  := _('Show Gantt/Bin');
      CustomHint := FMQMPlan.BalloonHint1;
       Cursor := crHandPoint;
      OnClick := BinShow;//FMQMPlan.MIShowBinClick;
      Width := 80;
      FMQMPlan.ImageList2.GetBitmap(3, FBinIconShape1.Picture.Bitmap);
      FMQMPlan.ImageList2.GetBitmap(0, FBinIconShape2.Picture.Bitmap);

      if FBin <> nil then
      begin
        if TPanel(FBin.HostDockSite).Height = 0 then
        begin
          FMQMPlan.ImageList2.GetBitmap(1, FBinIconShape1.Picture.Bitmap);
          FMQMPlan.ImageList2.GetBitmap(2, FBinIconShape2.Picture.Bitmap);
        end else
        begin
          FMQMPlan.ImageList2.GetBitmap(3, FBinIconShape1.Picture.Bitmap);
          FMQMPlan.ImageList2.GetBitmap(0, FBinIconShape2.Picture.Bitmap);
        end;
      end;
    end;
  end;

  OnResize := OnResizePanel;
  SetButtonHints;

end;

//----------------------------------------------------------------------------//

procedure TPlanWcControl.CreateLogoPanel;
begin
  m_LogoPanel := TPanel.Create(m_MainPanel);
  m_LogoPanel.Parent      := m_MainPanel;
  m_LogoPanel.BevelOuter  := bvRaised;
  m_LogoPanel.BevelInner  := bvLowered;
  m_LogoPanel.BevelWidth  := 1;
  m_LogoPanel.BorderStyle := bsNone;
  m_LogoPanel.BorderWidth := 0;
  m_LogoPanel.TabStop     := false;
  m_LogoPanel.Align       := alLeft;
  m_LogoPanel.Width       := m_RW;
  m_LogoPanel.AutoSize    := false;
  m_LogoImage(m_LogoPanel);
end;

//----------------------------------------------------------------------------//

constructor TPlanWcControl.CreateWcPlanComp(AOwner: TWinControl; hdrCfgWc : TMqmHdrCfgWc; IsDynamic : boolean;
                    MCMcNumMaxPrd, MCMcMaxPrd1 , MCMcMaxPrd2, MCMCatViewWcHoursPerc, MCMPropertyViewWcHoursPerc, SlotGroup : integer);
var
  ColorWcView : TColorWcView;
begin
  inherited Create(AOwner);

  m_LogoImage := hdrCfgWc.m_LogoImage;
  m_rw        := hdrCfgWc.m_rw;
  m_MainPanel := TPanel.Create(AOwner);
  m_MainPanel.Parent      := AOwner;
  m_MainPanel.BevelOuter  := bvNone;
  m_MainPanel.BevelInner  := bvNone;
  m_MainPanel.BevelWidth  := 1;
  m_MainPanel.BorderStyle := bsNone;
  m_MainPanel.BorderWidth := 0;
  m_MainPanel.TabStop     := false;
  m_MainPanel.Align       := alTop;
  m_MainPanel.Height      := hdrCfgWc.m_rw;

  m_CalPanel := TPanel.Create(self);
  m_CalPanel.Parent := m_MainPanel;
  m_CalPanel.Align  := AlClient;
  m_CalPanel.Height := hdrCfgWc.m_rw;

  CreateLogoPanel;

  CreateCalControll(IsDynamic, MCMcNumMaxPrd, MCMcMaxPrd1 , MCMcMaxPrd2, MCMCatViewWcHoursPerc, MCMPropertyViewWcHoursPerc);

  Parent := AOwner;
  Align := alClient;

  m_scroll := TMcmScrollBox.Create(Self);
  m_scroll.DoubleBuffered := True;
  m_scroll.ParentDoubleBuffered := False;
  m_scroll.Autosize := true;
  m_lastScrollPos := 0;

  m_scroll.Left := 1;
  m_scroll.Top := 1;
  m_scroll.Parent := Self;
  m_scroll.Align := alClient;
  m_scroll.HorzScrollBar.Visible := False;
  ColorWcView := GetColorWcView;
  m_CalPanel.Color := ColorWcView.CalbackgroundColor;
  m_planWcView := TPlanWcView.CreateWcPlanView(AOwner, m_scroll, m_CalPanel, self);
  m_planWCView.p_pShot.p_SlotGroup := SlotGroup;
//  m_scroll.m_Scrol_planWcView := m_planWcView;

  m_planWcView.SetColorWcView(ColorWcView);
  m_planWcView.SetViewModeDraw(DT_SecondLvl);
  m_scroll.VertScrollBar.Smooth := True;
  m_scroll.VertScrollBar.Tracking := True;

  CBCalChange(self);
end;

//----------------------------------------------------------------------------//

destructor TPlanWcControl.Destroy;
var
  I : Integer;
begin
  if m_planWcView = nil then exit;
  for I := 0 to m_planWcView.p_pShot.GetNumLines - 1 do
     TPlanLineAbst(m_planWcView.p_pShot.p_son[I]).Free;
  inherited destroy;
end;

//----------------------------------------------------------------------------//

procedure TPlanWcControl.DTPChange(Sender: TObject);
begin
   UpdateInterval(Sender);
   SetButtonHints;
end;

//----------------------------------------------------------------------------//

procedure TPlanWcControl.RefreshComp;
begin
  m_planWcView.RefreshTime;
  m_planWcView.RefreshPlan(true);
  //ReShape(Self);
end;

//----------------------------------------------------------------------------//

procedure TPlanWcControl.RGChange(Sender: TObject);
begin

end;

//----------------------------------------------------------------------------//

procedure TPlanWcControl.ScrollToLine(line: integer);
begin
 // if line > 0 then
 //   m_scroll.VertScrollBar.Position := (line - 1) * 66;
end;

//----------------------------------------------------------------------------//

procedure TPlanWcControl.SetScrolZise;
var
  numLines, NumbersOfSubLinesCategory, NumbersOfSubLinesProperty : Integer;
  I, J : Integer;
  PlanLineGroup : TPlanLineGroup;
begin
  NumbersOfSubLinesCategory := 0;
  NumbersOfSubLinesProperty := 0;
  numLines := P_planWcView.p_pShot.p_numSons;
  for I := 0 to P_planWcView.p_pShot.p_numSons - 1 do
  begin
    PlanLineGroup := TPlanLineGroup(P_planWcView.p_pShot.p_son[I]);

    if (PlanLineGroup.p_numSons > 1) and TPlanLineSecondLevel(TPlanLineShow(TPlanLineGroup(PlanLineGroup.p_son[1]))).p_shownAsSubLevel then
    begin
      for J := 1 to PlanLineGroup.p_numSons - 1 do
      begin
        if TPlanLineSecondLevel(TPlanLineShow(TPlanLineGroup(PlanLineGroup.p_son[1]))).P_SecondLevelType = Lvl_Wc_category then
          Inc(NumbersOfSubLinesCategory)
        else if TPlanLineSecondLevel(TPlanLineShow(TPlanLineGroup(PlanLineGroup.p_son[1]))).P_SecondLevelType = lvl_property then
          Inc(NumbersOfSubLinesProperty)
      end;

    end;
  end;

  m_lastScrollPos := m_scroll.VertScrollBar.Position;

  numLines := numLines + 1;
  if NumbersOfSubLinesCategory > 1 then
    NumbersOfSubLinesCategory := NumbersOfSubLinesCategory + 1;

  if NumbersOfSubLinesProperty > 1 then
    NumbersOfSubLinesProperty := NumbersOfSubLinesProperty + 1;

  if numLines < 1 then numLines := 1;
  m_scroll.VertScrollBar.Range := numLines * (CMinLineHeight + 1) + NumbersOfSubLinesCategory * (CMinLineHeightScondLvlCategory) + NumbersOfSubLinesProperty * (CMinLineHeightScondLvlProperty + 2); //(CMinLineHeightScondLvlProperty);//(CMinLineHeightScondLvl);
//  if m_scroll.VertScrollBar.Range > m_scroll.VertScrollBar.Margin then
//    m_scroll.VertScrollBar.Margin := m_scroll.VertScrollBar.Range + 200;
  if m_scroll.VertScrollBar.Range < 700 then
  begin
  //  m_scroll.VertScrollBar.Range := 800;
  //  m_scroll.VertScrollBar.Margin := 800;
  end;

  if m_lastScrollPos > 0 then
    m_scroll.VertScrollBar.Position := m_lastScrollPos;


//  m_scroll.VertScrollBar.Position := (5) * 66;  // avi if we like to play with the possition ..

//  m_scroll.VertScrollBar.Range := 10000; // make scrol bar show anytime;

//  if m_scroll.VertScrollBar.Range < 500 then
//    m_scroll.VertScrollBar.Range := 500;


end;

//----------------------------------------------------------------------------//

procedure TPlanWcControl.SetABValue(ABValue: integer);
begin

end;

procedure TPlanWcControl.SetButtonHints;
var
  Scale : Integer;
begin
  Scale := GetScaleComboBoxs(2);
  case Scale of
    0:
      begin
        FRightLeftButtons[1].Hint := _('Prev. day');
        FRightLeftButtons[2].Hint := _('Prev. hour');
        FRightLeftButtons[3].Hint := _('Next hour');
        FRightLeftButtons[4].Hint := _('Next day')
      end;
    1:
      begin
        FRightLeftButtons[1].Hint := _('Prev. 4w');
        FRightLeftButtons[2].Hint := _('Prev. week');
        FRightLeftButtons[3].Hint := _('Next week');
        FRightLeftButtons[4].Hint := _('Next 4w')
      end;
    2:
      begin
        FRightLeftButtons[1].Hint := _('Prev. 2 month');
        FRightLeftButtons[2].Hint := _('Prev. month');
        FRightLeftButtons[3].Hint := _('Next month');
        FRightLeftButtons[4].Hint := _('Next 2 month ')
      end;
  end;

end;

//----------------------------------------------------------------------------//

procedure TPlanWcControl.OnResizePanel(Sender: TObject);
begin
  // ReShape(Self);
end;

//----------------------------------------------------------------------------//

procedure TPlanWcControl.SetLeftDate(dt: TDateTime; prdNum, prdValue: integer);
begin
  m_planWcView.SetLeftDate(dt, prdNum, prdValue);
end;

//----------------------------------------------------------------------------//

function TPlanWcControl.GetCategoryShowPercent: CCategoryTypePrecent;
begin
  case m_Prec_option_Cat.Itemindex of
    0 : Result := Cp_WorkCenterAvailhours;
    1 : Result := Cp_WorkcenterUsedhours;
  else
    Result := Cp_WorkCenterAvailhours;
  end;

end;

//----------------------------------------------------------------------------//

function TPlanWcControl.GetPropShowPercent: CPropTypePrecent;
begin
  case m_Prec_option_Prop.Itemindex of
    0 : Result := pp_WorkCenterAvailhours;
    1 : Result := pp_WorkcenterUsedhours;
  else
    Result := pp_WorkcenterUsedhours;
  end;
end;

//----------------------------------------------------------------------------//

function TPlanWcControl.GetScaleComboBoxs(TimeScaleMcm : integer) : integer;
begin
  case TTimeScaleMcm(TimeScaleMcm) of
    csNumMaxPrd : Result := m_cbSpanValue.ItemIndex;
    csMaxPrd1 : Result := m_cbSpan.ItemIndex;
    csMaxPrd2 : Result := m_cbCal.ItemIndex;
    csCatViewWcHoursPerc : Result := m_Prec_option_Cat.ItemIndex;
    csPropertyViewWcHoursPerc : Result := m_Prec_option_Prop.ItemIndex;
  end;
end;

//----------------------------------------------------------------------------//

function TPlanWcControl.GetLeftDate: TDateTime;
begin
  Result := m_planWcView.GetLeftDate;
end;

//----------------------------------------------------------------------------//

function TPlanWcControl.GetRightDate: TDateTime;
begin
  Result := m_planWcView.GetRightDate;
end;

//----------------------------------------------------------------------------//

procedure TPlanWcControl.SetViewMode(mode: integer);
begin

end;

//----------------------------------------------------------------------------//

procedure TPlanWcControl.ShServerLoadMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ChangeTabFromResourcesToWorkCenters(false);
end;

//----------------------------------------------------------------------------//

procedure TPlanWcControl.TBChange(Sender: TObject);
begin

end;

//----------------------------------------------------------------------------//

procedure TPlanWcControl.UpdateInterval(Sender: TObject);
var
  dt: TDateTime;
begin
  if Sender = m_dtp then
    dt := Trunc(m_dtp.Date)
  else
    dt := m_planWcView.GetLeftDate;

  if dt = 0 then
    dt := today; // fp - first day of current year

  if Sender = FRightLeftButtons[1] then
  begin
    dt := dt - (m_planWcView.GetRightDate - m_planWcView.GetLeftDate);
  end else if Sender = FRightLeftButtons[2] then
  begin
    case m_cbCal.ItemIndex of
        0: dt := IncDay(dt, - 1);
        1: dt := IncWeek(dt, - 1);
        2: dt := IncMonth(dt, - 1);
    end
  end else if Sender = FRightLeftButtons[3] then
  begin
      case m_cbCal.ItemIndex of
        0: dt := IncDay(dt, 1);
        1: dt := IncWeek(dt, 1);
        2: dt := IncMonth(dt, 1);
      end
  end else if Sender = FRightLeftButtons[4] then
  begin
    dt := m_planWcView.GetRightDate + 1
  end;

  if today - dt > 60 then exit;

  m_planWcView.SetLeftDate(dt, m_cbSpanValue.ItemIndex+1, m_cbSpan.ItemIndex);
  m_dtp.Date := m_planWcView.GetLeftDate;

  RefreshComp;
end;

{ TMcmScrollBox }

{procedure TMcmScrollBox.WMVScroll(var Message: TWMVScroll);
begin
  inherited;
  m_Scrol_planWcView.RefreshPlan(false);
end;     }

{ TShapeCal }

procedure TShapeCal.Paint;
var
  SavedFontSize : integer;
begin
  inherited;

  if name = 'DammyBtnShap' then
  begin
   { if m_PlanWcControl.m_BtnResources <> nil then
    begin
      with m_PlanWcControl.m_BtnResources do
      begin
        Canvas.Font.Size := 11;
        Canvas.Font.color := ClWhite;
        Canvas.Font.name := 'Montserrat';
        Canvas.TextOut(20,11,_('Resources'));
      end;
    end;  }

    if m_PlanWcControl.FRightLeftButtons[1] <> nil then
    begin
      with m_PlanWcControl.FRightLeftButtons[1] do
      begin
        // Canvas.Font.Style := [fsBold];
       //  Canvas.Font.color := ClWhite;
       //  Canvas.TextOut(13,12,_('<<'));
         Caption := _('<<');
      end;
    end;

    if m_PlanWcControl.FRightLeftButtons[2] <> nil then
    begin
        with m_PlanWcControl.FRightLeftButtons[2] do
        begin
          {Canvas.Font.Style := [fsBold];
          Canvas.Font.color := ClWhite;
          Canvas.TextOut(18,12,_('<'));   }
          Caption := _('<');
        end;
    end;

    if m_PlanWcControl.FRightLeftButtons[3] <> nil then
    begin
      with m_PlanWcControl.FRightLeftButtons[3] do
      begin
       { Canvas.Font.Style := [fsBold];
        Canvas.Font.color := ClWhite;
        Canvas.TextOut(18,12,_('>'));     }
        Caption := _('>');
      end;
    end;

    if m_PlanWcControl.FRightLeftButtons[4] <> nil then
    begin
      with m_PlanWcControl.FRightLeftButtons[4] do
      begin
       { Canvas.Font.Style := [fsBold];
        Canvas.Font.color := ClWhite;
        Canvas.TextOut(13,12,_('>>')); }
        Caption := _('>>');
      end;

    end;

    if m_PlanWcControl.m_BtnWcView <> nil then
    begin
      with m_PlanWcControl.m_BtnWcView do
      begin
        StyleName := 'SmallButton';
        //Canvas.Font.color := ClWhite;
        SavedFontSize := Canvas.Font.Size;
       // Canvas.Font.Size := SavedFontSize + 4;
       // Canvas.TextOut(6,9,_('+/-'));
       Caption := _('+/-');
        Canvas.Font.Size := SavedFontSize
      end;
    end;

  end;

    ReShape(m_PlanWcControl);


 { if name = 'RightLeftButton1' then
  begin
    Canvas.Font.Style := [fsBold];
    Canvas.Font.color := ClWhite;
    Canvas.TextOut(13,7,_('<<'));
  end;

  if name = 'RightLeftButton2' then
  begin
    Canvas.Font.Style := [fsBold];
    Canvas.Font.color := ClWhite;
    Canvas.TextOut(18,7,_('<'));
  end;

  if name = 'RightLeftButton3' then
  begin
    Canvas.Font.Style := [fsBold];
    Canvas.Font.color := ClWhite;
    Canvas.TextOut(18,7,_('>'));
  end;

  if name = 'RightLeftButton4' then
  begin
    Canvas.Font.Style := [fsBold];
    Canvas.Font.color := ClWhite;
    Canvas.TextOut(13,7,_('>>'));
  end;   }
           {
  if name = 'BtnWcView' then
  begin
    Canvas.Font.Style := [fsBold];
    Canvas.Font.color := ClWhite;
    Canvas.TextOut(2,7,_('+/-'));
  end;

  if name = 'ResourcesMode' then
  begin
   // Canvas.Font.Style := [fsBold];
    Canvas.Font.Size := 11;
    Canvas.Font.color := ClWhite;
    Canvas.TextOut(14,4,_('Resources'));
  end;
           }
end;

end.
