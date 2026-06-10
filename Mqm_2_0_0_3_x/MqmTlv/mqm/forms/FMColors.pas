unit FMColors;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, StdCtrls, Buttons, Menus, Mask, UMGridComptClr, Grids, UReShape;

type
  TMQMLegendItem = class(TWinControl)
    constructor CreateLegendItem(AOwner: TComponent);
    destructor Destroy; override;
  private
    BkGroundShape:  TShape;
    ItemImage:      TImage;
    LblDescription: TLabel;
    procedure SetCaption(Caption: string);
    function GetCaption: string;
    procedure SetIcon(Icon: TIcon);
    function GetIcon: TIcon;

    property p_Caption: string  read GetCaption write SetCaption;
    property p_Icon: TIcon      read GetIcon    write SetIcon;
  end;

  TFColors = class(TForm)
    PanBtn: TPanel;
    PGCmain: TPageControl;
    TBJobtCmpt: TTabSheet;
    PanelJobToJob: TPanel;
    PanelJobToCap: TPanel;
    PanelJobCapToRes: TPanel;
    LblJobToJob: TLabel;
    LblJobToRes: TLabel;
    LblJobToCap: TLabel;
    TbsJobStatus: TTabSheet;
    PnlJobStatus: TPanel;
    TabResColor: TTabSheet;
    PanelResColr: TPanel;
    TabCapResColor: TTabSheet;
    PnlCapRes: TPanel;
    TbsBinIcons: TTabSheet;
    GBStatus: TGroupBox;
    GBWarnings: TGroupBox;
    GBOverlaps: TGroupBox;
    GBDelFrc: TGroupBox;
    GBHighFrc: TGroupBox;
    GBLowFrc: TGroupBox;
    TbsDateWarnings: TTabSheet;
    PnlDateWarnings: TPanel;
    TbsMaterialsWarnings: TTabSheet;
    PnlMaterialsWarning: TPanel;
    BtnOk: TcxButton;
    BtnCanc: TcxButton;
    procedure FormCreate(Sender: TObject);
    procedure BtnCancClick(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PGCmainDrawTab(Control: TCustomTabControl; TabIndex: Integer;
      const Rect: TRect; Active: Boolean);
  private
    m_JobToJobCmptColor:    TColorCompt;
    m_JobToCapCmptColor:    TColorCompt;
    m_JobCapToResCmptColor: TColorCompt;
    m_JobStatusColor:       TColorCompt;
    m_DateWarningColor:     TColorCompt;
    m_MaterialWarningColor: TColorCompt;
    m_ResColor:             TColorCompt;
    m_CapResColor:          TColorCompt;
    LegItemHighFrcHdr:     TMQMLegendItem;
    LegItemHighFrcAlwd:    TMQMLegendItem;
    LegItemHighFrcNotAlwd: TMQMLegendItem;
    LegItemLowFrcHdr:      TMQMLegendItem;
    LegItemLowFrcAlwd:     TMQMLegendItem;
    LegItemLowFrcNotAlwd:  TMQMLegendItem;
    LegItemDelFrcHdr:      TMQMLegendItem;
    LegItemDelFrcAlwd:     TMQMLegendItem;
    LegItemDelFrcNotAlwd:  TMQMLegendItem;

    LegItemStatusHdr:   TMQMLegendItem;
    LegItemNotSched:    TMQMLegendItem;
    LegItemOnGanttTemp: TMQMLegendItem;
    LegItemOnGanttFix:  TMQMLegendItem;
    LegItemIniProg:     TMQMLegendItem;
    LegItemGenProg:     TMQMLegendItem;
    LegItemFinalProg:   TMQMLegendItem;
    LegItemClosed:      TMQMLegendItem;

    LegItemWarningHdr: TMQMLegendItem;
    LegItemNoWarning:  TMQMLegendItem;
    LegItemDelDate:    TMQMLegendItem;
    LegItemHighDate:   TMQMLegendItem;
    LegItemLowDate:    TMQMLegendItem;
    LegItemNoMessages: TMQMLegendItem;
    LegItemGetMessages: TMQMLegendItem;
    LegItemSentMessages: TMQMLegendItem;
    LegItemGetSentMessages: TMQMLegendItem;

    LegItemOvlpHdr:    TMQMLegendItem;
    LegItemNoOvlp:     TMQMLegendItem;
    LegItemMatDate:    TMQMLegendItem;
    LegItemAddRes:     TMQMLegendItem;
    LegItemOvlpPrev:   TMQMLegendItem;
    LegItemOvlpNext:   TMQMLegendItem;
    LegItemOvlpBoth:   TMQMLegendItem;
    LegItemOvlpForced: TMQMLegendItem;

    procedure InitComponents;
    function SetCompatColors : boolean;

  public
    constructor CreateColorsForm(AOwner : TComponent);
  end;

implementation

{$R *.DFM}

uses
  gnugettext,
  UMSchedCont,
  UMGlobal,
  UMPlanGraph,
  UMObjCont,
  FMMainPlan;
//  UGDpiChange;

//----------------------------------------------------------------------------//

procedure TFColors.FormCreate(Sender: TObject);
begin
  TranslateComponent (self);
  InitComponents;
  PGCmain.ActivePage := TBJobtCmpt;

  ReShape(self);

end;

//----------------------------------------------------------------------------//

procedure TFColors.BtnCancClick(Sender: TObject);
begin
  ModalResult := mrAbort;
end;

//----------------------------------------------------------------------------//

procedure TFColors.InitComponents;
var
  VertSpace: integer;
begin
  m_JobToJobCmptColor := TColorCompt.CreateColorCompt(self, DBAppGlobals.JobToJobCompColor, DfltCmpClr,  Ct_JobToJob);
  m_JobToJobCmptColor.Parent := PanelJobToJob;
  m_JobToJobCmptColor.Align := alClient;

  m_JobToCapCmptColor := TColorCompt.CreateColorCompt(self, DBAppGlobals.JobToCapCompColor, DfltCmpClr, Ct_JobToCap);
  m_JobToCapCmptColor.Parent := PanelJobToCap;
  m_JobToCapCmptColor.Align := alClient;

  m_JobCapToResCmptColor := TColorCompt.CreateColorCompt(self, DBAppGlobals.JobCapToRscCompColor, DfltCmpClr, Ct_JobCapToRes);
  m_JobCapToResCmptColor.Parent := PanelJobCapToRes;
  m_JobCapToResCmptColor.Align := alClient;

  m_JobStatusColor := TColorCompt.CreateColorCompt(self, DBAppGlobals.JobStatusColor, DfltJobStatusClr, Ct_Error);
  m_JobStatusColor.Parent := PnlJobStatus;
  m_JobStatusColor.Align := alClient;

  m_DateWarningColor := TColorCompt.CreateColorCompt(self, DBAppGlobals.JobDateWarningColor, DfltJobDateWrnClr, Ct_Error);
  m_DateWarningColor.Parent := PnlDateWarnings;
  m_DateWarningColor.Align := alClient;

  m_MaterialWarningColor := TColorCompt.CreateColorCompt(self, DBAppGlobals.JobMatWarningColor, DfltJobMatWrnClr, Ct_Error);
  m_MaterialWarningColor.Parent := PnlMaterialsWarning;
  m_MaterialWarningColor.Align := alClient;

  m_ResColor := TColorCompt.CreateColorCompt(self, DBAppGlobals.ResColors, DfltRscClr, Ct_ResColor);
  m_ResColor.Parent := PanelResColr;
  m_ResColor.Align := alClient;

  m_CapResColor := TColorCompt.CreateColorCompt(self, DBAppGlobals.CapResColors, DfltCmpClr, Ct_CapResColor);
  m_CapResColor.Parent := PnlCapRes;
  m_CapResColor.Align := alClient;

  VertSpace := 3;

  LegItemHighFrcHdr := TMQMLegendItem.CreateLegendItem(TbsBinIcons);
  with LegItemHighFrcHdr do
  begin
    Parent := TbsBinIcons;
    top := GBHighFrc.Top -4;
    Left := GBHighFrc.Left + 4;
    p_Caption := _('Crossing latest end date');
    FMQMPlan.ImageList1.GetIcon(27, p_Icon);
  end;

  LegItemHighFrcAlwd := TMQMLegendItem.CreateLegendItem(GBHighFrc);
  with LegItemHighFrcAlwd do
  begin
    Parent := GBHighFrc;
    top := 20;
    Left := 10;
    p_Caption := _('Allowed');
  end;

  LegItemHighFrcNotAlwd := TMQMLegendItem.CreateLegendItem(GBHighFrc);
  with LegItemHighFrcNotAlwd do
  begin
    Parent := GBHighFrc;
    top := LegItemHighFrcAlwd.Top + LegItemHighFrcAlwd.Height + VertSpace;
    Left := LegItemHighFrcAlwd.Left;
    p_Caption := _('Not allowed');
    FMQMPlan.ImageList1.GetIcon(23, p_Icon);
  end;

  LegItemLowFrcHdr := TMQMLegendItem.CreateLegendItem(TbsBinIcons);
  with LegItemLowFrcHdr do
  begin
    Parent := TbsBinIcons;
    top := GBLowFrc.Top -4;
    Left := GBLowFrc.Left + 4;
    p_Caption := _('Crossing earliest date');
    FMQMPlan.ImageList1.GetIcon(26, p_Icon);
  end;

  LegItemLowFrcAlwd := TMQMLegendItem.CreateLegendItem(GBLowFrc);
  with LegItemLowFrcAlwd do
  begin
    Parent := GBLowFrc;
    top := 20;
    Left := 10;
    p_Caption := _('Allowed');
  end;

  LegItemLowFrcNotAlwd := TMQMLegendItem.CreateLegendItem(GBLowFrc);
  with LegItemLowFrcNotAlwd do
  begin
    Parent := GBLowFrc;
    top := LegItemLowFrcAlwd.Top + LegItemLowFrcAlwd.Height + VertSpace;
    Left := LegItemLowFrcAlwd.Left;
    p_Caption := _('Not allowed');
    FMQMPlan.ImageList1.GetIcon(23, p_Icon);
  end;

  LegItemDelFrcHdr := TMQMLegendItem.CreateLegendItem(TbsBinIcons);
  with LegItemDelFrcHdr do
  begin
    Parent := TbsBinIcons;
    top := GBDelFrc.Top -4;
    Left := GBDelFrc.Left + 4;
    p_Caption := _('Crossing delivery date');
    FMQMPlan.ImageList1.GetIcon(25, p_Icon);
  end;

  LegItemDelFrcAlwd := TMQMLegendItem.CreateLegendItem(GBDelFrc);
  with LegItemDelFrcAlwd do
  begin
    Parent := GBDelFrc;
    top := 20;
    Left := 10;
    p_Caption := _('Allowed');
  end;

  LegItemDelFrcNotAlwd := TMQMLegendItem.CreateLegendItem(GBDelFrc);
  with LegItemDelFrcNotAlwd do
  begin
    Parent := GBDelFrc;
    top := LegItemDelFrcAlwd.Top + LegItemDelFrcAlwd.Height + VertSpace;
    Left := LegItemDelFrcAlwd.Left;
    p_Caption := _('Not allowed');
    FMQMPlan.ImageList1.GetIcon(23, p_Icon);
  end;

  // Status
  LegItemStatusHdr := TMQMLegendItem.CreateLegendItem(TbsBinIcons);
  with LegItemStatusHdr do
  begin
    Parent := TbsBinIcons;
    top := GBStatus.Top -4;
    Left := GBStatus.Left + 4;
    p_Caption := _('Status');
    FMQMPlan.ImageList1.GetIcon(32, p_Icon);
  end;

  LegItemNotSched := TMQMLegendItem.CreateLegendItem(GBStatus);
  with LegItemNotSched do
  begin
    Parent := GBStatus;
    top := 20;
    Left := 10;
    p_Caption := _('Entity not scheduled');
  end;

  LegItemOnGanttTemp := TMQMLegendItem.CreateLegendItem(GBStatus);
  with LegItemOnGanttTemp do
  begin
    Parent := GBStatus;
    top := LegItemNotSched.Top + LegItemNotSched.Height + VertSpace;
    Left := LegItemNotSched.Left;
    p_Caption := _('Temporarily scheduled');
    FMQMPlan.ImageList1.GetIcon(21, p_Icon);
  end;

  LegItemOnGanttFix := TMQMLegendItem.CreateLegendItem(GBStatus);
  with LegItemOnGanttFix do
  begin
    Parent := GBStatus;
    top := LegItemOnGanttTemp.Top + LegItemOnGanttTemp.Height + VertSpace;
    Left := LegItemOnGanttTemp.Left;
    p_Caption := _('Fixed scheduled');
    FMQMPlan.ImageList1.GetIcon(20, p_Icon);
  end;

  LegItemIniProg := TMQMLegendItem.CreateLegendItem(GBStatus);
  with LegItemIniProg do
  begin
    Parent := GBStatus;
    top := LegItemOnGanttFix.Top + LegItemOnGanttFix.Height + VertSpace;
    Left := LegItemOnGanttFix.Left;
    p_Caption := _('Initial progress');
    FMQMPlan.ImageList1.GetIcon(29, p_Icon);
  end;

  LegItemGenProg := TMQMLegendItem.CreateLegendItem(GBStatus);
  with LegItemGenProg do
  begin
    Parent := GBStatus;
    top := LegItemIniProg.Top + LegItemIniProg.Height + VertSpace;
    Left := LegItemIniProg.Left;
    p_Caption := _('Generic progress');
    FMQMPlan.ImageList1.GetIcon(30, p_Icon);
  end;

  LegItemFinalProg := TMQMLegendItem.CreateLegendItem(GBStatus);
  with LegItemFinalProg do
  begin
    Parent := GBStatus;
    top := LegItemGenProg.Top + LegItemGenProg.Height + VertSpace;
    Left := LegItemGenProg.Left;
    p_Caption := _('Final progress');
    FMQMPlan.ImageList1.GetIcon(31, p_Icon);
  end;

  LegItemClosed := TMQMLegendItem.CreateLegendItem(GBStatus);
  with LegItemClosed do
  begin
    Parent := GBStatus;
    top := LegItemFinalProg.Top + LegItemFinalProg.Height + VertSpace;
    Left := LegItemFinalProg.Left;
    p_Caption := _('Step closed');
    FMQMPlan.ImageList1.GetIcon(33, p_Icon);
  end;

  // Warnings
  LegItemWarningHdr := TMQMLegendItem.CreateLegendItem(TbsBinIcons);
  with LegItemWarningHdr do
  begin
    Parent := TbsBinIcons;
    top := GBWarnings.Top -4;
    Left := GBWarnings.Left + 4;
    p_Caption := _('Dates warnings and messages');
    FMQMPlan.ImageList1.GetIcon(16, p_Icon);
    Width := Width - 20;
  end;

  LegItemNoWarning := TMQMLegendItem.CreateLegendItem(GBWarnings);
  with LegItemNoWarning do
  begin
    Parent := GBWarnings;
    top := 20;
    Left := 10;
    p_Caption := _('No warnings');
  end;

  LegItemDelDate := TMQMLegendItem.CreateLegendItem(GBWarnings);
  with LegItemDelDate do
  begin
    Parent := GBWarnings;
    top := LegItemNoWarning.Top + LegItemNoWarning.Height + VertSpace;
    Left := LegItemNoWarning.Left;
    p_Caption := _('Delivery date');
    FMQMPlan.ImageList1.GetIcon(37, p_Icon);
  end;

  LegItemHighDate := TMQMLegendItem.CreateLegendItem(GBWarnings);
  with LegItemHighDate do
  begin
    Parent := GBWarnings;
    top := LegItemDelDate.Top + LegItemDelDate.Height + VertSpace;
    Left := LegItemDelDate.Left;
    p_Caption := _('Latest end date');
    FMQMPlan.ImageList1.GetIcon(35, p_Icon);
  end;

  LegItemLowDate := TMQMLegendItem.CreateLegendItem(GBWarnings);
  with LegItemLowDate do
  begin
    Parent := GBWarnings;
    top := LegItemHighDate.Top + LegItemHighDate.Height + VertSpace;
    Left := LegItemHighDate.Left;
    p_Caption := _('Earliest start date');
    FMQMPlan.ImageList1.GetIcon(34, p_Icon);
  end;

  LegItemNoMessages := TMQMLegendItem.CreateLegendItem(GBWarnings);
  with LegItemNoMessages do
  begin
    Parent := GBWarnings;
    top := LegItemLowDate.Top + LegItemLowDate.Height + VertSpace;
    Left := LegItemLowDate.Left;
    p_Caption := _('No Messages');
  end;

  LegItemGetMessages := TMQMLegendItem.CreateLegendItem(GBWarnings);
  with LegItemGetMessages do
  begin
    Parent := GBWarnings;
    top := LegItemNoMessages.Top + LegItemNoMessages.Height + VertSpace;
    Left := LegItemNoMessages.Left;
    p_Caption := _('Job get Message');
    FMQMPlan.ImageList1.GetIcon(54, p_Icon);
  end;

  LegItemSentMessages := TMQMLegendItem.CreateLegendItem(GBWarnings);
  with LegItemSentMessages do
  begin
    Parent := GBWarnings;
    top := LegItemGetMessages.Top + LegItemGetMessages.Height + VertSpace;
    Left := LegItemGetMessages.Left;
    p_Caption := _('Job sent Message');
    FMQMPlan.ImageList1.GetIcon(55, p_Icon);
  end;

  LegItemGetSentMessages := TMQMLegendItem.CreateLegendItem(GBWarnings);
  with LegItemGetSentMessages do
  begin
    Parent := GBWarnings;
    top := LegItemSentMessages.Top + LegItemSentMessages.Height + VertSpace;
    Left := LegItemSentMessages.Left;
    p_Caption := _('Job get/sent Message');
    FMQMPlan.ImageList1.GetIcon(56, p_Icon);
  end;

  // Overlaps
  LegItemOvlpHdr := TMQMLegendItem.CreateLegendItem(TbsBinIcons);
  with LegItemOvlpHdr do
  begin
    Parent := TbsBinIcons;
    top := GBOverlaps.Top -4;
    Left := GBOverlaps.Left + 4;
    p_Caption := _('Materials warnings');
    FMQMPlan.ImageList1.GetIcon(24, p_Icon);
  end;

  LegItemNoOvlp := TMQMLegendItem.CreateLegendItem(GBWarnings);
  with LegItemNoOvlp do
  begin
    Parent := GBOverlaps;
    top := 20;
    Left := 10;
    p_Caption := _('No warnings');
  end;

  LegItemMatDate := TMQMLegendItem.CreateLegendItem(GBWarnings);
  with LegItemMatDate do
  begin
    Parent := GBOverlaps;
    top := LegItemNoOvlp.Top + LegItemNoOvlp.Height + VertSpace;
    Left := LegItemNoOvlp.Left;
    p_Caption := _('Not enough materials');
    FMQMPlan.ImageList1.GetIcon(36, p_Icon);
  end;

  LegItemAddRes := TMQMLegendItem.CreateLegendItem(GBWarnings);
  with LegItemAddRes do
  begin
    Parent := GBOverlaps;
    top := LegItemMatDate.Top + LegItemMatDate.Height + VertSpace;
    Left := LegItemMatDate.Left;
    p_Caption := _('Not enough additional resources');
    FMQMPlan.ImageList1.GetIcon(49, p_Icon);
  end;

  LegItemOvlpPrev := TMQMLegendItem.CreateLegendItem(GBWarnings);
  with LegItemOvlpPrev do
  begin
    Parent := GBOverlaps;
    top := LegItemAddRes.Top + LegItemAddRes.Height + VertSpace;
    Left := LegItemAddRes.Left;
    p_Caption := _('Not enough quantity from previous step');
    FMQMPlan.ImageList1.GetIcon(38, p_Icon);
  end;

  LegItemOvlpNext := TMQMLegendItem.CreateLegendItem(GBWarnings);
  with LegItemOvlpNext do
  begin
    Parent := GBOverlaps;
    top := LegItemOvlpPrev.Top + LegItemOvlpPrev.Height + VertSpace;
    Left := LegItemOvlpPrev.Left;
    p_Caption := _('Not enough quantity for next step');
    FMQMPlan.ImageList1.GetIcon(39, p_Icon);
  end;

  LegItemOvlpBoth := TMQMLegendItem.CreateLegendItem(GBWarnings);
  with LegItemOvlpBoth do
  begin
    Parent := GBOverlaps;
    top := LegItemOvlpNext.Top + LegItemOvlpNext.Height + VertSpace;
    Left := LegItemOvlpNext.Left;
    p_Caption := _('No qty from prev. and to next step');
    FMQMPlan.ImageList1.GetIcon(40, p_Icon);
  end;

  LegItemOvlpForced := TMQMLegendItem.CreateLegendItem(GBWarnings);
  with LegItemOvlpForced do
  begin
    Parent := GBOverlaps;
    top := LegItemOvlpBoth.Top + LegItemOvlpBoth.Height + VertSpace;
    Left := LegItemOvlpBoth.Left;
    p_Caption := _('Overlap not allowed');
    FMQMPlan.ImageList1.GetIcon(23, p_Icon);
  end;

end;

procedure TFColors.PGCmainDrawTab(Control: TCustomTabControl; TabIndex: Integer;
  const Rect: TRect; Active: Boolean);
begin
  with Control.Canvas do begin
    Brush.Color := clWhite;
    FillRect(Rect);
    TextOut(Rect.Left + Font.Size -5, Rect.Top + 2, (Control as TPageControl).Pages[TabIndex].Caption) ;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFColors.BtnOkClick(Sender: TObject);
begin
  if SetCompatColors then
  begin
    ModalResult := mrOK;
    if m_CapResColor.CheckChanges then
      p_pl.UpdateCapResColorDesc;
  end
  else
    ModalResult := mrCancel
end;

//----------------------------------------------------------------------------//

procedure TFColors.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  m_JobToJobCmptColor.free;
  m_JobToCapCmptColor.free;
  m_JobCapToResCmptColor.free;
  m_JobStatusColor.free;
  m_DateWarningColor.free;
  m_MaterialWarningColor.free;
  m_ResColor.free;
  m_CapResColor.free;
end;

//----------------------------------------------------------------------------//

function TFColors.SetCompatColors : boolean;
begin
  Result := false;
  if m_JobToJobCmptColor.CheckChanges then
  begin
    m_JobToJobCmptColor.SetCompColorFromTemp;
    Result := true;
  end;
  if m_JobToCapCmptColor.CheckChanges then
  begin
    m_JobToCapCmptColor.SetCompColorFromTemp;
    Result := true;
  end;
  if m_JobCapToResCmptColor.CheckChanges then
  begin
    m_JobCapToResCmptColor.SetCompColorFromTemp;
    Result := true;
  end;
  if m_JobStatusColor.CheckChanges then
  begin
    m_JobStatusColor.SetCompColorFromTemp;
    Result := true;
  end;
  if m_DateWarningColor.CheckChanges then
  begin
    m_DateWarningColor.SetCompColorFromTemp;
    Result := true;
  end;
  if m_MaterialWarningColor.CheckChanges then
  begin
    m_MaterialWarningColor.SetCompColorFromTemp;
    Result := true;
  end;
  if m_ResColor.CheckChanges then
  begin
    m_ResColor.SetCompColorFromTemp;
    Result := true;
  end;
  if m_CapResColor.CheckChanges then
  begin
    m_CapResColor.SetCompColorFromTemp;
    Result := true;
  end;
end;

//----------------------------------------------------------------------------//

constructor TFColors.CreateColorsForm(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if GetScreenDPI = 120 then
  begin
    Width := 1000;
    //PanelJobToJob.Left
   {
    PanelJobToJob.Width := 257;
    PanelJobToCap.Left  := 257 + 37;
    PanelJobToCap.Width := 257;
    PanelJobCapToRes.Left := PanelJobToCap.Left +  PanelJobToCap.Width + 4 ;
    PanelJobCapToRes.Width := 257;
    showmessage('Changed');
    }
  end;  
end;

//----------------------------------------------------------------------------//
// TMQMLegendItem
//----------------------------------------------------------------------------//

constructor TMQMLegendItem.CreateLegendItem(AOwner: TComponent);
begin
  inherited Create(AOwner);

  BkGroundShape := TShape.Create(self);
  with BkGroundShape do
  begin
    Parent := Self;
    Shape := stRectangle;
    Top := 0;
    Left := 0;
    Width := 19;
    Height := 19;
  end;

  ItemImage := TImage.Create(self);
  with ItemImage do
  begin
    Parent := Self;
    Top := 1;
    Left := 1;
    Width := 16;
    Height := 16;
  end;

  LblDescription := TLabel.Create(self);
  with LblDescription do
  begin
    Parent := Self;
    AutoSize := false;
    Top := 3;
    Left := BkGroundShape.Left + BkGroundShape.Width+3;
    if Screen.PixelsPerInch = 96 then // 100%
      Width := 245
    else if Screen.PixelsPerInch = 120 then  // 125%
      Width := 265
    else if Screen.PixelsPerInch = 144 then  // 150%
      Width := 265;
  end;

  Width := BkGroundShape.Width + LblDescription.Width + 6;
  Height := BkGroundShape.Height;
end;

//----------------------------------------------------------------------------//

destructor TMQMLegendItem.Destroy;
begin
  inherited Destroy;
end;

//----------------------------------------------------------------------------//

procedure TMQMLegendItem.SetCaption(Caption: string);
begin
  LblDescription.Caption := Caption;
  Width := BkGroundShape.Width + LblDescription.Width + 6;
end;

//----------------------------------------------------------------------------//

function TMQMLegendItem.GetCaption: string;
begin
  Result := LblDescription.Caption
end;

//----------------------------------------------------------------------------//

procedure TMQMLegendItem.SetIcon(Icon: TIcon);
begin
  ItemImage.Picture.Icon := Icon;
end;

//----------------------------------------------------------------------------//

function TMQMLegendItem.GetIcon: TIcon;
begin
  Result := ItemImage.Picture.Icon
end;

//----------------------------------------------------------------------------//

end.


