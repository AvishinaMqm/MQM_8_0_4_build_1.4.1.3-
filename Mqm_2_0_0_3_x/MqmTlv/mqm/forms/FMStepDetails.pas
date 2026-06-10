unit FMStepDetails;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, ComCtrls, StdCtrls, Buttons, ExtCtrls,
  UMSchedContFunc,
  UMTblDesc,DMsrvPc,Math ,
  UMUsrPropComp, UMIssuedArt, UMArticles,
  UMSchedOnPlan, 
  gnugettext, UReShape;

type

  RelationShip = (RS_PrevReq, RS_Current, RS_CurrentFirstLast, RS_CurrentFirst , RS_CurrentLast , RS_NextReq);

  TFStepDetails = class(TForm)
    Panel1: TPanel;
    LblProdReq: TLabel;
    LblStepnum: TLabel;
    StProdReq: TStaticText;
    StStepNum: TStaticText;
    PGStepDetails: TPageControl;
    TBHeader: TTabSheet;
    LblDelDate: TLabel;
    LblProdType: TLabel;
    LblUmdesc: TLabel;
    STDeldate: TStaticText;
    STProdType: TStaticText;
    STUmDesc: TStaticText;
    TbGenInfo: TTabSheet;
    TBProductsInfo: TTabSheet;
    TBmaterials: TTabSheet;
    TBInstructionInfo: TTabSheet;
    LblSubStep: TLabel;
    STSubStep: TStaticText;
    LblRePro: TLabel;
    STRePro: TStaticText;
    LblProductFam: TLabel;
    STProdFamily: TStaticText;
    LblMaterialsFam: TLabel;
    STMaterialsFam: TStaticText;
    LblLowestDate: TLabel;
    STLowestDate: TStaticText;
    LblProdLine: TLabel;
    STProdLine: TStaticText;
    TbCommentsInfo: TTabSheet;
    TbOthersInfo: TTabSheet;
    TbConnectedReq: TTabSheet;
    TbSchedDetails: TTabSheet;
    LblGroupNumber: TLabel;
    LlbScheduleType: TLabel;
    LblWorkStation: TLabel;
    LblWorkCenterDesc: TLabel;
    LblWCProcessDesc: TLabel;
    LblResDesc: TLabel;
    LblResSubLine: TLabel;
    LblResComp: TLabel;
    LblSetupTime: TLabel;
    LblQuantity: TLabel;
    LblExecTime: TLabel;
    LblSchedStart: TLabel;
    LblSchedEnd: TLabel;
    LblProgStart: TLabel;
    LblProgEnd: TLabel;
    LblQuantityProg: TLabel;
    LabelActualTime: TLabel;
    LblComment: TLabel;
    LblPrevConnSubStep: TLabel;
    LblPrevConnReProcess: TLabel;
    LblErrorInfo: TLabel;
    STGroupNumber: TStaticText;
    STScheduleType: TStaticText;
    STWorkStation: TStaticText;
    STWorkCenter: TStaticText;
    STWCProcess: TStaticText;
    STRes: TStaticText;
    STResSubLine: TStaticText;
    STResComp: TStaticText;
    STQuantity: TStaticText;
    STSetupTime: TStaticText;
    STExecTime: TStaticText;
    STSchedStart: TStaticText;
    STSchedEnd: TStaticText;
    STProgStart: TStaticText;
    STProgEnd: TStaticText;
    STQuantityProg: TStaticText;
    STActualTime: TStaticText;
    STComment: TStaticText;
    STPrevConnSubStep: TStaticText;
    STPrevConnReProcess: TStaticText;
    TbStepDetails: TTabSheet;
    LblPlannedWorkStation: TLabel;
    LblStepType: TLabel;
    LblMaterialsArrivalDate: TLabel;
    LblPlannedStartingDate: TLabel;
    LblLowestStartingDatePoss: TLabel;
    LblLowestSchedStartingDate: TLabel;
    LblPlannedEndingDate: TLabel;
    LblHighestEndingDatePos: TLabel;
    LblHighestSchedEndingDate: TLabel;
    LblPlannedWorkCenter: TLabel;
    LblPlannedWCProcess: TLabel;
    LblInitialQuantity: TLabel;
    LblFinalQuantity: TLabel;
    LblWeight: TLabel;
    LblWeighUMDescription: TLabel;
    LblScheduledQuantity: TLabel;
    LblCalCode: TLabel;
    LblTotalPlannedSetupTime: TLabel;
    LblTotalPlannedExecTime: TLabel;
    LblPlannedNumberOfRes: TLabel;
    LblRuleToConnectToPrevJob: TLabel;
    LblProgressedCalculated: TLabel;
    LblClosed: TLabel;
    STPlannedWorkStation: TStaticText;
    STStepType: TStaticText;
    STMaterialsArrivalDate: TStaticText;
    STPlannedStartingDate: TStaticText;
    STLowestStartingDatePos: TStaticText;
    STLowestSchedStartingDate: TStaticText;
    STPlannedEndingDate: TStaticText;
    STHighestEndingDatePos: TStaticText;
    STHighestSchedEndingDate: TStaticText;
    STPlannedWorkCenter: TStaticText;
    STPlannedWCProcess: TStaticText;
    STInitialQuantity: TStaticText;
    STFinalQuantity: TStaticText;
    STWeight: TStaticText;
    STWeighUMDescription: TStaticText;
    STScheduledQuantity: TStaticText;
    STCalCode: TStaticText;
    STTotalPlannedSetupTime: TStaticText;
    STTotalPlannedExecTime: TStaticText;
    STPlannedNumberOfRes: TStaticText;
    STRuleToConnectToPrevJob: TStaticText;
    STProgressedCalculated: TStaticText;
    STClosed: TStaticText;
    TbStepProperties: TTabSheet;
    TBRelatedOrders: TTabSheet;
    SGRelatedOrders: TStringGrid;
    StringGridGen: TStringGrid;
    StringGridInstr: TStringGrid;
    StringGridComment: TStringGrid;
    StringGridOther: TStringGrid;
    Tb: TTabSheet;
    SGStepsView: TStringGrid;
    TabSheet1: TTabSheet;
    SGJobsView: TStringGrid;
    SGConnectedReq: TStringGrid;
    LblSetupTimeWithOutMaterials: TLabel;
    STSetupTimeWithoutMaterials: TStaticText;
    GBTimeBar: TGroupBox;
    ShapeSetupTimeWOMaterials: TShape;
    ShapeSetupTime: TShape;
    ShapeExecTime: TShape;
    StringGridMat: TStringGrid;
    StringGridProd: TStringGrid;
    MemErrors: TMemo;
    LabelActualStart: TLabel;
    STActualStart: TStaticText;
    LabelActualEnd: TLabel;
    STActualEnd: TStaticText;
    LabelAlloedsplit: TLabel;
    STAlloweSplit: TStaticText;
    STLearningCurveCode: TStaticText;
    LblLearningCurveCode: TLabel;
    LblApprovalDate: TLabel;
    STApprovaldate: TStaticText;
    LblGenericPlan: TLabel;
    STGenericPlan: TStaticText;
    LblOriginalHighestEndingDatePos: TLabel;
    STOriginalHighestEndingDatePos: TStaticText;
    CurveFamily: TLabel;
    STLearningCurveFamily: TStaticText;
    LabelLblProgressedHost: TLabel;
    STProgressedHost: TStaticText;
    LabelOverriddenSpeedPerUm: TLabel;
    STOverriddenSpeedPerUm: TStaticText;
    LblOveriddenSetup: TLabel;
    StaticTexOverriddenSetup: TStaticText;

    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StringGridProdDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure StringGridGenDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure StringGridMatDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure StringGridInstrDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure StringGridCommentDrawCell(Sender: TObject; ACol,
      ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure StringGridOtherDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure StringGridOtherSelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure PGStepDetailsDrawTab(Control: TCustomTabControl;
      TabIndex: Integer; const Rect: TRect; Active: Boolean);
  private
    m_Id : TSchedId;
    m_propComp: TMShowPropList;
    m_SpaceGen : integer;
    m_SpaceProd : Integer;
    m_SpaceMat : Integer;
    m_SpaceInst : Integer;
    m_SpaceComent : Integer;
    m_SpaceOther : Integer;
    m_NewSpeed   : double;
    procedure InitWidth_Lbl;
    procedure JobDetails;
    procedure InitCaptions;
    procedure DisplayGeneralInfo;
    procedure DisplayHeader;
    procedure DisplayInfoArea;
    procedure DisplaySchedDetails;
    procedure DisplayStepDetails;
    procedure DisplayStepsView;
    procedure DisplayJobsView;
    procedure DisplayConnectedReq;
    procedure DisplayRelatedOrders;
    function  GetProcessSDesc(wc: string; Process: string) : string;
    procedure GetSpProgressTypes(ProdReq: string; StepId: integer;
                                 var ProgStart: double; var ProgGen: double;
                                 var ProgFinal: double; var ProgFinalSplit: double);
    function  AddConnectedReq(AddRowCount: boolean; TypeReq: RelationShip; ProdReq: string): boolean;
    procedure SetDefaultStringGridColors;
    procedure FillDataConnectedReq(ProdReq: string; StepId : Integer; TypeReq: RelationShip; WorCnterCode, StepClosed : string;
                                   QuantInit, NumResPlan : double; PlanStart, PlanEnd : TDateTime);
    procedure DisplayMaterialInfoArea;
    procedure DisplayProductInfoArea;
  public
   constructor CreateStepDetails(AOwner: TComponent; Id: TSchedId);
  end;

implementation

{$R *.DFM}

uses
  UMSchedCont,
  UMObjCont,
  UGglobal,
  UMRes,
  UMWkCtr,
  UMActArea,
  UMCompatSrv,
  UMGlobal,
  UMArticle,
  UMProdInfo,
  UMDescUm,
  UMCommon,
  FMProdImage,
  UMCompat,
  UMBalance,
  UMProdArt,
  Data.DB,
  FMRequirements,
  UMPlanGraph, FMMainPlan;

//----------------------------------------------------------------------------//

Resourcestring
  NOT_EXIST = '--------------';
  PROG_STARTING = 'Starting';
  PROG_GENERAL = 'General';
  PROG_FINAL = 'Final';
  PROG_FINAL_SPLIT = 'Final and Split';

//----------------------------------------------------------------------------//

constructor TFStepDetails.CreateStepDetails(AOwner: TComponent; Id: TSchedId);
var
  prop: TProperties;
  qry:    TMqmQuery;
begin
  inherited Create(AOwner);

//  Height := 506;
//  Width := 687;

  m_Id := Id;
  m_NewSpeed := 0;
  prop := p_sc.GetProperties(m_Id, nil);

  m_propComp := TMShowPropList.CreateShowPropList(TbStepProperties, prop, m_Id, true);

  qry := CreateQuery(Main_DB);
  p_sc.LoadChain(qry, p_sc.GetFldDescr(m_id, CSC_ProdReq, false));

  qry.Close;      //Vinc
  qry.Free;

end;

//----------------------------------------------------------------------------//

procedure TFStepDetails.InitWidth_Lbl;
begin
  LblDelDate.Width      := 95;
  LblProdType.Width     := 95;
  LblUmdesc.Width       := 95;
  LblProductFam.Width   := 95;
  LblMaterialsFam.Width := 95;
  LblLowestDate.Width   := 95;
  LblProdLine.Width     := 95;
  LblPlannedWorkStation.Width      := 160;
  LblStepType.Width                := 160;
  LblMaterialsArrivalDate.Width    := 160;
  LblPlannedStartingDate.Width     := 160;
  LblLowestStartingDatePoss.Width  := 160;
  LblLowestSchedStartingDate.Width := 160;
  LblPlannedEndingDate.Width       := 160;
  LblHighestEndingDatePos.Width    := 160;
  LblHighestSchedEndingDate.Width  := 160;
  LblPlannedWorkCenter.Width       := 160;
  LblPlannedWCProcess.Width        := 160;
  LblInitialQuantity.Width         := 160;
  LblScheduledQuantity.Width       := 160;
  LblClosed.Width                  := 165;
  LblWeight.Width                  := 165;
  LblWeighUMDescription.Width      := 165;
  LblCalCode.Width                 := 165;
  LblTotalPlannedSetupTime.Width   := 165;
  LblTotalPlannedExecTime.Width    := 165;
  LblPlannedNumberOfRes.Width      := 165;
  LblRuleToConnectToPrevJob.Width  := 165;
  LblProgressedCalculated.Width    := 165;
  LabelLblProgressedHost.Width     := 165;
  LabelAlloedsplit.Width           := 165;
  LblFinalQuantity.Width           := 165;
  LblSchedStart.Width              := 150;
  LblSchedEnd.Width                := 150;
  LlbScheduleType.Width            := 150;
  LblWCProcessDesc.Width           := 150;
  LblResDesc.Width                 := 150;
  LblResSubLine.Width              := 150;
  LblPrevConnSubStep.Width         := 150;
  LblQuantity.Width                := 150;
  LblSetupTime.Width               := 150;
  LblExecTime.Width                := 150;
  LblProgStart.Width               := 150;
  LblComment.Width                 := 150;
  LblErrorInfo.Width               := 150;
  LblWorkStation.Width               := 165;
  LblWorkCenterDesc.Width            := 165;
  LblGroupNumber.Width               := 165;
  LblLearningCurveCode.Width         := 165;
  LblResComp.Width                   := 165;
  LblPrevConnReProcess.Width         := 165;
  LblQuantityProg.Width              := 165;
  LblSetupTimeWithOutMaterials.Width := 165;
  LblProgEnd.Width                   := 165;
end;

//----------------------------------------------------------------------------//

procedure TFStepDetails.JobDetails;
var
  Save_Cursor : TCursor;
begin
  Save_Cursor := Screen.Cursor;
  Screen.Cursor  := crAppStart;
  InitCaptions;
  DisplayGeneralInfo;
  DisplayHeader;
  DisplayInfoArea;
  DisplayStepDetails;
  DisplayStepsView;
  DisplayJobsView;
  DisplaySchedDetails;
  DisplayConnectedReq;
  DisplayRelatedOrders;
  Screen.Cursor := Save_Cursor;
  PGStepDetails.ActivePage := TBHeader ;
end;

procedure TFStepDetails.PGStepDetailsDrawTab(Control: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
begin
  {with Control.Canvas do begin
    Brush.Color := clWhite;
    FillRect(Rect);
    TextOut(Rect.Left + Font.Size -5, Rect.Top + 2, (Control as TPageControl).Pages[TabIndex].Caption) ;
  end; }
end;

//----------------------------------------------------------------------------//

procedure TFStepDetails.InitCaptions;
begin
  SetComponent(LblProdReq, comp_Label, false);
  SetComponent(LblStepnum, comp_Label, false);
  SetComponent(LblSubStep, comp_Label, false);
  SetComponent(LblRePro, comp_Label, false);
  SetComponent(StProdReq, comp_Descr, false);
  SetComponent(StStepNum, comp_Descr, false);
  SetComponent(STSubStep, comp_Descr, false);
  SetComponent(STRePro, comp_Descr, false);

  SetComponent(LblDelDate, comp_Label, false);
  SetComponent(LblProdType, comp_Label, false);
  SetComponent(LblUmdesc, comp_Label, false);
  SetComponent(LblProductFam, comp_Label, false);
  SetComponent(LblMaterialsFam, comp_Label, false);
  SetComponent(LblLowestDate, comp_Label, false);
  SetComponent(LblProdLine, comp_Label, false);
  SetComponent(STDeldate, comp_Descr, false);
  SetComponent(STProdType, comp_Descr, false);
  SetComponent(STUmDesc, comp_Descr, false);
  SetComponent(STProdFamily, comp_Descr, false);
  SetComponent(STMaterialsFam, comp_Descr, false);
  SetComponent(STLowestDate, comp_Descr, false);
  SetComponent(STProdLine, comp_Descr, false);

  SetComponent(LblSchedStart, comp_Label, false);
  SetComponent(LblSchedEnd, comp_Label, false);
  SetComponent(LlbScheduleType, comp_Label, false);
  SetComponent(LblWCProcessDesc, comp_Label, false);
  SetComponent(LblResDesc, comp_Label, false);
  SetComponent(LblResSubLine, comp_Label, false);
  SetComponent(LblPrevConnSubStep, comp_Label, false);
  SetComponent(LblQuantity, comp_Label, false);
  SetComponent(LblSetupTime, comp_Label, false);
  SetComponent(LblSetupTimeWithoutMaterials, comp_Label, false);
  SetComponent(LblExecTime, comp_Label, false);
  SetComponent(LblErrorInfo, comp_Label, false);
  SetComponent(LblProgStart, comp_Label, false);
  SetComponent(LblComment, comp_Label, false);
  SetComponent(LblWorkStation, comp_Label, false);
  SetComponent(LblWorkCenterDesc, comp_Label, false);
  SetComponent(LblGroupNumber, comp_Label, false);
  SetComponent(LblLearningCurveCode, comp_Label, false);
  SetComponent(LblResComp, comp_Label, false);
  SetComponent(LblPrevConnReProcess, comp_Label, false);
  SetComponent(LblQuantityProg, comp_Label, false);
  SetComponent(LblProgEnd, comp_Label, false);
  SetComponent(STSchedStart, comp_Descr, false);
  SetComponent(STSchedEnd, comp_Descr, false);
  SetComponent(STScheduleType, comp_Descr, false);
  SetComponent(STWCProcess, comp_Descr, false);
  SetComponent(STRes, comp_Descr, false);
  SetComponent(STResSubLine, comp_Descr, false);
  SetComponent(STPrevConnSubStep, comp_Descr, false);
  SetComponent(STQuantity, comp_Descr, false);
  SetComponent(STSetupTime, comp_Descr, false);
  SetComponent(STSetupTimeWithoutMaterials, comp_Descr, false);
  SetComponent(STExecTime, comp_Descr, false);
  SetComponent(STActualTime, comp_Descr, false);
  SetComponent(STActualStart, comp_Descr, false);
  SetComponent(STActualEnd, comp_Descr, false);
//  SetComponent(STErrorInfo, comp_Descr, false);
  SetComponent(MemErrors, comp_descr, false);
  SetComponent(STProgStart, comp_Descr, false);
  SetComponent(STProgEnd, comp_Descr, false);
  SetComponent(STComment, comp_Descr, false);
  SetComponent(STWorkStation, comp_Descr, false);
  SetComponent(STWorkCenter, comp_Descr, false);
  SetComponent(STGroupNumber, comp_Descr, false);
  SetComponent(STLearningCurveCode, comp_Descr, false);
  SetComponent(STLearningCurveFamily, comp_Descr, false);
  SetComponent(STResComp, comp_Descr, false);
  SetComponent(STPrevConnReProcess, comp_Descr, false);
  SetComponent(STQuantityProg, comp_Descr, false);

  SetComponent(LblPlannedWorkStation, comp_Label, false);
  SetComponent(LblStepType, comp_Label, false);
  SetComponent(LblMaterialsArrivalDate, comp_Label, false);
  SetComponent(LblPlannedStartingDate, comp_Label, false);
  SetComponent(LblLowestStartingDatePoss, comp_Label, false);
  SetComponent(LblLowestSchedStartingDate, comp_Label, false);
  SetComponent(LblPlannedEndingDate, comp_Label, false);
  SetComponent(LblHighestEndingDatePos, comp_Label, false);
  SetComponent(LblHighestSchedEndingDate, comp_Label, false);
  SetComponent(LblPlannedWorkCenter, comp_Label, false);
  SetComponent(LblPlannedWCProcess, comp_Label, false);
  SetComponent(LblInitialQuantity, comp_Label, false);
  SetComponent(LblScheduledQuantity, comp_Label, false);
  SetComponent(LblClosed, comp_Label, false);
  SetComponent(LblWeight, comp_Label, false);
  SetComponent(LblWeighUMDescription, comp_Label, false);
  SetComponent(LblCalCode, comp_Label, false);
  SetComponent(LblTotalPlannedSetupTime, comp_Label, false);
  SetComponent(LblTotalPlannedExecTime, comp_Label, false);
  SetComponent(LblPlannedNumberOfRes, comp_Label, false);
  SetComponent(LblRuleToConnectToPrevJob, comp_Label, false);
  SetComponent(LblProgressedCalculated, comp_Label, false);
  SetComponent(LabelLblProgressedHost, comp_Label, false);
  SetComponent(LabelAlloedsplit, comp_Label, false);
  SetComponent(LblFinalQuantity, comp_Label, false);
  SetComponent(STPlannedWorkStation, comp_Descr, false);
  SetComponent(STStepType, comp_Descr, false);
  SetComponent(STApprovaldate, comp_Descr, false);
  SetComponent(STMaterialsArrivalDate, comp_Descr, false);
  SetComponent(STPlannedStartingDate, comp_Descr, false);
  SetComponent(STLowestStartingDatePos, comp_Descr, false);
  SetComponent(STLowestSchedStartingDate, comp_Descr, false);
  SetComponent(STPlannedEndingDate, comp_Descr, false);
  SetComponent(STHighestEndingDatePos, comp_Descr, false);
  SetComponent(STOriginalHighestEndingDatePos, comp_Descr, false);
  SetComponent(STHighestSchedEndingDate, comp_Descr, false);
  SetComponent(STPlannedWorkCenter, comp_Descr, false);
  SetComponent(STPlannedWCProcess, comp_Descr, false);
  SetComponent(STInitialQuantity, comp_Descr, false);
  SetComponent(STScheduledQuantity, comp_Descr, false);
  SetComponent(STClosed, comp_Descr, false);
  SetComponent(STWeight, comp_Descr, false);
  SetComponent(STWeighUMDescription, comp_Descr, false);
  SetComponent(STCalCode, comp_Descr, false);
  SetComponent(STTotalPlannedSetupTime, comp_Descr, false);
  SetComponent(STTotalPlannedExecTime, comp_Descr, false);
  SetComponent(STPlannedNumberOfRes, comp_Descr, false);
  SetComponent(STRuleToConnectToPrevJob, comp_Descr, false);
  SetComponent(STProgressedCalculated, comp_Descr, false);
  SetComponent(STProgressedHost, comp_Descr, false);
  SetComponent(STAlloweSplit, comp_Descr, false);
  SetComponent(STGenericPlan, comp_Descr, false);
  SetComponent(STFinalQuantity, comp_Descr, false);
  SetComponent(STOverriddenSpeedPerUm, comp_Descr, false);
  SetComponent(StaticTexOverriddenSetup, comp_Descr, false);

  with SGRelatedOrders do
  begin
    Cells[0,0] := '  ' + _('Connection type');
    Cells[1,0] := '  ' + _('Due date');
    Cells[2,0] := '  ' + _('Number of levels');
    Cells[3,0] := '  ' + _('Connection certainty');
    Cells[4,0] := '  ' + _('Entity');
  end;

  with SGStepsView do
  begin
    Cells[0,0] := ('  ') + _('Step number');
    Cells[1,0] := ('  ') + _('Planned work station');
    Cells[2,0] := ('  ') + _('Planned w.c');
    Cells[3,0] := ('  ') + _('Closed');
    Cells[4,0] := ('  ') + _('Initial qty');
    Cells[5,0] := ('  ') + _('Scheduled qty');
    Cells[6,0] := ('  ') + _('Planned start date');
    Cells[7,0] := ('  ') + _('Lowest scheduled start');
    Cells[8,0] := ('  ') + _('Planned end date');
    Cells[9,0] := ('  ') + _('Latest scheduled end');
    Cells[10,0] := (' ') + _('Planned no. of resources');
    Cells[11,0] := (' ') + _('Progress start');
    Cells[12,0] := (' ') + _('Progress general');
    Cells[13,0] := (' ') + _('Progress final');
    Cells[14,0] := (' ') + _('Progress final & split');
    Cells[15,0] := (' ') + _('Priority');
  end;

  with SGJobsView do
  begin
    Cells[0,0] := ('  ') + _('Step number');
    Cells[1,0] := ('  ') + _('Sub step no');
    Cells[2,0] := ('  ') + _('Re.process. no ');
    Cells[3,0] := ('  ') + _('Group no   ');
    Cells[4,0] := ('  ') + _('Sched. work station');
    Cells[5,0] := ('  ') + _('Planned w.c');
    Cells[6,0] := ('  ') + _('Resource code');
    Cells[7,0] := ('  ') + _('Progressed status');
    Cells[8,0] := ('  ') + _('Sched./Progress start');
    Cells[9,0] := ('  ') + _('Sched./Progress end');
    Cells[10,0] := ('  ') + _('Qty to sched');
    Cells[11,0] := ('  ') + _('Sched. setup time');
    Cells[12,0] := ('  ') + _('Sched. exc time');
    Cells[13,0] := ('  ') + _('Priority');
  end;

  with SGConnectedReq do
  begin
    Cells[0,0] := ('  ') + _('Production request');
    Cells[1,0] := ('  ') + _('Relationship');
    Cells[2,0] := ('  ') + _('Planned work station');
    Cells[3,0] := ('  ') + _('Planned w.c');
    Cells[4,0] := ('  ') + _('Closed');
    Cells[5,0] := ('  ') + _('Initial qty');
    Cells[6,0] := ('  ') + _('Scheduled qty');
    Cells[7,0] := ('  ') + _('Planned start date');
    Cells[8,0] := ('  ') + _('Earliest scheduled start');
    Cells[9,0] := ('  ') + _('Planned end date');
    Cells[10,0] := ('  ') + _('Latest scheduled end');
    Cells[11,0] := ('  ') + _('Planned no. of resources');
    Cells[12,0] := (' ') + _('Progress start');
    Cells[13,0] := (' ') + _('Progress general');
    Cells[14,0] := (' ') + _('Progress final');
    Cells[15,0] := (' ') + _('Progress final & split');

  with StringGridMat do
  begin
    Cells[0,0] := _('Bal. type');
    Cells[1,0] := _('Netting');//Group Code');

    // colwidths[0] := 2;
    Cells[2,0] := _('Prod type');
    Cells[3,0] := _('Prod code');
    Cells[4,0] := _('Required qty');
    Cells[5,0] := _('Status');
    Cells[6,0] := _('Mat. avail.');
    Cells[7,0] := _('Issued qty');
    Cells[8,0] := _('Allocated qty');
    Cells[9,0] := _('Issue code');
    Cells[10,0] := _('Original step');
    Cells[11,0] := _('Work center');
    Cells[12,0] := _('Wkc process');
    Cells[13,0] := _('Res cat code');
    Cells[14,0] := _('Res code');
    Cells[15,0] := _('Mach setup code');
    Cells[16,0] := _('Search material alloc');
    Cells[17,0] := _('Highest allocation date');
    Cells[18,0] := _('Sequence issued to');
  end; //string grid mat

  with StringGridProd do
  begin
    Cells[0,0] := _('Sequence');
    Cells[1,0] := _('Bal. type');
    Cells[2,0] := _('Netting group');
    Cells[3,0] := _('Product'); //Article
    Cells[4,0] := _('Planned qty');
    Cells[5,0] := _('Status');
    Cells[6,0] := _('Produced qty');
    Cells[7,0] := _('Allocated qty');
    Cells[8,0] := _('To request');
    Cells[9,0] := _('Res code');

  end; //string grid prod
end;

end;

//----------------------------------------------------------------------------//

procedure TFStepDetails.FormCreate(Sender: TObject);
begin
  ScaleFormSize(Self, Screen.PixelsPerInch);
  TranslateComponent (self);
  JobDetails;
  SetDefaultStringGridColors;
  InitWidth_Lbl;

  ReShape(self);
  BringToFront;
end;

//----------------------------------------------------------------------------//

procedure TFStepDetails.DisplayHeader;
var
  AType:      string;
begin
  AType := p_sc.GetFldDescr(m_id, CSC_ProdType, false);
  STProdType.Caption := p_ArtType.GetSDesc(AType);
  STDeldate.Caption      := p_sc.GetFldDescr(m_id, CSC_ProdDlvDate, false);
  STUmDesc.Caption       := GetSUmDesc(p_sc.GetFldDescr(m_id, CSC_ProdUM, false));
  STProdFamily.Caption   := p_sc.GetFldDescr(m_id, CSC_ProdFamily, false);
  STMaterialsFam.Caption := p_sc.GetFldDescr(m_id, CSC_ProdMatFamily, false);
  STLowestDate.Caption   := p_sc.GetFldDescr(m_id, CSC_LowStartTimeLimit, false);
  STProdLine.Caption     := p_sc.GetFldDescr(m_id, CSC_ProdLine, false);
  if STProdLine.Caption = '' then
     STProdLine.Caption := NOT_EXIST;
end;

//----------------------------------------------------------------------------//

procedure TFStepDetails.DisplayGeneralInfo;
begin
  StProdReq.Caption := p_sc.GetFldDescr(m_id, CSC_ProdReq, false);
  StStepNum.Caption := p_sc.GetFldDescr(m_id, CSC_ProdStep, false);
  STSubStep.Caption := p_sc.GetFldDescr(m_id, CSC_ProdSubStep, false);
  STRePro.Caption   := p_sc.GetFldDescr(m_id, CSC_ReprocNo, false);
end;
//----------------------------------------------------------------------------//

procedure TFStepDetails.DisplayProductInfoArea;
var
  ProdList: TMQMProdArtList;
  j: Integer;
  ProductionArt: PTProdArt;
begin
  ProdList := p_sc.GetHdrProducedMats(m_id);
  if not assigned(ProdList) then exit;

  for j := 0 to ProdList.p_count -1 do begin
    ProductionArt := ProdList.p_Item[j];
    with StringGridProd do
    begin
      Cells[0,RowCount - 1] := ProductionArt.Sequence;
      case ProductionArt.ArtOnBalance of
             aob_Normal: Cells[1,RowCount - 1] := _('Normal');
          aob_ReqNumber: Cells[1,RowCount - 1] := _('Request');
        aob_DisplayOnly: Cells[1,RowCount - 1] := _('Display');
      end;
      Cells[2,RowCount - 1] := ProductionArt.NetGroup.p_Code;
      Cells[3,RowCount - 1] := ProductionArt.Article.p_ArtCode;
      Cells[4,RowCount - 1] := FloatToStr(ProductionArt.RequiredQty);
      if ProductionArt.Closed then
        Cells[5,RowCount - 1] := _('Closed')
      else
        Cells[5,RowCount - 1] := _('Open');
      Cells[6,RowCount - 1] := FloatToStr(ProductionArt.ProducedQty);
      Cells[7,RowCount - 1] := FloatToStr(ProductionArt.AllocatedQty);
      Cells[8,RowCount - 1] := ProductionArt.ToRequest;
      Cells[9,RowCount - 1] := p_sc.GetFldDescr(m_id,CSC_rsc, false);;

      RowCount := RowCount + 1;
    end;//with
  end;//for
  if ProdList.p_count > 0 then
    StringGridProd.RowCount := StringGridProd.RowCount - 1;
end;
//----------------------------------------------------------------------------//

procedure TFStepDetails.DisplayMaterialInfoArea;
var
  planInfo: TSQplanInfo;
  TimingInfo: TSQtimingInfo;
  j : Integer;
  MachSetupCodeList :TMQMMacSetupList;
  MacSetupRec: TMacSetup;
  ProdStep, WkcProc: String;
  TmpMacSetup: TMQMMachineSetup;
  IssuedAL: PTIssuedArt;
  Res: TmqmRes;
  IssArtList: TMQMIssuedArtList;
  ListMatNotAvail: TList;

  procedure PrintMaterialData(ArtList: TMQMIssuedArtList);
  var
    i, z : Integer;
    ArtNotAvail: PTIssuedArt;
  begin
    with StringGridMat do
    begin
      for i:= 0 to ArtList.p_count-1 do
      begin
        IssuedAL := ArtList.p_Item[i];
        case IssuedAL.ArtOnBalance of
          aob_Normal: Cells[0,RowCount - 1]      := _('Normal');
          aob_ReqNumber: Cells[0,RowCount - 1]   := _('Request');
          aob_DisplayOnly: Cells[0,RowCount - 1] := _('Display');
        end;

        Cells[1,RowCount - 1] := IssuedAL.NetGroup.p_Code;
        Cells[2,RowCount - 1] := IssuedAL.Article.p_ArtType.p_ArtTypeCode;
        Cells[3,RowCount - 1] := IssuedAL.Article.p_ArtCode;
        Cells[4,RowCount - 1] := FloatToStr(IssuedAL.RequiredQty);
        if IssuedAL.ClosedIssue = true then
          Cells[5,RowCount - 1] := _('Closed')
        else
          Cells[5,RowCount - 1] := _('Open');

        // put NO if the article is not enough - fp
        if Assigned(ListMatNotAvail) then
          for z := 0 to ListMatNotAvail.Count -1 do
          begin
            ArtNotAvail := PTIssuedArt(ListMatNotAvail.Items[z]);
            if ArtNotAvail.Article = IssuedAL.Article then
              Cells[6,RowCount - 1] := '** ' + _('NO') + ' **';
          end;

        Cells[7,RowCount - 1] := FloatToStr(IssuedAL.IssuedQty);
        Cells[8,RowCount - 1] := FloatToStr(IssuedAL.AllocatedQty);
        Cells[9,RowCount - 1] := IssuedAL.IssueTransType;
        Cells[10,RowCount - 1] := IntToStr(IssuedAL.StepId);
        Cells[11,RowCount - 1] := MacSetupRec.WrkCtrCode;
        Cells[12,RowCount - 1] := WkcProc;//MacSetupRec.WrkCtrProc;
        Cells[13,RowCount - 1] := MacSetupRec.ResCat;
        Cells[14,RowCount - 1] := MacSetupRec.ResCode;
        Cells[15,RowCount - 1] := MacSetupRec.MachineSetupCode;

        if IssuedAL.SearchMatByAlloc = true then
          Cells[16,RowCount - 1] := _('Yes')
        else
          Cells[16,RowCount - 1] := _('No');
        if IssuedAL.HighAllocDate <> 0 then
          Cells[17,RowCount - 1] := DateTimeToStr(IssuedAL.HighAllocDate);
        Cells[18,RowCount - 1] := IssuedAL.SeqIssuedTo;

         RowCount := RowCount + 1;
      end;//for
    end;
  end;//end procedure

begin

////// NEW - fp

  p_sc.GetPlanInfo(m_id, planInfo);
  p_sc.GetTimingInfo(m_id, TimingInfo);
  m_NewSpeed := TimingInfo.NewSpeed;

  MacSetupRec.WrkCtrCode := TimingInfo.wkctCode;
  MacSetupRec.MachineSetupCode := TimingInfo.MachSetupCode;

  ProdStep := p_sc.GetFldDescr(m_id, CSC_ProdStep, false);
  WkcProc :=  p_sc.GetFldDescr(m_id, CSC_WkctProc, false);

  MachSetupCodeList := p_sc.GetStepIssMaterials(m_id);
  try
  if Assigned(MachSetupCodeList) then
  begin

    ListMatNotAvail := nil;

    if planInfo.isOnPlan then
    begin
      Res := TMqmRes(TMqmActArea(p_sc.getExtLinkPtr(m_id)).p_res);
      if Assigned(Res) then
      begin
        MacSetupRec.ResCat := Res.p_ResCat.p_ResCatCode;
        MacSetupRec.ResCode := Res.p_ResCode;
        MacSetupRec.WrkCtrCode := TMqmWrkCtr(Res.p_WrkCtr).p_WrkCtrCode;

        IssArtList := TMQMIssuedArtList.Create(true);
        MachSetupCodeList.GetIssuedArtList(MacSetupRec, IssArtList);

        ListMatNotAvail := TList.Create;

        // Check enough material
        p_sc.GetListMatNotAvail(m_Id, IssArtList, ListMatNotAvail);

        PrintMaterialData(IssArtList);

        IssArtList.Free;
        ListMatNotAvail.Free;
      end;
    end
    else
    begin
      for j:= 0 to MachSetupCodeList.p_count-1 do
      begin
        TmpMacSetup := MachSetupCodeList.p_Item[j];

        MacSetupRec.ResCat := TmpMacSetup.p_ResCatCode;
        MacSetupRec.ResCode := TmpMacSetup.p_ResCode;
        MacSetupRec.WrkCtrCode := TmpMacSetup.p_WrkCtrCode;

        PrintMaterialData(TmpMacSetup.m_IssuedArtList);
      end;
    end;
  end;
  except
  end;

  if StringGridMat.RowCount > 2 then
    StringGridMat.RowCount := StringGridMat.RowCount -1;

{ OLD
  if planInfo.isOnPlan then
  begin
    if Assigned(p_sc.getExtLinkPtr(m_id)) then
    begin
      Res := TMqmRes(TMqmActArea(p_sc.getExtLinkPtr(m_id)).p_res);
      if Assigned(Res) then
      begin
        MacSetupRec.ResCat := Res.p_ResCat.p_ResCatCode;
        MacSetupRec.ResCode := Res.p_ResCode;
        MacSetupRec.WrkCtrCode := TMqmWrkCtr(Res.p_WrkCtr).p_WrkCtrCode;
      end;
    end;
  end else
  begin
    p_sc.GetTimingInfo(m_id, TimingInfo);
    MacSetupRec.WrkCtrCode := TimingInfo.wkctCode;
    MacSetupRec.MachineSetupCode := TimingInfo.MachSetupCode;
  end;
  ProdStep := p_sc.GetFldDescr(m_id, CSC_ProdStep);
  WkcProc :=  p_sc.GetFldDescr(m_id, CSC_WkctProc);

  MachSetupCodeList := p_sc.GetStepIssMaterials(m_id);

  if not planInfo.isOnPlan then
  begin
    for j:= 0 to MachSetupCodeList.p_count-1 do begin
      TmpMacSetup := MachSetupCodeList.p_Item[j];
      PrintMaterialData(TmpMacSetup.m_IssuedArtList);
    end;
  end else
  begin
    IssArtList := TMQMIssuedArtList.Create;
    MachSetupCodeList.GetIssuedArtList(MacSetupRec, IssArtList);
    PrintMaterialData(IssArtList);

    IssArtList.Free;
  end;

  if StringGridMat.RowCount > 2 then
    StringGridMat.RowCount := StringGridMat.RowCount -1;
}
end;

//----------------------------------------------------------------------------//

procedure TFStepDetails.DisplayInfoArea;
var
  FlagHeader : boolean;
  ProdNo, ProdStep : string;
  StePInfoList, HeaderList : TStringList;
  I : Integer;
begin
  ProdNo := p_sc.GetFldDescr(m_id, CSC_ProdReq, false);
  ProdStep := p_sc.GetFldDescr(m_id, CSC_ProdStep, false);

  FlagHeader := false;
  HeaderList := TStringList.Create;
  StePInfoList := TStringList.Create;

  // General Information
  p_ProdInfo.GetInformation(ProdNo,StrToInt(ProdStep),IF_Gen,HeaderList,StePInfoList);

  m_SpaceGen := -1;

  with StringGridGen do
  begin

    for I := 0 to HeaderList.Count - 1 do
    begin
      FlagHeader := true;
      Cells[0,RowCount - 1] := HeaderList.Strings[I];
      if I < HeaderList.Count - 1 then
        RowCount := RowCount + 1;
    end;

    if FlagHeader and (StePInfoList.Count > 0) then
    begin
//savAro      RowCount := RowCount + 1;
//savAro      m_SpaceGen := RowCount - 1;
      m_SpaceGen := RowCount;  //SavARO
    end;

    for I := 0 to StePInfoList.Count - 1 do
    begin
//savAro      if FlagHeader then
//savAro      RowCount := RowCount + 1;
      Cells[0,RowCount-1] := StePInfoList.Strings[I];
      if I < StePInfoList.Count - 1 then  //savAro
        RowCount := RowCount + 1;         //savAro
    end;
  end;

  FlagHeader := false;
  HeaderList.Clear;
  StePInfoList.Clear;

  DisplayProductInfoArea;
  {
  // Product Information
  p_ProdInfo.GetInformation(ProdNo,StrToInt(ProdStep),IF_Prod,HeaderList,StePInfoList);

  m_SpaceProd := -1;

  with StringGridProd do
  begin

    for I := 0 to HeaderList.Count - 1 do
    begin
      FlagHeader := true;
      Cells[0,RowCount - 1] := HeaderList.Strings[I];
      if I < HeaderList.Count - 1 then
        RowCount := RowCount + 1;
    end;

    if FlagHeader and (StePInfoList.Count > 0) then
    begin
//SavAro       RowCount := RowCount + 1;
//SavAro      m_SpaceProd := RowCount - 1;
      m_SpaceProd := RowCount;  //SavAro
    end;

    for I := 0 to StePInfoList.Count - 1 do
    begin
//savAro      if FlagHeader then
//savAro      RowCount := RowCount + 1;
      Cells[0,RowCount-1] := StePInfoList.Strings[I];
      if I < StePInfoList.Count - 1 then  //savAro
        RowCount := RowCount + 1;         //savAro
    end;
  end;

  FlagHeader := false;
  HeaderList.Clear;
  StePInfoList.Clear;
 }
  DisplayMaterialInfoArea;
 {
  // Materials Information
  p_ProdInfo.GetInformation(ProdNo,StrToInt(ProdStep),IF_Mat,HeaderList,StePInfoList);

  m_SpaceMat := -1;

  with StringGridMat do
  begin

    for I := 0 to HeaderList.Count - 1 do
    begin
      FlagHeader := true;
      Cells[0,RowCount - 1] := HeaderList.Strings[I];
      if I < HeaderList.Count - 1 then
        RowCount := RowCount + 1;
    end;

    if FlagHeader and (StePInfoList.Count > 0) then
    begin
//SavAro       RowCount := RowCount + 1;
//SavAro      m_SpaceProd := RowCount - 1;
      m_SpaceProd := RowCount;  //SavAro
    end;

    for I := 0 to StePInfoList.Count - 1 do
    begin
//savAro      if FlagHeader then
//savAro      RowCount := RowCount + 1;
      Cells[0,RowCount-1] := StePInfoList.Strings[I];
      if I < StePInfoList.Count - 1 then  //savAro
        RowCount := RowCount + 1;         //savAro
    end;
  end;

  FlagHeader := false;
  HeaderList.Clear;
  StePInfoList.Clear;
   }
  // Instruction Information
  p_ProdInfo.GetInformation(ProdNo,StrToInt(ProdStep),IF_Inst,HeaderList,StePInfoList);

  m_SpaceInst := -1;

  with StringGridInstr do
  begin

    for I := 0 to HeaderList.Count - 1 do
    begin
      FlagHeader := true;
      Cells[0,RowCount - 1] := HeaderList.Strings[I];
      if I < HeaderList.Count - 1 then
        RowCount := RowCount + 1;
    end;

    if FlagHeader and (StePInfoList.Count > 0) then
    begin
//SavAro       RowCount := RowCount + 1;
//SavAro      m_SpaceProd := RowCount - 1;
      m_SpaceProd := RowCount;  //SavAro
    end;

    for I := 0 to StePInfoList.Count - 1 do
    begin
//savAro      if FlagHeader then
//savAro      RowCount := RowCount + 1;
      Cells[0,RowCount-1] := StePInfoList.Strings[I];
      if I < StePInfoList.Count - 1 then  //savAro
        RowCount := RowCount + 1;         //savAro
    end;
  end;

  FlagHeader := false;
  HeaderList.Clear;
  StePInfoList.Clear;

  // Comments Information
  p_ProdInfo.GetInformation(ProdNo,StrToInt(ProdStep),IF_Comments,HeaderList,StePInfoList);

  m_SpaceComent := -1;

  with StringGridComment do
  begin

    for I := 0 to HeaderList.Count - 1 do
    begin
      FlagHeader := true;
      Cells[0,RowCount - 1] := HeaderList.Strings[I];
      if I < HeaderList.Count - 1 then
        RowCount := RowCount + 1;
    end;

    if FlagHeader and (StePInfoList.Count > 0) then
    begin
//SavAro       RowCount := RowCount + 1;
//SavAro      m_SpaceProd := RowCount - 1;
      m_SpaceProd := RowCount;  //SavAro
    end;

    for I := 0 to StePInfoList.Count - 1 do
    begin
//savAro      if FlagHeader then
//savAro      RowCount := RowCount + 1;
      Cells[0,RowCount-1] := StePInfoList.Strings[I];
      if I < StePInfoList.Count - 1 then  //savAro
        RowCount := RowCount + 1;         //savAro
    end;
  end;

  FlagHeader := false;
  HeaderList.Clear;
  StePInfoList.Clear;

  // Other Information
  p_ProdInfo.GetInformation(ProdNo,StrToInt(ProdStep),IF_Others,HeaderList,StePInfoList);

  m_SpaceOther := -1;

  with StringGridComment do
  begin

    for I := 0 to HeaderList.Count - 1 do
    begin
      FlagHeader := true;
      Cells[0,RowCount - 1] := HeaderList.Strings[I];
      if I < HeaderList.Count - 1 then
        RowCount := RowCount + 1;
    end;

    if FlagHeader and (StePInfoList.Count > 0) then
    begin
//SavAro       RowCount := RowCount + 1;
//SavAro      m_SpaceProd := RowCount - 1;
      m_SpaceProd := RowCount;  //SavAro
    end;

    for I := 0 to StePInfoList.Count - 1 do
    begin
//savAro      if FlagHeader then
//savAro      RowCount := RowCount + 1;
      Cells[0,RowCount-1] := StePInfoList.Strings[I];
      if I < StePInfoList.Count - 1 then  //savAro
        RowCount := RowCount + 1;         //savAro
    end;
  end;

  HeaderList.free;
  StePInfoList.free;

end;

//----------------------------------------------------------------------------//

procedure TFStepDetails.DisplayConnectedReq;
var
{  qry: TMqmQuery;
  trs: TMqmTransaction;
  tbInfo: ^TTblInfo;  }
  ProdNo : string;
  Found : boolean;
  PrevProdNo : TStringList;
  I : Integer;
  StepList : TList;
  ReadHdr : string;
begin

{  PrevProdNo := TStringList.Create;

  ProdNo := p_sc.GetFldDescr(m_id, CSC_ProdReq);

  tbInfo := @tblInfo[tbl_prod_reqConnection];
  SetFldPfx(tbInfo.pfx);

  trs := CreateTransaction(Main_DB, true);
  qry := CreateQuery(trs, Main_DB);

  with qry do
  begin

    Transaction.Active := true;
    SQL.Clear;
    SQL.Add('select ' + CreatePfxFld(fli_PrevProdNum) + ' from ' + tbInfo.PCname);
    SQL.Add(' where ' + CreatePfxFld(fli_preqNo) + '=''' + ProdNo + '''');
    open;

    while not EOF do
    begin
      PrevProdNo.add(fieldByName(CreatePfxFld(fli_PrevProdNum)).AsString);
      Next;
    end;
    close;
  end;

  found := false;

  for I := 0 to PrevProdNo.Count - 1 do
  begin
    if AddConnectedReq(Found, RS_PrevReq ,PrevProdNo.Strings[I]) then
      Found := true;
  end;

  AddConnectedReq(Found, RS_Current, ProdNo);  //  First and Last Step

  with qry do
  begin

    Active := true;
    SQL.Clear;
    SQL.Add('select ' + CreatePfxFld(fli_preqNo) + ' from ' + tbInfo.PCname + ' where ' + CreatePfxFld(fli_PrevProdNum) + '=''' + ProdNo + '''');
    open;

    while not EOF do
    begin
      AddConnectedReq(true, RS_NextReq, fieldByName(CreatePfxFld(fli_preqNo)).AsString);
      Next;
    end;
    close;

  end;

  PrevProdNo.free;

  trs.Commit;       //Vinc
  qry.Free;
  trs.Free  }


  PrevProdNo := TStringList.Create;

  ProdNo := p_sc.GetFldDescr(m_id, CSC_ProdReq, false);

  StepList := TList.Create;
  p_sc.GetPrevConnReqSteps(m_Id, StepList);
  ReadHdr := '';
  for I := 0 to StepList.Count - 1 do
  begin
    if ReadHdr = TSCProdReqHdr(TSCProdReqDet(StepList[I]).m_hdr).m_code then continue;
    PrevProdNo.add(TSCProdReqHdr(TSCProdReqDet(StepList[I]).m_hdr).m_code);
    ReadHdr := TSCProdReqHdr(TSCProdReqDet(StepList[I]).m_hdr).m_code;
  end;

  found := false;

  for I := 0 to PrevProdNo.Count - 1 do
  begin
    if AddConnectedReq(Found, RS_PrevReq ,PrevProdNo.Strings[I]) then
      Found := true;
  end;

  AddConnectedReq(Found, RS_Current, ProdNo);  //  First and Last Step

  StepList.Clear;
  PrevProdNo.Clear;
  p_sc.GetNextConnReqSteps(m_Id, StepList);
  ReadHdr := '';
  for I := 0 to StepList.Count - 1 do
  begin
    if ReadHdr = TSCProdReqHdr(TSCProdReqDet(StepList[I]).m_hdr).m_code then continue;
    PrevProdNo.add(TSCProdReqHdr(TSCProdReqDet(StepList[I]).m_hdr).m_code);
    ReadHdr := TSCProdReqHdr(TSCProdReqDet(StepList[I]).m_hdr).m_code;
  end;

  for I := 0 to PrevProdNo.Count - 1 do
    AddConnectedReq(true, RS_NextReq, PrevProdNo.Strings[I]);

  PrevProdNo.free;
  StepList.Free;

end;

//----------------------------------------------------------------------------//
{
procedure TFStepDetails.GetPsQtyLimitDatesForPd(ProdReq : string; StepId : integer ; var Qty : double ; var LowSt : TDateTime ; var HighEd : TDateTime);
var
  qry: TMqmQuery;
  trs: TMqmTransaction;
  tbInfoPs : ^TTblInfo;
  FirstRec : boolean;
begin

  trs := CreateTransaction(Main_DB, true);
  qry := CreateQuery(trs, Main_DB);

  tbInfoPs := @tblInfo[tbl_prod_sched];

  with qry do
  begin
    Transaction.Active := true;
    SQL.Clear;

    SQL.Add('select ' + CreateFld(tbInfoPs.pfx,fli_schedStart) + ',');
    SQL.Add(CreateFld(tbInfoPs.pfx,fli_schedEnd) + ',');
    SQL.Add(CreateFld(tbInfoPs.pfx,fli_quant));
    SQL.Add(' from ' + tbInfoPs.PCname + ' where ' + CreateFld(tbInfoPs.pfx,fli_preqNo) + '=''' + ProdReq + '''');
    SQL.Add(' and ' + CreateFld(tbInfoPs.pfx,fli_pstepId) + '=''' + IntToStr(StepId) + '''');
    SQL.Add(' Order by ' + CreateFld(tbInfoPs.pfx,fli_psubstId));
    open;
    first;

    FirstRec := true;

    Qty := 0;
    LowSt := 0;
    HighEd := 0;

    while not Eof do
    begin
      if FirstRec then
      begin
        LowSt := FieldByName(CreateFld(tbInfoPS.pfx, fli_schedStart)).AsDateTime;
        HighEd := FieldByName(CreateFld(tbInfoPS.pfx, fli_schedEnd)).AsDateTime;
        FirstRec := false;
      end
      else
      begin
        if ((FieldByName(CreateFld(tbInfoPS.pfx, fli_schedStart)).AsDateTime) < LowSt) then
          LowSt := FieldByName(CreateFld(tbInfoPS.pfx, fli_schedStart)).AsDateTime;
        if ((FieldByName(CreateFld(tbInfoPS.pfx, fli_schedEnd)).AsDateTime) > HighEd) then
          HighEd := FieldByName(CreateFld(tbInfoPS.pfx, fli_schedEnd)).AsDateTime;
      end;
      Qty := Qty + FieldByName(CreateFld(tbInfoPS.pfx, fli_quant)).AsFloat;
      next;
    end;

    close;
  end;

  trs.Commit;
  qry.Free;
  trs.Free
end;
}

//---------------------------------------------------------------------------------------

function TFStepDetails.AddConnectedReq(AddRowCount: boolean; TypeReq: RelationShip; ProdReq: string): boolean;
var
  qry: TMqmQuery;
  tbInfoPd: ^TTblInfo;
  FirstTime : boolean;
  FirstStepId, LastStepId : Integer;
  FirstWorCnterCode, LastWorCnterCode, FirstStepClosed, LastStepClosed : string;
  FirstQuantInit ,LastQuantInit, FirstNumResPlan, LastNumResPlan : double;
  FirstPlanStart, LastPlanStart, FirstPlanEnd, LastPlanEnd : TDateTime;
begin
  Result := false;
  tbInfoPD := @tblInfo[tbl_prod_step];
  qry := CreateQuery(Main_DB);

  FirstTime := true;
  with qry do
  begin
    SQL.Clear;
    SQL.Add('select * from ' + tbInfoPd.GetTableName + ' where ' + CreateFld(tbInfopd.pfx, fli_preqNo) + '=''' + ProdReq + '''');
    if DBAppGlobals.MCM_App then
      qry.SQL.Add(' and ' + CreateFld(tbInfopd.pfx, fli_SchedulByMcm) + '=''1''')
    else
      qry.SQL.Add(' and ' + CreateFld(tbInfopd.pfx, fli_SchedulByMqm) + '=''1''');
  //  qry.SQL.Add(' and ' + CreateFld(tbInfopd.pfx, fli_ToBeSched) + '=''1''');
    SQL.Add('Order by ' + CreateFld(tbInfopd.pfx, fli_pstepId));
    open;
    while not EOF do
    begin
      if FirstTime then
      begin
        FirstStepId       := fieldByName(CreateFld(tbInfoPd.pfx,fli_pstepId)).AsInteger;
        FirstWorCnterCode := fieldByName(CreateFld(tbInfoPd.pfx,fli_wkCtrCode)).AsString;
        FirstStepClosed   := fieldByName(CreateFld(tbInfoPd.pfx,fli_StepClosed)).AsString;
        FirstQuantInit    := fieldByName(CreateFld(tbInfoPd.pfx,fli_quantInit)).AsFloat;
        FirstPlanStart    := fieldByName(CreateFld(tbInfoPd.pfx,fli_planStart)).AsDateTime;
        FirstPlanEnd      := fieldByName(CreateFld(tbInfoPd.pfx,fli_planEnd)).AsDateTime;
        FirstNumResPlan    := fieldByName(CreateFld(tbInfoPd.pfx,fli_NumResPlan)).AsFloat;
        FirstTime := false;
      end;
     // else
     // begin
      LastStepId       := fieldByName(CreateFld(tbInfoPd.pfx,fli_pstepId)).AsInteger;
      LastWorCnterCode := fieldByName(CreateFld(tbInfoPd.pfx,fli_wkCtrCode)).AsString;
      LastStepClosed   := fieldByName(CreateFld(tbInfoPd.pfx,fli_StepClosed)).AsString;
      LastQuantInit    := fieldByName(CreateFld(tbInfoPd.pfx,fli_quantInit)).AsFloat;
      LastPlanStart    := fieldByName(CreateFld(tbInfoPd.pfx,fli_planStart)).AsDateTime;
      LastPlanEnd      := fieldByName(CreateFld(tbInfoPd.pfx,fli_planEnd)).AsDateTime;
      LastNumResPlan   := fieldByName(CreateFld(tbInfoPd.pfx,fli_NumResPlan)).AsFloat;
     // end;

      next;
    end;
    close;
  end;
  qry.Free;

  if FirstTime then exit;

  with SGConnectedReq do
  begin
    Result := true;
    if AddRowCount then
      RowCount := RowCount + 1;
     case TypeReq of
       RS_PrevReq :
         FillDataConnectedReq(ProdReq, LastStepId, RS_PrevReq ,LastWorCnterCode, LastStepClosed ,LastQuantInit, LastNumResPlan, LastPlanStart, LastPlanEnd);
       RS_Current :
       begin
         FillDataConnectedReq(ProdReq,FirstStepId,RS_CurrentFirst ,FirstWorCnterCode, FirstStepClosed ,FirstQuantInit, FirstNumResPlan, FirstPlanStart, FirstPlanEnd);
         if (FirstStepId = LastStepId) then
         begin
           Cells[1,RowCount - 1] := _('Current First/Last step');
           Result := false;
           Exit;
         end
         else
         begin
           RowCount := RowCount + 1;
           FillDataConnectedReq(ProdReq,LastStepId, RS_CurrentLast, LastWorCnterCode, LastStepClosed ,LastQuantInit, LastNumResPlan, LastPlanStart, LastPlanEnd);
         end;
       end;
       RS_NextReq :
       begin
         FillDataConnectedReq(ProdReq,FirstStepId, RS_NextReq ,FirstWorCnterCode, FirstStepClosed ,FirstQuantInit, FirstNumResPlan, FirstPlanStart, FirstPlanEnd);
       end;
     end;
   end;

end;

//----------------------------------------------------------------------------//

procedure TFStepDetails.FillDataConnectedReq(ProdReq: string; StepId : Integer; TypeReq: RelationShip; WorCnterCode, StepClosed : string;
                                   QuantInit, NumResPlan : double; PlanStart, PlanEnd : TDateTime);
var
  LowSt, HighEd : TDateTime;
  WorkStation : string;
  ProgStart,ProgGen,ProgFinal,ProgFinalSplit : double;
begin

  with SGConnectedReq do
  begin
    Cells[0,RowCount - 1] := ProdReq;
    case TypeReq of
      RS_PrevReq : Cells[1,RowCount - 1] := _('Previous request');
      RS_CurrentFirstLast : Cells[1,RowCount - 1] := _('Current First/Last step');
      RS_CurrentFirst : Cells[1,RowCount - 1] := _('Current first step');
      RS_CurrentLast : Cells[1,RowCount - 1] := _('Current last step');
      RS_NextReq : Cells[1,RowCount - 1] := _('Next request');
    end;

    WorkStation := GetWorkStationForWc(WorCnterCode, true);
    if (WorkStation = '') then
      Cells[2,RowCount - 1] := NOT_EXIST
    else
      Cells[2,RowCount - 1] := WorkStation;

    if WorCnterCode = '' then
      Cells[3,RowCount - 1] := NOT_EXIST
    else
      Cells[3,RowCount - 1] := p_WrkctrDesc.GetSDesc(WorCnterCode);

    if (StepClosed = '0') then
      Cells[4,RowCount - 1] := _('  No')
    else
      Cells[4,RowCount - 1] := _('  Yes');

    Cells[5,RowCount - 1] := FloatToStr(QuantInit);

    p_sc.GetStepLimitDates(ProdReq, StepId, LowSt, HighEd);
    Cells[6,RowCount - 1] := FloatToStr(p_sc.GetStepSchedQty(ProdReq, StepId));

    Cells[7,RowCount - 1] := DateTimeToStr(PlanStart);

    if (LowSt = 0) then
      Cells[8,RowCount - 1] := NOT_EXIST
    else
      Cells[8,RowCount - 1] := DateTimeToStr(LowSt);
    Cells[9,RowCount - 1] := DateTimeToStr(PlanEnd);


    if (HighEd = 0) then
      Cells[10,RowCount - 1] := NOT_EXIST
    else
      Cells[10,RowCount - 1] := DateTimeToStr(HighEd);

    Cells[11,RowCount - 1] := FloatToStr(NumResPlan);

    GetSpProgressTypes(ProdReq,StepId,
                         ProgStart,ProgGen,ProgFinal,ProgFinalSplit);

    if (ProgStart = 0) then
      Cells[12,RowCount - 1] := NOT_EXIST
    else
      Cells[12,RowCount - 1] := FloatToStr(ProgStart);
    if (ProgGen = 0) then
      Cells[13,RowCount - 1] := NOT_EXIST
    else
      Cells[13,RowCount - 1] :=  FloatToStr(ProgGen);
    if (ProgFinal = 0) then
      Cells[14,RowCount - 1] := NOT_EXIST
    else
      Cells[14,RowCount - 1] :=  FloatToStr(ProgFinal);
    if (ProgFinalSplit = 0) then
      Cells[15,RowCount - 1] := NOT_EXIST
    else
      Cells[15,RowCount - 1] :=  FloatToStr(ProgFinalSplit);
  end;

end;

//------------------------------------------------------------------------------//

procedure TFStepDetails.DisplaySchedDetails;
var
//  ErrorNumber : CScErrors;
  Errors: SetOfErrors;
  plan : TSQplanInfo;
 // Wc : TMqmWrkCtr;
  WorkCenterCode, WorkCenterDesc : string;
  Res : TMqmRes;
  SchedType : string;
  FieldVal : variant;
  dataType: CBinColValType;
//sav  ProgressRec : TProgressRec;
  ProgInfo: TSQProgInfo;
  TimeBarUnit : Double;
  DummyList : TList;
//  test : Integer ;
//  test1 : Double;
begin
  DummyList := nil;
  //WC := TMqmWrkCtr(p_sc.GetWrkCtrPtr(m_id));   //
  WorkCenterCode := p_sc.GetFldDescr(m_id, CSC_WkctCode, false);
  WorkCenterDesc := p_sc.GetFldDescr(m_id, CSC_WkctCodeDesc, false);

  STWorkStation.Caption := GetWorkStationForWc(WorkCenterCode,true);
  STGroupNumber.Caption := p_sc.GetFldDescr(m_id, CSC_GroupNo, false);
  STLearningCurveCode.Caption := p_sc.GetLearningCurveCode(m_id);
  SchedType := p_sc.GetSchedType(m_id);


  if SchedType = '0' then
    STScheduleType.Caption := _('No')
  else if SchedType = '1' then
    STScheduleType.Caption := _('Initial')
  else if SchedType = '2' then
    STScheduleType.Caption := _('Final')
  else if SchedType = '3' then
    STScheduleType.Caption := _('Level 1')
  else if SchedType = '4' then
    STScheduleType.Caption := _('Level 2')
  else if SchedType = '5' then
    STScheduleType.Caption := _('Level 3')
  else if SchedType = '6' then
    STScheduleType.Caption := _('Level 4')
  else if SchedType = '7' then
    STScheduleType.Caption := _('Level 5');

  STWorkCenter.Caption := WorkCenterCode + '    ' + WorkCenterDesc;
  STWCProcess.Caption := p_sc.GetFldDescr(m_id, CSC_WkctProc, false) + '    ' + GetProcessSDesc(WorkCenterCode,STWCProcess.Caption);

  if Assigned(p_sc.getExtLinkPtr(m_id)) then
  begin
    Res := TMqmRes(TMqmActArea(p_sc.getExtLinkPtr(m_id)).p_res);
    if Assigned(Res) then
      STRes.Caption := Res.p_ResCode + '    ' + Res.p_ResSDesc;
  end;

  if p_sc.GetCurveFamilyIdCode(m_id) = '' then
  begin
    CurveFamily.Visible := false;
    STLearningCurveFamily.Visible := false
  end;

  STLearningCurveFamily.Caption := p_sc.GetCurveFamilyIdCode(m_id);

  STResSubLine.Caption := p_sc.GetFldDescr(m_id, CSC_SubLineRsc, false);
  p_sc.GetFldValue(m_id, CSC_NoResComp, FieldVal, dataType);
  if (FieldVal = 0) then
  begin
    STResComp.Visible := false;
    LblResComp.Visible := false;
  end
  else
    STResComp.Caption := FieldVal;
  STQuantity.Caption := p_sc.GetFldDescr(m_id, CSC_QtyToSched, false);
  p_sc.GetPlanInfo(m_id,plan);
  STSetupTime.Caption := FormatDuration(plan.supMinReal, true);
  STSetupTimeWithoutMaterials.Caption := FormatDuration(plan.supMinOvlp, true);
  STExecTime.Caption := FormatDuration(plan.exeMin, true);

  p_sc.GetFldValue(m_id, CSC_ActualTime, FieldVal, dataType);
  STActualTime.Caption := FormatDuration(FieldVal, true);

  if plan.startDate = 0 then
    STSchedStart.Caption := NOT_EXIST
  else
  begin
//    STSchedStart.Caption := DateTimeToStr(plan.startDate);
    STSchedStart.Caption := p_sc.GetFldDescr(m_id, CSC_SchedStart, false);
  end;

  if plan.endDate = 0 then
    STSchedEnd.Caption := NOT_EXIST
  else
  begin
   // STSchedEnd.Caption := DateTimeToStr(plan.endDate);
    STSchedEnd.Caption := p_sc.GetFldDescr(m_id, CSC_SchedEnd, false);
  end;

  p_sc.GetProgInfo(m_id, ProgInfo);
  if (ProgInfo.PrgSt = 0) then
    STProgStart.Caption := NOT_EXIST
  else
    STProgStart.Caption := DateTimeToStr(ProgInfo.PrgSt);

  if (ProgInfo.PrEd = 0) then
    STProgEnd.caption := NOT_EXIST
  else
    STProgEnd.caption := DateTimeToStr(ProgInfo.PrEd);

  STQuantityProg.Caption := FloatToStr(ProgInfo.PrgQty);

  p_sc.GetFldValue(m_id, CSC_ProgStart, FieldVal, dataType);
  STActualStart.Caption := FieldVal;

  p_sc.GetFldValue(m_id, CSC_ProgEnd, FieldVal, dataType);
  STActualEnd.Caption := FieldVal;

  STPrevConnSubStep.Caption := p_sc.GetFldDescr(m_id, CSC_BkwConnSubStp, false);
  STPrevConnReProcess.Caption := p_sc.GetFldDescr(m_id, CSC_BkwConnReProcs, false);
  STComment.Caption := p_sc.GetFldDescr(m_id, CSC_Comment, false);

  Errors := [];
  p_sc.checkerrors(m_id, CSEG_All, Errors, DummyList);
  MemErrors.Lines.Clear;
  if CSE_Materials in Errors then
    MemErrors.Lines.Add(GetErrorDesc(CSE_Materials));
  if CSE_AddRes in Errors then
    MemErrors.Lines.Add(GetErrorDesc(CSE_AddRes));
  if CSE_DelDate in Errors then
    MemErrors.Lines.Add(GetErrorDesc(CSE_DelDate));
  if CSE_BothOvlp in Errors then
    MemErrors.Lines.Add(GetErrorDesc(CSE_BothOvlp));
  if CSE_LeftOvlp in Errors then
    MemErrors.Lines.Add(GetErrorDesc(CSE_LeftOvlp));
  if CSE_RightOvlp in Errors then
    MemErrors.Lines.Add(GetErrorDesc(CSE_RightOvlp));
  if CSE_HighEndDate in Errors then
    MemErrors.Lines.Add(GetErrorDesc(CSE_HighEndDate));
  if CSE_LowStrDate in Errors then
    MemErrors.Lines.Add(GetErrorDesc(CSE_LowStrDate));
  if CSE_ApprovalDate in Errors then
    MemErrors.Lines.Add(GetErrorDesc(CSE_ApprovalDate));
{
  STErrorInfo.Caption := GetErrorDesc(ErrorNumber);
  case ErrorNumber of
    0: STErrorInfo.Caption := _('Step ends after delivery date');
    1: STErrorInfo.Caption := _('Step has not enough materials');
    2: STErrorInfo.Caption := _('Step ends after highest date');
    3: STErrorInfo.Caption := _('Step starts before lower limit');
    4: STErrorInfo.Caption := _('Step ends after planning date');
    5: STErrorInfo.Caption := _('Step starts before planning date');

  else
    STErrorInfo.Caption := '';
  end;
 }
   if ( p_sc.GetExtLinkPtr(m_id) = nil ) then
         GBTimeBar.Visible := false
    else begin
      GBTimeBar.visible := true ;
      if (plan.exeMin + plan.supMinReal) = 0 then
        plan.exeMin := 1;
      TimeBarUnit := ( GBTimeBar.Width - 20 )/(plan.supMinReal + plan.exeMin );

      ShapeSetuptimeWOMaterials.Left := GBTimeBar.Left + 10  ;
      ShapeSetuptimeWOMaterials.Width :=  Floor(TimeBarUnit *  plan.supMinOvlp);
      ShapeSetuptimeWOMaterials.Hint := FormatDuration(plan.supMinOvlp, true);
      ShapeSetuptimeWOMaterials.CustomHint := FMQMPlan.BalloonHint1;

      ShapeSetupTime.Left := GBTimeBar.Left + 10 + ShapeSetuptimeWOMaterials.Width - 1 ;
      ShapeSetupTime.Width := Floor(TimeBarUnit * ( plan.supMinReal - plan.supMinOvlp ) );
      ShapeSetupTime.Hint := FormatDuration(plan.supMinReal, true);
      ShapeSetupTime.CustomHint := FMQMPlan.BalloonHint1;

      ShapeExecTime.Left := GBTimeBar.Left + 10 + ShapeSetupTime.Width + ShapeSetuptimeWOMaterials.Width - 1 ;
      ShapeExectime.Width :=  Floor(TimeBarUnit * plan.exeMin );
      ShapeExectime.Hint := FormatDuration(plan.exeMin, true);
      ShapeExectime.CustomHint := FMQMPlan.BalloonHint1;
    end;


end;

//------------------------------------------------------------------------------//

procedure TFStepDetails.DisplayStepDetails;
var
  Um,  Process : string;
  WorkCenterCode, WorkCenterDesc : string;
//  WC: TMqmWrkCtr;
//  ProgressRec : TProgressRec;
  LowSt, HighEd : TDateTime;
//  SchedQty : double;
  ProdReq, ProgType : string;
  FieldVal : variant;
  dataType: CBinColValType;
  SplitInfo: TSQSplitInfo;
  linkInfo : TSQlinkInfo;
  NewTime, NewSetup, NewJobSetup : double;
  IsSpeedChanged, IsSetUpChanged, IsJobSetUpChanged : boolean;
begin
  Um := p_sc.GetFldDescr(m_id, CSC_WeightUM, false);
  STWeighUMDescription.Caption := GetSUmDesc(Um);

 // WC := TMqmWrkCtr(p_sc.GetWrkCtrPtr(m_id));
  WorkCenterCode := p_sc.GetFldDescr(m_id, CSC_PlanWkctCode, false);
  WorkCenterDesc := p_sc.GetFldDescr(m_id, CSC_PlanWkctDesc, false);

  STPlannedWorkCenter.caption := WorkCenterCode + '    ' + WorkCenterDesc;

  STPlannedWorkStation.Caption := GetWorkStationForWc(WorkCenterCode,true);

  Process := p_sc.GetFldDescr(m_id, CSC_PlanWkctProc, false);
  Process := Process + '    ' +  GetProcessSDesc(WorkCenterCode,Process);
  STPlannedWCProcess.Caption := Process;

  STStepType.Caption := p_sc.GetFldDescr(m_id, CSC_StepType, false);
  STApprovaldate.Caption := p_sc.GetFldDescr(m_id, CSC_ApprovalDate, false);

  p_sc.GetFldValue(m_id, CSC_MatArrivalDate, FieldVal, dataType);
  if FieldVal = 0 then
    STMaterialsArrivalDate.Caption := NOT_EXIST
  else
    STMaterialsArrivalDate.Caption := p_sc.GetFldDescr(m_id, CSC_MatArrivalDate, false);
  STPlannedStartingDate.Caption := p_sc.GetFldDescr(m_id, CSC_PlanStartDate, false);
  STLowestStartingDatePos.Caption := p_sc.GetFldDescr(m_id, CSC_LowStartDate, false);

  ProdReq := p_sc.GetFldDescr(m_id, CSC_ProdReq, false);

  p_sc.GetStepLimitDates(ProdReq, StrToInt(p_sc.GetFldDescr(m_id, CSC_ProdStep, false)), LowSt, HighEd);
  if (LowSt = 0) and (HighEd = 0) then
  begin
    STLowestSchedStartingDate.Caption := NOT_EXIST;
    STHighestSchedEndingDate.Caption := NOT_EXIST;
  end
  else
  begin
    STLowestSchedStartingDate.Caption := DateTimeToStr(LowSt);
    STHighestSchedEndingDate.Caption := DateTimeToStr(HighEd);
  end;

  STPlannedEndingDate.Caption := p_sc.GetFldDescr(m_id, CSC_PlanEndDate, false);
  STOriginalHighestEndingDatePos.Caption := p_sc.GetFldDescr(m_id, CSC_OrigHighEndLimit, false);
  STHighestEndingDatePos.Caption := p_sc.GetFldDescr(m_id, CSC_HighEndLimit, false);

  STScheduledQuantity.Caption := FloatToStr(p_sc.GetStepSchedQty(ProdReq, StrToInt(p_sc.GetFldDescr(m_id, CSC_ProdStep, false))));
  STInitialQuantity.Caption := p_sc.GetFldDescr(m_id, CSC_IniQty, false);
  STFinalQuantity.Caption := p_sc.GetFldDescr(m_id, CSC_FinQty, false);
  STWeight.Caption := p_sc.GetFldDescr(m_id, CSC_Weight, false);

  STCalCode.Caption := p_sc.GetFldDescr(m_id,  CSC_Calendar, false);
  STTotalPlannedSetupTime.Caption := p_sc.GetFldDescr(m_id, CSC_PlanSetup, false);
  STTotalPlannedExecTime.Caption := p_sc.GetFldDescr(m_id, CSC_ExeTime, false);
  STPlannedNumberOfRes.Caption := p_sc.GetFldDescr(m_id, CSC_NumOfRscPlan, false);

  if p_sc.GetFldDescr(m_id, CSC_ConnTypePrvStep, false) = '0' then
    STRuleToConnectToPrevJob.Caption := _('No');
  if p_sc.GetFldDescr(m_id, CSC_ConnTypePrvStep, false) = '1' then
    STRuleToConnectToPrevJob.Caption := _('Many previous jobs');
  if p_sc.GetFldDescr(m_id, CSC_ConnTypePrvStep, false) = '2' then
    STRuleToConnectToPrevJob.Caption := _('One previous job');
   if p_sc.GetFldDescr(m_id, CSC_ConnTypePrvStep, false) = '3' then
    STRuleToConnectToPrevJob.Caption := _('One to one');

  STClosed.Caption := p_sc.GetFldDescr(m_id, CSC_Closed, false);

  p_sc.GetSplitInfo(m_Id, SplitInfo);
                            // CSB_No,CSB_Yes,CSB_Son,CSB_Father
  case SplitInfo.SplitAllow of
    CSB_No  : STAlloweSplit.caption      := _('No');
    CSB_Yes : STAlloweSplit.caption      := _('Yes');
    CSB_Father : STAlloweSplit.caption   := _('Leader');
    CSB_Son : STAlloweSplit.caption      := _('Slave');
  end;

  ProgType := p_sc.GetFldDescr(m_id, CSC_ProgType, false);

  if ProgType <> '' then
  begin
    STProgressedCalculated.Caption := ProgType;
  end
  else
    STProgressedCalculated.Caption := NOT_EXIST;

  ProgType := p_sc.GetFldDescr(m_id, CSC_ProgType_Host, false);

  if ProgType <> '' then
  begin
    STProgressedHost.Caption := ProgType;
  end
  else
    STProgressedHost.Caption := NOT_EXIST;

  p_sc.GetLinkInfo(m_Id, linkInfo);
  if linkInfo.IsGenericPlan then
    STGenericPlan.Caption := _('Yes')
  else
    STGenericPlan.Caption := _('No');

  LabelOverriddenSpeedPerUm.Visible := false;
  STOverriddenSpeedPerUm.Visible    := false;
  StaticTexOverriddenSetup.Visible  := false;
  LblOveriddenSetup.Visible         := false;

  if p_sc.GetNewTimeIfSpeedChanged(m_id, NewTime, NewSetup, NewJobSetup, IsSpeedChanged, IsSetUpChanged, IsJobSetUpChanged) then
  begin
    if IsSpeedChanged then
    begin
      LabelOverriddenSpeedPerUm.Font.Style := [fsBold];
      LabelOverriddenSpeedPerUm.Visible := true;
      STOverriddenSpeedPerUm.Font.Style := [fsBold];
      STOverriddenSpeedPerUm.Visible    := true;
      STOverriddenSpeedPerUm.Caption    := FloatToStr(m_NewSpeed)
    end;
    if IsSetUpChanged then
    begin
      LblOveriddenSetup.Visible        := true;
      StaticTexOverriddenSetup.Visible := true;
      StaticTexOverriddenSetup.Caption := FloatToStr(NewSetup)
    end;
  end;
end;

//---------------------------------------------------------------------------------------

procedure TFStepDetails.DisplayStepsView;
var
  StepInfo: TSQStepInfo;
  i, J: integer;
  LowSt, HighEd : TDateTime;
  ProgStart,ProgGen,ProgFinal,ProgFinalSplit : double;
  ProdNo  : string;
begin
  J := -1;
  ProdNo := p_sc.GetFldDescr(m_id, CSC_ProdReq, false);
  for i := 0 to p_sc.StepCount(ProdNo) -1 do
  begin
    StepInfo := p_sc.GetStepByIndex(ProdNo, i);
    if StepInfo.isDeleted then
      continue;
    inc(J);
   // SGStepsView.RowCount := i + 2;
    SGStepsView.RowCount := J + 2;
    with SGStepsView do
    begin
      Cells[0,RowCount - 1] := IntToStr(StepInfo.StepNo);
      StepInfo.Wrkst := GetWorkStationForWc(StepInfo.wkCtrCode, true);

      if StepInfo.Wrkst = '' then
        Cells[1,RowCount - 1] := '-------------'
      else
        Cells[1,RowCount - 1] := StepInfo.Wrkst;

      if StepInfo.wkCtrCode = '' then
        Cells[2,RowCount - 1] := NOT_EXIST
      else
 //       Cells[2,RowCount - 1] := TMqmWrkCtr(StepInfo.wkCtrPtr).p_WrkCtrSDesc;
      Cells[2,RowCount - 1] := p_WrkctrDesc.GetSDesc(StepInfo.wkCtrCode);

      if StepInfo.StepClosed then
        Cells[3,RowCount - 1] := '  ' + _('Yes')
      else
        Cells[3,RowCount - 1] := '  ' + _('No');
      Cells[4,RowCount - 1] := FloatToStr(StepInfo.InitQty);
      Cells[5,RowCount - 1] := FloatToStr(p_sc.GetStepSchedQty(ProdNo, StepInfo.StepNo));

      Cells[6,RowCount - 1] := DateTimeToStr(StepInfo.planStart);
      p_sc.GetStepLimitDates(ProdNo, StepInfo.StepNo, LowSt, HighEd);
      if (LowSt = 0) then
         Cells[7,RowCount - 1] := NOT_EXIST
      else
        Cells[7,RowCount - 1] := DateTimeToStr(LowSt);

      Cells[8,RowCount - 1] := DateTimeToStr(StepInfo.planEnd);
      if (HighEd = 0) then
        Cells[9,RowCount - 1] := NOT_EXIST
      else
        Cells[9,RowCount - 1] := DateTimeToStr(HighEd);

      Cells[10,RowCount - 1] := FloatToStr(StepInfo.NumResPlan);

      p_sc.GetStepProgQtys(ProdNo, StepInfo.StepNo, ProgStart,ProgGen,ProgFinal,ProgFinalSplit);

      if (ProgStart = 0) then
        Cells[11,RowCount - 1] := NOT_EXIST
      else
        Cells[11,RowCount - 1] := FloatToStr(ProgStart);
      if (ProgGen = 0) then
        Cells[12,RowCount - 1] := NOT_EXIST
      else
        Cells[12,RowCount - 1] :=  FloatToStr(ProgGen);
      if (ProgFinal = 0) then
        Cells[13,RowCount - 1] := NOT_EXIST
      else
        Cells[13,RowCount - 1] :=  FloatToStr(ProgFinal);
      if (ProgFinalSplit = 0) then
        Cells[14,RowCount - 1] := NOT_EXIST
      else
        Cells[14,RowCount - 1] :=  FloatToStr(ProgFinalSplit);


//      Cells[15,RowCount - 1] := IntToStr(p_Priorities.GetPriority(StepInfo.wkCtrCode, StepInfo.wkCtrProc));
//      if Cells[15,RowCount - 1] = '-1' then
//        Cells[15,RowCount - 1] := NOT_EXIST;
      Cells[15,RowCount - 1] := NOT_EXIST;
      try
      if  Assigned(TMqmWrkCtr(StepInfo.wkCtrPtr))
      and Assigned(TMqmWrkCtr(StepInfo.wkCtrPtr).P_WkcProcList.p_ProcByName[StepInfo.wkCtrProc].RecPriority) then
        Cells[15,RowCount - 1] := TMqmWrkCtr(StepInfo.wkCtrPtr).P_WkcProcList.p_ProcByName[StepInfo.wkCtrProc].RecPriority.PrioritySeq
      else
        Cells[15,RowCount - 1] := NOT_EXIST;
      except

      end;
    end;

  end;

end;

//---------------------------------------------------------------------------------------

procedure TFStepDetails.DisplayJobsView;
var
  i, j, r: integer;
  ProdSchedInfo: TSQProdSchedInfo;
  ProdNo: string;
  WkcPriority : PTWkcPriority;
begin
  r := 1;
  ProdNo := p_sc.GetFldDescr(m_id, CSC_ProdReq, false);
  for i := 0 to p_sc.StepCount(ProdNo)-1 do
  begin
    for j := 0 to p_sc.ProdSchedCountByStepIndex(ProdNo, i)-1 do
    begin
      ProdSchedInfo := p_sc.GetStepPSByIndex(ProdNo, i, j);
      if not ProdSchedInfo.OnPlan then
        continue;

      inc(r);
      with SGJobsView do
      begin
        RowCount := r;
        Cells[0,RowCount - 1] := IntToStr(ProdSchedInfo.StepNo);
        Cells[1,RowCount - 1] := IntToStr(ProdSchedInfo.SubStepNo);
        Cells[2,RowCount - 1] := IntToStr(ProdSchedInfo.ReProcNo);
        Cells[3,RowCount - 1] := IntToStr(ProdSchedInfo.Group);

        if ProdSchedInfo.Wrkst = '' then
          Cells[4,RowCount - 1] := NOT_EXIST
        else
          Cells[4,RowCount - 1] := ProdSchedInfo.Wrkst;


        if ProdSchedInfo.wkCtrCode = '' then
          Cells[5,RowCount - 1] := NOT_EXIST
        else
          if  Assigned(ProdSchedInfo.wkCtrPtr) then
            Cells[5,RowCount - 1] := TMqmWrkCtr(ProdSchedInfo.wkCtrPtr).p_WrkCtrSDesc
          else
            Cells[5,RowCount - 1] := p_WrkctrDesc.GetSDesc(ProdSchedInfo.wkCtrCode);

        Cells[6,RowCount - 1] := ProdSchedInfo.RscCode;

        if ProdSchedInfo.ProgType <> '' then
        begin
          case StrToInt(ProdSchedInfo.ProgType) of
            1 : Cells[7,RowCount - 1] := PROG_STARTING;
            2 : Cells[7,RowCount - 1] := PROG_GENERAL;
            3 : Cells[7,RowCount - 1] := PROG_FINAL;
            4 : Cells[7,RowCount - 1] := PROG_FINAL_SPLIT;
          end;
        end;

        if Cells[7,RowCount - 1] = '' then
          Cells[7,RowCount - 1] := NOT_EXIST;

        if ProdSchedInfo.PrgSt <> 0 then
          Cells[8,RowCount - 1] := DateTimeToStr(ProdSchedInfo.PrgSt)
        else
        begin
          if (ProdSchedInfo.SchedType <> '0') then
            Cells[8,RowCount - 1] := DateTimeToStr(ProdSchedInfo.schedStart)
          else
            Cells[8,RowCount - 1] := NOT_EXIST
        end;

        if ProdSchedInfo.PrEd <> 0 then
          Cells[9,RowCount - 1] := DateTimeToStr(ProdSchedInfo.PrEd)
        else
        begin
          if (ProdSchedInfo.SchedType <> '0') then
            Cells[9,RowCount - 1] := DateTimeToStr(ProdSchedInfo.SchedEnd)
          else
            Cells[9,RowCount - 1] := NOT_EXIST
        end;

        if Cells[9,RowCount - 1] = '' then
          Cells[9,RowCount - 1] := NOT_EXIST;

        Cells[10,RowCount - 1] := FloatToStr(ProdSchedInfo.SchedQty);

        Cells[11,RowCount - 1] := FloatToStr(ProdSchedInfo.SupMinReal);
        Cells[12,RowCount - 1] := FloatToStr(ProdSchedInfo.ExeMin);

//        Cells[13,RowCount - 1] := IntToStr(p_Priorities.GetPriority(ProdSchedInfo.wkCtrCode,
//                                  ProdSchedInfo.wkCtrProc));
//        if Cells[13,RowCount - 1] = '-1' then
//          Cells[13,RowCount - 1] := NOT_EXIST;
        Cells[13,RowCount - 1] := NOT_EXIST;
        if Assigned(TMqmWrkCtr(ProdSchedInfo.wkCtrPtr)) then
        begin
          if Assigned(TMqmWrkCtr(ProdSchedInfo.wkCtrPtr).P_WkcProcList) then
          begin
            WkcPriority := PTWkcPriority(TMqmWrkCtr(ProdSchedInfo.wkCtrPtr).P_WkcProcList.p_ProcByName[ProdSchedInfo.wkCtrProc]);
            if Assigned(WkcPriority) then
               Cells[13,RowCount - 1] := WkcPriority.PrioritySeq;
          end;
        end;

      end;
    end;
  end;

end;

//---------------------------------------------------------------------------------------

procedure TFStepDetails.DisplayRelatedOrders;
var
  qry: TMqmQuery;
  Preq : string;
  tbInfoEH : ^TTblInfo;
  tbInfoEi : ^TTblInfo;
  tbInfoEC : ^TTblInfo;
  foundRec, FlagTo, FlagFrom : boolean;
begin
  foundRec := false;
  FlagTo := false;
  FlagFrom := false;
  qry := CreateQuery(Main_DB);

  tbInfoEH := @tblInfo[tbl_ext_infoHdr];
  tbInfoEi := @tblInfo[tbl_ext_info];
  tbInfoEC := @tblInfo[tbl_ext_connection];
//  SetFldPfx(tbInfoEC.pfx);

  Preq := p_sc.GetFldDescr(m_id, CSC_ProdReq, false);

  with qry do
  begin

    SQL.Clear;
    SQL.Add('select ');
    SQL.Add(CreateFld(tbInfoEC.pfx, fli_ConnCertentyLevel)    + ',');
    SQL.Add(CreateFld(tbInfoEC.pfx, fli_NumOfLevel)   + ',');
    SQL.Add(CreateFld(tbInfoEi.pfx, fli_InfoArea)   + ',');
    SQL.Add(CreateFld(tbInfoEH.pfx, fli_ConnType)   + ',');
    SQL.Add(CreateFld(tbInfoEH.pfx, fli_DueDate));
    SQL.Add(' from ' + tbInfoEH.GetTableName + ',' + tbInfoEi.GetTableName + ',' + tbInfoEC.GetTableName);
    SQL.Add(' where ' + CreateFld(tbInfoEC.pfx, fli_preqNo) + '=''' + Preq + '''');
    SQL.Add(' and '   + CreateFld(tbInfoEC.pfx,fli_ConnKey) + '=' + CreateFld(tbInfoEH.pfx, fli_ConnKey) + '');
    SQL.Add(' and ' +  CreateFld(tbInfoEC.pfx, fli_ConnKey) + '=' + CreateFld(tbInfoEi.pfx, fli_ConnKey) + '');
    SQL.Add(' Order by ' + CreateFld(tbInfoEH.pfx, fli_ConnType) + ', ');
    SQL.Add(CreateFld(tbInfoEi.pfx, fli_ConnKey) + ', ');
    SQL.Add(CreateFld(tbInfoEi.pfx, fli_infoLineNum));

    open;

    with SGRelatedOrders do
    begin
      while not qry.eof do
      begin
        foundRec := true;
        if FieldByName(CreateFld(tbInfoEH.pfx, fli_ConnType)).AsString = '1' then
        begin
          if not FlagTo then
          begin
            Cells[0,RowCount - 1] := _('To production');
            Cells[1,RowCount - 1] := DateTimeToStr(FieldByName(CreateFld(tbInfoEH.pfx, fli_DueDate)).AsDateTime);
            Cells[2,RowCount - 1] := intToStr(FieldByName(CreateFld(tbInfoEC.pfx, fli_NumOfLevel)).AsInteger);
            Cells[3,RowCount - 1] := FieldByName(CreateFld(tbInfoEC.pfx, fli_ConnCertentyLevel)).AsString;
            Cells[4,RowCount - 1] := FieldByName(CreateFld(tbInfoEi.pfx, fli_InfoArea)).AsString;
            FlagTo := true;
          end
          else
            Cells[4,RowCount - 1] := FieldByName(CreateFld(tbInfoEi.pfx, fli_InfoArea)).AsString;
        end
        else
        begin
          if not FlagFrom then
          begin
            Cells[0,RowCount - 1] := _('From production');
            Cells[1,RowCount - 1] := DateTimeToStr(FieldByName(CreateFld(tbInfoEH.pfx, fli_DueDate)).AsDateTime);
            Cells[2,RowCount - 1] := intToStr(FieldByName(CreateFld(tbInfoEC.pfx, fli_NumOfLevel)).AsInteger);
            Cells[3,RowCount - 1] := FieldByName(CreateFld(tbInfoEC.pfx, fli_ConnCertentyLevel)).AsString;
            Cells[4,RowCount - 1] := FieldByName(CreateFld(tbInfoEi.pfx, fli_InfoArea)).AsString;
            FlagFrom := true;
          end
          else
            Cells[4,RowCount - 1] := FieldByName(CreateFld(tbInfoEi.pfx, fli_InfoArea)).AsString;
        end;
        Next;
        RowCount := RowCount + 1;
      end;

       if foundRec then
         RowCount := RowCount - 1;
    end;
    close
  end;
  qry.free;
end;

//---------------------------------------------------------------------------------------

function TFStepDetails.GetProcessSDesc(wc : string ; Process : string) : string;
var
  qry: TMqmQuery;
  tbProcces : ^TTblInfo;
begin
  Result := '';
  tbProcces := @tblInfo[tbl_wkc_proc];
  qry := CreateQuery(Main_DB);

  with qry do
  begin
    SQL.Clear;
    SQL.Add('select ' + CreateFld(tbProcces.pfx,fli_SDescr) +  ' from ' + tbProcces.GetTableName + ' where ' + CreateFld(tbProcces.pfx, fli_wkCtrCode) + '=''' + WC + '''');
    SQL.Add(' and ' + CreateFld(tbProcces.pfx, fli_wkcProc) +  '=''' + Process + '''');
    open;
    Result := fieldByName(CreateFld(tbProcces.pfx, fli_SDescr)).AsString;
    Qry.Close;
  end;
  qry.Free;
end;

//---------------------------------------------------------------------------------------

procedure TFStepDetails.GetSpProgressTypes(ProdReq : string; StepId : integer ;var ProgStart : double ; var ProgGen : double ; var ProgFinal : double ; var ProgFinalSplit : double);
var
  qry: TMqmQuery;
  tbInfoSp : ^TTblInfo;
begin
  qry := CreateQuery(Main_DB);

  tbInfoSp := @tblInfo[tbl_sched_progress];

  ProgStart := 0;
  ProgGen := 0;
  ProgFinal := 0;
  ProgFinalSplit := 0;

  with qry do
  begin
    SQL.Clear;
    SQL.Add('select ' + CreateFld(tbInfoSp.pfx,fli_ProgressType) + ',' + CreateFld(tbInfoSp.pfx, fli_quant));
    SQL.Add(' from ' + tbInfoSp.GetTableName);
    SQL.Add(' where ' +  CreateFld(tbInfoSp.pfx,fli_preqNo) + '=''' + ProdReq + '''');
    SQL.Add(' and ' + CreateFld(tbInfoSp.pfx,fli_pstepId) + '=''' + IntToStr(StepId) + '''');
    open;
    first;
    while not Eof do
    begin
      case StrToInt(fieldByName(CreateFld(tbInfoSp.pfx,fli_ProgressType)).AsString) of
        1 : ProgStart := ProgStart + fieldByName(CreateFld(tbInfoSp.pfx,fli_quant)).AsFloat;
        2 : ProgGen   := ProgGen + fieldByName(CreateFld(tbInfoSp.pfx,fli_quant)).AsFloat;
        3 : ProgFinal   := ProgFinal + fieldByName(CreateFld(tbInfoSp.pfx,fli_quant)).AsFloat;
        4 : ProgFinalSplit   := ProgFinalSplit + fieldByName(CreateFld(tbInfoSp.pfx,fli_quant)).AsFloat;
      end;
      next;
    end;
    close;
  end;
  qry.Free;
end;

//---------------------------------------------------------------------------------------

procedure TFStepDetails.SetDefaultStringGridColors;
begin
  with SGStepsView do
  begin
    FixedCols        := 0;
    Color            := clInfoBk;
    FixedColor       := clGrayText;
  end;

  with StringGridGen do
  begin
    FixedCols        := 0;
    Color            := clInfoBk;
    FixedColor       := clGrayText;
  end;

  with StringGridProd do
  begin
    FixedCols        := 0;
    Color            := clInfoBk;
    FixedColor       := clGrayText;
  end;

  with StringGridMat do
  begin
    FixedCols        := 0;
    Color            := clInfoBk;
    FixedColor       := clGrayText;
  end;

  with StringGridInstr do
  begin
    FixedCols        := 0;
    Color            := clInfoBk;
    FixedColor       := clGrayText;
  end;

  with StringGridComment do
  begin
    FixedCols        := 0;
    Color            := clInfoBk;
    FixedColor       := clGrayText;
  end;

  with SGRelatedOrders do
  begin
    FixedCols        := 0;
    Color            := clInfoBk;
    FixedColor       := clGrayText;
  end;

  with StringGridOther do
  begin
    FixedCols        := 0;
    Color            := clInfoBk;
    FixedColor       := clGrayText;
  end;

  with SGJobsView do
  begin
    FixedCols        := 0;
    Color            := clInfoBk;
    FixedColor       := clGrayText;
  end;

  with SGConnectedReq do
  begin
    FixedCols        := 0;
    Color            := clInfoBk;
    FixedColor       := clGrayText;
  end;

end;

//---------------------------------------------------------------------------------------

{procedure TFStepDetails.GetInformationArea(InfoType : string ; Qry: TMqmQuery ; tbl : table);
var
  tbInfo: ^TTblInfo;
  ProdNo, ProdStep : string;
begin
  tbInfo := @tblInfo[tbl];

  ProdNo := p_sc.GetFldDescr(m_id, CSC_ProdReq);
  ProdStep := p_sc.GetFldDescr(m_id, CSC_ProdStep);

  qry.Close;
  qry.sql.Clear;
  qry.Transaction.Active := true;
  Qry.SQL.Add('select ' + CreateFld(tbInfo.pfx,fli_InfoArea) + ',' + CreateFld(tbInfo.pfx, fli_pstepId));
  qry.SQL.Add(' from ' + tbInfo.PCname + ' where ' + CreateFld(tbInfo.pfx,fli_preqNo) + '=''' + ProdNo + '''');
  qry.SQL.Add(' and ' + CreateFld(tbInfo.pfx,fli_infoType) + '=''' + InfoType + '''');
  qry.SQL.Add(' and ' + '(' + CreateFld(tbInfo.pfx,fli_pstepId) +  '=''' + ProdStep + '''');
  qry.SQL.Add(' or ' +  CreateFld(tbInfo.pfx,fli_pstepId) + '=''' + '0''' + ')');
  qry.SQL.Add(' Order by ' + CreateFld(tbInfo.pfx,fli_pstepId) + ',' + CreateFld(tbInfo.pfx,fli_infoLineNum));

  Qry.open;

end;  }

//---------------------------------------------------------------------------------------

procedure TFStepDetails.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

//---------------------------------------------------------------------------------------

procedure TFStepDetails.StringGridProdDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  if (m_SpaceProd = Arow) then
  begin
    StringGridProd.Canvas.Brush.Color := clbtnface;
    StringGridProd.Canvas.TextRect(Rect,Rect.left+2,Rect.Top+2,StringGridProd.Cells[ACol,ARow]);
  end;
end;

//---------------------------------------------------------------------------------------

procedure TFStepDetails.StringGridGenDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  if (m_SpaceGen = Arow) then
  begin
    StringGridGen.Canvas.Brush.Color := clbtnface;
    StringGridGen.Canvas.TextRect(Rect,Rect.left+2,Rect.Top+2,StringGridGen.Cells[ACol,ARow]);
  end;
end;

//---------------------------------------------------------------------------------------

procedure TFStepDetails.StringGridMatDrawCell(Sender: TObject; ACol,
                                      ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  if (m_SpaceMat = Arow) then
  begin
    StringGridMat.Canvas.Brush.Color := clbtnface;
    StringGridMat.Canvas.TextRect(Rect,Rect.left+2,Rect.Top+2,StringGridMat.Cells[ACol,ARow]);
  end;
end;

//---------------------------------------------------------------------------------------

procedure TFStepDetails.StringGridInstrDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  if (m_SpaceInst = Arow) then
  begin
    StringGridInstr.Canvas.Brush.Color := clbtnface;
    StringGridInstr.Canvas.TextRect(Rect,Rect.left+2,Rect.Top+2,StringGridInstr.Cells[ACol,ARow]);
  end;
end;

//---------------------------------------------------------------------------------------

procedure TFStepDetails.StringGridCommentDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  if (m_SpaceComent = Arow) then
  begin
    StringGridComment.Canvas.Brush.Color := clbtnface;
    StringGridComment.Canvas.TextRect(Rect,Rect.left+2,Rect.Top+2,StringGridComment.Cells[ACol,ARow]);
  end;
end;

//---------------------------------------------------------------------------------------

procedure TFStepDetails.StringGridOtherDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  if (m_SpaceOther = Arow) then
  begin
    StringGridOther.Canvas.Brush.Color := clbtnface;
    StringGridOther.Canvas.TextRect(Rect,Rect.left+2,Rect.Top+2,StringGridOther.Cells[ACol,ARow]);
  end;
end;

//---------------------------------------------------------------------------------------

procedure TFStepDetails.StringGridOtherSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var
  ProdImage : TProdImage;
begin
  if ACol = 0 then
  begin
    ProdImage := TProdImage.CreateImage(self);
    ProdImage.ShowModal;
    ProdImage.free;
  end;

end;

end.
