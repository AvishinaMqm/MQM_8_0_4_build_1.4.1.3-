unit FMBinFiltTabs;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Mask, ComCtrls, CommCtrl, ExtCtrls,
  UMSchedContFunc, gnugettext,
  CheckLst, Grids, Menus, UMwkCtr, UMBinFunc, UGPropComp, Spin, UReShape, ExSpinEdit;

type

  TTBinFilter = class(TForm)
    PageControl1: TPageControl;
    TabFiltGen: TTabSheet;
    TabProperty: TTabSheet;
    Panel1: TPanel;
    BtnOk1: TBitBtn;
    BtnAbo1: TBitBtn;
    EditTabName: TEdit;
    TabName: TLabel;
    ScrollBox1: TScrollBox;
    TabSheetDates: TTabSheet;
    LabelFromProdLDT: TLabel;
    CheckLowDate_From: TCheckBox;
    DatePickLowDate_From: TDateTimePicker;
    LblProdLDT: TLabel;
    LabelToProdLDT: TLabel;
    CheckLowDate_To: TCheckBox;
    DatePickLowDate_To: TDateTimePicker;
    LblFromProdHDT: TLabel;
    CheckDelivDate_From: TCheckBox;
    DatePickDelivDate_From: TDateTimePicker;
    LblProdHDT: TLabel;
    LblToProdHDT: TLabel;
    CheckDelivDate_To: TCheckBox;
    DatePickDelivDate_To: TDateTimePicker;
    DatePickStartDate_To: TDateTimePicker;
    LblPlannedSDT: TLabel;
    CheckStartDate_To: TCheckBox;
    LblToPlannedSDT: TLabel;
    DatePickStartDate_From: TDateTimePicker;
    CheckStartDate_From: TCheckBox;
    LblFromPlannedSDT: TLabel;
    DatePickLowStartDate_To: TDateTimePicker;
    LblLowestSDT: TLabel;
    CheckLowStartDate_To: TCheckBox;
    LblToLowestSDT: TLabel;
    DatePickLowStartDate_From: TDateTimePicker;
    CheckLowStartDate_From: TCheckBox;
    LblFromLowestSDT: TLabel;
    RadioGroupSched: TRadioGroup;
    RadioGroupClosed: TRadioGroup;
    RadioGroupReadOnly: TRadioGroup;
    RadioGroupGroups: TRadioGroup;
    RadioGroupReProcess: TRadioGroup;
    RadioGroupAlternativeWc: TRadioGroup;
    RadioGroupActivWcFromGantt: TRadioGroup;
    RGFltJobsOnGantt: TRadioGroup;
    RadioGroupPriority: TRadioGroup;
    TabSheetWarnings: TTabSheet;
    CBAfterDeliveryDate: TCheckBox;
    SpinEditAfterDeliveryDateInDays: TexSpinEdit;
    CBbeforeEarliestStart: TCheckBox;
    SpinEditBeforeEarliestStartIndays: TexSpinEdit;
    LabelBeforeEarliestStart: TLabel;
    xxx: TLabel;
    LabelAfterLatestEnd: TLabel;
    CBAfterLatestEnd: TCheckBox;
    SpinEditAfterlLatestEndInDays: TexSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    CBMaterials: TCheckBox;
    Label10: TLabel;
    CBAdditionalres: TCheckBox;
    Label11: TLabel;
    CBOveridePrevious: TCheckBox;
    Label12: TLabel;
    CBOverideNext: TCheckBox;
    Label13: TLabel;
    CBCompWithPrevJob: TCheckBox;
    Label14: TLabel;
    SpinEditCompPrevWithJobMin: TexSpinEdit;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    CBCompWithRes: TCheckBox;
    Label18: TLabel;
    CBShouldBeSched: TCheckBox;
    SpinEditCompWithResMin: TexSpinEdit;
    SpinEditShouldBeSched: TexSpinEdit;
    Label19: TLabel;
    RadioGroupProgress: TRadioGroup;
    LabelLatestendingDate: TLabel;
    Bevel4: TBevel;
    Label21: TLabel;
    Label22: TLabel;
    LabelLatestEndingDate_From: TLabel;
    LabelLatestEndingDate_To: TLabel;
    CheckLatestEndingDate_From: TCheckBox;
    DatePickerLatestEndingDate_From: TDateTimePicker;
    CheckLatestEndingDate_To: TCheckBox;
    DatePickerLatestEndingDate_To: TDateTimePicker;
    TabFiltervalues: TTabSheet;
    ScrollBox2: TScrollBox;
    CheckProdReq: TCheckBox;
    LblProdReq: TLabel;
    EditProdReqFrom: TEdit;
    ComboBoxProdType: TComboBox;
    CheckProdTyp: TCheckBox;
    CBStepType: TComboBox;
    LblProdType: TLabel;
    LblStepType: TLabel;
    CheckStepType: TCheckBox;
    CheckWC: TCheckBox;
    LabelWctr: TLabel;
    ComboBoxWC: TComboBox;
    ComboBoxProcess: TComboBox;
    LabelProcces: TLabel;
    CheckProcess: TCheckBox;
    CheckProdFamily: TCheckBox;
    LabelProdFamily: TLabel;
    EditProdFamily: TEdit;
    EditMaterialFamily: TEdit;
    LabelMaterialFamily: TLabel;
    CheckMatFamily: TCheckBox;
    EditMinStep: TEdit;
    EditMaxStep: TEdit;
    LabelMinStp: TLabel;
    CheckQty: TCheckBox;
    EditProdReqTo: TEdit;
    LabelTo: TLabel;
    Label20: TLabel;
    ComboBoxWCTo: TComboBox;
    ComboBoxProcessTo: TComboBox;
    CheckResource: TCheckBox;
    LblResource: TLabel;
    EdtResource: TEdit;
    Label24: TLabel;
    Label25: TLabel;
    EdtResourceTo: TEdit;
    Label26: TLabel;
    CheckStep: TCheckBox;
    LblStep: TLabel;
    EdtStep: TEdit;
    EdtGrpNumber: TEdit;
    LblGrpNumber: TLabel;
    CheckGrpNumber: TCheckBox;
    Label23: TLabel;
    EdtStepTo: TEdit;
    Label27: TLabel;
    EdtGrpNumberTo: TEdit;
    CheckSubStep: TCheckBox;
    LblSubstep: TLabel;
    EdtSubstep: TEdit;
    Label29: TLabel;
    EdtSubStepTo: TEdit;
    LabelMsg: TLabel;
    CBoxJobMsg: TCheckBox;
    GroupBxConfirmLevel: TGroupBox;
    CLBConLevelsToMove: TCheckListBox;
    LblDateTimeSchedCrosses: TLabel;
    LBlScheduledJobsCrossesFrom: TLabel;
    CBScheduledJobsCrosses_From: TCheckBox;
    PickerDateScheduledJobsCrosses_From: TDateTimePicker;
    LBlScheduledJobsCrossesTo: TLabel;
    CBScheduledJobsCrosses_To: TCheckBox;
    PickerDateScheduledJobsCrosses_To: TDateTimePicker;
    PickerTimeScheduledJobsCrosses_From: TDateTimePicker;
    PickerTimeScheduledJobsCrosses_To: TDateTimePicker;
    Label28: TLabel;
    CBShowImbalancedSteps: TCheckBox;
    LblActualStartDateRange: TLabel;
    LabelFromSchedulStart: TLabel;
    CheckSchedStartDate_From: TCheckBox;
    DatePickSchedStartDate_From: TDateTimePicker;
    LabelToSchedulStart: TLabel;
    CheckSchedStartDate_To: TCheckBox;
    DatePickSchedStartDate_To: TDateTimePicker;
    LblDaysFromToday: TLabel;
    LblDaysFromTodayFrom: TLabel;
    CbDaysFromTodayFrom: TCheckBox;
    LblDaysFromDodayTo: TLabel;
    CbDaysFromTodayTo: TCheckBox;
    SpinEditDaysFromTodayFrom: TexSpinEdit;
    SpinEditDaysFromTodayTo: TexSpinEdit;
    GroupBox1: TGroupBox;
    CBCustomerDate: TCheckListBox;
    LblFieldsSet: TLabel;
    TabSheetGroup: TTabSheet;
    CBoxBAllowGroupsOneJob: TCheckBox;
    ChkBxShowFirstGrplineInBin: TCheckBox;
    GrpBxShowGrpLinesInBib: TGroupBox;
    RadioContGrpGroupLines: TRadioGroup;
    CBoxBatchGroupLines: TCheckBox;
    CBGroupedBy: TComboBox;
    CBOverriddenExistingTab: TCheckBox;
    RG_ShowDependingOnNextHandledStep: TRadioGroup;
    RG_ShowDependingOnPreviousHandledStep: TRadioGroup;
    RG_ShowDependingOnNextHandledLinkedRequest: TRadioGroup;
    RG_ShowDependingOnPreviuosHandledLinkedRequest: TRadioGroup;
    Label30: TLabel;
    LblDaysFromPlanStart: TLabel;
    SpinEditDaysFromTodayPlanStartfrom: TexSpinEdit;
    Label32: TLabel;
    CbDaysToPlanStartTo: TCheckBox;
    SpinEditDaysToPlanStartTo: TexSpinEdit;
    CbDaysFromTodayPlanStartfrom: TCheckBox;
    Label33: TLabel;
    CheckEndDate_From: TCheckBox;
    DatePickEndDate_From: TDateTimePicker;
    Label34: TLabel;
    CheckEndDate_To: TCheckBox;
    DatePickEndDate_To: TDateTimePicker;
    CbDaysFromPlanEndTodayFrom: TCheckBox;
    Label35: TLabel;
    SpinEditDaysFromTodayPlanEndFrom: TexSpinEdit;
    Label36: TLabel;
    Label37: TLabel;
    CbDaysToPlanEndTodayTo: TCheckBox;
    SpinEditDaysToPlanEndTo: TexSpinEdit;
    Label31: TLabel;
    CheckBoxNextstartDate_From: TCheckBox;
    DateTimePickerNextStartDate_From: TDateTimePicker;
    CheckBoxNextsttartDate_To: TCheckBox;
    DateTimePickerNextStartDate_To: TDateTimePicker;
    CheckBoxNextstartFromToday: TCheckBox;
    CheckBoxNextstartDaysTo: TCheckBox;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label43: TLabel;
    SpinEditNextstartDaysFromToday: TexSpinEdit;
    SpinEditNextstartDaysTo: TexSpinEdit;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    SpinEditPrevEndDaysTo: TexSpinEdit;
    CheckBoxPrevEndDaysTo: TCheckBox;
    SpinEditPrevEndDaysFromToday: TexSpinEdit;
    CheckBoxPrevEndFromToday: TCheckBox;
    DateTimePickerPrevEndDate_To: TDateTimePicker;
    CheckBoxPrevEndDate_To: TCheckBox;
    DateTimePickerPrevEndDate_From: TDateTimePicker;
    CheckBoxPrevEndDate_From: TCheckBox;
    Label53: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label48: TLabel;
    Label52: TLabel;
    Label47: TLabel;
    BtnOk: TcxButton;
    BtnAbo: TcxButton;
    LblFixedDate: TLabel;
    DateTimePickerDaysFromTodayTo_time: TDateTimePicker;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    Label54: TLabel;
    Label55: TLabel;
    cbDaysfromEarliest_from: TCheckBox;
    seDaysfromEarliest_from: TExSpinEdit;
    Label56: TLabel;
    cbDaysfromEarliest_to: TCheckBox;
    seDaysfromEarliest_to: TExSpinEdit;
    Label57: TLabel;
    cbFixedDateEarliest_from: TCheckBox;
    Label58: TLabel;
    dtFixedDateEarliest_from: TDateTimePicker;
    Label59: TLabel;
    cbFixedDateEarliest_to: TCheckBox;
    Label60: TLabel;
    dtFixedDateEarliest_To: TDateTimePicker;
    GroupBox7: TGroupBox;
    GroupBox8: TGroupBox;
    GroupBox9: TGroupBox;
    GroupBox10: TGroupBox;
    TSWarp: TTabSheet;
    LblItemTypeCodeBaseWarp: TLabel;
    LblItemProductCodeBaseWarp: TLabel;
    EditItemTypeCodeBaseWarp: TEdit;
    EditProductCodeBaseWarp: TEdit;
    LblItemTypeCodeSecondWarp: TLabel;
    EditItemTypeCodeSecondWarp: TEdit;
    EditProductCodeSecondWarp: TEdit;
    LblItemProductCodeSecondWarp: TLabel;
    lblWrkGrpoup: TLabel;
    CheckWkcGrp: TCheckBox;
    cbWkcGrp: TComboBox;
    Label61: TLabel;
    Label65: TLabel;
    cbPlant: TComboBox;
    cbDivision: TComboBox;
    LabelHalted: TLabel;
    cbIgnoredProgress: TCheckBox;
    procedure BtnOk1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DatePickDelivDate_FromChange(Sender: TObject);
    procedure DatePickDelivDate_ToChange(Sender: TObject);
    procedure DatePickLowDate_FromChange(Sender: TObject);
    procedure DatePickLowDate_ToChange(Sender: TObject);
    procedure DatePickLowStartDate_FromChange(Sender: TObject);
    procedure DatePickLowStartDate_ToChange(Sender: TObject);
    procedure DatePickStartDate_FromChange(Sender: TObject);
    procedure DatePickStartDate_ToChange(Sender: TObject);
    procedure ComboBoxWCChange(Sender: TObject);
    procedure CheckNumeric(Sender: TObject; var Key: WideChar);
    procedure DatePickSchedStartDate_FromChange(Sender: TObject);
    procedure DatePickSchedStartDate_ToChange(Sender: TObject);
    procedure DatePickerLatestEndingDate_FromChange(Sender: TObject);
    procedure DatePickerLatestEndingDate_ToChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure ComboBoxWCToChange(Sender: TObject);
    procedure EdtStepKeyPress(Sender: TObject; var Key: Char);
    procedure CLBConLevelsToMoveClickCheck(Sender: TObject);
    procedure PickerDateScheduledJobsCrosses_FromChange(Sender: TObject);
    procedure PickerDateScheduledJobsCrosses_ToChange(Sender: TObject);
    procedure SpinEditDaysFromTodayFromChange(Sender: TObject);
    procedure SpinEditDaysFromTodayToChange(Sender: TObject);
    procedure SpinEditDaysFromTodayPlanStartfromChange(Sender: TObject);
    procedure SpinEditNextstartDaysToChange(Sender: TObject);
    procedure SpinEditDaysToPlanStartToClick(Sender: TObject);
    procedure DatePickEndDate_FromChange(Sender: TObject);
    procedure DatePickEndDate_ToChange(Sender: TObject);
    procedure SpinEditDaysFromTodayPlanEndFromChange(Sender: TObject);
    procedure SpinEditDaysToPlanEndToChange(Sender: TObject);
    procedure DateTimePickerNextStartDate_FromChange(Sender: TObject);
    procedure DateTimePickerNextStartDate_ToChange(Sender: TObject);
    procedure SpinEditNextstartDaysFromTodayChange(Sender: TObject);
    procedure DateTimePickerPrevEndDate_FromChange(Sender: TObject);
    procedure DateTimePickerPrevEndDate_ToChange(Sender: TObject);
    procedure SpinEditPrevEndDaysFromTodayChange(Sender: TObject);
    procedure SpinEditPrevEndDaysToChange(Sender: TObject);
    procedure BtnAboClick(Sender: TObject);
    procedure PageControl1DrawTab(Control: TCustomTabControl; TabIndex: Integer;
      const Rect: TRect; Active: Boolean);
    procedure dtFixedDateEarliest_fromChange(Sender: TObject);
    procedure dtFixedDateEarliest_ToChange(Sender: TObject);
    procedure seDaysfromEarliest_fromChange(Sender: TObject);
    procedure seDaysfromEarliest_toChange(Sender: TObject);
    procedure ScrollBox3MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);

  private
    m_ListWC : TList;
    m_Parmflt : TBinFilterParms;
    m_Id     : TSchedID;
    m_SrchType : CSearchTabs;
    m_ListProces : TstringList;
    m_TabName : string;
    LblResCat : TLabel;
    EdtResCat : TEdit;

    procedure InitWidth_Lbl;
    procedure SetAllWc;
    procedure GetAllWcProc;
    procedure InitCBStepType;
    procedure GetProdType;
    procedure InitFields;
    procedure InitJobFilter;
    procedure InitDefaultRadioGroup;
    procedure ReadBoolFromSearchJob;
    procedure WriteBoolToSearchJob;
    procedure HideCheckBox;
    function  GetWcObjByCode(code: string): TMqmWrkCtr;
    procedure SetTabName;
    procedure UpdateGroupedByFilter(GroupedBy_Code : string);
    procedure CleanSearchParams;

  public
    m_PropComp : TPropComponent;
    constructor CreateBinFilter(AOwner: TComponent; Parmflt: TBinFilterParms; TabName: string ;
                 PropType : TPropGridType ; SchedID : TSchedID; SRChType : CSearchTabs);
    function  GetTabName: string;
    function  SearchForWc(typ: string): integer;
    function  searchForProces(typ: string): integer;
    function  SearchForStpType(typ: CScSchedType): integer;
    function  SearchForProdTyp(typ: string): integer;
    procedure SetFilter(GroupedBy_Code : string);
    function  CheckDataforProp (var str : string) : boolean;
    procedure InitFilter;
    procedure SetDefaultBinFilter;
  end;

implementation

uses
  inifiles,
  UMArticle,
  UMCompat,
  DMsrvPC,
  Variants,
  UMPlan,
  UMObjCont,
  UMglobal,
  FMGroupedByFieldsConfig,
  UMTblDesc,
  FMbin,
  UMCompatSrv,
  UGGlobal;

{$R *.DFM}

{ TTBinFilter }

const
  // dont need to be translated , names for ini file.
  IniName = 'SearchProd.ini';
  CBProdReq = 'Search Production';
  CBProdTyp = 'Search Prod Type';
  CBStepTyp = 'Search Step Type';
  CBWC = 'Search Wc';
  CBPrcs = 'Search Process';
  CBProdFamily = 'Search prod family';
  CBMatFamily = 'Search Mat Family';
  CBStepGroup = 'Search Step Group';
  CBProdLine = 'Search Prod Line';
  CBQty = 'Search Qty';
  CBStepId = 'Search Step';
  CBSubStepId = 'Search Sub Step';
  CBGroupNum  = 'Search Group Number';

//----------------------------------------------------------------------------//

constructor TTBinFilter.CreateBinFilter(AOwner : TComponent; Parmflt: TBinFilterParms ;TabName : string ;
             PropType : TPropGridType ; SchedID : TSchedID ; SRChType : CSearchTabs);
begin
  inherited Create(AOwner);
  m_Parmflt := Parmflt;
  m_TabName := Trim(TabName);
  m_Id := SchedID;
  m_SrchType := SRChType;
  m_PropComp := TPropComponent.CreatePropComp(TabProperty,PropType,nil,m_Id, nil, nil);
end;

//----------------------------------------------------------------------------//

procedure TTBinFilter.SetTabName;
begin
  if m_TabName <> '' then
    EditTabName.Text := m_TabName
  else
  begin
    if (m_Id <> CSchedIDnull) and (m_SrchType = CSR_Prod_Req) then
      EditTabName.Text := p_sc.GetFldDescr(m_Id, CSC_ProdReq, false)
    else if (m_Id <> CSchedIDnull) and (m_SrchType = CSR_Prod_Type) then
      EditTabName.Text := p_sc.GetFldDescr(M_Id, CSC_ProdType, false)
    else if (m_Id <> CSchedIDnull) and (m_SrchType = CSR_Step_Type) then
      EditTabName.Text := CBStepType.Items[SearchForStpType(p_sc.GetJobType(M_Id))]
    else if (m_Id <> CSchedIDnull) and (m_SrchType = CSR_WorkCntr) then
    begin
      if p_sc.GetExtLinkPtr(m_Id) <> nil then
        EditTabName.Text := p_sc.GetFldDescr(M_Id, CSC_WkctCode, false)
      else
        EditTabName.Text := p_sc.GetFldDescr(M_Id, CSC_PlanWkctCode, false);
    end
    else if (m_Id <> CSchedIDnull) and (m_SrchType = CSR_Process) then
    begin
      if p_sc.GetExtLinkPtr(m_Id) <> nil then
        EditTabName.Text := p_sc.GetFldDescr(M_Id, CSC_WkctProc, false)
      else
        EditTabName.Text := p_sc.GetFldDescr(M_Id, CSC_PlanWkctProc, false);
    end
    else if (m_Id <> CSchedIDnull) and (m_SrchType = CSR_Prod_Family) then
      EditTabName.Text := p_sc.GetFldDescr(M_Id, CSC_ProdFamily, false)
    else if (m_Id <> CSchedIDnull) and (m_SrchType = CSR_Mat_Family) then
      EditTabName.Text := p_sc.GetFldDescr(M_Id, CSC_ProdMatFamily, false)
    else if (m_Id <> CSchedIDnull) and (m_SrchType = CSR_Rsc) then
      EditTabName.Text := p_sc.GetFldDescr(M_Id, CSC_Rsc, false)
    else if (m_Id <> CSchedIDnull) and (m_SrchType = CSR_Qty) then
      EditTabName.Text := p_sc.GetFldDescr(M_Id, CSC_IniQty, false)
  end;

  // Default name
  if (EditTabName.Text = '') and Assigned(Fbin) then
    EditTabName.Text := Fbin.SetDefaultTabName      //EditTabName.Text := _('Bin View');
  else if m_TabName <> '' then
    EditTabName.Text := m_TabName  // _('Bin View');
  else if EditTabName.Text <> '' then
    EditTabName.Text := EditTabName.Text;
end;

//----------------------------------------------------------------------------//

procedure TTBinFilter.UpdateGroupedByFilter(GroupedBy_Code : string);
var
  GroupedByFieldSet : PTGroupedByFieldSet;
  I : integer;
  Properties : TProperties;
  CodeProp : string;
  JobVal : variant;
begin
  GroupedByFieldSet := GetGroupBySetByCode(GroupedBy_Code);
  if FiltProdReq in GroupedByFieldSet.GroupedByOption then
  begin
    m_Parmflt.RecFilt.ProdReq := p_sc.GetFldDescr(m_Id, CSC_ProdReq, false);
    Include(m_Parmflt.RecFilt.Options, FiltProdReq);
  end;

  if FiltProdFamily in GroupedByFieldSet.GroupedByOption then
  begin
    m_Parmflt.RecFilt.ProductFamily := p_sc.GetFldDescr(M_Id, CSC_ProdFamily, false);
    Include(m_Parmflt.RecFilt.Options, FiltProdFamily);
  end;

  m_Parmflt.RecFilt.IsPropEnter := false;
  for I := Low(GroupedByFieldSet.PropCode) to High(GroupedByFieldSet.PropCode) do
  begin
    if GroupedByFieldSet.PropCode[I] <> '' then
    begin
      m_Parmflt.RecFilt.IsPropEnter := true;
      break
    end;
  end;

  if m_Parmflt.RecFilt.IsPropEnter then
  begin
    Include(m_Parmflt.RecFilt.Options, FiltProp);
    m_Parmflt.ClearFiltPropList;
    m_Parmflt.ClearPropRecFields;
    for I := 1 to 10 do
    begin
      Properties := p_sc.GetProperties(m_Id,nil);
      if not Assigned(Properties) then continue;
      if not Properties.GetValforCode(GroupedByFieldSet.PropCode[I -1], '', -1, JobVal) then
        continue;
      if vartostr(JobVal) <> '' then
      begin
        m_Parmflt.SetPropValue(GroupedByFieldSet.PropCode[I -1],
                          '',
                          JobVal,
                          JobVal);

        m_Parmflt.RecFilt.PropCod[I] := GroupedByFieldSet.PropCode[I -1];
        m_Parmflt.RecFilt.PropRes[I] := '';
        m_Parmflt.RecFilt.PropValfrom[I] := vartostr(JobVal);
        m_Parmflt.RecFilt.PropValTo[I] := vartostr(JobVal);
      end;
    end;
  end
  else
  begin
    m_Parmflt.ClearPropRecFields;
    Exclude(m_Parmflt.RecFilt.Options, FiltProp);
  end;


end;

//----------------------------------------------------------------------------//

procedure TTBinFilter.SpinEditDaysFromTodayFromChange(Sender: TObject);
begin
//  CbDaysFromTodayFrom.Checked := true;
end;

procedure TTBinFilter.SpinEditDaysFromTodayPlanEndFromChange(Sender: TObject);
begin
  CbDaysFromPlanEndTodayFrom.Checked := true;
end;

procedure TTBinFilter.SpinEditDaysFromTodayPlanStartfromChange(Sender: TObject);
begin
  CbDaysFromTodayPlanStartfrom.Checked := true;
end;

//----------------------------------------------------------------------------//

procedure TTBinFilter.SpinEditDaysFromTodayToChange(Sender: TObject);
begin
//  CbDaysFromTodayTo.Checked := true;
end;

procedure TTBinFilter.SpinEditDaysToPlanEndToChange(Sender: TObject);
begin
  CbDaysToPlanEndTodayTo.Checked := true
end;

procedure TTBinFilter.SpinEditDaysToPlanStartToClick(Sender: TObject);
begin
  CbDaysToPlanStartTo.Checked := true
end;

procedure TTBinFilter.SpinEditNextstartDaysFromTodayChange(Sender: TObject);
begin
  CheckBoxNextstartFromToday.Checked := true;
end;

procedure TTBinFilter.SpinEditNextstartDaysToChange(Sender: TObject);
begin
  CheckBoxNextstartDaysTo.Checked := true
end;

procedure TTBinFilter.SpinEditPrevEndDaysFromTodayChange(Sender: TObject);
begin
  CheckBoxPrevEndFromToday.Checked := true
end;

procedure TTBinFilter.SpinEditPrevEndDaysToChange(Sender: TObject);
begin
  CheckBoxPrevEndDaysTo.Checked := true
end;

//----------------------------------------------------------------------------//

procedure TTBinFilter.CleanSearchParams;
begin
  Exclude(m_Parmflt.RecFilt.Options, FiltProdReq);
  m_Parmflt.RecFilt.Resource := '';

  Exclude(m_Parmflt.RecFilt.Options, FiltStepId);
  m_Parmflt.RecFilt.StepId := -1;

  Exclude(m_Parmflt.RecFilt.Options, FiltStepIdTo);
  m_Parmflt.RecFilt.StepIdTo := -1;

  Exclude(m_Parmflt.RecFilt.Options, FiltSubStepId);
  m_Parmflt.RecFilt.SubStepId := -1;

  Exclude(m_Parmflt.RecFilt.Options, FiltSubStepIdTo);
  m_Parmflt.RecFilt.SubStepIdTo := -1;

  Exclude(m_Parmflt.RecFilt.Options, FiltGroupNum);
  m_Parmflt.RecFilt.GroupNum := 1234;

  Exclude(m_Parmflt.RecFilt.Options, FiltGroupNumTo);
  m_Parmflt.RecFilt.GroupNumTo := 1234;

  Exclude(m_Parmflt.RecFilt.Options, FiltProdType);
  m_Parmflt.RecFilt.ProdType := '';

  Exclude(m_Parmflt.RecFilt.Options, FiltStepType);
  m_Parmflt.RecFilt.StepType := CST_undef;

  Exclude(m_Parmflt.RecFilt.Options, FiltWkcr);
  m_Parmflt.RecFilt.wkCtrCode := '';

  Exclude(m_Parmflt.RecFilt.Options, FlitProcces);
  m_Parmflt.RecFilt.wkcProc := '';

  Exclude(m_Parmflt.RecFilt.Options, FiltWkcrTo);
  m_Parmflt.RecFilt.wkCtrCodeTo := '';

  Exclude(m_Parmflt.RecFilt.Options, FlitProccesTo);
  m_Parmflt.RecFilt.wkcProcTo := '';

  Exclude(m_Parmflt.RecFilt.Options, FiltProdFamily);
  m_Parmflt.RecFilt.ProductFamily := '';

  Exclude(m_Parmflt.RecFilt.Options, FiltMaterialFamily);
  m_Parmflt.RecFilt.MaterialFamily := '';

  Exclude(m_Parmflt.RecFilt.Options, FiltResource);
  m_Parmflt.RecFilt.Resource := '';

  Exclude(m_Parmflt.RecFilt.Options, FiltResourceTo);
  m_Parmflt.RecFilt.ResourceTo := '';

  Exclude(m_Parmflt.RecFilt.Options, FiltQty);
  m_Parmflt.RecFilt.MinQty := -1;
  m_Parmflt.RecFilt.MaxQty := -1;

  Exclude(m_Parmflt.RecFilt.Options, FiltAfterDeliveryInDays);
  m_Parmflt.RecFilt.AfterDeliveryInDays := -1;

  Exclude(m_Parmflt.RecFilt.Options, FiltBeforeEarliestStartInDays);
  m_Parmflt.RecFilt.BeforeEarliestStartIndays := -1;

  Exclude(m_Parmflt.RecFilt.Options, FiltAfterLatestEndInDays);
  m_Parmflt.RecFilt.AfterLatestEndInDays := -1;

  Exclude(m_Parmflt.RecFilt.Options, FiltBeforeEarliestStartInDaysFixed);
  m_Parmflt.RecFilt.EarliestDays_From := -1;

  Exclude(m_Parmflt.RecFilt.Options, FiltCompWithPrevJobInCase);
  m_Parmflt.RecFilt.CompWithPrevJobInCase := -1;

  Exclude(m_Parmflt.RecFilt.Options, FiltCompWithResInCase);
  m_Parmflt.RecFilt.CompWithResInCase := -1;

  Exclude(m_Parmflt.RecFilt.Options, FiltJobMsg);
  m_Parmflt.RecFilt.JobMsg := false;

  Exclude(m_Parmflt.RecFilt.Options, FiltAfterDeliveryInDays);
  m_Parmflt.RecFilt.AfterDeliveryInDays := -1;

  Exclude(m_Parmflt.RecFilt.Options, FiltBeforeEarliestStartInDays);
  m_Parmflt.RecFilt.BeforeEarliestStartIndays := -1;

  Exclude(m_Parmflt.RecFilt.Options, FiltAfterLatestEndInDays);
  m_Parmflt.RecFilt.AfterLatestEndInDays := -1;

  Exclude(m_Parmflt.RecFilt.Options, FiltCompWithPrevJobInCase);
  m_Parmflt.RecFilt.CompWithPrevJobInCase := -1;

  Exclude(m_Parmflt.RecFilt.Options, FiltShouldBeScheduledIndays);
  m_Parmflt.RecFilt.ShouldBeScheduledIndays := -1;

  Exclude(m_Parmflt.RecFilt.Options, FiltAfterDeliveryInDays);
  m_Parmflt.RecFilt.AfterDeliveryInDays := -1;

  Exclude(m_Parmflt.RecFilt.Options, FiltBeforeEarliestStartInDays);
  m_Parmflt.RecFilt.BeforeEarliestStartIndays := -1;

  Exclude(m_Parmflt.RecFilt.Options, FiltAfterLatestEndInDays);
  m_Parmflt.RecFilt.AfterLatestEndInDays := -1;

  Exclude(m_Parmflt.RecFilt.Options, FiltCompWithPrevJobInCase);
  m_Parmflt.RecFilt.CompWithPrevJobInCase := -1;

  Exclude(m_Parmflt.RecFilt.Options, FiltShouldBeScheduledIndays);
  m_Parmflt.RecFilt.ShouldBeScheduledIndays := -1;

  Exclude(m_Parmflt.RecFilt.Options, FiltConfLevelsfinal);
  Exclude(m_Parmflt.RecFilt.Options, FiltConfLevelsIni);
  Exclude(m_Parmflt.RecFilt.Options, FiltConfLevels1);
  Exclude(m_Parmflt.RecFilt.Options, FiltConfLevels2);
  Exclude(m_Parmflt.RecFilt.Options, FiltConfLevels3);
  Exclude(m_Parmflt.RecFilt.Options, FiltConfLevels4);
  Exclude(m_Parmflt.RecFilt.Options, FiltConfLevels5);
  Exclude(m_Parmflt.RecFilt.Options, FiltConfLevels5);
  Exclude(m_Parmflt.RecFilt.Options, FiltCustomerDateConfirmed);
  Exclude(m_Parmflt.RecFilt.Options, FiltCustomerDateCulculated);
  Exclude(m_Parmflt.RecFilt.Options, FiltCustomerDateRequested);

  Exclude(m_Parmflt.RecFilt.Options, FiltItemTypeBaseWarp);
  Exclude(m_Parmflt.RecFilt.Options, FiltProdCodeBaseWarp);

  Exclude(m_Parmflt.RecFilt.Options, FiltIgnoredProg);
  m_Parmflt.RecFilt.IgnoredProg := false;

  //grouping
  Exclude(m_Parmflt.RecFilt.Options, FiltWkcrGrp);
  m_Parmflt.RecFilt.wkCtrGroup := '';
  Exclude(m_Parmflt.RecFilt.Options, FiltWkcrPlant);
  m_Parmflt.RecFilt.wkCtrPlant := '';
  Exclude(m_Parmflt.RecFilt.Options, FiltWkcrDivision);
  m_Parmflt.RecFilt.wkCtrDivision := '';
end;

//----------------------------------------------------------------------------//

procedure TTBinFilter.SetDefaultBinFilter;
begin
  Include(m_Parmflt.RecFilt.Options, FiltWkcr_Active);
  Include(m_Parmflt.RecFilt.Options, FiltWkcrAlterntiv);
  Include(m_Parmflt.RecFilt.Options, FiltSchedJobs);
  Include(m_Parmflt.RecFilt.Options, FiltFltJobsOnGantt);
  Include(m_Parmflt.RecFilt.Options, FiltProgress);
  Include(m_Parmflt.RecFilt.Options, Filt_ReadOnly);
  Exclude(m_Parmflt.RecFilt.Options, FiltReProcces);
  Exclude(m_Parmflt.RecFilt.Options, FiltClosedJobs);
  Include(m_Parmflt.RecFilt.Options, FiltJobPriority);
end;

//----------------------------------------------------------------------------//

procedure TTBinFilter.InitFilter;
var
  I : integer;
  tmStart : TDateTime;
begin
  if FiltProdReq in m_Parmflt.RecFilt.Options then
    EditProdReqFrom.Text := m_Parmflt.RecFilt.ProdReq;

  if FiltProdReqTo in m_Parmflt.RecFilt.Options then
    EditProdReqTo.Text := m_Parmflt.RecFilt.ProdReqTo;

  if FiltStepId in m_Parmflt.RecFilt.Options then
    EdtStep.Text := IntToStr(m_Parmflt.RecFilt.StepId);

  if FiltStepIdTo in m_Parmflt.RecFilt.Options then
    EdtStepTo.Text := IntToStr(m_Parmflt.RecFilt.StepIdTo);

  if FiltSubStepId in m_Parmflt.RecFilt.Options then
    EdtSubStep.Text := IntToStr(m_Parmflt.RecFilt.SubStepId);

  if FiltSubStepIdTo in m_Parmflt.RecFilt.Options then
    EdtSubStepTo.Text := IntToStr(m_Parmflt.RecFilt.SubStepIdTo);

  if FiltGroupNum in m_Parmflt.RecFilt.Options then
    EdtGrpNumber.Text := IntToStr(m_Parmflt.RecFilt.GroupNum);

  if FiltGroupNumTo in m_Parmflt.RecFilt.Options then
    EdtGrpNumberTo.Text := IntToStr(m_Parmflt.RecFilt.GroupNumTo);

  if FiltResource in m_Parmflt.RecFilt.Options then
    EdtResource.Text := m_Parmflt.RecFilt.Resource;

  if FiltResourceTo in m_Parmflt.RecFilt.Options then
    EdtResourceTo.Text := m_Parmflt.RecFilt.ResourceTo;

  if FiltResCat in m_Parmflt.RecFilt.Options then
    EdtResCat.Text := m_Parmflt.RecFilt.ResCatCode;

  if FiltProdFamily in m_Parmflt.RecFilt.Options then
    EditProdFamily.Text := m_Parmflt.RecFilt.ProductFamily;

  if FiltMaterialFamily in m_Parmflt.RecFilt.Options then
    EditMaterialFamily.Text := m_Parmflt.RecFilt.MaterialFamily;

  if FiltReProcces in m_Parmflt.RecFilt.Options then
    RadioGroupReProcess.ItemIndex := 1
  else
    RadioGroupReProcess.ItemIndex := 0;

  if FiltJobPriority in m_Parmflt.RecFilt.Options then
    RadioGroupPriority.ItemIndex := 1
  else
    RadioGroupPriority.ItemIndex := 0;

  if FiltSchedJobs in m_Parmflt.RecFilt.Options then
    RadioGroupSched.ItemIndex := 1
  else if FiltOnlySchedJobs in m_Parmflt.RecFilt.Options then
    RadioGroupSched.ItemIndex := 2
  else
    RadioGroupSched.ItemIndex := 0;

  if FiltFltJobsOnGantt in m_Parmflt.RecFilt.Options then
    RGFltJobsOnGantt.ItemIndex := 1
  else
    RGFltJobsOnGantt.ItemIndex := 0;

  if FiltClosedJobs in m_Parmflt.RecFilt.Options then
    RadioGroupClosed.ItemIndex := 1
  else if FiltOnlyClosedJobs in m_Parmflt.RecFilt.Options then
    RadioGroupClosed.ItemIndex := 2
  else
    RadioGroupClosed.ItemIndex := 0;

  if FiltProgress in m_Parmflt.RecFilt.Options then
    RadioGroupProgress.ItemIndex := 1
  else if FiltOnlyProgress in m_Parmflt.RecFilt.Options then
    RadioGroupProgress.ItemIndex := 2
  else
    RadioGroupProgress.ItemIndex := 0;

  if Filt_ReadOnly in m_Parmflt.RecFilt.Options then
    RadioGroupReadOnly.ItemIndex := 1
  else if FiltOnlyReadOnly in m_Parmflt.RecFilt.Options then
    RadioGroupReadOnly.ItemIndex := 2
  else
    RadioGroupReadOnly.ItemIndex := 0;

  if FiltGroups in m_Parmflt.RecFilt.Options then
    RadioGroupGroups.ItemIndex := 1
  else if FiltOnlyGroups in m_Parmflt.RecFilt.Options then
    RadioGroupGroups.ItemIndex := 2
  else
    RadioGroupGroups.ItemIndex := 0;

  if FiltQty in m_Parmflt.RecFilt.Options then
  begin
    EditMinStep.Text := floatToStr(m_Parmflt.RecFilt.MinQty);
    if m_Parmflt.RecFilt.MaxQty <> -1 then
      EditMaxStep.Text := FloatToStr(m_Parmflt.RecFilt.MaxQty);
  end;

  if FiltWkcrAlterntiv in m_Parmflt.RecFilt.Options then
    RadioGroupAlternativeWc.ItemIndex := 1
  else
    RadioGroupAlternativeWc.ItemIndex := 0;

  if FiltStepType in m_Parmflt.RecFilt.Options then
    CBStepType.ItemIndex := SearchForStpType(m_Parmflt.RecFilt.StepType);

  if FiltProdType in m_Parmflt.RecFilt.Options then
    ComboBoxProdType.ItemIndex := SearchForProdTyp(m_Parmflt.RecFilt.ProdType);

  if FiltWkcr in m_Parmflt.RecFilt.Options then
  begin
    ComboBoxWC.ItemIndex := SearchForWc(m_Parmflt.RecFilt.wkCtrCode);
    ComboBoxWCChange(self);
  end;

  if FlitProcces in m_Parmflt.RecFilt.Options then
    ComboBoxProcess.ItemIndex := SearchForProces(m_Parmflt.RecFilt.wkcProc);

  if FiltWkcrTo in m_Parmflt.RecFilt.Options then
  begin
    ComboBoxWCTo.ItemIndex := SearchForWc(m_Parmflt.RecFilt.wkCtrCodeTo);
    ComboBoxWCToChange(self);
  end;

  if FlitProccesTo in m_Parmflt.RecFilt.Options then
    ComboBoxProcessTo.ItemIndex := SearchForProces(m_Parmflt.RecFilt.wkcProcTo);

  if FiltWkcr_Active in m_Parmflt.RecFilt.Options then
    RadioGroupActivWcFromGantt.ItemIndex := 1
  else
    RadioGroupActivWcFromGantt.ItemIndex := 0;

  if FiltLowDate in m_Parmflt.RecFilt.Options then
  begin
    if m_Parmflt.RecFilt.ProdLowDate_From <> 0 then
    begin
      CheckLowDate_From.Checked := true;
      DatePickLowDate_From.Date := m_Parmflt.RecFilt.ProdLowDate_From;
    end;
    if m_Parmflt.RecFilt.ProdLowDate_To <> 0 then
    begin
      DatePickLowDate_To.Date := m_Parmflt.RecFilt.ProdLowDate_To;
      CheckLowDate_To.Checked := true;
    end;
  end;

  if FiltDeliveryDate in m_Parmflt.RecFilt.Options then
  begin
    if m_Parmflt.RecFilt.ProdDelivDate_From <> 0 then
    begin
      CheckDelivDate_From.Checked := true;
      DatePickDelivDate_From.Date := m_Parmflt.RecFilt.ProdDelivDate_From;
    end;
    if m_Parmflt.RecFilt.ProdDelivDate_To <> 0 then
    begin
      DatePickDelivDate_To.Date := m_Parmflt.RecFilt.ProdDelivDate_To;
      CheckDelivDate_To.Checked := true;
    end;
  end;

  if FiltLowStartDate in m_Parmflt.RecFilt.Options then
  begin
    if m_Parmflt.RecFilt.LowStartDate_From <> 0 then
    begin
      CheckLowStartDate_From.Checked := true;
      DatePickLowStartDate_From.Date := m_Parmflt.RecFilt.LowStartDate_From;
    end;
    if m_Parmflt.RecFilt.LowStartDate_To <> 0 then
    begin
      DatePickLowStartDate_To.Date := m_Parmflt.RecFilt.LowStartDate_To;
      CheckLowStartDate_To.Checked := true;
    end;
  end;

  if FiltPlanStartDate in m_Parmflt.RecFilt.Options then
  begin
    if m_Parmflt.RecFilt.PlanStartDate_From <> 0 then
    begin
      CheckStartDate_From.Checked := true;
      DatePickStartDate_From.Date := m_Parmflt.RecFilt.PlanStartDate_From;
    end;
    if m_Parmflt.RecFilt.PlanStartDate_To <> 0 then
    begin
      DatePickStartDate_To.Date := m_Parmflt.RecFilt.PlanStartDate_To;
      CheckStartDate_To.Checked := true;
    end;
  end;

  if FiltPlanStartDate_DaysFromToday in m_Parmflt.RecFilt.Options then
  begin
    if m_Parmflt.RecFilt.PlanStartDate_DaysFromToday > -1 then
    begin
      CbDaysFromTodayPlanStartfrom.Checked := true;
      SpinEditDaysFromTodayPlanStartfrom.Value := m_Parmflt.RecFilt.PlanStartDate_DaysFromToday;
    end;
    if m_Parmflt.RecFilt.PlanStartDate_DaysTillToday > -1 then
    begin
      CbDaysToPlanStartTo.Checked := true;
      SpinEditDaysToPlanStartTo.Value := m_Parmflt.RecFilt.PlanStartDate_DaysTillToday;
    end;
  end;

  if FiltPlanEndDate in m_Parmflt.RecFilt.Options then
  begin
    if m_Parmflt.RecFilt.PlanEndDate_From <> 0 then
    begin
      CheckEndDate_From.Checked := true;
      DatePickEndDate_From.Date := m_Parmflt.RecFilt.PlanEndDate_From;
    end;
    if m_Parmflt.RecFilt.PlanEndDate_To <> 0 then
    begin
      DatePickEndDate_To.Date := m_Parmflt.RecFilt.PlanEndDate_To;
      CheckEndDate_To.Checked := true;
    end;
  end;

  if FiltPlanEndDate_DaysFromToday in m_Parmflt.RecFilt.Options then
  begin
    if m_Parmflt.RecFilt.PlanEndDate_DaysFromToday > -1 then
    begin
      CbDaysFromPlanEndTodayFrom.Checked := true;
      SpinEditDaysFromTodayPlanEndFrom.Value := m_Parmflt.RecFilt.PlanEndDate_DaysFromToday;
    end;
    if m_Parmflt.RecFilt.PlanEndDate_DaysTillToday > -1 then
    begin
      CbDaysToPlanEndTodayTo.Checked := true;
      SpinEditDaysToPlanEndTo.Value := m_Parmflt.RecFilt.PlanEndDate_DaysTillToday;
    end;
  end;

  if FiltNextStartDate in m_Parmflt.RecFilt.Options then
  begin
    if m_Parmflt.RecFilt.NextStartDate_From <> 0 then
    begin
      CheckBoxNextstartDate_From.Checked := true;
      DateTimePickerNextStartDate_From.Date := m_Parmflt.RecFilt.NextStartDate_From;
    end;
    if m_Parmflt.RecFilt.NextStartDate_To <> 0 then
    begin
      DateTimePickerNextStartDate_To.Date := m_Parmflt.RecFilt.NextStartDate_To;
      CheckBoxNextsttartDate_To.Checked := true;
    end;
  end;

  if FiltNextStartDate_DaysFromToday in m_Parmflt.RecFilt.Options then
  begin
    if m_Parmflt.RecFilt.NextStartDate_DaysFromToday > -1 then
    begin
      CheckBoxNextstartFromToday.Checked := true;
      SpinEditNextstartDaysFromToday.Value := m_Parmflt.RecFilt.NextStartDate_DaysFromToday;
    end;
    if m_Parmflt.RecFilt.NextStartDate_DaysTillToday > -1 then
    begin
      CheckBoxNextstartDaysTo.Checked := true;
      SpinEditNextstartDaysTo.Value := m_Parmflt.RecFilt.NextStartDate_DaysTillToday;
    end;
  end;

  if FiltprevEndDate in m_Parmflt.RecFilt.Options then
  begin
    if m_Parmflt.RecFilt.PrevEndDate_From <> 0 then
    begin
      CheckBoxPrevendDate_From.Checked := true;
      DateTimePickerPrevEndDate_From.Date := m_Parmflt.RecFilt.PrevEndDate_From;
    end;
    if m_Parmflt.RecFilt.PrevEndDate_To <> 0 then
    begin
      DateTimePickerPrevEndDate_To.Date := m_Parmflt.RecFilt.PrevEndDate_To;
      CheckBoxPrevEndDate_To.Checked := true;
    end;
  end;

  if FiltPrevEndDate_DaysFromToday in m_Parmflt.RecFilt.Options then
  begin
    if m_Parmflt.RecFilt.PrevEndDate_DaysFromToday > -1 then
    begin
      CheckBoxPrevEndFromToday.Checked := true;
      SpinEditPrevEndDaysFromToday.Value := m_Parmflt.RecFilt.PrevEndDate_DaysFromToday;
    end;
    if m_Parmflt.RecFilt.PrevEndDate_DaysTillToday > -1 then
    begin
      CheckBoxPrevEndDaysTo.Checked := true;
      SpinEditPrevEndDaysTo.Value := m_Parmflt.RecFilt.PrevEndDate_DaysTillToday;
    end;
  end;

  if FiltSchedStartDate in m_Parmflt.RecFilt.Options then
  begin
    if m_Parmflt.RecFilt.SchedStartDate_From <> 0 then
    begin
      CheckSchedStartDate_From.Checked := true;
      DatePickSchedStartDate_From.Date := m_Parmflt.RecFilt.SchedStartDate_From;
    end;
    if m_Parmflt.RecFilt.SchedStartDate_To <> 0 then
    begin
      CheckSchedStartDate_To.Checked := true;
      DatePickSchedStartDate_To.Date := m_Parmflt.RecFilt.SchedStartDate_To;
    end;
  end;

  if FiltSchedStartDate_Days in m_Parmflt.RecFilt.Options then
  begin
    if m_Parmflt.RecFilt.SchedStartDate_DaysFromToday > -1 then
    begin
      CbDaysFromTodayFrom.Checked := true;
      SpinEditDaysFromTodayFrom.Value := m_Parmflt.RecFilt.SchedStartDate_DaysFromToday;
    end;
    if m_Parmflt.RecFilt.SchedStartDate_DaysTillToday > -1 then
    begin
      CbDaysFromTodayTo.Checked := true;
      SpinEditDaysFromTodayTo.Value := m_Parmflt.RecFilt.SchedStartDate_DaysTillToday;
      tmStart := Frac(m_Parmflt.RecFilt.SchedStartDate_DaysTillToday_time/60/24);
      DateTimePickerDaysFromTodayTo_time.Time := Frac(tmStart);
    end;
  end;

  if FiltBeforeEarliestStartFixed in m_Parmflt.RecFilt.Options then
  begin
    if m_Parmflt.RecFilt.FixedEarliestDate_From <> 0 then
    begin
      cbFixedDateEarliest_from.Checked := true;
      dtFixedDateEarliest_from.Date := m_Parmflt.RecFilt.FixedEarliestDate_From;
    end;
    if m_Parmflt.RecFilt.FixedEarliestDate_To <> 0 then
    begin
      cbFixedDateEarliest_To.Checked := true;
      dtFixedDateEarliest_To.Date := m_Parmflt.RecFilt.FixedEarliestDate_To;
    end;
  end;

  if FiltBeforeEarliestStartInDaysFixed in m_Parmflt.RecFilt.Options then
  begin
    if m_Parmflt.RecFilt.EarliestDays_From > -1 then
    begin
      cbDaysfromEarliest_from.Checked := true;
      seDaysfromEarliest_from.Value := m_Parmflt.RecFilt.EarliestDays_From;
    end;
    if m_Parmflt.RecFilt.EarliestDays_To > -1 then
    begin
      cbDaysfromEarliest_To.Checked := true;
      seDaysfromEarliest_To.Value := m_Parmflt.RecFilt.EarliestDays_To;
    end;
  end;

  if FiltScheduledJobsCrossesDateTime in m_Parmflt.RecFilt.Options then
  begin
    if m_Parmflt.RecFilt.ScheduleJobsCrosses_From <> 0 then
    begin
      CBScheduledJobsCrosses_From.Checked := true;
      PickerDateScheduledJobsCrosses_From.Date := trunc(m_Parmflt.RecFilt.ScheduleJobsCrosses_From);
      PickerTimeScheduledJobsCrosses_From.Time := Frac(m_Parmflt.RecFilt.ScheduleJobsCrosses_From);
    end;
    if m_Parmflt.RecFilt.ScheduleJobsCrosses_To <> 0 then
    begin
      CBScheduledJobsCrosses_To.Checked := true;
      PickerDateScheduledJobsCrosses_To.Date := trunc(m_Parmflt.RecFilt.ScheduleJobsCrosses_To);
      PickerTimeScheduledJobsCrosses_To.Time := Frac(m_Parmflt.RecFilt.ScheduleJobsCrosses_To);
    end;
  end;

  if FiltLatestEndingDate in m_Parmflt.RecFilt.Options then
  begin
    if m_Parmflt.RecFilt.LatestEndingDate_From <> 0 then
    begin
      CheckLatestEndingDate_From.Checked := true;
      DatePickerLatestEndingDate_From.Date := m_Parmflt.RecFilt.LatestEndingDate_From;
    end;
    if m_Parmflt.RecFilt.LatestEndingDate_To <> 0 then
    begin
      CheckLatestEndingDate_To.Checked := true;
      DatePickerLatestEndingDate_To.Date := m_Parmflt.RecFilt.LatestEndingDate_To;
    end;
  end;

  if FiltProp in m_Parmflt.RecFilt.Options then
  begin
    for I := low(m_Parmflt.RecFilt.PropCod) to High(m_Parmflt.RecFilt.PropCod) do
    begin
      if (m_Parmflt.RecFilt.PropCod[I] <> '')
      and CheckPropExist(m_Parmflt.RecFilt.PropCod[I]) then
      begin
        if (I = 1) then
          m_PropComp.SetPropVal(m_Parmflt.RecFilt.PropCod[I],I,true)
        else
          m_PropComp.SetPropVal(m_Parmflt.RecFilt.PropCod[I],I,false);
        if m_Parmflt.RecFilt.PropRes[I] <> '' then
          m_PropComp.SetPropRes(m_Parmflt.RecFilt.PropRes[I],I);
        if m_Parmflt.RecFilt.PropValfrom[I] <> '' then
          m_PropComp.SetValFrom(m_Parmflt.RecFilt.PropValfrom[I],I);
        if m_Parmflt.RecFilt.PropValTo[I] <> '' then
          m_PropComp.SetValTo(m_Parmflt.RecFilt.PropValTo[I],I);
      end;
    end;
  end;

  if FiltAfterDeliveryDay in m_Parmflt.RecFilt.Options then
    CBAfterDeliveryDate.Checked := true
  else
    CBAfterDeliveryDate.Checked := false;

  if FiltAfterDeliveryInDays in m_Parmflt.RecFilt.Options then
    SpinEditAfterDeliveryDateInDays.Value := m_Parmflt.RecFilt.AfterDeliveryInDays
  else
    SpinEditAfterDeliveryDateInDays.Value := m_Parmflt.RecFilt.AfterDeliveryInDays;

  if FiltBeforeEarliestStart in m_Parmflt.RecFilt.Options then
    CBbeforeEarliestStart.Checked := true
  else
    CBbeforeEarliestStart.Checked := false;

  if FiltBeforeEarliestStartInDays in m_Parmflt.RecFilt.Options then
    SpinEditBeforeEarliestStartInDays.Value := m_Parmflt.RecFilt.BeforeEarliestStartInDays
  else
    SpinEditBeforeEarliestStartInDays.Value := m_Parmflt.RecFilt.BeforeEarliestStartInDays;

  if FiltAfterLatestEndInDays in m_Parmflt.RecFilt.Options then
    SpinEditAfterlLatestEndInDays.Value := m_Parmflt.RecFilt.AfterLatestEndInDays
  else
    SpinEditAfterlLatestEndInDays.Value := m_Parmflt.RecFilt.AfterLatestEndInDays;

  if FiltBeforeEarliestStartFixed in m_Parmflt.RecFilt.Options then
    cbFixedDateEarliest_from.Checked := True
  else
    cbFixedDateEarliest_from.Checked := False;

  if FiltBeforeEarliestStartInDaysFixed in m_Parmflt.RecFilt.Options then
    seDaysfromEarliest_from.Value := m_Parmflt.RecFilt.EarliestDays_From
  else
    seDaysfromEarliest_to.Value := m_Parmflt.RecFilt.EarliestDays_to;

  if FiltAfterLatestEnd in m_Parmflt.RecFilt.Options then
    CBAfterLatestEnd.Checked := true
  else
    CBAfterLatestEnd.Checked := false;

  if FiltMissingmaterials in m_Parmflt.RecFilt.Options then
    CBMaterials.Checked := true
  else
    CBMaterials.Checked := false;

  if FiltMissingAddRes in m_Parmflt.RecFilt.Options then
    CBAdditionalRes.Checked := true
  else
    CBAdditionalRes.Checked := false;

  if FiltOveridePrevious in m_Parmflt.RecFilt.Options then
    CBOveridePrevious.Checked := true
  else
    CBOveridePrevious.Checked := false;

  if FiltOverideNext in m_Parmflt.RecFilt.Options then
    CBOverideNext.Checked := true
  else
    CBOverideNext.Checked := false;

  if FiltCompWithPrevJob in m_Parmflt.RecFilt.Options then
    CBCompWithPrevJob.Checked := true
  else
    CBCompWithPrevJob.Checked := false;

  if FiltCompWithRes in m_Parmflt.RecFilt.Options then
    CBCompWithRes.Checked := true
  else
    CBCompWithRes.Checked := false;

  if FiltImbalancedSteps in m_Parmflt.RecFilt.Options then
    CBShowImbalancedSteps.Checked := true
  else
    CBShowImbalancedSteps.Checked := false;

  if FiltJobMsg in m_Parmflt.RecFilt.Options then
    CBoxJobMsg.Checked := true
  else
    CBoxJobMsg.Checked := false;

  if not (FiltConfLevNewLog in m_Parmflt.RecFilt.Options) then
  begin
    if not (FiltFix in m_Parmflt.RecFilt.Options) and not (FiltTemporary in m_Parmflt.RecFilt.Options) then
    begin
      if CLBConLevelsToMove.Items.Count > 0 then
        CLBConLevelsToMove.Checked[0] := true;
      if CLBConLevelsToMove.Items.Count > 1 then
        CLBConLevelsToMove.Checked[1] := true;
      if CLBConLevelsToMove.Items.Count > 2 then
        CLBConLevelsToMove.Checked[2] := true;
      if CLBConLevelsToMove.Items.Count > 3 then
        CLBConLevelsToMove.Checked[3] := true;
      if CLBConLevelsToMove.Items.Count > 4 then
        CLBConLevelsToMove.Checked[4] := true;
      if CLBConLevelsToMove.Items.Count > 5 then
        CLBConLevelsToMove.Checked[5] := true;
      if CLBConLevelsToMove.Items.Count > 6 then
        CLBConLevelsToMove.Checked[6] := true;
    end
    else if (FiltFix in m_Parmflt.RecFilt.Options) then
    begin
      if CLBConLevelsToMove.Items.Count > 0 then
        CLBConLevelsToMove.Checked[0] := true;
    end
    else if (FiltTemporary in m_Parmflt.RecFilt.Options) then
    begin
      if CLBConLevelsToMove.Items.Count > 1 then
        CLBConLevelsToMove.Checked[1] := true;
      if CLBConLevelsToMove.Items.Count > 2 then
        CLBConLevelsToMove.Checked[2] := true;
      if CLBConLevelsToMove.Items.Count > 3 then
        CLBConLevelsToMove.Checked[3] := true;
      if CLBConLevelsToMove.Items.Count > 4 then
        CLBConLevelsToMove.Checked[4] := true;
      if CLBConLevelsToMove.Items.Count > 5 then
        CLBConLevelsToMove.Checked[5] := true;
      if CLBConLevelsToMove.Items.Count > 6 then
        CLBConLevelsToMove.Checked[6] := true;
    end;
    Include(m_Parmflt.RecFilt.Options, FiltConfLevNewLog);
  end
  else
  begin
    if (FiltConfLevelsfinal in m_Parmflt.RecFilt.Options) and (CLBConLevelsToMove.Items.Count > 0) then
      CLBConLevelsToMove.Checked[0] := true
    else if CLBConLevelsToMove.Items.Count > 0 then
      CLBConLevelsToMove.Checked[0] := false;
    if (FiltConfLevelsIni in m_Parmflt.RecFilt.Options) and (CLBConLevelsToMove.Items.Count > 1) then
      CLBConLevelsToMove.Checked[1] := true
    else if CLBConLevelsToMove.Items.Count > 1 then
      CLBConLevelsToMove.Checked[1] := false;
  end;

  if (FiltConfLevels1 in m_Parmflt.RecFilt.Options) and (CLBConLevelsToMove.Items.Count > 2) then
     CLBConLevelsToMove.Checked[2] := true
  else if CLBConLevelsToMove.Items.Count > 2 then
     CLBConLevelsToMove.Checked[2] := false;

  if (FiltConfLevels2 in m_Parmflt.RecFilt.Options) and (CLBConLevelsToMove.Items.Count > 3) then
    CLBConLevelsToMove.Checked[3] := true
  else if CLBConLevelsToMove.Items.Count > 3 then
    CLBConLevelsToMove.Checked[3] := false;

  if (FiltConfLevels3 in m_Parmflt.RecFilt.Options) and (CLBConLevelsToMove.Items.Count > 4) then
    CLBConLevelsToMove.Checked[4] := true
  else if CLBConLevelsToMove.Items.Count > 4 then
    CLBConLevelsToMove.Checked[4] := false;

  if (FiltConfLevels4 in m_Parmflt.RecFilt.Options) and (CLBConLevelsToMove.Items.Count > 5) then
    CLBConLevelsToMove.Checked[5] := true
  else if CLBConLevelsToMove.Items.Count > 5 then
    CLBConLevelsToMove.Checked[5] := false;

  if (FiltConfLevels5 in m_Parmflt.RecFilt.Options) and (CLBConLevelsToMove.Items.Count > 6) then
    CLBConLevelsToMove.Checked[6] := true
  else if CLBConLevelsToMove.Items.Count > 6 then
    CLBConLevelsToMove.Checked[6] := false;

  if (FiltCustomerDateConfirmed in m_Parmflt.RecFilt.Options) then
    CBCustomerDate.Checked[0] := true
  else
    CBCustomerDate.Checked[0] := false;
  if (FiltCustomerDateCulculated in m_Parmflt.RecFilt.Options) then
    CBCustomerDate.Checked[1] := true
  else
    CBCustomerDate.Checked[1] := false;
  if (FiltCustomerDateRequested in m_Parmflt.RecFilt.Options) then
    CBCustomerDate.Checked[2] := true
  else
    CBCustomerDate.Checked[2] := false;

  if (FiltShouldBeScheduled in m_Parmflt.RecFilt.Options) then
    CBShouldBeSched.Checked := true
  else
    CBShouldBeSched.Checked := false;

  if FiltCompWithPrevJobInCase in m_Parmflt.RecFilt.Options then
    SpinEditCompPrevWithJobMin.Value := m_Parmflt.RecFilt.CompWithPrevJobInCase
  else
    SpinEditCompPrevWithJobMin.Value := m_Parmflt.RecFilt.CompWithPrevJobInCase;

  if FiltCompWithResInCase in m_Parmflt.RecFilt.Options then
    SpinEditCompWithResMin.Value := m_Parmflt.RecFilt.CompWithResInCase
  else
    SpinEditCompWithResMin.Value := m_Parmflt.RecFilt.CompWithResInCase;

  if FiltShouldBeScheduledIndays in m_Parmflt.RecFilt.Options then
    SpinEditShouldBeSched.Value := m_Parmflt.RecFilt.ShouldBeScheduledIndays
  else
    SpinEditShouldBeSched.Value := m_Parmflt.RecFilt.ShouldBeScheduledIndays;

  ChkBxShowFirstGrplineInBin.Checked     := m_Parmflt.RecFilt.ShowFirstGrplineInBin;
  CBoxBAllowGroupsOneJob.Checked         := m_Parmflt.RecFilt.AutoGroupSingleJob;
  CBoxBatchGroupLines.Checked            := m_Parmflt.RecFilt.ShowBatchGroupLinesInBin;

  if m_Parmflt.RecFilt.ShowContinueGroupLinesInBin = CsSCG_No then
     RadioContGrpGroupLines.ItemIndex      :=  0
  else if m_Parmflt.RecFilt.ShowContinueGroupLinesInBin = CsSCG_Yes then
     RadioContGrpGroupLines.ItemIndex      :=  1
  else
     RadioContGrpGroupLines.ItemIndex      :=  2;

  if m_Parmflt.RecFilt.ShowDependingOnNextHandledStep = CsAlways then
    RG_ShowDependingOnNextHandledStep.ItemIndex := 0
  else if m_Parmflt.RecFilt.ShowDependingOnNextHandledStep = CsWhenNotScheduled then
    RG_ShowDependingOnNextHandledStep.ItemIndex := 1
  else
    RG_ShowDependingOnNextHandledStep.ItemIndex := 2;

  if m_Parmflt.RecFilt.ShowDependingOnPrevHandledStep = CsAlways then
    RG_ShowDependingOnPreviousHandledStep.ItemIndex := 0
  else if m_Parmflt.RecFilt.ShowDependingOnPrevHandledStep = CsWhenNotScheduled then
    RG_ShowDependingOnPreviousHandledStep.ItemIndex := 1
  else
    RG_ShowDependingOnPreviousHandledStep.ItemIndex := 2;

  if m_Parmflt.RecFilt.ShowDependingOnNextHandledLinkedRequest = CsAlways then
    RG_ShowDependingOnNextHandledLinkedRequest.ItemIndex := 0
  else if m_Parmflt.RecFilt.ShowDependingOnNextHandledLinkedRequest = CsWhenNotScheduled then
    RG_ShowDependingOnNextHandledLinkedRequest.ItemIndex := 1
  else
    RG_ShowDependingOnNextHandledLinkedRequest.ItemIndex := 2;

  if m_Parmflt.RecFilt.ShowDependingOnPrevHandledLinkedRequest = CsAlways then
    RG_ShowDependingOnPreviuosHandledLinkedRequest.ItemIndex := 0
  else if m_Parmflt.RecFilt.ShowDependingOnPrevHandledLinkedRequest = CsWhenNotScheduled then
    RG_ShowDependingOnPreviuosHandledLinkedRequest.ItemIndex := 1
  else
    RG_ShowDependingOnPreviuosHandledLinkedRequest.ItemIndex := 2;

  if m_Parmflt.RecFilt.ItemTypeCodeBaseWarp <> '' then
    EditItemTypeCodeBaseWarp.text := m_Parmflt.RecFilt.ItemTypeCodeBaseWarp;

  if m_Parmflt.RecFilt.ProdCodeBaseWarp <> '' then
    EditProductCodeBaseWarp.text := m_Parmflt.RecFilt.ProdCodeBaseWarp;

  if m_Parmflt.RecFilt.ItemTypeCodeSecondWarp <> '' then
    EditItemTypeCodeSecondWarp.text := m_Parmflt.RecFilt.ItemTypeCodeSecondWarp;

  if m_Parmflt.RecFilt.ProdCodeSecondWarp <> '' then
    EditProductCodeSecondWarp.text := m_Parmflt.RecFilt.ProdCodeSecondWarp;


  //grouping
  if m_Parmflt.RecFilt.wkCtrGroup <> '' then
    cbWkcGrp.ItemIndex := cbWkcGrp.Items.IndexOf(m_Parmflt.RecFilt.wkCtrGroup);

  if m_Parmflt.RecFilt.wkCtrPlant <> '' then
    cbPlant.ItemIndex := cbPlant.Items.IndexOf(m_Parmflt.RecFilt.wkCtrPlant);

  if m_Parmflt.RecFilt.wkCtrDivision <> '' then
    cbDivision.ItemIndex := cbDivision.Items.IndexOf(m_Parmflt.RecFilt.wkCtrDivision);

  if FiltIgnoredProg in m_Parmflt.RecFilt.Options then
    cbIgnoredProgress.Checked := true
  else
    cbIgnoredProgress.Checked := false;

end;

//----------------------------------------------------------------------------//

procedure TTBinFilter.SetFilter(GroupedBy_Code : string);
var
  I : Integer;
  Year, Month, Day, Hour, Min, Sec, MSec : Word;
begin

  CleanSearchParams;

  if (m_SrchType = CSR_New) then
  begin

    if EditProdReqFrom.Text <> '' then
    begin
      Include(m_Parmflt.RecFilt.Options, FiltProdReq);
      m_Parmflt.RecFilt.ProdReq := EditProdReqFrom.Text;
    end
    else
    begin
      Exclude(m_Parmflt.RecFilt.Options, FiltProdReq);
      m_Parmflt.RecFilt.ProdReq := '';
    end;

    if EditProdReqTo.Text <> '' then
    begin
      Include(m_Parmflt.RecFilt.Options, FiltProdReqTo);
      m_Parmflt.RecFilt.ProdReqTo := EditProdReqTo.Text;
    end
    else
    begin
      Exclude(m_Parmflt.RecFilt.Options, FiltProdReqTo);
      m_Parmflt.RecFilt.ProdReqTo := '';
    end;

    if EdtStep.Text <> '' then
    begin
      Include(m_Parmflt.RecFilt.Options, FiltStepId);
      try
        m_Parmflt.RecFilt.StepId := StrToInt(EdtStep.Text);
      Except
        m_Parmflt.RecFilt.StepId := 0;
      end;
    end
    else
    begin
      Exclude(m_Parmflt.RecFilt.Options, FiltStepId);
      m_Parmflt.RecFilt.StepId := -1;
    end;

    if EdtStepTo.Text <> '' then
    begin
      Include(m_Parmflt.RecFilt.Options, FiltStepIdTo);
      try
        m_Parmflt.RecFilt.StepIdTo := StrToInt(EdtStepTo.Text);
      Except
        m_Parmflt.RecFilt.StepIdTo := 0;
      end;
    end
    else
    begin
      Exclude(m_Parmflt.RecFilt.Options, FiltStepIdTo);
      m_Parmflt.RecFilt.StepIdTo := -1;
    end;

    if EdtSubStep.Text <> '' then
    begin
      Include(m_Parmflt.RecFilt.Options, FiltSubStepId);
      try
        m_Parmflt.RecFilt.SubStepId := StrToInt(EdtSubStep.Text);
      Except
        m_Parmflt.RecFilt.SubStepId := 0;
      end;
    end
    else
    begin
      Exclude(m_Parmflt.RecFilt.Options, FiltSubStepId);
      m_Parmflt.RecFilt.SubStepId := -1;
    end;

    if EdtSubStepTo.Text <> '' then
    begin
      Include(m_Parmflt.RecFilt.Options, FiltSubStepIdTo);
      try
        m_Parmflt.RecFilt.SubStepIdTo := StrToInt(EdtSubStepTo.Text);
      Except
        m_Parmflt.RecFilt.SubStepIdTo := 0;
      end;
    end
    else
    begin
      Exclude(m_Parmflt.RecFilt.Options, FiltSubStepIdTo);
      m_Parmflt.RecFilt.SubStepIdTo := -1;
    end;

    if EdtGrpNumber.Text <> '' then
    begin
      Include(m_Parmflt.RecFilt.Options, FiltGroupNum);
      try
        m_Parmflt.RecFilt.GroupNum := StrToInt(EdtGrpNumber.Text);
      Except
        m_Parmflt.RecFilt.GroupNum := 1234;
      end;
    end
    else
    begin
      Exclude(m_Parmflt.RecFilt.Options, FiltGroupNum);
      m_Parmflt.RecFilt.GroupNum := 1234;
    end;

    if EdtGrpNumberTo.Text <> '' then
    begin
      Include(m_Parmflt.RecFilt.Options, FiltGroupNumTo);
      try
        m_Parmflt.RecFilt.GroupNumTo := StrToInt(EdtGrpNumberTo.Text);
      Except
        m_Parmflt.RecFilt.GroupNumTo := 1234;
      end;
    end
    else
    begin
      Exclude(m_Parmflt.RecFilt.Options, FiltGroupNumTo);
      m_Parmflt.RecFilt.GroupNumTo := 1234;
    end;

    if ComboBoxProdType.Items[ComboBoxProdType.ItemIndex] <> '' then
    begin
      Include(m_Parmflt.RecFilt.Options, FiltProdType);
      m_Parmflt.RecFilt.ProdType := ComboBoxProdType.Items[ComboBoxProdType.ItemIndex];
    end;

    m_Parmflt.RecFilt.StepType := CScSchedType(CBStepType.Items.Objects[CBStepType.ItemIndex]);
    if m_Parmflt.RecFilt.StepType <> CST_undef then
      Include(m_Parmflt.RecFilt.Options, FiltStepType);

    if ComboBoxWC.Items[ComboBoxWC.ItemIndex] <> '' then
    begin
      Include(m_Parmflt.RecFilt.Options, FiltWkcr);
      m_Parmflt.RecFilt.wkCtrCode := ComboBoxWC.Items[ComboBoxWC.ItemIndex];
    end;

    if ComboBoxProcess.Items[ComboBoxProcess.ItemIndex] <> '' then
    begin
      Include(m_Parmflt.RecFilt.Options, FlitProcces);
      m_Parmflt.RecFilt.wkcProc := ComboBoxProcess.Items[ComboBoxProcess.ItemIndex];
    end;

    if ComboBoxWCTo.Items[ComboBoxWCTo.ItemIndex] <> '' then
    begin
      Include(m_Parmflt.RecFilt.Options, FiltWkcrTo);
      m_Parmflt.RecFilt.wkCtrCodeTo := ComboBoxWCTo.Items[ComboBoxWCTo.ItemIndex];
    end;

    if ComboBoxProcessTo.Items[ComboBoxProcessTo.ItemIndex] <> '' then
    begin
      Include(m_Parmflt.RecFilt.Options, FlitProccesTo);
      m_Parmflt.RecFilt.wkcProcTo := ComboBoxProcessTo.Items[ComboBoxProcessTo.ItemIndex];
    end;

    if EditProdFamily.Text <> '' then
    begin
      Include(m_Parmflt.RecFilt.Options, FiltProdFamily);
      m_Parmflt.RecFilt.ProductFamily := EditProdFamily.Text;
    end;

    if EditMaterialFamily.Text <> '' then
    begin
      Include(m_Parmflt.RecFilt.Options, FiltMaterialFamily);
      m_Parmflt.RecFilt.MaterialFamily := EditMaterialFamily.Text;
    end;

    if EdtResource.Text <> '' then
    begin
      Include(m_Parmflt.RecFilt.Options, FiltResource);
      m_Parmflt.RecFilt.Resource := EdtResource.Text;
    end;

    if EdtResourceTo.Text <> '' then
    begin
      Include(m_Parmflt.RecFilt.Options, FiltResourceTo);
      m_Parmflt.RecFilt.ResourceTo := EdtResourceTo.Text;
    end;

    if EdtResCat.Text <> '' then
    begin
      Include(m_Parmflt.RecFilt.Options, FiltResCat);
      m_Parmflt.RecFilt.ResCatCode := EdtResCat.Text;
    end;

    if EditMinStep.Text <> '' then
    begin
      Include(m_Parmflt.RecFilt.Options, FiltQty);
      m_Parmflt.RecFilt.MinQty := StrToFloat(EditMinStep.Text);
    end;

    if EditMaxStep.Text <> '' then
      m_Parmflt.RecFilt.MaxQty := StrToFloat(EditMaxStep.text)

  end

  else if (m_Id <> CSchedIDnull) and (m_SrchType = CSR_FullProdReq) then
  begin
    WriteBoolToSearchJob;

    if (CheckProdReq.checked) and (EditProdReqFrom.Text <> '') then
    begin
      Include(m_Parmflt.RecFilt.Options, FiltProdReq);
      m_Parmflt.RecFilt.ProdReq := EditProdReqFrom.Text;
    end;

    if (CheckProdReq.checked) and (EditProdReqTo.Text <> '') then
    begin
      Include(m_Parmflt.RecFilt.Options, FiltProdReqTo);
      m_Parmflt.RecFilt.ProdReqTo := EditProdReqTo.Text;
    end;

    if (CheckStep.checked) and (EdtStep.Text <> '') then
    begin
      Include(m_Parmflt.RecFilt.Options, FiltStepId);
      try
        m_Parmflt.RecFilt.StepId := StrToInt(EdtStep.Text);
      except
        m_Parmflt.RecFilt.StepId := -1;
      end;
    end;

    if (CheckSubStep.checked) and (EdtSubStep.Text <> '') then
    begin
      Include(m_Parmflt.RecFilt.Options, FiltSubStepId);
      try
        m_Parmflt.RecFilt.SubStepId := StrToInt(EdtSubStep.Text);
      except
        m_Parmflt.RecFilt.SubStepId := -1;
      end;
    end;

    if (CheckGrpNumber.checked) and (EdtGrpNumber.Text <> '') then
    begin
      Include(m_Parmflt.RecFilt.Options, FiltGroupNum);
      try
        m_Parmflt.RecFilt.GroupNum := StrToInt(EdtGrpNumber.Text);
      except
        m_Parmflt.RecFilt.GroupNum := 1234;
      end;
    end;

    if (CheckProdTyp.Checked) and (ComboBoxProdType.Items[ComboBoxProdType.ItemIndex] <> '') then
    begin
      Include(m_Parmflt.RecFilt.Options, FiltProdType);
      m_Parmflt.RecFilt.ProdType := ComboBoxProdType.Items[ComboBoxProdType.ItemIndex];
    end;

    m_Parmflt.RecFilt.StepType := CScSchedType(CBStepType.Items.Objects[CBStepType.ItemIndex]);
    if (CheckStepType.Checked) and (m_Parmflt.RecFilt.StepType <> CST_undef) then
      Include(m_Parmflt.RecFilt.Options, FiltStepType);

    if (CheckWC.Checked) and (ComboBoxWC.Items[ComboBoxWC.ItemIndex] <> '') then
    begin
      Include(m_Parmflt.RecFilt.Options, FiltWkcr);
      m_Parmflt.RecFilt.wkCtrCode := ComboBoxWC.Items[ComboBoxWC.ItemIndex];
    end;

    if (CheckProcess.Checked) and (ComboBoxProcess.Items[ComboBoxProcess.ItemIndex] <> '') then
    begin
      Include(m_Parmflt.RecFilt.Options, FlitProcces);
      m_Parmflt.RecFilt.wkcProc := ComboBoxProcess.Items[ComboBoxProcess.ItemIndex];
    end;

    if (CheckWC.Checked) and (ComboBoxWCTo.Items[ComboBoxWCTo.ItemIndex] <> '') then
    begin
      Include(m_Parmflt.RecFilt.Options, FiltWkcrTo);
      m_Parmflt.RecFilt.wkCtrCodeTo := ComboBoxWCTo.Items[ComboBoxWCTo.ItemIndex];
    end;

    if (CheckProcess.Checked) and (ComboBoxProcessTo.Items[ComboBoxProcessTo.ItemIndex] <> '') then
    begin
      Include(m_Parmflt.RecFilt.Options, FlitProccesTo);
      m_Parmflt.RecFilt.wkcProcTo := ComboBoxProcessTo.Items[ComboBoxProcessTo.ItemIndex];
    end;

    if (CheckProdFamily.Checked) and (EditProdFamily.Text <> '') then
    begin
      Include(m_Parmflt.RecFilt.Options, FiltProdFamily);
      m_Parmflt.RecFilt.ProductFamily := EditProdFamily.Text;
    end;

    if (CheckMatFamily.Checked) and (EditMaterialFamily.Text <> '') then
    begin
      Include(m_Parmflt.RecFilt.Options, FiltMaterialFamily);
      m_Parmflt.RecFilt.MaterialFamily := EditMaterialFamily.Text;
    end;

    if (CheckResource.Checked) and (EdtResource.Text <> '') then
    begin
      Include(m_Parmflt.RecFilt.Options, FiltResource);
      m_Parmflt.RecFilt.Resource := EdtResource.Text;
    end;

    if (CheckResource.Checked) and (EdtResourceTo.Text <> '') then
    begin
      Include(m_Parmflt.RecFilt.Options, FiltResourceTo);
      m_Parmflt.RecFilt.ResourceTo := EdtResourceTo.Text;
    end;

    if EdtResCat.Text <> '' then
    begin
      Include(m_Parmflt.RecFilt.Options, FiltResCat);
      m_Parmflt.RecFilt.ResCatCode := EdtResCat.Text;
    end;

    if (CheckQty.Checked) and (EditMinStep.Text <> '') then
    begin
      Include(m_Parmflt.RecFilt.Options, FiltQty);
      m_Parmflt.RecFilt.MinQty := StrToFloat(EditMinStep.Text);
    end;

    if EditMaxStep.Text <> '' then
      m_Parmflt.RecFilt.MaxQty := StrToFloat(EditMaxStep.text)
  end

  else if (m_Id <> CSchedIDnull) and (m_SrchType = CSR_Prod_Req) then
  begin
    m_Parmflt.RecFilt.ProdReq := p_sc.GetFldDescr(m_Id, CSC_ProdReq, false);
    Include(m_Parmflt.RecFilt.Options, FiltProdReq);
  end

  else if (m_Id <> CSchedIDnull) and (m_SrchType = CSR_Prod_Type) then
  begin
    m_Parmflt.RecFilt.ProdType := p_sc.GetFldDescr(M_Id, CSC_ProdType, false);
    Include(m_Parmflt.RecFilt.Options, FiltProdType);
  end

  else if (m_Id <> CSchedIDnull) and (m_SrchType = CSR_Step_Type) then
  begin
    m_Parmflt.RecFilt.StepType := p_sc.GetJobType(M_Id);
    Include(m_Parmflt.RecFilt.Options, FiltStepType);
  end

  else if (m_Id <> CSchedIDnull) and (m_SrchType = CSR_WorkCntr) then
  begin
    if p_sc.GetExtLinkPtr(m_Id) <> nil then
      m_Parmflt.RecFilt.wkCtrCode := p_sc.GetFldDescr(M_Id, CSC_WkctCode, false)
    else
      m_Parmflt.RecFilt.wkCtrCode := p_sc.GetFldDescr(M_Id, CSC_PlanWkctCode, false);
    Include(m_Parmflt.RecFilt.Options, FiltWkcr);
  end

  else if (m_Id <> CSchedIDnull) and (m_SrchType = CSR_Process) then
  begin
    if p_sc.GetExtLinkPtr(m_Id) <> nil then
      m_Parmflt.RecFilt.wkcProc := p_sc.GetFldDescr(M_Id, CSC_WkctProc, false)
    else
      m_Parmflt.RecFilt.wkcProc := p_sc.GetFldDescr(M_Id, CSC_PlanWkctProc, false);
    Include(m_Parmflt.RecFilt.Options, FlitProcces);
  end

  else if (m_Id <> CSchedIDnull) and (m_SrchType = CSR_Prod_Family) then
  begin
    m_Parmflt.RecFilt.ProductFamily := p_sc.GetFldDescr(M_Id, CSC_ProdFamily, false);
    Include(m_Parmflt.RecFilt.Options, FiltProdFamily);
  end

  else if (m_Id <> CSchedIDnull) and (m_SrchType = CSR_Mat_Family) then
  begin
    m_Parmflt.RecFilt.MaterialFamily := p_sc.GetFldDescr(M_Id, CSC_ProdMatFamily, false);
    Include(m_Parmflt.RecFilt.Options, FiltMaterialFamily);
  end

  else if (m_Id <> CSchedIDnull) and (m_SrchType = CSR_Rsc) then
  begin
    m_Parmflt.RecFilt.Resource := p_sc.GetFldDescr(M_Id, CSC_rsc, false);
    Include(m_Parmflt.RecFilt.Options, FiltResource);
  end

  else if (m_Id <> CSchedIDnull) and (m_SrchType = CSR_Qty) then
  begin
    m_Parmflt.RecFilt.MinQty := StrTofloat(p_sc.GetFldDescr(M_Id, CSC_IniQty, false));
    Include(m_Parmflt.RecFilt.Options, FiltQty);
  end

  else if (m_Id <> CSchedIDnull) and (m_SrchType = CSR_GroupedBy) and (GroupedBy_Code <> '') then
  begin
    UpdateGroupedByFilter(GroupedBy_Code);
    m_Parmflt.P_OverriddenTab := true
  end;

  case RadioGroupReProcess.ItemIndex of
    0 : Exclude(m_Parmflt.RecFilt.Options, FiltReProcces);
    1 : Include(m_Parmflt.RecFilt.Options, FiltReProcces);
  end;

  case RadioGroupActivWcFromGantt.ItemIndex of
    0 : Exclude(m_Parmflt.RecFilt.Options, FiltWkcr_Active);
    1 : Include(m_Parmflt.RecFilt.Options, FiltWkcr_Active);
  end;

  case RadioGroupAlternativeWc.ItemIndex of
    0 : Exclude(m_Parmflt.RecFilt.Options, FiltWkcrAlterntiv);
    1 : Include(m_Parmflt.RecFilt.Options, FiltWkcrAlterntiv);
  end;

{ Duplicate
  case RadioGroupReProcess.ItemIndex of
    0 : Exclude(m_Parmflt.RecFilt.Options, FiltReProcces);
    1 : Include(m_Parmflt.RecFilt.Options, FiltReProcces);
  end;
}
  case RadioGroupPriority.ItemIndex of
    0 : Exclude(m_Parmflt.RecFilt.Options, FiltJobPriority);
    1 : Include(m_Parmflt.RecFilt.Options, FiltJobPriority);
  end;

  case RadioGroupSched.ItemIndex of
    0 :  begin
           Exclude(m_Parmflt.RecFilt.Options, FiltSchedJobs);
           Exclude(m_Parmflt.RecFilt.Options, FiltOnlySchedJobs);
         end;
    1 :  begin
           Include(m_Parmflt.RecFilt.Options, FiltSchedJobs);
           Exclude(m_Parmflt.RecFilt.Options, FiltOnlySchedJobs);
         end;
    2 :  begin
           Exclude(m_Parmflt.RecFilt.Options, FiltSchedJobs);
           Include(m_Parmflt.RecFilt.Options, FiltOnlySchedJobs);
         end
  end;

  case RGFltJobsOnGantt.ItemIndex of
    0 :  Exclude(m_Parmflt.RecFilt.Options, FiltFltJobsOnGantt);
    1 :  Include(m_Parmflt.RecFilt.Options, FiltFltJobsOnGantt);
  end;

  case RadioGroupClosed.ItemIndex of
    0 :  begin
           Exclude(m_Parmflt.RecFilt.Options, FiltClosedJobs);
           Exclude(m_Parmflt.RecFilt.Options, FiltOnlyClosedJobs);
         end;
    1 :  begin
           Include(m_Parmflt.RecFilt.Options, FiltClosedJobs);
           Exclude(m_Parmflt.RecFilt.Options, FiltOnlyClosedJobs);
         end;
    2 :  begin
           Exclude(m_Parmflt.RecFilt.Options, FiltClosedJobs);
           Include(m_Parmflt.RecFilt.Options, FiltOnlyClosedJobs);
         end
  end;

  case RadioGroupProgress.ItemIndex of
    0 :  begin
           Exclude(m_Parmflt.RecFilt.Options, FiltProgress);
           Exclude(m_Parmflt.RecFilt.Options, FiltOnlyProgress);
         end;
    1 :  begin
           Include(m_Parmflt.RecFilt.Options, FiltProgress);
           Exclude(m_Parmflt.RecFilt.Options, FiltOnlyProgress);
         end;
    2 :  begin
           Exclude(m_Parmflt.RecFilt.Options, FiltProgress);
           Include(m_Parmflt.RecFilt.Options, FiltOnlyProgress);
         end
  end;

  case RadioGroupReadOnly.ItemIndex of
    0 :  begin
           Exclude(m_Parmflt.RecFilt.Options, Filt_ReadOnly);
           Exclude(m_Parmflt.RecFilt.Options, FiltOnlyReadOnly);
           m_Parmflt.RecFilt.ReadOnly := CSB_Normal;
         end;
    1 :  begin
           Include(m_Parmflt.RecFilt.Options, Filt_ReadOnly);
           Exclude(m_Parmflt.RecFilt.Options, FiltOnlyReadOnly);
           m_Parmflt.RecFilt.ReadOnly := CSB_ReadOnly
         end;
    2 :  begin
           Exclude(m_Parmflt.RecFilt.Options, Filt_ReadOnly);
           Include(m_Parmflt.RecFilt.Options, FiltOnlyReadOnly);
         end
  end;

  case RadioGroupGroups.ItemIndex of
    0 :  begin
           Exclude(m_Parmflt.RecFilt.Options, FiltGroups);
           Exclude(m_Parmflt.RecFilt.Options, FiltOnlyGroups);
         end;
    1 :  begin
           Include(m_Parmflt.RecFilt.Options, FiltGroups);
           Exclude(m_Parmflt.RecFilt.Options, FiltOnlyGroups);
         end;
    2 :  begin
           Exclude(m_Parmflt.RecFilt.Options, FiltGroups);
           Include(m_Parmflt.RecFilt.Options, FiltOnlyGroups);
         end
  end;

  if (CheckLowDate_From.Checked) or (CheckLowDate_To.Checked) then
    Include(m_Parmflt.RecFilt.Options, FiltLowDate)
  else
    Exclude(m_Parmflt.RecFilt.Options, FiltLowDate);

  if (CheckLowDate_From.Checked) then
  begin
    DecodeDate(DatePickLowDate_From.Date, Year, Month, Day);
    m_Parmflt.RecFilt.ProdLowDate_From := EncodeDate(Year, Month, Day);
  end
  else
    m_Parmflt.RecFilt.ProdLowDate_From := 0;

  if CheckLowDate_To.Checked = true then
  begin
    DecodeDate(DatePickLowDate_To.Date, Year, Month, Day);
    m_Parmflt.RecFilt.ProdLowDate_To := EncodeDate(Year, Month, Day);
  end
  else
     m_Parmflt.RecFilt.ProdLowDate_To := 0;

  if (CheckDelivDate_From.Checked) or (CheckDelivDate_To.Checked) then
    Include(m_Parmflt.RecFilt.Options, FiltDeliveryDate)
  else
    Exclude(m_Parmflt.RecFilt.Options, FiltDeliveryDate);

  if (CheckDelivDate_From.Checked) then
  begin
    DecodeDate(DatePickDelivDate_From.Date, Year, Month, Day);
    m_Parmflt.RecFilt.ProdDelivDate_From := EncodeDate(Year, Month, Day);
  end
  else
    m_Parmflt.RecFilt.ProdDelivDate_From := 0;

  if CheckDelivDate_To.Checked = true then
  begin
    DecodeDate(DatePickDelivDate_To.Date, Year, Month, Day);
    m_Parmflt.RecFilt.ProdDelivDate_To := EncodeDate(Year, Month, Day);
  end
  else
     m_Parmflt.RecFilt.ProdDelivDate_To := 0;

  if (CheckLowStartDate_From.Checked) or (CheckLowStartDate_To.Checked) then
    Include(m_Parmflt.RecFilt.Options, FiltLowStartDate)
  else
    Exclude(m_Parmflt.RecFilt.Options, FiltLowStartDate);

  if (CheckLowStartDate_From.Checked) then
  begin
    DecodeDate(DatePickLowStartDate_From.Date, Year, Month, Day);
    m_Parmflt.RecFilt.LowStartDate_From := EncodeDate(Year, Month, Day);
  end
  else
    m_Parmflt.RecFilt.LowStartDate_From := 0;

  if CheckLowStartDate_To.Checked = true then
  begin
    DecodeDate(DatePickLowStartDate_To.Date, Year, Month, Day);
    m_Parmflt.RecFilt.LowStartDate_To := EncodeDate(Year, Month, Day);
  end
  else
     m_Parmflt.RecFilt.LowStartDate_To := 0;

  if (CheckStartDate_From.Checked) or (CheckStartDate_To.Checked) then
    Include(m_Parmflt.RecFilt.Options, FiltPlanStartDate)
  else
    Exclude(m_Parmflt.RecFilt.Options, FiltPlanStartDate);

  if (CheckStartDate_From.Checked) then
  begin
    DecodeDate(DatePickStartDate_From.Date, Year, Month, Day);
    m_Parmflt.RecFilt.PlanStartDate_From := EncodeDate(Year, Month, Day);
  end
  else
    m_Parmflt.RecFilt.PlanStartDate_From := 0;

  if CheckStartDate_To.Checked = true then
  begin
    DecodeDate(DatePickStartDate_To.Date, Year, Month, Day);
    m_Parmflt.RecFilt.PlanStartDate_To := EncodeDate(Year, Month, Day);
  end
  else
     m_Parmflt.RecFilt.PlanStartDate_To := 0;

  if CbDaysFromTodayPlanStartfrom.Checked then
  begin
    m_Parmflt.RecFilt.PlanStartDate_DaysFromToday := SpinEditDaysFromTodayPlanStartFrom.Value;
  end
  else
    m_Parmflt.RecFilt.PlanStartDate_DaysFromToday := -1;

  if CbDaysToPlanStartTo.Checked then
  begin
    m_Parmflt.RecFilt.PlanStartDate_DaysTillToday := SpinEditDaysToPlanStartTo.Value;
  end
  else
    m_Parmflt.RecFilt.PlanStartDate_DaysTillToday := -1;

  if CbDaysFromTodayPlanStartfrom.Checked or CbDaysToPlanStartTo.Checked then
    Include(m_Parmflt.RecFilt.Options, FiltPlanStartDate_DaysFromToday)
  else
    Exclude(m_Parmflt.RecFilt.Options, FiltPlanStartDate_DaysFromToday);

  if (CheckEndDate_From.Checked) or (CheckEndDate_To.Checked) then
    Include(m_Parmflt.RecFilt.Options, FiltPlanEndDate)
  else
    Exclude(m_Parmflt.RecFilt.Options, FiltPlanEndDate);

  if (CheckEndDate_From.Checked) then
  begin
    DecodeDate(DatePickEndDate_From.Date, Year, Month, Day);
    m_Parmflt.RecFilt.PlanEndDate_From := EncodeDate(Year, Month, Day);
  end
  else
    m_Parmflt.RecFilt.PlanEndDate_From := 0;

  if CheckEndDate_To.Checked = true then
  begin
    DecodeDate(DatePickEndDate_To.Date, Year, Month, Day);
    m_Parmflt.RecFilt.PlanEndDate_To := EncodeDate(Year, Month, Day);
  end
  else
     m_Parmflt.RecFilt.PlanEndDate_To := 0;

  if CbDaysFromPlanEndTodayFrom.Checked then
  begin
    m_Parmflt.RecFilt.PlanEndDate_DaysFromToday := SpinEditDaysFromTodayPlanEndFrom.Value;
  end
  else
    m_Parmflt.RecFilt.PlanEndDate_DaysFromToday := -1;

  if CbDaysToPlanEndTodayTo.Checked then
  begin
    m_Parmflt.RecFilt.PlanEndDate_DaysTillToday := SpinEditDaysToPlanEndTo.Value;
  end
  else
    m_Parmflt.RecFilt.PlanEndDate_DaysTillToday := -1;

  if CbDaysFromPlanEndTodayFrom.Checked or CbDaysToPlanEndTodayTo.Checked then
    Include(m_Parmflt.RecFilt.Options, FiltPlanEndDate_DaysFromToday)
  else
    Exclude(m_Parmflt.RecFilt.Options, FiltPlanEndDate_DaysFromToday);

  if (CheckBoxNextstartDate_From.Checked) or (CheckBoxNextsttartDate_To.Checked) then
    Include(m_Parmflt.RecFilt.Options, FiltNextStartDate)
  else
    Exclude(m_Parmflt.RecFilt.Options, FiltNextStartDate);

  if (CheckBoxNextstartDate_From.Checked) then
  begin
    DecodeDate(DateTimePickerNextStartDate_From.Date, Year, Month, Day);
    m_Parmflt.RecFilt.NextStartDate_From := EncodeDate(Year, Month, Day);
  end
  else
    m_Parmflt.RecFilt.NextStartDate_From := 0;

  if CheckBoxNextsttartDate_To.Checked = true then
  begin
    DecodeDate(DateTimePickerNextStartDate_To.Date, Year, Month, Day);
    m_Parmflt.RecFilt.NextStartDate_to := EncodeDate(Year, Month, Day);
  end
  else
     m_Parmflt.RecFilt.NextStartDate_to := 0;

  if CheckBoxNextstartFromToday.Checked then
  begin
    m_Parmflt.RecFilt.NextStartDate_DaysFromToday := SpinEditNextstartDaysFromToday.Value;
  end
  else
    m_Parmflt.RecFilt.NextStartDate_DaysFromToday := -1;

  if CheckBoxNextstartDaysTo.Checked then
  begin
    m_Parmflt.RecFilt.NextStartDate_DaysTillToday := SpinEditNextstartDaysTo.Value;
  end
  else
    m_Parmflt.RecFilt.NextStartDate_DaysTillToday := -1;

  if CheckBoxNextstartFromToday.Checked or CheckBoxNextstartDaysTo.Checked then
    Include(m_Parmflt.RecFilt.Options, FiltNextStartDate_DaysFromToday)
  else
    Exclude(m_Parmflt.RecFilt.Options, FiltNextStartDate_DaysFromToday);

  if (CheckBoxPrevEndDate_From.Checked) or (CheckBoxPrevEndDate_To.Checked) then
    Include(m_Parmflt.RecFilt.Options, FiltPrevEndDate)
  else
    Exclude(m_Parmflt.RecFilt.Options, FiltPrevEndDate);

  if (CheckBoxPrevEndDate_From.Checked) then
  begin
    DecodeDate(DateTimePickerPrevEndDate_From.Date, Year, Month, Day);
    m_Parmflt.RecFilt.PrevEndDate_From := EncodeDate(Year, Month, Day);
  end
  else
    m_Parmflt.RecFilt.PrevEndDate_From := 0;

  if CheckBoxPrevEndDate_To.Checked = true then
  begin
    DecodeDate(DateTimePickerPrevEndDate_to.Date, Year, Month, Day);
    m_Parmflt.RecFilt.PrevEndDate_to := EncodeDate(Year, Month, Day);
  end
  else
     m_Parmflt.RecFilt.PrevEndDate_to := 0;

  if CheckBoxPrevEndFromToday.Checked then
  begin
    m_Parmflt.RecFilt.PrevEndDate_DaysFromToday := SpinEditPrevEndDaysFromToday.Value;
  end
  else
    m_Parmflt.RecFilt.PrevEndDate_DaysFromToday := -1;

  if CheckBoxPrevEndDaysTo.Checked then
  begin
    m_Parmflt.RecFilt.PrevendDate_DaysTillToday := SpinEditPrevEndDaysTo.Value;
  end
  else
    m_Parmflt.RecFilt.prevendDate_DaysTillToday := -1;

  if CheckBoxPrevEndFromToday.Checked or CheckBoxPrevEndDaysTo.Checked then
    Include(m_Parmflt.RecFilt.Options, FiltPrevEndDate_DaysFromToday)
  else
    Exclude(m_Parmflt.RecFilt.Options, FiltPrevEndDate_DaysFromToday);

  if CheckSchedStartDate_From.Checked or CheckSchedStartDate_To.Checked then
    Include(m_Parmflt.RecFilt.Options, FiltSchedStartDate)
  else
    Exclude(m_Parmflt.RecFilt.Options, FiltSchedStartDate);

  if CbDaysFromTodayFrom.Checked or CbDaysFromTodayTo.Checked then
    Include(m_Parmflt.RecFilt.Options, FiltSchedStartDate_Days)
  else
    Exclude(m_Parmflt.RecFilt.Options, FiltSchedStartDate_Days);

  if cbFixedDateEarliest_from.Checked or cbFixedDateEarliest_to.Checked then
    Include(m_Parmflt.RecFilt.Options, FiltBeforeEarliestStartFixed)
  else
    Exclude(m_Parmflt.RecFilt.Options, FiltBeforeEarliestStartFixed);

  if cbDaysfromEarliest_from.Checked or cbDaysfromEarliest_to.Checked then
    Include(m_Parmflt.RecFilt.Options, FiltBeforeEarliestStartInDaysFixed)
  else
    Exclude(m_Parmflt.RecFilt.Options, FiltBeforeEarliestStartInDaysFixed);

  if CBScheduledJobsCrosses_From.Checked or CBScheduledJobsCrosses_To.Checked then
    Include(m_Parmflt.RecFilt.Options, FiltScheduledJobsCrossesDateTime)
  else
    Exclude(m_Parmflt.RecFilt.Options, FiltScheduledJobsCrossesDateTime);

  if (CBScheduledJobsCrosses_From.Checked) then
  begin
    DecodeDate(PickerDateScheduledJobsCrosses_From.Date, Year, Month, Day);
    m_Parmflt.RecFilt.ScheduleJobsCrosses_From := EncodeDate(Year, Month, Day);
    DecodeTime(PickerTimeScheduledJobsCrosses_From.Time, Hour, Min, Sec, MSec);
    m_Parmflt.RecFilt.ScheduleJobsCrosses_From := m_Parmflt.RecFilt.ScheduleJobsCrosses_From + EncodeTime(Hour, Min, Sec, 0);
  end
  else
    m_Parmflt.RecFilt.ScheduleJobsCrosses_From := 0;

  if CBScheduledJobsCrosses_To.Checked = true then
  begin
    DecodeDate(PickerDateScheduledJobsCrosses_To.Date, Year, Month, Day);
    m_Parmflt.RecFilt.ScheduleJobsCrosses_To := EncodeDate(Year, Month, Day);
    DecodeTime(PickerTimeScheduledJobsCrosses_To.Time, Hour, Min, Sec, MSec);
    m_Parmflt.RecFilt.ScheduleJobsCrosses_To := m_Parmflt.RecFilt.ScheduleJobsCrosses_To + EncodeTime(Hour, Min, Sec, 0);
  end
  else
     m_Parmflt.RecFilt.ScheduleJobsCrosses_To := 0;

  if CheckSchedStartDate_From.Checked then
  begin
    DecodeDate(DatePickSchedStartDate_From.Date, Year, Month, Day);
    m_Parmflt.RecFilt.SchedStartDate_From := EncodeDate(Year, Month, Day);
  end
  else
    m_Parmflt.RecFilt.SchedStartDate_From := 0;

  if CheckSchedStartDate_To.Checked then
  begin
    DecodeDate(DatePickSchedStartDate_To.Date, Year, Month, Day);
    m_Parmflt.RecFilt.SchedStartDate_To := EncodeDate(Year, Month, Day);
  end
  else
    m_Parmflt.RecFilt.SchedStartDate_To := 0;

  if CbDaysFromTodayFrom.Checked then
  begin
    m_Parmflt.RecFilt.SchedStartDate_DaysFromToday := SpinEditDaysFromTodayFrom.Value;
  end
  else
    m_Parmflt.RecFilt.SchedStartDate_DaysFromToday := -1;

  if cbFixedDateEarliest_from.Checked then
  begin
    DecodeDate(dtFixedDateEarliest_from.Date, Year, Month, Day);
    m_Parmflt.RecFilt.FixedEarliestDate_From := EncodeDate(Year, Month, Day);
  end
  else
    m_Parmflt.RecFilt.FixedEarliestDate_From := 0;

  if cbFixedDateEarliest_to.Checked then
  begin
    DecodeDate(dtFixedDateEarliest_to.Date, Year, Month, Day);
    m_Parmflt.RecFilt.FixedEarliestDate_to := EncodeDate(Year, Month, Day);
  end
  else
    m_Parmflt.RecFilt.FixedEarliestDate_to := 0;

  if cbDaysfromEarliest_from.Checked then
    m_Parmflt.RecFilt.EarliestDays_From := seDaysfromEarliest_from.Value
  else
    m_Parmflt.RecFilt.EarliestDays_From := -1;

  if cbDaysfromEarliest_to.Checked then
    m_Parmflt.RecFilt.EarliestDays_To := seDaysfromEarliest_to.Value
  else
    m_Parmflt.RecFilt.EarliestDays_To := -1;

  if CbDaysFromTodayTo.Checked then
  begin
    m_Parmflt.RecFilt.SchedStartDate_DaysTillToday := SpinEditDaysFromTodayTo.Value;
  //  DecodeTime(DateTimePickerDaysFromTodayTo_time.Time, Hour, Min, Sec, MSec);
    m_Parmflt.RecFilt.SchedStartDate_DaysTillToday_time := Frac(DateTimePickerDaysFromTodayTo_time.Time) * 60 * 24;
  end
  else
    m_Parmflt.RecFilt.SchedStartDate_DaysTillToday := -1;

  if CheckLatestEndingDate_From.Checked or CheckLatestEndingDate_To.Checked then
    Include(m_Parmflt.RecFilt.Options, FiltLatestEndingDate)
  else
    Exclude(m_Parmflt.RecFilt.Options, FiltLatestEndingDate);

  if CheckLatestEndingDate_From.Checked then
  begin
    DecodeDate(DatePickerLatestEndingDate_From.Date, Year, Month, Day);
    m_Parmflt.RecFilt.LatestEndingDate_From := EncodeDate(Year, Month, Day);
  end
  else
    m_Parmflt.RecFilt.LatestEndingDate_From := 0;

  if CheckLatestEndingDate_To.Checked then
  begin
    DecodeDate(DatePickerLatestEndingDate_To.Date, Year, Month, Day);
    m_Parmflt.RecFilt.LatestEndingDate_To := EncodeDate(Year, Month, Day);
  end
  else
    m_Parmflt.RecFilt.LatestEndingDate_To := 0;

  if GroupedBy_Code = '' then
  begin
    m_Parmflt.RecFilt.IsPropEnter := m_PropComp.IsPropEnter;
    if m_Parmflt.RecFilt.IsPropEnter then
    begin
      Include(m_Parmflt.RecFilt.Options, FiltProp);

      m_Parmflt.ClearFiltPropList;
      m_Parmflt.ClearPropRecFields;
      for I := 1 to m_PropComp.P_RowCount - 1 do
      begin
        if m_PropComp.P_GetPropVal[I] <> '' then
        begin
          m_Parmflt.SetPropValue(m_PropComp.P_GetPropVal[I],
                            m_PropComp.P_GetPropRsc[I],
                            m_PropComp.P_GetValFrom[I],
                            m_PropComp.P_GetValTo[I]);

          m_Parmflt.RecFilt.PropCod[I] := m_PropComp.P_GetPropVal[I];
          m_Parmflt.RecFilt.PropRes[I] := m_PropComp.P_GetPropRsc[I];
          m_Parmflt.RecFilt.PropValfrom[I] := m_PropComp.P_GetValFrom[I];
          m_Parmflt.RecFilt.PropValTo[I] := m_PropComp.P_GetValTo[I];
        end;
      end;
    end
    else
    begin
      m_Parmflt.ClearPropRecFields;
      Exclude(m_Parmflt.RecFilt.Options, FiltProp);
    end;
  end;

  if CBAfterDeliveryDate.Checked then
    Include(m_Parmflt.RecFilt.Options, FiltAfterDeliveryDay)
  else
    Exclude(m_Parmflt.RecFilt.Options, FiltAfterDeliveryDay);

  if SpinEditAfterDeliveryDateInDays.Value > 0 then
  begin
    Include(m_Parmflt.RecFilt.Options, FiltAfterDeliveryInDays);
    m_Parmflt.RecFilt.AfterDeliveryInDays := SpinEditAfterDeliveryDateInDays.Value;
  end
  else
    Exclude(m_Parmflt.RecFilt.Options, FiltAfterDeliveryInDays);

  if CBbeforeEarliestStart.Checked then
    Include(m_Parmflt.RecFilt.Options, FiltBeforeEarliestStart)
  else
    Exclude(m_Parmflt.RecFilt.Options, FiltBeforeEarliestStart);

  if SpinEditBeforeEarliestStartIndays.Value > 0 then
  begin
    Include(m_Parmflt.RecFilt.Options, FiltBeforeEarliestStartInDays);
    m_Parmflt.RecFilt.BeforeEarliestStartInDays := SpinEditBeforeEarliestStartIndays.Value;
  end
  else
    Exclude(m_Parmflt.RecFilt.Options, FiltBeforeEarliestStartInDays);

  if CBAfterLatestEnd.Checked then
    Include(m_Parmflt.RecFilt.Options, FiltAfterLatestEnd)
  else
    Exclude(m_Parmflt.RecFilt.Options, FiltAfterLatestEnd);

  if SpinEditAfterlLatestEndInDays.Value > 0 then
  begin
    Include(m_Parmflt.RecFilt.Options, FiltAfterLatestEndInDays);
    m_Parmflt.RecFilt.AfterLatestEndInDays := SpinEditAfterlLatestEndInDays.Value;
  end
  else
    Exclude(m_Parmflt.RecFilt.Options, FiltAfterLatestEndInDays);

  if CBMaterials.Checked then
    Include(m_Parmflt.RecFilt.Options, FiltMissingmaterials)
  else
    Exclude(m_Parmflt.RecFilt.Options, FiltMissingmaterials);

  if CBAdditionalRes.Checked then
    Include(m_Parmflt.RecFilt.Options, FiltMissingAddRes)
  else
    Exclude(m_Parmflt.RecFilt.Options, FiltMissingAddRes);

  if CBOveridePrevious.Checked then
    Include(m_Parmflt.RecFilt.Options, FiltOveridePrevious)
  else
    Exclude(m_Parmflt.RecFilt.Options, FiltOveridePrevious);

  if CBOverideNext.Checked then
    Include(m_Parmflt.RecFilt.Options, FiltOverideNext)
  else
    Exclude(m_Parmflt.RecFilt.Options, FiltOverideNext);

  if CBCompWithPrevJob.Checked then
    Include(m_Parmflt.RecFilt.Options, FiltCompWithPrevJob)
  else
    Exclude(m_Parmflt.RecFilt.Options, FiltCompWithPrevJob);

  if SpinEditCompPrevWithJobMin.Value > 0 then
  begin
    Include(m_Parmflt.RecFilt.Options, FiltCompWithPrevJobInCase);
    m_Parmflt.RecFilt.CompWithPrevJobInCase := SpinEditCompPrevWithJobMin.Value;
  end
  else
    Exclude(m_Parmflt.RecFilt.Options, FiltCompWithPrevJobInCase);

  if CBCompWithRes.Checked then
    Include(m_Parmflt.RecFilt.Options, FiltCompWithRes)
  else
    Exclude(m_Parmflt.RecFilt.Options, FiltCompWithRes);

  if CBShowImbalancedSteps.Checked then
    Include(m_Parmflt.RecFilt.Options, FiltImbalancedSteps)
  else
    Exclude(m_Parmflt.RecFilt.Options, FiltImbalancedSteps);

  if CBoxJobMsg.Checked then
    Include(m_Parmflt.RecFilt.Options, FiltJobMsg)
  else
    Exclude(m_Parmflt.RecFilt.Options, FiltJobMsg);

  if CLBConLevelsToMove.Items.Count > 0 then
  begin
    if CLBConLevelsToMove.Checked[0] then
      Include(m_Parmflt.RecFilt.Options, FiltConfLevelsfinal)
    else
      Exclude(m_Parmflt.RecFilt.Options, FiltConfLevelsfinal);
  end;

  if CLBConLevelsToMove.Items.Count > 1 then
  begin
    if CLBConLevelsToMove.Checked[1] then
      Include(m_Parmflt.RecFilt.Options, FiltConfLevelsIni)
    else
      Exclude(m_Parmflt.RecFilt.Options, FiltConfLevelsIni);
  end;

  if CLBConLevelsToMove.Items.Count > 2 then
  begin
    if CLBConLevelsToMove.Checked[2] then
      Include(m_Parmflt.RecFilt.Options, FiltConfLevels1)
    else
      Exclude(m_Parmflt.RecFilt.Options, FiltConfLevels1);
  end;

  if CLBConLevelsToMove.Items.Count > 3 then
  begin
    if CLBConLevelsToMove.Checked[3] then
      Include(m_Parmflt.RecFilt.Options, FiltConfLevels2)
    else
      Exclude(m_Parmflt.RecFilt.Options, FiltConfLevels2);
  end;

  if CLBConLevelsToMove.Items.Count > 4 then
  begin
    if CLBConLevelsToMove.Checked[4] then
      Include(m_Parmflt.RecFilt.Options, FiltConfLevels3)
    else
      Exclude(m_Parmflt.RecFilt.Options, FiltConfLevels3);
  end;

  if CLBConLevelsToMove.Items.Count > 5 then
  begin
    if CLBConLevelsToMove.Checked[5] then
      Include(m_Parmflt.RecFilt.Options, FiltConfLevels4)
    else
      Exclude(m_Parmflt.RecFilt.Options, FiltConfLevels4);
  end;

  if CLBConLevelsToMove.Items.Count > 6 then
  begin
    if CLBConLevelsToMove.Checked[6] then
      Include(m_Parmflt.RecFilt.Options, FiltConfLevels5)
    else
      Exclude(m_Parmflt.RecFilt.Options, FiltConfLevels5);
  end;

  if CBCustomerDate.Checked[0] then
    Include(m_Parmflt.RecFilt.Options, FiltCustomerDateConfirmed)
  else
    Exclude(m_Parmflt.RecFilt.Options, FiltCustomerDateConfirmed);

  if CBCustomerDate.Checked[1] then
    Include(m_Parmflt.RecFilt.Options, FiltCustomerDateCulculated)
  else
    Exclude(m_Parmflt.RecFilt.Options, FiltCustomerDateCulculated);

  if CBCustomerDate.Checked[2] then
    Include(m_Parmflt.RecFilt.Options, FiltCustomerDateRequested)
  else
    Exclude(m_Parmflt.RecFilt.Options, FiltCustomerDateRequested);

  if SpinEditCompWithResMin.Value > 0 then
  begin
    Include(m_Parmflt.RecFilt.Options, FiltCompWithResInCase);
    m_Parmflt.RecFilt.CompWithResInCase := SpinEditCompWithResMin.Value;
  end
  else
    Exclude(m_Parmflt.RecFilt.Options, FiltCompWithResInCase);

  if CBShouldBeSched.Checked then
    Include(m_Parmflt.RecFilt.Options, FiltShouldBeScheduled)
  else
    Exclude(m_Parmflt.RecFilt.Options, FiltShouldBeScheduled);

  if SpinEditShouldBeSched.Value > 0 then
  begin
    Include(m_Parmflt.RecFilt.Options, FiltShouldBeScheduledIndays);
    m_Parmflt.RecFilt.ShouldBeScheduledIndays := SpinEditShouldBeSched.Value;
  end
  else
    Exclude(m_Parmflt.RecFilt.Options, FiltShouldBeScheduledIndays);

  if ChkBxShowFirstGrplineInBin.Checked then
    m_Parmflt.RecFilt.ShowFirstGrplineInBin := true
  else
    m_Parmflt.RecFilt.ShowFirstGrplineInBin := false;

  if CBoxBAllowGroupsOneJob.Checked then
    m_Parmflt.RecFilt.AutoGroupSingleJob := true
  else
    m_Parmflt.RecFilt.AutoGroupSingleJob := false;

  if CBoxBatchGroupLines.Checked then
    m_Parmflt.RecFilt.ShowBatchGroupLinesInBin := true
  else
    m_Parmflt.RecFilt.ShowBatchGroupLinesInBin := false;

  if RadioContGrpGroupLines.ItemIndex = 0 then
    m_Parmflt.RecFilt.ShowContinueGroupLinesInBin := CsSCG_No
  else if RadioContGrpGroupLines.ItemIndex = 1 then
    m_Parmflt.RecFilt.ShowContinueGroupLinesInBin := CsSCG_Yes
  else
    m_Parmflt.RecFilt.ShowContinueGroupLinesInBin := CsSCG_YesSameSequence;

  if RG_ShowDependingOnNextHandledStep.ItemIndex = 0 then
    m_Parmflt.RecFilt.ShowDependingOnNextHandledStep := CsAlways
  else if RG_ShowDependingOnNextHandledStep.ItemIndex = 1 then
    m_Parmflt.RecFilt.ShowDependingOnNextHandledStep := CsWhenNotScheduled
  else
    m_Parmflt.RecFilt.ShowDependingOnNextHandledStep := CsWhenScheduled;

  if RG_ShowDependingOnPreviousHandledStep.ItemIndex = 0 then
    m_Parmflt.RecFilt.ShowDependingOnPrevHandledStep := CsAlways
  else if RG_ShowDependingOnPreviousHandledStep.ItemIndex = 1 then
    m_Parmflt.RecFilt.ShowDependingOnPrevHandledStep := CsWhenNotScheduled
  else
    m_Parmflt.RecFilt.ShowDependingOnPrevHandledStep := CsWhenScheduled;

  if RG_ShowDependingOnNextHandledLinkedRequest.ItemIndex = 0 then
    m_Parmflt.RecFilt.ShowDependingOnNextHandledLinkedRequest := CsAlways
  else if RG_ShowDependingOnNextHandledLinkedRequest.ItemIndex = 1 then
    m_Parmflt.RecFilt.ShowDependingOnNextHandledLinkedRequest := CsWhenNotScheduled
  else
    m_Parmflt.RecFilt.ShowDependingOnNextHandledLinkedRequest := CsWhenScheduled;

  if RG_ShowDependingOnPreviuosHandledLinkedRequest.ItemIndex = 0 then
    m_Parmflt.RecFilt.ShowDependingOnPrevHandledLinkedRequest := CsAlways
  else if RG_ShowDependingOnPreviuosHandledLinkedRequest.ItemIndex = 1 then
    m_Parmflt.RecFilt.ShowDependingOnPrevHandledLinkedRequest := CsWhenNotScheduled
  else
    m_Parmflt.RecFilt.ShowDependingOnPrevHandledLinkedRequest := CsWhenScheduled;

  if EditItemTypeCodeBaseWarp.text <> '' then
  begin
    Include(m_Parmflt.RecFilt.Options, FiltItemTypeBaseWarp);
    m_Parmflt.RecFilt.ItemTypeCodeBaseWarp := EditItemTypeCodeBaseWarp.text;
  end
  else
  begin
    Exclude(m_Parmflt.RecFilt.Options, FiltItemTypeBaseWarp);
    m_Parmflt.RecFilt.ItemTypeCodeBaseWarp := '';
  end;

  if EditProductCodeBaseWarp.Text <> '' then
  begin
    Include(m_Parmflt.RecFilt.Options, FiltProdCodeBaseWarp);
    m_Parmflt.RecFilt.ProdCodeBaseWarp := EditProductCodeBaseWarp.text;
  end
  else
  begin
    Exclude(m_Parmflt.RecFilt.Options, FiltProdCodeBaseWarp);
    m_Parmflt.RecFilt.ProdCodeBaseWarp := '';
  end;

  if EditItemTypeCodeSecondWarp.text <> '' then
  begin
    Include(m_Parmflt.RecFilt.Options, FiltItemTypeSecondWarp);
    m_Parmflt.RecFilt.ItemTypeCodeSecondWarp := EditItemTypeCodeSecondWarp.text;
  end
  else
  begin
    Exclude(m_Parmflt.RecFilt.Options, FiltItemTypeSecondWarp);
    m_Parmflt.RecFilt.ItemTypeCodeSecondWarp := '';
  end;

  if EditProductCodeSecondWarp.Text <> '' then
  begin
    Include(m_Parmflt.RecFilt.Options, FiltProdCodeSecondWarp);
    m_Parmflt.RecFilt.ProdCodeSecondWarp := EditProductCodeSecondWarp.text;
  end
  else
  begin
    Exclude(m_Parmflt.RecFilt.Options, FiltProdCodeSecondWarp);
    m_Parmflt.RecFilt.ProdCodeSecondWarp := '';
  end;


    //grouping
  if cbWkcGrp.Text <> '' then
  begin
    Include(m_Parmflt.RecFilt.Options, FiltWkcrGrp);
    m_Parmflt.RecFilt.wkCtrGroup := cbWkcGrp.Text;
  end else
  begin
    Exclude(m_Parmflt.RecFilt.Options, FiltWkcrGrp);
    m_Parmflt.RecFilt.wkCtrGroup := '';
  end;

  if cbPlant.Text <> '' then
  begin
    Include(m_Parmflt.RecFilt.Options, FiltWkcrPlant);
     m_Parmflt.RecFilt.wkCtrPlant := cbPlant.Text;
  end else
  begin
     Exclude(m_Parmflt.RecFilt.Options, FiltWkcrPlant);
    m_Parmflt.RecFilt.wkCtrPlant := '';
  end;

  if cbDivision.Text <> '' then
  begin
    Include(m_Parmflt.RecFilt.Options, FiltWkcrDivision);
     m_Parmflt.RecFilt.wkCtrDivision := cbDivision.Text;
  end else
  begin
     Exclude(m_Parmflt.RecFilt.Options, FiltWkcrDivision);
    m_Parmflt.RecFilt.wkCtrDivision := '';
  end;

  if cbIgnoredProgress.Checked then
    Include(m_Parmflt.RecFilt.Options, FiltIgnoredProg)
  else
    Exclude(m_Parmflt.RecFilt.Options, FiltIgnoredProg);

end;

//----------------------------------------------------------------------------//

function TTBinFilter.GetTabName: string;
begin
  Result := '   ' + EditTabName.Text + '   ';
end;

//----------------------------------------------------------------------------//

procedure TTBinFilter.BtnOk1Click(Sender: TObject);
var
  str : string;
begin
  str := '';
  ModalResult := mrOk;

  if (SpinEditAfterDeliveryDateInDays.Value > 0) and (CBAfterDeliveryDate.Checked = False) then
    CBAfterDeliveryDate.Checked := True;

  if (SpinEditAfterlLatestEndInDays.Value > 0) and (CBAfterLatestEnd.Checked = False) then
    CBAfterLatestEnd.Checked := True;

  if (SpinEditBeforeEarliestStartIndays.Value > 0) and (CBbeforeEarliestStart.Checked = False) then
    CBbeforeEarliestStart.Checked := True;

  if (SpinEditShouldBeSched.Value > 0) and (CBShouldBeSched.Checked = False) then
    CBShouldBeSched.Checked := True;

  if (SpinEditCompPrevWithJobMin.Value > 0) and (CBCompWithPrevJob.Checked = False) then
    CBCompWithPrevJob.Checked := True;

  if (SpinEditCompWithResMin.Value > 0) and (CBCompWithRes.Checked = False) then
    CBCompWithRes.Checked := True;

  if not CheckDataforProp(str) then
  begin
    if (str <> '') then
    begin
      Showmessage(str);
      ModalResult := mrNone;
      PageControl1.ActivePage := TabProperty;
      exit;
    end;
  end;

  SetFilter('');
  m_Parmflt.GetOrConditionProp;
  m_Parmflt.P_SetListOnProp := false;

  m_Parmflt.P_GroupedByCode := CBGroupedBy.Items[CBGroupedBy.ItemIndex];
  m_Parmflt.P_OverriddenTab := CBOverriddenExistingTab.Checked;

end;

//----------------------------------------------------------------------------//

procedure TTBinFilter.FormCreate(Sender: TObject);
begin
//  TabSheetWarnings.TabVisible := false;
  ScaleFormSize(Self, Screen.PixelsPerInch);
  InitWidth_Lbl;

  // Create Resource Category controls at runtime (below Resource)
  // Shift all controls below Resource down by 30px to make room
  LabelMinStp.Top := LabelMinStp.Top + 30;
  Label26.Top := Label26.Top + 30;
  EditMinStep.Top := EditMinStep.Top + 30;
  EditMaxStep.Top := EditMaxStep.Top + 30;
  CheckQty.Top := CheckQty.Top + 30;
  LabelProdFamily.Top := LabelProdFamily.Top + 30;
  EditProdFamily.Top := EditProdFamily.Top + 30;
  CheckProdFamily.Top := CheckProdFamily.Top + 30;
  LabelMaterialFamily.Top := LabelMaterialFamily.Top + 30;
  EditMaterialFamily.Top := EditMaterialFamily.Top + 30;
  CheckMatFamily.Top := CheckMatFamily.Top + 30;

  LblResCat := TLabel.Create(Self);
  LblResCat.Parent := LblResource.Parent;
  LblResCat.Left := LblResource.Left;
  LblResCat.Top := LblResource.Top + 32;
  LblResCat.Width := 135;
  LblResCat.Caption := 'Resource category';
  LblResCat.Font := LblResource.Font;

  EdtResCat := TEdit.Create(Self);
  EdtResCat.Parent := EdtResource.Parent;
  EdtResCat.Left := EdtResource.Left;
  EdtResCat.Top := EdtResource.Top + 30;
  EdtResCat.Width := EdtResource.Width;
  EdtResCat.Height := EdtResource.Height;

  //BtnAbo.Left := Width - BtnAbo.Width - BtnOk.Width - 45;
 // BtnOk.Left := Width - BtnOk.Width - 30;
  TranslateComponent (self);
  PageControl1.ActivePage := TabFiltGen;
  InitFields;
  GetAllWcProc;
  SetAllWc;
  InitCBStepType;
  GetProdType;
  if m_Id <> CSchedIDnull then
  begin
    InitDefaultRadioGroup;
    if (m_SrchType = CSR_FullProdReq) then
      InitJobFilter;
  end
  else
    HideCheckBox;

  if not DBAppGlobals.IsWarpHandled then
    PageControl1.Pages[6].TabVisible := false;

  if not DBAppSettings.FixColJobMsgVis then
  begin
    CBoxJobMsg.Checked := false;
    CBoxJobMsg.Enabled := false;
    TabSheetWarnings.Caption := _('Warnings');
  end
  else
    TabSheetWarnings.Caption := _('Warnings and messages');
  SetTabName;

  ReShape(Self);

end;

//----------------------------------------------------------------------------//

function TTBinFilter.SearchForStpType(Typ : CScSchedType) : integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to CBStepType.Items.Count - 1 do
    if Typ = CScSchedType(CBStepType.Items.Objects[I]) then
    begin
      Result := I;
      Exit;
    end;
end;

//----------------------------------------------------------------------------//

function TTBinFilter.SearchForProdTyp(typ: string): integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to ComboBoxProdType.Items.Count - 1 do
    if Typ = ComboBoxProdType.Items[i] then
    begin
      Result := i;
      exit
    end
end;

//----------------------------------------------------------------------------//

function TTBinFilter.SearchForWc(Typ : string) : integer;
var
  I : Integer;
begin
  Result := 0;
  for I := 0 to ComboBoxWC.Items.Count - 1 do
    if Typ = ComboBoxWC.Items[I] then
    begin
      Result := I;
      Exit;
    end;
end;

procedure TTBinFilter.seDaysfromEarliest_fromChange(Sender: TObject);
begin
   cbDaysfromEarliest_from.Checked := True;
end;

procedure TTBinFilter.seDaysfromEarliest_toChange(Sender: TObject);
begin
  cbDaysfromEarliest_To.Checked := True;
end;

//----------------------------------------------------------------------------//

function TTBinFilter.SearchForProces(Typ : string) : integer;
var
  I : Integer;
begin
  Result := 0;
  for I := 0 to ComboBoxProcess.Items.Count - 1 do
    if Typ = ComboBoxProcess.Items[I] then
    begin
      Result := I;
      Exit;
    end;
end;

//----------------------------------------------------------------------------//

function TTBinFilter.GetWcObjByCode(Code : string):TMqmWrkCtr;
var
  I : Integer;
begin
  Result := nil;
  for i := 0 to m_ListWC.count - 1 do
  begin
    if (Code = TMqmWrkCtr(m_ListWC[I]).p_WrkCtrCode) then
    begin
      Result := TMqmWrkCtr(m_ListWC[I]);
      Exit;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TTBinFilter.GetProdType;
var
  Index : Integer;
begin
  ComboBoxProdType.Items.Add('');
  for Index := 0 to p_ArtType.GetCount - 1 do
    ComboBoxProdType.Items.Add(p_ArtType.GetNext(Index));
end;

//----------------------------------------------------------------------------//

procedure TTBinFilter.InitCBStepType;
var
  i: integer;
begin
  i := CBStepType.Items.Add('');
  CBStepType.Items.Objects[i] := TObject(CST_undef);

  i := CBStepType.Items.Add('Batches');
  CBStepType.Items.Objects[i] := TObject(CST_batch);

  i := CBStepType.Items.Add('Continuous');
  CBStepType.Items.Objects[i] := TObject(CST_Continuous);

  i := CBStepType.Items.Add('Printing');
  CBStepType.Items.Objects[i] := TObject(CST_printing);

  CBStepType.ItemIndex := 0
end;

//----------------------------------------------------------------------------//

procedure TTBinFilter.InitFields;
var
  I, G : Integer;
  GroupedByFieldList : Tstringlist;
begin
  DatePickLowDate_From.Date := Date;
  DatePickLowDate_To.Date := Date;
  DatePickDelivDate_From.Date := Date;
  DatePickDelivDate_To.Date := Date;
  DatePickLowStartDate_From.Date := Date;
  DatePickLowStartDate_To.Date := Date;
  DatePickStartDate_From.Date := Date;
  DatePickStartDate_To.Date := Date;
  DatePickEndDate_From.Date := Date;
  DatePickEndDate_To.Date   := Date;
  DatePickSchedStartDate_From.Date := Date;
  DatePickSchedStartDate_To.Date := Date;
  DatePickerLatestEndingDate_From.Date := Date;
  DatePickerLatestEndingDate_To.Date := Date;
  PickerDateScheduledJobsCrosses_From.Date := Date;
  PickerDateScheduledJobsCrosses_To.Date := Date;
  DateTimePickerNextStartDate_From.Date := Date;
  DateTimePickerNextStartDate_To.Date := Date;
  DateTimePickerPrevEndDate_From.Date := Date;
  DateTimePickerPrevEndDate_To.Date := Date;

  dtFixedDateEarliest_from.Date := Date;
  dtFixedDateEarliest_to.Date := Date;

  CLBConLevelsToMove.Clear;
//  CLBConLevelsToMove.Items.Add('Final');
  CLBConLevelsToMove.Checked[CLBConLevelsToMove.Items.Add('Final')] := true;
  for i := 1 to DBAppGlobals.ConfLevels do
    if i = 1 then
    begin
      CLBConLevelsToMove.Checked[CLBConLevelsToMove.Items.Add('Initial')] := true;
    end
    else
    begin
      CLBConLevelsToMove.Checked[CLBConLevelsToMove.Items.Add('Level' + ' ' + IntToStr(i - 1))] := true;
    end;

  CBCustomerDate.Checked[0] := true;
  CBCustomerDate.Checked[1] := true;
  CBCustomerDate.Checked[2] := true;

  CBGroupedBy.items.add('');
  GroupedByFieldList := GetAllGroupedByFieldList;

  if assigned(GroupedByFieldList) then
  begin
    G := -1;
    for I := 0 to GroupedByFieldList.Count - 1 do
    begin
      if m_Parmflt.P_GroupedByCode = GroupedByFieldList.Strings[I] then
         G := I;
      CBGroupedBy.items.Add(GroupedByFieldList.Strings[I]);
    end;
    if GroupedByFieldList.Count > 0 then
       CBGroupedBy.ItemIndex := G + 1;
  end;

  if m_Parmflt.P_OverriddenTab then
    CBOverriddenExistingTab.Checked := true;

end;

//----------------------------------------------------------------------------//

procedure ReadBoolFromSearchProdIni(const sez, tag: string; var val: boolean);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(LocAppGlobals.AppDir + IniName);
  val := Ini.ReadBool(sez, tag, val);
  Ini.Free
end;

//----------------------------------------------------------------------------//

procedure WriteBoolToSearchProdIni(const sez, tag: string; value: boolean);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(LocAppGlobals.AppDir + IniName);
  Ini.WriteBool(sez, tag, value);
  Ini.Free
end;

//----------------------------------------------------------------------------//

procedure TTBinFilter.ReadBoolFromSearchJob;
var
  IsChecked : boolean;
begin

  IsChecked := false;

  ReadBoolFromSearchProdIni('0', CBProdReq, IsChecked);
    CheckProdReq.Checked := IsChecked;

  ReadBoolFromSearchProdIni('0', CBProdTyp, IsChecked);
    CheckProdTyp.Checked := IsChecked;

  ReadBoolFromSearchProdIni('0', CBStepTyp, IsChecked);
    CheckStepType.Checked := IsChecked;

  ReadBoolFromSearchProdIni('0', CBWC, IsChecked);
    CheckWC.Checked := IsChecked;

  ReadBoolFromSearchProdIni('0', CBPrcs, IsChecked);
    CheckProcess.Checked := IsChecked;

  ReadBoolFromSearchProdIni('0', CBProdFamily, IsChecked);
    CheckProdFamily.Checked := IsChecked;

  ReadBoolFromSearchProdIni('0', CBMatFamily, IsChecked);
    CheckMatFamily.Checked := IsChecked;

  ReadBoolFromSearchProdIni('0', CBProdLine, IsChecked);
    CheckResource.Checked := IsChecked;

  ReadBoolFromSearchProdIni('0', CBQty, IsChecked);
    CheckQty.Checked := IsChecked;

  ReadBoolFromSearchProdIni('0', CBStepId, IsChecked);
    CheckStep.Checked := IsChecked;

  ReadBoolFromSearchProdIni('0', CBSubStepId, IsChecked);
    CheckSubStep.Checked := IsChecked;

  ReadBoolFromSearchProdIni('0', CBGroupNum, IsChecked);
    CheckGrpNumber.Checked := IsChecked;

end;

procedure TTBinFilter.ScrollBox3MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  var
  LTopLeft, LTopRight, LBottomLeft, LBottomRight: SmallInt;
  LPoint: TPoint;
begin
  inherited;

  LPoint := TScrollbox(Sender).ClientToScreen(Point(0,0));

  LTopLeft := LPoint.X;
  LTopRight := LTopLeft + TScrollbox(Sender).Width;

  LBottomLeft := LPoint.Y;
  LBottomRight := LBottomLeft + TScrollbox(Sender).Width;


  if (MousePos.X >= LTopLeft) and
    (MousePos.X <= LTopRight) and
    (MousePos.Y >= LBottomLeft)and
    (MousePos.Y <= LBottomRight) then
  begin
    TScrollbox(Sender).VertScrollBar.Position :=
    TScrollbox(Sender).VertScrollBar.Position - WheelDelta;

    Handled := True;
  end;
end;

//----------------------------------------------------------------------------//

procedure TTBinFilter.InitJobFilter;
begin
  ReadBoolFromSearchJob;
  EditProdReqFrom.Text := p_sc.GetFldDescr(m_Id, CSC_ProdReq, false);
  ComboBoxProdType.ItemIndex := SearchForProdTyp(p_sc.GetFldDescr(M_Id, CSC_ProdType, false));
  CBStepType.ItemIndex := SearchForStpType(p_sc.GetJobType(M_Id));
  if p_sc.GetExtLinkPtr(m_Id) <> nil then
    ComboBoxWC.ItemIndex := SearchForWc(p_sc.GetFldDescr(M_Id, CSC_WkctCode, false))
  else
    ComboBoxWC.ItemIndex := SearchForWc(p_sc.GetFldDescr(M_Id, CSC_PlanWkctCode, false));
  if p_sc.GetExtLinkPtr(m_Id) <> nil then
    ComboBoxProcess.ItemIndex := searchForProces(p_sc.GetFldDescr(M_Id, CSC_WkctProc, false))
  else
    ComboBoxProcess.ItemIndex := searchForProces(p_sc.GetFldDescr(M_Id, CSC_PlanWkctProc, false));

  EditProdFamily.Text := p_sc.GetFldDescr(M_Id, CSC_ProdFamily, false);
  EditMaterialFamily.Text := p_sc.GetFldDescr(M_Id, CSC_ProdMatFamily, false);
  if p_sc.GetExtLinkPtr(m_Id) <> nil then
    EdtResource.Text := p_sc.GetFldDescr(M_Id, CSC_Rsc, false);
  EditMinStep.Text := p_sc.GetFldDescr(M_Id, CSC_IniQty, false);
  EditMaxStep.Text := '9999999'
end;

//----------------------------------------------------------------------------//

procedure TTBinFilter.InitDefaultRadioGroup;
begin
  RadioGroupActivWcFromGantt.ItemIndex := 0;
  RadioGroupSched.ItemIndex := 1;
  RadioGroupClosed.ItemIndex := 1;
end;

//----------------------------------------------------------------------------//

procedure TTBinFilter.HideCheckBox;
begin
  CheckProdReq.Visible := false;
  CheckProdTyp.Visible := false;
  CheckStepType.Visible := false;
  CheckWC.Visible := false;
  CheckProcess.Visible := false;
  CheckProdFamily.Visible := false;
  CheckMatFamily.Visible := false;
  CheckResource.Visible := false;
  CheckQty.Visible := false;
  CheckStep.Visible := false;
  CheckSubStep.Visible := false;
  CheckGrpNumber.Visible := false;
  CheckWkcGrp.Visible := false;
end;

//----------------------------------------------------------------------------//

procedure TTBinFilter.WriteBoolToSearchJob;
begin
  WriteBoolToSearchProdIni('0', CBProdReq, CheckProdReq.Checked);
  WriteBoolToSearchProdIni('0', CBProdTyp, CheckProdTyp.Checked);
  WriteBoolToSearchProdIni('0', CBStepTyp, CheckStepType.Checked);
  WriteBoolToSearchProdIni('0', CBWC, CheckWC.Checked);
  WriteBoolToSearchProdIni('0', CBPrcs, CheckProcess.Checked);
  WriteBoolToSearchProdIni('0', CBProdFamily, CheckProdFamily.Checked);
  WriteBoolToSearchProdIni('0', CBMatFamily, CheckMatFamily.Checked);
  WriteBoolToSearchProdIni('0', CBProdLine, CheckResource.Checked);
  WriteBoolToSearchProdIni('0', CBQty, CheckQty.Checked);
  WriteBoolToSearchProdIni('0', CBStepId, CheckStep.Checked);
  WriteBoolToSearchProdIni('0', CBSubStepId, CheckSubStep.Checked);
  WriteBoolToSearchProdIni('0', CBGroupNum, CheckGrpNumber.Checked);
end;

//----------------------------------------------------------------------------//

procedure TTBinFilter.GetAllWcProc;
var
  I,J : Integer;
  Wc : TMqmWrkCtr;

  function CheckExistProc(Pro : string) : boolean;
  var
    i: integer;
  begin
    Result := false;
    for i := 0 to m_ListProces.Count - 1 do
      if Pro = m_ListProces.Strings[I] then exit;
    Result := true
  end;

begin

  m_ListWC := TList.Create;
  m_ListProces := TStringList.Create;

  m_ListWC.Clear;
  for i := 0 to p_pl.p_WrkCtrsCount -1 do
  begin
    wc := TMqmWrkCtr(p_pl.p_WrkCtr[i]);
      m_ListWC.Add(wc);
  end;

  for I := 0 to m_ListWc.Count - 1 do
  begin
    Wc := TMqmWrkCtr(m_ListWc[I]);
    for J := 0 to Wc.P_GetProccesCount - 1 do
    begin
      if CheckExistProc(Wc.P_GetProcess[J]) then
        m_ListProces.Add(Wc.P_GetProcess[J]);
    end;
  end;

end;

//----------------------------------------------------------------------------//

procedure TTBinFilter.InitWidth_Lbl;
begin
  LblProdReq.Width          := 135;
  LblProdType.Width         := 135;
  LblStepType.Width         := 135;
  LabelWctr.Width           := 135;
  LabelProcces.Width        := 135;
  LabelProdFamily.Width     := 135;
  LabelMaterialFamily.Width := 135;
  LblResource.Width         := 135;
  LabelMinStp.Width         := 135;
  LblProdLDT.Width          := 180;
  LblProdHDT.Width          := 180;
  LblLowestSDT.Width        := 180;
  LblPlannedSDT.Width       := 180;
//  LabelSchedulStart.Width   := 180;
  LabelFromProdLDT.Width    := 42;
  LabelToProdLDT.Width      := 20;
  LblFromProdHDT.Width      := 42;
  LblToProdHDT.Width        := 20;
  LblFromLowestSDT.Width    := 42;
  LblToLowestSDT.Width      := 20;
  LblFromPlannedSDT.Width   := 42;
  LblToPlannedSDT.Width     := 20;
  LabelFromSchedulStart.Width := 42;
  LabelToSchedulStart.Width := 20;
end;

//----------------------------------------------------------------------------//

procedure TTBinFilter.PageControl1Change(Sender: TObject);
begin
  if PageControl1.TabIndex = 1 then
    EditProdReqFrom.SetFocus;
end;

procedure TTBinFilter.PageControl1DrawTab(Control: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
begin
  with Control.Canvas do begin
    Brush.Color := clWhite;
    FillRect(Rect);
    TextOut(Rect.Left + Font.Size -5, Rect.Top + 2, (Control as TPageControl).Pages[TabIndex].Caption) ;
  end;
end;

procedure TTBinFilter.BtnAboClick(Sender: TObject);
begin
  Close;
end;

//----------------------------------------------------------------------------//

procedure TTBinFilter.PickerDateScheduledJobsCrosses_FromChange(
  Sender: TObject);
begin
  CBScheduledJobsCrosses_From.Checked := true;
end;

//----------------------------------------------------------------------------//

procedure TTBinFilter.PickerDateScheduledJobsCrosses_ToChange(Sender: TObject);
begin
  CBScheduledJobsCrosses_To.Checked := true;
end;

//----------------------------------------------------------------------------//

procedure TTBinFilter.SetAllWc;
var
  I : Integer;
begin
  ComboBoxWC.Items.Clear;
  ComboBoxProcess.Clear;
  ComboBoxProcess.Items.Add('');
  ComboBoxWC.Enabled := true;
  ComboBoxProcess.Enabled := true;
  ComboBoxWC.Items.Add('');

  ComboBoxWCTo.Items.Clear;
  ComboBoxProcessTo.Clear;
  ComboBoxProcessTo.Items.Add('');
  ComboBoxWCTo.Enabled := true;
  ComboBoxProcessTo.Enabled := true;
  ComboBoxWCTo.Items.Add('');

  cbWkcGrp.Clear;
  cbPlant.Clear;
  cbDivision.Clear;

  cbWkcGrp.Items.Add('');
  cbPlant.Items.Add('');
  cbDivision.Items.Add('');

  for I := 0 to m_ListWC.Count - 1 do
  begin
    ComboBoxWC.Items.Add(TMqmWrkCtr(m_ListWC[I]).p_WrkCtrCode);
    ComboBoxWCTo.Items.Add(TMqmWrkCtr(m_ListWC[I]).p_WrkCtrCode);

    if cbWkcGrp.Items.IndexOf(TMqmWrkCtr(m_ListWC[I]).P_WcGrp) = -1 then
      cbWkcGrp.Items.Add(TMqmWrkCtr(m_ListWC[I]).P_WcGrp);

    if cbPlant.Items.IndexOf(TMqmWrkCtr(m_ListWC[I]).p_PlantCode) = -1 then
      cbPlant.Items.Add(TMqmWrkCtr(m_ListWC[I]).p_PlantCode);

    if cbDivision.Items.IndexOf(TMqmWrkCtr(m_ListWC[I]).p_Division) = -1 then
      cbDivision.Items.Add(TMqmWrkCtr(m_ListWC[I]).p_Division);

  end;

  for I := 0 to m_ListProces.Count - 1 do
  begin
    ComboBoxProcess.Items.Add(m_ListProces.Strings[I]);
    ComboBoxProcessTo.Items.Add(m_ListProces.Strings[I]);
  end;
end;

//----------------------------------------------------------------------------//

procedure TTBinFilter.FormDestroy(Sender: TObject);
begin
  m_Parmflt := nil;
  m_ListWC.free;
  m_ListProces.free;
end;

//----------------------------------------------------------------------------//

procedure TTBinFilter.DatePickDelivDate_FromChange(Sender: TObject);
begin
  CheckDelivDate_From.Checked := true;
end;

//----------------------------------------------------------------------------//

procedure TTBinFilter.DatePickDelivDate_ToChange(Sender: TObject);
begin
  CheckDelivDate_To.Checked := true;
end;

procedure TTBinFilter.DatePickEndDate_FromChange(Sender: TObject);
begin
  CheckEndDate_From.Checked := true;
end;

procedure TTBinFilter.DatePickEndDate_ToChange(Sender: TObject);
begin
  CheckEndDate_To.Checked := true;
end;

//----------------------------------------------------------------------------//

procedure TTBinFilter.DatePickLowDate_FromChange(Sender: TObject);
begin
  CheckLowDate_From.Checked := true;
end;

//----------------------------------------------------------------------------//

procedure TTBinFilter.DatePickLowDate_ToChange(Sender: TObject);
begin
  CheckLowDate_To.Checked := true;
end;

//----------------------------------------------------------------------------//

procedure TTBinFilter.DatePickLowStartDate_FromChange(Sender: TObject);
begin
  CheckLowStartDate_From.Checked := true;
end;

//----------------------------------------------------------------------------//

procedure TTBinFilter.DatePickLowStartDate_ToChange(Sender: TObject);
begin
  CheckLowStartDate_To.Checked := true;
end;

//----------------------------------------------------------------------------//

procedure TTBinFilter.DatePickStartDate_FromChange(Sender: TObject);
begin
  CheckStartDate_From.Checked := true;
end;

//----------------------------------------------------------------------------//

procedure TTBinFilter.DatePickStartDate_ToChange(Sender: TObject);
begin
  CheckStartDate_To.Checked := true;
end;

procedure TTBinFilter.DateTimePickerNextStartDate_FromChange(Sender: TObject);
begin
  CheckBoxNextstartDate_From.Checked := true;
end;

procedure TTBinFilter.DateTimePickerNextStartDate_ToChange(Sender: TObject);
begin
  CheckBoxNextsttartDate_To.Checked := true
end;

procedure TTBinFilter.DateTimePickerPrevEndDate_FromChange(Sender: TObject);
begin
  CheckBoxPrevEndDate_From.Checked := true
end;

procedure TTBinFilter.DateTimePickerPrevEndDate_ToChange(Sender: TObject);
begin
  CheckBoxPrevEndDate_To.Checked := true
end;

procedure TTBinFilter.dtFixedDateEarliest_fromChange(Sender: TObject);
begin
   cbFixedDateEarliest_from.Checked := True;
end;

procedure TTBinFilter.dtFixedDateEarliest_ToChange(Sender: TObject);
begin
  cbFixedDateEarliest_To.Checked := True;
end;

//----------------------------------------------------------------------------//

procedure TTBinFilter.EdtStepKeyPress(Sender: TObject; var Key: Char);
begin
  if not ((CharInSet(Key, ['0'..'9'])) or (key = chr(vk_Back)) or (Key = chr(24))) then
    abort;
end;

//----------------------------------------------------------------------------//

procedure TTBinFilter.ComboBoxWCChange(Sender: TObject);
var
  Wc : TMqmWrkCtr;
  I : Integer;
begin
  ComboBoxProcess.Items.Clear;
  ComboBoxProcess.Items.add('');
  if ComboBoxWC.Items[ComboBoxWC.ItemIndex] = '' then
    for I := 0 to m_ListProces.Count - 1 do
      ComboBoxProcess.Items.Add(m_ListProces.Strings[I])
  else
  begin
    Wc := GetWcObjByCode(ComboBoxWC.Items[ComboBoxWC.ItemIndex]);
    for I := 0 to Wc.P_GetProccesCount - 1 do
      ComboBoxProcess.Items.add(Wc.P_GetProcess[I])
  end;

end;

//----------------------------------------------------------------------------//

procedure TTBinFilter.ComboBoxWCToChange(Sender: TObject);
var
  Wc : TMqmWrkCtr;
  I : Integer;
begin
  ComboBoxProcessTo.Items.Clear;
  ComboBoxProcessTo.Items.add('');
  if ComboBoxWCTo.Items[ComboBoxWCTo.ItemIndex] = '' then
    for I := 0 to m_ListProces.Count - 1 do
      ComboBoxProcessTo.Items.Add(m_ListProces.Strings[I])
  else
  begin
    Wc := GetWcObjByCode(ComboBoxWCTo.Items[ComboBoxWCTO.ItemIndex]);
    for I := 0 to Wc.P_GetProccesCount - 1 do
      ComboBoxProcessTo.Items.add(Wc.P_GetProcess[I])
  end;
end;

//----------------------------------------------------------------------------//

function GetNumLength(Str : string; var DecNumber : integer) : integer;
var
  I : integer;
  Temp : string;
  BeforeDecimal : boolean;
begin
  DecNumber := 0;
  Result := 0;
  BeforeDecimal := true;

  for I := 1 to Length(Str) do
  begin
    Temp := copy(Str, I ,1);

    if not BeforeDecimal then
    begin
      DecNumber := DecNumber + 1;
      Continue;
    end;

    if (Temp < '0') or (Temp > '9') then
    begin
      BeforeDecimal := false;
      Continue;
    end;

    Result := Result + 1;

  end;
end;

//-------------------------------------------------------------------------

function TTBinFilter.CheckDataforProp(var str: string): boolean;
var
  I : Integer;
  PropCode : string;
  PropID : TPropID;
  len, noOfDecimal : Integer;
  LentgBeforeDec, LentgAfterDec : Integer;
begin
  Result := true;
  if m_PropComp.IsPropEnter then
  begin
    for I := 1 to m_PropComp.P_RowCount - 1 do
    begin
      //if (m_PropComp.GetPropDescVal(I) = '') then
      //begin
      //  Result := false;
      //  break
      //end
      PropCode := m_PropComp.P_GetPropVal[I];
      PropID := GetIdFromCode(PropCode);

      if (GetPropType(PropID) = CSA_Alpha) then
      begin
        len := GetLength(PropID);
        if (length(m_PropComp.P_GetValFrom[I]) > len) or ((m_PropComp.P_GetValTo[I] <> '') and
            (length(m_PropComp.P_GetValTo[I]) > len))    then
        begin
          str := PropCode + ' : ' + _('Higher then length definition');
          Result := false;
          break
        end;
      end

      else if (GetPropType(PropID) = CSA_Numerc) or (GetPropType(PropID) = CSA_Dynamic) then
      begin
        try
          StrToFloat(m_PropComp.P_GetValFrom[I])
        except
          str := PropCode + ' : ' + _('Please Insert a valid numeric value');
          Result := false;
          break
        end;

        ExistNumOfDecimal(PropID, len, noOfDecimal);
        LentgBeforeDec := GetNumLength(m_PropComp.P_GetValFrom[I], LentgAfterDec);

        if LentgBeforeDec > (len - noOfDecimal) then
        begin
          str := PropCode + ' : ' + _('Too many digits');
          Result := false;
          break
        end;

        if LentgAfterDec > noOfDecimal then
        begin
          str := PropCode + ' : ' + _('Too many decimals');
          Result := false;
          break
        end;

        try
          if (m_PropComp.P_GetValTo[I] <> '') and (StrToFloat(m_PropComp.P_GetValTo[I]) < 0) then
            Result := Result;
        except
          str := PropCode + ' : ' + _('Please Insert a valid numeric value');
          Result := false;
          break
        end;

        if (m_PropComp.P_GetValTo[I] <> '') then
        begin
          LentgBeforeDec := GetNumLength(m_PropComp.P_GetValTo[I], LentgAfterDec);

          if LentgBeforeDec > (len - noOfDecimal) then
          begin
            str := PropCode + ' : ' + _('Too many digits');
            Result := false;
            break
          end;

          if LentgAfterDec > noOfDecimal then
          begin
            str := PropCode + ' : ' + _('Too many decimals');
            Result := false;
            break
          end;

        end;
      end;

    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TTBinFilter.CheckNumeric(Sender: TObject; var Key: WideChar);
begin
  if not ((CharInSet(Key, ['0'..'9'])) or (key = chr(vk_Back)) or (key = chr(VK_DELETE)) or (Key = chr(24)) or (Key = ',')) then
      abort;
end;

//----------------------------------------------------------------------------//

procedure TTBinFilter.CLBConLevelsToMoveClickCheck(Sender: TObject);
begin
//  Exclude(m_Parmflt.RecFilt.Options, FiltTemporary);
//  Exclude(m_Parmflt.RecFilt.Options, FiltFix);
//  Include(m_Parmflt.RecFilt.Options, FiltConfLevNewLog);
end;

//----------------------------------------------------------------------------//

procedure TTBinFilter.DatePickSchedStartDate_FromChange(Sender: TObject);
begin
  CheckSchedStartDate_From.Checked := true;
end;

//----------------------------------------------------------------------------//

procedure TTBinFilter.DatePickSchedStartDate_ToChange(Sender: TObject);
begin
  CheckSchedStartDate_To.Checked := true;
end;

//----------------------------------------------------------------------------//

procedure TTBinFilter.DatePickerLatestEndingDate_FromChange(Sender: TObject);
begin
  CheckLatestEndingDate_From.Checked := true;
end;

//----------------------------------------------------------------------------//

procedure TTBinFilter.DatePickerLatestEndingDate_ToChange(Sender: TObject);
begin
  CheckLatestEndingDate_To.Checked := true;
end;

//----------------------------------------------------------------------------//

procedure TTBinFilter.FormShow(Sender: TObject);
begin
//  EditProdReq.SetFocus;
end;

//----------------------------------------------------------------------------//

end.
