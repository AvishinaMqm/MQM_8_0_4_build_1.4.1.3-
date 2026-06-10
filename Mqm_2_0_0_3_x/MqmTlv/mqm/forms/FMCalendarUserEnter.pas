unit FMCalendarUserEnter;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, Vcl.ExtCtrls, UReShape;

type

  TTypeUse = (PropComp);

  TCalendar = class(TForm)
    DateTimePicker1: TDateTimePicker;
    BtnAbort1: TBitBtn;
    BtnOk1: TBitBtn;
    BtnOk: TcxButton;
    BtnAbort: TcxButton;
    procedure FormCreate(Sender: TObject);
    procedure BtnAbort1Click(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
  private
    m_TypeUse : TTypeUse;
    m_Title   : string;
    { Private declarations }
  public
    constructor CreateCalendarUserEnter(AOwner : Tcomponent; TypeUse : TTypeUse; Title : string; IniDate : string);
    function GetDate : TDateTime;
    { Public declarations }
  end;



//var
//  Calendar: TCalendar;

implementation

{$R *.dfm}

{ TCalendar }

//----------------------------------------------------------------------------------------------

procedure TCalendar.BtnAbort1Click(Sender: TObject);
begin
  close;
end;

//----------------------------------------------------------------------------------------------

constructor TCalendar.CreateCalendarUserEnter(AOwner: Tcomponent; TypeUse : TTypeUse; Title : string; IniDate : string);
begin
  inherited create(AOwner);
  m_TypeUse := TypeUse;
  m_Title   := Title;
  try
    DateTimePicker1.Date := StrToDate(IniDate);
  except
    DateTimePicker1.Date := date;
  end;

  ReShape(Self);
//  ReShape(BtnAbort);
//  ReShape(BtnOk);
end;

//----------------------------------------------------------------------------------------------

procedure TCalendar.FormCreate(Sender: TObject);
begin
  if (m_TypeUse = PropComp) then
    caption := m_Title;
end;

//----------------------------------------------------------------------------------------------

function TCalendar.GetDate: TDateTime;
begin
  Result := DateTimePicker1.Date
end;

procedure TCalendar.BtnOkClick(Sender: TObject);
begin
   ModalResult := mrOk;
//   Close;
end;

//----------------------------------------------------------------------------------------------

end.
