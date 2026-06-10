unit FMBalanceChange;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FMRequirements, ExtCtrls, StdCtrls, Buttons, ComCtrls, UMBalance, UReSHape;

type
  TFBalanceChange = class(TForm)
    Panel1: TPanel;
    DatePicker: TDateTimePicker;
    TimePicker: TDateTimePicker;
    StaticQuantity: TStaticText;
    StaticDetailsDesc: TStaticText;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    BtnOk: TcxButton;
    BtnAbort: TcxButton;
    procedure BtnOkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnAbortClick(Sender: TObject);
  private
    m_OrigArtBalance : Pointer;
    m_PTDetailRows   : Pointer;
    { Private declarations }
  public
    { Public declarations }
    constructor CreateBalanceChangeForm(AOwner: TComponent; DetailRows: PTDetailRows);
  end;

var
  FBalanceChange: TFBalanceChange;

implementation

uses gnugettext, UGglobal, DMsrvPc, UMTblDesc, UMCommon;

{$R *.dfm}

{ TFBalanceChange }


function formatForTwoDigits(value: String): String;
begin
  if Length(value) = 1 then
    Result := '0' + value
  else
    Result := value;
end;

//----------------------------------------------------------------------------//

procedure UpdateDatabase(ArtBalance : PTArtBalance; DetailRows : PTDetailRows);
var
  year: Word;
  month: Word;
  day: Word;
  hour: Word;
  minute: Word;
  second: Word;
  milisecond: Word;
  StrDate : string;
  QryUpdateBH : TMqmQuery;
  tbInfo : ^TTblInfo;
begin
  tbInfo := @tblInfo[tbl_balance_header];
  QryUpdateBH := CreateQuery(Main_DB);
  QryUpdateBH.Transaction := CreateTransaction(Main_DB);
  QryUpdateBH.Transaction.StartTransaction;

  DecodeDate(ArtBalance.DueDate, year, month, day);
  DecodeTime(ArtBalance.DueDate, hour, minute, second, milisecond);
 // StrDate := QuotedStr(formatForTwoDigits(IntToStr(month)) + '/' + formatForTwoDigits(IntToStr(Day)) + '/' + IntToStr(Year) + ' ' +
 //                       formatForTwoDigits(IntToStr(hour)) + ':' + formatForTwoDigits(IntToStr(minute)) + ':' +
 //                       formatForTwoDigits(IntToStr(second)));

  StrDate := ConvertDateFormatDb2Oracle(ArtBalance.DueDate,true,true);

  with QryUpdateBH do
  begin
    Sql.Add(' update ' + tbInfo.GetTableName + ' set ');
   // Sql.Add('update BALANCE_HEADER set ');
    Sql.Add(' "BH_DUE_DATE" =' + StrDate);
    Sql.Add(' Where');
    Sql.Add(' "BH_TYPE_PROD" =' + QuotedStr(DetailRows.ArtType));
    Sql.Add(' And');
    Sql.Add(' "BH_PRODUCT_CODE" =' + QuotedStr(DetailRows.ProductCode));
    Sql.Add(' And');
    Sql.Add(' "BH_NET_GROUP_CODE" =' + QuotedStr(DetailRows.NetGroupPtr.m_Code));
    Sql.Add(' And');
    Sql.Add(' "BH_QTY" =' + QuotedStr(FloatToStr(DetailRows.Quantity)));
    Sql.Add(' And');
    Sql.Add(' "BH_INFO_AREA" =' + QuotedStr(DetailRows.description));
    QryUpdateBH.ExecSQL;
  end;
  QryUpdateBH.Transaction.commit;
end;

//----------------------------------------------------------------------------//

procedure TFBalanceChange.BtnAbortClick(Sender: TObject);
begin
  Close;
end;

procedure TFBalanceChange.BtnOkClick(Sender: TObject);
var
  Year, Month, Day: Word;
  Hour, Min, Sec, MSec: Word;
  T : TTime;
  D : TDate;
begin
  DecodeDate(DatePicker.Date, Year, Month, Day);
  D := EncodeDate(Year, Month, Day);
  DecodeTime(TimePicker.Time, Hour, Min, Sec, MSec);
  T := EncodeTime(Hour, Min, Sec, MSec);
  PTArtBalance(m_OrigArtBalance).DueDate  := D + T;
  PTDetailRows(m_PTDetailRows).DateTime   := PTArtBalance(m_OrigArtBalance).DueDate;
  PTDetailRows(m_PTDetailRows).Date := DateTimeToStr(D+T);
  UpdateDatabase(m_OrigArtBalance, m_PTDetailRows);
  ModalResult := mrOk;
 // CLose;
end;

//----------------------------------------------------------------------------//

constructor TFBalanceChange.CreateBalanceChangeForm(AOwner: TComponent;  DetailRows: PTDetailRows);
var
  Year, Month, Day: Word;
  Hour, Min, Sec, MSec: Word;
begin
  inherited create(Aowner);
  TranslateComponent(self);
  SetComponent(StaticDetailsDesc, comp_Descr, false);
  SetComponent(StaticQuantity, comp_Descr, false);
  StaticQuantity.Caption := FloatToStr(DetailRows.Quantity);
  StaticDetailsDesc.Caption := DetailRows.description;
  m_OrigArtBalance := DetailRows.Artbalance;
  m_PTDetailRows   := DetailRows;
  DecodeDate(PTArtBalance(DetailRows.Artbalance).DueDate, Year, Month, Day);
  DatePicker.Date := EncodeDate(Year, Month, Day);
  DecodeTime(PTArtBalance(DetailRows.Artbalance).DueDate, Hour, Min, Sec, MSec);
  TimePicker.time := EncodeTime(Hour, Min, Sec, MSec);

  ReShape(Self);
  ReSHape(BtnOk);
  ReShape(BtnAbort);
end;

//----------------------------------------------------------------------------//

procedure TFBalanceChange.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

end.
