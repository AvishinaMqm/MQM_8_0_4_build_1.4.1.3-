unit FMEditCal;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, UGBaseCal, ComCtrls,UMRes, UGShiftCal, CheckLst, UReShape;

type
  TMEditCal = class(TForm)
    grbActual: TGroupBox;
    grbActual1: TGroupBox;
    lblFrom: TLabel;
    Label2: TLabel;
    stActual1From: TStaticText;
    stActual1To: TStaticText;
    grbActual2: TGroupBox;
    Label3: TLabel;
    Label5: TLabel;
    stActual2From: TStaticText;
    stActual2To: TStaticText;
    grbActual3: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    stActual3From: TStaticText;
    stActual3To: TStaticText;
    grbActual4: TGroupBox;
    Label8: TLabel;
    Label9: TLabel;
    stActual4From: TStaticText;
    stActual4To: TStaticText;
    grbNew: TGroupBox;
    grbNew1: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    grbNew2: TGroupBox;
    Label12: TLabel;
    Label13: TLabel;
    grbNew3: TGroupBox;
    Label14: TLabel;
    Label15: TLabel;
    grbNew4: TGroupBox;
    Label16: TLabel;
    Label17: TLabel;
    dtmNew1From: TDateTimePicker;
    dtmNew1To: TDateTimePicker;
    dtmNew2From: TDateTimePicker;
    dtmNew2To: TDateTimePicker;
    dtmNew3From: TDateTimePicker;
    dtmNew3To: TDateTimePicker;
    dtmNew4From: TDateTimePicker;
    dtmNew4To: TDateTimePicker;
    rgTypeWorkDay: TRadioGroup;
    grbCalInfo: TGroupBox;
    Label4: TLabel;
    dtmDateCalFrom: TDateTimePicker;
    Label18: TLabel;
    dtmDateCalTo: TDateTimePicker;
    Label1: TLabel;
    StCalCode: TStaticText;
    grbCalOpt: TGroupBox;
    clstBoxOptDays: TCheckListBox;
    Label19: TLabel;
    chbModEndCal: TCheckBox;
    rgOptNotWorkDay: TRadioGroup;
    BtnOk: TcxButton;
    BtnAbo: TcxButton;
    Label20: TLabel;
    StResCode: TStaticText;
    rgCalRes: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure rgTypeWorkDayClick(Sender: TObject);
    procedure dtmDateCalFromChange(Sender: TObject);
    procedure chbModEndCalClick(Sender: TObject);
    procedure dtmDateCalFromClick(Sender: TObject);
    procedure BtnAboClick(Sender: TObject);
  private
    m_Cal : TPGCALshift;
    m_CalListToUpdate : TList;
    m_CalListToUpdateForSubRes : TList;
    m_ShiftCalDay : PTPGCALElem;

    function UpdateAll : boolean;
    function CheckValidData : boolean;
//    function IsChangedSomething : boolean;
    procedure PrepData(NoChangeItmIdx: boolean);
    procedure PutAllMidnight;
    procedure PhaseCalComponent(dt : TDate);
    Function ModifyResCal(ModType: Integer) : TList;
  public
    MainRes : TMqmRes;
    constructor CreateEditCalFrm(AOwner: Tcomponent; Cal: TPGCALObj; CalListToUpdate : TList; Res : TMqmRes);
    destructor Destroy ; override;
  end;

var
  MEditCal: TMEditCal;

implementation

uses
  gnugettext, UGglobal, UMObjCont,  UMWkCtr, UMSchedContFunc,UMPlanTbs, FMMainplan;

{$R *.DFM}

const
  ONE_HOUR = 1 / 24;

// -------------------------------------------------------------------------- //

Function TMEditCal.ModifyResCal(ModType: Integer) : TList;
var
  I,J, SubResIndex : Integer;
  WC, TempWc:     TMqmWrkCtr;
  Rsc:    TMqmRes;
  VisRes: TMqmVisibleRes;
  AWC : TStringList;
  ActTab : TMqmPlanTabSheet;
begin
  Result := TList.Create;
  AWc := TStringList.Create;

  if ModType = 1 then //all Res from selected Calendar
  begin
    for i := 0 to p_pl.p_ResList.Count - 1 do
    begin
      Rsc := TMqmRes(p_pl.p_ResList[I]);

      if TMqmVisibleRes(MainRes.p_VisRes[0]).p_CalCod
      = TMqmVisibleRes(Rsc.p_VisRes[0]).p_CalCod then
        Result.add(TMqmVisibleRes(Rsc.p_VisRes[0]).GetCalendar);
    end;

  end else if ModType = 2 then //WORK CENTAR
  begin

    WC := TMqmWrkCtr(MainRes.p_WrkCtr);

    for i := 0 to wc.p_ResCount - 1 do
    begin
      Rsc := TMqmRes(Wc.p_Res[I]);

      if TMqmVisibleRes(MainRes.p_VisRes[0]).p_CalCod
      = TMqmVisibleRes(Rsc.p_VisRes[0]).p_CalCod then
        Result.add(TMqmVisibleRes(Rsc.p_VisRes[0]).GetCalendar);
    end;

  end else if ModType = 3 then //ALT WORK CENTAR
  begin
    WC := TMqmWrkCtr(MainRes.p_WrkCtr);
    AWC := wc.GetAltWcList;
    for i := 0 to AWC.Count -1 do
    begin
      TempWc := p_pl.FindWrkCtrByCode(AWC.Strings[I]);
      if TempWc = nil then continue;
      if TempWc.p_PlantCode = '' then continue;
     // if TempWc.m_resList = nil then continue;

      for j := 0 to TempWc.p_ResCount - 1 do
      begin
        Rsc := TMqmRes(TempWc.p_Res[j]);
        if TMqmVisibleRes(MainRes.p_VisRes[0]).p_CalCod
        = TMqmVisibleRes(Rsc.p_VisRes[0]).p_CalCod then
          Result.add(TMqmVisibleRes(Rsc.p_VisRes[0]).GetCalendar);
      end;
    end;
  end else if ModType = 4 then //All Res from Current Gant
  begin

    ActTab := FMQMPlan.GetActiveTab;

    for i := 0 to ActTab.p_ganttPanel.p_VisResList.Count - 1 do
    begin

      if TMqmVisibleRes(ActTab.p_ganttPanel.p_VisResList[I]).p_CalCod
      = TMqmVisibleRes(MainRes.p_VisRes[0]).p_CalCod then
        Result.add(TMqmVisibleRes(ActTab.p_ganttPanel.p_VisResList[I]).GetCalendar);
    end;
  end;

  awc.Free;

end;

constructor TMEditCal.CreateEditCalFrm(AOwner: Tcomponent; Cal: TPGCALObj; CalListToUpdate : TList; Res : TMqmRes);
begin
  inherited Create(AOwner);

  Height := 555;
 // Width := 834;

  m_Cal := TPGCALshift(Cal);
  m_CalListToUpdate := CalListToUpdate;
  StCalCode.Caption := m_Cal.GetKey;
  StResCode.Caption := m_Cal.GetResKey;
  MainRes := Res;
  if m_Cal.m_IsEfficiencyAndCalBothOnResLvl then
  begin
    StCalCode.Caption := m_Cal.GetCalName_ResEffBothLvl;
    rgCalRes.Visible := True;
  end
  else
  begin
    rgCalRes.Visible := False;
    Label20.Visible := false;
    StResCode.Visible := false
  end;

  dtmDateCalFrom.Date := now;
  dtmDateCalTo.Date := dtmDateCalFrom.Date;
  PhaseCalComponent(dtmDateCalFrom.Date);

  PrepData(true);

  SetComponent(StCalCode, comp_Descr, false);
  SetComponent(StResCode, comp_Descr, false);
  SetComponent(stActual1From, comp_Descr, false);
  SetComponent(stActual1To, comp_Descr, false);
  SetComponent(stActual2From, comp_Descr, false);
  SetComponent(stActual2To, comp_Descr, false);
  SetComponent(stActual3From, comp_Descr, false);
  SetComponent(stActual3To, comp_Descr, false);
  SetComponent(stActual4From, comp_Descr, false);
  SetComponent(stActual4To, comp_Descr, false);

end;

// -------------------------------------------------------------------------- //

destructor TMEditCal.Destroy;
begin
  MEditCal := nil;
  inherited Destroy;
end;

//----------------------------------------------------------------------------//

procedure TMEditCal.FormCreate(Sender: TObject);
begin
  TranslateComponent (self);

  ReShape(Self);
//  ReShape(btnOk);
//  ReShape(btnAbo);
end;

//----------------------------------------------------------------------------//

procedure TMEditCal.BtnOkClick(Sender: TObject);
begin
  ModalResult := mrNone;
{ Mihailo to be recheked
   //check if date from < then today
  if dtmDateCalFrom.Date < Date then
  begin
    MessageDlg(_('Date from cannot be lower than today!'), mtError, [mbOk], 0);
    exit;
  end; }

//sav  if IsChangedSomething then
//sav  begin
    if CheckValidData then
      if UpdateAll then
        ModalResult := mrOk
//sav  end else
//sav    ModalResult := mrOk
end;

//----------------------------------------------------------------------------//

function TMEditCal.UpdateAll : boolean;
var
  InfoForUpdate : TPGCALInfoForUpdate;
  i,y : integer;
  CalShift : TPGCALshift;
  Rsc : TMqmRes;
begin
  Result := true;

  with InfoForUpdate do
  begin

   // InfoForUpdate.DayDoNotMod := [dSunday, dMonday, dTuesday, dWednesday, dThursday, dFriday, dSaturday];
    Include(InfoForUpdate.DayDoNotMod, dSunday);
    Include(InfoForUpdate.DayDoNotMod, dMonday);
    Include(InfoForUpdate.DayDoNotMod, dTuesday);
    Include(InfoForUpdate.DayDoNotMod, dWednesday);
    Include(InfoForUpdate.DayDoNotMod, dThursday);
    Include(InfoForUpdate.DayDoNotMod, dFriday);
    Include(InfoForUpdate.DayDoNotMod, dSaturday);

    dtStart := dtmDateCalFrom.Date;
    dtEnd := dtmDateCalTo.Date;

    for i := 0 to clstBoxOptDays.Items.Count-1 do
      if clstBoxOptDays.Checked[i] then
      begin
        if i = 6 then
          Exclude(InfoForUpdate.DayDoNotMod, dSunday)
        else
          Exclude(InfoForUpdate.DayDoNotMod, TDayOfWeekEnum(i+1));
      end;

    if rgOptNotWorkDay.ItemIndex = 0 then
      UseNotWorkDay := false
    else
      UseNotWorkDay := true;

    TpOfShift := rgTypeWorkDay.ItemIndex;

    ModResCal := rgCalRes.ItemIndex;

    case rgTypeWorkDay.ItemIndex of
      0:
         for i := 1 to 4 do
         begin
           InfoForUpdate.InfoShift[i].start := 0;
           InfoForUpdate.InfoShift[i].dur := 0;
         end;
      1:
         begin
           InfoForUpdate.InfoShift[1].start := 0;
           InfoForUpdate.InfoShift[1].dur := 60 * 24;
           for i := 2 to 4 do
           begin
             InfoForUpdate.InfoShift[i].start := 0;
             InfoForUpdate.InfoShift[i].dur := 0;
           end;
         end;
      2:
         begin
           // if the end of Shift is midnight add one day to component
           if (Frac(dtmNew1From.Time) <> 0) and (Frac(dtmNew1To.Time) = 0) then dtmNew1To.Date := dtmNew1To.Date + 1;
           if (Frac(dtmNew2From.Time) <> 0) and (Frac(dtmNew2To.Time) = 0) then dtmNew2To.Date := dtmNew2To.Date + 1;
           if (Frac(dtmNew3From.Time) <> 0) and (Frac(dtmNew3To.Time) = 0) then dtmNew3To.Date := dtmNew3To.Date + 1;
           if (Frac(dtmNew4From.Time) <> 0) and (Frac(dtmNew4To.Time) = 0) then dtmNew4To.Date := dtmNew4To.Date + 1;

           //1
           if (Frac(dtmNew1From.Time) > Frac(dtmNew1To.Time)) and (Frac(dtmNew1To.Time) = 0) then
            dtmNew1To.Time := StrToTime('23:59:59');

           if (Frac(dtmNew1From.Time) > Frac(dtmNew1To.Time)) and (Frac(dtmNew1From.Time) = 0) then
            dtmNew1From.Time := StrToTime('23:59:59');

            //2
           if (Frac(dtmNew2From.Time) > Frac(dtmNew2To.Time)) and (Frac(dtmNew2To.Time) = 0) then
            dtmNew2To.Time := StrToTime('23:59:59');

           if (Frac(dtmNew2From.Time) > Frac(dtmNew2To.Time)) and (Frac(dtmNew2From.Time) = 0) then
            dtmNew2From.Time := StrToTime('23:59:59');
            //3
           if (Frac(dtmNew3From.Time) > Frac(dtmNew3To.Time)) and (Frac(dtmNew3To.Time) = 0) then
            dtmNew3To.Time := StrToTime('23:59:59');

           if (Frac(dtmNew3From.Time) > Frac(dtmNew3To.Time)) and (Frac(dtmNew3From.Time) = 0) then
            dtmNew3From.Time := StrToTime('23:59:59');
            //4
           if (Frac(dtmNew4From.Time) > Frac(dtmNew4To.Time)) and (Frac(dtmNew4To.Time) = 0) then
            dtmNew4To.Time := StrToTime('23:59:59');

           if (Frac(dtmNew4From.Time) > Frac(dtmNew4To.Time)) and (Frac(dtmNew4From.Time) = 0) then
            dtmNew4From.Time := StrToTime('23:59:59');


           // Prepare Array of shift
           InfoForUpdate.InfoShift[1].start := Frac(dtmNew1From.Time) * 60 * 24;
           InfoForUpdate.InfoShift[1].dur := Frac(dtmNew1To.Time - dtmNew1From.Time) * 60 * 24;

           InfoForUpdate.InfoShift[2].start := Frac(dtmNew2From.Time) * 60 * 24;
           InfoForUpdate.InfoShift[2].dur := Frac(dtmNew2To.Time - dtmNew2From.Time) * 60 * 24;

           InfoForUpdate.InfoShift[3].start := Frac(dtmNew3From.Time) * 60 * 24;
           InfoForUpdate.InfoShift[3].dur := Frac(dtmNew3To.Time - dtmNew3From.Time) * 60 * 24;

           InfoForUpdate.InfoShift[4].start := Frac(dtmNew4From.Time) * 60 * 24;
           InfoForUpdate.InfoShift[4].dur := Frac(dtmNew4To.Time - dtmNew4From.Time) * 60 * 24;
         end;
    end;
  end;

  m_cal.UpdateShiftCalPeriod(InfoForUpdate);


  if rgCalRes.ItemIndex > 0 then
    m_CalListToUpdate := ModifyResCal(rgCalRes.ItemIndex);


  if Assigned(m_CalListToUpdate) then
    for I := 0 to m_CalListToUpdate.Count - 1 do
    begin
      CalShift := TPGCALshift(m_CalListToUpdate[I]);
      CalShift.UpdateShiftCalPeriod(InfoForUpdate);
    end;

   //Include parent and brothers if its subres
   if MainRes.p_isMultiRes then
   begin
     if rgCalRes.ItemIndex <> 1 then
     begin
       var noOfSubRes := MainRes.p_VisResCount;
       m_CalListToUpdateForSubRes := TList.Create;
       m_CalListToUpdateForSubRes.Add(TMqmVisibleRes(MainRes.p_VisRes[0]).GetCalendar);
       for I := 1 to noOfSubRes do
        m_CalListToUpdateForSubRes.Add(TMqmVisibleRes(MainRes.GetSubRes(i)).GetCalendar);

       for I := 0 to m_CalListToUpdateForSubRes.Count - 1 do
        begin
          CalShift := TPGCALshift(m_CalListToUpdateForSubRes[I]);
          CalShift.UpdateShiftCalPeriod(InfoForUpdate);
        end;
     end else  //modify all res and sub res with same cal
     begin
        m_CalListToUpdateForSubRes := TList.Create;
        for i := 0 to p_pl.p_ResList.Count - 1 do
        begin
          Rsc := TMqmRes(p_pl.p_ResList[I]);

          if not Rsc.p_isMultiRes then continue;

          if TMqmVisibleRes(MainRes.p_VisRes[0]).p_CalCod = TMqmVisibleRes(Rsc.p_VisRes[0]).p_CalCod then
          begin

             var noOfSubRes := Rsc.p_VisResCount;
             m_CalListToUpdateForSubRes.Clear;

             m_CalListToUpdateForSubRes.Add(TMqmVisibleRes(Rsc.p_VisRes[0]).GetCalendar);
             for y := 1 to noOfSubRes do
              m_CalListToUpdateForSubRes.Add(TMqmVisibleRes(Rsc.GetSubRes(y)).GetCalendar);

             for y := 0 to m_CalListToUpdateForSubRes.Count - 1 do
              begin
                CalShift := TPGCALshift(m_CalListToUpdateForSubRes[y]);
                CalShift.UpdateShiftCalPeriod(InfoForUpdate);
              end;

          end;
        end;

     end;

     m_CalListToUpdateForSubRes.Free;
   end;

  // Reorganize
  if not p_pl.ReorganizeAll(nil, nil) then
    Result := false;

end;

//----------------------------------------------------------------------------//

function TMEditCal.CheckValidData : boolean;
var
  ErrMsg : string;
  CalElemStart, CalElemEnd : PTPGCALElem;
begin
  Result := true;

  if rgTypeWorkDay.ItemIndex <> 2 then exit;
  ErrMsg := '';

  // Check if the start and end date are congruent
  if (dtmDateCalFrom.Date > dtmDateCalTo.Date) or
     (dtmDateCalTo.Date < dtmDateCalFrom.Date) then
  begin
    ErrMsg := _('The start date and the end date of calendar are not congruent') + #10;
    Result := false;
  end;

  // Check if start and the end date are into calendar
  CalElemStart := m_Cal.GetShiftCalDay(dtmDateCalFrom.Date);
  CalElemEnd   := m_Cal.GetShiftCalDay(dtmDateCalTo.Date);
  if not Assigned(CalElemStart) or not Assigned(CalElemEnd) then
  begin
    ErrMsg := ErrMsg + _('The start date or/and end date of calendar are out of range') + #10;
    Result := false;
  end;

  //Check if exist an empty shift before one filled
  if ((Frac(dtmNew1From.Time) = 0) and (Frac(dtmNew1To.Time) = 0) and (Frac(dtmNew2From.Time) > 0)) or
     ((Frac(dtmNew2From.Time) = 0) and (Frac(dtmNew2To.Time) = 0) and (Frac(dtmNew3From.Time) > 0)) or
     ((Frac(dtmNew3From.Time) = 0) and (Frac(dtmNew3To.Time) = 0) and (Frac(dtmNew4From.Time) > 0)) then
  begin
    ErrMsg := ErrMsg + _('There is a non working shift before a working one') + #10;
    Result := false;
  end;

  // Check if the hours are in sequence (only if not midnight)
  if ((Frac(dtmNew1From.Time) <> 0) and (Frac(dtmNew1To.Time) <> 0) and (dtmNew1To.Time < dtmNew1From.Time)) or
     ((Frac(dtmNew2From.Time) <> 0) and (Frac(dtmNew2To.Time) <> 0) and (dtmNew2To.Time < dtmNew2From.Time)) or
     ((Frac(dtmNew3From.Time) <> 0) and (Frac(dtmNew3To.Time) <> 0) and (dtmNew3To.Time < dtmNew3From.Time)) or
     ((Frac(dtmNew4From.Time) <> 0) and (Frac(dtmNew4To.Time) <> 0) and (dtmNew4To.Time < dtmNew4From.Time)) then
  begin
    ErrMsg := ErrMsg + _('The hours are not in sequence') + #10;
    Result := false
  end else
    if ((Frac(dtmNew2From.Time) > 0) and (dtmNew2From.Time < dtmNew1To.Time)) or
       ((Frac(dtmNew3From.Time) > 0) and (dtmNew3From.Time < dtmNew2To.Time)) or
       ((Frac(dtmNew4From.Time) > 0) and (dtmNew4From.Time < dtmNew3To.Time)) then
    begin
      ErrMsg := ErrMsg + _('The hours are not in sequence') + #10;
      Result := false;
    end;
{
  // Check if the sum of working hours are integer or not
  WrkHours := dtmNew1To.Time - dtmNew1From.Time + dtmNew2To.Time - dtmNew2From.Time +
              dtmNew3To.Time - dtmNew3From.Time + dtmNew4To.Time - dtmNew4From.Time;
  WrkHours := Round(WrkHours * 60 / ONE_HOUR / 60 * 10000) / 10000;
  if Frac(WrkHours) <> 0 then Result := false;
}
  // Check if the user select partially worked with all empty
  if (rgTypeWorkDay.ItemIndex = 2) and
     (Frac(dtmNew1From.Time) = 0) and (Frac(dtmNew1To.Time) = 0) then
  begin
    ErrMsg := ErrMsg + _('Is not possible to select partially working day with all shifts empty') + #10;
    Result := false;
  end;

  // Check if the start and end shift are equal
  if ((Frac(dtmNew1From.Time) <> 0) and (Frac(dtmNew1To.Time) <> 0) and (dtmNew1From.Time = dtmNew1To.Time)) or
     ((Frac(dtmNew2From.Time) <> 0) and (Frac(dtmNew2To.Time) <> 0) and (dtmNew2From.Time = dtmNew2To.Time)) or
     ((Frac(dtmNew3From.Time) <> 0) and (Frac(dtmNew3To.Time) <> 0) and (dtmNew3From.Time = dtmNew3To.Time)) or
     ((Frac(dtmNew4From.Time) <> 0) and (Frac(dtmNew4To.Time) <> 0) and (dtmNew4From.Time = dtmNew4To.Time)) then
  begin
    ErrMsg := ErrMsg + _('In one or more shifts the start date and the end date are equal') + #10;
    Result := false;
  end;

  if not Result then
    MessageDlg(_('One or more data are not correct') + ':' + #10 + ErrMsg, mtWarning, [mbOk], 0);

end;

//----------------------------------------------------------------------------//

procedure TMEditCal.PrepData(NoChangeItmIdx: boolean);
var
  i : integer;
  tmStart, tmEnd : TDateTime;
begin

  m_ShiftCalDay := m_Cal.GetShiftCalDay(dtmDateCalFrom.Date);

  if NoChangeItmIdx then
  begin
    if Assigned(m_ShiftCalDay) then
      case Trunc(m_ShiftCalDay.JNUMWH) of
         0: rgTypeWorkDay.ItemIndex := 0;
        24: rgTypeWorkDay.ItemIndex := 1;
      else
         rgTypeWorkDay.ItemIndex := 2;
      end
    else
      rgTypeWorkDay.ItemIndex := 0;
  end;
  stActual1From.Caption := '0.00.00';
  stActual1To.Caption := '0.00.00';
  stActual2From.Caption := '0.00.00';
  stActual2To.Caption := '0.00.00';
  stActual3From.Caption := '0.00.00';
  stActual3To.Caption := '0.00.00';
  stActual4From.Caption := '0.00.00';
  stActual4To.Caption := '0.00.00';

  PutAllMidnight;

  if not Assigned(m_ShiftCalDay) then exit;

  for i := 1 to 4 do
  begin

    tmStart := Frac(m_ShiftCalDay.shift[i].start/60/24);
    tmEnd := tmStart + Frac(m_ShiftCalDay.shift[i].dur/60/24);

    case i of
      1: begin
           if tmStart > 0 then
           begin
             stActual1From.Caption := FormatDateTime('HH:mm:ss', tmStart);
             dtmNew1From.Time := Frac(tmStart);
           end else
            stActual1From.Caption := '00:00:00';

           if tmEnd >= 0 then
           begin
             if (TimetoStr(tmEnd) = '11:59:59 PM') or (TimetoStr(tmEnd) = '11:59:00 PM') or (TimetoStr(tmEnd) = '12:00:00 AM') or
                (TimetoStr(tmEnd) = '23:59:59') or (TimetoStr(tmEnd) = '23:59:00') then
             begin
              stActual1To.Caption := '00:00:00';
              dtmNew1To.Time := 0
             end else
             begin
              stActual1To.Caption := FormatDateTime('HH:mm:ss', tmEnd);
              dtmNew1To.Time := Frac(tmEnd);
             end;
           end;
         end;
      2: begin
           if tmStart > 0 then
           begin
             stActual2From.Caption := FormatDateTime('HH:mm:ss', tmStart);
             dtmNew2From.Time := Frac(tmStart);
           end else
            stActual2From.Caption := '00:00:00';

           if tmEnd >= 0 then
           begin
             if (TimetoStr(tmEnd) = '11:59:59 PM') or (TimetoStr(tmEnd) = '11:59:00 PM') or
                (TimetoStr(tmEnd) = '23:59:59') or (TimetoStr(tmEnd) = '23:59:00') then
             begin
              stActual2To.Caption := '00:00:00';
              dtmNew2To.Time := 0
             end else
             begin
              stActual2To.Caption := FormatDateTime('HH:mm:ss', tmEnd);
              dtmNew2To.Time := Frac(tmEnd);
             end;
           end;
         end;
      3: begin
           if tmStart > 0 then
           begin
             stActual3From.Caption := FormatDateTime('HH:mm:ss', tmStart);
             dtmNew3From.Time := Frac(tmStart);
           end else
            stActual3From.Caption := '00:00:00';

           if tmEnd >= 0 then
           begin
             if (TimetoStr(tmEnd) = '11:59:59 PM') or (TimetoStr(tmEnd) = '11:59:00 PM') or (TimetoStr(tmEnd) = '12:00:00 AM') or
                (TimetoStr(tmEnd) = '23:59:59') or (TimetoStr(tmEnd) = '23:59:00') then
             begin
              stActual3To.Caption := '00:00:00';
              dtmNew3To.Time := 0
             end else
             begin
              stActual3To.Caption := FormatDateTime('HH:mm:ss', tmEnd);
              dtmNew3To.Time := Frac(tmEnd);
             end;
           end;
         end;
      4: begin
           if tmStart > 0 then
           begin
             stActual4From.Caption := FormatDateTime('HH:mm:ss', tmStart);
             dtmNew4From.Time := Frac(tmStart);
           end else
            stActual4From.Caption := '00:00:00';

           if tmEnd >= 0 then
           begin
             if (TimetoStr(tmEnd) = '11:59:59 PM') or (TimetoStr(tmEnd) = '11:59:00 PM') or (TimetoStr(tmEnd) = '12:00:00 AM') or
                (TimetoStr(tmEnd) = '23:59:59') or (TimetoStr(tmEnd) = '23:59:00') then
             begin
              stActual4To.Caption := '00:00:00';
              dtmNew4To.Time := 0
             end else
             begin
              stActual4To.Caption := FormatDateTime('HH:mm:ss', tmEnd);
              dtmNew4To.Time := Frac(tmEnd);
             end;
           end;
         end;
    end;
  end;

end;

//----------------------------------------------------------------------------//

procedure TMEditCal.PutAllMidnight;
begin
  dtmNew1From.Time := 0;
  dtmNew1To.Time := 0;
  dtmNew2From.Time := 0;
  dtmNew2To.Time := 0;
  dtmNew3From.Time := 0;
  dtmNew3To.Time := 0;
  dtmNew4From.Time := 0;
  dtmNew4To.Time := 0;
end;

//----------------------------------------------------------------------------//

procedure TMEditCal.rgTypeWorkDayClick(Sender: TObject);
begin
  if rgTypeWorkDay.ItemIndex = 2 then
  begin
    PrepData(false);
    dtmNew1From.Enabled := true;
    dtmNew1To.Enabled := true;
    dtmNew2From.Enabled := true;
    dtmNew2To.Enabled := true;
    dtmNew3From.Enabled := true;
    dtmNew3To.Enabled := true;
    dtmNew4From.Enabled := true;
    dtmNew4To.Enabled := true;
  end else
  begin
    PutAllMidnight;
    dtmNew1From.Enabled := false;
    dtmNew1To.Enabled := false;
    dtmNew2From.Enabled := false;
    dtmNew2To.Enabled := false;
    dtmNew3From.Enabled := false;
    dtmNew3To.Enabled := false;
    dtmNew4From.Enabled := false;
    dtmNew4To.Enabled := false;
  end;
end;

//----------------------------------------------------------------------------//

procedure TMEditCal.BtnAboClick(Sender: TObject);
begin
  ModalResult := mrAbort;
  Close;
end;

procedure TMEditCal.PhaseCalComponent(dt : TDate);
begin
  dtmNew1From.Date := dt;
  dtmNew1To.Date := dt;
  dtmNew2From.Date := dt;
  dtmNew2To.Date := dt;
  dtmNew3From.Date := dt;
  dtmNew3To.Date := dt;
  dtmNew4From.Date := dt;
  dtmNew4To.Date := dt;
end;

//----------------------------------------------------------------------------//
{sav
function TMEditCal.IsChangedSomething : boolean;
begin
  Result := false;
  if (StrToTime(stActual1From.Caption) <> Frac(dtmNew1From.Time)) or (StrToTime(stActual1To.Caption) <> Frac(dtmNew1To.Time)) or
     (StrToTime(stActual2From.Caption) <> Frac(dtmNew2From.Time)) or (StrToTime(stActual2To.Caption) <> Frac(dtmNew2To.Time)) or
     (StrToTime(stActual3From.Caption) <> Frac(dtmNew3From.Time)) or (StrToTime(stActual3To.Caption) <> Frac(dtmNew3To.Time)) or
     (StrToTime(stActual4From.Caption) <> Frac(dtmNew4From.Time)) or (StrToTime(stActual4To.Caption) <> Frac(dtmNew4To.Time)) then
    Result := true;
end;
}
//----------------------------------------------------------------------------//

procedure TMEditCal.dtmDateCalFromChange(Sender: TObject);
begin
//  dtmDateCalFrom.MinDate := now;
  dtmDateCalTo.Date := dtmDateCalFrom.Date;
end;

//----------------------------------------------------------------------------//

procedure TMEditCal.chbModEndCalClick(Sender: TObject);
begin
  if chbModEndCal.Checked then
  begin
    dtmDateCalTo.Enabled := false;
    dtmDateCalTo.Date := m_Cal.GetLastDate
  end else
  begin
    dtmDateCalTo.Enabled := true;
    dtmDateCalTo.Date := dtmDateCalFrom.Date;
  end;
end;

//----------------------------------------------------------------------------//

procedure TMEditCal.dtmDateCalFromClick(Sender: TObject);
var
  CalElemStart : PTPGCALElem;
begin
  CalElemStart := m_Cal.GetShiftCalDay(dtmDateCalFrom.Date);
  if Assigned(CalElemStart) then
  begin
    PhaseCalComponent(dtmDateCalFrom.Date);
    PrepData(true);
  end
end;

//----------------------------------------------------------------------------//

end.
