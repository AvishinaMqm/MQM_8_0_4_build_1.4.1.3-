unit FMAutoSched;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Gauges, UReShape,
  UMRank,
  UMAutoSched,
  UMSchedList,
  UMOpStack;

type

  TFAutoSched = class(TForm)
    Panel1: TPanel;
    BtnAbo: TBitBtn;
    Bevel1: TBevel;
    GObj: TGauge;
    LblElapsedT: TLabel;
    LblElapsed: TLabel;
    LblRemainT: TLabel;
    AutoSeqCfgName: TLabel;
    LblNumTry: TLabel;
    procedure BtnAboClick(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
  private
    m_SavedCaption : string;
  public
    m_AutoSchedTread: TAutoSchedThread;
    m_LastObjRank: TCustomRank;
    m_ResultsOnPlan: TList;
    m_ResultsInBin: TList;
    m_ObjList: TMSchedList;
    m_ManagerResList : TList;
    m_OperatedAbort  : boolean;
    m_StartTime      : TDateTime;
    constructor CreateAutoSched(AOwner: Tcomponent; ObjList: TMSchedList; ResOnPlan, ResInBin: TList; ManagerResList : TList);
    destructor Destroy; override;
    procedure SetObj(Progress,ElapsedHH,ElapsedMM,ElapsedSS : integer; AutoCfg : string);
    procedure SetStartTime(StartTime : TDateTime);
    procedure SetTryToImproveJobsPossition(Progress : integer; NumberOfTry : integer);
    function  SetElapsedTime : string;

    procedure ThreadDone(Sender: TObject);
    procedure SetOverlappForJobList(ObjList: TMSchedList; Wait : TForm);
  end;

var
  FAutoSched: TFAutoSched;

implementation

{$R *.DFM}

uses
  gnugettext,
 // FMRankReport,
  FMAutoSchedReport,
  UMObjCont,
  UMSchedCont,
  UMSchedContFunc,
  UMPlanFunc,
  UMBinFunc,
  FMMainPlan,
  UMStoredProc,
  FMbin,
  FMWait,
  UMAutoSchedCfg,
  UMbinGrid,
  UMCompat,
  UMPlanTbs,
  UMRes,
  UMGlobal,
  UMPlanObj,
  UMBinTbs;

//----------------------------------------------------------------------------//

constructor TFAutoSched.CreateAutoSched(AOwner: Tcomponent; ObjList: TMSchedList; ResOnPlan, ResInBin: TList; ManagerResList : TList);
var
  i : integer;
  IsPrevHighDateVisible, IsNextLowDateVisible : boolean;
  binGrid: TBinDrawGrid;
  Id : TSchedId;
begin
  inherited create(AOwner);
  m_SavedCaption := Caption;
  m_OperatedAbort := false;
  IsPrevHighDateVisible := false;
  IsNextLowDateVisible  := false;
  m_LastObjRank := nil;

  TranslateComponent (self);
  FAutoSched := self;

  m_ResultsOnPlan := ResOnPlan;
  m_ResultsInBin := ResInBin;
  m_ResultsOnPlan.Clear;
  m_ResultsInBin.Clear;
  m_ManagerResList := ManagerResList;

  AutoSchedCfg.m_SortBeforeSchedule := false;

//  if not AutoSchedCfg.m_SortBeforeSchedule then
  if not CheckIfActiveGanttTabIsMcm then
    FMQMPlan.MiniMizedMainForm;

//  AutoSchedCfg.m_SortBeforeSchedule := false;
  if AutoSchedCfg.m_SortBeforeSchedule then
  begin
    TFWait.CreateWaitForm(self, w_BuildingAutoSeqSort, ObjList).ShowModal;
    ObjList.SortList(SortAutoSeqCustomField);
    FMQMPlan.MiniMizedMainForm;
  end;

//  if ParamCount > 0 then // Orta
//    self.WindowState := wsMinimized;

  binGrid := FBin.GetActiveView.GetBinGrid;

  for I := low(binGrid.BinColumnSet) to high(binGrid.BinColumnSet) do
  begin
    if (binGrid.BinColumnSet[i].Field = CSC_PrvHighestDate) then
      IsPrevHighDateVisible := binGrid.BinColumnSet[i].Visible;
    if (binGrid.BinColumnSet[i].Field = CSC_NxtLowestDate) then
    begin
      IsNextLowDateVisible := binGrid.BinColumnSet[i].Visible;
      break;
    end;
  end;

  m_ObjList := ObjList;
  ReShape(Self);
  m_AutoSchedTread := TAutoSchedThread.CreateAutoSchedTread(self, ObjList,IsPrevHighDateVisible, IsNextLowDateVisible, m_ManagerResList);
end;

//----------------------------------------------------------------------------//

destructor TFAutoSched.Destroy;
begin
//  m_LastObjRank.Free;
  inherited Destroy;
  FAutoSched := nil;
end;

procedure TFAutoSched.Panel1Click(Sender: TObject);
begin

end;

//----------------------------------------------------------------------------//

procedure TFAutoSched.BtnAboClick(Sender: TObject);
var
  I : Integer;
begin
  m_OperatedAbort := true;
  if Assigned(AutoSchedTread) then
  begin
    for I := 0 to m_ObjList.GetLinkCount - 1 do
    begin
      p_sc.SetAutoSeqPrevNextIds(m_ObjList.GetLink(I), CSchedIDnull,true);
      p_sc.SetAutoSeqPrevNextIds(m_ObjList.GetLink(I), CSchedIDnull, false);
    end;
    AutoSchedTread.Terminate;
    LblElapsedT.Caption := _('Waiting for process end...')
  end else
    close;
end;

//----------------------------------------------------------------------------//

function TFAutoSched.SetElapsedTime : string;
var
  Year, Month, Day, Hour, Minute, Second, milisecond : Word;
  CurrentTime, TmpSeconds : double;
  ElapsedHH,ElapsedMM,ElapsedSS : integer;
  Elapsed : string;
begin
  DecodeTime(now, hour, minute, second, milisecond);
        CurrentTime := (hour * 3600) + (minute * 60) + second;
        TmpSeconds := CurrentTime - m_StartTime;
        ElapsedHH := trunc(TmpSeconds / 3600);
        TmpSeconds := TmpSeconds - (ElapsedHH * 3600);
        ElapsedMM := trunc(TmpSeconds / 60);
        TmpSeconds := TmpSeconds - (ElapsedMM * 60);
        ElapsedSS := trunc(TmpSeconds);

  Elapsed := '';

  if ElapsedHH > 0 then
     Elapsed := Elapsed + inttostr(ElapsedHH) + ' hours  ';
  if ElapsedMM > 0 then
     Elapsed := Elapsed + inttostr(ElapsedMM) + ' minutes  ';
  if ElapsedSS > 0 then
     Elapsed := Elapsed + inttostr(ElapsedSS) + ' seconds ...';
   LblElapsedT.Caption := Elapsed;

  Result := Elapsed;
end;

//----------------------------------------------------------------------------//


procedure TFAutoSched.SetObj(Progress,ElapsedHH,ElapsedMM,ElapsedSS : integer; AutoCfg : string);
var
  Elapsed : string;
begin
  try
    GObj.Progress := Progress;

    Elapsed := '';

    if ElapsedHH > 0 then
       Elapsed := Elapsed + inttostr(ElapsedHH) + ' hours  ';
    if ElapsedMM > 0 then
       Elapsed := Elapsed + inttostr(ElapsedMM) + ' minutes  ';
    if ElapsedSS > 0 then
       Elapsed := Elapsed + inttostr(ElapsedSS) + ' seconds ...';

     LblElapsedT.Caption := Elapsed;
    // Caption := m_SavedCaption + ' - ' + AutoCfg;
     AutoSeqCfgName.Caption := m_SavedCaption + ' - ' + AutoCfg;
  except
  end;
end;

//----------------------------------------------------------------------------//

procedure TFAutoSched.SetStartTime(StartTime : TDateTime);
begin
  m_startTime := StartTime
end;

//----------------------------------------------------------------------------//

procedure TFAutoSched.SetTryToImproveJobsPossition(Progress : integer; NumberOfTry : integer);
begin
  AutoSeqCfgName.top := 50;
  LblNumTry.visible := true;
  LblNumTry.caption := 'Try to improve jobs positioning  [' + IntToStr(NumberOfTry) + '.....15]';
  try
    GObj.Progress := Progress;

  except

  end;
end;

//----------------------------------------------------------------------------//

procedure TFAutoSched.ThreadDone(Sender: TObject);
begin
//  if Terminated then
//    FMQMPlan.ExitCompatModeInPlan;
  try
    FMQMPlan.ActiveUndo;
    FMQMPlan.GetActiveTab.FocusOnLine(0);
    PostMessage(handle, WM_CLOSE, 0, StrToInt(IniAppGlobals.Identifier));
    FMQMPlan.MaxiMizedMainForm
  except
  end;
//  Close;
end;

//----------------------------------------------------------------------------//

procedure TFAutoSched.SetOverlappForJobList(ObjList: TMSchedList; Wait : TForm);
var
  I, J : integer;
  ActiveTbs : TMqmPlanTabSheet;
  VisRes    : TMqmVisibleRes;

  CompVal   : TCompatVal;
  Save_Cursor : TCursor;
  WaitTime : TFWait;
  Dependency : boolean;
begin
  WaitTime := TFWait(Wait);
  Save_Cursor   := Screen.Cursor;
  Screen.Cursor  := crAppStart; //SQLWait;
  ActiveTbs := FMQMPlan.GetActiveTab;

  if Assigned(WaitTime.m_ProgBar) then
    WaitTime.m_ProgBar.SetMax(ObjList.GetLinkCount);

  for J := 0 to ObjList.GetLinkCount - 1 do
  begin
    Application.ProcessMessages;

    if Assigned(WaitTime.m_ProgBar) then
      WaitTime.m_ProgBar.SetPosition(J);

    for i := 0 to ActiveTbs.p_ganttPanel.p_VisResList.Count-1 do
    begin
      Application.ProcessMessages;
      p_pl.EnterCompatModeInPlan(ObjList.GetLink(J));
      VisRes := TMqmVisibleRes(ActiveTbs.p_ganttPanel.p_VisResList[i]);
      if VisRes.CheckCompatWithOcc([cho_compVal, cho_timing, cho_wkc, cho_readOnly, cho_qty, cho_Depend],
                                      ObjList.GetLink(J) , 0, nil, CompVal, Dependency)
      and (CompVal <= AutoSchedCfg.m_MinJobResComp) then
      begin
        p_pl.SetOvplTargetRes(VisRes, OvlpChk_OptimumLimits, -1);
        break;
      end;
    end;
  end;

  if Assigned(WaitTime.m_ProgBar) then
    WaitTime.m_ProgBar.SetPosition(0);

  p_pl.ExitCompatModeInPlan;
  Screen.Cursor := Save_Cursor;
end;

end.
