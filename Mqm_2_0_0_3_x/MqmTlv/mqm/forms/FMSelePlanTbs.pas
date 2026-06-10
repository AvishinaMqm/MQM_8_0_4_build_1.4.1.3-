unit FMSelePlanTbs;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, UMTabCfg, CheckLst;

type
  TFMSeleTab = class(TForm)
    LstTabs: TCheckListBox;
    BitBtn1: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    m_planTbCfg : TPlanTabsCfg;
    procedure ShowTabsList;
  public
    function GetSelectedView: integer;
    function GetStatTab(I : Integer): boolean;
  public
    constructor CreateSeleTab(AOwner: TComponent; planTbCfg: TPlanTabsCfg);
  end;

implementation

{$R *.DFM}

//----------------------------------------------------------------------------//

constructor TFMSeleTab.CreateSeleTab(AOwner: TComponent; planTbCfg: TPlanTabsCfg);
begin
  inherited Create(AOwner);
  m_planTbCfg := planTbCfg;
end;

//----------------------------------------------------------------------------//

procedure TFMSeleTab.FormCreate(Sender: TObject);
begin
  ShowTabsList;
end;

//----------------------------------------------------------------------------//

function TFMSeleTab.GetStatTab(I : Integer) : boolean;
begin
  if LstTabs.Checked[I] then
    Result := true
  else
    Result := false;
end;

//----------------------------------------------------------------------------//

function TFMSeleTab.GetSelectedView: integer;
begin
  Result := 1
end;

//----------------------------------------------------------------------------//

procedure TFMSeleTab.ShowTabsList;
var
  i:   Integer;
  cfg: TPlanTabCfg;
begin
  for I := 0 to m_planTbCfg.p_GetTabsCount - 1 do
  begin
    cfg := TPlanTabCfg(m_planTbCfg.GetTab(I));
    LstTabs.Items.Add(cfg.name);
    if cfg.isView then
      LstTabs.Checked[I] := true
    else
      LstTabs.Checked[I] := false
  end;
end;

//----------------------------------------------------------------------------//

procedure TFMSeleTab.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  m_planTbCfg := nil;
end;

//----------------------------------------------------------------------------//

end.
