unit FMOptions;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, UGPropComp, StdCtrls, Buttons, ComCtrls, gnugettext, Spin, Grids, UMViewTbs,
  Menus, UReShape,UMCompat, ExSpinEdit, UMSchedContFunc, Vcl.CheckLst;

type

  TFOptions = class(TForm)
    PanBtn: TPanel;
    PGCconfig: TPageControl;
    TBSBinProp: TTabSheet;
    TBSresFilter: TTabSheet;
    ChkSort: TCheckBox;
    GPBfilter: TGroupBox;
    ChkFilterRead: TCheckBox;
    ChkWorkcenter: TCheckBox;
    ChkNoTimings: TCheckBox;
    ChkNoCompat: TCheckBox;
    ChkKeepSort: TCheckBox;
    TbsPref: TTabSheet;
    ChkBxSequece: TCheckBox;
    RGFixTemp: TRadioGroup;
    ChkCenterStartOnMove: TCheckBox;
    ChkWarnOnMoveFinal: TCheckBox;
    ChkBxShowInBinOnMove: TCheckBox;
    TbsInfo: TTabSheet;
    GroupBox1: TGroupBox;
    ChkBCompat: TCheckBox;
    ChKBLowDate: TCheckBox;
    ChkBHighDate: TCheckBox;
    ChKBOverlaps: TCheckBox;
    ChkBMaterialDate: TCheckBox;
    ChkBDeliveryDate: TCheckBox;
    ChkBStatus: TCheckBox;
    ChkBDatesWarn: TCheckBox;
    GBErrors: TGroupBox;
    ChkBDelDateW: TCheckBox;
    ChkBMaterialsW: TCheckBox;
    ChkBPrevStepQtyW: TCheckBox;
    ChkBLowestStartW: TCheckBox;
    ChkBOvlpW: TCheckBox;
    ChkBAddResW: TCheckBox;
    ChkBHighEndW: TCheckBox;
    SpinEdit1: TexSpinEdit;
    Label1: TLabel;
    CBShowBinToolBar: TCheckBox;
    RGBinHandling: TRadioGroup;
    ChkBxRefreshBinButton: TCheckBox;
    CheckBJobMsg: TCheckBox;
    CBJobMoveWithoutConfirmation: TCheckBox;
    RadioGroupReportFormat: TRadioGroup;
    RGCalDayFormat: TRadioGroup;
    PageControlProperty: TPageControl;
    TsViewProperty: TTabSheet;
    TsPropertyAsDate: TTabSheet;
    GroupBox2: TGroupBox;
    RadioGroupRoundingCriteria: TRadioGroup;
    RGpSplitOnPreDefineTime: TRadioGroup;
    Lbl2PreDefinedTime: TLabel;
    TSAssignedProperty: TTabSheet;
    CBRound: TComboBox;
    LabelRoundDec: TLabel;
    DateTimePickerTime: TDateTimePicker;
    TabSheetPopupItems: TTabSheet;
    GroupBox3: TGroupBox;
    LblNewSetName: TLabel;
    EditNewSetName: TEdit;
    GroupBox4: TGroupBox;
    LBListOfSets: TListBox;
    TsPropertyAsRGB: TTabSheet;
    CBxShowBinPropColors: TCheckBox;
    TSHighestEndOverride: TTabSheet;
    LblCalculatedHighestEnd: TLabel;
    CBCalculatedHighestEnd: TComboBox;
    GBSetjobslimitdates: TGroupBox;
    LblCapacity: TLabel;
    LblSecureNumberDays: TLabel;
    EdtCapacity: TEdit;
    EdtScureNumberOfDays: TEdit;
    Label2: TLabel;
    GrpBoxMultiLineTabs: TGroupBox;
    CBGantt: TCheckBox;
    CBbin: TCheckBox;
    GBAssignedLimitGrpByCount1: TGroupBox;
    LblAssignedLimitCount1: TLabel;
    LblPropertyForValueCompare1: TLabel;
    CBAssignedLimitCount1: TComboBox;
    CBAssignedForValueCompareGrpLimit1: TComboBox;
    GBAssignedLimitGrpByCount2: TGroupBox;
    LblAssignedLimitCount2: TLabel;
    LblPropertyForValueCompare2: TLabel;
    CBAssignedLimitCount2: TComboBox;
    CBAssignedForValueCompareGrpLimit2: TComboBox;
    LblPropAsApprovalDate: TLabel;
    CBApprovalDateProp: TComboBox;
    CBAssignedBooleanProp1: TComboBox;
    LblAssignedBooleanProp1: TLabel;
    CBWhenMoveShowErrorIfExists: TCheckBox;
    CBDoNotAllowOverLapOnManual: TCheckBox;
    TabSheetMailInfo: TTabSheet;
    GrBMailConfig: TGroupBox;
    LblSMTPServer: TLabel;
    LblPort: TLabel;
    EditSmtpServer: TEdit;
    EditPort: TEdit;
    CBLoginSecureAutenthication: TCheckBox;
    CB_TLS_SSL_Enabled: TCheckBox;
    GroupBox5: TGroupBox;
    Label3: TLabel;
    EditMailSet: TEdit;
    GroupBox6: TGroupBox;
    ListBoxCodeMail: TListBox;
    PageControlMailList: TPageControl;
    RGUnscheduleClosedJobs: TRadioGroup;
    ShowJobQtyOnStatusBar: TLabel;
    CBNumOfDecimalForJobQtyOnStatusBar: TComboBox;
    BtnOk: TcxButton;
    BtnAbort: TcxButton;
    BtnAssignedLimitCount1: TcxButton;
    BtnAssignedForValueCompareGrpLimit1: TcxButton;
    BtnAssignedLimitCount2: TcxButton;
    BtnAssignedForValueCompareGrpLimit2: TcxButton;
    ButtonApprovalDateProp: TcxButton;
    ButtonCBAssignedBooleanProp1: TcxButton;
    BtnCalculatedHighestEnd: TcxButton;
    BitDeleteSet: TcxButton;
    BitOpenSet: TcxButton;
    BtnSaveNewSet: TcxButton;
    BitBtnDltMAilSet: TcxButton;
    BitBtOpenSetMail: TcxButton;
    NewSetMailList: TcxButton;
    ButtonCheckMail: TcxButton;
    GroupBox7: TGroupBox;
    rbQty: TRadioButton;
    rbPerc: TRadioButton;
    Label4: TLabel;
    cbQtyMultiProp: TComboBox;
    EditPropCustomSymbol: TEdit;
    LabelPropCustomeSymbol: TLabel;
    TabSheetCompetibleInBinFunction: TTabSheet;
    GBBinCompatible: TGroupBox;
    RGCreateBewBinTabForCompatibles: TRadioGroup;
    RGShowCompatibleInExistingBINS: TRadioGroup;
    Label5: TLabel;
    MiJobSequenceTabNameSuggested: TEdit;
    RGWhowScheduledOfSelectedResource: TRadioGroup;
    Panel3: TPanel;
    clbRes: TCheckListBox;
    Panel4: TPanel;
    Panel5: TPanel;
    clbActArea: TCheckListBox;
    Panel6: TPanel;
    Panel7: TPanel;
    clbJob: TCheckListBox;
    Panel8: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    clbBin: TCheckListBox;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    Splitter4: TSplitter;
    Panel11: TPanel;
    rgFontSize: TRadioGroup;
    CBWarningWhenResCompChange: TCheckBox;
    cbCapRes: TCheckBox;
    procedure BtnOkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CBShowBinToolBarClick(Sender: TObject);
    procedure RGBinHandlingClick(Sender: TObject);
    procedure ButtonApprovalDatePropClick(Sender: TObject);
    procedure BtnSaveNewSetClick(Sender: TObject);
    procedure BitOpenSetClick(Sender: TObject);
    procedure BitDeleteSetClick(Sender: TObject);
    procedure BtnAbortClick(Sender: TObject);
    procedure ButtonCBAssignedBooleanProp1Click(Sender: TObject);
    procedure BtnCalculatedHighestEndClick(Sender: TObject);
    procedure EdtCapacityKeyPress(Sender: TObject; var Key: Char);
    procedure BtnAssignedLimitCountClick(Sender: TObject);
    procedure BtnAssignedForValueCompareGrpLimitClick(Sender: TObject);
    procedure PageControlPropertyChange(Sender: TObject);
    procedure NewSetMailListClick(Sender: TObject);
    procedure BitBtnDltMAilSetClick(Sender: TObject);
    procedure BitBtOpenSetMailClick(Sender: TObject);
    procedure ListBoxCodeMailClick(Sender: TObject);
    procedure ButtonCheckMailClick(Sender: TObject);
    procedure rbQtyClick(Sender: TObject);
    procedure rbPercClick(Sender: TObject);
    procedure clbResClickCheck(Sender: TObject);
    procedure rgFontSizeClick(Sender: TObject);
    procedure GroupBox1Click(Sender: TObject);
  private
    m_PropComp : TPropComponent;
    m_PropAsDate : TPropComponent;
    m_PropAsRGB : TPropComponent;
    m_ListProp_start : TStringList;
    m_ConfLevelsDft : integer;
    m_MCMCustomPropOrig : string;
    m_PopupChanged : Boolean;
    tmpsize : integer;
    procedure InitProp;
    procedure SetProperties;
    procedure IniMailInfoToDB;
    procedure SetMailInfoToDB;
    function  AddTabSheetToControlMailList(SetName : string) : TMViewTabSheet;
    function  GetMailGroupList : TStringList;
    procedure RestPropRec;
    function  CheckAssignedProperty : boolean;
    procedure UpdatePopupLists;
  public
    constructor Create(AOwner: TComponent); override;
    procedure   ChgSortStatus(Sender: TObject);
    function    IsCustomPropChanged : boolean;
    Procedure   GetPopupList;

  end;

implementation

{$R *.DFM}

uses
  DMsrvPc,
  UMglobal,
  FMbin,
  UMTblDesc,
  UMObjCont,
  FmAutoRunDefinition,
  FmAutoRunSet,
  UMCommon,
  UGGlobal, FMMainPlan;
 // FMCustomSlotDisplay;

// -------------------------------------------------------------------------- //

procedure TFOptions.UpdatePopupLists;
var
  qry : TmqmQuery;
  tbInfo:       PTblInfo;
  i : Integer;
  sl : TStringList;
  visible, grpName : string;

begin
  Qry := CreateQuery(Cfg_DB);
  tbInfo := @tblInfo[tbl_CustomMenu];

  //res
  FMQMPlan.GetResPopupList.Clear;
  for I := 0 to clbRes.items.count - 1 do
  begin
    if clbRes.State[i] = cbChecked then
    begin
      visible := '1';
      FMQMPlan.GetResPopupList.Add((clbRes.Items.Objects[i] as TMenuItem).Name);
    end else
      visible := '0';

    qry.ExecSQL('Update ' + tbInfo.GetTableName + ' set CM_VISIBLE = ' + QuotedStr(visible)
      + ' where CM_MENUCODE = ' + QuotedStr('Resource')
      + ' and CM_MENUCAPTION = ' + QuotedStr((clbRes.Items.Objects[i] as TMenuItem).Name) + ' and CM_IDENTIFIER = ' + IniAppGlobals.Identifier
      + ' and CM_WKST_CODE = ' + QuotedStr(IniAppGlobals.WkstCode));
  end;

  //act area
  FMQMPlan.GetActAreaPopupList.Clear;
  for I := 0 to clbActArea.items.count - 1 do
  begin
    if clbActArea.State[i] = cbChecked then
    begin
      visible := '1';
      FMQMPlan.GetActAreaPopupList.Add((clbActArea.Items.Objects[i] as TMenuItem).Name);
    end else
      visible := '0';

    qry.ExecSQL('Update ' + tbInfo.GetTableName + ' set CM_VISIBLE = ' + QuotedStr(visible)
      + ' where CM_MENUCODE = ' + QuotedStr('ActArea')
      + ' and CM_MENUCAPTION = ' + QuotedStr((clbActArea.Items.Objects[i] as TMenuItem).Name) + ' and CM_IDENTIFIER = ' + IniAppGlobals.Identifier
      + ' and CM_WKST_CODE = ' + QuotedStr(IniAppGlobals.WkstCode));
  end;

  //group
 { FMQMPlan.GetGroupPopupList.Clear;
  for I := 0 to clbGroup.items.count - 1 do
  begin
    if clbGroup.State[i] = cbChecked then
    begin
      visible := '1';
      FMQMPlan.GetGroupPopupList.Add((clbGroup.Items.Objects[i] as TMenuItem).Name);
    end else
      visible := '0';

    qry.ExecSQL('Update ' + tbInfo.GetTableName + ' set CM_VISIBLE = ' + QuotedStr(visible)
      + ' where CM_MENUCODE = ' + QuotedStr('Group')
      + ' and CM_MENUCAPTION = ' + QuotedStr((clbGroup.Items.Objects[i] as TMenuItem).Name) + ' and CM_IDENTIFIER = ' + IniAppGlobals.Identifier
      + ' and CM_WKST_CODE = ' + QuotedStr(IniAppGlobals.WkstCode));
  end;  }

  //job
  FMQMPlan.GetJobPopupList.Clear;
  FMQMPlan.GetGroupPopupList.Clear;
  for I := 0 to clbJob.items.count - 1 do
  begin
    if clbJob.State[i] = cbChecked then
    begin
      visible := '1';
      FMQMPlan.GetJobPopupList.Add((clbJob.Items.Objects[i] as TMenuItem).Name);
    end else
      visible := '0';

    qry.ExecSQL('Update ' + tbInfo.GetTableName + ' set CM_VISIBLE = ' + QuotedStr(visible)
      + ' where CM_MENUCODE = ' + QuotedStr('Job')
      + ' and CM_MENUCAPTION = ' + QuotedStr((clbJob.Items.Objects[i] as TMenuItem).Name) + ' and CM_IDENTIFIER = ' + IniAppGlobals.Identifier
      + ' and CM_WKST_CODE = ' + QuotedStr(IniAppGlobals.WkstCode));


    //group
    if (clbJob.Items.Objects[i] as TMenuItem).Name = 'MISetNextLevel' then  //Set next confirmation level
      grpName := 'MISetNextLevelGrp'
    else if (clbJob.Items.Objects[i] as TMenuItem).Name = 'MISetIniFin' then //Set to initial
      grpName := 'MISetIniFinGrp'
    else if (clbJob.Items.Objects[i] as TMenuItem).Name = 'MISetLevelTo' then //Set confirmation level to...
      grpName := 'MISetLevelToGrp'
    else if (clbJob.Items.Objects[i] as TMenuItem).Name = 'MIUnschedule' then  //Unschedule
      grpName := 'MIgrpToBin'
    else if (clbJob.Items.Objects[i] as TMenuItem).Name = 'MiSplitRemainJob' then  //Unschedule remaining quantity
      grpName := 'MiSplitRemainGroup'
    else if (clbJob.Items.Objects[i] as TMenuItem).Name = 'MiSpeedChange' then //Modify execution
      grpName := 'MiSeedGrpChange'
    else if (clbJob.Items.Objects[i] as TMenuItem).Name = 'MiLearningCurveChange' then //Curve change
      grpName := 'MiLearningCurveGrpChange'
    else if (clbJob.Items.Objects[i] as TMenuItem).Name = 'MiSplitHere' then  //Split from this point
      grpName := 'MISplitGroup'
    else if (clbJob.Items.Objects[i] as TMenuItem).Name = 'MIGrpDetails' then  //Group handling
      grpName := 'MIGrpDetails'
    else if (clbJob.Items.Objects[i] as TMenuItem).Name = 'MIIgnoreHaltedGroup' then  //Group handling
      grpName := 'MIIgnoreHaltedGroup'

    else
      grpName := '';

    if grpName <> '' then
    begin
      if visible = '1' then
        FMQMPlan.GetGroupPopupList.Add(grpName);

      qry.ExecSQL('Update ' + tbInfo.GetTableName + ' set CM_VISIBLE = ' + QuotedStr(visible)
        + ' where CM_MENUCODE = ' + QuotedStr('Group')
        + ' and CM_MENUCAPTION = ' + QuotedStr(grpName) + ' and CM_IDENTIFIER = ' + IniAppGlobals.Identifier
        + ' and CM_WKST_CODE = ' + QuotedStr(IniAppGlobals.WkstCode));
    end;

  end;

  //Bin
  FBin.GetBinPopupList.Clear;
  for I := 0 to clbBin.items.count - 1 do
  begin
    if clbBin.State[i] = cbChecked then
    begin
      visible := '1';
      FBin.GetBinPopupList.Add((clbBin.Items.Objects[i] as TMenuItem).Name);
    end else
      visible := '0';

    qry.ExecSQL('Update ' + tbInfo.GetTableName + ' set CM_VISIBLE = ' + QuotedStr(visible)
      + ' where CM_MENUCODE = ' + QuotedStr('Bin')
      + ' and CM_MENUCAPTION = ' + QuotedStr((clbBin.Items.Objects[i] as TMenuItem).Name) + ' and CM_IDENTIFIER = ' + IniAppGlobals.Identifier
      + ' and CM_WKST_CODE = ' + QuotedStr(IniAppGlobals.WkstCode));
  end;

  qry.Close;
  qry.Free;

end;

// -------------------------------------------------------------------------- //

Procedure TFOptions.GetPopupList;
var I, y : Integer;
    mi : TMenuItem;
begin
  if not Assigned(Fbin) then
  begin
    TabSheetPopupItems.Visible := false;
    Exit;
  end;
  clbRes.Clear;
  clbActArea.Clear;
  clbJob.Clear;
  m_PopupChanged := False;

  for I := 0 to FMQMPlan.PopRes.Items.Count - 1 do
  begin
     mi := FMQMPlan.PopRes.Items[i];
     if mi.Caption = '-' then continue;
     clbRes.AddItem(_(mi.Caption), mi);
  end;

  for I := 0 to FMQMPlan.PupActArea.Items.Count - 1 do
  begin
     mi := FMQMPlan.PupActArea.Items[i];
     if mi.Caption = '-' then continue;
     clbActArea.AddItem(_(mi.Caption), mi);
  end;

  for I := 0 to FMQMPlan.PupJob.Items.Count - 1 do
  begin
     mi := FMQMPlan.PupJob.Items[i];
     if mi.Caption = '-' then continue;
     if mi.Name = 'MISetNextLevel' then
        mi.Caption := _('Set next confirmation level');
     clbJob.AddItem(_(mi.Caption), mi);
  end;

  for I := 0 to FMQMPlan.PupGroup.Items.Count - 1 do
  begin
     mi := FMQMPlan.PupGroup.Items[i];
     if mi.Caption = '-' then continue;

     if mi.Name = 'MIGrpDetails' then continue;

     if mi.Name = 'MIIgnoreHaltedGroup' then
        clbJob.AddItem(_(mi.Caption) + ' ' + _('group') , mi)
     else
       clbJob.AddItem(_(mi.Caption), mi);
  end;

  for I := 0 to FBin.PopUpBin.Items.Count - 1 do
  begin
     mi := FBin.PopUpBin.Items[i];
     if mi.Caption = '-' then continue;

     if mi.Name = 'MiRepositionJobsToRealMachines' then continue; // mcm

     if mi.Name = 'MINextLevel' then
        mi.Caption := _('Set to next confermation level');

     if mi.Name = 'MIWCenterHandle' then
        mi.Caption := _('Change plan work center ');

     clbBin.AddItem(_(mi.Caption), mi);
  end;

  //Res
  for I := 0 to clbRes.Items.count - 1 do
  begin
    if FMQMPlan.GetResPopupList.IndexOf(TMenuItem(clbRes.items.Objects[I]).name) > -1  then
      clbRes.State[I] := cbChecked
  end;

  //act area
  for I := 0 to clbActArea.Items.count - 1 do
  begin
    if FMQMPlan.GetActAreaPopupList.IndexOf(TMenuItem(clbActArea.items.Objects[I]).name) > -1  then
      clbActArea.State[I] := cbChecked
  end;

   //Job
  for I := 0 to clbJob.Items.count - 1 do
  begin
    if FMQMPlan.GetJobPopupList.IndexOf(TMenuItem(clbJob.items.Objects[I]).name) > -1  then
      clbJob.State[I] := cbChecked;

    //group
    //if FMQMPlan.GetJobPopupList.Count >= i then // avi 27/06/2024
   // begin
      if FMQMPlan.GetGroupPopupList.IndexOf(TMenuItem(clbJob.items.Objects[I]).name) > -1  then
        clbJob.State[i] := cbChecked
   // end;
  end;

  //Group
 { for I := 0  to clbGroup.Items.count - 1 do
  begin
    if FMQMPlan.GetGroupPopupList.IndexOf(TMenuItem(clbJob.items.Objects[clbJob.items.count -1 + I]).name) > -1  then
      clbJob.State[clbJob.items.count -1 + i] := cbChecked
  end;   }

   //Bin
  for I := 0 to clbBin.Items.count - 1 do
  begin
    if FBin.GetBinPopupList.IndexOf(TMenuItem(clbBin.items.Objects[I]).name) > -1  then
      clbBin.State[I] := cbChecked
  end;
end;

procedure TFOptions.GroupBox1Click(Sender: TObject);
begin

end;

// -------------------------------------------------------------------------- //

constructor TFOptions.Create(AOwner: TComponent);
var pos,i, index : Integer;
    PId : TPropID;
begin
  inherited Create(Aowner);
  m_ConfLevelsDft := DBAppGlobals.ConfLevels;
  m_ListProp_start := TStringList.Create;
  m_PropComp := TPropComponent.CreatePropComp(TsViewProperty,SelectedProp,nil,-1, nil, nil);
  m_PropAsDate := TPropComponent.CreatePropComp(TsPropertyAsDate,PropAsDate,nil,-1, nil, nil);
  m_PropAsRGB := TPropComponent.CreatePropComp(TsPropertyAsRGB,PropAsRGB,nil,-1, nil, nil);

  cbQtyMultiProp.Clear;
  cbQtyMultiProp.AddItem('',cbQtyMultiProp);
  cbQtyMultiProp.ItemIndex := 0;

  for Index := 0 to GetPropertyCount - 1 do
  begin
    pId := GetPropFromPos(Index);
    if not IsPropNumeric(pId) then continue;
    Pos := cbQtyMultiProp.Items.Add(GetPropCodeFromID(pId));
    cbQtyMultiProp.Items.Objects[pos] := pId;
  end;

  PId := GetIdFromCode(DBAppGlobals.MCMCustomProp);
  if (PId <> nil) then
  begin
    for I := 0 to cbQtyMultiProp.Items.Count - 1 do
    begin
      if PId = cbQtyMultiProp.Items.Objects[I] then
      begin
        cbQtyMultiProp.ItemIndex := I;
        Break
      end;
    end;
  end;

  m_MCMCustomPropOrig := DBAppGlobals.MCMCustomProp;

  EditPropCustomSymbol.Text := DBAppGlobals.MCMCustomPropSymbol;

  with DBAppGlobals do
  begin
    if MCMSlotDisplay = 0 then
      rbPerc.Checked := True
    else
      rbQty.Checked := True;

    if SpinEdit1.Value <> ConfLevels then
      SpinEdit1.Value := ConfLevels
    else
      SpinEdit1Change(self);

    ChkBxSequece.Checked  := CheckStepSeq;
    RGUnscheduleClosedJobs.ItemIndex := StrToInt(UnscheduleJobsOnStart);
    ChkCenterStartOnMove.Checked := CenterStartOnMove;
    ChkWarnOnMoveFinal.Checked := WarnOnMoveFinal;
    CBWhenMoveShowErrorIfExists.Checked := WhenMoveShowErrorsIfExist;
  end;

  with IniAppGlobals do
  begin
    EditSmtpServer.Text := SMTP_server;
    EditPort.Text       := port;
    if (LOGINWithAUTHENTICATION = '1') or (LOGINWithAUTHENTICATION = '') then
      CBLoginSecureAutenthication.Checked := true
    else
      CBLoginSecureAutenthication.Checked := false;

    if (TLS_SSL = '1') or (TLS_SSL = '') then
      CB_TLS_SSL_Enabled.Checked := true
    else
      CB_TLS_SSL_Enabled.Checked := false;
  end;

  with DBAppSettings do
  begin
    ChkBCompat.Checked    := FixColCompVis;
    ChKBLowDate.Checked   := FixColLowDVis;
    ChkBHighDate.Checked  := FixColHigDVis;
    ChKBOverlaps.Checked  := FixColOvlpVis;
    ChkBMaterialDate.Checked := FixColMatDVis;
    ChkBDeliveryDate.Checked := FixColDelDVis;
    ChkBDatesWarn.Checked := FixColDatesVis;
    ChkBStatus.Checked    := FixColStatVis;
    CheckBJobMsg.Checked  := FixColJobMsgVis;

    ChkBDelDateW.Checked     := ChkDelDate;
    ChkBMaterialsW.Checked   := ChkMaterials;
    ChkBAddResW.Checked      := ChkAddRes;
    ChkBPrevStepQtyW.Checked := ChkPrevStpQty;
    ChkBLowestStartW.Checked := ChkLowStart;
    ChkBHighEndW.Checked     := ChkHighEnd;
    ChkBOvlpW.Checked        := ChkLinkOvlp;

    ChkBxShowInBinOnMove.Checked         := ShowInBinOnMove;
    ChkBxRefreshBinButton.Checked        := RefreshBinByButton;
    CBJobMoveWithoutConfirmation.Checked := JobMoveWitoutConfirmation;
    CBWarningWhenResCompChange.Checked := WarningWhenMaxNumCompChanged;

    cbCapRes.Checked := CapResStartEnd;

    if ReportTimeFormat = '0' then
      RadioGroupReportFormat.ItemIndex := 0
    else
      RadioGroupReportFormat.ItemIndex := 1;

    if CalDayFormat = '0' then
      RGCalDayFormat.ItemIndex := 0
    else if CalDayFormat = '1' then
      RGCalDayFormat.ItemIndex := 1
    else if CalDayFormat = '2' then
      RGCalDayFormat.ItemIndex := 2
    else if CalDayFormat = '3' then
      RGCalDayFormat.ItemIndex := 3;

{    if ForceOverlap = FOL_No then
      RadioGroupForceOverlap.ItemIndex := 0
    else if ForceOverlap = FOL_Yes then
      RadioGroupForceOverlap.ItemIndex := 1
    else if ForceOverlap = FOL_Forceable then
      RadioGroupForceOverlap.ItemIndex := 2;  }

    if ForceOverlap = FOL_No then
      CBDoNotAllowOverLapOnManual.Checked := false
    else if ForceOverlap = FOL_Yes then
      CBDoNotAllowOverLapOnManual.Checked := true;

    CBShowBinToolBar.Checked       :=  ShowBinToolBar;
    if  ShowRowInBin then
      RGBinHandling.ItemIndex      :=  1
    else
      RGBinHandling.ItemIndex      :=  0;

    ChkSort.Checked       := TabResSort;
    ChkKeepSort.Checked   := TabKeepSort;
    ChkFilterRead.Checked := TabFilterRead;
    ChkWorkcenter.Checked := TabWorkcenter;
    ChkNoTimings.Checked  := TabNoTimings;
    ChkNoCompat.Checked   := TabNoCompat;

    if ShowBinPropColors then
      CBxShowBinPropColors.Checked := true
    else
      CBxShowBinPropColors.Checked := false;

    if not TabResSort then
      ChkKeepSort.Visible := false;

    if DBAppGlobals.MCM_App then
      TabSheetPopupItems.TabVisible := false;

    if GanttMultiLineTab then
      CBGantt.Checked := true
    else
      CBGantt.Checked := false;

    if BinMultiLineTab then
      CBBin.Checked := true
    else
      CBBin.Checked := false;

    if CreateNewBinTabForCompatibles = NewB_No then
      RGCreateBewBinTabForCompatibles.ItemIndex := 0
    else if CreateNewBinTabForCompatibles = NewB_Yes_OnlyCompatibleAndToSchedJobs then
      RGCreateBewBinTabForCompatibles.ItemIndex := 1
    else if CreateNewBinTabForCompatibles = NewB_Yes_MarkCompatibleAndToSchedJobs then
      RGCreateBewBinTabForCompatibles.ItemIndex := 2
    else if CreateNewBinTabForCompatibles = NewB_Yes_ShowOnlyCompatibles then
      RGCreateBewBinTabForCompatibles.ItemIndex := 3;

    if ShowCompatibleInExistingBINS = ShowC_No then
      RGShowCompatibleInExistingBINS.ItemIndex := 0
    else if ShowCompatibleInExistingBINS = ShowC_Yes_MarkTheCompatibles then
      RGShowCompatibleInExistingBINS.ItemIndex := 1
    else if ShowCompatibleInExistingBINS = ShowC_Yes_ShowOnlyCompatibles then
      RGShowCompatibleInExistingBINS.ItemIndex := 2;

    if ShowScheduledJobsOfSelectedResource = ShowS_No then
      RGWhowScheduledOfSelectedResource.ItemIndex := 0
    else if ShowScheduledJobsOfSelectedResource = ShowS_Yes then
      RGWhowScheduledOfSelectedResource.ItemIndex := 1;

    MiJobSequenceTabNameSuggested.Text := DBAppSettings.SuggestedTextTabJobSequence;

  end;

  rgFontSize.ItemIndex := iniAppGlobals.FontSize;
  tmpsize := IniAppGlobals.FontSize;

  CBRound.ItemIndex := 2;
  if iniAppGlobals.SplitFromPointNumOfDec <> '' then
  begin
    if iniAppGlobals.SplitFromPointNumOfDec = '0' then
      CBRound.ItemIndex := 0
    else if iniAppGlobals.SplitFromPointNumOfDec = '1' then
      CBRound.ItemIndex := 1
    else if iniAppGlobals.SplitFromPointNumOfDec = '2' then
      CBRound.ItemIndex := 2
  end;

  CBNumOfDecimalForJobQtyOnStatusBar.ItemIndex := 2;
  if iniAppGlobals.NumOfDecJobQtyOnStatusBar <> '' then
  begin
    if iniAppGlobals.NumOfDecJobQtyOnStatusBar = '0' then
      CBNumOfDecimalForJobQtyOnStatusBar.ItemIndex := 0
    else if iniAppGlobals.NumOfDecJobQtyOnStatusBar = '1' then
      CBNumOfDecimalForJobQtyOnStatusBar.ItemIndex := 1
    else if iniAppGlobals.NumOfDecJobQtyOnStatusBar = '2' then
      CBNumOfDecimalForJobQtyOnStatusBar.ItemIndex := 2
  end;

  RadioGroupRoundingCriteria.ItemIndex := 0;
  if iniAppGlobals.SplitFromPointRoundCrit <> '' then
  begin
    if iniAppGlobals.SplitFromPointRoundCrit = '0' then
      RadioGroupRoundingCriteria.ItemIndex := 0
    else if iniAppGlobals.SplitFromPointRoundCrit = '1' then
      RadioGroupRoundingCriteria.ItemIndex := 1
  end;

  RGpSplitOnPreDefineTime.ItemIndex := 0;
  if iniAppGlobals.SplitFromPointOnPreDefTime <> '' then
  begin
    if iniAppGlobals.SplitFromPointOnPreDefTime = '0' then
      RGpSplitOnPreDefineTime.ItemIndex := 0
    else if iniAppGlobals.SplitFromPointOnPreDefTime = '1' then
      RGpSplitOnPreDefineTime.ItemIndex := 1
    else if iniAppGlobals.SplitFromPointOnPreDefTime = '2' then
      RGpSplitOnPreDefineTime.ItemIndex := 2
  end;

  DateTimePickerTime.DateTime := date;

  if iniAppGlobals.SplitFromPointPreDefTime <> '' then
  begin
    try
      DateTimePickerTime.Time := StrToFloat(iniAppGlobals.SplitFromPointPreDefTime);
    Except
    end;
  end;

  if IniAppGlobals.SetLimiDateUsingCapacity <> '' then
  begin
    try
      EdtCapacity.Text := IniAppGlobals.SetLimiDateUsingCapacity;
    except
    end;
  end;

  if IniAppGlobals.SetLimiDateUsingSecureNumDays <> '' then
  begin
    try
      EdtScureNumberOfDays.Text := IniAppGlobals.SetLimiDateUsingSecureNumDays;
    except
    end;
  end;

  ChkSort.OnClick := ChgSortStatus;
  PGCconfig.ActivePage := TbsPref;
end;

// -------------------------------------------------------------------------- //

procedure TFOptions.EdtCapacityKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not ((CharInSet(Key, ['0'..'9'])) or (key = chr(vk_Back)) or (key = chr(VK_DELETE)) or (Key = chr(24)) or (Key = ',') or (Key = '%')) then
      abort;
end;

// -------------------------------------------------------------------------- //

procedure TFOptions.RestPropRec;
var
  I : Integer;
begin
  for I := Low(DBAppGlobals.ShowBinPropArry) to high(DBAppGlobals.ShowBinPropArry) do
    DBAppGlobals.ShowBinPropArry[I] := nil;
end;

// -------------------------------------------------------------------------- //

procedure TFOptions.InitProp;
var
  I,J : Integer;
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
  First : boolean;
  PropId : TPropId;
  Index : Integer;
begin
  for I := Low(DBAppGlobals.ShowBinPropArry) to high(DBAppGlobals.ShowBinPropArry) do
  begin
    if DBAppGlobals.ShowBinPropArry[I] = nil then break;

    if I = 0 then
      m_PropComp.SetPropVal(GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]),I + 1,true)
    else
      m_PropComp.SetPropVal(GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]),I + 1,false);
    m_ListProp_start.Add(GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]));
  end;

  qry := CreateQuery(Main_DB);
  tbInfo := @tblInfo[tbl_PropAsDate];

  qry.SQL.Clear;
  qry.SQL.Add('select * from ' + tbInfo.GetTableName );
  qry.SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.Open;

  First := true;
  I := 0;
  while not qry.Eof do
  begin
    if First then
    begin
      m_PropAsDate.SetPropVal(trim(qry.FieldByName(CreateFld(tbInfo.pfx, fli_PropertyCode)).AsString),I + 1,true);
      First := false
    end
    else
      m_PropAsDate.SetPropVal(trim(qry.FieldByName(CreateFld(tbInfo.pfx, fli_PropertyCode)).AsString),I + 1,false);
    qry.Next;
    Inc(I);
  end;

  qry.close;

  tbInfo := @tblInfo[tbl_PropAsRGB];

  qry.SQL.Clear;
  qry.SQL.Add('select * from ' + tbInfo.GetTableName );
  qry.SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.Open;

  First := true;
  I := 0;
  while not qry.Eof do
  begin
    if First then
    begin
      m_PropAsRGB.SetPropVal(trim(qry.FieldByName(CreateFld(tbInfo.pfx, fli_PropertyCode)).AsString),I + 1,true);
      First := false
    end
    else
      m_PropAsRGB.SetPropVal(trim(qry.FieldByName(CreateFld(tbInfo.pfx, fli_PropertyCode)).AsString),I + 1,false);
    qry.Next;
    Inc(I);
  end;

  Qry.Close;

  for I := 0 to GetPropertyCount - 1 do
  begin
    PropId := GetPropFromPos(I);

    if IsPropAlpha(PropId) then
    begin
      CBAssignedForValueCompareGrpLimit1.Items.Add(GetPropCodeFromID(PropId));
      CBAssignedForValueCompareGrpLimit2.Items.Add(GetPropCodeFromID(PropId))
    end
    else
    begin
      CBAssignedLimitCount1.Items.Add(GetPropCodeFromID(PropId));
      CBAssignedLimitCount2.Items.Add(GetPropCodeFromID(PropId));
    end;

    if IsPropPlanner(PropId) then
    begin
      for J := 1 to m_PropAsDate.P_RowCount - 1 do
      begin
        if m_PropAsDate.P_GetPropVal[J] <> '' then
        if m_PropAsDate.P_GetPropVal[J] = GetPropCodeFromID(PropId) then
            CBApprovalDateProp.Items.Add(GetPropCodeFromID(PropId));
      end;
      if IsPropAlpha(PropId) and IsPropPlanner(PropId) then
      begin
         if (GetLength(PropId) = 1) then
           CBAssignedBooleanProp1.Items.Add(GetPropCodeFromID(PropId))
         else if (GetLength(PropId) = 12) then
           CBCalculatedHighestEnd.Items.Add(GetPropCodeFromID(PropId));
      end;
    end;
  end;

  tbInfo := @tblInfo[tbl_PropAssigned];
  qry.SQL.Clear;
  qry.SQL.Add('select * from ' + tbInfo.GetTableName + ' where ');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_AssignedProp) + '=' + QuotedStr('APPROVAL_DATE'));
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.Open;

  if not qry.Eof then
  begin
    Index := CBApprovalDateProp.Items.IndexOf(trim(qry.FieldByName(CreateFld(tbInfo.pfx, fli_PropertyCode)).AsString));
    if Index > -1 then
      CBApprovalDateProp.ItemIndex := Index;
  end;
  qry.Close;
  qry.SQL.Clear;
  qry.SQL.Add('select * from ' + tbInfo.GetTableName + ' where ');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_AssignedProp) + '=' + QuotedStr('ASSIGNED_BOOL1'));
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.Open;

  if not qry.Eof then
  begin
    Index := CBAssignedBooleanProp1.Items.IndexOf(trim(qry.FieldByName(CreateFld(tbInfo.pfx, fli_PropertyCode)).AsString));
    if Index > -1 then
      CBAssignedBooleanProp1.ItemIndex := Index;
  end;

  qry.Close;
  qry.SQL.Clear;
  qry.SQL.Add('select * from ' + tbInfo.GetTableName + ' where ');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_AssignedProp) + '=' + QuotedStr('CALC_HIGH_DATE'));
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.Open;

  if not qry.Eof then
  begin
    Index := CBCalculatedHighestEnd.Items.IndexOf(trim(qry.FieldByName(CreateFld(tbInfo.pfx, fli_PropertyCode)).AsString));
    if Index > -1 then
      CBCalculatedHighestEnd.ItemIndex := Index;
  end;

  qry.SQL.Clear;
  qry.SQL.Add('select * from ' + tbInfo.GetTableName + ' where ');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_AssignedProp) + '=' + QuotedStr('LIMIT_GRP_COUNT'));
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.Open;

  if not qry.Eof then
  begin
    Index := CBAssignedLimitCount1.Items.IndexOf(trim(qry.FieldByName(CreateFld(tbInfo.pfx, fli_PropertyCode)).AsString));
    if Index > -1 then
      CBAssignedLimitCount1.ItemIndex := Index;
  end;

  qry.SQL.Clear;
  qry.SQL.Add('select * from ' + tbInfo.GetTableName + ' where ');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_AssignedProp) + '=' + QuotedStr('GRP_VAL_COMPRE'));
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.Open;

  if not qry.Eof then
  begin
    Index := CBAssignedForValueCompareGrpLimit1.Items.IndexOf(trim(qry.FieldByName(CreateFld(tbInfo.pfx, fli_PropertyCode)).AsString));
    if Index > -1 then
      CBAssignedForValueCompareGrpLimit1.ItemIndex := Index;
  end;

  qry.SQL.Clear;
  qry.SQL.Add('select * from ' + tbInfo.GetTableName + ' where ');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_AssignedProp) + '=' + QuotedStr('LIMIT_GRP_COUNT2'));
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.Open;

  if not qry.Eof then
  begin
    Index := CBAssignedLimitCount2.Items.IndexOf(trim(qry.FieldByName(CreateFld(tbInfo.pfx, fli_PropertyCode)).AsString));
    if Index > -1 then
      CBAssignedLimitCount2.ItemIndex := Index;
  end;

  qry.SQL.Clear;
  qry.SQL.Add('select * from ' + tbInfo.GetTableName + ' where ');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_AssignedProp) + '=' + QuotedStr('GRP_VAL_COMPRE2'));
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.Open;

  if not qry.Eof then
  begin
    Index := CBAssignedForValueCompareGrpLimit2.Items.IndexOf(trim(qry.FieldByName(CreateFld(tbInfo.pfx, fli_PropertyCode)).AsString));
    if Index > -1 then
      CBAssignedForValueCompareGrpLimit2.ItemIndex := Index;
  end;

{  qry.SQL.Clear;
  qry.SQL.Add('select * from ' + tbInfo.GetTableName + ' where ');
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_AssignedProp) + '=' + QuotedStr('MCM_SLOT_PROP'));
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.Open;

  if not qry.Eof then
  begin
    Index := cbQtyMultiProp.Items.IndexOf(trim(qry.FieldByName(CreateFld(tbInfo.pfx, fli_PropertyCode)).AsString));
    if Index > -1 then
      cbQtyMultiProp.ItemIndex := Index;
  end;  }

  qry.Free;
end;

// -------------------------------------------------------------------------- //

procedure TFOptions.ListBoxCodeMailClick(Sender: TObject);
begin
  if ListBoxCodeMail.Count = 0 then exit;
  if PageControlMailList.PageCount = 0 then exit;
  if ListBoxCodeMail.Count <> PageControlMailList.PageCount then exit;

  PageControlMailList.ActivePage := PageControlMailList.Pages[ListBoxCodeMail.ItemIndex];
end;

// -------------------------------------------------------------------------- //

procedure TFOptions.NewSetMailListClick(Sender: TObject);
begin
  if EditMailSet.Text = '' then
    begin
      MessageDlg(_('Please enter a set name.'), mtWarning, [mbOK], 0);
      exit
    end;
  ListBoxCodeMail.Items.Add(EditMailSet.Text); //add set to Sets ComboBox)
  EditMailSet.Text := '';
end;

// -------------------------------------------------------------------------- //

procedure TFOptions.PageControlPropertyChange(Sender: TObject);
var
  I : Integer;
  Propcode : string;
  FoundCode : boolean;
begin
  if PageControlProperty.ActivePage = TSAssignedProperty then
  begin
    if not m_PropAsDate.IsPropEnter then exit;
    Propcode := '';
    if CBApprovalDateProp.ItemIndex > -1 then
        Propcode := CBApprovalDateProp.Items[CBApprovalDateProp.ItemIndex];
    FoundCode := false;
    if Propcode <> '' then
      for I := 1 to m_PropAsDate.P_RowCount - 1 do
      begin
        if m_PropAsDate.P_GetPropVal[I] <> '' then
        begin
          if Propcode = m_PropAsDate.P_GetPropVal[I] then
          begin
            FoundCode := true;
            break;
          end;
        end;
      end;

    if FoundCode then
    begin
      CBApprovalDateProp.Items.Clear;
      for I := 1 to m_PropAsDate.P_RowCount - 1 do
      begin
        if m_PropAsDate.P_GetPropVal[I] <> '' then
        begin

          CBApprovalDateProp.Items.Add(m_PropAsDate.P_GetPropVal[I]);
          if m_PropAsDate.P_GetPropVal[I] = Propcode then
             CBApprovalDateProp.ItemIndex := CBApprovalDateProp.Items.Count - 1;

        end;
      end;
    end
    else
    begin
      CBApprovalDateProp.ItemIndex := -1;
      CBApprovalDateProp.Items.Clear;
      for I := 1 to m_PropAsDate.P_RowCount - 1 do
      begin
        if m_PropAsDate.P_GetPropVal[I] <> '' then
          CBApprovalDateProp.Items.Add(m_PropAsDate.P_GetPropVal[I]);
      end;
    end;
  end;

end;

// -------------------------------------------------------------------------- //

procedure TFOptions.rbPercClick(Sender: TObject);
begin
  label4.Visible := not rbPerc.Checked;
  cbQtyMultiProp.Visible := not rbPerc.Checked;
  LabelPropCustomeSymbol.Visible := not rbPerc.Checked;
  EditPropCustomSymbol.Visible := not rbPerc.Checked;
end;

// -------------------------------------------------------------------------- //

procedure TFOptions.rbQtyClick(Sender: TObject);
begin
  label4.Visible := rbQty.Checked;
  cbQtyMultiProp.Visible := rbQty.Checked;
  LabelPropCustomeSymbol.Visible := rbQty.Checked;
  EditPropCustomSymbol.Visible := rbQty.Checked;
end;

// -------------------------------------------------------------------------- //

procedure TFOptions.SetProperties;
var
  I : Integer;
  qry:    TMqmQuery;
  trs:    TMqmTransaction;
  tbInfo: ^TTblInfo;
  SqlInsert : string;
begin
  if m_PropComp.IsPropEnter then
  begin
    RestPropRec;
    for I := 1 to m_PropComp.P_RowCount - 1 do
    begin
      if m_PropComp.P_GetPropVal[I] <> '' then
        DBAppGlobals.ShowBinPropArry[I - 1] := GetIdFromCode(m_PropComp.P_GetPropVal[I]);
    end;
  end
  else
    for I := Low(DBAppGlobals.ShowBinPropArry) to high(DBAppGlobals.ShowBinPropArry) do
      DBAppGlobals.ShowBinPropArry[I] := nil;

  qry := CreateQuery(Main_DB);
  qry.Transaction := CreateTransaction(Main_DB);
  qry.Transaction.StartTransaction;
  Application.ProcessMessages;
  tbInfo := @tblInfo[tbl_PropAsDate];

  if m_PropAsDate.IsPropEnter then
  begin
    qry.SQL.Clear;
    qry.SQL.Add('delete from ' + tbInfo.GetTableName);
    qry.SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
    qry.ExecSQL;
    Application.ProcessMessages;
  //  qry.Transaction.Commit;
    if GetPropertyCount > 0 then
    CleanAllPropertiesAsDate;

    SqlInsert := 'insert into ' + tbInfo.GetTableName + '(';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_Identifier) + ', ';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_PropertyCode);
    SqlInsert := SqlInsert + ') values (';
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_Identifier) + ', ';
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_PropertyCode);
    SqlInsert := SqlInsert + ')';

    for I := 1 to m_PropAsDate.P_RowCount - 1 do
    begin
      if m_PropAsDate.P_GetPropVal[I] <> '' then
      begin
        qry.SQL.Clear;
        qry.SQL.Text := SqlInsert;
        qry.ParamByName(CreateFld(tbInfo.pfx,fli_Identifier)).AsString   := IniAppGlobals.Identifier;
        qry.ParamByName(CreateFld(tbInfo.pfx,fli_PropertyCode)).AsString := m_PropAsDate.P_GetPropVal[I];
        qry.ExecSQL;
    //    qry.Transaction.Commit;
        SetUserAsDateProp(GetIdFromCode(m_PropAsDate.P_GetPropVal[I]) , true);
      end;
    end;
  end
  else
  begin
    qry.SQL.Clear;
    qry.SQL.Add('delete from ' + tbInfo.GetTableName );
    qry.SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
    qry.ExecSQL;
    Application.ProcessMessages;
   // qry.Transaction.Commit;
  end;

  tbInfo := @tblInfo[tbl_PropAsRGB];
  qry.SQL.Clear;
    qry.SQL.Add('delete from ' + tbInfo.GetTableName );
    qry.SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
    qry.ExecSQL;
    Application.ProcessMessages;
   // qry.Transaction.Commit;
    if GetPropertyCount > 0 then
    CleanAllPropertiesAsRGB;

  if m_PropAsRGB.IsPropEnter then
  begin

    SqlInsert := 'insert into ' + tbInfo.GetTableName + '(';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_Identifier) + ', ';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_PropertyCode);
    SqlInsert := SqlInsert + ') values (';
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_Identifier) + ', ';
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_PropertyCode);
    SqlInsert := SqlInsert + ')';

    for I := 1 to m_PropAsRGB.P_RowCount - 1 do
    begin
      if m_PropAsRGB.P_GetPropVal[I] <> '' then
      begin
        qry.SQL.Clear;
        qry.SQL.Text := SqlInsert;
        qry.ParamByName(CreateFld(tbInfo.pfx,fli_Identifier)).AsString   := IniAppGlobals.Identifier;
        qry.ParamByName(CreateFld(tbInfo.pfx,fli_PropertyCode)).AsString := m_PropAsRGB.P_GetPropVal[I];
        qry.ExecSQL;
        Application.ProcessMessages;
     //   qry.Transaction.Commit;
        SetUserAsRGBProp(GetIdFromCode(m_PropAsRGB.P_GetPropVal[I]) , true);
      end;
    end;
  end;

  tbInfo := @tblInfo[tbl_PropAssigned];

  if CBApprovalDateProp.ItemIndex > -1 then
  begin
    CleanAllApprovalDateProp;

    qry.SQL.Clear;
    qry.SQL.Add('delete from ' + tbInfo.GetTableName );
    qry.SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_AssignedProp) + '=' + QuotedStr('APPROVAL_DATE'));
    qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
    qry.ExecSQL;
    Application.ProcessMessages;
  //  qry.Transaction.Commit;

    SqlInsert := '';
    SqlInsert := 'insert into ' + tbInfo.GetTableName + '(';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_Identifier)   + ', ';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_AssignedProp) + ',';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_PropertyCode);
    SqlInsert := SqlInsert + ') values (';
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_Identifier) + ', ';
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_AssignedProp) + ',' ;
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_PropertyCode);
    SqlInsert := SqlInsert + ')';
    qry.SQL.Clear;
    qry.SQL.Text := SqlInsert;
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_Identifier)).AsString   := IniAppGlobals.Identifier;
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_AssignedProp)).AsString := 'APPROVAL_DATE';
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_PropertyCode)).AsString := CBApprovalDateProp.Items.Strings[CBApprovalDateProp.ItemIndex];
    qry.ExecSQL;
    Application.ProcessMessages;
 //   qry.Transaction.Commit;
    SetApprovalDateProp(GetIdFromCode(CBApprovalDateProp.Items.Strings[CBApprovalDateProp.ItemIndex]), true);
  end;

  if CBAssignedBooleanProp1.ItemIndex > -1 then
  begin
    CleanAllAssignedBooleanProp1;
    qry.SQL.Clear;
    qry.SQL.Add('delete from ' + tbInfo.GetTableName );
    qry.SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_AssignedProp) + '=' + QuotedStr('ASSIGNED_BOOL1'));
    qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
    qry.ExecSQL;
    Application.ProcessMessages;
  //  qry.Transaction.Commit;
    SqlInsert := '';
    SqlInsert := 'insert into ' + tbInfo.GetTableName + '(';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_Identifier)   + ', ';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_AssignedProp) + ',';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_PropertyCode);
    SqlInsert := SqlInsert + ') values (';
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_Identifier) + ', ';
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_AssignedProp) + ',' ;
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_PropertyCode);
    SqlInsert := SqlInsert + ')';
    qry.SQL.Clear;
    qry.SQL.Text := SqlInsert;
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_Identifier)).AsString   := IniAppGlobals.Identifier;
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_AssignedProp)).AsString := 'ASSIGNED_BOOL1';
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_PropertyCode)).AsString := CBAssignedBooleanProp1.Items.Strings[CBAssignedBooleanProp1.ItemIndex];
    qry.ExecSQL;
    Application.ProcessMessages;
  //  qry.Transaction.Commit;
    SetAssignedBooleanProp1(GetIdFromCode(CBAssignedBooleanProp1.Items.Strings[CBAssignedBooleanProp1.ItemIndex]), true);
  end;

  if CBCalculatedHighestEnd.ItemIndex > -1 then
  begin
    CleanAllCalculatedHighDateProp;
    qry.SQL.Clear;
    qry.SQL.Add('delete from ' + tbInfo.GetTableName );
    qry.SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_AssignedProp) + '=' + QuotedStr('CALC_HIGH_DATE'));
    qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
    qry.ExecSQL;
    Application.ProcessMessages;
   // qry.Transaction.Commit;
    SqlInsert := '';
    SqlInsert := 'insert into ' + tbInfo.GetTableName + '(';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_Identifier)   + ', ';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_AssignedProp) + ',';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_PropertyCode);
    SqlInsert := SqlInsert + ') values (';
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_Identifier)   + ', ';
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_AssignedProp) + ',' ;
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_PropertyCode);
    SqlInsert := SqlInsert + ')';
    qry.SQL.Clear;
    qry.SQL.Text := SqlInsert;
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_Identifier)).AsString   := IniAppGlobals.Identifier;
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_AssignedProp)).AsString := 'CALC_HIGH_DATE';
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_PropertyCode)).AsString := CBCalculatedHighestEnd.Items.Strings[CBCalculatedHighestEnd.ItemIndex];
    qry.ExecSQL;
    Application.ProcessMessages;
  //  qry.Transaction.Commit;
    SetCalculatedHighDateProp(GetIdFromCode(CBCalculatedHighestEnd.Items.Strings[CBCalculatedHighestEnd.ItemIndex]), true);
  end;

  if CBAssignedLimitCount1.ItemIndex > -1 then
  begin
    CleanAllAssignedLimitGrpCountProp1;
    qry.SQL.Clear;
    qry.SQL.Add('delete from ' + tbInfo.GetTableName );
    qry.SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_AssignedProp) + '=' + QuotedStr('LIMIT_GRP_COUNT'));
    qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
    qry.ExecSQL;
    Application.ProcessMessages;
   // qry.Transaction.Commit;

    SqlInsert := '';
    SqlInsert := 'insert into ' + tbInfo.GetTableName + '(';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_Identifier)   + ', ';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_AssignedProp) + ',';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_PropertyCode);
    SqlInsert := SqlInsert + ') values (';
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_Identifier)   + ', ';
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_AssignedProp) + ',' ;
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_PropertyCode);
    SqlInsert := SqlInsert + ')';
    qry.SQL.Clear;
    qry.SQL.Text := SqlInsert;
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_Identifier)).AsString   := IniAppGlobals.Identifier;
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_AssignedProp)).AsString := 'LIMIT_GRP_COUNT';
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_PropertyCode)).AsString := CBAssignedLimitCount1.Items.Strings[CBAssignedLimitCount1.ItemIndex];
    qry.ExecSQL;
    Application.ProcessMessages;
  //  qry.Transaction.Commit;
    SetAssignedLimitGrpCountProp1(GetIdFromCode(CBAssignedLimitCount1.Items.Strings[CBAssignedLimitCount1.ItemIndex]), true);
  end;

  if CBAssignedForValueCompareGrpLimit1.ItemIndex > -1 then
  begin
    CleanAllAssignedPropValueCompareLimitGroup1;
    qry.SQL.Clear;
    qry.SQL.Add('delete from ' + tbInfo.GetTableName );
    qry.SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_AssignedProp) + '=' + QuotedStr('GRP_VAL_COMPRE'));
    qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
    qry.ExecSQL;
    Application.ProcessMessages;
  //  qry.Transaction.Commit;

    SqlInsert := '';
    SqlInsert := 'insert into ' + tbInfo.GetTableName + '(';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_Identifier)   + ', ';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_AssignedProp) + ',';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_PropertyCode);
    SqlInsert := SqlInsert + ') values (';
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_Identifier)   + ', ';
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_AssignedProp) + ',' ;
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_PropertyCode);
    SqlInsert := SqlInsert + ')';
    qry.SQL.Clear;
    qry.SQL.Text := SqlInsert;
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_Identifier)).AsString   := IniAppGlobals.Identifier;
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_AssignedProp)).AsString := 'GRP_VAL_COMPRE';
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_PropertyCode)).AsString := CBAssignedForValueCompareGrpLimit1.Items.Strings[CBAssignedForValueCompareGrpLimit1.ItemIndex];
    qry.ExecSQL;
    Application.ProcessMessages;
  //  qry.Transaction.Commit;
    SetAssignedPropValueCompareLimitGroup1(GetIdFromCode(CBAssignedForValueCompareGrpLimit1.Items.Strings[CBAssignedForValueCompareGrpLimit1.ItemIndex]), true);
  end;

  if CBAssignedLimitCount2.ItemIndex > -1 then
  begin
    CleanAllAssignedLimitGrpCountProp2;
    qry.SQL.Clear;
    qry.SQL.Add('delete from ' + tbInfo.GetTableName );
    qry.SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_AssignedProp) + '=' + QuotedStr('LIMIT_GRP_COUNT2'));
    qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
    qry.ExecSQL;
    Application.ProcessMessages;
  //  qry.Transaction.Commit;

    SqlInsert := '';
    SqlInsert := 'insert into ' + tbInfo.GetTableName + '(';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_Identifier)   + ', ';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_AssignedProp) + ',';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_PropertyCode);
    SqlInsert := SqlInsert + ') values (';
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_Identifier)   + ', ';
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_AssignedProp) + ',' ;
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_PropertyCode);
    SqlInsert := SqlInsert + ')';
    qry.SQL.Clear;
    qry.SQL.Text := SqlInsert;
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_Identifier)).AsString   := IniAppGlobals.Identifier;
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_AssignedProp)).AsString := 'LIMIT_GRP_COUNT2';
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_PropertyCode)).AsString := CBAssignedLimitCount2.Items.Strings[CBAssignedLimitCount2.ItemIndex];
    qry.ExecSQL;
    Application.ProcessMessages;
  //  qry.Transaction.Commit;
    SetAssignedLimitGrpCountProp2(GetIdFromCode(CBAssignedLimitCount2.Items.Strings[CBAssignedLimitCount2.ItemIndex]), true);
  end;

  if CBAssignedForValueCompareGrpLimit2.ItemIndex > -1 then
  begin
    CleanAllAssignedPropValueCompareLimitGroup2;
    qry.SQL.Clear;
    qry.SQL.Add('delete from ' + tbInfo.GetTableName );
    qry.SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_AssignedProp) + '=' + QuotedStr('GRP_VAL_COMPRE2'));
    qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
    qry.ExecSQL;
    Application.ProcessMessages;
   // qry.Transaction.Commit;

    SqlInsert := '';
    SqlInsert := 'insert into ' + tbInfo.GetTableName + '(';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_Identifier)   + ', ';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_AssignedProp) + ',';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_PropertyCode);
    SqlInsert := SqlInsert + ') values (';
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_Identifier)   + ', ';
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_AssignedProp) + ',' ;
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_PropertyCode);
    SqlInsert := SqlInsert + ')';
    qry.SQL.Clear;
    qry.SQL.Text := SqlInsert;
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_Identifier)).AsString   := IniAppGlobals.Identifier;
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_AssignedProp)).AsString := 'GRP_VAL_COMPRE2';
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_PropertyCode)).AsString := CBAssignedForValueCompareGrpLimit2.Items.Strings[CBAssignedForValueCompareGrpLimit2.ItemIndex];
    qry.ExecSQL;
    Application.ProcessMessages;
    SetAssignedPropValueCompareLimitGroup2(GetIdFromCode(CBAssignedForValueCompareGrpLimit2.Items.Strings[CBAssignedForValueCompareGrpLimit2.ItemIndex]), true);
  end;


  qry.Transaction.Commit;
  qry.close;
  qry.Free;

end;

// -------------------------------------------------------------------------- //

procedure TFOptions.IniMailInfoToDB;
var
  I : Integer;
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
  SqlText, UserId, Password, Recipient, GroupName : string;
  TabSheet : TMViewTabSheet;
begin
  qry := CreateQuery(Cfg_DB);
  tbInfo := @tblInfo[tbl_cfg_Mail_set_List];

  SqlText := 'select * from ' +  tbInfo.GetTableName + ' where ' + CreateFld(tbInfo.pfx, fli_workstation) + '=' +
            QuotedStr(IniAppGlobals.WkstCode) + AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)) + ' Order by ' + CreateFld(tbInfo.pfx, fli_MailGroupName);

  qry.SQL.Clear;
  qry.SQL.Add(SqlText);
  qry.Open;

  while not qry.Eof do
  begin
    GroupName   := trim(qry.FieldByName(CreateFld(tbInfo.pfx, fli_MailGroupName)).AsString);
    UserId    := trim(qry.FieldByName(CreateFld(tbInfo.pfx, fli_User_Id)).AsString);
    Password  := trim(qry.FieldByName(CreateFld(tbInfo.pfx, fli_Password)).AsString);
    Recipient := trim(qry.FieldByName(CreateFld(tbInfo.pfx, fli_Recipient)).AsString);
    ListBoxCodeMail.Items.Add(GroupName);
    TabSheet := AddTabSheetToControlMailList(GroupName);
    TEdit(TabSheet.Components[0]).Text := UserId;
    TEdit(TabSheet.Components[1]).Text := Password;
    TEdit(TabSheet.Components[2]).Text := Recipient;
    qry.Next;
  end;
end;

// -------------------------------------------------------------------------- //

procedure TFOptions.SetMailInfoToDB;
var
  I : Integer;
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
  SqlInsert : string;
  UserId, Password, Recipient : string;
  TabSheet : TMViewTabSheet;
begin
  if PageControlMailList.PageCount = 0 then exit;
  qry := CreateQuery(Cfg_DB);
  qry.Transaction := CreateTransaction(Cfg_DB);
  qry.Transaction.StartTransaction;

  tbInfo := @tblInfo[tbl_cfg_Mail_set_List];

  qry.SQL.Clear;
  qry.SQL.Add('delete from ' + tbInfo.GetTableName);
  qry.SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_workstation) + '= ' + QuotedStr(IniAppGlobals.WkstCode));
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.ExecSQL;
 // qry.Transaction.Commit;

  TabSheet := TMViewTabSheet(PageControlMailList.ActivePage);
//  for I := 0 to TabSheet.ComponentCount - 1 do
  for I := 0 to PageControlMailList.PageCount - 1 do
  begin
    TabSheet := TMViewTabSheet(PageControlMailList.Pages[I]);
    UserId := TEdit(TabSheet.Components[0]).Text;
    Password := TEdit(TabSheet.Components[1]).Text;
    Recipient := TEdit(TabSheet.Components[2]).Text;

    SqlInsert := '';
    SqlInsert := 'insert into ' + tbInfo.GetTableName + '(';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_Identifier) + ', ';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_workstation) + ',';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_MailGroupName) + ',';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_User_Id) + ',';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_Password) + ',';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_Recipient);
    SqlInsert := SqlInsert + ') values (';
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_Identifier) + ',' ;
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_workstation) + ',' ;
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_MailGroupName) + ',' ;
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_User_Id) + ',' ;
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_Password) + ',' ;
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_Recipient);
    SqlInsert := SqlInsert + ')';
    qry.SQL.Clear;
    qry.SQL.Text := SqlInsert;

    qry.ParamByName(CreateFld(tbInfo.pfx,fli_Identifier)).AsString   := IniAppGlobals.Identifier;
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_workstation)).AsString := IniAppGlobals.WkstCode;
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_MailGroupName)).AsString     := TabSheet.Caption;
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_User_Id)).AsString     := UserId;
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_Password)).AsString    := Password;
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_Recipient)).AsString   := Recipient;

    qry.ExecSQL;
    Application.ProcessMessages;
  end;

  qry.Transaction.Commit;

end;

// -------------------------------------------------------------------------- //

function TFOptions.AddTabSheetToControlMailList(SetName : string) : TMViewTabSheet;
var
  Lbl : TLabel;
  Edit : TEdit;
begin
  Result := TMViewTabSheet.CreateViewTab(PageControlMailList);
  Result.Caption := setName;

  Lbl := TLabel.Create(self);
  Lbl.Parent := Result;
  Lbl.left := 21;
  Lbl.top := 17;
  Lbl.Caption := 'User id';

  Edit := TEdit.Create(Result);
  Edit.Parent := Result;
  Edit.left := Lbl.left + Lbl.Width + 21;
  Edit.top := 15;
  Edit.Width := 300;
  Edit.text := '';

  Lbl := TLabel.Create(self);
  Lbl.Parent := Result;
  Lbl.left := Edit.left + Edit.Width + 30;
  Lbl.top := 17;
  Lbl.Caption := 'Password';

  Edit := TEdit.Create(Result);
  Edit.Parent := Result;
  Edit.left := Lbl.left + Lbl.Width + 21;
  Edit.top := 15;
  Edit.Width := 200;
  Edit.text := '';
  Edit.PasswordChar := '*';

  Lbl := TLabel.Create(self);
  Lbl.Parent := Result;
  Lbl.left := 21;
  Lbl.top := 54 ;
  Lbl.Caption := 'Recipient';

  Edit := TEdit.Create(Result);
  Edit.Parent := Result;
  Edit.left := Lbl.left + Lbl.Width + 21;
  Edit.top := 52;
  Edit.Width := 600;
  Edit.text := '';
end;

// -------------------------------------------------------------------------- //

function TFOptions.GetMailGroupList : TStringList;
var
  I : Integer;
  TabSheet : TMViewTabSheet;
begin
  Result := nil;
  if PageControlMailList.PageCount = 0 then exit;
  Result := TStringList.Create;
  for I := 0 to PageControlMailList.PageCount - 1 do
  begin
    TabSheet := TMViewTabSheet(PageControlMailList.Pages[I]);
    Result.Add(TabSheet.Caption)
  end;
end;

// -------------------------------------------------------------------------- //

procedure TFOptions.BitBtnDltMAilSetClick(Sender: TObject);
var
  qry:    TMqmQuery;
  trs:    TMqmTransaction;
  tbInfo: ^TTblInfo;
  Code : string;
  I : Integer;
begin
  for I := 0  to  PageControlMailList.PageCount-1 do
  begin
    if ListBoxCodeMail.ItemIndex = I then
    begin
      PageControlMailList.Pages[i].Destroy;
      break;
    end;
  end;
  ListBoxCodeMail.Items.Delete(ListBoxCodeMail.ItemIndex);
end;

// -------------------------------------------------------------------------- //

procedure TFOptions.BitBtOpenSetMailClick(Sender: TObject);
var
  setName: String;
  RowDetailsSet : TFRowDetailsSet;
  TabSheet : TMViewTabSheet;
begin
  if ListBoxCodeMail.ItemIndex < 0 then
  begin
    MessageDlg(_('Please select a set first !'), mtWarning, [mbOK], 0);
    exit;
  end;
  setName := ListBoxCodeMail.Items.Strings[ListBoxCodeMail.ItemIndex];
  if ListBoxCodeMail.Count = PageControlMailList.PageCount then exit;
  TabSheet := AddTabSheetToControlMailList(setName);
  PageControlMailList.ActivePage := TabSheet;
end;

// -------------------------------------------------------------------------- //

procedure TFOptions.BitDeleteSetClick(Sender: TObject);
var
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
  Code : string;
begin
  if LBListOfSets.ItemIndex = -1 then exit;
  Code := LBListOfSets.Items.Strings[LBListOfSets.ItemIndex];
  qry := CreateQuery(Cfg_DB);
  qry.Transaction := CreateTransaction(Cfg_DB);
  qry.Transaction.StartTransaction;

  tbInfo := @tblInfo[tbl_cfg_AutoRunDefinition];
  qry.SQL.Clear;
  qry.SQL.Add('delete from ' + tbInfo.GetTableName );
  qry.SQL.Add(' where ' );
  qry.SQL.Add(CreateFld(tbInfo.pfx, fli_wkstCode) + '=' + QuotedStr(IniAppGlobals.WkstCode));
  qry.SQL.Add( ' and ' + CreateFld(tbInfo.pfx, fli_AutomaticRunCode) + '=' + QuotedStr(Code));
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.ExecSQL;
  qry.Transaction.Commit;
  DeleteAutoRunCodeFromList(code);
  LBListOfSets.Items.Delete(LBListOfSets.ItemIndex);
end;

// -------------------------------------------------------------------------- //

procedure TFOptions.BitOpenSetClick(Sender: TObject);
var
  setName: String;
  RowDetailsSet : TFRowDetailsSet;
begin
  if LBListOfSets.ItemIndex < 0 then
  begin
    MessageDlg(_('Please select a set first !'), mtWarning, [mbOK], 0);
    exit;
  end;
  setName := LBListOfSets.Items.Strings[LBListOfSets.ItemIndex];

  RowDetailsSet := TFRowDetailsSet.CreateRowDetailAutoRunSet(setName , GetMailGroupList, self);
  RowDetailsSet.ShowModal;
end;

// -------------------------------------------------------------------------- //

procedure TFOptions.BtnAbortClick(Sender: TObject);
begin
  DBAppGlobals.ConfLevels := m_ConfLevelsDft;
  IniAppGlobals.FontSize := tmpsize;
  ModalResult := mrAbort;
  Close;
end;

// -------------------------------------------------------------------------- //

procedure TFOptions.BtnAssignedForValueCompareGrpLimitClick(Sender: TObject);
var
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
begin
  tbInfo := @tblInfo[tbl_PropAssigned];
  if TcxButton(sender).Name = 'BtnAssignedForValueCompareGrpLimit1' then
  begin
    CBAssignedForValueCompareGrpLimit1.ItemIndex := -1;
    CleanAllAssignedPropValueCompareLimitGroup1
  end
  else if TcxButton(sender).Name = 'BtnAssignedForValueCompareGrpLimit2' then
  begin
    CBAssignedForValueCompareGrpLimit2.ItemIndex := -1;
    CleanAllAssignedPropValueCompareLimitGroup2
  end;

  qry := CreateQuery(Main_DB);
  qry.Transaction := CreateTransaction(Main_DB);
  qry.Transaction.StartTransaction;

  qry.SQL.Clear;
  qry.SQL.Add('delete from ' + tbInfo.GetTableName );
  if TcxButton(sender).Name = 'BtnAssignedForValueCompareGrpLimit1' then
    qry.SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_AssignedProp) + '=' + QuotedStr('GRP_VAL_COMPRE'))
  else if TcxButton(sender).Name = 'BtnAssignedForValueCompareGrpLimit2' then
    qry.SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_AssignedProp) + '=' + QuotedStr('GRP_VAL_COMPRE2'));
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.ExecSQL;
  qry.Transaction.Commit;
  qry.Free;
end;

// -------------------------------------------------------------------------- //

procedure TFOptions.BtnAssignedLimitCountClick(Sender: TObject);
var
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
begin
  if TcxButton(Sender).Name = 'BtnAssignedLimitCount1' then
  begin
    CBAssignedLimitCount1.ItemIndex := -1;
    CleanAllAssignedLimitGrpCountProp1
  end

  else if TcxButton(Sender).Name = 'BtnAssignedLimitCount2' then
  begin
    CBAssignedLimitCount2.ItemIndex := -1;
    CleanAllAssignedLimitGrpCountProp2
  end;
  tbInfo := @tblInfo[tbl_PropAssigned];

  qry := CreateQuery(Main_DB);
  qry.Transaction := CreateTransaction(Main_DB);
  qry.Transaction.StartTransaction;

  qry.SQL.Clear;
  qry.SQL.Add('delete from ' + tbInfo.GetTableName );
  if TcxButton(Sender).Name = 'BtnAssignedLimitCount1' then
    qry.SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_AssignedProp) + '=' + QuotedStr('LIMIT_GRP_COUNT'))
  else if TcxButton(Sender).Name = 'BtnAssignedLimitCount2' then
    qry.SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_AssignedProp) + '=' + QuotedStr('LIMIT_GRP_COUNT2'));
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.ExecSQL;
  qry.Transaction.Commit;
  qry.Free;
end;

// -------------------------------------------------------------------------- //

procedure TFOptions.BtnCalculatedHighestEndClick(Sender: TObject);
var
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
begin
  CBCalculatedHighestEnd.ItemIndex := -1;
  tbInfo := @tblInfo[tbl_PropAssigned];
  CleanAllApprovalDateProp;
  qry := CreateQuery(Main_DB);
  qry.Transaction := CreateTransaction(Main_DB);
  qry.Transaction.StartTransaction;

  qry.SQL.Clear;
  qry.SQL.Add('delete from ' + tbInfo.GetTableName );
  qry.SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_AssignedProp) + '=' + QuotedStr('CALC_HIGH_DATE'));
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.ExecSQL;
  qry.Transaction.Commit;
  qry.Free;
end;

// -------------------------------------------------------------------------- //

function TFOptions.CheckAssignedProperty : boolean;
begin
  Result := true;
  if (CBAssignedLimitCount1.ItemIndex = -1) and (CBAssignedForValueCompareGrpLimit1.ItemIndex <> -1) or
     (CBAssignedLimitCount1.ItemIndex <> -1) and (CBAssignedForValueCompareGrpLimit1.ItemIndex = -1)
  then
  begin
    result := false;
    Showmessage(_('The two fields must be selected') + ' ' + _('for using function ') + ' ' + _('limit group by count'));
  end;

  if (CBAssignedLimitCount2.ItemIndex = -1) and (CBAssignedForValueCompareGrpLimit2.ItemIndex <> -1) or
     (CBAssignedLimitCount2.ItemIndex <> -1) and (CBAssignedForValueCompareGrpLimit2.ItemIndex = -1)
  then
  begin
    result := false;
    Showmessage(_('The two fields must be selected') + ' ' + _('for using function ') + ' ' + _('limit group by count'));
  end;

end;

// -------------------------------------------------------------------------- //

procedure TFOptions.BtnOkClick(Sender: TObject);
var
  Save_Cursor : TCursor;
  I : Integer;
  PropListChanged : boolean;
  TempStringList : TStringList;
  TempExt : Extended;
begin
  ModalResult := mrOk;
  Save_Cursor   := Screen.Cursor;
  Screen.Cursor  := crAppStart; //SQLWait;
  PropListChanged := false;
  if not CheckAssignedProperty then
  begin

  end;

//  CustomSlotDIsplay.Enable := true;

  if cbQtyMultiProp.Items[cbQtyMultiProp.ItemIndex] <> '' then
    DBAppGlobals.MCMCustomProp := GetPropCodeFromID(cbQtyMultiProp.Items.Objects[cbQtyMultiProp.ItemIndex])
  else
    DBAppGlobals.MCMCustomProp := '';

  DBAppGlobals.MCMCustomPropSymbol := EditPropCustomSymbol.Text;
  Application.ProcessMessages;
  SetProperties;
  SetMailInfoToDB;

  with DBAppGlobals do
  begin
    DefSchedType := RGFixTemp.ItemIndex+1;
    ConfLevels := SpinEdit1.Value;
    CheckStepSeq := ChkBxSequece.Checked;
    UnscheduleJobsOnStart := IntTostr(RGUnscheduleClosedJobs.ItemIndex);
    CenterStartOnMove := ChkCenterStartOnMove.Checked;
    WarnOnMoveFinal := ChkWarnOnMoveFinal.Checked;
    WhenMoveShowErrorsIfExist := CBWhenMoveShowErrorIfExists.Checked;

    if rbQty.Checked then
      MCMSlotDisplay := 1
    else
      MCMSlotDisplay := 0;

    if cbQtyMultiProp.Visible then
    begin
      if cbQtyMultiProp.text <> '' then
        MCMCustomQty := True
      else
        MCMCustomQty := False;
    end
    else
      MCMCustomQty := False;
  end;

  with IniAppGlobals do
  begin
    SMTP_server := EditSmtpServer.Text;
    PORT :=        EditPort.Text;
    if CBLoginSecureAutenthication.Checked then
      LOGINWithAUTHENTICATION := '1'
    else
      LOGINWithAUTHENTICATION := '0';
    if CB_TLS_SSL_Enabled.Checked then
      TLS_SSL  := '1'
    else
      TLS_SSL  := '0';
  end;

  with DBAppSettings do
  begin
    FixColCompVis := ChkBCompat.Checked;
    FixColLowDVis := ChKBLowDate.Checked;
    FixColHigDVis := ChkBHighDate.Checked;
    FixColOvlpVis := ChKBOverlaps.Checked;
    FixColMatDVis := ChkBMaterialDate.Checked;
    FixColDelDVis := ChkBDeliveryDate.Checked;
    FixColStatVis := ChkBStatus.Checked;
    FixColDatesVis  := ChkBDatesWarn.Checked;
    FixColJobMsgVis := CheckBJobMsg.Checked;

    ChkDelDate    := ChkBDelDateW.Checked;
    ChkMaterials  := ChkBMaterialsW.Checked;
    ChkAddRes     := ChkBAddResW.Checked;
    ChkPrevStpQty := ChkBPrevStepQtyW.Checked;
    ChkLowStart   := ChkBLowestStartW.Checked;
    ChkHighEnd    := ChkBHighEndW.Checked;
    ChkLinkOvlp   := ChkBOvlpW.Checked;

    ShowInBinOnMove     := ChkBxShowInBinOnMove.Checked;

    if RefreshBinByButton and not ChkBxRefreshBinButton.Checked then
       FBin.DeActivateRefreshButton;

    RefreshBinByButton  := ChkBxRefreshBinButton.Checked;

    JobMoveWitoutConfirmation := CBJobMoveWithoutConfirmation.Checked;
    WarningWhenMaxNumCompChanged := CBWarningWhenResCompChange.Checked;

    CapResStartEnd := cbCapRes.Checked;

    if RadioGroupReportFormat.ItemIndex = 0 then
      ReportTimeFormat := '0'
    else
      ReportTimeFormat := '1';

    case RGCalDayFormat.ItemIndex of
      0 : CalDayFormat := '0';
      1 : CalDayFormat := '1';
      2 : CalDayFormat := '2';
      3 : CalDayFormat := '3'
        else
          CalDayFormat := '0';
    end;

    ShowBinPropColors := CBxShowBinPropColors.Checked;


{    case RadioGroupForceOverlap.ItemIndex of
      0 : ForceOverlap := FOL_No;
      1 : ForceOverlap := FOL_Yes;
      2 : ForceOverlap := FOL_Forceable;
        else
          ForceOverlap := FOL_No;
    end;  }

    if CBDoNotAllowOverLapOnManual.Checked then
      ForceOverlap := FOL_Yes
    else
      ForceOverlap := FOL_No;


    ShowBinToolBar      := CBShowBinToolBar.Checked;
    if RGBinHandling.ItemIndex = 1 then
      ShowRowInBin      := true
    else
      ShowRowInBin      := false;

    TabResSort    := ChkSort.Checked;
    TabKeepSort   := ChkKeepSort.Checked;
    TabFilterRead := ChkFilterRead.Checked;
    TabWorkcenter := ChkWorkcenter.Checked;
    TabNoTimings  := ChkNoTimings.Checked;
    TabNoCompat   := ChkNoCompat.Checked;
    GanttMultiLineTab := CBGantt.Checked;
    BinMultiLineTab   := CBbin.Checked;

    case RGCreateBewBinTabForCompatibles.ItemIndex of
      0 : CreateNewBinTabForCompatibles := NewB_No;
      1 : CreateNewBinTabForCompatibles := NewB_Yes_OnlyCompatibleAndToSchedJobs;
      2 : CreateNewBinTabForCompatibles := NewB_Yes_MarkCompatibleAndToSchedJobs;
      3 : CreateNewBinTabForCompatibles := NewB_Yes_ShowOnlyCompatibles
        else
          CreateNewBinTabForCompatibles := NewB_No;
    end;

    case RGShowCompatibleInExistingBINS.ItemIndex of
      0 : ShowCompatibleInExistingBINS := ShowC_No;
      1 : ShowCompatibleInExistingBINS := ShowC_Yes_MarkTheCompatibles;
      2 : ShowCompatibleInExistingBINS := ShowC_Yes_ShowOnlyCompatibles;
        else
          ShowCompatibleInExistingBINS := ShowC_Yes_MarkTheCompatibles;
    end;

    case RGWhowScheduledOfSelectedResource.ItemIndex of
      0 : ShowScheduledJobsOfSelectedResource := ShowS_No;
      1 : ShowScheduledJobsOfSelectedResource := ShowS_Yes;
        else
          ShowScheduledJobsOfSelectedResource := ShowS_No;
    end;

    DBAppSettings.SuggestedTextTabJobSequence := MiJobSequenceTabNameSuggested.Text;
  end;

  iniAppGlobals.FontSize := rgFontSize.ItemIndex;

  GlobSaveSettingsValues;

  TempStringList := TStringList.Create;
  for I := Low(DBAppGlobals.ShowBinPropArry) to high(DBAppGlobals.ShowBinPropArry) do
  begin
    if (DBAppGlobals.ShowBinPropArry[I] <> nil) then
      TempStringList.Add(GetPropCodeFromID(DBAppGlobals.ShowBinPropArry[I]));
  end;
  if (m_ListProp_start.count <> TempStringList.Count) then
     PropListChanged := true
  else
  begin
    for I := 0 to m_ListProp_start.count - 1 do
    begin
      if (m_ListProp_start.Strings[I] <> TempStringList.Strings[I]) then
      begin
        PropListChanged := true;
          break;
        end;
      end;
  end;

//  if not Change then
  if PropListChanged then
  begin
    if Assigned(Fbin) then Fbin.OrganizeDefaultTabForNewPropSet;
    if Assigned(Fbin) then Fbin.OrganizeTabsForNewPropSet;
    if Assigned(Fbin) then Fbin.UpdateDbForNewPropSet;
    if Assigned(Fbin) then Fbin.UpdateDbForNewPropSetDefaultTab;
    SavePropBin;
  end;
//  if Assigned(Fbin) then Fbin.UdateTabsProp;

//  if not DBAppSettings.FixColSelection then
//    p_sc.DisableAllBinCheckBox(true);

  if CBRound.ItemIndex = 0 then
    iniAppGlobals.SplitFromPointNumOfDec := '0'
  else if CBRound.ItemIndex = 1 then
    iniAppGlobals.SplitFromPointNumOfDec := '1'
  else if CBRound.ItemIndex = 2 then
    iniAppGlobals.SplitFromPointNumOfDec := '2';

  if CBNumOfDecimalForJobQtyOnStatusBar.ItemIndex = 0 then
    iniAppGlobals.NumOfDecJobQtyOnStatusBar := '0'
  else if CBNumOfDecimalForJobQtyOnStatusBar.ItemIndex = 1 then
    iniAppGlobals.NumOfDecJobQtyOnStatusBar := '1'
  else if CBNumOfDecimalForJobQtyOnStatusBar.ItemIndex = 2 then
    iniAppGlobals.NumOfDecJobQtyOnStatusBar := '2';

  if RadioGroupRoundingCriteria.ItemIndex = 0 then
    iniAppGlobals.SplitFromPointRoundCrit := '0'
  else if RadioGroupRoundingCriteria.ItemIndex = 1 then
    iniAppGlobals.SplitFromPointRoundCrit := '1';

  if RGpSplitOnPreDefineTime.ItemIndex = 0 then
    iniAppGlobals.SplitFromPointOnPreDefTime := '0'
  else if RGpSplitOnPreDefineTime.ItemIndex = 1 then
    iniAppGlobals.SplitFromPointOnPreDefTime := '1'
  else if RGpSplitOnPreDefineTime.ItemIndex = 2 then
    iniAppGlobals.SplitFromPointOnPreDefTime := '2';

  TempExt := frac(DateTimePickerTime.DateTime);  //DateTimePickerTime.Time;
  try
    iniAppGlobals.SplitFromPointPreDefTime := FloatToStr(TempExt);
  Except
  end;

  try
    iniAppGlobals.SetLimiDateUsingCapacity := EdtCapacity.Text;
  Except
  end;

  try
    iniAppGlobals.SetLimiDateUsingSecureNumDays := EdtScureNumberOfDays.Text;
  Except
  end;

  with FBin do
  begin
//    TBJobMsg.Visible := DBAppSettings.FixColJobMsgVis;
 //   TBSelection.Visible := MISelection.Visible;
   // SPSelection.Visible := false;
  end;

  if m_PopupChanged and not DBAppGlobals.MCM_App then
    UpdatePopupLists;

//  if not (m_SaveOldShowContGrougLines and CBoxContGroupLines.Checked) then
  FBin.UpdateForChangeFilter;
  Screen.Cursor := Save_Cursor;
end;

// -------------------------------------------------------------------------- //

procedure TFOptions.ChgSortStatus(Sender: TObject);
begin
  if ChkSort.Checked then
    ChkKeepSort.Visible := true
  else
    ChkKeepSort.Visible := false
end;

procedure TFOptions.clbResClickCheck(Sender: TObject);
begin
  m_PopupChanged := True;
end;

// -------------------------------------------------------------------------- //

function TFOptions.IsCustomPropChanged : boolean;
begin
  Result := false;
  if m_MCMCustomPropOrig <> DBAppGlobals.MCMCustomProp then
    Result := true;
end;

// -------------------------------------------------------------------------- //

procedure TFOptions.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  m_ListProp_start.free;
  if ModalResult <> mrOk then
      DBAppGlobals.ConfLevels := m_ConfLevelsDft;
end;

// -------------------------------------------------------------------------- //

procedure TFOptions.FormCreate(Sender: TObject);
begin
  BitDeleteSet.StyleName := 'VLargeButton320x30';
  BitOpenSet.StyleName := 'VLargeButton320x30';
  BtnSaveNewSet.StyleName := 'VLargeButton320x30';
  BitBtnDltMAilSet.StyleName := 'VLargeButton320x30';
  BitBtOpenSetMail.StyleName := 'VLargeButton320x30';
  NewSetMailList.StyleName := 'VLargeButton320x30';
  ButtonCheckMail.StyleName := 'VLargeButton320x30';
  ScaleFormSize(Self, Screen.PixelsPerInch);
  GetAutoRunCodeList(LBListOfSets.Items);
  TranslateComponent (self);

  ReShape(Self);

end;

// -------------------------------------------------------------------------- //

procedure TFOptions.SpinEdit1Change(Sender: TObject);
begin
  DBAppGlobals.ConfLevels := SpinEdit1.Value;
  RGFixTemp.Items.Clear;
  RGFixTemp.Items.Add(_('Final schedule'));
  if SpinEdit1.Value >= 1 then
    RGFixTemp.Items.Add(_('Initial schedule'));
  if SpinEdit1.Value >= 2 then
    RGFixTemp.Items.Add(_('Confirmation level 1'));
  if SpinEdit1.Value >= 3 then
    RGFixTemp.Items.Add(_('Confirmation level 2'));
  if SpinEdit1.Value >= 4 then
    RGFixTemp.Items.Add(_('Confirmation level 3'));
  if SpinEdit1.Value >= 5 then
    RGFixTemp.Items.Add(_('Confirmation level 4'));
  if SpinEdit1.Value >= 6 then
    RGFixTemp.Items.Add(_('Confirmation level 5'));

  if RGFixTemp.Items.Count < DBAppGlobals.DefSchedType then
    RGFixTemp.ItemIndex := RGFixTemp.Items.Count-1
  else
    RGFixTemp.ItemIndex := DBAppGlobals.DefSchedType-1;
end;

// -------------------------------------------------------------------------- //

procedure TFOptions.FormShow(Sender: TObject);
begin
  InitProp;
  IniMailInfoToDB;
  if not DBAppGlobals.MCM_App then
    GetPopupList;

  if Screen.PixelsPerInch = 96 then
    CBNumOfDecimalForJobQtyOnStatusBar.Left := ShowJobQtyOnStatusBar.Left + ShowJobQtyOnStatusBar.Width-50
  else if Screen.PixelsPerInch = 120  then
    CBNumOfDecimalForJobQtyOnStatusBar.Left := ShowJobQtyOnStatusBar.Left + ShowJobQtyOnStatusBar.Width-10
  else if Screen.PixelsPerInch = 144  then
    CBNumOfDecimalForJobQtyOnStatusBar.Left := ShowJobQtyOnStatusBar.Left + ShowJobQtyOnStatusBar.Width - 20;

end;

// -------------------------------------------------------------------------- //

procedure TFOptions.BtnSaveNewSetClick(Sender: TObject);
//var
//  RowDetailsSet : TFRowDetailsSet;
begin
  EditNewSetName.Text;
  if EditNewSetName.Text = '' then
    begin
      MessageDlg(_('Please enter a set name.'), mtWarning, [mbOK], 0);
      exit
    end;
  LBListOfSets.Items.Add(EditNewSetName.Text); //add set to Sets ComboBox)
//  RowDetailsSet := TFRowDetailsSet.CreateRowDetailAutoRunSet(EditNewSetName.Text, self);
//  FBarConfig.CreateNewSet(EditNewSetName.Text, setType);

//  FbarConfig.Save(false, true,false);

  EditNewSetName.Text := '';
end;

// -------------------------------------------------------------------------- //

procedure TFOptions.ButtonCheckMailClick(Sender: TObject);
var
  I : Integer;
  TabSheet : TMViewTabSheet;
  SendMailParam : TSendMailParm;
begin
  SendMailParam.AttachmentFilePath := '';
  SendMailParam.Subject := _('Mqm test mail');
  SendMailParam.BodyText := _('This is a test - mail sent by mqm user');

  if PageControlMailList.PageCount = 0 then
  begin
    ShowMessage(_('Please fill all details for sending mail by open new set list'));
    exit;
  end;

  TabSheet := TMViewTabSheet(PageControlMailList.ActivePage);

  for I := 0 to TabSheet.ComponentCount - 1 do
  begin
    if (TabSheet.Components[I] is TEdit) and (I = 0) then
      SendMailParam.UserId := TEdit(TabSheet.Components[I]).Text;

    if (TabSheet.Components[I] is TEdit) and (I = 1) then
      SendMailParam.Password := TEdit(TabSheet.Components[I]).Text;

    if (TabSheet.Components[I] is TEdit) and (I = 2) then
      SendMailParam.Recipient := TEdit(TabSheet.Components[I]).Text;
  end;

  SendMailParam.SmtpServer := EditSmtpServer.Text;
  SendMailParam.port := EditPort.Text;

  if CB_TLS_SSL_Enabled.Checked then
    SendMailParam.TLS_SSL := true
  else
    SendMailParam.TLS_SSL := false;

  if SendEmail(SendMailParam) then
     ShowMessage(_('Email was sent'));

end;

// -------------------------------------------------------------------------- //

procedure TFOptions.ButtonApprovalDatePropClick(Sender: TObject);
var
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
begin
  CBApprovalDateProp.ItemIndex := -1;
  tbInfo := @tblInfo[tbl_PropAssigned];
  CleanAllApprovalDateProp;
  qry := CreateQuery(Main_DB);
  qry.Transaction := CreateTransaction(Main_DB);
  qry.Transaction.StartTransaction;
  qry.SQL.Clear;
  qry.SQL.Add('delete from ' + tbInfo.GetTableName );
  qry.SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_AssignedProp) + '=' + QuotedStr('APPROVAL_DATE'));
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.ExecSQL;
  qry.Transaction.Commit;
  qry.Free;
end;

// -------------------------------------------------------------------------- //

procedure TFOptions.ButtonCBAssignedBooleanProp1Click(Sender: TObject);
var
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
begin
  CBAssignedBooleanProp1.ItemIndex := -1;
  CleanAllAssignedBooleanProp1;
  tbInfo := @tblInfo[tbl_PropAssigned];
  qry := CreateQuery(Main_DB);
  qry.Transaction := CreateTransaction(Main_DB);
  qry.Transaction.StartTransaction;
  qry.SQL.Clear;
  qry.SQL.Add('delete from ' + tbInfo.GetTableName );
  qry.SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_AssignedProp) + '=' + QuotedStr('ASSIGNED_BOOL1'));
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  qry.ExecSQL;
  qry.Transaction.Commit;
  qry.Free;
end;

// -------------------------------------------------------------------------- //

procedure TFOptions.CBShowBinToolBarClick(Sender: TObject);
begin
  if assigned(FToolBar) then
    FToolBar.Visible := CBShowBinToolBar.Checked;
end;

// -------------------------------------------------------------------------- //

procedure TFOptions.RGBinHandlingClick(Sender: TObject);
begin
  if RGBinHandling.ItemIndex = 1 then
    FBin.ChangeBinOptions(true)
  else
    FBin.ChangeBinOptions(false);
end;

procedure TFOptions.rgFontSizeClick(Sender: TObject);
begin
  IniAppGlobals.FontSize := rgFontSize.ItemIndex;
  Reshape(self);
end;

end.
