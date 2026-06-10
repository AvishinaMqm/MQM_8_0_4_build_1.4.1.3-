unit FMStatisticsDetails;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, UMStatisticCalculation;

type
  TStatisticsDetails = class(TForm)
    ListBox1: TListBox;
    constructor CreateTCompCasePercent(AOwner: TComponent; var ArrayOfCompact : TPercentArrayCompact; NumberOfJobs : integer; IsResComp : boolean);
    constructor CreateTotalUomProduced(AOwner: TComponent; ListUmQty : TList);
    // Combined "jobs in delay" / "jobs delivering early" band breakdown. One column-pair (jobs, %)
    // per compared schedule. Bands/Denoms/Names are parallel arrays, one entry per schedule.
    // IsEarly = True drops the '<1' band and relabels for early delivery.
    constructor CreateDelayBands(AOwner: TComponent; const Bands : array of TDelayBandCounts;
                                 const Denoms : array of Integer; const Names : array of string;
                                 const PeriodTitle : string; IsEarly : Boolean = False);
  private
    procedure IniDate;
    { Private declarations }
  public
    { Public declarations }
  end;

//var
//  StatisticsDetails: TStatisticsDetails;

implementation

uses
  gnugettext;

{$R *.dfm}

{ TCompCasePercent }

//----------------------------------------------------------------------------//

constructor TStatisticsDetails.CreateTCompCasePercent(AOwner: TComponent; var ArrayOfCompact : TPercentArrayCompact; NumberOfJobs : integer; IsResComp : boolean);
var
  grd : TStringGrid;
  I, gridRow, nRows, cnt : Integer;

  function PctText(c, den : Integer) : string;
  begin
    if (den > 0) and (c > 0) then
      Result := FormatFloat('0.0', (c / den) * 100) + '%'
    else
      Result := '0%';
  end;

begin
  inherited Create(AOwner);
  if IsResComp then
    caption := _('Breakdown by case of compatibility - job to resource')
  else
    caption := _('Breakdown by case of compatibility - job to job');

  ListBox1.Visible := False; // the shared form uses a listbox; we show a grid instead

  nRows := 0;
  for I := Low(ArrayOfCompact) to High(ArrayOfCompact) do
    if ArrayOfCompact[I] > 0 then
      Inc(nRows);

  grd := TStringGrid.Create(Self);
  grd.Parent := Self;
  grd.Align  := alClient;
  grd.DefaultRowHeight := 22;
  grd.FixedCols := 1;
  grd.FixedRows := 1;
  grd.Options := grd.Options + [goColSizing] - [goRangeSelect];
  grd.ColCount := 3;
  grd.RowCount := 1 + nRows;
  if grd.RowCount < 2 then
    grd.RowCount := 2; // TStringGrid needs at least one non-fixed row

  grd.Cells[0, 0] := _('Case');
  grd.Cells[1, 0] := _('Jobs');
  grd.Cells[2, 0] := '%';

  gridRow := 1;
  for I := Low(ArrayOfCompact) to High(ArrayOfCompact) do
  begin
    if ArrayOfCompact[I] > 0 then
    begin
      cnt := ArrayOfCompact[I];
      grd.Cells[0, gridRow] := IntToStr(I);
      grd.Cells[1, gridRow] := IntToStr(cnt);
      grd.Cells[2, gridRow] := PctText(cnt, NumberOfJobs);
      Inc(gridRow);
    end;
  end;

  grd.ColWidths[0] := 70;
  grd.ColWidths[1] := 70;
  grd.ColWidths[2] := 70;

  ClientWidth  := 70 * 3 + 4;
  ClientHeight := grd.RowCount * grd.DefaultRowHeight + 6;
end;

//----------------------------------------------------------------------------//

constructor TStatisticsDetails.CreateTotalUomProduced(AOwner: TComponent;
  ListUmQty: TList);
var
  I : Integer;
  TotalUmProduced : PTTotalUmProduced;
begin
  inherited Create(AOwner);
  caption := (_('Quantity produced by unit of measure'));
  for I := 0 to ListUmQty.Count - 1 do
  begin
    TotalUmProduced := PTTotalUmProduced(ListUmQty[I]);
    // number with its unit of measure attached, e.g. "6000m", "4000kg"
    ListBox1.Items.Add(FloatToStr(TotalUmProduced.totalQty) + TotalUmProduced.UM);
  end;
end;

//----------------------------------------------------------------------------//

constructor TStatisticsDetails.CreateDelayBands(AOwner: TComponent; const Bands : array of TDelayBandCounts;
  const Denoms : array of Integer; const Names : array of string; const PeriodTitle : string; IsEarly : Boolean);
var
  grd : TStringGrid;
  s, k, col, totRow, schedCount, startBand, gridRow : Integer;
  denom, total : Integer;

  function PctText(cnt, den : Integer) : string;
  begin
    if (den > 0) and (cnt > 0) then
      Result := FormatFloat('0.0', (cnt / den) * 100) + '%'
    else
      Result := '0%';
  end;

begin
  inherited Create(AOwner);
  schedCount := Length(Bands);

  // The early breakdown drops the '<1' band (band 1, always 0 for early); delay shows all bands.
  if IsEarly then
    startBand := 2
  else
    startBand := 1;

  if IsEarly then
    caption := _('Jobs delivering early - breakdown of earlier jobs by days')
  else
    caption := _('Jobs delivering late - breakdown of late jobs by days');
  if PeriodTitle <> '' then
    caption := caption + ' - ' + PeriodTitle;

  ListBox1.Visible := False; // the shared form uses a listbox; we show a grid instead

  grd := TStringGrid.Create(Self);
  grd.Parent := Self;
  grd.Align  := alClient;
  grd.DefaultRowHeight := 22;
  grd.FixedCols := 1;
  grd.FixedRows := 1;
  grd.Options := grd.Options + [goColSizing] - [goRangeSelect];
  grd.ColCount := 1 + 2 * schedCount;
  grd.RowCount := 1 + (DELAY_BAND_COUNT - startBand + 1) + 1; // header + bands + total

  totRow := grd.RowCount - 1;

  // header
  grd.Cells[0, 0] := _('Days');
  for s := 0 to schedCount - 1 do
  begin
    col := 1 + 2 * s;
    grd.Cells[col, 0]     := Names[s];
    grd.Cells[col + 1, 0] := '%';
  end;

  // band rows
  gridRow := 1;
  for k := startBand to DELAY_BAND_COUNT do
  begin
    grd.Cells[0, gridRow] := DelayBandCaption(k);
    for s := 0 to schedCount - 1 do
    begin
      col := 1 + 2 * s;
      denom := Denoms[s];
      grd.Cells[col, gridRow]     := IntToStr(Bands[s][k]);
      grd.Cells[col + 1, gridRow] := PctText(Bands[s][k], denom);
    end;
    Inc(gridRow);
  end;

  // total row (= number of jobs in delay / delivering early)
  if IsEarly then
    grd.Cells[0, totRow] := _('Total early')
  else
    grd.Cells[0, totRow] := _('Total in delay');
  for s := 0 to schedCount - 1 do
  begin
    col := 1 + 2 * s;
    denom := Denoms[s];
    total := 0;
    for k := startBand to DELAY_BAND_COUNT do
      Inc(total, Bands[s][k]);
    grd.Cells[col, totRow]     := IntToStr(total);
    grd.Cells[col + 1, totRow] := PctText(total, denom);
  end;

  // column widths + form size
  grd.ColWidths[0] := 90;
  for col := 1 to grd.ColCount - 1 do
    grd.ColWidths[col] := 58;

  ClientWidth  := 90 + (grd.ColCount - 1) * 58 + 4;
  ClientHeight := grd.RowCount * grd.DefaultRowHeight + 6;
end;

//----------------------------------------------------------------------------//

procedure TStatisticsDetails.IniDate;
begin

end;

end.
