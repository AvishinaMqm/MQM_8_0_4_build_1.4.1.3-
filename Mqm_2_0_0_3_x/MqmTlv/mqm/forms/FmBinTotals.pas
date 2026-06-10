unit FmBinTotals;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Dateutils,
  Math,
  StdCtrls,
  UGGlobal,
  gnugettext,
  UMBinTBS,
  UMSchedContFunc,
  UMSchedCont,
  UMBinGrid,
  FMBin,
  UMObjCont,
  UMBinPanel,
  UMBinFunc,
  UMSchedList, Buttons, ComCtrls, UReShape, Vcl.ExtCtrls;

type
  TFrmBintotals = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    LblSched: TLabel;
    StTxtRecNo: TStaticText;
    LblJobs: TLabel;
    LblNotSched: TLabel;
    StTxtRecNo2: TStaticText;
    StTxtQty2: TStaticText;
    StTxtQty: TStaticText;
    LblQty: TLabel;
    Label1: TLabel;
    StTxtSetup: TStaticText;
    Label2: TLabel;
    StTxtExe: TStaticText;
    TabSheet2: TTabSheet;
    LabelFrom: TLabel;
    DatePickerFrom: TDateTimePicker;
    TimePickerFrom: TDateTimePicker;
    LabelTo: TLabel;
    DatePickerTo: TDateTimePicker;
    TimePickerTo: TDateTimePicker;
    LblTab2: TLabel;
    LblJobsGroupSched: TLabel;
    StaticTextCountSched: TStaticText;
    StaticTextQtySched: TStaticText;
    LblQtySched: TLabel;
    LblSetUpSched: TLabel;
    StaticTextSetUpSched: TStaticText;
    StaticTextExecSched: TStaticText;
    LblExecSched: TLabel;
    CBxDateType: TComboBox;
    BitBtnReCalc: TcxButton;
    BitBtnAbort: TcxButton;
    BitBtn1: TcxButton;
    procedure FormCreate(Sender: TObject);
    procedure BitBtnReCalcClick(Sender: TObject);
    procedure CalcTotalsWithDate(out SchedCounter: Integer;
                                 out SchedQuantity: Double;
                                 out SchedSetup: Double;
                                 out SchedExe: Double;
                                 StartDate : TDateTime; EndDate : TDateTime; DateFilter : Integer);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtnAbortClick(Sender: TObject);
    procedure PageControl1DrawTab(Control: TCustomTabControl; TabIndex: Integer;
      const Rect: TRect; Active: Boolean);

  private
    { Private declarations }
  public
    { Public declarations }

    procedure ShowTotals();

  end;
  procedure CalcTotals(out notSchedCounter: Integer;
                       out SchedCounter: Integer;
                       out notSchedQuantity: Double;
                       out SchedQuantity: Double;
                       out SchedSetup: Double;
                       out SchedExe: Double);
var
  FrmBintotals: TFrmBintotals;

implementation

uses
  UMCommon, UMReports;

{$R *.DFM}

//----------------------------------------------------------------------------//

procedure TFrmBintotals.ShowTotals();
var

  SchedCounter,
  notSchedCounter : Integer;
  SchedQuantity,
  NotSchedQuantity,
  TotSetup, TotExe: Double;
begin

  CalcTotals(notSchedCounter,SchedCounter,
             notSchedQuantity,SchedQuantity,
             TotSetup,TotExe);
  SetComponent(StTxtRecNo, comp_Descr, false);
  SetComponent(StTxtRecNo2, comp_Descr, false);
  SetComponent(StTxtQty, comp_Descr, false);
  SetComponent(StTxtQty2, comp_Descr, false);
  SetComponent(StTxtSetup, comp_Descr, false);
  SetComponent(StTxtExe, comp_Descr, false);

  SetComponent(StaticTextCountSched, comp_Descr, false);
  SetComponent(StaticTextQtySched, comp_Descr, false);
  SetComponent(StaticTextSetUpSched, comp_Descr, false);
  SetComponent(StaticTextExecSched, comp_Descr, false);

  StaticTextCountSched.Width := 57;
  StaticTextCountSched.Height := 17;
  StaticTextQtySched.Width := 110;
  StaticTextQtySched.Height := 17;
  StaticTextSetUpSched.Width := 110;
  StaticTextSetUpSched.Height := 17;
  StaticTextExecSched.Width := 110;
  StaticTextExecSched.Height := 17;

  StTxtRecNo.Width := 57;
  StTxtRecNo2.Width := 57;
  StTxtRecNo.Height := 17;
  StTxtRecNo2.Height := 17;
  StTxtQty.Width := 110;
  StTxtQty.Height := 17;
  StTxtQty2.Width := 110;
  StTxtQty2.Height := 17;
  StTxtSetup.Width := 110;
  StTxtSetup.Height := 17;
  StTxtExe.Width := 110;
  StTxtExe.Height := 17;

  StTxtRecNo.Caption  := inttoStr( SchedCounter);
  StTxtRecNo2.Caption := inttoStr(notSchedCounter);
  StTxtQty.Caption    := FloattoStr(SchedQuantity);
  StTxtQty2.Caption   := FloattoStr(notSchedQuantity);
  StTxtExe.Caption   := FormatDuration(TotExe, true);
  StTxtSetup.Caption := FormatDuration(TotSetup, true);

end;

//----------------------------------------------------------------------------//

procedure TFrmBintotals.BitBtn1Click(Sender: TObject);
var
  Year, Month, Day: Word;
  Hour, Min, Sec, MSec: Word;
  TimeFrom, TimeTo : TTime;
  DateFrom, DateTo: TDate;
  Save_Cursor : TCursor;
begin
  Save_Cursor   := Screen.Cursor;
  Screen.Cursor  := crAppStart; //SQLWait;
  DecodeDate(DatePickerFrom.Date, Year, Month, Day);
  DateFrom := EncodeDate(Year, Month, Day);
  DecodeTime(TimePickerFrom.Time, Hour, Min, Sec, MSec);
  TimeFrom := EncodeTime(Hour, Min, Sec, MSec);

  DecodeDate(DatePickerTo.Date, Year, Month, Day);
  DateTo := EncodeDate(Year, Month, Day);
  DecodeTime(TimePickerTo.Time, Hour, Min, Sec, MSec);
  TimeTo := EncodeTime(Hour, Min, Sec, MSec);
  HtmlBinExtraction(self, false, DateFrom + TimeFrom,DateTo + TimeTo, CBxDateType.ItemIndex);
  Screen.Cursor := Save_Cursor;
end;

//----------------------------------------------------------------------------//

procedure TFrmBintotals.BitBtnAbortClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmBintotals.BitBtnReCalcClick(Sender: TObject);
var
  Year, Month, Day: Word;
  Hour, Min, Sec, MSec: Word;
  TimeFrom, TimeTo : TTime;
  DateFrom, DateTo: TDate;
  CountSched : integer;
  QtySched,SetUpSched,ExecSched : double;
begin
  if ModalResult = mrok then
     ModalResult := mrNone;

  DecodeDate(DatePickerFrom.Date, Year, Month, Day);
  DateFrom := EncodeDate(Year, Month, Day);
  DecodeTime(TimePickerFrom.Time, Hour, Min, Sec, MSec);
  TimeFrom := EncodeTime(Hour, Min, Sec, MSec);

  DecodeDate(DatePickerTo.Date, Year, Month, Day);
  DateTo := EncodeDate(Year, Month, Day);
  DecodeTime(TimePickerTo.Time, Hour, Min, Sec, MSec);
  TimeTo := EncodeTime(Hour, Min, Sec, MSec);

  CalcTotalsWithDate(CountSched,
             QtySched,
             SetUpSched,ExecSched,DateFrom + TimeFrom, DateTo + TimeTo, CBxDateType.ItemIndex);

  StaticTextCountSched.Caption  := inttoStr(CountSched);
  StaticTextQtySched.Caption    := FloattoStr(QtySched);
  StaticTextSetUpSched.Caption   := FormatDuration(SetUpSched, true);
  StaticTextExecSched.Caption := FormatDuration(ExecSched, true);

end;

//----------------------------------------------------------------------------//

procedure TFrmBintotals.CalcTotalsWithDate(out SchedCounter: Integer;
  out SchedQuantity, SchedSetup, SchedExe: Double; StartDate,
  EndDate: TDateTime; DateFilter : Integer);
var
  i,count: Integer;
  ActTab: TBinTabSheet;
  ActBinGrid: TBinDrawGrid;
  ObjId: TSchedID;
  info:  TSQPlanInfo;
begin
  SchedCounter := 0;
  SchedQuantity := 0;
  SchedSetup := 0;
  SchedExe   := 0;

  ActTab := FBin.GetActiveView;
  ActbinGrid := ActTab.GetBinGrid;

  count := TBinPanel(ActbinGrid.Parent).m_ObjList.GetLinkCount;

  for i := 0 to count - 1  do
  begin
      ObjId := TBinPanel(ActbinGrid.Parent).m_ObjList.GetLink(i);
      p_sc.GetPlanInfo(ObjId, info);
      if info.isOnPlan then
      begin
        if DateFilter = 0 then
        begin
          if info.startDate < StartDate then continue;
          if info.endDate > EndDate then continue;
        end
        else
        begin
          if info.LastScheduleChanged < StartDate then continue;
          if info.LastScheduleChanged > EndDate then continue;
        end;

        SchedCounter := SchedCounter + 1;
        SchedQuantity := SchedQuantity + info.quant;
        SchedQuantity := RoundTo(SchedQuantity,-2);//2 digits after point
        SchedSetup := SchedSetup + info.supMinReal;
        SchedExe := SchedExe + info.exeMin;
      end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFrmBintotals.FormCreate(Sender: TObject);
var
  LowStart , highEnd : TdateTime;
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
  CountSched : integer;
  QtySched,SetUpSched,ExecSched : double;
begin
  TranslateComponent (self);
//  GetLowAndHightDate(LowStart,HighEnd);

  CBxDateType.Items.Add(_('Start Date'));
  CBxDateType.Items.Add(_('Last Schedule Changed'));
  CBxDateType.ItemIndex := 0;
  LowStart := 0;
  HighEnd  := 0;

  DecodeDate(Now, Year, Month, Day);
  DatePickerFrom.Date := EncodeDate(Year, Month, Day);
  DecodeTime(LowStart, Hour, Min, Sec, MSec);
  TimePickerFrom.Time := EncodeTime(Hour, Min, Sec, MSec);

  DecodeDate(Now + DaysInYear(YearOf(Now))*2, Year, Month, Day);
  DatePickerTo.Date := EncodeDate(Year, Month, Day);
  DecodeTime(HighEnd, Hour, Min, Sec, MSec);
  TimePickerTo.Time := EncodeTime(Hour, Min, Sec, MSec);

  CalcTotalsWithDate(CountSched,
             QtySched,
             SetUpSched,ExecSched,LowStart,HighEnd, CBxDateType.ItemIndex);

  StaticTextCountSched.Caption  := inttoStr(CountSched);

  StaticTextQtySched.Caption    := FloattoStr(QtySched);
  StaticTextSetUpSched.Caption   := FormatDuration(SetUpSched, true);
  StaticTextExecSched.Caption := FormatDuration(ExecSched, true);
  ShowToTals;
  BitBtnReCalcClick(self);

  ReShape(Self);
//  ReShape(BitBtnReCalc);
//  ReShape(BitBtnAbort);
//  ReShape(BitBtn1);
end;

procedure TFrmBintotals.PageControl1DrawTab(Control: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
begin
  with Control.Canvas do begin
    Brush.Color := clWhite;
    FillRect(Rect);
    TextOut(Rect.Left + Font.Size -5, Rect.Top + 2, (Control as TPageControl).Pages[TabIndex].Caption) ;
  end;
end;

//----------------------------------------------------------------------------//

procedure CalcTotals(out notSchedCounter: Integer;
                     out SchedCounter: Integer;
                     out notSchedQuantity: Double;
                     out SchedQuantity: Double;
                     out SchedSetup: Double;
                     out SchedExe: Double);
var
  i,count: Integer;
  ActTab: TBinTabSheet;
  ActBinGrid: TBinDrawGrid;
  ObjId: TSchedID;
  info:  TSQPlanInfo;
begin
  SchedCounter := 0;
  notSchedCounter := 0;
  SchedQuantity := 0;
  NotSchedQuantity := 0;
  SchedSetup := 0;
  SchedExe   := 0;

  ActTab := FBin.GetActiveView;
  ActbinGrid := ActTab.GetBinGrid;

  count := TBinPanel(ActbinGrid.Parent).m_ObjList.GetLinkCount;

  for i := 0 to count - 1  do
  begin
      ObjId := TBinPanel(ActbinGrid.Parent).m_ObjList.GetLink(i);
      p_sc.GetPlanInfo(ObjId, info);
      if info.isOnPlan then
      begin
        SchedCounter := SchedCounter + 1;
        SchedQuantity := SchedQuantity + info.quant;
        SchedQuantity := RoundTo(SchedQuantity,-2);//2 digits after point
        SchedSetup := SchedSetup + info.supMinReal;
        SchedExe := SchedExe + info.exeMin;
      end else
      begin
        notSchedCounter := notSchedCounter + 1;
        notSchedQuantity := notSchedQuantity + info.quant;
        notSchedQuantity := RoundTo(notSchedQuantity,-2);//2 digits after point
      end;
  end;
end;

end.
