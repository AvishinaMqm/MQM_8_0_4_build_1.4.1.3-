unit FMGroupAll;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Spin, UMSchedContFunc, ExtCtrls, UReShape, ExSpinEdit;

type
  TTGroupAllLines = class(TForm)
    GroupBox1: TGroupBox;
    ConvertJobQtyUm: TRadioGroup;
    ResUmList: TComboBox;
    LblResUm: TLabel;
    GroupBox2: TGroupBox;
    LblMinNumberOfJob: TLabel;
    LblMaxNumberJobs: TLabel;
    EditMaxNumberJobs: TEdit;
    EditMinNumberJobs: TEdit;
    EditMinQty: TEdit;
    EditMaxQty: TEdit;
    LblMinQty: TLabel;
    LblMaxQty: TLabel;
    GroupBox3: TGroupBox;
    EditNumOfMatFamiliyInGroup: TEdit;
    GroupBox5: TGroupBox;
    SEdtBefLatestlDays: TexSpinEdit;
    BitBtn2: TcxButton;
    BitBtn1: TcxButton;
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EditQtyKeyPress(Sender: TObject; var Key: Char);
    procedure GroupBox5Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);

  private
    m_Id : TSchedId;
    m_StringList_UM : TStringList;
    m_NumOfMatFamiliyInGroup : Integer;
    m_MinNumJobs : Integer;
    m_MaxNumJobs : Integer;
    m_MinQty     : currency;
    m_MaxQty     : currency;
    m_ConvertToRscUom : boolean;
    m_GapInDaysForLatestEnd : integer;
    m_ResUm : string;

    { Private declarations }
  public
    constructor CreateForm(AOwner : TComponent; Id : TSchedId);

    { Public declarations }
  end;

var
  TGroupAllLines: TTGroupAllLines;

implementation

{$R *.dfm}

Uses UMGlobal, UMObjCont, gnugettext;

//----------------------------------------------------------------------------//

procedure TTGroupAllLines.BitBtn1Click(Sender: TObject);
begin
  MOdalResult := mrAbort;
  Close;
end;

constructor TTGroupAllLines.CreateForm(AOwner : TComponent; Id : TSchedId);
var
  I : Integer;
begin
  inherited Create(AOwner);
  m_Id := Id;
  m_StringList_UM := p_sc.GetListUmForJob(Id);
  if not Assigned(m_StringList_UM) then
  begin
    ConvertJobQtyUm.Enabled := false;
    ResUmList.Enabled := false;
  end
  else
  begin
    for I := 0 to m_StringList_UM.Count - 1 do
      ResUmList.Items.Add(m_StringList_UM.Strings[I]);
  end;

end;

//----------------------------------------------------------------------------//

procedure TTGroupAllLines.EditQtyKeyPress(Sender: TObject; var Key: Char);
begin
  if not ((CharInSet(Key, ['0'..'9'])) or (key = chr(vk_Back)) or (Key = chr(24))) then
      abort;
end;

//----------------------------------------------------------------------------//

procedure TTGroupAllLines.BitBtn2Click(Sender: TObject);
begin
  ModalResult := mrOk;

  if trim(EditMinNumberJobs.Text) = '' then
  begin
    ModalResult := mrNone;
    ShowMessage(_('Minimum number of jobs in group was not defined'));
    exit;
  end;

  if trim(EditMaxNumberJobs.Text) = '' then
  begin
    ModalResult := mrNone;
    ShowMessage(_('Maximum number of jobs in group was not defined'));
    exit;
  end;

  if trim(EditMinQty.Text) = '' then
  begin
    ModalResult := mrNone;
    ShowMessage(_('Minimum job quantity was not defined'));
    exit;
  end;

  if trim(EditMaxQty.Text) = '' then
  begin
    ModalResult := mrNone;
    ShowMessage(_('Maximum job quantity was not defined'));
    exit;
  end;

  try
    if (StrToInt(EditMaxNumberJobs.Text) < 1) or (StrToInt(EditMaxNumberJobs.Text) < StrToInt(EditMinNumberJobs.Text)) then
    begin
      ModalResult := mrNone;
      ShowMessage(_('Minimum/Maximum jobs in a group are wrong values'));
      exit;
    end;
  except
  end;

  if (ConvertJobQtyUm.ItemIndex = 1) and (ResUmList.ItemIndex = -1) and ConvertJobQtyUm.Enabled then
  begin
    ModalResult := mrNone;
    ShowMessage(_('Please select Um from the list'));
  end;

  if trim(EditNumOfMatFamiliyInGroup.Text) = '' then
  begin
    ModalResult := mrNone;
    ShowMessage(_('Number of different material family was not defined'));
    exit;
  end;

  m_MinNumJobs := StrToInt(EditMinNumberJobs.Text);
  m_MaxNumJobs := StrToInt(EditMaxNumberJobs.Text);

  m_GapInDaysForLatestEnd := SEdtBefLatestlDays.value;


  m_NumOfMatFamiliyInGroup := StrToInt(EditNumOfMatFamiliyInGroup.Text);
  m_MinQty     := StrToFloat(EditMinQty.Text);
  m_MaxQty     := StrToFloat(EditMaxQty.Text);
  m_ResUm      := ResUmList.Items[0];
  if not ConvertJobQtyUm.Enabled then
    m_ConvertToRscUom := false
  else
    m_ConvertToRscUom := (ConvertJobQtyUm.ItemIndex = 1);

  DBAppGlobals.NumOfMatFamiliyInGroup := m_NumOfMatFamiliyInGroup;
  DBAppGlobals.MinNumJobsInGroup := m_MinNumJobs;
  DBAppGlobals.MaxNumJobsInGroup := m_MaxNumJobs;
  DBAppGlobals.MinQtyInGroup     := m_MinQty;
  DBAppGlobals.MaxQtyInGFroup    := m_MaxQty;
  DBAppGlobals.ConvertToRscUomInGroup := m_ConvertToRscUom;
  DBAppGlobals.GapInDaysForLatestEndGroup := m_GapInDaysForLatestEnd;
  DBAppGlobals.ResUmInGroup := m_ResUm;

end;

//----------------------------------------------------------------------------//

procedure TTGroupAllLines.FormCreate(Sender: TObject);
var
  I : Integer;
begin
  EditMinNumberJobs.Text := IntToStr(DBAppGlobals.MinNumJobsInGroup);
  if DBAppGlobals.MaxNumJobsInGroup > 0 then
    EditMaxNumberJobs.text := IntToStr(DBAppGlobals.MaxNumJobsInGroup);

  if DBAppGlobals.NumOfMatFamiliyInGroup > 0 then
    EditNumOfMatFamiliyInGroup.Text := IntToStr(DBAppGlobals.NumOfMatFamiliyInGroup);

  if DBAppGlobals.ConvertToRscUomInGroup then
    ConvertJobQtyUm.ItemIndex := 1
  else
    ConvertJobQtyUm.ItemIndex := 0;

  for I := 0 to ResUmList.Items.Count - 1 do
     if (ResUmList.Items[I] = DBAppGlobals.ResUmInGroup) then
     begin
       ResUmList.ItemIndex := I;
       Break
     end;

  EditMinQty.Text := FloatToStr(DBAppGlobals.MinQtyInGroup);
  if DBAppGlobals.MaxQtyInGFroup > 0 then
    EditMaxQty.Text := FloatToStr(DBAppGlobals.MaxQtyInGFroup);

  SEdtBefLatestlDays.value := DBAppGlobals.GapInDaysForLatestEndGroup;

  ReShape(self);
//  ReShape(BitBtn1);
//  ReShape(BitBtn2);
end;

procedure TTGroupAllLines.GroupBox5Click(Sender: TObject);
begin

end;

//----------------------------------------------------------------------------//

end.
