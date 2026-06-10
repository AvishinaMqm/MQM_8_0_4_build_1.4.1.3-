unit FMOccMov;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Classes, UMBinTbs, Graphics, Controls, Forms, Dialogs,
  UMSchedContFunc, UMRes,
  UMActArea, StdCtrls, UMSchedObjMover, Buttons, ComCtrls, ExtCtrls, gnugettext,
  Spin,
  //VCLTee.TeCanvas,
  UReShape, ExSpinEdit, Vcl.Mask, cxGraphics, dxUIAClasses, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus;

type

  TOccMoveSrvFunc   = procedure (ptr: pointer);
  TOccMoveEnterFunc = procedure (ptr1, ptr2: pointer);
  TOccMoveExitFunc  = procedure (ptr: pointer; BtnOk : boolean);

  TFMOccMove = class(TForm)
    PGCmove: TPageControl;
    TbsGen: TTabSheet;
    LblSetup: TLabel;
    StSetup: TStaticText;
    StExec: TStaticText;
    LblExe: TLabel;
    TbsOptions: TTabSheet;
    LblComments: TLabel;
    EdtComments: TEdit;
    TbsErrors: TTabSheet;
    MemErrors: TMemo;
    RGSchedType: TRadioGroup;
    TabDet: TTabSheet;
    PnlQty: TPanel;
    LblBatchMin: TLabel;
    StBchMinLev: TStaticText;
    StBchStdLev: TStaticText;
    StBchMaxLev: TStaticText;
    StBchMaxToLev: TStaticText;
    LblMaxAvail: TLabel;
    StBchStdToLev: TStaticText;
    LblStdAvail: TLabel;
    PnlResData: TPanel;
    StTgtSubRes: TStaticText;
    LblSubRes: TLabel;
    StTgtRes: TStaticText;
    LblResource: TLabel;
    StTgtWkc: TStaticText;
    LBlWorkCenter: TLabel;
    LblBatchStd: TLabel;
    LblBatchMax: TLabel;
    LblBatchQty: TLabel;
    StBatchQty: TStaticText;
    Panel1: TPanel;
    LblOcc: TLabel;
    StOcc: TStaticText;
    LblQty: TLabel;
    STQty: TStaticText;
    LblSupOvlp: TLabel;
    StSupOvlp: TStaticText;
    TbsActions: TTabSheet;
    RGMoveActions: TRadioGroup;
    CBoxTimeSele: TComboBox;
    LblTimeSele: TLabel;
    LblNext: TLabel;
    LblDays: TLabel;
    SpnEdtDays: TexSpinEdit;
    lblID: TLabel;
    LblBatchQuantity: TLabel;
    STBatchQuantity: TStaticText;
    STBatchResQuantity: TStaticText;
    Label1: TLabel;
    CBLogInfo: TCheckBox;
    gboxComponents: TGroupBox;
    LblCompMax: TLabel;
    LblCompMaxavl: TLabel;
    stMaxComponents: TStaticText;
    btnView: TcxButton;
    btnAbort: TcxButton;
    btnOk: TcxButton;
    btnForce: TcxButton;
    btnApply: TcxButton;
    BtnCompactEnt: TcxButton;
    Label2: TLabel;
    LbEInputUser: TLabeledEdit;
    STAlternativeQty: TStaticText;
    LblAlternativeQty: TLabel;
    lblEdtComponents: TLabeledEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOkClick(Sender: TObject);
    procedure BtnAbortClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnCompactEntClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CBoxTimeSeleChange(Sender: TObject);
    procedure RGSchedTypeClick(Sender: TObject);
    procedure Reset;
    procedure BtnForceClick(Sender: TObject);
    procedure btnViewStepDetailsClick(Sender: TObject);
    procedure lblEdtComponentsKeyPress(Sender: TObject; var Key: Char);
    procedure LbEInputUserChange(Sender: TObject);
//    procedure bbtnApplyCompClick(Sender: TObject);
    procedure EdtCommentsChange(Sender: TObject);
    procedure BtnApplyClick(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure PGCmoveDrawTab(Control: TCustomTabControl; TabIndex: Integer;
      const Rect: TRect; Active: Boolean);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    m_FromBin : boolean;
    m_ObjMover: TMqmSchedObjMover;
    m_suppFnc:  TOccMoveSrvFunc;
    m_suppObj:  TObject;
    m_exitFnc:  TOccMoveExitFunc;
    m_InputUser, m_OldValueUser, m_OldValueComponents: integer; // Only for avoid problems with enabled or not "Ok" button
    m_LastValueComp: integer;
    m_LastRes : TMQMRes;
    m_LastVisRes: TMqmVisibleRes;
    m_ResultChangeTo : CScMovementResult;
    m_ResComponentChanged : boolean;
    RowIndex : Integer;

//    procedure InitWidth_Lbl;
    procedure ChangeTo(actArea: TMqmActArea; date: TDateTime; isEnd: boolean; ToId: TSchedID; PlanClicked : boolean);
    procedure UpdateQtyFieds(actArea: TMqmActArea);
  public
    property p_ObjMover: TMqmSchedObjMover       read m_ObjMover;
  end;

  procedure OpenOccMoveForm(AOwner: TWinControl; id: TSchedID;
                            fnc: TOccMoveSrvFunc; obj: TObject;
                            fncEnter: TOccMoveEnterFunc; fncExit: TOccMoveExitFunc; AtLeastOneMultiResExist : boolean);
  function  GetOccMoveForm: TFMOccMove;
  procedure ChangeOccTo(actArea: TMqmActArea; date: TDateTime; isEnd: boolean; id: TSchedID; PlanClicked: boolean);

implementation

{$R *.DFM}

uses
  Variants,
  UMSchedCont,
  UMPlanObj,
  UMPlanTbs,
  UMCompat,
  UMGlobal,
  UMObjCont,
  FMMainPlan,
  UMCommon,
  FMStepDetails,
//  UMRes,
  UGGlobal,
  UMWkCtr,
  UMPlanFunc,
  UMBalance,
  FMGroupDetail,
  UMSchedOnPlan,
  FMGrpSplit,
  {$ifdef Big}
  FGinfo,
  {$endif}

  FMbin;

var
  FMOccMove: TFMOccMove;

//----------------------------------------------------------------------------//

procedure OpenOccMoveForm(AOwner: TWinControl; id: TSchedID;
                          fnc: TOccMoveSrvFunc; obj: TObject;
                          fncEnter: TOccMoveEnterFunc;
                          fncExit: TOccMoveExitFunc; AtLeastOneMultiResExist : boolean);
type
  TCompOnClick  = procedure (Sender: TObject) of object;
var
  moveChgInfo: TSQmoveChgInfo;
  SplitInfo: TSQSplitInfo;
  FieldVal, value : variant;
  dataType: CBinColValType;
  SplitQty, QtyPerJob,
  OrigJobQty, EachJobQty, GroupQty: currency;
  SplitNo, NewJobNr: integer;
  Err: string;
  ResComp, G : integer;
  TempOnClick: TCompOnClick;
  Res: TMQMRes;
  NewId, ChildId : TSchedID;
  List : TList;
  ChecksplitGroup : boolean;
  NumOfres, DecMult : Integer;
begin
  List := nil;
  ChecksplitGroup := true;
  if p_sc.IsGroup(Id) then
  begin
    for G := 0 to p_sc.GetGrpNumSons(Id) - 1 do
    begin
      ChildId := p_sc.GetGrpSon(Id, G);
      if not (p_sc.GetFldValue(ChildId, CSC_NumOfRscPlan, FieldVal, dataType)
      and (p_sc.IsProgressed(ChildId) = prg_none)
      and (FieldVal >= 2)
      and (p_sc.GetJobNumBrothers(ChildId) = 1)
      and not Assigned(p_sc.GetExtLinkPtr(ChildId))) then
      begin
        ChecksplitGroup := false;
        break
      end;
    end;

    if ChecksplitGroup then
    begin
      if MessageDlg(_('Those group steps are planned to be produced on') + ' '
                      + VarToStr(FieldVal) + ' ' + _('resources,') + #13#10 +
                    _('do you want to split before proceeding?'), mtConfirmation, [mbYes, mbNo], 0) = idYes then
      begin
        p_opStack.MarkStackForButtonUndo(_('split before proceeding'));
        NumOfres := FieldVal;
        p_sc.GetFldValue(Id, CSC_QtyToSched, value, dataType);
        GroupQty := value;
        // per-resource portion, floored to the job's own decimal precision (was hardcoded to 2
        // decimals). The remainder stays on the last (original) group; SplitGroup carves each
        // peeled group exactly to this quantity.
        DecMult := 1;
        for G := 1 to p_sc.GetJobNumOfDecimals(Id) do DecMult := DecMult * 10;
        groupQty := trunc(groupQty / NumOfres * DecMult) / DecMult;
        for G := 0 to NumOfres - 2 do
          SplitGroup(id, groupQty, true);
      end;
    end;

  end
  else
  begin
    if p_sc.GetFldValue(id, CSC_NumOfRscPlan, FieldVal, dataType)
    and (p_sc.IsProgressed(id) = prg_none)
    and (FieldVal >= 2)
    and (p_sc.GetJobNumBrothers(id) = 1)
    and not Assigned(p_sc.GetExtLinkPtr(id)) then
    begin
      if MessageDlg(_('This step is planned to be produced on') + ' '
                      + VarToStr(FieldVal) + ' ' + _('resources,') + #13#10 +
                    _('do you want to split before proceeding?'), mtConfirmation, [mbYes, mbNo], 0) = idYes then
      begin
        p_opStack.MarkStackForButtonUndo(_('split before proceeding'));
        p_sc.GetSplitInfo(id, SplitInfo);
        SplitQty := SplitInfo.quant;
        SplitNo  := FieldVal;
        QtyPerJob := 0;
        if not CalcSplitQty(id, 0, 0, SplitQty, SplitNo, QtyPerJob, OrigJobQty, EachJobQty, NewJobNr, Err)
        or not p_opStack.SplitJob(Id, OrigJobQty, EachJobQty, NewJobNr, NewId, List) then
          showmessage(_('Errors splitting the job'));
      end;
    end;
  end;

  p_opStack.MarkStackForButtonUndo(_('Move'));
  if not Assigned(FMOccMove) then
  begin
    FMOccMove := TFMOccMove.Create(AOwner);
    FMOccMove.formStyle := fsStayOnTop;
    ReShape(FMOccMove)
  end;

  p_sc.SetFlags(id,[],[CSF_moveSelect]);
  if Assigned(fncEnter) then fncEnter(obj, pointer(id));

  with FMOccMove do
  begin
    lblID.Caption := IntToStr(id);
    m_ResComponentChanged := false;
    m_ObjMover := TMqmSchedObjMover.Create;
    m_ObjMover.SetObjToMove(id);
    p_sc.GetMoveChgInfo(id, moveChgInfo);
    EdtComments.Text := moveChgInfo.comment;

    BtnCompactEnt.Enabled := false;
    if not DBAppGlobals.MCM_App or (DBAppGlobals.MCM_App and (IniAppGlobals.MCMasMQM = 1)) then
       BtnCompactEnt.Enabled := true;

    Res := TMQMRes(p_pl.FindResByCode(moveChgInfo.RscCode));
    if Assigned(Res) and Res.p_isMultiRes then
    begin
      GboxComponents.Visible := true;
      m_OldValueComponents := moveChgInfo.numOfRscComp;
      lblEdtComponents.Text := IntToStr(moveChgInfo.numOfRscComp);
      LbEInputUser.Text  := IntToStr(moveChgInfo.numOfRscComp);

      m_LastValueComp := m_OldValueComponents;
     // if lblEdtComponents.Text <> '' then
     //   m_LastValueComp := StrToInt(lblEdtComponents.Text);
      if p_sc.GetRscComponentFromJobOrStep(id) > 0 then
        ResComp := p_sc.GetRscComponentFromJobOrStep(id)
      else
        ResComp := Res.p_ResComp;
      stMaxComponents.Caption := IntToStr(Res.p_ResComp);

    end
    {else if AtLeastOneMultiResExist then
    begin


    end  }
    else
      GboxComponents.Visible := false;

    if moveChgInfo.RscCode = '' then
      m_FromBin := true
    else
      m_FromBin := false;

    TempOnClick := RGSchedType.OnClick;
    RGSchedType.OnClick := nil;

    RGSchedType.Items.Clear;
    RGSchedType.Items.Add(_('Final schedule'));
    if DBAppGlobals.ConfLevels >= 1 then
      RGSchedType.Items.Add(_('Initial schedule'));
    if DBAppGlobals.ConfLevels >= 2 then
      RGSchedType.Items.Add(_('Confirmation level 1'));
    if DBAppGlobals.ConfLevels >= 3 then
      RGSchedType.Items.Add(_('Confirmation level 2'));
    if DBAppGlobals.ConfLevels >= 4 then
      RGSchedType.Items.Add(_('Confirmation level 3'));
    if DBAppGlobals.ConfLevels >= 5 then
      RGSchedType.Items.Add(_('Confirmation level 4'));
    if DBAppGlobals.ConfLevels >= 6 then
      RGSchedType.Items.Add(_('Confirmation level 5'));

    if RGSchedType.Items.Count < DBAppGlobals.DefSchedType then
      RGSchedType.ItemIndex := RGSchedType.Items.Count-1
    else
      RGSchedType.ItemIndex := DBAppGlobals.DefSchedType-1;

    if      moveChgInfo.SchedType = '1' then
      RGSchedType.ItemIndex := 1
    else if moveChgInfo.SchedType = '2' then
      RGSchedType.ItemIndex := 0
    else if moveChgInfo.SchedType = '3' then
      //RGSchedType.Enabled := false
      RGSchedType.ItemIndex := 2
    else if moveChgInfo.SchedType = '4' then
      RGSchedType.ItemIndex := 3
    else if moveChgInfo.SchedType = '5' then
      RGSchedType.ItemIndex := 4
    else if moveChgInfo.SchedType = '6' then
      RGSchedType.ItemIndex := 5
    else if moveChgInfo.SchedType = '7' then
      RGSchedType.ItemIndex := 6
    else if moveChgInfo.SchedType = '8' then
      RGSchedType.ItemIndex := 7;

{
    RGSchedType.ItemIndex := DBAppGlobals.DefSchedType - 1;
    if      moveChgInfo.SchedType = '1' then
      RGSchedType.ItemIndex := 0
    else if moveChgInfo.SchedType = '2' then
      RGSchedType.ItemIndex := 1
    else if moveChgInfo.SchedType = '3' then
      RGSchedType.Enabled := false;
}
    RGSchedType.OnClick := TempOnClick;

    m_suppFnc := fnc;
    m_suppObj := obj;
    m_exitFnc := fncExit;

    if Assigned(FBin) then
      FBin.RefreshGrid;

    Show;
    SetFocus
  end
end;

//----------------------------------------------------------------------------//

function GetOccMoveForm: TFMOccMove;
begin
  Result := FMOccMove
end;

//----------------------------------------------------------------------------//

procedure ChangeOccTo(actArea: TMqmActArea; date: TDateTime; isEnd: boolean; id: TSchedID; PlanClicked : boolean);
var
  Save_Cursor : TCursor;
  {$ifdef Big}
  Checked : boolean;
  {$endif}

  MQMPlan : TFMQMPlan;
  NewItem : TMenuItem;
begin
//  Assert(Assigned(FMOccMove));
  if not Assigned(FMOccMove) then Exit;
  FMOccMove.PGCmove.ActivePage := FMOccMove.TbsGen;
  Save_Cursor   := Screen.Cursor;
  Screen.Cursor  := crAppStart; //SQLWait;
  FMOccMove.ChangeTo(actArea, date, isEnd, id, PlanClicked);
  Screen.Cursor := Save_Cursor;

  {$ifdef Big}
  Checked := FMOccMove.CBLogInfo.Checked;
  {$endif}

  if not DBAppGlobals.MCM_App or (DBAppGlobals.MCM_App and (IniAppGlobals.MCMasMQM = 1)) then
  begin
    if DBAppSettings.JobMoveWitoutConfirmation then
      FMOccMove.BtnOkClick(Application);
  end;

  {$ifdef Big}
  if Checked then
    ShowStringsInInfoForm(application, IniAppGlobals.InfoStringList);
 {$endif}

  if DBAppGlobals.ShowColorJobMode = PreDefinedPropList then
  begin
    if (GetIdFromCode(DBAppGlobals.LastPropColorInUseJobMode) <> nil) then
    begin
      NewItem := TMenuItem.Create(Application);
      NewItem.VCLComObject := GetIdFromCode(DBAppGlobals.LastPropColorInUseJobMode);
      MQMPlan := GetPlanView;
      MQMPlan.ClickShowBarColorfromPropList(NewItem);
    end
  end
  else if DBAppGlobals.ShowColorJobMode = DinamicPropList then
  begin
    if (GetIdFromCode(DBAppGlobals.LastPropColorInUseJobMode) <> nil) then
    begin
      NewItem := TMenuItem.Create(Application);
      NewItem.VCLComObject := GetIdFromCode(DBAppGlobals.LastPropColorInUseJobMode);
      MQMPlan := GetPlanView;
      MQMPlan.ClickShowBarColorDynamic(NewItem);
    end
  end

end;

//----------------------------------------------------------------------------//

procedure TFMOccMove.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Save_Cursor : TCursor;
begin
  if (ModalResult <> mrAbort) and (ModalResult <> mrOk) then
  begin
    if IsGroupFormOut then exit;
    m_ObjMover.Abort;
    p_opStack.UndoByButton;
    p_sc.SetAllFlags([CSF_moveSelect],[]);
    if not Assigned(p_sc.GetExtLinkPtr(p_pl.GetCompatModeInPlanId)) then
       p_sc.cleanInstanceCounterProperty(p_pl.GetCompatModeInPlanId);
    if Assigned(m_exitFnc) then
      m_exitFnc(m_suppObj, false);
  end;

  Save_Cursor   := Screen.Cursor;
  Screen.Cursor  := crAppStart; //SQLWait;
  FMQMPlan.ActiveUndo;

  DBAppGlobals.WdwMoveLeft := Self.Left;
  DBAppGlobals.WdwMoveTop := Self.Top;

  Action := caFree;
  FMOccMove := nil;

//  if Assigned(FBin) then
//    FBin.RefreshGrid;

  if Assigned(FBin) then
    FBin.SetBinMenuItems(FBin.GetMouseSchedObj(false));
  GetPlanView.EnableMainMenu;
  DBAppGlobals.MAINPLAN_Ignore_Save_Event := false;
  Screen.Cursor := Save_Cursor
end;

//----------------------------------------------------------------------------//

{procedure TFMOccMove.InitWidth_Lbl;
begin
{  LblTimeSele.Width := 145;
  LblSetup.Width := 105;
  LblSupOvlp.Width := 125;
  LblExe.Width := 105;
  LblQty.Width := 105;
  LblBatchQuantity.Width := 105;
  LBlWorkCenter.Width := 115;
  LblResource.Width := 115;
  LblSubRes.Width := 115;
  LblBatchQty.Width := 100;
  LblStdAvail.Width := 100;
  LblBatchMin.Width := 100;
  LblBatchStd.Width := 100;
  LblBatchMax.Width := 100;
  LblCompMax.Width  := 65;
  LblCompMaxavl.Width := 100;
end;                         }

//----------------------------------------------------------------------------//

procedure TFMOccMove.ChangeTo(actArea: TMqmActArea; date: TDateTime; isEnd: boolean; ToId: TSchedID; PlanClicked : boolean);
var
  duration, setup, overlap: double;
  err:             boolean;
  errlist:         TStringList;
  CompVal:         TCompatVal;
  id, ChildId:              TSchedId;
  EndDate:         TDateTime;
  AlignOpt:        CAlignOpt;
(*  ObjsMoved,
  FinalObjsMoved,
  ObjsDelayed,
  ObjsMaterial,
  ObjsAddRes:      boolean;*)
  PlanInfo:        TSQPlanInfo;
  OptsMover:       SetOptsMover;
  DeltaSetupObjToMove: double;
  ShowErrList: boolean;
  ResultChangeTo: CScMovementResult;
  moveChgInfo: TSQmoveChgInfo;
  Res: TMQMRes;
  BatchQty, MultQty : double;
  ComponentsUsed, G, Step, SubStep, Reprocess : integer;
  JobComponentsUsed, ResComp : integer;
  ComponentsAvail, NumberOfIdUsedComponets: integer;
  VisRes: TMqmVisibleRes;
  TimeSele, Request : string;
  Dependency : boolean;
begin
  if (not DBAppGlobals.MCM_App) or (DBAppGlobals.MCM_App and (IniAppGlobals.MCMasMQM = 1)) then
  begin
    btnOk.Enabled  := true;
  //  BtnOk.Color := $00F3B758;
    end;
  btnForce.Enabled := false;
 // btnForce.Color := clGradientActiveCaption;//$00F3B758;
//  BtnCompactEnt.enabled := true; //problem in aro
  err     := false;
  errlist := TStringList.Create;

  id := p_pl.GetCompatModeInPlanId;

  case FMOCCmove.RGMoveActions.ItemIndex of
    1:  AlignOpt := Al_Erliest;
    2:  AlignOpt := Al_Latest;
    3:  AlignOpt := Al_LowStart;
    4:  AlignOpt := Al_HighEnd;
    5:  AlignOpt := Al_PlanStart;
    6:  AlignOpt := Al_PlanEnd;
  else
    AlignOpt := Al_ToDate;
  end;

//sav  date := m_ObjMover.GetAlignedDate(actArea, AlignOpt, date);
  DBAppGlobals.MoveOption := FMOCCmove.RGMoveActions.ItemIndex;

  if id = CSchedIdNull then exit;

  if (p_sc.ToBeSched(id, errlist) <> CSX_Yes)
  or not p_sc.CanDetach(id, ErrList, false)
  or not Assigned(actArea)
  or not actArea.CheckCompatWithOcc([cho_compVal, cho_timing, cho_wkc, cho_readOnly, cho_useDate, cho_qty, cho_Depend],
                                     id, Date, errlist, CompVal, Dependency) then
  begin
    if not Assigned(actArea) then
      errlist.Add(_('Destination resource is missing.'));

    // this was done for giving option changing number of components for progress '1' and '2'
    if (errlist.Count > 0) and (errlist.Strings[0] = (_('Can''t move a progressed job or group'))) then
    begin
      if (not m_ResComponentChanged) or ((m_ResComponentChanged and
         (((p_sc.IsProgressed(Id) <> prg_Starting) and (p_sc.IsProgressed(Id) <> prg_General))) and
         ((Assigned(actArea) and not actArea.P_ActArea_UserClick)))) or
            (m_ResComponentChanged and actArea.P_ActArea_UserClick) then
      begin
        MemErrors.Lines    := errlist;
        PGCmove.ActivePage := TbsErrors;
        BtnOk.Enabled      := false;
        exit
      end;

      // in case progress is '1' or '2' we delete the current ps , and insering new in the save
      if ((p_sc.IsProgressed(Id) = prg_Starting) or (p_sc.IsProgressed(Id) = prg_General)) then
      begin
        if p_sc.IsGroup(Id) then
        begin
          for G := 0 to p_sc.GetGrpNumSons(Id) - 1 do
          begin
            ChildId := p_sc.GetGrpSon(Id, G);
            Request := p_sc.GetFldDescr(ChildId, CSC_ProdReq, false);
            Step :=    StrToInt(p_sc.GetFldDescr(ChildId, CSC_ProdStep, false));
            SubStep := StrToInt(p_sc.GetFldDescr(ChildId, CSC_ProdSubStep, false));
            Reprocess  := StrToInt(p_sc.GetFldDescr(ChildId, CSC_ReprocNo, false));
            DeleteRequest(Request, Step, SubStep, Reprocess);
          end;
        end
        else
        begin
          Request := p_sc.GetFldDescr(Id, CSC_ProdReq, false);
          Step    := StrToInt(p_sc.GetFldDescr(Id, CSC_ProdStep, false));
          SubStep := StrToInt(p_sc.GetFldDescr(Id, CSC_ProdSubStep, false));
          Reprocess  := StrToInt(p_sc.GetFldDescr(Id, CSC_ReprocNo, false));
          DeleteRequest(Request, Step, SubStep, Reprocess);
        end;
        p_sc.SetSchedObjStatus(Id, CSS_new);
        p_sc.SetSchedObjStatusFromPD(Id, true, true);
      end;

    end
    else
    begin
      MemErrors.Lines    := errlist;
      PGCmove.ActivePage := TbsErrors;
      BtnOk.Enabled      := false;
      exit;
    end;
  end;

  MemErrors.Lines.Clear;

///////////////////// - NEW - START - fp

  Res := TMQMRes(actArea.p_Res);
  VisRes := TMqmVisibleRes(actArea.p_Father);
  ShowErrList := false;

  JobComponentsUsed := 0;
  if Assigned(Res) and Res.p_isMultiRes then
  begin
    p_sc.GetMoveChgInfo(id, moveChgInfo);
    if p_sc.GetRscComponentFromJobOrStep(id) > 0 then
      ResComp := p_sc.GetRscComponentFromJobOrStep(id)
    else
      ResComp := VisRes.p_ResComp;
    stMaxComponents.Caption := IntToStr(VisRes.p_ResComp);

    if DBAppSettings.WarningWhenMaxNumCompChanged and (m_LastRes <> nil) and (m_LastRes <> Res) and not (p_sc.GetRscComponentFromJobOrStep(id) > 0) then
    begin
      if Assigned(m_LastVisRes) and (Trim(LbEInputUser.Text) <> '') and (ResComp <> m_LastVisRes.p_ResComp)  then
      begin
        MemErrors.Clear;
        ShowErrList := true;
        errlist.add(_('Maximum number of components has been changed !'));
        PGCmove.ActivePage := TbsErrors;
        LbEInputUser.Text := '';
      end;
    end;

    if Trim(LbEInputUser.Text) = '0' then
       LbEInputUser.Text := '';

    if Trim(lblEdtComponents.Text) = '' then
       lblEdtComponents.Text := '0';

    GboxComponents.Visible := true;

    date := m_ObjMover.GetAlignedDate(actArea, AlignOpt, date, 0, 0, isEnd, [Ar_AddRes, Ar_AddRes_ManPower,Ar_AddRes_Capacity], setup, overlap);

    while ResComp > 0 do
    begin
      if res.CheckNbrOfComponents(Res, VisRes, Id, ResComp, date) then break;
      ResComp := ResComp - 1;
    end;

    lblEdtComponents.Text := IntToStr(ResComp);

    if (Trim(LbEInputUser.Text) <> '') and (Trim(LbEInputUser.Text) <> '0') then
      JobComponentsUsed := StrToInt(LbEInputUser.Text)
    else
      JobComponentsUsed := ResComp;

  end
  else
    GboxComponents.Visible := false;

 // m_LastValueComp := JobComponentsUsed;

  TimeSele := CBoxTimeSele.Text;
  TimeSele := ''; //avi isko 18/05/2011 //

  {$ifdef Big}

  ResultChangeTo := m_ObjMover.ChangeToDetails(actArea, date, isEnd, ToId, AlignOpt, setup, overlap, duration,
                         TimeSele, EndDate, OptsMover, errlist,
                         False, DeltaSetupObjToMove,PlanClicked,JobComponentsUsed);
   //ShowStringsInInfoForm(application, IniAppGlobals.InfoStringList);

  {$else}

  if Assigned(TMqmRes(TMqmActArea(actArea).p_res)) then
  begin
    m_LastRes := TMqmRes(TMqmActArea(actArea).p_res);
    m_LastVisRes := TMqmVisibleRes(TMqmActArea(actArea).p_Father);
  end;

  ResultChangeTo := m_ObjMover.ChangeTo(actArea, date, isEnd, ToId, AlignOpt, setup, overlap, duration,
                         TimeSele, EndDate, OptsMover, errlist,
                         False, DeltaSetupObjToMove,PlanClicked,JobComponentsUsed);
  {$endif}

  m_ResultChangeTo := ResultChangeTo;
  if Assigned(Res) and Res.p_isMultiRes then
  begin

    // first double click from bin :
    if JobComponentsUsed = 0 then
       JobComponentsUsed := 1;
    if not res.CheckNbrOfComponents(Res, VisRes, Id, JobComponentsUsed, Date)  then
    begin
      modalresult := mrnone;
      MemErrors.Clear;
      MemErrors.Lines.Add(_('Maximum numbers of Components exceeded'));//    := errlist;
      PGCmove.ActivePage := TbsErrors;
      BtnOk.Enabled      := false;
      exit;
    end

  end;

  case ResultChangeTo of
    CSM_No, CSM_Not_Compatible :
      begin
        err := true;
        StExec.Caption    := _('Warning!');
        StSupOvlp.Caption := _('Warning!');
        StSetup.Caption   := _('Warning!');
        MemErrors.Lines    := errlist;
        PGCmove.ActivePage := TbsErrors;
        BtnOk.Enabled      := false;
     //   BtnOk.Color := clGradientActiveCaption;//$00F3B758;
      end;
    NumComponentsExceeded :
      begin
        err := true;
        StExec.Caption    := _('Warning!');
        StSupOvlp.Caption := _('Warning!');
        StSetup.Caption   := _('Warning!');
        ErrList.Add(_('Maximum numbers of Components exceeded'));
        MemErrors.Lines    := errlist;
        PGCmove.ActivePage := TbsErrors;
        BtnOk.Enabled      := false;
      end

    else
      begin
        StSetup.Caption   := FormatDuration(setup, true);
        StSupOvlp.Caption := FormatDuration(overlap, true);
        StExec.Caption    := FormatDuration(duration, true);

      //  p_sc.GetMoveChgInfo(id, moveChgInfo);

      //  ComponentsAvail := 0;
       // if Assigned(Res) and Res.p_isMultiRes then
       // begin
       //   gboxComponents.Visible := true;

         { if p_sc.GetRscComponentFromStep(id) > 0 then
            ResComp := p_sc.GetRscComponentFromStep(id)
          else
            ResComp := VisRes.p_ResComp;

          if (Trim(lblEdtComponents.Text) = '') then //or (m_LastRes <> Res) then
            lblEdtComponents.Text := IntToStr(ResComp);

          m_LastRes := Res;

          if (LbEInputUser.Text <> '') and (LbEInputUser.Text <> '0') then
            NumberOfIdUsedComponets := StrToInt(LbEInputUser.Text)
          else
            NumberOfIdUsedComponets := StrToInt(lblEdtComponents.Text);   }

        //  Res.CheckNbrOfComponents(res,VisRes,m_Id : TSchedID, NumberOfIdUsedComponets : Integer; StartingDate

       //   ComponentsUsed := Res.GetComponentsUsed(m_ObjMover.p_ID, moveChgInfo.startDate,
                                            //      moveChgInfo.endDate);
//          JobComponentsUsed := moveChgInfo.numOfRscComp;

       //   stMaxComponents.Caption := IntToStr(Res.p_ResComp);
       //   ComponentsAvail := Res.p_ResComp - ComponentsUsed;
       //   stAvailComponents.Caption := IntToStr(ComponentsAvail);

        //  if ComponentsAvail < NumberOfIdUsedComponets then

         // if ((ComponentsAvail <= 0) or (((lblEdtComponents.Text) <> '') and (ComponentsAvail - StrToInt(lblEdtComponents.Text) < 0))) then
         { begin
            ErrList.Add(_('Maximum numbers of Components exceeded'));
            ShowErrList := true;
            m_ResultChangeTo := CSM_NO;
          end; }

       // end
       // else
       //   gboxComponents.Visible := false;

        FMQMPlan.GetActiveTab.FocusOnJob(date, EndDate);

        if (not ShowErrList) and (OM_FinalObjsMoved in OptsMover) and DBAppGlobals.WarnOnMoveFinal then
        begin
          ErrList.Add(_('This operation involves final scheduled jobs to be moved. Do you want to proceed?'));
          ShowErrList := true;
          BtnForce.Enabled := true;
        //  btnForce.Color := $00F3B758;
        end;

        if (not ShowErrList) and (ResultChangeTo = CSM_Forced) then
        begin
          ShowErrList := true;
          BtnForce.Enabled := true;
         // btnForce.Color := $00F3B758;
        end;

        MemErrors.Lines    := errlist;
        if ShowErrList then
        begin
//          MemErrors.Lines    := errlist;
          PGCmove.ActivePage := TbsErrors;
          BtnOk.Enabled := false;
         // BtnOk.Color := clGradientActiveCaption;//$00F3B758;
        end;

        if DBAppGlobals.WhenMoveShowErrorsIfExist and (MemErrors.Lines.Count > 0) then
           PGCmove.ActivePage := TbsErrors;

      end;
  end;

///////////////////// - NEW - OLD - fp

///////////////// - OLD - START - fp
{
  if m_ObjMover.ChangeTo(actArea, date, isEnd, AlignOpt, setup, overlap, duration,
                         CBoxTimeSele.Text, EndDate, OptsMover, errlist,
                         False, DeltaSetupObjToMove) <> CSM_No then
  begin
    StSetup.Caption   := FormatDuration(setup);
    StSupOvlp.Caption := FormatDuration(overlap);
    StExec.Caption    := FormatDuration(duration);
    FMQMPlan.GetActiveTab.FocusOnJob(date, EndDate);

//   if FinalObjsMoved and DBAppGlobals.WarnOnMoveFinal then
    if ( OM_FinalObjsMoved in OptsMover )
    and DBAppGlobals.WarnOnMoveFinal then
    begin
      if MessageDlg(_('This operation involves final scheduled jobs to be moved. Do you want to proceed?'),
                    mtConfirmation, [mbYes, mbNo], 0) = mrNo then
      begin
        m_ObjMover.Abort;
        BtnOk.Enabled := false
      end;
    end;
  end else
  begin
    err := true;
    StExec.Caption    := _('Warning!');
    StSupOvlp.Caption := _('Warning!');
    StSetup.Caption   := _('Warning!');
    MemErrors.Lines    := errlist;
    PGCmove.ActivePage := TbsErrors;
    BtnOk.Enabled      := false;
  end;
}
///////////////// - OLD - START - fp

  //Fill the times description combo box
  p_pl.GetTmgDescList(TStringList(CBoxTimeSele.Items));
  if CBoxTimeSele.Items.Count = 0 then
    SetComponent(CBoxTimeSele, comp_Edit, false)
  else
  begin
    p_sc.GetPlanInfo(id, PlanInfo);
    CBoxTimeSele.ItemIndex := CBoxTimeSele.Items.IndexOf(planInfo.TmgDescr);
    SetComponent(CBoxTimeSele, comp_Edit, true);
  end;

  if Assigned(Res) then
  begin
    if (res.p_BchUM <> '') then
    begin
      if p_sc.QtyInUM(Id, res.p_BchUM, BatchQty, MultQty) then
      begin
        if BatchQty <> 0 then BatchQty := trunc(BatchQty*100)/100;
        STBatchQuantity.Caption := FloatToStr(BatchQty) + ' ' + res.p_BchUM  // avi
      end
      else
        STBatchQuantity.Caption := '---';
    end
  end;
  if Assigned(Res) then
    UpdateQtyFieds(p_sc.getExtLinkPtr(id));

  if (not err) and Assigned(m_suppFnc) then
    m_suppFnc(m_suppObj);

  if DBAppSettings.WarningWhenMaxNumCompChanged and (m_LastRes <> nil) and not (p_sc.GetRscComponentFromJobOrStep(id) > 0) then
  begin
    if Assigned(m_LastVisRes) and (Trim(LbEInputUser.Text) <> '') and (ResComp <> m_LastVisRes.p_ResComp)  then
    begin
      errlist.add(_('Maximum number of components has been changed !'));
      MemErrors.Lines    := errlist;
      PGCmove.ActivePage := TbsErrors;
      LbEInputUser.Text := '';
    end;
  end;

  errlist.Free;
  m_LastVisRes := VisRes;
  m_LastRes   := Res;
//  showmessage(IntToStr(actArea.GetCalendar.m_TestCount))
end;

//----------------------------------------------------------------------------//

procedure TFMOccMove.BtnOkClick(Sender: TObject);
var
  Modified:    boolean;
  moveChgInfo: TSQmoveChgInfo;
  id:          TSchedId;
  PlanInfo: TSQPlanInfo;
  SavedSchedType : string;
  res : TMqmRes;
  VisRes: TMqmVisibleRes;
  NumberOfIdUsedComponets : integer;
begin
  btnOk.Enabled := False;
  Modified := false;
  ModalResult := mrOk;

  id := p_pl.GetCompatModeInPlanId;
  //Assert(id <> CSchedIdNull);
  if id = CSchedIdNull then exit;

  //This must stay here to set the default schedule type
  p_sc.GetMoveChgInfo(id, moveChgInfo);
  Res := TMQMRes(p_pl.FindResByCode(moveChgInfo.RscCode));

  if (moveChgInfo.SchedType = '0') then
  begin
    case RGSchedType.ItemIndex of
      -1: begin
            moveChgInfo.SchedType := '1';
            Modified := true
          end;

       0: begin
            moveChgInfo.SchedType := '2';
            Modified := true
          end;

       1: begin
            moveChgInfo.SchedType := '1';
            Modified := true
          end;

       2: begin
            moveChgInfo.SchedType := '3';
            Modified := true
          end;

       3: begin
            moveChgInfo.SchedType := '4';
            Modified := true
          end;

       4: begin
            moveChgInfo.SchedType := '5';
            Modified := true
          end;

       5: begin
            moveChgInfo.SchedType := '6';
            Modified := true
          end;

       6: begin
            moveChgInfo.SchedType := '7';
            Modified := true
          end
    end;

    if modified then
      p_opStack.ChgOccMoveData(id, moveChgInfo);
  end;

  if Assigned(p_sc.getExtLinkPtr(ID)) and
     TMqmRes(TMqmActArea(p_sc.getExtLinkPtr(m_ObjMover.p_ID)).p_Res).p_isMultiRes and
     (Trim(lblEdtComponents.Text) <> '') and (StrToInt(lblEdtComponents.Text) <> 0) then
  begin
    if (LbEInputUser.Text <> '') and (LbEInputUser.Text <> '0') then
      NumberOfIdUsedComponets := StrToInt(LbEInputUser.Text)
    else
      NumberOfIdUsedComponets := StrToInt(lblEdtComponents.Text);

    SavedSchedType := moveChgInfo.SchedType;
    p_sc.GetPlanInfo(m_ObjMover.p_ID, PlanInfo);

    VisRes := TMqmVisibleRes(TMqmActArea(p_sc.GetExtLinkPtr(Id)).p_Father);

    if Assigned(p_sc.getExtLinkPtr(m_ObjMover.p_ID)) and
     //  TMQMVisibleRes(p_sc.getExtLinkPtr(m_ObjMover.p_ID)).p_isSubRes and
      TMqmRes(TMqmActArea(p_sc.getExtLinkPtr(m_ObjMover.p_ID)).p_Res).p_isMultiRes and
       (NumberOfIdUsedComponets <> m_LastValueComp) then
    begin
      ChangeTo(p_sc.getExtLinkPtr(id), PlanInfo.startDate, false, CSchedIDnull, false);
      if m_ResultChangeTo = CSM_No then
      begin
        modalresult := mrnone;
        exit;
      end;
      p_sc.GetMoveChgInfo(id, moveChgInfo);
      moveChgInfo.SchedType := SavedSchedType;
    end;

    if not res.CheckNbrOfComponents(Res, VisRes, Id, NumberOfIdUsedComponets, PlanInfo.startDate)  then
    //if not res.CheckNbrOfComponents(Id, StrToInt(lblEdtComponents.Text), PlanInfo.startDate)  then
    begin
      modalresult := mrnone;
      MemErrors.Clear;
      MemErrors.Lines.Add(_('Maximum numbers of Components exceeded'));//    := errlist;
      PGCmove.ActivePage := TbsErrors;
      BtnOk.Enabled      := false;

      exit;
    end
    else
      moveChgInfo.numOfRscComp := NumberOfIdUsedComponets;//StrToInt(LbEInputUser.Text);

    Modified := true
  end;

  if modified then
    p_opStack.ChgOccMoveData(id, moveChgInfo);

  p_sc.SetAllFlags([CSF_moveSelect],[]);

  if IsDynamicBinPlanActiv and m_FromBin then
    p_sc.SetFlags(id,[],[CSF_FilterJobsInDynamicGantt]);

  if Assigned(m_exitFnc) then m_exitFnc(m_suppObj, true);
  btnOk.Enabled := True;

  if Assigned(FBin) then
  begin
    if not FBin.GetActiveView.m_BinPanel.GetFiltParms.P_MaterialSchedFilter then
    begin
      FBin.GetActiveView.m_BinPanel.p_Grid.Row := 1;
      if (FBin.GetActiveView.m_BinPanel.p_Grid.RowCount > RowIndex) then
      begin
        FBin.GetActiveView.m_BinPanel.p_Grid.Row := RowIndex;
        FBin.GetActiveView.m_BinPanel.p_Grid.Refresh;
      end;
    end;
  end;
  Close
end;

//----------------------------------------------------------------------------//

procedure TFMOccMove.BtnAbortClick(Sender: TObject);
begin
  btnAbort.Enabled := False;
  ModalResult := mrAbort;
  if IsGroupFormOut then exit;
  m_ObjMover.Abort;
  p_opStack.UndoByButton;
//  if Assigned(m_suppFnc) then m_suppFnc(m_suppObj);
  p_sc.SetAllFlags([CSF_moveSelect],[]);
  Close;
//  FMQMPlan.RefreshActiveTab;
  if not Assigned(p_sc.GetExtLinkPtr(p_pl.GetCompatModeInPlanId)) then
     p_sc.cleanInstanceCounterProperty(p_pl.GetCompatModeInPlanId);
  if Assigned(m_exitFnc) then
    m_exitFnc(m_suppObj, false);

  btnAbort.Enabled := True;

  if assigned(FBin) then
  begin
    // avi for Marchi 04 08 2021 , when clicking abort move should say in original position
    //  same as was in version 6
   { FBin.GetActiveView.m_BinPanel.p_Grid.Row := 1;
    if FBin.GetActiveView.m_BinPanel.p_Grid.RowCount > RowIndex then
    begin
      FBin.GetActiveView.m_BinPanel.p_Grid.Row := RowIndex;
      FBin.GetActiveView.m_BinPanel.p_Grid.Refresh;
    end;  }
  end;
end;

//----------------------------------------------------------------------------//

procedure TFMOccMove.FormShow(Sender: TObject);
var
  isGroup, FirstJobHasAlternative, FoundDifUM :  boolean;
  planInfo: TSQplanInfo;
  id, SonId:       TSchedId;
  errlist:  TStringList;
  SplitInfo : TSQSplitInfo;
  I : integer;
  valueUM, um, jobqty, stepqty : variant;
  dataType : CBinColValType;
  AlternativeUM, S, TempStrQty : string;
  TotalAltQty : Double;
  TempExt : Extended;
begin
//  FBin.SetBinMenuItems(FBin.GetMouseSchedObj);
  LbEInputUser.EditLabel.Caption := '';
  lblEdtComponents.EditLabel.Caption := '';

  if (DBAppGlobals.WdwMoveLeft <> 0) and (DBAppGlobals.WdwMoveTop <> 0) then
  begin
    Left := DBAppGlobals.WdwMoveLeft;
    Top :=  DBAppGlobals.WdwMoveTop;
  end
  else
  begin
    Left := 290;
    Top := 247
  end;

  PGCmove.ActivePage := TbsGen;
  id := p_pl.GetCompatModeInPlanId;
  //Assert(id <> CSchedIdNull);

  if id = CSchedIdNull then Exit;
  errlist := TStringList.Create;

{$ifdef Customer}
  lblID.Visible := false;
//  gboxComponents.Visible := false;
{$endif}

  FMOCCmove.RGMoveActions.ItemIndex := DBAppGlobals.MoveOption;
  StOcc.Caption := p_sc.GetObjInfo(id, isGroup);

  if isGroup then
  begin
    Caption := _('Group');
    LblOcc.Caption := _('Group');
  end else
  begin
    FMOccMove.Caption := _('Request');
    LblOcc.Caption := _('Request');
  end;

  if FMOccMove.Caption = '' then
     FMOccMove.Caption := _('Occupation move'); // avi 0705 2020

  p_sc.GetPlanInfo(id, planInfo);
  if not planInfo.isOnPlan then
  begin
    StSetup.Caption   := '---';
    StSupOvlp.Caption := '---';
    StExec.Caption    := '---';
  end else
  begin
    StSetup.Caption   := FormatDuration(planInfo.supMinReal, true);
    StSupOvlp.Caption := FormatDuration(planInfo.supMinOvlp, true);
    StExec.Caption    := FormatDuration(planInfo.exeMin, true);
  end;

  STQty.Caption     := FloatToStr(planInfo.quant) + ' ' +
                       p_sc.GetFldDescr(id, CSC_ProdUM, false);

  SetComponent(StSetup,   comp_Descr, false);
  SetComponent(StSupOvlp, comp_Descr, false);
  SetComponent(StExec,    comp_Descr, false);
  SetComponent(STQty,     comp_Descr, false);
  SetComponent(STAlternativeQty, comp_Descr, false);

  LblAlternativeQty.Visible := true;
  STAlternativeQty.Visible  := true;
  FoundDifUM := false;
  TotalAltQty := 0;
  if isGroup then
  begin
    for i := 0 to p_sc.GetGrpNumSons(Id)-1 do
    begin
      SonId := p_sc.GetGrpSon(Id, i);
      p_sc.GetFldValue(SonId, CSC_ProdUM, valueUM, dataType);
      p_sc.GetSplitInfo(SonId, SplitInfo);

      if (I = 0) and (Trim(SplitInfo.AlternativeUM) <> '') then
      begin
        FirstJobHasAlternative := true;
        AlternativeUM := SplitInfo.AlternativeUM;
      end;

      if FirstJobHasAlternative then
      begin
        p_sc.GetFldValue(SonId, CSC_QtyToSched, jobqty, dataType);  //Job qty
        p_sc.GetFldValue(SonId, CSC_IniQty , stepqty, dataType);    //Step qty
        TotalAltQty := TotalAltQty + jobqty / StepQty * SplitInfo.AlternativeQty;
      end;

      if um = '' then
        um := ValueUM;

      if um <> ValueUM then
        FoundDifUM := true
    end;

    if FoundDifUM then
      STQty.Caption := '--------';

    if FirstJobHasAlternative then
    begin
      TempExt := Frac(TotalAltQty);
      S := FloatToStr(TempExt);

      if Length(S) > 3 then
      begin
        S := Copy(s, 2, 3);
        TempStrQty := FloatToStr(trunc(TotalAltQty));
        TempStrQty := TempStrQty + S;
        TotalAltQty := StrToFloat(TempStrQty);
      end;
      STAlternativeQty.Caption := FloatToStr(TotalAltQty) + ' ' + AlternativeUM;
    end
    else
    begin
      STAlternativeQty.Visible := false;
      LblAlternativeQty.Visible := false;
    end;
  end
  else
  begin
    p_sc.GetSplitInfo(Id, SplitInfo);
    if (Trim(SplitInfo.AlternativeUM) = '') then
    begin
      LblAlternativeQty.Visible := false;
      STAlternativeQty.Visible  := false;
    end
    else
    begin
      p_sc.GetFldValue(Id, CSC_QtyToSched, jobqty, dataType);  //Job qty
      p_sc.GetFldValue(Id, CSC_IniQty , stepqty, dataType);    //Step qty
      TotalAltQty := jobqty / StepQty * SplitInfo.AlternativeQty;
      TempExt := Frac(TotalAltQty);
      S := FloatToStr(TempExt);
      if Length(S) > 3 then
      begin
        S := Copy(s, 2, 3);
        TempStrQty := FloatToStr(trunc(TotalAltQty));
        TempStrQty := TempStrQty + S;
        TotalAltQty := StrToFloat(TempStrQty);
      end;
      STAlternativeQty.Caption := FloatToStr(TotalAltQty) + ' ' + SplitInfo.AlternativeUM;
    end;
  end;

  UpdateQtyFieds(p_sc.getExtLinkPtr(id));

  if not planInfo.isOnPlan
  or (planInfo.TmgDescr = '') then
  begin
    SetComponent(CBoxTimeSele, comp_Edit, false);
  end else
  begin
    p_pl.GetTmgDescList(TStringList(CBoxTimeSele.Items));
    CBoxTimeSele.ItemIndex := CBoxTimeSele.Items.IndexOf(planInfo.TmgDescr);
    SetComponent(CBoxTimeSele, comp_Edit, true);
  end;

  if p_sc.ToBeSched(id, errlist) <> CSX_Yes then
  begin
    MemErrors.Lines    := errlist;
    PGCmove.ActivePage := TbsErrors
  end;

  if assigned(fbin) and not fbin.GetActiveView.m_BinPanel.GetFiltParms.P_MaterialSchedFilter then
     RowIndex := fbin.GetActiveView.m_BinPanel.p_Grid.Row;
  LbEInputUser.OnChange := LbEInputUserChange;
  errlist.Free
end;

//----------------------------------------------------------------------------//

procedure TFMOccMove.UpdateQtyFieds(actArea: TMqmActArea);
var
  VisRes: TMqmVisibleRes;
  res:    TMqmRes;
  Wkc:    TMqmWrkCtr;
  id:     TSchedId;
  qty:      double;
  MultQty:  double;
  tmp:      double;
  BatchQty: double;
  AdditionalMultiplierProp : double;
  ObjPlanInfo: TSQplanInfo;

  procedure SetBatchField(stTxt: TStaticText; val: double);
  begin
    if val < 0 then
    begin
      stTxt.Caption := FloatToStr(-val) + ' ' + res.p_BchUM;
      stTxt.Brush.Color := clRed
    end
    else
    begin
      stTxt.Caption     := FloatToStr(val) + ' ' + res.p_BchUM;
      stTxt.Brush.Color := $00E1E1E1//clActiveBorder
    end
  end;

  procedure ShowBatchQuantity();
  var
  BatchQty: double;
  MultQty : double;
  begin
    Res := nil;
    id := p_pl.GetCompatModeInPlanId;
//    Assert(id <> CSchedIdNull);
    if id = CSchedIdNull then Exit;

    MultQty := 0;
    Wkc := TMqmWrkCtr(p_sc.GetWrkCtrPtr(Id));

    if not Assigned(Wkc) then exit;
    BatchQty := StrToFloat(p_sc.GetFldDescr(Id, CSC_QtyToSched, false));
    if Assigned(actArea) then
      Res := TMQMRes(actArea.p_Res);
    if not assigned(Res) or (res.p_BchUM = '') then exit;
    p_sc.QtyInUM(Id, res.p_BchUM, BatchQty, MultQty);
    LblBatchQuantity.Visible := true;
    STBatchQuantity.Visible := true;
    AdditionalMultiplierProp := res.P_GetAdditionalOptimumMaxMultiplierProp[Id];
    if BatchQty <> 0 then BatchQty := trunc((BatchQty/AdditionalMultiplierProp)*100)/100;
    STBatchQuantity.Caption := FloatToStr(BatchQty)+ ' ' +
                          res.p_BchUM;
  end;
begin

  id := p_pl.GetCompatModeInPlanId;
//  Assert(id <> CSchedIdNull);
  if id = CSchedIdNull then Exit;

  p_sc.GetPlanInfo(id, ObjPlanInfo);
  ShowBatchQuantity;
  if not Assigned(actArea)
  or not Assigned(actArea.p_Res) then
  begin
    if not ObjPlanInfo.BatchSizePerStep then
    begin
      PnlResData.Visible := false;
      PnlQty.Visible := false;
      exit
    end
    else
    begin
      StBchMinLev.Caption := FloatToStr(ObjPlanInfo.MinBatchSize) + ' ' + ObjplanInfo.ProdUM;
      StBchStdLev.Caption := FloatToStr(ObjPlanInfo.OptimumBatchSize) + ' ' + ObjplanInfo.ProdUM;
      StBchMaxLev.Caption := FloatToStr(ObjPlanInfo.MaxBatchSize) + ' ' + ObjplanInfo.ProdUM;
      STBatchResQuantity.Caption := FloatToStr(ObjplanInfo.quant) + ' ' + ObjplanInfo.ProdUM;
      LblBatchQty.Visible := false;
      StBatchQty.Visible  := false;
      StBchStdToLev.Visible := false;
      StBchMaxToLev.Visible := false;
      exit
    end

  end else
    PnlResData.Visible := true;

  VisRes := TMqmVisibleRes(actArea.p_Father);
  res := TMqmRes(actArea.p_Res);
  Wkc := TMqmWrkCtr(actArea.p_WrkCtr);
  MultQty := 0;

  p_pl.SetTmgTargetRes(res);

  StTgtWkc.Caption := Wkc.p_WrkCtrCode;
  StTgtRes.Caption := Res.p_ResCode;

  if res.p_isMultiRes then
  begin
    LblSubRes.Visible   := true;
    StTgtSubRes.Visible := true;
    StTgtSubRes.Caption := IntToStr(VisRes.p_SubCode)
  end else
  begin
    LblSubRes.Visible   := false;
    StTgtSubRes.Visible := false;
  end;

  if (res.p_BchUM <> '') then
  begin
    PnlQty.Visible := true;
    STBatchQuantity.Caption := '---';
    STBatchResQuantity.Caption := '---';
    if p_sc.QtyInUM(Id, res.p_BchUM, BatchQty, MultQty) then
    begin
      if BatchQty <> 0 then BatchQty := trunc((BatchQty/AdditionalMultiplierProp)*100)/100;
      STBatchQuantity.Caption := FloatToStr(BatchQty) + ' ' + res.p_BchUM;  // avi
      STBatchResQuantity.Caption := FloatToStr(BatchQty) + ' ' + res.p_BchUM;  // avi
    end;
  end
  else
  begin
    PnlQty.Visible := false;
    exit
  end;

  if not ObjPlanInfo.BatchSizePerStep then
  begin
    StBchMinLev.Caption := FloatToStr(res.p_Min_bch_size) + ' ' + res.p_BchUM;
    StBchStdLev.Caption := FloatToStr(res.p_Sndt_bch_Size*AdditionalMultiplierProp) + ' ' + res.p_BchUM;
    StBchMaxLev.Caption := FloatToStr(res.p_Max_bch_size*AdditionalMultiplierProp) + ' ' + res.p_BchUM;
  end
  else
  begin
    StBchMinLev.Caption := FloatToStr(ObjPlanInfo.MinBatchSize) + ' ' + ObjplanInfo.ProdUM;
    StBchStdLev.Caption := FloatToStr(ObjPlanInfo.OptimumBatchSize) + ' ' + ObjplanInfo.ProdUM;
    StBchMaxLev.Caption := FloatToStr(ObjPlanInfo.MaxBatchSize) + ' ' + ObjplanInfo.ProdUM;
    STBatchResQuantity.Caption := FloatToStr(ObjplanInfo.quant) + ' ' + ObjplanInfo.ProdUM;
    LblBatchQty.Visible := false;
    StBatchQty.Visible  := false;
    StBchStdToLev.Visible := false;
    StBchMaxToLev.Visible := false;

  end;

  if not p_sc.QtyInUM(id, res.p_BchUM, qty, MultQty) then
  begin
    StBatchQty.Caption    := '---';
    StBchStdToLev.Caption := '---';
    StBchMaxToLev.Caption := '---'
  end
  else
  begin
//    StBatchQty.Caption := FloatToStr(qty) + ' ' +
//                          res.p_BchUM;

    if (res.p_Min_bch_size = 0) or (MultQty = 0) then
      StBatchQty.Caption := '---'
    else
    begin
      tmp := res.p_Min_bch_size/MultQty;
      tmp := trunc(tmp*100)/100;
      SetBatchField(StBatchQty, tmp);
    end;

 //   tmp := res.p_Sndt_bch_size - qty;

    if (res.p_Sndt_bch_size = 0) or (MultQty = 0) then
      StBchStdToLev.Caption := '---'
    else
    begin
      tmp := res.p_Sndt_bch_Size*AdditionalMultiplierProp/MultQty;
      tmp := trunc(tmp*100)/100;
      StBchStdToLev.Caption     := FloatToStr(tmp) + ' ' + p_sc.GetFldDescr(Id, CSC_ProdUM, false);
      StBchStdToLev.Brush.Color := $00E1E1E1//clActiveBorder
    end;

//    tmp := res.p_Max_bch_size - qty;
    if (res.p_Max_bch_size = 0) or (MultQty = 0) then
      StBchMaxToLev.Caption := '---'
    else
    begin
      tmp := res.p_Max_bch_size*AdditionalMultiplierProp/MultQty;
      tmp := trunc(tmp*100)/100;
//      StBchMaxToLev.Caption := FloatToStr(; // avi
      SetBatchField(StBchMaxToLev, tmp);
    end;

  end;

end;

//----------------------------------------------------------------------------//

procedure TFMOccMove.Reset;
var
  Save_Cursor : TCursor;
begin
  Save_Cursor   := Screen.Cursor;
  Screen.Cursor  := crAppStart; //SQLWait;
  m_ObjMover.Abort;
  Screen.Cursor := Save_Cursor;
end;

//----------------------------------------------------------------------------//

procedure TFMOccMove.BtnCompactEntClick(Sender: TObject);
begin
  if Trim(lblEdtComponents.Text) <> '' then
      m_LastValueComp := StrToInt(lblEdtComponents.Text);
  m_ObjMover.CompactEntities([Ar_Material, Ar_MatWithDet, Ar_AddRes, Ar_AddRes_ManPower,Ar_AddRes_Capacity], SpnEdtDays.Value);
  if  Assigned(m_suppFnc) then
    m_suppFnc(m_suppObj);
  if not DBAppGlobals.MCM_App or (DBAppGlobals.MCM_App and (IniAppGlobals.MCMasMQM = 1)) then
  begin
    BtnOk.Enabled := true;
  //  BtnOk.Color := $00F3B758;
  end
end;

//----------------------------------------------------------------------------//

procedure TFMOccMove.FormCreate(Sender: TObject);
begin
  TranslateComponent (self);
  DBAppGlobals.MAINPLAN_Ignore_Save_Event := true;
  GetPlanView.DisableMainMenu;
  m_LastRes := nil;
 {$ifdef Big}
  CBLogInfo.Visible := true;
 {$else}
  CBLogInfo.Visible := false;
 {$endif}

  ReShape(Self);
  m_ResComponentChanged := false;
  BtnOk.Enabled := false;
//  InitWidth_Lbl
end;

procedure TFMOccMove.FormKeyPress(Sender: TObject; var Key: Char);
begin

end;

//----------------------------------------------------------------------------//

procedure TFMOccMove.CBoxTimeSeleChange(Sender: TObject);
var
  id:       TSchedId;
  PlanInfo: TSQPlanInfo;
begin
  p_pl.SetTmgByDescr(CBoxTimeSele.Text);
  id := p_pl.GetCompatModeInPlanId;
  p_sc.GetPlanInfo(id, PlanInfo);
  if Assigned(p_sc.getExtLinkPtr(id)) then
    ChangeTo(p_sc.getExtLinkPtr(id), PlanInfo.startDate, false, CSchedIDnull, false)
end;

//----------------------------------------------------------------------------//

procedure TFMOccMove.RGSchedTypeClick(Sender: TObject);
var
  id:       TSchedId;
begin
  id := p_pl.GetCompatModeInPlanId;
  if (p_sc.IsProgressed(id) = prg_none) then
    BtnApply.Enabled := true;

    if RGSchedType.ItemIndex = 0  then
    begin
      TRadioButton(RGSchedType.Controls[0]).Font.Style := [fsBold];
      TRadioButton(RGSchedType.Controls[1]).Font.Style := [];
    end;

    if RGSchedType.ItemIndex = 1  then
    begin
      TRadioButton(RGSchedType.Controls[1]).Font.Style := [fsBold];
      TRadioButton(RGSchedType.Controls[0]).Font.Style := [];
    end;

end;

//----------------------------------------------------------------------------//

procedure TFMOccMove.BtnForceClick(Sender: TObject);
begin
  BtnOkClick(sender);
end;

//----------------------------------------------------------------------------//

procedure TFMOccMove.btnViewStepDetailsClick(Sender: TObject);
var
  StepDetails : TFStepDetails;
  id:       TSchedId;
  PlanInfo: TSQPlanInfo;
begin
  btnView.Enabled := False;
  id := p_pl.GetCompatModeInPlanId;
  if (id = CSchedIdNull) then Exit;

  p_sc.GetPlanInfo(id,PlanInfo);
  if PlanInfo.isGroup then
  begin
    if IsGroupFormOut then exit;
      HandleGroup(Self,id, true,-1, false)
  end
  else
  begin
    TFStepDetails.CreateStepDetails(Self, id).ShowModal;
   // ReShape(self);
    //StepDetails := TFStepDetails.CreateStepDetails(Self, id);

    //StepDetails.ShowModal;
    //  exit;
    //StepDetails.Free
  end;
  btnView.Enabled := True;
end;

//----------------------------------------------------------------------------//
//Apply
procedure TFMOccMove.EdtCommentsChange(Sender: TObject);
var
  id: TSchedID;
begin
  id := p_pl.GetCompatModeInPlanId;
  if (p_sc.IsProgressed(id) = prg_none) then
    BtnApply.Enabled := true;
end;

//----------------------------------------------------------------------------//
//Apply
procedure TFMOccMove.BtnApplyClick(Sender: TObject);
var
  Modified: boolean;
  id: TSchedID;
  moveChgInfo: TSQmoveChgInfo;
begin
  Modified := false;

  id := p_pl.GetCompatModeInPlanId;
//  Assert(id <> CSchedIdNull);
  if id = CSchedIdNull then Exit;

  p_sc.GetMoveChgInfo(id, moveChgInfo);

  case RGSchedType.ItemIndex of
    -1: begin
          if (moveChgInfo.SchedType <> '1') then
          begin
            moveChgInfo.SchedType := '1';
            Modified := true
          end;
        end;

     0: begin
          if (moveChgInfo.SchedType <> '2') then
          begin
            moveChgInfo.SchedType := '2';
            Modified := true
          end;
        end;

     1: begin
          if (moveChgInfo.SchedType <> '1') then
          begin
            moveChgInfo.SchedType := '1';
            Modified := true
          end
        end;

     2: begin
          if (moveChgInfo.SchedType <> '3') then
          begin
            moveChgInfo.SchedType := '3';
            Modified := true
          end
        end;

     3: begin
          if (moveChgInfo.SchedType <> '4') then
          begin
            moveChgInfo.SchedType := '4';
            Modified := true
          end
        end;

     4: begin
          if (moveChgInfo.SchedType <> '5') then
          begin
            moveChgInfo.SchedType := '5';
            Modified := true
          end
        end;

     5: begin
          if (moveChgInfo.SchedType <> '6') then
          begin
            moveChgInfo.SchedType := '6';
            Modified := true
          end
        end;

     6: begin
          if (moveChgInfo.SchedType <> '7') then
          begin
            moveChgInfo.SchedType := '7';
            Modified := true
          end
        end
  end;

  if moveChgInfo.comment <> EdtComments.Text then
  begin
    moveChgInfo.comment := EdtComments.Text;
    Modified := true
  end;

  if modified then
  begin
     p_sc.SetMoveChgInfo(id, moveChgInfo);
    p_opStack.ChgOccMoveData(id, moveChgInfo);
  end;

  BtnApply.Enabled := false;
  if not DBAppGlobals.MCM_App or (DBAppGlobals.MCM_App and (IniAppGlobals.MCMasMQM = 1)) then
  begin
    BtnOk.Enabled := true;
  //  BtnOk.Color := $00F3B758;
  end;
end;

procedure TFMOccMove.lblEdtComponentsKeyPress(Sender: TObject; var Key: Char);
begin
  if (Ord(key) = VK_Return) and BtnOk.Enabled then
    btnOk.Click;

  if not ((CharInSet(Key, ['0'..'9'])) or (key = chr(vk_Back)) or (Key = chr(24))) then
    abort;
  m_ResComponentChanged := true;
end;

//----------------------------------------------------------------------------//

procedure TFMOccMove.Panel1Click(Sender: TObject);
begin
  lblID.Visible := true;
end;

procedure TFMOccMove.PGCmoveDrawTab(Control: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
begin
   //Mihailo 1.8.2019.
  with Control.Canvas do begin
    Brush.Color := clWhite;
    FillRect(Rect);
    TextOut(Rect.Left + Font.Size -5, Rect.Top + 2, (Control as TPageControl).Pages[TabIndex].Caption) ;
  end;

end;

//----------------------------------------------------------------------------//

procedure TFMOccMove.LbEInputUserChange(Sender: TObject);
begin
  if (Trim(LbEInputUser.Text) <> '') and
     (m_OldValueUser <> StrToInt(LbEInputUser.Text)) then
  begin
   // bbtnApplyComp.Enabled := true;
    if not DBAppGlobals.MCM_App or (DBAppGlobals.MCM_App and (IniAppGlobals.MCMasMQM = 1))  then
    begin
      BtnOk.Enabled := true;
    //  BtnOk.Color := $00F3B758;
    end;
  end;
end;

//----------------------------------------------------------------------------//

{procedure TFMOccMove.bbtnApplyCompClick(Sender: TObject);
var
  id:       TSchedId;
  PlanInfo: TSQPlanInfo;
  moveChgInfo: TSQmoveChgInfo;
  Res: TMQMRes;
  Components : integer;
  Available : integer;
begin
  Components := StrToInt(lblEdtComponents.Text);

  p_sc.GetMoveChgInfo(m_ObjMover.p_ID, moveChgInfo);
//  Res := TMQMRes(p_pl.FindResByCode(moveChgInfo.RscCode));
  Res := m_LastRes;

 // Available := Res.p_ResComp - Res.GetComponentsUsed(m_ObjMover.p_ID, moveChgInfo.startDate,
                 moveChgInfo.endDate);
 // stAvailComponents.Caption := IntToStr(Available);

  if Components > Available then
  begin
    MemErrors.Clear;
    MemErrors.Lines.Add(_('Maximum numbers of Components exceeded'));
    PGCmove.ActivePage := TbsErrors;
    BtnOk.Enabled      := false;
  //  BtnOk.Color := clGradientActiveCaption;//$00F3B758;
    exit;
  end;

  id := p_pl.GetCompatModeInPlanId;
  p_sc.GetPlanInfo(id, PlanInfo);
  if Assigned(p_sc.getExtLinkPtr(id)) then
    ChangeTo(p_sc.getExtLinkPtr(id), PlanInfo.startDate, false, CSchedIDnull, false);
end;
        }
//----------------------------------------------------------------------------//

initialization

  FMOccMove := nil;

//----------------------------------------------------------------------------//

end.
