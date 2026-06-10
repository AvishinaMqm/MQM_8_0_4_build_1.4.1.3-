unit UMUploadToNOW;

interface

uses
  Windows,
  UMTblDesc,
  Db,
  DMSrvPC,
  ADOdb,
  gnugettext;

  function SendProdSched_MQM_TO_NOW(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery; var Is_SCHEDULESUPLOAD_empty : boolean; var MQM_OR_MCM_ENVIRONMENT : string): boolean;
  function SendProdSched_MCM_TO_NOW(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery; var Is_SCHEDULESUPLOAD_empty : boolean; var MQM_OR_MCM_ENVIRONMENT : string): boolean;
  function SendMaterialSchedule_TO_NOW(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;

  function DownloadCompanyHandling(srvQry : TMqmQuery; HostQry: TMqmQuery): boolean;

implementation

uses
  SysUtils,
  UMSrvConfig,
  UMSrvLoad,
  Classes,
  dialogs,
  UGconvert,
  UMGlobal,
  UMCommon,
  UMload,
  StrUtils,
  UOpThread,
  UMSaveLoad;

type

  TABSCOMPANYHANDLING = Record
    ENTITYNAME : String;
    COMPANYLEVELHANDLING: String;
  end;
  PABSCOMPANYHANDLING = ^TABSCOMPANYHANDLING;

  TResourceWCenter = Record
    Resource : String;
    WorkCenter: String;
  end;
  FTResourceWCenter = ^TResourceWCenter;

  TMQMPRODSCHED = Record
    REQUEST     : string;
    COMPANYCODE : string;
    COUNTERCODE : string;
    CODE        : string;
    STEPNUMBER  : Integer;
    SUBSTEP     : integer;
    REPROCESS   : integer;
    CANGROUP    : string;
    GROUPNUMBER : string;
    SCHEDULETYPE : string;
    SCHEDULEWORKCENTERCODE        : string;
    SCHEDULEDRESOURCECODE         : string;
    SCHEDULEDRESOURCESUBLINE      : integer;
    NUMBEROFRESOURCECOMPONENTS    : integer;
    QUANTITYINPRIMARYUOM          : double;
    PRIMARYUOMCODE                : string;
    SETUPTIMEBEFOREMATERIAL       : double;
    SETUPTIMEAFTERMATERIAL        : double;
    EXECUTIONTIME                 : double;
    INITIALSCHEDULEDDATE          : string;
    INITIALSCHEDULEDTIME          : string;
    FINALSCHEDULEDDATE            : string;
    FINALSCHEDULEDTIME            : string;
    INITIALSCHEDULEDACTUALDATE    : string;
    INITIALSCHEDULEDACTUALTIME    : string;
    FINALSCHEDULEDACTUALDATE      : string;
    FINALSCHEDULEDACTUALTIME      : string;
    PLANNERCOMMENT                : string;
    NewDemandUniqueId             : string;
    SPLITFAMILY                   : string;
    IMPORTSTATUS                  : Integer;
    ChangedType                   : string;
    ABSUNIQUEID                   : integer;
    MQM_ENV                       : string;
    DELETE                        : boolean;
  end;
  PMQMPRODSCHED = ^TMQMPRODSCHED;

  TMQMWARPSCHED = Record
    ITEMTYPECODE     : string;   //key
    FIKDIDENTIFIER   : Double;   //key
    CONTAINERITEMTYPECODE  : string;
    CONTAINERSUBCODE01     : string;
    CONTAINERELEMENTCODE   : string;
    ELEMENTSCODE       : string;
    DEMANDCOUNTERCODE  : string;
    DEMANDCODE            : String;
    LOGICALWAREHOUSECODE  : string;  //key
    QTY                   : Double;
    RSC_CODE              : string;
    OVERRIDENSETUPTIME    : double;
    OVERRIDENSPEED        : double;
    SCH_START         : TDateTime;
    SCH_END                  : TDateTime;
    FIRSTJOBQUANTITYINCLUDED           : Double;
    LASTJOBQUANTITYINCLUDED           : Double;
   // HOSTITEMINDENTIFIER     : Double;
 //   HostWarehouse : String;
    SubDetailHostType : String;
    DetailCodeType : String;
    Action : String;
    MATERIALTYPE : Integer;
  end;
  PMQMWARPSCHED = ^TMQMWARPSCHED;

var
  M_ABSCOMPANYHANDLING : TList;
  M_ResourceWorkCnterList : TList;
  // Keys of the rows already sitting in SCHEDULESUPLOAD (importstatus=3, changetype<>'3')
  // that we are allowed to overwrite instead of blocking. Built in CheckEmptyTableInHost,
  // consumed in SendSchedTablesMqmAndMcm. One composite key string per row.
  g_ExistingUploadKeys : TStringList;

Function SetDecSeparator(S : String) : String;
begin

  if FormatSettings.DecimalSeparator = ',' then
  begin
      s := StringReplace(s,',','.', [rfReplaceAll, rfIgnoreCase]);
      s := StringReplace(s,'|',',', [rfReplaceAll, rfIgnoreCase]);
  end;

  Result := S;

end;

//----------------------------------------------------------------------------//

// Composite SCHEDULESUPLOAD row key (within a fixed company/environment/highlevel scope).
// Used to match a local schedule row against rows already present in SCHEDULESUPLOAD.
function MakeUploadKey(const ACompany, ACounter, ACode: string; AStep, ASub, AReproc: Integer): string;
begin
  Result := Trim(ACompany) + '|' + Trim(ACounter) + '|' + Trim(ACode) + '|' +
            IntToStr(AStep) + '|' + IntToStr(ASub) + '|' + IntToStr(AReproc);
end;

//----------------------------------------------------------------------------//

function ConvertDate_FormatTo(dateToConvert: TDate; GetDownloadTo: Integer): String;
var
  year: Word;
  month: Word;
  day: Word;
begin
  DecodeDate(dateToConvert, year, month, day);
  if (GetDownloadTo = 0) then      // IB
    Result := QuotedStr( IntToStr(month) + '/' + IntToStr(Day) + '/' + IntToStr(Year))
  else if (GetDownloadTo = 1) then // DB2
    Result := QuotedStr(IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(Day))
  else if (GetDownloadTo = 2) then  // Oracle
    Result := 'to_date(' + QuotedStr(IntToStr(Year) + '-' + IntToStr(Month) + '-' + IntToStr(Day)) + ', ' + QuotedStr('YYYY-MM-DD') + ')';
end;

//----------------------------------------------------------------------------//

function formatForTwoDigits(value: String): String;
begin
  if Length(value) = 1 then
    Result := '0' + value
  else
    Result := value;
end;

//----------------------------------------------------------------------------//

function ConvertTime_FormatTo(dateToConvert: TTime; GetDownloadTo: Integer): String;
var
  hour: Word;
  minute: Word;
  second: Word;
  milisecond: Word;
begin
  DecodeTime(dateToConvert, hour, minute, second, milisecond);

  if (GetDownloadTo = 0) then      // IB
    Result := QuotedStr(formatForTwoDigits(IntToStr(hour)) + ':' + formatForTwoDigits(IntToStr(minute)) + ':' +
                        formatForTwoDigits(IntToStr(second)) + '.' + IntToStr(milisecond))
  else if (GetDownloadTo = 1) then // DB2
    Result := QuotedStr(formatForTwoDigits(IntToStr(hour)) + ':' + formatForTwoDigits(IntToStr(minute)) + ':' +
                        formatForTwoDigits(IntToStr(second))) //' 00:00:00.0'
  else if (GetDownloadTo = 2) then  // Oracle
    Result := 'to_date(' + QuotedStr(IntToStr(1970) + '-' + '01' + '-' + '01' + ' ' +
                           formatForTwoDigits(IntToStr(hour)) + ':' + formatForTwoDigits(IntToStr(minute)) + ':' +
                           formatForTwoDigits(IntToStr(second))) + ', ' + QuotedStr('YYYY-MM-DD HH24:MI:SS') + ')';

end;

//----------------------------------------------------------------------------//

function ConvertTimeToOracle(OracTime : string) : string;
begin
    Result := 'to_date(' + QuotedStr(IntToStr(1970) + '-' + '01' + '-' + '01' + ' ' +
               OracTime) + ', ' + QuotedStr('YYYY-MM-DD HH24:MI:SS') + ')';
end;

//----------------------------------------------------------------------------//

function GetCompanyLevelHandlingByEntityName(EntitySearch : string; var CompanyInUsed : string) : boolean;
var
  I : Integer;
  ReqPABSCOMPANYHANDLING : PABSCOMPANYHANDLING;
  LevelHandling : string;
begin
  Result := false;
  for I := 0 to M_ABSCOMPANYHANDLING.Count - 1 do
  begin
    ReqPABSCOMPANYHANDLING := PABSCOMPANYHANDLING(M_ABSCOMPANYHANDLING[I]);
    if AnsiContainsStr(ReqPABSCOMPANYHANDLING.ENTITYNAME, EntitySearch) then
    begin
      LevelHandling := ReqPABSCOMPANYHANDLING.COMPANYLEVELHANDLING;
      if (LevelHandling = '5') then
        exit
      else if (LevelHandling = '3') or (LevelHandling = '4') then
      begin
        if IniAppGlobals.GroupCode <> '' then
          CompanyInUsed := IniAppGlobals.GroupCode
        else
          CompanyInUsed := IniAppGlobals.CompanyCode;
      end
      else if (LevelHandling = '1') or (LevelHandling = '2') then
        CompanyInUsed := 'NOC';
      Result := true;
      Exit;
    end;
  end;
end;

//----------------------------------------------------------------------------//

function SendArchiveTable(tbl: table; ASLib, PCcondition: string;
                   linkArr: array of TQryLinkRec;
                   srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
var
  i, parm, field: integer;
  tbInfo: ^TTblInfo;
  tblName:        string;
  linkList:       TList;
  LinkCount: integer;
begin
  tbInfo := @tblInfo[tbl];
  SetFldPfx(tbInfo.pfx);
  tblName := ASLib + tbInfo.ASname;

  // select the data from AS400
  with srvQry do
  begin
    UpdateOperation(_('PC query ') + ' ' + tbInfo.GetTableName);
    SQL.Clear;
    SQL.Add('select');
    for i := 0 to High(linkArr)-1 do
      SQL.Add(CreatePfxFld(linkArr[i].fldPC) + ',');
    SQL.Add(CreatePfxFld(linkArr[High(linkArr)].fldPC) + ' from ' + tbInfo.GetTableName);
    SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
    if PCcondition <> '' then
      SQL.Add(PCcondition);
    Open
  end;

  with HostQry do
  begin

    // clear the table on the server
    UpdateOperation(_('Clearing') + ' ' + tbInfo.ASname);
    SQL.Clear;
    SQL.Add('delete from ' + tblName);
    ExecSQL;
    Close;

    LinkCount := High(linkArr);
    UpdateOperation(_(' Uploading  ') + tbInfo.ASname  + _(' to Host ...') );
    SQL.Clear;
    SQL.Add('insert into ' + tblName + ' (');
    for i := 0 to LinkCount-1 do
      SQL.Add(linkArr[i].fldAS + ',');
    SQL.Add(linkArr[LinkCount].fldAS);
    SQL.Add(') values (');
    for i := 0 to LinkCount-1 do
      SQL.Add(':' + linkArr[i].fldAS + ',');
    SQL.Add(':' + linkArr[LinkCount].fldAS + ')');
    Prepared := true;

    linkList := TList.Create;
    for i := 0 to LinkCount do
    begin
      linkList.Add(HostQry.ParamByName(linkArr[i].fldAS));
      linkList.Add(srvQry.FieldByName(CreatePfxFld(linkArr[i].fldPC)))
    end;

    while not srvQry.EOF do
    begin
      // assign the fields
      parm  := 0;
      field := 1;

      for i := 0 to LinkCount do
      begin
        case linkArr[i].fldType of
          TLD_string   :begin
                         TParameter(linkList[parm]).DataType := ftString;
                         TParameter(linkList[parm]).Size := 50;
                         TParameter(linkList[parm]).value := TField(linkList[field]).AsString;
                        end;
          TLD_integer  :begin
                         TParameter(linkList[parm]).DataType := ftInteger;
                         TParameter(linkList[parm]).value := TField(linkList[field]).AsInteger;
                        end;
          TLD_float    :begin
                         TParameter(linkList[parm]).DataType := ftFloat;
                         TParameter(linkList[parm]).value := TField(linkList[field]).AsFloat;
                        end;
          TLD_date     :begin
                          TParameter(linkList[parm]).DataType := ftDateTime;
                          TParameter(linkList[parm]).value := TField(linkList[field]).AsDateTime;
                        end;
          TLD_dateTime :begin
                          TParameter(linkList[parm]).DataType := ftString;
                          TParameter(linkList[parm]).value := Datetimetostr(TField(linkList[field]).AsDateTime);
                        end;

        else
          Assert(false);
        end;

        parm  := parm  + 2;
        field := field + 2

      end;
      HostQry.ExecSql;
      srvQry.Next
    end;
    linkList.Free;
    HostQry.Close;

  end;

  UpdateOperation(_('saved ') + tbInfo.GetTableName);
  Result := true
end;

//----------------------------------------------------------------------------//

function SortMaterialHost(Item1, Item2: Pointer) : integer;
var
  MQMSP1 : PMQMWARPSCHED;
  MQMSP2 : PMQMWARPSCHED;
begin
  MQMSP1 := PMQMWARPSCHED(Item1);
  MQMSP2 := PMQMWARPSCHED(Item2);

  //, ITEMTYPECODE, FIKDIDENTIFIER,  CONTAINERITEMTYPECODE, CONTAINERSUBCODE01,  CONTAINERELEMENTCODE,  ELEMENTSCODE
  //,  DEMANDCOUNTERCODE, DEMANDCODE, LOGICALWAREHOUSECODE

  if MQMSP1.ITEMTYPECODE < MQMSP2.ITEMTYPECODE  then
     Result := -1
  else if (MQMSP1.ITEMTYPECODE = MQMSP2.ITEMTYPECODE) then
  begin
    if (MQMSP1.FIKDIDENTIFIER < MQMSP2.FIKDIDENTIFIER) then
      Result := -1
    else if (MQMSP1.FIKDIDENTIFIER = MQMSP2.FIKDIDENTIFIER) then
    begin
      if (MQMSP1.CONTAINERITEMTYPECODE < MQMSP2.CONTAINERITEMTYPECODE) then
          Result := -1
      else if (MQMSP1.CONTAINERITEMTYPECODE = MQMSP2.CONTAINERITEMTYPECODE) then
      begin
        if (MQMSP1.CONTAINERSUBCODE01 < MQMSP2.CONTAINERSUBCODE01) then
          Result := -1
        else if (MQMSP1.CONTAINERSUBCODE01 = MQMSP2.CONTAINERSUBCODE01) then
        begin
          if (MQMSP1.CONTAINERELEMENTCODE < MQMSP2.CONTAINERELEMENTCODE) then
            Result := -1
          else if (MQMSP1.CONTAINERELEMENTCODE = MQMSP2.CONTAINERELEMENTCODE) then
          begin
            if (MQMSP1.ELEMENTSCODE < MQMSP2.ELEMENTSCODE) then
              Result := -1
            else if (MQMSP1.ELEMENTSCODE = MQMSP2.ELEMENTSCODE) then
            begin
              if (MQMSP1.DEMANDCOUNTERCODE < MQMSP2.DEMANDCOUNTERCODE) then
                Result := -1
              else if (MQMSP1.DEMANDCOUNTERCODE = MQMSP2.DEMANDCOUNTERCODE) then
              begin
                if (MQMSP1.DEMANDCODE < MQMSP2.DEMANDCODE) then
                  Result := -1
                else if (MQMSP1.DEMANDCODE = MQMSP2.DEMANDCODE) then
                begin
                  if (MQMSP1.LOGICALWAREHOUSECODE < MQMSP2.LOGICALWAREHOUSECODE) then
                    Result := -1
                  else if (MQMSP1.LOGICALWAREHOUSECODE = MQMSP2.LOGICALWAREHOUSECODE) then
                    Result := 0
                  else
                    Result := 1;
                end else
                  Result := 1;
              end else
                Result := 1;
            end else
              Result := 1;
          end else
            Result := 1;
        end else
          Result := 1;
      end else
        Result := 1;
    end else
      Result := 1;
  end else
    Result := 1;
end;

function SortPSHost(Item1, Item2: Pointer) : integer;
var
  MQMSP1 : PMQMPRODSCHED;
  MQMSP2 : PMQMPRODSCHED;
begin
  MQMSP1 := PMQMPRODSCHED(Item1);
  MQMSP2 := PMQMPRODSCHED(Item2);

  if MQMSP1.COMPANYCODE < MQMSP2.COMPANYCODE then
     Result := -1
  else if (MQMSP1.COMPANYCODE = MQMSP2.COMPANYCODE) then
  begin
    if (MQMSP1.COUNTERCODE < MQMSP2.COUNTERCODE) then
       Result := -1
    else if (MQMSP1.COUNTERCODE = MQMSP2.COUNTERCODE) then
    begin
      if (MQMSP1.CODE < MQMSP2.CODE) then
        Result := -1
      else if (MQMSP1.CODE = MQMSP2.CODE) then
      begin
        if (MQMSP1.STEPNUMBER < MQMSP2.STEPNUMBER) then
          Result := -1
        else if (MQMSP1.STEPNUMBER = MQMSP2.STEPNUMBER) then
        begin
          if (MQMSP1.SUBSTEP < MQMSP2.SUBSTEP) then
            Result := -1
          else if (MQMSP1.SUBSTEP = MQMSP2.SUBSTEP) then
          begin
            if (MQMSP1.REPROCESS < MQMSP2.REPROCESS) then
              Result := -1
            else if (MQMSP1.REPROCESS = MQMSP2.REPROCESS) then
            begin
              result := 0;
            end
            else
              Result := 1;
          end
          else
            Result := 1;
        end
        else
          Result := 1;
      end
      else
        Result := 1
    end
    else
      Result := 1;
  end
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

procedure ConvertToCopmanyCounterCode(Request : string; var CompCod : string; var Counter : string; var Code : string);
begin
  CompCod := Trim(Copy(Request, 0, 3));
  Counter := Trim(Copy(Request, 4, 8));
  code := Trim(Copy(Request, 12, 15));
end;

//----------------------------------------------------------------------------//

{function GetWorkCenterFromRes(Resuorce : string) : string;
var
  tb : ^TTblInfo;
  SrvWcQry: TMqmQuery;
begin
  Result := '';
  SrvWcQry := ThreadCreateQueryArc;
  tb     := @tblInfo[tbl_res];
  SrvWcQry.SQL.Clear;
  SrvWcQry.SQL.add('Select RS_WKCNTER from ' + Tb.GetTableName + ' WHERE RS_RSC_CODE = ' + QuotedStr(Resuorce));
  SrvWcQry.Open;
  Result := SrvWcQry.FieldByName('RS_WKCNTER').AsString;
  SrvWcQry.Close;
  SrvWcQry.Free;
end;   }

//----------------------------------------------------------------------------//

procedure CleanResourceWorkCnterList(FreeList : boolean);
var
  I : Integer;
begin
  if assigned(M_ResourceWorkCnterList) then
  begin
    for I := 0 to M_ResourceWorkCnterList.Count - 1 do
      dispose(FTResourceWCenter(M_ResourceWorkCnterList[I]));
    M_ResourceWorkCnterList.Clear;
    if FreeList then
      M_ResourceWorkCnterList.Free;
  end;
end;

//----------------------------------------------------------------------------//

function FindWorkCenterByCode(Resource : string) : string;
var
  i: integer;
  Multiplier, NumberOfEntries : integer;
begin
  Result := '';

  NumberOfEntries := M_ResourceWorkCnterList.Count;
  if NumberOfEntries = 0 then
  begin
    Exit;
  end;

  Multiplier := 1;
  while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    i := Multiplier - 1;

  while (Multiplier > 0) do
  begin

    if  (i < NumberOfEntries)
      and (FTResourceWCenter(M_ResourceWorkCnterList[i]).Resource = Resource) then break;

    Multiplier := trunc(Multiplier / 2);

    if  (i < NumberOfEntries) and (FTResourceWCenter(M_ResourceWorkCnterList[i]).Resource < Resource) then
      i := i + Multiplier
    else
      i := i - Multiplier;
  end;

  if Multiplier > 0 then
    Result := FTResourceWCenter(M_ResourceWorkCnterList[i]).WorkCenter;

end;

//----------------------------------------------------------------------------//

procedure FillListWorkCenterFromRes;
var
  tb : ^TTblInfo;
  SrvWcQry: TMqmQuery;
  ResourceWCenter : FTResourceWCenter;
begin
  SrvWcQry := ThreadCreateQueryArc;
  tb     := @tblInfo[tbl_res];
  SrvWcQry.SQL.Clear;
  CleanResourceWorkCnterList(false);
  SrvWcQry.SQL.add('Select * from ' + Tb.GetTableName + WHERE_IDF_Condition('RS_IDENTIFIER') + ' ORDER BY RS_RSC_CODE ');
  SrvWcQry.Open;
  while not SrvWcQry.Eof do
  begin
    New(ResourceWCenter);
    ResourceWCenter.Resource := SrvWcQry.FieldByName('RS_RSC_CODE').AsString;
    ResourceWCenter.WorkCenter := SrvWcQry.FieldByName('RS_WKCNTER').AsString;
    M_ResourceWorkCnterList.Add(ResourceWCenter);
    SrvWcQry.Next
  end;
  SrvWcQry.Free
end;

//----------------------------------------------------------------------------//

function SendSchedTablesMqmAndMcm(tbl: table; ASLib, PCcondition: string;
                   linkArr: array of TQryLinkRec;
                   srvQry: TMqmQuery; HostQry: TMqmQuery; HIGHLEVELSCHEDULE_MQM_OR_MCM : string; Exist_HIGHLEVELSCHEDULE, Exist_COUNTERCOMPANYCODE,
                   Exist_Actual_Start_End : boolean): boolean;
var
  tbInfo : ^TTblInfo;
  srvSqlStr , HostSqlStr, HostSqlStrVal  : string;
  MQMPRODSCHED : PMQMPRODSCHED;
  HostSchedList : TList;
  List_To_Be_insert : Tlist;
  List_To_Be_update : Tlist;
  SrvSchedList      : TList;
  Index_Host, Index_Srv, I, j : integer;
  Request,CompCod,Counter,Code : string;
  sl     : TStringList;
  ConvertDateFormat : Integer;
  INITIALSCHEDULEDDATETIME : TDateTime;
  FINALSCHEDULEDDATETIME   : TdateTime;
  INITIALSCHEDULEDDATEACTUALTIME : TDateTime;
  FINALSCHEDULEDDATEACTUALTIME   : TdateTime;
  Str : string;
  COUNTERCOMPANYCODE_InUsed : string;
  ScheduleMQMORMCM : string;
  ProdReqList, StepList : TStringlist;
  // Cached TField references for srvQry loop
  sf_preqNo, sf_StepId, sf_substId, sf_reprocNo, sf_StepIsGrouped,
  sf_stGroup, sf_schedType, sf_rsc, sf_wkCtrCode, sf_subLinRscId,
  sf_NumSubRsc, sf_quant, sf_ProdUMCode, sf_supMinOvlp, sf_supMinReal,
  sf_exeMin, sf_schedStart, sf_schedEnd, sf_ActualStart, sf_ActualEnd,
  sf_Comment, sf_NewPreqUniqId, sf_SplitFamaly, sf_MqmEnv : TField;
  // Cached TField references for HostQry loop
  hf_Company, hf_Counter, hf_Code, hf_Step, hf_SubStep,
  hf_Reprocess, hf_CanGroup, hf_GroupNum, hf_SchedType,
  hf_WC, hf_Rsc, hf_RscSubLine, hf_NumRsc,
  hf_Qty, hf_UOM, hf_SetupBefore, hf_SetupAfter, hf_ExeTime,
  hf_InitDate, hf_InitTime, hf_FinalDate, hf_FinalTime,
  hf_PlanComment, hf_NewDemandId, hf_SplitFamily,
  hf_ActInitDate, hf_ActInitTime, hf_ActFinalDate, hf_ActFinalTime : TField;
begin
  Result := true;
  tbInfo := @tblInfo[tbl];

  if HIGHLEVELSCHEDULE_MQM_OR_MCM = '0' then
    ScheduleMQMORMCM := 'MQM'
  else
    ScheduleMQMORMCM := 'MCM';

  FillListWorkCenterFromRes;

  if not GetCompanyLevelHandlingByEntityName('COUNTER',  COUNTERCOMPANYCODE_InUsed) then
     COUNTERCOMPANYCODE_InUsed := IniAppGlobals.CompanyCode;

  HostSchedList     := TList.Create;
  List_To_Be_insert := TList.Create;
  SrvSchedList      := TList.Create;

  UpdateOperation(_('Reading local schedule - ' + ScheduleMQMORMCM + ' ...'));

  PCcondition := ' Order by ' + CreateFld(tbInfo.pfx,fli_preqNo) + ',' + CreateFld(tbInfo.pfx,fli_pstepId) + ',' +
                 CreateFld(tbInfo.pfx,fli_psubstId) + ',' + CreateFld(tbInfo.pfx,fli_psubstId);

  // select the data from AS400
  with srvQry do
  begin
    UpdateOperation(_('Local query ') + ' ' + tbInfo.GetTableName);
    ProdReqList := TStringlist.Create;
    StepList    := TStringlist.Create;
    SQL.Clear;
    SQL.text := 'Select ' + CreateFld(tbInfo.pfx,fli_preqNo) + ',' + CreateFld(tbInfo.pfx,fli_pstepId) + ' From '  + tbInfo.GetTableName + ' where ' + CreateFld(tbInfo.pfx,fli_ExeMin) + '>  999999';
    SQL.text := SQL.text + AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER));
    Open;
    while not EOF do
    begin
      ProdReqList.Add(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_preqNo)).Asstring);
      StepList.Add(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_pstepId)).Asstring);
      Next;
    end;
    SQL.Clear;
    for I := 0 to ProdReqList.Count - 1 do
    begin
      SQL.text := 'update ' + tbInfo.GetTableName + ' set ' + CreateFld(tbInfo.pfx,fli_ExeMin) + ' = ' + '0 where ';
      SQL.text := SQL.text + CreateFld(tbInfo.pfx, fli_preqNo) + ' = ''' + ProdReqList.Strings[I] + '''' + ' AND ' + CreateFld(tbInfo.pfx, fli_pstepId) + ' = ''' + StepList.Strings[I] + '''';
      SQL.text := SQL.text + AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER));
      try
        ExecSQL;
      except
        on E: Exception do
        begin
          raise
        end;
      end;
    end;
    ProdReqList.free;
    StepList.free;

{   SQL.text := 'update ' + tbInfo.GetTableName + ' set ' + CreateFld(tbInfo.pfx,fli_ExeMin) + ' = ' + '0 where ' + CreateFld(tbInfo.pfx,fli_ExeMin) + '>  999999';
    SQL.text := SQL.text + AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER));
    try
      ExecSQL;
    except
      on E: Exception do
      begin
        raise
      end;
    end;  }

    srvQry.Transaction.Commit;
    SQL.Clear;
    SQL.Add('select');
    for i := 0 to High(linkArr)-1 do
      SQL.Add(CreatePfxFld(linkArr[i].fldPC) + ',');
    SQL.Add(CreatePfxFld(linkArr[High(linkArr)].fldPC) + ' from ' + tbInfo.GetTableName);
    SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_exeMin) + ' >= ''0''');
    SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));
    if PCcondition <> '' then
      SQL.Add(PCcondition);
    Open;

    // Cache TField references once before loop
    sf_preqNo        := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_preqNo));
    sf_StepId        := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_PStepId));
    sf_substId       := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_psubstId));
    sf_reprocNo      := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_reprocNo));
    sf_StepIsGrouped := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_StepIsGrouped));
    sf_stGroup       := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_stGroup));
    sf_schedType     := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_schedType));
    sf_rsc           := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_rsc));
    sf_wkCtrCode     := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_wkCtrCode));
    sf_subLinRscId   := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_subLinRscId));
    sf_NumSubRsc     := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_NumSubRscComponents));
    sf_quant         := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_quant));
    sf_ProdUMCode    := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProdUMCode));
    sf_supMinOvlp    := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_supMinOvlp));
    sf_supMinReal    := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_supMinReal));
    sf_exeMin        := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_exeMin));
    sf_schedStart    := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_schedStart));
    sf_schedEnd      := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_schedEnd));
    sf_Comment       := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_Comment));
    sf_NewPreqUniqId := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_NewPreqUniqId));
    sf_SplitFamaly   := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_SplitFamaly));
    if Exist_Actual_Start_End then
    begin
      sf_ActualStart := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ActualStart));
      sf_ActualEnd   := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ActualEnd));
    end;
    if ScheduleMQMORMCM = 'MCM' then
      sf_MqmEnv := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_Mqm_environment));

    while not eof do
    begin
      Request := Trim(sf_preqNo.AsString);
      ConvertToCopmanyCounterCode(Request,CompCod,Counter,Code);
      new(MQMPRODSCHED);
      MQMPRODSCHED.REQUEST     := Request;
      MQMPRODSCHED.COMPANYCODE := CompCod;
      MQMPRODSCHED.COUNTERCODE := Counter;
      MQMPRODSCHED.CODE        := Code;
      MQMPRODSCHED.STEPNUMBER  := sf_StepId.AsInteger;
      MQMPRODSCHED.SUBSTEP     := sf_substId.AsInteger;
      MQMPRODSCHED.REPROCESS   := sf_reprocNo.AsInteger;
      MQMPRODSCHED.CANGROUP    := Trim(sf_StepIsGrouped.AsString);
      MQMPRODSCHED.GROUPNUMBER := IntToStr(sf_stGroup.AsInteger);
      MQMPRODSCHED.SCHEDULETYPE    := Trim(sf_schedType.AsString);
      MQMPRODSCHED.SCHEDULEDRESOURCECODE         := Trim(sf_rsc.AsString);
      if (MQMPRODSCHED.SCHEDULEDRESOURCECODE <> '') then
        MQMPRODSCHED.SCHEDULEWORKCENTERCODE        := Trim(FindWorkCenterByCode(MQMPRODSCHED.SCHEDULEDRESOURCECODE))   //Trim(GetWorkCenterFromRes(MQMPRODSCHED.SCHEDULEDRESOURCECODE))
      else
        MQMPRODSCHED.SCHEDULEWORKCENTERCODE        := Trim(sf_wkCtrCode.AsString);

      if (MQMPRODSCHED.SCHEDULETYPE = '0') or (MQMPRODSCHED.SCHEDULETYPE = '') then
      begin
        MQMPRODSCHED.SCHEDULEDRESOURCECODE := '';
        MQMPRODSCHED.SCHEDULEWORKCENTERCODE := ''
      end;
      if HIGHLEVELSCHEDULE_MQM_OR_MCM = '1' then
         MQMPRODSCHED.SCHEDULEDRESOURCECODE := '';

      MQMPRODSCHED.SCHEDULEDRESOURCESUBLINE      := sf_subLinRscId.AsInteger;
      MQMPRODSCHED.NUMBEROFRESOURCECOMPONENTS    := sf_NumSubRsc.AsInteger;
      MQMPRODSCHED.QUANTITYINPRIMARYUOM          := sf_quant.AsFloat;
      MQMPRODSCHED.PRIMARYUOMCODE                := Trim(sf_ProdUMCode.AsString);
      MQMPRODSCHED.SETUPTIMEBEFOREMATERIAL       := sf_supMinOvlp.AsFloat;
      MQMPRODSCHED.SETUPTIMEAFTERMATERIAL        := sf_supMinReal.AsFloat - MQMPRODSCHED.SETUPTIMEBEFOREMATERIAL;
   //   MQMPRODSCHED.SETUPTIMEAFTERMATERIAL        := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_supMinBase)).AsFloat;
      MQMPRODSCHED.EXECUTIONTIME                 := sf_exeMin.AsFloat;
      if MQMPRODSCHED.EXECUTIONTIME > 9999999 then
         MQMPRODSCHED.EXECUTIONTIME := 9999999;
      if IniAppGlobals.DownloadFrom = '0' then
        ConvertDateFormat := 1
      else if IniAppGlobals.DownloadFrom = '1' then
        ConvertDateFormat := 2
      else
        ConvertDateFormat := 1;

      INITIALSCHEDULEDDATETIME := sf_schedStart.AsDatetime;
      MQMPRODSCHED.INITIALSCHEDULEDDATE := ConvertDate_FormatTo(Trunc(INITIALSCHEDULEDDATETIME), ConvertDateFormat);
      MQMPRODSCHED.INITIALSCHEDULEDTIME := ConvertTime_FormatTo(Frac(INITIALSCHEDULEDDATETIME), ConvertDateFormat);

      FINALSCHEDULEDDATETIME := sf_schedEnd.AsDatetime;
      MQMPRODSCHED.FINALSCHEDULEDDATE := ConvertDate_FormatTo(Trunc(FINALSCHEDULEDDATETIME), ConvertDateFormat);
      MQMPRODSCHED.FINALSCHEDULEDTIME := ConvertTime_FormatTo(Frac(FINALSCHEDULEDDATETIME), ConvertDateFormat);

      if Exist_Actual_Start_End then
      begin
        INITIALSCHEDULEDDATEACTUALTIME := sf_ActualStart.AsDatetime;
        FINALSCHEDULEDDATEACTUALTIME := sf_ActualEnd.AsDatetime;

        if (INITIALSCHEDULEDDATEACTUALTIME = 0) or (FINALSCHEDULEDDATEACTUALTIME = 0) then
        begin
          if ConvertDateFormat = 2 then
          begin
            MQMPRODSCHED.INITIALSCHEDULEDACTUALDATE := ConvertDate_FormatTo(Trunc(INITIALSCHEDULEDDATEACTUALTIME), ConvertDateFormat);
            MQMPRODSCHED.INITIALSCHEDULEDACTUALTIME := ConvertTime_FormatTo(Frac(INITIALSCHEDULEDDATEACTUALTIME), ConvertDateFormat);
            MQMPRODSCHED.FINALSCHEDULEDACTUALDATE := ConvertDate_FormatTo(Trunc(FINALSCHEDULEDDATEACTUALTIME), ConvertDateFormat);
            MQMPRODSCHED.FINALSCHEDULEDACTUALTIME := ConvertTime_FormatTo(Frac(FINALSCHEDULEDDATEACTUALTIME), ConvertDateFormat);
          end
          else
          begin
            MQMPRODSCHED.INITIALSCHEDULEDACTUALDATE := '';
            MQMPRODSCHED.INITIALSCHEDULEDACTUALTIME := '';
            MQMPRODSCHED.FINALSCHEDULEDACTUALDATE := '';
            MQMPRODSCHED.FINALSCHEDULEDACTUALTIME := ''
          end;
        end
        else
        begin
          MQMPRODSCHED.INITIALSCHEDULEDACTUALDATE := ConvertDate_FormatTo(Trunc(INITIALSCHEDULEDDATEACTUALTIME), ConvertDateFormat);
          MQMPRODSCHED.INITIALSCHEDULEDACTUALTIME := ConvertTime_FormatTo(Frac(INITIALSCHEDULEDDATEACTUALTIME), ConvertDateFormat);
          MQMPRODSCHED.FINALSCHEDULEDACTUALDATE := ConvertDate_FormatTo(Trunc(FINALSCHEDULEDDATEACTUALTIME), ConvertDateFormat);
          MQMPRODSCHED.FINALSCHEDULEDACTUALTIME := ConvertTime_FormatTo(Frac(FINALSCHEDULEDDATEACTUALTIME), ConvertDateFormat);
        end;

      end;

      MQMPRODSCHED.PLANNERCOMMENT                := Trim(sf_Comment.AsString);
      MQMPRODSCHED.NewDemandUniqueId             := Trim(sf_NewPreqUniqId.AsString);
      MQMPRODSCHED.SPLITFAMILY                   := Trim(sf_SplitFamaly.AsString);
      if ScheduleMQMORMCM = 'MCM' then
        MQMPRODSCHED.MQM_ENV := Trim(sf_MqmEnv.AsString);
      SrvSchedList.Add(MQMPRODSCHED);
      Next
    end;
    SrvSchedList.Sort(SortPSHost);
  end;

//  if Check_FamilyStructureInNow then
//    PrepareChildsDataFromFamily(SrvSchedList);

  UpdateOperation(_('Reading host schedule - ' + ScheduleMQMORMCM + ' ... '));

  with HostQry do
  begin

    if IniAppGlobals.DownloadFrom = '0' then
      ConvertDateFormat := 1
    else if IniAppGlobals.DownloadFrom = '1' then
      ConvertDateFormat := 2
    else
      ConvertDateFormat := 1;

    if ConvertDateFormat = 1 then
    begin
      if Exist_COUNTERCOMPANYCODE then
        srvSqlStr := 'SELECT COMPANYCODE, COUNTERCOMPANYCODE, COUNTERCODE, CODE, STEPNUMBER, SUBSTEP, '
      else
        srvSqlStr := 'SELECT COMPANYCODE, COUNTERCODE, CODE, STEPNUMBER, SUBSTEP, ';
      srvSqlStr := srvSqlStr + 'REPROCESS, CANGROUP, GROUPNUMBER, SCHEDULETYPE, ';
      srvSqlStr := srvSqlStr + 'SCHEDULEDWORKCENTERCODE, SCHEDULEDRESOURCECODE, ';
      srvSqlStr := srvSqlStr + 'SCHEDULEDRESOURCESUBLINE, NUMBEROFRESOURCECOMPONENTS, ';
      srvSqlStr := srvSqlStr + 'QUANTITYINPRIMARYUOM, PRIMARYUOMCODE, SETUPTIMEBEFOREMATERIAL, ';
      srvSqlStr := srvSqlStr + 'SETUPTIMEAFTERMATERIAL, EXECUTIONTIME, INITIALSCHEDULEDDATE, INITIALSCHEDULEDTIME, ';
      srvSqlStr := srvSqlStr + 'FINALSCHEDULEDDATE,FINALSCHEDULEDTIME, PLANNERCOMMENT, NEWDEMANDUNIQUEID, ';
      if Exist_Actual_Start_End then
        srvSqlStr := srvSqlStr + 'INITIALSCHEDULEDACTUALDATE, INITIALSCHEDULEDACTUALTIME, FINALSCHEDULEDACTUALDATE, FINALSCHEDULEDACTUALTIME, ';
      srvSqlStr := srvSqlStr + 'SPLITFAMILY FROM SCHEDULESOFSTEPSPLITS ';
      srvSqlStr := srvSqlStr + 'WHERE COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ';
      if IniAppGlobals.EnvironmentCode <> '' then
        srvSqlStr := srvSqlStr + 'AND ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' ';

      if Exist_HIGHLEVELSCHEDULE then
        srvSqlStr := srvSqlStr + ' AND ' + 'HIGHLEVELSCHEDULE = ' + QuotedStr(HIGHLEVELSCHEDULE_MQM_OR_MCM) + ' ';

      srvSqlStr := srvSqlStr + 'ORDER BY COMPANYCODE,COUNTERCODE, CODE, STEPNUMBER, SUBSTEP, REPROCESS';
    end
    else if ConvertDateFormat = 2 then
    begin
      if Exist_COUNTERCOMPANYCODE then
        srvSqlStr := 'SELECT COMPANYCODE, COUNTERCOMPANYCODE, COUNTERCODE, CODE, STEPNUMBER, SUBSTEP, '
      else
        srvSqlStr := 'SELECT COMPANYCODE, COUNTERCODE, CODE, STEPNUMBER, SUBSTEP, ';
      srvSqlStr := srvSqlStr + 'REPROCESS, CANGROUP, GROUPNUMBER, SCHEDULETYPE, ';
      srvSqlStr := srvSqlStr + 'SCHEDULEDWORKCENTERCODE, SCHEDULEDRESOURCECODE, ';
      srvSqlStr := srvSqlStr + 'SCHEDULEDRESOURCESUBLINE, NUMBEROFRESOURCECOMPONENTS, ';
      srvSqlStr := srvSqlStr + 'QUANTITYINPRIMARYUOM, PRIMARYUOMCODE, SETUPTIMEBEFOREMATERIAL, ';
      srvSqlStr := srvSqlStr + 'SETUPTIMEAFTERMATERIAL, EXECUTIONTIME, INITIALSCHEDULEDDATE, ';
      srvSqlStr := srvSqlStr + 'TO_CHAR(INITIALSCHEDULEDTIME,'+ QuotedStr('HH24:MI:SS')+')' + '"INITIALSCHEDULEDTIME", ';
      srvSqlStr := srvSqlStr + 'FINALSCHEDULEDDATE, ';
      srvSqlStr := srvSqlStr + 'TO_CHAR(FINALSCHEDULEDTIME,'+ QuotedStr('HH24:MI:SS')+')' + '"FINALSCHEDULEDTIME", ';
      srvSqlStr := srvSqlStr + 'PLANNERCOMMENT, NEWDEMANDUNIQUEID, ';
      if Exist_Actual_Start_End then
        srvSqlStr := srvSqlStr + 'INITIALSCHEDULEDACTUALDATE, INITIALSCHEDULEDACTUALTIME, FINALSCHEDULEDACTUALDATE, FINALSCHEDULEDACTUALTIME, ';
      srvSqlStr := srvSqlStr + 'SPLITFAMILY FROM SCHEDULESOFSTEPSPLITS ';
      srvSqlStr := srvSqlStr + 'WHERE COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ';
      if IniAppGlobals.EnvironmentCode <> '' then
        srvSqlStr := srvSqlStr + 'AND ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' ';
      if Exist_HIGHLEVELSCHEDULE then
        srvSqlStr := srvSqlStr + ' AND ' + 'HIGHLEVELSCHEDULE = ' + QuotedStr(HIGHLEVELSCHEDULE_MQM_OR_MCM) + ' ';

      srvSqlStr := srvSqlStr + 'ORDER BY COMPANYCODE,COUNTERCODE, CODE, STEPNUMBER, SUBSTEP, REPROCESS';
    end;

    SQL.Text := srvSqlStr;

    HostQry.Open;

    // Cache TField references once before loop
    hf_Company     := HostQry.FieldByName('COMPANYCODE');
    hf_Counter     := HostQry.FieldByName('COUNTERCODE');
    hf_Code        := HostQry.FieldByName('CODE');
    hf_Step        := HostQry.FieldByName('STEPNUMBER');
    hf_SubStep     := HostQry.FieldByName('SUBSTEP');
    hf_Reprocess   := HostQry.FieldByName('REPROCESS');
    hf_CanGroup    := HostQry.FieldByName('CANGROUP');
    hf_GroupNum    := HostQry.FieldByName('GROUPNUMBER');
    hf_SchedType   := HostQry.FieldByName('SCHEDULETYPE');
    hf_WC          := HostQry.FieldByName('SCHEDULEDWORKCENTERCODE');
    hf_Rsc         := HostQry.FieldByName('SCHEDULEDRESOURCECODE');
    hf_RscSubLine  := HostQry.FieldByName('SCHEDULEDRESOURCESUBLINE');
    hf_NumRsc      := HostQry.FieldByName('NUMBEROFRESOURCECOMPONENTS');
    hf_Qty         := HostQry.FieldByName('QUANTITYINPRIMARYUOM');
    hf_UOM         := HostQry.FieldByName('PRIMARYUOMCODE');
    hf_SetupBefore := HostQry.FieldByName('SETUPTIMEBEFOREMATERIAL');
    hf_SetupAfter  := HostQry.FieldByName('SETUPTIMEAFTERMATERIAL');
    hf_ExeTime     := HostQry.FieldByName('EXECUTIONTIME');
    hf_InitDate    := HostQry.FieldByName('INITIALSCHEDULEDDATE');
    hf_InitTime    := HostQry.FieldByName('INITIALSCHEDULEDTIME');
    hf_FinalDate   := HostQry.FieldByName('FINALSCHEDULEDDATE');
    hf_FinalTime   := HostQry.FieldByName('FINALSCHEDULEDTIME');
    hf_PlanComment := HostQry.FieldByName('PLANNERCOMMENT');
    hf_NewDemandId := HostQry.FieldByName('NewDemandUniqueId');
    hf_SplitFamily := HostQry.FieldByName('SPLITFAMILY');
    if Exist_Actual_Start_End then
    begin
      hf_ActInitDate  := HostQry.FieldByName('INITIALSCHEDULEDACTUALDATE');
      hf_ActInitTime  := HostQry.FieldByName('INITIALSCHEDULEDACTUALTIME');
      hf_ActFinalDate := HostQry.FieldByName('FINALSCHEDULEDACTUALDATE');
      hf_ActFinalTime := HostQry.FieldByName('FINALSCHEDULEDACTUALTIME');
    end;

    while not HostQry.eof do
    begin
      new(MQMPRODSCHED);
      MQMPRODSCHED.COMPANYCODE := Trim(hf_Company.AsString);
      MQMPRODSCHED.COUNTERCODE := Trim(hf_Counter.AsString);
      MQMPRODSCHED.CODE        := Trim(hf_Code.AsString);
      MQMPRODSCHED.STEPNUMBER  := hf_Step.AsInteger;
      MQMPRODSCHED.SUBSTEP     := hf_SubStep.AsInteger;
      MQMPRODSCHED.REPROCESS   := hf_Reprocess.AsInteger;
      MQMPRODSCHED.CANGROUP    := Trim(hf_CanGroup.AsString);
      MQMPRODSCHED.GROUPNUMBER := '0';
      if Trim(hf_GroupNum.AsString) <> '' then
        MQMPRODSCHED.GROUPNUMBER := Trim(hf_GroupNum.AsString);
      MQMPRODSCHED.SCHEDULETYPE    := Trim(hf_SchedType.AsString);
      MQMPRODSCHED.SCHEDULEWORKCENTERCODE        := Trim(hf_WC.AsString);
      MQMPRODSCHED.SCHEDULEDRESOURCECODE         := Trim(hf_Rsc.AsString);
      MQMPRODSCHED.SCHEDULEDRESOURCESUBLINE      := hf_RscSubLine.AsInteger;
      MQMPRODSCHED.NUMBEROFRESOURCECOMPONENTS    := hf_NumRsc.AsInteger;
      MQMPRODSCHED.QUANTITYINPRIMARYUOM          := hf_Qty.AsFloat;
      MQMPRODSCHED.PRIMARYUOMCODE                := Trim(hf_UOM.AsString);
      MQMPRODSCHED.SETUPTIMEBEFOREMATERIAL       := hf_SetupBefore.AsFloat;
      MQMPRODSCHED.SETUPTIMEAFTERMATERIAL        := hf_SetupAfter.AsFloat;
      MQMPRODSCHED.EXECUTIONTIME                 := hf_ExeTime.AsFloat;
      if MQMPRODSCHED.EXECUTIONTIME > 9999999 then
           MQMPRODSCHED.EXECUTIONTIME := 9999999;
      if ConvertDateFormat = 1 then
      begin
        MQMPRODSCHED.INITIALSCHEDULEDDATE            := ConvertDate_FormatTo(hf_InitDate.AsDateTime , ConvertDateFormat);
        MQMPRODSCHED.INITIALSCHEDULEDTIME            := ConvertTime_FormatTo(hf_InitTime.AsDateTime , ConvertDateFormat);
        MQMPRODSCHED.FINALSCHEDULEDDATE              := ConvertDate_FormatTo(hf_FinalDate.AsDateTime, ConvertDateFormat);
        MQMPRODSCHED.FINALSCHEDULEDTIME              := ConvertTime_FormatTo(hf_FinalTime.AsDateTime, ConvertDateFormat);
        if Exist_Actual_Start_End then
        begin
          if (hf_ActInitDate.IsNull) or
             (hf_ActFinalDate.IsNull) then
          begin
            MQMPRODSCHED.INITIALSCHEDULEDACTUALDATE            := '';
            MQMPRODSCHED.INITIALSCHEDULEDACTUALTIME            := '';
            MQMPRODSCHED.FINALSCHEDULEDACTUALDATE              := '';
            MQMPRODSCHED.FINALSCHEDULEDACTUALTIME              := '';
          end
          else
          begin
            MQMPRODSCHED.INITIALSCHEDULEDACTUALDATE            := ConvertDate_FormatTo(hf_ActInitDate.AsDateTime , ConvertDateFormat);
            MQMPRODSCHED.INITIALSCHEDULEDACTUALTIME            := ConvertTime_FormatTo(hf_ActInitTime.AsDateTime , ConvertDateFormat);
            MQMPRODSCHED.FINALSCHEDULEDACTUALDATE              := ConvertDate_FormatTo(hf_ActFinalDate.AsDateTime, ConvertDateFormat);
            MQMPRODSCHED.FINALSCHEDULEDACTUALTIME              := ConvertTime_FormatTo(hf_ActFinalTime.AsDateTime, ConvertDateFormat);
          end;
        end;
      end;

      if ConvertDateFormat = 2 then
      begin
        MQMPRODSCHED.INITIALSCHEDULEDDATE            := ConvertDate_FormatTo(hf_InitDate.AsDateTime , ConvertDateFormat);
        Str := Trim(hf_InitTime.AsString);
        if Str = '' then
           MQMPRODSCHED.INITIALSCHEDULEDTIME := ConvertTime_FormatTo(0 , ConvertDateFormat)
        else
          MQMPRODSCHED.INITIALSCHEDULEDTIME  := ConvertTimeToOracle(Str);
        MQMPRODSCHED.FINALSCHEDULEDDATE              := ConvertDate_FormatTo(hf_FinalDate.AsDateTime, ConvertDateFormat);
        Str := hf_FinalTime.AsString;
        if str = '' then
           MQMPRODSCHED.FINALSCHEDULEDTIME := ConvertTime_FormatTo(0 , ConvertDateFormat)
        else
          MQMPRODSCHED.FINALSCHEDULEDTIME    := ConvertTimeToOracle(Str);

        if Exist_Actual_Start_End then
        begin
          MQMPRODSCHED.INITIALSCHEDULEDACTUALDATE            := ConvertDate_FormatTo(hf_ActInitDate.AsDateTime , ConvertDateFormat);
          INITIALSCHEDULEDDATEACTUALTIME                     := hf_ActInitTime.AsDateTime;
          FINALSCHEDULEDDATEACTUALTIME                       := hf_ActFinalTime.AsDateTime;
          Str := Trim(hf_ActInitTime.AsString);
          if Str = '' then
             MQMPRODSCHED.INITIALSCHEDULEDACTUALTIME := ConvertTime_FormatTo(0 , ConvertDateFormat)
          else
          begin
            //MQMPRODSCHED.INITIALSCHEDULEDACTUALTIME  := ConvertTimeToOracle(Str);
            MQMPRODSCHED.INITIALSCHEDULEDACTUALTIME  := ConvertTime_FormatTo(Frac(INITIALSCHEDULEDDATEACTUALTIME), ConvertDateFormat);
          end;

          MQMPRODSCHED.FINALSCHEDULEDACTUALDATE      := ConvertDate_FormatTo(hf_ActFinalDate.AsDateTime, ConvertDateFormat);
          Str := hf_ActFinalTime.AsString;
          if str = '' then
             MQMPRODSCHED.FINALSCHEDULEDACTUALTIME := ConvertTime_FormatTo(0 , ConvertDateFormat)
          else
          begin
            //MQMPRODSCHED.FINALSCHEDULEDACTUALTIME    := ConvertTimeToOracle(Str);
            MQMPRODSCHED.FINALSCHEDULEDACTUALTIME    := ConvertTime_FormatTo(Frac(FINALSCHEDULEDDATEACTUALTIME), ConvertDateFormat);
          end;
        end;

      end;

      MQMPRODSCHED.PLANNERCOMMENT                := trim(hf_PlanComment.AsString);
      MQMPRODSCHED.NewDemandUniqueId             := Trim(hf_NewDemandId.AsString);
      MQMPRODSCHED.SPLITFAMILY                   := Trim(hf_SplitFamily.AsString);
      HostSchedList.Add(MQMPRODSCHED);
      next;
    end;
    Close;
    HostSchedList.Sort(SortPSHost);

 end;

 UpdateOperation(_('Compare and insert modification to host - ' + ScheduleMQMORMCM + ' ... '));

 Index_Host := 0;
 Index_Srv  := 0;
 while true do
 begin

   if (Index_Srv > SrvSchedList.count - 1) and (Index_Host > HostSchedList.count - 1) then break;

   if (Index_Srv > SrvSchedList.count - 1) or

     ((Index_Srv <= SrvSchedList.count - 1) and  not (Index_Host > HostSchedList.count - 1) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).COMPANYCODE > pMQMPRODSCHED(HostSchedList[Index_Host]).COMPANYCODE)) or

     ((Index_Srv <= SrvSchedList.count - 1) and  not (Index_Host > HostSchedList.count - 1) and
      (pMQMPRODSCHED(SrvSchedList[Index_srv]).COMPANYCODE = pMQMPRODSCHED(HostSchedList[Index_Host]).COMPANYCODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).COUNTERCODE > pMQMPRODSCHED(HostSchedList[Index_Host]).COUNTERCODE)) or

     ((Index_Srv <= SrvSchedList.count - 1) and  not (Index_Host > HostSchedList.count - 1) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).COMPANYCODE = pMQMPRODSCHED(HostSchedList[Index_Host]).COMPANYCODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).COUNTERCODE = pMQMPRODSCHED(HostSchedList[Index_Host]).COUNTERCODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).CODE > pMQMPRODSCHED(HostSchedList[Index_Host]).CODE)) or

     ((Index_Srv <= SrvSchedList.count - 1) and  not (Index_Host > HostSchedList.count - 1) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).COMPANYCODE = pMQMPRODSCHED(HostSchedList[Index_Host]).COMPANYCODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).COUNTERCODE  = pMQMPRODSCHED(HostSchedList[Index_Host]).COUNTERCODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).CODE = pMQMPRODSCHED(HostSchedList[Index_Host]).CODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).STEPNUMBER > pMQMPRODSCHED(HostSchedList[Index_Host]).STEPNUMBER)) or

     ((Index_Srv <= SrvSchedList.count - 1) and not (Index_Host > HostSchedList.count - 1) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).COMPANYCODE = pMQMPRODSCHED(HostSchedList[Index_Host]).COMPANYCODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).COUNTERCODE  = pMQMPRODSCHED(HostSchedList[Index_Host]).COUNTERCODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).CODE = pMQMPRODSCHED(HostSchedList[Index_Host]).CODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).STEPNUMBER = pMQMPRODSCHED(HostSchedList[Index_Host]).STEPNUMBER) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).SUBSTEP > pMQMPRODSCHED(HostSchedList[Index_Host]).SUBSTEP)) or

     ((Index_Srv <= SrvSchedList.count - 1) and not (Index_Host > HostSchedList.count - 1) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).COMPANYCODE = pMQMPRODSCHED(HostSchedList[Index_Host]).COMPANYCODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).COUNTERCODE = pMQMPRODSCHED(HostSchedList[Index_Host]).COUNTERCODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).CODE = pMQMPRODSCHED(HostSchedList[Index_Host]).CODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).STEPNUMBER = pMQMPRODSCHED(HostSchedList[Index_Host]).STEPNUMBER) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).SUBSTEP = pMQMPRODSCHED(HostSchedList[Index_Host]).SUBSTEP) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).REPROCESS > pMQMPRODSCHED(HostSchedList[Index_Host]).REPROCESS)) then
    begin
      // to be deleted
      new(MQMPRODSCHED);
      MQMPRODSCHED.COMPANYCODE := pMQMPRODSCHED(HostSchedList[Index_Host]).COMPANYCODE;
      MQMPRODSCHED.COUNTERCODE := pMQMPRODSCHED(HostSchedList[Index_Host]).COUNTERCODE;
      MQMPRODSCHED.CODE        := pMQMPRODSCHED(HostSchedList[Index_Host]).CODE;
      MQMPRODSCHED.STEPNUMBER  := pMQMPRODSCHED(HostSchedList[Index_Host]).STEPNUMBER;
      MQMPRODSCHED.SUBSTEP     := pMQMPRODSCHED(HostSchedList[Index_Host]).SUBSTEP;
      MQMPRODSCHED.REPROCESS   := pMQMPRODSCHED(HostSchedList[Index_Host]).REPROCESS;
      MQMPRODSCHED.CANGROUP    := pMQMPRODSCHED(HostSchedList[Index_Host]).CANGROUP;
      MQMPRODSCHED.GROUPNUMBER := pMQMPRODSCHED(HostSchedList[Index_Host]).GROUPNUMBER;
      MQMPRODSCHED.SCHEDULETYPE    := pMQMPRODSCHED(HostSchedList[Index_Host]).SCHEDULETYPE;
      MQMPRODSCHED.SCHEDULEWORKCENTERCODE        := pMQMPRODSCHED(HostSchedList[Index_Host]).SCHEDULEWORKCENTERCODE;
      MQMPRODSCHED.SCHEDULEDRESOURCECODE         := pMQMPRODSCHED(HostSchedList[Index_Host]).SCHEDULEDRESOURCECODE;
      MQMPRODSCHED.SCHEDULEDRESOURCESUBLINE      := pMQMPRODSCHED(HostSchedList[Index_Host]).SCHEDULEDRESOURCESUBLINE;
      MQMPRODSCHED.NUMBEROFRESOURCECOMPONENTS    := pMQMPRODSCHED(HostSchedList[Index_Host]).NUMBEROFRESOURCECOMPONENTS;
      MQMPRODSCHED.QUANTITYINPRIMARYUOM          := pMQMPRODSCHED(HostSchedList[Index_Host]).QUANTITYINPRIMARYUOM;
      MQMPRODSCHED.PRIMARYUOMCODE                := pMQMPRODSCHED(HostSchedList[Index_Host]).PRIMARYUOMCODE;
      MQMPRODSCHED.SETUPTIMEBEFOREMATERIAL       := pMQMPRODSCHED(HostSchedList[Index_Host]).SETUPTIMEBEFOREMATERIAL;
      MQMPRODSCHED.SETUPTIMEAFTERMATERIAL        := pMQMPRODSCHED(HostSchedList[Index_Host]).SETUPTIMEAFTERMATERIAL;
      MQMPRODSCHED.EXECUTIONTIME                 := pMQMPRODSCHED(HostSchedList[Index_Host]).EXECUTIONTIME;
      MQMPRODSCHED.INITIALSCHEDULEDDATE          := pMQMPRODSCHED(HostSchedList[Index_Host]).INITIALSCHEDULEDDATE;
      MQMPRODSCHED.INITIALSCHEDULEDTIME          := pMQMPRODSCHED(HostSchedList[Index_Host]).INITIALSCHEDULEDTIME;
      MQMPRODSCHED.FINALSCHEDULEDDATE            := pMQMPRODSCHED(HostSchedList[Index_Host]).FINALSCHEDULEDDATE;
      MQMPRODSCHED.FINALSCHEDULEDTIME            := pMQMPRODSCHED(HostSchedList[Index_Host]).FINALSCHEDULEDTIME;
      MQMPRODSCHED.INITIALSCHEDULEDACTUALDATE    := pMQMPRODSCHED(HostSchedList[Index_Host]).INITIALSCHEDULEDACTUALDATE;
      MQMPRODSCHED.INITIALSCHEDULEDACTUALTIME    := pMQMPRODSCHED(HostSchedList[Index_Host]).INITIALSCHEDULEDACTUALTIME;
      MQMPRODSCHED.FINALSCHEDULEDACTUALDATE      := pMQMPRODSCHED(HostSchedList[Index_Host]).FINALSCHEDULEDACTUALDATE;
      MQMPRODSCHED.FINALSCHEDULEDACTUALTIME      := pMQMPRODSCHED(HostSchedList[Index_Host]).FINALSCHEDULEDACTUALTIME;
      MQMPRODSCHED.PLANNERCOMMENT                := pMQMPRODSCHED(HostSchedList[Index_Host]).PLANNERCOMMENT;
      MQMPRODSCHED.NewDemandUniqueId             := pMQMPRODSCHED(HostSchedList[Index_Host]).NewDemandUniqueId;
      MQMPRODSCHED.SPLITFAMILY                   := pMQMPRODSCHED(HostSchedList[Index_Host]).SPLITFAMILY;
      MQMPRODSCHED.ChangedType := '3';
      if MQMPRODSCHED.QUANTITYINPRIMARYUOM > 0 then
        List_To_Be_insert.Add(MQMPRODSCHED)
      else if (MQMPRODSCHED.SCHEDULEDRESOURCECODE = '') and (MQMPRODSCHED.QUANTITYINPRIMARYUOM = 0) and (MQMPRODSCHED.SCHEDULEWORKCENTERCODE <> '') then
        List_To_Be_insert.Add(MQMPRODSCHED); // for mcm
      Inc(Index_Host);
      continue
    end;

    //  if (Index_Srv > SrvSchedList.count - 1) or

    if (HostSchedList.count = 0) or (Index_Host > HostSchedList.count - 1) or

     ((Index_Srv <= SrvSchedList.count - 1) and (not (Index_Host > HostSchedList.count - 1)) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).COMPANYCODE < pMQMPRODSCHED(HostSchedList[Index_Host]).COMPANYCODE)) or

     ((Index_Srv <= SrvSchedList.count - 1) and (not (Index_Host > HostSchedList.count - 1)) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).COMPANYCODE = pMQMPRODSCHED(HostSchedList[Index_Host]).COMPANYCODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).COUNTERCODE < pMQMPRODSCHED(HostSchedList[Index_Host]).COUNTERCODE)) or

     ((Index_Srv <= SrvSchedList.count - 1) and (not (Index_Host > HostSchedList.count - 1)) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).COMPANYCODE = pMQMPRODSCHED(HostSchedList[Index_Host]).COMPANYCODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).COUNTERCODE = pMQMPRODSCHED(HostSchedList[Index_Host]).COUNTERCODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).CODE < pMQMPRODSCHED(HostSchedList[Index_Host]).CODE)) or

     ((Index_Srv <= SrvSchedList.count - 1) and (not (Index_Host > HostSchedList.count - 1)) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).COMPANYCODE = pMQMPRODSCHED(HostSchedList[Index_Host]).COMPANYCODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).COUNTERCODE = pMQMPRODSCHED(HostSchedList[Index_Host]).COUNTERCODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).CODE = pMQMPRODSCHED(HostSchedList[Index_Host]).CODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).STEPNUMBER < pMQMPRODSCHED(HostSchedList[Index_Host]).STEPNUMBER)) or

     ((Index_Srv <= SrvSchedList.count - 1) and (not (Index_Host > HostSchedList.count - 1)) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).COMPANYCODE = pMQMPRODSCHED(HostSchedList[Index_Host]).COMPANYCODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).COUNTERCODE = pMQMPRODSCHED(HostSchedList[Index_Host]).COUNTERCODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).CODE = pMQMPRODSCHED(HostSchedList[Index_Host]).CODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).STEPNUMBER = pMQMPRODSCHED(HostSchedList[Index_Host]).STEPNUMBER) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).SUBSTEP < pMQMPRODSCHED(HostSchedList[Index_Host]).SUBSTEP)) or

     ((Index_Srv <= SrvSchedList.count - 1) and (not (Index_Host > HostSchedList.count - 1)) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).COMPANYCODE = pMQMPRODSCHED(HostSchedList[Index_Host]).COMPANYCODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).COUNTERCODE = pMQMPRODSCHED(HostSchedList[Index_Host]).COUNTERCODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).CODE = pMQMPRODSCHED(HostSchedList[Index_Host]).CODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).STEPNUMBER = pMQMPRODSCHED(HostSchedList[Index_Host]).STEPNUMBER) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).SUBSTEP = pMQMPRODSCHED(HostSchedList[Index_Host]).SUBSTEP) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).REPROCESS < pMQMPRODSCHED(HostSchedList[Index_Host]).REPROCESS)) then

    begin

      if ScheduleMQMORMCM = 'MCM' then
      begin
        if pMQMPRODSCHED(SrvSchedList[Index_Srv]).MQM_ENV = '1' then
        begin
          Inc(Index_Srv);
          continue
        end;
      end;

      // To be insert
      new(MQMPRODSCHED);
      MQMPRODSCHED.COMPANYCODE := pMQMPRODSCHED(SrvSchedList[Index_Srv]).COMPANYCODE;
      MQMPRODSCHED.COUNTERCODE := pMQMPRODSCHED(SrvSchedList[Index_Srv]).COUNTERCODE;
      MQMPRODSCHED.CODE        := pMQMPRODSCHED(SrvSchedList[Index_Srv]).CODE;
      MQMPRODSCHED.STEPNUMBER  := pMQMPRODSCHED(SrvSchedList[Index_Srv]).STEPNUMBER;
      MQMPRODSCHED.SUBSTEP     := pMQMPRODSCHED(SrvSchedList[Index_Srv]).SUBSTEP;
      MQMPRODSCHED.REPROCESS   := pMQMPRODSCHED(SrvSchedList[Index_Srv]).REPROCESS;
      MQMPRODSCHED.CANGROUP    := pMQMPRODSCHED(SrvSchedList[Index_Srv]).CANGROUP;
      MQMPRODSCHED.GROUPNUMBER := pMQMPRODSCHED(SrvSchedList[Index_Srv]).GROUPNUMBER;
      MQMPRODSCHED.SCHEDULETYPE    := pMQMPRODSCHED(SrvSchedList[Index_Srv]).SCHEDULETYPE;
      MQMPRODSCHED.SCHEDULEWORKCENTERCODE        := pMQMPRODSCHED(SrvSchedList[Index_Srv]).SCHEDULEWORKCENTERCODE;
      MQMPRODSCHED.SCHEDULEDRESOURCECODE         := pMQMPRODSCHED(SrvSchedList[Index_Srv]).SCHEDULEDRESOURCECODE;
      MQMPRODSCHED.SCHEDULEDRESOURCESUBLINE      := pMQMPRODSCHED(SrvSchedList[Index_Srv]).SCHEDULEDRESOURCESUBLINE;
      MQMPRODSCHED.NUMBEROFRESOURCECOMPONENTS    := pMQMPRODSCHED(SrvSchedList[Index_Srv]).NUMBEROFRESOURCECOMPONENTS;
      MQMPRODSCHED.QUANTITYINPRIMARYUOM          := pMQMPRODSCHED(SrvSchedList[Index_Srv]).QUANTITYINPRIMARYUOM;
      MQMPRODSCHED.PRIMARYUOMCODE                := pMQMPRODSCHED(SrvSchedList[Index_Srv]).PRIMARYUOMCODE;
      MQMPRODSCHED.SETUPTIMEBEFOREMATERIAL       := pMQMPRODSCHED(SrvSchedList[Index_Srv]).SETUPTIMEBEFOREMATERIAL;
      MQMPRODSCHED.SETUPTIMEAFTERMATERIAL        := pMQMPRODSCHED(SrvSchedList[Index_Srv]).SETUPTIMEAFTERMATERIAL;
      MQMPRODSCHED.EXECUTIONTIME                 := pMQMPRODSCHED(SrvSchedList[Index_Srv]).EXECUTIONTIME;
      MQMPRODSCHED.INITIALSCHEDULEDDATE          := pMQMPRODSCHED(SrvSchedList[Index_Srv]).INITIALSCHEDULEDDATE;
      MQMPRODSCHED.INITIALSCHEDULEDTIME          := pMQMPRODSCHED(SrvSchedList[Index_Srv]).INITIALSCHEDULEDTIME;
      MQMPRODSCHED.FINALSCHEDULEDDATE            := pMQMPRODSCHED(SrvSchedList[Index_Srv]).FINALSCHEDULEDDATE;
      MQMPRODSCHED.FINALSCHEDULEDTIME            := pMQMPRODSCHED(SrvSchedList[Index_Srv]).FINALSCHEDULEDTIME;
      MQMPRODSCHED.INITIALSCHEDULEDACTUALDATE    := pMQMPRODSCHED(SrvSchedList[Index_Srv]).INITIALSCHEDULEDACTUALDATE;
      MQMPRODSCHED.INITIALSCHEDULEDACTUALTIME    := pMQMPRODSCHED(SrvSchedList[Index_Srv]).INITIALSCHEDULEDACTUALTIME;
      MQMPRODSCHED.FINALSCHEDULEDACTUALDATE      := pMQMPRODSCHED(SrvSchedList[Index_Srv]).FINALSCHEDULEDACTUALDATE;
      MQMPRODSCHED.FINALSCHEDULEDACTUALTIME      := pMQMPRODSCHED(SrvSchedList[Index_Srv]).FINALSCHEDULEDACTUALTIME;
      MQMPRODSCHED.PLANNERCOMMENT                := pMQMPRODSCHED(SrvSchedList[Index_Srv]).PLANNERCOMMENT;
      MQMPRODSCHED.NewDemandUniqueId             := pMQMPRODSCHED(SrvSchedList[Index_Srv]).NewDemandUniqueId;
      MQMPRODSCHED.SPLITFAMILY                   := pMQMPRODSCHED(SrvSchedList[Index_Srv]).SPLITFAMILY;
      MQMPRODSCHED.ChangedType := '1';

      if MQMPRODSCHED.QUANTITYINPRIMARYUOM > 0 then
        List_To_Be_insert.Add(MQMPRODSCHED)
      else if (MQMPRODSCHED.SCHEDULEDRESOURCECODE = '') and (MQMPRODSCHED.QUANTITYINPRIMARYUOM = 0) and (MQMPRODSCHED.SCHEDULEWORKCENTERCODE <> '') then
        List_To_Be_insert.Add(MQMPRODSCHED); // for mcm
      Inc(Index_Srv);
      continue
    end;

      // Key is equal

    if not Exist_Actual_Start_End then
    begin
      pMQMPRODSCHED(SrvSchedList[Index_Srv]).INITIALSCHEDULEDACTUALDATE := '';
      pMQMPRODSCHED(HostSchedList[Index_Host]).INITIALSCHEDULEDACTUALDATE := '';
      pMQMPRODSCHED(SrvSchedList[Index_Srv]).INITIALSCHEDULEDACTUALTIME := '';
      pMQMPRODSCHED(HostSchedList[Index_Host]).INITIALSCHEDULEDACTUALTIME := '';
      pMQMPRODSCHED(SrvSchedList[Index_Srv]).FINALSCHEDULEDACTUALDATE  := '';
      pMQMPRODSCHED(HostSchedList[Index_Host]).FINALSCHEDULEDACTUALDATE := '';
      pMQMPRODSCHED(SrvSchedList[Index_Srv]).FINALSCHEDULEDACTUALTIME := '';
      pMQMPRODSCHED(HostSchedList[Index_Host]).FINALSCHEDULEDACTUALTIME := '';
    end;

    if (pMQMPRODSCHED(SrvSchedList[Index_Srv]).CANGROUP <> pMQMPRODSCHED(HostSchedList[Index_Host]).CANGROUP) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).GROUPNUMBER <> pMQMPRODSCHED(HostSchedList[Index_Host]).GROUPNUMBER) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).SCHEDULETYPE <> pMQMPRODSCHED(HostSchedList[Index_Host]).SCHEDULETYPE) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).SCHEDULEWORKCENTERCODE <> pMQMPRODSCHED(HostSchedList[Index_Host]).SCHEDULEWORKCENTERCODE) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).SCHEDULEDRESOURCECODE <> pMQMPRODSCHED(HostSchedList[Index_Host]).SCHEDULEDRESOURCECODE) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).SCHEDULEDRESOURCESUBLINE <> pMQMPRODSCHED(HostSchedList[Index_Host]).SCHEDULEDRESOURCESUBLINE) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).NUMBEROFRESOURCECOMPONENTS <> pMQMPRODSCHED(HostSchedList[Index_Host]).NUMBEROFRESOURCECOMPONENTS) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).QUANTITYINPRIMARYUOM <> pMQMPRODSCHED(HostSchedList[Index_Host]).QUANTITYINPRIMARYUOM) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).PRIMARYUOMCODE <> pMQMPRODSCHED(HostSchedList[Index_Host]).PRIMARYUOMCODE) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).SETUPTIMEBEFOREMATERIAL <> pMQMPRODSCHED(HostSchedList[Index_Host]).SETUPTIMEBEFOREMATERIAL) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).SETUPTIMEAFTERMATERIAL <> pMQMPRODSCHED(HostSchedList[Index_Host]).SETUPTIMEAFTERMATERIAL) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).EXECUTIONTIME <> pMQMPRODSCHED(HostSchedList[Index_Host]).EXECUTIONTIME) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).INITIALSCHEDULEDDATE <> pMQMPRODSCHED(HostSchedList[Index_Host]).INITIALSCHEDULEDDATE) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).INITIALSCHEDULEDTIME <> pMQMPRODSCHED(HostSchedList[Index_Host]).INITIALSCHEDULEDTIME) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).FINALSCHEDULEDDATE <> pMQMPRODSCHED(HostSchedList[Index_Host]).FINALSCHEDULEDDATE) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).FINALSCHEDULEDTIME <> pMQMPRODSCHED(HostSchedList[Index_Host]).FINALSCHEDULEDTIME) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).INITIALSCHEDULEDACTUALDATE <> pMQMPRODSCHED(HostSchedList[Index_Host]).INITIALSCHEDULEDACTUALDATE) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).INITIALSCHEDULEDACTUALTIME <> pMQMPRODSCHED(HostSchedList[Index_Host]).INITIALSCHEDULEDACTUALTIME) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).FINALSCHEDULEDACTUALDATE <> pMQMPRODSCHED(HostSchedList[Index_Host]).FINALSCHEDULEDACTUALDATE) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).FINALSCHEDULEDACTUALTIME <> pMQMPRODSCHED(HostSchedList[Index_Host]).FINALSCHEDULEDACTUALTIME) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).PLANNERCOMMENT <> pMQMPRODSCHED(HostSchedList[Index_Host]).PLANNERCOMMENT) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).NewDemandUniqueId <> pMQMPRODSCHED(HostSchedList[Index_Host]).NewDemandUniqueId) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).SPLITFAMILY <> pMQMPRODSCHED(HostSchedList[Index_Host]).SPLITFAMILY) then
    begin

      if ScheduleMQMORMCM = 'MCM' then
      begin
        if pMQMPRODSCHED(SrvSchedList[Index_Srv]).MQM_ENV = '1' then
        begin
          Inc(Index_Host);
          Inc(Index_Srv);
          continue;
        end;
      end;

      new(MQMPRODSCHED);
      MQMPRODSCHED.COMPANYCODE := pMQMPRODSCHED(SrvSchedList[Index_Srv]).COMPANYCODE;
      MQMPRODSCHED.COUNTERCODE := pMQMPRODSCHED(SrvSchedList[Index_Srv]).COUNTERCODE;
      MQMPRODSCHED.CODE        := pMQMPRODSCHED(SrvSchedList[Index_Srv]).CODE;
      MQMPRODSCHED.STEPNUMBER  := pMQMPRODSCHED(SrvSchedList[Index_Srv]).STEPNUMBER;
      MQMPRODSCHED.SUBSTEP     := pMQMPRODSCHED(SrvSchedList[Index_Srv]).SUBSTEP;
      MQMPRODSCHED.REPROCESS   := pMQMPRODSCHED(SrvSchedList[Index_Srv]).REPROCESS;
      MQMPRODSCHED.CANGROUP    := pMQMPRODSCHED(SrvSchedList[Index_Srv]).CANGROUP;
      MQMPRODSCHED.GROUPNUMBER := pMQMPRODSCHED(SrvSchedList[Index_Srv]).GROUPNUMBER;
      MQMPRODSCHED.SCHEDULETYPE    := pMQMPRODSCHED(SrvSchedList[Index_Srv]).SCHEDULETYPE;
      MQMPRODSCHED.SCHEDULEWORKCENTERCODE        := pMQMPRODSCHED(SrvSchedList[Index_Srv]).SCHEDULEWORKCENTERCODE;
      MQMPRODSCHED.SCHEDULEDRESOURCECODE         := pMQMPRODSCHED(SrvSchedList[Index_Srv]).SCHEDULEDRESOURCECODE;
      MQMPRODSCHED.SCHEDULEDRESOURCESUBLINE      := pMQMPRODSCHED(SrvSchedList[Index_Srv]).SCHEDULEDRESOURCESUBLINE;
      MQMPRODSCHED.NUMBEROFRESOURCECOMPONENTS    := pMQMPRODSCHED(SrvSchedList[Index_Srv]).NUMBEROFRESOURCECOMPONENTS;
      MQMPRODSCHED.QUANTITYINPRIMARYUOM          := pMQMPRODSCHED(SrvSchedList[Index_Srv]).QUANTITYINPRIMARYUOM;
      MQMPRODSCHED.PRIMARYUOMCODE                := pMQMPRODSCHED(SrvSchedList[Index_Srv]).PRIMARYUOMCODE;
      MQMPRODSCHED.SETUPTIMEBEFOREMATERIAL       := pMQMPRODSCHED(SrvSchedList[Index_Srv]).SETUPTIMEBEFOREMATERIAL;
      MQMPRODSCHED.SETUPTIMEAFTERMATERIAL        := pMQMPRODSCHED(SrvSchedList[Index_Srv]).SETUPTIMEAFTERMATERIAL;
      MQMPRODSCHED.EXECUTIONTIME                 := pMQMPRODSCHED(SrvSchedList[Index_Srv]).EXECUTIONTIME;
      MQMPRODSCHED.INITIALSCHEDULEDDATE          := pMQMPRODSCHED(SrvSchedList[Index_Srv]).INITIALSCHEDULEDDATE;
      MQMPRODSCHED.INITIALSCHEDULEDTIME          := pMQMPRODSCHED(SrvSchedList[Index_Srv]).INITIALSCHEDULEDTIME;
      MQMPRODSCHED.FINALSCHEDULEDDATE            := pMQMPRODSCHED(SrvSchedList[Index_Srv]).FINALSCHEDULEDDATE;
      MQMPRODSCHED.FINALSCHEDULEDTIME            := pMQMPRODSCHED(SrvSchedList[Index_Srv]).FINALSCHEDULEDTIME;
      MQMPRODSCHED.INITIALSCHEDULEDACTUALDATE    := pMQMPRODSCHED(SrvSchedList[Index_Srv]).INITIALSCHEDULEDACTUALDATE;
      MQMPRODSCHED.INITIALSCHEDULEDACTUALTIME    := pMQMPRODSCHED(SrvSchedList[Index_Srv]).INITIALSCHEDULEDACTUALTIME;
      MQMPRODSCHED.FINALSCHEDULEDACTUALDATE      := pMQMPRODSCHED(SrvSchedList[Index_Srv]).FINALSCHEDULEDACTUALDATE;
      MQMPRODSCHED.FINALSCHEDULEDACTUALTIME      := pMQMPRODSCHED(SrvSchedList[Index_Srv]).FINALSCHEDULEDACTUALTIME;
      MQMPRODSCHED.PLANNERCOMMENT                := pMQMPRODSCHED(SrvSchedList[Index_Srv]).PLANNERCOMMENT;
      MQMPRODSCHED.NewDemandUniqueId             := pMQMPRODSCHED(SrvSchedList[Index_Srv]).NewDemandUniqueId;
      MQMPRODSCHED.SPLITFAMILY                   := pMQMPRODSCHED(SrvSchedList[Index_Srv]).SPLITFAMILY;
      MQMPRODSCHED.ChangedType := '2';
      if MQMPRODSCHED.QUANTITYINPRIMARYUOM > 0 then
        List_To_Be_insert.Add(MQMPRODSCHED)
      else if (MQMPRODSCHED.SCHEDULEDRESOURCECODE = '') and (MQMPRODSCHED.QUANTITYINPRIMARYUOM = 0) and (MQMPRODSCHED.SCHEDULEWORKCENTERCODE <> '') then
        List_To_Be_insert.Add(MQMPRODSCHED); // for mcm
    end;

    Inc(Index_Host);
    Inc(Index_Srv);
  end;

  List_To_Be_update := TList.Create;

  // --- Upsert: a row whose key already exists in SCHEDULESUPLOAD (a leftover that was already
  // imported - importstatus=3, changetype<>'3') is UPDATEd in place instead of INSERTed: all
  // attributes are refreshed from local and IMPORTSTATUS is reset to 0, while CHANGETYPE is left
  // untouched. Only local insert/modify rows (changetype <> '3') are eligible; delete rows never
  // reach here because any leftover delete row blocks the upload in CheckEmptyTableInHost.
  if Assigned(g_ExistingUploadKeys) and (g_ExistingUploadKeys.Count > 0) then
  begin
    for I := List_To_Be_insert.Count - 1 downto 0 do
    begin
      if (pMQMPRODSCHED(List_To_Be_insert[I]).ChangedType <> '3') and
         (g_ExistingUploadKeys.IndexOf(MakeUploadKey(pMQMPRODSCHED(List_To_Be_insert[I]).COMPANYCODE,
                                                     pMQMPRODSCHED(List_To_Be_insert[I]).COUNTERCODE,
                                                     pMQMPRODSCHED(List_To_Be_insert[I]).CODE,
                                                     pMQMPRODSCHED(List_To_Be_insert[I]).STEPNUMBER,
                                                     pMQMPRODSCHED(List_To_Be_insert[I]).SUBSTEP,
                                                     pMQMPRODSCHED(List_To_Be_insert[I]).REPROCESS)) >= 0) then
      begin
        List_To_Be_update.Add(List_To_Be_insert[I]);
        List_To_Be_insert.Delete(I);
      end;
    end;
  end;

  if List_To_Be_update.Count > 0 then
  begin
    with HostQry do
    begin
      // Mirror the INSERT's j-loop so an upsert writes EXACTLY the columns a fresh insert would
      // (and leaves the rest untouched). j = 0 Sched no group, j = 1 Sched+group,
      // j = 2 NoSched no group, j = 3 NoSched grouped.
      for j := 0 to 3 do
      begin
        for I := 0 to List_To_Be_update.count - 1 do
        begin
          if ((J = 0) and (pMQMPRODSCHED(List_To_Be_update[I]).SCHEDULETYPE <> '0') and (pMQMPRODSCHED(List_To_Be_update[I]).GROUPNUMBER = '0'))
          or ((J = 1) and (pMQMPRODSCHED(List_To_Be_update[I]).SCHEDULETYPE <> '0') and (pMQMPRODSCHED(List_To_Be_update[I]).GROUPNUMBER <> '0'))
          or ((j = 2) and (pMQMPRODSCHED(List_To_Be_update[I]).SCHEDULETYPE = '0') and (pMQMPRODSCHED(List_To_Be_update[I]).GROUPNUMBER = '0'))
          or ((j = 3) and (pMQMPRODSCHED(List_To_Be_update[I]).SCHEDULETYPE = '0') and (pMQMPRODSCHED(List_To_Be_update[I]).GROUPNUMBER <> '0')) then
          begin
            HostSqlStr := 'update "SCHEDULESUPLOAD" set ';
            HostSqlStr := HostSqlStr + '"CANGROUP" = ' + QuotedStr(pMQMPRODSCHED(List_To_Be_update[I]).CANGROUP) + DecSep;
            // GROUPNUMBER: written for grouped rows (j=1/3); for non-grouped rows the INSERT omits it
            // (= null on a new row), so on UPDATE we must explicitly set it to null - not leave it stale.
            if (j = 1) or (j = 3) then
              HostSqlStr := HostSqlStr + '"GROUPNUMBER" = ' + QuotedStr(pMQMPRODSCHED(List_To_Be_update[I]).GROUPNUMBER) + DecSep
            else
              HostSqlStr := HostSqlStr + '"GROUPNUMBER" = null' + DecSep;
            HostSqlStr := HostSqlStr + '"SCHEDULETYPE" = ' + QuotedStr(pMQMPRODSCHED(List_To_Be_update[I]).SCHEDULETYPE) + DecSep;
            // SCHEDULEDWORKCENTERCODE: only for scheduled rows (j=0/1); otherwise null (insert omits it).
            if (j = 0) or (j = 1) then
            begin
              if trim(pMQMPRODSCHED(List_To_Be_update[I]).SCHEDULEWORKCENTERCODE) = '' then
                HostSqlStr := HostSqlStr + '"SCHEDULEDWORKCENTERCODE" = null' + DecSep
              else
                HostSqlStr := HostSqlStr + '"SCHEDULEDWORKCENTERCODE" = ' + QuotedStr(pMQMPRODSCHED(List_To_Be_update[I]).SCHEDULEWORKCENTERCODE) + DecSep;
            end
            else
              HostSqlStr := HostSqlStr + '"SCHEDULEDWORKCENTERCODE" = null' + DecSep;
            if HIGHLEVELSCHEDULE_MQM_OR_MCM = '0' then  // mqm only carries the resource code
            begin
              // SCHEDULEDRESOURCECODE: only for scheduled rows (j=0/1); otherwise null (insert omits it).
              if (j = 0) or (j = 1) then
              begin
                if trim(pMQMPRODSCHED(List_To_Be_update[I]).SCHEDULEDRESOURCECODE) = '' then
                  HostSqlStr := HostSqlStr + '"SCHEDULEDRESOURCECODE" = null' + DecSep
                else
                  HostSqlStr := HostSqlStr + '"SCHEDULEDRESOURCECODE" = ' + QuotedStr(pMQMPRODSCHED(List_To_Be_update[I]).SCHEDULEDRESOURCECODE) + DecSep;
              end
              else
                HostSqlStr := HostSqlStr + '"SCHEDULEDRESOURCECODE" = null' + DecSep;
            end;
            HostSqlStr := HostSqlStr + '"SCHEDULEDRESOURCESUBLINE" = ' + IntToStr(pMQMPRODSCHED(List_To_Be_update[I]).SCHEDULEDRESOURCESUBLINE) + DecSep;
            HostSqlStr := HostSqlStr + '"NUMBEROFRESOURCECOMPONENTS" = ' + IntToStr(pMQMPRODSCHED(List_To_Be_update[I]).NUMBEROFRESOURCECOMPONENTS) + DecSep;
            HostSqlStr := HostSqlStr + '"QUANTITYINPRIMARYUOM" = ' + FloatToStr(pMQMPRODSCHED(List_To_Be_update[I]).QUANTITYINPRIMARYUOM) + DecSep;
            HostSqlStr := HostSqlStr + '"PRIMARYUOMCODE" = ' + QuotedStr(pMQMPRODSCHED(List_To_Be_update[I]).PRIMARYUOMCODE) + DecSep;
            HostSqlStr := HostSqlStr + '"SETUPTIMEBEFOREMATERIAL" = ' + FloatToStr(pMQMPRODSCHED(List_To_Be_update[I]).SETUPTIMEBEFOREMATERIAL) + DecSep;
            HostSqlStr := HostSqlStr + '"SETUPTIMEAFTERMATERIAL" = ' + FloatToStr(pMQMPRODSCHED(List_To_Be_update[I]).SETUPTIMEAFTERMATERIAL) + DecSep;
            HostSqlStr := HostSqlStr + '"EXECUTIONTIME" = ' + FloatToStr(pMQMPRODSCHED(List_To_Be_update[I]).EXECUTIONTIME) + DecSep;
            HostSqlStr := HostSqlStr + '"INITIALSCHEDULEDDATE" = ' + pMQMPRODSCHED(List_To_Be_update[I]).INITIALSCHEDULEDDATE + DecSep;
            HostSqlStr := HostSqlStr + '"INITIALSCHEDULEDTIME" = ' + pMQMPRODSCHED(List_To_Be_update[I]).INITIALSCHEDULEDTIME + DecSep;
            HostSqlStr := HostSqlStr + '"FINALSCHEDULEDDATE" = ' + pMQMPRODSCHED(List_To_Be_update[I]).FINALSCHEDULEDDATE + DecSep;
            HostSqlStr := HostSqlStr + '"FINALSCHEDULEDTIME" = ' + pMQMPRODSCHED(List_To_Be_update[I]).FINALSCHEDULEDTIME + DecSep;
            if Exist_Actual_Start_End then
            begin
              if pMQMPRODSCHED(List_To_Be_update[I]).INITIALSCHEDULEDACTUALDATE = '' then
              begin
                HostSqlStr := HostSqlStr + '"INITIALSCHEDULEDACTUALDATE" = null' + DecSep;
                HostSqlStr := HostSqlStr + '"INITIALSCHEDULEDACTUALTIME" = null' + DecSep;
                HostSqlStr := HostSqlStr + '"FINALSCHEDULEDACTUALDATE" = null' + DecSep;
                HostSqlStr := HostSqlStr + '"FINALSCHEDULEDACTUALTIME" = null' + DecSep;
              end
              else
              begin
                HostSqlStr := HostSqlStr + '"INITIALSCHEDULEDACTUALDATE" = ' + pMQMPRODSCHED(List_To_Be_update[I]).INITIALSCHEDULEDACTUALDATE + DecSep;
                HostSqlStr := HostSqlStr + '"INITIALSCHEDULEDACTUALTIME" = ' + pMQMPRODSCHED(List_To_Be_update[I]).INITIALSCHEDULEDACTUALTIME + DecSep;
                HostSqlStr := HostSqlStr + '"FINALSCHEDULEDACTUALDATE" = ' + pMQMPRODSCHED(List_To_Be_update[I]).FINALSCHEDULEDACTUALDATE + DecSep;
                HostSqlStr := HostSqlStr + '"FINALSCHEDULEDACTUALTIME" = ' + pMQMPRODSCHED(List_To_Be_update[I]).FINALSCHEDULEDACTUALTIME + DecSep;
              end;
            end;
            HostSqlStr := HostSqlStr + '"PLANNERCOMMENT" = ' + QuotedStr(pMQMPRODSCHED(List_To_Be_update[I]).PLANNERCOMMENT) + DecSep;
            HostSqlStr := HostSqlStr + '"NEWDEMANDUNIQUEID" = ' + QuotedStr(pMQMPRODSCHED(List_To_Be_update[I]).NewDemandUniqueId) + DecSep;
            HostSqlStr := HostSqlStr + '"SPLITFAMILY" = ' + QuotedStr(pMQMPRODSCHED(List_To_Be_update[I]).SPLITFAMILY) + DecSep;
            HostSqlStr := HostSqlStr + '"IMPORTSTATUS" = ' + IntToStr(0);
            // CHANGETYPE intentionally NOT touched - keep the existing value.
            HostSqlStr := SetDecSeparator(HostSqlStr);

            // WHERE clause (key) is built separately - no floats/value separators, so it must not pass through SetDecSeparator.
            HostSqlStrVal := ' where "COMPANYCODE" = ' + QuotedStr(pMQMPRODSCHED(List_To_Be_update[I]).COMPANYCODE);
            if IniAppGlobals.EnvironmentCode <> '' then
              HostSqlStrVal := HostSqlStrVal + ' AND "ENVIRONMENTCODE" = ' + QuotedStr(IniAppGlobals.EnvironmentCode);
            if Exist_HIGHLEVELSCHEDULE then
              HostSqlStrVal := HostSqlStrVal + ' AND "HIGHLEVELSCHEDULE" = ' + QuotedStr(HIGHLEVELSCHEDULE_MQM_OR_MCM);
            // COUNTERCOMPANYCODE is data, not part of the key - excluded from the WHERE.
            HostSqlStrVal := HostSqlStrVal + ' AND "COUNTERCODE" = ' + QuotedStr(pMQMPRODSCHED(List_To_Be_update[I]).COUNTERCODE);
            HostSqlStrVal := HostSqlStrVal + ' AND "CODE" = ' + QuotedStr(pMQMPRODSCHED(List_To_Be_update[I]).CODE);
            HostSqlStrVal := HostSqlStrVal + ' AND "STEPNUMBER" = ' + IntToStr(pMQMPRODSCHED(List_To_Be_update[I]).STEPNUMBER);
            HostSqlStrVal := HostSqlStrVal + ' AND "SUBSTEP" = ' + IntToStr(pMQMPRODSCHED(List_To_Be_update[I]).SUBSTEP);
            HostSqlStrVal := HostSqlStrVal + ' AND "REPROCESS" = ' + IntToStr(pMQMPRODSCHED(List_To_Be_update[I]).REPROCESS);

            HostQry.SQL.Text := HostSqlStr + HostSqlStrVal;

            try
              HostQry.ExecSQL;
              HostQry.Connection.Commit;
            except
              on E: Exception do
              begin
                Result := false;
                sl := TStringList.Create;
                sl.Add(_('Sending') + ' Schedules (update)');
                sl.Add('Demand : ' + pMQMPRODSCHED(List_To_Be_update[I]).CODE +
                         ' Step : ' + IntToStr(pMQMPRODSCHED(List_To_Be_update[I]).STEPNUMBER) +
                         ' Sub Step : ' + IntToStr(pMQMPRODSCHED(List_To_Be_update[I]).SUBSTEP));
                sl.Add('DB Error : ' + E.Message);
                UpdateError(sl);
                sl.Free;
                raise;
              end;
            end;
          end;
        end;
      end;
    end;
  end;

  if List_To_Be_insert.Count > 0 then
  begin
    with HostQry do
    begin

      for j := 0 to 3 do
      begin
        // J = 0 Sched, J = 1 Sched+group , j = 2 NoSsched no group , j = 3 No Ssched grouped ,

        HostSqlStr := '';
        HostSqlStr := 'insert into "SCHEDULESUPLOAD" ' + '(';
        HostSqlStr := HostSqlStr + '"COMPANYCODE", ';
        if IniAppGlobals.EnvironmentCode <> '' then
           HostSqlStr := HostSqlStr + '"ENVIRONMENTCODE", ';
        if Exist_HIGHLEVELSCHEDULE then
          HostSqlStr := HostSqlStr + '"HIGHLEVELSCHEDULE", ';

        if Exist_COUNTERCOMPANYCODE then
          HostSqlStr := HostSqlStr + '"COUNTERCOMPANYCODE", ';

        HostSqlStr := HostSqlStr + '"COUNTERCODE", ';
        HostSqlStr := HostSqlStr + '"CODE", ';
        HostSqlStr := HostSqlStr + '"STEPNUMBER", ';
        HostSqlStr := HostSqlStr + '"SUBSTEP", ';
        HostSqlStr := HostSqlStr + '"REPROCESS", ';
        HostSqlStr := HostSqlStr + '"CANGROUP", ';
        if (j = 1) or (j = 3) then
          HostSqlStr := HostSqlStr + 'GROUPNUMBER, ';
        HostSqlStr := HostSqlStr + '"SCHEDULETYPE", ';
        if (j = 0) or (j = 1) then
          HostSqlStr := HostSqlStr + '"SCHEDULEDWORKCENTERCODE", ';

        if HIGHLEVELSCHEDULE_MQM_OR_MCM = '0' then // mqm
        begin
          if (j = 0) or (j = 1) then
            HostSqlStr := HostSqlStr + '"SCHEDULEDRESOURCECODE", ';
        end;
        HostSqlStr := HostSqlStr + '"SCHEDULEDRESOURCESUBLINE", ';
        HostSqlStr := HostSqlStr + '"NUMBEROFRESOURCECOMPONENTS", ';
        HostSqlStr := HostSqlStr + '"QUANTITYINPRIMARYUOM", ';
        HostSqlStr := HostSqlStr + '"PRIMARYUOMCODE", ';
        HostSqlStr := HostSqlStr + '"SETUPTIMEBEFOREMATERIAL", ';
        HostSqlStr := HostSqlStr + '"SETUPTIMEAFTERMATERIAL", ';
        HostSqlStr := HostSqlStr + '"EXECUTIONTIME", ';
        HostSqlStr := HostSqlStr + '"INITIALSCHEDULEDDATE", ';
        HostSqlStr := HostSqlStr + '"INITIALSCHEDULEDTIME", ';
        HostSqlStr := HostSqlStr + '"FINALSCHEDULEDDATE", ';
        HostSqlStr := HostSqlStr + '"FINALSCHEDULEDTIME", ';

        if Exist_Actual_Start_End then
        begin
          HostSqlStr := HostSqlStr + '"INITIALSCHEDULEDACTUALDATE", ';
          HostSqlStr := HostSqlStr + '"INITIALSCHEDULEDACTUALTIME", ';
          HostSqlStr := HostSqlStr + '"FINALSCHEDULEDACTUALDATE", ';
          HostSqlStr := HostSqlStr + '"FINALSCHEDULEDACTUALTIME", ';
        end;

        HostSqlStr := HostSqlStr + '"PLANNERCOMMENT", ';
        HostSqlStr := HostSqlStr + '"NEWDEMANDUNIQUEID", ';
        HostSqlStr := HostSqlStr + '"SPLITFAMILY", ';
        HostSqlStr := HostSqlStr + '"IMPORTSTATUS", ';
        HostSqlStr := HostSqlStr + '"CHANGETYPE", ';
        HostSqlStr := HostSqlStr + '"ABSUNIQUEID"';
        HostSqlStr := HostSqlStr + ') values (';

        HostQry.SQL.Clear;
  //      HostQry.Connection.BeginTrans;
  //      HostQry.Connection.CommitTrans;

        for I := 0 to List_To_Be_insert.count - 1 do
        begin

          if ((J = 0) and (pMQMPRODSCHED(List_To_Be_insert[I]).SCHEDULETYPE <> '0') and (pMQMPRODSCHED(List_To_Be_insert[I]).GROUPNUMBER = '0'))
          or ((J = 1) and (pMQMPRODSCHED(List_To_Be_insert[I]).SCHEDULETYPE <> '0') and (pMQMPRODSCHED(List_To_Be_insert[I]).GROUPNUMBER <> '0'))
          or ((j = 2) and (pMQMPRODSCHED(List_To_Be_insert[I]).SCHEDULETYPE = '0') and (pMQMPRODSCHED(List_To_Be_insert[I]).GROUPNUMBER = '0'))
          or ((j = 3) and (pMQMPRODSCHED(List_To_Be_insert[I]).SCHEDULETYPE = '0') and (pMQMPRODSCHED(List_To_Be_insert[I]).GROUPNUMBER <> '0')) then
          begin
            HostSqlStrVal := '';
            HostSqlStrVal := QuotedStr(pMQMPRODSCHED(List_To_Be_insert[I]).COMPANYCODE) +  DecSep;
            if IniAppGlobals.EnvironmentCode <> '' then
               HostSqlStrVal := HostSqlStrVal + QuotedStr(IniAppGlobals.EnvironmentCode) + DecSep;

            if Exist_HIGHLEVELSCHEDULE then
              HostSqlStrVal := HostSqlStrVal + QuotedStr(HIGHLEVELSCHEDULE_MQM_OR_MCM)+ DecSep;
            if Exist_COUNTERCOMPANYCODE then
              HostSqlStrVal := HostSqlStrVal + QuotedStr(COUNTERCOMPANYCODE_InUsed)+ DecSep;

            HostSqlStrVal := HostSqlStrVal + QuotedStr(pMQMPRODSCHED(List_To_Be_insert[I]).COUNTERCODE) +  DecSep;
            HostSqlStrVal := HostSqlStrVal + QuotedStr(pMQMPRODSCHED(List_To_Be_insert[I]).CODE) +  DecSep;
            HostSqlStrVal := HostSqlStrVal + IntTostr(pMQMPRODSCHED(List_To_Be_insert[I]).STEPNUMBER) +  DecSep;
            HostSqlStrVal := HostSqlStrVal + IntTostr(pMQMPRODSCHED(List_To_Be_insert[I]).SUBSTEP) +  DecSep;
            HostSqlStrVal := HostSqlStrVal + IntTostr(pMQMPRODSCHED(List_To_Be_insert[I]).REPROCESS) +  DecSep;
            HostSqlStrVal := HostSqlStrVal + QuotedStr(pMQMPRODSCHED(List_To_Be_insert[I]).CANGROUP) + DecSep ;
            if (j = 1) or (j = 3) then
              HostSqlStrVal := HostSqlStrVal + QuotedStr(pMQMPRODSCHED(List_To_Be_insert[I]).GROUPNUMBER) + DecSep;
            HostSqlStrVal := HostSqlStrVal + QuotedStr(pMQMPRODSCHED(List_To_Be_insert[I]).SCHEDULETYPE) + DecSep;
            if (j = 0) or (j = 1) then
            begin
              if trim(pMQMPRODSCHED(List_To_Be_insert[I]).SCHEDULEWORKCENTERCODE) = '' then
                HostSqlStrVal := HostSqlStrVal + 'null ' +  DecSep
              else
                HostSqlStrVal := HostSqlStrVal + QuotedStr(pMQMPRODSCHED(List_To_Be_insert[I]).SCHEDULEWORKCENTERCODE) +  DecSep;
            end;

            if HIGHLEVELSCHEDULE_MQM_OR_MCM = '0' then
            begin
              if (j = 0) or (j = 1) then
              begin
                if trim(pMQMPRODSCHED(List_To_Be_insert[I]).SCHEDULEDRESOURCECODE) = '' then
                  HostSqlStrVal := HostSqlStrVal + 'null' +  DecSep
                else
                HostSqlStrVal := HostSqlStrVal + QuotedStr(pMQMPRODSCHED(List_To_Be_insert[I]).SCHEDULEDRESOURCECODE) + DecSep;
              end;
            end;

            HostSqlStrVal := HostSqlStrVal + Inttostr(pMQMPRODSCHED(List_To_Be_insert[I]).SCHEDULEDRESOURCESUBLINE) +  DecSep;
            HostSqlStrVal := HostSqlStrVal + inttostr(pMQMPRODSCHED(List_To_Be_insert[I]).NUMBEROFRESOURCECOMPONENTS) + DecSep;
            HostSqlStrVal := HostSqlStrVal + floattostr(pMQMPRODSCHED(List_To_Be_insert[I]).QUANTITYINPRIMARYUOM) + DecSep;
            HostSqlStrVal := HostSqlStrVal + QuotedStr(pMQMPRODSCHED(List_To_Be_insert[I]).PRIMARYUOMCODE) + DecSep;
            HostSqlStrVal := HostSqlStrVal + floattostr(pMQMPRODSCHED(List_To_Be_insert[I]).SETUPTIMEBEFOREMATERIAL) + DecSep;
            HostSqlStrVal := HostSqlStrVal + floattostr(pMQMPRODSCHED(List_To_Be_insert[I]).SETUPTIMEAFTERMATERIAL) + DecSep;
            HostSqlStrVal := HostSqlStrVal + floattostr(pMQMPRODSCHED(List_To_Be_insert[I]).EXECUTIONTIME) + DecSep;

            if pMQMPRODSCHED(List_To_Be_insert[I]).ChangedType = '3' then
            begin
              HostSqlStrVal := HostSqlStrVal + 'null ' + DecSep;
              HostSqlStrVal := HostSqlStrVal + 'null ' + DecSep;
              HostSqlStrVal := HostSqlStrVal + 'null ' + DecSep;
              HostSqlStrVal := HostSqlStrVal + 'null ' + DecSep;
            end
            else
            begin
              HostSqlStrVal := HostSqlStrVal + pMQMPRODSCHED(List_To_Be_insert[I]).INITIALSCHEDULEDDATE + DecSep;
              HostSqlStrVal := HostSqlStrVal + pMQMPRODSCHED(List_To_Be_insert[I]).INITIALSCHEDULEDTIME + DecSep;
              HostSqlStrVal := HostSqlStrVal + pMQMPRODSCHED(List_To_Be_insert[I]).FINALSCHEDULEDDATE + DecSep;
              HostSqlStrVal := HostSqlStrVal + pMQMPRODSCHED(List_To_Be_insert[I]).FINALSCHEDULEDTIME + DecSep;
            end;

            if Exist_Actual_Start_End then
            begin
              if (pMQMPRODSCHED(List_To_Be_insert[I]).ChangedType = '3') or (pMQMPRODSCHED(List_To_Be_insert[I]).INITIALSCHEDULEDACTUALDATE = '') then
              begin
                HostSqlStrVal := HostSqlStrVal + 'null ' + DecSep;
                HostSqlStrVal := HostSqlStrVal + 'null ' + DecSep;
                HostSqlStrVal := HostSqlStrVal + 'null ' + DecSep;
                HostSqlStrVal := HostSqlStrVal + 'null ' + DecSep;
              end
              else
              begin
                HostSqlStrVal := HostSqlStrVal + pMQMPRODSCHED(List_To_Be_insert[I]).INITIALSCHEDULEDACTUALDATE + DecSep;
                HostSqlStrVal := HostSqlStrVal + pMQMPRODSCHED(List_To_Be_insert[I]).INITIALSCHEDULEDACTUALTIME + DecSep;
                HostSqlStrVal := HostSqlStrVal + pMQMPRODSCHED(List_To_Be_insert[I]).FINALSCHEDULEDACTUALDATE + DecSep;
                HostSqlStrVal := HostSqlStrVal + pMQMPRODSCHED(List_To_Be_insert[I]).FINALSCHEDULEDACTUALTIME + DecSep;
              end;
            end;
            HostSqlStrVal := HostSqlStrVal + QuotedStr(pMQMPRODSCHED(List_To_Be_insert[I]).PLANNERCOMMENT) + DecSep;
            HostSqlStrVal := HostSqlStrVal + QuotedStr((pMQMPRODSCHED(List_To_Be_insert[I]).NewDemandUniqueId)) +  DecSep;
            HostSqlStrVal := HostSqlStrVal + QuotedStr(pMQMPRODSCHED(List_To_Be_insert[I]).SPLITFAMILY) +  DecSep;
            HostSqlStrVal := HostSqlStrVal + inttostr(0) +  DecSep;
            HostSqlStrVal := HostSqlStrVal + QuotedStr(pMQMPRODSCHED(List_To_Be_insert[I]).ChangedType) + DecSep + inttostr(0) + ')';

            HostSqlStrVal := SetDecSeparator(HostSqlStrVal);
            HostQry.SQL.Text := HostSqlStr + HostSqlStrVal;

            try
            //  HostQry.Connection.StartTransaction;
              HostQry.ExecSQL;
              HostQry.Connection.Commit;
            except
              on E: Exception do
              begin
                if Pos('duplicate', E.Message) > 0 then
                   continue;
                Result := false;
                sl := TStringList.Create;
                sl.Add(_('Sending') + ' Schedules');
                sl.Add('Demand : ' + pMQMPRODSCHED(List_To_Be_insert[I]).CODE +
                         ' Step : ' + IntToStr(pMQMPRODSCHED(List_To_Be_insert[I]).STEPNUMBER) +
                         ' Sub Step : ' + IntToStr(pMQMPRODSCHED(List_To_Be_insert[I]).SUBSTEP));
                sl.Add('DB Error : ' + E.Message);
                UpdateError(sl);
                sl.Free;
                raise;
              end;
            end;
          end;
        end;
      end;
    end;
  end;

  for I := HostSchedList.Count - 1 downto 0 do
     Dispose(PMQMPRODSCHED(HostSchedList[I]));

  for I := SrvSchedList.Count - 1 downto 0 do
     Dispose(PMQMPRODSCHED(SrvSchedList[I]));

  for I := List_To_Be_insert.Count - 1 downto 0 do
     Dispose(PMQMPRODSCHED(List_To_Be_insert[I]));

  for I := List_To_Be_update.Count - 1 downto 0 do
     Dispose(PMQMPRODSCHED(List_To_Be_update[I]));

  HostSchedList.Free;
  List_To_Be_insert.Free;
  List_To_Be_update.Free;
  SrvSchedList.Free;

end;


function FindMaterialInLocal(ITEMTYPECODE, CONTAINERITEMTYPECODE, CONTAINERSUBCODE01
  , CONTAINERELEMENTCODE, ELEMENTSCODE, DEMANDCOUNTERCODE,DEMANDCODE, LOGICALWAREHOUSECODE : String;
  FIKDIDENTIFIER : Double; var Index : integer; LocalList : TList) : PMQMWARPSCHED;
var
  i: integer;
  Multiplier, NumberOfEntries, NumberOfEntriesMinusOne : integer;
begin

  Result := nil;
  NumberOfEntries := LocalList.Count;
  Index := NumberOfEntries;

  if NumberOfEntries = 0 then exit;
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

    //, ITEMTYPECODE, FIKDIDENTIFIER,  CONTAINERITEMTYPECODE, CONTAINERSUBCODE01,  CONTAINERELEMENTCODE,  ELEMENTSCODE
  //,  DEMANDCOUNTERCODE, DEMANDCODE, LOGICALWAREHOUSECODE

    if (PMQMWARPSCHED(LocalList[i]).ITEMTYPECODE > ITEMTYPECODE) then
    begin
      if I < Index then Index := I;
      i := i - Multiplier;
      Continue;
    end;

    if  (PMQMWARPSCHED(LocalList[i]).ITEMTYPECODE < ITEMTYPECODE) then
    begin
      i := i + Multiplier;
      Continue;
    end;

    if (PMQMWARPSCHED(LocalList[i]).FIKDIDENTIFIER > FIKDIDENTIFIER) then
    begin
      if I < Index then Index := I;
      i := i - Multiplier;
      Continue;
    end;

    if  (PMQMWARPSCHED(LocalList[i]).FIKDIDENTIFIER < FIKDIDENTIFIER) then
    begin
      i := i + Multiplier;
      Continue;
    end;

    if (PMQMWARPSCHED(LocalList[i]).LOGICALWAREHOUSECODE > LOGICALWAREHOUSECODE) then
    begin
      if I < Index then Index := I;
      i := i - Multiplier;
      Continue;
    end;

    if  (PMQMWARPSCHED(LocalList[i]).LOGICALWAREHOUSECODE < LOGICALWAREHOUSECODE) then
    begin
      i := i + Multiplier;
      Continue;
    end;

    if (PMQMWARPSCHED(LocalList[i]).CONTAINERITEMTYPECODE > CONTAINERITEMTYPECODE) then
    begin
      if I < Index then Index := I;
      i := i - Multiplier;
      Continue;
    end;

    if  (PMQMWARPSCHED(LocalList[i]).CONTAINERITEMTYPECODE < CONTAINERITEMTYPECODE) then
    begin
      i := i + Multiplier;
      Continue;
    end;


    if (PMQMWARPSCHED(LocalList[i]).CONTAINERSUBCODE01 > CONTAINERSUBCODE01) then
    begin
      if I < Index then Index := I;
      i := i - Multiplier;
      Continue;
    end;

    if  (PMQMWARPSCHED(LocalList[i]).CONTAINERSUBCODE01 < CONTAINERSUBCODE01) then
    begin
      i := i + Multiplier;
      Continue;
    end;


    if (PMQMWARPSCHED(LocalList[i]).CONTAINERELEMENTCODE > CONTAINERELEMENTCODE) then
    begin
      if I < Index then Index := I;
      i := i - Multiplier;
      Continue;
    end;

    if  (PMQMWARPSCHED(LocalList[i]).CONTAINERELEMENTCODE < CONTAINERELEMENTCODE) then
    begin
      i := i + Multiplier;
      Continue;
    end;

    if (PMQMWARPSCHED(LocalList[i]).ELEMENTSCODE > ELEMENTSCODE) then
    begin
      if I < Index then Index := I;
      i := i - Multiplier;
      Continue;
    end;

    if  (PMQMWARPSCHED(LocalList[i]).ELEMENTSCODE < ELEMENTSCODE) then
    begin
      i := i + Multiplier;
      Continue;
    end;

    if (PMQMWARPSCHED(LocalList[i]).DEMANDCOUNTERCODE > DEMANDCOUNTERCODE) then
    begin
      if I < Index then Index := I;
      i := i - Multiplier;
      Continue;
    end;

    if  (PMQMWARPSCHED(LocalList[i]).DEMANDCOUNTERCODE < DEMANDCOUNTERCODE) then
    begin
      i := i + Multiplier;
      Continue;
    end;

    if (PMQMWARPSCHED(LocalList[i]).DEMANDCODE > DEMANDCODE) then
    begin
      if I < Index then Index := I;
      i := i - Multiplier;
      Continue;
    end;

    if  (PMQMWARPSCHED(LocalList[i]).DEMANDCODE < DEMANDCODE) then
    begin
      i := i + Multiplier;
      Continue;
    end;

    Result := PMQMWARPSCHED(LocalList[i]);
    Index := i;
    Break;

  end;
end;

//----------------------------------------------------------------------------//

function SendWarpSchedTableMqm(tbl: table; ASLib, PCcondition: string;
                   linkArr: array of TQryLinkRec;
                   srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
var
  tbInfo : ^TTblInfo;
  srvSqlStr , HostSqlStr, HostSqlStrVal  : string;
  HostMQMWARPSCHED, LocalMQMWARPSCHED : PMQMWARPSCHED;
  HostSchedList : TList;
  List_To_Be_insert : Tlist;
  SrvSchedList      : TList;
  Index_Host, Index_Srv, I, j, LineNumber : integer;
  Request,CompCod,Counter,Code : string;
  sl     : TStringList;
  ConvertDateFormat, index : Integer;
  INITIALSCHEDULEDDATETIME : TDateTime;
  FINALSCHEDULEDDATETIME   : TdateTime;
  INITIALSCHEDULEDDATEACTUALTIME : TDateTime;
  FINALSCHEDULEDDATEACTUALTIME   : TdateTime;
  Str : string;
  COUNTERCOMPANYCODE_InUsed, ItemType,LogicWHs : string;
  // Cached TField references for material srvQry loop
  mf_preqNo, mf_ProdType, mf_SubDetail, mf_DetailCode,
  mf_SubDetailHostType, mf_DetailCodeType,
  mf_quant, mf_rsc, mf_OverridenSpeed, mf_OverridenSetup,
  mf_schedStart, mf_schedEnd, mf_FirstJobQty, mf_LastJobQty,
  mf_HostItemId, mf_HostWarehouse : TField;
  // Cached TField references for material HostQry loop
  mhf_ItemType, mhf_ContainerItemType, mhf_ContainerSub,
  mhf_ContainerElement, mhf_Elements, mhf_DemandCounter, mhf_DemandCode,
  mhf_Qty, mhf_Rsc, mhf_OverridenSpeed, mhf_OverridenSetup,
  mhf_InitDate, mhf_InitTime, mhf_FinalDate, mhf_FinalTime,
  mhf_FirstJobQty, mhf_LastJobQty, mhf_FikdId, mhf_LogicWH : TField;

  function GetLastLineNumber : Integer;
    var i : Integer;
  begin
    Result := 0;
    i := 0;

//    i := DMib.m_DBHost.ExecSQLScalar('select isnull(max(LINENUMBER),0) from MATERIALDETAILSCHEDULE where '
//      + ' COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' and ENVIRONMENTCODE = '+ QuotedStr(IniAppGlobals.EnvironmentCode));


    i := DMib.m_DBHost.ExecSQLScalar('select nvl(max(LINENUMBER),0) from MATERIALDETAILSCHEDULE where '
        + ' COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' and ENVIRONMENTCODE = '+ QuotedStr(IniAppGlobals.EnvironmentCode));

    if i > 0 then
      Result := i;

  end;

  Function GetFirstPart(s : String) : String;
  begin
    Result := '';

    var tmp :=  Copy(s, 0, AnsiPos(';', s)-1) ;

    if tmp <> '' then
      Result := tmp;
  end;

  Function GetSecondPart(s : String) : String;
  begin
    Result := '';

    var tmp := Copy(s, AnsiPos(';',s) +1, Length(s) - LastDelimiter(';',s));

    if tmp <> '' then
      Result := tmp;
  end;

  Function GetThirdPart(s : String) : String;
  begin
    Result := '';

    var tmp := copy(s, LastDelimiter(';',s)+1, Length(s));

    if tmp <> '' then
      Result := tmp;
  end;
begin
  Result := true;
  tbInfo := @tblInfo[tbl];


  if not GetCompanyLevelHandlingByEntityName('ITEMTYPE',  ItemType) then
     ItemType := IniAppGlobals.CompanyCode;

  if not GetCompanyLevelHandlingByEntityName('LOGICALWAREHOUSE',  LogicWHs) then
     ItemType := IniAppGlobals.CompanyCode;

  HostSchedList     := TList.Create;
  SrvSchedList      := TList.Create;

  UpdateOperation(_('Reading locale warp schedule ...'));

  PCcondition := ' Order by ' + CreateFld(tbInfo.pfx,fli_ProdType) + ',' +
                 CreateFld(tbInfo.pfx,fli_preqNo) + ',' + CreateFld(tbInfo.pfx,fli_Sub_Detail) + ',' + CreateFld(tbInfo.pfx,fli_Detail_Code);

  if IniAppGlobals.DownloadFrom = '0' then
    ConvertDateFormat := 1
  else if IniAppGlobals.DownloadFrom = '1' then
    ConvertDateFormat := 2
  else
    ConvertDateFormat := 1;

  with srvQry do
  begin
    UpdateOperation(_('Local query ') + ' ' + tbInfo.GetTableName);
    SQL.Clear;
    SQL.Add('select ');

    for i := 0 to High(linkArr)-1 do
      SQL.Add(CreatePfxFld(linkArr[i].fldPC) + ',');

    SQL.Add(CreatePfxFld(linkArr[High(linkArr)].fldPC) + ' from ' + tbInfo.GetTableName);
    SQL.Add(WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_IDENTIFIER)));

    if PCcondition <> '' then
      SQL.Add(PCcondition);
    Open;

    // Cache TField references once before loop
    mf_preqNo            := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_preqNo));
    mf_ProdType          := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProdType));
    mf_SubDetail         := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_Sub_Detail));
    mf_DetailCode        := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_Detail_Code));
    mf_SubDetailHostType := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_SubDetailHostType));
    mf_DetailCodeType    := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_DetailCodeType));
    mf_quant             := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_quant));
    mf_rsc               := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_rsc));
    mf_OverridenSpeed    := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_OverridenSpeed));
    mf_OverridenSetup    := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_OverridenSetupTime));
    mf_schedStart        := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_schedStart));
    mf_schedEnd          := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_schedEnd));
    mf_FirstJobQty       := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_FirstJobQuantityIncluded));
    mf_LastJobQty        := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_LastJobQuantityIncluded));
    mf_HostItemId        := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_HostItemIndentifier));
    mf_HostWarehouse     := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_HostWarehouse));

    while not eof do
    begin
      Request := Trim(mf_preqNo.AsString);
      ConvertToCopmanyCounterCode(Request,CompCod,Counter,Code);

      new(LocalMQMWARPSCHED);
      LocalMQMWARPSCHED.ITEMTYPECODE := mf_ProdType.asString;

      if mf_SubDetailHostType.asString <> '0' then
      begin
        LocalMQMWARPSCHED.CONTAINERITEMTYPECODE := GetFirstPart(mf_SubDetail.asString);
        LocalMQMWARPSCHED.CONTAINERSUBCODE01 := GetSecondPart(mf_SubDetail.asString);
      end else
      begin
        LocalMQMWARPSCHED.CONTAINERITEMTYPECODE := '';
        LocalMQMWARPSCHED.CONTAINERSUBCODE01 := '';
      end;

      if mf_SubDetailHostType.asString = '2' then
        LocalMQMWARPSCHED.CONTAINERELEMENTCODE := GetThirdPart(mf_SubDetail.asString)
      else if mf_DetailCodeType.asString = '2' then
        LocalMQMWARPSCHED.CONTAINERELEMENTCODE := 'null'
      else
        LocalMQMWARPSCHED.CONTAINERELEMENTCODE := mf_DetailCode.asString;

      if mf_DetailCodeType.asString = '1' then
        LocalMQMWARPSCHED.ELEMENTSCODE  := 'null'
      else
        LocalMQMWARPSCHED.ELEMENTSCODE := mf_DetailCode.asString;

      if mf_preqNo.asString <> '' then
      begin
        LocalMQMWARPSCHED.DEMANDCOUNTERCODE  := GetSecondPart(mf_SubDetail.asString);
        LocalMQMWARPSCHED.DEMANDCODE  := GetThirdPart(mf_SubDetail.asString);
      end else
      begin
        LocalMQMWARPSCHED.DEMANDCOUNTERCODE  := '';
        LocalMQMWARPSCHED.DEMANDCODE  := '';
      end;

      LocalMQMWARPSCHED.QTY          := mf_quant.asFloat;
      LocalMQMWARPSCHED.RSC_CODE     := mf_rsc.AsString;
      LocalMQMWARPSCHED.OVERRIDENSPEED             := mf_OverridenSpeed.asFloat;
      LocalMQMWARPSCHED.OVERRIDENSETUPTIME         := mf_OverridenSetup.asFloat;
      LocalMQMWARPSCHED.SCH_START    := mf_schedStart.asDateTime;
      LocalMQMWARPSCHED.SCH_END      := mf_schedEnd.asDateTime;
      LocalMQMWARPSCHED.FIRSTJOBQUANTITYINCLUDED   := mf_FirstJobQty.asFloat;
      LocalMQMWARPSCHED.LASTJOBQUANTITYINCLUDED    := mf_LastJobQty.asFloat;
      LocalMQMWARPSCHED.FIKDIDENTIFIER        := mf_HostItemId.asFloat;
      LocalMQMWARPSCHED.LOGICALWAREHOUSECODE     := mf_HostWarehouse.asString;
      LocalMQMWARPSCHED.SubDetailHostType := mf_SubDetailHostType.asString;
      LocalMQMWARPSCHED.DetailCodeType    := mf_DetailCodeType.asString;
      SrvSchedList.Add(LocalMQMWARPSCHED);
      Next
    end;

    SrvSchedList.Sort(SortMaterialHost);
  end;

  UpdateOperation(_('Reading host warp schedule ... '));

  with HostQry do
  begin

      srvSqlStr := 'SELECT MATERIALTYPE, COMPANYCODE, ENVIRONMENTCODE, ';
      srvSqlStr := srvSqlStr + 'ITEMTYPECOMPANYCODE , ITEMTYPECODE , ';
      srvSqlStr := srvSqlStr + 'FIKDIDENTIFIER , LOGICALWAREHOUSECODE , QUANTITY , SCHEDULEDRESOURCECODE , ';
      srvSqlStr := srvSqlStr + 'OVERRIDENSETUPTIME , OVERRIDENSPEED , ';
      srvSqlStr := srvSqlStr + 'FIRSTJOBQUANTITYINCLUDED , LASTJOBQUANTITYINCLUDED , '
        + ' CONTAINERITEMTYPECODE ,CONTAINERSUBCODE01, CONTAINERELEMENTCODE, ELEMENTSCODE, DEMANDCOUNTERCODE, DEMANDCODE ,  ' ;

      if ConvertDateFormat = 1 then
        srvSqlStr := srvSqlStr + 'INITIALSCHEDULEDDATE , INITIALSCHEDULEDTIME , FINALSCHEDULEDDATE ,FINALSCHEDULEDTIME  '
      else if ConvertDateFormat = 2 then
      begin
        srvSqlStr := srvSqlStr + 'TO_CHAR(INITIALSCHEDULEDTIME,'+ QuotedStr('HH24:MI:SS')+')' + '"INITIALSCHEDULEDTIME", ';
        srvSqlStr := srvSqlStr + 'TO_CHAR(FINALSCHEDULEDTIME,'+ QuotedStr('HH24:MI:SS')+')' + '"FINALSCHEDULEDTIME" ';
      end;

      srvSqlStr := srvSqlStr + ' FROM MATERIALDETAILSCHEDULE ';
      srvSqlStr := srvSqlStr + 'WHERE COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ';
      if IniAppGlobals.EnvironmentCode <> '' then
        srvSqlStr := srvSqlStr + 'AND ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' ';

     srvSqlStr := srvSqlStr + ' ORDER BY COMPANYCODE,ENVIRONMENTCODE,ITEMTYPECODE ';

    SQL.Text := srvSqlStr;

    HostQry.Open;

    // Cache TField references once before loop
    mhf_ItemType        := HostQry.FieldByName('ITEMTYPECODE');
    mhf_ContainerItemType := HostQry.FieldByName('CONTAINERITEMTYPECODE');
    mhf_ContainerSub    := HostQry.FieldByName('CONTAINERSUBCODE01');
    mhf_ContainerElement := HostQry.FieldByName('CONTAINERELEMENTCODE');
    mhf_Elements        := HostQry.FieldByName('ELEMENTSCODE');
    mhf_DemandCounter   := HostQry.FieldByName('DEMANDCOUNTERCODE');
    mhf_DemandCode      := HostQry.FieldByName('DEMANDCODE');
    mhf_Qty             := HostQry.FieldByName('QUANTITY');
    mhf_Rsc             := HostQry.FieldByName('SCHEDULEDRESOURCECODE');
    mhf_OverridenSpeed  := HostQry.FieldByName('OVERRIDENSPEED');
    mhf_OverridenSetup  := HostQry.FieldByName('OVERRIDENSETUPTIME');
    mhf_InitDate        := HostQry.FieldByName('INITIALSCHEDULEDDATE');
    mhf_InitTime        := HostQry.FieldByName('INITIALSCHEDULEDTIME');
    mhf_FinalDate       := HostQry.FieldByName('FINALSCHEDULEDDATE');
    mhf_FinalTime       := HostQry.FieldByName('FINALSCHEDULEDTIME');
    mhf_FirstJobQty     := HostQry.FieldByName('FIRSTJOBQUANTITYINCLUDED');
    mhf_LastJobQty      := HostQry.FieldByName('LASTJOBQUANTITYINCLUDED');
    mhf_FikdId          := HostQry.FieldByName('FIKDIDENTIFIER');
    mhf_LogicWH         := HostQry.FieldByName('LOGICALWAREHOUSECODE');

    while not HostQry.eof do
    begin
      new(HostMQMWARPSCHED);

      HostMQMWARPSCHED.ITEMTYPECODE := mhf_ItemType.asString;

      HostMQMWARPSCHED.CONTAINERITEMTYPECODE := mhf_ContainerItemType.asString;
      HostMQMWARPSCHED.CONTAINERSUBCODE01    := mhf_ContainerSub.asString;
      HostMQMWARPSCHED.CONTAINERELEMENTCODE  := mhf_ContainerElement.asString;
      HostMQMWARPSCHED.ELEMENTSCODE          := mhf_Elements.asString;
      HostMQMWARPSCHED.DEMANDCOUNTERCODE     := mhf_DemandCounter.asString;
      HostMQMWARPSCHED.DEMANDCODE            := mhf_DemandCode.asString;

      HostMQMWARPSCHED.QTY          := mhf_Qty.asFloat;
      HostMQMWARPSCHED.RSC_CODE     := mhf_Rsc.AsString;
      HostMQMWARPSCHED.OVERRIDENSPEED             := mhf_OverridenSpeed.asFloat;
      HostMQMWARPSCHED.OVERRIDENSETUPTIME         := mhf_OverridenSetup.asFloat;
      HostMQMWARPSCHED.SCH_START    := mhf_InitDate.asDateTime + mhf_InitTime.asDateTime;
      HostMQMWARPSCHED.SCH_END      := mhf_FinalDate.asDateTime + mhf_FinalTime.asDateTime;
      HostMQMWARPSCHED.FIRSTJOBQUANTITYINCLUDED   := mhf_FirstJobQty.asFloat;
      HostMQMWARPSCHED.LASTJOBQUANTITYINCLUDED    := mhf_LastJobQty.asFloat;
      HostMQMWARPSCHED.FIKDIDENTIFIER         := mhf_FikdId.asFloat;
      HostMQMWARPSCHED.LOGICALWAREHOUSECODE := mhf_LogicWH.asString;
      HostMQMWARPSCHED.SubDetailHostType := '';//HostQry.FieldByName('LOGICALWAREHOUSECODE').asString;
      HostMQMWARPSCHED.DetailCodeType := '';//HostQry.FieldByName('LOGICALWAREHOUSECODE').asString;

      HostSchedList.Add(HostMQMWARPSCHED);
      next;
    end;
    HostSchedList.Sort(SortMaterialHost);
    Close;
  end;

 UpdateOperation(_('Compare and insert modification to host ... '));


 for i := 0 to HostSchedList.Count -1 do
 begin

  HostMQMWARPSCHED := HostSchedList[i];

  //, ITEMTYPECODE, FIKDIDENTIFIER,  CONTAINERITEMTYPECODE, CONTAINERSUBCODE01,  CONTAINERELEMENTCODE,  ELEMENTSCODE
  //,  DEMANDCOUNTERCODE, DEMANDCODE, LOGICALWAREHOUSECODE

  LocalMQMWARPSCHED := FindMaterialInLocal(HostMQMWARPSCHED.ITEMTYPECODE,  HostMQMWARPSCHED.CONTAINERITEMTYPECODE
  ,HostMQMWARPSCHED.CONTAINERSUBCODE01, HostMQMWARPSCHED.CONTAINERELEMENTCODE, HostMQMWARPSCHED.ELEMENTSCODE, HostMQMWARPSCHED.DEMANDCOUNTERCODE
  , HostMQMWARPSCHED.DEMANDCODE, HostMQMWARPSCHED.LOGICALWAREHOUSECODE,HostMQMWARPSCHED.FIKDIDENTIFIER,index, SrvSchedList);

  if LocalMQMWARPSCHED = nil then  //NOT FOUND
  begin
    HostSqlStr := '';
    HostSqlStr := 'Update "MATERIALDETAILSCHEDULE" set ';
    HostSqlStr := HostSqlStr + '"ACTION" = ' + QuotedStr('3') + DecSep ;
    HostSqlStr := HostSqlStr + ' "PROCESSED" = ' + QuotedStr('0');
    HostSqlStr := HostSqlStr + ' where COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode);
    HostSqlStr := HostSqlStr + ' and ENVIRONMENTCODE  = ' + QuotedStr(IniAppGlobals.EnvironmentCode);
    HostSqlStr := HostSqlStr + ' and ITEMTYPECODE  = ' + QuotedStr(HostMQMWARPSCHED.ITEMTYPECODE);
    HostSqlStr := HostSqlStr + ' and FIKDIDENTIFIER  = ' + QuotedStr(FloatTOStr(HostMQMWARPSCHED.FIKDIDENTIFIER));
    HostSqlStr := HostSqlStr + ' and CONTAINERITEMTYPECODE  = ' + QuotedStr(HostMQMWARPSCHED.CONTAINERITEMTYPECODE);
    HostSqlStr := HostSqlStr + ' and CONTAINERSUBCODE01  = ' + QuotedStr(HostMQMWARPSCHED.CONTAINERSUBCODE01);
    HostSqlStr := HostSqlStr + ' and CONTAINERELEMENTCODE  = ' + QuotedStr(HostMQMWARPSCHED.CONTAINERELEMENTCODE);
    HostSqlStr := HostSqlStr + ' and ELEMENTSCODE  = ' + QuotedStr(HostMQMWARPSCHED.ELEMENTSCODE);
    HostSqlStr := HostSqlStr + ' and DEMANDCOUNTERCODE  = ' + QuotedStr(HostMQMWARPSCHED.DEMANDCOUNTERCODE);
    HostSqlStr := HostSqlStr + ' and DEMANDCODE  = ' + QuotedStr(HostMQMWARPSCHED.DEMANDCODE);
    HostSqlStr := HostSqlStr + ' and LOGICALWAREHOUSECODE  = ' + QuotedStr(HostMQMWARPSCHED.LOGICALWAREHOUSECODE);

    HostSqlStr := SetDecSeparator(HostSqlStr);
    HostQry.SQL.Text := HostSqlStr;

    HostQry.Connection.StartTransaction;
    try
      HostQry.ExecSQL;
      HostQry.Connection.Commit;
      Continue;
    except
      on E: Exception do
      begin
        Result := false;
        sl := TStringList.Create;
        sl.Add(_('Sending') + ' Schedules - SendWarpSchedTableMqm');
        sl.Add('ITEMTYPECODE: ' + LocalMQMWARPSCHED.ITEMTYPECODE + ' ELEMENTSCODE: ' + LocalMQMWARPSCHED.ELEMENTSCODE +
               ' CONTAINERSUBCODE01: ' + LocalMQMWARPSCHED.CONTAINERSUBCODE01 + ' RSC_CODE: ' + LocalMQMWARPSCHED.RSC_CODE +
               ' DEMANDCODE: ' + LocalMQMWARPSCHED.DEMANDCODE + ' DEMANDCOUNTERCODE: ' + LocalMQMWARPSCHED.DEMANDCOUNTERCODE);
        sl.Add('DB Error : ' + E.Message);
        UpdateError(sl);
        sl.Free;
        Exit
      end;
    end;

  end else  //FOUND
  begin
    if LocalMQMWARPSCHED.RSC_CODE = '' then //NO RES CODE
    begin
      HostSqlStr := '';
      HostSqlStr := 'Update "MATERIALDETAILSCHEDULE" set ';
      HostSqlStr := HostSqlStr + '"ACTION" = ' + QuotedStr('3') + DecSep;
      HostSqlStr := HostSqlStr + ' "PROCESSED" = ' + QuotedStr('0');
      HostSqlStr := HostSqlStr + ' where COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode);
      HostSqlStr := HostSqlStr + ' and ENVIRONMENTCODE  = ' + QuotedStr(IniAppGlobals.EnvironmentCode);
      HostSqlStr := HostSqlStr + ' and ITEMTYPECODE  = ' + QuotedStr(HostMQMWARPSCHED.ITEMTYPECODE);
      HostSqlStr := HostSqlStr + ' and FIKDIDENTIFIER  = ' + QuotedStr(FloatTOStr(HostMQMWARPSCHED.FIKDIDENTIFIER));
      HostSqlStr := HostSqlStr + ' and CONTAINERITEMTYPECODE  = ' + QuotedStr(HostMQMWARPSCHED.CONTAINERITEMTYPECODE);
      HostSqlStr := HostSqlStr + ' and CONTAINERSUBCODE01  = ' + QuotedStr(HostMQMWARPSCHED.CONTAINERSUBCODE01);
      HostSqlStr := HostSqlStr + ' and CONTAINERELEMENTCODE  = ' + QuotedStr(HostMQMWARPSCHED.CONTAINERELEMENTCODE);
      HostSqlStr := HostSqlStr + ' and ELEMENTSCODE  = ' + QuotedStr(HostMQMWARPSCHED.ELEMENTSCODE);
      HostSqlStr := HostSqlStr + ' and DEMANDCOUNTERCODE  = ' + QuotedStr(HostMQMWARPSCHED.DEMANDCOUNTERCODE);
      HostSqlStr := HostSqlStr + ' and DEMANDCODE  = ' + QuotedStr(HostMQMWARPSCHED.DEMANDCODE);
      HostSqlStr := HostSqlStr + ' and LOGICALWAREHOUSECODE  = ' + QuotedStr(HostMQMWARPSCHED.LOGICALWAREHOUSECODE);

      HostSqlStr := SetDecSeparator(HostSqlStr);
      HostQry.SQL.Text := HostSqlStr;

      HostQry.Connection.StartTransaction;
      try
        HostQry.ExecSQL;
        HostQry.Connection.Commit;
        Continue;
      except
        on E: Exception do
        begin
          Result := false;
          sl := TStringList.Create;
          sl.Add(_('Sending') + ' Schedules - SendWarpSchedTableMqm');
          sl.Add('ITEMTYPECODE: ' + LocalMQMWARPSCHED.ITEMTYPECODE + ' ELEMENTSCODE: ' + LocalMQMWARPSCHED.ELEMENTSCODE +
               ' CONTAINERSUBCODE01: ' + LocalMQMWARPSCHED.CONTAINERSUBCODE01 + ' RSC_CODE: ' + LocalMQMWARPSCHED.RSC_CODE +
               ' DEMANDCODE: ' + LocalMQMWARPSCHED.DEMANDCODE + ' DEMANDCOUNTERCODE: ' + LocalMQMWARPSCHED.DEMANDCOUNTERCODE);
          sl.Add('DB Error : ' + E.Message);
          UpdateError(sl);
          sl.Free;
          Exit
        end;
      end;
    end else //found and have res code
    begin


       //compare rest values
      if (HostMQMWARPSCHED.QTY <> LocalMQMWARPSCHED.QTY) or
       (HostMQMWARPSCHED.RSC_CODE <> LocalMQMWARPSCHED.RSC_CODE) or
       (HostMQMWARPSCHED.OVERRIDENSETUPTIME <> LocalMQMWARPSCHED.OVERRIDENSETUPTIME) or
       (HostMQMWARPSCHED.OVERRIDENSPEED <> LocalMQMWARPSCHED.OVERRIDENSPEED) or
       (strtodatetime(formatDatetime(FormatSettings.ShortDateFormat + ' hh:mm:ss',HostMQMWARPSCHED.SCH_START)) <> strtodatetime(formatDatetime(FormatSettings.ShortDateFormat + ' hh:mm:ss',LocalMQMWARPSCHED.SCH_START))) or
       (strtodatetime(formatDatetime(FormatSettings.ShortDateFormat + ' hh:mm:ss',HostMQMWARPSCHED.SCH_END)) <> strtodatetime(formatDatetime(FormatSettings.ShortDateFormat + ' hh:mm:ss',LocalMQMWARPSCHED.SCH_END))) or
       (HostMQMWARPSCHED.FIRSTJOBQUANTITYINCLUDED <> LocalMQMWARPSCHED.FIRSTJOBQUANTITYINCLUDED) or
       (HostMQMWARPSCHED.LASTJOBQUANTITYINCLUDED <> LocalMQMWARPSCHED.LASTJOBQUANTITYINCLUDED)
     then
      begin
        HostSqlStr := '';
        HostSqlStr := 'Update "MATERIALDETAILSCHEDULE" set ';
        HostSqlStr := HostSqlStr + '"ACTION" = ' + QuotedStr('2') + DecSep;
        HostSqlStr := HostSqlStr + ' PROCESSED = ' + QuotedStr('0') + DecSep;
        HostSqlStr := HostSqlStr + ' QUANTITY = ' + QuotedStr(FloatToStr(LocalMQMWARPSCHED.QTY)) + DecSep;
        HostSqlStr := HostSqlStr + ' SCHEDULEDRESOURCECODE = ' + QuotedStr(LocalMQMWARPSCHED.RSC_CODE) + DecSep;
        HostSqlStr := HostSqlStr + ' OVERRIDENSETUPTIME = ' + QuotedStr(FloatToStr(LocalMQMWARPSCHED.OVERRIDENSETUPTIME)) + DecSep;
        HostSqlStr := HostSqlStr + ' OVERRIDENSPEED = ' + QuotedStr(FloatToStr(LocalMQMWARPSCHED.OVERRIDENSPEED)) + DecSep;

        if IniAppGlobals.downloadFrom = '0' then //DB2
        begin
          HostSqlStr := HostSqlStr + ' INITIALSCHEDULEDDATE  = ' + QuotedStr(FormatDateTime('yyyy-mm-dd',LocalMQMWARPSCHED.SCH_START)) + DecSep;
          HostSqlStr := HostSqlStr + ' FINALSCHEDULEDDATE  = ' + QuotedStr(FormatDateTime('yyyy-mm-dd',LocalMQMWARPSCHED.SCH_END)) + DecSep;
        end else if IniAppGlobals.downloadFrom = '1' then //oracle
        begin
          HostSqlStr := HostSqlStr + ' INITIALSCHEDULEDDATE  = ' + QuotedStr(FormatDateTime('dd-MM-yy', LocalMQMWARPSCHED.SCH_START)) + DecSep;
          HostSqlStr := HostSqlStr + ' FINALSCHEDULEDDATE  = ' + QuotedStr(FormatDateTime('dd-MM-yy',LocalMQMWARPSCHED.SCH_END)) + DecSep;
        end;

        HostSqlStr := HostSqlStr + ' INITIALSCHEDULEDTIME  = ' + QuotedStr(FormatDateTime('hh:mm:ss',LocalMQMWARPSCHED.SCH_START)) + DecSep;
        HostSqlStr := HostSqlStr + ' FINALSCHEDULEDTIME  = ' + QuotedStr(FormatDateTime('hh:mm:ss',LocalMQMWARPSCHED.SCH_END)) + DecSep;

                                            //////

        HostSqlStr := HostSqlStr + ' FIRSTJOBQUANTITYINCLUDED  = ' + QuotedStr(FloatToStr(LocalMQMWARPSCHED.FIRSTJOBQUANTITYINCLUDED)) + DecSep;
        HostSqlStr := HostSqlStr + ' LASTJOBQUANTITYINCLUDED  = ' + QuotedStr(FloatToStr(LocalMQMWARPSCHED.FIRSTJOBQUANTITYINCLUDED));

        HostSqlStr := HostSqlStr + ' where COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode);
        HostSqlStr := HostSqlStr + ' and ENVIRONMENTCODE  = ' + QuotedStr(IniAppGlobals.EnvironmentCode);
        HostSqlStr := HostSqlStr + ' and ITEMTYPECODE  = ' + QuotedStr(LocalMQMWARPSCHED.ITEMTYPECODE);
        HostSqlStr := HostSqlStr + ' and FIKDIDENTIFIER  = ' + QuotedStr(FloatTOStr(LocalMQMWARPSCHED.FIKDIDENTIFIER));
        HostSqlStr := HostSqlStr + ' and CONTAINERITEMTYPECODE  = ' + QuotedStr(LocalMQMWARPSCHED.CONTAINERITEMTYPECODE);
        HostSqlStr := HostSqlStr + ' and CONTAINERSUBCODE01  = ' + QuotedStr(LocalMQMWARPSCHED.CONTAINERSUBCODE01);
        HostSqlStr := HostSqlStr + ' and CONTAINERELEMENTCODE  = ' + QuotedStr(LocalMQMWARPSCHED.CONTAINERELEMENTCODE);
        HostSqlStr := HostSqlStr + ' and ELEMENTSCODE  = ' + QuotedStr(LocalMQMWARPSCHED.ELEMENTSCODE);
        HostSqlStr := HostSqlStr + ' and DEMANDCOUNTERCODE  = ' + QuotedStr(LocalMQMWARPSCHED.DEMANDCOUNTERCODE);
        HostSqlStr := HostSqlStr + ' and DEMANDCODE  = ' + QuotedStr(LocalMQMWARPSCHED.DEMANDCODE);
        HostSqlStr := HostSqlStr + ' and LOGICALWAREHOUSECODE  = ' + QuotedStr(LocalMQMWARPSCHED.LOGICALWAREHOUSECODE);

        HostSqlStr := SetDecSeparator(HostSqlStr);
        HostQry.SQL.Text := HostSqlStr;

        HostQry.Connection.StartTransaction;
        try
          HostQry.ExecSQL;
          HostQry.Connection.Commit;
          Continue;
        except
          on E: Exception do
          begin
            Result := false;
            sl := TStringList.Create;
            sl.Add(_('Sending') + ' Schedules - SendWarpSchedTableMqm');
            sl.Add('ITEMTYPECODE: ' + LocalMQMWARPSCHED.ITEMTYPECODE + ' ELEMENTSCODE: ' + LocalMQMWARPSCHED.ELEMENTSCODE +
               ' CONTAINERSUBCODE01: ' + LocalMQMWARPSCHED.CONTAINERSUBCODE01 + ' RSC_CODE: ' + LocalMQMWARPSCHED.RSC_CODE +
               ' DEMANDCODE: ' + LocalMQMWARPSCHED.DEMANDCODE + ' DEMANDCOUNTERCODE: ' + LocalMQMWARPSCHED.DEMANDCOUNTERCODE);
            sl.Add('DB Error : ' + E.Message);
            UpdateError(sl);
            sl.Free;
            Exit
          end;
        end;
      end else  //all the same
        continue;

    end;
  end;
 end;


 for i := 0 to SrvSchedList.count - 1 do
 begin
  LocalMQMWARPSCHED := SrvSchedList[i];

  if LocalMQMWARPSCHED.RSC_CODE = '' then Continue;


  HostMQMWARPSCHED := FindMaterialInLocal(LocalMQMWARPSCHED.ITEMTYPECODE,  LocalMQMWARPSCHED.CONTAINERITEMTYPECODE
  ,LocalMQMWARPSCHED.CONTAINERSUBCODE01, LocalMQMWARPSCHED.CONTAINERELEMENTCODE, LocalMQMWARPSCHED.ELEMENTSCODE, LocalMQMWARPSCHED.DEMANDCOUNTERCODE
  , LocalMQMWARPSCHED.DEMANDCODE, LocalMQMWARPSCHED.LOGICALWAREHOUSECODE,LocalMQMWARPSCHED.FIKDIDENTIFIER,index, HostSchedList);

  if HostMQMWARPSCHED = nil then
  begin
    LineNumber := GetLastLineNumber;

    Inc(LineNumber);
    HostSqlStr := '';
    HostSqlStr := 'insert into "MATERIALDETAILSCHEDULE" ' + '(';
    HostSqlStr := HostSqlStr + '"COMPANYCODE", ';

    if IniAppGlobals.EnvironmentCode <> '' then
       HostSqlStr := HostSqlStr + '"ENVIRONMENTCODE", ';

    HostSqlStr := HostSqlStr + '"LINENUMBER", ';
    HostSqlStr := HostSqlStr + '"MATERIALTYPE", ';
    HostSqlStr := HostSqlStr + '"ACTION", ';
    HostSqlStr := HostSqlStr + '"PROCESSED", ';
    HostSqlStr := HostSqlStr + '"ITEMTYPECOMPANYCODE", ';
    HostSqlStr := HostSqlStr + '"ITEMTYPECODE", ';
    HostSqlStr := HostSqlStr + 'FIKDIDENTIFIER, ';
    HostSqlStr := HostSqlStr + '"CONTAINERCOMPANYCODE", ';
    HostSqlStr := HostSqlStr + '"CONTAINERITEMTYPECODE", ';
    HostSqlStr := HostSqlStr + '"CONTAINERSUBCODE01", ';
    HostSqlStr := HostSqlStr + '"CONTAINERELEMENTCOMPANYCODE", ';
    HostSqlStr := HostSqlStr + '"CONTAINERELEMENTCODE", ';
    HostSqlStr := HostSqlStr + '"ELEMENTSCOMPANYCODE", ';
    HostSqlStr := HostSqlStr + '"ELEMENTSSUBCODEKEY", ';
    HostSqlStr := HostSqlStr + '"ELEMENTSCODE", ';
    HostSqlStr := HostSqlStr + '"DEMANDCOUNTERCODE", ';
    HostSqlStr := HostSqlStr + '"DEMANDCODE", ';
    HostSqlStr := HostSqlStr + '"QUANTITY", ';
    HostSqlStr := HostSqlStr + '"LOGICALWAREHOUSECOMPANYCODE", ';
    HostSqlStr := HostSqlStr + '"LOGICALWAREHOUSECODE", ';
    HostSqlStr := HostSqlStr + '"SCHEDULEDRESOURCECODE", ';
    HostSqlStr := HostSqlStr + '"OVERRIDENSETUPTIME", ';
    HostSqlStr := HostSqlStr + '"OVERRIDENSPEED", ';
    HostSqlStr := HostSqlStr + '"INITIALSCHEDULEDDATE", ';
    HostSqlStr := HostSqlStr + '"INITIALSCHEDULEDTIME", ';
    HostSqlStr := HostSqlStr + '"FINALSCHEDULEDDATE", ';
    HostSqlStr := HostSqlStr + '"FINALSCHEDULEDTIME", ';
    HostSqlStr := HostSqlStr + '"FIRSTJOBQUANTITYINCLUDED", ';
    HostSqlStr := HostSqlStr + '"LASTJOBQUANTITYINCLUDED", ';
    HostSqlStr := HostSqlStr + '"ABSUNIQUEID"';
   { HostSqlStr := HostSqlStr + '"CREATIONDATETIME", ';
    HostSqlStr := HostSqlStr + '"CREATIONUSER", ';
    HostSqlStr := HostSqlStr + '"LASTUPDATEDATETIME", ';
    HostSqlStr := HostSqlStr + '"LASTUPDATEUSER", ';
    HostSqlStr := HostSqlStr + '"CREATIONDATETIMEUTC", ';
    HostSqlStr := HostSqlStr + '"LASTUPDATEDATETIMEUTC" ';}

    HostQry.SQL.Clear;

    HostSqlStrVal := '';
    HostSqlStrVal := QuotedStr(IniAppGlobals.CompanyCode) +  DecSep;

    if IniAppGlobals.EnvironmentCode <> '' then
       HostSqlStrVal := HostSqlStrVal + QuotedStr(IniAppGlobals.EnvironmentCode) + DecSep;

    HostSqlStrVal := HostSqlStrVal + IntToStr(LineNumber) +  DecSep;
    HostSqlStrVal := HostSqlStrVal + QuotedStr('1') +  DecSep;
    HostSqlStrVal := HostSqlStrVal + QuotedStr('0') +  DecSep;
    HostSqlStrVal := HostSqlStrVal + IntTostr(0) +  DecSep;
    HostSqlStrVal := HostSqlStrVal + QuotedStr(Itemtype) +  DecSep;
    HostSqlStrVal := HostSqlStrVal + QuotedStr(LocalMQMWARPSCHED.ITEMTYPECODE) + DecSep ;
    HostSqlStrVal := HostSqlStrVal + FloatToStr(LocalMQMWARPSCHED.FIKDIDENTIFIER) + DecSep;
    HostSqlStrVal := HostSqlStrVal + QuotedStr(Itemtype) + DecSep;

   {   if trim(pMQMWARPSCHED(List_To_Be_insert[I]).SubDetailHostType) <> '0' then
        HostSqlStrVal := HostSqlStrVal + GetFirstPart(pMQMWARPSCHED(List_To_Be_insert[I]).SUB_DETAIL) +  DecSep
      else
        HostSqlStrVal := HostSqlStrVal + 'null' +  DecSep; }

    HostSqlStrVal := HostSqlStrVal + QuotedStr(LocalMQMWARPSCHED.CONTAINERITEMTYPECODE) + DecSep;
    HostSqlStrVal := HostSqlStrVal + QuotedStr(LocalMQMWARPSCHED.CONTAINERSUBCODE01) + DecSep;
   { if trim(pMQMWARPSCHED(List_To_Be_insert[I]).SubDetailHostType) <> '0' then
        HostSqlStrVal := HostSqlStrVal + GetSecondPart(pMQMWARPSCHED(List_To_Be_insert[I]).SUB_DETAIL) +  DecSep
      else
        HostSqlStrVal := HostSqlStrVal + 'null' +  DecSep;  }

    HostSqlStrVal := HostSqlStrVal + QuotedStr(Itemtype) +  DecSep;
    HostSqlStrVal := HostSqlStrVal + QuotedStr(LocalMQMWARPSCHED.CONTAINERELEMENTCODE) + DecSep;

   { if trim(pMQMWARPSCHED(List_To_Be_insert[I]).SubDetailHostType) = '2' then
      HostSqlStrVal := HostSqlStrVal + GetThirdPart(pMQMWARPSCHED(List_To_Be_insert[I]).SUB_DETAIL) + DecSep
    else if trim(pMQMWARPSCHED(List_To_Be_insert[I]).DetailCodeType) = '2' then
      HostSqlStrVal := HostSqlStrVal + 'null' +  DecSep
    else
      HostSqlStrVal := HostSqlStrVal + QuotedStr(pMQMWARPSCHED(List_To_Be_insert[I]).DETAIL_CODE) +  DecSep;}

    HostSqlStrVal := HostSqlStrVal + QuotedStr(Itemtype) + DecSep;
    HostSqlStrVal := HostSqlStrVal + QuotedStr('') + DecSep;

    HostSqlStrVal := HostSqlStrVal + QuotedStr(LocalMQMWARPSCHED.ELEMENTSCODE) + DecSep;
    HostSqlStrVal := HostSqlStrVal + QuotedStr(LocalMQMWARPSCHED.DEMANDCOUNTERCODE) + DecSep;
    HostSqlStrVal := HostSqlStrVal + QuotedStr(LocalMQMWARPSCHED.DEMANDCODE) + DecSep;

  {  if trim(pMQMWARPSCHED(List_To_Be_insert[I]).DetailCodeType) = '1' then
      HostSqlStrVal := HostSqlStrVal + 'null' + DecSep
    else
      HostSqlStrVal := HostSqlStrVal + QuotedStr(pMQMWARPSCHED(List_To_Be_insert[I]).DETAIL_CODE) +  DecSep;

    if trim(pMQMWARPSCHED(List_To_Be_insert[I]).PREQ_NO) <> '' then
      HostSqlStrVal := HostSqlStrVal + GetSecondPart(pMQMWARPSCHED(List_To_Be_insert[I]).SUB_DETAIL) +  DecSep
    else
      HostSqlStrVal := HostSqlStrVal + QuotedStr('') + DecSep;

    if trim(pMQMWARPSCHED(List_To_Be_insert[I]).PREQ_NO) <> '' then
      HostSqlStrVal := HostSqlStrVal + GetThirdPart(pMQMWARPSCHED(List_To_Be_insert[I]).SUB_DETAIL)  + DecSep
    else
      HostSqlStrVal := HostSqlStrVal + QuotedStr('') + DecSep;   }

    HostSqlStrVal := HostSqlStrVal + FloatToStr(LocalMQMWARPSCHED.QTY)+ DecSep;
    HostSqlStrVal := HostSqlStrVal + QuotedStr(LogicWHs) + DecSep;
    HostSqlStrVal := HostSqlStrVal + QuotedStr(LocalMQMWARPSCHED.LOGICALWAREHOUSECODE) + DecSep;
    HostSqlStrVal := HostSqlStrVal + QuotedStr(LocalMQMWARPSCHED.RSC_CODE) + DecSep;
    HostSqlStrVal := HostSqlStrVal + FloatToStr(LocalMQMWARPSCHED.OVERRIDENSETUPTIME) + DecSep;
    HostSqlStrVal := HostSqlStrVal + FloatToStr(LocalMQMWARPSCHED.OVERRIDENSPEED) + DecSep;

    //TODO FOR ORACLE
    HostSqlStrVal := HostSqlStrVal + QuotedStr(FormatDateTime('yyyy-mm-dd',LocalMQMWARPSCHED.SCH_START)) + DecSep;
    HostSqlStrVal := HostSqlStrVal + QuotedStr(FormatDateTime('HH:MM:SS',LocalMQMWARPSCHED.SCH_START)) +  DecSep;
    HostSqlStrVal := HostSqlStrVal + QuotedStr(FormatDateTime('yyyy-mm-dd',LocalMQMWARPSCHED.SCH_END)) + DecSep;
    HostSqlStrVal := HostSqlStrVal + QuotedStr(FormatDateTime('HH:MM:SS',LocalMQMWARPSCHED.SCH_END)) +  DecSep;

    HostSqlStrVal := HostSqlStrVal + FloatToStr(LocalMQMWARPSCHED.FIRSTJOBQUANTITYINCLUDED) +  DecSep;
    HostSqlStrVal := HostSqlStrVal + FloatToStr(LocalMQMWARPSCHED.LASTJOBQUANTITYINCLUDED) +  DecSep;
    HostSqlStrVal := HostSqlStrVal + IntToStr(0);

    HostSqlStrVal := HostSqlStrVal + ')';
    HostSqlStrVal := SetDecSeparator(HostSqlStrVal);

    HostQry.SQL.Text := HostSqlStr + ') values (';

    HostQry.SQL.Text := HostQry.SQL.Text + HostSqlStrVal;

    HostQry.Connection.StartTransaction;
    try
      HostQry.ExecSQL;
      HostQry.Connection.Commit;
    except
      on E: Exception do
      begin
        Result := false;
        sl := TStringList.Create;
        sl.Add(_('Sending') + ' Schedules - SendWarpSchedTableMqm');
        sl.Add('ITEMTYPECODE: ' + LocalMQMWARPSCHED.ITEMTYPECODE + ' ELEMENTSCODE: ' + LocalMQMWARPSCHED.ELEMENTSCODE +
               ' CONTAINERSUBCODE01: ' + LocalMQMWARPSCHED.CONTAINERSUBCODE01 + ' RSC_CODE: ' + LocalMQMWARPSCHED.RSC_CODE +
               ' DEMANDCODE: ' + LocalMQMWARPSCHED.DEMANDCODE + ' DEMANDCOUNTERCODE: ' + LocalMQMWARPSCHED.DEMANDCOUNTERCODE);
        sl.Add('DB Error : ' + E.Message);
        UpdateError(sl);
        sl.Free;
        Exit
      end;
    end;
  end else
    Continue;
 end;


  for I := HostSchedList.Count - 1 downto 0 do
     Dispose(PMQMWARPSCHED(HostSchedList[I]));

  for I := SrvSchedList.Count - 1 downto 0 do
     Dispose(PMQMWARPSCHED(SrvSchedList[I]));

  HostSchedList.Free;
  SrvSchedList.Free;

end;

//----------------------------------------------------------------------------//

function CopySendSchedTablesMqmAndMcm(tbl: table; ASLib, PCcondition: string;
                   linkArr: array of TQryLinkRec;
                   srvQry: TMqmQuery; HostQry: TMqmQuery; HIGHLEVELSCHEDULE_MQM_OR_MCM : string; Exist_HIGHLEVELSCHEDULE, Exist_COUNTERCOMPANYCODE,
                   Exist_Actual_Start_End : boolean): boolean;
var
  tbInfo : ^TTblInfo;
  srvSqlStr , HostSqlStr, HostSqlStrVal  : string;
  MQMPRODSCHED : PMQMPRODSCHED;
  HostSchedList : TList;
  List_To_Be_insert : Tlist;
  SrvSchedList      : TList;
  arraysize, Index_Host, Index_Srv, I, j : integer;
  Request,CompCod,Counter,Code : string;
  sl     : TStringList;
  ConvertDateFormat : Integer;
  INITIALSCHEDULEDDATETIME : TDateTime;
  FINALSCHEDULEDDATETIME   : TdateTime;
  INITIALSCHEDULEDDATEACTUALTIME : TDateTime;
  FINALSCHEDULEDDATEACTUALTIME   : TdateTime;
  Str : string;
  COUNTERCOMPANYCODE_InUsed : string;
  ScheduleMQMORMCM : string;
begin
  Result := true;
  tbInfo := @tblInfo[tbl];
  arraysize := -1;

  if HIGHLEVELSCHEDULE_MQM_OR_MCM = '0' then
    ScheduleMQMORMCM := 'MQM'
  else
    ScheduleMQMORMCM := 'MCM';

  FillListWorkCenterFromRes;

  if not GetCompanyLevelHandlingByEntityName('COUNTER',  COUNTERCOMPANYCODE_InUsed) then
     COUNTERCOMPANYCODE_InUsed := IniAppGlobals.CompanyCode;

  HostSchedList     := TList.Create;
  List_To_Be_insert := TList.Create;
  SrvSchedList      := TList.Create;

  UpdateOperation(_('Reading local schedule - ' + ScheduleMQMORMCM + ' ...'));

  PCcondition := ' Order by ' + CreateFld(tbInfo.pfx,fli_preqNo) + ',' + CreateFld(tbInfo.pfx,fli_pstepId) + ',' +
                 CreateFld(tbInfo.pfx,fli_psubstId) + ',' + CreateFld(tbInfo.pfx,fli_psubstId);

  // select the data from AS400
  with srvQry do
  begin
    UpdateOperation(_('Local query ') + ' ' + tbInfo.GetTableName);
    SQL.Clear;
    SQL.Add('update ' + tbInfo.GetTableName + ' set ' + CreateFld(tbInfo.pfx,fli_ExeMin) + ' = ' + '0 where ' + CreateFld(tbInfo.pfx,fli_ExeMin) + '>  999999');
    ExecSQL;
    srvQry.Transaction.Commit;
    SQL.Clear;
    SQL.Add('select');
    for i := 0 to High(linkArr)-1 do
      SQL.Add(CreatePfxFld(linkArr[i].fldPC) + ',');
    SQL.Add(CreatePfxFld(linkArr[High(linkArr)].fldPC) + ' from ' + tbInfo.GetTableName);
    SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_exeMin) + ' >= ''0''');
    if PCcondition <> '' then
      SQL.Add(PCcondition);
    Open;

    while not eof do
    begin
      Request := Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_preqNo)).AsString);
      ConvertToCopmanyCounterCode(Request,CompCod,Counter,Code);
      new(MQMPRODSCHED);
      MQMPRODSCHED.REQUEST     := Request;
      MQMPRODSCHED.COMPANYCODE := CompCod;
      MQMPRODSCHED.COUNTERCODE := Counter;
      MQMPRODSCHED.CODE        := Code;
      MQMPRODSCHED.STEPNUMBER  := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_PStepId)).AsInteger;
      MQMPRODSCHED.SUBSTEP     := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_psubstId)).AsInteger;
      MQMPRODSCHED.REPROCESS   := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_reprocNo)).AsInteger;
      MQMPRODSCHED.CANGROUP    := Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_StepIsGrouped)).AsString);
      MQMPRODSCHED.GROUPNUMBER := IntToStr(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_stGroup)).AsInteger);
      MQMPRODSCHED.SCHEDULETYPE    := Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_schedType)).AsString);
      MQMPRODSCHED.SCHEDULEDRESOURCECODE         := Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_rsc)).AsString);
      if (MQMPRODSCHED.SCHEDULEDRESOURCECODE <> '') then
        MQMPRODSCHED.SCHEDULEWORKCENTERCODE        := Trim(FindWorkCenterByCode(MQMPRODSCHED.SCHEDULEDRESOURCECODE))   //Trim(GetWorkCenterFromRes(MQMPRODSCHED.SCHEDULEDRESOURCECODE))
      else
        MQMPRODSCHED.SCHEDULEWORKCENTERCODE        := Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_wkCtrCode)).AsString);
      MQMPRODSCHED.SCHEDULEDRESOURCESUBLINE      := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_subLinRscId)).AsInteger;
      MQMPRODSCHED.NUMBEROFRESOURCECOMPONENTS    := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_NumSubRscComponents)).AsInteger;
      MQMPRODSCHED.QUANTITYINPRIMARYUOM          := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_quant)).AsFloat;
      MQMPRODSCHED.PRIMARYUOMCODE                := Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ProdUMCode)).AsString);
      MQMPRODSCHED.SETUPTIMEBEFOREMATERIAL       := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_supMinOvlp)).AsFloat;
      MQMPRODSCHED.SETUPTIMEAFTERMATERIAL        := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_supMinBase)).AsFloat;
      MQMPRODSCHED.EXECUTIONTIME                 := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_exeMin)).AsFloat;
      if MQMPRODSCHED.EXECUTIONTIME > 9999999 then
         MQMPRODSCHED.EXECUTIONTIME := 9999999;
      if IniAppGlobals.DownloadFrom = '0' then
        ConvertDateFormat := 1
      else if IniAppGlobals.DownloadFrom = '1' then
        ConvertDateFormat := 2
      else
        ConvertDateFormat := 1;

      INITIALSCHEDULEDDATETIME := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_schedStart)).AsDatetime;
      MQMPRODSCHED.INITIALSCHEDULEDDATE := ConvertDate_FormatTo(Trunc(INITIALSCHEDULEDDATETIME), ConvertDateFormat);
      MQMPRODSCHED.INITIALSCHEDULEDTIME := ConvertTime_FormatTo(Frac(INITIALSCHEDULEDDATETIME), ConvertDateFormat);

      FINALSCHEDULEDDATETIME := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_schedEnd)).AsDatetime;
      MQMPRODSCHED.FINALSCHEDULEDDATE := ConvertDate_FormatTo(Trunc(FINALSCHEDULEDDATETIME), ConvertDateFormat);
      MQMPRODSCHED.FINALSCHEDULEDTIME := ConvertTime_FormatTo(Frac(FINALSCHEDULEDDATETIME), ConvertDateFormat);

      if Exist_Actual_Start_End then
      begin
        INITIALSCHEDULEDDATEACTUALTIME := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ActualStart)).AsDatetime;
        MQMPRODSCHED.INITIALSCHEDULEDACTUALDATE := ConvertDate_FormatTo(Trunc(INITIALSCHEDULEDDATEACTUALTIME), ConvertDateFormat);
        MQMPRODSCHED.INITIALSCHEDULEDACTUALTIME := ConvertTime_FormatTo(Frac(INITIALSCHEDULEDDATEACTUALTIME), ConvertDateFormat);
      end;

      FINALSCHEDULEDDATEACTUALTIME := srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_ActualEnd)).AsDatetime;
      MQMPRODSCHED.FINALSCHEDULEDACTUALDATE := ConvertDate_FormatTo(Trunc(FINALSCHEDULEDDATEACTUALTIME), ConvertDateFormat);
      MQMPRODSCHED.FINALSCHEDULEDACTUALTIME := ConvertTime_FormatTo(Frac(FINALSCHEDULEDDATEACTUALTIME), ConvertDateFormat);

      MQMPRODSCHED.PLANNERCOMMENT                := Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_Comment)).AsString);
      MQMPRODSCHED.NewDemandUniqueId             := Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_NewPreqUniqId)).AsString);
      MQMPRODSCHED.SPLITFAMILY                   := Trim(srvQry.FieldByName(CreateFld(tbInfo.pfx, fli_SplitFamaly)).AsString);
      SrvSchedList.Add(MQMPRODSCHED);
      Next
    end;
    SrvSchedList.Sort(SortPSHost);
  end;

//  if Check_FamilyStructureInNow then
//    PrepareChildsDataFromFamily(SrvSchedList);

  UpdateOperation(_('Reading host schedule - ' + ScheduleMQMORMCM + ' ... '));

  with HostQry do
  begin

    if IniAppGlobals.DownloadFrom = '0' then
      ConvertDateFormat := 1
    else if IniAppGlobals.DownloadFrom = '1' then
      ConvertDateFormat := 2
    else
      ConvertDateFormat := 1;

    if ConvertDateFormat = 1 then
    begin
      if Exist_COUNTERCOMPANYCODE then
        srvSqlStr := 'SELECT COMPANYCODE, COUNTERCOMPANYCODE, COUNTERCODE, CODE, STEPNUMBER, SUBSTEP, '
      else
        srvSqlStr := 'SELECT COMPANYCODE, COUNTERCODE, CODE, STEPNUMBER, SUBSTEP, ';
      srvSqlStr := srvSqlStr + 'REPROCESS, CANGROUP, GROUPNUMBER, SCHEDULETYPE, ';
      srvSqlStr := srvSqlStr + 'SCHEDULEDWORKCENTERCODE, SCHEDULEDRESOURCECODE, ';
      srvSqlStr := srvSqlStr + 'SCHEDULEDRESOURCESUBLINE, NUMBEROFRESOURCECOMPONENTS, ';
      srvSqlStr := srvSqlStr + 'QUANTITYINPRIMARYUOM, PRIMARYUOMCODE, SETUPTIMEBEFOREMATERIAL, ';
      srvSqlStr := srvSqlStr + 'SETUPTIMEAFTERMATERIAL, EXECUTIONTIME, INITIALSCHEDULEDDATE, INITIALSCHEDULEDTIME, ';
      srvSqlStr := srvSqlStr + 'FINALSCHEDULEDDATE,FINALSCHEDULEDTIME, PLANNERCOMMENT, NEWDEMANDUNIQUEID, ';
      if Exist_Actual_Start_End then
        srvSqlStr := srvSqlStr + 'INITIALSCHEDULEDACTUALDATE, INITIALSCHEDULEDACTUALTIME, FINALSCHEDULEDACTUALDATE, FINALSCHEDULEDACTUALTIME, ';
      srvSqlStr := srvSqlStr + 'SPLITFAMILY FROM SCHEDULESOFSTEPSPLITS ';
      srvSqlStr := srvSqlStr + 'WHERE COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ';
      if IniAppGlobals.EnvironmentCode <> '' then
        srvSqlStr := srvSqlStr + 'AND ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' ';

      if Exist_HIGHLEVELSCHEDULE then
        srvSqlStr := srvSqlStr + ' AND ' + 'HIGHLEVELSCHEDULE = ' + QuotedStr(HIGHLEVELSCHEDULE_MQM_OR_MCM) + ' ';

      srvSqlStr := srvSqlStr + 'ORDER BY COMPANYCODE,COUNTERCODE, CODE, STEPNUMBER, SUBSTEP, REPROCESS';
    end
    else if ConvertDateFormat = 2 then
    begin
      if Exist_COUNTERCOMPANYCODE then
        srvSqlStr := 'SELECT COMPANYCODE, COUNTERCOMPANYCODE, COUNTERCODE, CODE, STEPNUMBER, SUBSTEP, '
      else
        srvSqlStr := 'SELECT COMPANYCODE, COUNTERCODE, CODE, STEPNUMBER, SUBSTEP, ';
      srvSqlStr := srvSqlStr + 'REPROCESS, CANGROUP, GROUPNUMBER, SCHEDULETYPE, ';
      srvSqlStr := srvSqlStr + 'SCHEDULEDWORKCENTERCODE, SCHEDULEDRESOURCECODE, ';
      srvSqlStr := srvSqlStr + 'SCHEDULEDRESOURCESUBLINE, NUMBEROFRESOURCECOMPONENTS, ';
      srvSqlStr := srvSqlStr + 'QUANTITYINPRIMARYUOM, PRIMARYUOMCODE, SETUPTIMEBEFOREMATERIAL, ';
      srvSqlStr := srvSqlStr + 'SETUPTIMEAFTERMATERIAL, EXECUTIONTIME, INITIALSCHEDULEDDATE, ';
      srvSqlStr := srvSqlStr + 'TO_CHAR(INITIALSCHEDULEDTIME,'+ QuotedStr('HH24:MI:SS')+')' + '"INITIALSCHEDULEDTIME", ';
      srvSqlStr := srvSqlStr + 'FINALSCHEDULEDDATE, ';
      srvSqlStr := srvSqlStr + 'TO_CHAR(FINALSCHEDULEDTIME,'+ QuotedStr('HH24:MI:SS')+')' + '"FINALSCHEDULEDTIME", ';
      srvSqlStr := srvSqlStr + 'PLANNERCOMMENT, NEWDEMANDUNIQUEID, ';
      if Exist_Actual_Start_End then
        srvSqlStr := srvSqlStr + 'INITIALSCHEDULEDACTUALDATE, INITIALSCHEDULEDACTUALTIME, FINALSCHEDULEDACTUALDATE, FINALSCHEDULEDACTUALTIME, ';
      srvSqlStr := srvSqlStr + 'SPLITFAMILY FROM SCHEDULESOFSTEPSPLITS ';
      srvSqlStr := srvSqlStr + 'WHERE COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ';
      if IniAppGlobals.EnvironmentCode <> '' then
        srvSqlStr := srvSqlStr + 'AND ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' ';
      if Exist_HIGHLEVELSCHEDULE then
        srvSqlStr := srvSqlStr + ' AND ' + 'HIGHLEVELSCHEDULE = ' + QuotedStr(HIGHLEVELSCHEDULE_MQM_OR_MCM) + ' ';

      srvSqlStr := srvSqlStr + 'ORDER BY COMPANYCODE,COUNTERCODE, CODE, STEPNUMBER, SUBSTEP, REPROCESS';
    end;

    SQL.Text := srvSqlStr;

    HostQry.Open;

    while not HostQry.eof do
    begin
      new(MQMPRODSCHED);
      MQMPRODSCHED.COMPANYCODE := Trim(HostQry.FieldByName('COMPANYCODE').AsString);
      MQMPRODSCHED.COUNTERCODE := Trim(HostQry.FieldByName('COUNTERCODE').AsString);
      MQMPRODSCHED.CODE        := Trim(HostQry.FieldByName('CODE').AsString);
      MQMPRODSCHED.STEPNUMBER  := HostQry.FieldByName('STEPNUMBER').AsInteger;
      MQMPRODSCHED.SUBSTEP     := HostQry.FieldByName('SUBSTEP').AsInteger;
      MQMPRODSCHED.REPROCESS   := HostQry.FieldByName('REPROCESS').AsInteger;
      MQMPRODSCHED.CANGROUP    := Trim(HostQry.FieldByName('CANGROUP').AsString);
      MQMPRODSCHED.GROUPNUMBER := '0';
      if Trim(HostQry.FieldByName('GROUPNUMBER').AsString) <> '' then
        MQMPRODSCHED.GROUPNUMBER := Trim(HostQry.FieldByName('GROUPNUMBER').AsString);
      MQMPRODSCHED.SCHEDULETYPE    := Trim(HostQry.FieldByName('SCHEDULETYPE').AsString);
      MQMPRODSCHED.SCHEDULEWORKCENTERCODE        := Trim(HostQry.FieldByName('SCHEDULEDWORKCENTERCODE').AsString);
      MQMPRODSCHED.SCHEDULEDRESOURCECODE         := Trim(HostQry.FieldByName('SCHEDULEDRESOURCECODE').AsString);
      MQMPRODSCHED.SCHEDULEDRESOURCESUBLINE      := HostQry.FieldByName('SCHEDULEDRESOURCESUBLINE').AsInteger;
      MQMPRODSCHED.NUMBEROFRESOURCECOMPONENTS    := HostQry.FieldByName('NUMBEROFRESOURCECOMPONENTS').AsInteger;
      MQMPRODSCHED.QUANTITYINPRIMARYUOM          := HostQry.FieldByName('QUANTITYINPRIMARYUOM').AsFloat;
      MQMPRODSCHED.PRIMARYUOMCODE                := Trim(HostQry.FieldByName('PRIMARYUOMCODE').AsString);
      MQMPRODSCHED.SETUPTIMEBEFOREMATERIAL       := HostQry.FieldByName('SETUPTIMEBEFOREMATERIAL').AsFloat;
      MQMPRODSCHED.SETUPTIMEAFTERMATERIAL        := HostQry.FieldByName('SETUPTIMEAFTERMATERIAL').AsFloat;
      MQMPRODSCHED.EXECUTIONTIME                 := HostQry.FieldByName('EXECUTIONTIME').AsFloat;
      if MQMPRODSCHED.EXECUTIONTIME > 9999999 then
           MQMPRODSCHED.EXECUTIONTIME := 9999999;
      if ConvertDateFormat = 1 then
      begin
        MQMPRODSCHED.INITIALSCHEDULEDDATE            := ConvertDate_FormatTo(HostQry.FieldByName('INITIALSCHEDULEDDATE').AsDateTime , ConvertDateFormat);
        MQMPRODSCHED.INITIALSCHEDULEDTIME            := ConvertTime_FormatTo(HostQry.FieldByName('INITIALSCHEDULEDTIME').AsDateTime , ConvertDateFormat);
        MQMPRODSCHED.FINALSCHEDULEDDATE              := ConvertDate_FormatTo(HostQry.FieldByName('FINALSCHEDULEDDATE').AsDateTime, ConvertDateFormat);
        MQMPRODSCHED.FINALSCHEDULEDTIME              := ConvertTime_FormatTo(HostQry.FieldByName('FINALSCHEDULEDTIME').AsDateTime, ConvertDateFormat);
        if Exist_Actual_Start_End then
        begin
          MQMPRODSCHED.INITIALSCHEDULEDACTUALDATE            := ConvertDate_FormatTo(HostQry.FieldByName('INITIALSCHEDULEDACTUALDATE').AsDateTime , ConvertDateFormat);
          MQMPRODSCHED.INITIALSCHEDULEDACTUALTIME            := ConvertTime_FormatTo(HostQry.FieldByName('INITIALSCHEDULEDACTUALTIME').AsDateTime , ConvertDateFormat);
          MQMPRODSCHED.FINALSCHEDULEDACTUALDATE              := ConvertDate_FormatTo(HostQry.FieldByName('FINALSCHEDULEDACTUALDATE').AsDateTime, ConvertDateFormat);
          MQMPRODSCHED.FINALSCHEDULEDACTUALTIME              := ConvertTime_FormatTo(HostQry.FieldByName('FINALSCHEDULEDACTUALTIME').AsDateTime, ConvertDateFormat);
        end;
      end;

      if ConvertDateFormat = 2 then
      begin
        MQMPRODSCHED.INITIALSCHEDULEDDATE            := ConvertDate_FormatTo(HostQry.FieldByName('INITIALSCHEDULEDDATE').AsDateTime , ConvertDateFormat);
        Str := Trim(HostQry.FieldByName('INITIALSCHEDULEDTIME').AsString);
        if Str = '' then
           MQMPRODSCHED.INITIALSCHEDULEDTIME := ConvertTime_FormatTo(0 , ConvertDateFormat)
        else
          MQMPRODSCHED.INITIALSCHEDULEDTIME  := ConvertTimeToOracle(Str);
        MQMPRODSCHED.FINALSCHEDULEDDATE              := ConvertDate_FormatTo(HostQry.FieldByName('FINALSCHEDULEDDATE').AsDateTime, ConvertDateFormat);
        Str := HostQry.FieldByName('FINALSCHEDULEDTIME').AsString;
        if str = '' then
           MQMPRODSCHED.FINALSCHEDULEDTIME := ConvertTime_FormatTo(0 , ConvertDateFormat)
        else
          MQMPRODSCHED.FINALSCHEDULEDTIME    := ConvertTimeToOracle(Str);

        if Exist_Actual_Start_End then
        begin
          MQMPRODSCHED.INITIALSCHEDULEDACTUALDATE            := ConvertDate_FormatTo(HostQry.FieldByName('INITIALSCHEDULEDACTUALDATE').AsDateTime , ConvertDateFormat);
          Str := Trim(HostQry.FieldByName('INITIALSCHEDULEDACTUALTIME').AsString);
          if Str = '' then
             MQMPRODSCHED.INITIALSCHEDULEDACTUALTIME := ConvertTime_FormatTo(0 , ConvertDateFormat)
          else
            MQMPRODSCHED.INITIALSCHEDULEDACTUALTIME  := ConvertTimeToOracle(Str);
          MQMPRODSCHED.FINALSCHEDULEDACTUALDATE      := ConvertDate_FormatTo(HostQry.FieldByName('FINALSCHEDULEDACTUALDATE').AsDateTime, ConvertDateFormat);
          Str := HostQry.FieldByName('FINALSCHEDULEDACTUALTIME').AsString;
          if str = '' then
             MQMPRODSCHED.FINALSCHEDULEDACTUALTIME := ConvertTime_FormatTo(0 , ConvertDateFormat)
          else
            MQMPRODSCHED.FINALSCHEDULEDACTUALTIME    := ConvertTimeToOracle(Str);
        end;

      end;

      MQMPRODSCHED.PLANNERCOMMENT                := trim(HostQry.FieldByName('PLANNERCOMMENT').AsString);
      MQMPRODSCHED.NewDemandUniqueId             := Trim(HostQry.FieldByName('NewDemandUniqueId').AsString);
      MQMPRODSCHED.SPLITFAMILY                   := Trim(HostQry.FieldByName('SPLITFAMILY').AsString);
      HostSchedList.Add(MQMPRODSCHED);
      next;
    end;
    Close;
 end;

 UpdateOperation(_('Compare and insert modification to host - ' + ScheduleMQMORMCM + ' ... '));

 Index_Host := 0;
 Index_Srv  := 0;
 while true do
 begin

   if (Index_Srv > SrvSchedList.count - 1) and (Index_Host > HostSchedList.count - 1) then break;

   if (Index_Srv > SrvSchedList.count - 1) or

     ((Index_Srv <= SrvSchedList.count - 1) and  not (Index_Host > HostSchedList.count - 1) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).COMPANYCODE > pMQMPRODSCHED(HostSchedList[Index_Host]).COMPANYCODE)) or

     ((Index_Srv <= SrvSchedList.count - 1) and  not (Index_Host > HostSchedList.count - 1) and
      (pMQMPRODSCHED(SrvSchedList[Index_srv]).COMPANYCODE = pMQMPRODSCHED(HostSchedList[Index_Host]).COMPANYCODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).COUNTERCODE > pMQMPRODSCHED(HostSchedList[Index_Host]).COUNTERCODE)) or

     ((Index_Srv <= SrvSchedList.count - 1) and  not (Index_Host > HostSchedList.count - 1) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).COMPANYCODE = pMQMPRODSCHED(HostSchedList[Index_Host]).COMPANYCODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).COUNTERCODE = pMQMPRODSCHED(HostSchedList[Index_Host]).COUNTERCODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).CODE > pMQMPRODSCHED(HostSchedList[Index_Host]).CODE)) or

     ((Index_Srv <= SrvSchedList.count - 1) and  not (Index_Host > HostSchedList.count - 1) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).COMPANYCODE = pMQMPRODSCHED(HostSchedList[Index_Host]).COMPANYCODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).COUNTERCODE  = pMQMPRODSCHED(HostSchedList[Index_Host]).COUNTERCODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).CODE = pMQMPRODSCHED(HostSchedList[Index_Host]).CODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).STEPNUMBER > pMQMPRODSCHED(HostSchedList[Index_Host]).STEPNUMBER)) or

     ((Index_Srv <= SrvSchedList.count - 1) and not (Index_Host > HostSchedList.count - 1) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).COMPANYCODE = pMQMPRODSCHED(HostSchedList[Index_Host]).COMPANYCODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).COUNTERCODE  = pMQMPRODSCHED(HostSchedList[Index_Host]).COUNTERCODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).CODE = pMQMPRODSCHED(HostSchedList[Index_Host]).CODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).STEPNUMBER = pMQMPRODSCHED(HostSchedList[Index_Host]).STEPNUMBER) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).SUBSTEP > pMQMPRODSCHED(HostSchedList[Index_Host]).SUBSTEP)) or

     ((Index_Srv <= SrvSchedList.count - 1) and not (Index_Host > HostSchedList.count - 1) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).COMPANYCODE = pMQMPRODSCHED(HostSchedList[Index_Host]).COMPANYCODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).COUNTERCODE = pMQMPRODSCHED(HostSchedList[Index_Host]).COUNTERCODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).CODE = pMQMPRODSCHED(HostSchedList[Index_Host]).CODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).STEPNUMBER = pMQMPRODSCHED(HostSchedList[Index_Host]).STEPNUMBER) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).SUBSTEP = pMQMPRODSCHED(HostSchedList[Index_Host]).SUBSTEP) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).REPROCESS > pMQMPRODSCHED(HostSchedList[Index_Host]).REPROCESS)) then
    begin
      // to be deleted
      new(MQMPRODSCHED);
      MQMPRODSCHED.COMPANYCODE := pMQMPRODSCHED(HostSchedList[Index_Host]).COMPANYCODE;
      MQMPRODSCHED.COUNTERCODE := pMQMPRODSCHED(HostSchedList[Index_Host]).COUNTERCODE;
      MQMPRODSCHED.CODE        := pMQMPRODSCHED(HostSchedList[Index_Host]).CODE;
      MQMPRODSCHED.STEPNUMBER  := pMQMPRODSCHED(HostSchedList[Index_Host]).STEPNUMBER;
      MQMPRODSCHED.SUBSTEP     := pMQMPRODSCHED(HostSchedList[Index_Host]).SUBSTEP;
      MQMPRODSCHED.REPROCESS   := pMQMPRODSCHED(HostSchedList[Index_Host]).REPROCESS;
      MQMPRODSCHED.CANGROUP    := pMQMPRODSCHED(HostSchedList[Index_Host]).CANGROUP;
      MQMPRODSCHED.GROUPNUMBER := pMQMPRODSCHED(HostSchedList[Index_Host]).GROUPNUMBER;
      MQMPRODSCHED.SCHEDULETYPE    := pMQMPRODSCHED(HostSchedList[Index_Host]).SCHEDULETYPE;
      MQMPRODSCHED.SCHEDULEWORKCENTERCODE        := pMQMPRODSCHED(HostSchedList[Index_Host]).SCHEDULEWORKCENTERCODE;
      MQMPRODSCHED.SCHEDULEDRESOURCECODE         := pMQMPRODSCHED(HostSchedList[Index_Host]).SCHEDULEDRESOURCECODE;
      MQMPRODSCHED.SCHEDULEDRESOURCESUBLINE      := pMQMPRODSCHED(HostSchedList[Index_Host]).SCHEDULEDRESOURCESUBLINE;
      MQMPRODSCHED.NUMBEROFRESOURCECOMPONENTS    := pMQMPRODSCHED(HostSchedList[Index_Host]).NUMBEROFRESOURCECOMPONENTS;
      MQMPRODSCHED.QUANTITYINPRIMARYUOM          := pMQMPRODSCHED(HostSchedList[Index_Host]).QUANTITYINPRIMARYUOM;
      MQMPRODSCHED.PRIMARYUOMCODE                := pMQMPRODSCHED(HostSchedList[Index_Host]).PRIMARYUOMCODE;
      MQMPRODSCHED.SETUPTIMEBEFOREMATERIAL       := pMQMPRODSCHED(HostSchedList[Index_Host]).SETUPTIMEBEFOREMATERIAL;
      MQMPRODSCHED.SETUPTIMEAFTERMATERIAL        := pMQMPRODSCHED(HostSchedList[Index_Host]).SETUPTIMEAFTERMATERIAL;
      MQMPRODSCHED.EXECUTIONTIME                 := pMQMPRODSCHED(HostSchedList[Index_Host]).EXECUTIONTIME;
      MQMPRODSCHED.INITIALSCHEDULEDDATE          := pMQMPRODSCHED(HostSchedList[Index_Host]).INITIALSCHEDULEDDATE;
      MQMPRODSCHED.INITIALSCHEDULEDTIME          := pMQMPRODSCHED(HostSchedList[Index_Host]).INITIALSCHEDULEDTIME;
      MQMPRODSCHED.FINALSCHEDULEDDATE            := pMQMPRODSCHED(HostSchedList[Index_Host]).FINALSCHEDULEDDATE;
      MQMPRODSCHED.FINALSCHEDULEDTIME            := pMQMPRODSCHED(HostSchedList[Index_Host]).FINALSCHEDULEDTIME;
      MQMPRODSCHED.INITIALSCHEDULEDACTUALDATE    := pMQMPRODSCHED(HostSchedList[Index_Host]).INITIALSCHEDULEDACTUALDATE;
      MQMPRODSCHED.INITIALSCHEDULEDACTUALTIME    := pMQMPRODSCHED(HostSchedList[Index_Host]).INITIALSCHEDULEDACTUALTIME;
      MQMPRODSCHED.FINALSCHEDULEDACTUALDATE      := pMQMPRODSCHED(HostSchedList[Index_Host]).FINALSCHEDULEDACTUALDATE;
      MQMPRODSCHED.FINALSCHEDULEDACTUALTIME      := pMQMPRODSCHED(HostSchedList[Index_Host]).FINALSCHEDULEDACTUALTIME;
      MQMPRODSCHED.PLANNERCOMMENT                := pMQMPRODSCHED(HostSchedList[Index_Host]).PLANNERCOMMENT;
      MQMPRODSCHED.NewDemandUniqueId             := pMQMPRODSCHED(HostSchedList[Index_Host]).NewDemandUniqueId;
      MQMPRODSCHED.SPLITFAMILY                   := pMQMPRODSCHED(HostSchedList[Index_Host]).SPLITFAMILY;
      MQMPRODSCHED.ChangedType := '3';
      if MQMPRODSCHED.QUANTITYINPRIMARYUOM > 0 then
        List_To_Be_insert.Add(MQMPRODSCHED)
      else if (MQMPRODSCHED.SCHEDULEDRESOURCECODE = '') and (MQMPRODSCHED.QUANTITYINPRIMARYUOM = 0) and (MQMPRODSCHED.SCHEDULEWORKCENTERCODE <> '') then
        List_To_Be_insert.Add(MQMPRODSCHED); // for mcm
      Inc(Index_Host);
      continue
    end;

    //  if (Index_Srv > SrvSchedList.count - 1) or

    if (HostSchedList.count = 0) or (Index_Host > HostSchedList.count - 1) or

     ((Index_Srv <= SrvSchedList.count - 1) and (not (Index_Host > HostSchedList.count - 1)) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).COMPANYCODE < pMQMPRODSCHED(HostSchedList[Index_Host]).COMPANYCODE)) or

     ((Index_Srv <= SrvSchedList.count - 1) and (not (Index_Host > HostSchedList.count - 1)) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).COMPANYCODE = pMQMPRODSCHED(HostSchedList[Index_Host]).COMPANYCODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).COUNTERCODE < pMQMPRODSCHED(HostSchedList[Index_Host]).COUNTERCODE)) or

     ((Index_Srv <= SrvSchedList.count - 1) and (not (Index_Host > HostSchedList.count - 1)) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).COMPANYCODE = pMQMPRODSCHED(HostSchedList[Index_Host]).COMPANYCODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).COUNTERCODE = pMQMPRODSCHED(HostSchedList[Index_Host]).COUNTERCODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).CODE < pMQMPRODSCHED(HostSchedList[Index_Host]).CODE)) or

     ((Index_Srv <= SrvSchedList.count - 1) and (not (Index_Host > HostSchedList.count - 1)) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).COMPANYCODE = pMQMPRODSCHED(HostSchedList[Index_Host]).COMPANYCODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).COUNTERCODE = pMQMPRODSCHED(HostSchedList[Index_Host]).COUNTERCODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).CODE = pMQMPRODSCHED(HostSchedList[Index_Host]).CODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).STEPNUMBER < pMQMPRODSCHED(HostSchedList[Index_Host]).STEPNUMBER)) or

     ((Index_Srv <= SrvSchedList.count - 1) and (not (Index_Host > HostSchedList.count - 1)) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).COMPANYCODE = pMQMPRODSCHED(HostSchedList[Index_Host]).COMPANYCODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).COUNTERCODE = pMQMPRODSCHED(HostSchedList[Index_Host]).COUNTERCODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).CODE = pMQMPRODSCHED(HostSchedList[Index_Host]).CODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).STEPNUMBER = pMQMPRODSCHED(HostSchedList[Index_Host]).STEPNUMBER) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).SUBSTEP < pMQMPRODSCHED(HostSchedList[Index_Host]).SUBSTEP)) or

     ((Index_Srv <= SrvSchedList.count - 1) and (not (Index_Host > HostSchedList.count - 1)) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).COMPANYCODE = pMQMPRODSCHED(HostSchedList[Index_Host]).COMPANYCODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).COUNTERCODE = pMQMPRODSCHED(HostSchedList[Index_Host]).COUNTERCODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).CODE = pMQMPRODSCHED(HostSchedList[Index_Host]).CODE) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).STEPNUMBER = pMQMPRODSCHED(HostSchedList[Index_Host]).STEPNUMBER) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).SUBSTEP = pMQMPRODSCHED(HostSchedList[Index_Host]).SUBSTEP) and
      (pMQMPRODSCHED(SrvSchedList[Index_Srv]).REPROCESS < pMQMPRODSCHED(HostSchedList[Index_Host]).REPROCESS)) then

    begin
      // To be insert
      new(MQMPRODSCHED);
      MQMPRODSCHED.COMPANYCODE := pMQMPRODSCHED(SrvSchedList[Index_Srv]).COMPANYCODE;
      MQMPRODSCHED.COUNTERCODE := pMQMPRODSCHED(SrvSchedList[Index_Srv]).COUNTERCODE;
      MQMPRODSCHED.CODE        := pMQMPRODSCHED(SrvSchedList[Index_Srv]).CODE;
      MQMPRODSCHED.STEPNUMBER  := pMQMPRODSCHED(SrvSchedList[Index_Srv]).STEPNUMBER;
      MQMPRODSCHED.SUBSTEP     := pMQMPRODSCHED(SrvSchedList[Index_Srv]).SUBSTEP;
      MQMPRODSCHED.REPROCESS   := pMQMPRODSCHED(SrvSchedList[Index_Srv]).REPROCESS;
      MQMPRODSCHED.CANGROUP    := pMQMPRODSCHED(SrvSchedList[Index_Srv]).CANGROUP;
      MQMPRODSCHED.GROUPNUMBER := pMQMPRODSCHED(SrvSchedList[Index_Srv]).GROUPNUMBER;
      MQMPRODSCHED.SCHEDULETYPE    := pMQMPRODSCHED(SrvSchedList[Index_Srv]).SCHEDULETYPE;
      MQMPRODSCHED.SCHEDULEWORKCENTERCODE        := pMQMPRODSCHED(SrvSchedList[Index_Srv]).SCHEDULEWORKCENTERCODE;
      MQMPRODSCHED.SCHEDULEDRESOURCECODE         := pMQMPRODSCHED(SrvSchedList[Index_Srv]).SCHEDULEDRESOURCECODE;
      MQMPRODSCHED.SCHEDULEDRESOURCESUBLINE      := pMQMPRODSCHED(SrvSchedList[Index_Srv]).SCHEDULEDRESOURCESUBLINE;
      MQMPRODSCHED.NUMBEROFRESOURCECOMPONENTS    := pMQMPRODSCHED(SrvSchedList[Index_Srv]).NUMBEROFRESOURCECOMPONENTS;
      MQMPRODSCHED.QUANTITYINPRIMARYUOM          := pMQMPRODSCHED(SrvSchedList[Index_Srv]).QUANTITYINPRIMARYUOM;
      MQMPRODSCHED.PRIMARYUOMCODE                := pMQMPRODSCHED(SrvSchedList[Index_Srv]).PRIMARYUOMCODE;
      MQMPRODSCHED.SETUPTIMEBEFOREMATERIAL       := pMQMPRODSCHED(SrvSchedList[Index_Srv]).SETUPTIMEBEFOREMATERIAL;
      MQMPRODSCHED.SETUPTIMEAFTERMATERIAL        := pMQMPRODSCHED(SrvSchedList[Index_Srv]).SETUPTIMEAFTERMATERIAL;
      MQMPRODSCHED.EXECUTIONTIME                 := pMQMPRODSCHED(SrvSchedList[Index_Srv]).EXECUTIONTIME;
      MQMPRODSCHED.INITIALSCHEDULEDDATE          := pMQMPRODSCHED(SrvSchedList[Index_Srv]).INITIALSCHEDULEDDATE;
      MQMPRODSCHED.INITIALSCHEDULEDTIME          := pMQMPRODSCHED(SrvSchedList[Index_Srv]).INITIALSCHEDULEDTIME;
      MQMPRODSCHED.FINALSCHEDULEDDATE            := pMQMPRODSCHED(SrvSchedList[Index_Srv]).FINALSCHEDULEDDATE;
      MQMPRODSCHED.FINALSCHEDULEDTIME            := pMQMPRODSCHED(SrvSchedList[Index_Srv]).FINALSCHEDULEDTIME;
      MQMPRODSCHED.INITIALSCHEDULEDACTUALDATE    := pMQMPRODSCHED(SrvSchedList[Index_Srv]).INITIALSCHEDULEDACTUALDATE;
      MQMPRODSCHED.INITIALSCHEDULEDACTUALTIME    := pMQMPRODSCHED(SrvSchedList[Index_Srv]).INITIALSCHEDULEDACTUALTIME;
      MQMPRODSCHED.FINALSCHEDULEDACTUALDATE      := pMQMPRODSCHED(SrvSchedList[Index_Srv]).FINALSCHEDULEDACTUALDATE;
      MQMPRODSCHED.FINALSCHEDULEDACTUALTIME      := pMQMPRODSCHED(SrvSchedList[Index_Srv]).FINALSCHEDULEDACTUALTIME;
      MQMPRODSCHED.PLANNERCOMMENT                := pMQMPRODSCHED(SrvSchedList[Index_Srv]).PLANNERCOMMENT;
      MQMPRODSCHED.NewDemandUniqueId             := pMQMPRODSCHED(SrvSchedList[Index_Srv]).NewDemandUniqueId;
      MQMPRODSCHED.SPLITFAMILY                   := pMQMPRODSCHED(SrvSchedList[Index_Srv]).SPLITFAMILY;
      MQMPRODSCHED.ChangedType := '1';

      if MQMPRODSCHED.QUANTITYINPRIMARYUOM > 0 then
        List_To_Be_insert.Add(MQMPRODSCHED)
      else if (MQMPRODSCHED.SCHEDULEDRESOURCECODE = '') and (MQMPRODSCHED.QUANTITYINPRIMARYUOM = 0) and (MQMPRODSCHED.SCHEDULEWORKCENTERCODE <> '') then
        List_To_Be_insert.Add(MQMPRODSCHED); // for mcm
      Inc(Index_Srv);
      continue
    end;

      // Key is equal

    if not Exist_Actual_Start_End then
    begin
      pMQMPRODSCHED(SrvSchedList[Index_Srv]).INITIALSCHEDULEDACTUALDATE := '';
      pMQMPRODSCHED(HostSchedList[Index_Host]).INITIALSCHEDULEDACTUALDATE := '';
      pMQMPRODSCHED(SrvSchedList[Index_Srv]).INITIALSCHEDULEDACTUALTIME := '';
      pMQMPRODSCHED(HostSchedList[Index_Host]).INITIALSCHEDULEDACTUALTIME := '';
      pMQMPRODSCHED(SrvSchedList[Index_Srv]).FINALSCHEDULEDACTUALDATE  := '';
      pMQMPRODSCHED(HostSchedList[Index_Host]).FINALSCHEDULEDACTUALDATE := '';
      pMQMPRODSCHED(SrvSchedList[Index_Srv]).FINALSCHEDULEDACTUALTIME := '';
      pMQMPRODSCHED(HostSchedList[Index_Host]).FINALSCHEDULEDACTUALTIME := '';
    end;

    if (pMQMPRODSCHED(SrvSchedList[Index_Srv]).CANGROUP <> pMQMPRODSCHED(HostSchedList[Index_Host]).CANGROUP) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).GROUPNUMBER <> pMQMPRODSCHED(HostSchedList[Index_Host]).GROUPNUMBER) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).SCHEDULETYPE <> pMQMPRODSCHED(HostSchedList[Index_Host]).SCHEDULETYPE) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).SCHEDULEWORKCENTERCODE <> pMQMPRODSCHED(HostSchedList[Index_Host]).SCHEDULEWORKCENTERCODE) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).SCHEDULEDRESOURCECODE <> pMQMPRODSCHED(HostSchedList[Index_Host]).SCHEDULEDRESOURCECODE) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).SCHEDULEDRESOURCESUBLINE <> pMQMPRODSCHED(HostSchedList[Index_Host]).SCHEDULEDRESOURCESUBLINE) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).NUMBEROFRESOURCECOMPONENTS <> pMQMPRODSCHED(HostSchedList[Index_Host]).NUMBEROFRESOURCECOMPONENTS) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).QUANTITYINPRIMARYUOM <> pMQMPRODSCHED(HostSchedList[Index_Host]).QUANTITYINPRIMARYUOM) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).PRIMARYUOMCODE <> pMQMPRODSCHED(HostSchedList[Index_Host]).PRIMARYUOMCODE) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).SETUPTIMEBEFOREMATERIAL <> pMQMPRODSCHED(HostSchedList[Index_Host]).SETUPTIMEBEFOREMATERIAL) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).SETUPTIMEAFTERMATERIAL <> pMQMPRODSCHED(HostSchedList[Index_Host]).SETUPTIMEAFTERMATERIAL) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).EXECUTIONTIME <> pMQMPRODSCHED(HostSchedList[Index_Host]).EXECUTIONTIME) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).INITIALSCHEDULEDDATE <> pMQMPRODSCHED(HostSchedList[Index_Host]).INITIALSCHEDULEDDATE) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).INITIALSCHEDULEDTIME <> pMQMPRODSCHED(HostSchedList[Index_Host]).INITIALSCHEDULEDTIME) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).FINALSCHEDULEDDATE <> pMQMPRODSCHED(HostSchedList[Index_Host]).FINALSCHEDULEDDATE) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).FINALSCHEDULEDTIME <> pMQMPRODSCHED(HostSchedList[Index_Host]).FINALSCHEDULEDTIME) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).INITIALSCHEDULEDACTUALDATE <> pMQMPRODSCHED(HostSchedList[Index_Host]).INITIALSCHEDULEDACTUALDATE) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).INITIALSCHEDULEDACTUALTIME <> pMQMPRODSCHED(HostSchedList[Index_Host]).INITIALSCHEDULEDACTUALTIME) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).FINALSCHEDULEDACTUALDATE <> pMQMPRODSCHED(HostSchedList[Index_Host]).FINALSCHEDULEDACTUALDATE) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).FINALSCHEDULEDACTUALTIME <> pMQMPRODSCHED(HostSchedList[Index_Host]).FINALSCHEDULEDACTUALTIME) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).PLANNERCOMMENT <> pMQMPRODSCHED(HostSchedList[Index_Host]).PLANNERCOMMENT) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).NewDemandUniqueId <> pMQMPRODSCHED(HostSchedList[Index_Host]).NewDemandUniqueId) or
       (pMQMPRODSCHED(SrvSchedList[Index_Srv]).SPLITFAMILY <> pMQMPRODSCHED(HostSchedList[Index_Host]).SPLITFAMILY) then
    begin
      new(MQMPRODSCHED);
      MQMPRODSCHED.COMPANYCODE := pMQMPRODSCHED(SrvSchedList[Index_Srv]).COMPANYCODE;
      MQMPRODSCHED.COUNTERCODE := pMQMPRODSCHED(SrvSchedList[Index_Srv]).COUNTERCODE;
      MQMPRODSCHED.CODE        := pMQMPRODSCHED(SrvSchedList[Index_Srv]).CODE;
      MQMPRODSCHED.STEPNUMBER  := pMQMPRODSCHED(SrvSchedList[Index_Srv]).STEPNUMBER;
      MQMPRODSCHED.SUBSTEP     := pMQMPRODSCHED(SrvSchedList[Index_Srv]).SUBSTEP;
      MQMPRODSCHED.REPROCESS   := pMQMPRODSCHED(SrvSchedList[Index_Srv]).REPROCESS;
      MQMPRODSCHED.CANGROUP    := pMQMPRODSCHED(SrvSchedList[Index_Srv]).CANGROUP;
      MQMPRODSCHED.GROUPNUMBER := pMQMPRODSCHED(SrvSchedList[Index_Srv]).GROUPNUMBER;
      MQMPRODSCHED.SCHEDULETYPE    := pMQMPRODSCHED(SrvSchedList[Index_Srv]).SCHEDULETYPE;
      MQMPRODSCHED.SCHEDULEWORKCENTERCODE        := pMQMPRODSCHED(SrvSchedList[Index_Srv]).SCHEDULEWORKCENTERCODE;
      MQMPRODSCHED.SCHEDULEDRESOURCECODE         := pMQMPRODSCHED(SrvSchedList[Index_Srv]).SCHEDULEDRESOURCECODE;
      MQMPRODSCHED.SCHEDULEDRESOURCESUBLINE      := pMQMPRODSCHED(SrvSchedList[Index_Srv]).SCHEDULEDRESOURCESUBLINE;
      MQMPRODSCHED.NUMBEROFRESOURCECOMPONENTS    := pMQMPRODSCHED(SrvSchedList[Index_Srv]).NUMBEROFRESOURCECOMPONENTS;
      MQMPRODSCHED.QUANTITYINPRIMARYUOM          := pMQMPRODSCHED(SrvSchedList[Index_Srv]).QUANTITYINPRIMARYUOM;
      MQMPRODSCHED.PRIMARYUOMCODE                := pMQMPRODSCHED(SrvSchedList[Index_Srv]).PRIMARYUOMCODE;
      MQMPRODSCHED.SETUPTIMEBEFOREMATERIAL       := pMQMPRODSCHED(SrvSchedList[Index_Srv]).SETUPTIMEBEFOREMATERIAL;
      MQMPRODSCHED.SETUPTIMEAFTERMATERIAL        := pMQMPRODSCHED(SrvSchedList[Index_Srv]).SETUPTIMEAFTERMATERIAL;
      MQMPRODSCHED.EXECUTIONTIME                 := pMQMPRODSCHED(SrvSchedList[Index_Srv]).EXECUTIONTIME;
      MQMPRODSCHED.INITIALSCHEDULEDDATE          := pMQMPRODSCHED(SrvSchedList[Index_Srv]).INITIALSCHEDULEDDATE;
      MQMPRODSCHED.INITIALSCHEDULEDTIME          := pMQMPRODSCHED(SrvSchedList[Index_Srv]).INITIALSCHEDULEDTIME;
      MQMPRODSCHED.FINALSCHEDULEDDATE            := pMQMPRODSCHED(SrvSchedList[Index_Srv]).FINALSCHEDULEDDATE;
      MQMPRODSCHED.FINALSCHEDULEDTIME            := pMQMPRODSCHED(SrvSchedList[Index_Srv]).FINALSCHEDULEDTIME;
      MQMPRODSCHED.INITIALSCHEDULEDACTUALDATE    := pMQMPRODSCHED(SrvSchedList[Index_Srv]).INITIALSCHEDULEDACTUALDATE;
      MQMPRODSCHED.INITIALSCHEDULEDACTUALTIME    := pMQMPRODSCHED(SrvSchedList[Index_Srv]).INITIALSCHEDULEDACTUALTIME;
      MQMPRODSCHED.FINALSCHEDULEDACTUALDATE      := pMQMPRODSCHED(SrvSchedList[Index_Srv]).FINALSCHEDULEDACTUALDATE;
      MQMPRODSCHED.FINALSCHEDULEDACTUALTIME      := pMQMPRODSCHED(SrvSchedList[Index_Srv]).FINALSCHEDULEDACTUALTIME;
      MQMPRODSCHED.PLANNERCOMMENT                := pMQMPRODSCHED(SrvSchedList[Index_Srv]).PLANNERCOMMENT;
      MQMPRODSCHED.NewDemandUniqueId             := pMQMPRODSCHED(SrvSchedList[Index_Srv]).NewDemandUniqueId;
      MQMPRODSCHED.SPLITFAMILY                   := pMQMPRODSCHED(SrvSchedList[Index_Srv]).SPLITFAMILY;
      MQMPRODSCHED.ChangedType := '2';
      if MQMPRODSCHED.QUANTITYINPRIMARYUOM > 0 then
        List_To_Be_insert.Add(MQMPRODSCHED)
      else if (MQMPRODSCHED.SCHEDULEDRESOURCECODE = '') and (MQMPRODSCHED.QUANTITYINPRIMARYUOM = 0) and (MQMPRODSCHED.SCHEDULEWORKCENTERCODE <> '') then
        List_To_Be_insert.Add(MQMPRODSCHED); // for mcm
    end;

    Inc(Index_Host);
    Inc(Index_Srv);
  end;

  if List_To_Be_insert.Count > 0 then
  begin
    with HostQry do
    begin


 {   HostQry.SQL.Clear;
    HostQry.SQL.Add('insert into ' + tbInfo.GetTableName              + '(');
    HostQry.SQL.Add(CreateFld(tbInfo.pfx, fli_preqNo)           + ',');
    HostQry.SQL.Add(CreateFld(tbInfo.pfx, fli_pstepId)          + ',');
    HostQry.SQL.Add(CreateFld(tbInfo.pfx, fli_updCode)          + ',');
    HostQry.SQL.Add(CreateFl d(tbInfo.pfx, fli_ChangeType)       + ',');
    HostQry.SQL.Add(CreateFld(tbInfo.pfx, fli_ReactivateReq));
    HostQry.SQL.Add(') values (');
    HostQry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_preqNo)     + ',');
    HostQry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_pstepId)    + ',');
    HostQry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_updCode)    + ',');
    HostQry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_ChangeType) + ',');
    HostQry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_ReactivateReq));
    HostQry.SQL.Add(')');       }


//      HostQry.SQL.Text :=


      for j := 0 to 3 do
      begin
        // J = 0 Sched, J = 1 Sched+group , j = 2 NoSsched no group , j = 3 No Ssched grouped ,

        HostSqlStr := '';
        HostSqlStr := 'insert into "SCHEDULESUPLOAD" ' + '(';
        HostSqlStr := HostSqlStr + '"COMPANYCODE", ';
        if IniAppGlobals.EnvironmentCode <> '' then
           HostSqlStr := HostSqlStr + '"ENVIRONMENTCODE", ';
        if Exist_HIGHLEVELSCHEDULE then
          HostSqlStr := HostSqlStr + '"HIGHLEVELSCHEDULE", ';

        if Exist_COUNTERCOMPANYCODE then
          HostSqlStr := HostSqlStr + '"COUNTERCOMPANYCODE", ';

        HostSqlStr := HostSqlStr + '"COUNTERCODE", ';
        HostSqlStr := HostSqlStr + '"CODE", ';
        HostSqlStr := HostSqlStr + '"STEPNUMBER", ';
        HostSqlStr := HostSqlStr + '"SUBSTEP", ';
        HostSqlStr := HostSqlStr + '"REPROCESS", ';
        HostSqlStr := HostSqlStr + '"CANGROUP", ';
        if (j = 1) or (j = 3) then
          HostSqlStr := HostSqlStr + 'GROUPNUMBER, ';
        HostSqlStr := HostSqlStr + '"SCHEDULETYPE", ';
        if (j = 0) or (j = 1) then
          HostSqlStr := HostSqlStr + '"SCHEDULEDWORKCENTERCODE", ';

        if HIGHLEVELSCHEDULE_MQM_OR_MCM = '0' then // mqm
        begin
          if (j = 0) or (j = 1) then
            HostSqlStr := HostSqlStr + '"SCHEDULEDRESOURCECODE", ';
        end;
        HostSqlStr := HostSqlStr + '"SCHEDULEDRESOURCESUBLINE", ';
        HostSqlStr := HostSqlStr + '"NUMBEROFRESOURCECOMPONENTS", ';
        HostSqlStr := HostSqlStr + '"QUANTITYINPRIMARYUOM", ';
        HostSqlStr := HostSqlStr + '"PRIMARYUOMCODE", ';
        HostSqlStr := HostSqlStr + '"SETUPTIMEBEFOREMATERIAL", ';
        HostSqlStr := HostSqlStr + '"SETUPTIMEAFTERMATERIAL", ';
        HostSqlStr := HostSqlStr + '"EXECUTIONTIME", ';
        HostSqlStr := HostSqlStr + '"INITIALSCHEDULEDDATE", ';
        HostSqlStr := HostSqlStr + '"INITIALSCHEDULEDTIME", ';
        HostSqlStr := HostSqlStr + '"FINALSCHEDULEDDATE", ';
        HostSqlStr := HostSqlStr + '"FINALSCHEDULEDTIME", ';

        if Exist_Actual_Start_End then
        begin
          HostSqlStr := HostSqlStr + '"INITIALSCHEDULEDACTUALDATE", ';
          HostSqlStr := HostSqlStr + '"INITIALSCHEDULEDACTUALTIME", ';
          HostSqlStr := HostSqlStr + '"FINALSCHEDULEDACTUALDATE", ';
          HostSqlStr := HostSqlStr + '"FINALSCHEDULEDACTUALTIME", ';
        end;

        HostSqlStr := HostSqlStr + '"PLANNERCOMMENT", ';
        HostSqlStr := HostSqlStr + '"NEWDEMANDUNIQUEID", ';
        HostSqlStr := HostSqlStr + '"SPLITFAMILY", ';
        HostSqlStr := HostSqlStr + '"IMPORTSTATUS", ';
        HostSqlStr := HostSqlStr + '"CHANGETYPE", ';
        HostSqlStr := HostSqlStr + '"ABSUNIQUEID"';
        HostSqlStr := HostSqlStr + ') values (';

        HostQry.SQL.Clear;
  //      HostQry.Connection.BeginTrans;
  //      HostQry.Connection.CommitTrans;

        for I := 0 to List_To_Be_insert.count - 1 do
        begin

          if ((J = 0) and (pMQMPRODSCHED(List_To_Be_insert[I]).SCHEDULETYPE <> '0') and (pMQMPRODSCHED(List_To_Be_insert[I]).GROUPNUMBER = '0'))
          or ((J = 1) and (pMQMPRODSCHED(List_To_Be_insert[I]).SCHEDULETYPE <> '0') and (pMQMPRODSCHED(List_To_Be_insert[I]).GROUPNUMBER <> '0'))
          or ((j = 2) and (pMQMPRODSCHED(List_To_Be_insert[I]).SCHEDULETYPE = '0') and (pMQMPRODSCHED(List_To_Be_insert[I]).GROUPNUMBER = '0'))
          or ((j = 3) and (pMQMPRODSCHED(List_To_Be_insert[I]).SCHEDULETYPE = '0') and (pMQMPRODSCHED(List_To_Be_insert[I]).GROUPNUMBER <> '0')) then
          begin
            HostSqlStrVal := '';
            HostSqlStrVal := QuotedStr(pMQMPRODSCHED(List_To_Be_insert[I]).COMPANYCODE) +  DecSep;
            if IniAppGlobals.EnvironmentCode <> '' then
               HostSqlStrVal := HostSqlStrVal + QuotedStr(IniAppGlobals.EnvironmentCode) + DecSep;

            if Exist_HIGHLEVELSCHEDULE then
              HostSqlStrVal := HostSqlStrVal + QuotedStr(HIGHLEVELSCHEDULE_MQM_OR_MCM)+ DecSep;
            if Exist_COUNTERCOMPANYCODE then
              HostSqlStrVal := HostSqlStrVal + QuotedStr(COUNTERCOMPANYCODE_InUsed)+ DecSep;

            HostSqlStrVal := HostSqlStrVal + QuotedStr(pMQMPRODSCHED(List_To_Be_insert[I]).COUNTERCODE) +  DecSep;
            HostSqlStrVal := HostSqlStrVal + QuotedStr(pMQMPRODSCHED(List_To_Be_insert[I]).CODE) +  DecSep;
            HostSqlStrVal := HostSqlStrVal + IntTostr(pMQMPRODSCHED(List_To_Be_insert[I]).STEPNUMBER) +  DecSep;
            HostSqlStrVal := HostSqlStrVal + IntTostr(pMQMPRODSCHED(List_To_Be_insert[I]).SUBSTEP) +  DecSep;
            HostSqlStrVal := HostSqlStrVal + IntTostr(pMQMPRODSCHED(List_To_Be_insert[I]).REPROCESS) +  DecSep;
            HostSqlStrVal := HostSqlStrVal + QuotedStr(pMQMPRODSCHED(List_To_Be_insert[I]).CANGROUP) + DecSep ;
            if (j = 1) or (j = 3) then
              HostSqlStrVal := HostSqlStrVal + QuotedStr(pMQMPRODSCHED(List_To_Be_insert[I]).GROUPNUMBER) + DecSep;
            HostSqlStrVal := HostSqlStrVal + QuotedStr(pMQMPRODSCHED(List_To_Be_insert[I]).SCHEDULETYPE) + DecSep;
            if (j = 0) or (j = 1) then
            begin
              if trim(pMQMPRODSCHED(List_To_Be_insert[I]).SCHEDULEWORKCENTERCODE) = '' then
                HostSqlStrVal := HostSqlStrVal + 'null' +  DecSep
              else
                HostSqlStrVal := HostSqlStrVal + QuotedStr(pMQMPRODSCHED(List_To_Be_insert[I]).SCHEDULEWORKCENTERCODE) +  DecSep;
            end;

            if HIGHLEVELSCHEDULE_MQM_OR_MCM = '0' then
            begin
              if (j = 0) or (j = 1) then
                HostSqlStrVal := HostSqlStrVal + QuotedStr(pMQMPRODSCHED(List_To_Be_insert[I]).SCHEDULEDRESOURCECODE) +   DecSep;
            end;

            HostSqlStrVal := HostSqlStrVal + Inttostr(pMQMPRODSCHED(List_To_Be_insert[I]).SCHEDULEDRESOURCESUBLINE) +  DecSep;
            HostSqlStrVal := HostSqlStrVal + inttostr(pMQMPRODSCHED(List_To_Be_insert[I]).NUMBEROFRESOURCECOMPONENTS) + DecSep;
            HostSqlStrVal := HostSqlStrVal + floattostr(pMQMPRODSCHED(List_To_Be_insert[I]).QUANTITYINPRIMARYUOM) + DecSep;
            HostSqlStrVal := HostSqlStrVal + QuotedStr(pMQMPRODSCHED(List_To_Be_insert[I]).PRIMARYUOMCODE) + DecSep;
            HostSqlStrVal := HostSqlStrVal + floattostr(pMQMPRODSCHED(List_To_Be_insert[I]).SETUPTIMEBEFOREMATERIAL) + DecSep;
            HostSqlStrVal := HostSqlStrVal + floattostr(pMQMPRODSCHED(List_To_Be_insert[I]).SETUPTIMEAFTERMATERIAL) + DecSep;
            HostSqlStrVal := HostSqlStrVal + floattostr(pMQMPRODSCHED(List_To_Be_insert[I]).EXECUTIONTIME) + DecSep;

            if pMQMPRODSCHED(List_To_Be_insert[I]).ChangedType = '3' then
            begin
              HostSqlStrVal := HostSqlStrVal + 'null' + DecSep;
              HostSqlStrVal := HostSqlStrVal + 'null' + DecSep;
              HostSqlStrVal := HostSqlStrVal + 'null' + DecSep;
              HostSqlStrVal := HostSqlStrVal + 'null' + DecSep;
            end
            else
            begin
              HostSqlStrVal := HostSqlStrVal + pMQMPRODSCHED(List_To_Be_insert[I]).INITIALSCHEDULEDDATE + DecSep;
              HostSqlStrVal := HostSqlStrVal + pMQMPRODSCHED(List_To_Be_insert[I]).INITIALSCHEDULEDTIME + DecSep;
              HostSqlStrVal := HostSqlStrVal + pMQMPRODSCHED(List_To_Be_insert[I]).FINALSCHEDULEDDATE + DecSep;
              HostSqlStrVal := HostSqlStrVal + pMQMPRODSCHED(List_To_Be_insert[I]).FINALSCHEDULEDTIME + DecSep;
            end;

            if Exist_Actual_Start_End then
            begin
              if pMQMPRODSCHED(List_To_Be_insert[I]).ChangedType = '3' then
              begin
                HostSqlStrVal := HostSqlStrVal + 'null' + DecSep;
                HostSqlStrVal := HostSqlStrVal + 'null' + DecSep;
                HostSqlStrVal := HostSqlStrVal + 'null' + DecSep;
                HostSqlStrVal := HostSqlStrVal + 'null' + DecSep;
              end
              else
              begin
                HostSqlStrVal := HostSqlStrVal + pMQMPRODSCHED(List_To_Be_insert[I]).INITIALSCHEDULEDACTUALDATE + DecSep;
                HostSqlStrVal := HostSqlStrVal + pMQMPRODSCHED(List_To_Be_insert[I]).INITIALSCHEDULEDACTUALTIME + DecSep;
                HostSqlStrVal := HostSqlStrVal + pMQMPRODSCHED(List_To_Be_insert[I]).FINALSCHEDULEDACTUALDATE + DecSep;
                HostSqlStrVal := HostSqlStrVal + pMQMPRODSCHED(List_To_Be_insert[I]).FINALSCHEDULEDACTUALTIME + DecSep;
              end;
            end;
            HostSqlStrVal := HostSqlStrVal + QuotedStr(pMQMPRODSCHED(List_To_Be_insert[I]).PLANNERCOMMENT) + DecSep;
            HostSqlStrVal := HostSqlStrVal + QuotedStr((pMQMPRODSCHED(List_To_Be_insert[I]).NewDemandUniqueId)) +  DecSep;
            HostSqlStrVal := HostSqlStrVal + QuotedStr(pMQMPRODSCHED(List_To_Be_insert[I]).SPLITFAMILY) +  DecSep;
            HostSqlStrVal := HostSqlStrVal + inttostr(0) +  DecSep;
            HostSqlStrVal := HostSqlStrVal + QuotedStr(pMQMPRODSCHED(List_To_Be_insert[I]).ChangedType) + DecSep + inttostr(0) + ')';

            HostSqlStrVal := SetDecSeparator(HostSqlStrVal);
            HostQry.SQL.Text := HostSqlStr + HostSqlStrVal;

            try
            //  HostQry.Connection.StartTransaction;
              HostQry.ExecSQL;
              HostQry.Connection.Commit;
            except
              on E: Exception do
              begin
                if Pos('duplicate', E.Message) > 0 then
                   continue;
                Result := false;
                sl := TStringList.Create;
                sl.Add(_('Sending') + ' Schedules - SendSchedTablesMqmAndMcm');
                sl.Add('Problem Occured In COMPANYCODE : ' + pMQMPRODSCHED(List_To_Be_insert[I]).COMPANYCODE + ' ' +
                         'COUNTERCODE : ' + pMQMPRODSCHED(List_To_Be_insert[I]).COUNTERCODE + ' ' +
                         'CODE : ' + pMQMPRODSCHED(List_To_Be_insert[I]).CODE  + ' ' +
                         'STEP NUMBER : ' + IntToStr(pMQMPRODSCHED(List_To_Be_insert[I]).STEPNUMBER) + ' ' +
                         'SUB STEP : ' + IntToStr(pMQMPRODSCHED(List_To_Be_insert[I]).SUBSTEP));
                sl.Add('DB Error : ' + E.Message);
                UpdateError(sl);
                sl.Free;
                raise;
              end;
            end;
          end;
        end;
      end;
    end;
  end;

  for I := HostSchedList.Count - 1 downto 0 do
     Dispose(PMQMPRODSCHED(HostSchedList[I]));

  for I := SrvSchedList.Count - 1 downto 0 do
     Dispose(PMQMPRODSCHED(SrvSchedList[I]));

  for I := List_To_Be_insert.Count - 1 downto 0 do
     Dispose(PMQMPRODSCHED(List_To_Be_insert[I]));

  HostSchedList.Free;
  List_To_Be_insert.Free;
  SrvSchedList.Free;

end;

//----------------------------------------------------------------------------//


function GetHostTableName(Name : string; var HostTableName : string) : boolean;
var
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
begin
  Result := false;
  HostTableName := '';
  qry := ThreadCreateQuery(Cfg_DB);
  tbInfo := @tblInfo[tbl_Archive_To_Host];

  qry.SQL.Clear;
  qry.SQL.Add('select * from ' + tbInfo.GetTableName );
  qry.SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_Tbl_Name) + ' = ''' + Name + '''');
  qry.Open;

  if not qry.EOF then
  begin
    Result := true;
    HostTableName := qry.FieldByName(CreateFld(tbInfo.pfx, fli_Tbl_Host)).AsString;
  end;

  qry.Close;
  qry.Free;
end;

//----------------------------------------------------------------------------//

function SendStockDetailsTable(srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
var
  sl     : TStringList;
  SQLText : String;
  Operation : String;
  HostNumberID, LocalNumberID : longint;
  HostUsed, LocalUsed : boolean;
  HostCounterCode, LocalCounterCode : String;
  HostCode, LocalCode : String;
  HostStepNumber, LocalStepNumber : longint;
  HostSubStep, LocalSubStep : integer;
  HostReProcess, LocalReProcess : integer;
  LocalCompanyCode, LocalRequest : String;
  HostQryUpdate: TMqmQuery;
  CompanyCode : String;

  TempString : String;
  TempInt : Integer;
  CurrentDateTimeString : String;
  HostODBC : TMqmQuery;
  tbStockDetails : ^TTblInfo;
  HostTableName : string;
begin
  tbStockDetails := @tblInfo[tbl_StockDetails];
  Result := true;
  if not GetHostTableName(tbStockDetails.GetTableName,HostTableName) then
    exit;

  HostODBC  := ThreadCreateQueryArc;

  Result        := true;
  HostNumberID  := -1;
  LocalNumberID := -1;
  LocalStepNumber := -1;
  HostStepNumber := -1;
  HostSubStep     := -1;
  LocalSubStep    := -1;
  HostReProcess   := -1;
  LocalReProcess  := -1;
  HostUsed      := false;
  LocalUsed     := false;

  SQLText := 'SELECT * FROM ITEMTYPELOGICALWAREHOUSE' +
            ' WHERE CONN_BTW_STOCK_AND_RESRV = ' + QuotedStr('1') +
            ' AND IW_1ST_COLUMN <> ' + QuotedStr('') +
            AND_IDF_Condition('IDENTIFIER');
  HostODBC.SQL.Clear;
  HostODBC.SQL.Add(SQLText);
  HostODBC.Open;
  if HostODBC.Eof then
  begin
    HostODBC.Close;
    HostODBC.Free;
    exit;
  end;
  HostODBC.Close;

  HostQryUpdate := ThreadCreateQueryHost;
  CompanyCode := IniAppGlobals.CompanyCode;
  CurrentDateTimeString := '(Current timestamp)'; // DB2
  if IniAppGlobals.DownloadFrom = '1' then CurrentDateTimeString := 'systimestamp';

  SQLText := 'select * from STOCKDETAILS ' + AND_IDF_Condition('SD_IDENTIFIER') + 'order by SD_BALANCEID';
  srvQry.SQL.Clear;
  srvQry.SQL.Add(SQLText);
  srvQry.Open;

  SQLText := '' +
   'SELECT NUMBERID, USED, COUNTERCODE, CODE, STEPNUMBER, SUBSTEP, REPROCESS ' +
   'FROM SchedulesUploadBlnConnections ' +
   'WHERE COMPANYCODE = ' + QuotedStr(CompanyCode) + '  ORDER BY NUMBERID';

  HostQry.SQL.Text := SQLText;
  HostQry.Open;

  while true do
  begin
    if srvQry.Eof and HostQry.Eof then break;

    Operation := '0';

    if HostQry.Eof then
      Operation := '1' // Insert
    else
    begin
      HostNumberID := HostQry.FieldByName('NUMBERID').AsInteger;
      TempInt := HostQry.FieldByName('USED').AsInteger;
      HostUsed := false;
      if TempInt = 1 then HostUsed := true;
      HostCounterCode := Trim(HostQry.FieldByName('COUNTERCODE').AsString);
      HostCode :=  Trim(HostQry.FieldByName('CODE').AsString);
      HostStepNumber := HostQry.FieldByName('STEPNUMBER').AsInteger;
      HostSubStep := HostQry.FieldByName('SUBSTEP').AsInteger;
      HostReProcess := HostQry.FieldByName('REPROCESS').AsInteger;
    end;

    if srvQry.Eof then
      Operation := '3' // Delete
    else
    begin
      LocalNumberID := srvQry.FieldByName('SD_BALANCEID').AsInteger;
      TempString := srvQry.FieldByName('SD_USED').AsString;
      LocalUsed := false;
      if TempString = '1' then LocalUsed := true;
      if LocalUsed then
      begin
        LocalRequest := Trim(srvQry.FieldByName('SD_PREQ_NO').AsString);
        ConvertToCopmanyCounterCode(LocalRequest,LocalCompanyCode,LocalCounterCode,LocalCode);
        LocalStepNumber := srvQry.FieldByName('SD_PSTEP_ID').AsInteger;
        LocalSubStep := srvQry.FieldByName('SD_PSUBST_ID').AsInteger;
        LocalReProcess := srvQry.FieldByName('SD_REPROC_NO').AsInteger;
      end
      else
      begin
        LocalCounterCode := '';
        LocalCode := '';
        LocalStepNumber := 0;
        LocalSubStep := 0;
        LocalReProcess := 0;
      end;

    end;

    if Operation = '0' then
    begin
      if HostNumberID > LocalNumberID then Operation := '1'; // Insert
      if HostNumberID < LocalNumberID then Operation := '3'; // Delete
      if HostNumberID = LocalNumberID then
      begin
        if (HostUsed <> LocalUsed) OR (HostCounterCode <> LocalCounterCode)
        OR (HostCode <> LocalCode) OR (HostStepNumber <> LocalStepNumber)
        OR (HostSubStep <> LocalSubStep) OR (HostReProcess <> LocalReProcess)
          then Operation := '2'; // Update
      end;
    end;

    SQLText := '';

    if (Operation = '1') and LocalUsed then
    begin
      SQLText := 'insert into SchedulesUploadBlnConnections ' + '(';
      SQLText := SQLText + '"COMPANYCODE", ';
      SQLText := SQLText + '"NUMBERID", ';
      SQLText := SQLText + '"USED", ';
      SQLText := SQLText + '"COUNTERCODE", ';
      SQLText := SQLText + '"CODE", ';
      SQLText := SQLText + '"STEPNUMBER", ';
      SQLText := SQLText + '"SUBSTEP", ';
      SQLText := SQLText + '"REPROCESS", ';
      SQLText := SQLText + '"TOBEPROCESSED", ';
      SQLText := SQLText + '"CREATIONDATETIME", ';
      SQLText := SQLText + '"CREATIONUSER"';
      SQLText := SQLText + ') values (';
      SQLText := SQLText + QuotedStr(CompanyCode) +  ', ';
      SQLText := SQLText + Inttostr(LocalNumberID) +  ', ';
      SQLText := SQLText + '1, ';
      SQLText := SQLText + QuotedStr(LocalCounterCode) +  ', ';
      SQLText := SQLText + QuotedStr(LocalCode) +  ', ';
      SQLText := SQLText + Inttostr(LocalStepNumber) +  ', ';
      SQLText := SQLText + Inttostr(LocalSubStep) +  ', ';
      SQLText := SQLText + Inttostr(LocalReProcess) +  ', ';
      SQLText := SQLText + '1, ';
      SQLText := SQLText + CurrentDateTimeString + ', ';
      SQLText := SQLText + QuotedStr('MQM') + ')';
    end;

    if Operation = '2' then
    begin
      SQLText := 'update SchedulesUploadBlnConnections set ';
      SQLText := SQLText + 'USED = ';
      if LocalUsed  then SQLText := SQLText + '1 ';
      if not LocalUsed  then SQLText := SQLText + '0 ';
      SQLText := SQLText + DecSep + ' COUNTERCODE = ' + QuotedStr(LocalCounterCode);
      SQLText := SQLText + DecSep +' CODE = ' + QuotedStr(LocalCode);
      SQLText := SQLText + DecSep +' STEPNUMBER = ' + Inttostr(LocalStepNumber);
      SQLText := SQLText + DecSep +' SUBSTEP = ' + Inttostr(LocalSubStep);
      SQLText := SQLText + DecSep +' REPROCESS = ' + Inttostr(LocalReProcess);
      SQLText := SQLText + DecSep +' TOBEPROCESSED = 1';
      SQLText := SQLText + DecSep +' LASTUPDATEDATETIME = ' + CurrentDateTimeString;
      SQLText := SQLText + DecSep +' LASTUPDATEUSER = ' + QuotedStr('MQM');
      SQLText := SQLText + ' WHERE COMPANYCODE = ' + QuotedStr(CompanyCode);
      SQLText := SQLText + '   AND NUMBERID = ' + Inttostr(LocalNumberID);
    end;

    if Operation = '3' then
    begin
      SQLText := 'delete from SchedulesUploadBlnConnections ';
      SQLText := SQLText + ' WHERE COMPANYCODE = ' + QuotedStr(CompanyCode);
      SQLText := SQLText + '   AND NUMBERID = ' + Inttostr(HostNumberID);
    end;

    if SQLText <> '' then
    begin
      HostQryUpdate.SQL.Clear;
      HostQryUpdate.SQL.Text := SQLText;
  //    HostQryUpdate.Connection.StartTransaction;
      try
        HostQryUpdate.ExecSQL;
      except
        on E: Exception do
        begin
          Result := false;
          sl := TStringList.Create;
          sl.Add(_('Sending') + ' STOCKDETAILS');
          sl.Add(SQLText);
          sl.Add(E.Message);
          UpdateError(sl);
          sl.Free;
          Exit
        end;
      end;
      HostQryUpdate.Connection.Commit;
    //  HostQryUpdate.Connection.CommitTrans;
    end;

    if Operation <> '1' then HostQry.Next;
    if Operation <> '3' then srvQry.Next;

  end;
  srvQry.Close;
  HostQryUpdate.Close;
  HostQryUpdate.free;
  HostODBC.Free;
  HostQry.Close;
end;

//----------------------------------------------------------------------------//

function CheckEmptyTableInHost(srvQry: TMqmQuery; HostQry: TMqmQuery; HIGHLEVELSCHEDULE_MQM_OR_MCM : string; Exist_HIGHLEVELSCHEDULE : boolean; var Is_SCHEDULESUPLOAD_empty : boolean) : boolean;
var
  CheckUploadSql : TStringList;
  Blocking : boolean;
begin
   Result := false;

   // (Re)build the set of overwritable keys for THIS company/environment/highlevel scope.
   if not Assigned(g_ExistingUploadKeys) then
     g_ExistingUploadKeys := TStringList.Create;
   g_ExistingUploadKeys.Clear;
   g_ExistingUploadKeys.Sorted := True;
   g_ExistingUploadKeys.Duplicates := dupIgnore;

   with HostQry do
   begin
     SQL.Clear;

     SQL.Add(' Select COMPANYCODE, COUNTERCODE, CODE, STEPNUMBER, SUBSTEP, REPROCESS, IMPORTSTATUS, CHANGETYPE from ' + 'SCHEDULESUPLOAD');
     SQL.Add(' WHERE ' + 'COMPANYCODE = ' + QuotedStr(IniAppGlobals.CompanyCode) + ' ');
     SQL.Add(' AND ' + 'ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' ');
     if Exist_HIGHLEVELSCHEDULE then
       SQL.Add(' AND ' + 'HIGHLEVELSCHEDULE = ' + QuotedStr(HIGHLEVELSCHEDULE_MQM_OR_MCM) + ' ');
     open;

     // A leftover row blocks the upload only if it has NOT been imported yet (importstatus <> 3),
     // or if it is an imported DELETE (importstatus = 3 and changetype = '3').
     // Imported non-delete rows (importstatus = 3, changetype <> '3') do NOT block - we may overwrite them.
     while not HostQry.EOF do
     begin
       Blocking := (FieldByName('IMPORTSTATUS').AsInteger <> 3) or
                   ((FieldByName('IMPORTSTATUS').AsInteger = 3) and (Trim(FieldByName('CHANGETYPE').AsString) = '3'));
       if Blocking then
       begin
         Is_SCHEDULESUPLOAD_empty := true;
         g_ExistingUploadKeys.Clear;

         CheckUploadSql := TStringList.Create;
         CheckUploadSql.add(HostQry.sql.text);
         CheckUploadSql.SaveToFile(LocAppGlobals.AppDir + '\CheckScheduleUpload.txt');
         CheckUploadSql.Free;

         Close;
         Result := false;
         Exit;
       end;

       g_ExistingUploadKeys.Add(MakeUploadKey(FieldByName('COMPANYCODE').AsString,
                                              FieldByName('COUNTERCODE').AsString,
                                              FieldByName('CODE').AsString,
                                              FieldByName('STEPNUMBER').AsInteger,
                                              FieldByName('SUBSTEP').AsInteger,
                                              FieldByName('REPROCESS').AsInteger));
       Next;
     end;

     Close;
     // No blocking rows -> proceed. g_ExistingUploadKeys now holds the keys we may overwrite.
     Result := true;
   end;
end;

//----------------------------------------------------------------------------//

procedure CheckTableColumns(srvQry: TMqmQuery; HostQry: TMqmQuery;
                                           var Exist_HIGHLEVELSCHEDULE : boolean;
                                           var Exit_COUNTERCOMPANYCODE : boolean;
                                           var Exist_Actual_Start_End  : boolean);
var
  ArcQry : TMqmQuery;
  LocalTableName : string;
  LocalHostName : TDndArchiveName;
begin
  LocalHostName := GetDndArchiveLocalName;
  LocalTableName := 'NOW_TABLES_COLUMNS';
  if LocalHostName <> TD_Interbase then
    LocalTableName  := 'SCDA_' + 'NOW_TABLES_COLUMNS';

   ArcQry  := ThreadCreateQueryArc;
   with Arcqry do
   begin
     SQL.Clear;
     SQL.Add(' Select COLUMN_NAME from ' + LocalTableName + ' WHERE COLUMN_NAME = ' + QuotedStr('HIGHLEVELSCHEDULE'));
     SQL.Add(' AND TABLE_NAME = ' + QuotedStr('SCHEDULESUPLOAD'));
     open;
     if not ArcQry.EOF then
       Exist_HIGHLEVELSCHEDULE := true;
     SQL.Clear;
     SQL.Add(' Select COLUMN_NAME from ' + LocalTableName + ' WHERE COLUMN_NAME = ' + QuotedStr('COUNTERCOMPANYCODE'));
     SQL.Add(' AND TABLE_NAME = ' + QuotedStr('SCHEDULESUPLOAD'));
     open;
     if not ArcQry.EOF then
       Exit_COUNTERCOMPANYCODE := true;

     SQL.Clear;
     SQL.Add(' Select COLUMN_NAME from ' + LocalTableName + ' WHERE COLUMN_NAME = ' + QuotedStr('INITIALSCHEDULEDACTUALDATE'));
     SQL.Add(' AND TABLE_NAME = ' + QuotedStr('SCHEDULESUPLOAD'));
     open;
     if not ArcQry.EOF then
       Exist_Actual_Start_End := true;
     Close;
   end;
end;

//----------------------------------------------------------------------------//

function SendProdSched_MQM_TO_NOW(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery ; var Is_SCHEDULESUPLOAD_empty : boolean; var MQM_OR_MCM_ENVIRONMENT : string): boolean;
const
  fldList: array [0..40] of TQryLinkRec = (
    (fldPC: fli_preqNo;                   fldAS: 'COMPANYCODE'; fldType: TLD_string),
    (fldPC: fli_pstepId;                  fldAS: 'COUNTERCODE'; fldType: TLD_integer),
    (fldPC: fli_psubstId;                 fldAS: 'CODE'; fldType: TLD_integer),
    (fldPC: fli_reprocNo;                 fldAS: 'STEPNUMBER'; fldType: TLD_integer),
    (fldPC: fli_ProdType;                 fldAS: 'SUBSTEP'; fldType: TLD_string),
    (fldPC: fli_ProdLine;                 fldAS: 'REPROCESS'; fldType: TLD_string),
    (fldPC: fli_ProdUMCode;               fldAS: 'TPRDUM'; fldType: TLD_string),
    (fldPC: fli_StepType;                 fldAS: 'TSTPTP'; fldType: TLD_string),
    (fldPC: fli_stGroup;                  fldAS: 'TSTPGR'; fldType: TLD_integer),
    (fldPC: fli_StepIsGrouped;            fldAS: 'TFLGRP'; fldType: TLD_string),
    (fldPC: fli_schedType;                fldAS: 'TSCHTP'; fldType: TLD_string),
    (fldPC: fli_wkCtrCode;                fldAS: 'TCDMAC'; fldType: TLD_string),
    (fldPC: fli_wkcProc;                  fldAS: 'TCDMAP'; fldType: TLD_string),
    (fldPC: fli_AlternativCode;           fldAS: 'TALTCD'; fldType: TLD_string),
    (fldPC: fli_rsc;                      fldAS: 'TPRRSC'; fldType: TLD_string),
    (fldPC: fli_subLinRscId;              fldAS: 'TRSCSL'; fldType: TLD_integer),
    (fldPC: fli_NumSubRscComponents;      fldAS: 'TNRRSC'; fldType: TLD_integer),
    (fldPC: fli_quant;                    fldAS: 'TSCHQT'; fldType: TLD_float),
    (fldPC: fli_supMinReal;               fldAS: 'TSETTM'; fldType: TLD_float),
    (fldPC: fli_supMinBase;               fldAS: 'TSAVST'; fldType: TLD_float),
    (fldPC: fli_supMinOvlp;               fldAS: 'TSAVST'; fldType: TLD_float),
    (fldPC: fli_exeMin;                   fldAS: 'TEXCTM'; fldType: TLD_float),
    (fldPC: fli_schedStart;               fldAS: 'TSTSDT'; fldType: TLD_DateTime),
    (fldPC: fli_schedEnd;                 fldAS: 'TENSDT'; fldType: TLD_DateTime),
    (fldPC: fli_ActualStart;              fldAS: '';       fldType: TLD_DateTime),
    (fldPC: fli_ActualEnd;                fldAS: '';       fldType: TLD_DateTime),
    (fldPC: fli_Comment;                  fldAS: 'TCOMMN'; fldType: TLD_string),
    (fldPC: fli_ConnForwardSubStep;       fldAS: 'TFWSST'; fldType: TLD_integer),
    (fldPC: fli_ConnForwardReProcess;     fldAS: 'TFWRNB'; fldType: TLD_integer),
    (fldPC: fli_ConnBackwardSubStep;      fldAS: 'TBCSST'; fldType: TLD_integer),
    (fldPC: fli_ConnBackwardReProcess;    fldAS: 'TBCRNB'; fldType: TLD_integer),
    (fldPC: fli_SaveAtLeastOnesAsFinnal;  fldAS: 'TSVFIN'; fldType: TLD_string),
    (fldPC: fli_MachSetupCode;            fldAS: 'TSETCD'; fldType: TLD_string),
    (fldPC: fli_NettedQuantity;           fldAS: 'TNETQT'; fldType: TLD_float),
    (fldPC: fli_ChangedQuantity;          fldAS: 'TCHGQT'; fldType: TLD_float),
    (fldPC: fli_usrCg;                    fldAS: 'TUSRCR'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;                  fldAS: 'TDTOCR'; fldType: TLD_DateTime),
    (fldPC: fli_usrCg;                    fldAS: 'TUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;                  fldAS: 'TDTOCH'; fldType: TLD_DateTime),
    (fldPC: fli_NewPreqUniqId;            fldAS: ''      ; fldType: TLD_string),
    (fldPC: fli_SplitFamaly;              fldAS: ''      ; fldType: TLD_string)
  );

var
  sl: TStringList;
  tbInfo: ^TTblInfo;
  Exist_HIGHLEVELSCHEDULE, Exit_COUNTERCOMPANYCODE : boolean;
  Exist_Actual_Start_End : boolean;
begin
  Exist_HIGHLEVELSCHEDULE := false;
  Exit_COUNTERCOMPANYCODE := false;
  Exist_Actual_Start_End := false;
  Result := true;
  tbInfo := @tblInfo[tbl];
  SetFldPfx(tbInfo.pfx);
  DownloadCompanyHandling(srvQry,HostQry);

  CheckTableColumns(srvQry, HostQry, Exist_HIGHLEVELSCHEDULE, Exit_COUNTERCOMPANYCODE, Exist_Actual_Start_End);
//  try
   if CheckEmptyTableInHost(srvQry, HostQry, '0', Exist_HIGHLEVELSCHEDULE, Is_SCHEDULESUPLOAD_empty) then
   begin
     Result := SendSchedTablesMqmAndMcm(tbl, AS400Speclib, ' where ' + CreateFld(tbInfo.pfx, fli_schedType) + ' <> ''0''', fldList, srvQry, HostQry, '0', Exist_HIGHLEVELSCHEDULE, Exit_COUNTERCOMPANYCODE, Exist_Actual_Start_End);
     if Result then
     begin
       try
         Result := SendStockDetailsTable(srvQry, HostQry)
       except
        on E: Exception do
        begin
          sl := TStringList.Create;
          sl.Add(_('Error while sending') + ' STOCKDETAILS');
          sl.Add('DB Error : ' + E.Message);
          UpdateError(sl);
          sl.Free;
        end;
       end;
     end;
   end
   else
   begin
     Result := false;
   end;

{   except
    on E: Exception do
      begin
        sl := TStringList.Create;
        sl.Add(_('Sending') + ' Schedules - SendSchedTablesMqmAndMcm');
        sl.Add(E.Message);
        UpdateError(sl);
        sl.Free;
        raise;
      end    }
//  end;

end;

//----------------------------------------------------------------------------//

function SendProdSched_MCM_TO_NOW(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery ; var Is_SCHEDULESUPLOAD_empty : boolean; var MQM_OR_MCM_ENVIRONMENT : string): boolean;
const
  fldList: array [0..41] of TQryLinkRec = (
    (fldPC: fli_preqNo;                   fldAS: 'COMPANYCODE'; fldType: TLD_string),
    (fldPC: fli_pstepId;                  fldAS: 'COUNTERCODE'; fldType: TLD_integer),
    (fldPC: fli_psubstId;                 fldAS: 'CODE'; fldType: TLD_integer),
    (fldPC: fli_reprocNo;                 fldAS: 'STEPNUMBER'; fldType: TLD_integer),
    (fldPC: fli_ProdType;                 fldAS: 'SUBSTEP'; fldType: TLD_string),
    (fldPC: fli_ProdLine;                 fldAS: 'REPROCESS'; fldType: TLD_string),
    (fldPC: fli_ProdUMCode;               fldAS: 'TPRDUM'; fldType: TLD_string),
    (fldPC: fli_StepType;                 fldAS: 'TSTPTP'; fldType: TLD_string),
    (fldPC: fli_stGroup;                  fldAS: 'TSTPGR'; fldType: TLD_integer),
    (fldPC: fli_StepIsGrouped;            fldAS: 'TFLGRP'; fldType: TLD_string),
    (fldPC: fli_schedType;                fldAS: 'TSCHTP'; fldType: TLD_string),
    (fldPC: fli_wkCtrCode;                fldAS: 'TCDMAC'; fldType: TLD_string),
    (fldPC: fli_wkcProc;                  fldAS: 'TCDMAP'; fldType: TLD_string),
    (fldPC: fli_AlternativCode;           fldAS: 'TALTCD'; fldType: TLD_string),
    (fldPC: fli_rsc;                      fldAS: 'TPRRSC'; fldType: TLD_string),
    (fldPC: fli_subLinRscId;              fldAS: 'TRSCSL'; fldType: TLD_integer),
    (fldPC: fli_NumSubRscComponents;      fldAS: 'TNRRSC'; fldType: TLD_integer),
    (fldPC: fli_quant;                    fldAS: 'TSCHQT'; fldType: TLD_float),
    (fldPC: fli_supMinBase;               fldAS: 'TSETTM'; fldType: TLD_float),
    (fldPC: fli_supMinReal;               fldAS: 'TSAVST'; fldType: TLD_float),
    (fldPC: fli_supMinOvlp;               fldAS: 'TSAVST'; fldType: TLD_float),
    (fldPC: fli_exeMin;                   fldAS: 'TEXCTM'; fldType: TLD_float),
    (fldPC: fli_schedStart;               fldAS: 'TSTSDT'; fldType: TLD_DateTime),
    (fldPC: fli_schedEnd;                 fldAS: 'TENSDT'; fldType: TLD_DateTime),
    (fldPC: fli_ActualStart;              fldAS: '';       fldType: TLD_DateTime),
    (fldPC: fli_ActualEnd;                fldAS: '';       fldType: TLD_DateTime),
    (fldPC: fli_Comment;                  fldAS: 'TCOMMN'; fldType: TLD_string),
    (fldPC: fli_ConnForwardSubStep;       fldAS: 'TFWSST'; fldType: TLD_integer),
    (fldPC: fli_ConnForwardReProcess;     fldAS: 'TFWRNB'; fldType: TLD_integer),
    (fldPC: fli_ConnBackwardSubStep;      fldAS: 'TBCSST'; fldType: TLD_integer),
    (fldPC: fli_ConnBackwardReProcess;    fldAS: 'TBCRNB'; fldType: TLD_integer),
    (fldPC: fli_SaveAtLeastOnesAsFinnal;  fldAS: 'TSVFIN'; fldType: TLD_string),
    (fldPC: fli_MachSetupCode;            fldAS: 'TSETCD'; fldType: TLD_string),
    (fldPC: fli_NettedQuantity;           fldAS: 'TNETQT'; fldType: TLD_float),
    (fldPC: fli_ChangedQuantity;          fldAS: 'TCHGQT'; fldType: TLD_float),
    (fldPC: fli_usrCg;                    fldAS: 'TUSRCR'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;                  fldAS: 'TDTOCR'; fldType: TLD_DateTime),
    (fldPC: fli_usrCg;                    fldAS: 'TUSRCH'; fldType: TLD_string),
    (fldPC: fli_usrTmCg;                  fldAS: 'TDTOCH'; fldType: TLD_DateTime),
    (fldPC: fli_NewPreqUniqId;            fldAS: ''      ; fldType: TLD_string),
    (fldPC: fli_SplitFamaly;              fldAS: ''      ; fldType: TLD_string),
    (fldPC: fli_Mqm_environment;          fldAS: ''      ; fldType: TLD_string)
  );

var
  sl: TStringList;
  tbInfo: ^TTblInfo;
  Exist_HIGHLEVELSCHEDULE, Exit_COUNTERCOMPANYCODE : boolean;
  Exist_Actual_Start_End : boolean;
begin
  Exist_HIGHLEVELSCHEDULE := false;
  Exit_COUNTERCOMPANYCODE := false;
  Exist_Actual_Start_End  := false;
  Result := true;
  tbInfo := @tblInfo[tbl];
  SetFldPfx(tbInfo.pfx);
  DownloadCompanyHandling(srvQry,HostQry);
  CheckTableColumns(srvQry, HostQry, Exist_HIGHLEVELSCHEDULE, Exit_COUNTERCOMPANYCODE, Exist_Actual_Start_End);

//  try
   if CheckEmptyTableInHost(srvQry, HostQry, '1', Exist_HIGHLEVELSCHEDULE, Is_SCHEDULESUPLOAD_empty) then
     Result := SendSchedTablesMqmAndMcm(tbl, AS400Speclib, ' where ' + CreateFld(tbInfo.pfx, fli_schedType) + ' <> ''0''', fldList, srvQry, HostQry, '1', Exist_HIGHLEVELSCHEDULE, Exit_COUNTERCOMPANYCODE, Exist_Actual_Start_End)
   else
   begin
     Result := false;
     //MQM_OR_MCM_ENVIRONMENT := 'MCM';
   end;

{   except
    on E: Exception do
      begin
        sl := TStringList.Create;
        sl.Add(_('Sending') + ' Schedules - SendSchedTablesMqmAndMcm');
        sl.Add(E.Message);
        UpdateError(sl);
        sl.Free;
        raise;
      end
  end  }

end;

//----------------------------------------------------------------------------//

function SendMaterialSchedule_TO_NOW(tbl: table; srvQry: TMqmQuery; HostQry: TMqmQuery): boolean;
const
  fldList: array [0..15] of TQryLinkRec = (
    (fldPC: fli_ProdType;                fldAS: 'ITEMTYPECODE'; fldType: TLD_string),
  //  (fldPC: fli_ProdCode;                fldAS: '' ; fldType: TLD_string),
    (fldPC: fli_preqNo;                  fldAS: ''        ; fldType: TLD_string),
    (fldPC: fli_Sub_Detail;              fldAS: ''  ; fldType: TLD_string),
    (fldPC: fli_Detail_Code;             fldAS: ''     ; fldType: TLD_string),
    (fldPC: fli_quant;                   fldAS: 'QUANTITY'   ; fldType: TLD_float),
   // (fldPC: fli_netGroupCode;            fldAS: ''; fldType: TLD_string),
    (fldPC: fli_rsc;                     fldAS: 'SCHEDULEDRESOURCECODE'; fldType: TLD_string),
    (fldPC: fli_OverridenSpeed;          fldAS: 'OVERRIDENSPEED'; fldType: TLD_float),
    (fldPC: fli_OverridenSetupTime;      fldAS: 'OVERRIDENSETUPTIME';  fldType: TLD_float),
    (fldPC: fli_schedStart;              fldAS: 'INITIALSCHEDULEDDATE'; fldType: TLD_dateTime),
    (fldPC: fli_schedEnd;                fldAS: 'FINALSCHEDULEDDATE'; fldType: TLD_dateTime),
    (fldPC: fli_FirstJobQuantityIncluded;fldAS: 'FIRSTJOBQUANTITYINCLUDED'; fldType: TLD_float),
    (fldPC: fli_LastJobQuantityIncluded; fldAS: 'LASTJOBQUANTITYINCLUDED'; fldType: TLD_float),
    (fldPC: fli_HostItemIndentifier;     fldAS: 'FIKDIDENTIFIER'; fldType: TLD_float),
    (fldPC: fli_HostWarehouse;           fldAS: 'LOGICALWAREHOUSECODE'; fldType: TLD_string),
    (fldPC: fli_SubDetailHostType;       fldAS: ''; fldType: TLD_string),
    (fldPC: fli_DetailCodeType;          fldAS: ''; fldType: TLD_string)
  );

var
  tbInfo: ^TTblInfo;
begin
  Result := true;
  tbInfo := @tblInfo[tbl];
  SetFldPfx(tbInfo.pfx);
//  DownloadCompanyHandling(srvQry,HostQry);

  //CheckTableColumns(srvQry, HostQry, Exist_HIGHLEVELSCHEDULE, Exit_COUNTERCOMPANYCODE, Exist_Actual_Start_End);
//  try
  Result := SendWarpSchedTableMqm(tbl, AS400Speclib, '',
                      fldList, srvQry, HostQry);

end;

//----------------------------------------------------------------------------//

function DownloadCompanyHandling(srvQry : TMqmQuery; HostQry: TMqmQuery): boolean;
var

  hostSqlStr : string;
  ReqPABSCOMPANYHANDLING : PABSCOMPANYHANDLING;
begin
  Result := true;
  M_ABSCOMPANYHANDLING := TList.Create;
  UpdateOperation(_('Downloading data for ABSCOMPANYHANDLING'));
  hostSqlStr := 'SELECT * FROM ABSCOMPANYHANDLING';

  HostQry.SQL.Text := hostSqlStr;
  hostQry.Active:=true;

  while ( not hostQry.Eof) do
  begin
    new(ReqPABSCOMPANYHANDLING);
    ReqPABSCOMPANYHANDLING.ENTITYNAME := UpperCase(Trim(HostQry.FieldByName('ENTITYNAME').AsString));
    ReqPABSCOMPANYHANDLING.COMPANYLEVELHANDLING := Trim(HostQry.FieldByName('COMPANYLEVELHANDLING').AsString);
    M_ABSCOMPANYHANDLING.Add(ReqPABSCOMPANYHANDLING);
    hostQry.Next;
  end;

  hostQry.close;

  IniAppGlobals.GroupCode := '';
  hostSqlStr := 'SELECT GROUPCODE FROM ABSCOMPANY where CODE = ' + QuotedStr(IniAppGlobals.CompanyCode);
  HostQry.SQL.Text := hostSqlStr;
  hostQry.Active:=true;
  if not hostQry.Eof then
    IniAppGlobals.GroupCode := Trim(HostQry.FieldByName('GROUPCODE').AsString);
  hostQry.close;

end;

//----------------------------------------------------------------------------//

procedure FreeCompanyLevelHandlingByEntity;
var
  I : Integer;
begin
  if assigned(M_ABSCOMPANYHANDLING) then
  begin
    for I := 0 to M_ABSCOMPANYHANDLING.Count - 1 do
      dispose(PABSCOMPANYHANDLING(M_ABSCOMPANYHANDLING[I]));
    M_ABSCOMPANYHANDLING.Free;
  end;
end;

//----------------------------------------------------------------------------//

initialization
  M_ResourceWorkCnterList := TList.Create;
finalization
  CleanResourceWorkCnterList(true);
  FreeCompanyLevelHandlingByEntity;
  if Assigned(g_ExistingUploadKeys) then
    g_ExistingUploadKeys.Free;

end.
