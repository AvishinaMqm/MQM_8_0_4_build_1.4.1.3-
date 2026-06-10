unit FMOORulesCase;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, UMRulesComp,
  UMSchedContFunc,
  UMRes, ComCtrls,
  gnugettext, StdCtrls, ExtCtrls, UReSHape;

type

  TFOORulesCase = class(TForm)
    PageControl1: TPageControl;
    TbsBefore: TTabSheet;
    TbsAfter: TTabSheet;
    Panel1: TPanel;
    LlbClacSetupTime: TLabel;
    StCalcsetupTime: TStaticText;
    constructor CreateFrmRulesCase(AOwner: TComponent);
    procedure   FormClose(Sender: TObject; var Action: TCloseAction);
    procedure   SetObjectsOtO(id, precId: TSchedId);
    procedure FormCreate(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure calculated_setup_time;
  private
    m_RulesCompBef: TMRulesComp;
    m_RulesCompAft: TMRulesComp;
    m_id:           TSchedId;
    m_precId:       TSchedId;
  end;

  procedure OpenFrmOtORulesCase(AOwner: TComponent; id, precId: TSchedId);

var
  FOORulesCase: TFOORulesCase;

implementation

uses
  UMObjCont,
  UMActArea,
  UMSchedCont,
  UMCommon,
  UGBaseCal,
  UMCompat,
  UMSchedObjMover,
  UGGlobal;

{$R *.DFM}

//----------------------------------------------------------------------------//

procedure OpenFrmOtORulesCase(AOwner: TComponent; id, precId: TSchedId);
var
  res: TMqmRes;
begin
  res := TMqmRes(TMqmActArea(p_sc.getExtLinkPtr(precId)).p_res);
  if (id = precId) or not (Res.p_occCanAttach) then
    exit;
  FOORulesCase := TFOORulesCase.CreateFrmRulesCase(AOWner);
  FOORulesCase.SetObjectsOtO(id, precId);
  FOORulesCase.ShowModal;
end;

//----------------------------------------------------------------------------//

constructor TFOORulesCase.CreateFrmRulesCase(AOwner: TComponent);
begin
  inherited Create(AOwner);
  m_RulesCompBef := TMRulesComp.CreateRulesComp(TbsBefore);
  m_RulesCompAft := TMRulesComp.CreateRulesComp(TbsAfter);
  PageControl1.ActivePage := TbsAfter
end;

//----------------------------------------------------------------------------//

procedure TFOORulesCase.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  FOORulesCase := nil
end;

//----------------------------------------------------------------------------//

procedure TFOORulesCase.SetObjectsOtO(id, precId: TSchedId);
var
  lstBef, lstAft: TList;
  isGroup: boolean;
  res: TMqmRes;
begin
  lstBef := TList.Create;
  lstAft := TList.Create;
  width := 1100;//920;
  Caption := _('Compatibility check results for ') + p_sc.GetObjInfo(precId, isGroup);
  res := TMqmRes(TMqmActArea(p_sc.getExtLinkPtr(precId)).p_res);
  m_id := id;
  m_precId := precId;

  calculated_setup_time;

  p_pl.SetTmgTargetRes(res);
  res.ReportSetupParms(precId, id, lstBef, true);
  m_RulesCompBef.UpdateOOData(lstBef, true);

  res.ReportSetupParms(id, precId, lstAft, false);
  m_RulesCompAft.UpdateOOData(lstAft, false);

  if lstBef.Count > lstAft.Count then
    height := (lstBef.Count+1) * 20 + 135//105
  else
    height := (lstAft.Count+1) * 20 + 135;//105;

  lstBef.Free;
  lstAft.Free
end;

//----------------------------------------------------------------------------//
procedure TFOORulesCase.FormCreate(Sender: TObject);
begin
  ScaleFormSize(Self, Screen.PixelsPerInch);
  TranslateComponent (self);

  ReShape(self);
end;

//----------------------------------------------------------------------------//
procedure TFOORulesCase.calculated_setup_time();
var
  actarea: TMqmActArea;
  res: TMqmRes;
  planInfo: TSQplanInfo;
  cal:      TPGCALObj;
  PreviousObj : TSchedId;
  supMinBase, duration:   double;
  TmgDescr: string;
  TmgMSC: string;
  setup, Overlap: double;
  beforeSetup: double;
  Dummy1, LearningCurveCode : string;
  Dummy2, Dummy3 : double;
begin
    //id = our current job we want to schedule
    //precid = the job on which we had right clicked on the plan
    //PreviousObj  = the job before the job we right clicked on
    res := TMqmRes(TMqmActArea(p_sc.getExtLinkPtr(m_precId)).p_res);
    actarea := TMqmActArea(p_sc.getExtLinkPtr(m_precId));
    cal := actArea.GetCalendar;
    Assert(Assigned(cal));
    duration := 0;
    p_sc.GetPlanInfo(m_precid , planInfo);
//    PreviousObj := actarea.GetPrecObj(planinfo.startDate,PreviousObj);
    PreviousObj := actarea.GetPrecObj(planinfo.startDate, -1);
    p_pl.SetTmgTargetRes(res);
    p_pl.GetMainTimings(supMinBase, duration, TmgDescr, TmgMSC);

    if (not CalcSetup(m_id,m_precid, actArea, supMinBase, setup, Overlap, Dummy1, Dummy2, Dummy3, LearningCurveCode)) then
      exit;

    if (not CalcSetup(m_id, PreviousObj, actArea, supMinBase, beforeSetup, Overlap, Dummy1, Dummy2, Dummy3, LearningCurveCode)) then
     exit;

    if PageControl1.ActivePageIndex = 0 then
      StCalcsetupTime.Caption := FormatDuration(beforeSetup, true)
    else
      StCalcsetupTime.Caption := FormatDuration(setup, true);
   end;

//----------------------------------------------------------------------------//
procedure TFOORulesCase.PageControl1Change(Sender: TObject);
begin
  calculated_setup_time;
end;

end.
