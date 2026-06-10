unit UMResCat;

interface

uses
  Classes,
  Dialogs,
  gnugettext,
  UMCompat,
  UMCompatRules,
  UMCompatSrv;

type

  TMqmResCat = class
    constructor CreateResCat(Code, descr: string);
    destructor  Destroy; override;
  private
    m_Code:  string;
    m_descr: string;
  public
    function GetDescr: string;
    property p_ResCatCode: string    read m_code;
    property p_ResCatDesc: string    read m_descr;

  // compatibility handling section

  private

    m_propMtx:      array[1..1] of TOrigMatrix;
    m_rulesRtoOMtx: array[1..2] of TOrigMatrix;
    m_rulesOtoOMtx: array[1..2] of TOrigMatrix;

  public

    function GetValueForProperty(pID: TPropID; mtx: TCompatMatrix): TPropRes;
    function GetRuleRtoOfForProperty(pID: TPropID; mtx: TCompatMatrix; prod: string): TCompRules;
    function GetRuleOtoOfForProperty(pID: TPropID; mtx: TCompatMatrix; prod: string): TCompRules;
    function AddProperty(code: string; var val: TPropResRec; ErrList: TStringList): boolean;
    function AddRtoOrule(code: string; var val: TRuleResRec; ErrList: TStringList): boolean;
    function AddOtoOrule(code: string; var val: TRuleResRec; ErrList: TStringList): boolean;

    procedure GetPropMtxs(lst: TList);
    function  GetRulesRtoOMtxs: TList;
    function  GetRulesOtoOMtxs: TList;
  end;

implementation

const

  PropMtxMap: array[TCompatMatrix] of integer = (
        1,  // simple code
       -1,  // code and process
       -1,  // code and product type
       -1,  // code and resource category
       -1,  // code, product type and resource category
       -1   // code, product type and process
      );

  RulesRtoOMtxMap: array[TCompatMatrix] of integer = (
        1,  // simple code
       -1,  // code and process
        2,  // code and product type
       -1,  // code and resource category
       -1,  // code, product type and resource category
       -1   // code, product type and process
      );

  RulesOtoOMtxMap: array[TCompatMatrix] of integer = (
        1,  // simple code
       -1,  // code and process
        2,  // code and product type
       -1,  // code and resource category
       -1,  // code, product type and resource category
       -1   // code, product type and process
      );

//----------------------------------------------------------------------------//

constructor TMqmResCat.CreateResCat(Code, descr: string);
var
  cmpM: TCompatMatrix;
begin
  inherited Create;
  m_Code  := Code;
  m_descr := descr;
  
  // initialize compatibility matrixes

  for cmpM := Low(TCompatMatrix) to High(TCompatMatrix) do
  begin
    // for the resource properties
    if PropMtxMap[cmpM] <> -1 then m_propMtx[PropMtxMap[cmpM]] := nil;

    // for the R to O compatibility rules
    if RulesRtoOMtxMap[cmpM] <> -1 then m_rulesRtoOMtx[RulesRtoOMtxMap[cmpM]] := nil;

    // for the O to O compatibility rules
    if RulesOtoOMtxMap[cmpM] <> -1 then m_rulesOtoOMtx[RulesOtoOMtxMap[cmpM]] := nil
  end

end;

//----------------------------------------------------------------------------//

destructor TMqmResCat.Destroy;
begin
//  if assigned(m_propMtx[1]) then
//    TOrigMatrix(m_propMtx[1]).free;
//  m_propMtx[1] := nil;

//  if assigned(m_rulesRtoOMtx[1]) then
//    TOrigMatrix(m_rulesRtoOMtx[1]).free;
//  m_rulesRtoOMtx[1] := nil;

//  if assigned(m_rulesRtoOMtx[2]) then
//    TOrigMatrix(m_rulesRtoOMtx[2]).free;
//  m_rulesRtoOMtx[2] := nil;

//  if assigned(m_rulesOtoOMtx[1]) then
//    TOrigMatrix(m_rulesOtoOMtx[1]).free;
//  m_rulesOtoOMtx[1] := nil;

//  if assigned(m_rulesOtoOMtx[2]) then
//    TOrigMatrix(m_rulesOtoOMtx[2]).free;
//  m_rulesOtoOMtx[2] := nil;

  inherited Destroy;
end;

//----------------------------------------------------------------------------//

function TMqmResCat.GetDescr: string;
begin
  Result := _('Category') + ' ' + p_ResCatCode;
end;

//----------------------------------------------------------------------------//

function TMqmResCat.GetValueForProperty(pID: TPropID; mtx: TCompatMatrix): TPropRes;
var
  mtxVal: TOrigMatrix;
begin
  Result := nil;
  mtxVal := m_propMtx[PropMtxMap[mtx]];
  if not Assigned(mtxVal) then exit;
  Result := TPropRes(TOneDmatrix(mtxVal).GetObject(pID));
end;

//----------------------------------------------------------------------------//

function TMqmResCat.GetRuleRtoOfForProperty(pID: TPropID; mtx: TCompatMatrix;
                                            prod: string): TCompRules;
var
  mtxVal: TOrigMatrix;
begin
  Result := nil;
  if RulesRtoOMtxMap[mtx] = -1 then exit;
  mtxVal := m_rulesRtoOMtx[RulesRtoOMtxMap[mtx]];
  if not Assigned(mtxVal) then exit;

  case mtx of
  CMX_code:      Result := TCompRules(TOneDmatrix(mtxVal).GetObject(pID));
  CMX_code_prod: Result := TCompRules(TTwoDmatrix(mtxVal).GetObject(pID,prod));
  else
    Assert(false)
  end
end;

//----------------------------------------------------------------------------//

function TMqmResCat.GetRuleOtoOfForProperty(pID: TPropID; mtx: TCompatMatrix;
                                            prod: string): TCompRules;
var
  mtxVal: TOrigMatrix;
begin
  Result := nil;
  if RulesOtoOMtxMap[mtx] = -1 then exit;
  mtxVal := m_rulesOtoOMtx[RulesOtoOMtxMap[mtx]];
  if not Assigned(mtxVal) then exit;

  case mtx of
  CMX_code:      Result := TCompRules(TOneDmatrix(mtxVal).GetObject(pID));
  CMX_code_prod: Result := TCompRules(TTwoDmatrix(mtxVal).GetObject(pID,prod));
  else
    Assert(false)
  end
end;

//----------------------------------------------------------------------------//

procedure TMqmResCat.GetPropMtxs(lst: TList);
var
  cmpM: TCompatMatrix;
begin
  for cmpM := Low(TCompatMatrix) to High(TCompatMatrix) do
  begin
    if (PropMtxMap[cmpM] = -1) or
       (not Assigned(m_propMtx[PropMtxMap[cmpM]])) then continue;
    lst.Add(m_propMtx[PropMtxMap[cmpM]])
  end
end;

//----------------------------------------------------------------------------//

function TMqmResCat.GetRulesRtoOMtxs: TList;
var
  cmpM: TCompatMatrix;
begin
  Result := TList.Create;

  for cmpM := Low(TCompatMatrix) to High(TCompatMatrix) do
  begin
    if (RulesRtoOMtxMap[cmpM] = -1) or
       (not Assigned(m_rulesRtoOMtx[RulesRtoOMtxMap[cmpM]])) then continue;
    Result.Add(m_rulesRtoOMtx[RulesRtoOMtxMap[cmpM]])
  end
end;

//----------------------------------------------------------------------------//

function TMqmResCat.GetRulesOtoOMtxs: TList;
var
  cmpM: TCompatMatrix;
begin
  Result := TList.Create;

  for cmpM := Low(TCompatMatrix) to High(TCompatMatrix) do
  begin
    if (RulesOtoOMtxMap[cmpM] = -1) or
       (not Assigned(m_rulesOtoOMtx[RulesOtoOMtxMap[cmpM]])) then continue;
    Result.Add(m_rulesOtoOMtx[RulesOtoOMtxMap[cmpM]])
  end
end;

//------------------------------------------------------\----------------------//

function TMqmResCat.AddProperty(code: string; var val: TPropResRec; ErrList: TStringList): boolean;
var
  propRes: TPropRes;
  pId:     TPropID;
  tpLink:  TCompatTopoLink;
  mtx:     TCompatMatrix;
  mtxVal:  TOrigMatrix;
begin
  propRes := TPropRes.Create;

  propRes.m_addResToOcc := val.addResToOcc;
  propRes.m_dfltResOcc  := val.dfltResOcc;
  propRes.m_dfltOccOcc  := val.dfltOccOcc;
  propRes.m_ValForGrp   := val.ValForGrp;
  propRes.m_dfltSameGrp := val.dfltSameGrp;

  pId := DecodeProp(code, val.valStr, propRes.m_val);
  if not Assigned(pId) then
  begin
    ErrList.Add(GetDescr + ': ' + _('Error loading property') + ' ' + code);
    Result := false;
    exit
  end;
{
  // mario to put on log
  if not Assigned(pId) then
  begin
    Result := false;
    exit
  end;
}
  GetPropCoordForValue(pID, tpLink, mtx);
  Assert(tpLink = CTL_cat);

  Assert(PropMtxMap[mtx] <> -1);
  if not Assigned(m_propMtx[PropMtxMap[mtx]]) then
    CreateMatrix(m_propMtx[PropMtxMap[mtx]], mtx);

  mtxVal := m_propMtx[PropMtxMap[mtx]];

  Assert(mtx = CMX_code);
  TOneDmatrix(mtxVal).AddObject(pId, propRes);

  Result := true
end;

//----------------------------------------------------------------------------//

procedure AssignRuleToMat(pId: TPropID; mtx: TCompatMatrix; mtxVal: TOrigMatrix;
                          isOtoO: boolean; var vrnt: variant; var val: TRuleResRec);
var
  oneDmtx: TOneDmatrix;
  twoDmtx: TTwoDmatrix;
  rule:    TCompRules;
  sup:     TSetupRec;
begin
  rule := nil;

  case mtx of
  CMX_code: begin
              oneDmtx := TOneDmatrix(mtxVal);
              rule := TCompRules(oneDmtx.GetObject(pId));
              if not Assigned(rule) then
              begin
                rule := TCompRules.Create;
                oneDmtx.AddObject(pId, rule)
              end
            end;

  CMX_code_prod: begin // code and product type
                   twoDmtx := TTwoDmatrix(mtxVal);
                   rule := TCompRules(twoDmtx.GetObject(pId, val.prodType));
                   if not Assigned(rule) then
                   begin
                     rule := TCompRules.Create;
                     twoDmtx.AddObject(pId, val.prodType, rule)
                   end
                 end;
  end;

  Assert(Assigned(rule));

  if not isOtoO then
    rule.AddItem(val.checkSeq, val.toBase, vrnt, val.op, val.comp, nil)
  else
  begin
    sup.Value          := ConvPropValue(pId, val.constStr);
    sup.supAdjType     := val.supAdjType;
    sup.supTime        := val.supTime;
    sup.supOverlap     := val.supOverlap;
    sup.supMult        := val.supMult;
    sup.supMultOverlap := val.supMultOverlap;
    sup.Teoreticl_wc     := val.Teoreticl_wc;
    sup.Duration         := val.Duration;
    sup.LeadTime         := val.LeadTime;
    sup.FromPos          := val.FromPos;
    sup.Length           :=  val.Length;
    sup.RuleForPartialPropVal := val.RuleForPartialPropVal;
    sup.WhenOkNextSeq    := val.WhenOkNextSeq;
    sup.NumOfdec         := val.NumOfdec;
    sup.Sequence         := val.Sequence;
    sup.CurveCode        := val.CurveCode;

    if val.onSameGroup = '0' then
      sup.OnSameGroupInt := 0
    else if val.onSameGroup = '1' then
      sup.OnSameGroupInt := 1
    else if val.onSameGroup = '2' then
      sup.OnSameGroupInt := 2;

    if val.onSameGroup = '1' then
      sup.onSameGroup := true
    else
      sup.onSameGroup := false;

    rule.AddItem(val.checkSeq, val.toBase, vrnt, val.op, val.comp, @sup)
  end
end;

//----------------------------------------------------------------------------//

function TMqmResCat.AddRtoOrule(code: string; var val: TRuleResRec; ErrList: TStringList): boolean;
var
  pId:       TPropID;
  tpLink:    TCompatTopoLink;
  mtx:       TCompatMatrix;
  vrnt:      variant;
begin
  pId := DecodeProp(code, val.valStr, vrnt);
  if not Assigned(pId) then
  begin
    ErrList.Add(GetDescr + ': ' + _('Error loading property') + ' ' + code);
    Result := false;
    exit
  end;

  GetPropCoordForRtoOcomp(pId, tpLink, mtx);
  if tpLink <> CTL_cat then
  begin
    ErrList.Add(GetDescr + ': ' + _('Error loading property') + ' ' + code + ' ' +
      _('System expect this property to be defined as Ressource category'));
    Result := false;
    exit
  end;

//  Assert(tpLink = CTL_cat);

  Assert(RulesRtoOMtxMap[mtx] <> -1);
  if not Assigned(m_rulesRtoOMtx[RulesRtoOMtxMap[mtx]]) then
    CreateMatrix(m_rulesRtoOMtx[RulesRtoOMtxMap[mtx]], mtx);

  AssignRuleToMat(pId, mtx, m_rulesRtoOMtx[RulesRtoOMtxMap[mtx]], false, vrnt, val);
  Result := true
end;

//----------------------------------------------------------------------------//

function TMqmResCat.AddOtoOrule(code: string; var val: TRuleResRec; ErrList: TStringList): boolean;
var
  pId:    TPropID;
  tpLink: TCompatTopoLink;
  mtx:    TCompatMatrix;
  vrnt:   variant;
begin
  pId := DecodeProp(code, val.valStr, vrnt);
  if not Assigned(pId) then
  begin
    ErrList.Add(GetDescr + ': ' + _('Error loading property') + ' ' + code);
    Result := false;
    exit
  end;

  GetPropCoordForOtoOcomp(pId, tpLink, mtx);
  Assert(tpLink = CTL_cat);

  Assert(RulesOtoOMtxMap[mtx] <> -1);
  if not Assigned(m_rulesOtoOMtx[RulesOtoOMtxMap[mtx]]) then
    CreateMatrix(m_rulesOtoOMtx[RulesOtoOMtxMap[mtx]], mtx);

  AssignRuleToMat(pId, mtx, m_rulesOtoOMtx[RulesOtoOMtxMap[mtx]], true, vrnt, val);
  Result := true
end;

//----------------------------------------------------------------------------//
end.
