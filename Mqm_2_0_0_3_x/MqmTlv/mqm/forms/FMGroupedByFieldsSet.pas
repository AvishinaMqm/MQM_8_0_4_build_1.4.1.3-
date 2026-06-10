unit FMGroupedByFieldsSet;

interface

uses
  cxButtons, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls, UReShape,
  Vcl.ExtCtrls;

type
  TFGroupedByFieldsSet = class(TForm)
    GroupBox1: TGroupBox;
    LblNewSetName: TLabel;
    EditNewSetName: TEdit;
    GroupBox2: TGroupBox;
    LBListOfSets: TListBox;
    BitDeleteSet: TcxButton;
    BitOpenSet: TcxButton;
    BtnSaveNewSet: TcxButton;
    BtnAbo: TcxButton;
    procedure BitDeleteSetClick(Sender: TObject);
    procedure BitOpenSetClick(Sender: TObject);
    procedure BtnSaveNewSetClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnAboClick(Sender: TObject);
    procedure LBListOfSetsDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    constructor CreateGroupedByFieldsSet(AOwner: TComponent);
    { Public declarations }
  end;

//var
//  FGroupedByFieldsSet: TFGroupedByFieldsSet;

implementation

uses
  FMGroupedByFieldsConfig, gnugettext;

{$R *.dfm}

//----------------------------------------------------------------------------//

procedure TFGroupedByFieldsSet.BitDeleteSetClick(Sender: TObject);
begin
  if LBListOfSets.ItemIndex >= 0 then
  begin
    DeleteGroupedByFieldCode(LBListOfSets.Items.Strings[LBListOfSets.ItemIndex]);
    LBListOfSets.Items.Delete(LBListOfSets.ItemIndex) ;
  end

end;

//----------------------------------------------------------------------------//

procedure TFGroupedByFieldsSet.BitOpenSetClick(Sender: TObject);
var
  setName: String;
  GroupedByFieldsConfig : TFGroupedByFieldsConfig;
begin
  if LBListOfSets.ItemIndex < 0 then
  begin
    MessageDlg(_('Please select a set first !'), mtWarning, [mbOK], 0);
    exit;
  end;
  setName := LBListOfSets.Items.Strings[LBListOfSets.ItemIndex];

  GroupedByFieldsConfig := TFGroupedByFieldsConfig.CreateGroupByField(Self, setName);
  GroupedByFieldsConfig.ShowModal;
  GroupedByFieldsConfig.Free;
end;

//----------------------------------------------------------------------------//

procedure TFGroupedByFieldsSet.BtnAboClick(Sender: TObject);
begin
  Close;
end;

procedure TFGroupedByFieldsSet.BtnSaveNewSetClick(Sender: TObject);
begin
  if EditNewSetName.Text = '' then
  begin
    MessageDlg(_('Please enter a set name.'), mtWarning, [mbOK], 0);
    exit
  end;
  if LBListOfSets.Items.IndexOf(EditNewSetName.Text) <> -1 then
  begin
    MessageDlg(_('Set name already exist !'), mtWarning, [mbOK], 0);
    exit
  end;
  LBListOfSets.Items.Add(EditNewSetName.Text);
end;

//----------------------------------------------------------------------------//

constructor TFGroupedByFieldsSet.CreateGroupedByFieldsSet(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ReShape(Self);
end;

//----------------------------------------------------------------------------//

procedure TFGroupedByFieldsSet.FormCreate(Sender: TObject);
var
  I : Integer;
  GroupedByFieldList : TStringList;
begin
  BitDeleteSet.StyleName := 'VLargeButton320x30';
  BitOpenSet.StyleName := 'VLargeButton320x30';
  Caption := _('Fields set configuration');
  GroupedByFieldList := GetAllGroupedByFieldList;
  if GroupedByFieldList <> nil then
  begin
    for I := 0 to GroupedByFieldList.Count - 1 do
      LBListOfSets.Items.Add(GroupedByFieldList.Strings[I]);
  end;


end;

procedure TFGroupedByFieldsSet.LBListOfSetsDblClick(Sender: TObject);
begin
   BitOpenSetClick(Sender);
end;

//----------------------------------------------------------------------------//

end.
