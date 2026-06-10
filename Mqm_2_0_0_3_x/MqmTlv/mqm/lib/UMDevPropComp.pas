unit UMDevPropComp;

interface

uses
  cxButtons, classes,
  controls,
  extCtrls,
  StdCtrls,
  Grids,
  Mask,
  UMCompat,
  UMPropComp,
  UMCompatSrv;

type

  TMShowPropList = class(TPanel)
    constructor CreateShowPropList(AOwner: TWinControl; PropList: TProperties);
    destructor  Destroy; override;
    procedure   FillGrid;
    procedure   ChangePropList(PropList: TProperties);
  private
    m_PropList: TProperties;
    m_sg:       TStringGrid;
  end;

  TMPropShow = class(TPanel)
    constructor CreatePropShow(AOwner: TWinControl); virtual;
    destructor  Destroy; override;
    procedure   Reset;
    procedure   AddObj(pId: TPropID; obj: TObject);
    procedure   Show; virtual; abstract;
  private
    m_list: TList;
  end;

  TMPropValuesShow = class(TMPropShow)
    constructor CreatePropValuesShow(AOwner: TWinControl);
    destructor  Destroy; override;
    procedure   Show; override;
  private
    m_sg: TStringGrid;
  end;

  TMPropRulesShow = class(TMPropShow)
    constructor CreatePropRulesShow(AOwner: TWinControl; isOtoO: boolean);
    destructor  Destroy; override;
    procedure   Show; override;
    procedure   ClickEval(Sender: TObject);
  private
    m_isOtoO:   boolean;
    m_stProp:   TStaticText;
    m_mskEdit:  TMaskEdit;
    m_button:   TcxButton;
    m_cbProp:   TComboBox;
    m_sg:       TStringGrid;
    procedure   ChgPropRule(Sender: TObject);
  end;

  TMDevPropComp = class(TMPropComp)
    constructor CreatePropComp(AOwner: TWinControl; filterCat: string;
                               mtxList: TList;
                               isForRules, isOtoO: boolean); override;
    destructor  Destroy; override;
  private
    m_mtxList:  TList;
    m_cbPos:    integer;
    m_topPanel: TPanel;
    m_propShow: TMPropShow;
    m_cbProp:   TComboBox;
    m_cbProc:   TComboBox;
    m_cbCat:    TComboBox;
    m_cbProd:   TComboBox;

    function    CreateCombo(tit: string; chgFnc: TNotifyEvent): TComboBox;
    procedure   ChgMtxType(Sender: TObject);
    procedure   ChgCombo(Sender: TObject);
  end;

implementation

uses
  dialogs,
  Graphics,
  SysUtils,
  UMCompatRules;

resourcestring

  CSTR_YES = 'Yes';
  CSTR_NO  = 'No';

  CSTR_PROPDESCR  = 'Description';
  CSTR_PROPVALUE  = 'Value';
  CSTR_ADDTOOCC   = 'Res. added to occ';
  CSTR_DFLTRESOCC = 'Default res. occ.';
  CSTR_DFLTOCCOCC = 'Default occ. occ.';

  CSTR_CHECKSEQ   = 'Check sequence';
  CSTR_RULVAL     = 'Value';
  CSTR_OP1        = 'oper. 1';
  CSTR_OP2        = 'oper. 2';
  CSTR_CMPVAL     = 'compat value';

  CSTR_MTXTYPE    = 'Matrix type';
  CSTR_WKCTPROC   = 'Workcenter process';
  CSTR_RESGRP     = 'Resource group';
  CSTR_PRODTYP    = 'Product type';

  CSTR_CMX_code           = 'property code';
  CSTR_CMX_proc           = 'property code and process';
  CSTR_CMX_cat            = 'property code and group';
  CSTR_CMX_prod_code      = 'product type and code';
  CSTR_CMX_prod_proc      = 'product type, code and process';
  CSTR_CMX_prod_cat       = 'product type, code and group';

  CSTR_PROPCAP = 'Property';

  CSTR_SUPADJ     = 'Setup adjustment';
  CSTR_SUPTM      = 'Setup time';
  CSTR_SUPOVER    = 'Setup overlap';
  CSTR_SUPMUL     = 'Setup multiplier';
  CSTR_SUPMULOVER = 'Setup multiplier Overlap';
  CSTR_SMGRP      = 'Same group';

  CSTR_TEST       = 'Test';

type
  TCmxSet = set of TCompatMatrix;

  TRecShow = record
    prop: TPropID;
    obj:  TObject;
  end;
  PTRecShow = ^TRecShow;

//----------------------------------------------------------------------------//

constructor TMShowPropList.CreateShowPropList(AOwner: TWinControl; PropList: TProperties);
begin
  inherited Create(AOwner);

  Parent  := AOwner;
  Visible := true;
  Align   := alClient;

  m_sg                  := TStringGrid.Create(self);
  m_sg.Parent           := self;
  m_sg.Align            := alClient;
  m_sg.Options          := m_sg.Options + [goRowSelect];
  m_sg.FixedCols        := 0;
  m_sg.Color            := clInfoBk;
  m_sg.FixedColor       := clGrayText;
  m_sg.DefaultRowHeight := 20;
  m_sg.DefaultColWidth  := 100;
  m_sg.ColCount         := 2;
  m_sg.Visible          := true;

  m_sg.ColCount := 2;
  m_sg.Rows[0].Add(CSTR_PROPDESCR);
  m_sg.Rows[0].Add(CSTR_PROPVALUE);

  ChangePropList(PropList)
end;

//----------------------------------------------------------------------------//

procedure TMShowPropList.ChangePropList(PropList: TProperties);
begin
  m_PropList := PropList;
  FillGrid
end;

//----------------------------------------------------------------------------//

procedure TMShowPropList.FillGrid;
var
  PropID: TPropID;
  PropVal: variant;
  PropRscCode: string;
  i: integer;
begin
  if not Assigned(m_PropList) or (m_PropList.p_PropCount = 0) then
    m_sg.Visible := false
  else
  begin
    m_sg.Visible := true;

    m_sg.RowCount := m_PropList.p_PropCount + 1;

    for i := 0 to m_PropList.p_PropCount-1 do
    begin
      PropVal := m_PropList.GetProperty(i, propId, PropRscCode); 
      m_sg.Rows[i+1].Add(GetPropDescr(propId));
      m_sg.Rows[i+1].Add(PropRscCode);
      m_sg.Rows[i+1].Add(FormatToShow(propId, PropVal));
    end
  end
end;

//----------------------------------------------------------------------------//

destructor TMShowPropList.Destroy;
begin
  inherited Destroy
end;

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

constructor TMPropShow.CreatePropShow(AOwner: TWinControl);
begin
  inherited Create(AOwner);
  m_list := TList.Create
end;

//----------------------------------------------------------------------------//

destructor TMPropShow.Destroy;
begin
  Reset;
  m_list.Free;
  inherited Destroy
end;

//----------------------------------------------------------------------------//

procedure TMPropShow.Reset;
var
  i:   integer;
  rec: PTRecShow;
begin
  for i := 0 to m_list.Count-1 do
  begin
    rec := PTRecShow(m_list[i]);
    Dispose(rec)
  end;

  m_list.Clear
end;

//----------------------------------------------------------------------------//

procedure TMPropShow.AddObj(pId: TPropID; obj: TObject);
var
  rec: PTRecShow;
begin
  New(rec);
  rec.prop := pId;
  rec.Obj  := obj;

  m_list.Add(rec)
end;

//----------------------------------------------------------------------------//

constructor TMPropValuesShow.CreatePropValuesShow(AOwner: TWinControl);
begin
  inherited CreatePropShow(AOwner);

  Parent  := AOwner;
  Visible := true;
  Align   := alClient;

  m_sg                  := TStringGrid.Create(self);
  m_sg.Parent           := self;
  m_sg.Align            := alClient;
  m_sg.Options          := m_sg.Options + [goRowSelect];
  m_sg.FixedCols        := 0;
  m_sg.Color            := clInfoBk;
  m_sg.FixedColor       := clGrayText;
  m_sg.DefaultRowHeight := 20;
  m_sg.DefaultColWidth  := 100;
  m_sg.ColCount         := 2;
  m_sg.Visible          := true;

  m_sg.ColCount := 5;
  m_sg.Rows[0].Add(CSTR_PROPDESCR);
  m_sg.Rows[0].Add(CSTR_PROPVALUE);
  m_sg.Rows[0].Add(CSTR_ADDTOOCC);
  m_sg.Rows[0].Add(CSTR_DFLTRESOCC);
  m_sg.Rows[0].Add(CSTR_DFLTOCCOCC)
end;

//----------------------------------------------------------------------------//

destructor TMPropValuesShow.Destroy;
begin
  inherited Destroy
end;

//----------------------------------------------------------------------------//

procedure TMPropValuesShow.Show;
var
  i:       integer;
  rec:     PTRecShow;
  propRes: TPropRes;
begin
  if m_list.Count = 0 then
    m_sg.Visible := false
  else
  begin
    m_sg.Visible := true;

    m_sg.RowCount := m_list.Count + 1;

    for i := 0 to m_list.Count-1 do
    begin
      rec := PTRecShow(m_list[i]);
      propRes := TPropRes(rec.obj);

      m_sg.Rows[i+1].Add(GetPropDescr(rec.prop));
      m_sg.Rows[i+1].Add(FormatToShow(rec.prop, propRes.m_val));
      m_sg.Rows[i+1].Add(propRes.m_addResToOcc);
      m_sg.Rows[i+1].Add(IntToStr(propRes.m_dfltResOcc));
      m_sg.Rows[i+1].Add(IntToStr(propRes.m_dfltOccOcc))
    end
  end
end;

//----------------------------------------------------------------------------//

procedure TMPropRulesShow.ClickEval(Sender: TObject);
var
  rule: TCompRules;
  rec:  PTRecShow;
begin
  rec := PTRecShow(m_list[m_cbProp.ItemIndex]);
  rule := TCompRules(rec.obj);
  rule.Sort;
// MARIO EvaluateCompatResults(self, rec.prop, m_mskEdit.Text, rule)
end;

//----------------------------------------------------------------------------//

constructor TMPropRulesShow.CreatePropRulesShow(AOwner: TWinControl; isOtoO: boolean);
var
  pan: TPanel;
begin
  inherited CreatePropShow(AOwner);

  m_isOtoO := isOtoO;

  Parent  := AOwner;
  Visible := true;
  Align   := alClient;

  pan := TPanel.Create(self);
  pan.Parent := self;
  pan.Align := alTop;

  m_stProp         := TStaticText.Create(self);
  m_stProp.Parent  := self;
  m_stProp.Caption := CSTR_PROPCAP;
  m_stProp.Left    := 8;
  m_stProp.Width   := 100;
  m_stProp.Top     := 16;

  m_cbProp := TComboBox.Create(self);
  m_cbProp.Parent := self;
  m_cbProp.Height := 20;
  m_cbProp.Width  := 145;
  m_cbProp.Top    := 12;
  m_cbProp.Left   := 116;

  m_cbProp.Color    := clInfoBk;
  m_cbProp.Style    := csDropDownList;
  m_cbProp.OnChange := ChgPropRule;
  m_cbProp.Visible  := true;

  m_mskEdit := TMaskEdit.Create(self);
  m_mskEdit.Parent := self;
  m_mskEdit.Left    := 300;
  m_mskEdit.Width   := 70;
  m_mskEdit.Top     := 16;
  m_mskEdit.Visible := false;

  m_button := TcxButton.Create(self);
  m_button.Parent  := self;
  m_button.Caption := CSTR_TEST;
  m_button.Left    := 380;
  m_button.Width   := 30;
  m_button.Top     := 8;
  m_button.Visible := false;
  m_button.OnClick := ClickEval;

  m_sg                  := TStringGrid.Create(self);
  m_sg.Parent           := self;
  m_sg.Align            := alClient;
  m_sg.Options          := m_sg.Options + [goRowSelect];
  m_sg.FixedCols        := 0;
  m_sg.Color            := clInfoBk;
  m_sg.FixedColor       := clGrayText;
  m_sg.DefaultRowHeight := 20;
  m_sg.ColCount         := 2;
  m_sg.Visible          := false;

  if m_isOtoO then
    m_sg.ColCount := 5
  else
    m_sg.ColCount := 11;

  m_sg.Rows[0].Add(CSTR_CHECKSEQ);
  m_sg.Rows[0].Add(CSTR_RULVAL);
  m_sg.Rows[0].Add(CSTR_OP1);
  m_sg.Rows[0].Add(CSTR_OP2);
  m_sg.Rows[0].Add(CSTR_CMPVAL);

  if not m_isOtoO then
  begin
    m_sg.Rows[0].Add(CSTR_SUPADJ);
    m_sg.Rows[0].Add(CSTR_SUPTM);
    m_sg.Rows[0].Add(CSTR_SUPOVER);
    m_sg.Rows[0].Add(CSTR_SUPMUL);
    m_sg.Rows[0].Add(CSTR_SUPMULOVER);
    m_sg.Rows[0].Add(CSTR_SMGRP)
  end
end;

//----------------------------------------------------------------------------//

destructor TMPropRulesShow.Destroy;
begin
  inherited Destroy
end;

//----------------------------------------------------------------------------//

procedure TMPropRulesShow.ChgPropRule(Sender: TObject);
var
  i:        integer;
  rule:     TCompRules;
  rec:      PTSetupRec;
  checkSeq: integer;
  value:    variant;
  op:       TRuleOpType;
  toBase:   string;
  comp:     TCompatVal;
  prop:     TPropID;
  cnt:      integer;
begin
  rule := TCompRules(PTRecShow(m_list[m_cbProp.ItemIndex]).obj);
  rule.Sort;

  prop := PTRecShow(m_list[m_cbProp.ItemIndex]).prop;

  cnt := rule.GetItemCount;

  if cnt = 0 then
  begin
    m_stProp.Visible  := false;
    m_mskEdit.Visible := false;
    m_button.Visible  := false;
    m_sg.Visible      := false
  end
  else
  begin
    m_stProp.Visible  := true;
    m_mskEdit.Visible := true;
    m_button.Visible  := true;
    m_sg.Visible      := true;

    m_sg.RowCount := cnt + 1;

    for i := 1 to cnt do
    begin
      rec := rule.GetItem(i-1, checkSeq, toBase, value, op, comp);

      m_sg.Rows[i].Add(IntToStr(checkSeq));
      m_sg.Rows[i].Add(FormatToShow(prop, value));
      m_sg.Rows[i].Add(toBase);
      m_sg.Rows[i].Add(RTtypeToChar(op));
      m_sg.Rows[i].Add(IntToStr(comp));

      if not m_isOtoO then
      begin
        Assert(Assigned(rec));
        m_sg.Rows[i].Add(FromSadjToChar(rec.supAdjType));
        m_sg.Rows[i].Add(FloatToStr(rec.supTime));
        m_sg.Rows[i].Add(FloatToStr(rec.supOverlap));
        m_sg.Rows[i].Add(FloatToStr(rec.supMult));
        m_sg.Rows[i].Add(FloatToStr(rec.supMultOverlap));
        if rec.onSameGroup then
          m_sg.Rows[i].Add(CSTR_YES)
        else
          m_sg.Rows[i].Add(CSTR_NO)
      end
    end
  end
end;

//----------------------------------------------------------------------------//

procedure TMPropRulesShow.Show;
var
  i:       integer;
  rec:     PTRecShow;
begin
  if m_list.Count = 0 then
    m_cbProp.Visible := false
  else
  begin
    m_cbProp.Visible := true;

    m_cbProp.Items.Clear;

    for i := 0 to m_list.Count-1 do
    begin
      rec := PTRecShow(m_list[i]);
      m_cbProp.Items.Add(GetPropDescr(rec.prop));
    end;
    m_cbProp.ItemIndex := 0;
    m_cbProp.OnChange(m_cbProp)
  end
end;

//----------------------------------------------------------------------------//

function GetDescr(mtx: TCompatMatrix): string;
begin
  case mtx of
  CMX_code:           Result := CSTR_CMX_code;
  CMX_code_proc:      Result := CSTR_CMX_proc;
  CMX_code_prod:      Result := CSTR_CMX_prod_code;
  CMX_code_cat:       Result := CSTR_CMX_cat;
  CMX_code_prod_cat:  Result := CSTR_CMX_prod_cat;
  CMX_code_prod_proc: Result := CSTR_CMX_prod_proc
  end
end;

//----------------------------------------------------------------------------//

function GetMtxFromPos(pos: integer): TCompatMatrix;
begin
  case pos of
  0: Result := CMX_code;
  1: Result := CMX_code_proc;
  2: Result := CMX_code_prod;
  3: Result := CMX_code_cat;
  4: Result := CMX_code_prod_cat;
  else
    begin
      Assert(pos = 5);
      Result := CMX_code_prod_proc
    end
  end
end;

//----------------------------------------------------------------------------//

function GetMatrixFromList(mtx: TCompatMatrix; mtxList: TList): TOrigMatrix;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to mtxList.Count-1 do
    if TOrigMatrix(mtxList[i]).m_mtx = mtx then
    begin
      Result := TOrigMatrix(mtxList[i]);
      exit
    end
end;

//----------------------------------------------------------------------------//

procedure TMDevPropComp.ChgMtxType(Sender: TObject);
var
  i:       integer;
  pId:     TPropId;
  obj:     TObject;
  mtxType: TCompatMatrix;
  cbShow1: TComboBox;
  cbShow2: TComboBox;
  mat1:    TOneDmatrix;
  mat2:    TTwoDmatrix;
  mat3:    TThreeDmatrix;
  num:     integer;
begin
  mtxType := GetMtxFromPos(m_cbProp.ItemIndex);
  case mtxType of

  CMX_code:
    begin
      if Assigned(m_cbProc)  then  m_cbProc.Visible := false;
      if Assigned(m_cbCat)   then  m_cbCat.Visible  := false;
      if Assigned(m_cbProd)  then  m_cbProd.Visible := false;

      mat1 := TOneDmatrix(GetMatrixFromList(mtxType, m_mtxList));

      Assert(Assigned(mat1));
      num := mat1.GetLev1Count;
      m_propShow.Reset;
      for i := 0 to num-1 do
      begin
        obj :=  mat1.GetLev1Obj(i, pId);
        m_propShow.AddObj(pId, obj);
      end;
      m_propShow.Show
    end;

    CMX_code_proc, CMX_code_cat, CMX_code_prod:
    begin
      mat2 := TTwoDmatrix(GetMatrixFromList(mtxType, m_mtxList));
      Assert(Assigned(mat2));
      num := mat2.GetLev1Count;

      if      mtxType = CMX_code_proc then
        cbShow1 := m_cbProc
      else if mtxType = CMX_code_cat then
        cbShow1 := m_cbCat
      else    // CMX_code_prod
        cbShow1 := m_cbProd;

      if Assigned(m_cbProc) then m_cbProc.Visible := false;
      if Assigned(m_cbCat)  then m_cbCat.Visible  := false;
      if Assigned(m_cbProd) then m_cbProd.Visible := false;

      m_propShow.Reset;

      if num > 0 then
      begin
        cbShow1.Visible := true;

        Assert(Assigned(mat2));
        cbShow1.Items.Clear;
        for i := 0 to num-1 do
          cbShow1.Items.Add(mat2.GetLev1Key(i));
        cbShow1.ItemIndex := 0;
        cbShow1.OnChange(cbShow1)
      end
    end;

  CMX_code_prod_proc, CMX_code_prod_cat:
    begin
      mat3 := TThreeDmatrix(GetMatrixFromList(mtxType, m_mtxList));
      Assert(Assigned(mat3));
      num := mat3.GetLev1Count;

      if mtxType = CMX_code_prod_proc then
      begin
        cbShow1 := m_cbProd;
        cbShow2 := m_cbProc
      end
      else    // CMX_code_prod_cat
      begin
        cbShow1 := m_cbProd;
        cbShow2 := m_cbCat
      end;

      if Assigned(m_cbProc) then m_cbProc.Visible := false;
      if Assigned(m_cbCat)  then m_cbCat.Visible  := false;
      if Assigned(m_cbProd) then m_cbProd.Visible := false;

      m_propShow.Reset;

      if num > 0 then
      begin
        cbShow1.Visible  := true;
        cbShow2.Visible  := true;

        Assert(Assigned(mat3));
        cbShow1.Items.Clear;
        for i := 0 to num-1 do
          cbShow1.Items.Add(mat3.GetLev1Key(i));
        cbShow1.ItemIndex := 0;
        cbShow1.OnChange(cbShow1)
      end
    end
  end
end;

//----------------------------------------------------------------------------//

procedure TMDevPropComp.ChgCombo(Sender: TObject);
var
  i:        integer;
  pId:      TPropId;
  obj:      TObject;
  cbChg1:   TComboBox;
  cbChg2:   TComboBox;
  mtxType:  TCompatMatrix;
  mat2:     TTwoDmatrix;
  mat3:     TThreeDmatrix;
  num:      integer;
begin
  mtxType := GetMtxFromPos(m_cbProp.ItemIndex);

  case mtxType of
  CMX_code_proc, CMX_code_cat, CMX_code_prod:
    begin
      mat2 := TTwoDmatrix(GetMatrixFromList(mtxType, m_mtxList));
      Assert(Assigned(mat2));

      if      mtxType = CMX_code_proc then
        cbChg1 := m_cbProc
      else if mtxType = CMX_code_cat then
        cbChg1 := m_cbCat
      else    // CMX_code_prod
        cbChg1 := m_cbProd;

      num := mat2.GetLev2Count(cbChg1.ItemIndex);
      m_propShow.Reset;
      for i := 0 to num-1 do
      begin
        obj := mat2.GetLev2Obj(cbChg1.ItemIndex, i, pId);
        m_propShow.AddObj(pId, obj);
      end;
      m_propShow.Show
    end;

  CMX_code_prod_proc, CMX_code_prod_cat:
    begin
      mat3 := TThreeDmatrix(GetMatrixFromList(mtxType, m_mtxList));
      Assert(Assigned(mat3));

      if mtxType = CMX_code_prod_proc then
      begin
        cbChg1 := m_cbProd;
        cbChg2 := m_cbProc
      end
      else    // CMX_code_prod_cat
      begin
        cbChg1 := m_cbProd;
        cbChg2 := m_cbCat
      end;

      if Sender = cbChg1 then
      begin
        // fill the secundary combobox
        num := mat3.GetLev2Count(cbChg1.ItemIndex);
        cbChg2.Items.Clear;
        for i := 0 to num-1 do
          cbChg2.Items.Add(mat3.GetLev2Key(cbChg1.ItemIndex, i));
        cbChg2.ItemIndex := 0
      end;

      num := mat3.GetLev3Count(cbChg1.ItemIndex, cbChg2.ItemIndex);
      m_propShow.Reset;
      for i := 0 to num-1 do
      begin
        obj :=  mat3.GetLev3Obj(cbChg1.ItemIndex, cbChg2.ItemIndex, i, pId);
        m_propShow.AddObj(pId, obj);
      end;
      m_propShow.Show
    end
  end
end;

//----------------------------------------------------------------------------//

function TMDevPropComp.CreateCombo(tit: string; chgFnc: TNotifyEvent): TComboBox;
var
  gpb: TGroupBox;
begin
  gpb := TGroupBox.Create(self);
  gpb.Parent  := m_topPanel;
  gpb.Caption := tit;
  gpb.Height  := 50;
  gpb.Width   := 250;

  if (m_cbPos = 0) or (m_cbPos = 2) then
    gpb.Left := 8
  else
    gpb.Left := 265;

  if (m_cbPos = 0) or (m_cbPos = 1) then
    gpb.Top := 8
  else
    gpb.Top := 60;
  gpb.Visible := true;

  Inc(m_cbPos);

  Result := TComboBox.Create(self);
  Result.Parent := gpb;
  Result.Height := 20;
  Result.Width  := 235;
  Result.Top    := 16;
  Result.Left   := 8;

  Result.Color    := clInfoBk;
  Result.Style    := csDropDownList;
  Result.OnChange := chgFnc;
  Result.Visible  := true
end;

//----------------------------------------------------------------------------//

function ExtractSet(mtxList: TList): TCmxSet;
var
  i: integer;
begin
  Result := [];
  for i := 0 to mtxList.Count-1 do
    Result := Result + [TOrigMatrix(mtxList[i]).m_mtx]
end;

//----------------------------------------------------------------------------//

constructor TMDevPropComp.CreatePropComp(AOwner: TWinControl; filterCat: string;
                                      mtxList: TList; isForRules, isOtoO: boolean);
var
  mtxSet: TCmxSet;
  i:      integer;
begin
  inherited Create(AOwner);
  m_cbPos   := 0;
  m_mtxList := mtxList;

  Parent  := AOwner;
  Visible := true;
  Align   := alClient;

  m_topPanel := TPanel.Create(self);
  m_topPanel.Parent := self;
  m_topPanel.Align := alTop;

  if isForRules then
    m_propShow := TMPropRulesShow.CreatePropRulesShow(self, isOtoO)
  else
    m_propShow := TMPropValuesShow.CreatePropValuesShow(self);

  m_cbProp := CreateCombo(CSTR_MTXTYPE, ChgMtxType);
  m_cbProc := nil;
  m_cbCat  := nil;
  m_cbProd := nil;

  mtxSet := ExtractSet(mtxList);
  if ([CMX_code_proc,CMX_code_prod_proc] * mtxSet) <> [] then
    m_cbProc  := CreateCombo(CSTR_WKCTPROC, ChgCombo);

  if ([CMX_code_cat,CMX_code_prod_cat] * mtxSet) <> [] then
    m_cbCat := CreateCombo(CSTR_RESGRP, ChgCombo);

  if ([CMX_code_prod,CMX_code_prod_proc,CMX_code_prod_cat] * mtxSet) <> [] then
    m_cbProd  := CreateCombo(CSTR_PRODTYP, ChgCombo);

  if m_cbPos < 3 then
    m_topPanel.Height := 60
  else
    m_topPanel.Height := 120;

  if mtxList.Count = 0 then
  begin
  end
  else
  begin
    for i := 0 to mtxList.Count-1 do
      m_cbProp.Items.Add(GetDescr(TOrigMatrix(mtxList[i]).m_mtx));
    m_cbProp.ItemIndex := 0;
    m_cbProp.OnChange(m_cbProp)
  end
end;

//----------------------------------------------------------------------------//

destructor TMDevPropComp.Destroy;
begin
  m_mtxList.Free;
  inherited Destroy;
end;

//----------------------------------------------------------------------------//
end.

