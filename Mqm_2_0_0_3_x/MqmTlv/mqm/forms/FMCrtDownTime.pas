unit FMCrtDownTime;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Buttons, UMGlobal, DateUtils,
  Grids, Menus, UGPropComp, UMCapRes, UmActArea,
  UMCapResMover, Spin, UmRes, gnugettext, UReShape, ExSpinEdit ;

type
  TCapResMoveSrvFunc = procedure (ptr: pointer);

  TFCrtDownTime = class(TForm)
    Panel1: TPanel;
    GBStDate: TGroupBox;
    DTPStDate: TDateTimePicker;
    DTPStTime: TDateTimePicker;
    GBEndDate: TGroupBox;
    DTPEndDate: TDateTimePicker;
    DTPEndTime: TDateTimePicker;
    GBDuration: TGroupBox;
    GroupBox5: TGroupBox;
    EdtComment: TEdit;
    LblStDate: TLabel;
    LblEndDate: TLabel;
    LblEndTime: TLabel;
    LblStTime: TLabel;
    LblDays: TLabel;
    LblHours: TLabel;
    LblMinutes: TLabel;
    SEDays: TexSpinEdit;
    SEHours: TexSpinEdit;
    SEMinutes: TexSpinEdit;
    CBCrossDntime: TCheckBox;
    BtnOk: TcxButton;
    BtnAbort: TcxButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOkClick(Sender: TObject);
    procedure BtnAbortClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DTPStDateChange(Sender: TObject);
    procedure DTPStTimeChange(Sender: TObject);
    procedure DTPEndDateChange(Sender: TObject);
    procedure DTPEndTimeChange(Sender: TObject);
    procedure SEDaysChange(Sender: TObject);
    procedure SEHoursChange(Sender: TObject);
    procedure SEMinutesChange(Sender: TObject);
    procedure CBCrossDntimeClick(Sender: TObject);
    procedure SEDaysKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SEHoursKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SEMinutesKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    m_New: boolean;
    m_Apa: TMqmActArea;
    m_CapRes: TMqmCapRes;
    m_CapResMover: TMqmCapResMover;
    m_MouseDate: TDateTime;
    m_LockChanges: boolean;

    m_suppFnc:  TCapResMoveSrvFunc;
    m_suppObj:  TObject;
    m_ControlDaysChange, m_ControlHoursChange, m_ControlMinutesChange : boolean;
    procedure InitCaptions;
    function  CheckData: boolean;
    procedure UpdateObjData;
    procedure StartDateChanged;
    procedure EndDateChanged;
    procedure DurationChanged;
    procedure EnableDisablField(control : boolean);
    function getDur(StDate, EndDate : TDateTime): Integer;
    { Private declarations }
  public
    { Public declarations }
    constructor CreateFMCrtCapRes(AOwner: TComponent; CapRes: TMqmCapRes; StDate: TDateTime);
    destructor Destroy; override;
    function  MoveTo(Apa: TMqmActArea; Date: TDateTime; Duration: integer; isEnd: boolean): boolean;
    property p_CapResMover: TMqmCapResMover       read m_CapResMover;
    function GetCapRes : TMqmCapRes;
  end;

  function  GetDownTimeForm: TFCrtDownTime;
  procedure OpenDownTimeForm(AOwner: TWinControl; CapRes: TMqmCapRes;
                          fnc: TCapResMoveSrvFunc; obj: TObject; apa: TMqmActArea; StDate: TDateTime);

var
  FCrtDownTime: TFCrtDownTime;

implementation

{$R *.DFM}

uses
  UGglobal,
  UMCompat,
  UMObjCont,
  UMPlanObj,
  UMDurObj,
  UMWkCtr,
  UGbaseCal,
  FMMainPlan;

//----------------------------------------------------------------------------//

procedure OpenDownTimeForm(AOwner: TWinControl; CapRes: TMqmCapRes;
                          fnc: TCapResMoveSrvFunc; obj: TObject; apa: TMqmActArea; StDate: TDateTime);
begin
  if not Assigned(FCrtDownTime) then
  begin
    FCrtDownTime := TFCrtDownTime.CreateFMCrtCapRes(AOwner, CapRes, StDate);
    FCrtDownTime.formStyle := fsStayOnTop
  end;

  with FCrtDownTime do
  begin
    m_CapResMover := TMqmCapResMover.Create;
    m_CapResMover.SetCapResToMove(m_CapRes);
    Include(m_capRes.m_ObjProp, objPr_MoveSel);
    m_Apa := apa;
    m_suppFnc :=  fnc;
    m_suppObj :=  obj;
    FMQMPlan.RefreshActiveTab;   // Refresh Plan
    Show
  end
end;

//----------------------------------------------------------------------------//

function GetDownTimeForm: TFCrtDownTime;
begin
  Result := FCrtDownTime
end;

//----------------------------------------------------------------------------//

constructor TFCrtDownTime.CreateFMCrtCapRes(AOwner: TComponent; CapRes: TMqmCapRes; StDate: TDateTime);
begin
  inherited Create(AOwner);
  if assigned(CapRes) then
  begin
    m_CapRes := CapRes;
    if (m_CapRes.m_Type = Cr_CrossingDtm) then
      CBCrossDntime.Checked := true;
    CBCrossDntime.Enabled := false;
    if TMqmCapRes(CapRes).p_CapResNum < 0 then
       EnableDisablField(false);
    m_Apa := TMqmActArea(CapRes.p_father);
    m_New := false
  end else
  begin
    m_New := true;
  end;

  m_MouseDate := StDate;

  if (DBAppSettings.CapResStartEnd) and (m_New) then
  begin
     DTPEndDate.Enabled := True;
     DTPStDate.Enabled := True;
     GBDuration.Enabled := False;
  end else
  begin
    DTPEndDate.Enabled := False;
    DTPStDate.Enabled := False;
    GBDuration.Enabled := True;
  end;

  InitCaptions;
end;

//----------------------------------------------------------------------------//

procedure TFCrtDownTime.FormCreate(Sender: TObject);
begin
  TranslateComponent (self);
 // Canvas.Font.Name := 'Montserrat';
  ReShape(self);
  m_ControlDaysChange := true;
  m_ControlHoursChange := true;
  m_ControlMinutesChange := true;
end;

//----------------------------------------------------------------------------//

destructor TFCrtDownTime.Destroy;
begin
  inherited destroy;
  FCrtDownTime := nil;
end;

//----------------------------------------------------------------------------//

procedure TFCrtDownTime.InitCaptions;
begin
  m_LockChanges := true;

  Caption := _('Downtime');

  if m_New then
  begin
    DTPStDate.DateTime  := m_MouseDate;
    DTPStTime.DateTime  := m_MouseDate;
    DTPEndDate.DateTime := m_MouseDate;
    DTPEndTime.DateTime := m_MouseDate;
    SEHours.Value       := 1;
    BtnOk.Enabled       := false;
  end else
  begin
    DTPStDate.DateTime  := m_CapRes.p_start;
    DTPStTime.DateTime  := m_CapRes.p_start;

    DTPEndDate.DateTime := m_CapRes.p_End;
    DTPEndTime.DateTime := m_CapRes.p_End;

    SEDays.Value    := Trunc(m_CapRes.p_dur / 24 / 60);
    SEHours.Value   := Trunc((m_CapRes.p_dur - SEDays.Value*24*60) / 60);
    SEMinutes.Value := Trunc(m_CapRes.p_dur - SEDays.Value*24*60 - SEHours.Value * 60);

    EdtComment.Text := m_CapRes.m_Comment;
  end;

  SEDays.MinValue    := 0;
  SEHours.MinValue   := 0;
  SEMinutes.MinValue := 0;

  SEDays.MaxValue    := 9999;
  SEHours.MaxValue   := 99;
  SEMinutes.MaxValue := 59;

  DTPStDate.OnChange  := DTPStDateChange;
  DTPStTime.OnChange  := DTPStTimeChange;
  DTPEndDate.OnChange := DTPEndDateChange;
  DTPEndTime.OnChange := DTPEndTimeChange;
  SEDays.OnChange     := SEDaysChange;
  SEHours.OnChange    := SEHoursChange;
  SEMinutes.OnChange  := SEMinutesChange;

 // SetComponent(EdtComment, comp_Edit,  true);
 { SetComponent(LblDays,    comp_Label, false);
  SetComponent(LblHours,   comp_Label, false);
  SetComponent(LblMinutes, comp_Label, false);
  SetComponent(LblStDate,  comp_Label, false);
  SetComponent(LblStTime,  comp_Label, false);
  SetComponent(LblEndDate, comp_Label, false);
  SetComponent(LblEndTime, comp_Label, false); }

  m_LockChanges := false;
end;

//----------------------------------------------------------------------------//

procedure TFCrtDownTime.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if (ModalResult <> mrAbort) and (ModalResult <> mrOk) then
  begin
    m_CapResMover.Abort;
    if Assigned(m_suppFnc) then m_suppFnc(m_suppObj);
    if Assigned(m_CapRes) then
      Exclude(m_capRes.m_ObjProp, objPr_MoveSel);
  end;

  if Assigned(m_Apa) then
    m_Apa.ClearMoveBackup;
  p_sc.ClearMoveOp;
  FMQMPlan.RefreshActiveTab;   // Refresh Plan

  Action    := caFree;
  FCrtDownTime := nil
end;

//----------------------------------------------------------------------------//

function TFCrtDownTime.MoveTo(Apa: TMqmActArea; Date: TDateTime; Duration: integer; isEnd: boolean): boolean;
var
  Res : TMQMRes;
  RecDwTimeLinked : PTDwTimeLinked;
  i : integer;
  DwTmObj : TMQMDurObj;
begin
  Result := false;
  BtnOk.Enabled := true;
  m_Apa := Apa;
  if not CheckData then
    exit;

  UpdateObjData;
  if Duration = -1 then
    Duration := (SEDays.Value*24*60) + (SEHours.Value*60) + SEMinutes.Value;

  m_LockChanges := true;
  EnableDisablField(false);
  if not m_CapResMover.ChangeTo(Apa, Date, Duration, isEnd) then
  begin
    if Assigned(m_suppFnc) then
      m_suppFnc(m_suppObj);

    BtnOk.Enabled := false;
    m_LockChanges := false;
    EnableDisablField(true);
    exit;
  end;

  EnableDisablField(true);
  m_LockChanges := false;
  if Assigned(m_suppFnc) then
    m_suppFnc(m_suppObj);

  // This check I think is wrong because should be opposite
  if not TMQMVisibleRes(apa.p_Father).p_isSubRes and (TMQMRes(apa.p_Res).p_VisResCount > 1) then
    if (m_CapRes.m_Type = cr_DownTime) or (m_CapRes.m_Type = Cr_CrossingDtm) then
    begin
      Res := TMQMRes(apa.p_Res);
      RecDwTimeLinked := Res.GetRecDwTmLinked(TMQMDurObj(m_CapRes));
      for i := 0 to RecDwTimeLinked.LstDwTime.Count -1 do
      begin
        DwTmObj := TMQMDurObj(RecDwTimeLinked.LstDwTime.Items[i]);
        Exclude(DwTmObj.m_ObjProp, objPr_MoveSel);
      end;
    end;

  try
    DTPStDate.DateTime  := m_CapRes.p_Start;
    DTPStTime.DateTime  := m_CapRes.p_Start;
    DTPEndDate.DateTime := m_CapRes.p_End;
    DTPEndTime.DateTime := m_CapRes.p_End;

    if SEDays.Value <> Trunc(m_CapRes.p_dur / 24 / 60) then
    begin
      m_ControlDaysChange := false;
      SEDays.Value    := Trunc(m_CapRes.p_dur / 24 / 60);
      m_ControlDaysChange := true;
    end;

    if SEHours.Value <> Trunc((m_CapRes.p_dur - SEDays.Value*24*60) / 60) then
    begin
      m_ControlHoursChange := false;
      SEHours.Value    := Trunc((m_CapRes.p_dur - SEDays.Value*24*60) / 60);
      m_ControlHoursChange := true;
    end;

    if SEMinutes.Value <> Trunc(m_CapRes.p_dur - SEDays.Value*24*60 - SEHours.Value * 60) then
    begin
      m_ControlMinutesChange := False;
      SEMinutes.Value    := Trunc(m_CapRes.p_dur - SEDays.Value*24*60 - SEHours.Value * 60);
      m_ControlMinutesChange := true;
    end;
   { SEDays.Value    := Trunc(m_CapRes.p_dur / 24 / 60);
    SEHours.Value   := Trunc((m_CapRes.p_dur - SEDays.Value*24*60) / 60);
    SEMinutes.Value := Trunc(m_CapRes.p_dur - SEDays.Value*24*60 - SEHours.Value * 60);   }

  except
    //////////
  end;
  Result := true;
end;

//----------------------------------------------------------------------------//

function TFCrtDownTime.GetCapRes : TMqmCapRes;
begin
  Result := m_CapRes
end;

//----------------------------------------------------------------------------//

function TFCrtDownTime.CheckData: boolean;
var
  Duration: integer;
begin
  Result := false;
  BtnOk.Enabled := Result;
  Duration := (SEDays.Value*24*60) + (SEHours.Value*60) + SEMinutes.Value;

  if not Assigned(m_apa) then
  begin
    showmessage(_('Select a position on the gantt first'));
    exit;
  end;

  if TMqmWrkCtr(m_apa.p_WrkCtr).p_ReadOnly then
  begin
    MessageDlg(_('Not allowed to move objects on read only resources.'), mtWarning, [mbOK], 0);
    exit
  end;

  if (Duration <= 0) then
  begin
    showmessage(_('The duration must be greater than zero'));
    exit;
  end;
  Result := true;
  BtnOk.Enabled := Result;
end;

//----------------------------------------------------------------------------//

procedure TFCrtDownTime.UpdateObjData;
begin
  with m_CapRes do
  begin
    if CBCrossDntime.Checked then
      m_type := Cr_CrossingDtm
    else
      m_type := cr_DownTime;
    m_Comment := EdtComment.Text;

    m_propList.Clear;
  end
end;

//----------------------------------------------------------------------------//

procedure TFCrtDownTime.BtnOkClick(Sender: TObject);
begin
  if not CheckData then
    exit;

  if not assigned(m_capRes.p_Father) then
  begin
    showmessage(_('Select a position on the gantt first'));
    exit
  end;
  ModalResult := mrOk;
  UpdateObjData;

  if Assigned(m_Apa) then
    m_Apa.UpdateCrossDownTmList;

  if Assigned(m_CapRes) then
    Exclude(m_capRes.m_ObjProp, objPr_MoveSel);
//  if Assigned(m_exitFnc) then m_exitFnc(m_suppObj);

  // I think check p_isSubRes should be opposite - fp
  if Assigned(m_Apa) and not TMQMVisibleRes(m_Apa.p_Father).p_isSubRes then
    TMQMRes(m_Apa.p_Res).RefreshDwTimeLinked(m_CapRes, false, m_New);

  Close
end;

//----------------------------------------------------------------------------//

procedure TFCrtDownTime.BtnAbortClick(Sender: TObject);
begin
  ModalResult := mrAbort;
  m_CapResMover.Abort;
  if Assigned(m_suppFnc) then m_suppFnc(m_suppObj);

  if Assigned(m_CapRes) then
    Exclude(m_capRes.m_ObjProp, objPr_MoveSel);

//  if Assigned(m_exitFnc) then m_exitFnc(m_suppObj)
  Close;
end;

//----------------------------------------------------------------------------//

procedure TFCrtDownTime.StartDateChanged;
var
  Duration: integer;
begin
  if m_LockChanges then exit;

  DTPStTime.Date := DTPStDate.Date;
  if Assigned(m_apa) then
  begin
    if not GBDuration.Enabled then
      Duration := getDur( DTPStTime.DateTime,DTPEndTime.DateTime)
    else
       Duration := (SEDays.Value*24*60) + (SEHours.Value*60) + SEMinutes.Value;
    MoveTo(m_Apa, DTPStTime.DateTime, Duration, false);
  end;
end;

//----------------------------------------------------------------------------//

procedure TFCrtDownTime.EnableDisablField(control: boolean);
begin
  DTPStDate.Enabled := control;
  DTPStTime.Enabled := control;
  SEDays.Enabled := control;
  SEHours.Enabled := control;
  SEMinutes.Enabled := control;
  DTPEndDate.Enabled := control;
  DTPEndTime.Enabled := control;
  EdtComment.Enabled := control;
  if m_capres.p_CapResNum < 0 then
    BtnOk.Enabled := false
  else
    BtnOk.Enabled   := true;
end;

function TFCrtDownTime.getDur(StDate, EndDate : TDateTime): Integer;
var  cal : TPGCALObj;
begin
   cal := m_Apa.GetCalendar;
   Result := trunc(cal.DiffWH(DTPStDate.DateTime, DTPEndTime.DateTime , m_Apa.m_CrossDownTmList)*60);
end;

//----------------------------------------------------------------------------//

procedure TFCrtDownTime.EndDateChanged;
var
  Duration: integer;
begin
  if m_LockChanges then exit;

   DTPEndTime.Date := DTPEndDate.Date;

  if not GBDuration.Enabled then
    Duration := getDur( DTPStTime.DateTime,DTPEndTime.DateTime)
  else
     Duration := (SEDays.Value*24*60) + (SEHours.Value*60) + SEMinutes.Value;

  if Assigned(m_apa) then
    MoveTo(m_Apa, DTPStTime.DateTime, Duration, false);

end;

//----------------------------------------------------------------------------//

procedure TFCrtDownTime.DurationChanged;
var
  Duration: integer;
begin
  if m_LockChanges then exit;

  Duration := (SEDays.Value*24*60) + (SEHours.Value*60) + SEMinutes.Value;

  if Assigned(m_apa)
  and (Duration > 0) then
    MoveTo(m_Apa, DTPStTime.DateTime, Duration, false);
end;

//----------------------------------------------------------------------------//

procedure TFCrtDownTime.DTPStDateChange(Sender: TObject);
begin
  StartDateChanged;
end;

//----------------------------------------------------------------------------//

procedure TFCrtDownTime.DTPStTimeChange(Sender: TObject);
begin
  StartDateChanged;
end;

//----------------------------------------------------------------------------//

procedure TFCrtDownTime.DTPEndDateChange(Sender: TObject);
begin
  EndDateChanged;
end;

//----------------------------------------------------------------------------//

procedure TFCrtDownTime.DTPEndTimeChange(Sender: TObject);
begin
  EndDateChanged;
end;

//----------------------------------------------------------------------------//

procedure TFCrtDownTime.SEDaysChange(Sender: TObject);
begin
  if m_ControlDaysChange then
  begin
    //m_ControlDaysChange := false;

    if SEDays.Value > 700 then
       SEDays.Value := 700;

    if SEDays.Value >= 0 then
      DurationChanged;
   // m_ControlDaysChange := true;
  end
end;

//----------------------------------------------------------------------------//

procedure TFCrtDownTime.SEHoursChange(Sender: TObject);
begin
if m_ControlHoursChange then
  begin
    m_ControlHoursChange := false;
   // if SEHours.Value > 23 then
   //   SEHours.Value := 23;

    if SEHours.Value >= 0 then
      DurationChanged;
    m_ControlHoursChange := true;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFCrtDownTime.SEMinutesChange(Sender: TObject);
begin
 if m_ControlMinutesChange then
  begin
    m_ControlMinutesChange := false;
    if SEMinutes.Value > 59 then
      SEMinutes.Value := 59;

    if SEMinutes.Value >= 0 then
      DurationChanged;
    m_ControlMinutesChange := true;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFCrtDownTime.CBCrossDntimeClick(Sender: TObject);
begin
  if CBCrossDntime.Checked then
    m_CapRes.m_Type := Cr_CrossingDtm
  else
    m_CapRes.m_Type := cr_DownTime;
end;

//----------------------------------------------------------------------------//

procedure TFCrtDownTime.SEDaysKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not (( (Integer(Key) > 47)  and (Integer(Key) < 59) or (key = vk_Back) or (Integer(Key) = 24)
          or ( (Integer(Key) > 94)  and (Integer(Key) < 106)) )) then// or (key = vk_Back) or (Key = 24)) then
    abort;
  DurationChanged;
end;

//----------------------------------------------------------------------------//

procedure TFCrtDownTime.SEHoursKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not (( (Integer(Key) > 47)  and (Integer(Key) < 59) or (key = vk_Back) or (Integer(Key) = 24)
          or ( (Integer(Key) > 94)  and (Integer(Key) < 106)) )) then// or (key = vk_Back) or (Key = 24)) then
    abort;
  if SEHours.Value > 23 then
    SEHours.Value := 23;
   DurationChanged;
end;

//----------------------------------------------------------------------------//

procedure TFCrtDownTime.SEMinutesKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not (( (Integer(Key) > 47)  and (Integer(Key) < 59) or (key = vk_Back) or (Integer(Key) = 24)
          or ( (Integer(Key) > 94)  and (Integer(Key) < 106)) )) then// or (key = vk_Back) or (Key = 24)) then
    abort;
  if SEMinutes.Value > 59 then
    SEMinutes.Value := 59;
   DurationChanged;
end;

//----------------------------------------------------------------------------//

initialization

  FCrtDownTime := nil;

//----------------------------------------------------------------------------//

end.
