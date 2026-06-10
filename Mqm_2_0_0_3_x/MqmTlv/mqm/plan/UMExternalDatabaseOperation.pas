unit UMExternalDatabaseOperation;

interface

uses
  Vcl.StdCtrls,
  UMCommon,
  System.Classes,
  DMsrvPc;

function  ExternalDB_GetLastUpdatedNumber_OnMystation : Integer;
procedure ExternalDB_DeleteAll_Req_change_OnMystation;
procedure ExternalDB_DeleteProd_Sched(qry: TMqmQuery; ProgBar: TObject; Status: TStaticText; WorkCentersHandledList, WorkCentersViewedList : string);
procedure ExternalDB_LoadAllStepsAndRequestsOnMyStation;
function  ExternalDB_LoopAllRequestHeaderFromPlan : boolean;
procedure ExternalDB_FillPropertiesUnscheduleList(qry: TMqmQuery; Status: TStaticText);
procedure ExternalDB_AddRequestStepToStepsToNotSaveList;
function  ExternalDB_CheckRequestStepInToNotSaveList(Request : string; Step : string) : boolean;
procedure ExternalDB_ClearCurrentStepsList;
procedure ExternalDB_ClearDatesMcmList;
procedure ExternalDB_UpdateMqmFromMcmEarliestLatestDates(qry: TMqmQuery; ProgBar: TObject; Status: TStaticText; WorkCentersHandledList, WorkCentersViewedList : string);
procedure ExternalDB_ForceMqmScheduleDetailsToMCM(WorkCentersHandledList : string);

type

  TDatesMcmSteps = record
    Request : string;
    Step : integer;
    planStart : TDateTime;
    planEnd   : TDateTime;
    LowStartTimeLimit : TDateTime;
    HighEndTimeLimit  : TDateTime;
  end;
  PDatesMcmSteps = ^TDatesMcmSteps;

  TCurrentSteps = record
    Request : string;
    Step : integer;
    Hdr_UTC : TDatetime;
    Init_Quent : double;
    Fin_Quent : double;
    Step_Can_Group : boolean;
    Forced_Grp_No : Integer;
    Step_Type : string;
    Workcenter : string;
    process : string;
    Sched_Mcm : boolean;
    Sched_Mqm : boolean;
    Step_UTC : TDatetime;
    RequestFound : boolean;
    IsStepClosed : boolean;
    StepFound : boolean;

    // for mcm
    LowStartTimeLimit : TDateTime;
    HighEndTimeLimit  : TDateTime;
  end;
  PTCurrentSteps = ^TCurrentSteps;

  TReqChange = record
    Request : string;
    Step    : integer;
    TypeOfChange : string;
  end;
  PTReqChange = ^TReqChange;

implementation

uses
  UMCompat,
  SysUtils,
  UMGlobal,
  UMSchedCont,
  UMObjCont,
  UMSchedOnPlan,
  gnugettext,
  Vcl.Forms,
  UMWkCtr,
  Data.db,
  UMSchedContFunc,
  Vcl.Dialogs,
  UMTblDesc;

var
  m_CurrentStepsList, m_DatesFromMcmList : TList;
  m_ReqChangeList    : Tlist;
  m_StepsToNotSave   : TStringList;
  m_PropertiesUnscheduleList : string;
  m_WorkCentersHandledList : string;
  m_WorkCentersViewedList : string;
  m_WorkCentersHandledAndViewList : string;

//----------------------------------------------------------------------------//

function ExternalDB_GetLastUpdatedNumber_OnMystation : Integer;
var
  qry:       TMqmQuery;
  tbReqChange : ^TTblInfo;
begin
  tbReqChange := @tblInfo[tbl_Req_Change];
  qry := CreateQuery(Main_DB);

  with qry do
  begin
    SQL.Clear;
    SQL.Add('Select ' + CreateFld(tbReqChange.pfx, fli_updCode) + ' from ' + tbReqChange.GetTableName +
    WHERE_IDF_Condition(CreateFld(tbReqChange.pfx, fli_Identifier)) + ' AND ' +
    CreateFld(tbReqChange.pfx, fli_wkstCode) + '=''' + IniAppGlobals.WkstCode + '''' +
    ' AND ' + CreateFld(tbReqChange.pfx, fli_preqNo) + '=' + QuotedStr('_ _'));
    open;

    if Eof then
      Result := GetLastUpdatedNumber
    else
      Result := FieldByName(CreateFld(tbReqChange.pfx, fli_updCode)).AsInteger;
    Close;
  end;
  Result := Result + 1;
  qry.free;
end;

//----------------------------------------------------------------------------//

procedure CleanReqChangeList;
begin

end;

//----------------------------------------------------------------------------//

procedure CurrentStepsList;
begin

end;

//----------------------------------------------------------------------------//

function FindHdrFromCode(CurrentList : boolean; List : TList; hdrCode: string): Integer;
var
  i: integer;
  Multiplier, NumberOfEntries : integer;
begin
  Result := -1;

  NumberOfEntries := List.Count;
  if NumberOfEntries = 0 then exit;

  Multiplier := 1;
  while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
  i := Multiplier - 1;

  while (Multiplier > 0) do
  begin

    if CurrentList then
    begin
      if  (i < NumberOfEntries)
      and (PTCurrentSteps(List[i]).Request = hdrCode) then break;

      Multiplier := trunc(Multiplier / 2);

      if  (i < NumberOfEntries)
      and (PTCurrentSteps(List[i]).Request < hdrCode) then
        i := i + Multiplier
      else
        i := i - Multiplier;
    end
    else
    begin
      if  (i < NumberOfEntries)
      and (TSCProdReqHdr(List[i]).m_code = hdrCode) then break;

      Multiplier := trunc(Multiplier / 2);

      if  (i < NumberOfEntries)
      and (TSCProdReqHdr(List[i]).m_code < hdrCode) then
        i := i + Multiplier
      else
        i := i - Multiplier;
    end;

  end;

  if Multiplier > 0 then Result := i

end;

//----------------------------------------------------------------------------//

function CheckIfRequestInChangedList(Request : string) : boolean;
var
  I : Integer;
begin
  Result := false;
  for I := 0 to m_ReqChangeList.Count - 1 do
  begin
    if PTReqChange(m_ReqChangeList[I]).Request = Request then
    begin
      result := true;
      exit;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure ExternalDB_FillPropertiesUnscheduleList(qry: TMqmQuery; Status: TStaticText);
var
  tbiPP : ^TTblInfo;
  Comma : string;
  step, I    : integer;
  PRecTiming : PTRecTiming;
  List : TList;
begin
  m_PropertiesUnscheduleList := '';

  if Assigned(Status) then
    Status.Caption := _('Read properties to unschedule ...');
  Application.ProcessMessages;
  tbiPP := @tblInfo[tbl_prop];

  Comma := '';
  with qry.SQL do
  begin
    Clear;
    Add('select ');
    Add('PY_PROPERTY PROPERTYCODE, PY_CNG_PROP_VAL_CAUSE_RESCHED ');
    Add('from ');
    Add(tbiPP.GetTableName + ' ');
    Add(WHERE_IDF_Condition(CreateFld(tbiPP.pfx, fli_Identifier)));
    Add(' AND ');
    Add('PY_CNG_PROP_VAL_CAUSE_RESCHED = ' + QuotedStr('1') + ' ');
    qry.open;
    while not Qry.Eof do
    begin
      m_PropertiesUnscheduleList := m_PropertiesUnscheduleList + comma + QuotedStr(qry.FieldByName('PROPERTYCODE').AsString);
      Comma := ',';
      Qry.Next;
    end;
    qry.close;
  end;
end;

//----------------------------------------------------------------------------//

procedure ExternalDB_AddRequestStepToStepsToNotSaveList;
var
  tblInfo_PropProd, tbInfo_Prod_Step : ^TTblInfo;
  Qry : TMqmQuery;
  Val, tmpVal : variant;
  Request, PropCode, PCode, RscCode : string;
  Step, Pos, I, J : Integer;
  prodReqList : TList;
  prop: TPropID;
  ProdReqHdr  : TSCProdReqHdr;
  tDet : TSCProdReqDet;
  PropId : TPropID;

begin
  if m_PropertiesUnscheduleList = '' then Exit;
  Qry := CreateQuery(Main_DB);
  Qry.Transaction := CreateTransaction(Main_DB);
  Qry.Transaction.StartTransaction;
  m_StepsToNotSave.Clear;

  tblInfo_PropProd := @tblInfo[tbl_prop_prod];
  tbInfo_Prod_Step  := @tblInfo[tbl_prod_step];

  with qry do
  begin
    SQL.Clear;
    SQL.Add('select ');
    SQL.Add('PP_PREQ_NO Request, PP_PSTEP_ID Step, PP_PROPERTY PropertyCode, PP_VALUE VAL ');
    SQL.Add('from ');
    SQL.Add(tblInfo_PropProd.GetTableName + ' PP ');
    SQL.Add(WHERE_IDF_Condition(CreateFld(tblInfo_PropProd.pfx, fli_Identifier)));
    SQL.Add(' and PP.' + CreateFld(tblInfo_PropProd.pfx, fli_PropertyCode) + ' IN ' + '(' + m_PropertiesUnscheduleList + ')');
    SQL.Add(' and PP.' + CreateFld(tblInfo_PropProd.pfx, fli_CrtOrUpdateDateTimeUTC) + ' > ' + ConvertDateFormatMQM(IniAppGlobals.RefreshUTC));
    SQL.Add( ' and (exists (select 1 from ' + tbInfo_Prod_Step.GetTableName + ' PD ');
    SQL.Add( ' where PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_IDENTIFIER) + ' = PP.' + CreateFld(tblInfo_PropProd.pfx, fli_IDENTIFIER) + ' ');
    SQL.Add( ' and PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_preqNo) + ' = PP.' + CreateFld(tblInfo_PropProd.pfx, fli_preqNo) + ' ');
    SQL.Add( ' and (PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_pstepId) + ' = PP.' + CreateFld(tblInfo_PropProd.pfx, fli_pstepId) + ' ');
    SQL.Add( ' Or PP.' + CreateFld(tblInfo_PropProd.pfx, fli_pstepId) + ' = ' + IntTostr(0) + ')');
    SQL.Add(' and PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_wkCtrCode) + ' IN ' + '(' + m_WorkCentersHandledAndViewList + ')' + '))');
    SQL.Add(' Order by Request, Step');
    Open;
    if not Eof then
      prodReqList := p_sc.P_GetprodReqList;
    while not EOF do
    begin
      Request  := FieldByName('Request').AsString;
      Step     := FieldByName('Step').AsInteger;
      PropCode := FieldByName('PropertyCode').AsString;
      Val      := FieldByName('Val').AsString;

      Pos := FindHdrFromCode(false, prodReqList, Request);

      if Pos > -1 then
      begin
        prop := DecodeProp(PropCode, val, tmpVal);
        ProdReqHdr := TSCProdReqHdr(prodReqList[Pos]);
        for I := 0 to ProdReqHdr.m_list.Count - 1 do
        begin
          tDet := TSCProdReqDet(ProdReqHdr.m_list[I]);
          if (Step <> 0) and (Step <> tDet.m_code) then continue;

          for J := tdet.m_propList.p_PropCount - 1 downto 0 do
          begin
            val := tdet.m_propList.GetProperty(J, PropId, RscCode);
            PCode := GetPropCodeFromID(PropId);
            if PropCode = PCode then
            begin
              if (tmpVal <> val) and (m_StepsToNotSave.IndexOf(Request+IntToStr(tDet.m_code)) = -1) then
              begin
                m_StepsToNotSave.add(Request+IntToStr(tDet.m_code));
              end;
            end;
          end;
        end;
      end;

      Next;
    end;

  end;
  Qry.Transaction.Commit;
  qry.Free;
end;

//----------------------------------------------------------------------------//

function ExternalDB_CheckRequestStepInToNotSaveList(Request : string; Step : string) : boolean;
begin
  Result := false;
  if m_StepsToNotSave.IndexOf(Request + step) <> - 1 then
  begin
    Result := true;
    Exit
  end;
end;

//----------------------------------------------------------------------------//

function SortCurrentSteps(Item1, Item2: Pointer) : integer;
var
  CurrentStep1 : PTCurrentSteps;
  CurrentStep2 : PTCurrentSteps;
begin
  CurrentStep1 := PTCurrentSteps(Item1);
  CurrentStep2 := PTCurrentSteps(Item2);
  if (CurrentStep1.Request < CurrentStep2.Request) then
    Result := -1
  else if (CurrentStep1.Request = CurrentStep2.Request) then
  begin
    if (CurrentStep1.Step < CurrentStep2.Step) then
      Result := -1
    else if (CurrentStep1.Step = CurrentStep2.Step) then
      Result := 0
    else
      Result := 1;
  end
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

function FindOrAddByRequestStep(var List : TList; Request : string; Step : Integer; changetype : string) : PTReqChange;
var
  i, Index : integer;
  Multiplier, NumberOfEntries, NumberOfEntriesMinusOne : integer;
  ReqChange : PTReqChange;
begin
  NumberOfEntries := List.Count;
  Index := NumberOfEntries;
  result := nil;
  if NumberOfEntries > 0 then
  begin
    NumberOfEntriesMinusOne := NumberOfEntries - 1;
    Multiplier := 1;
    while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    i := Multiplier - 1;

    while (Multiplier > 0) do
    begin
      Multiplier := trunc(Multiplier / 2);

      if (i > NumberOfEntriesMinusOne) then
      begin
        i := i - Multiplier;
        Continue;
      end;

      if  (PTReqChange(List[i]).Request > Request) then
      begin
        if I < Index then Index := I;
        i := i - Multiplier;
        Continue;
      end;

      if  (PTReqChange(List[i]).Request < Request) then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if  (PTReqChange(List[i]).Step > Step) then
      begin
        if I < Index then Index := I;
        i := i - Multiplier;
        Continue;
      end;

      if  (PTReqChange(List[i]).Step < Step) then
      begin
        i := i + Multiplier;
        Continue;
      end;

      if PTReqChange(List[i]).TypeOfChange < changetype then
          PTReqChange(List[i]).TypeOfChange := changetype;

      Break;

    end;

  end;

  if (Result = nil) then
  begin
    new(ReqChange);
    ReqChange.Request    := Request;
    ReqChange.Step       := Step;
    ReqChange.TypeOfChange := changetype;
    List.insert(Index, ReqChange);
  end;

end;

//----------------------------------------------------------------------------//

procedure ExternalDB_DeleteProd_Sched(qry: TMqmQuery; ProgBar: TObject; Status: TStaticText; WorkCentersHandledList, WorkCentersViewedList : string);
var
  ProgBarstatus : TMqmProgBar;
  tbInfo_Req_Change, tbInfo_Prod_Sched, tbInfo_prod_sched_mcm, tbInfo_Prod_Step, tbInfo_Prop_prod, tbInfo_wkc_alt : ^TTblInfo;
  ReqChange : PTReqChange;
  List : TList;
  I : Integer;
  InitialSql : boolean;
  TypeOfChange : string;
begin
  m_WorkCentersHandledList := WorkCentersHandledList;
  m_WorkCentersViewedList  := WorkCentersViewedList;
  m_WorkCentersHandledAndViewList := m_WorkCentersHandledList;

  if (m_WorkCentersViewedList <> '') and (m_WorkCentersHandledList <> '') then
    m_WorkCentersHandledAndViewList := m_WorkCentersHandledList + ',' + m_WorkCentersViewedList
  else if (m_WorkCentersViewedList <> '') then
    m_WorkCentersHandledAndViewList := m_WorkCentersViewedList;

  if m_WorkCentersHandledAndViewList = '' then
     m_WorkCentersHandledAndViewList := QuotedStr('&&&');

  if WorkCentersHandledList = '' then
     WorkCentersHandledList := QuotedStr('&&&');


  if Assigned(ProgBar) then
  begin
    ProgBarstatus := ProgBar as TMqmProgBar;

    ProgBarstatus.SetPosition(0);
    ProgBarstatus.SetMax(2000);
    //PrgBlock := trunc(2000/100) + 1;
    //PrgIndex := 0;
    //PrgPrevSecond := 0;
  end;

  tbInfo_Req_Change := @tblInfo[tbl_Req_Change];
  tbInfo_Prod_Sched := @tblInfo[tbl_prod_sched];
  tbInfo_prod_sched_mcm := @tblInfo[tbl_prod_sched_mcm];
  tbInfo_Prod_Step  := @tblInfo[tbl_prod_step];
  tbInfo_Prop_prod  := @tblInfo[tbl_prop_prod];
  tbInfo_wkc_alt    := @tblInfo[tbl_wkc_alt];

  with qry do
  begin
    SQL.Clear;

    if Assigned(Status) then Status.Caption := _('Check schedules relevance ...');

    Application.ProcessMessages;
    if not DBAppGlobals.MCM_App then
    begin
      SQL.Add('select distinct ');
      SQL.Add(QuotedStr('1') +' changetype ,');
      SQL.Add(CreateFld(tbInfo_Prod_Sched.pfx, fli_preqNo) + ',');
      SQL.Add(CreateFld(tbInfo_Prod_Sched.pfx, fli_pstepId));
      SQL.Add(' from ' + tbInfo_Prod_Sched.GetTableName + ' PS ');
      SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo_Prod_Sched.pfx, fli_Identifier)));
      SQL.Add( ' and PS.' + CreateFld(tbInfo_Prod_Sched.pfx, fli_StepWorkCenter) + ' IN ' + '(' + WorkCentersHandledList + ')');
      SQL.Add( ' and not exists (select 1 from ' + tbInfo_Prod_Step.GetTableName + ' PD ');
      SQL.Add( ' where PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_IDENTIFIER) + ' = PS.' + CreateFld(tbInfo_Prod_Sched.pfx, fli_IDENTIFIER) + ' ');
      SQL.Add( ' and PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_preqNo) + ' = PS.' + CreateFld(tbInfo_Prod_Sched.pfx, fli_preqNo) + ' ');
      SQL.Add( ' and PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_pstepId) + ' = PS.' + CreateFld(tbInfo_Prod_Sched.pfx, fli_pstepId) + ')');
      SQL.Add( ' union all ');
      SQL.Add('select distinct ');
      SQL.Add(QuotedStr('2') +' changetype ,');
      SQL.Add(CreateFld(tbInfo_Prod_Sched.pfx, fli_preqNo) + ',');
      SQL.Add(CreateFld(tbInfo_Prod_Sched.pfx, fli_pstepId));
      SQL.Add(' from ' + tbInfo_Prod_Sched.GetTableName + ' PS ');
      SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo_Prod_Sched.pfx, fli_Identifier)));
      SQL.Add(' and exists (select 1 from ' + tbInfo_Prod_Step.GetTableName + ' PD ');
      SQL.Add( ' where PD. ' + CreateFld(tbInfo_Prod_Step.pfx, fli_IDENTIFIER) + ' = PS.' + CreateFld(tbInfo_Prod_Sched.pfx, fli_IDENTIFIER) + ' ');
      SQL.Add( ' and PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_preqNo) + ' = PS.' + CreateFld(tbInfo_Prod_Sched.pfx, fli_preqNo) + ' ');
      SQL.Add( ' and PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_pstepId) + ' = PS.' + CreateFld(tbInfo_Prod_Sched.pfx, fli_pstepId) + ' ');
      SQL.Add( ' and PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_wkCtrCode) + ' IN ' + '(' + WorkCentersHandledList + ')');
      SQL.Add( ' and (PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_quantInit) + ' = ' + '0' +  ' OR PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_quantFinl) + ' = ' + '0');
      SQL.Add(' OR (PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_StepType) + ' = ' + QuotedStr('B'));
      SQL.Add(' and PS.' + CreateFld(tbInfo_Prod_Sched.pfx, fli_StepType) + ' <> ' + QuotedStr('B') + ')');
      SQL.Add(' OR (PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_StepType) + ' <> ' + QuotedStr('B'));
      SQL.Add(' and PS.' + CreateFld(tbInfo_Prod_Sched.pfx, fli_StepType) + ' = ' + QuotedStr('B') + ')');
      SQL.Add(' OR (PD.' +  CreateFld(tbInfo_Prod_Step.pfx, fli_StepCanGroup) + ' = ' + '0' + ' and PS.' + CreateFld(tbInfo_Prod_Sched.pfx, fli_stGroup) + ' <> ' + QuotedStr('0') + ')');
      SQL.Add(' OR (PD.' +  CreateFld(tbInfo_Prod_Step.pfx, fli_ForcedGroupNo) + ' <> ' + '0' + ' and PS.' + CreateFld(tbInfo_Prod_Sched.pfx, fli_ForcedGroupNo) + ' = ' + QuotedStr('0') + ')');
      SQL.Add(' OR PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_SchedulByMqm) + ' = ' + QuotedStr('0') + '))');
      SQL.Add(' union all ');
      SQL.Add('select distinct ');
      SQL.Add(QuotedStr('3') +' changetype ,');
      SQL.Add(CreateFld(tbInfo_Prod_Sched.pfx, fli_preqNo) + ',');
      SQL.Add(CreateFld(tbInfo_Prod_Sched.pfx, fli_pstepId));
      SQL.Add(' from ' + tbInfo_Prod_Sched.GetTableName + ' PS ');
      SQL.Add(' join ' + tbInfo_Prod_Step.GetTableName + ' PD on ');
      SQL.Add(' PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_IDENTIFIER) + ' = PS.' + CreateFld(tbInfo_Prod_Sched.pfx, fli_IDENTIFIER));
      SQL.Add( ' and PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_preqNo) + ' = PS.' + CreateFld(tbInfo_Prod_Sched.pfx, fli_preqNo) + ' ');
      SQL.Add( ' and PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_pstepId) + ' = PS.' + CreateFld(tbInfo_Prod_Sched.pfx, fli_pstepId) + ' ');
      SQL.Add( ' and PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_wkCtrCode) + ' <> PS.' + CreateFld(tbInfo_Prod_Sched.pfx, fli_StepWorkCenter) + ' ');
      SQL.Add( 'and PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_wkCtrCode) + ' IN ' + '(' + WorkCentersHandledList + ')');
      SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo_Prod_Sched.pfx, fli_Identifier)));
      SQL.Add(' and not exists (select 1 from ' + tbInfo_wkc_alt.GetTableName + ' AW ');
      SQL.Add( ' where AW.' + CreateFld(tbInfo_wkc_alt.pfx, fli_IDENTIFIER) + ' = PS.' + CreateFld(tbInfo_Prod_Sched.pfx, fli_IDENTIFIER) + ' ');
      SQL.Add( ' and AW.' + CreateFld(tbInfo_wkc_alt.pfx, fli_wkCtrCode) + ' = PS.' + CreateFld(tbInfo_Prod_Sched.pfx, fli_StepWorkCenter) + ' ');
      SQL.Add( ' and AW.' + CreateFld(tbInfo_wkc_alt.pfx, fli_wkcProc) + ' = PS.' + CreateFld(tbInfo_Prod_Sched.pfx, fli_wkcProc) + ' ');
      SQL.Add( ' and AW.' + CreateFld(tbInfo_wkc_alt.pfx, fli_AlterWC) + ' = PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_wkCtrCode) + ')');

      if m_PropertiesUnscheduleList <> '' then
      begin
        SQL.Add(' union all ');
        SQL.Add('select distinct ');
        SQL.Add(QuotedStr('4') +' changetype ,');
        SQL.Add(CreateFld(tbInfo_Prod_Sched.pfx, fli_preqNo) + ',');
        SQL.Add(CreateFld(tbInfo_Prod_Sched.pfx, fli_pstepId));
        SQL.Add(' from ' + tbInfo_Prod_Sched.GetTableName + ' PS ');
        SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo_Prod_Sched.pfx, fli_Identifier)));
        SQL.Add(' and exists (select 1 from ' + tbInfo_Prod_Step.GetTableName + ' PD ');
        SQL.Add( ' where PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_IDENTIFIER) + ' = PS.' + CreateFld(tbInfo_Prod_Sched.pfx, fli_IDENTIFIER) + ' ');
        SQL.Add( ' and PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_preqNo) + ' = PS.' + CreateFld(tbInfo_Prod_Sched.pfx, fli_preqNo) + ' ');
        SQL.Add( ' and PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_pstepId) + ' = PS.' + CreateFld(tbInfo_Prod_Sched.pfx, fli_pstepId) + ' ');
        SQL.Add( ' and PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_wkCtrCode) + ' IN ' + '(' + WorkCentersHandledList + '))');
        SQL.Add(' and exists (select 1 from ' + tbInfo_Prop_prod.GetTableName + ' PP ');
        SQL.Add( ' where PS.' + CreateFld(tbInfo_Prod_Sched.pfx, fli_IDENTIFIER) + ' = PP.' + CreateFld(tbInfo_Prop_prod.pfx, fli_IDENTIFIER) + ' ');
        SQL.Add( ' and PS.' + CreateFld(tbInfo_Prod_Sched.pfx, fli_preqNo) + ' = PP.' + CreateFld(tbInfo_Prop_prod.pfx, fli_preqNo) + ' ');
        SQL.Add( ' and (PS.' + CreateFld(tbInfo_Prod_Sched.pfx, fli_pstepId) + ' = PP.' + CreateFld(tbInfo_Prop_prod.pfx, fli_pstepId) + ' or PP.' + CreateFld(tbInfo_Prop_prod.pfx, fli_pstepId) + ' = 0)' );
        SQL.Add( ' and PP.' + CreateFld(tbInfo_Prop_prod.pfx, fli_PropertyCode) + ' IN ' + '(' + m_PropertiesUnscheduleList + ')');
        SQL.Add( ' and PP.' + CreateFld(tbInfo_Prop_prod.pfx, fli_CrtOrUpdateDateTimeUTC) + ' > PS.' + CreateFld(tbInfo_Prod_Sched.pfx, fli_CrtOrUpdateDateTimeUTC) + ')');
      end;

    end
    else
    begin
      SQL.Add('select distinct ');
      SQL.Add(QuotedStr('1') +' changetype ,');
      SQL.Add(CreateFld(tbInfo_prod_sched_mcm.pfx, fli_preqNo) + ',');
      SQL.Add(CreateFld(tbInfo_prod_sched_mcm.pfx, fli_pstepId));
      SQL.Add(' from ' + tbInfo_prod_sched_mcm.GetTableName + ' MS ');
      SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo_prod_sched_mcm.pfx, fli_Identifier)));
      SQL.Add( ' and MS.' + CreateFld(tbInfo_prod_sched_mcm.pfx, fli_StepWorkCenter) + ' IN ' + '(' + WorkCentersHandledList + ')');
      SQL.Add( ' and not exists (select 1 from ' + tbInfo_Prod_Step.GetTableName + ' PD ');
      SQL.Add( ' where PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_IDENTIFIER) + ' = MS.' + CreateFld(tbInfo_prod_sched_mcm.pfx, fli_IDENTIFIER) + ' ');
      SQL.Add( ' and PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_preqNo) + ' = MS.' + CreateFld(tbInfo_prod_sched_mcm.pfx, fli_preqNo) + ' ');
      SQL.Add( ' and PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_pstepId) + ' = MS.' + CreateFld(tbInfo_prod_sched_mcm.pfx, fli_pstepId) + ')');
      SQL.Add( ' union all ');
      SQL.Add('select distinct ');
      SQL.Add(QuotedStr('2') +' changetype ,');
      SQL.Add(CreateFld(tbInfo_prod_sched_mcm.pfx, fli_preqNo) + ',');
      SQL.Add(CreateFld(tbInfo_prod_sched_mcm.pfx, fli_pstepId));
      SQL.Add(' from ' + tbInfo_prod_sched_mcm.GetTableName + ' MS ');
      SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo_prod_sched_mcm.pfx, fli_Identifier)));
      SQL.Add(' and exists (select 1 from ' + tbInfo_Prod_Step.GetTableName + ' PD ');
      SQL.Add( ' where PD. ' + CreateFld(tbInfo_Prod_Step.pfx, fli_IDENTIFIER) + ' = MS.' + CreateFld(tbInfo_prod_sched_mcm.pfx, fli_IDENTIFIER) + ' ');
      SQL.Add( ' and PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_preqNo) + ' = MS.' + CreateFld(tbInfo_prod_sched_mcm.pfx, fli_preqNo) + ' ');
      SQL.Add( ' and PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_pstepId) + ' = MS.' + CreateFld(tbInfo_prod_sched_mcm.pfx, fli_pstepId) + ' ');
      SQL.Add( ' and PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_wkCtrCode) + ' IN ' + '(' + WorkCentersHandledList + ')');
      SQL.Add( ' and (PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_quantInit) + ' = ' + '0' +  ' OR PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_quantFinl) + ' = ' + '0');
      SQL.Add(' OR (PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_StepType) + ' = ' + QuotedStr('B'));
      SQL.Add(' and MS.' + CreateFld(tbInfo_prod_sched_mcm.pfx, fli_StepType) + ' <> ' + QuotedStr('B') + ')');
      SQL.Add(' OR (PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_StepType) + ' <> ' + QuotedStr('B'));
      SQL.Add(' and MS.' + CreateFld(tbInfo_prod_sched_mcm.pfx, fli_StepType) + ' = ' + QuotedStr('B') + ')');
      SQL.Add(' OR (PD.' +  CreateFld(tbInfo_Prod_Step.pfx, fli_StepCanGroup) + ' = ' + '0' + ' and MS.' + CreateFld(tbInfo_prod_sched_mcm.pfx, fli_stGroup) + ' <> ' + QuotedStr('0') + ')');
      SQL.Add(' OR (PD.' +  CreateFld(tbInfo_Prod_Step.pfx, fli_ForcedGroupNo) + ' <> ' + '0' + ' and MS.' + CreateFld(tbInfo_prod_sched_mcm.pfx, fli_ForcedGroupNo) + ' = ' + QuotedStr('0') + ')');
      SQL.Add(' OR PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_SchedulByMqm) + ' = ' + QuotedStr('0') + '))');
      SQL.Add(' union all ');
      SQL.Add('select distinct ');
      SQL.Add(QuotedStr('3') +' changetype ,');
      SQL.Add(CreateFld(tbInfo_prod_sched_mcm.pfx, fli_preqNo) + ',');
      SQL.Add(CreateFld(tbInfo_prod_sched_mcm.pfx, fli_pstepId));
      SQL.Add(' from ' + tbInfo_prod_sched_mcm.GetTableName + ' MS ');
      SQL.Add(' join ' + tbInfo_Prod_Step.GetTableName + ' PD on ');
      SQL.Add(' PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_IDENTIFIER) + ' = MS.' + CreateFld(tbInfo_prod_sched_mcm.pfx, fli_IDENTIFIER));
      SQL.Add( ' and PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_preqNo) + ' = MS.' + CreateFld(tbInfo_prod_sched_mcm.pfx, fli_preqNo) + ' ');
      SQL.Add( ' and PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_pstepId) + ' = MS.' + CreateFld(tbInfo_prod_sched_mcm.pfx, fli_pstepId) + ' ');
      SQL.Add( ' and PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_wkCtrCode) + ' <> MS.' + CreateFld(tbInfo_prod_sched_mcm.pfx, fli_StepWorkCenter) + ' ');
      SQL.Add( 'and PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_wkCtrCode) + ' IN ' + '(' + WorkCentersHandledList + ')');
      SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo_prod_sched_mcm.pfx, fli_Identifier)));
      SQL.Add(' and not exists (select 1 from ' + tbInfo_wkc_alt.GetTableName + ' AW ');
      SQL.Add( ' where AW.' + CreateFld(tbInfo_wkc_alt.pfx, fli_IDENTIFIER) + ' = MS.' + CreateFld(tbInfo_prod_sched_mcm.pfx, fli_IDENTIFIER) + ' ');
      SQL.Add( ' and AW.' + CreateFld(tbInfo_wkc_alt.pfx, fli_wkCtrCode) + ' = MS.' + CreateFld(tbInfo_prod_sched_mcm.pfx, fli_StepWorkCenter) + ' ');
      SQL.Add( ' and AW.' + CreateFld(tbInfo_wkc_alt.pfx, fli_wkcProc) + ' = MS.' + CreateFld(tbInfo_prod_sched_mcm.pfx, fli_wkcProc) + ' ');
      SQL.Add( ' and AW.' + CreateFld(tbInfo_wkc_alt.pfx, fli_AlterWC) + ' = PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_wkCtrCode) + ')');

      if m_PropertiesUnscheduleList <> '' then
      begin
        SQL.Add(' union all ');
        SQL.Add('select distinct ');
        SQL.Add(QuotedStr('4') +' changetype ,');
        SQL.Add(CreateFld(tbInfo_prod_sched_mcm.pfx, fli_preqNo) + ',');
        SQL.Add(CreateFld(tbInfo_prod_sched_mcm.pfx, fli_pstepId));
        SQL.Add(' from ' + tbInfo_prod_sched_mcm.GetTableName + ' MS ');
        SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo_prod_sched_mcm.pfx, fli_Identifier)));
        SQL.Add(' and exists (select 1 from ' + tbInfo_Prod_Step.GetTableName + ' PD ');
        SQL.Add( ' where PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_IDENTIFIER) + ' = MS.' + CreateFld(tbInfo_prod_sched_mcm.pfx, fli_IDENTIFIER) + ' ');
        SQL.Add( ' and PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_preqNo) + ' = MS.' + CreateFld(tbInfo_prod_sched_mcm.pfx, fli_preqNo) + ' ');
        SQL.Add( ' and PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_pstepId) + ' = MS.' + CreateFld(tbInfo_prod_sched_mcm.pfx, fli_pstepId) + ' ');
        SQL.Add( ' and PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_wkCtrCode) + ' IN ' + '(' + WorkCentersHandledList + '))');
        SQL.Add(' and exists (select 1 from ' + tbInfo_Prop_prod.GetTableName + ' PP ');
        SQL.Add( ' where MS.' + CreateFld(tbInfo_prod_sched_mcm.pfx, fli_IDENTIFIER) + ' = PP.' + CreateFld(tbInfo_Prop_prod.pfx, fli_IDENTIFIER) + ' ');
        SQL.Add( ' and MS.' + CreateFld(tbInfo_prod_sched_mcm.pfx, fli_preqNo) + ' = PP.' + CreateFld(tbInfo_Prop_prod.pfx, fli_preqNo) + ' ');
        SQL.Add( ' and (MS.' + CreateFld(tbInfo_prod_sched_mcm.pfx, fli_pstepId) + ' = PP.' + CreateFld(tbInfo_Prop_prod.pfx, fli_pstepId) + ' or PP.' + CreateFld(tbInfo_Prop_prod.pfx, fli_pstepId) + ' = 0)' );
        SQL.Add( ' and PP.' + CreateFld(tbInfo_Prop_prod.pfx, fli_PropertyCode) + ' IN ' + '(' + m_PropertiesUnscheduleList + ')');
        SQL.Add( ' and PP.' + CreateFld(tbInfo_Prop_prod.pfx, fli_CrtOrUpdateDateTimeUTC) + ' > MS.' + CreateFld(tbInfo_prod_sched_mcm.pfx, fli_CrtOrUpdateDateTimeUTC) + ')');
      end;

    end;

    Open;

    List := TList.Create;
    while not eof do
    begin
      Application.ProcessMessages;
      if not DBAppGlobals.MCM_App then
         FindOrAddByRequestStep(List, FieldByName(CreateFld(tbInfo_Prod_Sched.pfx, fli_preqNo)).AsString,
                             FieldByName(CreateFld(tbInfo_Prod_Sched.pfx, fli_pstepId)).AsInteger,
                             FieldByName('changetype').AsString)
      else
         FindOrAddByRequestStep(List, FieldByName(CreateFld(tbInfo_Prod_Sched_mcm.pfx, fli_preqNo)).AsString,
                             FieldByName(CreateFld(tbInfo_Prod_Sched_mcm.pfx, fli_pstepId)).AsInteger,
                             FieldByName('changetype').AsString);
      Next;
    end;

  end;

  Qry.SQL.Clear;
  InitialSql := false;
  for I := 0 to List.Count - 1 do
  begin
    Application.ProcessMessages;
    if not InitialSql then
    begin
      InitialSql := true;
      qry.Transaction := CreateTransaction(Main_DB);
    end;

    Qry.SQL.Clear;
    qry.SQL.Add('Delete from ' + tbInfo_Prod_Sched.GetTableName);
    qry.SQL.Add(' where ');
    qry.SQL.Add(CreateFld(tbInfo_Prod_Sched.pfx, fli_IDENTIFIER)         + ' = ');
    qry.SQL.Add(':' + CreateFld(tbInfo_Prod_Sched.pfx, fli_IDENTIFIER)   + ' and ');
    qry.SQL.Add(CreateFld(tbInfo_Prod_Sched.pfx, fli_preqNo)         + ' = ');
    qry.SQL.Add(':' + CreateFld(tbInfo_Prod_Sched.pfx, fli_preqNo)   + ' and ');
    qry.SQL.Add(CreateFld(tbInfo_Prod_Sched.pfx, fli_pstepId)        + ' = ');
    qry.SQL.Add(':' + CreateFld(tbInfo_Prod_Sched.pfx, fli_pstepId));

    Qry.Transaction.StartTransaction;

    qry.ParamByName(CreateFld(tbInfo_Prod_Sched.pfx, fli_IDENTIFIER)).AsString := IniAppGlobals.Identifier;
    qry.ParamByName(CreateFld(tbInfo_Prod_Sched.pfx, fli_preqNo)).AsString    := PTReqChange(List[i]).Request;
    qry.ParamByName(CreateFld(tbInfo_Prod_Sched.pfx, fli_pstepId)).AsInteger  := PTReqChange(List[i]).Step;
    qry.ExecSQL;

    TypeOfChange := 'Initial';
    if PTReqChange(List[i]).TypeOfChange = '1' then
       TypeOfChange := 'Step or request deleted'
    else if PTReqChange(List[i]).TypeOfChange = '2' then
       TypeOfChange := 'step changed'
    else if PTReqChange(List[i]).TypeOfChange = '3' then
       TypeOfChange := 'Work center changed to not alternative'
    else if PTReqChange(List[i]).TypeOfChange = '4' then
       TypeOfChange := 'Prop changed';
                                                       // PTReqChange(List[i]).substep, PTReqChange(List[i]).reprocess
    WriteLogLineToDB(qry, 'X', PTReqChange(List[i]).Request, PTReqChange(List[i]).Step , -1, -1,
                     'Dlt', '' ,'' , 0, 0, -1, '', TypeOfChange);
    qry.Transaction.Commit;
  end;


  for I := List.Count - 1 downto 0 do
     dispose(PTReqChange(List[I]));
  List.Clear;
  List.Free;
end;

//----------------------------------------------------------------------------//

procedure ExternalDB_DeleteAll_Req_change_OnMystation;
var
  tblInfo_Req_Change : ^TTblInfo;
  Qry : TMqmQuery;
begin
  Qry := CreateQuery(Main_DB);
  Qry.Transaction := CreateTransaction(Main_DB);
  Qry.Transaction.StartTransaction;

  tblInfo_Req_Change := @tblInfo[tbl_Req_Change];
  with qry do
  begin
    SQL.Clear;
    SQL.Add('delete ');
    SQL.Add('from ' + tblInfo_Req_Change.GetTableName);
    SQL.Add(' Where ' + CreateFld(tblInfo_Req_Change.pfx, fli_wkstCode) + '=''' + IniAppGlobals.WkstCode + '''');
    SQL.Add(' AND ' + CreateFld(tblInfo_Req_Change.pfx, fli_preqNo) + '<>' + QuotedStr('_ _'));
    SQL.Add(AND_IDF_Condition(CreateFld(tblInfo_Req_Change.pfx, fli_Identifier)));
    ExecSQL;
    qry.Transaction.Commit;
  end;
  qry.Free;

end;

//----------------------------------------------------------------------------//

procedure ExternalDB_LoadAllStepsAndRequestsOnMyStation;
var
  tblInfo_Req_Hdr, tbInfo_Prod_Step, tbInfo_WW  : ^TTblInfo;
  CurrentSteps : PTCurrentSteps;
  Qry : TMqmQuery;
  PREQ_NO, STEP_ID, CrtUTC, QtyInit,QtyFinal, StepCanGroup, ForcedGroupNo, StepType, WkctrCode, WkcProc,
  ClosedStep, SchedulByMcm, SchedulByMQM,
  UpdUTC : TField;
begin
  Qry := CreateQuery(Main_DB);
  Qry.Transaction := CreateTransaction(Main_DB);
  Qry.Transaction.StartTransaction;
  tblInfo_Req_Hdr   := @tblInfo[tbl_prod_reqHdr];
  tbInfo_Prod_Step  := @tblInfo[tbl_prod_step];
  tbInfo_WW := @tblInfo[tbl_wkst_wkc];
//  m_CurrentStepsList := TList.Create;
  ExternalDB_ClearCurrentStepsList;
  IniAppGlobals.RefreshUTCNew := UTCNow;

  with qry do
  begin
    SQL.Clear;
    SQL.Add(' Select ' );
    SQL.Add(CreateFld(tbInfo_Prod_Step.pfx, fli_preqNo)         + ' Request,');
    SQL.Add(CreateFld(tbInfo_Prod_Step.pfx, fli_pstepId)        + ' Step,');
    SQL.Add(CreateFld(tblInfo_Req_Hdr.pfx,  fli_CrtOrUpdateDateTimeUTC) + ' HdrUTC, ');
    SQL.Add(CreateFld(tbInfo_Prod_Step.pfx, fli_quantInit)        + ',');
    SQL.Add(CreateFld(tbInfo_Prod_Step.pfx, fli_quantFinl)        + ',');
    SQL.Add(CreateFld(tbInfo_Prod_Step.pfx, fli_StepCanGroup)     + ',');
    SQL.Add(CreateFld(tbInfo_Prod_Step.pfx, fli_ForcedGroupNo)    + ',');
    SQL.Add(CreateFld(tbInfo_Prod_Step.pfx, fli_StepType)         + ',');
    SQL.Add(CreateFld(tbInfo_Prod_Step.pfx, fli_wkCtrCode)        + ',');
    SQL.Add(CreateFld(tbInfo_Prod_Step.pfx, fli_wkcProc)          + ',');
    SQL.Add(CreateFld(tbInfo_Prod_Step.pfx, fli_StepClosed)       + ',');
    SQL.Add(CreateFld(tbInfo_Prod_Step.pfx, fli_SchedulByMcm)     + ',');
    SQL.Add(CreateFld(tbInfo_Prod_Step.pfx, fli_SchedulByMqm)     + ',');
    SQL.Add(CreateFld(tbInfo_Prod_Step.pfx, fli_CrtOrUpdateDateTimeUTC) + ' StepUTC ');
    SQL.Add(' from ' + tbInfo_Prod_Step.GetTableName + ' PD ');
    SQL.Add(' join ' + tblInfo_Req_Hdr.GetTableName + ' PH on ');
    SQL.Add(' PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_preqNo) + '=' + ' PH.' + CreateFld(tblInfo_Req_Hdr.pfx, fli_preqNo));
    SQL.Add(' AND PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_Identifier) + '=' + ' PH.' + CreateFld(tblInfo_Req_Hdr.pfx, fli_Identifier));
    SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo_Prod_Step.pfx, fli_Identifier)));
    SQL.Add(' and PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_wkCtrCode) + ' IN ' + '(' + m_WorkCentersHandledAndViewList + ')');
    if DBAppGlobals.MCM_App then
      SQL.Add(' AND PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_SchedulByMcm) + ' = ' + QuotedStr('1'))
    else
      SQL.Add(' AND PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_SchedulByMqm) + ' = ' + QuotedStr('1'));

    SQL.Add(' Order by Request, Step');
    Open;

    PREQ_NO  := FieldByName('Request');
    STEP_ID := FieldByName('Step');
    CrtUTC := FieldByName('HdrUTC');
    QtyInit := FieldByName(CreateFld(tbInfo_Prod_Step.pfx, fli_quantInit));
    QtyFinal := FieldByName(CreateFld(tbInfo_Prod_Step.pfx, fli_quantFinl));
    StepCanGroup := FieldByName(CreateFld(tbInfo_Prod_Step.pfx, fli_StepCanGroup));
    ForcedGroupNo := FieldByName(CreateFld(tbInfo_Prod_Step.pfx, fli_ForcedGroupNo));
    StepType := FieldByName(CreateFld(tbInfo_Prod_Step.pfx, fli_StepType));
    WkctrCode := FieldByName(CreateFld(tbInfo_Prod_Step.pfx, fli_wkCtrCode));
    WkcProc := FieldByName(CreateFld(tbInfo_Prod_Step.pfx, fli_wkcProc));
    ClosedStep := FieldByName(CreateFld(tbInfo_Prod_Step.pfx, fli_StepClosed));
    SchedulByMcm := FieldByName(CreateFld(tbInfo_Prod_Step.pfx, fli_SchedulByMcm));
    SchedulByMQM := FieldByName(CreateFld(tbInfo_Prod_Step.pfx, fli_SchedulByMqm));
    UpdUTC := FieldByName('StepUTC');

    while not EOF do
    begin
      new(CurrentSteps);
      CurrentSteps.Request := PREQ_NO.asString;
     // if CurrentSteps.Request = '001PROD    000061538' then
     //     CurrentSteps.Request := '001PROD    000061538';
      CurrentSteps.Step    := STEP_ID.Asinteger;
      CurrentSteps.Hdr_UTC := CrtUTC.AsDatetime;
      CurrentSteps.Init_Quent := QtyInit.AsFloat;
      CurrentSteps.Fin_Quent  := QtyFinal.AsFloat;

      if (StepCanGroup.AsString = '1') or (StepCanGroup.AsString = '2') then
        CurrentSteps.Step_Can_Group := true
      else
        CurrentSteps.Step_Can_Group := false;

      CurrentSteps.Forced_Grp_No  := ForcedGroupNo.Asinteger;
      CurrentSteps.Step_Type      := StepType.AsString;
      CurrentSteps.Workcenter := WkctrCode.AsString;
      CurrentSteps.process := WkcProc.AsString;

      CurrentSteps.IsStepClosed := false;
      if ClosedStep.AsString = '1' then
        CurrentSteps.IsStepClosed := true;

      CurrentSteps.Sched_Mcm := false;
      CurrentSteps.Sched_Mqm := false;
      if DBAppGlobals.MCM_App then
      begin
        if SchedulByMcm.AsString = '1' then
          CurrentSteps.Sched_Mcm := true
        else
          CurrentSteps.Sched_Mcm := false;
      end
      else
      begin
        if SchedulByMQM.AsString = '1' then
          CurrentSteps.Sched_Mqm := true
        else
          CurrentSteps.Sched_Mqm := false;
      end;

      CurrentSteps.Step_UTC := UpdUTC.AsDatetime;
      CurrentSteps.RequestFound := false;
      CurrentSteps.StepFound    := false;

      m_CurrentStepsList.Add(CurrentSteps);
      Next
    end;
  end;
  Qry.Transaction.Commit;
  Qry.free;
  m_CurrentStepsList.Sort(SortCurrentSteps);
end;

//----------------------------------------------------------------------------//

function ExternalDB_LoopAllRequestHeaderFromPlan : boolean;
var
  prodReqList : TList;
  I, J, P, Ps, Pos, PosStep, PosReq, Wc, ProcIndex, NextUpdatedNumber, NewNextUpdatedNumber : integer;
  HdrCode, OldHdrCode : String;
  ProdReqHdr  : TSCProdReqHdr;
  CurrentStep : PTCurrentSteps;
  job : TSCProdSched;
  ReqChange   : PTReqChange;
  FoundStep, FounddifferentWc, IsStep_0 : boolean;
  tDet        : TSCProdReqDet;
  Process     : string;
  WrkCtr, AltWc : TMqmWrkCtr;
  AltProc, Request : string;
  STEP : Integer;
  tbInfo_Req_change, tblInfo_PropProd, tbInfo_Prod_Step, tbInfo_Material,
  tblInfo_prod_reqConnection, tblInfo_sched_progress, tblInfo_step_batchSize,
  tblInfo_step_times, tblInfo_produced_article : ^TTblInfo;
  Qry : TMqmQuery;
  PropIPJob : TPropID;
  propVal: variant;
  FoundNotDeletedRequest, FoundNotDeletedStep, ContinueLoop : boolean;
  NewRequestChangeList : TStringList;
begin
  Result := false; // need to set true when change was found
  prodReqList := p_sc.P_GetprodReqList;

  for I := 0 to prodReqList.Count - 1 do
  begin
    ProdReqHdr := TSCProdReqHdr(prodReqList[i]);

    FoundNotDeletedRequest := false;
    for j := 0 to ProdReqHdr.m_list.Count - 1 do
    begin
      tDet := TSCProdReqDet(ProdReqHdr.m_list[j]);
      for Ps := 0 to tDet.m_list.Count - 1 do
      begin
        Job := TSCProdSched(tDet.m_list[Ps]);
        if Job.m_isDeleted then
           Continue;
        FoundNotDeletedRequest := true;
        break
      end;
    end;

    HdrCode := TSCProdReqHdr(prodReqList[i]).m_code;

    Pos := FindHdrFromCode(true, m_CurrentStepsList, HdrCode);

    if Pos > -1 then
    begin
      PTCurrentSteps(m_CurrentStepsList[Pos]).RequestFound := true;
      if not FoundNotDeletedRequest then
         PTCurrentSteps(m_CurrentStepsList[Pos]).RequestFound := false;
    end;

    if Pos > -1 then
    begin
      PosStep := Pos;
      while (PosStep - 1 >= 0) and (PTCurrentSteps(m_CurrentStepsList[PosStep - 1]).Request = HdrCode) do
      begin
        PTCurrentSteps(m_CurrentStepsList[PosStep - 1]).RequestFound := true;
        Dec(PosStep);
      end;
      Pos := PosStep;
    end;

    if (Pos = -1) and FoundNotDeletedRequest then
    begin
      new(ReqChange);
      ReqChange.Request := HdrCode;
      ReqChange.Step    := 0;
      ReqChange.TypeOfChange := '4';  //DeletedRequest
      m_ReqChangeList.Add(ReqChange);
      Continue
    end

    else if Pos >= 0 then
    begin
         // Put in the first step - RequestFound = true.
      if FoundNotDeletedRequest then
        PTCurrentSteps(m_CurrentStepsList[Pos]).RequestFound := true;

      PosReq := Pos;
      PosReq := PosReq + 1;
      while (PosReq <= m_CurrentStepsList.Count - 1) and (PTCurrentSteps(m_CurrentStepsList[PosReq]).Request = HdrCode) do
      begin
        if FoundNotDeletedRequest then
          PTCurrentSteps(m_CurrentStepsList[PosReq]).RequestFound := true;
        inc(PosReq);
      end;

      if PTCurrentSteps(m_CurrentStepsList[Pos]).Hdr_UTC > IniAppGlobals.RefreshUTC then
      begin
        new(ReqChange);
        ReqChange.Request := HdrCode;
        ReqChange.Step    := 0;
        ReqChange.TypeOfChange := '7';  // HeaderCosmeticChange
        m_ReqChangeList.Add(ReqChange);
        PTCurrentSteps(m_CurrentStepsList[Pos]).StepFound := true;
        Continue
      end;

      ProdReqHdr := TSCProdReqHdr(prodReqList[i]);

      for j := 0 to ProdReqHdr.m_list.Count - 1 do
      begin
        FoundStep := false;
        Pos := PosStep;
        tDet := TSCProdReqDet(ProdReqHdr.m_list[j]);

        FoundNotDeletedStep := false;
        for Ps := 0 to tDet.m_list.Count - 1 do
        begin
          Job := TSCProdSched(tDet.m_list[Ps]);
          if Job.m_isDeleted then
          begin
             Continue;
          end;
          FoundNotDeletedStep := true;
          break
        end;

        while (Pos >= 0) and (pos <= m_CurrentStepsList.Count - 1) and (PTCurrentSteps(m_CurrentStepsList[Pos]).Request = ProdReqHdr.m_code) do
        begin
          PTCurrentSteps(m_CurrentStepsList[Pos]).RequestFound := true;
          if (tDet.m_Code = PTCurrentSteps(m_CurrentStepsList[Pos]).Step) then
          begin
            FoundStep := true;
            break
          end;

          if ((Pos + 1) >= 0) and ((pos + 1) <= m_CurrentStepsList.Count - 1) and (PTCurrentSteps(m_CurrentStepsList[Pos + 1]).Request = ProdReqHdr.m_code) then
            Inc(Pos)
          else

          if pos = m_CurrentStepsList.Count - 1 then
          begin
            if (tDet.m_Code = PTCurrentSteps(m_CurrentStepsList[Pos]).Step) and
                (PTCurrentSteps(m_CurrentStepsList[Pos]).Request = ProdReqHdr.m_code) then
              FoundStep := true;
            break
          end

          else break;

        end;

        if not FoundStep and FoundNotDeletedStep then
        begin
          new(ReqChange);
          ReqChange.Request := ProdReqHdr.m_code;
          ReqChange.Step    := tDet.m_Code;
          ReqChange.TypeOfChange := '3';  // DeletedStep
          m_ReqChangeList.Add(ReqChange);
          continue
        end;

        if not FoundStep then continue;

        // step found
        PTCurrentSteps(m_CurrentStepsList[Pos]).StepFound := true;

        // check condition
        if ((PTCurrentSteps(m_CurrentStepsList[Pos]).Init_Quent <> tDet.m_quantInit) or
           (PTCurrentSteps(m_CurrentStepsList[Pos]).Fin_Quent <> tDet.m_quantFinl)) and
           ((PTCurrentSteps(m_CurrentStepsList[Pos]).Init_Quent = 0) or
           (PTCurrentSteps(m_CurrentStepsList[Pos]).Fin_Quent = 0)) then
        begin
          new(ReqChange);
          ReqChange.Request := ProdReqHdr.m_code;
          ReqChange.Step    := tDet.m_code;
          ReqChange.TypeOfChange := '4';  //StepFieldChange
          m_ReqChangeList.Add(ReqChange);
          Continue
        end;

        if ((PTCurrentSteps(m_CurrentStepsList[Pos]).Step_Type = 'B') and (tDet.m_stepType <> CST_batch)) or
           ((PTCurrentSteps(m_CurrentStepsList[Pos]).Step_Type <> 'B') and (tDet.m_stepType = CST_batch)) then
        begin
          new(ReqChange);
          ReqChange.Request := ProdReqHdr.m_code;
          ReqChange.Step    := tDet.m_code;
          ReqChange.TypeOfChange := '4';  //StepFieldChange
          m_ReqChangeList.Add(ReqChange);
          Continue
        end;

        if (not PTCurrentSteps(m_CurrentStepsList[Pos]).Step_Can_Group) and (tDet.m_CanGroup <> '0') then
        begin
          new(ReqChange);
          ReqChange.Request := ProdReqHdr.m_code;
          ReqChange.Step    := tDet.m_code;
          ReqChange.TypeOfChange := '4';  //StepFieldChange
          m_ReqChangeList.Add(ReqChange);
          Continue
        end;
        if PTCurrentSteps(m_CurrentStepsList[Pos]).Forced_Grp_No <> tDet.m_forcedGrpNo then
        begin
          new(ReqChange);
          ReqChange.Request := ProdReqHdr.m_code;
          ReqChange.Step    := tDet.m_code;
          ReqChange.TypeOfChange := '4';  //StepFieldChange
          m_ReqChangeList.Add(ReqChange);
          Continue
        end;

        FounddifferentWc := false;
        if (PTCurrentSteps(m_CurrentStepsList[Pos]).Workcenter <> tDet.m_planWkctr) then
        begin
          FounddifferentWc := true;
          WrkCtr := TMqmWrkCtr(p_pl.FindWrkCtrByCode(tDet.m_planWkctr));

          if Assigned(WrkCtr) then
          begin
            for Wc := 0 to WrkCtr.P_GetProccesCount -1 do
            begin
              Process := WrkCtr.P_GetProcess[Wc];
              for ProcIndex := 0 to WrkCtr.P_WkcProcList.P_GetAltProcListCount[Process] - 1  do
              begin
                AltWc := WrkCtr.P_WkcProcList.GetAltProcList(Process,false).P_GetAltWc[ProcIndex];
                WrkCtr.GetAltProcForAltWrkCtr(Process, AltWc.p_WrkCtrCode , AltProc);
                if (PTCurrentSteps(m_CurrentStepsList[Pos]).Workcenter = AltWc.p_WrkCtrCode) and
                   (PTCurrentSteps(m_CurrentStepsList[Pos]).process = AltProc) then
                begin
                  FounddifferentWc := false;
                  break
                end;

              end;
            end;
          end;

        end;

        if FounddifferentWc then
        begin
          new(ReqChange);
          ReqChange.Request := ProdReqHdr.m_code;
          ReqChange.Step    := tDet.m_code;
          ReqChange.TypeOfChange := '4';  //StepFieldChange
          m_ReqChangeList.Add(ReqChange);
          Continue
        end;

        if (DBAppGlobals.MCM_App) then
        begin
          if PTCurrentSteps(m_CurrentStepsList[Pos]).Sched_Mcm <> (tDet.m_StepToSched) then
          begin
            new(ReqChange);
            ReqChange.Request := ProdReqHdr.m_code;
            ReqChange.Step    := tDet.m_code;
            ReqChange.TypeOfChange := '4';  //StepFieldChange
            m_ReqChangeList.Add(ReqChange);
            Continue
          end;
        end
        else if PTCurrentSteps(m_CurrentStepsList[Pos]).Sched_Mqm <> (tDet.m_StepToSched) then
        begin
          new(ReqChange);
          ReqChange.Request := ProdReqHdr.m_code;
          ReqChange.Step    := tDet.m_code;
          ReqChange.TypeOfChange := '4';  //StepFieldChange
          m_ReqChangeList.Add(ReqChange);
          Continue
        end;

        if PTCurrentSteps(m_CurrentStepsList[Pos]).Step_UTC > IniAppGlobals.RefreshUTC then
        begin
          new(ReqChange);
          ReqChange.Request := ProdReqHdr.m_code;
          ReqChange.Step    := tDet.m_code;
          ReqChange.TypeOfChange := '6';  //StepCosmeticChange
          m_ReqChangeList.Add(ReqChange);
          Continue
        end;

      end;

    end;

  end;

  OldHdrCode := '';

  for I := 0 to m_CurrentStepsList.Count - 1 do
  begin
    HdrCode := PTCurrentSteps(m_CurrentStepsList[I]).Request;

    if (not PTCurrentSteps(m_CurrentStepsList[I]).RequestFound) and not (PTCurrentSteps(m_CurrentStepsList[I]).IsStepClosed) then
    begin
      new(ReqChange);
      ReqChange.Request := HdrCode;
      ReqChange.Step    := 0;
      ReqChange.TypeOfChange := '2';  //NewRequest
      m_ReqChangeList.Add(ReqChange);
      Continue
    end;

    if not PTCurrentSteps(m_CurrentStepsList[I]).StepFound then
    begin
      new(ReqChange);
      ReqChange.Request := HdrCode;
      ReqChange.Step    := PTCurrentSteps(m_CurrentStepsList[I]).Step;
      ReqChange.TypeOfChange := '2';  //Newstep
      m_ReqChangeList.Add(ReqChange);
      Continue
    end
  end;

  Qry := CreateQuery(Main_DB);
  Qry.Transaction := CreateTransaction(Main_DB);
  Qry.Transaction.StartTransaction;
  tblInfo_PropProd := @tblInfo[tbl_prop_prod];
  tbInfo_Prod_Step := @tblInfo[tbl_prod_step];

  if m_PropertiesUnscheduleList <> '' then
  begin
    with qry do
    begin
      SQL.Clear;
      SQL.Add('select distinct PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_preqNo) + ' Request ');
      SQL.Add(', PP.' + CreateFld(tblInfo_PropProd.pfx, fli_pstepId) + ' Step ');
      SQL.Add('from ');
      SQL.Add(tbInfo_Prod_Step.GetTableName + ' PD ');
      SQL.Add(' join ' + tblInfo_PropProd.GetTableName + ' PP on ');
      SQL.Add(' PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_IDENTIFIER) + ' = PP.' + CreateFld(tblInfo_PropProd.pfx, fli_IDENTIFIER));
      SQL.Add( ' and PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_preqNo) + ' = PP.' + CreateFld(tblInfo_PropProd.pfx, fli_preqNo) + ' ');
      SQL.Add( ' and (PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_pstepId) + ' = PP.' + CreateFld(tblInfo_PropProd.pfx, fli_pstepId) + ' ');
      SQL.Add( ' Or PP.' + CreateFld(tblInfo_PropProd.pfx, fli_pstepId) + ' = ' + IntTostr(0) + ')');
      SQL.Add( ' and PP.' + CreateFld(tblInfo_PropProd.pfx, fli_PropertyCode) + ' IN ' + '(' + m_PropertiesUnscheduleList + ')');
      SQL.Add( ' and PP.' + CreateFld(tblInfo_PropProd.pfx, fli_CrtOrUpdateDateTimeUTC) + ' > ' + ConvertDateFormatMQM(IniAppGlobals.RefreshUTC));
      SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo_Prod_Step.pfx, fli_Identifier)));
      SQL.Add(' and PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_wkCtrCode) + ' IN ' + '(' + m_WorkCentersHandledAndViewList + ')');
      SQL.Add(' Order by Request, Step');
      Open;
      Request := '';
      STEP := -1;
      IsStep_0 := false;
      while not Eof do
      begin
        if IsStep_0 then
        begin
          while (not Eof) and (Request = qry.FieldByName('Request').AsString) do
            Next;
          if Eof then break;
        end;
        Request  := qry.FieldByName('Request').AsString;
        STEP     := qry.FieldByName('STEP').AsInteger;
        IsStep_0 := false;
        new(ReqChange);
        ReqChange.Request := Request;
        ReqChange.Step    := STEP;
        m_ReqChangeList.Add(ReqChange);
        if STEP = 0 then
        begin
          IsStep_0 := true;
          ReqChange.TypeOfChange := '6'; // HeaderPropertyChange
        end
        else
          ReqChange.TypeOfChange := '5'; // StepPropertyChange
        next;
      end;
    end;

  end;
  qry.Transaction.Commit;

  Qry.Transaction.StartTransaction;
  tbInfo_Material := @tblInfo[tbl_material];
  tblInfo_prod_reqConnection := @tblInfo[tbl_prod_reqConnection];
  tblInfo_sched_progress     := @tblInfo[tbl_sched_progress];
  tblInfo_step_batchSize     := @tblInfo[tbl_step_batchSize];
  tblInfo_step_times         := @tblInfo[tbl_step_times];
  tblInfo_produced_article   := @tblInfo[tbl_produced_article];

  with qry do
  begin
    SQL.Clear;
    SQL.Add('select distinct PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_preqNo) + ' Request ');
    SQL.Add('from ');
    SQL.Add(tbInfo_Prod_Step.GetTableName + ' PD ');
    SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo_Prod_Step.pfx, fli_Identifier)));
    SQL.Add(' and PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_wkCtrCode) + ' IN ' + '(' + m_WorkCentersHandledAndViewList + ')');
  //  SQL.Add(' and (PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_wkCtrCode) + ' IN ' + '(' + m_WorkCentersHandledList + ')');
  //  SQL.Add(' Or PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_wkCtrCode) + ' IN ' + '(' + m_WorkCentersViewedList + ')' + ')');
    SQL.Add( ' and ((exists (select 1 from ' + tbInfo_Material.GetTableName + ' MT ');
    SQL.Add( ' where PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_IDENTIFIER) + ' = MT.' + CreateFld(tbInfo_Material.pfx, fli_IDENTIFIER) + ' ');
    SQL.Add( ' and PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_preqNo) + ' = MT.' + CreateFld(tbInfo_Material.pfx, fli_preqNo) + ' ');
    SQL.Add( ' and MT.' + CreateFld(tbInfo_Material.pfx, fli_CrtOrUpdateDateTimeUTC) + ' > ' + ConvertDateFormatMQM(IniAppGlobals.RefreshUTC) + '))');

    SQL.Add( ' or (exists (select 1 from ' + tblInfo_prod_reqConnection.GetTableName + ' RC ');
    SQL.Add( ' where PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_IDENTIFIER) + ' = RC.' + CreateFld(tblInfo_prod_reqConnection.pfx, fli_IDENTIFIER) + ' ');
    SQL.Add( ' and PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_preqNo) + ' = RC.' + CreateFld(tblInfo_prod_reqConnection.pfx, fli_preqNo) + ' ');
    SQL.Add( ' and RC.' + CreateFld(tblInfo_prod_reqConnection.pfx, fli_CrtOrUpdateDateTimeUTC) + ' > ' + ConvertDateFormatMQM(IniAppGlobals.RefreshUTC) + '))');

    SQL.Add( ' or (exists (select 1 from ' + tblInfo_sched_progress.GetTableName + ' SP ');
    SQL.Add( ' where PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_IDENTIFIER) + ' = SP.' + CreateFld(tblInfo_sched_progress.pfx, fli_IDENTIFIER) + ' ');
    SQL.Add( ' and PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_preqNo) + ' = SP.' + CreateFld(tblInfo_sched_progress.pfx, fli_preqNo) + ' ');
    SQL.Add( ' and SP.' + CreateFld(tblInfo_sched_progress.pfx, fli_CrtOrUpdateDateTimeUTC) + ' > ' + ConvertDateFormatMQM(IniAppGlobals.RefreshUTC) + '))');

 {   SQL.Add( ' or (exists (select 1 from ' + tblInfo_step_batchSize.GetTableName + ' SB ');
    SQL.Add( ' where PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_IDENTIFIER) + ' = SB.' + CreateFld(tblInfo_step_batchSize.pfx, fli_IDENTIFIER) + ' ');
    SQL.Add( ' and PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_preqNo) + ' = SB.' + CreateFld(tblInfo_step_batchSize.pfx, fli_preqNo) + ' ');
    SQL.Add( ' and SB.' + CreateFld(tblInfo_step_batchSize.pfx, fli_CrtOrUpdateDateTimeUTC) + ' > ' + ConvertDateFormatMQM(UTCNow) + '))');  }

    SQL.Add( ' or (exists (select 1 from ' + tblInfo_step_times.GetTableName + ' ST ');
    SQL.Add( ' where PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_IDENTIFIER) + ' = ST.' + CreateFld(tblInfo_step_times.pfx, fli_IDENTIFIER) + ' ');
    SQL.Add( ' and PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_preqNo) + ' = ST.' + CreateFld(tblInfo_step_times.pfx, fli_preqNo) + ' ');
    SQL.Add( ' and ST.' + CreateFld(tblInfo_step_times.pfx, fli_CrtOrUpdateDateTimeUTC) + ' > ' + ConvertDateFormatMQM(IniAppGlobals.RefreshUTC) + '))');

    SQL.Add( ' or (exists (select 1 from ' + tblInfo_produced_article.GetTableName + ' PA ');
    SQL.Add( ' where PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_IDENTIFIER) + ' = PA.' + CreateFld(tblInfo_produced_article.pfx, fli_IDENTIFIER) + ' ');
    SQL.Add( ' and PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_preqNo) + ' = PA.' + CreateFld(tblInfo_produced_article.pfx, fli_preqNo) + ' ');
    SQL.Add( ' and PA.' + CreateFld(tblInfo_produced_article.pfx, fli_CrtOrUpdateDateTimeUTC) + ' > ' + ConvertDateFormatMQM(IniAppGlobals.RefreshUTC) + ')))');

    open;

    while not EOF do
    begin
      Request := qry.FieldByName('Request').AsString;
      if not CheckIfRequestInChangedList(Request) then
      begin
        new(ReqChange);
        ReqChange.Request := Request;
        ReqChange.Step    := 0;
        ReqChange.TypeOfChange := '7'; // HeaderCosmeticChange
        m_ReqChangeList.Add(ReqChange);
      end;
      next;
    end;
  end;

  qry.Transaction.Commit;

  ContinueLoop := true;
  NewNextUpdatedNumber := -1;

  DBAppGlobals.LastUpdatNr := -1;

  if m_ReqChangeList.Count > 0 then
  begin

    NextUpdatedNumber := ExternalDB_GetLastUpdatedNumber_OnMystation;

    while ContinueLoop do
    begin
      Result := true;
      if NewNextUpdatedNumber > -1 then
         NextUpdatedNumber := NewNextUpdatedNumber;

      NewRequestChangeList := TStringList.Create;
      NewRequestChangeList.Sorted := true;
      tbInfo_Req_change := @tblInfo[tbl_Req_Change];
      Qry.Transaction := CreateTransaction(Main_DB);
      qry.Transaction.StartTransaction;

      with Qry do
      begin
        SQL.Clear;
        SQL.Add(' Select * from ' + tbInfo_Req_change.GetTableName);
        SQL.Add(' Where ' + CreateFld(tbInfo_Req_change.pfx, fli_wkstCode) + '=''' + IniAppGlobals.WkstCode + '''');
        SQL.Add(' AND ' + CreateFld(tbInfo_Req_change.pfx, fli_preqNo) + '=' + QuotedStr('_ _'));
        SQL.Add(AND_IDF_Condition(CreateFld(tbInfo_Req_change.pfx, fli_Identifier)));
        Open;
        if Eof then
        begin
          SQL.Clear;
          SQL.Add('insert into ' + tbInfo_Req_change.GetTableName  + '(');
          SQL.Add(CreateFld(tbInfo_Req_change.pfx, fli_IDENTIFIER)       + ',');
          SQL.Add(CreateFld(tbInfo_Req_change.pfx, fli_wkstCode)       + ',');
          SQL.Add(CreateFld(tbInfo_Req_change.pfx, fli_preqNo)           + ',');
          SQL.Add(CreateFld(tbInfo_Req_change.pfx, fli_pstepId)          + ',');
          SQL.Add(CreateFld(tbInfo_Req_change.pfx, fli_updCode)          + ',');
          SQL.Add(CreateFld(tbInfo_Req_change.pfx, fli_ChangeType)       + ',');
          SQL.Add(CreateFld(tbInfo_Req_change.pfx, fli_ReactivateReq));
          SQL.Add(') values (');
          SQL.Add(':' + CreateFld(tbInfo_Req_change.pfx, fli_IDENTIFIER) + ',');
          SQL.Add(':' + CreateFld(tbInfo_Req_change.pfx, fli_wkstCode)   + ',');
          SQL.Add(':' + CreateFld(tbInfo_Req_change.pfx, fli_preqNo)     + ',');
          SQL.Add(':' + CreateFld(tbInfo_Req_change.pfx, fli_pstepId)    + ',');
          SQL.Add(':' + CreateFld(tbInfo_Req_change.pfx, fli_updCode)    + ',');
          SQL.Add(':' + CreateFld(tbInfo_Req_change.pfx, fli_ChangeType) + ',');
          SQL.Add(':' + CreateFld(tbInfo_Req_change.pfx, fli_ReactivateReq));
          SQL.Add(')');

          Qry.ParamByName(CreateFld(tbInfo_Req_change.pfx, fli_IDENTIFIER)).Value := IniAppGlobals.Identifier;
          Qry.ParamByName(CreateFld(tbInfo_Req_change.pfx, fli_wkstCode)).Value := IniAppGlobals.WkstCode;
          Qry.ParamByName(CreateFld(tbInfo_Req_change.pfx, fli_preqNo)).Value := '_ _';
          Qry.ParamByName(CreateFld(tbInfo_Req_change.pfx, fli_pstepId)).Value := 0;
          Qry.ParamByName(CreateFld(tbInfo_Req_change.pfx, fli_updCode)).Value := NextUpdatedNumber;
          Qry.ParamByName(CreateFld(tbInfo_Req_change.pfx, fli_ChangeType)).Value := 'X';
          Qry.ParamByName(CreateFld(tbInfo_Req_change.pfx, fli_ReactivateReq)).Value := '';
          try
            Qry.ExecSQL;
          except

            on E: Exception do
            begin
              if (System.Pos('UNIQUE KEY', E.Message) > 0) or (System.Pos('PRIMARY ', E.Message) > 0) or (System.Pos('constraint ', E.Message) > 0) or
                  (System.Pos('primary key ', E.Message) > 0) or (System.Pos('duplicate values', E.Message) > 0) then
              begin
                NewNextUpdatedNumber := NextUpdatedNumber + 1;
                ContinueLoop := true;
                continue
              end
            end;

          end;

        end;

      end;

      with Qry do
      begin
        SQL.Clear;
        SQL.Add('insert into ' + tbInfo_Req_change.GetTableName  + '(');
        SQL.Add(CreateFld(tbInfo_Req_change.pfx, fli_IDENTIFIER)       + ',');
        SQL.Add(CreateFld(tbInfo_Req_change.pfx, fli_wkstCode)       + ',');
        SQL.Add(CreateFld(tbInfo_Req_change.pfx, fli_preqNo)           + ',');
        SQL.Add(CreateFld(tbInfo_Req_change.pfx, fli_pstepId)          + ',');
        SQL.Add(CreateFld(tbInfo_Req_change.pfx, fli_updCode)          + ',');
        SQL.Add(CreateFld(tbInfo_Req_change.pfx, fli_ChangeType)       + ',');
        SQL.Add(CreateFld(tbInfo_Req_change.pfx, fli_ReactivateReq));
        SQL.Add(') values (');
        SQL.Add(':' + CreateFld(tbInfo_Req_change.pfx, fli_IDENTIFIER) + ',');
        SQL.Add(':' + CreateFld(tbInfo_Req_change.pfx, fli_wkstCode)   + ',');
        SQL.Add(':' + CreateFld(tbInfo_Req_change.pfx, fli_preqNo)     + ',');
        SQL.Add(':' + CreateFld(tbInfo_Req_change.pfx, fli_pstepId)    + ',');
        SQL.Add(':' + CreateFld(tbInfo_Req_change.pfx, fli_updCode)    + ',');
        SQL.Add(':' + CreateFld(tbInfo_Req_change.pfx, fli_ChangeType) + ',');
        SQL.Add(':' + CreateFld(tbInfo_Req_change.pfx, fli_ReactivateReq));
        SQL.Add(')');
      end;

      ContinueLoop := false;

      for I := 0 to m_ReqChangeList.Count - 1 do
      begin
        if ContinueLoop then break;

        Application.ProcessMessages;

        if NewRequestChangeList.IndexOf(PTReqChange(m_ReqChangeList[I]).Request + IntToStr(PTReqChange(m_ReqChangeList[I]).Step)) = -1 then
          NewRequestChangeList.add(PTReqChange(m_ReqChangeList[I]).Request + IntToStr(PTReqChange(m_ReqChangeList[I]).Step))
        else
          continue;

        qry.ParamByName(CreateFld(tbInfo_Req_change.pfx, fli_IDENTIFIER)).Value := IniAppGlobals.Identifier;
        qry.ParamByName(CreateFld(tbInfo_Req_change.pfx, fli_wkstCode)).Value := IniAppGlobals.WkstCode;
        qry.ParamByName(CreateFld(tbInfo_Req_change.pfx, fli_preqNo)).Value := PTReqChange(m_ReqChangeList[I]).Request;
        qry.ParamByName(CreateFld(tbInfo_Req_change.pfx, fli_pstepId)).Value := PTReqChange(m_ReqChangeList[I]).Step;
        qry.ParamByName(CreateFld(tbInfo_Req_change.pfx, fli_updCode)).Value := NextUpdatedNumber;
        qry.ParamByName(CreateFld(tbInfo_Req_change.pfx, fli_ChangeType)).Value := PTReqChange(m_ReqChangeList[I]).TypeOfChange;
        //if ReqChange.Reactivate then
          //qry.ParamByName(CreateFld(tbInfo.pfx, fli_ReactivateReq)).Value := '1'
        //else
          Qry.ParamByName(CreateFld(tbInfo_Req_change.pfx, fli_ReactivateReq)).Value := '0';
        try
          Qry.ExecSQL;
        except

          on E: Exception do
          begin
            if (System.Pos('UNIQUE KEY', E.Message) > 0) or (System.Pos('PRIMARY ', E.Message) > 0) or
                (System.Pos('primary key ', E.Message) > 0) or (System.Pos('duplicate values', E.Message) > 0) then
            begin
              NewNextUpdatedNumber := NextUpdatedNumber + 1;
              ContinueLoop := true;
              continue;
            end
          end;

        end;
      end;

    end;

    qry.Transaction.Commit;
    Qry.Free;
    NewRequestChangeList.Free;
    for I := m_ReqChangeList.Count -1 downto 0 do
        Dispose(PTReqChange(m_ReqChangeList[I]));
    m_ReqChangeList.Clear;

    if NextUpdatedNumber >= 0 then
      DBAppGlobals.LastUpdatNr := NextUpdatedNumber - 1;

    IniAppGlobals.RefreshUTC := IniAppGlobals.RefreshUTCNew;

  end;

end;

//----------------------------------------------------------------------------//

function FindRequestStepInMcmdatesList(Request: string; Step : Integer; DatesFromMcmList : Tlist) : PDatesMcmSteps;
var
  i: integer;
  Multiplier, NumberOfEntries, NumberOfEntriesMinusOne : integer;
begin
  Result := nil;

  NumberOfEntries := DatesFromMcmList.Count;
  if NumberOfEntries = 0 then exit;
  NumberOfEntriesMinusOne := NumberOfEntries - 1;

  Multiplier := 1;
  while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    i := Multiplier - 1;

  while (Multiplier > 0) do
  begin
    Multiplier := trunc(Multiplier / 2);

    if (i > NumberOfEntriesMinusOne)
    or ((PDatesMcmSteps(DatesFromMcmList[i]).Request > Request)) then
    begin
      i := i - Multiplier;
      Continue;
    end;

    if  (PDatesMcmSteps(DatesFromMcmList[i]).Request < Request) then
    begin
      i := i + Multiplier;
      Continue;
    end;

    if  (PDatesMcmSteps(DatesFromMcmList[i]).Step < Step) then
    begin
      i := i + Multiplier;
      Continue;
    end;

    if  (PDatesMcmSteps(DatesFromMcmList[i]).Step > Step) then
    begin
      i := i - Multiplier;
      Continue;
  end;

    Result := PDatesMcmSteps(DatesFromMcmList[i]);
    Break;

  end;

end;

//----------------------------------------------------------------------------//

procedure ExternalDB_UpdateMqmFromMcmEarliestLatestDates(qry: TMqmQuery; ProgBar: TObject; Status: TStaticText; WorkCentersHandledList, WorkCentersViewedList : string);
var
  ProgBarstatus : TMqmProgBar;
  PrgIndex, PrgBlock, Progresses_Index, I, J, Ps : integer;
  PrgPrevSecond : Word;
  tblInfo_Req_Hdr, tbInfo_Prod_Step, tbInfo_WW, tbiMcm  : ^TTblInfo;
  DatesMcmSteps : PDatesMcmSteps;
  PREQ_NO, STEP_ID, ClosedStep, Low_StartTimeLimit, High_EndTimeLimit : TField;
  prodReqList : TList;
  ProdReqHdr  : TSCProdReqHdr;
  tDet : TSCProdReqDet;
  Job  : TSCProdSched;
  TableMcm : string;
begin
  ExternalDB_ClearDatesMcmList;

  if Assigned(ProgBar) then
  begin
    ProgBarstatus := ProgBar as TMqmProgBar;
    ProgBarstatus.SetPosition(0);
    ProgBarstatus.SetMax(2000);
    PrgBlock := trunc(2000/100) + 1;
    PrgIndex := 0;
    PrgPrevSecond := 0;
  end;

  if Assigned(Status) then
    Status.Caption := _('Reading scheduled Jobs from database...');

  Application.ProcessMessages;
  Progresses_Index := 0;

  tblInfo_Req_Hdr   := @tblInfo[tbl_prod_reqHdr];
  tbInfo_Prod_Step  := @tblInfo[tbl_prod_step];
  tbInfo_WW := @tblInfo[tbl_wkst_wkc];
  tbiMcm    := @tblInfo[tbl_prod_sched_mcm];

  if WorkCentersHandledList = '' then
     WorkCentersHandledList := QuotedStr('&&&');

  TableMcm := tbiMcm.GetTableName;
  with qry do
  begin
    SQL.Clear;

    SQL.Add(' Select ');
    SQL.Add(CreateFld(tbInfo_Prod_Step.pfx, fli_preqNo)  + ',');
    SQL.Add(CreateFld(tbInfo_Prod_Step.pfx, fli_pstepId)+ ',');
    SQL.Add('min('+ CreateFld(tbiMcm.pfx, fli_schedStart) + ')' + ' as LowestDate ,');
    SQL.Add('max('+ CreateFld(tbiMcm.pfx, fli_schedEnd) + ')' + ' as HighestDate ');

    SQL.Add(' from ' + tbInfo_Prod_Step.GetTableName + ' PD ');
    SQL.Add(' join ' + tbiMcm.GetTableName + ' MCM on ');
    SQL.Add(' PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_preqNo) + '=' + ' MCM.' + CreateFld(tbiMcm.pfx, fli_preqNo));
    SQL.Add(' AND PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_pstepId) + '=' + ' MCM.' + CreateFld(tbiMcm.pfx, fli_pstepId));
    SQL.Add(' AND PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_Identifier) + '=' + ' MCM.' + CreateFld(tbiMcm.pfx, fli_Identifier));
    SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo_Prod_Step.pfx, fli_Identifier)));
    SQL.Add(' AND PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_SchedulByMqm) + ' = ' + QuotedStr('1'));
    SQL.Add(' AND MCM.' + CreateFld(tbiMcm.pfx, fli_schedType) + ' <> ' + QuotedStr('0'));
    SQL.Add(' AND MCM.' + CreateFld(tbiMcm.pfx, fli_rsc) + ' <> ' + QuotedStr(''));
    SQL.Add(' and PD.' + CreateFld(tbInfo_Prod_Step.pfx, fli_wkCtrCode) + ' IN ' + '(' + WorkCentersHandledList + ')');

    SQL.Add(' GROUP BY ');
    SQL.Add(CreateFld(tbInfo_Prod_Step.pfx, fli_preqNo)  + ',');
    SQL.Add(CreateFld(tbInfo_Prod_Step.pfx, fli_pstepId) + ' ');

    SQL.Add(' ORDER BY ');
    SQL.Add(CreateFld(tbInfo_Prod_Step.pfx, fli_preqNo)  + ',');
    SQL.Add(CreateFld(tbInfo_Prod_Step.pfx, fli_pstepId));

    Open;

    PREQ_NO  := FieldByName(CreateFld(tbInfo_Prod_Step.pfx, fli_preqNo));
    STEP_ID := FieldByName(CreateFld(tbInfo_Prod_Step.pfx, fli_pstepId));
    Low_StartTimeLimit := FieldByName('LowestDate');
    High_EndTimeLimit  := FieldByName('HighestDate');

    while not EOF do
    begin
      new(DatesMcmSteps);
      DatesMcmSteps.Request := PREQ_NO.asString;
      DatesMcmSteps.Step    := STEP_ID.Asinteger;
      DatesMcmSteps.LowStartTimeLimit := Low_StartTimeLimit.AsDateTime;
      DatesMcmSteps.HighEndTimeLimit  := High_EndTimeLimit.AsDateTime;
      DatesMcmSteps.planStart         := DatesMcmSteps.LowStartTimeLimit;
      DatesMcmSteps.planEnd           := DatesMcmSteps.HighEndTimeLimit;
      m_DatesFromMcmList.Add(DatesMcmSteps);
      Next
    end;
  end;
//  m_CurrentHandledStepsListFromMcm.Sort(DatesMcmSteps);  // no need
  prodReqList := p_sc.P_GetprodReqList;

  for I := 0 to prodReqList.Count - 1 do
  begin
    ProdReqHdr := TSCProdReqHdr(prodReqList[i]);

    for j := 0 to ProdReqHdr.m_list.Count - 1 do
    begin
      tDet := TSCProdReqDet(ProdReqHdr.m_list[j]);
      DatesMcmSteps := FindRequestStepInMcmdatesList(tDet.m_hdr.m_code, tDet.m_code, m_DatesFromMcmList);
      if DatesMcmSteps <> nil then
      begin
        for Ps := 0 to tDet.m_list.Count - 1 do
        begin
          Job := TSCProdSched(tDet.m_list[Ps]);
          if Job.m_isDeleted then
             Continue;
          p_sc.SetEarliestLatestPlanedStartEndDatesFromMcm(Job.m_Id, DatesMcmSteps.LowStartTimeLimit, DatesMcmSteps.HighEndTimeLimit, DatesMcmSteps.planStart ,DatesMcmSteps.planEnd, false);
        end;
      end
      else
      begin
        for Ps := 0 to tDet.m_list.Count - 1 do
        begin
          Job := TSCProdSched(tDet.m_list[Ps]);
          if Job.m_isDeleted then
             Continue;
          p_sc.SetEarliestLatestPlanedStartEndDatesFromMcm(Job.m_Id, 0 ,0, 0, 0, true);
        end;
      end;

    end;
  end;

end;

//----------------------------------------------------------------------------//

procedure ExternalDB_ForceMqmScheduleDetailsToMCM(WorkCentersHandledList : string);
var
  ConFirmLvl : string;
  NumDaysFromToday : TDateTime;
  Qry : TMqmQuery;
  tbl : PTblInfo;
  TempDateTime : TDateTime;
  SelectionDateTime, PROD_SCHED, PROD_SCHED_MCM, Sep, PROD_STEP : string;
  Month, Day, Year, AHour, AMinute, ASecond, AMilliSecond : word;
  CBForceMqmScheduleDetails, CopiedSchedTypeFromMqm, CopiedBackwardFromMqmDays ,cbCopiedSchedTypeFromMqm, cbCopiedBackwardFromMqmDays: String;
begin
  Sep := ', ';

  if IniAppGlobals.DownloadTo = '2' then
  begin
    PROD_SCHED := 'PROD_SCHED';
    PROD_SCHED_MCM := 'PROD_SCHED_MCM';
    PROD_STEP      := 'PROD_STEP';
  end
  else
  begin
    PROD_SCHED := 'SCDM_PROD_SCHED';
    PROD_SCHED_MCM := 'SCDM_PROD_SCHED_MCM';
    PROD_STEP      := 'SCDM_PROD_STEP';
  end;
  qry := CreateQuery(Cfg_DB);
  tbl := @tblInfo[tbl_cfg_appini];

  qry.SQL.Text := 'Select * from ' + tbl.getTableName + ' where AI_WKST_CODE = ' + QuotedStr('MQMSRVLOAD') + AND_IDF_Condition(CreateFld(tbl.pfx, fli_Identifier));

  qry.Open;

  if qry.RecordCount > 0 then
  begin
    while not qry.eof do
    begin
      if qry.FieldByName('AI_FIELDNAME').asString = 'cbCopiedSchedTypeFromMqm' then
        cbCopiedSchedTypeFromMqm := qry.FieldByName('AI_VALUE').asString
      else if qry.FieldByName('AI_FIELDNAME').asString = 'cbCopiedBackwardFromMqmDays' then
        cbCopiedBackwardFromMqmDays := qry.FieldByName('AI_VALUE').asString
      else if qry.FieldByName('AI_FIELDNAME').asString = 'CopiedSchedTypeFromMqm' then
        CopiedSchedTypeFromMqm := qry.FieldByName('AI_VALUE').asString
      else if qry.FieldByName('AI_FIELDNAME').asString = 'CopiedBackwardFromMqmDays' then
        CopiedBackwardFromMqmDays := qry.FieldByName('AI_VALUE').asString
      else if qry.FieldByName('AI_FIELDNAME').asString = 'CBForceMqmScheduleDetails' then
        CBForceMqmScheduleDetails := qry.FieldByName('AI_VALUE').asString;
      qry.Next;
    end;

    qry.Free;

    if (CBForceMqmScheduleDetails <> '1') or ((CBCopiedSchedTypeFromMqm = '0') and (CBCopiedBackwardFromMqmDays = '0')) then
      exit;

    qry := CreateQuery(Main_DB);
    Qry.Transaction := CreateTransaction(Main_DB);
    Qry.Transaction.StartTransaction;

    with Qry do
    begin

      SQL.Clear;
      SQL.Add('update ' + PROD_SCHED_MCM + ' MCM set MS_MQM_ENV = ' + QuotedStr('0') + ' Where MS_MQM_ENV = ' + QuotedStr('1'));
      SQL.Add(AND_IDF_Condition('MS_IDENTIFIER'));
      SQL.Add(' and exists (select PD.PD_PREQ_NO from ' + PROD_STEP + ' PD '
                 + ' where PD.PD_IDENTIFIER = MCM.MS_IDENTIFIER AND PD.PD_PREQ_NO = MCM.MS_PREQ_NO and PD.PD_PSTEP_ID = MCM.MS_PSTEP_ID ');
      SQL.Add(' and PD.PD_WKCNTER' + ' IN ' + '(' + m_WorkCentersHandledAndViewList + ')' + ')');
      ExecSQL;

      // ('Delete old ' + 'PROD_SCHED_MCM');
      SQL.Clear;

      SQL.Add('delete from ' + PROD_SCHED_MCM + ' MCM where exists (select PS.PS_PREQ_NO from ' + PROD_SCHED + ' PS ' +
              'where PS.PS_SCHED_TYPE ' + ' <> ' + QuotedStr('0') + AND_IDF_Condition('PS.PS_IDENTIFIER') + AND_IDF_Condition('MCM.MS_IDENTIFIER') + ' AND PS.PS_PREQ_NO = MCM.MS_PREQ_NO and PS.PS_PSTEP_ID = MCM.MS_PSTEP_ID ');

      if CBCopiedSchedTypeFromMqm = '1' then
      begin

        if CopiedSchedTypeFromMqm = '0' then
          ConFirmLvl := QuotedStr('2')
        else if CopiedSchedTypeFromMqm = '1' then
          ConFirmLvl := QuotedStr('2') + ',' +  QuotedStr('1') + ',' + QuotedStr('3') + ',' + QuotedStr('4') + ',' + QuotedStr('5') + ',' + QuotedStr('6') + ',' + QuotedStr('7')
        else if CopiedSchedTypeFromMqm = '2' then
          ConFirmLvl := QuotedStr('2') + ',' + QuotedStr('3') + ',' + QuotedStr('4') + ',' + QuotedStr('5') + QuotedStr('6') + ',' + QuotedStr('7')
        else if CopiedSchedTypeFromMqm = '3' then
          ConFirmLvl := QuotedStr('2') + ',' + QuotedStr('4') + ',' + QuotedStr('5') + ',' + QuotedStr('6') + ',' + QuotedStr('7')
        else if CopiedSchedTypeFromMqm = '4' then
          ConFirmLvl := QuotedStr('2') + ',' + QuotedStr('5') + ',' + QuotedStr('6') + ',' + QuotedStr('7')
        else if CopiedSchedTypeFromMqm = '5' then
          ConFirmLvl := QuotedStr('2') + ',' + QuotedStr('6') + ',' + QuotedStr('7')
        else if CopiedSchedTypeFromMqm = '6' then
          ConFirmLvl := QuotedStr('2') + ',' + QuotedStr('7');

        SQL.Add(' and PS_SCHED_TYPE ' + ' in (' + ConFirmLvl + ')');
      end;

      if (CBCopiedBackwardFromMqmDays = '1') and (StrToInt(CopiedBackwardFromMqmDays) > 0) then
      begin
        NumDaysFromToday := now + StrToInt(CopiedBackwardFromMqmDays);
        TempDateTime := NumDaysFromToday;
        DecodeDate(TempDateTime, year, month, day);
        SelectionDateTime := ConvertDateFormatDb2Oracle(TempDateTime, true, true);
        SQL.Add(' AND PS_SCH_START ' + ' < ' + SelectionDateTime); //
      end;

      SQL.Add(')');
      SQL.Add(' and exists (select PD.PD_PREQ_NO from ' + PROD_STEP + ' PD '
                 + ' where PD.PD_IDENTIFIER = MCM.MS_IDENTIFIER AND PD.PD_PREQ_NO = MCM.MS_PREQ_NO and PD.PD_PSTEP_ID = MCM.MS_PSTEP_ID ');
      SQL.Add(' and PD.PD_WKCNTER' + ' IN ' + '(' + m_WorkCentersHandledAndViewList + ')' + ')');
      ExecSQL;
      Qry.sql.Clear;

      SQL.Add('insert into ' + PROD_SCHED_MCM + ' (MS_PREQ_NO, MS_PSTEP_ID, MS_PSUBST_ID, MS_REPROC_NO, MS_IDENTIFIER,');
      SQL.Add(' MS_TYPE_PROD, MS_PROD_UM, MS_STEP_TYP, MS_INIT_QUENT, MS_ST_GROUP,	MS_STEP_IS_GRPED, ');
      SQL.Add(' MS_SCHED_TYPE, MS_WKCNTER, MS_WKCT_PROC, MS_ALTERNATIVE_CODE, MS_RSC_CODE, MS_NUM_RSC_COMPONENTS, MS_QTY,');
      SQL.Add(' MS_SUP_BASE, MS_SUP_REAL, MS_SUP_OVERLAP, MS_EXE_MIN, MS_SCH_START, MS_SCH_END,MS_COMMENT, MS_NEW_PREQ_UNIQ_ID,');
      SQL.Add(' MS_SPLITED_FAMILY, MS_LEARNING_CURVE_CODE, MS_MQM_ENV, MS_LEARNING_CURVE_CODE_OCC_OCC, MS_FORCED_GRP_NO) ');

      SQL.Add(' (Select PS_PREQ_NO, PS_PSTEP_ID, PS_PSUBST_ID, PS_REPROC_NO, PS_IDENTIFIER,');
      SQL.Add(' PS_TYPE_PROD, PS_PROD_UM, PS_STEP_TYP, PS_INIT_QUENT, PS_ST_GROUP,	PS_STEP_IS_GRPED, ');
      SQL.Add(' PS_SCHED_TYPE, PS_WKCNTER, PS_WKCT_PROC, PS_ALTERNATIVE_CODE, PS_RSC_CODE, PS_NUM_RSC_COMPONENTS, PS_QTY,');
      SQL.Add(' PS_SUP_BASE, PS_SUP_REAL, PS_SUP_OVERLAP, PS_EXE_MIN, PS_SCH_START, PS_SCH_END, PS_COMMENT, PS_NEW_PREQ_UNIQ_ID,');
      SQL.Add(' PS_SPLITED_FAMILY, PS_LEARNING_CURVE_CODE, PS_MQM_ENV, PS_LEARNING_CURVE_CODE_OCC_OCC, PS_FORCED_GRP_NO');
      SQL.Add(' from ' + PROD_SCHED + ' ps where PS_SCHED_TYPE ' + ' <> ' + QuotedStr('0'));

      if CBCopiedSchedTypeFromMqm = '1' then
      begin
        if CopiedSchedTypeFromMqm = '0' then
          ConFirmLvl := QuotedStr('2')
        else if CopiedSchedTypeFromMqm = '1' then
          ConFirmLvl := QuotedStr('2') + Sep +  QuotedStr('1') + Sep + QuotedStr('3') + Sep + QuotedStr('4') + Sep + QuotedStr('5') + Sep + QuotedStr('6') + Sep + QuotedStr('7')
        else if CopiedSchedTypeFromMqm = '2' then
          ConFirmLvl := QuotedStr('2') + Sep + QuotedStr('3') + Sep + QuotedStr('4') + Sep + QuotedStr('5') + Sep + QuotedStr('6') + Sep + QuotedStr('7')
        else if CopiedSchedTypeFromMqm = '3' then
          ConFirmLvl := QuotedStr('2') + Sep + QuotedStr('4') + Sep + QuotedStr('5') + Sep + QuotedStr('6') + Sep + QuotedStr('7')
        else if CopiedSchedTypeFromMqm = '4' then
          ConFirmLvl := QuotedStr('2') + Sep + QuotedStr('5') + Sep + QuotedStr('6') + Sep + QuotedStr('7')
        else if CopiedSchedTypeFromMqm = '5' then
          ConFirmLvl := QuotedStr('2') + Sep + QuotedStr('6') + Sep + QuotedStr('7')
        else if CopiedSchedTypeFromMqm = '6' then
          ConFirmLvl := QuotedStr('2') + Sep + QuotedStr('7');
        Qry.SQL.Add(' and ');
        Qry.SQL.Add('PS_SCHED_TYPE ' + ' in (' + ConFirmLvl + ')');
      end;

      SQL.Add(AND_IDF_Condition('PS_IDENTIFIER'));

      if CBCopiedBackwardFromMqmDays = '1' then
      begin
        Qry.SQL.Add(' AND ');
        Qry.SQL.Add('PS_SCH_START ' + ' <= ' + SelectionDateTime);
      end;

      SQL.Add(' and exists (select 1 from ' + PROD_STEP
               + ' where PD_IDENTIFIER = PS_IDENTIFIER AND PD_PREQ_NO = PS_PREQ_NO and PD_PSTEP_ID = PS_PSTEP_ID ');

      SQL.Add(' and PD_WKCNTER' + ' IN ' + '(' + m_WorkCentersHandledAndViewList + ')' + '))');
    end;

    Qry.ExecSQL;
    Qry.Transaction.Commit;
    Qry.Close;
    Qry.Free;
  end;

end;

//----------------------------------------------------------------------------//

procedure ExternalDB_ClearDatesMcmList;
var
  I : Integer;
begin
  for I := 0 to m_DatesFromMcmList.Count - 1 do
    dispose(PDatesMcmSteps(m_DatesFromMcmList[I]));
  m_DatesFromMcmList.Clear
end;

//----------------------------------------------------------------------------//

procedure ExternalDB_ClearCurrentStepsList;
var
  I : Integer;
begin
  for I := 0 to m_CurrentStepsList.Count - 1 do
    dispose(PTCurrentSteps(m_CurrentStepsList[I]));
  m_CurrentStepsList.Clear
end;

//----------------------------------------------------------------------------//

initialization
  m_CurrentStepsList := TList.Create;
  m_DatesFromMcmList := TList.Create;
  m_ReqChangeList := TList.Create;
  m_StepsToNotSave := TStringList.Create;
  m_StepsToNotSave.Sorted := true;

finalization
  ExternalDB_ClearCurrentStepsList;
  ExternalDB_ClearDatesMcmList;
  m_DatesFromMcmList.free;
  m_CurrentStepsList.free;
  m_ReqChangeList.free;

end.
