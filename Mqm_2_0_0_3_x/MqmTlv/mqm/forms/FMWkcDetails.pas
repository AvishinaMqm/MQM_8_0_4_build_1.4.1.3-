unit FMWkcDetails;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls,
  UMwkCtr, Grids,UMRes, gnugettext, UReShape;

type
  TFWkcDetails = class(TForm)
    PanBtn: TPanel;
    PGCres: TPageControl;
    TBgen: TTabSheet;
    TBprop: TTabSheet;
    TBrulesRtoO: TTabSheet;
    TBrulesOtoO: TTabSheet;
    Panel1: TPanel;
    LblResCode: TLabel;
    StResCode: TStaticText;
    LblResDescr: TLabel;
    StResDescr: TStaticText;
    LblWcCode: TLabel;
    STWcCod: TStaticText;
    STWcSDesc: TStaticText;
    LblWcSDescCode: TLabel;
    LblWcLDescCode: TLabel;
    STWcLDesc: TStaticText;
    TbAlt: TTabSheet;
    StringGrid1: TStringGrid;
    TreeViewProces: TTreeView;
    BtnOk: TcxButton;
    procedure FormCreate(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure PGCresDrawTab(Control: TCustomTabControl; TabIndex: Integer;
      const Rect: TRect; Active: Boolean);
  public
    constructor CreateWkcDet(AOwner: TComponent; wc : TMqmWrkCtr);
    constructor CreateWkcDetByResource(AOwner: TComponent; Res: TMqmRes);
  private
    m_wkc: TMqmWrkCtr;
    procedure InitValues;
    procedure InitCaption;
    procedure BuildTree;
  end;

implementation

{$R *.DFM}

uses
  UMUsrPropComp;

//----------------------------------------------------------------------------//

procedure TFWkcDetails.BuildTree;
var
  I, J: integer;
  tn1,tn2: TTreeNode;
  AltWc : TMqmWrkCtr;
  AltWcCode, AltProc, Process: string;
begin

   with TreeViewProces.Items do
   begin
     Clear;
     tn1 := Add(nil, _('Process'));
     for I := 0 to m_wkc.P_GetProccesCount -1 do
     begin
       Process := m_wkc.P_GetProcess[I];
       tn2 := AddChild(tn1, Process);
       for J := 0 to m_wkc.P_WkcProcList.P_GetAltProcListCount[Process] - 1  do
       begin
         AltWc := m_wkc.P_WkcProcList.GetAltProcList(Process,false).P_GetAltWc[J];
         AddChild(tn2, _('Alternative w.center') + ': ' +
             AltWcCode + ' - ' +
         AltWc.p_WrkCtrSDesc);
         m_wkc.GetAltProcForAltWrkCtr(Process, AltWc.p_WrkCtrCode , AltProc);
         AddChild(tn2, _('Alternative process') + ': ' + AltProc + ' ' +
                  m_wkc.P_WkcProcList.GetAltProcList(Process,false).GetAltProcDesc(AltProc));
       end;
     end;
   end;
end;

//----------------------------------------------------------------------------//

constructor TFWkcDetails.CreateWkcDetByResource(AOwner: TComponent; Res: TMqmRes);
begin
  inherited Create(AOwner);
  m_wkc := TMqmWrkCtr(Res.p_Father);
  StResCode.Caption := Res.p_ResCode;
  StResDescr.Caption := Res.p_ResSDesc;
end;

//----------------------------------------------------------------------------//

constructor TFWkcDetails.CreateWkcDet(AOwner: TComponent; wc : TMqmWrkCtr);
begin
  inherited Create(AOwner);
  m_wkc := Wc;
  StResCode.Caption := '';
  StResDescr.Caption := '';
end;

//----------------------------------------------------------------------------//

procedure TFWkcDetails.FormCreate(Sender: TObject);
begin
  TranslateComponent (self);
  InitCaption;
  InitValues;
  BuildTree;
  PGCres.ActivePage := TBgen;

  ReShape(Self);
 // ReShape(BtnOk);
end;

//----------------------------------------------------------------------------//

procedure TFWkcDetails.InitCaption;
begin
  StringGrid1.Cells[0,0] := _('Process code');
  StringGrid1.Cells[1,0] := _('Process desc');
  StringGrid1.Cells[2,0] := _('Alt w.center');
  StringGrid1.Cells[3,0] := _('Alt w.center desc');
  StringGrid1.Cells[4,0] := _('Alt process');
  StringGrid1.Cells[5,0] := _('Alt process desc');
end;

//----------------------------------------------------------------------------//

procedure TFWkcDetails.InitValues;
begin
  // initialize valued fields
  STWcCod.Caption   := m_wkc.p_WrkCtrCode;
  STWcSDesc.Caption := m_wkc.p_WrkCtrSDesc;
  STWcLDesc.Caption := m_wkc.p_WrkCtrLDesc;

//  TMPropComp.CreatePropComp(TBprop,      m_wkc.GetPropMtxs,      false, false);
//  TMPropComp.CreatePropComp(TBrulesRtoO, m_wkc.GetRulesRtoOMtxs, true,  false);
//  TMPropComp.CreatePropComp(TBrulesOtoO, m_wkc.GetRulesOtoOMtxs, true,  true)
end;

procedure TFWkcDetails.PGCresDrawTab(Control: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
begin
  with Control.Canvas do begin
    Brush.Color := clWhite;
    FillRect(Rect);
    TextOut(Rect.Left + Font.Size -5, Rect.Top + 2, (Control as TPageControl).Pages[TabIndex].Caption) ;
  end;
end;

procedure TFWkcDetails.BtnOkClick(Sender: TObject);
begin
  MOdalResult := mrOk;
 // Close;
end;

//----------------------------------------------------------------------------//
end.
