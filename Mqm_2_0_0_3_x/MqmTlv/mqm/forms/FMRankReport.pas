unit FMRankReport;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, UMRank, ExtCtrls, TeeProcs, TeEngine, Chart, Series, StdCtrls,
  UMSchedObjMover, Buttons, VclTee.TeeGDIPlus, UReShape;

type
  TFRankReport = class(TForm)
    ChartScore: TChart;
    Series1: TBarSeries;
    Series2: TBarSeries;
    Bevel2: TBevel;
    GBPosRank: TGroupBox;
    SGRank: TStringGrid;
    Series3: TBarSeries;
    Splitter1: TSplitter;
    BtnOk: TPanel;
    BtnAbo: TPanel;
    procedure SGRankDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure SGRankSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOkClick(Sender: TObject);
    procedure BtnAboClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    m_Rank : TRank;
    m_ObjMover: TMqmSchedObjMover;
    procedure DrawDataCell(cvas: TCanvas; var rect: TRect; ARow, ACol: integer; RowIsSelected: boolean);
    procedure DrawHeadCell(Sender: TObject; ACol: integer; var Width: integer; var Desc: string);
    procedure InitChart(Line: integer);
  public
    constructor CreateRankReport(AOwner: Tcomponent; Rank: TRank);
    destructor Destroy ; override;
  end;

var
  FRankReport: TFRankReport;

implementation

uses
  gnugettext,
  UMCommon,
  FMMainPlan,
  UMSchedCont,
  UMSchedContFunc,
  UMBinFunc,
  UMActArea,
  UMRes,
  UMObjCont,
  UMAutoSchedCfg,
  UGGlobal;

{$R *.DFM}

//----------------------------------------------------------------------------//

constructor TFRankReport.CreateRankReport(AOwner: Tcomponent; Rank: TRank);
var
  isGrp: boolean;
begin
  inherited Create(AOwner);
  m_Rank := Rank;

 // Height := 500;
 // Width := 750;

  OccMoveEnter(FMQMPlan, Pointer(m_Rank.p_ObjToSched));

  m_ObjMover := TMqmSchedObjMover.Create;
  m_ObjMover.SetObjToMove(m_Rank.p_ObjToSched);

  Caption := _('Automatic sequencing results') + ' - ' + p_sc.GetObjInfo(m_Rank.p_ObjToSched, isGrp);

//  SGRank.ColCount := 13;
  SGRank.ColCount := 12;
  SGRank.ColWidths[0] := 80;
  SGRank.ColWidths[1] := 80;
  SGRank.ColWidths[2] := 80;
  SGRank.ColWidths[3] := 80;
  SGRank.ColWidths[4] := 80;
  SGRank.ColWidths[5] := 80;
  SGRank.ColWidths[6] := 80;
  SGRank.ColWidths[7] := 80;
  SGRank.ColWidths[8] := 80;
  SGRank.ColWidths[9] := 80;
  SGRank.ColWidths[10] := 80;
  SGRank.ColWidths[11] := 80;

  if m_Rank.p_Rank.Count = 0 then
    SGRank.RowCount := 2
  else
    SGRank.RowCount := m_Rank.p_Rank.Count + 1;

  if m_Rank.p_Rank.Count = 1 then
    InitChart(0);

  FRankReport := self;
end;

//----------------------------------------------------------------------------//

destructor TFRankReport.Destroy;
begin
  inherited Destroy;
  FRankReport := nil;
end;

//----------------------------------------------------------------------------//

procedure TFRankReport.DrawHeadCell(Sender: TObject; ACol: integer; var Width: integer; var Desc: string);
begin
  case ACol of
    0 : Desc := _('Score');
    1 : Desc := _('Gap to target date');
    2 : Desc := _('Difference to best score');
    3 : Desc := _('Resource');
    4 : Desc := _('Start date/hour');
    5 : Desc := _('End date/hour');
    6 : Desc := _('Earliest date discrepancy');
    7 : Desc := _('Latest end discrepancy');
    8 : Desc := _('Setup change discrepancy');
    9 : Desc := _('Job to res. discrepancy');
    10 : Desc := _('Job to job discrepancy');
    11 : Desc := _('Job to cap. res. discrepancy');
  end;

{
  case ACol of
    0 : Desc := _('Score gap');
    1 : Desc := _('Destination object');
    2 : Desc := _('Start date/hour');
    3 : Desc := _('End date/hour');
    4 : Desc := _('Planned start date gap');
    5 : Desc := _('Planned end date gap');
    6 : Desc := _('Earliest start date gap');
    7 : Desc := _('Latest end date gap');
    8 : Desc := _('Delivery date gap');
    9 : Desc := _('Setup');
    10 : Desc := _('Job to res compat. case');
    11 : Desc := _('Job to job compat. case');
    12 : Desc := _('Job to cap. res. compat. case');
  end;
}
end;

//----------------------------------------------------------------------------//

procedure TFRankReport.DrawDataCell(cvas: TCanvas; var rect: TRect; ARow, ACol: integer; RowIsSelected: boolean);
var
  str: string;
  Ranking: PTRanking;
  DtInfo:  TSQDatesInfo;
begin

  if ARow = m_Rank.p_Rank.Count then
  begin
    Cvas.TextRect(rect, rect.left+2, rect.top+2, '------');
    exit
  end;

  if m_Rank.p_Rank.Count = 0 then
    exit;

  Ranking := PTRanking(m_Rank.p_Rank[ARow]);

  case ACol of
    0 : str := FloatToStr(Ranking.m_Score);
    1 : str := FormatDuration(Ranking.m_TgtGap*24*60, true);
    2 : begin
          if m_Rank.p_BestRanking.m_Score <> 0 then
            str := FloatToStr(Ranking.m_Score - m_Rank.p_BestRanking.m_Score)
          else
            if Ranking.m_Score = 0 then
              str := '0'
            else
              str := FloatToStr(Ranking.m_Score)
        end;
    3 : str := Ranking.m_Pos.m_ObjFather.p_Father.GetDescr;
    4 : str := DateTimeToStr(Ranking.m_Pos.m_StartDate);
    5 : str := DateTimeToStr(Ranking.m_Pos.m_EndDate);
    6 : begin
          p_sc.GetDatesInfo(m_Rank.p_ObjToSched, DtInfo);
          if (Ranking.m_Pos.m_StartDate >= DtInfo.LowStrDate) then
            str := '--'
          else
          begin
//            str := FormatDuration(Ranking.m_DiscrepDateScore*24*60, true);
              str := FormatDuration((DtInfo.LowStrDate - Ranking.m_Pos.m_StartDate)*60*24, true);
          end;
        end;
    7 : begin
          p_sc.GetDatesInfo(m_Rank.p_ObjToSched, DtInfo);
          if (Ranking.m_Pos.m_endDate <= DtInfo.HighEndDate) then
            str := '--'
          else
//            str := FormatDuration(Ranking.m_DiscrepDateScore*24*60, true);
            str := FormatDuration((Ranking.m_Pos.m_endDate - DtInfo.HighEndDate)*60*24, true);
        end;
    8 : str := FormatDuration(Ranking.m_DiscrepDeltaSetupNextObj * 60, true);
    9 : str := FloatToStr(Ranking.m_DiscrepToResCompScore);
    10 : str := FloatToStr(Ranking.m_DiscrepToJobCompScore);
    11 : str := FloatToStr(Ranking.m_DiscrepToCapResCompScore);


{
    0 : begin
          if m_Rank.p_BestRanking.m_Score <> 0 then
            str := FloatToStr((Trunc((100 - ((Ranking.m_Score*100)/m_Rank.p_BestRanking.m_Score))*100))/100)
                    + ' %'
          else
            if Ranking.m_Score = 0 then
              str := '0 %'
            else
              str := FloatToStr((Trunc((100 - ((Ranking.m_Score*100)/-1))*100))/100)
                      + ' %';
        end;
    1 : str := Ranking.m_Pos.m_ObjFather.p_Father.GetDescr;
    2 : str := DateTimeToStr(Ranking.m_Pos.m_StartDate);
    3 : str := DateTimeToStr(Ranking.m_Pos.m_EndDate);
    4 : begin
          p_sc.GetDatesInfo(m_Rank.p_ObjToSched, DtInfo);
          str := FormatDuration((Ranking.m_Pos.m_StartDate - DtInfo.PlannedStrDate)*24*60);
        end;
    5 : begin
          p_sc.GetDatesInfo(m_Rank.p_ObjToSched, DtInfo);
          str := FormatDuration((Ranking.m_Pos.m_endDate - DtInfo.PlannedEndDate)*24*60);
        end;
    6 : begin
          p_sc.GetDatesInfo(m_Rank.p_ObjToSched, DtInfo);
          str := FormatDuration((Ranking.m_Pos.m_StartDate - DtInfo.LowStrDate)*24*60);
        end;
    7 : begin
          p_sc.GetDatesInfo(m_Rank.p_ObjToSched, DtInfo);
          str := FormatDuration((Ranking.m_Pos.m_endDate - DtInfo.HighEndDate)*24*60);
        end;
    8 : begin
          p_sc.GetDatesInfo(m_Rank.p_ObjToSched, DtInfo);
          str := FormatDuration((Ranking.m_Pos.m_endDate - DtInfo.DeliveryDate)*24*60);
        end;
    9 : str := FloatToStr(Ranking.m_Pos.m_Setup);
    10 : str := IntToStr(Ranking.m_ToResCompVal);
    11 : str := IntToStr(Ranking.m_ToJobCompVal);
    12 : str := IntToStr(Ranking.m_ToCapResCompVal);
}
  end;

  Cvas.TextRect(rect, rect.left+2, rect.top+2, str);

end;

//----------------------------------------------------------------------------//

procedure TFRankReport.SGRankDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  Wdh : integer;
  RowIsSelected: boolean;
  StrDes : string;
begin
  if ARow = 0 then
  begin
    DrawHeadCell(TDrawGrid(sender), acol, Wdh, StrDes);
    SGRank.Canvas.TextRect(rect, rect.left+2, rect.top+2, StrDes);
  end else
  begin
    if ARow = SGRank.Row then
      RowIsSelected := true
    else
      RowIsSelected := false;
    try
      DrawDataCell(TDrawGrid(sender).Canvas, rect, arow-1, acol, RowIsSelected)
    except
    end;
  end

end;

//----------------------------------------------------------------------------//

procedure TFRankReport.InitChart(Line: integer);
var
  Ranking: PTRanking;
  TmpEndDate: TDateTime;
  duration, setup, overlap: double;
  ActArea: TMqmActArea;
(*  ObjsMoved, FinalObjsMoved, ObjsDelayed: boolean;
  ObjsMaterial, ObjsAddRes: boolean;*)
  OptsMover: SetOptsMover;
  DeltaSetupObjToMove: double;
  Res : TMqmVisibleRes;
begin
  Ranking := PTRanking(m_Rank.p_Rank[Line]);
  ChartScore.Series[0].Clear;
  ChartScore.Series[1].Clear;
  ChartScore.Series[2].Clear;

  ChartScore.Series[0].Add(Ranking.m_DiscrepDateScore, _('Date'), clYellow);
  ChartScore.Series[1].Add(Ranking.m_PenaltyDateScore, _('Date'), clBlue);
  ChartScore.Series[2].Add(Ranking.m_DateScore,        _('Date'), clRed);

  ChartScore.Series[0].Add(Ranking.m_DiscrepToResCompScore, _('Resource comp.'), clYellow);
  ChartScore.Series[1].Add(Ranking.m_PenaltyToResCompScore, _('Resource comp.'), clBlue);
  ChartScore.Series[2].Add(Ranking.m_ToResCompScore,        _('Resource comp.'), clRed);

  ChartScore.Series[0].Add(Ranking.m_DiscrepToJobCompScore, _('Job to Job comp.'), clYellow);
  ChartScore.Series[1].Add(Ranking.m_PenaltyToJobCompScore, _('Job to Job comp.'), clBlue);
  ChartScore.Series[2].Add(Ranking.m_ToJobCompScore,        _('Job to Job comp.'), clRed);

// fp
  ChartScore.Series[0].Add(Ranking.m_DiscrepDeltaSetupNextObj, _('Setup change'), clYellow);
  ChartScore.Series[1].Add(Ranking.m_PenaltyDeltaSetupNextObj, _('Setup change'), clBlue);
  ChartScore.Series[2].Add(Ranking.m_DeltaSetupNextObj,        _('Setup change'), clRed);

  ChartScore.Series[0].Add(Ranking.m_DiscrepToCapResCompScore, _('Cap. res to job comp.'), clYellow);
  ChartScore.Series[1].Add(Ranking.m_PenaltyToCapResCompScore, _('Cap. res to job comp.'), clBlue);
  ChartScore.Series[2].Add(Ranking.m_ToCapResCompScore,        _('Cap. res to job comp.'), clRed);

(*  if m_ObjMover.ChangeTo(TMqmActArea(Ranking.m_Pos.m_ObjFather),
                         Ranking.m_Pos.m_StartDate, false, Al_toDate, setup,
                         overlap, duration, '', TmpEndDate, ObjsMoved, FinalObjsMoved,
                         ObjsDelayed, ObjsMaterial, ObjsAddRes, nil, False) then*)

  ActArea := TMqmActArea(Ranking.m_Pos.m_ObjFather);

  Res := TMqmVisibleRes(ActArea.p_Father);

  if m_ObjMover.ChangeTo(TMqmActArea(Ranking.m_Pos.m_ObjFather),
                         Ranking.m_Pos.m_StartDate, false, CSchedIDnull, Al_toDate, setup,
                         overlap, duration, '', TmpEndDate, OptsMover,
                         nil, False, DeltaSetupObjToMove, false, Res.p_ResComp) = CSM_Yes then
    BtnOk.Enabled := true
  else
    BtnOk.Enabled := false;

  FMQMPlan.RefreshActiveTab;
  FMQMPlan.FocusOnPlan(m_rank.p_ObjToSched)
end;

//----------------------------------------------------------------------------//

procedure TFRankReport.SGRankSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  InitChart(ARow-1);
end;

//----------------------------------------------------------------------------//

procedure TFRankReport.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (ModalResult <> mrOk) then
  begin
    m_ObjMover.Abort
  end;

  OccMoveExit(FMQMPlan,true);

  m_ObjMover.Destroy;
  Action := caFree
end;

//----------------------------------------------------------------------------//

procedure TFRankReport.BtnOkClick(Sender: TObject);
begin
  ModalResult := mrOk;
 // close
end;

//----------------------------------------------------------------------------//

procedure TFRankReport.BtnAboClick(Sender: TObject);
begin
  ModalResult := mrAbort;
  close
end;

//----------------------------------------------------------------------------//

procedure TFRankReport.FormCreate(Sender: TObject);
begin
  TranslateComponent (self);
  ScaleFormSize(Self, Screen.PixelsPerInch);
  BtnAbo.Left := Width - BtnAbo.Width - BtnOk.Width - 20;
  BtnOk.Left := Width - BtnOk.Width - 15;

  ReShape(Self);
  ReShape(BtnOk);
  ReSHape(BtnAbo);
end;

end.
