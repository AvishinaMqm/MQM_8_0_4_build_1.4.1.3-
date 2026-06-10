unit FMGroupDetail;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UMSchedList,
  UMSchedContFunc,
  StdCtrls,
  UMSchedView, ExtCtrls,
  UMRes, FMGrpSplit,
  UMUsrPropComp,
  UMOpStack, Buttons, ComCtrls, Spin,UReShape, ExSpinEdit, Vcl.Menus;

type
  TTGroupDetail = class(TForm)
    PanInfo: TPanel;
    PanBtn: TPanel;
    LblGrpNo: TLabel;
    StGrpNo: TStaticText;
    LblGrpQty: TLabel;
    StGrpQty: TStaticText;
    PgcGrp: TPageControl;
    TBSched: TTabSheet;
    PanOp: TPanel;
    TBProp: TTabSheet;
    TBsValues: TTabSheet;
    GPBtgtRes: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    LblSubRes: TLabel;
    StTgtWkc: TStaticText;
    StTgtRes: TStaticText;
    StTgtSubRes: TStaticText;
    PanBch: TPanel;
    GroupBox2: TGroupBox;
    StBchStdLev: TStaticText;
    StBchStdToLev: TStaticText;
    LblStdAvail: TLabel;
    GroupBox3: TGroupBox;
    StBchMinLev: TStaticText;
    GroupBox4: TGroupBox;
    LblMaxAvail: TLabel;
    StBchMaxLev: TStaticText;
    StBchMaxToLev: TStaticText;
    PnlSplit: TPanel;
    LblSplitNo: TLabel;
    LblQtyPerJob: TLabel;
    LblCurrGroupQty: TLabel;
    LblNrOfNewGroup: TLabel;
    LblQtyEachGroup: TLabel;
    StCurrGrpQty: TStaticText;
    EdtQtyPerJob: TEdit;
    StNrOfNewGrp: TStaticText;
    StQtyEachGrp: TStaticText;
    RgSplitType: TRadioGroup;
    RGQtyType: TRadioGroup;
    EdtQtyToSplit: TEdit;
    SEdtNumOfGroups: TexSpinEdit;
    LblSplitErr: TLabel;
    EdtSplitError: TEdit;
    BtnOk: TcxButton;
    BtnAbo: TcxButton;
    BtnMove: TcxButton;
    BtnShowRequiremants: TcxButton;
    BtnShowComp: TcxButton;
    BtnCalcSplit: TcxButton;
    BtnSplit: TcxButton;
    BtnRemove: TcxButton;
    BtnSelected: TcxButton;
    BtnChgQtyJobs: TcxButton;
    BtnJobMsg: TcxButton;
    BtnSplitGroup: TcxButton;
    StBchMinToLev: TStaticText;
    BtnSplitGroupByAlternativeUM: TcxButton;
    STQuantityAlt: TStaticText;
    LblQuantityAlt: TLabel;
    STStCurrUmHandled: TStaticText;
    ButtonAppendix: TcxButton;
    PopupMenuAppendix: TPopupMenu;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure BtnAboClick(Sender: TObject);
    procedure BtnRemoveClick(Sender: TObject);
    procedure RemoveChaineGroupType(Id : TSchedId; LastJob : boolean);
    procedure BtnShowCompClick(Sender: TObject);
    procedure BtnSelectedClick(Sender: TObject);
    procedure BtnMoveClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnChgQtyJobsClick(Sender: TObject);
    procedure BtnShowRequiremantsClick(Sender: TObject);
    procedure BtnJobMsgClick(Sender: TObject);
    procedure BtnSplitGroupClick(Sender: TObject);
    procedure BtnSplitClick(Sender: TObject);
    procedure BtnCalcSplitClick(Sender: TObject);
    procedure RgSplitTypeClick(Sender: TObject);
    procedure showAppendixClick(Sender: TObject);
  private
    m_grpId:         TSchedId;
    m_NewGroup : boolean;
    m_schedListView: TMSchedListView;
    m_schedList:     TMSchedList;
    m_markStack:     TStackMark;
    m_tgtVisRes:     TMqmVisibleRes;
    m_propComp:      TMShowPropList;
    m_IsFromOccMove: boolean;
    m_IsJobRemovedFromGroup : boolean;
    m_SplitGroupData : TSplitGroupData;
    m_splitByAlternativeQty : boolean;
    m_AlternativeQty : double;
    m_AlternativeUM : string;
    m_SplitWasClicked : boolean;

    procedure SetAppendixButtonIfNeeded;
    procedure SetCurrent(id: TSchedId; markStack : TStackMark);
    procedure AddToGroup(id: TSchedId);
    procedure SetTargetVisRes(visRes: TMqmVisibleRes);
    procedure UpdateAddRemFld;
    procedure EnabledButtons;
    procedure UpdateTgtVisRes;
    function  SetGroupChain(id: TSchedId) : boolean;
    procedure SplitTypeChanged;
    procedure CalcSplitData;
    function  CheckSameUM : boolean;
    constructor CreateGroupDetail(AOwner : TComponent; IsNewGroup : boolean);
  end;

  function  IsGroupFormOut: boolean;
  function  GetGrpFromGrpForm: TSchedId;
  procedure HandleGroup(AOwner: TComponent; id: TSchedId; IsFromOccMove : boolean; markStack : TStackMark; IsNewGroup : boolean);
  procedure AddToGroup(id: TSchedId);
  procedure SetTargetVisRes(visRes: TMqmVisibleRes);
  function  CheckIfSplitIsPossible(Id : TSchedId) : boolean;
  procedure SplitRestOfGroup(Grp : TSchedId);
  procedure SplitRestOfJob(Id : TSchedId);

implementation

{$R *.DFM}

uses
  gnugettext,
  Math,
  UMSchedCont,
  FMBin,
  UMBinFunc,
  UMPlan,
  UMPlanFunc,
  UMActArea,
  UMSchedObjMover,
  UMWkCtr,
  UMObjCont,
  UMCompatSrv,
  UMCompat, FMMainPlan,
  FMOccMov,
  FMStepDetails,
  FMJobHandle,
  UMGlobal,
  FMMsgJobHandler,
  FMTotalViews,
  UGGlobal;

resourcestring
  STR_GRP_CONT  = 'continuous';
  STR_GRP_BATCH = 'batch';
  STR_GRP_PRINT = 'printing';

var
  TGroupDetail: TTGroupDetail;
  m_OK : BOolean;

//----------------------------------------------------------------------------//

function IsGroupFormOut: boolean;
begin
  Result := Assigned(TGroupDetail)
end;

//----------------------------------------------------------------------------//

function GetGrpFromGrpForm: TSchedId;
begin
  Assert(Assigned(TGroupDetail));
  Result := TGroupDetail.m_grpId
end;

//----------------------------------------------------------------------------//

procedure HandleGroup(AOwner: TComponent; id: TSchedId ;IsFromOccMove : boolean; markStack : TStackMark; IsNewGroup : boolean);
begin
  Assert(not Assigned(TGroupDetail));
  TGroupDetail := TTGroupDetail.CreateGroupDetail(AOwner, IsNewGroup);
  TGroupDetail.formStyle := fsStayOnTop;
  TGroupDetail.m_IsFromOccMove := IsFromOccMove;
  TGroupDetail.SetCurrent(id, markStack);

  TGroupDetail.SetAppendixButtonIfNeeded;

  if DBAppSettings.FixColJobMsgVis then
  begin
    TGroupDetail.m_schedListView.FixedCols := 1;
    TGroupDetail.m_schedListView.ColWidths[0] := 18;
    TGroupDetail.BtnJobMsg.Visible := true;
  end;

  if TGroupDetail.m_IsFromOccMove then
  begin
    TGroupDetail.SetFocusedControl(TGroupDetail);
    TGroupDetail.ShowModal
  end
  else
    TGroupDetail.Show
end;

//----------------------------------------------------------------------------//

procedure AddToGroup(id: TSchedId);
begin
  Assert(Assigned(TGroupDetail));
  TGroupDetail.AddToGroup(id);
  TGroupDetail.FormShow(TGroupDetail);
end;

//----------------------------------------------------------------------------//

procedure SetTargetVisRes(visRes: TMqmVisibleRes);
begin
  Assert(Assigned(TGroupDetail));
  TGroupDetail.SetTargetVisRes(visRes)
end;

//----------------------------------------------------------------------------//

function CheckIfSplitIsPossible(Id : TSchedId) : boolean;
var
  I : Integer;
  ChildId : TSchedId;
  Progress : CProgress;
  NumberOfjobsNotProgressed, NumberOfJobsFinalProgressed, NumberOfJobsPartiallyProgressed : integer;
  JobQty, ProgQty : currency;
  value: variant;
  dataType: CBinColValType;
  linkInfo: TSQlinkInfo;
begin
  Result := false;
  p_sc.GetLinkInfo(id, linkInfo);
  if linkInfo.isGroup then
  begin
    NumberOfjobsNotProgressed := 0;
    NumberOfJobsFinalProgressed := 0;
    NumberOfJobsPartiallyProgressed := 0;

    for i := 0 to p_sc.GetGrpNumSons(Id)-1 do
    begin
      ChildId := p_sc.GetGrpSon(Id, i);
      if p_sc.IsAForcedGroup(ChildId, false) then
      begin
        result := false;
        exit
      end;

      Progress := p_sc.IsProgressedTypeAllowSplitRemainQty(ChildId);
      if (Progress = prg_none) or (Progress = prg_Starting) then
        inc(NumberOfjobsNotProgressed)
      else if (Progress = prg_Final) or (Progress = prg_FinalSplit) then
        Inc(NumberOfJobsFinalProgressed)
      else
      begin
        // checking the generic :
        p_sc.GetFldValue(ChildId, CSC_ProgQty, value, dataType);
        ProgQty := value;
        p_sc.GetFldValue(ChildId, CSC_QtyToSched, value, dataType);
        JobQty := value;
        if JobQty <= ProgQty then
          inc(NumberOfJobsFinalProgressed)
        else
          Inc(NumberOfJobsPartiallyProgressed);

      end;

    end;

    if (NumberOfJobsPartiallyProgressed > 0) or ((NumberOfJobsFinalProgressed > 0) and (NumberOfjobsNotProgressed > 0))  then
      Result := true

//    if (p_sc.GetGrpNumSons(Id) = NoProgressFound) or (p_sc.GetGrpNumSons(Id) = NumberOfJobsFinalProgressed) then
//      result := false;
//    if (NoProgressFound = 0) and (p_sc.GetGrpNumSons(Id) = (FoundGenericProgressQtyOverLimit + NumberOfJobsFinalProgressed)) then
//      result := false;
//    if (FoundProgressHigherThanZero = 0) and (NumberOfJobsFinalProgressed = 0) then
//      Result := false;

  end
  else
  begin
    Progress := p_sc.IsProgressedTypeAllowSplitRemainQty(Id);
    if (Progress = prg_General) then
    begin
      // checking the generic :
      p_sc.GetFldValue(Id, CSC_ProgQty, value, dataType);
      ProgQty := value;
      p_sc.GetFldValue(Id, CSC_QtyToSched, value, dataType);
      JobQty := value;
      if JobQty > ProgQty then
        result := true;
    end;
  end;

end;

//----------------------------------------------------------------------------//

procedure SplitRestOfGroup(Grp : TSchedId);
var
  markStack : TStackMark;
  I : Integer;
  List : TList;
  ChildId, Newgrp, NewId : TSchedId;
  Progress : CProgress;
  GroupCreated : boolean;
  value: variant;
  dataType: CBinColValType;
  JobQty, ProgQty, AvailQty: currency;
  OrigJobQty, EachJobQty, QtyPerJob: currency;
  SplitNo, NewJobNr: integer;
  Err: string;
begin
  GroupCreated := false;
  p_opStack.MarkStackForButtonUndo('Remove from group'); //aviadd
  for I := p_sc.GetGrpNumSons(Grp)-1 downto 0 do
  begin
    ChildId := p_sc.GetGrpSon(Grp, i);
    Progress := p_sc.IsProgressedTypeAllowSplitRemainQty(ChildId);
    if (Progress = prg_Final) or (Progress = prg_FinalSplit) then continue;
    if (Progress = prg_none) then
    begin
      p_opStack.RemoveJobFromGroup(ChildId, 'Removed for group split');
      if not GroupCreated then
      begin
        p_opStack.CreateGroup(ChildId, Newgrp);
        GroupCreated := true;
      end
      else
      begin
        p_opStack.AddJobToGroup(ChildId, Newgrp);
      end;
    end
    else
    begin
      p_sc.GetFldValue(ChildId, CSC_ProgQty, value, dataType);
      ProgQty := value;
      if ProgQty = 0 then
      begin
        p_opStack.RemoveJobFromGroup(ChildId, 'Removed for group split');
        if not GroupCreated then
        begin
          p_opStack.CreateGroup(ChildId, Newgrp);
          GroupCreated := true;
        end
        else
        begin
          p_opStack.AddJobToGroup(ChildId, Newgrp);
        end;
        continue;
      end;

      p_sc.GetFldValue(ChildId, CSC_QtyToSched, value, dataType);
      JobQty := value;
      AvailQty := (JobQty - ProgQty);
      QtyPerJob := AvailQty;
      if not CalcSplitQty(ChildId, 0, 0, AvailQty, 1, QtyPerJob, OrigJobQty, EachJobQty, NewJobNr, Err) then
      begin
        continue;
      end;

      p_opStack.SplitJob(ChildId, OrigJobQty, EachJobQty, NewJobNr, NewId, List);

      if not GroupCreated then
      begin
        p_opStack.CreateGroup(NewId, Newgrp);
        GroupCreated := true;
      end
      else
      begin
        p_opStack.AddJobToGroup(NewId, Newgrp);
      end;

    end;
    FMQMPlan.ActiveUndo;
  end;

end;

//----------------------------------------------------------------------------//

procedure SplitRestOfJob(Id : TSchedId);
var
  List : TList;
  NewId : TSchedId;
  Progress : CProgress;
  GroupCreated : boolean;
  value: variant;
  dataType: CBinColValType;
  JobQty, ProgQty, AvailQty: currency;
  OrigJobQty, EachJobQty, QtyPerJob: currency;
  SplitNo, NewJobNr: integer;
  Err: string;
begin
  p_opStack.MarkStackForButtonUndo('Split rest of job'); //aviadd
  p_sc.GetFldValue(Id, CSC_ProgQty, value, dataType);
  ProgQty := value;
  p_sc.GetFldValue(Id, CSC_QtyToSched, value, dataType);
  JobQty := value;
  AvailQty := (JobQty - ProgQty);
  QtyPerJob := AvailQty;
  if not CalcSplitQty(Id, 0, 0, AvailQty, 1, QtyPerJob, OrigJobQty, EachJobQty, NewJobNr, Err) then
  begin
    FMQMPlan.TBUndoClick(Application);
    exit
  end;
  p_opStack.SplitJob(Id, OrigJobQty, EachJobQty, NewJobNr, NewId, List);
  FMQMPlan.ActiveUndo;
end;

//----------------------------------------------------------------------------//

procedure TTGroupDetail.FormCreate(Sender: TObject);
begin
  ScaleFormSize(Self, Screen.PixelsPerInch);
  TranslateComponent (self);

  m_schedListView        := TMSchedListView.CreateListView(TBSched, m_schedList);
  m_schedListView.Parent := TBSched;
  m_schedListView.Align  := alClient;
  m_IsJobRemovedFromGroup := false;

  m_tgtVisRes            := nil;
  GPBtgtRes.Visible      := false;

//  m_propComp := TMShowPropList.CreateShowPropList(TBProp, nil, m_grpId);
//m_propComp := TPropComponent.Create(TBProp, CapResProp)
  PgcGrp.ActivePage := TBSched;
  if m_NewGroup then
    p_opStack.MarkStackForButtonUndo(_('Add Or remove from group')); //aviadd
//  p_opStack.MarkStackForButtonUndo(_('Split Job')); //aviadd

  PnlSplit.Height := 0;
  Height := 450;//360;


  ReShape(Self);

end;

//----------------------------------------------------------------------------//

procedure TTGroupDetail.FormClose(Sender: TObject; var Action: TCloseAction);
var
  MQMPlan : TFMQMPlan;
  NewItem : TMenuItem;
  ObjMover  : TMqmSchedObjMover;
  ResComp : Integer;
  Res : TMqmVisibleRes;
  info:  TSQStartEndInfo;
  NewIdStartDate, TmpEndDate : TDateTime;
  setup, overlap, duration : double;
  OptsMover: SetOptsMover;
  DeltaSetupObjToMove: double;
  Ptr : Pointer;
begin

 //Abort
  if not m_OK then
  begin
   p_opStack.UndoByMark(m_markStack);
   FBin.ChangeTabBinforChangeTabPlan;
  end;

   if m_SplitWasClicked and (p_sc.GetExtLinkPtr(m_grpId) <> nil) then
   begin
      p_pl.EnterCompatModeInPlanForSplit(m_grpId);
      ObjMover := TMqmSchedObjMover.Create;
      ObjMover.SetObjToMove(m_grpId);

      if p_sc.GetRscComponentFromJobOrStep(m_grpId) > 0 then
        ResComp := p_sc.GetRscComponentFromJobOrStep(m_grpId)
      else
        ResComp := Res.p_ResComp;

      p_sc.GetStartEndInfo(m_grpId, info);

      Ptr := p_sc.GetExtLinkPtr(m_grpId);

      NewIdStartDate := info.startDate;
      if ObjMover.ChangeTo(TMqmActArea(ptr), NewIdStartDate, false, CSchedIDnull, Al_toDate, setup, overlap,
                           duration, '', TmpEndDate, OptsMover, nil, False, DeltaSetupObjToMove,false, ResComp) = CSM_Yes then
      begin
      end
      else
        ObjMover.Abort;

      p_pl.ExitCompatModeInPlanForAutoSeq;
   end;

  Action := caFree;
  if not m_IsFromOccMove then
    p_pl.ExitCompatModeInPlan;
  p_sc.SetAllFlags([CSF_selected], []);
  FBin.RefreshGrid;
  MQMPlan := GetPlanView;
  if assigned(MQMPlan) then
    FMQMPlan.RefreshActiveTab;
  TGroupDetail := nil;

//  FBin.SetBinMenuItems(FBin.GetMouseSchedObj);

  if DBAppGlobals.ShowColorJobMode = PreDefinedPropList then
  begin
    if (GetIdFromCode(DBAppGlobals.LastPropColorInUseJobMode) <> nil) and Assigned(MQMPlan) then
    begin
      NewItem := TMenuItem.Create(Self);
      NewItem.VCLComObject := GetIdFromCode(DBAppGlobals.LastPropColorInUseJobMode);
      MQMPlan.ClickShowBarColorfromPropList(NewItem);
    end;
  end
  else if DBAppGlobals.ShowColorJobMode = DinamicPropList then
  begin
    if (GetIdFromCode(DBAppGlobals.LastPropColorInUseJobMode) <> nil) and Assigned(MQMPlan) then
    begin
      NewItem := TMenuItem.Create(Self);
      NewItem.VCLComObject := GetIdFromCode(DBAppGlobals.LastPropColorInUseJobMode);
      MQMPlan.ClickShowBarColorDynamic(NewItem);
    end
    else
      DBAppGlobals.ShowColorJobMode := Standard;
  end;

 // if ModalResult <> mrOK then
  FMQMPlan.ActiveUndo;


{  if ModalResult <> mrOK then
  begin
    p_opStack.UndoTo(m_markStack);
  end
  else
  begin
    FMQMPlan.ActiveUndo;
  end; }


end;

//----------------------------------------------------------------------------//

procedure TTGroupDetail.SetAppendixButtonIfNeeded;
var
  TotalViews_List : TList;
  NewItem : TMenuItem;
  I : Integer;
begin
  TotalViews_List := GetTotalViews_List;

  if TotalViews_List.Count > 0 then
  begin

    ButtonAppendix.Visible := true;
    for I := 0 to TotalViews_List.Count - 1 do
    begin
      if PTTotalsView(TotalViews_List[i]).Wkc_list.count = 0 then
      begin
        ButtonAppendix.Visible := False;
        exit;
      end;

      if PTTotalsView(TotalViews_List[i]).Wkc_list.IndexOf(TMqmWrkCtr(p_sc.GetWrkCtrPtr(m_grpId))) > -1 then
      begin
          NewItem := TMenuItem.Create(Self);
         // PopupMenuAppendix.add  GetCodeViewName(I);
          NewItem.VCLComObject := Pointer(TotalViews_List[I]);
          NewItem.Caption := GetCodeViewName(I);
          NewItem.Name    := 'MiFormulaItem' + IntToStr(I);
          NewItem.OnClick := showAppendixClick;     // IwkcPropertySelectionWc
          PopupMenuAppendix.Items.Add(NewItem);
      end;
    end;

    if PopupMenuAppendix.Items.Count = 0 then
      ButtonAppendix.Visible := False;
  end else
    ButtonAppendix.Visible := False;

  ButtonAppendix.Visible := FBin.GetBinPopupList.IndexOf('MiFormularesult') > -1;

end;

//----------------------------------------------------------------------------//

procedure TTGroupDetail.SetCurrent(id: TSchedId ; markStack : TStackMark);
var
  i:       integer;
  isGrp:   boolean;
  str:     string;
  scType:  CScSchedType;
  actArea: TMqmActArea;
  FMQMPlan : TFMQMPlan;
  GroupingType : CGroupingType;
begin
  Assert(id <> CSchedIdNull);
  str := p_sc.GetObjInfo(id, isGrp);

  if markStack <> -1 then
    m_markStack := markStack
  else
    m_markStack := p_opStack.MarkStack;

  m_schedList := TMSchedList.Create(self);

  if isGrp then
  begin
    m_grpId := id;
    EnabledButtons;
  end
  else
  begin
    GroupingType := p_sc.GetStepGroupType(id);
    p_opStack.CreateGroup(id, m_grpId);
    if (GroupingType = MultiStepForward_grp) or (GroupingType = MultiStepBackward_grp) or (GroupingType = MultiStepForwardBackward_grp) then
       SetGroupChain(Id);
  end;


  StGrpNo.Caption := p_sc.GetFldDescr(m_grpId, CSC_GroupNo, false);

{  scType := p_sc.GetJobType(m_grpId);
  case scType of
  CST_continuous:
    begin
//      StGrpType.Caption := STR_GRP_CONT;
    end;

  CST_batch:
    begin
 //     StGrpType.Caption := STR_GRP_BATCH;
    end;

  else
    begin
   //   StGrpType.Caption := STR_GRP_PRINT;
    end;
  end; }

  UpdateAddRemFld;

  for i := 0 to p_sc.GetGrpNumSons(m_grpId)-1 do
    m_schedList.AddLink(p_sc.GetGrpSon(m_grpId, i));
  m_schedListView.SetSchedList(m_schedList);

  if not m_IsFromOccMove then
    p_pl.EnterCompatModeInPlan(m_grpId);

  FMQMPlan := GetPlanView;
  if assigned(FMQMPlan) then
    FMQMPlan.RefreshActiveTab;
  FBin.ChangeTabBinforChangeTabPlan;

  actArea := TMqmActArea(p_sc.GetExtLinkPtr(m_grpId));
  if Assigned(actArea) then
    SetTargetVisRes(TMqmVisibleRes(actArea.p_father));

//  prop := p_sc.GetProperties(m_grpId, nil);
//  m_propComp.ChangePropList(prop);

end;

//----------------------------------------------------------------------------//

procedure TTGroupDetail.AddToGroup(id: TSchedId);
var
  FMQMPlan : TFMQMPlan;
  GroupingTypeGrp, GroupingTypeJob : CGroupingType;
  SChedListJobInGroup, SChedListJob : TMSchedList;
  I : Integer;
  SonId, GroupId : TSchedId;
  IsBelong : boolean;
  MqmActArea : TMqmActArea;
begin
  Assert(Assigned(m_schedList));
  p_opStack.AddJobToGroup(id, m_grpId);
  p_sc.SetPropListFlag(m_grpId, true, false);

  GroupingTypeGrp := p_sc.GetStepGroupType(m_grpId);
  GroupingTypeJob := p_sc.GetStepGroupType(id);
  if ((GroupingTypeGrp = MultiStepForward_grp) or (GroupingTypeGrp = MultiStepBackward_grp) or
     (GroupingTypeGrp = MultiStepForwardBackward_grp)) and (GroupingTypeGrp = GroupingTypeJob) then
  begin
    SChedListJobInGroup := TMSchedList.Create(self);
    SChedListJob   := TMSchedList.Create(self);
    p_sc.GetALLStepBrothersForGrouping(m_grpId, SChedListJobInGroup, true);
    p_sc.GetALLStepBrothersForGrouping(id, SChedListJob, true);
    if (SChedListJobInGroup.GetLinkCount = SChedListJob.GetLinkCount) then
    begin
      for I := 0 to SChedListJobInGroup.GetLinkCount - 1 do
      begin
        SonId := SChedListJobInGroup.GetLink(I);
        IsBelong := false;
        GroupId := p_sc.LinesBelongToGroup(SonId , IsBelong);
        if IsBelong and (p_sc.GetStepGroupType(SChedListJob.GetLink(I)) = FromOtherStep_grp) then
          p_opStack.AddJobToGroup(SChedListJob.GetLink(I), GroupId);
      end;
    end;
  end;

  FMQMPlan := GetPlanView;

  UpdateAddRemFld;

  m_schedList.AddLink(id);

  MqmActArea := TMqmActArea(p_sc.GetExtLinkPtr(m_grpId));
  if Assigned(MqmActArea) then
  begin
    MqmActArea := TMqmActArea(p_sc.GetExtLinkPtr(m_grpId));
    if assigned(MqmActArea) then
      MqmActArea.ReorganizeAllOcc(true);
  end;

  if assigned(FMQMPlan) then
    FMQMPlan.RefreshActiveTab;

  /////

  m_schedList.ClearList;
  for i := 0 to p_sc.GetGrpNumSons(m_grpId)-1 do
    m_schedList.AddLink(p_sc.GetGrpSon(m_grpId, i));
  m_schedListView.SetSchedList(m_schedList);

  /////
  m_schedListView.RefreshList;
  m_schedListView.Refresh;
  FBin.ChangeTabBinforChangeTabPlan
end;

//----------------------------------------------------------------------------//

procedure TTGroupDetail.BtnOkClick(Sender: TObject);
var
  actArea: TMqmActArea;
  OptsMover: SetOptsMover;
  DeltaSetupObjToMove: double;
  TmpStartDate : TDateTime;
  ObjMover  : TMqmSchedObjMover;
  Res : TMqmVisibleRes;
  setup, overlap, duration : double;
  components, ResComp : integer;
begin
  if p_sc.GetSchedType(m_grpId) <> '0' then
     p_sc.SetSchedType(m_grpId, p_sc.GetSchedType(m_grpId));

  if BtnSplit.Visible then
  begin
    if assigned(FBin) then
       Fbin.UpdateForChangeFilter;
  end;

  m_OK := True;

  // just to make sure we we call changeTo function
  if m_IsJobRemovedFromGroup then
  begin
    actArea := TMqmActArea(p_sc.GetExtLinkPtr(m_grpId));
    if Assigned(actArea) then
    begin
      OccMoveEnter(FMQMPlan, Pointer(m_grpId));
      ObjMover := TMqmSchedObjMover.Create;
      ObjMover.SetObjToMove(m_grpId);
      Res := TMqmVisibleRes(ActArea.p_Father);
      TmpStartDate := p_sc.GetSchedStart(m_grpId);
      if p_sc.GetRscComponentFromJobOrStep(m_grpId) > 0 then
        ResComp := p_sc.GetRscComponentFromJobOrStep(m_grpId)
      else
        ResComp := Res.p_ResComp;
      if ObjMover.ChangeTo(ActArea, TmpStartDate, false, CSchedIDnull, Al_toDate, setup, overlap,
                           duration, '', TmpStartDate, OptsMover, nil, False, DeltaSetupObjToMove,false, ResComp) = CSM_Yes then
      begin
      end
      else
        ObjMover.Abort;
      OccMoveExit(FMQMPlan, true);
    end;
  end;

  Close;

end;

//----------------------------------------------------------------------------//

procedure TTGroupDetail.BtnAboClick(Sender: TObject);
begin
//  p_opStack.UndoTo(m_markStack);
  m_OK := False;
  Close
end;

//----------------------------------------------------------------------------//

procedure TTGroupDetail.BtnRemoveClick(Sender: TObject);
var
  id: TSchedId;
  I : Integer;
  extPtr: pointer;
  FMQMPlan : TFMQMPlan;
  prop : TProperties;
begin
  m_IsJobRemovedFromGroup := true;
  FMQMPlan := GetPlanView;
  id := m_schedListView.GetSelected;
  if id = CSchedIdNull then exit;
  if p_sc.IsAForcedGroup(id, false) then
  begin
    MessageDlg('Unable to remove a job from a forced group', mtWarning, [mbOK], 0);
  exit;
  end;
  m_schedList.Remove(id);
  if not m_NewGroup then
    p_opStack.MarkStackForButtonUndo('Remove from group'); //aviadd

  if p_sc.GetGrpNumSons(m_grpId) = 1 then
  begin
    extPtr := p_sc.GetExtLinkPtr(m_grpId);
    if Assigned(extPtr) then
      p_opStack.DetachOccFromApa(m_grpId, extPtr);
    RemoveChaineGroupType(Id, true);
    prop := p_sc.GetProperties(Id,nil);
    for I := 0 to prop.P_PropCountInstanceCounter - 1 do
      prop.CleanPropertyInstanceCounter(I);
    p_opStack.RemoveJobFromGroup(id, 'Removed manually by user');
    p_sc.DeleteGroup(m_grpId);
    FBin.ChangeTabBinforChangeTabPlan;
    if m_NewGroup then
      p_opStack.Clear;
    Close
  end else
  begin
    prop := p_sc.GetProperties(Id,nil);
    for I := 0 to prop.P_PropCountInstanceCounter - 1 do
      prop.CleanPropertyInstanceCounter(I);
    p_opStack.RemoveJobFromGroup(id, 'Removed manually by user');
    p_sc.SortGroup(m_grpId);
    RemoveChaineGroupType(Id,false);
    if assigned(FMQMPlan) then
      FMQMPlan.RefreshActiveTab;
    FBin.ChangeTabBinforChangeTabPlan;
    m_schedListView.RefreshList;
    m_schedListView.Refresh;
    UpdateAddRemFld;
    FormShow(self);
  end;
  p_sc.SetPropListFlag(m_grpId, true, false);
end;

//----------------------------------------------------------------------------//

procedure TTGroupDetail.RemoveChaineGroupType(Id : TSchedId; LastJob : boolean);
var
  GroupingTypeGrp, GroupingTypeJob : CGroupingType;
  SChedListJobInGroup,SChedListJob : TMSchedList;
  I : Integer;
  SonId,GroupId : TSchedId;
  IsBelong : boolean;
  extPtr: pointer;
begin
  GroupingTypeGrp := p_sc.GetStepGroupType(m_grpId);
  GroupingTypeJob := p_sc.GetStepGroupType(id);
  if ((GroupingTypeGrp = MultiStepForward_grp) or (GroupingTypeGrp = MultiStepBackward_grp) or
     (GroupingTypeGrp = MultiStepForwardBackward_grp)) and (GroupingTypeGrp = GroupingTypeJob) then
  begin
    SChedListJobInGroup := TMSchedList.Create(self);
    SChedListJob   := TMSchedList.Create(self);
    p_sc.GetALLStepBrothersForGrouping(m_grpId, SChedListJobInGroup, false);
    p_sc.GetALLStepBrothersForGrouping(id, SChedListJob, false);
    if (SChedListJobInGroup.GetLinkCount = SChedListJob.GetLinkCount) then
    begin
      for I := 0 to SChedListJobInGroup.GetLinkCount - 1 do
      begin
        SonId := SChedListJobInGroup.GetLink(I);
        IsBelong := false;
        GroupId := p_sc.LinesBelongToGroup(SonId , IsBelong);
        if IsBelong and (p_sc.GetStepGroupType(SChedListJob.GetLink(I)) = FromOtherStep_grp) then
        begin
          if LastJob then
          begin
            extPtr := p_sc.GetExtLinkPtr(GroupId);
            if Assigned(extPtr) then
              p_opStack.DetachOccFromApa(GroupId, extPtr);
            p_opStack.RemoveJobFromGroup(SChedListJob.GetLink(I), 'Removed manually by user');
            p_sc.DeleteGroup(GroupId);
          end
          else
            p_opStack.RemoveJobFromGroup(SChedListJob.GetLink(I), 'Removed manually by user');
        end;
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TTGroupDetail.RgSplitTypeClick(Sender: TObject);
begin
  SplitTypeChanged
end;

//----------------------------------------------------------------------------//

procedure TTGroupDetail.showAppendixClick(Sender: TObject);
var NewItem : TMenuItem;
  FTotalViews : TFTotalViews;
begin
  NewItem := TMenuItem(Sender);

  if PTTotalsView(NewItem.VCLComObject).Wkc_list.Count = 0 then
  begin
    MessageDlg('Select workcenter for this set!', mtError, [mbOk], 0);
    exit;
  end;

  if PTTotalsView(NewItem.VCLComObject).Group_list.Count = 0 then
  begin
    MessageDlg('Select group by for this set!', mtError, [mbOk], 0);
    exit;
  end;

    if PTTotalsView(NewItem.VCLComObject).Formula_list.Count = 0 then
  begin
    MessageDlg('Select formula for this set!', mtError, [mbOk], 0);
    exit;
  end;

  if Assigned(NewItem) then
  begin
    try
      FTotalViews := TFTotalViews.CreateTotalView_Final(Self, m_schedList, PTTotalsView(NewItem.VCLComObject) ,'view', p_sc.GetFldDescr(m_grpId, CSC_GroupNo, false));

      if FTotalViews.GetError <> '' then
      begin
        MessageDlg(FTotalViews.GetError, mtWarning, [mbok], 0);
      end else
      begin
        FTotalViews.ShowModal;
      end;

    finally
      FTotalViews.free;
    end;

  end;

end;

//----------------------------------------------------------------------------//

procedure TTGroupDetail.BtnShowCompClick(Sender: TObject);
var
  iter:     TMSchedContIterator;
  id:       TSchedId;
  linkInfo: TSQlinkInfo;
  errDesc:  string;
  addFnc : TGrpAddFunc;
begin
  if p_sc.GetExtLinkPtr(m_grpId) = nil then
    addFnc := CanAddJobToGroupOnBin
  else
    addFnc := CanAddJobToGroupOnPlan;

  iter := TMSchedContIterator.CreateScIter(p_sc);
  while true do
  begin
    id := iter.GetNext;
    if id = CSchedIdNull then break;
    if p_sc.GetLinkInfo(id, linkInfo)  and
       (not linkInfo.isOnPlan)         and
       (not linkInfo.isGroup)          and
       (linkInfo.grpId = CSchedIdNull) and
       p_sc.CanAddJobToGroup(id, m_grpId, addFnc, CanAddJobToGroupSameType, errDesc) then
      p_sc.SetFlags(id, [], [CSF_selected])
    else
      p_sc.SetFlags(id, [CSF_selected], [])
  end;

  FBin.RefreshGrid
end;

//----------------------------------------------------------------------------//

procedure TTGroupDetail.SetTargetVisRes(visRes: TMqmVisibleRes);
var
  res: TMqmRes;

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
      stTxt.Brush.Color := clInfoBk
    end
  end;

begin
  if not Assigned(visRes) then
  begin
    GPBtgtRes.Visible := false;
    exit
  end;

  GPBtgtRes.Visible := true;  
  res := TMqmRes(visRes.p_father);
  if not res.p_occCanAttach then exit;

  GPBtgtRes.Visible := true;

  m_tgtVisRes := visRes;

  StTgtWkc.Caption := TMqmWrkCtr(res.p_father).p_WrkCtrCode;
  StTgtRes.Caption := res.p_ResCode;

  if res.p_isMultiRes then
  begin
    LblSubRes.Visible   := true;
    StTgtSubRes.Visible := true;
    StTgtSubRes.Caption := IntToStr(visRes.p_SubCode)
  end
  else
  begin
    LblSubRes.Visible   := false;
    StTgtSubRes.Visible := false;
  end;

  UpdateTgtVisRes
end;

//----------------------------------------------------------------------------//

procedure TTGroupDetail.UpdateAddRemFld;
var
  BatchQty: double;
  MultQty : double;
  res:      TMqmRes;
  objWkc:   TMqmWrkCtr;
begin
  BtnSplitGroup.Visible := True;
  if CheckSameUM then
    StGrpQty.Caption := p_sc.GetFldDescr(m_grpId, CSC_QtyToSched, false) + ' ' +
                      p_sc.GetFldDescr(m_grpId, CSC_ProdUM, false)
  else
  begin
    BtnSplitGroup.Visible := false;
    StGrpQty.Caption := '------';
  end;

  if not Assigned(m_tgtVisRes) then
  begin
    objWkc := TMqmWrkCtr(p_sc.GetWrkCtrPtr(m_grpId));
    if not Assigned(objWkc) then exit;
    res := TMqmRes(objWkc.p_Res[0]);
  end else
    res := TMqmRes(m_tgtVisRes.p_father);

  // fp - temp.... Only for prevent some access violation.... must be checked after
  if not Assigned(res) then exit;

  if res.p_BchUM = '' then
  begin
  //  LblBatchQty.Visible := false;
  //  StBatchQty.Visible := false;
    PanBch.Visible := false
  end
  else begin
  //  LblBatchQty.Visible := true;
  //  StBatchQty.Visible := true;
    PanBch.Visible := true;
    BatchQty := StrToFloat(p_sc.GetFldDescr(m_grpId, CSC_QtyToSched, false));
    p_sc.QtyInUM(m_grpId, res.p_BchUM, BatchQty, MultQty);

  //  StBatchQty.Caption := FloatToStr(BatchQty) + ' ' +
   //                       res.p_BchUM;
  end;
  UpdateTgtVisRes
end;

//----------------------------------------------------------------------------//

procedure TTGroupDetail.EnabledButtons;
var
  planInfo     : TSQplanInfo;
  GroupingType : CGroupingType;
begin
  planInfo.VisibleInBin := CSB_Normal;
  p_sc.GetPlanInfo(m_grpId , planInfo);
  GroupingType := p_sc.GetStepGroupType(m_grpId);
  if (PlanInfo.VisibleInBin = CSB_ReadOnly) or (m_IsFromOccMove) or (GroupingType = FromOtherStep_grp) then
  begin
    BtnRemove.Enabled     := false;
    BtnMove.Enabled       := false;
    BtnShowComp.Enabled   := false;
    BtnOk.Enabled         := false;
    BtnChgQtyJobs.Enabled := false
  end
end;

//----------------------------------------------------------------------------//

procedure TTGroupDetail.UpdateTgtVisRes;
var
  res:      TMqmRes;
  tmp:      double;
  qty:      double;
  MultQty:  double;
  AdditionalOptimumMaxMultiplierProp,AdditionalMinMultiplierProp : double;

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
      stTxt.Brush.Color := clInfoBk
    end
  end;

begin
  if not Assigned(m_tgtVisRes) then exit;

  res := TMqmRes(m_tgtVisRes.p_father);

  if res.p_BchUM <> '' then
  begin
    AdditionalOptimumMaxMultiplierProp := res.P_GetAdditionalOptimumMaxMultiplierProp[m_grpId];
    AdditionalMinMultiplierProp        := res.P_GetAdditionalMinMultiplierProp[m_grpId];
    StBchMinLev.Caption := FloatToStr(res.p_Min_bch_size) + ' ' + res.p_BchUM;
    StBchStdLev.Caption := FloatToStr(res.p_Sndt_bch_Size) + ' ' + res.p_BchUM;
    StBchMaxLev.Caption := FloatToStr(res.p_Max_bch_size) + ' ' + res.p_BchUM;

    if not p_sc.QtyInUM(m_grpId, res.p_BchUM, qty, MultQty) then
    begin
      StBchStdToLev.Caption := '---';
      StBchMaxToLev.Caption := '---'
    end
    else
    begin
      tmp := res.p_Sndt_bch_size*AdditionalOptimumMaxMultiplierProp - qty;
      if res.p_Sndt_bch_size = 0 then
        StBchStdToLev.Caption := '---'
      else
        SetBatchField(StBchStdToLev, tmp);

      tmp := res.p_Max_bch_size*AdditionalOptimumMaxMultiplierProp - qty;
      if res.p_Max_bch_size = 0 then
        StBchMaxToLev.Caption := '---'
      else
        SetBatchField(StBchMaxToLev, tmp);



      //////
      tmp := res.p_Min_bch_size*AdditionalMinMultiplierProp + qty;
      if res.p_Min_bch_size = 0 then
        StBchMinToLev.Caption := '---'
      else
        SetBatchField(StBchMinToLev, tmp);
      //////


    end
  end
end;

//----------------------------------------------------------------------------//

function TTGroupDetail.SetGroupChain(id: TSchedId) : boolean;
var
  SChedList : TMSchedList;
  I, GrpId  : Integer;
begin
  Result := true;
  SChedList := TMSchedList.Create(self);
  p_sc.GetALLStepBrothersForGrouping(id, SChedList, true);
  for I := 0 to SChedList.GetLinkCount - 1 do
    p_opStack.CreateGroup(SChedList.GetLink(I), GrpId);
end;

//----------------------------------------------------------------------------//

procedure TTGroupDetail.SplitTypeChanged;
var
  JobQty, ProgQty, AlternativeJobQty, QtyToSplit : double;
  JobQtyValue, stepQtyValue, ProgQtyValue : variant;
  dataType: CBinColValType;
  QtyInt : Integer;
  DecMult : integer;
begin
  DecMult := Round(IntPower(10, p_sc.GetJobNumOfDecimals(m_grpId)));
  p_sc.GetFldValue(m_grpId, CSC_QtyToSched, JobQtyValue, dataType);
  JobQty := JobQtyValue;

  p_sc.GetFldValue(m_grpId, CSC_ProgQty, ProgQtyValue, dataType);
  ProgQty := ProgQtyValue;

  if m_splitByAlternativeQty then
  begin
    p_sc.GetFldValue(m_grpId, CSC_IniQty , stepQtyValue, dataType);
    AlternativeJobQty := jobqty / stepQtyValue * m_AlternativeQty;
    ProgQty := ProgQty / stepQtyValue * m_AlternativeQty;
  end;

  case RgSplitType.ItemIndex of
    0:  begin //by number
          if m_splitByAlternativeQty then
            EdtQtyToSplit.Text    := FloatToStr(m_AlternativeQty-ProgQty)
          else
            EdtQtyToSplit.Text    := FloatToStr(JobQty-ProgQty);
          EdtQtyPerJob.Text     := '0';
          SEdtNumOfGroups.Value   := 0;
          EdtQtyToSplit.Enabled := true;
          SEdtNumOfGroups.Enabled := true;
          EdtQtyPerJob.Enabled  := false;
        end;
    1:  begin //by quantity

          if m_splitByAlternativeQty then
            EdtQtyToSplit.Text    := FloatToStr(m_AlternativeQty-ProgQty)
          else
            EdtQtyToSplit.Text    := FloatToStr(JobQty-ProgQty);
          SEdtNumOfGroups.Value   := 0;
          EdtQtyPerJob.Text     := '0';
          EdtQtyToSplit.Enabled := true;
          SEdtNumOfGroups.Enabled := false;
          EdtQtyPerJob.Enabled  := true;
        end;
    2:  begin
          if m_splitByAlternativeQty then
            EdtQtyToSplit.Text    := FloatToStr(m_AlternativeQty-ProgQty)
          else
            EdtQtyToSplit.Text    := FloatToStr(JobQty-ProgQty);
          SEdtNumOfGroups.Value   := 0;
          EdtQtyPerJob.Text     := '0';
          EdtQtyToSplit.Enabled := false;
          SEdtNumOfGroups.Enabled    := true;
          EdtQtyPerJob.Enabled  := true;
        end;
  end;

  if EdtQtyToSplit.Text <> '' then
  begin
    QtyToSplit  := StrToFloat(EdtQtyToSplit.Text);
    QtyInt := trunc(QtyToSplit * DecMult);
    QtyToSplit := QtyInt/DecMult;
    EdtQtyToSplit.Text := FloatToStr(QtyToSplit);
  end;

  EdtSplitError.Text     := '';
//  StCurrGrpQty.Caption   := '0';
  StQtyEachGrp.Caption   := '0';
  StNrOfNewGrp.Caption   := '0';
end;

//----------------------------------------------------------------------------//

constructor TTGroupDetail.CreateGroupDetail(AOwner : TComponent; IsNewGroup : boolean);
begin
  inherited Create(AOwner);
  m_SplitWasClicked := false;
  m_NewGroup := IsNewGroup;
end;

//----------------------------------------------------------------------------//

procedure TTGroupDetail.CalcSplitData;
var
  SplitQty, QtyPerGrp,
  OrigGrpQty, EachGrpQty : currency;
  SplitNo, NewGrpNr: integer;
  dataType: CBinColValType;
  JobQtyValue, stepqtyValue: variant;
  Err: string;
  JobQty, AlternativeJobQty : currency;
begin
  if EdtQtyPerJob.Text = '' then
  begin
    EdtSplitError.Text := _('Quantity per group cannot be empty');
    exit;
  end;

  if (EdtQtyToSplit.Text = '') then
  begin
    EdtSplitError.Text := _('Quantity to split cannot be empty');
    exit;
  end;

  p_sc.GetFldValue(m_grpId, CSC_QtyToSched, JobQtyValue, dataType);
  JobQty := JobQtyValue;

  if m_splitByAlternativeQty then
  begin
    p_sc.GetFldValue(m_grpId, CSC_IniQty , stepQtyValue, dataType);
    JobQty := m_AlternativeQty;
  end;

  if RGQtyType.ItemIndex = 0 then
    SplitQty := StrToFloat(EdtQtyToSplit.Text)
  else
    SplitQty  := JobQty - StrToFloat(EdtQtyToSplit.Text);

  SplitNo   := SEdtNumOfGroups.Value;

  QtyPerGrp := StrToFloat(EdtQtyPerJob.Text);

  if m_splitByAlternativeQty then
     BtnSplit.Enabled := CalcSplitQtyGrpAlternative(m_grpId, RgSplitType.ItemIndex, SplitQty, SplitNo, QtyPerGrp, OrigGrpQty, EachGrpQty, NewGrpNr, Err)
  else
    BtnSplit.Enabled := CalcSplitQtyGrp(m_grpId, RgSplitType.ItemIndex, SplitQty, SplitNo, QtyPerGrp, OrigGrpQty, EachGrpQty, NewGrpNr, Err);

  if BtnSplit.Enabled then
  begin
    EdtSplitError.Text    := '';
    StCurrGrpQty.Caption  := FloatToStr(OrigGrpQty);
    StQtyEachGrp.Caption  := FloatToStr(EachGrpQty);
    StNrOfNewGrp.Caption  := IntToStr(NewGrpNr);
    BtnSplit.Visible      := true;
    m_SplitGroupData.Id_Grp := m_grpId;
    m_SplitGroupData.SplitPercent := NewGrpNr*EachGrpQty/JobQty;
    m_SplitGroupData.NewGrpNr := NewGrpNr;
  end else
  begin
    EdtSplitError.Text    := Err;
    StCurrGrpQty.Caption  := '0';
    StQtyEachGrp.Caption  := '0';
    StNrOfNewGrp.Caption  := '0';
  end;

end;

//----------------------------------------------------------------------------//

function TTGroupDetail.CheckSameUM: boolean;
var
  I : integer;
  UM : string;
  SonId : TSchedId;
  valueUM : variant;
  dataType  : CBinColValType;
begin
  Result := true;
  UM := '';
  for i := 0 to p_sc.GetGrpNumSons(m_grpId)-1 do
  begin
    SonId := p_sc.GetGrpSon(m_grpId, i);
    p_sc.GetFldValue(SonId, CSC_ProdUM, valueUM, dataType);

    if um = '' then
      um := ValueUM;

    if um <> ValueUM then
    begin
      result := false;
      break
    end;
  end;

end;

//----------------------------------------------------------------------------//

procedure TTGroupDetail.BtnSelectedClick(Sender: TObject);
begin
    m_schedListView.DetailSelected;
end;

//----------------------------------------------------------------------------//

procedure TTGroupDetail.BtnMoveClick(Sender: TObject);
var
  FMQMPlan : TFMQMPlan;
begin
  m_OK := true;
  Close;
  FMQMPlan := GetPlanView;
  OpenOccMoveForm(FMQMPlan, m_grpId, RefreshAfterMove, FMQMPlan, OccMoveEnter, OccMoveExit, false)
end;

//----------------------------------------------------------------------------//

procedure TTGroupDetail.FormShow(Sender: TObject);
var
  Prop : TProperties;
  AlternativeUM : string;
  valueUM, um, jobqty, stepqty : variant;
  I : Integer;
  SonId : TSchedId;
  dataType  : CBinColValType;
  SplitInfo : TSQSplitInfo;
  TotalAltQty : Double;
  FoundDifUM, FirstJobHasAlternative : boolean;
  QtyInt : integer;
  DecMult : integer;
  planInfo: TSQplanInfo;
begin
  DecMult := Round(IntPower(10, p_sc.GetJobNumOfDecimals(m_grpId)));
  FoundDifUM := false;
  FirstJobHasAlternative := false;
  BtnSplitGroupByAlternativeUM.Visible := false;
  m_AlternativeQty := 0;
  TotalAltQty := 0;
  p_sc.GetSplitInfo(p_sc.GetGrpSon(m_grpId, 0), SplitInfo);

  STQuantityAlt.Visible := true;
  LblQuantityAlt.Visible := true;

  // to know if we have different UM :
  for i := 0 to p_sc.GetGrpNumSons(m_grpId)-1 do
  begin
    SonId := p_sc.GetGrpSon(m_grpId, i);
    p_sc.GetFldValue(SonId, CSC_ProdUM, valueUM, dataType);
    p_sc.GetSplitInfo(SonId, SplitInfo);

    if (I = 0) and (Trim(SplitInfo.AlternativeUM) <> '') then
    begin
      FirstJobHasAlternative := true;
      AlternativeUM := SplitInfo.AlternativeUM;
      m_AlternativeUM := AlternativeUM;
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
    StGrpQty.Caption := '-----'
  else
    BtnSplitGroup.Caption := _('Split') + ' ' + ValueUM;

  if FirstJobHasAlternative then
  begin
    QtyInt := trunc(TotalAltQty * DecMult);
    TotalAltQty := QtyInt/DecMult;
    STQuantityAlt.Caption := FloatToStr(TotalAltQty) + ' ' + AlternativeUM;

    BtnSplitGroupByAlternativeUM.Visible := true;
    BtnSplitGroupByAlternativeUM.Caption := _('Split') + ' ' + AlternativeUM;
    m_AlternativeQty := TotalAltQty;
  end
  else
  begin
    m_schedListView.ColWidths[7] := -1;  //hide alt.qty column
    BtnSplitGroupByAlternativeUM.Visible := false;
    STQuantityAlt.Visible := false;
    LblQuantityAlt.Visible := false
  end;

  p_sc.GetPlanInfo(m_grpId, planInfo);

  if not planInfo.SplitAllow then
  begin
    BtnSplitGroup.Visible := false;
    BtnSplitGroupByAlternativeUM.Visible := false;
  end
  else
  begin
    BtnSplitGroup.Visible := true;
    //BtnSplitGroupByAlternativeUM.Visible := true;
  end;

  prop := p_sc.GetProperties(m_grpId, nil);
  m_propComp := TMShowPropList.CreateShowPropList(TBProp, prop, m_grpId, true);
  if not m_IsFromOccMove then
    BtnShowCompClick(Self);

  BringToFront;
end;

//----------------------------------------------------------------------------//

procedure TTGroupDetail.BtnCalcSplitClick(Sender: TObject);
begin
  CalcSplitData;
end;

//----------------------------------------------------------------------------//

procedure TTGroupDetail.BtnChgQtyJobsClick(Sender: TObject);
var
  JobHandle : TFJobHandle;
  id: TSchedId;
begin
  id := m_schedListView.GetSelected;
  if id = CSchedIdNull then exit;
  if p_sc.IsAForcedGroup(id, false) then
  begin
    MessageDlg('Unable to modify a job of a forced group', mtWarning, [mbOK], 0);
  exit;
  end;
  JobHandle := TFJobHandle.CreateJobHandle(Self, id);
  JobHandle.BtnFixQtyClick(self);//  BtnQtyClick(self);
 // JobHandle.Pgrl.ActivePageIndex := 4;
  JobHandle.ShowModal;
  JobHandle.Free
end;

//----------------------------------------------------------------------------//

procedure TTGroupDetail.BtnJobMsgClick(Sender: TObject);
var
  id: TSchedId;
begin
  id := m_schedListView.GetSelected;
  if id = CSchedIdNull then exit;
  CreateMsgJobForm(id);
  m_schedListView.Refresh;
end;

//----------------------------------------------------------------------------//

procedure TTGroupDetail.BtnShowRequiremantsClick(Sender: TObject);
var
  id: TSchedId;
begin
  id := m_schedListView.GetSelected;
  if id = CSchedIdNull then exit;
  fbin.ShowRequiermants(id);
end;

//----------------------------------------------------------------------------//

procedure TTGroupDetail.BtnSplitClick(Sender: TObject);
var
  GrpSplit : TGrpSplit;
begin
  GrpSplit := TGrpSplit.CreateGrpSplit(self, m_SplitGroupData);
  if GrpSplit.GetmsgError <> '' then
  begin
    EdtSplitError.Text := GrpSplit.GetmsgError;
    GrpSplit.Free;
    exit
  end;

  m_SplitWasClicked := true;

  if GrpSplit.ShowModal = mrOk then
  begin
    p_sc.SetPropListFlag(m_grpId, true, false);
    m_schedListView.RefreshList;
    m_schedListView.Refresh;
    SplitTypeChanged;
  end;
end;

//----------------------------------------------------------------------------//

procedure TTGroupDetail.BtnSplitGroupClick(Sender: TObject);
var
  MainTop : Integer;
  valueUM : variant;
  dataType  : CBinColValType;
begin
  m_splitByAlternativeQty := false;

  if TcxButton(Sender).name = 'BtnSplitGroupByAlternativeUM' then
  begin
    m_splitByAlternativeQty := true;
    STStCurrUmHandled.Caption := m_AlternativeUM;
  end
  else
  begin
    p_sc.GetFldValue(m_grpId, CSC_ProdUM, valueUM, dataType);
    STStCurrUmHandled.Caption := valueUM;
  end;

  PnlSplit.Height := 240;
  Height := 700;
  LblSplitErr.Top := 215;
  SetComponent(EdtQtyToSplit, comp_Edit, true);
  SetComponent(EdtQtyPerJob, comp_Edit, true);
  SetComponent(StCurrGrpQty, comp_Descr, false);
  SetComponent(StNrOfNewGrp, comp_Descr, false);
  SetComponent(StQtyEachGrp, comp_Descr, false);

  BtnSplit.Visible := false;

  SplitTypeChanged;

  SEdtNumOfGroups.Value := 0;
  EdtQtyPerJob.Text  := '0';

  StCurrGrpQty.Caption := EdtQtyToSplit.Text;
  StNrOfNewGrp.Caption := '0';
  StQtyEachGrp.Caption := '0';
  EdtSplitError.Text := '';

  ReShapeSingle(Self);


end;

//----------------------------------------------------------------------------//

initialization

  TGroupDetail := nil

//----------------------------------------------------------------------------//

end.
