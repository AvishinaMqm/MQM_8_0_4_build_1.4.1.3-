unit FMBarConfigSets;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, CheckLst,UReShape,
  FMBarConfig,
  UGglobal,
  UMGlobal,
  gnugettext, Vcl.ExtCtrls;

type
  TFBarConfigSets = class(TForm)
    GroupBox1: TGroupBox;
    LblNewSetName: TLabel;
    EditNewSetName: TEdit;
    GroupBox2: TGroupBox;
    LBListOfSets: TListBox;
    BitDeleteSet: TcxButton;
    BitOpenSet: TcxButton;
    BtnSaveNewSet: TcxButton;
    BtnAbo: TcxButton;
    constructor Create(AOwner: TComponent;setTypeName: string); reintroduce;
    procedure BtnSaveNewSetClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitOpenSetClick(Sender: TObject);
    procedure BitCancelClick(Sender: TObject);
    procedure BitDeleteSetClick(Sender: TObject);
    procedure BtnAboClick(Sender: TObject);
    procedure LBListOfSetsDblClick(Sender: TObject);
//    procedure showActiveSet;
//    function  checkSetExist: boolean;

  private
    m_chkShowAsHint: TCheckBox;
    procedure ChkShowAsHintClick(Sender: TObject);
  public
    { Public declarations }

  end;

//var
//  FBarConfigSets: TFBarConfigSets;

implementation

{$R *.dfm}
var
  setType: string;

{
********************************************************************************
  Save new set
********************************************************************************
}

procedure TFBarConfigSets.BtnAboClick(Sender: TObject);
begin
  Close;
end;

procedure TFBarConfigSets.BtnSaveNewSetClick(Sender: TObject);
begin
  EditNewSetName.Text;
  if EditNewSetName.Text = '' then
    begin
      MessageDlg(_('Please enter a set name.'), mtWarning, [mbOK], 0);
      exit
    end;
{
 if not  FBarConfig.CheckNameIfValid(EditNewSetName.Text) then
 begin
   MessageDlg(_('This set name already exists in job or status bar sets. Please enter another.'), mtWarning, [mbOK], 0);
   exit
 end;
}
  LBListOfSets.Items.Add(EditNewSetName.Text); //add set to Sets ComboBox)
  FBarConfig.CreateNewSet(EditNewSetName.Text, setType);
 // FbarConfig.SaveBarDataToDB(false);,true,false);
  FbarConfig.Save(false, true,false, EditNewSetName.Text, setType);
//  MessageDlg(_('New set:') +'  '+ EditNewSetName.Text +' '+ _('saved.'), mtInformation, [mbOK], 0);
  EditNewSetName.Text := '';

  if LBListOfSets.Items.Count > 0 then
    LBListOfSets.Selected[0] := True;
end;

{
********************************************************************************
  Get set Type
********************************************************************************
}
constructor TFBarConfigSets.Create(AOwner: TComponent; setTypeName: string);
begin
  inherited Create(AOwner);
  setType := setTypeName;
  if setType = 'Job_bar' then
    Caption := _('Job bar sets')
  else
    Caption := _('Status bar sets');

  ReShape(Self);

end;

{
********************************************************************************
  Create form and add all set names to the list box
********************************************************************************
}
procedure TFBarConfigSets.FormCreate(Sender: TObject);
var
  WkcList: Tstrings;
  i: Integer;
begin
  TranslateComponent(self);
  WkcList := TstringList.Create;
  FBarConfig.GetSetNames(WkcList, setType);
  for i:= 0 to WkcList.count -1 do
  begin
    LBListOfSets.Items.Add(WkcList.Strings[i])
  end;

  if LBListOfSets.Items.Count > 0 then
    LBListOfSets.Selected[0] := True;

  // Add "Show as hint" checkbox for status bar config
  if setType <> 'Job_bar' then
  begin
    m_chkShowAsHint := TCheckBox.Create(Self);
    m_chkShowAsHint.Parent := GroupBox2;
    m_chkShowAsHint.Left := 39;
    m_chkShowAsHint.Top := 210;
    m_chkShowAsHint.Width := 250;
    m_chkShowAsHint.Caption := _('Show also as job hint');
    m_chkShowAsHint.Checked := IniAppGlobals.ShowStatusBarAsHint;
    m_chkShowAsHint.OnClick := ChkShowAsHintClick;
  end;

end;

procedure TFBarConfigSets.ChkShowAsHintClick(Sender: TObject);
begin
  IniAppGlobals.ShowStatusBarAsHint := m_chkShowAsHint.Checked;
end;

procedure TFBarConfigSets.LBListOfSetsDblClick(Sender: TObject);
begin
  BitOpenSetClick(Sender);
end;

{
********************************************************************************
  Open selected set config bar
********************************************************************************
}
procedure TFBarConfigSets.BitOpenSetClick(Sender: TObject);
var
  setName: String;
begin
  if LBListOfSets.ItemIndex < 0 then
  begin
    MessageDlg(_('Please select a set first !'), mtWarning, [mbOK], 0);
    exit;
  end;
  setName := LBListOfSets.Items.Strings[LBListOfSets.ItemIndex];

  fBarConfig := TFBarConfig.Create(Self,setType,setName);
  if FBarConfig.m_Abort then
  begin
    FBarConfig.deleteSet(SetName,SetType);
  //  FBarConfig.deleteWkcSet(SetName, SetType); //delete the set from the Work center list
    LBListOfSets.Items.Delete(LBListOfSets.ItemIndex);

    fBarConfig.free;
  end
  else
  begin
    fBarConfig.ShowModal;
    fBarConfig.free;
  end;
 // showActiveSet;
end;

{
********************************************************************************
  No set selected - cancelled.
********************************************************************************
}
procedure TFBarConfigSets.BitCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

{
********************************************************************************
  This procedure deletes the set.checks that at least one set remains.
********************************************************************************
}
procedure TFBarConfigSets.BitDeleteSetClick(Sender: TObject);
var
  setName: String;
begin
  if LBListOfSets.ItemIndex < 0 then exit;
  setName := LBListOfSets.Items.Strings[LBListOfSets.ItemIndex];

  if MessageDlg(_('Delete') +' '+ setName + ' '+ _('set ?'), mtWarning, [mbYes, mbNo], 0) in [mrNo] then
    exit;
//  if LBListOfSets.Count = 1 then
//  begin
//    MessageDlg(_('Unable to delete last and only set'), mtError, [mbOK], 0);
//    exit;
//  end;
  FBarConfig.deleteSet(SetName,SetType);
//  FbarConfig.SaveBarDataToDB(false);
  FBarConfig.Save(false, true, false, SetName, setType); // save BarData
  FBarConfig.deleteWkcSet(SetName, SetType); //delete the set from the Work center list
  LBListOfSets.Items.Delete(LBListOfSets.ItemIndex);
  //in case we deleted a set which had some wkc already in the table.
//  FBarConfig.SaveWkcSetToDB;
  FBarConfig.Save(false, false, true, SetName, setType);// save WkcSet
 // MessageDlg(_('Set deleted'), mtInformation, [mbOK], 0);

//  if setType = 'Job_bar' then
//    IniAppGlobals.JobBarTextSet := LBListOfSets.Items.Strings[0];
//  if setType = 'Status_bar' then
//    IniAppGlobals.StatusBarTextSet := LBListOfSets.Items.Strings[0];
 // showActiveSet;
end;

{
********************************************************************************
  Shows the Active set
********************************************************************************


procedure TFBarConfigSets.showActiveSet;
begin
  if checkSetExist then
  begin
    if setType = 'Job_bar' then
      STCurrentSet.Caption := IniAppGlobals.JobBarTextSet;
    if setType = 'Status_bar' then
      STCurrentSet.Caption := IniAppGlobals.StatusBarTextSet;
  end
  else
     STCurrentSet.Caption := _('None');
end;
 }
{
********************************************************************************
  checks that set exists , otherwise we can't show it no more.
********************************************************************************


function  TFBarConfigSets.checkSetExist: boolean;
var
  i: Integer;
  activeset: String;
begin
 // if setType = 'Job_bar' then
 //   activeset := IniAppGlobals.JobBarTextSet;
 // if setType = 'Status_bar' then
 //   activeset := IniAppGlobals.StatusBarTextSet;
  for i:= 0 to LBListOfSets.Count-1 do
  begin
    if activeset = LBListOfSets.Items.Strings[i] then
    begin
      result := true;
      exit;
    end;
  end;// for
  result := false;
end;
}

end.
