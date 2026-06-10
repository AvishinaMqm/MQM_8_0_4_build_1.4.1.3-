unit FMJobHandle;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls,
  UMSchedList,
  UMSchedContFunc, UMTblDesc,
  ComCtrls, Grids,
  UMSchedView, UMOpStack, Menus, Math,
  gnugettext, Spin, UReShape, ExSpinEdit;

type
  PTframePtr = ^Tframe;
  TOperationHandle = (Split, Join);
  RoundToType = (Non, Up, Down);

  TBalanceQty = record
    framePtr: PTframePtr;
    id: TSchedId;
    ChangeToInit: boolean;
    InitChgQty : Double;
    ManChgQty: Double;
    DisableFields: boolean;

   {
    StepNo: String;
    SubStepNo: String;
    ReprocNo: String;
    JobQtyToSched: Double;
    ManChgQty: Double;
    ProgQty: Double;
    TotManualChg: Double;
    JobQtyToSchedIni: Double;
   }

end;

  PTBalanceQty = ^TBalanceQty;

type
  TFJobHandle = class(TForm)
    PnlHeader: TPanel;
    LblWorkCenterDesc: TLabel;
    STWorkCenter: TStaticText;
    LblResDesc: TLabel;
    STRes: TStaticText;
    LblResSubLine: TLabel;
    STResSubLine: TStaticText;
    LblQuantityIniStepAlt: TLabel;
    STQuantityIniAlternative: TStaticText;
    LblQuantityProg: TLabel;
    STQuantityProg: TStaticText;
    LblWCProcessDesc: TLabel;
    STWCProcess: TStaticText;
    PgCtrl: TPageControl;
    TbsSchedList: TTabSheet;
    PanelBtns: TPanel;
    TbsSplit: TTabSheet;
    Panel1: TPanel;
    PnlSplit: TPanel;
    LblSplitNo: TLabel;
    Panel2: TPanel;
    LblSplitErr: TLabel;
    StSplitErr: TStaticText;
    StCurrJobQty: TStaticText;
    LblQtyPerJob: TLabel;
    EdtQtyPerJob: TEdit;
    StNrOfNewJob: TStaticText;
    StQtyEachJob: TStaticText;
    LblCurrJobQty: TLabel;
    LblNrOfNewJob: TLabel;
    LblQtyEachJob: TLabel;
    RgSplitType: TRadioGroup;
    LblProdReq: TLabel;
    StProdReq: TStaticText;
    LblStepnum: TLabel;
    StStepNum: TStaticText;
    LblSubStep: TLabel;
    STSubStep: TStaticText;
    LblRePro: TLabel;
    STRePro: TStaticText;
    LblStpIniQty: TLabel;
    STIniQty: TStaticText;
    LblTotJobs: TLabel;
    STTotJobs: TStaticText;
    TbsReproc: TTabSheet;
    Panel3: TcxButton;
    Panel4: TPanel;
    Panel5: TPanel;
    LblQtytoReproc: TLabel;
    EdtQtyReproc: TEdit;
    LblReprocErr: TLabel;
    STReprocErr: TStaticText;
    TbsConnect: TTabSheet;
    PnlConnHead: TcxButton;
    Panel7: TPanel;
    Splitter1: TSplitter;
    GBConn: TGroupBox;
    GBToConn: TGroupBox;
    PUpToConn: TPopupMenu;
    PUpConn: TPopupMenu;
    MIConnect: TMenuItem;
    MIDisconnect: TMenuItem;
    RGQtyType: TRadioGroup;
    EdtQtyToSplit: TEdit;
    TbSBalanceQty: TTabSheet;
    Panel10: TPanel;
    Panel11: TPanel;
    SBFrames: TScrollBox;
    LblReproc: TLabel;
    LblSubstp: TLabel;
    LblQty: TLabel;
    LblAllInAll: TLabel;
    STInitQty2: TStaticText;
    LblManchgQty: TLabel;
    LblStepQty: TLabel;
    STStepQty: TStaticText;
    Panel12: TPanel;
    LlbProgrQty: TLabel;
    Label2: TLabel;
    LblFinalQty: TLabel;
    SEdtNumOfJobs: TexSpinEdit;
    BtnOk: TcxButton;
    BtnCanc: TcxButton;
    BtnUndo: TcxButton;
    BtnFixQty: TcxButton;
    BtnReproc: TcxButton;
    BtnCorrectQty: TcxButton;
    BtnJoin: TcxButton;
    BtnJoinFamily: TcxButton;
    BtnSplit: TcxButton;
    BtnDetails: TcxButton;
    BtnConnectPrev: TcxButton;
    BtnConnectNext: TcxButton;
    BtnCalcSplit: TcxButton;
    BtnSplitBack: TcxButton;
    BtnSplitfamily: TcxButton;
    BtnSplitBalance: TcxButton;
    BtnConfirmSplit: TcxButton;
    BtnReprocBack: TcxButton;
    BtnConfirmReproc: TcxButton;
    BtnConnBack: TcxButton;
    BtnConnect: TcxButton;
    BtnBalanceQtyBack: TcxButton;
    BtnBalanceQty: TcxButton;
    BitBtn1: TBitBtn;
    BtnSplitUM: TcxButton;
    STUmCode: TStaticText;
    procedure BtnSplitClick(Sender: TObject);
    procedure BtnCalcSplitClick(Sender: TObject);
    procedure BtnConfirmSplitClick(Sender: TObject);
    procedure BtnSplitBackClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnUndoClick(Sender: TObject);
    procedure BtnDetailsClick(Sender: TObject);
    procedure RgSplitTypeClick(Sender: TObject);
    procedure BtnJoinClick(Sender: TObject);
    procedure BtnReprocClick(Sender: TObject);
    procedure BtnReprocBackClick(Sender: TObject);
    procedure BtnConfirmReprocClick(Sender: TObject);
    procedure BtnConnectPrevClick(Sender: TObject);
    procedure BtnConnBackClick(Sender: TObject);
    procedure BtnConnectNextClick(Sender: TObject);
    procedure MIConnectClick(Sender: TObject);
    procedure MIDisconnectClick(Sender: TObject);
    procedure BtnConnectClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnFixQtyClick(Sender: TObject);
    procedure Edit_InitQtyKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Update_memory;
    procedure Edit_TotalQtyKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BtnBalanceQtyClick(Sender: TObject);
    procedure BtnBalanceQtyBackClick(Sender: TObject);
    procedure BtnCorrectQtyClick(Sender: TObject);
    Procedure CheckDecimal(Sender: TObject);
    procedure BtnSplitfamilyClick(Sender: TObject);
    procedure BtnJoinFamilyClick(Sender: TObject);
    procedure BtnSplitBalanceClick(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure BtnCancClick(Sender: TObject);
    procedure PgCtrlDrawTab(Control: TCustomTabControl; TabIndex: Integer;
      const Rect: TRect; Active: Boolean);
    procedure EdtQtyToSplitKeyPress(Sender: TObject; var Key: Char);

  private
    { Private declarations }
    m_Id :             TSchedId;
    m_Orig_Id :        TSchedId;
    m_OperationHandle: TOperationHandle;
    m_schedListView:   TMSchedListView;
    m_ScwConnected:    TMSchedListView;
    m_ScwToConnect:    TMSchedListView;
    m_schedList:       TMSchedList;
    m_ToConnSchedList: TMSchedList;
    m_ConnSchedList:   TMSchedList;
    m_ConnPrev:        boolean;
    m_StackMark:       TStackMark;
    m_AllChangedQTY:   Double;  //, m_SessionChangedQTY
    m_ListFrame:       Tlist;
    m_initJobsNumber:  Integer;
    m_UM            :  string;
    m_SplitByUM     :  boolean;
    m_AlternativeUM :  string;
    m_UserPackaging_SplitWitoutdecimal : boolean;
    m_AlternativeStepQty :  currency;

//    m_CalcWithNoDecimals : boolean;

    procedure InitCaptions;
    procedure InitHeader;
    procedure InitSchedList;
    procedure InitSplit(Id: TSchedId);
    procedure InitReproc(Id: TSchedId);
    procedure InitConnect(id: TSchedId; Prev: boolean);
    procedure RowChanged(Sender: TObject);
    function  ButtonStatus: boolean;
    procedure SplitTypeChanged;
//    procedure InitBalanceChange();
    procedure BuildBalanceQtyTab( m_schedList: TMSchedList );
    procedure createNewFrame(i, id: Integer; var PbaseFrame: PTframePtr;//;
                             SubStepNo, ReprocNo, Qty,TotalManQty,
                             ProgQty,FinalSchedQty: String; disableFields: boolean);//:PTframePtr;
    function  CheckStepVsJobQty(changeToInitQtyField: boolean):boolean;
    procedure displayChg(EqToStep: boolean);
    procedure UpdateFrame;
    procedure CheckSubStep;
    procedure RefreshJobColorStatus;
    function  SplitFamilyRelative(Id : TSchedId) : TList;
  public
    { Public declarations }
   constructor CreateJobHandle(AOwner: TComponent; Id: TSchedId);
   destructor Destroy; override;
  end;
  function IsInteger(Arg : string) : Boolean;

  function SortBySubStep(Item1, Item2: Pointer): Integer;
  function SplitFromDatePoint(Id : TSchedID; DatePoint : TDateTime; RestToBin : boolean;
           CheckBeforeSplit : boolean; var NewCreatedId : TSchedId; UseRoundTo : RoundToType; NumOfDec : integer) : boolean;

  function SplitMqmAccordingToMcm(Id : TSchedID; QtyListToSplit : TList) : boolean;

var
  FJobHandle: TFJobHandle;


implementation

{$R *.DFM}

uses
  Variants,
  UMSchedCont,
  UMActArea,
  UMRes,
  UMWkCtr,
  UMObjCont,
  UGglobal,
  UMGlobal,
  UMBinFunc,
  FMMainPlan,
  UMPlanFunc,
  UMCommon,
  UMCompat,
  UMSchedOnPlan,
  UMStoredProc,
  UMSchedObjMover,
  UMIssuedArt,
  FMRequirements,
  DMSrvPC;

//----------------------------------------------------------------------------//

constructor TFJobHandle.CreateJobHandle(AOwner: TComponent; Id: TSchedId);
var
  i: integer;
  qry:    TMqmQuery;
  value: variant;
  dataType: CBinColValType;
  ProdNo: string;
  StepInfo: TSQStepInfo;
  tmpQty: double;
  SplitInfo: TSQSplitInfo;
begin
  inherited Create(AOwner);
  m_Id := Id;
  m_Orig_Id := Id;
  m_SplitByUM := false;
  for i := 0 to PgCtrl.PageCount-1 do
    PgCtrl.Pages[i].TabVisible := false;

  m_StackMark := p_opStack.MarkStack;
  m_ListFrame := Tlist.Create;

  p_sc.GetSplitInfo(m_Id, SplitInfo);
  m_AlternativeUM := Trim(SplitInfo.AlternativeUM);
  m_AlternativeStepQty := SplitInfo.AlternativeQty;

  InitCaptions;
  InitHeader;

  m_schedListView        := TMSchedListView.CreateListView(TbsSchedList, m_schedList);
  m_schedListView.Options := [goFixedVertLine, goVertLine,goHorzLine,goColSizing];
  m_schedListView.Parent := TbsSchedList;
  m_schedListView.Align  := alClient;
  m_schedListView.OnClick := RowChanged;

  m_UserPackaging_SplitWitoutdecimal := false;
  if m_AlternativeUM = '' then
    m_schedListView.ColWidths[6] := -1 //hide alt.qty column
  else
  begin                   // added to support the UserPackaging AlternativeUM - currently is not in used yet
    if p_sc.CheckIfUserPackagingSplitWitoutdecimal(p_sc.GetFldDescr(m_id, CSC_PlanWkctProc, false)) then
       m_UserPackaging_SplitWitoutdecimal := true
  end;

  m_ScwConnected        := TMSchedListView.CreateListView(TbsSchedList, m_schedList);
  m_schedListView.Options := [goFixedVertLine, goVertLine,goHorzLine,goColSizing];
  m_ScwConnected.Parent := GBConn;
  m_ScwConnected.Align  := alClient;
  m_ScwConnected.PopupMenu  := PupConn;

  m_ScwToConnect        := TMSchedListView.CreateListView(TbsSchedList, m_schedList);
  m_schedListView.Options := [goFixedVertLine, goVertLine,goHorzLine,goColSizing];
  m_ScwToConnect.Parent := GBToConn;
  m_ScwToConnect.Align  := alClient;
  m_ScwToConnect.PopupMenu  := PupToConn;


  InitSchedList;
//  BuildBalanceQtyTab( m_schedList);

  qry := CreateQuery( Main_DB);
  p_sc.LoadChain(qry, p_sc.GetFldDescr(m_id, CSC_ProdReq, false));

  qry.Free;

  p_sc.GetFldValue(m_Id, CSC_ProdStep, value, dataType);
  ProdNo := p_sc.GetFldDescr(m_id, CSC_ProdReq, false);

  BtnConnectPrev.Enabled := p_sc.GetPrecStepToSched(ProdNo, value, StepInfo);
  BtnConnectNext.Enabled := p_sc.GetNextStepToSched(ProdNo, value, StepInfo);

  BtnCorrectQty.Enabled := p_sc.CheckSchedSumQty(id);
  if BtnCorrectQty.Enabled then
  begin
    p_sc.ManualChangeQty(id, tmpQty, true, false);
    BtnCorrectQty.Enabled := tmpQty = 0;

  //  BtnCorrectQty.Color := $00F3B758;
  end;
  for i := 0 to m_schedList.GetLinkCount - 1 do
  begin
    id := TSchedId(m_schedList.GetLink(i));
    p_sc.GetFldValue(id, CSC_Closed, value, dataType);
    if value then
    begin
      BtnSplit.Enabled  := false;
    //  BtnSplit.Color := clGradientActiveCaption;

      BtnJoin.Enabled   := false;
    //  BtnJoin.Color := clGradientActiveCaption;
    end;
    if BtnCorrectQty.Enabled then
    begin
      p_sc.GetFldValue(id, CSC_ProgQty, value, dataType);
      BtnCorrectQty.Enabled := BtnCorrectQty.Enabled and (value = 0);
     // BtnCorrectQty.Color := $00F3B758;
    end;
  end;

  m_schedListView.Row := m_schedList.IndexOf(m_Id)+1;
  // was there a split or join ?
  m_initJobsNumber := m_schedList.GetLinkCount;
  PgCtrl.ActivePage := TbsSchedList;
{$IfDef DEVELOP}
  BtnConnectPrev.Visible := true;
  BtnConnectNext.Visible := true;
  BnOk.Width            := 72;
  BtnOk.Left             := 375;
  BtnCanc.Width          := 72;
  BtnCanc.Left           := 453;
{$endif}
{$IfDef Customer}
  BtnConnectPrev.Visible := false;
  BtnConnectNext.Visible := false;
{$endif}

end;

//----------------------------------------------------------------------------//

destructor TFJobHandle.Destroy;
begin
  m_schedList.Free;
  m_ToConnSchedList.Free;
  m_ConnSchedList.Free;
  m_ListFrame.Free;
  inherited destroy;
end;

//----------------------------------------------------------------------------//

procedure TFJobHandle.InitCaptions;
begin
  SetComponent(LblProdReq, comp_Label, false);
  SetComponent(LblStepnum, comp_Label, false);
  SetComponent(LblSubStep, comp_Label, false);
  SetComponent(LblRePro, comp_Label, false);
  SetComponent(LblStpIniQty, comp_Label, false);
  SetComponent(LblTotJobs, comp_Label, false);
  SetComponent(LblWorkCenterDesc, comp_Label, false);
  SetComponent(LblWCProcessDesc, comp_Label, false);
  SetComponent(LblResDesc, comp_Label, false);
  SetComponent(LblResSubLine, comp_Label, false);
  SetComponent(LblQuantityIniStepAlt, comp_Label, false);
  SetComponent(LblQuantityProg, comp_Label, false);
 // SetComponent(LblQtyToSplit, comp_Label, false);
  SetComponent(LblSplitNo, comp_Label, false);
  SetComponent(LblQtyPerJob, comp_Label, false);
  SetComponent(LblCurrJobQty, comp_Label, false);
  SetComponent(LblNrOfNewJob, comp_Label, false);
  SetComponent(LblQtyEachJob, comp_Label, false);
  SetComponent(LblSplitErr, comp_Label, false);
  SetComponent(LblQtytoReproc, comp_Label, false);
  SetComponent(LblReprocErr, comp_Label, false);

  SetComponent(StProdReq, comp_Descr, false);
  SetComponent(StStepNum, comp_Descr, false);
  SetComponent(STSubStep, comp_Descr, false);
  SetComponent(STRePro, comp_Descr, false);
  SetComponent(STIniQty, comp_Descr, false);
  SetComponent(STTotJobs, comp_Descr, false);
  SetComponent(STWorkCenter, comp_Descr, false);
  SetComponent(STWCProcess, comp_Descr, false);
  SetComponent(STRes, comp_Descr, false);
  SetComponent(STResSubLine, comp_Descr, false);
  SetComponent(STQuantityIniAlternative, comp_Descr, false);
  SetComponent(STQuantityProg, comp_Descr, false);
  SetComponent(StCurrJobQty, comp_Descr, false);
  SetComponent(StNrOfNewJob, comp_Descr, false);
  SetComponent(StQtyEachJob, comp_Descr, false);
  SetComponent(StSplitErr, comp_Descr, false);
  SetComponent(StReprocErr, comp_Descr, false);

  SetComponent(EdtQtyToSplit, comp_Edit, true);
  SetComponent(EdtQtyPerJob, comp_Edit, true);
  SetComponent(EdtQtyReproc, comp_Edit, true);

 // SetComponent(STInitQty, comp_Descr, false);
 // SetComponent(STFnlQty, comp_Descr, false);
 // SetComponent(STErrQtyChg, comp_Descr, false);

end;

//----------------------------------------------------------------------------//

{function FixDecimal(Number : double) : currency;
Var
  I : Integer;
  Str : ShortString;
  Flag : boolean;
begin
  Str := FloatToStr(Number);
  if Length(Str) <= 3 then exit;

  for I := 0 to Length(str) - 1 do
  begin
    if (Str[i] = '.') then
    begin
      flag := true;
      break;
    end;
  end;


  if flag and ((Length(str) - i) > 2) then

//  if (flag) then
  begin
    Delete(Str, I, Length(str) - I);
    Number := StrToFloat(Str);
    Result := Currency(Number);
  end;


end;}

//----------------------------------------------------------------------------//

procedure TFJobHandle.InitHeader;
var
  Wc : TMqmWrkCtr;
  Res : TMqmRes;
  ProgInfo: TSQProgInfo;
  valueUM   : variant;
  dataType  : CBinColValType;
  TempExt   : Extended;
  S, TempStrQty : string;
begin
  StProdReq.Caption := p_sc.GetFldDescr(m_id, CSC_ProdReq, false);
  StStepNum.Caption := p_sc.GetFldDescr(m_id, CSC_ProdStep, false);
  STSubStep.Caption := p_sc.GetFldDescr(m_id, CSC_ProdSubStep, false);
  STRePro.Caption   := p_sc.GetFldDescr(m_id, CSC_ReprocNo, false);
  p_sc.GetFldValue(m_id, CSC_ProdUM, valueUM, dataType);
  m_UM := valueUM;
  STIniQty.Caption  := p_sc.GetFldDescr(m_id, CSC_IniQty, false) + ' ' + valueUM;
  STTotJobs.Caption := IntToStr(p_sc.GetJobNumBrothers(m_Id));
  WC := TMqmWrkCtr(p_sc.GetWrkCtrPtr(m_id));
  STWorkCenter.Caption := WC.p_WrkCtrCode + '    ' + WC.p_WrkCtrSDesc;
  STWCProcess.Caption := p_sc.GetFldDescr(m_id, CSC_WkctProc, false);

  if Assigned(p_sc.getExtLinkPtr(m_id)) then
  begin
    Res := TMqmRes(TMqmActArea(p_sc.getExtLinkPtr(m_id)).p_res);
    if Assigned(Res) then
    begin
      STRes.Caption := Res.p_ResCode + '    ' + Res.p_ResSDesc;
      STResSubLine.Caption := p_sc.GetFldDescr(m_id, CSC_SubLineRsc, false)
    end
  end else
  begin
    STRes.Caption := '----';
    STResSubLine.Caption := '----'
  end;

  STQuantityIniAlternative.Visible := false;
  LblQuantityIniStepAlt.Visible := false;

  if (m_AlternativeUM <> '') and (m_AlternativeStepQty > 0) then
  begin
  {  TempExt := Frac(m_AlternativeStepQty);
    S := FloatToStr(TempExt);
    if Length(S) > 3 then
    begin
      S := Copy(s, 2, 3);
      TempStrQty := FloatToStr(trunc(m_AlternativeStepQty));
      TempStrQty := TempStrQty + S;
      m_AlternativeStepQty := StrToFloat(TempStrQty);
    end;  }
    STQuantityIniAlternative.Caption := FloatToStr(m_AlternativeStepQty) + ' ' + m_AlternativeUM;
    STQuantityIniAlternative.Visible := true;
    LblQuantityIniStepAlt.Visible := true;
    //STQuantity.Caption := FormatFloat('0.0000', m_AlternativeQty) + ' ' + m_AlternativeUM;
  end;

  p_sc.GetProgInfo(m_id, ProgInfo);
  STQuantityProg.Caption := FloatToStr(ProgInfo.PrgQty);
  ButtonStatus;
end;

//----------------------------------------------------------------------------//

procedure TFJobHandle.RowChanged(Sender: TObject);
begin
  m_id := m_schedListView.GetSelected;
  InitHeader;
end;

//----------------------------------------------------------------------------//

function TFJobHandle.ButtonStatus: boolean;
var
  value: variant;
  datatype: CBinColValType;
begin
  result := true;
  p_sc.GetFldValue(m_Id, CSC_ProgType, value, dataType);
  try
    if (value = 'Final') or (value = 'Final and Split') then
      begin
        BtnSplit.Enabled  := false;
      //  BtnSplit.Color := clGradientInactiveCaption;

        BtnJoin.Enabled   := false;
     //   BtnJoin.Color := clGradientInactiveCaption;
        result := false;
    end//if
    else
    begin
      BtnSplit.Enabled  := true;
    //  BtnSplit.Color   := $00F3B758;

      BtnJoin.Enabled   := true;
    //  BtnJoin.Color   := $00F3B758;
      result := true;
    end;//else
    except
    end;
end;

//----------------------------------------------------------------------------//

procedure TFJobHandle.InitSchedList;
var
  i: integer;
  JobBrother: TSchedID;
  planInfo: TSQplanInfo;
begin
  if not Assigned(m_schedList) then
    m_schedList := TMSchedList.Create(self)
  else
    m_schedList.ClearList;

  for i := 0 to p_sc.GetAllJobNumOfBrothers(m_Id)-1 do
  begin
    JobBrother := p_sc.GetJobBrother(m_Id, i);
    p_sc.GetPlanInfo(JobBrother, planInfo);
    if not planInfo.isDeleted then
      m_schedList.AddLink(JobBrother);
  end;
  m_schedList.SortList(SortBySubStep);
  m_schedListView.SetSchedList(m_schedList);

end;

//----------------------------------------------------------------------------//

procedure TFJobHandle.FormClose(Sender: TObject; var Action: TCloseAction);
var
  List : TList;
  I, J : Integer;
  schedList : TMSchedList;
  JobBrother: TSchedID;
  planInfo: TSQplanInfo;
begin
  if (m_OperationHandle = split) and (m_Id <> m_Orig_Id) then
  begin
    m_Id := m_Orig_Id;
  end;

  if ModalResult <> mrOK then
  begin
    p_opStack.UndoTo(m_StackMark);
  end
  else
  begin
    FMQMPlan.ActiveUndo;
  end;

  CheckSubStep;

  List := m_schedListView.GetListIds;
  schedList := TMSchedList.Create(self);

  if Assigned(List) then
  begin
    for I := 0 to List.Count - 1 do
    begin
      for J := 0 to p_sc.GetAllJobNumOfBrothers(TSchedId(List[I])) - 1 do
      begin
        JobBrother := p_sc.GetJobBrother(TSchedId(List[I]), J);
        p_sc.GetPlanInfo(JobBrother, planInfo);
        if not planInfo.isDeleted then
          m_schedList.AddLink(JobBrother);
      end;
      break;
    end;

    for i := 0 to m_schedList.GetLinkCount - 1 do
    begin
      JobBrother := TSchedId(m_schedList.GetLink(i));
      p_sc.UpdateBalance(JobBrother)
    end;
  end;


//  p_sc.UpdateBalance(m_Id);
  RefreshJobColorStatus
end;

//----------------------------------------------------------------------------//

procedure TFJobHandle.BtnUndoClick(Sender: TObject);
begin
  p_opStack.UndoByMark(m_StackMark);
  if (m_OperationHandle = split) and (m_Id <> m_Orig_Id) then
  begin
    m_Id := m_Orig_Id;
    InitSchedList;
  end;
  m_schedListView.Row := 1; //avoid list index out of bound
  m_schedListView.Invalidate;
  InitSchedList;
  m_id := m_schedListView.GetSelected;
  InitHeader;
  p_opStack.MarkStackForButtonUndo(_('Split job'));
{  if m_initJobsNumber <> m_schedList.GetLinkCount then
    BtnFixQty.Enabled := false
  else
    BtnFixQty.Enabled := true;  }
end;

//----------------------------------------------------------------------------//

procedure TFJobHandle.BtnDetailsClick(Sender: TObject);
begin
  m_schedListView.DetailSelected;
end;

//----------------------------------------------------------------------------//
// SPLIT
//----------------------------------------------------------------------------//

procedure TFJobHandle.BtnSplitClick(Sender: TObject);
var
  id: TSchedId;
  IniVal, FinVal: variant;
  dataType: CBinColValType;
  SplitInfo: TSQSplitInfo;
begin
  id := m_schedListView.GetSelected;
  if id = CSchedIdNull then exit;

  p_sc.GetFldValue(id, CSC_IniQty, IniVal, dataType);
  p_sc.GetFldValue(id, CSC_FinQty, FinVal, dataType);

  p_sc.GetSplitInfo(m_Id, SplitInfo);
  if SplitInfo.NewReqUniqId <> '' then
  begin
    ShowMessage(_('The step was already split and saved. A request was sent to the host to split the request. ' + '#13#10' +
                _('Join is not allowed until the new request will be created in the host and arrive to mqm')));
    Exit
  end;

  if (IniVal = 0) or (FinVal = 0) then
  begin
    ShowMessage(_('Step can not be scheduled with Quantity 0'));
    Exit
  end;

  // check if changed quantity is positive
  p_sc.ManualChangeQty(m_id, m_AllChangedQTY, true, false);
  if m_AllChangedQTY > 0 then
  begin
    MessageDlg(_('Split not allowed due to positive changed quantity'), mtWarning, [mbOK], 0);
    exit; // No split if changed quantity is positive
  end;

  m_SplitByUM := false;
  STUmCode.Caption    := m_UM;
  if TcxButton(Sender).name = 'BtnSplitUM' then
  begin
    m_SplitByUM      := true;
    STUmCode.Caption := m_AlternativeUM;
  end;

  InitSplit(id);
  PgCtrl.ActivePage := TbsSplit
end;

//----------------------------------------------------------------------------//

procedure TFJobHandle.BtnSplitfamilyClick(Sender: TObject);
var
  SplitQty, QtyPerJob,
  OrigJobQty, EachJobQty: currency;
  SplitNo, NewJobNr: integer;
  NewId : TSchedID;
  Err: string;
  List,ListFamily : TList;
  I,J : Integer;
  var SplitFamilyCode : Integer;
  SplitInfo: TSQSplitInfo;
  HandaledId : TSchedId;
  ContMainReletivList : TList;
  BrothersList : TMSchedList;
  PlanInfo : TSQplanInfo;
begin
  m_OperationHandle := split;
  List := nil;
  ContMainReletivList := nil;
  BrothersList := nil;

  p_sc.GetSplitInfo(m_Id, SplitInfo);

  if ((SplitInfo.SplitAllow = CSB_Son) or (SplitInfo.SplitAllow = CSB_father)) then
  begin
    if (SplitInfo.SplitFamilyCode <> '') and p_sc.SearchFatherOrSonForSplitFamily(SplitInfo.SplitFamilyCode, BrothersList,m_Id)
       and Assigned(BrothersList) then
    begin
      SplitQty  := StrToFloat(EdtQtyToSplit.Text);
      SplitNo   := SEdtNumOfJobs.Value;

      QtyPerJob := StrToFloat(EdtQtyPerJob.Text);

      if not CalcSplitQty(m_id, RgSplitType.ItemIndex, RGQtyType.ItemIndex, SplitQty, SplitNo, QtyPerJob, OrigJobQty, EachJobQty, NewJobNr, Err) then
      begin
        STSplitErr.Caption := Err;
        StCurrJobQty.Caption  := FloatToStr(OrigJobQty);
        StQtyEachJob.Caption  := FloatToStr(EachJobQty);
        StNrOfNewJob.Caption  := IntToStr(NewJobNr);

        BtnConfirmSplit.Enabled := false;
      //  BtnConfirmSplit.Color := clGradientActiveCaption;
        BtnSplitBalance.Enabled := false;
      //  BtnSplitBalance.Color := clGradientActiveCaption;

        exit;
      end;

      for J := 0 to BrothersList.GetLinkCount - 1 do
      begin
        if not (p_sc.GetJobNumBrothers(BrothersList.GetLink(J)) = p_sc.GetJobNumBrothers(m_id)) then
        begin
          ShowMessage(' operation can not be done , familiy members are incompatible');
          exit;
        end;

        p_sc.GetPlanInfo(BrothersList.GetLink(J), PlanInfo);
        if (PlanInfo.isOnPlan) then
        begin
          ShowMessage(' Operation can not be done , familiy members are on the plan');
          Exit;
        end;

        if PlanInfo.isGroup then
        begin
          ShowMessage(' Operation can not be done , familiy members are from a group type');
          Exit;
        end;

      end;

      p_opStack.SplitJob(m_Id, OrigJobQty, EachJobQty, NewJobNr, NewId, List);

      for J := 0 to BrothersList.GetLinkCount - 1 do
      begin
        if not Assigned(ContMainReletivList) then
           ContMainReletivList := TList.Create;
        ListFamily := SplitFamilyRelative(BrothersList.GetLink(J));
        ContMainReletivList.Add(ListFamily);
      end;

      for I := 0 to List.Count - 1 do
      begin
        SP_GET_SPLIT_FAMILY_CODE(SplitFamilyCode, 'SPLITFAMILY');
        if (SplitFamilyCode = 999999999) then
           SP_Reset_SPLIT_FAMILY_CODE_Generator;

        for J  := 0 to ContMainReletivList.Count - 1 do
        begin
          ListFamily := TList(ContMainReletivList[J]);
          HandaledId := TSchedId(ListFamily[I]);
          p_sc.SetSplitFamilyCode(HandaledId, '1' + FloatToStr(SplitFamilyCode));
          p_sc.SetSplitFamilyCode(TSchedId(List[I]), '1' + FloatToStr(SplitFamilyCode));
        end;
      end
    end;

  end;

  InitSchedList;
  InitHeader;
  m_schedListView.Row := m_schedList.IndexOf(m_Id)+1;
//  BtnFixQty.Enabled := false;
  PgCtrl.ActivePage := TbsSchedList;

end;

//----------------------------------------------------------------------------//

procedure TFJobHandle.InitSplit(id: TSchedId);
begin
  p_opStack.MarkStack;
  BtnConfirmSplit.Enabled := false;
//  BtnConfirmSplit.Color := clGradientActiveCaption;

  BtnSplitBalance.Enabled := false;
 // BtnSplitBalance.Color := clGradientActiveCaption;

  BtnSplitfamily.Enabled  := false;
 // BtnSplitfamily.Color := clGradientActiveCaption;

  SEdtNumOfJobs.Value := 0;
  EdtQtyPerJob.Text  := '0';
  SplitTypeChanged;

  StCurrJobQty.Caption := EdtQtyToSplit.Text;
  StNrOfNewJob.Caption := '0';
  StQtyEachJob.Caption := '0';
  StSplitErr.Caption := '';

end;

//----------------------------------------------------------------------------//

procedure TFJobHandle.BtnCalcSplitClick(Sender: TObject);
var
  SplitQty, QtyPerJob,
  OrigJobQty, EachJobQty, OrigJobQtyAlt, EachJobQtyAlt : currency;
  SplitNo, NewJobNr: integer;
  Err: string;
  jobqty, stepqty : variant;
  dataType: CBinColValType;
begin
  if (EdtQtyPerJob.Text = '') and (RgSplitType.ItemIndex <> 0) then
  begin
    STSplitErr.Caption := _('Quantity per job cannot be empty');
    exit;
  end;

  if (EdtQtyToSplit.Text = '') then
  begin
    STSplitErr.Caption := _('Quantity to split cannot be empty');
    exit;
  end;

  SplitQty  := StrToFloat(EdtQtyToSplit.Text);
  SplitNo   := SEdtNumOfJobs.Value;
  QtyPerJob := StrToFloat(EdtQtyPerJob.Text);

  if m_SplitByUM then
    BtnConfirmSplit.Enabled := CalcSplitQtyAlternative(m_id, RgSplitType.ItemIndex, RGQtyType.ItemIndex,SplitQty, SplitNo, QtyPerJob, OrigJobQty, EachJobQty, NewJobNr, Err, OrigJobQtyAlt, EachJobQtyAlt)
  else
    BtnConfirmSplit.Enabled := CalcSplitQty(m_id, RgSplitType.ItemIndex, RGQtyType.ItemIndex,SplitQty, SplitNo, QtyPerJob, OrigJobQty, EachJobQty, NewJobNr, Err);

  BtnSplitBalance.Enabled := BtnConfirmSplit.Enabled;
  BtnSplitFamily.Enabled := BtnConfirmSplit.Enabled;

  if BtnConfirmSplit.Enabled then
  begin
    STSplitErr.Caption    := '';
    if m_SplitByUM then
    begin
      StCurrJobQty.Caption  := FloatToStr(OrigJobQtyAlt);
      StQtyEachJob.Caption  := FloatToStr(EachJobQtyAlt)
    end
    else
    begin
      StCurrJobQty.Caption  := FloatToStr(OrigJobQty);
      StQtyEachJob.Caption  := FloatToStr(EachJobQty)
    end;
    StNrOfNewJob.Caption  := IntToStr(NewJobNr);
   // BtnConfirmSplit.Color := $00F3B758;
  //  BtnSplitFamily.Color := $00F3B758;
  //  BtnSplitBalance.Color := $00F3B758;
  end else
  begin
    STSplitErr.Caption    := Err;
    StCurrJobQty.Caption  := '0';
    StQtyEachJob.Caption  := '0';
    StNrOfNewJob.Caption  := '0';
  //  BtnConfirmSplit.Color := clGradientActiveCaption;
  //  BtnSplitFamily.Color := clGradientActiveCaption;
    //.Color := clGradientActiveCaption;
  end;

  if (Err = '') and (p_sc.IsProgressed(m_Id) = prg_none) and (NewJobNr = 0) then
  begin
    Err := '0 - is not a valid quantity for current job quantity';
    STSplitErr.Caption    := Err;
    StCurrJobQty.Caption  := '0';
    StQtyEachJob.Caption  := '0';
    StNrOfNewJob.Caption  := '0';
    BtnConfirmSplit.Enabled := false;
  //  BtnConfirmSplit.Color := clGradientActiveCaption;

    BtnSplitBalance.Enabled := false;
  //  BtnSplitBalance.Color := clGradientActiveCaption;
  end;

end;

procedure TFJobHandle.BtnCancClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  Close;
end;

//----------------------------------------------------------------------------//

procedure TFJobHandle.BtnConfirmSplitClick(Sender: TObject);
var
  SplitQty, QtyPerJob,
  OrigJobQty, EachJobQty, OrigJobQtyAlt, EachJobQtyAlt : currency;
  SplitNo, NewJobNr: integer;
  NewId : TSchedID;
  Err: string;
  List : TList;
  I : Integer;
  SplitInfo: TSQSplitInfo;
  planInfo : TSQplanInfo;
  NewIdStartDate, SavedOrigStartDate : TDateTime;
  Ptr            : Pointer;
  OptsMover: SetOptsMover;
  DeltaSetupObjToMove: double;
  ErrorFound : boolean;
  moveChgInfo: TSQmoveChgInfo;
begin
  m_OperationHandle := split;
  List := nil;
  SplitQty  := StrToFloat(EdtQtyToSplit.Text);
  SplitNo   := SEdtNumOfJobs.Value;
  QtyPerJob := StrToFloat(EdtQtyPerJob.Text);
  ErrorFound := true;

  if m_SplitByUM then
  begin
    if not CalcSplitQtyAlternative(m_id, RgSplitType.ItemIndex, RGQtyType.ItemIndex, SplitQty, SplitNo, QtyPerJob, OrigJobQty, EachJobQty, NewJobNr, Err, OrigJobQtyAlt, EachJobQtyAlt) then
       ErrorFound := false;
  end
  else
  begin
     if not CalcSplitQty(m_id, RgSplitType.ItemIndex, RGQtyType.ItemIndex, SplitQty, SplitNo, QtyPerJob, OrigJobQty, EachJobQty, NewJobNr, Err) then
        ErrorFound := false;
  end;

  if not ErrorFound then
  begin
    STSplitErr.Caption := Err;

    if m_SplitByUM then
    begin
      StCurrJobQty.Caption  := FloatToStr(OrigJobQtyAlt);
      StQtyEachJob.Caption  := FloatToStr(EachJobQtyAlt);
    end
    else
    begin
      StCurrJobQty.Caption  := FloatToStr(OrigJobQty);
      StQtyEachJob.Caption  := FloatToStr(EachJobQty);
    end;
    StNrOfNewJob.Caption  := IntToStr(NewJobNr);
    BtnConfirmSplit.Enabled := false;
    BtnSplitBalance.Enabled := false;

    exit;
  end;

  p_opStack.SplitJob(m_Id, OrigJobQty, EachJobQty, NewJobNr, NewId, List);

  p_sc.GetSplitInfo(m_Id, SplitInfo);

  if ((SplitInfo.SplitAllow = CSB_Son) or (SplitInfo.SplitAllow = CSB_father)) and (SplitInfo.SplitFamilyCode <> '') then
  begin
    if (SplitInfo.SplitFamilyCode <> '') then
    begin
      if MessageDlg(_('You are about to split only part of the family , are you confirm ?'), mtConfirmation, [mbYes, mbCancel], 0) = idYes then
      begin
        for I := 0 to List.Count - 1 do
          p_sc.SetSplitFamilyCode(TSchedId(List[I]), SplitInfo.SplitFamilyCode);
      end
      else
      begin
        BtnSplitBackClick(self);
        Exit;
      end;
    end
    else
    begin
    //  for I := 0 to List.Count - 1 do
    //    p_sc.SetSplitFamilyCode(TSchedId(List[I]), SplitInfo.SplitFamilyCode);
    end;

  end;

  p_sc.GetPlanInfo(m_id, planInfo);
  SavedOrigStartDate := planInfo.startDate;
  if planInfo.isOnPlan and
      (MessageDlg(_('Leave split jobs on Gantt ? '), mtConfirmation, [mbYes, mbNo], 0) = idYes) then
  begin
    NewIdStartDate := planInfo.EndDate;
    Ptr := p_sc.GetExtLinkPtr(m_id);
    for I  := 0 to List.Count - 1 do
    begin
      p_sc.GetPlanInfo(TSchedID(List[I]), planInfo);
      planInfo.startDate := NewIdStartDate;
      p_sc.SetPlanInfo(TSchedID(List[I]), planInfo);
      p_opStack.LinkOccToApa(TSchedID(List[I]), TMqmActArea(ptr));
      p_pl.RecalcTimings(TSchedID(List[I]));
      p_sc.GetPlanInfo(TSchedID(List[I]), planInfo);
      p_opStack.ChgOccDurData(TSchedID(List[I]), planInfo);

      if TMqmActArea(ptr).ReorganizeOcc(TSchedID(List[I]), False, OptsMover, DeltaSetupObjToMove, nil, SavedOrigStartDate) <> CSM_Yes then
         exit;
      p_sc.GetPlanInfo(TSchedID(List[I]), planInfo);
      NewIdStartDate := planInfo.EndDate;
      Ptr := p_sc.GetExtLinkPtr(TSchedID(List[I]));
    end;
  end
  else
  begin
    for I  := 0 to List.Count - 1 do
    begin
      // clean what done in TMSchedCont.SplitJob if the job is scheduled and the rest will go to the bin - Avi 10 12 2025
      moveChgInfo.RscCode := '';
      moveChgInfo.SchedType := '0';
      moveChgInfo.subLinRscId := -1;
      moveChgInfo.numOfRscComp := 0;
      p_sc.SetMoveChgInfo(TSchedID(List[I]), moveChgInfo);
    end;
  end;

  InitSchedList;
  InitHeader;
  m_schedListView.Row := m_schedList.IndexOf(m_Id)+1;
//  BtnFixQty.Enabled := false;
//  if Sender is TPanel then
//  begin
  if (Sender is TcxButton) then
  begin
    if ((Sender as TcxButton).Name = 'BtnConfirmSplit')  then
      PgCtrl.ActivePage := TbsSchedList;
  end;
//  end;

end;

//----------------------------------------------------------------------------//

procedure TFJobHandle.BtnSplitBackClick(Sender: TObject);
begin
  p_opStack.UndoByMark(m_StackMark);
  m_schedListView.Row := m_schedList.IndexOf(m_Id)+1;
  PgCtrl.ActivePage := TbsSchedList;
end;

//----------------------------------------------------------------------------//

procedure TFJobHandle.BtnSplitBalanceClick(Sender: TObject);
begin
  BtnConfirmSplitClick(self);
  BtnFixQtyClick(self);
end;

//----------------------------------------------------------------------------//

procedure TFJobHandle.RefreshJobColorStatus;
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

  RefreshAfterMove(FMQMPlan);

end;

//----------------------------------------------------------------------------//

function TFJobHandle.SplitFamilyRelative(Id : TSchedId) : TList;
var
  JobQty, ProgQty: double;
  Jobvalue, Progvalue: variant;
  dataType: CBinColValType;
  SplitQty, SplitQtyOrig, QtyPerJob, SplitQtyMainId, QtyPerJobMainId,
  OrigJobQty, EachJobQty: currency;
  SplitNo, NewJobNr: integer;
  Err: string;
  NewId : TSchedId;
  DecMult : integer;
begin
  Result := nil;
  DecMult := Round(IntPower(10, p_sc.GetJobNumOfDecimals(Id)));
  if Id <> CSchedIDnull then
  begin
    p_sc.GetFldValue(Id, CSC_QtyToSched, Jobvalue, dataType);
    JobQty := Jobvalue;
    p_sc.GetFldValue(Id, CSC_ProgQty, Progvalue, dataType);
    ProgQty := Progvalue;
    SplitQty := JobQty-ProgQty;
    SplitQtyOrig := SplitQty;
    SplitNo   := SEdtNumOfJobs.Value;
    QtyPerJob := StrToFloat(EdtQtyPerJob.Text);

    if (RgSplitType.ItemIndex > 0) then
    begin
      SplitQtyMainId  := StrToFloat(EdtQtyToSplit.Text);
      QtyPerJobMainId := StrToFloat(EdtQtyPerJob.Text);
      SplitQty := (SplitQty*SplitQtyMainId)/StrToFloat(Jobvalue);
      SplitQty := trunc(SplitQty*DecMult)/DecMult;
      QtyPerJob := SplitQtyOrig*QtyPerJobMainId/StrToFloat(Jobvalue);
      QtyPerJob := trunc(QtyPerJob*DecMult)/DecMult;
    end;

    if not CalcSplitQty(Id, RgSplitType.ItemIndex, RGQtyType.ItemIndex, SplitQty, SplitNo, QtyPerJob, OrigJobQty, EachJobQty, NewJobNr, Err) then
       exit;
    p_opStack.SplitJob(Id, OrigJobQty, EachJobQty, NewJobNr, NewId, Result);

  end;

end;

//----------------------------------------------------------------------------//

procedure TFJobHandle.RgSplitTypeClick(Sender: TObject);
begin
  SplitTypeChanged;
end;

//----------------------------------------------------------------------------//

procedure TFJobHandle.SplitTypeChanged;
var
  JobQty, ProgQty, AlternativeJobQty, EdtQtyToSplitTemp : double;
  Jobvalue, Progvalue, stepqty : variant;
  dataType: CBinColValType;
  TempExt   : Extended;
  S, TempStrQty : string;
  QtyInt : Integer;
begin
  p_sc.GetFldValue(m_Id, CSC_QtyToSched, Jobvalue, dataType);
  JobQty := Jobvalue;
  p_sc.GetFldValue(m_Id, CSC_ProgQty, Progvalue, dataType);
  ProgQty := Progvalue;
  BtnConfirmSplit.Enabled := false;
 // BtnConfirmSplit.Color := clGradientActiveCaption;
  BtnSplitBalance.Enabled := false;
 // BtnSplitBalance.Color := clGradientActiveCaption;

  if m_SplitByUM then
  begin
    p_sc.GetFldValue(m_Id, CSC_IniQty ,stepqty, dataType);
    AlternativeJobQty := jobqty / StepQty * m_AlternativeStepQty;
    ProgQty := ProgQty / StepQty * m_AlternativeStepQty;
  end;

  case RgSplitType.ItemIndex of
    0:  begin //by number
          if m_SplitByUM then
            EdtQtyToSplit.Text  := FloatToStr(AlternativeJobQty-ProgQty)
          else
            EdtQtyToSplit.Text  := FloatToStr(JobQty-ProgQty);
          EdtQtyPerJob.Text     := '0';
          SEdtNumOfJobs.Value   := 0;
          EdtQtyToSplit.Enabled := true;
          SEdtNumOfJobs.Enabled := true;
          EdtQtyPerJob.Enabled  := false;
        end;
    1:  begin //by quantity
          if m_SplitByUM then
            EdtQtyToSplit.Text  := FloatToStr(AlternativeJobQty-ProgQty)
          else
            EdtQtyToSplit.Text  := FloatToStr(JobQty-ProgQty);
          SEdtNumOfJobs.Value   := 0;
          EdtQtyPerJob.Text     := '0';
          EdtQtyToSplit.Enabled := true;
          SEdtNumOfJobs.Enabled := false;
          EdtQtyPerJob.Enabled  := true;
        end;
    2:  begin
          EdtQtyToSplit.Text    := '0';
          SEdtNumOfJobs.Value   := 0;
          EdtQtyPerJob.Text     := '0';
          EdtQtyToSplit.Enabled := false;
          SEdtNumOfJobs.Enabled    := true;
          EdtQtyPerJob.Enabled  := true;
        end;
  end;

  STSplitErr.Caption     := '';
  StCurrJobQty.Caption   := '0';
  StQtyEachJob.Caption   := '0';
  StNrOfNewJob.Caption   := '0';

  EdtQtyToSplitTemp := StrToFloat(EdtQtyToSplit.Text);
 // QtyInt := (EdtQtyToSplitTemp * 100);
  EdtQtyToSplitTemp := (EdtQtyToSplitTemp * 100)/100;
  EdtQtyToSplit.Text := FloatToStr(EdtQtyToSplitTemp);


end;

//----------------------------------------------------------------------------//

function CheckJoinRelative(id : TSchedId; SelcList : TList; SplitInfo : TSQSplitInfo) : boolean;
var
  TempId,RelativId : TSchedId;
  I,J,K : Integer;
  RelativList : TList;
  MainRelativIdList, BrothersList : TMSchedList;
  ListSplitCode : TStringList;
  FirstTime : boolean;
  planInfo : TSQplanInfo;
  function IsExistSplitCodeInList(SplitFamilyCode : string) : boolean;
  var
    s : integer;
  begin
    Result := false;
    for S := 0 to ListSplitCode.Count - 1 do
    begin
      if (SplitFamilyCode = ListSplitCode.Strings[S]) then
      begin
        Result := true;
        exit;
      end;
    end;
  end;

begin

  Result := true;
  ListSplitCode := TStringList.Create;
  MainRelativIdList := nil;
  BrothersList := nil;
  p_sc.SearchFatherOrSonForSplitFamily(SplitInfo.SplitFamilyCode, MainRelativIdList, Id);

  for J := 0 to MainRelativIdList.GetLinkCount - 1 do
  begin
    if not (p_sc.GetJobNumBrothers(MainRelativIdList.GetLink(J)) = p_sc.GetJobNumBrothers(id)) then
    begin
      ShowMessage(' Operation can not be done , familiy members are incompatible');
      Result := false;
      exit;
    end;
  end;

  for J := 0 to p_sc.GetAllJobNumOfBrothers(id) - 1 do
  begin
    RelativId := p_sc.GetJobBrother(Id, J);
    p_sc.GetPlanInfo(RelativId, PlanInfo);
    if PlanInfo.isDeleted then continue;
    if PlanInfo.isOnPlan then
    begin
      ShowMessage(' Operation can not be done , familiy members are on the plan');
      Result := false;
      Exit;
    end;
    if PlanInfo.isGroup then
    begin
      ShowMessage(' Operation can not be done , familiy members are from a group type');
      Result := false;
      Exit;
    end;
    p_sc.GetSplitInfo(RelativId, SplitInfo);
    ListSplitCode.add(SplitInfo.SplitFamilyCode);
  end;

  for J := 0 to MainRelativIdList.GetLinkCount - 1 do
  begin
    RelativId := MainRelativIdList.GetLink(J);
    for I := 0 to p_sc.GetAllJobNumOfBrothers(RelativId) - 1 do
    begin
      TempId := p_sc.GetJobBrother(RelativId, I);
      p_sc.GetPlanInfo(TempId, PlanInfo);
      if PlanInfo.isDeleted then continue;

      if PlanInfo.isOnPlan then
      begin
        ShowMessage(' Operation can not be done , familiy members are on the plan');
        Result := false;
        Exit;
      end;
      if PlanInfo.isGroup then
      begin
        ShowMessage(' Operation can not be done , familiy members are from a group type');
        Result := false;
        Exit;
      end;
    end;
  end;

  for J := 0 to MainRelativIdList.GetLinkCount - 1 do
  begin
    RelativId := MainRelativIdList.GetLink(J);
    K := 0;
    for I := 0 to p_sc.GetAllJobNumOfBrothers(RelativId) - 1 do
    begin
      TempId := p_sc.GetJobBrother(RelativId, I);
      p_sc.GetPlanInfo(TempId, PlanInfo);
      if PlanInfo.isDeleted then continue;
      p_sc.GetSplitInfo(TempId, SplitInfo);

      if (ListSplitCode.Strings[K] <> SplitInfo.SplitFamilyCode) then
      begin
        ShowMessage(' Operation can not be done , familiy members have incompatible codes');
        Result := false;
        Exit;
      end;
      Inc(K);
    end;
  end;

  FirstTime := true;
  ListSplitCode.Clear;
  for I := 0 to SelcList.Count - 1 do
  begin
    TempId    := TSchedId(SelcList[I]);
    p_sc.GetSplitInfo(TempId, SplitInfo);
    if FirstTime then
    begin
      p_sc.SearchFatherOrSonForSplitFamily(SplitInfo.SplitFamilyCode, BrothersList, TempId);
      FirstTime := false;
    end;
    ListSplitCode.Add(SplitInfo.SplitFamilyCode);
  end;

  RelativList := TList.Create;
  if assigned(BrothersList) then
  begin
    for I := 0 to BrothersList.GetLinkCount - 1 do
    begin
      TempId := BrothersList.GetLink(I);
      for J := 0 to p_sc.GetAllJobNumOfBrothers(TempId) - 1 do
      begin
        p_sc.GetPlanInfo(p_sc.GetJobBrother(TempId, J), Planinfo);
        if Planinfo.isDeleted then
           continue;
        p_sc.GetSplitInfo(p_sc.GetJobBrother(TempId, J) , SplitInfo);
        if IsExistSplitCodeInList(SplitInfo.SplitFamilyCode) then
           RelativList.Add(Pointer(p_sc.GetJobBrother(TempId, J)));
      end;
      p_opStack.JoinJobs(MainRelativIdList.GetLink(I) ,RelativList);
      RelativList.Clear;
    end;
  end;

  if Assigned(BrothersList) then
     BrothersList.Free;
  if Assigned(MainRelativIdList) then
     MainRelativIdList.Free;
  if Assigned(ListSplitCode) then
     ListSplitCode.Free;

end;

//----------------------------------------------------------------------------//
// JOIN
//----------------------------------------------------------------------------//

procedure TFJobHandle.BtnJoinClick(Sender: TObject);
var
  SelcList: TList;
  I: integer;
  SplitInfo: TSQSplitInfo;
  SubStep : variant;
  dataType: CBinColValType;
begin
  SelcList := m_schedListView.GetSelectedList;

  if SelcList.Count <= 1 then
    ShowMessage(_('Please, select more than one job'))
  else
  begin
    for i := 0 to SelcList.Count-1 do
    begin
      if assigned(p_sc.GetExtLinkPtr(TSchedID(SelcList[i]))) then
      begin
        ShowMessage(_('It is not possible to join these jobs on plan'));
        exit
      end;
      p_sc.GetSplitInfo(TSchedID(SelcList[i]), SplitInfo);
      if (SplitInfo.NewReqUniqId <> '') then
      begin
        p_sc.GetFldValue(TSchedID(SelcList[i]), CSC_ProdSubStep, SubStep, dataType);
        ShowMessage(_('It is not possible to join sub step ' + IntToStr(SubStep) + ' since the job have a request from host'));
        exit
      end;

    end;
    p_opStack.MarkStack;
    m_Id := TSchedID(SelcList[0]);

    if not ButtonStatus  then
      begin
        ShowMessage(_('It is not possible to join final jobs on plan'));
        exit
      end;
    SelcList.Remove(Pointer(m_Id));

   { ConnJobsList := TMSchedList.Create(self);
    //remove the connecctions of the jobs to be deleted
    for i := 0 to SelcList.Count-1 do
    begin
      ObjID := TSchedID(SelcList[i]);

      p_sc.GetFwLinkedJobs(ObjID, ConnJobsList);
      for j := 0 to ConnJobsList.GetLinkCount-1 do
        p_opStack.ResetForwardConn(ObjID, ConnJobsList.GetLink(j));

      ConnJobsList.ClearList;
      p_sc.GetBwLinkedJobs(ObjID, ConnJobsList);
      for j := 0 to ConnJobsList.GetLinkCount-1 do
        p_opStack.ResetBackwardConn(ObjID, ConnJobsList.GetLink(j));
    end;
    ConnJobsList.Free; }




    p_sc.GetSplitInfo(m_Id, SplitInfo);
    if ((SplitInfo.SplitAllow = CSB_Son) or (SplitInfo.SplitAllow = CSB_father)) and (SplitInfo.SplitFamilyCode <> '') then
    begin
      if MessageDlg(_('You are about to join only part of the family , are you confirm ?'), mtConfirmation, [mbYes, mbCancel], 0) = idYes then
      begin

      end
      else
        exit;
    end;

    p_opStack.JoinJobs(m_Id, SelcList);

    InitSchedList;
    InitHeader;
    m_schedListView.Row := m_schedList.IndexOf(m_Id)+1;
    m_schedListView.Invalidate;

    for I := 0 to m_schedListView.RowCount - 1 do
       if m_schedListView.Selected[I] then
          m_schedListView.ForceUnselected(I);

    m_schedListView.Forceselected(m_schedListView.Row - 1);
  end;

  SelcList.Free
end;

//----------------------------------------------------------------------------//

procedure TFJobHandle.BtnJoinFamilyClick(Sender: TObject);
var
  SelcList: TList;
  I: integer;
  SplitInfo: TSQSplitInfo;
begin
  SelcList := m_schedListView.GetSelectedList;

  if SelcList.Count <= 1 then
    ShowMessage(_('Please, select more than one job'))
  else
  begin
    for i := 0 to SelcList.Count-1 do
      if assigned(p_sc.GetExtLinkPtr(TSchedID(SelcList[i]))) then
      begin
        ShowMessage(_('It is not possible to join these jobs on plan'));
        exit
      end;
    p_opStack.MarkStack;
    m_Id := TSchedID(SelcList[0]);

    if not ButtonStatus  then
      begin
        ShowMessage(_('It is not possible to join final jobs on plan'));
        exit
      end;
    SelcList.Remove(Pointer(m_Id));

    p_sc.GetSplitInfo(m_Id, SplitInfo);
    if ((SplitInfo.SplitAllow = CSB_Son) or (SplitInfo.SplitAllow = CSB_father)) and (SplitInfo.SplitFamilyCode <> '') then
    begin
      if CheckJoinRelative(m_id,SelcList,SplitInfo) then
         p_opStack.JoinJobs(m_Id, SelcList);
    end
    else
      p_opStack.JoinJobs(m_Id, SelcList);

    InitSchedList;
    InitHeader;
    m_schedListView.Row := m_schedList.IndexOf(m_Id)+1;
    m_schedListView.Invalidate;
 //   BtnFixQty.Enabled := false;
  end;

  SelcList.Free
end;

procedure TFJobHandle.BtnOkClick(Sender: TObject);
begin
 BitBtn1.Click;
end;

//----------------------------------------------------------------------------//
// REPROCESS
//----------------------------------------------------------------------------//

procedure TFJobHandle.BtnReprocClick(Sender: TObject);
var
  id: TSchedId;
begin
  id := m_schedListView.GetSelected;
  if id = CSchedIdNull then exit;

  if not assigned(p_sc.GetExtLinkPtr(id)) then
  begin
    ShowMessage(_('It is not possible to reprocess unscheduled jobs'));
    exit
  end;

  InitReproc(id);
  PgCtrl.ActivePage := TbsReproc;
end;

//----------------------------------------------------------------------------//

procedure TFJobHandle.BtnReprocBackClick(Sender: TObject);
begin
  m_schedListView.Row := m_schedList.IndexOf(m_Id)+1;
  PgCtrl.ActivePage := TbsSchedList;
end;

//----------------------------------------------------------------------------//

procedure TFJobHandle.InitReproc(id: TSchedId);
var
  value: variant;
  dataType: CBinColValType;
begin
  p_sc.GetFldValue(m_Id, CSC_QtyToSched, value, dataType);
  EdtQtyReproc.Text  := VarToStr(value);
  STReprocErr.Caption := '';
end;

//----------------------------------------------------------------------------//

procedure TFJobHandle.BtnConfirmReprocClick(Sender: TObject);
var
  ReprocQty, jobQty: currency;
  value: variant;
  dataType: CBinColValType;
begin
  p_sc.GetFldValue(m_Id, CSC_QtyToSched, value, dataType);
  jobQty := value;
  ReprocQty := StrToCurr(EdtQtyReproc.Text);

  if (ReprocQty > jobQty) then
  begin
    STReprocErr.Caption := _('The reprocess quantity is greater than the job quantity');
    exit
  end;

  if (ReprocQty <= 0) then
  begin
    STReprocErr.Caption := _('The reprocess quantity must be greater than zero');
    exit
  end;

  p_opStack.MarkStack;
  p_opStack.ReprocJob(m_Id, ReprocQty);
  InitSchedList;
  InitHeader;
  m_schedListView.Row := m_schedList.IndexOf(m_Id)+1;
  PgCtrl.ActivePage := TbsSchedList;
end;

//----------------------------------------------------------------------------//
// CONNECT
//----------------------------------------------------------------------------//

procedure TFJobHandle.BtnConnectPrevClick(Sender: TObject);
var
  id: TSchedId;
begin
  id := m_schedListView.GetSelected;
  if id = CSchedIdNull then exit;
  p_opStack.MarkStack;
  InitConnect(id, true);
  PgCtrl.ActivePage := TbsConnect;
end;

//----------------------------------------------------------------------------//

procedure TFJobHandle.BtnConnectNextClick(Sender: TObject);
var
  id: TSchedId;
begin
  id := m_schedListView.GetSelected;
  if id = CSchedIdNull then exit;
  p_opStack.MarkStack;
  InitConnect(id, false);
  PgCtrl.ActivePage := TbsConnect;
end;

//----------------------------------------------------------------------------//

procedure TFJobHandle.BtnConnBackClick(Sender: TObject);
begin
  p_opStack.UndoByMark(m_StackMark);
  m_schedListView.Row := m_schedList.IndexOf(m_Id)+1;
  PgCtrl.ActivePage := TbsSchedList;
end;

//----------------------------------------------------------------------------//

procedure TFJobHandle.BtnConnectClick(Sender: TObject);
begin

  m_schedListView.Row := m_schedList.IndexOf(m_Id)+1;
  PgCtrl.ActivePage := TbsSchedList;
end;

//----------------------------------------------------------------------------//

procedure TFJobHandle.InitConnect(id: TSchedId; Prev: boolean);
var
  i: integer;
  StepInfo: TSQStepInfo;
  value: variant;
  dataType: CBinColValType;
  ProdNo: string;
begin
  if not Assigned(m_ToConnSchedList) then
    m_ToConnSchedList := TMSchedList.Create(self)
  else
    m_ToConnSchedList.ClearList;

  if not Assigned(m_ConnSchedList) then
    m_ConnSchedList := TMSchedList.Create(self)
  else
    m_ConnSchedList.ClearList;

  p_sc.GetFldValue(m_Id, CSC_ProdStep, value, dataType);

  m_Id := id;
  m_ConnPrev := Prev;

  ProdNo := p_sc.GetFldDescr(m_id, CSC_ProdReq, false);
  if Prev then
  begin
    PnlConnHead.Caption := _('Connecting jobs of previous step');
    if not p_sc.GetPrecStepToSched(ProdNo, value, StepInfo) then exit;
  end else
  begin
    PnlConnHead.Caption := _('Connecting jobs of next step');
    if not p_sc.GetNextStepToSched(ProdNo, value, StepInfo) then exit;
  end;

  if prev then
    GBConn.Caption := _('This step')
  else
    GBConn.Caption := _('Step') + ' ' + IntToStr(StepInfo.StepNo);

  MIConnect.Enabled := true;
  MIDisconnect.Enabled := true;

  //0=no 1=many 2=one 3=one to one
  case stepInfo.connTypeToPrevious of
    0:  begin
          GBConn.Caption := GBConn.Caption + ' ' + _('connections are automatically managed');
          MIConnect.Enabled := false;
          MIDisconnect.Enabled := false
        end;
    1:  GBConn.Caption := GBConn.Caption + ' ' + _('allow to connect many previous jobs');
    2:  GBConn.Caption := GBConn.Caption + ' ' + _('allow to connect one previous job');
    3:  GBConn.Caption := GBConn.Caption + ' ' + _('allow to connect jobs one to one');
  end;

  p_sc.GetStepJobs(ProdNo, StepInfo.StepNo, m_ToConnSchedList);

  if Prev then
    p_sc.GetBwLinkedJobs(m_Id, m_ConnSchedList)
  else
    p_sc.GetFwLinkedJobs(m_Id, m_ConnSchedList);

  //remove connected jobs from the job list
  for i := 0 to m_ConnSchedList.GetLinkCount-1 do
    m_ToConnSchedList.Remove(m_ConnSchedList.GetLink(i));

  m_ScwToConnect.SetSchedList(m_ToConnSchedList);
  m_ScwConnected.SetSchedList(m_ConnSchedList);
end;

//----------------------------------------------------------------------------//

procedure TFJobHandle.MIConnectClick(Sender: TObject);
var
  SelcList: TList;
  i: integer;
  id: TSchedId;
begin
  SelcList := m_ScwToConnect.GetSelectedList;
  for i := 0 to SelcList.Count-1 do
  begin
    id := TSchedID(SelcList[i]);
    if m_ConnPrev then
      p_opStack.SetBackwardConn(m_id, id)
    else
      p_opStack.SetForwardConn(m_id, id);
  end;
  InitConnect(m_id, m_ConnPrev);
  m_ScwToConnect.Invalidate;
  m_ScwConnected.Invalidate;
end;

//----------------------------------------------------------------------------//

procedure TFJobHandle.MIDisconnectClick(Sender: TObject);
var
  SelcList: TList;
  i: integer;
  id: TSchedId;
begin
  SelcList := m_ScwConnected.GetSelectedList;
  for i := 0 to SelcList.Count-1 do
  begin
    id := TSchedID(SelcList[i]);
    if m_ConnPrev then
      p_opStack.ResetBackwardConn(m_id, id)
    else
      p_opStack.ResetForwardConn(m_id, id);
  end;
  InitConnect(m_id, m_ConnPrev);
  m_ScwToConnect.Invalidate;
  m_ScwConnected.Invalidate;
end;

procedure TFJobHandle.PgCtrlDrawTab(Control: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
begin
  with Control.Canvas do begin
    Brush.Color := clWhite;
    FillRect(Rect);
    TextOut(Rect.Left + Font.Size -5, Rect.Top + 2, (Control as TPageControl).Pages[TabIndex].Caption) ;
  end;
end;

//----------------------------------------------------------------------------//
// Balance Quantity
//----------------------------------------------------------------------------//
{
procedure TFJobHandle.InitBalanceChange();
begin
  //updateframe;
  BuildBalanceQtyTab( m_schedList);
end;
 }
//----------------------------------------------------------------------------//

procedure TFJobHandle.BuildBalanceQtyTab( m_schedList: TMSchedList );
var
  i: Integer;
  TMC: double;
  id: TSchedId;
  Value, value2: variant;
  dataType:  CBinColValType;
  BalanceQty: PTbalanceQty;
  PBaseFrame: PTframePtr;
  StepQty,
  TotalManChg,
  SubStepNo,
  ReprocNo,
  JobQtyToSchedIni,
  ProgQty,
  JobQtyToSched: String;
 // disableFields: boolean;
  J : Integer;
begin
 // p_opStack.MarkStack;
  TotalManChg := '0';
  id := 0;

  for J := 0 to m_ListFrame.Count - 1 do
    PTBalanceQty(m_ListFrame[J]).framePtr.free;

  for J := 0 to m_ListFrame.Count - 1 do
    Dispose(PTBalanceQty(m_ListFrame[J]));
  m_ListFrame.Clear;

  for I:= 0 to  m_schedList.GetLinkCount -1 do
  begin
     new(BalanceQty);
     BalanceQty.disableFields := false;

     id := TSchedId(m_schedList.GetLink(I));
     p_sc.GetFldValue(Id, CSC_ProdSubStep ,Value, dataType);
     SubStepNo := Vartostr(value);
     p_sc.GetFldValue(Id, CSC_ReprocNo ,Value, dataType);
     ReprocNo :=  Vartostr(value);
     p_sc.GetFldValue(Id, CSC_QtyToSchedIni ,Value, dataType);
     JobQtyToSchedIni :=  Vartostr(value);
     p_sc.GetFldValue(Id, CSC_ProgQty ,Value, dataType);
     ProgQty :=  Vartostr(value);
     p_sc.GetFldValue(Id, CSC_QtyToSched ,Value, dataType);
     JobQtyToSched :=  Vartostr(value);

     BalanceQty.id := id;
     BalanceQty.ChangeToInit := false;

     p_sc.ManualChangeQty(id, TMC, true, false);
     TotalManChg := floattostr(TMC);

     p_sc.GetFldValue(Id, CSC_Closed, value2, dataType);
     p_sc.GetFldValue(Id, CSC_ProgType, value, dataType);

     if (value = 'Final') or (value = 'Final and Split') or value2 then
       BalanceQty.disableFields := true;

     new(  PBaseFrame );
     PBaseFrame^ := Tframe.Create(nil);
     createNewFrame(i, Id, PbaseFrame, SubStepNo, ReprocNo,
                                     JobQtyToSchedIni,
                                     TotalManChg,
                                     ProgQty,
                                     JobQtyToSched,
                                     BalanceQty.disableFields);
     BalanceQty.framePtr := PBaseFrame;
     m_ListFrame.Add(BalanceQty);
  end;
     p_sc.GetFldValue(Id, CSC_IniQty ,Value, dataType);
     StepQty := Vartostr(value);
     STStepQty.Caption := StepQty;
     StStepQty.Color := clInfoBk;
     StStepQty.Alignment := taCenter;

     STInitQty2.Caption := StepQty;
     StInitQty2.Color := clInfoBk;
     StInitQty2.Alignment := taCenter;

     CheckStepVsJobQty(false);
end;

//----------------------------------------------------------------------------//

procedure TFJobHandle.createNewFrame(i,id: Integer; var PbaseFrame: PTframePtr;//Tframe;//PTframePtr;
                             SubStepNo,ReprocNo,Qty,TotalManQty,ProgQty,
                             FinalSchedQty: String; disableFields: boolean);//:PTframePtr;
var
  Lbl_ReprocNo: TStaticText;
  Lbl_SubStep: TStaticText;
  Lbl_ProgressedQty: TStaticText;
  Lbl_SchedQtyFinal: TStaticText;
  Edit_InitQty: TEdit;
  Edit_TotalQty: TEdit;
  CBQtyChg: TComboBox;
  baseFrame: Tframe;
begin
  baseFrame := PbaseFrame^;
  PBaseFrame^.parent := SBFrames;
  PBaseFrame^.Width := 520 * Screen.PixelsPerInch div DEFAULT_DPI + 50;
  PBaseFrame^.Height := 35 * Screen.PixelsPerInch div DEFAULT_DPI;
  BaseFrame.TabOrder := 0;
  BaseFrame.left:= -3;
  BaseFrame.top:= (I*30);//* Screen.PixelsPerInch div DEFAULT_DPI;
  BaseFrame.name := 'Frame' + InttoStr(I);
  BaseFrame.Tag := id;
  BaseFrame.Height := 35;

  Lbl_SubStep := TStaticText.Create(BaseFrame);
  Lbl_SubStep.Parent := BaseFrame;
  Lbl_SubStep.Left := LblSubstp.Left - 20;//10 * Screen.PixelsPerInch div DEFAULT_DPI;
  Lbl_SubStep.Top := 10 * Screen.PixelsPerInch div DEFAULT_DPI;
  Lbl_SubStep.Width := 50 * Screen.PixelsPerInch div DEFAULT_DPI;
  Lbl_SubStep.Height := 17 * Screen.PixelsPerInch div DEFAULT_DPI;
  Lbl_SubStep.Alignment := taCenter;
  Lbl_SubStep.AutoSize := false;
  Lbl_SubStep.Anchors := [akLeft, akBottom];
  Lbl_SubStep.Caption := SubStepNo;
  Lbl_SubStep.Color := clInfoBk;
  Lbl_SubStep.BorderStyle := sbsSunken;

  Lbl_ReprocNo := TStaticText.Create(BaseFrame);
  Lbl_ReprocNo.Parent := BaseFrame;
  Lbl_ReprocNo.Left := LblReproc.Left- 20;//(Lbl_SubStep.Left )+ (10 * Screen.PixelsPerInch div DEFAULT_DPI);
  Lbl_ReprocNo.Top := 10 * Screen.PixelsPerInch div DEFAULT_DPI;
  Lbl_ReprocNo.Width := 50 * Screen.PixelsPerInch div DEFAULT_DPI;
  Lbl_ReprocNo.Height := 17 * Screen.PixelsPerInch div DEFAULT_DPI;
  Lbl_ReprocNo.Alignment := taCenter;
  Lbl_ReprocNo.AutoSize := false;
  Lbl_ReprocNo.Anchors := [akLeft, akBottom];
  Lbl_ReprocNo.Caption := ReprocNo;
  Lbl_ReprocNo.Color := clInfoBk;
  Lbl_ReprocNo.BorderStyle := sbsSunken;

  Edit_InitQty := TEdit.Create(BaseFrame);
  Edit_InitQty.Parent   := BaseFrame;
  Edit_InitQty.Left     := LblQty.Left- 20;//(Lbl_ReprocNo.Left + Lbl_ReprocNo.Width) + (10* Screen.PixelsPerInch div DEFAULT_DPI);
  Edit_InitQty.Top      := 10 * Screen.PixelsPerInch div DEFAULT_DPI-2;
  Edit_InitQty.Width    := 60 * Screen.PixelsPerInch div DEFAULT_DPI;
  Edit_InitQty.Height   := 17 * Screen.PixelsPerInch div DEFAULT_DPI;
  Edit_InitQty.TabOrder := 1 ;
  Edit_InitQty.Text     := Qty;
//  Edit_InitQty.Enabled  := not disableFields;
  Edit_InitQty.Enabled  := true;
  Edit_InitQty.Tag      := 0;
  Edit_InitQty.OnKeyUp  := Edit_InitQtyKeyUp;
//  Edit_InitQty.OnExit   := Edit_InitQtyExit;

  CBQtyChg :=  TComboBox.Create(BaseFrame);
  CBQtyChg.Parent := BaseFrame;
  CBQtyChg.Left := LblManchgQty.Left- 20;//(Edit_InitQty.Left + Edit_InitQty.Width )+ (10 * Screen.PixelsPerInch div DEFAULT_DPI);
  CBQtyChg.Top := 10 * Screen.PixelsPerInch div DEFAULT_DPI-2;
  CBQtyChg.Width := 55 * Screen.PixelsPerInch div DEFAULT_DPI;
  CBQtyChg.Height := 17 * Screen.PixelsPerInch div DEFAULT_DPI;
  CBQtyChg.TabOrder := 2 ;
  CBQtyChg.Items.Add(_('Total'));
  CBQtyChg.Items.Add(_('Delta'));
  CBQtyChg.ItemIndex := 0;

  Edit_TotalQty := Tedit.Create(BaseFrame);
  Edit_TotalQty.Parent := BaseFrame;
  Edit_TotalQty.Left := Label2.Left- 20;//(CBQtyChg.Left + CBQtyChg.Width )+ (10* Screen.PixelsPerInch div DEFAULT_DPI);
  Edit_TotalQty.Top := 10 * Screen.PixelsPerInch div DEFAULT_DPI-2;
  Edit_TotalQty.Width := 60 * Screen.PixelsPerInch div DEFAULT_DPI;
  Edit_TotalQty.Height := 17* Screen.PixelsPerInch div DEFAULT_DPI;
  Edit_TotalQty.TabOrder := 3 ;
  Edit_TotalQty.Text := '0';
  Edit_TotalQty.Enabled := not disableFields;
  Edit_TotalQty.Tag := Round(StrToFloat(TotalManQty)); //id;
  Edit_TotalQty.OnKeyUp := Edit_TotalQtyKeyUp;

  Lbl_ProgressedQty := TStaticText.Create(BaseFrame);
  Lbl_ProgressedQty.Parent := BaseFrame;
  Lbl_ProgressedQty.Left := LlbProgrQty.Left- 20;//(Edit_TotalQty.Left + Edit_TotalQty.Width) + 10 * Screen.PixelsPerInch div DEFAULT_DPI;
  Lbl_ProgressedQty.Top := 10 * Screen.PixelsPerInch div DEFAULT_DPI;
  Lbl_ProgressedQty.Width := 60 * Screen.PixelsPerInch div DEFAULT_DPI;
  Lbl_ProgressedQty.Height := 17* Screen.PixelsPerInch div DEFAULT_DPI;
  Lbl_ProgressedQty.Alignment := taCenter;
  Lbl_ProgressedQty.AutoSize := false;
  Lbl_ProgressedQty.Anchors := [akLeft, akBottom];
  Lbl_ProgressedQty.Caption := ProgQty;
  Lbl_ProgressedQty.Color := clInfoBk;
  Lbl_ProgressedQty.BorderStyle := sbsSunken;

  Lbl_SchedQtyFinal := TStaticText.Create(BaseFrame);
  Lbl_SchedQtyFinal.Parent := BaseFrame;
  Lbl_SchedQtyFinal.Left := LblFinalQty.Left- 20;//(Lbl_ProgressedQty.Left + Lbl_ProgressedQty.Width) + 10 * Screen.PixelsPerInch div DEFAULT_DPI;//400;
  Lbl_SchedQtyFinal.Top := 10 * Screen.PixelsPerInch div DEFAULT_DPI;
  Lbl_SchedQtyFinal.Width := 60 * Screen.PixelsPerInch div DEFAULT_DPI;
  Lbl_SchedQtyFinal.Height := 17 * Screen.PixelsPerInch div DEFAULT_DPI;
  Lbl_SchedQtyFinal.Alignment := taCenter;
  Lbl_SchedQtyFinal.AutoSize := false;
  Lbl_SchedQtyFinal.Anchors := [akLeft, akBottom];
  Lbl_SchedQtyFinal.Caption := FinalSchedQty;
  Lbl_SchedQtyFinal.Color := clInfoBk;
  Lbl_SchedQtyFinal.BorderStyle := sbsSunken;
  Lbl_SchedQtyFinal.Tag := 0;

end;

//----------------------------------------------------------------------------//

procedure TFJobHandle.BtnFixQtyClick(Sender: TObject);
begin
 // InitBalanceChange();
  BuildBalanceQtyTab( m_schedList);
  PgCtrl.ActivePage := TbSBalanceQty;
end;

//----------------------------------------------------------------------------//

procedure TFJobHandle.Edit_InitQtyKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not (( (Integer(Key) > 47)  and (Integer(Key) < 59) or (key = vk_Back) or (Integer(Key) = 24)
          or ( (Integer(Key) > 94)  and (Integer(Key) < 106)) )) then// or (key = vk_Back) or (Key = 24)) then
    abort;

  CheckStepVsJobQty(true);
end;

//----------------------------------------------------------------------------//

procedure TFJobHandle.Update_memory;
var
  curEdit: Tedit;
  curFrame: Tframe;
  BalanceQty: PTbalanceQty;
  I: Integer;
begin
  for I:= 0 to m_ListFrame.Count -1 do
  begin
    try
      BalanceQty := m_Listframe.Items[i];
      curFrame := Tframe(BalanceQty.framePtr^);
      curEdit  :=  Tedit(curFrame.Components[2]);
      if curEdit.Text = '' then curEdit.Text :='0';
      BalanceQty.InitChgQty := strToFloat(curEdit.Text);
   except
   end;
  end; // for
end;

//----------------------------------------------------------------------------//

procedure TFJobHandle.Edit_TotalQtyKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not (( (Integer(Key) > 47)  and (Integer(Key) < 59) or (key = vk_Back) or (Integer(Key) = 24)
          or ( (Integer(Key) > 94)  and (Integer(Key) < 106)) )) then// or (key = vk_Back) or (Key = 24)) then
    abort;
end;

procedure TFJobHandle.EdtQtyToSplitKeyPress(Sender: TObject; var Key: Char);
begin
  if FormatSettings.DecimalSeparator = ',' then
  begin
    if Key = chr(46) then // '.'
       Key := chr(44);
    if not ((CharInSet(Key, ['0'..'9'])) or (key = chr(vk_Back)) or (Key = chr(24)) or (Key = chr(44))) then
      abort;
  end
  else
  begin
    if Key = chr(44) then // ','
       Key := chr(46);
    if not ((CharInSet(Key, ['0'..'9'])) or (key = chr(vk_Back)) or (Key = chr(24)) or (Key = chr(46))) then
      abort;
  end;
end;

//----------------------------------------------------------------------------//

Procedure TFJobHandle.CheckDecimal(Sender: TObject);
var
  I : Integer;
  value : Shortstring;
  Flag : boolean;
  Edit : TEdit;
begin
  Flag := false;
  Edit := Tedit(sender);
  value := Shortstring(Edit.Text);
  if Length(value) <= 3 then exit;

  for i := 0 to Length(value) - 1 do
  begin
    if (value[i] = '.') then
    begin
      flag := true;
      break;
    end;
  end;

  if (flag) then
    Edit.MaxLength := i + 2;
end;

//----------------------------------------------------------------------------//

function TFJobHandle.CheckStepVsJobQty(changeToInitQtyField: boolean): boolean;
var
  BalanceQty: PTbalanceQty;
  modifiedQty, stepQty: currency;
  id : TSchedId;
  Value: variant;
  datatype: CBinColValType;
  I: Integer;
begin
  update_memory;
  modifiedQty := 0;
  id := TSchedId(m_schedList.GetLink(0));
  p_sc.GetFldValue(Id, CSC_IniQty ,Value, dataType);
  StepQty := currency(value);

  for I:= 0 to m_ListFrame.Count -1 do
  begin
    try
      BalanceQty := m_Listframe.Items[i];
      modifiedQty := modifiedQty + BalanceQty.InitChgQty;
    //did the user change the Init qty ? if yes then keep it.
    if not BalanceQty.ChangeToInit then
      BalanceQty.ChangeToInit := changeToInitQtyField;
    except
    end;
  end; // for
  StInitQty2.Caption :=  FloatToStr(modifiedQty);

  displayChg(modifiedQty = stepQty);
  result := (modifiedQty = stepQty);
 end;

 //----------------------------------------------------------------------------//

procedure TFJobHandle.displayChg(EqToStep: boolean);
var
//  curEdit: Tedit;
//  BalanceQty: PTbalanceQty;
  i: Integer;
begin
  try
  if not EqToStep then
  begin
    StInitQty2.Color := clRed;
    StInitQty2.Font.Color := clWhite;
  end //if
  else
  begin
    StInitQty2.Color := clInfoBk;
    StInitQty2.Font.Color := clBlack;
  end;//else

  for I:= 0 to m_ListFrame.Count -1 do
  begin
  //  BalanceQty := m_Listframe.Items[i];
    //curEdit  :=  Tedit(BalanceQty.framePtr.Components[2]);  avi febuary 2010
    //is the init qty been changed ?
   // if (BalanceQty.ChangeToInit = false) and
   //    (BalanceQty.DisableFields = false) then
     // curEdit.Enabled := not(EqToStep); avi febuary 2010
    BtnBalanceQty.Enabled :=  EqToStep;


  end;//for

  except
  end;//try
end;

//----------------------------------------------------------------------------//

procedure TFJobHandle.BtnBalanceQtyClick(Sender: TObject);
var
  actArea: TMqmActArea;
  OptsMover: SetOptsMover;
  DeltaSetupObjToMove: double;
  i: integer;
  error: string;
  curEdit: Tedit;
  curFrame: Tframe;
  BalanceQty: PTbalanceQty;
  InitQty,
  PrevChangedQty,
  initialInitQty,
  modifiedInitQty,
  modifiedManualQty,
  modifiedTotManQty: Double;
  id : TSchedId;
  Value: variant;
  datatype: CBinColValType;
  SavedOrigStartDate : TDateTime;
  CB:  TComboBox;

  procedure ManualQtyChg();
  begin
    // Manual Qty change
    if CB.ItemIndex = 1 then  // Delta - add the change to the Total chg
      modifiedManualQty :=  modifiedTotManQty
    else  // Total quantity
      begin  // get the exact change
        if modifiedTotManQty <> 0 then
        begin
          modifiedManualQty := modifiedTotManQty - InitQty;//initialInitQty
          PrevChangedQty := 0;
          p_sc.ManualChangeQty(id,PrevChangedQty,true,false);
          //if qty was already changed before then the modi = total - prev - init
          if (PrevChangedQty + modifiedManualQty + InitQty ) <> modifiedTotManQty then
          modifiedManualQty := modifiedTotManQty - InitQty - PrevChangedQty;
        end
        else
          modifiedManualQty := 0;
      end;

     if modifiedManualQty <> 0  then //change in qty =  save qty
     begin
       curEdit.Tag := round(modifiedManualQty);
       // if the man qty has changed - save it ( false 2 flag)
       p_opStack.MarkStack;
       error := p_opStack.ChangeQuantity(Id, modifiedManualQty, false, false);
       if error <> '' then
       begin
        MessageDlg(error, mtInformation, [mbOK], 0);
        exit;
       end;
    end;  //if
   end;//procedure

   procedure InitialQtyChg();
   begin
   // Initial Qty change
     if modifiedInitQty <> 0 then
      InitQty := modifiedInitQty
    else
      InitQty := initialInitQty;

     if initialInitQty <>  modifiedInitQty  then //change in qty, so save new qty
     begin
       // if the Init qty has changed - save it ( true flag)
       modifiedInitQty := modifiedInitQty - initialInitQty;
       p_opStack.MarkStack;
       error := p_opStack.ChangeQuantity(Id, modifiedInitQty, false, true);
       if error <> '' then
       begin
        MessageDlg(error, mtInformation, [mbOK], 0);
        exit;
       end;
     end;  //if
    end;//procedure

begin
  try
  BalanceQty := nil;
  for I:= 0 to  m_ListFrame.Count -1 do
  begin
     initialInitQty    := 0;
     modifiedInitQty   := 0;
     modifiedTotManQty := 0;
     modifiedManualQty := 0;

     BalanceQty := m_Listframe.Items[i];
     curFrame := Tframe(BalanceQty.framePtr^);
     id := curFrame.Tag;
     CB := TComboBox( curFrame.Components[3]);
     curEdit  :=  Tedit( curFrame.Components[4]);
     if isInteger( curEdit.Text ) then
       modifiedTotManQty := strToFloat(curEdit.Text);

     modifiedInitQty := BalanceQty.InitChgQty;
     p_sc.GetFldValue(Id,CSC_QtyToSchedIni ,Value, dataType);
     initialInitQty := double(value);

     InitialQtyChg;
     ManualQtyChg;
  end; //for

    //if Job qty = step qty and was changed by the user
    if (CheckStepVsJobQty(false) and BalanceQty.ChangeToInit) then
    begin
      //if MessageDlg(_('No further change to the initial quantity field will be possible .')
       //     +#13+#10+_('Do you confirm ?'), mtConfirmation, [mbYes, mbNo, mbCancel], 0) = idYes
      //then
        //begin
          UpdateFrame;
          PgCtrl.ActivePage := TbsSchedList;
          if assigned(p_sc.GetExtLinkPtr(id)) then
          begin
            p_pl.RecalcTimings(id);
            actArea := p_sc.GetExtLinkPtr(id);
            SavedOrigStartDate := p_sc.GetSchedStart(id);
            actArea.ReorganizeOcc(id, False, OptsMover, DeltaSetupObjToMove, nil, SavedOrigStartDate)
          end;
          exit;
        //end; //if message
      //else
      //  exit;
     end; //try

    except
    end;
    UpdateFrame;
    PgCtrl.ActivePage := TbsSchedList;
    if assigned(p_sc.GetExtLinkPtr(id)) then
    begin
      p_pl.RecalcTimings(id);
      actArea := p_sc.GetExtLinkPtr(id);
      SavedOrigStartDate := p_sc.GetSchedStart(id);
      actArea.ReorganizeOcc(id, False, OptsMover, DeltaSetupObjToMove, nil, SavedOrigStartDate)
    end;
end;

//----------------------------------------------------------------------------//
procedure TFJobHandle.UpdateFrame;
var
  BalanceQty: PTbalanceQty;
  TempLabel: TStaticText;
  TempEdit: Tedit;
  I: Integer;
  id: TSchedId;
  Value: Variant;
  dataType: CBinColValType;
begin
  for I:= 0 to  m_ListFrame.Count -1 do
  begin
    BalanceQty := m_Listframe.Items[i];
    id := Tframe(Tframe(BalanceQty.framePtr^)).Tag;

    TempLabel := TStaticText(Tframe(BalanceQty.framePtr^).Components[0]);
    p_sc.GetFldValue(Id, CSC_ProdSubStep ,Value, dataType);
    TempLabel.Caption := vartostr(value);

    TempLabel := TStaticText(Tframe(BalanceQty.framePtr^).Components[1]);
    p_sc.GetFldValue(Id, CSC_ReprocNo ,Value, dataType);
    TempLabel.Caption :=  Vartostr(value);

    TempEdit := TEdit(Tframe(BalanceQty.framePtr^).Components[2]);
    p_sc.GetFldValue(Id, CSC_QtyToSchedIni ,Value, dataType);
    TempEdit.Text :=  Vartostr(value);

    TempLabel:= TStaticText(Tframe(BalanceQty.framePtr^).Components[5]);
    p_sc.GetFldValue(Id, CSC_ProgQty ,Value, dataType);
    TempLabel.Caption :=  Vartostr(value);

    TempLabel  := TStaticText(Tframe(BalanceQty.framePtr^).Components[6]);
    p_sc.GetFldValue(Id, CSC_QtyToSched ,Value, dataType);
    TempLabel.Caption :=  Vartostr(value);
  end;//for
end;

//----------------------------------------------------------------------------//

procedure TFJobHandle.CheckSubStep;
var
  I : Integer;
  Step, SubStepNo : integer;
  ProdReq : string;
  id : TSchedId;
  value: variant;
  dataType: CBinColValType;
  SubStepZero : boolean;
  tbiPS:      ^TTblInfo;
  qry:        TMqmQuery;
begin
  SubStepZero := false;
  Id := -1;
  for I := 0 to m_schedList.GetLinkCount - 1 do
  begin
    id := TSchedId(m_schedList.GetLink(I));
    dataType := CBT_integer;
    p_sc.GetFldValue(Id, CSC_ProdSubStep ,Value, dataType);
    SubStepNo := value;
    if SubStepNo = 0 then
    begin
      Exit;
    end;
  end;

  if not SubStepZero then
  begin
 //   ShowMessage('found');
    dataType := CBT_string;
    p_sc.GetFldValue(Id, CSC_ProdReq ,Value, dataType);
    Prodreq := value;
    dataType := CBT_integer;
    p_sc.GetFldValue(Id, CSC_ProdStep ,Value, dataType);
    Step := value;

    tbiPS := @tblInfo[tbl_prod_sched];
    // delete from the database;
    qry := CreateQuery(Main_DB);

    with qry do
    begin

      // remove the deleted PSs
      SQL.Clear;
      SQL.Add('Delete from ' + tbiPS.GetTableName);
      SQL.Add(' where ');
      SQL.Add(CreateFld(tbiPS.pfx, fli_Identifier)         + ' = ');
      SQL.Add(':' + CreateFld(tbiPS.pfx, fli_Identifier)   + ' and ');
      SQL.Add(CreateFld(tbiPS.pfx, fli_preqNo)         + ' = ');
      SQL.Add(':' + CreateFld(tbiPS.pfx, fli_preqNo)   + ' and ');
      SQL.Add(CreateFld(tbiPS.pfx, fli_pstepId)        + ' = ');
      SQL.Add(':' + CreateFld(tbiPS.pfx, fli_pstepId));
    //  Prepare;

      ParamByName(CreateFld(tbiPS.pfx, fli_Identifier)).AsString    := IniAppGlobals.Identifier;
      ParamByName(CreateFld(tbiPS.pfx, fli_preqNo)).AsString    := ProdReq;
      ParamByName(CreateFld(tbiPS.pfx, fli_pstepId)).AsInteger  := Step;
      ExecSQL;
      qry.Free;
    end;

    for I := 0 to m_schedList.GetLinkCount - 1 do
    begin
      id := TSchedId(m_schedList.GetLink(I));
      p_sc.SetJobSubStep(id , I, false, false);
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFJobHandle.BtnBalanceQtyBackClick(Sender: TObject);
begin
  PgCtrl.ActivePage := TbsSchedList;
end;

//----------------------------------------------------------------------------//

function IsInteger(Arg : string) : Boolean;
begin
  result := true;
  try
    StrToFloat(Arg);
  except
    on EConvertError do
    begin
      result := false;
    end;//on..do
  end;//try..except
end;

//----------------------------------------------------------------------------//

function SortBySubStep(Item1, Item2: Pointer): Integer;
var
  ObjID1, ObjID2: TSchedID;
  SubStep1 , SubStep2 : Integer;
  PlanInfo1, PlanInfo2 : TSQplanInfo;
begin
  ObjID1 := TSchedID(Item1);
  ObjID2 := TSchedID(Item2);

  SubStep1 := StrToInt(p_sc.GetFldDescr(ObjID1, CSC_ProdSubStep, false));
  SubStep2 := StrToInt(p_sc.GetFldDescr(ObjID2, CSC_ProdSubStep, false));

  p_sc.GetPlanInfo(ObjID1, PlanInfo1);
  if PlanInfo1.isDeleted then
     SubStep1 := -1;

  p_sc.GetPlanInfo(ObjID2, PlanInfo2);
  if PlanInfo2.isDeleted then
     SubStep2 := -1;

  if SubStep1 > SubStep2 then
    Result := 1
  else
    if SubStep1 < SubStep2 then
      Result := -1
    else
      Result := 0;
end;

//----------------------------------------------------------------------------//

procedure TFJobHandle.FormCreate(Sender: TObject);
var
  SplitInfo: TSQSplitInfo;
  valueUM : variant;
  dataType: CBinColValType;
  planInfo: TSQplanInfo;
begin
  BtnCorrectQty.StyleName := 'VLargeButton320x30';
  BtnReproc.StyleName := 'VLargeButton320x30';
  BtnFixQty.StyleName := 'VLargeButton320x30';
  BtnSplitBalance.StyleName := 'VLargeButton320x30';
  TranslateComponent (self);
//  ScaleFormSize(Self, Screen.PixelsPerInch);
  p_sc.GetSplitInfo(m_Id, SplitInfo);
  p_opStack.MarkStackForButtonUndo(_('Split Job')); //aviadd
  if ((SplitInfo.SplitAllow = CSB_Son) or (SplitInfo.SplitAllow = CSB_father)) then
  begin
    BtnSplitBack.Left := 158;
    BtnSplitfamily.Visible := true;
    BtnSplitfamily.Enabled := false;
    //BtnSplitfamily.Color := clGradientActiveCaption;
    BtnSplitfamily.left := 283;

    BtnJoinFamily.Visible := true;
    BtnSplitfamily.Enabled := true;
  //  BtnSplitfamily.Color := $00F3B758;

  end;

  p_sc.GetPlanInfo(m_Id, planInfo);

  p_sc.GetFldValue(m_Id, CSC_ProdUM, valueUM, dataType);

  BtnSplitUM.Visible := false;
  if (m_AlternativeUM <> '') //and (m_AlternativeUM <> valueUM)
  then
  begin
    BtnSplitUM.Caption := _('Split') + ' ' + m_AlternativeUM;
    BtnSplitUM.Visible := true
  end;

  if BtnSplitUM.Visible then
    BtnSplit.Caption := BtnSplit.Caption + ' ' + valueUM;

  if not planInfo.SplitAllow then
  begin
    BtnSplit.Visible := false;
    BtnSplitUM.Visible := false
  end
  else
  begin
    BtnSplit.Visible := true;
    //BtnSplitUM.Visible := true
  end;

  ReShape(Self);
end;

//----------------------------------------------------------------------------//

procedure TFJobHandle.BtnCorrectQtyClick(Sender: TObject);
var
  ProdReq,
  Status       : String;
  i            : integer;
  RealInitQty,
  InitQty,
  NewQty,
  RestQty      : double;
  Id           : TSchedId;
  Value        : variant;
  dataType     : CBinColValType;
begin
  if m_schedList.GetLinkCount < 1 then
  begin
    ShowMessage(_('No job steps found'));
    exit
  end;

  // Check whether Initial Quantity changed
  RealInitQty := 0;
  InitQty := 0;
  for i := 0 to m_schedList.GetLinkCount - 1 do
  begin
    Id := TSchedId(m_schedList.GetLink(i));
    if i = 0 then begin
      p_sc.GetFldValue(Id, CSC_ProdReq, Value, dataType);
      ProdReq := Value;
      p_sc.GetFldValue(Id, CSC_ProdStep, Value, dataType);
      p_sc.GetStepSchedQty(ProdReq, Value);
      p_sc.GetFldValue(Id, CSC_IniQty, Value, dataType);
      InitQty := Value;
    end;
    p_sc.GetFldValue(Id, CSC_QtyToSched, Value, dataType);
    RealInitQty := RealInitQty + Value;
  end;
  if RealInitQty = InitQty then
  begin
    ShowMessage(_('Scheduled job quantities are already correct'));
    exit
  end;

  // Check whether new Scheduled Quantities are valid
  RestQty := InitQty;
  for i := 0 to m_schedList.GetLinkCount - 1 do
  begin
    Id := TSchedId(m_schedList.GetLink(i));
    p_sc.GetFldValue(Id, CSC_QtyToSched, Value, dataType);
    NewQty := RoundDblToDbl(Value / RealInitQty * InitQty, 2);
    RestQty := RestQty - NewQty;
    Status := p_sc.ChangeSchedQty(Id, NewQty, true);
    if Status <> '' then
    begin
      ShowMessage(Status);
      exit
    end;
  end;

  // Change Scheduled Quantities
  p_opStack.MarkStack;
  for i := 0 to m_schedList.GetLinkCount - 1 do
  begin
    Id := TSchedId(m_schedList.GetLink(i));
    p_sc.GetFldValue(Id, CSC_QtyToSched, Value, dataType);
    p_opStack.UpdateSchedQuantity(Id, Value, RoundDblToDbl(Value / RealInitQty * InitQty, 2) + RestQty);
    if i = 0 then
      RestQty := 0;
  end;
  InitSchedList;
  InitHeader;
  m_schedListView.Invalidate;
  m_schedListView.Row := m_schedList.IndexOf(m_Id)+1;
end;

//----------------------------------------------------------------------------//

function SplitFromDatePoint(Id : TSchedID; DatePoint : TDateTime; RestToBin : boolean;
         CheckBeforeSplit : boolean; var NewCreatedId : TSchedId; UseRoundTo : RoundToType; NumOfDec : integer) : boolean;
var
  QtyAtDate : currency;
  VisRes    : TMqmVisibleRes;
  JobQty, ProgQty, Temp: double;
  value: variant;
  dataType: CBinColValType;
  QtyPerJob, OrigJobQty, EachJobQty: currency;
  List : TList;
  NewID : TSchedID;
  NewIdStartDate : TDateTime;
  planInfo       : TSQplanInfo;
  Ptr            : Pointer;
  OptsMover: SetOptsMover;
  DeltaSetupObjToMove: double;
  MarkStack: TStackMark;
  ResComp : Integer;
  S : string;
  TempExt : Extended;
  ObjMover  : TMqmSchedObjMover;
  Res : TMqmVisibleRes;
  ResMain : TMqmRes;
  setup, overlap, duration : double;
  TmpEndDate : TDateTime;
  MacSetupRec: TMacSetup;
  TimingInfo: TSQtimingInfo;
  ProdStep, WkcProc: String;
  MachSetupCodeList :TMQMMacSetupList;
  IssArtList: TMQMIssuedArtList;
  FrmMat: TFMaterialReq;
  DecMult : integer;
begin
  Result := true;
  MarkStack := -1;
  DecMult := Round(IntPower(10, p_sc.GetJobNumOfDecimals(Id)));
  if not CheckBeforeSplit then
  begin
    MarkStack := p_opStack.MarkStack;
    p_opStack.MarkStackForButtonUndo(_('Split scheduled Job On Gantt'));
  end;
  VisRes := TMqmVisibleRes(TMqmActArea(p_sc.GetExtLinkPtr(id)).p_Father);
  QtyAtDate := p_sc.GetJobQtyAtDate(Id, VisRes, DatePoint);

  {if (NumOfDec > -1) and (UseRoundTo <> Non) then
  begin
    if UseRoundTo = up then
       QtyAtDate := RoundTo(QtyAtDate, NumOfDec * (-1))
    else if UseRoundTo = Down then
    begin
      TempExt := Frac(QtyAtDate);
      S := FloatToStr(TempExt);

      if NumOfDec = 1 then
      begin
        if Length(S) > 3 then
          S := Copy(s, 0, 3);
      end
      else if NumOfDec = 2 then
      begin
        if Length(S) > 4 then
          S := Copy(s, 0, 4);
      end;

      QtyAtDate := trunc(QtyAtDate);
      QtyAtDate := QtyAtDate + StrToFloat(s);

    end;
  end; }

  p_sc.GetFldValue(Id, CSC_QtyToSched, value, dataType);
  JobQty := value;
  p_sc.GetFldValue(Id, CSC_ProgQty, value, dataType);
  ProgQty := value;

//  SplitQty   := JobQty-ProgQty;
  QtyPerJob := trunc(QtyAtDate*DecMult)/DecMult;

  OrigJobQty := QtyPerJob;
  EachJobQty := JobQty - QtyPerJob;
  EachJobQty := trunc(EachJobQty*DecMult)/DecMult;

  if (NumOfDec > -1) and (UseRoundTo <> Non) then
  begin
    if UseRoundTo = up then
       EachJobQty := RoundTo(EachJobQty, NumOfDec * (-1))
    else if UseRoundTo = Down then
    begin
      TempExt := Frac(EachJobQty);
      S := FloatToStr(TempExt);

      if NumOfDec = 1 then
      begin
        if Length(S) > 3 then
          S := Copy(s, 0, 3);
      end
      else if NumOfDec = 2 then
      begin
        if Length(S) > 4 then
          S := Copy(s, 0, 4);
      end;

      EachJobQty := trunc(EachJobQty);
      EachJobQty := EachJobQty + StrToFloat(s);

    end;
  end;

  Temp := JobQty - (OrigJobQty + EachJobQty);
  OrigJobQty := OrigJobQty + Temp;

  if CheckBeforeSplit then
  begin
    if (EachJobQty = 0) or (OrigJobQty = 0) then
      Result := false;
    if QtyPerJob <= ProgQty then
      Result := false;
    exit;
  end;

  p_opStack.SplitJob(Id, OrigJobQty, EachJobQty, 1, NewId, List);

  if not RestToBin then
  begin
    p_sc.GetPlanInfo(id, planInfo);
    NewIdStartDate := planInfo.EndDate;
    Ptr := p_sc.GetExtLinkPtr(id);
    p_opStack.LinkOccToApa(NewId, TMqmActArea(ptr));
    p_sc.GetPlanInfo(NewId, planInfo);
    planInfo.startDate := NewIdStartDate;
    p_sc.SetPlanInfo(NewId, planInfo);

    OccMoveEnter(FMQMPlan, Pointer(NewId));
    ObjMover := TMqmSchedObjMover.Create;
    ObjMover.SetObjToMove(NewId);
    Res := TMqmVisibleRes(TMqmActArea(ptr).p_Father);
    if p_sc.GetRscComponentFromJobOrStep(NewId) > 0 then
      ResComp := p_sc.GetRscComponentFromJobOrStep(NewId)
    else
      ResComp := Res.p_ResComp;
    if ObjMover.ChangeTo(TMqmActArea(ptr), NewIdStartDate, false, CSchedIDnull, Al_toDate, setup, overlap,
                         duration, '', TmpEndDate, OptsMover, nil, False, DeltaSetupObjToMove,false, ResComp) = CSM_Yes then
    begin
    end
    else
      ObjMover.Abort;
    OccMoveExit(FMQMPlan, true);
    if TMqmActArea(ptr).ReorganizeOcc(NewId, False, OptsMover, DeltaSetupObjToMove, nil, DatePoint) <> CSM_Yes then
    begin
      Result := false;
      p_opStack.UndoTo(MarkStack);
    end;

    // to avoid the yellow net - avi 16.01.2018  - kind of refresh to the main iD materials
    MacSetupRec.WrkCtrCode := TimingInfo.wkctCode;
    MacSetupRec.MachineSetupCode := TimingInfo.MachSetupCode;

    ProdStep := p_sc.GetFldDescr(id, CSC_ProdStep, false);
    WkcProc :=  p_sc.GetFldDescr(id, CSC_WkctProc, false);

    MachSetupCodeList := p_sc.GetStepIssMaterials(id);

    if planInfo.isOnPlan then
    begin
      ResMain := TMqmRes(TMqmActArea(p_sc.getExtLinkPtr(id)).p_res);
      if Assigned(Res) then
      begin
        MacSetupRec.ResCat := ResMain.p_ResCat.p_ResCatCode;
        MacSetupRec.ResCode := ResMain.p_ResCode;
        MacSetupRec.WrkCtrCode := TMqmWrkCtr(ResMain.p_WrkCtr).p_WrkCtrCode;

        IssArtList := TMQMIssuedArtList.Create(true);
        MachSetupCodeList.GetIssuedArtList(MacSetupRec, IssArtList);

        FrmMat := TFMaterialReq.CreateReqForm(GetPlanView ,id,IssArtList);
        FrmMat.Free;
        IssArtList.Free;
      end;
    end
  end
  else
  begin
    p_sc.GetPlanInfo(Id, planInfo);
    p_opStack.ChgOccDurData(Id, planInfo);
  end;

  NewCreatedId := NewID;
  FMQMPlan.ActiveUndo;

end;

//----------------------------------------------------------------------------//

function SplitMqmAccordingToMcm(Id : TSchedID; QtyListToSplit : TList) : boolean;
var
  QtyAtDate : currency;
  VisRes    : TMqmVisibleRes;
  JobQty, ProgQty, Temp: double;
  value: variant;
  dataType: CBinColValType;
  QtyPerJob, OrigJobQty, EachJobQty: currency;
  List : TList;
  NewID : TSchedID;
  I : Integer;
  PlanWkctCode, PlanprocessCode : string;
  wc : TMqmWrkCtr;
  AltWcProcess : TWorkCenterInfo;
  DecMult : integer;
begin
  DecMult := Round(IntPower(10, p_sc.GetJobNumOfDecimals(Id)));

  for I := 0 to QtyListToSplit.Count - 1 do
  begin

    if I = 0 then
    begin
      PTMQMSplitInfoFromMcm(QtyListToSplit[I]).Id := id;
      continue;
    end;

    p_sc.GetFldValue(Id, CSC_QtyToSched, value, dataType);
    JobQty := value;
    p_sc.GetFldValue(Id, CSC_ProgQty, value, dataType);
    ProgQty := value;

    QtyPerJob := PTMQMSplitInfoFromMcm(QtyListToSplit[I]).Qty;

    OrigJobQty := QtyPerJob;
    EachJobQty := JobQty - QtyPerJob;
    EachJobQty := trunc(EachJobQty*DecMult)/DecMult;

    Temp := JobQty - (OrigJobQty + EachJobQty);
    OrigJobQty := OrigJobQty + Temp;

    p_opStack.SplitJob(Id, EachJobQty, OrigJobQty, 1, NewId, List);
    PTMQMSplitInfoFromMcm(QtyListToSplit[I]).Id := NewId;

  end;

  for I := 0 to QtyListToSplit.Count - 1 do
  begin
    if (PTMQMSplitInfoFromMcm(QtyListToSplit[I]).SchedwkCtrCode <> '') then
    begin
      wc := TMqmWrkCtr(p_pl.FindWrkCtrByCode(PTMQMSplitInfoFromMcm(QtyListToSplit[I]).SchedwkCtrCode));
      if assigned(wc) then
      begin
        AltWcProcess.AlterWorkCenter := PTMQMSplitInfoFromMcm(QtyListToSplit[I]).SchedwkCtrCode;
        AltWcProcess.AlterProcess    := PTMQMSplitInfoFromMcm(QtyListToSplit[I]).ProcessCode;
        p_sc.SetWcProcessAlternative(PTMQMSplitInfoFromMcm(QtyListToSplit[I]).Id, wc, AltWcProcess , wc.p_ReadOnly);
      end;
    end;
  end;

end;

//----------------------------------------------------------------------------//

end.
