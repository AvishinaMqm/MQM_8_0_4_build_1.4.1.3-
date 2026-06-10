unit FMSplitBySelectedDateTime;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, UReShape;

type
  TSplitBySelectedDateTime = class(TForm)
    CBxRejoinStepsJob: TCheckBox;
    DateTimePickerDate: TDateTimePicker;
    DateTimePickerTime: TDateTimePicker;
    CBRound: TComboBox;
    LabelRoundDec: TLabel;
    RadioGroupRoundingCriteria: TRadioGroup;
    BitBtn1: TcxButton;
    BtnAbo: TcxButton;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnAboClick(Sender: TObject);
  private
    m_ptr : pointer;
    Procedure SetGlobValues;
    { Private declarations }
  public
    constructor CreateSplitBySelectedDateTime(AOwner: TComponent; Date : TDate);
    { Public declarations }
  end;

//var
//  SplitBySelectedDateTime: TSplitBySelectedDateTime;

implementation

{$R *.dfm}

Uses FMBin, UMBinTbs, UMbinGrid, UMBinPanel, UMSchedContFunc, UMSchedCont, gnugettext,
     UMObjCont, UMSchedList, FMJobHandle, UMBinFunc, Umglobal;

{ TSplitBySelectedDateTime }

//----------------------------------------------------------------------------//

procedure TSplitBySelectedDateTime.BitBtn1Click(Sender: TObject);
var
  I ,NumberOfRowsInBin :    integer;
  ActTab: TBinTabSheet;
  ActBinGrid : TBinDrawGrid;
  id, BinId : TSchedId;
  PlanInfoId , PlanInfoBinId : TSQPlanInfo;
  TimingInfoNewIdToBin, TimingInfoBinId : TSQtimingInfo;
  NewCreatedId : TSchedId;
  List : TList;
  NumDec : Integer;
  RoundTo : RoundToType;
  ProgInfo : TSQProgInfo;
  TempDateTime : TDateTime;
begin
  NumDec := 0;
  RoundTo := Non;
  if RadioGroupRoundingCriteria.ItemIndex = 0 then
    RoundTo := Up
  else if RadioGroupRoundingCriteria.ItemIndex = 1 then
    RoundTo := Down;

  if CBRound.ItemIndex = 1 then
    NumDec := 1
  else if CBRound.ItemIndex = 2 then
    NumDec := 2;

  List := TList.Create;
  ActTab := FBin.GetActiveView;
  ActbinGrid := ActTab.GetBinGrid;
  NumberOfRowsInBin := TBinPanel(ActbinGrid.Parent).m_ObjList.GetLinkCount;
  for NumberOfRowsInBin := 0 to NumberOfRowsInBin - 1 do
  begin
    id := TSchedId(TBinPanel(ActbinGrid.Parent).m_ObjList.GetLink(NumberOfRowsInBin));
    p_sc.GetPlanInfo(id, PlanInfoId);
    if not PlanInfoId.isOnPlan then continue;

    TempDateTime := trunc(DateTimePickerDate.Date) + frac(DateTimePickerTime.Time);
    if (PlanInfoId.startDate < TempDateTime) and (PlanInfoId.endDate > TempDateTime) then

    begin
      NewCreatedId := -1;
      if (p_sc.IsProgressed(id) = prg_General) then
      begin
        if not SplitFromDatePoint(id, trunc(DateTimePickerDate.Date) + frac(DateTimePickerTime.Time) , true, true, NewCreatedId, RoundTo, NumDec) then
        begin
          p_sc.GetProgInfo(id, ProgInfo);
          if ((trunc(DateTimePickerDate.Date) + frac(DateTimePickerTime.Time)) < ProgInfo.PrgCurDt) then
            SplitFromDatePoint(id, ProgInfo.PrgCurDt , true, false, NewCreatedId, RoundTo, NumDec)
          else
            continue;
        end;
      end;
      if NewCreatedId = -1 then
        SplitFromDatePoint(id, trunc(DateTimePickerDate.Date) + frac(DateTimePickerTime.Time) , true, false, NewCreatedId, RoundTo, NumDec);
      RefreshAfterMove(m_ptr);
      p_sc.GetTimingInfo(NewCreatedId, TimingInfoNewIdToBin);
      if CBxRejoinStepsJob.Checked then
      begin
        for I := 0 to TBinPanel(ActbinGrid.Parent).m_ObjList.GetLinkCount - 1 do
        begin
          BinId := TSchedId(TBinPanel(ActbinGrid.Parent).m_ObjList.GetLink(I));
          if (NewCreatedId = BinId) then continue;
          p_sc.GetPlanInfo(BinId, PlanInfoBinId);
          if PlanInfoBinId.isOnPlan then continue;
          p_sc.GetTimingInfo(BinId, TimingInfoBinId);
          if (TimingInfoNewIdToBin.prodReq = TimingInfoBinId.prodReq) and
             (TimingInfoNewIdToBin.step = TimingInfoBinId.step) then
          begin
            List.Add(Pointer(NewCreatedId));
            p_opStack.JoinJobs(BinId, List);
            List.Clear;
            break;
          end;
        end;
      end;
    end;
  end;
  //
 // if CBxRejoinStepsJob.Checked then
 //   p_opStack.Clear;
  RefreshAfterMove(m_ptr);
  SetGlobValues;
  close;
//  GlobSaveIniValues

end;

//----------------------------------------------------------------------------//

procedure TSplitBySelectedDateTime.BtnAboClick(Sender: TObject);
begin
  Close;
end;

constructor TSplitBySelectedDateTime.CreateSplitBySelectedDateTime(
  AOwner: TComponent; Date: TDate);
begin
  inherited Create(AOwner);
  m_ptr := AOwner;
  DateTimePickerDate.Date := Date;
end;

//----------------------------------------------------------------------------//

procedure TSplitBySelectedDateTime.FormCreate(Sender: TObject);
begin
  Caption := _('Split By Selected Date Time');
  LabelRoundDec.Caption := _('Number of decimals to round  ');
  RadioGroupRoundingCriteria.Caption := _('Rounding Criteria');
  CBxRejoinStepsJob.Caption := _('Re-Join step jobs moved back to bin ?');
  CBRound.ItemIndex := 0;
  if iniAppGlobals.SplitByDateTimeNumOfDec <> '' then
  begin
    if iniAppGlobals.SplitByDateTimeNumOfDec = '1' then
      CBRound.ItemIndex := 1
    else if iniAppGlobals.SplitByDateTimeNumOfDec = '2' then
      CBRound.ItemIndex := 2
  end;

  if iniAppGlobals.SplitByDateTimeRoundCrit <> '' then
  begin
    if iniAppGlobals.SplitByDateTimeRoundCrit = '0' then
      RadioGroupRoundingCriteria.ItemIndex := 0
    else if iniAppGlobals.SplitByDateTimeRoundCrit = '1' then
      RadioGroupRoundingCriteria.ItemIndex := 1
  end;

  if iniAppGlobals.SplitByDateTimeReJoinBinJob <> '' then
  begin
    if iniAppGlobals.SplitByDateTimeReJoinBinJob = '1' then
      CBxRejoinStepsJob.Checked := true
    else
     CBxRejoinStepsJob.Checked := false;
  end;

  ReShape(Self);
//  ReShape(BitBtn1);
//  ReShape(BtnAbo);
end;

//----------------------------------------------------------------------------//

procedure TSplitBySelectedDateTime.SetGlobValues;
begin
  if CBRound.ItemIndex = 0 then
    iniAppGlobals.SplitByDateTimeNumOfDec := '0'
  else if CBRound.ItemIndex = 1 then
    iniAppGlobals.SplitByDateTimeNumOfDec := '1'
  else if CBRound.ItemIndex = 2 then
    iniAppGlobals.SplitByDateTimeNumOfDec := '2';

  if RadioGroupRoundingCriteria.ItemIndex = 0 then
    iniAppGlobals.SplitByDateTimeRoundCrit := '0'
  else if RadioGroupRoundingCriteria.ItemIndex = 1 then
    iniAppGlobals.SplitByDateTimeRoundCrit := '1';

  if CBxRejoinStepsJob.Checked then
    iniAppGlobals.SplitByDateTimeReJoinBinJob := '1'
  else
    iniAppGlobals.SplitByDateTimeReJoinBinJob := '2';

end;

//----------------------------------------------------------------------------//

end.
