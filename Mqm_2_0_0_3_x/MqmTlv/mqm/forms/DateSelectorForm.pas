unit dateSelectorForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Buttons;

type
  TDateSelectorFrm = class(TForm)
    Panel1: TPanel;
    selectDateMonthCalendar: TMonthCalendar;
    okButton: TBitBtn;
    cancelButton: TBitBtn;
    procedure okButtonClick(Sender: TObject);
    procedure cancelButtonClick(Sender: TObject);
  private
    { Private declarations }
    selectedDate: TDate;
  public
    function getSelectedDate(): TDate;
    procedure setSelectedDate(selectedDate: String);
    { Public declarations }
  end;

var
  DateSelectorFrm: TDateSelectorFrm;

implementation

{$R *.dfm}

procedure TDateSelectorFrm.cancelButtonClick(Sender: TObject);
begin
   ModalResult := mrCancel;
end;

procedure TDateSelectorFrm.okButtonClick(Sender: TObject);
begin
 //  selectedDate := DateToStr(selectDateMonthCalendar.Date);
  selectedDate := selectDateMonthCalendar.Date;
  ModalResult := mrOk;
end;

function TDateSelectorFrm.getSelectedDate(): TDate;
begin
  result := selectedDate;
end;

procedure TDateSelectorFrm.setSelectedDate(selectedDate: String);
begin
  try
    selectDateMonthCalendar.Date := StrToDate(selectedDate);
  except
    on e:Exception do
      selectDateMonthCalendar.Date := Date();
  end;
end;
end.
