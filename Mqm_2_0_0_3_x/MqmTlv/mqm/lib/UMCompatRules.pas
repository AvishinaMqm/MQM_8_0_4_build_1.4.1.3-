unit UMCompatRules;

interface

uses
  classes,
  UMCompat,
  UMCompatSrv;

type

  TSetupRec = record
    Value:          variant;
    supAdjType:     CScSupAdj;
    supTime:        double;
    AddToSetup:     double;
    AddToOverlap:   double;
    supOverlap:     double;
    supMult:        double;
    supMultOverlap: double;
    onSameGroup:    boolean;
    OnSameGroupInt: Integer;
    teoreticl_wc :  string;
    duration     :  double;
    LeadTime     :  double;
    toAdd:          boolean;
    RuleFound:      boolean;
    FromPos:        Integer;
    Length:          Integer;
    RuleForPartialPropVal : CScRuleForPropVal;
    NumOfdec:       Integer;
    WhenOkNextSeq:  Integer;
    Sequence     :  Integer;
    Report_jobPropValPartial : variant;
    Report_jobPrecPropValPartial : variant;
    CurveCode : string;
  end;
  PTSetupRec = ^TSetupRec;

  TRuleOpType = (RO_GT, RO_LT, RO_EQ, RO_NE, RO_GE, RO_LE, RO_VRplus, RO_VRminus,
                 RO_VRpercPlus, RO_VRpercMinus, RO_Custom1, RO_Custom2, RO_Contains);

  TCompRules = class(TObject)
    constructor Create;
    destructor  Destroy; override;
    function    EvaluateCompat(jobVal, resVal: variant; DefVal: TCompatVal; var pos: integer): TCompatVal;
    function    EvaluateSetupParms(jobVal, precJobVal: variant; DefVal: TCompatVal;
                                   JobProp, PrevJobProp: TProperties; PropId: TPropID;
                                   var supRec: TSetupRec; var pos: integer ;var IsSameGroup : boolean ;
                                   var SameGroupInt : Integer; var CurveCode : string): TCompatVal;
    procedure   Sort;
    procedure   AddItem(checkSeq: integer; toBase: string; value: variant;
                        op: string; comp: TCompatVal; sup: PTSetupRec);
    function    GetItemCount: integer;
    function    GetItem(pos: integer; var checkSeq: integer; var toBase: string;
                        var value: variant; var op: TRuleOpType;
                        var comp: TCompatVal): PTSetupRec;
  private
    m_hasExt: boolean;
    m_sorted: boolean;
    m_list:   TList;

  public
    property p_hasExt: boolean read m_hasExt;
  end;

  function RTtypeToChar(op: TRuleOpType): string;

implementation

uses
  sysutils, System.Math, System.AnsiStrings, Vcl.Dialogs, gnugettext;

type

  TRuleRec = record
    checkSeq:  integer;
    op:        TRuleOpType;
    toBaseDep: string;
    DepValue:  variant;
    comp:      TCompatVal;
    sup:       PTSetupRec;
  end;
   PTRuleRec = ^TRuleRec;

  function CustomOOCompat1(PropId: TPropID; JobProp, PrevJobProp: TProperties; setupRec: PTSetupRec; DepValue : Variant): boolean; external 'MqmCustomCompat.dll';
  function CustomOOCompat2(PropId: TPropID; JobProp, PrevJobProp: TProperties; setupRec: PTSetupRec; DepValue : Variant): boolean; external 'MqmCustomCompat.dll';
{$ifdef STATISTICS}
var
  s_ruleItems: integer;
  s_ruleCreat: integer;
{$endif}
//----------------------------------------------------------------------------//

constructor TCompRules.Create;
begin
  inherited Create;
  m_hasExt := false;
  m_sorted := true;
  m_list   := TList.Create;

{$ifdef STATISTICS}
  Inc(s_ruleCreat)
{$endif}
end;

//----------------------------------------------------------------------------//

destructor TCompRules.Destroy;
var
  rr: PTRuleRec;
  i:  integer;
begin
  for i := 0 to m_list.Count-1 do
  begin
    rr := PTRuleRec(m_list[i]);
    if Assigned(rr.sup) then Dispose(PTSetupRec(rr.sup));
    Dispose(rr)
  end;

  m_list.Free;
  inherited Destroy
end;

//----------------------------------------------------------------------------//

function RTcharToType(ch: string): TRuleOpType;
begin
  if      ch = '01' then
    Result := RO_GT
  else if ch = '02' then
    Result := RO_LT
  else if ch = '03' then
    Result := RO_EQ
  else if ch = '04' then
    Result := RO_NE
  else if ch = '05' then
    Result := RO_GE
  else if ch = '06' then
    Result := RO_LE
  else if ch = '07' then
    Result := RO_VRplus
  else if ch = '08' then
    Result := RO_VRminus
  else if ch = '09' then
    Result := RO_VRpercPlus
  else if ch = '10' then
    Result := RO_VRpercMinus
  else if ch = '11' then
    Result := RO_Contains
  else
  begin
    if ch = '98' then
      Result := RO_Custom2
    else if ch = '99' then
      Result := RO_Custom1
  end;

end;

//----------------------------------------------------------------------------//

function RTtypeToChar(op: TRuleOpType): string;
begin
  if      op = RO_GT then
    Result := 'GT'
  else if op = RO_LT then
    Result := 'LT'
  else if op = RO_EQ then
    Result := 'EQ'
  else if op = RO_NE then
    Result := 'NE'
  else if op = RO_GE then
    Result := 'GE'
  else if op = RO_LE then
    Result := 'LE'
  else if op = RO_VRplus then
    Result := 'VARplus'
  else if op = RO_VRminus then
    Result := 'VARminus'
  else if op = RO_VRpercPlus then
    Result := 'VARpercPlus'
  else if op = RO_VRpercMinus then
    Result := 'VARpercMinus'
  else if op = RO_Contains then
    Result := 'Contains'
  else
  begin
    if op = RO_Custom2 then
      Result := 'Customized-2'
    else if op = RO_Custom1 then
      Result := 'Customized-1'
  end;

end;

//----------------------------------------------------------------------------//

function OrderOnChk(item1, item2: pointer): integer;
var
  rr1, rr2: PTRuleRec;
begin
  rr1 := item1;
  rr2 := item2;

  if      rr1.checkSeq < rr2.checkSeq then
    Result := -1
  else if rr1.checkSeq > rr2.checkSeq then
    Result :=  1
  else
    Result :=  0
end;

//----------------------------------------------------------------------------//

procedure TCompRules.Sort;
begin
  m_list.Sort(OrderOnChk);
  m_sorted := true
end;

//----------------------------------------------------------------------------//

function TCompRules.EvaluateCompat(jobVal, resVal: variant; DefVal: TCompatVal; var pos: integer): TCompatVal;
label
  FOUND;
var
  i:     integer;
  rr:    PTRuleRec;
  value: variant;
begin
  if not m_sorted then
  begin
    m_list.Sort(OrderOnChk);
    m_sorted := true;
  end;

  pos := -1;

  for i := 0 to m_list.Count-1 do
  begin
    rr  := PTRuleRec(m_list[i]);
    pos := i;

    Assert(not Assigned(rr.sup));

    case rr.op of
    RO_GT:
      begin
        if rr.toBaseDep = '1' then
          value := resVal
        else
          value := rr.DepValue;
        if jobVal > value then goto FOUND
      end;

    RO_LT:
      begin
        if rr.toBaseDep = '1' then
          value := resVal
        else
          value := rr.DepValue;
        if jobVal < value then goto FOUND
      end;

    RO_EQ:
      begin
        if rr.toBaseDep = '1' then
          value := resVal
        else
          value := rr.DepValue;
        if jobVal = value then goto FOUND
      end;

    RO_NE:
      begin
        if rr.toBaseDep = '1' then
          value := resVal
        else
          value := rr.DepValue;
        if jobVal <> value then goto FOUND;
      end;

    RO_GE:
      begin
        if rr.toBaseDep = '1' then
          value := resVal
        else
          value := rr.DepValue;
        if jobVal >= value then goto FOUND;
      end;

    RO_LE:
      begin
        if rr.toBaseDep = '1' then
          value := resVal
        else
          value := rr.DepValue;
        if jobVal <= value then goto FOUND;
      end;

    RO_VRplus:
      if (jobVal >= resVal) and (jobVal <= (resVal+rr.DepValue)) then goto FOUND;

    RO_VRminus:
      if (jobVal <= resVal) and (jobVal >= (resVal-rr.DepValue)) then goto FOUND;

    RO_VRpercPlus:
      if (jobVal >= resVal) and (jobVal <= (resVal*(1+rr.DepValue/100))) then goto FOUND;

    RO_VRpercMinus:
      if (jobVal <= resVal) and (jobVal >= (resVal*(1-rr.DepValue/100))) then goto FOUND;

    RO_Contains:
      begin
        if rr.toBaseDep = '1' then
          value := resVal
        else
          value := rr.DepValue;
        if AnsiContainsStr(jobVal , value) then goto FOUND;
      end;

    end

  end;
  Result := DefVal;
  pos := -1;
  exit;

FOUND:
  Result := rr.comp
end;

//----------------------------------------------------------------------------//

function TCompRules.EvaluateSetupParms(jobVal, precJobVal: variant; DefVal: TCompatVal;
                                   JobProp, PrevJobProp: TProperties; PropId: TPropID;
                                   var supRec: TSetupRec; var pos: integer ;var IsSameGroup : boolean ;
                                   var SameGroupInt : Integer; var CurveCode : string): TCompatVal;


label
  FOUND, FOUNDFINAL;
var
  i:     integer;
  rr:    PTRuleRec;
  value, tempvalue1, tempvalue2: variant;
  OrigjobVal, OrigprecJobVal: variant;
  GoToSequence : boolean;
  GoToSequenceNumber : integer;
  iValue, iCode: Integer;
begin
  if not m_sorted then
  begin
    m_list.Sort(OrderOnChk);
    m_sorted := true;
  end;

  pos := -1;
  rr := nil;
  GoToSequence := false;
  GoToSequenceNumber := 0;
  OrigjobVal := jobVal;
  OrigprecJobVal := precJobVal;

  try
  for i := 0 to m_list.Count-1 do
  begin

    rr := PTRuleRec(m_list[i]);
    pos := i;

    if GoToSequence then
    begin
      if (rr.checkSeq <> GoToSequenceNumber) then continue;
      GoToSequence := false;
    end;

    if rr.sup.RuleForPartialPropVal = CSA_Yes_String then
    begin
      jobVal := copy(OrigjobVal, rr.sup.FromPos, rr.sup.Length);
      precJobVal := copy(OrigprecJobVal, rr.sup.FromPos, rr.sup.Length);
    end
    else if rr.sup.RuleForPartialPropVal = CSA_Yes_Numeric then
    begin
      tempvalue1 := copy(OrigjobVal, rr.sup.FromPos, rr.sup.Length);
      val(tempvalue1, iValue, iCode);
      if iCode = 0 then
      begin
        tempvalue2 := copy(OrigprecJobVal, rr.sup.FromPos, rr.sup.Length);
        val(tempvalue2, iValue, iCode);
        if iCode = 0 then
        begin
          jobVal := StrToFloat(tempvalue1);
          precJobVal := StrToFloat(tempvalue2);
          try
            if rr.sup.NumOfdec > 0 then
              jobVal := tempvalue1/(power(10, rr.sup.NumOfdec));
            except
            on E: Exception do
            begin
                ShowMessage(_('Error definition in property numeric rule / number of decimals for Property code') + ' ' +
                            GetPropCodeFromID(PropId));
            end;
          end;

          try
            if rr.sup.NumOfdec > 0 then
              precJobVal := tempvalue2/(power(10, rr.sup.NumOfdec));
            except
            on E: Exception do
            begin
              ShowMessage(_('Error definition in property numeric rule / number of decimals for Property code') + ' ' +
                          GetPropCodeFromID(PropId));
            end;
          end;
        end
        else
          continue;
      end
      else
        continue;
    end;

    if (rr.sup.RuleForPartialPropVal <> CSA_No) then // for the report
    begin
      rr.sup.Report_jobPropValPartial := jobVal;
      rr.sup.Report_jobPrecPropValPartial := precJobVal;
    end
    else
    begin
      rr.sup.Report_jobPropValPartial := '';
      rr.sup.Report_jobPrecPropValPartial := '';
    end;

    if ((rr.toBaseDep = '1') or (rr.toBaseDep = '6'))
    and (rr.depValue <> precJobVal) then
      continue;

    case rr.op of
    RO_GT:
      begin
        if (rr.toBaseDep = '1') or (rr.toBaseDep = '2')
        or (rr.toBaseDep = '6') or (rr.toBaseDep = '7') then
          value := rr.sup.value
        else
          value := precJobVal;
        if jobVal > value then goto FOUND
      end;

    RO_LT:
      begin
        if (rr.toBaseDep = '1') or (rr.toBaseDep = '2')
        or (rr.toBaseDep = '6') or (rr.toBaseDep = '7') then
          value := rr.sup.value
        else
          value := precJobVal;
        if jobVal < value then goto FOUND
      end;

    RO_EQ:
      begin
        if (rr.toBaseDep = '1') or (rr.toBaseDep = '2')
        or (rr.toBaseDep = '6') or (rr.toBaseDep = '7') then
          value := rr.sup.value
        else
          value := precJobVal;
        if jobVal = value then goto FOUND
      end;

    RO_NE:
      begin
        if (rr.toBaseDep = '1') or (rr.toBaseDep = '2')
        or (rr.toBaseDep = '6') or (rr.toBaseDep = '7') then
          value := rr.sup.value
        else
          value := precJobVal;
        if jobVal <> value then goto FOUND;
      end;

    RO_GE:
      begin
        if (rr.toBaseDep = '1') or (rr.toBaseDep = '2')
        or (rr.toBaseDep = '6') or (rr.toBaseDep = '7') then
          value := rr.sup.value
        else
          value := precJobVal;
        if jobVal >= value then goto FOUND
      end;

    RO_LE:
      begin
        if (rr.toBaseDep = '1') or (rr.toBaseDep = '2')
        or (rr.toBaseDep = '6') or (rr.toBaseDep = '7') then
          value := rr.sup.value
        else
          value := precJobVal;
        if jobVal <= value then goto FOUND
      end;

    RO_VRplus:
      if (jobVal >= precJobVal) and (jobVal <= (precJobVal+rr.sup.Value)) then goto FOUND;

    RO_VRminus:
      if (jobVal <= precJobVal) and (jobVal >= (precJobVal-rr.sup.Value)) then goto FOUND;

    RO_VRpercPlus:
      if (jobVal >= precJobVal) and (jobVal <= (precJobVal*(1+rr.sup.Value/100))) then goto FOUND;

    RO_VRpercMinus:
      if (jobVal <= precJobVal) and (jobVal >= (precJobVal*(1-rr.sup.Value/100))) then goto FOUND;

    RO_Custom1:
      if CustomOOCompat1(PropId, JobProp, PrevJobProp, rr.sup, rr.DepValue) then goto FOUND;

    RO_Custom2:
      if CustomOOCompat2(PropId, JobProp, PrevJobProp, rr.sup, rr.DepValue) then goto FOUND;

    end;

    continue;

    FOUND:
    if rr.sup.WhenOkNextSeq = 0 then GOTO FOUNDFINAL;
    GoToSequence := true;
    GoToSequenceNumber := rr.sup.WhenOkNextSeq;

  end;

// No rule was found - Apply default values //
  Result := DefVal;
  supRec.toAdd          := false;
  supRec.supAdjType     := CSA_copy;
  supRec.supTime        := 0;
  supRec.supOverlap     := 0;
  supRec.supMult        := 1;
  supRec.supMultOverlap := 1;
  supRec.teoreticl_wc   := '';
  supRec.duration       := 0;
  supRec.LeadTime       := 0;
  supRec.RuleFound      := false;
  supRec.WhenOkNextSeq  := rr.sup.WhenOkNextSeq;
  supRec.Sequence       := 0;
  supRec.CurveCode      := '';
  if rr.sup.RuleForPartialPropVal <> CSA_No then
  begin
    supRec.Report_jobPropValPartial     := rr.sup.Report_jobPropValPartial;
    supRec.Report_jobPrecPropValPartial := rr.sup.Report_jobPrecPropValPartial;
  end;
  pos := -1;
  exit;

FOUNDFINAL:

  if (rr.toBaseDep = '0')
  or (rr.toBaseDep = '1')
  or (rr.toBaseDep = '2') then
    supRec.toAdd := false
  else
    supRec.toAdd := true;

  supRec.Value          := rr.sup.Value;
  supRec.supAdjType     := rr.sup.supAdjType;
  supRec.supTime        := rr.sup.supTime;
  supRec.supOverlap     := rr.sup.supOverlap;
  supRec.supMult        := rr.sup.supMult;
  supRec.supMultOverlap := rr.sup.supMultOverlap;
  supRec.teoreticl_wc   := rr.sup.teoreticl_wc;
  supRec.duration       := rr.sup.duration;
  supRec.LeadTime       := rr.sup.LeadTime;
  supRec.Sequence       := rr.sup.Sequence;
  supRec.CurveCode      := rr.sup.CurveCode;
  supRec.Report_jobPropValPartial     := rr.sup.Report_jobPropValPartial;
  supRec.Report_jobPrecPropValPartial := rr.sup.Report_jobPrecPropValPartial;

  if (supRec.teoreticl_wc <> '') and (supRec.duration = 0) then
  begin
    supRec.teoreticl_wc := '';
    supRec.LeadTime := 0;
  end;

  supRec.RuleFound      := true;
  SameGroupInt          := rr.sup.OnSameGroupInt;
  if (SameGroupInt = 0) then
    IsSameGroup := false
  else
    IsSameGroup := true;

  CurveCode := rr.sup.CurveCode;

  Result := rr.comp

  except
    supRec.toAdd          := false;
    supRec.supAdjType     := CSA_copy;
    supRec.supTime        := 0;
    supRec.supOverlap     := 0;
    supRec.supMult        := 1;
    supRec.supMultOverlap := 1;
    supRec.RuleFound      := false;
    pos := -1;
    Result := 99;
  end;

end;

//----------------------------------------------------------------------------//

procedure TCompRules.AddItem(checkSeq: integer; toBase: string; value: variant;
                             op: string; comp: TCompatVal; sup: PTSetupRec);
var
  rr: PTRuleRec;
begin
  m_sorted := false;

{$ifdef STATISTICS}
  Inc(s_ruleItems);
{$endif}

  New(rr);
  rr.checkSeq  := checkSeq;
  rr.toBaseDep := toBase;
  rr.DepValue  := value;
  rr.op        := RTcharToType(op);
  rr.comp      := comp;
  rr.sup       := nil;

  if Assigned(sup) then
  begin
    m_hasExt := true;
    New(rr.sup);
    rr.sup^ := sup^
  end;

  m_list.Add(rr)
end;

//----------------------------------------------------------------------------//

function TCompRules.GetItemCount: integer;
begin
  Result := m_list.Count
end;

//----------------------------------------------------------------------------//

function TCompRules.GetItem(pos: integer; var checkSeq: integer; var toBase: string;
                            var value: variant; var op: TRuleOpType; var comp: TCompatVal): PTSetupRec;
var
  rr: PTRuleRec;
begin
  rr := PTRuleRec(m_list[pos]);
  checkSeq := rr.checkSeq;
  toBase   := rr.toBaseDep;
  value    := rr.DepValue;
  op       := rr.op;
  comp     := rr.comp;

  Result := rr.sup
end;

//----------------------------------------------------------------------------//
{$ifdef STATISTICS}
initialization
  s_ruleItems := 0;
  s_ruleCreat := 0;
{$endif}
//----------------------------------------------------------------------------//
end.
