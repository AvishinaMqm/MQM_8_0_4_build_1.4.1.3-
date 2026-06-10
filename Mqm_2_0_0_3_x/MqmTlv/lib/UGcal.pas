unit UGcal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, cxButtons,
  StdCtrls, ExtCtrls, Buttons, ComCtrls, UReShape, StrUtils, ExTrackBar,FMBin,UMTabCfg,UMViewPage ;

type
  {
    The unit of measure (UM) used by the calendar window is
    defined by the `TTimeScale' type.
    The time interval starts from `StartTime'.
    The time interval visible on the screen starts from `LeftTime'.
    `Lw' indicates how many pixels there are per UM (i.e. the
    distance in pixels between two vertical lines on the calendar).
    `UMperDay' indicates how many UMs there are in a day.
    `Lw UMperDay' is the number of pixel per day.
    `Width' is the width inftruck pixels of the paint box.
    At time `t' the x (pixel) position on the screen is given by:

          x(t) = (t - LeftTime) Lw UMperDay
  }

  TTimeScale = (csOneHour, csFourHours, csOneDay, csOneWeek);

  TCalPanel = class;

  TShapeCal = class(ExtCtrls.TShape) //interposer class
  private

  public
    m_CalPanel : TCalPanel;
    m_ResourceZoom_Val : Integer;
    m_HorizonTrcBarZoom_Val : Integer;
  private
    FOnpaint:TNotifyEvent;
  protected
     procedure Paint; override;
  end;

  TCalPanel = class(TCustomPanel)
    private
      FPaintBox: TPaintBox;
      FGroupBox: TGroupBox;
      FRadioButtons: array [TTimeScale] of TRadioButton;
      FRightLeftButtons: array [1..4] of TcxButton;
      GlobalImage : TImage;
      FButtonBmps: array [1..4] of TBitmap;
      RadioButtonCaptions: array [TTimeScale] of string;
      FGBoxBarZoom: TGroupBox;


      FComboBox : TComboBox ;
      TI : array [TTimeScale] of TComboExItem ;
      DLabel : TLabel;
    public
      FResourceBarZoomShape : TShapeCal;
      FHorizontalBarZoomShape : TShapeCal;
      FResourceTrcBarZoom   : TExTrackBar;
      FHorizontalTrcBarZoom : TExTrackBar;
      FStatusZoom           : TExTrackBar;
    private
      FDateTimePicker: TDateTimePicker;
      FTImageToday : TcxButton;
      FTimageWorkCenters : TcxButton;
      FImage : TImage;

      FLeftTime, FStartTime: TDateTime;
      FLw: Integer;
      FTimeScale: TTimeSCale;
      TabCfg: TPlanTabCfg;

      Procedure MouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);

      Procedure BinHide(Sender : TObject);
      Procedure BinShow(Sender : TObject);
      procedure Paint1h(Sender: TObject; y1, y2: Integer);
      procedure Paint4h(Sender: TObject; y1, y2: Integer);
      procedure Paint1d(Sender: TObject; y1, y2: Integer);
      procedure Paint1w(Sender: TObject; y1, y2: Integer);

      procedure OnResizePanel(Sender: TObject);
      procedure FTrcBarZoomChange(Sender: TObject);
      procedure SetTimeScale(ts : TTimeScale);
      procedure SetButtonHints;
      function GetRightTime: TDateTime;

      function IsFirstDayOfWeek(d: TDateTime): Boolean;
      function IsLastDayOfWeek(d: TDateTime): Boolean;

//      function DayOfYear(Day, Month, Year: Integer): Integer;

    protected
      FOnCalendarChanged: TNotifyEvent;

      procedure ChangeToWorkCentersScreen(Sender: TObject);
      procedure PaintCalendar(Sender: TObject);
      procedure ChangeTimeScale(Sender: TObject);


      procedure MouseButtonPressed(Sender: TObject; Button: TMouseButton;
                                   Shift: TShiftState; X, Y: Integer);

      procedure FBtnTodayMouseDown(Sender: TObject; Button: TMouseButton;
                Shift: TShiftState; X, Y: Integer);

    public
      FBinIconShape1 : TcxButton;
      FBinIconShape2 : TcxButton;
      constructor CreateCalPanel(AOwner: TComponent; Scale: TTimeScale; startDate: TDateTime; IsDynamic : boolean);
      destructor Destroy; override;

      function getFTImageToday : TcxButton;
      function FirstDayOfWeekOf(d: TDateTime): TDateTime;
      function PixelsPerDay: Real;
      function TimeToPixels(time: TDateTime): Integer;
      function PixelsToTime(x: Integer): TDateTime;
      function PixelQuant: TDateTime;
      procedure GoToTime(t: TDateTime);
      procedure UpdateCaptions;
      property StartTime: TDateTime read FStartTime;
      property LeftTime: TDateTime read FLeftTime;
      property RightTime: TDateTime read GetRightTime;
      property Lw: Integer read FLw;
      property TimeSCale: TTimeScale read FTimeScale write SetTimeScale;
      property OnCalendarChanged: TNotifyEvent write FOnCalendarChanged;
      procedure ChangeLeftDate(Sender: TObject);
    published
      property Align;
      property BevelInner;
      property BevelOuter;
      property ParentColor;
      property Color;
      property Height;
      property ParentFont;
      property Font;
  end;

  function DayOfYear(Day, Month, Year: Integer): Integer;
  function WeekNumber(d: TDateTime): Integer;

implementation

{$R *.DCR}
uses
  gnugettext, UMGlobal, FMMainPlan, DateUtils;

const
  FDOW = 2;     { index of first day of week: Monday. IS-8601 }
  LDOW = 1;     { index of last  day of week: Sunday. IS-8601 }

  CMaxPrd    = 2;
  CMaxNumPrd = 8;

  UMperDay   : array [TTimeScale] of Real = (24, 6, 1, 1/7);
  SmallChange: array [TTimeSCale] of Real = (1/24, 1/6, 1, 7);
  LargeChange: array [TTimeSCale] of Real = (1, 1, 7, 28);

  PrdWord: array[0..CMaxPrd] of String  = ('day/s', 'week/s', 'month/s');
  PrdNum: array[0..CMaxNumPrd] of Integer = (1, 2, 3, 4, 5, 6, 7, 8, 9);

  ButtonBitmapNames: array [1..4] of string = ('BB', 'B', 'F', 'FF');

  ColorPenLine = 14079702;

{ --------------------------------------------------------------------- }
{                                                                       }
{                       Constructor and destructor                      }
{                                                                       }
{ --------------------------------------------------------------------- }


constructor TCalPanel.CreateCalPanel(AOwner: TComponent; Scale: TTimeScale; startDate: TDateTime; IsDynamic : boolean);
const
  BTN_WIDTH = 44; //33;
  BTN_HEIGHT = 26;
  BTN_TOP = 9;
var
  i, curleft,iTop: Integer;
  ts: TTimeScale;
  Rect : TRect;
begin
  inherited Create(AOwner);
  DoubleBuffered := True;
  FOnCalendarChanged := nil;

  RadioButtonCaptions[csOneHour]   := _('1 hour');
  RadioButtonCaptions[csFourHours] := _('4 hours');
  RadioButtonCaptions[csOneDay]    := _('1 day');
  RadioButtonCaptions[csOneWeek]   := _('1 week');

  Parent := AOwner as TWinControl;
  Height := 92;
  Align := alClient;
  BevelInner:= bvNone;
  BevelOuter:= bvNone;
  Color := clBtnFace;
  Caption := '';
  OnClick := ChangeLeftDate;
  Cursor := crDefault;
  Color := ClWhite;//clGradientInactiveCaption;

  FPaintBox := TPaintBox.Create(Self);
  with FPaintBox do
  begin
    Parent := Self;
    Align := alBottom;
    OnPaint := PaintCalendar;
    OnMouseDown := MouseButtonPressed;
    Height := 49;
    ParentFont := True;
    Color := 15658734;//clGradientInactiveCaption; //clBtnFace;

    // calculate FLw, distance between vertical lines, based on font size
    Canvas.Font := Font;
    FLw := Canvas.TextWidth('m') * 5 div 2 + 30;
    Cursor := crDefault;
  end;

  // Bitmaps for the VCR buttons

  for i := Low(FButtonBmps) to High(FButtonBmps) do
  begin
    FButtonBmps[i] := TBitmap.Create;
    FButtonBmps[i].LoadFromResourceName(HInstance, ButtonBitmapNames[i]);
  end;

  // Create the four VCR movement buttons

  ///
  GlobalImage := TImage.Create(self);
  wIth GlobalImage do
  begin
    parent := Self;
    Align := alClient;
    Name := 'GlobalImage' + IntToStr(I);
    Stretch := true;
    try
      FMQMPlan.ImageList1.GetBitmap(60, GlobalImage.Picture.Bitmap);
    except
    end;
    BringToFront;
    showhint := true;
    Font.Name := 'Montserrat';
    CustomHint := FMQMPlan.BalloonHint1;
   // hint := 'aa';
  end;

  ///
  curleft := 4;            // current left position of button
  for i := Low(FRightLeftButtons) to High(FRightLeftButtons) do
  begin
    FRightLeftButtons[i] := TcxButton.Create(Self);
    with FRightLeftButtons[i] do
    begin
      Parent := Self;
      name := 'RightLeftButton' + IntToStr(I);
     // Top := BTN_TOP - 3;
      Left := curleft;
      Width := BTN_WIDTH + 2;
    //  Height := BTN_HEIGHT -2;

      Height := BTN_HEIGHT+2;
      Top := BTN_TOP ;
      FontResize2(Font,0);//Font.Size := 9;

      //StyleName := 'SmallButton';
      TabStop := False;
      OnClick := ChangeLeftDate;
      ShowHint := True;
      CustomHint := FMQMPlan.BalloonHint1;
      //OnMouseMove := MouseMove;
      Cursor := crHandPoint;
      OnCustomDraw := UReshape.GDrawHelper.cxButtonCustomDraw;
      if i <> 2 then
        curleft := curleft + Width + 5  // left position of next button
      else
      begin

        curleft := curleft + Width + 1 ;
        //MIHAILO
        // FROM - TO DATES
        DLabel := TLabel.Create(Self);
        with DLabel do
        Begin
          Parent := self;
          name := 'DateLabel';
          Top := BTN_TOP + 2;
          Left := curLeft + 4;
          Caption := '';
          FontResize2(font,2);
          Font.Name := 'Montserrat';
        End;

        curleft := curleft + 150;
      end;
    end;
  end;

  // Create the group box for the radio buttons
  //Mihailo

  FComboBox := TComboBox.Create(Self);
  With FComboBox do
  begin
    Parent := Self;
    Top := 12;
    Left := curleft + 12; //6;
    CurLeft := Left;
    Width := 95;
    Height := 39;
    TabStop := False;
    onChange := ChangeTimeScale;
    Color := clwhite;
    Style := csDropDownList ;
    Ctl3D := False;
    FontResize2(Font,0);
  end;

  for ts := Low(TTimeSCale) to High(TTimeSCale) do
  begin
    TI[ts] := TComboExItem.Create(nil);
    FComboBox.items.Create.AddObject(RadioButtonCaptions[ts],TI[ts]);

    if ts = Scale then
        FCombobox.ItemIndex := FCombobox.Items.IndexOfObject(TI[ts]);

    //TO DO
    //ON CLOSING MQM ,MODIFY SAVING FOR NEW COMBOBOX
  end;

  FTimeScale := Scale;

  FStartTime := FirstDayOfWeekOf(startDate);

  if Scale <> csOneWeek then
    FLeftTime  := Trunc(Date)
  else
    FLeftTime := FirstDayOfWeekOf(Date);

  FTImageToday := TcxButton.Create(Self);
  with FTImageToday do
  begin
    Parent := Self;
    name := 'FBtnToday';

    Left := FComboBox.Left + FComboBox.width + 10;
    curleft := Left;
    Width := 75 + 3;
    Height := BTN_HEIGHT+2;
    Top := BTN_TOP;
    FontResize2(Font,0);
    OnClick := ChangeLeftDate;
    Cursor := crHandPoint;
    OnCustomDraw := UReshape.GDrawHelper.cxButtonCustomDraw;
  end;

  FDateTimePicker := TDateTimePicker.Create(Self);
  with FDateTimePicker do
  begin
  //  MinDateTime := FStartTime;
    Parent := Self;
    Top := 12;
    Left := FTImageToday.Left + FTImageToday.width + 6;

    Width := 110;
    Height := 22;
    OnChange := ChangeLeftDate;
    Date := Now;
    curleft := Left + width + 10;
    FontResize2(Font,-1);
  end;


  FHorizontalBarZoomShape := TShapeCal.Create(Self);
  with FHorizontalBarZoomShape do
  begin
    Parent := self;
    name := 'FHorizontalBarZoomShape';
    m_CalPanel := self;
    m_HorizonTrcBarZoom_Val := 10;
    Top := 6;
    Left := CurLeft;
    //visible := false;
    Width := 4;//40;
    Height := 28;
    shape  := stRoundRect;
    Canvas.Font.Size  := 9;
    Brush.color := Clwhite;
    pen.Color := Clwhite;
    Canvas.Font.name := 'Montserrat';
    CurLeft := Left + Width;
  end;

  FHorizontalTrcBarZoom := TexTrackBar.Create(Self);
  with FHorizontalTrcBarZoom do
  begin
    Parent := self;
    Top := 13;
    Left := CurLeft;
    Canvas.Font.Name := 'Montserrat';
    Font.Size := 10;
    Width := 100;
    CurLeft := CurLeft + Width;
    Height := 28;
    Min := 5;
    Max := 100;
    Position := 20;
    TrkRadius := 10;
    Height := 20;
    OnChange := FTrcBarZoomChange;
    ThumbColor := Cl_STNDRD_LIGHT_BLUE;
    color := clWhite;
    TrkBdrColor := clGrayText;
    //TrkWidth := 12;
    ThumbIsColored := true;
    ThumbStyle := tsCircle;
    ShowHint := True;
    Hint  := _('Time scale zoom');
    CustomHint := FMQMPlan.BalloonHint1;
  end;

  FResourceBarZoomShape := TShapeCal.Create(Self);
  with FResourceBarZoomShape do
  begin
    Parent := self;
    name := 'FResourceBarZoomShape';
    Top := 6;
    Width := 4;//45;
    visible := false;
    Left := CurLeft;
    CurLeft := CurLeft + Width;
    Height := 28;
    shape  := stRoundRect;
    Canvas.Font.Size  := 9;
    Brush.color := Clwhite;
    pen.Color := Clwhite;
    Canvas.Font.name := 'Montserrat';
    AutoSize := False;
  end;

  FResourceTrcBarZoom := TexTrackBar.Create(Self);
  with FResourceTrcBarZoom do
  begin
    Parent := self;
    Top := 13;
    Left := CurLeft + 10;
    Width := 100;
    CurLeft := CurLeft + Width;
    Height := 28;
    Min := 5;
    Max := 100;
    Position := 20;
    Height := 20;
    OnChange := GetPlanView.TrcBarZoomChange;
    TrkRadius := 10;
    ThumbColor := Cl_STNDRD_LIGHT_BLUE;
    color := clWhite;
    TrkBdrColor := clGrayText;
    //TrkWidth := 12;
    ShowHint := True;
    Hint  := _('Resources zoom');
    CustomHint := FMQMPlan.BalloonHint1;
    ThumbIsColored := true;
    ThumbStyle := tsCircle;
    AutoSize := False;
  end;

  FStatusZoom := TexTrackBar.Create(Self);
  with FStatusZoom do
  begin
      Parent := self;
      Top := 13;
      Left := CurLeft + 20;
      Width := 100;
      CurLeft := Left + Width + 20;
      Height := 28;
      Min := 20;
      Max := 40;
      Position := 20;
      Height := 20;
      OnChange := GetPlanView.TrcBarStatusChange;
      TrkRadius := 10;
      ThumbColor := Cl_STNDRD_LIGHT_BLUE;
      color := clWhite;
      TrkBdrColor := clGrayText;
      //TrkWidth := 12;
      ShowHint := True;
      Hint  := _('Status bar zoom');
      CustomHint := FMQMPlan.BalloonHint1;
      ThumbIsColored := true;
      ThumbStyle := tsCircle;
      AutoSize := False;
  end;

 // if DBAppGlobals.MCM_App and not IsDynamic then
  if not IsDynamic then
  begin
    FTImageWorkCenters := TcxButton.Create(Self);
    with FTimageWorkCenters do
    begin
      Parent := Self;
      name := 'WorkCenters';
      FontResize2(Font,0);//Font.Size := 9;
      Top := BTN_TOP-2;
      Width := BTN_WIDTH + 100;
      Height := BTN_HEIGHT+7;
      Left := curleft;
      OnClick := ChangeToWorkCentersScreen;
      curleft := Left + Width;
      ShowHint := True;
      Hint  := _('Show work centers');
      CustomHint := FMQMPlan.BalloonHint1;
      //StyleName := 'LargeButton4.285x';
      Cursor := crHandPoint;
      OnCustomDraw := UReshape.GDrawHelper.cxButtonCustomDraw;
    end;
  end;

  //BIN ICONS
  //SHOW BIN

 // if not DBAppGlobals.MCM_App then
 //   curleft := curleft + 150;

  if Screen.Width > 1500 then
  begin

    FBinIconShape1 := TcxButton.Create(Self);
    with FBinIconShape1 do
    begin
      Parent := Self;
      name := 'FBinIconShape1';
      left := curleft + 25;
      Top := BTN_TOP-2;
      ShowHint := True;
      Hint  := _('Show Bin');
      CustomHint := FMQMPlan.BalloonHint1;
      Width := 53;
      Height := BTN_HEIGHT+7;
      OnClick := BinShow;//FMQMPlan.MIShowBinClick;
      Cursor := crHandPoint;
      caption := '';
      OptionsImage.Images := FMQMPlan.cxImageList1;
      OptionsImage.ImageIndex := 1;
      OnCustomDraw := UReshape.GDrawHelper.cxButtonCustomDraw;
      if FBin <> nil then
      begin
        if TPanel(FBin.HostDockSite).Height = 0 then
          OptionsImage.ImageIndex := 0
        else
          OptionsImage.ImageIndex := 1;
      end;
    end;

    //HIDE BIN
    {FBinIconShape2 := TImage.Create(Self);
    with FBinIconShape2 do
    begin
      Parent := Self;
      name := 'FBinIconShape2';
      if not DBAppGlobals.MCM_App then
        Top := -5
      else
        Top := -5;
      left := curleft + 10;
      ShowHint := True;
      Hint  := _('Show only Gantt');
      CustomHint := FMQMPlan.BalloonHint1;
      Width := 45;
      Cursor := crHandPoint;
      curLeft := Left + Width;
      Height := 50;
      try
        FMQMPlan.ImageList2.GetBitmap(3, FBinIconShape1.Picture.Bitmap);
        FMQMPlan.ImageList2.GetBitmap(0, FBinIconShape2.Picture.Bitmap);
      except
      end;
      if FBin <> nil then
      begin
        if TPanel(FBin.HostDockSite).Height = 0 then
        begin
          try
            FMQMPlan.ImageList2.GetBitmap(1, FBinIconShape1.Picture.Bitmap);
            FMQMPlan.ImageList2.GetBitmap(2, FBinIconShape2.Picture.Bitmap);
          except
          end;
        end
        else
        begin
          try
            FMQMPlan.ImageList2.GetBitmap(3, FBinIconShape1.Picture.Bitmap);
            FMQMPlan.ImageList2.GetBitmap(0, FBinIconShape2.Picture.Bitmap);
          except
          end;
        end;

      end;
      OnClick := BinHide;
    end;    }

  end;


  OnResize := OnResizePanel;
  SetButtonHints;
  UpdateCaptions;
  ReShape(Self);

end;

//----------------------------------------------------------------------------//

function GetFirstDayOfWeekLocaleInformation: String;
var pcLCA: Array[0..20] of Char;
begin
  GetLocaleInfo(LOCALE_SYSTEM_DEFAULT,LOCALE_IFIRSTDAYOFWEEK,pcLCA,19);
  Result := pcLCA;
end;

Procedure TCalPanel.BinShow(Sender : TObject);
begin

  if FBin <> nil then
    if FBin.HostDockSite is TPanel then
    begin
      if TPanel(FBin.HostDockSite).Height = 0 then
      begin
        GetPlanView.ShowDockPanel(FBin.HostDockSite as TPanel, True, nil);
        BringWindowToTop(Fbin.Handle);
        FBinIconShape1.OptionsImage.ImageIndex := 1;
        TcxButton(Sender).Hint  := _('Hide Bin');
      end else
      begin
        GetPlanView.ShowDockPanel(FBin.HostDockSite as TPanel, False, nil);
        FBinIconShape1.OptionsImage.ImageIndex := 0;
        TcxButton(Sender).Hint  := _('Show Bin');
      end;
    end;
end;

Procedure TCalPanel.BinHide(Sender : TObject);
begin

  if FBin <> nil then
    if FBin.HostDockSite is TPanel then
    begin
      GetPlanView.ShowDockPanel(FBin.HostDockSite as TPanel, False, nil);
      try
       { FMQMPlan.ImageList2.GetBitmap(1, FBinIconShape1.Picture.Bitmap);
        FMQMPlan.ImageList2.GetBitmap(2, FBinIconShape2.Picture.Bitmap);   }
      except
      end;
    end;
 // FBin.Visible := False;
  //FBin.FormClose(FBin,Action);

end;

procedure TCalPanel.FTrcBarZoomChange(Sender: TObject);
begin
  Canvas.Font := Font;

  if FMQMPlan.m_pgcPlan <> nil then
  TabCfg := TPlanTabCfg(FMQMPlan.m_planTbCfg.FindTab(FMQMPlan.m_pgcPlan.GetActiveView.GetCode));

  FLw := Canvas.TextWidth('m') * 5 div 2 + 30 + FHorizontalTrcBarZoom.Position;
  tabcfg.m_HZoom := FHorizontalTrcBarZoom.Position;

  FPaintBox.Repaint;

  FOnCalendarChanged(Self);

  FHorizontalBarZoomShape.m_HorizonTrcBarZoom_Val := FHorizontalTrcBarZoom.Position;
  FHorizontalTrcBarZoom.Repaint;
  FHorizontalBarZoomShape.repaint
end;

//----------------------------------------------------------------------------//

procedure TCalPanel.OnResizePanel(Sender: TObject);
begin
  ReShape(Self);
end;

//----------------------------------------------------------------------------//

destructor TCalPanel.Destroy;
var
  i: Integer;
begin
  for i := Low(FButtonBmps) to High(FButtonBmps) do
    FButtonBmps[i].Free;

  inherited Destroy;
end;

{ --------------------------------------------------------------------- }
{                                                                       }
{                       Conversion routines                             }
{                                                                       }
{ --------------------------------------------------------------------- }

// Number of pixels per day based on the current time scale
function TCalPanel.PixelsPerDay: Real;
begin
  Result := FLw * UMperDay[FTimeScale];
end;

//----------------------------------------------------------------------------//

(* The Time-Pixels conversion routines use LeftTime as offset 0,
  which means that the pixels are relative to the left side of
  the paintbox *)
function TCalPanel.TimeToPixels(time: TDateTime): Integer;
begin
  Result := Round((time - FLeftTime) * PixelsPerDay);
end;

//----------------------------------------------------------------------------//

function TCalPanel.PixelsToTime(x: Integer): TDateTime;
begin
  Result := FLeftTime + x / PixelsPerDay;
end;

//----------------------------------------------------------------------------//

function TCalPanel.PixelQuant: TDateTime;
begin
  Result := 1 / PixelsPerDay;
end;

//----------------------------------------------------------------------------//

function TCalPanel.GetRightTime: TDateTime;
begin
  Result := PixelsToTime(FPaintBox.Width-1);
end;

{ --------------------------------------------------------------------- }
{                                                                       }
{                      Events and utility routines                      }
{                                                                       }
{ --------------------------------------------------------------------- }

{
  Return the TDateTime of the first day of the week
  to which `d' belongs.
  For example:
    d = Thu Nov 19 1998 12 AM
    the function returns:
      Mon Nov 16 1998 0 AM
}

{ --------------------------------------------------------------------- }

procedure TCalPanel.FBtnTodayMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ChangeLeftDate(sender);
end;

{ --------------------------------------------------------------------- }

function TCalPanel.FirstDayOfWeekOf(d: TDateTime): TDateTime;
begin
  d := Trunc(d);
  while not IsFirstDayOfWeek(d) do
    d := d - 1.0;
  Result := d;
end;

//----------------------------------------------------------------------------//

function TCalPanel.getFTImageToday : TcxButton;
begin
  result := FTImageToday
end;

//----------------------------------------------------------------------------//

function TCalPanel.IsFirstDayOfWeek(d: TDateTime): Boolean;
begin
  if GetFirstDayOfWeekLocaleInformation = '0' then  //Monday - first day of week
    Result := DayOfWeek(d) = FDOW
  else if GetFirstDayOfWeekLocaleInformation = '5' then  //Saturday - first day of week
    Result := DayOfWeek(d) = 7
  else
    Result := DayOfWeek(d) = 1 //Sunday - first day of week
end;

//----------------------------------------------------------------------------//

function TCalPanel.IsLastDayOfWeek(d: TDateTime): Boolean;
begin
  if GetFirstDayOfWeekLocaleInformation = '0' then //Monday - first day of week
    Result := DayOfWeek(d) = LDOW
  else if GetFirstDayOfWeekLocaleInformation = '5' then  //Saturday - first day of week
    Result := DayOfWeek(d) = 7
  else
    Result := DayOfWeek(d) = 7  //Sunday - first day of week
end;

//----------------------------------------------------------------------------//

procedure TCalPanel.ChangeTimeScale(Sender: TObject);
var
  ts,sd: TTimeScale;
  tc : TPlanTabCfg;
begin
  if FCombobox.ItemIndex = 0 then
    ts := csOneHour
  else if FCombobox.ItemIndex = 1 then
    ts := csFourHours
  else if FCombobox.ItemIndex = 2 then
    ts := csOneDay
  else if FCombobox.ItemIndex = 3 then
    ts := csOneWeek;


//  for ts := Low(TTimeSCale) to High(TTimeSCale) do
 // begin
    if Sender = FComboBox then
    begin
      if ts <> FTimeScale then
      begin
        if ts > FTimeScale then
          if ts <> csOneWeek then
            FLeftTime := Trunc(FLeftTime)
          else
            FLeftTime := FirstDayOfWeekOf(FLeftTime);
        FTimeScale := ts;
        SetButtonHints;
        FPaintBox.Repaint;
        if Assigned(FOnCalendarChanged) then
          FOnCalendarChanged(Self);

        tc := TPlanTabCfg(FMQMPlan.m_planTbCfg.FindTab(FMQMPlan.m_pgcPlan.GetActiveView.GetCode));
        tc.m_CurrTScale := FCombobox.ItemIndex;

        exit
      end;
            // new time scale found, nothing more to do
    end;
 // end;
end;

//----------------------------------------------------------------------------//

procedure TCalPanel.SetTimeScale(ts : TTimeScale);
begin
  case ts of
    csOneHour  : FCombobox.ItemIndex := 0;
    csFourHours: FCombobox.ItemIndex := 1;
    csOneDay   : FCombobox.ItemIndex := 2;
    csOneWeek  : FCombobox.ItemIndex := 3;
  end;
  FTimeScale := ts
end;

//----------------------------------------------------------------------------//

procedure TCalPanel.ChangeLeftDate(Sender: TObject);
var tc : TPlanTabCfg;
begin
  if Sender = FRightLeftButtons[1] then
    FLeftTime := FLeftTime - LargeChange[FTimeScale]
  else if Sender = FRightLeftButtons[2] then
    FLeftTime := FLeftTime - SmallChange[FTimeScale]
  else if Sender = FRightLeftButtons[3] then
    FLeftTime := FLeftTime + SmallChange[FTimeScale]
  else if Sender = FRightLeftButtons[4] then
    FLeftTime := FLeftTime + LargeChange[FTimeScale]
  else if Sender = FTImageToday then
    FLeftTime := date
  else if Sender = FDateTimePicker then
  begin
    if FTimeScale = csOneWeek then
      FLeftTime := FirstDayOfWeekOf(Trunc(FDateTimePicker.Date))
    else
      FLeftTime := Trunc(FDateTimePicker.Date);
  end;

  if FLeftTime < FStartTime then
    FLeftTime := FStartTime;

   tc := TPlanTabCfg(FMQMPlan.m_planTbCfg.FindTab(FMQMPlan.m_pgcPlan.GetActiveView.GetCode));
   tc.m_CurrDtTime := FLeftTime;

// if FLeftTime <> PrevLeftTime then
//  begin
    FPaintBox.Repaint;
    if Assigned(FOnCalendarChanged) then
      FOnCalendarChanged(Self);
//  end;
end;

//----------------------------------------------------------------------------//

procedure TCalPanel.UpdateCaptions;
var ts: TTimeScale;
  i : Integer;
begin
  FGroupBox.Caption    := _('Time scale');
  //FGBoxBarZoom.Caption := _('Horizontal zoom');
  RadioButtonCaptions[csOneHour]   := _('1 hour');
  RadioButtonCaptions[csFourHours] := _('4 hours');
  RadioButtonCaptions[csOneDay]    := _('1 day');
  RadioButtonCaptions[csOneWeek]   := _('1 week');

  i := 0;
  for ts := Low(TTimeSCale) to High(TTimeSCale) do
  begin
    FComboBox.items[i] := RadioButtonCaptions[ts];

    if ts = FTimeScale then
        FCombobox.ItemIndex := FCombobox.Items.IndexOf(RadioButtonCaptions[ts]);

    inc(i);
  end;
  invalidate
end;

//----------------------------------------------------------------------------//

procedure TCalPanel.GoToTime(t: TDateTime);
var
  PrevLeftTime: TDateTime;
  year, month, day, hour, min, sec, msec: Word;
begin
  PrevLeftTime := FLeftTime;
  if FTimeScale = csOneWeek then
    FLeftTime := FirstDayOfWeekOf(t)
  else
  begin
    DecodeDate(t, year, month, day);
    DecodeTime(t, hour, min, sec, msec);

    // adjust hour, if necessary
    if FTimeScale = csFourHours then
      hour := hour div 4 * 4
    else if FTimeScale = csOneDay then
      hour := 0;

    FLeftTime := EncodeDate(year, month, day)+ EncodeTime(hour, 0, 0, 0)
  end;

  if FLeftTime < FStartTime then
    FLeftTime := FStartTime;

  if FLeftTime <> PrevLeftTime then
  begin
    FPaintBox.Repaint;
    if Assigned(FOnCalendarChanged) then
      FOnCalendarChanged(Self)
  end
end;

//----------------------------------------------------------------------------//

(* Left/Right click on the calendar moves the clicked point (date)
   to the left/right edge of the window *)
procedure TCalPanel.MouseButtonPressed(Sender: TObject; Button: TMouseButton;
                                        Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
    GoToTime(PixelsToTime(X))
  else if Button = mbRight then
    GoToTime(FLeftTime - GetRightTime + PixelsToTime(X+FLw));
end;

procedure TCalPanel.MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Screen.Cursor := crHandPoint;
end;

//----------------------------------------------------------------------------//

procedure TCalPanel.SetButtonHints;
begin
  case FTimeScale of
    csOneHour:
      begin
        FRightLeftButtons[1].Hint := _('Prev. day');
        FRightLeftButtons[2].Hint := _('Prev. hour');
        FRightLeftButtons[3].Hint := _('Next hour');
        FRightLeftButtons[4].Hint := _('Next day')
      end;
    csFourHours:
      begin
        FRightLeftButtons[1].Hint := _('Prev. day');
        FRightLeftButtons[2].Hint := _('Prev. 4h');
        FRightLeftButtons[3].Hint := _('Next 4h');
        FRightLeftButtons[4].Hint := _('Next day')
      end;
    csOneDay:
      begin
        FRightLeftButtons[1].Hint := _('Prev. week');
        FRightLeftButtons[2].Hint := _('Prev. day');
        FRightLeftButtons[3].Hint := _('Next day');
        FRightLeftButtons[4].Hint := _('Next week')
      end;
    else  { one week }
      begin
        FRightLeftButtons[1].Hint := _('Prev. 4w');
        FRightLeftButtons[2].Hint := _('Prev. week');
        FRightLeftButtons[3].Hint := _('Next week');
        FRightLeftButtons[4].Hint := _('Next 4w')
      end;
  end;
end;

//----------------------------------------------------------------------------//

//  Calculate the day number in the year for a given date

function DayOfYear(Day, Month, Year: Integer): Integer;
const
  DaysInYear: array [1..12] of Integer =
    ( 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334 );
begin
  Result := DaysInYear[Month] + Day;
  if (Month > 2) and IsLeapYear(Year) then
    Result := Result + 1;
end;

//----------------------------------------------------------------------------//

(*
  Calculate the week number according to International
  standard IS-8601. A week that lies partly in one year and
  partly in another is assigned a number in the year in which
  most of its days lie.
  This means that
      week 1 of any year is the week that contains 4 January
  or equivalently
      week 1 of any year is the week that contains the first
  Thurday of January.
  Most years have 52 weeks, but years that start on a Thurday
  and leap years that start on a Wednesday (or Thursday) have
  53 weeks.

  In the international standard IS-8601 the International
  Organization for Standardization (ISO) has decreed that
  Monday shall be the first day of the week.

  Return
    week number or -1 on error
*)

function WeekNumber(d: TDateTime): Integer;
const
  MONDAY = 0;
  TUESDAY = 1;
  WEDNESDAY = 2;
  THURSDAY = 3;
  FRIDAY = 4;
  SATURDAY = 5;
  SUNDAY = 6;
var
  day, month, year: Word;
  DowJanFirst: Integer;   // day of week of 1st January of year
  yday: Integer;          // Days since January 1 of year
  wday: Integer;          // Day of week
  maxweek: Integer;
begin
  DecodeDate(d, year, month, day);
  yday := DayOfYear(day, month, year) - 1;

  // This algorithm needs a different day numbering scheme than
  //  the one used by Delphi. We want Monday=0 ... Sunday=6

  wday := (DayOfWeek(d) - 2 + 7) mod 7;
  DowJanFirst := wday - yday mod 7;
  if DowJanFirst < 0 then
    DowJanFirst := DowJanFirst + 7;

  // The tricky part is the (yday + DowJanFirst) expression.
  //  This is the total number of days elapsed from the Monday
  //  of the week which contains the first of January.

  Result := (yday + DowJanFirst) div 7;
  if DowJanFirst < FRIDAY then
    Result := Result + 1;

  if Result <= 0 then
    // There is no such thing as week 0:
    // week 0 is the last week of the previous year
    Result := WeekNumber(EncodeDate(Year-1, 12, 31))
  else
  begin
    // The last week of the year could be the first week of next year
    if (DowJanFirst = THURSDAY) or
       (IsLeapYear(Year) and (DowJanFirst = WEDNESDAY)) then
      maxweek := 53
    else
      maxweek := 52;
    if Result > maxweek then Result := 1
  end
end;

{ --------------------------------------------------------------------- }

procedure TCalPanel.ChangeToWorkCentersScreen(Sender: TObject);
begin
  FTimageWorkCenters.Enabled := False;
  ChangeTabFromResourcesToWorkCenters(true);
  FTimageWorkCenters.Enabled := True;
end;

{ --------------------------------------------------------------------- }
{                                                                       }
{                          Paint routines                               }
{                                                                       }
{ --------------------------------------------------------------------- }

procedure TCalPanel.PaintCalendar(Sender: TObject);
var
  deltay, y1, y2: Integer;
begin
  with FPaintBox, FPaintBox.Canvas do
  begin
    // erase calendar background }
    Pen.Color := Color;
    Brush.Color := Color;
    Brush.Style := bsSolid;
    Rectangle(0, 0, Width, Height);
    Font.Color := clBlack;
    Pen.Color := clBlack;

    FontResize2(Font,0);//Font.Size := 8;

    // calculate vertical positions for text and lines:
    // the paintbox is divided vertically in four parts
    deltay := (Height - 1) div 4;
    y1 := 2 * deltay;
    y2 := 4 * deltay;

    Pen.color:=Clgray;
    moveTo(0, 0); LineTo (width-1,0);
    // draw the horizontal lines
    Pen.Color := ColorPenLine;//clBlack;
    MoveTo(0,1); LineTo(Width-1,  1);
    MoveTo(0, y1); LineTo(Width-1, y1);
    Pen.Color := ClWhite;
    MoveTo(0, y1-1); LineTo(Width-1, y1-1);
    Pen.Color := clBlack;
    MoveTo(0, y2); LineTo(Width-1, y2)
  end;

  case FTimeScale of
    csOneHour:   Paint1h(Sender, y1, y2);
    csFourHours: Paint4h(Sender, y1, y2);
    csOneDay:    Paint1d(Sender, y1, y2);
    csOneWeek:   Paint1w(Sender, y1, y2)
  end

end;

//----------------------------------------------------------------------------//

procedure TCalPanel.Paint1h(Sender: TObject; y1, y2: Integer);
var
  x: Integer;
  year, month, day, hour, min, sec, msec: Word;
  d, now: TDateTime;
  DayRect, HourRect: TRect;
  s: String;
begin
   DLabel.Caption := '';

  with FPaintBox do
  begin
    now := Date;
    d := Trunc(FLeftTime);
    x := TimeToPixels(d);
    DayRect  := Rect(x+2, 1, x+24*FLw-2, y1);
    HourRect := Rect(x+1, y1+1, x+FLw-2, y2);

    while x < Width do
    begin
      DecodeDate(d, year, month, day);
      DecodeTime(d, hour, min, sec, msec);

      Canvas.MoveTo(x, y2);

      if hour = 0 then
      begin
        if Round(d) = now then
        begin
          Canvas.Brush.Color := RGB(220, 220, 220);
          Canvas.FillRect(DayRect);
          Canvas.Brush.Color := Color;
          Canvas.Font.Color := clGreen;
          Canvas.Font.Style := [fsBold];
        end;
          Canvas.LineTo(x, 1);
          Canvas.Pen.color:=ClWhite;
          Canvas.MoveTo(x+1,y2);
          Canvas.LineTo(x+1,0);
          Canvas.Pen.Color:=ColorPenLine;//ClBlack;

          case DayOfWeek(d) of
            1: s := ' '+ _('Sunday');
            2: s := ' '+ _('Monday');
            3: s := ' '+ _('Tuesday');
            4: s := ' '+ _('Wednesday');
            5: s := ' '+ _('Thursday');
            6: s := ' '+ _('Friday');
            7: s := ' '+ _('Saturday')
          end;

          s := s + ' ' + IntToStr(Day) + ' ';

          case month of
            1:  s := s + _('January');
            2:  s := s + _('February');
            3:  s := s + _('March');
            4:  s := s + _('April');
            5:  s := s + _('May');
            6:  s := s + _('June');
            7:  s := s + _('July');
            8:  s := s + _('August');
            9:  s := s + _('September');
            10: s := s + _('October');
            11: s := s + _('November');
            12: s := s + _('December')
          end;
          s := s + ' ' + IntToStr(Year);

          Windows.DrawText(Canvas.Handle, PChar(s), Length(s), DayRect,
                         DT_SINGLELINE or DT_LEFT or DT_VCENTER);
          OffsetRect(DayRect, 24 * FLw, 0);
          Canvas.Font.Color := clBlack;
          Canvas.Font.Style := [];


      end
      else
      begin
          Canvas.LineTo(x, y1+(y1 div 2));
          Canvas.Pen.color:=ClWhite;
          Canvas.MoveTo(x+1, y2-2);
          Canvas.LineTo(x+1, y1+(y1 div 2));
          Canvas.Pen.color:=ColorPenLine;//ClBlack;
      end;

      if x = 0 then
        DLabel.Caption := Formatdatetime('t',d);

      s := IntToStr(hour);

      if length(s)>1 then
        s:=s+':00'
      else
        s:='0'+s+':00';
      Windows.DrawText(Canvas.Handle, PChar(s), Length(s), HourRect,
                       DT_SINGLELINE or DT_CENTER or DT_VCENTER);

      d := d + 1 / 24;   // next hour
      Inc(x, FLw);       // next vertical line
      OffsetRect(HourRect, FLw, 0) ;
    end
  end;


  DLabel.Left := FRightLeftButtons[2].Left + FRightLeftButtons[2].Width + 30;
end;

//----------------------------------------------------------------------------//

procedure TCalPanel.Paint4h(Sender: TObject; y1, y2: Integer);
var
  x: Integer;
  year, month, day, hour, min, sec, msec: Word;
  d, now: TDateTime;
  s,t: String;
  DayRect, HourRect: TRect;
begin
  DLabel.Caption := '';

  with FPaintBox do
  begin
    now := Date;
    d := Trunc(FLeftTime);
    x := TimeToPixels(d);

    DayRect  := Rect(x+2, 1, x+6*FLw-2, y1);
    HourRect := Rect(x+1, y1+1, x+FLw-2, y2);

    while x < Width do
    begin
      DecodeDate(d, year, month, day);
      DecodeTime(d, hour, min, sec, msec);

      Canvas.MoveTo(x, y2);
      if hour = 0 then
      begin
        if Round(d) = now then
        begin
          Canvas.Brush.Color := RGB(220, 220, 220);
          Canvas.FillRect(DayRect);
          Canvas.Brush.Color := Color;
          Canvas.Font.Color := clGreen;
          Canvas.Font.Style := [fsBold];
        end;
        Canvas.LineTo(x, 0);
         Canvas.Pen.color:=ClWhite;
        Canvas.MoveTo(x+1,y2);
        Canvas.LineTo(x+1,0);
        Canvas.Pen.Color:=ColorPenLine;//ClBlack;

        case DayOfWeek(d) of
          1: s := ' '+ _('Sunday');
          2: s := ' '+ _('Monday');
          3: s := ' '+ _('Tuesday');
          4: s := ' '+ _('Wednesday');
          5: s := ' '+ _('Thursday');
          6: s := ' '+ _('Friday');
          7: s := ' '+ _('Saturday')
        end;

        s := s + ' ' + IntToStr(Day) + ' ';

        case month of
          1:  s := s + _('January');
          2:  s := s + _('February');
          3:  s := s + _('March');
          4:  s := s + _('April');
          5:  s := s + _('May');
          6:  s := s + _('June');
          7:  s := s + _('July');
          8:  s := s + _('August');
          9:  s := s + _('September');
          10: s := s + _('October');
          11: s := s + _('November');
          12: s := s + _('December')
        end;
        s := s + ' ' + IntToStr(Year);

        Windows.DrawText(Canvas.Handle, PChar(s), Length(s), DayRect,
                         DT_SINGLELINE or DT_LEFT or DT_VCENTER);
        OffsetRect(DayRect, 6 * FLw, 0);
        Canvas.Font.Color := clBlack;
        Canvas.Font.Style := [];
      end
      else
        begin
        Canvas.LineTo(x, y1+(y1 div 2));
        Canvas.Pen.color:=ClWhite;
        Canvas.MoveTo(x+1, y2-2);
        Canvas.LineTo(x+1, y1+(y1 div 2));
        Canvas.Pen.color:=ColorPenLine;//ClBlack;
        end;

      s := IntToStr(hour);
      t := Inttostr(hour+3);

      if length(s)=1 then
        s:='0'+s;
      if length(t)=1 then
        t:='0'+t;
      s:=s+'-'+t;
      Windows.DrawText(Canvas.Handle, PChar(s), Length(s), HourRect,
                       DT_SINGLELINE or DT_CENTER or DT_VCENTER);

      if x = 0 then
        DLabel.Caption := s;

      d := d + 1 / 6;    // next four hours
      Inc(x, FLw);       // next vertical line
      OffsetRect(HourRect, FLw, 0)
    end
  end;

   DLabel.Left := FRightLeftButtons[2].Left + FRightLeftButtons[2].Width + 40;
end;

//----------------------------------------------------------------------------//

function ConvertFormatToStr(Temp : Word) : string;
begin
  if Temp = 1 then
    Result := '01'
  else if Temp = 2 then
    Result := '02'
  else if Temp = 3 then
    Result := '03'
  else if Temp = 4 then
    Result := '04'
  else if Temp = 5 then
    Result := '05'
  else if Temp = 6 then
    Result := '06'
  else if Temp = 7 then
    Result := '07'
  else if Temp = 8 then
    Result := '08'
  else if Temp = 9 then
    Result := '09'
  else
    Result := IntToStr(Temp);
end;

//----------------------------------------------------------------------------//



procedure TCalPanel.Paint1d(Sender: TObject; y1, y2: Integer);
var
  x: Integer;
  year, month, day: Word;
  s, str: String;
  d, now, l: TDateTime;
  DayRect, WeekRect: TRect;
  ShortDateFormat : string;
begin
  DLabel.Caption := '';

  with FPaintBox do
  begin
    now := Date;

    d := FirstDayOfWeekOf(FLeftTime);
    x := TimeToPixels(d);


    WeekRect := Rect(x+2, 1, x+7*FLw-2, y1);
    DayRect  := Rect(x+1, y1+1, x+FLw-2, y2);

    while x < Width do
    begin
      DecodeDate(d, year, month, day);

      Canvas.MoveTo(x, y2);
      if IsFirstDayOfWeek(d) then
      begin
        Canvas.LineTo(x, 0);
        Canvas.Pen.color:=ClWhite;
        Canvas.MoveTo(x+1,y2);
        Canvas.LineTo(x+1,0);
        Canvas.Pen.Color:=ColorPenLine;

        //Mihailo
        if DBAppSettings.CalDayFormat = '2' then
            s := ' '+ConvertFormatToStr(day) + '/' + ConvertFormatToStr(month) +'/' +ConvertFormatToStr(year)
        else if DBAppSettings.CalDayFormat = '3' then
          s := ' '+ConvertFormatToStr(month) + '/' + ConvertFormatToStr(day) +'/' +ConvertFormatToStr(year)
        else
          s := ' '+FormatDateTime(ShortDateFormat, d);

        s := s + ' (' + IntToStr(WeekNumber(d)) + ')';
        Windows.DrawText(Canvas.Handle, PChar(s), Length(s), WeekRect,
                         DT_SINGLELINE or DT_LEFT or DT_VCENTER);
      end
      else
      begin
        Canvas.LineTo(x, y1+(y1 div 2));
        Canvas.Pen.color:=ClWhite;
        Canvas.MoveTo(x+1, y2-2);
        Canvas.LineTo(x+1, y1+(y1 div 2));
        Canvas.Pen.color := ColorPenLine;
        if IsLastDayOfWeek(d) then
          OffsetRect(WeekRect, 7*FLw, 0);
      end;

      // write the name of the day
      if d = now then
      begin
        Canvas.Brush.Color := RGB(220, 220, 220);
        Canvas.FillRect(DayRect);
        Canvas.Brush.Color := Color;
        Canvas.Font.Color := clGreen;
        Canvas.Font.Style := [fsBold];
      end
      else if IsLastDayOfWeek(d) then
        Canvas.Font.Color := clRed;

      if DBAppSettings.CalDayFormat = '' then
         DBAppSettings.CalDayFormat := '0';

      if DBAppSettings.CalDayFormat = '0' then
      begin
        case DayOfWeek(d) of
          1: s := _('Sun');
          2: s := _('Mon');
          3: s := _('Tue');
          4: s := _('Wed');
          5: s := _('Thu');
          6: s := _('Fri');
          7: s := _('Sat')
        end;
      end
      else if DBAppSettings.CalDayFormat = '1' then
      begin
        str := ConvertFormatToStr(day);
        case DayOfWeek(d) of
          1: s := _('Sun/' + str);
          2: s := _('Mon/' + str);
          3: s := _('Tue/' + str);
          4: s := _('Wed/' + str);
          5: s := _('Thu/' + str);
          6: s := _('Fri/' + str);
          7: s := _('Sat/' + str);
        end;
      end
      else if DBAppSettings.CalDayFormat = '2' then
      begin
        case DayOfWeek(d) of
          1: s := (ConvertFormatToStr(day) + '/' + ConvertFormatToStr(month));
          2: s := (ConvertFormatToStr(day) + '/' + ConvertFormatToStr(month));
          3: s := (ConvertFormatToStr(day) + '/' + ConvertFormatToStr(month));
          4: s := (ConvertFormatToStr(day) + '/' + ConvertFormatToStr(month));
          5: s := (ConvertFormatToStr(day) + '/' + ConvertFormatToStr(month));
          6: s := (ConvertFormatToStr(day) + '/' + ConvertFormatToStr(month));
          7: s := (ConvertFormatToStr(day) + '/' + ConvertFormatToStr(month));
        end;
      end
      else if DBAppSettings.CalDayFormat = '3' then
      begin
        case DayOfWeek(d) of
          1: s := (ConvertFormatToStr(month) + '/' + ConvertFormatToStr(day));
          2: s := (ConvertFormatToStr(month) + '/' + ConvertFormatToStr(day));
          3: s := (ConvertFormatToStr(month) + '/' + ConvertFormatToStr(day));
          4: s := (ConvertFormatToStr(month) + '/' + ConvertFormatToStr(day));
          5: s := (ConvertFormatToStr(month) + '/' + ConvertFormatToStr(day));
          6: s := (ConvertFormatToStr(month) + '/' + ConvertFormatToStr(day));
          7: s := (ConvertFormatToStr(month) + '/' + ConvertFormatToStr(day));
        end;
      end;

      Windows.DrawText(Canvas.Handle, PChar(s), Length(s), DayRect,
                       DT_SINGLELINE or DT_CENTER or DT_VCENTER);
      Canvas.Font.Color := clBlack;
      Canvas.Font.Style := [];

      if x = 0 then
        DLabel.Caption := FormatDateTime('d', d) + ' '+ _(FormatDateTime('mmmm', d)) ;

      d := d + 1;        // next day
      Inc(x, FLw);       // next vertical line
      OffsetRect(DayRect, FLw, 0) ;

    end ;
  end;

  DLabel.Left := FRightLeftButtons[2].Left + FRightLeftButtons[2].Width + 30;
end;

//----------------------------------------------------------------------------//

procedure TCalPanel.Paint1w(Sender: TObject; y1, y2: Integer);
var
  year, month, day: Word;
  currentmonth, currentYear: Word;
  d, dm, now: TDateTime;
  x, xm: Integer;
  monthStr,s,t: String;
  WeekRect, MonthRect: TRect;
begin
  DLabel.Caption := '';

  with FPaintBox do
  begin
    now := Date;
    DecodeDate(now, year, currentmonth, day);
    CurrentYear := year;

    // draw month names in the upper part

    DecodeDate(FLeftTime, year, month, day);
    while (True) do
    begin
        dm := EncodeDate(year, month, 1);
        monthStr := '';
        case month of
          1:  monthStr  := _('January');
          2:  monthStr  := _('February');
          3:  monthStr  := _('March');
          4:  monthStr  := _('April');
          5:  monthStr  := _('May');
          6:  monthStr  := _('June');
          7:  monthStr  := _('July');
          8:  monthStr  := _('August');
          9:  monthStr  := _('September');
          10: monthStr  := _('October');
          11: monthStr  := _('November');
          12: monthStr  := _('December')
        end;

        xm := TimeToPixels(dm);
        if (xm > Width) then
          Break;
        Canvas.MoveTo(xm, y1);
        Canvas.LineTo(xm, 0);
        Canvas.Pen.Color:=ClWhite;
        Canvas.MoveTo(xm+1,y1);
        Canvas.LineTo(xm+1,0);
        Canvas.Pen.Color:=ColorPenLine;//ClBlack;
        MonthRect := Rect(xm+2, 1, xm+10*FLw, y1);

        s :=' '+ monthStr + FormatDateTime(' yyyy', dm);

        if (month = currentmonth) and (Year = CurrentYear) then
        begin
          Canvas.Brush.Color := RGB(220, 220, 220);
          Canvas.FillRect(MonthRect);
          Canvas.Brush.Color := Color;
          Canvas.Font.Color := clGreen;
          Canvas.Font.Style := [fsBold];
        end;

        Windows.DrawText(Canvas.Handle, PChar(s), Length(s), MonthRect,
                         DT_SINGLELINE or DT_LEFT or DT_VCENTER);

        if (month = currentmonth) and (Year = CurrentYear) then
        begin
          Canvas.Font.Color := clBlack;
          Canvas.Font.Style := [];
        end;

        month := month + 1;

        if month = 13 then
        begin
          month := 1;
          year := year + 1;
        end;
    end;

    // draw weeks in the lower part

    d := FirstDayOfWeekOf(FLeftTime);
    x := TimeToPixels(d);


    WeekRect := Rect(x+1, y1+1, x+FLw-2, y2);

    while x < Width do
    begin
      DecodeDate(d, year, month, day);
      Canvas.MoveTo(x, y2);
      Canvas.LineTo(x, y1+(y1 div 2));
      Canvas.Pen.color:=ClWhite;
      Canvas.MoveTo(x+1, y2-2);
      Canvas.LineTo(x+1, y1+(y1 div 2));
      Canvas.Pen.color:=ColorPenLine;//ClBlack;
      if (d <= now) and (now < d+7) then
      begin
        Canvas.Brush.Color := RGB(220, 220, 220);
        Canvas.FillRect(WeekRect);
        Canvas.Brush.Color := Color;
        Canvas.Font.Color := clGreen;
        Canvas.Font.Style := [fsBold];
      end;
      s := IntToStr(day);
      DecodeDate(d+6,year,month,day);
      t := InttoStr(day);
      if length(s)=1 then
        s:='0'+s;
      if length(t)=1 then
        t:='0'+t;
      s:=s+' - '+t;
      Windows.DrawText(Canvas.Handle, PChar(s), Length(s), WeekRect,
                       DT_SINGLELINE or DT_CENTER or DT_VCENTER);
      Canvas.Font.Color := clBlack;
      Canvas.Font.Style := [];

      if x <= 0 then
      begin
        if  DLabel.Caption = '' then
           DLabel.Caption := FormatDateTime('d',  d) + ' '+ AnsiLeftStr(_(FormatDateTime('mmmm',  d)),3) ;

        if  Length(DLabel.Caption) < 7 then
           DLabel.Caption := DLabel.Caption + ' - ' +FormatDateTime('d',  d+6) + ' '+ AnsiLeftStr(_(FormatDateTime('mmmm',  d+6)),3) ;
      end;

      d := d + 7;       // next week
      x := x + FLw;     // next vertical line
      OffsetRect(WeekRect, FLw, 0)  ;
    end
  end ; // with FPaintBox

  DLabel.Left := FRightLeftButtons[2].Left + FRightLeftButtons[2].Width + 10;
end;

//----------------------------------------------------------------------------//

{ TShape }

procedure TShapeCal.Paint;
begin
  inherited;

   //     FImage.canvas.pen.Color := clred;
   //   FImage.Canvas.TextOut(5, 5, 'SomeText');


 { if name = 'FBtnToday' then
  begin
    Canvas.Font.Name :='Arial';
    Canvas.Font.Size  :=12;
    Canvas.Font.Color:= clwhite;
    Canvas.TextOut(17,5,_('Today'));
  end; }

  // Canvas.Font.Style := [fsBold];
{  if name = 'RightLeftButton1' then
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

  if name = 'FHorizontalBarZoomShape' then
  begin
    // we do not show the % but the paint function still must paas here ...
    // avi 10/12/2020
   { Canvas.Font.color := ClBlack;
    Canvas.Font.name := 'Montserrat';
    Canvas.TextOut(1,7, IntToStr(m_HorizonTrcBarZoom_Val) + '%');
    Canvas.pen.Color := clwhite;      }

    // will salved for painting other TImage
    if assigned(m_CalPanel) and assigned(m_CalPanel.FTimageWorkCenters) then
    begin
      with m_CalPanel.FTimageWorkCenters do
      begin
        {Canvas.Font.Size  := 11;
        Canvas.Font.Color:= clwhite;
        Canvas.Font.name := 'Montserrat';
        Canvas.TextOut(22,11,_('Work Centers')); }
        Caption := _('Work Centers');
      end;
    end;

    with m_CalPanel.FDateTimePicker do
    begin
      FontResize2(Font, 0)
    end;

    with m_CalPanel.FTImageToday do
    begin
     // Canvas.Font.Name :='Arial';
      {Canvas.Font.Size  := 11;
      Canvas.Font.Color:= clwhite;
      Canvas.Font.name := 'Montserrat';
      Canvas.TextOut(17,10,_('Today'));   }
      Caption := _('Today');
    end;

    with m_CalPanel.FRightLeftButtons[1] do
    begin
     { Canvas.Font.Style := [fsBold];
      Canvas.Font.color := ClWhite;
      Canvas.TextOut(13,12,_('<<')); }
      Caption := _('<<');
    end;

    with m_CalPanel.FRightLeftButtons[2] do
    begin
     { Canvas.Font.Style := [fsBold];
      Canvas.Font.color := ClWhite;
      Canvas.TextOut(18,12,_('<'));  }
      Caption := _('<');
    end;

    with m_CalPanel.FRightLeftButtons[3] do
    begin
     { Canvas.Font.Style := [fsBold];
      Canvas.Font.color := ClWhite;
      Canvas.TextOut(18,12,_('>'));     }
      Caption := _('>');
    end;

    with m_CalPanel.FRightLeftButtons[4] do
    begin
     { Canvas.Font.Style := [fsBold];
      Canvas.Font.color := ClWhite;
      Canvas.TextOut(13,12,_('>>'));  }
      Caption := _('>>');
    end;

  end;

  // this component is set to visible folse , so this is not in used
  {if name = 'FResourceBarZoomShape' then
  begin
    Canvas.Font.color := ClBlack;
    Canvas.Font.name := 'Montserrat';
    Canvas.TextOut(1,7, IntToStr(m_ResourceZoom_Val) + '%');
    Canvas.pen.Color := clwhite;
  end; }

 { if name = 'WorkCenters' then
  begin
    Canvas.Font.color := ClWhite;
    Canvas.Font.Size := 11;
    Canvas.TextOut(23,4,_('Work Centers'));
  end;    }

end;

end.

