unit FMCapResDynamicCreate;

interface

uses
  cxButtons, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls,gnugettext,
  Vcl.ExtCtrls, UReSHape;

type
  TCapResDynamicCreate = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    DatePickerStart: TDateTimePicker;
    TimePicker1Start: TDateTimePicker;
    Lblfromtime: TLabel;
    DateTimePickerToDatelimit: TDateTimePicker;
    Label2: TLabel;
    BtnOk: TcxButton;
    BtnAbort: TcxButton;
    procedure BtnOkClick(Sender: TObject);
    procedure BtnAbortClick(Sender: TObject);

  private
    m_IsInsert    : boolean;
    m_IndexToSkip : Integer;
    m_CapResList : TList;
    { Private declarations }
  public
    constructor CreateCapResDynamic(AOwner: TComponent; CapResList : TList);
    constructor CreateCapResDynamicUpdate(AOwner: TComponent; CapResList : TList; IndexToSkip : integer);
    procedure   GetUpdatedCapResData(var DateBegin : TDate; var FromTime : TTime; var ToDatelimit : TDate);

    { Public declarations }
  end;

var
  CapResDynamicCreate: TCapResDynamicCreate;

implementation

{$R *.dfm}

uses FMCapResDynamic;

{ TCapResDynamicCreate }

//----------------------------------------------------------------------------------------------

procedure TCapResDynamicCreate.BtnAbortClick(Sender: TObject);
begin
  Close;
end;

procedure TCapResDynamicCreate.BtnOkClick(Sender: TObject);
var
  I : Integer;
  RowDate : PTRecCapResDynamic;
  Year, Month, Day: Word;
  Hour, Min, Sec, MSec: Word;
  DateBegin: TDate;
  FromTime: TTime;
  ToDatelimit: TDate;
  StartDateTime, StartDateTimeSelected : TDateTime;
begin
  DecodeDate(DatePickerStart.Date, Year, Month, Day);
  DateBegin := EncodeDate(Year, Month, Day);
  DecodeDate(DateTimePickerToDatelimit.Date, Year, Month, Day);
  ToDatelimit := EncodeDate(Year, Month, Day);
  DecodeTime(TimePicker1Start.Time, Hour, Min, Sec, MSec);
  FromTime := EncodeTime(Hour, Min, Sec, 0);
  StartDateTimeSelected := DateBegin + FromTime;

  ModalResult := mrOk;

  for I := 0 to m_CapResList.Count - 1 do
  begin
    if not m_IsInsert and (m_IndexToSkip = I) then continue;
    if m_IndexToSkip > -1 then
      RowDate := PTRecCapResDynamic(m_CapResList[m_IndexToSkip])
    else
      RowDate := PTRecCapResDynamic(m_CapResList[I]);
    FromTime := RowDate.FromTime/24/60;
    StartDateTime := RowDate.DateBegin + FromTime;
    if ((StartDateTimeSelected > StartDateTime) and (StartDateTimeSelected < RowDate.ToDateTimelimit)) or
       (StartDateTimeSelected < RowDate.ToDateTimelimit) and (ToDatelimit > RowDate.ToDateTimelimit) then
    begin
      Showmessage(_('Wrong date have been selected'));
      ModalResult := mrNone;
      break;
    end;
  end;
end;

//----------------------------------------------------------------------------------------------

constructor TCapResDynamicCreate.CreateCapResDynamic(AOwner: TComponent; CapResList : TList);
begin
  inherited Create(AOwner);
  m_IndexToSkip := -1;
  m_IsInsert := true;
  DatePickerStart.Date  := now;
  TimePicker1Start.Time := time;
  DateTimePickerToDatelimit.Date := now + 360*5;
  m_CapResList := CapResList;
  ReShape(self);
end;

//----------------------------------------------------------------------------------------------

constructor TCapResDynamicCreate.CreateCapResDynamicUpdate(AOwner: TComponent; CapResList : TList; IndexToSkip : integer);
var
  RowDate : PTRecCapResDynamic;
begin
  inherited Create(AOwner);
  m_IndexToSkip := IndexToSkip;
  m_CapResList := CapResList;
  m_IsInsert := false;
  RowDate := PTRecCapResDynamic(CapResList[IndexToSkip]);
  DatePickerStart.Date  := Trunc(RowDate.DateBegin);
  TimePicker1Start.Time := RowDate.FromTime/24/60;
  DateTimePickerToDatelimit.Date := RowDate.ToDateTimelimit;

end;

//----------------------------------------------------------------------------------------------

procedure TCapResDynamicCreate.GetUpdatedCapResData(var DateBegin: TDate;
  var FromTime: TTime; var ToDatelimit: TDate);
var
  Year, Month, Day: Word;
  Hour, Min, Sec, MSec: Word;
begin
  DecodeDate(DatePickerStart.Date, Year, Month, Day);
  DateBegin := EncodeDate(Year, Month, Day);
  DecodeDate(DateTimePickerToDatelimit.Date, Year, Month, Day);
  ToDatelimit := EncodeDate(Year, Month, Day);
  DecodeTime(TimePicker1Start.Time, Hour, Min, Sec, MSec);
  FromTime := EncodeTime(Hour, Min, 0, 0);
end;

//----------------------------------------------------------------------------------------------

end.
