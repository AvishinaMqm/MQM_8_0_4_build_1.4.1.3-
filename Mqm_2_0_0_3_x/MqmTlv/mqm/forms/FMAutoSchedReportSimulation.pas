unit FMAutoSchedReportSimulation;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UMSchedList, StdCtrls, Buttons, ExtCtrls, gnugettext, ComCtrls, UReShape;

type
  TFAutoSchedRptSimulation = class(TForm)
    PnlBtm: TPanel;
    PageControl1: TPageControl;
    BtnOk: TcxButton;
    BtnCanc: TcxButton;
    procedure BtnCancClick(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    m_ObjList : TMSchedList;
    m_ManagerResList : TList;
    m_IsAbort : boolean;
  public
    procedure IniReportTabs;
    procedure RefreshJobColorStatus;
    constructor CreateAutoSchedRptSim(AOwner: Tcomponent; ObjList: TMSchedList; ManagerResList : TList; IsAbort : boolean);
    destructor Destroy; override;

    { Public declarations }
  end;

//var


implementation

{$R *.dfm}

uses UMObjCont, Umcommon, UMSchedContFunc, FMMainPlan, Menus, UMglobal, UMCompat, UMAutoSchedSimulation;

{ TTFAutoSchedRptSimulation }

//----------------------------------------------------------------------------//

procedure TFAutoSchedRptSimulation.BtnCancClick(Sender: TObject);
var
  I : Integer;
begin
  for I := 0 to m_ObjList.GetLinkCount - 1 do
  begin
    p_sc.SetAutoSeqPrevNextIds(m_ObjList.GetLink(I), CSchedIDnull,true);
    p_sc.SetAutoSeqPrevNextIds(m_ObjList.GetLink(I), CSchedIDnull, false);
  end;

  if m_IsAbort then
  begin
    close;
    exit
  end;


  if (MessageDlg(_('All the modificatons of the automatic sequencing will be lost. Do you want to continue?'), mtConfirmation, [mbYes, mbNo], 0)) = mrNo then
    ModalResult := mrNone
  else
    Close;
end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedRptSimulation.BtnOkClick(Sender: TObject);
begin
  RefreshJobColorStatus;
//  Close;
  ModalResult := mrOk;
end;

//----------------------------------------------------------------------------//

constructor TFAutoSchedRptSimulation.CreateAutoSchedRptSim(AOwner: Tcomponent;
  ObjList: TMSchedList; ManagerResList: TList; IsAbort : boolean);
begin
  inherited create(AOwner);
  m_IsAbort := IsAbort;
  if IsAbort then
    BtnOk.enabled := false;

  m_ManagerResList := ManagerResList;
  m_ObjList := ObjList;
  IniReportTabs;

  ReShape(Self);
//  ReShape(btnOk);
//  ReShape(btnCanc);
end;

//----------------------------------------------------------------------------//

destructor TFAutoSchedRptSimulation.Destroy;
begin
  FMQMPlan.RefreshActiveTab;
  inherited destroy;
end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedRptSimulation.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedRptSimulation.IniReportTabs;
var
  I, J : Integer;
  TabSheet : TTabSheet;
//  Splitter : TSplitter;
  TreeView : TTreeView;
//  ListView : TListView;
//  TempCol: TListColumn;
  Score : double;
  Lev0Tn :  TTreeNode;
  TotLines, NumScheduled , NumNotScheduled : integer;
  Elapsedtime : string;
  TolleranceHoursComparison, TotalLateHoursAboveTollenrance,
  TotalHoursForLatestJobAboveTollenrance, TotalLateHoursUpToTollenrance : double;
  TotalLateJobsAboveTollenrance, TotalLateJobsUpToTollenrance : integer;

  TotalSetupHoursStandard, TotalSetupHoursBeforeMaterials, TotalSetupHoursAfterMaterials,
  TotalHoursAboveStandard : double;
  NumberOfJobsWithSetupNoMaterials, NumberOfJobsWithSetupAboveStandard,
//  TotalCaseOfJobToResource : double;
  Percent : double;
begin
  for I := 0 to m_ManagerResList.Count - 1 do
  begin
    TabSheet := TTabSheet.Create(Self);
    TabSheet.PageControl := PageControl1;

    TabSheet.Parent := PageControl1;
    TabSheet.Caption := TResourcesManager(m_ManagerResList[I]).GetCfgName;

    if I = 0 then
      TabSheet.Highlighted := true;

    TreeView := TTreeView.Create(self);
   // TreeView.Align := alLeft;
    TreeView.Align := alClient;
    TreeView.Parent := TabSheet;
    TreeView.Width  := 160;

    TreeView.Items.Clear;

    Score        := Trunc(TResourcesManager(m_ManagerResList[I]).p_TotalScore);
    NumScheduled := TResourcesManager(m_ManagerResList[I]).p_NumOfScheduleJobs;
    NumNotScheduled := TResourcesManager(m_ManagerResList[I]).p_NumOfNotScheduleJobs;
    ElapsedTime     := TResourcesManager(m_ManagerResList[I]).p_ElapsedTime;

    TolleranceHoursComparison              := 0;
    TotalLateHoursAboveTollenrance         := 0;
    TotalHoursForLatestJobAboveTollenrance := 0;
    TotalLateJobsAboveTollenrance          := 0;
    TotalLateHoursUpToTollenrance          := 0;
    TotalLateJobsUpToTollenrance           := 0;

    TotalSetupHoursStandard                := 0;
    TotalSetupHoursBeforeMaterials         := 0;
    TotalSetupHoursAfterMaterials          := 0;
    TotalHoursAboveStandard                := 0;
    NumberOfJobsWithSetupNoMaterials       := 0;
    NumberOfJobsWithSetupAboveStandard     := 0;


    try

    TolleranceHoursComparison              := TResourcesManager(m_ManagerResList[I]).p_TolleranceHoursComparison;
    TotalLateHoursAboveTollenrance         := TResourcesManager(m_ManagerResList[I]).P_TotalLateHoursAboveTollenrance;
    TotalHoursForLatestJobAboveTollenrance := TResourcesManager(m_ManagerResList[I]).P_TotalHoursForLatestJobAboveTollenrance;
    TotalLateJobsAboveTollenrance          := TResourcesManager(m_ManagerResList[I]).P_TotalLateJobsAboveTollenrance;
    TotalLateHoursUpToTollenrance          := TResourcesManager(m_ManagerResList[I]).P_TotalLateHoursUpToTollenrance;
    TotalLateJobsUpToTollenrance           := TResourcesManager(m_ManagerResList[I]).P_TotalLateJobsUpToTollenrance;

    TotalSetupHoursStandard                := TResourcesManager(m_ManagerResList[I]).p_TotalSetupHoursStandard;
    TotalSetupHoursBeforeMaterials         := TResourcesManager(m_ManagerResList[I]).p_TotalSetupHoursBeforeMaterials;
    TotalSetupHoursAfterMaterials          := TResourcesManager(m_ManagerResList[I]).p_TotalSetupHoursAfterMaterials;
    TotalHoursAboveStandard                := TResourcesManager(m_ManagerResList[I]).p_TotalHoursAboveStandard;
    NumberOfJobsWithSetupNoMaterials       := TResourcesManager(m_ManagerResList[I]).p_NumberOfJobsWithSetupNoMaterials;
    NumberOfJobsWithSetupAboveStandard     := TResourcesManager(m_ManagerResList[I]).p_NumberOfJobsWithSetupAboveStandard;
//    TotalCaseOfJobToResource               := TResourcesManager(m_ManagerResList[I]).p_TotalCaseOfJobToResource;
    except
    end;


    TotLines := NumScheduled + NumNotScheduled;

    Lev0Tn := TreeView.Items.Add(nil, _('General information'));

    TreeView.Items.AddChild(Lev0Tn, _('Elapsed time') +
                                      ' : ' +  Elapsedtime );


    TreeView.Items.AddChild(Lev0Tn, _('Total score') +
                                      ' : ' +  FloatToStr(Score)   );

    Lev0Tn := TreeView.Items.Add(nil, _('Scheduled jobs'));

    Percent := 0;
    if NumScheduled > 0 then
       Percent := Trunc(NumScheduled*100/TotLines*100)/100;

    TreeView.Items.AddChild(Lev0Tn, _('On plan') +
                                      ' ' +  FloatToStr(NumScheduled) +
                                      ' (' + FloatToStr(Percent) +
                                       '%)');

    Percent := 0;
    if NumNotScheduled > 0 then
       Percent := Trunc(NumNotScheduled*100/TotLines*100)/100;


    TreeView.Items.AddChild(Lev0Tn, _('Not scheduled') +
                                      ' ' +  FloatToStr(NumNotScheduled) +
                                      ' (' + FloatToStr(Percent) +
                                       '%)');

    Lev0Tn := TreeView.Items.Add(nil, _('Late jobs statistics (Hours used for Tolerance) = ') + ' '  + FormatDuration(TolleranceHoursComparison * 60 ,false));
    TreeView.Items.AddChild(Lev0Tn, _('Total Late Hours Above Tolerance') + ' : ' + FormatDuration(trunc(TotalLateHoursAboveTollenrance) * 60 ,false));
    TreeView.Items.AddChild(Lev0Tn, _('Total Hours For Latest Job Above Tolerance') + ' : ' + FormatDuration(trunc(TotalHoursForLatestJobAboveTollenrance) * 60 ,false));
    TreeView.Items.AddChild(Lev0Tn, _('Total Late Jobs Above Tolerance') + ' : ' + IntToStr(trunc(TotalLateJobsAboveTollenrance)));  //FormatDuration(trunc(TotalLateJobsAboveTollenrance) * 60 ,false));
    TreeView.Items.AddChild(Lev0Tn, _('Total Late Hours Up To Tolerance') + ' : ' + FormatDuration(trunc(TotalLateHoursUpToTollenrance) * 60 ,false));
    TreeView.Items.AddChild(Lev0Tn, _('Total Late Jobs Up To Tolerance') + ' : '  + IntToStr(trunc(TotalLateJobsUpToTollenrance))); // FormatDuration(trunc(TotalLateJobsUpToTollenrance) * 60 ,false));


    Lev0Tn := TreeView.Items.Add(nil, _('Set up statistic '));
    TreeView.Items.AddChild(Lev0Tn, _('Total Set up Hours Standard') + ' : ' + floatToStr(trunc(TotalSetupHoursStandard)));
    TreeView.Items.AddChild(Lev0Tn, _('Total Set up Hours Before Materials') + ' : ' + floatToStr(trunc(TotalSetupHoursBeforeMaterials)));
    TreeView.Items.AddChild(Lev0Tn, _('Total Set up Hours After Materials') + ' : ' + floatToStr(trunc(TotalSetupHoursAfterMaterials)));
    TreeView.Items.AddChild(Lev0Tn, _('Total Hours Above Standard') + ' : ' + floatToStr(trunc(TotalHoursAboveStandard)));
    TreeView.Items.AddChild(Lev0Tn, _('Number Of Jobs With Set up No Materials') + ' : ' + IntToStr(trunc(NumberOfJobsWithSetupNoMaterials)));
    TreeView.Items.AddChild(Lev0Tn, _('Number Of Jobs With Set up Above Standard') + ' : ' + IntToStr(trunc(NumberOfJobsWithSetupAboveStandard)));

    Lev0Tn := TreeView.Items.Add(nil, _('Number of jobs in each job to job compatibility case'));

    for J := Low(TResourcesManager(m_ManagerResList[I]).p_arrayJobToJobCase) to High(TResourcesManager(m_ManagerResList[I]).p_arrayJobToJobCase) do
    begin
      if TResourcesManager(m_ManagerResList[I]).p_arrayJobToJobCase[J] > 0 then
         TreeView.Items.AddChild(Lev0Tn, _('case') + ' ' + IntToStr(J) + ' : ' + IntToStr(TResourcesManager(m_ManagerResList[I]).p_arrayJobToJobCase[J]) + ' ' + _('jobs'));
    end;

    Lev0Tn := TreeView.Items.Add(nil, _('Number of jobs in each job to resource compatibility case'));

    for J := Low(TResourcesManager(m_ManagerResList[I]).p_arrayJobToResCase) to High(TResourcesManager(m_ManagerResList[I]).p_arrayJobToResCase) do
    begin
      if TResourcesManager(m_ManagerResList[I]).p_arrayJobToResCase[J] > 0 then
         TreeView.Items.AddChild(Lev0Tn, _('case') + ' ' + IntToStr(J) + ' : ' + IntToStr(TResourcesManager(m_ManagerResList[I]).p_arrayJobToResCase[J]) + ' ' + _('jobs'));
    end;

    Lev0Tn := TreeView.Items.Add(nil, _('Number of jobs scheduled after their latest end'));

    for J := Low(TResourcesManager(m_ManagerResList[I]).p_ArrayDaysOfLatedJobs) to High(TResourcesManager(m_ManagerResList[I]).p_ArrayDaysOfLatedJobs) do
    begin
      if TResourcesManager(m_ManagerResList[I]).p_ArrayDaysOfLatedJobs[J] > 0 then
      begin
        if J = Low(TResourcesManager(m_ManagerResList[I]).p_ArrayDaysOfLatedJobs) then
          TreeView.Items.AddChild(Lev0Tn, _('Up to') + ' ' + IntToStr(J) + ' ' + _('day') + ' : ' + IntToStr(TResourcesManager(m_ManagerResList[I]).p_ArrayDaysOfLatedJobs[J]) + ' ' + _('jobs') + '.')
        else if J = High(TResourcesManager(m_ManagerResList[I]).p_ArrayDaysOfLatedJobs) then
          TreeView.Items.AddChild(Lev0Tn, _('Over') + ' ' + IntToStr(J - 1) + ' ' + _('days') + ' : ' + IntToStr(TResourcesManager(m_ManagerResList[I]).p_ArrayDaysOfLatedJobs[J]) + ' ' + _('jobs') + '.')
        else if J <= High(TResourcesManager(m_ManagerResList[I]).p_ArrayDaysOfLatedJobs) - 1 then
          TreeView.Items.AddChild(Lev0Tn, _('Up to') + ' ' + IntToStr(J) + ' ' + _('days') + ' ' + IntToStr(TResourcesManager(m_ManagerResList[I]).GetDaysOfLatedJobsCumulativeTillSpecificDay(J)) + ' ' + _('jobs') + ' ' +
                             '(' + _('between') + ' ' + IntToStr(J - 1) + ' and ' + IntToStr(J) + ' ' + ' : ' + IntToStr(TResourcesManager(m_ManagerResList[I]).p_ArrayDaysOfLatedJobs[J]) + ' ' + _('jobs') + ').');
      end;
    end;

   { Splitter := TSplitter.Create(Self);
    Splitter.Parent := TabSheet;
    Splitter.Width := 3;
    Splitter.Left  := TreeView.Width + 3;
    Splitter.Align := alLeft;
    Splitter.ResizeStyle := rsPattern;
    Splitter.top := 0;

    ListView := TListView.Create(self);
    ListView.Align := alClient;
    ListView.Parent := TabSheet;
    ListView.Columns.Clear;
    ListView.GridLines := true;
    ListView.ViewStyle := vsReport;

    TempCol := ListView.Columns.Add;
    TempCol.Caption := _('Scheduled object');
    TempCol.Width := 150;

    TempCol := ListView.Columns.Add;
    TempCol.Caption := _('Planned start date');
    TempCol.Width := 150;

    TempCol := ListView.Columns.Add;
    TempCol.Caption := _('Planned end date');
    TempCol.Width := 150;     }

  end;



end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedRptSimulation.RefreshJobColorStatus;
var
  MQMPlan : TFMQMPlan;
  NewItem : TMenuItem;
begin
  MQMPlan := GetPlanView;

  if DBAppGlobals.ShowColorJobMode = DinamicPropList then
  begin
    if (GetIdFromCode(DBAppGlobals.LastPropColorInUseJobMode) <> nil) and Assigned(MQMPlan) then
    begin
      NewItem := TMenuItem.Create(Self);
      NewItem.VCLComObject := GetIdFromCode(DBAppGlobals.LastPropColorInUseJobMode);
      MQMPlan.ClickShowBarColorDynamic(NewItem);
    end
  end;
end;

end.
