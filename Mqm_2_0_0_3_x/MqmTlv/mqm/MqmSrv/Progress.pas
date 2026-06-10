unit Progress;

interface

uses Classes, DMsrvPc;


procedure CreateProgressTable(HostQry : TMqmQuery);
procedure DeleteAllNotRelevantProgresses(HostQry : TMqmQuery;
                                        WcHandledStr, DemandTemplatesStr_HandledAlways, DemandTemplatesStr_HandledOnlyGroup : string);
procedure DeleteAllNotRelevantProgresses2(HostQry : TMqmQuery; WcHandledStr : string);
function  BuildHandledProductionProgressTemplatesList(srvQryFD : TMqmQuery) : boolean;
procedure AddToSchedulesDownloadProgress(ArcQry : TMqmQuery; HostQry : TMqmQuery; DemandTemplatesStr_HandledAlways, DemandTemplatesStr_HandledOnlyGroup : string);
function  BuildProdSchedProgress(NeedToMakeMerge : boolean; handledWorkCentersSql : string; productionDemandCounters : TList; IsBackgroundThread: boolean = false) : TList;


implementation

uses  gnugettext, UMCommon, Data.DB, UMsrvLoad, UMSrvConfig, UOPThread, UMConvert, UMProductionStructService, UMglobal, SysUtils, ADODB,
      FireDAC.Comp.Client, FireDAC.Comp.DataSet, Forms, UMProductionStruct, UMProdMemory, UMTblDesc;

type

  TPROGRESS_NOW = Record
    PROGRESS_NUMBER : string;
    PROGRESS_TAMPLATECODE : string;
    DEMAND_COUNTER_CODE : string;
    DEMAND_CODE : string;
    DEMAND_STEP : Integer;
    DEMAND_TEMPLATE_CODE : string;
    PRODUCTION_ORDER_CODE : string;
    ORIG_END_DATE   : TDateTime;
    START_DATE_TIME : TDateTime;
    END_DATE_TIME   : TDateTime;
    RESOURCE_CODE	  : string;
    PRIMARY_QTY     : double;
    PRIMARY_UM_CODE : string;
    SECONDARY_QTY   : double;
    SECONDARY_UM_CODE : string;
    PACKAGING_QTY   : double;
    PACKAGING_UM_CODE : string;
    InitialBasePrimaryQuantity : double;
    FINAL_TO_INITIAL_DIVIDER : double;
    CLOSED_STEP : string;
    BASE_PRIMARY_UM_CODE : string;
    MULT_TO_BASE_PRIMARY_UMCODE : double;
    PROGRESS_PERCENT : double;
  end;
  PTPROGRESS_NOW = ^TPROGRESS_NOW;

  TPROD_SCHE_GRP = Record
    Request : string;
    step    : integer;
    GroupListStr : TStringList;
  end;
  PTPROD_SCHE_GRP = ^TPROD_SCHE_GRP;

var

  m_TemplateHandledProgress : string;
  m_TemplateFINALANDSPLIT, m_TemplateQUANTITYTYPE : TStringList;

//------------------------------------------------------------------------------------------------//

function SortProgress(Item1: Pointer; Item2: Pointer): Integer;
var
  MQMSP1 : PTPROGRESSES;
  MQMSP2 : PTPROGRESSES;
begin
  MQMSP1 := PTPROGRESSES(Item1);
  MQMSP2 := PTPROGRESSES(Item2);

  if MQMSP1.Request < MQMSP2.Request then
     Result := -1
  else if (MQMSP1.Request = MQMSP2.Request) then
  begin
    if (MQMSP1.Step < MQMSP2.Step) then
       Result := -1
    else if (MQMSP1.Step = MQMSP2.Step) then
    begin
      if (MQMSP1.Resource < MQMSP2.Resource) then
        Result := -1
      else if (MQMSP1.Resource = MQMSP2.Resource) then
      begin
        if (MQMSP1.ProgressStart < MQMSP2.ProgressStart) then
          Result := -1
        else if (MQMSP1.ProgressStart > MQMSP2.ProgressStart) then
          Result := 1
        else
          Result := 0;
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

//------------------------------------------------------------------------------------------------//

procedure LoadProdSchedGroups(var GrpProdSchedList : TList);
var
  SrvSqlStr : string;
  tbProdSched: ^TTblInfo;
  srvQry  : TMqmQuery;
  PROD_SCHE_GRP : PTPROD_SCHE_GRP;
  req, PrevReq : string;
  PrevStep : integer;
  fldPreqNo, fldPstepId, fldStGroup : TField;
begin
  tbProdSched := @tblInfo[tbl_prod_sched];
  srvQry := CreateQuery(Main_DB);

  srvSqlStr := 'SELECT ' +
                CreateFld(tbProdSched.pfx, fli_preqNo) + ',' +
                CreateFld(tbProdSched.pfx, fli_pstepId) + ',' +
                CreateFld(tbProdSched.pfx, fli_stGroup) + ' ' +
               'FROM ' + tbProdSched.GetTableName +
               ' WHERE ' + CreateFld(tbProdSched.pfx, fli_stGroup) + '>' + IntToStr(0) + AND_IDF_Condition(CreateFld(tbProdSched.pfx, fli_IDENTIFIER)) +
               ' Order by ' + CreateFld(tbProdSched.pfx, fli_preqNo) + ',' +
                CreateFld(tbProdSched.pfx, fli_pstepId) + ',' +
                CreateFld(tbProdSched.pfx, fli_psubstId);

  srvQry.SQL.Text := srvSqlStr;
  srvQry.Active := true;
  fldPreqNo  := srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_preqNo));
  fldPstepId := srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_pstepId));
  fldStGroup := srvQry.FieldByName(CreateFld(tbProdSched.pfx, fli_stGroup));

  while not srvQry.Eof do
  begin
    PrevReq := Trim(fldPreqNo.AsString);
    PrevStep := fldPstepId.AsInteger;

    new(PROD_SCHE_GRP);
    PROD_SCHE_GRP.Request := Trim(fldPreqNo.AsString);
    PROD_SCHE_GRP.Step := fldPstepId.AsInteger;
    PROD_SCHE_GRP.GroupListStr := TStringList.create;
    GrpProdSchedList.Add(PROD_SCHE_GRP);
    while (not srvQry.Eof) and (Trim(fldPreqNo.AsString) = PrevReq) and
          (fldPstepId.AsInteger = PrevStep) do
    begin
      PROD_SCHE_GRP.GroupListStr.Add(IntToStr(fldStGroup.AsInteger));
      PrevReq := Trim(fldPreqNo.AsString);
      PrevStep := fldPstepId.AsInteger;
      srvQry.Next;
    end;

  end;

  srvQry.Free;
end;

//------------------------------------------------------------------------------------------------//

function GetGroupListForRequestStep(Request : string; Step : Integer; GrpProdSchedList : TList) : TStringList;
var
  i: integer;
  Multiplier, NumberOfEntries, NumberOfEntriesMinusOne : integer;
begin
  Result := nil;

  NumberOfEntries := GrpProdSchedList.Count;
  if NumberOfEntries = 0 then exit;
  NumberOfEntriesMinusOne := NumberOfEntries - 1;

  Multiplier := 1;
  while Multiplier < NumberOfEntries do Multiplier := Multiplier * 2;
    i := Multiplier - 1;

  while (Multiplier > 0) do
  begin
    Multiplier := trunc(Multiplier / 2);

    if (i > NumberOfEntriesMinusOne)
    or ((PTPROD_SCHE_GRP(GrpProdSchedList[i]).Request > Request)) then
    begin
      i := i - Multiplier;
      Continue;
    end;

    if  (PTPROD_SCHE_GRP(GrpProdSchedList[i]).Request < Request) then
    begin
      i := i + Multiplier;
      Continue;
    end;

    if  (PTPROD_SCHE_GRP(GrpProdSchedList[i]).Step < Step) then
    begin
      i := i + Multiplier;
      Continue;
    end;

    if  (PTPROD_SCHE_GRP(GrpProdSchedList[i]).Step > Step) then
    begin
      i := i - Multiplier;
      Continue;
  end;

  Result := PTPROD_SCHE_GRP(GrpProdSchedList[i]).GroupListStr;
  Break;

  end;

end;

//------------------------------------------------------------------------------------------------//

function CheckSameGroup(GrpStringList1, GrpStringList2 : TStringList) : boolean;
var
  I, J : Integer;
  Grp : string;
begin
  result := false;
  for I := 0 to GrpStringList1.Count -1 do
  begin
    Grp := GrpStringList1.strings[I];
    for J := 0 to GrpStringList2.Count - 1 do
    begin
      if Grp = GrpStringList2.Strings[J] then
      begin
        Result := true;
        Exit
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------------------------//

function Prepare_Prod_Sched_Progress(HostQry, ArcQry : TMqmQuery; NeedToMakeMerge : boolean; handledWorkCentersSql : string; productionDemandCounters : TList; GrpProdSchedList : Tlist) : Tlist;
var
  DndArchiveArcName : TDndArchiveName;
  ProgressPerResource : TList;
  ProgressList        : TList;
  PrevResource, srvSqlStr, tblName, tblName01 : string;
  ResListHavingSubRes, SqlPrint : TStringList;
  Divider : double;
//  srvQryFD, QryFDDel, srvQryFDInsert, srvQryFDUpdate : TMqmQuery;
//  srvTrs, srvQryTrs : TMqmIBTransaction;
  DemandNewCode, CompanyInUsed, Company, CounterCode, PREQ_NO,
  tblProg_Name, tblProg_ProductionDemandTemplate, tblProg_PRODUCTIONPROGRESSTEMPLATE, Tblprog_PRODUCTIONDEMANDCOUNTER : string;
  ProgressedQuantity  : double;
  PROGRESSESRec, NewROGRESSESRec  : PTPROGRESSES;
  D,I,S, IndexProgress               : Integer;
  ProgEndDate                    : TDateTime;
  GrpListStr1, GrpListStr2 : TStringList;
  SameGroup : boolean;
  Temp, FINAL_TO_INITIAL_DIVIDER, PROGRESS_PERCENT : double;
  MidNight : String;
  MachineCode_FIELD,CounterCode_FIELD,Code_FIELD, DemandProgPrimaryQty_FIELD, InitialBasePrimaryQuantity_FIELD,
  FinalBasePrimaryQuantity_FIELD, ProgressTemplateCode_FIELD, ProgressNumber_FIELD, StepNumber_FIELD,
  ProductionOrderCode_FIELD, StartDate_FIELD, StartTime_FIELD, EndDate_FIELD, EndTime_FIELD,
  ClosedStep_FIELD,
  ArcQry_Cnt_FIELD, ArcQry_RscCode_FIELD : TField;

  procedure ResourceEndCalc;
  var
    I, J : Integer;
    SubResourceType : boolean;
  begin
    SubResourceType := false;
    if ResListHavingSubRes.IndexOf(trim(PrevResource)) <> -1 then
       SubResourceType := true;

    for I := 0 to ProgressPerResource.Count - 1 do
    Begin
      if PTPROGRESSES(ProgressPerResource[I]).Deleted then
        continue;

      for J := I + 1 to ProgressPerResource.Count - 1 do
	    begin
	      if PTPROGRESSES(ProgressPerResource[J]).Deleted then continue;

        // WHEN MACHINE IS TYPE OF SUBRESOURCE WE DO NOT HANDLE A SPLIT OF JOB - IF PO CHANGE AND PO APPEARS AGAIN - WE DO NOT SPLIT THE DEMANDS
        if (not SubResourceType) and ((PTPROGRESSES(ProgressPerResource[I]).ProductionOrderCode <> PTPROGRESSES(ProgressPerResource[J]).ProductionOrderCode)) then
        begin
          SameGroup := false;
          GrpListStr1 := GetGroupListForRequestStep(Trim(PTPROGRESSES(ProgressPerResource[I]).Request), PTPROGRESSES(ProgressPerResource[I]).Step, GrpProdSchedList);
          GrpListStr2 := GetGroupListForRequestStep(Trim(PTPROGRESSES(ProgressPerResource[J]).Request), PTPROGRESSES(ProgressPerResource[J]).Step, GrpProdSchedList);
          if Assigned(GrpListStr1) and Assigned(GrpListStr2) then
            SameGroup := CheckSameGroup(GrpListStr1, GrpListStr2);
          if not SameGroup then // qtt
          begin
  			    if PTPROGRESSES(ProgressPerResource[I]).ProgressType = '1' then
               PTPROGRESSES(ProgressPerResource[I]).Deleted := true;
            break;
   		    end;
        end;

		    if (PTPROGRESSES(ProgressPerResource[J]).DemandCounterCode = PTPROGRESSES(ProgressPerResource[I]).DemandCounterCode) and
		       (PTPROGRESSES(ProgressPerResource[J]).DemandCode = PTPROGRESSES(ProgressPerResource[I]).DemandCode) and
	       	 (PTPROGRESSES(ProgressPerResource[J]).Step = PTPROGRESSES(ProgressPerResource[I]).Step) then
	    	begin
  		    if PTPROGRESSES(ProgressPerResource[I]).ProgressCurrent < PTPROGRESSES(ProgressPerResource[J]).ProgressCurrent then
			     	PTPROGRESSES(ProgressPerResource[I]).ProgressCurrent := PTPROGRESSES(ProgressPerResource[J]).ProgressCurrent;
			    PTPROGRESSES(ProgressPerResource[I]).Qty := PTPROGRESSES(ProgressPerResource[I]).Qty + PTPROGRESSES(ProgressPerResource[J]).Qty;
			    if (PTPROGRESSES(ProgressPerResource[I]).ProgressType = '1') and (PTPROGRESSES(ProgressPerResource[I]).Qty > 0) then
             PTPROGRESSES(ProgressPerResource[I]).ProgressType := '2';
			    if (PTPROGRESSES(ProgressPerResource[I]).ProgressType = '1') and (PTPROGRESSES(ProgressPerResource[I]).ProgressCurrent > PTPROGRESSES(ProgressPerResource[I]).ProgressStart) then
             PTPROGRESSES(ProgressPerResource[I]).ProgressType := '2';
           if PTPROGRESSES(ProgressPerResource[J]).Is_finalAndSplit then
             PTPROGRESSES(ProgressPerResource[I]).Is_finalAndSplit := true;
 			    PTPROGRESSES(ProgressPerResource[J]).Deleted := true;
		    end;
      end;
    end;

    for I := 0 to ProgressPerResource.Count - 1 do
    begin
      if PTPROGRESSES(ProgressPerResource[I]).Deleted then continue;
      new(NewROGRESSESRec);
      NewROGRESSESRec.Request       := PTPROGRESSES(ProgressPerResource[I]).Request;
      NewROGRESSESRec.Step          := PTPROGRESSES(ProgressPerResource[I]).Step;
      NewROGRESSESRec.Resource      := PTPROGRESSES(ProgressPerResource[I]).Resource;
      NewROGRESSESRec.ProgressType  := PTPROGRESSES(ProgressPerResource[I]).ProgressType;
      NewROGRESSESRec.ProgressStart := PTPROGRESSES(ProgressPerResource[I]).ProgressStart;
      NewROGRESSESRec.ProgressCurrent := PTPROGRESSES(ProgressPerResource[I]).ProgressCurrent;
      NewROGRESSESRec.Qty := PTPROGRESSES(ProgressPerResource[I]).Qty;
      NewROGRESSESRec.StartingQty := PTPROGRESSES(ProgressPerResource[I]).StartingQty;
      NewROGRESSESRec.Is_finalAndSplit := PTPROGRESSES(ProgressPerResource[I]).Is_finalAndSplit;
      ProgressList.Add(NewROGRESSESRec);
    end;
  end;

begin

  Result := TList.Create;
  MidNight := '00:00:00';
  SqlPrint := TStringList.Create;
  if not GetCompanyLevelHandlingByEntityName('PRODUCTIONPROGRESS',  CompanyInUsed) then
     CompanyInUsed := IniAppGlobals.CompanyCode;

  ProgressPerResource := TList.Create;
  ProgressList        := TList.Create;
  PrevResource        := '';
  if handledWorkCentersSql = '' then
     Exit;

  if Trim(m_TemplateHandledProgress) = '' then
     Exit;

  ResListHavingSubRes  := TStringList.Create;
  DndArchiveArcName    := GetDndArchiveLocalName;
  if DndArchiveArcName = TD_Interbase then
  begin
    tblName := 'RES';
    tblName01 := 'RES_SUB'
  end
  else
  begin
    tblName  := 'SCDA_' + 'RES';
    tblName01 := 'SCDA_RES_SUB'
  end;

{  srvSqlStr  := 'SELECT RS_RSC_CODE '+
               'FROM ' + tblName +
               ' WHERE RS_NUM_RSC_COMP > 1 ' + AND_IDF_Condition('RS_IDENTIFIER');   }

  srvSqlStr  := 'select rs_rsc_code, count(*) cnt from ' + tblName  +
                ' join ' + tblName01 + ' on DH_IDENTIFIER = RS_IDENTIFIER and dh_rsc_code = rs_rsc_code' +
                ' WHERE RS_NUM_RSC_COMP > 1 ' + AND_IDF_Condition('RS_IDENTIFIER') +
                ' group by rs_rsc_code ' +
                ' order by rs_rsc_code ';

  ArcQry.SQL.Text := srvSqlStr;
  ArcQry.Active := true;
  ArcQry_Cnt_FIELD    := ArcQry.FieldByName('cnt');
  ArcQry_RscCode_FIELD := ArcQry.FieldByName('RS_RSC_CODE');
  while not ArcQry.eof do
  begin
    if ArcQry_Cnt_FIELD.AsInteger > 1 then
      ResListHavingSubRes.Add(Trim(ArcQry_RscCode_FIELD.Asstring));
    ArcQry.next
  end;
  ResListHavingSubRes.Sorted := true;

  m_TemplateQUANTITYTYPE.Sorted := true;
  m_TemplateFINALANDSPLIT.Sorted := true;

  with HostQry do
  begin
    Sql.Clear;

    SQL.Text := ' Select' +
    ' ppsu.PROPROGRESSPROGRESSNUMBER ProgressNumber, ' +
    ' pp.ProgressTemplateCode, ' +
    ' pd.CounterCode, ' +
    ' pd.code, ' +
    ' pd.TemplateCode, ' +
    ' pds.StepNumber, ' +
    ' PDS.InitialBasePrimaryQuantity, ' +
    ' PDS.FinalBasePrimaryQuantity, ' +
    ' PDS.InitialUserPrimaryQuantity, ' +
    ' PDS.FinalUserPrimaryQuantity, ' +
    ' case when PDS.ProgressStatus = ' + QuotedStr('3') + ' then ' + QuotedStr('1') + ' else ' + QuotedStr('0') + ' end ClosedStep, ' +
    ' PDS.ProductionOrderCode, ' +
    ' COALESCE(pp.ProgressStartPreprocessDate,pp.ProgressStartProcessDate,pp.ProgressStartPostProcessDate,pp.ProgressPartialEndDate,pp.ProgressEndDate) StartDate, ' +
    ' COALESCE(pp.ProgressStartPreprocessTime,pp.ProgressStartProcessTime,pp.ProgressStartPostProcessTime,pp.ProgressPartialEndTime,pp.ProgressEndTime,{t ' + QuotedStr(MidNight) + '}) StartTime, ' +
    ' COALESCE(pp.ProgressEndDate,pp.ProgressPartialEndDate,pp.ProgressStartPostProcessDate,pp.ProgressStartProcessDate,pp.ProgressStartPreprocessDate) EndDate, ' +
    ' COALESCE(pp.ProgressEndTime,pp.ProgressPartialEndTime,pp.ProgressStartPostProcessTime,pp.ProgressStartProcessTime,pp.ProgressStartPreprocessTime,{t ' + QuotedStr(MidNight) + '}) EndTime, ' +
    ' pp.MachineCode, ' +
    ' pp.primaryqty, ' +
    ' pp.secondaryqty, ' +
    ' pp.packagingqty, ' +
    ' ppsu.primaryqty DemandProgPrimaryQty, ' +
    ' ppsu.SecondaryQty DemandProgSecondaryQty, ' +
    ' ppsu.PackagingQty DemandProgPackagingQty, ' +
    ' pds.workcentercode ' +
    ' from PRODUCTIONPROGRESSSTEPUPDATED PPSU ' +
    ' join SchedulesDownloadDemands sdd ' +
    ' on  sdd.companycode = ppsu.PRODUCTIONPROGRESSCOMPANYCODE ' +
    ' and sdd.countercode = ppsu.DEMANDSTEPPRODEMANDCNTCODE ' +
    ' and sdd.code = ppsu.DEMANDSTEPPRODUCTIONDEMANDCODE ' +
    ' and sdd.environmentcode = ' + QuotedStr(IniAppGlobals.EnvironmentCode) +
    ' Join ProductionProgress PP ' +
    ' On  PP.CompanyCode = ppsu.ProductionProgressCompanyCode ' +
    ' and PP.ProgressNumber = ppsu.PROPROGRESSPROGRESSNUMBER ' +
    ' and pp.inactive IN (' + QuotedStr('0') + ',' + QuotedStr('1') + ')' +
    ' and pp.primaryqty >= 0 ' +
    ' and pp.machinecode is not null ' +
    ' and pp.progresstemplatecode in (' + m_TemplateHandledProgress + ')' +
    ' Join ProductionDemand PD ' +
    ' on  PD.CompanyCode = ppsu.PRODUCTIONPROGRESSCOMPANYCODE ' +
    ' and PD.CounterCode = ppsu.DEMANDSTEPPRODEMANDCNTCODE ' +
    ' and PD.Code = ppsu.DEMANDSTEPPRODUCTIONDEMANDCODE ' +
    ' Join ProductionDemandStep PDS ' +
    ' on  PDS.ProductionDemandCompanyCode = ppsu.PRODUCTIONPROGRESSCOMPANYCODE ' +
    ' and PDS.ProductionDemandCounterCode = ppsu.DEMANDSTEPPRODEMANDCNTCODE ' +
    ' and PDS.ProductionDemandCode = ppsu.DEMANDSTEPPRODUCTIONDEMANDCODE ' +
    ' and PDS.StepNumber = ppsu.DEMANDSTEPSTEPNUMBER ' +
    ' and PDS.WorkCenterCode IN (' + handledWorkCentersSql + ')' +
    ' where ppsu.PRODUCTIONPROGRESSCOMPANYCODE = ' + QuotedStr(CompanyInUsed) +
    ' and ' +
    ' (pp.ProgressStartPreprocessDate is not null or pp.ProgressStartProcessDate is not null or ' +
    ' pp.ProgressStartPostProcessDate is not null or pp.ProgressPartialEndDate is not null or ' +
    ' pp.ProgressEndDate is not null)' +
    ' order by pp.MachineCode, ' +
    ' COALESCE(pp.ProgressStartPreprocessDate,pp.ProgressStartProcessDate,pp.ProgressStartPostProcessDate,pp.ProgressPartialEndDate,pp.ProgressEndDate), ' +
    ' COALESCE(pp.ProgressStartPreprocessTime,pp.ProgressStartProcessTime,pp.ProgressStartPostProcessTime,pp.ProgressPartialEndTime,pp.ProgressEndTime,{t ' + QuotedStr(MidNight) + '}), ' +
    ' PDS.ProductionOrderCode, ' +
    ' pd.CounterCode, ' +
    ' pd.code, ' +
    ' pds.StepNumber ';

    SqlPrint.Add(SQL.Text);
    SqlPrint.SaveToFile(LocAppGlobals.AppDir + '\ProgressPrepareSql.txt');
    SqlPrint.Free;
    FetchOptions.RowsetSize := 5000;
    open;

    MachineCode_FIELD := HostQry.FieldByName('MachineCode');
    CounterCode_FIELD := HostQry.FieldByName('CounterCode');
    Code_FIELD :=        HostQry.FieldByName('Code');
    DemandProgPrimaryQty_FIELD := HostQry.FieldByName('DemandProgPrimaryQty');
    InitialBasePrimaryQuantity_FIELD := HostQry.FieldByName('InitialBasePrimaryQuantity');
    FinalBasePrimaryQuantity_FIELD := HostQry.FieldByName('FinalBasePrimaryQuantity');
    ProgressTemplateCode_FIELD := HostQry.FieldByName('ProgressTemplateCode');
    ProgressNumber_FIELD := HostQry.FieldByName('ProgressNumber');
    StepNumber_FIELD :=  HostQry.FieldByName('StepNumber');
    ProductionOrderCode_FIELD := HostQry.FieldByName('ProductionOrderCode');
    StartDate_FIELD := HostQry.FieldByName('StartDate');
    StartTime_FIELD := HostQry.FieldByName('StartTime');
    EndDate_FIELD := HostQry.FieldByName('EndDate');
    EndTime_FIELD := HostQry.FieldByName('EndTime');
    ClosedStep_FIELD := HostQry.FieldByName('ClosedStep');

    while not Eof do
    begin
      if (PrevResource <> '') and (PrevResource <> MachineCode_FIELD.AsString) then
	    begin
        ResourceEndCalc;
        for D := ProgressPerResource.Count - 1 downto 0 do
          dispose(PTPROGRESSES(ProgressPerResource[D]));
		    ProgressPerResource.Clear
	    end;

      PrevResource := MachineCode_FIELD.AsString;

      Company := Trim(CompanyInUsed);

      for I := Length(Company) to 2 do
        Company := Company + ' ';

      CounterCode := Trim(CounterCode_FIELD.AsString);

      for I := Length(CounterCode) to 7 do
        CounterCode := CounterCode + ' ';

      DemandNewCode := Code_FIELD.AsString;

      ProgressedQuantity := DemandProgPrimaryQty_FIELD.AsFloat;

      if InitialBasePrimaryQuantity_FIELD.AsFloat > 0 then
        FINAL_TO_INITIAL_DIVIDER := FinalBasePrimaryQuantity_FIELD.AsFloat/InitialBasePrimaryQuantity_FIELD.AsFloat
      else
        FINAL_TO_INITIAL_DIVIDER := 0;

      if (m_TemplateQUANTITYTYPE.IndexOf(ProgressTemplateCode_FIELD.AsString) <> -1) and (FINAL_TO_INITIAL_DIVIDER > 0) then
         ProgressedQuantity := ProgressedQuantity / FINAL_TO_INITIAL_DIVIDER;

	    new(PROGRESSESRec);
      PROGRESSESRec.ProgressNumber    := ProgressNumber_FIELD.AsString;
      PROGRESSESRec.DemandCounterCode := CounterCode_FIELD.AsString;
      PROGRESSESRec.DemandCode        := Code_FIELD.AsString;
	    PROGRESSESRec.Request         := Company + CounterCode + DemandNewCode;

      if NeedToMakeMerge then
        CheckMerge(PROGRESSESRec.Request, setStringLengthTo(PROGRESSESRec.DemandCounterCode , 8), productionDemandCounters);

	    PROGRESSESRec.Step            := StepNumber_FIELD.AsInteger;
	    PROGRESSESRec.Resource        := MachineCode_FIELD.AsString;
      PROGRESSESRec.ProductionOrderCode := ProductionOrderCode_FIELD.AsString;
	    PROGRESSESRec.ProgressStart   := StartDate_FIELD.AsDateTime + Frac(StartTime_FIELD.AsDateTime);
	    PROGRESSESRec.ProgressCurrent := EndDate_FIELD.AsDateTime + Frac(EndTime_FIELD.AsDateTime);

   {   PROGRESS_PERCENT         := 0;
      if HostQry.FieldByName('PrimaryQty').AsFloat > 0 then
      begin
        Temp := HostQry.FieldByName('DemandProgPrimaryQty').AsFloat/HostQry.FieldByName('PrimaryQty').AsFloat;
        if Temp > 1 then
           Temp := 1;
        Temp := getLimitedDecimalsForDouble(Temp, 8);
        PROGRESS_PERCENT := Temp * 100;
      end;

	    PROGRESSESRec.Qty := ProgressedQuantity * PROGRESS_PERCENT / 100;   }
      // Eran amd me commented all above since we coudnt understand we we used to
      // have the PROGRESS_PERCENT (we guess it was related to the old logic , when we used the old table NOw_progress
      // 12.12.2018

      PROGRESSESRec.Qty := ProgressedQuantity;
      PROGRESSESRec.Closed := false;
      if ClosedStep_FIELD.AsString = '1' then
	      PROGRESSESRec.Closed := true;
	    PROGRESSESRec.Deleted := false;
	    PROGRESSESRec.ProgressType := '1';//(Initial);
	    if PROGRESSESRec.Qty > 0 then
        PROGRESSESRec.ProgressType := '2';//(Generic);
      if PROGRESSESRec.ProgressCurrent > PROGRESSESRec.ProgressStart then
        PROGRESSESRec.ProgressType := '2';
	    if PROGRESSESRec.Closed then
        PROGRESSESRec.ProgressType := '3';
      if (PROGRESSESRec.ProgressType <> '1') and (PROGRESSESRec.ProgressCurrent = PROGRESSESRec.ProgressStart) then
        PROGRESSESRec.StartingQty := ProgressedQuantity
      else
        PROGRESSESRec.StartingQty := 0;

      PROGRESSESRec.Is_finalAndSplit := false;
      if m_TemplateFINALANDSPLIT.IndexOf(ProgressTemplateCode_FIELD.AsString) <> -1 then
         PROGRESSESRec.Is_finalAndSplit := true;

	    ProgressPerResource.add(PROGRESSESRec);
      Inc(IndexProgress);
      if (IndexProgress mod 500 = 0) then Application.ProcessMessages;
      Next;
    end;

    if (PrevResource <> '') then
    begin
	    ResourceEndCalc;
      for D := ProgressPerResource.Count - 1 downto 0 do
        dispose(PTPROGRESSES(ProgressPerResource[D]));
      ProgressPerResource.Clear
    end;

    for S := ProgressList.Count - 1 downto 0 do
    begin
      if PTPROGRESSES(ProgressList[S]).Is_finalAndSplit then
      begin
        if (PTPROGRESSES(ProgressList[S]).ProgressType = '2') then
          PTPROGRESSES(ProgressList[S]).ProgressType := '5';
      end;
    end;

    Result := ProgressList;
    if ProgressList.Count > 0 then
      ProgressList.Sort(SortProgress);

  end;

 {   Sql.Clear;
    SQL.Text := ' Select * from PROD_SCHED_PROGRESS ' +
                ' Order by SP_PREQ_NO, SP_PSTEP_ID, SP_RSC_CODE, SP_PROGRSTART';
    open;

    while true do
    begin
      if (IndexProgress > ProgressList.count - 1) and srvQryFD.Eof then break;

      if (IndexProgress > ProgressList.count - 1) or

      ((IndexProgress <= ProgressList.count - 1) and (not srvQryFD.Eof) and
       (PTPROGRESSES(ProgressList[IndexProgress]).Request > Trim(srvQryFD.FieldByName('SP_PREQ_NO').AsString))) or

      ((IndexProgress <= ProgressList.count - 1) and (not srvQryFD.Eof) and
        (PTPROGRESSES(ProgressList[IndexProgress]).Request = Trim(srvQryFD.FieldByName('SP_PREQ_NO').AsString)) and
       (PTPROGRESSES(ProgressList[IndexProgress]).Step > srvQryFD.FieldByName('SP_PSTEP_ID').AsInteger)) or

      ((IndexProgress <= ProgressList.count - 1) and (not srvQryFD.Eof) and
        (PTPROGRESSES(ProgressList[IndexProgress]).Request = Trim(srvQryFD.FieldByName('SP_PREQ_NO').AsString)) and
       (PTPROGRESSES(ProgressList[IndexProgress]).Step = srvQryFD.FieldByName('SP_PSTEP_ID').AsInteger) and
       (PTPROGRESSES(ProgressList[IndexProgress]).Resource > srvQryFD.FieldByName('SP_RSC_CODE').AsString)) or

      ((IndexProgress <= ProgressList.count - 1) and (not srvQryFD.Eof) and
        (PTPROGRESSES(ProgressList[IndexProgress]).Request = Trim(srvQryFD.FieldByName('SP_PREQ_NO').AsString)) and
       (PTPROGRESSES(ProgressList[IndexProgress]).Step = srvQryFD.FieldByName('SP_PSTEP_ID').AsInteger) and
       (PTPROGRESSES(ProgressList[IndexProgress]).Resource = Trim(srvQryFD.FieldByName('SP_RSC_CODE').AsString)) and
       (PTPROGRESSES(ProgressList[IndexProgress]).ProgressStart > srvQryFD.FieldByName('SP_PROGRSTART').AsDateTime)) then
      begin
        QryFDDel.sql.Clear;
     //   srvTrs.Active := true;
        QryFDDel.Sql.Add(' delete from PROD_SCHED_PROGRESS where');
        QryFDDel.Sql.Add('SP_PREQ_NO' + '=' + QuotedStr(srvQryFD.FieldByName('SP_PREQ_NO').AsString));
        QryFDDel.Sql.Add(' AND SP_PSTEP_ID'   + '=' + QuotedStr(IntToStr(srvQryFD.FieldByName('SP_PSTEP_ID').AsInteger)));
        QryFDDel.Sql.Add(' AND SP_RSC_CODE'   + '=' + QuotedStr(srvQryFD.FieldByName('SP_RSC_CODE').AsString));
        QryFDDel.Sql.Add(' AND SP_PROGRSTART' + '=' + ConvertDateFormatTo(srvQryFD.FieldByName('SP_PROGRSTART').AsDateTime , StrToInt(IniAppGlobals.DownloadTo)));
        QryFDDel.ExecSQL;
        QryFDDel.Connection.commit;

        srvQryFD.next;
      //  Application.ProcessMessages;
        continue;
      end;

      if srvQryFD.Eof or

        ((IndexProgress <= ProgressList.count - 1) and (not srvQryFD.Eof) and
         (PTPROGRESSES(ProgressList[IndexProgress]).Request < Trim(srvQryFD.FieldByName('SP_PREQ_NO').AsString)) or

        ((IndexProgress <= ProgressList.count - 1) and (not srvQryFD.Eof) and
          (PTPROGRESSES(ProgressList[IndexProgress]).Request = Trim(srvQryFD.FieldByName('SP_PREQ_NO').AsString)) and
         (PTPROGRESSES(ProgressList[IndexProgress]).Step < srvQryFD.FieldByName('SP_PSTEP_ID').AsInteger)) or

        ((IndexProgress <= ProgressList.count - 1) and (not srvQryFD.Eof) and
          (PTPROGRESSES(ProgressList[IndexProgress]).Request = Trim(srvQryFD.FieldByName('SP_PREQ_NO').AsString)) and
         (PTPROGRESSES(ProgressList[IndexProgress]).Step = srvQryFD.FieldByName('SP_PSTEP_ID').AsInteger) and
         (PTPROGRESSES(ProgressList[IndexProgress]).Resource < srvQryFD.FieldByName('SP_RSC_CODE').AsString)) or

        ((IndexProgress <= ProgressList.count - 1) and (not srvQryFD.Eof) and
          (PTPROGRESSES(ProgressList[IndexProgress]).Request = Trim(srvQryFD.FieldByName('SP_PREQ_NO').AsString)) and
         (PTPROGRESSES(ProgressList[IndexProgress]).Step = srvQryFD.FieldByName('SP_PSTEP_ID').AsInteger) and
         (PTPROGRESSES(ProgressList[IndexProgress]).Resource = srvQryFD.FieldByName('SP_RSC_CODE').AsString) and
         (PTPROGRESSES(ProgressList[IndexProgress]).ProgressStart < srvQryFD.FieldByName('SP_PROGRSTART').AsDateTime))) then
      begin
        ProgEndDate := 0;
        if (PTPROGRESSES(ProgressList[IndexProgress]).ProgressType = '3') or
           (PTPROGRESSES(ProgressList[IndexProgress]).ProgressType = '5') then
          ProgEndDate := PTPROGRESSES(ProgressList[IndexProgress]).ProgressCurrent;

        srvQryFDInsert.Sql.Clear;
     //   srvTrs.Active := true;
        srvQryFDInsert.SQL.Text := 'INSERT INTO PROD_SCHED_PROGRESS ("SP_PREQ_NO", "SP_PSTEP_ID", "SP_PSUBST_ID", ' +
        '"SP_REPROC_NO", "SP_LAST_PROG_TYPE", "SP_RSC_CODE", "SP_PROGRESED_GROUP", ' +
        '"SP_PROGRSTART", "SP_CURR_PRG_DATE", "SP_PROGREND", "SP_QTY", "SP_REMAIN_TIME"' +
        ' ) VALUES (' +
        QuotedStr(PTPROGRESSES(ProgressList[IndexProgress]).Request) + ', ' +
        QuotedStr(IntToStr(PTPROGRESSES(ProgressList[IndexProgress]).Step)) + ', ' +
        QuotedStr('-1') + ', ' +
        QuotedStr('-1') + ', ' +
        QuotedStr(PTPROGRESSES(ProgressList[IndexProgress]).ProgressType) + ', ' +
        QuotedStr(PTPROGRESSES(ProgressList[IndexProgress]).Resource) + ', ' +
        QuotedStr('0') + ', ' +
        ConvertDateFormatTo(PTPROGRESSES(ProgressList[IndexProgress]).ProgressStart , StrToInt(IniAppGlobals.DownloadTo)) + ', ' +
        ConvertDateFormatTo(PTPROGRESSES(ProgressList[IndexProgress]).ProgressCurrent , StrToInt(IniAppGlobals.DownloadTo)) + ', ' +
        ConvertDateFormatTo(ProgEndDate , StrToInt(IniAppGlobals.DownloadTo)) + ', ' +
        FloatToStr(PTPROGRESSES(ProgressList[IndexProgress]).Qty) + ', ' +
        FloatToStr(-1) + ')';
        srvQryFDInsert.ExecSQL;
        srvQryFDInsert.Connection.Commit;
        Inc(IndexProgress);
        Continue
      end;

      ProgEndDate := 0;
      if (PTPROGRESSES(ProgressList[IndexProgress]).ProgressType = '3') or
         (PTPROGRESSES(ProgressList[IndexProgress]).ProgressType = '5') then
        ProgEndDate := PTPROGRESSES(ProgressList[IndexProgress]).ProgressCurrent;

      if (PTPROGRESSES(ProgressList[IndexProgress]).ProgressType <> srvQryFD.FieldByName('SP_LAST_PROG_TYPE').AsString) or
         (PTPROGRESSES(ProgressList[IndexProgress]).ProgressCurrent <> srvQryFD.FieldByName('SP_CURR_PRG_DATE').AsDateTime) or
       //  (ProgEndDate <> srvQryFD.FieldByName('SP_PROGREND').AsDateTime) or
         (PTPROGRESSES(ProgressList[IndexProgress]).Qty <> srvQryFD.FieldByName('SP_QTY').AsFloat) then
      begin
        srvQryFDUpdate.Sql.Clear;
     //   srvTrs.Active := true;
        srvQryFDUpdate.Sql.Add('update PROD_SCHED_PROGRESS set ');
        srvQryFDUpdate.Sql.Add(' SP_LAST_PROG_TYPE ' + '=''' + PTPROGRESSES(ProgressList[IndexProgress]).ProgressType + '''' + ',');
        srvQryFDUpdate.Sql.Add(' SP_CURR_PRG_DATE   ' + '=' + ConvertDateFormatTo(PTPROGRESSES(ProgressList[IndexProgress]).ProgressCurrent , StrToInt(IniAppGlobals.DownloadTo)) + ', ');
        srvQryFDUpdate.Sql.Add(' SP_PROGREND ' + '=' + ConvertDateFormatTo(ProgEndDate , StrToInt(IniAppGlobals.DownloadTo)) + ', ');
        srvQryFDUpdate.Sql.Add(' SP_QTY   ' + '=''' + FloatToStr(PTPROGRESSES(ProgressList[IndexProgress]).Qty) + '''');
        srvQryFDUpdate.Sql.Add(' Where ');
        srvQryFDUpdate.Sql.Add(' SP_PREQ_NO '    + '=''' + PTPROGRESSES(ProgressList[IndexProgress]).Request + '''' + ' and ');
        srvQryFDUpdate.Sql.Add(' SP_PSTEP_ID '   + '=''' + IntToStr(PTPROGRESSES(ProgressList[IndexProgress]).Step) + '''' + ' and ');
        srvQryFDUpdate.Sql.Add(' SP_RSC_CODE '   + '=''' + PTPROGRESSES(ProgressList[IndexProgress]).Resource + '''' + ' and ');
        srvQryFDUpdate.Sql.Add(' SP_PROGRSTART ' + '='   + ConvertDateFormatTo(PTPROGRESSES(ProgressList[IndexProgress]).ProgressStart , StrToInt(IniAppGlobals.DownloadTo)));
        srvQryFDUpdate.ExecSQL;
        srvQryFDUpdate.connection.Commit;
      end;
      srvQryFD.Next;
      Inc(IndexProgress);
    end;                   }



  for D := ProgressPerResource.Count - 1 downto 0 do
    dispose(PTPROGRESSES(ProgressPerResource[D]));
  ProgressPerResource.Free;
  ResListHavingSubRes.Free;

{  srvQryFD.Free;
  QryFDDel.Free;
  srvQryFDInsert.Free;
  srvQryFDUpdate.Free; }
//  srvTrs.Free;
//  srvQryFDTrs.Free;
end;

//------------------------------------------------------------------------------------------------//

function BuildHandledProductionProgressTemplatesList(srvQryFD : TMqmQuery) : boolean;
var
  SrvSqlStr : string;
  DndArchiveArcName : TDndArchiveName;
  TableName : string;
  fldCode, fldFinalAndSplit, fldQuantityType : TField;
begin
  DndArchiveArcName := GetDndArchiveLocalName;

  TableName := 'PRODUCTIONPROGRESSTEMPLATE';
  if DndArchiveArcName <> TD_Interbase then
    TableName := 'SCDA_' + 'PRODUCTIONPRGRESTEMPLATE';

  Result := true;
  srvSqlStr := 'SELECT CODE, FINALANDSPLIT, QUANTITYTYPE ' +
               'FROM ' + TableName +
               ' WHERE HANDLEDBYMQM = ' + QuotedStr('1') + AND_IDF_Condition('IDENTIFIER');
  srvQryFD.SQL.Text := srvSqlStr;
  srvQryFD.Active := true;

  m_TemplateHandledProgress := '';

  if srvQryFD.Eof then
  begin
    if m_TemplateHandledProgress = '' then
      m_TemplateHandledProgress := QuotedStr(m_TemplateHandledProgress);
    Result := false;
    Exit;
  end;

  fldCode          := srvQryFD.FieldByName('CODE');
  fldFinalAndSplit := srvQryFD.FieldByName('FINALANDSPLIT');
  fldQuantityType  := srvQryFD.FieldByName('QUANTITYTYPE');

  while (not srvQryFD.Eof ) do
  begin
    if (m_TemplateHandledProgress <> '') then
      m_TemplateHandledProgress := m_TemplateHandledProgress + ', ';
    m_TemplateHandledProgress   := m_TemplateHandledProgress + QuotedStr(Trim(fldCode.AsString));
    if fldFinalAndSplit.AsString = '1' then
       m_TemplateFINALANDSPLIT.Add(Trim(fldCode.AsString));
    if fldQuantityType.AsString = '1' then
       m_TemplateQUANTITYTYPE.Add(Trim(fldCode.AsString));
    srvQryFD.Next
  end;

  if m_TemplateHandledProgress = '' then
    m_TemplateHandledProgress := QuotedStr(m_TemplateHandledProgress);

  srvQryFD.close;

end;

//------------------------------------------------------------------------------------------------//

function TakeMaxHistoricalDaysToKeep(srvQryFD : TMqmQuery) : integer;
var
  srvSqlStr : string;
  DndArchiveArcName : TDndArchiveName;
  TableName : string;
begin
  DndArchiveArcName := GetDndArchiveLocalName;

  TableName := 'PRODUCTIONDEMANDTEMPLATE';
  if DndArchiveArcName <> TD_Interbase then
    TableName := 'SCDA_' + 'PRODUCTIONDEMANDTEMPLATE';
{  srvQryFDTest := CreateMqmQuery;
  srvSqlStr := 'SELECT MAX(DAYSTOKEEPHISTORY) as MAXHISTORY '+
               'FROM PRODUCTIONDEMANDTEMPLATE ' +
               'WHERE ( HANDLEDBYMQM = ' + QuotedStr('2') + ' OR ' +
               'HANDLEDBYMQM = ' + QuotedStr('1') + ' OR HANDLEDBYMCM = ' + QuotedStr('1') + ' ) ';

  srvQryFDTest.SQL.Text := srvSqlStr;
  srvQryFDTest.Active := true;
  Application.ProcessMessages;
  if srvQryFDTest.FieldByName('MAXHISTORY').IsNull then
    Result := 20
  else
    Result := StrToInt((srvQryFDTest.FieldByName('MAXHISTORY').AsString)); }

//  srvQryFD := CreateMqmQuery;
 { srvSqlStr := 'SELECT MAX(DAYSTOKEEPHISTORY) as MAXHISTORY '+
               'FROM PRODUCTIONDEMANDTEMPLATE ' +
               'WHERE ( HANDLEDBYMQM = ' + QuotedStr('2') + ' OR ' +
               'HANDLEDBYMQM = ' + QuotedStr('1') + ' OR HANDLEDBYMCM = ' + QuotedStr('1') + ' ) ';

  srvQryFD.SQL.Text := srvSqlStr;
  srvQryFD.Active := false;
  srvQryFD.Active := true;
  Application.ProcessMessages;
  if srvQryFD.FieldByName('MAXHISTORY').IsNull then
    Result := 20
  else
    Result := StrToInt((srvQryFD.FieldByName('MAXHISTORY').AsString));  }
end;

//------------------------------------------------------------------------------------------------//

procedure DeleteAllNotRelevantProgresses(HostQry : TMqmQuery;
                                        WcHandledStr, DemandTemplatesStr_HandledAlways, DemandTemplatesStr_HandledOnlyGroup : string);
var
  hostSqlStr, CompanyInUsed : string;
//  HostName, LocalHostName : TDndArchiveName;
begin
  if not GetCompanyLevelHandlingByEntityName('PRODUCTIONPROGRESS', CompanyInUsed) then
    CompanyInUsed := IniAppGlobals.CompanyCode;

  hostSqlStr :=
    'DELETE FROM SchedulesDownloadProgress SDP ' +
    'WHERE SDP.COMPANYCODE = ' +  QuotedStr(CompanyInUsed) +
    'AND SDP.ENVIRONMENTCODE = '+ QuotedStr(IniAppGlobals.EnvironmentCode) +
    'AND NOT EXISTS ' +
     '(SELECT 1 ' +
      'FROM ProductionProgress PP ' +
      'WHERE PP.CompanyCode = SDP.companycode ' +
      'AND PP.ProgressNumber = SDP.progressnumber ' +
      'AND PP.ProgressTemplateCode IN (' + m_TemplateHandledProgress + ')' +
      'AND PP.Inactive IN (' + QuotedStr('0') + ',' + QuotedStr('1') + '))';

  HostQry.Connection.StartTransaction;
  HostQry.SQL.Text := hostSqlStr;
  HostQry.ExecSQL;
  HostQry.Connection.Commit;

  hostSqlStr := 'DELETE FROM SCHEDULESDOWNLOADPROGRESS SDP ' +
    ' WHERE SDP.ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) +
    ' AND SDP.COMPANYCODE = ' + QuotedStr(CompanyInUsed) +
    ' AND ORIGINALENDDATE <  {d' + ConvertDateFormatDb2Oracle(Now-StrToInt(IniAppGlobals.DaysKeepHistory), false, false) + '}' +
    ' AND NOT EXISTS ' +
    ' (SELECT 1 FROM PRODUCTIONPROGRESSSTEPUPDATED PPSU ' +
    ' JOIN PRODUCTIONDEMAND PD ' +
    ' ON PD.COMPANYCODE = PPSU.PRODUCTIONPROGRESSCOMPANYCODE ' +
    ' AND PD.COUNTERCODE = PPSU.DEMANDSTEPPRODEMANDCNTCODE ' +
    ' AND PD.CODE = PPSU.DEMANDSTEPPRODUCTIONDEMANDCODE ' +
    ' AND PD.PROGRESSSTATUS IN (' + QuotedStr('0') + ',' + QuotedStr('1') + ',' + QuotedStr('2') + ',' +
      QuotedStr('3') + ',' + QuotedStr('4') + ',' + QuotedStr('5') + ')' +
    ' AND PD.TEMPLATECODE IN (' + DemandTemplatesStr_HandledAlways + ')' +
    ' WHERE PPSU.PRODUCTIONPROGRESSCOMPANYCODE = SDP.COMPANYCODE ' +
    ' AND PPSU.PROPROGRESSPROGRESSNUMBER = SDP.PROGRESSNUMBER)';

  HostQry.Connection.StartTransaction;
  HostQry.SQL.Text := hostSqlStr;
  HostQry.ExecSQL;
  HostQry.Connection.Commit;

end;

//------------------------------------------------------------------------------------------------//

procedure DeleteAllNotRelevantProgresses2(HostQry : TMqmQuery; WcHandledStr : string);
var
  hostSqlStr, CompanyInUsed : string;
begin
  if not GetCompanyLevelHandlingByEntityName('PRODUCTIONPROGRESS', CompanyInUsed) then
    CompanyInUsed := IniAppGlobals.CompanyCode;

  hostSqlStr := 'DELETE FROM SCHEDULESDOWNLOADPROGRESS SDP ' +
    ' WHERE SDP.ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) +
    ' AND SDP.COMPANYCODE = ' + QuotedStr(CompanyInUsed) +
    ' AND ORIGINALENDDATE <  {d' + ConvertDateFormatDb2Oracle(Now-StrToInt(IniAppGlobals.DaysKeepHistory), false, false) + '}' +
    ' AND NOT EXISTS ' +
    ' (SELECT 1 FROM PRODUCTIONPROGRESSSTEPUPDATED PPSU ' +
    ' JOIN PRODUCTIONDEMANDSTEP PDS ' +
    ' ON PDS.PRODUCTIONDEMANDCOMPANYCODE = PPSU.PRODUCTIONPROGRESSCOMPANYCODE ' +
    ' AND PDS.PRODUCTIONDEMANDCOUNTERCODE = PPSU.DEMANDSTEPPRODEMANDCNTCODE ' +
    ' AND PDS.PRODUCTIONDEMANDCODE = PPSU.DEMANDSTEPPRODUCTIONDEMANDCODE ' +
    ' AND PDS.STEPNUMBER = PPSU.DEMANDSTEPSTEPNUMBER ' +
    ' AND PDS.WORKCENTERCODE IN (' + WcHandledStr + ')' +
    ' WHERE PPSU.PRODUCTIONPROGRESSCOMPANYCODE = SDP.COMPANYCODE ' +
    ' AND PPSU.PROPROGRESSPROGRESSNUMBER = SDP.PROGRESSNUMBER)';

  HostQry.Connection.StartTransaction;
  HostQry.SQL.Text := hostSqlStr;
  HostQry.ExecSQL;
  HostQry.Connection.Commit;
end;

//------------------------------------------------------------------------------------------------//

{  if StrToInt(IniAppGlobals.DownloadFrom) = 0 then
    ConvertDateFormat := 1
  else if StrToInt(IniAppGlobals.DownloadFrom) = 1 then
    ConvertDateFormat := 2
  else if StrToInt(IniAppGlobals.DownloadFrom) = 2 then
    ConvertDateFormat := 3
  else
    ConvertDateFormat := 1;    }

//  avi
//  srvSqlStr := 'Delete from Now_Progress where NP_ORIG_END_DATE < ' + ConvertDateFormatTo(DateToKeepHistory, GetDownloadTo) +
//                ' or NP_PROGRESS_TAMPLATECODE not IN (' + m_TemplateHandledProgress + ')';


{  srvSqlStr := 'Delete from ' + LocalTableName + ' where NP_PROGRESS_TAMPLATECODE not IN (' + m_TemplateHandledProgress + ')';
  srvQryFD.SQL.Text := srvSqlStr;
  srvQryFD.ExecSQL;
  Application.ProcessMessages;
  srvQryFD.connection.commit;   }

//  srvSqlStr := 'update Now_Progress set Np_ToDelete = ' + QuotedStr('0'); // mark all to 0
//  srvQryFD.SQL.Text := srvSqlStr;
//  srvQryFD.ExecSQL;


{  if HostName = TD_Db2 then
    hostSqlStr := ' Delete from SchedulesDownloadProgress where ' +
             'ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' AND ' +
             'COMPANYCODE = ' + QuotedStr(CompanyInUsed) + ' AND ' +
             '(varchar_format(OriginalEndDate, ' + QuotedStr('YYYYMMDD') + ') < ' + ConvertDateFormatToYYYYMMDD(DateToKeepHistory, StrToInt(IniAppGlobals.DownloadTo)) + ' OR ProgressTemplateCode not IN (' + m_TemplateHandledProgress + '))'

  else if HostName = TD_Oracle then
    hostSqlStr := ' Delete from SchedulesDownloadProgress where ' +
             'ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' AND ' +
             'COMPANYCODE = ' + QuotedStr(CompanyInUsed) + ' AND ' +
             '(TO_CHAR(OriginalEndDate, ' + QuotedStr('YYYYMMDD') + ') < ' + ConvertDateFormatToYYYYMMDD(DateToKeepHistory, StrToInt(IniAppGlobals.DownloadTo)) + ' OR ProgressTemplateCode not IN (' + m_TemplateHandledProgress + '))'

  else if HostName = TD_Db2OnAs400 then
    hostSqlStr := ' Delete from SchedulesDownloadProgress where ' +
             'ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' AND ' +
             'COMPANYCODE = ' + QuotedStr(CompanyInUsed) + ' AND ' +
             '(OriginalEndDate < ' + ConvertDateFormatFrom(DateToKeepHistory, TD_Db2OnAs400) + ')' + ' OR ProgressTemplateCode not IN (' + m_TemplateHandledProgress + ')';
  DateToKeepHistoryToDelete := DateToKeepHistory;
  srvSqlStr := 'Delete from ' + LocalTableName + ' where '  +
               'NP_ORIG_END_DATE < ' + ConvertDateFormatTo(DateToKeepHistoryToDelete, LocalHostName);



  srvQryFD.SQL.Text := srvSqlStr;
  srvQryFD.ExecSQL;
  Application.ProcessMessages;
  srvQryFD.connection.commit;

  HostQry.SQL.Text := hostSqlStr;
  HostQry.ExecSQL;                 }

//------------------------------------------------------------------------------------------------//

{procedure DiscoverAddProgressAndDelete(srvQryFD : TADOQuery; HostQry : TMqmQuery; DateToKeepHistory : TDate; CompanyInUsed : string);
var
  HostQryDel : TMqmQuery;
  srvQryFDDel  : TADOQuery;
  hostSqlStr : string;
  ProgressNumbers : string;
  Index : integer;
  ConvertDateFormat : Integer;
  Delete : boolean;
  PrevResource, demand, Company, CounterCode, DemandCode : string;
begin
  if GetDownloadFrom = 0 then
    ConvertDateFormat := 1
  else if GetDownloadFrom = 1 then
    ConvertDateFormat := 2
  else
    ConvertDateFormat := 1;

  HostQryDel := CreateHostQuery;
  srvQryFDDel  := CreateQuery(Main_DB);

  if ConvertDateFormat = 1 then
    hostSqlStr := 'Select ProgressNumber ' +
                  'From SchedulesDownloadProgress where ' +
                  ' ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' AND ' +
                  ' COMPANYCODE = ' + QuotedStr(CompanyInUsed) +
                  ' Except ' +
                  ' Select ProgressNumber From ProductionProgress ' +
                  ' where CompanyCode = ' + QuotedStr(CompanyInUsed) + ' and ' + ' ProgressTemplateCode IN (' + m_TemplateHandledProgress + ')' +
                  ' and MachineCode is not null and ' +
                  '((ProgressEndDate Is Not Null and varchar_format(ProgressEndDate, ' + QuotedStr('YYYYMMDD') + ') >= ' + ConvertDateFormatToYYYYMMDD(DateToKeepHistory, GetDownloadTo) + ') OR ' +
	                '(ProgressEndDate Is Null and ProgressPartialEndDate Is Not Null and ' +
	                ' varchar_format(ProgressPartialEndDate, ' + QuotedStr('YYYYMMDD') + ') >= ' + ConvertDateFormatToYYYYMMDD(DateToKeepHistory, GetDownloadTo) + ') OR ' +
              	  '(ProgressEndDate Is Null and ProgressPartialEndDate Is Null and ProgressStartPostProcessDate Is Not Null and ' +
	                ' varchar_format(ProgressStartPostProcessDate, ' + QuotedStr('YYYYMMDD') + ') >= ' + ConvertDateFormatToYYYYMMDD(DateToKeepHistory, GetDownloadTo) + ') OR ' +
	                ' (ProgressEndDate Is Null and ProgressPartialEndDate Is Null and ProgressStartPostProcessDate Is Null and ' +
           	      ' ProgressStartProcessDate Is Not Null and ' +
	                ' varchar_format(ProgressStartProcessDate, ' + QuotedStr('YYYYMMDD') + ') >= ' + ConvertDateFormatToYYYYMMDD(DateToKeepHistory, GetDownloadTo) + ') OR ' +
	                ' (ProgressEndDate Is Null and ProgressPartialEndDate Is Null and ProgressStartPostProcessDate Is Null and ' +
		              ' ProgressStartProcessDate Is Null and ProgressStartPreprocessDate Is Not Null and ' +
	                ' varchar_format(ProgressStartPreprocessDate, ' + QuotedStr('YYYYMMDD') + ') >= ' + ConvertDateFormatToYYYYMMDD(DateToKeepHistory, GetDownloadTo) + '))'

  else if ConvertDateFormat = 2 then
    hostSqlStr := 'Select ProgressNumber ' +
                  'From SchedulesDownloadProgress where ' +
                  ' ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' AND ' +
                  ' COMPANYCODE = ' + QuotedStr(CompanyInUsed) +
                  ' Minus ' +
                  ' Select ProgressNumber From ProductionProgress ' +
                  ' where CompanyCode = ' + QuotedStr(CompanyInUsed) + ' and ' + ' ProgressTemplateCode IN (' + m_TemplateHandledProgress + ')' +
                  ' and MachineCode is not null and ' +
                  '((ProgressEndDate Is Not Null and TO_CHAR(ProgressEndDate, ' + QuotedStr('YYYYMMDD') + ') >= ' + ConvertDateFormatToYYYYMMDD(DateToKeepHistory, GetDownloadTo) + ') OR ' +
	                '(ProgressEndDate Is Null and ProgressPartialEndDate Is Not Null and ' +
	                ' TO_CHAR(ProgressPartialEndDate, ' + QuotedStr('YYYYMMDD') + ') >= ' + ConvertDateFormatToYYYYMMDD(DateToKeepHistory, GetDownloadTo) + ') OR ' +
              	  '(ProgressEndDate Is Null and ProgressPartialEndDate Is Null and ProgressStartPostProcessDate Is Not Null and ' +
	                ' TO_CHAR(ProgressStartPostProcessDate, ' + QuotedStr('YYYYMMDD') + ') >= ' + ConvertDateFormatToYYYYMMDD(DateToKeepHistory, GetDownloadTo) + ') OR ' +
	                ' (ProgressEndDate Is Null and ProgressPartialEndDate Is Null and ProgressStartPostProcessDate Is Null and ' +
           	      ' ProgressStartProcessDate Is Not Null and ' +
	                ' TO_CHAR(ProgressStartProcessDate, ' + QuotedStr('YYYYMMDD') + ') >= ' + ConvertDateFormatToYYYYMMDD(DateToKeepHistory, GetDownloadTo) + ') OR ' +
	                ' (ProgressEndDate Is Null and ProgressPartialEndDate Is Null and ProgressStartPostProcessDate Is Null and ' +
		              ' ProgressStartProcessDate Is Null and ProgressStartPreprocessDate Is Not Null and ' +
	                ' TO_CHAR(ProgressStartPreprocessDate, ' + QuotedStr('YYYYMMDD') + ') >= ' + ConvertDateFormatToYYYYMMDD(DateToKeepHistory, GetDownloadTo) + '))';

  HostQry.SQL.Text := hostSqlStr;
  HostQry.Open;

//In oracle,
//Instead of except , minus
//instead of varchar_format, to_char

  ProgressNumbers := '';
  Index := 0;
  While not HostQry.Eof do
  begin
    If Index = 30 then
    begin
     // srvQryFDDel.sql.Clear;
     // srvQryFDDel.SQL.Text := ' Delete from Now_Progress where NP_PROGRESS_NUMBER IN (' + ProgressNumbers + ')';
     // srvQryFDDel.SQL.Text := ' update Now_Progress set np_ToDelete = ' + QuotedStr('1') + ' where NP_PROGRESS_NUMBER IN (' + ProgressNumbers + ')';
     // srvQryFDDel.Connection.BeginTrans;
     // srvQryFDDel.ExecSQL;
     // srvQryFDDel.Connection.CommitTrans;
      HostQryDel.SQL.Clear;
      HostQryDel.SQL.Text := ' Delete from SchedulesDownloadProgress where ProgressNumber IN (' + ProgressNumbers + ')';
      HostQryDel.ExecSQL;
      ProgressNumbers := '';
      Index := 0;
    end;
    if (ProgressNumbers <> '') then
      ProgressNumbers := ProgressNumbers + ', ';
    ProgressNumbers   := ProgressNumbers + QuotedStr(HostQry.FieldByName('ProgressNumber').AsString);
    Index := Index + 1;
    HostQry.Next;
  end;

  if ProgressNumbers <> '' then
  begin
    //srvQryFDDel.SQL.Clear;
    //srvQryFDDel.Connection.BeginTrans;
    //srvQryFDDel.SQL.Text := ' Delete from Now_Progress where NP_PROGRESS_NUMBER IN (' + ProgressNumbers + ')';
    //srvQryFDDel.SQL.Text := ' update Now_Progress set np_ToDelete = ' + QuotedStr('1') + ' where NP_PROGRESS_NUMBER IN (' + ProgressNumbers + ')';
    //srvQryFDDel.ExecSQL;
    //srvQryFDDel.Connection.CommitTrans;
    HostQryDel.SQL.Clear;
    HostQryDel.SQL.Text := ' Delete from SchedulesDownloadProgress where ProgressNumber IN (' + ProgressNumbers + ')';
    HostQryDel.ExecSQL
  end;

  PrevResource := '';
  srvQryFD.SQL.Clear;
  srvQryFD.SQL.Text := ' Select * from NOW_Progress order by NP_RESOURCE_CODE, NP_START_DATE_TIME';
  srvQryFD.Open;

  Delete := false;
  while not srvQryFD.eof do
  begin
    if (srvQryFD.FieldByName('NP_RESOURCE_CODE').AsString <> PrevResource) then
    begin
      Delete := true;
      PrevResource := srvQryFD.FieldByName('NP_RESOURCE_CODE').AsString;
    end;

    if Delete = true then
    begin
      Company := Trim(CompanyInUsed);
      CounterCode := srvQryFD.FieldByName('NP_DEMAND_COUNTER_CODE').AsString;
      DemandCode := srvQryFD.FieldByName('NP_DEMAND_CODE').AsString;
      demand := Company + CounterCode + DemandCode;
      srvQryFDDel.SQL.Clear;
      srvQryFDDel.SQL.Text := ' Select * from Prod_Req where PR_Preq_No = ' + QuotedStr(demand);
      srvQryFDDel.Open;
      if not srvQryFDDel.Eof then
        delete := false;
    end;

    if Delete = true then
    begin
      srvQryFDDel.SQL.Clear;
      srvQryFDDel.Connection.BeginTrans;
      srvQryFDDel.Sql.Add(' delete from NOW_PROGRESS where');
      srvQryFDDel.Sql.Add(' NP_PROGRESS_NUMBER' + '=' + QuotedStr(srvQryFD.FieldByName('NP_PROGRESS_NUMBER').AsString));
      srvQryFDDel.Sql.Add(' AND NP_DEMAND_COUNTER_CODE'   + '=' + QuotedStr(srvQryFD.FieldByName('NP_DEMAND_COUNTER_CODE').AsString));
      srvQryFDDel.Sql.Add(' AND NP_DEMAND_CODE'   + '=' + QuotedStr(srvQryFD.FieldByName('NP_DEMAND_CODE').AsString));
      srvQryFDDel.Sql.Add(' AND NP_DEMAND_STEP' + '=' + QuotedStr(IntToStr(srvQryFD.FieldByName('NP_DEMAND_STEP').AsInteger)));
      srvQryFDDel.ExecSQL;
      srvQryFDDel.Connection.CommitTrans;
    end;
    srvQryFD.Next;
  end;

  HostQryDel.free;
  srvQryFDDel.free;
end;  }

//------------------------------------------------------------------------------------------------//

procedure AddToSchedulesDownloadProgress(ArcQry : TMqmQuery; HostQry : TMqmQuery; DemandTemplatesStr_HandledAlways, DemandTemplatesStr_HandledOnlyGroup : string);
var
  DateInSQL, CompanyInUsed : string;
  hostSqlStr : string;
  SqlPrint : TStringList;
begin
  SqlPrint := TStringList.Create;

  if not GetCompanyLevelHandlingByEntityName('PRODUCTIONPROGRESS',  CompanyInUsed) then
     CompanyInUsed := IniAppGlobals.CompanyCode;

  DateInSQL := '{d ' + ConvertDateFormatDb2Oracle(Now - StrToInt(IniAppGlobals.DaysKeepHistory), false, false) + '}';

  hostSqlStr := ' Insert into SchedulesDownloadProgress ' +
                '(Select PP.CompanyCode ,' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' EnvironmentCode , PP.ProgressNumber, PP.ProgressTemplateCode, ' +
                ' COALESCE(PP.ProgressEndDate, PP.ProgressPartialEndDate,PP.ProgressStartPostProcessDate, PP.ProgressStartProcessDate, PP.ProgressStartPreprocessDate) OriginalEndDate, ' +
                ' 0 EverDownloaded ' +
                ' From ProductionProgress PP ' +
                ' where PP.CompanyCode = ' + QuotedStr(CompanyInUsed) +
                ' and PP.ProgressTemplateCode IN (' + m_TemplateHandledProgress + ')' +
                ' AND PP.Inactive in ' + '(' + QuotedStr('0') + ',' + QuotedStr('1') + ')' +
                ' AND primaryqty >= ' + IntToStr(0) +
                ' and MachineCode is not null ' +
                ' and ((PP.ProgressEndDate Is Not Null and PP.ProgressEndDate >= ' + DateInSQL + ') or ' +
                ' (PP.ProgressEndDate Is Null and PP.ProgressPartialEndDate Is Not Null and PP.ProgressPartialEndDate >= ' + DateInSQL + ') or ' +
                ' (PP.ProgressEndDate Is Null and PP.ProgressPartialEndDate Is Null and PP.ProgressStartPostProcessDate Is not Null and PP.ProgressStartPostProcessDate >= ' + DateInSQL + ') or ' +
                ' (PP.ProgressEndDate Is Null and PP.ProgressPartialEndDate Is Null and PP.ProgressStartPostProcessDate Is Null and PP.ProgressStartProcessDate Is Not Null and ' +
                ' PP.ProgressStartProcessDate >= ' + DateInSQL + ') or ' +
                ' (PP.ProgressEndDate Is Null and PP.ProgressPartialEndDate Is Null and PP.ProgressStartPostProcessDate Is Null and PP.ProgressStartProcessDate Is Null and ' +
                ' PP.ProgressStartPreprocessDate Is Not Null and PP.ProgressStartPreprocessDate >= ' + DateInSQL + ')) ' +
                ' and not exists (select 1 from SchedulesDownloadProgress sdp where sdp.companycode = pp.companycode and sdp.ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) +
                ' and sdp.progressnumber = pp.progressnumber))';

  HostQry.SQL.Text := hostSqlStr;

  SqlPrint.Add(hostSqlStr);
  SqlPrint.SaveToFile(LocAppGlobals.AppDir + '\ProgressAddToSchedulesSql1.txt');

  try
    HostQry.Connection.StartTransaction;
    HostQry.ExecSQL;
    HostQry.Connection.Commit;
  except
    on E: Exception do
    begin
      HostQry.Connection.Rollback;
      if not (Pos('duplicate', E.Message) > 0) then
        raise;
    end;
  end;

  hostSqlStr := 'INSERT INTO SCHEDULESDOWNLOADPROGRESS( ' +
                ' SELECT DISTINCT ' +
                ' PP.COMPANYCODE , ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' , PP.PROGRESSNUMBER, PP.PROGRESSTEMPLATECODE, ' +
                ' COALESCE(PP.PROGRESSENDDATE, PP.PROGRESSPARTIALENDDATE,PP.PROGRESSSTARTPOSTPROCESSDATE, PP.PROGRESSSTARTPROCESSDATE, PP.PROGRESSSTARTPREPROCESSDATE) ORIGINALENDDATE, ' +
                ' 0 EVERDOWNLOADED FROM SCHEDULESDOWNLOADDEMANDS SDD ' +
                ' JOIN PRODUCTIONPROGRESSSTEPUPDATED PPSU ' +
                ' ON PPSU.PRODUCTIONPROGRESSCOMPANYCODE = SDD.COMPANYCODE ' +
                ' AND PPSU.DEMANDSTEPPRODEMANDCNTCODE = SDD.COUNTERCODE ' +
                ' AND PPSU.DEMANDSTEPPRODUCTIONDEMANDCODE = SDD.CODE ' +
                ' JOIN PRODUCTIONPROGRESS PP ' +
                ' ON PP.COMPANYCODE = PPSU.PRODUCTIONPROGRESSCOMPANYCODE ' +
                ' AND PP.PROGRESSNUMBER = PPSU.PROPROGRESSPROGRESSNUMBER ' +
                ' WHERE SDD.COMPANYCODE = ' + QuotedStr(CompanyInUsed) +
                ' AND SDD.ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) +
                ' AND PP.PROGRESSTEMPLATECODE IN (' + m_TemplateHandledProgress + ')' +
                ' AND PP.INACTIVE IN (' + QuotedStr('0') + ',' + QuotedStr('1') + ')' +
                ' AND PP.PRIMARYQTY >= 0 ' +
                ' AND PP.MACHINECODE IS NOT NULL ' +
                ' AND NOT EXISTS ' +
                ' (SELECT 1 FROM SCHEDULESDOWNLOADPROGRESS SDP ' +
                ' WHERE SDP.COMPANYCODE = PPSU.PRODUCTIONPROGRESSCOMPANYCODE ' +
                ' AND SDP.ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) +
                ' AND SDP.PROGRESSNUMBER = PPSU.PROPROGRESSPROGRESSNUMBER) ' +
                ' AND EXISTS ' +
                ' (SELECT 1 FROM PRODUCTIONDEMAND PD ' +
                ' WHERE  PD.COMPANYCODE = SDD.COMPANYCODE ' +
                ' AND PD.COUNTERCODE = SDD.COUNTERCODE ' +
                ' AND PD.CODE = SDD.CODE ' +
                ' AND PD.PROGRESSSTATUS IN (' + QuotedStr('0') + ',' + QuotedStr('1') + ',' + QuotedStr('2') + ',' +
                                                QuotedStr('3') + ',' + QuotedStr('4') + ',' + QuotedStr('5') + '))' +
                ')';

  HostQry.SQL.Text := hostSqlStr;

  SqlPrint.clear;
  SqlPrint.Add(hostSqlStr);
  SqlPrint.SaveToFile(LocAppGlobals.AppDir + '\ProgressAddToSchedulesSql2.txt');

  HostQry.Connection.StartTransaction;
  HostQry.ExecSQL;
  HostQry.Connection.Commit;

  ArcQry.SQL.Clear;
  SqlPrint.Free;

  Application.ProcessMessages;
end;

//------------------------------------------------------------------------------------------------//

function BuildProdSchedProgress(NeedToMakeMerge : boolean; handledWorkCentersSql : string; productionDemandCounters : TList; IsBackgroundThread: boolean = false) : TList;
var
  HostQry : TMqmQuery;
  DateDwlLastProgress : TDateTime;
  GrpProdSchedList : TList;
  ArcQry : TMqmQuery;
  I : Integer;
  srvSqlStr, hostSqlStr, CompanyInUsed, tblEntityName : string;
  DndArchiveArcName : TDndArchiveName;
  OwnedHostConn, OwnedArcConn : TFDConnection;
  OwnedArcTrans : TFDTransaction;
begin
  OwnedHostConn := nil;
  OwnedArcConn  := nil;
  OwnedArcTrans := nil;
  if not IsBackgroundThread then
    UpdateOperation(_('Downloading data for PROGRESS'));
  HostQry := ThreadCreateQueryHost;
  ArcQry  := ThreadCreateQueryArc;
  if IsBackgroundThread then
  begin
    OwnedHostConn      := ThreadCloneHostConnection;
    OwnedArcConn       := ThreadCloneArcConnection;
    HostQry.Connection := OwnedHostConn;
    ArcQry.Connection  := OwnedArcConn;
  end;
  DndArchiveArcName := GetDndArchiveLocalName;

  if DndArchiveArcName = TD_Interbase then
    tblEntityName := 'NOW_DOWNLOAD_ENTITY_NAME'
  else
    tblEntityName  := 'SCDA_' + 'NOW_DOWNLOAD_ENTITY_NAME';

  srvSqlStr  := 'SELECT ND_DATE '+
               'FROM ' + tblEntityName +
               ' WHERE ND_ENTITY_NAME = ' + QuotedStr('PROGRESS') + AND_IDF_Condition('ND_IDENTIFIER');
  ArcQry.SQL.Text := srvSqlStr;
  ArcQry.Active := true;
  if not ArcQry.eof then
    DateDwlLastProgress := ArcQry.FieldByName('ND_DATE').AsDateTime
  else
    DateDwlLastProgress := now - 365*10;

  if not GetCompanyLevelHandlingByEntityName('PRODUCTIONPROGRESS',  CompanyInUsed) then
     CompanyInUsed := IniAppGlobals.CompanyCode;

  GrpProdSchedList := TList.create;
  LoadProdSchedGroups(GrpProdSchedList);
  Result := Prepare_Prod_Sched_Progress(HostQry, ArcQry, NeedToMakeMerge, handledWorkCentersSql, productionDemandCounters, GrpProdSchedList);

  if IsBackgroundThread then
  begin
    OwnedArcTrans := TFDTransaction.Create(nil);
    OwnedArcTrans.Connection := OwnedArcConn;
    ArcQry.Transaction := OwnedArcTrans;
  end
  else
    ArcQry.Transaction := ThreadCreateTransaction(Arc_DB);
  ArcQry.Transaction.StartTransaction;
  srvSqlStr := 'DELETE FROM ' + tblEntityName + ' WHERE ND_ENTITY_NAME  = ' + QuotedStr('PROGRESS') + AND_IDF_Condition('ND_IDENTIFIER');
  ArcQry.SQL.Text := srvSqlStr;
  ArcQry.ExecSQL;

  if DndArchiveArcName = TD_Db2 then
  begin
    srvSqlStr := 'INSERT INTO ' + tblEntityName + ' ("ND_IDENTIFIER", "ND_ENTITY_NAME", "ND_DATE") VALUES (' +
                  IniAppGlobals.Identifier + ', ' +
                  QuotedStr('PROGRESS') + ', ' +
                  ConvertDateFormatTo(now , TD_Db2) + ')';
  end
  else if DndArchiveArcName = TD_Oracle then
  begin
    srvSqlStr := 'INSERT INTO ' + tblEntityName + ' ("ND_IDENTIFIER", "ND_ENTITY_NAME", "ND_DATE") VALUES (' +
                  IniAppGlobals.Identifier + ', ' +
                  QuotedStr('PROGRESS') + ', ' +
                  ConvertDateFormatTo(now , TD_Oracle) + ')';
  end;

  ArcQry.SQL.Text := srvSqlStr;
  ArcQry.ExecSQL;
  ArcQry.Transaction.Commit;

  hostSqlStr := '';
  hostSqlStr := 'update SchedulesDownloadProgress set EverDownloaded = ' + QuotedStr('1') +
                ' where ENVIRONMENTCODE = ' + QuotedStr(IniAppGlobals.EnvironmentCode) + ' AND ' +
                'COMPANYCODE = ' + QuotedStr(CompanyInUsed);

  HostQry.SQL.Text := hostSqlStr;
  HostQry.ExecSQL;

  for I := 0 to GrpProdSchedList.Count -1 do
  begin
    PTPROD_SCHE_GRP(GrpProdSchedList[I]).GroupListStr.Free;
    dispose(PTPROD_SCHE_GRP(GrpProdSchedList[I]));
  end;
  GrpProdSchedList.Free;

  ArcQry.Free;
 // srvTrs.Free;
  HostQry.Free;
  OwnedArcTrans.Free;
  OwnedArcConn.Free;
  OwnedHostConn.Free;
end;

//------------------------------------------------------------------------------------------------//

procedure CreateProgressTable(HostQry : TMqmQuery);
var
  hostSqlStr : string;
  COMPANYCODE, PROGRESSNUMBER, PROGRESSTEMPLATECODE : string;
  ConvertDateFormat : Integer;
  Table : string;
  DndArchiveArcName : TDndArchiveName;
begin
  DndArchiveArcName := GetDndArchiveHostName;

  if DndArchiveArcName = TD_Db2 then
    ConvertDateFormat := 1
  else if DndArchiveArcName = TD_Oracle then
    ConvertDateFormat := 2
  else if DndArchiveArcName = TD_Db2OnAs400 then
    ConvertDateFormat := 3
  else
    ConvertDateFormat := 1;

  // ConvertDateFormat = 3 is as400 on db2

  COMPANYCODE := '';
  PROGRESSNUMBER := '';
  PROGRESSTEMPLATECODE := '';

  if IniAppGlobals.EnvironmentCode = '' then
     IniAppGlobals.EnvironmentCode := '   ';

  Table := 'SCHEDULESDOWNLOADPROGRESS';
//  if not CreateTableOnly then

  hostSqlStr := '';

//  srvQryFD := CreateQuery(Main_DB);
{  srvSqlStr := 'SELECT ND_DATE '+
               'FROM NOW_DOWNLOAD_ENTITY_NAME ' +
               'WHERE ND_ENTITY_NAME = ' + QuotedStr('PROGRESS');
  srvQryFD.SQL.Text := srvSqlStr;
  srvQryFD.Active := true;
  if not srvQryFD.eof then
    DateDwlLastProgress := srvQryFD.FieldByName('ND_DATE').AsDateTime
  else
    DateDwlLastProgress := now - 365*10;     }

  // Step 2 - Create tables on host

  if ConvertDateFormat = 1 then
    HostSqlStr := ' SELECT tabname FROM SYSCAT.TABLES WHERE tabname in (' + QuotedStr(Table) + ')'
  else if ConvertDateFormat = 2 then
    HostSqlStr := ' SELECT Table_name FROM USER_TABLES where Table_name in (' + QuotedStr(Table) + ')'
  else if ConvertDateFormat = 3 then
    HostSqlStr := ' SELECT Table_name FROM SYSCOLUMNS where Table_name in (' + QuotedStr(Table) + ')';


  HostQry.SQL.Text := hostSqlStr;
  HostQry.Connection.StartTransaction;
  HostQry.Open;
  HostQry.Connection.Commit;

  {
  add also support in Oracle from the doc
  }

 { try
    hostSqlStr := 'DROP TABLE ' + Table;
    HostQry.SQL.Text := hostSqlStr;
    HostQry.ExecSQL
  except
  end; }

  if HostQry.Eof then
  begin
    Application.ProcessMessages;
    if (ConvertDateFormat = 1) then
      hostSqlStr := ' select COLNAME, TYPENAME, LENGTH, SCALE from syscat.columns ' +
                   ' where tabname = ' + QuotedStr('PRODUCTIONPROGRESS') + ' AND colname = ' + QuotedStr('COMPANYCODE')
    else if (ConvertDateFormat = 2) then
      hostSqlStr := ' SELECT column_name as colname, data_type as typename, data_length as length, data_scale as scale from USER_TAB_COLUMNS ' +
                    ' where table_name = ' + QuotedStr('PRODUCTIONPROGRESS') + ' AND column_name = ' + QuotedStr('COMPANYCODE')
    else if (ConvertDateFormat = 3) then
      hostSqlStr := ' SELECT column_name as colname, data_type as typename, length, NUMERIC_SCALE as scale from SYSCOLUMNS ' +
                    ' where table_name = ' + QuotedStr('PRODUCTIONPROGRESS') + ' AND column_name = ' + QuotedStr('COMPANYCODE');

    HostQry.SQL.Text := hostSqlStr;
    HostQry.Connection.StartTransaction;
    HostQry.Open;
    COMPANYCODE := HostQry.FieldByName('COLNAME').AsString + ' ' + HostQry.FieldByName('TYPENAME').AsString + ' (' + IntToStr(HostQry.FieldByName('LENGTH').AsInteger) + ') NOT NULL ,' ;
    HostQry.Connection.Commit;

    if (ConvertDateFormat = 1) then
      hostSqlStr := ' select COLNAME, TYPENAME, LENGTH, SCALE from syscat.columns ' +
                    ' where tabname = ' + QuotedStr('PRODUCTIONPROGRESS') + ' AND colname = ' + QuotedStr('PROGRESSNUMBER')
    else if (ConvertDateFormat = 2) then
      hostSqlStr := ' SELECT column_name as colname, data_type as typename, data_length as length, data_scale as scale from USER_TAB_COLUMNS ' +
                    ' where table_name = ' + QuotedStr('PRODUCTIONPROGRESS') + ' AND column_name = ' + QuotedStr('PROGRESSNUMBER')
    else if (ConvertDateFormat = 3) then
      hostSqlStr := ' SELECT column_name as colname, data_type as typename, length, NUMERIC_SCALE as scale from SYSCOLUMNS ' +
                    ' where table_name = ' + QuotedStr('PRODUCTIONPROGRESS') + ' AND column_name = ' + QuotedStr('PROGRESSNUMBER');

    HostQry.SQL.Text := hostSqlStr;
    HostQry.Connection.StartTransaction;
    HostQry.Open;
    PROGRESSNUMBER := HostQry.FieldByName('COLNAME').AsString + ' ' + HostQry.FieldByName('TYPENAME').AsString + ' (' + IntToStr(HostQry.FieldByName('LENGTH').AsInteger) + ') NOT NULL ,' ;
    HostQry.Connection.Commit;

    if (ConvertDateFormat = 1) then
      hostSqlStr := ' select COLNAME, TYPENAME, LENGTH, SCALE from syscat.columns ' +
                    ' where tabname = ' + QuotedStr('PRODUCTIONPROGRESS') + ' AND colname = ' + QuotedStr('PROGRESSTEMPLATECODE')
    else if (ConvertDateFormat = 2) then
      hostSqlStr := ' SELECT column_name as colname, data_type as typename, data_length as length, data_scale as scale from USER_TAB_COLUMNS ' +
                    ' where table_name = ' + QuotedStr('PRODUCTIONPROGRESS') + ' AND column_name = ' + QuotedStr('PROGRESSTEMPLATECODE')
    else if (ConvertDateFormat = 3) then
      hostSqlStr := ' SELECT column_name as colname, data_type as typename, length, NUMERIC_SCALE as scale from SYSCOLUMNS ' +
                    ' where table_name = ' + QuotedStr('PRODUCTIONPROGRESS') + ' AND column_name = ' + QuotedStr('PROGRESSTEMPLATECODE');

    HostQry.SQL.Text := hostSqlStr;
    HostQry.Connection.StartTransaction;
    HostQry.Open;
    Application.ProcessMessages;
    PROGRESSTEMPLATECODE := HostQry.FieldByName('COLNAME').AsString + ' ' + HostQry.FieldByName('TYPENAME').AsString + ' (' + IntToStr(HostQry.FieldByName('LENGTH').AsInteger) + ') NOT NULL ,' ;
    HostQry.Connection.Commit;

    hostSqlStr := '';
    hostSqlStr := 'CREATE TABLE ' + Table + '(';
    hostSqlStr := hostSqlStr + ' ' + COMPANYCODE;
    hostSqlStr := hostSqlStr + 'ENVIRONMENTCODE CHARACTER (3) NOT NULL,';
    hostSqlStr := hostSqlStr + ' ' + PROGRESSNUMBER;
    hostSqlStr := hostSqlStr + ' ' + PROGRESSTEMPLATECODE;
    hostSqlStr := hostSqlStr + 'ORIGINALENDDATE DATE , ';
    hostSqlStr := hostSqlStr + 'EVERDOWNLOADED SMALLINT NOT NULL ,';
    hostSqlStr := hostSqlStr + 'PRIMARY KEY (ENVIRONMENTCODE, COMPANYCODE, PROGRESSNUMBER))';
    HostQry.SQL.Text := hostSqlStr;
    try
      HostQry.Connection.StartTransaction;
      HostQry.ExecSQL;
      HostQry.Connection.Commit;
      Application.ProcessMessages;
    except
      HostQry.Connection.Rollback;
    end;
  end;

end;

initialization
  m_TemplateFINALANDSPLIT := TStringList.Create;
  m_TemplateQUANTITYTYPE  := TStringList.Create;
finalization
  m_TemplateFINALANDSPLIT.Free;
  m_TemplateQUANTITYTYPE.Free
end.
