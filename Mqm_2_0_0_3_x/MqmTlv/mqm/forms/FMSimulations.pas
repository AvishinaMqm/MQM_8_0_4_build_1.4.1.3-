unit FMSimulations;

interface

uses
  UReShape, cxButtons, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TEntryMode = (em_Save, em_Open, em_Delete);

  TFSimulations = class(TForm)
    LblSimSaved: TLabel;
    LblCode: TLabel;
    Bevel1: TBevel;
    EdtSimCode: TEdit;
    EdtSimDesc: TEdit;
    LblDescr: TLabel;
    BtnDelete: TcxButton;
    LBSimsSaved: TListBox;
    btnSave: TcxButton;
    btnOpen: TcxButton;
    btnClose: TBitBtn;
    constructor FrmCreate(AOwner: TComponent; EntryMode: TEntryMode);
    destructor  Destroy; override;
    procedure FormShow(Sender: TObject);
    procedure EdtSimCodeChange(Sender: TObject);
    procedure EdtSimCodeKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure LBSimsSavedClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure BtnDeleteClick(Sender: TObject);
  private
    m_EntryMode : TEntryMode;
    procedure RefreshData;
    procedure LoadDataSim;
  end;

var
  FSimulations: TFSimulations;

implementation

{$R *.dfm}

uses UReShape, DMSrvPC, UMGlobal, UMSimulations, FMMainPlan, gnugettext, UMObjCont;

//----------------------------------------------------------------------------//

constructor TFSimulations.FrmCreate(AOwner: TComponent; EntryMode: TEntryMode);
begin
  inherited Create(AOwner);
  TranslateComponent (self);
  m_EntryMode := EntryMode;

  LoadDataSim;
end;

//----------------------------------------------------------------------------//

destructor TFSimulations.Destroy;
begin
  inherited Destroy;
end;

//----------------------------------------------------------------------------//

procedure TFSimulations.LoadDataSim;
var
  tmpStrLst : TStringList;
  EnvOK: boolean;
begin
  tmpStrLst := TStringList.Create;
  p_Sim.GetAllSimsCode(tmpStrLst, EnvOK);

  if not EnvOK then
  begin
    MessageDlg(_('Is not possible to connect the database of simulations!'), mtError, [mbOK], 0);
    close;
  end;

  LBSimsSaved.Items.Clear;
  LBSimsSaved.Items := tmpStrLst;
  tmpStrLst.Free;
end;

//----------------------------------------------------------------------------//

procedure TFSimulations.FormShow(Sender: TObject);
begin
  RefreshData;
end;

//----------------------------------------------------------------------------//

procedure TFSimulations.RefreshData;
begin
  Caption := 'Simulations';

  EdtSimCode.Enabled := false;
  EdtSimDesc.Enabled := false;

  EdtSimCode.Text := '';
  EdtSimDesc.Text := '';

  btnOpen.Enabled := false;
  btnSave.Enabled := false;
  BtnDelete.Enabled := false;

  btnOpen.Visible := false;
  btnSave.Visible := false;
  BtnDelete.Visible := false;

  case m_EntryMode of
    em_Save:
      begin
        Caption := Caption + ' - ' + _('SAVE');
        EdtSimCode.Enabled := true;
        EdtSimDesc.Enabled := true;
        btnSave.Visible := true;
        if p_Sim.p_SimModeActive then
        begin
          EdtSimCode.Text := p_Sim.p_CurrSimCode;
          EdtSimDesc.Text := p_Sim.p_CurrSimDesc;
          btnSave.SetFocus;
        end else
          EdtSimCode.SetFocus;
      end;
    em_Open:
      begin
        Caption := Caption + ' - ' + _('OPEN');
        btnOpen.Visible := true;
      end;
    em_Delete:
      begin
        Caption := Caption + ' - ' + _('DELETE');
        BtnDelete.Visible := true;
      end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFSimulations.EdtSimCodeChange(Sender: TObject);
begin
  case m_EntryMode of
    em_Save:
        if Trim(EdtSimCode.Text) <> '' then
          btnSave.Enabled := true
        else
          btnSave.Enabled := false;
    em_Open:
        if Trim(EdtSimCode.Text) <> '' then
          btnOpen.Enabled := true
        else
          btnOpen.Enabled := false;
    em_Delete:
        if Trim(EdtSimCode.Text) <> '' then
          btnDelete.Enabled := true
        else
          btnDelete.Enabled := false;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFSimulations.EdtSimCodeKeyPress(Sender: TObject; var Key: Char);
begin
  // In according of characater of table name of database
  // is possible to use only numbers alphabetical Chars and underscore
  // All others chars are forbidden

{  if (not (Key in [#48..#57])) and (not (Key in [#65..#90])) and
     (not (Key in [#97..#122])) and (not (Key = #95)) and
     (Key <> Chr(VK_BACK)) then Abort;  }
end;

//----------------------------------------------------------------------------//

procedure TFSimulations.LBSimsSavedClick(Sender: TObject);
begin
  EdtSimCode.Text := LBSimsSaved.Items.Strings[LBSimsSaved.ItemIndex];
  EdtSimDesc.Text := p_Sim.p_SimStruct[EdtSimCode.Text].Desc;
end;

//----------------------------------------------------------------------------//

procedure TFSimulations.btnSaveClick(Sender: TObject);
var
  EnvOK : boolean;  // Not Used here!!!
  DoSave: boolean;
//  w: word;
begin

  case m_EntryMode of
    em_Save:
      begin

{
        if (not p_Sim.p_SimModeActive) and p_pl.ChangesMade then
        begin
          w := MessageDlg(_('Before entry in simulation mode is needed to save modifications. Confirm?'),
                        mtConfirmation, [mbYes, mbNo], 0);
          case w of
            mrNo: exit;
            mrYes: FMQMPlan.MISaveClick(Sender);
          end;
        end;
}
        DoSave := true;

        if p_Sim.SimExist(Trim(EdtSimCode.Text), EnvOK) and
           (p_Sim.p_CurrSimCode <> Trim(EdtSimCode.Text)) then
        begin
          if MessageDlg(_('Simulation already exist! Do you want overwrite it?'),
                 mtConfirmation, [mbYes, mbNo], 0) = idYes then
            DoSave := true
          else
            DoSave := false;
        end;

        if DoSave then
        begin
          if not p_Sim.SaveSim(EdtSimCode.Text, EdtSimDesc.Text, FMQMPlan.MainProgBar, EnvOK) then
          begin
            MessageDlg('Not possible to save the simulation', mtError, [mbOK], 0);
            exit;
          end else
            Close;
        end;

      end;

    em_Open:;
    em_Delete:;

  end;

end;

//----------------------------------------------------------------------------//

procedure TFSimulations.btnOpenClick(Sender: TObject);
var
  w : word;
  EnvOK: boolean;
begin

  case m_EntryMode of
    em_Save:;
    em_Open:
      begin

        if (not p_Sim.p_SimModeActive) and p_pl.ChangesMade then
        begin
          w := MessageDlg(_('Before entry in simulation mode is needed to save modifications. Confirm?'),
                        mtConfirmation, [mbYes, mbNo, mbCancel], 0);
          case w of
//            mrNo: exit;
            mrCancel: exit;
            mrYes: FMQMPlan.MISaveClick(Sender);
          end;
        end;

        if p_Sim.p_SimModeActive and p_pl.ChangesMade then
        begin
          w := MessageDlg(_('Before load new simulation do you want to save current simulation?'),
                 mtConfirmation, [mbYes, mbNo, mbCancel], 0);

          case w of
            mrCancel: exit;
            mrYes:
              if not p_Sim.SaveSim(p_Sim.p_CurrSimCode, p_Sim.p_CurrSimDesc,
                                   FMQMPlan.MainProgBar, EnvOK) then
              begin
                MessageDlg('Not possible to save the simulation', mtError, [mbOK], 0);
                exit
              end;

          end;
        end;

        p_Sim.OpenSim(EdtSimCode.Text, EnvOK);

        Close
      end;
    em_Delete:;
  end;

end;

//----------------------------------------------------------------------------//

procedure TFSimulations.BtnDeleteClick(Sender: TObject);
var
  str : string;
  EnvOk: boolean;
begin

  if p_Sim.p_CurrSimCode = LBSimsSaved.Items.Strings[LBSimsSaved.ItemIndex] then
    str := _('After delete this simulation will be load main plan.') + ' ' + #10;
  str := str + _('Do you really want to delete the simulation?');

  case m_EntryMode of
    em_Save:;
    em_Open:;
    em_Delete:
      begin

        if MessageDlg(str, mtConfirmation, [mbYes, mbNo], 0) = mrNo then
          exit
        else
          if not p_Sim.DeleteSimByCode(LBSimsSaved.Items.Strings[LBSimsSaved.ItemIndex], EnvOK) then
             MessageDlg(_('Is not possible to delete the simulation'), mtWarning, [MbOk], 0)
          else
          begin
            FMQMPlan.MIReloadClick(Sender);
            LoadDataSim;
            RefreshData;
          end;

      end;
  end;

end;

//----------------------------------------------------------------------------//

procedure TFSimulations.FormCreate(Sender: TObject);
begin
  ReShape(Self);
end;

end.
