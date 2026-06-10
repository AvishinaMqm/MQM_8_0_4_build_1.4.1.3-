unit FMAppendix;

interface

uses
  cxButtons, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, UReShape, gnugettext, UMWkCtr;

type
  TFAppendix = class(TForm)
    GroupBox2: TGroupBox;
    LBListOfSets: TListBox;
    BitDeleteSet: TcxButton;
    BitOpenSet: TcxButton;
    GroupBox1: TGroupBox;
    LblNewSetName: TLabel;
    EditNewSetName: TEdit;
    BtnSaveNewSet: TcxButton;
    BtnAbo: TcxButton;
    Button1: TcxButton;
    Button2: TcxButton;
    procedure FormCreate(Sender: TObject);
    procedure BtnAboClick(Sender: TObject);
    procedure BtnSaveNewSetClick(Sender: TObject);
    procedure BitDeleteSetClick(Sender: TObject);
    procedure BitOpenSetClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

  uses FMTotalViews;

{$R *.dfm}

//----------------------------------------------------------------------------//

procedure TFAppendix.BitDeleteSetClick(Sender: TObject);
var
  setName: String;
  I, y : Integer;
  FTotalViews: TFTotalViews;
  TotalViews_List : Tlist;
begin
  if LBListOfSets.ItemIndex < 0 then exit;
  setName := LBListOfSets.Items.Strings[LBListOfSets.ItemIndex];

  if MessageDlg(_('Delete') +' '+ setName + ' '+ _('set ?'), mtWarning, [mbYes, mbNo], 0) in [mrNo] then
    exit;

  TotalViews_List := GetTotalViews_List;

  for I := TotalViews_List.Count - 1 downto 0 do
  begin
    if PTTotalsView(TotalViews_List[I]).set_name = setName then
    begin

      for y := PTTotalsView(TotalViews_List[I]).Wkc_list.Count - 1 downto 0 do
          PTTotalsView(TotalViews_List[I]).Wkc_list.Delete(y);

      for y := PTTotalsView(TotalViews_List[I]).Group_list.Count - 1 downto 0 do
          PTTotalsView(TotalViews_List[I]).Group_list.Delete(y);

      PTTotalsView(TotalViews_List[I]).Wkc_list.Free;
      PTTotalsView(TotalViews_List[I]).Group_list.Free;
      // other 2 entities should be handle as well
      TotalViews_List.Delete(I);
    end;

  end;

  LBListOfSets.Items.Delete(LBListOfSets.ItemIndex);
  FTotalViews := TFTotalViews.CreateTotalView_Delete(Self);
  FTotalViews.DeleteSet(SetName);
  FTotalViews.Free;

end;

//----------------------------------------------------------------------------//

procedure TFAppendix.BitOpenSetClick(Sender: TObject);
var
  setName: String;
  FTotalViews : TFTotalViews;
begin
  if LBListOfSets.ItemIndex < 0 then
  begin
    MessageDlg(_('Please select a set first !'), mtWarning, [mbOK], 0);
    exit;
  end;
  setName := LBListOfSets.Items.Strings[LBListOfSets.ItemIndex];
  FTotalViews := TFTotalViews.CreateTotalView(Self, PTTotalsView(LBListOfSets.Items.Objects[LBListOfSets.ItemIndex]) ,'wkc');
  FTotalViews.ShowModal;
  FTotalViews.free;
end;

//----------------------------------------------------------------------------//

procedure TFAppendix.BtnAboClick(Sender: TObject);
begin
  Close;
end;

//----------------------------------------------------------------------------//

procedure TFAppendix.BtnSaveNewSetClick(Sender: TObject);
var
  FTotalViews : TFTotalViews;
  TotalViews_List : Tlist;
begin
  if EditNewSetName.Text = '' then
  begin
    MessageDlg(_('Please enter a set name.'), mtWarning, [mbOK], 0);
    exit
  end;

  LBListOfSets.Items.Add(EditNewSetName.Text);

  FTotalViews := TFTotalViews.CreateTotalView_NewSet(Self);
  FTotalViews.CreateNewSet(EditNewSetName.Text);
  TotalViews_List := GetTotalViews_List;
  LBListOfSets.Items.Objects[LBListOfSets.Items.Count-1] := TObject(TotalViews_List[LBListOfSets.Items.Count-1]);

  FTotalViews.Save('', EditNewSetName.Text);

  EditNewSetName.Text := '';

  if LBListOfSets.Items.Count > 0 then
    LBListOfSets.Selected[0] := True;

  FTotalViews.Free;
end;

procedure TFAppendix.Button1Click(Sender: TObject);
var
  setName: String;
  FTotalViews : TFTotalViews;
begin
  if LBListOfSets.ItemIndex < 0 then
  begin
    MessageDlg(_('Please select a set first !'), mtWarning, [mbOK], 0);
    exit;
  end;

  setName := LBListOfSets.Items.Strings[LBListOfSets.ItemIndex];
  FTotalViews := TFTotalViews.CreateTotalView(Self, PTTotalsView(LBListOfSets.Items.Objects[LBListOfSets.ItemIndex]) ,'group');
  FTotalViews.ShowModal;
  FTotalViews.free;

end;

procedure TFAppendix.Button2Click(Sender: TObject);
var
  setName: String;
  FTotalViews : TFTotalViews;
begin

  if LBListOfSets.ItemIndex < 0 then
  begin
    MessageDlg(_('Please select a set first !'), mtWarning, [mbOK], 0);
    exit;
  end;

  setName := LBListOfSets.Items.Strings[LBListOfSets.ItemIndex];
  FTotalViews := TFTotalViews.CreateTotalView(Self, PTTotalsView(LBListOfSets.Items.Objects[LBListOfSets.ItemIndex]) ,'formula');
  FTotalViews.ShowModal;
  FTotalViews.free;

end;

//----------------------------------------------------------------------------//

procedure TFAppendix.FormCreate(Sender: TObject);
var
  I : Integer;
  TotalViews_List : TList;
begin
  ReShape(Self);

  TotalViews_List := GetTotalViews_List;

  for I := 0 to TotalViews_List.Count - 1 do
  begin
    LBListOfSets.Items.add(PTTotalsView(TotalViews_List[I]).set_name);
    LBListOfSets.Items.Objects[I] := TObject(TotalViews_List[I]);
  end;

  if LBListOfSets.Items.Count > 0 then
    LBListOfSets.Selected[0] := True;
end;

//----------------------------------------------------------------------------//

end.
