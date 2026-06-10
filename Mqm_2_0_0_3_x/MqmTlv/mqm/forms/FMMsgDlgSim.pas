unit FMMsgDlgSim;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, UReShape;

type
  TFMsgDlgSim = class(TForm)
    lblWarning: TLabel;
    lblRow1: TLabel;
    lblRow2: TLabel;
    lblRow3: TLabel;
    Bevel1: TBevel;
    bbtnOvrAll: TcxButton;
    btnAbort: TcxButton;
    bbtnOvrDelSim: TcxButton;
    procedure FormCreate(Sender: TObject);
    procedure bbtnOvrAllClick(Sender: TObject);
    procedure bbtnOvrDelSimClick(Sender: TObject);
    procedure btnAbortClick(Sender: TObject);
  public
    m_ResultMode: integer; // 0=Abort    1=Override    2=Override and delete Sim
  private
    procedure PlanOverride(DelAllSim: boolean);
  end;

var
  FMsgDlgSim: TFMsgDlgSim;

implementation

uses gnugettext;

{$R *.dfm}

//----------------------------------------------------------------------------//

procedure TFMsgDlgSim.FormCreate(Sender: TObject);
begin
  TranslateComponent (self);
  m_ResultMode := 0;

  lblWarning.Left := 0;
  lblWarning.Width := self.Width -1;
  lblRow1.Left := 0;
  lblRow1.Width := self.Width -1;
  lblRow2.Left := 0;
  lblRow2.Width := self.Width -1;
  lblRow3.Left := 0;
  lblRow3.Width := self.Width -1;
  Bevel1.Left := 0;
  Bevel1.Width := self.Width -1;

  ReShape(Self);
{  ReShape(bbtnOvrDelSim);
  ReShape(btnAbort);
  ReShape(bbtnOvrAll);}
end;

//----------------------------------------------------------------------------//

procedure TFMsgDlgSim.bbtnOvrAllClick(Sender: TObject);
begin
  PlanOverride(true);
end;

//----------------------------------------------------------------------------//

procedure TFMsgDlgSim.bbtnOvrDelSimClick(Sender: TObject);
begin
  PlanOverride(false);
end;

procedure TFMsgDlgSim.btnAbortClick(Sender: TObject);
begin
  Close;
end;

//----------------------------------------------------------------------------//

procedure TFMsgDlgSim.PlanOverride(DelAllSim: boolean);
var
  str : string;
begin
  str := _('Confirm the operation of override');
  if DelAllSim then
    str := str + ' ' + _('and delete all simulations?')
  else
    str := str + ' ' + _('and delete this simulation?');

  if MessageDlg(str, mtConfirmation, [mbYes, mbNo], 0) = idNo then
    exit
  else
    if DelAllSim then
      m_ResultMode := 1
    else
      m_ResultMode := 2;

  Close;
end;

//----------------------------------------------------------------------------//

end.
