unit FMWait;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, UMSchedList, StdCtrls, UMCommon, FMStatistics;

type
  WOperation = (w_Save, w_SaveAs, w_Statistic_Create, w_Statistic_Show, w_Refresh, w_Reload,
               w_MoveAllAfterToday, w_MoveByActTabAfterToday, w_MoveAllAfterTodayAndCloseGaps,
               w_MoveByActTabAfterTodayAndCloseGaps, w_BuildingAutoSeqSort, w_close,
               w_CompactJobsFromThisPointAllRes, w_CompactJobsFromThisPoint, w_BalanceUpdate, w_SavedPlanCopy);

  TFWait = class(TForm)
    Panel1: TPanel;
    Timer1: TTimer;
    constructor CreateWaitForm(AOwner: TComponent; Op: WOperation; ObjList: TMSchedList);
    constructor CreateWaitFormSavedPlan(AOwner: TComponent; Op: WOperation; SET_NAME,SET_DESC : string; StartDate, EndDate : TDatetime; ListSavedPlanCopy : TList);

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure CloseForm(Sender: TObject);
  private
    { Private declarations }
    m_Op: WOperation;
    m_ObjList: TMSchedList;
    m_ListStatisticOfGantTab, m_List : TList;
    m_Statistics : TFStatistics;
    m_SET_NAME : string;
    m_SET_DESC : string;
    m_StartDate, m_EndDate : TDateTime;
  public
    m_Weeks : boolean;
    m_ProgBar : TMqmProgBar;
    function GetStatisticGanttList : TList;
    function GetStatisticObj : TFStatistics;
    { Public declarations }
  end;

var
  FWait: TFWait;

implementation

uses
  FMMainPlan,
  FMAutoSched,
  UMAutoSchedCfg,
  UMGlobal,
  UMPlan, UMObjCont,
  DMsrvPc,
  ComCtrls, FMbin;

{$R *.dfm}

constructor TFWait.CreateWaitForm(AOwner: TComponent; Op: WOperation; ObjList: TMSchedList);
begin
  inherited Create(AOwner);
  Timer1.Interval := 100;
  Timer1.OnTimer := CloseForm;
  m_ObjList := ObjList;
  m_Op := Op;

  if (m_Op = w_BuildingAutoSeqSort) then
  begin
    m_ProgBar := TMqmProgBar.Create(self);
    with m_ProgBar do
    begin
      Parent := Self;
      Enabled := false;
      Top := 35;
      Left := 10;
      Width := 200;
      Height := 20;
      TickStyle := tsNone;
      SliderVisible := false;
    end;
  end;

end;

//----------------------------------------------------------------------------//

constructor TFWait.CreateWaitFormSavedPlan(AOwner: TComponent; Op: WOperation; SET_NAME, SET_DESC : string; StartDate, EndDate : TDatetime; ListSavedPlanCopy : TList);
begin
  inherited Create(AOwner);
  Timer1.Interval := 100;
  Timer1.OnTimer := CloseForm;
  m_SET_NAME := SET_NAME;
  m_SET_DESC := SET_DESC;
  m_StartDate := StartDate;
  m_EndDate := EndDate;
  m_List := ListSavedPlanCopy;

  m_Op := Op;

  if (m_Op = w_BuildingAutoSeqSort) then
  begin
    m_ProgBar := TMqmProgBar.Create(self);
    with m_ProgBar do
    begin
      Parent := Self;
      Enabled := false;
      Top := 35;
      Left := 10;
      Width := 200;
      Height := 20;
      TickStyle := tsNone;
      SliderVisible := false;
    end;
  end;

end;

//----------------------------------------------------------------------------//


procedure TFWait.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  FWait.free
end;

//----------------------------------------------------------------------------//

procedure TFWait.FormActivate(Sender: TObject);
var
  EnvOK: boolean;
begin
  Repaint;

  case m_op of

    w_Save :  begin

                Panel1.Caption := 'SAVING...';

                DBAppGlobals.m_SaveProcessStartedAndNotCompleted := true;

                DMib.m_MainDB.Ping;
                FMQMPlan.SaveToDB(false);

                DBAppGlobals.m_SaveProcessStartedAndNotCompleted := false;

                // Issue bellow was solved 16.09.2025
                // those line below make problem in Interbase , so operation will be done at co closing program.
               // if IniAppGlobals.DownloadTo <> '2' then
               // begin
                FMQMPlan.GetPlanCfg.StoreToDatabase;
                SaveAutoSchedCfgToDB;
                if fbin <> nil then FBin.SaveStatus;
                GlobSaveValues;
                GlobSaveIniValues;

               // end;

              end;

    w_SaveAs :  begin
                  Panel1.Caption := 'SAVING...';
                  FMQMPlan.SaveToDB(true);
                end;

    w_SavedPlanCopy  : begin
                  Panel1.Caption := 'Saving plan copy ...';
                  Panel1.Refresh;
                  p_pl.SavedPlanCopy(m_SET_NAME, m_SET_DESC, m_StartDate, m_EndDate, m_List);
                end;

    w_Statistic_Create : begin
                  Panel1.Caption := 'Create Statistics ...';
                  Panel1.Refresh;
                  m_ListStatisticOfGantTab := FMQMPlan.BuildStatisticAndShow(false);
                  m_Statistics := TFStatistics.CreateStatistics(Application, m_ListStatisticOfGantTab, false, true);
                end;

    w_Statistic_Show : begin
                  Panel1.Caption := 'Show Statistics ...';
                  Panel1.Refresh;
                  m_ListStatisticOfGantTab := FMQMPlan.BuildStatisticAndShow(true);
                  m_Statistics := TFStatistics.CreateStatistics(Application, m_ListStatisticOfGantTab, true, m_Weeks);
                end;

    w_Refresh : begin
                  DBAppGlobals.m_RefreshProcessStarted := true;
                  DMib.m_MainDB.Ping;
                  Panel1.Caption := 'REFRESHING DATA...';
                  Application.ProcessMessages;
                  RefreshData;
                  DBAppGlobals.m_RefreshProcessStarted := false;
                end;

    w_MoveAllAfterToday : begin
                       Panel1.Caption := 'PUSH  ALL  AND  ORGANIZE  PLAN ...';
                       FMQMPlan.OrganizePlanAfterOrBeforeToday(false, true)
                     end;

    w_MoveByActTabAfterToday : begin
                       Panel1.Caption := 'PUSH  ALL  AND  ORGANIZE  PLAN ...';
                       FMQMPlan.OrganizePlanAfterOrBeforeToday(true, true)
                     end;

    w_MoveAllAfterTodayAndCloseGaps : begin
                       Panel1.Caption := 'PUSH  ALL  AND  ORGANIZE  PLAN ...';
                       FMQMPlan.OrganizePlanAfterOrBeforeToday(false, false)
                     end;

    w_MoveByActTabAfterTodayAndCloseGaps : begin
                       Panel1.Caption := 'PUSH  ALL  AND  ORGANIZE  PLAN ...';
                       FMQMPlan.OrganizePlanAfterOrBeforeToday(true, false)
                     end;


    w_BuildingAutoSeqSort : begin
                       Panel1.Caption := 'Sorting ...';
                       if Assigned(FAutoSched) then
                          FAutoSched.SetOverlappForJobList(m_ObjList, self);
                      // if Assigned(FBin) then
                       //  FBin.SetOverlappForJobList(m_ObjList, self);
                     end;
    w_close : begin
                Panel1.Caption := 'Closing ...';
              end;

    w_CompactJobsFromThisPoint : begin
                      Panel1.Caption := 'REFRESHING DATA...';
                      Application.ProcessMessages;
                      FMQMPlan.CompactallscheduledjobsfromthispointonwardonlyforselectedResource(false);

                    end;

     w_CompactJobsFromThisPointAllRes : begin
                      Panel1.Caption := 'REFRESHING DATA...';
                      Application.ProcessMessages;
                      FMQMPlan.CompactallscheduledjobsfromthispointonwardonlyforselectedResource(true);

                    end;

     w_BalanceUpdate : begin
                      Panel1.Caption := 'BALANCE UPDATE...';
                      Application.ProcessMessages;
                      FMQMPlan.UpdateBalanceListFromDB;
                    end;


  end;


 // Timer1.Enabled := true;
end;

//----------------------------------------------------------------------------//

function TFWait.GetStatisticGanttList : TList;
begin
  Result := m_ListStatisticOfGantTab;
end;

//----------------------------------------------------------------------------//

function TFWait.GetStatisticObj: TFStatistics;
begin
  result := m_Statistics;
end;

//----------------------------------------------------------------------------//

procedure TFWait.CloseForm;
begin
  close
end;

end.
