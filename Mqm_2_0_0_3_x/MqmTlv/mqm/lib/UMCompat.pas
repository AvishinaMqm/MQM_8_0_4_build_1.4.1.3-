unit UMCompat;

interface

uses
  DMSrvPC;

type

  CScSupAdj = (CSA_copy, CSA_add, CSA_const, CSA_mult, CSA_AddTot);
  CScPropType = (CSA_Alpha, CSA_Numerc, CSA_Dynamic, CSA_Counter);
  CScRuleForPropVal = (CSA_No, CSA_Yes_String, CSA_Yes_Numeric);

  //--------------------------------------
  // records exported to including modules


  TPropResRec = record
    proc:        string;
    resCat:      string;
    valStr:      string;
    addResToOcc: string;
    dfltResOcc:  integer;
    dfltOccOcc:  integer;
    dfltSameGrp: integer;
    ValForGrp:   integer;
  end;


  TRuleResRec = record
    proc:           string;
    resCat:         string;
    prodType:       string;

    checkSeq:       integer;
    valStr:         string;
    op:             string;
    comp:           integer;
    toBase:         string;
    constStr:       string;

    supAdjType:     CScSupAdj;
    supTime:        double;
    supOverlap:     double;
    supMult:        double;
    supMultOverlap: double;
    teoreticl_wc :  string;
    duration     :  double;
    LeadTime     :  double;
    onSameGroup:    string;

    FromPos:        Integer;
    Length:          Integer;
    RuleForPartialPropVal : CScRuleForPropVal;
    NumOfdec:        Integer;
    WhenOkNextSeq:  Integer;
    Sequence : integer;
    CurveCode    : string
  end;
  PTRuleResRec = ^TRuleResRec;

  //--------------------------
  // unit related informations

  TCompatVal = -2..99;
  TErrVal    = 0..9;

  TPropID    = pointer;

  // types of matrix for the compatibility
  TCompatMatrix = (CMX_code,             // simple code
                   CMX_code_proc,        // code and process
                   CMX_code_prod,        // code and product type
                   CMX_code_cat,         // code and resource category
                   CMX_code_prod_cat,    // code, product type and resource category
                   CMX_code_prod_proc);  // code, product type and process

  TCompatTopoLink = (CTL_none,           // not defined
                     CTL_global,         // global level
                     CTL_cat,            // resource category level
                     CTL_wkc,            // workcenter level
                     CTL_res);           // resource level


  function CalcSetupFormula(supAdj: CScSupAdj;
                            supBase, supConst, supMult, AddToSetup: double): double;
  function CalcSetupOvlpFormula(supAdj: CScSupAdj;
                                supBase, supOvlpConst, supOvlpMult, AddToOverlap: double): double;
  function FromCharToSadj(str: string): CScSupAdj;
  function FromSadjToChar(supAdj: CScSupAdj): string;

  // used to preprocess the values of properties
  function  DecodeProp(code: string; valString: string; var val: variant): TPropID;
  function  DecodePropRule(code: string; valString: string; var val: variant): TPropID;
  procedure GetPropCoordForValue   (pId: TPropID; var tpLink: TCompatTopoLink; var mtx: TCompatMatrix);
  procedure GetPropCoordForRtoOcomp(pId: TPropID; var tpLink: TCompatTopoLink; var mtx: TCompatMatrix);
  procedure GetPropCoordForOtoOcomp(pId: TPropID; var tpLink: TCompatTopoLink; var mtx: TCompatMatrix);
  function  IsPropAffectSameGroupFlag(pId: TPropID): boolean;

  function  ConvPropValue(pId: TPropID; valString: string): variant;

  function  ConvPropValueRule(pId: TPropID; valString: string): variant;

  procedure LoadPropRec(qry: TMqmQuery);

  function  GetPropCodeFromID(pId: TPropID): string;

  function  GetPropertyCount : Integer;

  function  GetPropFromPos(ndx: integer): TPropID;

  function  GetNextProp(Index : Integer ; var Desc : string ; var PType : CScPropType) : string;

  function  GetPropType(pId: TPropID) : CScPropType;

  function  GetLength(pId: TPropID) : integer;

  function  ExistNumOfDecimal(pId: TPropID; var Len : Integer; var NumOfDecimal : Integer) : boolean;

  function  IsPropAlpha(Code : string) : boolean; overload;

  function  IsPropPlanner(pId: TPropID) : boolean;

  function  IsInstanceCounter(pId: TPropID) : boolean;

  function  GetPropInstanceCounterCode(pId: TPropID) : string;

  function  GetPropInstanceCounterValue(pId: TPropID) : string;

  procedure CleanAllPropertiesAsDate;

  procedure CleanAllPropertiesAsRGB;

  procedure SetUserAsDateProp(pId: TPropID ; Flag : boolean);

  procedure SetUserAsRGBProp(pId: TPropID ; Flag : boolean);

  procedure CleanAllApprovalDateProp;

  procedure CleanAllAssignedBooleanProp1;

  procedure CleanAllCalculatedHighDateProp;

  procedure CleanAllAssignedLimitGrpCountProp1;
  procedure CleanAllAssignedLimitGrpCountProp2;
  procedure CleanAllAssignedPropValueCompareLimitGroup1;
  procedure CleanAllAssignedPropValueCompareLimitGroup2;
  procedure SetCalculatedHighDateProp(pId: TPropID ; Flag : boolean);
  procedure SetAssignedLimitGrpCountProp1(pId: TPropID ; Flag : boolean);
  procedure SetAssignedLimitGrpCountProp2(pId: TPropID ; Flag : boolean);
  procedure SetAssignedPropValueCompareLimitGroup1(pId: TPropID ; Flag : boolean);
  procedure SetAssignedPropValueCompareLimitGroup2(pId: TPropID ; Flag : boolean);

  procedure SetApprovalDateProp(pId: TPropID ; Flag : boolean);

  procedure SetAssignedBooleanProp1(pId: TPropID ; Flag : boolean);

  function  GetCalculatedHighDateProp : TPropID;
  function  GetAssignedLimitGrpCountProp1 : TPropID;
  function  GetAssignedLimitGrpCountProp2 : TPropID;
  function  GetAssignedPropValueCompareLimitGroup1 : TpropID;
  function  GetAssignedPropValueCompareLimitGroup2 : TpropID;

  function  GetAssignedBooleanProp1 : TPropID;

  function  ExistAssignedBooleanProp1 : boolean;

  function  IsPropAsDate(pId: TPropID) : boolean;

  function  IsDateProp(pId: TPropID) : boolean;

  function  IsPropAsRGB(pId: TPropID) : boolean;

  function  IsApprovalDateProp(pId: TPropID) : boolean;

  function  IsAssignedBooleanProp1(pId: TPropID) : boolean;

  function  IsCalculatedDateProp(pId: TPropID) : boolean;

  function  IsAtLeastOnePropPlannerDefExists : boolean;

  function  GetPropDescr(pId: TPropID) : string;

  function  GetIdFromCode(Code : string) : TPropID;

  function  CheckPropExist(Code : string) : boolean;

  function  CheckPropExistByID(pId: TPropID) : boolean;

  function  FormatToShow(pId: TPropID; val: variant): string;

  function  IsPropAlpha(pId: TPropID) : boolean; overload;

  function  IsPropDynamic(pId: TPropID) : boolean; overload;

  function  IsPropNumeric(pId: TPropID): boolean; overload;

const
  CompValNotCached: TCompatVal = -2;
  CompValNotValid:  TCompatVal = -1;
  CompValNotDef:    TCompatVal = 0;
  CompValBest:      TCompatVal = 1;
  CompValNotComp:   TCompatVal = 99;

  CompMatDim : array[TCompatMatrix] of integer = (
                   1, // CMX_code            - simple code
                   2, // CMX_code_proc       - code and process
                   2, // CMX_code_prod       - code and product type
                   2, // CMX_code_cat        - code and resource category
                   3, // CMX_code_prod_cat   - code, product type and resource category
                   3  // CMX_code_prod_proc  - product type, code and process
                  );

implementation

uses
  Math,
  classes,
  sysUtils,
  Dialogs,
  UMglobal,
  gnugettext,
  UMCommon,
  DB,
  UMTblDesc;

type
  TPropInfoRec = record
    code:          string;
    descr:         string;
    isAlpha:       boolean;
    IsPropPlanner: boolean;
    IsInstanceCounter : boolean;
    DateProp : boolean;
    UserDateProp:  boolean;
    UserRGBProp:   boolean;
    ApprovalDateProp : boolean;
    AssignedBooleanProp1 : boolean;
    CalculatedHighDateProp   : boolean;
    AssignedLimitGrpCountProp1    : boolean;
    AssignedLimitGrpCountProp2    : boolean;
    AssignedPropValueCompareLimitGroup1 : boolean;
    AssignedPropValueCompareLimitGroup2 : boolean;
    Prop_Type :    CScPropType;
    PropInstanceCounterCode : string;
    PropInstanceValue   : string;

    len:           shortInt;
    numDec:        shortInt;
    changeResched: boolean;

    propConn:      TCompatTopoLink;
    connLev:       TCompatMatrix;
    resCCpers:     boolean;

    RtoOchkConn:   TCompatTopoLink;
    rToOchkLev:    TCompatMatrix;
    ROpers:        boolean;

    OtoOchkConn:   TCompatTopoLink;
    oToOchkLev:    TCompatMatrix;
    AffectsSameGroup : boolean;
  end;


  PTPropInfoRec = ^TPropInfoRec;

var
  s_propList: TList;

//----------------------------------------------------------------------------//

function CalcSetupFormula(supAdj: CScSupAdj;
                          supBase, supConst, supMult, AddToSetup: double): double;
begin
  case supAdj of
    CSA_copy:  Result := supBase;
    CSA_add :  Result := supBase + supConst;
    CSA_const: Result := supConst;
    CSA_AddTot: Result := 0;
  else
    Result := supBase * supMult
  end;

  Result := Result + AddToSetup;
end;

//----------------------------------------------------------------------------//

function CalcSetupOvlpFormula(supAdj: CScSupAdj;
                              supBase, supOvlpConst, supOvlpMult, AddToOverlap: double): double;
begin
  case supAdj of
    CSA_copy:  Result := 0;
    CSA_add:   Result := supBase + supOvlpConst;
    CSA_const: Result := supOvlpConst;
  else
    Result := supBase * supOvlpMult
  end;

  Result := Result + AddToOverlap;
end;

//----------------------------------------------------------------------------//

function FromCharToSadj(str: string): CScSupAdj;
begin
  if      str = '0' then
    Result := CSA_copy
  else if str = '1' then
    Result := CSA_add
  else if str = '2' then
    Result := CSA_const
  else if str = '3' then
    Result := CSA_mult
  else
  begin
    if (str = '4') then
      Result := CSA_AddTot
    else
      Result := CSA_copy
  end

end;

//----------------------------------------------------------------------------//

function FromSadjToChar(supAdj: CScSupAdj): string;
begin
  case supAdj of
    CSA_copy:  Result := '0';
    CSA_add:   Result := '1';
    CSA_const: Result := '2';
  else
    Result := '3'
  end
end;

//----------------------------------------------------------------------------//

procedure ClearPropRec;
var
  i: integer;
begin
  if not Assigned(s_propList) then exit;

  for i := 0 to s_propList.Count-1 do
    Dispose(PTPropInfoRec(s_propList[i]));
  s_propList.Clear
end;

//----------------------------------------------------------------------------//

function SortPROPERTY(Item1, Item2: Pointer) : integer;
var
  MQMPROP1 : PTPropInfoRec;
  MQMPROP2 : PTPropInfoRec;
begin
  MQMPROP1 := PTPropInfoRec(Item1);
  MQMPROP2 := PTPropInfoRec(Item2);
  if MQMPROP1.code < MQMPROP2.code then
    Result := -1
  else if (MQMPROP1.code = MQMPROP2.code) then
    Result := 0
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

procedure LoadPropRec(qry: TMqmQuery);
var
  prop:   PTPropInfoRec;
  tbInfo, tbInfo1, tbinfoPropAsDate, tbinfoPropAsRGB : ^TTblInfo;
  Code, PropMeaning : string;
  PropId : TPropId;
  PropAffectSameGroup : TStringList;
begin

  if Assigned(s_propList) then
    ClearPropRec
  else
    s_propList := TList.Create;

  tbInfo := @tblInfo[tbl_prop_res];
  tbInfo1 := @tblInfo[tbl_ruleOccToOcc];
  PropAffectSameGroup := TStringList.Create;

  with qry do
  begin
    SQL.Clear;
    SQL.Add('select distinct ');
    SQL.Add(CreateFld(tbInfo.pfx, fli_PropertyCode) + ' PropCode ');
    SQL.Add(' from ' + tbInfo.GetTableName);
    SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
    SQL.Add(' and ' + CreateFld(tbInfo.pfx, fli_PropDftSameGroupForOcc_Occ_Ruls) + ' = ' + QuotedStr('0'));
    SQL.Add(' union ');
    SQL.Add('select distinct ');
    SQL.Add(CreateFld(tbInfo1.pfx, fli_PropertyCode) + ' PropCode ');
    SQL.Add(' from ' + tbInfo1.GetTableName);
    SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo1.pfx, fli_Identifier)));
    SQL.Add(' and ' + CreateFld(tbInfo1.pfx, fli_CanBeSameGroup) + ' = ' + QuotedStr('0'));
    Open;
    while not EOF do
    begin
      PropAffectSameGroup.Add(FieldByName('PropCode').AsString);
      Next;
    end;
  end;

  tbInfo := @tblInfo[tbl_prop];

  with qry do
  begin
    SQL.Clear;
    SQL.Add('select');
    SQL.Add(CreateFld(tbInfo.pfx, fli_PropertyCode) + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_PropSDesc) + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_PropType) + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_PropLen) + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_PropIsdate) + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_DecNum) + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_ChgPropValCauseResched) + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_RP_MainLevel) + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_RP_Add_WC_Proc) + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_RO_CompatChekType) + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_RO_MainLevel) + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_RO_Add_WC_Proc) + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_RO_Add_ProdType) + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_OO_CompatChekType) + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_OO_MainLevel) + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_OO_Add_WC_Proc) + ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_OO_Add_ProdType)+ ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_MQMRelevance)+ ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_MCMRelevance)+ ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_PropInstanceCounter)+ ',');
    SQL.Add(CreateFld(tbInfo.pfx, fli_PropValueInstanceCounter));
    SQL.Add(' from ' + tbInfo.GetTableName);
    SQL.Add(' where ');
    if DBAppGlobals.MCM_App then
      SQL.Add(CreateFld(tbInfo.pfx, fli_MCMRelevance) + '<>' + QuotedStr('0'))
    else
      SQL.Add(CreateFld(tbInfo.pfx, fli_MQMRelevance) + '<>' + QuotedStr('0'));
    SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
    Open;

    while not EOF do
    begin

     // if FieldByName(CreatePfxFld(fli_MQMRelevance)).AsString = '0' then // mcm
     // begin
     //   Next;
     //   Continue;
     // end;

      New(prop);
      prop.DateProp := false;
      prop.UserDateProp := false;
      if FieldByName(CreateFld(tbInfo.pfx, fli_MQMRelevance)).AsString = '3' then
        prop.IsPropPlanner := true
      else
        prop.IsPropPlanner := false;

      prop.code  := FieldByName(CreateFld(tbInfo.pfx, fli_PropertyCode)).AsString;

      if FieldByName(CreateFld(tbInfo.pfx, fli_OO_MainLevel)).AsInteger > 0 then
      begin
        if PropAffectSameGroup.IndexOf(prop.code) = -1 then
          prop.AffectsSameGroup := false
        else
          prop.AffectsSameGroup := true;
      end;

      prop.descr := FieldByName(CreateFld(tbInfo.pfx, fli_PropSDesc)).AsString;

      if FieldByName(CreateFld(tbInfo.pfx, fli_PropType)).AsInteger = 1 then
      begin
        prop.isAlpha := true;
        prop.Prop_Type := CSA_Alpha;
        if not (Trim(FieldByName(CreateFld(tbInfo.pfx, fli_PropIsdate)).AsString) = '') then
          if FieldByName(CreateFld(tbInfo.pfx, fli_PropIsdate)).AsInteger = 1 then
            prop.DateProp := true;
      end
      else
      begin
        prop.isAlpha := false;
        if FieldByName(CreateFld(tbInfo.pfx, fli_PropType)).AsInteger = 2 then
          prop.Prop_Type := CSA_Numerc
        else if FieldByName(CreateFld(tbInfo.pfx, fli_PropType)).AsInteger = 3 then
          prop.Prop_Type := CSA_Dynamic
        else if FieldByName(CreateFld(tbInfo.pfx, fli_PropType)).AsInteger = 4 then
        begin
          prop.Prop_Type := CSA_Counter;
          prop.PropInstanceCounterCode := FieldByName(CreateFld(tbInfo.pfx, fli_PropInstanceCounter)).AsString;
          prop.PropInstanceValue := FieldByName(CreateFld(tbInfo.pfx, fli_PropValueInstanceCounter)).AsString;
        end;
      end;

      prop.len    := FieldByName(CreateFld(tbInfo.pfx, fli_PropLen)).AsInteger;
      prop.numDec := FieldByName(CreateFld(tbInfo.pfx, fli_DecNum)).AsInteger;

      if FieldByName(CreateFld(tbInfo.pfx, fli_ChgPropValCauseResched)).AsInteger = 1 then
        prop.changeResched := true
      else
        prop.changeResched := false;

      prop.UserRGBProp := false;
      prop.AssignedBooleanProp1 := false;
      prop.ApprovalDateProp := false;
      prop.CalculatedHighDateProp := false;
      prop.AssignedLimitGrpCountProp1 := false;
      prop.AssignedLimitGrpCountProp2 := false;
      prop.AssignedPropValueCompareLimitGroup1 := false;
      prop.AssignedPropValueCompareLimitGroup2 := false;

      // resource-property connection level
      case FieldByName(CreateFld(tbInfo.pfx, fli_RP_MainLevel)).AsInteger of
      1: prop.propConn := CTL_global;
      2: prop.propConn := CTL_wkc;
      3: prop.propConn := CTL_cat;
      4: prop.propConn := CTL_res;
      5: prop.propConn := CTL_wkc
      else
        Assert(false)
      end;

      // additional of WC Process
      if (prop.propConn = CTL_wkc) and
         (FieldByName(CreateFld(tbInfo.pfx, fli_RP_MainLevel)).AsInteger = 5) then
      begin
        // workcenter and category (no process allowed)
        Assert(fieldByName(CreateFld(tbInfo.pfx, fli_RP_Add_WC_Proc)).AsString = '0');
        prop.connLev := CMX_code_cat
      end
      else
      begin
        // all the other cases
        if FieldByName(CreateFld(tbInfo.pfx, fli_RP_Add_WC_Proc)).AsString = '0' then
          prop.connLev := CMX_code
        else
        begin
          Assert((prop.propConn = CTL_wkc) or (prop.propConn = CTL_res));
          prop.connLev := CMX_code_proc;
        end
      end;

      // Resource to Occupation Compatibility check type
      prop.resCCpers := (FieldByName(CreateFld(tbInfo.pfx, fli_RO_CompatChekType)).AsString = '2');
//      Assert(not prop.resCCpers); // we don't know how to handle it

      // resource to occupation compatibility check level
      case FieldByName(CreateFld(tbInfo.pfx, fli_RO_MainLevel)).AsInteger of
      0: prop.RtoOchkConn := CTL_none;
      1: prop.RtoOchkConn := CTL_global;
      2: prop.RtoOchkConn := CTL_wkc;
      3: prop.RtoOchkConn := CTL_cat;
      4: prop.RtoOchkConn := CTL_res;
      5: prop.RtoOchkConn := CTL_wkc
      else
        Assert(false)
      end;

      if prop.RtoOchkConn <> CTL_none then
      begin
        // Additional of Product Type
        if (prop.RtoOchkConn = CTL_wkc) and
           (FieldByName(CreateFld(tbInfo.pfx, fli_RO_MainLevel)).AsInteger = 5) then
        begin
          // workcenter and category
          Assert(FieldByName(CreateFld(tbInfo.pfx, fli_RO_Add_WC_Proc)).AsString = '0'); // no process allowed
          if FieldByName(CreateFld(tbInfo.pfx, fli_RO_Add_ProdType)).AsString = '0' then // no product type
            prop.rToOchkLev := CMX_code_cat
          else
            prop.rToOchkLev := CMX_code_prod_cat
        end
        else
        begin
          // all the other cases
          if FieldByName(CreateFld(tbInfo.pfx, fli_RO_Add_WC_Proc)).AsString = '0' then
          begin
            // no workcenter process
            if FieldByName(CreateFld(tbInfo.pfx, fli_RO_Add_ProdType)).AsString = '0' then // no product type
              prop.rToOchkLev := CMX_code
            else
              prop.rToOchkLev := CMX_code_prod
          end
          else
          begin
            // with workcenter process
            Assert((prop.RtoOchkConn = CTL_wkc) or (prop.RtoOchkConn = CTL_res));
            if FieldByName(CreateFld(tbInfo.pfx, fli_RO_Add_ProdType)).AsString = '0' then // no product type
              prop.rToOchkLev := CMX_code_proc
            else
              prop.rToOchkLev := CMX_code_prod_proc
          end
        end
      end;

      // Occupation to Occupation Compatibility check type
      prop.ROpers := (FieldByName(CreateFld(tbInfo.pfx, fli_OO_CompatChekType)).AsString = '2');
//      Assert(not prop.ROpers); // we don't know how to handle it

      // Occupation to Occupation compatibility check level
      case FieldByName(CreateFld(tbInfo.pfx, fli_OO_MainLevel)).AsInteger of
      0: prop.OtoOchkConn := CTL_none;
      1: prop.OtoOchkConn := CTL_global;
      2: prop.OtoOchkConn := CTL_wkc;
      3: prop.OtoOchkConn := CTL_cat;
      4: prop.OtoOchkConn := CTL_res;
      5: prop.OtoOchkConn := CTL_wkc
      else
        Assert(false);
      end;

      if prop.OtoOchkConn <> CTL_none then
      begin
        // Additional of Product Type
        if (prop.OtoOchkConn = CTL_wkc) and
           (FieldByName(CreateFld(tbInfo.pfx, fli_OO_MainLevel)).AsInteger = 5) then
        begin
          // workcenter and category
          Assert(FieldByName(CreateFld(tbInfo.pfx, fli_OO_Add_WC_Proc)).AsString = '0'); // no process allowed
          if FieldByName(CreateFld(tbInfo.pfx, fli_OO_Add_ProdType)).AsString = '0' then // no product type
            prop.oToOchkLev := CMX_code_cat
          else
            prop.oToOchkLev := CMX_code_prod_cat
        end
        else
        begin
          // all the other cases
          if FieldByName(CreateFld(tbInfo.pfx, fli_OO_Add_WC_Proc)).AsString = '0' then
          begin
            // no workcenter process
            if FieldByName(CreateFld(tbInfo.pfx, fli_OO_Add_ProdType)).AsString = '0' then // no product type
              prop.oToOchkLev := CMX_code
            else
              prop.oToOchkLev := CMX_code_prod
          end
          else
          begin
            // with workcenter process
            Assert((prop.OtoOchkConn = CTL_wkc) or (prop.OtoOchkConn = CTL_res));
            if FieldByName(CreateFld(tbInfo.pfx, fli_OO_Add_ProdType)).AsString = '0' then // no product type
              prop.oToOchkLev := CMX_code_proc
            else
              prop.oToOchkLev := CMX_code_prod_proc
          end
        end
      end;

      s_propList.Add(prop);
      Next
    end;

    Close;
    s_propList.Sort(SortPROPERTY);

    PropAffectSameGroup.Free;
    tbinfoPropAsDate := @tblInfo[tbl_PropAsDate];
    tbinfoPropAsRGB := @tblInfo[tbl_PropAsRGB];
    tbInfo := @tblInfo[tbl_PropAssigned];

    SQL.Clear;
    SQL.Add('select cast(' + QuotedStr('PropAsDate') + ' as char(20)) PropMeaning, ');
    SQL.Add(CreateFld(tbinfoPropAsDate.pfx, fli_PropertyCode) + ' as PropCode from ' + tbinfoPropAsDate.GetTableName);
    SQL.Add(WHERE_IDF_Condition(CreateFld(tbinfoPropAsDate.pfx, fli_Identifier)));
    SQL.Add(' union all ');
    SQL.Add('select cast(' + QuotedStr('PropAsRGB') + ' as char(20)) PropMeaning, ');
    SQL.Add(CreateFld(tbinfoPropAsRGB.pfx, fli_PropertyCode) + ' as PropCode from ' + tbinfoPropAsRGB.GetTableName);
    SQL.Add(WHERE_IDF_Condition(CreateFld(tbinfoPropAsRGB.pfx, fli_Identifier)));
    SQL.Add(' union all ');
    SQL.Add('select cast(' + CreateFld(tbInfo.pfx, fli_AssignedProp) + ' as char(20)) PropMeaning, ');
    SQL.Add(CreateFld(tbInfo.pfx, fli_PropertyCode) + ' as PropCode from ' + tbInfo.GetTableName);
    SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
    Open;

    while not qry.Eof do
    begin
      PropMeaning := FieldByName('PropMeaning').AsString;
      Code := FieldByName('PropCode').AsString;
      PropId := GetIdFromCode(Code);
      if PropId <> nil then
      begin
        if PropMeaning = trim('PropAsDate') then
          SetUserAsDateProp(PropId,true);
        if PropMeaning = trim('PropAsRGB') then
          SetUserAsRGBProp(PropId,true);
        if PropMeaning = trim('APPROVAL_DATE') then
          SetApprovalDateProp(PropId,true);
        if PropMeaning = trim('ASSIGNED_BOOL1') then
          SetAssignedBooleanProp1(PropId,true);
        if PropMeaning = trim('CALC_HIGH_DATE') then
          SetCalculatedHighDateProp(PropId,true);
        if PropMeaning = trim('LIMIT_GRP_COUNT') then
          SetAssignedLimitGrpCountProp1(PropId,true);
        if PropMeaning = trim('LIMIT_GRP_COUNT2') then
          SetAssignedLimitGrpCountProp2(PropId,true);
        if PropMeaning = trim('GRP_VAL_COMPRE') then
          SetAssignedPropValueCompareLimitGroup1(PropId,true);
        if PropMeaning = trim('GRP_VAL_COMPRE2') then
          SetAssignedPropValueCompareLimitGroup2(PropId,true);
      end;
      next;
    end;
    Close;

  end;
end;

procedure LoadPropRecOld(qry: TMqmQuery);
var
  prop:   PTPropInfoRec;
  tbInfo: ^TTblInfo;
  Code : string;
  PropId : TPropId;
  SqlText : string;
  P_PropertyCode,
  p_PropSDesc, p_PropType, p_PropLen, p_DecNum, p_ChgPropValCauseResched, p_RP_MainLevel,
  p_RP_Add_WC_Proc, p_RO_CompatChekType, p_RO_MainLevel, p_RO_Add_WC_Proc, p_RO_Add_ProdType,
  p_OO_CompatChekType, p_OO_MainLevel, p_OO_Add_WC_Proc, p_OO_Add_ProdType,
  p_MQMRelevance, p_MCMRelevance, p_PropInstanceCounter, p_PropValueInstanceCounter : TField;
begin

  if Assigned(s_propList) then
    ClearPropRec
  else
    s_propList := TList.Create;

  tbInfo := @tblInfo[tbl_prop];  // table mqpr

  with qry do
  begin
    SQL.Clear;

    SqlText := 'select' + ' ' + CreateFld(tbInfo.pfx, fli_PropertyCode) + ',' +
               CreateFld(tbInfo.pfx, fli_PropertyCode) + ',' +
               CreateFld(tbInfo.pfx, fli_PropSDesc) + ',' +
               CreateFld(tbInfo.pfx, fli_PropType)  + ',' +
               CreateFld(tbInfo.pfx, fli_PropLen)   + ',' +
               CreateFld(tbInfo.pfx, fli_DecNum)    + ',' +
               CreateFld(tbInfo.pfx, fli_ChgPropValCauseResched) + ',' +
               CreateFld(tbInfo.pfx, fli_RP_MainLevel) + ',' +
               CreateFld(tbInfo.pfx, fli_RP_Add_WC_Proc) + ',' +
               CreateFld(tbInfo.pfx, fli_RO_CompatChekType) + ',' +
               CreateFld(tbInfo.pfx, fli_RO_MainLevel) + ',' +
               CreateFld(tbInfo.pfx, fli_RO_Add_WC_Proc) + ',' +
               CreateFld(tbInfo.pfx, fli_RO_Add_ProdType) + ',' +
               CreateFld(tbInfo.pfx, fli_OO_CompatChekType) + ',' +
               CreateFld(tbInfo.pfx, fli_OO_MainLevel) + ',' +
               CreateFld(tbInfo.pfx, fli_OO_Add_WC_Proc) + ',' +
               CreateFld(tbInfo.pfx, fli_OO_Add_ProdType) + ',' +
               CreateFld(tbInfo.pfx, fli_MQMRelevance) + ',' +
               CreateFld(tbInfo.pfx, fli_MCMRelevance) + ',' +
               CreateFld(tbInfo.pfx, fli_PropInstanceCounter) + ',' +
               CreateFld(tbInfo.pfx, fli_PropValueInstanceCounter);

    SQL.Add(SqlText);
    SQL.Add(' from ' + tbInfo.GetTableName);
    SQL.Add(' where ');
    if DBAppGlobals.MCM_App then
      SQL.Add(CreateFld(tbInfo.pfx, fli_MCMRelevance) + '<>' + QuotedStr('0'))
    else
      SQL.Add(CreateFld(tbInfo.pfx, fli_MQMRelevance) + '<>' + QuotedStr('0'));
    SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
    Open;

    P_PropertyCode  := FieldByName(CreateFld(tbInfo.pfx, fli_PropertyCode));
    p_PropSDesc     := FieldByName(CreateFld(tbInfo.pfx, fli_PropSDesc));
    p_PropType      := FieldByName(CreateFld(tbInfo.pfx, fli_PropType));
    p_PropLen       := FieldByName(CreateFld(tbInfo.pfx, fli_PropLen));
    p_DecNum        := FieldByName(CreateFld(tbInfo.pfx, fli_DecNum));
    p_ChgPropValCauseResched := FieldByName(CreateFld(tbInfo.pfx, fli_ChgPropValCauseResched));
    p_RP_MainLevel           := FieldByName(CreateFld(tbInfo.pfx, fli_RP_MainLevel));
    p_RP_Add_WC_Proc         := FieldByName(CreateFld(tbInfo.pfx, fli_RP_Add_WC_Proc));
    p_RO_CompatChekType      := FieldByName(CreateFld(tbInfo.pfx, fli_RO_CompatChekType));
    p_RO_MainLevel           := FieldByName(CreateFld(tbInfo.pfx, fli_RO_MainLevel));
    p_RO_Add_WC_Proc         := FieldByName(CreateFld(tbInfo.pfx, fli_RO_Add_WC_Proc));
    p_RO_Add_ProdType        := FieldByName(CreateFld(tbInfo.pfx, fli_RO_Add_ProdType));
    p_OO_CompatChekType      := FieldByName(CreateFld(tbInfo.pfx, fli_OO_CompatChekType));
    p_OO_MainLevel           := FieldByName(CreateFld(tbInfo.pfx, fli_OO_MainLevel));
    p_OO_Add_WC_Proc         := FieldByName(CreateFld(tbInfo.pfx, fli_OO_Add_WC_Proc));
    p_OO_Add_ProdType        := FieldByName(CreateFld(tbInfo.pfx, fli_OO_Add_ProdType));
    p_MQMRelevance           := FieldByName(CreateFld(tbInfo.pfx, fli_MQMRelevance));
    p_MCMRelevance           := FieldByName(CreateFld(tbInfo.pfx, fli_MCMRelevance));
    p_PropInstanceCounter    := FieldByName(CreateFld(tbInfo.pfx, fli_PropInstanceCounter));
    p_PropValueInstanceCounter := FieldByName(CreateFld(tbInfo.pfx, fli_PropValueInstanceCounter));

    while not EOF do
    begin

      New(prop);

      if p_MQMRelevance.AsString = '3' then
         prop.IsPropPlanner := true;

      prop.code  := P_PropertyCode.AsString;
      prop.descr := p_PropSDesc.AsString;

      if FieldByName(CreateFld(tbInfo.pfx, fli_PropType)).AsInteger = 1 then
      begin
        prop.isAlpha := true;
        prop.Prop_Type := CSA_Alpha;
      end
      else
      begin
        prop.isAlpha := false;
        if p_PropType.AsInteger = 2 then
          prop.Prop_Type := CSA_Numerc
        else if p_PropType.AsInteger = 3 then
          prop.Prop_Type := CSA_Dynamic
        else if p_PropType.AsInteger = 4 then
        begin
          prop.Prop_Type := CSA_Counter;
          prop.PropInstanceCounterCode := p_PropInstanceCounter.AsString;
          prop.PropInstanceValue := p_PropValueInstanceCounter.AsString;
        end;
      end;

      prop.len    := p_PropLen.AsInteger;
      prop.numDec := p_DecNum.AsInteger;

      if p_ChgPropValCauseResched.AsInteger = 1 then
        prop.changeResched := true
      else
        prop.changeResched := false;

      prop.UserRGBProp := false;
      prop.AssignedBooleanProp1 := false;
      prop.ApprovalDateProp := false;
      prop.CalculatedHighDateProp := false;
      prop.AssignedLimitGrpCountProp1 := false;
      prop.AssignedLimitGrpCountProp2 := false;
      prop.AssignedPropValueCompareLimitGroup1 := false;
      prop.AssignedPropValueCompareLimitGroup2 := false;

      // resource-property connection level
      case p_RP_MainLevel.AsInteger of
      1: prop.propConn := CTL_global;
      2: prop.propConn := CTL_wkc;
      3: prop.propConn := CTL_cat;
      4: prop.propConn := CTL_res;
      5: prop.propConn := CTL_wkc
      else
        Assert(false)
      end;

      // additional of WC Process
      if (prop.propConn = CTL_wkc) and
         (p_RP_MainLevel.AsInteger = 5) then
      begin
        // workcenter and category (no process allowed)
        Assert(p_RP_Add_WC_Proc.AsString = '0');
        prop.connLev := CMX_code_cat
      end
      else
      begin
        // all the other cases
        if p_RP_Add_WC_Proc.AsString = '0' then
          prop.connLev := CMX_code
        else
        begin
          Assert((prop.propConn = CTL_wkc) or (prop.propConn = CTL_res));
          prop.connLev := CMX_code_proc;
        end
      end;

      // Resource to Occupation Compatibility check type
      prop.resCCpers := (p_RO_CompatChekType.AsString = '2');
//      Assert(not prop.resCCpers); // we don't know how to handle it

      // resource to occupation compatibility check level
      case p_RO_MainLevel.AsInteger of
      0: prop.RtoOchkConn := CTL_none;
      1: prop.RtoOchkConn := CTL_global;
      2: prop.RtoOchkConn := CTL_wkc;
      3: prop.RtoOchkConn := CTL_cat;
      4: prop.RtoOchkConn := CTL_res;
      5: prop.RtoOchkConn := CTL_wkc
      else
        Assert(false)
      end;

      if prop.RtoOchkConn <> CTL_none then
      begin
        // Additional of Product Type
        if (prop.RtoOchkConn = CTL_wkc) and
           (p_RO_MainLevel.AsInteger = 5) then
        begin
          // workcenter and category
          Assert(p_RO_Add_WC_Proc.AsString = '0'); // no process allowed
          if p_RO_Add_ProdType.AsString = '0' then // no product type
            prop.rToOchkLev := CMX_code_cat
          else
            prop.rToOchkLev := CMX_code_prod_cat
        end
        else
        begin
          // all the other cases
          if p_RO_Add_WC_Proc.AsString = '0' then
          begin
            // no workcenter process
            if p_RO_Add_ProdType.AsString = '0' then // no product type
              prop.rToOchkLev := CMX_code
            else
              prop.rToOchkLev := CMX_code_prod
          end
          else
          begin
            // with workcenter process
            Assert((prop.RtoOchkConn = CTL_wkc) or (prop.RtoOchkConn = CTL_res));
            if P_RO_Add_ProdType.AsString = '0' then // no product type
              prop.rToOchkLev := CMX_code_proc
            else
              prop.rToOchkLev := CMX_code_prod_proc
          end
        end
      end;

      // Occupation to Occupation Compatibility check type
      prop.ROpers := (p_OO_CompatChekType.AsString = '2');
//      Assert(not prop.ROpers); // we don't know how to handle it

      // Occupation to Occupation compatibility check level
      case p_OO_MainLevel.AsInteger of
      0: prop.OtoOchkConn := CTL_none;
      1: prop.OtoOchkConn := CTL_global;
      2: prop.OtoOchkConn := CTL_wkc;
      3: prop.OtoOchkConn := CTL_cat;
      4: prop.OtoOchkConn := CTL_res;
      5: prop.OtoOchkConn := CTL_wkc
      else
        Assert(false);
      end;

      if prop.OtoOchkConn <> CTL_none then
      begin
        // Additional of Product Type
        if (prop.OtoOchkConn = CTL_wkc) and
           (p_OO_MainLevel.AsInteger = 5) then
        begin
          // workcenter and category
          Assert(p_OO_Add_WC_Proc.AsString = '0'); // no process allowed
          if p_OO_Add_ProdType.AsString = '0' then // no product type
            prop.oToOchkLev := CMX_code_cat
          else
            prop.oToOchkLev := CMX_code_prod_cat
        end
        else
        begin
          // all the other cases
          if p_OO_Add_WC_Proc.AsString = '0' then
          begin
            // no workcenter process
            if p_OO_Add_ProdType.AsString = '0' then // no product type
              prop.oToOchkLev := CMX_code
            else
              prop.oToOchkLev := CMX_code_prod
          end
          else
          begin
            // with workcenter process
            Assert((prop.OtoOchkConn = CTL_wkc) or (prop.OtoOchkConn = CTL_res));
            if p_OO_Add_ProdType.AsString = '0' then // no product type
              prop.oToOchkLev := CMX_code_proc
            else
              prop.oToOchkLev := CMX_code_prod_proc
          end
        end
      end;

      s_propList.Add(prop);
      Next
    end;

    Close;

    tbInfo := @tblInfo[tbl_PropAsDate];

    with qry do
    begin
      SQL.Clear;
      SQL.Add('select * from ' + tbInfo.GetTableName);
      SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
      Open;

      while not qry.Eof do
      begin
        Code := FieldByName(CreateFld(tbInfo.pfx, fli_PropertyCode)).AsString;
        PropId := GetIdFromCode(Code);
        if PropId <> nil then
          SetUserAsDateProp(PropId,true);
        next
      end;
    end;
    Close;

    tbInfo := @tblInfo[tbl_PropAssigned];

    with qry do
    begin
      SQL.Clear;
      SQL.Clear;
      SQL.Add('select * from ' + tbInfo.GetTableName + ' where ');
      SQL.Add(CreateFld(tbInfo.pfx, fli_AssignedProp) + '=' + QuotedStr('APPROVAL_DATE'));
      SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
      Open;

      if not qry.Eof then
      begin
        Code := P_PropertyCode.AsString;
        PropId := GetIdFromCode(Code);
        if PropId <> nil then
          SetApprovalDateProp(PropId,true)
      end;
    end;
    Close;

    with qry do
    begin
      SQL.Clear;
      SQL.Clear;
      SQL.Add('select * from ' + tbInfo.GetTableName + ' where ');
      SQL.Add(CreateFld(tbInfo.pfx, fli_AssignedProp) + '=' + QuotedStr('ASSIGNED_BOOL1'));
      SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
      Open;

      if not qry.Eof then
      begin
        Code := FieldByName(CreateFld(tbInfo.pfx, fli_PropertyCode)).AsString;
        PropId := GetIdFromCode(Code);
        if PropId <> nil then
          SetAssignedBooleanProp1(PropId,true)
      end;
    end;
    Close;

    with qry do
    begin
      SQL.Clear;
      SQL.Clear;
      SQL.Add('select * from ' + tbInfo.GetTableName + ' where ');
      SQL.Add(CreateFld(tbInfo.pfx, fli_AssignedProp) + '=' + QuotedStr('CALC_HIGH_DATE'));
      SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
      Open;

      if not qry.Eof then
      begin
        Code := FieldByName(CreateFld(tbInfo.pfx, fli_PropertyCode)).AsString;
        PropId := GetIdFromCode(Code);
        if IsPropPlanner(PropId) and (GetLength(PropId) = 12) and IsPropAlpha(Code) then
          SetCalculatedHighDateProp(PropId,true)
      end;
    end;
    Close;

    with qry do
    begin
      SQL.Clear;
      SQL.Clear;
      SQL.Add('select * from ' + tbInfo.GetTableName + ' where ');
      SQL.Add(CreateFld(tbInfo.pfx, fli_AssignedProp) + '=' + QuotedStr('LIMIT_GRP_COUNT'));
      SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
      Open;

      if not qry.Eof then
      begin
        Code := FieldByName(CreateFld(tbInfo.pfx, fli_PropertyCode)).AsString;
        PropId := GetIdFromCode(Code);
        if PropId <> nil then
          SetAssignedLimitGrpCountProp1(PropId,true)
      end;
    end;
    Close;

    with qry do
    begin
      SQL.Clear;
      SQL.Clear;
      SQL.Add('select * from ' + tbInfo.GetTableName + ' where ');
      SQL.Add(CreateFld(tbInfo.pfx, fli_AssignedProp) + '=' + QuotedStr('LIMIT_GRP_COUNT2'));
      SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
      Open;

      if not qry.Eof then
      begin
        Code := FieldByName(CreateFld(tbInfo.pfx, fli_PropertyCode)).AsString;
        PropId := GetIdFromCode(Code);
        if PropId <> nil then
          SetAssignedLimitGrpCountProp2(PropId,true)
      end;
    end;
    Close;

    with qry do
    begin
      SQL.Clear;
      SQL.Clear;
      SQL.Add('select * from ' + tbInfo.GetTableName + ' where ');
      SQL.Add(CreateFld(tbInfo.pfx, fli_AssignedProp) + '=' + QuotedStr('GRP_VAL_COMPRE'));
      SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
      Open;

      if not qry.Eof then
      begin
        Code := FieldByName(CreateFld(tbInfo.pfx, fli_PropertyCode)).AsString;
        PropId := GetIdFromCode(Code);
        if PropId <> nil then
          SetAssignedPropValueCompareLimitGroup1(PropId,true)
      end;
    end;
    Close;

    with qry do
    begin
      SQL.Clear;
      SQL.Clear;
      SQL.Add('select * from ' + tbInfo.GetTableName + ' where ');
      SQL.Add(CreateFld(tbInfo.pfx, fli_AssignedProp) + '=' + QuotedStr('GRP_VAL_COMPRE2'));
      SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
      Open;

      if not qry.Eof then
      begin
        Code := FieldByName(CreateFld(tbInfo.pfx, fli_PropertyCode)).AsString;
        PropId := GetIdFromCode(Code);
        if PropId <> nil then
          SetAssignedPropValueCompareLimitGroup2(PropId,true)
      end;
    end;
    Close;

    tbInfo := @tblInfo[tbl_PropAsRGB];

    with qry do
    begin
      SQL.Clear;
      SQL.Add('select * from ' + tbInfo.GetTableName );
      SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
      Open;


      while not qry.Eof do
      begin
        Code := FieldByName(CreateFld(tbInfo.pfx, fli_PropertyCode)).AsString;
        PropId := GetIdFromCode(Code);
        SetUserAsRGBProp(PropId,true);
        next
      end;
    end;
    Close;

  end;
end;

//----------------------------------------------------------------------------//

function TrimLeadingZeros(const S: string): string;
var
  I, L: Integer;
begin
  L:= Length(S);
  I:= 1;
  while (I < L) and (S[I] = '0') do Inc(I);
  Result:= Copy(S, I);
end;

function ConvPropValueRule(pId: TPropID; valString: string): variant;
var
  ppRec: PTPropInfoRec;
  i : Integer;
  dec : String;
  Value: Extended;
begin
  ppRec := PTPropInfoRec(pId);

  if ppRec.isAlpha then
    Result := valString
  else if (Trim(valString) = '') then
    Result :=  0 //No Value
  else
  begin
    try

      if FormatSettings.DecimalSeparator = ',' then
        valString := stringreplace(valString, '.', ',', [rfReplaceAll, rfIgnoreCase]);

      if not TryStrToFloat(valString, Value) then
      begin
        Result := 0;
        Exit
      end;

      Result := StrToFloat(valString);
      {if ppRec.numDec > 0 then
      begin
        i := 0;
        dec := '';

        Result := Result/(power(10, ppRec.numDec));
      end;  }
    except
      on E: Exception do
      begin
        ShowMessage(_('Error decoding property') + ' ' +
                    ppRec.code + ' ' +
                    ppRec.descr + ': ' +
                    E.Message);
      end;
    end;
  end;
end;

function ConvPropValue(pId: TPropID; valString: string): variant;
var
  ppRec: PTPropInfoRec;
  i : Integer;
  dec : String;
  Value: Extended;
begin
  ppRec := PTPropInfoRec(pId);

  if ppRec.isAlpha then
    Result := valString
  else if (Trim(valString) = '') then
    Result :=  0 //No Value
  else
  begin
    try

      if FormatSettings.DecimalSeparator = ',' then
        valString := stringreplace(valString, '.', ',', [rfReplaceAll, rfIgnoreCase]);

      if not TryStrToFloat(valString, Value) then
      begin
        Result := 0;
        Exit
      end;

      Result := StrToFloat(valString);
      if ppRec.numDec > 0 then
      begin
        i := 0;
        dec := '';

        Result := Result/(power(10, ppRec.numDec));
      end;
    except
      on E: Exception do
      begin
        ShowMessage(_('Error decoding property') + ' ' +
                    ppRec.code + ' ' +
                    ppRec.descr + ': ' +
                    E.Message);
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

function FindPropFromCode(propList : TList; Code : string): Integer;
var
  i: integer;
  Multiplier, NumberOfEntries : integer;
begin
  Result := -1;
  NumberOfEntries := propList.Count;

  if NumberOfEntries = 0 then exit;

  Multiplier := 1;
  while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
  i := Multiplier - 1;

  while (Multiplier > 0) do
  begin

    if  (i < NumberOfEntries)
    and (PTPropInfoRec(propList[i]).code = Code) then
    begin
      Result := i;
      break;
    end;

    Multiplier := trunc(Multiplier / 2);

    if  (i < NumberOfEntries)
    and (PTPropInfoRec(propList[i]).code < Code) then
      i := i + Multiplier
    else
      i := i - Multiplier;

  end;

end;

//----------------------------------------------------------------------------//

function DecodePropRule(code: string; valString: string; var val: variant): TPropID;
var
  pos: integer;
begin
  pos := FindPropFromCode(s_propList, Code);

  if pos = -1 then
    Result := nil
  else
  begin
    try
      Result := s_propList[pos];
      val := ConvPropValueRule(Result, valString);
    except
      on E: Exception do
      begin
        Result := nil;
        ShowMessage(_('Error decoding property') + ' ' +
                    PTPropInfoRec(Result).code + ' ' +
                    PTPropInfoRec(Result).descr + ': ' +
                    E.Message);
      end;
    end;
  end
end;

function DecodeProp(code: string; valString: string; var val: variant): TPropID;
var
  pos: integer;
begin
  pos := FindPropFromCode(s_propList, Code);

  if pos = -1 then
    Result := nil
  else
  begin
    try
      Result := s_propList[pos];
      val := ConvPropValue(Result, valString);
    except
      on E: Exception do
      begin
        Result := nil;
        ShowMessage(_('Error decoding property') + ' ' +
                    PTPropInfoRec(Result).code + ' ' +
                    PTPropInfoRec(Result).descr + ': ' +
                    E.Message);
      end;
    end;
  end
end;

//----------------------------------------------------------------------------//

procedure GetPropCoordForValue(pId: TPropID; var tpLink: TCompatTopoLink; var mtx: TCompatMatrix);
var
  ppRec: PTPropInfoRec;
begin
  ppRec := PTPropInfoRec(pId);
  tpLink := ppRec.propConn;
  mtx   := ppRec.connLev;
end;

//----------------------------------------------------------------------------//

procedure GetPropCoordForRtoOcomp(pId: TPropID; var tpLink: TCompatTopoLink; var mtx: TCompatMatrix);
var
  ppRec: PTPropInfoRec;
begin
  ppRec := PTPropInfoRec(pId);
  tpLink := ppRec.RtoOchkConn;
  mtx   := ppRec.rToOchkLev
end;

//----------------------------------------------------------------------------//

procedure GetPropCoordForOtoOcomp(pId: TPropID; var tpLink: TCompatTopoLink; var mtx: TCompatMatrix);
var
  ppRec: PTPropInfoRec;
begin
  ppRec  := PTPropInfoRec(pId);
  tpLink := ppRec.OtoOchkConn;
  mtx    := ppRec.oToOchkLev
end;

//----------------------------------------------------------------------------//

function IsPropAffectSameGroupFlag(pId: TPropID): boolean;
var
  ppRec: PTPropInfoRec;
begin
  ppRec  := PTPropInfoRec(pId);
  result := ppRec.AffectsSameGroup;
end;

//----------------------------------------------------------------------------//

function GetPropCodeFromID(pId: TPropID): string;
begin
  Result := PTPropInfoRec(pId).code
end;

//----------------------------------------------------------------------------//

function GetPropertyCount : integer;
begin
  Result := s_propList.Count
end;

//----------------------------------------------------------------------------//

function GetPropFromPos(ndx: integer): TPropID;
begin
  Result := TPropID(s_propList[ndx])
end;

//----------------------------------------------------------------------------//

function GetNextProp(Index : Integer ; var Desc : string ; var PType : CScPropType) : string;
begin
  Assert(Index < s_propList.Count);
  Desc    := PTPropInfoRec(s_propList[Index]).descr;
  PType := PTPropInfoRec(s_propList[Index]).Prop_Type;
  Result  := PTPropInfoRec(s_propList[Index]).code
end;

//----------------------------------------------------------------------------//

function GetPropType(pId: TPropID) : CScPropType;
var
  ppRec: PTPropInfoRec;
begin
  ppRec := PTPropInfoRec(pId);
  Result := ppRec.Prop_Type
end;

//----------------------------------------------------------------------------//

function GetLength(pId: TPropID) : integer;
var
  ppRec: PTPropInfoRec;
begin
  ppRec := PTPropInfoRec(pId);
  Result := ppRec.len
end;

//----------------------------------------------------------------------------//

function ExistNumOfDecimal(pId: TPropID; var Len : Integer; var NumOfDecimal : Integer) : boolean;
var
  ppRec: PTPropInfoRec;
begin
  Result := false;
  ppRec  := PTPropInfoRec(pId);
  Len    := ppRec.len;
  NumOfDecimal := ppRec.numDec;
  if ppRec.numDec > 0 then
     Result := true
end;

//----------------------------------------------------------------------------//

function IsPropAlpha(code: string) : boolean;
var
  i:     integer;
  ppRec: PTPropInfoRec;
begin
  Result := true;
  Assert(s_propList.Count > 0);
  for i := 0 to s_propList.count - 1 do
  begin
    ppRec := PTPropInfoRec(s_propList[i]);
    if ppRec.code = Code then
    begin
      Result := ppRec.isAlpha;
      exit
    end
  end;
  Assert(false)
end;

//----------------------------------------------------------------------------//

function IsPropPlanner(pId: TPropID) : boolean;
var
  ppRec: PTPropInfoRec;
begin
  ppRec := PTPropInfoRec(pId);
  Result := ppRec.IsPropPlanner
end;

//----------------------------------------------------------------------------//

function IsInstanceCounter(pId: TPropID) : boolean;
var
  ppRec: PTPropInfoRec;
begin
  ppRec := PTPropInfoRec(pId);
  Result := ppRec.Prop_Type = CSA_Counter
end;

//----------------------------------------------------------------------------//

function GetPropInstanceCounterCode(pId: TPropID) : string;
var
  ppRec: PTPropInfoRec;
begin
  ppRec := PTPropInfoRec(pId);
  Result := ppRec.PropInstanceCounterCode;
end;

//----------------------------------------------------------------------------//

function GetPropInstanceCounterValue(pId: TPropID) : string;
var
  ppRec: PTPropInfoRec;
begin
  ppRec := PTPropInfoRec(pId);
  Result := ppRec.PropInstanceValue;
end;

//----------------------------------------------------------------------------//

procedure CleanAllPropertiesAsDate;
var
  i:     integer;
  ppRec: PTPropInfoRec;
begin
  Assert(s_propList.Count > 0);
  for i := 0 to s_propList.count - 1 do
  begin
    ppRec := PTPropInfoRec(s_propList[i]);
    ppRec.UserDateProp := false;
  end;
end;

//----------------------------------------------------------------------------//

procedure CleanAllPropertiesAsRGB;
var
  i:     integer;
  ppRec: PTPropInfoRec;
begin
  Assert(s_propList.Count > 0);
  for i := 0 to s_propList.count - 1 do
  begin
    ppRec := PTPropInfoRec(s_propList[i]);
    ppRec.UserRGBProp := false;
  end;
end;

//----------------------------------------------------------------------------//

procedure SetUserAsDateProp(pId: TPropID ; Flag : boolean);
var
  ppRec: PTPropInfoRec;
begin
  if pId <> nil then
  begin
    ppRec := PTPropInfoRec(pId);
    ppRec.UserDateProp := Flag
  end;
end;

//----------------------------------------------------------------------------//

procedure SetUserAsRGBProp(pId: TPropID ; Flag : boolean);
var
  ppRec: PTPropInfoRec;
begin
  if pId <> nil then
  begin
    ppRec := PTPropInfoRec(pId);
    ppRec.UserRGBProp := Flag
  end;
end;

//----------------------------------------------------------------------------//

procedure CleanAllApprovalDateProp;
var
  i:     integer;
  ppRec: PTPropInfoRec;
begin
  Assert(s_propList.Count > 0);
  for i := 0 to s_propList.count - 1 do
  begin
    ppRec := PTPropInfoRec(s_propList[i]);
    ppRec.ApprovalDateProp := false;
  end;
end;

//----------------------------------------------------------------------------//

procedure CleanAllAssignedBooleanProp1;
var
  i:     integer;
  ppRec: PTPropInfoRec;
begin
  Assert(s_propList.Count > 0);
  for i := 0 to s_propList.count - 1 do
  begin
    ppRec := PTPropInfoRec(s_propList[i]);
    ppRec.AssignedBooleanProp1 := false;
  end;
end;

//----------------------------------------------------------------------------//

procedure CleanAllCalculatedHighDateProp;
var
  i:     integer;
  ppRec: PTPropInfoRec;
begin
  Assert(s_propList.Count > 0);
  for i := 0 to s_propList.count - 1 do
  begin
    ppRec := PTPropInfoRec(s_propList[i]);
    ppRec.CalculatedHighDateProp := false;
  end;
end;

//----------------------------------------------------------------------------//

procedure CleanAllAssignedLimitGrpCountProp1;
var
  i:     integer;
  ppRec: PTPropInfoRec;
begin
  Assert(s_propList.Count > 0);
  for i := 0 to s_propList.count - 1 do
  begin
    ppRec := PTPropInfoRec(s_propList[i]);
    ppRec.AssignedLimitGrpCountProp1 := false;
  end;
end;

//----------------------------------------------------------------------------//

procedure CleanAllAssignedLimitGrpCountProp2;
var
  i:     integer;
  ppRec: PTPropInfoRec;
begin
  Assert(s_propList.Count > 0);
  for i := 0 to s_propList.count - 1 do
  begin
    ppRec := PTPropInfoRec(s_propList[i]);
    ppRec.AssignedLimitGrpCountProp2 := false;
  end;
end;

//----------------------------------------------------------------------------//

procedure CleanAllAssignedPropValueCompareLimitGroup1;
var
  i:     integer;
  ppRec: PTPropInfoRec;
begin
  Assert(s_propList.Count > 0);
  for i := 0 to s_propList.count - 1 do
  begin
    ppRec := PTPropInfoRec(s_propList[i]);
    ppRec.AssignedPropValueCompareLimitGroup1 := false;
  end;
end;

//----------------------------------------------------------------------------//

procedure CleanAllAssignedPropValueCompareLimitGroup2;
var
  i:     integer;
  ppRec: PTPropInfoRec;
begin
  Assert(s_propList.Count > 0);
  for i := 0 to s_propList.count - 1 do
  begin
    ppRec := PTPropInfoRec(s_propList[i]);
    ppRec.AssignedPropValueCompareLimitGroup2 := false;
  end;
end;

//----------------------------------------------------------------------------//

procedure SetCalculatedHighDateProp(pId: TPropID ; Flag : boolean);
var
  ppRec: PTPropInfoRec;
begin
  ppRec := PTPropInfoRec(pId);
  ppRec.CalculatedHighDateProp := Flag;
end;

//----------------------------------------------------------------------------//

procedure SetAssignedLimitGrpCountProp1(pId: TPropID ; Flag : boolean);
var
  ppRec: PTPropInfoRec;
begin
  ppRec := PTPropInfoRec(pId);
  ppRec.AssignedLimitGrpCountProp1 := Flag;
end;

//----------------------------------------------------------------------------//

procedure SetAssignedLimitGrpCountProp2(pId: TPropID ; Flag : boolean);
var
  ppRec: PTPropInfoRec;
begin
  ppRec := PTPropInfoRec(pId);
  ppRec.AssignedLimitGrpCountProp2 := Flag;
end;

//----------------------------------------------------------------------------//

procedure SetAssignedPropValueCompareLimitGroup1(pId: TPropID ; Flag : boolean);
var
  ppRec: PTPropInfoRec;
begin
  ppRec := PTPropInfoRec(pId);
  ppRec.AssignedPropValueCompareLimitGroup1 := Flag;
end;

//----------------------------------------------------------------------------//

procedure SetAssignedPropValueCompareLimitGroup2(pId: TPropID ; Flag : boolean);
var
  ppRec: PTPropInfoRec;
begin
  ppRec := PTPropInfoRec(pId);
  ppRec.AssignedPropValueCompareLimitGroup2 := Flag;
end;

//----------------------------------------------------------------------------//

procedure SetApprovalDateProp(pId: TPropID ; Flag : boolean);
var
  ppRec: PTPropInfoRec;
begin
  ppRec := PTPropInfoRec(pId);
  ppRec.ApprovalDateProp := Flag;
end;

//----------------------------------------------------------------------------//

procedure SetAssignedBooleanProp1(pId: TPropID ; Flag : boolean);
var
  ppRec: PTPropInfoRec;
begin
  ppRec := PTPropInfoRec(pId);
  ppRec.AssignedBooleanProp1 := Flag;
end;

//----------------------------------------------------------------------------//

function GetAssignedBooleanProp1 : TPropID;
var
  I : Integer;
  ppRec: PTPropInfoRec;
begin
  Result := nil;
  if (s_propList.Count > 0) then
  begin
    for i := 0 to s_propList.count - 1 do
    begin
      ppRec := PTPropInfoRec(s_propList[i]);
      if ppRec.AssignedBooleanProp1 then
      begin
        Result := s_propList[I];
        exit
      end
    end
  end;
end;

//----------------------------------------------------------------------------//

function GetCalculatedHighDateProp : TPropID;
var
  I : Integer;
  ppRec: PTPropInfoRec;
begin
  Result := nil;
  if (s_propList.Count > 0) then
  begin
    for i := 0 to s_propList.count - 1 do
    begin
      ppRec := PTPropInfoRec(s_propList[i]);
      if ppRec.CalculatedHighDateProp then
      begin
        Result := s_propList[I];
        exit
      end
    end
  end;
end;

//----------------------------------------------------------------------------//

function GetAssignedLimitGrpCountProp1 : TPropID;
var
  I : Integer;
  ppRec: PTPropInfoRec;
begin
  Result := nil;
  if (s_propList.Count > 0) then
  begin
    for i := 0 to s_propList.count - 1 do
    begin
      ppRec := PTPropInfoRec(s_propList[i]);
      if ppRec.AssignedLimitGrpCountProp1 then
      begin
        Result := s_propList[I];
        exit
      end
    end
  end;
end;

//----------------------------------------------------------------------------//

function GetAssignedLimitGrpCountProp2 : TPropID;
var
  I : Integer;
  ppRec: PTPropInfoRec;
begin
  Result := nil;
  if (s_propList.Count > 0) then
  begin
    for i := 0 to s_propList.count - 1 do
    begin
      ppRec := PTPropInfoRec(s_propList[i]);
      if ppRec.AssignedLimitGrpCountProp2 then
      begin
        Result := s_propList[I];
        exit
      end
    end
  end;
end;

//----------------------------------------------------------------------------//

function GetAssignedPropValueCompareLimitGroup1 : TPropID;
var
  I : Integer;
  ppRec: PTPropInfoRec;
begin
  Result := nil;
  if (s_propList.Count > 0) then
  begin
    for i := 0 to s_propList.count - 1 do
    begin
      ppRec := PTPropInfoRec(s_propList[i]);
      if ppRec.AssignedPropValueCompareLimitGroup1 then
      begin
        Result := s_propList[I];
        exit
      end
    end
  end;
end;

//----------------------------------------------------------------------------//

function GetAssignedPropValueCompareLimitGroup2 : TPropID;
var
  I : Integer;
  ppRec: PTPropInfoRec;
begin
  Result := nil;
  if (s_propList.Count > 0) then
  begin
    for i := 0 to s_propList.count - 1 do
    begin
      ppRec := PTPropInfoRec(s_propList[i]);
      if ppRec.AssignedPropValueCompareLimitGroup2 then
      begin
        Result := s_propList[I];
        exit
      end
    end
  end;
end;

//----------------------------------------------------------------------------//

function ExistAssignedBooleanProp1 : boolean;
var
  I : Integer;
  ppRec: PTPropInfoRec;
begin
  Result := false;
  if (s_propList.Count > 0) then
  begin
    for i := 0 to s_propList.count - 1 do
    begin
      ppRec := PTPropInfoRec(s_propList[i]);
      if ppRec.IsPropPlanner and ppRec.AssignedBooleanProp1 then
      begin
        Result := true;
        exit
      end
    end
  end;
end;

//----------------------------------------------------------------------------//

function IsPropAsDate(pId: TPropID) : boolean;
var
  ppRec: PTPropInfoRec;
begin
  Result := false;
  ppRec := PTPropInfoRec(pId);
  if ppRec = nil then exit;
  Result := ppRec.UserDateProp
end;

//----------------------------------------------------------------------------//

function IsDateProp(pId: TPropID) : boolean;
var
  ppRec: PTPropInfoRec;
begin
  Result := false;
  ppRec := PTPropInfoRec(pId);
  if ppRec = nil then exit;
  Result := ppRec.DateProp
end;

//----------------------------------------------------------------------------//

function IsPropAsRGB(pId: TPropID) : boolean;
var
  ppRec: PTPropInfoRec;
begin
  ppRec := PTPropInfoRec(pId);
  Result := ppRec.UserRGBProp
end;

//----------------------------------------------------------------------------//

function IsApprovalDateProp(pId: TPropID) : boolean;
var
  ppRec: PTPropInfoRec;
begin
  ppRec := PTPropInfoRec(pId);
  Result := ppRec.ApprovalDateProp
end;

//----------------------------------------------------------------------------//

function IsAssignedBooleanProp1(pId: TPropID) : boolean;
var
  ppRec: PTPropInfoRec;
begin
  ppRec := PTPropInfoRec(pId);
  Result := ppRec.AssignedBooleanProp1
end;

//----------------------------------------------------------------------------//

function IsCalculatedDateProp(pId: TPropID) : boolean;
var
  ppRec: PTPropInfoRec;
begin
  ppRec := PTPropInfoRec(pId);
  Result := ppRec.CalculatedHighDateProp
end;

//----------------------------------------------------------------------------//

function IsAssignedLimitGrpCountProp1(pId: TPropID) : boolean;
var
  ppRec: PTPropInfoRec;
begin
  ppRec := PTPropInfoRec(pId);
  Result := ppRec.AssignedLimitGrpCountProp1
end;

//----------------------------------------------------------------------------//

function AssignedPropValueCompareLimitGroup1(pId: TPropID) : boolean;
var
  ppRec: PTPropInfoRec;
begin
  ppRec := PTPropInfoRec(pId);
  Result := ppRec.AssignedPropValueCompareLimitGroup1
end;

//----------------------------------------------------------------------------//

function AssignedPropValueCompareLimitGroup2(pId: TPropID) : boolean;
var
  ppRec: PTPropInfoRec;
begin
  ppRec := PTPropInfoRec(pId);
  Result := ppRec.AssignedPropValueCompareLimitGroup2
end;

//----------------------------------------------------------------------------//

function IsAtLeastOnePropPlannerDefExists : boolean;
var
  I : Integer;
  ppRec: PTPropInfoRec;
begin
  Result := false;
  if (s_propList.Count > 0) then
  begin
    for i := 0 to s_propList.count - 1 do
    begin
      ppRec := PTPropInfoRec(s_propList[i]);
      if ppRec.IsPropPlanner then
      begin
        Result := true;
        exit
      end
    end
  end;
end;

//----------------------------------------------------------------------------//

function IsPropAlpha(pId: TPropID): boolean;
var
  ppRec: PTPropInfoRec;
begin
  ppRec := PTPropInfoRec(pId);
  Result := ppRec.isAlpha
end;

//----------------------------------------------------------------------------//

function IsPropNumeric(pId: TPropID): boolean;
var
  ppRec: PTPropInfoRec;
begin
  ppRec := PTPropInfoRec(pId);
  Result := ppRec.Prop_Type = CSA_Numerc;
end;

//----------------------------------------------------------------------------//

function IsPropDynamic(pId: TPropID) : boolean;
var
  ppRec: PTPropInfoRec;
begin
  ppRec := PTPropInfoRec(pId);
  Result := ppRec.Prop_Type = CSA_Dynamic;
end;

//----------------------------------------------------------------------------//
function CheckPropExistByID(pId: TPropID): boolean;
var
  i:     integer;
  ppRec: PTPropInfoRec;
begin
  Result := false;

  Assert(s_propList.Count > 0);
  for i := 0 to s_propList.count - 1 do
  begin
    ppRec := PTPropInfoRec(s_propList[i]);
    if ppRec = pId then
    begin
      Result := true;
      exit
    end
  end
end;

//----------------------------------------------------------------------------//

function CheckPropExist(Code : string): boolean;
var
  i:     integer;
  ppRec: PTPropInfoRec;
begin
  Result := false;

//  Assert(s_propList.Count > 0);
  for i := 0 to s_propList.count - 1 do
  begin
    ppRec := PTPropInfoRec(s_propList[i]);
    if ppRec.code = Code then
    begin
      Result := true;
      exit
    end
  end
end;

//----------------------------------------------------------------------------//

function GetPropDescr(pId: TPropID) : string;
begin
  Result := PTPropInfoRec(pId).descr
end;

//----------------------------------------------------------------------------//

function GetIdFromCode(Code : string) : TPropID;
var
  i, pos: integer;
begin
  pos := -1;
  for i := 0 to s_propList.Count-1 do
    if PTPropInfoRec(s_propList[i]).code = code then
    begin
      pos := i;
      break
    end;

  if pos = -1 then
    Result := nil
  else
  begin
    Result := s_propList[pos];
//    if PTPropInfoRec(Result).isAlpha then
//      val := valString
//    else
//      val := StrToFloat(valString)
  end;
end;

//----------------------------------------------------------------------------//

function FormatToShow(pId: TPropID; val: variant): string;
begin
  if PTPropInfoRec(pId).isAlpha then
    Result := val
  else
    Result := FloatToStr(val)
end;

//----------------------------------------------------------------------------//

initialization

  s_propList := nil;

finalization

  if Assigned(s_propList) then
  begin
    ClearPropRec;
    s_propList.Free;
  end;

//----------------------------------------------------------------------------//

end.
