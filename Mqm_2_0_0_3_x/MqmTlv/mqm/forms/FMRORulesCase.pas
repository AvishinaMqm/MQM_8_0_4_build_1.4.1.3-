unit FMRORulesCase;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, UMRulesComp,
  UMSchedContFunc,
  UMRes, UReSHape,
  gnugettext;

type

  TFRORulesCase = class(TForm)
    constructor CreateFrmRulesCase(AOwner: TComponent);
    procedure   FormClose(Sender: TObject; var Action: TCloseAction);
    procedure   SetObjectsRtO(id: TSchedId; res: TMqmRes);
    procedure FormCreate(Sender: TObject);
  private
    m_RulesComp: TMRulesComp;
  end;

  procedure OpenFrmRtORulesCase(AOwner: TComponent; id: TSchedId; res: TMqmRes);

var
  FRORulesCase: TFRORulesCase;

implementation

uses
  UMObjCont,
  UMActArea,
  UGGlobal;

{$R *.DFM}

//----------------------------------------------------------------------------//

procedure OpenFrmRtORulesCase(AOwner: TComponent; id: TSchedId; res: TMqmRes);
begin
  FRORulesCase := TFRORulesCase.CreateFrmRulesCase(AOWner);
  FRORulesCase.SetObjectsRtO(id, res);
  //ReShape(FRORulesCase);
  FRORulesCase.ShowModal;
end;

//----------------------------------------------------------------------------//

constructor TFRORulesCase.CreateFrmRulesCase(AOwner: TComponent);
begin
  inherited Create(AOwner);
  m_RulesComp := TMRulesComp.CreateRulesComp(self);
 // ReShape(m_RulesComp);
end;

//----------------------------------------------------------------------------//

procedure TFRORulesCase.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  FRORulesCase := nil
end;

//----------------------------------------------------------------------------//

procedure TFRORulesCase.SetObjectsRtO(id: TSchedId; res: TMqmRes);
var
  lst: TList;
begin
  lst := TList.Create;
  width := 900;
  Caption := _('Compatibility check results for resource ') + res.p_ResCode + ' ' + res.p_ResSDesc;
  res.ReportCompatRO(id, lst);
  m_RulesComp.UpdateROData(lst);
  height := (lst.Count+1) * 20 + 70;
  lst.Free
end;

//----------------------------------------------------------------------------//
procedure TFRORulesCase.FormCreate(Sender: TObject);
begin
  ScaleFormSize(Self, Screen.PixelsPerInch);
  TranslateComponent (self);
  ReShape(self);
end;

end.
