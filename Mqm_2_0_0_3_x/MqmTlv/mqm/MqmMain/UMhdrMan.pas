unit UMHdrMan;

interface

uses
  Controls,
  extctrls,
  Graphics,
  Forms,
  UGCal,
  UGShapeMan,
  UGHdrMan,
  ComCtrls,
  Winapi.Windows,
  classes,dialogs;

type

  TLogoImage  = procedure (AOwner: TWinControl);
  TCalScroll  = procedure (Sender: TObject);

  TMqmHdrCfgWc = class
    m_rh:    integer;
    m_rw:    integer;
    m_LogoImage : TLogoImage;
    constructor Create;
  end;

  TMqmHdrCfg = class(TGenHdrCfg)
    m_CalPanel:  TCalPanel;
    m_LogoImage: TLogoImage;
    m_CalScroll: TCalScroll;
    constructor Create; override;
  end;

  TMqmHdrManResources = class(TGenHdrMan)
    constructor CreateHdrMan(AOwner: TWinControl; hdrCfg: TGenHdrCfg; IsDynamic : boolean); override;
//    destructor  Destroy; override;
  private
    m_RW, m_RH: integer;
    m_LogoPanel: TPanel;
    m_LogoImage: TLogoImage;
    m_CalScroll: TCalScroll;
    procedure CreateLogoPanel;
    procedure OnCalScroll(Sender: TObject);
    procedure StatusBar1DrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
              const Rect: TRect);
  public
    m_MainPanel: TPanel;
    m_StatusPanel: TPanel;
    m_StBarInfo : TStatusBar;
    m_CalPanel: TCalPanel;
    property  P_LogoPanel : TPanel read m_LogoPanel;
  end;

implementation

uses
  sysutils,
  FMMainPlan,
  UMGlobal;

//----------------------------------------------------------------------------//

constructor TMqmHdrCfg.Create;
begin
  m_LogoImage := nil;
  m_CalScroll := nil
end;

//----------------------------------------------------------------------------//

constructor TMqmHdrManResources.CreateHdrMan(AOwner: TWinControl; hdrCfg: TGenHdrCfg; IsDynamic : boolean);
var
  mqmHdr: TMqmHdrCfg;
  MQMPlan : TFMQMPlan;
begin
  inherited Create(AOwner);
  MQMPlan := GetPlanView;
  mqmHdr := TMqmHdrCfg(hdrCfg);
  AOwner.DoubleBuffered := True;

  m_RH := mqmHdr.m_rh;
  m_RW := mqmHdr.m_rw;
  m_LogoImage := mqmHdr.m_LogoImage;
  m_CalScroll := mqmHdr.m_CalScroll;

  // the main panel is at the top of the owner
  m_MainPanel := TPanel.Create(AOwner);
  m_MainPanel.Parent      := AOwner;
  m_MainPanel.BevelOuter  := bvNone;
  m_MainPanel.BevelInner  := bvNone;
  m_MainPanel.BevelWidth  := 1;
  m_MainPanel.BorderStyle := bsNone;
  m_MainPanel.BorderWidth := 0;
  m_MainPanel.TabStop     := false;
  m_MainPanel.Align       := alTop;
  m_MainPanel.Height      := m_rh;
  m_MainPanel.Top         := 1;

  m_StatusPanel := TPanel.Create(AOwner);
  m_StatusPanel.Parent      := AOwner;
  m_StatusPanel.BevelOuter  := bvNone;
  m_StatusPanel.BevelInner  := bvNone;
  m_StatusPanel.BevelWidth  := 1;
  m_StatusPanel.BorderStyle := bsNone;
  m_StatusPanel.BorderWidth := 0;
  m_StatusPanel.TabStop     := false;
  m_StatusPanel.Align       := alTop;
  m_StatusPanel.Height      := FMQMPlan.StBarInfo.Height;
  m_StatusPanel.Top         := 0;
  m_StatusPanel.Color       := FMQMPlan.StBarInfo.Color;

  m_StBarInfo := TStatusBar.Create(AOwner);
  m_StBarInfo.Parent      := m_StatusPanel;
  m_StBarInfo.Align       := alClient;
  m_StBarInfo.color       := FMQMPlan.StBarInfo.Color;
 // m_StBarInfo.Height      := FMQMPlan.StBarInfo.Height;
  m_StBarInfo.Font.Size   := FMQMPlan.StBarInfo.Font.Size;

  m_StBarInfo.Font.Name   := 'Montserrat';
  m_StBarInfo.Panels      := FMQMPlan.StBarInfo.panels;
  m_StBarInfo.OnDrawPanel := StatusBar1DrawPanel;
//  m_StBarInfo.OnMouseMove    := FMQMPlan.StBarInfo.OnMouseMove;
  m_StBarInfo.Panels[1].Style := psOwnerDraw;
  m_StBarInfo.Panels[3].Style := psOwnerDraw;

  CreateLogoPanel;

  // the calendar
  m_CalPanel := TCalPanel.CreateCalPanel(m_MainPanel, csOneWeek, DBAppGlobals.StDateForPlan, IsDynamic);
  m_CalPanel.OnCalendarChanged := OnCalScroll
end;

//----------------------------------------------------------------------------//

procedure TMqmHdrManResources.CreateLogoPanel;
begin
  // the logo panel is at the left of the main panel
  m_LogoPanel := TPanel.Create(m_MainPanel);
  m_LogoPanel.Parent      := m_MainPanel;
  m_LogoPanel.BevelOuter  := bvRaised;
  m_LogoPanel.BevelInner  := bvLowered;
  m_LogoPanel.BevelWidth  := 1;
  m_LogoPanel.BorderStyle := bsNone;
  m_LogoPanel.BorderWidth := 0;
  m_LogoPanel.TabStop     := false;
  m_LogoPanel.Align       := alLeft;
  m_LogoPanel.Width       := m_RW;
  m_LogoPanel.AutoSize    := false;

  m_LogoImage(m_LogoPanel);
end;

//----------------------------------------------------------------------------//

procedure TMqmHdrManResources.StatusBar1DrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
              const Rect: TRect);
//var
//  Img : Graphics.TBitmap;
  // This bellow should be working correctly , still need to be tested
begin

{  Img := graphics.TBitmap.Create;
  try
  GetPlanView.ImageList1.GetBitmap(61, Img);
  except
  end;
  m_StBarInfo.Canvas.Draw(rect.Left+1,rect.top,Img);

  img.Free;   }
end;


//----------------------------------------------------------------------------//

procedure TMqmHdrManResources.OnCalScroll(Sender: TObject);
begin
  m_CalScroll(m_MainPanel.Owner.Owner)
end;

//----------------------------------------------------------------------------//

{ TMqmHdrCfgWc }

constructor TMqmHdrCfgWc.Create;
begin
  m_LogoImage := nil;
end;

end.
