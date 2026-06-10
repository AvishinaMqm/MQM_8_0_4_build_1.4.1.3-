unit FMBarConfigSets;

interface

uses
  UReShape, cxButtons, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, CheckLst,
  FMBarConfig,
  UGglobal,
  UMGlobal,
  gnugettext;

type
  TFBarConfigSets = class(TForm)
    GroupBox1: TGroupBox;
    LblNewSetName: TLabel;
    EditNewSetName: TEdit;
    BtnSaveNewSet: TcxButton;
    GroupBox2: TGroupBox;
    LBListOfSets: TListBox;
    BitDeleteSet: TBitBtn;
    BitOpenSet: TBitBtn;
    constructor Create(AOwner: TComponent;setTypeName: string); reintroduce;
    procedure BtnSaveNewSetClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitOpenSetClick(Sender: TObject);
    procedure BitCancelClick(Sender: TObject);
    procedure BitDeleteSetClick(Sender: TObject);
//    procedure showActiveSet;
//    function  checkSetExist: boolean;

  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  FBarConfigSets: TFBarConfigSets;

implementation

{$R *.dfm}
var
  setType: string;

{
********************************************************************************
  Save new set
********************************************************************************
}

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
  FbarConfig.SaveBarDataToDB(false);
//  MessageDlg(_('New set:') +'  '+ EditNewSetName.Text +' '+ _('saved.'), mtInformation, [mbOK], 0);
  EditNewSetName.Text := '';
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
//  showActiveSet;
  ReShape(Self);
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
  fBarConfig.ShowModal;
  fBarConfig.free;

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
  FbarConfig.SaveBarDataToDB(false);
  FBarConfig.deleteWkcSet(SetName, SetType); //delete the set from the Work center list
  LBListOfSets.Items.Delete(LBListOfSets.ItemIndex);
  //in case we deleted a set which had some wkc already in the table.
  FBarConfig.SaveWkcSetToDB;
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
