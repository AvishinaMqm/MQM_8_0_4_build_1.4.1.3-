unit FMPlannerPropDefine;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, gnugettext, UMCompatSrv, UGPropComp, UMSchedContFunc, StdCtrls, Buttons,
  DMsrvPc, ExtCtrls, UMCommon, UMCompat, UReShape;

type

  PRP_Status = (PRP_not_modi, PRP_new, PRP_modi, PRP_del);
  TPlannerPropDefine = class(TForm)
    Panel1: TPanel;
    BtnOk: TcxButton;
    BtnAbo: TcxButton;
    procedure BtnOkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnAboClick(Sender: TObject);
  private
    m_PropComp   : TPropComponent;
    m_Id         : TSchedId;
    m_StartIndexMainList : Integer;
    m_CurrReqStepList : TList;
  function CheckData(var str : string) : boolean;
  procedure MarkJobPropertyInList;
  function SearchDeletedPropFromJobList(PropListJob : TProperties; Request : string; Step : Integer) : boolean;
  procedure updateMainPropList(PropListJob : TProperties; Request : string; Step : Integer);
  function  updatePropValToCurrList(Prop : string; Val : string) : boolean;
  function  SearchPropInCurrentList(Prop : string; var Indx : Integer) : boolean;
    { Private declarations }
  public
    constructor CreatePlannerPropDefine(AOwner : TComponent; Properties : TProperties; ID : TSchedId);
  end;

  procedure savePropUserDefine(qry: TMqmQuery; updNum : Integer);
  function  GetLast_PROP_PROD_PLANNER : Integer;
  function  UpdatePropInJobList(Prop : TProperties; PropId : TPropId; val : string) : boolean;
  function  CheckPropValueInJobList(Prop : TProperties; PropId : TPropId; var val : string) : boolean;
  procedure UpdateMainListPropChange(Id : TSchedId; PropCode : string; val : string; delete : boolean);


implementation

{$R *.dfm}

uses UMSchedCont,UMObjCont,UMTblDesc,UMGlobal,FMbin,Data.DB;

type

  TSPropReqStepChanged = record
    Request : string;
    step    : Integer;
    prop    : string;
    val     : string;
    status  : PRP_Status;
  end;
  PTSPropReqStepChanged = ^TSPropReqStepChanged;

var
  MainPropListUserDef : TList;

{ TPlannerPropDefine }

//-------------------------------------------------------------------------

function SearchReqStep(ProdReq : string; Step : Integer) : Integer;
var
  I : Integer;
  Multiplier, NumberOfEntries : integer;
begin
  Result := -1;

  NumberOfEntries := MainPropListUserDef.Count;
  if NumberOfEntries = 0 then exit;

  Multiplier := 1;
  while Multiplier < NumberOfEntries do
    Multiplier := Multiplier * 2;
  i := Multiplier - 1;

  while (Multiplier > 0) do
  begin

    Multiplier := trunc(Multiplier/2);

    if (i >= NumberOfEntries) then
    begin
      i := i - Multiplier;
      continue;
    end;

    if (PTSPropReqStepChanged(MainPropListUserDef[i]).Request = ProdReq) and
        (PTSPropReqStepChanged(MainPropListUserDef[i]).step = Step) then
    begin
      Result := I;
      break;
    end;

    if (PTSPropReqStepChanged(MainPropListUserDef[i]).Request < ProdReq)
    or ((PTSPropReqStepChanged(MainPropListUserDef[i]).Request = ProdReq) and
       (PTSPropReqStepChanged(MainPropListUserDef[i]).step < Step)) then
       i := i + Multiplier
    else
       i := i - Multiplier;
  end;

  while Result > 0 do
  begin
    i :=  Result - 1;
    if (PTSPropReqStepChanged(MainPropListUserDef[i]).Request <> ProdReq) or
       (PTSPropReqStepChanged(MainPropListUserDef[i]).step <> Step) then
      break;
    result := i;
  end;

end;

//-------------------------------------------------------------------------

function SortReqStep(Item1, Item2: Pointer): integer;
var
  Rec1 , Rec2: PTSPropReqStepChanged;
begin
  Rec1 := PTSPropReqStepChanged(Item1);
  Rec2 := PTSPropReqStepChanged(Item2);

  if Rec1.Request = Rec2.Request then
  begin
    if Rec1.step = Rec2.step then
      Result := 0
    else if Rec1.step > Rec2.step then
      Result := 1
    else
      Result := -1
  end
  else if Rec1.Request > Rec2.Request then
    Result := 1
  else
    Result := -1
end;

//-------------------------------------------------------------------------

function SearchPropInJobList(Prop : TProperties; PropCode : string) : boolean;
var
  I : Integer;
  PropIdJob : TPropID;
  jobPropVal : variant;
  RscCode : string;
begin
  Result := false;
  for I := 0 to Prop.p_PropCount - 1 do
  begin
    jobPropVal := Prop.GetProperty(I, PropIdJob, RscCode);
    if PropCode = GetPropCodeFromID(PropIdJob) then
    begin
      Result := true;
      break;
    end;
  end;
end;

//-------------------------------------------------------------------------

procedure ClearPropChangedList;
var
  I : Integer;
begin
  for I := 0 to MainPropListUserDef.Count - 1 do
    Dispose(PTSPropReqStepChanged(MainPropListUserDef[i]));
  MainPropListUserDef.Clear;
end;

//-------------------------------------------------------------------------

function toMQMFormat(PropCode : string; Value : string) : string;
var
  PropID : TPropID;
  I , len : integer;
  noOfDecimal : Integer;
  d : double;
begin
  Result := value;
  PropID := GetIdFromCode(PropCode);
  if (GetPropType(PropID) = CSA_Numerc) or (GetPropType(PropID) = CSA_Dynamic) then
  begin
    if ExistNumOfDecimal(PropID, len, noOfDecimal) then
    begin
      try
        d := StrToFloat(Value);
      except
        Exit;
      end;
      for i := 0 to noOfDecimal - 1 do
        d := d * 10;
      Result := FloatToStr(d);
    end;
  end;
end;

//-------------------------------------------------------------------------

procedure savePropUserDefine(qry: TMqmQuery; updNum : Integer);
var
  tbInfo : ^TTblInfo;
  I : Integer;
  SqlDel, SqlInsert, SqlUpdate : string;
  PropValue, Code : string;
  IsDateProp : boolean;
  PropId : TPropId;
  DateProp : TDate;
  DateTimeProp : TDateTime;
  Year, Month, Day, Hour, Min, sec, msec : Word;
  IsHeaderDetFound : boolean;
  Id : TSchedId;
begin

  if not Assigned(MainPropListUserDef) then
      Exit;

  tbInfo := @tblInfo[tbl_PROP_PROD_PLANNER];

  with qry do
  begin
    for I := 0 to MainPropListUserDef.Count - 1 do
    begin
      if PTSPropReqStepChanged(MainPropListUserDef[i]).status = PRP_del then
      begin
        SqlDel := 'Delete from ' + tbInfo.GetTableName;
        SqlDel := SqlDel + ' Where ' + CreateFld(tbInfo.pfx, fli_preqNo) + '=''' + PTSPropReqStepChanged(MainPropListUserDef[i]).Request + '''';
        SqlDel := SqlDel + ' And ' + CreateFld(tbInfo.pfx, fli_pstepId) + '=''' + IntToStr(PTSPropReqStepChanged(MainPropListUserDef[i]).step) + '''';
        SqlDel := SqlDel + ' And ' + CreateFld(tbInfo.pfx, fli_PropertyCode) + '=''' + PTSPropReqStepChanged(MainPropListUserDef[i]).prop + '''';
        SqlDel := SqlDel + AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier));
        sql.Text := SqlDel;
        qry.ExecSQL;
      end
      else if PTSPropReqStepChanged(MainPropListUserDef[i]).status = PRP_new then
      begin

        SqlDel := 'Delete from ' + tbInfo.GetTableName;
        SqlDel := SqlDel + ' Where ' + CreateFld(tbInfo.pfx, fli_preqNo) + '=''' + PTSPropReqStepChanged(MainPropListUserDef[i]).Request + '''';
        SqlDel := SqlDel + ' And ' + CreateFld(tbInfo.pfx, fli_pstepId) + '=''' + IntToStr(PTSPropReqStepChanged(MainPropListUserDef[i]).step) + '''';
        SqlDel := SqlDel + ' And ' + CreateFld(tbInfo.pfx, fli_PropertyCode) + '=''' + PTSPropReqStepChanged(MainPropListUserDef[i]).prop + '''';
        SqlDel := SqlDel + AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier));
        sql.Text := SqlDel;
        qry.ExecSQL;

        SqlInsert := '';
        SqlInsert := SqlInsert + 'insert into ' + tbInfo.GetTableName + '(';
        SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_identifier) + ',';
        SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_preqNo) + ',';
        SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_pstepId) + ',';
        SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_PropertyCode) + ',';
        SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_PropValue) + ',';
        SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_updCode) + ',';
        SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_usrCr) + ',';
        SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_usrTmCr);
        SqlInsert := SqlInsert + ') values (';
        SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_identifier) + ',';
        SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_preqNo) + ',';
        SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_pstepId) + ',';
        SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_PropertyCode) + ',';
        SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_PropValue) + ',';
        SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_updCode) + ',';
        SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_usrCr) + ',';
        SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_usrTmCr);
        SqlInsert := SqlInsert + ')';
        sql.Text  := SqlInsert;

        ParamByName(CreateFld(tbInfo.pfx,fli_identifier)).AsString   := IniAppGlobals.Identifier;
        ParamByName(CreateFld(tbInfo.pfx,fli_preqNo)).AsString       := PTSPropReqStepChanged(MainPropListUserDef[i]).Request;
        ParamByName(CreateFld(tbInfo.pfx,fli_pstepId)).AsInteger     := PTSPropReqStepChanged(MainPropListUserDef[i]).step;
        ParamByName(CreateFld(tbInfo.pfx,fli_PropertyCode)).AsString := PTSPropReqStepChanged(MainPropListUserDef[i]).prop;
       // PropValue := toMQMFormat(PTSPropReqStepChanged(MainPropListUserDef[i]).prop,PTSPropReqStepChanged(MainPropListUserDef[i]).val);
        PropValue := PTSPropReqStepChanged(MainPropListUserDef[i]).val;
        Code := PTSPropReqStepChanged(MainPropListUserDef[i]).prop;
        PropId := GetIdFromCode(Code);
        IsDateProp := IsPropAsDate(PropId);
        if IsDateProp then
        begin
          DateProp := date;
          try
            DateProp := StrToDate(PropValue);
          except
            IsDateProp := false;
          end;
          if IsDateProp then
          begin
          {  DecodeDate(DateProp, Year, Month, Day);
            PropValue := intToStr(Year) + GetMonthDayFormat(Month) + GetMonthDayFormat(Day);
            ParamByName(CreateFld(tbInfo.pfx, fli_PropValue)).DataType := ftDate;
            ParamByName(CreateFld(tbInfo.pfx,fli_PropValue)).Value    := PropValue;}
            ParamByName(CreateFld(tbInfo.pfx,fli_PropValue)).AsString    := PropValue;
          end;
          if IsApprovalDateProp(PropId) then
          begin
            Id := p_sc.FindProdSched(ParamByName(CreateFld(tbInfo.pfx,fli_preqNo)).AsString,
                               ParamByName(CreateFld(tbInfo.pfx,fli_pstepId)).AsInteger,
                               0,0,IsHeaderDetFound);
            if IsHeaderDetFound then
              p_sc.SetApprovalDate(Id, DateProp);
          end;
        end
        else if IsCalculatedDateProp(PropId) then
        begin
          IsDateProp   := true;
          DateTimeProp := date;
          try
            DateTimeProp := StrToDateTime(PropValue);
          except
            IsDateProp := false;
          end;
          if IsDateProp then
          begin
            DecodeDate(DateTimeProp, Year, Month, Day);
            DecodeTime(frac(DateTimeProp), Hour, Min, sec, msec);
            PropValue := intToStr(Year) + GetMonthDayFormat(Month) + GetMonthDayFormat(Day) + GetMonthDayFormat(Hour) + GetMonthDayFormat(Min);
            ParamByName(CreateFld(tbInfo.pfx,fli_PropValue)).Value    := PropValue;
          end;

        end
        else
        begin
          ParamByName(CreateFld(tbInfo.pfx, fli_PropValue)).DataType := ftString;
          ParamByName(CreateFld(tbInfo.pfx, fli_PropValue)).Value := PropValue;
        end;
        ParamByName(CreateFld(tbInfo.pfx,fli_updCode)).AsInteger     := updNum + 1;
        ParamByName(CreateFld(tbInfo.pfx,fli_usrCr)).AsString        := IniAppGlobals.WkstCode;
        ParamByName(CreateFld(tbInfo.pfx,fli_usrTmCr)).AsDateTime    := now;
        try
          ExecSQL;
        except
        end;
      end
      else if PTSPropReqStepChanged(MainPropListUserDef[i]).status = PRP_modi then
      begin
        SqlUpdate := 'update ' + tbInfo.GetTableName + ' set ';
        SqlUpdate := SqlUpdate + CreateFld(tbInfo.pfx, fli_PropValue) + ' = ';
        SqlUpdate := SqlUpdate + ':' + CreateFld(tbInfo.pfx, fli_PropValue)  + ',';
        SqlUpdate := SqlUpdate + CreateFld(tbInfo.pfx, fli_updCode) + ' = ';
        SqlUpdate := SqlUpdate + ':' + CreateFld(tbInfo.pfx, fli_updCode)  + ',';
        SqlUpdate := SqlUpdate + CreateFld(tbInfo.pfx, fli_usrCr) + ' = ';
        SqlUpdate := SqlUpdate + ':' + CreateFld(tbInfo.pfx, fli_usrCr)  + ',';
        SqlUpdate := SqlUpdate + CreateFld(tbInfo.pfx, fli_usrTmCr) + ' = ';
        SqlUpdate := SqlUpdate + ':' + CreateFld(tbInfo.pfx, fli_usrTmCr);
        SqlUpdate := SqlUpdate + ' where ';
        SqlUpdate := SqlUpdate + CreateFld(tbInfo.pfx, fli_identifier)   + ' = ';
        SqlUpdate := SqlUpdate + ':' + CreateFld(tbInfo.pfx, fli_identifier) + ' and ';
        SqlUpdate := SqlUpdate + CreateFld(tbInfo.pfx, fli_preqNo)   + ' = ';
        SqlUpdate := SqlUpdate + ':' + CreateFld(tbInfo.pfx, fli_preqNo) + ' and ';
        SqlUpdate := SqlUpdate + CreateFld(tbInfo.pfx, fli_pstepId)   + ' = ';
        SqlUpdate := SqlUpdate + ':' + CreateFld(tbInfo.pfx, fli_pstepId) + ' and ';
        SqlUpdate := SqlUpdate + CreateFld(tbInfo.pfx, fli_PropertyCode)   + ' = ';
        SqlUpdate := SqlUpdate + ':' + CreateFld(tbInfo.pfx, fli_PropertyCode);
        SQL.Text := SqlUpdate;
        ParamByName(CreateFld(tbInfo.pfx, fli_identifier)).AsString := IniAppGlobals.Identifier;
        ParamByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString := PTSPropReqStepChanged(MainPropListUserDef[i]).Request;
        ParamByName(CreateFld(tbInfo.pfx, fli_pstepId)).AsInteger := PTSPropReqStepChanged(MainPropListUserDef[i]).step;
        ParamByName(CreateFld(tbInfo.pfx, fli_PropertyCode)).AsString := PTSPropReqStepChanged(MainPropListUserDef[i]).prop;
      //  PropValue := toMQMFormat(PTSPropReqStepChanged(MainPropListUserDef[i]).prop,PTSPropReqStepChanged(MainPropListUserDef[i]).val);
        PropValue := PTSPropReqStepChanged(MainPropListUserDef[i]).val;
        PropId := GetIdFromCode(PTSPropReqStepChanged(MainPropListUserDef[i]).prop);
        IsDateProp := IsPropAsDate(PropId);
        if IsDateProp then
        begin
          DateProp := date;
          try
            DateProp := StrToDate(PropValue);
          except
            IsDateProp := false;
          end;
          if IsDateProp then
          begin
           // DecodeDate(DateProp, Year, Month, Day);
           // PropValue := intToStr(Year) + GetMonthDayFormat(Month) + GetMonthDayFormat(Day);
           // ParamByName(CreateFld(tbInfo.pfx, fli_PropValue)).DataType := ftDate;
            ParamByName(CreateFld(tbInfo.pfx,fli_PropValue)).AsString    := PropValue;
          end;
          if IsApprovalDateProp(PropId) then
          begin
            Id := p_sc.FindProdSched(ParamByName(CreateFld(tbInfo.pfx,fli_preqNo)).AsString,
                               ParamByName(CreateFld(tbInfo.pfx,fli_pstepId)).AsInteger,
                               0,0,IsHeaderDetFound);
            if IsHeaderDetFound then
              p_sc.SetApprovalDate(Id, DateProp);
          end;
        end
        else
        begin
          ParamByName(CreateFld(tbInfo.pfx, fli_PropValue)).DataType := ftString;
          ParamByName(CreateFld(tbInfo.pfx, fli_PropValue)).Value := PropValue;
        end;

        ParamByName(CreateFld(tbInfo.pfx, fli_updCode)).AsInteger := updNum + 1;
        ParamByName(CreateFld(tbInfo.pfx, fli_usrCr)).AsString := IniAppGlobals.WkstCode;
        ParamByName(CreateFld(tbInfo.pfx, fli_usrTmCr)).AsDateTime := now;
        try
         ExecSQL;
        except
        end;
      end;
    end;
  end;
  ClearPropChangedList;
end;

//-------------------------------------------------------------------------

function GetLast_PROP_PROD_PLANNER : Integer;
var
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
begin
  qry := CreateQuery(Main_DB);
  tbInfo := @tblInfo[tbl_PROP_PROD_PLANNER];

  qry.SQL.Clear;
  qry.SQL.Add('select * from ' + tbInfo.GetTableName);
  qry.SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier)));
  if IniAppGlobals.DownloadTo = '2' then
    qry.SQL.Add(' order by ' + CreateFld(tbInfo.pfx , fli_updCode) + ' descending')
  else
    qry.SQL.Add(' order by ' + CreateFld(tbInfo.pfx , fli_updCode) + ' DESC');
  qry.Open;

  if not qry.EOF then
    Result := qry.FieldByName(CreateFld(tbInfo.pfx, fli_updCode)).AsInteger
  else
    Result := -1;

  qry.Close;
  qry.Free;
end;

//-------------------------------------------------------------------------

function UpdatePropInJobList(Prop : TProperties; PropId : TPropId; val : string) : boolean;
var
  I : Integer;
  PropIdJob : TPropID;
  RscCode : string;
  PropCode : string;
begin
  Result := false;
  for I := 0 to Prop.p_PropCount - 1 do
  begin
    Prop.GetProperty(I, PropIdJob, RscCode);
    if PropId = PropIdJob then
    begin
      Result := true;
      break;
    end;
  end;
  if result then
    Prop.SetValforCodeByIndex(val, I)
  else
  begin
    PropCode := GetPropCodeFromID(PropId);
    Prop.AddPlannerProperty(PropCode, val)
  end;
end;

//-------------------------------------------------------------------------

function CheckPropValueInJobList(Prop : TProperties; PropId : TPropId; var val : string) : boolean;
var
  I : Integer;
  PropIdJob : TPropID;
  RscCode : string;
  PropCode : string;
begin
  Result := false;
  for I := 0 to Prop.p_PropCount - 1 do
  begin
    Prop.GetProperty(I, PropIdJob, RscCode);
    if PropId = PropIdJob then
    begin
      Result := true;
      break;
    end;
  end;
  if result then
    Prop.GetValforCodeByIndex(val, I)
end;

//-------------------------------------------------------------------------

function GetNumLength(Str : string; var DecNumber : integer) : integer;
var
  I : integer;
  Temp : string;
  BeforeDecimal : boolean;
begin
  DecNumber := 0;
  Result := 0;
  BeforeDecimal := true;

  for I := 1 to Length(Str) do
  begin
    Temp := copy(Str, I ,1);

    if not BeforeDecimal then
    begin
      DecNumber := DecNumber + 1;
      Continue;
    end;

    if (Temp < '0') or (Temp > '9') then
    begin
      BeforeDecimal := false;
      Continue;
    end;

    Result := Result + 1;

  end;
end;

//-------------------------------------------------------------------------

function TPlannerPropDefine.CheckData(var str : string) : boolean;
var
  I : Integer;
  PropCode : string;
  PropID : TPropID;
  len, noOfDecimal : Integer;
  LentgBeforeDec, LentgAfterDec : Integer;
begin
  Result := true;
  if m_PropComp.IsPropEnter then
  begin
    for I := 1 to m_PropComp.P_RowCount - 1 do
    begin
      PropCode := m_PropComp.P_GetPropVal[I];
      PropID := GetIdFromCode(PropCode);
      if IsAssignedBooleanProp1(PropID) then continue;

      if (m_PropComp.GetPropDescVal(I) = '') then
      begin
        Result := false;
        break
      end
      else
      begin
        if (GetPropType(PropID) = CSA_Alpha) and not IsPropAsDate(PropId) then
        begin
          len := GetLength(PropID);
          if length(m_PropComp.GetPropDescVal(I)) > len then
          begin
            str := PropCode + ' : ' + _('Higher then length definition');
            Result := false;
            break
          end;
        end

        else if (GetPropType(PropID) = CSA_Numerc) or (GetPropType(PropID) = CSA_Dynamic) then
        begin
          try
            if StrToFloat(m_PropComp.GetPropDescVal(I)) < 0 then
               Result := Result;
          except
            str := PropCode + ' : ' + _('Please Insert a valid numeric value');
            Result := false;
            break
          end;

          ExistNumOfDecimal(PropID, len, noOfDecimal);
          LentgBeforeDec := GetNumLength(m_PropComp.GetPropDescVal(I), LentgAfterDec);

          if LentgBeforeDec > (len - noOfDecimal) then
          begin
            str := PropCode + ' : ' + _('Too many digits');
            Result := false;
            break
          end;

          if LentgAfterDec > noOfDecimal then
          begin
            str := PropCode + ' : ' + _('Too many decimals');
            Result := false;
            break
          end;

        end;
      end;
    end;
  end;
end;

//-------------------------------------------------------------------------

function TPlannerPropDefine.SearchDeletedPropFromJobList(PropListJob : TProperties; Request : string; Step : Integer) : boolean;
var
  I,J, Index : Integer;
  PropIdJob : TPropID;
  jobPropVal : variant;
  RscCode : string;
  PropCode : string;
  Found : boolean;
  RecPropReqStepChanged : PTSPropReqStepChanged;
begin
  Result := false;
  for I := 0 to PropListJob.p_PropCount - 1 do
  begin
    jobPropVal := PropListJob.GetProperty(I, PropIdJob, RscCode);
    if not IsPropPlanner(PropIdJob) then continue;
    PropCode := GetPropCodeFromID(PropIdJob);
    found := false;
    for J := 1 to m_PropComp.P_RowCount - 1 do
    begin
      if PropCode = m_PropComp.P_GetPropVal[J] then
      begin
        found := true;
        break;
      end;
    end;

    if not found then
    begin
      if not SearchPropInCurrentList(PropCode, Index) then
      begin
        new(RecPropReqStepChanged);
        RecPropReqStepChanged.Request := Request;
        RecPropReqStepChanged.Step    := Step;
        RecPropReqStepChanged.Prop    := PropCode;
        RecPropReqStepChanged.status  := PRP_del;
        m_CurrReqStepList.add(RecPropReqStepChanged);
      end;
    end;
  end;
end;

//-------------------------------------------------------------------------

procedure TPlannerPropDefine.BtnAboClick(Sender: TObject);
begin
  ModalResult := mrAbort;
  Close;
end;

procedure TPlannerPropDefine.BtnOkClick(Sender: TObject);
var
  I,J, Index : Integer;
  Properties : TProperties;
  jobPropVal :  variant;
  PropIdJob : TPropID;
  RscCode : string;
  RecPropReqStepChanged : PTSPropReqStepChanged;
  Request, step : variant;
  dataType: CBinColValType;
  PropCode : string;
  FoundProp : boolean;
  Str, PropVal : string;
  PropId : TPropId;
  ID : TSchedId;
  IsHeaderDetFound : boolean;
begin
  ModalResult := mrOk;
  Properties := p_sc.GetProperties(m_ID, nil);
  str := '';
  if not CheckData(str) then
  begin
    if (str <> '') then
      Showmessage(str)
    else
      Showmessage(_('Please enter propery value'));
    ModalResult := mrNone;
    exit;
  end;

  p_sc.GetFldValue(m_Id, CSC_ProdReq, Request, dataType);
  p_sc.GetFldValue(m_Id, CSC_ProdStep, step, dataType);

  for I := Properties.p_PropCount - 1 downto 0 do
  begin
    jobPropVal := Properties.GetProperty(I, PropIdJob, RscCode);
    if not IsPropPlanner(PropIdJob) then continue;

    FoundProp := false;
    for J := 1 to m_PropComp.P_RowCount - 1 do
    begin
      PropCode := GetPropCodeFromID(PropIdJob);
      if PropCode = m_PropComp.P_GetPropVal[J] then
      begin
        FoundProp := true;
        break;
      end;
    end;
    if not FoundProp then
    begin
      if not SearchPropInCurrentList(PropCode, Index) then
      begin
        new(RecPropReqStepChanged);
        RecPropReqStepChanged.Request := Request;
        RecPropReqStepChanged.Step    := Step;
        RecPropReqStepChanged.Prop    := PropCode;
        RecPropReqStepChanged.status  := PRP_del;
        m_CurrReqStepList.Add(RecPropReqStepChanged)
      end
      else
        PTSPropReqStepChanged(m_CurrReqStepList[Index]).status := PRP_del;
      Properties.DeletFromList(PropCode);

      PropId := GetIdFromCode(PropCode);
      if IsPropAsDate(PropId) and IsApprovalDateProp(PropId) then
      begin
        Id := p_sc.FindProdSched(Request,Step,0,0,IsHeaderDetFound);
        if IsHeaderDetFound then
          p_sc.SetApprovalDate(Id, 0);
      end;

    end;
  end;

  for I := 1 to m_PropComp.P_RowCount - 1 do
  begin
    Propval := '';
    if m_PropComp.P_GetPropVal[I] = '' then continue;

    PropId := GetIdFromCode(m_PropComp.P_GetPropVal[I]);
    if IsAssignedBooleanProp1(PropId) then
    begin
      if m_PropComp.P_GetBooleanVal[I] then
        PropVal := _('1')
      else
        PropVal := _('0');
    end
    else
      Propval := m_PropComp.GetPropDescVal(I);

    if not SearchPropInJobList(Properties, m_PropComp.P_GetPropVal[I]) then
    begin

      Properties.AddPlannerProperty(m_PropComp.P_GetPropVal[I], Propval);
      if not SearchPropInCurrentList(Propval, Index) then
      begin
        new(RecPropReqStepChanged);
        RecPropReqStepChanged.Request := Request;
        RecPropReqStepChanged.Step    := Step;
        RecPropReqStepChanged.Prop    := m_PropComp.P_GetPropVal[I];
        RecPropReqStepChanged.val     := Propval;
        RecPropReqStepChanged.status  := PRP_new;
        m_CurrReqStepList.Add(RecPropReqStepChanged);
      end
      else
      begin
        if (PTSPropReqStepChanged(m_CurrReqStepList[Index]).status = PRP_del) then
        begin
          PTSPropReqStepChanged(m_CurrReqStepList[Index]).val := Propval;
          PTSPropReqStepChanged(m_CurrReqStepList[Index]).status := PRP_modi;
        end;
      end;
    end
    else
    begin
      Properties.SetValforCode(m_PropComp.P_GetPropVal[I],Propval);
      if not updatePropValToCurrList(m_PropComp.P_GetPropVal[I],Propval) then
      begin
        new(RecPropReqStepChanged);
        RecPropReqStepChanged.Request := Request;
        RecPropReqStepChanged.Step    := Step;
        RecPropReqStepChanged.Prop    := m_PropComp.P_GetPropVal[I];
        RecPropReqStepChanged.val     := Propval;
        RecPropReqStepChanged.status  := PRP_modi;
        m_CurrReqStepList.Add(RecPropReqStepChanged);
      end;
    end;

    PropId := GetIdFromCode(m_PropComp.P_GetPropVal[I]);
    if IsPropAsDate(PropId) and IsApprovalDateProp(PropId) then
    begin
      Id := p_sc.FindProdSched(Request,Step,0,0,IsHeaderDetFound);
      if IsHeaderDetFound then
        p_sc.SetApprovalDate(Id, StrToDate(m_PropComp.GetPropDescVal(I)));
    end;
  end;

  updateMainPropList(Properties,Request,step);

  if assigned(FBin) then FBin.RefreshGrid;

end;

//-------------------------------------------------------------------------

procedure TPlannerPropDefine.MarkJobPropertyInList;
var
  Request, step : variant;
  dataType: CBinColValType;
  StartIndex : Integer;
  RecPropReqStepChanged : PTSPropReqStepChanged;
begin
  p_sc.GetFldValue(m_Id, CSC_ProdReq, Request, dataType);
  p_sc.GetFldValue(m_Id, CSC_ProdStep, step, dataType);
  StartIndex := SearchReqStep(Request, step);
  m_StartIndexMainList := StartIndex;
  if StartIndex > -1 then
  begin
    while (StartIndex < MainPropListUserDef.Count) and (PTSPropReqStepChanged(MainPropListUserDef[StartIndex]).Request = Request) and
          (PTSPropReqStepChanged(MainPropListUserDef[StartIndex]).step = step) do
    begin
      new(RecPropReqStepChanged);
      RecPropReqStepChanged.Request := Request;
      RecPropReqStepChanged.Step    := Step;
      RecPropReqStepChanged.Val     := PTSPropReqStepChanged(MainPropListUserDef[StartIndex]).val;
      RecPropReqStepChanged.Prop    := PTSPropReqStepChanged(MainPropListUserDef[StartIndex]).prop;
      RecPropReqStepChanged.status  := PTSPropReqStepChanged(MainPropListUserDef[StartIndex]).status;
      m_CurrReqStepList.Add(RecPropReqStepChanged);
      Inc(StartIndex);
    end;
  end
  else
  begin
  end;

end;

//-------------------------------------------------------------------------

function TPlannerPropDefine.SearchPropInCurrentList(Prop: string; var Indx: Integer): boolean;
var
  I : Integer;
begin
  result := false;
  for I := 0 to m_CurrReqStepList.Count - 1 do
  begin
    if PTSPropReqStepChanged(m_CurrReqStepList[I]).prop = prop then
    begin
      result := true;
      Indx := I;
      break;
    end;
  end;
end;

//-------------------------------------------------------------------------

constructor TPlannerPropDefine.CreatePlannerPropDefine(AOwner: TComponent; Properties : TProperties; ID : TSchedId);
begin
  inherited Create(AOwner);
  m_Id := Id;
  if not assigned(MainPropListUserDef) then
    MainPropListUserDef := TList.Create;
  m_CurrReqStepList   := TList.Create;
  MainPropListUserDef.Sort(SortReqStep);
  m_PropComp := TPropComponent.CreatePropComp(Panel1,PlannerPropDef,nil,Id, nil, nil);
  caption := _('Properties definition') + ' - ' + _('Request')   + ' : ' + p_sc.GetFldDescr(id,CSC_ProdReq, false) + ' ' +
             _('Step')      + ' : ' + p_sc.GetFldDescr(id,CSC_ProdStep, false);

  MarkJobPropertyInList;
  ReShape(Self);
end;

//-------------------------------------------------------------------------

procedure TPlannerPropDefine.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  if Assigned(m_PropComp) then
     m_PropComp.Free;
  if Assigned(m_CurrReqStepList) then
     m_CurrReqStepList.Free;
end;

//-------------------------------------------------------------------------

procedure TPlannerPropDefine.updateMainPropList(PropListJob : TProperties; Request : string; Step : Integer);
var
  I, Index : Integer;
  RecPropReqStepChanged : PTSPropReqStepChanged;
begin

  if (MainPropListUserDef.count = 0) then
  begin
    SearchDeletedPropFromJobList(PropListJob, Request, Step);
    for I := 0 to m_CurrReqStepList.Count - 1 do
    begin
      MainPropListUserDef.Add(m_CurrReqStepList[I]);
    end;
  end

  else if (MainPropListUserDef.count > 0) and (m_StartIndexMainList = -1) then
  begin
    for I := 0 to m_CurrReqStepList.Count - 1 do
    begin
      MainPropListUserDef.Add(m_CurrReqStepList[I]);
    end;
  end

  else if (MainPropListUserDef.Count > 0) and (m_StartIndexMainList > -1) then
  begin
    while (m_StartIndexMainList < MainPropListUserDef.Count) and (Request = PTSPropReqStepChanged(MainPropListUserDef[m_StartIndexMainList]).Request) and
         (Step = PTSPropReqStepChanged(MainPropListUserDef[m_StartIndexMainList]).Step) do
    begin
      if not SearchPropInJobList(PropListJob, PTSPropReqStepChanged(MainPropListUserDef[m_StartIndexMainList]).prop) then
      begin
        if not SearchPropInCurrentList(PTSPropReqStepChanged(MainPropListUserDef[m_StartIndexMainList]).prop, Index) then
        begin
          new(RecPropReqStepChanged);
          RecPropReqStepChanged.Request := Request;
          RecPropReqStepChanged.Step    := Step;
          RecPropReqStepChanged.Prop    := PTSPropReqStepChanged(MainPropListUserDef[m_StartIndexMainList]).prop;
          RecPropReqStepChanged.status  := PRP_del;
          m_CurrReqStepList.Add(RecPropReqStepChanged)
        end
        else
          PTSPropReqStepChanged(m_CurrReqStepList[Index]).status := PRP_del;
      end;
      Inc(m_StartIndexMainList);

    end;

    for I := m_StartIndexMainList - 1 downto 0 do
    begin
      if (Request = PTSPropReqStepChanged(MainPropListUserDef[I]).Request) and
         (Step = PTSPropReqStepChanged(MainPropListUserDef[I]).Step) then
      begin
        Dispose(PTSPropReqStepChanged(MainPropListUserDef[I]));
        MainPropListUserDef.remove(MainPropListUserDef[I])
      end
      else
        Break;
    end;

    for I := 0 to m_CurrReqStepList.Count - 1 do
       MainPropListUserDef.Add(m_CurrReqStepList[I])
  end;

end;

//-------------------------------------------------------------------------

function TPlannerPropDefine.updatePropValToCurrList(Prop, Val: string) : boolean;
var
  I : Integer;
begin
  Result := false;
  for I := 0 to m_CurrReqStepList.Count - 1 do
  begin
    if PTSPropReqStepChanged(m_CurrReqStepList[I]).prop = Prop then
    begin
      PTSPropReqStepChanged(m_CurrReqStepList[I]).val := val;
      Result := true;
      Break;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure UpdateMainListPropChange(Id : TSchedId; PropCode : string; val : string; delete : boolean);
var
  Request, step : variant;
  dataType: CBinColValType;
  StartIndex : Integer;
  RecPropReqStepChanged : PTSPropReqStepChanged;
  NewEnter : boolean;
begin
  NewEnter := false;
  if not Assigned(MainPropListUserDef) then
     MainPropListUserDef := TList.Create;
  p_sc.GetFldValue(Id, CSC_ProdReq, Request, dataType);
  p_sc.GetFldValue(Id, CSC_ProdStep, step, dataType);
  StartIndex := SearchReqStep(Request, step);
  if StartIndex > -1 then
  begin
    while (StartIndex < MainPropListUserDef.Count) and (PTSPropReqStepChanged(MainPropListUserDef[StartIndex]).Request = Request) and
          (PTSPropReqStepChanged(MainPropListUserDef[StartIndex]).step = step) do
        //  (PTSPropReqStepChanged(MainPropListUserDef[StartIndex]).prop = PropCode) do
    begin
      if (PTSPropReqStepChanged(MainPropListUserDef[StartIndex]).prop = PropCode) then
      begin

        PTSPropReqStepChanged(MainPropListUserDef[StartIndex]).val := val;
        if (PTSPropReqStepChanged(MainPropListUserDef[StartIndex]).status = PRP_del) and not delete then
          PTSPropReqStepChanged(MainPropListUserDef[StartIndex]).status := PRP_new;
        if delete then
          PTSPropReqStepChanged(MainPropListUserDef[StartIndex]).status := PRP_del;
       // Inc(StartIndex);
        newEnter := false;
        break
      end
      else
      begin
        newEnter := true;
        Inc(StartIndex);
      end;
    end;
  end
  else
  begin
    new(RecPropReqStepChanged);
    RecPropReqStepChanged.Request := Request;
    RecPropReqStepChanged.Step    := Step;
    RecPropReqStepChanged.Val     := val;
    RecPropReqStepChanged.Prop    := PropCode;
    RecPropReqStepChanged.status  := PRP_new;
    if delete then
      RecPropReqStepChanged.status  := PRP_del;
    MainPropListUserDef.Add(RecPropReqStepChanged);
    MainPropListUserDef.Sort(SortReqStep);
  end;

  if newEnter then
  begin
    new(RecPropReqStepChanged);
    RecPropReqStepChanged.Request := Request;
    RecPropReqStepChanged.Step    := Step;
    RecPropReqStepChanged.Val     := val;
    RecPropReqStepChanged.Prop    := PropCode;
    RecPropReqStepChanged.status  := PRP_new;
    if delete then
      RecPropReqStepChanged.status  := PRP_del;
    MainPropListUserDef.Add(RecPropReqStepChanged);
    MainPropListUserDef.Sort(SortReqStep);
  end;

end;

//------------------------------------------------------------------------------

initialization

finalization

  if Assigned(MainPropListUserDef) then
  begin
    ClearPropChangedList;
    MainPropListUserDef.Free;
  end;

end.
