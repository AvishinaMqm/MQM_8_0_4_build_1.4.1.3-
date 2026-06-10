unit UMUsrPropComp;

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
  UMObjCont,
  UMSchedContFunc,
  UMCompatSrv;

type

  TMShowPropList = class(TPanel)
    constructor CreateShowPropList(AOwner: TWinControl; PropList: TProperties; Id: TSchedId; ShowRes : boolean);
    destructor  Destroy; override;
    procedure   FillGrid;
    procedure   ChangePropList(PropList: TProperties);
  private
    m_PropList: TProperties;
    m_sg:       TStringGrid;
    m_Id:       TSchedId;
    m_ShowRes: boolean;
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
    constructor CreatePropValuesShow(AOwner: TWinControl; mtxList: TList);
    destructor  Destroy; override;
    procedure   Show; override;

  public
    m_filterCat: string;
  private
    m_sg:      TStringGrid;
    m_mtxList: TList;
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

  TMUsrPropComp = class(TMPropComp)
    constructor CreatePropComp(AOwner: TWinControl; filterCat: string;
                               mtxList: TList;
                               isForRules, isOtoO: boolean); override;
    destructor  Destroy; override;
  private
    m_mtxList:  TList;
    m_propShow: TMPropShow;
  end;

implementation

uses
  dialogs,
  Graphics,
  SysUtils,
  UMCompatRules,
  UMCommon,
  gnugettext;

resourcestring

  CSTR_YES = 'Yes';
  CSTR_NO  = 'No';

  CSTR_PROPWKCPROC = 'Wkc. proc.';
  CSTR_PROPDESCR   = 'Description';
  CSTR_PROPVALUE   = 'Value';
  CSTR_ADDTOOCC    = 'Res. added to occ';
  CSTR_DFLTRESOCC  = 'Default res. occ.';
  CSTR_DFLTOCCOCC  = 'Default occ. occ.';

  CSTR_CHECKSEQ    = 'Check sequence';
  CSTR_RULVAL      = 'Value';
  CSTR_OP1         = 'oper. 1';
  CSTR_OP2         = 'oper. 2';
  CSTR_CMPVAL      = 'compat value';

  CSTR_MTXTYPE     = 'Matrix type';
  CSTR_WKCTPROC    = 'Workcenter process';
  CSTR_RESGRP      = 'Resource group';
  CSTR_PRODTYP     = 'Product type';

  CSTR_CMX_code           = 'property code';
  CSTR_CMX_proc           = 'property code and process';
  CSTR_CMX_cat            = 'property code and group';
  CSTR_CMX_prod_code      = 'product type and code';
  CSTR_CMX_prod_proc      = 'product type, code and process';
  CSTR_CMX_prod_cat       = 'product type, code and group';

  CSTR_PROPCAP = 'Property';

  CSTR_SUPADJ     = 'Setup adjustment';
  CSTR_SUPTM      = 'Setup Time';
  CSTR_SUPOVER    = 'Setup Overlap';
  CSTR_SUPMUL     = 'Setup multiplier';
  CSTR_SUPMULOVER = 'Setup mult. over';
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

constructor TMShowPropList.CreateShowPropList(AOwner: TWinControl; PropList: TProperties; Id : TSchedId; ShowRes : boolean);
begin
  inherited Create(AOwner);

  Parent  := AOwner;
  Visible := true;
  Align   := alClient;
  m_ShowRes := ShowRes;

  m_Id                  := Id;
  m_sg                  := TStringGrid.Create(self);
  m_sg.Parent           := self;
  m_sg.Align            := alClient;
  m_sg.Options          := m_sg.Options + [goRowSelect,goColSizing];
  m_sg.FixedCols        := 0;
  m_sg.Color            := clInfoBk;
  m_sg.FixedColor       := clGrayText;
  m_sg.DefaultRowHeight := 20;
  m_sg.DefaultColWidth  := 100;
  m_sg.ColCount         := 2;
  m_sg.Visible          := true;

  m_sg.ColCount := 3;
  m_sg.Rows[0].Add(CSTR_PROPDESCR);
  if not m_ShowRes then
    m_sg.ColCount := 2
  else
  begin
    m_sg.ColCount := 3;
    m_sg.Rows[0].Add(_('Resource'));
  end;
  m_sg.Rows[0].Add(CSTR_PROPVALUE);
  m_sg.ColWidths[0] := 165;

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
  PropVal, TestedVal: variant;
  PropRscCode: string;
  i: integer;
  ValueDateTime : TDateTime;
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

      if IsPropDynamic(propId) then
      begin
        p_sc.GetPropVal(m_id,propId,TestedVal);
        if (TestedVal = PropVal) then
        begin
          PropVal := p_sc.GetPropDinamicVal(m_id,PropVal);
          PropVal := round(PropVal);
        end;
      end;

      if IsDateProp(propId) then
      begin
        if PropVal <> '' then
        begin
          ValueDateTime := GetDateFormatForStr(PropVal);
          PropVal   := DateTimeToStr(ValueDateTime);
        end;
      end;

      m_sg.Rows[i+1].Add(GetPropDescr(propId));
      if m_ShowRes then
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

constructor TMPropValuesShow.CreatePropValuesShow(AOwner: TWinControl; mtxList: TList);
begin
  inherited CreatePropShow(AOwner);

  Parent  := AOwner;
  Visible := true;
  Align   := alClient;

  m_sg                  := TStringGrid.Create(self);
  m_sg.Parent           := self;
  m_sg.Align            := alClient;
  m_sg.Options          := m_sg.Options + [goRowSelect];
  m_sg.FixedRows        := 1;
  m_sg.FixedCols        := 0;
  m_sg.Color            := clInfoBk;
  m_sg.FixedColor       := clGrayText;
  m_sg.DefaultRowHeight := 20;
  m_sg.DefaultColWidth  := 130;
  m_sg.ColCount         := 2;
  m_sg.Visible          := true;

  m_sg.Font.Name := 'Montserrat';
  //m_sg.Font.Size := 9;
  //m_sg.ParentFont := True;
  m_sg.ColCount := 5;
  m_sg.ColWidths[3] := 120;
  m_sg.Rows[0].Add(_('Wkc process'));
  m_sg.Rows[0].Add(CSTR_PROPDESCR);
  m_sg.Rows[0].Add(CSTR_PROPVALUE);
  m_sg.Rows[0].Add(CSTR_ADDTOOCC);
  m_sg.Rows[0].Add(CSTR_DFLTRESOCC);
  m_sg.Rows[0].Add(CSTR_DFLTOCCOCC);

  m_mtxList := mtxList
end;

//----------------------------------------------------------------------------//

destructor TMPropValuesShow.Destroy;
begin
  inherited Destroy
end;

//----------------------------------------------------------------------------//

procedure TMPropValuesShow.Show;

  procedure FormatRow(pId: TPropId; procDesc: string; propRes: TPropRes);
  var
    ndx: integer;
  begin
    ndx := m_sg.RowCount - 1;
    m_sg.Rows[ndx].Add('');
    m_sg.Rows[ndx].Add(GetPropDescr(pId));
    m_sg.Rows[ndx].Add(FormatToShow(pId, propRes.m_val));
    m_sg.Rows[ndx].Add(propRes.m_addResToOcc);
    m_sg.Rows[ndx].Add(IntToStr(propRes.m_dfltResOcc));
    m_sg.Rows[ndx].Add(IntToStr(propRes.m_dfltOccOcc));
    m_sg.RowCount := ndx + 2
  end;

var
  i:     integer;
  pId:      TPropId;
  mat1:     TOneDmatrix;
  mat2:     TTwoDmatrix;
  mtx:      TOrigMatrix;
  iProp:    integer;
  iProc:    integer;
  iCat:     integer;
  propRes:  TPropRes;
begin
  m_sg.RowCount := 2;

  for i := 0 to m_mtxList.Count-1 do
  begin
    mtx := TOrigMatrix(m_mtxList[i]);
    Assert((mtx.m_mtx <> CMX_code_prod)      and
           (mtx.m_mtx <> CMX_code_prod_proc) and
           (mtx.m_mtx <> CMX_code_prod_cat));

    case mtx.m_mtx of

    CMX_code:
      begin
        mat1 := TOneDmatrix(mtx);
        Assert(Assigned(mat1));

        for iProp := 0 to mat1.GetLev1Count - 1 do
        begin
          propRes := TPropRes(mat1.GetLev1Obj(iProp, pId));
          FormatRow(pId, '', propRes)
        end
      end;

    CMX_code_proc:
      begin
        mat2 := TTwoDmatrix(mtx);
        Assert(Assigned(mat2));

        for iProc := 0 to mat2.GetLev1Count - 1 do
          for iProp := 0 to mat2.GetLev2Count(iProc)-1 do
          begin
            propRes := TPropRes(mat2.GetLev2Obj(iProc, iProp, pId));
            FormatRow(pId, mat2.GetLev1Key(iProc), propRes)
          end
      end;

    CMX_code_cat:
      begin
        mat2 := TTwoDmatrix(mtx);
        Assert(Assigned(mat2));

        for iCat := 0 to mat2.GetLev1Count - 1 do
          for iProp := 0 to mat2.GetLev2Count(iCat)-1 do
          begin
            if mat2.GetLev1Key(iCat) <> m_filterCat then continue;
            propRes := TPropRes(mat2.GetLev2Obj(iCat, iProp, pId));
            FormatRow(pId, mat2.GetLev1Key(iCat), propRes)
          end
      end
    end
  end;

  m_sg.RowCount := m_sg.RowCount - 1  
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

function ExtractSet(mtxList: TList): TCmxSet;
var
  i: integer;
begin
  Result := [];
  for i := 0 to mtxList.Count-1 do
    Result := Result + [TOrigMatrix(mtxList[i]).m_mtx]
end;

//----------------------------------------------------------------------------//

constructor TMUsrPropComp.CreatePropComp(AOwner: TWinControl; filterCat: string;
                                         mtxList: TList; isForRules, isOtoO: boolean);
begin
  inherited Create(AOwner);
  m_mtxList := mtxList;

  Parent  := AOwner;
  Visible := true;
  Align   := alClient;

  if isForRules then
    m_propShow := TMPropRulesShow.CreatePropRulesShow(self, isOtoO)
  else
  begin
    m_propShow := TMPropValuesShow.CreatePropValuesShow(self, m_mtxList);
    TMPropValuesShow(m_propShow).m_filterCat := filterCat;
    m_propShow.Show
  end
end;

//----------------------------------------------------------------------------//

destructor TMUsrPropComp.Destroy;
begin
  m_mtxList.Free;
  inherited Destroy;
end;

//----------------------------------------------------------------------------//
end.

