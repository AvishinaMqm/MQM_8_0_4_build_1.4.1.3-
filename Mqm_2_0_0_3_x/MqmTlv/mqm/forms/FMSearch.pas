unit FMSearch;

interface

uses
  UReShape, cxButtons, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, Buttons,
  UMSchedCont,
  UMSchedContFunc,
  UMObjCont, ToolWin, CheckLst, UMCompat, UMSearchFunc, gnugettextD5, gnugettext;

type

  TSearchValue = class(TCustomPanel)
  private
    m_IsAlpha : boolean;
    m_CondType : TCondType;
  public
    LabelFieldName : TLabel;
    ComboBoxCond : TComboBox;
    ComboList : TComboBox;
    EditFrom : TEdit;
    EditTo   : TEdit;
    procedure InitComponents;
    procedure AddItems;
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure OnChangComboCond(Sender: TObject);
    function  GetItemIndexDft(Cond : TCondType) : Integer;
    destructor Destroy; override;
  end;

  TSearchField = class(TSearchValue)
  public
    m_ConfigSearch : TCnfigSearch;
  public
    constructor CreateLine(AOwner : TComponent ; ConfigSearch : PTCnfigSearch);
    destructor destroy ; override;
  end;

  TSearchProp = class(TSearchValue)
  private
    m_PropId  : TPropID;
  public
    constructor CreateLine(AOwner : TComponent ; PropId : TPropID);
    destructor destroy ; override;
  end;

  TSearch = class(TForm)
    TabMain: TTabSheet;
    TabSearch: TTabSheet;
    Panel3: TPanel;
    Bitsearch: TBitBtn;
    ScrollBox: TScrollBox;
    PanelBtns: TPanel;
    BtnOk: TBitBtn;
    BtnCanc: TBitBtn;
    BtnSearch: TcxButton;
    PgCtrl: TPageControl;
    BtnSplitBack: TcxButton;
    Panel1: TPanel;
    LblFieldDesc: TLabel;
    LblCond: TLabel;
    LblFrom: TLabel;
    LblTo: TLabel;
    PanelMain: TPanel;
    PanelTitleMain: TPanel;
    LabelMainTitleFields: TLabel;
    LabelMainTitleProperty: TLabel;
    BtnSearchJob: TcxButton;
    BtnNewSearch: TcxButton;
    procedure FormCreate(Sender: TObject);
    procedure DeleteComponent;
    procedure BtnSearchClick(Sender: TObject);
    procedure BtnSplitBackClick(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnSearchJobClick(Sender: TObject);
    procedure BtnNewSearchClick(Sender: TObject);

  public
    CBoxFieldSearch : TCBoxSearch;
    CBoxPropertySearch : TCheckListBox;
    { Public declarations }
  private
    PanelJobDetails : TPanel;
    LblProdReq : TLabel;
    StProdReq : TStaticText;
    LblStep : TLabel;
    StStepNum : TStaticText;
    LblSubStep : TLabel;
    STSubStep : TStaticText;
    LblRePro : TLabel;
    STRePro : TStaticText;

    m_id : TSchedId;
    m_IsFromJob : boolean;
    m_ArrayCnfgTemp : array[0..16] of TCnfigSearch;
    m_ArryManagSearch  : array of TSearchValue;

    procedure InitHeader;
    procedure ClearAllFields;
    procedure InitHeaderProperties;
    procedure InitPropLines;
    procedure InitFieldLines;
    procedure BuildSearch;
    function  GetFldDescr(SrchType : TSrchType) : CBinColId;
    procedure SetDataFromJob;
    function  SetRangeVisible(SrchType : TSrchType) : boolean;
    procedure SetFieldLines(Pos : Integer; ConfigSearch : PTCnfigSearch);

  public
    Constructor Create(AOwner : TComponent ; Id: TSchedId);
  end;

implementation

uses
  UReShape, UMCompatSrv,
  UGglobal;

{$R *.DFM}

//----------------------------------------------------------------------------//

constructor TSearch.Create(AOwner : TComponent ;Id: TSchedId);
begin
  inherited Create(AOwner);
  m_id := Id;
  if (m_id = -1) then
    m_IsFromJob := false
  else
    m_IsFromJob := true;

  LoadSrcCnfg(m_ArrayCnfgTemp);
end;

//----------------------------------------------------------------------------//

procedure TSearch.FormCreate(Sender: TObject);
var
  I : Integer;
begin
  TranslateComponent (self);
  if m_IsFromJob then
  begin
    PanelJobDetails := TPanel.Create(self);
    PanelJobDetails.Parent := TabMain;
    PanelJobDetails.Align := AlTop;
    PanelJobDetails.Height := 60;

    LblProdReq := TLabel.Create(self);
    LblProdReq.Parent := PanelJobDetails;
    LblProdReq.Caption := _('Request');
    LblProdReq.Top := 6;
    LblProdReq.Left := 15;
    SetComponent(LblProdReq, comp_Label, false);

    StProdReq := TStaticText.Create(Self);
    StProdReq.Parent := PanelJobDetails;
    StProdReq.Top := 6;
    StProdReq.Left := 108;
    StProdReq.Width := 122;
    StProdReq.Height := 17;
    SetComponent(StProdReq, comp_Descr, false);

    LblStep := TLabel.Create(self);
    LblStep.Parent := PanelJobDetails;
    LblStep.Caption := _('Step');
    LblStep.Top := 6;
    LblStep.Left := 255;
    SetComponent(LblStep, comp_Label, false);

    StStepNum := TStaticText.Create(Self);
    StStepNum.Parent := PanelJobDetails;
    StStepNum.Top := 6;
    StStepNum.Left := 383;
    StStepNum.Width := 122;
    StStepNum.Height := 17;
    SetComponent(StStepNum, comp_Descr, false);

    LblSubStep := TLabel.Create(self);
    LblSubStep.Parent := PanelJobDetails;
    LblSubStep.Caption := _('Sub step');
    LblSubStep.Top := 26;
    LblSubStep.Left := 15;
    SetComponent(LblSubStep, comp_Label, false);

    STSubStep := TStaticText.Create(Self);
    STSubStep.Parent := PanelJobDetails;
    STSubStep.Top := 26;
    STSubStep.Left := 108;
    STSubStep.Width := 122;
    STSubStep.Height := 17;
    SetComponent(STSubStep, comp_Descr, false);

    LblRePro := TLabel.Create(self);
    LblRePro.Parent := PanelJobDetails;
    LblRePro.Caption := _('Re process');
    LblRePro.Top := 26;
    LblRePro.Left := 255;
    SetComponent(LblRePro, comp_Label, false);

    STRePro := TStaticText.Create(Self);
    STRePro.Parent := PanelJobDetails;
    STRePro.Top := 26;
    STRePro.Left := 383;
    STRePro.Width := 122;
    STRePro.Height := 17;
    SetComponent(STRePro, comp_Descr, false);

    InitHeader;
  end;

  PanelMain.Align := AlClient;
  CBoxFieldSearch := TCBoxSearch.Create(self);
  CBoxFieldSearch.Parent := PanelMain;
  CBoxFieldSearch.Align := AlLeft;
  CBoxFieldSearch.Width := 275;

  CBoxPropertySearch := TCheckListBox.Create(self);
  CBoxPropertySearch.Parent := PanelMain;
  CBoxPropertySearch.Align := AlClient;

  for I := Low(m_ArrayCnfgTemp) to High(m_ArrayCnfgTemp) do
  begin
    CBoxFieldSearch.Items.Add(m_ArrayCnfgTemp[I].Name);
    CBoxFieldSearch.Checked[I] := m_ArrayCnfgTemp[I].Visible;
  end;

  InitHeaderProperties;

  for I := 0 to PgCtrl.PageCount-1 do
    PgCtrl.Pages[I].TabVisible := false;

  PgCtrl.ActivePage := TabMain;
  ReShape(Self);
end;

//----------------------------------------------------------------------------//

procedure TSearch.DeleteComponent;
var
  I,J : Integer;
  RecProp : TCnfigSearch;
begin
  for I := Low(m_ArryManagSearch) to High(m_ArryManagSearch) do
  begin
    if (m_ArryManagSearch[I] is TSearchField) then
    begin
      for J := Low(m_ArrayCnfgTemp) to High(m_ArrayCnfgTemp) do
      begin
        if TSearchField(m_ArryManagSearch[I]).m_ConfigSearch.Field = m_ArrayCnfgTemp[J].Field then
        begin
          m_ArrayCnfgTemp[J].ValFrom := TSearchField(m_ArryManagSearch[I]).EditFrom.Text;
          m_ArrayCnfgTemp[J].ValTo := TSearchField(m_ArryManagSearch[I]).EditTo.Text;
          m_ArrayCnfgTemp[J].CondType := TSearchField(m_ArryManagSearch[I]).m_CondType;
        end;
      end;
    end
    else
    begin
      RecProp.Prop := TSearchProp(m_ArryManagSearch[I]).m_PropId;
      RecProp.CondType := TSearchProp(m_ArryManagSearch[I]).m_CondType;
      RecProp.ValFrom := TSearchProp(m_ArryManagSearch[I]).EditFrom.Text;
      RecProp.ValTo := TSearchProp(m_ArryManagSearch[I]).EditTo.Text;
      SetValuesForPropId(@RecProp);
    end;

    if assigned(m_ArryManagSearch[I]) then
    begin
      m_ArryManagSearch[I].free;
      m_ArryManagSearch[I] := nil;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TSearch.SetFieldLines(Pos : Integer ; ConfigSearch : PTCnfigSearch);
var
  Index : Integer;
  i: integer;
begin
  m_ArryManagSearch[Pos] := TSearchField.CreateLine(self , ConfigSearch);
  m_ArryManagSearch[Pos].Parent := ScrollBox;

  if (ConfigSearch.Field = SRC_StepType) then
  begin
    (m_ArryManagSearch[Pos] as TSearchField).ComboBoxCond.OnChange := nil;
     i := (m_ArryManagSearch[Pos] as TSearchField).ComboBoxCond.items.Add('');
    (m_ArryManagSearch[Pos] as TSearchField).ComboBoxCond.Items.Objects[i] := TObject(CST_undef);
      i := (m_ArryManagSearch[Pos] as TSearchField).ComboBoxCond.Items.Add('Batches');
     (m_ArryManagSearch[Pos] as TSearchField).ComboBoxCond.Items.Objects[i] := TObject(CST_batch);
      i := (m_ArryManagSearch[Pos] as TSearchField).ComboBoxCond.Items.Add('Continuous');
     (m_ArryManagSearch[Pos] as TSearchField).ComboBoxCond.Items.Objects[i] := TObject(CST_Continuous);
      i := (m_ArryManagSearch[Pos] as TSearchField).ComboBoxCond.Items.Add('Printing');
     (m_ArryManagSearch[Pos] as TSearchField).ComboBoxCond.Items.Objects[i] := TObject(CST_printing);
     (m_ArryManagSearch[Pos] as TSearchField).ComboBoxCond.ItemIndex := 0;
     (m_ArryManagSearch[Pos] as TSearchField).EditFrom.Visible := false;
     (m_ArryManagSearch[Pos] as TSearchField).EditTo.Visible := false;
  end
  else
  begin
    (m_ArryManagSearch[Pos] as TSearchField).AddItems;
     Index := (m_ArryManagSearch[Pos] as TSearchField).GetItemIndexDft(ConfigSearch.CondType);
     (m_ArryManagSearch[Pos] as TSearchField).ComboBoxCond.ItemIndex := Index;
     (m_ArryManagSearch[Pos] as TSearchField).EditFrom.text := ConfigSearch.ValFrom;
     (m_ArryManagSearch[Pos] as TSearchField).EditTo.text := ConfigSearch.ValTo;
  end;

  if not SetRangeVisible(ConfigSearch.Field) then
    (m_ArryManagSearch[Pos] as TSearchField).EditTo.Visible := false;

  if Pos = 0 then
    m_ArryManagSearch[Pos].Top := 1
  else
    m_ArryManagSearch[Pos].Top := m_ArryManagSearch[Pos - 1].Top + 36;
end;

//----------------------------------------------------------------------------//

procedure TSearch.BtnSearchClick(Sender: TObject);
begin
  BuildSearch;
end;

//----------------------------------------------------------------------------//

procedure TSearch.BtnSplitBackClick(Sender: TObject);
begin
    PgCtrl.ActivePage := TabMain;
end;

//----------------------------------------------------------------------------//

procedure TSearch.InitHeader;
begin
  StProdReq.Caption := p_sc.GetFldDescr(m_id, CSC_ProdReq);
  StStepNum.Caption := p_sc.GetFldDescr(m_id, CSC_ProdStep);
  STSubStep.Caption := p_sc.GetFldDescr(m_id, CSC_ProdSubStep);
  STRePro.Caption   := p_sc.GetFldDescr(m_id, CSC_ReprocNo);
end;

//----------------------------------------------------------------------------//

procedure TSearch.InitHeaderProperties;
begin
  InitPropListCnfg(CBoxPropertySearch);
end;

//----------------------------------------------------------------------------//

procedure TSearch.BuildSearch;
begin
  DeleteComponent;
  SetLength(m_ArryManagSearch, 0);
  InitFieldLines;
  InitPropLines;
  PgCtrl.ActivePage := TabSearch;
end;

//----------------------------------------------------------------------------//

procedure TSearch.BtnSearchJobClick(Sender: TObject);
begin
  if m_IsFromJob then
  begin
    ClearAllFields;
    SetDataFromJob;
  end;
end;

//----------------------------------------------------------------------------//

procedure TSearch.BtnNewSearchClick(Sender: TObject);
begin
  ClearAllFields;
  BuildSearch
end;

//----------------------------------------------------------------------------//

procedure TSearch.InitFieldLines;
var
  I : Integer;
begin
  for I := Low(m_ArrayCnfgTemp) to High(m_ArrayCnfgTemp) do
  begin
    if CBoxFieldSearch.Checked[I] then
    begin
      m_ArrayCnfgTemp[I].Visible := true; // after should remember  avi avi
      SetLength(m_ArryManagSearch, length(m_ArryManagSearch) + 1);
      SetFieldLines(High(m_ArryManagSearch), @m_ArrayCnfgTemp[I]);
    end
    else
      m_ArrayCnfgTemp[I].Visible := false;
  end;
end;

//----------------------------------------------------------------------------//

procedure TSearch.InitPropLines;
var
  I, Index : Integer;
begin
  for I := 0 to CBoxPropertySearch.Items.Count -1 do
  begin
    if CBoxPropertySearch.Checked[I] then
    begin
      SetLength(m_ArryManagSearch, length(m_ArryManagSearch) + 1);
      m_ArryManagSearch[High(m_ArryManagSearch)] := TSearchProp.CreateLine(self, TPropID(CBoxPropertySearch.Items.Objects[I]));
      m_ArryManagSearch[High(m_ArryManagSearch)].Parent := ScrollBox;
      m_ArryManagSearch[High(m_ArryManagSearch)].AddItems;
      Index := m_ArryManagSearch[High(m_ArryManagSearch)].GetItemIndexDft(m_ArryManagSearch[High(m_ArryManagSearch)].m_CondType);
      m_ArryManagSearch[High(m_ArryManagSearch)].ComboBoxCond.ItemIndex := Index;

      if High(m_ArryManagSearch) = 0 then
        m_ArryManagSearch[High(m_ArryManagSearch)].Top := 1
      else
        m_ArryManagSearch[High(m_ArryManagSearch)].Top := m_ArryManagSearch[High(m_ArryManagSearch) - 1].Top + 36;
    end;
  end;
end;

//----------------------------------------------------------------------------//

function TSearch.GetFldDescr(SrchType : TSrchType) : CBinColId;
begin

  case SrchType of
    SRC_ProdReq         : Result := CSC_ProdReq;
    SRC_ProdType        : Result := CSC_ProdType;
    SRC_ProdFamily      : Result := CSC_ProdFamily;
    SRC_MaterialFamily  : Result := CSC_ProdMatFamily;
    SRC_ProdLine        : Result := CSC_ProdLine;
    SRC_StepType        : Result := CSC_StepType;
    SRC_GroupNo         : Result := CSC_GroupNo;
    SRC_WkctProc        : Result := CSC_WkctProc;
    SRC_QtyToSched      : Result := CSC_QtyToSched;
    SRC_ExeTime         : Result := CSC_ExeTime;

    SRC_JobComment      : Result := CSC_Comment;
    SRC_ProdProcused_PI,
    SRC_Material_PI,
    SRC_GenInfo_PI,
    SRC_Comment_PI,
    SRC_Instruction_PI,
    SRC_Others_PI      : Result := CSC_Non
    else
      Result := CSC_Non;
    end;

end;

//----------------------------------------------------------------------------//

procedure TSearch.SetDataFromJob;
var
  I : integer;
  IdField : CBinColId;
begin
  for I := Low(m_ArrayCnfgTemp) to High(m_ArrayCnfgTemp) do
  begin
    IdField := GetFldDescr(m_ArrayCnfgTemp[I].Field);
    if (IdField <> CSC_Non) then
    begin
      if (IdField = CSC_GroupNo) and (p_sc.GetFldDescr(m_id, IdField) = '----') then
         m_ArrayCnfgTemp[I].ValFrom := ''
      else
        m_ArrayCnfgTemp[I].ValFrom := p_sc.GetFldDescr(m_id, IdField);

    end;
  end;

  BuildSearch;

end;

//----------------------------------------------------------------------------//

function TSearch.SetRangeVisible(SrchType : TSrchType) : boolean;
begin
  case SrchType of
    SRC_ProdType , SRC_ProdProcused_PI, SRC_MaterialFamily,
    SRC_Material_PI, SRC_ProdLine, SRC_GenInfo_PI, SRC_Comment_PI, SRC_Instruction_PI,
    SRC_Others_PI, SRC_StepType, SRC_WkctProc, SRC_JobComment
    : Result := false;
  else
    Result := true;
  end;
end;

//----------------------------------------------------------------------------//

procedure TSearch.BtnOkClick(Sender: TObject);
begin
{ for I := low(m_ArryManagSearch) to High(m_ArryManagSearch) do
 begin


 end;


  for I := 0 to CBoxFieldSearch.Items.count - 1 do
    SaveSrcCnfg(I, CBoxFieldSearch.Checked[I]);
  SavePropListCnfg(CBoxPropertySearch);    }
end;

{ TSearchValue}
//----------------------------------------------------------------------------//

procedure TSearchValue.AddItems;
begin
  ComboBoxCond.items.add('=');
  ComboBoxCond.items.add('<');
  ComboBoxCond.items.add('>');
  ComboBoxCond.items.add('Like');
  ComboBoxCond.items.add('From To');
end;

//----------------------------------------------------------------------------//

destructor TSearchValue.Destroy;
begin
  LabelFieldName.free;
  ComboBoxCond.free;
  EditFrom.free;
  EditTo.free;
  inherited Destroy;
end;

//----------------------------------------------------------------------------//

procedure TSearchValue.EditKeyPress(Sender: TObject; var Key: Char);
begin
  if not m_IsAlpha then
    if not ((Key in ['0'..'9']) or (key = chr(vk_Back)) or (Key = chr(24))) then
      abort;
end;

//----------------------------------------------------------------------------//

procedure TSearchValue.OnChangComboCond(Sender: TObject);
begin
  case ComboBoxCond.ItemIndex of
    0 : m_CondType := SRC_equal;
    1 : m_CondType := SRC_Less;
    2 : m_CondType := SRC_Big;
    3 : m_CondType := SRC_Like;
    4 : m_CondType := SRC_FromTo;
  end;
end;

//----------------------------------------------------------------------------//

procedure TSearchValue.InitComponents;
begin
  self.Height := 36;
  self.Width := 577;
  self.Align := AlTop;

  LabelFieldName := TLabel.Create(self);
  LabelFieldName.Parent := self;
  LabelFieldName.Left := 28;
  LabelFieldName.Top := 11;

  ComboBoxCond := TComboBox.Create(Self);
  ComboBoxCond.Parent := self;
  ComboBoxCond.OnChange := OnChangComboCond;
  ComboBoxCond.Left := 175;
  ComboBoxCond.Width := 59;
  ComboBoxCond.Height := 17;
  ComboBoxCond.Top := 8;

  EditFrom := TEdit.create(self);
  EditFrom.Parent := self;
  EditFrom.OnKeyPress := EditKeyPress;
  EditFrom.Left := 260;
  EditFrom.Height := 17;
  EditFrom.Top := 8;

  EditTo := TEdit.create(self);
  EditTo.Parent := self;
  EditTo.OnKeyPress := EditKeyPress;
  EditTo.Left := 400;
  EditTo.Height := 17;
  EditTo.Top := 8;

end;

{ SearchField }

//----------------------------------------------------------------------------//

constructor TSearchField.CreateLine(AOwner: TComponent ; ConfigSearch : PTCnfigSearch);
begin
  inherited Create(AOwner);
  m_ConfigSearch := ConfigSearch^;
  InitComponents;
  LabelFieldName.Caption := m_ConfigSearch.Name;
  case m_ConfigSearch.Field of
    SRC_GroupNo, SRC_QtyToSched, SRC_ExeTime : m_IsAlpha := false
  else
    m_IsAlpha := true;
  end;
end;

//----------------------------------------------------------------------------//

destructor TSearchField.destroy;
begin
  inherited destroy;
end;

{ TSearchProp }

//----------------------------------------------------------------------------//

constructor TSearchProp.CreateLine(AOwner: TComponent; PropId: TPropID);
var
  PropName,TextValFrom,TextValTo : string;
begin
  inherited Create(AOwner);
  m_PropId := PropId;
  InitComponents;
  GetValuesForPropId(m_PropId  , m_IsAlpha , TextValFrom, TextValTo, m_CondType, PropName);
  LabelFieldName.Caption := PropName;
  EditFrom.Text := TextValFrom;
  EditTo.Text := TextValTo;
  EditFrom.Color := clInfoBk;
  EditTo.Color := clInfoBk;
end;

//----------------------------------------------------------------------------//

destructor TSearchProp.destroy;
begin
  inherited destroy;
end;

//----------------------------------------------------------------------------//

procedure TSearch.FormClose(Sender: TObject; var Action: TCloseAction);
var
  I : Integer;
begin
  for I := Low(m_ArryManagSearch) to High(m_ArryManagSearch) do
  begin
    m_ArryManagSearch[I].Free;
    m_ArryManagSearch[I] := nil;
  end;
  Action := caFree;
end;

//----------------------------------------------------------------------------//

function TSearchValue.GetItemIndexDft(Cond : TCondType) : Integer;
begin
  case Cond of
    SRC_equal : Result := 0;
    SRC_Less : Result := 1;
    SRC_Big : Result := 2;
    SRC_Like : Result := 3;
    SRC_FromTo : Result := 4;
  else
    Result := 0;
  end
end;

//----------------------------------------------------------------------------//

procedure TSearch.ClearAllFields;
var
  I : Integer;
begin
  for I := Low(m_ArrayCnfgTemp) to High(m_ArrayCnfgTemp) do
  begin
    m_ArrayCnfgTemp[I].CondType := SRC_equal;
    m_ArrayCnfgTemp[I].ValFrom := '';
    m_ArrayCnfgTemp[I].ValTo := '';
  end;
end;

//----------------------------------------------------------------------------//

end.
