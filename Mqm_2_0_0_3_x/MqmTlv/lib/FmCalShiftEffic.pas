unit FmCalShiftEffic;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, Vcl.ExtCtrls, UReShape;

type
  TCalShiftEffic = class(TForm)
    TimePicker1Start: TDateTimePicker;
    TimePicker1End: TDateTimePicker;
    EditShiftEffic1: TEdit;
    EditShiftEffic2: TEdit;
    TimePicker2End: TDateTimePicker;
    TimePicker2Start: TDateTimePicker;
    TimePicker3Start: TDateTimePicker;
    TimePicker3End: TDateTimePicker;
    EditShiftEffic3: TEdit;
    EditShiftEffic4: TEdit;
    TimePicker4End: TDateTimePicker;
    TimePicker4Start: TDateTimePicker;
    DatePickerStart: TDateTimePicker;
    DatePickerEnd: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    BtnOk: TcxButton;
    BtnAbort: TcxButton;
    BitBtn1: TBitBtn;
    procedure EditShiftEffic1KeyPress(Sender: TObject; var Key: Char);
    procedure BtnOkClick(Sender: TObject);
    procedure BtnAbortClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    m_CopyCurrentList : TList;
    Is_Insert : boolean;
    { Private declarations }
  public
    constructor CreateCalShiftEffic(AOwner: TComponent; CurrentList : TList);
    constructor CreateCalShiftEfficUpdate(AOwner: TComponent; StarDate : TDate; EndDate : TDate;
    SH1_start , SH1_End : TTime; Effic1 : double;
    SH2_start , SH2_End : TTime; Effic2 : double;
    SH3_start , SH3_End : TTime; Effic3 : double;
    SH4_start , SH4_End : TTime; Effic4 : double);
    procedure GetUpdatedCalShift(var StarDate : TDate; var EndDate : TDate;
    var SH1_start , SH1_End : TTime; var Effic1 : double;
    var SH2_start , SH2_End : TTime; var Effic2 : double;
    var SH3_start , SH3_End : TTime; var Effic3 : double;
    var SH4_start , SH4_End : TTime; var Effic4 : double);
    { Public declarations }
  end;

{  TCalendarShiftEffic = record
    CalCod  : string;
    CalStartDate : TDateTime;
    CalEndDate   : TDateTime;
    SH1_start    : TTime;
    SH1_End      : TTime;
    SH1_EFFIC    : double;
    SH2_start    : TTime;
    SH2_End      : TTime;
    SH2_EFFIC    : double;
    SH3_start    : TTime;
    SH3_End      : TTime;
    SH3_EFFIC    : double;
    SH4_start    : TTime;
    SH4_End      : TTime;
    SH4_EFFIC    : double;
  end;
  PTCalendarShiftEffic =  ^TCalendarShiftEffic;  }

implementation

{$R *.dfm}

uses gnugettext, UGshiftCal;

{ TCalShiftEffic }

procedure TCalShiftEffic.BitBtn1Click(Sender: TObject);
var
  I : Integer;
begin
  ModalResult := mrOk;
  if Is_insert = True then
  begin
    for I := 0 to m_CopyCurrentList.Count - 1 do
    begin
      if PTShiftEffic(m_CopyCurrentList[I]).StartDate = Trunc(DatePickerStart.Date) then
      begin
        Showmessage(_('Start date already exists'));
        ModalResult := mrNone;
        exit;
      end;

      if ((PTShiftEffic(m_CopyCurrentList[I]).StartDate <= Trunc(DatePickerStart.Date)) and
         (Trunc(DatePickerStart.Date) <= PTShiftEffic(m_CopyCurrentList[I]).EndDate)) then

      begin
        Showmessage(_('Dates for shift are already selected '));
        ModalResult := mrNone;
        exit;
      end;

      if ((PTShiftEffic(m_CopyCurrentList[I]).StartDate <= Trunc(DatePickerStart.Date)) and
         (Trunc(DatePickerEnd.Date) <= PTShiftEffic(m_CopyCurrentList[I]).EndDate)) then
      begin
        Showmessage(_('Dates for shift are already selected '));
        ModalResult := mrNone;
        exit;
      end;

      if ((PTShiftEffic(m_CopyCurrentList[I]).StartDate >= Trunc(DatePickerStart.Date)) and
         (Trunc(DatePickerEnd.Date) >= PTShiftEffic(m_CopyCurrentList[I]).EndDate)) then
      begin
        Showmessage(_('Dates for shift are already selected '));
        ModalResult := mrNone;
        exit;
      end;

    end;
  end;

  if trunc(DatePickerStart.date) > trunc(DatePickerEnd.Date) then
  begin
    Showmessage(_('Start date must be lower then end date'));
    ModalResult := mrNone;
    exit
  end;

  //if (TimePicker1Start.Time > TimePicker1End.Time) then
  if  (TimePicker1End.Time <> 37886) and (TimePicker1Start.Time > TimePicker1End.Time) then
  begin
    Showmessage(_('Start Time shift must be lower then end time shift'));
    ModalResult := mrNone;
    exit
  end;

  if (TimePicker1Start.Time <> 37886) and (TimePicker1Start.Time >= TimePicker2Start.Time) and
     (TimePicker1Start.Time <= TimePicker2End.Time) then
  begin
    Showmessage(_('Start Time shift already exists'));
    ModalResult := mrNone;
    exit
  end;

  if (TimePicker1End.Time >= TimePicker2Start.Time) and
     (TimePicker1End.Time <= TimePicker2End.Time) then
  begin
    Showmessage(_('Start Time shift already exists'));
    ModalResult := mrNone;
    exit
  end;

  if  (TimePicker1Start.Time <> 37886) and (TimePicker1Start.Time >= TimePicker3Start.Time) and
     (TimePicker1Start.Time <= TimePicker3End.Time) then
  begin
    Showmessage(_('Start Time shift already exists'));
    ModalResult := mrNone;
    exit
  end;

  if (TimePicker1End.Time >= TimePicker3Start.Time) and
     (TimePicker1End.Time <= TimePicker3End.Time) then
  begin
    Showmessage(_('Start Time shift already exists'));
    ModalResult := mrNone;
    exit
  end;

  if  (TimePicker1Start.Time <> 37886) and (TimePicker1Start.Time >= TimePicker4Start.Time) and
     (TimePicker1Start.Time <= TimePicker4End.Time) then
  begin
    Showmessage(_('Start Time shift already exists'));
    ModalResult := mrNone;
    exit
  end;

  if (TimePicker1End.Time >= TimePicker4Start.Time) and
     (TimePicker1End.Time <= TimePicker4End.Time) then
  begin
    Showmessage(_('Start Time shift already exists'));
    ModalResult := mrNone;
    exit
  end;

  if (TimePicker2Start.Time <> 37886) then
  begin

    if (TimePicker2Start.Time >= TimePicker1Start.Time) and
       (TimePicker2Start.Time <= TimePicker1End.Time) then
    begin
      Showmessage(_('Start Time shift already exists'));
      ModalResult := mrNone;
      exit
    end;

    if (TimePicker2End.Time >= TimePicker1Start.Time) and
       (TimePicker2End.Time <= TimePicker1End.Time) then
    begin
      Showmessage(_('Start Time shift already exists'));
      ModalResult := mrNone;
      exit
    end;

    if (TimePicker2Start.Time >= TimePicker3Start.Time) and
       (TimePicker2Start.Time <= TimePicker3End.Time) then
    begin
    //  Showmessage(_('Start Time shift already exists'));
    //  ModalResult := mrNone;
    //  exit
    end;

   { if (TimePicker2End.Time >= TimePicker3Start.Time) and
       (TimePicker2End.Time <= TimePicker3End.Time) then
    begin
      Showmessage(_('Start Time shift already exists'));
      ModalResult := mrNone;
      exit
    end;

    if (TimePicker2Start.Time >= TimePicker4Start.Time) and
       (TimePicker2Start.Time <= TimePicker4End.Time) then
    begin
      Showmessage(_('Start Time shift already exists'));
      ModalResult := mrNone;
      exit
    end;

    if (TimePicker2End.Time >= TimePicker4Start.Time) and
       (TimePicker2End.Time <= TimePicker4End.Time) then
    begin
      Showmessage(_('Start Time shift already exists'));
      ModalResult := mrNone;
      exit
    end;   }

  end;

  if (TimePicker3Start.Time <> 37886) then
  begin

    if (TimePicker3Start.Time >= TimePicker1Start.Time) and
       (TimePicker3Start.Time <= TimePicker1End.Time) then
    begin
      Showmessage(_('Start Time shift already exists'));
      ModalResult := mrNone;
      exit
    end;

    if (TimePicker3End.Time >= TimePicker1Start.Time) and
       (TimePicker3End.Time <= TimePicker1End.Time) then
    begin
      Showmessage(_('Start Time shift already exists'));
      ModalResult := mrNone;
      exit
    end;

    if (TimePicker3Start.Time >= TimePicker2Start.Time) and
       (TimePicker3Start.Time <= TimePicker2End.Time) then
    begin
    //  Showmessage(_('Start Time shift already exists'));
     // ModalResult := mrNone;
     // exit
    end;

    if (TimePicker3End.Time >= TimePicker2Start.Time) and
       (TimePicker3End.Time <= TimePicker2End.Time) then
    begin
     // Showmessage(_('Start Time shift already exists'));
     // ModalResult := mrNone;
     // exit
    end;

    if (TimePicker3Start.Time >= TimePicker4Start.Time) and
       (TimePicker3Start.Time <= TimePicker4End.Time) then
    begin
     // Showmessage(_('Start Time shift already exists'));
     // ModalResult := mrNone;
     // exit
    end;

    if (TimePicker3End.Time >= TimePicker4Start.Time) and
       (TimePicker3End.Time <= TimePicker4End.Time) then
    begin
     // Showmessage(_('Start Time shift already exists'));
     // ModalResult := mrNone;
     // exit
    end;

  end;

  if (TimePicker4Start.Time <> 37886) then
  begin

    if (TimePicker4Start.Time >= TimePicker1Start.Time) and
       (TimePicker4Start.Time <= TimePicker1End.Time) then
    begin
      Showmessage(_('Start Time shift already exists'));
      ModalResult := mrNone;
      exit
    end;

    if (TimePicker4End.Time >= TimePicker1Start.Time) and
       (TimePicker4End.Time <= TimePicker1End.Time) then
    begin
      Showmessage(_('Start Time shift already exists'));
      ModalResult := mrNone;
      exit
    end;

    if (TimePicker4Start.Time >= TimePicker2Start.Time) and
       (TimePicker4Start.Time <= TimePicker2End.Time) then
    begin
    //  Showmessage(_('Start Time shift already exists'));
    //  ModalResult := mrNone;
    //  exit
    end;

    if (TimePicker4End.Time >= TimePicker2Start.Time) and
       (TimePicker4End.Time <= TimePicker2End.Time) then
    begin
     // Showmessage(_('Start Time shift already exists'));
     // ModalResult := mrNone;
     // exit
    end;

    if (TimePicker4Start.Time >= TimePicker3Start.Time) and
       (TimePicker4Start.Time <= TimePicker3End.Time) then
    begin
      //Showmessage(_('Start Time shift already exists'));
     // ModalResult := mrNone;
     // exit
    end;

    if (TimePicker4End.Time >= TimePicker3Start.Time) and
       (TimePicker4End.Time <= TimePicker3End.Time) then
    begin
     // Showmessage(_('Start Time shift already exists'));
     // ModalResult := mrNone;
     // exit
    end;
  end;

//  if (TimePicker2Start.Time <> 37886) and (TimePicker2Start.Time >= TimePicker2End.Time) then
  if (TimePicker2Start.Time <> 37886) and (TimePicker2End.Time <> 37886) and (TimePicker2Start.Time >= TimePicker2End.Time) then
  begin
   // Showmessage(_('Start Time shift must be lower then end time shift'));
   // ModalResult := mrNone;
   // exit
  end;

//  if (TimePicker3Start.Time <> 37886) and (TimePicker3Start.Time >= TimePicker3End.Time) then
  if (TimePicker3Start.Time <> 37886) and (TimePicker3End.Time <> 37886) and (TimePicker3Start.Time >= TimePicker3End.Time) then
  begin
  //  Showmessage(_('Start Time shift must be lower then end time shift'));
  //  ModalResult := mrNone;
  //  exit
  end;

  //if (TimePicker4Start.Time <> 37886) and (TimePicker4Start.Time >= TimePicker4End.Time) then
  if (TimePicker4Start.Time <> 37886) and (TimePicker4End.Time <> 37886) and (TimePicker4Start.Time >= TimePicker4End.Time) then
  begin
   // Showmessage(_('Start Time shift must be lower then end time shift'));
   // ModalResult := mrNone;
   // exit
  end;

  if (TimePicker1Start.Time = 37886) and (TimePicker1End.Time = 37886) and (StrToFloat(EditShiftEffic1.Text) > 0) then
  begin
   // Showmessage(_('End Time shift must be higher then start time shift'));
  //  ModalResult := mrNone;
  //  exit
  end;

  if (TimePicker2Start.Time = 37886) and (TimePicker2End.Time = 37886) and (StrToFloat(EditShiftEffic2.Text) > 0) then
  begin
   // Showmessage(_('End Time shift must be higher then start time shift'));
   // ModalResult := mrNone;
   // exit
  end;

  if (TimePicker3Start.Time = 37886) and (TimePicker3End.Time = 37886) and (StrToFloat(EditShiftEffic3.Text) > 0) then
  begin
   // Showmessage(_('End Time shift must be higher then start time shift'));
   // ModalResult := mrNone;
   // exit
  end;

  if (TimePicker4Start.Time = 37886) and (TimePicker4End.Time = 37886) and (StrToFloat(EditShiftEffic4.Text) > 0) then
  begin
   // Showmessage(_('End Time shift must be higher then start time shift'));
  //  ModalResult := mrNone;
  //  exit
  end;

end;

procedure TCalShiftEffic.BtnAbortClick(Sender: TObject);
begin
  ModalResult := mrAbort;
  close
end;

procedure TCalShiftEffic.BtnOkClick(Sender: TObject);
begin
  BitBtn1.Click;
end;

//----------------------------------------------------------------------------//

constructor TCalShiftEffic.CreateCalShiftEffic(AOwner: TComponent; CurrentList : TList);
begin
  inherited Create(AOwner);
  DatePickerStart.Date  := now;
  DatePickerEnd.Date    := now + 10 * 365;
  TimePicker1Start.Time := 0;
  TimePicker1End.Time   := 0;
  TimePicker2Start.Time := 0;
  TimePicker2End.Time   := 0;
  TimePicker3Start.Time := 0;
  TimePicker3End.Time   := 0;
  TimePicker4Start.Time := 0;
  TimePicker4End.Time  :=  0;
  Is_insert := true;
  m_CopyCurrentList := CurrentList;

  ReShape(self);
end;

//----------------------------------------------------------------------------//

constructor TCalShiftEffic.CreateCalShiftEfficUpdate(AOwner: TComponent; StarDate,
  EndDate: TDate; SH1_start, SH1_End: TTime; Effic1: double; SH2_start,
  SH2_End: TTime; Effic2: double; SH3_start, SH3_End: TTime; Effic3: double;
  SH4_start, SH4_End: TTime; Effic4: double);
begin
  inherited Create(AOwner);
  DatePickerStart.Date  := StarDate;
  DatePickerEnd.Date    := EndDate;
  TimePicker1Start.Time := SH1_start;
  TimePicker1End.Time   := SH1_End;
  TimePicker2Start.Time := SH2_start;
  TimePicker2End.Time   := SH2_End;
  TimePicker3Start.Time := SH3_start;
  TimePicker3End.Time   := SH3_End;
  TimePicker4Start.Time := SH4_start;
  TimePicker4End.Time  :=  SH4_end;
  EditShiftEffic1.Text := FloatToStr(Effic1);
  EditShiftEffic2.Text := FloatToStr(Effic2);
  EditShiftEffic3.Text := FloatToStr(Effic3);
  EditShiftEffic4.Text := FloatToStr(Effic4);
  DatePickerStart.Enabled := false;
  DatePickerEnd.Enabled   := false;
end;

//----------------------------------------------------------------------------//

procedure TCalShiftEffic.EditShiftEffic1KeyPress(Sender: TObject; var Key: Char);
begin
  if not ((CharInSet(Key, ['0'..'9'])) or (key = chr(vk_Back)) or (Key = chr(24))) then
      abort;
end;

//----------------------------------------------------------------------------//

procedure TCalShiftEffic.GetUpdatedCalShift(var StarDate, EndDate: TDate;
  var SH1_start, SH1_End: TTime; var Effic1: double; var SH2_start,
  SH2_End: TTime; var Effic2: double; var SH3_start, SH3_End: TTime;
  var Effic3: double; var SH4_start, SH4_End: TTime; var Effic4: double);
var
  Year, Month, Day: Word;
  Hour, Min, Sec, MSec: Word;
begin
  DecodeDate(DatePickerStart.Date, Year, Month, Day);
  StarDate := EncodeDate(Year, Month, Day);
  DecodeDate(DatePickerEnd.Date, Year, Month, Day);
  EndDate := EncodeDate(Year, Month, Day);
  DecodeTime(TimePicker1Start.Time, Hour, Min, Sec, MSec);
  SH1_start := EncodeTime(Hour, Min, Sec, MSec);
  DecodeTime(TimePicker1End.Time, Hour, Min, Sec, MSec);
  SH1_End := EncodeTime(Hour, Min, Sec, MSec);
  Effic1  := StrToFloat(EditShiftEffic1.Text);
  DecodeTime(TimePicker2Start.Time, Hour, Min, Sec, MSec);
  SH2_start := EncodeTime(Hour, Min, Sec, MSec);
  DecodeTime(TimePicker2End.Time, Hour, Min, Sec, MSec);
  SH2_End := EncodeTime(Hour, Min, Sec, MSec);
  Effic2  := StrToFloat(EditShiftEffic2.Text);
  DecodeTime(TimePicker3Start.Time, Hour, Min, Sec, MSec);
  SH3_start := EncodeTime(Hour, Min, Sec, MSec);
  DecodeTime(TimePicker3End.Time, Hour, Min, Sec, MSec);
  SH3_End := EncodeTime(Hour, Min, Sec, MSec);
  Effic3  := StrToFloat(EditShiftEffic3.Text);
  DecodeTime(TimePicker4Start.Time, Hour, Min, Sec, MSec);
  SH4_start := EncodeTime(Hour, Min, Sec, MSec);
  DecodeTime(TimePicker4End.Time, Hour, Min, Sec, MSec);
  SH4_End := EncodeTime(Hour, Min, Sec, MSec);
  Effic4  := StrToFloat(EditShiftEffic4.Text);
end;

//----------------------------------------------------------------------------//

end.
