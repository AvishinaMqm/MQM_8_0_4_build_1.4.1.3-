unit FMAutoSchedReport;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, StdCtrls, Buttons, Menus, UMSchedList, UReShape;

type

  TFAutoSchedRpt = class(TForm)
    TVReport: TTreeView;
    LVReport: TListView;
    Splitter1: TSplitter;
    PnlBtm: TPanel;
    PupMnu: TPopupMenu;
    JobDetail1: TMenuItem;
    BtnOk: TcxButton;
    BtnCanc: TcxButton;
    procedure TVReportChange(Sender: TObject; Node: TTreeNode);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LVReportCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure LVReportSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure BtnCancClick(Sender: TObject);
    procedure JobDetail1Click(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    m_FormClose : boolean;
    m_ObjList : TMSchedList;
    m_ObjsOnPlan: TList;
    m_ObjsInBin: TList;
    m_Lev1Tn : TTreeNode;
    procedure InitTreeView;
    procedure SetColForPlan;
    procedure SetColForBin;
    procedure RefreshJobColorStatus;
  public
    constructor CreateAutoSchedRpt(AOwner: Tcomponent; ObjList: TMSchedList; ObjsOnPlan, ObjsInBin: TList);
    destructor Destroy; override;
  end;

//  function ProcSortDelay(Item1, Item2: PTReportLine): Integer;
//  function ProcSortProdEff(Item1, Item2: PTReportLine): Integer;

var
  FAutoSchedRpt: TFAutoSchedRpt;

implementation

{$R *.DFM}

uses
  gnugettext,
  UMRank,
  FMMainPlan,
  FMStepDetails,
  UMSchedContFunc,
  UMSchedCont,
  UMObjCont,
  UMAutoSchedCfg,
  UMCompat,
  UMActArea,
  UMCommon,
  UMGlobal,
  UGGlobal;

//----------------------------------------------------------------------------//
{
function ProcSortDelay(Item1, Item2: PTReportLine): Integer;
var
  Delay1, Delay2: TDateTime;
begin
  Delay1 := Item1.m_VipLn.p_rdRecRV.BDTCSN - Item1.m_VipLn.p_end;
  Delay2 := Item2.m_VipLn.p_rdRecRV.BDTCSN - Item2.m_VipLn.p_end;

  if Delay1 = Delay2 then
    Result := ProcSortProdEff(Item1, Item2)
  else
    if Delay1 > Delay2 then
      Result := 1
    else
      Result := -1;
end;

//----------------------------------------------------------------------------//

function ProcSortProdEff(Item1, Item2: PTReportLine): Integer;
var
  ProdEff1, ProdEff2: double;
begin
  ProdEff1 := Item1.m_Rec.SCMPQU +
              Item1.m_Rec.SCMPRS +
              Item1.m_Rec.SCTROC +
              Item1.m_Rec.SCTRDS;
  ProdEff2 := Item2.m_Rec.SCMPQU +
              Item2.m_Rec.SCMPRS +
              Item2.m_Rec.SCTROC +
              Item2.m_Rec.SCTRDS;

  if (ProdEff1 = ProdEff2) then
  begin
    if Item1.m_VipLn.p_rdRecRV.BDTCSN - Item1.m_VipLn.p_end
     <> Item2.m_VipLn.p_rdRecRV.BDTCSN - Item2.m_VipLn.p_end then
      Result := ProcSortDelay(Item1, Item2)
    else
      Result := 0
  end else
    if ProdEff1 > ProdEff2 then
      Result := -1
    else
      Result := 1;
end;
}
//----------------------------------------------------------------------------//

constructor TFAutoSchedRpt.CreateAutoSchedRpt(AOwner: Tcomponent; ObjList: TMSchedList; ObjsOnPlan, ObjsInBin: TList);
begin
  inherited create(AOwner);
  m_FormClose := false;
  m_ObjList   := ObjList;
  m_ObjsOnPlan := ObjsOnPlan;
  m_ObjsInBin := ObjsInBin;
//  TVReport.Color := s_colors[PlanBackGrd];
  InitTreeView;

  Height := 570;
  Width := 825;

  FAutoSchedRpt := self;
end;

//----------------------------------------------------------------------------//

destructor TFAutoSchedRpt.Destroy;
begin
  inherited Destroy;

  FMQMPlan.RefreshActiveTab;
  FAutoSchedRpt := nil;
end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedRpt.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  m_FormClose := true;
  Action := caFree;
end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedRpt.SetColForPlan;
var
  TempCol: TListColumn;
begin
  LVReport.Columns.Clear;

  TempCol := LVReport.Columns.Add;
  TempCol.Caption := _('Scheduled object');
  TempCol.Width := 200;

  TempCol := LVReport.Columns.Add;
  TempCol.Caption := _('Resource');
  TempCol.Width := 120;

  TempCol := LVReport.Columns.Add;
  TempCol.Caption := _('Start date');
  TempCol.Width := 120;

  TempCol := LVReport.Columns.Add;
  TempCol.Caption := _('End date');
  TempCol.Width := 120;

  TempCol := LVReport.Columns.Add;
  TempCol.Caption := _('Planned start date gap');
  TempCol.Width := 100;

  TempCol := LVReport.Columns.Add;
  TempCol.Caption := _('Planned end date gap');
  TempCol.Width := 100;

  TempCol := LVReport.Columns.Add;
  TempCol.Caption := _('Earliest start date gap');
  TempCol.Width := 100;

  TempCol := LVReport.Columns.Add;
  TempCol.Caption := _('Latest end date gap');
  TempCol.Width := 100;

  TempCol := LVReport.Columns.Add;
  TempCol.Caption := _('Dalivery date gap');
  TempCol.Width := 100;

  TempCol := LVReport.Columns.Add;
  TempCol.Caption := _('Job to res compat. case');
  TempCol.Width := 100;

  TempCol := LVReport.Columns.Add;
  TempCol.Caption := _('Job to job compat. case');
  TempCol.Width := 100;

  TempCol := LVReport.Columns.Add;
  TempCol.Caption := _('Job to cap. res. compat. case');
  TempCol.Width := 120;

  TempCol := LVReport.Columns.Add;
  TempCol.Caption := _('Added setup');
  TempCol.Width := 100;

end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedRpt.SetColForBin;
var
  TempCol: TListColumn;
begin
  LVReport.Columns.Clear;
  TempCol := LVReport.Columns.Add;
  TempCol.Caption := _('Object to be scheduled');
  TempCol.Width := 200;

  TempCol := LVReport.Columns.Add;
  TempCol.Caption := _('Planned start date');
  TempCol.Width := 100;

  TempCol := LVReport.Columns.Add;
  TempCol.Caption := _('Planned end date');
  TempCol.Width := 100;

  TempCol := LVReport.Columns.Add;
  TempCol.Caption := _('Warning description');
  TempCol.Width := 500;

end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedRpt.InitTreeView;
var
  i, TotLines : integer;
  Lev0Tn,Lev1Tn,Lev2Tn:  TTreeNode;
  ReportRec: PTAutoSchedResult;
  DtInfo:  TSQDatesInfo;
begin

//  Res := nil;

  TVReport.Items.Clear;
  TotLines := m_ObjsOnPlan.Count + m_ObjsInBin.Count;
  if (m_ObjsOnPlan.Count > 0) then
  begin
    Lev0Tn := TVReport.Items.Add(nil, _('On plan') +
                                      ' ' +  FloatToStr(m_ObjsOnPlan.Count) +
                                      ' (' + FloatToStr(Trunc(m_ObjsOnPlan.Count*100/TotLines*100)/100) +
                                       '%)');
    Lev1Tn := TVReport.Items.AddChild(Lev0Tn, _('Date'));
    Lev2Tn := TVReport.Items.AddChild(Lev1Tn, _('Below earliest start date'));
    for i := 0 to m_ObjsOnPlan.Count-1 do
    begin
      ReportRec := PTAutoSchedResult(m_ObjsOnPlan.items[i]);
      p_sc.GetDatesInfo(ReportRec.m_ObjID, DtInfo);

      if (DtInfo.startDate < (DtInfo.LowStrDate - BeforeLowTolerance(AutoSchedCfg))) then
      begin
        if not Assigned(Lev2Tn.Data) then
          Lev2Tn.Data := TList.Create;
        TList(Lev2Tn.Data).Add(ReportRec);
      end

    end;
    if Assigned(Lev2Tn.Data) then
    begin
      Lev2Tn.Text := Lev2Tn.Text + ' ' + IntToStr(TList(Lev2Tn.Data).Count) +
                     ' (' + FloatToStr(Trunc(TList(Lev2Tn.Data).Count*100/m_ObjsOnPlan.Count*100)/100) +
                     '%)';
//      TList(Lev2Tn.Data).Sort(@ProcSortProdEff)
    end;

    Lev2Tn := TVReport.Items.AddChild(Lev1Tn, _('Within earliest start date tolerance'));
    for i := 0 to m_ObjsOnPlan.Count-1 do
    begin
      ReportRec := PTAutoSchedResult(m_ObjsOnPlan.items[i]);
      p_sc.GetDatesInfo(ReportRec.m_ObjID, DtInfo);

      if (DtInfo.startDate >= (DtInfo.LowStrDate - BeforeLowTolerance(AutoSchedCfg)))
      and (DtInfo.startDate < DtInfo.LowStrDate) then
      begin
        if not Assigned(Lev2Tn.Data) then
          Lev2Tn.Data := TList.Create;
        TList(Lev2Tn.Data).Add(ReportRec);
      end

    end;
    if Assigned(Lev2Tn.Data) then
    begin
      Lev2Tn.Text := Lev2Tn.Text + ' ' + IntToStr(TList(Lev2Tn.Data).Count) +
                     ' (' + FloatToStr(Trunc(TList(Lev2Tn.Data).Count*100/m_ObjsOnPlan.Count*100)/100) +
                     '%)';
//      TList(Lev2Tn.Data).Sort(@ProcSortProdEff)
    end;

    Lev2Tn := TVReport.Items.AddChild(Lev1Tn, _('On time'));
    for i := 0 to m_ObjsOnPlan.Count-1 do
    begin
      ReportRec := PTAutoSchedResult(m_ObjsOnPlan.items[i]);
      p_sc.GetDatesInfo(ReportRec.m_ObjID, DtInfo);
      if (DtInfo.startDate >= DtInfo.LowStrDate)
      and (DtInfo.endDate <= DtInfo.HighEndDate) then
      begin
        if not Assigned(Lev2Tn.Data) then
          Lev2Tn.Data := TList.Create;
        TList(Lev2Tn.Data).Add(ReportRec);
      end
    end;
    if Assigned(Lev2Tn.Data) then
    begin
      Lev2Tn.Text := Lev2Tn.Text + ' ' + IntToStr(TList(Lev2Tn.Data).Count) +
                     ' (' + FloatToStr(Trunc(TList(Lev2Tn.Data).Count*100/m_ObjsOnPlan.Count*100)/100) +
                     '%)';
//      TList(Lev2Tn.Data).Sort(@ProcSortProdEff)
    end;

    Lev2Tn := TVReport.Items.AddChild(Lev1Tn, _('Within latest end date tolerance'));
    for i := 0 to m_ObjsOnPlan.Count-1 do
    begin
      ReportRec := PTAutoSchedResult(m_ObjsOnPlan.items[i]);
      p_sc.GetDatesInfo(ReportRec.m_ObjID, DtInfo);

      if (DtInfo.endDate > DtInfo.HighEndDate)
      and (DtInfo.endDate <= DtInfo.HighEndDate + AfterHighTolerance(AutoSchedCfg)) then
      begin
        if not Assigned(Lev2Tn.Data) then
          Lev2Tn.Data := TList.Create;
        TList(Lev2Tn.Data).Add(ReportRec);
      end

    end;
    if Assigned(Lev2Tn.Data) then
    begin
      Lev2Tn.Text := Lev2Tn.Text + ' ' + IntToStr(TList(Lev2Tn.Data).Count) +
                     ' (' + FloatToStr(Trunc(TList(Lev2Tn.Data).Count*100/m_ObjsOnPlan.Count*100)/100) +
                     '%)';
//      TList(Lev2Tn.Data).Sort(@ProcSortProdEff)
    end;

    Lev2Tn := TVReport.Items.AddChild(Lev1Tn, _('Over latest end date tolerance'));
    for i := 0 to m_ObjsOnPlan.Count-1 do
    begin
      ReportRec := PTAutoSchedResult(m_ObjsOnPlan.items[i]);
      p_sc.GetDatesInfo(ReportRec.m_ObjID, DtInfo);

// OLD AUTOSCHED CONFIGURATION
//      if (DtInfo.endDate > DtInfo.HighEndDate + AfterHighTolerance(AutoSchedCfg))
//      and (DtInfo.endDate <= DtInfo.DeliveryDate) then
      if (DtInfo.endDate > DtInfo.HighEndDate + AfterHighTolerance(AutoSchedCfg)) then
      begin
        if not Assigned(Lev2Tn.Data) then
          Lev2Tn.Data := TList.Create;
        TList(Lev2Tn.Data).Add(ReportRec);
      end
    end;
    if Assigned(Lev2Tn.Data) then
    begin
      Lev2Tn.Text := Lev2Tn.Text + ' ' + IntToStr(TList(Lev2Tn.Data).Count) +
                     ' (' + FloatToStr(Trunc(TList(Lev2Tn.Data).Count*100/m_ObjsOnPlan.Count*100)/100) +
                     '%)';
//      TList(Lev2Tn.Data).Sort(@ProcSortProdEff)
    end;
{
// OLD AUTOSCHED CONFIGURATION
    Lev2Tn := TVReport.Items.AddChild(Lev1Tn, _('Within delivery date tolerance'));
    for i := 0 to m_ObjsOnPlan.Count-1 do
    begin
      ReportRec := PTAutoSchedResult(m_ObjsOnPlan.items[i]);
      p_sc.GetDatesInfo(ReportRec.m_ObjID, DtInfo);

      if (DtInfo.endDate > DtInfo.DeliveryDate)
      and (DtInfo.endDate <= DtInfo.DeliveryDate + AutoSchedCfg.m_TollAfterDelDate) then
      begin
        if not Assigned(Lev2Tn.Data) then
          Lev2Tn.Data := TList.Create;
        TList(Lev2Tn.Data).Add(ReportRec);
      end
    end;
    if Assigned(Lev2Tn.Data) then
    begin
      Lev2Tn.Text := Lev2Tn.Text + ' ' + IntToStr(TList(Lev2Tn.Data).Count) +
                     ' (' + FloatToStr(Trunc(TList(Lev2Tn.Data).Count*100/m_ObjsOnPlan.Count*100)/100) +
                     '%)';
//      TList(Lev2Tn.Data).Sort(@ProcSortProdEff)
    end;
    Lev2Tn := TVReport.Items.AddChild(Lev1Tn, _('Over delivery date tolerance'));
    for i := 0 to m_ObjsOnPlan.Count-1 do
    begin
      ReportRec := PTAutoSchedResult(m_ObjsOnPlan.items[i]);
      p_sc.GetDatesInfo(ReportRec.m_ObjID, DtInfo);

      if (DtInfo.endDate > DtInfo.DeliveryDate + AutoSchedCfg.m_TollAfterDelDate) then
      begin
        if not Assigned(Lev2Tn.Data) then
          Lev2Tn.Data := TList.Create;
        TList(Lev2Tn.Data).Add(ReportRec);
      end

    end;
    if Assigned(Lev2Tn.Data) then
    begin
      Lev2Tn.Text := Lev2Tn.Text + ' ' + IntToStr(TList(Lev2Tn.Data).Count) +
                     ' (' + FloatToStr(Trunc(TList(Lev2Tn.Data).Count*100/m_ObjsOnPlan.Count*100)/100) +
                     '%)';
//      TList(Lev2Tn.Data).Sort(@ProcSortProdEff)
    end;
}
    Lev0Tn.Expand(true)
  end;

  if (m_ObjsInBin.Count > 0) then
  begin
    Lev0Tn := TVReport.Items.Add(nil, _('Not scheduled') +
                                      ' ' +  FloatToStr(m_ObjsInBin.Count) +
                                      ' (' + FloatToStr(Trunc(m_ObjsInBin.Count*100/TotLines*100)/100) +
                                       '%)');

    Lev1Tn := TVReport.Items.AddChild(Lev0Tn, _('No valid positions found'));

    if AutoSchedCfg.m_StopOnFirstNotSchedJob then
    begin
       Lev0Tn.Selected := true;
       m_Lev1Tn := Lev1Tn;
    end;

    for i := 0 to m_ObjsInBin.Count-1 do
    begin
      ReportRec := PTAutoSchedResult(m_ObjsInBin.items[i]);
      if ReportRec.m_ErrCode = 1 then
      begin
        if not Assigned(Lev1Tn.Data) then
          Lev1Tn.Data := TList.Create;
        TList(Lev1Tn.Data).Add(ReportRec);
      end
    end;
    if Assigned(Lev1Tn.Data) then
      Lev1Tn.Text := Lev1Tn.Text + ' ' + IntToStr(TList(Lev1Tn.Data).Count) +
                     ' (' + FloatToStr(Trunc(TList(Lev1Tn.Data).Count*100/m_ObjsInBin.Count*100)/100) +
                     '%)';
    Lev1Tn := TVReport.Items.AddChild(Lev0Tn, _('Already on plan'));
    for i := 0 to m_ObjsInBin.Count-1 do
    begin
      ReportRec := PTAutoSchedResult(m_ObjsInBin.items[i]);
      if ReportRec.m_ErrCode = 2 then
      begin
        if not Assigned(Lev1Tn.Data) then
          Lev1Tn.Data := TList.Create;
        TList(Lev1Tn.Data).Add(ReportRec);
      end
    end;
    if Assigned(Lev1Tn.Data) then
      Lev1Tn.Text := Lev1Tn.Text + ' ' + IntToStr(TList(Lev1Tn.Data).Count) +
                     ' (' + FloatToStr(Trunc(TList(Lev1Tn.Data).Count*100/m_ObjsInBin.Count*100)/100) +
                     '%)';
    Lev1Tn := TVReport.Items.AddChild(Lev0Tn, _('Priority warning'));
    for i := 0 to m_ObjsInBin.Count-1 do
    begin
      ReportRec := PTAutoSchedResult(m_ObjsInBin.items[i]);
      if ReportRec.m_ErrCode = 3 then
      begin
        if not Assigned(Lev1Tn.Data) then
          Lev1Tn.Data := TList.Create;
        TList(Lev1Tn.Data).Add(ReportRec);
      end
    end;
    if Assigned(Lev1Tn.Data) then
      Lev1Tn.Text := Lev1Tn.Text + ' ' + IntToStr(TList(Lev1Tn.Data).Count) +
                     ' (' + FloatToStr(Trunc(TList(Lev1Tn.Data).Count*100/m_ObjsInBin.Count*100)/100) +
                     '%)';
    Lev0Tn.Expand(true)
  end;
end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedRpt.TVReportChange(Sender: TObject; Node: TTreeNode);
var
  ReportRec: PTAutoSchedResult;
  i: integer;
  ListItem: TListItem;
  ObjId: TSchedID;
  isGrp: boolean;
  DtInfo:  TSQDatesInfo;
  PlanInfo:  TSQPlanInfo;
begin

  LVReport.Items.Clear;

  if Assigned(Node.Data) then
  begin
    ReportRec := PTAutoSchedResult(TList(Node.Data).Items[0]);
    if Assigned(ReportRec) then
    begin
      if not Assigned(ReportRec.m_ObjFather) then
        SetColForBin
      else
        SetColForPlan;
    end;

    for i := 0 to TList(Node.Data).Count-1 do
    begin
      ListItem := LVReport.Items.Add;
      ListItem.Data := TList(Node.Data).Items[i];
      if Assigned(ListItem.Data) then
      begin
        ReportRec := PTAutoSchedResult(ListItem.Data);
        ObjID := ReportRec.m_ObjID;
        ListItem.Caption := p_sc.GetObjInfo(ObjID, isGrp);
        if isGrp then
          ListItem.Caption := _('Group ') + ListItem.Caption
        else
          ListItem.Caption := _('Prod. req. ') + ListItem.Caption;
        p_sc.GetDatesInfo(ObjID, DtInfo);

        if Assigned(ReportRec.m_ObjFather) then
        begin
          ListItem.SubItems.Add(ReportRec.m_ObjFather.p_Father.GetDescr);
          ListItem.SubItems.Add(DateTimeToStr(DtInfo.startDate));
          ListItem.SubItems.Add(DateTimeToStr(DtInfo.endDate));
          ListItem.SubItems.Add(FormatDuration((DtInfo.startDate - DtInfo.PlannedStrDate)*24*60, true));
          ListItem.SubItems.Add(FormatDuration((DtInfo.endDate - DtInfo.PlannedEndDate)*24*60, true));
          ListItem.SubItems.Add(FormatDuration((DtInfo.startDate - DtInfo.LowStrDate)*24*60, true));
          ListItem.SubItems.Add(FormatDuration((DtInfo.endDate - DtInfo.HighEndDate)*24*60, true));
          ListItem.SubItems.Add(FormatDuration((DtInfo.endDate - DtInfo.DeliveryDate)*24*60, true));
          ListItem.SubItems.Add(IntToStr(ReportRec.m_ToResCompVal));

          ListItem.SubItems.Add(IntToStr(ReportRec.m_ToJobCompVal));
{
          prevId := TMqmActArea(ReportRec.m_ObjFather).GetPrecObj(DtInfo.startDate, prevId);
          if prevID = CSchedIdNull then
            ListItem.SubItems.Add('---')
          else
          begin
            FMQMPlan.EnterCompatModeInPlan(ObjID);
            p_sc.GetCompatWithOcc(prevId, compFor, compBack);
            ListItem.SubItems.Add(IntToStr(compFor));
            FMQMPlan.ExitCompatModeInPlan
          end;
}
          ListItem.SubItems.Add(IntToStr(ReportRec.m_ToCapResCompVal));
          p_sc.GetPlanInfo(ObjId, PlanInfo);
          ListItem.SubItems.Add(FormatDuration(PlanInfo.supMinReal - PlanInfo.supMinBase, true));
        end else
        begin
          ListItem.SubItems.Add(DateTimeToStr(DtInfo.PlannedStrDate));
          ListItem.SubItems.Add(DateTimeToStr(DtInfo.PlannedEndDate));
          ListItem.SubItems.Add(ReportRec.m_ErrDesc);
        end;
      end;
    end
  end else
    LVReport.Columns.Clear;
{
  if Assigned(m_SelectedObj) then
    Exclude(m_SelectedObj.m_ObjProp, objPr_SrchSelected);
  m_SelectedObj := nil;

  if Assigned(m_SelectedDestObj) then
    Exclude(m_SelectedDestObj.m_ObjProp, objPr_SrchSelected);
  m_SelectedDestObj := nil;

  MainPlan.RefreshActiveTab
}
end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedRpt.LVReportCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
//var
//  PlanType : TPlanType;
//  ObjId: TSchedID;
begin
  exit; //sav
//  if IsDynamicPlanActiv then
//    PlanType := PDynamic
//  else
//    PlanType := PNormal;

//  ObjID := PTAutoSchedResult(Item.Data).m_ObjID;
//  p_sc.GetColors(ObjID, true, CompValNotDef, PlanType, CSEG_All, Sender.Canvas);
end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedRpt.LVReportSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
var
  ObjId: TSchedID;
begin
  if not m_FormClose then
  begin
    ObjID := PTAutoSchedResult(Item.Data).m_ObjID;
    if Assigned(p_sc.GetExtLinkPtr(ObjID)) then
      FMQMPlan.FocusOnPlan(objID);
  end;
end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedRpt.FormCreate(Sender: TObject);
begin
  TranslateComponent (self);
  ScaleFormSize(Self, Screen.PixelsPerInch);
  BtnCanc.Left := Width - BtnCanc.Width - BtnOk.Width - 30;
  BtnOk.Left := Width - BtnOk.Width - 25;

  ReShape(Self);
  ReSHape(BtnCanc);
  ReShape(BtnOk);
end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedRpt.FormShow(Sender: TObject);
begin
  if AutoSchedCfg.m_StopOnFirstNotSchedJob and Assigned(m_Lev1Tn) then
  begin
    m_Lev1Tn.Selected := true;
    m_Lev1Tn.Focused := true;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedRpt.BtnCancClick(Sender: TObject);
var
  I : Integer;
begin
  for I := 0 to m_ObjList.GetLinkCount - 1 do
  begin
    p_sc.SetAutoSeqPrevNextIds(m_ObjList.GetLink(I), CSchedIDnull,true);
    p_sc.SetAutoSeqPrevNextIds(m_ObjList.GetLink(I), CSchedIDnull, false);
  end;

  if (MessageDlg(_('All the modificatons of the automatic sequencing will be lost. Do you want to continue?'), mtConfirmation, [mbYes, mbNo], 0)) = mrNo then
    ModalResult := mrNone
  else
    Close;
end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedRpt.JobDetail1Click(Sender: TObject);
var
  ObjId: TSchedID;
  StepDetails : TFStepDetails;
begin
  if (LVReport.Selected <> nil) then
  begin
    ObjID := PTAutoSchedResult(LVReport.Selected.Data).m_ObjID;
    StepDetails := TFStepDetails.CreateStepDetails(Self, ObjID);
    StepDetails.ShowModal;
    StepDetails.Free
  end;
end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedRpt.RefreshJobColorStatus;
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

//----------------------------------------------------------------------------//

procedure TFAutoSchedRpt.BtnOkClick(Sender: TObject);
begin
  RefreshJobColorStatus;
  //Close;
  ModalResult := mrOk;
end;

end.
